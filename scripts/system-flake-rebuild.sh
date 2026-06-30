#!/usr/bin/env bash

if [ -n "$1" ]; then
    export HOST=$1
else
    export HOST=$(hostname)
fi

systemd-run --user --scope --collect -- \
    sudo nixos-rebuild --impure --keep-going --flake .#$HOST switch
