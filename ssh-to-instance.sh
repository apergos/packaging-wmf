#!/bin/bash

usage() {
    echo "Usage: $0 <distroversion> [containername]"
    echo "Example:"
    echo "$0 buster"
}


# check args
if [ -z "$1" ]; then
    usage
    exit 1
fi

# add to this when a new version is supported
case "$1" in
    'buster')
	DISTROVERS="$1"
	;;
    *)    
	usage
	exit 1
esac
   
if [ -n "$2" ]; then
    host="$2"
else
    possibles=$( docker ps | grep "${DISTROVERS}-build" | cut -d ' ' -f 1 )
    if [[ "$possibles" = *" "* ]]; then
        echo "Usage: $0 $DISTROVERS container-name"
        echo "Advice: use one of ${possibles} for the container"
        exit 1
    fi
    host="$possibles"    
fi

IPADDR=`docker inspect "--format={{.NetworkSettings.IPAddress}}" "$host"`

if [ -z "$IPADDR" ]; then
    echo "Failed to find IP address for $host"
    exit 1
else
    echo "ssh to ${IPADDR}"
fi

ssh -t -l root -o "StrictHostKeyChecking no" -o "UserKnownHostsFile /dev/null"  -o "LogLevel=ERROR" "$IPADDR"
