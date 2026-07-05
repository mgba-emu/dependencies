#!/bin/bash

BASEDIR=$(dirname $0)

REMOVE_QT="
3d
activeqt
canvas3d
canvaspainter
charts
coap
connectivity
datavis3d
doc
docgallery
enginio
feedback
gamepad
graphicaleffects
graphs
grpc
httpserver
imageformats
languageserver
location
lottie
mqtt
networkauth
opcua
openapi
pim
positioning
purchasing
qa
quick1
quick3d
quick3dphysics
quickcontrols
quickcontrols2
quickeffectmaker
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
tasktree
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

pushd $BASEDIR/../qt5
git submodule init
git submodule deinit -f qtdeclarative
for dir in $REMOVE_QT; do
    git submodule deinit -f qt$dir
done
git submodule update
popd

pushd $BASEDIR/../qt6
git submodule init
for dir in $REMOVE_QT; do
    git submodule deinit -f qt$dir
done
git submodule update
popd
