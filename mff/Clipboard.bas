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
		#ifdef __USE_WINAPI__
			OpenClipboard(NULL)
		#endif
	End Sub
	
	Private Sub ClipboardType.Clear
		#ifdef __USE_GTK__
			gtk_clipboard_clear(FClipboard)
		#elseif defined(__USE_WINAPI__)
			EmptyClipboard
		#endif
	End Sub
	
	Private Sub ClipboardType.Close
		#ifdef __USE_WINAPI__
			CloseClipboard
		#endif
	End Sub
	
	#ifdef __USE_WINAPI__
		Private Function ClipboardType.HasFormat(FFormat As WORD) As Boolean
			Return IsClipboardFormatAvailable(FFormat)
		End Function
	#endif
	
	Private Sub ClipboardType.SetAsText(ByRef Value As WString)
		#ifdef __USE_GTK__
			gtk_clipboard_set_text(FClipboard, ToUtf8(Value), -1)
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			ClipboardSetText(ToUtf8(Value))
		#else
			Dim pchData As WString Ptr
			Dim hClipboardData As HGLOBAL
			Dim sz As Integer
			This.Open
			This.Clear
			sz = (Len(Value) + 1) * SizeOf(WString)
			hClipboardData = GlobalAlloc(GMEM_MOVEABLE, sz)
			If hClipboardData Then
				pchData = Cast(WString Ptr, GlobalLock(hClipboardData))
				If pchData Then
					memcpy(pchData, @Value, sz)
					GlobalUnlock(hClipboardData)
				Else
					GlobalFree(hClipboardData)
				End If
				SetClipboardData(CF_UNICODETEXT, hClipboardData)
			End If
			This.Close
		#endif
	End Sub
	
	Private Function ClipboardType.GetAsText ByRef As WString
		#ifdef __USE_GTK__
		Dim pGtkTxt As ZString Ptr = gtk_clipboard_wait_for_text(FClipboard)
		If pGtkTxt Then
		WLet(FText, *pGtkTxt)
  	              g_free(pGtkTxt)
   	         Else
    	            WLet(FText, "")
     	       End If
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			Dim As ZString Ptr pUtf8 = ClipboardGetText()
			Dim As WString Ptr pWide = IIf(pUtf8, FromUtf8(pUtf8), 0)
			If pUtf8 Then Deallocate(pUtf8)
			WLet(FText, IIf(pWide, *pWide, ""))
			If pWide Then WDeAllocate(pWide)
		#else
			Dim hClipboardData As HANDLE
			This.Open
			hClipboardData = GetClipboardData(CF_UNICODETEXT)
			If hClipboardData <> 0 Then
				Dim pText As WString Ptr = CPtr(WString Ptr, GlobalLock(hClipboardData))
				WLet(FText, IIf(pText, *pText, "" ))
				GlobalUnlock(hClipboardData)
			Else
				WLet(FText, "")
			End If
			This.Close
		#endif
		If FText Then Return *FText Else Return ""
	End Function
	
	#ifdef __USE_WINAPI__
		Private Sub ClipboardType.SetAsHandle(FFormat As WORD, Value As HANDLE)
			This.Open
			This.Clear
			SetClipboardData(FFormat, Value)
			This.Close
		End Sub
	#endif
	
	#ifdef __USE_WINAPI__
		Private Function ClipboardType.GetAsHandle(FFormat As WORD) As HANDLE
			This.Open
			Function = GetClipboardData(FFormat)
			This.Close
		End Function
	#endif
	
	Private Property ClipboardType.FormatCount As Integer
		#ifdef __USE_WINAPI__
			Return CountClipboardFormats
		#else
			Return 0
		#endif
	End Property
	
	Private Property ClipboardType.FormatCount(Value As Integer)
	End Property
	
	Private Property ClipboardType.Format ByRef As WString
		Dim s As String = Space(255)
		#ifdef __USE_WINAPI__
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
		WLet(FFormat, Value)
		#ifdef __USE_WINAPI__
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
		If FFormat Then _Deallocate(FFormat)
	End Destructor
End Namespace