'###############################################################################
'#  Panel.bi                                                                   #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TPanel.bi                                                                 #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "ContainerControl.bi"
#include once "Graphic.bi"
'#Include Once "Canvas.bi"

Namespace My.Sys.Forms
	#define QPanel(__Ptr__) (*Cast(Panel Ptr,__Ptr__))
	
	Private Enum Bevel
		bvNone, bvLowered, bvRaised
	End Enum
	
	'Used to group collections of controls (Windows, Linux, Android, Web).
	Private Type Panel Extends ContainerControl
	Private:
		FTopColor    As Integer
		FBottomColor As Integer
		FBevelInner  As Bevel
		FBevelOuter  As Bevel
		FBorderWidth As Integer
		FBevelWidth  As Integer
		FTransparent As Boolean
		FDownButton  As Integer
		#ifdef __USE_WINAPI__
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			Declare Static Sub WNDPROC(ByRef Message As Message)
			Declare Sub AdjustColors(FBevel As Integer)
			Declare Sub DoRect(R As My.Sys.Drawing.Rect, tTopColor As Integer = GetSysColor(COLOR_BTNSHADOW), tBottomColor As Integer = GetSysColor(COLOR_BTNSHADOW))
			Declare Sub Frame3D(R As My.Sys.Drawing.Rect, AWidth As Integer)
		#endif
		Declare Static Sub GraphicChange(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
	Protected:
		#ifdef __USE_WASM__
			Declare Virtual Function GetContent() As UString
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Returns/sets a graphic to be displayed in a control (Windows, Linux).
		Graphic As My.Sys.Drawing.GraphicType
		Declare Property BevelInner As Bevel
		Declare Property BevelInner(Value As Bevel)
		Declare Property BevelOuter As Bevel
		Declare Property BevelOuter(Value As Bevel)
		Declare Property BevelWidth As Integer
		Declare Property BevelWidth(Value As Integer)
		Declare Property BorderWidth As Integer
		Declare Property BorderWidth(Value As Integer)
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		Declare Virtual Property Text ByRef As WString
		Declare Virtual Property Text(ByRef Value As WString)
		Declare Virtual Property Visible As Boolean
		Declare Virtual Property Visible(Value As Boolean)
		Declare Property Transparent As Boolean
		Declare Property Transparent(Value As Boolean)
		Declare Sub CreateWnd
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "Panel.bas"
#endif
