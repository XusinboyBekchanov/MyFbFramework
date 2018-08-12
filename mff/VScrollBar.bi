'###############################################################################
'#  VScrollBar.bi                                                               #
'#  This file is part of MyFBFramework                                           #
'#  Version 1.0.0                                                              #
'###############################################################################

Namespace My.Sys.Forms
    #DEFINE QVScrollBar(__Ptr__) *Cast(VScrollBar Ptr,__Ptr__)

    Type VScrollBar Extends Control
        Private:
            FMin            As Integer
            FMax            As Integer 
            FPosition       As Integer
            FArrowChangeSize     As Integer
            FPageSize       As Integer
            SIF             As SCROLLINFO
            Declare Static Sub WndProc(BYREF Message As Message)
            Declare Sub ProcessMessage(BYREF Message As Message)
            Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
        Public:
            Declare Property MinValue As Integer
            Declare Property MinValue(Value As Integer)
            Declare Property MaxValue As Integer
            Declare Property MaxValue(Value As Integer)
            Declare Property ArrowChangeSize As Integer
            Declare Property ArrowChangeSize(Value As Integer)
            Declare Property PageSize As Integer
            Declare Property PageSize(Value As Integer)
            Declare Property Position As Integer
            Declare Property Position(Value As Integer)
            Declare Operator Cast As Control Ptr
            Declare Constructor
            Declare Destructor
            OnChange As Sub(BYREF Sender As VScrollBar)
            OnScroll As Sub(BYREF Sender As VScrollBar, ByRef NewPos As UInt)
    End Type
    
    Property VScrollBar.MinValue As Integer
        Return FMin
    End Property

    Property VScrollBar.MinValue(Value As Integer)
        FMin = Value
        If Handle Then Perform(SBM_SETRANGE, FMin, FMax)
    End Property

    Property VScrollBar.MaxValue As Integer
        Return FMax
    End Property

    Property VScrollBar.MaxValue(Value As Integer)
        FMax = Value
        If Handle Then Perform(SBM_SETRANGE, FMin, FMax)
    End Property

    Property VScrollBar.Position As Integer
        Return FPosition
    End Property

    Property VScrollBar.Position(Value As Integer)
        FPosition = Value
        If Handle Then Perform(SBM_SETPOS, FPosition, True)
    End Property

    Property VScrollBar.ArrowChangeSize As Integer
        Return FArrowChangeSize
    End Property

    Property VScrollBar.ArrowChangeSize(Value As Integer)
        FArrowChangeSize = Value
    End Property

    Property VScrollBar.PageSize As Integer
        Return FPageSize
    End Property

    Property VScrollBar.PageSize(Value As Integer)
        If FPageSize > FMax Or Value = FPageSize Then Exit Property
        FPageSize = Value
        SIF.fMask = SIF_PAGE
        SIF.nPage = FPageSize
        If Handle Then Perform(SBM_SETSCROLLINFO, True, CInt(@SIF))
    End Property

    Sub VScrollBar.HandleIsAllocated(BYREF Sender As Control)
        If Sender.Child Then
            With QVScrollBar(Sender.Child)
                 .MinValue = .MinValue
                 .MaxValue = .MaxValue
                 .Position = .Position
                 .PageSize = .PageSize
            End With
        End If
    End Sub

    Sub VScrollBar.WndProc(BYREF Message As Message)
    End Sub

    Sub VScrollBar.ProcessMessage(BYREF Message As Message)
        Static As Integer OldPos
        Select Case Message.Msg
        Case WM_PAINT
'            #IF DEFINED(APPLICATION)
'            If UCase(Application.OSVersion) = "WINDOWS XP" Then
'               Hint = This.Hint 'XP ?!
'            End If
'            #ENDIF
            Message.Result = 0
        Case CM_CREATE
            sif.cbSize = sizeof(sif)
              sif.fMask  = SIF_RANGE Or SIF_PAGE
              sif.nMin   = FMin
              sif.nMax   = FMax
              sif.nPage  = FPageSize
            SetScrollInfo(FHandle, SB_CTL, @sif, TRUE)
        Case CM_HSCROLL, CM_VSCROLL
            Var lo = Loword(Message.wParam)
            sif.cbSize = sizeof(sif)
                sif.fMask  = SIF_ALL
                GetScrollInfo (FHandle, SB_CTL, @sif)
            OldPos = sif.nPos
            Select Case lo
            Case SB_TOP, SB_LEFT
                sif.nPos = sif.nMin
            Case SB_BOTTOM, SB_RIGHT
                sif.nPos = sif.nMax
            Case SB_LINEUP, SB_LINELEFT
                sif.nPos -= FArrowChangeSize
            Case SB_LINEDOWN, SB_LINERIGHT
                sif.nPos += FArrowChangeSize
            Case SB_PAGEUP, SB_PAGELEFT
                sif.nPos -= sif.nPage
            Case SB_PAGEDOWN, SB_PAGERIGHT
                sif.nPos += sif.nPage
            Case SB_THUMBPOSITION, SB_THUMBTRACK
                sif.nPos = sif.nTrackPos
            End Select
            sif.fMask = SIF_POS
              SetScrollInfo(FHandle, SB_CTL, @sif, TRUE)
              GetScrollInfo(FHandle, SB_CTL, @sif)
            If (Not sif.nPos = OldPos) Then
                  If OnScroll Then
                   OnScroll(This, sif.nPos)
                End If
                End If
        End Select
        Base.ProcessMessage(message)
    End Sub

    Operator VScrollBar.Cast As Control Ptr 
        Return Cast(Control Ptr, @This)
    End Operator

    Constructor VScrollBar
        SIF.cbSize = SizeOF(SCROLLINFO)
        FMin       = 0
        FMax       = 100
        FPosition  = 0
        PageSize   = 1
        With This
            .RegisterClass "VScrollBar", "ScrollBar"
            .Child       = @This
            .ChildProc   = @WndProc
            WLet FClassName, "VScrollBar"
            WLet FClassAncestor, "ScrollBar"
            .ExStyle     = 0
            Base.Style       = WS_CHILD OR SB_VERT
            .Width       = 17
            .Height      = 121
            .OnHandleIsAllocated = @HandleIsAllocated
        End With  
    End Constructor

    Destructor VScrollBar
    End Destructor
End Namespace
