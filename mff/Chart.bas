'################################################################################
'#  Chart.bas                                                                   #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2021)                                          #
'#  Based on:                                                                   #
'#   Module Name: ucPieChart                                                    #
'#   Date: 23/06/2020                                                           #
'#   Module Name: ucChartArea                                                   #
'#   Date: 23/06/2020                                                           #
'#   Module Name: ucChartBar                                                    #
'#   Date: 08/08/2020                                                           #
'#   Author:  Leandro Ascierto                                                  #
'#   Web: www.leandroascierto.com                                               #
'#   Version: 1.0.0                                                             #
'################################################################################

#include once "Chart.bi"
#include once "vbcompat.bi"

Namespace My.Sys.Forms
	Private Function Chart.ReadProperty(ByRef PropertyName As String) As Any Ptr
		FTempString = LCase(PropertyName)
		Select Case FTempString
		Case "axismax": Return @m_AxisMax
		Case "axismin": Return @m_AxisMin
		Case "backcoloropacity": Return @m_BackColorOpacity
		Case "border": Return @m_Border
		Case "bordercolor": Return @m_BorderColor
		Case "borderround": Return @m_BorderRound
		Case "canvas": Return @Canvas
		Case "chartstyle": Return @m_ChartStyle
		Case "chartorientation": Return @m_ChartOrientation
		Case "count": Return @ItemsCount
		Case "donutwidth": Return @m_DonutWidth
		Case "fillgradient": Return @m_FillGradient
		Case "fillopacity": Return @m_FillOpacity
			'Case "itemcolor": Return @m_ItemColor
		Case "labelsalignment": Return @m_LabelsAlignments
		Case "labelsformat": Return m_LabelsFormat.vptr
		Case "labelsformats": Return m_LabelsFormats.vptr
		Case "labelsposition": Return @m_LabelsPositions
		Case "labelsvisible": Return @m_LabelsVisible
		Case "legendalign": Return @m_LegendAlign
		Case "legendvisible": Return @m_LegendVisible
		Case "linescolor": Return @m_LinesColor
		Case "linescurve": Return @m_LinesCurve
		Case "lineswidth": Return @m_LinesWidth
		Case "rotation": Return @m_Rotation
		Case "separatorline": Return @m_SeparatorLine
		Case "separatorlinecolor": Return @m_SeparatorLineColor
		Case "separatorlinewidth": Return @m_SeparatorLineWidth
			'Case "special": Return @m_Special
		Case "title": Return m_Title.vptr
		Case "titlefont": Return @m_TitleFont
		Case "titleforecolor": Return @m_TitleForeColor
		Case "verticallines": Return @m_VerticalLines
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Private Function Chart.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		If Value = 0 Then
			Select Case LCase(PropertyName)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		Else
			Select Case LCase(PropertyName)
			Case "axismax": AxisMax = QSingle(Value)
			Case "axismin": AxisMin = QSingle(Value)
			Case "backcoloropacity": BackColorOpacity = QLong(Value)
			Case "border": Border = QBoolean(Value)
			Case "bordercolor": BorderColor = QInteger(Value)
			Case "borderround": BorderRound = QLong(Value)
			Case "chartstyle": ChartStyle = *Cast(ChartStyles Ptr, Value)
			Case "chartorientation": ChartOrientation = *Cast(ChartOrientations Ptr, Value)
			Case "designmode": FDesignMode = QBoolean(Value): If FDesignMode Then Example: Refresh
			Case "donutwidth": DonutWidth = QSingle(Value)
			Case "fillgradient": FillGradient = QBoolean(Value)
			Case "fillopacity": FillOpacity = QLong(Value)
				'Case "itemcolor": ItemColor = QInteger(Value)
			Case "labelsalignment": LabelsAlignment = *Cast(LabelsAlignments Ptr, Value)
			Case "labelsformat": LabelsFormat = QWString(Value)
			Case "labelsformats": LabelsFormats = QWString(Value)
			Case "labelsposition": LabelsPosition = *Cast(LabelsPositions Ptr, Value)
			Case "labelsvisible": LabelsVisible = QBoolean(Value)
			Case "legendalign": LegendAlign = *Cast(LegendAligns Ptr, Value)
			Case "legendvisible": LegendVisible = QBoolean(Value)
			Case "linescolor": LinesColor = QInteger(Value)
			Case "linescurve": LinesCurve = QBoolean(Value)
			Case "lineswidth": LinesWidth = QLong(Value)
			Case "rotation": Rotation = QLong(Value)
			Case "separatorline": SeparatorLine = QBoolean(Value)
			Case "separatorlinecolor": SeparatorLineColor = QInteger(Value)
			Case "separatorlinewidth": SeparatorLineWidth = QSingle(Value)
				'Case "special": Special = QBoolean(Value)
			Case "title": Title = QWString(Value)
			Case "titleforecolor": TitleForeColor = QInteger(Value)
			Case "verticallines": VerticalLines = QBoolean(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		End If
		Return True
	End Function
	
	Private Sub Chart.GetCenterPie(X As Single, Y As Single)
		X = m_CenterCircle.x
		Y = m_CenterCircle.Y
	End Sub
	
	Private Property Chart.Count() As Long
		Count = ItemsCount
	End Property
	
	Private Property Chart.Special(Index As Long, Value As Boolean)
		m_Item(Index).Special = Value
		Me.Refresh
	End Property
	
	Private Property Chart.Special(Index As Long) As Boolean
		Return m_Item(Index).Special
	End Property
	
	Private Property Chart.ItemColor(Index As Long, Value As ULong)
		m_Item(Index).ItemColor = Value
		Me.Refresh
	End Property
	
	Private Property Chart.ItemColor(Index As Long) As ULong
		Return m_Item(Index).ItemColor
	End Property
	
	Private Sub Chart.Clear()
		Dim i As Long
		For i = 0 To ItemsCount - 1
			#ifndef __USE_GTK__
				GdipDeletePath m_Item(i).hPath
			#endif
		Next
		ItemsCount = 0
		ReDim Preserve m_Item(0)
		
		mHotBar = -1
		mHotSerie = -1
		Erase m_Serie
		SerieCount = 0
		
		Me.Refresh
	End Sub
	
	Private Sub Chart.AddItem(ByRef ItemName As WString, Value As Single, Item_Color As Long, bSpecial As Boolean = False)
		ReDim Preserve m_Item(ItemsCount)
		With m_Item(ItemsCount)
			.ItemName = ItemName
			.ItemColor = Item_Color
			.Value = Value
			.Special = bSpecial
		End With
		ItemsCount = ItemsCount + 1
	End Sub
	
	Private Sub Chart.AddSerie(ByVal SerieName As String, ByVal SerieColor As Long, Values As DoubleList Ptr, cCustomColors As IntegerList Ptr)
		ReDim Preserve m_Serie(SerieCount)
		With m_Serie(SerieCount)
			.SerieName = SerieName
			.SerieColor = SerieColor
			.Values = Values
			.CustomColors = cCustomColors
		End With
		SerieCount = SerieCount + 1
	End Sub
	
	Private Sub Chart.AddAxisItems(AxisItems As WStringList Ptr, ByVal WordWrap As Boolean = False, AxisAngle As Single = 0, AxisAlign As TextAlignmentH = cCenter)
		cAxisItem = AxisItems
		m_WordWrap = WordWrap
		m_AxisAngle = AxisAngle
		m_AxisAlign = AxisAlign
	End Sub
	
	Private Property Chart.AxisMax As Single
		Return m_AxisMax
	End Property
	
	Private Property Chart.AxisMax(Value As Single)
		m_AxisMax = Value
		Refresh
	End Property
	
	Private Property Chart.AxisMin As Single
		Return m_AxisMin
	End Property
	
	Private Property Chart.AxisMin(Value As Single)
		m_AxisMin = Value
		Refresh
	End Property
	
	Private Property Chart.Title() ByRef As WString
		Return *m_Title.vptr
	End Property
	
	Private Property Chart.Title(ByRef New_Value As WString)
		m_Title = New_Value
		Refresh
	End Property
	
	Private Property Chart.TitleFont() ByRef As My.Sys.Drawing.Font
		Return m_TitleFont
	End Property
	
	Private Property Chart.TitleFont(ByRef New_Value As My.Sys.Drawing.Font)
		m_TitleFont = New_Value
		Refresh
	End Property
	
	Private Property Chart.TitleForeColor() As ULong
		TitleForeColor = m_TitleForeColor
	End Property
	
	Private Property Chart.TitleForeColor(ByVal New_Value As ULong)
		m_TitleForeColor = New_Value
		Refresh
	End Property
	
	Private Property Chart.BackColorOpacity() As Long
		BackColorOpacity = m_BackColorOpacity
	End Property
	
	Private Property Chart.BackColorOpacity(ByVal New_Value As Long)
		m_BackColorOpacity = New_Value
		Refresh
	End Property
	
	Private Property Chart.LinesColor() As ULong
		LinesColor = m_LinesColor
	End Property
	
	Private Property Chart.LinesColor(ByVal New_Value As ULong)
		m_LinesColor = New_Value
		Refresh
	End Property
	
	
	Private Property Chart.FillOpacity() As Long
		FillOpacity = m_FillOpacity
	End Property
	
	Private Property Chart.FillOpacity(ByVal New_Value As Long)
		m_FillOpacity = New_Value
		Refresh
	End Property
	
	Private Property Chart.Border() As Boolean
		Border = m_Border
	End Property
	
	Private Property Chart.Border(ByVal New_Value As Boolean)
		m_Border = New_Value
		Refresh
	End Property
	
	Private Property Chart.BorderRound() As Long
		BorderRound = m_BorderRound
	End Property
	
	Private Property Chart.BorderRound(ByVal New_Value As Long)
		m_BorderRound = New_Value
		Refresh
	End Property
	
	Private Property Chart.BorderColor() As ULong
		BorderColor = m_BorderColor
	End Property
	
	Private Property Chart.BorderColor(ByVal New_Value As ULong)
		m_BorderColor = New_Value
		Refresh
	End Property
	
	Private Property Chart.LabelsFormat() ByRef As WString
		Return *m_LabelsFormat.vptr
	End Property
	
	Private Property Chart.LabelsFormat(ByRef New_Value As WString)
		m_LabelsFormat = New_Value
		Refresh
	End Property
	
	Private Property Chart.LabelsFormats() ByRef As WString
		Return *m_LabelsFormats.vptr
	End Property
	
	Private Property Chart.LabelsFormats(ByRef New_Value As WString)
		m_LabelsFormats = New_Value
		Refresh
	End Property
	
	Private Property Chart.LinesCurve() As Boolean
		LinesCurve = m_LinesCurve
	End Property
	
	Private Property Chart.LinesCurve(ByVal New_Value As Boolean)
		m_LinesCurve = New_Value
		Refresh
	End Property
	
	Private Property Chart.LinesWidth() As Long
		LinesWidth = m_LinesWidth
	End Property
	
	Private Property Chart.LinesWidth(ByVal New_Value As Long)
		m_LinesWidth = New_Value
		Refresh
	End Property
	
	Private Property Chart.FillGradient() As Boolean
		FillGradient = m_FillGradient
	End Property
	
	Private Property Chart.FillGradient(ByVal New_Value As Boolean)
		m_FillGradient = New_Value
		Refresh
	End Property
	
	Private Property Chart.VerticalLines() As Boolean
		VerticalLines = m_VerticalLines
	End Property
	
	Private Property Chart.VerticalLines(ByVal New_Value As Boolean)
		m_VerticalLines = New_Value
		Refresh
	End Property
	
	Private Property Chart.ChartStyle() As ChartStyles
		ChartStyle = m_ChartStyle
	End Property
	
	Private Property Chart.ChartStyle(ByVal New_Value As ChartStyles)
		m_ChartStyle = New_Value
		Select Case m_ChartStyle
		Case CS_PIE To CS_DONUT
			m_FillOpacity = 100
			m_Border = True
			m_LabelsFormats = "{P}%"
		Case CS_AREA
			m_FillOpacity = 50
			m_Border = False
			m_LabelsFormats = "{V}"
		Case CS_GroupedColumn To CS_StackedBarsPercent
			m_FillOpacity = 50
			m_Border = False
			m_LabelsFormats = "{V}"
		End Select
		Refresh
	End Property
	
	Private Property Chart.ChartOrientation() As ChartOrientations
		ChartOrientation = m_ChartOrientation
	End Property
	
	Private Property Chart.ChartOrientation(ByVal New_Value As ChartOrientations)
		m_ChartOrientation = New_Value
		Refresh
	End Property
	
	Private Property Chart.LegendAlign() As LegendAligns
		LegendAlign = m_LegendAlign
	End Property
	
	Private Property Chart.LegendAlign(ByVal New_Value As LegendAligns)
		m_LegendAlign = New_Value
		Refresh
	End Property
	
	Private Property Chart.LegendVisible() As Boolean
		LegendVisible = m_LegendVisible
	End Property
	
	Private Property Chart.LegendVisible(ByVal New_Value As Boolean)
		m_LegendVisible = New_Value
		Refresh
	End Property
	
	Private Property Chart.DonutWidth() As Single
		DonutWidth = m_DonutWidth
	End Property
	
	Private Property Chart.DonutWidth(ByVal New_Value As Single)
		m_DonutWidth = New_Value
		Refresh
	End Property
	
	Private Property Chart.SeparatorLine() As Boolean
		SeparatorLine = m_SeparatorLine
	End Property
	
	Private Property Chart.SeparatorLine(ByVal New_Value As Boolean)
		m_SeparatorLine = New_Value
		Refresh
	End Property
	
	Private Property Chart.SeparatorLineWidth() As Single
		SeparatorLineWidth = m_SeparatorLineWidth
	End Property
	
	Private Property Chart.SeparatorLineWidth(ByVal New_Value As Single)
		m_SeparatorLineWidth = New_Value
		Refresh
	End Property
	
	Private Property Chart.SeparatorLineColor() As ULong
		SeparatorLineColor = m_SeparatorLineColor
	End Property
	
	Private Property Chart.SeparatorLineColor(ByVal New_Value As ULong)
		m_SeparatorLineColor = New_Value
		Refresh
	End Property
	
	Private Property Chart.LabelsPosition() As LabelsPositions
		LabelsPosition = m_LabelsPositions
	End Property
	
	Private Property Chart.LabelsPosition(ByVal New_Value As LabelsPositions)
		m_LabelsPositions = New_Value
		Refresh
	End Property
	
	Private Property Chart.LabelsAlignment() As LabelsAlignments
		LabelsAlignment = m_LabelsAlignments
	End Property
	
	Private Property Chart.LabelsAlignment(ByVal New_Value As LabelsAlignments)
		m_LabelsAlignments = New_Value
		Refresh
	End Property
	
	Private Property Chart.LabelsVisible() As Boolean
		LabelsVisible = m_LabelsVisible
	End Property
	
	Private Property Chart.LabelsVisible(ByVal New_Value As Boolean)
		m_LabelsVisible = New_Value
		Refresh
	End Property
	
	Private Property Chart.Rotation() As Long
		Rotation = m_Rotation
	End Property
	
	Private Property Chart.Rotation(ByVal New_Value As Long)
		m_Rotation = New_Value Mod 360
		If m_Rotation < 0 Then m_Rotation = 360 + m_Rotation
		Refresh
	End Property
	
	Private Sub Chart.tmrMOUSEOVER_Timer_(ByRef Sender As TimerComponent)
		*Cast(Chart Ptr, Sender.Designer).tmrMOUSEOVER_Timer(Sender)
	End Sub
	Private Sub Chart.tmrMOUSEOVER_Timer(ByRef Sender As TimerComponent)
		'		#ifndef __USE_GTK__
		'			Dim PT As Point
		'			Dim Rect As RectL
		'			If c_lhWnd = 0 Then Exit Sub
		'
		'			GetCursorPos @PT
		'			ScreenToClient c_lhWnd, @PT
		'
		'			With Rect
		'				.Left = m_PT.X - (m_Left - ScaleX(This.Left))
		'				.Top = m_PT.Y - (m_Top - ScaleY(This.Top))
		'				.Right = This.ClientWidth
		'				.Bottom = This.ClientHeight
		'			End With
		'
		'			If PtInRectL(Rect, PT.X, PT.Y) = 0 Then
		'				'mHotBar = -1
		'				HotItem = -1
		'				tmrMOUSEOVER.Interval = 0
		'				Me.Refresh
		'				'RaiseEvent MouseLeave
		'			End If
		'		#endif
	End Sub
	
	Private Sub Chart.InitProperties()
		m_Title = This.Name
		FBackColor = clWhite
		m_BackColorOpacity = 100
		FForeColor = clBlack
		m_LinesColor = &HF4F4F4
		Select Case ChartStyle
		Case CS_PIE To CS_DONUT
			m_FillOpacity = 100
			m_Border = True
			m_LabelsFormats = "{P}%"
		Case CS_AREA
			m_FillOpacity = 50
			m_Border = False
			m_LabelsFormats = "{V}"
		Case CS_GroupedColumn To CS_StackedBarsPercent
			m_FillOpacity = 50
			m_Border = False
			m_LabelsFormats = "{V}"
		End Select
		m_LabelsPositions = LP_Inside
		m_LabelsAlignments = LP_CENTER
		m_AxisXVisible = True
		m_AxisYVisible = True
		m_AxisMax = 0
		m_AxisMin = 0
		m_BorderColor = &HF4F4F4
		m_LinesWidth = 1
		m_VerticalLines = False
		m_FillGradient = False
		m_HorizontalLines = True
		m_ChartStyle = CS_PIE
		m_ChartOrientation = CO_Vertical
		m_LegendAlign = LA_RIGHT
		m_LegendVisible = True
		'm_TitleFont.Name = DefaultFont.Name
		m_TitleFont.Size = 16
		m_DonutWidth = 50
		m_SeparatorLine = True
		m_SeparatorLineWidth = 4
		m_SeparatorLineColor = clWhite
		m_LabelsVisible = True
		m_BorderRound = 0
	End Sub
	
	Private Sub Chart.GetTextSize(ByRef text_ As WString, ByVal lWidth As Long, ByVal Height As Long, ByRef oFont As My.Sys.Drawing.Font, ByVal bWordWrap As Boolean, ByRef SZ As SIZEF)
		#ifdef __USE_GTK__
			Dim As PangoFontDescription Ptr desc
		#else
			Dim hBrush As Long
			Dim hFontFamily As GpFontFamily Ptr
			Dim hFormat As GpStringFormat Ptr
			Dim hFont As GpFont Ptr
		#endif
		Dim layoutRect As RectF
		Dim lFontSize As Long
		Dim lFontStyle As GDIPLUS_FONTSTYLE
		Dim BB As RectF, CF As Long, LF As Long
		
		#ifdef __USE_GTK__
			desc = pango_font_description_from_string(oFont.Name & " " & oFont.Size)
			pango_layout_set_font_description (layout, desc)
		#else
			If GdipCreateFontFamilyFromName(WStrPtr(oFont.Name), 0, @hFontFamily) Then
				If GdipGetGenericFontFamilySansSerif(@hFontFamily) Then Exit Sub
			End If
		#endif
		
		#ifndef __USE_GTK__
			If GdipCreateStringFormat(0, 0, @hFormat) = 0 Then
				If Not bWordWrap Then GdipSetStringFormatFlags hFormat, StringFormatFlagsNoWrap
			End If
		#endif
		
		If oFont.Bold Then lFontStyle = lFontStyle Or GDIPLUS_FONTSTYLE.FontStyleBold
		If oFont.Italic Then lFontStyle = lFontStyle Or GDIPLUS_FONTSTYLE.FontStyleItalic
		If oFont.Underline Then lFontStyle = lFontStyle Or GDIPLUS_FONTSTYLE.FontStyleUnderline
		If oFont.StrikeOut Then lFontStyle = lFontStyle Or GDIPLUS_FONTSTYLE.FontStyleStrikeout
		
		#ifndef __USE_GTK__
			lFontSize = MulDiv(oFont.Size, GetDeviceCaps(GetDC(This.Handle), LOGPIXELSY), 72)
		#endif
		
		layoutRect.Width = lWidth * nScale: layoutRect.Height = Height * nScale
		
		#ifdef __USE_GTK__
			Dim As PangoRectangle extend, extend2
			pango_layout_set_text(layout, ToUTF8(text_), Len(ToUTF8(text_)))
			pango_cairo_update_layout(cr, layout)
			pango_layout_get_pixel_extents(layout, @extend, @extend2)
'			#ifdef PANGO_VERSION
'				Dim As PangoLayoutLine Ptr pl = pango_layout_get_line_readonly(layout, 0)
'			#else
'				Dim As PangoLayoutLine Ptr pl = pango_layout_get_line(layout, 0)
'			#endif
			'pango_layout_line_get_pixel_extents(pl, NULL, @extend)
			SZ.Width = extend2.Width
			SZ.Height = extend2.Height
			
			pango_font_description_free (desc)
		#else
			GdipCreateFont(hFontFamily, lFontSize, lFontStyle, UnitPixel, @hFont)
			
			GdipMeasureString hGraphics, @text_, -1, hFont, @layoutRect, hFormat, @BB, @CF, @LF
			
			SZ.Width = BB.Width
			SZ.Height = BB.Height
			
			GdipDeleteFont hFont
			GdipDeleteStringFormat hFormat
			GdipDeleteFontFamily hFontFamily
		#endif
		
	End Sub
	
	Private Sub Chart.DrawText(ByRef text As WString, ByVal X As Long, ByVal Y As Long, ByVal lWidth As Long, ByVal Height As Long, ByRef oFont As My.Sys.Drawing.Font, ByVal ForeColor As Long, HAlign As TextAlignmentH = 0, VAlign As TextAlignmentV = 0, bWordWrap As Boolean = False, Angle As Single = 0)
		#ifdef __USE_GTK__
			Dim As PangoFontDescription Ptr desc
		#else
			Dim hBrush As GpBrush Ptr
			Dim hFontFamily As GpFontFamily Ptr
			Dim hFormat As GpStringFormat Ptr
			Dim hFont As GpFont Ptr
			'Dim hDC As HDC
		#endif
		Dim layoutRect As RectF
		Dim lFontSize As Long
		Dim lFontStyle As GDIPLUS_FONTSTYLE
		Dim W As Single, H As Single
		W = lWidth
		H = Height
		If Angle <> 0 Then
			Select Case Angle
			Case Is <= 90
				W = lWidth + Angle * (Height - lWidth) / 90
			Case Is < 180
				W = lWidth + (180 - Angle) * (Height - lWidth) / 90
			Case Is < 270
				W = lWidth + (Angle Mod 90) * (Height - lWidth) / 90
			Case Else
				W = lWidth + (360 - Angle) * (Height - lWidth) / 90
			End Select
			
			X = X - ((W - lWidth) / 2)
			
			lWidth = W
			
			#ifndef __USE_GTK__
				GdipTranslateWorldTransform hGraphics, X + lWidth / 2, Y + Height / 2, 0
				GdipRotateWorldTransform hGraphics, Angle, 0
				GdipTranslateWorldTransform hGraphics, -(X + lWidth / 2), -(Y + Height / 2), 0
			#endif
		End If
		
		#ifdef __USE_GTK__
			desc = pango_font_description_from_string(oFont.Name & " " & oFont.Size)
			pango_layout_set_font_description (layout, desc)
		#else
			If GdipCreateFontFamilyFromName(@oFont.Name, 0, @hFontFamily) <> GDIP_OK Then
				If GdipGetGenericFontFamilySansSerif(@hFontFamily) <> GDIP_OK Then Exit Sub
			End If
		#endif
		
		#ifndef __USE_GTK__
			If GdipCreateStringFormat(0, 0, @hFormat) = GDIP_OK Then
				If Not bWordWrap Then GdipSetStringFormatFlags hFormat, StringFormatFlagsNoWrap
				GdipSetStringFormatAlign hFormat, HAlign
				GdipSetStringFormatLineAlign hFormat, VAlign
			End If
		#endif
		
		If oFont.Bold Then lFontStyle = lFontStyle Or GDIPLUS_FONTSTYLE.FontStyleBold
		If oFont.Italic Then lFontStyle = lFontStyle Or GDIPLUS_FONTSTYLE.FontStyleItalic
		If oFont.Underline Then lFontStyle = lFontStyle Or GDIPLUS_FONTSTYLE.FontStyleUnderline
		If oFont.Strikeout Then lFontStyle = lFontStyle Or GDIPLUS_FONTSTYLE.FontStyleStrikeout
		
		#ifndef __USE_GTK__
			'hDC = GetDC(0&)
			lFontSize = MulDiv(oFont.Size, GetDeviceCaps(hD, LOGPIXELSY), 72)
			'ReleaseDC 0&, hDC
		#endif
		
		layoutRect.X = X: layoutRect.Y = Y
		layoutRect.Width = lWidth: layoutRect.Height = Height
		
		#ifdef __USE_GTK__
			Dim As PangoRectangle extend1, extend
			pango_layout_set_text(layout, ToUTF8(Text), Len(ToUTF8(Text)))
			pango_cairo_update_layout(cr, layout)
			'pango_layout_get_pixel_extents(layout, @extend1, @extend)
			#ifdef PANGO_VERSION
				Dim As PangoLayoutLine Ptr pl = pango_layout_get_line_readonly(layout, 0)
			#else
				Dim As PangoLayoutLine Ptr pl = pango_layout_get_line(layout, 0)
			#endif
			pango_layout_line_get_pixel_extents(pl, NULL, @extend)
			
			Select Case HAlign
			Case cLeft
			Case cCenter: layoutRect.X += (layoutRect.Width - extend.width) / 2
			Case cRight: layoutRect.X += layoutRect.Width - extend.width
			End Select
			Select Case VAlign
			Case cTop
			Case cMiddle: layoutRect.Y += (layoutRect.Height - extend.height) / 2
			Case cBottom: layoutRect.Y += layoutRect.Height - extend.height
			End Select
			
			cairo_move_to(cr, layoutRect.X - 0.5, layoutRect.Y + extend.height - 0.5)
			cairo_set_source_rgb(cr, GetRedD(ForeColor), GetGreenD(ForeColor), GetBlueD(ForeColor))
			pango_cairo_show_layout_line(cr, pl)
			
			pango_font_description_free (desc)
		#else
			If GdipCreateSolidFill(ForeColor, Cast(GpSolidFill Ptr Ptr, @hBrush)) = GDIP_OK Then
				If GdipCreateFont(hFontFamily, lFontSize, lFontStyle, UnitPixel, @hFont) = GDIP_OK Then
					GdipDrawString hGraphics, @text, -1, hFont, @layoutRect, hFormat, hBrush
					GdipDeleteFont hFont
				End If
				GdipDeleteBrush hBrush
			End If
			
			If hFormat Then GdipDeleteStringFormat hFormat
			GdipDeleteFontFamily hFontFamily
			If Angle <> 0 Then GdipResetWorldTransform hGraphics
		#endif
	End Sub
	
	Private Function Chart.GetWindowsDPI() As Double
		#ifdef __USE_GTK__
			Return 1#
		#else
			Dim hDC As HDC, LPX  As Double
			hDC = GetDC(0)
			LPX = CDbl(GetDeviceCaps(hDC, LOGPIXELSX))
			ReleaseDC 0, hDC
			
			If (LPX = 0) Then
				GetWindowsDPI = 1#
			Else
				GetWindowsDPI = LPX / 96#
			End If
		#endif
	End Function
	
	Private Sub Chart.HitTest(X As Single, Y As Single, HitResult As Integer)
		'			If This.Enabled Then
		'				HitResult = 3
		'				If Not DesignMode Then
		'					Dim PT As Point
		'
		'					If tmrMOUSEOVER.Interval = 0 Then
		'						GetCursorPos @PT
		'						ScreenToClient c_lhWnd, @PT
		'						m_PT.X = PT.X - X
		'						m_PT.Y = PT.Y - Y
		'
		'						m_Left = ScaleX(This.Left)
		'						m_Top = ScaleY(This.Top)
		'
		'
		'						tmrMOUSEOVER.Interval = 1
		'						'RaiseEvent MouseEnter
		'					End If
		'
		'				End If
		'			End If
	End Sub
	
	Private Function Chart.PtInPath(hPath As Any Ptr, X As Single, Y As Single) As Boolean
		#ifdef __USE_GTK__
			Dim As Boolean bResult
			Dim As cairo_t Ptr cr1 = gdk_cairo_create(gtk_widget_get_window(widget))
			Dim As cairo_path_t Ptr path = hPath
			cairo_new_path(cr1)
			cairo_append_path(cr1, path)
			cairo_close_path(cr)
			bResult = cairo_in_fill(cr1, X, Y)
			cairo_destroy(cr1)
			Return bResult
		#else
			Dim lResult As Long
			GdipIsVisiblePathPoint(hPath, X, Y, 0, Cast(BOOL Ptr, @lResult))
			Return lResult
		#endif
	End Function
	
	Private Sub Chart.MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
		
		Dim i As Long
		Dim bResult As Boolean
		
		If Button <> 0 Then Exit Sub
		
		For i = 0 To ItemsCount - 1
			
			bResult = PtInPath(m_Item(i).hPath, X, Y)
			
			If bResult Then
				If i = HotItem Then
					If OnItemClick Then OnItemClick(i)
				End If
				Exit Sub
			End If
			
		Next
	End Sub
	Private Sub Chart.MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
		Select Case ChartStyle
		Case CS_PIE To CS_DONUT
			Dim i As Long
			Dim bResult As Boolean 'BOOL
			'RaiseEvent MouseMove(Button, Shift, X, Y)
			If Button <> -1 Then Exit Sub
			For i = 0 To ItemsCount - 1
				If PtInRectL(m_Item(i).LegendRect, X, Y) Then
					If i <> HotItem Then
						HotItem = i
						Me.Refresh
					End If
					Exit Sub
				End If
				
				'?"MouseMove", X, Y
				bResult = PtInPath(m_Item(i).hPath, X, Y)
				
				If bResult Then
					If i <> HotItem Then
						HotItem = i
						Me.Refresh
					End If
					Exit Sub
				End If
				
			Next
			
			If HotItem <> -1 Then
				HotItem = -1
				Me.Refresh
			End If
		Case CS_AREA
			Dim XX As Single, YY As Single, i As Long
			If X > MarginLeft And Y > TopHeader And X < MarginLeft + mWidth And Y < TopHeader + mHeight Then
				If SerieCount = 0 Then Exit Sub
				XX = X - MarginLeft + PtDistance / 2
				'YY = Y '- TopHeader
				
				If (XX \ PtDistance) <> mHotBar Then
					mHotBar = (XX \ PtDistance)
					Me.Refresh
				End If
				Exit Sub
			Else
				For i = 0 To SerieCount - 1
					
					If PtInRectL(m_Serie(i).LegendRect, X, Y) Then
						If mHotSerie <> i Then
							mHotSerie = i
							mHotBar = -1
							Me.Refresh
						End If
						Exit Sub
					End If
				Next
			End If
			
			If mHotBar <> -1 Then
				mHotBar = -1
				Me.Refresh
			End If
			
			If mHotSerie <> -1 Then
				mHotSerie = -1
				Me.Refresh
			End If
		Case CS_GroupedColumn To CS_StackedBarsPercent
			Dim i As Integer, j As Integer
			For i = 0 To SerieCount - 1
				With m_Serie(i)
					If PtInRectL(.LegendRect, X, Y) Then
						If i <> mHotSerie Then
							mHotSerie = i
							mHotBar = -1
							Me.Refresh
						End If
						Exit Sub
					End If
					For j = 0 To .Values->Count - 1
						If PtInRectL(.Rects(j), X, Y) Then
							If i <> mHotSerie Then
								mHotSerie = i
								mHotBar = j
								Me.Refresh
							End If
							Exit Sub
						End If
					Next
				End With
			Next
			
			If mHotSerie <> -1 Then
				mHotSerie = -1
				Me.Refresh
			End If
		End Select
	End Sub
	
	Private Sub Chart.UpdateSerie(ByVal Index As Integer, ByVal SerieName As String, ByVal SerieColor As Long, Values As DoubleList Ptr)
		Dim TempCol As DoubleList Ptr
		Dim i As Long, j As Long
		Dim Dif As Single
		Dim bCancel As Boolean
		Dim bVisible As Boolean
		bCancel = True
		bVisible = Me.LabelsVisible
		Me.LabelsVisible = False
		With m_Serie(Index)
			.SerieName = SerieName
			.SerieColor = SerieColor
			TempCol = .Values
			
			For i = 1 To 10
				.Values = New DoubleList Ptr
				For j = 1 To Values->Count
					Dif = Values->Item(j) - TempCol->Item(j)
					.Values->Add Round(TempCol->Item(j) + i * Dif / 10)
				Next
				Me.Refresh
				pApp->DoEvents
				Wait 1
				'
			Next
			.Values = Values
			Me.LabelsVisible = bVisible
		End With
	End Sub
	
	Private Sub Chart.Wait(Interval As Integer)
		Dim t As Single
		t = Timer + Interval / 100
		Do While t > Timer
			'DoEvents
		Loop
	End Sub
	
	Private Function Chart.PtInRectL(Rect_ As RectL, ByVal X As Long, ByVal Y As Long) As Boolean
		With Rect_
			'?"PtInRectL - X, Y: " & X & ", " & Y, "Left: " & .Left, "Width: " & .Right, "Right: " & .Left + .Right, "Top: " &  .Top, "Height: " &  .Bottom, "Bottom: " & .Top + .Bottom
			If X >= .Left And X <= .Left + .Right And Y >= .Top And Y <= .Top + .Bottom Then
				PtInRectL = True
			End If
		End With
	End Function
	
	Private Sub Chart.Paint()
		This.Draw
	End Sub
	
	Private Sub Chart.Refresh()
		'		Dim As HDC hd
		'		hd = GetDC(FHandle)
		'		This.Paint hd
		'		ReleaseDc FHandle, hd
		'Repaint
		#ifdef __USE_GTK__
			If gtk_is_widget(widget) Then gtk_widget_queue_draw(widget)
		#else
			RedrawWindow(FHandle, NULL, NULL, RDW_INVALIDATE)
			UpdateWindow FHandle
		#endif
	End Sub
	
	Private Sub Chart.Show()
		Me.Refresh
	End Sub
	
	#ifndef __USE_GTK__
		Private Sub Chart.ManageGDIToken(ByVal projectHwnd As HWND) ' by LaVolpe
			'If projectHwnd = 0& Then Exit Function
			
			'			Dim hwndGDIsafe     As HWND                 'API window to monitor IDE shutdown
			'
			'			Do
			'				hwndGDIsafe = GetParent(projectHwnd)
			'				If Not hwndGDIsafe = 0& Then projectHwnd = hwndGDIsafe
			'			Loop Until hwndGDIsafe = 0&
			'			' ok, got the highest level parent, now find highest level owner
			'			Do
			'				hwndGDIsafe = GetWindow(projectHwnd, GW_OWNER)
			'				If Not hwndGDIsafe = 0& Then projectHwnd = hwndGDIsafe
			'			Loop Until hwndGDIsafe = 0&
			'
			'			hwndGDIsafe = FindWindowEx(projectHwnd, 0&, "Static", "GDI+Safe Patch")
			'
			'			If hwndGDIsafe Then
			'				ManageGDIToken = hwndGDIsafe    ' we already have a manager running for this VB instance
			'				Exit Function                   ' can abort
			'			End If
			'
			#ifdef __FB_64BIT__
				Dim StartupInput As GdiplusStartupInput  'GDI+ startup info
			#else
				Dim StartupInput As Gdiplus.GdiplusStartupInput  'GDI+ startup info
			#endif
			
			'	'
			'	'		'On Error Resume Next
			StartupInput.GdiPlusVersion = 1                    ' attempt to start GDI+
			GdiplusStartup(@gToken, @StartupInput, NULL)
			If gToken = 0& Then                         ' failed to start
				'If Err Then Err.Clear
				Exit Sub
			End If
			
			'			On Error Goto 0
			'
			'			Dim z_ScMem         As LPVOID                 'Thunk base address
			'			Dim z_Code()        As Long                 'Thunk machine-code initialised here
			'			Dim nAddr           As Long                 'hwndGDIsafe prev window procedure
			'
			'			Const WNDPROC_OFF   As Long = &H30          'Offset where window proc starts from z_ScMem
			'			Const PAGE_RWX      As Long = &H40&         'Allocate executable memory
			'			Const MEM_COMMIT    As Long = &H1000&       'Commit allocated memory
			'			Const MEM_RELEASE   As Long = &H8000&       'Release allocated memory flag
			'			Const MEM_LEN       As Long = &HD4          'Byte length of thunk
			'
			'			z_ScMem = VirtualAlloc(0, MEM_LEN, MEM_COMMIT, PAGE_RWX) 'Allocate executable memory
			'			If z_ScMem <> 0 Then                                     'Ensure the allocation succeeded
			'				' we make the api window a child so we can use FindWindowEx to locate it easily
			'				hwndGDIsafe = CreateWindowExW(0&, "Static", "GDI+Safe Patch", WS_CHILD, 0&, 0&, 0&, 0&, projectHwnd, 0&, GetModuleHandle(0), ByVal 0&)
			'				If hwndGDIsafe <> 0 Then
			'
			'					ReDim z_Code(0 To MEM_LEN \ 4 - 1)
			'
			'					z_Code(12) = &HD231C031: z_Code(13) = &HBBE58960: z_Code(14) = &H12345678: z_Code(15) = &H3FFF631: z_Code(16) = &H74247539: z_Code(17) = &H3075FF5B: z_Code(18) = &HFF2C75FF: z_Code(19) = &H75FF2875
			'					z_Code(20) = &H2C73FF24: z_Code(21) = &H890853FF: z_Code(22) = &HBFF1C45: z_Code(23) = &H2287D81: z_Code(24) = &H75000000: z_Code(25) = &H443C707: z_Code(26) = &H2&: z_Code(27) = &H2C753339: z_Code(28) = &H2047B81: z_Code(29) = &H75000000
			'					z_Code(30) = &H2C73FF23: z_Code(31) = &HFFFFFC68: z_Code(32) = &H2475FFFF: z_Code(33) = &H681C53FF: z_Code(34) = &H12345678: z_Code(35) = &H3268&: z_Code(36) = &HFF565600: z_Code(37) = &H43892053: z_Code(38) = &H90909020: z_Code(39) = &H10C261
			'					z_Code(40) = &H562073FF: z_Code(41) = &HFF2453FF: z_Code(42) = &H53FF1473: z_Code(43) = &H2873FF18: z_Code(44) = &H581053FF: z_Code(45) = &H89285D89: z_Code(46) = &H45C72C75: z_Code(47) = &H800030: z_Code(48) = &H20458B00: z_Code(49) = &H89145D89
			'					z_Code(50) = &H81612445: z_Code(51) = &H4C4&: z_Code(52) = &HC63FF00
			'
			'					z_Code(1) = 0                                                   ' shutDown mode; used internally by ASM
			'					z_Code(2) = zFnAddr("user32", "CallWindowProcA")                ' function pointer CallWindowProc
			'					z_Code(3) = zFnAddr("kernel32", "VirtualFree")                  ' function pointer VirtualFree
			'					z_Code(4) = zFnAddr("kernel32", "FreeLibrary")                  ' function pointer FreeLibrary
			'					z_Code(5) = gToken                                              ' Gdi+ token
			'					z_Code(10) = Cast(Long, LoadLibrary("gdiplus"))                             ' library pointer (add reference)
			'					z_Code(6) = Cast(Long, GetProcAddress(Cast(HMODULE, z_Code(10)), "GdiplusShutdown"))       ' function pointer GdiplusShutdown
			'					z_Code(7) = zFnAddr("user32", "SetWindowLongA")                 ' function pointer SetWindowLong
			'					z_Code(8) = zFnAddr("user32", "SetTimer")                       ' function pointer SetTimer
			'					z_Code(9) = zFnAddr("user32", "KillTimer")                      ' function pointer KillTimer
			'
			'					z_Code(14) = Cast(Long, z_ScMem)                                            ' ASM ebx start point
			'					z_Code(34) = Cast(Long, z_ScMem + WNDPROC_OFF)                              ' subclass window procedure location
			'
			'					RtlMoveMemory(z_ScMem, VarPtr(z_Code(0)), MEM_LEN)               'Copy the thunk code/data to the allocated memory
			'
			'					nAddr = SetWindowLongPtr(hwndGDIsafe, GWL_WNDPROC, Cast(LONG_PTR, z_ScMem + WNDPROC_OFF)) 'Subclass our API window
			'					RtlMoveMemory(z_ScMem + 44, VarPtr(nAddr), 4&) ' Add prev window procedure to the thunk
			'					gToken = 0& ' zeroize so final check below does not release it
			'
			'					ManageGDIToken = hwndGDIsafe    ' return handle of our GDI+ manager
			'				Else
			'					VirtualFree z_ScMem, 0, MEM_RELEASE     ' failure - release memory
			'					z_ScMem = 0&
			'				End If
			'			Else
			'				VirtualFree z_ScMem, 0, MEM_RELEASE           ' failure - release memory
			'				z_ScMem = 0&
			'			End If
			'
			'			If gToken Then GdiplusShutdown gToken       ' release token if error occurred
			
		End Sub
		
		'		Private Function Chart.zFnAddr(ByVal sDLL As String, ByVal sProc As String) As Long
		'			zFnAddr = Cast(Long, GetProcAddress(GetModuleHandleA(sDLL), sProc))  'Get the specified procedure address
		'		End Function
		
		Private Function Chart.SafeRange(Value As Long, Min As Long, Max As Long) As Long
			
			If Value < Min Then
				SafeRange = Min
			ElseIf Value > Max Then
				SafeRange = Max
			Else
				SafeRange = Value
			End If
		End Function
	#endif
	
	Private Function Chart.RGBtoARGB(ByVal RGBColor As ULong, ByVal Opacity As Long) As ULong
		#ifdef __USE_GTK__
			Return ShiftColor(RGBColor, clWhite, Opacity / 100 * 255)
			'Return ((Cast(ULong, Opacity / 100 * 255) Shl 24) + (Cast(ULong, Abs(GetRed(RGBColor))) Shl 16) + (Cast(ULong, Abs(GetGreen(RGBColor))) Shl 8) + (Cast(ULong, Abs(GetBlue(RGBColor)))))
		#else
			Return ((Cast(dword, Opacity / 100 * 255) Shl 24) + (Cast(dword, GetRed(RGBColor)) Shl 16) + (Cast(dword, GetGreen(RGBColor)) Shl 8) + Cast(dword, GetBlue(RGBColor)))
		#endif
		'Return Color_MakeARGB(Opacity / 100 * 255, GetRed(RGBColor), GetGreen(RGBColor), GetBlue(RGBColor))
	End Function
	
	Private Function Round(X As Double, Drob As Integer = 0) As Integer
		If Drob = 0 Then
			Return CInt(X)
		Else
			Return CInt(X * 10 ^ Drob) / 10 ^ Drob
		End If
	End Function
	
	Private Function Chart.GetMax() As Single
		Dim i As Long, j As Long, M As Single
		Dim Sum As Single
		If SerieCount = 0 Then Exit Function
		If (m_ChartStyle = CS_StackedBars) Or (m_ChartStyle = CS_StackedBarsPercent) Then
			For i = 1 To m_Serie(0).Values->Count
				Sum = 0
				For j = 0 To SerieCount - 1
					Sum = Sum + m_Serie(j).Values->Item(i)
				Next
				
				If M < Sum Then M = Sum
			Next
		Else
			For i = 0 To SerieCount - 1
				For j = 1 To m_Serie(i).Values->Count
					If M < m_Serie(i).Values->Item(j) Then
						M = m_Serie(i).Values->Item(j)
					End If
				Next
			Next
		End If
		
		GetMax = M
		
	End Function
	
	
	Private Function Chart.GetMin() As Single
		Dim i As Long, j As Long, M As Single
		Dim Sum As Single
		If SerieCount = 0 Then Exit Function
		If (m_ChartStyle = CS_StackedBars) Or (m_ChartStyle = CS_StackedBarsPercent) Then
			For i = 1 To m_Serie(0).Values->Count
				Sum = 0
				For j = 0 To SerieCount - 1
					If m_Serie(j).Values->Item(i) < 0 Then
						Sum = Sum + m_Serie(j).Values->Item(i)
					End If
				Next
				
				If M > Sum Then M = Sum
			Next
		Else
			For i = 0 To SerieCount - 1
				For j = 1 To m_Serie(i).Values->Count
					If m_Serie(i).Values->Item(j) < M Then
						M = m_Serie(i).Values->Item(j)
					End If
				Next
			Next
		End If
		
		GetMin = M
		
	End Function
	
	'*1
	Private Function Chart.SumSerieValues(Index As Long, bPositives As Boolean = False) As Single
		Dim i As Long
		Dim M As Single
		For i = 0 To SerieCount - 1
			M = M + Abs(m_Serie(i).Values->Item(Index))
		Next
		SumSerieValues = M
	End Function
	
	Private Sub Chart.Draw()
		#ifndef __USE_GTK__
			Dim hPath As GpPath Ptr
			Dim hBrush As GpBrush Ptr, hPen As GpPen Ptr
		#endif
		Dim mRect As RectL
		Dim i As Single, j As Long
		Dim mPenWidth As Single
		Dim TextWidth As Single
		Dim TextHeight As Single
		Dim XX As Single, YY As Single
		Dim yRange As Single
		Dim lForeColor As Long
		Dim RectL_ As RectL
		Dim LabelsRect As RectL
		Dim iStep As Single
		Dim nVal As Single
		Dim NumDecim As Single
		Dim forLines As Single, toLines As Single
		Dim AxisX As SIZEF
		Dim AxisY As SIZEF
		Dim PT16 As Single
		Dim PT24 As Single
		Dim ColRow As Integer
		Dim LineSpace As Single
		Dim TitleSize As SIZEF
		Dim sDisplay As String
		Dim SafePercent As Single
		Dim Min As Single, Max As Single, LastAngle As Single, Angle As Single, Total  As Single
		Dim DonutSize As Single
		Dim LW As Single
		Dim R1 As Single, R2 As Single, R3 As Single
		Dim CX As Single, CY   As Single
		Dim Left_ As Single, Top_ As Single
		Dim Percent As Single
		Const PItoRAD = 3.141592 / 180
		Dim lTop As Single
		Dim ZeroPoint As Long
		Dim sLabelText As String
		Dim bAngMaj180 As Boolean
		Dim LblWidth As Single
		Dim LblHeight As Single
		Dim mFormat As String
		Dim A As Single
		Dim Displacement As Single
		Dim lColor As Long
		Dim Value As Single
		Dim RangeHeight As Single
		Dim BarSpace As Single
		Dim BarWidth As Single
		Dim LastPositive() As Long, LastNegative() As Long
		
		#ifndef __USE_GTK__
			If GdipCreateFromHDC(hD, @hGraphics) Then Exit Sub
			
			GdipSetSmoothingMode(hGraphics, SmoothingModeAntiAlias)
			GdipSetCompositingQuality(hGraphics, &H3) 'CompositingQualityGammaCorrected
		#endif
		
		Select Case ChartStyle
		Case CS_PIE To CS_DONUT
			
			PT16 = 16 * nScale
			mPenWidth = 1 * nScale
			DonutSize = m_DonutWidth * nScale
			
			MarginLeft = PT16
			TopHeader = PT16
			MarginRight = PT16
			Footer = PT16
			
			Canvas.Font = This.Font
			If m_LegendVisible Then
				For i = 0 To ItemsCount - 1
					m_Item(i).TextHeight = ScaleY(Canvas.TextHeight(m_Item(i).ItemName)) * 1.5
					m_Item(i).TextWidth = ScaleX(Canvas.TextWidth(m_Item(i).ItemName)) * 1.5 + m_Item(i).TextHeight
				Next
			End If
			
			If Len(m_Title) Then
				GetTextSize(*m_Title.vptr, ScaleX(This.ClientWidth), 0, m_TitleFont, True, TitleSize)
				TopHeader = TopHeader + TitleSize.Height
			End If
			mWidth = ScaleX(This.ClientWidth) - MarginLeft - MarginRight
			mHeight = ScaleY(This.ClientHeight) - TopHeader - Footer
			
			'Calculate the Legend Area
			If m_LegendVisible Then
				ColRow = 1
				Select Case m_LegendAlign
				Case LA_RIGHT, LA_LEFT
					With LabelsRect
						TextWidth = 0
						TextHeight = 0
						For i = 0 To ItemsCount - 1
							If TextHeight + m_Item(i).TextHeight > mHeight Then
								.Right = .Right + TextWidth
								ColRow = ColRow + 1
								TextWidth = 0
								TextHeight = 0
							End If
							
							TextHeight = TextHeight + m_Item(i).TextHeight
							.Bottom = .Bottom + m_Item(i).TextHeight
							
							If TextWidth < m_Item(i).TextWidth Then
								TextWidth = m_Item(i).TextWidth '+ PT16
							End If
						Next
						.Right = .Right + TextWidth
						If m_LegendAlign = LA_LEFT Then
							MarginLeft = MarginLeft + .Right
						Else
							MarginRight = MarginRight + .Right
						End If
						mWidth = mWidth - .Right
					End With
					
				Case LA_BOTTOM, LA_TOP
					With LabelsRect
						
						.Bottom = m_Item(0).TextHeight + PT16 / 2
						TextWidth = 0
						For i = 0 To ItemsCount - 1
							If TextWidth + m_Item(i).TextWidth > mWidth Then
								.Bottom = .Bottom + m_Item(i).TextHeight
								ColRow = ColRow + 1
								TextWidth = 0
							End If
							TextWidth = TextWidth + m_Item(i).TextWidth
							.Right = .Right + m_Item(i).TextWidth
						Next
						If m_LegendAlign = LA_TOP Then
							TopHeader = TopHeader + .Bottom
						End If
						mHeight = mHeight - .Bottom
					End With
				End Select
			End If
			
			
			Dim RectF_ As RectF
			With RectF_
				.Width = ScaleX(This.ClientWidth) - 1 * nScale
				.Height = ScaleY(This.ClientHeight) - 1 * nScale
			End With
			
			RoundRect RectF_, RGBtoARGB(FBackColor, m_BackColorOpacity), RGBtoARGB(m_BorderColor, 100), m_BorderRound * nScale, m_Border, m_BackColorOpacity
			
			
			'    'Background
			'    If m_BackColorOpacity > 0 Then
			'        GdipCreateSolidFill RGBtoARGB(m_BackColor, m_BackColorOpacity), hBrush
			'        GdipFillRectangleI hGraphics, hBrush, 0, 0, This.ClientWidth, This.ClientHeight
			'        GdipDeleteBrush hBrush
			'    End If
			'
			'    'Border
			'    If m_Border Then
			'        Call GdipCreatePen1(RGBtoARGB(m_BorderColor, 50), mPenWidth, &H2, hPen)
			'        GdipDrawRectangleI hGraphics, hPen, mPenWidth / 2, mPenWidth / 2, This.ClientWidth - mPenWidth, This.ClientHeight - mPenWidth
			'        GdipDeletePen hPen
			'    End If
			'
			
			
			'Sum of itemes
			For i = 0 To ItemsCount - 1
				Total = Total + m_Item(i).Value
			Next
			
			'calculate max size of labels
			For i = 0 To ItemsCount - 1
				With m_Item(i)
					Percent = Round(100 * .Value / Total, 1)
					If i < ItemsCount - 1 Then
						SafePercent = SafePercent + Percent
					Else
						Percent = Round(100 - SafePercent, 1)
					End If
					.text = Replace(m_LabelsFormats, "{A}", .ItemName)
					.text = Replace(.text, "{P}", WStr(Percent))
					.text = Replace(.text, "{V}", WStr(Round(.Value, 1)))
					.text = Replace(.text, "{LF}", Chr(10))
					
					TextWidth = ScaleX(Canvas.TextWidth(.text)) * 1.3
					TextHeight = ScaleY(Canvas.TextHeight(.text)) * 1.3
					If TextWidth > LblWidth Then LblWidth = TextWidth
					If TextHeight > LblHeight Then LblHeight = TextHeight
				End With
			Next
			
			'size of pie
			If m_LabelsPositions = LP_Outside Or m_LabelsPositions = LP_TwoColumns Then
				Min = IIf(mWidth - LblWidth * 2 < mHeight - LblHeight * 2, mWidth - LblWidth * 2, mHeight - LblHeight * 2)
			Else
				Min = IIf(mWidth < mHeight, mWidth, mHeight)
			End If
			
			If Min / 3 < DonutSize Then DonutSize = Min / 3
			XX = MarginLeft + mWidth / 2 - Min / 2
			YY = TopHeader + mHeight / 2 - Min / 2
			m_CenterCircle.X = MarginLeft + mWidth / 2
			m_CenterCircle.Y = TopHeader + mHeight / 2
			R1 = Min / 2
			
			'    If m_SeparatorLine Then
			'        GdipCreateSolidFill RGBtoARGB(m_SeparatorLineColor, m_BackColorOpacity), hBrush
			'        GdipFillEllipseI hGraphics, hBrush, XX - m_SeparatorLineWidth, YY - m_SeparatorLineWidth, Min + m_SeparatorLineWidth * 2, Min + m_SeparatorLineWidth * 2
			'        GdipDeleteBrush hBrush
			'    End If
			
			LastAngle = m_Rotation - 90
			For i = 0 To ItemsCount - 1
				Angle = 360 * m_Item(i).Value / Total
				
				
				'*1
				If m_Item(i).Special Then
					R2 = PT16 / 1.5
					Left_ = XX + (R2 * Cos((LastAngle + Angle / 2) * PItoRAD))
					Top_ = YY + (R2 * Sin((LastAngle + Angle / 2) * PItoRAD))
				Else
					Left_ = XX
					Top_ = YY
				End If
				
				#ifdef __USE_GTK__
					If m_Item(i).hPath <> 0 Then cairo_path_destroy m_Item(i).hPath
					cairo_new_path(cr)
				#else
					If m_Item(i).hPath <> 0 Then GdipDeletePath m_Item(i).hPath
					GdipCreatePath 0, @m_Item(i).hPath
				#endif
				
				If m_ChartStyle = CS_DONUT Then
					#ifdef __USE_GTK__
						cairo_move_to(cr, Left_ + Min / 2, Top_ + Min / 2)
						cairo_arc(cr, Left_ + Min / 2, Top_ + Min / 2, Min / 2, LastAngle * (G_PI / 180), LastAngle * (G_PI / 180) + Angle * (G_PI / 180))
						cairo_arc_negative(cr, Left_ + DonutSize + (Min - DonutSize * 2) / 2, Top_ + DonutSize + (Min - DonutSize * 2) / 2, (Min - DonutSize * 2) / 2, LastAngle  * (G_PI / 180) + Angle * (G_PI / 180),LastAngle  * (G_PI / 180) + Angle * (G_PI / 180) + -Angle * (G_PI / 180))
					#else
						GdipAddPathArc m_Item(i).hPath, Left_, Top_, Min, Min, LastAngle, Angle
						GdipAddPathArc m_Item(i).hPath, Left_ + DonutSize, Top_ + DonutSize, Min - DonutSize * 2, Min - DonutSize * 2, LastAngle + Angle, -Angle
					#endif
				Else
					#ifdef __USE_GTK__
						cairo_move_to(cr, Left_ + Min / 2, Top_ + Min / 2)
						cairo_arc(cr, Left_ + Min / 2, Top_ + Min / 2, Min / 2, LastAngle * (G_PI / 180), LastAngle * (G_PI / 180) + Angle * (G_PI / 180)) 'LastAngle / 90, Angle / 90
					#else
						GdipAddPathPie m_Item(i).hPath, Left_, Top_, Min, Min, LastAngle, Angle
					#endif
				End If
				#ifdef __USE_GTK__
					m_Item(i).hPath = cairo_copy_path(cr)
				#endif
				
				If HotItem = i Then
					lColor = RGBtoARGB(ShiftColor(m_Item(i).ItemColor, clWhite, 150), m_FillOpacity)
				Else
					lColor = RGBtoARGB(m_Item(i).ItemColor, m_FillOpacity)
				End If
				If m_FillGradient Then
					With RectL_
						.Left = MarginLeft - R2
						.Top = TopHeader - R2
						.Right = mWidth + R2 * 2
						.Bottom = mHeight + R2 * 2
					End With
					#ifndef __USE_GTK__
						GdipCreateLineBrushFromRectWithAngleI Cast(GpRect Ptr, @RectL_), lColor, RGBtoARGB(clWhite, 100), 180 + LastAngle + Angle / 2, 0, WrapModeTile, Cast(GpLineGradient Ptr Ptr, @hBrush)
					#endif
				Else
					#ifndef __USE_GTK__
						GdipCreateSolidFill lColor, Cast(GpSolidFill Ptr Ptr, @hBrush)
					#endif
				End If
				#ifdef __USE_GTK__
					cairo_set_source_rgba(cr, GetRedD(lColor), GetGreenD(lColor), GetBlueD(lColor), m_FillOpacity / 100)
					cairo_fill(cr)
				#else
					GdipFillPath hGraphics, Cast(GpBrush Ptr, hBrush), m_Item(i).hPath
					GdipDeleteBrush Cast(GpBrush Ptr, hBrush)
				#endif
				
				R1 = Min / 2
				R2 = m_Item(i).TextWidth / 2
				R3 = m_Item(i).TextHeight / 2
				
				CX = XX + Min / 2 + TextWidth
				CY = YY + Min / 2 + TextHeight
				
				Left_ = CX + ((R1 - R2) * Cos((LastAngle + Angle / 2) * PItoRAD)) - R2
				Top_ = CY + ((R1 - R3) * Sin((LastAngle + Angle / 2) * PItoRAD)) - R3
				'DrawText hGraphics, m_Item(i).ItemName, Left, Top, R2 * 2, R3 * 2, This.Font, lForeColor, cCenter, cMiddle
				LastAngle = LastAngle + Angle '+ 2
			Next
			
			'*2
			
			LastAngle = m_Rotation - 90
			bAngMaj180 = False
			For i = 0 To ItemsCount - 1
				Angle = 360 * m_Item(i).Value / Total
				
				If m_SeparatorLine Then
					#ifdef __USE_GTK__
						cairo_set_source_rgb(cr, GetRedD(m_SeparatorLineColor), GetGreenD(m_SeparatorLineColor), GetBlueD(m_SeparatorLineColor))
						cairo_set_line_width (cr, m_SeparatorLineWidth * nScale)
						'?m_SeparatorLineWidth
					#else
						GdipCreatePen1 RGBtoARGB(m_SeparatorLineColor, 100), m_SeparatorLineWidth * nScale, 2, @hPen
						GdipSetPenEndCap hPen, 2
					#endif
					
					R1 = (Min + mPenWidth / 2) / 2
					R2 = (Min - mPenWidth / 2) / 2 - DonutSize
					
					CX = XX + Min / 2
					CY = YY + Min / 2
					
					Left_ = CX + (R1 * Cos((LastAngle) * PItoRAD))
					Top_ = CY + (R1 * Sin((LastAngle) * PItoRAD))
					
					If m_ChartStyle = CS_DONUT Then
						CX = CX + (R2 * Cos((LastAngle) * PItoRAD))
						CY = CY + (R2 * Sin((LastAngle) * PItoRAD))
					Else
						'GdipDrawEllipseI hGraphics, hPen, XX, YY, Min, Min
					End If
					
					#ifdef __USE_GTK__
						cairo_move_to(cr, Left_, Top_)
						cairo_line_to(cr, CX, CY)
						cairo_stroke(cr)
					#else
						GdipDrawLineI hGraphics, hPen, Left_, Top_, CX, CY
						
						GdipDeletePen hPen
					#endif
				End If
				
				TextWidth = LblWidth
				TextHeight = LblHeight
				
				If m_LabelsPositions = LP_Inside Then
					If DonutSize > TextWidth Then TextWidth = DonutSize
					If DonutSize > TextHeight Then TextHeight = DonutSize
				End If
				
				R2 = TextWidth / 2
				R3 = TextHeight / 2
				Displacement = IIf(m_Item(i).Special, PT16 / 1.5, 0)
				
				CX = XX + Min / 2
				CY = YY + Min / 2
				
				A = LastAngle + Angle / 2
				
				If m_LabelsPositions = LP_Inside Then
					Left_ = CX + ((R1 - R2 + Displacement) * Cos(A * PItoRAD)) - R2
					Top_ = CY + ((R1 - R3 + Displacement) * Sin(A * PItoRAD)) - R3
				Else
					Left_ = CX + ((R1 + R2 + Displacement) * Cos(A * PItoRAD)) - R2
					Top_ = CY + ((R1 + R3 + Displacement) * Sin(A * PItoRAD)) - R3
				End If
				If m_LabelsVisible Then
					If m_LabelsPositions = LP_TwoColumns Then
						Dim LineOut As Integer
						LineOut = ScaleY(Canvas.TextHeight("Aj")) / 2
						
						#ifdef __USE_GTK__
							Var BrushColor = RGBtoARGB(m_Item(i).ItemColor, 50), BrushAlpha = 0.5
							Var PenColor = RGBtoARGB(m_Item(i).ItemColor, 50), PenAlpha = 1
							cairo_set_line_width(cr, 1 * nScale)
						#else
							GdipCreateSolidFill RGBtoARGB(m_Item(i).ItemColor, 50), Cast(GpSolidFill Ptr Ptr, @hBrush)
							GdipCreatePen1 RGBtoARGB(m_Item(i).ItemColor, 100), 1 * nScale, 2, @hPen
						#endif
						
						If (LastAngle + Angle / 2 + 90) Mod 359 < 180 Then
							If bAngMaj180 Then
								bAngMaj180 = False
								lTop = Top_
							End If
							
							If lTop <= 0 Then lTop = Top_
							
							If Top_ < lTop Then
								lTop = lTop
							Else
								lTop = Top_
							End If
							
							Left_ = XX + Min + PT16
							#ifdef __USE_GTK__
								cairo_set_source_rgba(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor), BrushAlpha)
								cairo_rectangle(cr, Left_, lTop, TextWidth, TextHeight)
								cairo_fill(cr)
							#else
								GdipFillRectangleI hGraphics, Cast(GpBrush Ptr, hBrush), Left_, lTop, TextWidth, TextHeight
							#endif
							DrawText m_Item(i).text, Left_, lTop, TextWidth, TextHeight, This.Font, RGBtoARGB(FForeColor, 100), cCenter, cMiddle
							
							lTop = lTop + TextHeight
							
							Left_ = CX + (R1 * Cos(A * PItoRAD))
							Top_ = CY + (R1 * Sin(A * PItoRAD))
							CX = CX + ((R1 + LineOut) * Cos(A * PItoRAD))
							CY = CY + ((R1 + LineOut) * Sin(A * PItoRAD))
							
							#ifdef __USE_GTK__
								cairo_set_source_rgba(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor), PenAlpha)
								cairo_move_to(cr, Left_, Top_)
								cairo_line_to(cr, CX, CY)
								cairo_stroke(cr)
							#else
								GdipDrawLineI hGraphics, hPen, Left_, Top_, CX, CY
							#endif
							Left_ = XX + Min + PT16
							Top_ = lTop - TextHeight / 2
							#ifdef __USE_GTK__
								cairo_set_source_rgba(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor), PenAlpha)
								cairo_move_to(cr, CX, CY)
								cairo_line_to(cr, Left_, Top_)
								cairo_stroke(cr)
							#else
								GdipDrawLineI hGraphics, hPen, CX, CY, Left_, Top_
							#endif
						Else
							If bAngMaj180 = False Then
								bAngMaj180 = True
								lTop = TopHeader + mHeight
							End If
							
							If lTop <= 0 Then lTop = Top_
							
							If Top_ > lTop Then
								lTop = lTop
							Else
								lTop = Top_
							End If
							
							Left_ = XX - TextWidth - PT16
							#ifdef __USE_GTK__
								cairo_set_source_rgba(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor), BrushAlpha)
								cairo_rectangle(cr, Left_, lTop, TextWidth, TextHeight)
								cairo_fill(cr)
							#else
								GdipFillRectangleI hGraphics, Cast(GpBrush Ptr, hBrush), Left_, lTop, TextWidth, TextHeight
							#endif
							DrawText m_Item(i).text, Left_, lTop, TextWidth, TextHeight, This.Font, RGBtoARGB(FForeColor, 100), cCenter, cMiddle
							
							Left_ = CX + (R1 * Cos(A * PItoRAD))
							Top_ = CY + (R1 * Sin(A * PItoRAD))
							CX = CX + ((R1 + LineOut) * Cos(A * PItoRAD))
							CY = CY + ((R1 + LineOut) * Sin(A * PItoRAD))
							#ifdef __USE_GTK__
								cairo_set_source_rgba(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor), PenAlpha)
								cairo_move_to(cr, Left_, Top_)
								cairo_line_to(cr, CX, CY)
								cairo_stroke(cr)
							#else
								GdipDrawLineI hGraphics, hPen, Left_, Top_, CX, CY
							#endif
							Left_ = XX - PT16
							Top_ = lTop + TextHeight / 2
							#ifdef __USE_GTK__
								cairo_set_source_rgba(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor), PenAlpha)
								cairo_move_to(cr, CX, CY)
								cairo_line_to(cr, Left_, Top_)
								cairo_stroke(cr)
							#else
								GdipDrawLineI hGraphics, hPen, CX, CY, Left_, Top_
							#endif
							lTop = lTop - TextHeight
						End If
						#ifndef __USE_GTK__
							GdipDeleteBrush Cast(GpBrush Ptr, hBrush)
							GdipDeletePen hPen
						#endif
						
					ElseIf m_LabelsPositions = LP_Inside Then
						'lForeColor = IIf(IsDarkColor(m_Item(i).ItemColor), &H808080, vbWhite)
						'DrawText hGraphics, m_Item(i).Text, Left + 1, Top + 1, TextWidth, TextHeight, This.Font, RGBtoARGB(lForeColor, 100), cCenter, cMiddle
						If HotItem = i Then
							lColor = ShiftColor(m_Item(i).ItemColor, clWhite, 150)
						Else
							lColor = m_Item(i).ItemColor
						End If
						lForeColor = IIf(IsDarkColor(lColor), clWhite, clBlack)
						DrawText m_Item(i).text, Left_, Top_, TextWidth, TextHeight, This.Font, RGBtoARGB(lForeColor, 100), cCenter, cMiddle
					Else
						DrawText m_Item(i).text, Left_, Top_, TextWidth, TextHeight, This.Font, RGBtoARGB(FForeColor, 100), cCenter, cMiddle
					End If
				End If
				LastAngle = LastAngle + Angle '+ 2
			Next
			
			
			
			If m_LegendVisible Then
				For i = 0 To ItemsCount - 1
					lForeColor = RGBtoARGB(FForeColor, 100)
					Select Case m_LegendAlign
					Case LA_RIGHT, LA_LEFT
						With LabelsRect
							TextWidth = 0
							
							If .Left = 0 Then
								TextHeight = 0
								If m_LegendAlign = LA_LEFT Then
									.Left = PT16
								Else
									.Left = MarginLeft + mWidth + PT16
								End If
								If ColRow = 1 Then
									.Top = TopHeader + mHeight / 2 - .Bottom / 2
								Else
									.Top = TopHeader
								End If
							End If
							
							If TextWidth < m_Item(i).TextWidth Then
								TextWidth = m_Item(i).TextWidth '+ PT16
							End If
							
							If TextHeight + m_Item(i).TextHeight > mHeight Then
								If i > 0 Then .Left = .Left + TextWidth
								.Top = TopHeader
								TextHeight = 0
							End If
							m_Item(i).LegendRect.Left = .Left
							m_Item(i).LegendRect.Top = .Top
							m_Item(i).LegendRect.Right = m_Item(i).TextWidth
							m_Item(i).LegendRect.Bottom = m_Item(i).TextHeight
							'?"LegendRect", m_Item(i).LegendRect.Left, m_Item(i).LegendRect.Top
							
							With m_Item(i).LegendRect
								#ifdef __USE_GTK__
									cairo_set_source_rgba(cr, GetRedD(m_Item(i).ItemColor), GetGreenD(m_Item(i).ItemColor), GetBlueD(m_Item(i).ItemColor), 1)
									cairo_arc(cr, .Left + (m_Item(i).TextHeight / 2) / 2 - 0.5, .Top + m_Item(i).TextHeight / 4 + (m_Item(i).TextHeight / 2) / 2 - 0.5, m_Item(i).TextHeight / 2 / 2 - 0.5, 0, 2 * G_PI)
									cairo_fill(cr)
								#else
									GdipCreateSolidFill RGBtoARGB(m_Item(i).ItemColor, 100), Cast(GpSolidFill Ptr Ptr, @hBrush) '&hB0000000
									GdipFillEllipseI hGraphics, Cast(GpBrush Ptr, hBrush), .Left, .Top + m_Item(i).TextHeight / 4, m_Item(i).TextHeight / 2, m_Item(i).TextHeight / 2
									GdipDeleteBrush Cast(GpBrush Ptr, hBrush)
								#endif
							End With
							DrawText m_Item(i).ItemName, .Left + m_Item(i).TextHeight / 1.5, .Top, m_Item(i).TextWidth, m_Item(i).TextHeight, This.Font, lForeColor, cLeft, cMiddle
							TextHeight = TextHeight + m_Item(i).TextHeight
							.Top = .Top + m_Item(i).TextHeight
							
						End With
						
					Case LA_BOTTOM, LA_TOP
						With LabelsRect
							If .Left = 0 Then
								If ColRow = 1 Then
									.Left = MarginLeft + mWidth / 2 - .Right / 2
								Else
									.Left = MarginLeft
								End If
								If m_LegendAlign = LA_TOP Then
									.Top = PT16 + TitleSize.Height
								Else
									.Top = TopHeader + mHeight + TitleSize.Height - PT16 / 2
								End If
							End If
							
							If .Left + m_Item(i).TextWidth - MarginLeft > mWidth Then
								.Left = MarginLeft
								.Top = .Top + m_Item(i).TextHeight
							End If
							
							#ifdef __USE_GTK__
								cairo_set_source_rgba(cr, GetRedD(m_Item(i).ItemColor), GetGreenD(m_Item(i).ItemColor), GetBlueD(m_Item(i).ItemColor), 1)
								cairo_arc(cr, .Left + (m_Item(i).TextHeight / 2) / 2 - 0.5, .Top + m_Item(i).TextHeight / 4 + (m_Item(i).TextHeight / 2) / 2 - 0.5, m_Item(i).TextHeight / 2 / 2, 0, 2 * G_PI)
								cairo_fill(cr)
							#else
								GdipCreateSolidFill RGBtoARGB(m_Item(i).ItemColor, 100), Cast(GpSolidFill Ptr Ptr, @hBrush)
								GdipFillEllipseI hGraphics, Cast(GpBrush Ptr, hBrush), .Left, .Top + m_Item(i).TextHeight / 4, m_Item(i).TextHeight / 2, m_Item(i).TextHeight / 2
								GdipDeleteBrush Cast(GpBrush Ptr, hBrush)
							#endif
							m_Item(i).LegendRect.Left = .Left
							m_Item(i).LegendRect.Top = .Top
							m_Item(i).LegendRect.Right = m_Item(i).TextWidth
							m_Item(i).LegendRect.Bottom = m_Item(i).TextHeight
							
							DrawText m_Item(i).ItemName, .Left + m_Item(i).TextHeight / 1.5, .Top, m_Item(i).TextWidth, m_Item(i).TextHeight, This.Font, lForeColor, cLeft, cMiddle
							.Left = .Left + m_Item(i).TextWidth '+ M_ITEM(i).TextHeight / 1.5
						End With
					End Select
					
					
				Next
			End If
		Case CS_AREA
			
			Canvas.Font = This.Font
			'PT16 = 16 * nScale
			PT16 = (ScaleX(This.ClientWidth) + ScaleY(This.ClientHeight)) * 2.5 / 100
			
			PT24 = 24 * nScale
			mPenWidth = 1 * nScale
			LW = m_LinesWidth * nScale
			If LW < 1 Then LW = 1
			lForeColor = RGBtoARGB(FForeColor, 100)
			
			'If SerieCount > 1 Then BarSpace = LW * 4
			
			Max = IIf(m_AxisMax <> 0, m_AxisMax, GetMax())
			Min = IIf(m_AxisMin <> 0, m_AxisMin, GetMin())
			
			If m_AxisXVisible Then
				If cAxisItem <> 0 Then
					For i = 0 To cAxisItem->Count - 1
						TextWidth = ScaleX(Canvas.TextWidth(cAxisItem->Item(i))) * 1.3
						TextHeight = ScaleY(Canvas.TextHeight(cAxisItem->Item(i))) * 1.3
						If TextWidth > AxisX.Width Then AxisX.Width = TextWidth
						If TextHeight > AxisX.Height Then AxisX.Height = TextHeight
					Next
				End If
				
				If m_AxisAngle <> 0 Then
					With AxisX
						Select Case m_AxisAngle
						Case Is <= 90
							.Height = .Height + m_AxisAngle * (.Width - .Height) / 90
						Case Is < 180
							.Height = .Height + (180 - m_AxisAngle) * (.Width - .Height) / 90
						Case Is < 270
							.Height = .Height + (m_AxisAngle Mod 90) * (.Width - .Height) / 90
						Case Else
							.Height = .Height + (360 - m_AxisAngle) * (.Width - .Height) / 90
						End Select
					End With
				End If
			End If
			
			If m_AxisYVisible Then
				Value = IIf(Len(WStr(Max)) > Len(WStr(Min)), Max, Min)
				sDisplay = Replace(m_LabelsFormats, "{V}", WStr(Value))
				sDisplay = Replace(sDisplay, "{LF}", Chr(10))
				If Len(sDisplay) = 1 Then sDisplay = "0.9"
				AxisY.Width = ScaleX(Canvas.TextWidth(WStr(sDisplay))) * 1.5
				AxisY.Height = ScaleY(Canvas.TextHeight(WStr(sDisplay))) * 1.5
			End If
			
			
			If m_LegendVisible Then
				For i = 0 To SerieCount - 1
					m_Serie(i).TextHeight = ScaleY(Canvas.TextHeight(m_Serie(i).SerieName)) * 1.5
					m_Serie(i).TextWidth = ScaleX(Canvas.TextWidth(m_Serie(i).SerieName)) * 1.5 + m_Serie(i).TextHeight
				Next
			End If
			
			If Len(m_Title) Then
				GetTextSize(m_Title, ScaleX(This.ClientWidth), 0, m_TitleFont, True, TitleSize)
			End If
			
			MarginRight = PT16
			TopHeader = PT16 + TitleSize.Height
			MarginLeft = PT16 + AxisY.Width
			Footer = PT16 + AxisX.Height
			
			mWidth = ScaleX(This.ClientWidth) - MarginLeft - MarginRight
			mHeight = ScaleY(This.ClientHeight) - TopHeader - Footer
			
			If m_LegendVisible Then
				ColRow = 1
				Select Case m_LegendAlign
				Case LA_RIGHT, LA_LEFT
					With LabelsRect
						TextWidth = 0
						TextHeight = 0
						For i = 0 To SerieCount - 1
							If TextHeight + m_Serie(i).TextHeight > mHeight Then
								.Right = .Right + TextWidth
								ColRow = ColRow + 1
								TextWidth = 0
								TextHeight = 0
							End If
							
							TextHeight = TextHeight + m_Serie(i).TextHeight
							.Bottom = .Bottom + m_Serie(i).TextHeight
							
							If TextWidth < m_Serie(i).TextWidth Then
								TextWidth = m_Serie(i).TextWidth '+ PT16
							End If
						Next
						.Right = .Right + TextWidth
						If m_LegendAlign = LA_LEFT Then
							MarginLeft = MarginLeft + .Right
						Else
							MarginRight = MarginRight + .Right
						End If
						mWidth = mWidth - .Right
					End With
					
				Case LA_BOTTOM, LA_TOP
					With LabelsRect
						
						.Bottom = m_Serie(0).TextHeight + PT16 / 2
						TextWidth = 0
						For i = 0 To SerieCount - 1
							If TextWidth + m_Serie(i).TextWidth > mWidth Then
								.Bottom = .Bottom + m_Serie(i).TextHeight
								ColRow = ColRow + 1
								TextWidth = 0
							End If
							TextWidth = TextWidth + m_Serie(i).TextWidth
							.Right = .Right + m_Serie(i).TextWidth
						Next
						If m_LegendAlign = LA_TOP Then
							TopHeader = TopHeader + .Bottom
						End If
						mHeight = mHeight - .Bottom
					End With
				End Select
			End If
			
			If cAxisItem AndAlso cAxisItem->Count Then
				AxisDistance = (mWidth - mPenWidth) / (cAxisItem->Count - 1)
			End If
			
			If SerieCount > 0 Then
				PtDistance = (mWidth - mPenWidth) / (m_Serie(0).Values->Count - 1)
			End If
			
			'    If (m_ChartStyle = CS_StackedBars) Or (m_ChartStyle = CS_StackedBarsPercent) Then
			'        BarWidth = (PtDistance / 2)
			'    Else
			'        BarWidth = (PtDistance / (SerieCount + 0.5))
			'    End If
			
			
			NumDecim = 1
			
			If m_AxisMin Then forLines = m_AxisMin
			If m_AxisMax Then toLines = m_AxisMax
			
			
			nVal = Max + Abs(Min)
			
			Do While nVal > 9.5
				nVal = nVal / 9.99
				NumDecim = NumDecim * 10
			Loop
			
			Select Case nVal
			Case 0 To 1.999999
				iStep = 0.2
			Case 2 To 4.799999
				iStep = 0.5
			Case 4.8 To 9.599999
				iStep = 1
			End Select
			
			Dim nDec As Single
			nDec = 1
			Do
				If nDec * iStep * NumDecim > IIf(Max > Abs(Min), Max, Abs(Min)) * 3 Then Exit Do
				
				If Max > 0 Then
					If m_AxisMax = 0 Then
						toLines = CInt((Max / NumDecim + iStep) / iStep) * (iStep * NumDecim)
					End If
				End If
				
				If Min < 0 Then
					If m_AxisMin = 0 Then
						forLines = CInt((Min / (iStep * NumDecim)) - 1) * (iStep * NumDecim)
					End If
				End If
				
				RangeHeight = (mHeight / ((toLines + Abs(forLines)) / (iStep * NumDecim)))
				
				Exit Do
				If RangeHeight < AxisY.Height Then
					
					
					Select Case iStep
					Case Is = 0.2 * nDec: iStep = 0.5 * nDec
					Case Is = 0.5 * nDec: iStep = 1 * nDec
					Case Is = 1 * nDec: nDec = nDec * 10: iStep = 0.2 * nDec
					End Select
				Else
					Exit Do
				End If
			Loop
			
			
'			If GdipCreateFromHDC(hD, @hGraphics) = 0 Then
'				
'				GdipSetSmoothingMode(hGraphics, SmoothingModeAntiAlias)
'				GdipSetCompositingQuality(hGraphics, &H3) 'CompositingQualityGammaCorrected
'				
				Dim RectF_ As RectF
				With RectF_
					.Width = ScaleX(This.ClientWidth) - 1 * nScale
					.Height = ScaleY(This.ClientHeight) - 1 * nScale
				End With
				
				RoundRect RectF_, RGBtoARGB(FBackColor, m_BackColorOpacity), RGBtoARGB(m_BorderColor, 100), m_BorderRound * nScale, m_Border, m_BackColorOpacity
				
				
				'HORIZONTAL LINES AND vertical axis
				#ifdef __USE_GTK__
					Var PenColor = RGBtoARGB(m_LinesColor, 100)
					cairo_set_line_width(cr, mPenWidth)
				#else
					GdipCreatePen1(RGBtoARGB(m_LinesColor, 100), mPenWidth, &H2, @hPen)
				#endif
				
				YY = TopHeader + mHeight
				yRange = forLines
				
				If toLines = 0 And forLines = 0 Then toLines = 1
				RangeHeight = (mHeight / ((toLines + Abs(forLines)) / (iStep * NumDecim)))
				ZeroPoint = TopHeader + mHeight - RangeHeight * (Abs(forLines) / (iStep * NumDecim))
				
				For i = forLines / (iStep * NumDecim) To toLines / (iStep * NumDecim)
					If m_HorizontalLines Then
						#ifdef __USE_GTK__
							cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
							cairo_move_to(cr, MarginLeft, YY)
							cairo_line_to(cr, This.ClientWidth - MarginRight - mPenWidth, YY)
							cairo_stroke(cr)
						#else
							GdipDrawLine hGraphics, hPen, MarginLeft, YY, ScaleX(This.ClientWidth) - MarginRight - mPenWidth, YY
						#endif
					End If
					
					If m_AxisYVisible Then
						sDisplay = Replace(m_LabelsFormats, "{V}", WStr(yRange))
						sDisplay = Replace(sDisplay, "{LF}", Chr(10))
						DrawText sDisplay, 0, YY - RangeHeight / 2, MarginLeft - 8 * nScale, RangeHeight, This.Font, lForeColor, cRight, cMiddle
					End If
					YY = YY - RangeHeight
					yRange = yRange + CLng(iStep * NumDecim)
				Next
				
				If m_VerticalLines And SerieCount > 0 Then
					For i = 0 To m_Serie(0).Values->Count - 1
						XX = MarginLeft + PtDistance * i
						#ifdef __USE_GTK__
							cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
							cairo_move_to(cr, XX, TopHeader)
							cairo_line_to(cr, XX, TopHeader + mHeight + 4 * nScale)
							cairo_stroke(cr)
						#else
							GdipDrawLine hGraphics, hPen, XX, TopHeader, XX, TopHeader + mHeight + 4 * nScale
						#endif
					Next
				End If
				
				#ifndef __USE_GTK__
					GdipDeletePen hPen
				#endif
				
				For i = 0 To SerieCount - 1
					'Calculo
					ReDim (m_Serie(i).PT)(m_Serie(i).Values->Count - 1)
					
					For j = 0 To m_Serie(i).Values->Count - 1
						Value = m_Serie(i).Values->Item(j) ' + 1
						With m_Serie(i).PT(j)
							.X = MarginLeft + PtDistance * j
							'.Y = TopHeader + mHeight - (m_Serie(i).Values(j + 1) * (Max * mHeight / toLines) / Max)
							If Value >= 0 Then
								.Y = ZeroPoint - (Value * (ZeroPoint - TopHeader) / toLines)
							Else
								.Y = ZeroPoint + (Value * (TopHeader + mHeight - ZeroPoint) / forLines)
							End If
						End With
					Next
					
					'fill Line/Curve
					If m_FillOpacity > 0 Then
						#ifdef __USE_GTK__
							cairo_new_path(cr)
							If True Then
						#else
							If GdipCreatePath(&H0, @hPath) = 0 Then
						#endif
							#ifdef __USE_GTK__
								'cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
								cairo_move_to cr, MarginLeft, ZeroPoint
								'cairo_line_to cr, MarginLeft, ZeroPoint
							#else
								GdipAddPathLineI hPath, MarginLeft, ZeroPoint, MarginLeft, ZeroPoint
							#endif
							If m_LinesCurve Then
								#ifdef __USE_GTK__
									'cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
									cairo_line_to(cr, m_Serie(i).PT(0).X, m_Serie(i).PT(0).Y)
									For l As Integer = 1 To UBound(m_Serie(i).PT)
										Dim As Single Y
										If l Mod 2 = 1 Then
											If m_Serie(i).PT(l).Y > m_Serie(i).PT(l - 1).Y Then
												Y = IIf(m_Serie(i).PT(l - 1).Y > m_Serie(i).PT(l).Y, m_Serie(i).PT(l - 1).Y, m_Serie(i).PT(l).Y)
											Else
												Y = IIf(m_Serie(i).PT(l - 1).Y < m_Serie(i).PT(l).Y, m_Serie(i).PT(l - 1).Y, m_Serie(i).PT(l).Y)
											End If
										ElseIf l Mod 2 = 0 Then
											If m_Serie(i).PT(l).Y > m_Serie(i).PT(l - 1).Y Then
												Y = IIf(m_Serie(i).PT(l - 1).Y < m_Serie(i).PT(l).Y, m_Serie(i).PT(l - 1).Y, m_Serie(i).PT(l).Y)
											Else
												Y = IIf(m_Serie(i).PT(l - 1).Y > m_Serie(i).PT(l).Y, m_Serie(i).PT(l - 1).Y, m_Serie(i).PT(l).Y)
											End If
										End If
										cairo_curve_to cr, m_Serie(i).PT(l - 1).X, m_Serie(i).PT(l - 1).Y, (m_Serie(i).PT(l).X + m_Serie(i).PT(l - 1).X) / 2, Y, m_Serie(i).PT(l).X, m_Serie(i).PT(l).Y
									Next
								#else
									GdipAddPathCurveI hPath, Cast(GpPoint Ptr, @m_Serie(i).PT(0)), UBound(m_Serie(i).PT) + 1
								#endif
							Else
								#ifdef __USE_GTK__
									'cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
									cairo_line_to(cr, m_Serie(i).PT(0).X, m_Serie(i).PT(0).Y)
									For l As Integer = 1 To UBound(m_Serie(i).PT)
										cairo_line_to cr, m_Serie(i).PT(l).X, m_Serie(i).PT(l).Y
									Next
									'cairo_stroke(cr)
								#else
									GdipAddPathLine2I hPath, Cast(GpPoint Ptr, @m_Serie(i).PT(0)), UBound(m_Serie(i).PT) + 1
								#endif
							End If
							#ifdef __USE_GTK__
								'cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
								'cairo_move_to(cr, MarginLeft + mWidth - mPenWidth, ZeroPoint)
								cairo_line_to(cr, MarginLeft + mWidth - mPenWidth, ZeroPoint)
								'cairo_stroke(cr)
							#else
								GdipAddPathLineI hPath, MarginLeft + mWidth - mPenWidth, ZeroPoint, MarginLeft + mWidth - mPenWidth, ZeroPoint
							#endif
							
							Dim As ULong BrushColor
							If m_FillGradient Then
								With RectL_
									.Top = TopHeader
									
									.Right = mWidth
									.Bottom = ZeroPoint - TopHeader
								End With
								#ifdef __USE_GTK__
									BrushColor = RGBtoARGB(m_Serie(i).SerieColor, m_FillOpacity)
								#else
									GdipCreateLineBrushFromRectWithAngleI Cast(GpRect Ptr, @RectL_), RGBtoARGB(m_Serie(i).SerieColor, m_FillOpacity), RGBtoARGB(m_Serie(i).SerieColor, 10), 90, 0, WrapModeTileFlipXY, Cast(GpLineGradient Ptr Ptr, @hBrush)
								#endif
							Else
								#ifdef __USE_GTK__
									BrushColor = RGBtoARGB(m_Serie(i).SerieColor, m_FillOpacity)
								#else
									GdipCreateSolidFill RGBtoARGB(m_Serie(i).SerieColor, m_FillOpacity), Cast(GpSolidFill Ptr Ptr, @hBrush)
								#endif
							End If
							
							#ifdef __USE_GTK__
								cairo_close_path(cr)
								cairo_set_source_rgba(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor), m_FillOpacity / 100)
								cairo_fill(cr)
								
								cairo_new_path(cr)
							#else
								GdipFillPath hGraphics, hBrush, hPath
								GdipDeleteBrush hBrush
								
								GdipDeletePath hPath
							#endif
						End If
					End If
					
					'Draw Lines or Curve
					If mHotSerie = i Then LW = LW * 1.5 Else LW = m_LinesWidth * nScale
					#ifdef __USE_GTK__
						Var PenColor = RGBtoARGB(m_Serie(i).SerieColor, 100)
						cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
						cairo_set_line_width(cr, LW)
					#else
						GdipCreatePen1 RGBtoARGB(m_Serie(i).SerieColor, 100), LW, &H2, @hPen
					#endif
					If m_LinesCurve Then
						#ifdef __USE_GTK__
							cairo_move_to(cr, m_Serie(i).PT(0).X, m_Serie(i).PT(0).Y)
							For l As Integer = 1 To UBound(m_Serie(i).PT)
								Dim As Single Y
								If l Mod 2 = 1 Then
									If m_Serie(i).PT(l).Y > m_Serie(i).PT(l - 1).Y Then
										Y = IIf(m_Serie(i).PT(l - 1).Y > m_Serie(i).PT(l).Y, m_Serie(i).PT(l - 1).Y, m_Serie(i).PT(l).Y)
									Else
										Y = IIf(m_Serie(i).PT(l - 1).Y < m_Serie(i).PT(l).Y, m_Serie(i).PT(l - 1).Y, m_Serie(i).PT(l).Y)
									End If
								ElseIf l Mod 2 = 0 Then
									If m_Serie(i).PT(l).Y > m_Serie(i).PT(l - 1).Y Then
										Y = IIf(m_Serie(i).PT(l - 1).Y < m_Serie(i).PT(l).Y, m_Serie(i).PT(l - 1).Y, m_Serie(i).PT(l).Y)
									Else
										Y = IIf(m_Serie(i).PT(l - 1).Y > m_Serie(i).PT(l).Y, m_Serie(i).PT(l - 1).Y, m_Serie(i).PT(l).Y)
									End If
								End If
								cairo_curve_to cr, m_Serie(i).PT(l - 1).X, m_Serie(i).PT(l - 1).Y, (m_Serie(i).PT(l).X + m_Serie(i).PT(l - 1).X) / 2, Y, m_Serie(i).PT(l).X, m_Serie(i).PT(l).Y
							Next
							cairo_stroke(cr)
						#else
							GdipDrawCurveI hGraphics, hPen, Cast(GpPoint Ptr, @m_Serie(i).PT(0)), UBound(m_Serie(i).PT) + 1
						#endif
					Else
						#ifdef __USE_GTK__
							cairo_move_to(cr, m_Serie(i).PT(0).X, m_Serie(i).PT(0).Y)
							For l As Integer = 1 To UBound(m_Serie(i).PT)
								cairo_line_to cr, m_Serie(i).PT(l).X, m_Serie(i).PT(l).Y
							Next
							cairo_stroke(cr)
						#else
							GdipDrawLinesI hGraphics, hPen, Cast(GpPoint Ptr, @m_Serie(i).PT(0)), UBound(m_Serie(i).PT) + 1
						#endif
					End If
					#ifndef __USE_GTK__
						GdipDeletePen hPen
					#endif
					
					If m_LegendVisible Then
						Select Case m_LegendAlign
						Case LA_RIGHT, LA_LEFT
							With LabelsRect
								TextWidth = 0
								
								If .Left = 0 Then
									TextHeight = 0
									If m_LegendAlign = LA_LEFT Then
										.Left = PT16
									Else
										.Left = MarginLeft + mWidth + PT16
									End If
									If ColRow = 1 Then
										.Top = TopHeader + mHeight / 2 - .Bottom / 2
									Else
										.Top = TopHeader
									End If
								End If
								
								If TextWidth < m_Serie(i).TextWidth Then
									TextWidth = m_Serie(i).TextWidth '+ PT16
								End If
								
								If TextHeight + m_Serie(i).TextHeight > mHeight Then
									If i > 0 Then .Left = .Left + TextWidth
									.Top = TopHeader
									TextHeight = 0
								End If
								m_Serie(i).LegendRect.Left = .Left
								m_Serie(i).LegendRect.Top = .Top
								m_Serie(i).LegendRect.Right = m_Serie(i).TextWidth
								m_Serie(i).LegendRect.Bottom = m_Serie(i).TextHeight
								
								#ifdef __USE_GTK__
									Var BrushColor = RGBtoARGB(m_Serie(i).SerieColor, 100)
									cairo_set_source_rgb(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor))
									cairo_rectangle(cr, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2)
									cairo_fill(cr)
								#else
									GdipCreateSolidFill RGBtoARGB(m_Serie(i).SerieColor, 100), Cast(GpSolidFill Ptr Ptr, @hBrush)
									GdipFillRectangleI hGraphics, hBrush, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2
									GdipDeleteBrush hBrush
								#endif
								
								DrawText m_Serie(i).SerieName, .Left + m_Serie(i).TextHeight / 1.5, .Top, m_Serie(i).TextWidth, m_Serie(i).TextHeight, This.Font, lForeColor, cLeft, cMiddle
								TextHeight = TextHeight + m_Serie(i).TextHeight
								.Top = .Top + m_Serie(i).TextHeight
								
							End With
							
						Case LA_BOTTOM, LA_TOP
							With LabelsRect
								If .Left = 0 Then
									If ColRow = 1 Then
										.Left = MarginLeft + mWidth / 2 - .Right / 2
									Else
										.Left = MarginLeft
									End If
									If m_LegendAlign = LA_TOP Then
										.Top = PT16 + TitleSize.Height
									Else
										.Top = TopHeader + mHeight + TitleSize.Height + PT16 / 2
									End If
								End If
								
								If .Left + m_Serie(i).TextWidth - MarginLeft > mWidth Then
									.Left = MarginLeft
									.Top = .Top + m_Serie(i).TextHeight
								End If
								
								#ifdef __USE_GTK__
									Var BrushColor = RGBtoARGB(m_Serie(i).SerieColor, 100)
									cairo_set_source_rgb(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor))
									cairo_rectangle(cr, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2)
									cairo_fill(cr)
								#else
									GdipCreateSolidFill RGBtoARGB(m_Serie(i).SerieColor, 100), Cast(GpSolidFill Ptr Ptr, @hBrush)
									GdipFillRectangleI hGraphics, hBrush, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2
									GdipDeleteBrush hBrush
								#endif
								m_Serie(i).LegendRect.Left = .Left
								m_Serie(i).LegendRect.Top = .Top
								m_Serie(i).LegendRect.Right = m_Serie(i).TextWidth
								m_Serie(i).LegendRect.Bottom = m_Serie(i).TextHeight
								
								DrawText m_Serie(i).SerieName, .Left + m_Serie(i).TextHeight / 1.5, .Top, m_Serie(i).TextWidth, m_Serie(i).TextHeight, This.Font, lForeColor, cLeft, cMiddle
								.Left = .Left + m_Serie(i).TextWidth '+ m_Serie(i).TextHeight / 1.5
							End With
						End Select
					End If
					
					
					'            If m_LabelsVisible Then
					'                GdipCreateSolidFill RGBtoARGB(m_Serie(i).SeireColor, 80), hBrush
					'                For j = 0 To UBound(PT2)
					'                    GdipFillEllipseI hGraphics, hBrush, PT2(j).X - LW * 2 - mPenWidth, PT2(j).Y - LW * 2 - mPenWidth, LW * 6, LW * 6
					'                    GdipCreatePen1 RGBtoARGB(vbWhite, 100), LW, &H2, hPen
					'                    GdipDrawEllipseI hGraphics, hPen, PT2(j).X - LW * 2 - mPenWidth, PT2(j).Y - LW * 2 - mPenWidth, LW * 6, LW * 6
					'                    GdipDeletePen hPen
					'                    TextWidth = Canvas.TextWidth(CStr(m_Serie(i).Values(j + 1))) + 25
					'                    'DrawText hGraphics, m_Serie(i).Values(J + 1), PT2(J).x - TextWidth / 2 + 1, PT2(J).y - TextHeight * 1.5 + 1, TextWidth, TextHeight, This.Font, lForeColor, cCenter, cMiddle
					'                    DrawText hGraphics, m_Serie(i).Values(j + 1), PT2(j).X - TextWidth / 2, PT2(j).Y - TextHeight * 1.5, TextWidth, TextHeight, This.Font, RGBtoARGB(m_Serie(i).SeireColor, 100), cCenter, cMiddle
					'                Next
					'                GdipDeleteBrush hBrush
					'            End If
					
					
					'Marck Colors
					Dim PTSZ As Single
					PTSZ = LW * 2
					'If mHotSerie = i Then PTSZ = LW * 1.2 Else PTSZ = LW * 1.2
					'If PTSZ < 3 * nScale Then PTSZ = 3 * nScale
					For j = 0 To m_Serie(i).Values->Count - 1
						If mHotBar = j Then
							#ifdef __USE_GTK__
								Var PenColor = RGBtoARGB(m_LinesColor, 100)
								cairo_set_line_width(cr, mPenWidth)
							#else
								GdipCreatePen1(RGBtoARGB(m_LinesColor, 100), mPenWidth, &H2, @hPen)
							#endif
							XX = MarginLeft + PtDistance * j
							#ifdef __USE_GTK__
								cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
								cairo_move_to(cr, XX, TopHeader)
								cairo_line_to(cr, XX, TopHeader + mHeight + 4 * nScale)
								cairo_stroke(cr)
							#else
								GdipDrawLine hGraphics, hPen, XX, TopHeader, XX, TopHeader + mHeight + 4 * nScale
								GdipDeletePen hPen
							#endif
						End If
						
						
						If mHotSerie = i Then
							#ifdef __USE_GTK__
								Var BrushColor = RGBtoARGB(m_Serie(i).SerieColor, 50)
								cairo_set_source_rgba(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor), 0.5)
								cairo_arc(cr, m_Serie(i).PT(j).X - PTSZ * 2 + PTSZ * 4 / 2 - 0.5, m_Serie(i).PT(j).Y - PTSZ * 2 + PTSZ * 4 / 2 - 0.5, PTSZ * 4 / 2, 0, 2 * G_PI)
								cairo_fill(cr)
							#else
								GdipCreateSolidFill RGBtoARGB(m_Serie(i).SerieColor, 50), Cast(GpSolidFill Ptr Ptr, @hBrush)
								GdipFillEllipseI hGraphics, hBrush, m_Serie(i).PT(j).X - PTSZ * 2, m_Serie(i).PT(j).Y - PTSZ * 2, PTSZ * 4, PTSZ * 4
								GdipDeleteBrush hBrush
							#endif
						End If
						
						#ifdef __USE_GTK__
							Var BrushColor = RGBtoARGB(m_Serie(i).SerieColor, 100)
							cairo_set_source_rgb(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor))
							cairo_arc(cr, m_Serie(i).PT(j).X - PTSZ + PTSZ * 2 / 2 - 0.5, m_Serie(i).PT(j).Y - PTSZ + PTSZ * 2 / 2 - 0.5, PTSZ * 2 / 2, 0, 2 * G_PI)
							cairo_fill(cr)
						#else
							GdipCreateSolidFill RGBtoARGB(m_Serie(i).SerieColor, 100), Cast(GpSolidFill Ptr Ptr, @hBrush)
							GdipFillEllipseI hGraphics, hBrush, m_Serie(i).PT(j).X - PTSZ, m_Serie(i).PT(j).Y - PTSZ, PTSZ * 2, PTSZ * 2
							
							'RectangleI hGraphics, hBrush, This.ClientWidth - MarginRight + MaxAxisHeight / 3, TopHeader + MaxAxisHeight * i + MaxAxisHeight / 4, MaxAxisHeight / 2, MaxAxisHeight / 2
							GdipDeleteBrush hBrush
						#endif
						
						#ifdef __USE_GTK__
							Var BrushColor1 = RGBtoARGB(FBackColor, 100 - m_FillOpacity)
							cairo_set_source_rgba(cr, GetRedD(BrushColor1), GetGreenD(BrushColor1), GetBlueD(BrushColor1), (100 - m_FillOpacity) / 100)
							cairo_arc(cr, m_Serie(i).PT(j).X - PTSZ + PTSZ * 2 / 2 - 0.5, m_Serie(i).PT(j).Y - PTSZ + PTSZ * 2 / 2 - 0.5, PTSZ * 2 / 2, 0, 2 * G_PI)
							cairo_stroke(cr)
						#else
							GdipCreatePen1(RGBtoARGB(FBackColor, 100 - m_FillOpacity), mPenWidth, &H2, @hPen)
							GdipDrawEllipseI hGraphics, hPen, m_Serie(i).PT(j).X - PTSZ, m_Serie(i).PT(j).Y - PTSZ, PTSZ * 2, PTSZ * 2
							GdipDeletePen hPen
						#endif
						
						'Serie Text
						'  DrawText hGraphics, m_Serie(i).SerieName, This.ClientWidth - MarginRight + MaxAxisHeight, TopHeader + MaxAxisHeight * i, MarginRight, MaxAxisHeight, This.Font, lForeColor, cLeft, cMiddle
					Next
				Next
				
				'Horizontal Axis
				If m_AxisXVisible Then
					If cAxisItem Then
						For i = 0 To cAxisItem->Count - 1
							XX = MarginLeft + AxisDistance * (i) - (AxisDistance / 2) ' - 1
							m_AxisAlign = cCenter
							DrawText cAxisItem->Item(i), XX, TopHeader + mHeight, AxisDistance, Footer, This.Font, lForeColor, m_AxisAlign, cMiddle, m_WordWrap, m_AxisAngle
						Next
					End If
				End If
				
			'End If
		Case CS_GroupedColumn To CS_StackedBarsPercent
			If m_ChartOrientation = CO_Vertical Then
				
				'PT16 = 16 * nScale
				PT16 = (ScaleX(This.ClientWidth) + ScaleY(This.ClientHeight)) * 2.5 / 100
				
				PT24 = 24 * nScale
				mPenWidth = 1 * nScale
				LW = m_LinesWidth * nScale
				lForeColor = RGBtoARGB(FForeColor, 100)
				
				If SerieCount > 1 Then BarSpace = LW * 4
				
				Max = IIf(m_AxisMax <> 0, m_AxisMax, GetMax())
				Min = IIf(m_AxisMin <> 0, m_AxisMin, GetMin())
				
				Canvas.Font = This.Font
				
				If m_AxisXVisible Then
					If cAxisItem Then
						For i = 0 To cAxisItem->Count - 1
							TextWidth = ScaleX(Canvas.TextWidth(cAxisItem->Item(i))) * 1.3
							TextHeight = ScaleY(Canvas.TextHeight(cAxisItem->Item(i))) * 1.3
							If TextWidth > AxisX.Width Then AxisX.Width = TextWidth
							If TextHeight > AxisX.Height Then AxisX.Height = TextHeight
						Next
					End If
					
					If m_AxisAngle <> 0 Then
						With AxisX
							Select Case m_AxisAngle
							Case Is <= 90
								.Height = .Height + m_AxisAngle * (.Width - .Height) / 90
							Case Is < 180
								.Height = .Height + (180 - m_AxisAngle) * (.Width - .Height) / 90
							Case Is < 270
								.Height = .Height + (m_AxisAngle Mod 90) * (.Width - .Height) / 90
							Case Else
								.Height = .Height + (360 - m_AxisAngle) * (.Width - .Height) / 90
							End Select
						End With
					End If
				End If
				
				If m_AxisYVisible Then
					Value = IIf(Len(WStr(Max)) > Len(WStr(Min)), Max, Min)
					sDisplay = Replace(m_LabelsFormats, "{V}", WStr(Value))
					sDisplay = Replace(sDisplay, "{LF}", Chr(10))
					If Len(sDisplay) = 1 Then sDisplay = "0.9"
					AxisY.Width = ScaleX(Canvas.TextWidth(WStr(sDisplay))) * 1.5
					AxisY.Height = ScaleY(Canvas.TextHeight(WStr(sDisplay))) * 1.5
				End If
				
				
				If m_LegendVisible Then
					For i = 0 To SerieCount - 1
						m_Serie(i).TextHeight = ScaleY(Canvas.TextHeight(m_Serie(i).SerieName)) * 1.5
						m_Serie(i).TextWidth = ScaleX(Canvas.TextWidth(m_Serie(i).SerieName)) * 1.5 + m_Serie(i).TextHeight
					Next
				End If
				
				If Len(m_Title) Then
					GetTextSize(m_Title, ScaleX(This.ClientWidth), 0, m_TitleFont, True, TitleSize)
				End If
				
				MarginRight = PT16
				TopHeader = PT16 + TitleSize.Height
				MarginLeft = PT16 + AxisY.Width
				Footer = PT16 + AxisX.Height
				
				mWidth = ScaleX(This.ClientWidth) - MarginLeft - MarginRight
				mHeight = ScaleY(This.ClientHeight) - TopHeader - Footer
				
				If m_LegendVisible Then
					ColRow = 1
					Select Case m_LegendAlign
					Case LA_RIGHT, LA_LEFT
						With LabelsRect
							TextWidth = 0
							TextHeight = 0
							For i = 0 To SerieCount - 1
								If TextHeight + m_Serie(i).TextHeight > mHeight Then
									.Right = .Right + TextWidth
									ColRow = ColRow + 1
									TextWidth = 0
									TextHeight = 0
								End If
								
								TextHeight = TextHeight + m_Serie(i).TextHeight
								.Bottom = .Bottom + m_Serie(i).TextHeight
								
								If TextWidth < m_Serie(i).TextWidth Then
									TextWidth = m_Serie(i).TextWidth '+ PT16
								End If
							Next
							.Right = .Right + TextWidth
							If m_LegendAlign = LA_LEFT Then
								MarginLeft = MarginLeft + .Right
							Else
								MarginRight = MarginRight + .Right
							End If
							mWidth = mWidth - .Right
						End With
						
					Case LA_BOTTOM, LA_TOP
						With LabelsRect
							
							.Bottom = m_Serie(0).TextHeight + PT16 / 2
							TextWidth = 0
							For i = 0 To SerieCount - 1
								If TextWidth + m_Serie(i).TextWidth > mWidth Then
									.Bottom = .Bottom + m_Serie(i).TextHeight
									ColRow = ColRow + 1
									TextWidth = 0
								End If
								TextWidth = TextWidth + m_Serie(i).TextWidth
								.Right = .Right + m_Serie(i).TextWidth
							Next
							If m_LegendAlign = LA_TOP Then
								TopHeader = TopHeader + .Bottom
							End If
							mHeight = mHeight - .Bottom
						End With
					End Select
				End If
				
				If cAxisItem AndAlso cAxisItem->Count Then
					AxisDistance = (mWidth - mPenWidth) / cAxisItem->Count
				End If
				
				If SerieCount > 0 Then
					PtDistance = (mWidth - mPenWidth) / m_Serie(0).Values->Count
				End If
				
				If (m_ChartStyle = CS_StackedBars) Or (m_ChartStyle = CS_StackedBarsPercent) Then
					BarWidth = (PtDistance / 2)
				Else
					BarWidth = (PtDistance / (SerieCount + 0.5))
				End If
				
				LineSpace = BarWidth * 20 / 100
				NumDecim = 1
				
				If m_AxisMin Then forLines = m_AxisMin
				If m_AxisMax Then toLines = m_AxisMax
				
				If m_ChartStyle = CS_StackedBarsPercent Then
					iStep = 10
					If Max > 0 Then toLines = 100
					If Min < 0 Then forLines = -100
					Do
						RangeHeight = (mHeight / ((toLines + Abs(forLines)) / (iStep * NumDecim)))
						
						If RangeHeight < AxisY.Height Then
							Select Case iStep
							Case Is = 10: iStep = 20
							Case Is = 20: iStep = 50
							Case Is = 50: iStep = 100: Exit Do
							End Select
						Else
							Exit Do
						End If
					Loop
				Else
					nVal = Max + Abs(Min)
					
					Do While nVal > 9.5
						nVal = nVal / 9.99
						NumDecim = NumDecim * 10
					Loop
					
					Select Case nVal
					Case 0 To 1.999999
						iStep = 0.2
					Case 2 To 4.799999
						iStep = 0.5
					Case 4.8 To 9.599999
						iStep = 1
					End Select
					
					Dim nDec As Single
					nDec = 1
					Do
						If nDec * iStep * NumDecim > IIf(Max > Abs(Min), Max, Abs(Min)) * 3 Then Exit Do
						
						If Max > 0 Then
							If m_AxisMax = 0 Then
								toLines = CInt((Max / NumDecim + iStep) / iStep) * (iStep * NumDecim)
							End If
						End If
						
						If Min < 0 Then
							If m_AxisMin = 0 Then
								forLines = CInt((Min / (iStep * NumDecim)) - 1) * (iStep * NumDecim)
							End If
						End If
						
						RangeHeight = (mHeight / ((toLines + Abs(forLines)) / (iStep * NumDecim)))
						
						Exit Do
						If RangeHeight < AxisY.Height Then
							
							
							Select Case iStep
							Case Is = 0.2 * nDec: iStep = 0.5 * nDec
							Case Is = 0.5 * nDec: iStep = 1 * nDec
							Case Is = 1 * nDec: nDec = nDec * 10: iStep = 0.2 * nDec
							End Select
						Else
							Exit Do
						End If
					Loop
				End If
				
				Dim RectF_ As RectF
				With RectF_
					.Width = ScaleX(This.ClientWidth) - 1 * nScale
					.Height = ScaleY(This.ClientHeight) - 1 * nScale
				End With
				
				RoundRect RectF_, RGBtoARGB(FBackColor, m_BackColorOpacity), RGBtoARGB(m_BorderColor, 100), m_BorderRound * nScale, m_Border, m_BackColorOpacity
				
				'    'Background
				'    If m_BackColorOpacity > 0 Then
				'        GdipCreateSolidFill RGBtoARGB(m_BackColor, m_BackColorOpacity), hBrush
				'        GdipFillRectangleI hGraphics, hBrush, 0, 0, This.ClientWidth, This.ClientHeight
				'        GdipDeleteBrush hBrush
				'    End If
				'
				'    'Border
				'    If m_Border Then
				'        Call GdipCreatePen1(RGBtoARGB(m_BorderColor, 50), mPenWidth, &H2, hPen)
				'        GdipDrawRectangleI hGraphics, hPen, mPenWidth / 2, mPenWidth / 2, This.ClientWidth - mPenWidth, This.ClientHeight - mPenWidth
				'        GdipDeletePen hPen
				'    End If
				
				'HORIZONTAL LINES AND vertical axis
				#ifdef __USE_GTK__
					Var PenColor = RGBtoARGB(m_LinesColor, 100)
					cairo_set_line_width(cr, mPenWidth)
				#else
					GdipCreatePen1(RGBtoARGB(m_LinesColor, 100), mPenWidth, &H2, @hPen)
				#endif
				
				YY = TopHeader + mHeight
				yRange = forLines
				
				If toLines = 0 And forLines = 0 Then toLines = 1
				RangeHeight = (mHeight / ((toLines + Abs(forLines)) / (iStep * NumDecim)))
				ZeroPoint = TopHeader + mHeight - RangeHeight * (Abs(forLines) / (iStep * NumDecim))
				
				For i = forLines / (iStep * NumDecim) To toLines / (iStep * NumDecim)
					If m_HorizontalLines Then
						#ifdef __USE_GTK__
							cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
							cairo_move_to(cr, MarginLeft, YY)
							cairo_line_to(cr, This.ClientWidth - MarginRight - mPenWidth, YY)
						#else
							GdipDrawLine hGraphics, hPen, MarginLeft, YY, ScaleX(This.ClientWidth) - MarginRight - mPenWidth, YY
						#endif
					End If
					
					If m_AxisYVisible Then
						sDisplay = Replace(m_LabelsFormats, "{V}", WStr(yRange))
						sDisplay = Replace(sDisplay, "{LF}", Chr(10))
						DrawText sDisplay, 0, YY - RangeHeight / 2, MarginLeft - 8 * nScale, RangeHeight, This.Font, lForeColor, cRight, cMiddle
					End If
					YY = YY - RangeHeight
					yRange = yRange + (iStep * NumDecim) 'CLng(iStep * NumDecim)
				Next
				
				If m_VerticalLines And SerieCount > 0 Then
					For i = 0 To m_Serie(0).Values->Count - 1
						XX = MarginLeft + PtDistance * i
						#ifdef __USE_GTK__
							cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
							cairo_move_to(cr, XX, TopHeader)
							cairo_line_to(cr, XX, TopHeader + mHeight + 4 * nScale)
						#else
							GdipDrawLine hGraphics, hPen, XX, TopHeader, XX, TopHeader + mHeight + 4 * nScale
						#endif
					Next
				End If
				
				#ifndef __USE_GTK__
					GdipDeletePen hPen
				#endif
				
				If ((m_ChartStyle = CS_StackedBars) Or (m_ChartStyle = CS_StackedBarsPercent)) And SerieCount > 0 Then
					ReDim LastPositive(m_Serie(0).Values->Count - 1)
					ReDim LastNegative(m_Serie(0).Values->Count - 1)
					For i = 0 To m_Serie(0).Values->Count - 1
						LastPositive(i) = ZeroPoint
						LastNegative(i) = ZeroPoint
					Next
				End If
				
				For i = 0 To SerieCount - 1
					'Calculo
					ReDim (m_Serie(i).Rects)(m_Serie(i).Values->Count - 1)
					If (m_ChartStyle = CS_StackedBars) Or (m_ChartStyle = CS_StackedBarsPercent) Then
						
						If m_ChartStyle = CS_StackedBarsPercent Then
							For j = 0 To m_Serie(i).Values->Count - 1
								Max = SumSerieValues(j, True) ' + 1
								Value = m_Serie(i).Values->Item(j) ' + 1
								
								With m_Serie(i).Rects(j)
									.Left = MarginLeft + PtDistance * j + BarWidth / 2
									
									If Value >= 0 Then
										.Bottom = (Value * (ZeroPoint - TopHeader) / Max)
										.Top = LastPositive(j) - .Bottom
										LastPositive(j) = .Top
									Else
										.Top = LastNegative(j)
										.Bottom = (Abs(Value) * (TopHeader + mHeight - ZeroPoint) / Max)
										LastNegative(j) = .Top + .Bottom
									End If
									
									.Right = BarWidth
								End With
								
							Next
						Else
							
							For j = 0 To m_Serie(i).Values->Count - 1
								Value = m_Serie(i).Values->Item(j) ' + 1
								
								With m_Serie(i).Rects(j)
									.Left = MarginLeft + PtDistance * j + BarWidth / 2
									If Value >= 0 Then
										.Bottom = (Value * (Max * (ZeroPoint - TopHeader) / toLines) / Max)
										.Top = LastPositive(j) - .Bottom
										LastPositive(j) = .Top
									Else
										.Top = LastNegative(j)
										.Bottom = (Value * (Min * (TopHeader + mHeight - ZeroPoint) / forLines) / Min)
										LastNegative(j) = .Top + .Bottom
									End If
									.Right = BarWidth
								End With
							Next
						End If
					Else
						For j = 0 To m_Serie(i).Values->Count - 1
							Value = m_Serie(i).Values->Item(j) ' + 1
							With m_Serie(i).Rects(j)
								.Left = MarginLeft + PtDistance * j + BarWidth / 4 + BarWidth * i + BarSpace / 2
								If Value >= 0 Then
									.Top = ZeroPoint - (Value * (ZeroPoint - TopHeader) / toLines)
									.Bottom = ZeroPoint - .Top
								Else
									.Top = ZeroPoint
									.Bottom = (Value * (TopHeader + mHeight - ZeroPoint) / forLines)
								End If
								.Right = BarWidth - BarSpace
							End With
						Next
					End If
					
					
					With RectL_
						.Top = TopHeader
						.Right = ScaleX(This.ClientWidth)
						.Bottom = ScaleY(This.ClientHeight)
					End With
					
					For j = 0 To UBound(m_Serie(i).Rects)
						
						If Not m_Serie(i).CustomColors = 0 Then
							lColor = m_Serie(i).CustomColors->Item(j) ' + 1
						Else
							lColor = m_Serie(i).SerieColor
						End If
						
						Dim As ULong PenColor
						If i = mHotSerie And (mHotBar = j Or mHotBar = -1) Then
							#ifdef __USE_GTK__
								PenColor = RGBtoARGB(lColor, 100)
								cairo_set_line_width(cr, LW * 2)
							#else
								GdipCreatePen1 RGBtoARGB(lColor, 100), LW * 2, &H2, @hPen
							#endif
							lColor = ShiftColor(lColor, clWhite, 90)
						Else
							#ifdef __USE_GTK__
								PenColor = RGBtoARGB(lColor, 100)
								cairo_set_line_width(cr, LW)
							#else
								GdipCreatePen1 RGBtoARGB(lColor, 100), LW, &H2, @hPen
							#endif
						End If
						
						Dim As ULong BrushColor
						If m_FillGradient Then
							#ifdef __USE_GTK__
								BrushColor = RGBtoARGB(lColor, m_FillOpacity)
							#else
								GdipCreateLineBrushFromRectWithAngleI Cast(GpRect Ptr, @RectL_), RGBtoARGB(lColor, m_FillOpacity), RGBtoARGB(clWhite, IIf(m_FillOpacity < 100, 0, 100)), 90, 0, WrapModeTile, Cast(GpLineGradient Ptr Ptr, @hBrush)
							#endif
						Else
							#ifdef __USE_GTK__
								BrushColor = RGBtoARGB(lColor, m_FillOpacity)
							#else
								GdipCreateSolidFill RGBtoARGB(lColor, m_FillOpacity), Cast(GpSolidFill Ptr Ptr, @hBrush)
							#endif
						End If
						
						With m_Serie(i).Rects(j)
							#ifdef __USE_GTK__
								cairo_set_source_rgba(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor), m_FillOpacity / 100)
								cairo_rectangle(cr, .Left, .Top, .Right, .Bottom)
								cairo_fill(cr)
								cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
								cairo_rectangle(cr, .Left, .Top, .Right, .Bottom)
								cairo_stroke(cr)
							#else
								GdipFillRectangleI hGraphics, hBrush, .Left, .Top, .Right, .Bottom
								GdipDrawRectangleI hGraphics, hPen, .Left, .Top, .Right, .Bottom
							#endif
						End With
						
						#ifndef __USE_GTK__
							GdipDeleteBrush hBrush
							GdipDeletePen hPen
						#endif
					Next
					
					
					If m_LegendVisible Then
						Select Case m_LegendAlign
						Case LA_RIGHT, LA_LEFT
							With LabelsRect
								TextWidth = 0
								
								If .Left = 0 Then
									TextHeight = 0
									If m_LegendAlign = LA_LEFT Then
										.Left = PT16
									Else
										.Left = MarginLeft + mWidth + PT16
									End If
									If ColRow = 1 Then
										.Top = TopHeader + mHeight / 2 - .Bottom / 2
									Else
										.Top = TopHeader
									End If
								End If
								
								If TextWidth < m_Serie(i).TextWidth Then
									TextWidth = m_Serie(i).TextWidth '+ PT16
								End If
								
								If TextHeight + m_Serie(i).TextHeight > mHeight Then
									If i > 0 Then .Left = .Left + TextWidth
									.Top = TopHeader
									TextHeight = 0
								End If
								m_Serie(i).LegendRect.Left = .Left
								m_Serie(i).LegendRect.Top = .Top
								m_Serie(i).LegendRect.Right = m_Serie(i).TextWidth
								m_Serie(i).LegendRect.Bottom = m_Serie(i).TextHeight
								
								#ifdef __USE_GTK__
									Var BrushColor = RGBtoARGB(m_Serie(i).SerieColor, 100)
									cairo_set_source_rgb(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor))
									cairo_rectangle(cr, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2)
									cairo_fill(cr)
								#else
									GdipCreateSolidFill RGBtoARGB(m_Serie(i).SerieColor, 100), Cast(GpSolidFill Ptr Ptr, @hBrush)
									GdipFillRectangleI hGraphics, hBrush, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2
									GdipDeleteBrush hBrush
								#endif
								
								DrawText m_Serie(i).SerieName, .Left + m_Serie(i).TextHeight / 1.5, .Top, m_Serie(i).TextWidth, m_Serie(i).TextHeight, This.Font, lForeColor, cLeft, cMiddle
								TextHeight = TextHeight + m_Serie(i).TextHeight
								.Top = .Top + m_Serie(i).TextHeight
								
							End With
							
						Case LA_BOTTOM, LA_TOP
							With LabelsRect
								If .Left = 0 Then
									If ColRow = 1 Then
										.Left = MarginLeft + mWidth / 2 - .Right / 2
									Else
										.Left = MarginLeft
									End If
									If m_LegendAlign = LA_TOP Then
										.Top = PT16 + TitleSize.Height
									Else
										.Top = TopHeader + mHeight + TitleSize.Height + PT16 / 2
									End If
								End If
								
								If .Left + m_Serie(i).TextWidth - MarginLeft > mWidth Then
									.Left = MarginLeft
									.Top = .Top + m_Serie(i).TextHeight
								End If
								
								#ifdef __USE_GTK__
									Var BrushColor = RGBtoARGB(m_Serie(i).SerieColor, 100)
									cairo_set_source_rgb(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor))
									cairo_rectangle(cr, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2)
									cairo_fill(cr)
								#else
									GdipCreateSolidFill RGBtoARGB(m_Serie(i).SerieColor, 100), Cast(GpSolidFill Ptr Ptr, @hBrush)
									GdipFillRectangleI hGraphics, hBrush, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2
									GdipDeleteBrush hBrush
								#endif
								m_Serie(i).LegendRect.Left = .Left
								m_Serie(i).LegendRect.Top = .Top
								m_Serie(i).LegendRect.Right = m_Serie(i).TextWidth
								m_Serie(i).LegendRect.Bottom = m_Serie(i).TextHeight
								
								DrawText m_Serie(i).SerieName, .Left + m_Serie(i).TextHeight / 1.5, .Top, m_Serie(i).TextWidth, m_Serie(i).TextHeight, This.Font, lForeColor, cLeft, cMiddle
								.Left = .Left + m_Serie(i).TextWidth '+ m_Serie(i).TextHeight / 1.5
							End With
						End Select
					End If
					
				Next
				
				
				If m_LabelsVisible Then
					For i = 0 To SerieCount - 1
						For j = 0 To m_Serie(i).Values->Count - 1
							mRect = m_Serie(i).Rects(j)
							With mRect
								sDisplay = Replace(m_LabelsFormats, "{V}", FormatLabel(m_Serie(i).Values->Item(j), m_LabelsFormat)) ' + 1
								sDisplay = Replace(sDisplay, "{LF}", Chr(10))
								TextHeight = ScaleY(Canvas.TextHeight(sDisplay)) * 1.3
								TextWidth = ScaleX(Canvas.TextWidth(sDisplay)) * 1.5
								If (TextHeight > .Bottom Or m_LabelsPositions = LP_Outside) And m_ChartStyle = CS_GroupedColumn Then
									.Top = .Top - TextHeight
									.Bottom = TextHeight
									lColor = RGBtoARGB(m_Serie(i).SerieColor, 100)
								Else
									If Not m_Serie(i).CustomColors = 0 Then
										lColor = m_Serie(i).CustomColors->Item(j)
									Else
										lColor = FForeColor
									End If
									If IsDarkColor(lColor) Then
										lColor = RGBtoARGB(clWhite, 100)
									Else
										lColor = RGBtoARGB(clBlack, 100)
									End If
								End If
								
								If TextWidth > .Right Then
									.Left = .Left + .Right / 2 - TextWidth / 2
									.Right = TextWidth
								End If
								
								
								DrawText sDisplay, .Left, .Top, .Right, .Bottom, This.Font, lColor, cCenter, m_LabelsAlignments
							End With
						Next
					Next
				End If
				
				'a line to overlap the base of the rectangle
				
				#ifdef __USE_GTK__
					Var PenColor1 = RGBtoARGB(m_LinesColor, 100)
					cairo_set_line_width(cr, LW)
					cairo_set_source_rgb(cr, GetRedD(PenColor1), GetGreenD(PenColor1), GetBlueD(PenColor1))
					cairo_move_to(cr, MarginLeft, ZeroPoint)
					cairo_line_to(cr, This.ClientWidth - MarginRight - mPenWidth, ZeroPoint)
					cairo_stroke(cr)
				#else
					GdipCreatePen1(RGBtoARGB(m_LinesColor, 100), LW, &H2, @hPen)
					GdipDrawLine hGraphics, hPen, MarginLeft, ZeroPoint, ScaleX(This.ClientWidth) - MarginRight - mPenWidth, ZeroPoint
					GdipDeletePen hPen
				#endif
				
				'*-
				'Horizontal Axis
				If m_AxisXVisible Then
					If cAxisItem Then
						For i = 0 To cAxisItem->Count - 1
							XX = MarginLeft + AxisDistance * (i) ' - 1
							DrawText cAxisItem->Item(i), XX, TopHeader + mHeight, AxisDistance, Footer, This.Font, lForeColor, m_AxisAlign, cMiddle, m_WordWrap, m_AxisAngle
						Next
					End If
				End If
				
			Else
				
				'PT16 = 16 * nScale
				PT16 = (ScaleX(This.ClientWidth) + ScaleY(This.ClientHeight)) * 2.5 / 100
				
				PT24 = 24 * nScale
				mPenWidth = 1 * nScale
				LW = m_LinesWidth * nScale
				lForeColor = RGBtoARGB(FForeColor, 100)
				If SerieCount > 1 Then BarSpace = LW * 4
				
				Max = IIf(m_AxisMax <> 0, m_AxisMax, GetMax())
				Min = IIf(m_AxisMin <> 0, m_AxisMin, GetMin())
				
				Canvas.Font = This.Font
				
				If m_AxisYVisible Then
					For i = 0 To cAxisItem->Count - 1
						TextWidth = ScaleX(Canvas.TextWidth(cAxisItem->Item(i))) * 1.3
						TextHeight = ScaleY(Canvas.TextHeight(cAxisItem->Item(i))) * 1.5
						If TextWidth > AxisY.Width Then AxisY.Width = TextWidth
						If TextHeight > AxisY.Height Then AxisY.Height = TextHeight
					Next
					
					If m_AxisAngle <> 0 Then
						With AxisY
							Select Case m_AxisAngle
							Case Is <= 90
								.Width = .Width + m_AxisAngle * (.Height - .Width) / 90
							Case Is < 180
								.Width = .Width + (180 - m_AxisAngle) * (.Height - .Width) / 90
							Case Is < 270
								.Width = .Width + (m_AxisAngle Mod 90) * (.Height - .Width) / 90
							Case Else
								.Width = .Width + (360 - m_AxisAngle) * (.Height - .Width) / 90
							End Select
						End With
					End If
				End If
				
				If m_AxisXVisible Then
					Value = IIf(Len(WStr(Max)) > Len(WStr(Min)), Max, Min)
					sDisplay = Replace(m_LabelsFormats, "{V}", WStr(Value))
					sDisplay = Replace(sDisplay, "{LF}", Chr(10))
					AxisX.Width = ScaleX(Canvas.TextWidth(WStr(sDisplay))) * 1.5
					AxisX.Height = ScaleY(Canvas.TextHeight(WStr(sDisplay))) * 1.5
				End If
				
				If m_LegendVisible Then
					For i = 0 To SerieCount - 1
						m_Serie(i).TextHeight = ScaleX(Canvas.TextHeight(m_Serie(i).SerieName)) * 1.5
						m_Serie(i).TextWidth = ScaleY(Canvas.TextWidth(m_Serie(i).SerieName)) * 1.5 + m_Serie(i).TextHeight
					Next
				End If
				
				If Len(m_Title) Then
					GetTextSize(m_Title, ScaleX(This.ClientWidth), 0, m_TitleFont, True, TitleSize)
				End If
				
				MarginRight = PT16
				TopHeader = PT16 + TitleSize.Height
				MarginLeft = PT16 + AxisY.Width
				Footer = PT16 + AxisX.Height
				
				mWidth = ScaleX(This.ClientWidth) - MarginLeft - MarginRight
				mHeight = ScaleY(This.ClientHeight) - TopHeader - Footer
				
				If m_LegendVisible Then
					ColRow = 1
					Select Case m_LegendAlign
					Case LA_RIGHT, LA_LEFT
						With LabelsRect
							TextWidth = 0
							TextHeight = 0
							For i = 0 To SerieCount - 1
								If TextHeight + m_Serie(i).TextHeight > mHeight Then
									.Right = .Right + TextWidth
									ColRow = ColRow + 1
									TextWidth = 0
									TextHeight = 0
								End If
								
								TextHeight = TextHeight + m_Serie(i).TextHeight
								.Bottom = .Bottom + m_Serie(i).TextHeight
								
								If TextWidth < m_Serie(i).TextWidth Then
									TextWidth = m_Serie(i).TextWidth '+ PT16
								End If
							Next
							.Right = .Right + TextWidth
							If m_LegendAlign = LA_LEFT Then
								MarginLeft = MarginLeft + .Right
							Else
								MarginRight = MarginRight + .Right
							End If
							mWidth = mWidth - .Right
						End With
						
					Case LA_BOTTOM, LA_TOP
						With LabelsRect
							
							.Bottom = m_Serie(0).TextHeight + PT16 / 2
							TextWidth = 0
							For i = 0 To SerieCount - 1
								If TextWidth + m_Serie(i).TextWidth > mWidth Then
									.Bottom = .Bottom + m_Serie(i).TextHeight
									ColRow = ColRow + 1
									TextWidth = 0
								End If
								TextWidth = TextWidth + m_Serie(i).TextWidth
								.Right = .Right + m_Serie(i).TextWidth
							Next
							If m_LegendAlign = LA_TOP Then
								TopHeader = TopHeader + .Bottom
							End If
							mHeight = mHeight - .Bottom
						End With
					End Select
				End If
				
				If cAxisItem AndAlso cAxisItem->Count Then
					AxisDistance = (mHeight - mPenWidth) / cAxisItem->Count
				End If
				
				If SerieCount > 0 Then
					PtDistance = (mHeight - mPenWidth) / m_Serie(0).Values->Count
				End If
				
				If (m_ChartStyle = CS_StackedBars) Or (m_ChartStyle = CS_StackedBarsPercent) Then
					BarWidth = (PtDistance / 2)
				Else
					BarWidth = (PtDistance / (SerieCount + 0.5))
				End If
				
				LineSpace = BarWidth * 20 / 100
				NumDecim = 1
				
				If m_AxisMin Then forLines = m_AxisMin
				If m_AxisMax Then toLines = m_AxisMax
				
				If m_ChartStyle = CS_StackedBarsPercent Then
					iStep = 10
					
					If Max > 0 Then toLines = 100
					If Min < 0 Then forLines = -100
					Do
						RangeHeight = (mWidth / ((toLines + Abs(forLines)) / (iStep * NumDecim)))
						If RangeHeight < AxisX.Width Then
							Select Case iStep
							Case Is = 10: iStep = 20
							Case Is = 20: iStep = 50
							Case Is = 50: iStep = 100: Exit Do
							End Select
						Else
							Exit Do
						End If
					Loop
				Else
					nVal = Max + Abs(Min)
					
					Do While nVal > 9.5
						nVal = nVal / 9.99
						NumDecim = NumDecim * 10
					Loop
					
					Select Case nVal
					Case 0 To 1.999999
						iStep = 0.2
					Case 2 To 4.799999
						iStep = 0.5
					Case 4.8 To 9.599999
						iStep = 1
					End Select
					
					Dim nDec As Single
					nDec = 1
					Do
						If nDec * iStep * NumDecim > IIf(Max > Abs(Min), Max, Abs(Min)) Then Exit Do
						
						If Max > 0 Then
							If m_AxisMax = 0 Then
								toLines = CInt((Max / NumDecim + iStep) / iStep) * (iStep * NumDecim)
							End If
						End If
						
						If Min < 0 Then
							If m_AxisMin = 0 Then
								forLines = CInt((Min / (iStep * NumDecim)) - 1) * (iStep * NumDecim)
							End If
						End If
						
						RangeHeight = (mWidth / ((toLines + Abs(forLines)) / (iStep * NumDecim)))
						
						Exit Do
						
						If RangeHeight < AxisX.Width Then
							
							
							Select Case iStep
							Case Is = 0.2 * nDec: iStep = 0.5 * nDec
							Case Is = 0.5 * nDec: iStep = 1 * nDec
							Case Is = 1 * nDec: nDec = nDec * 10: iStep = 0.2 * nDec
							End Select
						Else
							Exit Do
						End If
					Loop
					
				End If
				
				Dim RectF_ As RectF
				With RectF_
					.Width = ScaleX(This.ClientWidth) - 1 * nScale
					.Height = ScaleY(This.ClientHeight) - 1 * nScale
				End With
				RoundRect RectF_, RGBtoARGB(FBackColor, m_BackColorOpacity), RGBtoARGB(m_BorderColor, 100), m_BorderRound * nScale, m_Border, m_BackColorOpacity
				
				'     'Background
				'     If m_BackColorOpacity > 0 Then
				'         GdipCreateSolidFill RGBtoARGB(m_BackColor, m_BackColorOpacity), hBrush
				'         GdipFillRectangleI hGraphics, hBrush, 0, 0, This.ClientWidth, This.ClientHeight
				'         GdipDeleteBrush hBrush
				'     End If
				'
				'     'Border
				'     If m_Border Then
				'         Call GdipCreatePen1(RGBtoARGB(m_LinesColor, 50), mPenWidth, &H2, hPen)
				'         GdipDrawRectangleI hGraphics, hPen, mPenWidth / 2, mPenWidth / 2, This.ClientWidth - mPenWidth, This.ClientHeight - mPenWidth
				'         GdipDeletePen hPen
				'     End If
				
				'vertical LINES AND vertical axis
				#ifdef __USE_GTK__
					Var PenColor = RGBtoARGB(m_LinesColor, 100)
					cairo_set_line_width(cr, mPenWidth)
				#else
					GdipCreatePen1(RGBtoARGB(m_LinesColor, 100), mPenWidth, &H2, @hPen)
				#endif
				
				YY = TopHeader + mHeight
				XX = MarginLeft
				yRange = forLines
				If toLines = 0 And forLines = 0 Then toLines = 1
				
				RangeHeight = (mWidth / ((toLines + Abs(forLines)) / (iStep * NumDecim)))
				
				ZeroPoint = MarginLeft + RangeHeight * (Abs(forLines) / (iStep * NumDecim))
				
				For i = forLines / (iStep * NumDecim) To toLines / (iStep * NumDecim)
					If m_VerticalLines Then
						#ifdef __USE_GTK__
							cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
							cairo_move_to(cr, XX, TopHeader)
							cairo_line_to(cr, XX, TopHeader + mHeight - mPenWidth)
							cairo_stroke(cr)
						#else
							GdipDrawLine hGraphics, hPen, XX, TopHeader, XX, TopHeader + mHeight - mPenWidth
						#endif
					End If
					
					If m_AxisXVisible Then
						sDisplay = Replace(m_LabelsFormats, "{V}", WStr(yRange))
						sDisplay = Replace(sDisplay, "{LF}", Chr(10))
						DrawText sDisplay, XX - RangeHeight / 2, YY + 8 * nScale, RangeHeight, Footer, This.Font, lForeColor, cCenter, cTop
						'DrawText hGraphics, sDisplay, 0, Yy - RangeHeight / 2, MarginLeft - 8 * nScale, RangeHeight, This.Font, lForeColor, cRight, cMiddle
						
					End If
					
					XX = XX + RangeHeight
					yRange = yRange + CLng(iStep * NumDecim)
				Next
				
				
				If m_HorizontalLines And SerieCount > 0 Then
					For i = 0 To m_Serie(0).Values->Count
						YY = TopHeader + PtDistance * i
						#ifdef __USE_GTK__
							cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
							cairo_move_to(cr, MarginLeft, YY)
							cairo_line_to(cr, MarginLeft + mWidth, YY)
							cairo_stroke(cr)
						#else
							GdipDrawLine hGraphics, hPen, MarginLeft, YY, MarginLeft + mWidth, YY
						#endif
					Next
				End If
				
				#ifndef __USE_GTK__
					GdipDeletePen hPen
				#endif
				
				If ((m_ChartStyle = CS_StackedBars) Or (m_ChartStyle = CS_StackedBarsPercent)) And SerieCount > 0 Then
					ReDim LastPositive(m_Serie(0).Values->Count - 1)
					ReDim LastNegative(m_Serie(0).Values->Count - 1)
					For i = 0 To m_Serie(0).Values->Count - 1
						LastPositive(i) = ZeroPoint
						LastNegative(i) = ZeroPoint
					Next
				End If
				
				For i = 0 To SerieCount - 1
					'Calculo
					ReDim (m_Serie(i).Rects)(m_Serie(i).Values->Count - 1)
					If (m_ChartStyle = CS_StackedBars) Or (m_ChartStyle = CS_StackedBarsPercent) Then
						
						If m_ChartStyle = CS_StackedBarsPercent Then
							For j = 0 To m_Serie(i).Values->Count - 1
								Max = This.SumSerieValues(j, True) ' + 1
								Value = m_Serie(i).Values->Item(j) ' + 1
								
								With m_Serie(i).Rects(j)
									.Top = TopHeader + PtDistance * j + BarWidth / 2
									
									If Value >= 0 Then
										.Left = LastPositive(j)
										.Right = (Value * (MarginLeft + mWidth - ZeroPoint) / Max)
										
										LastPositive(j) = .Left + .Right
									Else
										.Right = (Abs(Value) * (ZeroPoint - MarginLeft) / Max)
										.Left = LastNegative(j) - .Right
										LastNegative(j) = .Left
									End If
									
									.Bottom = BarWidth
								End With
								
							Next
						Else
							
							For j = 0 To m_Serie(i).Values->Count - 1
								Value = m_Serie(i).Values->Item(j) ' + 1
								
								With m_Serie(i).Rects(j)
									.Top = TopHeader + PtDistance * j + BarWidth / 2
									
									If Value >= 0 Then
										.Left = LastPositive(j)
										.Right = (Value * (Max * (MarginLeft + mWidth - ZeroPoint) / toLines) / Max)
										LastPositive(j) = .Left + .Right
										
									Else
										.Right = (Value * (Min * (ZeroPoint - MarginLeft) / forLines) / Min)
										.Left = LastNegative(j) - .Right
										LastNegative(j) = .Left
										
									End If
									
									.Bottom = BarWidth
								End With
							Next
						End If
					Else
						For j = 0 To m_Serie(i).Values->Count - 1
							Value = m_Serie(i).Values->Item(j) ' + 1
							
							With m_Serie(i).Rects(j)
								.Top = TopHeader + PtDistance * j + BarWidth / 4 + BarSpace / 2 + BarWidth * i
								If Value >= 0 Then
									.Left = ZeroPoint
									.Right = (Value * (MarginLeft + mWidth - ZeroPoint) / toLines)
								Else
									.Left = ZeroPoint - (Value * (ZeroPoint - MarginLeft) / forLines)
									.Right = ZeroPoint - .Left
								End If
								.Bottom = BarWidth - BarSpace
							End With
						Next
					End If
					
					With RectL_
						.Top = TopHeader
						.Right = ScaleX(This.ClientWidth) - MarginRight
						.Bottom = ScaleY(This.ClientHeight)
					End With
					
					For j = 0 To UBound(m_Serie(i).Rects)
						
						If Not m_Serie(i).CustomColors = 0 Then
							lColor = m_Serie(i).CustomColors->Item(j) ' + 1
						Else
							lColor = m_Serie(i).SerieColor
						End If
						
						Dim As ULong PenColor
						If i = mHotSerie And (mHotBar = j Or mHotBar = -1) Then
							#ifdef __USE_GTK__
								PenColor = RGBtoARGB(lColor, 100)
								cairo_set_line_width(cr, LW * 2)
							#else
								GdipCreatePen1 RGBtoARGB(lColor, 100), LW * 2, &H2, @hPen
							#endif
							lColor = ShiftColor(lColor, clWhite, 90)
						Else
							#ifdef __USE_GTK__
								PenColor = RGBtoARGB(lColor, 100)
								cairo_set_line_width(cr, LW)
							#else
								GdipCreatePen1 RGBtoARGB(lColor, 100), LW, &H2, @hPen
							#endif
						End If
						
						Dim As ULong BrushColor
						If m_FillGradient Then
							#ifdef __USE_GTK__
								BrushColor = RGBtoARGB(lColor, m_FillOpacity)
							#else
								GdipCreateLineBrushFromRectWithAngleI Cast(GpRect Ptr, @RectL_), RGBtoARGB(lColor, m_FillOpacity), RGBtoARGB(clWhite, IIf(m_FillOpacity < 100, 0, 100)), 180, 0, WrapModeTile, Cast(GpLineGradient Ptr Ptr, hBrush)
							#endif
						Else
							#ifdef __USE_GTK__
								BrushColor = RGBtoARGB(lColor, m_FillOpacity)
							#else
								GdipCreateSolidFill RGBtoARGB(lColor, m_FillOpacity), Cast(GpSolidFill Ptr Ptr, @hBrush)
							#endif
						End If
						
						With m_Serie(i).Rects(j)
							#ifdef __USE_GTK__
								cairo_set_source_rgba(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor), m_FillOpacity / 100)
								cairo_rectangle(cr, .Left, .Top, .Right, .Bottom)
								cairo_fill(cr)
								cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
								cairo_rectangle(cr, .Left, .Top, .Right, .Bottom)
								cairo_stroke(cr)
							#else
								GdipFillRectangleI hGraphics, hBrush, .Left, .Top, .Right, .Bottom
								GdipDrawRectangleI hGraphics, hPen, .Left, .Top, .Right, .Bottom
							#endif
						End With
						
						#ifndef __USE_GTK__
							GdipDeleteBrush hBrush
							GdipDeletePen hPen
						#endif
					Next
					
					If m_LegendVisible Then
						Select Case m_LegendAlign
						Case LA_RIGHT, LA_LEFT
							With LabelsRect
								TextWidth = 0
								
								If .Left = 0 Then
									TextHeight = 0
									If m_LegendAlign = LA_LEFT Then
										.Left = PT16
									Else
										.Left = MarginLeft + mWidth + PT16
									End If
									If ColRow = 1 Then
										.Top = TopHeader + mHeight / 2 - .Bottom / 2
									Else
										.Top = TopHeader
									End If
								End If
								
								If TextWidth < m_Serie(i).TextWidth Then
									TextWidth = m_Serie(i).TextWidth '+ PT16
								End If
								
								If TextHeight + m_Serie(i).TextHeight > mHeight Then
									If i > 0 Then .Left = .Left + TextWidth
									.Top = TopHeader
									TextHeight = 0
								End If
								m_Serie(i).LegendRect.Left = .Left
								m_Serie(i).LegendRect.Top = .Top
								m_Serie(i).LegendRect.Right = m_Serie(i).TextWidth
								m_Serie(i).LegendRect.Bottom = m_Serie(i).TextHeight
								
								#ifdef __USE_GTK__
									Var BrushColor = RGBtoARGB(m_Serie(i).SerieColor, 100)
									cairo_set_source_rgb(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor))
									cairo_rectangle(cr, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2)
									cairo_fill(cr)
								#else
									GdipCreateSolidFill RGBtoARGB(m_Serie(i).SerieColor, 100), Cast(GpSolidFill Ptr Ptr, @hBrush)
									GdipFillRectangleI hGraphics, hBrush, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2
									GdipDeleteBrush hBrush
								#endif
								
								DrawText m_Serie(i).SerieName, .Left + m_Serie(i).TextHeight / 1.5, .Top, m_Serie(i).TextWidth, m_Serie(i).TextHeight, This.Font, lForeColor, cLeft, cMiddle
								TextHeight = TextHeight + m_Serie(i).TextHeight
								.Top = .Top + m_Serie(i).TextHeight
								
							End With
							
						Case LA_BOTTOM, LA_TOP
							With LabelsRect
								If .Left = 0 Then
									If ColRow = 1 Then
										.Left = MarginLeft + mWidth / 2 - .Right / 2
									Else
										.Left = MarginLeft
									End If
									If m_LegendAlign = LA_TOP Then
										.Top = PT16 + TitleSize.Height
									Else
										.Top = TopHeader + mHeight + TitleSize.Height + PT16 / 2
									End If
								End If
								
								If .Left + m_Serie(i).TextWidth - MarginLeft > mWidth Then
									.Left = MarginLeft
									.Top = .Top + m_Serie(i).TextHeight
								End If
								
								#ifdef __USE_GTK__
									Var BrushColor = RGBtoARGB(m_Serie(i).SerieColor, 100)
									cairo_set_source_rgb(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor))
									cairo_rectangle(cr, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2)
									cairo_fill(cr)
								#else
									GdipCreateSolidFill RGBtoARGB(m_Serie(i).SerieColor, 100), Cast(GpSolidFill Ptr Ptr, hBrush)
									GdipFillRectangleI hGraphics, hBrush, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2
									GdipDeleteBrush hBrush
								#endif
								m_Serie(i).LegendRect.Left = .Left
								m_Serie(i).LegendRect.Top = .Top
								m_Serie(i).LegendRect.Right = m_Serie(i).TextWidth
								m_Serie(i).LegendRect.Bottom = m_Serie(i).TextHeight
								
								DrawText m_Serie(i).SerieName, .Left + m_Serie(i).TextHeight / 1.5, .Top, m_Serie(i).TextWidth, m_Serie(i).TextHeight, This.Font, lForeColor, cLeft, cMiddle
								.Left = .Left + m_Serie(i).TextWidth '+ m_Serie(i).TextHeight / 1.5
							End With
						End Select
					End If
					
				Next
				
				If m_LabelsVisible Then
					For i = 0 To SerieCount - 1
						For j = 0 To m_Serie(i).Values->Count - 1
							mRect = m_Serie(i).Rects(j)
							With mRect
								sDisplay = Replace(m_LabelsFormats, "{V}", FormatLabel(m_Serie(i).Values->Item(j), m_LabelsFormat)) ' + 1
								sDisplay = Replace(sDisplay, "{LF}", Chr(10))
								TextHeight = ScaleX(Canvas.TextHeight(sDisplay)) * 1.3
								TextWidth = ScaleY(Canvas.TextWidth(sDisplay)) * 1.5
								If (TextWidth > .Right Or m_LabelsPositions = LP_Outside) And m_ChartStyle = CS_GroupedColumn Then
									.Left = .Left + .Right + PT16 / 10
									.Right = TextWidth
									lColor = RGBtoARGB(m_Serie(i).SerieColor, 100)
								Else
									If Not m_Serie(i).CustomColors = 0 Then
										lColor = m_Serie(i).CustomColors->Item(j)
									Else
										lColor = FForeColor
									End If
									If IsDarkColor(lColor) Then
										lColor = RGBtoARGB(clWhite, 100)
									Else
										lColor = RGBtoARGB(clBlack, 100)
									End If
								End If
								
								If TextHeight > .Bottom Then
									.Top = .Top + .Bottom / 2 - TextHeight / 2
									.Bottom = TextHeight
								End If
								
								
								DrawText sDisplay, .Left, .Top, .Right, .Bottom, This.Font, lColor, m_LabelsAlignments, cMiddle
							End With
						Next
					Next
				End If
				
				
				
				'a line to overlap the base of the rectangle
				#ifdef __USE_GTK__
					cairo_set_line_width(cr, LW)
					Var PenColor1 = RGBtoARGB(m_LinesColor, 100)
					cairo_set_source_rgb(cr, GetRedD(PenColor1), GetGreenD(PenColor1), GetBlueD(PenColor1))
					cairo_move_to(cr, ZeroPoint, TopHeader)
					cairo_line_to(cr, ZeroPoint, TopHeader + mHeight - mPenWidth)
					cairo_stroke(cr)
				#else
					GdipCreatePen1(RGBtoARGB(m_LinesColor, 100), LW, &H2, @hPen)
					GdipDrawLine hGraphics, hPen, ZeroPoint, TopHeader, ZeroPoint, TopHeader + mHeight - mPenWidth
					GdipDeletePen hPen
				#endif
				
				'vertical Axis
				If m_AxisYVisible Then
					For i = 0 To cAxisItem->Count - 1
						YY = TopHeader + AxisDistance * (i) ' - 1
						If m_LegendAlign = LA_LEFT Then
							XX = LabelsRect.Left + LabelsRect.Right
						Else
							XX = PT16
						End If
						
						DrawText cAxisItem->Item(i), XX, YY, MarginLeft - XX - PT16 / 10, AxisDistance, This.Font, lForeColor, m_AxisAlign, cMiddle, m_WordWrap, m_AxisAngle
					Next
				End If
				
			End If
		End Select
		
		'Title
		If Len(m_Title) Then
			DrawText m_Title, 0, PT16 / 2, ScaleX(This.ClientWidth), TopHeader, m_TitleFont, RGBtoARGB(m_TitleForeColor, 100), cCenter, cTop, True
		End If
		
		Select Case ChartStyle
		Case CS_PIE To CS_AREA
			ShowToolTips
		Case CS_GroupedColumn To CS_StackedBarsPercent
			ShowToolTips BarWidth
		End Select
		
		#ifndef __USE_GTK__
			GdipDeleteGraphics(hGraphics)
		#endif
		
	End Sub
	
	'*3
	Private Sub Chart.ShowToolTips(BarWidth As Single = 0)
		Select Case ChartStyle
		Case CS_PIE To CS_DONUT
			Dim i As Long, j As Long
			Dim sDisplay As String
			Dim bBold As Boolean
			Dim RectF_ As RectF
			Dim LW As Single
			Dim lForeColor As Long
			Dim sText As String
			Dim TM As Single
			Dim PT As POINTF
			Dim SZ As SIZEF
			
			If HotItem > -1 Then
				lForeColor = RGBtoARGB(FForeColor, 100)
				LW = m_LinesWidth * nScale
				TM = ScaleY(Canvas.TextHeight("Aj")) / 4
				
				sText = m_Item(HotItem).ItemName & ": " & m_Item(HotItem).text
				GetTextSize sText, 0, 0, This.Font, False, SZ
				
				With RectF_
					#ifdef __USE_GTK__
						Dim As cairo_path_t Ptr path = m_Item(HotItem).hPath
						Dim As cairo_path_data_t Ptr pData
						Dim As Integer i = 0
						While i < path->num_data
							pData = @path->data[i]
							i += path->data[i].header.length
						Wend
						PT.X = pData[1].point.X
						PT.Y = pData[1].point.Y
					#else
						GdipGetPathLastPoint m_Item(HotItem).hPath, Cast(GpPointF Ptr, @PT)
					#endif
					.X = PT.X
					.Y = PT.Y
					.Width = SZ.Width + TM * 2
					.Height = SZ.Height + TM * 2
					
					If .X < 0 Then .X = LW
					If .Y < 0 Then .Y = LW
					If .X + .Width >= ScaleX(This.ClientWidth) - LW Then .X = ScaleX(This.ClientWidth) - .Width - LW
					If .Y + .Height >= ScaleY(This.ClientHeight) - LW Then .Y = ScaleY(This.ClientHeight) - .Height - LW
				End With
				
				RoundRect RectF_, RGBtoARGB(FBackColor, 90), RGBtoARGB(m_Item(HotItem).ItemColor, 80), TM, True, 90, 80
				
				With RectF_
					.X = .X + TM
					.Y = .Y
					DrawText m_Item(HotItem).ItemName & ": ", .X, .Y, .Width, .Height, This.Font, lForeColor, cLeft, cMiddle
					GetTextSize m_Item(HotItem).ItemName & ": ", 0, 0, This.Font, False, SZ
					
					bBold = Canvas.Font.Bold
					Canvas.Font.Bold = True
					DrawText m_Item(HotItem).text, .X + SZ.Width, .Y, .Width, .Height, Canvas.Font, lForeColor, cLeft, cMiddle
					Canvas.Font.Bold = bBold
				End With
				
			End If
		Case CS_Area
			Dim i As Long, j As Long
			Dim sDisplay As UString
			Dim bBold As Boolean
			Dim RectF_ As RectF
			Dim LW As Single
			Dim lForeColor As Long
			Dim sText As String
			#ifndef __USE_GTK__
				Dim hBrush As GpBrush Ptr
			#endif
			Dim TM As Single
			Dim SZ As SIZEF
			Dim Max As Single
			Dim IndexMax As Long
			
			If mHotBar > -1 Then
				lForeColor = RGBtoARGB(FForeColor, 100)
				LW = m_LinesWidth * nScale
				TM = ScaleY(Canvas.TextHeight("Aj")) / 4
				bBold = This.Font.Bold
				
				If cAxisItem->Count = m_Serie(i).Values->Count Then
					sText = cAxisItem->Item(mHotBar) & Chr(13, 10) ' + 1
				End If
				
				For i = 0 To SerieCount - 1
					If Max < m_Serie(i).Values->Item(mHotBar) Then ' + 1
						Max = m_Serie(i).Values->Item(mHotBar) ' + 1
						IndexMax = i
					End If
					
					For j = 0 To m_Serie(i).Values->Count - 1
						If mHotBar = j Then ' - 1
							sDisplay = Replace(m_LabelsFormats, "{V}", WStr(m_Serie(i).Values->Item(j)))
							sDisplay = Replace(sDisplay, "{LF}", Chr(10))
							sText = sText & m_Serie(i).SerieName & ": " & sDisplay & Chr(13, 10)
						End If
					Next
				Next
				sText = ..Left(sText, Len(sText) - 2)
				
				GetTextSize sText, 0, 0, This.Font, False, SZ
				
				With RectF_
					
					.X = m_Serie(IndexMax).PT(mHotBar).X - SZ.Width / 2
					.Y = m_Serie(IndexMax).PT(mHotBar).Y - SZ.Height - 10 * nScale - TM
					.Width = SZ.Width + TM * 5
					.Height = SZ.Height + TM * 2
					
					If .X < 0 Then .X = LW
					If .Y < 0 Then .Y = LW
					If .X + .Width > ScaleX(This.ClientWidth) Then .X = ScaleX(This.ClientWidth) - .Width - LW
					If .Y + .Height > ScaleY(This.ClientHeight) Then .Y = ScaleY(This.ClientHeight) - .Height - LW
				End With
				
				RoundRect RectF_, RGBtoARGB(FBackColor, 90), RGBtoARGB(m_LinesColor, 80), TM, , 90, 80
				
				RectF_.X = RectF_.X + TM
				RectF_.Y = RectF_.Y + TM
				
				If cAxisItem->Count = m_Serie(0).Values->Count Then
					sText = cAxisItem->Item(mHotBar) ' + 1
					With RectF_
						GetTextSize sText, 0, 0, This.Font, False, SZ
						DrawText sText, .X, .Y, .Width, 0, This.Font, lForeColor, cLeft, cTop
						.Y = .Y + SZ.Height
					End With
				End If
				
				For i = 0 To SerieCount - 1
					For j = 0 To m_Serie(i).Values->Count - 1
						
						
						If mHotBar = j Then  'mHotSerie = I And ' - 1
							
							
							sDisplay = Replace(m_LabelsFormats, "{V}", WStr(m_Serie(i).Values->Item(j)))
							sDisplay = Replace(sDisplay, "{LF}", Chr(10))
							'sText =  & sDisplay
							
							With RectF_
								sText = m_Serie(i).SerieName & ": "
								GetTextSize sText, 0, 0, This.Font, False, SZ
								#ifdef __USE_GTK__
									cairo_set_source_rgba(cr, GetRedD(m_Serie(i).SerieColor), GetGreenD(m_Serie(i).SerieColor), GetBlueD(m_Serie(i).SerieColor), 1)
									cairo_rectangle(cr, .X, .Y + SZ.Height / 4, SZ.Height / 2, SZ.Height / 2)
									cairo_fill(cr)
								#else
									GdipCreateSolidFill RGBtoARGB(m_Serie(i).SerieColor, 100), Cast(GpSolidFill Ptr Ptr, @hBrush)
									GdipFillRectangleI hGraphics, hBrush, .X, .Y + SZ.Height / 4, SZ.Height / 2, SZ.Height / 2
									GdipDeleteBrush hBrush
								#endif
								
								DrawText sText, .X + SZ.Height / 1.5, .Y, .Width, 0, This.Font, lForeColor, cLeft, cTop
								
								Canvas.Font.Bold = True
								DrawText sDisplay, .X + SZ.Height / 1.5 + SZ.Width, .Y, .Width, 0, Canvas.Font, lForeColor, cLeft, cTop
								Canvas.Font.Bold = False
								
								.Y = .Y + SZ.Height
								' TextWidth = Canvas.TextWidth(m_Serie(I).SerieName) * 1.3
								'DrawText hGraphics, m_Serie(I).SerieName & ": ", .Left, .Top, .Width, 0, This.Font, lForeColor, cLeft, cTop
								' .Left = .Left + TextWidth
								'
								'This.Font.Bold = True
								'DrawText hGraphics, sDisplay, .Left, .Top, .Width, 0, This.Font, lForeColor, cLeft, cTop
								' This.Font.Bold = bBold
							End With
							
						End If
					Next
				Next
				Canvas.Font.Bold = bBold
			End If
		Case CS_GroupedColumn To CS_StackedBarsPercent
			Dim i As Long, j As Long
			Dim sDisplay As String
			Dim bBold As Boolean
			Dim RectF_ As RectF
			Dim LW As Single
			Dim lForeColor As Long
			Dim TM As Single
			Dim SZ As SIZEF
			
			If mHotBar > -1 Then
				TM = ScaleY(Canvas.TextHeight("Aj")) / 4
				lForeColor = RGBtoARGB(FForeColor, 100)
				LW = m_LinesWidth * nScale
				
				For i = 0 To SerieCount - 1
					For j = 0 To m_Serie(i).Values->Count
						
						Dim sText As String
						If mHotSerie = i And mHotBar = j Then ' - 1
							
							If cAxisItem->Count = m_Serie(i).Values->Count Then
								sText = cAxisItem->Item(j) & Chr(13, 10)
							End If
							sDisplay = Replace(m_LabelsFormats, "{V}", WStr(m_Serie(i).Values->Item(j)))
							sDisplay = Replace(sDisplay, "{LF}", Chr(10))
							sText = sText & m_Serie(i).SerieName & ": " & sDisplay
							
							GetTextSize sText, 0, 0, This.Font, False, SZ
							
							With RectF_
								
								.X = m_Serie(i).Rects(j).Left + BarWidth / 2 - SZ.Width / 2 ' - 1
								.Y = m_Serie(i).Rects(j).Top - SZ.Height - 10 * nScale ' - 1
								.Width = SZ.Width + TM * 2
								.Height = SZ.Height + TM * 2
								
								If .X < 0 Then .X = LW
								If .Y < 0 Then .Y = LW
								If .X + .Width >= ScaleX(This.ClientWidth) - LW Then .X = ScaleX(This.ClientWidth) - .Width - LW
								If .Y + .Height >= ScaleY(This.ClientHeight) - LW Then .Y = ScaleY(This.ClientHeight) - .Height - LW
							End With
							
							RoundRect RectF_, RGBtoARGB(FBackColor, 90), RGBtoARGB(m_Serie(i).SerieColor, 80), TM, , 90, 80
							
							
							With RectF_
								.X = .X + TM
								.Y = .Y + TM
								If cAxisItem->Count = m_Serie(i).Values->Count Then
									DrawText cAxisItem->Item(j), .X, .Y, .Width, 0, This.Font, lForeColor, cLeft, cTop
									GetTextSize cAxisItem->Item(j), 0, 0, This.Font, False, SZ
									.Y = .Y + SZ.Height
								End If
								
								DrawText m_Serie(i).SerieName & ": ", .X, .Y, .Width, 0, This.Font, lForeColor, cLeft, cTop
								GetTextSize m_Serie(i).SerieName & ": ", 0, 0, This.Font, False, SZ
								.X = .X + SZ.Width
								bBold = Canvas.Font.Bold
								Canvas.Font.Bold = True
								DrawText sDisplay, .X, .Y, .Width, 0, Canvas.Font, lForeColor, cLeft, cTop
								Canvas.Font.Bold = bBold
							End With
							
						End If
					Next
				Next
			End If
		End Select
	End Sub
	
	Private Sub Chart.RoundRect(Rect_ As RectF, ByVal BackColor As Long, ByVal lBorderColor As Long, ByVal Round As Single, bBorder As Boolean = True, BackColorAlpha As Integer = 100, BorderColorAlpha As Integer = 100)
		#ifndef __USE_GTK__
			Dim hPen As GpPen Ptr, hBrush As GpBrush Ptr
			Dim mPath As GpPath Ptr
		#endif
		
		#ifdef __USE_GTK__
			Dim As Long BrushColor = BackColor
			Dim As Long PenColor = lBorderColor
			cairo_set_line_width(cr, 1 * nScale)
			cairo_new_path(cr)
		#else
			GdipCreateSolidFill BackColor, Cast(GpSolidFill Ptr Ptr, @hBrush)
			If bBorder Then GdipCreatePen1 lBorderColor, 1 * nScale, &H2, @hPen
		#endif
		
		If Round = 0 Then
			With Rect_
				#ifdef __USE_GTK__
					cairo_set_source_rgba(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor), BackColorAlpha / 100)
					cairo_rectangle(cr, .X, .Y, .Width, .Height)
					cairo_fill(cr)
					If bBorder Then
						cairo_set_source_rgba(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor), BorderColorAlpha / 100)
						cairo_rectangle(cr, .X, .Y, .Width, .Height)
						cairo_stroke(cr)
					End If
				#else
					GdipFillRectangleI hGraphics, hBrush, .X, .Y, .Width, .Height
					If hPen Then GdipDrawRectangleI hGraphics, hPen, .X, .Y, .Width, .Height
				#endif
			End With
		Else
			#ifdef __USE_GTK__
				Round = Round * 2
				With Rect_
					Var x = .X, y = .Y, nWidth = .Width, nHeight = .Height
					Var radius = Round / 2
					cairo_set_source_rgba(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor), BackColorAlpha / 100)
					cairo_arc (cr, x + radius + 0.5, y + radius + 0.5, radius, G_PI, -G_PI / 2)
					cairo_line_to (cr, x + nWidth - radius * 2 + 0.5, y + 0.5)
					cairo_arc (cr, x + nWidth - radius + 0.5, y + radius + 0.5, radius, -G_PI / 2, 0)
					cairo_line_to (cr, x + nWidth + 0.5, y + nHeight - radius + 0.5)
					cairo_arc (cr, x + nWidth - radius + 0.5, y + nHeight - radius + 0.5, radius, 0, G_PI / 2)
					cairo_line_to (cr, x + nWidth - radius + 0.5, y + nHeight + 0.5)
					cairo_arc (cr, x + radius + 0.5, y + nHeight - radius + 0.5, radius, G_PI / 2, G_PI)
					cairo_close_path cr
					cairo_fill(cr)
					If bBorder Then
						cairo_set_source_rgba(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor), BorderColorAlpha / 100)
						cairo_arc (cr, x + radius + 0.5, y + radius + 0.5, radius, G_PI, -G_PI / 2)
						cairo_line_to (cr, x + nWidth - radius * 2 + 0.5, y + 0.5)
						cairo_arc (cr, x + nWidth - radius + 0.5, y + radius + 0.5, radius, -G_PI / 2, 0)
						cairo_line_to (cr, x + nWidth + 0.5, y + nHeight - radius + 0.5)
						cairo_arc (cr, x + nWidth - radius + 0.5, y + nHeight - radius + 0.5, radius, 0, G_PI / 2)
						cairo_line_to (cr, x + nWidth - radius + 0.5, y + nHeight + 0.5)
						cairo_arc (cr, x + radius + 0.5, y + nHeight - radius + 0.5, radius, G_PI / 2, G_PI)
						cairo_close_path cr
						cairo_stroke(cr)
					End If
				End With
			#else
				If GdipCreatePath(&H0, @mPath) = 0 Then
					Round = Round * 2
					With Rect_
						GdipAddPathArcI mPath, .X, .Y, Round, Round, 180, 90
						GdipAddPathArcI mPath, .X + .Width - Round, .Y, Round, Round, 270, 90
						GdipAddPathArcI mPath, .X + .Width - Round, .Y + .Height - Round, Round, Round, 0, 90
						GdipAddPathArcI mPath, .X, .Y + .Height - Round, Round, Round, 90, 90
						GdipClosePathFigure mPath
					End With
					GdipFillPath hGraphics, hBrush, mPath
					If hPen Then GdipDrawPath hGraphics, hPen, mPath
					GdipDeletePath(mPath)
				End If
			#endif
		End If
		
		#ifndef __USE_GTK__
			GdipDeleteBrush(hBrush)
			If hPen Then GdipDeletePen(hPen)
		#endif
		
	End Sub
	
	Private Function Chart.ShiftColor(ByVal clrFirst As Long, ByVal clrSecond As Long, ByVal lAlpha As Long) As Long
		Dim lShiftColor As Long
		#ifdef __USE_GTK__
			Dim clrFore(3)         As ULong = {GetRed(clrFirst), GetGreen(clrFirst), GetBlue(clrFirst)}
			Dim clrBack(3)         As ULong = {GetRed(clrSecond), GetGreen(clrSecond), GetBlue(clrSecond)}
			
			clrFore(0) = (clrFore(0) * lAlpha + clrBack(0) * (255 - lAlpha)) / 255
			clrFore(1) = (clrFore(1) * lAlpha + clrBack(1) * (255 - lAlpha)) / 255
			clrFore(2) = (clrFore(2) * lAlpha + clrBack(2) * (255 - lAlpha)) / 255
			
			lShiftColor = RGB(clrFore(0), clrFore(1), clrFore(2))
			lShiftColor = (Cast(ULong, 100 / 100 * 255) Shl 24) + (Cast(ULong, GetRed(lShiftColor)) Shl 16) + (Cast(ULong, GetGreen(lShiftColor)) Shl 8) + (Cast(ULong, GetBlue(lShiftColor)))
		#else
			Dim clrFore(3)         As ColorREF
			Dim clrBack(3)         As ColorREF
			
			OleTranslateColor clrFirst, 0, VarPtr(clrFore(0))
			OleTranslateColor clrSecond, 0, VarPtr(clrBack(0))
			
			clrFore(0) = (clrFore(0) * lAlpha + clrBack(0) * (255 - lAlpha)) / 255
			clrFore(1) = (clrFore(1) * lAlpha + clrBack(1) * (255 - lAlpha)) / 255
			clrFore(2) = (clrFore(2) * lAlpha + clrBack(2) * (255 - lAlpha)) / 255
			
			memcpy @lShiftColor, VarPtr(clrFore(0)), 4
		#endif
		
		Return lShiftColor
		
	End Function
	
	Private Function Chart.IsDarkColor(ByVal lColor As Long) As Boolean
		Dim bBGRA(0 To 3) As Byte
		#ifndef __USE_GTK__
			OleTranslateColor lColor, 0, VarPtr(lColor)
			CopyMemory(@bBGRA(0), @lColor, 4&)
		#endif
		
		IsDarkColor = ((CLng(bBGRA(0)) + (CLng(bBGRA(1) * 3)) + CLng(bBGRA(2))) / 2) < 382
		
	End Function
	
	Private Function Chart.FormatLabel(ByVal numerical_expression As Double, ByRef formatting_expression As WString = "") As UString
		If formatting_expression = "" Then
			Return WStr(numerical_expression)
		Else
			Return Format(numerical_expression, formatting_expression)
		End If
	End Function
	
	Private Sub Chart.Example()
		Me.AddItem "Juan", 70, clRed
		Me.AddItem "Adan", 20, clGreen
		Me.AddItem "Pedro", 10, clBlue
		
		Dim StringValue As WStringList Ptr
		StringValue = New WStringList
		
		StringValue->Add "2018"
		StringValue->Add "2019"
		StringValue->Add "2020"
		Me.AddAxisItems StringValue
		
		Dim Value As DoubleList Ptr
		Value = New DoubleList
		With *Value
			.Add 10
			.Add 15
			.Add 5
		End With
		This.AddSerie "Juan", clRed, Value
		Value = New DoubleList
		With *Value
			.Add 8
			.Add 4
			.Add 12
		End With
		Me.AddSerie "Pedro", clBlue, Value
	End Sub
	
	#ifndef __USE_GTK__
		Private Sub Chart.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			With QChart(@Sender)
				.HotItem = -1
				.nScale = .GetWindowsDPI
				'.m_TitleFont = New My.SYs.FornFont
				If .Parent <> 0 Then .c_lhWnd = .Parent->Handle
				.m_FontSize = .Font.Size
				.m_TitleFontSize = .m_TitleFont.Size
				.m_Width = .Width
				.m_Height = .Height
				.m_SeparatorLineWidth2 = .m_SeparatorLineWidth
				.m_DonutWidth2 = .m_DonutWidth
				'If .DesignMode Then .Example
				.ManageGDIToken(.c_lhWnd)
				'.cAxisItem = New WStringList
				.mHotBar = -1
				.mHotSerie = -1
			End With
		End Sub
		
		Private Sub Chart.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Private Sub Chart.ProcessMessage(ByRef Message As Message)
		Static DownButton As Integer = -1
		Dim As Integer HitResult
		#ifdef __USE_GTK__
			Dim As GdkEvent Ptr e = Message.event
			Select Case Message.event->type
			Case GDK_BUTTON_PRESS: DownButton = e->button.button - 1
			Case GDK_BUTTON_RELEASE: MouseUp e->button.button - 1, e->button.state, e->button.x, e->button.y: DownButton = -1
			Case GDK_MOTION_NOTIFY: MouseMove(DownButton, e->Motion.state, e->Motion.x, e->Motion.y)
			End Select
		#else
			Select Case Message.Msg
			Case WM_ERASEBKGND
				Message.Result = 0
				Exit Sub
			Case WM_PAINT
				Dim ps As PAINTSTRUCT
				Dim Dc As HDC
				'Dim As HDC bufDC
				Dim As HBITMAP bufBMP
				Dim As Integer mClientWidth = ScaleX(This.ClientWidth), mClientHeight = ScaleY(This.ClientHeight)
				Dc = BeginPaint(This.Handle, @ps)
				hD = CreateCompatibleDC(Dc)
				bufBMP = CreateCompatibleBitmap(Dc, mClientWidth, mClientHeight)
				SelectObject(hD, bufBMP)
				This.Paint
				BitBlt(Dc, 0, 0, mClientWidth, mClientHeight, hD, 0, 0, SRCCOPY)
				DeleteDc hD
				DeleteObject bufBMP
				EndPaint(This.Handle, @ps)
				Message.Result = 0
				Exit Sub
			Case WM_SIZE:
				Font.Size = Max(m_FontSize, m_FontSize * This.Height / m_Height)
				m_TitleFont.Size = Max(m_TitleFontSize, (m_TitleFontSize) * This.Height / m_Height)
				m_SeparatorLineWidth = m_SeparatorLineWidth2 * This.Height / m_Height
				m_DonutWidth = m_DonutWidth2 * This.Height / m_Height
			Case WM_LBUTTONDOWN: DownButton = 0
			Case WM_RBUTTONDOWN: DownButton = 1
			Case WM_MBUTTONDOWN: DownButton = 2
			Case WM_LBUTTONUP: MouseUp DownButton, Message.wParam And &HFFFF, Message.lParamLo, Message.lParamHi: DownButton = -1
			Case WM_RBUTTONUP: MouseUp DownButton, Message.wParam And &HFFFF, Message.lParamLo, Message.lParamHi: DownButton = -1
			Case WM_MBUTTONUP: MouseUp DownButton, Message.wParam And &HFFFF, Message.lParamLo, Message.lParamHi: DownButton = -1
			Case WM_MOUSEMOVE: MouseMove DownButton, Message.wParam And &HFFFF, Message.lParamLo, Message.lParamHi
			Case WM_NCHITTEST: HitTest Message.lParamLo, Message.lParamHi, HitResult
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Operator Chart.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Private Function Chart.OnDraw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As gpointer) As Boolean
			Dim As Chart Ptr chrt = Cast(Any Ptr, data1)
			If chrt->cr = 0 Then
				chrt->cr = cr
				chrt->Canvas.Handle = cr
				chrt->Canvas.Font.Name = chrt->Font.Name
				chrt->Canvas.Font.Size = chrt->Font.Size
				chrt->Canvas.layout = chrt->layout
				With *chrt
					.HotItem = -1
					.nScale = .GetWindowsDPI
					'.m_TitleFont = New My.SYs.FornFont
					'If .Parent <> 0 Then .c_lhWnd = .Parent->Handle
					.m_FontSize = .Font.Size
					.m_TitleFontSize = .m_TitleFont.Size
					.m_Width = .Width
					.m_Height = .Height
					.m_SeparatorLineWidth2 = .m_SeparatorLineWidth
					.m_DonutWidth2 = .m_DonutWidth
					'If .DesignMode Then .Example
					'.ManageGDIToken(.c_lhWnd)
					'.cAxisItem = New WStringList
					.mHotBar = -1
					.mHotSerie = -1
				End With
			End If
			#ifdef __USE_GTK3__
			#else
				chrt->cr = cr
			#endif
			chrt->Draw
			
			Return False
		End Function
		
		Private Function Chart.OnExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As gpointer) As Boolean
			Dim As Chart Ptr chrt = Cast(Any Ptr, data1)
			Dim As cairo_t Ptr cr = gdk_cairo_create(Event->window)
			chrt->win = Event->window
			chrt->OnDraw widget, cr, data1
			cairo_destroy(cr)
			Return False
		End Function
		
		Private Sub Chart.OnSizeAllocate(widget As GtkWidget Ptr, allocation As GdkRectangle Ptr, user_data As Any Ptr)
			Dim As Chart Ptr chrt = Cast(Any Ptr, user_data)
			With *chrt
				If .cr <> 0 Then
					'.Font.Size = Max(.m_FontSize, .m_FontSize * .Height / .m_Height)
					.m_TitleFont.Size = Max(.m_TitleFontSize, (.m_TitleFontSize) * .Height / .m_Height)
					.m_SeparatorLineWidth = .m_SeparatorLineWidth2 * .Height / .m_Height
					.m_DonutWidth = .m_DonutWidth2 * .Height / .m_Height
				End If
			End With
		End Sub
	#endif
	
	Private Constructor Chart
		With This
			WLet(FClassName, "Chart")
			#ifdef __USE_GTK__
				widget = gtk_layout_new(NULL, NULL)
				.RegisterClass "Chart", @This
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
				g_signal_connect(widget, "size-allocate", G_CALLBACK(@OnSizeAllocate), @This)
				#ifdef __USE_GTK3__
					g_signal_connect(widget, "draw", G_CALLBACK(@OnDraw), @This)
				#else
					g_signal_connect(widget, "expose-event", G_CALLBACK(@OnExposeEvent), @This)
				#endif
				pcontext = gtk_widget_create_pango_context(widget)
				layout = pango_layout_new(pcontext)
				Dim As PangoFontDescription Ptr desc
				#ifdef __FB_WIN32__
					desc = pango_font_description_from_string ("Sans 8")
				#else
					desc = pango_font_description_from_string ("Noto Mono 8")
				#endif
				pango_layout_set_font_description (layout, desc)
				pango_font_description_free (desc)
				'Canvas.Font = Font
			#else
				.Style        = WS_CHILD
				.ExStyle      = 0
				.RegisterClass "Chart", ""
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.Width        = 175
			.Height       = 21
			.Child        = @This
			.Canvas.Ctrl = @This
			.InitProperties()
			.tmrMOUSEOVER.Designer = @This
			.tmrMOUSEOVER.Interval = 0
			.tmrMOUSEOVER.OnTimer = @tmrMOUSEOVER_Timer_
			.tmrMOUSEOVER.Enabled = True
		End With
	End Constructor
	
	Private Destructor Chart
		
		Dim i As Long
		For i = 0 To ItemsCount - 1
			#ifdef __USE_GTK__
				cairo_path_destroy(m_Item(i).hPath)
			#else
				GdipDeletePath m_Item(i).hPath
			#endif
		Next
		#ifndef __USE_GTK__
			If gToken Then
				GdiplusShutdown(gToken)
			End If
			'UnregisterClass "Chart",GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
