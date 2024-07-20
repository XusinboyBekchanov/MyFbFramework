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

'Provides methods and properties to manage an application, such as methods to start and stop an application, to process messages, and properties to get information about an application.
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
	#ifndef VER_BUILD
		#define VER_BUILD "0"
	#endif
	
	Private Function Application.Version As String
		Return GetVerInfo("FileVersion")
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
	
	Private Property Application.CurLanguagePath ByRef As WString
		If FCurLanguagePath = 0 Then WLet(FCurLanguagePath, ExePath & "/Languages/")
			Return *FCurLanguagePath
	End Property
	
	Private Property Application.CurLanguagePath(ByRef Value As WString)
		If *FCurLanguagePath = Value Then Return
		WLet(FCurLanguagePath, Value)
	End Property
	
	Private Property Application.CurLanguage ByRef As WString
		If FCurLanguage = 0 Then 
			WLet(FCurLanguage, *FLanguage)
		End If
		Return *FCurLanguage
	End Property
	
	Private Property Application.CurLanguage(ByRef Value As WString)
		If LCase(Value) = LCase(*FLanguage) OrElse Value = "" OrElse LCase(Value) = LCase(*FCurLanguage) Then Return
		mlKeys.Clear
		Dim As Integer i, Pos1, Pos2
		Dim As Integer Fn = FreeFile, Result
		Dim As WString * 2048 Buff, tKey
		Dim As Boolean StartGeneral = False
		Dim As UString LanguageFile = *FCurLanguagePath & Value & ".lng"
		Result = Open(LanguageFile For Input Encoding "utf-8" As #Fn)
		If Result <> 0 Then Result = Open(LanguageFile For Input Encoding "utf-16" As #Fn)
		If Result <> 0 Then Result = Open(LanguageFile For Input Encoding "utf-32" As #Fn)
		If Result <> 0 Then Result = Open(LanguageFile For Input As #Fn)
		If Result = 0 Then
			Do Until EOF(Fn)
				Line Input #Fn, Buff
				If LCase(Trim(Buff)) = "[general]" Then StartGeneral = True : Continue Do
				Pos1 = InStr(Buff, "=")
				If StartGeneral AndAlso Len(Trim(Buff, Any !"\t ")) > 0 AndAlso Pos1 > 0 Then
					Pos2 = InStr(Pos1, Buff, "|")
					tKey = Trim(Mid(Buff, 1, Pos1 - 1), Any !"\t ")
					Var Pos3 = InStr(Buff, "~")
					If Pos3 > 0 AndAlso Pos3 < Pos1 Then Buff = Replace(Buff, "~", "=")
					If Trim(Mid(Buff, Pos1 + 1), Any !"\t ") <> "" Then mlKeys.Add Trim(Left(Buff, Pos1 - 1), Any !"\t "), Trim(Mid(Buff, Pos1 + 1), Any !"\t ")
				End If
			Loop
			mlKeys.SortKeys
			Close(Fn)
			WLet(FCurLanguage, Value)
		Else
			Print ML("Open file failure!") &  " " & ML("in function") & " Application.CurLanguage. File Name: " &  LanguageFile
		End If
	End Property
	
	Private Property Application.Language ByRef As WString
		Return WGet(FLanguage)
	End Property
	
	Private Property Application.Language(ByRef Value As WString)
		WLet(FLanguage, Value)
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
					#elseif defined(__USE_WASM__)
						If MainForm Then
							WLet(FTitle, MainForm->Text)
						End If
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
		Dim As WString * 255 Tx
		Dim As WString*225 s, En
		Dim As Integer L, i, k
		#if defined(__FB_WIN32__) AndAlso Not defined(__USE_GTK4__)
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
				Tx = Command(0)
				L = Len(Tx)
				'L = readlink("/proc/self/exe", @Tx, 255 - 1)
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
			#if defined(__FB_WIN32__) AndAlso Not defined(__USE_GTK4__)
				Dim As ULong iret
				If TranslationString = "" Then Return ""
				Dim As WString Ptr value = 0
				Dim As String FullInfoName = $"\StringFileInfo\" & TranslationString & "\" & InfoName
				If VerQueryValue(_vinfo, FullInfoName, @value, @iret) Then
					''~ value = cast( zstring ptr, vqinfo )
				End If
				Return WGet(value)
			#else
				If InfoName = "ProductVersion" Then
					Return VER_MAJOR & "." & VER_MINOR & "." & VER_PATCH
				ElseIf InfoName = "FileVersion" Then
					Return VER_MAJOR & "." & VER_MINOR & "." & VER_PATCH & "." & VER_BUILD
				End If
			#endif
		End Function
	#endif
	
	#ifdef __USE_GTK4__
		#define generic_gtk_init() gtk_init()
	#else
		#define generic_gtk_init() gtk_init(0, 0)
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
			generic_gtk_init()
			
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
		WLet(FCurLanguagePath, ExePath & "/Languages/")
		GetFonts
		This.initialized = False
		This._vinfo = 0
		WLet(FLanguage, "")
		ExeName
		#if defined(__FB_WIN32__) AndAlso Not defined(__USE_GTK4__)
			Dim As DWORD ret, discard
			ret = GetFileVersionInfoSize(FFileName, @discard)
			If ret <> 0 Then
				This._vinfo = _Allocate(ret)
				If This._vinfo Then
					If GetFileVersionInfo(FFileName, 0, ret, This._vinfo) Then
						Dim As Unsigned Short Ptr ulTranslation
						Dim As ULong iret
						If VerQueryValue(_vinfo, $"\VarFileInfo\Translation", @ulTranslation, @iret) Then
							Dim As WString * LOCALE_NAME_MAX_LENGTH AppLanguage
							GetLocaleInfo(ulTranslation[0], LOCALE_SENGLANGUAGE, @AppLanguage, LOCALE_NAME_MAX_LENGTH)
							WLet(FLanguage, AppLanguage)
							TranslationString = Hex(ulTranslation[0], 4) & Hex(ulTranslation[1], 4)
						End If
						This.initialized = True
					End If
				End If
			End If
		#else
			WLet(FLanguage, "English")
		#endif
	End Constructor
	
	Private Destructor Application
		If pApp = @This Then pApp = 0
		If FForms Then _Deallocate( FForms)
		If FFileName Then _Deallocate( FFileName)
		If FExeName Then _Deallocate( FExeName)
		If FTitle Then _Deallocate( FTitle)
		If FControls Then _Deallocate( FControls)
		If FCurLanguage Then _Deallocate( FCurLanguage)
		If FCurLanguagePath Then _Deallocate( FCurLanguagePath)
		If FLanguage Then _Deallocate( FLanguage)
		If This._vinfo <> 0 Then _Deallocate((This._vinfo)) : This._vinfo = 0
	End Destructor
End Namespace

Public Function ML(ByRef V As WString) ByRef As WString
	If App.CurLanguage = App.Language Then Return V
	Dim As Integer tIndex = mlKeys.IndexOfKey(V) ' For improve the speed
	If tIndex >= 0 Then
		Return mlKeys.Item(tIndex)->Text
	Else
		tIndex = mlKeys.IndexOfKey(Replace(V, "&", "")) '
		If tIndex >= 0 Then Return mlKeys.Item(tIndex)->Text Else Return V
	End If
End Function

#ifdef __EXPORT_PROCS__
	Function ApplicationMainForm Alias "ApplicationMainForm" (App As My.Application Ptr) As My.Sys.Forms.Control Ptr __EXPORT__
		Return App->MainForm
	End Function
	
	Function ApplicationFileName Alias "ApplicationFileName"(App As My.Application Ptr) ByRef As WString __EXPORT__
		Return App->FileName
	End Function
#endif
