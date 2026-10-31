#!/bin/sh
# patch-fbc-rtlib.sh FbcDir - the runtime of FreeBASIC on macOS and iOS: the cycle profiler uses a section and the
# __start_/__stop_ symbols of ELF, Mach-O has its own ones
set -e
F="$1/src/rtlib/profile_cycles.c"
perl -0pi -e 's/extern char __start_fb_profilecycledata\[\];\s*extern char __stop_fb_profilecycledata;/#if defined(__APPLE__)\nextern char __start_fb_profilecycledata[] __asm("section\$start\$__DATA\$fb_profcycle");\nextern char __stop_fb_profilecycledata __asm("section\$end\$__DATA\$fb_profcycle");\n#define FB_PROFILE_SECTION "__DATA,fb_profcycle"\n#else\nextern char __start_fb_profilecycledata[];\nextern char __stop_fb_profilecycledata;\n#define FB_PROFILE_SECTION "fb_profilecycledata"\n#endif/; s/section\("fb_profilecycledata"\)/section(FB_PROFILE_SECTION)/' "$F"
grep -q 'section(FB_PROFILE_SECTION)' "$F"
grep -q 'section\$start\$__DATA\$fb_profcycle' "$F"
# iOS: system() is not available in its SDK, a program of iOS can not start another one (mff_no_system of mffUIKit.m)
if [ "$2" = "ios" ]; then
	for f in $(grep -lE '[^_a-zA-Z]system[[:space:]]*\(' "$1"/src/rtlib/*.c "$1"/src/rtlib/unix/*.c "$1"/src/rtlib/darwin/*.c 2>/dev/null); do
		perl -pi -e 's/(?<![_a-zA-Z])system\s*\(/mff_no_system(/g' "$f"
		perl -0pi -e 's/\A/int mff_no_system(const char *);\n/' "$f"
	done
fi
