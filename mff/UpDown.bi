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

#include once "Control.bi"
'Const UDN_DELTAPOS = (UDN_FIRST - 1)

Namespace My.Sys.Forms
	#define QUpDown(__Ptr__) (*Cast(UpDown Ptr,__Ptr__))
	
	Private Enum UpDownOrientation
		udVertical,udHorizontal
	End Enum
	
	Private Enum UpDownAlignment
		udRight,udLeft
	End Enum
	
	'`UpDown` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`UpDown` - An up-down control is a pair of arrow buttons that the user can click to increment or decrement a value, such as a scroll position or a number displayed in a companion control (called a buddy window) (Windows, Linux).
	Private Type UpDown Extends Control
	Private:
	Protected:
		FPosition     As Integer
		FMinValue     As Integer
		FMaxValue     As Integer
		FStyle        As UpDownOrientation
		FArrowKeys    As Boolean
		FIncrement    As Integer
		FAlignment    As Integer
		FThousands    As Boolean
		FWrap         As Boolean
		#ifndef __USE_GTK__
			FUDAccel(1)   As UDACCEL
		#endif
		AStyle(2)     As Integer
		AAlignment(2) As Integer
		AWrap(2)      As Integer
		AArrowKeys(2) As Integer
		AAThousand(2) As Integer
		FAssociate    As Control Ptr
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#endif
		Declare Sub SetRange(AMin As Integer, AMax As Integer)
	Public:
		#ifndef ReadProperty_Off
			'Loads property from serialization stream
			Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves property to serialization stream
			Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Processes Windows API messages
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		Declare Property Alignment As UpDownAlignment
		'Gets/sets arrow buttons alignment (Left/Right)
		Declare Property Alignment(Value As UpDownAlignment)
		Declare Property ArrowKeys As Boolean
		'Determines if arrow keys can control value changes
		Declare Property ArrowKeys(Value As Boolean)
		Declare Property MinValue As Integer
		'Gets/sets minimum allowed value
		Declare Property MinValue(Value As Integer)
		Declare Property MaxValue As Integer
		'Gets/sets maximum allowed value
		Declare Property MaxValue(Value As Integer)
		Declare Property Increment As Integer
		'Gets/sets the value change per arrow click
		Declare Property Increment(Value As Integer)
		Declare Property Position  As Integer
		'Gets/sets current numeric value
		Declare Property Position(Value As Integer)
		Declare Property TabIndex As Integer
		'Gets/sets tab order position
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		'Determines if control accepts focus via Tab key
		Declare Property TabStop(Value As Boolean)
		Declare Property Text ByRef As WString
		'Gets/sets string representation of current value
		Declare Property Text(ByRef Value As WString)
		Declare Property Thousands As Boolean
		'Determines if thousand separators are displayed
		Declare Property Thousands(Value As Boolean)
		Declare Property Wrap As Boolean
		'Enables value wrap-around at min/max limits
		Declare Property Wrap(Value As Boolean)
		Declare Property Style As UpDownOrientation
		'Gets/sets visual style (Vertical/Horizontal arrows)
		Declare Property Style(Value As UpDownOrientation)
		Declare Property Associate As Control Ptr
		'Gets/sets the buddy control linked to display values
		Declare Property Associate(Value As Control Ptr)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		'Raised before value changes occur
		OnChanging   As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As UpDown,Value As Integer,Direction As Integer)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "UpDown.bas"
#endif
