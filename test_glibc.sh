#!/bin/bash
set -e -x

mkdir -p /sys/fs/cgroup/freezer/user/mariusz/0/suspendgroup || true
mknod /tmp/pv_shuffler_wait_pipe p || true

# cd /mnt/glibc
#./testrun.sh /usr/local/bin/rr /bin/bash -c "(PV_SHUFFLER_PIPE_WAIT=1 PV_SHUFFLER_DISABLE_FREEZE_THREADS=1 LD_PRELOAD=/opt/pv/twiddler/libpe_binary_scrambler_hook.so /usr/bin/nodejs /src/echo-server.js)"

# builddir=/mnt/glibc/

# exec /usr/local/bin/rr env GCONV_PATH="${builddir}"/iconvdata LOCPATH="${builddir}"/localedata LC_ALL=C \
#   PV_SHUFFLER_PIPE_WAIT=1 PV_SHUFFLER_DISABLE_FREEZE_THREADS=1 LD_PRELOAD=/opt/pv/twiddler/libpe_binary_scrambler_hook.so \
#    "${builddir}"/elf/ld-linux-x86-64.so.2 --library-path "${builddir}":"${builddir}"/math:"${builddir}"/elf:"${builddir}"/dlfcn:"${builddir}"/nss:"${builddir}"/nis:"${builddir}"/rt:"${builddir}"/resolv:"${builddir}"/crypt:"${builddir}"/mathvec:"${builddir}"/support:"${builddir}"/nptl \
#    /usr/bin/nodejs /src/echo-server.js

# /usr/local/bin/rr env PV_SHUFFLER_PIPE_WAIT=1 PV_SHUFFLER_DISABLE_FREEZE_THREADS=1 LD_PRELOAD=/opt/pv/twiddler/libpe_binary_scrambler_hook.so /usr/bin/nodejs /src/echo-server.js

export LD_DEBUG=files
export PV_SHUFFLER_PIPE_WAIT=1
export PV_SHUFFLER_DISABLE_FREEZE_THREADS=1
# LD_PRELOAD=/opt/pv/twiddler/libpe_binary_scrambler_hook.so


# symbol-file /opt/pv/twiddler/libpe_binary_scrambler_hook.so
# gdb -ex 'set env LD_LIBRARY_PATH /mnt/glibc/scrambled' -ex 'set env LD_DEBUG libs' \
#    -ex 'set env PV_SHUFFLER_PIPE_WAIT=1' -ex 'set env PV_SHUFFLER_DISABLE_FREEZE_THREADS 1' \
#     -ex 'set env LD_PRELOAD /opt/pv/twiddler/libpe_binary_scrambler_hook.so' -ex 'set args /usr/bin/nodejs  /src/echo-server.js' /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 

# env LD_LIBRARY_PATH=/mnt/glibc/scrambled LD_PRELOAD=/opt/pv/twiddler/libpe_binary_scrambler_hook.so /usr/bin/nodejs /src/echo-server.js

# Prepare settings for rr replay
cat > ~/.gdbinit << HERE
set verbose on
set debug-file-directory /usr/lib/debug
set substitute-path /build/glibc-LK5gWL /home/root/src
define hook-stop
disas \$rip-0x20,+0x40
x/16xg \$rsp
bt
end
define sym_libc
set \$nadr = \$arg0+0x1000
add-symbol-file /usr/lib/debug/lib/x86_64-linux-gnu/libc-2.23.so -o \$nadr
end
define sym_twiddler
set \$nadr = \$arg0
add-symbol-file /opt/pv/twiddler/libpe_binary_scrambler_hook.so -o \$nadr
end
HERE
# The line below seems not so useful
# set directories /home/root/src/glibc-2.23/stdio-common

# add-symbol-file /opt/pv/twiddler/libpe_binary_scrambler_hook.so -o 0x7fe399e8f000

ln -s /mnt/glibc/scrambled/libc-2.23.so  /mnt/glibc/scrambled/libc.so.6 || true

# export LLP=/mnt/glibc/scrambled
/usr/local/bin/rr env LD_LIBRARY_PATH=$LLP LD_PRELOAD=/opt/pv/twiddler/libpe_binary_scrambler_hook.so:/tmp/basehook.so /usr/bin/nodejs /src/echo-server.js
