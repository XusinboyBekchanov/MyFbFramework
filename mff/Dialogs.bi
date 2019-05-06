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

#INCLUDE Once "Application.bi"
#IfNDef __USE_GTK__
	#INCLUDE Once "Win/ShlObj.bi"
#EndIf

Const OFN_ENABLEINCLUDENOTIFY = &H400000

#IfDef __USE_GTK__
	Enum OpenOption
		ofReadOnly 
		ofOverwritePrompt 
		ofHideReadOnly
		ofNoChangeDir
		ofShowHelp
		ofNoValidate 
		ofAllowMultiSelect
		ofExtensionDifferent 
		ofPathMustExist 
		ofFileMustExist 
		ofCreatePrompt
		ofShareAware 
		ofNoReadOnlyReturn 
		ofNoTestFileCreate 
		ofNoNetworkButton
		ofNoLongNames 
		ofOldStyleDialog 
		ofNoDereferenceLinks 
		ofEnableIncludeNotify
		ofEnableSizing
	End Enum
#Else
	Enum OpenOption
		ofReadOnly            = OFN_READONLY 
		ofOverwritePrompt     = OFN_OVERWRITEPROMPT 
		ofHideReadOnly        = OFN_HIDEREADONLY
		ofNoChangeDir         = OFN_NOCHANGEDIR
		ofShowHelp            = OFN_SHOWHELP
		ofNoValidate          = OFN_NOVALIDATE 
		ofAllowMultiSelect    = OFN_ALLOWMULTISELECT
		ofExtensionDifferent  = OFN_EXTENSIONDIFFERENT 
		ofPathMustExist       = OFN_PATHMUSTEXIST 
		ofFileMustExist       = OFN_FILEMUSTEXIST 
		ofCreatePrompt        = OFN_CREATEPROMPT
		ofShareAware          = OFN_SHAREAWARE 
		ofNoReadOnlyReturn    = OFN_NOREADONLYRETURN 
		ofNoTestFileCreate    = OFN_NOTESTFILECREATE 
		ofNoNetworkButton     = OFN_NONETWORKBUTTON
		ofNoLongNames         = OFN_NOLONGNAMES 
		ofOldStyleDialog      = OFN_EXPLORER 
		ofNoDereferenceLinks  = OFN_NODEREFERENCELINKS 
		ofEnableIncludeNotify = OFN_ENABLEINCLUDENOTIFY
		ofEnableSizing        = OFN_ENABLESIZING
	End Enum
#EndIf

Type OpenFileDialogOptions
    Count   As Integer
    Options As Integer Ptr
    Declare Sub Include(Value As Integer)
    Declare Sub Exclude(Value As Integer)
    Declare Operator Cast As Integer
End Type

Sub OpenFileDialogOptions.Include(Value As Integer)
    Count += 1
    Options = ReAllocate(Options, Count*SizeOF(Integer))
    Options[Count-1] = Value
End Sub

Sub OpenFileDialogOptions.Exclude(Value As Integer)
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
    Options = ReAllocate(Options,SizeOf(Integer) * Count)
End Sub

Operator OpenFileDialogOptions.Cast As Integer
    Dim As Integer O
    For i As Integer = 0 To Count -1
        O OR= Options[i]
    Next i
    Return O
End Operator

Type Dialog Extends Component
    Public:
        Declare Abstract Function Execute As Boolean
End Type

Type OpenFileDialog Extends Dialog
     Private:
		#IfNDef __USE_GTK__
			Declare Static Function Hook(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As UInteger
        #EndIf
        Control     As My.Sys.Forms.Control
        FInitialDir   As WString Ptr
        FCaption      As WString Ptr
        FMultiSelect  As Boolean
        FDefaultExt   As WString Ptr
        FFileName     As WString Ptr
        FFileTitle    As WString Ptr
        FFilter       As WString Ptr
     Public:
		FileNames 	As WStringList
		#IfNDef __USE_GTK__
			
        #EndIf
        FilterIndex  As Integer
        Declare Property MultiSelect As Boolean
        Declare Property MultiSelect(Value As Boolean)
        Declare Property InitialDir ByRef As WString
        Declare Property InitialDir(ByRef Value As WString)
        Declare Property Caption ByRef As WString
        Declare Property Caption(ByRef Value As WString)
        Declare Property DefaultExt ByRef As WString
        Declare Property DefaultExt(ByRef Value As WString)
        Declare Property FileName ByRef As WString
        Declare Property FileName(ByRef Value As WString)
        Declare Property FileTitle ByRef As WString
        Declare Property FileTitle(ByRef Value As WString)
        Declare Property Filter ByRef As WString
        Declare Property Filter(ByRef Value As WString)
        #IfNDef __USE_GTK__
			Handle       As HWND
		#EndIf
        Options      As OpenFileDialogOptions
        Center       As Boolean
        Declare Function Execute As Boolean
        Declare Constructor
        Declare Destructor
        OnFolderChange    As Sub(BYREF Sender As My.Sys.Forms.Control)
        OnSelectionChange As Sub(BYREF Sender As My.Sys.Forms.Control)
        OnTypeChange      As Sub(BYREF Sender As My.Sys.Forms.Control, Index As Integer)
End Type

Property OpenFileDialog.MultiSelect As Boolean
    Return FMultiSelect
End Property

Property OpenFileDialog.MultiSelect(Value As Boolean)
    FMultiSelect = Value
    If Value Then
		Options.Include ofAllowMultiSelect
	Else
		Options.Exclude ofAllowMultiSelect
	End If
End Property

Property OpenFileDialog.InitialDir ByRef As WString
    Return WGet(FInitialDir)
End Property

Property OpenFileDialog.InitialDir(ByRef Value As WString)
    FInitialDir    = Reallocate(FInitialDir, (Len(Value) + 1) * SizeOf(WString))
    *FInitialDir = Value
End Property

Property OpenFileDialog.Caption ByRef As WString
    Return WGet(FCaption)
End Property

Property OpenFileDialog.Caption(ByRef Value As WString)
    FCaption    = Reallocate(FCaption, (Len(Value) + 1) * SizeOf(WString))
    *FCaption = Value
End Property

Property OpenFileDialog.DefaultExt ByRef As WString
    Return WGet(FDefaultExt)
End Property

Property OpenFileDialog.DefaultExt(ByRef Value As WString)
    FDefaultExt    = Reallocate(FDefaultExt, (Len(Value) + 1) * SizeOf(WString))
    *FDefaultExt = Value
End Property

Property OpenFileDialog.FileName ByRef As WString
    Return WGet(FFileName)
End Property

Property OpenFileDialog.FileName(ByRef Value As WString)
    WLet FFileName, Value
End Property

Property OpenFileDialog.FileTitle ByRef As WString
    Return WGet(FFileTitle)
End Property

Property OpenFileDialog.FileTitle(ByRef Value As WString)
    WLet FFileTitle, Value
End Property

Property OpenFileDialog.Filter ByRef As WString
    Return WGet(FFilter)
End Property

Property OpenFileDialog.Filter(ByRef Value As WString)
    FFilter    = Reallocate(FFilter, (Len(Value) + 1) * SizeOf(WString))
    *FFilter = Value
End Property

#IfNDef __USE_GTK__
	Function OpenFileDialog.Hook(FWindow As HWND,Msg As UINT,wParam As WPARAM,lParam As LPARAM) As UInteger
		Static As My.Sys.Forms.Control Ptr Ctrl
		Static As OpenFileDialog Ptr OpenDial
		Select Case Msg
		Case WM_INITDIALOG
			'Ctrl = Message.Captured
			'OpenDial = Ctrl->Child
			'OpenDial->Handle = FWindow
		Case WM_NOTIFY
			Dim As OFNOTIFY Ptr POF
			POF = Cast(OFNOTIFY Ptr,lParam)
			Select Case POF->hdr.Code
			Case CDN_FILEOK
				SetWindowLongPtr GetParent(FWindow),DWLP_MSGRESULT,1
				Exit Function
			Case CDN_SELCHANGE
				If OpenDial Then If OpenDial->OnSelectionChange Then OpenDial->OnSelectionChange(*Ctrl)
			Case CDN_FOLDERCHANGE
				If OpenDial Then If OpenDial->OnFolderChange Then OpenDial->OnFolderChange(*Ctrl)
			Case CDN_TYPECHANGE
				Dim As Integer Index
				Index = *Cast(OPENFILENAME Ptr,POF->lpOFN).nFilterIndex
				If OpenDial Then 
					OpenDial->FilterIndex = Index
					If OpenDial->OnTypeChange Then 
						OpenDial->OnTypeChange(*Ctrl, Index)
					End If
				End If
			Case CDN_INITDONE
				If OpenDial Then
					If OpenDial->Center Then
						Dim As Rect R
						Dim As Integer L,T,W,H
						GetWindowRect(GetParent(FWindow),@R)
						L = R.Left
						T = R.Top
						W = R.Right - R.Left
						H = R.Bottom - R.Top
						L = (GetSysTemMetrics(SM_CXSCREEN) - W)\2
						T = (GetSysTemMetrics(SM_CYSCREEN) - H)\2:PRINT L,T
						SetWindowPos GetParent(FWindow),0,L,T,0,0,SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER
					End If
				End If
			End Select
		End Select
		Return False
	End Function
#EndIf

Function OpenFileDialog.Execute As Boolean
    On Error Goto ErrorHandler
	Dim bResult As Boolean
	FileNames.Clear
    #IfDef __USE_GTK__
		Dim As GtkWindow Ptr win
		If App.MainForm Then
			win = Gtk_Window(App.MainForm->widget)
		End If
		widget =  gtk_file_chooser_dialog_new (ToUtf8("Open File"), _
                                      win, _
                                      GTK_FILE_CHOOSER_ACTION_OPEN, _
                                      ToUTF8("Cancel"), GTK_RESPONSE_CANCEL, _
                                      ToUTF8("Open"), GTK_RESPONSE_ACCEPT, _
                                      NULL)
		'gtk_file_chooser_set_current_name(GTK_FILE_CHOOSER (widget), *FFileName)
		'gtk_file_chooser_set_do_overwrite_confirmation (GTK_FILE_CHOOSER (widget), TRUE)
		If FMultiSelect Then gtk_file_chooser_set_select_multiple(GTK_FILE_CHOOSER (widget), True)
		Dim As Integer res = gtk_dialog_run (GTK_DIALOG (widget))
		bResult = res = GTK_RESPONSE_ACCEPT
		If bResult Then
			filename = WStr(*gtk_file_chooser_get_filename (GTK_FILE_CHOOSER (widget)))
			Dim As GSList Ptr l = gtk_file_chooser_get_filenames(GTK_FILE_CHOOSER (widget))
			while (l)
				FileNames.Add *Cast(ZString Ptr, l->Data)
				g_free(l->Data)
				l = l->Next
			Wend
			g_slist_free(l)
		End If
		gtk_widget_destroy( GTK_WIDGET(widget) )
    #Else
    	Dim cwsFile As WString  * (MAX_PATH +1) * 100
		Dim dwFlags As DWORD = Cast(Integer, Options)
		Dim dwBufLen AS DWORD
		Dim wMarkers AS WString * 4 = "||"
		If Right(*FFilter, 1) <> "|" Then wMarkers += "|"
		Dim wFilter As WString * 260 = ""
		wFilter = *FFilter & wMarkers
		Dim dwFilterStrSize As DWORD = Len(wFilter)
		Dim pchar As WChar Ptr = @wFilter
		For i As Long = 0 To Len(wFilter) - 1
			If pchar[i] = Asc("|") Then pchar[i] = 0
		Next
		If Len(*FInitialDir) = 0 Then FInitialDir = ReAllocate(FInitialDir, (Len(CURDIR) + 1) * SizeOf(WString)): *FInitialDir = CURDIR
		If dwBufLen = 0 Then
			If (dwFlags And OFN_ALLOWMULTISELECT = OFN_ALLOWMULTISELECT) Then dwBufLen = 32768  ' // 64 Kb buffer
		End If
		If dwBufLen < 260 Then dwBufLen = 260
		'WReAllocate cwsFile, Len(*FFileName & "|")
		WLet FFileTitle, Space(dwBufLen)
		cwsFile = *FFileName & "|"
		DIM cbPos AS LONG = LEN(cwsFile) - 1
		'IF LEN(*cwsFile) < dwBufLen THEN cwsFile = ReAllocate(cwsFile, (dwBufLen + 1) * SizeOf(WString)): *cwsFile += SPACE(dwBufLen - LEN(*cwsFile))
		DIM dwFileStrSize AS Integer = LEN(cwsFile)
		pchar = @cwsFile
		pchar[cbPos] = 0
		cbPos = LEN(*FFileTitle) - 1
		pchar = FFileTitle
		pchar[cbPos] = 0
		DIM ofn AS OPENFILENAME
			ZeroMemory(@ofn, sizeof(ofn))
		ofn.lStructSize     = SIZEOF(ofn)
		If App.MainForm Then ofn.hwndOwner       = App.MainForm->Handle
		ofn.lpstrFilter     = @wFilter
		ofn.nFilterIndex    = 1
		ofn.lpstrFile       = @cwsFile
		ofn.lpstrFileTitle       = FFileTitle
		ofn.nMaxFileTitle       = 256
		'ofn.lpstrFile[0] = 0
		ofn.nMaxFile        = (Max_Path + 1) * 100
		ofn.lpstrInitialDir = NULL
		IF LEN(*FCaption) THEN ofn.lpstrTitle = FCaption
		ofn.Flags = dwFlags
		IF FDefaultExt THEN ofn.lpstrDefExt = FDefaultExt
		bResult = GetOpenFilename(@ofn)
		IF bResult THEN
			FileName = cwsFile
			Dim buff As WString Ptr = @cwsFile
			For i As Integer = 0 To max_path * 100
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
		END IF
		'Deallocate cwsFile
		'Deallocate wFilter
	#EndIf
    Return bResult
    Exit Function
ErrorHandler:
    MsgBox ErrDescription(Err) & " (" & Err & ") " & _
        "in line " & Erl() & " " & _
        "in function " & ZGet(Erfn()) & " " & _
        "in module " & ZGet(Ermn())
End Function

Constructor OpenFileDialog
    'FInitialDir       = CAllocate(0)
    'FCaption          = CAllocate(0)
    'FDefaultExt       = CAllocate(0)
    'FFileName         = CAllocate(0)
    'FFilter           = CAllocate(0)
    #IfDef __USE_GTK__
		
    #Else	
		Options.Include OFN_PATHMUSTEXIST 
		Options.Include OFN_FILEMUSTEXIST 
		'Options.Include OFN_HIDEREADONLY
		'Options.Include OFN_EXPLORER 
		'Options.Include OFN_ENABLEHOOK
	#EndIf
    Caption           = "Open ..."
    FilterIndex       = 1
    Center            = True
    'Control.Child     = @This
    WLet FClassName, "OpenFileDialog"
End Constructor

Destructor OpenFileDialog
    If FInitialDir Then DeAllocate FInitialDir
    If FCaption Then DeAllocate FCaption
    If FDefaultExt Then DeAllocate FDefaultExt
    If FFileName Then DeAllocate FFileName
    If FFileTitle Then DeAllocate FFileTitle
    If FFilter Then DeAllocate FFilter
End Destructor

Type SaveFileDialog Extends Dialog
    Private:
		#IfNDef __USE_GTK__
			Declare Static Function Hook(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As UInteger
        #EndIf
        Control      As My.Sys.Forms.Control
        FInitialDir   As WString Ptr
        FCaption      As WString Ptr
        FDefaultExt   As WString Ptr
        FFileName     As WString Ptr
        FFilter       As WString Ptr 
    Public:
        FilterIndex  As Integer
        Declare Property InitialDir ByRef As WString
        Declare Property InitialDir(ByRef Value As WString)
        Declare Property Caption ByRef As WString
        Declare Property Caption(ByRef Value As WString)
        Declare Property DefaultExt ByRef As WString
        Declare Property DefaultExt(ByRef Value As WString)
        Declare Property FileName ByRef As WString
        Declare Property FileName(ByRef Value As WString)
        Declare Property Filter ByRef As WString
        Declare Property Filter(ByRef Value As WString)
        #IfNDef __USE_GTK__
			Handle       As HWND
        #EndIf
        Options      As OpenFileDialogOptions
        Center       As Boolean
        Declare Property Color As Integer
        Declare Property Color(Value As Integer)
        Declare Function Execute As Boolean
        Declare Constructor
        Declare Destructor
        OnFolderChange    As Sub(BYREF Sender As My.Sys.Forms.Control)
        OnSelectionChange As Sub(BYREF Sender As My.Sys.Forms.Control)
        OnTypeChange      As Sub(BYREF Sender As My.Sys.Forms.Control, Index As Integer)
End Type

Property SaveFileDialog.InitialDir ByRef As WString
    Return WGet(FInitialDir)
End Property

Property SaveFileDialog.InitialDir(ByRef Value As WString)
    FInitialDir    = Reallocate(FInitialDir, (Len(Value) + 1) * SizeOf(WString))
    *FInitialDir = Value
End Property

Property SaveFileDialog.Caption ByRef As WString
    Return WGet(FCaption)
End Property

Property SaveFileDialog.Caption(ByRef Value As WString)
    FCaption    = Reallocate(FCaption, (Len(Value) + 1) * SizeOf(WString))
    *FCaption = Value
End Property

Property SaveFileDialog.DefaultExt ByRef As WString
    Return WGet(FDefaultExt)
End Property

Property SaveFileDialog.DefaultExt(ByRef Value As WString)
    FDefaultExt    = Reallocate(FDefaultExt, (Len(Value) + 1) * SizeOf(WString))
    *FDefaultExt = Value
End Property

Property SaveFileDialog.FileName ByRef As WString
    Return WGet(FFileName)
End Property

Property SaveFileDialog.FileName(ByRef Value As WString)
    FFileName    = Reallocate(FFileName, (Len(Value) + 1) * SizeOf(WString))
    *FFileName = Value
End Property

Property SaveFileDialog.Filter ByRef As WString
    Return WGet(FFilter)
End Property

Property SaveFileDialog.Filter(ByRef Value As WString)
    FFilter    = Reallocate(FFilter, (Len(Value) + 1) * SizeOf(WString))
    *FFilter = Value
End Property

#IfNDef __USE_GTK__
	Function SaveFileDialog.Hook(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As UInteger
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
			Select Case POF->hdr.Code
			Case CDN_FILEOK
				SetWindowLongPtr GetParent(FWindow),DWLP_MSGRESULT,1
				Exit Function
			Case CDN_SELCHANGE
				If SaveDial Then If SaveDial->OnSelectionChange Then SaveDial->OnSelectionChange(*Ctrl)
			Case CDN_FOLDERCHANGE
				If SaveDial Then If SaveDial->OnFolderChange Then SaveDial->OnFolderChange(*Ctrl)
			Case CDN_TYPECHANGE
				Dim As Integer Index
				Index = *Cast(OPENFILENAME Ptr,POF->lpOFN).nFilterIndex
				If SaveDial Then 
					SaveDial->FilterIndex = Index
					If SaveDial->OnTypeChange Then 
						SaveDial->OnTypeChange(*Ctrl, Index)
					End If
				End If
			Case CDN_INITDONE
				If SaveDial Then
					If SaveDial->Center Then
						Dim As Rect R
						Dim As Integer L,T,W,H
						GetWindowRect(GetParent(FWindow),@R)
						L = R.Left
						T = R.Top
						W = R.Right - R.Left
						H = R.Bottom - R.Top
						L = (GetSysTemMetrics(SM_CXSCREEN) - W)\2
						T = (GetSysTemMetrics(SM_CYSCREEN) - H)\2:PRINT L,T
						SetWindowPos GetParent(FWindow),0,L,T,0,0,SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER
					End If
				End If
			End Select
		End Select
		Return False
	End Function
#EndIf

Function SaveFileDialog.Execute As Boolean
    Dim bResult As Boolean
    #IfDef __USE_GTK__
		Dim As GtkWindow Ptr win
		If App.MainForm Then
			win = Gtk_Window(App.MainForm->widget)
		End If
		widget =  gtk_file_chooser_dialog_new (ToUTF8("Save File"), _
                                      win, _
                                      GTK_FILE_CHOOSER_ACTION_SAVE, _
                                      ToUTF8("Cancel"), GTK_RESPONSE_CANCEL, _
                                      ToUTF8("Save"), GTK_RESPONSE_ACCEPT, _
                                      NULL)
		'gtk_file_chooser_set_current_name(GTK_FILE_CHOOSER (widget), *FFileName)
		'gtk_file_chooser_set_do_overwrite_confirmation (GTK_FILE_CHOOSER (widget), TRUE)
		'gtk_file_chooser_set_select_multiple(GTK_FILE_CHOOSER (widget), true)
		Dim As Integer res = gtk_dialog_run (GTK_DIALOG (widget))
		bResult = res = GTK_RESPONSE_ACCEPT
		If bResult Then
			filename = WStr(*gtk_file_chooser_get_filename (GTK_FILE_CHOOSER (widget)))
		End If
		gtk_widget_destroy( GTK_WIDGET(widget) )
    #Else
		Dim dwFlags As DWORD = Cast(Integer, Options)
		Dim dwBufLen AS DWORD
		Dim wMarkers AS WString * 4 = "||"
		If Right(*FFilter, 1) <> "|" Then wMarkers += "|"
		Dim wFilter As WString Ptr = CAllocate(260 * SizeOf(WString))
		*wFilter = *FFilter & wMarkers
		Dim dwFilterStrSize As DWORD = Len(*wFilter)
		Dim pchar As WChar Ptr = wFilter
		For i As Long = 0 To Len(*wFilter) - 1
			If pchar[i] = Asc("|") Then pchar[i] = 0
		Next
		If Len(*FInitialDir) = 0 Then FInitialDir = ReAllocate(FInitialDir, (Len(CURDIR) + 1) * SizeOf(WString)): *FInitialDir = CURDIR
		If dwBufLen = 0 Then
			If (dwFlags And OFN_ALLOWMULTISELECT = OFN_ALLOWMULTISELECT) Then dwBufLen = 32768  ' // 64 Kb buffer
		End If
		If dwBufLen < 260 Then dwBufLen = 260
		Dim cwsFile As WString Ptr = CAllocate((Len(*FFileName & "|") + 1) * SizeOf(WString))
		*cwsFile = *FFileName & "|"
		DIM cbPos AS LONG = LEN(*cwsFile) - 1
		IF LEN(*cwsFile) < dwBufLen THEN cwsFile = ReAllocate(cwsFile, (dwBufLen + 1) * SizeOf(WString)): *cwsFile += SPACE(dwBufLen - LEN(*cwsFile))
		DIM dwFileStrSize AS Integer = LEN(*cwsFile)
		pchar = cwsFile
		pchar[cbPos] = 0
		DIM ofn AS OPENFILENAME
		ofn.lStructSize     = SIZEOF(ofn)
		If App.MainForm Then ofn.hwndOwner       = App.MainForm->Handle
		ofn.lpstrFilter     = wFilter
		ofn.nFilterIndex    = 1
		ofn.lpstrFile       = cwsFile
		'ofn.lpstrFile[0] = 0
		ofn.nMaxFile        = dwFileStrSize
		ofn.lpstrInitialDir = FInitialDir
		IF LEN(*FCaption) THEN ofn.lpstrTitle = FCaption
		ofn.Flags = dwFlags
		IF FDefaultExt THEN ofn.lpstrDefExt = FDefaultExt
		IF GetSaveFilename(@ofn) THEN
			FileName = *cwsFile
			bResult = True
		Else
			bResult = False
		END IF
		Deallocate cwsFile
		Deallocate wFilter
	#EndIf
    Return bResult
End Function

Property SaveFileDialog.Color As Integer
    Return Control.BackColor
End Property

Property SaveFileDialog.Color(Value As Integer)
    Control.BackColor = Value
End Property

Constructor SaveFileDialog
    FInitialDir   = CAllocate(0)
    FCaption      = CAllocate(0)
    FDefaultExt   = CAllocate(0)
    FFileName     = CAllocate(0)
    FFilter       = CAllocate(0)
    Caption       = "Save As"
    FilterIndex   = 1
    WLet FClassName, "SaveFileDialog"
    Center        = True
    'Control.Child = @This
    #IfNDef __USE_GTK__
		Options.Include OFN_FILEMUSTEXIST 
		Options.Include OFN_PATHMUSTEXIST 
		Options.Include OFN_EXPLORER 
		'Options.Include OFN_ENABLEHOOK
	#EndIf
End Constructor

Destructor SaveFileDialog
    DeAllocate FInitialDir
    DeAllocate FCaption
    DeAllocate FDefaultExt
    DeAllocate FFileName
    DeAllocate FFilter
End Destructor

Type FontDialog Extends Dialog
     Font        As My.Sys.Drawing.Font
     MaxFontSize As Integer
     MinFontSize As Integer
     Declare Function Execute As Boolean
     Declare Constructor
     Declare Destructor
End Type

Function FontDialog.Execute As Boolean
    Static As Integer FWidth(2) = {400,700}
    #IfNDef __USE_GTK__
		Dim As CHOOSEFONT CF
		Dim As LOGFONT LGF
		Dim As HDC Dc
		Dc = GetDC(HWND_DESKTOP)
		LGF.lfItalic      = Font.Italic
		LGF.lfUnderLine   = Font.UnderLine
		LGF.lfStrikeOut   = Font.StrikeOut
		LGF.lfHeight      = -MulDiv(Font.Size, GetDeviceCaps(Dc, LOGPIXELSY), 72)
		LGF.lfWeight      = FWidth(Font.Bold)
		LGF.lfFaceName    = Font.Name
		CF.lStructSize    = SizeOf(CHOOSEFONTA)
		CF.hwndOwner      = MainHandle
		CF.HDC            = Dc
		CF.Flags          = CF_BOTH or CF_EFFECTS  or CF_INITTOLOGFONTSTRUCT
		CF.rgbColors      = Font.Color
		CF.lpLogFont      = @LGF
		ReleaseDC HWND_DESKTOP,Dc
		If ChooseFont(@CF) <> 0 then
			Font.Name        = LGF.lfFaceName
			Font.Italic      = LGF.lfItalic
			Font.UnderLine   = LGF.lfUnderLine
			Font.StrikeOut   = LGF.lfStrikeOut
			Font.Color       = CF.rgbColors
			Font.Size        = LGF.lfHeight
			Font.Bold        = IIf(LGF.lfWeight = 700,True,False)
			Return True
		Else
			Return False
		End If
	#Else
		Return False
	#EndIf
End Function

Constructor FontDialog
     MaxFontSize = 0
     MinFontSize = 0
     WLet FClassName, "FontDialog"
End Constructor

Destructor FontDialog
End Destructor

Type FolderBrowserDialog Extends Dialog
    Private:
		#IfNDef __USE_GTK__
			Declare Static Function Hook(hWnd As HWND, uMsg As uINT, lParam AS LPARAM, lpData As LPARAM) As Integer
        #EndIf
        Control    As My.Sys.Forms.Control
        FCaption    As WString Ptr
        FTitle      As WString Ptr
        FInitialDir As WString Ptr
        FDirectory  As WString Ptr
     Public:
		#IfNDef __USE_GTK__
			Handle     As HWND
		#EndIf
        Declare Property Caption ByRef As WString
        Declare Property Caption(ByRef Value As WString)
        Declare Property Title ByRef As WString
        Declare Property Title(ByRef Value As WString)
        Declare Property InitialDir ByRef As WString
        Declare Property InitialDir(ByRef Value As WString)
        Declare Property Directory ByRef As WString
        Declare Property Directory(ByRef Value As WString)
        Center     As Boolean
        Declare Function Execute As Boolean
        Declare Constructor
        Declare Destructor
End Type

Property FolderBrowserDialog.Caption ByRef As WString
    Return WGet(FCaption)
End Property

Property FolderBrowserDialog.Caption(ByRef Value As WString)
    FCaption    = Reallocate(FCaption, (Len(Value) + 1) * SizeOf(WString))
    *FCaption = Value
End Property

Property FolderBrowserDialog.Title ByRef As WString
    Return WGet(FTitle)
End Property

Property FolderBrowserDialog.Title(ByRef Value As WString)
    FTitle    = Reallocate(FTitle, (Len(Value) + 1) * SizeOf(WString))
    *FTitle = Value
End Property

Property FolderBrowserDialog.InitialDir ByRef As WString
    Return WGet(FInitialDir)
End Property

Property FolderBrowserDialog.InitialDir(ByRef Value As WString)
    FInitialDir    = Reallocate(FInitialDir, (Len(Value) + 1) * SizeOf(WString))
    *FInitialDir = Value
End Property

Property FolderBrowserDialog.Directory ByRef As WString
    Return WGet(FDirectory)
End Property

Property FolderBrowserDialog.Directory(ByRef Value As WString)
    FDirectory    = Reallocate(FDirectory, (Len(Value) + 1) * SizeOf(WString))
    *FDirectory = Value
End Property

#IfNDef __USE_GTK__
	Function FolderBrowserDialog.Hook(FWindow As HWND,uMsg As uINT,lParam AS LPARAM,lpData As LPARAM) As Integer
		Dim As FolderBrowserDialog Ptr BrowseDial
		Dim As My.Sys.Forms.Control Ptr Ctrl
		Dim R As Rect
		If uMsg = BFFM_INITIALIZED then
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
			'SendMessage(FWindow,BFFM_SETSELECTIONA,1,CUint(lpData))
			'If Len(BrowseDial->Caption) then
			'   SetWindowText(FWindow, BrowseDial->FCaption)
			'End If
		End If
		Return False
	End Function
#EndIf

Function FolderBrowserDialog.Execute As Boolean
	Dim As Boolean bResult
    #IfDef __USE_GTK__
		Dim As GtkWindow Ptr win
		If App.MainForm Then
			win = Gtk_Window(App.MainForm->widget)
		End If
		widget =  gtk_file_chooser_dialog_new (ToUTF8("Choose Folder"), _
                                      win, _
                                      GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER, _
                                      ToUTF8("Cancel"), GTK_RESPONSE_CANCEL, _
                                      ToUTF8("Open"), GTK_RESPONSE_ACCEPT, _
                                      NULL)
		'gtk_file_chooser_set_current_name(GTK_FILE_CHOOSER (widget), *FFileName)
		'gtk_file_chooser_set_do_overwrite_confirmation (GTK_FILE_CHOOSER (widget), TRUE)
		'gtk_file_chooser_set_select_multiple(GTK_FILE_CHOOSER (widget), true)
		Dim As Integer res = gtk_dialog_run (GTK_DIALOG (widget))
		bResult = res = GTK_RESPONSE_ACCEPT
		If bResult Then
			Directory = WStr(*gtk_file_chooser_get_filename (GTK_FILE_CHOOSER (widget)))
		End If
		gtk_widget_destroy( GTK_WIDGET(widget) )
		Return bResult
    #Else
		Dim BI    As BROWSEINFO
		Dim pidl  As Any Ptr
		Dim sPath AS WString Ptr = CAllocate(MAX_PATH * SizeOf(WString))
		Dim xPath AS WString Ptr = CAllocate(MAX_PATH * SizeOf(WString))
		FDirectory = CAllocate(MAX_PATH * SizeOf(WString))
		
		*sPath = WString(MAX_PATH,0)
		*xPath = WString(MAX_PATH,0)                             '
		InitialDir        = InitialDir + Chr(0)
		BI.hWndOwner      = MainHandle
		BI.pszDisplayName = xPath
		BI.lpszTitle      = FTitle
		'BI.lpfn           = @FolderBrowserDialog.Hook
		BI.lParam         = Cast(LPARAM, FInitialDir)
		'Message.Captured = Control
		pidl = SHBrowseForFolder(@BI)
		If pidl then
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
	#EndIf
End Function

Constructor FolderBrowserDialog
    FCaption = CAllocate(0)
    FTitle = CAllocate(0)
    WLet FClassName, "FolderBrowserDialog"
    FInitialDir = CAllocate(0)
    FDirectory = CAllocate(0)
    'Control.Child = @This
    Title = "Please select a Folder :"
End Constructor

Destructor FolderBrowserDialog
    DeAllocate FCaption
    DeAllocate FTitle
    DeAllocate FInitialDir
    DeAllocate FDirectory
End Destructor

Type ColorDialog Extends Dialog
     Private:
		#IfNDef __USE_GTK__
			CC              As CHOOSECOLOR
		#EndIf
        _Caption        As WString Ptr
        #IfNDef __USE_GTK__
			Declare Static Function Hook(FWindow As HWND,Msg As UINT,wParam As WPARAM,lParam As LPARAM) As UInteger
		#EndIf
     Public:
        Parent          As My.Sys.Forms.Control Ptr
        Center          As Integer
        #IfNDef __USE_GTK__
			Handle          As Hwnd
		#EndIf
        Declare Property Caption ByRef As WString
        Declare Property Caption(ByRef Value As WString)
        Color           As Integer
        Style           As Integer
        #IfNDef __USE_GTK__
			Colors(16)      As COLORREF => {&H0,&H808080,&H000080,&H008080,_
											&H008000,&H808000,&H800000,&H800080,_
											&HFFFFFF,&HC0C0C0,&H0000FF,&H00FFFF,_
											&H00FF00,&HFFFF00,&HFF0000,&HFF00FF _
										}
        #EndIf
        BackColor       As Integer
        Declare Operator Cast As Any Ptr
        Declare Function Execute As Boolean
        Declare Constructor
        Declare Destructor
End Type

#IfNDef __USE_GTK__
	Function ColorDialog.Hook(FWindow As HWND,Msg As UINT,wParam As WPARAM,lParam As LPARAM) As UInteger

		Static As HBrush Brush

		Select Case Msg

		Case wm_initdialog 

			Dim As ColorDialog Ptr CommonDialog = Cast(ColorDialog Ptr,*Cast(lpChooseColor,lParam).lCustData)

			If CommonDialog Then

				CommonDialog->Handle = FWindow

				SetWindowLongPtr(FWindow,DWLP_MSGRESULT,Cint(CommonDialog))

				SetWindowText(FWindow, CommonDialog->_Caption)

				If CommonDialog->Center Then 

				   Dim As Rect R,Wr

				   GetWindowRect(FWindow,@Wr)

				   SystemParametersInfo(spi_getworkarea,0,@R,0)

				   MoveWindow(FWindow,(R.Right  - (Wr.Right - Wr.Left))/2,(R.Bottom - (Wr.Bottom - Wr.Top))/2,Wr.Right - Wr.Left,Wr.Bottom - Wr.Top,1)

				End If

				Brush = CreateSolidBrush(CommonDialog->BackColor)

			End If

			Return True

		Case wm_ctlcolordlg To wm_ctlcolorstatic

			Dim As ColorDialog Ptr CommonDialog = Cast(ColorDialog Ptr,GetWindowLongPtr(FWindow,DWLP_MSGRESULT))

			If CommonDialog Then

				With *CommonDialog

					SetBkMode(Cast(HDc,wParam),Transparent)

					SetBkColor(Cast(HDc,wParam),.BackColor)

					SetBkMode(Cast(HDc,wParam),Opaque)

					Return CInt(Brush)

				End With

			End If     

		Case wm_erasebkgnd

			Dim As ColorDialog Ptr CommonDialog = Cast(ColorDialog Ptr,GetWindowLongPtr(FWindow,DWLP_MSGRESULT))

			If CommonDialog Then

				With *CommonDialog

					Dim As HDC Dc = Cast(HDC,wParam)

					Dim As Rect R

					GetClientRect(FWindow,@R)

					FillRect(Dc,@R,Brush)

					Return True

				End With

			End If

		Case Else

			Return False

		End Select

		Return True

	End Function
#EndIf

Property ColorDialog.Caption ByRef As WString
    Return WGet(_Caption)
End Property

Property ColorDialog.Caption(ByRef Value As WString)
    WLet _Caption, Value
End Property

Function ColorDialog.Execute As Boolean
	#IfNDef __USE_GTK__
		Dim As ChooseColor CC
		CC.lStructSize  = SizeOf(CC)
		CC.lpCustColors = @Colors(0)
		CC.hWndOwner    = IIf(Parent,Parent->Handle,0)
		CC.RGBResult    = This.Color
		CC.Flags        = CC_RGBINIT
		CC.Flags        = CC.Flags or CC_ENABLEHOOK
		Select Case Style
		Case 0
			CC.Flags    = CC.Flags or CC_FULLOPEN 
		Case 1
			CC.Flags    = CC.Flags or CC_PREVENTFULLOPEN
		End Select
		CC.lpfnHook     = @Hook
		CC.lCustData    = Cast(lParam,@This)
		If ChooseColor(@CC) Then
		   This.Color = CC.RGBResult
		   Return True
		End If
	#EndIf
	Return False
End Function

Operator ColorDialog.Cast as any ptr
    return @This
end Operator

Constructor ColorDialog
    Caption = "Choose Color..."
    WLet FClassName, "ColorDialog"
    #IfNDef __USE_GTK__
		BackColor = GetSysColor(color_btnface)
	#EndIf
End Constructor

Destructor ColorDialog
End Destructor

