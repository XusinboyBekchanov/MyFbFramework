#!/bin/sh
# build.sh - links a MyFbFramework program for macOS (AppKit, -d __USE_COCOA__) on a Mac.
#
#   build.sh Program.c Program [FbcDir]
#
# Program.c is the C code of the program for macOS (on any system):
#   fbc -target darwin-aarch64 -gen gcc -r -d __USE_COCOA__ -i <MyFbFramework> -m Program Program.bas
# FbcDir is the folder of the sources of fbc with the runtime of FreeBASIC built for the Mac (make rtlib),
# ../fbc by default. The program is Program and its bundle Program.app.
set -e
SRC="$1"
OUT="$2"
FBC="${3:-../fbc}"
DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -z "$SRC" ] || [ -z "$OUT" ]; then
	echo "Usage: build.sh Program.c Program [FbcDir]"
	exit 1
fi
LIB="$(ls -d "$FBC"/lib/freebasic/darwin-* 2>/dev/null | head -n 1)"
if [ ! -f "$LIB/libfbmt.a" ]; then
	echo "The runtime of FreeBASIC (libfbmt.a) is not in $FBC/lib/freebasic/darwin-*: make -C $FBC rtlib"
	exit 1
fi
sh "$DIR/../Apple/fix-c-code.sh" "$SRC"
# The flags of fbc for the C code of -gen gcc
clang -c -O1 -w -fno-strict-aliasing -fwrapv -fno-math-errno -fno-exceptions -fno-asynchronous-unwind-tables -funwind-tables "$SRC" -o "$OUT.o"
clang -c -O1 -fobjc-arc -Wall "$DIR/mffCocoa.m" -o "$OUT.mff.o"
RT0=""
[ -f "$LIB/fbrt0.o" ] && RT0="$LIB/fbrt0.o"
clang -o "$OUT" $RT0 "$OUT.o" "$OUT.mff.o" -L"$LIB" -lfbmt -lpthread -lm -lncurses -framework Cocoa -framework WebKit
rm -f "$OUT.o" "$OUT.mff.o"

# The bundle: a program of the Dock with its menu and its windows in front
NAME="$(basename "$OUT")"
APP="$OUT.app"
mkdir -p "$APP/Contents/MacOS"
cp "$OUT" "$APP/Contents/MacOS/$NAME"
cat > "$APP/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleExecutable</key><string>$NAME</string>
	<key>CFBundleIdentifier</key><string>com.myfbframework.$NAME</string>
	<key>CFBundleName</key><string>$NAME</string>
	<key>CFBundlePackageType</key><string>APPL</string>
	<key>CFBundleShortVersionString</key><string>1.0</string>
	<key>NSHighResolutionCapable</key><true/>
	<key>NSPrincipalClass</key><string>NSApplication</string>
</dict>
</plist>
EOF
echo "Built: $OUT, $APP"
