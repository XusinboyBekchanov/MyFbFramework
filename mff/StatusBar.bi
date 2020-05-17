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

#Include Once "Control.bi"
#Include Once "Menus.bi"

Namespace My.Sys.Forms
	#DEFINE QStatusBar(__Ptr__) *Cast(StatusBar Ptr, __Ptr__)
	#DEFINE QStatusPanel(__Ptr__) *Cast(StatusPanel Ptr, __Ptr__)
	
	#IfDef __USE_GTK__
		Enum BevelStyle
			pbLowered
			pbNone
			pbRaised
			pbOwnerDraw
			pbRtlReading
			pbNoTabParsing
		End Enum
	#Else
		Enum BevelStyle
			pbLowered    = 0
			pbNone       = SBT_NOBORDERS
			pbRaised     = SBT_POPOUT
			pbOwnerDraw  = SBT_OWNERDRAW
			pbRtlReading = SBT_RTLREADING
			pbNoTabParsing = SBT_NOTABPARSING
		End Enum
	#EndIf
	
	Type StatusPanel Extends My.Sys.Object
	Private:
		FAlignment As Integer
		FCaption   As WString Ptr
		FBevel     As BevelStyle
		FWidth     As Integer
	Public:
		Index      As Integer
		#IfDef __USE_GTK__
			message_id As guint
			label As GtkWidget Ptr
		#EndIf
		StatusBarControl As My.Sys.Forms.Control Ptr
		Declare Property Caption ByRef As WString
		Declare Property Caption(ByRef Value As WString)
		Declare Property Width As Integer
		Declare Property Width(Value As Integer)
		Declare Property Bevel As BevelStyle
		Declare Property Bevel(Value As BevelStyle)
		Declare Property Alignment As Integer
		Declare Property Alignment(Value As Integer)
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
		#IfDef __USE_GTK__
			Dim As guint context_id
		#Else
			Declare Static Sub WndProc(BYREF Message As Message)
			Declare Sub ProcessMessage(BYREF Message As Message)
			Declare Static Sub HandleIsAllocated(BYREF Sender As My.Sys.Forms.Control)
		#EndIf
	Public:
		Count         As Integer
		Font          As My.Sys.Drawing.Font
		Panels        As StatusPanel Ptr Ptr
		Declare Property Panel(Index As Integer) As StatusPanel
		Declare Property Panel(Index As Integer, Value As StatusPanel)
		Declare Property Color As Integer
		Declare Property Color(Value As Integer)
		Declare Property SimpleText ByRef As WString
		Declare Property SimpleText(ByRef Value As WString)
		Declare Property SimplePanel As Boolean
		Declare Property SimplePanel(Value As Boolean)
		Declare Property SizeGrip As Boolean
		Declare Property SizeGrip(Value As Boolean)
		Declare Function Add(ByRef wText As WString) As StatusPanel Ptr
		Declare Sub Remove(Index As Integer)
		Declare Sub Clear
		Declare Sub UpdatePanels
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#IfNDef __USE_MAKE__
	#Include Once "StatusBar.bas"
#EndIf
