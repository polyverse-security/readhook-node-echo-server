#!/bin/bash
set -e -x

mkdir -p /sys/fs/cgroup/freezer/user/mariusz/0/suspendgroup
mknod /tmp/pv_shuffler_wait_pipe p

cd /mnt/glibc

export PV_SHUFFLER_PIPE_WAIT=1
export LD_PRELOAD=/opt/pv/twiddler/libpe_binary_scrambler_hook.so

./testrun.sh /usr/bin/nodejs /src/echo-server.js