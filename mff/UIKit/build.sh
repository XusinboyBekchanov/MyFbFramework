#!/bin/sh
# build.sh - builds a MyFbFramework program for the iOS Simulator (UIKit, -d __USE_UIKIT__) on a Mac.
#
#   build.sh Program.c Program [FbcDir]
#
# Program.c is the C code of the program (on any system):
#   fbc -target darwin-aarch64 -gen gcc -r -d __USE_UIKIT__ -i <MyFbFramework> -m Program Program.bas
# FbcDir is the folder of the sources of fbc with the runtime of FreeBASIC built for the Simulator, ../fbc-ios by default:
#   sh build-rtlib.sh ../fbc-ios
# The bundle is Program.app.
set -e
SRC="$1"
OUT="$2"
FBC="${3:-../fbc-ios}"
DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -z "$SRC" ] || [ -z "$OUT" ]; then
	echo "Usage: build.sh Program.c Program [FbcDir]"
	exit 1
fi
LIB="$(ls -d "$FBC"/lib/freebasic/darwin-* 2>/dev/null | head -n 1)"
if [ ! -f "$LIB/libfbmt.a" ]; then
	echo "The runtime of FreeBASIC (libfbmt.a) is not in $FBC/lib/freebasic/darwin-*"
	exit 1
fi
sh "$DIR/../Apple/fix-c-code.sh" "$SRC"
CC="xcrun --sdk iphonesimulator clang -target arm64-apple-ios14.0-simulator"
$CC -c -O1 -w -fno-strict-aliasing -fwrapv -fno-math-errno -fno-exceptions -fno-asynchronous-unwind-tables -funwind-tables "$SRC" -o "$OUT.o"
$CC -c -O1 -fobjc-arc -Wall "$DIR/mffUIKit.m" -o "$OUT.mff.o"
RT0=""
[ -f "$LIB/fbrt0.o" ] && RT0="$LIB/fbrt0.o"
NAME="$(basename "$OUT")"
APP="$OUT.app"
mkdir -p "$APP"
$CC -o "$APP/$NAME" $RT0 "$OUT.o" "$OUT.mff.o" -L"$LIB" -lfbmt -lpthread -lm -framework UIKit -framework WebKit -framework CoreGraphics -framework Foundation
rm -f "$OUT.o" "$OUT.mff.o"
cat > "$APP/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleExecutable</key><string>$NAME</string>
	<key>CFBundleIdentifier</key><string>com.myfbframework.$NAME</string>
	<key>CFBundleName</key><string>$NAME</string>
	<key>CFBundlePackageType</key><string>APPL</string>
	<key>CFBundleShortVersionString</key><string>1.0</string>
	<key>CFBundleVersion</key><string>1</string>
	<key>MinimumOSVersion</key><string>14.0</string>
	<key>UIDeviceFamily</key><array><integer>1</integer><integer>2</integer></array>
	<key>UILaunchScreen</key><dict/>
	<key>UISupportedInterfaceOrientations</key><array><string>UIInterfaceOrientationPortrait</string><string>UIInterfaceOrientationLandscapeLeft</string><string>UIInterfaceOrientationLandscapeRight</string></array>
</dict>
</plist>
EOF
echo "Built: $APP"
