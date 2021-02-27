'################################################################################
'#  Chart.bi                                                                    #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2019-2021)                                     #
'#  not finished, in progress                                                   #
'################################################################################

#include once "Chart.bi"

Namespace My.Sys.Forms
	Function Chart.ReadProperty(ByRef PropertyName As String) As Any Ptr
		FTempString = LCase(PropertyName)
		Select Case FTempString
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function Chart.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		If Value = 0 Then
			Select Case LCase(PropertyName)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		Else
			Select Case LCase(PropertyName)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		End If
		Return True
	End Function
	
	Public Sub Chart.GetCenterPie(X As Single, Y As Single)
		X = m_CenterCircle.X
		Y = m_CenterCircle.Y
	End Sub
	
	Public Property Chart.Count() As Long
		Count = ItemsCount
	End Property
	
	Public Property Chart.Special(Index As Long, Value As Boolean)
		m_Item(Index).Special = Value
		Me.Refresh
	End Property
	
	Public Property Chart.Special(Index As Long) As Boolean
		Return m_Item(Index).Special
	End Property
	
	Public Property Chart.ItemColor(Index As Long, Value As OLE_COLOR)
		m_Item(Index).ItemColor = Value
		Me.Refresh
	End Property
	
	Public Property Chart.ItemColor(Index As Long) As OLE_COLOR
		Return m_Item(Index).ItemColor
	End Property
	
	Public Sub Chart.Clear()
		Dim i As Long
		For i = 0 To ItemsCount - 1
			GdipDeletePath m_Item(i).hPath
		Next
		ItemsCount = 0
		ReDim Preserve m_Item(0)
		Me.Refresh
	End Sub
	
	Public Sub Chart.AddItem(ByRef ItemName As WString, Value As Single, Item_Color As Long, bSpecial As Boolean = False)
		ReDim Preserve m_Item(ItemsCount)
		With m_Item(ItemsCount)
			.ItemName = ItemName
			.ItemColor = Item_Color
			.Value = Value
			.Special = bSpecial
		End With
		ItemsCount = ItemsCount + 1
	End Sub
	
	Public Property Chart.Title() ByRef As WString
		Return *m_Title.vptr
	End Property
	
	Public Property Chart.Title(ByRef New_Value As WString)
		m_Title = New_Value
		Refresh
	End Property
	
	Public Property Chart.TitleFont() As My.Sys.Drawing.Font
		Return m_TitleFont
	End Property
	
	Public Property Chart.TitleFont(ByRef New_Value As My.Sys.Drawing.Font)
		m_TitleFont = New_Value
		Refresh
	End Property
	
	Public Property Chart.TitleForeColor() As OLE_COLOR
		TitleForeColor = m_TitleForeColor
	End Property
	
	Public Property Chart.TitleForeColor(ByVal New_Value As OLE_COLOR)
		m_TitleForeColor = New_Value
		Refresh
	End Property
	
	Public Property Chart.BackColorOpacity() As Long
		BackColorOpacity = m_BackColorOpacity
	End Property
	
	Public Property Chart.BackColorOpacity(ByVal New_Value As Long)
		m_BackColorOpacity = New_Value
		Refresh
	End Property
	
	Public Property Chart.FillOpacity() As Long
		FillOpacity = m_FillOpacity
	End Property
	
	Public Property Chart.FillOpacity(ByVal New_Value As Long)
		m_FillOpacity = New_Value
		Refresh
	End Property
	
	Public Property Chart.Border() As Boolean
		Border = m_Border
	End Property
	
	Public Property Chart.Border(ByVal New_Value As Boolean)
		m_Border = New_Value
		Refresh
	End Property
	
	Public Property Chart.BorderRound() As Long
		BorderRound = m_BorderRound
	End Property
	
	Public Property Chart.BorderRound(ByVal New_Value As Long)
		m_BorderRound = New_Value
		Refresh
	End Property
	
	Public Property Chart.BorderColor() As OLE_COLOR
		BorderColor = m_BorderColor
	End Property
	
	Public Property Chart.BorderColor(ByVal New_Value As OLE_COLOR)
		m_BorderColor = New_Value
		Refresh
	End Property
	
	Public Property Chart.LabelsFormats() As String
		LabelsFormats = m_LabelsFormats
	End Property
	
	Public Property Chart.LabelsFormats(ByVal New_Value As String)
		m_LabelsFormats = New_Value
		Refresh
	End Property
	
	Public Property Chart.FillGradient() As Boolean
		FillGradient = m_FillGradient
	End Property
	
	Public Property Chart.FillGradient(ByVal New_Value As Boolean)
		m_FillGradient = New_Value
		Refresh
	End Property
	
	Public Property Chart.ChartStyle() As ChartStyles
		ChartStyle = m_ChartStyle
	End Property
	
	Public Property Chart.ChartStyle(ByVal New_Value As ChartStyles)
		m_ChartStyle = New_Value
		Refresh
	End Property
	
	Public Property Chart.LegendAlign() As ucPC_LegendAlign
		LegendAlign = m_LegendAlign
	End Property
	
	Public Property Chart.LegendAlign(ByVal New_Value As ucPC_LegendAlign)
		m_LegendAlign = New_Value
		Refresh
	End Property
	
	Public Property Chart.LegendVisible() As Boolean
		LegendVisible = m_LegendVisible
	End Property
	
	Public Property Chart.LegendVisible(ByVal New_Value As Boolean)
		m_LegendVisible = New_Value
		Refresh
	End Property
	
	Public Property Chart.DonutWidth() As Single
		DonutWidth = m_DonutWidth
	End Property
	
	Public Property Chart.DonutWidth(ByVal New_Value As Single)
		m_DonutWidth = New_Value
		Refresh
	End Property
	
	Public Property Chart.SeparatorLine() As Boolean
		SeparatorLine = m_SeparatorLine
	End Property
	
	Public Property Chart.SeparatorLine(ByVal New_Value As Boolean)
		m_SeparatorLine = New_Value
		Refresh
	End Property
	
	Public Property Chart.SeparatorLineWidth() As Single
		SeparatorLineWidth = m_SeparatorLineWidth
	End Property
	
	Public Property Chart.SeparatorLineWidth(ByVal New_Value As Single)
		m_SeparatorLineWidth = New_Value
		Refresh
	End Property
	
	Public Property Chart.SeparatorLineColor() As OLE_COLOR
		SeparatorLineColor = m_SeparatorLineColor
	End Property
	
	Public Property Chart.SeparatorLineColor(ByVal New_Value As OLE_COLOR)
		m_SeparatorLineColor = New_Value
		Refresh
	End Property
	
	Public Property Chart.LabelsPosition() As LabelsPositions
		LabelsPosition = m_LabelsPositions
	End Property
	
	Public Property Chart.LabelsPosition(ByVal New_Value As LabelsPositions)
		m_LabelsPositions = New_Value
		Refresh
	End Property
	
	Public Property Chart.LabelsVisible() As Boolean
		LabelsVisible = m_LabelsVisible
	End Property
	
	Public Property Chart.LabelsVisible(ByVal New_Value As Boolean)
		m_LabelsVisible = New_Value
		Refresh
	End Property
	
	Public Property Chart.Rotation() As Long
		Rotation = m_Rotation
	End Property
	
	Public Property Chart.Rotation(ByVal New_Value As Long)
		m_Rotation = New_Value Mod 360
		If m_Rotation < 0 Then m_Rotation = 360 + m_Rotation
		Refresh
	End Property
	
	Private Sub Chart.tmrMOUSEOVER_Timer_(ByRef Sender As TimerComponent)
		*Cast(Chart Ptr, Sender.Designer).tmrMOUSEOVER_Timer(Sender)
	End Sub
	Private Sub Chart.tmrMOUSEOVER_Timer(ByRef Sender As TimerComponent)
		Dim PT As Point
		Dim Rect As RectL
		If c_lhWnd = 0 Then Exit Sub
		
		GetCursorPos @PT
		ScreenToClient c_lhWnd, @PT
		
		With Rect
			.Left = m_PT.X - (m_Left - ScaleX(This.Left))
			.Top = m_PT.Y - (m_Top - ScaleY(This.Top))
			.Width = This.ClientWidth
			.Height = This.ClientHeight
		End With
		
		If PtInRectL(Rect, PT.X, PT.Y) = 0 Then
			'mHotBar = -1
			HotItem = -1
			tmrMOUSEOVER.Interval = 0
			Me.Refresh
			'RaiseEvent MouseLeave
		End If
	End Sub
	
	Private Sub Chart.InitProperties()
		m_Title = This.Name
		FBackColor = clWhite
		m_BackColorOpacity = 100
		FForeColor = clBlack
		m_FillOpacity = 100
		m_Border = False
		m_BorderColor = &HF4F4F4
		m_LinesWidth = 1
		m_VerticalLines = False
		m_FillGradient = False
		m_HorizontalLines = True
		m_ChartStyle = CS_PIE
		m_ChartOrientation = CO_Vertical
		m_LegendAlign = LA_RIGHT
		m_LegendVisible = True
		m_TitleFont.Name = This.Font.Name
		m_TitleFont.Size = This.Font.Size + 8
		m_DonutWidth = 50!
		m_SeparatorLine = True
		m_SeparatorLineWidth = 2!
		m_SeparatorLineColor = clWhite
		m_LabelsVisible = True
		m_LabelsPositions = LP_Inside
		m_LabelsFormats = "{P}%"
		m_BorderRound = 0
		
		'c_lhWnd = UserControl.ContainerHwnd
		
		If DesignMode Then Call Example
	End Sub
	
	
	Private Function Chart.GetTextSize(ByVal hGraphics As Long, ByVal text As String, ByVal Width As Long, ByVal Height As Long, ByVal oFont As StdFont, ByVal bWordWrap As Boolean, ByRef SZ As SIZEF) As Long
		Dim hBrush As Long
		Dim hFontFamily As Long
		Dim hFormat As Long
		Dim layoutRect As RectF
		Dim lFontSize As Long
		Dim lFontStyle As GDIPLUS_FONTSTYLE
		Dim hFont
		Dim BB As RectF, CF As Long, LF As Long
		
		If GdipCreateFontFamilyFromName(StrPtr(oFont.Name), 0, hFontFamily) Then
			If GdipGetGenericFontFamilySansSerif(hFontFamily) Then Exit Function
		End If
		
		If GdipCreateStringFormat(0, 0, hFormat) = 0 Then
			If Not bWordWrap Then GdipSetStringFormatFlags hFormat, StringFormatFlagsNoWrap
		End If
		
		If oFont.Bold Then lFontStyle = lFontStyle Or FontStyleBold
		If oFont.Italic Then lFontStyle = lFontStyle Or FontStyleItalic
		If oFont.Underline Then lFontStyle = lFontStyle Or FontStyleUnderline
		If oFont.Strikethrough Then lFontStyle = lFontStyle Or FontStyleStrikeout
		
		
		lFontSize = MulDiv(oFont.Size, GetDeviceCaps(UserControl.hDC, LOGPIXELSY), 72)
		
		layoutRect.Width = Width * nScale: layoutRect.Height = Height * nScale
		
		Call GdipCreateFont(hFontFamily, lFontSize, lFontStyle, UnitPixel, hFont)
		
		GdipMeasureString hGraphics, StrPtr(text), -1, hFont, layoutRect, hFormat, BB, CF, LF
		
		SZ.Width = BB.Width
		SZ.Height = BB.Height
		
		GdipDeleteFont hFont
		GdipDeleteStringFormat hFormat
		GdipDeleteFontFamily hFontFamily
		
		
	End Function
	
	
	Private Function Chart.DrawText(ByVal hGraphics As Long, ByVal text As String, ByVal X As Long, ByVal Y As Long, ByVal Width As Long, ByVal Height As Long, ByVal oFont As StdFont, ByVal ForeColor As Long, Optional HAlign As CaptionAlignmentH, Optional VAlign As CaptionAlignmentV, Optional bWordWrap As Boolean) As Long
		Dim hBrush As Long
		Dim hFontFamily As Long
		Dim hFormat As Long
		Dim layoutRect As RectF
		Dim lFontSize As Long
		Dim lFontStyle As GDIPLUS_FONTSTYLE
		Dim hFont As Long
		Dim hDC As Long
		
		
		If GdipCreateFontFamilyFromName(StrPtr(oFont.Name), 0, hFontFamily) <> GDIP_OK Then
			If GdipGetGenericFontFamilySansSerif(hFontFamily) <> GDIP_OK Then Exit Function
			'If GdipGetGenericFontFamilySerif(hFontFamily) Then Exit Function
		End If
		
		If GdipCreateStringFormat(0, 0, hFormat) = GDIP_OK Then
			If Not bWordWrap Then GdipSetStringFormatFlags hFormat, StringFormatFlagsNoWrap
			'GdipSetStringFormatFlags hFormat, HotkeyPrefixShow
			GdipSetStringFormatAlign hFormat, HAlign
			GdipSetStringFormatLineAlign hFormat, VAlign
		End If
		
		If oFont.Bold Then lFontStyle = lFontStyle Or FontStyleBold
		If oFont.Italic Then lFontStyle = lFontStyle Or FontStyleItalic
		If oFont.Underline Then lFontStyle = lFontStyle Or FontStyleUnderline
		If oFont.Strikethrough Then lFontStyle = lFontStyle Or FontStyleStrikeout
		
		
		hDC = GetDC(0&)
		lFontSize = MulDiv(oFont.Size, GetDeviceCaps(UserControl.hDC, LOGPIXELSY), 72)
		ReleaseDC 0&, hDC
		
		layoutRect.Left = X: layoutRect.Top = Y
		layoutRect.Width = Width: layoutRect.Height = Height
		
		If GdipCreateSolidFill(ForeColor, hBrush) = GDIP_OK Then
			If GdipCreateFont(hFontFamily, lFontSize, lFontStyle, UnitPixel, hFont) = GDIP_OK Then
				GdipDrawString hGraphics, StrPtr(text), -1, hFont, layoutRect, hFormat, hBrush
				GdipDeleteFont hFont
			End If
			GdipDeleteBrush hBrush
		End If
		
		If hFormat Then GdipDeleteStringFormat hFormat
		GdipDeleteFontFamily hFontFamily
		
		
	End Function
	
	Public Function Chart.GetWindowsDPI() As Double
		Dim hDC As Long, LPX  As Double
		hDC = GetDC(0)
		LPX = CDbl(GetDeviceCaps(hDC, LOGPIXELSX))
		ReleaseDC 0, hDC
		
		If (LPX = 0) Then
			GetWindowsDPI = 1#
		Else
			GetWindowsDPI = LPX / 96#
		End If
	End Function
	
	Private Sub UserControl_HitTest(X As Single, Y As Single, HitResult As Integer)
		If UserControl.Enabled Then
			HitResult = vbHitResultHit
			If Ambient.UserMode Then
				Dim PT As POINTL
				
				If tmrMOUSEOVER.Interval = 0 Then
					GetCursorPos PT
					ScreenToClient c_lhWnd, PT
					m_PT.X = PT.X - X
					m_PT.Y = PT.Y - Y
					
					m_Left = ScaleX(Extender.Left, vbContainerSize, UserControl.ScaleMode)
					m_Top = ScaleY(Extender.Top, vbContainerSize, UserControl.ScaleMode)
					
					
					tmrMOUSEOVER.Interval = 1
					'RaiseEvent MouseEnter
				End If
				
			End If
		End If
	End Sub
	
	Private Sub UserControl_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
		RaiseEvent MouseUp(Button, Shift, X, Y)
		
		Dim i As Long
		Dim lResult As Long
		
		If Button <> vbLeftButton Then Exit Sub
		
		For i = 0 To ItemsCount - 1
			
			lResult = 0
			Call GdipIsVisiblePathPoint(m_Item(i).hPath, X, Y, 0&, lResult)
			
			If lResult Then
				If i = HotItem Then
					RaiseEvent ItemClick(i)
				End If
				Exit Sub
			End If
			
		Next
	End Sub
	Private Sub UserControl_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
		RaiseEvent MouseDown(Button, Shift, X, Y)
	End Sub
	Private Sub UserControl_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
		Dim i As Long
		Dim lResult As Long
		RaiseEvent MouseMove(Button, Shift, X, Y)
		If Button <> 0 Then Exit Sub
		For i = 0 To ItemsCount - 1
			
			If PtInRectL(m_Item(i).LegendRect, X, Y) Then
				If i <> HotItem Then
					HotItem = i
					Me.Refresh
				End If
				Exit Sub
			End If
			
			lResult = 0
			Call GdipIsVisiblePathPoint(m_Item(i).hPath, X, Y, 0&, lResult)
			
			If lResult Then
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
		
	End Sub
	
	Private Function Chart.PtInRectL(Rect As RectL, ByVal X As Single, ByVal Y As Single) As Boolean
		With Rect
			If X >= .Left And X <= .Left + .Width And Y >= .Top And Y <= .Top + .Height Then
				PtInRectL = True
			End If
		End With
	End Function
	'Private Sub UserControl_KeyDown(KeyCode As Integer, Shift As Integer)
	'    RaiseEvent KeyDown(KeyCode, Shift)
	'End Sub
	'
	'Private Sub UserControl_KeyPress(KeyAscii As Integer)
	'     RaiseEvent KeyPress(KeyAscii)
	'End Sub
	'
	'Private Sub UserControl_KeyUp(KeyCode As Integer, Shift As Integer)
	'    RaiseEvent KeyUp(KeyCode, Shift)
	'End Sub
	'
	'Private Sub UserControl_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, y As Single)
	'    RaiseEvent OLEDragDrop(Data, Effect, Button, Shift, x, y)
	'End Sub
	'
	'Private Sub UserControl_OLEDragOver(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, x As Single, y As Single, State As Integer)
	'    RaiseEvent OLEDragOver(Data, Effect, Button, Shift, x, y, State)
	'End Sub
	
	Private Sub UserControl_Paint()
		Draw
	End Sub
	
	Public Sub Chart.Refresh()
		This.Update
	End Sub
	
	Private Sub UserControl_Show()
		Me.Refresh
	End Sub
	
	Private Function Chart.ManageGDIToken(ByVal projectHwnd As Long) As Long ' by LaVolpe
		If projectHwnd = 0& Then Exit Function
		
		Dim hwndGDIsafe     As Long                 'API window to monitor IDE shutdown
		
		Do
			hwndGDIsafe = GetParent(projectHwnd)
			If Not hwndGDIsafe = 0& Then projectHwnd = hwndGDIsafe
		Loop Until hwndGDIsafe = 0&
		' ok, got the highest level parent, now find highest level owner
		Do
			hwndGDIsafe = GetWindow(projectHwnd, GW_OWNER)
			If Not hwndGDIsafe = 0& Then projectHwnd = hwndGDIsafe
		Loop Until hwndGDIsafe = 0&
		
		hwndGDIsafe = FindWindowEx(projectHwnd, 0&, "Static", "GDI+Safe Patch")
		
		If hwndGDIsafe Then
			ManageGDIToken = hwndGDIsafe    ' we already have a manager running for this VB instance
			Exit Function                   ' can abort
		End If
		
		Dim gdiSI           As GDIPlusStartupInput  'GDI+ startup info
		Dim gToken          As Long                 'GDI+ instance token
		
		On Error Resume Next
		gdiSI.GdiPlusVersion = 1                    ' attempt to start GDI+
		GdiplusStartup gToken, gdiSI
		If gToken = 0& Then                         ' failed to start
			If Err Then Err.Clear
			Exit Function
		End If
		On Error Goto 0
		
		Dim z_ScMem         As Long                 'Thunk base address
		Dim z_Code()        As Long                 'Thunk machine-code initialised here
		Dim nAddr           As Long                 'hwndGDIsafe prev window procedure
		
		Const WNDPROC_OFF   As Long = &H30          'Offset where window proc starts from z_ScMem
		Const PAGE_RWX      As Long = &H40&         'Allocate executable memory
		Const MEM_COMMIT    As Long = &H1000&       'Commit allocated memory
		Const MEM_RELEASE   As Long = &H8000&       'Release allocated memory flag
		Const MEM_LEN       As Long = &HD4          'Byte length of thunk
		
		z_ScMem = VirtualAlloc(0, MEM_LEN, MEM_COMMIT, PAGE_RWX) 'Allocate executable memory
		If z_ScMem <> 0 Then                                     'Ensure the allocation succeeded
			' we make the api window a child so we can use FindWindowEx to locate it easily
			hwndGDIsafe = CreateWindowExA(0&, "Static", "GDI+Safe Patch", WS_CHILD, 0&, 0&, 0&, 0&, projectHwnd, 0&, App.hInstance, ByVal 0&)
			If hwndGDIsafe <> 0 Then
				
				ReDim z_Code(0 To MEM_LEN \ 4 - 1)
				
				z_Code(12) = &HD231C031: z_Code(13) = &HBBE58960: z_Code(14) = &H12345678: z_Code(15) = &H3FFF631: z_Code(16) = &H74247539: z_Code(17) = &H3075FF5B: z_Code(18) = &HFF2C75FF: z_Code(19) = &H75FF2875
				z_Code(20) = &H2C73FF24: z_Code(21) = &H890853FF: z_Code(22) = &HBFF1C45: z_Code(23) = &H2287D81: z_Code(24) = &H75000000: z_Code(25) = &H443C707: z_Code(26) = &H2&: z_Code(27) = &H2C753339: z_Code(28) = &H2047B81: z_Code(29) = &H75000000
				z_Code(30) = &H2C73FF23: z_Code(31) = &HFFFFFC68: z_Code(32) = &H2475FFFF: z_Code(33) = &H681C53FF: z_Code(34) = &H12345678: z_Code(35) = &H3268&: z_Code(36) = &HFF565600: z_Code(37) = &H43892053: z_Code(38) = &H90909020: z_Code(39) = &H10C261
				z_Code(40) = &H562073FF: z_Code(41) = &HFF2453FF: z_Code(42) = &H53FF1473: z_Code(43) = &H2873FF18: z_Code(44) = &H581053FF: z_Code(45) = &H89285D89: z_Code(46) = &H45C72C75: z_Code(47) = &H800030: z_Code(48) = &H20458B00: z_Code(49) = &H89145D89
				z_Code(50) = &H81612445: z_Code(51) = &H4C4&: z_Code(52) = &HC63FF00
				
				z_Code(1) = 0                                                   ' shutDown mode; used internally by ASM
				z_Code(2) = zFnAddr("user32", "CallWindowProcA")                ' function pointer CallWindowProc
				z_Code(3) = zFnAddr("kernel32", "VirtualFree")                  ' function pointer VirtualFree
				z_Code(4) = zFnAddr("kernel32", "FreeLibrary")                  ' function pointer FreeLibrary
				z_Code(5) = gToken                                              ' Gdi+ token
				z_Code(10) = LoadLibrary("gdiplus")                             ' library pointer (add reference)
				z_Code(6) = GetProcAddress(z_Code(10), "GdiplusShutdown")       ' function pointer GdiplusShutdown
				z_Code(7) = zFnAddr("user32", "SetWindowLongA")                 ' function pointer SetWindowLong
				z_Code(8) = zFnAddr("user32", "SetTimer")                       ' function pointer SetTimer
				z_Code(9) = zFnAddr("user32", "KillTimer")                      ' function pointer KillTimer
				
				z_Code(14) = z_ScMem                                            ' ASM ebx start point
				z_Code(34) = z_ScMem + WNDPROC_OFF                              ' subclass window procedure location
				
				RtlMoveMemory z_ScMem, VarPtr(z_Code(0)), MEM_LEN               'Copy the thunk code/data to the allocated memory
				
				nAddr = SetWindowLong(hwndGDIsafe, GWL_WNDPROC, z_ScMem + WNDPROC_OFF) 'Subclass our API window
				RtlMoveMemory z_ScMem + 44, VarPtr(nAddr), 4& ' Add prev window procedure to the thunk
				gToken = 0& ' zeroize so final check below does not release it
				
				ManageGDIToken = hwndGDIsafe    ' return handle of our GDI+ manager
			Else
				VirtualFree z_ScMem, 0, MEM_RELEASE     ' failure - release memory
				z_ScMem = 0&
			End If
		Else
			VirtualFree z_ScMem, 0, MEM_RELEASE           ' failure - release memory
			z_ScMem = 0&
		End If
		
		If gToken Then GdiplusShutdown gToken       ' release token if error occurred
		
	End Function
	
	Private Function Chart.zFnAddr(ByVal sDLL As String, ByVal sProc As String) As Long
		zFnAddr = GetProcAddress(GetModuleHandleA(sDLL), sProc)  'Get the specified procedure address
	End Function
	
	Private Function Chart.SafeRange(Value, Min, Max)
		
		If Value < Min Then
			SafeRange = Min
		ElseIf Value > Max Then
			SafeRange = Max
		Else
			SafeRange = Value
		End If
	End Function
	
	
	Public Function Chart.RGBtoARGB(ByVal RGBColor As Long, ByVal Opacity As Long) As Long
		'By LaVople
		' GDI+ color conversion routines. Most GDI+ functions require ARGB format vs standard RGB format
		' This routine will return the passed RGBcolor to RGBA format
		' Passing VB system color constants is allowed, i.e., vbButtonFace
		' Pass Opacity as a value from 0 to 255
		
		If (RGBColor And &H80000000) Then RGBColor = GetSysColor(RGBColor And &HFF&)
		RGBtoARGB = (RGBColor And &HFF00&) Or (RGBColor And &HFF0000) \ &H10000 Or (RGBColor And &HFF) * &H10000
		Opacity = CByte((Abs(Opacity) / 100) * 255)
		If Opacity < 128 Then
			If Opacity < 0& Then Opacity = 0&
			RGBtoARGB = RGBtoARGB Or Opacity * &H1000000
		Else
			If Opacity > 255& Then Opacity = 255&
			RGBtoARGB = RGBtoARGB Or (Opacity - 128&) * &H1000000 Or &H80000000
		End If
		
	End Function
	
	
	
	'*1
	Private Sub Chart.Draw()
		Dim hGraphics As Long
		Dim hBrush As Long, hPen As Long
		Dim i As Single, j As Long
		Dim mHeight As Single
		Dim mWidth As Single
		Dim mPenWidth As Single
		Dim MarginLeft As Single
		Dim MarginRight As Single
		Dim TopHeader As Single
		Dim Footer As Single
		Dim TextWidth As Single
		Dim TextHeight As Single
		Dim XX As Single, YY As Single
		Dim lForeColor As Long
		Dim RectL As RectL
		Dim LabelsRect As RectL
		Dim PT16 As Single
		Dim ColRow As Integer
		Dim TitleSize As SIZEF
		Dim sDisplay As String
		Dim SafePercent As Single
		Dim Min As Single, LastAngle As Single, Angle As Single, Total  As Single
		Dim DonutSize As Single
		Dim R1 As Single, R2 As Single, R3 As Single
		Dim CX As Single, CY   As Single
		Dim Left As Single, Top As Single
		Dim Percent As Single
		Const PItoRAD = 3.141592 / 180
		Dim lTop As Single
		Dim sLabelText As String
		Dim bAngMaj180 As Boolean
		Dim LblWidth As Single
		Dim LblHeight As Single
		Dim mFormat As String
		Dim A As Single
		Dim Displacement As Single
		Dim lColor As Long
		
		If GdipCreateFromHDC(hDC, hGraphics) Then Exit Sub
		
		Call GdipSetSmoothingMode(hGraphics, SmoothingModeAntiAlias)
		
		PT16 = 16 * nScale
		mPenWidth = 1 * nScale
		DonutSize = m_DonutWidth * nScale
		
		MarginLeft = PT16
		TopHeader = PT16
		MarginRight = PT16
		Footer = PT16
		
		If m_LegendVisible Then
			For i = 0 To ItemsCount - 1
				m_Item(i).TextHeight = UserControl.TextHeight(m_Item(i).ItemName) * 1.5
				m_Item(i).TextWidth = UserControl.TextWidth(m_Item(i).ItemName) * 1.5 + m_Item(i).TextHeight
			Next
		End If
		
		If Len(m_Title) Then
			Call GetTextSize(hGraphics, m_Title, UserControl.ScaleWidth, 0, m_TitleFont, True, TitleSize)
			TopHeader = TopHeader + TitleSize.Height
		End If
		
		mWidth = UserControl.ScaleWidth - MarginLeft - MarginRight
		mHeight = UserControl.ScaleHeight - TopHeader - Footer
		
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
							.Width = .Width + TextWidth
							ColRow = ColRow + 1
							TextWidth = 0
							TextHeight = 0
						End If
						
						TextHeight = TextHeight + m_Item(i).TextHeight
						.Height = .Height + m_Item(i).TextHeight
						
						If TextWidth < m_Item(i).TextWidth Then
							TextWidth = m_Item(i).TextWidth '+ PT16
						End If
					Next
					.Width = .Width + TextWidth
					If m_LegendAlign = LA_LEFT Then
						MarginLeft = MarginLeft + .Width
					Else
						MarginRight = MarginRight + .Width
					End If
					mWidth = mWidth - .Width
				End With
				
			Case LA_BOTTOM, LA_TOP
				With LabelsRect
					
					.Height = m_Item(0).TextHeight + PT16 / 2
					TextWidth = 0
					For i = 0 To ItemsCount - 1
						If TextWidth + m_Item(i).TextWidth > mWidth Then
							.Height = .Height + m_Item(i).TextHeight
							ColRow = ColRow + 1
							TextWidth = 0
						End If
						TextWidth = TextWidth + m_Item(i).TextWidth
						.Width = .Width + m_Item(i).TextWidth
					Next
					If m_LegendAlign = LA_TOP Then
						TopHeader = TopHeader + .Height
					End If
					mHeight = mHeight - .Height
				End With
			End Select
		End If
		
		
		Dim RectF As RectF
		With RectF
			.Width = UserControl.ScaleWidth - 1 * nScale
			.Height = UserControl.ScaleHeight - 1 * nScale
		End With
		
		RoundRect hGraphics, RectF, RGBtoARGB(m_BackColor, m_BackColorOpacity), RGBtoARGB(m_BorderColor, 100), m_BorderRound * nScale, m_Border
		
		
		'    'Background
		'    If m_BackColorOpacity > 0 Then
		'        GdipCreateSolidFill RGBtoARGB(m_BackColor, m_BackColorOpacity), hBrush
		'        GdipFillRectangleI hGraphics, hBrush, 0, 0, UserControl.ScaleWidth, UserControl.ScaleHeight
		'        GdipDeleteBrush hBrush
		'    End If
		'
		'    'Border
		'    If m_Border Then
		'        Call GdipCreatePen1(RGBtoARGB(m_BorderColor, 50), mPenWidth, &H2, hPen)
		'        GdipDrawRectangleI hGraphics, hPen, mPenWidth / 2, mPenWidth / 2, UserControl.ScaleWidth - mPenWidth, UserControl.ScaleHeight - mPenWidth
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
				.text = Replace(.text, "{P}", Percent)
				.text = Replace(.text, "{V}", Round(.Value, 1))
				.text = Replace(.text, "{LF}", vbLf)
				
				TextWidth = UserControl.TextWidth(.text) * 1.3
				TextHeight = UserControl.TextHeight(.text) * 1.3
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
				Left = XX + (R2 * Cos((LastAngle + Angle / 2) * PItoRAD))
				Top = YY + (R2 * Sin((LastAngle + Angle / 2) * PItoRAD))
			Else
				Left = XX
				Top = YY
			End If
			
			If m_Item(i).hPath <> 0 Then GdipDeletePath m_Item(i).hPath
			GdipCreatePath 0, m_Item(i).hPath
			
			If m_ChartStyle = CS_DONUT Then
				GdipAddPathArc m_Item(i).hPath, Left, Top, Min, Min, LastAngle, Angle
				GdipAddPathArc m_Item(i).hPath, Left + DonutSize, Top + DonutSize, Min - DonutSize * 2, Min - DonutSize * 2, LastAngle + Angle, -Angle
			Else
				GdipAddPathPie m_Item(i).hPath, Left, Top, Min, Min, LastAngle, Angle
			End If
			
			If HotItem = i Then
				lColor = RGBtoARGB(ShiftColor(m_Item(i).ItemColor, vbWhite, 150), m_FillOpacity)
			Else
				lColor = RGBtoARGB(m_Item(i).ItemColor, m_FillOpacity)
			End If
			If m_FillGradient Then
				With RectL
					.Left = MarginLeft - R2
					.Top = TopHeader - R2
					.Width = mWidth + R2 * 2
					.Height = mHeight + R2 * 2
				End With
				GdipCreateLineBrushFromRectWithAngleI RectL, lColor, RGBtoARGB(vbWhite, 100), 180 + LastAngle + Angle / 2, 0, WrapModeTile, hBrush
			Else
				GdipCreateSolidFill lColor, hBrush
			End If
			GdipFillPath hGraphics, hBrush, m_Item(i).hPath
			GdipDeleteBrush hBrush
			
			R1 = Min / 2
			R2 = m_Item(i).TextWidth / 2
			R3 = m_Item(i).TextHeight / 2
			
			CX = XX + Min / 2 + TextWidth
			CY = YY + Min / 2 + TextHeight
			
			Left = CX + ((R1 - R2) * Cos((LastAngle + Angle / 2) * PItoRAD)) - R2
			Top = CY + ((R1 - R3) * Sin((LastAngle + Angle / 2) * PItoRAD)) - R3
			'DrawText hGraphics, m_Item(i).ItemName, Left, Top, R2 * 2, R3 * 2, UserControl.Font, lForeColor, cCenter, cMiddle
			LastAngle = LastAngle + Angle '+ 2
		Next
		
		
		'*2
		
		
		
		LastAngle = m_Rotation - 90
		bAngMaj180 = False
		For i = 0 To ItemsCount - 1
			Angle = 360 * m_Item(i).Value / Total
			
			If m_SeparatorLine Then
				GdipCreatePen1 RGBtoARGB(m_SeparatorLineColor, 100), m_SeparatorLineWidth * nScale, &H2, hPen
				GdipSetPenEndCap hPen, &H2
				
				R1 = (Min + mPenWidth / 2) / 2
				R2 = (Min - mPenWidth / 2) / 2 - DonutSize
				
				CX = XX + Min / 2
				CY = YY + Min / 2
				
				Left = CX + (R1 * Cos((LastAngle) * PItoRAD))
				Top = CY + (R1 * Sin((LastAngle) * PItoRAD))
				
				If m_ChartStyle = CS_DONUT Then
					CX = CX + (R2 * Cos((LastAngle) * PItoRAD))
					CY = CY + (R2 * Sin((LastAngle) * PItoRAD))
				Else
					'GdipDrawEllipseI hGraphics, hPen, XX, YY, Min, Min
				End If
				
				GdipDrawLineI hGraphics, hPen, Left, Top, CX, CY
				
				GdipDeletePen hPen
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
				Left = CX + ((R1 - R2 + Displacement) * Cos(A * PItoRAD)) - R2
				Top = CY + ((R1 - R3 + Displacement) * Sin(A * PItoRAD)) - R3
			Else
				Left = CX + ((R1 + R2 + Displacement) * Cos(A * PItoRAD)) - R2
				Top = CY + ((R1 + R3 + Displacement) * Sin(A * PItoRAD)) - R3
			End If
			If m_LabelsVisible Then
				If m_LabelsPositions = LP_TwoColumns Then
					Dim LineOut As Integer
					LineOut = UserControl.TextHeight("Aj") / 2
					GdipCreateSolidFill RGBtoARGB(m_Item(i).ItemColor, 50), hBrush
					GdipCreatePen1 RGBtoARGB(m_Item(i).ItemColor, 100), 1 * nScale, &H2, hPen
					
					If (LastAngle + Angle / 2 + 90) Mod 359 < 180 Then
						If bAngMaj180 Then
							bAngMaj180 = False
							lTop = Top
						End If
						
						If lTop <= 0 Then lTop = Top
						
						If Top < lTop Then
							lTop = lTop
						Else
							lTop = Top
						End If
						
						Left = XX + Min + PT16
						
						GdipFillRectangleI hGraphics, hBrush, Left, lTop, TextWidth, TextHeight
						DrawText hGraphics, m_Item(i).text, Left, lTop, TextWidth, TextHeight, UserControl.Font, RGBtoARGB(m_ForeColor, 100), cCenter, cMiddle
						lTop = lTop + TextHeight
						
						Left = CX + (R1 * Cos(A * PItoRAD))
						Top = CY + (R1 * Sin(A * PItoRAD))
						CX = CX + ((R1 + LineOut) * Cos(A * PItoRAD))
						CY = CY + ((R1 + LineOut) * Sin(A * PItoRAD))
						
						GdipDrawLineI hGraphics, hPen, Left, Top, CX, CY
						Left = XX + Min + PT16
						Top = lTop - TextHeight / 2
						GdipDrawLineI hGraphics, hPen, CX, CY, Left, Top
					Else
						If bAngMaj180 = False Then
							bAngMaj180 = True
							lTop = TopHeader + mHeight
						End If
						
						If lTop <= 0 Then lTop = Top
						
						If Top > lTop Then
							lTop = lTop
						Else
							lTop = Top
						End If
						
						Left = XX - TextWidth - PT16
						GdipFillRectangleI hGraphics, hBrush, Left, lTop, TextWidth, TextHeight
						DrawText hGraphics, m_Item(i).text, Left, lTop, TextWidth, TextHeight, UserControl.Font, RGBtoARGB(m_ForeColor, 100), cCenter, cMiddle
						Left = CX + (R1 * Cos(A * PItoRAD))
						Top = CY + (R1 * Sin(A * PItoRAD))
						CX = CX + ((R1 + LineOut) * Cos(A * PItoRAD))
						CY = CY + ((R1 + LineOut) * Sin(A * PItoRAD))
						GdipDrawLineI hGraphics, hPen, Left, Top, CX, CY
						Left = XX - PT16
						Top = lTop + TextHeight / 2
						GdipDrawLineI hGraphics, hPen, CX, CY, Left, Top
						lTop = lTop - TextHeight
					End If
					GdipDeleteBrush hBrush
					GdipDeletePen hPen
					
				ElseIf m_LabelsPositions = LP_Inside Then
					'lForeColor = IIf(IsDarkColor(m_Item(i).ItemColor), &H808080, vbWhite)
					'DrawText hGraphics, m_Item(i).Text, Left + 1, Top + 1, TextWidth, TextHeight, UserControl.Font, RGBtoARGB(lForeColor, 100), cCenter, cMiddle
					If HotItem = i Then
						lColor = ShiftColor(m_Item(i).ItemColor, vbWhite, 150)
					Else
						lColor = m_Item(i).ItemColor
					End If
					lForeColor = IIf(IsDarkColor(lColor), vbWhite, vbBlack)
					DrawText hGraphics, m_Item(i).text, Left, Top, TextWidth, TextHeight, UserControl.Font, RGBtoARGB(lForeColor, 100), cCenter, cMiddle
				Else
					DrawText hGraphics, m_Item(i).text, Left, Top, TextWidth, TextHeight, UserControl.Font, RGBtoARGB(m_ForeColor, 100), cCenter, cMiddle
				End If
			End If
			LastAngle = LastAngle + Angle '+ 2
		Next
		
		
		
		If m_LegendVisible Then
			For i = 0 To ItemsCount - 1
				lForeColor = RGBtoARGB(m_ForeColor, 100)
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
								.Top = TopHeader + mHeight / 2 - .Height / 2
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
						m_Item(i).LegendRect.Width = m_Item(i).TextWidth
						m_Item(i).LegendRect.Height = m_Item(i).TextHeight
						
						With m_Item(i).LegendRect
							GdipCreateSolidFill RGBtoARGB(m_Item(i).ItemColor, 100), hBrush
							GdipFillEllipseI hGraphics, hBrush, .Left, .Top + m_Item(i).TextHeight / 4, m_Item(i).TextHeight / 2, m_Item(i).TextHeight / 2
							GdipDeleteBrush hBrush
						End With
						DrawText hGraphics, m_Item(i).ItemName, .Left + m_Item(i).TextHeight / 1.5, .Top, m_Item(i).TextWidth, m_Item(i).TextHeight, UserControl.Font, lForeColor, cLeft, cMiddle
						TextHeight = TextHeight + m_Item(i).TextHeight
						.Top = .Top + m_Item(i).TextHeight
						
					End With
					
				Case LA_BOTTOM, LA_TOP
					With LabelsRect
						If .Left = 0 Then
							If ColRow = 1 Then
								.Left = MarginLeft + mWidth / 2 - .Width / 2
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
						
						GdipCreateSolidFill RGBtoARGB(m_Item(i).ItemColor, 100), hBrush
						GdipFillEllipseI hGraphics, hBrush, .Left, .Top + m_Item(i).TextHeight / 4, m_Item(i).TextHeight / 2, m_Item(i).TextHeight / 2
						GdipDeleteBrush hBrush
						m_Item(i).LegendRect.Left = .Left
						m_Item(i).LegendRect.Top = .Top
						m_Item(i).LegendRect.Width = m_Item(i).TextWidth
						m_Item(i).LegendRect.Height = m_Item(i).TextHeight
						
						DrawText hGraphics, m_Item(i).ItemName, .Left + m_Item(i).TextHeight / 1.5, .Top, m_Item(i).TextWidth, m_Item(i).TextHeight, UserControl.Font, lForeColor, cLeft, cMiddle
						.Left = .Left + m_Item(i).TextWidth '+ M_ITEM(i).TextHeight / 1.5
					End With
				End Select
				
				
			Next
		End If
		
		
		'Title
		If Len(m_Title) Then
			DrawText hGraphics, m_Title, 0, PT16 / 2, UserControl.ScaleWidth, TopHeader, m_TitleFont, RGBtoARGB(m_TitleForeColor, 100), cCenter, cTop, True
		End If
		
		ShowToolTips hGraphics
		
		Call GdipDeleteGraphics(hGraphics)
		
		
	End Sub
	
	
	Private Sub Chart.ShowToolTips(hGraphics As Long)
		Dim i As Long, j As Long
		Dim sDisplay As String
		Dim bBold As Boolean
		Dim RectF As RectF
		Dim LW As Single
		Dim lForeColor As Long
		Dim sText As String
		Dim TM As Single
		Dim PT As POINTF
		Dim SZ As SIZEF
		
		If HotItem > -1 Then
			
			lForeColor = RGBtoARGB(m_ForeColor, 100)
			LW = m_LinesWidth * nScale
			TM = UserControl.TextHeight("Aj") / 4
			
			sText = m_Item(HotItem).ItemName & ": " & m_Item(HotItem).text
			GetTextSize hGraphics, sText, 0, 0, UserControl.Font, False, SZ
			
			
			With RectF
				GdipGetPathLastPoint m_Item(HotItem).hPath, PT
				.Left = PT.X
				.Top = PT.Y
				.Width = SZ.Width + TM * 2
				.Height = SZ.Height + TM * 2
				
				If .Left < 0 Then .Left = LW
				If .Top < 0 Then .Top = LW
				If .Left + .Width >= UserControl.ScaleWidth - LW Then .Left = UserControl.ScaleWidth - .Width - LW
				If .Top + .Height >= UserControl.ScaleHeight - LW Then .Top = UserControl.ScaleHeight - .Height - LW
			End With
			
			RoundRect hGraphics, RectF, RGBtoARGB(m_BackColor, 90), RGBtoARGB(m_Item(HotItem).ItemColor, 80), TM
			
			
			With RectF
				.Left = .Left + TM
				.Top = .Top
				DrawText hGraphics, m_Item(HotItem).ItemName & ": ", .Left, .Top, .Width, .Height, UserControl.Font, lForeColor, cLeft, cMiddle
				GetTextSize hGraphics, m_Item(HotItem).ItemName & ": ", 0, 0, UserControl.Font, False, SZ
				bBold = UserControl.Font.Bold
				UserControl.Font.Bold = True
				DrawText hGraphics, m_Item(HotItem).text, .Left + SZ.Width, .Top, .Width, .Height, UserControl.Font, lForeColor, cLeft, cMiddle
				UserControl.Font.Bold = bBold
			End With
			
		End If
	End Sub
	
	Private Sub Chart.RoundRect(ByVal hGraphics As Long, Rect As RectF, ByVal BackColor As Long, ByVal BorderColor As Long, ByVal Round As Single, Optional bBorder As Boolean = True)
		Dim hPen As Long, hBrush As Long
		Dim mPath As Long
		
		GdipCreateSolidFill BackColor, hBrush
		If bBorder Then GdipCreatePen1 BorderColor, 1 * nScale, &H2, hPen
		
		If Round = 0 Then
			With Rect
				GdipFillRectangleI hGraphics, hBrush, .Left, .Top, .Width, .Height
				If hPen Then GdipDrawRectangleI hGraphics, hPen, .Left, .Top, .Width, .Height
			End With
		Else
			If GdipCreatePath(&H0, mPath) = 0 Then
				Round = Round * 2
				With Rect
					GdipAddPathArcI mPath, .Left, .Top, Round, Round, 180, 90
					GdipAddPathArcI mPath, .Left + .Width - Round, .Top, Round, Round, 270, 90
					GdipAddPathArcI mPath, .Left + .Width - Round, .Top + .Height - Round, Round, Round, 0, 90
					GdipAddPathArcI mPath, .Left, .Top + .Height - Round, Round, Round, 90, 90
					GdipClosePathFigure mPath
				End With
				GdipFillPath hGraphics, hBrush, mPath
				If hPen Then GdipDrawPath hGraphics, hPen, mPath
				Call GdipDeletePath(mPath)
			End If
		End If
		
		Call GdipDeleteBrush(hBrush)
		If hPen Then Call GdipDeletePen(hPen)
		
	End Sub
	
	
	Private Function Chart.ShiftColor(ByVal clrFirst As Long, ByVal clrSecond As Long, ByVal lAlpha As Long) As Long
		
		Dim clrFore(3)         As Byte
		Dim clrBack(3)         As Byte
		
		OleTranslateColor clrFirst, 0, VarPtr(clrFore(0))
		OleTranslateColor clrSecond, 0, VarPtr(clrBack(0))
		
		clrFore(0) = (clrFore(0) * lAlpha + clrBack(0) * (255 - lAlpha)) / 255
		clrFore(1) = (clrFore(1) * lAlpha + clrBack(1) * (255 - lAlpha)) / 255
		clrFore(2) = (clrFore(2) * lAlpha + clrBack(2) * (255 - lAlpha)) / 255
		
		CopyMemory ShiftColor, clrFore(0), 4
		
	End Function
	
	Private Function Chart.IsDarkColor(ByVal Color As Long) As Boolean
		Dim BGRA(0 To 3) As Byte
		OleTranslateColor Color, 0, VarPtr(Color)
		CopyMemory BGRA(0), Color, 4&
		
		IsDarkColor = ((CLng(BGRA(0)) + (CLng(BGRA(1) * 3)) + CLng(BGRA(2))) / 2) < 382
		
	End Function
	
	Private Sub Chart.Example()
		Me.AddItem "Juan", 70, vbRed
		Me.AddItem "Adan", 20, vbGreen
		Me.AddItem "Pedro", 10, vbBlue
	End Sub
	
	#ifndef __USE_GTK__
		Sub Chart.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QChart(Sender.Child)
					.HotItem = -1
					.nScale = GetWindowsDPI
					'.m_TitleFont = New My.SYs.FornFont
					If Parent <> 0 Then .c_lhWnd = Parent.Handle
					Call ManageGDIToken(c_lhWnd)
				End With
			End If
		End Sub
		
		Sub Chart.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Sub Chart.ProcessMessage(ByRef Message As Message)
		Base.ProcessMessage(Message)
	End Sub
	
	Operator Chart.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	Constructor Chart
		With This
			WLet(FClassName, "Chart")
			#ifdef __USE_GTK__
				widget = gtk_layout_new(NULL, NULL)
				.RegisterClass "Chart", @This
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
			.InitProperties()
			.tmrMOUSEOVER.OnTimer = @tmrMOUSEOVER_Timer
		End With
	End Constructor
	
	Destructor Chart
		#ifndef __USE_GTK__
			Dim i As Long
			For i = 0 To ItemsCount - 1
				GdipDeletePath m_Item(i).hPath
			Next
			UnregisterClass "Chart",GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace


