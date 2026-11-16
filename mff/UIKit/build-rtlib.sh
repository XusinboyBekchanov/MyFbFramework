#!/bin/sh
# build-rtlib.sh FbcDir [simulator|device] - builds the runtime of FreeBASIC for iOS from the sources of fbc in FbcDir
# (no clone, no patch: the rtlib of fbc knows iOS itself, HOST_IOS of src/rtlib/fb_config.h) and puts it next to the
# runtime of macOS in FbcDir/lib/freebasic:
#   simulator (by default): iossim-<cpu of the Mac> (iossim-aarch64, iossim-x86_64), the folder of build.sh
#   device: ios-aarch64 (the iPhone and the iPad)
# The iOS Simulator is another platform than iOS (the platform of the Mach-O objects, its own SDK), even with the same
# processor: the linker does not mix them, so each one has its own folder. They are not darwin-<cpu> (macOS).
# A file of the runtime which the SDK of iOS can not compile stays out of the library: it matters only if a program
# needs its functions (the link says so then). The errors are shown as annotations of GitHub Actions.
F="$1"
KIND="${2:-simulator}"
if [ -z "$F" ] || [ ! -f "$F/makefile" ] || [ ! -d "$F/src/rtlib" ]; then
	echo "Usage: build-rtlib.sh FbcDir [simulator|device] - FbcDir is the folder of the sources of fbc"
	exit 1
fi
F="$(cd "$F" && pwd)"
case "$KIND" in
simulator)
	# The Simulator runs the code of the processor of the Mac
	CPU="$(uname -m)"
	SDK=iphonesimulator
	TRIPLE="$CPU-apple-ios14.0-simulator"
	NAME=iossim
	;;
device)
	CPU=arm64
	SDK=iphoneos
	TRIPLE="arm64-apple-ios14.0"
	NAME=ios
	;;
*)
	echo "build-rtlib.sh: $KIND is not simulator or device"
	exit 1
	;;
esac
ARCH="$CPU"
[ "$CPU" = "arm64" ] && ARCH=aarch64
LIB="$F/lib/freebasic/$NAME-$ARCH"
# The objects in a folder of their own: a build in FbcDir would replace the runtime of macOS (lib/freebasic/darwin-<cpu>)
B="$(mktemp -d "${TMPDIR:-/tmp}/fbc-rtlib-$NAME.XXXXXX")" || exit 1
cd "$B" || exit 1
make -k -f "$F/makefile" rtlib -j4 TARGET_OS=darwin TARGET_ARCH=$ARCH CC="xcrun --sdk $SDK clang -target $TRIPLE" > rtlib.log 2>&1
grep -E "error:" rtlib.log | head -n 20 | sed 's/^/::warning::/'
OUT="$B/lib/freebasic/darwin-$ARCH"
OBJ="$B/src/rtlib/obj/darwin-$ARCH"
mkdir -p "$OUT"
if [ ! -f "$OUT/libfbmt.a" ]; then
	xcrun libtool -static -o "$OUT/libfbmt.a" "$OBJ"/mt/*.o || { tail -n 30 rtlib.log; echo "::error::No objects of the runtime"; cd /; rm -rf "$B"; exit 1; }
fi
[ -f "$OUT/fbrt0.o" ] || cp "$OBJ/fbrt0.o" "$OUT/" 2>/dev/null
rm -rf "$LIB"
mkdir -p "$LIB"
cp "$OUT"/*.a "$OUT"/*.o "$LIB/" 2>/dev/null
cd /
rm -rf "$B"
ls -la "$LIB"
