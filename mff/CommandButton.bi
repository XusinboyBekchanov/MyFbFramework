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

#define QCommandButton(__Ptr__) *Cast(CommandButton Ptr,__Ptr__)

#include once "Control.bi"
#include once "Graphic.bi"
#include once "List.bi"

Private Enum ButtonStyle
	bsText, bsBitmap, bsIcon, bsCursor, bsOwnerDraw
End Enum

Namespace My.Sys.Forms
	Private Type CommandButton Extends Control
	Private:
		FStyle      As ButtonStyle
		FDefault    As Boolean
		FImageType  As Integer
		AStyle(4)   As Integer
		ADefault(2) As Integer
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef message As message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#else
			Declare Static Sub Clicked(widget As GtkButton Ptr, user_data As Any Ptr)
		#endif
		Declare Static Sub GraphicChange(ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
		Declare Function EnumMenuItems(Item As MenuItem, ByRef List As List) As Boolean
	Protected:
		Declare Virtual Sub ProcessMessage(ByRef message As message)
	Public:
		Graphic     As My.Sys.Drawing.GraphicType
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property Caption ByRef As WString
		Declare Property Caption(ByRef Value As WString)
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Property Default As Boolean
		Declare Property Default(Value As Boolean)
		Declare Property Style As ButtonStyle
		Declare Property Style(Value As ButtonStyle)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		#ifdef __USE_WINAPI__
			OnDraw  As Sub(ByRef Sender As CommandButton, ByRef R As Rect, DC As HDC = 0)
		#endif
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "CommandButton.bas"
#endif
