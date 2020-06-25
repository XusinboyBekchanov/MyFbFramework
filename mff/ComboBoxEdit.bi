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
#include once "ListItems.bi"

Namespace My.Sys.Forms
	#define QComboBoxEdit(__Ptr__) *Cast(ComboBoxEdit Ptr,__Ptr__)
	
	Enum ComboBoxEditStyle
		cbSimple            = 0
		cbDropDown
		cbDropDownList
		cbOwnerDrawFixed
		cbOwnerDrawVariable
	End Enum
	
	Type ComboBoxEdit Extends Control
	Private:
		FSort             As Boolean
		FItemText         As WString Ptr
		FItemHeight       As Integer
		FDropDownCount    As Integer
		FIntegralHeight   As Boolean
		#ifndef __USE_GTK__
			FListHandle     As HWND
			FEditHandle     As HWND
			lpfnEditWndProc As Any Ptr
		#endif
		FSelColor         As Integer
		AStyle(5)         As Integer
		ASortStyle(2)     As Integer
		AIntegralHeight(2)As Integer
		Declare Sub GetChilds
		Declare Sub UpdateListHeight
		#ifdef __USE_GTK__
			Declare Static Sub Entry_Activate(entry As GtkEntry Ptr, user_data As Any Ptr)
		#else
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			Declare Static Function SubClassProc(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
		#endif
	Protected:
		FStyle            As Integer
		FItemIndex        As Integer
		#ifndef __USE_GTK__
			Declare Static Function WindowProc(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
		#endif
		Declare Sub ProcessMessage(ByRef Message As Message)
	Public:
		#ifdef __USE_GTK__
			DropDownWidget As GtkWidget Ptr
			DropDownListWidget As GtkWidget Ptr
		#endif
		Items             As ListItems
		Declare Function ReadProperty(PropertyName As String) As Any Ptr
		Declare Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Declare Property Style As ComboBoxEditStyle
		Declare Property Style(Value As ComboBoxEditStyle)
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Property SelColor As Integer
		Declare Property SelColor(Value As Integer)
		Declare Property ItemIndex As Integer
		Declare Property ItemIndex(Value As Integer)
		Declare Property ItemHeight As Integer
		Declare Property ItemHeight(Value As Integer)
		Declare Property ItemCount As Integer
		Declare Property ItemCount(Value As Integer)
		Declare Property DropDownCount As Integer
		Declare Property DropDownCount(Value As Integer)
		Declare Property IntegralHeight As Boolean
		Declare Property IntegralHeight(Value As Boolean)
		Declare Property Sort As Boolean
		Declare Property Sort(Value As Boolean)
		Declare Property Object(FIndex As Integer) As Any Ptr
		Declare Property Object(FIndex As Integer, Obj As Any Ptr)
		Declare Property Item(FIndex As Integer) ByRef As WString
		Declare Property Item(FIndex As Integer, ByRef FItem As WString)
		Declare Operator Cast As Control Ptr
		Declare Sub AddItem(ByRef FItem As WString)
		Declare Sub AddObject(ByRef ObjName As WString, Obj As Any Ptr)
		Declare Sub RemoveItem(FIndex As Integer)
		Declare Sub InsertItem(FIndex As Integer, ByRef FItem As WString)
		Declare Sub InsertObject(FIndex As Integer, ByRef ObjName As WString, Obj As Any Ptr)
		Declare Function IndexOf(ByRef Item As WString) As Integer
		Declare Function Contains(ByRef Item As WString) As Boolean
		Declare Function IndexOfObject(Obj As Any Ptr) As Integer
		Declare Sub Clear
		Declare Sub ShowDropDown(Value As Boolean)
		Declare Sub SaveToFile(ByRef File As WString)
		Declare Sub LoadFromFile(ByRef File As WString)
		Declare Static Sub RegisterClass
		Declare Constructor
		Declare Destructor
		OnChange            As Sub(ByRef Sender As ComboBoxEdit)
		OnDblClick          As Sub(ByRef Sender As ComboBoxEdit)
		OnDropDown          As Sub(ByRef Sender As ComboBoxEdit)
		OnCloseUp           As Sub(ByRef Sender As ComboBoxEdit)
		OnKeyPress          As Sub(ByRef Sender As ComboBoxEdit, Key As Byte, Shift As Integer)
		OnKeyDown           As Sub(ByRef Sender As ComboBoxEdit, Key As Integer, Shift As Integer)
		OnKeyUp             As Sub(ByRef Sender As ComboBoxEdit, Key As Integer, Shift As Integer)
		#ifndef __USE_GTK__
			OnMeasureItem       As Sub(BYREF Sender As ComboBoxEdit, ItemIndex As Integer, BYREF Height As UInt)
			OnDrawItem          As Sub(BYREF Sender As ComboBoxEdit, ItemIndex As Integer, State As Integer, BYREF R As Rect, DC As HDC = 0)
		#EndIf
		OnSelected          As Sub(BYREF Sender As ComboBoxEdit, ItemIndex As Integer)
		OnSelectCanceled    As Sub(BYREF Sender As ComboBoxEdit)
	End Type
	
	#IfDef __USE_GTK__
		Declare Sub ComboBoxEdit_Popup(widget As GtkComboBox Ptr, user_data As Any Ptr)
		
		Declare Function ComboBoxEdit_Popdown(widget As GtkComboBox Ptr, user_data As Any Ptr) As Boolean
		
		Declare Sub ComboBoxEdit_Changed(widget As GtkComboBox Ptr, user_data As Any Ptr)
	#EndIf
End namespace

#IfNDef __USE_MAKE__
	#Include Once "ComboBoxEdit.bas"
#EndIf
