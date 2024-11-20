#!/usr/bin/env sh

if [ ! -z $1 ]; then
    export HOST=$1
else
    export HOST=$(hostname)
fi

# sudo rm -rf /boot

sudo nixos-rebuild --impure --flake .#$HOST boot
