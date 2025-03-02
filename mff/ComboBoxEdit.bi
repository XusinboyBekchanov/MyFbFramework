'###############################################################################
'#  ComboBoxEdit.bi                                                            #
'#  This file is part of MyFBFramework                                         #
'#  Based on:                                                                  #
'#   TComboBox.bi                                                              #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "Control.bi"
#include once "WStringList.bi"

Namespace My.Sys.Forms
	#define QComboBoxEdit(__Ptr__) (*Cast(ComboBoxEdit Ptr,__Ptr__))
	
	Private Enum ComboBoxEditStyle
		cbSimple            = 0
		cbDropDown
		cbDropDownList
		cbOwnerDrawFixed
		cbOwnerDrawVariable
	End Enum
	
	'`ComboBoxEdit` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`ComboBoxEdit` - Combines the features of a [[TextBox]] and a [[ListControl]].
	Private Type ComboBoxEdit Extends Control
	Private:
		FSort             As Boolean
		FItemText         As WString Ptr
		FItemHeight       As Integer
		#ifdef __USE_WINAPI__
			FListHandle     As HWND
			FEditHandle     As HWND
			lpfnEditWndProc As Any Ptr
		#endif
		FSelColor         As Integer
		ASortStyle(2)     As Integer
		AIntegralHeight(2) As Integer
		Declare Sub GetChilds
	Protected:
		AStyle(5)         As Integer
		FDropDownCount    As Integer
		FStyle            As Integer
		FIntegralHeight   As Boolean
		FItemIndex        As Integer
		FNewIndex         As Integer
		FSelected         As Boolean
		Declare Virtual Sub UpdateListHeight
		#if defined(__USE_WINAPI__) OrElse defined(__USE_WASM__)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#endif
		#ifdef __USE_WINAPI__
			Declare Static Function WindowProc(FWindow As HWND, msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			Declare Static Function SubClassProc(FWindow As HWND, msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			Declare Virtual Sub SetDark(Value As Boolean)
		#elseif defined(__USE_GTK__)
			Declare Static Sub ComboBoxEdit_Popup(widget As GtkComboBox Ptr, user_data As Any Ptr)
			Declare Static Function ComboBoxEdit_Popdown(widget As GtkComboBox Ptr, user_data As Any Ptr) As Boolean
			Declare Static Sub ComboBoxEdit_Changed(widget As GtkComboBox Ptr, user_data As Any Ptr)
			Declare Static Sub Entry_Activate(entry As GtkEntry Ptr, user_data As Any Ptr)
			DropDownWidget As GtkWidget Ptr
			DropDownListWidget As GtkWidget Ptr
		#elseif defined(__USE_WASM__)
			Declare Virtual Function GetContent() As UString
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		'Collection of list items.
		Items             As WStringList
		#ifndef ReadProperty_Off
			'Loads persisted properties.
			Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Persists properties to storage.
			Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Virtual Property TabIndex As Integer
		'Tab navigation order index.
		Declare Virtual Property TabIndex(Value As Integer)
		Declare Virtual Property TabStop As Boolean
		'Enables Tab key navigation.
		Declare Virtual Property TabStop(Value As Boolean)
		Declare Virtual Property SelColor As Integer
		'Color of selected text.
		Declare Virtual Property SelColor(Value As Integer)
		Declare Virtual Property ItemIndex As Integer
		'Index of currently selected item (-1 if none).
		Declare Virtual Property ItemIndex(Value As Integer)
		Declare Virtual Property ItemHeight As Integer
		'Height of each list item in pixels.
		Declare Virtual Property ItemHeight(Value As Integer)
		Declare Virtual Property ItemCount As Integer
		'Total number of items in list.
		Declare Virtual Property ItemCount(Value As Integer)
		Declare Virtual Property DropDownCount As Integer
		'Maximum visible items in dropdown list.
		Declare Virtual Property DropDownCount(Value As Integer)
		Declare Virtual Property IntegralHeight As Boolean
		'Adjusts height to prevent partial item display.
		Declare Virtual Property IntegralHeight(Value As Boolean)
		Declare Virtual Property Sort As Boolean
		'Enables automatic alphabetical sorting.
		Declare Virtual Property Sort(Value As Boolean)
		Declare Virtual Property Style As ComboBoxEditStyle
		'Display style (Simple/Dropdown/DropdownList).
		Declare Virtual Property Style(Value As ComboBoxEditStyle)
		'Associated data with list items.
		Declare Virtual Property ItemData(FIndex As Integer) As Any Ptr
		'Associated data with list items.
		Declare Virtual Property ItemData(FIndex As Integer, Value As Any Ptr)
		'Access items by index (default property).
		Declare Virtual Property Item(FIndex As Integer) ByRef As WString
		'Access items by index (default property).
		Declare Virtual Property Item(FIndex As Integer, ByRef FItem As WString)
		Declare Virtual Property Text ByRef As WString
		'Editable text content.
		Declare Virtual Property Text(ByRef Value As WString)
		'Appends new item to list.
		Declare Virtual Sub AddItem(ByRef FItem As WString)
		'Deletes item by index.
		Declare Virtual Sub RemoveItem(FIndex As Integer)
		'Inserts item at position.
		Declare Virtual Sub InsertItem(FIndex As Integer, ByRef FItem As WString)
		'Returns item index by text.
		Declare Virtual Function IndexOf(ByRef Item As WString) As Integer
		'Checks if item exists in list.
		Declare Virtual Function Contains(ByRef Item As WString) As Boolean
		'Finds index by associated data.
		Declare Virtual Function IndexOfData(pData As Any Ptr) As Integer
		Declare Virtual Function NewIndex As Integer
		Declare Virtual Sub Clear
		'Opens/closes dropdown list.
		Declare Virtual Sub ShowDropDown(Value As Boolean)
		'Saves items to text file.
		Declare Virtual Sub SaveToFile(ByRef FileName As WString)
		'Loads items from text file.
		Declare Virtual Sub LoadFromFile(ByRef FileName As WString)
		Declare Virtual Sub Undo
		Declare Virtual Sub PasteFromClipboard
		Declare Virtual Sub CopyToClipboard
		Declare Virtual Sub CutToClipboard
		Declare Virtual Sub SelectAll
		Declare Static Sub RegisterClass
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		'Raised when control gains focus.
		OnActivate          As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ComboBoxEdit)
		'Triggered on text/item selection change.
		OnChange            As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ComboBoxEdit)
		'Raised when dropdown opens.
		OnDropDown          As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ComboBoxEdit)
		'Raised when dropdown closes.
		OnCloseUp           As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ComboBoxEdit)
		'Triggered by character input.
		OnKeyPress          As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ComboBoxEdit, Key As Integer, Shift As Integer)
		'Triggered by keyboard key press.
		OnKeyDown           As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ComboBoxEdit, Key As Integer, Shift As Integer)
		'Triggered by keyboard key release.
		OnKeyUp             As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ComboBoxEdit, Key As Integer, Shift As Integer)
		#ifdef __USE_WINAPI__
			'Custom item sizing event.
			OnMeasureItem       As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ComboBoxEdit, ItemIndex As Integer, ByRef Height As UINT)
			'Custom item rendering event.
			OnDrawItem          As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ComboBoxEdit, ItemIndex As Integer, State As Integer, ByRef R As Rect, DC As HDC = 0)
		#endif
		'Triggered after item selection.
		OnSelected          As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ComboBoxEdit, ItemIndex As Integer)
		'Raised when selection aborted.
		OnSelectCanceled    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ComboBoxEdit)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "ComboBoxEdit.bas"
#endif
