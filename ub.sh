#!/bin/bash
set -e -x
set -o pipefail

pushd ../../polyverse-security/pe-binary-scrambler-hook
./build.sh
[ $? -ne 0 ] && return 1
 ./publish.sh
[ $? -ne 0 ] && return 1
export POLYVERSE_SECURITY_TWIDDLER_SHA=$(git rev-parse --verify HEAD)
popd

./upvendor.sh
[ $? -ne 0 ] && return 1
./build.sh
[ $? -ne 0 ] && return 1
