#!/usr/bin/env bash
# Get all the information about the latest
get_latest_server() {
  MC_VERSION=$(curl -s "https://papermc.io/api/v2/projects/paper/" | jq -r -e .versions[-1])
  LATEST_BUILD=$(curl -s "https://papermc.io/api/v2/projects/paper/versions/$MC_VERSION" | jq -r -e .builds[-1])
  SERVER_JAR_FILENAME=$(curl -s "https://papermc.io/api/v2/projects/paper/versions/$MC_VERSION/builds/$LATEST_BUILD/" | jq -r -e .downloads.application.name)
  SERVER_JAR_SHA256=$(curl -s "https://papermc.io/api/v2/projects/paper/versions/$MC_VERSION/builds/$LATEST_BUILD/" | jq -r -e .downloads.application.sha256)
  SERVER_JAR_URL="https://papermc.io/api/v2/projects/paper/versions/$MC_VERSION/builds/$LATEST_BUILD/downloads/$SERVER_JAR_FILENAME"

  printf "%s\n" "Downloading $MC_VERSION build $LATEST_BUILD..."

  echo "$SERVER_JAR_SHA256 paper.jar" > papersha256.txt
  wget --quiet -O paper.jar -T 60 $SERVER_JAR_URL
}

# Declare some constants
AIKAR_FLAGS_CONSTANT="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"
ZGC_FLAGS_CONSTANT="-XX:+UseZGC -XX:+IgnoreUnrecognizedVMOptions -XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions -XX:-OmitStackTraceInFastThrow -XX:+ShowCodeDetailsInExceptionMessages -XX:+DisableExplicitGC -XX:-UseParallelGC -XX:-UseParallelOldGC -XX:+PerfDisableSharedMem -XX:-ZUncommit -XX:ZUncommitDelay=300 -XX:ZCollectionInterval=5 -XX:ZAllocationSpikeTolerance=2.0 -XX:+AlwaysPreTouch -XX:+UseTransparentHugePages -XX:LargePageSizeInBytes=2M -XX:+UseLargePages -XX:+ParallelRefProcEnabled"

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

if [[ -z "$FLAGS" ]]; then
  if [[ -n "$AIKAR_FLAGS" ]]; then
    FLAGS="$AIKAR_FLAGS_CONSTANT"
  elif [[ -n "$ZGC_FLAGS" ]]; then
    FLAGS="$ZGC_FLAGS_CONSTANT"
  fi
fi

printf "%s\n" "Setting device hostname to: $DEVICE_HOSTNAME"

curl -s -X PATCH --header "Content-Type:application/json" \
  --data '{"network": {"hostname": "'"${DEVICE_HOSTNAME}"'"}}' \
  "$BALENA_SUPERVISOR_ADDRESS/v1/device/host-config?apikey=$BALENA_SUPERVISOR_API_KEY" >/dev/null

# Download a server JAR if we don't already have a valid one
# And copy the server files into the directory on first run
printf "\n\n%s\n\n" "Starting balenaMinecraftServer..."
if [[ -z "$ENABLE_UPDATE" ]]; then
  if [[ ! -e "/servercache/copied.txt" ]]; then
    printf "%s\n" "Copying config"
    # Copy the server files to the volume
    cp -R /serverfiles /usr/src/
    # Mark this is done
    touch /servercache/copied.txt
  else
    printf "%s\n" "Config already copied"
  fi

  cd /usr/src/serverfiles/ || exit

  printf "%s" "Checking server JAR... "
  # Check to see if we have a server jar, and if we do, is it valid?
  if [[ ! -e "paper.jar" ]]; then
    printf "%s\n" "No server JAR found."
    get_latest_server
  fi

  # We have a paper.jar, is it valid?
  if [[ $(sha256sum -c papersha256.txt --status 2>/dev/null) -eq 1 || ! -e "papersha256.txt" ]]; then
    printf "%s\n" "Server JAR not valid."
    get_latest_server
  else
    printf "%s\n" "Found a valid server file. It's called: $(ls *.jar). Use ENABLE_UPDATE to update."
  fi
else
  # Force paper jar updating
  printf "%s\n" "Forcing server update"
  get_latest_server
fi

if [[ -n "$ENABLE_CONFIG_UPDATE" ]]; then
  # Copy the server files to the volume
  printf "%s\n" "Forcing config copy"
  cp -R /serverfiles /usr/src/
fi

# Make sure we are in the file volume
cd /usr/src/serverfiles/ || exit

if [[ -z "$CUSTOM_COMMAND" ]]; then
  printf "%s\n" "Starting JAR file with: $RAM of RAM"
  # Start java with the custom flags
  java -Xms$RAM -Xmx$RAM $FLAGS -jar $JAR_FILE nogui
else
  $CUSTOM_COMMAND
fi

# Don't overload the server if the start fails
sleep 10
