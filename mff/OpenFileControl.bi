'###############################################################################
'#  Dialogs.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   Dialogs.bi                                                                #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "Dialogs.bi"
#ifndef __USE_GTK__
	#include once "win\dlgs.bi"
#endif

Namespace My.Sys.Forms
	'`OpenFileControl` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`OpenFileControl` - Embeds a file selection interface directly within forms, supporting multi-select and dynamic filtering.
	Private Type OpenFileControl Extends Control
	Private:
		#ifdef __USE_GTK__
			Declare Static Sub FileChooser_CurrentFolderChanged(chooser As GtkFileChooser Ptr, user_data As Any Ptr)
			Declare Static Sub FileChooser_FileActivated(chooser As GtkFileChooser Ptr, user_data As Any Ptr)
			Declare Static Sub FileChooser_SelectionChanged(chooser As GtkFileChooser Ptr, user_data As Any Ptr)
			Dim As GtkFileFilter Ptr filefilter(Any)
		#else
			Declare Static Function Hook(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As UInteger
			Declare Static Function EnumChildsProc(hDlg As HWND, lParam As LPARAM) As Boolean
			Declare Static Function EnumListViewsProc(hDlg As HWND, lParam1 As LPARAM) As Boolean
			Declare Static Function HookChildProc(hDlg As HWND, uMsg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			Declare Static Function HookListView(hDlg As HWND, uMsg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			Declare Static Function HookListViewParent(hDlg As HWND, uMsg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			Declare Static Function HookComboBoxParent(hDlg As HWND, uMsg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			ThreadID As Any Ptr
		#endif
	Protected:
		FFirstShowed  As Boolean
		FDarkMode     As Boolean
		FInitialDir   As WString Ptr
		FMultiSelect  As Boolean
		FDefaultExt   As WString Ptr
		FFileName     As WString Ptr
		FFileTitle    As WString Ptr
		FFilter       As WString Ptr
		FFilterIndex  As Integer
		FFilterCount  As Integer
	Public:
		#ifndef ReadProperty_Off
			'Loads config from persistence stream
			Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves config to persistence stream
			Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Array of paths for multi-selected files
		FileNames     As WStringList
		'Bitmask for dialog behavior flags
		Options       As OpenFileOptions
		Declare Property MultiSelect As Boolean
		'Enables multiple file selection
		Declare Property MultiSelect(Value As Boolean)
		Declare Property InitialDir ByRef As WString
		'Initial browsing directory path
		Declare Property InitialDir(ByRef Value As WString)
		Declare Property DefaultExt ByRef As WString
		'Auto-appends extension when missing
		Declare Property DefaultExt(ByRef Value As WString)
		Declare Property FileName ByRef As WString
		'Full path of selected single file
		Declare Property FileName(ByRef Value As WString)
		Declare Property FileTitle ByRef As WString
		'Filename without directory path
		Declare Property FileTitle(ByRef Value As WString)
		Declare Property Filter ByRef As WString
		'File type filters (e.g., "Images|*.jpg;*.png")
		Declare Property Filter(ByRef Value As WString)
		Declare Property FilterIndex As Integer
		'Default filter position (1-based index)
		Declare Property FilterIndex(Value As Integer)
		Declare Property TabIndex As Integer
		'Position in tab navigation order
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		'Enables focus via Tab key
		Declare Property TabStop(Value As Boolean)
		'Initializes native window handle
		Declare Static Sub CreateWnd(Param As Any Ptr)
		'Initializes native window handle
		Declare Sub CreateWnd
		Declare Constructor
		Declare Destructor
		'Triggered when selection is confirmed
		OnFileActivate    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As OpenFileControl)
		'Raised during directory navigation
		OnFolderChange    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As OpenFileControl)
		'Fired when selected files change
		OnSelectionChange As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As OpenFileControl)
		'Triggered by filter type modification
		OnTypeChange      As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As OpenFileControl, Index As Integer)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "OpenFileControl.bas"
#endif
