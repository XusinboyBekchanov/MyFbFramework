'###############################################################################
'#  Application.bas                                                             #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TApplication.bi                                                           #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.1                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "Application.bi"
#include once "Form.bi"
#include once "DarkMode/DarkMode.bi"

Dim Shared App As My.Application
If pApp = 0 Then pApp = @App

Namespace My
	#ifndef ReadProperty_Off
		Private Function Application.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "mainform": Return @FMainForm
			Case "version": WLet(FTemp, WStr(Version)): Return FTemp
			Case "title": Title: Return FTitle
			Case "filename": Return @This.FileName
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function Application.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "mainform": This.MainForm = Value
				Case "title": This.Title = QWString(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Property Application.DarkMode As Boolean
		Return FDarkMode
	End Property
	
	Private Property Application.DarkMode(Value As Boolean)
		FDarkMode = Value
		#ifdef __USE_WINAPI__
			If g_buildNumber = 0 Then InitDarkMode
		#endif
		SetDarkMode Value, False
	End Property
	
	#ifndef APP_TITLE
		#define APP_TITLE ""
	#endif
	#ifndef VER_MAJOR
		#define VER_MAJOR "0"
	#endif
	#ifndef VER_MINOR
		#define VER_MINOR "0"
	#endif
	#ifndef VER_PATCH
		#define VER_PATCH "0"
	#endif
	
	Private Function Application.Version As Const String
		#ifdef __FB_WIN32__
			Return GetVerInfo("FileVersion")
		#else
			Dim As String Version_ = VER_MAJOR & "." & VER_MINOR & "." & VER_PATCH
			Return Version_
		#endif
	End Function
	
	Private Property Application.Icon As My.Sys.Drawing.Icon
		Return FIcon
	End Property
	
	Private Property Application.Icon(value As My.Sys.Drawing.Icon)
		Dim As Integer i
		FIcon = value
		#ifdef __USE_WINAPI__
			If FIcon.Handle Then
				For i = 0 To FormCount -1
					SendMessage Forms[i]->Handle,WM_SETICON,ICON_BIG,CInt(FIcon.Handle)
				Next i
			End If
		#endif
	End Property
	
	#ifndef Application_Title_Get_Off
		Private Property Application.Title ByRef As WString
			If FTitle = 0 Then
				WLet(FTitle, GetVerInfo("ApplicationTitle"))
				If *FTitle = "" Then
					#ifdef __USE_GTK__
						WLet(FTitle, APP_TITLE)
					#elseif defined(__USE_WINAPI__)
						For i As Integer = 0 To FormCount -1
							If (GetWindowLong(Forms[i]->Handle, GWL_EXSTYLE) And WS_EX_APPWINDOW) = WS_EX_APPWINDOW Then
								WLet(FTitle, Forms[i]->Text)
								Exit For
							End If
						Next i
					#endif
				End If
			End If
			Return *FTitle
		End Property
	#endif
	
	Private Property Application.Title(ByRef Value As WString)
		WLet(FTitle, Value)
	End Property
	
	Private Property Application.ExeName ByRef As WString
		Dim As WString*255 Tx
		Dim As WString*225 s, En
		Dim As Integer L, i, k
		#ifdef __USE_WINAPI__
			L = GetModuleFileName(GetModuleHandle(NULL), Tx, 255)
		#else
			Tx = Command(0)
			L = Len(Tx)
		#endif
		s = .Left(Tx, L)
		For i = 0 To Len(s)
			If s[i] = Asc("\") Then k = i
		Next i
		En = Mid(s, k + 2, Len(s))
		WLet(FFileName, s)
		WLet(FExeName, Mid(En, 1, InStr(En, ".") - 1))
		Return *FExeName
	End Property
	
	Private Property Application.ExeName(ByRef Value As WString)
	End Property
	
	Private Property Application.FileName ByRef As WString
		Dim As Integer L
		#ifdef __USE_GTK__
			Dim As ZString * 255 Tx
			#ifndef __FB_WIN32__
				L = readlink("/proc/self/exe", @Tx, 255 - 1)
			#else
				Tx = Command(0)
				L = Len(Tx)
			#endif
		#elseif defined(__USE_WINAPI__)
			Dim As WString * 255 Tx
			L = GetModuleFileName(GetModuleHandle(NULL), @Tx, 255 - 1)
		#elseif defined(__USE_JNI__)
			Dim As WString * 255 Tx
		#else
			Dim As WString * 255 Tx
		#endif
		WLet(FFileName, .Left(Tx, L))
		Return *FFileName
	End Property
	
	Private Property Application.ActiveForm As My.Sys.Forms.Form Ptr
		Return FActiveForm
	End Property
	
	Private Property Application.ActiveForm(Value As My.Sys.Forms.Form Ptr)
		FActiveForm = Value
		'		#ifdef __USE_WINAPI__
		'			If Value Then SetForegroundWindow(Value->Handle)
		'		#endif
	End Property
	
	Private Property Application.ActiveMDIChild As My.Sys.Forms.Form Ptr
		Return FActiveMDIChild
	End Property
	
	Private Property Application.ActiveMDIChild(Value As My.Sys.Forms.Form Ptr)
		FActiveMDIChild = Value
		'		#ifdef __USE_WINAPI__
		'			If Value Then SetForegroundWindow(Value->Handle)
		'		#endif
	End Property
	
	Private Property Application.MainForm As My.Sys.Forms.Form Ptr
		'        For i As Integer = 0 To FormCount -1
		'            If (Forms[i]->ExStyle AND WS_EX_APPWINDOW) = WS_EX_APPWINDOW Then
		'                FMainForm = Forms[i]
		Return FMainForm
		'            End If
		'        Next i
	End Property
	
	Private Property Application.MainForm(Value As My.Sys.Forms.Form Ptr)
		FMainForm = Value
		#ifdef __USE_GTK__
			If FMainForm AndAlso FMainForm->Handle Then g_signal_connect(FMainForm->Handle, "delete-event", G_CALLBACK(@gtk_main_quit), NULL)
		#elseif defined(__USE_JNI__)
			My.Sys.Forms.AppMainForm = FMainForm
		#endif
	End Property
	
	#ifndef Application_ControlCount_Get_Off
		Private Property Application.ControlCount As Integer
			GetControls
			Return FControlCount
		End Property
	#endif
	
	Private Property Application.ControlCount(Value  As Integer)
	End Property
	
	#ifndef Application_Controls_Get_Off
		Private Property Application.Controls As My.Sys.Forms.Control Ptr Ptr
			GetControls
			Return FControls
		End Property
	#endif
	
	Private Property Application.Controls(Value  As My.Sys.Forms.Control Ptr Ptr)
	End Property
	
	Private Function Application.FormCount As Integer
		GetForms
		Return FFormCount
	End Function
	
	#ifndef Application_Forms_Get_Off
		Private Property Application.Forms As My.Sys.Forms.Form Ptr Ptr
			GetForms
			Return FForms
		End Property
	#endif
	
	Private Property Application.Forms(Value  As My.Sys.Forms.Form Ptr Ptr)
	End Property
	
	'	Property Application.HintColor As Integer
	'		Return FHintColor
	'	End Property
	'
	'	Property Application.HintColor(value As Integer)
	'		Dim As Integer i
	'		FHintColor = value
	'		For i = 0 To ControlCount -1
	'			#ifndef __USE_GTK__
	'				If Controls[i]->ToolTipHandle Then SendMessage(Controls[i]->ToolTipHandle,TTM_SETTIPBKCOLOR,value,0)
	'			#endif
	'		Next i
	'	End Property
	'
	'	Property Application.HintPause As Integer
	'		Return FHintPause
	'	End Property
	'
	'	Property Application.HintPause (value As Integer)
	'		Dim As Integer i
	'		FHintPause = value
	'		For i = 0 To ControlCount -1
	'			#ifndef __USE_GTK__
	'				If Controls[i]->ToolTipHandle Then SendMessage(Controls[i]->ToolTipHandle,TTM_SETDELAYTIME,TTDT_INITIAL,value)
	'			#endif
	'		Next i
	'	End Property
	'
	'	Property Application.HintShortPause As Integer
	'		Return FHintShortPause
	'	End Property
	'
	'	Property Application.HintShortPause(value As Integer)
	'		Dim As Integer i
	'		FHintShortPause = value
	'		For i = 0 To ControlCount -1
	'			#ifndef __USE_GTK__
	'				If Controls[i]->ToolTipHandle Then SendMessage(Controls[i]->ToolTipHandle,TTM_SETDELAYTIME,TTDT_RESHOW,value)
	'			#endif
	'		Next i
	'	End Property
	'
	'	Property Application.HintHidePause As Integer
	'		Return FHintHidePause
	'	End Property
	'
	'	Property Application.HintHidePause(value As Integer)
	'		Dim As Integer i
	'		FHintHidePause = value
	'		For i = 0 To ControlCount -1
	'			#ifndef __USE_GTK__
	'				If Controls[i]->ToolTipHandle Then SendMessage(Controls[i]->ToolTipHandle,TTM_SETDELAYTIME,TTDT_AUTOPOP,value)
	'			#endif
	'		Next i
	'	End Property
	
	Private Sub Application.HelpCommand(CommandID As Integer,FData As Long)
		#ifdef __USE_WINAPI__
			If MainForm Then WinHelp(MainForm->Handle, HelpFile, CommandID, FData)
		#endif
	End Sub
	
	Private Sub Application.HelpContext(ContextID As Long)
		#ifdef __USE_WINAPI__
			If MainForm Then WinHelp(MainForm->Handle,HelpFile,HELP_CONTEXT,ContextID)
		#endif
	End Sub
	
	Private Sub Application.HelpJump(TopicID As String)
		Dim StrFmt As String
		StrFmt = "JumpID(" + Chr(34) + Chr(34) + ","+ Chr(34) + TopicID + Chr(34) + ")"+ Chr(0)
		If MainForm Then
			#ifdef __USE_WINAPI__
				If WinHelp(MainForm->Handle,HelpFile,HELP_COMMAND,CInt(StrPtr(StrFmt))) = 0 Then
					WinHelp(MainForm->Handle,HelpFile,HELP_CONTENTS,NULL)
				End If
			#endif
		End If
	End Sub
	
	Private Sub Application.Run
		#ifdef __USE_GTK__
			'gdk_threads_enter()
			gtk_main()
			'gdk_threads_leave()
		#elseif defined(__USE_WINAPI__)
			Dim As MSG msg
			If FormCount = 0 Then
				End 10
			End If
			Dim mess As Message
			Dim TranslateAndDispatch As Boolean
			While GetMessage(@msg, NULL, 0, 0)
				TranslateAndDispatch = True
				If FActiveForm <> 0 Then
					If FActiveForm->Accelerator Then TranslateAndDispatch = TranslateAccelerator(FActiveForm->Handle, FActiveForm->Accelerator, @msg) = 0
					'If FActiveForm->Parent AndAlso FActiveForm->Parent->Accelerator Then TranslateAndDispatch = TranslateAccelerator(FActiveForm->Parent->Handle, FActiveForm->Parent->Accelerator, @msg) = 0
					If TranslateAndDispatch Then
						Select Case msg.message
						Case WM_KEYDOWN
							Select Case msg.wParam
							Case VK_TAB ', VK_LEFT, VK_UP, VK_DOWN, VK_RIGHT, VK_PRIOR, VK_NEXT
								'If Not GetFocus() = FActiveForm->Handle Then
								FActiveForm->SelectNextControl(GetKeyState(VK_SHIFT) And 8000)
								'TranslateAndDispatch = False
								'ElseIf IsDialogMessage(FActiveForm->Handle, @Msg) Then
								'	TranslateAndDispatch = False
								'End If
								'								Dim KeyStateArray(256) As Byte
								'								Dim As Integer OldState
								'								Dim As Boolean bSet
								'								If Not GetFocus() = FActiveForm->Handle Then
								'									bSet = True
								'									GetKeyboardState(ByVal VarPtr(keyStateArray(0)))
								'									OldState = KeyStateArray(VK_SHIFT)
								'									KeyStateArray(VK_SHIFT) = IIf(GetKeyState(VK_SHIFT) And 8000, 0, -127)
								'									SetKeyboardState(ByVal VarPtr(keyStateArray(0)))
								'								End If
								'								If IsDialogMessage(FActiveForm->Handle, @Msg) Then
								'									TranslateAndDispatch = False
								'								End If
								'								If bSet Then
								'									KeyStateArray(VK_SHIFT) = OldState
								'									SetKeyboardState(ByVal VarPtr(keyStateArray(0)))
								'								End If
							End Select
						End Select
					End If
				End If
				If OnMessage Then
					mess = Type(@This, msg.hwnd, msg.message, msg.wParam, msg.lParam, 0, LoWord(msg.wParam), HiWord(msg.wParam), LoWord(msg.lParam), HiWord(msg.lParam), 0)
					OnMessage(mess)
					If mess.Result Then TranslateAndDispatch = False
				End If
				If FActiveForm <> 0 AndAlso FActiveForm->KeyPreview Then
					Select Case msg.message
					Case WM_KEYDOWN, WM_KEYUP, WM_CHAR
						mess = Type(@This, msg.hwnd, msg.message, msg.wParam, msg.lParam, 0, LoWord(msg.wParam), HiWord(msg.wParam), LoWord(msg.lParam), HiWord(msg.lParam), 0)
						FActiveForm->ProcessMessage(mess)
						If mess.Result Then TranslateAndDispatch = False
					End Select
				End If
				If TranslateAndDispatch Then
					TranslateMessage @msg
					DispatchMessage @msg
				End If
				MouseX = msg.pt.X
				MouseY = msg.pt.Y
				If OnMouseMove Then OnMouseMove(MouseX, MouseY)
			Wend
		#endif
	End Sub
	
	Private Sub Application.Terminate
		#ifdef __USE_WINAPI__
			PostQuitMessage(0)
		#endif
		End 1
	End Sub
	
	#ifndef Application_DoEvents_Off
		Private Sub Application.DoEvents
			#ifdef __USE_GTK__
				While gtk_events_pending()
					gtk_main_iteration
				Wend
			#elseif defined(__USE_WINAPI__)
				Dim As MSG M
				While PeekMessage(@M, NULL, 0, 0, PM_REMOVE)
					If M.message <> WM_QUIT Then
						TranslateMessage @M
						DispatchMessage @M
					Else
						If (GetWindowLong(M.hwnd,GWL_EXSTYLE) And WS_EX_APPWINDOW) = WS_EX_APPWINDOW Then End -1
					End If
				Wend
			#endif
		End Sub
	#endif
	
	Private Function Application.IndexOfControl(Control As My.Sys.Forms.Control Ptr) As Integer
		Dim As Integer i
		For i = 0 To ControlCount -1
			If Controls[i] = Control Then Return i
		Next i
		Return -1
	End Function
	
	#ifdef __USE_WINAPI__
		Private Function Application.FindControl(ControlHandle As HWND) As My.Sys.Forms.Control Ptr
			Dim As Integer i
			If Controls Then
				For i = 0 To ControlCount -1
					If Controls[i]->Handle = ControlHandle Then Return Controls[i]
				Next i
			End If
			Return NULL
		End Function
	#endif
	
	Private Function Application.FindControl(ControlName As String) As My.Sys.Forms.Control Ptr
		Dim As Integer i
		If Controls Then
			For i = 0 To ControlCount -1
				If UCase(Controls[i]->Name) = UCase(ControlName) Then Return Controls[i]
			Next i
		End If
		Return 0
	End Function
	
	Private Function Application.IndexOfForm(Form As My.Sys.Forms.Form Ptr) As Integer
		Dim As Integer i
		If Forms Then
			For i = 0 To FormCount -1
				If Forms[i] = Form Then Return i
			Next i
		End If
		Return -1
	End Function
	
	#ifdef __USE_WINAPI__
		Private Function Application.EnumThreadWindowsProc(FWindow As HWND, LData As LPARAM) As BOOL
			Dim As My.Sys.Forms.Form Ptr AForm
			Dim As Application Ptr Appl
			Appl = Cast(Application Ptr, LData)
			AForm = Cast(My.Sys.Forms.Form Ptr, GetWindowLongPtr(FWindow, GWLP_USERDATA))
			If Appl Then
				If AForm Then
					With QApplication(Appl)
						.FFormCount += 1
						.FForms = _Reallocate(.FForms, SizeOf(My.Sys.Forms.Form Ptr) * .FFormCount)
						.FForms[.FFormCount - 1] = AForm
					End With
				End If
			End If
			Return True
		End Function
	#endif
	
	Private Sub Application.GetForms
		'FForms = 0 'CAllocate_(0)
		FFormCount = 0
		#ifdef __USE_WINAPI__
			EnumThreadWindows GetCurrentThreadId, Cast(WNDENUMPROC,@EnumThreadWindowsProc),Cast(LPARAM,@This)
		#endif
	End Sub
	
	#ifndef Application_GetControls_Off
		Private Sub Application.EnumControls(Control As My.Sys.Forms.Control)
			Dim As Integer i
			For i = 0 To Control.ControlCount -1
				FControlCount += 1
				FControls = _Reallocate(FControls,SizeOf(My.Sys.Forms.Control Ptr)*FControlCount)
				FControls[FControlCount -1] = Control.Controls[i]
				EnumControls(*Control.Controls[i])
			Next i
		End Sub
		
		Private Sub Application.GetControls
			Dim As Integer i
			'FControls = 0 ' CAllocate_(0)
			FControlCount = 0
			For i = 0 To FormCount -1
				EnumControls(*Forms[i])
			Next i
		End Sub
	#endif
	
	#ifdef __USE_WINAPI__
		Private Function Application.EnumFontsProc(LogFont As LOGFONT Ptr, TextMetric As TEXTMETRIC Ptr, FontStyle As DWORD, hData As LPARAM) As Integer
			Cast(WStringList Ptr, hData)->Add(LogFont->lfFaceName)
			Return True
		End Function
	#endif
	
	Private Sub Application.GetFonts
		#ifdef __USE_WINAPI__
			Dim DC    As HDC
			Dim LFont As LOGFONTA
			DC = GetDC(HWND_DESKTOP)
			LFont.lfCharSet = DEFAULT_CHARSET
		#endif
		Fonts.Clear
		'       EnumFontFamilies(DC,NULL,@EnumFontsProc,Cint(@Fonts)) 'OR
		'EnumFontFamiliesEx(DC,@LFont,@EnumFontsProc,CInt(@s), 0)
		'EnumFonts(DC,NULL,@EnumFontsProc,CInt(NULL))
		#ifdef __USE_WINAPI__
			ReleaseDC(HWND_DESKTOP,DC)
		#endif
	End Sub
	
	Private Operator Application.Cast As Any Ptr
		Return @This
	End Operator
	
	#ifndef Application_GetVerInfo_Off
		Private Function Application.GetVerInfo(ByRef InfoName As String) As String
			Dim As ULong iret
			If TranslationString = "" Then Return ""
			Dim As WString Ptr value = 0
			Dim As String FullInfoName = $"\StringFileInfo\" & TranslationString & "\" & InfoName
			#ifdef __USE_WINAPI__
				If VerQueryValue(_vinfo, FullInfoName, @value, @iret) Then
					''~ value = cast( zstring ptr, vqinfo )
				End If
			#endif
			Return WGet(value)
		End Function
	#endif
	
	Private Constructor Application
		If pApp = 0 Then pApp = @This
		#ifdef __USE_GTK__
			'g_thread_init(NULL)
			#ifdef __USE_GTK4__
				gdk_threads_init()
			#else
				#ifdef __FB_WIN32__
					g_thread_init(NULL)
				#else
					gdk_threads_init()
				#endif
			#endif
			#ifdef __USE_GTK4__
				gtk_init()
			#else
				gtk_init(NULL, NULL)
			#endif
			
			gtk_icon_theme_append_search_path(gtk_icon_theme_get_default(), ToUtf8(ExePath & "/resources"))
			gtk_icon_theme_append_search_path(gtk_icon_theme_get_default(), ToUtf8(ExePath & "/Resources"))
			'gtk_icon_theme_add_resource_path(gtk_icon_theme_get_default(), exepath & "/resources")
			'Dim As GList Ptr l = gtk_icon_theme_list_icons(gtk_icon_theme_get_default(), null)
			'while (l)
			'	If StartsWith(*Cast(Zstring ptr, l->Data), "VisualFBEditor") Then
			'		?*Cast(Zstring ptr, l->Data)
			'	End If
			'	If StartsWith(*Cast(Zstring ptr, l->Data), "Logo") Then
			'		?*Cast(Zstring ptr, l->Data)
			'	End If
			'	l = l->Next
			'Wend
		#elseif defined(__USE_JNI__)
			
		#elseif defined(__USE_WINAPI__)
			Const ICC_ALL =  _
			ICC_ANIMATE_CLASS      Or _
			ICC_BAR_CLASSES        Or _
			ICC_COOL_CLASSES       Or _
			ICC_DATE_CLASSES       Or _
			ICC_HOTKEY_CLASS       Or _
			ICC_INTERNET_CLASSES   Or _
			ICC_LINK_CLASS         Or _
			ICC_LISTVIEW_CLASSES   Or _
			ICC_NATIVEFNTCTL_CLASS Or _
			ICC_PAGESCROLLER_CLASS Or _
			ICC_PROGRESS_CLASS     Or _
			ICC_STANDARD_CLASSES   Or _
			ICC_TAB_CLASSES        Or _
			ICC_TREEVIEW_CLASSES   Or _
			ICC_UPDOWN_CLASS       Or _
			ICC_USEREX_CLASSES
			Dim As INITCOMMONCONTROLSEX ccx
			With ccx
				.dwSize = SizeOf(INITCOMMONCONTROLSEX)
				.dwICC  = ICC_ALL ' ICC_STANDARD_CLASSES
			End With
			INITCOMMONCONTROLSEX(@ccx)
			'InitCommonControls
			Instance = GetModuleHandle(NULL)
		#endif
		GetFonts
		#ifdef __USE_WINAPI__
			Dim As DWORD ret, discard
		#endif
		This.initialized = False
		This._vinfo = 0
		ExeName
		#ifdef __USE_WINAPI__
			ret = GetFileVersionInfoSize(FFileName, @discard)
			If ret <> 0 Then
				This._vinfo = _Allocate(ret)
				If This._vinfo Then
					If GetFileVersionInfo(FFileName, 0, ret, This._vinfo) Then
						Dim As Unsigned Short Ptr ulTranslation
						Dim As ULong iret
						If VerQueryValue(_vinfo, $"\VarFileInfo\Translation", @ulTranslation, @iret) Then
							TranslationString = Hex(ulTranslation[0], 4) & Hex(ulTranslation[1], 4)
						End If
						This.initialized = True
					End If
				End If
			End If
		#endif
	End Constructor
	
	Private Destructor Application
		If pApp = @This Then pApp = 0
		If FForms Then _Deallocate( FForms)
		If FFileName Then _Deallocate( FFileName)
		If FExeName Then _Deallocate( FExeName)
		If FTitle Then _Deallocate( FTitle)
		If FControls Then _Deallocate( FControls)
		If This._vinfo <> 0 Then _Deallocate((This._vinfo)) : This._vinfo = 0
	End Destructor
End Namespace

#ifdef _DebugWindow_
	Dim Shared As Any Ptr DebugWindowHandle = Cast(Any Ptr, _DebugWindow_)
#else
	Dim Shared As Any Ptr DebugWindowHandle
#endif

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
		Private Sub Print Overload(ByVal Msg As Integer, ByVal Msg1 As Integer = -1, ByVal Msg2 As Integer = -1, ByVal Msg3 As Integer = -1, ByVal Msg4 As Integer = -1, bWriteLog As Boolean = False, bPrintMsg As Boolean = False, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
			Dim As WString Ptr tMsgPtr
			WLet(tMsgPtr, Str(Msg))
			If Msg1 <> -1 Then WAdd(tMsgPtr, Chr(9) & Msg1)
			If Msg2 <> -1 Then WAdd(tMsgPtr, Chr(9) & Msg2)
			If Msg3 <> -1 Then WAdd(tMsgPtr, Chr(9) & Msg3)
			If Msg4 <> -1 Then WAdd(tMsgPtr, Chr(9) & Msg4)
			Print(*tMsgPtr, bWriteLog, bPrintMsg, bShowMsg, bPrintToDebugWindow)
			_Deallocate(tMsgPtr)
		End Sub
		
		Private Sub Print Overload(ByRef Msg As WString, ByRef Msg1 As Const WString = "", ByRef Msg2 As Const WString = "", ByRef Msg3 As Const WString = "", ByRef Msg4 As Const WString = "", bWriteLog As Boolean = False, bPrintMsg As Boolean = False, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
			Dim As WString Ptr tMsgPtr
			WLet(tMsgPtr, Msg)
			If Msg1 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg1)
			If Msg2 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg2)
			If Msg3 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg3)
			If Msg4 <> "" Then WAdd(tMsgPtr, Chr(9) & Msg4)
			Print(*tMsgPtr, bWriteLog, bPrintMsg, bShowMsg, bPrintToDebugWindow)
			_Deallocate(tMsgPtr)
		End Sub
		
		Private Sub Print Overload(ByRef Msg As UString, bWriteLog As Boolean = False, bPrintMsg As Boolean = False, bShowMsg As Boolean = False, bPrintToDebugWindow As Boolean = True)
			If bWriteLog Then
				Dim As Integer Result, Fn = FreeFile_
				Result = Open(ExePath & "/DebugInfo.log" For Append As #Fn) 'Encoding "utf-8" Can not be using in the same mode
				If Result = 0 Then
					.Print #Fn, __DATE_ISO__ & " " & Time & Chr(9) & Msg & Space(20) 'cut some word if some unicode inside.
				End If
				CloseFile_(Fn)
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

#ifdef __USE_GTK4__
	Dim Shared DialogResult As gint
	Sub gtk_dialog_response_sub(dialog As GtkDialog Ptr, response_id As gint)
		DialogResult = response_id
	End Sub
#endif

Public Function MsgBox Alias "MsgBox" (ByRef MsgStr As WString, ByRef Caption As WString = "", MsgType As MessageType = MessageType.mtInfo, ButtonsType As ButtonsTypes = ButtonsTypes.btOK) As MessageResult
	Dim As Integer Result = -1
	Dim As WString Ptr FCaption
	Dim As Integer MsgTypeIn, ButtonsTypeIn
	WLet(FCaption, Caption)
	Dim As My.Sys.Forms.Control Ptr ActiveForm
	If *FCaption = "" Then WLet(FCaption, App.Title)
	'    For i As Integer = 0 To App.FormCount -1
	'        If GetActiveWindow = App.Forms[i]->Handle Then ActiveForm = App.Forms[i]
	'        If App.Forms[i]->Handle Then App.Forms[i]->Enabled = False
	'    Next i
	#ifdef __USE_WINAPI__
		Dim As HWND Wnd
	#endif
	'    If ActiveForm Then
	'       If ActiveForm->Handle Then
	'          Wnd = ActiveForm->Handle
	'       Else
	'          Wnd = MainHandle
	'       End If
	'    End If
	#ifdef __USE_GTK__
		Dim As GtkWidget Ptr dialog
		Dim As GtkWindow Ptr win
		If pApp->MainForm Then
			win = GTK_WINDOW(pApp->MainForm->Handle)
		End If
		Select Case MsgType
		Case mtInfo: MsgTypeIn = GTK_MESSAGE_INFO
		Case mtWarning: MsgTypeIn = GTK_MESSAGE_WARNING
		Case mtQuestion: MsgTypeIn = GTK_MESSAGE_QUESTION
		Case mtError: MsgTypeIn = GTK_MESSAGE_ERROR
		Case mtOther: MsgTypeIn = GTK_MESSAGE_OTHER
		End Select
		Select Case ButtonsType
		Case btNone: ButtonsTypeIn = GTK_BUTTONS_NONE
		Case btOK: ButtonsTypeIn = GTK_BUTTONS_OK
		Case btYesNo: ButtonsTypeIn = GTK_BUTTONS_YES_NO
		Case btYesNoCancel: ButtonsTypeIn = GTK_BUTTONS_YES_NO
		Case btOkCancel: ButtonsTypeIn = GTK_BUTTONS_OK_CANCEL
		End Select
		dialog = gtk_message_dialog_new (win, _
		GTK_DIALOG_DESTROY_WITH_PARENT Or GTK_DIALOG_MODAL, _
		MsgTypeIn, _
		IIf(ButtonsType = btYesNoCancel, btNone, ButtonsTypeIn), _
		ToUtf8(MsgStr), _
		NULL)
		gtk_window_set_transient_for(GTK_WINDOW(dialog), win)
		gtk_window_set_title(GTK_WINDOW(dialog), ToUtf8(*FCaption))
		If ButtonsType = btYesNoCancel Then
			#ifdef __USE_GTK4__
				gtk_dialog_add_button(GTK_DIALOG(dialog), "gtk-cancel", GTK_RESPONSE_CANCEL)
				gtk_dialog_add_button(GTK_DIALOG(dialog), "gtk-no", GTK_RESPONSE_NO)
				gtk_dialog_add_button(GTK_DIALOG(dialog), "gtk-yes", GTK_RESPONSE_YES)
			#else
				#ifndef __USE_GTK2__
					gtk_dialog_add_button(GTK_DIALOG(dialog), ToUtf8(*Cast(WString Ptr, GTK_STOCK_CANCEL)), GTK_RESPONSE_CANCEL)
					gtk_dialog_add_button(GTK_DIALOG(dialog), ToUtf8(*Cast(WString Ptr, GTK_STOCK_NO)), GTK_RESPONSE_NO)
					gtk_dialog_add_button(GTK_DIALOG(dialog), ToUtf8(*Cast(WString Ptr, GTK_STOCK_YES)), GTK_RESPONSE_YES)
				#else
					gtk_dialog_add_button(GTK_DIALOG(dialog), GTK_STOCK_CANCEL, GTK_RESPONSE_CANCEL)
					gtk_dialog_add_button(GTK_DIALOG(dialog), GTK_STOCK_NO, GTK_RESPONSE_NO)
					gtk_dialog_add_button(GTK_DIALOG(dialog), GTK_STOCK_YES, GTK_RESPONSE_YES)
				#endif
			#endif
			gtk_dialog_set_default_response(GTK_DIALOG(dialog), GTK_RESPONSE_YES)
		End If
		#ifdef __USE_GTK4__
			g_signal_connect_swapped (dialog, "response", G_CALLBACK(@gtk_dialog_response_sub), dialog)
			gtk_widget_set_visible(dialog, True)
			Result = DialogResult
		#else
			Result = gtk_dialog_run (GTK_DIALOG (dialog))
		#endif
		Select Case Result
		Case GTK_RESPONSE_CANCEL: Result = mrCancel
		Case GTK_RESPONSE_NO: Result = mrNo
		Case GTK_RESPONSE_OK: Result = mrOK
		Case GTK_RESPONSE_YES: Result = mrYes
		End Select
		#ifdef __USE_GTK4__
			g_object_unref(dialog)
		#else
			gtk_widget_destroy(dialog)
		#endif
	#elseif defined(__USE_WINAPI__)
		'		Wnd = GetActiveWindow()
		'		If App.MainForm <> 0 Then
		'			Wnd = App.MainForm->Handle
		'		End If
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
		Result = MessageBox(0, @MsgStr, FCaption, MsgTypeIn Or ButtonsTypeIn Or MB_TOPMOST Or MB_TASKMODAL)
		Select Case Result
		Case IDABORT: Result = mrAbort
		Case IDCANCEL: Result = mrCancel
		Case IDIGNORE: Result = mrIgnore
		Case IDNO: Result = mrNo
		Case IDOK: Result = mrOK
		Case IDRETRY: Result = mrRetry
		Case IDYES: Result = mrYes
		End Select
	#endif
	'Do
	'    App.DoEvents
	'Loop Until Result <> -1
	'    For i As Integer = 0 To App.FormCount -1
	'        If App.Forms[i]->Handle Then App.Forms[i]->Enabled = True
	'    Next i
	WDeAllocate(FCaption)
	Return Result
End Function

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

Function InputBox(ByRef sCaption As WString  = "" , ByRef sMessageText As WString = "Enter text:" , ByRef sDefaultText As WString = "" , iFlag As Long = 0 , iFlag2 As Long = 0, hParentWin As Any Ptr = 0) As UString __EXPORT__
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
					Dim As UString sRet = InputBox_.mess
					Function = sRet
					DestroyWindow(InputBox_.hWnd)
					InputBox_.flag=0
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

#ifdef __EXPORT_PROCS__
	Function ApplicationMainForm Alias "ApplicationMainForm" (App As My.Application Ptr) As My.Sys.Forms.Control Ptr __EXPORT__
		Return App->MainForm
	End Function
	
	Function ApplicationFileName Alias "ApplicationFileName"(App As My.Application Ptr) ByRef As WString __EXPORT__
		Return App->FileName
	End Function
#endif
