'###############################################################################
'#  RadioButton.bi                                                             #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TRadioButton.bi                                                           #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.2.2                                                            #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "Control.bi"

Namespace My.Sys.Forms
	#define QRadioButton(__Ptr__) (*Cast(RadioButton Ptr,__Ptr__))
	
	Private Type RadioButton Extends Control
	Private:
		FAlignment  As Integer
		FChecked    As Boolean
		#ifdef __USE_WINAPI__
			Declare Static Sub WndProc(ByRef Message As Message)
		#endif
		Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
	Protected:
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		#ifndef ReadProperty_Off
			Declare Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property Alignment As CheckAlignmentConstants
		Declare Property Alignment(Value As CheckAlignmentConstants)
		Declare Property Caption ByRef As WString
		Declare Property Caption(ByRef Value As WString)
		Declare Property Parent As Control Ptr
		Declare Property Parent(Value As Control Ptr)
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Property Checked As Boolean
		Declare Property Checked(Value As Boolean)
		Declare Property Grouped As Boolean
		Declare Property Grouped(Value As Boolean)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnClick As Sub(ByRef Sender As RadioButton)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "RadioButton.bas"
#endif
