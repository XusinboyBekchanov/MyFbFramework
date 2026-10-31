#!/bin/sh
# fix-c-code.sh File.c ... - the C code of fbc for clang on macOS and iOS: an Error statement without a resume address
# gives "goto *" in a function without labels of addresses, which clang rejects. fb_ErrorThrowEx does not return there
# (without a handler it ends the program), so the jump is not needed
perl -0pi -e 's/(void\* (vr\$\d+) = fb_ErrorThrowEx\([^\n]*\(void\*\)0ull, \(void\*\)0ull \);\s*)goto \*\2;/$1(void)$2;/g' "$@"
