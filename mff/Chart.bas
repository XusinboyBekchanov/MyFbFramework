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
		Case "tooltipsformat": Return m_ToolTipsFormat.vptr
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
			Case "tooltipsformat": ToolTipsFormat = QWString(Value)
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
	
	Private Function Chart.SeriesCount As Long
		Return SerieCount
	End Function
	
	Private Function Chart.AxisItemsCount As Long
		If cAxisItem = 0 Then
			Return 0
		Else
			Return cAxisItem->Count
		End If
	End Function
	
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
	
	Private Property Chart.ToolTipsFormat() ByRef As WString
		Return *m_ToolTipsFormat.vptr
	End Property
	
	Private Property Chart.ToolTipsFormat(ByRef New_Value As WString)
		m_ToolTipsFormat = New_Value
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
				.Values = New DoubleList
				For j = 0 To Values->Count - 1
					Dif = Values->Item(j) - TempCol->Item(j)
					.Values->Add TempCol->Item(j) + i * Dif / 10
				Next
				Me.Refresh
				pApp->DoEvents
				Wait 1
				Delete_(.Values)
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
?1186:			Dim hPath As GpPath Ptr
?1187:			Dim hBrush As GpBrush Ptr, hPen As GpPen Ptr
		#endif
?1189:		Dim mRect As RectL
?1190:		Dim i As Single, j As Long
?1191:		Dim mPenWidth As Single
?1192:		Dim TextWidth As Single
?1193:		Dim TextHeight As Single
?1194:		Dim XX As Single, YY As Single
?1195:		Dim yRange As Single
?1196:		Dim lForeColor As Long
?1197:		Dim RectL_ As RectL
?1198:		Dim LabelsRect As RectL
?1199:		Dim iStep As Single
?1200:		Dim nVal As Single
?1201:		Dim NumDecim As Single
?1202:		Dim forLines As Single, toLines As Single
?1203:		Dim AxisX As SIZEF
?1204:		Dim AxisY As SIZEF
?1205:		Dim PT16 As Single
?1206:		Dim PT24 As Single
?1207:		Dim ColRow As Integer
?1208:		Dim LineSpace As Single
?1209:		Dim TitleSize As SIZEF
?1210:		Dim sDisplay As String
?1211:		Dim SafePercent As Single
?1212:		Dim Min As Single, Max As Single, LastAngle As Single, Angle As Single, Total  As Single
?1213:		Dim DonutSize As Single
?1214:		Dim LW As Single
?1215:		Dim R1 As Single, R2 As Single, R3 As Single
?1216:		Dim CX As Single, CY   As Single
?1217:		Dim Left_ As Single, Top_ As Single
?1218:		Dim Percent As Single
?1219:		Const PItoRAD = 3.141592 / 180
?1220:		Dim lTop As Single
?1221:		Dim ZeroPoint As Long
?1222:		Dim sLabelText As String
?1223:		Dim bAngMaj180 As Boolean
?1224:		Dim LblWidth As Single
?1225:		Dim LblHeight As Single
?1226:		Dim mFormat As String
?1227:		Dim A As Single
?1228:		Dim Displacement As Single
?1229:		Dim lColor As Long
?1230:		Dim Value As Single
?1231:		Dim RangeHeight As Single
?1232:		Dim BarSpace As Single
?1233:		Dim BarWidth As Single
?1234:		Dim LastPositive() As Long, LastNegative() As Long
?1235:		
		#ifndef __USE_GTK__
?1237:			If GdipCreateFromHDC(hD, @hGraphics) Then Exit Sub
?1238:			
?1239:			GdipSetSmoothingMode(hGraphics, SmoothingModeAntiAlias)
?1240:			GdipSetCompositingQuality(hGraphics, &H3) 'CompositingQualityGammaCorrected
		#endif
?1242:		
?1243:		Select Case ChartStyle
		Case CS_PIE To CS_DONUT
?1245:			
?1246:			PT16 = 16 * nScale
?1247:			mPenWidth = 1 * nScale
?1248:			DonutSize = m_DonutWidth * nScale
?1249:			
?1250:			MarginLeft = PT16
?1251:			TopHeader = PT16
?1252:			MarginRight = PT16
?1253:			Footer = PT16
?1254:			
?1255:			Canvas.Font = This.Font
?1256:			If m_LegendVisible Then
?1257:				For i = 0 To ItemsCount - 1
?1258:					m_Item(i).TextHeight = ScaleY(Canvas.TextHeight(m_Item(i).ItemName)) * 1.5
?1259:					m_Item(i).TextWidth = ScaleX(Canvas.TextWidth(m_Item(i).ItemName)) * 1.5 + m_Item(i).TextHeight
?1260:				Next
?1261:			End If
?1262:			
?1263:			If Len(m_Title) Then
?1264:				GetTextSize(*m_Title.vptr, ScaleX(This.ClientWidth), 0, m_TitleFont, True, TitleSize)
?1265:				TopHeader = TopHeader + TitleSize.Height
?1266:			End If
?1267:			mWidth = ScaleX(This.ClientWidth) - MarginLeft - MarginRight
?1268:			mHeight = ScaleY(This.ClientHeight) - TopHeader - Footer
?1269:			
			'Calculate the Legend Area
?1271:			If m_LegendVisible Then
?1272:				ColRow = 1
?1273:				Select Case m_LegendAlign
				Case LA_RIGHT, LA_LEFT
?1275:					With LabelsRect
?1276:						TextWidth = 0
?1277:						TextHeight = 0
?1278:						For i = 0 To ItemsCount - 1
?1279:							If TextHeight + m_Item(i).TextHeight > mHeight Then
?1280:								.Right = .Right + TextWidth
?1281:								ColRow = ColRow + 1
?1282:								TextWidth = 0
?1283:								TextHeight = 0
?1284:							End If
?1285:							
?1286:							TextHeight = TextHeight + m_Item(i).TextHeight
?1287:							.Bottom = .Bottom + m_Item(i).TextHeight
?1288:							
?1289:							If TextWidth < m_Item(i).TextWidth Then
?1290:								TextWidth = m_Item(i).TextWidth '+ PT16
?1291:							End If
?1292:						Next
?1293:						.Right = .Right + TextWidth
?1294:						If m_LegendAlign = LA_LEFT Then
?1295:							MarginLeft = MarginLeft + .Right
?1296:						Else
?1297:							MarginRight = MarginRight + .Right
?1298:						End If
?1299:						mWidth = mWidth - .Right
?1300:					End With
?1301:					
?1302:				Case LA_BOTTOM, LA_TOP
?1303:					With LabelsRect
?1304:						
?1305:						.Bottom = m_Item(0).TextHeight + PT16 / 2
?1306:						TextWidth = 0
?1307:						For i = 0 To ItemsCount - 1
?1308:							If TextWidth + m_Item(i).TextWidth > mWidth Then
?1309:								.Bottom = .Bottom + m_Item(i).TextHeight
?1310:								ColRow = ColRow + 1
?1311:								TextWidth = 0
?1312:							End If
?1313:							TextWidth = TextWidth + m_Item(i).TextWidth
?1314:							.Right = .Right + m_Item(i).TextWidth
?1315:						Next
?1316:						If m_LegendAlign = LA_TOP Then
?1317:							TopHeader = TopHeader + .Bottom
?1318:						End If
?1319:						mHeight = mHeight - .Bottom
?1320:					End With
?1321:				End Select
?1322:			End If
?1323:			
?1324:			
?1325:			Dim RectF_ As RectF
?1326:			With RectF_
?1327:				.Width = ScaleX(This.ClientWidth) - 1 * nScale
?1328:				.Height = ScaleY(This.ClientHeight) - 1 * nScale
?1329:			End With
?1330:			
?1331:			RoundRect RectF_, RGBtoARGB(FBackColor, m_BackColorOpacity), RGBtoARGB(m_BorderColor, 100), m_BorderRound * nScale, m_Border, m_BackColorOpacity
?1332:			
?1333:			
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
?1348:			
?1349:			
			'Sum of itemes
?1351:			For i = 0 To ItemsCount - 1
?1352:				Total = Total + m_Item(i).Value
?1353:			Next
?1354:			
			'calculate max size of labels
?1356:			For i = 0 To ItemsCount - 1
?1357:				With m_Item(i)
?1358:					Percent = Round(100 * .Value / Total, 1)
?1359:					If i < ItemsCount - 1 Then
?1360:						SafePercent = SafePercent + Percent
?1361:					Else
?1362:						Percent = Round(100 - SafePercent, 1)
?1363:					End If
?1364:					.text = Replace(m_LabelsFormats, "{A}", .ItemName)
?1365:					.text = Replace(.text, "{P}", WStr(Percent))
?1366:					.text = Replace(.text, "{V}", WStr(Round(.Value, 1)))
?1367:					.text = Replace(.text, "{LF}", Chr(10))
?1368:					
?1369:					TextWidth = ScaleX(Canvas.TextWidth(.text)) * 1.3
?1370:					TextHeight = ScaleY(Canvas.TextHeight(.text)) * 1.3
?1371:					If TextWidth > LblWidth Then LblWidth = TextWidth
?1372:					If TextHeight > LblHeight Then LblHeight = TextHeight
?1373:				End With
?1374:			Next
?1375:			
			'size of pie
?1377:			If m_LabelsPositions = LP_Outside Or m_LabelsPositions = LP_TwoColumns Then
?1378:				Min = IIf(mWidth - LblWidth * 2 < mHeight - LblHeight * 2, mWidth - LblWidth * 2, mHeight - LblHeight * 2)
?1379:			Else
?1380:				Min = IIf(mWidth < mHeight, mWidth, mHeight)
?1381:			End If
?1382:			
?1383:			If Min / 3 < DonutSize Then DonutSize = Min / 3
?1384:			XX = MarginLeft + mWidth / 2 - Min / 2
?1385:			YY = TopHeader + mHeight / 2 - Min / 2
?1386:			m_CenterCircle.X = MarginLeft + mWidth / 2
?1387:			m_CenterCircle.Y = TopHeader + mHeight / 2
?1388:			R1 = Min / 2
?1389:			
			'    If m_SeparatorLine Then
			'        GdipCreateSolidFill RGBtoARGB(m_SeparatorLineColor, m_BackColorOpacity), hBrush
			'        GdipFillEllipseI hGraphics, hBrush, XX - m_SeparatorLineWidth, YY - m_SeparatorLineWidth, Min + m_SeparatorLineWidth * 2, Min + m_SeparatorLineWidth * 2
			'        GdipDeleteBrush hBrush
			'    End If
?1395:			
?1396:			LastAngle = m_Rotation - 90
?1397:			For i = 0 To ItemsCount - 1
?1398:				Angle = 360 * m_Item(i).Value / Total
?1399:				
?1400:				
				'*1
?1402:				If m_Item(i).Special Then
?1403:					R2 = PT16 / 1.5
?1404:					Left_ = XX + (R2 * Cos((LastAngle + Angle / 2) * PItoRAD))
?1405:					Top_ = YY + (R2 * Sin((LastAngle + Angle / 2) * PItoRAD))
?1406:				Else
?1407:					Left_ = XX
?1408:					Top_ = YY
?1409:				End If
?1410:				
				#ifdef __USE_GTK__
?1412:					If m_Item(i).hPath <> 0 Then cairo_path_destroy m_Item(i).hPath
?1413:					cairo_new_path(cr)
				#else
?1415:					If m_Item(i).hPath <> 0 Then GdipDeletePath m_Item(i).hPath
?1416:					GdipCreatePath 0, @m_Item(i).hPath
				#endif
?1418:				
?1419:				If m_ChartStyle = CS_DONUT Then
					#ifdef __USE_GTK__
?1421:						cairo_move_to(cr, Left_ + Min / 2, Top_ + Min / 2)
?1422:						cairo_arc(cr, Left_ + Min / 2, Top_ + Min / 2, Min / 2, LastAngle * (G_PI / 180), LastAngle * (G_PI / 180) + Angle * (G_PI / 180))
?1423:						cairo_arc_negative(cr, Left_ + DonutSize + (Min - DonutSize * 2) / 2, Top_ + DonutSize + (Min - DonutSize * 2) / 2, (Min - DonutSize * 2) / 2, LastAngle  * (G_PI / 180) + Angle * (G_PI / 180),LastAngle  * (G_PI / 180) + Angle * (G_PI / 180) + -Angle * (G_PI / 180))
					#else
?1425:						GdipAddPathArc m_Item(i).hPath, Left_, Top_, Min, Min, LastAngle, Angle
?1426:						GdipAddPathArc m_Item(i).hPath, Left_ + DonutSize, Top_ + DonutSize, Min - DonutSize * 2, Min - DonutSize * 2, LastAngle + Angle, -Angle
					#endif
?1428:				Else
					#ifdef __USE_GTK__
?1430:						cairo_move_to(cr, Left_ + Min / 2, Top_ + Min / 2)
?1431:						cairo_arc(cr, Left_ + Min / 2, Top_ + Min / 2, Min / 2, LastAngle * (G_PI / 180), LastAngle * (G_PI / 180) + Angle * (G_PI / 180)) 'LastAngle / 90, Angle / 90
					#else
?1433:						GdipAddPathPie m_Item(i).hPath, Left_, Top_, Min, Min, LastAngle, Angle
					#endif
?1435:				End If
				#ifdef __USE_GTK__
?1437:					m_Item(i).hPath = cairo_copy_path(cr)
				#endif
?1439:				
?1440:				If HotItem = i Then
?1441:					lColor = RGBtoARGB(ShiftColor(m_Item(i).ItemColor, clWhite, 150), m_FillOpacity)
?1442:				Else
?1443:					lColor = RGBtoARGB(m_Item(i).ItemColor, m_FillOpacity)
?1444:				End If
?1445:				If m_FillGradient Then
?1446:					With RectL_
?1447:						.Left = MarginLeft - R2
?1448:						.Top = TopHeader - R2
?1449:						.Right = mWidth + R2 * 2
?1450:						.Bottom = mHeight + R2 * 2
?1451:					End With
					#ifndef __USE_GTK__
?1453:						GdipCreateLineBrushFromRectWithAngleI Cast(GpRect Ptr, @RectL_), lColor, RGBtoARGB(clWhite, 100), 180 + LastAngle + Angle / 2, 0, WrapModeTile, Cast(GpLineGradient Ptr Ptr, @hBrush)
					#endif
?1455:				Else
					#ifndef __USE_GTK__
?1457:						GdipCreateSolidFill lColor, Cast(GpSolidFill Ptr Ptr, @hBrush)
					#endif
?1459:				End If
				#ifdef __USE_GTK__
?1461:					cairo_set_source_rgba(cr, GetRedD(lColor), GetGreenD(lColor), GetBlueD(lColor), m_FillOpacity / 100)
?1462:					cairo_fill(cr)
				#else
?1464:					GdipFillPath hGraphics, Cast(GpBrush Ptr, hBrush), m_Item(i).hPath
?1465:					GdipDeleteBrush Cast(GpBrush Ptr, hBrush)
				#endif
?1467:				
?1468:				R1 = Min / 2
?1469:				R2 = m_Item(i).TextWidth / 2
?1470:				R3 = m_Item(i).TextHeight / 2
?1471:				
?1472:				CX = XX + Min / 2 + TextWidth
?1473:				CY = YY + Min / 2 + TextHeight
?1474:				
?1475:				Left_ = CX + ((R1 - R2) * Cos((LastAngle + Angle / 2) * PItoRAD)) - R2
?1476:				Top_ = CY + ((R1 - R3) * Sin((LastAngle + Angle / 2) * PItoRAD)) - R3
				'DrawText hGraphics, m_Item(i).ItemName, Left, Top, R2 * 2, R3 * 2, This.Font, lForeColor, cCenter, cMiddle
?1478:				LastAngle = LastAngle + Angle '+ 2
?1479:			Next
?1480:			
			'*2
?1482:			
?1483:			LastAngle = m_Rotation - 90
?1484:			bAngMaj180 = False
?1485:			For i = 0 To ItemsCount - 1
?1486:				Angle = 360 * m_Item(i).Value / Total
?1487:				
?1488:				If m_SeparatorLine Then
					#ifdef __USE_GTK__
?1490:						cairo_set_source_rgb(cr, GetRedD(m_SeparatorLineColor), GetGreenD(m_SeparatorLineColor), GetBlueD(m_SeparatorLineColor))
?1491:						cairo_set_line_width (cr, m_SeparatorLineWidth * nScale)
						'?m_SeparatorLineWidth
					#else
?1494:						GdipCreatePen1 RGBtoARGB(m_SeparatorLineColor, 100), m_SeparatorLineWidth * nScale, 2, @hPen
?1495:						GdipSetPenEndCap hPen, 2
					#endif
?1497:					
?1498:					R1 = (Min + mPenWidth / 2) / 2
?1499:					R2 = (Min - mPenWidth / 2) / 2 - DonutSize
?1500:					
?1501:					CX = XX + Min / 2
?1502:					CY = YY + Min / 2
?1503:					
?1504:					Left_ = CX + (R1 * Cos((LastAngle) * PItoRAD))
?1505:					Top_ = CY + (R1 * Sin((LastAngle) * PItoRAD))
?1506:					
?1507:					If m_ChartStyle = CS_DONUT Then
?1508:						CX = CX + (R2 * Cos((LastAngle) * PItoRAD))
?1509:						CY = CY + (R2 * Sin((LastAngle) * PItoRAD))
?1510:					Else
						'GdipDrawEllipseI hGraphics, hPen, XX, YY, Min, Min
?1512:					End If
?1513:					
					#ifdef __USE_GTK__
?1515:						cairo_move_to(cr, Left_, Top_)
?1516:						cairo_line_to(cr, CX, CY)
?1517:						cairo_stroke(cr)
					#else
?1519:						GdipDrawLineI hGraphics, hPen, Left_, Top_, CX, CY
?1520:						
?1521:						GdipDeletePen hPen
					#endif
?1523:				End If
?1524:				
?1525:				TextWidth = LblWidth
?1526:				TextHeight = LblHeight
?1527:				
?1528:				If m_LabelsPositions = LP_Inside Then
?1529:					If DonutSize > TextWidth Then TextWidth = DonutSize
?1530:					If DonutSize > TextHeight Then TextHeight = DonutSize
?1531:				End If
?1532:				
?1533:				R2 = TextWidth / 2
?1534:				R3 = TextHeight / 2
?1535:				Displacement = IIf(m_Item(i).Special, PT16 / 1.5, 0)
?1536:				
?1537:				CX = XX + Min / 2
?1538:				CY = YY + Min / 2
?1539:				
?1540:				A = LastAngle + Angle / 2
?1541:				
?1542:				If m_LabelsPositions = LP_Inside Then
?1543:					Left_ = CX + ((R1 - R2 + Displacement) * Cos(A * PItoRAD)) - R2
?1544:					Top_ = CY + ((R1 - R3 + Displacement) * Sin(A * PItoRAD)) - R3
?1545:				Else
?1546:					Left_ = CX + ((R1 + R2 + Displacement) * Cos(A * PItoRAD)) - R2
?1547:					Top_ = CY + ((R1 + R3 + Displacement) * Sin(A * PItoRAD)) - R3
?1548:				End If
?1549:				If m_LabelsVisible Then
?1550:					If m_LabelsPositions = LP_TwoColumns Then
?1551:						Dim LineOut As Integer
?1552:						LineOut = ScaleY(Canvas.TextHeight("Aj")) / 2
?1553:						
						#ifdef __USE_GTK__
?1555:							Var BrushColor = RGBtoARGB(m_Item(i).ItemColor, 50), BrushAlpha = 0.5
?1556:							Var PenColor = RGBtoARGB(m_Item(i).ItemColor, 50), PenAlpha = 1
?1557:							cairo_set_line_width(cr, 1 * nScale)
						#else
?1559:							GdipCreateSolidFill RGBtoARGB(m_Item(i).ItemColor, 50), Cast(GpSolidFill Ptr Ptr, @hBrush)
?1560:							GdipCreatePen1 RGBtoARGB(m_Item(i).ItemColor, 100), 1 * nScale, 2, @hPen
						#endif
?1562:						
?1563:						If (LastAngle + Angle / 2 + 90) Mod 359 < 180 Then
?1564:							If bAngMaj180 Then
?1565:								bAngMaj180 = False
?1566:								lTop = Top_
?1567:							End If
?1568:							
?1569:							If lTop <= 0 Then lTop = Top_
?1570:							
?1571:							If Top_ < lTop Then
?1572:								lTop = lTop
?1573:							Else
?1574:								lTop = Top_
?1575:							End If
?1576:							
?1577:							Left_ = XX + Min + PT16
							#ifdef __USE_GTK__
?1579:								cairo_set_source_rgba(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor), BrushAlpha)
?1580:								cairo_rectangle(cr, Left_, lTop, TextWidth, TextHeight)
?1581:								cairo_fill(cr)
							#else
?1583:								GdipFillRectangleI hGraphics, Cast(GpBrush Ptr, hBrush), Left_, lTop, TextWidth, TextHeight
							#endif
?1585:							DrawText m_Item(i).text, Left_, lTop, TextWidth, TextHeight, This.Font, RGBtoARGB(FForeColor, 100), cCenter, cMiddle
?1586:							
?1587:							lTop = lTop + TextHeight
?1588:							
?1589:							Left_ = CX + (R1 * Cos(A * PItoRAD))
?1590:							Top_ = CY + (R1 * Sin(A * PItoRAD))
?1591:							CX = CX + ((R1 + LineOut) * Cos(A * PItoRAD))
?1592:							CY = CY + ((R1 + LineOut) * Sin(A * PItoRAD))
?1593:							
							#ifdef __USE_GTK__
?1595:								cairo_set_source_rgba(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor), PenAlpha)
?1596:								cairo_move_to(cr, Left_, Top_)
?1597:								cairo_line_to(cr, CX, CY)
?1598:								cairo_stroke(cr)
							#else
?1600:								GdipDrawLineI hGraphics, hPen, Left_, Top_, CX, CY
							#endif
?1602:							Left_ = XX + Min + PT16
?1603:							Top_ = lTop - TextHeight / 2
							#ifdef __USE_GTK__
?1605:								cairo_set_source_rgba(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor), PenAlpha)
?1606:								cairo_move_to(cr, CX, CY)
?1607:								cairo_line_to(cr, Left_, Top_)
?1608:								cairo_stroke(cr)
							#else
?1610:								GdipDrawLineI hGraphics, hPen, CX, CY, Left_, Top_
							#endif
?1612:						Else
?1613:							If bAngMaj180 = False Then
?1614:								bAngMaj180 = True
?1615:								lTop = TopHeader + mHeight
?1616:							End If
?1617:							
?1618:							If lTop <= 0 Then lTop = Top_
?1619:							
?1620:							If Top_ > lTop Then
?1621:								lTop = lTop
?1622:							Else
?1623:								lTop = Top_
?1624:							End If
?1625:							
?1626:							Left_ = XX - TextWidth - PT16
							#ifdef __USE_GTK__
?1628:								cairo_set_source_rgba(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor), BrushAlpha)
?1629:								cairo_rectangle(cr, Left_, lTop, TextWidth, TextHeight)
?1630:								cairo_fill(cr)
							#else
?1632:								GdipFillRectangleI hGraphics, Cast(GpBrush Ptr, hBrush), Left_, lTop, TextWidth, TextHeight
							#endif
?1634:							DrawText m_Item(i).text, Left_, lTop, TextWidth, TextHeight, This.Font, RGBtoARGB(FForeColor, 100), cCenter, cMiddle
?1635:							
?1636:							Left_ = CX + (R1 * Cos(A * PItoRAD))
?1637:							Top_ = CY + (R1 * Sin(A * PItoRAD))
?1638:							CX = CX + ((R1 + LineOut) * Cos(A * PItoRAD))
?1639:							CY = CY + ((R1 + LineOut) * Sin(A * PItoRAD))
							#ifdef __USE_GTK__
?1641:								cairo_set_source_rgba(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor), PenAlpha)
?1642:								cairo_move_to(cr, Left_, Top_)
?1643:								cairo_line_to(cr, CX, CY)
?1644:								cairo_stroke(cr)
							#else
?1646:								GdipDrawLineI hGraphics, hPen, Left_, Top_, CX, CY
							#endif
?1648:							Left_ = XX - PT16
?1649:							Top_ = lTop + TextHeight / 2
							#ifdef __USE_GTK__
?1651:								cairo_set_source_rgba(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor), PenAlpha)
?1652:								cairo_move_to(cr, CX, CY)
?1653:								cairo_line_to(cr, Left_, Top_)
?1654:								cairo_stroke(cr)
							#else
?1656:								GdipDrawLineI hGraphics, hPen, CX, CY, Left_, Top_
							#endif
?1658:							lTop = lTop - TextHeight
?1659:						End If
						#ifndef __USE_GTK__
?1661:							GdipDeleteBrush Cast(GpBrush Ptr, hBrush)
?1662:							GdipDeletePen hPen
						#endif
?1664:						
?1665:					ElseIf m_LabelsPositions = LP_Inside Then
						'lForeColor = IIf(IsDarkColor(m_Item(i).ItemColor), &H808080, vbWhite)
						'DrawText hGraphics, m_Item(i).Text, Left + 1, Top + 1, TextWidth, TextHeight, This.Font, RGBtoARGB(lForeColor, 100), cCenter, cMiddle
?1668:						If HotItem = i Then
?1669:							lColor = ShiftColor(m_Item(i).ItemColor, clWhite, 150)
?1670:						Else
?1671:							lColor = m_Item(i).ItemColor
?1672:						End If
?1673:						lForeColor = IIf(IsDarkColor(lColor), clWhite, clBlack)
?1674:						DrawText m_Item(i).text, Left_, Top_, TextWidth, TextHeight, This.Font, RGBtoARGB(lForeColor, 100), cCenter, cMiddle
?1675:					Else
?1676:						DrawText m_Item(i).text, Left_, Top_, TextWidth, TextHeight, This.Font, RGBtoARGB(FForeColor, 100), cCenter, cMiddle
?1677:					End If
?1678:				End If
?1679:				LastAngle = LastAngle + Angle '+ 2
?1680:			Next
?1681:			
?1682:			
?1683:			
?1684:			If m_LegendVisible Then
?1685:				For i = 0 To ItemsCount - 1
?1686:					lForeColor = RGBtoARGB(FForeColor, 100)
?1687:					Select Case m_LegendAlign
					Case LA_RIGHT, LA_LEFT
?1689:						With LabelsRect
?1690:							TextWidth = 0
?1691:							
?1692:							If .Left = 0 Then
?1693:								TextHeight = 0
?1694:								If m_LegendAlign = LA_LEFT Then
?1695:									.Left = PT16
?1696:								Else
?1697:									.Left = MarginLeft + mWidth + PT16
?1698:								End If
?1699:								If ColRow = 1 Then
?1700:									.Top = TopHeader + mHeight / 2 - .Bottom / 2
?1701:								Else
?1702:									.Top = TopHeader
?1703:								End If
?1704:							End If
?1705:							
?1706:							If TextWidth < m_Item(i).TextWidth Then
?1707:								TextWidth = m_Item(i).TextWidth '+ PT16
?1708:							End If
?1709:							
?1710:							If TextHeight + m_Item(i).TextHeight > mHeight Then
?1711:								If i > 0 Then .Left = .Left + TextWidth
?1712:								.Top = TopHeader
?1713:								TextHeight = 0
?1714:							End If
?1715:							m_Item(i).LegendRect.Left = .Left
?1716:							m_Item(i).LegendRect.Top = .Top
?1717:							m_Item(i).LegendRect.Right = m_Item(i).TextWidth
?1718:							m_Item(i).LegendRect.Bottom = m_Item(i).TextHeight
							'?"LegendRect", m_Item(i).LegendRect.Left, m_Item(i).LegendRect.Top
?1720:							
?1721:							With m_Item(i).LegendRect
								#ifdef __USE_GTK__
?1723:									cairo_set_source_rgba(cr, GetRedD(m_Item(i).ItemColor), GetGreenD(m_Item(i).ItemColor), GetBlueD(m_Item(i).ItemColor), 1)
?1724:									cairo_arc(cr, .Left + (m_Item(i).TextHeight / 2) / 2 - 0.5, .Top + m_Item(i).TextHeight / 4 + (m_Item(i).TextHeight / 2) / 2 - 0.5, m_Item(i).TextHeight / 2 / 2 - 0.5, 0, 2 * G_PI)
?1725:									cairo_fill(cr)
								#else
?1727:									GdipCreateSolidFill RGBtoARGB(m_Item(i).ItemColor, 100), Cast(GpSolidFill Ptr Ptr, @hBrush) '&hB0000000
?1728:									GdipFillEllipseI hGraphics, Cast(GpBrush Ptr, hBrush), .Left, .Top + m_Item(i).TextHeight / 4, m_Item(i).TextHeight / 2, m_Item(i).TextHeight / 2
?1729:									GdipDeleteBrush Cast(GpBrush Ptr, hBrush)
								#endif
?1731:							End With
?1732:							DrawText m_Item(i).ItemName, .Left + m_Item(i).TextHeight / 1.5, .Top, m_Item(i).TextWidth, m_Item(i).TextHeight, This.Font, lForeColor, cLeft, cMiddle
?1733:							TextHeight = TextHeight + m_Item(i).TextHeight
?1734:							.Top = .Top + m_Item(i).TextHeight
?1735:							
?1736:						End With
?1737:						
?1738:					Case LA_BOTTOM, LA_TOP
?1739:						With LabelsRect
?1740:							If .Left = 0 Then
?1741:								If ColRow = 1 Then
?1742:									.Left = MarginLeft + mWidth / 2 - .Right / 2
?1743:								Else
?1744:									.Left = MarginLeft
?1745:								End If
?1746:								If m_LegendAlign = LA_TOP Then
?1747:									.Top = PT16 + TitleSize.Height
?1748:								Else
?1749:									.Top = TopHeader + mHeight + TitleSize.Height - PT16 / 2
?1750:								End If
?1751:							End If
?1752:							
?1753:							If .Left + m_Item(i).TextWidth - MarginLeft > mWidth Then
?1754:								.Left = MarginLeft
?1755:								.Top = .Top + m_Item(i).TextHeight
?1756:							End If
?1757:							
							#ifdef __USE_GTK__
?1759:								cairo_set_source_rgba(cr, GetRedD(m_Item(i).ItemColor), GetGreenD(m_Item(i).ItemColor), GetBlueD(m_Item(i).ItemColor), 1)
?1760:								cairo_arc(cr, .Left + (m_Item(i).TextHeight / 2) / 2 - 0.5, .Top + m_Item(i).TextHeight / 4 + (m_Item(i).TextHeight / 2) / 2 - 0.5, m_Item(i).TextHeight / 2 / 2, 0, 2 * G_PI)
?1761:								cairo_fill(cr)
							#else
?1763:								GdipCreateSolidFill RGBtoARGB(m_Item(i).ItemColor, 100), Cast(GpSolidFill Ptr Ptr, @hBrush)
?1764:								GdipFillEllipseI hGraphics, Cast(GpBrush Ptr, hBrush), .Left, .Top + m_Item(i).TextHeight / 4, m_Item(i).TextHeight / 2, m_Item(i).TextHeight / 2
?1765:								GdipDeleteBrush Cast(GpBrush Ptr, hBrush)
							#endif
?1767:							m_Item(i).LegendRect.Left = .Left
?1768:							m_Item(i).LegendRect.Top = .Top
?1769:							m_Item(i).LegendRect.Right = m_Item(i).TextWidth
?1770:							m_Item(i).LegendRect.Bottom = m_Item(i).TextHeight
?1771:							
?1772:							DrawText m_Item(i).ItemName, .Left + m_Item(i).TextHeight / 1.5, .Top, m_Item(i).TextWidth, m_Item(i).TextHeight, This.Font, lForeColor, cLeft, cMiddle
?1773:							.Left = .Left + m_Item(i).TextWidth '+ M_ITEM(i).TextHeight / 1.5
?1774:						End With
?1775:					End Select
?1776:					
?1777:					
?1778:				Next
?1779:			End If
?1780:		Case CS_AREA
?1781:			
?1782:			Canvas.Font = This.Font
			'PT16 = 16 * nScale
?1784:			PT16 = (ScaleX(This.ClientWidth) + ScaleY(This.ClientHeight)) * 2.5 / 100
?1785:			
?1786:			PT24 = 24 * nScale
?1787:			mPenWidth = 1 * nScale
?1788:			LW = m_LinesWidth * nScale
?1789:			If LW < 1 Then LW = 1
?1790:			lForeColor = RGBtoARGB(FForeColor, 100)
?1791:			
			'If SerieCount > 1 Then BarSpace = LW * 4
?1793:			
?1794:			Max = IIf(m_AxisMax <> 0, m_AxisMax, GetMax())
?1795:			Min = IIf(m_AxisMin <> 0, m_AxisMin, GetMin())
?1796:			
?1797:			If m_AxisXVisible Then
?1798:				If cAxisItem <> 0 Then
?1799:					For i = 0 To cAxisItem->Count - 1
?1800:						TextWidth = ScaleX(Canvas.TextWidth(cAxisItem->Item(i))) * 1.3
?1801:						TextHeight = ScaleY(Canvas.TextHeight(cAxisItem->Item(i))) * 1.3
?1802:						If TextWidth > AxisX.Width Then AxisX.Width = TextWidth
?1803:						If TextHeight > AxisX.Height Then AxisX.Height = TextHeight
?1804:					Next
?1805:				End If
?1806:				
?1807:				If m_AxisAngle <> 0 Then
?1808:					With AxisX
?1809:						Select Case m_AxisAngle
						Case Is <= 90
?1811:							.Height = .Height + m_AxisAngle * (.Width - .Height) / 90
?1812:						Case Is < 180
?1813:							.Height = .Height + (180 - m_AxisAngle) * (.Width - .Height) / 90
?1814:						Case Is < 270
?1815:							.Height = .Height + (m_AxisAngle Mod 90) * (.Width - .Height) / 90
?1816:						Case Else
?1817:							.Height = .Height + (360 - m_AxisAngle) * (.Width - .Height) / 90
?1818:						End Select
?1819:					End With
?1820:				End If
?1821:			End If
?1822:			
?1823:			If m_AxisYVisible Then
?1824:				Value = IIf(Len(WStr(Max)) > Len(WStr(Min)), Max, Min)
?1825:				sDisplay = Replace(m_LabelsFormats, "{V}", WStr(Value))
?1826:				sDisplay = Replace(sDisplay, "{LF}", Chr(10))
?1827:				If Len(sDisplay) = 1 Then sDisplay = "0.9"
?1828:				AxisY.Width = ScaleX(Canvas.TextWidth(WStr(sDisplay))) * 1.5
?1829:				AxisY.Height = ScaleY(Canvas.TextHeight(WStr(sDisplay))) * 1.5
?1830:			End If
?1831:			
?1832:			
?1833:			If m_LegendVisible Then
?1834:				For i = 0 To SerieCount - 1
?1835:					m_Serie(i).TextHeight = ScaleY(Canvas.TextHeight(m_Serie(i).SerieName)) * 1.5
?1836:					m_Serie(i).TextWidth = ScaleX(Canvas.TextWidth(m_Serie(i).SerieName)) * 1.5 + m_Serie(i).TextHeight
?1837:				Next
?1838:			End If
?1839:			
?1840:			If Len(m_Title) Then
?1841:				GetTextSize(m_Title, ScaleX(This.ClientWidth), 0, m_TitleFont, True, TitleSize)
?1842:			End If
?1843:			
?1844:			MarginRight = PT16
?1845:			TopHeader = PT16 + TitleSize.Height
?1846:			MarginLeft = PT16 + AxisY.Width
?1847:			Footer = PT16 + AxisX.Height
?1848:			
?1849:			mWidth = ScaleX(This.ClientWidth) - MarginLeft - MarginRight
?1850:			mHeight = ScaleY(This.ClientHeight) - TopHeader - Footer
?1851:			
?1852:			If m_LegendVisible Then
?1853:				ColRow = 1
?1854:				Select Case m_LegendAlign
				Case LA_RIGHT, LA_LEFT
?1856:					With LabelsRect
?1857:						TextWidth = 0
?1858:						TextHeight = 0
?1859:						For i = 0 To SerieCount - 1
?1860:							If TextHeight + m_Serie(i).TextHeight > mHeight Then
?1861:								.Right = .Right + TextWidth
?1862:								ColRow = ColRow + 1
?1863:								TextWidth = 0
?1864:								TextHeight = 0
?1865:							End If
?1866:							
?1867:							TextHeight = TextHeight + m_Serie(i).TextHeight
?1868:							.Bottom = .Bottom + m_Serie(i).TextHeight
?1869:							
?1870:							If TextWidth < m_Serie(i).TextWidth Then
?1871:								TextWidth = m_Serie(i).TextWidth '+ PT16
?1872:							End If
?1873:						Next
?1874:						.Right = .Right + TextWidth
?1875:						If m_LegendAlign = LA_LEFT Then
?1876:							MarginLeft = MarginLeft + .Right
?1877:						Else
?1878:							MarginRight = MarginRight + .Right
?1879:						End If
?1880:						mWidth = mWidth - .Right
?1881:					End With
?1882:					
?1883:				Case LA_BOTTOM, LA_TOP
?1884:					With LabelsRect
?1885:						
?1886:						.Bottom = m_Serie(0).TextHeight + PT16 / 2
?1887:						TextWidth = 0
?1888:						For i = 0 To SerieCount - 1
?1889:							If TextWidth + m_Serie(i).TextWidth > mWidth Then
?1890:								.Bottom = .Bottom + m_Serie(i).TextHeight
?1891:								ColRow = ColRow + 1
?1892:								TextWidth = 0
?1893:							End If
?1894:							TextWidth = TextWidth + m_Serie(i).TextWidth
?1895:							.Right = .Right + m_Serie(i).TextWidth
?1896:						Next
?1897:						If m_LegendAlign = LA_TOP Then
?1898:							TopHeader = TopHeader + .Bottom
?1899:						End If
?1900:						mHeight = mHeight - .Bottom
?1901:					End With
?1902:				End Select
?1903:			End If
?1904:			
?1905:			If cAxisItem AndAlso cAxisItem->Count Then
?1906:				AxisDistance = (mWidth - mPenWidth) / (cAxisItem->Count - 1)
?1907:			End If
?1908:			
?1909:			If SerieCount > 0 Then
?1910:				PtDistance = (mWidth - mPenWidth) / (m_Serie(0).Values->Count - 1)
?1911:			End If
?1912:			
			'    If (m_ChartStyle = CS_StackedBars) Or (m_ChartStyle = CS_StackedBarsPercent) Then
			'        BarWidth = (PtDistance / 2)
			'    Else
			'        BarWidth = (PtDistance / (SerieCount + 0.5))
			'    End If
?1918:			
?1919:			
?1920:			NumDecim = 1
?1921:			
?1922:			If m_AxisMin Then forLines = m_AxisMin
?1923:			If m_AxisMax Then toLines = m_AxisMax
?1924:			
?1925:			
?1926:			nVal = Max + Abs(Min)
?1927:			
?1928:			Do While nVal > 9.5
?1929:				nVal = nVal / 9.99
?1930:				NumDecim = NumDecim * 10
?1931:			Loop
?1932:			
?1933:			Select Case nVal
			Case 0 To 1.999999
?1935:				iStep = 0.2
?1936:			Case 2 To 4.799999
?1937:				iStep = 0.5
?1938:			Case 4.8 To 9.599999
?1939:				iStep = 1
?1940:			End Select
?1941:			
?1942:			Dim nDec As Single
?1943:			nDec = 1
?1944:			Do
?1945:				If nDec * iStep * NumDecim > IIf(Max > Abs(Min), Max, Abs(Min)) * 3 Then Exit Do
?1946:				
?1947:				If Max > 0 Then
?1948:					If m_AxisMax = 0 Then
?1949:						toLines = CInt((Max / NumDecim + iStep) / iStep) * (iStep * NumDecim)
?1950:					End If
?1951:				End If
?1952:				
?1953:				If Min < 0 Then
?1954:					If m_AxisMin = 0 Then
?1955:						forLines = CInt((Min / (iStep * NumDecim)) - 1) * (iStep * NumDecim)
?1956:					End If
?1957:				End If
?1958:				
?1959:				RangeHeight = (mHeight / ((toLines + Abs(forLines)) / (iStep * NumDecim)))
?1960:				
?1961:				Exit Do
?1962:				If RangeHeight < AxisY.Height Then
?1963:					
?1964:					
?1965:					Select Case iStep
					Case Is = 0.2 * nDec: iStep = 0.5 * nDec
?1967:					Case Is = 0.5 * nDec: iStep = 1 * nDec
?1968:					Case Is = 1 * nDec: nDec = nDec * 10: iStep = 0.2 * nDec
?1969:					End Select
?1970:				Else
?1971:					Exit Do
?1972:				End If
?1973:			Loop
?1974:			
?1975:			
'			If GdipCreateFromHDC(hD, @hGraphics) = 0 Then
'				
'				GdipSetSmoothingMode(hGraphics, SmoothingModeAntiAlias)
'				GdipSetCompositingQuality(hGraphics, &H3) 'CompositingQualityGammaCorrected
'				
?1981:				Dim RectF_ As RectF
?1982:				With RectF_
?1983:					.Width = ScaleX(This.ClientWidth) - 1 * nScale
?1984:					.Height = ScaleY(This.ClientHeight) - 1 * nScale
?1985:				End With
?1986:				
?1987:				RoundRect RectF_, RGBtoARGB(FBackColor, m_BackColorOpacity), RGBtoARGB(m_BorderColor, 100), m_BorderRound * nScale, m_Border, m_BackColorOpacity
?1988:				
?1989:				
				'HORIZONTAL LINES AND vertical axis
				#ifdef __USE_GTK__
?1992:					Var PenColor = RGBtoARGB(m_LinesColor, 100)
?1993:					cairo_set_line_width(cr, mPenWidth)
				#else
?1995:					GdipCreatePen1(RGBtoARGB(m_LinesColor, 100), mPenWidth, &H2, @hPen)
				#endif
?1997:				
?1998:				YY = TopHeader + mHeight
?1999:				yRange = forLines
?2000:				
?2001:				If toLines = 0 And forLines = 0 Then toLines = 1
?2002:				RangeHeight = (mHeight / ((toLines + Abs(forLines)) / (iStep * NumDecim)))
?2003:				ZeroPoint = TopHeader + mHeight - RangeHeight * (Abs(forLines) / (iStep * NumDecim))
?2004:				
?2005:				For i = forLines / (iStep * NumDecim) To toLines / (iStep * NumDecim)
?2006:					If m_HorizontalLines Then
						#ifdef __USE_GTK__
?2008:							cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
?2009:							cairo_move_to(cr, MarginLeft, YY)
?2010:							cairo_line_to(cr, This.ClientWidth - MarginRight - mPenWidth, YY)
?2011:							cairo_stroke(cr)
						#else
?2013:							GdipDrawLine hGraphics, hPen, MarginLeft, YY, ScaleX(This.ClientWidth) - MarginRight - mPenWidth, YY
						#endif
?2015:					End If
?2016:					
?2017:					If m_AxisYVisible Then
?2018:						sDisplay = Replace(m_LabelsFormats, "{V}", WStr(yRange))
?2019:						sDisplay = Replace(sDisplay, "{LF}", Chr(10))
?2020:						DrawText sDisplay, 0, YY - RangeHeight / 2, MarginLeft - 8 * nScale, RangeHeight, This.Font, lForeColor, cRight, cMiddle
?2021:					End If
?2022:					YY = YY - RangeHeight
?2023:					yRange = yRange + CLng(iStep * NumDecim)
?2024:				Next
?2025:				
?2026:				If m_VerticalLines And SerieCount > 0 Then
?2027:					For i = 0 To m_Serie(0).Values->Count - 1
?2028:						XX = MarginLeft + PtDistance * i
						#ifdef __USE_GTK__
?2030:							cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
?2031:							cairo_move_to(cr, XX, TopHeader)
?2032:							cairo_line_to(cr, XX, TopHeader + mHeight + 4 * nScale)
?2033:							cairo_stroke(cr)
						#else
?2035:							GdipDrawLine hGraphics, hPen, XX, TopHeader, XX, TopHeader + mHeight + 4 * nScale
						#endif
?2037:					Next
?2038:				End If
?2039:				
				#ifndef __USE_GTK__
?2041:					GdipDeletePen hPen
				#endif
?2043:				
?2044:				For i = 0 To SerieCount - 1
					'Calculo
?2046:					ReDim (m_Serie(i).PT)(m_Serie(i).Values->Count - 1)
?2047:					
?2048:					For j = 0 To m_Serie(i).Values->Count - 1
?2049:						Value = m_Serie(i).Values->Item(j) ' + 1
?2050:						With m_Serie(i).PT(j)
?2051:							.X = MarginLeft + PtDistance * j
							'.Y = TopHeader + mHeight - (m_Serie(i).Values(j + 1) * (Max * mHeight / toLines) / Max)
?2053:							If Value >= 0 Then
?2054:								.Y = ZeroPoint - (Value * (ZeroPoint - TopHeader) / toLines)
?2055:							Else
?2056:								.Y = ZeroPoint + (Value * (TopHeader + mHeight - ZeroPoint) / forLines)
?2057:							End If
?2058:						End With
?2059:					Next
?2060:					
					'fill Line/Curve
?2062:					If m_FillOpacity > 0 Then
						#ifdef __USE_GTK__
?2064:							cairo_new_path(cr)
?2065:							If True Then
						#else
?2067:							If GdipCreatePath(&H0, @hPath) = 0 Then
						#endif
							#ifdef __USE_GTK__
								'cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
?2071:								cairo_move_to cr, MarginLeft, ZeroPoint
								'cairo_line_to cr, MarginLeft, ZeroPoint
							#else
?2074:								GdipAddPathLineI hPath, MarginLeft, ZeroPoint, MarginLeft, ZeroPoint
							#endif
?2076:							If m_LinesCurve Then
								#ifdef __USE_GTK__
									'cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
?2079:									cairo_line_to(cr, m_Serie(i).PT(0).X, m_Serie(i).PT(0).Y)
?2080:									For l As Integer = 1 To UBound(m_Serie(i).PT)
?2081:										Dim As Single Y
?2082:										If l Mod 2 = 1 Then
?2083:											If m_Serie(i).PT(l).Y > m_Serie(i).PT(l - 1).Y Then
?2084:												Y = IIf(m_Serie(i).PT(l - 1).Y > m_Serie(i).PT(l).Y, m_Serie(i).PT(l - 1).Y, m_Serie(i).PT(l).Y)
?2085:											Else
?2086:												Y = IIf(m_Serie(i).PT(l - 1).Y < m_Serie(i).PT(l).Y, m_Serie(i).PT(l - 1).Y, m_Serie(i).PT(l).Y)
?2087:											End If
?2088:										ElseIf l Mod 2 = 0 Then
?2089:											If m_Serie(i).PT(l).Y > m_Serie(i).PT(l - 1).Y Then
?2090:												Y = IIf(m_Serie(i).PT(l - 1).Y < m_Serie(i).PT(l).Y, m_Serie(i).PT(l - 1).Y, m_Serie(i).PT(l).Y)
?2091:											Else
?2092:												Y = IIf(m_Serie(i).PT(l - 1).Y > m_Serie(i).PT(l).Y, m_Serie(i).PT(l - 1).Y, m_Serie(i).PT(l).Y)
?2093:											End If
?2094:										End If
?2095:										cairo_curve_to cr, m_Serie(i).PT(l - 1).X, m_Serie(i).PT(l - 1).Y, (m_Serie(i).PT(l).X + m_Serie(i).PT(l - 1).X) / 2, Y, m_Serie(i).PT(l).X, m_Serie(i).PT(l).Y
?2096:									Next
								#else
?2098:									GdipAddPathCurveI hPath, Cast(GpPoint Ptr, @m_Serie(i).PT(0)), UBound(m_Serie(i).PT) + 1
								#endif
?2100:							Else
								#ifdef __USE_GTK__
									'cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
?2103:									cairo_line_to(cr, m_Serie(i).PT(0).X, m_Serie(i).PT(0).Y)
?2104:									For l As Integer = 1 To UBound(m_Serie(i).PT)
?2105:										cairo_line_to cr, m_Serie(i).PT(l).X, m_Serie(i).PT(l).Y
?2106:									Next
									'cairo_stroke(cr)
								#else
?2109:									GdipAddPathLine2I hPath, Cast(GpPoint Ptr, @m_Serie(i).PT(0)), UBound(m_Serie(i).PT) + 1
								#endif
?2111:							End If
							#ifdef __USE_GTK__
								'cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
								'cairo_move_to(cr, MarginLeft + mWidth - mPenWidth, ZeroPoint)
?2115:								cairo_line_to(cr, MarginLeft + mWidth - mPenWidth, ZeroPoint)
								'cairo_stroke(cr)
							#else
?2118:								GdipAddPathLineI hPath, MarginLeft + mWidth - mPenWidth, ZeroPoint, MarginLeft + mWidth - mPenWidth, ZeroPoint
							#endif
?2120:							
?2121:							Dim As ULong BrushColor
?2122:							If m_FillGradient Then
?2123:								With RectL_
?2124:									.Top = TopHeader
?2125:									
?2126:									.Right = mWidth
?2127:									.Bottom = ZeroPoint - TopHeader
?2128:								End With
								#ifdef __USE_GTK__
?2130:									BrushColor = RGBtoARGB(m_Serie(i).SerieColor, m_FillOpacity)
								#else
?2132:									GdipCreateLineBrushFromRectWithAngleI Cast(GpRect Ptr, @RectL_), RGBtoARGB(m_Serie(i).SerieColor, m_FillOpacity), RGBtoARGB(m_Serie(i).SerieColor, 10), 90, 0, WrapModeTileFlipXY, Cast(GpLineGradient Ptr Ptr, @hBrush)
								#endif
?2134:							Else
								#ifdef __USE_GTK__
?2136:									BrushColor = RGBtoARGB(m_Serie(i).SerieColor, m_FillOpacity)
								#else
?2138:									GdipCreateSolidFill RGBtoARGB(m_Serie(i).SerieColor, m_FillOpacity), Cast(GpSolidFill Ptr Ptr, @hBrush)
								#endif
?2140:							End If
?2141:							
							#ifdef __USE_GTK__
?2143:								cairo_close_path(cr)
?2144:								cairo_set_source_rgba(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor), m_FillOpacity / 100)
?2145:								cairo_fill(cr)
?2146:								
?2147:								cairo_new_path(cr)
							#else
?2149:								GdipFillPath hGraphics, hBrush, hPath
?2150:								GdipDeleteBrush hBrush
?2151:								
?2152:								GdipDeletePath hPath
							#endif
?2154:						End If
?2155:					End If
?2156:					
					'Draw Lines or Curve
?2158:					If mHotSerie = i Then LW = LW * 1.5 Else LW = m_LinesWidth * nScale
					#ifdef __USE_GTK__
?2160:						Var PenColor = RGBtoARGB(m_Serie(i).SerieColor, 100)
?2161:						cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
?2162:						cairo_set_line_width(cr, LW)
					#else
?2164:						GdipCreatePen1 RGBtoARGB(m_Serie(i).SerieColor, 100), LW, &H2, @hPen
					#endif
?2166:					If m_LinesCurve Then
						#ifdef __USE_GTK__
?2168:							cairo_move_to(cr, m_Serie(i).PT(0).X, m_Serie(i).PT(0).Y)
?2169:							For l As Integer = 1 To UBound(m_Serie(i).PT)
?2170:								Dim As Single Y
?2171:								If l Mod 2 = 1 Then
?2172:									If m_Serie(i).PT(l).Y > m_Serie(i).PT(l - 1).Y Then
?2173:										Y = IIf(m_Serie(i).PT(l - 1).Y > m_Serie(i).PT(l).Y, m_Serie(i).PT(l - 1).Y, m_Serie(i).PT(l).Y)
?2174:									Else
?2175:										Y = IIf(m_Serie(i).PT(l - 1).Y < m_Serie(i).PT(l).Y, m_Serie(i).PT(l - 1).Y, m_Serie(i).PT(l).Y)
?2176:									End If
?2177:								ElseIf l Mod 2 = 0 Then
?2178:									If m_Serie(i).PT(l).Y > m_Serie(i).PT(l - 1).Y Then
?2179:										Y = IIf(m_Serie(i).PT(l - 1).Y < m_Serie(i).PT(l).Y, m_Serie(i).PT(l - 1).Y, m_Serie(i).PT(l).Y)
?2180:									Else
?2181:										Y = IIf(m_Serie(i).PT(l - 1).Y > m_Serie(i).PT(l).Y, m_Serie(i).PT(l - 1).Y, m_Serie(i).PT(l).Y)
?2182:									End If
?2183:								End If
?2184:								cairo_curve_to cr, m_Serie(i).PT(l - 1).X, m_Serie(i).PT(l - 1).Y, (m_Serie(i).PT(l).X + m_Serie(i).PT(l - 1).X) / 2, Y, m_Serie(i).PT(l).X, m_Serie(i).PT(l).Y
?2185:							Next
?2186:							cairo_stroke(cr)
						#else
?2188:							GdipDrawCurveI hGraphics, hPen, Cast(GpPoint Ptr, @m_Serie(i).PT(0)), UBound(m_Serie(i).PT) + 1
						#endif
?2190:					Else
						#ifdef __USE_GTK__
?2192:							cairo_move_to(cr, m_Serie(i).PT(0).X, m_Serie(i).PT(0).Y)
?2193:							For l As Integer = 1 To UBound(m_Serie(i).PT)
?2194:								cairo_line_to cr, m_Serie(i).PT(l).X, m_Serie(i).PT(l).Y
?2195:							Next
?2196:							cairo_stroke(cr)
						#else
?2198:							GdipDrawLinesI hGraphics, hPen, Cast(GpPoint Ptr, @m_Serie(i).PT(0)), UBound(m_Serie(i).PT) + 1
						#endif
?2200:					End If
					#ifndef __USE_GTK__
?2202:						GdipDeletePen hPen
					#endif
?2204:					
?2205:					If m_LegendVisible Then
?2206:						Select Case m_LegendAlign
						Case LA_RIGHT, LA_LEFT
?2208:							With LabelsRect
?2209:								TextWidth = 0
?2210:								
?2211:								If .Left = 0 Then
?2212:									TextHeight = 0
?2213:									If m_LegendAlign = LA_LEFT Then
?2214:										.Left = PT16
?2215:									Else
?2216:										.Left = MarginLeft + mWidth + PT16
?2217:									End If
?2218:									If ColRow = 1 Then
?2219:										.Top = TopHeader + mHeight / 2 - .Bottom / 2
?2220:									Else
?2221:										.Top = TopHeader
?2222:									End If
?2223:								End If
?2224:								
?2225:								If TextWidth < m_Serie(i).TextWidth Then
?2226:									TextWidth = m_Serie(i).TextWidth '+ PT16
?2227:								End If
?2228:								
?2229:								If TextHeight + m_Serie(i).TextHeight > mHeight Then
?2230:									If i > 0 Then .Left = .Left + TextWidth
?2231:									.Top = TopHeader
?2232:									TextHeight = 0
?2233:								End If
?2234:								m_Serie(i).LegendRect.Left = .Left
?2235:								m_Serie(i).LegendRect.Top = .Top
?2236:								m_Serie(i).LegendRect.Right = m_Serie(i).TextWidth
?2237:								m_Serie(i).LegendRect.Bottom = m_Serie(i).TextHeight
?2238:								
								#ifdef __USE_GTK__
?2240:									Var BrushColor = RGBtoARGB(m_Serie(i).SerieColor, 100)
?2241:									cairo_set_source_rgb(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor))
?2242:									cairo_rectangle(cr, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2)
?2243:									cairo_fill(cr)
								#else
?2245:									GdipCreateSolidFill RGBtoARGB(m_Serie(i).SerieColor, 100), Cast(GpSolidFill Ptr Ptr, @hBrush)
?2246:									GdipFillRectangleI hGraphics, hBrush, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2
?2247:									GdipDeleteBrush hBrush
								#endif
?2249:								
?2250:								DrawText m_Serie(i).SerieName, .Left + m_Serie(i).TextHeight / 1.5, .Top, m_Serie(i).TextWidth, m_Serie(i).TextHeight, This.Font, lForeColor, cLeft, cMiddle
?2251:								TextHeight = TextHeight + m_Serie(i).TextHeight
?2252:								.Top = .Top + m_Serie(i).TextHeight
?2253:								
?2254:							End With
?2255:							
?2256:						Case LA_BOTTOM, LA_TOP
?2257:							With LabelsRect
?2258:								If .Left = 0 Then
?2259:									If ColRow = 1 Then
?2260:										.Left = MarginLeft + mWidth / 2 - .Right / 2
?2261:									Else
?2262:										.Left = MarginLeft
?2263:									End If
?2264:									If m_LegendAlign = LA_TOP Then
?2265:										.Top = PT16 + TitleSize.Height
?2266:									Else
?2267:										.Top = TopHeader + mHeight + TitleSize.Height + PT16 / 2
?2268:									End If
?2269:								End If
?2270:								
?2271:								If .Left + m_Serie(i).TextWidth - MarginLeft > mWidth Then
?2272:									.Left = MarginLeft
?2273:									.Top = .Top + m_Serie(i).TextHeight
?2274:								End If
?2275:								
								#ifdef __USE_GTK__
?2277:									Var BrushColor = RGBtoARGB(m_Serie(i).SerieColor, 100)
?2278:									cairo_set_source_rgb(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor))
?2279:									cairo_rectangle(cr, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2)
?2280:									cairo_fill(cr)
								#else
?2282:									GdipCreateSolidFill RGBtoARGB(m_Serie(i).SerieColor, 100), Cast(GpSolidFill Ptr Ptr, @hBrush)
?2283:									GdipFillRectangleI hGraphics, hBrush, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2
?2284:									GdipDeleteBrush hBrush
								#endif
?2286:								m_Serie(i).LegendRect.Left = .Left
?2287:								m_Serie(i).LegendRect.Top = .Top
?2288:								m_Serie(i).LegendRect.Right = m_Serie(i).TextWidth
?2289:								m_Serie(i).LegendRect.Bottom = m_Serie(i).TextHeight
?2290:								
?2291:								DrawText m_Serie(i).SerieName, .Left + m_Serie(i).TextHeight / 1.5, .Top, m_Serie(i).TextWidth, m_Serie(i).TextHeight, This.Font, lForeColor, cLeft, cMiddle
?2292:								.Left = .Left + m_Serie(i).TextWidth '+ m_Serie(i).TextHeight / 1.5
?2293:							End With
?2294:						End Select
?2295:					End If
?2296:					
?2297:					
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
?2311:					
?2312:					
					'Marck Colors
?2314:					Dim PTSZ As Single
?2315:					PTSZ = LW * 2
					'If mHotSerie = i Then PTSZ = LW * 1.2 Else PTSZ = LW * 1.2
					'If PTSZ < 3 * nScale Then PTSZ = 3 * nScale
?2318:					For j = 0 To m_Serie(i).Values->Count - 1
?2319:						If mHotBar = j Then
							#ifdef __USE_GTK__
?2321:								Var PenColor = RGBtoARGB(m_LinesColor, 100)
?2322:								cairo_set_line_width(cr, mPenWidth)
							#else
?2324:								GdipCreatePen1(RGBtoARGB(m_LinesColor, 100), mPenWidth, &H2, @hPen)
							#endif
?2326:							XX = MarginLeft + PtDistance * j
							#ifdef __USE_GTK__
?2328:								cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
?2329:								cairo_move_to(cr, XX, TopHeader)
?2330:								cairo_line_to(cr, XX, TopHeader + mHeight + 4 * nScale)
?2331:								cairo_stroke(cr)
							#else
?2333:								GdipDrawLine hGraphics, hPen, XX, TopHeader, XX, TopHeader + mHeight + 4 * nScale
?2334:								GdipDeletePen hPen
							#endif
?2336:						End If
?2337:						
?2338:						
?2339:						If mHotSerie = i Then
							#ifdef __USE_GTK__
?2341:								Var BrushColor = RGBtoARGB(m_Serie(i).SerieColor, 50)
?2342:								cairo_set_source_rgba(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor), 0.5)
?2343:								cairo_arc(cr, m_Serie(i).PT(j).X - PTSZ * 2 + PTSZ * 4 / 2 - 0.5, m_Serie(i).PT(j).Y - PTSZ * 2 + PTSZ * 4 / 2 - 0.5, PTSZ * 4 / 2, 0, 2 * G_PI)
?2344:								cairo_fill(cr)
							#else
?2346:								GdipCreateSolidFill RGBtoARGB(m_Serie(i).SerieColor, 50), Cast(GpSolidFill Ptr Ptr, @hBrush)
?2347:								GdipFillEllipseI hGraphics, hBrush, m_Serie(i).PT(j).X - PTSZ * 2, m_Serie(i).PT(j).Y - PTSZ * 2, PTSZ * 4, PTSZ * 4
?2348:								GdipDeleteBrush hBrush
							#endif
?2350:						End If
?2351:						
						#ifdef __USE_GTK__
?2353:							Var BrushColor = RGBtoARGB(m_Serie(i).SerieColor, 100)
?2354:							cairo_set_source_rgb(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor))
?2355:							cairo_arc(cr, m_Serie(i).PT(j).X - PTSZ + PTSZ * 2 / 2 - 0.5, m_Serie(i).PT(j).Y - PTSZ + PTSZ * 2 / 2 - 0.5, PTSZ * 2 / 2, 0, 2 * G_PI)
?2356:							cairo_fill(cr)
						#else
?2358:							GdipCreateSolidFill RGBtoARGB(m_Serie(i).SerieColor, 100), Cast(GpSolidFill Ptr Ptr, @hBrush)
?2359:							GdipFillEllipseI hGraphics, hBrush, m_Serie(i).PT(j).X - PTSZ, m_Serie(i).PT(j).Y - PTSZ, PTSZ * 2, PTSZ * 2
?2360:							
							'RectangleI hGraphics, hBrush, This.ClientWidth - MarginRight + MaxAxisHeight / 3, TopHeader + MaxAxisHeight * i + MaxAxisHeight / 4, MaxAxisHeight / 2, MaxAxisHeight / 2
?2362:							GdipDeleteBrush hBrush
						#endif
?2364:						
						#ifdef __USE_GTK__
?2366:							Var BrushColor1 = RGBtoARGB(FBackColor, 100 - m_FillOpacity)
?2367:							cairo_set_source_rgba(cr, GetRedD(BrushColor1), GetGreenD(BrushColor1), GetBlueD(BrushColor1), (100 - m_FillOpacity) / 100)
?2368:							cairo_arc(cr, m_Serie(i).PT(j).X - PTSZ + PTSZ * 2 / 2 - 0.5, m_Serie(i).PT(j).Y - PTSZ + PTSZ * 2 / 2 - 0.5, PTSZ * 2 / 2, 0, 2 * G_PI)
?2369:							cairo_stroke(cr)
						#else
?2371:							GdipCreatePen1(RGBtoARGB(FBackColor, 100 - m_FillOpacity), mPenWidth, &H2, @hPen)
?2372:							GdipDrawEllipseI hGraphics, hPen, m_Serie(i).PT(j).X - PTSZ, m_Serie(i).PT(j).Y - PTSZ, PTSZ * 2, PTSZ * 2
?2373:							GdipDeletePen hPen
						#endif
?2375:						
						'Serie Text
						'  DrawText hGraphics, m_Serie(i).SerieName, This.ClientWidth - MarginRight + MaxAxisHeight, TopHeader + MaxAxisHeight * i, MarginRight, MaxAxisHeight, This.Font, lForeColor, cLeft, cMiddle
?2378:					Next
?2379:				Next
?2380:				
				'Horizontal Axis
?2382:				If m_AxisXVisible Then
?2383:					If cAxisItem Then
?2384:						For i = 0 To cAxisItem->Count - 1
?2385:							XX = MarginLeft + AxisDistance * (i) - (AxisDistance / 2) ' - 1
?2386:							m_AxisAlign = cCenter
?2387:							DrawText cAxisItem->Item(i), XX, TopHeader + mHeight, AxisDistance, Footer, This.Font, lForeColor, m_AxisAlign, cMiddle, m_WordWrap, m_AxisAngle
?2388:						Next
?2389:					End If
?2390:				End If
?2391:				
			'End If
?2393:		Case CS_GroupedColumn To CS_StackedBarsPercent
?2394:			If m_ChartOrientation = CO_Vertical Then
?2395:				
				'PT16 = 16 * nScale
?2397:				PT16 = (ScaleX(This.ClientWidth) + ScaleY(This.ClientHeight)) * 2.5 / 100
?2398:				
?2399:				PT24 = 24 * nScale
?2400:				mPenWidth = 1 * nScale
?2401:				LW = m_LinesWidth * nScale
?2402:				lForeColor = RGBtoARGB(FForeColor, 100)
?2403:				
?2404:				If SerieCount > 1 Then BarSpace = LW * 4
?2405:				
?2406:				Max = IIf(m_AxisMax <> 0, m_AxisMax, GetMax())
?2407:				Min = IIf(m_AxisMin <> 0, m_AxisMin, GetMin())
?2408:				
?2409:				Canvas.Font = This.Font
?2410:				
?2411:				If m_AxisXVisible Then
?2412:					If cAxisItem Then
?2413:						For i = 0 To cAxisItem->Count - 1
?2414:							TextWidth = ScaleX(Canvas.TextWidth(cAxisItem->Item(i))) * 1.3
?2415:							TextHeight = ScaleY(Canvas.TextHeight(cAxisItem->Item(i))) * 1.3
?2416:							If TextWidth > AxisX.Width Then AxisX.Width = TextWidth
?2417:							If TextHeight > AxisX.Height Then AxisX.Height = TextHeight
?2418:						Next
?2419:					End If
?2420:					
?2421:					If m_AxisAngle <> 0 Then
?2422:						With AxisX
?2423:							Select Case m_AxisAngle
							Case Is <= 90
?2425:								.Height = .Height + m_AxisAngle * (.Width - .Height) / 90
?2426:							Case Is < 180
?2427:								.Height = .Height + (180 - m_AxisAngle) * (.Width - .Height) / 90
?2428:							Case Is < 270
?2429:								.Height = .Height + (m_AxisAngle Mod 90) * (.Width - .Height) / 90
?2430:							Case Else
?2431:								.Height = .Height + (360 - m_AxisAngle) * (.Width - .Height) / 90
?2432:							End Select
?2433:						End With
?2434:					End If
?2435:				End If
?2436:				
?2437:				If m_AxisYVisible Then
?2438:					Value = IIf(Len(WStr(Max)) > Len(WStr(Min)), Max, Min)
?2439:					sDisplay = Replace(m_LabelsFormats, "{V}", WStr(Value))
?2440:					sDisplay = Replace(sDisplay, "{LF}", Chr(10))
?2441:					If Len(sDisplay) = 1 Then sDisplay = "0.9"
?2442:					AxisY.Width = ScaleX(Canvas.TextWidth(WStr(sDisplay))) * 1.5
?2443:					AxisY.Height = ScaleY(Canvas.TextHeight(WStr(sDisplay))) * 1.5
?2444:				End If
?2445:				
?2446:				
?2447:				If m_LegendVisible Then
?2448:					For i = 0 To SerieCount - 1
?2449:						m_Serie(i).TextHeight = ScaleY(Canvas.TextHeight(m_Serie(i).SerieName)) * 1.5
?2450:						m_Serie(i).TextWidth = ScaleX(Canvas.TextWidth(m_Serie(i).SerieName)) * 1.5 + m_Serie(i).TextHeight
?2451:					Next
?2452:				End If
?2453:				
?2454:				If Len(m_Title) Then
?2455:					GetTextSize(m_Title, ScaleX(This.ClientWidth), 0, m_TitleFont, True, TitleSize)
?2456:				End If
?2457:				
?2458:				MarginRight = PT16
?2459:				TopHeader = PT16 + TitleSize.Height
?2460:				MarginLeft = PT16 + AxisY.Width
?2461:				Footer = PT16 + AxisX.Height
?2462:				
?2463:				mWidth = ScaleX(This.ClientWidth) - MarginLeft - MarginRight
?2464:				mHeight = ScaleY(This.ClientHeight) - TopHeader - Footer
?2465:				
?2466:				If m_LegendVisible Then
?2467:					ColRow = 1
?2468:					Select Case m_LegendAlign
					Case LA_RIGHT, LA_LEFT
?2470:						With LabelsRect
?2471:							TextWidth = 0
?2472:							TextHeight = 0
?2473:							For i = 0 To SerieCount - 1
?2474:								If TextHeight + m_Serie(i).TextHeight > mHeight Then
?2475:									.Right = .Right + TextWidth
?2476:									ColRow = ColRow + 1
?2477:									TextWidth = 0
?2478:									TextHeight = 0
?2479:								End If
?2480:								
?2481:								TextHeight = TextHeight + m_Serie(i).TextHeight
?2482:								.Bottom = .Bottom + m_Serie(i).TextHeight
?2483:								
?2484:								If TextWidth < m_Serie(i).TextWidth Then
?2485:									TextWidth = m_Serie(i).TextWidth '+ PT16
?2486:								End If
?2487:							Next
?2488:							.Right = .Right + TextWidth
?2489:							If m_LegendAlign = LA_LEFT Then
?2490:								MarginLeft = MarginLeft + .Right
?2491:							Else
?2492:								MarginRight = MarginRight + .Right
?2493:							End If
?2494:							mWidth = mWidth - .Right
?2495:						End With
?2496:						
?2497:					Case LA_BOTTOM, LA_TOP
?2498:						With LabelsRect
?2499:							
?2500:							.Bottom = m_Serie(0).TextHeight + PT16 / 2
?2501:							TextWidth = 0
?2502:							For i = 0 To SerieCount - 1
?2503:								If TextWidth + m_Serie(i).TextWidth > mWidth Then
?2504:									.Bottom = .Bottom + m_Serie(i).TextHeight
?2505:									ColRow = ColRow + 1
?2506:									TextWidth = 0
?2507:								End If
?2508:								TextWidth = TextWidth + m_Serie(i).TextWidth
?2509:								.Right = .Right + m_Serie(i).TextWidth
?2510:							Next
?2511:							If m_LegendAlign = LA_TOP Then
?2512:								TopHeader = TopHeader + .Bottom
?2513:							End If
?2514:							mHeight = mHeight - .Bottom
?2515:						End With
?2516:					End Select
?2517:				End If
?2518:				
?2519:				If cAxisItem AndAlso cAxisItem->Count Then
?2520:					AxisDistance = (mWidth - mPenWidth) / cAxisItem->Count
?2521:				End If
?2522:				
?2523:				If SerieCount > 0 Then
?2524:					PtDistance = (mWidth - mPenWidth) / m_Serie(0).Values->Count
?2525:				End If
?2526:				
?2527:				If (m_ChartStyle = CS_StackedBars) Or (m_ChartStyle = CS_StackedBarsPercent) Then
?2528:					BarWidth = (PtDistance / 2)
?2529:				Else
?2530:					BarWidth = (PtDistance / (SerieCount + 0.5))
?2531:				End If
?2532:				
?2533:				LineSpace = BarWidth * 20 / 100
?2534:				NumDecim = 1
?2535:				
?2536:				If m_AxisMin Then forLines = m_AxisMin
?2537:				If m_AxisMax Then toLines = m_AxisMax
?2538:				
?2539:				If m_ChartStyle = CS_StackedBarsPercent Then
?2540:					iStep = 10
?2541:					If Max > 0 Then toLines = 100
?2542:					If Min < 0 Then forLines = -100
?2543:					Do
?2544:						RangeHeight = (mHeight / ((toLines + Abs(forLines)) / (iStep * NumDecim)))
?2545:						
?2546:						If RangeHeight < AxisY.Height Then
?2547:							Select Case iStep
							Case Is = 10: iStep = 20
?2549:							Case Is = 20: iStep = 50
?2550:							Case Is = 50: iStep = 100: Exit Do
?2551:							End Select
?2552:						Else
?2553:							Exit Do
?2554:						End If
?2555:					Loop
?2556:				Else
?2557:					nVal = Max + Abs(Min)
?2558:					
?2559:					Do While nVal > 9.5
?2560:						nVal = nVal / 9.99
?2561:						NumDecim = NumDecim * 10
?2562:					Loop
?2563:					
?2564:					Select Case nVal
					Case 0 To 1.999999
?2566:						iStep = 0.2
?2567:					Case 2 To 4.799999
?2568:						iStep = 0.5
?2569:					Case 4.8 To 9.599999
?2570:						iStep = 1
?2571:					End Select
?2572:					
?2573:					Dim nDec As Single
?2574:					nDec = 1
?2575:					Do
?2576:						If nDec * iStep * NumDecim > IIf(Max > Abs(Min), Max, Abs(Min)) * 3 Then Exit Do
?2577:						
?2578:						If Max > 0 Then
?2579:							If m_AxisMax = 0 Then
?2580:								toLines = CInt((Max / NumDecim + iStep) / iStep) * (iStep * NumDecim)
?2581:							End If
?2582:						End If
?2583:						
?2584:						If Min < 0 Then
?2585:							If m_AxisMin = 0 Then
?2586:								forLines = CInt((Min / (iStep * NumDecim)) - 1) * (iStep * NumDecim)
?2587:							End If
?2588:						End If
?2589:						
?2590:						RangeHeight = (mHeight / ((toLines + Abs(forLines)) / (iStep * NumDecim)))
?2591:						
?2592:						Exit Do
?2593:						If RangeHeight < AxisY.Height Then
?2594:							
?2595:							
?2596:							Select Case iStep
							Case Is = 0.2 * nDec: iStep = 0.5 * nDec
?2598:							Case Is = 0.5 * nDec: iStep = 1 * nDec
?2599:							Case Is = 1 * nDec: nDec = nDec * 10: iStep = 0.2 * nDec
?2600:							End Select
?2601:						Else
?2602:							Exit Do
?2603:						End If
?2604:					Loop
?2605:				End If
?2606:				
?2607:				Dim RectF_ As RectF
?2608:				With RectF_
?2609:					.Width = ScaleX(This.ClientWidth) - 1 * nScale
?2610:					.Height = ScaleY(This.ClientHeight) - 1 * nScale
?2611:				End With
?2612:				
?2613:				RoundRect RectF_, RGBtoARGB(FBackColor, m_BackColorOpacity), RGBtoARGB(m_BorderColor, 100), m_BorderRound * nScale, m_Border, m_BackColorOpacity
?2614:				
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
?2628:				
				'HORIZONTAL LINES AND vertical axis
				#ifdef __USE_GTK__
?2631:					Var PenColor = RGBtoARGB(m_LinesColor, 100)
?2632:					cairo_set_line_width(cr, mPenWidth)
				#else
?2634:					GdipCreatePen1(RGBtoARGB(m_LinesColor, 100), mPenWidth, &H2, @hPen)
				#endif
?2636:				
?2637:				YY = TopHeader + mHeight
?2638:				yRange = forLines
?2639:				
?2640:				If toLines = 0 And forLines = 0 Then toLines = 1
?2641:				RangeHeight = (mHeight / ((toLines + Abs(forLines)) / (iStep * NumDecim)))
?2642:				ZeroPoint = TopHeader + mHeight - RangeHeight * (Abs(forLines) / (iStep * NumDecim))
?2643:				
?2644:				For i = forLines / (iStep * NumDecim) To toLines / (iStep * NumDecim)
?2645:					If m_HorizontalLines Then
						#ifdef __USE_GTK__
?2647:							cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
?2648:							cairo_move_to(cr, MarginLeft, YY)
?2649:							cairo_line_to(cr, This.ClientWidth - MarginRight - mPenWidth, YY)
						#else
?2651:							GdipDrawLine hGraphics, hPen, MarginLeft, YY, ScaleX(This.ClientWidth) - MarginRight - mPenWidth, YY
						#endif
?2653:					End If
?2654:					
?2655:					If m_AxisYVisible Then
?2656:						sDisplay = Replace(m_LabelsFormats, "{V}", WStr(yRange))
?2657:						sDisplay = Replace(sDisplay, "{LF}", Chr(10))
?2658:						DrawText sDisplay, 0, YY - RangeHeight / 2, MarginLeft - 8 * nScale, RangeHeight, This.Font, lForeColor, cRight, cMiddle
?2659:					End If
?2660:					YY = YY - RangeHeight
?2661:					yRange = yRange + (iStep * NumDecim) 'CLng(iStep * NumDecim)
?2662:				Next
?2663:				
?2664:				If m_VerticalLines And SerieCount > 0 Then
?2665:					For i = 0 To m_Serie(0).Values->Count - 1
?2666:						XX = MarginLeft + PtDistance * i
						#ifdef __USE_GTK__
?2668:							cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
?2669:							cairo_move_to(cr, XX, TopHeader)
?2670:							cairo_line_to(cr, XX, TopHeader + mHeight + 4 * nScale)
						#else
?2672:							GdipDrawLine hGraphics, hPen, XX, TopHeader, XX, TopHeader + mHeight + 4 * nScale
						#endif
?2674:					Next
?2675:				End If
?2676:				
				#ifndef __USE_GTK__
?2678:					GdipDeletePen hPen
				#endif
?2680:				
?2681:				If ((m_ChartStyle = CS_StackedBars) Or (m_ChartStyle = CS_StackedBarsPercent)) And SerieCount > 0 Then
?2682:					ReDim LastPositive(m_Serie(0).Values->Count - 1)
?2683:					ReDim LastNegative(m_Serie(0).Values->Count - 1)
?2684:					For i = 0 To m_Serie(0).Values->Count - 1
?2685:						LastPositive(i) = ZeroPoint
?2686:						LastNegative(i) = ZeroPoint
?2687:					Next
?2688:				End If
?2689:				
?2690:				For i = 0 To SerieCount - 1
					'Calculo
?2692:					ReDim (m_Serie(i).Rects)(m_Serie(i).Values->Count - 1)
?2693:					If (m_ChartStyle = CS_StackedBars) Or (m_ChartStyle = CS_StackedBarsPercent) Then
?2694:						
?2695:						If m_ChartStyle = CS_StackedBarsPercent Then
?2696:							For j = 0 To m_Serie(i).Values->Count - 1
?2697:								Max = SumSerieValues(j, True) ' + 1
?2698:								Value = m_Serie(i).Values->Item(j) ' + 1
?2699:								
?2700:								With m_Serie(i).Rects(j)
?2701:									.Left = MarginLeft + PtDistance * j + BarWidth / 2
?2702:									
?2703:									If Value >= 0 Then
?2704:										.Bottom = (Value * (ZeroPoint - TopHeader) / Max)
?2705:										.Top = LastPositive(j) - .Bottom
?2706:										LastPositive(j) = .Top
?2707:									Else
?2708:										.Top = LastNegative(j)
?2709:										.Bottom = (Abs(Value) * (TopHeader + mHeight - ZeroPoint) / Max)
?2710:										LastNegative(j) = .Top + .Bottom
?2711:									End If
?2712:									
?2713:									.Right = BarWidth
?2714:								End With
?2715:								
?2716:							Next
?2717:						Else
?2718:							
?2719:							For j = 0 To m_Serie(i).Values->Count - 1
?2720:								Value = m_Serie(i).Values->Item(j) ' + 1
?2721:								
?2722:								With m_Serie(i).Rects(j)
?2723:									.Left = MarginLeft + PtDistance * j + BarWidth / 2
?2724:									If Value >= 0 Then
?2725:										.Bottom = (Value * (Max * (ZeroPoint - TopHeader) / toLines) / Max)
?2726:										.Top = LastPositive(j) - .Bottom
?2727:										LastPositive(j) = .Top
?2728:									Else
?2729:										.Top = LastNegative(j)
?2730:										.Bottom = (Value * (Min * (TopHeader + mHeight - ZeroPoint) / forLines) / Min)
?2731:										LastNegative(j) = .Top + .Bottom
?2732:									End If
?2733:									.Right = BarWidth
?2734:								End With
?2735:							Next
?2736:						End If
?2737:					Else
?2738:						For j = 0 To m_Serie(i).Values->Count - 1
?2739:							Value = m_Serie(i).Values->Item(j) ' + 1
?2740:							With m_Serie(i).Rects(j)
?2741:								.Left = MarginLeft + PtDistance * j + BarWidth / 4 + BarWidth * i + BarSpace / 2
?2742:								If Value >= 0 Then
?2743:									.Top = ZeroPoint - (Value * (ZeroPoint - TopHeader) / toLines)
?2744:									.Bottom = ZeroPoint - .Top
?2745:								Else
?2746:									.Top = ZeroPoint
?2747:									.Bottom = (Value * (TopHeader + mHeight - ZeroPoint) / forLines)
?2748:								End If
?2749:								.Right = BarWidth - BarSpace
?2750:							End With
?2751:						Next
?2752:					End If
?2753:					
?2754:					
?2755:					With RectL_
?2756:						.Top = TopHeader
?2757:						.Right = ScaleX(This.ClientWidth)
?2758:						.Bottom = ScaleY(This.ClientHeight)
?2759:					End With
?2760:					
?2761:					For j = 0 To UBound(m_Serie(i).Rects)
?2762:						
?2763:						If Not m_Serie(i).CustomColors = 0 Then
?2764:							lColor = m_Serie(i).CustomColors->Item(j) ' + 1
?2765:						Else
?2766:							lColor = m_Serie(i).SerieColor
?2767:						End If
?2768:						
?2769:						Dim As ULong PenColor
?2770:						If i = mHotSerie And (mHotBar = j Or mHotBar = -1) Then
							#ifdef __USE_GTK__
?2772:								PenColor = RGBtoARGB(lColor, 100)
?2773:								cairo_set_line_width(cr, LW * 2)
							#else
?2775:								GdipCreatePen1 RGBtoARGB(lColor, 100), LW * 2, &H2, @hPen
							#endif
?2777:							lColor = ShiftColor(lColor, clWhite, 90)
?2778:						Else
							#ifdef __USE_GTK__
?2780:								PenColor = RGBtoARGB(lColor, 100)
?2781:								cairo_set_line_width(cr, LW)
							#else
?2783:								GdipCreatePen1 RGBtoARGB(lColor, 100), LW, &H2, @hPen
							#endif
?2785:						End If
?2786:						
?2787:						Dim As ULong BrushColor
?2788:						If m_FillGradient Then
							#ifdef __USE_GTK__
?2790:								BrushColor = RGBtoARGB(lColor, m_FillOpacity)
							#else
?2792:								GdipCreateLineBrushFromRectWithAngleI Cast(GpRect Ptr, @RectL_), RGBtoARGB(lColor, m_FillOpacity), RGBtoARGB(clWhite, IIf(m_FillOpacity < 100, 0, 100)), 90, 0, WrapModeTile, Cast(GpLineGradient Ptr Ptr, @hBrush)
							#endif
?2794:						Else
							#ifdef __USE_GTK__
?2796:								BrushColor = RGBtoARGB(lColor, m_FillOpacity)
							#else
?2798:								GdipCreateSolidFill RGBtoARGB(lColor, m_FillOpacity), Cast(GpSolidFill Ptr Ptr, @hBrush)
							#endif
?2800:						End If
?2801:						
?2802:						With m_Serie(i).Rects(j)
							#ifdef __USE_GTK__
?2804:								cairo_set_source_rgba(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor), m_FillOpacity / 100)
?2805:								cairo_rectangle(cr, .Left, .Top, .Right, .Bottom)
?2806:								cairo_fill(cr)
?2807:								cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
?2808:								cairo_rectangle(cr, .Left, .Top, .Right, .Bottom)
?2809:								cairo_stroke(cr)
							#else
?2811:								GdipFillRectangleI hGraphics, hBrush, .Left, .Top, .Right, .Bottom
?2812:								GdipDrawRectangleI hGraphics, hPen, .Left, .Top, .Right, .Bottom
							#endif
?2814:						End With
?2815:						
						#ifndef __USE_GTK__
?2817:							GdipDeleteBrush hBrush
?2818:							GdipDeletePen hPen
						#endif
?2820:					Next
?2821:					
?2822:					
?2823:					If m_LegendVisible Then
?2824:						Select Case m_LegendAlign
						Case LA_RIGHT, LA_LEFT
?2826:							With LabelsRect
?2827:								TextWidth = 0
?2828:								
?2829:								If .Left = 0 Then
?2830:									TextHeight = 0
?2831:									If m_LegendAlign = LA_LEFT Then
?2832:										.Left = PT16
?2833:									Else
?2834:										.Left = MarginLeft + mWidth + PT16
?2835:									End If
?2836:									If ColRow = 1 Then
?2837:										.Top = TopHeader + mHeight / 2 - .Bottom / 2
?2838:									Else
?2839:										.Top = TopHeader
?2840:									End If
?2841:								End If
?2842:								
?2843:								If TextWidth < m_Serie(i).TextWidth Then
?2844:									TextWidth = m_Serie(i).TextWidth '+ PT16
?2845:								End If
?2846:								
?2847:								If TextHeight + m_Serie(i).TextHeight > mHeight Then
?2848:									If i > 0 Then .Left = .Left + TextWidth
?2849:									.Top = TopHeader
?2850:									TextHeight = 0
?2851:								End If
?2852:								m_Serie(i).LegendRect.Left = .Left
?2853:								m_Serie(i).LegendRect.Top = .Top
?2854:								m_Serie(i).LegendRect.Right = m_Serie(i).TextWidth
?2855:								m_Serie(i).LegendRect.Bottom = m_Serie(i).TextHeight
?2856:								
								#ifdef __USE_GTK__
?2858:									Var BrushColor = RGBtoARGB(m_Serie(i).SerieColor, 100)
?2859:									cairo_set_source_rgb(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor))
?2860:									cairo_rectangle(cr, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2)
?2861:									cairo_fill(cr)
								#else
?2863:									GdipCreateSolidFill RGBtoARGB(m_Serie(i).SerieColor, 100), Cast(GpSolidFill Ptr Ptr, @hBrush)
?2864:									GdipFillRectangleI hGraphics, hBrush, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2
?2865:									GdipDeleteBrush hBrush
								#endif
?2867:								
?2868:								DrawText m_Serie(i).SerieName, .Left + m_Serie(i).TextHeight / 1.5, .Top, m_Serie(i).TextWidth, m_Serie(i).TextHeight, This.Font, lForeColor, cLeft, cMiddle
?2869:								TextHeight = TextHeight + m_Serie(i).TextHeight
?2870:								.Top = .Top + m_Serie(i).TextHeight
?2871:								
?2872:							End With
?2873:							
?2874:						Case LA_BOTTOM, LA_TOP
?2875:							With LabelsRect
?2876:								If .Left = 0 Then
?2877:									If ColRow = 1 Then
?2878:										.Left = MarginLeft + mWidth / 2 - .Right / 2
?2879:									Else
?2880:										.Left = MarginLeft
?2881:									End If
?2882:									If m_LegendAlign = LA_TOP Then
?2883:										.Top = PT16 + TitleSize.Height
?2884:									Else
?2885:										.Top = TopHeader + mHeight + TitleSize.Height + PT16 / 2
?2886:									End If
?2887:								End If
?2888:								
?2889:								If .Left + m_Serie(i).TextWidth - MarginLeft > mWidth Then
?2890:									.Left = MarginLeft
?2891:									.Top = .Top + m_Serie(i).TextHeight
?2892:								End If
?2893:								
								#ifdef __USE_GTK__
?2895:									Var BrushColor = RGBtoARGB(m_Serie(i).SerieColor, 100)
?2896:									cairo_set_source_rgb(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor))
?2897:									cairo_rectangle(cr, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2)
?2898:									cairo_fill(cr)
								#else
?2900:									GdipCreateSolidFill RGBtoARGB(m_Serie(i).SerieColor, 100), Cast(GpSolidFill Ptr Ptr, @hBrush)
?2901:									GdipFillRectangleI hGraphics, hBrush, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2
?2902:									GdipDeleteBrush hBrush
								#endif
?2904:								m_Serie(i).LegendRect.Left = .Left
?2905:								m_Serie(i).LegendRect.Top = .Top
?2906:								m_Serie(i).LegendRect.Right = m_Serie(i).TextWidth
?2907:								m_Serie(i).LegendRect.Bottom = m_Serie(i).TextHeight
?2908:								
?2909:								DrawText m_Serie(i).SerieName, .Left + m_Serie(i).TextHeight / 1.5, .Top, m_Serie(i).TextWidth, m_Serie(i).TextHeight, This.Font, lForeColor, cLeft, cMiddle
?2910:								.Left = .Left + m_Serie(i).TextWidth '+ m_Serie(i).TextHeight / 1.5
?2911:							End With
?2912:						End Select
?2913:					End If
?2914:					
?2915:				Next
?2916:				
?2917:				
?2918:				If m_LabelsVisible Then
?2919:					For i = 0 To SerieCount - 1
?2920:						For j = 0 To m_Serie(i).Values->Count - 1
?2921:							mRect = m_Serie(i).Rects(j)
?2922:							With mRect
?2923:								sDisplay = Replace(m_LabelsFormats, "{V}", FormatLabel(m_Serie(i).Values->Item(j), m_LabelsFormat)) ' + 1
?2924:								sDisplay = Replace(sDisplay, "{LF}", Chr(10))
?2925:								TextHeight = ScaleY(Canvas.TextHeight(sDisplay)) * 1.3
?2926:								TextWidth = ScaleX(Canvas.TextWidth(sDisplay)) * 1.5
?2927:								If (TextHeight > .Bottom Or m_LabelsPositions = LP_Outside) And m_ChartStyle = CS_GroupedColumn Then
?2928:									.Top = .Top - TextHeight
?2929:									.Bottom = TextHeight
?2930:									lColor = RGBtoARGB(m_Serie(i).SerieColor, 100)
?2931:								Else
?2932:									If Not m_Serie(i).CustomColors = 0 Then
?2933:										lColor = m_Serie(i).CustomColors->Item(j)
?2934:									Else
?2935:										lColor = FForeColor
?2936:									End If
?2937:									If IsDarkColor(lColor) Then
?2938:										lColor = RGBtoARGB(clWhite, 100)
?2939:									Else
?2940:										lColor = RGBtoARGB(clBlack, 100)
?2941:									End If
?2942:								End If
?2943:								
?2944:								If TextWidth > .Right Then
?2945:									.Left = .Left + .Right / 2 - TextWidth / 2
?2946:									.Right = TextWidth
?2947:								End If
?2948:								
?2949:								
?2950:								DrawText sDisplay, .Left, .Top, .Right, .Bottom, This.Font, lColor, cCenter, m_LabelsAlignments
?2951:							End With
?2952:						Next
?2953:					Next
?2954:				End If
?2955:				
				'a line to overlap the base of the rectangle
?2957:				
				#ifdef __USE_GTK__
?2959:					Var PenColor1 = RGBtoARGB(m_LinesColor, 100)
?2960:					cairo_set_line_width(cr, LW)
?2961:					cairo_set_source_rgb(cr, GetRedD(PenColor1), GetGreenD(PenColor1), GetBlueD(PenColor1))
?2962:					cairo_move_to(cr, MarginLeft, ZeroPoint)
?2963:					cairo_line_to(cr, This.ClientWidth - MarginRight - mPenWidth, ZeroPoint)
?2964:					cairo_stroke(cr)
				#else
?2966:					GdipCreatePen1(RGBtoARGB(m_LinesColor, 100), LW, &H2, @hPen)
?2967:					GdipDrawLine hGraphics, hPen, MarginLeft, ZeroPoint, ScaleX(This.ClientWidth) - MarginRight - mPenWidth, ZeroPoint
?2968:					GdipDeletePen hPen
				#endif
?2970:				
				'*-
				'Horizontal Axis
?2973:				If m_AxisXVisible Then
?2974:					If cAxisItem Then
?2975:						For i = 0 To cAxisItem->Count - 1
?2976:							XX = MarginLeft + AxisDistance * (i) ' - 1
?2977:							DrawText cAxisItem->Item(i), XX, TopHeader + mHeight, AxisDistance, Footer, This.Font, lForeColor, m_AxisAlign, cMiddle, m_WordWrap, m_AxisAngle
?2978:						Next
?2979:					End If
?2980:				End If
?2981:				
?2982:			Else
?2983:				
				'PT16 = 16 * nScale
?2985:				PT16 = (ScaleX(This.ClientWidth) + ScaleY(This.ClientHeight)) * 2.5 / 100
?2986:				
?2987:				PT24 = 24 * nScale
?2988:				mPenWidth = 1 * nScale
?2989:				LW = m_LinesWidth * nScale
?2990:				lForeColor = RGBtoARGB(FForeColor, 100)
?2991:				If SerieCount > 1 Then BarSpace = LW * 4
?2992:				
?2993:				Max = IIf(m_AxisMax <> 0, m_AxisMax, GetMax())
?2994:				Min = IIf(m_AxisMin <> 0, m_AxisMin, GetMin())
?2995:				
?2996:				Canvas.Font = This.Font
?2997:				
?2998:				If m_AxisYVisible Then
?2999:					For i = 0 To cAxisItem->Count - 1
?3000:						TextWidth = ScaleX(Canvas.TextWidth(cAxisItem->Item(i))) * 1.3
?3001:						TextHeight = ScaleY(Canvas.TextHeight(cAxisItem->Item(i))) * 1.5
?3002:						If TextWidth > AxisY.Width Then AxisY.Width = TextWidth
?3003:						If TextHeight > AxisY.Height Then AxisY.Height = TextHeight
?3004:					Next
?3005:					
?3006:					If m_AxisAngle <> 0 Then
?3007:						With AxisY
?3008:							Select Case m_AxisAngle
							Case Is <= 90
?3010:								.Width = .Width + m_AxisAngle * (.Height - .Width) / 90
?3011:							Case Is < 180
?3012:								.Width = .Width + (180 - m_AxisAngle) * (.Height - .Width) / 90
?3013:							Case Is < 270
?3014:								.Width = .Width + (m_AxisAngle Mod 90) * (.Height - .Width) / 90
?3015:							Case Else
?3016:								.Width = .Width + (360 - m_AxisAngle) * (.Height - .Width) / 90
?3017:							End Select
?3018:						End With
?3019:					End If
?3020:				End If
?3021:				
?3022:				If m_AxisXVisible Then
?3023:					Value = IIf(Len(WStr(Max)) > Len(WStr(Min)), Max, Min)
?3024:					sDisplay = Replace(m_LabelsFormats, "{V}", WStr(Value))
?3025:					sDisplay = Replace(sDisplay, "{LF}", Chr(10))
?3026:					AxisX.Width = ScaleX(Canvas.TextWidth(WStr(sDisplay))) * 1.5
?3027:					AxisX.Height = ScaleY(Canvas.TextHeight(WStr(sDisplay))) * 1.5
?3028:				End If
?3029:				
?3030:				If m_LegendVisible Then
?3031:					For i = 0 To SerieCount - 1
?3032:						m_Serie(i).TextHeight = ScaleX(Canvas.TextHeight(m_Serie(i).SerieName)) * 1.5
?3033:						m_Serie(i).TextWidth = ScaleY(Canvas.TextWidth(m_Serie(i).SerieName)) * 1.5 + m_Serie(i).TextHeight
?3034:					Next
?3035:				End If
?3036:				
?3037:				If Len(m_Title) Then
?3038:					GetTextSize(m_Title, ScaleX(This.ClientWidth), 0, m_TitleFont, True, TitleSize)
?3039:				End If
?3040:				
?3041:				MarginRight = PT16
?3042:				TopHeader = PT16 + TitleSize.Height
?3043:				MarginLeft = PT16 + AxisY.Width
?3044:				Footer = PT16 + AxisX.Height
?3045:				
?3046:				mWidth = ScaleX(This.ClientWidth) - MarginLeft - MarginRight
?3047:				mHeight = ScaleY(This.ClientHeight) - TopHeader - Footer
?3048:				
?3049:				If m_LegendVisible Then
?3050:					ColRow = 1
?3051:					Select Case m_LegendAlign
					Case LA_RIGHT, LA_LEFT
?3053:						With LabelsRect
?3054:							TextWidth = 0
?3055:							TextHeight = 0
?3056:							For i = 0 To SerieCount - 1
?3057:								If TextHeight + m_Serie(i).TextHeight > mHeight Then
?3058:									.Right = .Right + TextWidth
?3059:									ColRow = ColRow + 1
?3060:									TextWidth = 0
?3061:									TextHeight = 0
?3062:								End If
?3063:								
?3064:								TextHeight = TextHeight + m_Serie(i).TextHeight
?3065:								.Bottom = .Bottom + m_Serie(i).TextHeight
?3066:								
?3067:								If TextWidth < m_Serie(i).TextWidth Then
?3068:									TextWidth = m_Serie(i).TextWidth '+ PT16
?3069:								End If
?3070:							Next
?3071:							.Right = .Right + TextWidth
?3072:							If m_LegendAlign = LA_LEFT Then
?3073:								MarginLeft = MarginLeft + .Right
?3074:							Else
?3075:								MarginRight = MarginRight + .Right
?3076:							End If
?3077:							mWidth = mWidth - .Right
?3078:						End With
?3079:						
?3080:					Case LA_BOTTOM, LA_TOP
?3081:						With LabelsRect
?3082:							
?3083:							.Bottom = m_Serie(0).TextHeight + PT16 / 2
?3084:							TextWidth = 0
?3085:							For i = 0 To SerieCount - 1
?3086:								If TextWidth + m_Serie(i).TextWidth > mWidth Then
?3087:									.Bottom = .Bottom + m_Serie(i).TextHeight
?3088:									ColRow = ColRow + 1
?3089:									TextWidth = 0
?3090:								End If
?3091:								TextWidth = TextWidth + m_Serie(i).TextWidth
?3092:								.Right = .Right + m_Serie(i).TextWidth
?3093:							Next
?3094:							If m_LegendAlign = LA_TOP Then
?3095:								TopHeader = TopHeader + .Bottom
?3096:							End If
?3097:							mHeight = mHeight - .Bottom
?3098:						End With
?3099:					End Select
?3100:				End If
?3101:				
?3102:				If cAxisItem AndAlso cAxisItem->Count Then
?3103:					AxisDistance = (mHeight - mPenWidth) / cAxisItem->Count
?3104:				End If
?3105:				
?3106:				If SerieCount > 0 Then
?3107:					PtDistance = (mHeight - mPenWidth) / m_Serie(0).Values->Count
?3108:				End If
?3109:				
?3110:				If (m_ChartStyle = CS_StackedBars) Or (m_ChartStyle = CS_StackedBarsPercent) Then
?3111:					BarWidth = (PtDistance / 2)
?3112:				Else
?3113:					BarWidth = (PtDistance / (SerieCount + 0.5))
?3114:				End If
?3115:				
?3116:				LineSpace = BarWidth * 20 / 100
?3117:				NumDecim = 1
?3118:				
?3119:				If m_AxisMin Then forLines = m_AxisMin
?3120:				If m_AxisMax Then toLines = m_AxisMax
?3121:				
?3122:				If m_ChartStyle = CS_StackedBarsPercent Then
?3123:					iStep = 10
?3124:					
?3125:					If Max > 0 Then toLines = 100
?3126:					If Min < 0 Then forLines = -100
?3127:					Do
?3128:						RangeHeight = (mWidth / ((toLines + Abs(forLines)) / (iStep * NumDecim)))
?3129:						If RangeHeight < AxisX.Width Then
?3130:							Select Case iStep
							Case Is = 10: iStep = 20
?3132:							Case Is = 20: iStep = 50
?3133:							Case Is = 50: iStep = 100: Exit Do
?3134:							End Select
?3135:						Else
?3136:							Exit Do
?3137:						End If
?3138:					Loop
?3139:				Else
?3140:					nVal = Max + Abs(Min)
?3141:					
?3142:					Do While nVal > 9.5
?3143:						nVal = nVal / 9.99
?3144:						NumDecim = NumDecim * 10
?3145:					Loop
?3146:					
?3147:					Select Case nVal
					Case 0 To 1.999999
?3149:						iStep = 0.2
?3150:					Case 2 To 4.799999
?3151:						iStep = 0.5
?3152:					Case 4.8 To 9.599999
?3153:						iStep = 1
?3154:					End Select
?3155:					
?3156:					Dim nDec As Single
?3157:					nDec = 1
?3158:					Do
?3159:						If nDec * iStep * NumDecim > IIf(Max > Abs(Min), Max, Abs(Min)) Then Exit Do
?3160:						
?3161:						If Max > 0 Then
?3162:							If m_AxisMax = 0 Then
?3163:								toLines = CInt((Max / NumDecim + iStep) / iStep) * (iStep * NumDecim)
?3164:							End If
?3165:						End If
?3166:						
?3167:						If Min < 0 Then
?3168:							If m_AxisMin = 0 Then
?3169:								forLines = CInt((Min / (iStep * NumDecim)) - 1) * (iStep * NumDecim)
?3170:							End If
?3171:						End If
?3172:						
?3173:						RangeHeight = (mWidth / ((toLines + Abs(forLines)) / (iStep * NumDecim)))
?3174:						
?3175:						Exit Do
?3176:						
?3177:						If RangeHeight < AxisX.Width Then
?3178:							
?3179:							
?3180:							Select Case iStep
							Case Is = 0.2 * nDec: iStep = 0.5 * nDec
?3182:							Case Is = 0.5 * nDec: iStep = 1 * nDec
?3183:							Case Is = 1 * nDec: nDec = nDec * 10: iStep = 0.2 * nDec
?3184:							End Select
?3185:						Else
?3186:							Exit Do
?3187:						End If
?3188:					Loop
?3189:					
?3190:				End If
?3191:				
?3192:				Dim RectF_ As RectF
?3193:				With RectF_
?3194:					.Width = ScaleX(This.ClientWidth) - 1 * nScale
?3195:					.Height = ScaleY(This.ClientHeight) - 1 * nScale
?3196:				End With
?3197:				RoundRect RectF_, RGBtoARGB(FBackColor, m_BackColorOpacity), RGBtoARGB(m_BorderColor, 100), m_BorderRound * nScale, m_Border, m_BackColorOpacity
?3198:				
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
?3212:				
				'vertical LINES AND vertical axis
				#ifdef __USE_GTK__
?3215:					Var PenColor = RGBtoARGB(m_LinesColor, 100)
?3216:					cairo_set_line_width(cr, mPenWidth)
				#else
?3218:					GdipCreatePen1(RGBtoARGB(m_LinesColor, 100), mPenWidth, &H2, @hPen)
				#endif
?3220:				
?3221:				YY = TopHeader + mHeight
?3222:				XX = MarginLeft
?3223:				yRange = forLines
?3224:				If toLines = 0 And forLines = 0 Then toLines = 1
?3225:				
?3226:				RangeHeight = (mWidth / ((toLines + Abs(forLines)) / (iStep * NumDecim)))
?3227:				
?3228:				ZeroPoint = MarginLeft + RangeHeight * (Abs(forLines) / (iStep * NumDecim))
?3229:				
?3230:				For i = forLines / (iStep * NumDecim) To toLines / (iStep * NumDecim)
?3231:					If m_VerticalLines Then
						#ifdef __USE_GTK__
?3233:							cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
?3234:							cairo_move_to(cr, XX, TopHeader)
?3235:							cairo_line_to(cr, XX, TopHeader + mHeight - mPenWidth)
?3236:							cairo_stroke(cr)
						#else
?3238:							GdipDrawLine hGraphics, hPen, XX, TopHeader, XX, TopHeader + mHeight - mPenWidth
						#endif
?3240:					End If
?3241:					
?3242:					If m_AxisXVisible Then
?3243:						sDisplay = Replace(m_LabelsFormats, "{V}", WStr(yRange))
?3244:						sDisplay = Replace(sDisplay, "{LF}", Chr(10))
?3245:						DrawText sDisplay, XX - RangeHeight / 2, YY + 8 * nScale, RangeHeight, Footer, This.Font, lForeColor, cCenter, cTop
						'DrawText hGraphics, sDisplay, 0, Yy - RangeHeight / 2, MarginLeft - 8 * nScale, RangeHeight, This.Font, lForeColor, cRight, cMiddle
?3247:						
?3248:					End If
?3249:					
?3250:					XX = XX + RangeHeight
?3251:					yRange = yRange + CLng(iStep * NumDecim)
?3252:				Next
?3253:				
?3254:				
?3255:				If m_HorizontalLines And SerieCount > 0 Then
?3256:					For i = 0 To m_Serie(0).Values->Count
?3257:						YY = TopHeader + PtDistance * i
						#ifdef __USE_GTK__
?3259:							cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
?3260:							cairo_move_to(cr, MarginLeft, YY)
?3261:							cairo_line_to(cr, MarginLeft + mWidth, YY)
?3262:							cairo_stroke(cr)
						#else
?3264:							GdipDrawLine hGraphics, hPen, MarginLeft, YY, MarginLeft + mWidth, YY
						#endif
?3266:					Next
?3267:				End If
?3268:				
				#ifndef __USE_GTK__
?3270:					GdipDeletePen hPen
				#endif
?3272:				
?3273:				If ((m_ChartStyle = CS_StackedBars) Or (m_ChartStyle = CS_StackedBarsPercent)) And SerieCount > 0 Then
?3274:					ReDim LastPositive(m_Serie(0).Values->Count - 1)
?3275:					ReDim LastNegative(m_Serie(0).Values->Count - 1)
?3276:					For i = 0 To m_Serie(0).Values->Count - 1
?3277:						LastPositive(i) = ZeroPoint
?3278:						LastNegative(i) = ZeroPoint
?3279:					Next
?3280:				End If
?3281:				
?3282:				For i = 0 To SerieCount - 1
					'Calculo
?3284:					ReDim (m_Serie(i).Rects)(m_Serie(i).Values->Count - 1)
?3285:					If (m_ChartStyle = CS_StackedBars) Or (m_ChartStyle = CS_StackedBarsPercent) Then
?3286:						
?3287:						If m_ChartStyle = CS_StackedBarsPercent Then
?3288:							For j = 0 To m_Serie(i).Values->Count - 1
?3289:								Max = This.SumSerieValues(j, True) ' + 1
?3290:								Value = m_Serie(i).Values->Item(j) ' + 1
?3291:								
?3292:								With m_Serie(i).Rects(j)
?3293:									.Top = TopHeader + PtDistance * j + BarWidth / 2
?3294:									
?3295:									If Value >= 0 Then
?3296:										.Left = LastPositive(j)
?3297:										.Right = (Value * (MarginLeft + mWidth - ZeroPoint) / Max)
?3298:										
?3299:										LastPositive(j) = .Left + .Right
?3300:									Else
?3301:										.Right = (Abs(Value) * (ZeroPoint - MarginLeft) / Max)
?3302:										.Left = LastNegative(j) - .Right
?3303:										LastNegative(j) = .Left
?3304:									End If
?3305:									
?3306:									.Bottom = BarWidth
?3307:								End With
?3308:								
?3309:							Next
?3310:						Else
?3311:							
?3312:							For j = 0 To m_Serie(i).Values->Count - 1
?3313:								Value = m_Serie(i).Values->Item(j) ' + 1
?3314:								
?3315:								With m_Serie(i).Rects(j)
?3316:									.Top = TopHeader + PtDistance * j + BarWidth / 2
?3317:									
?3318:									If Value >= 0 Then
?3319:										.Left = LastPositive(j)
?3320:										.Right = (Value * (Max * (MarginLeft + mWidth - ZeroPoint) / toLines) / Max)
?3321:										LastPositive(j) = .Left + .Right
?3322:										
?3323:									Else
?3324:										.Right = (Value * (Min * (ZeroPoint - MarginLeft) / forLines) / Min)
?3325:										.Left = LastNegative(j) - .Right
?3326:										LastNegative(j) = .Left
?3327:										
?3328:									End If
?3329:									
?3330:									.Bottom = BarWidth
?3331:								End With
?3332:							Next
?3333:						End If
?3334:					Else
?3335:						For j = 0 To m_Serie(i).Values->Count - 1
?3336:							Value = m_Serie(i).Values->Item(j) ' + 1
?3337:							
?3338:							With m_Serie(i).Rects(j)
?3339:								.Top = TopHeader + PtDistance * j + BarWidth / 4 + BarSpace / 2 + BarWidth * i
?3340:								If Value >= 0 Then
?3341:									.Left = ZeroPoint
?3342:									.Right = (Value * (MarginLeft + mWidth - ZeroPoint) / toLines)
?3343:								Else
?3344:									.Left = ZeroPoint - (Value * (ZeroPoint - MarginLeft) / forLines)
?3345:									.Right = ZeroPoint - .Left
?3346:								End If
?3347:								.Bottom = BarWidth - BarSpace
?3348:							End With
?3349:						Next
?3350:					End If
?3351:					
?3352:					With RectL_
?3353:						.Top = TopHeader
?3354:						.Right = ScaleX(This.ClientWidth) - MarginRight
?3355:						.Bottom = ScaleY(This.ClientHeight)
?3356:					End With
?3357:					
?3358:					For j = 0 To UBound(m_Serie(i).Rects)
?3359:						
?3360:						If Not m_Serie(i).CustomColors = 0 Then
?3361:							lColor = m_Serie(i).CustomColors->Item(j) ' + 1
?3362:						Else
?3363:							lColor = m_Serie(i).SerieColor
?3364:						End If
?3365:						
?3366:						Dim As ULong PenColor
?3367:						If i = mHotSerie And (mHotBar = j Or mHotBar = -1) Then
							#ifdef __USE_GTK__
?3369:								PenColor = RGBtoARGB(lColor, 100)
?3370:								cairo_set_line_width(cr, LW * 2)
							#else
?3372:								GdipCreatePen1 RGBtoARGB(lColor, 100), LW * 2, &H2, @hPen
							#endif
?3374:							lColor = ShiftColor(lColor, clWhite, 90)
?3375:						Else
							#ifdef __USE_GTK__
?3377:								PenColor = RGBtoARGB(lColor, 100)
?3378:								cairo_set_line_width(cr, LW)
							#else
?3380:								GdipCreatePen1 RGBtoARGB(lColor, 100), LW, &H2, @hPen
							#endif
?3382:						End If
?3383:						
?3384:						Dim As ULong BrushColor
?3385:						If m_FillGradient Then
							#ifdef __USE_GTK__
?3387:								BrushColor = RGBtoARGB(lColor, m_FillOpacity)
							#else
?3389:								GdipCreateLineBrushFromRectWithAngleI Cast(GpRect Ptr, @RectL_), RGBtoARGB(lColor, m_FillOpacity), RGBtoARGB(clWhite, IIf(m_FillOpacity < 100, 0, 100)), 180, 0, WrapModeTile, Cast(GpLineGradient Ptr Ptr, hBrush)
							#endif
?3391:						Else
							#ifdef __USE_GTK__
?3393:								BrushColor = RGBtoARGB(lColor, m_FillOpacity)
							#else
?3395:								GdipCreateSolidFill RGBtoARGB(lColor, m_FillOpacity), Cast(GpSolidFill Ptr Ptr, @hBrush)
							#endif
?3397:						End If
?3398:						
?3399:						With m_Serie(i).Rects(j)
							#ifdef __USE_GTK__
?3401:								cairo_set_source_rgba(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor), m_FillOpacity / 100)
?3402:								cairo_rectangle(cr, .Left, .Top, .Right, .Bottom)
?3403:								cairo_fill(cr)
?3404:								cairo_set_source_rgb(cr, GetRedD(PenColor), GetGreenD(PenColor), GetBlueD(PenColor))
?3405:								cairo_rectangle(cr, .Left, .Top, .Right, .Bottom)
?3406:								cairo_stroke(cr)
							#else
?3408:								GdipFillRectangleI hGraphics, hBrush, .Left, .Top, .Right, .Bottom
?3409:								GdipDrawRectangleI hGraphics, hPen, .Left, .Top, .Right, .Bottom
							#endif
?3411:						End With
?3412:						
						#ifndef __USE_GTK__
?3414:							GdipDeleteBrush hBrush
?3415:							GdipDeletePen hPen
						#endif
?3417:					Next
?3418:					
?3419:					If m_LegendVisible Then
?3420:						Select Case m_LegendAlign
						Case LA_RIGHT, LA_LEFT
?3422:							With LabelsRect
?3423:								TextWidth = 0
?3424:								
?3425:								If .Left = 0 Then
?3426:									TextHeight = 0
?3427:									If m_LegendAlign = LA_LEFT Then
?3428:										.Left = PT16
?3429:									Else
?3430:										.Left = MarginLeft + mWidth + PT16
?3431:									End If
?3432:									If ColRow = 1 Then
?3433:										.Top = TopHeader + mHeight / 2 - .Bottom / 2
?3434:									Else
?3435:										.Top = TopHeader
?3436:									End If
?3437:								End If
?3438:								
?3439:								If TextWidth < m_Serie(i).TextWidth Then
?3440:									TextWidth = m_Serie(i).TextWidth '+ PT16
?3441:								End If
?3442:								
?3443:								If TextHeight + m_Serie(i).TextHeight > mHeight Then
?3444:									If i > 0 Then .Left = .Left + TextWidth
?3445:									.Top = TopHeader
?3446:									TextHeight = 0
?3447:								End If
?3448:								m_Serie(i).LegendRect.Left = .Left
?3449:								m_Serie(i).LegendRect.Top = .Top
?3450:								m_Serie(i).LegendRect.Right = m_Serie(i).TextWidth
?3451:								m_Serie(i).LegendRect.Bottom = m_Serie(i).TextHeight
?3452:								
								#ifdef __USE_GTK__
?3454:									Var BrushColor = RGBtoARGB(m_Serie(i).SerieColor, 100)
?3455:									cairo_set_source_rgb(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor))
?3456:									cairo_rectangle(cr, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2)
?3457:									cairo_fill(cr)
								#else
?3459:									GdipCreateSolidFill RGBtoARGB(m_Serie(i).SerieColor, 100), Cast(GpSolidFill Ptr Ptr, @hBrush)
?3460:									GdipFillRectangleI hGraphics, hBrush, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2
?3461:									GdipDeleteBrush hBrush
								#endif
?3463:								
?3464:								DrawText m_Serie(i).SerieName, .Left + m_Serie(i).TextHeight / 1.5, .Top, m_Serie(i).TextWidth, m_Serie(i).TextHeight, This.Font, lForeColor, cLeft, cMiddle
?3465:								TextHeight = TextHeight + m_Serie(i).TextHeight
?3466:								.Top = .Top + m_Serie(i).TextHeight
?3467:								
?3468:							End With
?3469:							
?3470:						Case LA_BOTTOM, LA_TOP
?3471:							With LabelsRect
?3472:								If .Left = 0 Then
?3473:									If ColRow = 1 Then
?3474:										.Left = MarginLeft + mWidth / 2 - .Right / 2
?3475:									Else
?3476:										.Left = MarginLeft
?3477:									End If
?3478:									If m_LegendAlign = LA_TOP Then
?3479:										.Top = PT16 + TitleSize.Height
?3480:									Else
?3481:										.Top = TopHeader + mHeight + TitleSize.Height + PT16 / 2
?3482:									End If
?3483:								End If
?3484:								
?3485:								If .Left + m_Serie(i).TextWidth - MarginLeft > mWidth Then
?3486:									.Left = MarginLeft
?3487:									.Top = .Top + m_Serie(i).TextHeight
?3488:								End If
?3489:								
								#ifdef __USE_GTK__
?3491:									Var BrushColor = RGBtoARGB(m_Serie(i).SerieColor, 100)
?3492:									cairo_set_source_rgb(cr, GetRedD(BrushColor), GetGreenD(BrushColor), GetBlueD(BrushColor))
?3493:									cairo_rectangle(cr, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2)
?3494:									cairo_fill(cr)
								#else
?3496:									GdipCreateSolidFill RGBtoARGB(m_Serie(i).SerieColor, 100), Cast(GpSolidFill Ptr Ptr, hBrush)
?3497:									GdipFillRectangleI hGraphics, hBrush, .Left, .Top + m_Serie(i).TextHeight / 4, m_Serie(i).TextHeight / 2, m_Serie(i).TextHeight / 2
?3498:									GdipDeleteBrush hBrush
								#endif
?3500:								m_Serie(i).LegendRect.Left = .Left
?3501:								m_Serie(i).LegendRect.Top = .Top
?3502:								m_Serie(i).LegendRect.Right = m_Serie(i).TextWidth
?3503:								m_Serie(i).LegendRect.Bottom = m_Serie(i).TextHeight
?3504:								
?3505:								DrawText m_Serie(i).SerieName, .Left + m_Serie(i).TextHeight / 1.5, .Top, m_Serie(i).TextWidth, m_Serie(i).TextHeight, This.Font, lForeColor, cLeft, cMiddle
?3506:								.Left = .Left + m_Serie(i).TextWidth '+ m_Serie(i).TextHeight / 1.5
?3507:							End With
?3508:						End Select
?3509:					End If
?3510:					
?3511:				Next
?3512:				
?3513:				If m_LabelsVisible Then
?3514:					For i = 0 To SerieCount - 1
?3515:						For j = 0 To m_Serie(i).Values->Count - 1
?3516:							mRect = m_Serie(i).Rects(j)
?3517:							With mRect
?3518:								sDisplay = Replace(m_LabelsFormats, "{V}", FormatLabel(m_Serie(i).Values->Item(j), m_LabelsFormat)) ' + 1
?3519:								sDisplay = Replace(sDisplay, "{LF}", Chr(10))
?3520:								TextHeight = ScaleX(Canvas.TextHeight(sDisplay)) * 1.3
?3521:								TextWidth = ScaleY(Canvas.TextWidth(sDisplay)) * 1.5
?3522:								If (TextWidth > .Right Or m_LabelsPositions = LP_Outside) And m_ChartStyle = CS_GroupedColumn Then
?3523:									.Left = .Left + .Right + PT16 / 10
?3524:									.Right = TextWidth
?3525:									lColor = RGBtoARGB(m_Serie(i).SerieColor, 100)
?3526:								Else
?3527:									If Not m_Serie(i).CustomColors = 0 Then
?3528:										lColor = m_Serie(i).CustomColors->Item(j)
?3529:									Else
?3530:										lColor = FForeColor
?3531:									End If
?3532:									If IsDarkColor(lColor) Then
?3533:										lColor = RGBtoARGB(clWhite, 100)
?3534:									Else
?3535:										lColor = RGBtoARGB(clBlack, 100)
?3536:									End If
?3537:								End If
?3538:								
?3539:								If TextHeight > .Bottom Then
?3540:									.Top = .Top + .Bottom / 2 - TextHeight / 2
?3541:									.Bottom = TextHeight
?3542:								End If
?3543:								
?3544:								
?3545:								DrawText sDisplay, .Left, .Top, .Right, .Bottom, This.Font, lColor, m_LabelsAlignments, cMiddle
?3546:							End With
?3547:						Next
?3548:					Next
?3549:				End If
?3550:				
?3551:				
?3552:				
				'a line to overlap the base of the rectangle
				#ifdef __USE_GTK__
?3555:					cairo_set_line_width(cr, LW)
?3556:					Var PenColor1 = RGBtoARGB(m_LinesColor, 100)
?3557:					cairo_set_source_rgb(cr, GetRedD(PenColor1), GetGreenD(PenColor1), GetBlueD(PenColor1))
?3558:					cairo_move_to(cr, ZeroPoint, TopHeader)
?3559:					cairo_line_to(cr, ZeroPoint, TopHeader + mHeight - mPenWidth)
?3560:					cairo_stroke(cr)
				#else
?3562:					GdipCreatePen1(RGBtoARGB(m_LinesColor, 100), LW, &H2, @hPen)
?3563:					GdipDrawLine hGraphics, hPen, ZeroPoint, TopHeader, ZeroPoint, TopHeader + mHeight - mPenWidth
?3564:					GdipDeletePen hPen
				#endif
?3566:				
				'vertical Axis
?3568:				If m_AxisYVisible Then
?3569:					For i = 0 To cAxisItem->Count - 1
?3570:						YY = TopHeader + AxisDistance * (i) ' - 1
?3571:						If m_LegendAlign = LA_LEFT Then
?3572:							XX = LabelsRect.Left + LabelsRect.Right
?3573:						Else
?3574:							XX = PT16
?3575:						End If
?3576:						
?3577:						DrawText cAxisItem->Item(i), XX, YY, MarginLeft - XX - PT16 / 10, AxisDistance, This.Font, lForeColor, m_AxisAlign, cMiddle, m_WordWrap, m_AxisAngle
?3578:					Next
?3579:				End If
?3580:				
?3581:			End If
?3582:		End Select
?3583:		
		'Title
?3585:		If Len(m_Title) Then
?3586:			DrawText m_Title, 0, PT16 / 2, ScaleX(This.ClientWidth), TopHeader, m_TitleFont, RGBtoARGB(m_TitleForeColor, 100), cCenter, cTop, True
?3587:		End If
?3588:		
?3589:		Select Case ChartStyle
		Case CS_PIE To CS_AREA
?3591:			ShowToolTips
?3592:		Case CS_GroupedColumn To CS_StackedBarsPercent
?3593:			ShowToolTips BarWidth
?3594:		End Select
?3595:		
		#ifndef __USE_GTK__
?3597:			GdipDeleteGraphics(hGraphics)
		#endif
?3599:		
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
							sDisplay = Replace(m_LabelsFormats, "{V}", FormatLabel(m_Serie(i).Values->Item(j), m_ToolTipsFormat))
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
							
							
							sDisplay = Replace(m_LabelsFormats, "{V}", FormatLabel(m_Serie(i).Values->Item(j), m_ToolTipsFormat))
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
							sDisplay = Replace(m_LabelsFormats, "{V}", FormatLabel(m_Serie(i).Values->Item(j), m_ToolTipsFormat))
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
		
		m_WStringList = New_(WStringList)
		
		m_WStringList->Add "2018"
		m_WStringList->Add "2019"
		m_WStringList->Add "2020"
		Me.AddAxisItems m_WStringList
		
		m_DoubleList1 = New_(DoubleList)
		With *m_DoubleList1
			.Add 10
			.Add 15
			.Add 5
		End With
		This.AddSerie "Juan", clRed, m_DoubleList1
		m_DoubleList2 = New_(DoubleList)
		With *m_DoubleList2
			.Add 8
			.Add 4
			.Add 12
		End With
		Me.AddSerie "Pedro", clBlue, m_DoubleList2
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
		If m_WStringList <> 0 Then Delete_(m_WStringList)
		If m_DoubleList1 <> 0 Then Delete_(m_DoubleList1)
		If m_DoubleList2 <> 0 Then Delete_(m_DoubleList2)
		#ifndef __USE_GTK__
			If gToken Then
				GdiplusShutdown(gToken)
			End If
			'UnregisterClass "Chart",GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
