'###############################################################################
'#  ScrollControl.bi                                                           #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#include once "ScrollControl.bi"

Namespace My.Sys.Forms
	Private Function ScrollControl.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "tabindex": Return @FTabIndex
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Private Function ScrollControl.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "tabindex": TabIndex = QInteger(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Private Property ScrollControl.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property ScrollControl.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property ScrollControl.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property ScrollControl.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	#ifndef __USE_GTK__
		Private Sub ScrollControl.SetScrollsInfo
			Dim Si As SCROLLINFO
			Dim As Integer MaxWidth, MaxHeight
			
			GetMax MaxWidth, MaxHeight
			
			Si.cbSize = SizeOf(Si)
			Si.fMask  = SIF_ALL
			GetScrollInfo (This.Handle, SB_HORZ, @Si)
			Si.cbSize = SizeOf(Si)
			Si.fMask  = SIF_RANGE Or SIF_PAGE
			Si.nMin   = 0
			Si.nMax   = Max(MaxWidth, IIf(Si.nPos = 0, 0, This.ClientWidth + Si.nPos))
			Si.nPage  = This.ClientWidth
			SetScrollInfo(This.Handle, SB_HORZ, @Si, True)
			
			Si.cbSize = SizeOf(Si)
			Si.fMask  = SIF_ALL
			GetScrollInfo (This.Handle, SB_VERT, @Si)
			Si.cbSize = SizeOf(Si)
			Si.fMask  = SIF_RANGE Or SIF_PAGE
			Si.nMin   = 0
			Si.nMax   = Max(MaxHeight, IIf(Si.nPos = 0, 0, This.ClientHeight + Si.nPos))
			Si.nPage  = This.ClientHeight
			SetScrollInfo(This.Handle, SB_VERT, @Si, True)
		End Sub
		
		Private Sub ScrollControl.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QScrollControl(Sender.Child)
					.SetScrollsInfo
				End With
			End If
		End Sub
		
		Private Sub ScrollControl.WNDPROC(ByRef Message As Message)
		End Sub
	#endif
	
	Sub ScrollControl.GetMax(ByRef MaxWidth As Integer, ByRef MaxHeight As Integer)
		MaxWidth = 0
		MaxHeight = 0
		For i As Integer = 0 To ControlCount - 1
			If Controls[i]->Visible Then 
				If MaxWidth < Controls[i]->Left + Controls[i]->Width Then MaxWidth = Controls[i]->Left + Controls[i]->Width
				If MaxHeight < Controls[i]->Top + Controls[i]->Height Then MaxHeight = Controls[i]->Top + Controls[i]->Height
			End If
		Next
	End Sub
	
	Private Sub ScrollControl.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Static bShifted As Boolean
			Static scrStyle As Integer, scrDirection As Integer
			Dim Si As SCROLLINFO
			Dim As Integer MaxWidth, MaxHeight, ScrollPos
			bShifted = GetKeyState(VK_SHIFT) And 8000
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
			Case WM_MOUSEWHEEL
				#ifdef __FB_64BIT__
					If Message.wParam < 4000000000 Then
						scrDirection = 1
					Else
						scrDirection = -1
					End If
				#else
					scrDirection = Sgn(Message.wParam)
				#endif
				Var scrStyle = IIf(bShifted, SB_HORZ, SB_VERT)
				Var ArrowChangeSize = IIf(bShifted, FHorizontalArrowChangeSize, FVerticalArrowChangeSize)
				Si.cbSize = SizeOf(Si)
				Si.fMask  = SIF_ALL
				GetScrollInfo (Message.hWnd, scrStyle, @Si)
				ScrollPos = Si.nPos
				If scrDirection = -1 Then
					Si.nPos = Min(Si.nPos + ArrowChangeSize, Si.nMax)
				Else
					Si.nPos = Max(Si.nPos - ArrowChangeSize, Si.nMin)
				End If
				Si.fMask = SIF_POS
				SetScrollInfo(Message.hWnd, scrStyle, @Si, True)
				GetScrollInfo (Message.hWnd, scrStyle, @Si)
				
				If Si.nPos <> ScrollPos Then
					If bShifted Then
						ScrollWindow(Message.hWnd, (ScrollPos - Si.nPos), 0, NULL, NULL)
					Else
						ScrollWindow(Message.hWnd, 0, (ScrollPos - Si.nPos), NULL, NULL)
					End If
					If Si.nPos = 0 Then SetScrollsInfo
					UpdateWindow (Message.hWnd)
					
					If OnScroll Then OnScroll(This)
					
				End If
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
					Si.nPos -= FVerticalArrowChangeSize
				Case SB_LINEDOWN
					Si.nPos += FVerticalArrowChangeSize
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
					If Si.nPos = 0 Then SetScrollsInfo
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
					Si.nPos -= FHorizontalArrowChangeSize
				Case SB_LINERIGHT
					Si.nPos += FHorizontalArrowChangeSize
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
					If Si.nPos = 0 Then SetScrollsInfo
					UpdateWindow (Message.hWnd)
					
					If OnScroll Then OnScroll(This)
					
				End If
			Case WM_SIZE
				SetScrollsInfo
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Operator ScrollControl.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Constructor ScrollControl
		#ifdef __USE_GTK__
			widget = gtk_scrolled_window_new(NULL, NULL)
			gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(widget), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
			'g_signal_connect(widget, "value-changed", G_CALLBACK(@Range_ValueChanged), @This)
			This.RegisterClass "ScrollControl", @This
		#endif
		FTabIndex       = -1
		With This
			.Child      = @This
			#ifndef __USE_GTK__
				.RegisterClass "ScrollControl"
				.ChildProc   = @WNDPROC
				.ExStyle     = 0
				Base.Style       = WS_CHILD Or WS_VSCROLL Or WS_HSCROLL
				.BackColor       = GetSysColor(COLOR_BTNFACE)
				FDefaultBackColor = .BackColor
				.OnHandleIsAllocated = @HandleIsAllocated
				.DoubleBuffered = True
			#endif
			WLet(FClassName, "ScrollControl")
			FHorizontalArrowChangeSize = 10
			FVerticalArrowChangeSize = 10
			.Width      = 121
			.Height     = 41
		End With
	End Constructor
	
	Private Destructor ScrollControl
	End Destructor
End Namespace
