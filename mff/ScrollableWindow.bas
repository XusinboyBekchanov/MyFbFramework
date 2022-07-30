'###############################################################################
'#  ScrollableWindow.bi                                                        #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#include once "ScrollableWindow.bi"

Namespace My.Sys.Forms
	Private Function ScrollableWindow.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "tabindex": Return @FTabIndex
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Private Function ScrollableWindow.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "tabindex": TabIndex = QInteger(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Private Property ScrollableWindow.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property ScrollableWindow.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property ScrollableWindow.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property ScrollableWindow.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	#ifndef __USE_GTK__
		Private Sub ScrollableWindow.SetScrollsInfo
			Dim Si As SCROLLINFO
			Dim As Integer MaxWidth, MaxHeight
			
			GetMax MaxWidth, MaxHeight
			
			Si.cbSize = SizeOf(Si)
			Si.fMask  = SIF_RANGE Or SIF_PAGE
			Si.nMin   = 0
			Si.nMax   = MaxWidth
			Si.nPage  = This.ClientWidth
			SetScrollInfo(This.Handle, SB_HORZ, @Si, True)
			
			Si.cbSize = SizeOf(Si)
			Si.fMask  = SIF_RANGE Or SIF_PAGE
			Si.nMin   = 0
			Si.nMax   = MaxHeight
			Si.nPage  = This.ClientHeight
			SetScrollInfo(This.Handle, SB_VERT, @Si, True)
		End Sub
		
		Private Sub ScrollableWindow.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QScrollableWindow(Sender.Child)
					.SetScrollsInfo
				End With
			End If
		End Sub
		
		Private Sub ScrollableWindow.WNDPROC(ByRef Message As Message)
		End Sub
	#endif
	
	Sub ScrollableWindow.GetMax(ByRef MaxWidth As Integer, ByRef MaxHeight As Integer)
		MaxWidth = 0
		MaxHeight = 0
		For i As Integer = 0 To ControlCount - 1
			If MaxWidth < Controls[i]->Left + Controls[i]->Width Then MaxWidth = Controls[i]->Left + Controls[i]->Width
			If MaxHeight < Controls[i]->Top + Controls[i]->Height Then MaxHeight = Controls[i]->Top + Controls[i]->Height
		Next
	End Sub
	
	Private Sub ScrollableWindow.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Dim Si As SCROLLINFO
			Dim As Integer MaxWidth, MaxHeight, ScrollPos
			Select Case Message.Msg
			Case WM_PAINT
				Dim As HDC Dc, memDC
				Dim As HBITMAP Bmp
				Dim As PAINTSTRUCT Ps
				Canvas.HandleSetted = True
				If g_darkModeSupported AndAlso g_darkModeEnabled Then
					If Not FDarkMode Then
						SetDark True
					End If
				Else
					If FDarkMode Then
						SetDark False
					End If
				End If
				Dc = BeginPaint(Handle, @Ps)
				If DoubleBuffered Then
					memDC = CreateCompatibleDC(Dc)
					Bmp   = CreateCompatibleBitmap(Dc,Ps.rcPaint.Right,Ps.rcPaint.Bottom)
					SelectObject(memDC,Bmp)
					SendMessage(Handle, WM_ERASEBKGND, CInt(memDC), CInt(memDC))
					FillRect memDC,@Ps.rcPaint, Brush.Handle
					Canvas.Handle = memDC
					If OnPaint Then OnPaint(This, Canvas)
					BitBlt(Dc, 0, 0, Ps.rcPaint.Right, Ps.rcPaint.Bottom, memDC, 0, 0, SRCCOPY)
					DeleteObject(Bmp)
					DeleteDC(memDC)
				Else
					FillRect Dc, @Ps.rcPaint, Brush.Handle
					Canvas.Handle = Dc
					If OnPaint Then OnPaint(This, Canvas)
				End If
				EndPaint Handle,@Ps
				Message.Result = 0
				Canvas.HandleSetted = False
				Return
			Case WM_VSCROLL
				Si.cbSize = SizeOf(Si)
				Si.fMask  = SIF_ALL
				GetScrollInfo (Message.hWnd, SB_VERT, @Si)
				
				ScrollPos = Si.nPos
				
				Select Case LoWord(Message.wParam)
				Case SB_TOP
					Si.nPos = Si.nMin
				Case SB_BOTTOM
					Si.nPos = Si.nMax
				Case SB_LINEUP
					Si.nPos -= 1
				Case SB_LINEDOWN
					Si.nPos += 1
				Case SB_PAGEUP
					Si.nPos -= Si.nPage
				Case SB_PAGEDOWN
					Si.nPos += Si.nPage
				Case SB_THUMBTRACK
					Si.nPos = Si.nTrackPos
				End Select
				
				Si.fMask = SIF_POS
				SetScrollInfo (Message.hWnd, SB_VERT, @Si, True)
				GetScrollInfo (Message.hWnd, SB_VERT, @Si)
				
				If Si.nPos <> ScrollPos Then
					
					ScrollWindow(Message.hWnd, 0, (ScrollPos - Si.nPos), NULL, NULL)
					UpdateWindow (Message.hWnd)
					
					If OnScroll Then OnScroll(This)
					
				End If
			Case WM_HSCROLL
				Si.cbSize = SizeOf(Si)
				Si.fMask  = SIF_ALL
				GetScrollInfo (Message.hWnd, SB_HORZ, @Si)
				
				ScrollPos = Si.nPos
				
				Select Case LoWord(Message.wParam)
				Case SB_LEFT
					Si.nPos = Si.nMin
				Case SB_RIGHT
					Si.nPos = Si.nMax
				Case SB_LINELEFT
					Si.nPos -= 1
				Case SB_LINERIGHT
					Si.nPos += 1
				Case SB_PAGELEFT
					Si.nPos -= Si.nPage
				Case SB_PAGERIGHT
					Si.nPos += Si.nPage
				Case SB_THUMBTRACK
					Si.nPos = Si.nTrackPos
				End Select
				
				Si.fMask = SIF_POS
				SetScrollInfo (Message.hWnd, SB_HORZ, @Si, True)
				GetScrollInfo (Message.hWnd, SB_HORZ, @Si)
				
				If Si.nPos <> ScrollPos Then
					
					ScrollWindow (Message.hWnd, (ScrollPos - Si.nPos), 0, NULL, NULL)
					UpdateWindow (Message.hWnd)
					
					If OnScroll Then OnScroll(This)
					
				End If
			Case WM_SIZE
				SetScrollsInfo
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Operator ScrollableWindow.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Constructor ScrollableWindow
		#ifdef __USE_GTK__
			widget = gtk_scrolled_window_new(NULL, NULL)
			'g_signal_connect(widget, "value-changed", G_CALLBACK(@Range_ValueChanged), @This)
			This.RegisterClass "ScrollableWindow", @This
		#endif
		FTabIndex       = -1
		With This
			.Child      = @This
			#ifndef __USE_GTK__
				.RegisterClass "ScrollableWindow"
				.ChildProc   = @WNDPROC
				.ExStyle     = 0
				Base.Style       = WS_CHILD Or WS_VSCROLL Or WS_HSCROLL
				.OnHandleIsAllocated = @HandleIsAllocated
				.DoubleBuffered = True
			#endif
			WLet(FClassName, "ScrollableWindow")
			.Width      = 121
			.Height     = 41
		End With
	End Constructor
	
	Private Destructor ScrollableWindow
	End Destructor
End Namespace
