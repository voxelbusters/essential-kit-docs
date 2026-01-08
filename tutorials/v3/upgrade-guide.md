# Upgrade Guide

On every update, make sure you follow the below steps to avoid any issues.

1. Delete Assets/Plugins/VoxelBusters/EssentialKit and CoreLibrary folders.
2. Delete Assets/ExternalDependencyManager folder (If we updated to latest version)
3. Import the new update



### Version Specific

| Upgrading to Version | Recomendations                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **3.7.0**            | <p>When making XCode builds, <strong>Replace</strong> rather <strong>than</strong> <strong>Append</strong> for the <strong>first</strong> <strong>time</strong> - As we removed completely .xcframewok files and included the source code(swift files) for easy debugging.<br><br>Also, as Declared Age Api's are used, please make sure <strong>you are on latest xcode version</strong>(as of now <strong>26.2</strong>) which has 26.2 iOS SDK.</p> |
| **3.5.0**            | When making XCode builds, **Replace** rather **than** **Append** for the **first** **time** - As we removed including sub xcode projects and started shipping XCFrameworks with dSYM files for better compatibility with ios build plugins on Windows.                                                                                                                                                                                                 |
|                      |                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
