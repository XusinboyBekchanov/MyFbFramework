'###############################################################################
'#  Control.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Version 1.0.0                                                              #
'###############################################################################

#Include Once "Menus.bi"
#Include Once "List.bi"
#Include Once "Graphics.bi"
#If __Fb_linux__
#Else
    #Include Once "win/commctrl.bi"
    #Include Once "win/shellapi.bi"
#EndIf

Using My.Sys.ComponentModel

Namespace My.Sys.Forms
    #DEFINE QControl(__Ptr__) *Cast(Control Ptr,__Ptr__)

    Enum DockStyle '...'
        alNone, alLeft, alRight, alTop, alBottom, alClient
    End Enum

    Enum AnchorStyle '...'
        asNone
        asAnchor
        asAnchorProportional
    End Enum

    Type SizeConstraints
        Left  As Integer
        Top    As Integer
        Width As Integer
        Height As Integer
    End Type
    
    Type ControlProperty
        Name As String * 50
        Type As String * 50
        Comment As WString Ptr
    End Type

    Type LocationType
        X As Integer
        Y As Integer
    End Type
    
    Type SizeType
        Width As Integer
        Height As Integer
    End Type
    
    Type PControl As Control Ptr
    
    Type ControlCollection Extends My.Sys.Object
        
    End Type

    Type Control Extends Component
        Private:
            Tracked As Boolean
            FAnchoredLeft     As Integer
            FAnchoredTop     As Integer
            FAnchoredRight     As Integer
            FAnchoredBottom As Integer
            FAnchoredParentWidth As Integer
            FAnchoredParentHeight As Integer
            Dim As Rect R, RR
        Protected:
            FID                As Integer
            FTemp              As WString Ptr
            FParent            As Control Ptr
            FOwner             As Control Ptr
            FToolInfo          As TOOLINFO
            FBorderStyle       As Integer
            FExStyle           As Integer
            FStyle             As Integer
            FText              As WString Ptr
            FHint              As WString Ptr
            FShowHint          As Boolean
            FHandle            As HWND
            FAlign             As Integer
            FLeft              As Integer
            FTop               As Integer
            FWidth             As Integer
            FHeight            As Integer
            FClientWidth       As Integer
            FClientHeight      As Integer
            FColor             As Integer
            FStoredFont        As My.Sys.Drawing.Font
            FGrouped           As Boolean  
            FLocation          As LocationType
            FSize              As SizeType
            FTabStop           As Boolean
            FEnabled           As Boolean
            FVisible           As Boolean
            DownButton         As Integer = -1
            FDefaultButton     As Control ptr
            FCancelButton      As Control ptr
            FActiveControl     As Control Ptr
            FPopupMenuItems     As List
            PrevProc           As Any Ptr
            Child              As Any Ptr
            ChildProc          As Any Ptr 'Function(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
            CreateParam        As Any Ptr
            Declare Function EnumPopupMenuItems(Item As MenuItem) As Boolean
            Declare Sub GetPopupMenuItems
            Declare Sub AllocateHint
            Declare Sub Move
            Declare Sub ChangeExStyle(iStyle As Integer, Value As Boolean)
            Declare Sub ChangeStyle(iStyle As Integer, Value As Boolean)
            Declare Sub AddProperty(Name As String, Type As String, ByRef Comment As WString)
            Declare Function ExStyleExists(iStyle As Integer) As Boolean
            Declare Function StyleExists(iStyle As Integer) As Boolean
            Declare Property Style As Integer
            Declare Property Style(Value As Integer)
            Declare Property ExStyle As Integer
            Declare Property ExStyle(Value As Integer)
            Declare Function SelectNext(CurControl As Control Ptr, Prev As Boolean = False) As Control Ptr
            Declare Virtual Sub ProcessMessage(ByRef message As Message)        
        Public:
            Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
            Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
            Declare Static Function WindowProc(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
            Declare Static Function DefWndProc(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
            Declare Static Function CallWndProc(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
            Declare Static Function SuperWndProc(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
            OnHandleIsAllocated As Sub(ByRef Sender As Control)
            OnHandleIsDestroyed As Sub(ByRef Sender As Control)
            SubClass            As Boolean
            ToolTipHandle       As HWND
            Accelerator        As HACCEL
            Brush              As My.Sys.Drawing.Brush
            Font               As My.Sys.Drawing.Font
            Cursor             As My.Sys.Drawing.Cursor Ptr
            ContextMenu        As My.Sys.Forms.PopupMenu Ptr
            HelpContext        As Integer
            Constraints        As SizeConstraints
            DoubleBuffered     As Boolean
            ControlCount       As Integer
            Controls           As Control Ptr Ptr
            AnchorLeft         As AnchorStyle
            AnchorTop          As AnchorStyle
            AnchorRight        As AnchorStyle
            AnchorBottom       As AnchorStyle
            MarginLeft         As Integer
            MarginTop          As Integer
            MarginRight        As Integer
            MarginBottom       As Integer
            Declare Property ID As Integer
            Declare Property ID(Value As Integer)
            Declare Property Handle As HWND
            Declare Property Handle(Value As HWND)
            Declare Property BorderStyle As Integer
            Declare Property BorderStyle(Value As Integer)
            Declare Property Location As LocationType
            Declare Property Location(Value As LocationType)
            'Foydalanuvchilarga ko`rsatiladigan matn
            Declare Property Text ByRef As WString
            Declare Property Text(ByRef Value As WString)
            Declare Property Hint ByRef As WString
            Declare Property Hint(ByRef Value As WString)
            Declare Property ShowHint As Boolean
            Declare Property ShowHint(Value As Boolean)
            Declare Property Color As Integer
            Declare Property Color(Value As Integer)
            Declare Property Parent As Control Ptr
            Declare Property Parent(Value As Control Ptr)
            Declare Property Align As Integer
            Declare Property Align(Value As Integer)
            Declare Property Left As Integer
            Declare Property Left(Value As Integer)
            Declare Property Top As Integer
            Declare Property Top(Value As Integer)
            Declare Property Width As Integer
            Declare Property Width(Value As Integer)
            Declare Property Height As Integer
            Declare Property Height(Value As Integer)
            Declare Property Size As SizeType
            Declare Property Size(Value As SizeType)
            Declare Property ClientWidth As Integer
            Declare Property ClientWidth(Value As Integer)
            Declare Property ClientHeight As Integer
            Declare Property ClientHeight(Value As Integer)
            Declare Property TabStop As Boolean
            Declare Property TabStop(Value As Boolean)
            Declare Property Grouped As Boolean
            Declare Property Grouped(Value As Boolean)
            Declare Property Enabled As Boolean
            Declare Property Enabled(Value As Boolean)
            Declare Property Visible As Boolean
            Declare Property Visible(Value As Boolean)
            Declare Static Function RegisterClass(ByRef wClassName As WString, ByRef wClassAncestor As WString = "", WndProcAddr As Any Ptr = 0) As Integer
            Declare Function GetTextLength() As Integer
            Declare Function Perform(Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
            Declare Function GetForm() As Control Ptr
            Declare Function TopLevelControl() As Control Ptr
            Declare Function Focused As Boolean
            Declare Function IndexOf(Ctrl As Control Ptr) As Integer
            Declare Sub CreateWnd
            Declare Sub RecreateWnd
            Declare Sub FreeWnd
            Declare Sub ClientToScreen(ByRef P As Point)
            Declare Sub ScreenToClient(ByRef P As Point)
            Declare Sub Invalidate
            Declare Sub Repaint
            Declare Sub Update
            Declare Sub UpdateLock
            Declare Sub UpdateUnLock
            Declare Sub SetFocus
            Declare Sub BringToFront
            Declare Sub RequestAlign
            Declare Sub Show
            Declare Sub Hide
            Declare Sub SetBounds(ALeft As Integer, ATop As Integer, AWidth As Integer, AHeight As Integer)
            Declare Sub SetMargins(mLeft As Integer, mTop As Integer, mRight As Integer, mBottom As Integer)
            Declare Sub Add(Ctrl As Control Ptr)
            Declare Sub AddRange Cdecl(CountArgs As Integer, ...)
            Declare Sub Remove(Ctrl As Control Ptr)
            Declare Operator Cast As Any Ptr
            Declare Operator Let(ByRef Value As Control Ptr)
            Declare Constructor
            Declare Destructor
            OnActiveControlChange As Sub(ByRef Sender As Control)
            OnCreate     As Sub(ByRef Sender As Control)
            OnDestroy    As Sub(ByRef Sender As Control)
            OnDropFile   As Sub(ByRef Sender As Control, ByRef Filename As WString)
            OnPaint      As Sub(ByRef Sender As Control)
            OnMouseDown  As Sub(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
            OnMouseMove  As Sub(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
            OnMouseUp    As Sub(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
            OnMouseWheel As Sub(ByRef Sender As Control, Direction As Integer, x As Integer, y As Integer, Shift As Integer)
            OnMouseLeave As Sub(ByRef Sender As Control)
            OnClick      As Sub(ByRef Sender As Control)
            OnDblClick   As Sub(ByRef Sender As Control)
            OnKeyPress   As Sub(ByRef Sender As Control, Key As Byte)
            OnKeyDown    As Sub(ByRef Sender As Control, Key As Integer,Shift As Integer)
            OnKeyUp      As Sub(ByRef Sender As Control, Key As Integer,Shift As Integer)
            OnResize     As Sub(ByRef Sender As Control)
            OnScroll     As Sub(ByRef Sender As Control)
            OnUpdate     As Sub(ByRef Sender As Control)
    End Type

    Dim Shared CreationControl As Control Ptr

    Function Control.ReadProperty(ByRef PropertyName As String) As Any Ptr
        FTempString = LCase(PropertyName)
        Select Case FTempString
        Case "align": Return @FAlign
        Case "anchorleft": Return @AnchorLeft
        Case "anchorright": Return @AnchorRight
        Case "anchortop": Return @AnchorTop
        Case "anchorbottom": Return @AnchorBottom
        Case "location": Return @FLocation
        Case "location.x": Return @FLocation.X
        Case "location.y": Return @FLocation.Y    
        Case "marginleft": Return @MarginLeft
        Case "marginright": Return @MarginRight
        Case "margintop": Return @MarginTop
        Case "marginbottom": Return @MarginBottom
        Case "borderstyle": Return @FBorderStyle
        Case "color": Return @FColor
        Case "clientheight": Return @FClientHeight: ClientHeight: Return @FClientHeight
        Case "clientwidth": Return @FClientWidth: ClientWidth: Return @FClientWidth
        Case "grouped": Return @FGrouped
        Case "enabled": Return @FEnabled
        Case "font": Return @This.Font
        Case "font.name": FTempString = This.Font.Name: Return @FTempString
      '  Case "font.size": Return This.Font.FSize
        Case "left": Return @FLeft
        Case "top": Return @FTop
        Case "width": Return @FWidth
        Case "height": Return @FHeight
        Case "parent": Return FParent
        Case "size": Return @FSize
        Case "showhint": Return @FShowHint
        Case "hint": Return FHint
        Case "subclass": Return @SubClass
        Case "tabstop": Return @FTabStop
        Case "text": Return FText
        Case "visible": Return @FVisible
        Case Else: Return Base.ReadProperty(PropertyName)
        End Select
        Return 0
    End Function
    
    Function Control.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
        If Value = 0 Then
            Select Case LCase(PropertyName)
            Case "parent": This.Parent = Value
            Case Else: Return Base.WriteProperty(PropertyName, Value)
            End Select
        Else
            Select Case LCase(PropertyName)
            Case "align": This.Align = QInteger(Value)
            Case "anchorleft": This.AnchorLeft = QInteger(Value)
            Case "anchorright": This.AnchorRight = QInteger(Value)
            Case "anchortop": This.AnchorTop = QInteger(Value)
            Case "anchorbottom": This.AnchorBottom = QInteger(Value)
            Case "location": This.Location = *Cast(LocationType Ptr, Value)
            Case "location.x": This.FLocation.X = QInteger(Value)
            Case "location.y": This.FLocation.Y = QInteger(Value)
            Case "marginleft": This.MarginLeft = QInteger(Value)
            Case "marginright": This.MarginRight = QInteger(Value)
            Case "margintop": This.MarginTop = QInteger(Value)
            Case "marginbottom": This.MarginBottom = QInteger(Value)
            Case "borderstyle": This.BorderStyle = QInteger(Value)
            Case "color": This.Color = QInteger(Value)
            Case "enabled": This.Enabled = QBoolean(Value)
            Case "grouped": This.Grouped = QBoolean(Value)
            Case "font": This.Font = *Cast(My.Sys.Drawing.Font Ptr, Value)
            Case "font.name": This.Font.Name = QWString(Value)
            Case "font.size": This.Font.Size = QInteger(Value)    
            Case "left": This.Left = QInteger(Value)
            Case "top": This.Top = QInteger(Value)
            Case "width": This.Width = QInteger(Value)
            Case "height": This.Height = QInteger(Value)
            Case "parent": This.Parent = QControl(Value)
            Case "tabstop": This.TabStop = QBoolean(Value)
            Case "text": This.Text = QWString(Value)
            Case "visible": This.FVisible = QBoolean(Value)
            Case "showhint": This.ShowHint = QBoolean(Value)
            Case "hint": This.Hint = QWString(Value)
            Case "subclass": This.SubClass = QBoolean(Value)
            Case Else: Return Base.WriteProperty(PropertyName, Value)
            End Select
        End If
        Return True
    End Function
    
    Property Control.Location As LocationType
        Return FLocation
    End Property
    
    Property Control.Location(Value As LocationType)
        FLocation = Value
        FLeft = Value.X
        FTop = Value.Y
        If FHandle Then Move
    End Property
    
    Function Control.Focused As Boolean
        Return GetFocus = FHandle
    End Function

    Function Control.GetTextLength() As Integer '...'
        If FHandle Then
            Return Perform(WM_GETTEXTLENGTH, 0, 0)
        Else
            Return Len(*FText)
        EndIf
    End Function
    
    Function Control.GetForm As Control Ptr '...'
        If This.ClassName = "Form" Then
            Return @This
        ElseIf FParent = 0 Then
            Return FParent
        ElseIf FParent->ClassName = "Form" Then
            Return FParent
        Else
            Return FParent->GetForm()
        End If
    End Function

    Function Control.TopLevelControl As Control Ptr '...'
        If GetClassNameOf(Handle) = "" Then
            Return @This
        ElseIf FParent = 0 Then
            Return @This
        Else
            Return FParent->TopLevelControl()
        End If
    End Function
    
    Property Control.Handle As HWND '...'
        Return FHandle
    End Property

    Property Control.Handle(Value As HWND)
        FHandle = Value
    End Property
    
    Property Control.BorderStyle As Integer '...'
        Return FBorderStyle
    End Property

    Property Control.BorderStyle(Value As Integer) '...'
        FBorderStyle = Value
        ChangeExStyle WS_EX_CLIENTEDGE, Value
    End Property
    
    Property Control.Style As Integer '...'
        If Handle Then
            FStyle = GetWindowLong(Handle, GWL_STYLE)
        End If
        Return FStyle
    End Property

    Property Control.Style(Value As Integer) '...'
        FStyle = Value
        If FHandle Then SetWindowLong(FHandle, GWL_STYLE, FStyle) 'RecreateWnd
    End Property

    Property Control.ExStyle As Integer '...'
        If Handle Then
            FExStyle = GetWindowLong(Handle, GWL_EXSTYLE)
        End If
        Return FExStyle
    End Property

    Property Control.ExStyle(Value As Integer) '...'
        FExStyle = Value
        If Handle Then RecreateWnd
    End Property

    Property Control.ID As Integer '...'
        If Handle Then
            FID = GetDlgCtrlID(Handle)
        End If
        Return FID
    End Property

    Property Control.ID(Value As Integer) '...'
        FID = Value
    End Property

    Property Control.Text ByRef As WString '...'
        If FHandle Then
            Dim As Integer L
            L = Perform(WM_GETTEXTLENGTH, 0, 0)
            FText = Cast(WString Ptr, ReAllocate(FText, (L + 1 + 1) * SizeOf(WString)))
            *FText = WString(L + 1, 0)
            GetWindowText(FHandle, FText, L + 1)
        End If
        Return *FText
    End Property

    Property Control.Text(ByRef Value As WString) '...'
        FText = Cast(WString Ptr, ReAllocate(FText, (Len(Value) + 1) * SizeOf(WString)))
        *FText = Value
        If FHandle Then SetWindowTextW FHandle, FText
    End Property

    Property Control.Hint ByRef As WString '...'
        Return *FHint
    End Property

    Property Control.Hint(ByRef Value As WString) '...'
        FHint = Cast(WString Ptr, ReAllocate(FHint, (Len(WString) + 1) * SizeOf(WString)))
        *FHint = Value
        If FHandle Then
           If ToolTipHandle Then
               SendMessage(ToolTipHandle, TTM_GETTOOLINFO, 0, CInt(@FToolInfo))
               FToolInfo.lpszText = FHint
               SendMessage(ToolTipHandle, TTM_UPDATETIPTEXT, 0, CInt(@FToolInfo))
           End If
        End If
    End Property

    Property Control.Align As Integer '...'
        Return FAlign
    End Property

    Property Control.Align(Value As Integer) '...'
        FAlign = Value
        If FParent Then FParent->RequestAlign 
    End Property

    Sub Control.Move() '...'
        Dim As Integer iLeft = FLeft, iTop = FTop, iWidth = FWidth, iHeight = FHeight
        If FParent Then
            iLeft = iLeft + FParent->MarginLeft
            iTop = iTop + FParent->MarginTop
            iWidth = iWidth - FParent->MarginLeft - FParent->MarginRight
            iHeight = iHeight - FParent->MarginTop - FParent->MarginBottom
        End If
        MoveWindow FHandle, iLeft, iTop, iWidth, iHeight, True
    End Sub

    Property Control.Left As Integer '...'
        If FHandle Then
            If UCase(FParent->ClassName) = "SYSTABCONTROL32" Or UCase(FParent->ClassName) = "TABCONTROL" Then
            Else
                Dim As Rect R
                GetWindowRect Handle,@R
                MapWindowPoints 0,GetParent(Handle),Cast(Point Ptr,@R),2
                Return R.Left
            End If
        End If
        Return FLeft
    End Property

    Property Control.Left(Value As Integer) '...'
        FLeft = Value
        If FHandle Then Move
    End Property

    Property Control.Top As Integer '...'
        If FHandle Then
            If UCase(FParent->ClassName) = "SYSTABCONTROL32" Or UCase(FParent->ClassName) = "TABCONTROL" Then
            Else
                Dim As Rect R
                GetWindowRect Handle,@R
                MapWindowPoints 0,GetParent(Handle),Cast(Point Ptr,@R),2
                Return R.Top
            End If
        End If
        Return FTop
    End Property

    Property Control.Top(Value As Integer)
        FTop = Value
        If FHandle Then Move
    End Property

    Property Control.Width As Integer '...'
        If FHandle Then
            Dim As Rect R
            GetWindowRect Handle, @R
            MapWindowPoints 0, GetParent(FHandle), Cast(Point Ptr, @R), 2
            Return R.Right - R.Left
        End If
        Return FWidth
    End Property

    Property Control.Width(Value As Integer) '...'
        FWidth = Value
        If FHandle Then Move
    End Property

    Property Control.Height As Integer '...'
        If FHandle Then
            Dim As Rect R
            GetWindowRect Handle, @R
            MapWindowPoints 0, GetParent(FHandle), Cast(Point Ptr, @R), 2
            Return R.Bottom - R.Top
        End If
        Return FHeight
    End Property

    Property Control.Height(Value As Integer) '...'
        FHeight = Value
        If FHandle Then Move
    End Property

    Property Control.ClientWidth As Integer
        If FHandle Then
            GetClientRect Handle ,@R
            FClientWidth = R.Right
'            If UCase(ClassName) = "SYSTABCONTROL32" OR UCase(ClassName) = "TABCONTROL" Then
'                InflateRect @R, -4, -4
'                If (FParent->StyleExists(TCS_VERTICAL)) Then
'                    Perform(TCM_GETITEMRECT, 0, CInt(@RR))
'                    FClientWidth = R.Right - (RR.Right - RR.Left) - 3
'                else
'                    FClientWidth = R.Right - 2
'                End If
'            End If
        End If
        Return FClientWidth
    End Property

    Property Control.ClientWidth(Value As Integer)
    End Property

    Property Control.ClientHeight As Integer
        If Handle Then
            GetClientRect Handle ,@R
            FClientHeight = R.Bottom
'            If UCase(ClassName) = "SYSTABCONTROL32" OR UCase(ClassName) = "TABCONTROL" Then
'                InflateRect @R,-4, -4
'                If (Not FParent->StyleExists(TCS_VERTICAL)) Then
'                    Perform(TCM_GETITEMRECT,0,CInt(@RR))
'                    FClientHeight = R.Bottom - (RR.Bottom - RR.Top) - 3
'                Else
'                    FClientHeight = R.Bottom - 2
'                End If
'            End If
        End If
        Return FClientHeight
    End Property

    Property Control.ClientHeight(Value As Integer)
    End Property

    Property Control.ShowHint As Boolean '...'
        Return FShowHint
    End Property

    Property Control.ShowHint(Value As Boolean) '...'
        FShowHint = Value
        If Handle Then 
           SendMessage(ToolTipHandle,TTM_ACTIVATE,FShowHint,0)
        End If
    End Property

    Property Control.Color As Integer '...'
        Return FColor
    End Property

    Property Control.Color(Value As Integer) '...'
        FColor = Value
        Brush.Color = FColor
        Invalidate
    End Property

    Property Control.Parent As Control Ptr '...'
        Return FParent 
    End Property

    Property Control.Parent(Value As Control Ptr) '...'
        FParent = Value
        If Value Then Value->Add(@This)
    End Property
    
    Function Control.StyleExists(iStyle As Integer) As Boolean '...'
        Return (Style AND iStyle) = iStyle
    End Function

    Function Control.ExStyleExists(iStyle As Integer) As Boolean '...'
        Return (ExStyle AND iStyle) = iStyle
    End Function

    Sub Control.ChangeStyle(iStyle As Integer, Value As Boolean) '...'
        If Value Then
            If ((Style AND iStyle) <> iStyle) Then Style = Style Or iStyle
        ElseIf ((Style AND iStyle) = iStyle) Then
            Style = Style And Not iStyle
        End If
    End Sub

    Sub Control.ChangeExStyle(iStyle As Integer, Value As Boolean) '...'
        If Value Then
            If ((Style AND iStyle) <> iStyle) Then Style = Style Or iStyle
        ElseIf ((Style AND iStyle) = iStyle) Then
            Style = Style And Not iStyle
        End If
    End Sub

    Property Control.TabStop As Boolean '...'
        FTabStop = StyleExists(WS_TABSTOP)
        Return FTabStop
    End Property

    Property Control.TabStop(Value As Boolean) '...'
        FTabStop = Value
        ChangeStyle WS_TABSTOP, Value
    End Property

    Property Control.Grouped As Boolean '...'
        FGrouped = StyleExists(WS_GROUP)
        Return FGrouped
    End Property

    Property Control.Grouped(Value As Boolean) '...'
        FGrouped = Value
        ChangeStyle WS_GROUP, Value
    End Property

    Property Control.Enabled As Boolean '...'
        If Handle Then FEnabled = IsWindowEnabled(Handle)
        Return FEnabled
    End Property

    Property Control.Enabled(Value As Boolean) '...'
        FEnabled = Value
        If FHandle Then EnableWindow FHandle, FEnabled
    End Property

    Property Control.Visible() As Boolean '...'
        If FHandle Then FVisible = IsWindowVisible(FHandle)
        Return FVisible
    End Property

    Property Control.Visible(Value As Boolean) '...'
        FVisible = Value
        If FHandle = 0 And CInt(Value) Then
            CreateWnd
        End If
        If FHandle Then
            If Value Then
                ShowWindow(FHandle, SW_SHOW)
                'UpdateWindow(FHandle)
            Else
                ShowWindow(FHandle, SW_HIDE)
            End If
        End If
        If FParent Then FParent->RequestAlign
    End Property

    Sub Control.Show() '...'
        Visible = True
    End Sub

    Sub Control.Hide() '...'
        Visible = False
    End Sub
    
    Sub Control.CreateWnd
        If Handle Then Exit Sub
        Dim As HWND HParent
        Dim As Integer ControlID = 0
        If (Style AND WS_CHILD) = WS_CHILD Then
            If FParent Then
                HParent = FParent->Handle
                FID =  1000 + FParent->ControlCount
                ControlID = FID
            ElseIf FOwner <> 0 AndAlso FOwner->Handle Then
                HParent = FOwner->Handle
            Else
                Exit Sub
            End If
        Else
           If FParent Then
               HParent = FParent->Handle
           Else
               HParent = NULL
                If MainHandle Then
                    HParent = MainHandle
                End If 
                If FOwner Then
                    HParent = FOwner->Handle
                End If
            End If 
            ControlID = NULL
        End If
        If (Style AND (WS_CLIPCHILDREN OR WS_CLIPSIBLINGS)) <> (WS_CLIPCHILDREN OR WS_CLIPSIBLINGS) Then
            Style = Style OR (WS_CLIPCHILDREN OR WS_CLIPSIBLINGS)
        End If
        CreationCOntrol = @This
        'RegisterClass ClassName, ClassAncestor
        Static As Integer ATabStop(2) =>{0,WS_TABSTOP},AGrouped(2) = >{0,WS_GROUP}
        FHandle = CreateWindowExW(FExStyle,_
                                FClassName,_
                                FText,_
                                FStyle OR ATabStop(Abs_(FTabStop)) OR AGrouped(Abs_(FGrouped)),_
                                FLeft,_
                                FTop,_
                                FWidth,_
                                FHeight,_
                                HParent,_
                                Cast(HMENU, ControlID),_
                                Instance,_
                                @This) ' '
        If Handle Then
            SetWindowLongPtr(Handle, GWLP_USERDATA, CInt(Child)) 
            If SubClass Then
                PrevProc = Cast(Any Ptr, SetWindowLongPtr(Handle, GWLP_WNDPROC, CInt(@CallWndProc))) 
            End If
            BringToFront
            SendMessage Handle, CM_CREATE, 0, 0
            If This.Font Then This.Font.Parent = Handle
            If OnHandleIsAllocated Then OnHandleIsAllocated(This)
            If FParent Then
                FAnchoredParentWidth = FParent->Width
                FAnchoredParentHeight = FParent->Height
                FAnchoredLeft = FLeft
                FAnchoredTop = FTop
                FAnchoredRight = FAnchoredParentWidth - FWidth - FLeft
                FAnchoredBottom = FAnchoredParentHeight - FHeight - FTop
            End If
            Dim i As Integer
                For i = 0 To This.ControlCount -1
                    This.Controls[i]->CreateWnd
                    This.Controls[i]->RequestAlign
            Next i
            This.RequestAlign
            If This.ContextMenu Then This.ContextMenu->Window = FHandle
            If OnCreate Then OnCreate(This)            
            If FVisible Then ShowWindow(FHandle, SW_SHOWNORMAL)
            Update
        End If
    End Sub

    Sub Control.RecreateWnd '...'
        Dim As Integer i
        If Handle = 0 Then Exit Sub
        'For i = 0 To ControlCount -1
        '    Controls[i]->FreeWnd
        'Next i
        FreeWnd 
        CreateWnd
        For i = 0 To ControlCount -1
            Controls[i]->RecreateWnd
            Controls[i]->RequestAlign
        Next i
        RequestAlign
    End Sub

    Sub Control.FreeWnd
        If OnHandleIsDestroyed Then OnHandleIsDestroyed(This)
        If FHandle Then
            DestroyWindow FHandle
            FHandle = 0
        End If
        If ToolTipHandle Then 
            DestroyWindow ToolTipHandle
            ToolTipHandle = 0
        End If
    End Sub

    Sub Control.ProcessMessage(ByRef Message As Message)
        Static bShift As Boolean, bCtrl As Boolean
        bShift = GetKeyState(VK_SHIFT) And 8000
        bCtrl = GetKeyState(VK_CONTROL) And 8000
        Select Case Message.Msg
        Case WM_PAINT
            If OnPaint Then OnPaint(This)
        Case WM_SETCURSOR
            If CInt(This.Cursor <> 0) AndAlso CInt(LoWord(message.lParam) = HTCLIENT) Then
                Message.Result = Cast(LResult, SetCursor(This.Cursor->Handle))
            End If
        Case WM_HSCROLL
            If Not Message.LParam = Null Then
                SendMessage Cast(HWND, Message.LParam), CM_HSCROLL, Cast(WParam, Message.WParam), Cast(LParam, Message.LParam)
            Else
                If OnScroll Then OnScroll(This)
            End If
        Case WM_VSCROLL
            If Not Message.LParam = Null Then
                SendMessage Cast(HWND, Message.LParam), CM_VSCROLL, Cast(WParam, Message.WParam), Cast(LParam, Message.LParam)
            Else
                If OnScroll Then OnScroll(This)
            End If
        Case WM_CTLCOLORMSGBOX To WM_CTLCOLORSTATIC
               Dim As Control Ptr Child
               If Message.Msg = WM_CTLCOLORSTATIC Then
                   If (GetWindowLong(CPtr(HWND,Message.LParam),GWL_STYLE) AND SS_SIMPLE) = SS_SIMPLE Then
                       Exit Select
                   End If
               End If
               Child = Cast(Control Ptr,GetWindowLongPtr(CPtr(HWND,Message.LParam),GWLP_USERDATA))
               If Child Then
                   With *Child
                       SendMessage(CPtr(HWND,Message.LParam),CM_CTLCOLOR,Message.wParam,Message.lParam)
                       message.result = Cast(LRESULT,.Brush.Handle)
                   End With
               Else
                   Dim As HDC Dc
                   DC = Cast(HDC,Message.wParam)
                   Child = Cast(Control Ptr,GetWindowLongPtr(Message.hWnd,GWLP_USERDATA))
                   If Child Then
                      SetBKMode(DC,TRANSPARENT)
                      SetBKColor(DC,Child->Color)
                      If Child->Font Then SetTextColor(DC,Child->Font.Color)
                      SetBKMode(DC,OPAQUE)
                      message.result = Cast(LRESULT,Brush.Handle)
                   End If
               End If
        Case WM_SIZE
            If Controls Then 
                RequestAlign
            End If
            If OnReSize Then OnReSize(This)
        Case WM_DESTROY
            If OnDestroy Then OnDestroy(This)
            FHandle = 0
        Case WM_WINDOWPOSCHANGING
             If Constraints.Left <> 0 Then *Cast(WINDOWPOS Ptr, Message.lParam).x  = Constraints.Left 
             If Constraints.Top <> 0 Then *Cast(WINDOWPOS Ptr, Message.lParam).y  = Constraints.Top 
             If Constraints.Width <> 0 Then *Cast(WINDOWPOS Ptr, Message.lParam).cx = Constraints.Width 
             If Constraints.Height <> 0 Then *Cast(WINDOWPOS Ptr, Message.lParam).cy = Constraints.Height
        Case WM_CANCELMODE
             SendMessage(Handle,CM_CANCELMODE,0,0)
        Case WM_LBUTTONDOWN
            DownButton = 0
            If OnClick Then OnClick(This)
            If OnMouseDown Then OnMouseDown(This,0,Message.lParamLo,Message.lParamHi,Message.wParam AND &HFFFF)
        Case WM_LBUTTONDBLCLK
            If OnDblClick Then OnDblClick(This)
        Case WM_LBUTTONUP
            DownButton = -1
             If OnMouseUp Then OnMouseUp(This,0,Message.lParamLo,Message.lParamHi,Message.wParam AND &HFFFF)
        Case WM_MBUTTONDOWN
            DownButton = 2
             If OnMouseDown Then OnMouseDown(This,2,Message.lParamLo,Message.lParamHi,Message.wParam AND &HFFFF)
        Case WM_MBUTTONUP
            DownButton = -1
            If OnMouseUp Then OnMouseUp(This,2,Message.lParamLo,Message.lParamHi,Message.wParam AND &HFFFF)
        Case WM_RBUTTONDOWN
            DownButton = 1
            If OnMouseDown Then OnMouseDown(This,1,Message.lParamLo,Message.lParamHi,Message.wParam AND &HFFFF)
        Case WM_RBUTTONUP
            DownButton = -1
            If OnMouseUp Then OnMouseUp(This,1,Message.lParamLo,Message.lParamHi,Message.wParam AND &HFFFF)
            If ContextMenu Then
                If ContextMenu->Handle Then
                    dim as POINT P
                          P.x = Message.lParamLo
                          P.y = Message.lParamHi
                          .ClientToScreen(This.Handle, @P)
                    ContextMenu->Popup(P.x, P.y)
                End If
            End If
        Case WM_MEASUREITEM
             Dim As MEASUREITEMSTRUCT Ptr miStruct
             miStruct = Cast(MEASUREITEMSTRUCT Ptr,Message.lParam)
             Select Case miStruct->CtlType 
             Case ODT_MENU    
                'miStruct->itemWidth = miStruct->itemWidth + 8
                    'If miStruct->itemHeight < 18 Then miStruct->itemHeight = 18
             Case ODT_LISTBOX,ODT_COMBOBOX 
                 SendMessage(GetDlgItem(Handle,Message.wParam),CM_MEASUREITEM,Message.wParam,Message.lParam)
             End Select
         Case WM_DRAWITEM
             Dim As DRAWITEMSTRUCT Ptr diStruct
             diStruct = Cast(DRAWITEMSTRUCT Ptr,Message.lParam)
             Select Case diStruct->CtlType 
             Case ODT_MENU
                'If This.ContextMenu AndAlso This.ContextMenu->ImagesList AndAlso This.ContextMenu->ImagesList->Handle AndAlso diStruct->itemData <> 0 Then
                '    ImageList_Draw(This.ContextMenu->ImagesList->Handle, Cast(MenuItem Ptr, diStruct->itemData)->ImageIndex, diStruct->hDC, 2, 2, ILD_NORMAL)
                'End If
             Case ODT_BUTTON,ODT_COMBOBOX,ODT_HEADER,ODT_LISTBOX,ODT_LISTVIEW,ODT_STATIC,ODT_TAB
                 SendMessage(Cast(HWND,diStruct->hwndItem),CM_DRAWITEM,Message.wParam,Message.lParam) 
             End Select
        Case WM_COMMAND
            GetPopupMenuItems
            For i As Integer = 0 To FPopupMenuItems.Count -1
               If QMenuItem(FPopupMenuItems.Items[i]).Command = Message.wParamLo Then
                If QMenuItem(FPopupMenuItems.Items[i]).OnClick Then QMenuItem(FPopupMenuItems.Items[i]).OnClick(QMenuItem(FPopupMenuItems.Items[i]))
                  Exit For
               End If
               Next i
            SendMessage(Cast(HWND,Message.lParam),CM_COMMAND,Message.wParam,Message.lParam)
        Case WM_MOUSEMOVE
            If OnMouseMove Then OnMouseMove(This, DownButton, Message.lParamLo,Message.lParamHi,Message.wParam AND &HFFFF) 
            If This.Tracked = false Then
                Dim As TRACKMOUSEEVENT event_
                event_.cbSize = sizeof(TRACKMOUSEEVENT)
                event_.dwFlags = TME_LEAVE
                event_.hwndTrack = Handle
                event_.dwHoverTime = 10
                TrackMouseEvent(@event_)
                This.Tracked = true
            End If
        Case WM_MOUSEWHEEL
            If OnMouseWheel Then OnMouseWheel(This,Sgn(Message.wParam),Message.lParamLo,Message.lParamHi,Message.wParam AND &HFFFF)
        Case WM_MOUSELEAVE
            If OnMouseLeave Then OnMouseLeave(This)
            This.Tracked = false
        Case WM_DROPFILES
            If OnDropFile Then
                Dim As HDrop iDrop = Cast(HDrop, Message.wParam)
                Dim As Integer filecount, length, i
    
           filecount = DragQueryFile(iDrop, -1, NULL, 0)
    
           Dim As WString Ptr filename
                For i = 0 To filecount - 1
                    WReallocate filename, MAX_PATH
                    length = DragQueryFile(iDrop, i, filename, MAX_PATH)
                    '*filename = Left(*filename, length)
                    If OnDropFile Then OnDropFile(This, *filename)
    
           Next
                DragFinish iDrop
            End If
        Case WM_CHAR
            If OnKeyPress Then OnKeyPress(This, Message.WParam)
        Case WM_KEYDOWN
            If OnKeyDown Then OnKeyDown(This,LoWord(Message.WParam),Message.lParam And &HFFFF)
            If GetKeyState(VK_MENU) >= 0 Then
                Select Case LoWord(message.wParam)
                Case VK_TAB
                    Dim Frm As Control Ptr = GetForm
                    If Frm Then
                        SelectNext frm->FActiveControl, bShift
                        Message.Result = -1:
                        Exit Sub
                    End If
                Case VK_RETURN
                    Dim Frm As Control Ptr = GetForm
                    If Frm AndAlso frm->FDefaultButton AndAlso frm->FDefaultButton->OnClick then
                        frm->FDefaultButton->OnClick(*frm->FDefaultButton)
                        Message.Result = -1: 
                        Exit Sub
                    End If
                Case VK_ESCAPE
                    Dim Frm As Control Ptr = GetForm
                    If Frm AndAlso frm->FCancelButton AndAlso frm->FCancelButton->OnClick then
                        frm->FCancelButton->OnClick(*frm->FCancelButton)
                        Message.Result = -1:
                        Exit Sub
                    End If
                End Select
            End If
        Case WM_KEYUP
            If OnKeyUp Then OnKeyUp(This,LoWord(Message.WParam),Message.lParam And &HFFFF)
        Case WM_SETFOCUS
               Dim frm As Control Ptr = GetForm
            If frm Then frm->FActiveControl = @This
        Case WM_NOTIFY
            Dim As LPNMHDR NM
            Static As HWND FWindow
            NM = Cast(LPNMHDR,Message.lParam)
            If NM->Code = TTN_NEEDTEXT Then 
               If FWindow Then SendMessage FWindow,CM_NEEDTEXT,Message.wParam,Message.lParam
            Else
               FWindow = NM->hwndFrom
               SendMessage *Cast(LPNMHDR,Message.lParam).hwndFrom,CM_NOTIFY,Message.wParam,Message.lParam 
            End If
        Case WM_HELP
            If (GetWindowLong(message.hwnd,GWL_STYLE) AND WS_CHILD) <> WS_CHILD Then SendMessage(message.hwnd,CM_HELP,message.wParam,message.LParam)
        Case WM_NEXTDLGCTL
            Dim As Control Ptr NextCtrl
            Dim As Control Ptr frm = GetForm
            If frm Then
                NextCtrl = SelectNext(frm->FActiveControl)
                If NextCtrl Then NextCtrl->SetFocus
            End If
        End Select
    End Sub

    Function Control.EnumPopupMenuItems(Item As MenuItem) As Boolean '...'
        FPopupMenuItems.Add Item
        For i As Integer = 0 To Item.Count -1
            EnumPopupMenuItems *Item.Item(i)
        Next i
        Return True
    End Function

    Sub Control.GetPopupMenuItems '...'
        FPopupMenuItems.Clear
        If ContextMenu Then
            For i As Integer = 0 To ContextMenu->Count -1
                EnumPopupMenuItems *ContextMenu->Item(i)
            Next i
        End If
    End Sub

    Function Control.DefWndProc(FWindow As HWND,Msg As UINT,wParam As WPARAM,lParam As LPARAM) As LRESULT
        Dim Message As Message
        Dim As Control Ptr Ctrl
        Ctrl = Cast(Any Ptr,GetWindowLongPtr(FWindow,GWLP_USERDATA))
        Message = Type(FWindow,Msg,wParam,lParam,0,0,LoWord(wParam),HiWord(wParam),LoWord(lParam),HiWord(lParam),Message.Captured)
        If Ctrl Then
            Message.Sender = Ctrl
            Ctrl->ProcessMessage(Message)
            If Message.Result = -1 Then
                Exit Function
            ElseIf Message.Result = -2 Then
                Msg = Message.Msg
                wParam = Message.wParam
                lParam = Message.lParam
            ElseIf Message.Result <> 0 Then 
                Return Message.Result
            End If
        End If
        Message.Result = DefWindowProc(FWindow,Msg,wParam,lParam)
        Return Message.Result
    End Function

    Function Control.CallWndProc(FWindow As HWND,Msg As UINT,wParam As WPARAM,lParam As LPARAM) As LRESULT
        Dim Message As Message
        Dim As Control Ptr Ctrl
        Dim As Any Ptr Proc = @DefWindowProc
        Ctrl = Cast(Any Ptr,GetWindowLongPtr(FWindow,GWLP_USERDATA))
        Message = Type(FWindow,Msg,wParam,lParam,0,Proc,LoWord(wParam),HiWord(wParam),LoWord(lParam),HiWord(lParam),Message.Captured)
        If Ctrl Then
            Proc = Ctrl->PrevProc
            Message.Sender = Ctrl
            Ctrl->ProcessMessage(Message)
            If Message.Result = -1 Then
                Exit Function
            ElseIf Message.Result = -2 Then
                Msg = Message.Msg
                wParam = Message.wParam
                lParam = Message.lParam
            ElseIf Message.Result <> 0 Then
                Return Message.Result
            End If
            Message.Result = CallWindowProc(Proc,FWindow,Msg,wParam,lParam)
        End If
        Return Message.Result
    End Function

    Function Control.SuperWndProc(FWindow As HWND,Msg As UINT,wParam As WPARAM,lParam As LPARAM) As LRESULT
        Dim As Control Ptr Ctrl
        Dim Message As Message
        Ctrl = Cast(Any Ptr, GetWindowLongPtr(FWindow,GWLP_USERDATA))
        Message = Type(FWindow,Msg,wParam,lParam,0,Ctrl,LoWord(wParam),HiWord(wParam),LoWord(lParam),HiWord(lParam),Message.Captured)
        If Ctrl Then
            With *Ctrl
                Message.Sender = Ctrl
                  .ProcessMessage(Message)
                   If Message.Result = -1 Then
                    Return Message.Result
                   ElseIf Message.Result = -2 Then
                    Msg = Message.Msg
                    wParam = Message.wParam
                    lParam = Message.lParam
                   ElseIf Message.Result <> 0 Then
                    Return Message.Result
                End If
               End With
        End If
        Return CallWindowProc(GetClassProc(FWindow), FWindow, Msg, wParam, lParam)
    End Function

    Function Control.Perform(Msg As UINT,wParam As WPARAM,lParam As LPARAM) As LRESULT '...'
        If Handle Then
            Return SendMessageW(Handle,Msg,wParam,lParam)
        Else
            Return 0
        End If
    End Function

    Function Control.SelectNext(CurControl As Control Ptr, Prev As Boolean = False) As Control Ptr '...'
        Static As Integer Index, LastIndex
        Var iStep = IIF(Prev, -1, 1)
        If CurControl AndAlso CurControl->Parent Then
            Index = CurControl->Parent->IndexOF(CurControl)
            If Index <> -1 Then
                Index = Index + iStep
                Dim ForTo As Integer
                If Prev Then
                    If Index = -1 Then Index = QControl(CurControl->Parent).ControlCount - 1
                    ForTo = 0
                Else
                    If Index = QControl(CurControl->Parent).ControlCount Then Index = 0
                    ForTo = QControl(CurControl->Parent).ControlCount - 1
                End If
                For i As Integer = Index To ForTo Step iStep
                    If (QControl(CurControl->Parent).Controls[i]->Style AND WS_TABSTOP) = WS_TABSTOP Then
                        QControl(CurControl->Parent).Controls[i]->SetFocus
                        Return QControl(CurControl->Parent).Controls[i]
                    End If
                Next
            End If
        End If        
        Return NULL
    End Function

    Function Control.RegisterClass(ByRef wClassName As WString, ByRef wClassAncestor As WString = "", WndProcAddr As Any Ptr = 0) As Integer '...'
        Dim As WNDCLASSEX Wc
        Dim As Any Ptr ClassProc
        Dim As Integer Result
        Dim Proc As Function(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT = WndProcAddr
        Wc.cbsize = SizeOf(WNDCLASSEX)
        If wClassAncestor <> "" Then
            If GetClassInfoEx(0, wClassAncestor, @Wc) <> 0 Then
                ClassProc = Wc.lpfnWndProc
                Wc.lpszClassName = @wClassName
                Wc.lpfnWndProc   = IIF(WndProcAddr = 0, @SuperWndProc, Proc)
                Wc.hInstance     = Instance
                'If Cursor AndAlso Cursor->Handle Then Wc.hCursor = Cursor->Handle
                Wc.cbWndExtra += 4
                Result = .RegisterClassEx(@Wc)
                If Result Then
                    StoreClass wClassName, wClassAncestor, ClassProc 
                End If
            ElseIf GetClassInfoEx(Instance, wClassAncestor, @Wc) <> 0 Then
                ClassProc = GetClassProc(wClassAncestor)
                'If Cursor AndAlso Cursor->Handle Then Wc.hCursor = Cursor->Handle
                Wc.lpszClassName = @wClassName
                Wc.lpfnWndProc   = IIF(WndProcAddr = 0, @DefWndProc, Proc)
                Result = .RegisterClassEx(@Wc)
                If Result Then
                    StoreClass wClassName, wClassAncestor, ClassProc 
                End If
            Else
                MessageBox NULL, wClassName & "' sinfini qayd qilish imkoni yo`q.", "Control", MB_ICONERROR
            End If
        Else
            If GetClassInfoEx(GetModuleHandle(NULL), wClassName, @Wc) = 0 Then
                Wc.lpszClassName = @wClassName
                Wc.lpfnWndProc   = IIF(WndProcAddr = 0, @DefWndProc, Proc)
                Wc.Style = CS_DBLCLKS
                Wc.hInstance     = Instance
                Wc.hCursor       = LoadCursor(NULL, IDC_ARROW)
                Wc.hbrBackground = Cast(HBRUSH, 16)
                Result = .RegisterClassEx(@Wc)
            End If
        End If
        Return Result
    End Function

    Sub Control.SetBounds(ALeft As Integer, ATop As Integer, AWidth As Integer, AHeight As Integer) '...'
        FLeft   = ALeft
        FTop    = ATop
        FWidth  = AWidth
        FHeight = AHeight
        If FHandle Then Move
    End Sub

    Sub Control.SetMargins(mLeft As Integer, mTop As Integer, mRight As Integer, mBottom As Integer) '...'
        MarginLeft   = mLeft
        MarginTop    = mTop
        MarginRight  = mRight
        MarginBottom = mBottom
        RequestAlign
    End Sub

    Sub Control.RequestAlign '...'
        Dim As Control Ptr Ptr ListLeft, ListRight, ListTop, ListBottom, ListClient
        Dim As Integer i,LeftCount = 0, RightCount = 0, TopCount = 0, BottomCount = 0, ClientCount = 0
        Dim As Integer tTop, bTop, lLeft, rLeft 
        Dim As Integer aLeft, aTop, aWidth, aHeight
        If ControlCount = 0 Then Exit Sub
        'This.UpdateLock
        For i = 0 To ControlCount -1
            If Controls[i]->Handle = 0 Then Continue For
            Select Case Controls[i]->Align
            Case 1'alLeft
                LeftCount += 1
                ListLeft = ReAllocate(ListLeft,SizeOF(Control)*LeftCount)
                ListLeft[LeftCount -1] = Controls[i]
            Case 2'alRight
                RightCount += 1
                ListRight = ReAllocate(ListRight,SizeOF(Control)*RightCount)
                ListRight[RightCount -1] = Controls[i]
            Case 3'alTop
                TopCount += 1
                ListTop = ReAllocate(ListTop,SizeOF(Control)*TopCount)
                ListTop[TopCount -1] = Controls[i]
            Case 4'alBottom
                BottomCount += 1
                ListBottom = ReAllocate(ListBottom,SizeOF(Control)*BottomCount)
                ListBottom[BottomCount -1] = Controls[i]
            Case 5'alClient
                ClientCount += 1
                ListClient = ReAllocate(ListClient,SizeOF(Control)*ClientCount)
                ListClient[ClientCount -1] = Controls[i]
            Case Else
                With *Controls[i]
                    If Cast(Integer, .AnchorLeft) + Cast(Integer, .AnchorRight) + Cast(Integer, .AnchorTop) + Cast(Integer, .AnchorBottom) <> 0 Then
                        If .FHandle Then
                            aLeft = .Left: aTop = .Top: aWidth = .Width: aHeight = .Height
                            If .AnchorLeft <> asNone Then
                                If .AnchorLeft = asAnchorProportional Then aLeft = This.Width / .FAnchoredParentWidth * .FAnchoredLeft
                                If .AnchorRight <> asNone Then aWidth = This.Width - aLeft - IIF(.AnchorRight = asAnchor, .FAnchoredRight, This.Width / .FAnchoredParentWidth * .FAnchoredRight)
                            ElseIf .AnchorRight <> asNone Then
                                aLeft = This.Width - .Width - IIF(.AnchorRight = asAnchor, .FAnchoredRight, This.Width / .FAnchoredParentWidth * .FAnchoredRight)
                            End If
                            If .AnchorTop <> asNone Then
                                If .AnchorTop = asAnchorProportional Then aTop = This.Height / .FAnchoredParentHeight * .FAnchoredTop
                                If .AnchorBottom <> asNone Then aHeight = This.Height - aTop - IIF(.AnchorBottom = asAnchor, .FAnchoredBottom, This.Height / .FAnchoredParentHeight * .FAnchoredBottom)
                            ElseIf .AnchorBottom <> asNone Then
                                aTop = This.Height - .Height - IIF(.AnchorBottom = asAnchor, .FAnchoredBottom, This.Height / .FAnchoredParentHeight * .FAnchoredBottom)
                            End If
                            .SetBounds(aLeft, aTop, aWidth, aHeight)
                        End If
                    End If
                End With
            End Select
        Next i
        lLeft = 0
        rLeft = ClientWidth
        tTop  = 0
        bTop  = ClientHeight
        For i = 0 To TopCount -1
            With *ListTop[i]
                If .Visible Then
                    tTop += .Height
                    .SetBounds(0,tTop - .Height,ClientWidth,.Height)
                End If  
            End With
        Next i
        bTop = ClientHeight
        For i = 0 To BottomCount -1
            With *ListBottom[i]
                If .Visible Then    
                   bTop -= .Height
                   .SetBounds(0,bTop,ClientWidth,.Height)
                End If
            End With
        Next i
        lLeft = 0
        For i = 0 To LeftCount -1
            With *ListLeft[i]
                If .Visible Then
                   lLeft += .Width
                   .SetBounds(lLeft - .Width, tTop, .Width, bTop - tTop)
                End If
            End With
        Next i
        rLeft = ClientWidth
        For i = 0 To RightCount -1
            With *ListRight[i]
                If .Visible Then 
                    rLeft -= .Width
                    .SetBounds(rLeft, tTop, .Width, bTop - tTop)
                End If
            End With
        Next i
        For i = 0 To ClientCount -1
            With *ListClient[i]
                If .Visible Then 
                   .SetBounds(lLeft,tTop,rLeft - lLeft,bTop - tTop)
                End If
            End With
        Next i
        If ListLeft   Then DeAllocate ListLeft
        If ListRight  Then DeAllocate ListRight
        If ListTop    Then DeAllocate ListTop
        If ListBottom Then DeAllocate ListBottom
        If ListClient Then DeAllocate ListClient
        'This.UpdateUnLock
    End Sub

    Sub Control.ClientToScreen(ByRef P As Point) '...'
        If Handle Then .ClientToScreen Handle,@P
    End Sub

    Sub Control.ScreenToClient(ByRef P As Point) '...'
        If Handle Then .ScreenToClient Handle,@P
    End Sub

    Sub Control.Invalidate '...'
        If Handle Then InvalidateRect Handle, 0, True
    End Sub

    Sub Control.Repaint '...'
        If Handle Then 
            RedrawWindow Handle,0,0,RDW_ERASE OR RDW_INVALIDATE
            Update
        End If
    End Sub

    Sub Control.Update '...'
        If Handle Then UpdateWindow Handle
    End Sub

    Sub Control.UpdateLock '...'
        If FHandle Then LockWindowUpdate FHandle
    End Sub

    Sub Control.UpdateUnLock '...'
        If FHandle Then LockWindowUpdate 0
    End Sub

    Sub Control.SetFocus '...'
         If Handle Then .SetFocus Handle
    End Sub

    Sub Control.BringToFront '...'
         If Handle Then BringWindowToTop Handle
    End Sub

    Sub Control.AllocateHint '...'
        If Handle Then
           ToolTipHandle = CreateWindowEx(0, TOOLTIPS_CLASS, "", TTS_ALWAYSTIP, 0, 0, 0, 0, FHandle, NULL, GetModuleHandle(NULL), NULL)
           FToolInfo.uFlags   = TTF_IDISHWND OR TTF_SUBCLASS
           If FParent Then FToolInfo.hwnd = FParent->Handle
           FToolInfo.hinst    = GetModuleHandle(NULL)
           FToolInfo.uId      = Cast(Integer, Handle)
           FToolInfo.lpszText = FHint
           SendMessage(ToolTipHandle, TTM_ADDTOOL, 0, Cint(@FToolInfo))
        End If
    End Sub

    Sub Control.Add(Ctrl As Control Ptr) '...'
        If Ctrl Then
            Dim As Control Ptr FSaveParent = Ctrl->FParent
            Ctrl->FParent = @This
            ControlCount += 1
            Controls = ReAllocate(Controls,SizeOF(Control)*ControlCount)
            Controls[ControlCount -1] = Ctrl
            If Ctrl->Handle Then
                If Handle Then 
                    SetParent Ctrl->Handle, Handle
                    Ctrl->FAnchoredParentWidth = This.Width
                    Ctrl->FAnchoredParentHeight = This.Height
                    Ctrl->FAnchoredLeft = Ctrl->FLeft
                    Ctrl->FAnchoredTop = Ctrl->FTop
                    Ctrl->FAnchoredRight = Ctrl->FAnchoredParentWidth - Ctrl->FWidth - Ctrl->FLeft
                    Ctrl->FAnchoredBottom = Ctrl->FAnchoredParentHeight - Ctrl->FHeight - Ctrl->FTop
                End If
            ElseIf Handle Then
                #IFDEF __AUTOMATE_CREATE_CHILDS__ 
                Ctrl->CreateWnd
                #ENDIF
            End If
            RequestAlign
            If FSaveParent then
                If FSaveParent <> @This Then
                    FSaveParent->Remove Ctrl
                    FSaveParent->RequestAlign
                End If
            End if
        End If
    End Sub

    #IfnDef __FB_64BIT__
    Sub Control.AddRange Cdecl(CountArgs As Integer, ...)
        Dim value As Any Ptr
        value = Va_first()
        For i as integer = 1 to CountArgs
            Add(Va_arg(value, Control Ptr))
            value = Va_next(value, Long)
        Next
    End Sub
    #EndIf

    Sub Control.Remove(Ctrl As Control Ptr) '...'
        Dim As Any Ptr P
        Dim As Integer i,x,Index
        Index = IndexOf(Ctrl)
        If Index >= 0 And Index <= ControlCount -1 Then
           For i = Index + 1 To ControlCount -1
               P = Controls[i]
               Controls[i -1] = P
           Next i
           ControlCount -= 1 
           Controls = ReAllocate(Controls,ControlCount*SizeOf(Control))
           'DeAllocate P
        End If
    End Sub

    Function Control.IndexOf(Ctrl As Control Ptr) As Integer '...'
        Dim As Integer i
        For i = 0 To ControlCount -1
            If Controls[i] = Ctrl Then Return i
        Next i
        Return -1
    End Function

    Operator Control.Cast As Any Ptr '...'
        Return @This
    End Operator

    Operator Control.Let(ByRef Value As Control Ptr) '...'
        If Value Then
           This = *Cast(Control Ptr,Value)
        End If
    End Operator

    Constructor Control '...'
        ClassName = "Control"
        ClassAncestor = ""
        Text = ""
        FVisible = True
        FEnabled = True
        'FHint = CAllocate(0)
    End Constructor

    Destructor Control
        If FHandle Then FreeWnd
        If FText Then DeAllocate FText
        If FHint Then DeAllocate FHint
        If Controls Then DeAllocate Controls
        'Dim As Integer i
        'For i = 0 To ControlCount -1
        '    If Controls[i] Then Controls[i]->Free
        'Next i
    End Destructor
End namespace
