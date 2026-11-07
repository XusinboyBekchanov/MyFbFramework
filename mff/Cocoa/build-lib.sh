#!/bin/sh
# build-lib.sh FbcDir - the host of AppKit as libmffCocoa.a in the folder of the runtime of FreeBASIC. The program then
# needs only fbc, it links the library itself (mff/Apple/mffApple.bi):
#   fbc -gen gas64 -mt -d __USE_COCOA__ -i <MyFbFramework> Program.bas
set -e
FBC="${1:-../fbc}"
DIR="$(cd "$(dirname "$0")" && pwd)"
LIB="$(ls -d "$FBC"/lib/freebasic/darwin-* 2>/dev/null | head -n 1)"
if [ -z "$LIB" ]; then
	echo "The runtime of FreeBASIC is not in $FBC/lib/freebasic/darwin-*: make -C $FBC rtlib"
	exit 1
fi
OBJ="$LIB/mffCocoa.o"
clang -c -O1 -fobjc-arc -Wall "$DIR/mffCocoa.m" -o "$OBJ"
rm -f "$LIB/libmffCocoa.a"
ar rcs "$LIB/libmffCocoa.a" "$OBJ"
rm -f "$OBJ"
echo "Built: $LIB/libmffCocoa.a"
