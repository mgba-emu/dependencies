#!/bin/bash
usage () {
    echo "Usage: $0 [-Pq] TAG" >&2
    exit 1
}

PUSH='yes'

while getopts Pq OPT; do
    case "$OPT" in
        P)
		    PUSH='no'
			;;
        q)
            QUIET=-q
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
DOCKERFILE=dockerfiles/$(echo $BUILD | sed -e 's/:/-/')/Dockerfile
FROM=$(head -n1 $DOCKERFILE | cut -d ' ' -f2)

echo "Building mgba/$BUILD for $DOCKERFILE"
if [ -n "$(echo $BUILD | grep windows)" ]; then
    git submodule update --init
    git submodule foreach --recursive git submodule init
    (cd libraries && buildscripts/clean-extra.sh)
    git submodule update --recursive
fi
docker build $QUIET -t mgba/$BUILD . -f $DOCKERFILE || exit 1
docker-squash mgba/$BUILD -f $FROM -t mgba/$BUILD || exit 1
[ "$PUSH" != "yes" ] || docker push mgba/$BUILD || exit 1
