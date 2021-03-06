﻿'###############################################################################
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

#include once "Control.bi"

Namespace My.Sys.Forms
	#define QScrollBarControl(__Ptr__) *Cast(ScrollBarControl Ptr,__Ptr__)
	
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
		#ifndef __USE_GTK__
			SIF         	As SCROLLINFO
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		Declare Function ReadProperty(PropertyName As String) As Any Ptr
		Declare Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
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
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnCnange As Sub(ByRef Sender As ScrollBarControl)
		OnScroll As Sub(ByRef Sender As ScrollBarControl, ByRef NewPos As Integer)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "ScrollBarControl.bas"
#endif
