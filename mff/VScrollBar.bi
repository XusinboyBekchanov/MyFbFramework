'###############################################################################
'#  VScrollBar.bi                                                              #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TScrollBar.bi                                                             #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "ScrollBarControl.bi"

Namespace My.Sys.Forms
	#define QVScrollBar(__Ptr__) (*Cast(VScrollBar Ptr,__Ptr__))
	
	'`VScrollBar` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`VScrollBar` - Provides a vertical scroll bar.
	Private Type VScrollBar Extends Control
	Private:
		FMin            As Integer
		FMax            As Integer
		FPosition       As Integer
		FArrowChangeSize     As Integer
		FPageSize       As Integer
		#ifndef __USE_GTK__
			SIF             As SCROLLINFO
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#else
			Declare Static Sub Range_ValueChanged(range As GtkRange Ptr, user_data As Any Ptr)
		#endif
	Protected:
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		#ifndef ReadProperty_Off
			'Reads property value from persistence stream
			Declare Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Writes property value to persistence stream
			Declare Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property MinValue As Integer
		'Gets/sets the minimum scroll position value
		Declare Property MinValue(Value As Integer)
		Declare Property MaxValue As Integer
		'Gets/sets the maximum scroll position value
		Declare Property MaxValue(Value As Integer)
		Declare Property ArrowChangeSize As Integer
		'Gets/sets the increment value when clicking arrow buttons
		Declare Property ArrowChangeSize(Value As Integer)
		Declare Property PageSize As Integer
		'Gets/sets the visible area size represented by scrollbar thumb
		Declare Property PageSize(Value As Integer)
		Declare Property Position As Integer
		'Gets/sets the current scroll position value
		Declare Property Position(Value As Integer)
		Declare Property TabIndex As Integer
		'Gets/sets the tab order of the control
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		'Determines if control can receive focus via Tab key
		Declare Property TabStop(Value As Boolean)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		'Triggered when scroll position changes
		OnScroll As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As VScrollBar, ByRef NewPos As UInteger)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "VScrollBar.bas"
#endif
