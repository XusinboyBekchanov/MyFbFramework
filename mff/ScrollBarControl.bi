'###############################################################################
'#  ScrollBarControl.bi                                                        #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TScrollBar.bi                                                             #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
	#DEFINE QScrollBarControl(__Ptr__) *Cast(ScrollBarControl Ptr,__Ptr__)
	
	Enum ScrollBarControlStyle
		sbHorizontal,sbVertical
	End Enum
	
	Type ScrollBarControl Extends Control
	Private:
		FStyle      	As ScrollBarControlStyle
		FMin        	As Integer
		FMax        	As Integer
		FPosition   	As Integer
		FArrowChangeSize 	As Integer
		FPageSize   	As Integer
		AStyle(2)   	As Integer
		#IfNDef __USE_GTK__
			SIF         	As SCROLLINFO
			Declare Static Sub WndProc(BYREF Message As Message)
			Declare Sub ProcessMessage(BYREF Message As Message)
			Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
		#EndIf
	Public:
		Declare Property Style As ScrollBarControlStyle
		Declare Property Style(Value As ScrollBarControlStyle)
		Declare Property MinValue As Integer
		Declare Property MinValue(Value As Integer)
		Declare Property MaxValue As Integer
		Declare Property MaxValue(Value As Integer)
		Declare Property ArrowChangeSize As Integer
		Declare Property ArrowChangeSize(Value As Integer)
		Declare Property PageSize As Integer
		Declare Property PageSize(Value As Integer)
		Declare Property Position As Integer
		Declare Property Position(Value As Integer)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnCnange As Sub(BYREF Sender As ScrollBarControl)
		OnScroll As Sub(BYREF Sender As ScrollBarControl, ByRef NewPos As Integer)
	End Type
End Namespace

#IfNDef __USE_MAKE__
	#Include Once "ScrollBarControl.bas"
#EndIf
