#!/bin/sh
# build.sh - builds a MyFbFramework program for the iOS Simulator (UIKit, -d __USE_UIKIT__) on a Mac.
#
#   build.sh Program.c Program [FbcDir]
#
# Program.c is the C code of the program (on any system):
#   fbc -target darwin-aarch64 (darwin-x86_64 on a Mac with Intel) -gen gcc -r -d __USE_UIKIT__ -i <MyFbFramework> -m Program Program.bas
# With -gen gas64 (a fast compilation on a Mac with Intel) Program.asm of fbc -gen gas64 -r is given instead of Program.c.
# FbcDir is the folder with the runtime of FreeBASIC built for the Simulator (lib/freebasic/darwin-*), ../fbc-ios by
# default, made from the sources of fbc:
#   sh build-rtlib.sh ../fbc ../fbc-ios
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
# The Simulator runs the code of the processor of the Mac
ARCH="$(uname -m)"
CC="xcrun --sdk iphonesimulator clang -target $ARCH-apple-ios14.0-simulator"
case "$SRC" in
*.asm)
	$CC -c -x assembler "$SRC" -o "$OUT.o"
	;;
*)
	sh "$DIR/../Apple/fix-c-code.sh" "$SRC"
	$CC -c -O1 -w -fno-strict-aliasing -fwrapv -fno-math-errno -fno-exceptions -fno-asynchronous-unwind-tables -funwind-tables "$SRC" -o "$OUT.o"
	;;
esac
$CC -c -O1 -fobjc-arc -Wall "$DIR/mffUIKit.m" -o "$OUT.mff.o"
RT0=""
[ -f "$LIB/fbrt0.o" ] && RT0="$LIB/fbrt0.o"
NAME="$(basename "$OUT")"
APP="$OUT.app"
mkdir -p "$APP"
# A bundle of macOS of the same name (Program.app/Contents): the Simulator would read its Info.plist and refuse the
# program (code 22, no valid CFBundleVersion)
rm -rf "$APP/Contents"
$CC -o "$APP/$NAME" $RT0 "$OUT.o" "$OUT.mff.o" -L"$LIB" -lfbmt -lpthread -lm -framework UIKit -framework WebKit -framework CoreGraphics -framework Foundation
rm -f "$OUT.o" "$OUT.mff.o"
# The icon of the Home Screen: iOS takes it only from the files of the bundle (Icon of a form does not change it).
# MFF_ICON=File, or AppIcon.png (a square picture without transparency: iOS rounds its corners itself), Program.png
# (.icns, .ico) or Icon.png in Resources next to Program.c (or one folder up), as the pictures of the sizes of the iPhone
# and the iPad (loose files, without an asset catalog of Xcode)
SRCDIR="$(cd "$(dirname "$SRC")" && pwd)"
ICON="$MFF_ICON"
if [ -z "$ICON" ]; then
	for R in "$SRCDIR/Resources" "$SRCDIR/../Resources"; do
		for F in AppIcon.png "$NAME.png" "$NAME.icns" "$NAME.ico" Icon.png; do
			if [ -f "$R/$F" ]; then ICON="$R/$F"; break 2; fi
		done
	done
fi
rm -f "$APP"/AppIcon*.png
ICONS=""
if [ -n "$ICON" ]; then
	if [ ! -f "$ICON" ]; then
		echo "The icon $ICON is not there"
	else
		for S in "60x60@2x 120" "60x60@3x 180" "76x76@2x~ipad 152" "83.5x83.5@2x~ipad 167"; do
			set -- $S
			sips -s format png -z "$2" "$2" "$ICON" --out "$APP/AppIcon$1.png" >/dev/null
		done
		ICONS="	<key>CFBundleIcons</key><dict><key>CFBundlePrimaryIcon</key><dict><key>CFBundleIconFiles</key><array><string>AppIcon60x60</string></array></dict></dict>
	<key>CFBundleIcons~ipad</key><dict><key>CFBundlePrimaryIcon</key><dict><key>CFBundleIconFiles</key><array><string>AppIcon60x60</string><string>AppIcon76x76</string><string>AppIcon83.5x83.5</string></array></dict></dict>"
	fi
fi
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
$ICONS
</dict>
</plist>
EOF
# The files of the program in the bundle: Resources next to Program.c (or one folder up, like a program made with
# -x ../) as AppResources (iOS does not install a bundle with Resources at its top), and the lines "From [To]" of
# ios-bundle.txt next to Program.c (From from its folder, To the path in the bundle, From by default)
for R in "$SRCDIR/Resources" "$SRCDIR/../Resources"; do
	if [ -d "$R" ]; then
		rm -rf "$APP/AppResources"
		cp -R "$R" "$APP/AppResources"
		break
	fi
done
if [ -f "$SRCDIR/ios-bundle.txt" ]; then
	while read -r FROM TO; do
		case "$FROM" in ""|\#*) continue ;; esac
		[ -z "$TO" ] && TO="$FROM"
		case "$TO" in /*|*..*) echo "ios-bundle.txt: $TO is not a path in the bundle"; continue ;; esac
		mkdir -p "$APP/$(dirname "$TO")"
		rm -rf "${APP:?}/$TO"
		cp -R "$SRCDIR/$FROM" "$APP/$TO"
	done < "$SRCDIR/ios-bundle.txt"
fi
echo "Built: $APP"
