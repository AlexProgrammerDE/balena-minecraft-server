#!/usr/bin/env bash

if [[ -z "$DEVICE_HOSTNAME" ]]; then
  DEVICE_HOSTNAME=balenaminecraftserver
fi

printf "%s\n" "Setting device hostname to: $DEVICE_HOSTNAME"

curl -X PATCH --header "Content-Type:application/json" \
    --data '{"network": {"hostname": "'"${DEVICE_HOSTNAME}"'"}}' \
    "$BALENA_SUPERVISOR_ADDRESS/v1/device/host-config?apikey=$BALENA_SUPERVISOR_API_KEY"

# This var is for dev reasons
if [[ -z "$ENABLE_UPDATE" ]]; then

# Go to the cache volume
cd /servercache/

# This runs only one time
if [[ ! -a "copied.txt" ]]; then

# Copy the serverfiles to the volume
cp -R /serverfiles /usr/src/

# Get the server jar file from paper-mc
cd /usr/src/serverfiles/

if [[ -z "$(*.jar)" ]]; then
  printf "%s\n" "Downloading the server file from paper-mc."
  wget -O paper.jar https://papermc.io/ci/job/Paper-1.15/lastSuccessfulBuild/artifact/paperclip.jar
else
  printf "%s\n" "There is already an server file. It´s called: $(ls *.jar)"
fi

# This saves that this is done
cd /servercache/
touch copied.txt
fi
else

# Copy the serverfiles to the volume
cp -R /serverfiles /usr/src/

# Get the server jar file from paper-mc
printf "%s\n" "Downloading the server file from paper-mc."
cd /usr/src/serverfiles/
wget -O paper.jar https://papermc.io/ci/job/Paper-1.15/lastSuccessfulBuild/artifact/paperclip.jar
fi

# Make sure you are in the file volume
cd /usr/src/serverfiles/

# Do that forever
while : ; do

# Add double RAM
if [[ -z "$DOUBLE_RAM" ]]; then

printf "%s\n" "Starting jar file with 1GB of RAM."
java -Xms1G -Xmx1G -jar *.jar
else

printf "%s\n" "Starting jar file with 2GB of RAM."
java -Xms2G -Xmx2G -jar *.jar
fi

# Don´t overload the server if the start fails 
sleep 10
done
