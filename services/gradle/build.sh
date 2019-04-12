#!/bin/sh

wget https://github.com/maximberezin97/spireautomator/archive/master.zip -O ~/master.zip
unzip ~/master -d ~
cd ~/spireautomator-master
gradle fatJar
mkdir ~/output
cp ~/spireautomator-master/build/libs/spireautomator-portable.jar ~/output/
