#!/usr/bin/env bash

loop="0"

while [ $loop = 0 ]
do
java -Xms1G -Xmx1G -XX:+UseConcMarkSweepGC -jar spigot.jar
sleep 10
done
