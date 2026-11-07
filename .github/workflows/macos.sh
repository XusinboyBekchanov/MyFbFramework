#!/bin/sh
# macOS (AppKit, -d __USE_COCOA__) and the iOS Simulator (UIKit, -d __USE_UIKIT__): the examples are built on the Mac.
# fbc makes the C code, clang builds it with the runtime of FreeBASIC from the sources of fbc and the hosts
# mff/Cocoa/mffCocoa.m and mff/UIKit/mffUIKit.m
set -e
cd ../..
MFF="$(pwd)"
WORK="$(cd .. && pwd)"
FBC="$WORK/fbc"

# The runtime of FreeBASIC for macOS
git clone --depth 1 https://github.com/freebasic/fbc.git "$FBC"
sh mff/Apple/patch-fbc-rtlib.sh "$FBC"
# TARGET_ARCH: uname -m gives arm64, which the makefile of fbc takes for the 32-bit arm
make -C "$FBC" rtlib -j4 TARGET_OS=darwin TARGET_ARCH=aarch64 > "$WORK/make.log" 2>&1 || { cat "$WORK/make.log"; exit 1; }

# fbc for macOS on arm64 of https://deb.fbxl.net (it only makes the C code here, -r)
FBXL=freebasic-1.20.5-1-macos-arm64.tar.xz
curl -fsSL -o "$WORK/$FBXL" "https://deb.fbxl.net/macos/arm64/$FBXL"
echo "22f47b42102b1624c0712cb0452c20b38b5c9a55046ec30af1fbe679c4859adf  $WORK/$FBXL" | shasum -a 256 -c -
mkdir -p "$WORK/fbxl"
tar xf "$WORK/$FBXL" -C "$WORK/fbxl"
FBCEXE="$WORK/fbxl/usr/local/bin/fbc"
"$FBCEXE" -version

# The runtime of FreeBASIC for the iOS Simulator
sh mff/UIKit/build-rtlib.sh "$WORK/fbc-ios"

mkdir -p build/macos build/ios
for f in examples/Hello.bas examples/WebAndroid/ControlsDemo.bas examples/WebAndroid/AllControlsDemo.bas examples/WebAndroid/CanvasDemo.bas; do
	p="$(basename "$f" .bas)"
	for t in "macos __USE_COCOA__ Cocoa $FBC" "ios __USE_UIKIT__ UIKit $WORK/fbc-ios"; do
		set -- $t
		echo "== $p ($1)"
		"$FBCEXE" -target darwin-aarch64 -gen gcc -r -d "$2" -i "$FBC/inc" -i . -m "$p" "$f"
		mv "${f%.bas}.c" "build/$1/"
		sh "mff/$3/build.sh" "build/$1/$p.c" "build/$1/$p" "$4"
		if [ ! -e "build/$1/$p.app" ] && [ ! -f "build/$1/$p" ]; then
			echo "build/$1/$p does not exist"
			exit 1
		fi
	done
done

ls build/macos build/ios
