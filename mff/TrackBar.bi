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

#Include Once "Control.bi"

Namespace My.Sys.Forms
	#DEFINE QTrackBar(__Ptr__) *Cast(TrackBar Ptr,__Ptr__)
	
	Enum TrackBarOrientation
		tbVertical,tbHorizontal
	End Enum
	
	Enum TickMark
		tmBottomRight, tmTopLeft, tmBoth
	End Enum
	
	Enum TickStyle
		tsNone, tsAuto, tsManual
	End Enum
	
	Type TrackBar Extends Control
	Private:
		FPosition         As Integer
		FMinValue         As Integer
		FMaxValue         As Integer
		FStyle            As Integer
		FTick             As Integer
		FTickMarks        As Integer
		FTickStyle        As Integer
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
		#IfNDef __USE_GTK__
			Declare Static Sub WndProc(BYREF Message As Message)
			Declare Sub ProcessMessage(BYREF Message As Message)
			Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
		#EndIf
		Declare Sub SetRanges(APosition As Integer, AMin As Integer, AMax As Integer)
	Public:
		Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
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
		Declare Property ThumbLength  As Integer
		Declare Property ThumbLength(Value As Integer)
		Declare Property SelStart  As Integer
		Declare Property SelStart(Value As Integer)
		Declare Property SelEnd As Integer
		Declare Property SelEnd(Value As Integer)
		Declare Property SliderVisible As Boolean
		Declare Property SliderVisible(Value As Boolean)
		Declare Property Tick As Integer
		Declare Property Tick(Value As Integer)
		Declare Property TickStyle As Integer
		Declare Property TickStyle(Value As Integer)
		Declare Property TickMarks As Integer
		Declare Property TickMarks(Value As Integer)
		Declare Property Style As Integer
		Declare Property Style(Value As Integer) ' TrackBarOrientation
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnChange As Sub(BYREF Sender As TrackBar, Position As Integer)
	End Type
End namespace

#IfNDef __USE_MAKE__
	#Include Once "TrackBar.bas"
#EndIf
