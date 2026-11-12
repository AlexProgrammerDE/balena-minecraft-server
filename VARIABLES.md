# Variables

The available built in variables for this project.

## mc-server

| Name                 | Default               | Description                                                                                                                                                            |
|----------------------|-----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| RAM                  | 1G                    | The allocated RAM to the Minecraft Server on startup. This can not be as much RAM as the device has. Always keep one gigabyte of RAM or more for the operating system! |
| DEVICE_HOSTNAME      | balenaminecraftserver | Hostname for the device in the local network the server is in                                                                                                          |
| JAR_FILE             | paper.jar             | Name of the file to be executed in the startup command                                                                                                                 |
| FLAGS                |                     | Add custom startup flags to the startup command                                                                                                                        |
| AIKAR_FLAGS          | false                 | Set to `true` to add Aikar startup flags to the startup command                                                                                                        |
| ZGC_FLAGS            | false                 | Set to `true` to add ZGC startup flags to the startup command                                                                                                          |
| ENABLE_UPDATE        | false                 | Set to `true` to download the newest stable Paper build on every start                                                                                                 |
| MC_VERSION           |                       | Pin a Minecraft version, for example `26.3`. Empty means the newest version that has a stable Paper build. It only applies when a jar is downloaded, so to change the version of an existing server also set `ENABLE_UPDATE=true` and restart. The image runs Java 25, so old versions such as 1.16.x don't start. Don't pin a version older than the one the world was last played on |
| ENABLE_CONFIG_UPDATE | false                 | Set to `true` to overwrite the server config with the defaults on every start                                                                                          |
| CUSTOM_COMMAND       |                       | Overwrites java start command with custom shell command                                                                                                                                  |

## scp-server

| Name         | Default | Description                                     |
|--------------|---------|-------------------------------------------------|
| SCP_PASSWORD | balena  | SCP password for connecting to the file system. |
