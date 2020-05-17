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

#Include Once "Component.bi"

#IfDef __USE_GTK__
	#DEFINE crArrow       "default"
	#DEFINE crAppStarting "progress"
	#DEFINE crCross       "crosshair"
	#DEFINE crIBeam       "text"
	#DEFINE crIcon        GDK_ICON
	#DEFINE crNo          "not-allowed"
	#DEFINE crSize        "move"
	#DEFINE crSizeAll     "all-scroll"
	#DEFINE crSizeNESW    "nesw-resize"
	#DEFINE crSizeNS      "ns-resize"
	#DEFINE crSizeNWSE    "nwse-resize"
	#DEFINE crSizeWE      "ew-resize"
	#DEFINE crUpArrow     GDK_CENTER_PTR
	#DEFINE crWait        "wait"
	#DEFINE crDrag        GDK_FLEUR
	#DEFINE crMultiDrag   GDK_FLEUR
	#DEFINE crHandPoint   "pointer"
	#DEFINE crSQLWait     GDK_WATCH
	#DEFINE crHSplit      "col-resize"
	#DEFINE crVSplit      "row-resize"
	#DEFINE crNoDrop      "no-drop"
#Else
	#DEFINE crArrow       LoadCursor(0,IDC_ARROW)
	#DEFINE crAppStarting LoadCursor(0,IDC_APPSTARTING)
	#DEFINE crCross       LoadCursor(0,IDC_CROSS)
	#DEFINE crIBeam       LoadCursor(0,IDC_IBEAM)
	#DEFINE crIcon        LoadCursor(0,IDC_ICON)
	#DEFINE crNo          LoadCursor(0,IDC_NO)
	#DEFINE crSize        LoadCursor(0,IDC_SIZE)
	#DEFINE crSizeAll     LoadCursor(0,IDC_SIZEALL)
	#DEFINE crSizeNESW    LoadCursor(0,IDC_SIZENESW)
	#DEFINE crSizeNS      LoadCursor(0,IDC_SIZENS)
	#DEFINE crSizeNWSE    LoadCursor(0,IDC_SIZENWSE)
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
