#ifndef __FBS_PLUG_STATIC_BI__
#define __FBS_PLUG_STATIC_BI__

'' plug-static.bi
''
'' Copyright 2023 by Jeff Marshall
''   coder[at]execulink.com

#include once "plug-cdtor.bi"

#if __FB_OUT_DLL__ = 0

namespace fbsound.cdtor

enum module_group
	MODULE_NONE = 0
	MODULE_MAIN    = 1
	MODULE_SUPPORT = 2
	MODULE_PLUGIN1  = 3
	MODULE_PLUGIN2  = 4
	MODULE_PLUGIN3  = 5
end enum

type cdtor_struct
	ctorproc as sub cdecl ()
	dtorproc as sub cdecl ()
	module as zstring ptr
	group as module_group
	plug_filler as function cdecl( byref plug as FBS_PLUG ) as boolean
	next as cdtor_struct ptr 
end type

declare sub register cdecl _
	( _
		byval cdtor_ctx as cdtor_struct ptr _
	)

declare sub callctors cdecl ()
declare sub calldtors cdecl ()

#if defined( DEBUG ) or ( __FB_DEBUG__ <> 0 )
declare sub dump cdecl ()
#endif

declare function getfirst_cdtor cdecl _
	(_
	) as const cdtor_struct ptr

declare function getnext_cdtor cdecl _
	( _
		byval cdtor as const cdtor_struct ptr _
	) as const cdtor_struct ptr

declare function getfirst_plugin cdecl _
	( _
	) as const cdtor_struct ptr

declare function getnext_plugin cdecl _
	( _
		byval cdtor as const cdtor_struct ptr _
	) as const cdtor_struct ptr

end namespace

#endif ' __FB_OUT_DLL__ = 0

#endif ' __FBS_PLUG_STATIC_BI__