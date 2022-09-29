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

#include once "ListControl.bi"

Namespace My.Sys.Forms
	#define QCheckedListBox(__Ptr__) *Cast(CheckedListBox Ptr,__Ptr__)
	
	Private Type CheckedListBox Extends ListControl
	Private:
		#ifndef __USE_GTK__
			Declare Static Sub WNDPROC(ByRef Message As Message)
			Declare Virtual Sub ProcessMessage(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			fTheme  As HTHEME
		#endif
	Protected:
		#ifdef __USE_GTK__
			Declare Static Sub Check(cell As GtkCellRendererToggle Ptr, path As gchar Ptr, model As GtkListStore Ptr)
		#endif
	Public:
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property Checked(Index As Integer) As Boolean
		Declare Property Checked(Index As Integer, Value As Boolean)
		Declare Sub AddItem(ByRef FItem As WString, Obj As Any Ptr = 0)
		Declare Sub InsertItem(FIndex As Integer, ByRef FItem As WString, Obj As Any Ptr = 0)
		Declare Sub SaveToFile(ByRef FileName As WString)
		Declare Sub LoadFromFile(ByRef FileName As WString)
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "CheckedListBox.bas"
#endif
