'###############################################################################
'#  NumericUpDown.bi                                                                  #
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

#include once "UpDown.bi"

Namespace My.Sys.Forms
	#define QNumericUpDown(__Ptr__) (*Cast(NumericUpDown Ptr, __Ptr__))
	
	'`NumericUpDown` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`NumericUpDown` - Allows numeric input via textbox with increment/decrement buttons and value constraints.
	Private Type NumericUpDown Extends Control
	Private:
		FStyle        As UpDownOrientation
		FText As WString * 100
		FDecimalPlaces As Integer
		FScaleFactor   As Integer = 1
		FIntegerTemp   As Integer
		FDoubleTemp    As Integer
		FBooleanTemp    As Integer
		FHandleIsAllocated As Boolean
		#ifndef __USE_GTK__
			Declare Static Function HookChildProc(hDlg As HWND, uMsg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#elseif defined(__USE_GTK__)
			Declare Static Sub SpinButton_ValueChanged(self As GtkSpinButton Ptr, user_data As Any Ptr)
		#endif
	Protected:
		As UpDown UpDownControl
		Declare Sub MoveUpDownControl
	Public:
		#ifndef ReadProperty_Off
			'Loads configuration from data stream
			Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves configuration to data stream
			Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Processes Windows API messages
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		Declare Property MinValue As Double
		'Minimum allowed numeric value
		Declare Property MinValue(Value As Double)
		Declare Property MaxValue As Double
		'Maximum allowed numeric value
		Declare Property MaxValue(Value As Double)
		Declare Property Increment As Double
		'Step value for each button press
		Declare Property Increment(Value As Double)
		Declare Property DecimalPlaces As Integer
		'Number of displayed decimal digits
		Declare Property DecimalPlaces(Value As Integer)
		Declare Property Position  As Double
		'Current numeric value
		Declare Property Position(Value As Double)
		Declare Property ArrowKeys As Boolean
		'Enables keyboard arrow keys for value adjustment
		Declare Property ArrowKeys(Value As Boolean)
		Declare Property TabIndex As Integer
		'Tab order position
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		'Includes in tab navigation when True
		Declare Property TabStop(Value As Boolean)
		Declare Property Text ByRef As WString
		'String representation of current value
		Declare Property Text(ByRef Value As WString)
		Declare Property Thousands As Boolean
		'Displays thousand separators when enabled
		Declare Property Thousands(Value As Boolean)
		Declare Property Wrap As Boolean
		'Circulates values past min/max limits
		Declare Property Wrap(Value As Boolean)
		Declare Property Style As UpDownOrientation
		'Visual style (Flat/Standard/Modern)
		Declare Property Style(Value As UpDownOrientation)
		Declare Property UpDownWidth As Integer
		'Width of spinner buttons in pixels
		Declare Property UpDownWidth(Value As Integer)
		'Highlights all text content
		Declare Sub SelectAll
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		'Raised when value changes via any input method
		OnChange As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As NumericUpDown)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "NumericUpDown.bas"
#endif
