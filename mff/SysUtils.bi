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
#elseif defined(__FB_JS__)
	#ifndef __USE_WASM__
		#define __USE_WASM__
	#endif
#elseif Not defined(__USE_WASM__)
	#if Not defined(__FB_WIN32__)
		#ifndef __USE_GTK__
			#define __USE_GTK__
		#endif
	#elseif Not defined(__USE_GTK__)
		#ifndef __USE_WINAPI__
			#define __USE_WINAPI__
		#endif
	#endif
#endif

#if defined(__USE_WINAPI__) OrElse defined(__FB_WIN32__)
	#define UNICODE
	#include once "windows.bi"
#endif

#ifdef __USE_GTK__
	'#define FHandle Widget
	'#if defined(__USE_GTK3__) Or defined(__USE_GTK4__)
	'#elseif Not defined(__USE_GTK2__)
	'	#define __USE_GTK2__
	'#endif
	'#ifdef __USE_GTK4__
	'	#include once "cairo/cairo.bi"
	'	#include once "gir_headers/Gir/PangoCairo-1.0.bi"
	'	#include once "gir_headers/Gir/Gtk-4.0.bi"
	'	#include once "gir_headers/Gir/_GObjectMacros-2.0.bi"
	'#else
	'	#include once "gtk/gtk.bi"
	'	#ifdef __USE_GTK3__
	'		#include once "glib-object.bi"
	'	#endif
	'#endif
#elseif defined(__USE_JNI__)
	#include once "jni.bi"
	#define Max(a, b) IIf((a) > (b), (a), (b))
	#define Min(a, b) IIf((a) < (b), (a), (b))
#elseif defined(__USE_WASM__)
	#define Max(a, b) IIf((a) > (b), (a), (b))
	#define Min(a, b) IIf((a) < (b), (a), (b))
	Declare Sub AddColumn(Id As Any Ptr, Caption As String)
	Declare Sub AddRow(Id As Any Ptr, Text As String)
	Declare Function GetDocumentWidth() As Integer
	Declare Function GetDocumentHeight() As Integer
	Declare Sub InsertHTML(Value As String)
	Declare Sub SetTitle(Value As String)
	Declare Sub FreePtr(Ptr As Any Ptr)
	Declare Sub SetVisibleByStringId(Id As String, Value As Boolean)
	Declare Sub SetVisible(Id As Any Ptr, Value As Boolean)
	Declare Sub CreateElement(AddPosition As String, ClassName As String, Class As String, Type As String, Id As Any Ptr, Name As String, Text As String, Style As String, PositionType As String, Left As String, Top As String, Width As String, Height As String, Right As String, Bottom As String, Parent As Any Ptr)
	Declare Sub DeleteElement(Id As Any Ptr)
	Declare Function GetStringValue(Id As Any Ptr) As ZString Ptr
	Declare Sub SetStringValue(Id As Any Ptr, Value As String)
	Declare Sub SetBackColor(Id As Any Ptr, Value As Integer)
	Declare Sub SetForeColor(Id As Any Ptr, Value As Integer)
	Declare Sub SetFont(Id As Any Ptr, Value As String)
	Declare Sub SetChecked(Id As String, Value As Boolean)
	Declare Function GetChecked(Id As String) As Boolean
	Declare Function MessageBox(Message As String, Caption As String, MessageType As Integer, ButtonsType As Integer) As Integer
	Declare Sub SetLoadEvent(Id As Any Ptr)
	Declare Sub SetChangeEvent(Id As Any Ptr)
	Declare Sub SetClickEvent(Id As Any Ptr)
	Declare Sub SetDblClickEvent(Id As Any Ptr)
	Declare Sub SetGotFocusEvent(Id As Any Ptr)
	Declare Sub SetLostFocusEvent(Id As Any Ptr)
	Declare Sub SetKeyDownEvent(Id As Any Ptr)
	Declare Sub SetKeyPressEvent(Id As Any Ptr)
	Declare Sub SetKeyUpEvent(Id As Any Ptr)
	Declare Sub SetMouseEnterEvent(Id As Any Ptr)
	Declare Sub SetMouseDownEvent(Id As Any Ptr)
	Declare Sub SetMouseMoveEvent(Id As Any Ptr)
	Declare Sub SetMouseUpEvent(Id As Any Ptr)
	Declare Sub SetMouseLeaveEvent(Id As Any Ptr)
	Declare Sub SetMouseWheelEvent(Id As Any Ptr)
	Declare Sub SetUnloadEvent(Id As Any Ptr)
#elseif defined(__USE_WINAPI__)
	#include once "win/wincrypt.bi"
	#include once "Win/CommCtrl.bi"
	#include once "Win/CommDlg.bi"
	#include once "Win/RichEdit.bi"
	#include once "win/iphlpapi.bi"
	#define Instance GetModuleHandle(NULL)
#endif
#include once "UString.bi"
#include once "Integer.bi"

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

#macro RedefineClassKeyword
	#undef Class
	#define Class Type
	#define __StartOfClassBody__ End Type
	#macro __EndOfClassBody__
		Scope
		#undef Class
		#macro Class
			Scope
			#undef Class
			#define Class Type
		#endmacro
	#endmacro
#endmacro

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
	
	Declare Function EnumThreadWindowsProc(FWindow As HWND,LData As LPARAM) As BOOL
	
	Declare Function MainHandle As HWND
#elseif defined(__USE_JNI__)
	Dim Shared env         As JNIEnv Ptr
	Dim Shared Instance As jobject
#endif
Dim Shared xdpi         As Double
Dim Shared ydpi         As Double

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

Declare Function GetErrorString(ByVal Code As UInteger, ByVal MaxLen  As UShort = 1024, WithCode As Boolean = False) As UString

#ifndef __USE_MAKE__
	#include once "SysUtils.bas"
#endif
