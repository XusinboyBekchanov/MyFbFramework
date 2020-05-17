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

#Include Once "ContainerControl.bi"
'#Include Once "Canvas.bi"

Namespace My.Sys.Forms
	#DEFINE QPanel(__Ptr__) *Cast(Panel Ptr,__Ptr__)
	
	Enum Bevel
		bvNone, bvLowered,bvRaised
	End Enum
	
	Type Panel Extends ContainerControl
	Private:
		FTopColor    As Integer
		FBottomColor As Integer
		FBevelInner  As Integer
		FBevelOuter  As Integer
		FBorderWidth As Integer
		FBevelWidth  As Integer
		#IfNDef __USE_GTK__
			Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
			Declare Static Sub WndProc(BYREF Message As Message)
			Declare Sub AdjustColors(FBevel As Integer)
			Declare Sub DoRect(R As RECT,tTopColor As Integer = GetSysColor(COLOR_BTNSHADOW),tBottomColor As Integer = GetSysColor(COLOR_BTNSHADOW))
			Declare Sub Frame3D(R As RECT, AWidth As Integer)
		#EndIf
	Public:
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		'Canvas        As My.Sys.Drawing.Canvas
		Declare Property BevelInner As Integer
		Declare Property BevelInner(Value As Integer)
		Declare Property BevelOuter As Integer
		Declare Property BevelOuter(Value As Integer)
		Declare Property BevelWidth As Integer
		Declare Property BevelWidth(Value As Integer)
		Declare Property BorderWidth As Integer
		Declare Property BorderWidth(Value As Integer)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		#IfNDef __USE_GTK__
			OnPaint     As Sub(BYREF Sender As Panel,DC As HDC,R As Rect)
		#EndIf
	End Type
End Namespace

#IfNDef __USE_MAKE__
	#Include Once "Panel.bas"
#EndIf
