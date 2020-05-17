'###############################################################################
'#  ProgressBar.bi                                                             #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TProgressBar.bi                                                           #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
	#DEFINE QProgressBar(__Ptr__) *Cast(ProgressBar Ptr,__Ptr__)
	
	Enum ProgressBarOrientation
		pbHorizontal, pbVertical
	End Enum
	
	Type ProgressBar Extends Control
	Private:
		FMode32      As Boolean
		FPosition    As Integer
		FMinValue    As Integer
		FMaxValue    As Integer
		FStep        As Integer
		FSmooth      As Boolean
		FMarquee     As Boolean
		FMarqueeOn   As Boolean
		FOrientation As Integer
		ASmooth(2)   As Integer
		AMarquee(2)  As Integer
		FMarqueeInterval As Integer
		AOrientation(2) As Integer
		#IfNDef __USE_GTK__
			Declare Static Sub WndProc(BYREF Message As Message)
			Declare Sub ProcessMessage(BYREF Message As Message)
			Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
		#EndIf
		Declare Sub SetRange(AMin As Integer,AMax As Integer)
	Public:
		Declare Property MinValue As Integer
		Declare Property MinValue(Value As Integer)
		Declare Property MaxValue As Integer
		Declare Property MaxValue(Value As Integer)
		Declare Property Position As Integer
		Declare Property Position(Value As Integer)
		Declare Property StepValue As Integer
		Declare Property StepValue(Value As Integer)
		Declare Property Smooth As Boolean
		Declare Property Smooth(Value As Boolean)
		Declare Property Marquee As Boolean
		Declare Property Marquee(Value As Boolean)
		Declare Property Orientation As Integer
		Declare Property Orientation(Value As Integer)
		Declare Operator Cast As Control Ptr
		Declare Sub SetMarquee(MarqueeOn As Boolean, Interval As Integer)
		Declare Sub StepIt
		Declare Sub StepBy(Delta As Integer)
		Declare Constructor
		Declare Destructor
	End Type
End namespace

#IfNDef __USE_MAKE__
	#Include Once "ProgressBar.bas"
#EndIf
