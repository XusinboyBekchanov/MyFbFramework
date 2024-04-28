'###############################################################################
'#  CommandButton.bi                                                           #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TButton.bi                                                                #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#define QCommandButton(__Ptr__) (*Cast(CommandButton Ptr,__Ptr__))

#include once "Control.bi"
#include once "Graphic.bi"
#include once "List.bi"

Private Enum ButtonStyle
	bsText, bsBitmap, bsIcon, bsCursor, bsOwnerDraw
End Enum

Namespace My.Sys.Forms
	'Looks like a push button and is used to begin, interrupt, or end a process.
	Private Type CommandButton Extends Control
	Private:
		FStyle      As ButtonStyle
		FCancel     As Boolean
		FDefault    As Boolean
		FImageType  As Integer
		AStyle(4)   As Integer
		ADefault(2) As Integer
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#else
			Declare Static Sub Clicked(widget As GtkButton Ptr, user_data As Any Ptr)
		#endif
		Declare Static Sub GraphicChange(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
		Declare Function EnumMenuItems(Item As MenuItem, ByRef List As List) As Boolean
	Protected:
		Declare Virtual Sub ProcessMessage(ByRef message As Message)
	Public:
		'Returns/sets a graphic to be displayed in a control (Windows only).
		Graphic     As My.Sys.Drawing.GraphicType
		#ifndef ReadProperty_Off
			'Reads value from the name of property (Windows, Linux, Android, Web).
			Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Writes value to the name of property (Windows, Linux, Android, Web).
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Indicates whether a command button is the Cancel button on a form (Windows only).
		Declare Property Cancel As Boolean
		Declare Property Cancel(Value As Boolean)
		'Returns/sets the caption of the control (Windows, Linux, Android, Web).
		Declare Property Caption ByRef As WString
		Declare Property Caption(ByRef Value As WString)
		'Returns/sets the tab order of an object within its parent form (Windows only).
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		'Returns/sets a value indicating whether a user can use the TAB key to give the focus to an object (Windows only).
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		'Returns/sets the text contained in the control (Windows, Linux, Android, Web).
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		'Determines which CommandButton control is the default command button on a form (Windows, Linux).
		Declare Property Default As Boolean
		Declare Property Default(Value As Boolean)
		'Returns/sets the appearance of the control, whether standard or graphical (with a custom picture) (Windows only).
		Declare Property Style As ButtonStyle
		Declare Property Style(Value As ButtonStyle)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		#ifdef __USE_WINAPI__
			'Occurs when any part of a CommandButton is moved, enlarged, or exposed.
			OnDraw  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As CommandButton, ByRef R As Rect, DC As HDC = 0)
		#endif
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "CommandButton.bas"
#endif
