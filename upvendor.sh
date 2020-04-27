#!/bin/bash
set -e -x

# Enumerate the vendors in this file
VENDORS=('polyverse' 'polyverse-security')

# polyverse commitshas
POLYVERSE_READHOOK_VER="v1.3.0-jitrop3"

# polyverse-security commitshas
if [[ -z $POLYVERSE_SECURITY_TWIDDLER_SHA ]]; then
	POLYVERSE_SECURITY_TWIDDLER_SHA="596de2837ac124f590b0733de5593c2bc98551a2"
fi

function main() {
	VENDOR_ROOT="${PWD}/vendor"

	# Delete the whole vendor folder and make a clean one
	rm -rf ${VENDOR_ROOT} && mkdir -p "${VENDOR_ROOT}"

	# Upvendor each of the listed vendors
	for VENDOR in ${VENDORS[@]}; do
		upvendor $VENDOR
	done

	return 0
}

function upvendor() {
	VENDOR_FOLDER="${VENDOR_ROOT}/$1"
	mkdir -p "${VENDOR_FOLDER}"

	echo "INFO: Upvendoring: $1"
	cd ${VENDOR_FOLDER}
	$1
}

function polyverse() {
	if [[ -n "$PV_UPVENDOR_LOCAL" ]]; then # (Convenience for development)
		cp -v ../../../readhook/dll/basehook.so .
		cp -v ../../../readhook/dll/fullhook.so .
	else
		wget -nv https://github.com/polyverse/readhook/releases/download/${POLYVERSE_READHOOK_VER}/basehook.so
		wget -nv https://github.com/polyverse/readhook/releases/download/${POLYVERSE_READHOOK_VER}/fullhook.so
		cp -p /Users/mariusz/Downloads/LinuxExes/scrambled/basehook.so .
	fi
}

function polyverse-security() {
        if [[ -n "$PV_UPVENDOR_LOCAL" ]]; then # (Convenience for development)
		cp -v ../../../../polyverse-security/pe-binary-scrambler-hook/out/twiddler-dev.tar .
		# cp -v ../../../../polyverse-security/pe-binary-scrambler-hook/out/twiddler-rel.tar .
	else
		aws s3 cp s3://polyverse-artifacts/twiddler/twiddler-dev-${POLYVERSE_SECURITY_TWIDDLER_SHA}.tar twiddler-dev.tar
		# aws s3 cp s3://polyverse-artifacts/twiddler/twiddler-rel-${POLYVERSE_SECURITY_TWIDDLER_SHA}.tar twiddler-rel.tar
	fi
}

main "$@"
exit $?
