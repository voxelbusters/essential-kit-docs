

# Project using doxygen-awesome-css theme


# For markdown conversion use below commmand (install moxygen)
moxygen -c --groups --anchors -H --output ./markdown/%s.md ./xml/


## For Versioning
Change the html(or xml) output folder name (expert-html) in doxygen settings to docs/v2 or docs/v3 or docs/v4 ..


## Deploying
Using github pages for hosting the docs html. So shift to 
api branch in https://github.com/voxelbusters/essential-kit 
and push the files to the api branch.

