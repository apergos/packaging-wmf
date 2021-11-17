#!/usr/bin/bash

usage() {
    echo "Usage: bash $0 <distroversion>"
    echo "Example:"
    echo "bash $0 buster"
}

expand_template() {
  FILENAME=$1
  mkdir -p "$DISTROVERS/scratch/"
  cat "configs/${FILENAME}.templ" | sed -e "s/GITNAME/$GITNAME/g; s/GITEMAIL/$GITEMAIL/g; s/EDITOR/$EDITOR/g;" > "$DISTROVERS/scratch/${FILENAME}"
}

copy_config() {
  FILENAME=$1
  mkdir -p "$DISTROVERS/scratch/"
  cp "configs/${FILENAME}" "$DISTROVERS/scratch/${FILENAME}"
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

source settings.txt

# setup git and debian configs
expand_template root_gitconfig
expand_template bashrc_addons
copy_config quiltrc-dpkg
copy_config wikimedia.pref
copy_config "${DISTROVERS}_deb_security.list"
copy_config "${DISTROVERS}_wikimedia.list"

cd "$DISTROVERS"

docker build --rm -t "${USER}/buster:prod" .


