'################################################################################
'#  SelectBar.bas                                                               #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Liu XiaLin                                                         #
'#  Based on:                                                                   #
'#   PsSelectBar (Paul Squires, PlanetSquires Software, MPL 2.0)                #
'################################################################################

'#Region "Form"
	#include once "SelectBar.bi"
	#include once "vbcompat.bi"

	Namespace My.Sys.Forms

	Private Function SelectBar.GetWindowsDPI() As Double
		#ifdef __USE_GTK__
			Return 1#
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			Return IIf(ydpi > 0, ydpi, 1#)
		#elseif defined(__USE_WINAPI__)
			Dim hDC As HDC, LPX As Double
			hDC = GetDC(0)
			LPX = CDbl(GetDeviceCaps(hDC, LOGPIXELSX))
			ReleaseDC 0, hDC
			If LPX = 0 Then
				Return 1#
			Else
				Return LPX / 96#
			End If
		#endif
	End Function

	Private Function SelectBar.PanelCount() As Long
		Return UBound(m_Panel) + 1
	End Function

	Private Function SelectBar.IsValidPanel(ByVal idx As Long) As Boolean
		Return idx >= 0 AndAlso idx < PanelCount() AndAlso m_Panel(idx) <> 0
	End Function

	'Measure a label on a PRIVATE canvas: measuring through This.Canvas during
	'an active paint session would clobber the paint device (SetHandle replaces
	'the handle and UnSetHandle closes the session)
	Private Function SelectBar.TextWidthOf(ByRef Value As WString) As Long
		#ifdef __USE_GTK__
			'A Pango layout can be created from any cairo context - a scratch
			'surface measures without a live paint
			Dim cv As My.Sys.Drawing.Canvas
			cv.Ctrl = @This
			cv.Font = This.Font
			Dim As cairo_surface_t Ptr Surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 1, 1)
			Dim As cairo_t Ptr cr = cairo_create(Surface)
			cv.SetHandle(cr)
			Dim As Long Result = cv.TextWidth(Value)
			cv.Handle = 0
			cv.HandleSetted = False
			cairo_destroy(cr)
			cairo_surface_destroy(Surface)
			Return Result
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			Return Canvas.TextWidth(Value)
		#else
			Dim cv As My.Sys.Drawing.Canvas
			cv.Ctrl = @This
			cv.Font = This.Font
			Return cv.TextWidth(Value)
		#endif
	End Function

	Private Function SelectBar.TextHeightOf(ByRef Value As WString) As Long
		#ifdef __USE_GTK__
			Dim cv As My.Sys.Drawing.Canvas
			cv.Ctrl = @This
			cv.Font = This.Font
			Dim As cairo_surface_t Ptr Surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 1, 1)
			Dim As cairo_t Ptr cr = cairo_create(Surface)
			cv.SetHandle(cr)
			Dim As Long Result = cv.TextHeight(Value)
			cv.Handle = 0
			cv.HandleSetted = False
			cairo_destroy(cr)
			cairo_surface_destroy(Surface)
			Return Result
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			Return Canvas.TextHeight(Value)
		#else
			Dim cv As My.Sys.Drawing.Canvas
			cv.Ctrl = @This
			cv.Font = This.Font
			Return cv.TextHeight(Value)
		#endif
	End Function

	'Assign every panel's cell rects. The only place select-bar geometry is
	'produced. Cells run left to right; a run wider than the client just clips
	'at the client edge (rects are computed honestly, never squeezed).
	Private Sub SelectBar.LayoutPanels()
		bLayoutDirty = False

		Dim clientW As Long = ScaleX(This.ClientWidth)
		Dim clientH As Long = ScaleY(This.ClientHeight)
		If clientW <= 0 OrElse clientH <= 0 Then
			bLayoutDirty = True
			Exit Sub
		End If

		Dim nScalePadL As Long = m_PadLeft * nScale
		Dim nScalePadR As Long = m_PadRight * nScale
		Dim nScaleIndH As Long = m_IndicatorHeight * nScale
		Dim nScaleIndGap As Long = m_IndicatorGap * nScale

		Dim x As Long = 0
		Dim i As Long
		For i = 0 To PanelCount() - 1
			With *m_Panel(i)
				Dim padL As Long = IIf(.PadLeft >= 0, .PadLeft * nScale, nScalePadL)
				Dim padR As Long = IIf(.PadRight >= 0, .PadRight * nScale, nScalePadR)
				Dim textW As Long = ScaleX(TextWidthOf(.Text))
				.nCellWidth = padL + textW + padR
				.rc.Left = x
				.rc.Top = 0
				.rc.Right = x + .nCellWidth
				.rc.Bottom = clientH
				.rcText.Left = .rc.Left + padL
				.rcText.Right = .rcText.Left + textW
				'Centre the label vertically on the row, above its indicator slot
				Dim textH As Long = ScaleY(TextHeightOf(.Text))
				.rcText.Top = (clientH - nScaleIndH - nScaleIndGap - textH) \ 2
				If .rcText.Top < 0 Then .rcText.Top = 0
				.rcText.Bottom = .rcText.Top + textH
				.rcIndicator.Left = .rcText.Left
				.rcIndicator.Right = .rcText.Right
				.rcIndicator.Top = .rcText.Bottom + nScaleIndGap
				.rcIndicator.Bottom = .rcIndicator.Top + nScaleIndH
				x = .rc.Right
			End With
		Next
	End Sub

	Private Function SelectBar.HitTest(ByVal x As Long, ByVal y As Long) As Long
		Dim i As Long
		For i = 0 To PanelCount() - 1
			With *m_Panel(i)
				If x >= .rc.Left AndAlso x < .rc.Right AndAlso y >= .rc.Top AndAlso y < .rc.Bottom Then Return i
			End With
		Next
		Return -1
	End Function

	Private Function SelectBar.ARGB(clr As ULong, Opacity As Long = 100) As ULong
		#ifdef __USE_WINAPI__
			Return (Cast(ULong, Opacity / 100 * 255) Shl 24) Or (GetRed(clr) Shl 16) Or (GetGreen(clr) Shl 8) Or GetBlue(clr)
		#else
			Return clr
		#endif
	End Function

	'Fill a rectangle with an exact colour through the Canvas path family. The
	'GDI+ branch of Canvas.Rectangle takes its colour from Canvas.FillColor (and
	'FillOpacity, which defaults to 50) rather than Brush.Color - the path fill
	'is deterministic on every backend instead.
	Private Sub SelectBar.FillRectPath(ByVal x As Long, ByVal y As Long, ByVal w As Long, ByVal h As Long, clr As ULong)
		If w <= 0 OrElse h <= 0 Then Exit Sub
		Canvas.PathStart
		Canvas.PathRoundRect(x, y, w, h, 0)
		Canvas.FillPath(ARGB(clr), 100)
		Canvas.PathDiscard
	End Sub

	Private Sub SelectBar.Draw()
		On Error Goto ErrorHandler

		If bLayoutDirty Then LayoutPanels()

		'---- the background -------------------------------------------------------
		Dim backClr As ULong = m_BackColor
		If backClr = Cast(ULong, -1) Then backClr = clBtnFace
		FillRectPath(0, 0, ScaleX(This.ClientWidth), ScaleY(This.ClientHeight), backClr)

		Canvas.Font = This.Font
		Dim i As Long
		For i = 0 To PanelCount() - 1
			With *m_Panel(i)
				'The cell fill (the hot colour may equal the bar's own: the
				'default look distinguishes the current panel by the line only)
				If CBool(i = m_HotIdx) AndAlso CBool(i <> m_CurSel) AndAlso CBool(.isEnabled) AndAlso CBool(This.Enabled) Then
					FillRectPath(.rc.Left, .rc.Top, .rc.Right - .rc.Left, .rc.Bottom - .rc.Top, m_BackColorHot)
				ElseIf i = m_CurSel Then
					FillRectPath(.rc.Left, .rc.Top, .rc.Right - .rc.Left, .rc.Bottom - .rc.Top, m_BackColorSelect)
				End If

				'The label
				Dim clrText As ULong = m_ForeColor
				If .isEnabled = False OrElse This.Enabled = False Then
					clrText = m_ForeColorDisabled
				ElseIf i = m_CurSel Then
					clrText = m_ForeColorSelect
				ElseIf i = m_HotIdx Then
					clrText = m_ForeColorHot
				End If
				Canvas.TextOut(.rcText.Left, .rcText.Top, .Text, clrText, -1)

				'The line under the current panel
				If CBool(i = m_CurSel) AndAlso CBool(.isEnabled) AndAlso CBool(This.Enabled) Then
					FillRectPath(.rcIndicator.Left, .rcIndicator.Top, .rcIndicator.Right - .rcIndicator.Left, .rcIndicator.Bottom - .rcIndicator.Top, m_IndicatorColor)
				End If
			End With
		Next

		Exit Sub
		ErrorHandler:
		MsgBox ErrDescription(Err) & " (" & Err & ") " & _
		"in line " & Erl() & " (Handler line: " & __LINE__ & ") " & _
		"in function " & ZGet(Erfn()) & " (Handler function: " & __FUNCTION__ & ") " & _
		"in module " & ZGet(Ermn()) & " (Handler file: " & __FILE__ & ") "
	End Sub

	'== Interaction =========================================================================

	Private Sub SelectBar.SetHot(ByVal idx As Long)
		If idx <> m_HotIdx Then
			m_HotIdx = idx
			Refresh
		End If
	End Sub

	Private Sub SelectBar.SelectPanel(ByVal idx As Long)
		'A click selects; disabled panels swallow clicks
		If IsValidPanel(idx) = False Then Exit Sub
		If m_Panel(idx)->isEnabled = False Then Exit Sub
		If idx <> m_CurSel Then
			m_CurSel = idx
			bLayoutDirty = True
			Refresh
			If OnSelect Then OnSelect(*Designer, This, idx)
		End If
	End Sub

	Private Sub SelectBar.CancelPress()
		m_PressedIdx = -1
	End Sub

	Private Sub SelectBar.Refresh()
		bLayoutDirty = True
		#ifdef __USE_GTK__
			If GTK_IS_WIDGET(widget) Then gtk_widget_queue_draw(widget)
		#elseif defined(__USE_WINAPI__)
			If FHandle Then
				InvalidateRect(FHandle, NULL, TRUE)
				UpdateWindow FHandle
			End If
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			Repaint
		#endif
	End Sub

	Private Sub SelectBar.tmrHotTrack_Timer_(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent)
		QSelectBar(Sender.Designer).tmrHotTrack_Timer(Sender)
	End Sub

	Private Sub SelectBar.tmrHotTrack_Timer(ByRef Sender As TimerComponent)
		#ifdef __USE_WINAPI__
			If FHandle = 0 Then Exit Sub
			Dim pt As POINT
			GetCursorPos(@pt)
			'the raw API: Control.ScreenToClient (MFF Point) shadows the name here
			..ScreenToClient(FHandle, @pt)
			Dim idx As Long = HitTest(pt.x, pt.y)
			SetHot(idx)
		#endif
	End Sub

	Private Sub SelectBar.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_WINAPI__
			Select Case Message.Msg
			Case WM_ERASEBKGND
				Message.Result = 0
				Exit Sub
			Case WM_PAINT
				Dim ps As PAINTSTRUCT
				Dim Dc As HDC
				Dim As HBITMAP bufBMP
				Dim As Integer mClientWidth = ScaleX(This.ClientWidth), mClientHeight = ScaleY(This.ClientHeight)
				Dc = BeginPaint(This.Handle, @ps)
				If mClientWidth > 0 AndAlso mClientHeight > 0 Then
					Dim hdBuf As HDC = CreateCompatibleDC(Dc)
					bufBMP = CreateCompatibleBitmap(Dc, mClientWidth, mClientHeight)
					SelectObject(hdBuf, bufBMP)
					Canvas.SetHandle(hdBuf)
					Draw()
					Canvas.UnSetHandle
					BitBlt(Dc, 0, 0, mClientWidth, mClientHeight, hdBuf, 0, 0, SRCCOPY)
					DeleteDC hdBuf
					DeleteObject bufBMP
				End If
				EndPaint(This.Handle, @ps)
				Message.Result = 0
				Exit Sub
			Case WM_SIZE
				bLayoutDirty = True
			Case WM_LBUTTONDOWN
				Dim idx As Long = HitTest(Message.lParamLo, Message.lParamHi)
				m_PressedIdx = idx
				SetCapture(FHandle)
				SetHot(idx)
			Case WM_MOUSEMOVE
				Dim idx As Long = HitTest(Message.lParamLo, Message.lParamHi)
				SetHot(idx)
			Case WM_LBUTTONUP
				Dim idx As Long = HitTest(Message.lParamLo, Message.lParamHi)
				Dim bWasPressed As Boolean = (m_PressedIdx = idx AndAlso idx >= 0)
				If GetCapture = FHandle Then ReleaseCapture
				CancelPress
				If bWasPressed Then SelectPanel(idx)
			Case WM_CAPTURECHANGED
				CancelPress
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub

	#ifdef __USE_GTK__
		Private Function SelectBar.OnDraw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As gpointer) As Boolean
			Dim As SelectBar Ptr p = Cast(Any Ptr, data1)
			p->Canvas.HandleSetted = True
			p->Canvas.Handle = cr
			If p->nScale = 0 Then p->nScale = p->GetWindowsDPI()
			p->Draw()
			p->Canvas.Handle = 0
			p->Canvas.HandleSetted = False
			Return False
		End Function

		Private Sub SelectBar.GTK_MouseDown(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, X As Integer, Y As Integer, Shift As Integer)
			Dim As SelectBar Ptr p = Cast(SelectBar Ptr, @Sender)
			p->m_PressedIdx = p->HitTest(X, Y)
			p->SetHot(p->m_PressedIdx)
		End Sub

		Private Sub SelectBar.GTK_MouseMove(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, X As Integer, Y As Integer, Shift As Integer)
			Dim As SelectBar Ptr p = Cast(SelectBar Ptr, @Sender)
			p->SetHot(p->HitTest(X, Y))
		End Sub

		Private Sub SelectBar.GTK_MouseUp(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, X As Integer, Y As Integer, Shift As Integer)
			Dim As SelectBar Ptr p = Cast(SelectBar Ptr, @Sender)
			Dim idx As Long = p->HitTest(X, Y)
			Dim bWasPressed As Boolean = (p->m_PressedIdx = idx AndAlso idx >= 0)
			p->CancelPress
			If bWasPressed Then p->SelectPanel(idx)
		End Sub
	#endif

	Private Sub SelectBar.InitProperties()
		With This
			WLet(FClassName, "SelectBar")
			#ifdef __USE_WINAPI__
				.Style = WS_CHILD
				.ExStyle = 0
				.RegisterClass "SelectBar", ""
				.ChildProc = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#elseif defined(__USE_GTK__)
				widget = gtk_layout_new(NULL, NULL)
				.RegisterClass "SelectBar", @This
				gtk_widget_set_events(widget, _
				GDK_EXPOSURE_MASK Or _
				GDK_STRUCTURE_MASK Or _
				GDK_BUTTON_PRESS_MASK Or _
				GDK_BUTTON_RELEASE_MASK Or _
				GDK_POINTER_MOTION_MASK)
				#ifdef __USE_GTK4__
					mff_widget_set_draw_func(widget, Cast(Any Ptr, @OnDraw), @This)
				#else
					#ifndef __USE_GTK2__
						g_signal_connect(widget, "draw", G_CALLBACK(@OnDraw), @This)
					#endif
				#endif
				.OnMouseDown = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, X As Integer, Y As Integer, Shift As Integer), @GTK_MouseDown)
				.OnMouseMove = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, X As Integer, Y As Integer, Shift As Integer), @GTK_MouseMove)
				.OnMouseUp = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, X As Integer, Y As Integer, Shift As Integer), @GTK_MouseUp)
			#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.Width = 200
			.Height = 28
			.Child = @This
			.Canvas.Ctrl = @This
			#ifdef __USE_WINAPI__
				.Canvas.UsingGdip = True
			#endif
			.BackColor = m_BackColor
		End With
		tmrHotTrack.Designer = @This
		tmrHotTrack.Interval = 0
		tmrHotTrack.OnTimer = @tmrHotTrack_Timer_
		tmrHotTrack.Enabled = True
	End Sub

	#ifdef __USE_WINAPI__
		Private Sub SelectBar.WndProc(ByRef Message As Message)
		End Sub

		Private Sub SelectBar.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			With QSelectBar(@Sender)
				.nScale = .GetWindowsDPI()
				.bLayoutDirty = True
				.tmrHotTrack.Interval = SELECTBAR_HOTTRACK_MS
			End With
		End Sub
	#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
		Private Sub SelectBar.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			With QSelectBar(@Sender)
				.nScale = .GetWindowsDPI()
				.bLayoutDirty = True
			End With
		End Sub
	#endif

	Private Constructor SelectBar
		InitProperties()
	End Constructor

	Private Destructor SelectBar
		tmrHotTrack.Interval = 0
		tmrHotTrack.Enabled = False
		Clear()
	End Destructor

	'== Panels ==============================================================================

	Private Sub SelectBar.Clear()
		Dim i As Long
		For i = 0 To PanelCount() - 1
			If m_Panel(i) <> 0 Then Delete m_Panel(i)
			m_Panel(i) = 0
		Next
		Erase m_Panel
		m_CurSel = -1
		m_HotIdx = -1
		m_PressedIdx = -1
		bLayoutDirty = True
		Refresh
	End Sub

	Private Function SelectBar.AddPanel(ByRef Text As WString, ByVal id As Long = 0, ByVal ItemData As Integer = 0) As Long
		Dim p As SelectBarPanel Ptr = _New(SelectBarPanel)
		If p = 0 Then Return -1
		ReDim Preserve m_Panel(PanelCount())
		m_Panel(PanelCount() - 1) = p
		p->Text = Text
		p->id = id
		p->ItemData = ItemData
		bLayoutDirty = True
		Refresh
		Return PanelCount() - 1
	End Function

	Private Function SelectBar.GetCount As Long
		Return PanelCount()
	End Function

	Private Function SelectBar.GetPanelRect(ByVal idx As Long, ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		If IsValidPanel(idx) = False Then Return False
		If bLayoutDirty Then LayoutPanels()
		rcLeft = m_Panel(idx)->rc.Left: rcTop = m_Panel(idx)->rc.Top
		rcRight = m_Panel(idx)->rc.Right: rcBottom = m_Panel(idx)->rc.Bottom
		Return rcRight > rcLeft
	End Function

	Private Function SelectBar.GetTextRect(ByVal idx As Long, ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		If IsValidPanel(idx) = False Then Return False
		If bLayoutDirty Then LayoutPanels()
		rcLeft = m_Panel(idx)->rcText.Left: rcTop = m_Panel(idx)->rcText.Top
		rcRight = m_Panel(idx)->rcText.Right: rcBottom = m_Panel(idx)->rcText.Bottom
		Return rcRight > rcLeft
	End Function

	Private Function SelectBar.GetIndicatorRect(ByVal idx As Long, ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		If IsValidPanel(idx) = False Then Return False
		If bLayoutDirty Then LayoutPanels()
		rcLeft = m_Panel(idx)->rcIndicator.Left: rcTop = m_Panel(idx)->rcIndicator.Top
		rcRight = m_Panel(idx)->rcIndicator.Right: rcBottom = m_Panel(idx)->rcIndicator.Bottom
		Return rcRight > rcLeft
	End Function

	Private Function SelectBar.GetText(ByVal idx As Long) As UString
		If IsValidPanel(idx) = False Then Return ""
		Return m_Panel(idx)->Text
	End Function

	Private Function SelectBar.SetText(ByVal idx As Long, ByRef Text As WString) As Boolean
		If IsValidPanel(idx) = False Then Return False
		m_Panel(idx)->Text = Text
		bLayoutDirty = True
		Refresh
		Return True
	End Function

	Private Function SelectBar.GetPanelID(ByVal idx As Long) As Long
		If IsValidPanel(idx) = False Then Return 0
		Return m_Panel(idx)->id
	End Function

	Private Function SelectBar.SetPanelID(ByVal idx As Long, ByVal id As Long) As Boolean
		If IsValidPanel(idx) = False Then Return False
		m_Panel(idx)->id = id
		Return True
	End Function

	Private Function SelectBar.GetItemData(ByVal idx As Long) As Integer
		If IsValidPanel(idx) = False Then Return 0
		Return m_Panel(idx)->ItemData
	End Function

	Private Function SelectBar.SetItemData(ByVal idx As Long, ByVal ItemData As Integer) As Boolean
		If IsValidPanel(idx) = False Then Return False
		m_Panel(idx)->ItemData = ItemData
		Return True
	End Function

	Private Function SelectBar.GetEnabled(ByVal idx As Long) As Boolean
		If IsValidPanel(idx) = False Then Return False
		Return m_Panel(idx)->isEnabled
	End Function

	Private Function SelectBar.SetEnabled(ByVal idx As Long, ByVal isEnabled As Boolean) As Boolean
		If IsValidPanel(idx) = False Then Return False
		m_Panel(idx)->isEnabled = isEnabled
		Refresh
		Return True
	End Function

	Private Property SelectBar.CurSel As Long
		Return m_CurSel
	End Property

	Private Property SelectBar.CurSel(Value As Long)
		'Silent: only a click raises OnSelect
		If Value < -1 OrElse Value >= PanelCount() Then Exit Property
		m_CurSel = Value
		bLayoutDirty = True
		Refresh
	End Property

	Private Property SelectBar.PadLeft As Long
		Return m_PadLeft
	End Property

	Private Property SelectBar.PadLeft(Value As Long)
		m_PadLeft = Max(0, Value)
		bLayoutDirty = True
		Refresh
	End Property

	Private Property SelectBar.PadRight As Long
		Return m_PadRight
	End Property

	Private Property SelectBar.PadRight(Value As Long)
		m_PadRight = Max(0, Value)
		bLayoutDirty = True
		Refresh
	End Property

	Private Property SelectBar.IndicatorHeight As Long
		Return m_IndicatorHeight
	End Property

	Private Property SelectBar.IndicatorHeight(Value As Long)
		m_IndicatorHeight = Max(1, Value)
		bLayoutDirty = True
		Refresh
	End Property

	Private Property SelectBar.IndicatorGap As Long
		Return m_IndicatorGap
	End Property

	Private Property SelectBar.IndicatorGap(Value As Long)
		m_IndicatorGap = Max(0, Value)
		bLayoutDirty = True
		Refresh
	End Property

	Private Property SelectBar.BarBackColor As ULong
		Return m_BackColor
	End Property

	Private Property SelectBar.BarBackColor(Value As ULong)
		m_BackColor = Value
		Refresh
	End Property

	Private Property SelectBar.BarForeColor As ULong
		Return m_ForeColor
	End Property

	Private Property SelectBar.BarForeColor(Value As ULong)
		m_ForeColor = Value
		Refresh
	End Property

	Private Property SelectBar.BarBackColorHot As ULong
		Return m_BackColorHot
	End Property

	Private Property SelectBar.BarBackColorHot(Value As ULong)
		m_BackColorHot = Value
		Refresh
	End Property

	Private Property SelectBar.BarForeColorHot As ULong
		Return m_ForeColorHot
	End Property

	Private Property SelectBar.BarForeColorHot(Value As ULong)
		m_ForeColorHot = Value
		Refresh
	End Property

	Private Property SelectBar.BarBackColorSelect As ULong
		Return m_BackColorSelect
	End Property

	Private Property SelectBar.BarBackColorSelect(Value As ULong)
		m_BackColorSelect = Value
		Refresh
	End Property

	Private Property SelectBar.BarForeColorSelect As ULong
		Return m_ForeColorSelect
	End Property

	Private Property SelectBar.BarForeColorSelect(Value As ULong)
		m_ForeColorSelect = Value
		Refresh
	End Property

	Private Property SelectBar.BarForeColorDisabled As ULong
		Return m_ForeColorDisabled
	End Property

	Private Property SelectBar.BarForeColorDisabled(Value As ULong)
		m_ForeColorDisabled = Value
		Refresh
	End Property

	Private Property SelectBar.IndicatorColor As ULong
		Return m_IndicatorColor
	End Property

	Private Property SelectBar.IndicatorColor(Value As ULong)
		m_IndicatorColor = Value
		Refresh
	End Property

	#ifndef ReadProperty_Off
		Private Function SelectBar.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case PropertyName
			Case "CurSel": Return @m_CurSel
			End Select
			Return Base.ReadProperty(PropertyName)
		End Function
	#endif

	#ifndef WriteProperty_Off
		Private Function SelectBar.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			Select Case PropertyName
			Case "CurSel": CurSel = QInteger(Value): Return True
			End Select
			Return Base.WriteProperty(PropertyName, Value)
		End Function
	#endif

	Private Operator SelectBar.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator

	End Namespace
'#End Region
