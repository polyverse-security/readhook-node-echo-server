#!/bin/bash
set -e -x

HOOK_PATH=/home/mariusz/go/src/github.com/polyverse-security/pe-binary-scrambler-hook
# GLIBC_PATH=/home/mariusz/build/glibc
GLIBC_PATH=/mnt/hgfs/Downloads/LinuxExes

#docker run --privileged -it --rm -p 8080:8080 polyverse/readhook-node-echo-server $1
docker run --privileged --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -it --rm --name readhook-node-echo-server \
     -v $HOOK_PATH:/mnt/cross -v $GLIBC_PATH:/mnt/glibc \
     --mount "source=src-glibc-2.23,target=/home/root/src/glibc-2.23" \
     --mount "source=build-glibc-2.23,target=/home/root/build/glibc-2.23" \
     --entrypoint=/bin/bash \
     polyverse/readhook-node-echo-server

