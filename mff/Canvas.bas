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
		FFillColor = Value
		#ifdef __USE_WINAPI__
			SetBkColor Handle, FFillColor
			'Brush.Color = FFillColor
			'FloodFill(1, 1, FFillColor, FillStyle.fsSurface)
		#endif
	End Property
	
	Private Property Canvas.FillMode As BrushFillMode
		Return FFillMode
	End Property
	
	Private Property Canvas.FillMode(Value As BrushFillMode)
		FFillMode = Value
		#ifdef __USE_WINAPI__
			SetBkMode Handle, FFillMode
		#endif
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
		Return FDrawWidth
	End Property
	
	Private Property Canvas.DrawWidth(Value As Integer)
		#ifdef __USE_GTK__
		#elseif defined(__USE_WINAPI__)
			FDrawWidth = Value
			Pen.Size = Value
		#endif
	End Property
	
	Private Sub Canvas.Cls(x As Double = 0, y As Double = 0, x1 As Double = 0, y1 As Double = 0)
		If Not HandleSetted Then GetDevice
		If ParentControl > 0 Then
			#ifdef __USE_GTK__
				cairo_set_source_rgb(Handle, GetRed(FBackColor), GetBlue(FBackColor), GetGreen(FBackColor))
				cairo_fill_preserve(Handle)
			#elseif defined(__USE_WINAPI__)
				Dim As HBRUSH B = CreateSolidBrush(FBackColor)
				Dim As ..Rect R
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
				Else
					R.left = ScaleX(x) * imgScaleX + imgOffsetX
					R.top = ScaleY(y) * imgScaleY + imgOffsetY
					R.right = ScaleX(x1) * imgScaleX + imgOffsetX
					R.bottom = ScaleY(y1) * imgScaleY + imgOffsetY
				End If
				.FillRect Handle, Cast(..RECT Ptr, @R), B
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
			Return .GetPixel(Handle, ScaleX(xy.x), ScaleY(xy.y))
		#else
			Return 0
		#endif
		ReleaseDevice
	End Property
	
	Private Property Canvas.Pixel(xy As Point, Value As Integer)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_GTK__
			cairo_set_source_rgb(Handle, GetRed(Value) / 255.0, GetBlue(Value) / 255.0, GetGreen(Value) / 255.0)
			.cairo_rectangle(Handle, xy.x, xy.y, 1, 1)
			cairo_fill(Handle)
		#elseif defined(__USE_WINAPI__)
			.SetPixel(Handle, ScaleX(xy.X) * imgScaleX + imgOffsetX, ScaleY(xy.Y) * imgScaleY + imgOffsetY, Value)
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Property
	
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
	
	Private Sub Canvas.CreateDoubleBuffer
		#ifdef __USE_WINAPI__
			If Not HandleSetted Then GetDevice
			DC = Handle
			memDC = CreateCompatibleDC(DC)
			CompatibleBmp = CreateCompatibleBitmap(DC, ScaleX(This.Width) , ScaleY(This.Height))
			SelectObject(memDC, CompatibleBmp)
			Handle = memDC
			HandleSetted = True
			FDoubleBuffer = True
		#endif
	End Sub
	
	Private Sub Canvas.DeleteDoubleBuffer
		#ifdef __USE_WINAPI__
			If Not FDoubleBuffer Then Exit Sub
			#ifdef __USE_WINAPI__
				BitBlt(DC, 0, 0, ScaleX(This.Width), ScaleY(This.Height), memDC, 0, 0, SRCCOPY)
			#endif
			Handle = DC
			HandleSetted = False
			DeleteObject(CompatibleBmp)
			DeleteDC(memDC)
			FDoubleBuffer = False
			If Not HandleSetted Then ReleaseDevice
		#endif
	End Sub
	
	Private Sub Canvas.Scale(x As Double, y As Double, x1 As Double, y1 As Double)
		If ParentControl Then
			imgScaleX = Min(ParentControl->Width, ParentControl->Height) / (x1 - x)
			imgScaleY = Min(ParentControl->Width, ParentControl->Height) / (y1 - y)
			imgOffsetX = IIf(ParentControl->Width > ParentControl->Height, (ParentControl->Width - ParentControl->Height) / 2 - x * imgScaleX, -x * imgScaleX)
			imgOffsetY = IIf(ParentControl->Height > ParentControl->Width, (ParentControl->Height - ParentControl->Width) / 2 - y * imgScaleY, -y * imgScaleY)
			FScaleWidth = x1 - x
			FScaleHeight = y1 - y
		Else
			imgScaleX = 1
			imgScaleY = 1
			imgOffsetX = 0
			imgOffsetY = 0
			FDrawWidth = 1
			FScaleWidth = This.Width
			FScaleHeight =  This.Height
		End If
	End Sub
	
	Private Sub Canvas.MoveTo(x As Double, y As Double)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_GTK__
			cairo_move_to(Handle, x - 0.5, y - 0.5)
		#elseif defined(__USE_WINAPI__)
			.MoveToEx Handle, ScaleX(x) * imgScaleX + imgOffsetX , ScaleY(y) * imgScaleY + imgOffsetY, 0
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.LineTo(x As Double, y As Double)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_GTK__
			cairo_line_to(Handle, x - 0.5, y - 0.5)
			cairo_stroke(Handle)
		#elseif defined(__USE_WINAPI__)
			.LineTo Handle, ScaleX(x) * imgScaleX + imgOffsetX , ScaleY(y) * imgScaleY + imgOffsetY
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
				Rectangle(x, y, x1, y1)
				Brush.Color = OldFillColor
			Else
				Rectangle(x, y, x1, y1)
			End If
		Else
			#ifdef __USE_GTK__
				cairo_move_to(Handle, x * imgScaleX + imgOffsetX - 0.5, y * imgScaleY + imgOffsetY - 0.5)
				cairo_line_to(Handle, x1 * imgScaleX + imgOffsetX - 0.5, y1 * imgScaleY + imgOffsetY - 0.5)
				cairo_stroke(Handle)
			#elseif defined(__USE_WINAPI__)
				Dim As Integer OldPenColor
				If FillColorBk <> -1 Then
					OldPenColor = Pen.Color
					Pen.Color = FillColorBk
				End If
				.MoveToEx Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, 0
				.LineTo Handle, ScaleX(x1) * imgScaleX + imgOffsetX, ScaleY(y1) * imgScaleY + imgOffsetY
				If FillColorBk <> -1 Then Pen.Color = OldPenColor
			#endif
			
		End If
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	#ifndef Canvas_Rectangle_Double_Double_Double_Double_Off
		Private Sub Canvas.Rectangle Overload(x As Double, y As Double, x1 As Double, y1 As Double)
			If Not HandleSetted Then GetDevice
			#ifdef __USE_GTK__
				cairo_move_to (Handle, x - 0.5, y - 0.5)
				cairo_line_to (Handle, x1 - 0.5, y - 0.5)
				cairo_line_to (Handle, x1 - 0.5, y1 - 0.5)
				cairo_line_to (Handle, x - 0.5, y1 - 0.5)
				cairo_line_to (Handle, x - 0.5, y - 0.5)
				cairo_set_source_rgb(Handle, GetRedD(Brush.Color), GetGreenD(Brush.Color), GetBlueD(Brush.Color))
				cairo_fill_preserve(Handle)
				cairo_set_source_rgb(Handle, GetRedD(Pen.Color), GetGreenD(Pen.Color), GetBlueD(Pen.Color))
				cairo_stroke(Handle)
			#elseif defined(__USE_WINAPI__)
				.Rectangle Handle, ScaleX(x) * imgScaleX + imgOffsetX , ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1) * imgScaleX + imgOffsetX , ScaleY(y1) * imgScaleY + imgOffsetY
			#endif
			If Not HandleSetted Then ReleaseDevice
		End Sub
	#endif
	
	Private Sub Canvas.Rectangle(R As Rect)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_GTK__
			.cairo_rectangle(Handle, R.Left - 0.5, R.Top - 0.5, R.Right - R.Left - 0.5, R.Bottom - R.Top - 0.5)
			cairo_set_source_rgb(Handle, GetRedD(Brush.Color), GetGreenD(Brush.Color), GetBlueD(Brush.Color))
			cairo_fill_preserve(Handle)
			cairo_set_source_rgb(Handle, GetRedD(Pen.Color), GetGreenD(Pen.Color), GetBlueD(Pen.Color))
			cairo_stroke(Handle)
		#elseif defined(__USE_WINAPI__)
			.Rectangle Handle, ScaleX(R.Left) * imgScaleX + imgOffsetX, ScaleY(R.Top) * imgScaleY + imgOffsetY, ScaleX(R.Right) * imgScaleX + imgOffsetX, ScaleY(R.Bottom) * imgScaleY + imgOffsetY
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.Ellipse Overload(x As Double, y As Double, x1 As Double, y1 As Double)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_GTK__
			cairo_arc(Handle, x + (x1 - x) / 2 - 0.5, y + (y1 - y) / 2 - 0.5, (x1 - x) / 2, 0, 2 * G_PI)
			cairo_fill_preserve(Handle)
			'			cairo_set_source_rgb(cr, 0.0, 0.0, 0.0)
			'			cairo_stroke(cr)
		#elseif defined(__USE_WINAPI__)
			.Ellipse Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1) * imgScaleX + imgOffsetX, ScaleY(y1) * imgScaleY + imgOffsetY
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.Ellipse(R As Rect)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_GTK__
			cairo_arc(Handle, R.Left + (R.Right - R.Left) / 2 - 0.5, R.Top + (R.Bottom - R.Top) / 2 - 0.5, (R.Right - R.Left) / 2, 0, 2 * G_PI)
			cairo_fill_preserve(Handle)
		#elseif defined(__USE_WINAPI__)
			.Ellipse Handle, ScaleX(R.Left) * imgScaleX + imgOffsetX, ScaleY(R.Top) * imgScaleY + imgOffsetY, ScaleX(R.Right) * imgScaleX + imgOffsetX, ScaleY(R.Bottom) * imgScaleY + imgOffsetY
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.Circle(x As Double, y As Double, Radial As Double, FillColorBK As Integer = -1)
		If Not HandleSetted Then GetDevice
		'Special code for VB6
		If FillColorBk = -1 Then FillColorBk = FBackColor
		Dim As Integer OldFillColor = Brush.Color
		Brush.Color = FillColorBK
		#ifdef __USE_GTK__
			cairo_arc(Handle, x , y, Radial, 0, 2 * G_PI)
			cairo_fill_preserve(Handle)
			'			cairo_set_source_rgb(cr, 0.0, 0.0, 0.0)
			'			cairo_stroke(cr)
		#elseif defined(__USE_WINAPI__)
			.Ellipse Handle, ScaleX(x - Radial / 2) * imgScaleX + imgOffsetX, ScaleY(y - Radial / 2) * imgScaleY + imgOffsetY, ScaleX(x + Radial / 2) * imgScaleX + imgOffsetX, ScaleY(y + Radial / 2) * imgScaleY + imgOffsetY
		#endif
		Brush.Color = OldFillColor
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.RoundRect Overload(x As Double, y As Double, x1 As Double, y1 As Double, nWidth As Integer, nHeight As Integer)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_GTK__
			Var radius = x1 - x
			cairo_move_to Handle, x - 0.5, y + nWidth / 2 - 0.5
			cairo_arc (Handle, x + radius - 0.5, y + nWidth / 2 - 0.5, nWidth / 2, G_PI, -G_PI / 2)
			cairo_line_to (Handle, x + nWidth - nWidth / 2 - 0.5, y - 0.5)
			cairo_arc (Handle, x + nWidth - nWidth / 2 - 0.5, y + nWidth / 2 - 0.5, nWidth / 2, -G_PI / 2, 0)
			cairo_line_to (Handle, x + nWidth - 0.5, y + nHeight - nWidth / 2 - 0.5)
			cairo_arc (Handle, x + nWidth - nWidth / 2 - 0.5, y + nHeight - nWidth / 2 - 0.5, nWidth / 2, 0, G_PI / 2)
			cairo_line_to (Handle, x + nWidth / 2 - 0.5, y + nHeight - 0.5)
			cairo_arc (Handle, x + nWidth / 2 - 0.5, y + nHeight - nWidth / 2 - 0.5, nWidth / 2, G_PI / 2, G_PI)
			cairo_close_path Handle
			cairo_fill_preserve(Handle)
		#elseif defined(__USE_WINAPI__)
			.RoundRect Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1) * imgScaleX + imgOffsetX, ScaleY(y1) * imgScaleY + imgOffsetY, ScaleX(nWidth) * imgScaleX + imgOffsetX, ScaleY(nHeight) * imgScaleY + imgOffsetY
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.Polygon(Points As Point Ptr, Count As Long)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			Dim tPoints As Point Ptr
			tPoints->x = Points->x * imgScaleX + imgOffsetX:  tPoints->y = Points->y * imgScaleX + imgOffsetX
			.Polygon Handle, Cast(..Point Ptr, tPoints), Count
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.RoundRect(R As Rect, nWidth As Integer, nHeight As Integer)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_GTK__
			This.RoundRect R.Left, R.Top, R.Right, R.Bottom, nWidth, nHeight
		#elseif defined(__USE_WINAPI__)
			.RoundRect Handle, ScaleX(R.Left) * imgScaleX + imgOffsetX, ScaleY(R.Top) * imgScaleY + imgOffsetY, ScaleX(R.Right) * imgScaleX + imgOffsetX, ScaleY(R.Bottom) * imgScaleY + imgOffsetY, ScaleX(nWidth * imgScaleX + imgOffsetX), ScaleY(nHeight) * imgScaleY + imgOffsetY
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.Chord(x As Double, y As Double, x1 As Double, y1 As Double, nXRadial1 As Double, nYRadial1 As Double, nXRadial2 As Double, nYRadial2 As Double)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			.Chord(Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1) * imgScaleX + imgOffsetX, ScaleY(y1) * imgScaleY + imgOffsetY, ScaleX(nXRadial1) * imgScaleX, ScaleY(nYRadial1) * imgScaleY, ScaleX(nXRadial2) * imgScaleX, ScaleY(nYRadial2) * imgScaleY)
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.Pie(x As Double, y As Double, x1 As Double, y1 As Double, nXRadial1 As Double, nYRadial1 As Double, nXRadial2 As Double, nYRadial2 As Double)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			.Pie(Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1) * imgScaleX + imgOffsetX, ScaleY(y1) * imgScaleY + imgOffsetY, ScaleX(nXRadial1) * imgScaleX, ScaleY(nYRadial1) * imgScaleY , ScaleX(nXRadial2) * imgScaleX , ScaleY(nYRadial2) * imgScaleY)
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.Arc(x As Double, y As Double, x1 As Double, y1 As Double, xStart As Double, yStart As Double, xEnd As Double, yEnd As Double)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			.Arc(Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1) * imgScaleX + imgOffsetX, ScaleY(y1) * imgScaleY + imgOffsetY, ScaleX(xStart) * imgScaleX + imgOffsetX, ScaleY(yStart) * imgScaleY + imgOffsetY, ScaleX(xEnd) * imgScaleX + imgOffsetX, ScaleY(yEnd) * imgScaleY + imgOffsetY)
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.ArcTo(x As Double, y As Double, x1 As Double, y1 As Double, nXRadial1 As Double, nYRadial1 As Double, nXRadial2 As Double, nYRadial2 As Double)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			.ArcTo Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(x1) * imgScaleX + imgOffsetX, ScaleY(y1) * imgScaleY + imgOffsetY, ScaleX(nXRadial1) * imgScaleX , ScaleY(nYRadial1) * imgScaleY, ScaleX(nXRadial2) * imgScaleX, ScaleY(nYRadial2) * imgScaleY
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.AngleArc(x As Double, y As Double, Radius As Double, StartAngle As Double, SweepAngle As Double)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			.AngleArc Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, ScaleX(Radius) * imgScaleX, StartAngle, SweepAngle
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.Polyline(Points() As Point, Count As Long)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			Dim tPoints(Count - 1) As Point
			For i As Integer = 0 To Count - 1
				tPoints(i).X = Points(i).X * imgScaleX + imgOffsetX : tPoints(i).Y = Points(i).Y * imgScaleY + imgOffsetY
			Next
			.Polyline Handle, Cast(..Point Ptr, @tPoints(0)), Count
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.PolylineTo(Points() As Point, Count As Long)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			Dim tPoints(Count - 1) As Point
			For i As Integer = 0 To Count - 1
				tPoints(i).X = Points(i).X * imgScaleX + imgOffsetX : tPoints(i).Y = Points(i).Y * imgScaleY + imgOffsetY
			Next
			.PolylineTo Handle, Cast(..Point Ptr, @tPoints(0)), Count
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.PolyBeizer(Points() As Point, Count As Long)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			Dim tPoints(Count - 1) As Point
			For i As Integer = 0 To Count - 1
				tPoints(i).X = Points(i).X * imgScaleX + imgOffsetX : tPoints(i).Y = Points(i).Y * imgScaleY + imgOffsetY
			Next
			.PolyBezier Handle, Cast(..Point Ptr, @tPoints(0)), Count
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Sub Canvas.PolyBeizerTo(Points() As Point, Count As Long)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			Dim tPoints(Count - 1) As Point
			For i As Integer = 0 To Count - 1
				tPoints(i).X = Points(i).X * imgScaleX + imgOffsetX : tPoints(i).Y = Points(i).Y * imgScaleY + imgOffsetY
			Next
			.PolyBezierTo Handle, Cast(..Point Ptr, @tPoints(0)), Count
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
			#ifdef PANGO_VERSION
				Dim As PangoLayoutLine Ptr pl = pango_layout_get_line_readonly(layout, 0)
			#else
				Dim As PangoLayoutLine Ptr pl = pango_layout_get_line(layout, 0)
			#endif
			pango_layout_line_get_pixel_extents(pl, NULL, @extend2)
			If BK <> -1 Then
				iRed = Abs(GetRed(BK) / 255.0): iGreen = Abs(GetGreen(BK) / 255.0): iBlue = Abs(GetBlue(BK) / 255.0)
				cairo_set_source_rgb(Handle, iRed, iGreen, iBlue)
				.cairo_rectangle (Handle, x, y, extend2.width, extend2.height)
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
			If BK = -1 Then SetBkMode(Handle, TRANSPARENT) Else SetBkColor(Handle, BK)
			If FG = -1 Then SetTextColor(Handle, Font.Color) Else SetTextColor(Handle, FG)
			.TextOut(Handle, ScaleX(x) * imgScaleX + imgOffsetX, ScaleY(y) * imgScaleY + imgOffsetY, @s, Len(s))
			If BK = -1 Then SetBkMode(Handle, OPAQUE)
		#endif
		If Not HandleSetted Then ReleaseDevice
	End Sub
	
	Private Function Canvas.Get(x As Double, y As Double, nWidth As Integer, nHeight As Integer, ByVal ImageSource As Any Ptr) As Any Ptr
		If Not HandleSetted Then GetDevice
		#ifdef __USE_GTK__
			Dim As GdkPixbuf Ptr ImageDest
			If nWidth <> 0 AndAlso nHeight <> 0 Then
				ImageDest = gdk_pixbuf_new(GDK_COLORSPACE_RGB, True, 8 , nWidth, nHeight)
				If ImageDest Then
					gdk_pixbuf_copy_area(ImageSource, x, y, nWidth, nHeight, ImageDest, 0, 0)
					Return ImageDest
				EndIf
			EndIf
			Return 0
		#elseif defined(__USE_WINAPI__)
			Dim As GpImage Ptr pImage1
			Dim As GpImage Ptr pImage2
			Dim As HBITMAP     ImageDest
			' // Initialize Gdiplus
			Dim token As ULONG_PTR, StartupInput As GdiplusStartupInput
			StartupInput.GdiplusVersion = 1
			GdiplusStartup(@token, @StartupInput, NULL)
			If token = NULL Then Return False
			GdipCreateBitmapFromHBITMAP(ImageSource, NULL, Cast(GpBitmap Ptr Ptr, @pImage1))
			GdipCloneBitmapArea (x, y, nWidth, nHeight, 0, Cast(GpBitmap Ptr , pImage1) , Cast(GpBitmap Ptr Ptr, @pImage2))
			GdipCreateHBITMAPFromBitmap(Cast(GpBitmap Ptr , pImage2) , @ImageDest, 0)
			' // Free the image
			If pImage1 Then GdipDisposeImage pImage1
			If pImage2 Then GdipDisposeImage pImage2
			' // Shutdown Gdiplus
			GdiplusShutdown token
			Return ImageDest
		#endif
		If Not HandleSetted Then ReleaseDevice
		Return 0
	End Function
	
	Private Sub Canvas.DrawAlpha(x As Double, y As Double, ByRef Image As My.Sys.Drawing.BitmapType)
		If Not HandleSetted Then GetDevice
		#ifdef __USE_WINAPI__
			Dim As HDC hMemDC = CreateCompatibleDC(Handle) ' Create Dc
			SelectObject(hMemDC, Image.Handle) ' Select BITMAP in New Dc
			
			Dim As BITMAP Bitmap01
			GetObject(Image.Handle, SizeOf(Bitmap01), @Bitmap01)
			
			Dim As BLENDFUNCTION bfn ' Struct With info For AlphaBlend
			bfn.BlendOp = AC_SRC_OVER
			bfn.BlendFlags = 0
			bfn.SourceConstantAlpha = 255
			bfn.AlphaFormat = AC_SRC_ALPHA
			
			AlphaBlend(Handle, 0, 0, Bitmap01.bmWidth, Bitmap01.bmHeight, hMemDC, 0, 0, Bitmap01.bmWidth, Bitmap01.bmHeight, bfn) ' Display BITMAP
	
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
			pango_layout_set_text(layout, ToUTF8(FText), Len(ToUTF8(FText)))
			pango_cairo_update_layout(Handle, layout)
			#ifdef PANGO_VERSION
				Dim As PangoLayoutLine Ptr pl = pango_layout_get_line_readonly(layout, 0)
			#else
				Dim As PangoLayoutLine Ptr pl = pango_layout_get_line(layout, 0)
			#endif
			pango_layout_line_get_pixel_extents(pl, NULL, @extend)
			pango_font_description_free (desc)
			Function = extend.Width
		#elseif defined(__USE_JNI__)
			Function = 0
		#elseif defined(__USE_WINAPI__)
			Dim Sz As ..SIZE
			GetTextExtentPoint32(Handle, @FText, Len(FText), @Sz)
			Function = UnScaleX(Sz.cX)
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
			pango_layout_set_text(layout, ToUTF8(FText), Len(ToUTF8(FText)))
			pango_cairo_update_layout(Handle, layout)
			#ifdef pango_version
				Dim As PangoLayoutLine Ptr pl = pango_layout_get_line_readonly(layout, 0)
			#else
				Dim As PangoLayoutLine Ptr pl = pango_layout_get_line(layout, 0)
			#endif
			pango_layout_line_get_pixel_extents(pl, NULL, @extend)
			pango_font_description_free (desc)
			Function = extend.Height
		#elseif defined(__USE_JNI__)
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
	
	Private Sub Canvas.Font_Create(ByRef Sender As My.Sys.Drawing.Font)
		#ifdef __USE_WINAPI__
			With *Cast(Canvas Ptr, Sender.Parent)
				If .Handle Then SelectObject(.Handle, Sender.Handle)
			End With
		#endif
	End Sub
	
	Private Sub Canvas.Pen_Create(ByRef Sender As My.Sys.Drawing.Pen)
		#ifdef __USE_WINAPI__
			With *Cast(Canvas Ptr, Sender.Parent)
				If .Handle Then
					SelectObject(.Handle, Sender.Handle)
					SetROP2 .Handle, Sender.Mode
				End If
			End With
		#endif
	End Sub
	
	Private Sub Canvas.Brush_Create(ByRef Sender As My.Sys.Drawing.Brush)
		#ifdef __USE_WINAPI__
			With *Cast(Canvas Ptr, Sender.Parent)
				If .Handle Then SelectObject(.Handle, Sender.Handle)
			End With
		#endif
	End Sub
	
	Private Constructor Canvas
		Clip = False
		WLet(FClassName, "Canvas")
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
		FScaleWidth = This.Width
		FScaleHeight =  This.Height
	End Constructor
	
	Private Destructor Canvas
		#ifndef __USE_GTK__
			If Handle Then ReleaseDevice
		#endif
	End Destructor
End Namespace
