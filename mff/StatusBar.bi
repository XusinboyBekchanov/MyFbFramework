'###############################################################################
'#  StatusBar.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TStatusBar.bi                                                             #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "Control.bi"
#include once "Menus.bi"

Namespace My.Sys.Forms
	#define QStatusBar(__Ptr__) *Cast(StatusBar Ptr, __Ptr__)
	#define QStatusPanel(__Ptr__) *Cast(StatusPanel Ptr, __Ptr__)
	
	#ifdef __USE_GTK__
		Enum BevelStyle
			pbLowered
			pbNone
			pbRaised
			pbOwnerDraw
			pbRtlReading
			pbNoTabParsing
		End Enum
	#else
		Enum BevelStyle
			pbLowered    = 0
			pbNone       = SBT_NOBORDERS
			pbRaised     = SBT_POPOUT
			pbOwnerDraw  = SBT_OWNERDRAW
			pbRtlReading = SBT_RTLREADING
			pbNoTabParsing = SBT_NOTABPARSING
		End Enum
	#endif
	
	Type StatusPanel Extends My.Sys.Object
	Private:
		FAlignment  As Integer
		FCaption    As WString Ptr
		FName       As WString Ptr
		FBevel      As BevelStyle
		FWidth      As Integer
		FRealWidth  As Integer
		StatusBarControl As My.Sys.Forms.Control Ptr
		Declare Static Sub IconChanged(ByRef Sender As My.Sys.Drawing.Icon)
	Public:
		Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Index      As Integer
		#ifdef __USE_GTK__
			message_id As guint
			label As GtkWidget Ptr
		#endif
		Icon As My.Sys.Drawing.Icon
		Declare Property Alignment As Integer
		Declare Property Alignment(Value As Integer)
		Declare Property Bevel As BevelStyle
		Declare Property Bevel(Value As BevelStyle)
		Declare Property Caption ByRef As WString
		Declare Property Caption(ByRef Value As WString)
		Declare Property Name ByRef As WString
		Declare Property Name(ByRef Value As WString)
		Declare Property Parent As Control Ptr
		Declare Property Parent(Value As Control Ptr)
		Declare Property Width As Integer
		Declare Property Width(Value As Integer)
		Declare Property RealWidth As Integer
		Declare Operator Cast As Any Ptr
		Declare Operator Let(ByRef Value As WString)
		Declare Constructor
		Declare Destructor
	End Type
	
	Type StatusBar Extends Control
	Private:
		FSimpleText   As WString Ptr
		FSimplePanel  As Boolean
		FSizeGrip     As Boolean
		AStyle(2)     As Integer
		#ifdef __USE_GTK__
			Dim As guint context_id
		#else
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Virtual Sub ProcessMessage(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#endif
	Public:
		Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Count         As Integer
		'Font          As My.Sys.Drawing.Font
		Panels        As StatusPanel Ptr Ptr
		Declare Property Panel(Index As Integer) As StatusPanel Ptr
		Declare Property Panel(Index As Integer, Value As StatusPanel Ptr)
		Declare Property BackColor As Integer
		Declare Property BackColor(Value As Integer)
		Declare Function IndexOf(ByRef stPanel As StatusPanel Ptr) As Integer
		Declare Property SimpleText ByRef As WString
		Declare Property SimpleText(ByRef Value As WString)
		Declare Property SimplePanel As Boolean
		Declare Property SimplePanel(Value As Boolean)
		Declare Property SizeGrip As Boolean
		Declare Property SizeGrip(Value As Boolean)
		Declare Function Add(ByRef wText As WString) As StatusPanel Ptr
		Declare Sub Add(stPanel As StatusPanel Ptr)
		Declare Sub Remove(Index As Integer)
		Declare Sub Clear
		Declare Sub UpdatePanels
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "StatusBar.bas"
#endif
