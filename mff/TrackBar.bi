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
	
	'`TrackBar` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`TrackBar` - A trackbar is a window that contains a slider (sometimes called a thumb) in a channel, and optional tick marks.
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
			'Deserializes properties from stream
			Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Serializes properties to stream
			Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property MinValue As Integer
		'Gets/sets the minimum range value
		Declare Property MinValue(Value As Integer)
		Declare Property MaxValue As Integer
		'Gets/sets the maximum range value
		Declare Property MaxValue(Value As Integer)
		Declare Property Position  As Integer
		'Gets/sets the current slider position
		Declare Property Position(Value As Integer)
		Declare Property LineSize  As Integer
		'Gets/sets the step value for arrow key navigation
		Declare Property LineSize(Value As Integer)
		Declare Property PageSize  As Integer
		'Gets/sets the scroll page size (thumb drag distance)
		Declare Property PageSize(Value As Integer)
		Declare Property Frequency As Integer
		'Sets the interval between regular tick marks
		Declare Property Frequency(Value As Integer)
		Declare Property TabIndex As Integer
		'Gets/sets tab navigation order
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		'Determines if control accepts focus via Tab key
		Declare Property TabStop(Value As Boolean)
		Declare Property ThumbLength  As Integer
		'Gets/sets the length of the slider thumb
		Declare Property ThumbLength(Value As Integer)
		Declare Property SelStart  As Integer
		'Gets/sets the start position of a selection range
		Declare Property SelStart(Value As Integer)
		Declare Property SelEnd As Integer
		'Gets/sets the end position of a selection range
		Declare Property SelEnd(Value As Integer)
		Declare Property SliderVisible As Boolean
		'Controls visibility of the slider thumb
		Declare Property SliderVisible(Value As Boolean)
		Declare Property TickStyle As TickStyles
		'Configures tick display mode (None/Auto/Manual)
		Declare Property TickStyle(Value As TickStyles)
		Declare Property TickMark As TickMarks
		'Sets tick mark position (Top/Bottom/Left/Right)
		Declare Property TickMark(Value As TickMarks)
		Declare Property Style As TrackBarOrientation
		'Sets orientation (Horizontal/Vertical)
		Declare Property Style(Value As TrackBarOrientation) ' TrackBarOrientation
		'Adds a custom tick mark at specified position
		Declare Sub AddTickMark(Value As Integer)
		'Removes all custom tick marks
		Declare Sub ClearTickMarks
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		'Triggered when slider position changes
		OnChange As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TrackBar, Position As Integer)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "TrackBar.bas"
#endif
