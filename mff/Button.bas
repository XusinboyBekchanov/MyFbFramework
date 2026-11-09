'################################################################################
'#  Button.bas                                                                  #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Liu XiaLin                                                         #
'#  Based on:                                                                   #
'#   PsButton (Paul Squires, PlanetSquires Software, MPL 2.0)                   #
'################################################################################

'#Region "Form"
	#include once "Button.bi"
	#include once "vbcompat.bi"

	Namespace My.Sys.Forms

	Private Function Button.GetWindowsDPI() As Double
		#ifdef __USE_GTK__
			Return 1#
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			Return IIf(ydpi > 0, ydpi, 1#)
		#elseif defined(__USE_WINAPI__)
			'Per-monitor: prefer the scale the framework adopted for THIS control
			'(WM_DPICHANGED keeps it current); the screen DC answers for the
			'PRIMARY monitor and lies on every other one.
			If xdpi > 0 Then Return xdpi
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

	'The distance the visual bounds extend beyond the button chrome on every
	'side. The focus ring is drawn INSIDE this band, and the band is reserved
	'UNCONDITIONALLY - whether or not the control currently has focus - which
	'is what stops the button jumping when focus arrives.
	Private Function Button.RingPad() As Long
		Return m_FocusGap * nScale + m_FocusThickness
	End Function

	Private Function Button.HasText() As Boolean
		Return Len(This.Text) > 0
	End Function

	Private Function Button.HasIconLeft() As Boolean
		'An icon cell is present when the side carries a glyph. (The Ps source
		'also allows an image file per cell; this port draws glyphs.)
		Return Len(WGet(FGlyphLeft)) > 0
	End Function

	Private Function Button.HasIconRight() As Boolean
		Return Len(WGet(FGlyphRight)) > 0
	End Function

	'Measure the caption with the control's font. Runs with NO client geometry,
	'so GetIdealSize stays valid before the control has ever been sized.
	Private Sub Button.MeasureText(ByRef nWidth As Long, ByRef nHeight As Long)
		nWidth = 0
		nHeight = 0
		If HasText() = False Then Exit Sub
		#ifdef __USE_WINAPI__
			Dim hdc As HDC = GetDC(FHandle)
			If hdc = 0 Then Exit Sub
			Dim hFontUse As HFONT = Cast(HFONT, 0)
			If This.Font.Handle Then
				hFontUse = This.Font.Handle
			Else
				'The control font is a wish (name + point size) until its HFONT
				'is materialised. The Canvas font is built from the same four
				'fields and carries a real Handle - measure with THAT, or the
				'metrics come from DEFAULT_GUI_FONT's fixed 96-DPI bitmap and
				'the caption is centred on the wrong height, drifting down as
				'the DPI grows
				Canvas.Font.Name = This.Font.Name
				Canvas.Font.Size = This.Font.Size
				Canvas.Font.Bold = This.Font.Bold
				Canvas.Font.Italic = This.Font.Italic
				hFontUse = Canvas.Font.Handle
			End If
			If hFontUse = 0 Then hFontUse = GetStockObject(DEFAULT_GUI_FONT)
			Dim hOld As HFONT = Cast(HFONT, SelectObject(hdc, hFontUse))
			'DrawText with DT_CALCRECT measures without needing the SIZE type
			'(MFF's own Type Size occupies that name inside this namespace), and
			'DT_NOPREFIX enforces the no-ampersand rule the whole family draws by
			Dim rcCalc As Rect
			DrawTextW(hdc, This.Text, -1, @rcCalc, DT_CALCRECT Or DT_NOPREFIX)
			nWidth = rcCalc.Right
			nHeight = rcCalc.Bottom
			SelectObject(hdc, hOld)
			ReleaseDC(FHandle, hdc)
		#elseif defined(__USE_GTK__)
			'Without a font handle yet the layout measures in the default font of
			'the widget: a zero width would leave the caption span empty
			If layout <> 0 Then
				If This.Font.Handle Then pango_layout_set_font_description(layout, Cast(PangoFontDescription Ptr, This.Font.Handle))
				pango_layout_set_text(layout, ToUtf8(This.Text), -1)
				Dim w As Long, h As Long
				pango_layout_get_pixel_size(layout, @w, @h)
				nWidth = w
				nHeight = h
			End If
		#endif
	End Sub

	'Assign the five rects. The only place button geometry is produced. The
	'ideal size is computed BEFORE the zero-client bail: it does not depend on
	'the client at all, and GetIdealSize is exactly what a host calls to decide
	'how big to make the control in the first place.
	Private Sub Button.LayoutButton()
		bLayoutDirty = False

		'---- the measuring pass ------------------------------------------------
		MeasureText(nTextWidth, nTextHeight)

		Dim nRingPad As Long = RingPad()
		Dim nCellW As Long = m_IconWidth * nScale
		Dim nCellH As Long = m_IconHeight * nScale
		Dim nGapDev As Long = m_IconGap * nScale
		Dim padL As Long = m_PadLeft * nScale
		Dim padT As Long = m_PadTop * nScale
		Dim padR As Long = m_PadRight * nScale
		Dim padB As Long = m_PadBottom * nScale

		Dim bText As Boolean = HasText() AndAlso nTextWidth > 0
		Dim bLeft As Boolean = HasIconLeft()
		Dim bRght As Boolean = HasIconRight()

		'The gap is spent only when there is a caption to separate from: an
		'icon-only button charges pad + icon + pad and nothing else
		Dim leftBlock As Long = 0
		If bLeft Then
			leftBlock = nCellW
			If bText Then leftBlock += nGapDev
		End If
		Dim rightBlock As Long = 0
		If bRght Then
			rightBlock = nCellW
			If bText Then rightBlock += nGapDev
		End If

		Dim contentH As Long = 0
		If bText Then contentH = nTextHeight
		If bLeft OrElse bRght Then
			If nCellH > contentH Then contentH = nCellH
		End If

		Dim textW As Long = 0
		If bText Then textW = nTextWidth

		nIdealW = 2 * nRingPad + padL + leftBlock + textW + rightBlock + padR
		nIdealH = 2 * nRingPad + padT + contentH + padB

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

		'Opt-in auto size: keep the top-left, take the ideal size
		If m_AutoSize Then
			If ScaleX(This.Width) <> nIdealW OrElse ScaleY(This.Height) <> nIdealH Then
				This.Width = UnScaleX(nIdealW)
				This.Height = UnScaleY(nIdealH)
			End If
		End If

		'---- placement ----------------------------------------------------------
		rcButton.Left = nRingPad: rcButton.Top = nRingPad
		rcButton.Right = clientW - nRingPad: rcButton.Bottom = clientH - nRingPad
		Dim btnH As Long = rcButton.Bottom - rcButton.Top

		'The icon cells, pinned to their padding, always v-centred. An absent
		'part gives an EMPTY rect, not a zero-width one tucked against an edge
		If bLeft Then
			Dim xL As Long = rcButton.Left + padL
			Dim yL As Long = rcButton.Top + ((btnH - nCellH) \ 2)
			rcIconLeft.Left = xL: rcIconLeft.Top = yL: rcIconLeft.Right = xL + nCellW: rcIconLeft.Bottom = yL + nCellH
		Else
			rcIconLeft.Left = 0: rcIconLeft.Top = 0: rcIconLeft.Right = 0: rcIconLeft.Bottom = 0
		End If
		If bRght Then
			Dim xR As Long = rcButton.Right - padR - nCellW
			Dim yR As Long = rcButton.Top + ((btnH - nCellH) \ 2)
			rcIconRight.Left = xR: rcIconRight.Top = yR: rcIconRight.Right = xR + nCellW: rcIconRight.Bottom = yR + nCellH
		Else
			rcIconRight.Left = 0: rcIconRight.Top = 0: rcIconRight.Right = 0: rcIconRight.Bottom = 0
		End If

		'The caption SPAN between the two icon blocks, degenerate rather than
		'negative when the client is too narrow
		If bText Then
			Dim tLeft As Long = rcButton.Left + padL + leftBlock
			Dim tRight As Long = rcButton.Right - padR - rightBlock
			If tRight < tLeft Then tRight = tLeft
			Dim tTop As Long = rcButton.Top + ((btnH - nTextHeight) \ 2)
			rcText.Left = tLeft: rcText.Top = tTop: rcText.Right = tRight: rcText.Bottom = tTop + nTextHeight
		Else
			rcText.Left = 0: rcText.Top = 0: rcText.Right = 0: rcText.Bottom = 0
		End If

		rcVisual.Left = rcButton.Left - nRingPad: rcVisual.Top = rcButton.Top - nRingPad
		rcVisual.Right = rcButton.Right + nRingPad: rcVisual.Bottom = rcButton.Bottom + nRingPad
	End Sub

	'== Colour resolution ===================================================================

	'Which colour set does this state call for? disabled > pressed > hot > idle.
	'A PURE FUNCTION: the painter and the tests read the same truth table.
	Private Function Button.ResolvedMood() As ButtonMoods
		If This.Enabled = False Then Return bmDisabled
		'A live press renders as pressed only while the cursor is still inside;
		'slide off and this goes false without ending the gesture
		If isPressed AndAlso isHot Then Return bmPressed
		If isHot Then Return bmHot
		Return bmIdle
	End Function

	'The factory palette of one mood. Both themes read FLAT: the resting
	'chrome takes the PARENT's background (the button is a hairline outline
	'on its container, like a secondary command), hot fills a quiet hover
	'shade, pressed fills the accent, disabled mutes. The active set follows
	'the framework's global dark flag while BackColor is left at its -1 (auto)
	'default - assigning BackColor switches every mood to the manual m_*
	'colours. Returns False when the manual palette applies.
	Private Function Button.ThemeColors(ByVal mood As ButtonMoods, ByRef clrBack As ULong, ByRef clrFore As ULong, ByRef clrBorder As ULong, ByRef clrIcon As ULong) As Boolean
		'The manual palette wins as soon as the host assigned a BackColor.
		'Compare through a ULong copy: BackColor is an Integer, and -1 held in
		'a signed variable is NOT Cast(ULong, -1) under a mixed comparison
		Dim clrAuto As ULong = This.BackColor
		If clrAuto <> Cast(ULong, -1) Then Return False
		Dim bDark As Boolean = False
		#ifdef __USE_WINAPI__
			bDark = g_darkModeSupported AndAlso g_darkModeEnabled
		#else
			'GTK, Android, Web: the dark mode of the application (SetDarkMode)
			bDark = g_darkModeEnabled
		#endif
		#if defined(__USE_GTK__) AndAlso Not defined(__USE_GTK2__)
			'Over a theme-painted parent the GTK theme decides: a light text of the theme is on a dark surface. In the designer
			'of the IDE (the library) the dark mode of the application is not set, the text was dark on a dark theme
			If widget <> 0 AndAlso ThemeBackShows() Then
				Dim As GdkRGBA FgColor
				#ifdef __USE_GTK4__
					gtk4compat_widget_get_color(widget, @FgColor)
				#else
					gtk_style_context_get_color(gtk_widget_get_style_context(widget), GTK_STATE_FLAG_NORMAL, @FgColor)
				#endif
				bDark = FgColor.red * 0.299 + FgColor.green * 0.587 + FgColor.blue * 0.114 > 0.5
			End If
		#endif
		If bDark Then
			Select Case mood
			Case bmDisabled
				clrBack = PRGB(40, 44, 51): clrFore = PRGB(96, 102, 112)
				clrBorder = clrBack
			Case bmPressed
				clrBack = PRGB(38, 79, 120): clrFore = PRGB(255, 255, 255)
				clrBorder = clrBack
			Case bmHot
				clrBack = PRGB(55, 61, 72): clrFore = PRGB(226, 230, 238)
				clrBorder = clrBack
			Case Else
				'The resting button is the PARENT's colour with a quiet outline
				'(Toggle's off-border grey - the family's resting-control value)
				clrBack = ParentBack(): clrFore = PRGB(200, 205, 214)
				clrBorder = PRGB(84, 89, 97)
			End Select
			clrIcon = clrFore
		Else
			Select Case mood
			Case bmDisabled
				clrBack = PRGB(229, 231, 233): clrFore = PRGB(160, 164, 170)
				clrBorder = PRGB(202, 206, 210)
			Case bmPressed
				clrBack = PRGB(0, 84, 153): clrFore = PRGB(255, 255, 255)
				clrBorder = clrBack
			Case bmHot
				'A quiet grey hover - the same step above the parent the dark
				'hot shade is - keeps the resting/hot pair legible in light too
				clrBack = PRGB(225, 228, 232): clrFore = PRGB(10, 16, 24)
				clrBorder = PRGB(160, 164, 170)
			Case Else
				'The resting button is the PARENT's colour with a quiet outline
				clrBack = ParentBack(): clrFore = PRGB(32, 33, 36)
				clrBorder = PRGB(160, 164, 170)
			End Select
			clrIcon = clrFore
		End If
		Return True
	End Function

	'The colour the rounded corners sit on: the PARENT's background, so the
	'chrome reads as a rounded shape and not as a square patch of its own
	'fill. A parent on auto resolves through the theme, exactly like the
	'framework paints auto forms (dark = darkBkColor, light = COLOR_BTNFACE).
	Private Function Button.ParentBack() As ULong
		Return EffectiveParentBack()
	End Function

	'On GTK an auto form (BackColor -1) is painted by the GTK theme (light or dark), whose colour the framework does not
	'know: EffectiveParentBack falls back to a light grey and painted a light square around the button on a dark form.
	'Then the corner band is not painted (the corners stay transparent) and the resting face is painted with the
	'background of the theme.
	Private Function Button.ThemeBackShows() As Boolean
		#ifdef __USE_GTK__
			Dim pAnc As Control Ptr = Cast(Control Ptr, This.Parent)
			While pAnc <> 0
				Dim clr As ULong = pAnc->BackColor
				If clr <> Cast(ULong, -1) Then Return False
				pAnc = Cast(Control Ptr, pAnc->Parent)
			Wend
			Return True
		#else
			Return False
		#endif
	End Function
	
	'Turn the mood (plus the default-button flag) into the four colours the
	'painter uses. The default overlay is applied LAST and unconditionally, so
	'it cannot be true in three moods and forgotten in the fourth.
	Private Sub Button.ResolvedColors(ByRef clrBack As ULong, ByRef clrFore As ULong, ByRef clrBorder As ULong, ByRef clrIcon As ULong)
		Dim mood As ButtonMoods = ResolvedMood()
		If ThemeColors(mood, clrBack, clrFore, clrBorder, clrIcon) Then
			If m_IsDefault Then clrBorder = m_DefaultBorderColor
			Exit Sub
		End If
		Select Case mood
		Case bmDisabled
			clrBack = m_BackColorDisabled
			clrFore = m_ForeColorDisabled
			clrBorder = m_BorderColorDisabled
			clrIcon = m_IconColorDisabled
		Case bmPressed
			clrBack = m_BackColorPressed
			clrFore = m_ForeColorPressed
			clrBorder = m_BorderColorPressed
			clrIcon = m_IconColorPressed
		Case bmHot
			clrBack = m_BackColorHot
			clrFore = m_ForeColorHot
			clrBorder = m_BorderColorHot
			clrIcon = m_IconColorHot
		Case Else
			clrBack = This.BackColor
			clrFore = m_ForeColor
			clrBorder = m_BorderColor
			clrIcon = m_IconColor
		End Select
		If m_IsDefault Then clrBorder = m_DefaultBorderColor
	End Sub

	'== Painting ============================================================================

	Private Function Button.ARGB(clr As ULong, Opacity As Long = 100) As ULong
		#ifdef __USE_WINAPI__
			Return (Cast(ULong, Opacity / 100 * 255) Shl 24) Or (GetRed(clr) Shl 16) Or (GetGreen(clr) Shl 8) Or GetBlue(clr)
		#else
			Return clr
		#endif
	End Function

	'Which face supplies the icon glyphs? Windows resolves the configured name
	'through the Fluent Icons fallback chain once, then caches the answer.
	'Returns 0 = "use the caption font".
	Private Function Button.ResolveGlyphFontName() As WString Ptr
		#ifndef __USE_WINAPI__
			If WGet(FGlyphFontName) > "" Then Return FGlyphFontName
			Return 0
		#else
			Static bDone As Boolean = False
			Static pCached As WString Ptr = 0
			If bDone Then Return pCached
			bDone = True

			If FGlyphFontName<> 0 AndAlso FontHasGlyph(*FGlyphFontName) Then
				WLet(pCached, *FGlyphFontName)
				Return pCached
			End If
			If FontHasGlyph("Segoe Fluent Icons") Then
				WLet(pCached, "Segoe Fluent Icons")
			ElseIf FontHasGlyph("Segoe MDL2 Assets") Then
				WLet(pCached, "Segoe MDL2 Assets")
			ElseIf FontHasGlyph("Segoe UI Symbol") Then
				WLet(pCached, "Segoe UI Symbol")
			End If
			Return pCached
		#endif
	End Function

	#ifdef __USE_WINAPI__
		'Does this face contain the Checkbox codepoint? GGI_MARK_NONEXISTING
		'answers &hFFFF for a missing glyph, which is the whole test.
		Private Function Button.FontHasGlyph(ByRef sFace As WString) As Boolean
			Dim As HFONT hFontTest = CreateFontW(16, 0, 0, 0, FW_NORMAL, 0, 0, 0, DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, CLEARTYPE_QUALITY, DEFAULT_PITCH Or FF_DONTCARE, sFace)
			If hFontTest = 0 Then Return False
			Dim As HDC hdc = GetDC(0)
			Dim As HFONT hOld = Cast(HFONT, SelectObject(hdc, hFontTest))
			Dim As UShort wch = &hE739
			Dim As UShort gi = &hFFFF
			GetGlyphIndicesW(hdc, @wch, 1, @gi, 1)
			SelectObject(hdc, hOld)
			DeleteObject hFontTest
			ReleaseDC 0, hdc
			Return gi <> &hFFFF
		End Function
	#endif

	'One line, ellipsized into the caption span. Called at paint time only
	'(it measures through the live Canvas). Returns 0 when the text already
	'fits; the caller frees the result.
	Private Function Button.Ellipsize(ByRef sText As WString, ByVal nMaxWidth As Long) As WString Ptr
		If Canvas.TextWidth(sText) <= nMaxWidth Then Return 0
		Dim s As UString = sText
		Do While Len(s) > 0
			s = Mid(s, 1, Len(s) - 1)
			If Canvas.TextWidth(s & WChr(&h2026)) <= nMaxWidth Then Exit Do
		Loop
		Dim p As WString Ptr = 0
		WLet(p, s & WChr(&h2026))
		Return p
	End Function

	Private Sub Button.Draw()
		On Error Goto ErrorHandler

		If bLayoutDirty Then LayoutButton()

		Dim clrBack As ULong, clrFore As ULong, clrBorder As ULong, clrIcon As ULong
		ResolvedColors(clrBack, clrFore, clrBorder, clrIcon)

		'---- the background -------------------------------------------------------
		'The band OUTSIDE the rounded chrome is ALWAYS the PARENT's background:
		'it exists so the rounding reads against the container, and following
		'the control's own BackColor here is what paints a square patch of the
		'wrong colour around a custom-coloured button (the "square border"
		'artifact). The chrome face shows the button's own colours, the band
		'never does.
		Dim backClr As ULong = ParentBack()
		Dim bThemeBack As Boolean = ThemeBackShows()
		If Not bThemeBack Then
			Canvas.PathStart
			Canvas.PathRoundRect(0, 0, ScaleX(This.ClientWidth), ScaleY(This.ClientHeight), 0)
			Canvas.FillPath(ARGB(backClr), 100)
			Canvas.PathDiscard
		End If

		'The caption font, copied FIELD BY FIELD: an object assignment would
		'share the WString pointers, and the glyph swap below must never write
		'through the control's own font
		Canvas.Font.Name = This.Font.Name
		Canvas.Font.Size = This.Font.Size
		Canvas.Font.Bold = This.Font.Bold
		Canvas.Font.Italic = This.Font.Italic

		'---- the focus ring (inside the reserved band) -----------------------------
		'The radius speaks LOGICAL pixels through ResolveCornerRadius: an own
		'CornerCurvature (>= 0) wins, else the framework default, else the
		'built-in; the ring stays concentric with the chrome by adding the gap
		Dim nCurv As Long = ResolveCornerRadius(m_Curvature, BUTTON_DEFAULT_CURVATURE)
		If isFocused AndAlso This.Enabled Then
			Dim ringGap As Long = m_FocusGap * nScale
			Dim ringThick As Long = m_FocusThickness
			Dim ringW As Long = (rcButton.Right - rcButton.Left) + ringGap * 2
			Dim ringH As Long = (rcButton.Bottom - rcButton.Top) + ringGap * 2
			Canvas.PathStart
			Canvas.PathRoundRect(rcButton.Left - ringGap, rcButton.Top - ringGap, ringW, ringH, nCurv * nScale + ringGap)
			Canvas.StrokePath(ARGB(m_FocusRingColor), ringThick, 100)
			Canvas.PathDiscard
		End If

		'---- the chrome: rounded rect fill + border ---------------------------------
		Dim btnW As Long = rcButton.Right - rcButton.Left
		Dim btnH As Long = rcButton.Bottom - rcButton.Top
		If btnW > 0 AndAlso btnH > 0 Then
			Canvas.PathStart
			Canvas.PathRoundRect(rcButton.Left, rcButton.Top, btnW, btnH, nCurv * nScale)
			'The resting face is the parent's colour. Over a theme-painted parent that colour is not known: the face is
			'painted with the background of the theme (the window), inside the rounded chrome only - a picture or the
			'grid of the designer behind the button does not show through it, the corners stay transparent
			If bThemeBack AndAlso clrBack = backClr Then
				#if defined(__USE_GTK__) AndAlso Not defined(__USE_GTK2__)
					Dim As GtkWidget Ptr pTop
					If widget <> 0 Then pTop = gtk_widget_get_toplevel(widget)
					If pTop <> 0 AndAlso Canvas.Handle <> 0 Then
						cairo_save(Canvas.Handle)
						cairo_clip_preserve(Canvas.Handle)
						gtk_render_background(gtk_widget_get_style_context(pTop), Canvas.Handle, rcButton.Left, rcButton.Top, btnW, btnH)
						cairo_restore(Canvas.Handle)
						'gtk_render_background used the path of the cairo context: again for the border
						Canvas.PathStart
						Canvas.PathRoundRect(rcButton.Left, rcButton.Top, btnW, btnH, nCurv * nScale)
					End If
				#endif
			Else
				Canvas.FillPath(ARGB(clrBack), 100)
			End If
			If m_BorderThickness > 0 Then
				Canvas.StrokePath(ARGB(clrBorder), m_BorderThickness, 100)
			End If
			Canvas.PathDiscard
		End If

		'---- the glyph cells ---------------------------------------------------------
		Dim pFace As WString Ptr = ResolveGlyphFontName()
		Dim sCapName As UString = Canvas.Font.Name
		Dim nCapSize As Integer = Canvas.Font.Size
		If pFace <> 0 Then Canvas.Font.Name = *pFace
		Canvas.Font.Size = FGlyphFontPoint
		DrawGlyph(rcIconLeft, WGet(FGlyphLeft), clrIcon)
		DrawGlyph(rcIconRight, WGet(FGlyphRight), clrIcon)
		Canvas.Font.Name = sCapName
		Canvas.Font.Size = nCapSize

		'---- the caption ---------------------------------------------------------------
		If HasText() AndAlso rcText.Right > rcText.Left Then
			Dim sText As UString = This.Text
			Dim spanW As Long = rcText.Right - rcText.Left
			'Ellipsize and TextWidth speak LOGICAL pixels (the Canvas scales by
			'the DPI itself); the layout rects are device pixels. Convert here
			'or the caption drifts down/right on any monitor above 96 DPI
			Dim pEll As WString Ptr = Ellipsize(sText, UnScaleX(spanW))
			If pEll <> 0 Then
				sText = *pEll
				WDeAllocate(pEll)
			End If
			Dim tW As Long = Canvas.TextWidth(sText)
			Dim spanL As Long = UnScaleX(spanW)
			Dim leftL As Long = UnScaleX(rcText.Left)
			Dim tX As Long
			Select Case m_TextAlign
			Case baCenter
				tX = leftL + (spanL - tW) \ 2
			Case baRight
				tX = leftL + spanL - tW
			Case Else
				tX = leftL
			End Select
			'COLORREF, like every TextOut - see the CheckBoxEx note
			Canvas.TextOut(tX, UnScaleY(rcText.Top), sText, clrFore, -1)
		End If

		Exit Sub
		ErrorHandler:
		MsgBox ErrDescription(Err) & " (" & Err & ") " & _
		"in line " & Erl() & " (Handler line: " & __LINE__ & ") " & _
		"in function " & ZGet(Erfn()) & " (Handler function: " & __FUNCTION__ & ") " & _
		"in module " & ZGet(Ermn()) & " (Handler file: " & __FILE__ & ") "
	End Sub

Private Sub Button.DrawGlyph(ByRef rcCell As My.Sys.Drawing.Rect, ByRef sGlyph As WString, ByVal clrIcon As ULong)
		'Centred in the declared cell; a glyph too large for the cell clips
		If Len(sGlyph) = 0 Then Exit Sub
		Dim cellW As Long = rcCell.Right - rcCell.Left
		Dim cellH As Long = rcCell.Bottom - rcCell.Top
		If cellW <= 0 OrElse cellH <= 0 Then Exit Sub
		Dim gW As Long = Canvas.TextWidth(sGlyph)
		Dim gH As Long = Canvas.TextHeight(sGlyph)
		'TextOut takes LOGICAL coordinates (and measures in them); the cell is
		'device pixels - centre and place in logical or the glyph drifts
		Dim xL As Long = UnScaleX(rcCell.Left)
		Dim yL As Long = UnScaleY(rcCell.Top)
		Dim wL As Long = UnScaleX(cellW)
		Dim hL As Long = UnScaleY(cellH)
		'COLORREF, like every TextOut - see the CheckBoxEx note
		Canvas.TextOut(xL + (wL - gW) \ 2, yL + (hL - gH) \ 2, sGlyph, clrIcon, -1)
	End Sub

	'== Interaction =========================================================================

	Private Sub Button.CancelPress()
		'A press that ends somewhere other than WM_LBUTTONUP (capture taken
		'away, focus lost, control disabled) leaves the pressed chrome on
		'screen unless it repaints - and WM_LBUTTONUP never repaints by itself
		If isPressed Then
			isPressed = False
			Refresh
		End If
	End Sub

	Private Sub Button.ClearHot()
		If isHot Then
			isHot = False
			Refresh
		End If
	End Sub

	Private Sub Button.FireClick()
		If This.Enabled = False Then Exit Sub
		If OnClick Then OnClick(*Designer, This)
	End Sub

	Private Sub Button.UpdateHotTimer()
		#ifdef __USE_WINAPI__
			If FHandle <> 0 Then
				tmrHotTrack.Interval = BUTTON_HOTTRACK_MS
			Else
				tmrHotTrack.Interval = 0
			End If
		#endif
	End Sub

	Private Sub Button.tmrHotTrack_Timer_(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent)
		QPushButton(Sender.Designer).tmrHotTrack_Timer(Sender)
	End Sub

	Private Sub Button.tmrHotTrack_Timer(ByRef Sender As TimerComponent)
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

	Private Sub Button.Refresh()
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

	Private Sub Button.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_WINAPI__
			Select Case Message.Msg
			Case WM_DPICHANGED
				'Cross-monitor moves keep the HWND: the per-monitor scale cached at
				'creation must follow the monitor, or every metric stays on the old
				'factor and the chrome clips (the missing bottom ring).
				If Message.wParamLo > 0 Then
					Dim nNewScale As Double = Message.wParamLo / 96
					If nNewScale <> nScale Then
						 nScale = nNewScale
						 bLayoutDirty = True
					End If
				End If
			Case WM_ERASEBKGND
				Message.Result = 0
				Exit Sub
			Case WM_PAINT
				'The whole control is drawn through the Canvas into a memory
				'bitmap, then blitted
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
			Case WM_ENABLE
				'The mood colours change with Enabled: EnableWindow does not
				'repaint by itself, so ask for it here
				CancelPress
				ClearHot
				Refresh
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
				Dim pt As POINT
				pt.x = GET_X_LPARAM(Message.lParam): pt.y = GET_Y_LPARAM(Message.lParam)
				Dim rc As RECT
				GetClientRect(FHandle, @rc)
				Dim bInside As Boolean = pt.x >= rc.Left AndAlso pt.x < rc.Right AndAlso pt.y >= rc.Top AndAlso pt.y < rc.Bottom
				If bInside <> isHot Then
					isHot = bInside
					Refresh
				End If
			Case WM_LBUTTONUP
				'Snapshot BEFORE releasing: ReleaseCapture sends WM_CAPTURECHANGED
				'synchronously, which cancels the press
				Dim bWasPressed As Boolean = isPressed
				If GetCapture = FHandle Then ReleaseCapture
				CancelPress
				If bWasPressed AndAlso isHot Then FireClick
			Case WM_CAPTURECHANGED
				CancelPress
			Case WM_MOUSELEAVE
				ClearHot
			Case WM_KEYDOWN
				If This.Enabled = False Then Exit Select
				Select Case Message.wParam
				Case VK_SPACE, VK_RETURN
					FireClick
					bAteKeyDown = True
					Message.Result = 0
					Exit Sub
				End Select
			Case WM_CHAR
				'Swallow the character a consumed Space/Enter produced, or the
				'system beeps even though the keystroke worked
				If bAteKeyDown Then
					bAteKeyDown = False
					Message.Result = 0
					Exit Sub
				End If
			End Select
		#elseif defined(__USE_GTK__)
			'GTK has no Msg: the events of the layout come in Message.Event
			'(drawing goes through OnDraw)
			Dim As GdkEvent Ptr e = Message.Event
			If e <> 0 Then
				Dim As Long nEvType, nBtn, nKey
				Dim As Double ex, ey
				#ifdef __USE_GTK4__
					nEvType = gtk4compat_event_type(e)
					gtk4compat_event_get_widget_position(widget, e, @ex, @ey)
					If nEvType = GDK_BUTTON_PRESS OrElse nEvType = GDK_BUTTON_RELEASE Then nBtn = gdk_button_event_get_button(e)
					If nEvType = GDK_KEY_PRESS Then nKey = gdk_key_event_get_keyval(e)
				#else
					nEvType = e->type
					Select Case nEvType
					Case GDK_BUTTON_PRESS, GDK_BUTTON_RELEASE
						nBtn = e->button.button: ex = e->button.x: ey = e->button.y
					Case GDK_MOTION_NOTIFY
						ex = e->motion.x: ey = e->motion.y
					Case GDK_KEY_PRESS
						nKey = e->key.keyval
					End Select
				#endif
				Select Case nEvType
				Case GDK_BUTTON_PRESS
					If nBtn = 1 AndAlso This.Enabled Then
						isPressed = True
						isHot = True
						gtk_widget_grab_focus(widget)
						Refresh
					End If
				Case GDK_MOTION_NOTIFY
					Dim bInside As Boolean = ex >= 0 AndAlso ey >= 0 AndAlso ex < This.ClientWidth AndAlso ey < This.ClientHeight
					If bInside <> isHot Then
						isHot = bInside
						Refresh
					End If
				Case GDK_BUTTON_RELEASE
					If nBtn = 1 Then
						Dim bWasPressed As Boolean = isPressed
						CancelPress
						If bWasPressed AndAlso isHot Then FireClick
					End If
				Case GDK_LEAVE_NOTIFY
					If isPressed = False Then ClearHot
				Case GDK_KEY_PRESS
					If This.Enabled AndAlso (CBool(nKey = GDK_KEY_Return) OrElse CBool(nKey = GDK_KEY_KP_Enter) OrElse CBool(nKey = GDK_KEY_SPACE)) Then
						FireClick
						Message.Result = True
					End If
				End Select
			End If
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			Select Case Message.Msg
			Case CM_PAINT
				'The base class has set Canvas.Handle to this control's platform
				'canvas before sending CM_PAINT
				Draw()
			Case CM_MOUSEDOWN
				If Message.wParam = 0 AndAlso This.Enabled Then
					isPressed = True
					isHot = True
					Refresh
				End If
			Case CM_MOUSEMOVE
				Dim px As Long = MffPointX(Message.lParam)
				Dim py As Long = MffPointY(Message.lParam)
				Dim bInside As Boolean = px >= 0 AndAlso py >= 0 AndAlso px < ScaleX(This.ClientWidth) AndAlso py < ScaleY(This.ClientHeight)
				If bInside <> isHot Then
					isHot = bInside
					Refresh
				End If
			Case CM_MOUSEUP
				If Message.wParam = 0 Then
					Dim bWasPressed As Boolean = isPressed
					CancelPress
					If bWasPressed AndAlso isHot Then FireClick
				End If
			Case CM_MOUSELEAVE
				ClearHot
			Case CM_KEYDOWN
				'13 = Enter, 32 = Space, the same keys the Windows branch takes
				If This.Enabled AndAlso (Message.wParam = 13 OrElse Message.wParam = 32) Then FireClick
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub

	#ifdef __USE_WINAPI__
		Private Sub Button.WndProc(ByRef Message As Message)
		End Sub

		Private Sub Button.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			With QPushButton(@Sender)
				.nScale = .GetWindowsDPI()
				.bLayoutDirty = True
				.UpdateHotTimer()
			End With
		End Sub
	#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
		Private Sub Button.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			With QPushButton(@Sender)
				.nScale = .GetWindowsDPI()
				.bLayoutDirty = True
			End With
		End Sub
	#endif

	#ifdef __USE_GTK__
		Private Function Button.OnDraw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As gpointer) As Boolean
			Dim As Button Ptr p = Cast(Any Ptr, data1)
			p->Canvas.HandleSetted = True
			p->Canvas.Handle = cr
			If p->nScale = 0 Then p->nScale = p->GetWindowsDPI()
			p->Draw()
			'The caption is the LAST thing drawn, and pango leaves its glyphs pending
			'in the surface: without a flush GTK presents the frame without them
			cairo_surface_flush(cairo_get_target(cr))
			p->Canvas.Handle = 0
			p->Canvas.HandleSetted = False
			Return False
		End Function

		#ifndef __USE_GTK4__
			Private Function Button.OnExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As gpointer) As Boolean
				Dim As Button Ptr p = Cast(Any Ptr, data1)
				Dim As cairo_t Ptr cr = gdk_cairo_create(Event->window)
				p->OnDraw(widget, cr, data1)
				cairo_destroy(cr)
				Return False
			End Function
		#endif

		Private Sub Button.OnSizeAllocate(widget As GtkWidget Ptr, allocation As GdkRectangle Ptr, user_data As Any Ptr)
			Dim As Button Ptr p = Cast(Any Ptr, user_data)
			p->bLayoutDirty = True
		End Sub
	#endif

	Private Sub Button.InitProperties()
		With This
			WLet(FClassName, "Button")
			WLet(FGlyphLeft, "")
			WLet(FGlyphRight, "")
			WLet(FGlyphFontName, "")
			#ifdef __USE_WINAPI__
				'"Button" is a Win32 PREDEFINED class name (case-insensitive): the
				'registration request is refused silently by the system lookup in
				'Control.RegisterClass, and CreateWindowExW then builds a real native
				'push button - ProcessMessage never runs, nothing is drawn. So the
				'window class carries its own name while ClassName stays "Button",
				'the identity the designer and the property grid key on.
				WLet(FWindowClassName, "MFFButton")
				.Style = WS_CHILD Or WS_TABSTOP
				.ExStyle = 0
				.RegisterClass "MFFButton", ""
				.ChildProc = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#elseif defined(__USE_GTK__)
				widget = gtk_layout_new(NULL, NULL)
				#ifdef __USE_GTK3__
					'GtkLayout paints the background of the theme (white): the button draws its own chrome, around it the
					'parent must show through (a white square stayed around the button on a dark form)
					Dim As GtkCssProvider Ptr pCss = gtk_css_provider_new()
					gtk_css_provider_load_from_data(pCss, "* { background-color: transparent; background-image: none; }", -1, NULL)
					gtk_style_context_add_provider(gtk_widget_get_style_context(widget), GTK_STYLE_PROVIDER(pCss), GTK_STYLE_PROVIDER_PRIORITY_APPLICATION)
					g_object_unref(pCss)
				#endif
				.RegisterClass "Button", @This
				gtk_widget_set_events(widget, _
				GDK_EXPOSURE_MASK Or _
				GDK_STRUCTURE_MASK Or _
				GDK_KEY_PRESS_MASK Or _
				GDK_FOCUS_CHANGE_MASK Or _
				GDK_BUTTON_PRESS_MASK Or _
				GDK_BUTTON_RELEASE_MASK Or _
				GDK_LEAVE_NOTIFY_MASK Or _
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
			.Width = 100
			.Height = 28
			.Child = @This
			.Canvas.Ctrl = @This
			#ifdef __USE_WINAPI__
				.Canvas.UsingGdip = True
			#endif
			'BackColor stays at the base -1 (auto): the mood palette then
			'follows the app theme (ThemeColors); assigning a BackColor takes
			'the whole manual m_* set over
		End With
		tmrHotTrack.Designer = @This
		tmrHotTrack.Interval = 0
		tmrHotTrack.OnTimer = @tmrHotTrack_Timer_
		tmrHotTrack.Enabled = True
	End Sub

	Private Constructor Button
		InitProperties()
	End Constructor

	Private Destructor Button
		tmrHotTrack.Interval = 0
		tmrHotTrack.Enabled = False
		WDeAllocate(FGlyphLeft)
		WDeAllocate(FGlyphRight)
		WDeAllocate(FGlyphFontName)
	End Destructor

	'== Properties ==========================================================================

	Private Property Button.GlyphLeft ByRef As WString
		Return WGet(FGlyphLeft)
	End Property

	Private Property Button.GlyphLeft(ByRef Value As WString)
		WLet(FGlyphLeft, Value)
		'Removes the cell AND its gap when emptied, so the ideal width changes
		Refresh
		ApplyAutoSize
	End Property

	Private Property Button.GlyphRight ByRef As WString
		Return WGet(FGlyphRight)
	End Property

	Private Property Button.GlyphRight(ByRef Value As WString)
		WLet(FGlyphRight, Value)
		Refresh
		ApplyAutoSize
	End Property

	Private Property Button.GlyphFontName ByRef As WString
		Return WGet(FGlyphFontName)
	End Property

	Private Property Button.GlyphFontName(ByRef Value As WString)
		WLet(FGlyphFontName, Value)
		'Paint-time input only: the icon cell is DECLARED, never measured
		Refresh
	End Property

	Private Property Button.GlyphFontPoint As Integer
		Return FGlyphFontPoint
	End Property

	Private Property Button.GlyphFontPoint(Value As Integer)
		FGlyphFontPoint = Value
		Refresh
	End Property

	Private Property Button.IsDefault As Boolean
		Return m_IsDefault
	End Property

	Private Property Button.IsDefault(Value As Boolean)
		'SILENT and cheap: only the border colour changes, so it never
		're-measures
		m_IsDefault = Value
		Refresh
	End Property

	Private Property Button.ID As Long
		Return m_ID
	End Property

	Private Property Button.ID(Value As Long)
		m_ID = Value
	End Property

	Private Property Button.TextAlign As ButtonAligns
		Return m_TextAlign
	End Property

	Private Property Button.TextAlign(Value As ButtonAligns)
		m_TextAlign = Value
		Refresh
	End Property

	Private Property Button.AutoSize As Boolean
		Return m_AutoSize
	End Property

	Private Property Button.AutoSize(Value As Boolean)
		m_AutoSize = Value
		Refresh
		ApplyAutoSize
	End Property

	Private Property Button.PadLeft As Long
		Return m_PadLeft
	End Property

	Private Property Button.PadLeft(Value As Long)
		m_PadLeft = Max(0, Value)
		Refresh
		ApplyAutoSize
	End Property

	Private Property Button.PadTop As Long
		Return m_PadTop
	End Property

	Private Property Button.PadTop(Value As Long)
		m_PadTop = Max(0, Value)
		Refresh
		ApplyAutoSize
	End Property

	Private Property Button.PadRight As Long
		Return m_PadRight
	End Property

	Private Property Button.PadRight(Value As Long)
		m_PadRight = Max(0, Value)
		Refresh
		ApplyAutoSize
	End Property

	Private Property Button.PadBottom As Long
		Return m_PadBottom
	End Property

	Private Property Button.PadBottom(Value As Long)
		m_PadBottom = Max(0, Value)
		Refresh
		ApplyAutoSize
	End Property

	Private Property Button.IconGap As Long
		Return m_IconGap
	End Property

	Private Property Button.IconGap(Value As Long)
		m_IconGap = Max(0, Value)
		Refresh
		ApplyAutoSize
	End Property

	Private Property Button.IconWidth As Long
		Return m_IconWidth
	End Property

	Private Property Button.IconWidth(Value As Long)
		m_IconWidth = Max(0, Value)
		Refresh
		ApplyAutoSize
	End Property

	Private Property Button.IconHeight As Long
		Return m_IconHeight
	End Property

	Private Property Button.IconHeight(Value As Long)
		m_IconHeight = Max(0, Value)
		Refresh
		ApplyAutoSize
	End Property

	Private Property Button.CornerCurvature As Long
		Return m_Curvature
	End Property

	Private Property Button.CornerCurvature(Value As Long)
		'-1 = follow the framework default (g_DefaultCornerRadius); the
		'resolver clamps anything below that to the sentinel itself
		m_Curvature = IIf(Value < -1, -1, Value)
		Refresh
	End Property

	Private Property Button.BorderThickness As Long
		Return m_BorderThickness
	End Property

	Private Property Button.BorderThickness(Value As Long)
		m_BorderThickness = Max(0, Value)
		Refresh
	End Property

	Private Property Button.FocusGap As Long
		Return m_FocusGap
	End Property

	Private Property Button.FocusGap(Value As Long)
		m_FocusGap = Max(0, Value)
		Refresh
		ApplyAutoSize
	End Property

	Private Property Button.FocusThickness As Long
		Return m_FocusThickness
	End Property

	Private Property Button.FocusThickness(Value As Long)
		m_FocusThickness = Max(0, Value)
		Refresh
		ApplyAutoSize
	End Property

	Private Property Button.BackColorHot As ULong
		Return m_BackColorHot
	End Property

	Private Property Button.BackColorHot(Value As ULong)
		m_BackColorHot = Value
		Refresh
	End Property

	Private Property Button.BackColorPressed As ULong
		Return m_BackColorPressed
	End Property

	Private Property Button.BackColorPressed(Value As ULong)
		m_BackColorPressed = Value
		Refresh
	End Property

	Private Property Button.BackColorDisabled As ULong
		Return m_BackColorDisabled
	End Property

	Private Property Button.BackColorDisabled(Value As ULong)
		m_BackColorDisabled = Value
		Refresh
	End Property

	Private Property Button.ForeColor As ULong
		Return m_ForeColor
	End Property

	Private Property Button.ForeColor(Value As ULong)
		m_ForeColor = Value
		Refresh
	End Property

	Private Property Button.ForeColorHot As ULong
		Return m_ForeColorHot
	End Property

	Private Property Button.ForeColorHot(Value As ULong)
		m_ForeColorHot = Value
		Refresh
	End Property

	Private Property Button.ForeColorPressed As ULong
		Return m_ForeColorPressed
	End Property

	Private Property Button.ForeColorPressed(Value As ULong)
		m_ForeColorPressed = Value
		Refresh
	End Property

	Private Property Button.ForeColorDisabled As ULong
		Return m_ForeColorDisabled
	End Property

	Private Property Button.ForeColorDisabled(Value As ULong)
		m_ForeColorDisabled = Value
		Refresh
	End Property

	Private Property Button.BorderColor As ULong
		Return m_BorderColor
	End Property

	Private Property Button.BorderColor(Value As ULong)
		m_BorderColor = Value
		Refresh
	End Property

	Private Property Button.BorderColorHot As ULong
		Return m_BorderColorHot
	End Property

	Private Property Button.BorderColorHot(Value As ULong)
		m_BorderColorHot = Value
		Refresh
	End Property

	Private Property Button.BorderColorPressed As ULong
		Return m_BorderColorPressed
	End Property

	Private Property Button.BorderColorPressed(Value As ULong)
		m_BorderColorPressed = Value
		Refresh
	End Property

	Private Property Button.BorderColorDisabled As ULong
		Return m_BorderColorDisabled
	End Property

	Private Property Button.BorderColorDisabled(Value As ULong)
		m_BorderColorDisabled = Value
		Refresh
	End Property

	Private Property Button.IconColor As ULong
		Return m_IconColor
	End Property

	Private Property Button.IconColor(Value As ULong)
		m_IconColor = Value
		Refresh
	End Property

	Private Property Button.IconColorHot As ULong
		Return m_IconColorHot
	End Property

	Private Property Button.IconColorHot(Value As ULong)
		m_IconColorHot = Value
		Refresh
	End Property

	Private Property Button.IconColorPressed As ULong
		Return m_IconColorPressed
	End Property

	Private Property Button.IconColorPressed(Value As ULong)
		m_IconColorPressed = Value
		Refresh
	End Property

	Private Property Button.IconColorDisabled As ULong
		Return m_IconColorDisabled
	End Property

	Private Property Button.IconColorDisabled(Value As ULong)
		m_IconColorDisabled = Value
		Refresh
	End Property

	Private Property Button.FocusRingColor As ULong
		Return m_FocusRingColor
	End Property

	Private Property Button.FocusRingColor(Value As ULong)
		m_FocusRingColor = Value
		Refresh
	End Property

	Private Property Button.DefaultBorderColor As ULong
		Return m_DefaultBorderColor
	End Property

	Private Property Button.DefaultBorderColor(Value As ULong)
		m_DefaultBorderColor = Value
		Refresh
	End Property

	'== Actions =============================================================================

	Private Sub Button.ApplyAutoSize()
		'Recompute the ideal size and, when opted in, take it. A no-op without
		'a handle: the first layout after allocation applies it.
		#ifdef __USE_WINAPI__
			If FHandle = 0 Then Exit Sub
		#elseif defined(__USE_GTK__)
			If widget = 0 Then Exit Sub
		#endif
		If m_AutoSize = False Then Exit Sub
		If bLayoutDirty Then LayoutButton()
	End Sub

	Private Sub Button.Click()
		'An ACTION, not a setter: refused on a disabled control exactly as a
		'real click would be. It reports, it does not animate.
		FireClick
	End Sub

	Private Sub Button.GetIdealSize(ByRef nWidth As Long, ByRef nHeight As Long)
		'Force a pending layout: the ideal size is computed inside it, ahead of
		'the zero-client bail, so the answer is valid before we are ever sized
		If bLayoutDirty Then LayoutButton()
		nWidth = nIdealW
		nHeight = nIdealH
	End Sub

	Private Function Button.GetRect(ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		If bLayoutDirty Then LayoutButton()
		If rcButton.Right <= rcButton.Left OrElse rcButton.Bottom <= rcButton.Top Then Return False
		rcLeft = rcButton.Left: rcTop = rcButton.Top: rcRight = rcButton.Right: rcBottom = rcButton.Bottom
		Return True
	End Function

	Private Function Button.GetTextRect(ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		If bLayoutDirty Then LayoutButton()
		'Empty is the honest answer for "no caption", and the query still succeeds
		rcLeft = rcText.Left: rcTop = rcText.Top: rcRight = rcText.Right: rcBottom = rcText.Bottom
		Return True
	End Function

	Private Function Button.GetIconLeftRect(ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		If bLayoutDirty Then LayoutButton()
		rcLeft = rcIconLeft.Left: rcTop = rcIconLeft.Top: rcRight = rcIconLeft.Right: rcBottom = rcIconLeft.Bottom
		Return True
	End Function

	Private Function Button.GetIconRightRect(ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		If bLayoutDirty Then LayoutButton()
		rcLeft = rcIconRight.Left: rcTop = rcIconRight.Top: rcRight = rcIconRight.Right: rcBottom = rcIconRight.Bottom
		Return True
	End Function

	Private Function Button.GetVisualRect(ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		If bLayoutDirty Then LayoutButton()
		If rcVisual.Right <= rcVisual.Left OrElse rcVisual.Bottom <= rcVisual.Top Then Return False
		rcLeft = rcVisual.Left: rcTop = rcVisual.Top: rcRight = rcVisual.Right: rcBottom = rcVisual.Bottom
		Return True
	End Function

	#ifndef ReadProperty_Off
		Private Function Button.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case PropertyName
			Case "IsDefault": Return @m_IsDefault
			Case "ID": Return @m_ID
			End Select
			Return Base.ReadProperty(PropertyName)
		End Function
	#endif

	#ifndef WriteProperty_Off
		Private Function Button.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			Select Case PropertyName
			Case "IsDefault": IsDefault = QBoolean(Value): Return True
			Case "ID": ID = QInteger(Value): Return True
			End Select
			Return Base.WriteProperty(PropertyName, Value)
		End Function
	#endif

	Private Operator Button.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator

	End Namespace
'#End Region