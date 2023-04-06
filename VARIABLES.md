# Variables

The available built in variables for this project.

## mc-server

| Name                 | Default               | Description                                                                                                                                                            |
|----------------------|-----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| RAM                  | 1G                    | The allocated RAM to the Minecraft Server on startup. This can not be as much RAM as the device has. Always keep one gigabyte of RAM or more for the operating system! |
| DEVICE_HOSTNAME      | balenaminecraftserver | Hostname for the device in the local network the server is in                                                                                                          |
| JAR_FILE             | paper.jar             | Name of the file to be executed in the startup command                                                                                                                 |
| FLAGS                |                     | Add custom startup flags to the startup command                                                                                                                        |
| AIKAR_FLAGS          | false                 | Add Aikar startup flags to the startup command                                                                                                                         |
| ZGC_FLAGS            | false                 | Add ZGC startup flags to the startup command                                                                                                                           |
| ENABLE_UPDATE        | false                 | Forces a server jar update                                                                                                                                             |
| ENABLE_CONFIG_UPDATE | false                 | Forces a server config update                                                                                                                                          |
| CUSTOM_COMMAND       |                       | Overwrites java start command with custom shell command                                                                                                                                  |

## scp-server

| Name         | Default | Description                                     |
|--------------|---------|-------------------------------------------------|
| SCP_PASSWORD | balena  | SCP password for connecting to the file system. |
