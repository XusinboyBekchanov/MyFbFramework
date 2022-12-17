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
'#Include Once "Canvas.bi"

Namespace My.Sys.Forms
	#define QPanel(__Ptr__) (*Cast(Panel Ptr,__Ptr__))
	
	Private Enum Bevel
		bvNone, bvLowered, bvRaised
	End Enum
	
	Private Type Panel Extends ContainerControl
	Private:
		FTopColor    As Integer
		FBottomColor As Integer
		FBevelInner  As Integer
		FBevelOuter  As Integer
		FBorderWidth As Integer
		FBevelWidth  As Integer
		#ifdef __USE_WINAPI__
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			Declare Static Sub WNDPROC(ByRef Message As Message)
			Declare Sub AdjustColors(FBevel As Integer)
			Declare Sub DoRect(R As My.Sys.Drawing.Rect, tTopColor As Integer = GetSysColor(COLOR_BTNSHADOW), tBottomColor As Integer = GetSysColor(COLOR_BTNSHADOW))
			Declare Sub Frame3D(R As My.Sys.Drawing.Rect, AWidth As Integer)
		#endif
	Protected:
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Canvas        As My.Sys.Drawing.Canvas
		Declare Property BevelInner As Integer
		Declare Property BevelInner(Value As Integer)
		Declare Property BevelOuter As Integer
		Declare Property BevelOuter(Value As Integer)
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
		Declare Sub CreateWnd
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "Panel.bas"
#endif
