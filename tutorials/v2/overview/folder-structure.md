# Folder Structure

All Voxel Busters Plugins will be inside Assets/Plugins/VoxelBusters folder. EssentialKit folder contains the plugin files related to this plugin.

Plugin comes with [**External Dependency Manager**](https://github.com/googlesamples/unity-jar-resolver) which is a plugin maintained by Google. This plugin minimises the conflicts with external plugins. As of now we use this for resolving android libraries.

| Folder                                   | Description                                                                                                                                       |
| ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| Assets/External Dependency Manager       | Folder where [**External Dependency Manager**](https://github.com/googlesamples/unity-jar-resolver) plugin exists.                                |
| Assets/Plugins/VoxelBusters              | Root folder for all Voxel Busters plugins                                                                                                         |
| Assets/Plugins/VoxelBusters/EssentialKit | Essential Kit plugin main folder                                                                                                                  |
| Assets/Resources                         | Folder where the [Essential Kit Settings](settings.md#essential-kit-settings) are stored. Make sure you don't delete this folder while upgrading. |

{% hint style="success" %}
When you are trying to upgrade the plugin, make sure your Essential Kit Settings asset under **Assets/Resources** is committed to version control or have a backup.
{% endhint %}

{% hint style="success" %}
All modules within the plugin uses assembly definition files(.asmdef). So these won't affect any of your project compilation times!
{% endhint %}
