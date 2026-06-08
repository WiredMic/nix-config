#!/usr/bin/env bash

if [ ! -z $1 ]; then
    export HOST=$1
else
    export HOST=$(hostname)
fi

sudo nixos-rebuild --impure --flake .#$HOST \
    --override-input nixpkgs path:/home/rasmus/Projects/nix/nixpkgs \
    --override-input home-manager path:/home/rasmus/Projects/nix/home-manager \
    --override-input stylix "github:danth/stylix" \
    switch
