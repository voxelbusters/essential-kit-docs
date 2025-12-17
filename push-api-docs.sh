#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
docs_repo_root="$script_dir"

usage() {
  cat <<'EOF'
Usage: bash push-api-docs.sh

Publishes updated API docs to the `api-github-pages` branch (GitHub Pages) and syncs PlayMaker docs into `tutorials/v3`.

Runs in the `Docs` repo:
  1) Sync PlayMaker docs -> tutorials/v3/features/**/playmaker
  2) Run Doxygen -> api/docs
  3) Commit+push to origin/master (if changed)
  4) Copy api/docs/* to api-github-pages branch root and push (if changed)
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

step() {
  echo
  echo "==> $*"
}

git_docs() {
  git -C "$docs_repo_root" "$@"
}

# Branches (Docs repo)
master_branch="master"
target_branch="api-github-pages"

# Folders (relative to Docs repo root)
api_folder="api"
docs_folder_from_root="api/docs"

target_folder="."

sync_playmaker_script="$docs_repo_root/sync-playmaker-docs.sh"

if [[ ! -f "$sync_playmaker_script" ]]; then
  echo "ERROR: Missing sync script: $sync_playmaker_script" >&2
  exit 1
fi

if ! command -v doxygen >/dev/null 2>&1; then
  echo "ERROR: doxygen is required but was not found on PATH." >&2
  exit 1
fi

# Ensure we're on the expected branch in the Docs repo (not the monorepo root).
current_branch="$(git_docs symbolic-ref --short HEAD)"
if [[ "$current_branch" != "$master_branch" ]]; then
  echo "You are not on the $master_branch branch (Docs repo). Please switch to $master_branch first." >&2
  exit 1
fi

step "Syncing PlayMaker docs into Docs/tutorials/v3"
bash "$sync_playmaker_script"

step "Building API docs with Doxygen"
rm -rf "$docs_repo_root/$docs_folder_from_root"
mkdir -p "$docs_repo_root/$docs_folder_from_root"
(cd "$docs_repo_root/$api_folder" && doxygen Doxyfile)

step "Committing and pushing updates to $master_branch (if changed)"
git_docs add "$docs_folder_from_root" "tutorials/v3"
if git_docs diff --cached --quiet; then
  echo "No changes to commit on $master_branch."
else
  git_docs commit -m "chore: update API docs + sync PlayMaker tutorials"
  git_docs push origin "$master_branch"
fi

step "Publishing API docs to $target_branch"
git_docs checkout "$target_branch"

temp_folder="$(mktemp -d)"
cleanup() {
  rm -rf "$temp_folder"
}
trap cleanup EXIT

git -C "$docs_repo_root" --work-tree="$temp_folder" checkout "$master_branch" -- "$docs_folder_from_root/"

# Loop through subfolders of api/docs and mirror them to the branch root.
find "$temp_folder/$docs_folder_from_root" -mindepth 1 -maxdepth 1 -type d | while read -r sub_folder; do
  sub_folder_name="$(basename "$sub_folder")"
  target_sub_folder="$docs_repo_root/$target_folder/$sub_folder_name"

  if [[ -d "$target_sub_folder" ]]; then
    rm -rf "$target_sub_folder"
  else
    mkdir -p "$target_sub_folder"
  fi

  cp -r "$sub_folder/." "$target_sub_folder"
done

git_docs add "$target_folder"
if git_docs diff --cached --quiet; then
  echo "No changes to commit on $target_branch."
else
  git_docs commit -m "chore: update GitHub Pages API docs"
  git_docs push origin "$target_branch"
fi

git_docs checkout "$master_branch"
step "Done (back on $master_branch)"
