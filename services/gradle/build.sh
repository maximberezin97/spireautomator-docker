#!/bin/sh

mkdir /input
wget https://github.com/maximberezin97/spireautomator/archive/master.zip -O /input/master.zip
unzip /input/master -d /input
cd /input/spireautomator-master
gradle fatJar
cp /input/spireautomator-master/build/libs/spireautomator-portable.jar /output/
chmod 777 /output/spireautomator-portable.jar
