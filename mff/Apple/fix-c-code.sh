#!/bin/sh
# fix-c-code.sh File.c ... - the C code of fbc for clang on macOS and iOS (arm64):
# - fbc clears a Cva_List as the 32 bytes of va_list of AArch64; on Apple it is a pointer of 8 bytes, the other bytes are
#   the variables next to it
# - an Error statement without a resume address gives "goto *" in a function without labels of addresses, which clang
#   rejects. fb_ErrorThrowEx does not return there (without a handler it ends the program), so the jump is not needed
perl -0pi -e 's/(__builtin_va_list ([^\s;]+);\s*__builtin_memset\(\s*&\2,\s*0,\s*)32ll/$1sizeof(__builtin_va_list)/g; s/(void\* (vr\$\d+) = fb_ErrorThrowEx\([^\n]*\(void\*\)0ull, \(void\*\)0ull \);\s*)goto \*\2;/$1(void)$2;/g' "$@"
