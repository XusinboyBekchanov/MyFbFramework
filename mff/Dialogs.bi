#INCLUDE Once "Application.bi"
#INCLUDE Once "Win/ShlObj.bi"

Const OFN_ENABLEINCLUDENOTIFY = &H400000

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
        Declare Static Function Hook(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As UInteger
        Control     As My.Sys.Forms.Control
        FInitialDir   As WString Ptr
        FCaption      As WString Ptr
        FDefaultExt   As WString Ptr
        FFileName     As WString Ptr
        FFileTitle    As WString Ptr
        FFilter       As WString Ptr
     Public:
        FilterIndex  As Integer
        cwsFile As WString  * (MAX_PATH +1) * 1000
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
        Handle       As HWND
        Options      As OpenFileDialogOptions
        Center       As Boolean
        Declare Function Execute As Boolean
        Declare Constructor
        Declare Destructor
        OnFolderChange    As Sub(BYREF Sender As My.Sys.Forms.Control)
        OnSelectionChange As Sub(BYREF Sender As My.Sys.Forms.Control)
        OnTypeChange      As Sub(BYREF Sender As My.Sys.Forms.Control, Index As Integer)
End Type

Property OpenFileDialog.InitialDir ByRef As WString
    Return *FInitialDir
End Property

Property OpenFileDialog.InitialDir(ByRef Value As WString)
    FInitialDir    = Reallocate(FInitialDir, (Len(Value) + 1) * SizeOf(WString))
    *FInitialDir = Value
End Property

Property OpenFileDialog.Caption ByRef As WString
    Return *FCaption
End Property

Property OpenFileDialog.Caption(ByRef Value As WString)
    FCaption    = Reallocate(FCaption, (Len(Value) + 1) * SizeOf(WString))
    *FCaption = Value
End Property

Property OpenFileDialog.DefaultExt ByRef As WString
    Return *FDefaultExt
End Property

Property OpenFileDialog.DefaultExt(ByRef Value As WString)
    FDefaultExt    = Reallocate(FDefaultExt, (Len(Value) + 1) * SizeOf(WString))
    *FDefaultExt = Value
End Property

Property OpenFileDialog.FileName ByRef As WString
    Return *FFileName
End Property

Property OpenFileDialog.FileName(ByRef Value As WString)
    FFileName    = Reallocate(FFileName, (Len(Value) + 1) * SizeOf(WString))
    *FFileName = Value
End Property

Property OpenFileDialog.FileTitle ByRef As WString
    Return *FFileTitle
End Property

Property OpenFileDialog.FileTitle(ByRef Value As WString)
    WLet FFileTitle, Value
End Property

Property OpenFileDialog.Filter ByRef As WString
    Return *FFilter
End Property

Property OpenFileDialog.Filter(ByRef Value As WString)
    FFilter    = Reallocate(FFilter, (Len(Value) + 1) * SizeOf(WString))
    *FFilter = Value
End Property

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

Function OpenFileDialog.Execute As Boolean
    Dim dwFlags As DWORD = Cast(Integer, Options)
    Dim dwBufLen AS DWORD
    Dim bResult As Boolean
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
    ofn.lStructSize     = SIZEOF(ofn)
    If App.MainForm Then ofn.hwndOwner       = App.MainForm->Handle
    ofn.lpstrFilter     = wFilter
    ofn.nFilterIndex    = 1
    ofn.lpstrFile       = @cwsFile
    ofn.lpstrFileTitle       = FFileTitle
    ofn.nMaxFileTitle       = 256
    'ofn.lpstrFile[0] = 0
    ofn.nMaxFile        = (Max_Path + 1) * 1000
    ofn.lpstrInitialDir = NULL
    IF LEN(*FCaption) THEN ofn.lpstrTitle = FCaption
    ofn.Flags = dwFlags
    IF FDefaultExt THEN ofn.lpstrDefExt = FDefaultExt
    IF GetOpenFilename(@ofn) THEN
        FileName = cwsFile
        bResult = True
    Else
        bResult = False
    END IF
    'Deallocate cwsFile
    Deallocate wFilter
    Return bResult
End Function

Constructor OpenFileDialog
    'FInitialDir       = CAllocate(0)
    'FCaption          = CAllocate(0)
    'FDefaultExt       = CAllocate(0)
    'FFileName         = CAllocate(0)
    'FFilter           = CAllocate(0)
    Caption           = "Faylni ochish..."
    FilterIndex       = 1
    Center            = True
    'Control.Child     = @This
    Options.Include OFN_PATHMUSTEXIST 
    Options.Include OFN_FILEMUSTEXIST 
    'Options.Include OFN_HIDEREADONLY
    'Options.Include OFN_EXPLORER 
    'Options.Include OFN_ENABLEHOOK
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
        Declare Static Function Hook(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As UInteger
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
        Handle       As HWND
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
    Return *FInitialDir
End Property

Property SaveFileDialog.InitialDir(ByRef Value As WString)
    FInitialDir    = Reallocate(FInitialDir, (Len(Value) + 1) * SizeOf(WString))
    *FInitialDir = Value
End Property

Property SaveFileDialog.Caption ByRef As WString
    Return *FCaption
End Property

Property SaveFileDialog.Caption(ByRef Value As WString)
    FCaption    = Reallocate(FCaption, (Len(Value) + 1) * SizeOf(WString))
    *FCaption = Value
End Property

Property SaveFileDialog.DefaultExt ByRef As WString
    Return *FDefaultExt
End Property

Property SaveFileDialog.DefaultExt(ByRef Value As WString)
    FDefaultExt    = Reallocate(FDefaultExt, (Len(Value) + 1) * SizeOf(WString))
    *FDefaultExt = Value
End Property

Property SaveFileDialog.FileName ByRef As WString
    Return *FFileName
End Property

Property SaveFileDialog.FileName(ByRef Value As WString)
    FFileName    = Reallocate(FFileName, (Len(Value) + 1) * SizeOf(WString))
    *FFileName = Value
End Property

Property SaveFileDialog.Filter ByRef As WString
    Return *FFilter
End Property

Property SaveFileDialog.Filter(ByRef Value As WString)
    FFilter    = Reallocate(FFilter, (Len(Value) + 1) * SizeOf(WString))
    *FFilter = Value
End Property

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

Function SaveFileDialog.Execute As Boolean
    Dim dwFlags As DWORD = Cast(Integer, Options)
    Dim dwBufLen AS DWORD
    Dim bResult As Boolean
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
    Return bResult
End Function

Property SaveFileDialog.Color As Integer
    Return Control.Color
End Property

Property SaveFileDialog.Color(Value As Integer)
    Control.Color = Value
End Property

Constructor SaveFileDialog
    FInitialDir   = CAllocate(0)
    FCaption      = CAllocate(0)
    FDefaultExt   = CAllocate(0)
    FFileName     = CAllocate(0)
    FFilter       = CAllocate(0)
    Caption       = "Faylni ... kabi saqlash"
    FilterIndex   = 1
    Center        = True
    'Control.Child = @This
    Options.Include OFN_FILEMUSTEXIST 
    Options.Include OFN_PATHMUSTEXIST 
    Options.Include OFN_EXPLORER 
    'Options.Include OFN_ENABLEHOOK
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
End Function

Constructor FontDialog
     MaxFontSize = 0
     MinFontSize = 0
End Constructor

Destructor FontDialog
End Destructor

Type FolderBrowserDialog Extends Dialog
    Private:
        Declare Static Function Hook(hWnd As HWND, uMsg As uINT, lParam AS LPARAM, lpData As LPARAM) As Integer
        Control    As My.Sys.Forms.Control
        FCaption    As WString Ptr
        FTitle      As WString Ptr
        FInitialDir As WString Ptr
        FDirectory  As WString Ptr
     Public:
        Handle     As HWND
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
    Return *FCaption
End Property

Property FolderBrowserDialog.Caption(ByRef Value As WString)
    FCaption    = Reallocate(FCaption, (Len(Value) + 1) * SizeOf(WString))
    *FCaption = Value
End Property

Property FolderBrowserDialog.Title ByRef As WString
    Return *FTitle
End Property

Property FolderBrowserDialog.Title(ByRef Value As WString)
    FTitle    = Reallocate(FTitle, (Len(Value) + 1) * SizeOf(WString))
    *FTitle = Value
End Property

Property FolderBrowserDialog.InitialDir ByRef As WString
    Return *FInitialDir
End Property

Property FolderBrowserDialog.InitialDir(ByRef Value As WString)
    FInitialDir    = Reallocate(FInitialDir, (Len(Value) + 1) * SizeOf(WString))
    *FInitialDir = Value
End Property

Property FolderBrowserDialog.Directory ByRef As WString
    Return *FDirectory
End Property

Property FolderBrowserDialog.Directory(ByRef Value As WString)
    FDirectory    = Reallocate(FDirectory, (Len(Value) + 1) * SizeOf(WString))
    *FDirectory = Value
End Property

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

Function FolderBrowserDialog.Execute As Boolean
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
End Function

Constructor FolderBrowserDialog
    FCaption = CAllocate(0)
    FTitle = CAllocate(0)
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
