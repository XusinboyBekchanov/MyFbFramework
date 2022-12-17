'###############################################################################
'#  TrackBar.bi                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TTrackBar.bi                                                              #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "Control.bi"

Namespace My.Sys.Forms
	#define QTrackBar(__Ptr__) (*Cast(TrackBar Ptr,__Ptr__))
	
	Private Enum TrackBarOrientation
		tbHorizontal, tbVertical
	End Enum
	
	Private Enum TickMarks
		tmBottomRight, tmTopLeft, tmBoth
	End Enum
	
	Private Enum TickStyles
		tsNone, tsAuto, tsManual
	End Enum
	
	Private Type TrackBar Extends Control
	Private:
		FPosition         As Integer
		FMinValue         As Integer
		FMaxValue         As Integer
		FStyle            As TrackBarOrientation
		FTickMark         As TickMarks
		FTickStyle        As TickStyles
		FLineSize         As Integer
		FPageSize         As Integer
		FThumbLength      As Integer
		FFrequency        As Integer
		FSelStart         As Integer
		FSelEnd           As Integer
		FSliderVisible    As Boolean
		AStyle(2)         As Integer
		ATickStyles(3)    As Integer
		ATickMarks(3)     As Integer
		ASliderVisible(2) As Integer
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#else
			Declare Static Sub Range_ValueChanged(range As GtkRange Ptr, user_data As Any Ptr)
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		Declare Sub SetRanges(APosition As Integer, AMin As Integer, AMax As Integer)
	Public:
		#ifndef ReadProperty_Off
			Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property MinValue As Integer
		Declare Property MinValue(Value As Integer)
		Declare Property MaxValue As Integer
		Declare Property MaxValue(Value As Integer)
		Declare Property Position  As Integer
		Declare Property Position(Value As Integer)
		Declare Property LineSize  As Integer
		Declare Property LineSize(Value As Integer)
		Declare Property PageSize  As Integer
		Declare Property PageSize(Value As Integer)
		Declare Property Frequency As Integer
		Declare Property Frequency(Value As Integer)
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		Declare Property ThumbLength  As Integer
		Declare Property ThumbLength(Value As Integer)
		Declare Property SelStart  As Integer
		Declare Property SelStart(Value As Integer)
		Declare Property SelEnd As Integer
		Declare Property SelEnd(Value As Integer)
		Declare Property SliderVisible As Boolean
		Declare Property SliderVisible(Value As Boolean)
		Declare Property TickStyle As TickStyles
		Declare Property TickStyle(Value As TickStyles)
		Declare Property TickMark As TickMarks
		Declare Property TickMark(Value As TickMarks)
		Declare Property Style As TrackBarOrientation
		Declare Property Style(Value As TrackBarOrientation) ' TrackBarOrientation
		Declare Sub AddTickMark(Value As Integer)
		Declare Sub ClearTickMarks
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnChange As Sub(ByRef Sender As TrackBar, Position As Integer)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "TrackBar.bas"
#endif
