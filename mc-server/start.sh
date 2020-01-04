#!/usr/bin/env bash

loop="0"

while [ $loop = 0 ]
do
java -Xmx512M -Xms512M -jar *.jar
sleep 10
done
