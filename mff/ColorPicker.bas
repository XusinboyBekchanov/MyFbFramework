'################################################################################
'#  ColorPicker.bas                                                             #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Liu XiaLin                                                         #
'#  Based on:                                                                   #
'#   PsColorPicker (Paul Squires, PlanetSquires Software, MPL 2.0)              #
'################################################################################

'#Region "Form"
	#include once "ColorPicker.bi"
	#include once "vbcompat.bi"

	Namespace My.Sys.Forms

	' ========================================================================================
	' THE WEB TABLE. The standard 137-entry named set in the order the platform colour
	' editors use - greys, then reds through yellows, greens, cyans, blues, purples, pinks -
	' rather than alphabetically, so the list scans for "something like this but darker".
	' The two duplicate names (Aqua = Cyan, Fuchsia = Magenta) are dropped. Parallel arrays,
	' per the PsColorPicker note on fbc array initialisers.
	' ========================================================================================
	Dim Shared As ZString * 21 gClrWebName(0 To 136) = { _
	    "Black"               , "DimGray"             , "Gray"                , "DarkGray", _
	    "Silver"              , "LightGray"           , "Gainsboro"           , "WhiteSmoke", _
	    "White"               , "RosyBrown"           , "IndianRed"           , "Brown", _
	    "Firebrick"           , "LightCoral"          , "Maroon"              , "DarkRed", _
	    "Red"                 , "Snow"                , "MistyRose"           , "Salmon", _
	    "Tomato"              , "DarkSalmon"          , "Coral"               , "OrangeRed", _
	    "LightSalmon"         , "Sienna"              , "SeaShell"            , "Chocolate", _
	    "SaddleBrown"         , "SandyBrown"          , "PeachPuff"           , "Peru", _
	    "Linen"               , "Bisque"              , "DarkOrange"          , "BurlyWood", _
	    "Tan"                 , "AntiqueWhite"        , "NavajoWhite"         , "BlanchedAlmond", _
	    "PapayaWhip"          , "Moccasin"            , "Orange"              , "Wheat", _
	    "OldLace"             , "FloralWhite"         , "DarkGoldenrod"       , "Cornsilk", _
	    "Goldenrod"           , "PaleGoldenrod"       , "Khaki"               , "LemonChiffon", _
	    "DarkKhaki"           , "Beige"               , "LightGoldenrodYellow", "Olive", _
	    "Yellow"              , "LightYellow"         , "Ivory"               , "OliveDrab", _
	    "YellowGreen"         , "DarkOliveGreen"      , "GreenYellow"         , "Chartreuse", _
	    "LawnGreen"           , "DarkSeaGreen"        , "ForestGreen"         , "LimeGreen", _
	    "LightGreen"          , "PaleGreen"           , "DarkGreen"           , "Green", _
	    "Lime"                , "Honeydew"            , "SeaGreen"            , "MediumSeaGreen", _
	    "SpringGreen"         , "MintCream"           , "MediumSpringGreen"   , "MediumAquamarine", _
	    "Aquamarine"          , "Turquoise"           , "LightSeaGreen"       , "MediumTurquoise", _
	    "DarkSlateGray"       , "PaleTurquoise"       , "Teal"                , "DarkCyan", _
	    "Cyan"                , "LightCyan"           , "Azure"               , "DarkTurquoise", _
	    "CadetBlue"           , "PowderBlue"          , "LightBlue"           , "DeepSkyBlue", _
	    "SkyBlue"             , "LightSkyBlue"        , "SteelBlue"           , "AliceBlue", _
	    "DodgerBlue"          , "SlateGray"           , "LightSlateGray"      , "LightSteelBlue", _
	    "CornflowerBlue"      , "RoyalBlue"           , "MidnightBlue"        , "Lavender", _
	    "Navy"                , "DarkBlue"            , "MediumBlue"          , "Blue", _
	    "GhostWhite"          , "SlateBlue"           , "DarkSlateBlue"       , "MediumSlateBlue", _
	    "MediumPurple"        , "BlueViolet"          , "Indigo"              , "DarkOrchid", _
	    "DarkViolet"          , "MediumOrchid"        , "Thistle"             , "Plum", _
	    "Violet"              , "Purple"              , "DarkMagenta"         , "Magenta", _
	    "Orchid"              , "MediumVioletRed"     , "DeepPink"            , "HotPink", _
	    "LavenderBlush"       , "PaleVioletRed"       , "Crimson"             , "Pink", _
	    "LightPink" }

	Dim Shared As ULong gClrWebColor(0 To 136) = { _
	    PRGB(  0,  0,  0)  , PRGB(105,105,105)  , PRGB(128,128,128)  , PRGB(169,169,169), _
	    PRGB(192,192,192)  , PRGB(211,211,211)  , PRGB(220,220,220)  , PRGB(245,245,245), _
	    PRGB(255,255,255)  , PRGB(188,143,143)  , PRGB(205, 92, 92)  , PRGB(165, 42, 42), _
	    PRGB(178, 34, 34)  , PRGB(240,128,128)  , PRGB(128,  0,  0)  , PRGB(139,  0,  0), _
	    PRGB(255,  0,  0)  , PRGB(255,250,250)  , PRGB(255,228,225)  , PRGB(250,128,114), _
	    PRGB(255, 99, 71)  , PRGB(233,150,122)  , PRGB(255,127, 80)  , PRGB(255, 69,  0), _
	    PRGB(255,160,122)  , PRGB(160, 82, 45)  , PRGB(255,245,238)  , PRGB(210,105, 30), _
	    PRGB(139, 69, 19)  , PRGB(244,164, 96)  , PRGB(255,218,185)  , PRGB(205,133, 63), _
	    PRGB(250,240,230)  , PRGB(255,228,196)  , PRGB(255,140,  0)  , PRGB(222,184,135), _
	    PRGB(210,180,140)  , PRGB(250,235,215)  , PRGB(255,222,173)  , PRGB(255,235,205), _
	    PRGB(255,239,213)  , PRGB(255,228,181)  , PRGB(255,165,  0)  , PRGB(245,222,179), _
	    PRGB(253,245,230)  , PRGB(255,250,240)  , PRGB(184,134, 11)  , PRGB(255,248,220), _
	    PRGB(218,165, 32)  , PRGB(238,232,170)  , PRGB(240,230,140)  , PRGB(255,250,205), _
	    PRGB(189,183,107)  , PRGB(245,245,220)  , PRGB(250,250,210)  , PRGB(128,128,  0), _
	    PRGB(255,255,  0)  , PRGB(255,255,224)  , PRGB(255,255,240)  , PRGB(107,142, 35), _
	    PRGB(154,205, 50)  , PRGB( 85,107, 47)  , PRGB(173,255, 47)  , PRGB(127,255,  0), _
	    PRGB(124,252,  0)  , PRGB(143,188,143)  , PRGB( 34,139, 34)  , PRGB( 50,205, 50), _
	    PRGB(144,238,144)  , PRGB(152,251,152)  , PRGB(  0,100,  0)  , PRGB(  0,128,  0), _
	    PRGB(  0,255,  0)  , PRGB(240,255,240)  , PRGB( 46,139, 87)  , PRGB( 60,179,113), _
	    PRGB(  0,255,127)  , PRGB(245,255,250)  , PRGB(  0,250,154)  , PRGB(102,205,170), _
	    PRGB(127,255,212)  , PRGB( 64,224,208)  , PRGB( 32,178,170)  , PRGB( 72,209,204), _
	    PRGB( 47, 79, 79)  , PRGB(175,238,238)  , PRGB(  0,128,128)  , PRGB(  0,139,139), _
	    PRGB(  0,255,255)  , PRGB(224,255,255)  , PRGB(240,255,255)  , PRGB(  0,206,209), _
	    PRGB( 95,158,160)  , PRGB(176,224,230)  , PRGB(173,216,230)  , PRGB(  0,191,255), _
	    PRGB(135,206,235)  , PRGB(135,206,250)  , PRGB( 70,130,180)  , PRGB(240,248,255), _
	    PRGB( 30,144,255)  , PRGB(112,128,144)  , PRGB(119,136,153)  , PRGB(176,196,222), _
	    PRGB(100,149,237)  , PRGB( 65,105,225)  , PRGB( 25, 25,112)  , PRGB(230,230,250), _
	    PRGB(  0,  0,128)  , PRGB(  0,  0,139)  , PRGB(  0,  0,205)  , PRGB(  0,  0,255), _
	    PRGB(248,248,255)  , PRGB(106, 90,205)  , PRGB( 72, 61,139)  , PRGB(123,104,238), _
	    PRGB(147,112,219)  , PRGB(138, 43,226)  , PRGB( 75,  0,130)  , PRGB(153, 50,204), _
	    PRGB(148,  0,211)  , PRGB(186, 85,211)  , PRGB(216,191,216)  , PRGB(221,160,221), _
	    PRGB(238,130,238)  , PRGB(128,  0,128)  , PRGB(139,  0,139)  , PRGB(255,  0,255), _
	    PRGB(218,112,214)  , PRGB(199, 21,133)  , PRGB(255, 20,147)  , PRGB(255,105,180), _
	    PRGB(255,240,245)  , PRGB(219,112,147)  , PRGB(220, 20, 60)  , PRGB(255,192,203), _
	    PRGB(255,182,193) }

	' ========================================================================================
	' Pure colour laws
	' ========================================================================================

	Private Sub ColorPicker.HSLtoRGB(ByVal h As Double, ByVal s As Double, ByVal l As Double, ByRef nR As Long, ByRef nG As Long, ByRef nB As Long)
		'Ported from PsColorPicker_HSLtoRGB
		Dim q As Double = IIf(l < 0.5, l * (1 + s), l + s - l * s)
		Dim p As Double = 2 * l - q
		Dim hk As Double = h
		If hk < 0 Then hk = 0
		If hk > 1 Then hk = 1
		Dim tR As Double = hk + 1.0 / 3.0
		Dim tG As Double = hk
		Dim tB As Double = hk - 1.0 / 3.0
		If tR < 0 Then tR += 1
		If tR > 1 Then tR -= 1
		If tG < 0 Then tG += 1
		If tG > 1 Then tG -= 1
		If tB < 0 Then tB += 1
		If tB > 1 Then tB -= 1
		If tR < 1.0 / 6.0 Then
			tR = p + (q - p) * 6 * tR
		ElseIf tR < 0.5 Then
			tR = q
		ElseIf tR < 2.0 / 3.0 Then
			tR = p + (q - p) * (2.0 / 3.0 - tR) * 6
		Else
			tR = p
		End If
		If tG < 1.0 / 6.0 Then
			tG = p + (q - p) * 6 * tG
		ElseIf tG < 0.5 Then
			tG = q
		ElseIf tG < 2.0 / 3.0 Then
			tG = p + (q - p) * (2.0 / 3.0 - tG) * 6
		Else
			tG = p
		End If
		If tB < 1.0 / 6.0 Then
			tB = p + (q - p) * 6 * tB
		ElseIf tB < 0.5 Then
			tB = q
		ElseIf tB < 2.0 / 3.0 Then
			tB = p + (q - p) * (2.0 / 3.0 - tB) * 6
		Else
			tB = p
		End If
		nR = CInt(tR * 255)
		nG = CInt(tG * 255)
		nB = CInt(tB * 255)
		If nR < 0 Then nR = 0
		If nR > 255 Then nR = 255
		If nG < 0 Then nG = 0
		If nG > 255 Then nG = 255
		If nB < 0 Then nB = 0
		If nB > 255 Then nB = 255
	End Sub

	'THE MATRIX'S COLOUR LAW: column = hue, row = lightness, last column = greyscale.
	'  l = 1 - (row + 0.5) / rows   (top row near-white tint, bottom near-black shade;
	'                                pure white/black live in the greyscale column)
	'  h = col / (cols - 1)         over the chromatic columns only, so hue 0 appears once
	'A law, not a table: a host that resizes the matrix gets a finer sweep of the same colours.
	Private Function ColorPicker.MatrixColorAt(ByVal nCol As Long, ByVal nRow As Long, ByVal nCols As Long, ByVal nRows As Long) As ULong
		If nCols < 2 Then nCols = 2
		If nRows < 1 Then nRows = 1
		If nCol < 0 Then nCol = 0
		If nCol > nCols - 1 Then nCol = nCols - 1
		If nRow < 0 Then nRow = 0
		If nRow > nRows - 1 Then nRow = nRows - 1
		Dim lum As Double = 1.0 - ((CDbl(nRow) + 0.5) / CDbl(nRows))
		Dim nR As Long, nG As Long, nB As Long
		If nCol = nCols - 1 Then
			HSLtoRGB(0.0, 0.0, lum, nR, nG, nB)
		Else
			HSLtoRGB(CDbl(nCol) / CDbl(nCols - 1), 1.0, lum, nR, nG, nB)
		End If
		Return PRGB(nR, nG, nB)
	End Function

	Private Function ColorPicker.WebColorCount() As Long
		Return 137
	End Function

	Private Function ColorPicker.WebColorAt(ByVal idx As Long) As ULong
		If idx < 0 OrElse idx > 136 Then Return 0
		Return gClrWebColor(idx)
	End Function

	Private Function ColorPicker.WebColorName(ByVal idx As Long) As WString
		If idx < 0 OrElse idx > 136 Then Return ""
		Return WStr(gClrWebName(idx))
	End Function

	'Measures a label on a PRIVATE canvas: measuring through This.Canvas during
	'an active paint session would clobber the paint device
	Private Function ColorPicker.TextWidthOf(ByRef Value As WString) As Long
		#ifdef __USE_GTK__
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
			Canvas.Font = This.Font
			Return Canvas.TextWidth(Value)
		#else
			Dim cv As My.Sys.Drawing.Canvas
			cv.Ctrl = @This
			cv.Font = This.Font
			Return cv.TextWidth(Value)
		#endif
	End Function

	' ========================================================================================
	' Geometry
	' ========================================================================================

	Private Function ColorPicker.GetWindowsDPI() As Double
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

	Private Sub ColorPicker.BodyRects
		'rcBody must already be set; fills rcMatrix / rcList / rcScroll for the tab
		Dim nScaleCellW As Long = COLORPICKER_CELL_W * nScale
		Dim nScaleCellH As Long = COLORPICKER_CELL_H * nScale
		Dim nScaleSwatchW As Long = COLORPICKER_SWATCH_W * nScale
		Dim nScaleRowH As Long = COLORPICKER_ROW_H * nScale
		Dim nScaleScrollW As Long = COLORPICKER_SCROLL_W * nScale
		If m_Tab = cpTabCustom Then
			rcMatrix = rcBody
			rcList.Left = 0: rcList.Top = 0: rcList.Right = 0: rcList.Bottom = 0
			rcScroll.Left = 0: rcScroll.Top = 0: rcScroll.Right = 0: rcScroll.Bottom = 0
		Else
			rcMatrix.Left = 0: rcMatrix.Top = 0: rcMatrix.Right = 0: rcMatrix.Bottom = 0
			rcList = rcBody
			rcList.Right -= nScaleScrollW
			rcScroll.Left = rcBody.Right - nScaleScrollW
			rcScroll.Top = rcBody.Top
			rcScroll.Right = rcBody.Right
			rcScroll.Bottom = rcBody.Bottom
			'Thumb position from the scroll index
			Dim nCount As Long = WebColorCount()
			Dim visible As Long = (rcList.Bottom - rcList.Top) \ nScaleRowH
			If visible < 1 Then visible = 1
			Dim nMax As Long = nCount - visible
			If nMax < 0 Then nMax = 0
			Dim trackH As Long = rcScroll.Bottom - rcScroll.Top
			Dim thumbH As Long = trackH
			If nCount > 0 AndAlso visible < nCount Then thumbH = trackH * visible \ nCount
			If thumbH < nScaleScrollW Then thumbH = nScaleScrollW
			Dim thumbY As Long = rcScroll.Top
			If nMax > 0 Then thumbY = rcScroll.Top + (trackH - thumbH) * m_ScrollTop \ nMax
			rcScrollThumb.Left = rcScroll.Left
			rcScrollThumb.Top = thumbY
			rcScrollThumb.Right = rcScroll.Right
			rcScrollThumb.Bottom = thumbY + thumbH
		End If
	End Sub

	Private Sub ColorPicker.LayoutPicker
		bLayoutDirty = False

		Dim clientW As Long = ScaleX(This.ClientWidth)
		Dim clientH As Long = ScaleY(This.ClientHeight)
		If clientW <= 0 OrElse clientH <= 0 Then
			bLayoutDirty = True
			Exit Sub
		End If

		Dim nScalePad As Long = COLORPICKER_PAD * nScale
		Dim nScaleGap As Long = COLORPICKER_GAP * nScale
		Dim nScaleTabH As Long = COLORPICKER_TAB_H * nScale
		Dim nScaleRowH As Long = COLORPICKER_ROW_H * nScale
		Dim nScalePreviewW As Long = COLORPICKER_PREVIEW_W * nScale
		Dim nScalePreviewH As Long = COLORPICKER_PREVIEW_H * nScale
		Dim nScaleFieldW As Long = COLORPICKER_FIELD_W * nScale
		Dim nScaleFieldH As Long = COLORPICKER_FIELD_H * nScale
		Dim nScaleLabelW As Long = COLORPICKER_LABEL_W * nScale
		Dim nScaleOKW As Long = COLORPICKER_OK_W * nScale
		Dim nScaleOKH As Long = COLORPICKER_OK_H * nScale

		Dim y As Long = nScalePad

		'---- the tab strip (sized to its text, left-aligned) -----------------------
		rcTabs.Left = nScalePad
		rcTabs.Top = y
		rcTabs.Right = clientW - nScalePad
		rcTabs.Bottom = y + nScaleTabH
		Canvas.Font = This.Font
		For i As Long = 0 To 1
			m_TabTextW(i) = ScaleX(TextWidthOf(IIf(i = cpTabWeb, "Web", "Custom"))) + COLORPICKER_TAB_PAD * 2 * nScale
		Next
		y = rcTabs.Bottom + nScaleGap

		'---- the body (fixed height across all tabs) -------------------------------
		rcBody.Left = nScalePad
		rcBody.Top = y
		rcBody.Right = clientW - nScalePad
		rcBody.Bottom = y + COLORPICKER_LIST_ROWS * nScaleRowH
		BodyRects
		y = rcBody.Bottom + nScaleGap

		'---- the footer: the preview block left, the fields right ------------------
		'Initial label + split box + Current label
		rcInitialLabel.Left = nScalePad
		rcInitialLabel.Top = y
		rcInitialLabel.Right = nScalePad + nScalePreviewW
		rcInitialLabel.Bottom = y + nScaleRowH
		rcPreview.Left = nScalePad
		rcPreview.Top = rcInitialLabel.Bottom
		rcPreview.Right = rcPreview.Left + nScalePreviewW
		rcPreview.Bottom = rcPreview.Top + nScalePreviewH * 2
		rcInitial = rcPreview
		rcInitial.Bottom = rcPreview.Top + nScalePreviewH
		rcCurrent = rcPreview
		rcCurrent.Top = rcInitial.Bottom
		rcCurrentLabel.Left = nScalePad
		rcCurrentLabel.Top = rcPreview.Bottom
		rcCurrentLabel.Right = rcInitialLabel.Right
		rcCurrentLabel.Bottom = rcCurrentLabel.Top + nScaleRowH

		'The fields, one per row, to the right of the preview
		Dim fx As Long = rcPreview.Right + nScaleGap
		Dim nVisibleFields As Long = IIf(m_ShowAlpha, cpFieldCount, cpFieldCount - 1)
		Dim fy As Long = y + (rcCurrentLabel.Bottom - y - nVisibleFields * nScaleFieldH - (nVisibleFields - 1) * (nScaleGap \ 2)) \ 2
		If fy < y Then fy = y
		For i As Long = 0 To cpFieldCount - 1
			rcFieldLabel(i).Left = fx
			rcFieldLabel(i).Top = fy
			rcFieldLabel(i).Right = fx + nScaleLabelW
			rcFieldLabel(i).Bottom = fy + nScaleFieldH
			rcField(i).Left = rcFieldLabel(i).Right
			rcField(i).Top = fy
			rcField(i).Right = rcField(i).Left + nScaleFieldW
			rcField(i).Bottom = fy + nScaleFieldH
			fy += nScaleFieldH + nScaleGap \ 2
		Next
		rcFields.Left = fx
		rcFields.Top = y
		rcFields.Right = clientW - nScalePad
		rcFields.Bottom = rcCurrentLabel.Bottom

		y = rcCurrentLabel.Bottom + nScaleGap

		'---- the OK button: the only commit path, at the right edge ----------------
		rcOK.Left = clientW - nScalePad - nScaleOKW
		rcOK.Top = y
		rcOK.Right = clientW - nScalePad
		rcOK.Bottom = y + nScaleOKH
	End Sub

	Private Sub ColorPicker.GetIdealSize(ByRef nWidth As Long, ByRef nHeight As Long)
		'Computed straight from the scalars, valid before the control is sized
		Dim contentW As Long = COLORPICKER_MATRIX_COLS * COLORPICKER_CELL_W
		Dim bodyH As Long = COLORPICKER_LIST_ROWS * COLORPICKER_ROW_H
		Dim footerH As Long = COLORPICKER_ROW_H + COLORPICKER_PREVIEW_H * 2 + COLORPICKER_ROW_H
		nWidth = contentW + COLORPICKER_PAD * 2
		nHeight = COLORPICKER_PAD + COLORPICKER_TAB_H + COLORPICKER_GAP + bodyH + COLORPICKER_GAP + footerH + COLORPICKER_GAP + COLORPICKER_OK_H + COLORPICKER_PAD
	End Sub

	' ========================================================================================
	' Painting
	' ========================================================================================

	Private Function ColorPicker.ARGB(clr As ULong, Opacity As Long = 100) As ULong
		#ifdef __USE_WINAPI__
			Return (Cast(ULong, Opacity / 100 * 255) Shl 24) Or (GetRed(clr) Shl 16) Or (GetGreen(clr) Shl 8) Or GetBlue(clr)
		#else
			Return clr
		#endif
	End Function

	Private Sub ColorPicker.FillRectPath(ByVal x As Long, ByVal y As Long, ByVal w As Long, ByVal h As Long, clr As ULong)
		If w <= 0 OrElse h <= 0 Then Exit Sub
		Canvas.PathStart
		Canvas.PathRoundRect(x, y, w, h, 0)
		Canvas.FillPath(ARGB(clr), 100)
		Canvas.PathDiscard
	End Sub

	Private Sub ColorPicker.StrokeRectPath(ByVal x As Long, ByVal y As Long, ByVal w As Long, ByVal h As Long, clr As ULong, ByVal PenWidth As Single = 1)
		If w <= 0 OrElse h <= 0 Then Exit Sub
		Canvas.PathStart
		Canvas.PathRoundRect(x + 0.5, y + 0.5, w - 1, h - 1, 0)
		Canvas.StrokePath(ARGB(clr), PenWidth, 100)
		Canvas.PathDiscard
	End Sub

	Private Sub ColorPicker.DrawMatrix
		Dim nCols As Long = COLORPICKER_MATRIX_COLS
		Dim nRows As Long = COLORPICKER_MATRIX_ROWS
		Dim nScaleCellW As Long = COLORPICKER_CELL_W * nScale
		Dim nScaleCellH As Long = COLORPICKER_CELL_H * nScale
		For r As Long = 0 To nRows - 1
			For c As Long = 0 To nCols - 1
				Dim x As Long = rcMatrix.Left + c * nScaleCellW
				Dim yy As Long = rcMatrix.Top + r * nScaleCellH
				Dim cellClr As ULong = MatrixColorAt(c, r, nCols, nRows)
				Canvas.PathStart
				Canvas.PathRoundRect(x, yy, nScaleCellW, nScaleCellH, COLORPICKER_CURVATURE * nScale)
				Canvas.FillPath(ARGB(cellClr), 100)
				Canvas.PathDiscard
				'The selection ring, inset so it reads as being ON the swatch
				Dim idx As Long = r * nCols + c
				If idx = m_BodySel Then
					StrokeRectPath(x + COLORPICKER_RING_INSET, yy + COLORPICKER_RING_INSET, nScaleCellW - COLORPICKER_RING_INSET * 2, nScaleCellH - COLORPICKER_RING_INSET * 2, m_SelRingColor, 2)
				ElseIf idx = m_HotSwatch Then
					StrokeRectPath(x + COLORPICKER_RING_INSET, yy + COLORPICKER_RING_INSET, nScaleCellW - COLORPICKER_RING_INSET * 2, nScaleCellH - COLORPICKER_RING_INSET * 2, m_HotRingColor, 1)
				End If
			Next
		Next
	End Sub

	Private Sub ColorPicker.DrawList
		Dim nScaleSwatchW As Long = COLORPICKER_SWATCH_W * nScale
		Dim nScaleRowH As Long = COLORPICKER_ROW_H * nScale
		Dim nScaleRingIn As Long = COLORPICKER_RING_INSET
		Dim visible As Long = (rcList.Bottom - rcList.Top) \ nScaleRowH
		If visible < 1 Then visible = 1

		'Bring the selected row into view. NO repaint here: this runs inside a
		'paint, so adjust the scroll and refresh the thumb rect in place - a
		'nested Refresh inside WM_PAINT re-enters the paint session (flicker,
		'sometimes a blank body)
		If m_BodySel >= 0 Then
			If m_BodySel < m_ScrollTop Then
				SetScrollTop(m_BodySel, False)
				BodyRects
			ElseIf m_BodySel >= m_ScrollTop + visible Then
				SetScrollTop(m_BodySel - visible + 1, False)
				BodyRects
			End If
		End If

		Canvas.Font = This.Font
		For k As Long = 0 To visible - 1
			Dim idx As Long = m_ScrollTop + k
			If idx >= WebColorCount() Then Exit For
			Dim yy As Long = rcList.Top + k * nScaleRowH
			'The swatch, then the name
			Dim swX As Long = rcList.Left
			Dim swY As Long = yy + (nScaleRowH - (nScaleRowH - 4)) \ 2
			Dim swH As Long = nScaleRowH - 4
			Canvas.PathStart
			Canvas.PathRoundRect(swX, swY, nScaleSwatchW, swH, COLORPICKER_CURVATURE * nScale)
			Canvas.FillPath(ARGB(WebColorAt(idx)), 100)
			Canvas.PathDiscard
			If idx = m_BodySel Then
				StrokeRectPath(swX + nScaleRingIn, swY + nScaleRingIn, nScaleSwatchW - nScaleRingIn * 2, swH - nScaleRingIn * 2, m_SelRingColor, 2)
			ElseIf idx = m_HotSwatch Then
				StrokeRectPath(swX + nScaleRingIn, swY + nScaleRingIn, nScaleSwatchW - nScaleRingIn * 2, swH - nScaleRingIn * 2, m_HotRingColor, 1)
			End If
			Dim clrName As ULong = m_ForeColor
			If idx = m_BodySel Then clrName = m_TabForeColorSel
			Canvas.TextOut(swX + nScaleSwatchW + 6 * nScale, yy + (nScaleRowH - ScaleY(Canvas.TextHeight(WebColorName(idx)))) \ 2, WebColorName(idx), clrName, -1)
		Next

		'The in-control scrollbar: track + thumb (keeps the popup child-free)
		FillRectPath(rcScroll.Left, rcScroll.Top, rcScroll.Right - rcScroll.Left, rcScroll.Bottom - rcScroll.Top, m_FieldBackColor)
		FillRectPath(rcScrollThumb.Left, rcScrollThumb.Top, rcScrollThumb.Right - rcScrollThumb.Left, rcScrollThumb.Bottom - rcScrollThumb.Top, m_TabBackColorSel)
		StrokeRectPath(rcScroll.Left, rcScroll.Top, rcScroll.Right - rcScroll.Left, rcScroll.Bottom - rcScroll.Top, m_BorderColor, 1)
	End Sub

	Private Sub ColorPicker.DrawFooter
		'The Initial/Current labels
		Canvas.Font = This.Font
		Canvas.TextOut(rcInitialLabel.Left, rcInitialLabel.Top, *m_TextInitial, m_ForeColor, -1)
		Canvas.TextOut(rcCurrentLabel.Left, rcCurrentLabel.Top, *m_TextCurrent, m_ForeColor, -1)

		'The split box: the alpha of each half is drawn as opacity over the chrome
		Canvas.PathStart
		Canvas.PathRoundRect(rcInitial.Left, rcInitial.Top, rcInitial.Right - rcInitial.Left, rcInitial.Bottom - rcInitial.Top, COLORPICKER_CURVATURE * nScale)
		Canvas.FillPath(ARGB(m_InitialColor), m_InitialAlpha * 100 \ 255)
		Canvas.StrokePath(ARGB(m_BorderColor), 1, 100)
		Canvas.PathDiscard
		Canvas.PathStart
		Canvas.PathRoundRect(rcCurrent.Left, rcCurrent.Top, rcCurrent.Right - rcCurrent.Left, rcCurrent.Bottom - rcCurrent.Top, COLORPICKER_CURVATURE * nScale)
		Canvas.FillPath(ARGB(m_Color), m_Alpha * 100 \ 255)
		Canvas.StrokePath(ARGB(m_BorderColor), 1, 100)
		Canvas.PathDiscard

		'The fields
		For i As Long = 0 To cpFieldCount - 1
			If m_ShowAlpha = False AndAlso i = cpFieldA Then Exit For
			Dim sLabel As WString = *m_TextField(i)
			Canvas.TextOut(rcFieldLabel(i).Left, rcFieldLabel(i).Top + ((rcFieldLabel(i).Bottom - rcFieldLabel(i).Top) - ScaleY(Canvas.TextHeight(sLabel))) \ 2, sLabel, m_ForeColor, -1)
			FillRectPath(rcField(i).Left, rcField(i).Top, rcField(i).Right - rcField(i).Left, rcField(i).Bottom - rcField(i).Top, m_FieldBackColor)
			StrokeRectPath(rcField(i).Left, rcField(i).Top, rcField(i).Right - rcField(i).Left, rcField(i).Bottom - rcField(i).Top, IIf(i = m_FocusField, m_FieldBorderColorSel, m_FieldBorderColor), 1)
			Dim sText As String = IIf(i = m_FocusField, m_Edit, ChannelText(i))
			Canvas.TextOut(rcField(i).Left + 4 * nScale, rcField(i).Top + ((rcField(i).Bottom - rcField(i).Top) - ScaleY(Canvas.TextHeight(WStr(sText)))) \ 2, WStr(sText), m_FieldForeColor, -1)
			'The caret, only while this field is focused and the blink is on
			If i = m_FocusField AndAlso m_CaretOn Then
				Dim cx As Long = rcField(i).Left + 4 * nScale + ScaleX(Canvas.TextWidth(WStr(Mid(sText, 1, m_Caret))))
				Canvas.PathStart
				Canvas.PathMoveTo(cx, rcField(i).Top + 3 * nScale)
				Canvas.PathLineTo(cx, rcField(i).Bottom - 3 * nScale)
				Canvas.StrokePath(ARGB(m_FieldForeColor), 1, 100)
				Canvas.PathDiscard
			End If
		Next
	End Sub

	Private Sub ColorPicker.Draw
		On Error Goto ErrorHandler

		If bLayoutDirty Then LayoutPicker

		'---- the background and the border ----------------------------------------
		Dim backClr As ULong = m_ChromeBackColor
		If backClr = Cast(ULong, -1) Then backClr = GetSysColor(COLOR_BTNFACE)
		FillRectPath(0, 0, ScaleX(This.ClientWidth), ScaleY(This.ClientHeight), backClr)
		StrokeRectPath(0, 0, ScaleX(This.ClientWidth), ScaleY(This.ClientHeight), m_BorderColor, 1)

		'---- the tab strip ----------------------------------------------------------
		Canvas.Font = This.Font
		Dim x As Long = rcTabs.Left
		For i As Long = 0 To 1
			Dim sCaption As WString = IIf(i = cpTabWeb, "Web", "Custom")
			Dim tw As Long = m_TabTextW(i)
			If i = m_Tab Then
				FillRectPath(x, rcTabs.Top, tw, rcTabs.Bottom - rcTabs.Top, m_TabBackColorSel)
			ElseIf i = m_HotTab Then
				FillRectPath(x, rcTabs.Top, tw, rcTabs.Bottom - rcTabs.Top, m_TabBackColorSel)
			End If
			Dim clrTab As ULong = IIf(i = m_Tab, m_TabForeColorSel, m_TabForeColor)
			Canvas.TextOut(x + COLORPICKER_TAB_PAD * nScale, rcTabs.Top + ((rcTabs.Bottom - rcTabs.Top) - ScaleY(Canvas.TextHeight(sCaption))) \ 2, sCaption, clrTab, -1)
			x += tw
		Next

		'---- the body ---------------------------------------------------------------
		If m_Tab = cpTabCustom Then
			DrawMatrix
		Else
			DrawList
		End If

		'---- the footer and the OK button --------------------------------------------
		DrawFooter
		Dim clrOK As ULong = m_OKBackColor
		If m_OKPressed Then
			clrOK = m_OKBackColorPressed
		ElseIf m_OKHot Then
			clrOK = m_OKBackColorHot
		End If
		Canvas.PathStart
		Canvas.PathRoundRect(rcOK.Left, rcOK.Top, rcOK.Right - rcOK.Left, rcOK.Bottom - rcOK.Top, COLORPICKER_CURVATURE * nScale)
		Canvas.FillPath(ARGB(clrOK), 100)
		Canvas.StrokePath(ARGB(m_OKBorderColor), 1, 100)
		Canvas.PathDiscard
		Canvas.TextOut(rcOK.Left + ((rcOK.Right - rcOK.Left) - ScaleX(Canvas.TextWidth(*m_TextOK))) \ 2, rcOK.Top + ((rcOK.Bottom - rcOK.Top) - ScaleY(Canvas.TextHeight(*m_TextOK))) \ 2, *m_TextOK, m_OKForeColor, -1)

		Exit Sub
		ErrorHandler:
		MsgBox ErrDescription(Err) & " (" & Err & ") " & _
		"in line " & Erl() & " (Handler line: " & __LINE__ & ") " & _
		"in function " & ZGet(Erfn()) & " (Handler function: " & __FUNCTION__ & ") " & _
		"in module " & ZGet(Ermn()) & " (Handler file: " & __FILE__ & ") "
	End Sub

	' ========================================================================================
	' Value plumbing
	' ========================================================================================

	Private Function ColorPicker.ChannelText(ByVal idx As Long) As String
		Select Case idx
		Case cpFieldR: Return Str(m_Color And 255)
		Case cpFieldG: Return Str((m_Color Shr 8) And 255)
		Case cpFieldB: Return Str((m_Color Shr 16) And 255)
		Case cpFieldA: Return Str(m_Alpha)
		End Select
		Return ""
	End Function

	Private Sub ColorPicker.SyncBodySel
		'Which cell of the current tab's body is the current colour, or -1. One
		'field, re-derived whenever the colour or the tab changes: a colour that
		'is not on the current tab lights up nothing, the honest answer.
		m_BodySel = -1
		If m_Tab = cpTabWeb Then
			For i As Long = 0 To WebColorCount() - 1
				If WebColorAt(i) = m_Color Then
					m_BodySel = i
					Exit For
				End If
			Next
		Else
			Dim nCol As Long, nRow As Long
			If MatrixIndexOf(m_Color, nCol, nRow) Then
				m_BodySel = nRow * COLORPICKER_MATRIX_COLS + nCol
			End If
		End If
	End Sub

	Private Sub ColorPicker.SetColorInternal(ByVal clr As ULong, ByVal nPhase As Long)
		m_Color = clr
		SyncBodySel
		Refresh
		If OnColorChanged Then OnColorChanged(*Designer, This, m_Color, m_Alpha, nPhase)
	End Sub

	Private Sub ColorPicker.SetScrollTop(ByVal Value As Long, ByVal bRepaint As Boolean = True)
		Dim visible As Long = (rcList.Bottom - rcList.Top) \ (COLORPICKER_ROW_H * nScale)
		If visible < 1 Then visible = 1
		Dim nMax As Long = WebColorCount() - visible
		If nMax < 0 Then nMax = 0
		If Value > nMax Then Value = nMax
		If Value < 0 Then Value = 0
		If Value <> m_ScrollTop Then
			m_ScrollTop = Value
			'NO repaint when called from inside Draw: the paint in flight will
			'pick the new scroll up, and a nested Refresh inside WM_PAINT
			're-enters the paint session (flicker, sometimes a blank body)
			If bRepaint Then Refresh
		End If
	End Sub

	Private Function ColorPicker.ListRowCount As Long
		Return (rcList.Bottom - rcList.Top) \ (COLORPICKER_ROW_H * nScale)
	End Function

	Private Function ColorPicker.MatrixIndexOf(ByVal clr As ULong, ByRef nCol As Long, ByRef nRow As Long) As Boolean
		nCol = -1: nRow = -1
		For r As Long = 0 To COLORPICKER_MATRIX_ROWS - 1
			For c As Long = 0 To COLORPICKER_MATRIX_COLS - 1
				If MatrixColorAt(c, r, COLORPICKER_MATRIX_COLS, COLORPICKER_MATRIX_ROWS) = clr Then
					nCol = c: nRow = r
					Return True
				End If
			Next
		Next
		Return False
	End Function

	Private Function ColorPicker.CellFromPoint(ByVal x As Long, ByVal y As Long, ByRef rc As ColorPickerRect, ByVal nCols As Long, ByRef nCol As Long, ByRef nRow As Long) As Boolean
		'Point -> cell, a plain division because the grid is an exact multiple of
		'the cell size - this is what stops the hit test and the painter disagreeing
		nCol = -1: nRow = -1
		Dim w As Long = rc.Right - rc.Left
		If x < rc.Left OrElse y < rc.Top OrElse x >= rc.Right OrElse y >= rc.Bottom Then Return False
		nCol = (x - rc.Left) * nCols \ w
		nRow = (y - rc.Top) \ (COLORPICKER_CELL_H * nScale)
		If nRow < 0 Then nRow = 0
		If nRow > COLORPICKER_MATRIX_ROWS - 1 Then nRow = COLORPICKER_MATRIX_ROWS - 1
		Return nCol >= 0 AndAlso nRow >= 0
	End Function

	' ========================================================================================
	' Field editing. One buffer: entering a field seeds it from the value, the
	' first accepted character replaces it wholesale (select-all-on-entry without
	' a selection model), leaving commits it.
	' ========================================================================================

	Private Function ColorPicker.EnterField(ByVal idx As Long) As Boolean
		If idx < 0 OrElse idx >= cpFieldCount Then Return False
		If m_ShowAlpha = False AndAlso idx = cpFieldA Then Return False
		If m_FocusField = idx Then Return True
		If m_FocusField >= 0 Then CommitField
		m_FocusField = idx
		m_Edit = ChannelText(idx)
		m_EditFresh = True
		m_Caret = Len(m_Edit)
		m_CaretOn = True
		tmrCaret.Interval = COLORPICKER_CARET_MS
		Refresh
		Return True
	End Function

	Private Sub ColorPicker.CommitField
		If m_FocusField < 0 Then Exit Sub
		Dim sTmp As String = m_Edit
		Dim v As Long = CLng(Val(Trim(sTmp)))
		If v < 0 Then v = 0
		If v > 255 Then v = 255
		Select Case m_FocusField
		Case cpFieldR: m_Color = (m_Color And &HFFFF00) Or v
		Case cpFieldG: m_Color = (m_Color And &HFF00FF) Or (v Shl 8)
		Case cpFieldB: m_Color = (m_Color And &HFFFF) Or (v Shl 16)
		Case cpFieldA: m_Alpha = v
		End Select
		m_FocusField = -1
		m_CaretOn = False
		tmrCaret.Interval = 0
		SyncBodySel
		Refresh
		If OnColorChanged Then OnColorChanged(*Designer, This, m_Color, m_Alpha, cpPhaseEnd)
	End Sub

	'Key handling in VK terms (Windows WM_KEYDOWN / GTK keyval mapped by the
	'GTK glue). Printable digits come through HandleChar instead on Windows.
	Private Function ColorPicker.KeyEdit(KeyCode As Long) As Boolean
		If m_FocusField < 0 Then Return False
		Select Case KeyCode
		Case 8 'Backspace
			m_EditFresh = False
			If m_Caret > 0 AndAlso Len(m_Edit) > 0 Then
				m_Edit = Mid(m_Edit, 1, m_Caret - 1) & Mid(m_Edit, m_Caret + 1)
				m_Caret -= 1
			End If
			Refresh
			Return True
		Case 46 'Delete
			m_EditFresh = False
			If m_Caret < Len(m_Edit) Then
				m_Edit = Mid(m_Edit, 1, m_Caret) & Mid(m_Edit, m_Caret + 2)
			End If
			Refresh
			Return True
		Case 37 'Left
			m_EditFresh = False
			If m_Caret > 0 Then m_Caret -= 1
			Refresh
			Return True
		Case 39 'Right
			m_EditFresh = False
			If m_Caret < Len(m_Edit) Then m_Caret += 1
			Refresh
			Return True
		Case 36 'Home
			m_EditFresh = False
			m_Caret = 0
			Refresh
			Return True
		Case 35 'End
			m_EditFresh = False
			m_Caret = Len(m_Edit)
			Refresh
			Return True
		Case 13 'Return: commit
			CommitField
			Return True
		Case 9 'Tab: commit and walk to the next field (the order is the contract)
			Dim cur As Long = m_FocusField
			CommitField
			Dim nxt As Long = cur
			Dim i As Long
			For i = 1 To cpFieldCount
				nxt += 1
				If nxt >= cpFieldCount Then nxt = 0
				If m_ShowAlpha OrElse nxt <> cpFieldA Then Exit For
			Next
			EnterField(nxt)
			Return True
		Case 27 'Esc: the modal shell cancels
			If OnCancel Then OnCancel(*Designer, This)
			Return True
		End Select
		Return False
	End Function

	Private Sub ColorPicker.SetHotTab(ByVal idx As Long)
		If idx <> m_HotTab Then
			m_HotTab = idx
			Refresh
		End If
	End Sub

	Private Sub ColorPicker.SetHotSwatch(ByVal idx As Long)
		If idx <> m_HotSwatch Then
			m_HotSwatch = idx
			Refresh
		End If
	End Sub

	Private Sub ColorPicker.SetHotField(ByVal idx As Long)
		If idx <> m_HotField Then
			m_HotField = idx
			Refresh
		End If
	End Sub

	Private Sub ColorPicker.CancelOKPress
		m_OKPressed = False
	End Sub

	' ========================================================================================
	' Hit helpers (device pixels)
	' ========================================================================================

	Private Function ColorPicker.HitTestField(ByVal x As Long, ByVal y As Long) As Long
		For i As Long = 0 To cpFieldCount - 1
			If m_ShowAlpha = False AndAlso i = cpFieldA Then Exit For
			If x >= rcField(i).Left AndAlso x < rcField(i).Right AndAlso y >= rcField(i).Top AndAlso y < rcField(i).Bottom Then Return i
		Next
		Return -1
	End Function

	Private Function ColorPicker.TabFromPoint(ByVal x As Long, ByVal y As Long) As Long
		If y < rcTabs.Top OrElse y >= rcTabs.Bottom Then Return -1
		Dim xk As Long = rcTabs.Left
		For i As Long = 0 To 1
			If x >= xk AndAlso x < xk + m_TabTextW(i) Then Return i
			xk += m_TabTextW(i)
		Next
		Return -1
	End Function

	' ========================================================================================
	' Timers / refresh
	' ========================================================================================

	Private Sub ColorPicker.tmrHotTrack_Timer_(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent)
		QColorPicker(Sender.Designer).tmrHotTrack_Timer(Sender)
	End Sub

	Private Sub ColorPicker.tmrHotTrack_Timer(ByRef Sender As TimerComponent)
		#ifdef __USE_WINAPI__
			If FHandle = 0 Then Exit Sub
			Dim pt As POINT
			GetCursorPos(@pt)
			'the raw API: Control.ScreenToClient (MFF Point) shadows the name here
			..ScreenToClient(FHandle, @pt)
			'If the cursor left, clear every hot state (the safety net)
			Dim rc As RECT
			GetClientRect(FHandle, @rc)
			Dim bInside As Boolean = pt.x >= rc.Left AndAlso pt.x < rc.Right AndAlso pt.y >= rc.Top AndAlso pt.y < rc.Bottom
			If bInside = False Then
				SetHotTab(-1)
				SetHotSwatch(-1)
				SetHotField(-1)
				If m_OKHot Then
					m_OKHot = False
					Refresh
				End If
			End If
		#endif
	End Sub

	Private Sub ColorPicker.tmrCaret_Timer_(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent)
		QColorPicker(Sender.Designer).tmrCaret_Timer(Sender)
	End Sub

	Private Sub ColorPicker.tmrCaret_Timer(ByRef Sender As TimerComponent)
		If m_FocusField >= 0 Then
			m_CaretOn = Not m_CaretOn
			Refresh
		End If
	End Sub

	Private Sub ColorPicker.Refresh
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

	' ========================================================================================
	' Interaction
	' ========================================================================================

	Private Sub ColorPicker.MouseDownAt(ByVal x As Long, ByVal y As Long)
		If bLayoutDirty Then LayoutPicker
		'Tab?
		Dim t As Long = TabFromPoint(x, y)
		If t >= 0 AndAlso t <> m_Tab Then
			m_Tab = t
			m_ScrollTop = 0
			SyncBodySel
			bLayoutDirty = True
			Refresh
			If OnTabChanged Then OnTabChanged(*Designer, This, t)
			Exit Sub
		End If
		'OK?
		If x >= rcOK.Left AndAlso x < rcOK.Right AndAlso y >= rcOK.Top AndAlso y < rcOK.Bottom Then
			m_OKPressed = True
			#ifdef __USE_WINAPI__
				SetCapture(FHandle)
			#endif
			Refresh
			Exit Sub
		End If
		'Fields?
		Dim f As Long = HitTestField(x, y)
		If f >= 0 Then
			EnterField(f)
			m_EditFresh = True
			m_Caret = Len(m_Edit)
			Refresh
			Exit Sub
		End If
		'The Initial half of the preview reverts
		If x >= rcInitial.Left AndAlso x < rcInitial.Right AndAlso y >= rcInitial.Top AndAlso y < rcInitial.Bottom Then
			m_Alpha = m_InitialAlpha
			SetColorInternal(m_InitialColor, cpPhaseEnd)
			Exit Sub
		End If
		'Body?
		If m_Tab = cpTabCustom Then
			Dim nCol As Long, nRow As Long
			If CellFromPoint(x, y, rcMatrix, COLORPICKER_MATRIX_COLS, nCol, nRow) Then
				m_IsDragging = True
				#ifdef __USE_WINAPI__
					SetCapture(FHandle)
				#endif
				SetColorInternal(MatrixColorAt(nCol, nRow, COLORPICKER_MATRIX_COLS, COLORPICKER_MATRIX_ROWS), cpPhaseBegin)
			End If
		Else
			'Scrollbar thumb?
			If x >= rcScroll.Left AndAlso x < rcScroll.Right AndAlso y >= rcScroll.Top AndAlso y < rcScroll.Bottom Then
				m_bScrollingThumb = True
				#ifdef __USE_WINAPI__
					SetCapture(FHandle)
				#endif
			ElseIf x >= rcList.Left AndAlso x < rcList.Right AndAlso y >= rcList.Top AndAlso y < rcList.Bottom Then
				Dim k As Long = (y - rcList.Top) \ (COLORPICKER_ROW_H * nScale)
				Dim idx As Long = m_ScrollTop + k
				If idx >= 0 AndAlso idx < WebColorCount() Then
					m_BodySel = idx
					SetColorInternal(WebColorAt(idx), cpPhaseEnd)
				End If
			End If
		End If
	End Sub

	Private Sub ColorPicker.MouseMoveAt(ByVal x As Long, ByVal y As Long)
		If bLayoutDirty Then LayoutPicker
		'A live matrix drag
		If m_IsDragging Then
			Dim nCol As Long, nRow As Long
			If CellFromPoint(x, y, rcMatrix, COLORPICKER_MATRIX_COLS, nCol, nRow) Then
				SetColorInternal(MatrixColorAt(nCol, nRow, COLORPICKER_MATRIX_COLS, COLORPICKER_MATRIX_ROWS), cpPhaseMove)
			End If
			Exit Sub
		End If
		'Thumb drag
		If m_bScrollingThumb Then
			Dim trackH As Long = rcScroll.Bottom - rcScroll.Top
			Dim thumbH As Long = rcScrollThumb.Bottom - rcScrollThumb.Top
			Dim nMax As Long = WebColorCount() - ListRowCount
			If nMax > 0 AndAlso trackH > thumbH Then
				SetScrollTop((y - rcScroll.Top - thumbH \ 2) * nMax \ (trackH - thumbH), False)
				RepaintAsync
			End If
			Exit Sub
		End If
		'Hot states
		SetHotTab(TabFromPoint(x, y))
		If m_Tab = cpTabCustom Then
			Dim nCol As Long, nRow As Long
			If CellFromPoint(x, y, rcMatrix, COLORPICKER_MATRIX_COLS, nCol, nRow) Then
				SetHotSwatch(nRow * COLORPICKER_MATRIX_COLS + nCol)
			Else
				SetHotSwatch(-1)
			End If
		Else
			Dim sw As Long = -1
			If x >= rcList.Left AndAlso x < rcList.Right AndAlso y >= rcList.Top AndAlso y < rcList.Bottom Then
				sw = m_ScrollTop + (y - rcList.Top) \ (COLORPICKER_ROW_H * nScale)
				If sw >= WebColorCount() Then sw = -1
			End If
			SetHotSwatch(sw)
		End If
		SetHotField(HitTestField(x, y))
		Dim bOKNow As Boolean = x >= rcOK.Left AndAlso x < rcOK.Right AndAlso y >= rcOK.Top AndAlso y < rcOK.Bottom
		If bOKNow <> m_OKHot Then
			m_OKHot = bOKNow
			Refresh
		End If
	End Sub

	Private Sub ColorPicker.MouseUpAt(ByVal x As Long, ByVal y As Long)
		'The drag ends where it stands: the value was already committed per move
		If m_IsDragging Then
			m_IsDragging = False
			#ifdef __USE_WINAPI__
				If GetCapture = FHandle Then ReleaseCapture
			#endif
			If OnColorChanged Then OnColorChanged(*Designer, This, m_Color, m_Alpha, cpPhaseEnd)
			Exit Sub
		End If
		If m_bScrollingThumb Then
			m_bScrollingThumb = False
			#ifdef __USE_WINAPI__
				If GetCapture = FHandle Then ReleaseCapture
			#endif
			Exit Sub
		End If
		'OK commits on release only if the cursor is still over it
		If m_OKPressed Then
			#ifdef __USE_WINAPI__
				If GetCapture = FHandle Then ReleaseCapture
			#endif
			CancelOKPress
			m_OKHot = x >= rcOK.Left AndAlso x < rcOK.Right AndAlso y >= rcOK.Top AndAlso y < rcOK.Bottom
			Refresh
			If m_OKHot Then 
				If OnOK Then OnOK(*Designer, This)
			End If
		End If
	End Sub

	'Invalidate without the synchronous UpdateWindow: wheel and thumb-drag
	'events arrive faster than paints, and coalescing them into one paint per
	'pump cycle is what keeps the list flicker-free
	Private Sub ColorPicker.RepaintAsync
		#ifdef __USE_GTK__
			If GTK_IS_WIDGET(widget) Then gtk_widget_queue_draw(widget)
		#elseif defined(__USE_WINAPI__)
			If FHandle Then InvalidateRect(FHandle, NULL, FALSE)
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			Repaint
		#endif
	End Sub

	Private Sub ColorPicker.WheelAt(ByVal Delta As Long)
		If m_Tab <> cpTabWeb Then Exit Sub
		SetScrollTop(m_ScrollTop + Delta * 3, False)
		RepaintAsync
	End Sub

	Private Sub ColorPicker.ProcessMessage(ByRef Message As Message)
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
				MouseDownAt(Message.lParamLo, Message.lParamHi)
			Case WM_MOUSEMOVE
				MouseMoveAt(Message.lParamLo, Message.lParamHi)
			Case WM_LBUTTONUP
				MouseUpAt(Message.lParamLo, Message.lParamHi)
			Case WM_MOUSEWHEEL
				WheelAt(Sgn(HiWord(Message.wParam)))
			Case WM_KEYDOWN
				If KeyEdit(Message.wParam) Then
					Message.Result = 0
					Exit Sub
				End If
			Case WM_CHAR
				If Message.wParam >= 48 AndAlso Message.wParam <= 57 Then
					HandleChar(Message.wParam)
					Message.Result = 0
					Exit Sub
				End If
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub

	'One accepted character. The FIRST character after entering a field replaces
	'the seeded buffer wholesale (select-all-on-entry); editing keys cleared the
	'flag, so after them the digit is inserted at the caret.
	Private Sub ColorPicker.HandleChar(ByVal ch As Long)
		If m_FocusField < 0 Then Exit Sub
		Dim sTmp As String = m_Edit
		If m_EditFresh Then
			m_Edit = ""
			m_Caret = 0
			m_EditFresh = False
		End If
		If Len(m_Edit) < 3 Then
			m_Edit = Mid(m_Edit, 1, m_Caret) & Chr(ch) & Mid(m_Edit, m_Caret + 1)
			m_Caret += 1
		End If
		Refresh
	End Sub

	#ifdef __USE_GTK__
		Private Function ColorPicker.OnDraw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As gpointer) As Boolean
			Dim As ColorPicker Ptr p = Cast(Any Ptr, data1)
			p->Canvas.HandleSetted = True
			p->Canvas.Handle = cr
			If p->nScale = 0 Then p->nScale = p->GetWindowsDPI()
			p->Draw()
			p->Canvas.Handle = 0
			p->Canvas.HandleSetted = False
			Return False
		End Function

		Private Sub ColorPicker.GTK_MouseDown(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, X As Integer, Y As Integer, Shift As Integer)
			Cast(ColorPicker Ptr, @Sender)->MouseDownAt(X, Y)
		End Sub

		Private Sub ColorPicker.GTK_MouseMove(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, X As Integer, Y As Integer, Shift As Integer)
			Cast(ColorPicker Ptr, @Sender)->MouseMoveAt(X, Y)
		End Sub

		Private Sub ColorPicker.GTK_MouseUp(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, X As Integer, Y As Integer, Shift As Integer)
			Cast(ColorPicker Ptr, @Sender)->MouseUpAt(X, Y)
		End Sub

		Private Sub ColorPicker.GTK_MouseWheel(ByRef Designer As My.Sys.Object, ByRef Sender As Control, Delta As Integer, X As Integer, Y As Integer, Shift As Integer)
			Cast(ColorPicker Ptr, @Sender)->WheelAt(Delta)
		End Sub

		Private Sub ColorPicker.GTK_KeyDown(ByRef Designer As My.Sys.Object, ByRef Sender As Control, Key As Integer, Shift As Integer)
			'Map the GDK keyvals onto the VK terms KeyEdit understands
			Dim vk As Long = Key
			Select Case Key
			Case &HFF08: vk = 8        'BackSpace
			Case &HFF0D, &HFF0A: vk = 13 'Return
			Case &HFF1B: vk = 27       'Escape
			Case &HFFFF: vk = 46       'Delete
			Case &HFF51: vk = 37       'Left
			Case &HFF52: vk = 38       'Up
			Case &HFF53: vk = 39       'Right
			Case &HFF54: vk = 40       'Down
			Case &HFF50: vk = 36       'Home
			Case &HFF57: vk = 35       'End
			Case &HFF09: vk = 9        'Tab
			Case &HFFB0 To &HFFB9: vk = 48 + (Key - &HFFB0) 'KP_0..KP_9
			End Select
			If vk >= 48 AndAlso vk <= 57 Then
				Cast(ColorPicker Ptr, @Sender)->HandleChar(vk)
			Else
				Cast(ColorPicker Ptr, @Sender)->KeyEdit(vk)
			End If
		End Sub
	#endif

	Private Sub ColorPicker.InitProperties
		With This
			WLet(FClassName, "ColorPicker")
			#ifdef __USE_WINAPI__
				.Style = WS_CHILD
				.ExStyle = 0
				.RegisterClass "ColorPicker", ""
				.ChildProc = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#elseif defined(__USE_GTK__)
				widget = gtk_layout_new(NULL, NULL)
				.RegisterClass "ColorPicker", @This
				gtk_widget_set_events(widget, _
				GDK_EXPOSURE_MASK Or _
				GDK_STRUCTURE_MASK Or _
				GDK_KEY_PRESS_MASK Or _
				GDK_SCROLL_MASK Or _
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
				.OnMouseWheel = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, Delta As Integer, X As Integer, Y As Integer, Shift As Integer), @GTK_MouseWheel)
				.OnKeyDown = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, Key As Integer, Shift As Integer), @GTK_KeyDown)
				pcontext = gtk_widget_create_pango_context(widget)
				layout = pango_layout_new(pcontext)
			#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			Dim iw As Long, ih As Long
			GetIdealSize(iw, ih)
			.Width = iw
			.Height = ih
			.Child = @This
			.Canvas.Ctrl = @This
			#ifdef __USE_WINAPI__
				.Canvas.UsingGdip = True
			#endif
			.BackColor = m_ChromeBackColor
			WLet(m_TextOK, "OK")
			WLet(m_TextInitial, "Initial")
			WLet(m_TextCurrent, "Current")
			WLet(m_TextField(cpFieldR), "Red:")
			WLet(m_TextField(cpFieldG), "Green:")
			WLet(m_TextField(cpFieldB), "Blue:")
			WLet(m_TextField(cpFieldA), "Alpha:")
		End With
		tmrHotTrack.Designer = @This
		tmrHotTrack.Interval = 0
		tmrHotTrack.OnTimer = @tmrHotTrack_Timer_
		tmrHotTrack.Enabled = True
		tmrCaret.Designer = @This
		tmrCaret.Interval = 0
		tmrCaret.OnTimer = @tmrCaret_Timer_
		tmrCaret.Enabled = True
	End Sub

	#ifdef __USE_WINAPI__
		Private Sub ColorPicker.WndProc(ByRef Message As Message)
		End Sub

		Private Sub ColorPicker.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			With QColorPicker(@Sender)
				.nScale = .GetWindowsDPI()
				.bLayoutDirty = True
				.tmrHotTrack.Interval = COLORPICKER_HOTTRACK_MS
			End With
		End Sub
	#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
		Private Sub ColorPicker.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			With QColorPicker(@Sender)
				.nScale = .GetWindowsDPI()
				.bLayoutDirty = True
			End With
		End Sub
	#endif

	Private Constructor ColorPicker
		InitProperties
	End Constructor

	Private Destructor ColorPicker
		tmrHotTrack.Interval = 0
		tmrHotTrack.Enabled = False
		tmrCaret.Interval = 0
		tmrCaret.Enabled = False
		WDeAllocate m_TextOK
		WDeAllocate m_TextInitial
		WDeAllocate m_TextCurrent
		Dim i As Long
		For i = 0 To cpFieldCount - 1
			WDeAllocate m_TextField(i)
		Next
	End Destructor

	' ========================================================================================
	' Properties
	' ========================================================================================

	Private Property ColorPicker.PickedColor As ULong
		Return m_Color
	End Property

	Private Property ColorPicker.PickedColor(Value As ULong)
		m_Color = Value
		SyncBodySel
		Refresh
	End Property

	Private Property ColorPicker.PickedAlpha As UByte
		Return m_Alpha
	End Property

	Private Property ColorPicker.PickedAlpha(Value As UByte)
		m_Alpha = Value
		Refresh
	End Property

	Private Property ColorPicker.ShowAlpha As Boolean
		Return m_ShowAlpha
	End Property

	Private Property ColorPicker.ShowAlpha(Value As Boolean)
		m_ShowAlpha = Value
		bLayoutDirty = True
		Refresh
	End Property

	Private Property ColorPicker.PickerTab As Long
		Return m_Tab
	End Property

	Private Property ColorPicker.PickerTab(Value As Long)
		'Silent, the family rule for programmatic setters
		If Value < cpTabWeb OrElse Value > cpTabCustom Then Exit Property
		m_Tab = Value
		m_ScrollTop = 0
		SyncBodySel
		bLayoutDirty = True
		Refresh
	End Property

	Private Sub ColorPicker.SetInitialColor(ByVal clr As ULong, ByVal nAlpha As UByte = 255)
		m_InitialColor = clr
		m_InitialAlpha = nAlpha
		m_Color = clr
		m_Alpha = nAlpha
		SyncBodySel
		Refresh
	End Sub

	Private Property ColorPicker.TextOK() ByRef As WString
		Return *m_TextOK
	End Property

	Private Property ColorPicker.TextOK(Value As WString)
		WLet m_TextOK, Value
		Refresh
	End Property

	Private Property ColorPicker.TextInitial() ByRef As WString
		Return *m_TextInitial
	End Property

	Private Property ColorPicker.TextInitial(Value As WString)
		WLet m_TextInitial, Value
		Refresh
	End Property

	Private Property ColorPicker.TextCurrent() ByRef As WString
		Return *m_TextCurrent
	End Property

	Private Property ColorPicker.TextCurrent(Value As WString)
		WLet m_TextCurrent, Value
		Refresh
	End Property

	Private Property ColorPicker.TextFieldLabel(ByVal idx As Long) As WString
		If idx < 0 OrElse idx >= cpFieldCount Then Return *m_TextOK
		Return *m_TextField(idx)
	End Property

	Private Property ColorPicker.TextFieldLabel(ByVal idx As Long, Value As WString)
		If idx < 0 OrElse idx >= cpFieldCount Then Exit Property
		WLet m_TextField(idx), Value
		Refresh
	End Property

	Private Property ColorPicker.ChromeBackColor As ULong
		Return m_ChromeBackColor
	End Property

	Private Property ColorPicker.ChromeBackColor(Value As ULong)
		m_ChromeBackColor = Value
		Refresh
	End Property

	Private Property ColorPicker.ChromeForeColor As ULong
		Return m_ForeColor
	End Property

	Private Property ColorPicker.ChromeForeColor(Value As ULong)
		m_ForeColor = Value
		Refresh
	End Property

	Private Property ColorPicker.ChromeBorderColor As ULong
		Return m_BorderColor
	End Property

	Private Property ColorPicker.ChromeBorderColor(Value As ULong)
		m_BorderColor = Value
		Refresh
	End Property

	' ========================================================================================
	' The modal shell: a fixed-dialog Form hosting the picker, ended by OnOK (TRUE)
	' or OnCancel / the frame close (FALSE).
	' ========================================================================================

	#ifndef ReadProperty_Off
		Private Function ColorPicker.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case PropertyName
			Case "PickedColor": Return @m_Color
			Case "PickedAlpha": Return @m_Alpha
			End Select
			Return Base.ReadProperty(PropertyName)
		End Function
	#endif

	#ifndef WriteProperty_Off
		Private Function ColorPicker.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			Select Case PropertyName
			Case "PickedColor": If Value <> 0 Then PickedColor = *Cast(ULong Ptr, Value): Return True
			Case "PickedAlpha": If Value <> 0 Then PickedAlpha = *Cast(UByte Ptr, Value): Return True
			End Select
			Return Base.WriteProperty(PropertyName, Value)
		End Function
	#endif

	Private Operator ColorPicker.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator

	Private Type ColorPickerDialog Extends Form
		Picker As ColorPicker
		bAccepted As Boolean = False
		Declare Static Sub Picker_OK_(ByRef Designer As My.Sys.Object, ByRef Sender As ColorPicker)
		Declare Static Sub Picker_Cancel_(ByRef Designer As My.Sys.Object, ByRef Sender As ColorPicker)
		Declare Sub Picker_OK(ByRef Sender As ColorPicker)
		Declare Sub Picker_Cancel(ByRef Sender As ColorPicker)
		Declare Constructor
	End Type

	Private Constructor ColorPickerDialog
		Dim pw As Long, ph As Long
		Picker.GetIdealSize(pw, ph)
		With This
			.Name = "ColorPickerDialog"
			.Text = "Select color"
			.BorderStyle = FormBorderStyle.FixedDialog
			.StartPosition = FormStartPosition.CenterScreen
			.SetBounds 0, 0, pw + 16, ph + 42
		End With
		With Picker
			.Name = "Picker"
			.SetBounds 8, 8, pw, ph
			.Designer = @This
			.OnOK = @Picker_OK_
			.OnCancel = @Picker_Cancel_
			.Parent = @This
		End With
	End Constructor

	Private Sub ColorPickerDialog.Picker_OK_(ByRef Designer As My.Sys.Object, ByRef Sender As ColorPicker)
		Cast(ColorPickerDialog Ptr, Sender.Designer)->Picker_OK(Sender)
	End Sub

	Private Sub ColorPickerDialog.Picker_OK(ByRef Sender As ColorPicker)
		bAccepted = True
		CloseForm
	End Sub

	Private Sub ColorPickerDialog.Picker_Cancel_(ByRef Designer As My.Sys.Object, ByRef Sender As ColorPicker)
		Cast(ColorPickerDialog Ptr, Sender.Designer)->Picker_Cancel(Sender)
	End Sub

	Private Sub ColorPickerDialog.Picker_Cancel(ByRef Sender As ColorPicker)
		bAccepted = False
		CloseForm
	End Sub

	Public Function ShowColorPicker(ByRef InitialColor As ULong, ByRef OutColor As ULong, ByRef OutAlpha As UByte, ByVal ShowAlphaCh As Boolean = True, ByRef Caption As WString = "Select color") As Boolean
		Dim dlg As ColorPickerDialog
		dlg.Text = Caption
		dlg.Picker.SetInitialColor(InitialColor, 255)
		dlg.Picker.ShowAlpha = ShowAlphaCh
		dlg.ShowModal
		If dlg.bAccepted Then
			OutColor = dlg.Picker.PickedColor
			OutAlpha = dlg.Picker.PickedAlpha
		End If
		Return dlg.bAccepted
	End Function

	End Namespace
'#End Region
