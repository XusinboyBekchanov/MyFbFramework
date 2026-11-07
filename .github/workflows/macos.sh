#!/bin/sh
# macOS (AppKit, -d __USE_COCOA__): the examples are built with FreeBASIC for macOS on arm64 of https://deb.fbxl.net
# (fbc makes the C code, clang builds it with the runtime of that FreeBASIC and the host mff/Cocoa/mffCocoa.m)
set -e
cd ../..
WORK="$(cd .. && pwd)"

FBXL=freebasic-1.20.5-1-macos-arm64.tar.xz
curl -fsSL -o "$WORK/$FBXL" "https://deb.fbxl.net/macos/arm64/$FBXL"
echo "22f47b42102b1624c0712cb0452c20b38b5c9a55046ec30af1fbe679c4859adf  $WORK/$FBXL" | shasum -a 256 -c -
mkdir -p "$WORK/fbxl"
tar xf "$WORK/$FBXL" -C "$WORK/fbxl"
FB="$WORK/fbxl/usr/local"
"$FB/bin/fbc" -version
# The headers of fbc of freebasic/fbc: with the ones of FBXL, FileExists (file.bi) and the macro of it of MyFbFramework
# are duplicated definitions
git clone -q --depth 1 https://github.com/freebasic/fbc.git "$WORK/fbc"

# FB_NO_USTRING, FB_NO_SFXLIB: this fbc has its own type UString and commands of sound (Midi), MyFbFramework has its
# own ones
DEFS="-d FB_NO_USTRING -d FB_NO_SFXLIB -d __USE_COCOA__"

# MyFbFramework as a library, like on Windows and Linux, with the host of AppKit libmffCocoa.a; its name is the one of
# mff.bi. fbc makes only the C code: this fbc does not know the #inclib "framework:..." of mff/Apple/mffApple.bi,
# clang links the frameworks
sh mff/Cocoa/build-lib.sh "$FB"
LIB="$FB/lib/freebasic/darwin-aarch64"
"$FB/bin/fbc" -target darwin-aarch64 -gen gcc -r -dll $DEFS -i "$WORK/fbc/inc" -b mff/mff.bi
sh mff/Apple/fix-c-code.sh mff/mff.c
clang -c -O1 -w -fno-strict-aliasing -fwrapv -fno-math-errno -fno-exceptions -fno-asynchronous-unwind-tables -funwind-tables mff/mff.c -o mff/mff.o
clang -dynamiclib -o libmff64_cocoa.dylib -install_name @rpath/libmff64_cocoa.dylib "$LIB/fbrt0.o" mff/mff.o -L"$LIB" -lmffCocoa -lfbmt -lpthread -lm -lncurses -framework Cocoa -framework WebKit -framework ApplicationServices
rm -f mff/mff.c mff/mff.o
if [ ! -f libmff64_cocoa.dylib ]; then
	echo "libmff64_cocoa.dylib does not exist"
	exit 1
fi

mkdir -p build
for f in examples/Hello.bas examples/WebAndroid/ControlsDemo.bas examples/WebAndroid/AllControlsDemo.bas examples/WebAndroid/CanvasDemo.bas; do
	p="$(basename "$f" .bas)"
	echo "== $p"
	"$FB/bin/fbc" -target darwin-aarch64 -gen gcc -r $DEFS -i "$WORK/fbc/inc" -i . -m "$p" "$f"
	mv "${f%.bas}.c" build/
	sh mff/Cocoa/build.sh "build/$p.c" "build/$p" "$FB"
	if [ ! -f "build/$p" ]; then
		echo "build/$p does not exist"
		exit 1
	fi
done

ls build
