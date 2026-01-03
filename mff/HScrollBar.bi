'###############################################################################
'#  HScrollBar.bi                                                              #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TScrollBar.bi                                                             #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "ScrollBarControl.bi"

Namespace My.Sys.Forms
	#define QHScrollBar(__Ptr__) (*Cast(HScrollBar Ptr,__Ptr__))
	
	'`HScrollBar` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`HScrollBar` - Provides a horizontal scroll bar for easy navigation through long lists of items (Windows, Linux).
	Private Type HScrollBar Extends Control
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
			'Loads scroll configuration from stream
			Declare Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves scroll configuration to stream
			Declare Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property MinValue As Integer
		'Minimum allowable scroll position
		Declare Property MinValue(Value As Integer)
		Declare Property MaxValue As Integer
		'Maximum allowable scroll position
		Declare Property MaxValue(Value As Integer)
		Declare Property ArrowChangeSize As Integer
		'Step value when clicking arrow buttons (small change)
		Declare Property ArrowChangeSize(Value As Integer)
		Declare Property TabIndex As Integer
		'Position in tab navigation order
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		'Enables focus via Tab key
		Declare Property TabStop(Value As Boolean)
		Declare Property PageSize As Integer
		'Visible area size (large change step)
		Declare Property PageSize(Value As Integer)
		Declare Property Position As Integer
		'Current thumb position value
		Declare Property Position(Value As Integer)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		'Triggered during thumb position changes
		OnScroll As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As HScrollBar, ByRef NewPos As UInteger)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "HScrollBar.bas"
#endif
