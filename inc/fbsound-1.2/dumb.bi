#ifndef __DUMB_BI__
#define __DUMB_BI__

'  ###########
' # dumb.bi #
'###########

#include once "fbstypes.bi"

#ifndef NO_MOD

#inclib "dumb"

extern "c"

declare sub dumb_exit()

declare sub dumb_register_stdfiles()

declare function load_duh( _
byval filename as const zstring ptr) as any ptr

declare function dumb_load_it( _
byval filename as const zstring ptr) as any ptr

declare function dumb_load_xm( _
byval filename as const zstring ptr) as any ptr

declare function dumb_load_s3m( _
byval filename as const zstring ptr) as any ptr

declare function dumb_load_mod( _
byval filename as const zstring ptr) as any ptr

declare function duh_get_length( _
byval pDuh as any ptr) as clong

declare sub unload_duh( _
byval pDuh as any ptr)

declare function duh_start_sigrenderer( _
byval pDuh      as any ptr, _
byval sig       as long, _
byval nChannels as long, _
byval aPos      as long) as any ptr

declare function duh_render( _
byval pMod      as any ptr, _
byval bits      as long, _
byval unsign    as long, _
byval volume    as single, _
byval delta     as single, _
byval nSamples  as clong, _
byval buffer    as any ptr) as long

declare sub duh_end_sigrenderer( _
byval pMod as any ptr)

declare function dumb_it_callback_terminate( _
byval pData as any ptr) as long

declare function duh_get_it_sigrenderer( _
byval pMod as any ptr) as any ptr

declare sub dumb_it_set_loop_callback( _
byval pIt      as any ptr, _
byval callback as any ptr, _
byval userdata as any ptr)

declare sub dumb_it_set_xm_speed_zero_callback( _
byval pIt      as any ptr, _
byval callback as any ptr, _
byval userdata as any ptr)

end extern

#endif ' NO_MOD

#endif ' __DUMB_BI__
