'###############################################################################
'#  CheckedListBox.bi                                                          #
'#  This file is part of MyFBFramework                                         #
'#  Based on:                                                                  #
'#   TListBox.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Modified by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                      #
'###############################################################################

#include once "Control.bi"
#include once "WStringList.bi"

Namespace My.Sys.Forms
	#define QCheckedListBox(__Ptr__) *Cast(CheckedListBox Ptr,__Ptr__)
	
	Type CheckedListBox Extends Control
	Private:
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
			Declare Virtual Sub ProcessMessage(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#endif
	Protected:
		#ifdef __USE_GTK__
			ListStore As GtkListStore Ptr
			TreeSelection As GtkTreeSelection Ptr
		#endif
	Public:
		Items             As WStringList
		Declare Function ReadProperty(PropertyName As String) As Any Ptr
		Declare Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Declare Property BorderStyle As Integer
		Declare Property BorderStyle(Value As Integer)
		Declare Property Checked(Index As Integer) As Boolean
		Declare Property Checked(Index As Integer, Value As Boolean)
		Declare Property Ctl3D As Boolean
		Declare Property Ctl3D(Value As Boolean)
		Declare Property ItemIndex As Integer
		Declare Property ItemIndex(Value As Integer)
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
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
		Declare Property ItemData(FIndex As Integer) As Any Ptr
		Declare Property ItemData(FIndex As Integer, Obj As Any Ptr)
		Declare Property Item(FIndex As Integer) ByRef As WString
		Declare Property Item(FIndex As Integer, ByRef FItem As WString)
		Declare Property Selected(Index As Integer) As Boolean
		Declare Property Selected(Index As Integer, Value As Boolean)
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Operator Cast As Control Ptr
		Declare Sub AddItem(ByRef FItem As WString, Obj As Any Ptr = 0)
		Declare Sub RemoveItem(FIndex As Integer)
		Declare Sub InsertItem(FIndex As Integer, ByRef FItem As WString, Obj As Any Ptr = 0)
		Declare Function IndexOf(ByRef Item As WString) As Integer
		Declare Function IndexOfData(Obj As Any Ptr) As Integer
		Declare Sub Clear
		Declare Sub SaveToFile(ByRef File As WString)
		Declare Sub LoadFromFile(ByRef File As WString)
		Declare Constructor
		Declare Destructor
		OnChange      As Sub(ByRef Sender As CheckedListBox)
		OnDblClick    As Sub(ByRef Sender As CheckedListBox)
		OnKeyPress    As Sub(ByRef Sender As CheckedListBox, Key As Byte, Shift As Integer)
		OnKeyDown     As Sub(ByRef Sender As CheckedListBox, Key As Integer, Shift As Integer)
		OnKeyUp       As Sub(ByRef Sender As CheckedListBox, Key As Integer, Shift As Integer)
		#ifndef __USE_GTK__
			OnMeasureItem As Sub(ByRef Sender As CheckedListBox, ItemIndex As Integer, ByRef Height As UInt)
			OnDrawItem    As Sub(ByRef Sender As CheckedListBox, ItemIndex As Integer, State As Integer,ByRef R As Rect, DC As HDC = 0)
		#endif
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "CheckedListBox.bas"
#endif
