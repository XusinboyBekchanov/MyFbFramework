'################################################################################
'#  IconPanel.bas                                                               #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Liu XiaLin                                                         #
'#  Based on:                                                                   #
'#   PsIconPanel (Paul Squires, PlanetSquires Software, MPL 2.0)                #
'################################################################################

'#Region "Form"
	#include once "IconPanel.bi"
	#include once "vbcompat.bi"

	Namespace My.Sys.Forms

	Private Function IconPanel.GetWindowsDPI() As Double
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

	Private Function IconPanel.ItemCount() As Long
		Return UBound(m_Item) + 1
	End Function

	Private Function IconPanel.IsValidItem(ByVal idx As Long) As Boolean
		Return idx >= 0 AndAlso idx < ItemCount() AndAlso m_Item(idx) <> 0
	End Function

	'Assign every item's cell rects. Widths are DECLARED (icon size + pads, or
	'the separator width) - nothing is measured, so cells never move at runtime.
	'A run wider than the client clips at the edge; the justify applies when the
	'run is narrower.
	Private Sub IconPanel.LayoutItems()
		bLayoutDirty = False

		Dim clientW As Long = ScaleX(This.ClientWidth)
		Dim clientH As Long = ScaleY(This.ClientHeight)
		If clientW <= 0 OrElse clientH <= 0 Then
			bLayoutDirty = True
			Exit Sub
		End If

		'Total declared width
		Dim runW As Long = 0
		Dim i As Long
		For i = 0 To ItemCount() - 1
			With *m_Item(i)
				If .Kind = ikSeparator Then
					runW += m_SeparatorWidth * nScale
				Else
					Dim iw As Long = IIf(.IconWidth >= 0, .IconWidth * nScale, m_IconWidth * nScale)
					Dim pb As Long = IIf(.PadBefore >= 0, .PadBefore * nScale, m_PadBefore * nScale)
					Dim pa As Long = IIf(.PadAfter >= 0, .PadAfter * nScale, m_PadAfter * nScale)
					runW += pb + iw + pa
				End If
			End With
		Next

		Dim x As Long = 0
		If runW < clientW Then
			Select Case m_Justify
			Case ijCenter
				x = (clientW - runW) \ 2
			Case ijRight
				x = clientW - runW
			End Select
		End If

		For i = 0 To ItemCount() - 1
			With *m_Item(i)
				If .Kind = ikSeparator Then
					Dim sw As Long = m_SeparatorWidth * nScale
					.rc.Left = x: .rc.Top = 0: .rc.Right = x + sw: .rc.Bottom = clientH
					.rcIcon = .rc
					x += sw
				Else
					Dim iw As Long = IIf(.IconWidth >= 0, .IconWidth * nScale, m_IconWidth * nScale)
					Dim ih As Long = IIf(.IconHeight >= 0, .IconHeight * nScale, m_IconHeight * nScale)
					Dim pb As Long = IIf(.PadBefore >= 0, .PadBefore * nScale, m_PadBefore * nScale)
					Dim pa As Long = IIf(.PadAfter >= 0, .PadAfter * nScale, m_PadAfter * nScale)
					.rc.Left = x: .rc.Top = 0: .rc.Right = x + pb + iw + pa: .rc.Bottom = clientH
					'Centre the glyph square on the row
					.rcIcon.Left = .rc.Left + pb
					.rcIcon.Right = .rcIcon.Left + iw
					.rcIcon.Top = (clientH - ih) \ 2
					If .rcIcon.Top < 0 Then .rcIcon.Top = 0
					.rcIcon.Bottom = .rcIcon.Top + ih
					x = .rc.Right
				End If
			End With
		Next
	End Sub

	Private Function IconPanel.HitTest(ByVal x As Long, ByVal y As Long) As Long
		Dim i As Long
		For i = 0 To ItemCount() - 1
			With *m_Item(i)
				If x >= .rc.Left AndAlso x < .rc.Right AndAlso y >= .rc.Top AndAlso y < .rc.Bottom Then Return i
			End With
		Next
		Return -1
	End Function

	Private Function IconPanel.ARGB(clr As ULong, Opacity As Long = 100) As ULong
		#ifdef __USE_WINAPI__
			Return (Cast(ULong, Opacity / 100 * 255) Shl 24) Or (GetRed(clr) Shl 16) Or (GetGreen(clr) Shl 8) Or GetBlue(clr)
		#else
			Return clr
		#endif
	End Function

	'Fill a rectangle with an exact colour through the Canvas path family (the
	'GDI+ branch of Canvas.Rectangle takes its colour from Canvas.FillColor and
	'FillOpacity rather than Brush.Color)
	Private Sub IconPanel.FillRectPath(ByVal x As Long, ByVal y As Long, ByVal w As Long, ByVal h As Long, clr As ULong)
		If w <= 0 OrElse h <= 0 Then Exit Sub
		Canvas.PathStart
		Canvas.PathRoundRect(x, y, w, h, 0)
		Canvas.FillPath(ARGB(clr), 100)
		Canvas.PathDiscard
	End Sub

	Private Sub IconPanel.Draw()
		On Error Goto ErrorHandler

		If bLayoutDirty Then LayoutItems()

		'---- the background -------------------------------------------------------
		Dim backClr As ULong = m_BackColor
		If backClr = Cast(ULong, -1) Then backClr = clBtnFace
		FillRectPath(0, 0, ScaleX(This.ClientWidth), ScaleY(This.ClientHeight), backClr)

		Canvas.Font = This.Font
		Dim i As Long
		For i = 0 To ItemCount() - 1
			With *m_Item(i)
				If .Kind = ikSeparator Then
					FillRectPath(.rc.Left, .rc.Top, .rc.Right - .rc.Left, .rc.Bottom - .rc.Top, m_SeparatorColor)
				Else
					'Cell fill
					Dim clrCell As ULong = m_CellColor
					Dim clrGlyph As ULong = m_GlyphColor
					If .isEnabled = False OrElse This.Enabled = False Then
						clrCell = m_CellColorDisabled
						clrGlyph = m_GlyphColorDisabled
					ElseIf .isSelected Then
						clrCell = m_CellColorSelected
						clrGlyph = m_GlyphColorSelected
					ElseIf i = m_HotIdx Then
						clrCell = m_CellColorHot
						clrGlyph = m_GlyphColorHot
					End If
					Dim cw As Long = .rcIcon.Right - .rcIcon.Left
					Dim ch As Long = .rcIcon.Bottom - .rcIcon.Top
					FillRectPath(.rcIcon.Left, .rcIcon.Top, cw, ch, clrCell)

					'The glyph, centred in the icon square
					If Len(.Glyph) > 0 Then
						Dim tW As Long = ScaleX(Canvas.TextWidth(.Glyph))
						Dim tH As Long = ScaleY(Canvas.TextHeight(.Glyph))
						Canvas.TextOut(.rcIcon.Left + (cw - tW) \ 2, .rcIcon.Top + (ch - tH) \ 2, .Glyph, clrGlyph, -1)
					End If
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

	Private Sub IconPanel.SetHot(ByVal idx As Long)
		If idx <> m_HotIdx Then
			m_HotIdx = idx
			Refresh
		End If
	End Sub

	Private Sub IconPanel.ActivateItem(ByVal idx As Long)
		'A click on an enabled, interactive cell: a toggle latches, a button fires
		If IsValidItem(idx) = False Then Exit Sub
		With *m_Item(idx)
			If .Kind = ikSeparator Then Exit Sub
			If .isEnabled = False OrElse This.Enabled = False Then Exit Sub
			If .Kind = ikToggle Then
				.isSelected = Not .isSelected
			End If
			Refresh
			If OnItemClick Then OnItemClick(*Designer, This, idx, .Kind, .isSelected)
		End With
	End Sub

	Private Sub IconPanel.CancelPress()
		m_PressedIdx = -1
	End Sub

	Private Sub IconPanel.Refresh()
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

	Private Sub IconPanel.tmrHotTrack_Timer_(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent)
		QIconPanel(Sender.Designer).tmrHotTrack_Timer(Sender)
	End Sub

	Private Sub IconPanel.tmrHotTrack_Timer(ByRef Sender As TimerComponent)
		#ifdef __USE_WINAPI__
			If FHandle = 0 Then Exit Sub
			Dim pt As POINT
			GetCursorPos(@pt)
			'the raw API: Control.ScreenToClient (MFF Point) shadows the name here
			..ScreenToClient(FHandle, @pt)
			SetHot(HitTest(pt.x, pt.y))
		#endif
	End Sub

	Private Sub IconPanel.ProcessMessage(ByRef Message As Message)
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
				m_PressedIdx = HitTest(Message.lParamLo, Message.lParamHi)
				SetCapture(FHandle)
				SetHot(m_PressedIdx)
			Case WM_MOUSEMOVE
				SetHot(HitTest(Message.lParamLo, Message.lParamHi))
			Case WM_LBUTTONUP
				Dim idx As Long = HitTest(Message.lParamLo, Message.lParamHi)
				Dim bWasPressed As Boolean = (m_PressedIdx = idx AndAlso idx >= 0)
				If GetCapture = FHandle Then ReleaseCapture
				CancelPress
				If bWasPressed Then ActivateItem(idx)
			Case WM_CAPTURECHANGED
				CancelPress
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub

	#ifdef __USE_GTK__
		Private Function IconPanel.OnDraw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As gpointer) As Boolean
			Dim As IconPanel Ptr p = Cast(Any Ptr, data1)
			p->Canvas.HandleSetted = True
			p->Canvas.Handle = cr
			If p->nScale = 0 Then p->nScale = p->GetWindowsDPI()
			p->Draw()
			p->Canvas.Handle = 0
			p->Canvas.HandleSetted = False
			Return False
		End Function

		Private Sub IconPanel.GTK_MouseDown(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, X As Integer, Y As Integer, Shift As Integer)
			Dim As IconPanel Ptr p = Cast(IconPanel Ptr, @Sender)
			p->m_PressedIdx = p->HitTest(X, Y)
			p->SetHot(p->m_PressedIdx)
		End Sub

		Private Sub IconPanel.GTK_MouseMove(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, X As Integer, Y As Integer, Shift As Integer)
			Dim As IconPanel Ptr p = Cast(IconPanel Ptr, @Sender)
			p->SetHot(p->HitTest(X, Y))
		End Sub

		Private Sub IconPanel.GTK_MouseUp(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, X As Integer, Y As Integer, Shift As Integer)
			Dim As IconPanel Ptr p = Cast(IconPanel Ptr, @Sender)
			Dim idx As Long = p->HitTest(X, Y)
			Dim bWasPressed As Boolean = (p->m_PressedIdx = idx AndAlso idx >= 0)
			p->CancelPress
			If bWasPressed Then p->ActivateItem(idx)
		End Sub
	#endif

	Private Sub IconPanel.InitProperties()
		With This
			WLet(FClassName, "IconPanel")
			#ifdef __USE_WINAPI__
				.Style = WS_CHILD
				.ExStyle = 0
				.RegisterClass "IconPanel", ""
				.ChildProc = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#elseif defined(__USE_GTK__)
				widget = gtk_layout_new(NULL, NULL)
				.RegisterClass "IconPanel", @This
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
			.Height = 34
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
		Private Sub IconPanel.WndProc(ByRef Message As Message)
		End Sub

		Private Sub IconPanel.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			With QIconPanel(@Sender)
				.nScale = .GetWindowsDPI()
				.bLayoutDirty = True
				.tmrHotTrack.Interval = ICONPANEL_HOTTRACK_MS
			End With
		End Sub
	#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
		Private Sub IconPanel.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			With QIconPanel(@Sender)
				.nScale = .GetWindowsDPI()
				.bLayoutDirty = True
			End With
		End Sub
	#endif

	Private Constructor IconPanel
		InitProperties()
	End Constructor

	Private Destructor IconPanel
		tmrHotTrack.Interval = 0
		tmrHotTrack.Enabled = False
		Clear()
	End Destructor

	'== Items ===============================================================================

	Private Sub IconPanel.Clear()
		Dim i As Long
		For i = 0 To ItemCount() - 1
			If m_Item(i) <> 0 Then Delete m_Item(i)
			m_Item(i) = 0
		Next
		Erase m_Item
		m_HotIdx = -1
		m_PressedIdx = -1
		bLayoutDirty = True
		Refresh
	End Sub

	Private Function IconPanel.AddItem(ByVal itemKind As IconPanelKinds, ByRef Glyph As WString, ByVal id As Long = 0, ByVal ItemData As Integer = 0) As Long
		Dim p As IconPanelItem Ptr = _New(IconPanelItem)
		If p = 0 Then Return -1
		ReDim Preserve m_Item(ItemCount())
		m_Item(ItemCount() - 1) = p
		p->Kind = itemKind
		p->Glyph = Glyph
		p->id = id
		p->ItemData = ItemData
		bLayoutDirty = True
		Refresh
		Return ItemCount() - 1
	End Function

	Private Function IconPanel.AddSeparator() As Long
		Return AddItem(ikSeparator, "")
	End Function

	Private Function IconPanel.GetCount As Long
		Return ItemCount()
	End Function

	Private Function IconPanel.GetItemKind(ByVal idx As Long) As IconPanelKinds
		If IsValidItem(idx) = False Then Return ikSeparator
		Return m_Item(idx)->Kind
	End Function

	Private Function IconPanel.GetGlyph(ByVal idx As Long) As UString
		If IsValidItem(idx) = False Then Return ""
		Return m_Item(idx)->Glyph
	End Function

	Private Function IconPanel.SetGlyph(ByVal idx As Long, ByRef Glyph As WString) As Boolean
		If IsValidItem(idx) = False Then Return False
		m_Item(idx)->Glyph = Glyph
		Refresh
		Return True
	End Function

	Private Function IconPanel.GetItemID(ByVal idx As Long) As Long
		If IsValidItem(idx) = False Then Return 0
		Return m_Item(idx)->id
	End Function

	Private Function IconPanel.SetItemID(ByVal idx As Long, ByVal id As Long) As Boolean
		If IsValidItem(idx) = False Then Return False
		m_Item(idx)->id = id
		Return True
	End Function

	Private Function IconPanel.GetItemData(ByVal idx As Long) As Integer
		If IsValidItem(idx) = False Then Return 0
		Return m_Item(idx)->ItemData
	End Function

	Private Function IconPanel.SetItemData(ByVal idx As Long, ByVal ItemData As Integer) As Boolean
		If IsValidItem(idx) = False Then Return False
		m_Item(idx)->ItemData = ItemData
		Return True
	End Function

	Private Function IconPanel.GetSelected(ByVal idx As Long) As Boolean
		If IsValidItem(idx) = False Then Return False
		Return m_Item(idx)->isSelected
	End Function

	Private Function IconPanel.SetSelected(ByVal idx As Long, ByVal isSelected As Boolean) As Boolean
		If IsValidItem(idx) = False Then Return False
		m_Item(idx)->isSelected = isSelected
		Refresh
		Return True
	End Function

	Private Function IconPanel.GetEnabled(ByVal idx As Long) As Boolean
		If IsValidItem(idx) = False Then Return False
		Return m_Item(idx)->isEnabled
	End Function

	Private Function IconPanel.SetEnabled(ByVal idx As Long, ByVal isEnabled As Boolean) As Boolean
		If IsValidItem(idx) = False Then Return False
		m_Item(idx)->isEnabled = isEnabled
		Refresh
		Return True
	End Function

	Private Function IconPanel.HitTestItem(ByVal x As Long, ByVal y As Long) As Long
		If bLayoutDirty Then LayoutItems()
		Return HitTest(x, y)
	End Function

	Private Function IconPanel.GetItemRect(ByVal idx As Long, ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		If IsValidItem(idx) = False Then Return False
		If bLayoutDirty Then LayoutItems()
		rcLeft = m_Item(idx)->rc.Left: rcTop = m_Item(idx)->rc.Top
		rcRight = m_Item(idx)->rc.Right: rcBottom = m_Item(idx)->rc.Bottom
		Return rcRight > rcLeft
	End Function

	Private Function IconPanel.GetIdealWidth As Long
		'The total declared run width plus the client padding - valid any time
		Dim runW As Long = 0
		Dim i As Long
		For i = 0 To ItemCount() - 1
			With *m_Item(i)
				If .Kind = ikSeparator Then
					runW += m_SeparatorWidth
				Else
					runW += IIf(.PadBefore >= 0, .PadBefore, m_PadBefore) + IIf(.IconWidth >= 0, .IconWidth, m_IconWidth) + IIf(.PadAfter >= 0, .PadAfter, m_PadAfter)
				End If
			End With
		Next
		Return runW
	End Function

	Private Property IconPanel.Justify As IconPanelJustify
		Return m_Justify
	End Property

	Private Property IconPanel.Justify(Value As IconPanelJustify)
		m_Justify = Value
		bLayoutDirty = True
		Refresh
	End Property

	Private Property IconPanel.IconWidth As Long
		Return m_IconWidth
	End Property

	Private Property IconPanel.IconWidth(Value As Long)
		m_IconWidth = Max(1, Value)
		bLayoutDirty = True
		Refresh
	End Property

	Private Property IconPanel.IconHeight As Long
		Return m_IconHeight
	End Property

	Private Property IconPanel.IconHeight(Value As Long)
		m_IconHeight = Max(1, Value)
		bLayoutDirty = True
		Refresh
	End Property

	Private Property IconPanel.PadBefore As Long
		Return m_PadBefore
	End Property

	Private Property IconPanel.PadBefore(Value As Long)
		m_PadBefore = Max(0, Value)
		bLayoutDirty = True
		Refresh
	End Property

	Private Property IconPanel.PadAfter As Long
		Return m_PadAfter
	End Property

	Private Property IconPanel.PadAfter(Value As Long)
		m_PadAfter = Max(0, Value)
		bLayoutDirty = True
		Refresh
	End Property

	Private Property IconPanel.SeparatorWidth As Long
		Return m_SeparatorWidth
	End Property

	Private Property IconPanel.SeparatorWidth(Value As Long)
		m_SeparatorWidth = Max(0, Value)
		bLayoutDirty = True
		Refresh
	End Property

	Private Property IconPanel.PanelBackColor As ULong
		Return m_BackColor
	End Property

	Private Property IconPanel.PanelBackColor(Value As ULong)
		m_BackColor = Value
		Refresh
	End Property

	Private Property IconPanel.CellColor As ULong
		Return m_CellColor
	End Property

	Private Property IconPanel.CellColor(Value As ULong)
		m_CellColor = Value
		Refresh
	End Property

	Private Property IconPanel.CellColorHot As ULong
		Return m_CellColorHot
	End Property

	Private Property IconPanel.CellColorHot(Value As ULong)
		m_CellColorHot = Value
		Refresh
	End Property

	Private Property IconPanel.CellColorSelected As ULong
		Return m_CellColorSelected
	End Property

	Private Property IconPanel.CellColorSelected(Value As ULong)
		m_CellColorSelected = Value
		Refresh
	End Property

	Private Property IconPanel.CellColorDisabled As ULong
		Return m_CellColorDisabled
	End Property

	Private Property IconPanel.CellColorDisabled(Value As ULong)
		m_CellColorDisabled = Value
		Refresh
	End Property

	Private Property IconPanel.GlyphColor As ULong
		Return m_GlyphColor
	End Property

	Private Property IconPanel.GlyphColor(Value As ULong)
		m_GlyphColor = Value
		Refresh
	End Property

	Private Property IconPanel.GlyphColorHot As ULong
		Return m_GlyphColorHot
	End Property

	Private Property IconPanel.GlyphColorHot(Value As ULong)
		m_GlyphColorHot = Value
		Refresh
	End Property

	Private Property IconPanel.GlyphColorSelected As ULong
		Return m_GlyphColorSelected
	End Property

	Private Property IconPanel.GlyphColorSelected(Value As ULong)
		m_GlyphColorSelected = Value
		Refresh
	End Property

	Private Property IconPanel.GlyphColorDisabled As ULong
		Return m_GlyphColorDisabled
	End Property

	Private Property IconPanel.GlyphColorDisabled(Value As ULong)
		m_GlyphColorDisabled = Value
		Refresh
	End Property

	Private Property IconPanel.SeparatorColor As ULong
		Return m_SeparatorColor
	End Property

	Private Property IconPanel.SeparatorColor(Value As ULong)
		m_SeparatorColor = Value
		Refresh
	End Property

	#ifndef ReadProperty_Off
		Private Function IconPanel.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Return Base.ReadProperty(PropertyName)
		End Function
	#endif

	#ifndef WriteProperty_Off
		Private Function IconPanel.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			Return Base.WriteProperty(PropertyName, Value)
		End Function
	#endif

	Private Operator IconPanel.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator

	End Namespace
'#End Region
