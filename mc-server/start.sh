#!/usr/bin/env bash
# Starts a Paper server from the serverfiles volume.
# Downloads the newest stable Paper build from PaperMC's Fill v3 API when there is no valid jar.

FILL_API="https://fill.papermc.io/v3/projects/paper"
USER_AGENT="balena-minecraft-server/2.0 (+https://github.com/AlexProgrammerDE/balena-minecraft-server)"
SERVER_DIR=/usr/src/serverfiles

AIKAR_FLAGS_CONSTANT="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"
ZGC_FLAGS_CONSTANT="-XX:+UseZGC -XX:+IgnoreUnrecognizedVMOptions -XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions -XX:-OmitStackTraceInFastThrow -XX:+ShowCodeDetailsInExceptionMessages -XX:+DisableExplicitGC -XX:-UseParallelGC -XX:+PerfDisableSharedMem -XX:-ZUncommit -XX:ZUncommitDelay=300 -XX:ZCollectionInterval=5 -XX:ZAllocationSpikeTolerance=2.0 -XX:+AlwaysPreTouch -XX:+UseTransparentHugePages -XX:LargePageSizeInBytes=2M -XX:+UseLargePages -XX:+ParallelRefProcEnabled"

is_true() { [[ "${1,,}" == "true" || "$1" == "1" ]]; }

fill_get() { curl -fsSL --retry 3 --max-time 120 -A "$USER_AGENT" "$@"; }

# Sets PAPER_VERSION and PAPER_BUILD (build JSON) to the newest stable build.
# MC_VERSION pins the Minecraft version; otherwise the newest version with a stable build wins.
resolve_build() {
  local candidates version build
  if [[ -n "$MC_VERSION" ]]; then
    candidates="$MC_VERSION"
  else
    # Fill lists versions newest first; release candidates have no STABLE builds and get skipped.
    candidates=$(fill_get "$FILL_API" | jq -r '.versions | to_entries[].value[]' | head -n 10)
  fi
  for version in $candidates; do
    build=$(fill_get "$FILL_API/versions/$version/builds?channel=STABLE" | jq -ce '.[0] // empty' 2>/dev/null) || continue
    PAPER_VERSION=$version
    PAPER_BUILD=$build
    return 0
  done
  return 1
}

download_server() {
  local name url sha
  if ! resolve_build; then
    echo "Could not find a stable Paper build${MC_VERSION:+ for $MC_VERSION}"
    return 1
  fi
  name=$(jq -r '.downloads["server:default"].name' <<<"$PAPER_BUILD")
  url=$(jq -r '.downloads["server:default"].url' <<<"$PAPER_BUILD")
  sha=$(jq -r '.downloads["server:default"].checksums.sha256' <<<"$PAPER_BUILD")

  echo "Downloading Paper $PAPER_VERSION build $(jq -r .id <<<"$PAPER_BUILD") ($name)..."
  fill_get -o paper.jar.download "$url" || return 1
  if ! echo "$sha  paper.jar.download" | sha256sum -c --status; then
    echo "Checksum mismatch for $name, discarding it"
    rm -f paper.jar.download
    return 1
  fi
  mv paper.jar.download paper.jar
  echo "$sha  paper.jar" >papersha256.txt
}

DEVICE_HOSTNAME=${DEVICE_HOSTNAME:-balenaminecraftserver}
JAR_FILE=${JAR_FILE:-paper.jar}
RAM=${RAM:-1G}

if [[ -z "$FLAGS" ]]; then
  if is_true "$AIKAR_FLAGS"; then
    FLAGS="$AIKAR_FLAGS_CONSTANT"
  elif is_true "$ZGC_FLAGS"; then
    FLAGS="$ZGC_FLAGS_CONSTANT"
  fi
fi

echo "Setting device hostname to: $DEVICE_HOSTNAME"
curl -s -X PATCH --header "Content-Type:application/json" \
  --data '{"network": {"hostname": "'"${DEVICE_HOSTNAME}"'"}}' \
  "$BALENA_SUPERVISOR_ADDRESS/v1/device/host-config?apikey=$BALENA_SUPERVISOR_API_KEY" >/dev/null

echo "Starting balenaMinecraftServer..."
cd "$SERVER_DIR" || exit 1

# Copy the default config into the volume on first run (or when forced)
if [[ ! -e /servercache/copied.txt ]]; then
  echo "First run: copying default server config"
  cp -R /serverfiles/. "$SERVER_DIR"/
  touch /servercache/copied.txt
elif is_true "$ENABLE_CONFIG_UPDATE"; then
  echo "ENABLE_CONFIG_UPDATE is set: overwriting server config"
  cp -R /serverfiles/. "$SERVER_DIR"/
fi

# A custom JAR_FILE is uploaded by the user, so only manage paper.jar
if [[ "$JAR_FILE" == "paper.jar" ]]; then
  if is_true "$ENABLE_UPDATE"; then
    echo "ENABLE_UPDATE is set: fetching the newest Paper build"
    download_server || echo "Update failed, keeping the current paper.jar"
  elif [[ -e paper.jar ]] && sha256sum -c --status papersha256.txt 2>/dev/null; then
    echo "Found a valid paper.jar. Set ENABLE_UPDATE=true to update it."
  else
    echo "No valid paper.jar found"
    if ! download_server; then
      echo "Download failed, retrying in 30 seconds"
      sleep 30
      exit 1
    fi
  fi
fi

if [[ -n "$CUSTOM_COMMAND" ]]; then
  exec bash -c "$CUSTOM_COMMAND"
fi

echo "Starting $JAR_FILE with $RAM of RAM"
# exec makes java PID 1, so it receives the stop signal and Paper saves the worlds before exiting
# shellcheck disable=SC2086 # FLAGS is a list of separate JVM options
exec java -Xms"$RAM" -Xmx"$RAM" $FLAGS -jar "$JAR_FILE" nogui
