'################################################################################
'#  DebugPrint.bi                                                               #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'#   Version: 1.0.0                                                             #
'################################################################################

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

'Displays a message in a dialog box, waits for the user to click a button, and returns an Integer indicating which button the user clicked.
Declare Function MsgBox Alias "MsgBox" (ByRef MsgStr As WString, ByRef Caption As WString = "", MsgType As MessageType = MessageType.mtInfo, ButtonsType As ButtonsTypes = ButtonsTypes.btOK) As MessageResult
Declare Function CheckUTF8NoBOM(ByRef SourceStr As String) As Boolean
Declare Function LoadFromFile(ByRef FileName As WString, ByRef FileEncoding As FileEncodings = FileEncodings.Utf8BOM, ByRef NewLineType As NewLineTypes = NewLineTypes.WindowsCRLF) ByRef As WString
Declare Function SaveToFile(ByRef FileName As WString, ByRef wData As WString, ByRef FileEncoding As FileEncodings = FileEncodings.Utf8BOM, ByRef NewLineType As NewLineTypes = NewLineTypes.WindowsCRLF) As Boolean
Declare Function InputBox(ByRef sCaption As WString  = "" , ByRef sMessageText As WString = "Enter text:" , ByRef sDefaultText As WString = "" , iFlag As Long = 0 , iFlag2 As Long = 0, hParentWin As Any Ptr = 0) ByRef As WString
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

#ifdef _DebugWindow_
	'Gets a handle to the debug window when the application is launched from the IDE.
	Dim Shared As Any Ptr DebugWindowHandle = Cast(Any Ptr, _DebugWindow_)
#else
	'Gets a handle to the debug window when the application is launched from the IDE.
	Dim Shared As Any Ptr DebugWindowHandle
#endif
Namespace Debug
	Declare Sub Print Overload(ByRef Msg As WString, bWriteLog As Boolean = True, bPrintMsg As Boolean = False, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
	Declare Sub Print Overload(ByVal MSG As Integer, ByVal Msg1 As Integer = -1, ByVal Msg2 As Integer = -1, ByVal Msg3 As Integer = -1, ByVal Msg4 As Integer = -1, bWriteLog As Boolean = True, bPrintMsg As Boolean = False, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
	Declare Sub Print Overload(ByRef MSG As WString, ByRef Msg1 As Const WString = "", ByRef Msg2 As Const WString = "", ByRef Msg3 As Const WString = "", ByRef Msg4 As Const WString = "", bWriteLog As Boolean = True, bPrintMsg As Boolean = False, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
	
	#ifndef Debug_Assert_Off
		#define AssertError(expression) _Assert(__FILE__, __LINE__, __FUNCTION__, __FB_QUOTE__(expression), expression, 0)
		#define AssertWarning(expression) _Assert(__FILE__, __LINE__, __FUNCTION__, __FB_QUOTE__(expression), expression, 1)
		
		Private Sub _Assert(ByRef sFile As WString, iLine As Integer, ByRef sFunction As WString, ByRef sExpression As WString, expression As Boolean, iType As Integer)
			#ifdef __FB_DEBUG__
				If Not expression Then ..Print sFile & "(" & Str(iLine) & "): assertion failed at " & sFunction & ": " & sExpression
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
	
		Private Sub Print Overload(ByVal MSG As Integer, ByVal Msg1 As Integer = -1, ByVal Msg2 As Integer = -1, ByVal Msg3 As Integer = -1, ByVal Msg4 As Integer = -1, bWriteLog As Boolean = True, bPrintMsg As Boolean = False, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
			Dim As WString Ptr tMsgPtr
			WLet(tMsgPtr, Str(MSG))
			If Msg1 <> -1 Then WAdd(tMsgPtr, Chr(9) & Msg1)
			If Msg2 <> -1 Then WAdd(tMsgPtr, Chr(9) & Msg2)
			If Msg3 <> -1 Then WAdd(tMsgPtr, Chr(9) & Msg3)
			If Msg4 <> -1 Then WAdd(tMsgPtr, Chr(9) & Msg4)
			Print(*tMsgPtr, bWriteLog, bPrintMsg, bShowMsg, bPrintToDebugWindow)
			Deallocate(tMsgPtr)
		End Sub
		
		Private Sub Print Overload(ByRef MSG As WString, ByRef Msg1 As Const WString = "", ByRef Msg2 As Const WString = "", ByRef Msg3 As Const WString = "", ByRef Msg4 As Const WString = "", bWriteLog As Boolean = True, bPrintMsg As Boolean = False, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
			Dim As WString Ptr tMsgPtr
			WLet(tMsgPtr, MSG)
			If Msg1 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg1)
			If Msg2 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg2)
			If Msg3 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg3)
			If Msg4 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg4)
			Print(*tMsgPtr, bWriteLog, bPrintMsg, bShowMsg, bPrintToDebugWindow)
			Deallocate(tMsgPtr)
		End Sub
		
		Private Sub Print Overload(ByRef Msg As WString, bWriteLog As Boolean = True, bPrintMsg As Boolean = False, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
			If bWriteLog Then
				Dim As Integer Result, Fn = FreeFile
				Result = Open(ExePath & "/DebugInfo.log" For Append As #Fn) 'Encoding "utf-8" Can not be using in the same mode
				If Result = 0 Then
					.Print #Fn, __DATE_ISO__ & " " & Time & Chr(9) & Msg & Space(20) 'cut some word if some unicode inside.
				End If
				Close #Fn
			End If
			If bPrintMsg Then .Print Msg
			If bShowMsg Then MsgBox Msg, "Visual FB Editor"
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

#ifdef __USE_GTK4__
	Dim Shared DialogResult As gint
	Sub gtk_dialog_response_sub(dialog As GtkDialog Ptr, response_id As gint)
		DialogResult = response_id
	End Sub
#endif

Type TInputBox
	#ifdef __USE_WINAPI__
		As MSG msg
		As HWND hWnd, hwnd1, hwnd2, hwnd3
		As WString * 1024 mess
		As BOOL flag
		As DEVMODE dm(0)
		As HFONT font,font1
		As Integer size
	#elseif defined(__USE_GTK__)
		dialog As GtkWidget Ptr
		
		entry As GtkWidget Ptr
		
		sText As ZString*1024
		
		iFlag As Long
	#else
		iFlag As Long
	#endif
End Type

#ifdef __USE_GTK__
	Sub EventbuttonInputBoxSub cdecl(Gwindow As GtkWidget Ptr,  data_ As gpointer) Export
		
		Dim As TInputBox Ptr tib = data_
		
		#ifdef __USE_GTK4__
			tib->sText = *gtk_entry_buffer_get_text(gtk_entry_get_buffer(Cast(Any Ptr, tib->entry)))
		#else
			tib->sText = *gtk_entry_get_text(Cast(Any Ptr, tib->entry))
		#endif
		
		gtk_dialog_response(Cast(Any Ptr, tib->dialog) , GTK_RESPONSE_OK)
		
	End Sub
	
	Function EventEntryInputBoxFunc cdecl( Gwindow As GtkWidget Ptr, gEvent As GdkEvent Ptr, data_ As gpointer) As gboolean Export
		
		Dim As TInputBox Ptr tib = data_
		
		If tib->iFlag = 0 AndAlso Cast(GdkEventButton Ptr,gEvent)->type = GDK_BUTTON_PRESS Then
			
			#ifdef __USE_GTK4__
				gtk_entry_buffer_set_text(gtk_entry_get_buffer(Cast(Any Ptr, tib->entry)), "", -1)
			#else
				gtk_entry_set_text(Cast(Any Ptr, tib->entry), "")
			#endif
			
			tib->iFlag = 1
			
		End If
		
		Return False
		
	End Function
#endif

Function InputBox(ByRef sCaption As WString  = "" , ByRef sMessageText As WString = "Enter text:" , ByRef sDefaultText As WString = "" , iFlag As Long = 0 , iFlag2 As Long = 0, hParentWin As Any Ptr = 0) ByRef As WString
	#ifdef __USE_WINAPI__
		Dim As HWND hwFocus = GetFocus()
		Dim InputBox_ As TInputBox
		InputBox_.dm(0).dmSize = SizeOf(DEVMODE)
		EnumDisplaySettings( 0, ENUM_CURRENT_SETTINGS, @InputBox_.dm(0))
		InputBox_.hWnd  = CreateWindowEx(WS_EX_CONTROLPARENT, "#32770", @sCaption, WS_TILED Or WS_VISIBLE, InputBox_.dm(0).dmPelsWidth / 2 - 155, InputBox_.dm(0).dmPelsHeight / 2 - 70, 310, 130, hParentWin, 0, 0, 0 )
		InputBox_.hwnd1 = CreateWindowEx(WS_EX_CLIENTEDGE, "Edit", @sDefaultText, WS_CHILD Or WS_VISIBLE Or WS_TABSTOP Or iFlag, 10, 33, 275, 25, InputBox_.hWnd, 0, 0, 0)
		InputBox_.hwnd2 = CreateWindowEx(0, "Button", "OK", WS_CHILD Or WS_VISIBLE Or WS_TABSTOP, 106, 65, 80, 25, InputBox_.hWnd, 0, 0, 0)
		InputBox_.hwnd3 = CreateWindowEx(0, "Static", @sMessageText, WS_CHILD Or WS_VISIBLE, 10, 10, 275, 20, InputBox_.hWnd, 0, 0, 0)
		
		InputBox_.size  = -MulDiv(10, GetDeviceCaps(CreateDC("DISPLAY",0,0,0), LOGPIXELSY), 72)
		InputBox_.font  = CreateFont(InputBox_.size,0,0,0,0,1,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH Or FF_DONTCARE,"Times New Roman")
		SendMessage(InputBox_.hwnd3,WM_SETFONT,Cast(WPARAM,InputBox_.font),0)
		InputBox_.font1 = CreateFont(InputBox_.size,0,0,0,0,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,DEFAULT_PITCH Or FF_DONTCARE,"Times New Roman")
		SendMessage(InputBox_.hwnd2,WM_SETFONT,Cast(WPARAM,InputBox_.font1),0)
		SendMessage(InputBox_.hwnd1,WM_SETFONT,Cast(WPARAM,InputBox_.font1),0)
		SetFocus InputBox_.hwnd1
		
		While GetMessage(@InputBox_.msg, 0, 0, 0 )
			If IsDialogMessage(InputBox_.hWnd ,@InputBox_.msg)  = 0 Then
				TranslateMessage(@InputBox_.msg )
				DispatchMessage(@InputBox_.msg )
			End If
			Select Case InputBox_.msg.hwnd
			Case InputBox_.hwnd2
				Dim As Integer iMsg = InputBox_.msg.message
				If (iMsg = WM_LBUTTONDOWN) OrElse (iMsg = WM_KEYUP AndAlso (InputBox_.msg.wParam = 32 OrElse InputBox_.msg.wParam = 13)) Then
					SendMessage(InputBox_.hwnd1,WM_GETTEXT,1024,Cast(LPARAM ,@InputBox_.mess))
					Static As WString Ptr sRet
					WLet(sRet, InputBox_.mess)
					Function = *sRet
					DestroyWindow(InputBox_.hWnd)
					InputBox_.flag = 0
					SetFocus(hwFocus)
					Exit Function
				End If
			Case InputBox_.hwnd1
				If InputBox_.msg.message=WM_LBUTTONDOWN Then
					If iFlag2 <> 0 Then
						If InputBox_.flag=0 Then
							InputBox_.flag=1
							SetWindowText(InputBox_.hwnd1 , "")
						End If
					End If
				End If
			End Select
		Wend
		SetFocus(hwFocus)
	#elseif defined(__USE_GTK__) AndAlso Not defined(__USE_GTK4__)
		Dim As GtkWidget  Ptr dialog
		
		Dim As GtkWidget  Ptr label
		
		Dim As GtkWidget  Ptr entry
		
		Dim As GtkWidget  Ptr button
		
		Dim As GtkWidget  Ptr hBoxDialog , vBox , hBox1 , hBox2 , hBox3 , vboxfill
		
		dialog = gtk_dialog_new ()
		
		If hParentWin Then
			
			gtk_window_set_transient_for(GTK_WINDOW(dialog) , Cast(Any Ptr,hParentWin))
			
		End If
		
		hBoxDialog = gtk_dialog_get_action_area(GTK_DIALOG(dialog))
		
		gtk_window_set_title (GTK_WINDOW (dialog), sCaption)
		
		label = gtk_label_new (sMessageText)
		
		entry = gtk_entry_new ()
		
		button = gtk_button_new_with_label("OK")
		
		vBox = gtk_vbox_new( 0 , 5)
		
		hBox1 = gtk_hbox_new( 1 , 180)
		
		hBox2 = gtk_hbox_new( 1 , 0)
		
		hBox3 = gtk_hbox_new( 1 , 0)
		
		vboxfill = gtk_vbox_new( 0 , 0)
		
		gtk_box_pack_start(Cast(Any Ptr , vBox), hBox1 , 0 , 1, 0)
		
		gtk_box_pack_start(Cast(Any Ptr , vBox), hBox2 , 1 , 1, 0)
		
		gtk_box_pack_start(Cast(Any Ptr , vBox), hBox3 , 1 , 1, 6)
		
		gtk_box_pack_start(Cast(Any Ptr , hBoxDialog), vBox , 1 , 1, 0)
		
		gtk_box_pack_start(Cast(Any Ptr , hBox1), label , 0 , 1, 0)
		
		gtk_box_pack_start(Cast(Any Ptr , hBox1), vboxfill , 1 , 1, 0)
		
		gtk_box_pack_start(Cast(Any Ptr , hBox2), entry , 1 , 1, 0)
		
		gtk_box_pack_start(Cast(Any Ptr , hBox3), button ,1 , 1, 100)
		
		gtk_widget_set_size_request(entry, 300, 30)
		
		If Len(sDefaultText) Then
			
			#ifdef __USE_GTK4__
				gtk_entry_buffer_set_text (gtk_entry_get_buffer(Cast(Any Ptr, entry)), sDefaultText, -1)
			#else
				gtk_entry_set_text (Cast(Any Ptr, entry) , sDefaultText)
			#endif
			
		End If
		
		Dim As TInputBox Ptr tib = _New(TInputBox)
		
		tib->dialog = dialog
		
		tib->entry = entry
		
		g_signal_connect(G_OBJECT(button), "clicked", G_CALLBACK (@EventbuttonInputBoxSub),tib)
		
		If iFlag2 Then
			
			g_signal_connect(G_OBJECT(entry), "event", G_CALLBACK (@EventEntryInputBoxFunc), tib)
			
		End If
		
		#ifdef __USE_GTK4
			gtk_widget_set_visible(dialog, True)
		#else
			gtk_widget_show_all(dialog)
		#endif
		
		If gtk_dialog_run (Cast(Any Ptr ,dialog)) = GTK_RESPONSE_OK Then
			
			Function = Trim(tib->sText, Chr(0))
			
		End If
		
		_Delete(tib)
		
		#ifdef __USE_GTK4__
			g_object_unref(dialog)
		#else
			gtk_widget_destroy(dialog)
		#endif
	#else
		Function = ""
	#endif
End Function

#ifndef LoadFromFile_Off
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
				WLet(pBuff, FromUtf8(StrPtr(Buff)))
				NewLineType= NewLineTypes.LinuxLF
			Else
				*pBuff =  WInput(FileSize, #Fn)
			End If
		End If
		CloseFile_(Fn)
		Return *pBuff
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
