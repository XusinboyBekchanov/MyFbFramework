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

#include once "Dialogs.bi"

Private Sub OpenFileOptions.Include(Value As Integer)
	Count += 1
	Options = _Reallocate(Options, Count*SizeOf(Integer))
	Options[Count-1] = Value
End Sub

Private Sub OpenFileOptions.Exclude(Value As Integer)
	Dim As Integer Idx
	For i As Integer = 0 To Count -1
		If Options[i] = Value Then Idx  = 1
	Next i
	If Idx < Count Then
		Count -= 1
		For i As Integer = Idx To Count-1
			Options[i] = Options[i + 1]
		Next i
	End If
	Options = _Reallocate(Options,SizeOf(Integer) * Count)
End Sub

Private Operator OpenFileOptions.Cast As Integer
	Dim As Integer O
	For i As Integer = 0 To Count -1
		O Or= Options[i]
	Next i
	Return O
End Operator

Private Destructor OpenFileOptions
	If Options Then _Deallocate(Options)
End Destructor

#ifndef ReadProperty_Off
	Private Function Dialog.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
#endif

#ifndef WriteProperty_Off
	Private Function Dialog.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
#endif

#ifndef ReadProperty_Off
	Private Function OpenFileDialog.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "caption": Return FCaption
		Case "center": Return @Center
		Case "defaultext": Return FDefaultExt
		Case "filename": Return FFileName
		Case "filetitle": Return FFileTitle
		Case "filter": Return FFilter
		Case "filterindex": Return @FilterIndex
		Case "initialdir": Return FInitialDir
		Case "multiselect": Return @FMultiSelect
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
#endif

#ifndef WriteProperty_Off
	Private Function OpenFileDialog.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "caption": If Value <> 0 Then This.Caption = QWString(Value)
		Case "center": If Value <> 0 Then This.Center = QBoolean(Value)
		Case "defaultext": If Value <> 0 Then This.DefaultExt = QWString(Value)
		Case "filename": If Value <> 0 Then This.FileName = QWString(Value)
		Case "filetitle": If Value <> 0 Then This.FileTitle = QWString(Value)
		Case "filter": If Value <> 0 Then This.Filter = QWString(Value)
		Case "filterindex": If Value <> 0 Then This.FilterIndex = QInteger(Value)
		Case "initialdir": If Value <> 0 Then This.InitialDir = QWString(Value)
		Case "multiselect": If Value <> 0 Then This.MultiSelect = QBoolean(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
#endif

Private Property OpenFileDialog.MultiSelect As Boolean
	Return FMultiSelect
End Property

Private Property OpenFileDialog.MultiSelect(Value As Boolean)
	FMultiSelect = Value
	If Value Then
		Options.Include ofAllowMultiSelect
	Else
		Options.Exclude ofAllowMultiSelect
	End If
End Property

Private Property OpenFileDialog.InitialDir ByRef As WString
	If FInitialDir > 0 Then Return *FInitialDir Else Return ""
End Property

Private Property OpenFileDialog.InitialDir(ByRef Value As WString)
	FInitialDir    = _Reallocate(FInitialDir, (Len(Value) + 1) * SizeOf(WString))
	*FInitialDir = Value
End Property

Private Property OpenFileDialog.Caption ByRef As WString
	If FCaption > 0 Then Return *FCaption Else Return ""
End Property

Private Property OpenFileDialog.Caption(ByRef Value As WString)
	FCaption    = _Reallocate(FCaption, (Len(Value) + 1) * SizeOf(WString))
	*FCaption = Value
End Property

Private Property OpenFileDialog.DefaultExt ByRef As WString
	If FDefaultExt > 0 Then Return *FDefaultExt Else Return ""
End Property

Private Property OpenFileDialog.DefaultExt(ByRef Value As WString)
	FDefaultExt    = _Reallocate(FDefaultExt, (Len(Value) + 1) * SizeOf(WString))
	*FDefaultExt = Value
End Property

Private Property OpenFileDialog.FileName ByRef As WString
	If FFileName > 0 Then Return *FFileName Else Return ""
End Property

Private Property OpenFileDialog.FileName(ByRef Value As WString)
	WLet(FFileName, Value)
End Property

Private Property OpenFileDialog.FileTitle ByRef As WString
	If FFileTitle > 0 Then Return *FFileTitle Else Return ""
End Property

Private Property OpenFileDialog.FileTitle(ByRef Value As WString)
	WLet(FFileTitle, Value)
End Property

Private Property OpenFileDialog.Filter ByRef As WString
	If FFilter > 0 Then Return *FFilter Else Return ""
End Property

Private Property OpenFileDialog.Filter(ByRef Value As WString)
	FFilter = _Reallocate(FFilter, (Len(Value) + 1) * SizeOf(WString))
	*FFilter = Value
End Property

#ifndef __USE_GTK__
	Private Function OpenFileDialog.Hook(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As UInteger
		Static As OpenFileDialog Ptr OpenDial
		Select Case Msg
		Case WM_INITDIALOG
			OpenDial = Cast(OpenFileDialog Ptr, Cast(LPOPENFILENAME, lParam)->lCustData)
			OpenDial->Handle = FWindow
			SetWindowLongPtr(FWindow, GWLP_USERDATA, CInt(OpenDial))
		Case WM_NOTIFY
			Dim As OFNOTIFY Ptr POF
			Dim As OpenFileDialog Ptr OpenDial = Cast(OpenFileDialog Ptr, GetWindowLongPtr(FWindow, GWLP_USERDATA))
			POF = Cast(OFNOTIFY Ptr, lParam)
			Select Case POF->hdr.code
'			Case FILEOKSTRING
'				Return 2
			Case CDN_FILEOK
				Return 2
				SetWindowLongPtr GetParent(FWindow), DWLP_MSGRESULT, 1
				Return 2
			Case CDN_SELCHANGE
				If OpenDial Then If OpenDial->OnSelectionChange Then OpenDial->OnSelectionChange(*OpenDial->Designer, *OpenDial)
			Case CDN_FOLDERCHANGE
				If OpenDial Then If OpenDial->OnFolderChange Then OpenDial->OnFolderChange(*OpenDial->Designer, *OpenDial)
			Case CDN_TYPECHANGE
				Dim As Integer Index
				Index = Cast(OPENFILENAME Ptr, POF->lpOFN)->nFilterIndex
				If OpenDial Then
					OpenDial->FilterIndex = Index
					If OpenDial->OnTypeChange Then
						OpenDial->OnTypeChange(*OpenDial->Designer, *OpenDial, Index)
					End If
				End If
			Case CDN_INITDONE
				If OpenDial Then
					If OpenDial->Center Then
						Dim As ..Rect R
						Dim As Integer L,T,W,H
						GetWindowRect(GetParent(FWindow),@R)
						L = R.Left
						T = R.Top
						W = R.Right - R.Left
						H = R.Bottom - R.Top
						L = (GetSystemMetrics(SM_CXSCREEN) - W)\2
						T = (GetSystemMetrics(SM_CYSCREEN) - H)\2
						SetWindowPos GetParent(FWindow),0,L,T,0,0,SWP_NOACTIVATE Or SWP_NOSIZE Or SWP_NOZORDER
					End If
				End If
			End Select
		End Select
		Return False
	End Function
#endif

Private Function OpenFileDialog.Execute As Boolean
	On Error Goto ErrorHandler
	Dim bResult As Boolean
	FileNames.Clear
	#ifdef __USE_GTK__
		Dim As GtkWindow Ptr win
		Dim As GtkFileFilter Ptr filefilter()
		If pApp AndAlso pApp->MainForm Then
			win = GTK_WINDOW(pApp->MainForm->widget)
		End If
		widget =  gtk_file_chooser_dialog_new(ToUtf8(*FCaption), _
		win, _
		GTK_FILE_CHOOSER_ACTION_OPEN, _
		ToUtf8("Cancel"), GTK_RESPONSE_CANCEL, _
		ToUtf8("Open"), GTK_RESPONSE_ACCEPT, _
		NULL)
		Dim As UString res()
		If *FFilter <> "" Then
			Split *FFilter, "|", res()
			ReDim filefilter(UBound(res) + 1)
			Dim j As Integer
			For i As Integer = 1 To UBound(res) Step 2
				If res(i) = "" Then Continue For
				j += 1
				filefilter(j) = gtk_file_filter_new()
				gtk_file_filter_set_name(filefilter(j), ToUtf8(res(i - 1)))
				gtk_file_filter_add_pattern(filefilter(j), res(i))
				gtk_file_chooser_add_filter(GTK_FILE_CHOOSER (widget), filefilter(j))
			Next
			If FilterIndex <= j Then gtk_file_chooser_set_filter(GTK_FILE_CHOOSER (widget), filefilter(FilterIndex))
		End If
		If WGet(FFileName) <> "" Then
			gtk_file_chooser_set_current_name(GTK_FILE_CHOOSER (widget), ToUtf8(*FFileName))
		End If
		If WGet(FInitialDir) = "" Then WLet(FInitialDir, CurDir)
		gtk_file_chooser_set_current_folder(GTK_FILE_CHOOSER (widget), ToUtf8(*FInitialDir))
		'gtk_file_chooser_set_do_overwrite_confirmation (GTK_FILE_CHOOSER (widget), TRUE)
		Dim bTrue As gboolean = 1
		gtk_file_chooser_set_action(GTK_FILE_CHOOSER(widget), GTK_FILE_CHOOSER_ACTION_OPEN)
		If FMultiSelect Then gtk_file_chooser_set_select_multiple(GTK_FILE_CHOOSER (widget), bTrue)
		Dim As Integer result = gtk_dialog_run (GTK_DIALOG (widget))
		bResult = result = GTK_RESPONSE_ACCEPT
		If bResult Then
			FileName = WStr(*gtk_file_chooser_get_filename (GTK_FILE_CHOOSER (widget)))
			Dim As GSList Ptr l = gtk_file_chooser_get_filenames(GTK_FILE_CHOOSER (widget))
			While (l)
				FileNames.Add *Cast(ZString Ptr, l->data)
				g_free(l->data)
				l = l->next
			Wend
			g_slist_free(l)
		End If
		#ifdef __USE_GTK4__
			g_object_unref(widget)
		#else
			gtk_widget_destroy( GTK_WIDGET(widget) )
		#endif
	#else
		Dim cwsFile As WString  * (MAX_PATH +1) * 100
		Dim dwFlags As DWORD = Cast(Integer, Options)
		Dim dwBufLen As DWORD
		Dim wMarkers As WString * 4 = "||"
		If Right(*FFilter, 1) <> "|" Then wMarkers += "|"
		Dim wFilter As WString Ptr '* 260 = ""
		WLet(wFilter, *FFilter & wMarkers)
		Dim dwFilterStrSize As DWORD = Len(wFilter)
		Dim pchar As WCHAR Ptr = wFilter
		For i As Long = 0 To Len(*wFilter) - 1
			If pchar[i] = Asc("|") Then pchar[i] = 0
		Next
		If WGet(FInitialDir) = "" Then WLet(FInitialDir, CurDir)
		If dwBufLen = 0 Then
			If (dwFlags And OFN_ALLOWMULTISELECT = OFN_ALLOWMULTISELECT) Then dwBufLen = 32768  ' // 64 Kb buffer
		End If
		If dwBufLen < 260 Then dwBufLen = 260
		'WReAllocate cwsFile, Len(*FFileName & "|")
		WLet(FFileTitle, Space(dwBufLen))
		cwsFile = *FFileName & "|"
		Dim cbPos As Long = Len(cwsFile) - 1
		'IF LEN(*cwsFile) < dwBufLen THEN cwsFile = ReAllocate(cwsFile, (dwBufLen + 1) * SizeOf(WString)): *cwsFile += SPACE(dwBufLen - LEN(*cwsFile))
		Dim dwFileStrSize As Integer = Len(cwsFile)
		pchar = @cwsFile
		pchar[cbPos] = 0
		cbPos = Len(*FFileTitle) - 1
		pchar = FFileTitle
		pchar[cbPos] = 0
		Dim ofn As OPENFILENAME
		ZeroMemory(@ofn, SizeOf(ofn))
		ofn.lStructSize     = SizeOf(ofn)
		If pApp->MainForm Then ofn.hwndOwner       = pApp->MainForm->Handle
		ofn.lpstrFilter     = wFilter
		ofn.nFilterIndex    = 1
		ofn.lpstrFile       = @cwsFile
		ofn.lpstrFileTitle       = FFileTitle
		ofn.nMaxFileTitle       = 256
		'ofn.lpstrFile[0] = 0
		ofn.nMaxFile        = (MAX_PATH + 1) * 100
		ofn.lpstrInitialDir = FInitialDir
		If Len(*FCaption) Then ofn.lpstrTitle = FCaption
		ofn.Flags = dwFlags
		ofn.lpfnHook           = Cast(LPOFNHOOKPROC, @Hook)
		ofn.lCustData          = Cast(LPARAM, @This)
		If FDefaultExt Then ofn.lpstrDefExt = FDefaultExt
		bResult = GetOpenFileName(@ofn)
		If bResult Then
			FileName = cwsFile
			Dim buff As WString Ptr = @cwsFile
			For i As Integer = 0 To MAX_PATH * 100
				If i <> 0 AndAlso buff[i] = 0 Then
					If buff[i - 1] = 0 Then
						Exit For
					End If
				ElseIf i = 0 Then
					FileNames.Add buff[i] & ""
				ElseIf buff[i - 1] = 0 Then
					FileNames.Add buff[0] & "\" & buff[i]
				End If
			Next
			If FileNames.Count > 1 Then FileNames.Remove 0
		End If
		'Deallocate cwsFile
		WDeAllocate(wFilter)
	#endif
	Return bResult
	Exit Function
	ErrorHandler:
	MsgBox ErrDescription(Err) & " (" & Err & ") " & _
	"in line " & Erl() & " " & _
	"in function " & ZGet(Erfn()) & " " & _
	"in module " & ZGet(Ermn())
End Function

Private Constructor OpenFileDialog
	#ifdef __USE_GTK__
		
	#else
		Options.Include OFN_PATHMUSTEXIST
		Options.Include OFN_FILEMUSTEXIST
		Options.Include OFN_EXPLORER
		'Options.Include OFN_HIDEREADONLY
		'Options.Include OFN_ENABLEHOOK
	#endif
	WLet(FCaption, "Open ...")
	WLet(FFilter, "")
	WLet(FFileName, "")
	FilterIndex       = 1
	Center            = True
	'Control.Child     = @This
	WLet(FClassName, "OpenFileDialog")
End Constructor

Private Destructor OpenFileDialog
	If FInitialDir Then _Deallocate(FInitialDir)
	If FCaption Then _Deallocate( FCaption)
	If FDefaultExt Then _Deallocate( FDefaultExt)
	If FFileName Then _Deallocate( FFileName)
	If FFileTitle Then _Deallocate( FFileTitle)
	If FFilter Then _Deallocate(FFilter)
End Destructor

#ifndef ReadProperty_Off
	Private Function SaveFileDialog.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "caption": Return FCaption
		Case "center": Return @Center
		Case "defaultext": Return FDefaultExt
		Case "filename": Return FFileName
		Case "filter": Return FFilter
		Case "filterindex": Return @FilterIndex
		Case "initialdir": Return FInitialDir
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
#endif

#ifndef WriteProperty_Off
	Private Function SaveFileDialog.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "caption": If Value <> 0 Then This.Caption = QWString(Value)
		Case "center": If Value <> 0 Then This.Center = QBoolean(Value)
		Case "defaultext": If Value <> 0 Then This.DefaultExt = QWString(Value)
		Case "filename": If Value <> 0 Then This.FileName = QWString(Value)
		Case "filter": If Value <> 0 Then This.Filter = QWString(Value)
		Case "filterindex": If Value <> 0 Then This.FilterIndex = QInteger(Value)
		Case "initialdir": If Value <> 0 Then This.InitialDir = QWString(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
#endif

Private Property SaveFileDialog.InitialDir ByRef As WString
	If FInitialDir > 0 Then Return *FInitialDir Else Return ""
End Property

Private Property SaveFileDialog.InitialDir(ByRef Value As WString)
	FInitialDir    = _Reallocate(FInitialDir, (Len(Value) + 1) * SizeOf(WString))
	*FInitialDir = Value
End Property

Private Property SaveFileDialog.Caption ByRef As WString
	If FCaption > 0 Then Return *FCaption Else Return ""
End Property

Private Property SaveFileDialog.Caption(ByRef Value As WString)
	FCaption    = _Reallocate(FCaption, (Len(Value) + 1) * SizeOf(WString))
	*FCaption = Value
End Property

Private Property SaveFileDialog.DefaultExt ByRef As WString
	If FDefaultExt > 0 Then Return *FDefaultExt Else Return ""
End Property

Private Property SaveFileDialog.DefaultExt(ByRef Value As WString)
	FDefaultExt    = _Reallocate(FDefaultExt, (Len(Value) + 1) * SizeOf(WString))
	*FDefaultExt = Value
End Property

Private Property SaveFileDialog.FileName ByRef As WString
	If FFileName > 0 Then Return *FFileName Else Return ""
End Property

Private Property SaveFileDialog.FileName(ByRef Value As WString)
	FFileName    = _Reallocate(FFileName, (Len(Value) + 1) * SizeOf(WString))
	*FFileName = Value
End Property

Private Property SaveFileDialog.Filter ByRef As WString
	If FFilter > 0 Then Return *FFilter Else Return ""
End Property

Private Property SaveFileDialog.Filter(ByRef Value As WString)
	FFilter    = _Reallocate(FFilter, (Len(Value) + 1) * SizeOf(WString))
	*FFilter = Value
End Property

#ifndef __USE_GTK__
	Private Function SaveFileDialog.Hook(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As UInteger
		Static As My.Sys.Forms.Control Ptr Ctrl
		Static As SaveFileDialog Ptr SaveDial
		Select Case Msg
		Case WM_INITDIALOG
			'Ctrl = Message.Captured
			'SaveDial = Ctrl->Child
			'SaveDial->Handle = FWindow
		Case WM_NOTIFY
			Dim As OFNOTIFY Ptr POF
			POF = Cast(OFNOTIFY Ptr,lParam)
			Select Case POF->hdr.code
			Case CDN_FILEOK
				SetWindowLongPtr GetParent(FWindow),DWLP_MSGRESULT,1
				Exit Function
			Case CDN_SELCHANGE
				If SaveDial Then If SaveDial->OnSelectionChange Then SaveDial->OnSelectionChange(*Ctrl->Designer, *Ctrl)
			Case CDN_FOLDERCHANGE
				If SaveDial Then If SaveDial->OnFolderChange Then SaveDial->OnFolderChange(*Ctrl->Designer, *Ctrl)
			Case CDN_TYPECHANGE
				Dim As Integer Index
				Index = Cast(OPENFILENAME Ptr, POF->lpOFN)->nFilterIndex
				If SaveDial Then
					SaveDial->FilterIndex = Index
					If SaveDial->OnTypeChange Then
						SaveDial->OnTypeChange(*Ctrl->Designer, *Ctrl, Index)
					End If
				End If
			Case CDN_INITDONE
				If SaveDial Then
					If SaveDial->Center Then
						Dim As ..Rect R
						Dim As Integer L,T,W,H
						GetWindowRect(GetParent(FWindow), @R)
						L = R.Left
						T = R.Top
						W = R.Right - R.Left
						H = R.Bottom - R.Top
						L = (GetSystemMetrics(SM_CXSCREEN) - W)\2
						T = (GetSystemMetrics(SM_CYSCREEN) - H)\2:Print L,T
						SetWindowPos GetParent(FWindow),0,L,T,0,0,SWP_NOACTIVATE Or SWP_NOSIZE Or SWP_NOZORDER
					End If
				End If
			End Select
		End Select
		Return False
	End Function
#endif

Private Function SaveFileDialog.Execute As Boolean
	Dim bResult As Boolean
	#ifdef __USE_GTK__
		Dim As GtkWindow Ptr win
		Dim As GtkFileFilter Ptr filefilter(), curfilefilter
		If pApp->MainForm Then
			win = GTK_WINDOW(pApp->MainForm->widget)
		End If
		widget =  gtk_file_chooser_dialog_new (ToUtf8(*FCaption), _
		win, _
		GTK_FILE_CHOOSER_ACTION_SAVE, _
		ToUtf8("Cancel"), GTK_RESPONSE_CANCEL, _
		ToUtf8("Save"), GTK_RESPONSE_ACCEPT, _
		NULL)
		Dim As UString res()
		If *FFilter <> "" Then
			Split *FFilter, "|", res()
			ReDim filefilter(UBound(res) + 1)
			Dim j As Integer
			For i As Integer = 1 To UBound(res) Step 2
				If res(i) = "" Then Continue For
				j += 1
				filefilter(j) = gtk_file_filter_new()
				gtk_file_filter_set_name(filefilter(j), ToUtf8(res(i - 1)))
				gtk_file_filter_add_pattern(filefilter(j), res(i))
				gtk_file_chooser_add_filter(GTK_FILE_CHOOSER (widget), filefilter(j))
			Next
			If FilterIndex <= j Then gtk_file_chooser_set_filter(GTK_FILE_CHOOSER (widget), filefilter(FilterIndex))
		End If
		If *FFileName <> "" Then
			gtk_file_chooser_set_current_name(GTK_FILE_CHOOSER (widget), ToUtf8(*FFileName))
		End If
		If WGet(FInitialDir) = "" Then WLet(FInitialDir, CurDir)
		gtk_file_chooser_set_current_folder(GTK_FILE_CHOOSER (widget), ToUtf8(*FInitialDir))
		'gtk_file_chooser_set_do_overwrite_confirmation (GTK_FILE_CHOOSER (widget), TRUE)
		'gtk_file_chooser_set_select_multiple(GTK_FILE_CHOOSER (widget), true)
		Dim As Integer result = gtk_dialog_run (GTK_DIALOG (widget))
		bResult = result = GTK_RESPONSE_ACCEPT
		If bResult Then
			Dim As WString Ptr cwsFile, cwsFileExt
			WLet(cwsFile, WStr(*gtk_file_chooser_get_filename (GTK_FILE_CHOOSER (widget))))
			curfilefilter = gtk_file_chooser_get_filter(GTK_FILE_CHOOSER (widget))
			For j As Integer = 0 To UBound(filefilter)
				If curfilefilter = filefilter(j) Then FilterIndex = j: Exit For
			Next
			Var Index = FilterIndex * 2 - 1
			If Index <= UBound(res) Then
				WLet(cwsFileExt, Replace(res(Index), "*", ""))
				If res(Index) = "*.*" Then
					FileName = *cwsFile
				ElseIf Not EndsWith(*cwsFile, *cwsFileExt) Then
					FileName = *cwsFile & *cwsFileExt
				Else
					FileName = *cwsFile
				End If
			Else
				FileName = *cwsFile
			End If
		End If
		#ifdef __USE_GTK4__
			g_object_unref(widget)
		#else
			gtk_widget_destroy( GTK_WIDGET(widget) )
		#endif
	#else
		Dim dwFlags As DWORD = Cast(Integer, Options)
		Dim dwBufLen As DWORD
		Dim wMarkers As WString * 4 = "||"
		If Right(*FFilter, 1) <> "|" Then wMarkers += "|"
		Dim wFilter As WString Ptr
		WLet(wFilter, *FFilter & wMarkers)
		Dim dwFilterStrSize As DWORD = Len(*wFilter)
		Dim pchar As WCHAR Ptr = wFilter
		For i As Long = 0 To Len(*wFilter) - 1
			If pchar[i] = Asc("|") Then pchar[i] = 0
		Next
		If WGet(FInitialDir) = "" Then WLet(FInitialDir, CurDir)
		If dwBufLen = 0 Then
			If (dwFlags And OFN_ALLOWMULTISELECT = OFN_ALLOWMULTISELECT) Then dwBufLen = 32768  ' // 64 Kb buffer
		End If
		If dwBufLen < 260 Then dwBufLen = 260
		Dim cwsFile As WString Ptr = _Allocate((Len(*FFileName & "|") + 1) * SizeOf(WString))
		*cwsFile = *FFileName & "|"
		Dim cbPos As Long = Len(*cwsFile) - 1
		If Len(*cwsFile) < dwBufLen Then cwsFile = _Reallocate(cwsFile, (dwBufLen + 1) * SizeOf(WString)): *cwsFile += Space(dwBufLen - Len(*cwsFile))
		Dim dwFileStrSize As Integer = Len(*cwsFile)
		pchar = cwsFile
		pchar[cbPos] = 0
		Dim ofn As OPENFILENAME
		ofn.lStructSize     = SizeOf(ofn)
		If pApp->MainForm Then ofn.hwndOwner       = pApp->MainForm->Handle
		ofn.lpstrFilter     = wFilter
		ofn.nFilterIndex    = FilterIndex
		ofn.lpstrFile       = cwsFile
		'ofn.lpstrFile[0] = 0
		ofn.nMaxFile        = dwFileStrSize
		ofn.lpstrInitialDir = FInitialDir
		If Len(*FCaption) Then ofn.lpstrTitle = FCaption
		ofn.Flags = dwFlags
		'If FDefaultExt Then ofn.lpstrDefExt = FDefaultExt
		ofn.lpstrDefExt = NULL
		If GetSaveFileName(@ofn) Then
			If ofn.nFileExtension = 0 Then
				FilterIndex = ofn.nFilterIndex
				Dim As UString res()
				Split(*FFilter, "|", res())
				Var Index = FilterIndex * 2 - 1
				If res(Index) = "*.*" Then
					FileName = *cwsFile
				Else
					FileName = *cwsFile & Replace(res(Index), "*", "")
				End If
			Else
				FileName = *cwsFile
			End If
			bResult = True
		Else
			bResult = False
		End If
		_Deallocate( cwsFile)
		_Deallocate( wFilter)
	#endif
	Return bResult
End Function

Private Property SaveFileDialog.Color As Integer
	Return Control.BackColor
End Property

Private Property SaveFileDialog.Color(Value As Integer)
	Control.BackColor = Value
End Property

Private Constructor SaveFileDialog
	WLet(FCaption, "Save As")
	WLet(FFilter, "")
	WLet(FFileName, "")
	FilterIndex   = 1
	WLet(FClassName, "SaveFileDialog")
	Center        = True
	'Control.Child = @This
	#ifndef __USE_GTK__
		Options.Include OFN_FILEMUSTEXIST
		Options.Include OFN_PATHMUSTEXIST
		Options.Include OFN_EXPLORER
		'Options.Include OFN_ENABLEHOOK
	#endif
End Constructor

Private Destructor SaveFileDialog
	If FInitialDir <> 0 Then _Deallocate( FInitialDir)
	If FCaption <> 0 Then _Deallocate( FCaption)
	If FDefaultExt <> 0 Then _Deallocate( FDefaultExt)
	If FFileName <> 0 Then _Deallocate( FFileName)
	If FFilter <> 0 Then _Deallocate( FFilter)
End Destructor

#ifndef ReadProperty_Off
	Private Function FontDialog.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "font": Return @This.Font
		Case "maxfontsize": Return @MaxFontSize
		Case "minfontsize": Return @MinFontSize
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
#endif

#ifndef WriteProperty_Off
	Private Function FontDialog.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "font": If Value <> 0 Then This.Font = *Cast(My.Sys.Drawing.Font Ptr, Value)
		Case "maxfontsize": If Value <> 0 Then This.MaxFontSize = QInteger(Value)
		Case "minfontsize": If Value <> 0 Then This.MinFontSize = QInteger(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
#endif

Private Function FontDialog.Execute As Boolean
	Static As Integer FWidth(2) = {400,700}
	#ifdef __USE_GTK__
		Dim As Boolean bResult
		#ifdef __USE_GTK3__
			Dim As GtkWindow Ptr win
			If pApp->MainForm Then
				win = GTK_WINDOW(pApp->MainForm->widget)
			End If
			widget =  gtk_font_chooser_dialog_new (ToUtf8("Choose Font"), win)
			gtk_font_chooser_set_font(GTK_FONT_CHOOSER (widget), ToUtf8(Font.Name & " " & WStr(Font.Size)))
		#else
			widget =  gtk_font_selection_dialog_new(ToUtf8("Choose Font"))
			gtk_font_selection_dialog_set_font_name(GTK_FONT_SELECTION_DIALOG(widget), ToUtf8(Font.Name & " " & WStr(Font.Size)))
		#endif
		Dim As Integer res = gtk_dialog_run (GTK_DIALOG (widget))
		bResult = res = GTK_RESPONSE_OK
		If bResult Then
			#ifdef __USE_GTK3__
				Dim As PangoFontDescription Ptr desc = gtk_font_chooser_get_font_desc (GTK_FONT_CHOOSER (widget))
				Font.Name        = WStr(*pango_font_description_get_family(desc))
				Font.Italic      = pango_font_description_get_style(desc) = PANGO_STYLE_ITALIC
				Font.Underline   = False
				Font.StrikeOut   = False
				Font.Color       = 0
				Font.Size        = gtk_font_chooser_get_font_size(GTK_FONT_CHOOSER (widget)) / PANGO_SCALE
				Font.Bold        = pango_font_description_get_weight(desc) <> PANGO_WEIGHT_THIN
			#else
				Dim As GtkWidget Ptr sel = gtk_font_selection_dialog_get_font_selection(GTK_FONT_SELECTION_DIALOG(widget))
				Dim As PangoFontFamily Ptr pff = gtk_font_selection_get_family(GTK_FONT_SELECTION(sel))
				Font.Name        = WStr(*pango_font_family_get_name(pff))
				Font.Italic      = False
				Font.Underline   = False
				Font.StrikeOut   = False
				Font.Color       = 0
				Font.Size        = gtk_font_selection_get_size(GTK_FONT_SELECTION(sel)) / PANGO_SCALE
				Font.Bold        = False
			#endif
		End If
		#ifdef __USE_GTK4__
			g_object_unref(widget)
		#else
			gtk_widget_destroy( GTK_WIDGET(widget) )
		#endif
		Return bResult
	#else
		Dim As CHOOSEFONT CF
		Dim As LOGFONT LGF
		Dim As HDC Dc
		Dc = GetDC(HWND_DESKTOP)
		LGF.lfItalic      = Font.Italic
		LGF.lfUnderline   = Font.Underline
		LGF.lfStrikeOut   = Font.StrikeOut
		LGF.lfHeight      = -MulDiv(Font.Size, GetDeviceCaps(Dc, LOGPIXELSY), 72)
		LGF.lfWeight      = FWidth(abs_(Font.Bold))
		LGF.lfFaceName    = Font.Name
		CF.lStructSize    = SizeOf(CHOOSEFONT)
		CF.hwndOwner      = MainHandle
		CF.hDC            = Dc
		CF.Flags          = CF_BOTH Or CF_EFFECTS Or CF_INITTOLOGFONTSTRUCT
		CF.rgbColors      = Font.Color
		CF.lpLogFont      = @LGF
		ReleaseDC HWND_DESKTOP,Dc
		If CHOOSEFONT(@CF) <> 0 Then
			Font.Name        = LGF.lfFaceName
			Font.Italic      = LGF.lfItalic
			Font.Underline   = LGF.lfUnderline
			Font.StrikeOut   = LGF.lfStrikeOut
			Font.Color       = CF.rgbColors
			Font.Size        = CF.iPointSize / 10
			Font.Bold        = IIf(LGF.lfWeight = 700,True,False)
			Return True
		Else
			Return False
		End If
	#endif
End Function

Private Constructor FontDialog
	MaxFontSize = 0
	MinFontSize = 0
	WLet(FClassName, "FontDialog")
End Constructor

Private Destructor FontDialog
End Destructor

#ifndef ReadProperty_Off
	Private Function FolderBrowserDialog.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "caption": Return FCaption
		Case "center": Return @Center
		Case "directory": Return FDirectory
		Case "title": Return FTitle
		Case "initialdir": Return FInitialDir
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
#endif

#ifndef WriteProperty_Off
	Private Function FolderBrowserDialog.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "caption": If Value <> 0 Then This.Caption = QWString(Value)
		Case "center": If Value <> 0 Then This.Center = QBoolean(Value)
		Case "directory": If Value <> 0 Then This.Directory = QWString(Value)
		Case "title": If Value <> 0 Then This.Title = QWString(Value)
		Case "initialdir": If Value <> 0 Then This.InitialDir = QWString(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
#endif

Private Property FolderBrowserDialog.Caption ByRef As WString
	If FCaption > 0 Then Return *FCaption Else Return ""
End Property

Private Property FolderBrowserDialog.Caption(ByRef Value As WString)
	FCaption    = _Reallocate(FCaption, (Len(Value) + 1) * SizeOf(WString))
	*FCaption = Value
End Property

Private Property FolderBrowserDialog.Title ByRef As WString
	If FTitle > 0 Then Return *FTitle Else Return ""
End Property

Private Property FolderBrowserDialog.Title(ByRef Value As WString)
	FTitle    = _Reallocate(FTitle, (Len(Value) + 1) * SizeOf(WString))
	*FTitle = Value
End Property

Private Property FolderBrowserDialog.InitialDir ByRef As WString
	If FInitialDir > 0 Then Return *FInitialDir Else Return ""
End Property

Private Property FolderBrowserDialog.InitialDir(ByRef Value As WString)
	FInitialDir    = _Reallocate(FInitialDir, (Len(Value) + 1) * SizeOf(WString))
	*FInitialDir = Value
End Property

Private Property FolderBrowserDialog.Directory ByRef As WString
	If FDirectory > 0 Then Return *FDirectory Else Return ""
End Property

Private Property FolderBrowserDialog.Directory(ByRef Value As WString)
	FDirectory    = _Reallocate(FDirectory, (Len(Value) + 1) * SizeOf(WString))
	*FDirectory = Value
End Property

#ifndef __USE_GTK__
	Private Function FolderBrowserDialog.Hook(FWindow As HWND, uMsg As UINT, lParam As LPARAM, lpData As LPARAM) As Long
		Dim As FolderBrowserDialog Ptr BrowseDial
		Dim As My.Sys.Forms.Control Ptr Ctrl
		Dim R As Rect
		If uMsg = BFFM_INITIALIZED Then
			'Ctrl = Message.Captured
			'BrowseDial = Ctrl->Child
			'BrowseDial->Handle = FWindow
			'GetWindowRect(FWindow, @R)
			'If BrowseDial->Center Then
			'    MoveWindow(FWindow,_
			'               (GetSystemMetrics(SM_CXSCREEN)-(R.Right-R.Left))/2,_
			'               (GetSystemMetrics(SM_CYSCREEN)-(R.Bottom-R.Top))/2,_
			'               (R.Right-R.Left),(R.Bottom-R.Top),_
			'               1)
			'End If
			SendMessage(FWindow, BFFM_SETSELECTION, 1, CUInt(lpData))
			'If Len(BrowseDial->Caption) then
			'   SetWindowText(FWindow, BrowseDial->FCaption)
			'End If
		End If
		Return False
	End Function
#endif

Private Function FolderBrowserDialog.Execute As Boolean
	Dim As Boolean bResult
	#ifdef __USE_GTK__
		Dim As GtkWindow Ptr win
		If pApp->MainForm Then
			win = GTK_WINDOW(pApp->MainForm->widget)
		End If
		widget =  gtk_file_chooser_dialog_new (ToUtf8("Choose Folder"), _
		win, _
		GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER, _
		ToUtf8("Cancel"), GTK_RESPONSE_CANCEL, _
		ToUtf8("Open"), GTK_RESPONSE_ACCEPT, _
		NULL)
		'gtk_file_chooser_set_current_name(GTK_FILE_CHOOSER (widget), *FFileName)
		'gtk_file_chooser_set_do_overwrite_confirmation (GTK_FILE_CHOOSER (widget), TRUE)
		'gtk_file_chooser_set_select_multiple(GTK_FILE_CHOOSER (widget), true)
		Dim As Integer res = gtk_dialog_run (GTK_DIALOG (widget))
		bResult = res = GTK_RESPONSE_ACCEPT
		If bResult Then
			Directory = WStr(*gtk_file_chooser_get_filename (GTK_FILE_CHOOSER (widget)))
		End If
		#ifdef __USE_GTK4__
			g_object_unref(widget)
		#else
			gtk_widget_destroy( GTK_WIDGET(widget) )
		#endif
		Return bResult
	#else
		Dim BI    As BROWSEINFO
		Dim pidl  As Any Ptr
		Dim sPath As WString Ptr = _CAllocate(MAX_PATH * SizeOf(WString))
		Dim xPath As WString Ptr = _CAllocate(MAX_PATH * SizeOf(WString))
		FDirectory = _CAllocate(MAX_PATH * SizeOf(WString))
		
		*sPath = WString(MAX_PATH,0)
		*xPath = WString(MAX_PATH,0)                             '
		InitialDir        = InitialDir + Chr(0)
		BI.hwndOwner      = MainHandle
		BI.pszDisplayName = xPath
		BI.lpszTitle      = FTitle
		BI.ulFlags        = BIF_USENEWUI 
		BI.lpfn           = @FolderBrowserDialog.Hook
		BI.lParam         = Cast(LPARAM, FInitialDir)
		'Message.Captured = Control
		pidl = SHBrowseForFolder(@BI)
		If pidl Then
			*FDirectory = ""
			If SHGetPathFromIDList(pidl, sPath) Then
				'For i As Integer = 0 To Len(*sPath)
				'    If sPath[i] <> 0 Then *FDirectory += WChr(sPath[i])
				'Next i
				*FDirectory = RTrim(*sPath)
			Else
				'For i As Integer = 0 To Len(sPath)
				'    If xPath[i] <> 0 Then *FDirectory += WChr(xPath[i])
				'Next i
				*FDirectory = RTrim(*xPath)
			End If
			CoTaskMemFree pidl
			Return 1
		Else
			Return 0
		End If
	#endif
End Function

Private Constructor FolderBrowserDialog
	WLet(FClassName, "FolderBrowserDialog")
	'Control.Child = @This
	WLet(FTitle, "Please select a Folder:")
	WLet(FCaption, *FTitle)
End Constructor

Private Destructor FolderBrowserDialog
	If FCaption <> 0 Then _Deallocate( FCaption)
	If FTitle <> 0 Then _Deallocate( FTitle)
	If FInitialDir <> 0 Then _Deallocate( FInitialDir)
	If FDirectory <> 0 Then _Deallocate( FDirectory)
End Destructor

#ifndef ReadProperty_Off
	Private Function ColorDialog.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "caption": Return _Caption
		Case "center": Return @Center
		Case "color": Return @Color
		Case "backcolor": Return @BackColor
		Case "parent": Return Parent
		Case "style": Return @Style
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
#endif

#ifndef WriteProperty_Off
	Private Function ColorDialog.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "caption": If Value <> 0 Then This.Caption = QWString(Value)
		Case "center": If Value <> 0 Then This.Center = QInteger(Value)
		Case "color": If Value <> 0 Then This.Color = QInteger(Value)
		Case "backcolor": If Value <> 0 Then This.BackColor = QInteger(Value)
		Case "parent": This.Parent = Value
		Case "style": If Value <> 0 Then This.BackColor = QInteger(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
#endif

#ifndef __USE_GTK__
	Private Function ColorDialog.Hook(FWindow As HWND,Msg As UINT,wParam As WPARAM,lParam As LPARAM) As UInteger
		Static As HBRUSH Brush
		Select Case Msg
		Case WM_INITDIALOG
			Dim As ColorDialog Ptr CommonDialog = Cast(ColorDialog Ptr, Cast(LPCHOOSECOLOR, lParam)->lCustData)
			If CommonDialog Then
				CommonDialog->Handle = FWindow
				SetWindowLongPtr(FWindow,DWLP_MSGRESULT,CInt(CommonDialog))
				SetWindowText(FWindow, CommonDialog->_Caption)
				If CommonDialog->Center Then
					Dim As ..Rect R,Wr
					GetWindowRect(FWindow, @Wr)
					SystemParametersInfo(SPI_GETWORKAREA,0,@R,0)
					MoveWindow(FWindow,(R.Right  - (Wr.Right - Wr.Left))/2,(R.Bottom - (Wr.Bottom - Wr.Top))/2,Wr.Right - Wr.Left,Wr.Bottom - Wr.Top,1)
				End If
				Brush = CreateSolidBrush(CommonDialog->BackColor)
			End If
			Return True
		Case WM_CTLCOLORDLG To WM_CTLCOLORSTATIC
			Dim As ColorDialog Ptr CommonDialog = Cast(ColorDialog Ptr,GetWindowLongPtr(FWindow,DWLP_MSGRESULT))
			If CommonDialog Then
				With *CommonDialog
					SetBkMode(Cast(HDC,wParam),TRANSPARENT)
					SetBkColor(Cast(HDC,wParam),.BackColor)
					SetBkMode(Cast(HDC,wParam),OPAQUE)
					Return CInt(Brush)
				End With
			End If
		Case WM_ERASEBKGND
			Dim As ColorDialog Ptr CommonDialog = Cast(ColorDialog Ptr,GetWindowLongPtr(FWindow,DWLP_MSGRESULT))
			If CommonDialog Then
				With *CommonDialog
					Dim As HDC Dc = Cast(HDC,wParam)
					Dim As ..Rect R
					GetClientRect(FWindow, @R)
					FillRect(Dc,@R,Brush)
					Return True
				End With
			End If
		Case Else
			Return False
		End Select
		Return True
	End Function
#endif

Private Property ColorDialog.Caption ByRef As WString
	Return *_Caption
End Property

Private Property ColorDialog.Caption(ByRef Value As WString)
	WLet(_Caption, Value)
End Property

Private Function ColorDialog.Execute As Boolean
	#ifdef __USE_GTK__
		Dim As Boolean bResult
		Dim As GtkWindow Ptr win
		If pApp->MainForm Then
			win = GTK_WINDOW(pApp->MainForm->widget)
		End If
		#ifdef __USE_GTK3__
			widget = gtk_color_chooser_dialog_new (ToUtf8(*_Caption), win)
		#else
			widget = gtk_color_selection_dialog_new(ToUtf8(*_Caption))
		#endif
		Dim As Integer res = gtk_dialog_run (GTK_DIALOG (widget))
		bResult = res = GTK_RESPONSE_OK
		If bResult Then
			Dim As UString RGBString
			#ifdef __USE_GTK3__
				Dim As GdkRGBA RGBAColor
				gtk_color_chooser_get_rgba(GTK_COLOR_CHOOSER (widget), @RGBAColor)
				RGBString = WStr(*gdk_rgba_to_string(@RGBAColor))
			#else
				Dim As GdkColor gColor
				Dim As GtkWidget Ptr cs = gtk_color_selection_dialog_get_color_selection(GTK_COLOR_SELECTION_DIALOG(widget))
				gtk_color_selection_get_current_color(GTK_COLOR_SELECTION (cs), @gColor)
				RGBString = WStr(*gdk_color_to_string(@gColor))
			#endif
			Dim As UString res()
			Split(Mid(RGBString, 5, Len(RGBString) - 5), ",", res())
			If UBound(res) >= 2 Then This.Color = BGR(Val(res(0)), Val(res(1)), Val(res(2)))
		End If
		#ifdef __USE_GTK4__
			g_object_unref(widget)
		#else
			gtk_widget_destroy( GTK_WIDGET(widget) )
		#endif
		Return bResult
	#else
		Dim As CHOOSECOLOR CC
		CC.lStructSize  = SizeOf(CC)
		CC.lpCustColors = @Colors(0)
		CC.hwndOwner    = MainHandle 'IIf(Parent,Parent->Handle, 0)
		CC.rgbResult    = This.Color
		CC.Flags        = CC_RGBINIT
		CC.Flags        = CC.Flags Or CC_ENABLEHOOK
		Select Case Style
		Case 0
			CC.Flags    = CC.Flags Or CC_FULLOPEN
		Case 1
			CC.Flags    = CC.Flags Or CC_PREVENTFULLOPEN
		End Select
		CC.lpfnHook     = @Hook
		CC.lCustData    = Cast(LPARAM,@This)
		If CHOOSECOLOR(@CC) Then
			This.Color = CC.rgbResult
			Return True
		End If
		Return False
	#endif
End Function

Private Operator ColorDialog.Cast As Any Ptr
	Return @This
End Operator

Private Constructor ColorDialog
	WLet(_Caption, "Choose Color...")
	WLet(FClassName, "ColorDialog")
	#ifndef __USE_GTK__
		BackColor = GetSysColor(COLOR_BTNFACE)
	#endif
End Constructor

Private Destructor ColorDialog
	_Deallocate(_Caption)
End Destructor

