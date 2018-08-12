'###############################################################################
'#  Form.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Version 1.0.0                                                              #
'###############################################################################

#Include Once "ContainerControl.bi"
#Include Once "Application.bi"

Namespace My.Sys.Forms
    #DEFINE QForm(__Ptr__) *Cast(Form Ptr,__Ptr__)

    Enum ModalResults
        OK
        Cancel
        Yes
        No
    End Enum
    
    Enum FormBorderStyles
        bsNone
        bsChildDialog
        bsDialog
        bsSingle
        bsToolWindow
        bsSingleToolWindow
    End Enum
    
    Enum FormStyles
        fsNormal
        fsMDIForm
        fsMDIChild
        fsStayOnTop
    End Enum
            
    Enum WindowStates
        wsHide
        wsNormal
        wsMaximized
        wsMinimized
    End Enum
    
    Type Form Extends ContainerControl
        Private:
            FMainForm      As Boolean
            FMainStyle(2)  As Integer
            FMenuItems     As List
            FBorderStyle   As Integer
            FFormStyle     As Integer
            FBorderIcons   As Integer
            FExStyle(6)    As Integer
            FCmdShow(4)    As Integer
            FChild(2)      As Integer
            FStyle(6)      As Integer
            FClassStyle(6) As Integer
            FWindowState   As Integer
            FOnCreate      As Sub(BYREF Sender As Form)
            Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
            Declare Static Sub HandleIsDestroyed(BYREF Sender As Control)
            Declare Static Sub WndProc(BYREF Message As Message)
            Declare Function EnumMenuItems(Item As MenuItem) As Boolean
            Declare Sub GetMenuItems
        Protected:
            FIsChild       As Boolean
            Declare Sub ProcessMessage(BYREF Message As Message)
        Public:
            Icon          As My.Sys.Drawing.Icon
            Menu          As MainMenu Ptr
            ModalResult   As Integer 'ModalResults
            Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
            Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
            Declare Property ActiveControl As Control Ptr
            Declare Property ActiveControl(Value As Control Ptr)
            Declare Property DefaultButton As Control ptr 'CommandButton
            Declare Property DefaultButton(Value As Control ptr)
            Declare Property CancelButton As Control ptr 'CommandButton
            Declare Property CancelButton(Value As Control ptr)
            Declare Property BorderStyle As Integer 'FormBorderStyles
            Declare Property BorderStyle(Value As Integer)
            Declare Property FormStyle As Integer 'FormStyles
            Declare Property FormStyle(Value As Integer)
            Declare Property WindowState As Integer 'WindowStates
            Declare Property WindowState(Value As Integer)
            Declare Property Owner As Form Ptr
            Declare Property Owner(Value As Form Ptr)
            Declare Property Caption ByRef As WString
            Declare Property Caption(ByRef Value As WString)
            Declare Property MainForm As Boolean
            Declare Property MainForm(Value As Boolean)
            Declare Property Enabled As Boolean
            Declare Property Enabled(Value As Boolean)            
            Declare Property Visible As Boolean
            Declare Property Visible(Value As Boolean)            
            Declare Operator Cast As Control Ptr
            Declare Sub BringToFront
            Declare Sub SendToBack
            Declare Sub Invalidate
            Declare Sub Repaint
            Declare Sub Show
            Declare Sub Show(ByRef Parent As Form)
            Declare Function ShowModal As Integer
            Declare Sub Hide
            Declare Sub Minimize
            Declare Sub CloseForm
            Declare Sub Center
            Declare Constructor
            Declare Destructor
            OnPaint      As Sub(ByRef Sender As Form, DC As HDC, R As Rect)
            OnShow       As Sub(ByRef Sender As Form)
            OnHide       As Sub(ByRef Sender As Form)
            OnFree       As Sub(ByRef Sender As Form)
            OnClose      As Sub(ByRef Sender As Form, BYREF Action As Integer)
            OnSize       As Sub(ByRef Sender As Form)
            OnTimer      As Sub(ByRef Sender As Form)
            OnActivate   As Sub(ByRef Sender As Form)
            OnDeActivate As Sub(ByRef Sender As Form)
    End Type

    Function Form.ReadProperty(ByRef PropertyName As String) As Any Ptr
        FTempString = LCase(PropertyName)
        Select Case FTempString
        Case "borderstyle": Return @FBorderStyle
        Case "cancelbutton": Return FCancelButton
        Case "caption": Return This.FText
        Case "defaultbutton": Return FDefaultButton
        Case "icon": Return @Icon
        Case "formstyle": Return @FFormStyle
        Case "menu": Return Menu
        Case "mainform": Return @FMainForm
        Case "modalresult": Return @ModalResult
        Case "owner": Return FOwner
        Case "windowstate": Return @FWindowState
        Case Else: Return Base.ReadProperty(PropertyName)
        End Select
        Return 0
    End Function
    
    Function Form.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
        If Value = 0 Then
            Select Case LCase(PropertyName)
            Case Else: Return Base.WriteProperty(PropertyName, Value)
            End Select
        Else
            Select Case LCase(PropertyName)
            Case "borderstyle": This.BorderStyle = QInteger(Value)
            Case "cancelbutton": This.CancelButton = Cast(Control Ptr, Value)
            Case "caption": This.Caption = QWString(Value)
            Case "defaultbutton": This.DefaultButton = Cast(Control Ptr, Value)
            Case "formstyle": This.FormStyle = QInteger(Value)
            Case "icon": This.Icon = QWString(Value)
            Case "mainform": This.MainForm = QBoolean(Value)
            Case "menu": This.Menu = Cast(MainMenu Ptr, Value)
            Case "modalresult": This.ModalResult = QInteger(Value)
            Case "owner": This.Owner = Cast(Form Ptr, Value)
            Case "windowstate": This.WindowState = QInteger(Value)
            Case Else: Return Base.WriteProperty(PropertyName, Value)
            End Select
        End If
        Return True
    End Function
    
    Property Form.ActiveControl As Control Ptr
        Return FActiveControl
    End Property

    Property Form.ActiveControl(Value As Control Ptr)
        FActiveControl = Value
        'If FActiveControl Then FActiveControl->SetFocus
        If OnActiveControlChange Then OnActiveControlChange(This)
    End Property

    Property Form.Owner As Form Ptr
        Return Cast(Form Ptr, FOwner)
    End Property

    Property Form.Owner(Value As Form Ptr)
        If Value <> FOwner Then
           FOwner = Value
           If Handle AndAlso FOwner AndAlso FOwner->Handle Then 
               SetParent FOwner->Handle, Handle
           End If
        End If
    End Property

    Property Form.DefaultButton As Control Ptr
        Return FDefaultButton
    End Property
    
    Property Form.DefaultButton(Value As Control Ptr)
        FDefaultButton = Value
        If FDefaultButton AndAlso UCASE(*FDefaultButton.ClassName) = "COMMANDBUTTON" Then
            
        End If
    End Property
    
    Property Form.CancelButton As Control Ptr
        Return FCancelButton
    End Property
    
    Property Form.CancelButton(Value As Control Ptr)
        FCancelButton = Value
    End Property
    
    Property Form.MainForm As Boolean
        Return FMainForm
    End Property

    Property Form.MainForm(Value As Boolean)
        If Value <> FMainForm Then
            FMainForm = Value
            If App.MainForm <> 0 Then Cast(Form Ptr, App.MainForm)->MainForm = False
            ChangeExStyle WS_EX_APPWINDOW, Value
            If FMainForm Then
                App.MainForm = @This
            Else     
                App.MainForm = 0
            End If           
        End If
    End Property

    Property Form.BorderStyle As Integer
        Return FBorderStyle
    End Property

    Property Form.BorderStyle(Value As Integer)
        FBorderStyle = Value
        If Not DesignMode Then
            ExStyle = FExStyle(FBorderStyle) OR FMainStyle(Abs_(FMainForm))
            Style   = FStyle(FBorderStyle) Or FChild(Abs_(FIsChild))
        End If
    End Property

    Property Form.FormStyle As Integer
        Return FFormStyle
    End Property
      
    Property Form.FormStyle(Value As Integer)
        If Value = FFormStyle Then Exit Property
        FFormStyle = Value
        Select Case FFormStyle
        Case 0 'fsNormal
            If (ExStyle AND WS_EX_TOPMOST) = WS_EX_TOPMOST Then
                ExStyle = ExStyle AND NOT WS_EX_TOPMOST
                SetWindowPos Handle,HWND_NOTOPMOST,0,0,0,0,SWP_NOMOVE OR SWP_NOACTIVATE OR SWP_NOSIZE
            End If 
        Case 1 'fsMDIForm
        Case 2 'fsMDIChild
        Case 3 'fsStayOnTop
            If (ExStyle AND WS_EX_TOPMOST) <> WS_EX_TOPMOST Then
                ExStyle = ExStyle OR WS_EX_TOPMOST
                SetWindowPos Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE OR SWP_NOACTIVATE OR SWP_NOSIZE
            End If    
        End Select
    End Property

    Property Form.WindowState As Integer
        Return FWindowState
    End Property

    Property Form.WindowState(Value As Integer)
        FWindowState = Value
    End Property

    Property Form.Caption ByRef As WString
        Return Text
    End Property

    Property Form.Caption(ByRef Value As WString)
        Text = Value
    End Property

    Property Form.Enabled As Boolean
        Return Base.Enabled
    End Property

    Property Form.Enabled(Value As Boolean)
        Base.Enabled = Value
        FWindowState = Value
    End Property

    Sub Form.WndProc(BYREF message As Message)
    End Sub

    Sub Form.HandleIsDestroyed(BYREF Sender As Control)
        If Sender.Child Then
            With QForm(Sender.Child)
                SetMenu .Handle,NULL
                DrawMenuBar .Handle
            End With
        End If
    End Sub

    Function GetAscKeyCode(HotKey As String) As Integer
        Select Case HotKey
        Case "Backspace", "Back": Return 08
        Case "Tab": Return 09
        Case "Enter", "Return": Return 13
        Case "Escape", "Esc": Return 27
        Case "Space": Return 32
        Case "PageUp": Return 33
        Case "PageDown": Return 34
        Case "End": Return 35
        Case "Home": Return 36
        Case "Left": Return 37
        Case "Up": Return 38
        Case "Right": Return 39
        Case "Down": Return 40
        Case "Print": Return 42
        Case "Insert", "Ins": Return 45
        Case "Num0": Return 96
        Case "Num1": Return 97
        Case "Num2": Return 98
        Case "Num3": Return 99
        Case "Num4": Return 100
        Case "Num5": Return 101
        Case "Num6": Return 102
        Case "Num7": Return 103
        Case "Num8": Return 104
        Case "Num9": Return 105
        Case "F1": Return 112
        Case "F2": Return 113
        Case "F3": Return 114
        Case "F4": Return 115
        Case "F5": Return 116
        Case "F6": Return 117
        Case "F7": Return 118
        Case "F8": Return 119
        Case "F9": Return 120
        Case "F10": Return 121
        Case "F11": Return 122
        Case "F12": Return 123
        Case "Delete", "Del": : Return 127
        Case Else: Return Asc(HotKey)
        End Select
    End Function
    
    Sub Form.HandleIsAllocated(BYREF Sender As Control)
        If Sender.Child Then
            Dim As HMENU NoNeedSysMenu
            With QForm(Sender.Child)
                 SetClassLong(.Handle,GCL_STYLE,.FClassStyle(.BorderStyle))
                 If .FBorderStyle = 2 Then
                    SetClassLongPtr(.Handle,GCLP_HICON,NULL) 
                    SendMessage(.Handle,WM_SETICON,1,NULL)
                    NoNeedSysMenu = GetSystemMenu(.Handle, False)
                    DeleteMenu(NoNeedSysMenu, SC_TASKLIST, MF_BYCOMMAND)
                    DeleteMenu(NoNeedSysMenu, 7, MF_BYPOSITION)
                    DeleteMenu(NoNeedSysMenu, 5, MF_BYPOSITION)
                    DeleteMenu(NoNeedSysMenu, SC_MAXIMIZE, MF_BYCOMMAND)
                    DeleteMenu(NoNeedSysMenu, SC_MINIMIZE, MF_BYCOMMAND)
                    DeleteMenu(NoNeedSysMenu, SC_SIZE, MF_BYCOMMAND)
                    DeleteMenu(NoNeedSysMenu, SC_RESTORE, MF_BYCOMMAND)
                 Else
                    SendMessage(.Handle, WM_SETICON, 1, CInt(.Icon.Handle))
                    GetSystemMenu(.Handle, True)
                    EnableMenuItem(NoNeedSysMenu, SC_MINIMIZE, MF_BYCOMMAND OR MF_GRAYED)
                    EnableMenuItem(NoNeedSysMenu, SC_MAXIMIZE, MF_BYCOMMAND OR MF_GRAYED)
                 End If
                 If .Menu Then .Menu->ParentWindow = .Handle
                 .GetMenuItems
                Dim As String mnuCaption, HotKey
                Dim As Integer Pos1, CountOfHotKeys = 0
                Dim As MenuItem Ptr mi
                ReDim accl(1) As ACCEL
                For i As Integer = 0 To .FMenuItems.Count - 1
                    mi = .FMenuItems.Items[i]
                    mnuCaption = mi->Caption
                    Pos1 = InStr(mnuCaption, !"\t")
                    If Pos1 > 0 Then
                        CountOfHotKeys = CountOfHotKeys + 1
                        HotKey = Mid(mnuCaption, Pos1 + 1)
                        ReDim Preserve accl(CountOfHotKeys - 1) As ACCEL
                        If Instr(HotKey, "Ctrl") > 0 Then accl(CountOfHotKeys - 1).fVirt = accl(CountOfHotKeys - 1).fVirt Or FCONTROL
                        If Instr(HotKey, "Shift") > 0 Then accl(CountOfHotKeys - 1).fVirt = accl(CountOfHotKeys - 1).fVirt Or FSHIFT
                        If Instr(HotKey, "Alt") > 0 Then accl(CountOfHotKeys - 1).fVirt = accl(CountOfHotKeys - 1).fVirt Or FALT
                        accl(CountOfHotKeys - 1).fVirt = accl(CountOfHotKeys - 1).fVirt Or FVIRTKEY
                        Pos1 = InstrRev(HotKey, "+")
                        If Pos1 > 0 Then HotKey = Mid(HotKey, Pos1 + 1)
                        accl(CountOfHotKeys - 1).key = GetAscKeyCode(HotKey)
                        accl(CountOfHotKeys - 1).cmd = mi->Command
                    End If
                Next i
                .Accelerator = CreateAcceleratorTable(Cast(LPACCEL, @accl(0)), CountOfHotKeys)
            End With
        End If
    End Sub

    Sub Form.ProcessMessage(BYREF msg As Message)
        Dim As Integer Action = 1 
        Static As Boolean IsMenuItem
        Select Case msg.Msg
        Case WM_PAINT
             Dim As HDC Dc,memDC
             Dim As HBITMAP Bmp
             Dim As PAINTSTRUCT Ps
             Dc = BeginPaint(Handle,@Ps)
             If DoubleBuffered Then
                MemDC = CreateCompatibleDC(DC)
                Bmp   = CreateCompatibleBitmap(DC,Ps.rcpaint.Right,Ps.rcpaint.Bottom)
                SelectObject(MemDc,Bmp)
                SendMessage(Handle,WM_ERASEBKGND, CInt(MemDC), CInt(MemDC))
                FillRect memDc,@Ps.rcpaint, Brush.Handle
                If OnPaint Then OnPaint(This,memDC,Ps.rcpaint)
                BitBlt(DC, 0, 0, Ps.rcpaint.Right, Ps.rcpaint.Bottom, MemDC, 0, 0, SRCCOPY)
                DeleteObject(Bmp)
                DeleteDC(MemDC)
            Else
                FillRect Dc,@Ps.rcpaint, Brush.Handle
                If OnPaint Then OnPaint(This,DC,Ps.rcpaint) 
            End If
            EndPaint Handle,@Ps
            msg.Result = 0
        Case WM_CLOSE
            If OnClose Then
                OnClose(This, Action)
            End If
            Select Case Action
            Case 0
                msg.Result = -1
            Case 1
                If MainForm Then
                    PostQuitMessage 0 
                    'End 0
                Else
                   ShowWindow Handle,SW_HIDE
                   msg.Result = -1
                End If
            Case 2
                ShowWindow Handle,SW_MINIMIZE
                msg.Result = -1
            End Select
        Case WM_COMMAND
            GetMenuItems
            Dim As MenuItem Ptr mi
            For i As Integer = 0 To FMenuItems.Count -1
                mi = FMenuItems.Items[i]
                With *mi
                    If .Command = msg.wParamLo Then
                        If .OnClick Then .OnClick(*mi)
                        Exit For
                    End If
                End With
            Next i
            IsMenuItem = False
        Case WM_MENUSELECT
             IsMenuItem = True
        Case WM_INITMENU
        Case WM_INITMENUPOPUP
        Case WM_SIZE
             If OnSize Then OnSize(This)
        Case WM_TIMER
             If OnTimer Then OnTimer(This)
        Case WM_ACTIVATE
             Select Case msg.wParamLo
             Case WA_ACTIVE, WA_CLICKACTIVE 
                 If OnActivate Then OnActivate(This)
             Case WA_INACTIVE
                 If OnDeActivate Then OnDeActivate(This)
             End Select
        Case WM_DESTROY
            If Accelerator Then DestroyAcceleratorTable(Accelerator)
         Case WM_DRAWITEM
             Dim As DRAWITEMSTRUCT Ptr diStruct
             diStruct = Cast(DRAWITEMSTRUCT Ptr, msg.lParam)
             Select Case diStruct->CtlType 
             Case ODT_MENU    
                'If This.Menu AndAlso This.Menu->ImagesList AndAlso This.Menu->ImagesList->Handle AndAlso diStruct->itemData <> 0 Then
                '    ImageList_Draw(This.Menu->ImagesList->Handle, Cast(MenuItem Ptr, diStruct->itemData)->ImageIndex, diStruct->hDC, 2, 2, ILD_NORMAL)
                'End If
             End Select
         Case CM_HELP
             Dim As Point P
             Dim As HWND HControl
             Dim As Control Ptr Ctrl
             Dim As Integer ContextID,Id,i
             Dim As HELPINFO Ptr HIF
             HIF = Cast(HELPINFO Ptr, msg.lParam)
             If HIF->iContextType = HELPINFO_WINDOW Then
                 HControl = HIF->hItemHandle
                 Ctrl = Cast(Control Ptr, GetWindowLongPtr(HControl, GWLP_USERDATA)) 
                 If Ctrl Then
                    If Ctrl->HelpContext <> 0 Then
                        ContextID = Ctrl->HelpContext
                    Else
                        If Ctrl->Parent Then
                            Ctrl= Ctrl->Parent 
                            ContextID = Ctrl->HelpContext
                         Else
                            Exit Select
                         End If
                    End If
                 End If   
                 Ctrl->ClientToScreen(P)
             Else  ' Message.HelpInfo.iContextType = HELPINFO_MENUITEM 
                 Id = 0 
                 If This.Menu Then
                     For i = 0 To This.Menu->Count -1
                            If This.Menu->Item(i)->Command = HIF->iCtrlID Then
                                Id = i
                                Exit For
                            End If
                     Next i
                End If
'                 If Id Then ContextID = MainMenu.Item(Id)->HelpContext
'                 If ContextID = 0 Then 
'                     For i = 0 to MainMenu.Count -1
'                          If MainMenu.Items[i]->CommandID = HIF->iCtrlID Then
'                              Id = i
'                              Exit For
'                          End If
'                     Next i  
'                     If Id then ContextID = PopupMenu.Items[Id]->HelpContext
'                 End If   
                 This.ClientToScreen(P)
             End If
             If (GetWindowLong(Handle,GWL_EXSTYLE) AND WS_EX_CONTEXTHELP) = WS_EX_CONTEXTHELP Then
                 App.HelpCommand(HELP_SETPOPUP_POS, CInt(@P))
                 App.HelpCommand(HELP_CONTEXTPOPUP, ContextID)
             Else
                 App.HelpContext(ContextID)
             End If
        End Select
        Base.ProcessMessage(msg)
    End Sub
            
    Sub Form.SendToBack
    End Sub
        
    Property Form.Visible() As Boolean
        If FHandle Then
            FVisible = IsWindowVisible(FHandle)
        End if
        Return FVisible
    End Property

    Property Form.Visible(Value As Boolean)
        FVisible = Value 
        If Value Then 
            Show
        Else
            Hide
        End If
    End Property

    Sub Form.Show
        If IsWindowVisible(Handle) Then
            This.SetFocus
        Else
            If Handle Then
                ShowWindow Handle ,FCmdShow(FWindowState)
                If FParent Then FParent->RequestAlign
            Else
                CreateWnd
            End If
        End If
        If OnShow Then OnShow(This)
    End Sub
    
    Sub Form.Show(ByRef OwnerForm As Form)
        This.FParent = @OwnerForm
        This.Show
    End Sub
        
    Function Form.ShowModal As Integer
        Dim As Integer i
        Dim As Any Ptr Mtx
        If IsWindowVisible(Handle) Then
           This.SetFocus
           Exit Function
        End If
        If GetCapture <> 0 Then SendMessage(GetCapture,WM_CANCELMODE,0,0)
        '?"..." & GetCapture
        'ReleaseCapture
        For i = 0 To App.FormCount -1
            If App.Forms[i]->Handle <> Handle Then Cast(Form Ptr,App.Forms[i]->Child)->Enabled = False
        Next i
        If OnShow Then OnShow(This)
        Visible = True
        Do
           App.DoEvents
           Update
        Loop While IsWindowVisible(Handle) = True
        Visible = False
        For i = 0 To App.FormCount -1
             Cast(Form Ptr,App.Forms[i]->Child)->Enabled = True
        Next i
        'ReleaseCapture
        SetActiveWindow MainHandle
        Function = ModalResult
    End Function

    Sub Form.Hide
        If Handle Then
            If IsWindowVisible(Handle) Then
                If OnHide Then OnHide(This)
                ShowWindow Handle, SW_HIDE
            End If
        End If
    End Sub
        
    Sub Form.Minimize
        If IsIconic(Handle) = 0 Then
           ShowWindow Handle, SW_MINIMIZE
        End If
    End Sub

    Sub Form.CloseForm
        If Handle Then Perform(WM_CLOSE, 0, 0)
    End Sub

    Sub Form.Center
        This.Left = (GetSystemMetrics(SM_CXSCREEN) - This.Width)\2
        This.Top  = (GetSystemMetrics(SM_CYSCREEN) - This.Height)\2
    End Sub

    Function Form.EnumMenuItems(Item As MenuItem) As Boolean
        FMenuItems.Add Item
        For i As Integer = 0 To Item.Count -1
            EnumMenuItems *Item.Item(i)
        Next i
        Return True
    End Function

    Sub Form.GetMenuItems
        FMenuItems.Clear
        If This.Menu Then
            For i As Integer = 0 To This.Menu->Count -1
                EnumMenuItems *This.Menu->Item(i)
            Next i
        End If
    End Sub

    Operator Form.Cast As Control Ptr
       Return @This
    End Operator

    Constructor Form
        Text = "Form"
        FMainStyle(0)  = 0  
        FMainStyle(1)  = WS_EX_APPWINDOW
        FClassStyle(0) = CS_VREDRAW OR CS_HREDRAW OR CS_DBLCLKS
        FClassStyle(1) = CS_DBLCLKS
        FClassStyle(2) = CS_DBLCLKS OR CS_SAVEBITS OR CS_BYTEALIGNWINDOW
        FClassStyle(3) = CS_DBLCLKS
        FClassStyle(4) = CS_DBLCLKS
        FClassStyle(5) = CS_DBLCLKS
        FExStyle(0)    = WS_EX_CONTROLPARENT
        FExStyle(1)    = WS_EX_CONTROLPARENT
        FExStyle(2)    = WS_EX_CONTROLPARENT OR WS_EX_DLGMODALFRAME
        FExStyle(3)    = WS_EX_CONTROLPARENT
        FExStyle(4)    = WS_EX_CONTROLPARENT OR WS_EX_TOOLWINDOW
        FExStyle(5)    = WS_EX_CONTROLPARENT OR WS_EX_TOOLWINDOW
        FStyle(0)      = WS_POPUP OR DS_CONTROL
        FStyle(1)      = WS_CAPTION OR WS_BORDER OR DS_CONTROL
        FStyle(2)      = WS_CAPTION OR WS_BORDER OR WS_SYSMENU
        FStyle(3)      = WS_OVERLAPPEDWINDOW
        FStyle(4)      = WS_CAPTION OR WS_BORDER OR WS_SYSMENU
        FStyle(5)      = WS_CAPTION OR WS_THICKFRAME OR WS_SYSMENU
        FChild(0) = 0
        FChild(1) = WS_CHILD
        FCmdShow(0) = SW_HIDE
        FCmdShow(1) = SW_SHOWNORMAL
        FCmdShow(2) = SW_SHOWMAXIMIZED
        FCmdShow(3) = SW_SHOWMINIMIZED
        FBorderStyle   = 3
        FWindowState   = 1
        Canvas.Ctrl    = This
        With This
            .Child             = @This
            .ChildProc         = @WndProc
            WLet FClassName, "Form"
            WLet FClassAncestor, ""
            .ExStyle           = FExStyle(FBorderStyle) OR FMainStyle(FMainForm)
            .Style             = FStyle(FBorderStyle) Or FChild(Abs_(FIsChild))
            .Width             = 350
            .Height            = 300
            .BackColor             = GetSysColor(COLOR_BTNFACE) 
            .RegisterClass "Form"
            .OnHandleIsAllocated = @HandleIsAllocated
        End With
        If App.MainForm = 0 Then MainForm = True
        #IFDEF __AUTOMATE_CREATE_FORM__  
        CreateWnd
        #ENDIF
    End Constructor

    Destructor Form
        If OnFree Then OnFree(This)
        If FHandle THen FreeWnd
        'UnregisterClass ClassName, GetModuleHandle(NULL)
    End Destructor
End namespace
