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
	#ifndef ReadProperty_Off
		Private Function Splitter.ReadProperty(PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "align": Return @FAlign
			Case "minextra": Return @MinExtra
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function Splitter.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "align": This.Align = *Cast(SplitterAlignmentConstants Ptr, Value)
			Case "minextra": This.MinExtra = QInteger(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	
	#ifdef __USE_WINAPI__
		Private Sub Splitter.WndProc(ByRef Message As Message)
			'        If Message.Sender Then
			'            If Cast(TControl Ptr,Message.Sender)->Child Then
			'               Cast(Splitter Ptr,Cast(TControl Ptr,Message.Sender)->Child)->ProcessMessage(Message)
			'            End If
			'        End If
		End Sub
	#endif
	
	Private Property Splitter.Align As SplitterAlignmentConstants
		Return Base.Align
	End Property
	
	Private Sub Splitter.DrawTrackSplit(x As Integer, y As Integer)
		#ifdef __USE_WINAPI__
'			Static As Word DotBits(7) =>{&H5555, &HAAAA, &H5555, &HAAAA, &H5555, &HAAAA, &H5555, &HAAAA}
'			Dim As HDC Dc
'			Dim As HBRUSH hbr
'			Dim As HBITMAP Bmp
'			Dc  = GetDCEx(This.Parent->Handle,0,dcx_cache Or dcx_clipsiblings) ' or dcx_lockwindowupdate
'			Bmp = CreateBitmap(8,8,1,1,@DotBits(0))
'			hbr = SelectObject(Dc,CreatePatternBrush(Bmp))
'			DeleteObject(Bmp)
'			PatBlt(Dc, x, y, ScaleX(ClientWidth), ScaleY(ClientHeight), patinvert)
'			DeleteObject(SelectObject(Dc,hbr))
'			ReleaseDC(This.Parent->Handle,Dc)
		#endif
	End Sub
	
	Private Property Splitter.Align(value As SplitterAlignmentConstants)
		Base.Align = *Cast(DockStyle Ptr, @value)
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
	
	#ifdef __USE_WINAPI__
		Private Sub Splitter.ParentWndProc(ByRef Message As Message)
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
	
	#if Not defined(__USE_GTK__) AndAlso Not defined(__USE_WINAPI__)
		#define SPLITTER_PRESS   -101
		#define SPLITTER_MOVE    -102
		#define SPLITTER_RELEASE -103
	#endif
	
	Private Sub Splitter.ProcessMessage(ByRef Message As Message)
		Static As Long xOrig, yOrig, xCur, yCur, i, down1
		' The size of the control at the press: the new size is computed from it and not from the current size,
		' the current size of GTK is the allocated size, which changes only after the next frame
		Static As Integer iStartLeft, iStartTop, iStartWidth, iStartHeight
		Static As Control Ptr SizeCtrl
		Dim As Integer iNewSize
		#ifdef __USE_GTK__
			Dim As GdkDisplay Ptr display = gdk_display_get_default()
			#ifndef __USE_GTK2__
				Dim As GdkDeviceManager Ptr device_manager = gdk_display_get_device_manager(display)
				Dim As GdkDevice Ptr device = gdk_device_manager_get_client_pointer(device_manager)
			#endif
			Dim As GdkEvent Ptr e = Message.event
			#ifdef __USE_GTK4__
				Select Case gtk4compat_event_type(Message.event)
			#else
				Select Case Message.event->Type
			#endif
		#elseif defined(__USE_WINAPI__)
			Static As ..Point g_OrigCursorPos, g_CurCursorPos
			Select Case Message.Msg
			Case WM_SETCURSOR
				If CInt(Cursor.Handle <> 0) AndAlso CInt(Not FDesignMode) Then Message.Result = Cast(LResult, SetCursor(Cursor.Handle)): Return
			Case WM_PAINT
				If g_darkModeSupported AndAlso g_darkModeEnabled Then
					If Not FDarkMode Then
						SetDark True
'						FDarkMode = True
'						Brush.Handle = hbrBkgnd
'						SendMessageW(FHandle, WM_THEMECHANGED, 0, 0)
					End If
				Else
					If FDarkMode Then
						SetDark False
'						FDarkMode = False
'						If FBackColor = -1 Then
'							Brush.Handle = 0
'						Else
'							Brush.Color = FBackColor
'						End If
'						SendMessageW(FHandle, WM_THEMECHANGED, 0, 0)
					End If
				End If
				Dim As ..Rect R
				Dim As HDC Dc
				Dc = GetDC(Handle)
				GetClientRect Handle, @R
				SetBKMode Dc, TRANSPARENT
				FillRect Dc, @R, Brush.Handle
				SetBKColor Dc, OPAQUE
				ReleaseDC Handle, DC
				Message.Result = 0
				Exit Sub
		#else
			'Web: the drag of the splitter element (SetDragEvent) arrives as CM_CHANGE with data-drag = 1 (press), 2 (move), 3 (release)
			'and the distance from the press in data-dx and data-dy; the messages below are made for the shared code
			#ifdef __USE_WASM__
				If Message.Msg = CM_CHANGE Then
					Dim As ZString Ptr pValue = GetAttribute(FHandle, "data-drag")
					Dim As Integer DragState = ValInt(*pValue)
					FreePtr(pValue)
					pValue = GetAttribute(FHandle, "data-dx"): xCur = ScaleX(ValInt(*pValue)): FreePtr(pValue)
					pValue = GetAttribute(FHandle, "data-dy"): yCur = ScaleY(ValInt(*pValue)): FreePtr(pValue)
					Message.Msg = IIf(DragState = 1, SPLITTER_PRESS, IIf(DragState = 2, SPLITTER_MOVE, SPLITTER_RELEASE))
					Message.Handled = True
				End If
			#endif
			Select Case Message.Msg
		#endif
			#ifdef __USE_GTK__
			Case GDK_BUTTON_PRESS
			#elseif defined(__USE_WINAPI__)
			Case WM_LBUTTONDOWN
			#else
			Case SPLITTER_PRESS
			#endif
			down1 = 1
			#ifdef __USE_GTK__
				#ifndef __USE_GTK2__
					gdk_device_get_position (device, NULL, @xOrig, @yOrig)
				#else
					gdk_display_get_pointer (display, NULL, @xOrig, @yOrig, NULL)
				#endif
			#elseif defined(__USE_WINAPI__)
				If (GetCursorPos(@g_OrigCursorPos)) Then
					SetCapture(Handle)
				End If
				Dim As ..Rect R
				Dim As ..Point P
				GetClientRect GetParent(Handle), @R
				..ClientToScreen GetParent(Handle), @P
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
			#else
				xOrig = 0
				yOrig = 0
			#endif
			SizeCtrl = 0
			i = This.Parent->IndexOf(@This)
			If i > 0 Then
				SizeCtrl = This.Parent->Controls[i - 1]
				SizeCtrl->GetBounds iStartLeft, iStartTop, iStartWidth, iStartHeight
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
			#ifdef __USE_GTK__
			Case GDK_MOTION_NOTIFY
			#elseif defined(__USE_WINAPI__)
			Case WM_MOUSEMOVE
			#else
			Case SPLITTER_MOVE
			#endif
			'        int wnd_x = g_OrigWndPos.x +
			If down1 = 1 Then
				i = This.Parent->IndexOf(@This)
				#ifdef __USE_GTK__
					#ifndef __USE_GTK2__
						gdk_device_get_position (device, NULL, @xCur, @yCur)
					#else
						gdk_display_get_pointer (display, NULL, @xCur, @yCur, NULL)
					#endif
				#elseif defined(__USE_WINAPI__)
					If (GetCursorPos(@g_CurCursorPos)) Then
						xCur = g_CurCursorPos.x
						yCur = g_CurCursorPos.y
				#endif
					If This.Parent->ControlCount AndAlso i > 0 AndAlso SizeCtrl = This.Parent->Controls[i - 1] Then
						#ifdef __USE_WINAPI__
							' One layout pass for the step: the moves do not paint, and when the pass ends
							'only the places the moved windows left and took are painted (at once, so that
							'the panels follow the mouse), not the whole parent with all its children
							Dim As Integer iSavedAlignLock = AlignLock
							AlignLock = iSavedAlignLock + 1
							If iSavedAlignLock = 0 Then AlignClear
						#else
							This.Parent->UpdateLock
						#endif
						' The control and the splitter are moved at once: the right and the bottom control keep their
						' right and bottom edge (with only the new size the edge moves until the parent aligns again)
						Select Case Align
						Case SplitterAlignmentConstants.alLeft
							iNewSize = Max(0, iStartWidth - UnScaleX(xOrig) + UnScaleX(xCur))
							SizeCtrl->SetBounds iStartLeft, iStartTop, iNewSize, iStartHeight
							This.Left = iStartLeft + iNewSize
						Case SplitterAlignmentConstants.alRight
							iNewSize = Max(0, iStartWidth + UnScaleX(xOrig) - UnScaleX(xCur))
							SizeCtrl->SetBounds iStartLeft + iStartWidth - iNewSize, iStartTop, iNewSize, iStartHeight
							This.Left = iStartLeft + iStartWidth - iNewSize - This.Width
						Case SplitterAlignmentConstants.alTop
							iNewSize = Max(0, iStartHeight - UnScaleY(yOrig) + UnScaleY(yCur))
							SizeCtrl->SetBounds iStartLeft, iStartTop, iStartWidth, iNewSize
							This.Top = iStartTop + iNewSize
						Case SplitterAlignmentConstants.alBottom
							iNewSize = Max(0, iStartHeight + UnScaleY(yOrig) - UnScaleY(yCur))
							SizeCtrl->SetBounds iStartLeft, iStartTop + iStartHeight - iNewSize, iStartWidth, iNewSize
							This.Top = iStartTop + iStartHeight - iNewSize - This.Height
						End Select
						If OnMoving Then OnMoving(*Designer, This)
						This.Parent->RequestAlign
						#ifdef __USE_GTK__
							If i > 0 Then This.Parent->Controls[i-1]->RequestAlign
							'#Else
							'		This.Parent->RequestAlign
						#endif
						#ifdef __USE_WINAPI__
							AlignLock = iSavedAlignLock
							If iSavedAlignLock = 0 Then AlignRedraw This.Parent->Handle, True
						#else
							This.Parent->UpdateUnLock
							This.Parent->Repaint
						#endif
						'This.Parent->Update
						'Parent->Update
					End If
					#ifdef __USE_WINAPI__
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
			#elseif defined(__USE_WINAPI__)
			Case WM_LBUTTONUP
			#else
			Case SPLITTER_RELEASE
			#endif
			down1 = 0
			SizeCtrl = 0
			#ifdef __USE_WINAPI__
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
			If OnMoved Then OnMoved(*Designer, This)
		End Select
		Base.ProcessMessage(Message)
	End Sub
	
	#ifdef __USE_WASM__
		Private Sub Splitter.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then SetDragEvent(Sender.Handle)
		End Sub
	#endif
	
	Private Operator Splitter.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Private Function Splitter.OnDraw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As gpointer) As Boolean
			Dim As Splitter Ptr spl = data1
			If Not spl->bCursor Then
				spl->bCursor = True
				spl->Align = spl->Align
			End If
			Return False
		End Function
		
		Private Function Splitter.OnExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As gpointer) As Boolean
			#ifdef __USE_GTK4__
				Dim As cairo_t Ptr cr = gdk_cairo_create(NULL)
			#else
				Dim As cairo_t Ptr cr = gdk_cairo_create(Event->window)
			#endif
			OnDraw(widget, cr, data1)
			cairo_destroy(cr)
			Return False
		End Function
	#endif
	
	Private Constructor Splitter
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
				#ifndef __USE_GTK2__
					#ifdef __USE_GTK4__
						gtk4compat_signal_connect(widget, "draw", G_CALLBACK(@OnDraw), @This)
					#else
						g_signal_connect(widget, "draw", G_CALLBACK(@OnDraw), @This)
					#endif
				#else
					g_signal_connect(widget, "expose-event", G_CALLBACK(@OnExposeEvent), @This)
				#endif
			#elseif defined(__USE_WINAPI__)
				.RegisterClass "Splitter"
				.ChildProc = @WndProc
				.Style     = WS_CHILD
				.BackColor     = GetSysColor(COLOR_BTNFACE)
				FDefaultBackColor = .BackColor
				'.DoubleBuffered = True
			#endif
			WLet(FClassName, "Splitter")
			WLet(FClassAncestor, "")
			#ifdef __USE_WASM__
				WLet(FClassAncestor, "div")
				FElementStyle = "background-color: var(--mff-line, #ddd); touch-action: none;"
				.OnHandleIsAllocated = @HandleIsAllocated
			#elseif defined(__USE_JNI__)
				WLet(FClassAncestor, "mff:Layout")
			#endif
			.Width     = 3
			.Align     = SplitterAlignmentConstants.alLeft
		End With
	End Constructor
	
	Private Destructor Splitter
		#ifdef __USE_WINAPI__
			'UnregisterClass "Splitter", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
