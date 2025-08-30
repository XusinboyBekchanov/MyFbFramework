'' plug-static.bas
''
'' Copyright 2023 by Jeff Marshall
''   coder[at]execulink.com

#if __FB_OUT_DLL__ = 0

#include once "fbs-config.bi"
#include once "fbstypes.bi"
#include once "plug.bi"
#include once "plug-static.bi"

#ifndef NULL
	#define NULL 0
#endif

Namespace fbsound.cdtor

Dim Shared head_cdtor As cdtor_struct Ptr

Private _
Sub addNode( ByVal x As cdtor_struct Ptr )
	Dim As cdtor_struct Ptr n = head_cdtor
	Dim As cdtor_struct Ptr Ptr p = @head_cdtor
	While n
		If( n->group > x->group ) Then
			Exit While
		End If
		p = @(n->next)
		n = n->next
	Wend
	*p = x
	x->next = n
End Sub

Private _
Sub reverse()
	Dim As cdtor_struct Ptr n = head_cdtor, t = Any
	head_cdtor = 0
	While n
		t = n->next
		n->next = head_cdtor
		head_cdtor = n
		n = t
	Wend
End Sub

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
