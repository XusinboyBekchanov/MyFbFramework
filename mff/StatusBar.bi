'################################################################################
'#  StatusBar.bi                                                                  #
'#  This file is part of MyFBFramework                                            #
'#  Version 1.0.0                                                                  #
'################################################################################

#Include Once "Control.bi"
#Include Once "Menus.bi"

Namespace My.Sys.Forms
    #DEFINE QStatusBar(__Ptr__) *Cast(StatusBar Ptr, __Ptr__)
    #DEFINE QStatusPanel(__Ptr__) *Cast(StatusPanel Ptr, __Ptr__)

    Enum BevelStyle
          pbLowered    = 0
          pbNone       = SBT_NOBORDERS
          pbRaised     = SBT_POPOUT
          pbOwnerDraw  = SBT_OWNERDRAW
          pbRtlReading = SBT_RTLREADING
        pbNoTabParsing = SBT_NOTABPARSING    
    End Enum

    Type StatusPanel Extends My.Sys.Object
        Private:
            FAlignment As Integer
            FCaption   As WString Ptr
            FBevel     As BevelStyle
            FWidth     As Integer
        Public:  
            Index      As Integer
            StatusBarControl As My.Sys.Forms.Control Ptr
            Declare Property Caption ByRef As WString
            Declare Property Caption(ByRef Value As WString)
            Declare Property Width As Integer
            Declare Property Width(Value As Integer)
            Declare Property Bevel As BevelStyle
            Declare Property Bevel(Value As BevelStyle)
            Declare Property Alignment As Integer
            Declare Property Alignment(Value As Integer)
            Declare Operator Cast As Any Ptr
            Declare Operator Let(ByRef Value As WString)
            Declare Constructor
            Declare Destructor
    End Type
            
    Type StatusBar Extends Control
        Private:
            FSimpleText   As WString Ptr
            FSimplePanel  As Boolean
            FSizeGrip     As Boolean
            AStyle(2)     As Integer 
            Declare Static Sub WndProc(BYREF Message As Message)
            Declare Sub ProcessMessage(BYREF Message As Message)
            Declare Static Sub HandleIsAllocated(BYREF Sender As My.Sys.Forms.Control)
        Public:
            Count         As Integer
            Font          As My.Sys.Drawing.Font
            Panels        As StatusPanel Ptr Ptr
            Declare Property Panel(Index As Integer) As StatusPanel
            Declare Property Panel(Index As Integer, Value As StatusPanel)
            Declare Property Color As Integer
            Declare Property Color(Value As Integer)
            Declare Property SimpleText ByRef As WString
            Declare Property SimpleText(ByRef Value As WString)
            Declare Property SimplePanel As Boolean
            Declare Property SimplePanel(Value As Boolean)
            Declare Property SizeGrip As Boolean
            Declare Property SizeGrip(Value As Boolean)
            Declare Sub Add
            Declare Sub Remove(Index As Integer)
            Declare Sub Clear
            Declare Sub UpdatePanels
            Declare Operator Cast As My.Sys.Forms.Control Ptr
            Declare Constructor
            Declare Destructor
    End Type

    Property StatusPanel.Caption ByRef As WString
        Return *FCaption
    End Property

    Property StatusPanel.Caption(ByRef Value As WString)
        FCaption = Reallocate(FCaption, (Len(Value) + 1) * SizeOf(WString))
        *FCaption = Value 
        If This.StatusBarControl Then Cast(StatusBar Ptr, This.StatusBarControl)->UpdatePanels 
    End Property

    Property StatusPanel.Width As Integer
        Return FWidth
    End Property

    Property StatusPanel.Width(Value As Integer)
        FWidth = Value
        If This.StatusBarControl Then Cast(StatusBar Ptr, This.StatusBarControl)->UpdatePanels 
    End Property

    Property StatusPanel.Bevel As BevelStyle
        Return FBevel
    End Property

    Property StatusPanel.Bevel(Value As BevelStyle)
        FBevel = Value
        If This.StatusBarControl Then Cast(StatusBar Ptr, This.StatusBarControl)->UpdatePanels 
    End Property

    Property StatusPanel.Alignment As Integer
        Return FAlignment
    End Property

    Property StatusPanel.Alignment(Value As Integer)
        FAlignment = Value
        If This.StatusBarControl Then Cast(StatusBar Ptr, This.StatusBarControl)->UpdatePanels 
    End Property

    Operator StatusPanel.Cast As Any Ptr
        Return @This
    End Operator

    Operator StatusPanel.Let(ByRef Value As WString)
        Caption = Value
    End Operator

    Constructor StatusPanel
        FCaption = CAllocate(0)
        Caption   = ""
        FWidth     = 50
        FAlignment = 0
        FBevel     = 0
    End Constructor

    Destructor StatusPanel
        If FCaption Then Deallocate FCaption
    End Destructor

    Sub StatusBar.Add
        Count += 1
        Panels = ReAllocate(Panels, SizeOF(StatusPanel) * Count)
        Panels[Count -1] = New StatusPanel
        Panels[Count -1]->Index     = Count - 1
        Panels[Count -1]->Width     = 50
        Panels[Count -1]->Caption   = ""
        Panels[Count -1]->Alignment = 0
        Panels[Count -1]->Bevel     = pbLowered
        Panels[Count -1]->StatusBarControl = @This
        UpdatePanels
    End Sub

    Sub StatusBar.Remove(Index As Integer)
        Dim As StatusPanel Ptr Ptr Temp
        Dim As Integer i, x = 0
        If Index >= 0 And Index <= Count -1 Then
           Temp = cAllocate((Count - 1) * SizeOf(StatusPanel)) 
           x = 0
           For i = 0 To Count -1
               If i <> Index Then
                  x += 1
                  Temp[x -1] = Panels[i]
               End If
           Next i
           Count -= 1 
           Panels = cAllocate(Count*SizeOf(StatusPanel))
           For i = 0 to Count -1
               Panels[i] = Temp[i]
           Next i
           DeAllocate Temp
        End If
        UpdatePanels
    End Sub

    Sub StatusBar.Clear
        For i As Integer = Count -1 To 0 Step -1
            Remove i
        Next i
        Count = 0
        SetWindowText Handle, ""
    End Sub

    Sub StatusBar.UpdatePanels
        Dim As Integer i,FWidth()
        Dim As WString Ptr s = CAllocate(0)
        ReDim FWidth(Count)
        If Count > 0 Then 
            For i = 0 To Count -1
                If i = 0 Then
                   FWidth(i) = Panels[i]->Width
                Else
                   FWidth(i) = Panels[i]->Width  + FWidth(i -1)
               End If
            Next i
            FWidth(Count - 1) = -1
            Perform(SB_SETPARTS, Count, CInt(@FWidth(0)))
            For i = 0 To Count -1
                If Panels[i]->Alignment = 0 Then
                    s = ReAllocate(s, (Len(Panels[i]->Caption) + 1) * SizeOf(WString))
                    *s = Panels[i]->Caption
                ElseIf Panels[i]->Alignment = 1 Then
                    s = ReAllocate(s, (Len(Chr(9) + Panels[i]->Caption) + 1) * SizeOf(WString))
                    *s = Chr(9)+Panels[i]->Caption
                ElseIf Panels[i]->Alignment = 2 then
                    s = ReAllocate(s, (Len(Chr(9) + Chr(9) + Panels[i]->Caption) + 1) * SizeOf(WString))
                    *s = Chr(9)+Chr(9)+Panels[i]->Caption
                Else 
                    s = ReAllocate(s, (Len(Panels[i]->Caption) + 1) * SizeOf(WString))
                    *s = Panels[i]->Caption
                End If 
                Perform(SB_SETTEXT, i OR Panels[i]->Bevel, CInt(s))
            Next i
        End If 
        Invalidate
    End Sub

    Property StatusBar.Panel(Index As Integer) As StatusPanel
        If Index >= 0 And Index <= Count -1 Then
           Return *Panels[Index]
        End If
    End Property

    Property StatusBar.Panel(Index As Integer, Value As StatusPanel)
        If Index >= 0 And Index <= Count -1 Then
           Panels[Index] = Value
        End If
    End Property

    Property StatusBar.Color As Integer
        Return Base.BackColor
    End Property

    Property StatusBar.Color(Value As Integer)
        Base.BackColor = Value
        If Handle Then SendMessage(Handle, SB_SETBKCOLOR, 0, Base.BackColor)
    End Property

    Property StatusBar.SizeGrip As Boolean
        Return FSizeGrip 
    End Property

    Property StatusBar.SizeGrip(Value As Boolean)
        If Value <> FSizeGrip Then
           FSizeGrip = Value 
           Style  = WS_CHILD OR CCS_NOPARENTALIGN OR AStyle(Abs_(FSizeGrip))
           RecreateWnd
        End If
    End Property

    Property StatusBar.SimplePanel As Boolean
        Return FSimplePanel 
    End Property

    Property StatusBar.SimplePanel(Value As Boolean)
        If Value <> FSimplePanel Then
           FSimplePanel = Value 
           If Handle Then 
               SendMessage(Handle, SB_SIMPLE, FSimplePanel, 0)
               SimpleText = *FSimpleText
           End If
        End If
    End Property

    Property StatusBar.SimpleText ByRef As WString
        Return *FSimpleText
    End Property

    Property StatusBar.SimpleText(ByRef Value As WString)
        If SimplePanel Then
            FSimpleText = Reallocate(FSimpleText, (Len(Value) + 1) * SizeOf(WString))
            *FSimpleText = Value
            Text = *FSimpleText
            If FHandle Then SendMessage(Handle, SB_SETTEXT, 255, CInt(@Value))
        End If    
    End Property

    Sub StatusBar.HandleIsAllocated(BYREF Sender As My.Sys.Forms.Control)
        If Sender.Child Then
            With QStatusBar(Sender.Child)
                 SetClassLong .Handle, GCL_STYLE, GetClassLong(.Handle,GCL_STYLE) AND NOT CS_HREDRAW
                 .Perform(SB_SETBKCOLOR, 0, .Color)
                 .SimpleText = .SimpleText
                 .SimplePanel = .SimplePanel
                 .UpdatePanels
            End With
        End If
    End Sub

    Sub StatusBar.WndProc(BYREF Message As Message)
    End Sub

    Sub StatusBar.ProcessMessage(BYREF Message As Message)
    End Sub

    Operator StatusBar.Cast As My.Sys.Forms.Control Ptr
         Return Cast(My.Sys.Forms.Control Ptr, @This)
    End Operator

    Constructor StatusBar
        FSimpleText = CAllocate(0)
        AStyle(0) = 0
        AStyle(1) = SBARS_SIZEGRIP 
        FSizeGrip = True
        With This
            .RegisterClass "StatusBar","msctls_StatusBar32"
            WLet FClassName, "StatusBar"
            WLet FClassAncestor, "msctls_StatusBar32"
            .Style        = WS_CHILD OR CCS_NOPARENTALIGN OR AStyle(Abs_(FSizeGrip))
            .ExStyle      = 0
            .Width        = 175
            .Height       = 21
            .Color        = GetSysColor(COLOR_BTNFACE) 
            .Child        = @This
            .ChildProc    = @WndProc
            .Color        = GetSysColor(COLOR_BTNFACE)
            .OnHandleIsAllocated = @HandleIsAllocated
        End With
    End Constructor

    Destructor StatusBar
        Panels = cAllocate(0) 
        UnregisterClass "StatusBar",GetModuleHandle(NULL)
        Deallocate FSimpleText
    End Destructor
End Namespace
