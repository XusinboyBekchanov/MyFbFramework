'' plug-static.bas
''
'' Copyright 2023 by Jeff Marshall
''   coder[at]execulink.com

#if __FB_OUT_DLL__ = 0

#include once "fbsound/fbs-config.bi"
#include once "fbsound/fbstypes.bi"
#include once "fbsound/plug.bi"
#include once "fbsound/plug-static.bi"

#ifndef NULL
	#define NULL 0
#endif

namespace fbsound.cdtor

dim shared head_cdtor as cdtor_struct ptr

private _
sub addNode( byval x as cdtor_struct ptr )
	dim as cdtor_struct ptr n = head_cdtor
	dim as cdtor_struct ptr ptr p = @head_cdtor
	while n
		if( n->group > x->group ) then
			exit while
		end if
		p = @(n->next)
		n = n->next
	wend
	*p = x
	x->next = n
end sub

private _
sub reverse()
	dim as cdtor_struct ptr n = head_cdtor, t = any
	head_cdtor = 0
	while n
		t = n->next
		n->next = head_cdtor
		head_cdtor = n
		n = t
	wend
end sub

public _
sub register cdecl _
	( _
		byval ctx as cdtor_struct ptr _
	)
	static initialized as boolean = false
	if not initialized then
		head_cdtor = 0
		initialized = true
	end if
	addNode( ctx )
end sub

public _
sub callctors cdecl ()
	dim ctx as cdtor_struct ptr = any

	ctx = head_cdtor
	do while ctx <> 0
		if ctx->ctorproc then
			ctx->ctorproc()
		end if
		ctx = ctx->next
	loop 

end sub

public _
sub calldtors cdecl ()
	dim ctx as cdtor_struct ptr = any
	reverse()
	ctx = head_cdtor
	do while ctx <> 0
		if ctx->dtorproc then
			ctx->dtorproc()
		end if
		ctx = ctx->next
	loop 
	reverse()
end sub

#if defined( DEBUG ) or ( __FB_DEBUG__ <> 0 )

public _
sub dump cdecl ()
	dim ctx as cdtor_struct ptr = head_cdtor 
	print "CDTORS:"
	do while ctx <> 0
		if ctx->ctorproc then
			print hex(ctx->dtorproc,sizeof(any ptr)*2),
		else
			print hex(0,sizeof(any ptr)*2),
		end if
		if ctx->dtorproc then
			print hex(ctx->ctorproc,sizeof(any ptr)*2),
		else
			print hex(0,sizeof(any ptr)*2),
		end if
		print ctx->group,
		if ctx->module then
			print *ctx->module
		else
			print "<unnamed>"
		end if
		ctx = ctx->next
	loop 
end sub

#endif 

public _
function getnext_cdtor cdecl _
	( _
		byval ctx as const cdtor_struct ptr _
	) as const cdtor_struct ptr
	return ctx->next 
end function

public _
function getfirst_cdtor cdecl _
	( _
	) as const cdtor_struct ptr
	return head_cdtor
end function

private _
function find_plugin cdecl _
	( _
		byval ctx as const cdtor_struct ptr _
	) as const cdtor_struct ptr
	ctx = iif( ctx = NULL, head_cdtor, ctx->next )
	do while ctx
		select case ctx->group
		case MODULE_PLUGIN1, MODULE_PLUGIN2, MODULE_PLUGIN3
			return ctx
		end select
		ctx = ctx->next
	loop
	return NULL
end function

public _
function getfirst_plugin cdecl _
	( _
	) as const cdtor_struct ptr
	return find_plugin( NULL )
end function

public _
function getnext_plugin cdecl _
	( _
		byval ctx as const cdtor_struct ptr _
	) as const cdtor_struct ptr
	return find_plugin( ctx )
end function

end namespace '' fbsound.cdtor

#endif
