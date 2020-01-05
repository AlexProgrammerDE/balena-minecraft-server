#!/usr/bin/env bash

if [[ -z "$CACHE_IGNORE" ]]; then

cd /servercache/

if [[ ! -a "copied.txt" ]]; then
cp -R /serverfiles /usr/src/
cd /usr/src/serverfiles/
wget -O spigot.jar https://github.com/AlexProgrammerDE/Example-Server/raw/master/spigot.jar
cd /servercache/
touch copied.txt
fi
else
cp -R /serverfiles /usr/src/
cd /usr/src/serverfiles/
wget -O spigot.jar https://github.com/AlexProgrammerDE/Example-Server/raw/master/spigot.jar
fi

cd /usr/src/serverfiles/

while : ; do

if [[ -z "$DOUBLE_RAM" ]]; then
java -Xms1G -Xmx1G -jar *.jar
else
java -Xms2G -Xmx2G -jar *.jar
fi
sleep 10
done
