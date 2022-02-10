#!/usr/bin/env bash

# This script is only used to run the dockercontainer built by the makefile and mount the pwd
echo "[Script] Using docker: $(docker -v)"
docker run --volume "$(pwd):/home/cccd-user/data" fedora-cccd:latest "/home/cccd-user/data/$@"
