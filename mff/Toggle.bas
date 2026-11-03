'################################################################################
'#  Toggle.bas                                                                  #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Liu XiaLin                                                         #
'#  Based on:                                                                   #
'#   PsToggle (Paul Squires, PlanetSquires Software, MPL 2.0)                   #
'################################################################################

'#Region "Form"
	#include once "Toggle.bi"
	#include once "vbcompat.bi"

	Namespace My.Sys.Forms

	Private Function Toggle.GetWindowsDPI() As Double
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

	'== Geometry ============================================================================

	Private Function Toggle.RingPad() As Long
		'The focus ring is drawn inside this band, so it is reserved whether or
		'not the control currently has focus - the pill never jumps when focus
		'arrives
		Return m_FocusGap * nScale + m_FocusThickness
	End Function

	Private Function Toggle.KnobDiameter() As Long
		'The knob is a circle inset from the track on all four sides, so its
		'diameter follows the track HEIGHT and the inset; clamped at 1
		Dim dia As Long = m_TrackHeight * nScale - 2 * m_KnobInset * nScale
		If dia < 1 Then dia = 1
		Return dia
	End Function

	'Assign the three rects. The only place toggle geometry is produced.
	'  rcTrack: the pill, always vertically centred
	'  rcKnob : the circle at the end the checked state calls for
	'  rcVisual: rcTrack inflated by the focus-ring padding
	Private Sub Toggle.LayoutToggle()
		bLayoutDirty = False
		#ifdef __USE_WINAPI__
			If FHandle = 0 Then Exit Sub
		#elseif defined(__USE_GTK__)
			If widget = 0 Then Exit Sub
		#endif

		Dim clientW As Long = ScaleX(This.ClientWidth)
		Dim clientH As Long = ScaleY(This.ClientHeight)

		'No geometry yet (created 0x0, sized only once the host shows us)
		If clientW <= 0 OrElse clientH <= 0 Then
			bLayoutDirty = True
			Exit Sub
		End If

		Dim nRingPad As Long = RingPad()
		Dim knobDia As Long = KnobDiameter()
		Dim trackW As Long = m_TrackWidth * nScale
		Dim trackH As Long = m_TrackHeight * nScale
		Dim nInset As Long = m_KnobInset * nScale
		Dim visualW As Long = trackW + 2 * nRingPad

		'tjLeft, which is also the overflow fallback
		Dim x As Long = nRingPad
		If visualW < clientW Then
			Select Case m_Justify
			Case tjCenter
				x = (clientW - trackW) \ 2
			Case tjRight
				x = clientW - nRingPad - trackW
			End Select
		End If
		Dim y As Long = (clientH - trackH) \ 2

		rcTrack.Left = x: rcTrack.Top = y: rcTrack.Right = x + trackW: rcTrack.Bottom = y + trackH

		Dim knobX As Long = rcTrack.Left + nInset
		If isChecked Then knobX = rcTrack.Right - nInset - knobDia
		Dim knobY As Long = rcTrack.Top + nInset
		rcKnob.Left = knobX: rcKnob.Top = knobY: rcKnob.Right = knobX + knobDia: rcKnob.Bottom = knobY + knobDia

		rcVisual.Left = rcTrack.Left - nRingPad
		rcVisual.Top = rcTrack.Top - nRingPad
		rcVisual.Right = rcTrack.Right + nRingPad
		rcVisual.Bottom = rcTrack.Bottom + nRingPad
	End Sub

	'== Painting ============================================================================

	Private Function Toggle.ARGB(clr As ULong, Opacity As Long = 100) As ULong
		#ifdef __USE_WINAPI__
			Return (Cast(ULong, Opacity / 100 * 255) Shl 24) Or (GetRed(clr) Shl 16) Or (GetGreen(clr) Shl 8) Or GetBlue(clr)
		#else
			Return clr
		#endif
	End Function

	'Resolve the track/border/knob colour triple from state: checked x hot x
	'enabled (a live press renders as hot - there are no pressed colours)
	Private Sub Toggle.TrackColors(ByRef clrTrack As ULong, ByRef clrBorder As ULong, ByRef clrKnob As ULong)
		If This.Enabled = False Then
			If isChecked Then
				clrTrack = m_TrackColorOnDisabled
				clrBorder = m_TrackBorderColorOnDisabled
				clrKnob = m_KnobColorOnDisabled
			Else
				clrTrack = m_TrackColorOffDisabled
				clrBorder = m_TrackBorderColorOffDisabled
				clrKnob = m_KnobColorOffDisabled
			End If
		ElseIf isHot Then
			If isChecked Then
				clrTrack = m_TrackColorOnHot
				clrBorder = m_TrackBorderColorOnHot
				clrKnob = m_KnobColorOnHot
			Else
				clrTrack = m_TrackColorOffHot
				clrBorder = m_TrackBorderColorOffHot
				clrKnob = m_KnobColorOffHot
			End If
		Else
			If isChecked Then
				clrTrack = m_TrackColorOn
				clrBorder = m_TrackBorderColorOn
				clrKnob = m_KnobColorOn
			Else
				clrTrack = m_TrackColorOff
				clrBorder = m_TrackBorderColorOff
				clrKnob = m_KnobColorOff
			End If
		End If
	End Sub

	Private Sub Toggle.Draw()
		On Error Goto ErrorHandler

		If bLayoutDirty Then LayoutToggle()

		'---- the background -------------------------------------------------------
		'A path fill, not Canvas.Rectangle: the GDI+ branch of Rectangle takes
		'its colour from Canvas.FillColor/FillOpacity rather than Brush.Color
		Dim backClr As ULong = This.BackColor
		If backClr = Cast(ULong, -1) Then backClr = clBtnFace
		Canvas.PathStart
		Canvas.PathRoundRect(0, 0, ScaleX(This.ClientWidth), ScaleY(This.ClientHeight), 0)
		Canvas.FillPath(ARGB(backClr), 100)
		Canvas.PathDiscard

		Dim clrTrack As ULong, clrBorder As ULong, clrKnob As ULong
		TrackColors(clrTrack, clrBorder, clrKnob)

		Dim trackW As Long = rcTrack.Right - rcTrack.Left
		Dim trackH As Long = rcTrack.Bottom - rcTrack.Top
		Dim knobDia As Long = rcKnob.Right - rcKnob.Left
		If trackW <= 0 OrElse trackH <= 0 Then Exit Sub

		'---- the focus ring (inside the reserved band) -----------------------------
		If isFocused AndAlso This.Enabled Then
			Dim ringPadGap As Long = m_FocusGap * nScale
			Dim ringThick As Long = m_FocusThickness
			Canvas.PathStart
			Canvas.PathRoundRect(rcTrack.Left - ringPadGap, rcTrack.Top - ringPadGap, trackW + ringPadGap * 2, trackH + ringPadGap * 2, (trackH + ringPadGap * 2) / 2)
			Canvas.StrokePath(ARGB(m_FocusRingColor), ringThick, 100)
			Canvas.PathDiscard
		End If

		'---- the pill ---------------------------------------------------------------
		Canvas.PathStart
		Canvas.PathRoundRect(rcTrack.Left, rcTrack.Top, trackW, trackH, trackH / 2)
		Canvas.FillPath(ARGB(clrTrack), 100)
		Canvas.StrokePath(ARGB(clrBorder), m_BorderThickness, 100)
		Canvas.PathDiscard

		'---- the knob ----------------------------------------------------------------
		Canvas.PathStart
		Canvas.PathRoundRect(rcKnob.Left, rcKnob.Top, knobDia, knobDia, knobDia / 2)
		Canvas.FillPath(ARGB(clrKnob), 100)
		Canvas.PathDiscard

		Exit Sub
		ErrorHandler:
		MsgBox ErrDescription(Err) & " (" & Err & ") " & _
		"in line " & Erl() & " (Handler line: " & __LINE__ & ") " & _
		"in function " & ZGet(Erfn()) & " (Handler function: " & __FUNCTION__ & ") " & _
		"in module " & ZGet(Ermn()) & " (Handler file: " & __FILE__ & ") "
	End Sub

	'== Interaction =========================================================================

	Private Sub Toggle.CancelPress()
		isPressed = False
	End Sub

	Private Sub Toggle.UpdateHotTimer()
		'The hot-tracking safety net: WM_MOUSELEAVE is not reliably delivered on
		'fast exits, so a periodic cursor check clears the hot state
		#ifdef __USE_WINAPI__
			If FHandle <> 0 Then
				tmrHotTrack.Interval = TOGGLE_HOTTRACK_MS
			Else
				tmrHotTrack.Interval = 0
			End If
		#endif
	End Sub

	Private Sub Toggle.tmrHotTrack_Timer_(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent)
		QToggle(Sender.Designer).tmrHotTrack_Timer(Sender)
	End Sub

	Private Sub Toggle.tmrHotTrack_Timer(ByRef Sender As TimerComponent)
		#ifdef __USE_WINAPI__
			If FHandle = 0 Then Exit Sub
			Dim pt As POINT
			GetCursorPos(@pt)
			'the raw API: Control.ScreenToClient (MFF Point) shadows the name here
			..ScreenToClient(FHandle, @pt)
			Dim rc As RECT
			GetClientRect(FHandle, @rc)
			Dim bInside As Boolean = pt.x >= rc.Left AndAlso pt.x < rc.Right AndAlso pt.y >= rc.Top AndAlso pt.y < rc.Bottom
			If bInside <> isHot Then
				isHot = bInside
				If isPressed AndAlso bInside = False Then CancelPress
				Refresh
			End If
		#endif
	End Sub

	Private Sub Toggle.Refresh()
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

	Private Sub Toggle.ProcessMessage(ByRef Message As Message)
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
			Case WM_SETFOCUS
				isFocused = True
				Refresh
			Case WM_KILLFOCUS
				isFocused = False
				CancelPress
				Refresh
			Case WM_GETDLGCODE
				'Tell the dialog manager we want the arrow/tab keys ourselves
				Message.Result = DLGC_WANTARROWS
				Exit Sub
			Case WM_LBUTTONDOWN
				If This.Enabled Then
					isPressed = True
					isHot = True
					SetCapture(FHandle)
					.SetFocus FHandle
					Refresh
				End If
			Case WM_MOUSEMOVE
				#ifdef __USE_WINAPI__
					Dim pt As POINT
					pt.x = Message.lParamLo: pt.y = Message.lParamHi
					Dim rc As RECT
					GetClientRect(FHandle, @rc)
					Dim bInside As Boolean = pt.x >= rc.Left AndAlso pt.x < rc.Right AndAlso pt.y >= rc.Top AndAlso pt.y < rc.Bottom
					If bInside <> isHot Then
						isHot = bInside
						Refresh
					End If
				#endif
			Case WM_LBUTTONUP
				Dim bWasPressed As Boolean = isPressed
				If GetCapture = FHandle Then ReleaseCapture
				CancelPress
				If bWasPressed AndAlso isHot AndAlso This.Enabled Then
					isChecked = Not isChecked
					bLayoutDirty = True
					Refresh
					If OnCheckChanged Then OnCheckChanged(*Designer, This, isChecked)
				End If
			Case WM_CAPTURECHANGED
				CancelPress
			Case WM_KEYDOWN
				If This.Enabled = False Then Exit Select
				Select Case Message.wParam
				Case VK_SPACE, VK_RETURN
					isChecked = Not isChecked
					bLayoutDirty = True
					Refresh
					If OnCheckChanged Then OnCheckChanged(*Designer, This, isChecked)
					Message.Result = 0
					Exit Sub
				End Select
			End Select
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			Select Case Message.Msg
			Case CM_PAINT
				Draw()
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub

	#ifdef __USE_GTK__
		Private Function Toggle.OnDraw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As gpointer) As Boolean
			Dim As Toggle Ptr p = Cast(Any Ptr, data1)
			p->Canvas.HandleSetted = True
			p->Canvas.Handle = cr
			If p->nScale = 0 Then p->nScale = p->GetWindowsDPI()
			p->Draw()
			p->Canvas.Handle = 0
			p->Canvas.HandleSetted = False
			Return False
		End Function

		#ifndef __USE_GTK4__
			Private Function Toggle.OnExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As gpointer) As Boolean
				Dim As Toggle Ptr p = Cast(Any Ptr, data1)
				Dim As cairo_t Ptr cr = gdk_cairo_create(Event->window)
				p->OnDraw(widget, cr, data1)
				cairo_destroy(cr)
				Return False
			End Function
		#endif
	#endif

	Private Sub Toggle.InitProperties()
		With This
			WLet(FClassName, "Toggle")
			#ifdef __USE_WINAPI__
				.Style = WS_CHILD Or WS_TABSTOP
				.ExStyle = 0
				.RegisterClass "Toggle", ""
				.ChildProc = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#elseif defined(__USE_GTK__)
				widget = gtk_layout_new(NULL, NULL)
				.RegisterClass "Toggle", @This
				gtk_widget_set_events(widget, _
				GDK_EXPOSURE_MASK Or _
				GDK_STRUCTURE_MASK Or _
				GDK_KEY_PRESS_MASK Or _
				GDK_FOCUS_CHANGE_MASK Or _
				GDK_BUTTON_PRESS_MASK Or _
				GDK_BUTTON_RELEASE_MASK Or _
				GDK_POINTER_MOTION_MASK)
				#ifdef __USE_GTK4__
					mff_widget_set_draw_func(widget, @OnDraw, @This)
				#else
					#ifndef __USE_GTK2__
						g_signal_connect(widget, "draw", G_CALLBACK(@OnDraw), @This)
					#else
						g_signal_connect(widget, "expose-event", G_CALLBACK(@OnExposeEvent), @This)
					#endif
				#endif
				pcontext = gtk_widget_create_pango_context(widget)
				layout = pango_layout_new(pcontext)
			#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.Width = 50
			.Height = 25
			.Child = @This
			.Canvas.Ctrl = @This
			#ifdef __USE_WINAPI__
				.Canvas.UsingGdip = True
			#endif
			.BackColor = PRGB(33, 37, 43)
		End With
		tmrHotTrack.Designer = @This
		tmrHotTrack.Interval = 0
		tmrHotTrack.OnTimer = @tmrHotTrack_Timer_
		tmrHotTrack.Enabled = True
	End Sub

	#ifdef __USE_WINAPI__
		Private Sub Toggle.WndProc(ByRef Message As Message)
		End Sub

		Private Sub Toggle.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			With QToggle(@Sender)
				.nScale = .GetWindowsDPI()
				.bLayoutDirty = True
				.UpdateHotTimer()
			End With
		End Sub
	#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
		Private Sub Toggle.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			With QToggle(@Sender)
				.nScale = .GetWindowsDPI()
				.bLayoutDirty = True
			End With
		End Sub
	#endif

	Private Constructor Toggle
		InitProperties()
	End Constructor

	Private Destructor Toggle
		tmrHotTrack.Interval = 0
		tmrHotTrack.Enabled = False
	End Destructor

	'== Properties ==========================================================================

	Private Property Toggle.Checked As Boolean
		Return isChecked
	End Property

	Private Property Toggle.Checked(Value As Boolean)
		isChecked = Value
		bLayoutDirty = True
		Refresh
	End Property

	Private Property Toggle.TrackWidth As Long
		Return m_TrackWidth
	End Property

	Private Property Toggle.TrackWidth(Value As Long)
		m_TrackWidth = Max(1, Value)
		bLayoutDirty = True
		Refresh
	End Property

	Private Property Toggle.TrackHeight As Long
		Return m_TrackHeight
	End Property

	Private Property Toggle.TrackHeight(Value As Long)
		m_TrackHeight = Max(1, Value)
		bLayoutDirty = True
		Refresh
	End Property

	Private Property Toggle.KnobInset As Long
		Return m_KnobInset
	End Property

	Private Property Toggle.KnobInset(Value As Long)
		m_KnobInset = Max(0, Value)
		bLayoutDirty = True
		Refresh
	End Property

	Private Property Toggle.BorderThickness As Long
		Return m_BorderThickness
	End Property

	Private Property Toggle.BorderThickness(Value As Long)
		m_BorderThickness = Max(0, Value)
		Refresh
	End Property

	Private Property Toggle.FocusGap As Long
		Return m_FocusGap
	End Property

	Private Property Toggle.FocusGap(Value As Long)
		m_FocusGap = Max(0, Value)
		bLayoutDirty = True
		Refresh
	End Property

	Private Property Toggle.FocusThickness As Long
		Return m_FocusThickness
	End Property

	Private Property Toggle.FocusThickness(Value As Long)
		m_FocusThickness = Max(0, Value)
		Refresh
	End Property

	Private Property Toggle.Justify As ToggleJustifies
		Return m_Justify
	End Property

	Private Property Toggle.Justify(Value As ToggleJustifies)
		m_Justify = Value
		bLayoutDirty = True
		Refresh
	End Property

	Private Property Toggle.FocusRingColor As ULong
		Return m_FocusRingColor
	End Property

	Private Property Toggle.FocusRingColor(Value As ULong)
		m_FocusRingColor = Value
		Refresh
	End Property

	Private Property Toggle.TrackColorOn As ULong
		Return m_TrackColorOn
	End Property

	Private Property Toggle.TrackColorOn(Value As ULong)
		m_TrackColorOn = Value
		Refresh
	End Property

	Private Property Toggle.TrackColorOnHot As ULong
		Return m_TrackColorOnHot
	End Property

	Private Property Toggle.TrackColorOnHot(Value As ULong)
		m_TrackColorOnHot = Value
		Refresh
	End Property

	Private Property Toggle.TrackColorOnDisabled As ULong
		Return m_TrackColorOnDisabled
	End Property

	Private Property Toggle.TrackColorOnDisabled(Value As ULong)
		m_TrackColorOnDisabled = Value
		Refresh
	End Property

	Private Property Toggle.TrackBorderColorOn As ULong
		Return m_TrackBorderColorOn
	End Property

	Private Property Toggle.TrackBorderColorOn(Value As ULong)
		m_TrackBorderColorOn = Value
		Refresh
	End Property

	Private Property Toggle.TrackBorderColorOnHot As ULong
		Return m_TrackBorderColorOnHot
	End Property

	Private Property Toggle.TrackBorderColorOnHot(Value As ULong)
		m_TrackBorderColorOnHot = Value
		Refresh
	End Property

	Private Property Toggle.TrackBorderColorOnDisabled As ULong
		Return m_TrackBorderColorOnDisabled
	End Property

	Private Property Toggle.TrackBorderColorOnDisabled(Value As ULong)
		m_TrackBorderColorOnDisabled = Value
		Refresh
	End Property

	Private Property Toggle.KnobColorOn As ULong
		Return m_KnobColorOn
	End Property

	Private Property Toggle.KnobColorOn(Value As ULong)
		m_KnobColorOn = Value
		Refresh
	End Property

	Private Property Toggle.KnobColorOnHot As ULong
		Return m_KnobColorOnHot
	End Property

	Private Property Toggle.KnobColorOnHot(Value As ULong)
		m_KnobColorOnHot = Value
		Refresh
	End Property

	Private Property Toggle.KnobColorOnDisabled As ULong
		Return m_KnobColorOnDisabled
	End Property

	Private Property Toggle.KnobColorOnDisabled(Value As ULong)
		m_KnobColorOnDisabled = Value
		Refresh
	End Property

	Private Property Toggle.TrackColorOff As ULong
		Return m_TrackColorOff
	End Property

	Private Property Toggle.TrackColorOff(Value As ULong)
		m_TrackColorOff = Value
		Refresh
	End Property

	Private Property Toggle.TrackColorOffHot As ULong
		Return m_TrackColorOffHot
	End Property

	Private Property Toggle.TrackColorOffHot(Value As ULong)
		m_TrackColorOffHot = Value
		Refresh
	End Property

	Private Property Toggle.TrackColorOffDisabled As ULong
		Return m_TrackColorOffDisabled
	End Property

	Private Property Toggle.TrackColorOffDisabled(Value As ULong)
		m_TrackColorOffDisabled = Value
		Refresh
	End Property

	Private Property Toggle.TrackBorderColorOff As ULong
		Return m_TrackBorderColorOff
	End Property

	Private Property Toggle.TrackBorderColorOff(Value As ULong)
		m_TrackBorderColorOff = Value
		Refresh
	End Property

	Private Property Toggle.TrackBorderColorOffHot As ULong
		Return m_TrackBorderColorOffHot
	End Property

	Private Property Toggle.TrackBorderColorOffHot(Value As ULong)
		m_TrackBorderColorOffHot = Value
		Refresh
	End Property

	Private Property Toggle.TrackBorderColorOffDisabled As ULong
		Return m_TrackBorderColorOffDisabled
	End Property

	Private Property Toggle.TrackBorderColorOffDisabled(Value As ULong)
		m_TrackBorderColorOffDisabled = Value
		Refresh
	End Property

	Private Property Toggle.KnobColorOff As ULong
		Return m_KnobColorOff
	End Property

	Private Property Toggle.KnobColorOff(Value As ULong)
		m_KnobColorOff = Value
		Refresh
	End Property

	Private Property Toggle.KnobColorOffHot As ULong
		Return m_KnobColorOffHot
	End Property

	Private Property Toggle.KnobColorOffHot(Value As ULong)
		m_KnobColorOffHot = Value
		Refresh
	End Property

	Private Property Toggle.KnobColorOffDisabled As ULong
		Return m_KnobColorOffDisabled
	End Property

	Private Property Toggle.KnobColorOffDisabled(Value As ULong)
		m_KnobColorOffDisabled = Value
		Refresh
	End Property

	'== Actions =============================================================================

	Private Sub Toggle.GetIdealSize(ByRef nWidth As Long, ByRef nHeight As Long)
		'The visual bounds: valid BEFORE the control has ever been sized (it is
		'computed straight from the scalars, not from the layout)
		Dim pad As Long = m_FocusGap + m_FocusThickness
		nWidth = m_TrackWidth + 2 * pad
		nHeight = m_TrackHeight + 2 * pad
	End Sub

	Private Function Toggle.GetTrackRect(ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		If bLayoutDirty Then LayoutToggle()
		If rcTrack.Right <= rcTrack.Left Then Return False
		rcLeft = rcTrack.Left: rcTop = rcTrack.Top: rcRight = rcTrack.Right: rcBottom = rcTrack.Bottom
		Return True
	End Function

	Private Function Toggle.GetKnobRect(ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		If bLayoutDirty Then LayoutToggle()
		If rcKnob.Right <= rcKnob.Left Then Return False
		rcLeft = rcKnob.Left: rcTop = rcKnob.Top: rcRight = rcKnob.Right: rcBottom = rcKnob.Bottom
		Return True
	End Function

	#ifndef ReadProperty_Off
		Private Function Toggle.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case PropertyName
			Case "Checked": Return @isChecked
			End Select
			Return Base.ReadProperty(PropertyName)
		End Function
	#endif

	#ifndef WriteProperty_Off
		Private Function Toggle.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			Select Case PropertyName
			Case "Checked": Checked = QBoolean(Value): Return True
			End Select
			Return Base.WriteProperty(PropertyName, Value)
		End Function
	#endif

	Private Operator Toggle.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator

	End Namespace
'#End Region
