#!/bin/bash

BASEDIR=$(dirname $0)

pushd $BASEDIR/../qt5
REMOVE_QT="
3d
activeqt
canvas3d
charts
connectivity
datavis3d
declarative
doc
docgallery
enginio
feedback
gamepad
graphicaleffects
imageformats
location
networkauth
pim
purchasing
qa
quick1
quickcontrols
quickcontrols2
remoteobjects
repotools
script
scxml
sensors
serialbus
serialport
speech
svg
systems
virtualkeyboard
wayland
webchannel
webengine
webkit
webkit-examples
websockets
webview
xmlpatterns
"

git submodule init
for dir in $REMOVE_QT; do
    git submodule deinit -f qt$dir
done
git submodule update
popd
