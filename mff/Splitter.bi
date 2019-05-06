'###############################################################################
'#  Splitter.bi                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TSplitter.bi                                                              #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
    #DEFINE QSplitter(__Ptr__) *Cast(Splitter Ptr, __Ptr__)

    Type Splitter Extends Control
        Private:
            FOldParentProc  As Any Ptr
            #IfNDef __USE_GTK__
				Declare Static Sub ParentWndProc(BYREF Message As Message)
				Declare Static Sub WndProc(BYREF Message As Message)
			#EndIf
        Protected:
            Declare Sub DrawTrackSplit(x As Integer, y As Integer)
            Declare Sub ProcessMessage(BYREF Message As Message)
        Public:
			#IfDef __USE_GTK__
				Dim As Boolean bCursor
			#EndIf
            Declare Operator Cast As Control Ptr
            Declare Property Align As Integer
            Declare Property Align(Value As Integer)
            OnPaint As Sub(byref Sender As Splitter)
            OnMoved As Sub(byref Sender As Splitter) 
            Declare Constructor
            Declare Destructor
    End Type
            
    #IfNDef __USE_GTK__
		Sub Splitter.WndProc(BYREF Message As Message)
	'        If Message.Sender Then
	'            If Cast(TControl Ptr,Message.Sender)->Child Then
	'               Cast(Splitter Ptr,Cast(TControl Ptr,Message.Sender)->Child)->ProcessMessage(Message) 
	'            End If
	'        End If
		End Sub
	#EndIf
    
    Property Splitter.Align As Integer
        return Base.Align
    End Property

    Sub Splitter.DrawTrackSplit(x As Integer, y As Integer)
        #IfNDef __USE_GTK__
			Static As Word DotBits(7) =>{&H5555, &HAAAA, &H5555, &HAAAA, &H5555, &HAAAA, &H5555, &HAAAA}
			Dim As HDC Dc 
			Dim As HBRUSH hbr
			Dim As HBITMAP Bmp
			Dc  = GetDCEx(This.Parent->Handle,0,dcx_cache or dcx_clipsiblings) ' or dcx_lockwindowupdate
			Bmp = CreateBitmap(8,8,1,1,@DotBits(0))
			hbr = SelectObject(Dc,CreatePatternBrush(Bmp))
			DeleteObject(Bmp)
			PatBlt(Dc,x,y,ClientWidth,ClientHeight,patinvert)
			DeleteObject(SelectObject(Dc,hbr))
			ReleaseDC(This.Parent->Handle,Dc)
		#EndIf
    End Sub

    Property Splitter.Align(value as Integer)
        Base.Align = value
        Var cr = New My.Sys.Drawing.Cursor
        cr->Ctrl = @This
        Select Case value
		Case 1, 2
			*cr = crSizeWE
			This.Width = 3
		Case 3, 4
			*cr = crSizeNS
			This.Height = 3
		Case Else
			*cr = crArrow
		End Select
		If This.Cursor Then Delete This.Cursor
		This.Cursor = cr
    end Property
    
    #IfNDef __USE_GTK__
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
		#EndIf
		
		Sub Splitter.ProcessMessage(BYREF Message As Message)
			Static As Long xOrig, yOrig, xCur, yCur, i, down1
			#IfDef __USE_GTK__
				Dim As GdkDisplay Ptr display = gdk_display_get_default()
				#IfDef __USE_GTK3__
					Dim As GdkDeviceManager Ptr device_manager = gdk_display_get_device_manager(display)
					Dim As GdkDevice Ptr device = gdk_device_manager_get_client_pointer(device_manager)
				#EndIf
				Dim As GdkEvent Ptr e = Message.event
				Select Case Message.event->Type
			#Else
				Static As POINT g_OrigCursorPos, g_CurCursorPos
				Select Case Message.Msg
				Case WM_SETCURSOR
					If CInt(Cursor <> 0) AndAlso CInt(Not DesignMode) Then Message.Result = Cast(LResult, SetCursor(Cursor->Handle)): Return
				Case WM_PAINT
					Dim As Rect R
					Dim As HDC Dc
					Dc = GetDC(Handle)
					GetClientRect Handle,@R
					FillRect Dc, @R, Brush.Handle
					ReleaseDC Handle, DC
					Message.Result = 0
			#EndIf
			#IfDef __USE_GTK__
				Case GDK_BUTTON_PRESS
			#Else
				Case WM_LBUTTONDOWN
			#EndIf
					down1 = 1
				#IfDef __USE_GTK__
					#IfDef __USE_GTK3__
						gdk_device_get_position (device, NULL, @xOrig, @yOrig)
					#Else
						gdk_display_get_pointer (display, NULL, @xOrig, @yOrig, NULL)
					#EndIf
				#Else
					If (GetCursorPos(@g_OrigCursorPos)) Then
						SetCapture(Handle)
					End If
					xOrig = g_OrigCursorPos.x
					yOrig = g_OrigCursorPos.y
				#EndIf
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
				#IfDef __USE_GTK__
				Case GDK_MOTION_NOTIFY
				#Else
				case wm_mousemove
				#EndIf
		'        int wnd_x = g_OrigWndPos.x + 
					If down1 = 1 Then
						i = This.Parent->IndexOf(This)
					#IfDef __USE_GTK__
						#IfDef __USE_GTK3__
							gdk_device_get_position (device, NULL, @xCur, @yCur)
						#Else
							gdk_display_get_pointer (display, NULL, @xCur, @yCur, NULL)
						#EndIf
					#Else
						if (GetCursorPos(@g_CurCursorPos)) Then
							xCur = g_CurCursorPos.x
							yCur = g_CurCursorPos.y
					#EndIf
							If This.Parent->ControlCount Then
							   If Align = 1 Then
								   If i > 0 Then This.Parent->Controls[i-1]->Width = This.Parent->Controls[i-1]->Width - xOrig + xCur
							   ElseIf Align = 2 Then
								   If i > 0 Then This.Parent->Controls[i-1]->Width = This.Parent->Controls[i-1]->Width + xOrig - xCur 'This.Left
							   ElseIf Align = 3 Then
								   If i > 0 Then This.Parent->Controls[i-1]->Height = This.Parent->Controls[i-1]->Height - yOrig + yCur
							   ElseIf Align = 4 Then
								   If i > 0 Then This.Parent->Controls[i-1]->Height = This.Parent->Controls[i-1]->Height + yOrig - yCur
							   End If
							   xOrig = xCur
							   yOrig = yCur
							   if onMoved then onMoved(This)
							   This.Parent->UpdateLock
							   This.Parent->RequestAlign
							   #IfDef __USE_GTK__
									If i > 0 Then This.Parent->Controls[i-1]->RequestAlign
								'#Else
							'		This.Parent->RequestAlign
							   #EndIf
							   This.Parent->UpdateUnLock
							   'Parent->Update
							End If
					#IfNDef __USE_GTK__
						End If
					#EndIf
					End if
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
				#IfDef __USE_GTK__
				Case GDK_BUTTON_RELEASE
				#Else
				Case WM_LBUTTONUP
				#EndIf
					down1 = 0
				#IfNDef __USE_GTK__
					releaseCapture
				#EndIf
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
    
    #IfDef __USE_GTK__
	    Function OnDraw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As gpointer) As Boolean
			Dim As Splitter Ptr spl = data1
			If Not spl->bCursor Then
				spl->bCursor = True
				spl->Align = spl->Align
			End If
			return FALSE
	    End Function
	    
	    Function OnExposeEvent(widget As GtkWidget Ptr, event As GdkEventExpose Ptr, data1 As gpointer) As Boolean
			Dim As cairo_t Ptr cr = gdk_cairo_create(event->window)
			OnDraw(widget, cr, data1)
			cairo_destroy(cr)
			return FALSE
	    End Function
	#EndIf
        
    Constructor Splitter
        With This
             .Child     = @This
             #IfDef __USE_GTK__
				'widget = gtk_separator_new(GTK_ORIENTATION_VERTICAL)
				'widget = gtk_drawing_area_new()
				widget = gtk_layout_new(NULL, NULL)
				gtk_widget_set_events(widget, _
	                      GDK_EXPOSURE_MASK Or _
	                       GDK_SCROLL_MASK Or _
	                       GDK_STRUCTURE_MASK Or _
	                       GDK_KEY_PRESS_MASK Or _
	                       GDK_KEY_RELEASE_MASK Or _
	                       GDK_FOCUS_CHANGE_MASK Or _
	                       GDK_LEAVE_NOTIFY_MASK Or _
	                       GDK_BUTTON_PRESS_MASK Or _
	                       GDK_BUTTON_RELEASE_MASK Or _
	                       GDK_POINTER_MOTION_MASK Or _
	                       GDK_POINTER_MOTION_HINT_MASK)
				'gtk_scrolled_window_set_policy(gtk_scrolled_window(widget), GTK_POLICY_EXTERNAL, GTK_POLICY_EXTERNAL)
				.RegisterClass "Splitter", @This
				#IfDef __USE_GTK3__
					g_signal_connect(widget, "draw", G_CALLBACK(@OnDraw), @This)
             	#Else
             		g_signal_connect(widget, "expose-event", G_CALLBACK(@OnExposeEvent), @This)
             	#EndIf
             #Else
				.RegisterClass "Splitter"
				 .ChildProc = @WndProc
				 .Style     = WS_CHILD
				.BackColor     = GetSysColor(COLOR_BTNFACE)
             #EndIf
             WLet FClassName, "Splitter"
             WLet FClassAncestor, ""
             .Width     = 3
             .Align     = 1
        End With
    End Constructor
        
    Destructor Splitter
		#IfNDef __USE_GTK__
			UnregisterClass "Splitter", GetModuleHandle(NULL)
		#EndIf
    End Destructor
End namespace
