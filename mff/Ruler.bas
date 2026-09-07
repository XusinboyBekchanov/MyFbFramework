'###############################################################################
'#  Ruler.bas                                                                  #
'#  This file is part of MyFBFramework                                        #
'#  See Ruler.bi for an overview of the design.                               #
'###############################################################################

#include once "Ruler.bi"

Namespace My.Sys.Forms
	Constructor Ruler
		With This
			#ifdef __USE_GTK__
				widget = gtk_layout_new(NULL, NULL)
				.RegisterClass "Ruler", @This
			#endif
			.Child          = @This
			.Canvas.Ctrl    = @This
			'.Graphic.OnChange = @GraphicChange
			#ifdef __USE_WINAPI__
				.RegisterClass "Ruler"
				'.ChildProc   = @WNDPROC
				.ExStyle     = 0
				.Style       = WS_CHILD
				.BackColor       = BGR(246, 246, 248)
				FDefaultBackColor = BGR(246, 246, 248)
				'.OnHandleIsAllocated = @HandleIsAllocated
			#elseif defined(__USE_JNI__)
				WLet(FClassAncestor, "android/widget/AbsoluteLayout")
			#elseif defined(__USE_WASM__)
				WLet(FClassAncestor, "div")
			#endif
			FTabIndex          = -1
			WLet(FClassName, "Ruler")
			.Width       = 121
			.Height      = 24
		End With
		FOrientation = ruHorizontal
		FUnits       = ruPixels
		FDPI         = 96
		FZeroOffset  = 0
		FMousePos    = -1
		FMarkerCount = 0
		#ifdef __USE_GTK__
			OnHandleIsAllocated = @HandleAllocated
		#endif
	End Constructor

	Destructor Ruler
	End Destructor

	Private Property Ruler.Orientation As RulerOrientation
		Return FOrientation
	End Property

	Private Property Ruler.Orientation(Value As RulerOrientation)
		FOrientation = Value
		If Value = ruHorizontal Then
			This.Move(Left, Top, Width, 24)
		Else
			This.Move(Left, Top, 24, Height)
		End If
		Invalidate
	End Property

	Private Property Ruler.Units As RulerUnits
		Return FUnits
	End Property

	Private Property Ruler.Units(Value As RulerUnits)
		FUnits = Value
		Invalidate
	End Property

	Private Property Ruler.DPI As Integer
		Return FDPI
	End Property

	Private Property Ruler.DPI(Value As Integer)
		If Value > 0 Then FDPI = Value
		Invalidate
	End Property

	Private Property Ruler.ZeroOffset As Integer
		Return FZeroOffset
	End Property

	Private Property Ruler.ZeroOffset(Value As Integer)
		If FZeroOffset <> Value Then
			FZeroOffset = Value
			Invalidate
		End If
	End Property

	Private Property Ruler.MousePosition As Integer
		Return FMousePos
	End Property

	Private Property Ruler.MousePosition(Value As Integer)
		If FMousePos <> Value Then
			FMousePos = Value
			Invalidate
		End If
	End Property

	Private Sub Ruler.ClearMarkers()
		FMarkerCount = 0
		Invalidate
	End Sub

	Private Sub Ruler.AddMarker(Position As Integer)
		If FMarkerCount < RULER_MAX_MARKERS Then
			FMarkers(FMarkerCount) = Position
			FMarkerCount += 1
			Invalidate
		End If
	End Sub

	'Reacts to the framework's own dark-mode notifications (Control.SetDark, the same virtual
	'every other control overrides) - Base.SetDark already swaps the native theme/background,
	'we only need to repaint so DrawRuler picks the matching palette below.
	Private Sub Ruler.SetDark(Value As Boolean)
		Base.SetDark(Value)
		BackColor = IIf(Value, BGR(45, 45, 48), BGR(246, 246, 248))
		Invalidate
	End Sub

	'All the actual tick/marker/tracker drawing - called from ProcessMessage below, never from
	'the public OnPaint field (see Ruler.bi for why).
	Private Sub Ruler.DrawRuler(ByRef Canvas As My.Sys.Drawing.Canvas)
		Dim As Integer W = This.Width, H = This.Height
		
		If W <= 0 OrElse H <= 0 Then Return

		Dim As Integer clrBack, clrTick, clrText, clrMarker, clrTracker
		
		If FDarkMode Then
			clrBack    = BGR(45, 45, 48)
			clrTick    = BGR(110, 110, 118)
			clrText    = BGR(200, 200, 205)
			clrMarker  = BGR(110, 140, 230)
			clrTracker = BGR(235, 90, 90)
		Else
			clrBack    = BGR(246, 246, 248)
			clrTick    = BGR(140, 140, 150)
			clrText    = BGR(90, 90, 100)
			clrMarker  = BGR(90, 110, 200)
			clrTracker = BGR(220, 60, 60)
		End If
		Canvas.FillRect(Type<My.Sys.Drawing.Rect>(0, 0, W, H), clrBack)

		Dim As Double PxPerUnit
		Select Case FUnits
		Case ruInches:      PxPerUnit = FDPI
		Case ruCentimeters: PxPerUnit = FDPI / 2.54
		Case Else:          PxPerUnit = 100 'pixel mode: a "unit" is just 50px of major-tick spacing
		End Select

		Dim As Integer Extent     = IIf(FOrientation = ruHorizontal, W, H)
		Dim As Integer Divisions  = IIf(FUnits = ruPixels, 5, 8) 'minor ticks per major unit
		Dim As Double  MinorStep  = PxPerUnit / Divisions
		If MinorStep < 2 Then MinorStep = 2 'guard against a degenerate DPI/Units combo

		'Walk in minor-tick increments across the whole visible extent; ZeroOffset shifts which
		'tick lands at pixel 0, so the ruler content scrolls in lock-step with whatever surface
		'it is docked to.
		Dim As Integer FirstTick = CInt(Int((-FZeroOffset) / MinorStep)) - 1
		Dim As Integer LastTick  = CInt(Int((Extent - FZeroOffset) / MinorStep)) + 1
		For i As Integer = FirstTick To LastTick
			Dim As Double p = i * MinorStep + FZeroOffset
			If p < 0 OrElse p > Extent Then Continue For
			Dim As Boolean Major   = (i Mod Divisions) = 0
			Dim As Integer TickLen = IIf(Major, 10, 4)
			If FOrientation = ruHorizontal Then
				Canvas.Line(p, H - TickLen, p, H, clrTick)
				If Major Then Canvas.TextOut(p + 2, 1, WStr(i \ Divisions), clrText, -1)
			Else
				Canvas.Line(W - TickLen, p, W, p, clrTick)
				If Major Then Canvas.TextOut(1, p + 1, WStr(i \ Divisions), clrText, -1)
			End If
		Next i

		'Section-boundary markers (fed via AddMarker) - a stronger accent line, so a vertical
		'Ruler docked next to a Report design surface visibly mirrors the band layout.
		For i As Integer = 0 To FMarkerCount - 1
			Dim As Integer p = FMarkers(i) + FZeroOffset
			If p < 0 OrElse p > Extent Then Continue For
			If FOrientation = ruHorizontal Then
				Canvas.Line(p, 0, p, H, clrMarker)
			Else
				Canvas.Line(0, p, W, p, clrMarker)
			End If
		Next i

		'Live mouse-position tracker, the moving line Word/Xojo draw on their rulers.
		If FMousePos >= 0 Then
			Dim As Integer p = FMousePos + FZeroOffset
			If p >= 0 AndAlso p <= Extent Then
				If FOrientation = ruHorizontal Then
					Canvas.Line(p, 0, p, H, clrTracker)
				Else
					Canvas.Line(0, p, W, p, clrTracker)
				End If
			End If
		End If
	End Sub

	#ifdef __USE_GTK__
		Private Function Ruler.GtkDrawAfter(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As gpointer) As Boolean
			Dim As Ruler Ptr R = Cast(Ruler Ptr, data1)
			If R = 0 Then Return False
			R->Canvas.SetHandle(cr)
			R->DrawRuler(R->Canvas)
			R->Canvas.UnSetHandle
			Return False 'let the signal keep propagating - we're only adding to the drawing
		End Function

		'Connected via OnHandleIsAllocated (Constructor), not called directly from the
		'Constructor itself, because Panel/Control create their native GTK widget lazily -
		'`widget` isn't valid yet at Constructor time.
		Private Sub Ruler.HandleAllocated(ByRef Sender As Control)
			Dim As Ruler Ptr R = Cast(Ruler Ptr, @Sender)
			If R AndAlso R->widget Then g_signal_connect_after(R->widget, "draw", G_CALLBACK(@GtkDrawAfter), R)
		End Sub

		Private Sub Ruler.ProcessMessage(ByRef Message As Message)
			'Nothing extra to do here on GTK - the actual tick/marker/tracker drawing happens
			'in GtkDrawAfter, connected once via HandleAllocated above, which keeps it
			'independent of the public OnPaint field the same way the Win32 branch does.
			Base.ProcessMessage(Message)
		End Sub
	#else
		Private Sub Ruler.ProcessMessage(ByRef Message As Message)
			Select Case Message.Msg
			Case WM_PAINT
				Dim As HDC Dc, memDC
				Dim As HBITMAP MemBmp, hOldBmp
				Dim As PAINTSTRUCT Ps
				Dim As ..Rect R
				GetClientRect Handle, @R
				Dc = BeginPaint(Handle, @Ps)
				If Dc = 0 Then
					EndPaint This.Handle, @Ps
					Message.Result = 0
					Return
				End If
				If g_darkModeSupported AndAlso g_darkModeEnabled Then
					If Not FDarkMode Then SetDark True
				Else
					If FDarkMode Then SetDark False
				End If
				If DoubleBuffered Then
					memDC = CreateCompatibleDC(Dc)
					MemBmp = CreateCompatibleBitmap(Dc, R.Right - R.Left, R.Bottom - R.Top)
					hOldBmp = SelectObject(memDC, MemBmp)
					FillRect memDC, @R, Brush.Handle
					Canvas.SetHandle memDC
				Else
					FillRect Dc, @R, Brush.Handle
					Canvas.SetHandle Dc
				End If
				DrawRuler(Canvas)
				If OnPaint Then OnPaint(*Designer, This, Canvas)
				Canvas.UnSetHandle
				If DoubleBuffered Then
					BitBlt(Dc, 0, 0, R.Right - R.left, R.Bottom - R.top, memDC, 0, 0, SRCCOPY)
					SelectObject memDC, hOldBmp
					DeleteObject(MemBmp)
					DeleteDC(memDC)
				End If
				EndPaint Handle, @Ps
				ReleaseDC Handle, Dc
				Message.Result = 0
				Return
			End Select
			Base.ProcessMessage(Message)
		End Sub
	#endif
End Namespace
