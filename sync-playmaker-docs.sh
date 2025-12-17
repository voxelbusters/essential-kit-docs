#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
docs_repo_root="$script_dir"
monorepo_root="$(cd -- "$docs_repo_root/.." && pwd)"

playmaker_actions_root="$monorepo_root/UnityProject/Assets/Plugins/VoxelBusters/EssentialKit/ThirdPartySupport/PlayMaker/Scripts/Actions"
tutorials_features_root="$docs_repo_root/tutorials/v3/features"

if ! command -v rsync >/dev/null 2>&1; then
  echo "ERROR: rsync is required but was not found on PATH." >&2
  exit 1
fi

if [[ ! -d "$playmaker_actions_root" ]]; then
  echo "ERROR: PlayMaker Actions folder not found: $playmaker_actions_root" >&2
  exit 1
fi

if [[ ! -d "$tutorials_features_root" ]]; then
  echo "ERROR: Tutorials features folder not found: $tutorials_features_root" >&2
  exit 1
fi

declare -a mappings=(
  "AddressBook:address-book"
  "AppShortcuts:app-shortcuts"
  "AppUpdater:app-updater"
  "BillingServices:billing-services"
  "CloudServices:cloud-services"
  "DeepLinkServices:deep-link-services"
  "GameServices:game-services"
  "MediaServices:media-services"
  "NativeUI:native-ui"
  "NetworkServices:network-services"
  "NotificationServices:notification-services"
  "RateMyApp:rate-my-app"
  "SharingServices:sharing"
  "TaskServices:task-services"
  "Utilities:utilities"
  "WebView:web-view"
)

echo "Syncing PlayMaker docs into GitBook tutorials..."
echo "Source:      $playmaker_actions_root"
echo "Destination: $tutorials_features_root"
echo

for mapping in "${mappings[@]}"; do
  feature_name="${mapping%%:*}"
  feature_slug="${mapping##*:}"

  source_docs_dir="$playmaker_actions_root/$feature_name/Docs"
  dest_docs_dir="$tutorials_features_root/$feature_slug/playmaker"

  if [[ ! -d "$source_docs_dir" ]]; then
    echo "WARN: Missing source docs folder, skipping: $source_docs_dir" >&2
    continue
  fi

  mkdir -p "$dest_docs_dir"

  # Keep the destination fully in sync, but ignore Unity metadata and editor artifacts.
  rsync -a --delete \
    --exclude "*.meta" \
    --exclude ".DS_Store" \
    --exclude "Thumbs.db" \
    "$source_docs_dir/" \
    "$dest_docs_dir/"

  echo "Synced: $feature_name -> tutorials/v3/features/$feature_slug/playmaker"
done

echo
echo "Done."
