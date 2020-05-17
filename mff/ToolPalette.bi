'###############################################################################
'#  ToolPalette.bi                                                             #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TToolBar.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Adapted to ToolPalette and added cross-platform                            #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "ToolBar.bi"

Namespace My.Sys.Forms
	#define QToolGroup(__Ptr__) *Cast(ToolGroup Ptr,__Ptr__)
	#define QToolPalette(__Ptr__) *Cast(ToolPalette Ptr,__Ptr__)
	
	Enum ToolPaletteStyle
		tpsIcons
		tpsText
		tpsBoth
		tpsBothHorizontal
	End Enum
	
	Type ToolGroupButtons
	Private:
		FButtons As List
	Public:
		Parent   As My.Sys.Object Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Item(Index As Integer) As ToolButton Ptr
		Declare Property Item(ByRef Key As WString) As ToolButton Ptr
		Declare Property Item(Index As Integer, Value As ToolButton Ptr)
		Declare Function Add(FStyle As Integer = tbsAutosize, FImageIndex As Integer = -1, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As Integer = tstEnabled) As ToolButton Ptr
		Declare Function Add(FStyle As Integer = tbsAutosize, ByRef ImageKey As WString, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As Integer = tstEnabled) As ToolButton Ptr
		Declare Sub Remove(Index As Integer)
		Declare Function IndexOf(ByRef FButton As ToolButton Ptr) As Integer
		Declare Function IndexOf(ByRef Key As WString) As Integer
		Declare Sub Clear
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	Type ToolGroup Extends My.Sys.Object
	Private:
		FCaption      As WString Ptr
		FExpanded     As Boolean
		FCommandID    As Integer
	Protected:
		FName           As WString Ptr
	Public:
		#ifdef __USE_GTK__
			Widget As GtkWidget Ptr
		#endif
		Tag           As Any Ptr
		Ctrl       As Control Ptr
		Buttons		As ToolGroupButtons
		Declare Function Index As Integer
		Declare Property Caption ByRef As WString
		Declare Property Caption(ByRef Value As WString)
		Declare Property CommandID As Integer
		Declare Property CommandID(Value As Integer)
		Declare Property Name ByRef As WString
		Declare Property Name(ByRef Value As WString)
		Declare Property Expanded As Boolean
		Declare Property Expanded(Value As Boolean)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	Type ToolGroups
	Private:
		FGroups As List
	Public:
		Parent   As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Item(Index As Integer) As ToolGroup Ptr
		Declare Property Item(ByRef Key As WString) As ToolGroup Ptr
		Declare Property Item(Index As Integer, Value As ToolGroup Ptr)
		Declare Function Add(ByRef Caption As WString, ByRef Key As WString = "") As ToolGroup Ptr
		Declare Sub Remove(Index As Integer)
		Declare Function IndexOf(ByRef FToolGroup As ToolGroup Ptr) As Integer
		Declare Function IndexOf(ByRef Key As WString) As Integer
		Declare Sub Clear
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	Type ToolPalette Extends Control
	Private:
		FButtonWidth    As Integer
		FButtonHeight   As Integer
		FColor          As Integer
		FAutosize       As Boolean
		FFlat           As Boolean
		FList           As Boolean
		FDivider        As Boolean
		FVisible        As Boolean
		FEnabled        As Boolean
		FTransparent    As Boolean
		FStyle          As Integer
		FWrapable       As Integer
		ATransparent(2) As Integer
		AFlat(2)        As Integer
		ADivider(2)     As Integer
		AAutosize(2)    As Integer
		AList(2)        As Integer
		AState(6)       As Integer
		AWrap(2)        As Integer
		FButtons        As List
		FImagesList      As ImageList Ptr
		FHotImagesList   As ImageList Ptr
		FDisabledImagesList As ImageList Ptr
		Declare Static Sub WndProc(ByRef Message As Message)
		Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		Declare Static Sub HandleIsDestroyed(ByRef Sender As Control)
		Declare Sub ProcessMessage(ByRef Message As Message)
		Declare Sub GetDropDownMenuItems
	Public:
		Groups          As ToolGroups
		Declare Property ImagesList As ImageList Ptr
		Declare Property ImagesList(Value As ImageList Ptr)
		Declare Property HotImagesList As ImageList Ptr
		Declare Property HotImagesList(Value As ImageList Ptr)
		Declare Property DisabledImagesList As ImageList Ptr
		Declare Property DisabledImagesList(Value As ImageList Ptr)
		Declare Property AutoSize As Boolean
		Declare Property AutoSize(Value As Boolean)
		Declare Property Flat As Boolean
		Declare Property Flat(Value As Boolean)
		Declare Property List As Boolean
		Declare Property List(Value As Boolean)
		Declare Property Wrapable As Boolean
		Declare Property Wrapable(Value As Boolean)
		Declare Property Transparency As Boolean
		Declare Property Transparency(Value As Boolean)
		Declare Property Divider As Boolean
		Declare Property Divider(Value As Boolean)
		Declare Property Style As Integer
		Declare Property Style(Value As Integer)
		Declare Property ButtonWidth As Integer
		Declare Property ButtonWidth(Value As Integer)
		Declare Property ButtonHeight As Integer
		Declare Property ButtonHeight(Value As Integer)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnButtonClick As Sub(BYREF Sender As ToolPalette,BYREF Button As ToolButton)
	End Type
End Namespace

#IfNDef __USE_MAKE__
	#Include Once "ToolPalette.bas"
#EndIf
