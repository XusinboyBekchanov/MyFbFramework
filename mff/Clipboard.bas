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
#include once "Clipboard.bi"

Dim Shared As My.Sys.ClipboardType Clipboard
pClipboard = @Clipboard

Namespace My.Sys
	Sub ClipboardType.Open
		#ifndef __USE_GTK__
			OpenClipboard(NULL)
		#endif
	End Sub
	
	Sub ClipboardType.Clear
		#ifdef __USE_GTK__
			gtk_clipboard_clear(FClipboard)
		#else
			EmptyClipboard
		#endif
	End Sub
	
	Sub ClipboardType.Close
		#ifndef __USE_GTK__
			CloseClipboard
		#endif
	End Sub
	
	#ifndef __USE_GTK__
		Function ClipboardType.HasFormat(FFormat As Word) As Boolean
			Return IsClipboardFormatAvailable(FFormat)
		End Function
	#endif
	
	Sub ClipboardType.SetAsText(ByRef Value As WString)
		#ifdef __USE_GTK__
			gtk_clipboard_set_text(FClipBoard, ToUTF8(Value), -1)
		#Else
			Dim pchData As WString Ptr
			Dim hClipboardData As HGLOBAL
			Dim sz As Integer
			This.Open
			This.Clear
			sz = (Len(value) + 1) * SizeOf(WString)
			hClipboardData = GlobalAlloc(NULL, sz)
			pchData = Cast(WString Ptr, GlobalLock(hClipboardData))
			memcpy(pchData, @Value, sz)
			SetClipboardData(CF_UNICODETEXT, hClipboardData)
			GlobalUnlock(hClipboardData)
			This.Close
		#endif
	End Sub
	
	Function ClipboardType.GetAsText ByRef As WString
		#ifdef __USE_GTK__
			WLet FText, *gtk_clipboard_wait_for_text(FClipBoard)
		#else
			Dim hClipboardData As HANDLE
			This.Open
			hClipboardData = GetClipboardData(CF_UNICODETEXT)
			If hClipboardData <> 0 Then
				WLet FText, *CPtr(WString Ptr, GlobalLock(hClipboardData))
				GlobalUnlock(hClipboardData)
			Else
				WLet FText, ""
			End If
			This.Close
		#endif
		Return *FText
	End Function
	
	#ifndef __USE_GTK__
		Sub ClipboardType.SetAsHandle(FFormat As Word,Value As HANDLE)
			This.Open
			This.Clear
			SetClipboardData(FFormat, Value)
			This.Close
		End Sub
	#endif
	
	#ifndef __USE_GTK__
		Function ClipboardType.GetAsHandle(FFormat As Word) As HANDLE
			This.Open
			Function = GetClipboardData(FFormat)
			This.Close
		End Function
	#endif
	
	Property ClipboardType.FormatCount As Integer
		#ifndef __USE_GTK__
			Return CountClipboardFormats
		#else
			Return 0
		#endif
	End Property
	
	Property ClipboardType.FormatCount(Value As Integer)
	End Property
	
	Property ClipboardType.Format ByRef As WString
		Dim s As String = Space(255)
		#ifndef __USE_GTK__
			Dim i As Integer, IFormat As UINT
			i = GetClipboardFormatName(IFormat,s,255)
			FFormat = Cast(WString Ptr, Reallocate(FFormat, (i + 1) * SizeOf(WString)))
			*FFormat = Left(s, i)
		#endif
		Return *FFormat
	End Property
	
	Property ClipboardType.Format(ByRef Value As WString)
		WLet FFormat, Value + Chr(0)
		#ifndef __USE_GTK__
			RegisterClipboardFormat(FFormat)
		#endif
	End Property
	
	Constructor ClipboardType
		#ifdef __USE_GTK__
			FClipBoard = gtk_clipboard_get(GDK_SELECTION_CLIPBOARD)
		#endif
	End Constructor
	
	Destructor ClipboardType
		If FText Then Deallocate FText
	End Destructor
End Namespace
