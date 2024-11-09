# Essential Kit Docs

### Branches
* main - Api reference(via Doxygen - /api), Tutorials(synced via GitBook - /tutorials), Resources (common media files) 
* api-github-pages -> Branch specially used for pushing api reference docs


### API Docs update Workflow
* push-api-docs.sh script is used for pushing the latest docs to api-github-pages branch by building with doxygen
    The script does the following
        * Builds the docs with doxygen
        * Commits & pushes the api/docs files to **master**
        * Shifts branch to api-github-pages
        * Copies api/docs folder and resources folder from master branch
        * Commits & pushes to **api-github-pages**
        * Swithces the branch back to **master**
