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

#ifdef __FB_LINUX__
	#define __USE_GTK__
#else
	#define __USE_WINAPI__
#endif

#ifdef __FB_WIN32__
	#define UNICODE
	#include once "Windows.bi"
#endif

#ifndef __USE_GTK__
	#include once "Win/CommCtrl.bi"
	#include once "Win/CommDlg.bi"
	#include once "Win/RichEdit.bi"
	#include once "win/iphlpapi.bi"
	#define Instance GetModuleHandle(NULL)
#endif
#include once "utf_conv.bi"
#include once "UString.bi"

#ifdef __EXPORT_PROCS__
	#define __EXPORT__ Export
#else
	#define __EXPORT__
#endif

Const HELP_SETPOPUP_POS = &Hd

'#DEFINE __AUTOMATE_CREATE_CHILDS__

#ifndef __USE_GTK__
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
#endif

Declare Function ScaleX (ByVal cx As Single) As Single
Declare Function ScaleY (ByVal cy As Single) As Single

Declare Function iGet(Value As Any Ptr) As Integer
Declare Function ZGet(ByRef subject As ZString Ptr) As String

Declare Sub WDeAllocate Overload(ByRef subject As WString Ptr)

Declare Sub WDeAllocate Overload(subject() As WString Ptr)

Declare Sub WReAllocate(ByRef subject As WString Ptr, lLen As Integer)

Declare Function WGet(ByRef subject As WString Ptr) ByRef As WString

Declare Sub WLet(ByRef subject As WString Ptr, ByRef txt As WString, ExistsSubjectInTxt As Boolean = False)

Declare Sub WAdd(ByRef subject As WString Ptr, ByRef txt As WString, AddBefore As Boolean = False)

Namespace ClassContainer
	Type ClassType
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
	
	#ifndef __USE_GTK__
		Declare Function GetClassProc(FWindow As HWND) As Any Ptr
		
		Declare Function GetClassNameOf(FWindow As HWND) As String
		
		Declare Sub Finalization
	#endif
End Namespace

Using ClassContainer

Declare Function ToUtf8(ByRef nWString As WString) As String

Declare Function FromUtf8(pZString As ZString Ptr) ByRef As WString

#ifdef GetMN
	Declare Function GetMessageName(Message As Integer) As String
#endif

Declare Function ErrDescription(Code As Integer) ByRef As WString

Declare Function _Abs(Value As Boolean) As Integer

Declare Function InStrCount(ByRef subject As WString, ByRef searchtext As WString, start As Integer = 1, MatchCase As Boolean = True) As Long

Declare Sub Split(ByRef subject As WString, ByRef Delimiter As WString, result() As UString, MatchCase As Boolean = True)

Declare Function Join(subject() As UString, ByRef Delimiter As WString, iStart As Integer = 0, iStep As Integer = 1) As UString

Declare Function StartsWith(ByRef a As WString, ByRef b As WString) As Boolean

Declare Function EndsWith(ByRef a As WString, ByRef b As WString) As Boolean

Declare Function StringExtract Overload(ByRef wszMainStr As WString, ByRef wszMatchStr As Const WString, ByVal nStart As Long = 1, ByVal MatchCase As Boolean = True) As UString

Declare Function StringExtract(ByRef wszMainStr As WString, ByRef wszDelim1 As Const WString, ByRef wszDelim2 As Const WString, ByVal nStart As Long = 1, ByVal MatchCase As Boolean = True) As UString

Declare Function StringSubStringAll(ByRef wszMainStr As WString, ByRef ParseStart As Const WString, ByRef ParseEnd As Const WString,Result() As WString Ptr, MatchCase As Boolean = True) As Long

Declare Function GetErrorString(ByVal Code As UInteger, ByVal MaxLen  As UShort = 1024) As UString

#ifndef __USE_MAKE__
	#include once "SysUtils.bas"
#endif
