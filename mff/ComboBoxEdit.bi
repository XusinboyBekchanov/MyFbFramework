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
	
	Private Type ComboBoxEdit Extends Control
	Private:
		FSort             As Boolean
		FItemText         As WString Ptr
		FItemHeight       As Integer
		#ifndef __USE_GTK__
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
		FSelected         As Boolean
		Declare Virtual Sub UpdateListHeight
		#ifndef __USE_GTK__
			Declare Static Function WindowProc(FWindow As HWND, MSG As UINT, WPARAM As WPARAM, LPARAM As LPARAM) As LRESULT
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			Declare Static Function SUBCLASSPROC(FWindow As HWND, MSG As UINT, WPARAM As WPARAM, LPARAM As LPARAM) As LRESULT
			Declare Virtual Sub SetDark(Value As Boolean)
		#else
			Declare Static Sub ComboBoxEdit_Popup(widget As GtkComboBox Ptr, user_data As Any Ptr)
			Declare Static Function ComboBoxEdit_Popdown(widget As GtkComboBox Ptr, user_data As Any Ptr) As Boolean
			Declare Static Sub ComboBoxEdit_Changed(widget As GtkComboBox Ptr, user_data As Any Ptr)
			Declare Static Sub Entry_Activate(entry As GtkEntry Ptr, user_data As Any Ptr)
			DropDownWidget As GtkWidget Ptr
			DropDownListWidget As GtkWidget Ptr
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
		Declare Virtual Property TabIndex As Integer
		Declare Virtual Property TabIndex(Value As Integer)
		Declare Virtual Property TabStop As Boolean
		Declare Virtual Property TabStop(Value As Boolean)
		Declare Virtual Property SelColor As Integer
		Declare Virtual Property SelColor(Value As Integer)
		Declare Virtual Property ItemIndex As Integer
		Declare Virtual Property ItemIndex(Value As Integer)
		Declare Virtual Property ItemHeight As Integer
		Declare Virtual Property ItemHeight(Value As Integer)
		Declare Virtual Property ItemCount As Integer
		Declare Virtual Property ItemCount(Value As Integer)
		Declare Virtual Property DropDownCount As Integer
		Declare Virtual Property DropDownCount(Value As Integer)
		Declare Virtual Property IntegralHeight As Boolean
		Declare Virtual Property IntegralHeight(Value As Boolean)
		Declare Virtual Property Sort As Boolean
		Declare Virtual Property Sort(Value As Boolean)
		Declare Virtual Property Style As ComboBoxEditStyle
		Declare Virtual Property Style(Value As ComboBoxEditStyle)
		Declare Virtual Property ItemData(FIndex As Integer) As Any Ptr
		Declare Virtual Property ItemData(FIndex As Integer, Value As Any Ptr)
		Declare Virtual Property Item(FIndex As Integer) ByRef As WString
		Declare Virtual Property Item(FIndex As Integer, ByRef FItem As WString)
		Declare Virtual Property Text ByRef As WString
		Declare Virtual Property Text(ByRef Value As WString)
		Declare Virtual Sub AddItem(ByRef FItem As WString)
		Declare Virtual Sub RemoveItem(FIndex As Integer)
		Declare Virtual Sub InsertItem(FIndex As Integer, ByRef FItem As WString)
		Declare Virtual Function IndexOf(ByRef Item As WString) As Integer
		Declare Virtual Function Contains(ByRef Item As WString) As Boolean
		Declare Virtual Function IndexOfData(pData As Any Ptr) As Integer
		Declare Virtual Sub Clear
		Declare Virtual Sub ShowDropDown(Value As Boolean)
		Declare Virtual Sub SaveToFile(ByRef FileName As WString)
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
		OnActivate          As Sub(ByRef Sender As ComboBoxEdit)
		OnChange            As Sub(ByRef Sender As ComboBoxEdit)
		OnDropDown          As Sub(ByRef Sender As ComboBoxEdit)
		OnCloseUp           As Sub(ByRef Sender As ComboBoxEdit)
		OnKeyPress          As Sub(ByRef Sender As ComboBoxEdit, Key As Integer, Shift As Integer)
		OnKeyDown           As Sub(ByRef Sender As ComboBoxEdit, Key As Integer, Shift As Integer)
		OnKeyUp             As Sub(ByRef Sender As ComboBoxEdit, Key As Integer, Shift As Integer)
		#ifndef __USE_GTK__
			OnMeasureItem       As Sub(ByRef Sender As ComboBoxEdit, ItemIndex As Integer, ByRef Height As UINT)
			OnDrawItem          As Sub(ByRef Sender As ComboBoxEdit, ItemIndex As Integer, State As Integer, ByRef R As Rect, DC As HDC = 0)
		#endif
		OnSelected          As Sub(ByRef Sender As ComboBoxEdit, ItemIndex As Integer)
		OnSelectCanceled    As Sub(ByRef Sender As ComboBoxEdit)
	End Type
	
	#ifdef __USE_GTK__
		Declare Sub ComboBoxEdit_Popup(widget As GtkComboBox Ptr, user_data As Any Ptr)
		
		Declare Function ComboBoxEdit_Popdown(widget As GtkComboBox Ptr, user_data As Any Ptr) As Boolean
		
		Declare Sub ComboBoxEdit_Changed(widget As GtkComboBox Ptr, user_data As Any Ptr)
	#endif
End Namespace

#ifndef __USE_MAKE__
	#include once "ComboBoxEdit.bas"
#endif
