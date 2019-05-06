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
#Include Once "SysUtils.bi"

Namespace My.Sys
    Type ClipboardType
        Private:
            FFormatCount As Integer
            FFormat      As WString Ptr
            FText        As WString Ptr
            #IfDef __USE_GTK__
				FClipboard As GtkClipboard Ptr
			#EndIf
        Public:
            Declare Sub Open
            Declare Sub Clear
            Declare Sub Close
            Declare Sub SetAsText(ByRef Value As WString)
            Declare Function GetAsText ByRef As WString
            #IfNDef __USE_GTK__
				Declare Sub SetAsHandle(FFormat As Word, Value As HANDLE)
				Declare Function GetAsHandle(FFormat As Word) As HANDLE
				Declare Function HasFormat(FFormat As Word) As Boolean
            #EndIf
            Declare Property FormatCount As Integer
            Declare Property FormatCount(Value As Integer)
            Declare Property Format ByRef As WString
            Declare Property Format(ByRef Value As WString)
            Declare Constructor
            Declare Destructor
    End Type

    Sub ClipboardType.Open
		#IfNDef __USE_GTK__
			OpenClipboard(NULL)
		#EndIf
    End Sub

    Sub ClipboardType.Clear
		#IfDef __USE_GTK__
			gtk_clipboard_clear(FClipboard)
		#Else
			EmptyClipboard
		#EndIf
    End Sub

    Sub ClipboardType.Close
		#IfNDef __USE_GTK__
			CloseClipboard
		#EndIf
    End Sub

	#IfNDef __USE_GTK__
		Function ClipboardType.HasFormat(FFormat As Word) As Boolean
			Return IsClipboardFormatAvailable(FFormat)
		End Function
    #Endif

    Sub ClipboardType.SetAsText(ByRef Value As WString)
        #IfDef __USE_GTK__
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
        #EndIf
    End Sub

    Function ClipboardType.GetAsText ByRef As WString
        #IfDef __USE_GTK__
			WLet FText, *gtk_clipboard_wait_for_text(FClipBoard)
        #Else
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
		#EndIf
        Return *FText
    End Function

	#IfNDef __USE_GTK__
		Sub ClipboardType.SetAsHandle(FFormat As Word,Value As HANDLE)
			This.Open
			This.Clear
			SetClipboardData(FFormat, Value)
			This.Close
		End Sub
	#EndIf

	#IfNDef __USE_GTK__
		Function ClipboardType.GetAsHandle(FFormat As Word) As HANDLE
			This.Open
			Function = GetClipboardData(FFormat)
			This.Close
		End Function
	#EndIf

    Property ClipboardType.FormatCount As Integer
		#IfNDef __USE_GTK__
			Return CountClipboardFormats
		#Else
			Return 0
		#EndIf
    End Property

    Property ClipboardType.FormatCount(Value As Integer)
    End Property

    Property ClipboardType.Format ByRef As WString
        Dim s As String = Space(255)
        #IfNDef __USE_GTK__
			Dim i As Integer, IFormat As UINT
			i = GetClipboardFormatName(IFormat,s,255)
			FFormat = Cast(WString Ptr, ReAllocate(FFormat, (i + 1) * SizeOf(WString))) 
			*FFormat = Left(s, i)
		#EndIf
		Return *FFormat
    End Property

    Property ClipboardType.Format(ByRef Value As WString)
        WLet FFormat, Value + Chr(0)
        #IfNDef __USE_GTK__
			RegisterClipboardFormat(FFormat) 
		#EndIf
    End Property

    Constructor ClipboardType
		#IfDef __USE_GTK__
			FClipBoard = gtk_clipboard_get(GDK_SELECTION_CLIPBOARD)
		#EndIf
    End Constructor

    Destructor ClipboardType
        If FText Then Deallocate FText
    End Destructor
End Namespace

Dim Shared As My.Sys.ClipboardType Clipboard
