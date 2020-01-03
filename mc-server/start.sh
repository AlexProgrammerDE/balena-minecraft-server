#!/usr/bin/env bash

loop="0"

while [ $loop = 0 ]
do
java -Xmx1024M -Xms1024M -jar *.jar
sleep 10
done
