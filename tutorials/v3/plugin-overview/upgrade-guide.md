# Upgrade Guide

On every update, make sure you follow the below steps to avoid any issues.

1. Delete Assets/Plugins/VoxelBusters/EssentialKit and CoreLibrary folders.
2. Delete Assets/ExternalDependencyManager folder (If we updated to latest version)
3. Import the new update



### Version Specific

| Upgrading to Version | Recomendations                                                                                                                                                                                                                                         |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **3.5.0**            | When making XCode builds, **Replace** rather **than** **Append** for the **first** **time** - As we removed including sub xcode projects and started shipping XCFrameworks with dSYM files for better compatibility with ios build plugins on Windows. |
|                      |                                                                                                                                                                                                                                                        |
|                      |                                                                                                                                                                                                                                                        |
