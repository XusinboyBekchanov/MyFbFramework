'******************************************************************************
'* Cursor.bi                                                                  *
'* Authors: Nastase Eodor, Xusinboy Bekchanov                                 *
'* Based on:                                                                  *
'*  TCursor                                                                   *
'*  This file is part of FreeBasic Windows GUI ToolKit                        *
'*  Copyright (c) 2007-2008 Nastase Eodor                                     *
'*  Version 1.0.0                                                             *
'*  nastase_eodor@yahoo.com                                                   *
'* Updated and added cross-platform                                          *
'* by Xusinboy Bekchanov (2018-2019)                                         *
'******************************************************************************

#include once "Component.bi"

Namespace Cursors
#ifdef __USE_GTK__
	#define crDefault     "default"
	#define crArrow       "default"
	#define crAppStarting "progress"
	#define crCross       "crosshair"
	#define crIBeam       "text"
	#define crIcon        GDK_ICON
	#define crNo          "not-allowed"
	#define crSize        "move"
	#define crSizeAll     "all-scroll"
	#ifdef __USE_GTK3__
		#define crSizeNESW    "nesw-resize"
	#else
		#define crSizeNESW    "crosshair"
	#endif
	#ifdef __USE_GTK3__
		#define crSizeNS      "ns-resize"
	#else
		#define crSizeNS      "sb_v_double_arrow"
	#endif
	#ifdef __USE_GTK3__
		#define crSizeNWSE    "nwse-resize"
	#else
		#define crSizeNWSE    "crosshair"
	#endif
	#ifdef __USE_GTK3__
		#define crSizeWE      "ew-resize"
	#else
		#define crSizeWE      "sb_h_double_arrow"
	#endif
	#define crUpArrow     GDK_CENTER_PTR
	#define crWait        "wait"
	#define crDrag        GDK_FLEUR
	#define crMultiDrag   GDK_FLEUR
	#define crHandPoint   "pointer"
	#define crSQLWait     GDK_WATCH
	#define crHSplit      "col-resize"
	#define crVSplit      "row-resize"
	#define crNoDrop      "no-drop"
#else
	#define crDefault     0
	#define crArrow       LoadCursor(0,IDC_ARROW)
	#define crAppStarting LoadCursor(0,IDC_APPSTARTING)
	#define crCross       LoadCursor(0,IDC_CROSS)
	#define crIBeam       LoadCursor(0,IDC_IBEAM)
	#define crIcon        LoadCursor(0,IDC_ICON)
	#define crNo          LoadCursor(0,IDC_NO)
	#define crSize        LoadCursor(0,IDC_SIZE)
	#define crSizeAll     LoadCursor(0,IDC_SIZEALL)
	#define crSizeNESW    LoadCursor(0,IDC_SIZENESW)
	#define crSizeNS      LoadCursor(0,IDC_SIZENS)
	#define crSizeNWSE    LoadCursor(0,IDC_SIZENWSE)
	#define crSizeWE      LoadCursor(0,IDC_SIZEWE)
	#define crUpArrow     LoadCursor(0,IDC_UPARROW)
	#define crWait        LoadCursor(0,IDC_WAIT)
	#define crHand        LoadCursor(0,IDC_HAND)
	#define crHelp        LoadCursor(0,IDC_HELP)
	#define crDrag        LoadCursor(GetModuleHandle(NULL),"DRAG")
	#define crMultiDrag   LoadCursor(GetModuleHandle(NULL),"MULTIDRAG")
	#define crHandPoint   LoadCursor(GetModuleHandle(NULL),"HANDPOINT")
	#define crSQLWait     LoadCursor(GetModuleHandle(NULL),"SQLWAIT")
	#define crHSplit      LoadCursor(GetModuleHandle(NULL),"HSPLIT")
	#define crVSplit      LoadCursor(GetModuleHandle(NULL),"VSPLIT")
	#define crNoDrop      LoadCursor(GetModuleHandle(NULL),"NODROP")
#endif
End Namespace

Namespace My.Sys.Drawing
	#define QCursor(__Ptr__) (*Cast(Cursor Ptr,__Ptr__))
	
	'Represents the image used to paint the mouse pointer (Windows, Linux).
	Private Type Cursor Extends My.Sys.Object
	Private:
		FWidth     As Integer
		FHeight    As Integer
		FHotSpotX  As Integer
		FHotSpotY  As Integer
		FResName As WString Ptr
		Declare Sub Create
	Public:
		#ifndef ReadProperty_Off
			Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Ctrl 			As My.Sys.ComponentModel.Component Ptr
		Graphic    		As Any Ptr
		#ifdef __USE_GTK__
			Handle 		As GdkCursor Ptr
		#elseif defined(__USE_WINAPI__)
			Handle		As HCURSOR
		#elseif defined(__USE_JNI__)
			Handle		As jobject
		#else
			Handle		As Any Ptr
		#endif
		Declare Property Width As Integer
		Declare Property Width(Value As Integer)
		Declare Property Height As Integer
		Declare Property Height(Value As Integer)
		Declare Property HotSpotX As Integer
		Declare Property HotSpotX(Value As Integer)
		Declare Property HotSpotY As Integer
		Declare Property HotSpotY(Value As Integer)
		Declare Function LoadFromFile(ByRef File As WString, cx As Integer = 0, cy As Integer = 0) As Boolean
		Declare Function SaveToFile(ByRef File As WString) As Boolean
		Declare Function LoadFromResourceName(ByRef ResName As WString, ModuleHandle As Any Ptr = 0, cxDesired As Integer = 0, cyDesired As Integer = 0) As Boolean
		Declare Function LoadFromResourceID(ResID As Integer, ModuleHandle As Any Ptr = 0, cxDesired As Integer = 0, cyDesired As Integer = 0) As Boolean
		#ifdef __USE_WINAPI__
			Declare Function ToBitmap() As HBITMAP
		#endif
		Declare Function ToString() ByRef As WString
		Declare Operator Cast As Any Ptr
		Declare Operator Let(Value As Integer)
		#ifdef __USE_GTK__
			Declare Operator Let(Value As GdkCursorType)
		#elseif defined(__USE_WINAPI__)
			Declare Operator Let(Value As HCURSOR)
		#endif
		Declare Operator Let(ByRef Value As WString)
		Declare Operator Let(Value As Cursor)
		Declare Constructor
		Declare Destructor
		Changed As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Cursor)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "Cursor.bas"
#endif
