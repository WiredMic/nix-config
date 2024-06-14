#!/usr/bin/env bash

if [ ! -z $1 && ! -z $2 ]; then
	export USER=$1
  export HOST=$2
else
  export USER=$(whoami)
	export HOST=$(hostname)
fi

home-manager --impure --flake .#$USER@$HOST switch
