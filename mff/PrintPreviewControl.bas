'###############################################################################
'#  PrintPreviewControl.bas                                                           #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#include once "PrintPreviewControl.bi"

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function PrintPreviewControl.ReadProperty(PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "tabindex": Return @FTabIndex
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function PrintPreviewControl.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "tabindex": TabIndex = QInteger(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	
	Private Property PrintPreviewControl.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property PrintPreviewControl.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property PrintPreviewControl.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property PrintPreviewControl.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Property PrintPreviewControl.Orientation As PrinterOrientation
		Return FOrientation
	End Property
	
	Private Property PrintPreviewControl.Orientation(Value As PrinterOrientation)
		FOrientation = Value
		Document->PrinterSettings.Orientation = FOrientation
		Document->Repaint
		SetScrollsInfo
		Repaint
	End Property
	
	Private Property PrintPreviewControl.PageLength As Integer
		Return FPageLength
	End Property
	
	Private Property PrintPreviewControl.PageLength(Value As Integer)
		FPageLength = Value
		Document->Repaint
		SetScrollsInfo
		Repaint
	End Property
	
	Private Property PrintPreviewControl.PageWidth As Integer
		Return FPageWidth
	End Property
	
	Private Property PrintPreviewControl.PageWidth(Value As Integer)
		FPageWidth = Value
		Document->Repaint
		SetScrollsInfo
		Repaint
	End Property
	
	Private Property PrintPreviewControl.CurrentPage As Integer
		Return FCurrentPage
	End Property
	
	Private Property PrintPreviewControl.CurrentPage(Value As Integer)
		FCurrentPage = Value
		SetScrollsInfo
		Repaint
	End Property
	
	Private Property PrintPreviewControl.Zoom As Integer
		Return FZoom
	End Property
	
	Private Property PrintPreviewControl.Zoom(Value As Integer)
		FZoom = Value
		SetScrollsInfo
		Repaint
	End Property
	
	#ifndef __USE_GTK__
		Private Sub PrintPreviewControl.SetScrollsInfo
			Dim Si As SCROLLINFO
			Dim As Integer MaxWidth, MaxHeight
			
			Dim As Integer iPageWidth = Document->PrinterSettings.PrintableWidth
			Dim As Integer iPageHeight = Document->PrinterSettings.PrintableHeight
			Dim As Integer iWidth = iPageWidth * FZoom / 100
			Dim As Integer iHeight = iPageHeight * FZoom / 100
			Dim As Integer iLeft = (Canvas.Width - iWidth) / 2, iTop = 10
			
			MaxWidth = iWidth + 20
			MaxHeight = iHeight + 20
			
			Si.cbSize = SizeOf(Si)
			Si.fMask  = SIF_ALL
			GetScrollInfo (This.Handle, SB_HORZ, @Si)
			Si.cbSize = SizeOf(Si)
			Si.fMask  = SIF_RANGE Or SIF_PAGE Or SIF_POS
			Si.nPos   = Max(0, (MaxWidth - This.ClientWidth) / 2)
			Si.nMin   = 0
			Si.nMax   = MaxWidth - 1
			Si.nPage  = This.ClientWidth
			SetScrollInfo(This.Handle, SB_HORZ, @Si, True)
			
			Si.cbSize = SizeOf(Si)
			Si.fMask  = SIF_ALL
			GetScrollInfo (This.Handle, SB_VERT, @Si)
			Si.cbSize = SizeOf(Si)
			Si.fMask  = SIF_RANGE Or SIF_PAGE Or SIF_POS
			Si.nMin   = 0
			Si.nMax   = MaxHeight - 1
			Si.nPos   = Min(Si.nPos, Si.nMax)
			Si.nPage  = This.ClientHeight
			SetScrollInfo(This.Handle, SB_VERT, @Si, True)
		End Sub
		
		Private Sub PrintPreviewControl.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QPrintPreviewControl(Sender.Child)
					.SetScrollsInfo
				End With
			End If
		End Sub
		
		Private Sub PrintPreviewControl.WNDPROC(ByRef Message As Message)
		End Sub
		
		Private Sub PrintPreviewControl.PaintControl
			If Document->Pages.Count = 0 Then Document->Repaint
			
			Dim As ENHMETAHEADER emh
			Dim As Double MillimetersPerPixelsX, MillimetersPerPixelsY
			Dim As Rect rc
			
			FCurrentPage = Max(1, Min(FCurrentPage, Document->Pages.Count))
			
			Dim Si As SCROLLINFO
			Dim As Integer HScrollPos, VScrollPos
			
			Si.cbSize = SizeOf(Si)
			Si.fMask  = SIF_ALL
			GetScrollInfo(FHandle, SB_HORZ, @Si)
			HScrollPos = Si.nPos
			GetScrollInfo(FHandle, SB_VERT, @Si)
			VScrollPos = Si.nPos
			
			MillimetersPerPixelsX = GetDeviceCaps(Canvas.Handle, HORZRES) / GetDeviceCaps(Canvas.Handle, HORZSIZE) / 100
			MillimetersPerPixelsY = GetDeviceCaps(Canvas.Handle, VERTRES) / GetDeviceCaps(Canvas.Handle, VERTSIZE) / 100
			
			Dim As Integer iPageWidth = Document->PrinterSettings.PrintableWidth
			Dim As Integer iPageHeight = Document->PrinterSettings.PrintableHeight
			Dim As Integer iWidth = iPageWidth * FZoom / 100
			Dim As Integer iHeight = iPageHeight * FZoom / 100
			
			Dim As Integer iLeft = IIf(iWidth - Canvas.Width > 0, 10 - HScrollPos, (Canvas.Width - iWidth) / 2), iTop = 10 - VScrollPos
			
			GetEnhMetaFileHeader(Document->Pages.Item(FCurrentPage - 1)->Handle, SizeOf(emh), @emh)
			
			rc.Left   = emh.rclFrame.left * MillimetersPerPixelsX
			rc.Right  = rc.Left + (emh.rclFrame.right - emh.rclFrame.left) * MillimetersPerPixelsX
			rc.Top    = emh.rclFrame.top * MillimetersPerPixelsX
			rc.Bottom = rc.Top + (emh.rclFrame.bottom - emh.rclFrame.top) * MillimetersPerPixelsX
			
			Dim As HDC hdcDesktop, memDC
			Dim As HBITMAP Bmp, BmpOld
			Dim As Rect rcPage, rcClient
			Dim As Long nLeft, nTop, cxPage, cyPage
			
			rcPage.Left   = 0
			rcPage.Top    = 0
			rcPage.Right  = iPageWidth
			rcPage.Bottom = iPageHeight
			
			hdcDesktop = GetDC(0)
			memDC      = CreateCompatibleDC(0)
			Bmp        = CreateCompatibleBitmap(hdcDesktop, iPageWidth, iPageHeight)
			BmpOld     = SelectObject(memDC, Bmp)
			
			SelectObject(memDC, GetStockObject(WHITE_BRUSH))
			PatBlt(memDC, 0, 0, iPageWidth, iPageHeight, PATCOPY)
			
			Canvas.Rectangle iLeft, iTop, iLeft + iWidth, iTop + iHeight
			PlayEnhMetaFile(memDC, Document->Pages.Item(FCurrentPage - 1)->Handle, @rc)
			StretchBlt(Canvas.Handle, iLeft + 1, iTop + 1, iWidth - 2, iHeight - 2, memDC, 0, 0, iPageWidth, iPageHeight, SRCCOPY)
			
		End Sub
	#endif
	
	Private Sub PrintPreviewControl.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Static bShifted As Boolean, bCtrl As Boolean
			Static scrStyle As Integer, scrDirection As Integer
			Dim Si As SCROLLINFO
			Dim As Integer MaxWidth, MaxHeight, ScrollPos
			bShifted = GetKeyState(VK_SHIFT) And 8000
			bCtrl = GetKeyState(VK_CONTROL) And 8000
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
					FillRect memDC, @Ps.rcPaint, Brush.Handle
					Canvas.Handle = memDC
					PaintControl
					If OnPaint Then OnPaint(*Designer, This, Canvas)
					BitBlt(Dc, 0, 0, Ps.rcPaint.Right, Ps.rcPaint.Bottom, memDC, 0, 0, SRCCOPY)
					DeleteObject(Bmp)
					DeleteDC(memDC)
				Else
					FillRect Dc, @Ps.rcPaint, Brush.Handle
					Canvas.Handle = Dc
					PaintControl
					If OnPaint Then OnPaint(*Designer, This, Canvas)
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
				Dim As Integer iPageHeight = Document->PrinterSettings.PrintableHeight
				Dim As Integer iHeight = iPageHeight * FZoom / 100 + 20
				If bCtrl Then
					Dim As Integer OldZoom = FZoom
					FZoom = Min(500, Max(10, FZoom + scrDirection))
					If OldZoom <> FZoom Then
						If OnZoom Then OnZoom(*Designer, This)
						Repaint
					End If
				ElseIf This.ClientHeight > iHeight Then
					Dim As Integer OldCurrentPage = FCurrentPage
					FCurrentPage = Min(Document->Pages.Count, Max(1, FCurrentPage - scrDirection))
					If OldCurrentPage <> FCurrentPage Then
						If OnCurrentPageChanged Then OnCurrentPageChanged(*Designer, This)
						Repaint
					End If
				Else
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
						'If bShifted Then
						'	ScrollWindow(Message.hWnd, (ScrollPos - Si.nPos), 0, NULL, NULL)
						'Else
						'	ScrollWindow(Message.hWnd, 0, (ScrollPos - Si.nPos), NULL, NULL)
						'End If
						'If Si.nPos = 0 Then SetScrollsInfo
						'UpdateWindow (Message.hWnd)
						
						If OnScroll Then OnScroll(*Designer, This)
						
						Repaint
						
					End If
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
					
					'ScrollWindow(Message.hWnd, 0, (ScrollPos - Si.nPos), NULL, NULL)
					'If Si.nPos = 0 Then SetScrollsInfo
					'UpdateWindow (Message.hWnd)
					
					'If Si.nPos > Si.nMax - ClientHeight AndAlso FCurrentPage < Document->Pages.Count Then
					'	FCurrentPage += 1
					'	Si.nPos = 0
					'	If OnCurrentPageChanged Then OnCurrentPageChanged(*Designer, This)
					'ElseIf Si.nPos < Si.nMax AndAlso FCurrentPage > 1 Then
					'	FCurrentPage -= 1
					'	Si.nPos = Si.nMax - ClientHeight
					'	If OnCurrentPageChanged Then OnCurrentPageChanged(*Designer, This)
					'End If
					
					If OnScroll Then OnScroll(*Designer, This)
					
					Repaint
					
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
					
					'ScrollWindow (Message.hWnd, (ScrollPos - Si.nPos), 0, NULL, NULL)
					'If Si.nPos = 0 Then SetScrollsInfo
					'UpdateWindow (Message.hWnd)
					
					If OnScroll Then OnScroll(*Designer, This)
					
					Repaint
					
				End If
			Case WM_SIZE
				SetScrollsInfo
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Operator PrintPreviewControl.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Constructor PrintPreviewControl
		#ifdef __USE_GTK__
			widget = gtk_scrolled_window_new(NULL, NULL)
			gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(widget), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
			'g_signal_connect(widget, "value-changed", G_CALLBACK(@Range_ValueChanged), @This)
			This.RegisterClass "PrintPreviewControl", @This
		#endif
		FTabIndex       = -1
		Canvas.Ctrl = @This
		Document = @DefaultDocument
		FOrientation = PrinterOrientation.poPortait
		'Dim As UString DefaultPrinter = Document.PrinterSettings.GetDefaultPrinterDriver
		'If DefaultPrinter > "" Then
		'	This.PrinterName = DefaultPrinter
		'	' Set the default values for the printer
		'	This.Copies = 1
		'	This.Orientation = DMORIENT_PORTRAIT
		'	This.PaperWidth = 8.5
		'	This.PaperHeight = 11
		'End If
		With This
			.Child      = @This
			#ifndef __USE_GTK__
				.RegisterClass "PrintPreviewControl"
				.ChildProc   = @WNDPROC
				.ExStyle     = 0
				Base.Style       = WS_CHILD Or WS_VSCROLL Or WS_HSCROLL
				.BackColor       = GetSysColor(COLOR_BTNFACE)
				FDefaultBackColor = .BackColor
				.OnHandleIsAllocated = @HandleIsAllocated
				.DoubleBuffered = True
			#endif
			WLet(FClassName, "PrintPreviewControl")
			FHorizontalArrowChangeSize = 10
			FVerticalArrowChangeSize = 10
			FCurrentPage = 1
			.Width      = 121
			.Height     = 41
		End With
	End Constructor
	
	Private Destructor PrintPreviewControl
	End Destructor
End Namespace
