#!/bin/bash
# Expecting it to run from api folder

# Define the paths

# Branches
master_branch="master"
target_branch="api-github-pages"

# Folders
api_folder="api"
docs_folder="docs"
docs_folder_from_root="api/docs"

temp_folder="temp"
target_folder="."



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

echo "Copying contents of $docs_folder_from_root from $master_branch to $temp_folder"
mkdir $temp_folder
echo "Copying contants of $docs_folder_from_root to $temp_folder"
git --work-tree=./$temp_folder checkout $master_branch -- $docs_folder_from_root/
#git checkout $master_branch -- $resources_folder/ - No need to copy this as it will be copied now within doxygen (as we referred the images folder and moved overview.md to root)

# Loop through all sub_folderes of $docs_folder_from_root, delete only if they exist in destination
find "$temp_folder/$docs_folder_from_root" -mindepth 1 -maxdepth 1 -type d | while read -r sub_folder; do
  sub_folder_name=$(basename "$sub_folder")
  target_sub_folder="$target_folder/$sub_folder_name"
  echo "Source sub folder : $sub_folder"
  echo "Target sub folder : $target_sub_folder"

  # Check if the sub_folder exists in the target directory
  if [ -d "$target_sub_folder" ]; then
    echo "There is a target folder $target_sub_folder, so we will delete it"
    # If it exists, delete it
    rm -rf "$target_sub_folder"
    echo "Deleted existing folder: $target_sub_folder"
  else
    echo "Creating $target_sub_folder if doesn't exist"
    mkdir -p "$target_sub_folder"  
  fi
  
  # Copy the sub_folder from source to target
  cp -r "$sub_folder/." "$target_sub_folder"
  echo "Copied folder: $sub_folder to $target_sub_folder"
done

echo "Deleting temp folder"
rm -rf $temp_folder

# Add, commit, and push changes to the api-github-pages branch
git add $target_folder
git commit -m "chore: Updating contents of latest docs for GitHub Pages"
git push origin $target_branch

# Checkout back to the master branch
git checkout $master_branch

echo "Contents of the docs folder have been moved to the root of the $target_branch branch, and you are now back on the main branch."
