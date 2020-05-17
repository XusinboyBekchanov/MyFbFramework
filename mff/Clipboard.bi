'******************************************************************************
'* ClipboardType
'* This file is part of MyFBFramework
'* Based on:
'*  TClipboard
'*  FreeBasic Windows GUI ToolKit
'*  Copyright (c) 2007-2008 Nastase Eodor
'*  nastase_eodor@yahoo.com
'* Updated and added cross-platform
'* by Xusinboy Bekchanov (2018-2019)
'******************************************************************************
#include once "Component.bi"

Namespace My.Sys
	Type ClipboardType
	Private:
		FFormatCount As Integer
		FFormat      As WString Ptr
		FText        As WString Ptr
		#ifdef __USE_GTK__
			FClipboard As GtkClipboard Ptr
		#endif
	Public:
		Declare Sub Open
		Declare Sub Clear
		Declare Sub Close
		Declare Sub SetAsText(ByRef Value As WString)
		Declare Function GetAsText ByRef As WString
		#ifndef __USE_GTK__
			Declare Sub SetAsHandle(FFormat As Word, Value As HANDLE)
			Declare Function GetAsHandle(FFormat As Word) As HANDLE
			Declare Function HasFormat(FFormat As Word) As Boolean
		#endif
		Declare Property FormatCount As Integer
		Declare Property FormatCount(Value As Integer)
		Declare Property Format ByRef As WString
		Declare Property Format(ByRef Value As WString)
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

Common Shared As My.Sys.ClipboardType Ptr pClipboard

#ifndef __USE_MAKE__
	#include once "Clipboard.bas"
#endif
