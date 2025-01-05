'################################################################################
'#  NoInterface.bi
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'#   Version: 1.0.0                                                             #
'################################################################################
'Avoid using another Msgbox in SimpleVariantPlus.bi
'Function MsgBox cdecl Overload (ByVal Msg As LPCWSTR, ByVal Flags As Long = MB_ICONINFORMATION) As Long'

#define APP_TITLE "Visual FB Editor"
#include once "UString.bi"
Private Enum MessageType
	mtInfo
	mtWarning
	mtQuestion
	mtError
	mtOther
End Enum

Private Enum ButtonsTypes
	btNone
	btOK
	btYesNo
	btYesNoCancel
	btOkCancel
End Enum

Private Enum MessageResult
	mrAbort
	mrCancel
	mrIgnore
	mrNo
	mrOK
	mrRetry
	mrYes
End Enum

Enum FileEncodings
	PlainText
	Utf8
	Utf8BOM
	Utf16BOM
	Utf32BOM
End Enum

Enum NewLineTypes
	WindowsCRLF
	LinuxLF
	MacOSCR
End Enum
Declare Function MsgBox Alias "MsgBox" (ByRef MsgStr As WString, ByRef Caption As WString = "", MsgType As MessageType = MessageType.mtInfo, ButtonsType As ButtonsTypes = ButtonsTypes.btOK) As MessageResult
Namespace Debug
	Declare Sub Print Overload(ByRef Msg As String, bWriteLog As Boolean = False, bPrintMsg As Boolean = True, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
	Declare Sub Print(ByVal MSG As Integer, ByVal Msg1 As Integer = -1, ByVal Msg2 As Integer = -1, ByVal Msg3 As Integer = -1, ByVal Msg4 As Integer = -1, bWriteLog As Boolean = False, bPrintMsg As Boolean = True, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
	Declare Sub Print(ByRef MSG As WString, ByRef Msg1 As Const WString = "", ByRef Msg2 As Const WString = "", ByRef Msg3 As Const WString = "", ByRef Msg4 As Const WString = "", bWriteLog As Boolean = False, bPrintMsg As Boolean = True, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
	Declare Sub Print(ByRef MSG As String, ByRef Msg1 As Const String = "", ByRef Msg2 As Const String = "", ByRef Msg3 As Const String = "", ByRef Msg4 As Const String = "", bWriteLog As Boolean = False, bPrintMsg As Boolean = True, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
	Declare Sub Print(ByRef MSG As ZString, ByRef Msg1 As Const ZString = "", ByRef Msg2 As Const ZString = "", ByRef Msg3 As Const ZString = "", ByRef Msg4 As Const ZString = "", bWriteLog As Boolean = False, bPrintMsg As Boolean = True, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
	
	#ifndef Debug_Assert_Off
		#define AssertError(expression) _Assert(__FILE__, __LINE__, __FUNCTION__, __FB_QUOTE__(expression), expression, 0)
		#define AssertWarning(expression) _Assert(__FILE__, __LINE__, __FUNCTION__, __FB_QUOTE__(expression), expression, 1)
		
		Private Sub _Assert(ByRef sFile As WString, iLine As Integer, ByRef sFunction As WString, ByRef sExpression As WString, expression As Boolean, iType As Integer)
			#ifdef __FB_DEBUG__
				If Not expression Then .Print sFile & "(" & Str(iLine) & "): assertion failed at " & sFunction & ": " & sExpression
				If iType = 0 Then End
			#endif
		End Sub
	#endif
	
	#ifndef Debug_Clear_Off
		Private Sub Clear
			#ifdef __USE_WINAPI__
				If IsWindow(DebugWindowHandle) Then SendMessage(DebugWindowHandle, WM_SETTEXT, Cast(WPARAM, 0), Cast(LPARAM, @""))
			#elseif defined(__USE_GTK__)
				If GTK_IS_TEXT_VIEW(DebugWindowHandle) Then gtk_text_buffer_set_text(gtk_text_view_get_buffer(GTK_TEXT_VIEW(DebugWindowHandle)), !"\0", -1)
			#endif
		End Sub
	#endif
	
	Private Sub Print (ByVal MSG As Integer, ByVal Msg1 As Integer = -1, ByVal Msg2 As Integer = -1, ByVal Msg3 As Integer = -1, ByVal Msg4 As Integer = -1, bWriteLog As Boolean = False, bPrintMsg As Boolean = True, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
		Dim As WString Ptr tMsgPtr
		WLet(tMsgPtr, Str(MSG))
		If Msg1 <> -1 Then WAdd(tMsgPtr, Chr(9) & Msg1)
		If Msg2 <> -1 Then WAdd(tMsgPtr, Chr(9) & Msg2)
		If Msg3 <> -1 Then WAdd(tMsgPtr, Chr(9) & Msg3)
		If Msg4 <> -1 Then WAdd(tMsgPtr, Chr(9) & Msg4)
		Print(*tMsgPtr, bWriteLog, bPrintMsg, bShowMsg, bPrintToDebugWindow)
		Deallocate(tMsgPtr)
	End Sub
	
	Private Sub Print(ByRef MSG As WString, ByRef Msg1 As Const WString = "", ByRef Msg2 As Const WString = "", ByRef Msg3 As Const WString = "", ByRef Msg4 As Const WString = "", bWriteLog As Boolean = False, bPrintMsg As Boolean = True, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
		Dim As WString Ptr tMsgPtr
		WLet(tMsgPtr, MSG)
		If Msg1 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg1)
		If Msg2 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg2)
		If Msg3 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg3)
		If Msg4 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg4)
		Print(*tMsgPtr, bWriteLog, bPrintMsg, bShowMsg, bPrintToDebugWindow)
		Deallocate(tMsgPtr)
	End Sub
	
	Private Sub Print(ByRef MSG As String, ByRef Msg1 As Const String = "", ByRef Msg2 As Const String = "", ByRef Msg3 As Const String = "", ByRef Msg4 As Const String = "", bWriteLog As Boolean = False, bPrintMsg As Boolean = True, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
		Dim As WString Ptr tMsgPtr
		WLet(tMsgPtr, MSG)
		If Msg1 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg1)
		If Msg2 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg2)
		If Msg3 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg3)
		If Msg4 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg4)
		Print(*tMsgPtr, bWriteLog, bPrintMsg, bShowMsg, bPrintToDebugWindow)
		Deallocate(tMsgPtr)
	End Sub
	
	Private Sub Print(ByRef MSG As ZString, ByRef Msg1 As Const ZString = "", ByRef Msg2 As Const ZString = "", ByRef Msg3 As Const ZString = "", ByRef Msg4 As Const ZString = "", bWriteLog As Boolean = False, bPrintMsg As Boolean = True, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
		Dim As WString Ptr tMsgPtr
		WLet(tMsgPtr, MSG)
		If Msg1 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg1)
		If Msg2 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg2)
		If Msg3 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg3)
		If Msg4 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg4)
		Print(*tMsgPtr, bWriteLog, bPrintMsg, bShowMsg, bPrintToDebugWindow)
		Deallocate(tMsgPtr)
	End Sub
	
	Private Sub Print Overload(ByRef Msg As String, bWriteLog As Boolean = False, bPrintMsg As Boolean = True, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
		If bWriteLog Then
			Dim As Integer Result, Fn = FreeFile
			Result = Open(ExePath & "/DebugInfo.log" For Append As #Fn) 'Encoding "utf-8" Can not be using in the same mode
			If Result = 0 Then
				.Print #Fn, __DATE_ISO__ & " " & Time & Chr(9) & Msg & Space(20) 'cut some word if some unicode inside.
			End If
			Close #Fn
		End If
		If bPrintMsg Then .Print Msg
		If bShowMsg Then MsgBox Msg, APP_TITLE
		If bPrintToDebugWindow Then
			#ifdef __USE_WINAPI__
				If IsWindow(DebugWindowHandle) Then
					Dim As HWND TabPageHandle = GetParent(DebugWindowHandle)
					Dim As HWND TabControlHandle = GetParent(TabPageHandle)
					Dim As Integer Index = Cast(Integer, GetProp(TabPageHandle, "@@@Index"))
					If SendMessage(TabControlHandle, TCM_GETCURSEL, 0, 0) <> Index Then
						SendMessage(TabControlHandle, TCM_SETCURSEL, Index, 0)
						ShowWindow(TabPageHandle, SW_SHOW)
						BringWindowToTop(TabPageHandle)
					End If
					Dim As WString Ptr SelText
					WLet(SelText, Msg & Chr(13, 10))
					SendMessage(DebugWindowHandle, EM_REPLACESEL, 0, CInt(SelText))
					WDeAllocate(SelText)
				End If
			#elseif defined(__USE_GTK__)
				If GTK_IS_TEXT_VIEW(DebugWindowHandle) Then
					Dim As GtkWidget Ptr TabPageHandle = gtk_widget_get_parent(DebugWindowHandle)
					Dim As GtkWidget Ptr TabControlHandle = gtk_widget_get_parent(TabPageHandle)
					Dim As Integer Index = gtk_notebook_page_num(GTK_NOTEBOOK(TabControlHandle), TabPageHandle)
					If gtk_notebook_get_current_page(GTK_NOTEBOOK(gtk_widget_get_parent(gtk_widget_get_parent(DebugWindowHandle)))) <> Index Then
						gtk_notebook_set_current_page(GTK_NOTEBOOK(gtk_widget_get_parent(gtk_widget_get_parent(DebugWindowHandle))), Index)
					End If
					Dim As GtkTextIter _start, _end
					gtk_text_buffer_insert_at_cursor(gtk_text_view_get_buffer(GTK_TEXT_VIEW(DebugWindowHandle)), ToUtf8(Msg & Chr(13, 10)), -1)
					gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(DebugWindowHandle)), @_start, @_end)
					Dim As GtkTextMark Ptr ptextmark = gtk_text_buffer_create_mark(gtk_text_view_get_buffer(GTK_TEXT_VIEW(DebugWindowHandle)), NULL, @_end, False)
					gtk_text_view_scroll_to_mark(GTK_TEXT_VIEW(DebugWindowHandle), ptextmark, 0., False, 0., 0.)
					While gtk_events_pending()
						gtk_main_iteration()
					Wend
				End If
			#endif
		End If
	End Sub
End Namespace

Public Function MsgBox Alias "MsgBox" (ByRef MsgStr As WString, ByRef Caption As WString = "", MsgType As MessageType = MessageType.mtInfo, ButtonsType As ButtonsTypes = ButtonsTypes.btOK) As MessageResult
	Dim As Integer Result = -1
	Dim As WString Ptr FCaption = CAllocate((Len(Caption) + 1) * SizeOf(WString))
	Dim As WString Ptr FMsgStr = CAllocate((Len(MsgStr) + 1) * SizeOf(WString))
	*FCaption = Caption
	*FMsgStr = MsgStr
	Dim As Integer MsgTypeIn, ButtonsTypeIn
	Dim As Long Wnd
	Select Case MsgType
	Case mtInfo: MsgTypeIn = MB_ICONINFORMATION
	Case mtWarning: MsgTypeIn = MB_ICONEXCLAMATION
	Case mtQuestion: MsgTypeIn = MB_ICONQUESTION
	Case mtError: MsgTypeIn = MB_ICONERROR
	Case mtOther: MsgTypeIn = 0
	End Select
	Select Case ButtonsType
	Case btNone: ButtonsTypeIn = 0
	Case btOK: ButtonsTypeIn = MB_OK
	Case btYesNo: ButtonsTypeIn = MB_YESNO
	Case btYesNoCancel: ButtonsTypeIn = MB_YESNOCANCEL
	Case btOkCancel: ButtonsTypeIn = MB_OKCANCEL
	End Select
	Result = MessageBox(0, *FMsgStr, *FCaption, MsgTypeIn Or ButtonsTypeIn Or MB_TOPMOST Or MB_TASKMODAL)
	Select Case Result
	Case IDABORT: Result = mrAbort
	Case IDCANCEL: Result = mrCancel
	Case IDIGNORE: Result = mrIgnore
	Case IDNO: Result = mrNo
	Case IDOK: Result = mrOK
	Case IDRETRY: Result = mrRetry
	Case IDYES: Result = mrYes
	End Select
	Return Result
End Function

Private Function CheckUTF8NoBOM(ByRef SourceStr As String) As Boolean
	Dim As Boolean IsUTF8 = True
	Dim As Integer iStart = 0, iEnd = Len(SourceStr)
	While (iStart < iEnd)
		If SourceStr[iStart] < &H80 Then
			'(10000000): 值小于&H80的为ASCII字符
			iStart += 1
		ElseIf (SourceStr[iStart] < &HC0) Then
			'(11000000): 值介于&H80与&HC0之间的为无效UTF-8字符
			IsUTF8 = False
			Exit While
		ElseIf (SourceStr[iStart] < &HE0) Then
			'(11100000): 此范围内为2字节UTF-8字符
			If iStart >= iEnd - 1 Then Exit While
			If ((SourceStr[iStart + 1] And &HC0) <> &H80) Then
				IsUTF8 = False
				Exit While
			End If
			iStart += 2
		ElseIf (SourceStr[iStart] < (&HF0)) Then
			'(11110000): 此范围内为3字节UTF-8字符
			If iStart >= iEnd - 2 Then Exit While
			If ((SourceStr[iStart + 1] And &HC0) <> &H80) Or ((SourceStr[iStart + 2] And &HC0) <> &H80) Then
				IsUTF8 = False
				Exit While
			End If
			iStart += 3
		Else
			IsUTF8 = False
			Exit While
		End If
	Wend
	Return IsUTF8
End Function

#ifndef LoadFromFile_Off
	Private Function LoadFromFile(ByRef FileName As WString, ByRef FileEncoding As FileEncodings = FileEncodings.Utf8BOM, ByRef NewLineType As NewLineTypes = NewLineTypes.WindowsCRLF) ByRef As WString
		Dim As String Buff, EncodingStr
		Dim As Integer Result = -1, Fn, FileSize
		'check the Newlinetype again for missing Cr in AsicII file
		Fn = FreeFile_
		If Open(FileName For Binary Access Read As #Fn) = 0 Then
			FileSize = LOF(Fn) + 1
			Buff = String(4, 0)
			Get #Fn, , Buff
			If (Buff[0] = &HFF AndAlso Buff[1] = &HFE AndAlso Buff[2] = 0 AndAlso Buff[3] = 0) OrElse (Buff[0] = 0 AndAlso Buff[1] = 0 AndAlso Buff[2] = &HFE AndAlso Buff[3] = &HFF) Then 'Little Endian , Big Endian
				FileEncoding = FileEncodings.Utf32BOM
				EncodingStr = "utf-32"
				Buff = String(1024, 0)
				Get #Fn, 0, Buff
				'ElseIf (Buff[0] = = OxFE && Buff[1] = = 0xFF) 'Big Endian
			ElseIf (Buff[0] = &HFF AndAlso Buff[1] = &HFE) OrElse (Buff[0] = &HFE AndAlso Buff[1] = &HFF) Then 'Little Endian
				FileEncoding = FileEncodings.Utf16BOM
				EncodingStr = "utf-16"
				Buff = String(1024, 0)
				Get #Fn, 0, Buff
			ElseIf Buff[0] = &HEF AndAlso Buff[1] = &HBB AndAlso Buff[2] = &HBF Then
				FileEncoding = FileEncodings.Utf8BOM
				EncodingStr = "utf-8"
				Buff = String(1024, 0)
				Get #Fn, 0, Buff
			Else
				Buff = String(FileSize, 0)
				Get #Fn, 0, Buff
				If (CheckUTF8NoBOM(Buff)) Then
					FileEncoding = FileEncodings.Utf8
					EncodingStr = "ascii"
				Else
					FileEncoding = FileEncodings.PlainText
					EncodingStr = "ascii"
				End If
			End If
			If InStr(Buff, Chr(13, 10)) Then
				NewLineType= NewLineTypes.WindowsCRLF
			ElseIf InStr(Buff, Chr(10)) Then
				NewLineType= NewLineTypes.LinuxLF
			ElseIf InStr(Buff, Chr(13)) Then
				NewLineType= NewLineTypes.MacOSCR
			Else
				NewLineType= NewLineTypes.WindowsCRLF
			End If
		Else
			CloseFile_(Fn)
			Debug.Print Date & " " & Time & Chr(9) & __FUNCTION__ & Chr(9) & "Open file failure: " + FileName, True
			Return ""
		End If
		CloseFile_(Fn)
		
		Static As WString Ptr pBuff
		Fn = FreeFile_
		Result = Open(FileName For Input Encoding EncodingStr As #Fn)
		If Result = 0 Then
			pBuff = _Reallocate(pBuff, (FileSize + 1) * SizeOf(WString))
			If FileEncoding = FileEncodings.Utf8 Then
				Buff =  Input(FileSize, #Fn)
				*pBuff = FromUtf8(StrPtr(Buff))
			Else
				*pBuff =  WInput(FileSize, #Fn)
			End If
		End If
		CloseFile_(Fn)
		If pBuff > 0 Then Return *pBuff Else Return ""
	End Function
#endif

#ifndef SaveToFile_Off
	Private Function SaveToFile(ByRef FileName As WString, ByRef wData As WString, ByRef FileEncoding As FileEncodings = FileEncodings.Utf8BOM, ByRef NewLineType As NewLineTypes = NewLineTypes.WindowsCRLF) As Boolean
		Dim As Integer Fn = FreeFile_
		Dim As Integer Result
		Dim As String FileEncodingText, NewLine
		If FileEncoding = FileEncodings.Utf8 Then
			FileEncodingText = "ascii"
		ElseIf FileEncoding = FileEncodings.Utf8BOM Then
			FileEncodingText = "utf-8"
		ElseIf FileEncoding = FileEncodings.Utf16BOM Then
			FileEncodingText = "utf-16"
		ElseIf FileEncoding = FileEncodings.Utf32BOM Then
			FileEncodingText = "utf-32"
		Else
			FileEncodingText = "ascii"
		End If
		If NewLineType = NewLineTypes.LinuxLF Then
			NewLine = Chr(10)
		ElseIf NewLineType = NewLineTypes.MacOSCR Then
			NewLine = Chr(13)
		Else
			NewLine = "" ' Chr(13, 10) No neeed replace
		End If
		If Open(FileName For Output Encoding FileEncodingText As #Fn) = 0 Then
			If FileEncoding = FileEncodings.Utf8 Then
				If NewLine <> "" Then
					Print #Fn, ToUtf8(Replace(wData, Chr(13, 10), NewLine)); 'Automaticaly add a Cr LF to the ends of file for each time without ";"
				Else
					Print #Fn, ToUtf8(wData); 'Automaticaly add a Cr LF to the ends of file for each time without ";"
				End If
				
			ElseIf FileEncoding = FileEncodings.PlainText Then
				If NewLine <> "" Then
					Print #Fn, Str(Replace(wData, Chr(13, 10), NewLine));
				Else
					Print #Fn, Str(wData);
				End If
			Else
				If NewLine <> "" Then
					Print #Fn, Replace(wData, Chr(13, 10), NewLine);
				Else
					Print #Fn, wData;
				End If
			End If
		Else
			Debug.Print "Save file failure! "  & FileName, True
			Return False
		End If
		CloseFile_(Fn)
		Return True
	End Function
#endif

