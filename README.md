# Essential Kit Docs

## Branches

- `master`: Source for API docs (`api/`), tutorials (`tutorials/`), and shared resources (`resources/`).
- `api-github-pages`: Published API documentation served via GitHub Pages.

## Updating API Docs + Tutorials

Run: `bash push-api-docs.sh`

### What `push-api-docs.sh` does

1. **Safety checks**
   - Requires the `Docs` repo to be on `master`.
2. **Sync PlayMaker docs into tutorials**
   - Source: `../UnityProject/Assets/Plugins/VoxelBusters/EssentialKit/ThirdPartySupport/PlayMaker/Scripts/Actions/<Feature>/Docs/`
   - Destination: `tutorials/v3/features/<feature>/playmaker/`
3. **Regenerate API docs**
   - Deletes/recreates `api/docs`
   - Runs `doxygen` using `api/Doxyfile` (output under `api/docs`)
4. **Commit + push to `origin master` (only if changed)**
   - `api/docs`
   - `tutorials/v3`
5. **Publish to GitHub Pages**
   - Checks out `api-github-pages`
   - Copies `api/docs/*` from `master` into the branch root
   - Commits + pushes to `origin api-github-pages` (only if changed)
6. **Cleanup**
   - Switches back to `master`
