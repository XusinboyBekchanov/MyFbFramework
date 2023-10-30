'###############################################################################
'#  Splitter.bi                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TSplitter.bi                                                              #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "Control.bi"

Namespace My.Sys.Forms
	#define QSplitter(__Ptr__) (*Cast(Splitter Ptr, __Ptr__))
	
	Private Enum SplitterAlignmentConstants
		alNone
		alLeft
		alRight
		alTop
		alBottom
	End Enum
	
	'Represents a splitter control that enables the user to resize docked controls.
	Private Type Splitter Extends Control
	Private:
		FOldParentProc  As Any Ptr
		#ifndef __USE_GTK__
			Declare Static Sub ParentWndProc(ByRef Message As Message)
			Declare Static Sub WndProc(ByRef Message As Message)
		#endif
	Protected:
		Declare Sub DrawTrackSplit(x As Integer, y As Integer)
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		#ifndef ReadProperty_Off
			Declare Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		#ifdef __USE_GTK__
			Dim As Boolean bCursor
		#endif
		MinExtra As Integer
		Declare Operator Cast As Control Ptr
		Declare Property Align As SplitterAlignmentConstants
		Declare Property Align(Value As SplitterAlignmentConstants)
		OnPaint As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Splitter)
		OnMoving As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Splitter)
		OnMoved As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Splitter)
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "Splitter.bas"
#endif
