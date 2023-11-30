'################################################################################
'#  Canvas.bi                                                                   #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                      #
'#  Based on:                                                                   #
'#   TCanvas.bi                                                                 #
'#   FreeBasic Windows GUI ToolKit                                              #
'#   Copyright (c) 2007-2008 Nastase Eodor                                      #
'#   Version 1.0.0                                                              #
'################################################################################

#include once "Canvas.bi"

Namespace My.Sys.Drawing
	#ifndef ReadProperty_Off
		Private Function Canvas.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "pen": Return @Pen
			Case "brush": Return @Brush
			Case "font": Return @Font
			Case "clip": Return @Clip
			Case "copymode": Return @CopyMode
				#ifdef __USE_GTK__
				Case "handle": Return Handle
				#else
				Case "handle": Return @Handle
				#endif
			Case "height": iTemp = This.Height: Return @iTemp
			Case "width": iTemp = This.Width: Return @iTemp
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function Canvas.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "clip": This.Clip = QBoolean(Value)
			Case "copymode": This.CopyMode = QInteger(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	
	Private Property Canvas.BackColor As Integer
		Return FBackColor
	End Property
	
	Private Property Canvas.BackColor(Value As Integer)
		FBackColor = Value
		FillColor = FBackColor
	End Property
	
	Private Property Canvas.FillColor As Integer
		Return FFillColor
	End Property
	
	Private Property Canvas.FillColor(Value As Integer)
		If FFillColor <> Value Then
			FFillColor = Value
			#ifdef __USE_WINAPI__
				If FFillColor = -1 Then FFillColor = FBackColor
				SetBkColor Handle, FFillColor
				Brush.Color = FFillColor
				If GdipToken <> NULL Then
					If GdipBrush Then GdipDeleteBrush(GdipBrush)
					GdipCreateSolidFill(RGBtoARGB(FFillColor, FillOpacity), Cast(GpSolidFill Ptr Ptr, @GdipBrush))
				End If
				'FloodFill(1, 1, FFillColor, FillStyle.fsSurface)
			#endif
		End If
	End Property
	
	Private Property Canvas.FillMode As BrushFillMode
		Return FFillMode
	End Property
	
	Private Property Canvas.FillMode(Value As BrushFillMode)
		If FFillMode <> Value Then
			FFillMode = Value
			#ifdef __USE_WINAPI__
				SetBkMode Handle, FFillMode
			#endif
		End If
	End Property
	
	Private Property Canvas.HatchStyle As HatchStyles
		Return FHatchStyle
	End Property
	
	Private Property Canvas.HatchStyle(Value As HatchStyles)
		If FHatchStyle <> Value Then
			FHatchStyle = Value
			#ifdef __USE_WINAPI__
				Brush.HatchStyle = Value
				If GdipToken <> NULL Then
					If GdipBrush Then GdipDeleteBrush(GdipBrush)
					GdipCreateHatchBrush(GpHatchStyles, RGBtoARGB(FFillColor, FillOpacity), RGBtoARGB(FDrawColor, FillOpacity), Cast(GpHatch Ptr Ptr, @GdipBrush))
				End If
			#endif
		End If
	End Property
	
	Private Property Canvas.FillStyles As BrushStyles
		Return FFillStyles
	End Property
	
	Private Property Canvas.FillStyles(Value As BrushStyles)
		'https://learn.microsoft.com/zh-cn/windows/win32/gdiplus/-gdiplus-brushes-and-filled-shapes-about
		'If FFillStyles <> Value Then
		FFillStyles = Value
		#ifdef __USE_WINAPI__
			Brush.Style= Value
			If GdipToken <> NULL Then
				If GdipBrush Then GdipDeleteBrush(GdipBrush)
				Select Case FFillStyles
				Case BrushStyles.bsHatch
					GdipCreateHatchBrush(GpHatchStyles, RGBtoARGB(FFillColor, FillOpacity), RGBtoARGB(FDrawColor, FillOpacity), Cast(GpHatch Ptr Ptr, @GdipBrush))
				Case BrushStyles.bsPattern
					GdipCreateLineBrush(@GpLineGradientPara.PointFrom, @GpLineGradientPara.PointTo, RGBtoARGB(GpLineGradientPara.ColorStart, FillOpacity), RGBtoARGB(GpLineGradientPara.ColorEnd, FillOpacity),  GpLineGradientPara.WrapModes, Cast(GpLineGradient Ptr Ptr, @GdipBrush))
					Print "GdipBrush=" & GdipBrush
					'Case BrushStyles.bsClear
					'	'ElseIf Value = BrushStyles.bsHatch Then
					'	'GdipCreateHatchBrush(HatchStyle.
				Case Else
					GdipCreateSolidFill(RGBtoARGB(FFillColor, FillOpacity), Cast(GpSolidFill Ptr Ptr, @GdipBrush))
				End Select
			End If
		#endif
		'End If
	End Property
	
	Private Property Canvas.Width As Integer
		If ParentControl Then
			Return ParentControl->Width
		End If
	End Property
	
	Private Property Canvas.Height As Integer
		If ParentControl Then
			Return ParentControl->Height
		End If
	End Property
	
	Private Property Canvas.ScaleWidth As Integer
		Return FScaleWidth
	End Property
	
	Private Property Canvas.ScaleHeight As Integer
		Return FScaleHeight
	End Property
	
	Private Property Canvas.DrawWidth As Integer
		#ifdef __USE_WINAPI__
			If GdipToken <> NULL Then Return FDrawWidth
		#endif
		Return Pen.Size
	End Property
	
	Private Property Canvas.DrawWidth(Value As Integer)
		#ifdef __USE_GTK__
		#elseif defined(__USE_WINAPI__)
			If FDrawWidth <> Value Then
				FDrawWidth = Value
				Pen.Size = Value
				If GdipToken <> NULL Then
					If GdipPen Then GdipDeletePen(GdipPen)
					GdipCreatePen1(RGBtoARGB(Pen.Color, BackColorOpacity), FDrawWidth, &H2, @GdipPen)
					GdipSetPenEndCap GdipPen, 2
				End If
			End If
		#endif
	End Property
	
	Private Property Canvas.DrawColor As Integer
		#ifdef __USE_WINAPI__
			If GdipToken <> NULL Then Return FDrawColor
		#endif
		Return Pen.Color
	End Property
	
	Private Property Canvas.DrawColor(Value As Integer)
		#ifdef __USE_GTK__
		#elseif defined(__USE_WINAPI__)
			If FDrawColor <> Value Then
				FDrawColor = Value
				Pen.Color = Value
				If GdipToken <> NULL Then
					If GdipPen Then GdipDeletePen(GdipPen)
					GdipCreatePen1(RGBtoARGB(Pen.Color, BackColorOpacity), FDrawWidth, &H2, @GdipPen)
					GdipSetPenEndCap GdipPen, 2
				End If
			End If
		#endif
	End Property
	
	Private Property Canvas.DrawStyle As PenStyle
		#ifdef __USE_WINAPI__
			If GdipToken <> NULL Then Return FDrawStyle
		#endif
		Return Pen.Style
	End Property
	'https://learn.microsoft.com/zh-cn/windows/win32/api/gdipluspen/nf-gdipluspen-pen-setdashstyle
	Private Property Canvas.DrawStyle(Value As PenStyle)
		#ifdef __USE_GTK__
		#elseif defined(__USE_WINAPI__)
			If FDrawStyle <> Value Then
				FDrawStyle = Value
				Pen.Style = Value
				If GdipToken <> NULL Then
					If GdipPen Then GdipDeletePen(GdipPen)
					GdipCreatePen1(RGBtoARGB(Pen.Color, BackColorOpacity), FDrawWidth, &H2, @GdipPen)
					GdipSetPenEndCap GdipPen, 2
					Dim As GpDashStyle tGpDashStyle
					Select Case Value
					Case PenStyle.psDash
						tGpDashStyle = DashStyleDash
					Case PenStyle.psDot
						tGpDashStyle = DashStyleDot
					Case PenStyle.psDashDot
						tGpDashStyle = DashStyleDashDot
					Case PenStyle.psDashDotDot
						tGpDashStyle = DashStyleDashDotDot
					Case Else
						tGpDashStyle = DashStyleSolid
					End Select
					GdipSetPenDashStyle(GdipPen, tGpDashStyle)
				End If
			End If
		#endif
	End Property
	
	Private Sub Canvas.Cls(x As Double = 0, y As Double = 0, x1 As Double = 0, y1 As Double = 0)
		If Not HandleSetted Then GetDevice
		If ParentControl > 0 Then
			#ifdef __USE_GTK__
				cairo_set_source_rgb(Handle, GetRed(FBackColor), GetBlue(FBackColor), GetGreen(FBackColor))
			#elseif defined(__USE_WINAPI__)
				Dim As HBRUSH B = CreateSolidBrush(FBackColor)
			#endif
			Dim As Rect R
			If x = x1 AndAlso y = y1 AndAlso x = y Then
				R.Left = 0
				R.Top = 0
				R.Right = ScaleX(ParentControl->Width)
				R.Bottom = ScaleY(ParentControl->Height)
				'Remove Scale
				imgScaleX = 1
				imgScaleY = 1
				imgOffsetX = 0
				imgOffsetY = 0
				FDrawWidth = 1
				FScaleWidth = ScaleX(This.Width)
				FScaleHeight =  ScaleY(This.Height)
				#ifdef __USE_WINAPI__
					If memDC > 0 Then DeleteDoubleBuffer
					.FillRect Handle, Cast(..Rect Ptr, @R), B
				#endif
			Else
				R.Left = ScaleX(x) * imgScaleX + imgOffsetX
				R.Top = ScaleY(y) * imgScaleY + imgOffsetY
				R.Right = ScaleX(x1) * imgScaleX + imgOffsetX
				R.Bottom = ScaleY(y1) * imgScaleY + imgOffsetY
				#ifdef __USE_WINAPI__
					.FillRect Handle, Cast(..Rect Ptr, @R), B
				#endif
			End If
			#ifdef __USE_GTK__
				.cairo_rectangle(Handle, R.Left - 0.5, R.Top - 0.5, R.Right - R.Left - 0.5, R.Bottom - R.Top - 0.5)
				cairo_set_source_rgb(Handle, GetRedD(FBackColor), GetGreenD(FBackColor), GetBlueD(FBackColor))
				cairo_fill_preserve(Handle)
			#elseif defined(__USE_WINAPI__)
				.FillRect Handle, Cast(..Rect Ptr, @R), B
				DeleteObject B
			#endif
		End If
		If Not HandleSetted Then ReleaseDevice
	End Sub
	Private Property Canvas.Ctrl As My.Sys.ComponentModel.Component Ptr
		Return ParentControl
	End Property
	
	Private Property Canvas.Ctrl(Value As My.Sys.ComponentModel.Component Ptr)
		ParentControl = Value
		If ParentControl Then
			'			ParentControl->Canvas = @This
			'			If *Ctrl Is My.Sys.Forms.Control Then
			'				Brush.Color = Cast(My.Sys.Forms.Control Ptr, Ctrl)->BackColor
			'			End If
		End If
	End Property
	
	Private Property Canvas.Pixel(xy As Point) As Integer
		GetDevice
		#ifdef __USE_WINAPI__
			Return .GetPixel(Handle, ScaleX(xy.X), ScaleY(xy.Y))
		#else
			Return 0
		#endif
		ReleaseDevice
	End Property
	
	Private Property Canvas.Pixel(xy As Point, Value As Integer)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_GTK__
			cairo_set_source_rgb(Handle, GetRed(Value) / 255.0, GetBlue(Value) / 255.0, GetGreen(Value) / 255.0)
			.cairo_rectangle(Handle, xy.X * imgScaleX + imgOffsetX - 0.5, xy.Y * imgScaleY + imgOffsetY - 0.5, 1, 1)
			cairo_fill(Handle)
		#elseif defined(__USE_WINAPI__)
			.SetPixel(Handle, ScaleX(xy.X) * imgScaleX + imgOffsetX, ScaleY(xy.Y) * imgScaleY + imgOffsetY, Value)
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Property
	
	Private Sub Canvas.UsingGdip(Vaule As Boolean = True)
		#ifdef __USE_WINAPI__
			If Vaule = True Then
				If GdipToken <> NULL Then
					If GdipPen Then GdipDeletePen(GdipPen)
					If GdipBrush Then GdipDeleteBrush(GdipBrush)
					If GdipToken Then GdiplusShutdown(GdipToken)
				End If
				FGdipStartupInput.GdiplusVersion = 1                    ' attempt to start GDI+
				GdiplusStartup(@GdipToken, @FGdipStartupInput, NULL)
				If GdipToken = NULL Then                         ' failed to start
					Print Date & " " & Time & Chr(9) & __FUNCTION__ & Chr(9) & "Initial GDIPlus failure! "
				Else
					DC = GetDC(ParentControl->Handle)
					Handle = DC
					If GdipCreateFromHDC(DC, @GdipGraphics) <> NULL Then
						If GdipToken Then GdiplusShutdown(GdipToken)
						GdipToken = NULL
						Print Date & " " & Time & Chr(9) & __FUNCTION__ & Chr(9) & "Initial GdipGraphics failure! "
					Else
						GdipCreateSolidFill(RGBtoARGB(FFillColor, FillOpacity), Cast(GpSolidFill Ptr Ptr, @GdipBrush))
						GdipCreatePen1(RGBtoARGB(Pen.Color, BackColorOpacity), FDrawWidth, &H2, @GdipPen)
						GdipSetPenEndCap GdipPen, 2
						GdipSetSmoothingMode(GdipGraphics, SmoothingModeAntiAlias)
						GdipSetCompositingQuality(GdipGraphics, &H3) 'CompositingQualityGammaCorrected
					End If
				End If
			Else
				If GdipToken <> NULL Then
					If GdipPen Then GdipDeletePen(GdipPen)
					If GdipBrush Then GdipDeleteBrush(GdipBrush)
					If GdipToken Then GdiplusShutdown(GdipToken)
					GdipToken = NULL
				End If
			End If
		#endif
	End Sub
	
	Private Sub Canvas.GetDevice
		If Not HandleSetted Then
			If ParentControl Then
				#ifdef __USE_GTK__
					If ParentControl->Handle Then
						pcontext = gtk_widget_create_pango_context(ParentControl->Handle)
						layout = pango_layout_new(pcontext)
						pango_layout_set_font_description(layout, Font.Handle)
						If Not HandleSetted Then
							If ParentControl->layoutwidget Then
								#ifdef __USE_GTK4__
									Dim As GdkDrawContext Ptr drawContext
									cairoRegion = cairo_region_create()
									Dim As GdkDrawingContext Ptr drawingContext
									drawingContext = gdk_window_begin_draw_frame(gtk_widget_get_window(ParentControl->layoutwidget), drawContext, cairoRegion)
									Handle = gdk_drawing_context_get_cairo_context(drawingContext)
								#else
									Handle = gdk_cairo_create(gtk_layout_get_bin_window(GTK_LAYOUT(ParentControl->layoutwidget)))
								#endif
								HandleSetted = True
							End If
						End If
					End If
				#elseif defined(__USE_WINAPI__)
					If ParentControl->Handle Then
						If Clip Then
							Handle = GetDCEx(ParentControl->Handle, 0, DCX_PARENTCLIP Or DCX_CACHE)
						Else
							Handle = GetDC(ParentControl->Handle)
						End If
						SelectObject(Handle, Font.Handle)
						SelectObject(Handle, Pen.Handle)
						SelectObject(Handle, Brush.Handle)
						SetROP2 Handle, Pen.Mode
					End If
				#endif
			End If
		End If
	End Sub
	
	Private Sub Canvas.ReleaseDevice
		#ifdef __USE_GTK__
			If layout Then g_object_unref(layout)
			#ifdef __USE_GTK4__
				gdk_window_end_draw_frame(gtk_widget_get_window(ParentControl->layoutwidget), DrawingContext)
				cairo_region_destroy(cairoRegion)
			#else
				If pcontext Then g_object_unref(pcontext)
				If Handle AndAlso G_IS_OBJECT(Handle) Then cairo_destroy(Handle)
				HandleSetted = False
			#endif
		#elseif defined(__USE_WINAPI__)
			If FDoubleBuffer Then
				DeleteDoubleBuffer
				FDoubleBuffer = False
			End If
			If HandleSetted Then Exit Sub
			If ParentControl Then If Handle Then ReleaseDC ParentControl->Handle, Handle
		#endif
	End Sub
	
	Private Sub Canvas.CreateDoubleBuffer(DrawGraphicBitmap As Boolean = True, CleanBK As Boolean = False)
		#ifdef __USE_WINAPI__
			If memDC > 0 Then DeleteDoubleBuffer
			If Not HandleSetted Then GetDevice
			DC = Handle
			memDC = CreateCompatibleDC(DC)
			FBmpWidth = ScaleX(ParentControl->Width)
			FBmpHeight = ScaleY(ParentControl->Height)
			CompatibleBmp = CreateCompatibleBitmap(DC, FBmpWidth, FBmpHeight)
			SelectObject(memDC, CompatibleBmp)
			
			'If CleanBK = False Then
			'	RedrawWindow(ParentControl->Handle, NULL, NULL, RDW_INVALIDATE Or RDW_ALLCHILDREN)
			'	CreateDoubleBuffered = False
			'	If DrawGraphicBitmap Then SendMessage(ParentControl->Handle, WM_PAINT, 0, 128)
			'Else
			'	Dim As HBRUSH B = CreateSolidBrush(FBackColor)
			'	Dim As ..Rect Re
			'	Re= Type<..Rect>(0, 0, FBmpWidth, FBmpHeight)
			'	.FillRect Handle, @Re, B
			'	DeleteObject B
			'End If
			'BitBlt(memDC, 0, 0, FBmpWidth, FBmpHeight, DC, 0, 0, SRCCOPY)
			Handle = memDC
			'If GdipToken <> NULL Then
			'	If GdipPen Then GdipDeletePen(GdipPen)
			'	If GdipBrush Then GdipDeleteBrush(GdipBrush)
			'	If GdipGraphics Then GdipDeleteGraphics(GdipGraphics)
			'	If GdipToken Then GdiplusShutdown(GdipToken)
			'End If
			'FGdipStartupInput.GdiplusVersion = 1                    ' attempt to start GDI+
			'GdiplusStartup(@GdipToken, @FGdipStartupInput, NULL)
			'If GdipToken = NULL Then                         ' failed to start
			'	Print Date & " " & Time & Chr(9) & __FUNCTION__ & Chr(9) & "Initial GDIPlus failure! "
			'Else
			'	If GdipCreateFromHDC(memDC, @GdipGraphics) <> NULL Then
			'		If GdipToken Then GdiplusShutdown(GdipToken)
			'		GdipToken = NULL
			'		Print Date & " " & Time & Chr(9) & __FUNCTION__ & Chr(9) & "Initial GdipGraphics failure! ", True
			'	Else
			'		GdipCreateSolidFill(RGBtoARGB(FFillColor, FillOpacity), Cast(GpSolidFill Ptr Ptr, @GdipBrush))
			'		GdipCreatePen1(RGBtoARGB(Pen.Color, BackColorOpacity), FDrawWidth, &H2, @GdipPen)
			'		GdipSetPenEndCap GdipPen, 2
			'		GdipSetSmoothingMode(GdipGraphics, SmoothingModeAntiAlias)
			'		GdipSetCompositingQuality(GdipGraphics, &H3) 'CompositingQualityGammaCorrected
			'	End If
			'End If
			HandleSetted = True
			FDoubleBuffer = True
			CreateDoubleBuffered = True
		#endif
	End Sub
	
	#ifndef Canvas_TransferDoubleBuffer_Off
		Private Sub Canvas.TransferDoubleBuffer(ALeft As Long = 0, ATop As Long = 0, AWidth As Long = -1, AHeight As Long = -1)
			If AWidth = -1 Then AWidth = FBmpWidth Else AWidth = ScaleX(AWidth)
			If AHeight = -1 Then AHeight = FBmpHeight Else AHeight = ScaleY(AHeight)
			#ifdef __USE_WINAPI__
				If memDC > 0 Then
					SetStretchBltMode(DC, HALFTONE)
					StretchBlt(DC, ScaleX(ALeft), ScaleY(ATop),  AWidth, AHeight, memDC, 0, 0, FBmpWidth, FBmpHeight, SRCCOPY)
				End If
			#endif
		End Sub
	#endif
	
	Private Sub Canvas.DeleteDoubleBuffer
		#ifdef __USE_WINAPI__
			#ifdef __USE_WINAPI__
				If memDC > 0 Then BitBlt(DC, 0, 0, ScaleX(This.Width), ScaleY(This.Height), memDC, 0, 0, SRCCOPY)
			#endif
			Handle = DC
			HandleSetted = False
			DeleteObject(CompatibleBmp)
			DeleteDC(memDC)
			memDC = 0
			FDoubleBuffer = False
			CreateDoubleBuffered = False
			If Not HandleSetted Then ReleaseDevice
		#endif
	End Sub
	
	Private Sub Canvas.Scale(x As Double, y As Double, x1 As Double, y1 As Double)
		If ParentControl Then
			imgScaleX = Min(ParentControl->Width, ParentControl->Height) / (x1 - x)
			imgScaleY = Min(ParentControl->Width, ParentControl->Height) / (y1 - y)
			imgOffsetX = ScaleX(IIf(ParentControl->Width > ParentControl->Height, (ParentControl->Width - ParentControl->Height) / 2 - x * imgScaleX, -x * imgScaleX))
			imgOffsetY = ScaleY(IIf(ParentControl->Height > ParentControl->Width, (ParentControl->Height - ParentControl->Width) / 2 - y * imgScaleY, -y * imgScaleY))
			FScaleWidth = ScaleX(x1 - x)
			FScaleHeight = ScaleY(y1 - y)
		Else
			imgScaleX = 1
			imgScaleY = 1
			imgOffsetX = 0
			imgOffsetY = 0
			FDrawWidth = 1
			FScaleWidth = ScaleX(This.Width)
			FScaleHeight = ScaleY( This.Height)
		End If
	End Sub
	
	Private Sub Canvas.MoveTo(x As Double, y As Double)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_GTK__
			cairo_move_to(Handle, x * imgScaleX + imgOffsetX - 0.5, y * imgScaleY + imgOffsetY - 0.5)
		#elseif defined(__USE_WINAPI__)
			If GdipToken = NULL Then
				.MoveToEx Handle, ScaleX(x) * imgScaleX + imgOffsetX , ScaleY(y) * imgScaleY + imgOffsetY, 0
			Else
				FMoveToX = ScaleX(x) * imgScaleX + imgOffsetX : FMoveToY = ScaleY(y) * imgScaleY + imgOffsetY
			End If
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.LineTo(x As Double, y As Double)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_GTK__
			cairo_set_source_rgb(Handle, GetRedD(Pen.Color), GetGreenD(Pen.Color), GetBlueD(Pen.Color))
			cairo_line_to(Handle, x * imgScaleX + imgOffsetX - 0.5, y * imgScaleY + imgOffsetY - 0.5)
			cairo_stroke(Handle)
		#elseif defined(__USE_WINAPI__)
			If GdipToken = NULL Then
				.LineTo Handle, ScaleX(x) * imgScaleX + imgOffsetX , ScaleY(y) * imgScaleY + imgOffsetY
			Else
				GdipDrawLine GdipGraphics, GdipPen, FMoveToX, FMoveToY, ScaleX(x) * imgScaleX + imgOffsetX , ScaleY(y) * imgScaleY + imgOffsetY
			End If
			
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.Line(x As Double, y As Double, x1 As Double, y1 As Double, FillColorBk As Integer = -1, BoxBF As String = "" )
		If Not HandleSetted Then GetDevice
		If BoxBF <> "" Then
			If BoxBF = "F" Then
				'Special code for VB6
				If FillColorBk = -1 Then FillColorBk = FBackColor
				Dim As Integer OldFillColor = Brush.Color
				Brush.Color = FillColorBk
				#ifdef __USE_WINAPI__
					If GdipToken = NULL Then
						Rectangle(x, y, x1, y1)
					Else
						GdipFillRectangle(GdipGraphics, GdipBrush, x, y, x1, y1)
					End If
				#else
					Rectangle(x, y, x1, y1)
				#endif
				Brush.Color = OldFillColor
			Else
				#ifdef __USE_WINAPI__
					If GdipToken = NULL Then
						Rectangle(x, y, x1, y1)
					Else
						GdipDrawRectangle GdipGraphics, GdipPen, x, y, x1, y1
					End If
				#else
					Rectangle(x, y, x1, y1)
				#endif
			End If
		Else
			Dim As Integer OldPenColor
			If FillColorBk <> -1 Then
				OldPenColor = Pen.Color
				Pen.Color = FillColorBk
			End If
			#ifdef __USE_GTK__
				cairo_set_source_rgb(Handle, GetRedD(Pen.Color), GetGreenD(Pen.Color), GetBlueD(Pen.Color))
				cairo_move_to(Handle, x * imgScaleX + imgOffsetX - 0.5, y * imgScaleY + imgOffsetY - 0.5)
				cairo_line_to(Handle, x1 * imgScaleX + imgOffsetX - 0.5, y1 * imgScaleY + imgOffsetY - 0.5)
				cairo_stroke(Handle)
			#elseif defined(__USE_WINAPI__)
				If GdipToken = NULL Then
					.MoveToEx Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, 0
					.LineTo Handle, ScaleX(x1) * imgScaleX + imgOffsetX, ScaleY(y1) * imgScaleY + imgOffsetY
				Else
					GdipDrawLine GdipGraphics, GdipPen, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1) * imgScaleX + imgOffsetX, ScaleY(y1) * imgScaleY + imgOffsetY
				End If
			#endif
			If FillColorBk <> -1 Then Pen.Color = OldPenColor
		End If
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	#ifndef Canvas_Rectangle_Double_Double_Double_Double_Off
		Private Sub Canvas.Rectangle Overload(x As Double, y As Double, x1 As Double, y1 As Double)
			If Not HandleSetted Then GetDevice
			#ifdef __USE_GTK__
				cairo_move_to (Handle, x * imgScaleX + imgOffsetX - 0.5, y * imgScaleY + imgOffsetY - 0.5)
				cairo_line_to (Handle, x1 * imgScaleX + imgOffsetX - 0.5, y * imgScaleY + imgOffsetY - 0.5)
				cairo_line_to (Handle, x1 * imgScaleX + imgOffsetX - 0.5, y1 * imgScaleY + imgOffsetY - 0.5)
				cairo_line_to (Handle, x * imgScaleX + imgOffsetX - 0.5, y1 * imgScaleY + imgOffsetY - 0.5)
				cairo_line_to (Handle, x * imgScaleX + imgOffsetX - 0.5, y * imgScaleY + imgOffsetY - 0.5)
				cairo_set_source_rgb(Handle, GetRedD(Brush.Color), GetGreenD(Brush.Color), GetBlueD(Brush.Color))
				cairo_fill_preserve(Handle)
				cairo_set_source_rgb(Handle, GetRedD(Pen.Color), GetGreenD(Pen.Color), GetBlueD(Pen.Color))
				cairo_stroke(Handle)
			#elseif defined(__USE_WINAPI__)
				If GdipToken = NULL Then
					.Rectangle Handle, ScaleX(x) * imgScaleX + imgOffsetX , ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1) * imgScaleX + imgOffsetX , ScaleY(y1) * imgScaleY + imgOffsetY
				Else
					If GdipBrush Then GdipFillRectangle(GdipGraphics, GdipBrush, ScaleX(x) * imgScaleX + imgOffsetX , ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1 - x) * imgScaleX, ScaleY(y1 - y) * imgScaleY)
					GdipDrawRectangle(GdipGraphics, GdipPen,  ScaleX(x) * imgScaleX + imgOffsetX , ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1 - x) * imgScaleX, ScaleY(y1 - y) * imgScaleY)
				End If
			#endif
			If Not HandleSetted Then ReleaseDevice
		End Sub
	#endif
	
	Private Sub Canvas.Rectangle(R As Rect)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_GTK__
			.cairo_rectangle(Handle, R.Left * imgScaleX + imgOffsetX - 0.5, R.Top * imgScaleY + imgOffsetY - 0.5, (R.Right - R.Left) * imgScaleY - 0.5, (R.Bottom - R.Top) * imgScaleY - 0.5)
			cairo_set_source_rgb(Handle, GetRedD(Brush.Color), GetGreenD(Brush.Color), GetBlueD(Brush.Color))
			cairo_fill_preserve(Handle)
			cairo_set_source_rgb(Handle, GetRedD(Pen.Color), GetGreenD(Pen.Color), GetBlueD(Pen.Color))
			cairo_stroke(Handle)
		#elseif defined(__USE_WINAPI__)
			If GdipToken = NULL Then
				.Rectangle Handle, ScaleX(R.Left) * imgScaleX + imgOffsetX, ScaleY(R.Top) * imgScaleY + imgOffsetY, ScaleX(R.Right) * imgScaleX + imgOffsetX, ScaleY(R.Bottom) * imgScaleY + imgOffsetY
			Else
				If GdipBrush Then GdipFillRectangle(GdipGraphics, GdipBrush, ScaleX(R.Left) * imgScaleX + imgOffsetX, ScaleY(R.Top) * imgScaleY + imgOffsetY, ScaleX(R.Right - R.Left) * imgScaleX, ScaleY(R.Bottom - R.Top) * imgScaleY)
				GdipDrawRectangle(GdipGraphics, GdipPen, ScaleX(R.Left) * imgScaleX + imgOffsetX, ScaleY(R.Top) * imgScaleY + imgOffsetY, ScaleX(R.Right - R.Left) * imgScaleX , ScaleY(R.Bottom - R.Top) * imgScaleY)
			End If
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.Ellipse Overload(x As Double, y As Double, x1 As Double, y1 As Double)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_GTK__
			cairo_move_to Handle, x * imgScaleX + imgOffsetX - 0.5, y * imgScaleY + imgOffsetY - 0.5
			cairo_set_source_rgb(Handle, GetRedD(Brush.Color), GetGreenD(Brush.Color), GetBlueD(Brush.Color))
			cairo_arc(Handle, (x + (x1 - x) / 2) * imgScaleX + imgOffsetX - 0.5, (y + (y1 - y) / 2) * imgScaleY + imgOffsetY - 0.5, ((x1 - x) / 2) * imgScaleX, 0, 2 * G_PI)
			cairo_fill_preserve(Handle)
			cairo_set_source_rgb(Handle, GetRedD(Pen.Color), GetGreenD(Pen.Color), GetBlueD(Pen.Color))
			cairo_stroke(Handle)
		#elseif defined(__USE_WINAPI__)
			If GdipToken = NULL Then
				.Ellipse(Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1) * imgScaleX + imgOffsetX, ScaleY(y1) * imgScaleY + imgOffsetY)
			Else
				If GdipBrush Then GdipFillEllipse(GdipGraphics, GdipBrush, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX((x1)) * imgScaleX, ScaleY((y1)) * imgScaleY)
				GdipDrawEllipse(GdipGraphics, GdipPen, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1) * imgScaleX, ScaleY(y1) * imgScaleY)
			End If
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.Ellipse(R As Rect)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_GTK__
			cairo_move_to Handle, R.Left * imgScaleX + imgOffsetX - 0.5, R.Top * imgScaleY + imgOffsetY - 0.5
			cairo_set_source_rgb(Handle, GetRedD(Brush.Color), GetGreenD(Brush.Color), GetBlueD(Brush.Color))
			cairo_arc(Handle, (R.Left + (R.Right - R.Left) / 2) * imgScaleX + imgOffsetX - 0.5, (R.Top + (R.Bottom - R.Top) / 2) * imgScaleY + imgOffsetY - 0.5, ((R.Right - R.Left) / 2) * imgScaleX, 0, 2 * G_PI)
			cairo_fill_preserve(Handle)
			cairo_set_source_rgb(Handle, GetRedD(Pen.Color), GetGreenD(Pen.Color), GetBlueD(Pen.Color))
			cairo_stroke(Handle)
		#elseif defined(__USE_WINAPI__)
			If GdipToken = NULL Then
				.Ellipse Handle, ScaleX(R.Left) * imgScaleX + imgOffsetX, ScaleY(R.Top) * imgScaleY + imgOffsetY, ScaleX(R.Right) * imgScaleX + imgOffsetX, ScaleY(R.Bottom) * imgScaleY + imgOffsetY
			Else
				If GdipBrush Then GdipFillEllipse(GdipGraphics, GdipBrush, ScaleX(R.Left) * imgScaleX + imgOffsetX, ScaleY(R.Top) * imgScaleY + imgOffsetY, ScaleX(R.Right - R.Left) * imgScaleX, ScaleY(R.Bottom - R.Top) * imgScaleY)
				GdipDrawEllipse(GdipGraphics, GdipPen, ScaleX(R.Left) * imgScaleX + imgOffsetX, ScaleY(R.Top) * imgScaleY + imgOffsetY, ScaleX(R.Right - R.Left) * imgScaleX, ScaleY(R.Bottom - R.Top) * imgScaleY)
			End If
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.Circle(x As Double, y As Double, Radial As Double, FillColorBK As Integer = -1)
		If Not HandleSetted Then GetDevice
		'Special code for VB6
		If FillColorBK = -1 Then FillColorBK = FBackColor
		Dim As Integer OldFillColor = Brush.Color
		Brush.Color = FillColorBK
		#ifdef __USE_GTK__
			cairo_move_to Handle, (x + Radial / 2) * imgScaleX + imgOffsetX - 0.5, y * imgScaleY + imgOffsetY - 0.5
			cairo_set_source_rgb(Handle, GetRedD(Brush.Color), GetGreenD(Brush.Color), GetBlueD(Brush.Color))
			cairo_arc(Handle, x * imgScaleX + imgOffsetX, y * imgScaleY + imgOffsetY, Radial / 2 * imgScaleX, 0, 2 * G_PI)
			cairo_fill_preserve(Handle)
			cairo_set_source_rgb(Handle, GetRedD(Pen.Color), GetGreenD(Pen.Color), GetBlueD(Pen.Color))
			cairo_stroke(Handle)
		#elseif defined(__USE_WINAPI__)
			If GdipToken = NULL Then
				.Ellipse Handle, ScaleX(x - Radial / 2) * imgScaleX + imgOffsetX, ScaleY(y - Radial / 2) * imgScaleY + imgOffsetY, ScaleX(x + Radial / 2) * imgScaleX + imgOffsetX, ScaleY(y + Radial / 2) * imgScaleY + imgOffsetY
			Else
				If GdipBrush Then GdipFillEllipse(GdipGraphics, GdipBrush, ScaleX(x - Radial / 2) * imgScaleX + imgOffsetX, ScaleY(y - Radial / 2) * imgScaleY + imgOffsetY, ScaleX(Radial) * imgScaleX, ScaleY(Radial) * imgScaleY)
				GdipDrawEllipse GdipGraphics, GdipPen, ScaleX(x - Radial / 2) * imgScaleX + imgOffsetX, ScaleY(y - Radial / 2) * imgScaleY + imgOffsetY, ScaleX(Radial) * imgScaleX, ScaleY(Radial) * imgScaleY
			End If
		#endif
		Brush.Color = OldFillColor
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.RoundRect Overload(x As Double, y As Double, x1 As Double, y1 As Double, nWidth As Integer, nHeight As Integer)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_GTK__
			Var radius = x1 - x
			cairo_set_source_rgb(Handle, GetRedD(Brush.Color), GetGreenD(Brush.Color), GetBlueD(Brush.Color))
			cairo_move_to Handle, x * imgScaleX + imgOffsetX - 0.5, (y + nWidth / 2) * imgScaleY + imgOffsetY - 0.5
			cairo_arc (Handle, (x + radius) * imgScaleX + imgOffsetX - 0.5, (y + nWidth / 2) * imgScaleY + imgOffsetY - 0.5, (nWidth / 2) * imgScaleX, G_PI, -G_PI / 2)
			cairo_line_to (Handle, (x + nWidth - nWidth / 2) * imgScaleX + imgOffsetX - 0.5, y * imgScaleY + imgOffsetY - 0.5)
			cairo_arc (Handle, (x + nWidth - nWidth / 2) * imgScaleX + imgOffsetX - 0.5, (y + nWidth / 2) * imgScaleY + imgOffsetY - 0.5, (nWidth / 2) * imgScaleX, -G_PI / 2, 0)
			cairo_line_to (Handle, (x + nWidth) * imgScaleX + imgOffsetX - 0.5, (y + nHeight - nWidth / 2) * imgScaleY + imgOffsetY - 0.5)
			cairo_arc (Handle, x + (nWidth - nWidth / 2) * imgScaleX + imgOffsetX - 0.5, (y + nHeight - nWidth / 2) * imgScaleY + imgOffsetY - 0.5, (nWidth / 2) * imgScaleX, 0, G_PI / 2)
			cairo_line_to (Handle, (x + nWidth / 2) * imgScaleX + imgOffsetX - 0.5, (y + nHeight) * imgScaleY + imgOffsetY - 0.5)
			cairo_arc (Handle, (x + nWidth / 2) * imgScaleX + imgOffsetX - 0.5, (y + nHeight - nWidth / 2) * imgScaleY + imgOffsetY - 0.5, (nWidth / 2) * imgScaleX, G_PI / 2, G_PI)
			cairo_close_path Handle
			cairo_fill_preserve(Handle)
		#elseif defined(__USE_WINAPI__)
			If GdipToken = NULL Then
				.RoundRect Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1) * imgScaleX + imgOffsetX, ScaleY(y1) * imgScaleY + imgOffsetY, ScaleX(nWidth) * imgScaleX + imgOffsetX, ScaleY(nHeight) * imgScaleY + imgOffsetY
			Else
				If GdipBrush Then GdipFillRectangle(GdipGraphics, GdipBrush, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1 - x) * imgScaleX + imgOffsetX, ScaleY(y1 - y) * imgScaleY + imgOffsetY)
				GdipDrawRectangle(GdipGraphics, GdipPen, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1 - x) * imgScaleX + imgOffsetX, ScaleY(y1 - y) * imgScaleY + imgOffsetY) ', ScaleX(nWidth) * imgScaleX + imgOffsetX, ScaleY(nHeight) * imgScaleY + imgOffsetY
				'gdipPathNew
				
			End If
			
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.Polygon(Points() As Point, Count As Long)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			If GdipToken = NULL Then
				Dim tPoints(Count - 1) As Point
				For i As Integer = 0 To Count - 1
					tPoints(i).X = ScaleX(Points(i).X) * imgScaleX + imgOffsetX : tPoints(i).Y = ScaleY(Points(i).Y) * imgScaleY + imgOffsetY
				Next
				.Polygon Handle, Cast(..Point Ptr, @tPoints(0)), Count
			Else
				Dim tGpPoints(Count - 1) As GpPointF
				For i As Integer = 0 To Count - 1
					tGpPoints(i).X = ScaleX(Points(i).X) * imgScaleX + imgOffsetX
					tGpPoints(i).Y = ScaleY(Points(i).Y) * imgScaleY + imgOffsetY
				Next
				If GdipBrush Then GdipFillPolygon GdipGraphics, GdipBrush, @tGpPoints(0), Count, FillMode
				GdipDrawPolygon GdipGraphics, GdipPen, Cast(GpPointF Ptr, @tGpPoints(0)), Count
			End If
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.RoundRect(R As Rect, nWidth As Integer, nHeight As Integer)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_GTK__
			This.RoundRect R.Left, R.Top, R.Right, R.Bottom, nWidth, nHeight
		#elseif defined(__USE_WINAPI__)
			If GdipToken = NULL Then
				.RoundRect Handle, ScaleX(R.Left) * imgScaleX + imgOffsetX, ScaleY(R.Top) * imgScaleY + imgOffsetY, ScaleX(R.Right) * imgScaleX + imgOffsetX, ScaleY(R.Bottom) * imgScaleY + imgOffsetY, ScaleX(nWidth) * imgScaleX + imgOffsetX, ScaleY(nHeight) * imgScaleY + imgOffsetY
			Else
				GdipDrawRectangle(GdipGraphics, GdipPen, ScaleX(R.Left) * imgScaleX + imgOffsetX, ScaleY(R.Top) * imgScaleY + imgOffsetY, ScaleX(R.Right - R.Left) * imgScaleX, ScaleY(R.Bottom - R.Top) * imgScaleY)
			End If
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.Chord(x As Double, y As Double, x1 As Double, y1 As Double, nXRadial1 As Double, nYRadial1 As Double, nXRadial2 As Double, nYRadial2 As Double)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			If GdipToken = NULL Then
				.Chord(Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1) * imgScaleX + imgOffsetX, ScaleY(y1) * imgScaleY + imgOffsetY, ScaleX(nXRadial1) * imgScaleX, ScaleY(nYRadial1) * imgScaleY, ScaleX(nXRadial2) * imgScaleX, ScaleY(nYRadial2) * imgScaleY)
			Else
				.Chord(Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1) * imgScaleX + imgOffsetX, ScaleY(y1) * imgScaleY + imgOffsetY, ScaleX(nXRadial1) * imgScaleX, ScaleY(nYRadial1) * imgScaleY, ScaleX(nXRadial2) * imgScaleX, ScaleY(nYRadial2) * imgScaleY)
			End If
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.Pie(x As Double, y As Double, x1 As Double, y1 As Double, nXRadial1 As Double, nYRadial1 As Double, nXRadial2 As Double, nYRadial2 As Double)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			If GdipToken = NULL Then
				.Pie(Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1) * imgScaleX + imgOffsetX, ScaleY(y1) * imgScaleY + imgOffsetY, ScaleX(nXRadial1) * imgScaleX, ScaleY(nYRadial1) * imgScaleY, ScaleX(nXRadial2) * imgScaleX , ScaleY(nYRadial2) * imgScaleY)
			Else
				If GdipBrush Then GdipFillPie(GdipGraphics, GdipBrush, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1 - x) * imgScaleX + imgOffsetX, ScaleY(y1 - x) * imgScaleY + imgOffsetY, nXRadial1, nYRadial1)
				GdipDrawPie(GdipGraphics, GdipPen, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1 - x) * imgScaleX + imgOffsetX, ScaleY(y1 - x) * imgScaleY + imgOffsetY, nXRadial1, nYRadial1)
			End If
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.Arc(x As Double, y As Double, x1 As Double, y1 As Double, xStart As Double, yStart As Double, xEnd As Double, yEnd As Double)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			If GdipToken = NULL Then
				.Arc(Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1) * imgScaleX + imgOffsetX, ScaleY(y1) * imgScaleY + imgOffsetY, ScaleX(xStart) * imgScaleX + imgOffsetX, ScaleY(yStart) * imgScaleY + imgOffsetY, ScaleX(xEnd) * imgScaleX + imgOffsetX, ScaleY(yEnd) * imgScaleY + imgOffsetY)
			Else
				.Arc(Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1) * imgScaleX + imgOffsetX, ScaleY(y1) * imgScaleY + imgOffsetY, ScaleX(xStart) * imgScaleX + imgOffsetX, ScaleY(yStart) * imgScaleY + imgOffsetY, ScaleX(xEnd) * imgScaleX + imgOffsetX, ScaleY(yEnd) * imgScaleY + imgOffsetY)
			End If
		#elseif defined(__USE_GTK__)
			cairo_move_to Handle, x * imgScaleX + imgOffsetX - 0.5, y * imgScaleY + imgOffsetY - 0.5
			cairo_arc(Handle, (x + (x1 - x) / 2) * imgScaleX + imgOffsetX - 0.5, (y + (y1 - y) / 2) * imgScaleY + imgOffsetY - 0.5, ((x1 - x) / 2) * imgScaleX, 0, G_PI * 1)
			cairo_fill_preserve(Handle)
			cairo_set_source_rgb(Handle, GetRedD(Pen.Color), GetGreenD(Pen.Color), GetBlueD(Pen.Color))
			cairo_stroke(Handle)
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.ArcTo(x As Double, y As Double, x1 As Double, y1 As Double, nXRadial1 As Double, nYRadial1 As Double, nXRadial2 As Double, nYRadial2 As Double)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			If GdipToken = NULL Then
				.ArcTo Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1) * imgScaleX + imgOffsetX, ScaleY(y1) * imgScaleY + imgOffsetY, ScaleX(nXRadial1) * imgScaleX , ScaleY(nYRadial1) * imgScaleY, ScaleX(nXRadial2) * imgScaleX, ScaleY(nYRadial2) * imgScaleY
			Else
				.ArcTo Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1) * imgScaleX + imgOffsetX, ScaleY(y1) * imgScaleY + imgOffsetY, ScaleX(nXRadial1) * imgScaleX , ScaleY(nYRadial1) * imgScaleY, ScaleX(nXRadial2) * imgScaleX, ScaleY(nYRadial2) * imgScaleY
			End If
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.AngleArc(x As Double, y As Double, Radius As Double, StartAngle As Double, SweepAngle As Double)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			If GdipToken = NULL Then
				.AngleArc Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(Radius) * imgScaleX, StartAngle, SweepAngle
			Else
				GdipDrawArc(GdipGraphics, GdipPen, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(Radius) * imgScaleX, ScaleY(Radius) * imgScaleY, StartAngle, SweepAngle)
			End If
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.Polyline(Points() As Point, Count As Long)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			If GdipToken = NULL Then
				Dim tPoints(Count - 1) As Point
				For i As Integer = 0 To Count - 1
					tPoints(i).X = ScaleX(Points(i).X) * imgScaleX + imgOffsetX : tPoints(i).Y = ScaleY(Points(i).Y) * imgScaleY + imgOffsetY
				Next
				.Polyline Handle, Cast(..Point Ptr, @tPoints(0)), Count
				.ExtFloodFill Handle, (tPoints(0).X + tPoints(Count \ 2).X) / 2, (tPoints(0).Y + tPoints(Count \ 2).Y) / 2, FFillColor, FillStyle.fsSurface
			Else
				Dim tGpPoints(Count - 1) As GpPointF
				For i As Integer = 0 To Count - 1
					tGpPoints(i).X = ScaleX(Points(i).X) * imgScaleX + imgOffsetX
					tGpPoints(i).Y = ScaleY(Points(i).Y) * imgScaleY + imgOffsetY
				Next
				If GdipBrush Then GdipFillPolygon(GdipGraphics, GdipBrush, Cast(GpPointF Ptr, @tGpPoints(0)), Count, FillMode)
				GdipDrawPolygon GdipGraphics, GdipPen, Cast(GpPointF Ptr, @tGpPoints(0)), Count
			End If
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.PolylineTo(Points() As Point, Count As Long)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			If GdipToken = NULL Then
				Dim tPoints(Count - 1) As Point
				For i As Integer = 0 To Count - 1
					tPoints(i).X = ScaleX(Points(i).X) * imgScaleX + imgOffsetX : tPoints(i).Y = ScaleY(Points(i).Y) * imgScaleY + imgOffsetY
				Next
				.PolylineTo Handle, Cast(..Point Ptr, @tPoints(0)), Count
			Else
				Dim tGpPoints(Count - 1) As GpPointF
				For i As Integer = 0 To Count - 1
					tGpPoints(i).X = ScaleX(Points(i).X) * imgScaleX + imgOffsetX
					tGpPoints(i).Y = ScaleY(Points(i).Y) * imgScaleY + imgOffsetY
				Next
				If GdipBrush Then GdipFillPolygon GdipGraphics, GdipBrush, Cast(GpPointF Ptr, @tGpPoints(0)), Count, FillMode
				GdipDrawPolygon GdipGraphics, GdipPen, Cast(GpPointF Ptr, @tGpPoints(0)), Count
			End If
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.PolyBeizer(Points() As Point, Count As Long)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			If GdipToken = NULL Then
				Dim tPoints(Count - 1) As Point
				For i As Integer = 0 To Count - 1
					tPoints(i).X = ScaleX(Points(i).X) * imgScaleX + imgOffsetX : tPoints(i).Y = ScaleY(Points(i).Y) * imgScaleY + imgOffsetY
				Next
				.PolyBezier Handle, Cast(..Point Ptr, @tPoints(0)), Count
			Else
				Dim tGpPoints(Count - 1) As GpPointF
				For i As Integer = 0 To Count - 1
					tGpPoints(i).X = ScaleX(Points(i).X) * imgScaleX + imgOffsetX
					tGpPoints(i).Y = ScaleY(Points(i).Y) * imgScaleY + imgOffsetY
				Next
				If GdipBrush Then GdipFillClosedCurve(GdipGraphics, GdipBrush, Cast(GpPointF Ptr, @tGpPoints(0)), Count)
				GdipDrawBeziers(GdipGraphics, GdipPen, Cast(GpPointF Ptr, @tGpPoints(0)), Count)
			End If
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.PolyBeizerTo(Points() As Point, Count As Long)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			If GdipToken = NULL Then
				Dim tPoints(Count - 1) As Point
				For i As Integer = 0 To Count - 1
					tPoints(i).X = ScaleX(Points(i).X) * imgScaleX + imgOffsetX : tPoints(i).Y = ScaleY(Points(i).Y) * imgScaleY + imgOffsetY
				Next
				.PolyBezierTo Handle, Cast(..Point Ptr, @tPoints(0)), Count
			Else
				Dim tGpPoints(Count - 1) As GpPointF
				For i As Integer = 0 To Count - 1
					tGpPoints(i).X = ScaleX(Points(i).X) * imgScaleX + imgOffsetX
					tGpPoints(i).Y = ScaleY(Points(i).Y) * imgScaleY + imgOffsetY
				Next
				'GdipFillPolygon GdipGraphics, GdipPen, Cast(GpPointF Ptr, @tGpPoints(0)), Count
				GdipDrawBeziers GdipGraphics, GdipPen, Cast(GpPointF Ptr, @tGpPoints(0)), Count
			End If
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.SetPixel(x As Double, y As Double, PixelColor As Integer)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_GTK__
			cairo_set_source_rgb(Handle, GetRed(PixelColor) / 255.0, GetBlue(PixelColor) / 255.0, GetGreen(PixelColor) / 255.0)
			.cairo_rectangle(Handle, x * imgScaleX + imgOffsetX, y * imgScaleY + imgOffsetY, 1, 1)
			cairo_fill(Handle)
		#elseif defined(__USE_WINAPI__)
			.SetPixel Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, PixelColor
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Function Canvas.GetPixel(x As Double, y As Double) As Integer
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			Function = .GetPixel(Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY)
		#else
			Function = 0
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Function
	
	Private Sub Canvas.TextOut(x As Double, y As Double, ByRef s As WString, FG As Integer = -1, BK As Integer = -1)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_GTK__
			Dim As PangoRectangle extend2
			Dim As Double iRed, iGreen, iBlue
			pango_layout_set_text(layout, ToUtf8(s), Len(ToUtf8(s)))
			pango_cairo_update_layout(Handle, layout)
			#ifdef pango_version
				Dim As PangoLayoutLine Ptr pl = pango_layout_get_line_readonly(layout, 0)
			#else
				Dim As PangoLayoutLine Ptr pl = pango_layout_get_line(layout, 0)
			#endif
			pango_layout_line_get_pixel_extents(pl, NULL, @extend2)
			If BK <> -1 Then
				iRed = Abs(GetRed(BK) / 255.0): iGreen = Abs(GetGreen(BK) / 255.0): iBlue = Abs(GetBlue(BK) / 255.0)
				cairo_set_source_rgb(Handle, iRed, iGreen, iBlue)
				.cairo_rectangle (Handle, x * imgScaleX + imgOffsetX, y * imgScaleY + imgOffsetY, extend2.width, extend2.height)
				cairo_fill (Handle)
			End If
			cairo_move_to(Handle, x * imgScaleX + imgOffsetX + 0.5, y * imgScaleY + imgOffsetY + extend2.height + 0.5)
			If FG = -1 Then
				iRed = Abs(GetRed(Font.Color) / 255.0): iGreen = Abs(GetGreen(Font.Color) / 255.0): iBlue = Abs(GetBlue(Font.Color) / 255.0)
			Else
				iRed = Abs(GetRed(FG) / 255.0): iGreen = Abs(GetGreen(FG) / 255.0): iBlue = Abs(GetBlue(FG) / 255.0)
			End If
			iRed = Abs(GetRed(FG) / 255.0): iGreen = Abs(GetGreen(FG) / 255.0): iBlue = Abs(GetBlue(FG) / 255.0)
			cairo_set_source_rgb(Handle, iRed, iGreen, iBlue)
			pango_cairo_show_layout_line(Handle, pl)
		#elseif defined(__USE_WINAPI__)
			SetBkMode Handle, TRANSPARENT
			If FG = -1 Then SetTextColor(Handle, Font.Color) Else SetTextColor(Handle, FG)
			If BK = -1 Then
				Brush = GetStockObject(NULL_BRUSH)
			Else
				SetBkColor(Handle, BK)
				SetBkMode(Handle, OPAQUE)
			End If
			.TextOut(Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, @s, Len(s))
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Function Canvas.Get(x As Double, y As Double, nWidth As Integer, nHeight As Integer, ByRef ImageSource As My.Sys.Drawing.BitmapType) As Any Ptr
		Return Get(x, y, nWidth , nHeight, ImageSource.Handle)
	End Function
	
	Private Function Canvas.Get(x As Double, y As Double, nWidth As Integer, nHeight As Integer, ByVal ImageSource As Any Ptr) As Any Ptr
		If Not HandleSetted Then GetDevice
		#ifdef __USE_GTK__
			Dim As GdkPixbuf Ptr ImageDest
			If nWidth <> 0 AndAlso nHeight <> 0 Then
				ImageDest = gdk_pixbuf_new(GDK_COLORSPACE_RGB, True, 8 , nWidth, nHeight)
				If ImageDest Then
					gdk_pixbuf_copy_area(ImageSource, x, y, nWidth, nHeight, ImageDest, 0, 0)
					Return ImageDest
				End If
			End If
			Return 0
		#elseif defined(__USE_WINAPI__)
			Dim As GpImage Ptr pImage1
			Dim As GpImage Ptr pImage2
			Dim As HBITMAP     ImageDest
			' // Initialize Gdiplus
			Dim token As ULONG_PTR, StartupInput As GdiplusStartupInput
			If GdipToken = NULL Then
				StartupInput.GdiplusVersion = 1
				GdiplusStartup(@token, @StartupInput, NULL)
				If token = NULL Then Return False
			End If
			GdipCreateBitmapFromHBITMAP(ImageSource, NULL, Cast(GpBitmap Ptr Ptr, @pImage1))
			GdipCloneBitmapArea (x, y, nWidth, nHeight, 0, Cast(GpBitmap Ptr , pImage1) , Cast(GpBitmap Ptr Ptr, @pImage2))
			GdipCreateHBITMAPFromBitmap(Cast(GpBitmap Ptr , pImage2) , @ImageDest, 0)
			' // Free the image
			If pImage1 Then GdipDisposeImage pImage1
			If pImage2 Then GdipDisposeImage pImage2
			If GdipToken = NULL Then
				' // Shutdown Gdiplus
				GdiplusShutdown token
			End If
			Return ImageDest
		#endif
		If Not HandleSetted Then ReleaseDevice
		Return 0
	End Function
	
	Private Sub Canvas.DrawAlpha(x As Double, y As Double, nWidth As Double = -1, nHeight As Double = -1, ByRef Image As My.Sys.Drawing.BitmapType, iSourceAlpha As Integer = 255)
		DrawAlpha(x, y, nWidth, nHeight, Image.Handle, iSourceAlpha)
	End Sub
	
	Private Sub Canvas.DrawAlpha(x As Double, y As Double, nWidth As Double = -1, nHeight As Double = -1, ByVal Image As Any Ptr, iSourceAlpha As Integer = 255)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			Dim As HDC hMemDC = CreateCompatibleDC(Handle) ' Create Dc
			SelectObject(hMemDC, Image) ' Select BITMAP in New Dc
			
			Dim As BITMAP Bitmap01
			GetObject(Image, SizeOf(Bitmap01), @Bitmap01)
			
			Dim As BLENDFUNCTION bfn ' Struct With info For AlphaBlend
			bfn.BlendOp = AC_SRC_OVER
			bfn.BlendFlags = 0
			bfn.SourceConstantAlpha = iSourceAlpha
			bfn.AlphaFormat = AC_SRC_ALPHA
			If nWidth = -1 Then nWidth = Bitmap01.bmWidth
			If nHeight = -1 Then nHeight = Bitmap01.bmHeight
			SetStretchBltMode(Handle, HALFTONE)
			AlphaBlend(Handle, x, y, nWidth, nHeight, hMemDC, 0, 0, Bitmap01.bmWidth, Bitmap01.bmHeight, bfn) ' Display BITMAP
			DeleteDC(hMemDC) ' Delete Dc
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.Draw(x As Double, y As Double, Image As Any Ptr)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			Dim As HDC MemDC
			Dim As HBITMAP OldBitmap
			Dim As BITMAP Bitmap01
			MemDC = CreateCompatibleDC(Handle)
			OldBitmap = SelectObject(MemDC, Cast(HBITMAP, Image))
			GetObject(Cast(HBITMAP, Image), SizeOf(Bitmap01), @Bitmap01)
			BitBlt(Handle, ScaleX(x), ScaleY(y), Bitmap01.bmWidth, Bitmap01.bmHeight, MemDC, 0, 0, SRCCOPY)
			SelectObject(MemDC, OldBitmap)
			DeleteDC(MemDC)
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.Draw(x As Double, y As Double, ByRef Image As My.Sys.Drawing.BitmapType)
		This.Draw(x, y, Image.Handle)
	End Sub
	
	Private Sub Canvas.Draw(x As Double, y As Double, ByRef Image As My.Sys.Drawing.Icon)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			DrawIconEx(Handle, x, y, Image.Handle, Image.Width, Image.Height, 0, 0, DI_NORMAL)
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	#ifndef Canvas_DrawTransparent_Off
		Private Sub Canvas.DrawTransparent(x As Double, y As Double, Image As Any Ptr, cTransparentColor As UInteger = 0)
			If Not HandleSetted Then GetDevice
			#ifdef __USE_WINAPI__
				Dim As BITMAP     bm
				Dim As COLORREF   cColor
				Dim As HBITMAP    bmAndBack, bmAndObject, bmAndMem, bmSave
				Dim As HBITMAP    bmBackOld, bmObjectOld, bmMemOld, bmSaveOld
				Dim As HDC        hdcMem, hdcBack, hdcObject, hdcTemp, hdcSave
				Dim As ..Point      ptSize
				
				hdcTemp = CreateCompatibleDC(Handle)
				SelectObject(hdcTemp, Cast(HBITMAP, Image))   ' Выбираем битмап
				
				GetObject(Cast(HBITMAP, Image), SizeOf(BITMAP), Cast(LPSTR, @bm))
				ptSize.X = bm.bmWidth            ' Получаем ширину битмапа
				ptSize.Y = bm.bmHeight           ' Получаем высоту битмапа
				DPtoLP(hdcTemp, @ptSize, 1)      ' Конвертируем из координат
				' устройства в логические
				' точки
				
				' Создаём несколько DC для хранения временных данных.
				hdcBack   = CreateCompatibleDC(Handle)
				hdcObject = CreateCompatibleDC(Handle)
				hdcMem    = CreateCompatibleDC(Handle)
				hdcSave   = CreateCompatibleDC(Handle)
				
				' Создаём битмап для каждого DC.
				
				' Монохромный DC
				bmAndBack   = CreateBitmap(ptSize.X, ptSize.Y, 1, 1, NULL)
				
				' Монохромный DC
				bmAndObject = CreateBitmap(ptSize.X, ptSize.Y, 1, 1, NULL)
				
				bmAndMem    = CreateCompatibleBitmap(Handle, ptSize.X, ptSize.Y)
				bmSave      = CreateCompatibleBitmap(Handle, ptSize.X, ptSize.Y)
				
				' В каждом DC должен быть выбран объект битмапа для хранения
				' пикселей.
				bmBackOld   = SelectObject(hdcBack, bmAndBack)
				bmObjectOld = SelectObject(hdcObject, bmAndObject)
				bmMemOld    = SelectObject(hdcMem, bmAndMem)
				bmSaveOld   = SelectObject(hdcSave, bmSave)
				
				' Устанавливаем режим маппинга.
				SetMapMode(hdcTemp, GetMapMode(Handle))
				
				' Сохраняем битмап, переданный в параметре функции, так как
				' он будет изменён.
				BitBlt(hdcSave, 0, 0, ptSize.X, ptSize.Y, hdcTemp, 0, 0, SRCCOPY)
				
				' Устанавливаем фоновый цвет (в исходном DC) тех частей,
				' которые будут прозрачными.
				cColor = SetBkColor(hdcTemp, cTransparentColor)
				
				' Создаём маску для битмапа путём вызова BitBlt из исходного
				' битмапа на монохромный битмап.
				BitBlt(hdcObject, 0, 0, ptSize.X, ptSize.Y, hdcTemp, 0, 0, SRCCOPY)
				
				' Устанавливаем фоновый цвет исходного DC обратно в
				' оригинальный цвет.
				SetBkColor(hdcTemp, cColor)
				
				' Создаём инверсию маски.
				BitBlt(hdcBack, 0, 0, ptSize.X, ptSize.Y, hdcObject, 0, 0, NOTSRCCOPY)
				
				' Копируем фон главного DC в конечный.
				BitBlt(hdcMem, 0, 0, ptSize.X, ptSize.Y, Handle, x, y, SRCCOPY)
				
				' Накладываем маску на те места, где будет помещён битмап.
				BitBlt(hdcMem, 0, 0, ptSize.X, ptSize.Y, hdcObject, 0, 0, SRCAND)
				
				' Накладываем маску на прозрачные пиксели битмапа.
				BitBlt(hdcTemp, 0, 0, ptSize.X, ptSize.Y, hdcBack, 0, 0, SRCAND)
				
				' Xor-им битмап с фоном на конечном DC.
				BitBlt(hdcMem, 0, 0, ptSize.X, ptSize.Y, hdcTemp, 0, 0, SRCPAINT)
				
				' Копируем на экран.
				BitBlt(Handle, x, y, ptSize.X, ptSize.Y, hdcMem, 0, 0, SRCCOPY)
				
				' Помещаем оригинальный битмап обратно в битмап, переданный в
				' параметре функции.
				BitBlt(hdcTemp, 0, 0, ptSize.X, ptSize.Y, hdcSave, 0, 0, SRCCOPY)
				
				' Удаляем битмапы из памяти.
				DeleteObject(SelectObject(hdcBack, bmBackOld))
				DeleteObject(SelectObject(hdcObject, bmObjectOld))
				DeleteObject(SelectObject(hdcMem, bmMemOld))
				DeleteObject(SelectObject(hdcSave, bmSaveOld))
				
				' Удаляем DC из памяти.
				DeleteDC(hdcMem)
				DeleteDC(hdcBack)
				DeleteDC(hdcObject)
				DeleteDC(hdcSave)
				DeleteDC(hdcTemp)
			#endif
			If Not HandleSetted Then ReleaseDevice
		End Sub
		
		Private Sub Canvas.DrawTransparent(x As Double, y As Double, ByRef Image As My.Sys.Drawing.BitmapType, cTransparentColor As UInteger = 0)
			DrawTransparent ScaleX(x), ScaleY(y), Image.Handle, cTransparentColor
		End Sub
	#endif
	
	Private Sub Canvas.DrawStretch(x As Double, y As Double, nWidth As Integer, nHeight As Integer, Image As Any Ptr)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			Dim As HDC MemDC
			Dim As HBITMAP OldBitmap
			Dim As BITMAP Bitmap01
			MemDC = CreateCompatibleDC(Handle)
			OldBitmap = SelectObject(MemDC, Cast(HBITMAP, Image))
			GetObject(Cast(HBITMAP, Image), SizeOf(Bitmap01), @Bitmap01)
			SetStretchBltMode(Handle, HALFTONE)
			'SetStretchBltMode(Handle, COLORONCOLOR)
			StretchBlt(Handle, ScaleX(x), ScaleY(y), ScaleX(nWidth), ScaleX(nHeight), MemDC, 0, 0, Bitmap01.bmWidth, Bitmap01.bmHeight, SRCCOPY)
			SelectObject(MemDC, OldBitmap)
			DeleteDC(MemDC)
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.CopyRect(Dest As Rect, Canvas As Canvas, Source As Rect)
		If Not HandleSetted Then GetDevice
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.FloodFill(x As Double, y As Double, FillColorBK As Integer = -1, FillStyleBK As FillStyle)
		If Not HandleSetted Then GetDevice
		If FillColorBK = -1 Then FillColorBK = FBackColor
		#ifdef __USE_WINAPI__
			.ExtFloodFill Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, FillColorBK, FillStyleBK
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.FillRect(R As Rect, FillColorBK As Integer = -1)
		If Not HandleSetted Then GetDevice
		If FillColorBK = -1 Then FillColorBK = FBackColor
		#ifdef __USE_GTK__
			cairo_set_source_rgb(Handle, GetRed(FillColorBK), GetBlue(FillColorBK), GetGreen(FillColorBK))
			.cairo_rectangle(Handle, R.Left * imgScaleX + imgOffsetX - 0.5, R.Top * imgScaleX + imgOffsetX - 0.5, R.Right - R.Left - 0.5, R.Bottom - R.Top - 0.5)
			cairo_fill_preserve(Handle)
		#elseif defined(__USE_WINAPI__)
			Static As HBRUSH B
			If B Then DeleteObject B
			R.Left = ScaleX(R.Left) * imgScaleX + imgOffsetX
			R.Top = ScaleY(R.Top) * imgScaleY + imgOffsetY
			R.Right = ScaleX(R.Right) * imgScaleX + imgOffsetX
			R.Bottom = ScaleY(R.Bottom) * imgScaleY + imgOffsetY
			If FillColorBK <> -1 Then
				B = CreateSolidBrush(FillColorBK)
				.FillRect Handle, Cast(..Rect Ptr, @R), B
			Else
				.FillRect Handle, Cast(..Rect Ptr, @R), Brush.Handle
			End If
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.DrawFocusRect(R As Rect)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			R.Left = ScaleX(R.Left) * imgScaleX + imgOffsetX
			R.Top = ScaleY(R.Top) * imgScaleY + imgOffsetY
			R.Right = ScaleX(R.Right) * imgScaleX + imgOffsetX
			R.Bottom = ScaleY(R.Bottom) * imgScaleY + imgOffsetY
			.DrawFocusRect Handle, Cast(..Rect Ptr, @R)
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Function Canvas.TextWidth(ByRef FText As WString) As Integer
		If Not HandleSetted Then GetDevice
		#ifdef __USE_GTK__
			Dim As PangoRectangle extend
			Dim As PangoFontDescription Ptr desc
			desc = pango_font_description_from_string(Font.Name & " " & Font.Size)
			pango_layout_set_font_description (layout, desc)
			pango_layout_set_text(layout, ToUtf8(FText), Len(ToUtf8(FText)))
			pango_cairo_update_layout(Handle, layout)
			#ifdef pango_version
				Dim As PangoLayoutLine Ptr pl = pango_layout_get_line_readonly(layout, 0)
			#else
				Dim As PangoLayoutLine Ptr pl = pango_layout_get_line(layout, 0)
			#endif
			pango_layout_line_get_pixel_extents(pl, NULL, @extend)
			pango_font_description_free (desc)
			Function = UnScaleX(extend.width)
		#elseif defined(__USE_JNI__) OrElse defined(__USE_WASM__)
			Function = 0
		#elseif defined(__USE_WINAPI__)
			Dim Sz As ..Size
			GetTextExtentPoint32(Handle, @FText, Len(FText), @Sz)
			Function = UnScaleX(Sz.cx)
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Function
	
	Private Function Canvas.TextHeight(ByRef FText As WString) As Integer
		If Not HandleSetted Then GetDevice
		#ifdef __USE_GTK__
			Dim As PangoRectangle extend
			Dim As PangoFontDescription Ptr desc
			desc = pango_font_description_from_string(Font.Name & " " & Font.Size)
			pango_layout_set_font_description (layout, desc)
			pango_layout_set_text(layout, ToUtf8(FText), Len(ToUtf8(FText)))
			pango_cairo_update_layout(Handle, layout)
			#ifdef pango_version
				Dim As PangoLayoutLine Ptr pl = pango_layout_get_line_readonly(layout, 0)
			#else
				Dim As PangoLayoutLine Ptr pl = pango_layout_get_line(layout, 0)
			#endif
			pango_layout_line_get_pixel_extents(pl, NULL, @extend)
			pango_font_description_free (desc)
			Function = extend.height
		#elseif defined(__USE_JNI__) OrElse defined(__USE_WASM__)
			Function = 0
		#elseif defined(__USE_WINAPI__)
			Dim Sz As ..Size
			GetTextExtentPoint32(Handle, @FText, Len(FText), @Sz)
			Function = UnScaleY(Sz.cy)
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Function
	
	Private Operator Canvas.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Sub Canvas.Font_Create(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.Font)
		#ifdef __USE_WINAPI__
			With *Cast(Canvas Ptr, Sender.Parent)
				If .Handle Then SelectObject(.Handle, Sender.Handle)
			End With
		#endif
	End Sub
	
	Private Sub Canvas.Pen_Create(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.Pen)
		#ifdef __USE_WINAPI__
			With *Cast(Canvas Ptr, Sender.Parent)
				If .Handle Then
					SelectObject(.Handle, Sender.Handle)
					SetROP2 .Handle, Sender.Mode
				End If
				If .GdipToken <> NULL Then
					If .GdipPen Then GdipDeletePen(.GdipPen)
					GdipCreatePen1(RGBtoARGB(.Pen.Color, .BackColorOpacity), .FDrawWidth, &H2, @.GdipPen)
				End If
			End With
		#endif
	End Sub
	
	Private Sub Canvas.Brush_Create(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.Brush)
		#ifdef __USE_WINAPI__
			With *Cast(Canvas Ptr, Sender.Parent)
				If .Handle Then SelectObject(.Handle, Sender.Handle)
				If .GdipToken <> NULL Then
					If .GdipBrush Then GdipDeleteBrush(.GdipBrush)
					GdipCreateSolidFill(RGBtoARGB(.FFillColor, .FillOpacity), Cast(GpSolidFill Ptr Ptr, @.GdipBrush))
				End If
			End With
		#endif
	End Sub
	
	Private Constructor Canvas
		Clip = False
		WLet(FClassName, "Canvas")
		#ifdef __USE_WINAPI__
			GdipToken = NULL
		#endif
		Font.Parent = @This
		Font.OnCreate = @Font_Create
		Pen.Parent = @This
		Pen.OnCreate = @Pen_Create
		Brush.Parent = @This
		Brush.OnCreate = @Brush_Create
		'Brush.Style = BrushStyles.bsClear
		Brush.Style = BrushStyles.bsSolid
		imgScaleX = 1
		imgScaleY = 1
		FDrawWidth = 1
		FScaleWidth = ScaleX(This.Width)
		FScaleHeight = ScaleY(This.Height)
		FillOpacity = 50
		BackColorOpacity = 100
	End Constructor
	
	Private Destructor Canvas
		#ifdef __USE_WINAPI__
			If memDC > 0 Then DeleteDoubleBuffer
			If Handle Then ReleaseDevice
			' // Shutdown Gdiplus
			If GdipToken <> NULL Then
				If GdipPen Then GdipDeletePen(GdipPen)
				If GdipBrush Then GdipDeleteBrush(GdipBrush)
				If GdipGraphics Then GdipDeleteGraphics(GdipGraphics)
				If GdipToken Then GdiplusShutdown(GdipToken)
			End If
		#endif
	End Destructor
End Namespace
