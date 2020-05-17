'###############################################################################
'#  HScrollBar.bi                                                              #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TScrollBar.bi                                                             #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

Namespace My.Sys.Forms
	#DEFINE QHScrollBar(__Ptr__) *Cast(HScrollBar Ptr,__Ptr__)
	
	Type HScrollBar Extends Control
	Private:
		FMin            As Integer
		FMax            As Integer
		FPosition       As Integer
		FArrowChangeSize     As Integer
		FPageSize       As Integer
		#IfNDef __USE_GTK__
			SIF             As SCROLLINFO
			Declare Static Sub WndProc(BYREF Message As Message)
			Declare Sub ProcessMessage(BYREF Message As Message)
			Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
		#EndIf
	Public:
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
		OnChange As Sub(BYREF Sender As HScrollBar)
		OnScroll As Sub(BYREF Sender As HScrollBar, ByRef NewPos As UInteger)
	End Type
End Namespace

#IfNDef __USE_MAKE__
	#Include Once "HScrollBar.bas"
#EndIf
