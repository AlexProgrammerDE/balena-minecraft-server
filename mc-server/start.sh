#!/usr/bin/env bash

# Wait for working internet access here
wget --quiet --spider https://papermc.io 2>&1
if [ $? -eq 1 ]; then
  echo "No internet access - exiting"
  sleep 10
  exit 1
fi

if [[ -z "$DEVICE_HOSTNAME" ]]; then
  DEVICE_HOSTNAME=balenaminecraftserver
fi

if [[ -z "$JAR_FILE" ]]; then
  JAR_FILE="server.jar"
fi

if [[ -z "$RAM" ]]; then
  RAM="1G"
fi


printf "%s\n" "Setting device hostname to: $DEVICE_HOSTNAME"

curl -s -X PATCH --header "Content-Type:application/json" \
    --data '{"network": {"hostname": "'"${DEVICE_HOSTNAME}"'"}}' \
    "$BALENA_SUPERVISOR_ADDRESS/v1/device/host-config?apikey=$BALENA_SUPERVISOR_API_KEY" > /dev/null

# Download a server JAR if we don't already have a valid one
# And copy the server files into the directory on first run
printf "\n\n%s\n\n" "Starting balenaMinecraftServer..."

if [[ ! -e "/servercache/copied.txt" ]]; then
  printf "%s\n" "Copying config"
  # Copy the serverfiles to the volume
  cp -R /serverfiles /usr/src/
  # Mark this is done and store the SHA256 we're using
  touch /servercache/copied.txt
else
  printf "%s\n" "Config already copied"
fi

cd /usr/src/serverfiles/

printf "%s" "Checking server JAR... "
# Check to see if we have a server jar, and if we do, is it valid?
if [[ ! -e $JAR_FILE ]]; then
  printf "%s\n" "No server JAR found. Downloading from official website"
  wget -O server.jar -T 15 -c https://launcher.mojang.com/v1/objects/0a269b5f2c5b93b1712d0f5dc43b6182b9ab254e/server.jar
  JAR_FILE="server.jar"
  printf "%s\n" "Download complete"
fi


if [[ ! -z "$ENABLE_CONFIG_UPDATE" ]]; then
  # Copy the serverfiles to the volume
  printf "%s\n" "Forcing config copy"
  cp -R /serverfiles /usr/src/
fi

# Make sure you are in the file volume
cd /usr/src/serverfiles/

# Do that forever
printf "%s\n" "Starting JAR file with: $RAM of RAM"
/opt/jdk-16.0.1/bin/java -Xms$RAM -Xmx$RAM -jar $JAR_FILE

# Don´t overload the server if the start fails 
sleep 10