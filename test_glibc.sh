#!/bin/bash
set -e -x

mkdir -p /sys/fs/cgroup/freezer/user/mariusz/0/suspendgroup || true
mknod /tmp/pv_shuffler_wait_pipe p || true

cd /mnt/glibc
#./testrun.sh /usr/local/bin/rr /bin/bash -c "(PV_SHUFFLER_PIPE_WAIT=1 PV_SHUFFLER_DISABLE_FREEZE_THREADS=1 LD_PRELOAD=/opt/pv/twiddler/libpe_binary_scrambler_hook.so /usr/bin/nodejs /src/echo-server.js)"

builddir=/mnt/glibc

exec /usr/local/bin/rr env GCONV_PATH="${builddir}"/iconvdata LOCPATH="${builddir}"/localedata LC_ALL=C   PV_SHUFFLER_PIPE_WAIT=1 PV_SHUFFLER_DISABLE_FREEZE_THREADS=1 LD_PRELOAD=/opt/pv/twiddler/libpe_binary_scrambler_hook.so  "${builddir}"/elf/ld-linux-x86-64.so.2 --library-path "${builddir}":"${builddir}"/math:"${builddir}"/elf:"${builddir}"/dlfcn:"${builddir}"/nss:"${builddir}"/nis:"${builddir}"/rt:"${builddir}"/resolv:"${builddir}"/crypt:"${builddir}"/mathvec:"${builddir}"/support:"${builddir}"/nptl /usr/bin/nodejs /src/echo-server.js

