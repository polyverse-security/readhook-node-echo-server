#!/bin/bash
set -e -x

mkdir -p /sys/fs/cgroup/freezer/user/mariusz/0/suspendgroup
mknod /tmp/pv_shuffler_wait_pipe p

# gdb -ex "set args /src/echo-server.js" -ex "set env LD_PRELOAD /tmp/fullhook.so:/tmp/basehook.so:/opt/pv/twiddler/libpe_binary_scrambler_hook.so" \
#     -ex "set directories /mnt/cross" \
#     nodejs
gdb -ex "set args /src/echo-server.js" -ex "set env LD_PRELOAD /opt/pv/twiddler/libpe_binary_scrambler_hook.so" \
    -ex "set directories /mnt/cross" \
    nodejs
