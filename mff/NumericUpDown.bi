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
	
	Private Type NumericUpDown Extends Control
	Private:
		FStyle        As UpDownOrientation
		FText As WString * 100
		FDecimalPlaces As Integer
		FScaleFactor   As Integer = 1
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
			Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		Declare Property MinValue As Double
		Declare Property MinValue(Value As Double)
		Declare Property MaxValue As Double
		Declare Property MaxValue(Value As Double)
		Declare Property Increment As Double
		Declare Property Increment(Value As Double)
		Declare Property DecimalPlaces As Integer
		Declare Property DecimalPlaces(Value As Integer)
		Declare Property Position  As Double
		Declare Property Position(Value As Double)
		Declare Property ArrowKeys As Boolean
		Declare Property ArrowKeys(Value As Boolean)
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Property Thousands As Boolean
		Declare Property Thousands(Value As Boolean)
		Declare Property Wrap As Boolean
		Declare Property Wrap(Value As Boolean)
		Declare Property Style As UpDownOrientation
		Declare Property Style(Value As UpDownOrientation)
		Declare Property UpDownWidth As Integer
		Declare Property UpDownWidth(Value As Integer)
		Declare Sub SelectAll
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnChange As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As NumericUpDown)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "NumericUpDown.bas"
#endif
