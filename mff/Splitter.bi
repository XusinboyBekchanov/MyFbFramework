'###############################################################################
'#  Splitter.bi                                                                #
'#  This file is part of MyFBFramework                                           #
'#  Version 1.0.0                                                              #
'###############################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
    #DEFINE QSplitter(__Ptr__) *Cast(Splitter Ptr, __Ptr__)

    Type Splitter Extends Control
        Private:
            FOldParentProc  As Any Ptr
            Declare Static Sub ParentWndProc(BYREF Message As Message)
            Declare Static Sub WndProc(BYREF Message As Message)
        Protected:
            Declare Sub DrawTrackSplit(x As Integer, y As Integer)
            Declare Sub ProcessMessage(BYREF Message As Message)
        Public:
            Declare Operator Cast As Control Ptr
            Declare Property Align As Integer
            Declare Property Align(Value As Integer)
            OnPaint As Sub(byref Sender As Splitter)
            OnMoved As Sub(byref Sender As Splitter) 
            Declare Constructor
            Declare Destructor
    End Type
                   
    Sub Splitter.WndProc(BYREF Message As Message)
'        If Message.Sender Then
'            If Cast(TControl Ptr,Message.Sender)->Child Then
'               Cast(Splitter Ptr,Cast(TControl Ptr,Message.Sender)->Child)->ProcessMessage(Message) 
'            End If
'        End If
    End Sub
    
    Property Splitter.Align As Integer
        return Base.Align
    End Property

    Sub Splitter.DrawTrackSplit(x As Integer, y As Integer)
        Static As Word DotBits(7) =>{&H5555, &HAAAA, &H5555, &HAAAA, &H5555, &HAAAA, &H5555, &HAAAA}
        Dim As HDC Dc 
        Dim As HBRUSH hbr
        Dim As HBITMAP Bmp
        Dc  = GetDCEx(Parent->Handle,0,dcx_cache or dcx_clipsiblings) ' or dcx_lockwindowupdate
        Bmp = CreateBitmap(8,8,1,1,@DotBits(0))
        hbr = SelectObject(Dc,CreatePatternBrush(Bmp))
        DeleteObject(Bmp)
        PatBlt(Dc,x,y,ClientWidth,ClientHeight,patinvert)
        DeleteObject(SelectObject(Dc,hbr))
        ReleaseDC(Parent->Handle,Dc)
    End Sub

    Property Splitter.Align(value as Integer)
        Base.Align = value
        Dim cr As My.Sys.Drawing.Cursor
        Select Case value
        Case 1, 2
            cr = crSizeWE
            This.Width = 3
        Case 3, 4
            cr = crSizeNS
            This.Height = 3
        Case Else
            cr = crArrow
        End Select
        If This.Cursor Then Delete This.Cursor
        This.Cursor = New My.Sys.Drawing.Cursor(cr.Handle)
    end Property
    
    Sub Splitter.ParentWndProc(BYREF Message As Message)
        Dim As Control Ptr Ctrl
        Select Case Message.Msg
        Case WM_MOUSEMOVE
            If Message.Captured Then
               Dim As Integer x, y 
               Ctrl = Cast(Control Ptr, GetWindowLongPtr(Message.Captured ,GWLP_USERDATA)) 
               If Ctrl Then
                   If Ctrl->Child Then
                   End If
               End If
            End If
        Case WM_LBUTTONUP
            SendMessage Message.Captured, WM_LBUTTONUP, Message.lParam, Message.lParam
            If Message.Captured Then
               Ctrl = Cast(Control Ptr, GetWindowLongPtr(Message.Captured, GWLP_USERDATA)) 
               If Ctrl Then
                   If Ctrl->Child Then
                   End If
               End If
            End If
            ReleaseCapture
        End Select
    End Sub
                
    Sub Splitter.ProcessMessage(BYREF Message As Message)
        Static As Integer x,y,x1,y1,i,down1
        Static As POINT g_OrigCursorPos, g_CurCursorPos
        Select Case Message.Msg
        Case WM_SETCURSOR
            If Cursor <> 0 Then Message.Result = Cast(LResult, SetCursor(Cursor->Handle)): Return
        Case WM_PAINT
            Dim As Rect R
            Dim As HDC Dc
            Dc = GetDC(Handle)
            GetClientRect Handle,@R
            FillRect Dc, @R, Brush.Handle
            ReleaseDC Handle, DC
            Message.Result = 0
        Case WM_LBUTTONDOWN
            down1 = 1
            If (GetCursorPos(@g_OrigCursorPos)) Then
                SetCapture(Handle)
            End If
            'SetCapture Handle 'Parent->Handle            
'            x1 = loword(message.lparam)
'            y1 = hiword(message.lparam)
'            Select Case Align
'            Case 1, 2
'                  DrawTrackSplit(x1, FTop)
'            Case 3, 4
'                  DrawTrackSplit(FLeft, y1)
'            End Select
'            Down = 1
'            ?"keldi"
        case wm_mousemove
'        int wnd_x = g_OrigWndPos.x + 
            If down1 = 1 Then
                i = Parent->IndexOf(This)
                if (GetCursorPos(@g_CurCursorPos)) Then
                If Parent->ControlCount Then
                   If Align = 1 Then
                       If i > 0 Then Parent->Controls[i-1]->Width = Parent->Controls[i-1]->Width - g_OrigCursorPos.x + g_CurCursorPos.x
                   ElseIf Align = 2 Then
                       If i > 0 Then Parent->Controls[i-1]->Width = Parent->Controls[i-1]->Width + g_OrigCursorPos.x - g_CurCursorPos.x 'This.Left
                   ElseIf Align = 3 Then
                       If i > 0 Then Parent->Controls[i-1]->Height = Parent->Controls[i-1]->Height - g_OrigCursorPos.y + g_CurCursorPos.y
                   ElseIf Align = 4 Then
                       If i > 0 Then Parent->Controls[i-1]->Height = Parent->Controls[i-1]->Height + g_OrigCursorPos.y - g_CurCursorPos.y
                   End If
                   g_OrigCursorPos.x = g_CurCursorPos.x
                   g_OrigCursorPos.y = g_CurCursorPos.y
                   if onMoved then onMoved(This)
                   Parent->UpdateLock
                   Parent->RequestAlign
                   Parent->UpdateUnLock
                   'Parent->Update
                End If
    
                      End If     
End if
'        ?333
'             x = loword(message.lparam)
'             y = hiword(message.lparam)
'             if down then
'                select case Align
'                case 1,2
'                    DrawTrackSplit(x,FTop)
'                    DrawTrackSplit(x1,FTop)
'                case 3,4
'                    DrawTrackSplit(FLeft,y)
'                    DrawTrackSplit(FLeft,y1)
'                end select
'             end if
'             x1 = loword(Message.lParam)
'             y1 = hiword(Message.lParam)
        Case WM_LBUTTONUP
            down1 = 0
            releaseCapture
'            dim as integer i
'            if Down then
'                select case Align
'                case 1,2
'                     DrawTrackSplit(x1,FTop)
'                case 3,4
'                     DrawTrackSplit(FLeft,y1)
'                end select
'                down = 0
'                x = loword(Message.lParam)
'                y = hiword(Message.lParam)
'                i = Parent->IndexOf(Control)
'                ReleaseCapture
'                Parent->ChildProc = FOldParentProc
'                Message.Captured  = 0
'                If Parent->ControlCount Then
'                   If Align = 1 Then
'                       This.Left = x - This.Left 
'                       If i > 0 Then Parent->Controls[i-1]->Width = Parent->Controls[i-1]->Width + This.Left
'                   ElseIf Align = 2 Then
'                       This.Left = This.Left - x
'                       If i > 0 Then Parent->Controls[i-1]->Width = Parent->Controls[i-1]->Width + This.Left
'                   ElseIf Align = 3 Then
'                       Top = y - Top
'                       If i > 0 Then Parent->Controls[i-1]->Height = Parent->Controls[i-1]->Height + Top
'                   ElseIf Align = 4 Then
'                       Top = Top - y 
'                       If i > 0 Then Parent->Controls[i-1]->Height = Parent->Controls[i-1]->Height + Top
'                   End If
'                   Parent->RequestAlign 
'                   if onMoved then onMoved(This)
'                End If
'            End If    
'            ReleaseCapture
'            x = Message.lParamLo
'            y = Message.lParamHi
'            i = Parent->IndexOf(This)
'            Parent->ChildProc = FOldParentProc
'            Message.Captured  = NULL
'            If Parent->ControlCount Then
'               If Align = 1 Then
'                   This.Left = x - This.Left 
'                   If i > 0 Then Parent->Controls[i-1]->Width = Parent->Controls[i-1]->Width + This.Left
'               ElseIf Align = 2 Then
'                   'This.Left = This.Left - x
'                    ?x1 - x, x1, x
'                   If i > 0 Then Parent->Controls[i-1]->Width = Parent->Controls[i-1]->Width + x1 - x 'This.Left
'               ElseIf Align = 3 Then
'                   Top = y - Top
'                   If i > 0 Then Parent->Controls[i-1]->Height = Parent->Controls[i-1]->Height + Top
'               ElseIf Align = 4 Then
'                   Top = Top - y 
'                   If i > 0 Then Parent->Controls[i-1]->Height = Parent->Controls[i-1]->Height + Top
'               End If
'               Parent->RequestAlign 
'            End If
        End Select
        Base.ProcessMessage(Message)
    End Sub
        
    Operator Splitter.Cast As Control Ptr
        Return Cast(Control Ptr, @This)
    End Operator
        
    Constructor Splitter
        With This
             .Child     = @This
             .ChildProc = @WndProc
             .Style     = WS_CHILD
             .ClassName = "Splitter"
             .ClassAncestor = ""
             .Width     = 3
             .Align     = 1
             .Color     = GetSysColor(COLOR_BTNFACE)
             .RegisterClass "Splitter"
        End With
    End Constructor
        
    Destructor Splitter
        UnregisterClass "Splitter", GetModuleHandle(NULL)
    End Destructor
End namespace
