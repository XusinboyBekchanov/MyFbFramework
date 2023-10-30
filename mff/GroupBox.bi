'###############################################################################
'#  GroupBox.bi                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TGroupBox.bi                                                              #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "ContainerControl.bi"

Namespace My.Sys.Forms
	#define QGroupBox(__Ptr__) (*Cast(GroupBox Ptr,__Ptr__))
	
	'Provides an identifiable grouping for controls.
	Private Type GroupBox Extends ContainerControl
	Private:
		FParentColor As Integer
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#endif
	Protected:
		#ifdef __USE_WASM__
			Declare Virtual Function GetContent() As UString
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		#ifndef ReadProperty_Off
			Declare Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property Caption ByRef As WString
		Declare Property Caption(ByRef Value As WString)
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Property ParentColor As Boolean
		Declare Property ParentColor(Value As Boolean)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GroupBox)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "GroupBox.bas"
#endif
