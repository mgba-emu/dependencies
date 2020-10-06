#!/bin/bash
usage () {
    echo "Usage: $0 [-Pqs] TAG" >&2
    exit 1
}

PUSH='yes'
SQUASH='no'

while getopts Pqs OPT; do
    case "$OPT" in
        P)
            PUSH='no'
            ;;
        q)
            QUIET=-q
            ;;
        s)
            SQUASH='yes'
            ;;
        *)
            usage
            ;;
    esac
done
shift $(( $OPTIND - 1 ))
if [ $# -ne 1 ]; then
    usage
fi

BUILD=$1
DOCKERFILE=dockerfiles/${BUILD//:/-}/Dockerfile
FROM=$(grep ^FROM $DOCKERFILE | awk '{print $2}')
if [[ "$BUILD" =~ : ]]; then
    DATETAG=-$(date +%Y%m%d)
else
    DATETAG=:$(date +%Y%m%d)
fi
set -e

echo "Building mgba/$BUILD for $DOCKERFILE"
if [[ "$BUILD" =~ windows ]]; then
    git submodule update --init
    git submodule foreach --recursive git submodule init
    (cd libraries && buildscripts/clean-extra.sh)
    git submodule update --recursive
fi
docker build $QUIET -t mgba/$BUILD . -f $DOCKERFILE
if [ "$SQUASH" = yes ]; then
	docker-squash mgba/$BUILD -f $FROM -t mgba/$BUILD
fi
if [ "$PUSH" = yes ]; then
	docker push mgba/$BUILD
	docker tag mgba/$BUILD mgba/$BUILD$DATETAG
	docker push mgba/$BUILD$DATETAG
	docker rmi mgba/$BUILD$DATETAG
fi
