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

#include once "Control.bi"

Namespace My.Sys.Forms
	#define QProgressBar(__Ptr__) *Cast(ProgressBar Ptr,__Ptr__)
	
	Private Enum ProgressBarOrientation
		pbHorizontal, pbVertical
	End Enum
	
	Private Type ProgressBar Extends Control
	Private:
		FMode32      As Boolean
		FPosition    As Integer
		FMinValue    As Integer
		FMaxValue    As Integer
		FStep        As Integer
		FSmooth      As Boolean
		FMarquee     As Boolean
		FMarqueeOn   As Boolean
		FOrientation As ProgressBarOrientation
		ASmooth(2)   As Integer
		AMarquee(2)  As Integer
		FMarqueeInterval As Integer
		AOrientation(2) As Integer
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#else
			Declare Static Function progress_cb(ByVal user_data As gpointer) As gboolean
			Dim progress_bar_timer_id As UInteger
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		Declare Sub SetRange(AMin As Integer, AMax As Integer)
		#ifdef __USE_WINAPI__
			Declare Virtual Sub SetDark(Value As Boolean)
		#endif
	Public:
		Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
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
		Declare Property Orientation As ProgressBarOrientation
		Declare Property Orientation(Value As ProgressBarOrientation)
		Declare Operator Cast As Control Ptr
		Declare Sub SetMarquee(MarqueeOn As Boolean, Interval As Integer)
		Declare Sub StopMarquee
		Declare Sub StepIt
		Declare Sub StepBy(Delta As Integer)
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "ProgressBar.bas"
#endif
