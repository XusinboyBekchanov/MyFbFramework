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

#ifdef __USE_GTK__
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
	#DEFINE crSizeWE      LoadCursor(0,IDC_SIZEWE)
	#DEFINE crUpArrow     LoadCursor(0,IDC_UPARROW)
	#DEFINE crWait        LoadCursor(0,IDC_WAIT)
	#DEFINE crDrag        LoadCursor(GetModuleHandle(NULL),"DRAG")
	#DEFINE crMultiDrag   LoadCursor(GetModuleHandle(NULL),"MULTIDRAG")
	#DEFINE crHandPoint   LoadCursor(GetModuleHandle(NULL),"HANDPOINT")
	#DEFINE crSQLWait     LoadCursor(GetModuleHandle(NULL),"SQLWAIT")
	#DEFINE crHSplit      LoadCursor(GetModuleHandle(NULL),"HSPLIT")
	#DEFINE crVSplit      LoadCursor(GetModuleHandle(NULL),"VSPLIT")
	#DEFINE crNoDrop      LoadCursor(GetModuleHandle(NULL),"NODROP")
#EndIf

Namespace My.Sys.Drawing
	#DEFINE QCursor(__Ptr__) *Cast(Cursor Ptr,__Ptr__)
	
	Type Cursor Extends My.Sys.Object
	Private:
		FWidth     As Integer
		FHeight    As Integer
		FHotSpotX  As Integer
		FHotSpotY  As Integer
		Declare Sub Create
	Public:
		Ctrl 			As My.Sys.ComponentModel.Component Ptr
		Graphic    		As Any Ptr
		#IfDef __USE_GTK__
			Handle 		As GdkCursor Ptr
		#Else
			Handle		As HCURSOR
		#EndIf
		Declare Property Width As Integer
		Declare Property Width(Value As Integer)
		Declare Property Height As Integer
		Declare Property Height(Value As Integer)
		Declare Property HotSpotX As Integer
		Declare Property HotSpotX(Value As Integer)
		Declare Property HotSpotY As Integer
		Declare Property HotSpotY(Value As Integer)
		Declare Sub LoadFromFile(ByRef File As WString)
		Declare Sub SaveToFile(ByRef File As WString)
		Declare Sub LoadFromResourceName(ByRef ResName As WString)
		Declare Sub LoadFromResourceID(ResID As Integer)
		Declare Operator Cast As Any Ptr
		#IfDef __USE_GTK__
			Declare Operator Let(Value As GdkCursorType)
		#Else
			Declare Operator Let(Value As HCURSOR)
		#EndIf
		Declare Operator Let(ByRef Value As WString)
		Declare Operator Let(Value As Cursor)
		Declare Constructor
		Declare Destructor
		Changed As Sub(BYREF Sender As Cursor)
	End Type
End namespace

#IfNDef __USE_MAKE__
	#Include Once "Cursor.bas"
#EndIf
