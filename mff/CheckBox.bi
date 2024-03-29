﻿'################################################################################
'#  CheckBox.bi                                                                 #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                      #
'#  Based on:                                                                   #
'#   TCheckBox.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                              #
'#   Copyright (c) 2007-2008 Nastase Eodor                                      #
'#   Version 1.0.0                                                              #
'#  Updated and added cross-platform                                            #
'#  by Xusinboy Bekchanov (2018-2019)                                           #
'################################################################################

#include once "Control.bi"

Namespace My.Sys.Forms
	#define QCheckBox(__Ptr__) (*Cast(CheckBox Ptr,__Ptr__))
	
	'Displays an V when selected; the V disappears when the CheckBox is cleared.
	Private Type CheckBox Extends Control
	Private:
		FAlignment  As Integer
		FChecked    As Boolean
		#ifdef __USE_WINAPI__
			Declare Static Sub WndProc(ByRef Message As Message)
		#elseif defined(__USE_GTK__)
			Declare Static Sub CheckBox_Toggled(widget As GtkToggleButton Ptr, user_data As Any Ptr)
		#endif
		Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
	Protected:
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		#ifdef __USE_WASM__
			Declare Virtual Function GetContent() As UString
		#endif
	Public:
		#ifndef ReadProperty_Off
			Declare Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property AutoSize As Boolean
		Declare Property AutoSize(Value As Boolean)
		Declare Property Alignment As CheckAlignmentConstants
		Declare Property Alignment(Value As CheckAlignmentConstants)
		Declare Property Caption ByRef As WString
		Declare Property Caption(ByRef Value As WString)
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Property Checked As Boolean
		Declare Property Checked(Value As Boolean)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As CheckBox)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "CheckBox.bas"
#endif
