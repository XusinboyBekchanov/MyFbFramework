'###############################################################################
'#  ListControl.bi                                                             #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TListBox.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "Control.bi"
#include once "ListItems.bi"

Namespace My.Sys.Forms
	#define QListControl(__Ptr__) *Cast(ListControl Ptr,__Ptr__)
	
	Enum ListControlStyle
		lbNormal = 0
		lbOwnerDrawFixed
		lbOwnerDrawVariable
	End Enum
	
	Type ListControl Extends Control
	Private:
		FStyle            As Integer
		FBorderStyle      As Integer
		FSort             As Boolean
		FSelCount         As Integer
		FSelItems         As Integer Ptr
		FTopIndex         As Integer
		FItemIndex        As Integer
		FItemHeight       As Integer
		FMultiselect      As Boolean
		FExtendSelect     As Boolean
		FColumns          As Integer
		FIntegralHeight   As Boolean
		FCtl3D            As Boolean
		ABorderStyle(3)   As Integer
		ABorderExStyle(2) As Integer
		AStyle(3)         As Integer
		ASortStyle(2)     As Integer
		AMultiselect(2)   As Integer
		AExtendSelect(2)  As Integer
		AMultiColumns(2)  As Integer
		AIntegralHeight(2)As Integer
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#else
			#ifdef __USE_GTK3__
				Declare Static Sub SelectionChanged(box As GtkListBox Ptr, user_data As Any Ptr)
			#else
				Declare Static Sub ListItem_Selected(Item1 As GtkItem Ptr, user_data As Any Ptr)
				Declare Static Sub SelectionChanged(list As GtkList Ptr, user_data As Any Ptr)
			#endif
		#endif
		Declare Sub ProcessMessage(ByRef Message As Message)
	Public:
		Items             As ListItems
		Declare Property Style As ListControlStyle
		Declare Property Style(Value As ListControlStyle)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		Declare Property BorderStyle As Integer
		Declare Property BorderStyle(Value As Integer)
		Declare Property Ctl3D As Boolean
		Declare Property Ctl3D(Value As Boolean)
		Declare Property ItemIndex As Integer
		Declare Property ItemIndex(Value As Integer)
		Declare Property TopIndex As Integer
		Declare Property TopIndex(Value As Integer)
		Declare Property ItemHeight As Integer
		Declare Property ItemHeight(Value As Integer)
		Declare Property ItemCount As Integer
		Declare Property ItemCount(Value As Integer)
		Declare Property SelCount As Integer
		Declare Property SelCount(Value As Integer)
		Declare Property SelItems As Integer Ptr
		Declare Property SelItems(Value As Integer Ptr)
		Declare Property Sort As Boolean
		Declare Property Sort(Value As Boolean)
		Declare Property MultiSelect As Boolean
		Declare Property MultiSelect(Value As Boolean)
		Declare Property ExtendSelect As Boolean
		Declare Property ExtendSelect(Value As Boolean)
		Declare Property IntegralHeight As Boolean
		Declare Property IntegralHeight(Value As Boolean)
		Declare Property Columns As Integer
		Declare Property Columns(Value As Integer)
		Declare Property Object(FIndex As Integer) As Any Ptr
		Declare Property Object(FIndex As Integer, Obj As Any Ptr)
		Declare Property Item(FIndex As Integer) ByRef As WString
		Declare Property Item(FIndex As Integer, ByRef FItem As WString)
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Operator Cast As Control Ptr
		Declare Sub AddItem(ByRef FItem As WString)
		Declare Sub AddObject(ByRef ObjName As WString, Obj As Any Ptr)
		Declare Sub RemoveItem(FIndex As Integer)
		Declare Sub InsertItem(FIndex As Integer, ByRef FItem As WString)
		Declare Sub InsertObject(FIndex As Integer, ByRef ObjName As WString, Obj As Any Ptr)
		Declare Function IndexOf(ByRef Item As WString) As Integer
		Declare Function IndexOfObject(Obj As Any Ptr) As Integer
		Declare Sub Clear
		Declare Sub SaveToFile(ByRef File As WString)
		Declare Sub LoadFromFile(ByRef File As WString)
		Declare Constructor
		Declare Destructor
		OnChange      As Sub(ByRef Sender As ListControl)
		OnDblClick    As Sub(ByRef Sender As ListControl)
		OnKeyPress    As Sub(ByRef Sender As ListControl, Key As Byte, Shift As Integer)
		OnKeyDown     As Sub(ByRef Sender As ListControl, Key As Integer, Shift As Integer)
		OnKeyUp       As Sub(ByRef Sender As ListControl, Key As Integer, Shift As Integer)
		#ifndef __USE_GTK__
			OnMeasureItem As Sub(ByRef Sender As ListControl, ItemIndex As Integer, ByRef Height As UInt)
			OnDrawItem    As Sub(ByRef Sender As ListControl, ItemIndex As Integer, State As Integer,ByRef R As Rect,DC As HDC = 0)
		#endif
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "ListControl.bas"
#endif
