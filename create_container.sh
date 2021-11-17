#!/bin/bash

usage() {
    echo "Usage: bash $0 <distroversion>"
    echo "Example:"
    echo "bash $0 buster"
}

####################
# main

# check args
if [ -z "$1" ]; then
    usage
    exit 1
fi

source ./known_distros
for DISTRO in $KNOWN; do
    if [ "$1" == "$DISTRO" ]; then
	DISTROVERS="$1"
        break
    fi
done
if [ -z "$DISTROVERS" ]; then
    echo "No such distro '$1', known distros are: ${KNOWN}"
    usage
    exit 1
fi

if [ ! -e "./settings.txt" ]; then
    echo "Copy settings.txt.sample to settings.txt in this directory and edit it"
    echo "with your information, then run this script again."
    exit 1
fi

source "${DISTROVERS}/settings.txt"
cd "$DISTROVERS"
docker run  -t  -d --privileged --name "${DISTROVERS}-builds"  -v ${DEBS}:/root/git/debs "${USER}/${DISTROVERS}:prod"

