#pragma once

#include once "crt/long.bi"
#include once "win/rpc.bi"
#include once "win/winapifamily.bi"
'#include once "pshpack8.bi"
#include once "win/basetsd.bi"
#include once "win/rpcnsip.bi"
'#include once "win/rpcsal.bi"
'#include once "win/poppack.bi"
#include once "win/objidl.bi"
#include once "win/oaidl.bi"
#include once "crt/long.bi" 
'#include once "EventToken.bi"
#inclib "WebView2Loader.dll"

Extern "C"

Const __REQUIRED_RPCNDR_H_VERSION__ = 475
'Const __RPCNDR_H_VERSION__ = 500
#define __RPCNDR_H__
'Const NDR_CHAR_REP_MASK = Cast(culong, Cast(clong, &h0000000F))
'Const NDR_INT_REP_MASK = Cast(culong, Cast(clong, &h000000F0))
'Const NDR_FLOAT_REP_MASK = Cast(culong, Cast(clong, &h0000FF00))
'Const NDR_LITTLE_ENDIAN = Cast(culong, Cast(clong, &h00000010))
'Const NDR_BIG_ENDIAN = Cast(culong, Cast(clong, &h00000000))
'Const NDR_IEEE_FLOAT = Cast(culong, Cast(clong, &h00000000))
'Const NDR_VAX_FLOAT = Cast(culong, Cast(clong, &h00000100))
'Const NDR_IBM_FLOAT = Cast(culong, Cast(clong, &h00000300))
'Const NDR_ASCII_CHAR = Cast(culong, Cast(clong, &h00000000))
'Const NDR_EBCDIC_CHAR = Cast(culong, Cast(clong, &h00000001))
'Const NDR_LOCAL_DATA_REPRESENTATION = Cast(culong, Cast(clong, &h00000010))
Const NDR_LOCAL_ENDIAN = NDR_LITTLE_ENDIAN
Const TARGET_IS_NT100_OR_LATER = 0
Const TARGET_IS_NT63_OR_LATER = 0
Const TARGET_IS_NT62_OR_LATER = 0
Const TARGET_IS_NT61_OR_LATER = 0
Const TARGET_IS_NT60_OR_LATER = 0
'Const TARGET_IS_NT51_OR_LATER = 0
'Const TARGET_IS_NT50_OR_LATER = 0
'Const TARGET_IS_NT40_OR_LATER = 0
'Const TARGET_IS_NT351_OR_WIN95_OR_LATER = 0

Type small As ZString
Type Byte_ As UByte
Type cs_byte_ As Byte
Type Boolean_ As UByte
#define _HYPER_DEFINED

#if defined(__FB_DOS__) Or ((Not defined(__FB_64BIT__)) And (defined(__FB_DARWIN__) Or defined(__FB_CYGWIN__) Or ((Not defined(__FB_ARM__)) And (defined(__FB_LINUX__) Or defined(__FB_FREEBSD__) Or defined(__FB_OPENBSD__) Or defined(__FB_NETBSD__)))))
	Type hyper As Double
	Type MIDL_uhyper As Double
#else
	Type hyper As LongInt
	'' TODO: #define MIDL_uhyper unsigned __int64
#endif

Type wchar_t As UShort
#define _WCHAR_T_DEFINED
'Type size_t_ As ULong
#define _SIZE_T_DEFINED
'#define midl_user_allocate midl_user_allocate
'#define midl_user_free midl_user_free
#define __MIDL_USER_DEFINED

'' TODO: _Must_inspect_result_ _Ret_maybenull_ _Post_writable_byte_size_(size)void * __RPC_USER MIDL_user_allocate(_In_ size_t size);
'' TODO: void __RPC_USER MIDL_user_free( _Pre_maybenull_ _Post_invalid_ void * );
'' TODO: _Ret_maybenull_ _Post_writable_byte_size_(size)void * __RPC_USER I_RpcDefaultAllocate( handle_t bh, size_t size, void * (* RealAlloc)(size_t) );
'' TODO: void __RPC_USER I_RpcDefaultFree( handle_t bh, void *, void (*RealFree)(void *) );
#define RPC_VAR_ENTRY __cdecl

#if defined(__FB_ARM__) And (defined(__FB_LINUX__) Or defined(__FB_FREEBSD__) Or defined(__FB_OPENBSD__) Or defined(__FB_NETBSD__))
	#define __MIDL_DECLSPEC_DLLIMPORT
	#define __MIDL_DECLSPEC_DLLEXPORT
#else
	#define __MIDL_DECLSPEC_DLLIMPORT __declspec(dllimport)
	#define __MIDL_DECLSPEC_DLLEXPORT __declspec(dllexport)
#endif

Type NDR_CCONTEXT As Any Ptr

Type _0
	pad(0 To 1) As Any Ptr
	userContext As Any Ptr
End Type

'Type NDR_SCONTEXT As _0 Ptr
'#define NDRSContextValue(hContext) (@(hContext)->userContext)
Const cbNDRContext = 20
'' TODO: typedef void (__RPC_USER * NDR_RUNDOWN)(void * context);
'' TODO: typedef void (__RPC_USER * NDR_NOTIFY_ROUTINE)(void);
'' TODO: typedef void (__RPC_USER * NDR_NOTIFY2_ROUTINE)(boolean flag);

'Type _SCONTEXT_QUEUE
'	NumberOfObjects As culong
'	ArrayOfObjects As NDR_SCONTEXT Ptr
'End Type

Type SCONTEXT_QUEUE As _SCONTEXT_QUEUE
Type PSCONTEXT_QUEUE As _SCONTEXT_QUEUE Ptr
'' TODO: RPCRTAPI RPC_BINDING_HANDLE RPC_ENTRY NDRCContextBinding ( _In_ NDR_CCONTEXT CContext );
'' TODO: RPCRTAPI void RPC_ENTRY NDRCContextMarshall ( _In_opt_ NDR_CCONTEXT CContext, _Out_ void *pBuff );
'' TODO: RPCRTAPI void RPC_ENTRY NDRCContextUnmarshall ( _Inout_opt_ NDR_CCONTEXT * pCContext, _In_ RPC_BINDING_HANDLE hBinding, _In_ void * pBuff, _In_ unsigned long DataRepresentation );
'' TODO: RPCRTAPI void RPC_ENTRY NDRCContextUnmarshall2 ( _Inout_opt_ NDR_CCONTEXT * pCContext, _In_ RPC_BINDING_HANDLE hBinding, _In_ void * pBuff, _In_ unsigned long DataRepresentation );
'' TODO: RPCRTAPI void RPC_ENTRY NDRSContextMarshall ( _In_ NDR_SCONTEXT CContext, _Out_ void * pBuff, _In_ NDR_RUNDOWN userRunDownIn );
'' TODO: RPCRTAPI NDR_SCONTEXT RPC_ENTRY NDRSContextUnmarshall ( _In_ void * pBuff, _In_ unsigned long DataRepresentation );
'' TODO: RPCRTAPI void RPC_ENTRY NDRSContextMarshallEx ( _In_ RPC_BINDING_HANDLE BindingHandle, _In_ NDR_SCONTEXT CContext, _Out_ void * pBuff, _In_ NDR_RUNDOWN userRunDownIn );
'' TODO: RPCRTAPI void RPC_ENTRY NDRSContextMarshall2 ( _In_ RPC_BINDING_HANDLE BindingHandle, _In_ NDR_SCONTEXT CContext, _Out_ void * pBuff, _In_ NDR_RUNDOWN userRunDownIn, _In_opt_ void * CtxGuard, _In_ unsigned long Flags );
'' TODO: RPCRTAPI NDR_SCONTEXT RPC_ENTRY NDRSContextUnmarshallEx ( _In_ RPC_BINDING_HANDLE BindingHandle, _In_ void * pBuff, _In_ unsigned long DataRepresentation );
'' TODO: RPCRTAPI NDR_SCONTEXT RPC_ENTRY NDRSContextUnmarshall2( _In_ RPC_BINDING_HANDLE BindingHandle, _In_opt_ void * pBuff, _In_ unsigned long DataRepresentation, _In_opt_ void * CtxGuard, _In_ unsigned long Flags );
'' TODO: RPCRTAPI void RPC_ENTRY RpcSsDestroyClientContext ( _In_ void * * ContextHandle );

'#define byte_from_ndr(source, target) Scope : /' TODO: *(target) = *(*(char * *)&(source)->Buffer)++; '/ : End Scope
'#macro byte_array_from_ndr(Source, LowerIndex, UpperIndex, Target)
'	Scope
'		NDRcopy(CPtr(ZString Ptr, (Target)) + (LowerIndex), (Source)->Buffer, CULng((UpperIndex) - (LowerIndex)))
'		(*CPtr(culong Ptr, @(Source)->Buffer)) += (UpperIndex) - (LowerIndex)
'	End Scope
'#endmacro
'#define boolean_from_ndr(source, target) Scope : /' TODO: *(target) = *(*(char * *)&(source)->Buffer)++; '/ : End Scope
'#macro boolean_array_from_ndr(Source, LowerIndex, UpperIndex, Target)
'	Scope
'		NDRcopy(CPtr(ZString Ptr, (Target)) + (LowerIndex), (Source)->Buffer, CULng((UpperIndex) - (LowerIndex)))
'		(*CPtr(culong Ptr, @(Source)->Buffer)) += (UpperIndex) - (LowerIndex)
'	End Scope
'#endmacro
'#define small_from_ndr(source, target) Scope : /' TODO: *(target) = *(*(char * *)&(source)->Buffer)++; '/ : End Scope
'#define small_from_ndr_temp(source, target, format) Scope : /' TODO: *(target) = *(*(char * *)(source))++; '/ : End Scope
'#macro small_array_from_ndr(Source, LowerIndex, UpperIndex, Target)
'	Scope
'		NDRcopy(CPtr(ZString Ptr, (Target)) + (LowerIndex), (Source)->Buffer, CULng((UpperIndex) - (LowerIndex)))
'		(*CPtr(culong Ptr, @(Source)->Buffer)) += (UpperIndex) - (LowerIndex)
'	End Scope
'#endmacro
Type error_status_t As culong

'' TODO: #define _midl_ma1( p, cast ) *(*( cast **)&p)++
'' TODO: #define _midl_ma2( p, cast ) *(*( cast **)&p)++
'' TODO: #define _midl_ma4( p, cast ) *(*( cast **)&p)++
'' TODO: #define _midl_ma8( p, cast ) *(*( cast **)&p)++
'' TODO: #define _midl_unma1( p, cast ) *(( cast *)p)++
'' TODO: #define _midl_unma2( p, cast ) *(( cast *)p)++
'' TODO: #define _midl_unma3( p, cast ) *(( cast *)p)++
'' TODO: #define _midl_unma4( p, cast ) *(( cast *)p)++

#define _midl_fa2(p) Scope : p = Cast(RPC_BUFPTR, ULONG_PTR(p + 1) And (Not &h1)) : End Scope
#define _midl_fa4(p) Scope : p = Cast(RPC_BUFPTR, ULONG_PTR(p + 3) And (Not &h3)) : End Scope
#define _midl_fa8(p) Scope : p = Cast(RPC_BUFPTR, ULONG_PTR(p + 7) And (Not &h7)) : End Scope
#define _midl_addp(p, n) Scope : p += n : End Scope

'' TODO: #define _midl_marsh_lhs( p, cast ) *(*( cast **)&p)++
'' TODO: #define _midl_marsh_up( mp, p ) *(*(unsigned long **)&mp)++ = (unsigned long)p
'' TODO: #define _midl_advmp( mp ) *(*(unsigned long **)&mp)++
'' TODO: #define _midl_unmarsh_up( p ) (*(*(unsigned long **)&p)++)
'' TODO: #define NdrMarshConfStringHdr( p, s, l ) (_midl_ma4( p, unsigned long) = s, _midl_ma4( p, unsigned long) = 0, _midl_ma4( p, unsigned long) = l)
'' TODO: #define NdrUnMarshConfStringHdr(p, s, l) ((s=_midl_unma4(p,unsigned long), (_midl_addp(p,4)), (l=_midl_unma4(p,unsigned long))
#macro NdrMarshCCtxtHdl(pc, p)
	Scope
		NDRCContextMarshall(Cast(NDR_CCONTEXT, pc), p)
		p + 20
	End Scope
#endmacro
'' TODO: #define NdrUnMarshCCtxtHdl(pc,p,h,drep) (NDRCContextUnmarshall((NDR_CONTEXT)pc,h,p,drep), p+20)
#define NdrUnMarshSCtxtHdl(pc, p, drep) Scope : pc = NDRSContextUnmarshall(p, drep) : End Scope
'' TODO: #define NdrMarshSCtxtHdl(pc,p,rd) (NdrSContextMarshall((NDR_SCONTEXT)pc,p, (NDR_RUNDOWN)rd)
#define NdrFieldOffset(s, f) LONG_PTR(@CPtr(s Ptr, 0)->f)
#define NdrFieldPad(s, f, p, t) (Cast(culong, NdrFieldOffset(s, f) - NdrFieldOffset(s, p)) - SizeOf(t))
'' TODO: #define NdrFcShort(s) (unsigned char)(s & 0xff), (unsigned char)(s >> 8)
'' TODO: #define NdrFcLong(s) (unsigned char)(s & 0xff), (unsigned char)((s & 0x0000ff00) >> 8), (unsigned char)((s & 0x00ff0000) >> 16), (unsigned char)(s >> 24)
'#define RPC_BAD_STUB_DATA_EXCEPTION_FILTER ((((RpcExceptionCode() = STATUS_ACCESS_VIOLATION) OrElse (RpcExceptionCode() = STATUS_DATATYPE_MISALIGNMENT)) OrElse (RpcExceptionCode() = RPC_X_BAD_STUB_DATA)) OrElse (RpcExceptionCode() = RPC_S_INVALID_BOUND))
Type RPC_BUFPTR As UByte Ptr
Type RPC_LENGTH As culong
'' TODO: typedef void (__RPC_USER * EXPR_EVAL)( struct _MIDL_STUB_MESSAGE * );
Type PFORMAT_STRING As Const UByte Ptr

'Type ARRAY_INFO
'	Dimension As clong
'	BufferConformanceMark As culong Ptr
'	BufferVarianceMark As culong Ptr
'	MaxCountArray As culong Ptr
'	OffsetArray As culong Ptr
'	ActualCountArray As culong Ptr
'End Type

Type PARRAY_INFO As ARRAY_INFO Ptr
Type PNDR_ASYNC_MESSAGE As _NDR_ASYNC_MESSAGE Ptr
Type PNDR_CORRELATION_INFO As _NDR_CORRELATION_INFO Ptr
Type PFORMAT_STRING As Const UByte Ptr
Type MIDL_SYNTAX_INFO As _MIDL_SYNTAX_INFO
Type PMIDL_SYNTAX_INFO As _MIDL_SYNTAX_INFO Ptr
Type _MIDL_STUB_DESC As _MIDL_STUB_DESC_
Type _FULL_PTR_XLAT_TABLES As _FULL_PTR_XLAT_TABLES_

'Type _MIDL_STUB_MESSAGE
'	RpcMsg As PRPC_MESSAGE
'	Buffer As UByte Ptr
'	BufferStart As UByte Ptr
'	BufferEnd As UByte Ptr
'	BufferMark As UByte Ptr
'	BufferLength As culong
'	MemorySize As culong
'	Memory As UByte Ptr
'	IsClient As UByte
'	Pad As UByte
'	uFlags2 As UShort
'	ReuseBuffer As Long
'	pAllocAllNodesContext As NDR_ALLOC_ALL_NODES_CONTEXT Ptr
'	pPointerQueueState As NDR_POINTER_QUEUE_STATE Ptr
'	IgnoreEmbeddedPointers As Long
'	PointerBufferMark As UByte Ptr
'	CorrDespIncrement As UByte
'	uFlags As UByte
'	UniquePtrCount As UShort
'	MaxCount As ULONG_PTR
'	Offset As culong
'	ActualCount As culong
'	'' TODO: void * ( __RPC_API * pfnAllocate)( size_t );
'	'' TODO: void ( __RPC_API * pfnFree)(void *);
'	StackTop As UByte Ptr
'	pPresentedType As UByte Ptr
'	pTransmitType As UByte Ptr
'	SavedHandle As handle_t
'	StubDesc As Const _MIDL_STUB_DESC Ptr
'	FullPtrXlatTables As _FULL_PTR_XLAT_TABLES Ptr
'	FullPtrRefId As culong
'	PointerLength As culong
'	fInDontFree : 1 As Long
'	fDontCallFreeInst : 1 As Long
'	fUnused1 : 1 As Long
'	fHasReturn : 1 As Long
'	fHasExtensions : 1 As Long
'	fHasNewCorrDesc : 1 As Long
'	fIsIn : 1 As Long
'	fIsOut : 1 As Long
'	fIsOicf : 1 As Long
'	fBufferValid : 1 As Long
'	fHasMemoryValidateCallback : 1 As Long
'	fInFree : 1 As Long
'	fNeedMCCP : 1 As Long
'	fUnused2 : 3 As Long
'	fUnused3 : 16 As Long
'	dwDestContext As culong
'	pvDestContext As Any Ptr
'	SavedContextHandles As NDR_SCONTEXT Ptr
'	ParamNumber As clong
'	pRpcChannelBuffer As IRpcChannelBuffer Ptr
'	pArrayInfo As PARRAY_INFO
'	SizePtrCountArray As culong Ptr
'	SizePtrOffsetArray As culong Ptr
'	SizePtrLengthArray As culong Ptr
'	pArgQueue As Any Ptr
'	dwStubPhase As culong
'	LowStackMark As Any Ptr
'	pAsyncMsg As PNDR_ASYNC_MESSAGE
'	pCorrInfo As PNDR_CORRELATION_INFO
'	pCorrMemory As UByte Ptr
'	pMemoryList As Any Ptr
'	pCSInfo As INT_PTR
'	ConformanceMark As UByte Ptr
'	VarianceMark As UByte Ptr
'	Unused As INT_PTR
'	pContext As _NDR_PROC_CONTEXT Ptr
'	ContextHandleHash As Any Ptr
'	pUserMarshalList As Any Ptr
'	Reserved51_3 As INT_PTR
'	Reserved51_4 As INT_PTR
'	Reserved51_5 As INT_PTR
'End Type

Type MIDL_STUB_MESSAGE As _MIDL_STUB_MESSAGE
Type PMIDL_STUB_MESSAGE As _MIDL_STUB_MESSAGE Ptr
Type MIDL_STUB_MESSAGE As _MIDL_STUB_MESSAGE
Type PMIDL_STUB_MESSAGE As _MIDL_STUB_MESSAGE Ptr
'' TODO: typedef void * ( __RPC_API * GENERIC_BINDING_ROUTINE) (void *);
'' TODO: typedef void ( __RPC_API * GENERIC_UNBIND_ROUTINE) (void *, unsigned char *);

'Type _GENERIC_BINDING_ROUTINE_PAIR
'	pfnBind As GENERIC_BINDING_ROUTINE
'	pfnUnbind As GENERIC_UNBIND_ROUTINE
'End Type

Type GENERIC_BINDING_ROUTINE_PAIR As _GENERIC_BINDING_ROUTINE_PAIR
Type PGENERIC_BINDING_ROUTINE_PAIR As _GENERIC_BINDING_ROUTINE_PAIR Ptr

'Type __GENERIC_BINDING_INFO
'	pObj As Any Ptr
'	Size As ULong
'	pfnBind As GENERIC_BINDING_ROUTINE
'	pfnUnbind As GENERIC_UNBIND_ROUTINE
'End Type

Type GENERIC_BINDING_INFO As __GENERIC_BINDING_INFO
Type PGENERIC_BINDING_INFO As __GENERIC_BINDING_INFO Ptr
'' TODO: #define NDR_SHAREABLE static
'' TODO: typedef void ( __RPC_USER * XMIT_HELPER_ROUTINE) ( PMIDL_STUB_MESSAGE );

'type _XMIT_ROUTINE_QUINTUPLE
'	pfnTranslateToXmit As XMIT_HELPER_ROUTINE
'	pfnTranslateFromXmit As XMIT_HELPER_ROUTINE
'	pfnFreeXmit As XMIT_HELPER_ROUTINE
'	pfnFreeInst As XMIT_HELPER_ROUTINE
'End Type

Type XMIT_ROUTINE_QUINTUPLE As _XMIT_ROUTINE_QUINTUPLE
Type PXMIT_ROUTINE_QUINTUPLE As _XMIT_ROUTINE_QUINTUPLE Ptr
'' TODO: typedef unsigned long( __RPC_USER * USER_MARSHAL_SIZING_ROUTINE) (unsigned long *, unsigned long, void * );
'' TODO: typedef unsigned char *( __RPC_USER * USER_MARSHAL_MARSHALLING_ROUTINE) (unsigned long *, unsigned char * , void * );
'' TODO: typedef unsigned char *( __RPC_USER * USER_MARSHAL_UNMARSHALLING_ROUTINE) (unsigned long *, unsigned char *, void * );
'' TODO: typedef void ( __RPC_USER * USER_MARSHAL_FREEING_ROUTINE) (unsigned long *, void * );

'type _USER_MARSHAL_ROUTINE_QUADRUPLE
'	pfnBufferSize As USER_MARSHAL_SIZING_ROUTINE
'	pfnMarshall As USER_MARSHAL_MARSHALLING_ROUTINE
'	pfnUnmarshall As USER_MARSHAL_UNMARSHALLING_ROUTINE
'	pfnFree As USER_MARSHAL_FREEING_ROUTINE
'End Type

Type USER_MARSHAL_ROUTINE_QUADRUPLE As _USER_MARSHAL_ROUTINE_QUADRUPLE
'#define USER_MARSHAL_CB_SIGNATURE Asc("USRC")

Type _USER_MARSHAL_CB_TYPE As Long
'Enum
	'USER_MARSHAL_CB_BUFFER_SIZE
	'USER_MARSHAL_CB_MARSHALL
	'USER_MARSHAL_CB_UNMARSHALL
	'USER_MARSHAL_CB_FREE
'End Enum

Type USER_MARSHAL_CB_TYPE As _USER_MARSHAL_CB_TYPE

'type _USER_MARSHAL_CB
'	Flags As culong
'	pStubMsg As PMIDL_STUB_MESSAGE
'	pReserve As PFORMAT_STRING
'	Signature As culong
'	CBType As USER_MARSHAL_CB_TYPE
'	pFormat As PFORMAT_STRING
'	pTypeFormat As PFORMAT_STRING
'End Type

Type USER_MARSHAL_CB As _USER_MARSHAL_CB
'#define USER_CALL_CTXT_MASK(f) ((f) And &h00ff)
'#define USER_CALL_AUX_MASK(f) ((f) And &hff00)
'#define GET_USER_DATA_REP(f) ((f) Shr 16)
Const USER_CALL_IS_ASYNC = &h0100
Const USER_CALL_NEW_CORRELATION_DESC = &h0200

'Type _MALLOC_FREE_STRUCT
'	'' TODO: void * ( __RPC_USER * pfnAllocate)(size_t);
'	'' TODO: void ( __RPC_USER * pfnFree)(void *);
'End Type

Type MALLOC_FREE_STRUCT As _MALLOC_FREE_STRUCT

'type _COMM_FAULT_OFFSETS
'	CommOffset As Short
'	FaultOffset As Short
'End Type

Type COMM_FAULT_OFFSETS As _COMM_FAULT_OFFSETS

Type _IDL_CS_CONVERT As Long
'Enum
'	IDL_CS_NO_CONVERT
'	IDL_CS_IN_PLACE_CONVERT
'	IDL_CS_NEW_BUFFER_CONVERT
'End Enum

Type IDL_CS_CONVERT As _IDL_CS_CONVERT
'' TODO: typedef void( __RPC_USER * CS_TYPE_NET_SIZE_ROUTINE) (RPC_BINDING_HANDLE hBinding, unsigned long ulNetworkCodeSet, unsigned long ulLocalBufferSize, IDL_CS_CONVERT * conversionType, unsigned long * pulNetworkBufferSize, error_status_t * pStatus);
'' TODO: typedef void( __RPC_USER * CS_TYPE_LOCAL_SIZE_ROUTINE) (RPC_BINDING_HANDLE hBinding, unsigned long ulNetworkCodeSet, unsigned long ulNetworkBufferSize, IDL_CS_CONVERT * conversionType, unsigned long * pulLocalBufferSize, error_status_t * pStatus);
'' TODO: typedef void( __RPC_USER * CS_TYPE_TO_NETCS_ROUTINE) (RPC_BINDING_HANDLE hBinding, unsigned long ulNetworkCodeSet, void * pLocalData, unsigned long ulLocalDataLength, byte * pNetworkData, unsigned long * pulNetworkDataLength, error_status_t * pStatus);
'' TODO: typedef void( __RPC_USER * CS_TYPE_FROM_NETCS_ROUTINE) (RPC_BINDING_HANDLE hBinding, unsigned long ulNetworkCodeSet, byte * pNetworkData, unsigned long ulNetworkDataLength, unsigned long ulLocalBufferSize, void * pLocalData, unsigned long * pulLocalDataLength, error_status_t * pStatus);
'' TODO: typedef void( __RPC_USER * CS_TAG_GETTING_ROUTINE) (RPC_BINDING_HANDLE hBinding, int fServerSide, unsigned long * pulSendingTag, unsigned long * pulDesiredReceivingTag, unsigned long * pulReceivingTag, error_status_t * pStatus);
'' TODO: void __RPC_USER RpcCsGetTags( RPC_BINDING_HANDLE hBinding, int fServerSide, unsigned long * pulSendingTag, unsigned long * pulDesiredReceivingTag, unsigned long * pulReceivingTag, error_status_t * pStatus);

'Type _NDR_CS_SIZE_CONVERT_ROUTINES
'	pfnNetSize As CS_TYPE_NET_SIZE_ROUTINE
'	pfnToNetCs As CS_TYPE_TO_NETCS_ROUTINE
'	pfnLocalSize As CS_TYPE_LOCAL_SIZE_ROUTINE
'	pfnFromNetCs As CS_TYPE_FROM_NETCS_ROUTINE
'End Type

Type NDR_CS_SIZE_CONVERT_ROUTINES As _NDR_CS_SIZE_CONVERT_ROUTINES

'Type _NDR_CS_ROUTINES
'	pSizeConvertRoutines As NDR_CS_SIZE_CONVERT_ROUTINES Ptr
'	pTagGettingRoutines As CS_TAG_GETTING_ROUTINE Ptr
'End Type

Type NDR_CS_ROUTINES As _NDR_CS_ROUTINES

Type _NDR_EXPR_DESC
	pOffset As Const UShort Ptr
	pFormatExpr As PFORMAT_STRING
End Type

Type NDR_EXPR_DESC As _NDR_EXPR_DESC

'union _MIDL_STUB_DESC_IMPLICIT_HANDLE_INFO
'	pAutoHandle As handle_t Ptr
'	pPrimitiveHandle As handle_t Ptr
'	pGenericBindingInfo As PGENERIC_BINDING_INFO
'End Union

'Type _MIDL_STUB_DESC_
'	RpcInterfaceInformation As Any Ptr
'	'' TODO: void * ( __RPC_API * pfnAllocate)(size_t);
'	'' TODO: void ( __RPC_API * pfnFree)(void *);
'	IMPLICIT_HANDLE_INFO As _MIDL_STUB_DESC_IMPLICIT_HANDLE_INFO
'	apfnNdrRundownRoutines As Const NDR_RUNDOWN Ptr
'	aGenericBindingRoutinePairs As Const GENERIC_BINDING_ROUTINE_PAIR Ptr
'	apfnExprEval As Const EXPR_EVAL Ptr
'	aXmitQuintuple As Const XMIT_ROUTINE_QUINTUPLE Ptr
'	pFormatTypes As Const UByte Ptr
'	fCheckBounds As Long
'	Version As culong
'	pMallocFreeStruct As MALLOC_FREE_STRUCT Ptr
'	MIDLVersion As clong
'	CommFaultOffsets As Const COMM_FAULT_OFFSETS Ptr
'	aUserMarshalQuadruple As Const USER_MARSHAL_ROUTINE_QUADRUPLE Ptr
'	NotifyRoutineTable As Const NDR_NOTIFY_ROUTINE Ptr
'	mFlags As ULONG_PTR
'	CsRoutineTables As Const NDR_CS_ROUTINES Ptr
'	ProxyServerInfo As Any Ptr
'	pExprInfo As Const NDR_EXPR_DESC Ptr
'End Type

Type MIDL_STUB_DESC As _MIDL_STUB_DESC
Type PMIDL_STUB_DESC As Const MIDL_STUB_DESC Ptr
Type PMIDL_XMIT_TYPE As Any Ptr
'' TODO: typedef void ( __RPC_API * STUB_THUNK)( PMIDL_STUB_MESSAGE );
'' TODO: typedef long ( __RPC_API * SERVER_ROUTINE)();

Type _MIDL_METHOD_PROPERTY
	Id As culong
	Value As ULONG_PTR
End Type

Type MIDL_METHOD_PROPERTY As _MIDL_METHOD_PROPERTY
Type PMIDL_METHOD_PROPERTY As _MIDL_METHOD_PROPERTY Ptr

Type _MIDL_METHOD_PROPERTY_MAP
	Count As culong
	Properties As Const MIDL_METHOD_PROPERTY Ptr
End Type

Type MIDL_METHOD_PROPERTY_MAP As _MIDL_METHOD_PROPERTY_MAP
Type PMIDL_METHOD_PROPERTY_MAP As _MIDL_METHOD_PROPERTY_MAP Ptr

Type _MIDL_INTERFACE_METHOD_PROPERTIES
	MethodCount As UShort
	MethodProperties As Const MIDL_METHOD_PROPERTY_MAP Const Ptr Ptr
End Type

Type MIDL_INTERFACE_METHOD_PROPERTIES As _MIDL_INTERFACE_METHOD_PROPERTIES

'type _MIDL_SERVER_INFO_
'	pStubDesc As PMIDL_STUB_DESC
'	DispatchTable As Const SERVER_ROUTINE Ptr
'	ProcString As PFORMAT_STRING
'	FmtStringOffset As Const UShort Ptr
'	ThunkTable As Const STUB_THUNK Ptr
'	pTransferSyntax As PRPC_SYNTAX_IDENTIFIER
'	nCount As ULONG_PTR
'	pSyntaxInfo As PMIDL_SYNTAX_INFO
'End Type

Type MIDL_SERVER_INFO As _MIDL_SERVER_INFO_
Type PMIDL_SERVER_INFO As _MIDL_SERVER_INFO_ Ptr
#undef _MIDL_STUBLESS_PROXY_INFO

Type _MIDL_STUBLESS_PROXY_INFO
	pStubDesc As PMIDL_STUB_DESC
	ProcFormatString As PFORMAT_STRING
	FormatStringOffset As Const UShort Ptr
	pTransferSyntax As PRPC_SYNTAX_IDENTIFIER
	nCount As ULONG_PTR
	pSyntaxInfo As PMIDL_SYNTAX_INFO
End Type

'type MIDL_STUBLESS_PROXY_INFO as _MIDL_STUBLESS_PROXY_INFO
Type PMIDL_STUBLESS_PROXY_INFO As MIDL_STUBLESS_PROXY_INFO Ptr

'Type _MIDL_SYNTAX_INFO
'	TransferSyntax As RPC_SYNTAX_IDENTIFIER
'	DispatchTable As RPC_DISPATCH_TABLE Ptr
'	ProcString As PFORMAT_STRING
'	FmtStringOffset As Const UShort Ptr
'	TypeString As PFORMAT_STRING
'	aUserMarshalQuadruple As Const Any Ptr
'	pMethodProperties As Const MIDL_INTERFACE_METHOD_PROPERTIES Ptr
'	pReserved2 As ULONG_PTR
'End Type

Type MIDL_SYNTAX_INFO As _MIDL_SYNTAX_INFO
Type PMIDL_SYNTAX_INFO As _MIDL_SYNTAX_INFO Ptr
Type PARAM_OFFSETTABLE As UShort Ptr
Type PPARAM_OFFSETTABLE As UShort Ptr

'Union _CLIENT_CALL_RETURN
'	Pointer As Any Ptr
'	Simple As LONG_PTR
'End Union

Type CLIENT_CALL_RETURN As _CLIENT_CALL_RETURN

Type XLAT_SIDE As Long
'Enum
'	XLAT_SERVER = 1
'	XLAT_CLIENT
'End Enum

'Type _FULL_PTR_XLAT_TABLES_
'	RefIdToPointer As Any Ptr
'	PointerToRefId As Any Ptr
'	NextRefId As culong
'	XlatSide As XLAT_SIDE
'End Type

Type FULL_PTR_XLAT_TABLES As _FULL_PTR_XLAT_TABLES
Type PFULL_PTR_XLAT_TABLES As _FULL_PTR_XLAT_TABLES Ptr

Type _system_handle_t As Long
Enum
	SYSTEM_HANDLE_FILE = 0
	SYSTEM_HANDLE_SEMAPHORE = 1
	SYSTEM_HANDLE_EVENT = 2
	SYSTEM_HANDLE_MUTEX = 3
	SYSTEM_HANDLE_PROCESS = 4
	SYSTEM_HANDLE_TOKEN = 5
	SYSTEM_HANDLE_SECTION = 6
	SYSTEM_HANDLE_REG_KEY = 7
	SYSTEM_HANDLE_THREAD = 8
	SYSTEM_HANDLE_COMPOSITION_OBJECT = 9
	SYSTEM_HANDLE_SOCKET = 10
	SYSTEM_HANDLE_JOB = 11
	SYSTEM_HANDLE_INVALID = &hFF
End Enum

Type system_handle_t As _system_handle_t

Enum
	MidlInterceptionInfoVersionOne = 1
End Enum

Enum
	MidlWinrtTypeSerializationInfoVersionOne = 1
End Enum

Const MIDL_WINRT_TYPE_SERIALIZATION_INFO_CURRENT_VERSION = MidlWinrtTypeSerializationInfoVersionOne

Type _MIDL_INTERCEPTION_INFO
	Version As culong
	ProcString As PFORMAT_STRING
	ProcFormatOffsetTable As Const UShort Ptr
	ProcCount As culong
	TypeString As PFORMAT_STRING
End Type

Type MIDL_INTERCEPTION_INFO As _MIDL_INTERCEPTION_INFO
Type PMIDL_INTERCEPTION_INFO As _MIDL_INTERCEPTION_INFO Ptr

Type _MIDL_WINRT_TYPE_SERIALIZATION_INFO
	Version As culong
	TypeFormatString As PFORMAT_STRING
	FormatStringSize As UShort
	TypeOffset As UShort
	StubDesc As PMIDL_STUB_DESC
End Type

Type MIDL_WINRT_TYPE_SERIALIZATION_INFO As _MIDL_WINRT_TYPE_SERIALIZATION_INFO
Type PMIDL_WINRT_TYPE_SERIALIZATION_INFO As _MIDL_WINRT_TYPE_SERIALIZATION_INFO Ptr
'' TODO: RPC_STATUS RPC_ENTRY NdrClientGetSupportedSyntaxes( _In_ RPC_CLIENT_INTERFACE * pInf, _Out_ unsigned long * pCount, _Out_ MIDL_SYNTAX_INFO ** pArr );
'' TODO: RPC_STATUS RPC_ENTRY NdrServerGetSupportedSyntaxes( _In_ RPC_SERVER_INTERFACE * pInf, _Out_ unsigned long * pCount, _Out_ MIDL_SYNTAX_INFO ** pArr, _Out_ unsigned long * pPreferSyntaxIndex);
'' TODO: RPCRTAPI void RPC_ENTRY NdrSimpleTypeMarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, unsigned char FormatChar );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrPointerMarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrCsArrayMarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrCsTagMarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrSimpleStructMarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrConformantStructMarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrConformantVaryingStructMarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrComplexStructMarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrFixedArrayMarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrConformantArrayMarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrConformantVaryingArrayMarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrVaryingArrayMarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrComplexArrayMarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrNonConformantStringMarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrConformantStringMarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrEncapsulatedUnionMarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrNonEncapsulatedUnionMarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrByteCountPointerMarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrXmitOrRepAsMarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrUserMarshalMarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrInterfacePointerMarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrClientContextMarshall( PMIDL_STUB_MESSAGE pStubMsg, NDR_CCONTEXT ContextHandle, int fCheck );
'' TODO: RPCRTAPI void RPC_ENTRY NdrServerContextMarshall( PMIDL_STUB_MESSAGE pStubMsg, NDR_SCONTEXT ContextHandle, NDR_RUNDOWN RundownRoutine );
'' TODO: RPCRTAPI void RPC_ENTRY NdrServerContextNewMarshall( PMIDL_STUB_MESSAGE pStubMsg, NDR_SCONTEXT ContextHandle, NDR_RUNDOWN RundownRoutine, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrSimpleTypeUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, unsigned char FormatChar );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrCsArrayUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char ** ppMemory, PFORMAT_STRING pFormat, unsigned char fMustAlloc );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrCsTagUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char ** ppMemory, PFORMAT_STRING pFormat, unsigned char fMustAlloc );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrRangeUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char ** ppMemory, PFORMAT_STRING pFormat, unsigned char fMustAlloc );
'' TODO: RPCRTAPI void RPC_ENTRY NdrCorrelationInitialize( PMIDL_STUB_MESSAGE pStubMsg, void * pMemory, unsigned long CacheSize, unsigned long flags );
'' TODO: RPCRTAPI void RPC_ENTRY NdrCorrelationPass( PMIDL_STUB_MESSAGE pStubMsg );
'' TODO: RPCRTAPI void RPC_ENTRY NdrCorrelationFree( PMIDL_STUB_MESSAGE pStubMsg );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrPointerUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * * ppMemory, PFORMAT_STRING pFormat, unsigned char fMustAlloc );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrSimpleStructUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * * ppMemory, PFORMAT_STRING pFormat, unsigned char fMustAlloc );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrConformantStructUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * * ppMemory, PFORMAT_STRING pFormat, unsigned char fMustAlloc );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrConformantVaryingStructUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * * ppMemory, PFORMAT_STRING pFormat, unsigned char fMustAlloc );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrComplexStructUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * * ppMemory, PFORMAT_STRING pFormat, unsigned char fMustAlloc );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrFixedArrayUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * * ppMemory, PFORMAT_STRING pFormat, unsigned char fMustAlloc );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrConformantArrayUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * * ppMemory, PFORMAT_STRING pFormat, unsigned char fMustAlloc );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrConformantVaryingArrayUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * * ppMemory, PFORMAT_STRING pFormat, unsigned char fMustAlloc );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrVaryingArrayUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * * ppMemory, PFORMAT_STRING pFormat, unsigned char fMustAlloc );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrComplexArrayUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * * ppMemory, PFORMAT_STRING pFormat, unsigned char fMustAlloc );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrNonConformantStringUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * * ppMemory, PFORMAT_STRING pFormat, unsigned char fMustAlloc );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrConformantStringUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * * ppMemory, PFORMAT_STRING pFormat, unsigned char fMustAlloc );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrEncapsulatedUnionUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * * ppMemory, PFORMAT_STRING pFormat, unsigned char fMustAlloc );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrNonEncapsulatedUnionUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * * ppMemory, PFORMAT_STRING pFormat, unsigned char fMustAlloc );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrByteCountPointerUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * * ppMemory, PFORMAT_STRING pFormat, unsigned char fMustAlloc );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrXmitOrRepAsUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * * ppMemory, PFORMAT_STRING pFormat, unsigned char fMustAlloc );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrUserMarshalUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * * ppMemory, PFORMAT_STRING pFormat, unsigned char fMustAlloc );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrInterfacePointerUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * * ppMemory, PFORMAT_STRING pFormat, unsigned char fMustAlloc );
'' TODO: RPCRTAPI void RPC_ENTRY NdrClientContextUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, NDR_CCONTEXT * pContextHandle, RPC_BINDING_HANDLE BindHandle );
'' TODO: RPCRTAPI NDR_SCONTEXT RPC_ENTRY NdrServerContextUnmarshall( PMIDL_STUB_MESSAGE pStubMsg );
'' TODO: RPCRTAPI NDR_SCONTEXT RPC_ENTRY NdrContextHandleInitialize( _In_ PMIDL_STUB_MESSAGE pStubMsg, _In_reads_(_Inexpressible_(2)) PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI NDR_SCONTEXT RPC_ENTRY NdrServerContextNewUnmarshall( _In_ PMIDL_STUB_MESSAGE pStubMsg, _In_reads_(_Inexpressible_(2)) PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrPointerBufferSize( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrCsArrayBufferSize( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrCsTagBufferSize( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrSimpleStructBufferSize( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrConformantStructBufferSize( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrConformantVaryingStructBufferSize( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrComplexStructBufferSize( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrFixedArrayBufferSize( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrConformantArrayBufferSize( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrConformantVaryingArrayBufferSize( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrVaryingArrayBufferSize( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrComplexArrayBufferSize( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrConformantStringBufferSize( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrNonConformantStringBufferSize( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrEncapsulatedUnionBufferSize( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrNonEncapsulatedUnionBufferSize( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrByteCountPointerBufferSize( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrXmitOrRepAsBufferSize( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrUserMarshalBufferSize( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrInterfacePointerBufferSize( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrContextHandleSize( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned long RPC_ENTRY NdrPointerMemorySize( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned long RPC_ENTRY NdrContextHandleMemorySize( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned long RPC_ENTRY NdrCsArrayMemorySize( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned long RPC_ENTRY NdrCsTagMemorySize( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned long RPC_ENTRY NdrSimpleStructMemorySize( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned long RPC_ENTRY NdrConformantStructMemorySize( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned long RPC_ENTRY NdrConformantVaryingStructMemorySize( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned long RPC_ENTRY NdrComplexStructMemorySize( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned long RPC_ENTRY NdrFixedArrayMemorySize( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned long RPC_ENTRY NdrConformantArrayMemorySize( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned long RPC_ENTRY NdrConformantVaryingArrayMemorySize( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned long RPC_ENTRY NdrVaryingArrayMemorySize( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned long RPC_ENTRY NdrComplexArrayMemorySize( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned long RPC_ENTRY NdrConformantStringMemorySize( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned long RPC_ENTRY NdrNonConformantStringMemorySize( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned long RPC_ENTRY NdrEncapsulatedUnionMemorySize( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned long RPC_ENTRY NdrNonEncapsulatedUnionMemorySize( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned long RPC_ENTRY NdrXmitOrRepAsMemorySize( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned long RPC_ENTRY NdrUserMarshalMemorySize( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI unsigned long RPC_ENTRY NdrInterfacePointerMemorySize( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrPointerFree( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrCsArrayFree( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrSimpleStructFree( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrConformantStructFree( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrConformantVaryingStructFree( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrComplexStructFree( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrFixedArrayFree( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrConformantArrayFree( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrConformantVaryingArrayFree( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrVaryingArrayFree( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrComplexArrayFree( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrEncapsulatedUnionFree( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrNonEncapsulatedUnionFree( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrByteCountPointerFree( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrXmitOrRepAsFree( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrUserMarshalFree( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrInterfacePointerFree( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pMemory, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI void RPC_ENTRY NdrConvert2( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat, long NumberParams );
'' TODO: RPCRTAPI void RPC_ENTRY NdrConvert( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat );

Const USER_MARSHAL_FC_BYTE = 1
Const USER_MARSHAL_FC_CHAR = 2
Const USER_MARSHAL_FC_SMALL = 3
Const USER_MARSHAL_FC_USMALL = 4
Const USER_MARSHAL_FC_WCHAR = 5
Const USER_MARSHAL_FC_SHORT = 6
Const USER_MARSHAL_FC_USHORT = 7
Const USER_MARSHAL_FC_LONG = 8
Const USER_MARSHAL_FC_ULONG = 9
Const USER_MARSHAL_FC_FLOAT = 10
Const USER_MARSHAL_FC_HYPER = 11
Const USER_MARSHAL_FC_DOUBLE = 12

'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrUserMarshalSimpleTypeConvert( unsigned long * pFlags, unsigned char * pBuffer, unsigned char FormatChar );
'' TODO: RPCRTAPI void RPC_ENTRY NdrClientInitializeNew( PRPC_MESSAGE pRpcMsg, PMIDL_STUB_MESSAGE pStubMsg, PMIDL_STUB_DESC pStubDescriptor, unsigned int ProcNum );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrServerInitializeNew( PRPC_MESSAGE pRpcMsg, PMIDL_STUB_MESSAGE pStubMsg, PMIDL_STUB_DESC pStubDescriptor );
'' TODO: RPCRTAPI void RPC_ENTRY NdrServerInitializePartial( PRPC_MESSAGE pRpcMsg, PMIDL_STUB_MESSAGE pStubMsg, PMIDL_STUB_DESC pStubDescriptor, unsigned long RequestedBufferSize );
'' TODO: RPCRTAPI void RPC_ENTRY NdrClientInitialize( PRPC_MESSAGE pRpcMsg, PMIDL_STUB_MESSAGE pStubMsg, PMIDL_STUB_DESC pStubDescriptor, unsigned int ProcNum );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrServerInitialize( PRPC_MESSAGE pRpcMsg, PMIDL_STUB_MESSAGE pStubMsg, PMIDL_STUB_DESC pStubDescriptor );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrServerInitializeUnmarshall ( PMIDL_STUB_MESSAGE pStubMsg, PMIDL_STUB_DESC pStubDescriptor, PRPC_MESSAGE pRpcMsg );
'' TODO: RPCRTAPI void RPC_ENTRY NdrServerInitializeMarshall ( PRPC_MESSAGE pRpcMsg, PMIDL_STUB_MESSAGE pStubMsg );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrGetBuffer( PMIDL_STUB_MESSAGE pStubMsg, unsigned long BufferLength, RPC_BINDING_HANDLE Handle );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrNsGetBuffer( PMIDL_STUB_MESSAGE pStubMsg, unsigned long BufferLength, RPC_BINDING_HANDLE Handle );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrSendReceive( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pBufferEnd );
'' TODO: RPCRTAPI unsigned char *RPC_ENTRY NdrNsSendReceive( PMIDL_STUB_MESSAGE pStubMsg, unsigned char * pBufferEnd, RPC_BINDING_HANDLE * pAutoHandle );
'' TODO: RPCRTAPI void RPC_ENTRY NdrFreeBuffer( PMIDL_STUB_MESSAGE pStubMsg );
'' TODO: RPCRTAPI RPC_STATUS RPC_ENTRY NdrGetDcomProtocolVersion( PMIDL_STUB_MESSAGE pStubMsg, RPC_VERSION * pVersion );

#if defined(__FB_WIN32__) Or defined(__FB_CYGWIN__)
	'declare function NdrClientCall2(byval pStubDescriptor as PMIDL_STUB_DESC, byval pFormat as PFORMAT_STRING, ...) as CLIENT_CALL_RETURN
	'Declare Function NdrClientCall(ByVal pStubDescriptor As PMIDL_STUB_DESC, ByVal pFormat As PFORMAT_STRING, ...) As CLIENT_CALL_RETURN
	'Declare Function NdrAsyncClientCall(ByVal pStubDescriptor As PMIDL_STUB_DESC, ByVal pFormat As PFORMAT_STRING, ...) As CLIENT_CALL_RETURN
#else
	'' TODO: CLIENT_CALL_RETURN __cdecl NdrClientCall2( PMIDL_STUB_DESC pStubDescriptor, PFORMAT_STRING pFormat, ... );
	'' TODO: CLIENT_CALL_RETURN __cdecl NdrClientCall( PMIDL_STUB_DESC pStubDescriptor, PFORMAT_STRING pFormat, ... );
	'' TODO: CLIENT_CALL_RETURN __cdecl NdrAsyncClientCall( PMIDL_STUB_DESC pStubDescriptor, PFORMAT_STRING pFormat, ... );
	'' TODO: CLIENT_CALL_RETURN __cdecl NdrClientCall4( PMIDL_STUB_DESC pStubDescriptor, PFORMAT_STRING pFormat, ... );
	'' TODO: CLIENT_CALL_RETURN __cdecl NdrAsyncClientCall2( PMIDL_STUB_DESC pStubDescriptor, PFORMAT_STRING pFormat, ... );
	'' TODO: CLIENT_CALL_RETURN __cdecl NdrMesProcEncodeDecode4( handle_t Handle, const MIDL_STUB_DESC * pStubDescriptor, PFORMAT_STRING pFormat, ... );
	'' TODO: CLIENT_CALL_RETURN __cdecl NdrDcomAsyncClientCall( PMIDL_STUB_DESC pStubDescriptor, PFORMAT_STRING pFormat, ... );
	'' TODO: CLIENT_CALL_RETURN __cdecl NdrDcomAsyncClientCall2( PMIDL_STUB_DESC pStubDescriptor, PFORMAT_STRING pFormat, ... );
#endif

#if (defined(__FB_CYGWIN__) And defined(__FB_64BIT__)) Or ((Not defined(__FB_64BIT__)) And (defined(__FB_WIN32__) Or defined(__FB_CYGWIN__)))
	Declare Function NdrClientCall4(ByVal pStubDescriptor As PMIDL_STUB_DESC, ByVal pFormat As PFORMAT_STRING, ...) As CLIENT_CALL_RETURN
	Declare Function NdrAsyncClientCall2(ByVal pStubDescriptor As PMIDL_STUB_DESC, ByVal pFormat As PFORMAT_STRING, ...) As CLIENT_CALL_RETURN
	Declare Function NdrMesProcEncodeDecode4(ByVal Handle As handle_t, ByVal pStubDescriptor As Const MIDL_STUB_DESC Ptr, ByVal pFormat As PFORMAT_STRING, ...) As CLIENT_CALL_RETURN
#endif

#if defined(__FB_WIN32__) Or defined(__FB_CYGWIN__)
	'declare function NdrDcomAsyncClientCall(byval pStubDescriptor as PMIDL_STUB_DESC, byval pFormat as PFORMAT_STRING, ...) as CLIENT_CALL_RETURN
#endif

#if (defined(__FB_CYGWIN__) And defined(__FB_64BIT__)) Or ((Not defined(__FB_64BIT__)) And (defined(__FB_WIN32__) Or defined(__FB_CYGWIN__)))
	Declare Function NdrDcomAsyncClientCall2(ByVal pStubDescriptor As PMIDL_STUB_DESC, ByVal pFormat As PFORMAT_STRING, ...) As CLIENT_CALL_RETURN
#endif

Type STUB_PHASE As Long
'Enum
'	STUB_UNMARSHAL
'	STUB_CALL_SERVER
'	STUB_MARSHAL
'	STUB_CALL_SERVER_NO_HRESULT
'End Enum

Type PROXY_PHASE As Long
'Enum
'	PROXY_CALCSIZE
'	PROXY_GETBUFFER
'	PROXY_MARSHAL
'	PROXY_SENDRECEIVE
'	PROXY_UNMARSHAL
'End Enum

'' TODO: RPCRTAPI void RPC_ENTRY NdrAsyncServerCall( PRPC_MESSAGE pRpcMsg );
'' TODO: RPCRTAPI long RPC_ENTRY NdrAsyncStubCall( struct IRpcStubBuffer * pThis, struct IRpcChannelBuffer * pChannel, PRPC_MESSAGE pRpcMsg, unsigned long * pdwStubPhase );
'' TODO: RPCRTAPI long RPC_ENTRY NdrDcomAsyncStubCall( struct IRpcStubBuffer * pThis, struct IRpcChannelBuffer * pChannel, PRPC_MESSAGE pRpcMsg, unsigned long * pdwStubPhase );
'' TODO: RPCRTAPI long RPC_ENTRY NdrStubCall2( void * pThis, void * pChannel, PRPC_MESSAGE pRpcMsg, unsigned long * pdwStubPhase );
'' TODO: RPCRTAPI void RPC_ENTRY NdrServerCall2( PRPC_MESSAGE pRpcMsg );
'' TODO: RPCRTAPI long RPC_ENTRY NdrStubCall ( void * pThis, void * pChannel, PRPC_MESSAGE pRpcMsg, unsigned long * pdwStubPhase );
'' TODO: RPCRTAPI void RPC_ENTRY NdrServerCall( PRPC_MESSAGE pRpcMsg );
'' TODO: RPCRTAPI int RPC_ENTRY NdrServerUnmarshall( void * pChannel, PRPC_MESSAGE pRpcMsg, PMIDL_STUB_MESSAGE pStubMsg, PMIDL_STUB_DESC pStubDescriptor, PFORMAT_STRING pFormat, void * pParamList );
'' TODO: RPCRTAPI void RPC_ENTRY NdrServerMarshall( void * pThis, void * pChannel, PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat );
'' TODO: RPCRTAPI RPC_STATUS RPC_ENTRY NdrMapCommAndFaultStatus( PMIDL_STUB_MESSAGE pStubMsg, unsigned long * pCommStatus, unsigned long * pFaultStatus, RPC_STATUS Status );
Type RPC_SS_THREAD_HANDLE As Any Ptr
'' TODO: typedef void * __RPC_API RPC_CLIENT_ALLOC ( _In_ size_t Size );
'' TODO: typedef void __RPC_API RPC_CLIENT_FREE ( _In_ void * Ptr );
'' TODO: RPCRTAPI void *RPC_ENTRY RpcSsAllocate ( _In_ size_t Size );
'' TODO: RPCRTAPI void RPC_ENTRY RpcSsDisableAllocate ( void );
'' TODO: RPCRTAPI void RPC_ENTRY RpcSsEnableAllocate ( void );
'' TODO: RPCRTAPI void RPC_ENTRY RpcSsFree ( _In_ void * NodeToFree );
'' TODO: RPCRTAPI RPC_SS_THREAD_HANDLE RPC_ENTRY RpcSsGetThreadHandle ( void );
'' TODO: RPCRTAPI void RPC_ENTRY RpcSsSetClientAllocFree ( _In_ RPC_CLIENT_ALLOC * ClientAlloc, _In_ RPC_CLIENT_FREE * ClientFree );
'' TODO: RPCRTAPI void RPC_ENTRY RpcSsSetThreadHandle ( _In_ RPC_SS_THREAD_HANDLE Id );
'' TODO: RPCRTAPI void RPC_ENTRY RpcSsSwapClientAllocFree ( _In_ RPC_CLIENT_ALLOC * ClientAlloc, _In_ RPC_CLIENT_FREE * ClientFree, _Out_ RPC_CLIENT_ALLOC * * OldClientAlloc, _Out_ RPC_CLIENT_FREE * * OldClientFree );
'' TODO: RPCRTAPI void *RPC_ENTRY RpcSmAllocate ( _In_ size_t Size, _Out_ RPC_STATUS * pStatus );
'' TODO: RPCRTAPI RPC_STATUS RPC_ENTRY RpcSmClientFree ( _In_ void * pNodeToFree );
'' TODO: RPCRTAPI RPC_STATUS RPC_ENTRY RpcSmDestroyClientContext ( _In_ void * * ContextHandle );
'' TODO: RPCRTAPI RPC_STATUS RPC_ENTRY RpcSmDisableAllocate ( void );
'' TODO: RPCRTAPI RPC_STATUS RPC_ENTRY RpcSmEnableAllocate ( void );
'' TODO: RPCRTAPI RPC_STATUS RPC_ENTRY RpcSmFree ( _In_ void * NodeToFree );
'' TODO: RPCRTAPI RPC_SS_THREAD_HANDLE RPC_ENTRY RpcSmGetThreadHandle ( _Out_ RPC_STATUS * pStatus );
'' TODO: RPCRTAPI RPC_STATUS RPC_ENTRY RpcSmSetClientAllocFree ( _In_ RPC_CLIENT_ALLOC * ClientAlloc, _In_ RPC_CLIENT_FREE * ClientFree );
'' TODO: RPCRTAPI RPC_STATUS RPC_ENTRY RpcSmSetThreadHandle ( _In_ RPC_SS_THREAD_HANDLE Id );
'' TODO: RPCRTAPI RPC_STATUS RPC_ENTRY RpcSmSwapClientAllocFree ( _In_ RPC_CLIENT_ALLOC * ClientAlloc, _In_ RPC_CLIENT_FREE * ClientFree, _Out_ RPC_CLIENT_ALLOC * * OldClientAlloc, _Out_ RPC_CLIENT_FREE * * OldClientFree );
'' TODO: RPCRTAPI void RPC_ENTRY NdrRpcSsEnableAllocate( PMIDL_STUB_MESSAGE pMessage );
'' TODO: RPCRTAPI void RPC_ENTRY NdrRpcSsDisableAllocate( PMIDL_STUB_MESSAGE pMessage );
'' TODO: RPCRTAPI void RPC_ENTRY NdrRpcSmSetClientToOsf( PMIDL_STUB_MESSAGE pMessage );
'' TODO: RPCRTAPI void *RPC_ENTRY NdrRpcSmClientAllocate ( _In_ size_t Size );
'' TODO: RPCRTAPI void RPC_ENTRY NdrRpcSmClientFree ( _In_ void * NodeToFree );
'' TODO: RPCRTAPI void *RPC_ENTRY NdrRpcSsDefaultAllocate ( _In_ size_t Size );
'' TODO: RPCRTAPI void RPC_ENTRY NdrRpcSsDefaultFree ( _In_ void * NodeToFree );
'' TODO: RPCRTAPI PFULL_PTR_XLAT_TABLES RPC_ENTRY NdrFullPointerXlatInit( unsigned long NumberOfPointers, XLAT_SIDE XlatSide );
'' TODO: RPCRTAPI void RPC_ENTRY NdrFullPointerXlatFree( PFULL_PTR_XLAT_TABLES pXlatTables );
'' TODO: RPCRTAPI void *RPC_ENTRY NdrAllocate( PMIDL_STUB_MESSAGE pStubMsg, size_t Len );
'' TODO: RPCRTAPI void RPC_ENTRY NdrClearOutParameters( PMIDL_STUB_MESSAGE pStubMsg, PFORMAT_STRING pFormat, void * ArgAddr );
'' TODO: RPCRTAPI void *RPC_ENTRY NdrOleAllocate ( _In_ size_t Size );
'' TODO: RPCRTAPI void RPC_ENTRY NdrOleFree ( _In_ void * NodeToFree );

#define CONST_VTBL
#define DECLSPEC_SELECTANY
#define DECLSPEC_NOVTABLE
#define DECLSPEC_UUID(x)
'' TODO: #define MIDL_INTERFACE(x) struct DECLSPEC_UUID(x) DECLSPEC_NOVTABLE
'' TODO: #define EXTERN_GUID(itf,l1,s1,s2,c1,c2,c3,c4,c5,c6,c7,c8) EXTERN_C const IID itf

'type _NDR_USER_MARSHAL_INFO_LEVEL1
'	Buffer As Any Ptr
'	BufferSize As culong
'	'' TODO: void *(__RPC_API * pfnAllocate)(size_t);
'	'' TODO: void (__RPC_API * pfnFree)(void *);
'	pRpcChannelBuffer As IRpcChannelBuffer Ptr
'	Reserved(0 To 4) As ULONG_PTR
'End Type

Type NDR_USER_MARSHAL_INFO_LEVEL1 As _NDR_USER_MARSHAL_INFO_LEVEL1

Union _NDR_USER_MARSHAL_INFO_DUMMYUNIONNAME
	Level1 As NDR_USER_MARSHAL_INFO_LEVEL1
End Union

'type _NDR_USER_MARSHAL_INFO
'	InformationLevel As culong
'	DUMMYUNIONNAME As _NDR_USER_MARSHAL_INFO_DUMMYUNIONNAME
'End Type

Type NDR_USER_MARSHAL_INFO As _NDR_USER_MARSHAL_INFO
'' TODO: RPC_STATUS RPC_ENTRY NdrGetUserMarshalInfo ( _In_ unsigned long * pFlags, _In_ unsigned long InformationLevel, _Out_ NDR_USER_MARSHAL_INFO * pMarshalInfo );
'' TODO: RPC_STATUS RPC_ENTRY NdrCreateServerInterfaceFromStub( _In_ struct IRpcStubBuffer* pStub, _Inout_ RPC_SERVER_INTERFACE *pServerIf );

#if defined(__FB_WIN32__) Or defined(__FB_CYGWIN__)
	'Declare Function NdrClientCall3(ByVal pProxyInfo As MIDL_STUBLESS_PROXY_INFO Ptr, ByVal nProcNum As culong, ByVal pReturnValue As Any Ptr, ...) As CLIENT_CALL_RETURN
	'Declare Function Ndr64AsyncClientCall(ByVal pProxyInfo As MIDL_STUBLESS_PROXY_INFO Ptr, ByVal nProcNum As culong, ByVal pReturnValue As Any Ptr, ...) As CLIENT_CALL_RETURN
	'Declare Function Ndr64DcomAsyncClientCall(ByVal pProxyInfo As MIDL_STUBLESS_PROXY_INFO Ptr, ByVal nProcNum As culong, ByVal pReturnValue As Any Ptr, ...) As CLIENT_CALL_RETURN
#else
	'' TODO: CLIENT_CALL_RETURN __cdecl NdrClientCall3( MIDL_STUBLESS_PROXY_INFO *pProxyInfo, unsigned long nProcNum, void * pReturnValue, ... );
	'' TODO: CLIENT_CALL_RETURN __cdecl Ndr64AsyncClientCall( MIDL_STUBLESS_PROXY_INFO *pProxyInfo, unsigned long nProcNum, void * pReturnValue, ... );
	'' TODO: CLIENT_CALL_RETURN __cdecl Ndr64DcomAsyncClientCall( MIDL_STUBLESS_PROXY_INFO *pProxyInfo, unsigned long nProcNum, void * pReturnValue, ... );
#endif

'' TODO: RPCRTAPI void RPC_ENTRY Ndr64AsyncServerCall( PRPC_MESSAGE pRpcMsg );
'' TODO: RPCRTAPI void RPC_ENTRY Ndr64AsyncServerCall64( PRPC_MESSAGE pRpcMsg );
'' TODO: RPCRTAPI void RPC_ENTRY Ndr64AsyncServerCallAll( PRPC_MESSAGE pRpcMsg );
'' TODO: RPCRTAPI long RPC_ENTRY Ndr64AsyncStubCall( struct IRpcStubBuffer * pThis, struct IRpcChannelBuffer * pChannel, PRPC_MESSAGE pRpcMsg, unsigned long * pdwStubPhase );
'' TODO: RPCRTAPI long RPC_ENTRY Ndr64DcomAsyncStubCall( struct IRpcStubBuffer * pThis, struct IRpcChannelBuffer * pChannel, PRPC_MESSAGE pRpcMsg, unsigned long * pdwStubPhase );
'' TODO: RPCRTAPI long RPC_ENTRY NdrStubCall3 ( void * pThis, void * pChannel, PRPC_MESSAGE pRpcMsg, unsigned long * pdwStubPhase );
'' TODO: RPCRTAPI void RPC_ENTRY NdrServerCallAll( PRPC_MESSAGE pRpcMsg );
'' TODO: RPCRTAPI void RPC_ENTRY NdrServerCallNdr64( PRPC_MESSAGE pRpcMsg );
'' TODO: RPCRTAPI void RPC_ENTRY NdrServerCall3( PRPC_MESSAGE pRpcMsg );
'' TODO: RPCRTAPI void RPC_ENTRY NdrPartialIgnoreClientMarshall( PMIDL_STUB_MESSAGE pStubMsg, void * pMemory );
'' TODO: RPCRTAPI void RPC_ENTRY NdrPartialIgnoreServerUnmarshall( PMIDL_STUB_MESSAGE pStubMsg, void ** ppMemory );
'' TODO: RPCRTAPI void RPC_ENTRY NdrPartialIgnoreClientBufferSize( PMIDL_STUB_MESSAGE pStubMsg, void * pMemory );
'' TODO: RPCRTAPI void RPC_ENTRY NdrPartialIgnoreServerInitialize( PMIDL_STUB_MESSAGE pStubMsg, void ** ppMemory, PFORMAT_STRING pFormat );
'' TODO: void RPC_ENTRY RpcUserFree( handle_t AsyncHandle, void * pBuffer );
#define __webview2_h__
'' TODO: #define interface struct

#define __ICoreWebView2AcceleratorKeyPressedEventArgs_FWD_DEFINED__
#define __ICoreWebView2AcceleratorKeyPressedEventHandler_FWD_DEFINED__
#define __ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler_FWD_DEFINED__
#define __ICoreWebView2CallDevToolsProtocolMethodCompletedHandler_FWD_DEFINED__
#define __ICoreWebView2CapturePreviewCompletedHandler_FWD_DEFINED__
#define __ICoreWebView2_FWD_DEFINED__
#define __ICoreWebView2Controller_FWD_DEFINED__
#define __ICoreWebView2ContentLoadingEventArgs_FWD_DEFINED__
#define __ICoreWebView2ContentLoadingEventHandler_FWD_DEFINED__
#define __ICoreWebView2DocumentTitleChangedEventHandler_FWD_DEFINED__
#define __ICoreWebView2ContainsFullScreenElementChangedEventHandler_FWD_DEFINED__
#define __ICoreWebView2CreateCoreWebView2ControllerCompletedHandler_FWD_DEFINED__
#define __ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler_FWD_DEFINED__
#define __ICoreWebView2Deferral_FWD_DEFINED__
#define __ICoreWebView2DevToolsProtocolEventReceivedEventArgs_FWD_DEFINED__
#define __ICoreWebView2DevToolsProtocolEventReceivedEventHandler_FWD_DEFINED__
#define __ICoreWebView2DevToolsProtocolEventReceiver_FWD_DEFINED__
#define __ICoreWebView2Environment_FWD_DEFINED__
#define __ICoreWebView2EnvironmentOptions_FWD_DEFINED__
#define __ICoreWebView2ExecuteScriptCompletedHandler_FWD_DEFINED__
#define __ICoreWebView2FocusChangedEventHandler_FWD_DEFINED__
#define __ICoreWebView2HistoryChangedEventHandler_FWD_DEFINED__
#define __ICoreWebView2HttpHeadersCollectionIterator_FWD_DEFINED__
#define __ICoreWebView2HttpRequestHeaders_FWD_DEFINED__
#define __ICoreWebView2HttpResponseHeaders_FWD_DEFINED__
#define __ICoreWebView2MoveFocusRequestedEventArgs_FWD_DEFINED__
#define __ICoreWebView2MoveFocusRequestedEventHandler_FWD_DEFINED__
#define __ICoreWebView2NavigationCompletedEventArgs_FWD_DEFINED__
#define __ICoreWebView2NavigationCompletedEventHandler_FWD_DEFINED__
#define __ICoreWebView2NavigationStartingEventArgs_FWD_DEFINED__
#define __ICoreWebView2NavigationStartingEventHandler_FWD_DEFINED__
#define __ICoreWebView2NewBrowserVersionAvailableEventHandler_FWD_DEFINED__
#define __ICoreWebView2NewWindowRequestedEventArgs_FWD_DEFINED__
#define __ICoreWebView2NewWindowRequestedEventHandler_FWD_DEFINED__
#define __ICoreWebView2PermissionRequestedEventArgs_FWD_DEFINED__
#define __ICoreWebView2PermissionRequestedEventHandler_FWD_DEFINED__
#define __ICoreWebView2ProcessFailedEventArgs_FWD_DEFINED__
#define __ICoreWebView2ProcessFailedEventHandler_FWD_DEFINED__
#define __ICoreWebView2ScriptDialogOpeningEventArgs_FWD_DEFINED__
#define __ICoreWebView2ScriptDialogOpeningEventHandler_FWD_DEFINED__
#define __ICoreWebView2Settings_FWD_DEFINED__
#define __ICoreWebView2SourceChangedEventArgs_FWD_DEFINED__
#define __ICoreWebView2SourceChangedEventHandler_FWD_DEFINED__
#define __ICoreWebView2WebMessageReceivedEventArgs_FWD_DEFINED__
#define __ICoreWebView2WebMessageReceivedEventHandler_FWD_DEFINED__
#define __ICoreWebView2WebResourceRequest_FWD_DEFINED__
#define __ICoreWebView2WebResourceRequestedEventArgs_FWD_DEFINED__
#define __ICoreWebView2WebResourceRequestedEventHandler_FWD_DEFINED__
#define __ICoreWebView2WebResourceResponse_FWD_DEFINED__
#define __ICoreWebView2WindowCloseRequestedEventHandler_FWD_DEFINED__
#define __ICoreWebView2ZoomFactorChangedEventHandler_FWD_DEFINED__
#define __WebView2_LIBRARY_DEFINED__

Type COREWEBVIEW2_CAPTURE_PREVIEW_IMAGE_FORMAT As Long
Enum
	COREWEBVIEW2_CAPTURE_PREVIEW_IMAGE_FORMAT_PNG = 0
	COREWEBVIEW2_CAPTURE_PREVIEW_IMAGE_FORMAT_JPEG = COREWEBVIEW2_CAPTURE_PREVIEW_IMAGE_FORMAT_PNG + 1
End Enum

Type COREWEBVIEW2_SCRIPT_DIALOG_KIND As Long
Enum
	COREWEBVIEW2_SCRIPT_DIALOG_KIND_ALERT = 0
	COREWEBVIEW2_SCRIPT_DIALOG_KIND_CONFIRM = COREWEBVIEW2_SCRIPT_DIALOG_KIND_ALERT + 1
	COREWEBVIEW2_SCRIPT_DIALOG_KIND_PROMPT = COREWEBVIEW2_SCRIPT_DIALOG_KIND_CONFIRM + 1
	COREWEBVIEW2_SCRIPT_DIALOG_KIND_BEFOREUNLOAD = COREWEBVIEW2_SCRIPT_DIALOG_KIND_PROMPT + 1
End Enum

Type COREWEBVIEW2_PROCESS_FAILED_KIND As Long
Enum
	COREWEBVIEW2_PROCESS_FAILED_KIND_BROWSER_PROCESS_EXITED = 0
	COREWEBVIEW2_PROCESS_FAILED_KIND_RENDER_PROCESS_EXITED = COREWEBVIEW2_PROCESS_FAILED_KIND_BROWSER_PROCESS_EXITED + 1
	COREWEBVIEW2_PROCESS_FAILED_KIND_RENDER_PROCESS_UNRESPONSIVE = COREWEBVIEW2_PROCESS_FAILED_KIND_RENDER_PROCESS_EXITED + 1
End Enum

Type COREWEBVIEW2_PERMISSION_KIND As Long
Enum
	COREWEBVIEW2_PERMISSION_KIND_UNKNOWN_PERMISSION = 0
	COREWEBVIEW2_PERMISSION_KIND_MICROPHONE = COREWEBVIEW2_PERMISSION_KIND_UNKNOWN_PERMISSION + 1
	COREWEBVIEW2_PERMISSION_KIND_CAMERA = COREWEBVIEW2_PERMISSION_KIND_MICROPHONE + 1
	COREWEBVIEW2_PERMISSION_KIND_GEOLOCATION = COREWEBVIEW2_PERMISSION_KIND_CAMERA + 1
	COREWEBVIEW2_PERMISSION_KIND_NOTIFICATIONS = COREWEBVIEW2_PERMISSION_KIND_GEOLOCATION + 1
	COREWEBVIEW2_PERMISSION_KIND_OTHER_SENSORS = COREWEBVIEW2_PERMISSION_KIND_NOTIFICATIONS + 1
	COREWEBVIEW2_PERMISSION_KIND_CLIPBOARD_READ = COREWEBVIEW2_PERMISSION_KIND_OTHER_SENSORS + 1
End Enum

Type COREWEBVIEW2_PERMISSION_STATE As Long
Enum
	COREWEBVIEW2_PERMISSION_STATE_DEFAULT = 0
	COREWEBVIEW2_PERMISSION_STATE_ALLOW = COREWEBVIEW2_PERMISSION_STATE_DEFAULT + 1
	COREWEBVIEW2_PERMISSION_STATE_DENY = COREWEBVIEW2_PERMISSION_STATE_ALLOW + 1
End Enum

Type COREWEBVIEW2_WEB_ERROR_STATUS As Long
Enum
	COREWEBVIEW2_WEB_ERROR_STATUS_UNKNOWN = 0
	COREWEBVIEW2_WEB_ERROR_STATUS_CERTIFICATE_COMMON_NAME_IS_INCORRECT = COREWEBVIEW2_WEB_ERROR_STATUS_UNKNOWN + 1
	COREWEBVIEW2_WEB_ERROR_STATUS_CERTIFICATE_EXPIRED = COREWEBVIEW2_WEB_ERROR_STATUS_CERTIFICATE_COMMON_NAME_IS_INCORRECT + 1
	COREWEBVIEW2_WEB_ERROR_STATUS_CLIENT_CERTIFICATE_CONTAINS_ERRORS = COREWEBVIEW2_WEB_ERROR_STATUS_CERTIFICATE_EXPIRED + 1
	COREWEBVIEW2_WEB_ERROR_STATUS_CERTIFICATE_REVOKED = COREWEBVIEW2_WEB_ERROR_STATUS_CLIENT_CERTIFICATE_CONTAINS_ERRORS + 1
	COREWEBVIEW2_WEB_ERROR_STATUS_CERTIFICATE_IS_INVALID = COREWEBVIEW2_WEB_ERROR_STATUS_CERTIFICATE_REVOKED + 1
	COREWEBVIEW2_WEB_ERROR_STATUS_SERVER_UNREACHABLE = COREWEBVIEW2_WEB_ERROR_STATUS_CERTIFICATE_IS_INVALID + 1
	COREWEBVIEW2_WEB_ERROR_STATUS_TIMEOUT = COREWEBVIEW2_WEB_ERROR_STATUS_SERVER_UNREACHABLE + 1
	COREWEBVIEW2_WEB_ERROR_STATUS_ERROR_HTTP_INVALID_SERVER_RESPONSE = COREWEBVIEW2_WEB_ERROR_STATUS_TIMEOUT + 1
	COREWEBVIEW2_WEB_ERROR_STATUS_CONNECTION_ABORTED = COREWEBVIEW2_WEB_ERROR_STATUS_ERROR_HTTP_INVALID_SERVER_RESPONSE + 1
	COREWEBVIEW2_WEB_ERROR_STATUS_CONNECTION_RESET = COREWEBVIEW2_WEB_ERROR_STATUS_CONNECTION_ABORTED + 1
	COREWEBVIEW2_WEB_ERROR_STATUS_DISCONNECTED = COREWEBVIEW2_WEB_ERROR_STATUS_CONNECTION_RESET + 1
	COREWEBVIEW2_WEB_ERROR_STATUS_CANNOT_CONNECT = COREWEBVIEW2_WEB_ERROR_STATUS_DISCONNECTED + 1
	COREWEBVIEW2_WEB_ERROR_STATUS_HOST_NAME_NOT_RESOLVED = COREWEBVIEW2_WEB_ERROR_STATUS_CANNOT_CONNECT + 1
	COREWEBVIEW2_WEB_ERROR_STATUS_OPERATION_CANCELED = COREWEBVIEW2_WEB_ERROR_STATUS_HOST_NAME_NOT_RESOLVED + 1
	COREWEBVIEW2_WEB_ERROR_STATUS_REDIRECT_FAILED = COREWEBVIEW2_WEB_ERROR_STATUS_OPERATION_CANCELED + 1
	COREWEBVIEW2_WEB_ERROR_STATUS_UNEXPECTED_ERROR = COREWEBVIEW2_WEB_ERROR_STATUS_REDIRECT_FAILED + 1
End Enum

Type COREWEBVIEW2_WEB_RESOURCE_CONTEXT As Long
Enum
	COREWEBVIEW2_WEB_RESOURCE_CONTEXT_ALL = 0
	COREWEBVIEW2_WEB_RESOURCE_CONTEXT_DOCUMENT = COREWEBVIEW2_WEB_RESOURCE_CONTEXT_ALL + 1
	COREWEBVIEW2_WEB_RESOURCE_CONTEXT_STYLESHEET = COREWEBVIEW2_WEB_RESOURCE_CONTEXT_DOCUMENT + 1
	COREWEBVIEW2_WEB_RESOURCE_CONTEXT_IMAGE = COREWEBVIEW2_WEB_RESOURCE_CONTEXT_STYLESHEET + 1
	COREWEBVIEW2_WEB_RESOURCE_CONTEXT_MEDIA = COREWEBVIEW2_WEB_RESOURCE_CONTEXT_IMAGE + 1
	COREWEBVIEW2_WEB_RESOURCE_CONTEXT_FONT = COREWEBVIEW2_WEB_RESOURCE_CONTEXT_MEDIA + 1
	COREWEBVIEW2_WEB_RESOURCE_CONTEXT_SCRIPT = COREWEBVIEW2_WEB_RESOURCE_CONTEXT_FONT + 1
	COREWEBVIEW2_WEB_RESOURCE_CONTEXT_XML_HTTP_REQUEST = COREWEBVIEW2_WEB_RESOURCE_CONTEXT_SCRIPT + 1
	COREWEBVIEW2_WEB_RESOURCE_CONTEXT_FETCH = COREWEBVIEW2_WEB_RESOURCE_CONTEXT_XML_HTTP_REQUEST + 1
	COREWEBVIEW2_WEB_RESOURCE_CONTEXT_TEXT_TRACK = COREWEBVIEW2_WEB_RESOURCE_CONTEXT_FETCH + 1
	COREWEBVIEW2_WEB_RESOURCE_CONTEXT_EVENT_SOURCE = COREWEBVIEW2_WEB_RESOURCE_CONTEXT_TEXT_TRACK + 1
	COREWEBVIEW2_WEB_RESOURCE_CONTEXT_WEBSOCKET = COREWEBVIEW2_WEB_RESOURCE_CONTEXT_EVENT_SOURCE + 1
	COREWEBVIEW2_WEB_RESOURCE_CONTEXT_MANIFEST = COREWEBVIEW2_WEB_RESOURCE_CONTEXT_WEBSOCKET + 1
	COREWEBVIEW2_WEB_RESOURCE_CONTEXT_SIGNED_EXCHANGE = COREWEBVIEW2_WEB_RESOURCE_CONTEXT_MANIFEST + 1
	COREWEBVIEW2_WEB_RESOURCE_CONTEXT_PING = COREWEBVIEW2_WEB_RESOURCE_CONTEXT_SIGNED_EXCHANGE + 1
	COREWEBVIEW2_WEB_RESOURCE_CONTEXT_CSP_VIOLATION_REPORT = COREWEBVIEW2_WEB_RESOURCE_CONTEXT_PING + 1
	COREWEBVIEW2_WEB_RESOURCE_CONTEXT_OTHER = COREWEBVIEW2_WEB_RESOURCE_CONTEXT_CSP_VIOLATION_REPORT + 1
End Enum

Type COREWEBVIEW2_MOVE_FOCUS_REASON As Long
Enum
	COREWEBVIEW2_MOVE_FOCUS_REASON_PROGRAMMATIC = 0
	COREWEBVIEW2_MOVE_FOCUS_REASON_NEXT = COREWEBVIEW2_MOVE_FOCUS_REASON_PROGRAMMATIC + 1
	COREWEBVIEW2_MOVE_FOCUS_REASON_PREVIOUS = COREWEBVIEW2_MOVE_FOCUS_REASON_NEXT + 1
End Enum

Type COREWEBVIEW2_KEY_EVENT_KIND As Long
Enum
	COREWEBVIEW2_KEY_EVENT_KIND_KEY_DOWN = 0
	COREWEBVIEW2_KEY_EVENT_KIND_KEY_UP = COREWEBVIEW2_KEY_EVENT_KIND_KEY_DOWN + 1
	COREWEBVIEW2_KEY_EVENT_KIND_SYSTEM_KEY_DOWN = COREWEBVIEW2_KEY_EVENT_KIND_KEY_UP + 1
	COREWEBVIEW2_KEY_EVENT_KIND_SYSTEM_KEY_UP = COREWEBVIEW2_KEY_EVENT_KIND_SYSTEM_KEY_DOWN + 1
End Enum

Type COREWEBVIEW2_PHYSICAL_KEY_STATUS
	RepeatCount As UINT32
	ScanCode As UINT32
	IsExtendedKey As BOOL
	IsMenuKeyDown As BOOL
	WasKeyDown As BOOL
	IsKeyReleased As BOOL
End Type

Type STDAPI As HRESULT
Type ICoreWebView2EnvironmentOptions As ICoreWebView2EnvironmentOptions_
Type ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler As ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler_
Declare Function CreateCoreWebView2EnvironmentWithOptions stdcall(ByVal browserExecutableFolder As PCWSTR, ByVal userDataFolder As PCWSTR, ByVal environmentOptions As ICoreWebView2EnvironmentOptions Ptr, ByVal environment_created_handler As ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler Ptr) As STDAPI
Declare Function CreateCoreWebView2Environment stdcall(ByVal environment_created_handler As ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler Ptr) As STDAPI
Declare Function GetAvailableCoreWebView2BrowserVersionString stdcall(ByVal browserExecutableFolder As PCWSTR, ByVal versionInfo As LPWSTR Ptr) As STDAPI
Declare Function CompareBrowserVersions stdcall(ByVal version1 As PCWSTR, ByVal version2 As PCWSTR, ByVal result As Long Ptr) As STDAPI
'' TODO: EXTERN_C const IID LIBID_WebView2;
#define __ICoreWebView2AcceleratorKeyPressedEventArgs_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2AcceleratorKeyPressedEventArgs;

Type ICoreWebView2AcceleratorKeyPressedEventArgs As ICoreWebView2AcceleratorKeyPressedEventArgs_
Type ICoreWebView2AcceleratorKeyPressedEventArgsVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2AcceleratorKeyPressedEventArgs * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2AcceleratorKeyPressedEventArgs Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2AcceleratorKeyPressedEventArgs * This);
	AddRef As Function stdcall (This As ICoreWebView2AcceleratorKeyPressedEventArgs Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2AcceleratorKeyPressedEventArgs * This);
	Release As Function stdcall (This As ICoreWebView2AcceleratorKeyPressedEventArgs Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_KeyEventKind )( ICoreWebView2AcceleratorKeyPressedEventArgs * This, COREWEBVIEW2_KEY_EVENT_KIND *keyEventKind);
	get_KeyEventKind As Function stdcall (This As ICoreWebView2AcceleratorKeyPressedEventArgs Ptr, keyEventKind As COREWEBVIEW2_KEY_EVENT_KIND Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_VirtualKey )( ICoreWebView2AcceleratorKeyPressedEventArgs * This, UINT *virtualKey);
	get_VirtualKey As Function stdcall (This As ICoreWebView2AcceleratorKeyPressedEventArgs Ptr, virtualKey As UINT Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_KeyEventLParam )( ICoreWebView2AcceleratorKeyPressedEventArgs * This, INT *lParam);
	get_KeyEventLParam As Function stdcall (This As ICoreWebView2AcceleratorKeyPressedEventArgs Ptr, lParam As Integer) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_PhysicalKeyStatus )( ICoreWebView2AcceleratorKeyPressedEventArgs * This, COREWEBVIEW2_PHYSICAL_KEY_STATUS *physicalKeyStatus);
	get_PhysicalKeyStatus As Function stdcall (This As ICoreWebView2AcceleratorKeyPressedEventArgs Ptr, physicalKeyStatus As COREWEBVIEW2_PHYSICAL_KEY_STATUS) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Handled )( ICoreWebView2AcceleratorKeyPressedEventArgs * This, BOOL *handled);
	get_Handled As Function stdcall (This As ICoreWebView2AcceleratorKeyPressedEventArgs Ptr, handled As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_Handled )( ICoreWebView2AcceleratorKeyPressedEventArgs * This, BOOL handled);
	put_Handled As Function stdcall (This As ICoreWebView2AcceleratorKeyPressedEventArgs Ptr, handled As BOOL) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2AcceleratorKeyPressedEventArgs_
	lpVtbl As ICoreWebView2AcceleratorKeyPressedEventArgsVtbl Ptr
End Type

#define __ICoreWebView2AcceleratorKeyPressedEventHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2AcceleratorKeyPressedEventHandler;

Type ICoreWebView2AcceleratorKeyPressedEventHandler As ICoreWebView2AcceleratorKeyPressedEventHandler_
Type ICoreWebView2Controller As ICoreWebView2Controller_
Type ICoreWebView2AcceleratorKeyPressedEventHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2AcceleratorKeyPressedEventHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2AcceleratorKeyPressedEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2AcceleratorKeyPressedEventHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2AcceleratorKeyPressedEventHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2AcceleratorKeyPressedEventHandler * This);
	Release As Function stdcall (This As ICoreWebView2AcceleratorKeyPressedEventHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2AcceleratorKeyPressedEventHandler * This, ICoreWebView2Controller *sender, ICoreWebView2AcceleratorKeyPressedEventArgs *args);
	Invoke As Function stdcall (This As ICoreWebView2AcceleratorKeyPressedEventHandler Ptr, sender As ICoreWebView2Controller Ptr, args As ICoreWebView2AcceleratorKeyPressedEventArgs Ptr) As CULONG
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2AcceleratorKeyPressedEventHandler_
	lpVtbl As ICoreWebView2AcceleratorKeyPressedEventHandlerVtbl Ptr
End Type

#define __ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler;

Type ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler As ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler_
Type ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler * This);
	Release As Function stdcall (This As ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler * This, HRESULT errorCode, LPCWSTR id);
	Invoke As Function stdcall (This As ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler Ptr, errorCode As HRESULT, id As LPCWSTR) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler_
	lpVtbl As ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandlerVtbl Ptr
End Type

#define __ICoreWebView2CallDevToolsProtocolMethodCompletedHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2CallDevToolsProtocolMethodCompletedHandler;

Type ICoreWebView2CallDevToolsProtocolMethodCompletedHandler As ICoreWebView2CallDevToolsProtocolMethodCompletedHandler_
Type ICoreWebView2CallDevToolsProtocolMethodCompletedHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2CallDevToolsProtocolMethodCompletedHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2CallDevToolsProtocolMethodCompletedHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2CallDevToolsProtocolMethodCompletedHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2CallDevToolsProtocolMethodCompletedHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2CallDevToolsProtocolMethodCompletedHandler * This);
	Release As Function stdcall (This As ICoreWebView2CallDevToolsProtocolMethodCompletedHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2CallDevToolsProtocolMethodCompletedHandler * This, HRESULT errorCode, LPCWSTR returnObjectAsJson);
	Invoke As Function stdcall (This As ICoreWebView2CallDevToolsProtocolMethodCompletedHandler Ptr, errorCode As HRESULT, returnObjectAsJson As LPCWSTR) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2CallDevToolsProtocolMethodCompletedHandler_
	lpVtbl As ICoreWebView2CallDevToolsProtocolMethodCompletedHandlerVtbl Ptr
End Type

#define __ICoreWebView2CapturePreviewCompletedHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2CapturePreviewCompletedHandler;

Type ICoreWebView2CapturePreviewCompletedHandler As ICoreWebView2CapturePreviewCompletedHandler_
Type ICoreWebView2CapturePreviewCompletedHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2CapturePreviewCompletedHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2CapturePreviewCompletedHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2CapturePreviewCompletedHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2CapturePreviewCompletedHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2CapturePreviewCompletedHandler * This);
	Release As Function stdcall (This As ICoreWebView2CapturePreviewCompletedHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2CapturePreviewCompletedHandler * This, HRESULT result);
	Invoke As Function stdcall (This As ICoreWebView2CapturePreviewCompletedHandler Ptr, result As HRESULT) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2CapturePreviewCompletedHandler_
	lpVtbl As ICoreWebView2CapturePreviewCompletedHandlerVtbl Ptr
End Type

Type EventRegistrationToken
	value As __int64
End Type

#define __ICoreWebView2_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2;
Type ICoreWebView2Settings As ICoreWebView2Settings_
Type ICoreWebView2NavigationStartingEventHandler As ICoreWebView2NavigationStartingEventHandler_
Type ICoreWebView2ContentLoadingEventHandler As ICoreWebView2ContentLoadingEventHandler_
Type ICoreWebView2SourceChangedEventHandler As ICoreWebView2SourceChangedEventHandler_
Type ICoreWebView2HistoryChangedEventHandler As ICoreWebView2HistoryChangedEventHandler_
Type ICoreWebView2NavigationCompletedEventHandler As ICoreWebView2NavigationCompletedEventHandler_
Type ICoreWebView2ScriptDialogOpeningEventHandler As ICoreWebView2ScriptDialogOpeningEventHandler_
Type ICoreWebView2PermissionRequestedEventHandler As ICoreWebView2PermissionRequestedEventHandler_
Type ICoreWebView2ProcessFailedEventHandler As ICoreWebView2ProcessFailedEventHandler_
Type ICoreWebView2ExecuteScriptCompletedHandler As ICoreWebView2ExecuteScriptCompletedHandler_
Type ICoreWebView2WebMessageReceivedEventHandler As ICoreWebView2WebMessageReceivedEventHandler_
Type ICoreWebView2DevToolsProtocolEventReceiver As ICoreWebView2DevToolsProtocolEventReceiver_
Type ICoreWebView2NewWindowRequestedEventHandler As ICoreWebView2NewWindowRequestedEventHandler_
Type ICoreWebView2DocumentTitleChangedEventHandler As ICoreWebView2DocumentTitleChangedEventHandler_
Type ICoreWebView2ContainsFullScreenElementChangedEventHandler As ICoreWebView2ContainsFullScreenElementChangedEventHandler_
Type ICoreWebView2WebResourceRequestedEventHandler As ICoreWebView2WebResourceRequestedEventHandler_
Type ICoreWebView2WindowCloseRequestedEventHandler As ICoreWebView2WindowCloseRequestedEventHandler_
Type ICoreWebView2 As ICoreWebView2_
Type ICoreWebView2Vtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2 * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2 Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2 * This);
	AddRef As Function stdcall (This As ICoreWebView2 Ptr) As culong
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2 * This);
	Release As Function stdcall (This As ICoreWebView2 Ptr) As culong
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Settings )( ICoreWebView2 * This, ICoreWebView2Settings **settings);
	get_Settings As Function stdcall (This As ICoreWebView2 Ptr, settings As ICoreWebView2Settings Ptr Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Source )( ICoreWebView2 * This, LPWSTR *uri);
	get_Source As Function stdcall (This As ICoreWebView2 Ptr, uri As LPWSTR Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Navigate )( ICoreWebView2 * This, LPCWSTR uri);
	Navigate As Function stdcall (This As ICoreWebView2 Ptr, uri As LPCWSTR) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *NavigateToString )( ICoreWebView2 * This, LPCWSTR htmlContent);
	NavigateToString As Function stdcall (This As ICoreWebView2 Ptr, htmlContent As LPCWSTR) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_NavigationStarting )( ICoreWebView2 * This, ICoreWebView2NavigationStartingEventHandler *eventHandler, EventRegistrationToken *token);
	add_NavigationStarting As Function stdcall (This As ICoreWebView2 Ptr, eventHandler As ICoreWebView2NavigationStartingEventHandler Ptr, token As EventRegistrationToken Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_NavigationStarting )( ICoreWebView2 * This, EventRegistrationToken token);
	remove_NavigationStarting As Function stdcall (This As ICoreWebView2 Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_ContentLoading )( ICoreWebView2 * This, ICoreWebView2ContentLoadingEventHandler *eventHandler, EventRegistrationToken *token);
	add_ContentLoading As Function stdcall (This As ICoreWebView2 Ptr, eventHandler As ICoreWebView2ContentLoadingEventHandler Ptr, token As EventRegistrationToken Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_ContentLoading )( ICoreWebView2 * This, EventRegistrationToken token);
	remove_ContentLoading As Function stdcall (This As ICoreWebView2 Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_SourceChanged )( ICoreWebView2 * This, ICoreWebView2SourceChangedEventHandler *eventHandler, EventRegistrationToken *token);
	add_SourceChanged As Function stdcall (This As ICoreWebView2 Ptr, eventHandler As ICoreWebView2SourceChangedEventHandler, token As EventRegistrationToken Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_SourceChanged )( ICoreWebView2 * This, EventRegistrationToken token);
	remove_SourceChanged As Function stdcall (This As ICoreWebView2 Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_HistoryChanged )( ICoreWebView2 * This, ICoreWebView2HistoryChangedEventHandler *eventHandler, EventRegistrationToken *token);
	add_HistoryChanged As Function stdcall (This As ICoreWebView2 Ptr, eventHandler As ICoreWebView2HistoryChangedEventHandler Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_HistoryChanged )( ICoreWebView2 * This, EventRegistrationToken token);
	remove_HistoryChanged As Function stdcall (This As ICoreWebView2 Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_NavigationCompleted )( ICoreWebView2 * This, ICoreWebView2NavigationCompletedEventHandler *eventHandler, EventRegistrationToken *token);
	add_NavigationCompleted As Function stdcall (This As ICoreWebView2 Ptr, eventHandler As ICoreWebView2NavigationCompletedEventHandler Ptr, token As EventRegistrationToken Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_NavigationCompleted )( ICoreWebView2 * This, EventRegistrationToken token);
	remove_NavigationCompleted As Function stdcall (This As ICoreWebView2 Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_FrameNavigationStarting )( ICoreWebView2 * This, ICoreWebView2NavigationStartingEventHandler *eventHandler, EventRegistrationToken *token);
	add_FrameNavigationStarting As Function stdcall (This As ICoreWebView2 Ptr, eventHandler As ICoreWebView2NavigationStartingEventHandler Ptr, token As EventRegistrationToken Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_FrameNavigationStarting )( ICoreWebView2 * This, EventRegistrationToken token);
	remove_FrameNavigationStarting As Function stdcall (This As ICoreWebView2 Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_FrameNavigationCompleted )( ICoreWebView2 * This, ICoreWebView2NavigationCompletedEventHandler *eventHandler, EventRegistrationToken *token);
	add_FrameNavigationCompleted As Function stdcall (This As ICoreWebView2 Ptr, eventHandler As ICoreWebView2NavigationCompletedEventHandler, token As EventRegistrationToken Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_FrameNavigationCompleted )( ICoreWebView2 * This, EventRegistrationToken token);
	remove_FrameNavigationCompleted As Function stdcall (This As ICoreWebView2 Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_ScriptDialogOpening )( ICoreWebView2 * This, ICoreWebView2ScriptDialogOpeningEventHandler *eventHandler, EventRegistrationToken *token);
	add_ScriptDialogOpening As Function stdcall (This As ICoreWebView2 Ptr, eventHandler As ICoreWebView2ScriptDialogOpeningEventHandler Ptr, token As EventRegistrationToken Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_ScriptDialogOpening )( ICoreWebView2 * This, EventRegistrationToken token);
	remove_ScriptDialogOpening As Function stdcall (This As ICoreWebView2 Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_PermissionRequested )( ICoreWebView2 * This, ICoreWebView2PermissionRequestedEventHandler *eventHandler, EventRegistrationToken *token);
	add_PermissionRequested As Function stdcall (This As ICoreWebView2 Ptr, eventHandler As ICoreWebView2PermissionRequestedEventHandler Ptr, token As EventRegistrationToken Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_PermissionRequested )( ICoreWebView2 * This, EventRegistrationToken token);
	remove_PermissionRequested As Function stdcall (This As ICoreWebView2 Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_ProcessFailed )( ICoreWebView2 * This, ICoreWebView2ProcessFailedEventHandler *eventHandler, EventRegistrationToken *token);
	add_ProcessFailed As Function(ByVal This As ICoreWebView2 Ptr, eventHandler As ICoreWebView2ProcessFailedEventHandler, token As EventRegistrationToken Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_ProcessFailed )( ICoreWebView2 * This, EventRegistrationToken token);
	remove_ProcessFailed As Function stdcall (This As ICoreWebView2 Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *AddScriptToExecuteOnDocumentCreated )( ICoreWebView2 * This, LPCWSTR javaScript, ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler *handler);
	AddScriptToExecuteOnDocumentCreated As Function stdcall (This As ICoreWebView2 Ptr, javaScript As LPCWSTR, handler As ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *RemoveScriptToExecuteOnDocumentCreated )( ICoreWebView2 * This, LPCWSTR id);
	RemoveScriptToExecuteOnDocumentCreated As Function stdcall (This As ICoreWebView2 Ptr, id As LPCWSTR) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *ExecuteScript )( ICoreWebView2 * This, LPCWSTR javaScript, ICoreWebView2ExecuteScriptCompletedHandler *handler);
	ExecuteScript As Function stdcall (This As ICoreWebView2 Ptr, javaScript As LPCWSTR, handler As ICoreWebView2ExecuteScriptCompletedHandler Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *CapturePreview )( ICoreWebView2 * This, COREWEBVIEW2_CAPTURE_PREVIEW_IMAGE_FORMAT imageFormat, IStream *imageStream, ICoreWebView2CapturePreviewCompletedHandler *handler);
	CapturePreview As Function stdcall (This As ICoreWebView2 Ptr, imageFormat As COREWEBVIEW2_CAPTURE_PREVIEW_IMAGE_FORMAT, imageStream As IStream Ptr, handler As ICoreWebView2CapturePreviewCompletedHandler) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Reload )( ICoreWebView2 * This);
	Reload As Function stdcall (This As ICoreWebView2 Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *PostWebMessageAsJson )( ICoreWebView2 * This, LPCWSTR webMessageAsJson);
	PostWebMessageAsJson As Function stdcall (This As ICoreWebView2 Ptr, webMessageAsJson As LPCWSTR) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *PostWebMessageAsString )( ICoreWebView2 * This, LPCWSTR webMessageAsString);
	PostWebMessageAsString As Function stdcall (This As ICoreWebView2 Ptr, webMessageAsString As LPCWSTR) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_WebMessageReceived )( ICoreWebView2 * This, ICoreWebView2WebMessageReceivedEventHandler *handler, EventRegistrationToken *token);
	add_WebMessageReceived As Function stdcall (This As ICoreWebView2 Ptr, handler As LPCWSTR, handler As ICoreWebView2WebMessageReceivedEventHandler Ptr, token As EventRegistrationToken Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_WebMessageReceived )( ICoreWebView2 * This, EventRegistrationToken token);
	remove_WebMessageReceived As Function stdcall (This As ICoreWebView2 Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *CallDevToolsProtocolMethod )( ICoreWebView2 * This, LPCWSTR methodName, LPCWSTR parametersAsJson, ICoreWebView2CallDevToolsProtocolMethodCompletedHandler *handler);
	CallDevToolsProtocolMethod As Function stdcall (This As ICoreWebView2 Ptr, methodName As LPCWSTR, parametersAsJson As LPCWSTR, handler As ICoreWebView2CallDevToolsProtocolMethodCompletedHandler Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_BrowserProcessId )( ICoreWebView2 * This, UINT32 *value);
	get_BrowserProcessId As Function stdcall (This As ICoreWebView2 Ptr, value As UINT32 Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_CanGoBack )( ICoreWebView2 * This, BOOL *canGoBack);
	get_CanGoBack As Function stdcall (This As ICoreWebView2 Ptr, canGoBack As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_CanGoForward )( ICoreWebView2 * This, BOOL *canGoForward);
	get_CanGoForward As Function stdcall (This As ICoreWebView2 Ptr, canGoForward As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *GoBack )( ICoreWebView2 * This);
	GoBack As Function stdcall (This As ICoreWebView2 Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *GoForward )( ICoreWebView2 * This);
	GoForward As Function stdcall (This As ICoreWebView2 Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *GetDevToolsProtocolEventReceiver )( ICoreWebView2 * This, LPCWSTR eventName, ICoreWebView2DevToolsProtocolEventReceiver **receiver);
	GetDevToolsProtocolEventReceiver As Function stdcall (This As ICoreWebView2 Ptr, eventName As LPCWSTR, receiver As ICoreWebView2DevToolsProtocolEventReceiver Ptr Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Stop )( ICoreWebView2 * This);
	Stop As Function stdcall (This As ICoreWebView2 Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_NewWindowRequested )( ICoreWebView2 * This, ICoreWebView2NewWindowRequestedEventHandler *eventHandler, EventRegistrationToken *token);
	add_NewWindowRequested As Function stdcall (This As ICoreWebView2 Ptr, eventHandler As ICoreWebView2NewWindowRequestedEventHandler Ptr, token As EventRegistrationToken Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_NewWindowRequested )( ICoreWebView2 * This, EventRegistrationToken token);
	remove_NewWindowRequested As Function stdcall (This As ICoreWebView2 Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_DocumentTitleChanged )( ICoreWebView2 * This, ICoreWebView2DocumentTitleChangedEventHandler *eventHandler, EventRegistrationToken *token);
	add_DocumentTitleChanged As Function stdcall (This As ICoreWebView2 Ptr, eventHandler As ICoreWebView2DocumentTitleChangedEventHandler, token As EventRegistrationToken Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_DocumentTitleChanged )( ICoreWebView2 * This, EventRegistrationToken token);
	remove_DocumentTitleChanged As Function stdcall (This As ICoreWebView2 Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_DocumentTitle )( ICoreWebView2 * This, LPWSTR *title);
	get_DocumentTitle As Function stdcall (This As ICoreWebView2 Ptr, title As LPWSTR) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *AddHostObjectToScript )( ICoreWebView2 * This, LPCWSTR name, VARIANT *object);
	AddHostObjectToScript As Function stdcall (This As ICoreWebView2 Ptr, name As LPWSTR, Object As VARIANT Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *RemoveHostObjectFromScript )( ICoreWebView2 * This, LPCWSTR name);
	RemoveHostObjectFromScript As Function stdcall (This As ICoreWebView2 Ptr, name As LPWSTR) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *OpenDevToolsWindow )( ICoreWebView2 * This);
	OpenDevToolsWindow As Function stdcall (This As ICoreWebView2 Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_ContainsFullScreenElementChanged )( ICoreWebView2 * This, ICoreWebView2ContainsFullScreenElementChangedEventHandler *eventHandler, EventRegistrationToken *token);
	add_ContainsFullScreenElementChanged As Function stdcall (This As ICoreWebView2 Ptr, eventHandler As ICoreWebView2ContainsFullScreenElementChangedEventHandler Ptr, token As EventRegistrationToken Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_ContainsFullScreenElementChanged )( ICoreWebView2 * This, EventRegistrationToken token);
	remove_ContainsFullScreenElementChanged As Function stdcall (This As ICoreWebView2 Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_ContainsFullScreenElement )( ICoreWebView2 * This, BOOL *containsFullScreenElement);
	get_ContainsFullScreenElement As Function stdcall (This As ICoreWebView2 Ptr, containsFullScreenElement As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_WebResourceRequested )( ICoreWebView2 * This, ICoreWebView2WebResourceRequestedEventHandler *eventHandler, EventRegistrationToken *token);
	add_WebResourceRequested As Function stdcall (This As ICoreWebView2 Ptr, eventHandler As ICoreWebView2WebResourceRequestedEventHandler, token As EventRegistrationToken Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_WebResourceRequested )( ICoreWebView2 * This, EventRegistrationToken token);
	remove_WebResourceRequested As Function stdcall (This As ICoreWebView2 Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *AddWebResourceRequestedFilter )( ICoreWebView2 * This, const LPCWSTR uri, const COREWEBVIEW2_WEB_RESOURCE_CONTEXT resourceContext);
	AddWebResourceRequestedFilter As Function stdcall (This As ICoreWebView2 Ptr, uri As Const LPCWSTR, resourceContext As Const COREWEBVIEW2_WEB_RESOURCE_CONTEXT) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *RemoveWebResourceRequestedFilter )( ICoreWebView2 * This, const LPCWSTR uri, const COREWEBVIEW2_WEB_RESOURCE_CONTEXT resourceContext);
	RemoveWebResourceRequestedFilter As Function stdcall (This As ICoreWebView2 Ptr, uri As Const LPCWSTR, resourceContext As Const COREWEBVIEW2_WEB_RESOURCE_CONTEXT) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_WindowCloseRequested )( ICoreWebView2 * This, ICoreWebView2WindowCloseRequestedEventHandler *eventHandler, EventRegistrationToken *token);
	add_WindowCloseRequested As Function stdcall (This As ICoreWebView2 Ptr, eventHandler As ICoreWebView2WindowCloseRequestedEventHandler, resourceContext As Const COREWEBVIEW2_WEB_RESOURCE_CONTEXT) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_WindowCloseRequested )( ICoreWebView2 * This, EventRegistrationToken token);
	remove_WindowCloseRequested As Function stdcall (This As ICoreWebView2 Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2_
	lpVtbl As ICoreWebView2Vtbl Ptr
End Type

#define __ICoreWebView2Controller_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2Controller;
Type ICoreWebView2ZoomFactorChangedEventHandler As ICoreWebView2ZoomFactorChangedEventHandler_
Type ICoreWebView2MoveFocusRequestedEventHandler As ICoreWebView2MoveFocusRequestedEventHandler_
Type ICoreWebView2FocusChangedEventHandler As ICoreWebView2FocusChangedEventHandler_
Type ICoreWebView2Controller As ICoreWebView2Controller_
Type ICoreWebView2ControllerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2Controller * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2Controller Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2Controller * This);
	AddRef As Function stdcall (This As ICoreWebView2Controller Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2Controller * This);
	Release As Function stdcall (This As ICoreWebView2Controller Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_IsVisible )( ICoreWebView2Controller * This, BOOL *isVisible);
	get_IsVisible As Function stdcall (This As ICoreWebView2Controller Ptr, isVisible As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_IsVisible )( ICoreWebView2Controller * This, BOOL isVisible);
	put_IsVisible As Function stdcall (This As ICoreWebView2Controller Ptr, isVisible As BOOL) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Bounds )( ICoreWebView2Controller * This, RECT *bounds);
	get_Bounds As Function stdcall (This As ICoreWebView2Controller Ptr, bounds As RECT Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_Bounds )( ICoreWebView2Controller * This, RECT bounds);
	put_Bounds As Function stdcall (This As ICoreWebView2Controller Ptr, bounds As RECT) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_ZoomFactor )( ICoreWebView2Controller * This, double *zoomFactor);
	get_ZoomFactor As Function stdcall (This As ICoreWebView2Controller Ptr, zoomFactor As Double Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_ZoomFactor )( ICoreWebView2Controller * This, double zoomFactor);
	put_ZoomFactor As Function stdcall (This As ICoreWebView2Controller Ptr, zoomFactor As Double) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_ZoomFactorChanged )( ICoreWebView2Controller * This, ICoreWebView2ZoomFactorChangedEventHandler *eventHandler, EventRegistrationToken *token);
	add_ZoomFactorChanged As Function stdcall (This As ICoreWebView2Controller Ptr, eventHandler As ICoreWebView2ZoomFactorChangedEventHandler Ptr, token As EventRegistrationToken Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_ZoomFactorChanged )( ICoreWebView2Controller * This, EventRegistrationToken token);
	remove_ZoomFactorChanged As Function stdcall (This As ICoreWebView2Controller Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *SetBoundsAndZoomFactor )( ICoreWebView2Controller * This, RECT bounds, double zoomFactor);
	SetBoundsAndZoomFactor As Function stdcall (This As ICoreWebView2Controller Ptr, bounds As RECT, zoomFactor As Double) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *MoveFocus )( ICoreWebView2Controller * This, COREWEBVIEW2_MOVE_FOCUS_REASON reason);
	MoveFocus As Function stdcall (This As ICoreWebView2Controller Ptr, reason As COREWEBVIEW2_MOVE_FOCUS_REASON) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_MoveFocusRequested )( ICoreWebView2Controller * This, ICoreWebView2MoveFocusRequestedEventHandler *eventHandler, EventRegistrationToken *token);
	add_MoveFocusRequested As Function stdcall (This As ICoreWebView2Controller Ptr, eventHandler As ICoreWebView2MoveFocusRequestedEventHandler Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_MoveFocusRequested )( ICoreWebView2Controller * This, EventRegistrationToken token);
	remove_MoveFocusRequested As Function stdcall (This As ICoreWebView2Controller Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_GotFocus )( ICoreWebView2Controller * This, ICoreWebView2FocusChangedEventHandler *eventHandler, EventRegistrationToken *token);
	add_GotFocus As Function stdcall (This As ICoreWebView2Controller Ptr, eventHandler As ICoreWebView2FocusChangedEventHandler Ptr, token As EventRegistrationToken Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_GotFocus )( ICoreWebView2Controller * This, EventRegistrationToken token);
	remove_GotFocus As Function stdcall (This As ICoreWebView2Controller Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_LostFocus )( ICoreWebView2Controller * This, ICoreWebView2FocusChangedEventHandler *eventHandler, EventRegistrationToken *token);
	add_LostFocus As Function stdcall (This As ICoreWebView2Controller Ptr, eventHandler As ICoreWebView2FocusChangedEventHandler, token As EventRegistrationToken Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_LostFocus )( ICoreWebView2Controller * This, EventRegistrationToken token);
	remove_LostFocus As Function stdcall (This As ICoreWebView2Controller Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_AcceleratorKeyPressed )( ICoreWebView2Controller * This, ICoreWebView2AcceleratorKeyPressedEventHandler *eventHandler, EventRegistrationToken *token);
	add_AcceleratorKeyPressed As Function stdcall (This As ICoreWebView2Controller Ptr, eventHandler As ICoreWebView2AcceleratorKeyPressedEventHandler Ptr, token As EventRegistrationToken Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_AcceleratorKeyPressed )( ICoreWebView2Controller * This, EventRegistrationToken token);
	remove_AcceleratorKeyPressed As Function stdcall (This As ICoreWebView2Controller Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_ParentWindow )( ICoreWebView2Controller * This, HWND *topLevelWindow);
	get_ParentWindow As Function stdcall (This As ICoreWebView2Controller Ptr, topLevelWindow As HWND Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_ParentWindow )( ICoreWebView2Controller * This, HWND topLevelWindow);
	put_ParentWindow As Function stdcall (This As ICoreWebView2Controller Ptr, topLevelWindow As HWND) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *NotifyParentWindowPositionChanged )( ICoreWebView2Controller * This);
	NotifyParentWindowPositionChanged As Function stdcall (This As ICoreWebView2Controller Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Close )( ICoreWebView2Controller * This);
	Close As Function stdcall (This As ICoreWebView2Controller Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_CoreWebView2 )( ICoreWebView2Controller * This, ICoreWebView2 **coreWebView2);
	get_CoreWebView2 As Function stdcall (This As ICoreWebView2Controller Ptr, coreWebView2 As ICoreWebView2 Ptr Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2Controller_
	lpVtbl As ICoreWebView2ControllerVtbl Ptr
End Type

#define __ICoreWebView2ContentLoadingEventArgs_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2ContentLoadingEventArgs;

Type ICoreWebView2ContentLoadingEventArgs As ICoreWebView2ContentLoadingEventArgs_
Type ICoreWebView2ContentLoadingEventArgsVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2ContentLoadingEventArgs * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2ContentLoadingEventArgs Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2ContentLoadingEventArgs * This);
	AddRef As Function stdcall (This As ICoreWebView2ContentLoadingEventArgs Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2ContentLoadingEventArgs * This);
	Release As Function stdcall (This As ICoreWebView2ContentLoadingEventArgs Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_IsErrorPage )( ICoreWebView2ContentLoadingEventArgs * This, BOOL *isErrorPage);
	get_IsErrorPage As Function stdcall (This As ICoreWebView2ContentLoadingEventArgs Ptr, isErrorPage As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_NavigationId )( ICoreWebView2ContentLoadingEventArgs * This, UINT64 *navigation_id);
	get_NavigationId As Function stdcall (This As ICoreWebView2ContentLoadingEventArgs Ptr, navigation_id As UINT64 Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2ContentLoadingEventArgs_
	lpVtbl As ICoreWebView2ContentLoadingEventArgsVtbl Ptr
End Type

#define __ICoreWebView2ContentLoadingEventHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2ContentLoadingEventHandler;

Type ICoreWebView2ContentLoadingEventHandler As ICoreWebView2ContentLoadingEventHandler_
Type ICoreWebView2ContentLoadingEventHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2ContentLoadingEventHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2ContentLoadingEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2ContentLoadingEventHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2ContentLoadingEventHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2ContentLoadingEventHandler * This);
	Release As Function stdcall (This As ICoreWebView2ContentLoadingEventHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2ContentLoadingEventHandler * This, ICoreWebView2 *webview, ICoreWebView2ContentLoadingEventArgs *args);
	Invoke As Function stdcall (This As ICoreWebView2ContentLoadingEventHandler Ptr, webview As ICoreWebView2, args As ICoreWebView2ContentLoadingEventArgs Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2ContentLoadingEventHandler_
	lpVtbl As ICoreWebView2ContentLoadingEventHandlerVtbl Ptr
End Type

#define __ICoreWebView2DocumentTitleChangedEventHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2DocumentTitleChangedEventHandler;

Type ICoreWebView2DocumentTitleChangedEventHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2DocumentTitleChangedEventHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2DocumentTitleChangedEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2DocumentTitleChangedEventHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2DocumentTitleChangedEventHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2DocumentTitleChangedEventHandler * This);
	Release As Function stdcall (This As ICoreWebView2DocumentTitleChangedEventHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2DocumentTitleChangedEventHandler * This, ICoreWebView2 *sender, IUnknown *args);
	Invoke As Function stdcall (This As ICoreWebView2DocumentTitleChangedEventHandler Ptr, sender As ICoreWebView2 Ptr, args As IUnknown Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2DocumentTitleChangedEventHandler_
	lpVtbl As ICoreWebView2DocumentTitleChangedEventHandlerVtbl Ptr
End Type

#define __ICoreWebView2ContainsFullScreenElementChangedEventHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2ContainsFullScreenElementChangedEventHandler;

Type ICoreWebView2ContainsFullScreenElementChangedEventHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2ContainsFullScreenElementChangedEventHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2ContainsFullScreenElementChangedEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2ContainsFullScreenElementChangedEventHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2ContainsFullScreenElementChangedEventHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2ContainsFullScreenElementChangedEventHandler * This);
	Release As Function stdcall (This As ICoreWebView2ContainsFullScreenElementChangedEventHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2ContainsFullScreenElementChangedEventHandler * This, ICoreWebView2 *sender, IUnknown *args);
	Invoke As Function stdcall (This As ICoreWebView2ContainsFullScreenElementChangedEventHandler Ptr, sender As ICoreWebView2 Ptr, args As IUnknown Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2ContainsFullScreenElementChangedEventHandler_
	lpVtbl As ICoreWebView2ContainsFullScreenElementChangedEventHandlerVtbl Ptr
End Type

#define __ICoreWebView2CreateCoreWebView2ControllerCompletedHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2CreateCoreWebView2ControllerCompletedHandler;

Type ICoreWebView2CreateCoreWebView2ControllerCompletedHandler As ICoreWebView2CreateCoreWebView2ControllerCompletedHandler_
Type ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2CreateCoreWebView2ControllerCompletedHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2CreateCoreWebView2ControllerCompletedHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2CreateCoreWebView2ControllerCompletedHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2CreateCoreWebView2ControllerCompletedHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2CreateCoreWebView2ControllerCompletedHandler * This);
	Release As Function stdcall (This As ICoreWebView2CreateCoreWebView2ControllerCompletedHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2CreateCoreWebView2ControllerCompletedHandler * This, HRESULT result, ICoreWebView2Controller *createdController);
	Invoke As Function stdcall (This As ICoreWebView2CreateCoreWebView2ControllerCompletedHandler Ptr, result As HRESULT, createdController As ICoreWebView2Controller Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2CreateCoreWebView2ControllerCompletedHandler_
	lpVtbl As ICoreWebView2CreateCoreWebView2ControllerCompletedHandlerVtbl Ptr
End Type

#define __ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler;
Type ICoreWebView2Environment As ICoreWebView2Environment_
Type ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall(This As ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler * This);
	AddRef As Function stdcall(This As ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler * This);
	Release As Function stdcall(This As ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler * This, HRESULT result, ICoreWebView2Environment *created_environment);
	Invoke As Function stdcall(This As ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler Ptr, result As HRESULT, created_environment As ICoreWebView2Environment Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler_
	lpVtbl As ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandlerVtbl Ptr
End Type

#define __ICoreWebView2Deferral_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2Deferral;

Type ICoreWebView2Deferral As ICoreWebView2Deferral_
Type ICoreWebView2DeferralVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2Deferral * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2Deferral Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2Deferral * This);
	AddRef As Function stdcall (This As ICoreWebView2Deferral Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2Deferral * This);
	Release As Function stdcall (This As ICoreWebView2Deferral Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Complete )( ICoreWebView2Deferral * This);
	Complete As Function stdcall (This As ICoreWebView2Deferral Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2Deferral_
	lpVtbl As ICoreWebView2DeferralVtbl Ptr
End Type

#define __ICoreWebView2DevToolsProtocolEventReceivedEventArgs_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2DevToolsProtocolEventReceivedEventArgs;

Type ICoreWebView2DevToolsProtocolEventReceivedEventArgs As ICoreWebView2DevToolsProtocolEventReceivedEventArgs_
Type ICoreWebView2DevToolsProtocolEventReceivedEventArgsVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2DevToolsProtocolEventReceivedEventArgs * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2DevToolsProtocolEventReceivedEventArgs Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2DevToolsProtocolEventReceivedEventArgs * This);
	AddRef As Function stdcall (This As ICoreWebView2DevToolsProtocolEventReceivedEventArgs Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2DevToolsProtocolEventReceivedEventArgs * This);
	Release As Function stdcall (This As ICoreWebView2DevToolsProtocolEventReceivedEventArgs Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_ParameterObjectAsJson )( ICoreWebView2DevToolsProtocolEventReceivedEventArgs * This, LPWSTR *parameterObjectAsJson);
	get_ParameterObjectAsJson As Function stdcall (This As ICoreWebView2DevToolsProtocolEventReceivedEventArgs Ptr, parameterObjectAsJson As LPWSTR Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2DevToolsProtocolEventReceivedEventArgs_
	lpVtbl As ICoreWebView2DevToolsProtocolEventReceivedEventArgsVtbl Ptr
End Type

#define __ICoreWebView2DevToolsProtocolEventReceivedEventHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2DevToolsProtocolEventReceivedEventHandler;

Type ICoreWebView2DevToolsProtocolEventReceivedEventHandler As ICoreWebView2DevToolsProtocolEventReceivedEventHandler_
Type ICoreWebView2DevToolsProtocolEventReceivedEventHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2DevToolsProtocolEventReceivedEventHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2DevToolsProtocolEventReceivedEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2DevToolsProtocolEventReceivedEventHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2DevToolsProtocolEventReceivedEventHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2DevToolsProtocolEventReceivedEventHandler * This);
	Release As Function stdcall (This As ICoreWebView2DevToolsProtocolEventReceivedEventHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2DevToolsProtocolEventReceivedEventHandler * This, ICoreWebView2 *sender, ICoreWebView2DevToolsProtocolEventReceivedEventArgs *args);
	Invoke As Function stdcall (This As ICoreWebView2DevToolsProtocolEventReceivedEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2DevToolsProtocolEventReceivedEventArgs Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2DevToolsProtocolEventReceivedEventHandler_
	lpVtbl As ICoreWebView2DevToolsProtocolEventReceivedEventHandlerVtbl Ptr
End Type

#define __ICoreWebView2DevToolsProtocolEventReceiver_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2DevToolsProtocolEventReceiver;

Type ICoreWebView2DevToolsProtocolEventReceiverVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2DevToolsProtocolEventReceiver * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2DevToolsProtocolEventReceiver Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2DevToolsProtocolEventReceiver * This);
	AddRef As Function stdcall (This As ICoreWebView2DevToolsProtocolEventReceiver Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2DevToolsProtocolEventReceiver * This);
	Release As Function stdcall (This As ICoreWebView2DevToolsProtocolEventReceiver Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_DevToolsProtocolEventReceived )( ICoreWebView2DevToolsProtocolEventReceiver * This, ICoreWebView2DevToolsProtocolEventReceivedEventHandler *handler, EventRegistrationToken *token);
	add_DevToolsProtocolEventReceived As Function stdcall (This As ICoreWebView2DevToolsProtocolEventReceiver Ptr, handler As ICoreWebView2DevToolsProtocolEventReceivedEventHandler Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_DevToolsProtocolEventReceived )( ICoreWebView2DevToolsProtocolEventReceiver * This, EventRegistrationToken token);
	remove_DevToolsProtocolEventReceived As Function stdcall (This As ICoreWebView2DevToolsProtocolEventReceiver Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2DevToolsProtocolEventReceiver_
	lpVtbl As ICoreWebView2DevToolsProtocolEventReceiverVtbl Ptr
End Type

#define __ICoreWebView2Environment_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2Environment;

Type ICoreWebView2WebResourceResponse As ICoreWebView2WebResourceResponse_
Type ICoreWebView2NewBrowserVersionAvailableEventHandler As ICoreWebView2NewBrowserVersionAvailableEventHandler_
Type ICoreWebView2EnvironmentVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2Environment * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2Environment Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2Environment * This);
	AddRef As Function stdcall (This As ICoreWebView2Environment Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2Environment * This);
	Release As Function stdcall (This As ICoreWebView2Environment Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *CreateCoreWebView2Controller )( ICoreWebView2Environment * This, HWND parentWindow, ICoreWebView2CreateCoreWebView2ControllerCompletedHandler *handler);
	CreateCoreWebView2Controller As Function stdcall (This As ICoreWebView2Environment Ptr, parentWindow As HWND, handler As ICoreWebView2CreateCoreWebView2ControllerCompletedHandler Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *CreateWebResourceResponse )( ICoreWebView2Environment * This, IStream *content, int statusCode, LPCWSTR reasonPhrase, LPCWSTR headers, ICoreWebView2WebResourceResponse **response);
	CreateWebResourceResponse As Function stdcall (This As ICoreWebView2Environment Ptr, content As IStream Ptr, statusCode As Integer, reasonPhrase As LPCWSTR, headers As LPCWSTR, response As ICoreWebView2WebResourceResponse Ptr Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_BrowserVersionString )( ICoreWebView2Environment * This, LPWSTR *versionInfo);
	get_BrowserVersionString As Function stdcall (This As ICoreWebView2Environment Ptr, versionInfo As LPWSTR Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *add_NewBrowserVersionAvailable )( ICoreWebView2Environment * This, ICoreWebView2NewBrowserVersionAvailableEventHandler *eventHandler, EventRegistrationToken *token);
	add_NewBrowserVersionAvailable As Function stdcall (This As ICoreWebView2Environment Ptr, eventHandler As ICoreWebView2NewBrowserVersionAvailableEventHandler Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *remove_NewBrowserVersionAvailable )( ICoreWebView2Environment * This, EventRegistrationToken token);
	remove_NewBrowserVersionAvailable As Function stdcall (This As ICoreWebView2Environment Ptr, token As EventRegistrationToken) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2Environment_
	lpVtbl As ICoreWebView2EnvironmentVtbl Ptr
End Type

#define __ICoreWebView2EnvironmentOptions_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2EnvironmentOptions;

Type ICoreWebView2EnvironmentOptionsVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2EnvironmentOptions * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2EnvironmentOptions Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2EnvironmentOptions * This);
	AddRef As Function stdcall (This As ICoreWebView2EnvironmentOptions Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2EnvironmentOptions * This);
	Release As Function stdcall (This As ICoreWebView2EnvironmentOptions Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_AdditionalBrowserArguments )( ICoreWebView2EnvironmentOptions * This, LPWSTR *value);
	get_AdditionalBrowserArguments As Function stdcall (This As ICoreWebView2EnvironmentOptions Ptr, value As LPWSTR Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_AdditionalBrowserArguments )( ICoreWebView2EnvironmentOptions * This, LPCWSTR value);
	put_AdditionalBrowserArguments As Function stdcall (This As ICoreWebView2EnvironmentOptions Ptr, value As LPWSTR) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Language )( ICoreWebView2EnvironmentOptions * This, LPWSTR *value);
	get_Language As Function stdcall (This As ICoreWebView2EnvironmentOptions Ptr, value As LPWSTR Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_Language )( ICoreWebView2EnvironmentOptions * This, LPCWSTR value);
	put_Language As Function stdcall (This As ICoreWebView2EnvironmentOptions Ptr, value As LPWSTR) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_TargetCompatibleBrowserVersion )( ICoreWebView2EnvironmentOptions * This, LPWSTR *value);
	get_TargetCompatibleBrowserVersion As Function stdcall (This As ICoreWebView2EnvironmentOptions Ptr, value As LPWSTR Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_TargetCompatibleBrowserVersion )( ICoreWebView2EnvironmentOptions * This, LPCWSTR value);
	put_TargetCompatibleBrowserVersion As Function stdcall (This As ICoreWebView2EnvironmentOptions Ptr, value As LPWSTR) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2EnvironmentOptions_
	lpVtbl As ICoreWebView2EnvironmentOptionsVtbl Ptr
End Type

#define __ICoreWebView2ExecuteScriptCompletedHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2ExecuteScriptCompletedHandler;

Type ICoreWebView2ExecuteScriptCompletedHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2ExecuteScriptCompletedHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2ExecuteScriptCompletedHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2ExecuteScriptCompletedHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2ExecuteScriptCompletedHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2ExecuteScriptCompletedHandler * This);
	Release As Function stdcall (This As ICoreWebView2ExecuteScriptCompletedHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2ExecuteScriptCompletedHandler * This, HRESULT errorCode, LPCWSTR resultObjectAsJson);
	Invoke As Function stdcall (This As ICoreWebView2ExecuteScriptCompletedHandler Ptr, errorCode As HRESULT, resultObjectAsJson As LPCWSTR) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2ExecuteScriptCompletedHandler_
	lpVtbl As ICoreWebView2ExecuteScriptCompletedHandlerVtbl Ptr
End Type

#define __ICoreWebView2FocusChangedEventHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2FocusChangedEventHandler;

Type ICoreWebView2FocusChangedEventHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2FocusChangedEventHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2FocusChangedEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2FocusChangedEventHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2FocusChangedEventHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2FocusChangedEventHandler * This);
	Release As Function stdcall (This As ICoreWebView2FocusChangedEventHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2FocusChangedEventHandler * This, ICoreWebView2Controller *sender, IUnknown *args);
	Invoke As Function stdcall (This As ICoreWebView2FocusChangedEventHandler Ptr, sender As ICoreWebView2Controller Ptr, args As IUnknown Ptr) As CULONG
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2FocusChangedEventHandler_
	lpVtbl As ICoreWebView2FocusChangedEventHandlerVtbl Ptr
End Type

#define __ICoreWebView2HistoryChangedEventHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2HistoryChangedEventHandler;

Type ICoreWebView2HistoryChangedEventHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2HistoryChangedEventHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2HistoryChangedEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2HistoryChangedEventHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2HistoryChangedEventHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2HistoryChangedEventHandler * This);
	Release As Function stdcall (This As ICoreWebView2HistoryChangedEventHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2HistoryChangedEventHandler * This, ICoreWebView2 *webview, IUnknown *args);
	Invoke As Function stdcall (This As ICoreWebView2HistoryChangedEventHandler Ptr, webview As ICoreWebView2 Ptr, args As IUnknown Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2HistoryChangedEventHandler_
	lpVtbl As ICoreWebView2HistoryChangedEventHandlerVtbl Ptr
End Type

#define __ICoreWebView2HttpHeadersCollectionIterator_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2HttpHeadersCollectionIterator;

Type ICoreWebView2HttpHeadersCollectionIterator As ICoreWebView2HttpHeadersCollectionIterator_
Type ICoreWebView2HttpHeadersCollectionIteratorVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2HttpHeadersCollectionIterator * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2HttpHeadersCollectionIterator Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2HttpHeadersCollectionIterator * This);
	AddRef As Function stdcall (This As ICoreWebView2HttpHeadersCollectionIterator Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2HttpHeadersCollectionIterator * This);
	Release As Function stdcall (This As ICoreWebView2HttpHeadersCollectionIterator Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *GetCurrentHeader )( ICoreWebView2HttpHeadersCollectionIterator * This, LPWSTR *name, LPWSTR *value);
	GetCurrentHeader As Function stdcall (This As ICoreWebView2HttpHeadersCollectionIterator Ptr, Name As LPWSTR Ptr, value As LPWSTR Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_HasCurrentHeader )( ICoreWebView2HttpHeadersCollectionIterator * This, BOOL *hasCurrent);
	get_HasCurrentHeader As Function stdcall (This As ICoreWebView2HttpHeadersCollectionIterator Ptr, hasCurrent As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *MoveNext )( ICoreWebView2HttpHeadersCollectionIterator * This, BOOL *hasNext);
	MoveNext As Function stdcall (This As ICoreWebView2HttpHeadersCollectionIterator Ptr, hasNext As BOOL Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2HttpHeadersCollectionIterator_
	lpVtbl As ICoreWebView2HttpHeadersCollectionIteratorVtbl Ptr
End Type

#define __ICoreWebView2HttpRequestHeaders_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2HttpRequestHeaders;

Type ICoreWebView2HttpRequestHeaders As ICoreWebView2HttpRequestHeaders_
Type ICoreWebView2HttpRequestHeadersVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2HttpRequestHeaders * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2HttpRequestHeaders Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2HttpRequestHeaders * This);
	AddRef As Function stdcall (This As ICoreWebView2HttpRequestHeaders Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2HttpRequestHeaders * This);
	Release As Function stdcall (This As ICoreWebView2HttpRequestHeaders Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *GetHeader )( ICoreWebView2HttpRequestHeaders * This, LPCWSTR name, LPWSTR *value);
	GetHeader As Function stdcall (This As ICoreWebView2HttpRequestHeaders Ptr, Name As LPCWSTR, value As LPWSTR Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *GetHeaders )( ICoreWebView2HttpRequestHeaders * This, LPCWSTR name, ICoreWebView2HttpHeadersCollectionIterator **iterator);
	GetHeaders As Function stdcall (This As ICoreWebView2HttpRequestHeaders Ptr, Name As LPCWSTR, iterator As ICoreWebView2HttpHeadersCollectionIterator Ptr Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Contains )( ICoreWebView2HttpRequestHeaders * This, LPCWSTR name, BOOL *contains);
	Contains As Function stdcall (This As ICoreWebView2HttpRequestHeaders Ptr, Name As LPCWSTR, contains_ As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *SetHeader )( ICoreWebView2HttpRequestHeaders * This, LPCWSTR name, LPCWSTR value);
	SetHeader As Function stdcall (This As ICoreWebView2HttpRequestHeaders Ptr, Name As LPCWSTR, value As LPCWSTR Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *RemoveHeader )( ICoreWebView2HttpRequestHeaders * This, LPCWSTR name);
	RemoveHeader As Function stdcall (This As ICoreWebView2HttpRequestHeaders Ptr, Name As LPCWSTR) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *GetIterator )( ICoreWebView2HttpRequestHeaders * This, ICoreWebView2HttpHeadersCollectionIterator **iterator);
	GetIterator As Function stdcall (This As ICoreWebView2HttpRequestHeaders Ptr, iterator As ICoreWebView2HttpHeadersCollectionIterator Ptr Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2HttpRequestHeaders_
	lpVtbl As ICoreWebView2HttpRequestHeadersVtbl Ptr
End Type

#define __ICoreWebView2HttpResponseHeaders_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2HttpResponseHeaders;

Type ICoreWebView2HttpResponseHeaders As ICoreWebView2HttpResponseHeaders_
Type ICoreWebView2HttpResponseHeadersVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2HttpResponseHeaders * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2HttpResponseHeaders Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2HttpResponseHeaders * This);
	AddRef As Function stdcall (This As ICoreWebView2HttpResponseHeaders Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2HttpResponseHeaders * This);
	Release As Function stdcall (This As ICoreWebView2HttpResponseHeaders Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *AppendHeader )( ICoreWebView2HttpResponseHeaders * This, LPCWSTR name, LPCWSTR value);
	AppendHeader As Function stdcall (This As ICoreWebView2HttpResponseHeaders Ptr, Name As LPCWSTR, value As LPCWSTR) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Contains )( ICoreWebView2HttpResponseHeaders * This, LPCWSTR name, BOOL *contains);
	Contains As Function stdcall (This As ICoreWebView2HttpResponseHeaders Ptr, Name As LPCWSTR, contains_ As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *GetHeader )( ICoreWebView2HttpResponseHeaders * This, LPCWSTR name, LPWSTR *value);
	GetHeader As Function stdcall (This As ICoreWebView2HttpResponseHeaders Ptr, Name As LPCWSTR, value As LPWSTR) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *GetHeaders )( ICoreWebView2HttpResponseHeaders * This, LPCWSTR name, ICoreWebView2HttpHeadersCollectionIterator **iterator);
	GetHeaders As Function stdcall (This As ICoreWebView2HttpResponseHeaders Ptr, Name As LPCWSTR, iterator As ICoreWebView2HttpHeadersCollectionIterator Ptr Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *GetIterator )( ICoreWebView2HttpResponseHeaders * This, ICoreWebView2HttpHeadersCollectionIterator **iterator);
	GetIterator As Function stdcall (This As ICoreWebView2HttpResponseHeaders Ptr, Name As LPCWSTR, iterator As ICoreWebView2HttpHeadersCollectionIterator Ptr Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2HttpResponseHeaders_
	lpVtbl As ICoreWebView2HttpResponseHeadersVtbl Ptr
End Type

#define __ICoreWebView2MoveFocusRequestedEventArgs_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2MoveFocusRequestedEventArgs;

Type ICoreWebView2MoveFocusRequestedEventArgs As ICoreWebView2MoveFocusRequestedEventArgs_
Type ICoreWebView2MoveFocusRequestedEventArgsVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2MoveFocusRequestedEventArgs * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2MoveFocusRequestedEventArgs Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2MoveFocusRequestedEventArgs * This);
	AddRef As Function stdcall (This As ICoreWebView2MoveFocusRequestedEventArgs Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2MoveFocusRequestedEventArgs * This);
	Release As Function stdcall (This As ICoreWebView2MoveFocusRequestedEventArgs Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Reason )( ICoreWebView2MoveFocusRequestedEventArgs * This, COREWEBVIEW2_MOVE_FOCUS_REASON *value);
	get_Reason As Function stdcall (This As ICoreWebView2MoveFocusRequestedEventArgs Ptr, value As COREWEBVIEW2_MOVE_FOCUS_REASON) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Handled )( ICoreWebView2MoveFocusRequestedEventArgs * This, BOOL *value);
	get_Handled As Function stdcall (This As ICoreWebView2MoveFocusRequestedEventArgs Ptr, value As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_Handled )( ICoreWebView2MoveFocusRequestedEventArgs * This, BOOL value);
	put_Handled As Function stdcall (This As ICoreWebView2MoveFocusRequestedEventArgs Ptr, value As BOOL) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2MoveFocusRequestedEventArgs_
	lpVtbl As ICoreWebView2MoveFocusRequestedEventArgsVtbl Ptr
End Type

#define __ICoreWebView2MoveFocusRequestedEventHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2MoveFocusRequestedEventHandler;

Type ICoreWebView2MoveFocusRequestedEventHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2MoveFocusRequestedEventHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2MoveFocusRequestedEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2MoveFocusRequestedEventHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2MoveFocusRequestedEventHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2MoveFocusRequestedEventHandler * This);
	Release As Function stdcall (This As ICoreWebView2MoveFocusRequestedEventHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2MoveFocusRequestedEventHandler * This, ICoreWebView2Controller *sender, ICoreWebView2MoveFocusRequestedEventArgs *args);
	Invoke As Function stdcall (This As ICoreWebView2MoveFocusRequestedEventHandler Ptr, sender As ICoreWebView2Controller Ptr, args As ICoreWebView2MoveFocusRequestedEventArgs Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2MoveFocusRequestedEventHandler_
	lpVtbl As ICoreWebView2MoveFocusRequestedEventHandlerVtbl Ptr
End Type

#define __ICoreWebView2NavigationCompletedEventArgs_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2NavigationCompletedEventArgs;

Type ICoreWebView2NavigationCompletedEventArgs As ICoreWebView2NavigationCompletedEventArgs_
Type ICoreWebView2NavigationCompletedEventArgsVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2NavigationCompletedEventArgs * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2NavigationCompletedEventArgs Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2NavigationCompletedEventArgs * This);
	AddRef As Function stdcall (This As ICoreWebView2NavigationCompletedEventArgs Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2NavigationCompletedEventArgs * This);
	Release As Function stdcall (This As ICoreWebView2NavigationCompletedEventArgs Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_IsSuccess )( ICoreWebView2NavigationCompletedEventArgs * This, BOOL *isSuccess);
	get_IsSuccess As Function stdcall (This As ICoreWebView2NavigationCompletedEventArgs Ptr, isSuccess As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_WebErrorStatus )( ICoreWebView2NavigationCompletedEventArgs * This, COREWEBVIEW2_WEB_ERROR_STATUS *COREWEBVIEW2_WEB_ERROR_STATUS);
	get_WebErrorStatus As Function stdcall (This As ICoreWebView2NavigationCompletedEventArgs Ptr, COREWEBVIEW2_WEB_ERROR_STATUS As COREWEBVIEW2_WEB_ERROR_STATUS Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_NavigationId )( ICoreWebView2NavigationCompletedEventArgs * This, UINT64 *navigation_id);
	get_NavigationId As Function stdcall (This As ICoreWebView2NavigationCompletedEventArgs Ptr, navigation_id As UINT64 Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2NavigationCompletedEventArgs_
	lpVtbl As ICoreWebView2NavigationCompletedEventArgsVtbl Ptr
End Type

#define __ICoreWebView2NavigationCompletedEventHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2NavigationCompletedEventHandler;

Type ICoreWebView2NavigationCompletedEventHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2NavigationCompletedEventHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2NavigationCompletedEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2NavigationCompletedEventHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2NavigationCompletedEventHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2NavigationCompletedEventHandler * This);
	Release As Function stdcall (This As ICoreWebView2NavigationCompletedEventHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2NavigationCompletedEventHandler * This, ICoreWebView2 *sender, ICoreWebView2NavigationCompletedEventArgs *args);
	Invoke As Function stdcall (This As ICoreWebView2NavigationCompletedEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2NavigationCompletedEventArgs Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2NavigationCompletedEventHandler_
	lpVtbl As ICoreWebView2NavigationCompletedEventHandlerVtbl Ptr
End Type

#define __ICoreWebView2NavigationStartingEventArgs_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2NavigationStartingEventArgs;

Type ICoreWebView2NavigationStartingEventArgs As ICoreWebView2NavigationStartingEventArgs_
Type ICoreWebView2NavigationStartingEventArgsVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2NavigationStartingEventArgs * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2NavigationStartingEventArgs Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2NavigationStartingEventArgs * This);
	AddRef As Function stdcall (This As ICoreWebView2NavigationStartingEventArgs Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2NavigationStartingEventArgs * This);
	Release As Function stdcall (This As ICoreWebView2NavigationStartingEventArgs Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Uri )( ICoreWebView2NavigationStartingEventArgs * This, LPWSTR *uri);
	get_Uri As Function stdcall (This As ICoreWebView2NavigationStartingEventArgs Ptr, uri As LPWSTR Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_IsUserInitiated )( ICoreWebView2NavigationStartingEventArgs * This, BOOL *isUserInitiated);
	get_IsUserInitiated As Function stdcall (This As ICoreWebView2NavigationStartingEventArgs Ptr, isUserInitiated As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_IsRedirected )( ICoreWebView2NavigationStartingEventArgs * This, BOOL *isRedirected);
	get_IsRedirected As Function stdcall (This As ICoreWebView2NavigationStartingEventArgs Ptr, isRedirected As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_RequestHeaders )( ICoreWebView2NavigationStartingEventArgs * This, ICoreWebView2HttpRequestHeaders **requestHeaders);
	get_RequestHeaders As Function stdcall (This As ICoreWebView2NavigationStartingEventArgs Ptr, requestHeaders As ICoreWebView2HttpRequestHeaders Ptr Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Cancel )( ICoreWebView2NavigationStartingEventArgs * This, BOOL *cancel);
	get_Cancel As Function stdcall (This As ICoreWebView2NavigationStartingEventArgs Ptr, cancel As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_Cancel )( ICoreWebView2NavigationStartingEventArgs * This, BOOL cancel);
	put_Cancel As Function stdcall (This As ICoreWebView2NavigationStartingEventArgs Ptr, cancel As BOOL) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_NavigationId )( ICoreWebView2NavigationStartingEventArgs * This, UINT64 *navigation_id);
	get_NavigationId As Function stdcall (This As ICoreWebView2NavigationStartingEventArgs Ptr, navigation_id As UINT64 Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2NavigationStartingEventArgs_
	lpVtbl As ICoreWebView2NavigationStartingEventArgsVtbl Ptr
End Type

#define __ICoreWebView2NavigationStartingEventHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2NavigationStartingEventHandler;

Type ICoreWebView2NavigationStartingEventHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2NavigationStartingEventHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2NavigationStartingEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2NavigationStartingEventHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2NavigationStartingEventHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2NavigationStartingEventHandler * This);
	Release As Function stdcall (This As ICoreWebView2NavigationStartingEventHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2NavigationStartingEventHandler * This, ICoreWebView2 *sender, ICoreWebView2NavigationStartingEventArgs *args);
	Invoke As Function stdcall (This As ICoreWebView2NavigationStartingEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2NavigationStartingEventArgs Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2NavigationStartingEventHandler_
	lpVtbl As ICoreWebView2NavigationStartingEventHandlerVtbl Ptr
End Type

#define __ICoreWebView2NewBrowserVersionAvailableEventHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2NewBrowserVersionAvailableEventHandler;

Type ICoreWebView2NewBrowserVersionAvailableEventHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2NewBrowserVersionAvailableEventHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2NewBrowserVersionAvailableEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2NewBrowserVersionAvailableEventHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2NewBrowserVersionAvailableEventHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2NewBrowserVersionAvailableEventHandler * This);
	Release As Function stdcall (This As ICoreWebView2NewBrowserVersionAvailableEventHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2NewBrowserVersionAvailableEventHandler * This, ICoreWebView2Environment *webviewEnvironment, IUnknown *args);
	Invoke As Function stdcall (This As ICoreWebView2NewBrowserVersionAvailableEventHandler Ptr, webviewEnvironment As ICoreWebView2Environment Ptr, args As IUnknown Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2NewBrowserVersionAvailableEventHandler_
	lpVtbl As ICoreWebView2NewBrowserVersionAvailableEventHandlerVtbl Ptr
End Type

#define __ICoreWebView2NewWindowRequestedEventArgs_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2NewWindowRequestedEventArgs;

Type ICoreWebView2NewWindowRequestedEventArgs As ICoreWebView2NewWindowRequestedEventArgs_
Type ICoreWebView2NewWindowRequestedEventArgsVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2NewWindowRequestedEventArgs * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2NewWindowRequestedEventArgs Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2NewWindowRequestedEventArgs * This);
	AddRef As Function stdcall (This As ICoreWebView2NewWindowRequestedEventArgs Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2NewWindowRequestedEventArgs * This);
	Release As Function stdcall (This As ICoreWebView2NewWindowRequestedEventArgs Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Uri )( ICoreWebView2NewWindowRequestedEventArgs * This, LPWSTR *uri);
	get_Uri As Function stdcall (This As ICoreWebView2NewWindowRequestedEventArgs Ptr, uri As LPWSTR Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_NewWindow )( ICoreWebView2NewWindowRequestedEventArgs * This, ICoreWebView2 *newWindow);
	put_NewWindow As Function stdcall (This As ICoreWebView2NewWindowRequestedEventArgs Ptr, newWindow As ICoreWebView2 Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_NewWindow )( ICoreWebView2NewWindowRequestedEventArgs * This, ICoreWebView2 **newWindow);
	get_NewWindow As Function stdcall (This As ICoreWebView2NewWindowRequestedEventArgs Ptr, newWindow As ICoreWebView2 Ptr Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_Handled )( ICoreWebView2NewWindowRequestedEventArgs * This, BOOL handled);
	put_Handled As Function stdcall (This As ICoreWebView2NewWindowRequestedEventArgs Ptr, handled As BOOL) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Handled )( ICoreWebView2NewWindowRequestedEventArgs * This, BOOL *handled);
	get_Handled As Function stdcall (This As ICoreWebView2NewWindowRequestedEventArgs Ptr, handled As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_IsUserInitiated )( ICoreWebView2NewWindowRequestedEventArgs * This, BOOL *isUserInitiated);
	get_IsUserInitiated As Function stdcall (This As ICoreWebView2NewWindowRequestedEventArgs Ptr, isUserInitiated As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *GetDeferral )( ICoreWebView2NewWindowRequestedEventArgs * This, ICoreWebView2Deferral **deferral);
	GetDeferral As Function stdcall (This As ICoreWebView2NewWindowRequestedEventArgs Ptr, deferral As ICoreWebView2Deferral Ptr Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2NewWindowRequestedEventArgs_
	lpVtbl As ICoreWebView2NewWindowRequestedEventArgsVtbl Ptr
End Type

#define __ICoreWebView2NewWindowRequestedEventHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2NewWindowRequestedEventHandler;

Type ICoreWebView2NewWindowRequestedEventHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2NewWindowRequestedEventHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2NewWindowRequestedEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2NewWindowRequestedEventHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2NewWindowRequestedEventHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2NewWindowRequestedEventHandler * This);
	Release As Function stdcall (This As ICoreWebView2NewWindowRequestedEventHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2NewWindowRequestedEventHandler * This, ICoreWebView2 *sender, ICoreWebView2NewWindowRequestedEventArgs *args);
	Invoke As Function stdcall (This As ICoreWebView2NewWindowRequestedEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2NewWindowRequestedEventArgs Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2NewWindowRequestedEventHandler_
	lpVtbl As ICoreWebView2NewWindowRequestedEventHandlerVtbl Ptr
End Type

#define __ICoreWebView2PermissionRequestedEventArgs_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2PermissionRequestedEventArgs;

Type ICoreWebView2PermissionRequestedEventArgs As ICoreWebView2PermissionRequestedEventArgs_
Type ICoreWebView2PermissionRequestedEventArgsVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2PermissionRequestedEventArgs * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2PermissionRequestedEventArgs Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2PermissionRequestedEventArgs * This);
	AddRef As Function stdcall (This As ICoreWebView2PermissionRequestedEventArgs Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2PermissionRequestedEventArgs * This);
	Release As Function stdcall (This As ICoreWebView2PermissionRequestedEventArgs Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Uri )( ICoreWebView2PermissionRequestedEventArgs * This, LPWSTR *uri);
	get_Uri As Function stdcall (This As ICoreWebView2PermissionRequestedEventArgs Ptr, uri As LPWSTR Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_PermissionKind )( ICoreWebView2PermissionRequestedEventArgs * This, COREWEBVIEW2_PERMISSION_KIND *value);
	get_PermissionKind As Function stdcall (This As ICoreWebView2PermissionRequestedEventArgs Ptr, value As COREWEBVIEW2_PERMISSION_KIND Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_IsUserInitiated )( ICoreWebView2PermissionRequestedEventArgs * This, BOOL *isUserInitiated);
	get_IsUserInitiated As Function stdcall (This As ICoreWebView2PermissionRequestedEventArgs Ptr, isUserInitiated As BOOL  Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_State )( ICoreWebView2PermissionRequestedEventArgs * This, COREWEBVIEW2_PERMISSION_STATE *value);
	get_State As Function stdcall (This As ICoreWebView2PermissionRequestedEventArgs Ptr, value As COREWEBVIEW2_PERMISSION_STATE Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_State )( ICoreWebView2PermissionRequestedEventArgs * This, COREWEBVIEW2_PERMISSION_STATE value);
	put_State As Function stdcall (This As ICoreWebView2PermissionRequestedEventArgs Ptr, value As COREWEBVIEW2_PERMISSION_STATE) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *GetDeferral )( ICoreWebView2PermissionRequestedEventArgs * This, ICoreWebView2Deferral **deferral);
	GetDeferral As Function stdcall (This As ICoreWebView2PermissionRequestedEventArgs Ptr, deferral As ICoreWebView2Deferral Ptr Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2PermissionRequestedEventArgs_
	lpVtbl As ICoreWebView2PermissionRequestedEventArgsVtbl Ptr
End Type

#define __ICoreWebView2PermissionRequestedEventHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2PermissionRequestedEventHandler;

Type ICoreWebView2PermissionRequestedEventHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2PermissionRequestedEventHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2PermissionRequestedEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2PermissionRequestedEventHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2PermissionRequestedEventHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2PermissionRequestedEventHandler * This);
	Release As Function stdcall (This As ICoreWebView2PermissionRequestedEventHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2PermissionRequestedEventHandler * This, ICoreWebView2 *sender, ICoreWebView2PermissionRequestedEventArgs *args);
	Invoke As Function stdcall (This As ICoreWebView2PermissionRequestedEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2PermissionRequestedEventArgs Ptr) As CULONG
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2PermissionRequestedEventHandler_
	lpVtbl As ICoreWebView2PermissionRequestedEventHandlerVtbl Ptr
End Type

#define __ICoreWebView2ProcessFailedEventArgs_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2ProcessFailedEventArgs;

Type ICoreWebView2ProcessFailedEventArgs As ICoreWebView2ProcessFailedEventArgs_
Type ICoreWebView2ProcessFailedEventArgsVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2ProcessFailedEventArgs * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2ProcessFailedEventArgs Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2ProcessFailedEventArgs * This);
	AddRef As Function stdcall (This As ICoreWebView2ProcessFailedEventArgs Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2ProcessFailedEventArgs * This);
	Release As Function stdcall (This As ICoreWebView2ProcessFailedEventArgs Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_ProcessFailedKind )( ICoreWebView2ProcessFailedEventArgs * This, COREWEBVIEW2_PROCESS_FAILED_KIND *processFailedKind);
	get_ProcessFailedKind As Function stdcall (This As ICoreWebView2ProcessFailedEventArgs Ptr, processFailedKind As COREWEBVIEW2_PROCESS_FAILED_KIND Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2ProcessFailedEventArgs_
	lpVtbl As ICoreWebView2ProcessFailedEventArgsVtbl Ptr
End Type

#define __ICoreWebView2ProcessFailedEventHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2ProcessFailedEventHandler;

Type ICoreWebView2ProcessFailedEventHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2ProcessFailedEventHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2ProcessFailedEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2ProcessFailedEventHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2ProcessFailedEventHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2ProcessFailedEventHandler * This);
	Release As Function stdcall (This As ICoreWebView2ProcessFailedEventHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2ProcessFailedEventHandler * This, ICoreWebView2 *sender, ICoreWebView2ProcessFailedEventArgs *args);
	Invoke As Function stdcall (This As ICoreWebView2ProcessFailedEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2ProcessFailedEventArgs Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2ProcessFailedEventHandler_
	lpVtbl As ICoreWebView2ProcessFailedEventHandlerVtbl Ptr
End Type

#define __ICoreWebView2ScriptDialogOpeningEventArgs_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2ScriptDialogOpeningEventArgs;

Type ICoreWebView2ScriptDialogOpeningEventArgs As ICoreWebView2ScriptDialogOpeningEventArgs_
Type ICoreWebView2ScriptDialogOpeningEventArgsVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2ScriptDialogOpeningEventArgs * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2ScriptDialogOpeningEventArgs Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2ScriptDialogOpeningEventArgs * This);
	AddRef As Function stdcall (This As ICoreWebView2ScriptDialogOpeningEventArgs Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2ScriptDialogOpeningEventArgs * This);
	Release As Function stdcall (This As ICoreWebView2ScriptDialogOpeningEventArgs Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Uri )( ICoreWebView2ScriptDialogOpeningEventArgs * This, LPWSTR *uri);
	get_Uri As Function stdcall (This As ICoreWebView2ScriptDialogOpeningEventArgs Ptr, uri As LPWSTR Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Kind )( ICoreWebView2ScriptDialogOpeningEventArgs * This, COREWEBVIEW2_SCRIPT_DIALOG_KIND *kind);
	get_Kind As Function stdcall (This As ICoreWebView2ScriptDialogOpeningEventArgs Ptr, kind As COREWEBVIEW2_SCRIPT_DIALOG_KIND Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Message )( ICoreWebView2ScriptDialogOpeningEventArgs * This, LPWSTR *message);
	get_Message As Function stdcall (This As ICoreWebView2ScriptDialogOpeningEventArgs Ptr, message As LPWSTR Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Accept )( ICoreWebView2ScriptDialogOpeningEventArgs * This);
	Accept As Function stdcall (This As ICoreWebView2ScriptDialogOpeningEventArgs Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_DefaultText )( ICoreWebView2ScriptDialogOpeningEventArgs * This, LPWSTR *defaultText);
	get_DefaultText As Function stdcall (This As ICoreWebView2ScriptDialogOpeningEventArgs Ptr, defaultText As LPWSTR Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_ResultText )( ICoreWebView2ScriptDialogOpeningEventArgs * This, LPWSTR *resultText);
	get_ResultText As Function stdcall (This As ICoreWebView2ScriptDialogOpeningEventArgs Ptr, resultText As LPWSTR Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_ResultText )( ICoreWebView2ScriptDialogOpeningEventArgs * This, LPCWSTR resultText);
	put_ResultText As Function stdcall (This As ICoreWebView2ScriptDialogOpeningEventArgs Ptr, resultText As LPWSTR) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *GetDeferral )( ICoreWebView2ScriptDialogOpeningEventArgs * This, ICoreWebView2Deferral **deferral);
	GetDeferral As Function stdcall (This As ICoreWebView2ScriptDialogOpeningEventArgs Ptr, deferral As ICoreWebView2Deferral Ptr Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2ScriptDialogOpeningEventArgs_
	lpVtbl As ICoreWebView2ScriptDialogOpeningEventArgsVtbl Ptr
End Type

#define __ICoreWebView2ScriptDialogOpeningEventHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2ScriptDialogOpeningEventHandler;

Type ICoreWebView2ScriptDialogOpeningEventHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2ScriptDialogOpeningEventHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2ScriptDialogOpeningEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2ScriptDialogOpeningEventHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2ScriptDialogOpeningEventHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2ScriptDialogOpeningEventHandler * This);
	Release As Function stdcall (This As ICoreWebView2ScriptDialogOpeningEventHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2ScriptDialogOpeningEventHandler * This, ICoreWebView2 *sender, ICoreWebView2ScriptDialogOpeningEventArgs *args);
	Invoke As Function stdcall (This As ICoreWebView2ScriptDialogOpeningEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2ScriptDialogOpeningEventArgs Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2ScriptDialogOpeningEventHandler_
	lpVtbl As ICoreWebView2ScriptDialogOpeningEventHandlerVtbl Ptr
End Type

#define __ICoreWebView2Settings_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2Settings;

Type ICoreWebView2SettingsVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2Settings * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2Settings Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2Settings * This);
	AddRef As Function stdcall (This As ICoreWebView2Settings Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2Settings * This);
	Release As Function stdcall (This As ICoreWebView2Settings Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_IsScriptEnabled )( ICoreWebView2Settings * This, BOOL *isScriptEnabled);
	get_IsScriptEnabled As Function stdcall (This As ICoreWebView2Settings Ptr, isScriptEnabled As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_IsScriptEnabled )( ICoreWebView2Settings * This, BOOL isScriptEnabled);
	put_IsScriptEnabled As Function stdcall (This As ICoreWebView2Settings Ptr, isScriptEnabled As BOOL) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_IsWebMessageEnabled )( ICoreWebView2Settings * This, BOOL *isWebMessageEnabled);
	get_IsWebMessageEnabled As Function stdcall (This As ICoreWebView2Settings Ptr, isWebMessageEnabled As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_IsWebMessageEnabled )( ICoreWebView2Settings * This, BOOL isWebMessageEnabled);
	put_IsWebMessageEnabled As Function stdcall (This As ICoreWebView2Settings Ptr, isWebMessageEnabled As BOOL) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_AreDefaultScriptDialogsEnabled )( ICoreWebView2Settings * This, BOOL *areDefaultScriptDialogsEnabled);
	get_AreDefaultScriptDialogsEnabled As Function stdcall (This As ICoreWebView2Settings Ptr, areDefaultScriptDialogsEnabled As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_AreDefaultScriptDialogsEnabled )( ICoreWebView2Settings * This, BOOL areDefaultScriptDialogsEnabled);
	put_AreDefaultScriptDialogsEnabled As Function stdcall (This As ICoreWebView2Settings Ptr, areDefaultScriptDialogsEnabled As BOOL) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_IsStatusBarEnabled )( ICoreWebView2Settings * This, BOOL *isStatusBarEnabled);
	get_IsStatusBarEnabled As Function stdcall (This As ICoreWebView2Settings Ptr, isStatusBarEnabled As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_IsStatusBarEnabled )( ICoreWebView2Settings * This, BOOL isStatusBarEnabled);
	put_IsStatusBarEnabled As Function stdcall (This As ICoreWebView2Settings Ptr, isStatusBarEnabled As BOOL) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_AreDevToolsEnabled )( ICoreWebView2Settings * This, BOOL *areDevToolsEnabled);
	get_AreDevToolsEnabled As Function stdcall (This As ICoreWebView2Settings Ptr, areDevToolsEnabled As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_AreDevToolsEnabled )( ICoreWebView2Settings * This, BOOL areDevToolsEnabled);
	put_AreDevToolsEnabled As Function stdcall (This As ICoreWebView2Settings Ptr, areDevToolsEnabled As BOOL) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_AreDefaultContextMenusEnabled )( ICoreWebView2Settings * This, BOOL *enabled);
	get_AreDefaultContextMenusEnabled As Function stdcall (This As ICoreWebView2Settings Ptr, enabled As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_AreDefaultContextMenusEnabled )( ICoreWebView2Settings * This, BOOL enabled);
	put_AreDefaultContextMenusEnabled As Function stdcall (This As ICoreWebView2Settings Ptr, enabled As BOOL) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_AreHostObjectsAllowed )( ICoreWebView2Settings * This, BOOL *allowed);
	get_AreHostObjectsAllowed As Function stdcall (This As ICoreWebView2Settings Ptr, allowed As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_AreHostObjectsAllowed )( ICoreWebView2Settings * This, BOOL allowed);
	put_AreHostObjectsAllowed As Function stdcall (This As ICoreWebView2Settings Ptr, allowed As BOOL) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_IsZoomControlEnabled )( ICoreWebView2Settings * This, BOOL *enabled);
	get_IsZoomControlEnabled As Function stdcall (This As ICoreWebView2Settings Ptr, enabled As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_IsZoomControlEnabled )( ICoreWebView2Settings * This, BOOL enabled);
	put_IsZoomControlEnabled As Function stdcall (This As ICoreWebView2Settings Ptr, enabled As BOOL) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_IsBuiltInErrorPageEnabled )( ICoreWebView2Settings * This, BOOL *enabled);
	get_IsBuiltInErrorPageEnabled As Function stdcall (This As ICoreWebView2Settings Ptr, enabled As BOOL Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_IsBuiltInErrorPageEnabled )( ICoreWebView2Settings * This, BOOL enabled);
	put_IsBuiltInErrorPageEnabled As Function stdcall (This As ICoreWebView2Settings Ptr, enabled As BOOL) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2Settings_
	lpVtbl As ICoreWebView2SettingsVtbl Ptr
End Type

#define __ICoreWebView2SourceChangedEventArgs_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2SourceChangedEventArgs;

Type ICoreWebView2SourceChangedEventArgs As ICoreWebView2SourceChangedEventArgs_
Type ICoreWebView2SourceChangedEventArgsVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2SourceChangedEventArgs * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2SourceChangedEventArgs Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2SourceChangedEventArgs * This);
	AddRef As Function stdcall (This As ICoreWebView2SourceChangedEventArgs Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2SourceChangedEventArgs * This);
	Release As Function stdcall (This As ICoreWebView2SourceChangedEventArgs Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_IsNewDocument )( ICoreWebView2SourceChangedEventArgs * This, BOOL *isNewDocument);
	get_IsNewDocument As Function stdcall (This As ICoreWebView2SourceChangedEventArgs Ptr, isNewDocument As BOOL Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2SourceChangedEventArgs_
	lpVtbl As ICoreWebView2SourceChangedEventArgsVtbl Ptr
End Type

#define __ICoreWebView2SourceChangedEventHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2SourceChangedEventHandler;

Type ICoreWebView2SourceChangedEventHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2SourceChangedEventHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2SourceChangedEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2SourceChangedEventHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2SourceChangedEventHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2SourceChangedEventHandler * This);
	Release As Function stdcall (This As ICoreWebView2SourceChangedEventHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2SourceChangedEventHandler * This, ICoreWebView2 *webview, ICoreWebView2SourceChangedEventArgs *args);
	Invoke As Function stdcall (This As ICoreWebView2SourceChangedEventHandler Ptr, webview As ICoreWebView2 Ptr, args As ICoreWebView2SourceChangedEventArgs Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2SourceChangedEventHandler_
	lpVtbl As ICoreWebView2SourceChangedEventHandlerVtbl Ptr
End Type

#define __ICoreWebView2WebMessageReceivedEventArgs_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2WebMessageReceivedEventArgs;

Type ICoreWebView2WebMessageReceivedEventArgs As ICoreWebView2WebMessageReceivedEventArgs_
Type ICoreWebView2WebMessageReceivedEventArgsVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2WebMessageReceivedEventArgs * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2WebMessageReceivedEventArgs Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2WebMessageReceivedEventArgs * This);
	AddRef As Function stdcall (This As ICoreWebView2WebMessageReceivedEventArgs Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2WebMessageReceivedEventArgs * This);
	Release As Function stdcall (This As ICoreWebView2WebMessageReceivedEventArgs Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Source )( ICoreWebView2WebMessageReceivedEventArgs * This, LPWSTR *source);
	get_Source As Function stdcall (This As ICoreWebView2WebMessageReceivedEventArgs Ptr, source As LPWSTR Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_WebMessageAsJson )( ICoreWebView2WebMessageReceivedEventArgs * This, LPWSTR *webMessageAsJson);
	get_WebMessageAsJson As Function stdcall (This As ICoreWebView2WebMessageReceivedEventArgs Ptr, webMessageAsJson As LPWSTR Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *TryGetWebMessageAsString )( ICoreWebView2WebMessageReceivedEventArgs * This, LPWSTR *webMessageAsString);
	TryGetWebMessageAsString As Function stdcall (This As ICoreWebView2WebMessageReceivedEventArgs Ptr, webMessageAsString As LPWSTR Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2WebMessageReceivedEventArgs_
	lpVtbl As ICoreWebView2WebMessageReceivedEventArgsVtbl Ptr
End Type

#define __ICoreWebView2WebMessageReceivedEventHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2WebMessageReceivedEventHandler;

Type ICoreWebView2WebMessageReceivedEventHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2WebMessageReceivedEventHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2WebMessageReceivedEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2WebMessageReceivedEventHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2WebMessageReceivedEventHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2WebMessageReceivedEventHandler * This);
	Release As Function stdcall (This As ICoreWebView2WebMessageReceivedEventHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2WebMessageReceivedEventHandler * This, ICoreWebView2 *sender, ICoreWebView2WebMessageReceivedEventArgs *args);
	Invoke As Function stdcall (This As ICoreWebView2WebMessageReceivedEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2WebMessageReceivedEventArgs Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2WebMessageReceivedEventHandler_
	lpVtbl As ICoreWebView2WebMessageReceivedEventHandlerVtbl Ptr
End Type

#define __ICoreWebView2WebResourceRequest_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2WebResourceRequest;

Type ICoreWebView2WebResourceRequest As ICoreWebView2WebResourceRequest_
Type ICoreWebView2WebResourceRequestVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2WebResourceRequest * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2WebResourceRequest Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2WebResourceRequest * This);
	AddRef As Function stdcall (This As ICoreWebView2WebResourceRequest Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2WebResourceRequest * This);
	Release As Function stdcall (This As ICoreWebView2WebResourceRequest Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Uri )( ICoreWebView2WebResourceRequest * This, LPWSTR *uri);
	get_Uri As Function stdcall (This As ICoreWebView2WebResourceRequest Ptr, uri As LPWSTR Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_Uri )( ICoreWebView2WebResourceRequest * This, LPCWSTR uri);
	put_Uri As Function stdcall (This As ICoreWebView2WebResourceRequest Ptr, uri As LPWSTR) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Method )( ICoreWebView2WebResourceRequest * This, LPWSTR *method);
	get_Method As Function stdcall (This As ICoreWebView2WebResourceRequest Ptr, method As LPWSTR Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_Method )( ICoreWebView2WebResourceRequest * This, LPCWSTR method);
	put_Method As Function stdcall (This As ICoreWebView2WebResourceRequest Ptr, method As LPWSTR) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Content )( ICoreWebView2WebResourceRequest * This, IStream **content);
	get_Content As Function stdcall (This As ICoreWebView2WebResourceRequest Ptr, content As IStream Ptr Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_Content )( ICoreWebView2WebResourceRequest * This, IStream *content);
	put_Content As Function stdcall (This As ICoreWebView2WebResourceRequest Ptr, content As IStream Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Headers )( ICoreWebView2WebResourceRequest * This, ICoreWebView2HttpRequestHeaders **headers);
	get_Headers As Function stdcall (This As ICoreWebView2WebResourceRequest Ptr, headers As ICoreWebView2HttpRequestHeaders Ptr Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2WebResourceRequest_
	lpVtbl As ICoreWebView2WebResourceRequestVtbl Ptr
End Type

#define __ICoreWebView2WebResourceRequestedEventArgs_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2WebResourceRequestedEventArgs;

Type ICoreWebView2WebResourceRequestedEventArgs As ICoreWebView2WebResourceRequestedEventArgs_
Type ICoreWebView2WebResourceRequestedEventArgsVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2WebResourceRequestedEventArgs * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2WebResourceRequestedEventArgs Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2WebResourceRequestedEventArgs * This);
	AddRef As Function stdcall (This As ICoreWebView2WebResourceRequestedEventArgs Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2WebResourceRequestedEventArgs * This);
	Release As Function stdcall (This As ICoreWebView2WebResourceRequestedEventArgs Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Request )( ICoreWebView2WebResourceRequestedEventArgs * This, ICoreWebView2WebResourceRequest **request);
	get_Request As Function stdcall (This As ICoreWebView2WebResourceRequestedEventArgs Ptr, request As ICoreWebView2WebResourceRequest Ptr Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Response )( ICoreWebView2WebResourceRequestedEventArgs * This, ICoreWebView2WebResourceResponse **response);
	get_Response As Function stdcall (This As ICoreWebView2WebResourceRequestedEventArgs Ptr, response As ICoreWebView2WebResourceResponse Ptr Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_Response )( ICoreWebView2WebResourceRequestedEventArgs * This, ICoreWebView2WebResourceResponse *response);
	put_Response As Function stdcall (This As ICoreWebView2WebResourceRequestedEventArgs Ptr, response As ICoreWebView2WebResourceResponse Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *GetDeferral )( ICoreWebView2WebResourceRequestedEventArgs * This, ICoreWebView2Deferral **deferral);
	GetDeferral As Function stdcall (This As ICoreWebView2WebResourceRequestedEventArgs Ptr, deferral As ICoreWebView2Deferral Ptr Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_ResourceContext )( ICoreWebView2WebResourceRequestedEventArgs * This, COREWEBVIEW2_WEB_RESOURCE_CONTEXT *context);
	get_ResourceContext As Function stdcall (This As ICoreWebView2WebResourceRequestedEventArgs Ptr, context As COREWEBVIEW2_WEB_RESOURCE_CONTEXT Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2WebResourceRequestedEventArgs_
	lpVtbl As ICoreWebView2WebResourceRequestedEventArgsVtbl Ptr
End Type

#define __ICoreWebView2WebResourceRequestedEventHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2WebResourceRequestedEventHandler;

Type ICoreWebView2WebResourceRequestedEventHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2WebResourceRequestedEventHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2WebResourceRequestedEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2WebResourceRequestedEventHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2WebResourceRequestedEventHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2WebResourceRequestedEventHandler * This);
	Release As Function stdcall (This As ICoreWebView2WebResourceRequestedEventHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2WebResourceRequestedEventHandler * This, ICoreWebView2 *sender, ICoreWebView2WebResourceRequestedEventArgs *args);
	Invoke As Function stdcall (This As ICoreWebView2WebResourceRequestedEventHandler Ptr, sender As ICoreWebView2 Ptr, args As ICoreWebView2WebResourceRequestedEventArgs Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2WebResourceRequestedEventHandler_
	lpVtbl As ICoreWebView2WebResourceRequestedEventHandlerVtbl Ptr
End Type

#define __ICoreWebView2WebResourceResponse_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2WebResourceResponse;

Type ICoreWebView2WebResourceResponseVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2WebResourceResponse * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2WebResourceResponse Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2WebResourceResponse * This);
	AddRef As Function stdcall (This As ICoreWebView2WebResourceResponse Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2WebResourceResponse * This);
	Release As Function stdcall (This As ICoreWebView2WebResourceResponse Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Content )( ICoreWebView2WebResourceResponse * This, IStream **content);
	get_Content As Function stdcall (This As ICoreWebView2WebResourceResponse Ptr, content As IStream Ptr Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_Content )( ICoreWebView2WebResourceResponse * This, IStream *content);
	put_Content As Function stdcall (This As ICoreWebView2WebResourceResponse Ptr, content As IStream Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_Headers )( ICoreWebView2WebResourceResponse * This, ICoreWebView2HttpResponseHeaders **headers);
	get_Headers As Function stdcall (This As ICoreWebView2WebResourceResponse Ptr, headers As ICoreWebView2HttpResponseHeaders Ptr Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_StatusCode )( ICoreWebView2WebResourceResponse * This, int *statusCode);
	get_StatusCode As Function stdcall (This As ICoreWebView2WebResourceResponse Ptr, statusCode As Integer Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_StatusCode )( ICoreWebView2WebResourceResponse * This, int statusCode);
	put_StatusCode As Function stdcall (This As ICoreWebView2WebResourceResponse Ptr, statusCode As Integer) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *get_ReasonPhrase )( ICoreWebView2WebResourceResponse * This, LPWSTR *reasonPhrase);
	get_ReasonPhrase As Function stdcall (This As ICoreWebView2WebResourceResponse Ptr, reasonPhrase As LPWSTR Ptr) As HRESULT
	'' TODO: HRESULT ( STDMETHODCALLTYPE *put_ReasonPhrase )( ICoreWebView2WebResourceResponse * This, LPCWSTR reasonPhrase);
	put_ReasonPhrase As Function stdcall (This As ICoreWebView2WebResourceResponse Ptr, reasonPhrase As LPWSTR) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2WebResourceResponse_
	lpVtbl As ICoreWebView2WebResourceResponseVtbl Ptr
End Type

#define __ICoreWebView2WindowCloseRequestedEventHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2WindowCloseRequestedEventHandler;

Type ICoreWebView2WindowCloseRequestedEventHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2WindowCloseRequestedEventHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2WindowCloseRequestedEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2WindowCloseRequestedEventHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2WindowCloseRequestedEventHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2WindowCloseRequestedEventHandler * This);
	Release As Function stdcall (This As ICoreWebView2WindowCloseRequestedEventHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2WindowCloseRequestedEventHandler * This, ICoreWebView2 *sender, IUnknown *args);
	Invoke As Function stdcall (This As ICoreWebView2WindowCloseRequestedEventHandler Ptr, sender As ICoreWebView2 Ptr, args As IUnknown Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2WindowCloseRequestedEventHandler_
	lpVtbl As ICoreWebView2WindowCloseRequestedEventHandlerVtbl Ptr
End Type

#define __ICoreWebView2ZoomFactorChangedEventHandler_INTERFACE_DEFINED__
'' TODO: EXTERN_C const IID IID_ICoreWebView2ZoomFactorChangedEventHandler;

Type ICoreWebView2ZoomFactorChangedEventHandlerVtbl
	'' TODO: BEGIN_INTERFACE HRESULT ( STDMETHODCALLTYPE *QueryInterface )( ICoreWebView2ZoomFactorChangedEventHandler * This, REFIID riid, _COM_Outptr_ void **ppvObject);
	QueryInterface As Function stdcall (This As ICoreWebView2ZoomFactorChangedEventHandler Ptr, riid As REFIID, ppvObject As PVOID Ptr) As HRESULT
	'' TODO: ULONG ( STDMETHODCALLTYPE *AddRef )( ICoreWebView2ZoomFactorChangedEventHandler * This);
	AddRef As Function stdcall (This As ICoreWebView2ZoomFactorChangedEventHandler Ptr) As CULONG
	'' TODO: ULONG ( STDMETHODCALLTYPE *Release )( ICoreWebView2ZoomFactorChangedEventHandler * This);
	Release As Function stdcall (This As ICoreWebView2ZoomFactorChangedEventHandler Ptr) As CULONG
	'' TODO: HRESULT ( STDMETHODCALLTYPE *Invoke )( ICoreWebView2ZoomFactorChangedEventHandler * This, ICoreWebView2Controller *sender, IUnknown *args);
	Invoke As Function stdcall (This As ICoreWebView2ZoomFactorChangedEventHandler Ptr, sender As ICoreWebView2Controller Ptr, args As IUnknown Ptr) As HRESULT
	'' TODO: END_INTERFACE
End Type

Type ICoreWebView2ZoomFactorChangedEventHandler_
	lpVtbl As ICoreWebView2ZoomFactorChangedEventHandlerVtbl Ptr
End Type

End Extern

