#!/bin/bash
# Expecting it to run from api folder

# Define the paths
docs_folder="docs"
target_branch="api-github-pages"

mkdir $docs_folder
doxygen Doxyfile

# Check if we're on the main branch
current_branch=$(git symbolic-ref --short HEAD)
if [[ "$current_branch" != "main" ]]; then
  echo "You are not on the 'main' branch. Please switch to 'main' branch first."
  exit 1
fi

# Step 1: Get the list of directories in the docs folder using `find`
folders_in_docs=$(find $docs_folder -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)

# Step 2: Checkout to the target branch (api-github-pages)
git checkout $target_branch

# Step 3: Delete corresponding folders in the target branch if they exist
for folder in $folders_in_docs; do
  if [ -d "$folder" ]; then
    echo "Deleting folder $folder in the target branch..."
    git rm -rf "$folder"
  fi
done

# Step 4: Checkout the contents of the docs folder from the main branch
git checkout main -- $docs_folder/

# Step 5: Move all contents of docs to the root of the current branch
mv $docs_folder/* .

# Step 6: Remove the empty docs folder
rmdir $docs_folder

# Step 7: Add, commit, and push changes to the api-github-pages branch
git add .
git commit -m "Move contents of docs folder to root for GitHub Pages"
git push origin $target_branch

# Step 8: Checkout back to the main branch
git checkout main

echo "Contents of the docs folder have been moved to the root of the $target_branch branch, and you are now back on the main branch."
