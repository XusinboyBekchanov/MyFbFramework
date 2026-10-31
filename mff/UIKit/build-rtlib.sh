#!/bin/sh
# build-rtlib.sh FbcDir - gets the sources of fbc into FbcDir and builds the runtime of FreeBASIC for the iOS Simulator.
# A file of the runtime which the SDK of iOS can not compile stays out of the library: it matters only if a program
# needs its functions (the link says so then). The errors are shown as annotations of GitHub Actions.
F="$1"
DIR="$(cd "$(dirname "$0")" && pwd)"
[ -d "$F/src" ] || git clone --depth 1 https://github.com/freebasic/fbc.git "$F" || exit 1
sh "$DIR/../Apple/patch-fbc-rtlib.sh" "$F" ios || exit 1
make -k -C "$F" rtlib -j4 TARGET_OS=darwin TARGET_ARCH=aarch64 CC="xcrun --sdk iphonesimulator clang -target arm64-apple-ios14.0-simulator -I$DIR/../Apple/ios-include" > rtlib.log 2>&1
grep -E "error:" rtlib.log | head -n 20 | sed 's/^/::warning::/'
LIB="$F/lib/freebasic/darwin-aarch64"
mkdir -p "$LIB"
OBJ="$F/src/rtlib/obj/darwin-aarch64"
if [ ! -f "$LIB/libfbmt.a" ]; then
	xcrun libtool -static -o "$LIB/libfbmt.a" "$OBJ"/mt/*.o || { tail -n 30 rtlib.log; echo "::error::No objects of the runtime"; exit 1; }
fi
[ -f "$LIB/fbrt0.o" ] || cp "$OBJ/fbrt0.o" "$LIB/" 2>/dev/null
ls -la "$LIB"
