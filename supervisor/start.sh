#!/usr/bin/env bash

cd /usr/src/

export VERSION=$(<VERSION)

echo "You are using Version $VERSION of balena-minecraft-server."

echo "Checking for Internet connection."

wget --spider http://google.com 2>&1

if [ $? -eq 0 ]; then
  echo "There is a internet connection. Checking for Updates."
  
  wget -O ONLINEVERSION https://raw.githubusercontent.com/AlexProgrammerDE/balena-minecraft-server/master/VERSION
  
  export ONLINEVERSION=$(<ONLINEVERSION)
  
  if [[ "$VERSION" == "$ONLINEVERSION" ]]; then
    echo "You are using the newest version of balena-minecraft-server!"
  else
    echo "There are updates available. You can get the newest version of balena-minecraft-server from: github.com/AlexProgrammerDE/balena-minecraft-server"
  fi
else
  echo "There is no internet connection. Trying again on next boot."
fi

while [[ true ]]; do
  sleep 120
done
