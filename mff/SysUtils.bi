'###############################################################################
'#  SysUtils.bi                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   SysUtils.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#  Modified by Xusinboy Bekchanov (2018-2019)                                 #
'###############################################################################

#ifdef __FB_LINUX__
	#define __USE_GTK__
#else
	#define __USE_WINAPI__
#endif

#ifndef __USE_GTK__
    #define UNICODE
    #include once "Windows.bi"
    #include once "Win/CommCtrl.bi"
    #include once "Win/CommDlg.bi"
    #include once "Win/RichEdit.bi"
    #define Instance GetModuleHandle(NULL)
#endif
#include once "utf_conv.bi"
'#Include Once "UString.bi"

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

Declare Function iGet(Value As Any Ptr) As Integer

Declare Function ZGet(ByRef subject As ZString Ptr) As String

Declare Sub WDeAllocate Overload(ByRef subject As WString Ptr)

Declare Sub WDeAllocate Overload(subject() As WString Ptr)

Declare Sub WReAllocate(ByRef subject As WString Ptr, lLen As Integer)

Declare Function WGet(ByRef subject As WString Ptr) ByRef As WString

Declare Sub WLet(ByRef subject As WString Ptr, ByRef txt As WString, ExistsSubject As Boolean = False)

Declare Sub WAdd(ByRef subject As WString Ptr, ByRef txt As WString)

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
    
    #IFNDef __USE_GTK__
    Declare Function GetClassProc(FWindow As HWND) As Any Ptr
    
    Declare Function GetClassNameOf(FWindow As HWND) As String
    
    Declare Sub Finalization
    #EndIf
End Namespace

Using ClassContainer

Declare Function ToUtf8(pWString As WString Ptr) As String

Declare Function FromUtf8(pZString As ZString Ptr) ByRef As WString

#IfDef GetMN
	Declare Function GetMessageName(Message As Integer) As String
#EndIf

Declare Function ErrDescription(Code As Integer) ByRef As WString

Declare Function _Abs(Value As Boolean) As Integer

Declare Function InStrCount(ByRef subject As WString, ByRef searchtext AS Wstring, start As Integer = 1) As Integer

Dim Shared wTemp(10) As WString Ptr

Declare Sub Split(ByRef subject As WString, ByRef Delimiter As Wstring, result() As Wstring Ptr)

Declare Function Join(subject() As WString Ptr, iStart As Integer = 0, iStep As Integer = 1) ByRef As WString

Declare Function Replace(ByRef subject As WString, ByRef oldtext As const WString, ByRef newtext As const WString, ByVal start As Integer = 1, byref count as integer = 0, memnumber As Integer = 0) ByRef As WString

Declare Function StartsWith(ByRef a As WString, ByRef b As WString) As Boolean

Declare Function EndsWith(ByRef a As WString, ByRef b As WString) As Boolean

#IfNDef __USE_MAKE__
	#Include Once "SysUtils.bas"
#EndIf
