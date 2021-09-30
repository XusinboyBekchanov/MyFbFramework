'###############################################################################
'#  Splitter.bi                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TSplitter.bi                                                              #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "Splitter.bi"

Namespace My.Sys.Forms
	Function Splitter.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "align": Return @FAlign
		Case "minextra": Return @MinExtra
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function Splitter.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "align": This.Align = *Cast(SplitterAlignmentConstants Ptr, Value)
		Case "minextra": This.MinExtra = QInteger(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	#ifndef __USE_GTK__
		Sub Splitter.WndProc(ByRef Message As Message)
			'        If Message.Sender Then
			'            If Cast(TControl Ptr,Message.Sender)->Child Then
			'               Cast(Splitter Ptr,Cast(TControl Ptr,Message.Sender)->Child)->ProcessMessage(Message)
			'            End If
			'        End If
		End Sub
	#endif
	
	Property Splitter.Align As SplitterAlignmentConstants
		Return Base.Align
	End Property
	
	Sub Splitter.DrawTrackSplit(x As Integer, y As Integer)
		#ifndef __USE_GTK__
			Static As Word DotBits(7) =>{&H5555, &HAAAA, &H5555, &HAAAA, &H5555, &HAAAA, &H5555, &HAAAA}
			Dim As HDC Dc
			Dim As HBRUSH hbr
			Dim As HBITMAP Bmp
			Dc  = GetDCEx(This.Parent->Handle,0,dcx_cache Or dcx_clipsiblings) ' or dcx_lockwindowupdate
			Bmp = CreateBitmap(8,8,1,1,@DotBits(0))
			hbr = SelectObject(Dc,CreatePatternBrush(Bmp))
			DeleteObject(Bmp)
			PatBlt(Dc, x, y, ScaleX(ClientWidth), ScaleY(ClientHeight), patinvert)
			DeleteObject(SelectObject(Dc,hbr))
			ReleaseDC(This.Parent->Handle,Dc)
		#endif
	End Sub
	
	Property Splitter.Align(value As SplitterAlignmentConstants)
		Base.Align = value
		Select Case value
		Case 1, 2
			This.Cursor = crSizeWE
			This.Width = 3
		Case 3, 4
			This.Cursor = crSizeNS
			This.Height = 3
		Case Else
			This.Cursor = crArrow
		End Select
	End Property
	
	#ifndef __USE_GTK__
		Sub Splitter.ParentWndProc(ByRef Message As Message)
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
	#endif
	
	Sub Splitter.ProcessMessage(ByRef Message As Message)
		Static As Long xOrig, yOrig, xCur, yCur, i, down1
		#ifdef __USE_GTK__
			Dim As GdkDisplay Ptr display = gdk_display_get_default()
			#ifdef __USE_GTK3__
				Dim As GdkDeviceManager Ptr device_manager = gdk_display_get_device_manager(display)
				Dim As GdkDevice Ptr device = gdk_device_manager_get_client_pointer(device_manager)
			#endif
			Dim As GdkEvent Ptr e = Message.event
			Select Case Message.event->Type
		#else
			Static As Point g_OrigCursorPos, g_CurCursorPos
			Select Case Message.Msg
			Case WM_SETCURSOR
				If CInt(Cursor.Handle <> 0) AndAlso CInt(Not FDesignMode) Then Message.Result = Cast(LResult, SetCursor(Cursor.Handle)): Return
			Case WM_PAINT
				Dim As Rect R
				Dim As HDC Dc
				Dc = GetDC(Handle)
				GetClientRect Handle,@R
				FillRect Dc, @R, Brush.Handle
				ReleaseDC Handle, DC
				'	Message.Result = 0
		#endif
			#ifdef __USE_GTK__
			Case GDK_BUTTON_PRESS
			#else
			Case WM_LBUTTONDOWN
			#endif
			down1 = 1
			#ifdef __USE_GTK__
				#ifdef __USE_GTK3__
					gdk_device_get_position (device, NULL, @xOrig, @yOrig)
				#else
					gdk_display_get_pointer (display, NULL, @xOrig, @yOrig, NULL)
				#endif
			#else
				If (GetCursorPos(@g_OrigCursorPos)) Then
					SetCapture(Handle)
				End If
				Dim As Rect R
				Dim As Point P
				GetClientRect GetParent(Handle), @R
				ClientToScreen GetParent(Handle), @P
				R.Left = P.X
				R.Top = P.Y
				R.Right = R.Right + P.X
				R.Bottom = R.Bottom + P.Y
				Select Case This.Align
				Case 1, 2
					R.Left = R.Left + ScaleX(This.MinExtra)
					R.Right = R.Right - ScaleX(This.MinExtra)
				Case 3, 4
					R.Top = R.Top + ScaleX(This.MinExtra)
					R.Bottom = R.Bottom - ScaleX(This.MinExtra)
				End Select
				ClipCursor @R
				xOrig = g_OrigCursorPos.x
				yOrig = g_OrigCursorPos.y
			#endif
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
			#ifdef __USE_GTK__
			Case GDK_MOTION_NOTIFY
			#else
			Case wm_mousemove
			#endif
			'        int wnd_x = g_OrigWndPos.x +
			If down1 = 1 Then
				i = This.Parent->IndexOf(@This)
				#ifdef __USE_GTK__
					#ifdef __USE_GTK3__
						gdk_device_get_position (device, NULL, @xCur, @yCur)
					#else
						gdk_display_get_pointer (display, NULL, @xCur, @yCur, NULL)
					#endif
				#else
					If (GetCursorPos(@g_CurCursorPos)) Then
						xCur = g_CurCursorPos.x
						yCur = g_CurCursorPos.y
				#endif
					If This.Parent->ControlCount Then
						This.Parent->UpdateLock
						Select Case Align
						Case SplitterAlignmentConstants.alLeft
							If i > 0 Then This.Parent->Controls[i - 1]->Width = This.Parent->Controls[i - 1]->Width - UnScaleX(xOrig) + UnScaleX(xCur)
						Case SplitterAlignmentConstants.alRight
							If i > 0 Then This.Parent->Controls[i - 1]->Width = This.Parent->Controls[i - 1]->Width + UnScaleX(xOrig) - UnScaleX(xCur)
						Case SplitterAlignmentConstants.alTop
							If i > 0 Then This.Parent->Controls[i - 1]->Height = This.Parent->Controls[i - 1]->Height - UnScaleY(yOrig) + UnScaleY(yCur)
						Case SplitterAlignmentConstants.alBottom
							If i > 0 Then This.Parent->Controls[i - 1]->Height = This.Parent->Controls[i - 1]->Height + UnScaleY(yOrig) - UnScaleY(yCur)
						End Select
						xOrig = xCur
						yOrig = yCur
						If onMoved Then onMoved(This)
						This.Parent->RequestAlign
						#ifdef __USE_GTK__
							If i > 0 Then This.Parent->Controls[i-1]->RequestAlign
							'#Else
							'		This.Parent->RequestAlign
						#endif
						This.Parent->UpdateUnLock
						This.Parent->Update
						'Parent->Update
					End If
					#ifndef __USE_GTK__
					End If
					#endif
			End If
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
			#ifdef __USE_GTK__
			Case GDK_BUTTON_RELEASE
			#else
			Case WM_LBUTTONUP
			#endif
			down1 = 0
			#ifndef __USE_GTK__
				ClipCursor 0
				releaseCapture
			#endif
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
	
	#ifdef __USE_GTK__
		Function OnDraw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As gpointer) As Boolean
			Dim As Splitter Ptr spl = data1
			If Not spl->bCursor Then
				spl->bCursor = True
				spl->Align = spl->Align
			End If
			Return False
		End Function
		
		Function OnExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As gpointer) As Boolean
			Dim As cairo_t Ptr cr = gdk_cairo_create(Event->window)
			OnDraw(widget, cr, data1)
			cairo_destroy(cr)
			Return False
		End Function
	#endif
	
	Constructor Splitter
		With This
			.Child     = @This
			#ifdef __USE_GTK__
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
				#ifdef __USE_GTK3__
					g_signal_connect(widget, "draw", G_CALLBACK(@OnDraw), @This)
				#else
					g_signal_connect(widget, "expose-event", G_CALLBACK(@OnExposeEvent), @This)
				#endif
			#else
				.RegisterClass "Splitter"
				.ChildProc = @WndProc
				.Style     = WS_CHILD
				.BackColor     = GetSysColor(COLOR_BTNFACE)
				'.DoubleBuffered = True
			#endif
			This.Cursor.Ctrl = @This
			WLet(FClassName, "Splitter")
			WLet(FClassAncestor, "")
			.Width     = 3
			.Align     = SplitterAlignmentConstants.alLeft
		End With
	End Constructor
	
	Destructor Splitter
		#ifndef __USE_GTK__
			UnregisterClass "Splitter", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
