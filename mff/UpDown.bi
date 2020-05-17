'###############################################################################
'#  UpDown.bi                                                                  #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TUpDown.bi                                                                #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#Include Once "Control.bi"
'Const UDN_DELTAPOS = (UDN_FIRST - 1)

Namespace My.Sys.Forms
	#DEFINE QUpDown(__Ptr__) *Cast(UpDown Ptr,__Ptr__)
	
	Enum UpDownOrientation
		udVertical,udHorizontal
	End Enum
	
	Enum UpDownAlignment
		udRight,udLeft
	End Enum
	
	Type UpDown Extends Control
	Private:
		FPosition     As Integer
		FMinValue     As Integer
		FMaxValue     As Integer
		FStyle        As Integer
		FArrowKeys    As Boolean
		FIncrement    As Integer
		FAlignment    As Integer
		FThousands    As Boolean
		FWrap         As Boolean
		#IfNDef __USE_GTK__
			FUDAccel(1)   As UDACCEL
		#EndIf
		AStyle(2)     As Integer
		AAlignment(2) As Integer
		AWrap(2)      As Integer
		AArrowKeys(2) As Integer
		AAThousand(2) As Integer
		FAssociate    As Control Ptr
		#IfNDef __USE_GTK__
			Declare Static Sub WndProc(BYREF Message As Message)
			Declare Sub ProcessMessage(BYREF Message As Message)
			Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
		#EndIf
		Declare Sub SetRange(AMin As Integer, AMax As Integer)
	Public:
		Declare Property MinValue As Integer
		Declare Property MinValue(Value As Integer)
		Declare Property MaxValue As Integer
		Declare Property MaxValue(Value As Integer)
		Declare Property Increment As Integer
		Declare Property Increment(Value As Integer)
		Declare Property Position  As Integer
		Declare Property Position(Value As Integer)
		Declare Property ArrowKeys As Boolean
		Declare Property ArrowKeys(Value As Boolean)
		Declare Property Thousands As Boolean
		Declare Property Thousands(Value As Boolean)
		Declare Property Wrap As Boolean
		Declare Property Wrap(Value As Boolean)
		Declare Property Style As Integer
		Declare Property Style(Value As Integer)
		Declare Property Associate As Control Ptr
		Declare Property Associate(Value As Control Ptr)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnChanging   As Sub(BYREF Sender As UpDown,Value As Integer,Direction As Integer)
	End Type
End namespace

#IfNDef __USE_MAKE__
	#Include Once "UpDown.bas"
#EndIf
