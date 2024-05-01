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
#include once "WStringList.bi"

Namespace My.Sys.Forms
	#define QListControl(__Ptr__) (*Cast(ListControl Ptr, __Ptr__))
	
	Private Enum ListControlStyle
		lbNormal = 0
		lbOwnerDrawFixed
		lbOwnerDrawVariable
	End Enum
	
	Private Enum SelectionModes
		smNone = 0
		smOne
		smMultiSimple
		smMultiExtended
	End Enum
	
	'Displays a list of items from which the user can select one or more.
	Private Type ListControl Extends Control
	Private:
		#ifdef __USE_WINAPI__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#elseif defined(__USE_GTK__)
			Declare Static Sub SelectionChanged(selection As GtkTreeSelection Ptr, user_data As Any Ptr)
		#elseif defined(__USE_WASM__)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#endif
	Protected:
		FNewIndex         As Integer
		FStyle            As Integer
		FSort             As Boolean
		FSelCount         As Integer
		FSelItems         As Integer Ptr
		FTopIndex         As Integer
		FItemIndex        As Integer
		FItemHeight       As Integer
		FMultiselect      As Boolean
		FExtendSelect     As Boolean
		FMultiColumn      As Boolean
		FIntegralHeight   As Boolean
		FHorizontalScrollBar As Boolean
		FVerticalScrollBar   As Boolean
		FCtl3D            As Boolean
		FSelectionMode    As SelectionModes
		AItems(Any)       As Integer 
		#ifdef __USE_GTK__
			ListStore As GtkListStore Ptr
			TreeSelection As GtkTreeSelection Ptr
		#elseif defined(__USE_WASM__)
			Declare Virtual Function GetContent() As UString
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		Items             As WStringList
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property Style As ListControlStyle
		Declare Property Style(Value As ListControlStyle)
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
		Declare Property Selected(Index As Integer) As Boolean
		Declare Property Selected(Index As Integer, Value As Boolean)
		Declare Property SelectionMode As SelectionModes
		Declare Property SelectionMode(Value As SelectionModes)
		Declare Property Sort As Boolean
		Declare Property Sort(Value As Boolean)
		Declare Property HorizontalScrollBar As Boolean
		Declare Property HorizontalScrollBar(Value As Boolean)
		Declare Property VerticalScrollBar As Boolean
		Declare Property VerticalScrollBar(Value As Boolean)
		Declare Property IntegralHeight As Boolean
		Declare Property IntegralHeight(Value As Boolean)
		Declare Property MultiColumn As Boolean
		Declare Property MultiColumn(Value As Boolean)
		Declare Property ItemData(FIndex As Integer) As Any Ptr
		Declare Property ItemData(FIndex As Integer, Obj As Any Ptr)
		Declare Property Item(FIndex As Integer) ByRef As WString
		Declare Property Item(FIndex As Integer, ByRef FItem As WString)
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Operator Cast As Control Ptr
		Declare Sub AddItem(ByRef FItem As WString, Obj As Any Ptr = 0)
		Declare Sub RemoveItem(FIndex As Integer)
		Declare Sub InsertItem(FIndex As Integer, ByRef FItem As WString, Obj As Any Ptr = 0)
		Declare Function IndexOf(ByRef Item As WString) As Integer
		Declare Function IndexOfData(Obj As Any Ptr) As Integer
		Declare Function NewIndex As Integer
		Declare Sub SelectAll
		Declare Sub UnSelectAll
		Declare Sub Clear
		Declare Sub SaveToFile(ByRef FileName As WString)
		Declare Sub LoadFromFile(ByRef FileName As WString)
		Declare Constructor
		Declare Destructor
		OnChange      As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ListControl)
		#ifdef __USE_WINAPI__
			OnMeasureItem As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ListControl, ItemIndex As Integer, ByRef Height As UINT)
			OnDrawItem    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ListControl, ItemIndex As Integer, State As Integer, ByRef R As My.Sys.Drawing.Rect, DC As HDC = 0)
		#endif
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "ListControl.bas"
#endif
