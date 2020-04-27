#!/bin/bash
set -e -x

HOOK_PATH=/Users/mariusz/concurix/goworkspace/src/github.com/polyverse-security/pe-binary-scrambler-hook
GLIBC_PATH=/Users/mariusz/Downloads/LinuxExes/glibc

#docker run --privileged -it --rm -p 8080:8080 polyverse/readhook-node-echo-server $1
docker run --privileged -it --rm --name readhook-node-echo-server -v $HOOK_PATH:/mnt/cross -v $GLIBC_PATH:/mnt/glibc --entrypoint=/bin/bash polyverse/readhook-node-echo-server

