![Balena Server Logo](images/logo.png)

# Minecraft Server
**Starter project enabling you a Minecraft Server using just a Raspberry Pi 4 or Jetson Nano.**

This project has been tested on a Raspberry Pi 4 B 4GB & Nvidia Jetson Nano. I do not recommend using a Raspberry Pi 3 or older. They do not have enough RAM and power to calculate all the things. :boom:

## Why balenaMinecraftServer?

* It works out of the box, just start it, and it just works. :+1:
* You can play anywhere. You can take the Pi to a friend, connect to his Wi-Fi and enjoy playing. :video_game:
* It is free. No costs, no big server and no complication. :free:
* Why host on a computer? A Pi is power efficient! :rocket:
* You can easy maintain the files on the Pi by using your PC. :computer:

## Hardware required

* Raspberry Pi 4B (We recommend the 4GB or the 8GB model. 1GB is not enough!) or Nvidia Jetson Nano
* A fan or cooling system to prevent lag caused by throttling
* A 16GB or greater micro SD Card (We always recommend SanDisk Extreme Pro SD cards)
* Power supply

## Software required

* A download of this project (of course)
* Software to flash an SD card ([balenaEtcher](https://balena.io/etcher))
* A free [balenaCloud](https://balena.io/cloud) account
* The [balena CLI tools](https://github.com/balena-io/balena-cli/blob/master/INSTALL.md)

## Setup and use :stars:

To run this project is as simple as deploying it to a balenaCloud application; no additional configuration is required.

### Setup the device :cd:

* Sign up for or login to the [balenaCloud dashboard](https://dashboard.balena-cloud.com)
* Create an application, selecting the correct device type for your Raspberry Pi
* Add a device to the application, enabling you to download the OS
* Flash the downloaded OS to your SD card with [balenaEtcher](https://balena.io/etcher)
* Power up the board and check it's online in the dashboard

### One Click Deployment

You can deploy this server with one click with the button below. Or, you can follow the manual deployment instructions in the next section.

[![](https://balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/AlexProgrammerDE/balena-minecraft-server)

### Manually Deploy this application :airplane:

* Install the [balena CLI tools](https://github.com/balena-io/balena-cli/blob/master/INSTALL.md)
* Login with `balena login`
* Download this project and from the project directory run `balena push <appName>` where `<appName>` is the name you gave your balenaCloud application in the first step.

## Connect to the server :satellite:

Balena Minecraft Server sets automatically your Server hostname to `balenaminecraftserver.local`. It is the address the from your server. You can connect to it like this:

**Note:** The IP address also works.

![Server-IP](images/Server-IP.png)

Now you have a balenaServer :sunglasses::

**NOTE:** This works only in the connected Wifi. If you want to play worldwide click here: https://github.com/AlexProgrammerDE/balena-server/blob/master/README.md#play-worldwide-optional-earth_americas

![Minecraft Screenshot](images/minecraft-screenshot.png)

## Connect to the terminal :satellite:

The server has no console input option in the cloud dashboard, so you need `RCON`. The port is `25575` and the password is `balena`. It is a protocol for connecting to the server.
There are many clients, but you can pick one here:

* mcrcon: https://github.com/Tiiffi/mcrcon/releases (NOTE: You will need for starting this script this batch file if you are using windows (Just paste it in the unzipped directory.): https://github.com/AlexProgrammerDE/RCON-Script/blob/master/launch.bat)

* Minecraft Server RCON: https://alexprogrammerde.github.io/Minecraft-Server-RCON.rar

## Connect to the file-directory :satellite:

You can connect to the server and change your serverfiles. I recommend using a tool like [WinSCP](https://winscp.net/) or if you are using OSX or a linux distribution you can use [Filezilla](https://filezilla-project.org/).  The IP Address to connect to is “balenaminecraftserver” (without the quotes), the protocol to choose is SCP (If you got the choice), the port number is 22, the username is “root” (again, without the quotes) and the password is “balena” (no quotes). The files are in the folder named “serverfiles” at the root directory, you can double click to open that directory and browse the files in there.

**NOTE:** You can also change your SCP password by setting the `SCP_PASSWORD` Environment Variable within balenaCloud.  On the left, simply click on “Device Variables” and then click the “Add Variable” button. Give it a name of `SCP_PASSWORD`, and set the value to your password. 

## Connect to another Wifi :satellite:

balenaMinecraftServer has wifi-connect integrated. You can use it for taking the Pi everywhere. If you want to read more is here the link to the programm: https://github.com/balena-io/wifi-connect (There is explained how it works.) 

## Change hostname
You can change the hostname by defining the DEVICE_HOSTNAME Environment Variable within balenaCloud.

**NOTE:** If you decide to change the hostname, you will have to use your new hostname within Minecraft to connect to the server, instead of `balenaminecraftserver.local`.

## Custom RAM (optional) :link:

Devices like the Raspberry Pi 4B 4GB or the 8GB model have enough RAM to run the server with more RAM (the default value used by balena Minecraft server is 1GB). If you set `RAM` to a value like `2G`, `4G`, or `6G` it will have the specified amount of RAM available.

## Add plugins (optional) :wrench:

balenaMinecraftServer also supports plugins. Just drop the in the plugins folder using [`SCP`](https://github.com/AlexProgrammerDE/balena-minecraft-server#connect-to-the-file-directory-satellite). The current Minecraft version is `1.16`. You can get your plugins from there(Other work too.): 

* Spigot resources: https://www.spigotmc.org/resources/categories/spigot.4/
* Bukkit: https://dev.bukkit.org/bukkit-plugins

**NOTE:** Before adding the plugin and getting an error look if the plugin supports `1.16`.

## Play worldwide (optional) :earth_americas:

Once you’ve perfected the setup of your server on your local network, you might be interested in unveiling your server to the rest of the world! Here’s how you can enable remote access and allow players to connect via the Internet.

![NO-IP Picture](images/NO-IP.png)

If you’d like to allow friends outside your local network to join your server, you’ll need to set up dynamic DNS (DDNS) to expose your Pi to the outside world. This example uses a service called No-IP, which has a free tier for people who want to try DDNS out, though other options and methods do exist as well. In the case of this example, you will need to: 

* Create an account with [No-IP](https://www.noip.com/sign-up) by visiting their website.
* After creating the account and logging in, create a Hostname (example: balena.serverminecraft.net) by [following their documentation](https://www.noip.com/support/knowledgebase/getting-started-with-no-ip-com/).
* Set up Port Forwarding: You will need to route your Minecraft traffic to port 25565 on your Pi. To do this, you will log in to your home router and setup Port Forwarding. This step varies by particular brand of modem or router, but the No-IP documentation does a good job of describing the process [here](https://www.noip.com/support/knowledgebase/general-port-forwarding-guide/). You may need to follow instructions specific to your modem or router if the No-IP documentation does not contain your particular type.
* Optional: You can log in to No-IP with your router to keep the IP Address current in case it changes. That allows the router to connect automatically to No-IP. Here is a [guide by No-IP](https://www.noip.com/support/knowledgebase/how-to-configure-ddns-in-router/) on how to accomplish this.
* Paste your public / external internet address in the box labeled IP Address into the No-IP dashboard. You're done. 👍

For a deeper look at setting up remote access, please [reference this guide](https://www.noip.com/support/knowledgebase/getting-started-with-no-ip-com/) (Note: You can skip the DUC part).

## Custom Server (optional) :eyeglasses:

If you want to customize your server even further, but don't know where to start, take a look at some server software listed here:

* Spigot (Vanilla Java Edition): https://getbukkit.org/download/spigot
* Purpur (Vanilla Java Edition, very well optimized for 1.16.3) https://purpur.pl3x.net/
* Vanilla from Minecraft (Vanilla Java Edition): https://getbukkit.org/download/vanilla
* Paper (Vanilla Java Edition): https://papermc.io/downloads
* Forge (Modded Java Edition): http://files.minecraftforge.net/
* ccSpigot (Vanilla Java Edition, Fork and continuation of Paper 1.12.2): https://github.com/moom0o/ccSpigot

Note: Balena Minecraft Server uses Paper. It is an efficient and powerful server. It is compatible with spigot and bukkit plugins.

If you want to use a different Minecraft Sever .jar, add a variable called `JAR_FILE`. The value should be the same as your custom .jar file that you placed in the serverfiles directory using SCP.

I encourage you to take your server build even further! There are many tutorials out there on server customization-- this README only touches on a few ideas. If you need help, please reach out by submitting an [issue on GitHub](https://github.com/AlexProgrammerDE/balena-minecraft-server/issues).

## 🌈 Community

Feel free to join our Discord community server:

[![Discord Banner](https://discord.com/api/guilds/739784741124833301/widget.png?style=banner2)](https://discord.gg/CDrcxzH)

This project is in active development, so if you have any feature requests or issues please submit them here on GitHub. PRs are welcome, too. :octocat:

Here is a little server demo :crown::

![Server Demo](images/server-demo.gif)
