#!/usr/bin/env bash
# Get all the information about the latest
get_latest_server() {
  MC_VERSION="1.16.4"
  LATEST_BUILD=$(curl -s "https://papermc.io/api/v2/projects/paper/versions/$MC_VERSION" | jq -r -e .builds[-1])
  SERVER_JAR_FILENAME=$(curl -s "https://papermc.io/api/v2/projects/paper/versions/$MC_VERSION/builds/$LATEST_BUILD/" | jq -r -e .downloads.application.name)
  SERVER_JAR_SHA256=$(curl -s "https://papermc.io/api/v2/projects/paper/versions/$MC_VERSION/builds/$LATEST_BUILD/" | jq -r -e .downloads.application.sha256)
  SERVER_JAR_URL="https://papermc.io/api/v2/projects/paper/versions/$MC_VERSION/builds/$LATEST_BUILD/downloads/$SERVER_JAR_FILENAME"

  printf "%s\n" "Downloading $MC_VERSION build $LATEST_BUILD..."

  wget --quiet -O paper.jar -T 60 $SERVER_JAR_URL
  echo "$SERVER_JAR_SHA256 paper.jar" > papersha256.txt
}

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
  JAR_FILE="paper.jar"
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
if [[ -z "$ENABLE_UPDATE" ]]; then
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
  if [[ ! -e "paper.jar" ]]; then
    printf "%s\n" "No server JAR found."
    get_latest_server
  fi

  # We have a paper.jar, is it valid?
  if [[ $(sha256sum -c papersha256.txt --status 2>/dev/null) -eq 1 ]]; then
    printf "%s\n" "Server JAR not valid."
    get_latest_server
  else
    printf "%s\n" "Found a valid server file. It's called: $(ls *.jar). Use ENABLE_UPDATE to update."
  fi
else
# But also allow forcing of an update
  printf "%s\n" "Forcing server update"
  get_latest_server
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
java -Xms$RAM -Xmx$RAM -jar $JAR_FILE

# Don´t overload the server if the start fails 
sleep 10