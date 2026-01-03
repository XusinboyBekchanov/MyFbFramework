'###############################################################################
'#  ScrollBarControl.bi                                                        #
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

#include once "Control.bi"

Namespace My.Sys.Forms
	#define QScrollBarControl(__Ptr__) (*Cast(ScrollBarControl Ptr,__Ptr__))
	
	Private Enum ScrollBarControlStyle
		sbHorizontal, sbVertical
	End Enum
	
	'`ScrollBarControl` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`ScrollBarControl` - Provides a horizontal and a vertical scroll bar for easy navigation through long lists of items (Windows, Linux).
	Private Type ScrollBarControl Extends Control
	Private:
		FStyle      	As ScrollBarControlStyle
		FMin        	As Integer
		FMax        	As Integer
		FPosition   	As Integer
		FArrowChangeSize 	As Integer
		FPageSize   	As Integer
		AStyle(2)   	As Integer
		#ifndef __USE_GTK__
			SIF         	As SCROLLINFO
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#else
			Declare Static Sub Range_ValueChanged(range As GtkRange Ptr, user_data As Any Ptr)
		#endif
	Protected:
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		#ifndef ReadProperty_Off
			'Loads properties from persistence stream
			Declare Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves properties to persistence stream
			Declare Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property Style As ScrollBarControlStyle
		'Visual style (Flat/Classic/Modern)
		Declare Property Style(Value As ScrollBarControlStyle)
		Declare Property MinValue As Integer
		'Minimum position value of the scroll range
		Declare Property MinValue(Value As Integer)
		Declare Property MaxValue As Integer
		'Maximum position value of the scroll range
		Declare Property MaxValue(Value As Integer)
		Declare Property ArrowChangeSize As Integer
		'Gets/sets the step value when clicking scroll arrows (default 1)
		Declare Property ArrowChangeSize(Value As Integer)
		Declare Property PageSize As Integer
		'Size of the visible portion (affects scroll thumb length)
		Declare Property PageSize(Value As Integer)
		Declare Property Position As Integer
		'Current scroll position within MinValue-MaxValue
		Declare Property Position(Value As Integer)
		Declare Property TabIndex As Integer
		'Controls focus order in tab sequence
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		'Determines if control accepts focus via Tab key
		Declare Property TabStop(Value As Boolean)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		'Raised when scroll position changes
		OnScroll As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ScrollBarControl, ByRef NewPos As Integer)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "ScrollBarControl.bas"
#endif
