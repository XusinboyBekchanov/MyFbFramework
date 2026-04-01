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

'Provides methods to place data on and retrieve data from the system Clipboard.
Dim Shared As My.Sys.ClipboardType Clipboard
'pClipboard = @Clipboard

Namespace My.Sys
	Private Sub ClipboardType.Open
		#ifndef __USE_GTK__
			OpenClipboard(NULL)
		#endif
	End Sub
	
	Private Sub ClipboardType.Clear
		#ifdef __USE_GTK__
			gtk_clipboard_clear(FClipboard)
		#else
			EmptyClipboard
		#endif
	End Sub
	
	Private Sub ClipboardType.Close
		#ifndef __USE_GTK__
			CloseClipboard
		#endif
	End Sub
	
	#ifndef __USE_GTK__
		Private Function ClipboardType.HasFormat(FFormat As WORD) As Boolean
			Return IsClipboardFormatAvailable(FFormat)
		End Function
	#endif
	
	Private Sub ClipboardType.SetAsText(ByRef Value As WString)
		#ifdef __USE_GTK__
			gtk_clipboard_set_text(FClipboard, ToUtf8(Value), -1)
		#else
			Dim pchData As WString Ptr
			Dim hClipboardData As HGLOBAL
			Dim sz As Integer
			This.Open
			This.Clear
			sz = (Len(Value) + 1) * SizeOf(WString)
			hClipboardData = GlobalAlloc(NULL, sz)
			If hClipboardData Then
				pchData = Cast(WString Ptr, GlobalLock(hClipboardData))
				If pchData Then
					memcpy(pchData, @Value, sz)
					GlobalUnlock(hClipboardData)
				End If
				SetClipboardData(CF_UNICODETEXT, hClipboardData)
			End If
			This.Close
		#endif
	End Sub
	
	Private Function ClipboardType.GetAsText ByRef As WString
		#ifdef __USE_GTK__
			WLet(FText, *gtk_clipboard_wait_for_text(FClipboard))
		#else
			Dim hClipboardData As HANDLE
			This.Open
			hClipboardData = GetClipboardData(CF_UNICODETEXT)
			If hClipboardData <> 0 Then
				Dim pText As WString Ptr = Cptr(WString Ptr, GlobalLock(hClipboardData))
				WLet(FText, IIf(pText, *pText, "" ))
				GlobalUnlock(hClipboardData)
			Else
				WLet(FText, "")
			End If
			This.Close
		#endif
		If FText Then Return *FText Else Return ""
	End Function
	
	#ifndef __USE_GTK__
		Private Sub ClipboardType.SetAsHandle(FFormat As WORD, Value As HANDLE)
			This.Open
			This.Clear
			SetClipboardData(FFormat, Value)
			This.Close
		End Sub
	#endif
	
	#ifndef __USE_GTK__
		Private Function ClipboardType.GetAsHandle(FFormat As WORD) As HANDLE
			This.Open
			Function = GetClipboardData(FFormat)
			This.Close
		End Function
	#endif
	
	Private Property ClipboardType.FormatCount As Integer
		#ifndef __USE_GTK__
			Return CountClipboardFormats
		#else
			Return 0
		#endif
	End Property
	
	Private Property ClipboardType.FormatCount(Value As Integer)
	End Property
	
	Private Property ClipboardType.Format ByRef As WString
		Dim s As String = Space(255)
		#ifndef __USE_GTK__
			Dim i As Integer, IFormat As UINT
			i = GetClipboardFormatName(IFormat, s, 255)
			If i > 0 Then
				FFormat = Cast(WString Ptr, _Reallocate(FFormat, (i + 1) * SizeOf(WString)))
				*FFormat = ..Left(s, i)
			End If
		#endif
		If FFormat > 0 Then Return *FFormat Else Return ""
	End Property
	
	Private Property ClipboardType.Format(ByRef Value As WString)
		WLet(FFormat, Value + Chr(0))
		#ifndef __USE_GTK__
			RegisterClipboardFormat(FFormat)
		#endif
	End Property
	
	Private Constructor ClipboardType
		#ifdef __USE_GTK__
			FClipboard = gtk_clipboard_get(GDK_SELECTION_CLIPBOARD)
		#endif
	End Constructor
	
	Private Destructor ClipboardType
		If FText Then _Deallocate( FText)
	End Destructor
End Namespace