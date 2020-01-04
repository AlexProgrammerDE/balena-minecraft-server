![Balena Server Logo](images/logo.png)

# A Minecraft server for the Raspberry Pi 4 
**Starter project enabling you a Mineccaft Server using just a Raspberry Pi.**

This project has been tested on Raspberry Pi 4 B 1GB and Raspberry Pi 4 B 4GB. We do not recommend using a Raspberry Pi 3 or deeper. They have not enough RAM and power to calculate all the things.

## Hardware required

* Raspberry Pi 4B
* SD Card (we recommend 8GB Sandisk Extreme Pro)
* Power supply

## Software required

* A download of this project (of course)
* Software to flash an SD card ([balenaEtcher](https://balena.io/etcher))
* A free [balenaCloud](https://balena.io/cloud) account
* The [balena CLI tools](https://github.com/balena-io/balena-cli/blob/master/INSTALL.md)

## Setup and use

To run this project is as simple as deploying it to a balenaCloud application; no additional configuration is required.

### Setup the Raspberry Pi

* Sign up for or login to the [balenaCloud dashboard](https://dashboard.balena-cloud.com)
* Create an application, selecting the correct device type for your Raspberry Pi
* Add a device to the application, enabling you to download the OS
* Flash the downloaded OS to your SD card with [balenaEtcher](https://balena.io/etcher)
* Power up the Pi and check it's online in the dashboard

### Deploy this application

* Install the [balena CLI tools](https://github.com/balena-io/balena-cli/blob/master/INSTALL.md)
* Login with `balena login`
* Download this project and from the project directory run `balena push <appName>` where `<appName>` is the name you gave your balenaCloud application in the first step.

This project is in active development so if you have any feature requests or issues please submit them here on GitHub. PRs are welcome, too.

## Connect to the server

You can see in the Dashboard two ip-adresses. One of them is the from your server. One example:

![IP-Adress](images/IP-Adress.png)

In my case is it `192.168.178.35`. You can connect to it like that:

![Server-IP](images/Server-IP.png)

## Connect to the terminal

The server has no console input option in the cloud dashboard, so you need `RCON`. It is a protocol for connecting to the server.
There are many clients, but you can pick one here:

* mcrcon: https://github.com/Tiiffi/mcrcon/releases

**NOTE:** You will need for starting this script this batchfile if you are using windows (Just paste it in the unzipped directory.): https://github.com/AlexProgrammerDE/RCON-Script/blob/master/launch.bat

* icecon: https://github.com/icedream/icecon/releases

**Note: ** It is working,but old don´t wonder if it doesn´t work. It does work at the moment. 
