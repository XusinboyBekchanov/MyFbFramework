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
	
	'`ListControl` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`ListControl` - Displays a list of items from which the user can select one or more (Windows, Linux, Web).
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
		'Collection of list items
		Items             As WStringList
		#ifndef ReadProperty_Off
			'Loads persisted properties
			Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Persists properties to storage
			Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property Style As ListControlStyle
		'Visual style (Standard/OwnerDraw)
		Declare Property Style(Value As ListControlStyle)
		Declare Property Ctl3D As Boolean
		'Determines if control uses 3D border style
		Declare Property Ctl3D(Value As Boolean)
		Declare Property ItemIndex As Integer
		'Index of selected item (-1 if none)
		Declare Property ItemIndex(Value As Integer)
		Declare Property TabIndex As Integer
		'Tab navigation order index
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		'Enables Tab key navigation
		Declare Property TabStop(Value As Boolean)
		Declare Property TopIndex As Integer
		'Index of first visible item
		Declare Property TopIndex(Value As Integer)
		Declare Property ItemHeight As Integer
		'Height of individual items
		Declare Property ItemHeight(Value As Integer)
		Declare Property ItemCount As Integer
		'Total items in the list
		Declare Property ItemCount(Value As Integer)
		Declare Property SelCount As Integer
		'Number of selected items
		Declare Property SelCount(Value As Integer)
		Declare Property SelItems As Integer Ptr
		'Collection of selected items
		Declare Property SelItems(Value As Integer Ptr)
		'Selection state of specific item
		Declare Property Selected(Index As Integer) As Boolean
		'Selection state of specific item
		Declare Property Selected(Index As Integer, Value As Boolean)
		Declare Property SelectionMode As SelectionModes
		'Selection behavior (Single/Multi)
		Declare Property SelectionMode(Value As SelectionModes)
		Declare Property Sort As Boolean
		'Enables automatic alphabetical sorting
		Declare Property Sort(Value As Boolean)
		Declare Property HorizontalScrollBar As Boolean
		'Controls horizontal scrollbar visibility
		Declare Property HorizontalScrollBar(Value As Boolean)
		Declare Property VerticalScrollBar As Boolean
		'Controls vertical scrollbar visibility
		Declare Property VerticalScrollBar(Value As Boolean)
		Declare Property IntegralHeight As Boolean
		'Auto-adjusts height to avoid partial items
		Declare Property IntegralHeight(Value As Boolean)
		Declare Property MultiColumn As Boolean
		'Enables multi-column display mode
		Declare Property MultiColumn(Value As Boolean)
		'Associated data for items
		Declare Property ItemData(FIndex As Integer) As Any Ptr
		'Associated data for items
		Declare Property ItemData(FIndex As Integer, Obj As Any Ptr)
		'Accesses item by index
		Declare Property Item(FIndex As Integer) ByRef As WString
		'Accesses item by index
		Declare Property Item(FIndex As Integer, ByRef FItem As WString)
		Declare Property Text ByRef As WString
		'Text of selected item
		Declare Property Text(ByRef Value As WString)
		Declare Operator Cast As Control Ptr
		'Adds new item to the list
		Declare Sub AddItem(ByRef FItem As WString, Obj As Any Ptr = 0)
		'Removes item by index
		Declare Sub RemoveItem(FIndex As Integer)
		'Inserts item at specified position
		Declare Sub InsertItem(FIndex As Integer, ByRef FItem As WString, Obj As Any Ptr = 0)
		'Finds index of specified text
		Declare Function IndexOf(ByRef Item As WString) As Integer
		'Finds index by associated data
		'Finds index of specified text
		Declare Function IndexOfData(Obj As Any Ptr) As Integer
		'Gets index for newly added item
		Declare Function NewIndex As Integer
		'Selects all items in multi-select mode
		Declare Sub SelectAll
		'Clears all selections
		Declare Sub UnSelectAll
		'Removes all items
		Declare Sub Clear
		'Saves items to text file
		Declare Sub SaveToFile(ByRef FileName As WString)
		'Loads items from text file
		Declare Sub LoadFromFile(ByRef FileName As WString)
		Declare Constructor
		Declare Destructor
		'Raised when selection changes
		OnChange      As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ListControl)
		#ifdef __USE_WINAPI__
			'Custom item size measurement event
			OnMeasureItem As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ListControl, ItemIndex As Integer, ByRef Height As UINT)
			'Custom item painting event
			OnDrawItem    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ListControl, ItemIndex As Integer, State As Integer, ByRef R As My.Sys.Drawing.Rect, DC As HDC = 0)
		#endif
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "ListControl.bas"
#endif