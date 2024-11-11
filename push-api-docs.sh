#!/bin/bash
# Expecting it to run from api folder

# Define the paths
api_folder="api"
docs_folder="docs"
docs_folder_from_root="api/docs"
target_branch="api-github-pages"
resources_folder="resources"
master_branch="master"

# Check if we're on the main branch
current_branch=$(git symbolic-ref --short HEAD)
if [[ "$current_branch" != $master_branch ]]; then
  echo "You are not on the $master_branch branch. Please switch to $master_branch branch first."
  exit 1
fi


cd $api_folder
mkdir $docs_folder
doxygen Doxyfile
cd ..

git commit -m 'chore: updated docs' -- $docs_folder_from_root/
git push origin $master_branch

git checkout $target_branch

# Step 1: Checkout the contents of the docs folder from the main branch
git checkout $master_branch -- $docs_folder_from_root/
#git checkout $master_branch -- $resources_folder/ - No need to copy this as it will be copied now within doxygen (as we referred the images folder and moved overview.md to root)

# Step 7: Add, commit, and push changes to the api-github-pages branch
git add $api_folder
git add $resources_folder
git commit -m "chore: Updating contents of latest docs for GitHub Pages"
git push origin $target_branch

# Step 8: Checkout back to the master branch
git checkout $master_branch

echo "Contents of the docs folder have been moved to the root of the $target_branch branch, and you are now back on the main branch."
