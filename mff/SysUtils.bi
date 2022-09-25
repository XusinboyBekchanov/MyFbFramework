'################################################################################
'#  SysUtils.bi                                                                 #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                      #
'#  Based on:                                                                   #
'#   SysUtils.bi                                                                #
'#   FreeBasic Windows GUI ToolKit                                              #
'#   Copyright (c) 2007-2008 Nastase Eodor                                      #
'#  Modified by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                       #
'################################################################################

#ifdef __FB_ANDROID__
	#ifndef __USE_JNI__
		#define __USE_JNI__
	#endif
#elseif Not defined(__FB_WIN32__)
	#ifndef __USE_GTK__
		#define __USE_GTK__
	#endif
#elseif Not defined(__USE_GTK__)
	#ifndef __USE_WINAPI__
		#define __USE_WINAPI__
	#endif
#endif

#ifdef __USE_WINAPI__
	#define UNICODE
	#include once "Windows.bi"
#endif

#ifdef __USE_GTK__
	#define FHandle Widget
	#if defined(__USE_GTK3__) Or defined(__USE_GTK4__)
	#elseif Not defined(__USE_GTK2__)
		#define __USE_GTK2__
	#endif
#elseif defined(__USE_JNI__)
	#include once "jni.bi"
	#define Max(a, b) IIf((a) > (b), (a), (b))
	#define Min(a, b) IIf((a) < (b), (a), (b))
#else
	#include once "win/wincrypt.bi"
	#include once "Win/CommCtrl.bi"
	#include once "Win/CommDlg.bi"
	#include once "Win/RichEdit.bi"
	#include once "win/iphlpapi.bi"
	#define Instance GetModuleHandle(NULL)
#endif
#include once "UString.bi"

#ifdef __EXPORT_PROCS__
	#define PublicOrPrivate Public
	#define __EXPORT__ Export
#else
	#define PublicOrPrivate Private
	#define __EXPORT__
#endif

'#define In ,
'#macro Each(iter, arr)
'	index As Integer = LBound(arr) To UBound(arr)
'	#define iter arr(index)
'#endmacro

#define Each(iter, col) __index__ As Integer = 0 To col.Count - 1: Dim As Typeof(col.Item(__index__)) iter = col.Item(__index__)

#define Me This

#ifndef _L
	#ifdef __USE_GTK__
		#define _L Print __LINE__, __FILE__, __FUNCTION__:
	#else
		#define _L Print __LINE__, __FILE__, __FUNCTION__, GetErrorString(GetLastError, , True):
	#endif
#endif

Const HELP_SETPOPUP_POS = &Hd

'#DEFINE __AUTOMATE_CREATE_CHILDS__

#ifdef __USE_WINAPI__
	#define CM_NOTIFYCHILD 39998
	#define CM_CHANGEIMAGE 39999
	#define CM_CTLCOLOR    40000
	#define CM_COMMAND     40001
	#define CM_NOTIFY      40002
	#define CM_HSCROLL     40003
	#define CM_VSCROLL     40004
	#define CM_MEASUREITEM 40005
	#define CM_DRAWITEM    40006
	#define CM_HELPCONTEXT 40007
	#define CM_CANCELMODE  40008
	#define CM_HELP        40010
	#define CM_NEEDTEXT    40011
	#define CM_CREATE      40012
	
	'Dim Shared As Message Message
	
	Declare Function EnumThreadWindowsProc(FWindow As HWND,LData As LParam) As Bool
	
	Declare Function MainHandle As HWND
#elseif defined(__USE_JNI__)
	Dim Shared env          As JNIEnv Ptr
	Dim Shared xdpi         As Double
	Dim Shared ydpi         As Double
#endif

#ifdef __USE_JNI__
	Declare Function ScaleX(ByVal cx As Single) As Integer
	Declare Function ScaleY(ByVal cy As Single) As Integer
	Declare Function UnScaleX(ByVal cx As Single) As Integer
	Declare Function UnScaleY(ByVal cy As Single) As Integer
#else
	Declare Function ScaleX(ByVal cx As Single) As Single
	Declare Function ScaleY(ByVal cy As Single) As Single
	Declare Function UnScaleX(ByVal cx As Single) As Single
	Declare Function UnScaleY(ByVal cy As Single) As Single
#endif

Declare Function iGet(Value As Any Ptr) As Integer
Declare Function ZGet(ByRef subject As ZString Ptr) As String

Namespace ClassContainer
	Private Type ClassType
	Protected:
		FClassName As WString Ptr
		FClassAncestor As WString Ptr
	Public:
		ClassProc As Any Ptr
		Declare Property ClassName ByRef As WString
		Declare Property ClassName(ByRef Value As WString)
		Declare Property ClassAncestor ByRef As WString
		Declare Property ClassAncestor(ByRef Value As WString)
		Declare Constructor
		Declare Destructor
	End Type
	
	Dim Classes()  As ClassType
	
	Declare Function FindClass(ByRef ClassName As WString) As Integer
	
	Declare Sub StoreClass(ByRef ClassName As WString, ByRef ClassAncestor As WString, ClassProc As Any Ptr)
	
	Declare Function GetClassProc Overload(ByRef ClassName As WString) As Any Ptr
	
	#ifdef __USE_WINAPI__
		Declare Function GetClassProc(FWindow As HWND) As Any Ptr
		
		Declare Function GetClassNameOf(FWindow As HWND) As String
		
		Declare Sub Finalization
	#endif
End Namespace

Using ClassContainer

#ifdef GetMN
	Declare Function GetMessageName(Message As Integer) As String
#endif

Declare Function ErrDescription(Code As Integer) ByRef As WString

Declare Function _Abs(Value As Boolean) As Integer

Declare Function InStrCount(ByRef subject As WString, ByRef searchtext As WString, start As Integer = 1, MatchCase As Boolean = True) As Long
'Declare Function Replace Overload(ByRef wszMainStr As WString, ByRef wszMatchStr As Const WString, ByRef wszReplaceWith As Const WString, ByVal Start As Integer = 1, ByRef Count As Integer = 0, MatchCase As Boolean = True) As String
'Declare Function Replace Overload(ByRef wszMainStr As WString, MatchedStr() As WString Ptr, ReplaceWith() As WString Ptr, ByVal Start As Integer = 1, ByRef Count As Integer = 0, MatchCase As Boolean = True) As String
Declare Sub Split Overload(ByRef wszMainStr As WString, ByRef Delimiter As Const WString, Result() As UString, MatchCase As Boolean = True)
Declare Sub Split Overload(ByRef wszMainStr As WString, ByRef Delimiter As Const WString, Result() As WString Ptr, MatchCase As Boolean = True)
Declare Function Join Overload(Subject() As UString, ByRef Delimiter As Const WString, iStart As Integer = 0, iStep As Integer = 1) As UString
Declare Function Join Overload(Subject() As WString Ptr, ByRef Delimiter As Const WString, iStart As Integer = 0, iStep As Integer = 1) As String
Declare Function StartsWith(ByRef a As Const WString, ByRef b As Const WString) As Boolean
Declare Function EndsWith(ByRef a As Const WString, ByRef b As Const WString) As Boolean
Declare Function StringExtract Overload(ByRef wszMainStr As WString, ByRef wszMatchStr As Const WString, ByVal nStart As Long = 1, ByVal MatchCase As Boolean = True) As UString

Declare Function StringExtract(ByRef wszMainStr As WString, ByRef wszDelim1 As Const WString, ByRef wszDelim2 As Const WString, ByVal nStart As Long = 1, ByVal MatchCase As Boolean = True) As UString

Declare Function StringSubStringAll(ByRef wszMainStr As WString, ByRef ParseStart As Const WString, ByRef ParseEnd As Const WString,Result() As WString Ptr, MatchCase As Boolean = True) As Long

Declare Function GetErrorString(ByVal Code As UInteger, ByVal MaxLen  As UShort = 1024, WithCode As Boolean = False) As UString

#ifndef __USE_MAKE__
	#include once "SysUtils.bas"
#endif
