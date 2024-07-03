'################################################################################
'#  Console.bi
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'#   Version: 1.0.0                                                             #
'################################################################################
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
Declare Function MsgBox Alias "MsgBox" (ByRef MsgStr As WString, ByRef Caption As WString = "", MsgType As MessageType = MessageType.mtInfo, ButtonsType As ButtonsTypes = ButtonsTypes.btOK) As MessageResult
Namespace Debug
	#ifndef Debug_Assert_Off
		#define AssertError(expression) _Assert(__FILE__, __LINE__, __FUNCTION__, __FB_QUOTE__(expression), expression, 0)
		#define AssertWarning(expression) _Assert(__FILE__, __LINE__, __FUNCTION__, __FB_QUOTE__(expression), expression, 1)
		
		Private Sub _Assert(ByRef sFile As WString, iLine As Integer, ByRef sFunction As WString, ByRef sExpression As WString, expression As Boolean, iType As Integer)
			#ifdef __FB_DEBUG__
				If Not expression Then Print sFile & "(" & Str(iLine) & "): assertion failed at " & sFunction & ": " & sExpression
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
	
	#ifndef Debug_Print_Off
		'Private Sub Print Overload(ByVal Msg As Integer, ByVal Msg1 As Integer = -1, ByVal Msg2 As Integer = -1, ByVal Msg3 As Integer = -1, ByVal Msg4 As Integer = -1, bWriteLog As Boolean = False, bPrintMsg As Boolean = False, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
		'	Dim As WString Ptr tMsgPtr
		'	WLet(tMsgPtr, Str(Msg))
		'	If Msg1 <> -1 Then WAdd(tMsgPtr, Chr(9) & Msg1)
		'	If Msg2 <> -1 Then WAdd(tMsgPtr, Chr(9) & Msg2)
		'	If Msg3 <> -1 Then WAdd(tMsgPtr, Chr(9) & Msg3)
		'	If Msg4 <> -1 Then WAdd(tMsgPtr, Chr(9) & Msg4)
		'	Print(*tMsgPtr, bWriteLog, bPrintMsg, bShowMsg, bPrintToDebugWindow)
		'	Deallocate(tMsgPtr)
		'End Sub
		'
		'Private Sub Print Overload(ByRef Msg As WString, ByRef Msg1 As Const WString = "", ByRef Msg2 As Const WString = "", ByRef Msg3 As Const WString = "", ByRef Msg4 As Const WString = "", bWriteLog As Boolean = False, bPrintMsg As Boolean = False, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
		'	Dim As WString Ptr tMsgPtr
		'	WLet(tMsgPtr, Msg)
		'	If Msg1 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg1)
		'	If Msg2 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg2)
		'	If Msg3 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg3)
		'	If Msg4 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg4)
		'	Print(*tMsgPtr, bWriteLog, bPrintMsg, bShowMsg, bPrintToDebugWindow)
		'	Deallocate(tMsgPtr)
		'End Sub
		
		Private Sub Print Overload(ByRef Msg As UString, bWriteLog As Boolean = False, bPrintMsg As Boolean = False, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
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
	#endif
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

