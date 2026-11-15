#!/bin/sh
# build-rtlib.sh FbcDir [OutDir] - builds the runtime of FreeBASIC for the iOS Simulator from the sources of fbc in FbcDir
# (no clone, no patch: the rtlib of fbc knows iOS itself, HOST_IOS of src/rtlib/fb_config.h). The objects and the
# library go to OutDir (../fbc-ios by default, a build next to the sources: the runtime of macOS in FbcDir stays as it
# is), the library is OutDir/lib/freebasic/darwin-<cpu>/libfbmt.a, the FbcDir of build.sh.
# A file of the runtime which the SDK of iOS can not compile stays out of the library: it matters only if a program
# needs its functions (the link says so then). The errors are shown as annotations of GitHub Actions.
F="$1"
OUT="${2:-../fbc-ios}"
DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -z "$F" ] || [ ! -f "$F/makefile" ] || [ ! -d "$F/src/rtlib" ]; then
	echo "Usage: build-rtlib.sh FbcDir [OutDir] - FbcDir is the folder of the sources of fbc"
	exit 1
fi
F="$(cd "$F" && pwd)"
mkdir -p "$OUT" || exit 1
OUT="$(cd "$OUT" && pwd)"
# The Simulator runs the code of the processor of the Mac
CPU="$(uname -m)"
ARCH="$CPU"
[ "$CPU" = "arm64" ] && ARCH=aarch64
cd "$OUT" || exit 1
make -k -f "$F/makefile" rtlib -j4 TARGET_OS=darwin TARGET_ARCH=$ARCH CC="xcrun --sdk iphonesimulator clang -target $CPU-apple-ios14.0-simulator" > rtlib.log 2>&1
grep -E "error:" rtlib.log | head -n 20 | sed 's/^/::warning::/'
LIB="$OUT/lib/freebasic/darwin-$ARCH"
mkdir -p "$LIB"
OBJ="$OUT/src/rtlib/obj/darwin-$ARCH"
if [ ! -f "$LIB/libfbmt.a" ]; then
	xcrun libtool -static -o "$LIB/libfbmt.a" "$OBJ"/mt/*.o || { tail -n 30 rtlib.log; echo "::error::No objects of the runtime"; exit 1; }
fi
[ -f "$LIB/fbrt0.o" ] || cp "$OBJ/fbrt0.o" "$LIB/" 2>/dev/null
ls -la "$LIB"
