'################################################################################
'#  Progress.bas                                                                #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Liu XiaLin                                                         #
'#  Based on:                                                                   #
'#   PsProgressBar (Paul Squires, PlanetSquires Software, MPL 2.0)              #
'################################################################################

'#Region "Form"
	#include once "Progress.bi"
	#include once "vbcompat.bi"

	Namespace My.Sys.Forms

	' ========================================================================================
	' PURE FUNCTIONS: the fill law, the marquee motion law and the block tiling. No window,
	' no state, no timer - they only answer numbers, which keeps the two things most likely
	' to be subtly wrong testable without a message pump. Ported from PsProgressBar.
	' ========================================================================================

	'Bar length for a determinate position. The longint intermediate keeps
	'(p - nMin) * nTrackLen from overflowing for ranges of a few hundred million.
	Private Function Progress.ComputeBarLength(ByVal nPos As Long, ByVal nMin As Long, ByVal nMax As Long, ByVal nTrackLen As Long) As Long
		If nTrackLen <= 0 Then Return 0
		'An empty or inverted range has no meaningful position: answer 0 rather than divide by zero
		If nMax <= nMin Then Return 0

		Dim p As Long = nPos
		If p < nMin Then p = nMin
		If p > nMax Then p = nMax

		Dim num As LongInt = Cast(LongInt, p - nMin) * Cast(LongInt, nTrackLen)
		Dim n As Long = CLng(num \ Cast(LongInt, nMax - nMin))
		If n < 0 Then n = 0
		If n > nTrackLen Then n = nTrackLen
		Return n
	End Function

	'Leading edge of the indeterminate chunk at tick nTick, as an offset from the
	'start of the track along the growth axis.
	'  msBounce: [0, nTrackLen - nChunkLen], a triangle wave (period = 2 * span)
	'  msWrap:   [-nChunkLen, nTrackLen), a sawtooth - the caller clips to the track
	Private Function Progress.ComputeMarqueeOffset(ByVal nTrackLen As Long, ByVal nChunkLen As Long, ByVal nStep As Long, ByVal nTick As Long, ByVal nStyle As Long) As Long
		If nTrackLen <= 0 Then Return 0
		If nChunkLen <= 0 Then Return 0

		Dim stp As Long = nStep
		If stp < 1 Then stp = 1

		Dim travel As LongInt = Cast(LongInt, nTick) * Cast(LongInt, stp)

		If nStyle = msWrap Then
			'One period carries the chunk from entirely before the track to entirely past it
			Dim period As LongInt = Cast(LongInt, nTrackLen) + Cast(LongInt, nChunkLen)
			Dim p As LongInt = travel Mod period
			If p < 0 Then p += period
			Return CLng(p) - nChunkLen
		End If

		'Bounce. The chunk stays inside, so the span it can travel is what is left over
		Dim span As Long = nTrackLen - nChunkLen
		If span <= 0 Then Return 0

		Dim period As LongInt = Cast(LongInt, span) * 2
		Dim p As LongInt = travel Mod period
		If p < 0 Then p += period
		'Triangle wave: out on the first half of the period, back on the second
		If p <= Cast(LongInt, span) Then Return CLng(p)
		Return CLng(period - p)
	End Function

	'How many whole blocks of nBlockLen, separated by nBlockGap, fit inside nLength.
	'The +gap in the numerator lets the last block go without a trailing gap.
	Private Function Progress.ComputeBlockCount(ByVal nLength As Long, ByVal nBlockLen As Long, ByVal nBlockGap As Long) As Long
		If nBlockLen <= 0 Then Return 0
		If nLength < nBlockLen Then Return 0
		Dim gap As Long = nBlockGap
		If gap < 0 Then gap = 0
		Return (nLength + gap) \ (nBlockLen + gap)
	End Function

	' ========================================================================================
	' Geometry
	' ========================================================================================

	Private Function Progress.GetWindowsDPI() As Double
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

	Private Function Progress.ResolvedCurvature() As Long
		'The stadium sentinel becomes the track's cross extent, which the round
		'path clamps to half - both ends become exact semicircles
		If m_Curvature >= 0 Then Return m_Curvature
		Dim cross As Long
		If m_Orientation = poVertical Then
			cross = rcTrack.Right - rcTrack.Left
		Else
			cross = rcTrack.Bottom - rcTrack.Top
		End If
		If cross < 0 Then cross = 0
		Return cross
	End Function

	Private Function Progress.FillLength() As Long
		'The distance a 100% bar covers: rcFill's extent along the growth axis
		Dim n As Long
		If m_Orientation = poVertical Then
			n = rcFill.Bottom - rcFill.Top
		Else
			n = rcFill.Right - rcFill.Left
		End If
		If n < 0 Then n = 0
		Return n
	End Function

	Private Function Progress.BarLength() As Long
		Dim n As Long
		If m_Orientation = poVertical Then
			n = rcBar.Bottom - rcBar.Top
		Else
			n = rcBar.Right - rcBar.Left
		End If
		If n < 0 Then n = 0
		Return n
	End Function

	'Where block idx sits inside the CURRENT bar rect. Blocks tile from the bar's
	'own growth-start edge: for a determinate bar they sit on a fixed grid, in
	'indeterminate mode they travel with the floating chunk.
	Private Function Progress.BlockRectAt(ByVal idx As Long, ByRef rc As ProgressRect) As Boolean
		rc.Left = 0: rc.Top = 0: rc.Right = 0: rc.Bottom = 0
		If idx < 0 Then Return False

		Dim blockLen As Long = m_BlockLength * nScale
		If blockLen <= 0 Then Return False
		Dim gap As Long = m_BlockGap * nScale
		If gap < 0 Then gap = 0
		Dim stride As Long = blockLen + gap
		Dim ofs As Long = idx * stride

		rc = rcBar
		If m_Orientation = poVertical Then
			If m_Reverse Then
				rc.Top = rcBar.Top + ofs
				rc.Bottom = rc.Top + blockLen
				If rc.Bottom > rcBar.Bottom Then Return False
			Else
				rc.Bottom = rcBar.Bottom - ofs
				rc.Top = rc.Bottom - blockLen
				If rc.Top < rcBar.Top Then Return False
			End If
		Else
			If m_Reverse Then
				rc.Right = rcBar.Right - ofs
				rc.Left = rc.Right - blockLen
				If rc.Left < rcBar.Left Then Return False
			Else
				rc.Left = rcBar.Left + ofs
				rc.Right = rc.Left + blockLen
				If rc.Right > rcBar.Right Then Return False
			End If
		End If
		Return True
	End Function

	'Assign the three rects. The only place progress geometry is produced.
	'  rcTrack: full length along the growth axis, m_Thickness deep across it,
	'           centred (0 = fill the client's cross axis)
	'  rcFill:  rcTrack inset by m_BarInset
	'  rcBar:   determinate - anchored to rcFill's start edge; indeterminate -
	'           the floating marquee chunk, clipped to rcFill
	'  A vertical bar grows BOTTOM-UP by default; Reverse mirrors the direction.
	Private Sub Progress.LayoutProgress()
		bLayoutDirty = False
		#ifdef __USE_WINAPI__
			If FHandle = 0 Then Exit Sub
		#elseif defined(__USE_GTK__)
			If widget = 0 Then Exit Sub
		#endif

		Dim clientW As Long = ScaleX(This.ClientWidth)
		Dim clientH As Long = ScaleY(This.ClientHeight)

		'No geometry yet (created 0x0, sized only once the host places us)
		If clientW <= 0 OrElse clientH <= 0 Then
			bLayoutDirty = True
			Exit Sub
		End If

		Dim nThick As Long = m_Thickness * nScale
		Dim nInset As Long = m_BarInset * nScale

		'---- rcTrack -------------------------------------------------------------
		If m_Orientation = poVertical Then
			Dim tw As Long = nThick
			If tw <= 0 OrElse tw > clientW Then tw = clientW
			Dim x As Long = (clientW - tw) \ 2
			rcTrack.Left = x: rcTrack.Top = 0: rcTrack.Right = x + tw: rcTrack.Bottom = clientH
		Else
			Dim th As Long = nThick
			If th <= 0 OrElse th > clientH Then th = clientH
			Dim y As Long = (clientH - th) \ 2
			rcTrack.Left = 0: rcTrack.Top = y: rcTrack.Right = clientW: rcTrack.Bottom = y + th
		End If

		'---- rcFill: the track, inset --------------------------------------------
		rcFill = rcTrack
		If nInset > 0 Then
			rcFill.Left += nInset: rcFill.Top += nInset
			rcFill.Right -= nInset: rcFill.Bottom -= nInset
			If rcFill.Right < rcFill.Left Then rcFill.Right = rcFill.Left
			If rcFill.Bottom < rcFill.Top Then rcFill.Bottom = rcFill.Top
		End If

		'---- rcBar ----------------------------------------------------------------
		Dim fillLen As Long = FillLength()
		Dim barStart As Long = 0
		Dim barLen As Long = 0

		If m_Mode = pmIndeterminate Then
			Dim chunk As Long = fillLen * m_ChunkPercent \ 100
			If chunk < 1 Then chunk = 1
			If chunk > fillLen Then chunk = fillLen
			barLen = chunk
			barStart = ComputeMarqueeOffset(fillLen, chunk, m_MarqueeStep * nScale, m_Tick, m_MarqueeStyle)
		Else
			barLen = ComputeBarLength(m_Position, m_Min, m_Max, fillLen)
			barStart = 0
		End If

		rcBar = rcFill
		If m_Orientation = poVertical Then
			If m_Reverse Then
				rcBar.Top = rcFill.Top + barStart
				rcBar.Bottom = rcBar.Top + barLen
			Else
				rcBar.Bottom = rcFill.Bottom - barStart
				rcBar.Top = rcBar.Bottom - barLen
			End If
		Else
			If m_Reverse Then
				rcBar.Right = rcFill.Right - barStart
				rcBar.Left = rcBar.Right - barLen
			Else
				rcBar.Left = rcFill.Left + barStart
				rcBar.Right = rcBar.Left + barLen
			End If
		End If

		'CLIP THE BAR TO THE FILL AREA: msWrap deliberately produces offsets that
		'slide in from one edge and out of the other, so rcBar legitimately
		'overhangs during a wrap cycle
		If rcBar.Left < rcFill.Left Then rcBar.Left = rcFill.Left
		If rcBar.Top < rcFill.Top Then rcBar.Top = rcFill.Top
		If rcBar.Right > rcFill.Right Then rcBar.Right = rcFill.Right
		If rcBar.Bottom > rcFill.Bottom Then rcBar.Bottom = rcFill.Bottom
		If rcBar.Right < rcBar.Left Then rcBar.Right = rcBar.Left
		If rcBar.Bottom < rcBar.Top Then rcBar.Bottom = rcBar.Top
	End Sub

	' ========================================================================================
	' Painting
	' ========================================================================================

	Private Function Progress.Percent() As Long
		If m_Max <= m_Min Then Return 0
		Dim p As Long = m_Position
		If p < m_Min Then p = m_Min
		If p > m_Max Then p = m_Max
		Dim num As LongInt = Cast(LongInt, p - m_Min) * 100
		Return CLng(num \ Cast(LongInt, m_Max - m_Min))
	End Function

	'Resolve the bar's two stops from the state. DISABLED beats everything, then
	'the paused/error state. pfSolid uses the first colour only.
	Private Function Progress.ResolveBarColors(ByRef clr2 As ULong) As ULong
		clr2 = 0
		If This.Enabled = False Then
			clr2 = m_BarColorDisabledEnd
			Return m_BarColorDisabled
		End If
		Select Case m_State
		Case psPaused
			clr2 = m_BarColorPausedEnd
			Return m_BarColorPaused
		Case psError
			clr2 = m_BarColorErrorEnd
			Return m_BarColorError
		Case Else
			clr2 = m_BarColorEnd
			Return m_BarColor
		End Select
	End Function

	'Exactly what would be drawn across the bar right now
	Private Function Progress.DisplayText() As UString
		Select Case m_TextMode
		Case ptPercent
			Return WStr(Percent()) & "%"
		Case ptValue
			Return WStr(m_Position)
		Case ptCustom
			Return This.Text
		End Select
		Return ""
	End Function

	'COLORREF (+opacity) to the colour layout the Canvas Path family expects:
	'ARGB on Windows, the COLORREF layout plus the Opacity argument elsewhere
	Private Function Progress.ARGB(clr As ULong, Opacity As Long = 100) As ULong
		#ifdef __USE_WINAPI__
			Return (Cast(ULong, Opacity / 100 * 255) Shl 24) Or (GetRed(clr) Shl 16) Or (GetGreen(clr) Shl 8) Or GetBlue(clr)
		#else
			Return clr
		#endif
	End Function

	Private Sub Progress.Draw()
		On Error Goto ErrorHandler

		'Consume any pending layout before painting - this is what makes layout lazy
		If bLayoutDirty Then LayoutProgress()

		Dim curv As Long = ResolvedCurvature() * nScale
		Dim clr1 As ULong, clr2 As ULong

		'---- the background -------------------------------------------------------
		'No BackColor of its own: blend into the parent, so the area outside
		'the rounded track is not painted with a foreign colour
		Dim backClr As Integer = This.BackColor
		If backClr = -1 AndAlso This.Parent <> 0 Then
			backClr = This.Parent->BackColor
			#ifdef __USE_WINAPI__
				If g_darkModeSupported AndAlso g_darkModeEnabled AndAlso This.Parent->FDefaultBackColor = This.Parent->FBackColor Then backClr = darkBkColor
			#endif
		End If
		If backClr = -1 Then backClr = clBtnFace
		'A path fill, not Canvas.Rectangle: the GDI+ branch of Rectangle takes
		'its colour from Canvas.FillColor/FillOpacity rather than Brush.Color
		Canvas.PathStart
		Canvas.PathRoundRect(0, 0, ScaleX(This.ClientWidth), ScaleY(This.ClientHeight), 0)
		Canvas.FillPath(ARGB(backClr), 100)
		Canvas.PathDiscard

		'---- the track ------------------------------------------------------------
		If rcTrack.Right > rcTrack.Left AndAlso rcTrack.Bottom > rcTrack.Top Then
			Canvas.PathStart
			Canvas.PathRoundRect(rcTrack.Left, rcTrack.Top, rcTrack.Right - rcTrack.Left, rcTrack.Bottom - rcTrack.Top, curv)
			Canvas.FillPath(ARGB(m_TrackColor), 100)
			If m_BorderThickness > 0 Then
				Canvas.StrokePath(ARGB(m_TrackBorderColor), m_BorderThickness, 100)
			End If
			Canvas.PathDiscard
		End If

		'---- the bar ---------------------------------------------------------------
		clr1 = ResolveBarColors(clr2)
		Dim bHasBar As Boolean = rcBar.Right > rcBar.Left AndAlso rcBar.Bottom > rcBar.Top
		Dim barLen As Long = BarLength()

		If bHasBar Then
			If m_Segmented Then
				'Each block takes its own slice of one gradient spanning the whole
				'run, so the blocks read as a single bar that happens to be
				'perforated rather than as N identical chips
				Dim nBlocks As Long = ComputeBlockCount(barLen, m_BlockLength * nScale, m_BlockGap * nScale)
				For k As Long = 0 To nBlocks - 1
					Dim rcBlk As ProgressRect
					If BlockRectAt(k, rcBlk) = False Then Exit For
					Canvas.PathStart
					Canvas.PathRoundRect(rcBlk.Left, rcBlk.Top, rcBlk.Right - rcBlk.Left, rcBlk.Bottom - rcBlk.Top, curv)
					If m_FillStyle = pfGradient Then
						'rcBar as the RAMP rect: the gradient runs across the whole
						'bar and every block shows the slice it covers
						If m_Orientation = poVertical Then
							Canvas.FillPathGradient(ARGB(clr1), ARGB(clr2), 100, 100, rcBar.Left, rcBar.Top, rcBar.Right - rcBar.Left, rcBar.Bottom - rcBar.Top, 0)
						Else
							Canvas.FillPathGradient(ARGB(clr1), ARGB(clr2), 100, 100, rcBar.Left, rcBar.Top, rcBar.Right - rcBar.Left, rcBar.Bottom - rcBar.Top, 90)
						End If
					Else
						Canvas.FillPath(ARGB(clr1), 100)
					End If
					Canvas.PathDiscard
				Next
			Else
				Canvas.PathStart
				Canvas.PathRoundRect(rcBar.Left, rcBar.Top, rcBar.Right - rcBar.Left, rcBar.Bottom - rcBar.Top, curv)
				If m_FillStyle = pfGradient Then
					If m_Orientation = poVertical Then
						Canvas.FillPathGradient(ARGB(clr1), ARGB(clr2), 100, 100, rcBar.Left, rcBar.Top, rcBar.Right - rcBar.Left, rcBar.Bottom - rcBar.Top, 0)
					Else
						Canvas.FillPathGradient(ARGB(clr1), ARGB(clr2), 100, 100, rcBar.Left, rcBar.Top, rcBar.Right - rcBar.Left, rcBar.Bottom - rcBar.Top, 90)
					End If
				Else
					Canvas.FillPath(ARGB(clr1), 100)
				End If
				Canvas.PathDiscard
			End If
		End If

		'---- the text ---------------------------------------------------------------
		Dim sText As UString = DisplayText()
		If Len(sText) = 0 Then Exit Sub
		If rcTrack.Right <= rcTrack.Left OrElse rcTrack.Bottom <= rcTrack.Top Then Exit Sub

		Canvas.Font = This.Font
		Dim tW As Long = ScaleX(Canvas.TextWidth(sText))
		Dim tH As Long = ScaleY(Canvas.TextHeight(sText))
		Dim tX As Long = rcTrack.Left + ((rcTrack.Right - rcTrack.Left) - tW) \ 2
		Dim tY As Long = rcTrack.Top + ((rcTrack.Bottom - rcTrack.Top) - tH) \ 2

		Dim clrText As ULong
		If This.Enabled = False Then
			clrText = m_TextColorDisabled
		ElseIf bHasBar Then
			'One colour choice without clip regions (those are Windows-only):
			'text whose centre lies over the filled bar reads against the bar.
			'Orientation and Reverse are already baked into rcBar
			Dim tCX As Long = tX + tW \ 2
			Dim tCY As Long = tY + tH \ 2
			If tCX >= rcBar.Left AndAlso tCX <= rcBar.Right AndAlso tCY >= rcBar.Top AndAlso tCY <= rcBar.Bottom Then
				clrText = m_TextColorOnBar
			Else
				clrText = m_TextColor
			End If
		Else
			clrText = m_TextColor
		End If
		Canvas.TextOut(tX, tY, sText, clrText, -1)

		Exit Sub
		ErrorHandler:
		MsgBox ErrDescription(Err) & " (" & Err & ") " & _
		"in line " & Erl() & " (Handler line: " & __LINE__ & ") " & _
		"in function " & ZGet(Erfn()) & " (Handler function: " & __FUNCTION__ & ") " & _
		"in module " & ZGet(Ermn()) & " (Handler file: " & __FILE__ & ") "
	End Sub

	' ========================================================================================
	' Marquee timer
	' ========================================================================================

	Private Sub Progress.UpdateMarqueeTimer()
		'The timer runs ONLY in indeterminate mode: a determinate bar burns no CPU
		If m_Mode = pmIndeterminate AndAlso This.Enabled Then
			tmrMarquee.Interval = m_MarqueeInterval
		Else
			tmrMarquee.Interval = 0
		End If
	End Sub

	Private Sub Progress.tmrMarquee_Timer_(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent)
		QProgress(Sender.Designer).tmrMarquee_Timer(Sender)
	End Sub

	Private Sub Progress.tmrMarquee_Timer(ByRef Sender As TimerComponent)
		m_Tick += 1
		'Only the bar rect depends on the tick: relayout and repaint
		bLayoutDirty = True
		Refresh
	End Sub

	' ========================================================================================
	' Messages / platform glue
	' ========================================================================================

	Private Sub Progress.Refresh()
		bLayoutDirty = True
		#ifdef __USE_GTK__
			If GTK_IS_WIDGET(widget) Then gtk_widget_queue_draw(widget)
		#elseif defined(__USE_WINAPI__)
			If FHandle Then
				InvalidateRect(FHandle, NULL, FALSE)
				UpdateWindow FHandle
			End If
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			Repaint
		#endif
	End Sub

	#ifdef __USE_WINAPI__
		Private Sub Progress.WndProc(ByRef Message As Message)
		End Sub

		Private Sub Progress.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			With QProgress(@Sender)
				.nScale = .GetWindowsDPI()
				.bLayoutDirty = True
				.UpdateMarqueeTimer()
			End With
		End Sub
	#endif

	#if defined(__USE_WASM__) OrElse defined(__USE_JNI__)
		Private Sub Progress.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			With QProgress(@Sender)
				.nScale = .GetWindowsDPI()
				.bLayoutDirty = True
				.UpdateMarqueeTimer()
			End With
		End Sub
	#endif

	Private Sub Progress.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_WINAPI__
			Select Case Message.Msg
			Case WM_ERASEBKGND
				Message.Result = 0
				Exit Sub
			Case WM_PAINT
				'The whole control is drawn through the Canvas into a memory
				'bitmap, then blitted: no flicker even at 30 ms marquee ticks
				Dim ps As PAINTSTRUCT
				Dim Dc As HDC
				Dim As HBITMAP bufBMP
				Dim As Integer mClientWidth = ScaleX(This.ClientWidth), mClientHeight = ScaleY(This.ClientHeight)
				If mClientWidth <= 0 OrElse mClientHeight <= 0 Then
					Dc = BeginPaint(This.Handle, @ps)
					EndPaint(This.Handle, @ps)
					Message.Result = 0
					Exit Sub
				End If
				Dc = BeginPaint(This.Handle, @ps)
				Dim hd As HDC = CreateCompatibleDC(Dc)
				bufBMP = CreateCompatibleBitmap(Dc, mClientWidth, mClientHeight)
				SelectObject(hd, bufBMP)
				Canvas.SetHandle(hd)
				'Pixel i covers [i, i+1]: with the default offset mode an edge at 0 or
				'at the client width falls on a pixel centre, leaving a half-blended
				'dark line at the top/left and clipping the bottom/right
				If Canvas.GdipGraphics Then GdipSetPixelOffsetMode(Canvas.GdipGraphics, PixelOffsetModeHalf)
				Draw()
				Canvas.UnSetHandle
				BitBlt(Dc, 0, 0, mClientWidth, mClientHeight, hd, 0, 0, SRCCOPY)
				DeleteDC hd
				DeleteObject bufBMP
				EndPaint(This.Handle, @ps)
				Message.Result = 0
				Exit Sub
			End Select
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			Select Case Message.Msg
			Case CM_PAINT
				'The base class has set Canvas.Handle to this control's platform
				'canvas before sending CM_PAINT (Control.PaintCanvas)
				Draw()
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub

	#ifdef __USE_GTK__
		Private Function Progress.OnDraw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As gpointer) As Boolean
			Dim As Progress Ptr p = Cast(Any Ptr, data1)
			p->Canvas.HandleSetted = True
			p->Canvas.Handle = cr
			p->Canvas.Font.Name = p->Font.Name
			p->Canvas.Font.Size = p->Font.Size
			p->Canvas.layout = p->layout
			If p->nScale = 0 Then p->nScale = p->GetWindowsDPI()
			p->Draw()
			p->Canvas.Handle = 0
			p->Canvas.HandleSetted = False
			Return False
		End Function

		#ifndef __USE_GTK4__
			Private Function Progress.OnExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As gpointer) As Boolean
				Dim As Progress Ptr p = Cast(Any Ptr, data1)
				Dim As cairo_t Ptr cr = gdk_cairo_create(Event->window)
				p->OnDraw(widget, cr, data1)
				cairo_destroy(cr)
				Return False
			End Function
		#endif

		Private Sub Progress.OnSizeAllocate(widget As GtkWidget Ptr, allocation As GdkRectangle Ptr, user_data As Any Ptr)
			Dim As Progress Ptr p = Cast(Any Ptr, user_data)
			p->bLayoutDirty = True
		End Sub
	#endif

	Private Sub Progress.InitProperties()
		With This
			WLet(FClassName, "Progress")
			#ifdef __USE_WINAPI__
				.Style = WS_CHILD
				.ExStyle = 0
				.RegisterClass "Progress", ""
				.ChildProc = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#elseif defined(__USE_GTK__)
				widget = gtk_layout_new(NULL, NULL)
				.RegisterClass "Progress", @This
				gtk_widget_set_events(widget, _
				GDK_EXPOSURE_MASK Or _
				GDK_STRUCTURE_MASK Or _
				GDK_BUTTON_PRESS_MASK Or _
				GDK_BUTTON_RELEASE_MASK Or _
				GDK_POINTER_MOTION_MASK)
				#ifdef __USE_GTK4__
					mff_widget_set_size_allocate_func(widget, @OnSizeAllocate, @This)
					mff_widget_set_draw_func(widget, @OnDraw, @This)
				#else
					g_signal_connect(widget, "size-allocate", G_CALLBACK(@OnSizeAllocate), @This)
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
			.Width = 175
			.Height = 21
			.Child = @This
			.Canvas.Ctrl = @This
			#ifdef __USE_WINAPI__
				.Canvas.UsingGdip = True
			#endif
		End With
		tmrMarquee.Designer = @This
		tmrMarquee.Interval = 0
		tmrMarquee.OnTimer = @tmrMarquee_Timer_
		tmrMarquee.Enabled = True
	End Sub

	Private Constructor Progress
		InitProperties()
	End Constructor

	Private Destructor Progress
		tmrMarquee.Interval = 0
		tmrMarquee.Enabled = False
	End Destructor

	' ========================================================================================
	' Properties
	' ========================================================================================

	Private Property Progress.MinValue As Long
		Return m_Min
	End Property

	Private Property Progress.MinValue(Value As Long)
		m_Min = Value
		bLayoutDirty = True
		Refresh
	End Property

	Private Property Progress.MaxValue As Long
		Return m_Max
	End Property

	Private Property Progress.MaxValue(Value As Long)
		m_Max = Value
		bLayoutDirty = True
		Refresh
	End Property

	Private Property Progress.Position As Long
		Return m_Position
	End Property

	Private Property Progress.Position(Value As Long)
		m_Position = Value
		bLayoutDirty = True
		Refresh
	End Property

	Private Property Progress.StepValue As Long
		Return m_StepValue
	End Property

	Private Property Progress.StepValue(Value As Long)
		m_StepValue = Value
	End Property

	Private Property Progress.PercentValue As Long
		Return Percent()
	End Property

	Private Property Progress.Mode As ProgressModes
		Return m_Mode
	End Property

	Private Property Progress.Mode(Value As ProgressModes)
		m_Mode = Value
		bLayoutDirty = True
		UpdateMarqueeTimer()
		Refresh
	End Property

	Private Property Progress.State As ProgressStates
		Return m_State
	End Property

	Private Property Progress.State(Value As ProgressStates)
		m_State = Value
		Refresh
	End Property

	Private Property Progress.FillStyle As ProgressFillStyles
		Return m_FillStyle
	End Property

	Private Property Progress.FillStyle(Value As ProgressFillStyles)
		m_FillStyle = Value
		Refresh
	End Property

	Private Property Progress.TextMode As ProgressTextModes
		Return m_TextMode
	End Property

	Private Property Progress.TextMode(Value As ProgressTextModes)
		m_TextMode = Value
		Refresh
	End Property

	Private Property Progress.MarqueeStyle As ProgressMarqueeStyles
		Return m_MarqueeStyle
	End Property

	Private Property Progress.MarqueeStyle(Value As ProgressMarqueeStyles)
		m_MarqueeStyle = Value
		bLayoutDirty = True
		Refresh
	End Property

	Private Property Progress.Orientation As ProgressOrientations
		Return m_Orientation
	End Property

	Private Property Progress.Orientation(Value As ProgressOrientations)
		m_Orientation = Value
		bLayoutDirty = True
		Refresh
	End Property

	Private Property Progress.Segmented As Boolean
		Return m_Segmented
	End Property

	Private Property Progress.Segmented(Value As Boolean)
		m_Segmented = Value
		Refresh
	End Property

	Private Property Progress.Reverse As Boolean
		Return m_Reverse
	End Property

	Private Property Progress.Reverse(Value As Boolean)
		m_Reverse = Value
		bLayoutDirty = True
		Refresh
	End Property

	Private Property Progress.Thickness As Long
		Return m_Thickness
	End Property

	Private Property Progress.Thickness(Value As Long)
		m_Thickness = Value
		bLayoutDirty = True
		Refresh
	End Property

	Private Property Progress.BarInset As Long
		Return m_BarInset
	End Property

	Private Property Progress.BarInset(Value As Long)
		m_BarInset = Value
		bLayoutDirty = True
		Refresh
	End Property

	Private Property Progress.BlockLength As Long
		Return m_BlockLength
	End Property

	Private Property Progress.BlockLength(Value As Long)
		m_BlockLength = Value
		bLayoutDirty = True
		Refresh
	End Property

	Private Property Progress.BlockGap As Long
		Return m_BlockGap
	End Property

	Private Property Progress.BlockGap(Value As Long)
		m_BlockGap = Value
		bLayoutDirty = True
		Refresh
	End Property

	Private Property Progress.BorderThickness As Long
		Return m_BorderThickness
	End Property

	Private Property Progress.BorderThickness(Value As Long)
		m_BorderThickness = Value
		Refresh
	End Property

	Private Property Progress.Curvature As Long
		Return m_Curvature
	End Property

	Private Property Progress.Curvature(Value As Long)
		m_Curvature = Value
		Refresh
	End Property

	Private Property Progress.ChunkPercent As Long
		Return m_ChunkPercent
	End Property

	Private Property Progress.ChunkPercent(Value As Long)
		m_ChunkPercent = Value
		bLayoutDirty = True
		Refresh
	End Property

	Private Property Progress.MarqueeInterval As Long
		Return m_MarqueeInterval
	End Property

	Private Property Progress.MarqueeInterval(Value As Long)
		m_MarqueeInterval = Value
		UpdateMarqueeTimer()
	End Property

	Private Property Progress.MarqueeStep As Long
		Return m_MarqueeStep
	End Property

	Private Property Progress.MarqueeStep(Value As Long)
		m_MarqueeStep = Value
	End Property

	Private Property Progress.TrackColor As ULong
		Return m_TrackColor
	End Property

	Private Property Progress.TrackColor(Value As ULong)
		m_TrackColor = Value
		Refresh
	End Property

	Private Property Progress.TrackBorderColor As ULong
		Return m_TrackBorderColor
	End Property

	Private Property Progress.TrackBorderColor(Value As ULong)
		m_TrackBorderColor = Value
		Refresh
	End Property

	Private Property Progress.BarColor As ULong
		Return m_BarColor
	End Property

	Private Property Progress.BarColor(Value As ULong)
		m_BarColor = Value
		Refresh
	End Property

	Private Property Progress.BarColorEnd As ULong
		Return m_BarColorEnd
	End Property

	Private Property Progress.BarColorEnd(Value As ULong)
		m_BarColorEnd = Value
		Refresh
	End Property

	Private Property Progress.PausedColor As ULong
		Return m_BarColorPaused
	End Property

	Private Property Progress.PausedColor(Value As ULong)
		m_BarColorPaused = Value
		Refresh
	End Property

	Private Property Progress.PausedColorEnd As ULong
		Return m_BarColorPausedEnd
	End Property

	Private Property Progress.PausedColorEnd(Value As ULong)
		m_BarColorPausedEnd = Value
		Refresh
	End Property

	Private Property Progress.ErrorColor As ULong
		Return m_BarColorError
	End Property

	Private Property Progress.ErrorColor(Value As ULong)
		m_BarColorError = Value
		Refresh
	End Property

	Private Property Progress.ErrorColorEnd As ULong
		Return m_BarColorErrorEnd
	End Property

	Private Property Progress.ErrorColorEnd(Value As ULong)
		m_BarColorErrorEnd = Value
		Refresh
	End Property

	Private Property Progress.DisabledColor As ULong
		Return m_BarColorDisabled
	End Property

	Private Property Progress.DisabledColor(Value As ULong)
		m_BarColorDisabled = Value
		Refresh
	End Property

	Private Property Progress.DisabledColorEnd As ULong
		Return m_BarColorDisabledEnd
	End Property

	Private Property Progress.DisabledColorEnd(Value As ULong)
		m_BarColorDisabledEnd = Value
		Refresh
	End Property

	Private Property Progress.TextColor As ULong
		Return m_TextColor
	End Property

	Private Property Progress.TextColor(Value As ULong)
		m_TextColor = Value
		Refresh
	End Property

	Private Property Progress.TextColorOnBar As ULong
		Return m_TextColorOnBar
	End Property

	Private Property Progress.TextColorOnBar(Value As ULong)
		m_TextColorOnBar = Value
		Refresh
	End Property

	Private Property Progress.TextColorDisabled As ULong
		Return m_TextColorDisabled
	End Property

	Private Property Progress.TextColorDisabled(Value As ULong)
		m_TextColorDisabled = Value
		Refresh
	End Property

	' ========================================================================================
	' Actions
	' ========================================================================================

	Private Sub Progress.SetRange(AMin As Long, AMax As Long)
		m_Min = AMin
		m_Max = AMax
		bLayoutDirty = True
		Refresh
	End Sub

	'Advance by StepValue and answer the new position. Clamps at MaxValue where
	'the classic PBM_STEPIT wraps - a wrap makes a finished job look restarted.
	Private Function Progress.StepIt() As Long
		Return StepBy(m_StepValue)
	End Function

	Private Function Progress.StepBy(Delta As Long) As Long
		m_Position += Delta
		If m_Position < m_Min Then m_Position = m_Min
		If m_Position > m_Max Then m_Position = m_Max
		bLayoutDirty = True
		Refresh
		Return m_Position
	End Function

	#ifndef ReadProperty_Off
		Private Function Progress.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case PropertyName
			Case "MinValue": Return @m_Min
			Case "MaxValue": Return @m_Max
			Case "Position": Return @m_Position
			End Select
			Return Base.ReadProperty(PropertyName)
		End Function
	#endif

	#ifndef WriteProperty_Off
		Private Function Progress.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			Select Case PropertyName
			Case "MinValue": MinValue = QInteger(Value): Return True
			Case "MaxValue": MaxValue = QInteger(Value): Return True
			Case "Position": Position = QInteger(Value): Return True
			End Select
			Return Base.WriteProperty(PropertyName, Value)
		End Function
	#endif

	Private Operator Progress.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator

	End Namespace
'#End Region
