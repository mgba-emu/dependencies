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
lottie
networkauth
pim
purchasing
qa
quick1
quick3d
quickcontrols
quickcontrols2
quicktimeline
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
webchannel
webengine
webglplugin
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
