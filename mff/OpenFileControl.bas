'###############################################################################
'#  Dialogs.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   Dialogs.bi                                                                #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "OpenFileControl.bi"

Namespace My.Sys.Forms
	Function OpenFileControl.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "defaultext": Return FDefaultExt
		Case "filename": WLet FFileName, FileName: Return FFileName
		Case "filetitle": WLet FFileTitle, FileTitle: Return FFileTitle
		Case "filter": Return FFilter
		Case "initialdir": WLet FInitialDir, InitialDir: Return FInitialDir
		Case "multiselect": Return @FMultiSelect
		Case "tabindex": Return @FTabIndex
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function OpenFileControl.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "defaultext": DefaultExt = QWString(Value)
		Case "filename": FileName = QWString(Value)
		Case "filetitle": FileTitle = QWString(Value)
		Case "filter": Filter = QWString(Value)
		Case "initialdir": InitialDir = QWString(Value)
		Case "multiselect": MultiSelect = QBoolean(Value)
		Case "tabindex": TabIndex = QInteger(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Property OpenFileControl.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Property OpenFileControl.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Property OpenFileControl.TabStop As Boolean
		Return FTabStop
	End Property
	
	Property OpenFileControl.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Property OpenFileControl.MultiSelect As Boolean
		Return FMultiSelect
	End Property
	
	Property OpenFileControl.MultiSelect(Value As Boolean)
		FMultiSelect = Value
		If Value Then
			Options.Include ofAllowMultiSelect
		Else
			Options.Exclude ofAllowMultiSelect
		End If
	End Property
	
	Property OpenFileControl.InitialDir ByRef As WString
		Return WGet(FInitialDir)
	End Property
	
	Property OpenFileControl.InitialDir(ByRef Value As WString)
		FInitialDir    = Reallocate_(FInitialDir, (Len(Value) + 1) * SizeOf(WString))
		*FInitialDir = Value
	End Property
	
	Property OpenFileControl.DefaultExt ByRef As WString
		Return WGet(FDefaultExt)
	End Property
	
	Property OpenFileControl.DefaultExt(ByRef Value As WString)
		FDefaultExt    = Reallocate_(FDefaultExt, (Len(Value) + 1) * SizeOf(WString))
		*FDefaultExt = Value
	End Property
	
	Property OpenFileControl.FileName ByRef As WString
		If FHandle Then
			#ifdef __USE_GTK__
				WLet FFileName, WStr(*gtk_file_chooser_get_filename(GTK_FILE_CHOOSER(widget)))
			#else
				Dim As Integer iSize = 1024
				Dim As WString * 1024 Path
				If SendMessage(FHandle, CDM_GETFILEPATH, iSize, Cast(WPARAM, @Path)) > 0 Then
					WLet FFileName, Path
				End If
			#endif
		End If
		Return WGet(FFileName)
	End Property
	
	Property OpenFileControl.FileName(ByRef Value As WString)
		WLet(FFileName, Value)
	End Property
	
	Property OpenFileControl.FileTitle ByRef As WString
		Return WGet(FFileTitle)
	End Property
	
	Property OpenFileControl.FileTitle(ByRef Value As WString)
		WLet(FFileTitle, Value)
	End Property
	
	Property OpenFileControl.Filter ByRef As WString
		Return WGet(FFilter)
	End Property
	
	Property OpenFileControl.Filter(ByRef Value As WString)
		FFilter    = Reallocate_(FFilter, (Len(Value) + 1) * SizeOf(WString))
		*FFilter = Value
	End Property
	
	#ifndef __USE_GTK__
		Function OpenFileControl.Hook(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As UInteger
			Static As OpenFileControl Ptr OpenDial
			Select Case Msg
			Case WM_INITDIALOG
				OpenDial = Cast(OpenFileControl Ptr, Cast(lpOpenFileName, lParam)->lCustData)
				OpenDial->Handle = GetParent(FWindow)
				SetWindowLongPtr(FWindow, GWLP_USERDATA, CInt(OpenDial))
				If OpenDial->Parent = 0 OrElse OpenDial->Parent->Handle = 0 Then SendMessage(GetParent(FWindow), WM_SYSCOMMAND, SC_CLOSE, 0)
				Dim As HWND ModalWnd = GetParent(FWindow)
				'ShowWindow(ModalWnd, SW_HIDE)
				SetWindowLong(ModalWnd, GWL_STYLE, WS_CHILD Or DS_CONTROL)
				SetWindowLong(ModalWnd, GWL_EXSTYLE, WS_EX_CONTROLPARENT)
				SetParent ModalWnd, OpenDial->Parent->Handle
				ShowWindow(GetDlgItem(ModalWnd, IDOK), SW_HIDE)
				ShowWindow(GetDlgItem(ModalWnd, IDCANCEL), SW_HIDE)
				Dim As Rect R
				GetWindowRect GetDlgItem(ModalWnd, cmb13), @R
				MapWindowPoints 0, GetParent(GetDlgItem(ModalWnd, cmb13)), Cast(Point Ptr, @R), 2
				MoveWindow(GetDlgItem(ModalWnd, cmb13), R.Left, R.Top, R.Right - R.Left + 100, R.Bottom - R.Top, True)
				GetWindowRect GetDlgItem(ModalWnd, cmb1), @R
				MapWindowPoints 0, GetParent(GetDlgItem(ModalWnd, cmb1)), Cast(Point Ptr, @R), 2
				MoveWindow(GetDlgItem(ModalWnd, cmb1), R.Left, R.Top, R.Right - R.Left + 100, R.Bottom - R.Top, True)
				If OpenDial->FVisible Then ShowWindow(ModalWnd, SW_SHOWNORMAL)
				'ShowWindow(OpenDial->Parent->Handle, SW_SHOWNORMAL)
				'ChangeStyle WS_CAPTION, False
				'EndDialog ModalWnd, 0
				'ShowWindow(ModalWnd, SW_HIDE)
				'SendMessage(ModalWnd, WM_DESTROY, 0, 0)
			Case WM_NOTIFY
				Dim As OpenFileControl Ptr OpenDial = Cast(OpenFileControl Ptr, GetWindowLongPtr(FWindow, GWLP_USERDATA))
				Dim As OFNOTIFY Ptr POF
				POF = Cast(OFNOTIFY Ptr, lParam)
				Select Case POF->hdr.Code
				Case CDN_FILEOK
					If OpenDial Then If OpenDial->OnFileActivate Then OpenDial->OnFileActivate(*OpenDial)
					SetWindowLongPtr FWindow, DWLP_MSGRESULT, 1
					Return 1
				Case CDN_SELCHANGE
					If OpenDial Then If OpenDial->OnSelectionChange Then OpenDial->OnSelectionChange(*OpenDial)
				Case CDN_FOLDERCHANGE
					If OpenDial Then If OpenDial->OnFolderChange Then OpenDial->OnFolderChange(*OpenDial)
				Case CDN_TYPECHANGE
					Dim As Integer Index
					Index = *Cast(OPENFILENAME Ptr, POF->lpOFN).nFilterIndex
					If OpenDial Then
						OpenDial->FilterIndex = Index
						If OpenDial->OnTypeChange Then
							OpenDial->OnTypeChange(*OpenDial, Index)
						End If
					End If
				Case CDN_INITDONE
					'MoveWindow GetParent(FWindow), -500, -500, 800, 500, True
					'MoveWindow FWindow, 0, 0, 1000, 1000, True
				End Select
			End Select
			Return False
		End Function
	#endif
	
	Sub OpenFileControl.CreateWnd(Param As Any Ptr)
		#ifndef __USE_GTK__
			Dim As OpenFileControl Ptr OpenDial = Param
			On Error Goto ErrorHandler
			Dim bResult As Boolean
			OpenDial->FileNames.Clear
			Dim cwsFile As WString  * (MAX_PATH + 1) * 100
			Dim dwFlags As DWORD = Cast(Integer, OpenDial->Options)
			Dim dwBufLen As DWORD
			Dim wMarkers As WString * 4 = "||"
			If Right(*OpenDial->FFilter, 1) <> "|" Then wMarkers += "|"
			Dim wFilter As WString Ptr '* 260 = ""
			WLet(wFilter, *OpenDial->FFilter & wMarkers)
			Dim dwFilterStrSize As DWORD = Len(wFilter)
			Dim pchar As WChar Ptr = wFilter
			For i As Long = 0 To Len(*wFilter) - 1
				If pchar[i] = Asc("|") Then pchar[i] = 0
			Next
			If WGet(OpenDial->FInitialDir) = "" Then WLet(OpenDial->FInitialDir, CurDir)
			If dwBufLen = 0 Then
				If (dwFlags And OFN_ALLOWMULTISELECT = OFN_ALLOWMULTISELECT) Then dwBufLen = 32768  ' // 64 Kb buffer
			End If
			If dwBufLen < 260 Then dwBufLen = 260
			'WReAllocate cwsFile, Len(*FFileName & "|")
			WLet(OpenDial->FFileTitle, Space(dwBufLen))
			cwsFile = *OpenDial->FFileName & "|"
			Dim cbPos As Long = Len(cwsFile) - 1
			'IF LEN(*cwsFile) < dwBufLen THEN cwsFile = ReAllocate(cwsFile, (dwBufLen + 1) * SizeOf(WString)): *cwsFile += SPACE(dwBufLen - LEN(*cwsFile))
			Dim dwFileStrSize As Integer = Len(cwsFile)
			pchar = @cwsFile
			pchar[cbPos] = 0
			cbPos = Len(*OpenDial->FFileTitle) - 1
			pchar = OpenDial->FFileTitle
			pchar[cbPos] = 0
			Dim ofn As OPENFILENAME
			ZeroMemory(@ofn, SizeOf(ofn))
			ofn.lStructSize     = SizeOf(ofn)
			'If pApp->MainForm Then ofn.hwndOwner       = pApp->MainForm->Handle
			ofn.hwndOwner = 0
			ofn.lpstrFilter     = wFilter
			ofn.nFilterIndex    = 1
			ofn.lpstrFile       = @cwsFile
			ofn.lpstrFileTitle       = OpenDial->FFileTitle
			ofn.nMaxFileTitle       = 256
			'ofn.lpstrFile[0] = 0
			ofn.nMaxFile        = (Max_Path + 1) * 100
			ofn.lpstrInitialDir = OpenDial->FInitialDir
			ofn.Flags = dwFlags
			ofn.lpfnHook           = Cast(LPOFNHOOKPROC, @Hook)
			ofn.lCustData          = Cast(LPARAM, OpenDial)
			If OpenDial->FDefaultExt Then ofn.lpstrDefExt = OpenDial->FDefaultExt
			bResult = GetOpenFilename(@ofn)
			OpenDial->ThreadID = 0
			'Deallocate cwsFile
			WDeallocate wFilter
			Exit Sub
			ErrorHandler:
			MsgBox ErrDescription(Err) & " (" & Err & ") " & _
			"in line " & Erl() & " " & _
			"in function " & ZGet(Erfn()) & " " & _
			"in module " & ZGet(Ermn())
		#endif
	End Sub
	
	Sub OpenFileControl.CreateWnd
		#ifndef __USE_GTK__
			If This.Parent <> 0 AndAlso This.Parent->Handle <> 0 Then
				ThreadID = ThreadCreate(@CreateWnd, @This)
				Do While FHandle = 0
					pApp->DoEvents
				Loop
				SetWindowLongPtr(FHandle, GWLP_USERDATA, CInt(@This))
			End If
		#endif
	End Sub
	
	#ifdef __USE_GTK__
		Sub OpenFileControl.FileChooser_CurrentFolderChanged(chooser As GtkFileChooser Ptr, user_data As Any Ptr)
			Dim As OpenFileControl Ptr ofc = user_data
			If ofc->OnFolderChange Then ofc->OnFolderChange(*ofc)
		End Sub
		
		Sub OpenFileControl.FileChooser_FileActivated(chooser As GtkFileChooser Ptr, user_data As Any Ptr)
			Dim As OpenFileControl Ptr ofc = user_data
			If ofc->OnFileActivate Then ofc->OnFileActivate(*ofc)
		End Sub
		
		Sub OpenFileControl.FileChooser_SelectionChanged(chooser As GtkFileChooser Ptr, user_data As Any Ptr)
			Dim As OpenFileControl Ptr ofc = user_data
			If ofc->OnSelectionChange Then ofc->OnSelectionChange(*ofc)
		End Sub
	#endif
	
	Constructor OpenFileControl
		'FInitialDir       = CAllocate(0)
		'FCaption          = CAllocate(0)
		'FDefaultExt       = CAllocate(0)
		'FFileName         = CAllocate(0)
		'FFilter           = CAllocate(0)
		#ifdef __USE_GTK__
			Dim As GtkFileFilter Ptr filefilter()
			widget =  gtk_file_chooser_widget_new (GTK_FILE_CHOOSER_ACTION_OPEN)
			Dim As UString res()
			If *FFilter <> "" Then
				Split *FFilter, "|", res()
				ReDim filefilter(UBound(res) + 1)
				Dim j As Integer
				For i As Integer = 1 To UBound(res) Step 2
					If res(i) = "" Then Continue For
					j += 1
					filefilter(j) = gtk_file_filter_new()
					gtk_file_filter_set_name(filefilter(j), ToUTF8(res(i - 1)))
					gtk_file_filter_add_pattern(filefilter(j), res(i))
					gtk_file_chooser_add_filter(GTK_FILE_CHOOSER (widget), filefilter(j))
				Next
				If FilterIndex <= j Then gtk_file_chooser_set_filter(GTK_FILE_CHOOSER (widget), filefilter(FilterIndex))
			End If
			If WGet(FFileName) <> "" Then
				gtk_file_chooser_set_current_name(GTK_FILE_CHOOSER (widget), ToUTF8(*FFileName))
			End If
			If WGet(FInitialDir) = "" Then WLet(FInitialDir, CurDir)
			gtk_file_chooser_set_current_folder(GTK_FILE_CHOOSER (widget), ToUTF8(*FInitialDir))
			If FMultiSelect Then gtk_file_chooser_set_select_multiple(GTK_FILE_CHOOSER (widget), True)
			g_signal_connect(widget, "current-folder-changed", G_CALLBACK(@FileChooser_CurrentFolderChanged), @This)
			g_signal_connect(widget, "file-activated", G_CALLBACK(@FileChooser_FileActivated), @This)
			g_signal_connect(widget, "selection-changed", G_CALLBACK(@FileChooser_SelectionChanged), @This)
		#else
			Options.Include OFN_PATHMUSTEXIST
			Options.Include OFN_FILEMUSTEXIST
			Options.Include OFN_HIDEREADONLY
			Options.Include OFN_ENABLESIZING
			Options.Include OFN_EXPLORER
			Options.Include OFN_ENABLEHOOK
			'OFN_NONETWORKBUTTON
			'OFN_LONGNAMES
			'OFN_NODEREFERENCELINKS
			'OFN_OVERWRITEPROMPT
			'OFN_CREATEPROMPT
			'OFN_DONTADDTORECENT
		#endif
		Child = @This
		FTabIndex          = -1
		FTabStop           = True
		WLet(FClassName, "OpenFileControl")
		FilterIndex       = 1
		'Control.Child     = @This
	End Constructor
	
	Destructor OpenFileControl
		If FInitialDir Then Deallocate_( FInitialDir)
		If FDefaultExt Then Deallocate_( FDefaultExt)
		If FFileName Then DeAllocate_( FFileName)
		If FFileTitle Then DeAllocate_( FFileTitle)
		If FFilter Then DeAllocate_( FFilter)
		#ifndef __USE_GTK__
			If FDesignMode Then
				SendMessage(GetDlgItem(GetParent(FHandle), IDCANCEL), BM_CLICK, 0, 0)
				'SendMessage(FHandle, WM_COMMAND, IDCANCEL, 0)
			Else
				SendMessage(GetParent(FHandle), WM_SYSCOMMAND, SC_CLOSE, 0)
			End If
			'SetActiveWindow(GetParent(FHandle))
			'SendMessage(GetDlgItem(GetParent(FHandle), IDCANCEL), BM_CLICK, 0, 0)
			'EndDialog(GetParent(FHandle), 1)
			If Not FDesignMode Then
				If ThreadID <> 0 AndAlso IsWindow(GetParent(FHandle)) Then ThreadWait(ThreadID) 'AndAlso IsWindow(GetParent(FHandle)) 
			End If
			FHandle = 0
		#endif
	End Destructor
End Namespace
