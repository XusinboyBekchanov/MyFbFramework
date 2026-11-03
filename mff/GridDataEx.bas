'################################################################################
'#  GridDataEx.bas                                                                #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'#  Converted from: VBFlexGrid.ctl of VBFLXGRD18 (VB GridDataEx Control 1.8)      #
'#                                                                              #
'#  Part 1: construction, data model and property implementations.              #
'#  https://github.com/Kr00l/VBFLXGRD                                           #  
'################################################################################

#include once "GridDataEx.bi"

'DarkMode_Explorer switches a window's own scrollbars to the dark theme
'(Win10 1809+; harmless no-op on older systems). Declared at global scope so
'the import name is not namespaced.
#ifdef __USE_WINAPI__
	Declare Function GDSetWindowTheme Lib "uxtheme" Alias "SetWindowTheme" (ByVal hWnd As HWND, ByVal pszSubAppName As WString Ptr, ByVal pszSubIdList As WString Ptr) As Long
#endif

'Report bridge state: the grid feeding the active Report and the ByRef
'return buffer for the OnGetFieldValue callback (module-level, because a
'Static member function cannot take ByRef parameters).
Dim Shared RptSourceGrid As My.Sys.Forms.GridDataEx Ptr = 0
Dim Shared RptValueBuf As WString Ptr = 0

Namespace My.Sys.Forms
	'Active print-preview grid (one preview at a time; the static preview
	'handlers resolve the grid through this pointer).
	Dim Shared PreviewGrid As GridDataEx Ptr = 0

	'=== GridDataEx common helpers (merged from GridDataCommon.bas) ===

	'VB OLE colors are direct BGR values in this control context. System color
	'constants (&H80000000 and above) translate through GetSysColor on Windows;
	'other platforms keep the raw value.
	Function FlexWinColor(ByVal CrColor As Long) As Long
		If (CrColor And &H80000000) <> 0 Then
			Return GetSysColor(CrColor And &HFF)
		End If
		Return CrColor
	End Function

	#ifdef __USE_WINAPI__
		#ifdef __USE_WINAPI__
	'The shift/mouse state readers serve the raw WinAPI message path; the GTK
	'branch receives the state through the shared control events instead.
	Function FlexGetShiftStateFromMsg() As Integer
		Dim As Integer Result
		If GetKeyState(VK_SHIFT) < 0 Then Result = Result Or FLEX_SHIFT_MASK
		If GetKeyState(VK_CONTROL) < 0 Then Result = Result Or FLEX_CTRL_MASK
		If GetKeyState(VK_MENU) < 0 Then Result = Result Or FLEX_ALT_MASK
		Return Result
	End Function

	Function FlexKeyPressed(ByVal KeyCode As Long) As Boolean
		Return (GetAsyncKeyState(KeyCode) And &H8000) = &H8000
	End Function

	Function FlexGetMouseState() As Integer
		Const SM_SWAPBUTTON_ = 23
		Dim As Integer LeftBtn = VK_LBUTTON, RightBtn = VK_RBUTTON
		If GetSystemMetrics(SM_SWAPBUTTON_) <> 0 Then
			LeftBtn = VK_RBUTTON
			RightBtn = VK_LBUTTON
		End If
		Dim As Integer Result
		If FlexKeyPressed(LeftBtn) Then Result = Result Or FLEX_LEFT_BUTTON
		If FlexKeyPressed(RightBtn) Then Result = Result Or FLEX_RIGHT_BUTTON
		If FlexKeyPressed(VK_MBUTTON) Then Result = Result Or FLEX_MIDDLE_BUTTON
		Return Result
	End Function

	Sub FlexSetWindowRedraw(ByVal hWnd As HWND, ByVal Enabled As Boolean)
		Const RDW_UPDATENOW_ = &H100, RDW_INVALIDATE_ = &H1, RDW_ERASE_ = &H4, RDW_ALLCHILDREN_ = &H80
		SendMessage(hWnd, WM_SETREDRAW, Cast(WPARAM, IIf(Enabled, 1, 0)), 0)
		If Enabled Then
			RedrawWindow(hWnd, NULL, NULL, RDW_UPDATENOW_ Or RDW_INVALIDATE_ Or RDW_ERASE_ Or RDW_ALLCHILDREN_)
		End If
	End Sub
		#endif
	#else
		'The colors of the light scheme of Windows 10 (GetSysColor) for the platforms
		'without the system colors of Windows
		Function FlexSysColor(ByVal Index As Long) As Long
			Select Case Index
			Case COLOR_SCROLLBAR: Return &HC8C8C8
			Case COLOR_WINDOW, COLOR_HIGHLIGHTTEXT, COLOR_BTNHIGHLIGHT: Return &HFFFFFF
			Case COLOR_HIGHLIGHT: Return &HD77800
			Case COLOR_BTNFACE: Return &HF0F0F0
			Case COLOR_BTNSHADOW: Return &HA0A0A0
			Case COLOR_GRAYTEXT: Return &H6D6D6D
			Case COLOR_3DDKSHADOW: Return &H696969
			Case COLOR_3DLIGHT: Return &HE3E3E3
			Case COLOR_INFOBK: Return &HE1FFFF
			Case COLOR_HOTLIGHT: Return &HCC6600
			Case Else: Return 0 'the texts and the frames
			End Select
		End Function

		'The FLEX_*_MASK bits of a state of the modifiers of GDK
		Function FlexGdkShift(ByVal State As Long) As Integer
			Dim As Integer Result
			#ifdef __USE_GTK__
				If State And GDK_SHIFT_MASK Then Result Or= FLEX_SHIFT_MASK
				If State And GDK_CONTROL_MASK Then Result Or= FLEX_CTRL_MASK
				If State And GDK_MOD1_MASK Then Result Or= FLEX_ALT_MASK
			#else
				Result = State And 7
			#endif
			Return Result
		End Function

		#ifdef __USE_GTK__
			Function FlexKeyToVK(ByVal KeyVal As Long) As Long
				Select Case KeyVal
				Case GDK_KEY_a To GDK_KEY_z: Return KeyVal - GDK_KEY_a + &H41
				Case GDK_KEY_A To GDK_KEY_Z, GDK_KEY_0 To GDK_KEY_9: Return KeyVal
				Case GDK_KEY_KP_0 To GDK_KEY_KP_9: Return KeyVal - GDK_KEY_KP_0 + VK_NUMPAD0
				Case GDK_KEY_F1 To GDK_KEY_F12: Return KeyVal - GDK_KEY_F1 + VK_F1
				Case GDK_KEY_Up, GDK_KEY_KP_Up: Return VK_UP
				Case GDK_KEY_Down, GDK_KEY_KP_Down: Return VK_DOWN
				Case GDK_KEY_Left, GDK_KEY_KP_Left: Return VK_LEFT
				Case GDK_KEY_Right, GDK_KEY_KP_Right: Return VK_RIGHT
				Case GDK_KEY_Home, GDK_KEY_KP_Home: Return VK_HOME
				Case GDK_KEY_End, GDK_KEY_KP_End: Return VK_END
				Case GDK_KEY_Page_Up, GDK_KEY_KP_Page_Up: Return VK_PRIOR
				Case GDK_KEY_Page_Down, GDK_KEY_KP_Page_Down: Return VK_NEXT
				Case GDK_KEY_Tab, GDK_KEY_ISO_Left_Tab: Return VK_TAB
				Case GDK_KEY_Return, GDK_KEY_KP_Enter: Return VK_RETURN
				Case GDK_KEY_Escape: Return VK_ESCAPE
				Case GDK_KEY_BackSpace: Return VK_BACK
				Case GDK_KEY_Delete, GDK_KEY_KP_Delete: Return VK_DELETE
				Case GDK_KEY_Insert, GDK_KEY_KP_Insert: Return VK_INSERT
				Case GDK_KEY_space: Return VK_SPACE
				Case GDK_KEY_KP_Add: Return VK_ADD
				Case GDK_KEY_KP_Subtract: Return VK_SUBTRACT
				Case GDK_KEY_KP_Multiply: Return VK_MULTIPLY
				Case GDK_KEY_KP_Divide: Return VK_DIVIDE
				Case GDK_KEY_KP_Decimal: Return VK_DECIMAL
				Case GDK_KEY_period: Return &HBE
				Case GDK_KEY_Shift_L, GDK_KEY_Shift_R: Return VK_SHIFT
				Case GDK_KEY_Control_L, GDK_KEY_Control_R: Return VK_CONTROL
				Case GDK_KEY_Alt_L, GDK_KEY_Alt_R: Return VK_MENU
				End Select
				Return 0
			End Function
		#endif
	#endif

	'Twips-per-pixel helpers. The VB6 control works internally in twips;
	'this port keeps pixel geometry for drawing and converts at the boundary.
	'DPI-aware: the inherited xdpi/ydpi are scale factors (96DPI -> 1.0,
	'120DPI -> 1.25, 144DPI -> 1.5). Twips map to physical pixels via
	'twips * factor / 15, so one pixel holds 15/factor twips.
	Function GridDataEx.TwipsPerPixelX() As Single
		Dim As Single Factor = xdpi
		If Factor <= 0 Then Factor = 1
		Return 15 / Factor
	End Function

	Function GridDataEx.TwipsPerPixelY() As Single
		Dim As Single Factor = ydpi
		If Factor <= 0 Then Factor = 1
		Return 15 / Factor
	End Function

	'=== DPI unit boundaries ===
	'The grid draws, scrolls and hit-tests in PHYSICAL pixels: twips convert
	'through the DPI factor and mouse messages arrive as raw physical lParam
	'coordinates. The MFF framework speaks LOGICAL 96-DPI pixels in its
	'ClientWidth/Height properties, its SetBounds and inside the Canvas
	'primitives (they multiply by xdpi/ydpi on the way out). Convert at those
	'boundaries and neutralize the Canvas scaling while the grid paints.

	Function GridDataEx.ClientWidthPx() As Long
		#ifndef __USE_WINAPI__
			'The physical pixels without the own scroll bar
			Return Max(0, ScaleX(ClientWidth) - IIf(FOwnVScroll, OwnScrollBarSize(), 0))
		#else
			Dim As RECT R
			If Handle <> 0 Then GetClientRect(Handle, @R)
			Return R.Right
		#endif
	End Function

	Function GridDataEx.ClientHeightPx() As Long
		#ifndef __USE_WINAPI__
			Return Max(0, ScaleY(ClientHeight) - IIf(FOwnHScroll, OwnScrollBarSize(), 0))
		#else
			Dim As RECT R
			If Handle <> 0 Then GetClientRect(Handle, @R)
			Return R.Bottom
		#endif
	End Function

	'Design-logical pixels (96 DPI constants) into grid physical pixels.
	Function GridDataEx.LogicalToPxX(ByVal Value As Long) As Long
		Dim As Single Factor = xdpi
		If Factor <= 0 Then Factor = 1
		Return CInt(Value * Factor)
	End Function

	Function GridDataEx.LogicalToPxY(ByVal Value As Long) As Long
		Dim As Single Factor = ydpi
		If Factor <= 0 Then Factor = 1
		Return CInt(Value * Factor)
	End Function

	'Canvas draws 1:1: the grid passes physical pixels, so the framework's
	'internal ScaleX/ScaleY must not scale them a second time.
	Sub GridDataEx.UsePhysicalCanvas()
		Canvas.xdpi = 1
		Canvas.ydpi = 1
	End Sub

	'=== FlexCellFormat ===

	Sub FlexCellFormat.Clear
		TextStyle = -1
		Alignment = -1
		PictureAlignment = -1
		BackColor = -1
		ForeColor = -1
		ComboCue = -1
		Checked = -1
		FloodPercent = 0
		FloodColor = -1
		WDeAllocate(ToolTipText)
		ToolTipText = 0
		WDeAllocate(FontName)
		FontName = 0
		FontSize = 0
		FontStyle = 0
		FontCharset = -1
	End Sub

	Destructor FlexCellFormat
		WDeAllocate(ToolTipText)
		ToolTipText = 0
		WDeAllocate(FontName)
		FontName = 0
	End Destructor

	'=== FlexCell ===

	Property FlexCell.Text ByRef As WString
		If FText <> 0 Then Return *FText
		Return ""
	End Property

	Property FlexCell.Text(ByRef Value As WString)
		WLet(FText, Value)
	End Property

	Sub FlexCell.ClearText
		WDeAllocate(FText)
		FText = 0
	End Sub

	Destructor FlexCell
		WDeAllocate(FText)
		FText = 0
		If Fmtg <> 0 Then Delete Fmtg
		Fmtg = 0
	End Destructor

	'=== FlexUndoEntry ===

	Destructor FlexUndoEntry
		WDeAllocate(OldText)
		OldText = 0
		WDeAllocate(NewText)
		NewText = 0
	End Destructor

	'=== Construction / destruction ===

	Constructor GridDataEx
		With This
			Canvas.Ctrl = @This
			.Child = @This
			#ifdef __USE_WINAPI__
				.RegisterClass "GridDataEx"
				.ExStyle = 0
				.Style = WS_CHILD Or WS_VISIBLE Or WS_TABSTOP Or WS_CLIPSIBLINGS Or WS_VSCROLL Or WS_HSCROLL
				.BackColor = GetSysColor(COLOR_WINDOW)
				.DoubleBuffered = True
			#elseif defined(__USE_GTK__)
				'A layout like Chart: it gets the mouse, the keys and the draw signal
				widget = gtk_layout_new(NULL, NULL)
				.RegisterClass "GridDataEx", @This
				'The layout holds the editors (TextBox, ComboBoxEdit) like the one of a Panel
				layoutwidget = widget
				#ifdef __USE_GTK4__
					gtk_widget_set_focusable(widget, True)
				#else
					gtk_widget_set_can_focus(widget, True)
				#endif
				.OnPaint = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Cv As My.Sys.Drawing.Canvas), @GTK_Paint)
			#else
				'The Web and Android: the grid paints on CM_PAINT and gets the CM_MOUSE* and
				'CM_KEY* messages without the OnMouse* and OnKey* events of the user
				FMouseEvents = True
				FKeyEvents = True
			#endif
			WLet(FClassName, "GridDataEx")
			.Width = 121 * TwipsPerPixelX()
			.Height = 121 * TwipsPerPixelY()
		End With

		'Light/dark default scheme follows App.DarkMode (g_darkModeEnabled).
		#ifndef __USE_WINAPI__
			SetDefaultColors(False)
		#else
			SetDefaultColors(g_darkModeEnabled)
		#endif
		FGridLinesFixed = GridDataLineInset
		FGridLinesFrozen = -1
		WLet(FClipSeparatorsCol, Chr(9))
		WLet(FClipSeparatorsRow, Chr(13))

		ReDim CellsArr(0 To (FRows * FCols) - 1)
		ReDim RowsArr(0 To FRows - 1)
		ReDim MergeCache(0 To (FRows * FCols) * 4 - 1)
		ReDim FMergeRows(0 To FRows - 1)
		ReDim FMergeCols(0 To FCols - 1)
		ReDim ColsArr(0 To FCols - 1)
		Dim i As Long, j As Long
		For i = 0 To FRows - 1
			RowsArr(i).Height = -1
			RowsArr(i).State = 0
			RowsArr(i).ID = -1
		Next i
		For j = 0 To FCols - 1
			ColsArr(j).Width = -1
			ColsArr(j).Alignment = FlexAlignmentGeneral
			ColsArr(j).FixedAlignment = -1
		Next j
		'Cells stay lazy: 0 = empty cell, allocated on first write.
		FCapRows = FRows

		FRow = FFixedRows
		If FRow > FRows - 1 Then FRow = FRows - 1
		FCol = FFixedCols
		If FCol > FCols - 1 Then FCol = FCols - 1
		FRowSel = FRow
		FColSel = FCol
		'The first scrollable row/column starts right after the fixed region.
		FTopRow = FFixedRows
		FLeftCol = FFixedCols

		FDefaultBackColor = GetSysColor(COLOR_WINDOW)
		FVisible = True
		FEnabled_ = True
		FTabStop = True
		FTabIndex = -1
	End Constructor

	Destructor GridDataEx
		CancelEdit
		#ifdef __USE_WINAPI__
			DestroyMemSurface
		#endif
		If FTextTmp <> 0 Then _Deallocate(FTextTmp)
		Dim i As Long
		For i = LBound(CellsArr) To UBound(CellsArr)
			If CellsArr(i) <> 0 Then Delete CellsArr(i)
			CellsArr(i) = 0
		Next i
		Erase CellsArr
		For i = 0 To FCols - 1
			WDeAllocate(ColsArr(i).Key)
			ColsArr(i).Key = 0
			WDeAllocate(ColsArr(i).ComboItems)
			ColsArr(i).ComboItems = 0
			WDeAllocate(ColsArr(i).ComboHeader)
			ColsArr(i).ComboHeader = 0
			WDeAllocate(ColsArr(i).FormatStr)
			ColsArr(i).FormatStr = 0
			WDeAllocate(ColsArr(i).FixedFormatStr)
			ColsArr(i).FixedFormatStr = 0
			WDeAllocate(ColsArr(i).Filter)
			ColsArr(i).Filter = 0
			WDeAllocate(ColsArr(i).Lookup)
			ColsArr(i).Lookup = 0
		Next i
		#ifdef __USE_WINAPI__
			If FScrollTipHwnd <> 0 Then DestroyWindow(Cast(HWND, FScrollTipHwnd))
			FScrollTipHwnd = 0
		#endif
		WDeAllocate(FScrollTipText)
		FScrollTipText = 0
		WDeAllocate(FFormatString)
		FFormatString = 0
		ClearUndoQueue
		WDeAllocate(FComboList)
		FComboList = 0
		CloseDropDown(False)
		If ComboEdit_ <> 0 Then Delete ComboEdit_
		ComboEdit_ = 0
		If ComboCalendar_ <> 0 Then Delete ComboCalendar_
		ComboCalendar_ = 0
		If CalcPanel_ <> 0 Then
			For i = 0 To 19
				If CalcBtn_(i) <> 0 Then Delete CalcBtn_(i)
				CalcBtn_(i) = 0
			Next i
			If CalcDisplay_ <> 0 Then Delete CalcDisplay_
			CalcDisplay_ = 0
			Delete CalcPanel_
			CalcPanel_ = 0
		End If
		WDeAllocate(FCalcEntry)
		FCalcEntry = 0
		WDeAllocate(FClipSeparatorsCol)
		FClipSeparatorsCol = 0
		WDeAllocate(FClipSeparatorsRow)
		FClipSeparatorsRow = 0
		WDeAllocate(FIncrSearchString)
		FIncrSearchString = 0
		If EditText_ <> 0 Then Delete EditText_
		EditText_ = 0
	End Destructor

	Operator GridDataEx.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator

	'=== Internal cell access ===

	Function GridDataEx.CellAt(ByVal aRow As Long, ByVal aCol As Long) As FlexCell Ptr
		If aRow < 0 OrElse aCol < 0 OrElse aRow > FRows - 1 OrElse aCol > FCols - 1 Then Return 0
		Return CellsArr(aRow * FCols + aCol)
	End Function

	'Read/write cell access that allocates the cell on first use (lazy cells:
	'empty cells cost no memory, so million-row grids stay lightweight).
	Function GridDataEx.CellCreate(ByVal aRow As Long, ByVal aCol As Long) As FlexCell Ptr
		If aRow < 0 OrElse aCol < 0 OrElse aRow > FRows - 1 OrElse aCol > FCols - 1 Then Return 0
		Dim As Long Idx = aRow * FCols + aCol
		If CellsArr(Idx) = 0 Then CellsArr(Idx) = New FlexCell
		Return CellsArr(Idx)
	End Function

	Sub GridDataEx.SetCell(ByVal aRow As Long, ByVal aCol As Long, ByRef Value As WString)
		Dim As FlexCell Ptr C = CellCreate(aRow, aCol)
		If C = 0 Then Exit Sub
		C->Text = Value
		InvalidateMergeCache
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Sub

	'=== TextMatrix (equivalent of VB6 TextMatrix property) ===

	Function GridDataEx.TextMatrix(ByVal aRow As Long, ByVal aCol As Long) ByRef As WString
		Dim As FlexCell Ptr C = CellAt(aRow, aCol)
		If C <> 0 Then Return C->Text
		Return ""
	End Function

	Sub GridDataEx.TextMatrix(ByVal aRow As Long, ByVal aCol As Long, ByRef Value As WString)
		Dim As FlexCell Ptr C = CellCreate(aRow, aCol)
		If C = 0 Then Exit Sub
		C->Text = Value
		InvalidateMergeCache
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Sub

	'=== Text (current cell) ===

	Property GridDataEx.Text ByRef As WString
		Return TextMatrix(FRow, FCol)
	End Property

	Property GridDataEx.Text(ByRef Value As WString)
		Dim As FlexCell Ptr C = CellCreate(FRow, FCol)
		If C = 0 Then Exit Property
		C->Text = Value
		InvalidateMergeCache
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	'=== Rows / Cols ===

	Property GridDataEx.Rows As Long
		Return FRows
	End Property

	'Grows the physical storage (CellsArr / RowsArr / FMergeRows) so that
	'NeededRows logical rows fit. Capacity doubles, so a million-row load
	'triggers only ~20 reallocations instead of one per row.
	Sub GridDataEx.EnsureRowCapacity(ByVal NeededRows As Long)
		If NeededRows <= FCapRows Then Exit Sub
		Dim As Long NewCap = IIf(FCapRows > 0, FCapRows, 64)
		While NewCap < NeededRows
			NewCap *= 2
		Wend
		Dim As Long OldPhys = FCapRows
		If OldPhys < 1 Then OldPhys = 0
		'Cell pointer array: stride is FCols (row-major flat layout).
		Dim As Long OldCount = FRows * FCols
		Dim As Long NewCount = NewCap * FCols
		ReDim Preserve CellsArr(0 To NewCount - 1)
		Dim As Long i
		For i = OldCount To NewCount - 1
			CellsArr(i) = 0
		Next i
		'Row info array; defaults for every slot beyond the logical rows.
		ReDim Preserve RowsArr(0 To NewCap - 1)
		Dim As Long InitFrom = FRows
		If InitFrom < OldPhys Then InitFrom = OldPhys
		For i = InitFrom To NewCap - 1
			RowsArr(i).Height = -1
			RowsArr(i).State = 0
			RowsArr(i).ID = -1
			RowsArr(i).Data = 0
		Next i
		'Merge participation flags: force new slots to False.
		ReDim Preserve FMergeRows(0 To NewCap - 1)
		For i = InitFrom To NewCap - 1
			FMergeRows(i) = False
		Next i
		FCapRows = NewCap
		'Prefix caches sized to capacity are still valid for indices < FRows;
		'new rows extend the totals, so mark dirty anyway.
		InvalidateRowGeometry
	End Sub

	Property GridDataEx.Rows(ByVal Value As Long)
		If Value < 1 OrElse Value = FRows Then Exit Property
		Dim As Long i
		If Value > FRows Then
			'Grow: capacity-managed, cells stay lazy (0 = empty cell).
			EnsureRowCapacity(Value)
			'New logical rows start empty.
			For i = FRows To Value - 1
				RowsArr(i).Height = -1
				RowsArr(i).State = 0
				RowsArr(i).ID = -1
				RowsArr(i).Data = 0
				FMergeRows(i) = False
			Next i
			FRows = Value
		Else
			'Shrink: release the dropped cells and reinit their row info so a
			'later regrow cannot surface stale heights/states.
			Dim As Long OldCount = FRows * FCols
			Dim As Long NewCount = Value * FCols
			For i = NewCount To OldCount - 1
				If CellsArr(i) <> 0 Then
					Delete CellsArr(i)
					CellsArr(i) = 0
				End If
			Next i
			For i = Value To FRows - 1
				RowsArr(i).Height = -1
				RowsArr(i).State = 0
				RowsArr(i).ID = -1
				RowsArr(i).Data = 0
			Next i
			FRows = Value
			InvalidateMergeCache
		End If
		InvalidateRowGeometry
		'Clamp current position.
		If FRow > FRows - 1 Then FRow = FRows - 1
		If FRowSel > FRows - 1 Then FRowSel = FRows - 1
		FScrollBarsDirty = True
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.Cols As Long
		Return FCols
	End Property

	Property GridDataEx.Cols(ByVal Value As Long)
		If Value < 1 OrElse Value = FCols Then Exit Property
		Dim As Long i, j
		Dim OldCells(Any) As FlexCell Ptr
		Dim As Long OldCols = FCols
		Dim As Long OldCount = FRows * OldCols
		ReDim OldCells(0 To OldCount - 1)
		For i = 0 To OldCount - 1
			OldCells(i) = CellsArr(i)
		Next i
		'New flat array sized to the row capacity; cells stay lazy (0 = empty).
		ReDim CellsArr(0 To Max(FRows, FCapRows) * Value - 1)
		Dim As Long CopyCols = IIf(Value < OldCols, Value, OldCols)
		For i = 0 To FRows - 1
			For j = 0 To CopyCols - 1
				Swap CellsArr(i * Value + j), OldCells(i * OldCols + j)
			Next j
		Next i
		For i = 0 To OldCount - 1
			Delete OldCells(i)
		Next i
		Erase OldCells
		'Resize col info array.
		Dim OldCInfo(Any) As FlexColInfo
		ReDim OldCInfo(0 To OldCols - 1)
		For i = 0 To OldCols - 1
			OldCInfo(i) = ColsArr(i)
		Next i
		ReDim ColsArr(0 To Value - 1)
		If LBound(FMergeCols) <= UBound(FMergeCols) Then
			ReDim Preserve FMergeCols(0 To Value - 1)
		End If
		For i = 0 To Value - 1
			ColsArr(i).Width = -1
			ColsArr(i).Alignment = FlexAlignmentGeneral
			ColsArr(i).FixedAlignment = -1
			ColsArr(i).Key = 0
			If i < OldCols Then
				ColsArr(i) = OldCInfo(i)
			End If
		Next i
		FCols = Value
		InvalidateMergeCache
		InvalidateColGeometry
		InvalidateRowGeometry
		If FCol > FCols - 1 Then FCol = FCols - 1
		If FColSel > FCols - 1 Then FColSel = FCols - 1
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	'=== aRow / aCol ===

	Property GridDataEx.Row As Long
		Return FRow
	End Property

	Property GridDataEx.Row(ByVal Value As Long)
		Value = Max(0, Min(Value, FRows - 1))
		If Value = FRow AndAlso Value = FRowSel Then Exit Property
		Dim As Boolean CancelFlag = False
		If OnBeforeRowColChange Then OnBeforeRowColChange(*Designer, This, Value, FCol, CancelFlag)
		If CancelFlag Then Exit Property
		Dim As Long OldRow = FRow
		Dim As Long OldCol = FCol
		If Value <> FRow Then
			If OnLeaveCell Then OnLeaveCell(*Designer, This)
			FRow = Value
		End If
		If FAllowSelection Then
			Select Case FSelectionMode
				Case FlexSelectionModeFree, FlexSelectionModeFreeByRow, FlexSelectionModeFreeByColumn
					FRowSel = Value
					FColSel = FCol
				Case FlexSelectionModeByRow
					FRowSel = Value
					FColSel = 0
				Case FlexSelectionModeByColumn
					FRowSel = 0
					FColSel = FCol
			End Select
		End If
		EnsureVisibleCell FRow, FCol
		If OnEnterCell Then OnEnterCell(*Designer, This)
		If OnRowColChange Then OnRowColChange(*Designer, This)
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.Col As Long
		Return FCol
	End Property

	Property GridDataEx.Col(ByVal Value As Long)
		Value = Max(0, Min(Value, FCols - 1))
		If Value = FCol AndAlso Value = FColSel Then Exit Property
		Dim As Boolean CancelFlag = False
		If OnBeforeRowColChange Then OnBeforeRowColChange(*Designer, This, FRow, Value, CancelFlag)
		If CancelFlag Then Exit Property
		If Value <> FCol Then
			If OnLeaveCell Then OnLeaveCell(*Designer, This)
			FCol = Value
		End If
		If FAllowSelection Then
			Select Case FSelectionMode
				Case FlexSelectionModeFree, FlexSelectionModeFreeByRow, FlexSelectionModeFreeByColumn
					FRowSel = FRow
					FColSel = Value
				Case FlexSelectionModeByRow
					FRowSel = FRow
					FColSel = 0
				Case FlexSelectionModeByColumn
					FRowSel = 0
					FColSel = Value
			End Select
		End If
		EnsureVisibleCell FRow, FCol
		If OnEnterCell Then OnEnterCell(*Designer, This)
		If OnRowColChange Then OnRowColChange(*Designer, This)
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	'=== RowSel / ColSel ===

	Property GridDataEx.RowSel As Long
		Return FRowSel
	End Property

	Property GridDataEx.RowSel(ByVal Value As Long)
		Value = Max(0, Min(Value, FRows - 1))
		If Value = FRowSel Then Exit Property
		FRowSel = Value
		If OnSelChange Then OnSelChange(*Designer, This)
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.ColSel As Long
		Return FColSel
	End Property

	Property GridDataEx.ColSel(ByVal Value As Long)
		Value = Max(0, Min(Value, FCols - 1))
		If Value = FColSel Then Exit Property
		FColSel = Value
		If OnSelChange Then OnSelChange(*Designer, This)
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	'=== TopRow / LeftCol ===

	Property GridDataEx.TopRow As Long
		Return FTopRow
	End Property

	Property GridDataEx.TopRow(ByVal Value As Long)
		Value = Max(FFixedRows + FFrozenRows, Min(Value, FRows - 1))
		If Value = FTopRow Then Exit Property
		'Partial scroll when the content covers the viewport (fast), full
		'repaint otherwise; both paths are flicker-free via the offscreen paint.
		Dim As Long dY = RowTopY(FTopRow) - RowTopY(Value)
		FTopRow = Value
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then
			#ifdef __USE_WINAPI__
				ScrollGridPixels(0, dY)
			#else
				RepaintGrid
			#endif
		End If
		If OnScroll Then OnScroll(*Designer, This)
	End Property

	Property GridDataEx.LeftCol As Long
		Return FLeftCol
	End Property

	Property GridDataEx.LeftCol(ByVal Value As Long)
		Value = Max(FFixedCols + FFrozenCols, Min(Value, FCols - 1))
		If Value = FLeftCol Then Exit Property
		Dim As Long dX = ColLeftX(FLeftCol) - ColLeftX(Value)
		FLeftCol = Value
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then
			#ifdef __USE_WINAPI__
				ScrollGridPixels(dX, 0)
			#else
				RepaintGrid
			#endif
		End If
		If OnScroll Then OnScroll(*Designer, This)
	End Property

	'=== FixedRows / FixedCols ===

	Property GridDataEx.FixedRows As Long
		Return FFixedRows
	End Property

	Property GridDataEx.FixedRows(ByVal Value As Long)
		Value = Max(0, Min(Value, FRows))
		FFixedRows = Value
		FTopRow = Max(FTopRow, FFixedRows + FFrozenRows)
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.FixedCols As Long
		Return FFixedCols
	End Property

	Property GridDataEx.FixedCols(ByVal Value As Long)
		Value = Max(0, Min(Value, FCols))
		FFixedCols = Value
		FLeftCol = Max(FLeftCol, FFixedCols + FFrozenCols)
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	'=== GridLines ===

	Property GridDataEx.GridLines As Integer
		Return FGridLines
	End Property

	Property GridDataEx.GridLines(ByVal Value As Integer)
		FGridLines = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	'=== BackColorBkg ===

	Property GridDataEx.BackColorBkg As Long
		Return FBackColorBkg
	End Property

	Property GridDataEx.BackColorBkg(ByVal Value As Long)
		FColorsCustomized = True
		FBackColorBkg = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	'=== Cell formatting ===

	Function GridDataEx.CellHasFormat(ByVal aRow As Long, ByVal aCol As Long) As Boolean
		Dim As FlexCell Ptr C = CellAt(aRow, aCol)
		If C = 0 Then Return False
		Return C->FHasFmtg
	End Function

	Function GridDataEx.EnsureFmtg(ByVal aRow As Long, ByVal aCol As Long) As FlexCellFormat Ptr
		Dim As FlexCell Ptr C = CellCreate(aRow, aCol)
		If C = 0 Then Return 0
		If C->Fmtg = 0 Then C->Fmtg = New FlexCellFormat
		C->FHasFmtg = True
		Return C->Fmtg
	End Function

	Function GridDataEx.CellBackColorAt(ByVal aRow As Long, ByVal aCol As Long) As Long
		Dim As FlexCell Ptr C = CellAt(aRow, aCol)
		If C = 0 OrElse C->Fmtg = 0 Then Return -1
		Return C->Fmtg->BackColor
	End Function

	Sub GridDataEx.CellBackColorAt(ByVal aRow As Long, ByVal aCol As Long, ByVal Value As Long)
		Dim As FlexCellFormat Ptr F = EnsureFmtg(aRow, aCol)
		If F = 0 Then Exit Sub
		F->BackColor = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Sub

	Function GridDataEx.CellForeColorAt(ByVal aRow As Long, ByVal aCol As Long) As Long
		Dim As FlexCell Ptr C = CellAt(aRow, aCol)
		If C = 0 OrElse C->Fmtg = 0 Then Return -1
		Return C->Fmtg->ForeColor
	End Function

	Sub GridDataEx.CellForeColorAt(ByVal aRow As Long, ByVal aCol As Long, ByVal Value As Long)
		Dim As FlexCellFormat Ptr F = EnsureFmtg(aRow, aCol)
		If F = 0 Then Exit Sub
		F->ForeColor = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Sub

	'=== AddItem / RemoveItem / Clear ===

	Function GridDataEx.AddItem(ByRef Item As Const WString, ByVal Index As Long = -1) As Boolean
		'Item is a tab-delimited string like VB6 AddItem. Bulk loads stay fast:
		'no per-row scroll bar update, no forced synchronous repaint, and the
		'storage grows with doubling capacity.
		Dim As Long TargetIndex = Index
		If TargetIndex < 0 OrElse TargetIndex > FRows Then TargetIndex = FRows
		Dim As Long OldRows = FRows
		'Grow storage by one logical row (amortized O(1)).
		EnsureRowCapacity(FRows + 1)
		RowsArr(FRows).Height = -1
		RowsArr(FRows).State = 0
		RowsArr(FRows).ID = -1
		RowsArr(FRows).Data = 0
		FMergeRows(FRows) = False
		FRows += 1
		'Move rows down if inserting into the middle.
		If TargetIndex < OldRows Then
			Dim i As Long, j As Long
			For j = 0 To FCols - 1
				For i = OldRows To TargetIndex + 1 Step -1
					Swap CellsArr(i * FCols + j), CellsArr((i - 1) * FCols + j)
				Next i
			Next j
		End If
		'Split by tab (without copying the remaining string per field).
		'VB6 semantics: the first field lands in column 0, fixed or not.
		Dim As Long PosStart = 1, TabPos, FieldIdx = 0
		Dim As FlexCell Ptr C
		Dim As UString FieldValue
		Do
			TabPos = InStr(PosStart, Item, Chr(9))
			If TabPos > 0 Then
				FieldValue = Mid(Item, PosStart, TabPos - PosStart)
			Else
				FieldValue = Mid(Item, PosStart)
			End If
			If FieldIdx <= FCols - 1 Then
				C = CellCreate(TargetIndex, FieldIdx)
				If C <> 0 Then C->Text = FieldValue
			End If
			FieldIdx += 1
			If TabPos = 0 Then Exit Do
			PosStart = TabPos + 1
		Loop While PosStart <= Len(Item) + 1
		InvalidateMergeCache
		InvalidateRowGeometry
		FScrollBarsDirty = True
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
		Return True
	End Function

	Sub GridDataEx.RemoveItem(ByVal aIndex As Long)
		If aIndex < FFixedRows OrElse aIndex > FRows - 1 Then Exit Sub
		Dim i As Long, j As Long
		For j = 0 To FCols - 1
			For i = aIndex To FRows - 2
				Swap CellsArr(i * FCols + j), CellsArr((i + 1) * FCols + j)
			Next i
			Dim As FlexCell Ptr Last = CellsArr((FRows - 1) * FCols + j)
			If Last <> 0 Then Last->ClearText
		Next j
		For i = aIndex To FRows - 2
			RowsArr(i) = RowsArr(i + 1)
		Next i
		RowsArr(FRows - 1).Height = -1
		RowsArr(FRows - 1).State = 0
		RowsArr(FRows - 1).ID = -1
		RowsArr(FRows - 1).Data = 0
		InvalidateMergeCache
		InvalidateRowGeometry
		Rows = FRows - 1
	End Sub

	Sub GridDataEx.Clear(ByVal Where As Integer = FlexClearEverywhere, ByVal What As Integer = FlexClearEverything)
		Dim i As Long, j As Long
		Dim As Long StartRow = 0, EndRow = FRows - 1
		Dim As Long StartCol = 0, EndCol = FCols - 1
		Select Case Where
			Case FlexClearFixed
				StartRow = 0 : EndRow = FFixedRows - 1
				StartCol = 0 : EndCol = FCols - 1
			Case FlexClearScrollable
				StartRow = FFixedRows : EndRow = FRows - 1
				StartCol = FFixedCols : EndCol = FCols - 1
			Case Else
				StartRow = 0 : EndRow = FRows - 1
				StartCol = 0 : EndCol = FCols - 1
		End Select
		Select Case What
			Case FlexClearText
				For i = StartRow To EndRow
					For j = StartCol To EndCol
						Dim As FlexCell Ptr C = CellAt(i, j)
						If C <> 0 Then C->ClearText
					Next j
				Next i
			Case FlexClearFormatting
				For i = StartRow To EndRow
					For j = StartCol To EndCol
						Dim As FlexCell Ptr C = CellAt(i, j)
						If C <> 0 Then
							If C->Fmtg <> 0 Then Delete C->Fmtg
							C->Fmtg = 0
							C->FHasFmtg = False
						End If
					Next j
				Next i
				Case Else 'FlexClearEverything
					For i = StartRow To EndRow
						For j = StartCol To EndCol
							Dim As FlexCell Ptr C = CellAt(i, j)
							If C <> 0 Then
								C->ClearText
								If C->Fmtg <> 0 Then Delete C->Fmtg
								C->Fmtg = 0
								C->FHasFmtg = False
							End If
						Next j
					Next i
		End Select
		InvalidateMergeCache
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Sub

	'=== Edit support (TextBox child like MFF Grid.GridEditText) ===

	Function GridDataEx.StartEdit(ByVal aRow As Long = -1, ByVal aCol As Long = -1) As Boolean
		If FInEdit Then
			'Same cell: keep the running session; another cell: finish it first.
			If (aRow = FEditRow) AndAlso (aCol = FEditCol) Then Return True
			CommitEditInternal(FlexEditCloseModeCode)
		End If
		If aRow < 0 Then aRow = FRow
		If aCol < 0 Then aCol = FCol
		If aRow < 0 OrElse aCol < 0 OrElse aRow > FRows - 1 OrElse aCol > FCols - 1 Then Return False
		If FEditLocked Then Return False
		Dim As Boolean CancelFlag = False
		If OnBeforeEdit Then OnBeforeEdit(*Designer, This, aRow, aCol, FEditReason, CancelFlag)
		If CancelFlag Then Return False
		'Place the current cell onto the edit target first.
		If aRow <> FRow OrElse aCol <> FCol Then
			Row = aRow
			Col = aCol
		End If
		If EditText_ = 0 Then
			EditText_ = New FlexEditTextBox
			With *EditText_
				.Grid = @This
				.Parent = @This
				.BorderStyle = BorderStyles.bsNone
				.Visible = False
				.OnChange = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TextBox), @FlexEditTextBox.Edit_Change)
				.OnLostFocus = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TextBox), @FlexEditTextBox.Edit_LostFocus)
				#ifndef __USE_WINAPI__
					.OnKeyDown = @FlexEditTextBox.Edit_KeyDown
				#endif
			End With
			#ifdef __USE_WINAPI__
				If EditText_->Handle <> 0 Then
					SendMessage(EditText_->Handle, EM_SETLIMITTEXT, IIf(FEditMaxLength > 0, FEditMaxLength, 32767), 0)
				End If
			#endif
		End If
		FEditRow = FRow
		FEditCol = FCol
		FInEdit = True
		FEditChanged = False
		EditText_->Text = TextMatrix(FEditRow, FEditCol)
		'EditSetupStyle: app can add ES_NUMBER/ES_READONLY per column.
		Dim As Long dwSt = 0, dwEx = 0
		#ifdef __USE_WINAPI__
			If EditText_->Handle <> 0 Then dwSt = GetWindowLong(EditText_->Handle, GWL_STYLE)
		#endif
		If OnEditSetupStyle Then OnEditSetupStyle(*Designer, This, dwSt, dwEx)
		#ifdef __USE_WINAPI__
			If EditText_->Handle <> 0 Then
				Dim As Long CurSt = GetWindowLong(EditText_->Handle, GWL_STYLE)
				If (dwSt And &H2000) <> 0 Then CurSt Or= &H2000 Else CurSt And= Not &H2000 'ES_NUMBER
				If (dwSt And &H800) <> 0 Then CurSt Or= &H800 Else CurSt And= Not &H800 'ES_READONLY
				SetWindowLong(EditText_->Handle, GWL_STYLE, CurSt)
				SendMessage(EditText_->Handle, &HCF, IIf((dwSt And &H800) <> 0, 1, 0), 0) 'EM_SETREADONLY
			End If
		#endif
		'EditSetupWindow: app can restyle the editor colors before showing.
		'Default editor colors follow the grid (light or dark scheme); the
		'EditSetupWindow event below can still override them.
		EditText_->BackColor = BackColor
		EditText_->ForeColor = ForeColor
		Dim As Long BkClr = -1, FkClr = -1
		If OnEditSetupWindow Then OnEditSetupWindow(*Designer, This, BkClr, FkClr)
		If BkClr >= 0 Then EditText_->BackColor = BkClr
		Dim As Integer ColMode = FlexComboModeNone
		If FEditCol <= FCols - 1 Then ColMode = ColsArr(FEditCol).ComboMode
		Select Case ColMode
			Case FlexComboModeDropDown, FlexComboModeEditable
				'The in-place editor is a ComboBoxEdit over the cell.
				EnsureComboEdit(IIf(ColMode = FlexComboModeDropDown, cbDropDownList, cbDropDown))
				FillComboItems
				Dim As Long EL, ET, EW, EH
				CellEditorRect(EL, ET, EW, EH)
				'MFF SetBounds speaks logical pixels: the editor rect is physical.
				ComboEdit_->SetBounds UnScaleX(EL), UnScaleY(ET), UnScaleX(Max(EW, LogicalToPxX(60))), UnScaleY(Max(EH, LogicalToPxY(20)))
				ComboEdit_->ItemIndex = ComboEdit_->IndexOf(TextMatrix(FEditRow, FEditCol))
				ComboEdit_->Text = TextMatrix(FEditRow, FEditCol)
				ComboEdit_->Visible = True
				ComboEdit_->SetFocus
				'Auto-open the list for cue clicks and plain drop-down columns.
				If (FEditReason = FlexEditReasonComboCueClick) OrElse (ColMode = FlexComboModeDropDown) Then
					ComboEdit_->ShowDropDown(True)
					FComboDropped = True
				End If
			Case FlexComboModeCalendar
				'The hidden text box holds the value; the calendar popup sets it.
				EnsureComboCalendar
				Dim As Long CL, CT, CW, CH
				CellEditorRect(CL, CT, CW, CH)
				Dim As Long CalW = LogicalToPxX(216)
				Dim As Long CalH = LogicalToPxY(232)
				Dim As Long CalY = CT + CH
				If CalY + CalH > ClientHeightPx() Then CalY = Max(0, CT - CalH)
				ComboCalendar_->SetBounds UnScaleX(Max(0, min(CL, ClientWidthPx() - CalW))), UnScaleY(CalY), UnScaleX(CalW), UnScaleY(CalH)
				'Seed from the current YYYY-MM-DD text when possible.
				Dim As UString CurText = TextMatrix(FEditRow, FEditCol)
				If Len(CurText) >= 10 Then
					ComboCalendar_->SelectedDate = DateSerial(Val(Mid(CurText, 1, 4)), Val(Mid(CurText, 6, 2)), Val(Mid(CurText, 9, 2)))
				Else
					ComboCalendar_->SelectedDate = DateSerial(Year(Now), Month(Now), Day(Now))
				End If
				ComboCalendar_->Visible = True
				ComboCalendar_->SetFocus
				FComboDropped = True
			Case FlexComboModeCalculator
				EnsureCalcPanel
				Dim As Long PL, PT, PW, PH
				CellEditorRect(PL, PT, PW, PH)
				PW = LogicalToPxX(178) : PH = LogicalToPxY(226)
				Dim As Long PY = PT + PH
				If PY + PH > ClientHeightPx() Then PY = Max(0, PT - PH)
				CalcPanel_->SetBounds UnScaleX(Max(0, min(PL, ClientWidthPx() - PW))), UnScaleY(PY), UnScaleX(PW), UnScaleY(PH)
				WLet(FCalcEntry, TextMatrix(FEditRow, FEditCol))
				If Len(*FCalcEntry) = 0 Then WLet(FCalcEntry, "0")
				FCalcAccum = 0
				FCalcOp = 0
				FCalcFresh = True
				CalcUpdateDisplay
				CalcPanel_->Visible = True
				EditText_->SetFocus
				FComboDropped = True
			Case FlexComboModeButton
				'Button cell: the empty editor keeps the session alive while the
				'app opens its custom editor from OnComboButtonClick.
				EditText_->SetFocus
				EditText_->Visible = True
				PositionEditBox
			Case Else
				EditText_->SetFocus
				EditText_->SetSel(Len(EditText_->Text), Len(EditText_->Text))
				EditText_->Visible = True
				PositionEditBox
		End Select
		If OnEnterEdit Then OnEnterEdit(*Designer, This)
		If ColMode = FlexComboModeButton Then
			If OnComboButtonClick Then OnComboButtonClick(*Designer, This)
		End If
		Return True
	End Function

	Function GridDataEx.CancelEdit() As Boolean
		If FInEdit = False Then Return False
		CloseDropDown(False)
		Dim As Boolean CancelFlag = False
		If OnEditQueryClose Then OnEditQueryClose(*Designer, This, FlexEditCloseModeEscape, CancelFlag)
		If CancelFlag Then Return False
		If EditText_ <> 0 Then EditText_->Visible = False
		FInEdit = False
		FEditCloseMode = FlexEditCloseModeEscape
		FEditRow = -1
		FEditCol = -1
		If OnLeaveEdit Then OnLeaveEdit(*Designer, This)
		SetFocus
		Return True
	End Function

	Function GridDataEx.CommitEdit() As Boolean
		Return CommitEditInternal(FlexEditCloseModeCode)
	End Function

	Function GridDataEx.CommitEditInternal(ByVal CloseMode As Integer) As Boolean
		If FInEdit = False Then Return False
		'Take the current text from a visible combo editor first.
		If ComboEdit_ <> 0 AndAlso ComboEdit_->Visible Then EditText_->Text = ComboEdit_->Text
		If FComboDropped Then CloseDropDown(False)
		Dim As Boolean CancelFlag = False
		If OnEditQueryClose Then OnEditQueryClose(*Designer, This, CloseMode, CancelFlag)
		If CancelFlag Then Return False
		FEditCloseMode = CloseMode
		Dim As WString Ptr NewText = 0
		WLet(NewText, EditText_->Text)
		Dim As Boolean WasChanged = TextMatrix(FEditRow, FEditCol) <> *NewText
		'Not in the edit before the editor hides: hiding it takes its focus, and the
		'lost focus (EditBoxLostFocus) must not commit the same edit once more
		FInEdit = False
		EditText_->Visible = False
		If WasChanged Then
			Dim As UString OldText = TextMatrix(FEditRow, FEditCol)
			TextToCell(*NewText, FEditRow, FEditCol)
			PushUndo(FEditRow, FEditCol, OldText, *NewText, FEditRowSel, FEditColSel)
			If OnAfterEdit Then OnAfterEdit(*Designer, This, FEditRow, FEditCol, *NewText)
		End If
		Dim As Long DoneRow = FEditRow, DoneCol = FEditCol
		FEditRow = -1
		FEditCol = -1
		If OnLeaveEdit Then OnLeaveEdit(*Designer, This)
		WDeAllocate(NewText)
		SetFocus
		'Navigation after Return/Tab close.
		Select Case CloseMode
			Case FlexEditCloseModeReturn
				Select Case FDirectionAfterReturn
					Case FlexDirectionAfterReturnDown : If DoneRow < FRows - 1 Then Row = DoneRow + 1
					Case FlexDirectionAfterReturnUp : If DoneRow > FFixedRows Then Row = DoneRow - 1
					Case FlexDirectionAfterReturnRight : If DoneCol < FCols - 1 Then Col = DoneCol + 1
					Case FlexDirectionAfterReturnLeft : If DoneCol > FFixedCols Then Col = DoneCol - 1
				End Select
			Case FlexEditCloseModeTab
				If DoneCol < FCols - 1 Then
					Col = DoneCol + 1
				ElseIf FWrapCellBehavior <> FlexWrapNone AndAlso DoneRow < FRows - 1 Then
					Row = DoneRow + 1
					Col = FFixedCols
				End If
			Case FlexEditCloseModeShiftTab
				If DoneCol > FFixedCols Then
					Col = DoneCol - 1
				ElseIf FWrapCellBehavior <> FlexWrapNone AndAlso DoneRow > FFixedRows Then
					Row = DoneRow - 1
					Col = FCols - 1
				End If
		End Select
		Return True
	End Function

	Sub GridDataEx.PositionEditBox
		'Place the edit TextBox over the current cell's client rectangle.
		If EditText_ = 0 Then Exit Sub
		If FFilterEditActive Then
			'Filter edit: cover the filter band cell of FFilterEditCol.
			If FFilterEditCol < 0 OrElse FFilterEditCol > FCols - 1 Then Exit Sub
			Dim As Long BorderSize = GetGridLineOffsets_AreaTop()
			Dim As Long FixedColCount = FFixedCols + FFrozenCols
			Dim As Long FixedRowCount = FFixedRows + FFrozenRows
			If FixedColCount > FCols Then FixedColCount = FCols
			If FixedRowCount > FRows Then FixedRowCount = FRows
			Dim As Long L, T, W, H
			H = FilterBarHeightPx()
			T = BorderSize + RowTopY(FixedRowCount)
			If FFilterEditCol < FixedColCount Then
				L = BorderSize + ColLeftX(FFilterEditCol)
			Else
				L = BorderSize + ColLeftX(FixedColCount) + (ColLeftX(FFilterEditCol) - ColLeftX(FLeftCol))
			End If
			W = ColLeftX(FFilterEditCol + 1) - ColLeftX(FFilterEditCol)
			EditText_->SetBounds UnScaleX(L), UnScaleY(T), UnScaleX(W + 1), UnScaleY(H + 1)
			Exit Sub
		End If
		If FEditRow < 0 OrElse FEditCol < 0 Then Exit Sub
		Dim As Long MR1, MC1, MR2, MC2
		GetMergedRange(FEditRow, FEditCol, MR1, MC1, MR2, MC2)
		Dim As Long L = ColLeftX(MC1), T = RowTopY(MR1)
		Dim As Long W = ColLeftX(MC2 + 1) - L, H = RowTopY(MR2 + 1) - T
		Dim As Long BorderSize = 0
		Select Case FBorderStyle
			Case FlexBorderStyleSingle, FlexBorderStyleThin : BorderSize = LogicalToPxX(1)
			Case FlexBorderStyleSunken, FlexBorderStyleRaised : BorderSize = LogicalToPxX(2)
		End Select
		L += BorderSize : T += BorderSize
		'MFF SetBounds speaks logical pixels: convert the physical cell rect.
		EditText_->SetBounds UnScaleX(L), UnScaleY(T), UnScaleX(W + 1), UnScaleY(H + 1)
	End Sub

	'=== Geometry conversion helpers ===

	Function GridDataEx.GetDefaultRowHeightPx() As Long
		'VB6 default row height is 240 twips; convert to pixels. The zoom scale
		'applies to every row/column so the whole sheet grows uniformly.
		Dim As Single TppY = TwipsPerPixelY()
		Dim As Long H = Max(1, CInt(FDefaultRowHeight / TppY))
		If FZoom <> 1 Then H = Max(1, CInt(H * FZoom))
		Return H
	End Function

	Function GridDataEx.GetDefaultColWidthPx() As Long
		'VB6 default column width is 1200 twips.
		Dim As Single TppX = TwipsPerPixelX()
		Dim As Long W = Max(1, CInt(FDefaultColWidth / TppX))
		If FZoom <> 1 Then W = Max(1, CInt(W * FZoom))
		Return W
	End Function

	Function GridDataEx.GetRowHeightPx(ByVal aIndex As Long) As Long
		If aIndex < 0 OrElse aIndex > FRows - 1 Then Return 0
		'Hidden rows collapse to zero height (filter + RowHidden).
		If (RowsArr(aIndex).State And FLEX_RWIS_HIDDEN) <> 0 Then Return 0
		Dim As Long H
		If RowsArr(aIndex).Height < 0 Then
			H = GetDefaultRowHeightPx()
		Else
			H = Max(1, CInt(RowsArr(aIndex).Height / TwipsPerPixelY()))
			If FZoom <> 1 Then H = Max(1, CInt(H * FZoom))
		End If
		Return H
	End Function

	Function GridDataEx.GetColWidthPx(ByVal aIndex As Long) As Long
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return 0
		'Hidden columns collapse to zero width (ColHidden).
		If (ColsArr(aIndex).State And FLEX_CLIS_HIDDEN) <> 0 Then Return 0
		Dim As Long W
		If ColsArr(aIndex).Width < 0 Then
			W = GetDefaultColWidthPx()
		Else
			W = Max(1, CInt(ColsArr(aIndex).Width / TwipsPerPixelX()))
			If FZoom <> 1 Then W = Max(1, CInt(W * FZoom))
		End If
		Return W
	End Function

	Sub GridDataEx.EnsureVisibleCell(ByVal aRow As Long, ByVal aCol As Long)
		If aRow < FTopRow Then
			FTopRow = Max(FFixedRows + FFrozenRows, aRow)
		Else
			'Check if below the visible area: the bottom of aRow must fit.
			'Binary search the smallest top row that shows aRow completely.
			Dim As Long FixedCount = FFixedRows + FFrozenRows
			If FixedCount > FRows Then FixedCount = FRows
			Dim As Long aRowB = Min(aRow, FRows - 1)
			Dim As Long VisH = ClientHeightPx() - GetGridLineOffsets_AreaTop() - (RowTopY(FixedCount) - RowTopY(0)) - FilterBarHeightPx()
			Dim As Long RowBottom = RowTopY(aRowB + 1)
			Dim As Long RowTop = RowTopY(aRowB)
			If RowBottom - RowTopY(FTopRow) > VisH AndAlso aRowB > FTopRow Then
				'Find max TryTop in [FTopRow..aRowB] with RowBottom - RowTopY(TryTop) <= VisH.
				Dim As Long Lo = FTopRow, Hi = aRowB
				While Lo < Hi
					Dim As Long MidI = (Lo + Hi) \ 2
					If RowBottom - RowTopY(MidI) <= VisH Then Hi = MidI Else Lo = MidI + 1
				Wend
				FTopRow = Max(FFixedRows + FFrozenRows, Lo)
			End If
		End If
		If aCol < FLeftCol Then
			FLeftCol = Max(FFixedCols + FFrozenCols, aCol)
		Else
			Dim As Long FixedColCount = FFixedCols + FFrozenCols
			If FixedColCount > FCols Then FixedColCount = FCols
			Dim As Long aColR = Min(aCol, FCols - 1)
			Dim As Long VisW = ClientWidthPx() - GetGridLineOffsets_AreaTop() - (ColLeftX(FixedColCount) - ColLeftX(0))
			Dim As Long ColRight = ColLeftX(aColR + 1)
			If ColRight - ColLeftX(FLeftCol) > VisW AndAlso aColR > FLeftCol Then
				Dim As Long Lo = FLeftCol, Hi = aColR
				While Lo < Hi
					Dim As Long MidJ = (Lo + Hi) \ 2
					If ColRight - ColLeftX(MidJ) <= VisW Then Hi = MidJ Else Lo = MidJ + 1
				Wend
				FLeftCol = Max(FFixedCols + FFrozenCols, Lo)
			End If
		End If
		If Handle <> 0 Then SetScrollBarsInternal
	End Sub

	'Border inset used by EnsureVisibleCell (pixel top/left inset of the grid area).
	Function GridDataEx.GetGridLineOffsets_AreaTop() As Long
		Select Case FBorderStyle
			Case FlexBorderStyleSingle, FlexBorderStyleThin : Return LogicalToPxX(1)
			Case FlexBorderStyleSunken, FlexBorderStyleRaised : Return LogicalToPxX(2)
		End Select
		Return 0
	End Function

	'=== Scroll bars ===

	#ifdef __USE_WINAPI__
	Sub GridDataEx.SetScrollBarsInternal
		'Totals come from the prefix caches (O(1)); bulk loads defer this via
		'FScrollBarsDirty and the state flushes before the next paint.
		If Handle = 0 Then
			FScrollBarsDirty = True
			Exit Sub
		End If
		Dim As Long TotalHeight = RowTopY(FRows) + FilterBarHeightPx()
		Dim As Long FixedHeight = RowTopY(FFixedRows + FFrozenRows) + FilterBarHeightPx()
		Dim As Long TotalWidth = ColLeftX(FCols)
		Dim As Long FixedWidth = ColLeftX(FFixedCols + FFrozenCols)
		Dim As SCROLLINFO SI
		SI.cbSize = SizeOf(SCROLLINFO)
		SI.fMask = SIF_RANGE Or SIF_PAGE Or SIF_POS
		If TotalHeight > ClientHeightPx() AndAlso (FScrollBars = 2 OrElse FScrollBars = 3) Then 'vertical present
			SI.nMin = 0
			SI.nMax = FRows - 1
			SI.nPage = Max(1, (ClientHeightPx() - FixedHeight) \ GetDefaultRowHeightPx())
			SI.nPos = FTopRow
			SetScrollInfo(Handle, SB_VERT, @SI, True)
		Else
			SI.nMin = 0 : SI.nMax = 0 : SI.nPage = 0 : SI.nPos = 0
			SetScrollInfo(Handle, SB_VERT, @SI, True)
		End If
		If TotalWidth > ClientWidthPx() AndAlso (FScrollBars = 1 OrElse FScrollBars = 3) Then
			SI.nMin = 0
			SI.nMax = FCols - 1
			SI.nPage = Max(1, (ClientWidthPx() - FixedWidth) \ GetDefaultColWidthPx())
			SI.nPos = FLeftCol
			SetScrollInfo(Handle, SB_HORZ, @SI, True)
		Else
			SI.nMin = 0 : SI.nMax = 0 : SI.nPage = 0 : SI.nPos = 0
			SetScrollInfo(Handle, SB_HORZ, @SI, True)
		End If
		FScrollBarsDirty = False
	End Sub
	#endif

	'=== Geometry prefix caches ===
	'Row/column pixel offsets are accumulated into RowPrefix/ColPrefix once
	'and then read with O(1) lookups (or O(log n) binary searches), so the
	'geometry cost no longer scales with the total row count.

	Sub GridDataEx.InvalidateRowGeometry()
		FRowGeomDirty = True
	End Sub

	Sub GridDataEx.InvalidateColGeometry()
		FColGeomDirty = True
	End Sub

	Sub GridDataEx.BuildRowGeometry()
		Dim As Long Need = FRows + 1
		If LBound(RowPrefix) > UBound(RowPrefix) OrElse UBound(RowPrefix) < Need - 1 Then
			Dim As Long Cap = IIf(FCapRows > Need, FCapRows, Need)
			ReDim RowPrefix(0 To Cap)
		End If
		Dim As Long DefH = GetDefaultRowHeightPx()
		Dim As Long Acc = 0
		Dim As Boolean Uniform = True
		For i As Long = 0 To FRows - 1
			RowPrefix(i) = Acc
			Dim As Long H = GetRowHeightPx(i)
			Acc += H
			If H <> DefH Then Uniform = False
		Next i
		RowPrefix(FRows) = Acc
		FRowUniformPx = IIf(Uniform, DefH, 0)
		FRowGeomDirty = False
	End Sub

	Sub GridDataEx.BuildColGeometry()
		Dim As Long Need = FCols + 1
		If LBound(ColPrefix) > UBound(ColPrefix) OrElse UBound(ColPrefix) < Need - 1 Then
			ReDim ColPrefix(0 To Need)
		End If
		Dim As Long DefW = GetDefaultColWidthPx()
		Dim As Long Acc = 0
		Dim As Boolean Uniform = True
		For j As Long = 0 To FCols - 1
			ColPrefix(j) = Acc
			Dim As Long W = GetColWidthPx(j)
			Acc += W
			If W <> DefW Then Uniform = False
		Next j
		ColPrefix(FCols) = Acc
		FColUniformPx = IIf(Uniform, DefW, 0)
		FColGeomDirty = False
	End Sub

	Function GridDataEx.RowAtY(ByVal Y As Long) As Long
		'Returns the row under grid coordinate Y, -1 if below the last row.
		'O(log n) via the prefix cache (O(1) when all rows share one height).
		If FRows <= 0 Then Return -1
		If FRowGeomDirty Then BuildRowGeometry
		If FRowUniformPx > 0 Then
			If Y < 0 Then Return 0
			Dim As Long Idx = Y \ FRowUniformPx
			If Idx > FRows - 1 Then Return -1
			Return Idx
		End If
		If Y < 0 Then Return 0
		If Y >= RowPrefix(FRows) Then Return -1
		'Binary search: largest i with RowPrefix(i) <= Y.
		Dim As Long Lo = 0, Hi = FRows - 1
		While Lo < Hi
			Dim As Long MidI = (Lo + Hi + 1) \ 2
			If RowPrefix(MidI) <= Y Then Lo = MidI Else Hi = MidI - 1
		Wend
		Return Lo
	End Function

	Function GridDataEx.ColAtX(ByVal X As Long) As Long
		If FCols <= 0 Then Return -1
		If FColGeomDirty Then BuildColGeometry
		If FColUniformPx > 0 Then
			If X < 0 Then Return 0
			Dim As Long Idx = X \ FColUniformPx
			If Idx > FCols - 1 Then Return -1
			Return Idx
		End If
		If X < 0 Then Return 0
		If X >= ColPrefix(FCols) Then Return -1
		Dim As Long Lo = 0, Hi = FCols - 1
		While Lo < Hi
			Dim As Long MidJ = (Lo + Hi + 1) \ 2
			If ColPrefix(MidJ) <= X Then Lo = MidJ Else Hi = MidJ - 1
		Wend
		Return Lo
	End Function

	Function GridDataEx.RowTopY(ByVal aRow As Long) As Long
		Dim As Long Idx = aRow
		If Idx < 0 Then Idx = 0
		If Idx > FRows Then Idx = FRows
		If Idx = 0 Then Return 0
		If FRowGeomDirty Then BuildRowGeometry
		If FRowUniformPx > 0 Then Return Idx * FRowUniformPx
		Return RowPrefix(Idx)
	End Function

	Function GridDataEx.ColLeftX(ByVal aCol As Long) As Long
		Dim As Long Idx = aCol
		If Idx < 0 Then Idx = 0
		If Idx > FCols Then Idx = FCols
		If Idx = 0 Then Return 0
		If FColGeomDirty Then BuildColGeometry
		If FColUniformPx > 0 Then Return Idx * FColUniformPx
		Return ColPrefix(Idx)
	End Function

	Sub GridDataEx.RepaintGrid
		If Handle = 0 Then Exit Sub
		#ifdef __USE_WINAPI__
			InvalidateRect(Handle, NULL, False)
			UpdateWindow(Handle)
		#else
			Repaint
		#endif
	End Sub

	#ifdef __USE_WINAPI__
	Sub GridDataEx.EnsureMemSurface(ByVal Dc As HDC, ByVal W As Long, ByVal H As Long)
		'Keeps an off-screen bitmap matching the client size; WM_PAINT draws
		'into it and blits once, so per-cell GDI calls never touch the screen.
		If W <= 0 OrElse H <= 0 Then Exit Sub
		If FMemDc <> 0 AndAlso FMemW = W AndAlso FMemH = H Then Exit Sub
		DestroyMemSurface
		FMemDc = Cast(Any Ptr, CreateCompatibleDC(Dc))
		FMemBmp = Cast(Any Ptr, CreateCompatibleBitmap(Dc, W, H))
		FMemOld = Cast(Any Ptr, SelectObject(Cast(HDC, FMemDc), Cast(HBITMAP, FMemBmp)))
		FMemW = W
		FMemH = H
	End Sub

	Sub GridDataEx.DestroyMemSurface()
		If FMemDc <> 0 Then
			If FMemOld <> 0 Then SelectObject(Cast(HDC, FMemDc), Cast(HGDIOBJ, FMemOld))
			If FMemBmp <> 0 Then DeleteObject(Cast(HBITMAP, FMemBmp))
			DeleteDC(Cast(HDC, FMemDc))
		End If
		FMemDc = 0
		FMemBmp = 0
		FMemOld = 0
		FMemW = 0
		FMemH = 0
	End Sub

	Sub GridDataEx.ScrollGridPixels(ByVal dX As Long, ByVal dY As Long)
		'Shifts the already-drawn pixels and invalidates only the exposed
		'strip. The off-screen buffer is scrolled with ScrollDC so screen and
		'buffer stay identical; the strip repaint then only fills the exposed
		'part (background first, so it is correct by construction).
		'The blit is only safe when the grid content completely covers the
		'scroll rect in the scroll direction - otherwise old pixels would be
		'dragged into the uncovered background area, so a full repaint runs.
		'Vertical scrolling excludes the fixed/frozen row band (it never moves
		'vertically). Horizontal scrolling excludes only the fixed/frozen
		'COLUMN band: the scrollable columns of the fixed header rows move
		'with the content.
		If Handle = 0 Then Exit Sub
		If dX <> 0 AndAlso dY <> 0 Then
			RepaintGrid
			Exit Sub
		End If
		If dX = 0 AndAlso dY = 0 Then Exit Sub
		Dim As Long BorderSize = GetGridLineOffsets_AreaTop()
		Dim As Long FixedRowCount = FFixedRows + FFrozenRows
		Dim As Long FixedColCount = FFixedCols + FFrozenCols
		If FixedRowCount > FRows Then FixedRowCount = FRows
		If FixedColCount > FCols Then FixedColCount = FCols
		'Horizontal scrolling keeps the fixed/frozen COLUMN band in place
		'(only the scrollable columns move). Vertical scrolling instead moves
		'the fixed columns too - they hold the per-row content (e.g. row
		'indexes) that must travel with its row; only the fixed/frozen ROW
		'band (plus the filter band) stays put.
		Dim As Long RCLeft = BorderSize
		Dim As Long RCTop = BorderSize
		If dX <> 0 Then RCLeft = BorderSize + (ColLeftX(FixedColCount) - ColLeftX(0))
		If dX = 0 Then RCTop = BorderSize + (RowTopY(FixedRowCount) - RowTopY(0)) + FilterBarHeightPx()
		Dim As Long RCRight = ClientWidthPx() - BorderSize
		Dim As Long RCBottom = ClientHeightPx() - BorderSize
		If RCRight <= RCLeft OrElse RCBottom <= RCTop Then
			RepaintGrid
			Exit Sub
		End If
		'Content coverage check in the scroll direction.
		If dY <> 0 Then
			Dim As Long GridBottom = RCTop + (RowTopY(FRows) - RowTopY(FTopRow))
			If GridBottom < RCBottom Then
				RepaintGrid
				Exit Sub
			End If
		Else
			Dim As Long GridRight = RCLeft + (ColLeftX(FCols) - ColLeftX(FLeftCol))
			If GridRight < RCRight Then
				RepaintGrid
				Exit Sub
			End If
		End If
		Dim As RECT RC
		RC.Left = RCLeft
		RC.Top = RCTop
		RC.Right = RCRight
		RC.Bottom = RCBottom
		ScrollWindowEx(Handle, dX, dY, @RC, @RC, NULL, NULL, SW_INVALIDATE)
		'Keep the off-screen buffer in sync with the shifted screen pixels.
		If FMemDc <> 0 Then ScrollDC(Cast(HDC, FMemDc), dX, dY, @RC, @RC, NULL, NULL)
	End Sub
	#endif

	'=== Drawing engine ===

	Sub GridDataEx.DrawGridArea(ByRef Cv As My.Sys.Drawing.Canvas, ByVal DrawLeft As Long, ByVal DrawTop As Long, ByVal DrawRight As Long, ByVal DrawBottom As Long)
		Dim As My.Sys.Drawing.Rect RCFull
		RCFull.Left = DrawLeft : RCFull.Top = DrawTop
		RCFull.Right = DrawRight : RCFull.Bottom = DrawBottom
		'Background (backend-agnostic fill).
		Cv.FillRect(RCFull, FlexWinColor(FBackColorBkg))

		'Wallpaper behind the cells (HBITMAP, any of the 11 alignments).
		If FWallPaper <> 0 Then
			Dim As Long WPB = GetGridLineOffsets_AreaTop()
			DrawWallPaperArea(Cv, DrawLeft + WPB, DrawTop + WPB, DrawRight - WPB, DrawBottom - WPB)
		End If

		Dim As Long BorderSize = GetGridLineOffsets_AreaTop()

		Dim As Long AreaTop = DrawTop + BorderSize
		Dim As Long AreaLeft = DrawLeft + BorderSize
		Dim As Long AreaBottom = DrawBottom - BorderSize
		Dim As Long AreaRight = DrawRight - BorderSize

		'Visible-range setup: fixed region size and the client origin of the
		'scrollable area. The first scrollable row/col (FTopRow/FLeftCol) is
		'always drawn right after the fixed region (whole-row/column jumps),
		'so no extra scroll offset applies to the drawing positions.
		Dim As Long FixedRowCount = FFixedRows + FFrozenRows
		Dim As Long FixedColCount = FFixedCols + FFrozenCols
		If FixedRowCount > FRows Then FixedRowCount = FRows
		If FixedColCount > FCols Then FixedColCount = FCols
		Dim As Long FilterH = FilterBarHeightPx()
		Dim As Long ScrollTop = AreaTop + (RowTopY(FixedRowCount) - RowTopY(0)) + FilterH
		Dim As Long ScrollLeft = AreaLeft + (ColLeftX(FixedColCount) - ColLeftX(0))
		Dim As Long TopRowDraw = FTopRow
		If TopRowDraw < FixedRowCount Then TopRowDraw = FixedRowCount
		Dim As Long LeftColDraw = FLeftCol
		If LeftColDraw < FixedColCount Then LeftColDraw = FixedColCount
		Dim As Long YCur, XCur

		'Sheet border area color (fixed background behind cells).
		Dim As Long SheetTop = AreaTop, SheetLeft = AreaLeft
		Dim As Long i, j

		'=== Draw fixed rows + the visible scroll range only (never all rows) ===
		YCur = AreaTop
		For i = 0 To FixedRowCount - 1
			If YCur > AreaBottom Then Exit For
			If (RowsArr(i).State And FLEX_RWIS_HIDDEN) = 0 Then
				DrawGridRowCells(Cv, i, YCur, AreaLeft, 0, FixedColCount - 1, AreaRight)
				DrawGridRowCells(Cv, i, YCur, ScrollLeft, LeftColDraw, FCols - 1, AreaRight)
			End If
			YCur += GetRowHeightPx(i)
		Next i
		'Filter bar band between the fixed rows and the first scroll row.
		If FilterH > 0 Then DrawFilterBar(Cv, YCur, AreaLeft, ScrollLeft, FixedColCount, LeftColDraw, AreaRight)
		YCur = ScrollTop
		For i = TopRowDraw To FRows - 1
			If YCur > AreaBottom Then Exit For
			If (RowsArr(i).State And FLEX_RWIS_HIDDEN) = 0 Then
				DrawGridRowCells(Cv, i, YCur, AreaLeft, 0, FixedColCount - 1, AreaRight)
				DrawGridRowCells(Cv, i, YCur, ScrollLeft, LeftColDraw, FCols - 1, AreaRight)
			End If
			YCur += GetRowHeightPx(i)
		Next i

		'=== Grid lines overlay (flat style) ===
		'Lines between two cells of the same merged block are suppressed.
		'Color resolves per cell through GetGridLineColor (fixed/frozen/normal).
		'Only the visible row/column ranges are visited; the fixed region and
		'the scrolled region are handled as separate, correctly placed passes.
		If (FGridLines <> GridDataLineNone) Then
			If ((FGridLines = GridDataLineFlat) OrElse (FGridLines = GridDataLineFlatHorz)) Then
				'Horizontal line at the top of every visible row except row 0.
				YCur = AreaTop
				For i = 0 To FixedRowCount - 1
					If YCur > AreaBottom Then Exit For
					If (i > 0) AndAlso ((RowsArr(i).State And FLEX_RWIS_HIDDEN) = 0) Then
						DrawGridLinesRow(Cv, i, YCur, AreaLeft, 0, FixedColCount - 1, AreaRight)
						DrawGridLinesRow(Cv, i, YCur, ScrollLeft, LeftColDraw, FCols - 1, AreaRight)
					End If
					YCur += GetRowHeightPx(i)
					If YCur > AreaBottom Then Exit For
				Next i
				YCur = ScrollTop
				For i = TopRowDraw To FRows - 1
					If YCur > AreaBottom Then Exit For
					If (RowsArr(i).State And FLEX_RWIS_HIDDEN) = 0 Then
						DrawGridLinesRow(Cv, i, YCur, AreaLeft, 0, FixedColCount - 1, AreaRight)
						DrawGridLinesRow(Cv, i, YCur, ScrollLeft, LeftColDraw, FCols - 1, AreaRight)
					End If
					YCur += GetRowHeightPx(i)
				Next i
			End If
			If ((FGridLines = GridDataLineFlat) OrElse (FGridLines = GridDataLineFlatVert)) Then
				'Vertical line at the left of every visible column except column 0.
				'Fixed columns span the full height: fixed rows portion + scrolled rows portion.
				XCur = AreaLeft
				For j = 0 To FixedColCount - 1
					If XCur > AreaRight Then Exit For
					If (j > 0) AndAlso ((ColsArr(j).State And FLEX_CLIS_HIDDEN) = 0) Then
						DrawGridLinesCol(Cv, j, XCur, AreaTop, 0, FixedRowCount - 1, AreaBottom)
						DrawGridLinesCol(Cv, j, XCur, ScrollTop, TopRowDraw, FRows - 1, AreaBottom)
					End If
					XCur += GetColWidthPx(j)
					If XCur > AreaRight Then Exit For
				Next j
				XCur = ScrollLeft
				For j = LeftColDraw To FCols - 1
					If XCur > AreaRight Then Exit For
					If (ColsArr(j).State And FLEX_CLIS_HIDDEN) = 0 Then
						DrawGridLinesCol(Cv, j, XCur, AreaTop, 0, FixedRowCount - 1, AreaBottom)
						DrawGridLinesCol(Cv, j, XCur, ScrollTop, TopRowDraw, FRows - 1, AreaBottom)
					End If
					XCur += GetColWidthPx(j)
				Next j
			End If
		End If

		'=== Outer border (backend-agnostic bevel) ===
		If BorderSize > 0 Then
			Dim As Long ClrDark = FlexWinColor(&H808080)
			Dim As Long ClrLight = FlexWinColor(&HFFFFFF)
			Dim As Long Lft = DrawLeft, TopB = DrawTop
			Dim As Long Rgt = DrawRight - 1, Btm = DrawBottom - 1
			If FBorderStyle = FlexBorderStyleSunken Then
				Cv.Line(Lft, TopB, Rgt, TopB, ClrDark) : Cv.Line(Lft, TopB, Lft, Btm, ClrDark)
				Cv.Line(Lft, Btm, Rgt, Btm, ClrLight) : Cv.Line(Rgt, TopB, Rgt, Btm, ClrLight)
			ElseIf FBorderStyle = FlexBorderStyleRaised Then
				Cv.Line(Lft, Btm, Rgt, Btm, ClrDark) : Cv.Line(Rgt, TopB, Rgt, Btm, ClrDark)
				Cv.Line(Lft, TopB, Rgt, TopB, ClrLight) : Cv.Line(Lft, TopB, Lft, Btm, ClrLight)
			Else
				Cv.Line(Lft, TopB, Rgt, TopB, ClrDark) : Cv.Line(Lft, Btm, Rgt, Btm, ClrDark)
				Cv.Line(Lft, TopB, Lft, Btm, ClrDark) : Cv.Line(Rgt, TopB, Rgt, Btm, ClrDark)
			End If
		End If

		'Drag/drop feedback: highlighted target row/column band and the
		'insert mark arrow (drawn on top of everything else).
		DrawDropHighlight(Cv)
		DrawInsertMark(Cv)
	End Sub

	Sub GridDataEx.DrawGridRowCells(ByRef Cv As My.Sys.Drawing.Canvas, ByVal aRow As Long, ByVal YCur As Long, ByVal XCurStart As Long, ByVal aColStart As Long, ByVal aColEnd As Long, ByVal AreaRight As Long)
		'Draws one grid row's cells for the inclusive column range
		'[aColStart..aColEnd] starting at pixel XCurStart. Called once for the
		'fixed column range and once for the scrolled range; merged slaves are
		'skipped.
		Dim As Long XCur = XCurStart
		For j As Long = aColStart To aColEnd
			Dim As Long ColW = GetColWidthPx(j)
			If XCur > AreaRight Then Exit For
			'Hidden columns have zero width; skip their cells entirely.
			If (ColsArr(j).State And FLEX_CLIS_HIDDEN) <> 0 Then
				XCur += ColW
				Continue For
			End If
			'Merged cells: slaves are skipped; the master draws the whole block.
			Dim As Long MR1, MC1, MR2, MC2
			GetMergedRange(aRow, j, MR1, MC1, MR2, MC2)
			Dim IsSlave As Boolean = CBool((aRow <> MR1) OrElse (j <> MC1))
			Dim As Boolean IsFixedCell = (aRow < FFixedRows) OrElse (j < FFixedCols)
			If IsSlave Then
				XCur += ColW
				Continue For
			End If
			Dim IsSelected As Boolean = False
			If FAllowSelection Then
				If FSelectionMode = FlexSelectionModeByRow Then
					IsSelected = (aRow >= Min(FRow, FRowSel)) AndAlso (aRow <= Max(FRow, FRowSel))
				ElseIf FSelectionMode = FlexSelectionModeByColumn Then
					IsSelected = (j >= Min(FCol, FColSel)) AndAlso (j <= Max(FCol, FColSel))
				Else
					IsSelected = (aRow >= Min(FRow, FRowSel)) AndAlso (aRow <= Max(FRow, FRowSel)) AndAlso _
					             (j >= Min(FCol, FColSel)) AndAlso (j <= Max(FCol, FColSel))
				End If
				If FHighLight = FlexHighLightWithFocus Then IsSelected = IsSelected AndAlso CBool((aRow = FRow) OrElse (j = FCol))
			End If
			'Total block extent in pixels (master cell + merged span).
			Dim As Long RowH = GetRowHeightPx(aRow)
			Dim As Long BlockW = ColW, BlockH = RowH
			If (MR2 > aRow) OrElse (MC2 > j) Then
				BlockW = ColLeftX(MC2 + 1) - ColLeftX(MC1)
				BlockH = RowTopY(MR2 + 1) - RowTopY(MR1)
			End If
			DrawCellContent(Cv, XCur, YCur, XCur + BlockW, YCur + BlockH, aRow, j, IsFixedCell)
			'Advance over all columns consumed by the block span.
			XCur += BlockW
			j = MC2
		Next j
	End Sub

	Sub GridDataEx.DrawGridLinesRow(ByRef Cv As My.Sys.Drawing.Canvas, ByVal aRow As Long, ByVal YCur As Long, ByVal XCurStart As Long, ByVal aColStart As Long, ByVal aColEnd As Long, ByVal AreaRight As Long)
		'Horizontal line at the top of row aRow over the inclusive column
		'range [aColStart..aColEnd], segment-by-segment, skipping spans where
		'the cells ABOVE (aRow-1,j) and BELOW (aRow,j) share a block.
		Dim As Long XSeg = XCurStart
		For j As Long = aColStart To aColEnd
			Dim As Long ColW2 = GetColWidthPx(j)
			If XSeg > AreaRight Then Exit For
			If aRow > 0 Then
				Dim As Long HU1, HU2, HU3, HU4, HD1, HD2, HD3, HD4
				GetMergedRange(aRow - 1, j, HU1, HU2, HU3, HU4)
				GetMergedRange(aRow, j, HD1, HD2, HD3, HD4)
				Dim SameBlock As Boolean = CBool((HU1 = HD1) AndAlso (HU2 = HD2) AndAlso (HU3 = HD3) AndAlso (HU4 = HD4))
				If Not SameBlock Then
					Dim As Boolean FixArea = CBool(aRow < FFixedRows OrElse j < FFixedCols)
					Dim As Boolean FrzArea = CBool((aRow >= FFixedRows) AndAlso (aRow < FFixedRows + FFrozenRows)) OrElse CBool((j >= FFixedCols) AndAlso (j < FFixedCols + FFrozenCols))
					Dim As Long LClr = GetGridLineColor(aRow, j, FixArea)
					Dim As Long LWid = GetAreaLineWidth(FixArea, FrzArea)
					If LWid > 1 Then
						DrawThickHLine(Cv, XSeg, XSeg + ColW2, YCur, LWid, LClr)
					Else
						Cv.Line(XSeg, YCur, XSeg + ColW2, YCur, LClr)
					End If
				End If
			End If
			XSeg += ColW2
		Next j
	End Sub

	Sub GridDataEx.DrawGridLinesCol(ByRef Cv As My.Sys.Drawing.Canvas, ByVal aCol As Long, ByVal XCur As Long, ByVal YCurStart As Long, ByVal aRowStart As Long, ByVal aRowEnd As Long, ByVal AreaBottom As Long)
		'Vertical line at the left of column aCol over the inclusive row range
		'[aRowStart..aRowEnd], segment-by-segment, skipping spans where the
		'cells LEFT/RIGHT share a block.
		Dim As Long YSeg = YCurStart
		For i As Long = aRowStart To aRowEnd
			Dim As Long RowH2 = GetRowHeightPx(i)
			If YSeg > AreaBottom Then Exit For
			If aCol > 0 Then
				Dim As Long VL1, VL2, VL3, VL4, VR1, VR2, VR3, VR4
				GetMergedRange(i, aCol - 1, VL1, VL2, VL3, VL4)
				GetMergedRange(i, aCol, VR1, VR2, VR3, VR4)
				Dim SameV As Boolean = CBool((VL1 = VR1) AndAlso (VL2 = VR2) AndAlso (VL3 = VR3) AndAlso (VL4 = VR4))
				If Not SameV Then
					Dim As Boolean FixAreaV = CBool(i < FFixedRows OrElse aCol < FFixedCols)
					Dim As Boolean FrzAreaV = CBool((i >= FFixedRows) AndAlso (i < FFixedRows + FFrozenRows)) OrElse CBool((aCol >= FFixedCols) AndAlso (aCol < FFixedCols + FFrozenCols))
					Dim As Long LClrV = GetGridLineColor(i, aCol, FixAreaV)
					Dim As Long LWidV = GetAreaLineWidth(FixAreaV, FrzAreaV)
					If LWidV > 1 Then
						DrawThickVLine(Cv, XCur, YSeg, YSeg + RowH2, LWidV, LClrV)
					Else
						Cv.Line(XCur, YSeg, XCur, YSeg + RowH2, LClrV)
					End If
				End If
			End If
			YSeg += RowH2
		Next i
	End Sub

	Sub GridDataEx.DrawCellContent(ByRef Cv As My.Sys.Drawing.Canvas, ByVal RCLeft As Long, ByVal RCTop As Long, ByVal RCRight As Long, ByVal RCBottom As Long, ByVal aRow As Long, ByVal aCol As Long, ByVal bFixedArea As Boolean)
		Dim As FlexCell Ptr C = CellAt(aRow, aCol)
		Dim As FlexCellFormat Ptr F = 0
		If C <> 0 Then F = C->Fmtg

		Dim As Boolean IsSelected = False
		If FAllowSelection Then
			If FSelectionMode = FlexSelectionModeByRow Then
				IsSelected = (aRow >= Min(FRow, FRowSel)) AndAlso (aRow <= Max(FRow, FRowSel))
			ElseIf FSelectionMode = FlexSelectionModeByColumn Then
				IsSelected = (aCol >= Min(FCol, FColSel)) AndAlso (aCol <= Max(FCol, FColSel))
			Else
				IsSelected = (aRow >= Min(FRow, FRowSel)) AndAlso (aRow <= Max(FRow, FRowSel)) AndAlso _
				             (aCol >= Min(FCol, FColSel)) AndAlso (aCol <= Max(FCol, FColSel))
			End If
			'Non-contiguous per-row marks participate like the range selection.
			If IsSelected = False AndAlso ((RowsArr(aRow).State And FLEX_RWIS_SELECTED) <> 0) Then IsSelected = True
			Select Case FHighLight
				Case FlexHighLightNever : IsSelected = False
				Case FlexHighLightWithFocus
					If Focused() = False Then IsSelected = False
				Case FlexHighLightAlwaysFocusRect
					'Selection highlight shown with a focus-styled frame; keep highlight.
			End Select
		End If

		'Determine colors: cell format > selection > fixed > normal/alternating.
		Dim As Long BackColorValue, ForeColorValue
		If F <> 0 AndAlso F->BackColor >= 0 Then
			BackColorValue = FlexWinColor(F->BackColor)
		ElseIf IsSelected Then
			BackColorValue = FlexWinColor(FBackColorSel)
		ElseIf bFixedArea Then
			BackColorValue = FlexWinColor(FBackColorFixed)
		ElseIf (FBackColorAlt >= 0) AndAlso (((aRow - FFixedRows) And 1) = 1) Then
			BackColorValue = FlexWinColor(FBackColorAlt)
		Else
			BackColorValue = FlexWinColor(BackColor)
		End If
		If F <> 0 AndAlso F->ForeColor >= 0 Then
			ForeColorValue = FlexWinColor(F->ForeColor)
		ElseIf IsSelected AndAlso FUseForeColorSel Then
			ForeColorValue = FlexWinColor(FForeColorSel)
		ElseIf bFixedArea Then
			ForeColorValue = FlexWinColor(FForeColorFixed)
		Else
			ForeColorValue = FlexWinColor(ForeColor)
		End If

		Dim As My.Sys.Drawing.Rect RC
		RC.Left = RCLeft : RC.Top = RCTop : RC.Right = RCRight : RC.Bottom = RCBottom
		Cv.FillRect(RC, BackColorValue)

		'Flood fill (progress bar style) beneath the text.
		If F <> 0 AndAlso F->FloodPercent > 0 Then
			Dim As Long FloodClr = F->FloodColor
			If FloodClr < 0 Then FloodClr = FFloodColor
			If FloodClr < 0 Then FloodClr = FBackColorSel
			DrawFloodFill(Cv, RCLeft, RCTop, RCRight, RCBottom, F->FloodPercent, FloodClr)
		End If

		'Cell picture / icon: rendered at its configured size and direction.
		Dim As Long PicIndL = 0, PicIndR = 0
		DrawCellPicture(Cv, RCLeft, RCTop, RCRight, RCBottom, aRow, aCol, PicIndL, PicIndR)

		'Fixed cells get an edge look per GridLinesFixed.
		If bFixedArea Then
			Dim As Long LineStyle = GridLinesFixed
			Dim As Boolean IsFrozenCell = CBool((aRow >= FFixedRows) AndAlso (aRow < FFixedRows + FFrozenRows)) OrElse _
			                              CBool((aCol >= FFixedCols) AndAlso (aCol < FFixedCols + FFrozenCols))
			If IsFrozenCell Then LineStyle = GridLinesFrozen
			Dim As Long ClrHi = FlexWinColor(&HFFFFFF)
			Dim As Long ClrLo = FlexWinColor(&H808080)
			Select Case LineStyle
				Case GridDataLineInset
					Cv.Line(RCLeft + 1, RCBottom - 1, RCRight - 1, RCBottom - 1, ClrHi) : Cv.Line(RCRight - 1, RCTop + 1, RCRight - 1, RCBottom - 1, ClrHi)
					Cv.Line(RCLeft + 1, RCTop + 1, RCRight - 2, RCTop + 1, ClrLo) : Cv.Line(RCLeft + 1, RCTop + 1, RCLeft + 1, RCBottom - 2, ClrLo)
				Case GridDataLineRaised
					Cv.Line(RCLeft + 1, RCBottom - 1, RCRight - 1, RCBottom - 1, ClrLo) : Cv.Line(RCRight - 1, RCTop + 1, RCRight - 1, RCBottom - 1, ClrLo)
					Cv.Line(RCLeft + 1, RCTop + 1, RCRight - 2, RCTop + 1, ClrHi) : Cv.Line(RCLeft + 1, RCTop + 1, RCLeft + 1, RCBottom - 2, ClrHi)
				Case GridDataLineDashes
					Dim As Long Xc = RCLeft + 1
					Do While Xc < RCRight - 1
						Cv.Line(Xc, RCBottom - 1, Min(Xc + 2, RCRight - 1), RCBottom - 1, ClrLo)
						Xc += 4
					Loop
				Case GridDataLineDots
					Dim As Long Xc = RCLeft + 1
					Do While Xc < RCRight - 1
						Cv.SetPixel(Xc, RCBottom - 1, ClrLo)
						Xc += 3
					Loop
			End Select
		End If

		'Text style bevel (control-wide or per-cell).
		Dim As Long StyleToUse = -1
		If F <> 0 AndAlso F->TextStyle >= 0 Then
			StyleToUse = F->TextStyle
		Else
			StyleToUse = IIf(bFixedArea, FTextStyleFixed, FTextStyle)
		End If
		If StyleToUse <> FlexTextStyleFlat AndAlso StyleToUse >= 0 Then
			ApplyTextStyleFrame(Cv, RCLeft, RCTop, RCRight, RCBottom, StyleToUse, CBool(StyleToUse >= FlexTextStyleRaisedLight))
		End If

		'Focus rect on current cell, per FocusRect style.
		If bFixedArea = False Then
			If (aRow = FRow) AndAlso (aCol = FCol) AndAlso (FFocusRect <> FlexFocusRectNone) Then
				If Focused() Then
					Dim As My.Sys.Drawing.Rect RCFocus
					Select Case FFocusRect
						Case FlexFocusRectLight
							RCFocus.Left = RCLeft + 2 : RCFocus.Top = RCTop + 2 : RCFocus.Right = RCRight - 2 : RCFocus.Bottom = RCBottom - 2
							Cv.DrawFocusRect(RCFocus)
						Case FlexFocusRectHeavy
							RCFocus.Left = RCLeft + 1 : RCFocus.Top = RCTop + 1 : RCFocus.Right = RCRight - 1 : RCFocus.Bottom = RCBottom - 1
							Cv.Line(RCFocus.Left, RCFocus.Top, RCFocus.Right, RCFocus.Top, ForeColorValue)
							Cv.Line(RCFocus.Left, RCFocus.Bottom, RCFocus.Right, RCFocus.Bottom, ForeColorValue)
							Cv.Line(RCFocus.Left, RCFocus.Top, RCFocus.Left, RCFocus.Bottom, ForeColorValue)
							Cv.Line(RCFocus.Right, RCFocus.Top, RCFocus.Right, RCFocus.Bottom, ForeColorValue)
						Case FlexFocusRectFlat
							RCFocus.Left = RCLeft + 1 : RCFocus.Top = RCTop + 1 : RCFocus.Right = RCRight - 1 : RCFocus.Bottom = RCBottom - 1
							Cv.Line(RCFocus.Left, RCFocus.Top, RCFocus.Right, RCFocus.Top, ForeColorValue)
							Cv.Line(RCFocus.Left, RCFocus.Bottom, RCFocus.Right, RCFocus.Bottom, ForeColorValue)
							Cv.Line(RCFocus.Left, RCFocus.Top, RCFocus.Left, RCFocus.Bottom, ForeColorValue)
							Cv.Line(RCFocus.Right, RCFocus.Top, RCFocus.Right, RCFocus.Bottom, ForeColorValue)
					End Select
				End If
			End If
		End If

		'Checkbox glyph.
		Dim As Integer CheckedState = EffectiveChecked(aRow, aCol)
		Dim As Boolean HasCheckBox = (CheckedState <> FlexNoCheckBox)
		Dim As Long CBSize = 0, CBX = 0, CBY = 0
		If HasCheckBox Then
			CBSize = min(CvCheckBoxSize(), RCBottom - RCTop - 2)
			CBX = RCLeft + 3
			CBY = RCTop + ((RCBottom - RCTop) - CBSize) \ 2
			Dim As Boolean Disabled = (CheckedState >= FlexDisabledUnchecked)
			DrawCheckBoxGlyph(Cv, CBX, CBY, CBSize, IIf(CheckedState >= FlexDisabledUnchecked, CheckedState - FlexDisabledUnchecked, CheckedState), Disabled)
		End If

		'Sort arrow in fixed cells (drawn right of the text, right-aligned unless configured).
		If bFixedArea AndAlso aCol <= FCols - 1 Then
			If ColsArr(aCol).SortArrow <> FlexSortArrowNone Then
				Dim As Long ArrowClr = ColsArr(aCol).SortArrowColor
				If ArrowClr < 0 Then ArrowClr = FSortArrowColor
				If ArrowClr < 0 Then ArrowClr = ForeColorValue
				Dim As Long ArrowX = RCRight - 8
				If ColsArr(aCol).SortArrowAlignment = FlexLeftRightAlignmentLeft Then ArrowX = RCLeft + 8
				DrawSortArrow(Cv, ArrowX, (RCTop + RCBottom) \ 2, ColsArr(aCol).SortArrow, ArrowClr)
			End If
		End If

		'Text via Canvas.TextOut, manual alignment, optional per-cell font.
		Dim TextValue As UString = ""
		If (C <> 0) AndAlso (C->FText <> 0) Then TextValue = *C->FText
		'Columns with a lookup show the translated value.
		If HasLookup(aCol) Then TextValue = LookupTranslate(TextValue, FlexLookupConvValue, aCol)
		'Cell button columns: the whole cell is one owner-drawn button whose
		'caption is the (translated) cell text.
		If bFixedArea = False AndAlso (ColsArr(aCol).State And FLEX_CLIS_CELLBUTTONS) <> 0 Then
			DrawCellButtonGlyph(Cv, RCLeft, RCTop, RCRight, RCBottom, TextValue, IsSelected, CBool(Enabled = False))
			Exit Sub
		End If
		If Len(TextValue) > 0 Then
			Dim As Long AlignIdx = -1
			If F <> 0 AndAlso F->Alignment >= 0 Then
				AlignIdx = F->Alignment
			Else
				AlignIdx = GetCellAlign(aRow, aCol, bFixedArea)
			End If
			'Per-cell font: save, apply, draw, restore.
			Dim As Boolean NeedFont = False
			Dim As String SavedName = ""
			Dim As Integer SavedSize = 0
			Dim As Boolean SavedBold = False, SavedItalic = False, SavedUnderline = False, SavedStrikeOut = False
			If F <> 0 Then
				Dim As String CellName = ""
				If F->FontName <> 0 Then CellName = *F->FontName
				NeedFont = CBool(Len(CellName) > 0) OrElse (F->FontSize > 0) OrElse (F->FontStyle <> 0)
				If NeedFont Then
					SavedName = Cv.Font.Name
					SavedSize = Cv.Font.Size
					SavedBold = Cv.Font.Bold
					SavedItalic = Cv.Font.Italic
					SavedUnderline = Cv.Font.Underline
					SavedStrikeOut = Cv.Font.StrikeOut
					If Len(CellName) > 0 Then Cv.Font.Name = CellName
					If F->FontSize > 0 Then Cv.Font.Size = F->FontSize
					Cv.Font.Bold = IIf(F->FontStyle <> 0, CBool((F->FontStyle And FLEX_FS_BOLD) <> 0), SavedBold)
					Cv.Font.Italic = IIf(F->FontStyle <> 0, CBool((F->FontStyle And FLEX_FS_ITALIC) <> 0), SavedItalic)
					Cv.Font.Underline = IIf(F->FontStyle <> 0, CBool((F->FontStyle And FLEX_FS_UNDERLINE) <> 0), SavedUnderline)
					Cv.Font.StrikeOut = IIf(F->FontStyle <> 0, CBool((F->FontStyle And FLEX_FS_STRIKEOUT) <> 0), SavedStrikeOut)
				End If
			End If
			Dim As Long TextW = Cv.TextWidth(TextValue)
			Dim As Long CellW = RCRight - RCLeft, CellH = RCBottom - RCTop
			Dim As Long TextH = Cv.TextHeight(TextValue)
			Dim As Long Tx = RCLeft + 3
			'Reserve space taken by the cell picture, checkbox and sort arrow.
			Dim As Long IndentL = PicIndL, IndentR = PicIndR
			If HasCheckBox Then IndentL += CBSize + 5
			'Column text indentation (ColTextIndent + OnCellTextIndent, twips).
			If (ColsArr(aCol).State And FLEX_CLIS_TEXTINDENT) <> 0 Then
				Dim As Long TwIndL = 0, TwIndR = 0
				If OnCellTextIndent Then OnCellTextIndent(*Designer, This, aRow, aCol, TwIndL, TwIndR)
				IndentL += CInt(TwIndL / TwipsPerPixelX())
				IndentR += CInt(TwIndR / TwipsPerPixelX())
			End If
			If bFixedArea AndAlso ColsArr(aCol).SortArrow <> FlexSortArrowNone Then
				If ColsArr(aCol).SortArrowAlignment = FlexLeftRightAlignmentRight Then IndentR += 12 Else IndentL += 12
			End If
			Dim As Long AvailW = CellW - IndentL - IndentR - 6
			'Ellipsis trimming when the text does not fit and wrapping is off.
			Dim As Boolean WasTrimmed = False
			Dim As Long WrapOpt = ColsArr(aCol).WordWrapOption
			If bFixedArea AndAlso ColsArr(aCol).WordWrapOptionFixed >= 0 Then WrapOpt = ColsArr(aCol).WordWrapOptionFixed
			Dim As Boolean DoWrap = FWordWrap OrElse CBool(WrapOpt >= FlexWordBreak AndAlso WrapOpt <> FlexSingleLine)
			If (DoWrap = False) AndAlso (TextW > AvailW) AndAlso (AvailW > 12) Then
				Dim As Long Ell = IIf(bFixedArea, FEllipsisFormatFixed, FEllipsisFormat)
				Dim As String EllChar = "..."
				If Ell = FlexEllipsisFormatPath Then EllChar = "..."
				Do
					If Len(TextValue) <= 1 Then Exit Do
					TextValue = Mid(TextValue, 1, Len(TextValue) - 1)
					WasTrimmed = True
					TextW = Cv.TextWidth(TextValue & EllChar)
				Loop While (TextW > AvailW) AndAlso (Len(TextValue) > 0)
				If WasTrimmed Then TextValue = TextValue & EllChar
			End If
			If DoWrap AndAlso TextW > AvailW AndAlso AvailW > 12 Then
				Dim As Long MaxLines = Max(1, CellH \ Max(1, TextH))
				Dim As String OutText = ""
				If ColsArr(aCol).MimicTextBox > 0 Then
					'MimicTextBox: break on any character (DT_EDITCONTROL feel).
					Dim As String WrLine = ""
					Dim As Long LineCount = 0
					For iCh As Long = 1 To Len(TextValue)
						Dim As String Ch1 = Mid(TextValue, iCh, 1)
						If Ch1 = Chr(13) Then
							OutText &= WrLine & Chr(13)
							LineCount += 1
							WrLine = ""
							If LineCount >= MaxLines Then Exit For
						ElseIf Cv.TextWidth(WrLine & Ch1) > AvailW AndAlso Len(WrLine) > 0 Then
							OutText &= WrLine & Chr(13)
							LineCount += 1
							WrLine = Ch1
							If LineCount >= MaxLines Then Exit For
						Else
							WrLine &= Ch1
						End If
					Next iCh
					If LineCount < MaxLines AndAlso Len(WrLine) > 0 Then OutText &= WrLine
					TextValue = OutText
				Else
				'Greedy word wrap into at most (CellH \ TextH) lines.
				Dim As String WrLine = "", WrWord = ""
				Dim As Long LineCount = 0
				Dim iCh As Long
				For iCh = 1 To Len(TextValue) + 1
					Dim As String Ch1 = Mid(TextValue, iCh, 1)
					If Ch1 = " " OrElse iCh > Len(TextValue) Then
						Dim As String Candidate = WrLine
						If Len(WrLine) = 0 Then Candidate = WrWord Else Candidate = WrLine & " " & WrWord
						If Cv.TextWidth(Candidate) > AvailW AndAlso Len(WrLine) > 0 Then
							OutText &= WrLine & Chr(13)
							LineCount += 1
							If LineCount >= MaxLines Then Exit For
							WrLine = WrWord
						Else
							WrLine = Candidate
						End If
						WrWord = ""
					Else
						WrWord &= Ch1
					End If
				Next iCh
				If LineCount < MaxLines AndAlso Len(WrLine) > 0 Then OutText &= WrLine
				TextValue = OutText
				End If
			End If
			TextW = Cv.TextWidth(TextValue)
			Select Case AlignIdx
				Case FlexAlignmentCenterTop, FlexAlignmentCenterCenter, FlexAlignmentCenterBottom, FlexAlignmentGeneral, FlexAlignmentGeneralTop, FlexAlignmentGeneralCenter, FlexAlignmentGeneralBottom
					Tx = RCLeft + IndentL + Max(3, (AvailW - TextW) \ 2 + 3)
				Case FlexAlignmentRightTop, FlexAlignmentRightCenter, FlexAlignmentRightBottom
					Tx = RCRight - IndentR - TextW - 4
				Case Else
					Tx = RCLeft + IndentL + 3
			End Select
			Dim As Long Ty = RCTop + ((CellH - TextH) \ 2)
			'Multi-line output line by line.
			Dim As Boolean AlignBottom = CBool(AlignIdx = FlexAlignmentLeftBottom OrElse AlignIdx = FlexAlignmentCenterBottom OrElse AlignIdx = FlexAlignmentRightBottom OrElse AlignIdx = FlexAlignmentGeneralBottom)
			Dim As Boolean AlignTop = CBool(AlignIdx = FlexAlignmentLeftTop OrElse AlignIdx = FlexAlignmentCenterTop OrElse AlignIdx = FlexAlignmentRightTop OrElse AlignIdx = FlexAlignmentGeneralTop)
			If AlignBottom Then Ty = RCBottom - TextH - 2
			If AlignTop Then Ty = RCTop + 2
			If InStr(TextValue, Chr(13)) > 0 Then
				'Multi-line: start from top and step by line height.
				Dim As Long LineY = RCTop + 2
				Dim As Long SegStart = 1, SegPos
				Do
					Dim As UString Seg = Mid(TextValue, SegStart)
					SegPos = InStr(Seg, Chr(13))
					Dim As UString OneLine
					If SegPos > 0 Then OneLine = Mid(Seg, 1, SegPos - 1) Else OneLine = Seg
					Dim As Long OneW = Cv.TextWidth(OneLine)
					Dim As Long OneX = Tx
					Select Case AlignIdx
						Case FlexAlignmentCenterTop, FlexAlignmentCenterCenter, FlexAlignmentCenterBottom
							OneX = RCLeft + IndentL + Max(3, (AvailW - OneW) \ 2 + 3)
						Case FlexAlignmentRightTop, FlexAlignmentRightCenter, FlexAlignmentRightBottom
							OneX = RCRight - IndentR - OneW - 4
					End Select
					Cv.TextOut(OneX, LineY, OneLine, ForeColorValue, -1)
					LineY += TextH
					If SegPos = 0 Then Exit Do
					SegStart += SegPos
				Loop
			Else
				Cv.TextOut(Tx, Ty, TextValue, ForeColorValue, -1)
			End If
			If NeedFont Then
				Cv.Font.Name = SavedName
				Cv.Font.Size = SavedSize
				Cv.Font.Bold = SavedBold
				Cv.Font.Italic = SavedItalic
				Cv.Font.Underline = SavedUnderline
				Cv.Font.StrikeOut = SavedStrikeOut
			End If
		End If

		'Bookmark ribbon in the row header cell of bookmarked rows (on top of text).
		If (aRow >= 0) AndAlso (aRow <= FRows - 1) AndAlso (aRow >= FFixedRows) Then
			If (RowsArr(aRow).State And FLEX_RWIS_BOOKMARK) <> 0 Then
				If (aCol < FFixedCols) OrElse ((FFixedCols = 0) AndAlso (aCol = 0)) Then
					Dim As Long MarkClr = FInsertMarkColor
					If MarkClr < 0 Then MarkClr = &H0000A5FF 'orange (COLORREF BGR)
					Dim As Long MarkW = LogicalToPxX(7)
					Dim As Long MarkH = (RCBottom - RCTop) * 6 \ 10
					If MarkH < 8 Then MarkH = Min(8, RCBottom - RCTop - 2)
					Dim As Long MarkX = RCRight - MarkW - 4
					If FFixedCols = 0 Then MarkX = RCLeft + 3
					Dim As Long MarkY = RCTop + ((RCBottom - RCTop) - MarkH) \ 2
					DrawBookmarkMark(Cv, MarkX, MarkY, MarkW, MarkH, FlexWinColor(MarkClr))
				End If
			End If
		End If
	End Sub

	'===
	'=== Message processing ===

	'=== The input of every platform (called by ProcessMessage: WM_* of Windows,
	'GdkEvent of GTK, CM_* of the Web and Android) ===

	Sub GridDataEx.GridMouseDown(ByVal Button As Integer, ByVal X As Long, ByVal Y As Long, ByVal ShiftState As Integer)
		If Button = 2 Then
			'Reader mode: middle-button panning.
			If FAllowReaderMode Then
				FReaderPanning = True
				FReaderLastX = X
				FReaderLastY = Y
				GridCapture(True)
			End If
			Exit Sub
			Exit Sub
		End If
		If Button <> 0 Then Exit Sub
		Dim As Boolean CancelFlag = False
		If OnBeforeMouseDown Then OnBeforeMouseDown(*Designer, This, 0, ShiftState, X, Y, CancelFlag)
		If CancelFlag Then
			Exit Sub
		End If
		If FComboDropped Then CloseDropDown(False)
		SetFocus
		UpdateHitTest(X, Y)
		'Divider drag has priority over cell selection.
		Dim As Long DragColIdx = HitColDividerPx(X, Y)
		Dim As Long DragRowIdx = -1
		If DragColIdx < 0 Then DragRowIdx = HitRowDividerPx(X, Y)
		If DragColIdx >= 0 Then
			Dim As Boolean CancelResize = False
			If OnBeforeUserResize Then OnBeforeUserResize(*Designer, This, -1, DragColIdx, CancelResize)
			If CancelResize Then
				Exit Sub
			End If
			FDragMode = 1
			FDragIndex = DragColIdx
			FDragStartPos = X
			FDragStartSize = ColWidth(DragColIdx)
			GridCapture(True)
			Exit Sub
		ElseIf DragRowIdx >= 0 Then
			Dim As Boolean CancelResize2 = False
			If OnBeforeUserResize Then OnBeforeUserResize(*Designer, This, DragRowIdx, -1, CancelResize2)
			If CancelResize2 Then
				Exit Sub
			End If
			FDragMode = 2
			FDragIndex = DragRowIdx
			FDragStartPos = Y
			FDragStartSize = RowHeight(DragRowIdx)
			GridCapture(True)
			Exit Sub
		End If
		'Cell button click: move onto the cell and raise the event.
		If FHitResult = FlexHitResultCellButton Then
			If FInEdit Then CommitEdit
			If FFilterEditActive Then ApplyFilterEdit
			Row = FHitRow
			Col = FHitCol
			If OnCellButtonClick Then OnCellButtonClick(*Designer, This, FHitRow, FHitCol)
			Exit Sub
		End If
		'Filter bar band click: edit that column's filter criteria in place.
		If FHitResult = FlexHitResultFilterCell Then
			If FInEdit Then CommitEdit
			If FFilterEditActive Then ApplyFilterEdit
			StartFilterEdit(FHitCol)
			Exit Sub
		End If
		Dim As Long HitRowL = FHitRow
		Dim As Long HitColL = FHitCol
		If HitRowL < 0 OrElse HitColL < 0 Then
			Exit Sub
		End If
		'Checkbox click toggles the check state.
		If FHitResult = FlexHitResultCheckBox AndAlso CheckBoxesActive(HitRowL, HitColL) Then
			If HitRowL >= FFixedRows Then
				If FInEdit Then CommitEdit
				Row = HitRowL
				Col = HitColL
			End If
			Dim As Boolean CancelCheck = False
			If OnCellBeforeCheck Then OnCellBeforeCheck(*Designer, This, HitRowL, HitColL, FlexCellCheckReasonMouse, CancelCheck)
			If CancelCheck = False Then
				Dim As Integer NewState = FlexChecked
				If EffectiveChecked(HitRowL, HitColL) = FlexChecked Then NewState = FlexUnchecked
				Dim As FlexCellFormat Ptr F = EnsureFmtg(HitRowL, HitColL)
				If F <> 0 Then F->Checked = NewState
				If OnCellCheck Then OnCellCheck(*Designer, This, HitRowL, HitColL)
				If FRedraw Then RepaintGrid
			End If
			Exit Sub
		End If
		'Combo cue click opens the cell editor.
		If FHitResult = FlexHitResultComboCue Then
			If HitRowL >= FFixedRows Then
				If FAllowUserEditing = False AndAlso FAlwaysAllowComboCues Then
					'Not editable, but cues stay clickable for custom handling.
					If OnComboCueClick Then OnComboCueClick(*Designer, This, HitRowL, HitColL, FlexEditReasonComboCueClick)
				Else
					If FInEdit Then CommitEdit
					Row = HitRowL
					Col = HitColL
					If OnComboCueClick Then OnComboCueClick(*Designer, This, HitRowL, HitColL, FlexEditReasonComboCueClick)
					FEditReason = FlexEditReasonComboCueClick
					StartEdit(HitRowL, HitColL)
				End If
			End If
			Exit Sub
		End If
		If FInEdit Then CommitEdit
		'Clicking outside the band commits a running filter edit.
		If FFilterEditActive Then ApplyFilterEdit
		'Header click sort (SortOnClick): clicking a fixed-row header cell
		'sorts that column, toggling the direction on repeat clicks. The
		'fixed-column corner keeps its big-selection behavior.
		If FSortOnClick AndAlso HitRowL >= 0 AndAlso HitRowL < FFixedRows AndAlso HitColL >= FFixedCols Then
			Dim As Long ClickCol = HitColL
			If FSortClickCol = ClickCol Then
				FSortClickDesc = Not FSortClickDesc
			Else
				FSortClickCol = ClickCol
				FSortClickDesc = False
			End If
			'Auto mode: numeric sort when every non-empty value is numeric.
			Dim As Boolean AllNum = True, AnyVal = False
			For kSort As Long = FFixedRows To FRows - 1
				Dim As UString SV = TextMatrix(kSort, ClickCol)
				If Len(Trim(SV)) > 0 Then
					AnyVal = True
					If IsNumericText(SV) = False Then
						AllNum = False
						Exit For
					End If
				End If
			Next kSort
			Dim As Integer SortKind
			If AllNum AndAlso AnyVal Then
				SortKind = IIf(FSortClickDesc, FlexSortNumericDescending, FlexSortNumericAscending)
			Else
				SortKind = IIf(FSortClickDesc, FlexSortStringNoCaseDescending, FlexSortStringNoCaseAscending)
			End If
			For kSort As Long = 0 To FCols - 1
				ColSortArrow(kSort) = FlexSortArrowNone
			Next kSort
			ColSortArrow(ClickCol) = IIf(FSortClickDesc, FlexSortArrowDescending, FlexSortArrowAscending)
			Sort(ClickCol, SortKind)
			If OnClick_ Then OnClick_(*Designer, This, HitRowL, HitColL)
			If OnCellClick Then OnCellClick(*Designer, This, HitRowL, HitColL, 0)
			Exit Sub
		End If
		'Fixed area big selection: click a fixed row/col to select the whole row/col.
		If FAllowBigSelection AndAlso FAllowSelection Then
			If HitRowL < FFixedRows AndAlso HitRowL >= 0 Then
				Row = HitRowL
				Col = FFixedCols
				FRowSel = HitRowL
				FColSel = FCols - 1
				If OnSelChange Then OnSelChange(*Designer, This)
				If FRedraw AndAlso Handle <> 0 Then RepaintGrid
				If OnClick_ Then OnClick_(*Designer, This, HitRowL, HitColL)
				If OnCellClick Then OnCellClick(*Designer, This, HitRowL, HitColL, 0)
				Exit Sub
			ElseIf HitColL < FFixedCols AndAlso HitColL >= 0 Then
				Row = FFixedRows
				Col = HitColL
				FRowSel = FRows - 1
				FColSel = HitColL
				If OnSelChange Then OnSelChange(*Designer, This)
				If FRedraw AndAlso Handle <> 0 Then RepaintGrid
				If OnClick_ Then OnClick_(*Designer, This, HitRowL, HitColL)
				If OnCellClick Then OnCellClick(*Designer, This, HitRowL, HitColL, 0)
				Exit Sub
			End If
		End If
		If HitRowL >= FFixedRows AndAlso HitRowL >= 0 AndAlso HitColL >= 0 Then
			Dim As Boolean CtrlHeld = CBool((ShiftState And FLEX_CTRL_MASK) = FLEX_CTRL_MASK)
			Dim As Boolean ShiftHeld = CBool((ShiftState And FLEX_SHIFT_MASK) = FLEX_SHIFT_MASK)
			If CtrlHeld AndAlso FAllowMultiSelection Then
				'Toggle a non-contiguous row mark.
				RowSelected(HitRowL) = Not RowSelected(HitRowL)
			ElseIf ShiftHeld AndAlso FAllowSelection Then
				'Extend the selection rectangle from the current cell.
				FRowSel = HitRowL
				FColSel = HitColL
				If OnSelChange Then OnSelChange(*Designer, This)
			Else
				If FAllowMultiSelection = False Then
					Dim iClear As Long
					For iClear = 0 To FRows - 1
						RowsArr(iClear).State And= Not FLEX_RWIS_SELECTED
					Next iClear
				End If
				Row = HitRowL
				Col = HitColL
			End If
			If OnClick_ Then OnClick_(*Designer, This, HitRowL, HitColL)
			If OnCellClick Then OnCellClick(*Designer, This, HitRowL, HitColL, 0)
		End If
		Exit Sub
	End Sub

	Function GridDataEx.GridMouseMove(ByVal X As Long, ByVal Y As Long) As Boolean
		If FReaderPanning Then
			'Middle-button panning: scroll by whole rows/columns moved.
			Dim As Long dPx = FReaderLastX - X, dPy = FReaderLastY - Y
			FReaderLastX = X : FReaderLastY = Y
			Dim As Long RH = Max(1, GetDefaultRowHeightPx()), CWp = Max(1, GetDefaultColWidthPx())
			If Abs(dPy) >= RH Then TopRow = Max(FFixedRows + FFrozenRows, Min(FRows - 1, TopRow + Sgn(dPy) * (Abs(dPy) \ RH)))
			If Abs(dPx) >= CWp Then LeftCol = Max(FFixedCols + FFrozenCols, Min(FCols - 1, LeftCol + Sgn(dPx) * (Abs(dPx) \ CWp)))
			Return True
		End If
		UpdateHitTest(X, Y)
		If FDragMode = 1 Then
			'Dragging a column divider: convert pixel delta back to twips.
			Dim As Long DeltaTw = CInt((X - FDragStartPos) * TwipsPerPixelX())
			Dim As Long NewW = Max(240, FDragStartSize + DeltaTw)
			If FColWidthMax > 0 AndAlso NewW > FColWidthMax Then NewW = FColWidthMax
			If NewW <> ColWidth(FDragIndex) Then ColWidth(FDragIndex) = NewW
			Return True
		ElseIf FDragMode = 2 Then
			Dim As Long DeltaTwY = CInt((Y - FDragStartPos) * TwipsPerPixelY())
			Dim As Long NewH = Max(120, FDragStartSize + DeltaTwY)
			If FRowHeightMax > 0 AndAlso NewH > FRowHeightMax Then NewH = FRowHeightMax
			If NewH <> RowHeight(FDragIndex) Then RowHeight(FDragIndex) = NewH
			Return True
		Else
			'Hover feedback: change cursor over dividers.
			Dim As Long HovCol = HitColDividerPx(X, Y)
			Dim As Long HovRow = -1
			If HovCol < 0 Then HovRow = HitRowDividerPx(X, Y)
			If HovCol >= 0 Then
				SetGridCursor(1)
			ElseIf HovRow >= 0 Then
				SetGridCursor(2)
			ElseIf FMouseTrack AndAlso CBool(FHitResult = FlexHitResultCell OrElse FHitResult = FlexHitResultCellButton) Then
				'Hot-track: hand cursor over interactive cell parts.
				If FHitResult = FlexHitResultCellButton OrElse CheckBoxesActive(FHitRow, FHitCol) OrElse ColsArr(FHitCol).ComboCue >= FlexComboCueDropDown Then
					SetGridCursor(3)
				End If
			End If
		End If
		Return False
	End Function

	Function GridDataEx.GridMouseUp(ByVal Button As Integer, ByVal X As Long, ByVal Y As Long) As Boolean
		If Button = 2 Then
			If FReaderPanning Then
				FReaderPanning = False
				GridCapture(False)
			End If
			Return True
			Return False
		End If
		If Button <> 0 Then Return False
		CancelScrollTip
		If FDragMode = 1 Then
			Dim As Long ResizedCol = FDragIndex
			FDragMode = 0
			FDragIndex = -1
			GridCapture(False)
			If OnAfterUserResize Then OnAfterUserResize(*Designer, This, -1, ResizedCol, ColWidth(ResizedCol))
			Return True
		ElseIf FDragMode = 2 Then
			Dim As Long ResizedRow = FDragIndex
			FDragMode = 0
			FDragIndex = -1
			GridCapture(False)
			If OnAfterUserResize Then OnAfterUserResize(*Designer, This, ResizedRow, -1, RowHeight(ResizedRow))
			Return True
		End If
		Return False
	End Function

	Sub GridDataEx.GridDblClick(ByVal X As Long, ByVal Y As Long)
		UpdateHitTest(X, Y)
		'Divider double click: auto fit.
		Dim As Long DbColIdx = HitColDividerPx(X, Y)
		Dim As Long DbRowIdx = -1
		If DbColIdx < 0 Then DbRowIdx = HitRowDividerPx(X, Y)
		If DbColIdx >= 0 Then
			If OnDividerDblClick Then OnDividerDblClick(*Designer, This, -1, DbColIdx)
			AutoSizeCol(DbColIdx, CBool(DbColIdx < FFixedCols))
			If OnAfterUserResize Then OnAfterUserResize(*Designer, This, -1, DbColIdx, -1)
			Exit Sub
		ElseIf DbRowIdx >= 0 Then
			If OnDividerDblClick Then OnDividerDblClick(*Designer, This, DbRowIdx, -1)
			AutoSize(DbRowIdx, DbRowIdx, FlexAutoSizeModeRowHeight, FlexAutoSizeScopeAll, False, 0)
			If OnAfterUserResize Then OnAfterUserResize(*Designer, This, DbRowIdx, -1, -1)
			Exit Sub
		End If
		Dim As Long HR = FHitRow, HC = FHitCol
		If HR >= 0 AndAlso HC >= 0 Then
			If OnDblClick_ Then OnDblClick_(*Designer, This, HR, HC)
			If OnCellDblClick Then OnCellDblClick(*Designer, This, HR, HC, 0)
			If FAllowUserEditing Then
				FEditReason = FlexEditReasonDblClick
				StartEdit(HR, HC)
			End If
		End If
		Exit Sub
	End Sub

	Sub GridDataEx.GridWheel(ByVal Delta As Long, ByVal ShiftState As Integer, ByVal Horizontal As Boolean)
		If Horizontal Then
			'The tilt wheel scrolls horizontally (Delta > 0: right).
			Dim As Long HLines = FWheelScrollLines
			If HLines < 1 Then HLines = 3
			If Delta < 0 Then
				LeftCol = Max(FFixedCols + FFrozenCols, LeftCol - HLines)
			Else
				LeftCol = min(LeftCol + HLines, FCols - 1)
			End If
			Exit Sub
			Exit Sub
		End If
		'Ctrl+wheel zooms the view instead of scrolling.
		If (ShiftState And FLEX_CTRL_MASK) = FLEX_CTRL_MASK Then
			Zoom = Zoom + IIf(Delta > 0, 0.1, -0.1)
			Exit Sub
		End If
		Dim As Long Lines = FWheelScrollLines
		If Lines < 1 Then Lines = 3
		If Delta < 0 Then
			TopRow = min(TopRow + Lines, FRows - 1)
		Else
			TopRow = Max(FFixedRows + FFrozenRows, TopRow - Lines)
		End If
		Exit Sub
	End Sub

	Function GridDataEx.GridKeyDown(ByVal KeyCode As Integer, ByVal ShiftState As Integer) As Boolean
		If FInEdit Then Return False
		'VB6 semantics: the KeyDown event can set KeyCode = 0 to suppress the default action.
		If OnKeyDown Then OnKeyDown(*Designer, This, KeyCode, ShiftState)
		If KeyCode = 0 Then
			Return True
		End If
		Select Case KeyCode
			Case VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT
				If (ShiftState And FLEX_SHIFT_MASK) = FLEX_SHIFT_MASK AndAlso FAllowSelection Then
					'Extend the selection.
					Select Case KeyCode
						Case VK_UP : If FRowSel > FFixedRows Then FRowSel -= 1
						Case VK_DOWN : If FRowSel < FRows - 1 Then FRowSel += 1
						Case VK_LEFT : If FColSel > FFixedCols Then FColSel -= 1
						Case VK_RIGHT : If FColSel < FCols - 1 Then FColSel += 1
					End Select
					If OnSelChange Then OnSelChange(*Designer, This)
				ElseIf (ShiftState And FLEX_CTRL_MASK) = FLEX_CTRL_MASK Then
					'Jump to the data region edges.
					Select Case KeyCode
						Case VK_UP : Row = FFixedRows
						Case VK_DOWN : Row = FRows - 1
						Case VK_LEFT : Col = FFixedCols
						Case VK_RIGHT : Col = FCols - 1
					End Select
				Else
					Select Case KeyCode
						Case VK_UP
							'Skip over hidden rows (filtered out).
							Dim As Long NRUp = Row - 1
							Do While (NRUp > FFixedRows) AndAlso ((RowsArr(NRUp).State And FLEX_RWIS_HIDDEN) <> 0)
								NRUp -= 1
							Loop
							If (NRUp >= FFixedRows) AndAlso ((RowsArr(NRUp).State And FLEX_RWIS_HIDDEN) = 0) Then Row = NRUp
						Case VK_DOWN
							Dim As Long NRDown = Row + 1
							Do While (NRDown < FRows - 1) AndAlso ((RowsArr(NRDown).State And FLEX_RWIS_HIDDEN) <> 0)
								NRDown += 1
							Loop
							If (NRDown <= FRows - 1) AndAlso ((RowsArr(NRDown).State And FLEX_RWIS_HIDDEN) = 0) Then Row = NRDown
						Case VK_LEFT : If Col > FFixedCols Then Col = Col - 1
						Case VK_RIGHT : If Col < FCols - 1 Then Col = Col + 1
					End Select
				End If
			Case VK_HOME
				If (ShiftState And FLEX_CTRL_MASK) = FLEX_CTRL_MASK Then
					Row = FFixedRows
					Col = FFixedCols
				Else
					Col = FFixedCols
				End If
			Case VK_END
				If (ShiftState And FLEX_CTRL_MASK) = FLEX_CTRL_MASK Then
					Row = FRows - 1
					Col = FCols - 1
				Else
					Col = FCols - 1
				End If
			Case VK_PRIOR
				Row = Max(FFixedRows, Row - RowsPerPage())
			Case VK_NEXT
				Row = Min(Row + RowsPerPage(), FRows - 1)
			Case VK_TAB
				If FTabBehavior = FlexTabCells Then
					Dim As Integer ShiftState2 = ShiftState
					If (ShiftState2 And FLEX_SHIFT_MASK) = FLEX_SHIFT_MASK Then
						If Col > FFixedCols Then
							Col = Col - 1
						ElseIf FWrapCellBehavior <> FlexWrapNone AndAlso Row > FFixedRows Then
							Row = Row - 1
							Col = FCols - 1
						End If
					Else
						If Col < FCols - 1 Then
							Col = Col + 1
						ElseIf FWrapCellBehavior <> FlexWrapNone AndAlso Row < FRows - 1 Then
							Row = Row + 1
							Col = FFixedCols
						End If
					End If
				Else
					Exit Select
				End If
			Case VK_RETURN
				If FAllowUserEditing AndAlso FDirectionAfterReturn = FlexDirectionAfterReturnEdit Then
					FEditReason = FlexEditReasonReturn
					StartEdit
				Else
					If OnDblClick_ Then OnDblClick_(*Designer, This, FRow, FCol)
				End If
			Case VK_F2
				If FAllowUserEditing Then
					FEditReason = FlexEditReasonF2
					StartEdit
				End If
			Case VK_F4
				If FAllowUserEditing AndAlso ColsArr(FCol).ComboMode <> FlexComboModeNone Then
					FEditReason = FlexEditReasonComboCueF4
					StartEdit
				End If
			Case VK_SPACE
				If CheckBoxesActive(FRow, FCol) Then
					Dim As Boolean CancelCheck = False
					If OnCellBeforeCheck Then OnCellBeforeCheck(*Designer, This, FRow, FCol, FlexCellCheckReasonKeyboard, CancelCheck)
					If CancelCheck = False Then
						Dim As Integer NewState = FlexChecked
						If EffectiveChecked(FRow, FCol) = FlexChecked Then NewState = FlexUnchecked
						Dim As FlexCellFormat Ptr F = EnsureFmtg(FRow, FCol)
						If F <> 0 Then F->Checked = NewState
						If OnCellCheck Then OnCellCheck(*Designer, This, FRow, FCol)
						If FRedraw Then RepaintGrid
					End If
				ElseIf FAllowUserEditing Then
					FEditReason = FlexEditReasonSpace
					StartEdit
				End If
			Case Else
				Exit Select
		End Select
		Return True
		Return False
	End Function

	Sub GridDataEx.GridKeyPress(ByVal KeyChar As Integer)
		If FInEdit = False Then
			If OnKeyPress Then OnKeyPress(*Designer, This, KeyChar)
			If KeyChar = 0 Then
				Exit Sub
			End If
			If FAllowIncrementalSearch AndAlso KeyChar >= 32 Then
				IncrementalSearchAdvance(KeyChar)
			ElseIf FAllowUserEditing AndAlso KeyChar >= 32 Then
				'Typing starts an edit session seeded with the pressed character.
				'(Combo/calendar/calculator cells open their drop-down instead.)
				FEditReason = FlexEditReasonKeyPress
				If StartEdit Then
					If (FEditCol < 0) OrElse (FEditCol > FCols - 1) OrElse (ColsArr(FEditCol).ComboMode = FlexComboModeNone) Then
						EditText_->Text = Chr(KeyChar)
						EditText_->SetSel(1, 1)
					End If
					FEditChanged = True
				End If
			End If
		End If
	End Sub

	Sub GridDataEx.GridKeyUp(ByVal KeyCode As Integer, ByVal ShiftState As Integer)
		If OnKeyUp Then OnKeyUp(*Designer, This, KeyCode, ShiftState)
	End Sub

	Sub GridDataEx.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_WINAPI__
		Select Case Message.Msg
			Case WM_PAINT
				'The scheme was chosen before the window existed; apply the
				'matching scrollbar theme once the HWND is there.
				#ifdef __USE_WINAPI__
					If FScrollBarThemeDark = -1 AndAlso Handle <> 0 Then
						ApplyScrollBarTheme(g_darkModeEnabled)
					End If
				#endif
				'Flush deferred scroll bar state before painting.
				If FScrollBarsDirty Then SetScrollBarsInternal
				Dim As PAINTSTRUCT PS
				Dim As HDC Dc = BeginPaint(Handle, @PS)
				Dim As Long ClientW = ClientWidthPx()
				Dim As Long ClientH = ClientHeightPx()
				If FDoubleBuffer Then
					'Draw into the off-screen buffer, then blit once: no
					'intermediate states hit the screen, so no flicker.
					EnsureMemSurface(Dc, ClientW, ClientH)
					If FMemDc <> 0 Then
						Canvas.SetHandle(Cast(HDC, FMemDc))
						UsePhysicalCanvas
						DrawGridArea(Canvas, 0, 0, ClientW, ClientH)
						Canvas.UnSetHandle
						BitBlt(Dc, PS.rcPaint.Left, PS.rcPaint.Top, _
						       PS.rcPaint.Right - PS.rcPaint.Left + 1, _
						       PS.rcPaint.Bottom - PS.rcPaint.Top + 1, _
						       Cast(HDC, FMemDc), PS.rcPaint.Left, PS.rcPaint.Top, SRCCOPY)
					Else
						Canvas.SetHandle(Dc)
						UsePhysicalCanvas
						DrawGridArea(Canvas, 0, 0, ClientW, ClientH)
						Canvas.UnSetHandle
					End If
				Else
					Canvas.SetHandle(Dc)
					UsePhysicalCanvas
					DrawGridArea(Canvas, 0, 0, ClientW, ClientH)
					Canvas.UnSetHandle
				End If
				EndPaint(Handle, @PS)
				Message.Result = 0
				Return
			Case WM_ERASEBKGND
				Message.Result = 1
				Return
			Case WM_GETDLGCODE
				'Ask for arrows/chars (and Tab in TabCells mode) so keys reach the grid.
				Dim As Long Code = DLGC_WANTARROWS Or DLGC_WANTCHARS
				If FTabBehavior = FlexTabCells Then Code Or= DLGC_WANTTAB
				Message.Result = Code
				Return
			Case WM_DPICHANGED
				'Runtime cross-monitor move (PerMonitorV2): the twips->pixel
				'ratio changes with the DPI, so every cached row/column pixel
				'offset is stale now. Adopt the new factors (the Form already
				'set them for forwarded messages; reading wParam again is
				'idempotent), let the base class rescale the window, font and
				'child controls, then rebuild the geometry and resync the
				'in-place editor so it stays glued to its cell.
				Dim As Single NewX = Message.wParamLo / 96
				Dim As Single NewY = Message.wParamHi / 96
				If NewX > 0 AndAlso NewY > 0 AndAlso (NewX <> xdpi OrElse NewY <> ydpi) Then
					xdpi = NewX
					ydpi = NewY
				End If
				Canvas.xdpi = xdpi
				Canvas.ydpi = ydpi
				Font.xdpi = xdpi
				Font.ydpi = ydpi
				Font.Size = Font.Size
				Base.ProcessMessage(Message)
				InvalidateRowGeometry
				InvalidateColGeometry
				FScrollBarsDirty = True
				EnsureVisibleCell(FRow, FCol)
				'Popups were placed with the old pixel geometry: close them
				'(the edit session itself stays alive and realigns below).
				If FComboDropped Then CloseDropDown(False)
				If FInEdit Then PositionEditBox
				SetScrollBarsInternal
				If Handle <> 0 Then RepaintGrid
				Message.Result = 0
				Return
			Case WM_SIZE
				SetScrollBarsInternal
				PositionEditBox
			Case WM_VSCROLL
				If FComboDropped Then
					CloseDropDown(False)
					If FInEdit Then CommitEditInternal(FlexEditCloseModeLostFocus)
				End If
				Dim As Long Cmd = LoWord(Message.wParam)
				Select Case Cmd
					Case SB_LINEDOWN : If FTopRow < FRows - 1 Then TopRow = TopRow + 1
					Case SB_LINEUP : If TopRow > FFixedRows + FFrozenRows Then TopRow = TopRow - 1
					Case SB_PAGEDOWN : TopRow = Min(TopRow + RowsPerPage(), FRows - 1)
					Case SB_PAGEUP : TopRow = Max(FFixedRows + FFrozenRows, TopRow - RowsPerPage())
					Case SB_THUMBTRACK, SB_THUMBPOSITION
						If Cmd = SB_THUMBTRACK AndAlso FShowScrollTips Then UpdateScrollTip(SB_VERT, HiWord(Message.wParam))
						TopRow = HiWord(Message.wParam)
				End Select
				If Cmd <> SB_THUMBTRACK Then CancelScrollTip
				Message.Result = 0
				Return
			Case WM_HSCROLL
				If FComboDropped Then
					CloseDropDown(False)
					If FInEdit Then CommitEditInternal(FlexEditCloseModeLostFocus)
				End If
				Dim As Long Cmd = LoWord(Message.wParam)
				Select Case Cmd
					Case SB_LINERIGHT : If FLeftCol < FCols - 1 Then Debug.Print "HSCROLL LINERIGHT from " & FLeftCol : LeftCol = LeftCol + 1 : Debug.Print "HSCROLL LINERIGHT to " & FLeftCol
					Case SB_LINELEFT : If LeftCol > FFixedCols + FFrozenCols Then LeftCol = LeftCol - 1
					Case SB_PAGERIGHT : LeftCol = min(LeftCol + ColsPerPage(), FCols - 1)
					Case SB_PAGELEFT : LeftCol = Max(FFixedCols + FFrozenCols, LeftCol - ColsPerPage())
					Case SB_THUMBTRACK, SB_THUMBPOSITION
						If Cmd = SB_THUMBTRACK AndAlso FShowScrollTips Then UpdateScrollTip(SB_HORZ, HiWord(Message.wParam))
						LeftCol = HiWord(Message.wParam)
				End Select
				If Cmd <> SB_THUMBTRACK Then CancelScrollTip
				Message.Result = 0
				Return
			Case &H20E 'WM_MOUSEHWHEEL: tilt wheel scrolls horizontally.
				GridWheel(IIf(GET_WHEEL_DELTA_WPARAM(Message.wParam) < 0, -1, 1), FlexGetShiftStateFromMsg(), True)
				Message.Result = 0
				Return
			Case WM_DROPFILES '&H233: files dropped onto the grid.
				If FAllowDropFiles AndAlso Message.wParam <> 0 Then
					Dim As HDROP hd = Cast(HDROP, Message.wParam)
					Dim As Long FCnt = DragQueryFileW(hd, &HFFFFFFFF, NULL, 0)
					If FCnt > 0 Then
						Dim As WString Ptr ListTxt = 0
						Dim As Integer Capacity
						For df As Long = 0 To FCnt - 1
							Dim As WString * 520 FileBuf
							DragQueryFileW(hd, df, @FileBuf, 520)
							If df > 0 Then WAdd(ListTxt, Chr(13) & Chr(10))
							WAdd(ListTxt, FileBuf, , Capacity)
						Next df
						If OnDropFiles AndAlso ListTxt <> 0 Then OnDropFiles(*Designer, This, *ListTxt)
						WDeAllocate(ListTxt)
					End If
					DragFinish(hd)
				End If
				Message.Result = 0
				Return
			Case WM_MBUTTONDOWN 'reader mode: middle-button panning.
				GridMouseDown(2, GET_X_LPARAM(Message.lParam), GET_Y_LPARAM(Message.lParam), FlexGetShiftStateFromMsg())
				Message.Result = 0
				Return
			Case WM_MBUTTONUP
				GridMouseUp(2, GET_X_LPARAM(Message.lParam), GET_Y_LPARAM(Message.lParam))
				Message.Result = 0
				Return
			Case WM_MOUSEWHEEL
				GridWheel(IIf(GET_WHEEL_DELTA_WPARAM(Message.wParam) < 0, -1, 1), FlexGetShiftStateFromMsg(), False)
				Message.Result = 0
				Return
			Case WM_LBUTTONDOWN
				GridMouseDown(0, GET_X_LPARAM(Message.lParam), GET_Y_LPARAM(Message.lParam), FlexGetShiftStateFromMsg())
				Message.Result = 0
				Return
			Case WM_MOUSEMOVE
				If GridMouseMove(GET_X_LPARAM(Message.lParam), GET_Y_LPARAM(Message.lParam)) Then
					Message.Result = 0
					Return
				End If
			Case WM_LBUTTONUP
				If GridMouseUp(0, GET_X_LPARAM(Message.lParam), GET_Y_LPARAM(Message.lParam)) Then
					Message.Result = 0
					Return
				End If
			Case WM_LBUTTONDBLCLK
				GridDblClick(GET_X_LPARAM(Message.lParam), GET_Y_LPARAM(Message.lParam))
				Message.Result = 0
				Return
			Case WM_KEYDOWN
				If GridKeyDown(CInt(Message.wParam), FlexGetShiftStateFromMsg()) Then
					Message.Result = 0
					Return
				End If
			Case WM_CHAR
				If FInEdit = False Then GridKeyPress(CInt(Message.wParam))
			Case WM_KEYUP
				GridKeyUp(CInt(Message.wParam), FlexGetShiftStateFromMsg())
			Case WM_SETFOCUS
				RepaintGrid
			Case WM_KILLFOCUS
				RepaintGrid
		End Select
		#elseif defined(__USE_GTK__)
		'The events of the layout (Chart does the same): the points are in the units of GTK
		Dim As GdkEvent Ptr e = Message.Event
		If e <> 0 Then
			#ifdef __USE_GTK4__
				Dim As gdouble ex, ey
				gtk4compat_event_get_widget_position(widget, e, @ex, @ey)
				Dim As Integer GState = FlexGdkShift(gdk_event_get_modifier_state(e))
				Select Case gtk4compat_event_type(e)
				Case GDK_BUTTON_PRESS
					InputMouseDown(gdk_button_event_get_button(e) - 1, ex, ey, GState)
				Case GDK_2BUTTON_PRESS
					GridDblClick(ex, ey)
				Case GDK_BUTTON_RELEASE
					InputMouseUp(gdk_button_event_get_button(e) - 1, ex, ey)
				Case GDK_MOTION_NOTIFY
					InputMouseMove(ex, ey)
				Case GDK_KEY_PRESS
					If InputKeyDown(gdk_key_event_get_keyval(e), GState) Then Message.Result = True
				Case GDK_KEY_RELEASE
					GridKeyUp(FlexKeyToVK(gdk_key_event_get_keyval(e)), GState)
				Case GDK_SCROLL
					Select Case gdk_scroll_event_get_direction(e)
					Case GDK_SCROLL_UP: GridWheel(1, GState, False)
					Case GDK_SCROLL_DOWN: GridWheel(-1, GState, False)
					Case GDK_SCROLL_LEFT: GridWheel(-1, GState, True)
					Case GDK_SCROLL_RIGHT: GridWheel(1, GState, True)
					Case GDK_SCROLL_SMOOTH
						Dim As gdouble dx, dy
						gdk_scroll_event_get_deltas(e, @dx, @dy)
						If dy <> 0 Then GridWheel(-Sgn(dy), GState, False)
						If dx <> 0 Then GridWheel(Sgn(dx), GState, True)
					End Select
					Message.Result = True
				End Select
			#else
				Select Case e->type
				Case GDK_BUTTON_PRESS
					InputMouseDown(e->button.button - 1, e->button.x, e->button.y, FlexGdkShift(e->button.state))
				Case GDK_2BUTTON_PRESS
					GridDblClick(e->button.x, e->button.y)
				Case GDK_BUTTON_RELEASE
					InputMouseUp(e->button.button - 1, e->button.x, e->button.y)
				Case GDK_MOTION_NOTIFY
					InputMouseMove(e->motion.x, e->motion.y)
				Case GDK_KEY_PRESS
					If InputKeyDown(e->key.keyval, FlexGdkShift(e->key.state)) Then Message.Result = True
				Case GDK_KEY_RELEASE
					GridKeyUp(FlexKeyToVK(e->key.keyval), FlexGdkShift(e->key.state))
				Case GDK_SCROLL
					Dim As Integer GState = FlexGdkShift(e->scroll.state)
					Select Case e->scroll.direction
					Case GDK_SCROLL_UP: GridWheel(1, GState, False)
					Case GDK_SCROLL_DOWN: GridWheel(-1, GState, False)
					Case GDK_SCROLL_LEFT: GridWheel(-1, GState, True)
					Case GDK_SCROLL_RIGHT: GridWheel(1, GState, True)
					#ifndef __USE_GTK2__
					Case GDK_SCROLL_SMOOTH
						If e->scroll.delta_y <> 0 Then GridWheel(-Sgn(e->scroll.delta_y), GState, False)
						If e->scroll.delta_x <> 0 Then GridWheel(Sgn(e->scroll.delta_x), GState, True)
					#endif
					End Select
					Message.Result = True
				Case GDK_FOCUS_CHANGE
					RepaintGrid
				End Select
			#endif
		End If
		#else
		'The Web and Android: CM_* messages, the points are the pixels of the canvas
		Select Case Message.Msg
			Case CM_PAINT
				PaintOwn(Canvas)
			Case CM_MOUSEDOWN
				Dim As Long X = MffPointX(Message.lParam), Y = MffPointY(Message.lParam)
				If Message.wParam = 0 Then
					'No double click message here: the second press soon on the same place is one
					Dim As Double TimeNow = Timer
					If TimeNow - FLastDownTime < 0.5 AndAlso Abs(X - FLastDownX) <= LogicalToPxX(4) AndAlso Abs(Y - FLastDownY) <= LogicalToPxY(4) Then
						FLastDownTime = 0
						If OwnScrollBarDown(X, Y) = False Then GridDblClick(X, Y)
					Else
						FLastDownTime = TimeNow
						FLastDownX = X
						FLastDownY = Y
						InputMouseDown(0, X, Y, 0)
					End If
				Else
					InputMouseDown(Message.wParam, X, Y, 0)
				End If
			Case CM_MOUSEMOVE
				InputMouseMove(MffPointX(Message.lParam), MffPointY(Message.lParam))
			Case CM_MOUSEUP
				InputMouseUp(Message.wParam, MffPointX(Message.lParam), MffPointY(Message.lParam))
			Case CM_MOUSEWHEEL
				GridWheel(Message.wParam, 0, False)
				Message.Result = 1
			Case CM_MOUSEHWHEEL
				'wParam: 1 left, -1 right
				GridWheel(-Message.wParam, 0, True)
				Message.Result = 1
			Case CM_KEYDOWN
				If GridKeyDown(Message.wParam, Message.lParam And 7) Then Message.Result = 1
			Case CM_CHAR
				If FInEdit = False AndAlso Message.wParam >= 32 Then GridKeyPress(Message.wParam)
			Case CM_KEYUP
				GridKeyUp(Message.wParam, Message.lParam And 7)
			Case CM_SETFOCUS, CM_KILLFOCUS
				RepaintGrid
		End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub

	'=== Print preview / report engine ===

	Function GridDataEx.CollectVisRows(RowList() As Long) As Long
		Dim As Long n = 0
		ReDim RowList(0 To FRows - 1)
		For i As Long = 0 To FRows - 1
			If (RowsArr(i).State And FLEX_RWIS_HIDDEN) = 0 Then
				RowList(n) = i
				n += 1
			End If
		Next i
		Return n
	End Function

	Function GridDataEx.CollectVisCols(ColList() As Long) As Long
		Dim As Long n = 0
		ReDim ColList(0 To FCols - 1)
		For j As Long = 0 To FCols - 1
			If (ColsArr(j).State And FLEX_CLIS_HIDDEN) = 0 Then
				ColList(n) = j
				n += 1
			End If
		Next j
		Return n
	End Function

	Sub GridDataEx.BuildReportLayout(ByRef Lay As FlexReportLayout, ByVal Landscape As Boolean, ByVal XDpi As Double, ByVal YDpi As Double)
		'Pagination: the printable area (inches) comes from the target DPI;
		'the usable width keeps 0.6in margins, the height keeps margins plus
		'the header band (title + page number) on every page.
		If Landscape Then
			Lay.PageWIn = 11.69 : Lay.PageHIn = 8.27
		Else
			Lay.PageWIn = 8.27 : Lay.PageHIn = 11.69
		End If
		Dim As Double UsableW = Lay.PageWIn - 1.2
		Dim As Double UsableH = Lay.PageHIn - 1.2 - 0.35
		Dim RowList(Any) As Long, ColList(Any) As Long
		Dim As Long nR = CollectVisRows(RowList()), nC = CollectVisCols(ColList())
		If nR < 1 OrElse nC < 1 Then Exit Sub
		'Repeated header height: all visible fixed rows.
		Dim As Double HdrIn = 0
		For k As Long = 0 To nR - 1
			If RowList(k) < FFixedRows Then
				HdrIn += GetRowHeightPx(RowList(k)) / 96.0
			End If
		Next k
		UsableH -= HdrIn
		If UsableW < 1 Then UsableW = 1
		If UsableH < 1 Then UsableH = 1
		'Fit-to-width: squeeze every visible column onto one page instead of
		'splitting into column groups (ColScale shrinks each column).
		Lay.ColScale = 1.0
		If FReportFitWidth Then
			Dim As Double TotalW = 0
			For k As Long = 0 To nC - 1
				Dim As Double wj0 = GetColWidthPx(ColList(k)) / 96.0
				If wj0 < 0.2 Then wj0 = 0.2
				TotalW += wj0
			Next k
			If TotalW > UsableW AndAlso TotalW > 0 Then Lay.ColScale = UsableW / TotalW
			ReDim Lay.ColStart(0 To 0)
			Lay.ColStart(0) = 0
			Lay.ColPages = 1
		Else
		'Column groups.
		Dim As Long cPages = 0
		ReDim Lay.ColStart(0 To nC)
		Dim As Double AccW = 0
		For k As Long = 0 To nC - 1
			Dim As Double wj = GetColWidthPx(ColList(k)) / 96.0
			If wj < 0.2 Then wj = 0.2
			If k = 0 OrElse AccW + wj > UsableW Then
				ReDim Preserve Lay.ColStart(0 To cPages)
				Lay.ColStart(cPages) = k
				cPages += 1
				AccW = wj
			Else
				AccW += wj
			End If
		Next k
		Lay.ColPages = cPages
		End If
		'Row groups.
		Dim As Long rPages = 0
		ReDim Lay.RowStart(0 To nR)
		Dim As Double AccH = 0
		For k As Long = 0 To nR - 1
			If RowList(k) < FFixedRows Then Continue For
			Dim As Double hj = GetRowHeightPx(RowList(k)) / 96.0
			If hj < 0.1 Then hj = 0.1
			If rPages = 0 OrElse AccH + hj > UsableH Then
				ReDim Preserve Lay.RowStart(0 To rPages)
				Lay.RowStart(rPages) = k
				rPages += 1
				AccH = hj
			Else
				AccH += hj
			End If
		Next k
		If rPages = 0 Then
			ReDim Lay.RowStart(0 To 0)
			Lay.RowStart(0) = nR
			rPages = 1
		End If
		Lay.RowPages = rPages
	End Sub

	#ifdef __USE_WINAPI__
	Sub GridDataEx.RenderReportPage(ByVal Dc As HDC, ByVal PageNo As Long, ByRef Lay As FlexReportLayout, ByRef Title As WString)
		'Draws one report page (light palette, GDI) into Dc at the DPI the
		'layout was built for. Page order: column groups outer, row pages
		'inner, like a classic printout.
		Dim RowList(Any) As Long, ColList(Any) As Long
		Dim As Long nR = CollectVisRows(RowList()), nC = CollectVisCols(ColList())
		If nR < 1 OrElse nC < 1 Then Exit Sub
		Dim As Long XDpi = GetDeviceCaps(Dc, LOGPIXELSX)
		Dim As Long YDpi = GetDeviceCaps(Dc, LOGPIXELSY)
		Dim As Double PageW = Lay.PageWIn * XDpi, PageH = Lay.PageHIn * YDpi
		Dim As Double MarginL = 0.6 * XDpi, MarginT = 0.6 * YDpi
		Dim As Double MarginR = PageW - 0.6 * XDpi
		'Background.
		Dim As Rect RC
		RC.Left = 0 : RC.Top = 0 : RC.Right = CInt(PageW) : RC.Bottom = CInt(PageH)
		Dim As HBRUSH WhiteBr = GetStockObject(WHITE_BRUSH)
		FillRect(Dc, @RC, WhiteBr)
		'Header: title (bold) left, page x/y right, rule underneath.
		Dim As HFONT HdrFont = CreateFontW(-CInt(11.0 / 72.0 * YDpi), 0, 0, 0, FW_BOLD, 0, 0, 0, DEFAULT_CHARSET, 0, 0, CLEARTYPE_QUALITY, 0, 0)
		Dim As HGDIOBJ OldF = SelectObject(Dc, Cast(HGDIOBJ, HdrFont))
		SetBkMode(Dc, TRANSPARENT)
		SetTextColor(Dc, &H000000)
		Dim As UString PgTxt = "第 " & (PageNo + 1) & " / " & (Lay.ColPages * Lay.RowPages) & " 页"
		Dim As Rect RH
		RH.Left = CInt(MarginL) : RH.Top = CInt(MarginT) : RH.Right = CInt(MarginR) : RH.Bottom = CInt(MarginT + 0.25 * YDpi)
		Dim As UString TitleTxt = IIf(Len(Title) > 0, Title, WStr("GridDataEx 报表"))
		If Lay.ColPages > 1 Then TitleTxt &= "  （列组 " & (PageNo \ Lay.RowPages + 1) & "/" & Lay.ColPages & "）"
		DrawTextW(Dc, TitleTxt, Len(TitleTxt), @RH, DT_LEFT Or DT_VCENTER Or DT_SINGLELINE Or DT_END_ELLIPSIS)
		DrawTextW(Dc, PgTxt, Len(PgTxt), @RH, DT_RIGHT Or DT_VCENTER Or DT_SINGLELINE)
		SelectObject(Dc, Cast(HGDIOBJ, GetStockObject(BLACK_PEN)))
		Dim As HGDIOBJ HdrBrush = SelectObject(Dc, GetStockObject(NULL_BRUSH))
		RC.Left = CInt(MarginL) : RC.Top = CInt(MarginT + 0.27 * YDpi) : RC.Right = CInt(MarginR) : RC.Bottom = CInt(MarginT + 0.27 * YDpi) + 1
		FillRect(Dc, @RC, Cast(HBRUSH, GetStockObject(BLACK_BRUSH)))
		SelectObject(Dc, HdrBrush)
		SelectObject(Dc, OldF)
		DeleteObject(Cast(HGDIOBJ, HdrFont))
		'Body font.
		Dim As HFONT BodyFont = CreateFontW(-CInt(9.0 / 72.0 * YDpi), 0, 0, 0, FW_NORMAL, 0, 0, 0, DEFAULT_CHARSET, 0, 0, CLEARTYPE_QUALITY, 0, 0)
		OldF = SelectObject(Dc, Cast(HGDIOBJ, BodyFont))
		Dim As HPEN LinePen = CreatePen(PS_SOLID, 1, &H808080)
		Dim As HGDIOBJ OldPen = SelectObject(Dc, Cast(HGDIOBJ, LinePen))
		Dim As HBRUSH HdrBack = CreateSolidBrush(&HF0F0F0)
		Dim As HBRUSH OldBr = Cast(HBRUSH, SelectObject(Dc, Cast(HGDIOBJ, HdrBack)))
		'Column band of this page.
		Dim As Long cg = PageNo \ Lay.RowPages
		Dim As Long rg = PageNo Mod Lay.RowPages
		Dim As Long c0 = Lay.ColStart(cg)
		Dim As Long c1 = IIf(cg + 1 <= Lay.ColPages - 1, Lay.ColStart(cg + 1) - 1, nC - 1)
		'Y walk: repeated fixed header rows, then this page's data rows.
		Dim As Double Y = MarginT + 0.35 * YDpi
		Dim As HGDIOBJ OldMap = 0
		'Repeated header rows.
		For k As Long = 0 To nR - 1
			If RowList(k) >= FFixedRows Then Exit For
			Dim As Double RHt = GetRowHeightPx(RowList(k)) / 96.0 * YDpi
			Dim As Double X = MarginL
			For m As Long = c0 To c1
				Dim As Double CW = GetColWidthPx(ColList(m)) / 96.0 * XDpi * Lay.ColScale
				If CW < 20 Then CW = 20
				Dim As Rect Cell
				Cell.Left = CInt(X) : Cell.Top = CInt(Y) : Cell.Right = CInt(X + CW) : Cell.Bottom = CInt(Y + RHt)
				FillRect(Dc, @Cell, HdrBack)
				Dim As UString HT = TextDisplay(RowList(k), ColList(m))
				SetTextColor(Dc, &H000000)
				DrawTextW(Dc, HT, Len(HT), @Cell, DT_CENTER Or DT_VCENTER Or DT_SINGLELINE Or DT_END_ELLIPSIS)
				MoveToEx(Dc, Cell.Left, Cell.Bottom - 1, NULL) : LineTo(Dc, Cell.Right, Cell.Bottom - 1)
				MoveToEx(Dc, Cell.Right - 1, Cell.Top, NULL) : LineTo(Dc, Cell.Right - 1, Cell.Bottom)
				X += CW
			Next m
			Y += RHt
		Next k
		'Data rows of this row group.
		Dim As Long r0 = Lay.RowStart(rg)
		Dim As Long r1 = IIf(rg + 1 <= Lay.RowPages - 1, Lay.RowStart(rg + 1) - 1, nR - 1)
		For k As Long = r0 To r1
			If RowList(k) < FFixedRows Then Continue For
			Dim As Double RHt = GetRowHeightPx(RowList(k)) / 96.0 * YDpi
			Dim As Double X = MarginL
			For m As Long = c0 To c1
				Dim As Double CW = GetColWidthPx(ColList(m)) / 96.0 * XDpi * Lay.ColScale
				If CW < 20 Then CW = 20
				Dim As Rect Cell
				Cell.Left = CInt(X) : Cell.Top = CInt(Y) : Cell.Right = CInt(X + CW) : Cell.Bottom = CInt(Y + RHt)
				Dim As UString VT = TextDisplay(RowList(k), ColList(m))
				SetTextColor(Dc, &H000000)
				Dim As Long Al = ColsArr(ColList(m)).Alignment
				Dim As Long DTF = DT_VCENTER Or DT_SINGLELINE Or DT_END_ELLIPSIS
				Select Case Al
					Case FlexAlignmentLeftCenter : DTF Or= DT_LEFT
					Case FlexAlignmentCenterCenter : DTF Or= DT_CENTER
					Case FlexAlignmentRightCenter : DTF Or= DT_RIGHT
					Case FlexAlignmentGeneral, FlexAlignmentGeneralCenter, FlexAlignmentGeneralTop, FlexAlignmentGeneralBottom
						If IsNumericText(VT) Then DTF Or= DT_RIGHT Else DTF Or= DT_LEFT
					Case Else : DTF Or= DT_LEFT
				End Select
				DrawTextW(Dc, VT, Len(VT), @Cell, DTF)
				MoveToEx(Dc, Cell.Left, Cell.Bottom - 1, NULL) : LineTo(Dc, Cell.Right, Cell.Bottom - 1)
				MoveToEx(Dc, Cell.Right - 1, Cell.Top, NULL) : LineTo(Dc, Cell.Right - 1, Cell.Bottom)
				X += CW
			Next m
			Y += RHt
			If Y > PageH - 0.6 * YDpi Then Exit For
		Next k
		SelectObject(Dc, Cast(HGDIOBJ, OldBr))
		SelectObject(Dc, OldPen)
		SelectObject(Dc, OldF)
		DeleteObject(Cast(HGDIOBJ, HdrBack))
		DeleteObject(Cast(HGDIOBJ, LinePen))
		DeleteObject(Cast(HGDIOBJ, BodyFont))
	End Sub
	#endif

	Property GridDataEx.ReportFitWidth As Boolean
		Return FReportFitWidth
	End Property

	Property GridDataEx.ReportFitWidth(ByVal Value As Boolean)
		FReportFitWidth = Value
	End Property

	Sub GridDataEx.PreviewShowPage(ByVal Delta As Long, ByVal Absolute As Long)
		If FPrevForm = 0 Then Exit Sub
		Dim As Long NP = IIf(Absolute > 0, Absolute, FPrevPage + Delta)
		If NP < 1 Then NP = 1
		If NP > FPrevPages Then NP = FPrevPages
		FPrevPage = NP
		If FPrevLbl <> 0 Then FPrevLbl->Text = "第 " & NP & " / " & FPrevPages & " 页"
		If FPrevHost <> 0 Then FPrevHost->Repaint
	End Sub

	Sub GridDataEx.PreviewDoPrint()
		Dim As UString T = IIf(FPrevTitle <> 0, *FPrevTitle, "")
		PrintOut(T, FPrevLandscape)
	End Sub

	Sub GridDataEx.PreviewBtn_Click(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
		Dim As GridDataEx Ptr G = PreviewGrid
		If G = 0 Then Exit Sub
		Select Case Sender.Text
			Case "首页" : G->PreviewShowPage(0, 1)
			Case "上一页" : G->PreviewShowPage(-1, 0)
			Case "下一页" : G->PreviewShowPage(1, 0)
			Case "末页" : G->PreviewShowPage(0, G->FPrevPages)
			Case "打印" : G->PreviewDoPrint()
			Case "-" : G->PreviewHost_Wheel(Designer, Sender, -1, 0, 0, 0)
			Case "+" : G->PreviewHost_Wheel(Designer, Sender, 1, 0, 0, 0)
			Case "100%" : G->PreviewSetZoom(1.0)
			Case "适应" : G->PreviewSetZoom(0)
			Case "关闭" : If G->FPrevForm <> 0 Then G->FPrevForm->CloseForm
		End Select
	End Sub

	Sub GridDataEx.PreviewForm_Resize(ByRef Designer As My.Sys.Object, ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
		'Keep the page host centered and fit on resize.
		Dim As GridDataEx Ptr G = PreviewGrid
		If G = 0 OrElse G->FPrevHost = 0 Then Exit Sub
		Dim As Long FW = Sender.ClientWidth, FH = Sender.ClientHeight
		If FW < 100 OrElse FH < 100 Then Exit Sub
		G->FPrevHost->SetBounds 4, 36, FW - 8, FH - 40
		G->FPrevHost->Repaint
	End Sub

	Sub GridDataEx.PreviewHost_Paint(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Cv As My.Sys.Drawing.Canvas)
		Dim As GridDataEx Ptr G = PreviewGrid
		If G = 0 Then Exit Sub
		#ifdef __USE_WINAPI__
		Dim As HDC Dc = Cast(HDC, Cv.Handle)
		If Dc = 0 Then Exit Sub
		'Physical host size: ClientWidth would be logical pixels while the DC
		'is physical - mixing them made the page blow up on high DPI.
		Dim As RECT HRC
		GetClientRect(Sender.Handle, @HRC)
		Dim As Long CW = HRC.Right, CH = HRC.Bottom
		Dim As RECT BG
		BG.Left = 0 : BG.Top = 0 : BG.Right = CW : BG.Bottom = CH
		Dim As HBRUSH GrayBr = CreateSolidBrush(&H3C3C3C)
		FillRect(Dc, @BG, GrayBr)
		DeleteObject(Cast(HGDIOBJ, GrayBr))
		Dim As FlexReportLayout Lay
		G->BuildReportLayout(Lay, G->FPrevLandscape, 96, 96)
		If Lay.ColPages < 1 OrElse Lay.RowPages < 1 Then Exit Sub
		Dim As Double BaseW = Lay.PageWIn * 96, BaseH = Lay.PageHIn * 96 'logical page px
		'Zoom: 0 = fit the whole page into the host (with padding).
		Dim As Double Z = G->FPrevZoom
		If Z <= 0 Then
			Z = Min((CW - 24) / BaseW, (CH - 24) / BaseH)
			If Z < 0.05 Then Z = 0.05
		End If
		Dim As Long PW = CInt(BaseW * Z)
		Dim As Long PH = CInt(BaseH * Z)
		Dim As Long PX = (CW - PW) \ 2 + G->FPrevOffX
		Dim As Long PY = (CH - PH) \ 2 + G->FPrevOffY
		'Rulers mirror the page origin/zoom (Report.Bas designer style).
		If G->FPrevRulerH <> 0 Then G->FPrevRulerH->ZeroOffset = CInt(PX / Z)
		If G->FPrevRulerV <> 0 Then G->FPrevRulerV->ZeroOffset = CInt(PY / Z)
		'Clamp the pan so a page edge never leaves the host completely.
		If PX > CW - 24 Then PX = CW - 24
		If PY > CH - 24 Then PY = CH - 24
		If PX + PW < 24 Then PX = 24 - PW
		If PY + PH < 24 Then PY = 24 - PH
		'Page shadow + border.
		Dim As HBRUSH ShBr = CreateSolidBrush(&H141414)
		Dim As Rect ShRect
		ShRect.Left = PX + 3 : ShRect.Top = PY + 3 : ShRect.Right = PX + PW + 3 : ShRect.Bottom = PY + PH + 3
		FillRect(Dc, @ShRect, ShBr)
		DeleteObject(Cast(HGDIOBJ, ShBr))
		'Render at the display resolution (crisper when zoomed in) and blit.
		Dim As Long PgDpi = Max(96, CInt(96 * Z))
		Dim As Long BMW = CInt(Lay.PageWIn * PgDpi)
		Dim As Long BMH = CInt(Lay.PageHIn * PgDpi)
		Dim As HDC Mem = CreateCompatibleDC(Dc)
		Dim As HBITMAP Bmp = CreateCompatibleBitmap(Dc, BMW, BMH)
		Dim As HGDIOBJ OldSel = SelectObject(Mem, Cast(HGDIOBJ, Bmp))
		Dim As FlexReportLayout LayHi
		G->BuildReportLayout(LayHi, G->FPrevLandscape, PgDpi, PgDpi)
		G->RenderReportPage(Mem, G->FPrevPage - 1, LayHi, IIf(G->FPrevTitle <> 0, *G->FPrevTitle, WStr("")))
		SetStretchBltMode(Dc, HALFTONE)
		StretchBlt(Dc, PX, PY, PW, PH, Mem, 0, 0, BMW, BMH, SRCCOPY)
		SelectObject(Mem, OldSel)
		DeleteObject(Cast(HGDIOBJ, Bmp))
		DeleteDC(Mem)
		'Zoom level caption on the host.
		Dim As HFONT CapFont = CreateFontW(-CInt(9.0 / 72.0 * GetDeviceCaps(Dc, LOGPIXELSY)), 0, 0, 0, FW_NORMAL, 0, 0, 0, DEFAULT_CHARSET, 0, 0, CLEARTYPE_QUALITY, 0, 0)
		Dim As HGDIOBJ OldF = SelectObject(Dc, Cast(HGDIOBJ, CapFont))
		SetBkMode(Dc, TRANSPARENT)
		SetTextColor(Dc, &HFFFFFF)
		Dim As UString ZTxt = IIf(G->FPrevZoom <= 0, "适应 " & CInt(Z * 100) & "%", CInt(Z * 100) & "%")
		Dim As Rect ZR
		ZR.Left = 6 : ZR.Top = CH - 26 : ZR.Right = CW - 6 : ZR.Bottom = CH - 6
		DrawTextW(Dc, ZTxt, Len(ZTxt), @ZR, DT_RIGHT Or DT_VCENTER Or DT_SINGLELINE)
		SelectObject(Dc, OldF)
		DeleteObject(Cast(HGDIOBJ, CapFont))
		#endif
	End Sub

	Sub GridDataEx.PreviewSetZoom(ByVal NewZoom As Double)
		'0 = fit window mode; otherwise clamp into 20%..500%.
		FPrevZoom = NewZoom
		If FPrevZoom > 0 Then
			If FPrevZoom < 0.2 Then FPrevZoom = 0.2
			If FPrevZoom > 5 Then FPrevZoom = 5
		End If
		FPrevOffX = 0 : FPrevOffY = 0
		If FPrevHost <> 0 Then FPrevHost->Repaint
	End Sub

	Sub GridDataEx.PreviewHost_Wheel(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByVal Direction As Integer, ByVal X As Integer, ByVal Y As Integer, ByVal Shift As Integer)
		'Mouse wheel zooms (10% steps); the zoom caption shows the level.
		Dim As GridDataEx Ptr G = PreviewGrid
		If G = 0 Then Exit Sub
		Dim As Double Cur = G->FPrevZoom
		If Cur <= 0 Then
			'Adopt the current fit level as the zoom base first.
			Dim As Long HostW = Sender.ScaleX(Sender.ClientWidth), HostH = Sender.ScaleY(Sender.ClientHeight)
			Dim As Double BaseW = 8.27 * 96, BaseH = 11.69 * 96
			If G->FPrevLandscape Then Swap BaseW, BaseH
			Cur = Min((HostW - 24) / BaseW, (HostH - 24) / BaseH)
			If Cur < 0.05 Then Cur = 0.05
		End If
		If Direction > 0 Then
			G->PreviewSetZoom(Cur * 1.1)
		Else
			G->PreviewSetZoom(Cur / 1.1)
		End If
	End Sub

	Sub GridDataEx.PreviewHost_MouseDown(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByVal Button As Integer, ByVal X As Integer, ByVal Y As Integer, ByVal Shift As Integer)
		Dim As GridDataEx Ptr G = PreviewGrid
		If G = 0 Then Exit Sub
		If Button = 0 Then
			G->FPrevDragging = True
			G->FPrevDragX = X
			G->FPrevDragY = Y
		End If
	End Sub

	Sub GridDataEx.PreviewHost_MouseMove(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByVal Button As Integer, ByVal X As Integer, ByVal Y As Integer, ByVal Shift As Integer)
		Dim As GridDataEx Ptr G = PreviewGrid
		If G = 0 Then Exit Sub
		If G->FPrevDragging AndAlso Button = 0 Then
			G->FPrevOffX += X - G->FPrevDragX
			G->FPrevOffY += Y - G->FPrevDragY
			G->FPrevDragX = X
			G->FPrevDragY = Y
			Sender.Repaint
		End If
	End Sub

	Sub GridDataEx.PreviewHost_MouseUp(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByVal Button As Integer, ByVal X As Integer, ByVal Y As Integer, ByVal Shift As Integer)
		Dim As GridDataEx Ptr G = PreviewGrid
		If G = 0 Then Exit Sub
		G->FPrevDragging = False
	End Sub

	Sub GridDataEx.PrintPreview(ByRef Title As WString = "", ByVal Landscape As Boolean = False)
		'Builds the pagination at preview DPI and shows the preview window.
		#ifndef __USE_WINAPI__
			'The pages are drawn with GDI (RenderReportPage): Windows only
			Exit Sub
		#endif
		Dim As FlexReportLayout Lay
		BuildReportLayout(Lay, Landscape, 96, 96)
		If Lay.ColPages < 1 OrElse Lay.RowPages < 1 Then Exit Sub
		PreviewGrid = @This
		FPrevLandscape = Landscape
		WLet(FPrevTitle, Title)
		FPrevPages = Lay.ColPages * Lay.RowPages
		If FPrevPage > FPrevPages Then FPrevPage = 1
		If FPrevForm = 0 Then
			FPrevForm = New Form
			With *FPrevForm
				.Name = "GridDataPreview"
				.Text = "打印预览 - GridDataEx"
				.Designer = FPrevForm
				.SetBounds 120, 80, 860, 640
				.OnResize = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer), @PreviewForm_Resize)
			End With
			Dim As String Caps(0 To 9) = {"首页", "上一页", "下一页", "末页", "打印", "-", "+", "100%", "适应", "关闭"}
			For i As Long = 0 To 9
				Dim As CommandButton Ptr B = New CommandButton
				With *B
					.Name = "pvBtn" & i
					.Text = Caps(i)
					.Designer = FPrevForm
					.SetBounds 6 + i * 64, 6, 60, 24
					.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @PreviewBtn_Click)
					.Parent = FPrevForm
				End With
			Next i
			FPrevRulerH = New Ruler
			With *FPrevRulerH
				.Name = "pvRulerH"
				.Orientation = ruHorizontal
				.Units = ruCentimeters
				.Designer = FPrevForm
				.SetBounds 4, 36, 830, 24
				.Parent = FPrevForm
			End With
			FPrevRulerV = New Ruler
			With *FPrevRulerV
				.Name = "pvRulerV"
				.Orientation = ruVertical
				.Units = ruCentimeters
				.Designer = FPrevForm
				.SetBounds 4, 60, 24, 536
				.Parent = FPrevForm
			End With
			FPrevLbl = New Label
			With *FPrevLbl
				.Name = "pvLbl"
				.Text = "第 1 / 1 页"
				.Designer = FPrevForm
				.SetBounds 660, 8, 180, 20
				.Parent = FPrevForm
			End With
			FPrevHost = New Panel
			With *FPrevHost
				.Name = "pvHost"
				.Designer = FPrevForm
				.SetBounds 28, 60, 806, 536
				.OnPaint = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Cv As My.Sys.Drawing.Canvas), @PreviewHost_Paint)
				.OnMouseWheel = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByVal Direction As Integer, ByVal X As Integer, ByVal Y As Integer, ByVal Shift As Integer), @PreviewHost_Wheel)
				.OnMouseDown = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByVal Button As Integer, ByVal X As Integer, ByVal Y As Integer, ByVal Shift As Integer), @PreviewHost_MouseDown)
				.OnMouseMove = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByVal Button As Integer, ByVal X As Integer, ByVal Y As Integer, ByVal Shift As Integer), @PreviewHost_MouseMove)
				.OnMouseUp = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByVal Button As Integer, ByVal X As Integer, ByVal Y As Integer, ByVal Shift As Integer), @PreviewHost_MouseUp)
				.Parent = FPrevForm
			End With
		Else
			'Window exists: it may have been closed - just reshow.
		End If
		FPrevLbl->Text = "第 " & FPrevPage & " / " & FPrevPages & " 页"
		FPrevForm->Show
		PreviewShowPage(0, FPrevPage)
	End Sub

	Sub GridDataEx.PrintOut(ByRef Title As WString = "", ByVal Landscape As Boolean = False)
		'Prints the report to the default printer, one page per StartPage.
		#ifdef __USE_WINAPI__
			Dim As WString * 260 PrnName
			Dim As ULong Sz = 260
			If GetDefaultPrinterW(@PrnName, @Sz) = 0 Then Exit Sub
			Dim As HDC PDc = CreateDCW(WStr("WINSPOOL"), @PrnName, NULL, NULL)
			If PDc = 0 Then Exit Sub
			Dim As Long XDpi = GetDeviceCaps(PDc, LOGPIXELSX)
			Dim As Long YDpi = GetDeviceCaps(PDc, LOGPIXELSY)
			'The printer's own printable area defines the page size.
			Dim As Double PWIn = GetDeviceCaps(PDc, HORZRES) / XDpi
			Dim As Double PHIn = GetDeviceCaps(PDc, VERTRES) / YDpi
			Dim As Boolean Land = PWIn > PHIn
			Dim As FlexReportLayout Lay
			BuildReportLayout(Lay, Land, XDpi, YDpi)
			Dim As Long TotalPages = Lay.ColPages * Lay.RowPages
			If TotalPages < 1 Then
				DeleteDC(PDc)
				Exit Sub
			End If
			Dim As DOCINFOW DI
			DI.cbSize = SizeOf(DOCINFOW)
			Dim As WString Ptr DocName
			WLet(DocName, IIf(Len(Title) > 0, Title, WStr("GridDataEx Report")))
			DI.lpszDocName = DocName
			If StartDocW(PDc, @DI) <= 0 Then
				DeleteDC(PDc)
				_Deallocate(DocName)
				Exit Sub
			End If
			_Deallocate(DocName)
			For pg As Long = 0 To TotalPages - 1
				StartPage(PDc)
				RenderReportPage(PDc, pg, Lay, Title)
				EndPage(PDc)
			Next pg
			EndDoc(PDc)
			DeleteDC(PDc)
		#endif
	End Sub
	'=== MFF Report.Bas bridge: full band-based report pipeline ===

	Function GridDataEx.BuildReportObject(ByRef Title As WString, ByVal GroupCol As Long) As Report Ptr
		'Maps the visible grid onto a Report:
		'  PageHeader  - labels (column captions, bold)
		'  GroupHeader - optional label bound to the group column
		'  Detail      - fields bound to "C<col>" data fields
		'  PageFooter  - page-number label (Report.PageNo)
		'Column x positions come from the grid (scaled to fit 7in like
		'ReportFitWidth), heights follow the grid rows.
		Dim RowList(Any) As Long, ColList(Any) As Long
		Dim As Long nR = CollectVisRows(RowList()), nC = CollectVisCols(ColList())
		If nC < 2 Then Return 0
		Dim As Report Ptr R = New Report
		'7 inches of printable width at design scale (96dpi logical px).
		Dim As Long PageW = 672
		Dim As Double TotalW = 0
		For m As Long = 0 To nC - 1
			Dim As Double w = GetColWidthPx(ColList(m)) / 96.0
			If w < 0.2 Then w = 0.2
			TotalW += w
		Next m
		Dim As Double K = IIf(TotalW > 0, Min(1.0, (PageW - 16) / (TotalW * 96.0)), 1.0)
		R->Width = PageW
		Dim As ReportBand Ptr BH = R->Bands.Add(rbtPageHeader)
		BH->Height = 26
		Dim As ReportBand Ptr BD = R->Bands.Add(rbtDetail)
		BD->Height = 22
		Dim As ReportBand Ptr BF = R->Bands.Add(rbtPageFooter)
		BF->Height = 24
		Dim As ReportBand Ptr BG = 0
		If GroupCol >= FFixedCols AndAlso GroupCol <= FCols - 1 Then
			BG = R->Bands.Add(rbtGroupHeader)
			BG->Height = 24
		End If
		'Page header labels + detail fields, x walks the column widths.
		Dim As Long X = 8
		For m As Long = 0 To nC - 1
			Dim As Long cw = Max(40, CInt(GetColWidthPx(ColList(m)) / 96.0 * 96.0 * K))
			Dim As ReportLabel Ptr L = New ReportLabel
			L->Text = TextDisplay(0, ColList(m))
			L->Transparent = False
			L->BackColor = &HF0F0F0
			L->Alignment = AlignmentConstants.taCenter
			L->SetBounds(X, 3, cw - 4, 20)
			BH->Components.Add(L)
			Dim As ReportField Ptr F = New ReportField
			F->DataField = "C" & ColList(m)
			F->Alignment = IIf(IsNumericText(TextMatrix(RowList(FFixedRows), ColList(m))), AlignmentConstants.taRight, AlignmentConstants.taLeft)
			F->SetBounds(X, 2, cw - 4, 18)
			BD->Components.Add(F)
			If BG <> 0 AndAlso ColList(m) = GroupCol Then
				Dim As ReportField Ptr GF = New ReportField
				GF->DataField = "C" & ColList(m)
				GF->Text = TextDisplay(0, ColList(m)) & ": "
				GF->SetBounds(8, 3, PageW - 24, 18)
				BG->Components.Add(GF)
			End If
			X += cw
		Next m
		'Page footer: page number + title left.
		Dim As ReportLabel Ptr FL = New ReportLabel
		FL->Text = IIf(Len(Title) > 0, Title, WStr("GridDataEx Report"))
		FL->SetBounds(8, 4, PageW \ 2, 16)
		BF->Components.Add(FL)
		Dim As ReportField Ptr FP = New ReportField
		FP->DataField = "PAGENUMBER"
		FP->Text = "第 1 页"
		FP->SetBounds(PageW - 140, 4, 130, 16)
		BF->Components.Add(FP)
		Return R
	End Function

	Function GridDataRptGetFieldValue(ByRef Designer As My.Sys.Object, ByRef FieldName As WString, RowIndex As Integer) ByRef As WString
		'Resolves "C<col>" to the visible data row's cell (translated) text.
		'Module-level: a Static member function cannot take ByRef parameters,
		'which the Report.OnGetFieldValue delegate requires.
		Dim As GridDataEx Ptr G = RptSourceGrid
		If G = 0 OrElse RptValueBuf = 0 Then Return ""
		Dim As String K = FieldName
		If UCase(Mid(K, 1, 6)) = "PAGENU" Then Return ""
		If Mid(K, 1, 1) <> "C" Then Return ""
		Dim As Long c = Val(Mid(K, 2))
		If c < 0 OrElse c > G->Cols - 1 Then Return ""
		Dim As Long RI = RowIndex
		Dim As Long nR = 0
		For i As Long = G->FixedRows To G->Rows - 1
			If G->RowHidden(i) = False Then
				If RI = nR Then
					WLet(RptValueBuf, G->TextDisplay(i, c))
					Return *RptValueBuf
				End If
				nR += 1
			End If
		Next i
		Return ""
	End Function

	Sub GridDataEx.ReportShow(ByRef Title As WString = "", ByVal GroupCol As Long = -1, ByVal ToPDF As Boolean = False)
		Dim As Report Ptr R = BuildReportObject(Title, GroupCol)
		If R = 0 Then Exit Sub
		RptSourceGrid = @This
		If FRptBuf = 0 Then WLet(FRptBuf, "")
		RptValueBuf = FRptBuf
		R->OnGetFieldValue = @GridDataRptGetFieldValue
		'Detail iteration needs the data row count (visible, non-fixed).
		Dim RowList(Any) As Long
		R->RowCount = CollectVisRows(RowList()) - FFixedRows
		If R->RowCount < 0 Then R->RowCount = 0
		If ToPDF Then
			R->ExportToPDF(IIf(Len(Title) > 0, Title, WStr("GridDataEx Report")))
		Else
			R->PrintPreview
		End If
	End Sub

	'=== Default color schemes (light + dark) ===

	Sub GridDataEx.SetDefaultColors(ByVal Dark As Boolean)
		'Built-in palettes. Light keeps the classic system colors; dark uses
		'a VS Code-like scheme. Values are COLORREF (0xBBGGRR).
		If Dark = False Then
			BackColor = GetSysColor(COLOR_WINDOW)        'cell background
			ForeColor = GetSysColor(COLOR_WINDOWTEXT)    'cell text
			FBackColorBkg = GetSysColor(COLOR_SCROLLBAR) 'sheet background
			FBackColorFixed = GetSysColor(COLOR_BTNFACE) 'fixed cells
			FForeColorFixed = GetSysColor(COLOR_BTNTEXT)
			FBackColorSel = GetSysColor(COLOR_HIGHLIGHT) 'selection
			FForeColorSel = GetSysColor(COLOR_HIGHLIGHTTEXT)
			FGridColor = &HC0C0C0
			FGridColorFixed = 0 'black
		Else
			BackColor = &H1E1E1E        '#1E1E1E cell background
			ForeColor = &HD4D4D4        '#D4D4D4 cell text
			FBackColorBkg = &H262626    '#262626 sheet background
			FBackColorFixed = &H2D2D30  '#2D2D30 fixed cells
			FForeColorFixed = &HF0F0F0  '#F0F0F0
			FBackColorSel = &H714709    '#094771 selection (VS Code blue)
			FForeColorSel = &HFFFFFF
			FGridColor = &H3A3A3A       '#3A3A3A grid lines
			FGridColorFixed = &H464646  '#464646
		End If
		FBackColorAlt = -1
		FGridColorFrozen = -1
		FSortArrowColor = -1
		FFloodColor = -1
		FInsertMarkColor = -1
		FColorsCustomized = False
		ApplyScrollBarTheme(Dark)
	End Sub

	Sub GridDataEx.ApplyScrollBarTheme(ByVal Dark As Boolean)
		'Switches the grid's own scrollbars between the light and the
		'DarkMode_Explorer theme; FScrollBarThemeDark=-1 means "not yet".
		#ifdef __USE_WINAPI__
			If FScrollBarThemeDark = IIf(Dark, 1, 0) Then Exit Sub
			If Handle = 0 Then Exit Sub
			Dim As WString * 20 LightTheme = ""
			Dim As WString * 20 DarkTheme = "DarkMode_Explorer"
			Dim As WString * 2 EmptyId = ""
			If Dark Then
				AllowDarkModeForWindow(Handle, True)
				GDSetWindowTheme(Handle, @DarkTheme, @EmptyId)
			Else
				GDSetWindowTheme(Handle, @LightTheme, @EmptyId)
				AllowDarkModeForWindow(Handle, False)
			End If
			FScrollBarThemeDark = IIf(Dark, 1, 0)
			InvalidateRect(Handle, NULL, True)
		#endif
	End Sub

	Sub GridDataEx.ApplyDefaultColors()
		'Reapplies the scheme for the current App.DarkMode state; call after
		'toggling App.DarkMode (the grid receives no notification on its own).
		#ifndef __USE_WINAPI__
			SetDefaultColors(False)
		#else
			SetDefaultColors(g_darkModeEnabled)
		#endif
		'The in-place editor follows the cell colors so editing stays
		'readable in both schemes.
		If EditText_ <> 0 Then
			EditText_->BackColor = BackColor
			EditText_->ForeColor = ForeColor
		End If
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Sub

	'=== Sort engine (ported from MFF Grid GridRows.CompareStrings/.Sort/.SortArray) ===

	Function GridDataEx.CompareStrings(ByRef s1 As WString, ByRef s2 As WString, ByVal MatchCase As Boolean = True, ByVal NaturalSort As Boolean = False, ByVal Direction As Long = 1) As Long
		'Character-wise compare; NaturalSort compares digit runs (optional
		'sign, integer and fraction part) by numeric value, like GridRows.
		Dim As Integer iLen1 = Len(s1)
		Dim As Integer iLen2 = Len(s2)
		Dim As Integer i1 = 0, i2 = 0
		Dim As Long c1, c2

		While i1 < iLen1 AndAlso i2 < iLen2
			c1 = s1[i1]
			c2 = s2[i2]
			Dim isNum1 As Boolean = (c1 >= 48 AndAlso c1 <= 57) OrElse _
				((c1 = 43 OrElse c1 = 45) AndAlso (i1 + 1 < iLen1) AndAlso (s1[i1 + 1] >= 48 AndAlso s1[i1 + 1] <= 57))
			Dim isNum2 As Boolean = (c2 >= 48 AndAlso c2 <= 57) OrElse _
				((c2 = 43 OrElse c2 = 45) AndAlso (i2 + 1 < iLen2) AndAlso (s2[i2 + 1] >= 48 AndAlso s2[i2 + 1] <= 57))
			If NaturalSort AndAlso isNum1 AndAlso isNum2 Then
				Dim sign1 As Double = 1.0
				If s1[i1] = 43 Then
					i1 += 1 ''+'
				ElseIf s1[i1] = 45 Then   '-
					sign1 = -1.0
					i1 += 1
				End If
				Dim num1_int As LongInt = 0
				While i1 < iLen1 AndAlso s1[i1] >= 48 AndAlso s1[i1] <= 57
					num1_int = num1_int * 10 + (s1[i1] - 48)
					i1 += 1
				Wend
				Dim num1_frac As Double = 0.0
				If i1 < iLen1 AndAlso s1[i1] = 46 Then ' "."  Decimal part
					i1 += 1
					Dim divisor As Double = 10.0
					While i1 < iLen1 AndAlso s1[i1] >= 48 AndAlso s1[i1] <= 57
						num1_frac = num1_frac + (s1[i1] - 48) / divisor
						divisor *= 10.0
						i1 += 1
					Wend
				End If
				Dim val1 As Double = sign1 * (num1_int + num1_frac)

				Dim sign2 As Double = 1.0
				If s2[i2] = 43 Then
					i2 += 1
				ElseIf s2[i2] = 45 Then
					sign2 = -1.0
					i2 += 1
				End If
				Dim num2_int As LongInt = 0
				While i2 < iLen2 AndAlso s2[i2] >= 48 AndAlso s2[i2] <= 57
					num2_int = num2_int * 10 + (s2[i2] - 48)
					i2 += 1
				Wend
				Dim num2_frac As Double = 0.0
				If i2 < iLen2 AndAlso s2[i2] = 46 Then ' "."  Decimal part
					i2 += 1
					Dim divisor2 As Double = 10.0
					While i2 < iLen2 AndAlso s2[i2] >= 48 AndAlso s2[i2] <= 57
						num2_frac = num2_frac + (s2[i2] - 48) / divisor2
						divisor2 *= 10.0
						i2 += 1
					Wend
				End If
				Dim val2 As Double = sign2 * (num2_int + num2_frac)
				If val1 < val2 Then Return -1 * Direction
				If val1 > val2 Then Return 1 * Direction
				Continue While
			End If

			If Not MatchCase Then
				If c1 >= 65 AndAlso c1 <= 90 Then c1 += 32 ' A-Z -> a-z
				If c2 >= 65 AndAlso c2 <= 90 Then c2 += 32
			End If
			If c1 < c2 Then Return -1 * Direction
			If c1 > c2 Then Return 1 * Direction

			i1 += 1
			i2 += 1
		Wend
		If iLen1 < iLen2 Then Return -1 * Direction
		If iLen1 > iLen2 Then Return 1 * Direction
		Return 0
	End Function

	' ---- 行排序辅助: TimSortIndex 需要"行号"形式的比较回调 ----
	' 键数组按"行号"索引(不再随排序交换), 比较器按行号取键
	Dim Shared GDSortKeyTxt As WString Ptr Ptr
	Dim Shared GDSortKeyNum As Double Ptr
	Dim Shared GDSortKeyKind As Integer Ptr
	Dim Shared GDSortCmpCase As Boolean
	Dim Shared GDSortNatural As Boolean
	Dim Shared GDSortRowBase As Long
	Dim Shared GDSortSelf As GridDataEx Ptr

	Private Function GridDataRowCompare(ByVal a As Long, ByVal b As Long, ByVal ctx As Any Ptr) As Long
		Dim As Long ra = GDSortRowBase + a
		Dim As Long rb = GDSortRowBase + b
		If (GDSortKeyKind[ra] = 0) OrElse (GDSortKeyKind[rb] = 0) Then
			Return GDSortSelf->CompareStrings(IIf(GDSortKeyTxt[ra] <> 0, *GDSortKeyTxt[ra], ""), IIf(GDSortKeyTxt[rb] <> 0, *GDSortKeyTxt[rb], ""), GDSortCmpCase, GDSortNatural, 1)
		ElseIf GDSortKeyNum[ra] < GDSortKeyNum[rb] Then
			Return -1
		ElseIf GDSortKeyNum[ra] > GDSortKeyNum[rb] Then
			Return 1
		End If
		Return 0
	End Function

	Sub GridDataEx.SortArray(ByVal StartRow As Long = -1, ByVal EndRow As Long = -1, ByVal SortCol As Long = -1, ByVal SortType As Integer = FlexSortGenericAscending, ByVal NaturalSort As Boolean = False, ByVal MatchCase As Boolean = False)
		'TimSort over a row-order index: keys stay indexed by row (text as
		'WString Ptr like Grid, plus pre-parsed numeric/date values), so the
		'sort itself moves nothing but the index array. The grid contents are
		'rewritten once at the end following the final order, which also keeps
		'OnCompare events correct because the event still sees the untouched
		'rows through the order mapping.
		If SortCol < FFixedCols OrElse SortCol > FCols - 1 Then Exit Sub
		Dim As Long iLBound = IIf(StartRow < 0, FFixedRows, Max(FFixedRows, StartRow))
		Dim As Long iUBound = IIf(EndRow < 0, FRows - 1, min(FRows - 1, EndRow))
		If iUBound - iLBound < 1 Then Exit Sub
		Dim As Long iDirection = IIf((SortType = FlexSortGenericDescending) OrElse (SortType = FlexSortNumericDescending) OrElse _
			(SortType = FlexSortStringNoCaseDescending) OrElse (SortType = FlexSortStringDescending) OrElse _
			(SortType = FlexSortCurrencyDescending) OrElse (SortType = FlexSortDateDescending), -1, 1)
		Dim As Boolean UseCustom = (SortType = FlexSortCustom) OrElse (SortType = FlexSortCustomText)
		Dim As Boolean CmpCase = MatchCase OrElse (SortType = FlexSortStringAscending) OrElse (SortType = FlexSortStringDescending)
		Dim As Long i, j, k

		'--- parallel key arrays (pointer/POD swaps only) ---
		Dim Order(iLBound To iUBound) As Long          'Order[i] = source row
		Dim KeyTxt(iLBound To iUBound) As WString Ptr  'allocated text keys
		Dim KeyNum(iLBound To iUBound) As Double       'pre-parsed value
		Dim KeyKind(iLBound To iUBound) As Integer     '0 text, 1 numeric, 2 date
		For i = iLBound To iUBound
			Order(i) = i
			WLet(KeyTxt(i), CellTextRaw(i, SortCol))
			KeyNum(i) = 0
			KeyKind(i) = 0
			Select Case SortType
				Case FlexSortNumericAscending, FlexSortNumericDescending, _
				     FlexSortCurrencyAscending, FlexSortCurrencyDescending
					KeyKind(i) = 1
					KeyNum(i) = Val(*KeyTxt(i))
				Case FlexSortDateAscending, FlexSortDateDescending
					KeyKind(i) = 2
					KeyNum(i) = ParseDateText(*KeyTxt(i))
				Case Else
					If IsNumericText(*KeyTxt(i)) Then
						KeyKind(i) = 1
						KeyNum(i) = Val(*KeyTxt(i))
					End If
			End Select
		Next i

		If UseCustom Then
			'Stable insertion sort; OnCompare receives real row numbers.
			For i = iLBound + 1 To iUBound
				j = i
				While j > iLBound
					Dim As Long CmpResult = 0
					OnCompare(*Designer, This, Order(j - 1), Order(j), SortCol, CmpResult)
					If CmpResult * iDirection <= 0 Then Exit While
					Swap Order(j - 1), Order(j)
					Swap KeyTxt(j - 1), KeyTxt(j)
					Swap KeyNum(j - 1), KeyNum(j)
					Swap KeyKind(j - 1), KeyKind(j)
					j -= 1
				Wend
			Next i
		Else
			'TimSort over row indices: the keys stay indexed by row and the
			'comparator looks them up, so nothing but the order array moves.
			GDSortKeyTxt = @KeyTxt(iLBound)
			GDSortKeyNum = @KeyNum(iLBound)
			GDSortKeyKind = @KeyKind(iLBound)
			GDSortCmpCase = CmpCase
			GDSortNatural = NaturalSort
			GDSortRowBase = iLBound
			GDSortSelf = @This
			Dim As Long Ptr GDSortIdx = New Long[iUBound - iLBound + 1]
			If GDSortIdx = 0 Then Exit Sub
			TimSortIndex(GDSortIdx, iUBound - iLBound + 1, @GridDataRowCompare, iDirection, 0)
			For i = iLBound To iUBound
				Order(i) = GDSortRowBase + GDSortIdx[i - iLBound]
			Next i
			Delete[] GDSortIdx
		End If

		'--- rewrite the grid once following the final order ---
		Dim As Long n = iUBound - iLBound + 1
		Dim TmpCells(0 To n * FCols - 1) As FlexCell Ptr
		Dim TmpRows(0 To n - 1) As FlexRowInfo
		For i = 0 To n - 1
			Dim As Long Src = Order(iLBound + i)
			For k = 0 To FCols - 1
				TmpCells(i * FCols + k) = CellsArr(Src * FCols + k)
			Next k
			TmpRows(i) = RowsArr(Src)
		Next i
		For i = 0 To n - 1
			For k = 0 To FCols - 1
				CellsArr((iLBound + i) * FCols + k) = TmpCells(i * FCols + k)
			Next k
			RowsArr(iLBound + i) = TmpRows(i)
		Next i

		For i = iLBound To iUBound
			WDeAllocate(KeyTxt(i))
		Next i
		InvalidateMergeCache
		InvalidateRowGeometry
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
		If OnScroll Then OnScroll(*Designer, This)
	End Sub

	Sub GridDataEx.Sort(ByVal SortCol As Long = -1, ByVal SortType As Integer = FlexSortGenericAscending, ByVal NaturalSort As Boolean = False, ByVal MatchCase As Boolean = False)
		'Public entry: validates and forwards to SortArray over the whole
		'data area (GridRows.Sort -> GridRows.SortArray pattern).
		If SortCol < 0 Then SortCol = FCol
		If SortCol < FFixedCols OrElse SortCol > FCols - 1 Then Exit Sub
		If FRows - FFixedRows < 2 Then Exit Sub
		SortArray(FFixedRows, FRows - 1, SortCol, SortType, NaturalSort, MatchCase)
	End Sub

	'=== FindItem (equivalent of VB6 FindItem) ===

	Function GridDataEx.FindItem(ByRef SearchText As WString, ByVal aRow As Long = -1, ByVal aCol As Long = -1, ByVal Match As Integer = FlexFindMatchPartial, ByVal CaseSensitive As Boolean = False, ByVal ExcludeHidden As Boolean = False, ByVal Wrap As Boolean = True, ByVal Direction As Integer = FlexFindDirectionDown) As Boolean
		'Locates a cell by text and makes it the current cell. Returns False when absent.
		If Len(SearchText) = 0 Then Return False
		'Record the parameters so FindNext can continue this search.
		FFindText = SearchText
		FFindMatch = Match
		FFindCase = CaseSensitive
		FFindDir = Direction
		Dim As Long StartRow = IIf(aRow < 0, FRow, aRow)
		Dim As Long StartCol = IIf(aCol < 0, FCol, aCol)
		Dim As Long StepRow = 0, StepCol = 0
		Select Case Direction
			Case FlexFindDirectionUp : StepRow = -1
			Case FlexFindDirectionRight : StepCol = 1
			Case FlexFindDirectionLeft : StepCol = -1
			Case Else : StepRow = 1
		End Select
		Dim As Boolean Backward = (StepRow < 0) OrElse (StepCol < 0)
		Dim As Long i = StartRow, j = StartCol
		Dim As Long Scanned = 0, TotalCells = (FRows - FFixedRows) * (FCols - FFixedCols)
		Do While Scanned <= TotalCells
			Dim advance As Boolean = True
			If i >= FFixedRows AndAlso j >= FFixedCols AndAlso i <= FRows - 1 AndAlso j <= FCols - 1 Then
				Scanned += 1
				Dim As Boolean VisibleOK = True
				If ExcludeHidden Then
					VisibleOK = IsRowVisible(i) AndAlso IsColVisible(j)
				End If
				If VisibleOK Then
					Dim As UString Haystack = TextMatrix(i, j)
					Dim As UString Needle = SearchText
					If CaseSensitive = False Then
						Haystack = UCase(TextMatrix(i, j))
						Needle = UCase(SearchText)
					End If
					Dim Found As Boolean
					Select Case Match
						Case FlexFindMatchExact : Found = (Haystack = Needle)
						Case FlexFindMatchStartsWith : Found = (Mid(Haystack, 1, Len(Needle)) = Needle)
						Case FlexFindMatchEndsWith
							If Len(Haystack) >= Len(Needle) Then
								Found = (Mid(Haystack, Len(Haystack) - Len(Needle) + 1) = Needle)
							Else
								Found = False
							End If
						Case Else : Found = (InStr(Haystack, Needle) > 0)
					End Select
					If Found Then
						Row = i
						Col = j
						Return True
					End If
				End If
			End If
			If advance Then
				If StepRow <> 0 Then
					i += StepRow
					If i > FRows - 1 OrElse i < FFixedRows Then
						If Wrap = False Then Return False
						i = IIf(StepRow > 0, FFixedRows, FRows - 1)
						'Wrapped past the start: stop when revisiting the start cell.
						If Backward = False AndAlso i = StartRow AndAlso j >= StartCol Then Return False
					End If
				Else
					j += StepCol
					If j > FCols - 1 OrElse j < FFixedCols Then
						If Wrap = False Then Return False
						j = IIf(StepCol > 0, FFixedCols, FCols - 1)
						i += 1
						If i > FRows - 1 Then
							i = FFixedRows
							If Backward = False AndAlso StartCol = FFixedCols AndAlso StartRow = FFixedRows Then Return False
						End If
					End If
				End If
			End If
			'Stop after a full wrap revisiting the start cell.
			If Scanned > TotalCells Then Return False
		Loop
		Return False
	End Function

	Sub GridDataEx.SelectAll
		FRow = FFixedRows
		FCol = FFixedCols
		FRowSel = FRows - 1
		FColSel = FCols - 1
		If OnSelChange Then OnSelChange(*Designer, This)
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Sub
	'=== Row height / column width (twips, VB6-compatible API) ===

	Property GridDataEx.RowHeight(ByVal aIndex As Long) As Long
		If aIndex < 0 OrElse aIndex > FRows - 1 Then Return -1
		Return RowsArr(aIndex).Height
	End Property

	Property GridDataEx.RowHeight(ByVal aIndex As Long, ByVal Value As Long)
		If aIndex < 0 OrElse aIndex > FRows - 1 Then Exit Property
		If FRowHeightMin > 0 AndAlso Value > 0 AndAlso Value < FRowHeightMin Then Value = FRowHeightMin
		If FRowHeightMax > 0 AndAlso Value > FRowHeightMax Then Value = FRowHeightMax
		RowsArr(aIndex).Height = IIf(Value > 0, Value, -1)
		InvalidateRowGeometry
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.ColWidth(ByVal aIndex As Long) As Long
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return -1
		Return ColsArr(aIndex).Width
	End Property

	Property GridDataEx.ColWidth(ByVal aIndex As Long, ByVal Value As Long)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		If FColWidthMin > 0 AndAlso Value > 0 AndAlso Value < FColWidthMin Then Value = FColWidthMin
		If FColWidthMax > 0 AndAlso Value > FColWidthMax Then Value = FColWidthMax
		ColsArr(aIndex).Width = IIf(Value > 0, Value, -1)
		InvalidateColGeometry
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.DefaultRowHeight As Long
		Return FDefaultRowHeight
	End Property

	Property GridDataEx.DefaultRowHeight(ByVal Value As Long)
		If Value < 60 Then Value = 60 'Minimum sane row height in twips.
		FDefaultRowHeight = Value
		InvalidateRowGeometry
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.DefaultColWidth As Long
		Return FDefaultColWidth
	End Property

	Property GridDataEx.DefaultColWidth(ByVal Value As Long)
		If Value < 120 Then Value = 120 'Minimum sane column width in twips.
		FDefaultColWidth = Value
		InvalidateColGeometry
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.AllowUserResizing As Integer
		Return FAllowUserResizing
	End Property

	Property GridDataEx.AllowUserResizing(ByVal Value As Integer)
		FAllowUserResizing = Value
	End Property

	'=== Divider hit testing ===

	'Client-to-grid coordinate conversion (the drawing area scrolls; the fixed
	'region does not). Grid space starts at 0 = top/left of row 0 / column 0.
	Function GridDataEx.GridYFromClient(ByVal Y As Long) As Long
		Dim As Long BorderSize = GetGridLineOffsets_AreaTop()
		Dim As Long FixedRowCount = FFixedRows + FFrozenRows
		If FixedRowCount > FRows Then FixedRowCount = FRows
		Dim As Long ScrollTop = BorderSize + RowTopY(FixedRowCount) + FilterBarHeightPx()
		If Y < ScrollTop Then Return Y - BorderSize
		Return RowTopY(FTopRow) + (Y - ScrollTop)
	End Function

	Function GridDataEx.GridXFromClient(ByVal X As Long) As Long
		Dim As Long BorderSize = GetGridLineOffsets_AreaTop()
		Dim As Long FixedColCount = FFixedCols + FFrozenCols
		If FixedColCount > FCols Then FixedColCount = FCols
		Dim As Long ScrollLeft = BorderSize + ColLeftX(FixedColCount)
		If X < ScrollLeft Then Return X - BorderSize
		Return ColLeftX(FLeftCol) + (X - ScrollLeft)
	End Function

	Function GridDataEx.HitColDividerPx(ByVal X As Long, ByVal Y As Long) As Long
		'Returns the column index whose right divider is under X, -1 if none.
		'The vertical position must be inside the grid area rows.
		Dim As Long BorderSize = GetGridLineOffsets_AreaTop()
		Dim As Long AreaTop = BorderSize
		Dim As Long AreaBottom = ClientHeightPx() - BorderSize
		If Y < AreaTop OrElse Y > AreaBottom Then Return -1
		If FAllowUserResizing = FlexAllowUserResizingNone Then Return -1
		If FAllowUserResizing = FlexAllowUserResizingRows Then Return -1
		Dim As Long Tol = Max(2, GetDefaultColWidthPx() \ 24) 'About 50 twips worth of pixels.
		'Work in grid space; the neighbor of the column under X owns the divider.
		Dim As Long GridX = GridXFromClient(X)
		Dim As Long j = ColAtX(GridX)
		If j < 0 Then j = FCols - 1
		Dim As Long k
		For k = j - 1 To j + 1
			If k < 0 OrElse k > FCols - 1 Then Continue For
			Dim As Long XCur = ColLeftX(k + 1)
			If GridX >= XCur - Tol AndAlso GridX <= XCur + Tol Then
				'Per-column nosizing flag blocks the divider.
				If (ColsArr(k).State And FLEX_CLIS_NOSIZING) <> 0 Then Return -1
				Return k
			End If
		Next k
		Return -1
	End Function

	Function GridDataEx.HitRowDividerPx(ByVal X As Long, ByVal Y As Long) As Long
		Dim As Long BorderSize = GetGridLineOffsets_AreaTop()
		Dim As Long AreaLeft = BorderSize
		Dim As Long AreaRight = ClientWidthPx() - BorderSize
		If X < AreaLeft OrElse X > AreaRight Then Return -1
		If FAllowUserResizing = FlexAllowUserResizingNone Then Return -1
		If FAllowUserResizing = FlexAllowUserResizingColumns Then Return -1
		Dim As Long Tol = Max(2, GetDefaultRowHeightPx() \ 12)
		Dim As Long GridY = GridYFromClient(Y)
		Dim As Long i = RowAtY(GridY)
		If i < 0 Then i = FRows - 1
		Dim As Long k
		For k = i - 1 To i + 1
			If k < 0 OrElse k > FRows - 1 Then Continue For
			Dim As Long YCur = RowTopY(k + 1)
			If GridY >= YCur - Tol AndAlso GridY <= YCur + Tol Then
				If (RowsArr(k).State And FLEX_RWIS_NOSIZING) <> 0 Then Return -1
				Return k
			End If
		Next k
		Return -1
	End Function
	Property GridDataEx.GridColor As Long
		Return FGridColor
	End Property

	Property GridDataEx.GridColor(ByVal Value As Long)
		FColorsCustomized = True
		FGridColor = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	'=== Merged cells ===

	Property GridDataEx.MergeCells As Integer
		Return FMergeCells
	End Property

	Property GridDataEx.MergeCells(ByVal Value As Integer)
		If Value = FMergeCells Then Exit Property
		FMergeCells = Value
		InvalidateMergeCache
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.MergeRow(ByVal aIndex As Long) As Boolean
		If aIndex < 0 OrElse aIndex > FRows - 1 Then Return False
		Return FMergeRows(aIndex)
	End Property

	Property GridDataEx.MergeRow(ByVal aIndex As Long, ByVal Value As Boolean)
		If aIndex < 0 OrElse aIndex > FRows - 1 Then Exit Property
		FMergeRows(aIndex) = Value
		InvalidateMergeCache
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.MergeCol(ByVal aIndex As Long) As Boolean
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return False
		Return FMergeCols(aIndex)
	End Property

	Property GridDataEx.MergeCol(ByVal aIndex As Long, ByVal Value As Boolean)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		FMergeCols(aIndex) = Value
		InvalidateMergeCache
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Sub GridDataEx.InvalidateMergeCache
		FMergeDirty = True
	End Sub

	Function GridDataEx.CellTextRaw(ByVal aRow As Long, ByVal aCol As Long) ByRef As WString
		Dim As FlexCell Ptr C = CellAt(aRow, aCol)
		If C = 0 OrElse C->FText = 0 Then Return ""
		Return *C->FText
	End Function

	Function GridDataEx.CellsEqual(ByVal r1 As Long, ByVal c1 As Long, ByVal r2 As Long, ByVal c2 As Long) As Boolean
		'Two cells can merge only if both are non-empty and equal.
		If Len(CellTextRaw(r1, c1)) = 0 Then Return False
		Return CBool(CellTextRaw(r1, c1) = CellTextRaw(r2, c2))
	End Function

	Sub GridDataEx.BuildMergeCache
		'With merging disabled no cache is needed at all (important for
		'million-row grids: the flat cache would cost 16 bytes per cell).
		If FMergeCells = FlexMergeCellsNever Then
			FMergeDirty = False
			Exit Sub
		End If
		Dim n As Long = FRows * FCols
		If LBound(MergeCache) > UBound(MergeCache) OrElse (UBound(MergeCache) - LBound(MergeCache) + 1) <> n * 4 Then
			ReDim MergeCache(0 To n * 4 - 1)
		End If
		Dim k As Long
		For k = 0 To n - 1
			MergeCache(k * 4 + 0) = -1 : MergeCache(k * 4 + 1) = -1
			MergeCache(k * 4 + 2) = -1 : MergeCache(k * 4 + 3) = -1
		Next k
		FMergeDirty = False

		Dim AllowHorz As Boolean = (FMergeCells = FlexMergeCellsFree) OrElse _
		                           (FMergeCells = FlexMergeCellsRestrictColumns) OrElse _
		                           (FMergeCells = FlexMergeCellsRestrictAll) OrElse _
		                           (FMergeCells = FlexMergeCellsFixedOnly)
		Dim AllowVert As Boolean = (FMergeCells = FlexMergeCellsFree) OrElse _
		                           (FMergeCells = FlexMergeCellsRestrictRows) OrElse _
		                           (FMergeCells = FlexMergeCellsRestrictAll)
		Dim FixedOnly As Boolean = (FMergeCells = FlexMergeCellsFixedOnly)

		Dim r As Long, cc As Long
		For r = 0 To FRows - 1
			For cc = 0 To FCols - 1
				If Len(CellTextRaw(r, cc)) = 0 Then Continue For
				If FixedOnly AndAlso CBool((r >= FFixedRows) OrElse (cc >= FFixedCols)) Then Continue For
				Dim As Long R2 = r, C2 = cc
				Dim CanRow As Boolean = AllowVert AndAlso FMergeRows(r)
				Dim CanCol As Boolean = AllowHorz AndAlso FMergeCols(cc)
				If CanCol Then
					Do While C2 + 1 <= FCols - 1
						If FixedOnly AndAlso (C2 + 1 >= FFixedCols) Then Exit Do
						If Not FMergeCols(C2 + 1) Then Exit Do
						If CellsEqual(r, cc, r, C2 + 1) = False Then Exit Do
						C2 += 1
					Loop
				End If
				If CanRow Then
					Do While R2 + 1 <= FRows - 1
						If FixedOnly AndAlso (R2 + 1 >= FFixedRows) Then Exit Do
						If Not FMergeRows(R2 + 1) Then Exit Do
						Dim OkDown As Boolean = True
						Dim t As Long
						For t = cc To C2
							If CellsEqual(r, cc, R2 + 1, t) = False Then OkDown = False : Exit For
						Next t
						If OkDown = False Then Exit Do
						R2 += 1
					Loop
				End If
				Dim i2 As Long, j2 As Long
				For i2 = r To R2
					For j2 = cc To C2
						Dim kk As Long = (i2 * FCols + j2) * 4
						If MergeCache(kk) = -1 Then
							MergeCache(kk + 0) = r : MergeCache(kk + 1) = cc
							MergeCache(kk + 2) = R2 : MergeCache(kk + 3) = C2
						End If
					Next j2
				Next i2
			Next cc
		Next r
	End Sub

	Sub GridDataEx.GetMergedRange(ByVal aRow As Long, ByVal aCol As Long, ByRef R1 As Long, ByRef C1 As Long, ByRef R2 As Long, ByRef C2 As Long)
		R1 = aRow : C1 = aCol : R2 = aRow : C2 = aCol
		If FMergeCells = FlexMergeCellsNever Then Exit Sub
		If FMergeDirty Then BuildMergeCache
		If aRow < 0 OrElse aCol < 0 OrElse aRow > FRows - 1 OrElse aCol > FCols - 1 Then Exit Sub
		Dim k As Long = (aRow * FCols + aCol) * 4
		'-1 marks an unmerged cell in the cache; keep the identity range for
		'them (otherwise empty cells would look like merge slaves and would
		'not be drawn at all).
		If MergeCache(k + 0) < 0 Then Exit Sub
		R1 = MergeCache(k + 0) : C1 = MergeCache(k + 1)
		R2 = MergeCache(k + 2) : C2 = MergeCache(k + 3)
	End Sub

	Function GridDataEx.IsMergeMaster(ByVal aRow As Long, ByVal aCol As Long) As Boolean
		Dim As Long R1, C1, R2, C2
		GetMergedRange(aRow, aCol, R1, C1, R2, C2)
		Return (aRow = R1) AndAlso (aCol = C1) AndAlso ((R1 <> R2) OrElse (C1 <> C2))
	End Function

	Function GridDataEx.IsMergeSlave(ByVal aRow As Long, ByVal aCol As Long) As Boolean
		Dim As Long R1, C1, R2, C2
		GetMergedRange(aRow, aCol, R1, C1, R2, C2)
		Return (aRow <> R1) OrElse (aCol <> C1)
	End Function

	'=== Frozen rows / columns ===

	Property GridDataEx.FrozenRows As Long
		Return FFrozenRows
	End Property

	Property GridDataEx.FrozenRows(ByVal Value As Long)
		Value = Max(0, Min(Value, FRows - FFixedRows))
		If Value = FFrozenRows Then Exit Property
		FFrozenRows = Value
		FTopRow = Max(FTopRow, FFixedRows + FFrozenRows)
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.FrozenCols As Long
		Return FFrozenCols
	End Property

	Property GridDataEx.FrozenCols(ByVal Value As Long)
		Value = Max(0, Min(Value, FCols - FFixedCols))
		If Value = FFrozenCols Then Exit Property
		FFrozenCols = Value
		FLeftCol = Max(FLeftCol, FFixedCols + FFrozenCols)
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	'=== Border / grid line styles ===

	Property GridDataEx.BorderStyle As Integer
		Return FBorderStyle
	End Property

	Property GridDataEx.BorderStyle(ByVal Value As Integer)
		If Value = FBorderStyle Then Exit Property
		FBorderStyle = Value
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.GridLinesFixed As Integer
		Return FGridLinesFixed
	End Property

	Property GridDataEx.GridLinesFixed(ByVal Value As Integer)
		FGridLinesFixed = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.GridLinesFrozen As Integer
		If FGridLinesFrozen < 0 Then Return FGridLinesFixed
		Return FGridLinesFrozen
	End Property

	Property GridDataEx.GridLinesFrozen(ByVal Value As Integer)
		FGridLinesFrozen = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	'=== Color properties ===

	Property GridDataEx.GridColorFixed As Long
		Return FGridColorFixed
	End Property

	Property GridDataEx.GridColorFixed(ByVal Value As Long)
		FColorsCustomized = True
		FGridColorFixed = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.GridColorFrozen As Long
		Return FGridColorFrozen
	End Property

	Property GridDataEx.GridColorFrozen(ByVal Value As Long)
		FColorsCustomized = True
		FGridColorFrozen = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.BackColorAlt As Long
		Return FBackColorAlt
	End Property

	Property GridDataEx.BackColorAlt(ByVal Value As Long)
		FColorsCustomized = True
		FBackColorAlt = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.BackColorFixed As Long
		Return FBackColorFixed
	End Property

	Property GridDataEx.BackColorFixed(ByVal Value As Long)
		FColorsCustomized = True
		FBackColorFixed = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.BackColorSel As Long
		Return FBackColorSel
	End Property

	Property GridDataEx.BackColorSel(ByVal Value As Long)
		FColorsCustomized = True
		FBackColorSel = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.ForeColorFixed As Long
		Return FForeColorFixed
	End Property

	Property GridDataEx.ForeColorFixed(ByVal Value As Long)
		FColorsCustomized = True
		FForeColorFixed = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.ForeColorSel As Long
		Return FForeColorSel
	End Property

	Property GridDataEx.ForeColorSel(ByVal Value As Long)
		FColorsCustomized = True
		FForeColorSel = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.SortArrowColor As Long
		Return FSortArrowColor
	End Property

	Property GridDataEx.SortArrowColor(ByVal Value As Long)
		FColorsCustomized = True
		FSortArrowColor = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.FloodColor As Long
		Return FFloodColor
	End Property

	Property GridDataEx.FloodColor(ByVal Value As Long)
		FColorsCustomized = True
		FFloodColor = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.InsertMarkColor As Long
		Return FInsertMarkColor
	End Property

	Property GridDataEx.InsertMarkColor(ByVal Value As Long)
		FColorsCustomized = True
		FInsertMarkColor = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	'=== Text style ===

	Property GridDataEx.TextStyle As Integer
		Return FTextStyle
	End Property

	Property GridDataEx.TextStyle(ByVal Value As Integer)
		FTextStyle = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.TextStyleFixed As Integer
		Return FTextStyleFixed
	End Property

	Property GridDataEx.TextStyleFixed(ByVal Value As Integer)
		FTextStyleFixed = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	'=== Highlight / focus / wrap ===

	Property GridDataEx.HighLight As Integer
		Return FHighLight
	End Property

	Property GridDataEx.HighLight(ByVal Value As Integer)
		FHighLight = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.FocusRect As Integer
		Return FFocusRect
	End Property

	Property GridDataEx.FocusRect(ByVal Value As Integer)
		FFocusRect = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.WordWrap As Boolean
		Return FWordWrap
	End Property

	Property GridDataEx.WordWrap(ByVal Value As Boolean)
		FWordWrap = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.SingleLine As Boolean
		Return FSingleLine
	End Property

	Property GridDataEx.SingleLine(ByVal Value As Boolean)
		FSingleLine = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.EllipsisFormat As Integer
		Return FEllipsisFormat
	End Property

	Property GridDataEx.EllipsisFormat(ByVal Value As Integer)
		FEllipsisFormat = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.EllipsisFormatFixed As Integer
		Return FEllipsisFormatFixed
	End Property

	Property GridDataEx.EllipsisFormatFixed(ByVal Value As Integer)
		FEllipsisFormatFixed = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	'=== Redraw / buffering / visual styles ===

	Property GridDataEx.Redraw As Boolean
		Return FRedraw
	End Property

	Property GridDataEx.Redraw(ByVal Value As Boolean)
		FRedraw = Value
		#ifdef __USE_WINAPI__
			If Handle <> 0 Then FlexSetWindowRedraw(Handle, Value)
		#endif
		If Value AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.DoubleBuffer As Boolean
		Return FDoubleBuffer
	End Property

	Property GridDataEx.DoubleBuffer(ByVal Value As Boolean)
		FDoubleBuffer = Value
		#ifdef __USE_WINAPI__
			DoubleBuffered = Value
		#endif
	End Property

	Property GridDataEx.VisualStyles As Boolean
		Return FVisualStyles
	End Property

	Property GridDataEx.VisualStyles(ByVal Value As Boolean)
		FVisualStyles = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.FontQuality As Integer
		Return FFontQuality
	End Property

	Property GridDataEx.FontQuality(ByVal Value As Integer)
		FFontQuality = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	'=== Behavior flags ===

	Property GridDataEx.AllowBigSelection As Boolean
		Return FAllowBigSelection
	End Property

	Property GridDataEx.AllowBigSelection(ByVal Value As Boolean)
		FAllowBigSelection = Value
	End Property

	Property GridDataEx.AllowSelection As Boolean
		Return FAllowSelection
	End Property

	Property GridDataEx.AllowSelection(ByVal Value As Boolean)
		FAllowSelection = Value
	End Property

	Property GridDataEx.AllowMultiSelection As Boolean
		Return FAllowMultiSelection
	End Property

	Property GridDataEx.AllowMultiSelection(ByVal Value As Boolean)
		FAllowMultiSelection = Value
		If Value = False Then
			'Drop all non-contiguous row marks.
			Dim i As Long
			For i = 0 To FRows - 1
				RowsArr(i).State And= Not FLEX_RWIS_SELECTED
			Next i
			If FRedraw AndAlso Handle <> 0 Then RepaintGrid
		End If
	End Property

	Property GridDataEx.AllowUserEditing As Boolean
		Return FAllowUserEditing
	End Property

	Property GridDataEx.AllowUserEditing(ByVal Value As Boolean)
		FAllowUserEditing = Value
	End Property

	Property GridDataEx.AllowUserFreezing As Integer
		Return FAllowUserFreezing
	End Property

	Property GridDataEx.AllowUserFreezing(ByVal Value As Integer)
		FAllowUserFreezing = Value
	End Property

	Property GridDataEx.AllowIncrementalSearch As Boolean
		Return FAllowIncrementalSearch
	End Property

	Property GridDataEx.AllowIncrementalSearch(ByVal Value As Boolean)
		FAllowIncrementalSearch = Value
		If Value = False Then FIncrSearchActive = False
	End Property

	Property GridDataEx.SelectionMode As Integer
		Return FSelectionMode
	End Property

	Property GridDataEx.SelectionMode(ByVal Value As Integer)
		FSelectionMode = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.FillStyle As Integer
		Return FFillStyle
	End Property

	Property GridDataEx.FillStyle(ByVal Value As Integer)
		FFillStyle = Value
	End Property

	Property GridDataEx.ScrollBars As Integer
		Return FScrollBars
	End Property

	Property GridDataEx.ScrollBars(ByVal Value As Integer)
		FScrollBars = Value
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.ScrollTrack As Boolean
		Return FScrollTrack
	End Property

	Property GridDataEx.ScrollTrack(ByVal Value As Boolean)
		FScrollTrack = Value
	End Property

	Property GridDataEx.ScrollTipFollowThumb As Boolean
		Return FScrollTipFollowThumb
	End Property

	Property GridDataEx.ScrollTipFollowThumb(ByVal Value As Boolean)
		FScrollTipFollowThumb = Value
	End Property

	Property GridDataEx.DisableNoScroll As Boolean
		Return FDisableNoScroll
	End Property

	Property GridDataEx.DisableNoScroll(ByVal Value As Boolean)
		FDisableNoScroll = Value
		SetScrollBarsInternal
	End Property

	Property GridDataEx.RowSizingMode As Integer
		Return FRowSizingMode
	End Property

	Property GridDataEx.RowSizingMode(ByVal Value As Integer)
		FRowSizingMode = Value
	End Property

	Property GridDataEx.TabBehavior As Integer
		Return FTabBehavior
	End Property

	Property GridDataEx.TabBehavior(ByVal Value As Integer)
		FTabBehavior = Value
	End Property

	Property GridDataEx.DirectionAfterReturn As Integer
		Return FDirectionAfterReturn
	End Property

	Property GridDataEx.DirectionAfterReturn(ByVal Value As Integer)
		FDirectionAfterReturn = Value
	End Property

	Property GridDataEx.WrapCellBehavior As Integer
		Return FWrapCellBehavior
	End Property

	Property GridDataEx.WrapCellBehavior(ByVal Value As Integer)
		FWrapCellBehavior = Value
	End Property

	Property GridDataEx.WantReturn As Boolean
		Return FWantReturn
	End Property

	Property GridDataEx.WantReturn(ByVal Value As Boolean)
		FWantReturn = Value
	End Property

	Property GridDataEx.ExtendLastCol As Boolean
		Return FExtendLastCol
	End Property

	Property GridDataEx.ExtendLastCol(ByVal Value As Boolean)
		FExtendLastCol = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.SheetBorder As Boolean
		Return FSheetBorder
	End Property

	Property GridDataEx.SheetBorder(ByVal Value As Boolean)
		FSheetBorder = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.BestFitMode As Integer
		Return FBestFitMode
	End Property

	Property GridDataEx.BestFitMode(ByVal Value As Integer)
		FBestFitMode = Value
	End Property

	Property GridDataEx.MultiSelChangeTime As Long
		Return FMultiSelChangeTime
	End Property

	Property GridDataEx.MultiSelChangeTime(ByVal Value As Long)
		FMultiSelChangeTime = Max(0, Value)
	End Property

	Property GridDataEx.WheelScrollLines As Long
		Return FWheelScrollLines
	End Property

	Property GridDataEx.WheelScrollLines(ByVal Value As Long)
		FWheelScrollLines = Max(1, Value)
	End Property

	Property GridDataEx.RowHeightMin As Long
		Return FRowHeightMin
	End Property

	Property GridDataEx.RowHeightMin(ByVal Value As Long)
		FRowHeightMin = Max(0, Value)
	End Property

	Property GridDataEx.RowHeightMax As Long
		Return FRowHeightMax
	End Property

	Property GridDataEx.RowHeightMax(ByVal Value As Long)
		FRowHeightMax = Max(0, Value)
	End Property

	Property GridDataEx.ColWidthMin As Long
		Return FColWidthMin
	End Property

	Property GridDataEx.ColWidthMin(ByVal Value As Long)
		FColWidthMin = Max(0, Value)
	End Property

	Property GridDataEx.ColWidthMax As Long
		Return FColWidthMax
	End Property

	Property GridDataEx.ColWidthMax(ByVal Value As Long)
		FColWidthMax = Max(0, Value)
	End Property

	'=== Row / column metrics (twips like VB6) ===

	Property GridDataEx.RowPos(ByVal aIndex As Long) As Long
		If aIndex < 0 OrElse aIndex > FRows - 1 Then Return 0
		Return RowTopY(aIndex) * CLng(TwipsPerPixelY())
	End Property

	Property GridDataEx.ColPos(ByVal aIndex As Long) As Long
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return 0
		Return ColLeftX(aIndex) * CLng(TwipsPerPixelX())
	End Property

	Property GridDataEx.RowPosition(ByVal aIndex As Long) As Long
		'Returns the ordinal position of the row (identity mapping; rows are stored in display order).
		If aIndex < 0 OrElse aIndex > FRows - 1 Then Return -1
		Return aIndex
	End Property

	Property GridDataEx.RowPosition(ByVal aIndex As Long, ByVal Value As Long)
		'Moves row aIndex to position Value by rotating the contents.
		If aIndex < 0 OrElse aIndex > FRows - 1 Then Exit Property
		Value = Max(0, Min(Value, FRows - 1))
		If Value = aIndex Then Exit Property
		Dim j As Long, i As Long, StepDir As Long = IIf(Value > aIndex, 1, -1)
		For i = aIndex To Value - StepDir Step StepDir
			For j = 0 To FCols - 1
				Swap CellsArr(i * FCols + j), CellsArr((i + StepDir) * FCols + j)
			Next j
			Swap RowsArr(i), RowsArr(i + StepDir)
		Next i
		InvalidateMergeCache
		InvalidateRowGeometry
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.ColPosition(ByVal aIndex As Long) As Long
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return -1
		Return aIndex
	End Property

	Property GridDataEx.ColPosition(ByVal aIndex As Long, ByVal Value As Long)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		Value = Max(0, Min(Value, FCols - 1))
		If Value = aIndex Then Exit Property
		Dim i As Long, j As Long, StepDir As Long = IIf(Value > aIndex, 1, -1)
		For j = aIndex To Value - StepDir Step StepDir
			For i = 0 To FRows - 1
				Swap CellsArr(i * FCols + j), CellsArr(i * FCols + (j + StepDir))
			Next i
			Swap ColsArr(j), ColsArr(j + StepDir)
		Next j
		InvalidateMergeCache
		InvalidateColGeometry
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.RowHeightUniform As Long
		'Returns the height of the first scrollable row.
		If FRows - FFixedRows > 0 Then Return RowHeight(FFixedRows)
		Return DefaultRowHeight
	End Property

	Property GridDataEx.RowHeightUniform(ByVal Value As Long)
		'Sets all scrollable rows to the same height.
		Dim i As Long
		For i = FFixedRows To FRows - 1
			RowHeight(i) = Value
		Next i
	End Property

	'=== Row info API ===

	Property GridDataEx.RowHidden(ByVal aIndex As Long) As Boolean
		If aIndex < 0 OrElse aIndex > FRows - 1 Then Return False
		Return CBool((RowsArr(aIndex).State And FLEX_RWIS_HIDDEN) <> 0)
	End Property

	Property GridDataEx.RowHidden(ByVal aIndex As Long, ByVal Value As Boolean)
		If aIndex < 0 OrElse aIndex > FRows - 1 Then Exit Property
		If Value Then
			RowsArr(aIndex).State Or= FLEX_RWIS_HIDDEN
		Else
			RowsArr(aIndex).State And= Not FLEX_RWIS_HIDDEN
		End If
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.RowSelected(ByVal aIndex As Long) As Boolean
		If aIndex < 0 OrElse aIndex > FRows - 1 Then Return False
		Return CBool((RowsArr(aIndex).State And FLEX_RWIS_SELECTED) <> 0)
	End Property

	Property GridDataEx.RowSelected(ByVal aIndex As Long, ByVal Value As Boolean)
		If aIndex < 0 OrElse aIndex > FRows - 1 Then Exit Property
		Dim As Boolean OldState = CBool((RowsArr(aIndex).State And FLEX_RWIS_SELECTED) <> 0)
		If OldState = Value Then Exit Property
		If Value Then
			RowsArr(aIndex).State Or= FLEX_RWIS_SELECTED
		Else
			RowsArr(aIndex).State And= Not FLEX_RWIS_SELECTED
		End If
		If OnMultiSelChange Then OnMultiSelChange(*Designer, This)
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.SelectedRow(ByVal aIndex As Long) As Long
		'Returns the row index of the aIndex-th (0-based) selected row.
		Dim i As Long, Count As Long = 0
		For i = 0 To FRows - 1
			If (RowsArr(i).State And FLEX_RWIS_SELECTED) <> 0 Then
				If Count = aIndex Then Return i
				Count += 1
			End If
		Next i
		Return -1
	End Property

	Property GridDataEx.SelectedRows As Long
		Dim i As Long, Count As Long = 0
		For i = 0 To FRows - 1
			If (RowsArr(i).State And FLEX_RWIS_SELECTED) <> 0 Then Count += 1
		Next i
		Return Count
	End Property

	Property GridDataEx.RowData(ByVal aIndex As Long) As Any Ptr
		If aIndex < 0 OrElse aIndex > FRows - 1 Then Return 0
		Return RowsArr(aIndex).Data
	End Property

	Property GridDataEx.RowData(ByVal aIndex As Long, ByVal Value As Any Ptr)
		If aIndex < 0 OrElse aIndex > FRows - 1 Then Exit Property
		RowsArr(aIndex).Data = Value
	End Property

	Property GridDataEx.RowID(ByVal aIndex As Long) As Long
		If aIndex < 0 OrElse aIndex > FRows - 1 Then Return -1
		Return RowsArr(aIndex).ID
	End Property

	Property GridDataEx.RowID(ByVal aIndex As Long, ByVal Value As Long)
		If aIndex < 0 OrElse aIndex > FRows - 1 Then Exit Property
		RowsArr(aIndex).ID = Value
	End Property

	Property GridDataEx.RowIndex(ByVal ID As Long) As Long
		'Finds the row whose RowID equals ID, -1 when absent.
		Dim i As Long
		For i = 0 To FRows - 1
			If RowsArr(i).ID = ID Then Return i
		Next i
		Return -1
	End Property

	Property GridDataEx.RowResizable(ByVal aIndex As Long) As Boolean
		If aIndex < 0 OrElse aIndex > FRows - 1 Then Return False
		Return CBool((RowsArr(aIndex).State And FLEX_RWIS_NOSIZING) = 0)
	End Property

	Property GridDataEx.RowResizable(ByVal aIndex As Long, ByVal Value As Boolean)
		If aIndex < 0 OrElse aIndex > FRows - 1 Then Exit Property
		If Value Then
			RowsArr(aIndex).State And= Not FLEX_RWIS_NOSIZING
		Else
			RowsArr(aIndex).State Or= FLEX_RWIS_NOSIZING
		End If
	End Property

	Function GridDataEx.RowIsVisible(ByVal aIndex As Long, ByVal Visibility As Integer = FlexVisibilityCompleteOnly) As Boolean
		If aIndex < 0 OrElse aIndex > FRows - 1 Then Return False
		If (RowsArr(aIndex).State And FLEX_RWIS_HIDDEN) <> 0 Then Return False
		'CompleteOnly requires the row to fit fully between the fixed area and the client bottom.
		Dim As Long AreaTop = RowTopY(FFixedRows + FFrozenRows)
		Dim As Long AreaBottom = ClientHeightPx() - FilterBarHeightPx()
		Dim As Long RowT = RowTopY(aIndex), RowB = RowTopY(aIndex + 1)
		If RowT < AreaTop OrElse RowT >= AreaBottom Then Return False
		If Visibility = FlexVisibilityCompleteOnly AndAlso RowB > AreaBottom Then Return False
		Return True
	End Function

	Function GridDataEx.RowsVisible(ByVal Visibility As Integer = FlexVisibilityCompleteOnly) As Long
		Dim i As Long, Count As Long = 0
		For i = FTopRow To FRows - 1
			If RowIsVisible(i, Visibility) = False AndAlso i > FTopRow Then Exit For
			Count += 1
		Next i
		Return Count
	End Function

	Function GridDataEx.FixedRowsVisible(ByVal Visibility As Integer = FlexVisibilityCompleteOnly) As Long
		Dim i As Long, Count As Long = 0
		For i = 0 To FFixedRows - 1
			Count += 1
		Next i
		Return Count
	End Function

	Function GridDataEx.FrozenRowsVisible(ByVal Visibility As Integer = FlexVisibilityCompleteOnly) As Long
		Dim i As Long, Count As Long = 0
		For i = FFixedRows To FFixedRows + FFrozenRows - 1
			Count += 1
		Next i
		Return Count
	End Function

	Property GridDataEx.RowsPerPage As Long
		Dim As Long FixedH = 0, i
		For i = 0 To FFixedRows + FFrozenRows - 1
			FixedH += GetRowHeightPx(i)
		Next i
		Return Max(1, (ClientHeightPx() - FixedH - FilterBarHeightPx()) \ GetDefaultRowHeightPx())
	End Property

	'=== Column info API ===

	Property GridDataEx.ColHidden(ByVal aIndex As Long) As Boolean
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return False
		Return CBool((ColsArr(aIndex).State And FLEX_CLIS_HIDDEN) <> 0)
	End Property

	Property GridDataEx.ColHidden(ByVal aIndex As Long, ByVal Value As Boolean)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		If Value Then
			ColsArr(aIndex).State Or= FLEX_CLIS_HIDDEN
		Else
			ColsArr(aIndex).State And= Not FLEX_CLIS_HIDDEN
		End If
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.ColKey(ByVal aIndex As Long) ByRef As WString
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return ""
		If ColsArr(aIndex).Key = 0 Then Return ""
		Return *ColsArr(aIndex).Key
	End Property

	Property GridDataEx.ColKey(ByVal aIndex As Long, ByRef Value As WString)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		WLet(ColsArr(aIndex).Key, Value)
	End Property

	Property GridDataEx.ColIndex(ByRef Key As WString) As Long
		Dim j As Long
		For j = 0 To FCols - 1
			If ColsArr(j).Key <> 0 AndAlso *ColsArr(j).Key = Key Then Return j
		Next j
		Return -1
	End Property

	Function GridDataEx.ColIsVisible(ByVal aIndex As Long, ByVal Visibility As Integer = FlexVisibilityCompleteOnly) As Boolean
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return False
		If (ColsArr(aIndex).State And FLEX_CLIS_HIDDEN) <> 0 Then Return False
		Dim As Long AreaLeft = ColLeftX(FFixedCols + FFrozenCols)
		Dim As Long AreaRight = ClientWidthPx()
		Dim As Long ColL = ColLeftX(aIndex), ColR = ColLeftX(aIndex + 1)
		If ColL < AreaLeft OrElse ColL >= AreaRight Then Return False
		If Visibility = FlexVisibilityCompleteOnly AndAlso ColR > AreaRight Then Return False
		Return True
	End Function

	Function GridDataEx.ColsVisible(ByVal Visibility As Integer = FlexVisibilityCompleteOnly) As Long
		Dim j As Long, Count As Long = 0
		For j = FLeftCol To FCols - 1
			If ColIsVisible(j, Visibility) = False AndAlso j > FLeftCol Then Exit For
			Count += 1
		Next j
		Return Count
	End Function

	Function GridDataEx.FixedColsVisible(ByVal Visibility As Integer = FlexVisibilityCompleteOnly) As Long
		Return FFixedCols
	End Function

	Function GridDataEx.FrozenColsVisible(ByVal Visibility As Integer = FlexVisibilityCompleteOnly) As Long
		Return FFrozenCols
	End Function

	Property GridDataEx.ColsPerPage As Long
		Dim As Long FixedW = 0, j
		For j = 0 To FFixedCols + FFrozenCols - 1
			FixedW += GetColWidthPx(j)
		Next j
		Return Max(1, (ClientWidthPx() - FixedW) \ GetDefaultColWidthPx())
	End Property

	Property GridDataEx.ColData(ByVal aIndex As Long) As Any Ptr
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return 0
		Return ColsArr(aIndex).Data
	End Property

	Property GridDataEx.ColData(ByVal aIndex As Long, ByVal Value As Any Ptr)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		ColsArr(aIndex).Data = Value
	End Property

	Property GridDataEx.ColAlignment(ByVal aIndex As Long) As Integer
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return FlexAlignmentGeneral
		Return ColsArr(aIndex).Alignment
	End Property

	Property GridDataEx.ColAlignment(ByVal aIndex As Long, ByVal Value As Integer)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		ColsArr(aIndex).Alignment = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.FixedAlignment(ByVal aIndex As Long) As Integer
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return FlexAlignmentGeneral
		Return ColsArr(aIndex).FixedAlignment
	End Property

	Property GridDataEx.FixedAlignment(ByVal aIndex As Long, ByVal Value As Integer)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		ColsArr(aIndex).FixedAlignment = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.ColWordWrapOption(ByVal aIndex As Long) As Integer
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return FlexWordWrapNone
		Return ColsArr(aIndex).WordWrapOption
	End Property

	Property GridDataEx.ColWordWrapOption(ByVal aIndex As Long, ByVal Value As Integer)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		ColsArr(aIndex).WordWrapOption = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.ColWordWrapOptionFixed(ByVal aIndex As Long) As Integer
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return FlexWordWrapNone
		Return ColsArr(aIndex).WordWrapOptionFixed
	End Property

	Property GridDataEx.ColWordWrapOptionFixed(ByVal aIndex As Long, ByVal Value As Integer)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		ColsArr(aIndex).WordWrapOptionFixed = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.ColSort(ByVal aIndex As Long) As Integer
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return FlexSortNone
		Return ColsArr(aIndex).Sort
	End Property

	Property GridDataEx.ColSort(ByVal aIndex As Long, ByVal Value As Integer)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		ColsArr(aIndex).Sort = Value
	End Property

	Property GridDataEx.ColSortMode(ByVal aIndex As Long) As Integer
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return FlexSortModeNormal
		Return ColsArr(aIndex).SortMode
	End Property

	Property GridDataEx.ColSortMode(ByVal aIndex As Long, ByVal Value As Integer)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		ColsArr(aIndex).SortMode = Value
	End Property

	Property GridDataEx.ColSortArrow(ByVal aIndex As Long) As Integer
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return FlexSortArrowNone
		Return ColsArr(aIndex).SortArrow
	End Property

	Property GridDataEx.ColSortArrow(ByVal aIndex As Long, ByVal Value As Integer)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		ColsArr(aIndex).SortArrow = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.ColSortArrowAlignment(ByVal aIndex As Long) As Integer
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return FlexLeftRightAlignmentRight
		Return ColsArr(aIndex).SortArrowAlignment
	End Property

	Property GridDataEx.ColSortArrowAlignment(ByVal aIndex As Long, ByVal Value As Integer)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		ColsArr(aIndex).SortArrowAlignment = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.ColSortArrowColor(ByVal aIndex As Long) As Long
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return -1
		Return ColsArr(aIndex).SortArrowColor
	End Property

	Property GridDataEx.ColSortArrowColor(ByVal aIndex As Long, ByVal Value As Long)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		ColsArr(aIndex).SortArrowColor = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.ColComboCue(ByVal aIndex As Long) As Integer
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return FlexComboCueNone
		Return ColsArr(aIndex).ComboCue
	End Property

	Property GridDataEx.ColComboCue(ByVal aIndex As Long, ByVal Value As Integer)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		ColsArr(aIndex).ComboCue = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.ColComboMode(ByVal aIndex As Long) As Integer
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return FlexComboModeNone
		Return ColsArr(aIndex).ComboMode
	End Property

	Property GridDataEx.ColComboMode(ByVal aIndex As Long, ByVal Value As Integer)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		ColsArr(aIndex).ComboMode = Value
		'Combo columns imply a combo cue.
		If Value <> FlexComboModeNone AndAlso ColsArr(aIndex).ComboCue = FlexComboCueNone Then
			Select Case Value
				Case FlexComboModeButton : ColsArr(aIndex).ComboCue = FlexComboCueButton
				Case FlexComboModeCalculator : ColsArr(aIndex).ComboCue = FlexComboCueButton
				Case Else : ColsArr(aIndex).ComboCue = FlexComboCueDropDown
			End Select
		End If
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.ColComboItems(ByVal aIndex As Long) ByRef As WString
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return ""
		If ColsArr(aIndex).ComboItems = 0 Then Return ""
		Return *ColsArr(aIndex).ComboItems
	End Property

	Property GridDataEx.ColComboItems(ByVal aIndex As Long, ByRef Value As WString)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		'Normalize: items are stored CR separated; "|", CRLF and LF are
		'accepted input ("|" matches the VB6 separator).
		Dim As UString Norm = Value
		Norm = Replace(Norm, "|", Chr(13))
		Norm = Replace(Norm, Chr(13) & Chr(10), Chr(13))
		Norm = Replace(Norm, Chr(10), Chr(13))
		WLet(ColsArr(aIndex).ComboItems, Norm)
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.ColComboHeader(ByVal aIndex As Long) ByRef As WString
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return ""
		If ColsArr(aIndex).ComboHeader = 0 Then Return ""
		Return *ColsArr(aIndex).ComboHeader
	End Property

	Property GridDataEx.ColComboHeader(ByVal aIndex As Long, ByRef Value As WString)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		WLet(ColsArr(aIndex).ComboHeader, Value)
	End Property

	Property GridDataEx.ColComboBoundColumn(ByVal aIndex As Long) As Long
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return -1
		Return ColsArr(aIndex).ComboBoundColumn
	End Property

	Property GridDataEx.ColComboBoundColumn(ByVal aIndex As Long, ByVal Value As Long)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		ColsArr(aIndex).ComboBoundColumn = Value
	End Property

	'=== Current-cell combo access ===

	Property GridDataEx.ComboMode As Integer
		If FCol < 0 OrElse FCol > FCols - 1 Then Return FlexComboModeNone
		Return ColsArr(FCol).ComboMode
	End Property

	Property GridDataEx.ComboMode(ByVal Value As Integer)
		ColComboMode(FCol) = Value
	End Property

	Property GridDataEx.ComboCue As Integer
		If FCol < 0 OrElse FCol > FCols - 1 Then Return FlexComboCueNone
		Return ColsArr(FCol).ComboCue
	End Property

	Property GridDataEx.ComboCue(ByVal Value As Integer)
		ColComboCue(FCol) = Value
	End Property

	Property GridDataEx.ComboItems ByRef As WString
		Return ColComboItems(FCol)
	End Property

	Property GridDataEx.ComboItems(ByRef Value As WString)
		ColComboItems(FCol) = Value
	End Property

	Property GridDataEx.ComboListCount As Long
		Dim As UString Items = ColComboItems(FCol)
		If Len(Items) = 0 Then Return 0
		Dim As Long Count = 1, P = 1
		Do
			P = InStr(P, Items, Chr(13))
			If P = 0 Then Exit Do
			Count += 1
			P += 1
		Loop
		Return Count
	End Property

	Property GridDataEx.ComboListIndex As Long
		'Index of the current cell text within the column combo items.
		Dim As UString Items = ColComboItems(FCol)
		Dim As UString CurText = TextMatrix(FRow, FCol)
		If Len(Items) = 0 OrElse Len(CurText) = 0 Then Return -1
		Dim As Long P = 1, Idx = 0
		Do While P <= Len(Items)
			Dim As UString Chunk = Mid(Items, P)
			Dim As Long CR = InStr(Chunk, Chr(13))
			Dim As UString One
			If CR > 0 Then One = Mid(Chunk, 1, CR - 1) Else One = Chunk
			If One = CurText Then Return Idx
			Idx += 1
			If CR = 0 Then Exit Do
			P += CR
		Loop
		Return -1
	End Property

	Property GridDataEx.ComboListIndex(ByVal Value As Long)
		'Writes the requested combo item into the current cell.
		Dim As UString Items = ColComboItems(FCol)
		If Len(Items) = 0 OrElse Value < 0 Then Exit Property
		Dim As Long P = 1, Idx = 0
		Do While P <= Len(Items)
			Dim As UString Chunk = Mid(Items, P)
			Dim As Long CR = InStr(Chunk, Chr(13))
			Dim As UString One
			If CR > 0 Then One = Mid(Chunk, 1, CR - 1) Else One = Chunk
			If Idx = Value Then
				TextMatrix(FRow, FCol, ComboItemValue(One))
				Exit Do
			End If
			Idx += 1
			If CR = 0 Then Exit Do
			P += CR
		Loop
	End Property

	Property GridDataEx.ComboDropped As Boolean
		Return FComboDropped
	End Property

	Property GridDataEx.ColCheckBoxes(ByVal aIndex As Long) As Boolean
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return False
		Return CBool((ColsArr(aIndex).State And FLEX_CLIS_CHECKBOXES) <> 0)
	End Property

	Property GridDataEx.ColCheckBoxes(ByVal aIndex As Long, ByVal Value As Boolean)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		If Value Then
			ColsArr(aIndex).State Or= FLEX_CLIS_CHECKBOXES
		Else
			ColsArr(aIndex).State And= Not FLEX_CLIS_CHECKBOXES
		End If
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.ColResizable(ByVal aIndex As Long) As Boolean
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return False
		Return CBool((ColsArr(aIndex).State And FLEX_CLIS_NOSIZING) = 0)
	End Property

	Property GridDataEx.ColResizable(ByVal aIndex As Long, ByVal Value As Boolean)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		If Value Then
			ColsArr(aIndex).State And= Not FLEX_CLIS_NOSIZING
		Else
			ColsArr(aIndex).State Or= FLEX_CLIS_NOSIZING
		End If
	End Property

	Property GridDataEx.ColNullable(ByVal aIndex As Long) As Boolean
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return False
		Return CBool((ColsArr(aIndex).State And FLEX_CLIS_NULLABLE) <> 0)
	End Property

	Property GridDataEx.ColNullable(ByVal aIndex As Long, ByVal Value As Boolean)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		If Value Then
			ColsArr(aIndex).State Or= FLEX_CLIS_NULLABLE
		Else
			ColsArr(aIndex).State And= Not FLEX_CLIS_NULLABLE
		End If
	End Property

	Property GridDataEx.ColDataType(ByVal aIndex As Long) As Integer
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return 0
		Return ColsArr(aIndex).DataType
	End Property

	Property GridDataEx.ColDataType(ByVal aIndex As Long, ByVal Value As Integer)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		ColsArr(aIndex).DataType = Value
	End Property

	Property GridDataEx.ColNumericPrecision(ByVal aIndex As Long) As UByte
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return 0
		Return ColsArr(aIndex).NumericPrecision
	End Property

	Property GridDataEx.ColNumericPrecision(ByVal aIndex As Long, ByVal Value As UByte)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		ColsArr(aIndex).NumericPrecision = Value
	End Property

	Property GridDataEx.ColNumericScale(ByVal aIndex As Long) As UByte
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return 0
		Return ColsArr(aIndex).NumericScale
	End Property

	Property GridDataEx.ColNumericScale(ByVal aIndex As Long, ByVal Value As UByte)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		ColsArr(aIndex).NumericScale = Value
	End Property

	Property GridDataEx.ColDataCapacity(ByVal aIndex As Long) As Long
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return 0
		Return ColsArr(aIndex).DataCapacity
	End Property

	Property GridDataEx.ColDataCapacity(ByVal aIndex As Long, ByVal Value As Long)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		ColsArr(aIndex).DataCapacity = Value
	End Property

	Sub GridDataEx.ClearRowInfo(ByVal aIndex As Long)
		If aIndex < 0 OrElse aIndex > FRows - 1 Then Exit Sub
		RowsArr(aIndex).Height = -1
		RowsArr(aIndex).State = 0
		RowsArr(aIndex).ID = -1
		RowsArr(aIndex).Data = 0
		InvalidateRowGeometry
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Sub

	Sub GridDataEx.ClearColInfo(ByVal aIndex As Long)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Sub
		ColsArr(aIndex).Width = -1
		ColsArr(aIndex).State = 0
		WDeAllocate(ColsArr(aIndex).Key)
		ColsArr(aIndex).Key = 0
		ColsArr(aIndex).Alignment = FlexAlignmentGeneral
		ColsArr(aIndex).FixedAlignment = -1
		ColsArr(aIndex).WordWrapOption = -1
		ColsArr(aIndex).WordWrapOptionFixed = -1
		ColsArr(aIndex).Sort = FlexSortNone
		ColsArr(aIndex).SortArrow = FlexSortArrowNone
		ColsArr(aIndex).SortArrowColor = -1
		ColsArr(aIndex).ComboCue = FlexComboCueNone
		ColsArr(aIndex).ComboMode = FlexComboModeNone
		ColsArr(aIndex).Data = 0
		WDeAllocate(ColsArr(aIndex).ComboItems)
		ColsArr(aIndex).ComboItems = 0
		WDeAllocate(ColsArr(aIndex).ComboHeader)
		ColsArr(aIndex).ComboHeader = 0
		ColsArr(aIndex).ComboBoundColumn = -1
		WDeAllocate(ColsArr(aIndex).Filter)
		ColsArr(aIndex).Filter = 0
		WDeAllocate(ColsArr(aIndex).Lookup)
		ColsArr(aIndex).Lookup = 0
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Sub

	'=== Cell formatting helpers (VB6 CellXxx semantics: current cell + FillStyle) ===

	'Returns the bounds the a CellXxx assignment applies to:
	'the current cell when FillStyle = Single, the whole selection when Repeat.
	Sub GridDataEx.FillStyleRange(ByRef R1 As Long, ByRef C1 As Long, ByRef R2 As Long, ByRef C2 As Long)
		If FFillStyle = FlexFillStyleRepeat AndAlso FAllowSelection Then
			R1 = Min(FRow, FRowSel) : C1 = Min(FCol, FColSel)
			R2 = Max(FRow, FRowSel) : C2 = Max(FCol, FColSel)
		Else
			R1 = FRow : C1 = FCol : R2 = FRow : C2 = FCol
		End If
	End Sub

	Property GridDataEx.CellBackColor As Long
		Dim As FlexCell Ptr C = CellAt(FRow, FCol)
		If C <> 0 AndAlso C->Fmtg <> 0 AndAlso C->Fmtg->BackColor >= 0 Then Return C->Fmtg->BackColor
		Return BackColor
	End Property

	Property GridDataEx.CellBackColor(ByVal Value As Long)
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		FillStyleRange(r1, c1, r2, c2)
		Dim i As Long, j As Long
		For i = r1 To r2
			For j = c1 To c2
				Dim As FlexCellFormat Ptr F = EnsureFmtg(i, j)
				If F <> 0 Then F->BackColor = Value
			Next j
		Next i
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.CellForeColor As Long
		Dim As FlexCell Ptr C = CellAt(FRow, FCol)
		If C <> 0 AndAlso C->Fmtg <> 0 AndAlso C->Fmtg->ForeColor >= 0 Then Return C->Fmtg->ForeColor
		Return ForeColor
	End Property

	Property GridDataEx.CellForeColor(ByVal Value As Long)
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		FillStyleRange(r1, c1, r2, c2)
		Dim i As Long, j As Long
		For i = r1 To r2
			For j = c1 To c2
				Dim As FlexCellFormat Ptr F = EnsureFmtg(i, j)
				If F <> 0 Then F->ForeColor = Value
			Next j
		Next i
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.CellTextStyle As Integer
		Dim As FlexCell Ptr C = CellAt(FRow, FCol)
		If C <> 0 AndAlso C->Fmtg <> 0 AndAlso C->Fmtg->TextStyle >= 0 Then Return C->Fmtg->TextStyle
		Return IIf((FRow < FFixedRows) OrElse (FCol < FFixedCols), FTextStyleFixed, FTextStyle)
	End Property

	Property GridDataEx.CellTextStyle(ByVal Value As Integer)
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		FillStyleRange(r1, c1, r2, c2)
		Dim i As Long, j As Long
		For i = r1 To r2
			For j = c1 To c2
				Dim As FlexCellFormat Ptr F = EnsureFmtg(i, j)
				If F <> 0 Then F->TextStyle = Value
			Next j
		Next i
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.CellAlignment As Integer
		Dim As FlexCell Ptr C = CellAt(FRow, FCol)
		If C <> 0 AndAlso C->Fmtg <> 0 AndAlso C->Fmtg->Alignment >= 0 Then Return C->Fmtg->Alignment
		Return GetCellAlign(FRow, FCol, CBool((FRow < FFixedRows) OrElse (FCol < FFixedCols)))
	End Property

	Property GridDataEx.CellAlignment(ByVal Value As Integer)
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		FillStyleRange(r1, c1, r2, c2)
		Dim i As Long, j As Long
		For i = r1 To r2
			For j = c1 To c2
				Dim As FlexCellFormat Ptr F = EnsureFmtg(i, j)
				If F <> 0 Then F->Alignment = Value
			Next j
		Next i
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.CellPictureAlignment As Integer
		Dim As FlexCell Ptr C = CellAt(FRow, FCol)
		If C <> 0 AndAlso C->Fmtg <> 0 AndAlso C->Fmtg->PictureAlignment >= 0 Then Return C->Fmtg->PictureAlignment
		Return FlexPictureAlignmentCenterCenter
	End Property

	Property GridDataEx.CellPictureAlignment(ByVal Value As Integer)
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		FillStyleRange(r1, c1, r2, c2)
		Dim i As Long, j As Long
		For i = r1 To r2
			For j = c1 To c2
				Dim As FlexCellFormat Ptr F = EnsureFmtg(i, j)
				If F <> 0 Then F->PictureAlignment = Value
			Next j
		Next i
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.CellToolTipText ByRef As WString
		Dim As FlexCell Ptr C = CellAt(FRow, FCol)
		If C <> 0 AndAlso C->Fmtg <> 0 AndAlso C->Fmtg->ToolTipText <> 0 Then Return *C->Fmtg->ToolTipText
		Return ""
	End Property

	Property GridDataEx.CellToolTipText(ByRef Value As WString)
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		FillStyleRange(r1, c1, r2, c2)
		Dim i As Long, j As Long
		For i = r1 To r2
			For j = c1 To c2
				Dim As FlexCellFormat Ptr F = EnsureFmtg(i, j)
				If F <> 0 Then WLet(F->ToolTipText, Value)
			Next j
		Next i
	End Property

	Property GridDataEx.CellComboCue As Integer
		Dim As FlexCell Ptr C = CellAt(FRow, FCol)
		If C <> 0 AndAlso C->Fmtg <> 0 AndAlso C->Fmtg->ComboCue >= 0 Then Return C->Fmtg->ComboCue
		Return ColsArr(FCol).ComboCue
	End Property

	Property GridDataEx.CellComboCue(ByVal Value As Integer)
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		FillStyleRange(r1, c1, r2, c2)
		Dim i As Long, j As Long
		For i = r1 To r2
			For j = c1 To c2
				Dim As FlexCellFormat Ptr F = EnsureFmtg(i, j)
				If F <> 0 Then F->ComboCue = Value
			Next j
		Next i
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Function GridDataEx.EffectiveChecked(ByVal aRow As Long, ByVal aCol As Long) As Integer
		'Resolves the check state: FlexNoCheckBox when the column has no checkboxes.
		If aRow < 0 OrElse aCol < 0 OrElse aRow > FRows - 1 OrElse aCol > FCols - 1 Then Return FlexNoCheckBox
		If CheckBoxesActive(aRow, aCol) = False Then Return FlexNoCheckBox
		Dim As FlexCell Ptr C = CellAt(aRow, aCol)
		If C <> 0 AndAlso C->Fmtg <> 0 AndAlso C->Fmtg->Checked >= 0 Then Return C->Fmtg->Checked
		Return FlexUnchecked
	End Function

	Function GridDataEx.CheckBoxesActive(ByVal aRow As Long, ByVal aCol As Long) As Boolean
		If aCol < 0 OrElse aCol > FCols - 1 Then Return False
		Dim As FlexCell Ptr C = CellAt(aRow, aCol)
		'An explicit per-cell check state forces the checkbox on.
		If C <> 0 AndAlso C->Fmtg <> 0 AndAlso C->Fmtg->Checked >= FlexUnchecked Then Return True
		Return CBool((ColsArr(aCol).State And FLEX_CLIS_CHECKBOXES) <> 0)
	End Function

	Property GridDataEx.CellChecked As Integer
		Return EffectiveChecked(FRow, FCol)
	End Property

	Property GridDataEx.CellChecked(ByVal Value As Integer)
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		FillStyleRange(r1, c1, r2, c2)
		Dim i As Long, j As Long
		For i = r1 To r2
			For j = c1 To c2
				Dim As FlexCellFormat Ptr F = EnsureFmtg(i, j)
				If F <> 0 Then F->Checked = Value
			Next j
		Next i
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.CellFloodPercent As Integer
		Dim As FlexCell Ptr C = CellAt(FRow, FCol)
		If C <> 0 AndAlso C->Fmtg <> 0 Then Return C->Fmtg->FloodPercent
		Return 0
	End Property

	Property GridDataEx.CellFloodPercent(ByVal Value As Integer)
		Value = Max(0, Min(100, Value))
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		FillStyleRange(r1, c1, r2, c2)
		Dim i As Long, j As Long
		For i = r1 To r2
			For j = c1 To c2
				Dim As FlexCellFormat Ptr F = EnsureFmtg(i, j)
				If F <> 0 Then F->FloodPercent = Value
			Next j
		Next i
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.CellFloodColor As Long
		Dim As FlexCell Ptr C = CellAt(FRow, FCol)
		If C <> 0 AndAlso C->Fmtg <> 0 AndAlso C->Fmtg->FloodColor >= 0 Then Return C->Fmtg->FloodColor
		If FFloodColor >= 0 Then Return FFloodColor
		Return BackColorSel
	End Property

	Property GridDataEx.CellFloodColor(ByVal Value As Long)
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		FillStyleRange(r1, c1, r2, c2)
		Dim i As Long, j As Long
		For i = r1 To r2
			For j = c1 To c2
				Dim As FlexCellFormat Ptr F = EnsureFmtg(i, j)
				If F <> 0 Then F->FloodColor = Value
			Next j
		Next i
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	'=== Cell picture properties (current cell + FillStyle range) ===

	Property GridDataEx.CellPicture As Any Ptr
		Dim As FlexCell Ptr C = CellAt(FRow, FCol)
		If C <> 0 AndAlso C->Fmtg <> 0 Then Return C->Fmtg->PictureHandle
		Return 0
	End Property

	Property GridDataEx.CellPicture(ByVal Value As Any Ptr)
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		FillStyleRange(r1, c1, r2, c2)
		Dim i As Long, j As Long
		For i = r1 To r2
			For j = c1 To c2
				Dim As FlexCellFormat Ptr F = EnsureFmtg(i, j)
				If F <> 0 Then F->PictureHandle = Value
			Next j
		Next i
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.CellPictureIsIcon As Boolean
		Dim As FlexCell Ptr C = CellAt(FRow, FCol)
		If C <> 0 AndAlso C->Fmtg <> 0 Then Return C->Fmtg->PictureIsIcon
		Return True
	End Property

	Property GridDataEx.CellPictureIsIcon(ByVal Value As Boolean)
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		FillStyleRange(r1, c1, r2, c2)
		Dim i As Long, j As Long
		For i = r1 To r2
			For j = c1 To c2
				Dim As FlexCellFormat Ptr F = EnsureFmtg(i, j)
				If F <> 0 Then F->PictureIsIcon = Value
			Next j
		Next i
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.CellPictureWidth As Long
		Dim As FlexCell Ptr C = CellAt(FRow, FCol)
		If C <> 0 AndAlso C->Fmtg <> 0 Then Return C->Fmtg->PictureWidth
		Return 0
	End Property

	Property GridDataEx.CellPictureWidth(ByVal Value As Long)
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		FillStyleRange(r1, c1, r2, c2)
		Dim i As Long, j As Long
		For i = r1 To r2
			For j = c1 To c2
				Dim As FlexCellFormat Ptr F = EnsureFmtg(i, j)
				If F <> 0 Then F->PictureWidth = Max(0, Value)
			Next j
		Next i
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.CellPictureHeight As Long
		Dim As FlexCell Ptr C = CellAt(FRow, FCol)
		If C <> 0 AndAlso C->Fmtg <> 0 Then Return C->Fmtg->PictureHeight
		Return 0
	End Property

	Property GridDataEx.CellPictureHeight(ByVal Value As Long)
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		FillStyleRange(r1, c1, r2, c2)
		Dim i As Long, j As Long
		For i = r1 To r2
			For j = c1 To c2
				Dim As FlexCellFormat Ptr F = EnsureFmtg(i, j)
				If F <> 0 Then F->PictureHeight = Max(0, Value)
			Next j
		Next i
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Sub GridDataEx.SetCellPicture(ByVal aRow As Long, ByVal aCol As Long, ByVal Handle As Any Ptr, ByVal IsIcon As Boolean, ByVal WidthPx As Long, ByVal HeightPx As Long, ByVal Alignment As Integer)
		'One-shot setup: assigns the graphic, its render size and direction.
		If aRow < 0 OrElse aCol < 0 OrElse aRow > FRows - 1 OrElse aCol > FCols - 1 Then Exit Sub
		Dim As FlexCellFormat Ptr F = EnsureFmtg(aRow, aCol)
		If F = 0 Then Exit Sub
		F->PictureHandle = Handle
		F->PictureIsIcon = IsIcon
		F->PictureWidth = Max(0, WidthPx)
		F->PictureHeight = Max(0, HeightPx)
		If Alignment >= FlexPictureAlignmentLeftTop Then F->PictureAlignment = Alignment
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Sub

	'=== Cell font ===

	Property GridDataEx.CellFontName ByRef As WString
		Dim As FlexCell Ptr C = CellAt(FRow, FCol)
		If C <> 0 AndAlso C->Fmtg <> 0 AndAlso C->Fmtg->FontName <> 0 Then Return *C->Fmtg->FontName
		Return Font.Name
	End Property

	Property GridDataEx.CellFontName(ByRef Value As WString)
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		FillStyleRange(r1, c1, r2, c2)
		Dim i As Long, j As Long
		For i = r1 To r2
			For j = c1 To c2
				Dim As FlexCellFormat Ptr F = EnsureFmtg(i, j)
				If F <> 0 Then WLet(F->FontName, Value)
			Next j
		Next i
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.CellFontSize As Integer
		Dim As FlexCell Ptr C = CellAt(FRow, FCol)
		If C <> 0 AndAlso C->Fmtg <> 0 AndAlso C->Fmtg->FontSize > 0 Then Return C->Fmtg->FontSize
		Return Font.Size
	End Property

	Property GridDataEx.CellFontSize(ByVal Value As Integer)
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		FillStyleRange(r1, c1, r2, c2)
		Dim i As Long, j As Long
		For i = r1 To r2
			For j = c1 To c2
				Dim As FlexCellFormat Ptr F = EnsureFmtg(i, j)
				If F <> 0 Then F->FontSize = Value
			Next j
		Next i
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Function GridDataEx.CellFontStyleBit(ByVal BitFlag As Integer) As Boolean
		Dim As FlexCell Ptr C = CellAt(FRow, FCol)
		If C <> 0 AndAlso C->Fmtg <> 0 Then Return CBool((C->Fmtg->FontStyle And BitFlag) <> 0)
		'Fall back to the control font attribute.
		Select Case BitFlag
			Case FLEX_FS_BOLD : Return Font.Bold
			Case FLEX_FS_ITALIC : Return Font.Italic
			Case FLEX_FS_UNDERLINE : Return Font.Underline
			Case FLEX_FS_STRIKEOUT : Return Font.StrikeOut
		End Select
		Return False
	End Function

	Sub GridDataEx.SetCellFontStyleBit(ByVal BitFlag As Integer, ByVal Value As Boolean)
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		FillStyleRange(r1, c1, r2, c2)
		Dim i As Long, j As Long
		For i = r1 To r2
			For j = c1 To c2
				Dim As FlexCellFormat Ptr F = EnsureFmtg(i, j)
				If F <> 0 Then
					If Value Then
						F->FontStyle Or= BitFlag
					Else
						F->FontStyle And= Not BitFlag
					End If
				End If
			Next j
		Next i
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Sub

	Property GridDataEx.CellFontBold As Boolean
		Return CellFontStyleBit(FLEX_FS_BOLD)
	End Property

	Property GridDataEx.CellFontBold(ByVal Value As Boolean)
		SetCellFontStyleBit(FLEX_FS_BOLD, Value)
	End Property

	Property GridDataEx.CellFontItalic As Boolean
		Return CellFontStyleBit(FLEX_FS_ITALIC)
	End Property

	Property GridDataEx.CellFontItalic(ByVal Value As Boolean)
		SetCellFontStyleBit(FLEX_FS_ITALIC, Value)
	End Property

	Property GridDataEx.CellFontUnderline As Boolean
		Return CellFontStyleBit(FLEX_FS_UNDERLINE)
	End Property

	Property GridDataEx.CellFontUnderline(ByVal Value As Boolean)
		SetCellFontStyleBit(FLEX_FS_UNDERLINE, Value)
	End Property

	Property GridDataEx.CellFontStrikeThrough As Boolean
		Return CellFontStyleBit(FLEX_FS_STRIKEOUT)
	End Property

	Property GridDataEx.CellFontStrikeThrough(ByVal Value As Boolean)
		SetCellFontStyleBit(FLEX_FS_STRIKEOUT, Value)
	End Property

	Property GridDataEx.CellFontCharset As Integer
		Dim As FlexCell Ptr C = CellAt(FRow, FCol)
		If C <> 0 AndAlso C->Fmtg <> 0 AndAlso C->Fmtg->FontCharset >= 0 Then Return C->Fmtg->FontCharset
		Return 0
	End Property

	Property GridDataEx.CellFontCharset(ByVal Value As Integer)
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		FillStyleRange(r1, c1, r2, c2)
		Dim i As Long, j As Long
		For i = r1 To r2
			For j = c1 To c2
				Dim As FlexCellFormat Ptr F = EnsureFmtg(i, j)
				If F <> 0 Then F->FontCharset = Value
			Next j
		Next i
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.CellHasCustomFormatting As Boolean
		Dim As FlexCell Ptr C = CellAt(FRow, FCol)
		If C = 0 Then Return False
		Return C->FHasFmtg
	End Property

	Property GridDataEx.CellHasCustomFormatting(ByVal Value As Boolean)
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		FillStyleRange(r1, c1, r2, c2)
		Dim i As Long, j As Long
		For i = r1 To r2
			For j = c1 To c2
				Dim As FlexCell Ptr C = CellAt(i, j)
				If C <> 0 Then
					If Value = False Then
						If C->Fmtg <> 0 Then Delete C->Fmtg
						C->Fmtg = 0
					End If
					C->FHasFmtg = Value
				End If
			Next j
		Next i
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	'=== Cell tag ===

	Property GridDataEx.CellHasTag As Boolean
		Dim As FlexCell Ptr C = CellAt(FRow, FCol)
		If C = 0 Then Return False
		Return C->FHasTag
	End Property

	Property GridDataEx.CellHasTag(ByVal Value As Boolean)
		Dim As FlexCell Ptr C = CellAt(FRow, FCol)
		If C <> 0 Then C->FHasTag = Value
	End Property

	Property GridDataEx.CellTag As Any Ptr
		Dim As FlexCell Ptr C = CellAt(FRow, FCol)
		If C = 0 Then Return 0
		Return C->TagPtr
	End Property

	Property GridDataEx.CellTag(ByVal Value As Any Ptr)
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		FillStyleRange(r1, c1, r2, c2)
		Dim i As Long, j As Long
		For i = r1 To r2
			For j = c1 To c2
				Dim As FlexCell Ptr C = CellAt(i, j)
				If C <> 0 Then
					C->TagPtr = Value
					C->FHasTag = (Value <> 0)
				End If
			Next j
		Next i
	End Property

	'=== Cell geometry (pixels of the merged current cell) ===

	Property GridDataEx.CellLeft As Long
		Dim As Long MR1, MC1, MR2, MC2
		GetMergedRange(FRow, FCol, MR1, MC1, MR2, MC2)
		Return ColLeftX(MC1) + IIf(FBorderStyle = FlexBorderStyleNone, 0, 2)
	End Property

	Property GridDataEx.CellTop As Long
		Dim As Long MR1, MC1, MR2, MC2
		GetMergedRange(FRow, FCol, MR1, MC1, MR2, MC2)
		Return RowTopY(MR1) + IIf(FBorderStyle = FlexBorderStyleNone, 0, 2)
	End Property

	Property GridDataEx.CellWidth As Long
		Dim As Long MR1, MC1, MR2, MC2
		GetMergedRange(FRow, FCol, MR1, MC1, MR2, MC2)
		Return ColLeftX(MC2 + 1) - ColLeftX(MC1)
	End Property

	Property GridDataEx.CellHeight As Long
		Dim As Long MR1, MC1, MR2, MC2
		GetMergedRange(FRow, FCol, MR1, MC1, MR2, MC2)
		Return RowTopY(MR2 + 1) - RowTopY(MR1)
	End Property

	Sub GridDataEx.CellEnsureVisible(ByVal Visibility As Integer, ByVal aRow As Long, ByVal aCol As Long)
		If aRow < 0 Then aRow = FRow
		If aCol < 0 Then aCol = FCol
		If aRow < 0 OrElse aCol < 0 Then Exit Sub
		EnsureVisibleCell(aRow, aCol)
		If Visibility = FlexVisibilityCompleteOnly Then
			'Nudge further until the cell fits completely.
			Do While RowIsVisible(aRow, FlexVisibilityCompleteOnly) = False AndAlso FTopRow < aRow
				FTopRow += 1
			Loop
			Do While ColIsVisible(aCol, FlexVisibilityCompleteOnly) = False AndAlso FLeftCol < aCol
				FLeftCol += 1
			Loop
			SetScrollBarsInternal
		End If
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Sub

	Property GridDataEx.TextArray(ByVal aIndex As Long) ByRef As WString
		'Flat index into the cell matrix, row-major like VB6 TextArray.
		If aIndex < 0 OrElse aIndex >= FRows * FCols Then Return ""
		Dim As FlexCell Ptr C = CellsArr(aIndex)
		If C = 0 Then Return ""
		Return C->Text
	End Property

	Property GridDataEx.TextArray(ByVal aIndex As Long, ByRef Value As WString)
		If aIndex < 0 OrElse aIndex >= FRows * FCols Then Exit Property
		If CellsArr(aIndex) = 0 Then CellsArr(aIndex) = New FlexCell
		CellsArr(aIndex)->Text = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	'=== Selection helpers ===

	Sub GridDataEx.InternalSetRowCol(ByVal NewRow As Long, ByVal NewCol As Long, ByVal NewRowSel As Long, ByVal NewColSel As Long, ByVal Flags As Long)
		NewRow = Max(0, min(NewRow, FRows - 1))
		NewCol = Max(0, min(NewCol, FCols - 1))
		NewRowSel = Max(0, Min(NewRowSel, FRows - 1))
		NewColSel = Max(0, Min(NewColSel, FCols - 1))
		Dim As Boolean Changed = CBool(NewRow <> FRow OrElse NewCol <> FCol OrElse NewRowSel <> FRowSel OrElse NewColSel <> FColSel)
		FRow = NewRow
		FCol = NewCol
		FRowSel = NewRowSel
		FColSel = NewColSel
		EnsureVisibleCell(FRow, FCol)
		If Changed Then
			If OnEnterCell Then OnEnterCell(*Designer, This)
			If OnRowColChange Then OnRowColChange(*Designer, This)
			If (NewRowSel <> NewRow) OrElse (NewColSel <> NewCol) Then
				If OnSelChange Then OnSelChange(*Designer, This)
			End If
		End If
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Sub

	Sub GridDataEx.GetSelRange(ByRef Row1 As Long, ByRef Col1 As Long, ByRef Row2 As Long, ByRef Col2 As Long)
		Row1 = Min(FRow, FRowSel) : Col1 = Min(FCol, FColSel)
		Row2 = Max(FRow, FRowSel) : Col2 = Max(FCol, FColSel)
	End Sub

	Sub GridDataEx.SelectRange(ByVal aRow As Long, ByVal aCol As Long, ByVal aRowSel As Long = -1, ByVal aColSel As Long = -1)
		If aRowSel < 0 Then aRowSel = aRow
		If aColSel < 0 Then aColSel = aCol
		InternalSetRowCol(aRow, aCol, aRowSel, aColSel, 0)
	End Sub

	Function GridDataEx.BottomRow(ByVal Visibility As Integer = FlexVisibilityCompleteOnly) As Long
		'Last visible row below the fixed/frozen area (scroll-aware).
		Dim As Long BorderSize = GetGridLineOffsets_AreaTop()
		Dim As Long FixedCount = FFixedRows + FFrozenRows
		If FixedCount > FRows Then FixedCount = FRows
		Dim As Long RowOffset = RowTopY(FTopRow) - RowTopY(FixedCount)
		Dim As Long Last = FixedCount - 1
		Dim As Long FilterTopOff = FilterBarHeightPx()
		Dim As Long i = Max(FTopRow, FixedCount)
		Do While i <= FRows - 1
			If (RowsArr(i).State And FLEX_RWIS_HIDDEN) <> 0 Then
				i += 1
				Continue Do
			End If
			Dim As Long TopY = BorderSize + RowTopY(i) - RowOffset + FilterTopOff
			If TopY >= ClientHeightPx() Then Exit Do
			Dim As Long H = GetRowHeightPx(i)
			Last = i
			If Visibility = FlexVisibilityCompleteOnly AndAlso (TopY + H) > ClientHeightPx() Then
				Last = i - 1
				Exit Do
			End If
			i += 1
		Loop
		Return Max(Last, FixedCount - 1)
	End Function

	Function GridDataEx.RightCol(ByVal Visibility As Integer = FlexVisibilityCompleteOnly) As Long
		Dim As Long BorderSize = GetGridLineOffsets_AreaTop()
		Dim As Long FixedCount = FFixedCols + FFrozenCols
		If FixedCount > FCols Then FixedCount = FCols
		Dim As Long ColOffset = ColLeftX(FLeftCol) - ColLeftX(FixedCount)
		Dim As Long Last = FixedCount - 1
		Dim As Long j = Max(FLeftCol, FixedCount)
		Do While j <= FCols - 1
			If (ColsArr(j).State And FLEX_CLIS_HIDDEN) <> 0 Then
				j += 1
				Continue Do
			End If
			Dim As Long LeftX = BorderSize + ColLeftX(j) - ColOffset
			If LeftX >= ClientWidthPx() Then Exit Do
			Dim As Long W = GetColWidthPx(j)
			Last = j
			If Visibility = FlexVisibilityCompleteOnly AndAlso (LeftX + W) > ClientWidthPx() Then
				Last = j - 1
				Exit Do
			End If
			j += 1
		Loop
		Return Max(Last, FixedCount - 1)
	End Function

	Property GridDataEx.MouseRow As Long
		Return FMouseRow
	End Property

	Property GridDataEx.MouseCol As Long
		Return FMouseCol
	End Property

	Property GridDataEx.HitRow As Long
		Return FHitRow
	End Property

	Property GridDataEx.HitCol As Long
		Return FHitCol
	End Property

	Property GridDataEx.HitRowDivider As Long
		Return FHitRowDivider
	End Property

	Property GridDataEx.HitColDivider As Long
		Return FHitColDivider
	End Property

	Property GridDataEx.HitResult As Integer
		Return FHitResult
	End Property

	Sub GridDataEx.UpdateHitTest(ByVal X As Long, ByVal Y As Long)
		'Refreshes the hit test cache for the given client position.
		Dim As Long BorderSize = GetGridLineOffsets_AreaTop()
		Dim As Long FixedRowCount = FFixedRows + FFrozenRows
		Dim As Long FixedColCount = FFixedCols + FFrozenCols
		If FixedRowCount > FRows Then FixedRowCount = FRows
		If FixedColCount > FCols Then FixedColCount = FCols
		'Client position converted into scroll-aware grid space.
		Dim As Long GridX = GridXFromClient(X)
		Dim As Long GridY = GridYFromClient(Y)
		'Filter bar band: between the fixed rows and the first scroll row.
		Dim As Long FilterH = FilterBarHeightPx()
		If FilterH > 0 Then
			Dim As Long BandTop = BorderSize + RowTopY(FixedRowCount)
			If (Y >= BandTop) AndAlso (Y < BandTop + FilterH) Then
				FHitRow = -1
				FHitRowDivider = -1
				FHitColDivider = -1
				FHitCol = ColAtX(GridX)
				FMouseRow = -1
				FMouseCol = FHitCol
				FHitResult = FlexHitResultFilterCell
				Exit Sub
			End If
		End If
		FHitRow = RowAtY(GridY)
		FHitCol = ColAtX(GridX)
		FHitRowDivider = HitRowDividerPx(X, Y)
		FHitColDivider = HitColDividerPx(X, Y)
		FMouseRow = FHitRow
		FMouseCol = FHitCol
		FHitResult = FlexHitResultNoWhere
		If FHitRow >= 0 AndAlso FHitCol >= 0 Then
			FHitResult = FlexHitResultCell
			Dim As Long MR1, MC1, MR2, MC2
			GetMergedRange(FHitRow, FHitCol, MR1, MC1, MR2, MC2)
			If (MR1 <> MR2) OrElse (MC1 <> MC2) Then FHitRow = MR1 : FHitCol = MC1
			'Combo cue / checkbox sub-hits (grid-space rect mapped back to client).
			Dim As Long CellL = ColLeftX(FHitCol), CellT = RowTopY(FHitRow)
			Dim As Long CellW = ColLeftX(FHitCol + 1) - CellL, CellH = RowTopY(FHitRow + 1) - CellT
			Dim As Long CellLClient = CellL, CellTClient = CellT
			If FHitCol >= FixedColCount Then CellLClient = BorderSize + ColLeftX(FixedColCount) + (CellL - ColLeftX(FLeftCol))
			If FHitRow >= FixedRowCount Then CellTClient = BorderSize + RowTopY(FixedRowCount) + FilterBarHeightPx() + (CellT - RowTopY(FTopRow))
			'Cell button columns: the entire cell is the button.
			If (FHitRow >= FFixedRows) AndAlso (ColsArr(FHitCol).State And FLEX_CLIS_CELLBUTTONS) <> 0 Then
				FHitResult = FlexHitResultCellButton
			End If
			Dim As Long CBSize = Max(12, CvCheckBoxSize())
			Dim As Boolean CBHitOk = True
			If FHitRow < FFixedRows Then
				If (ColsArr(FHitCol).State And FLEX_CLIS_CHECKBOXESHTIFIXED) <> 0 Then CBHitOk = False
			Else
				If (ColsArr(FHitCol).State And FLEX_CLIS_CHECKBOXESHTI) <> 0 Then CBHitOk = False
			End If
			If FHitResult = FlexHitResultCellButton Then
				'Button cells have no further sub-hits.
			ElseIf CBHitOk AndAlso CheckBoxesActive(FHitRow, FHitCol) Then
				Dim As Long CBX = CellLClient + 3, CBY = CellTClient + (CellH - CBSize) \ 2
				If X >= CBX AndAlso X <= CBX + CBSize AndAlso Y >= CBY AndAlso Y <= CBY + CBSize Then
					FHitResult = FlexHitResultCheckBox
				End If
			ElseIf ColsArr(FHitCol).ComboCue >= FlexComboCueDropDown Then
				Dim As Long CueW = GetComboCueWidth(FHitCol)
				Dim As Long CueX = CellLClient + CellW - CueW - 2
				If X >= CueX AndAlso X <= CellLClient + CellW AndAlso Y >= CellTClient AndAlso Y <= CellTClient + CellH Then
					FHitResult = FlexHitResultComboCue
				End If
			End If
		ElseIf FHitRowDivider >= 0 Then
			FHitResult = IIf(FHitRowDivider < FFixedRows, FlexHitResultDividerRowBottom, FlexHitResultDividerRowBottom)
		ElseIf FHitColDivider >= 0 Then
			FHitResult = FlexHitResultDividerColumnRight
		End If
		If FHitRow < 0 AndAlso Y < BorderSize + RowTopY(FixedRowCount) Then FHitResult = FlexHitResultNoWhere
	End Sub

	Sub GridDataEx.HitTest(ByVal X As Long, ByVal Y As Long)
		UpdateHitTest(X, Y)
	End Sub

	'=== Grid line offsets & metrics ===

	Sub GridDataEx.GetGridLineOffsets(ByRef LeftOff As Long, ByRef TopOff As Long, ByRef RightOff As Long, ByRef BottomOff As Long)
		'Offsets of the grid line area relative to the client edges (pixels).
		Dim As Long BorderSize = GetGridLineOffsets_AreaTop()
		LeftOff = BorderSize : TopOff = BorderSize
		RightOff = -BorderSize : BottomOff = -BorderSize
		'Inset grid lines eat one pixel into each cell.
		Dim As Long LineFixed = GridLinesFixed
		Dim As Long LineNormal = FGridLines
		If (LineNormal = GridDataLineInset) OrElse (LineFixed = GridDataLineInset) OrElse (GridLinesFrozen = GridDataLineInset) Then
			RightOff -= 1 : BottomOff -= 1
		End If
	End Sub

	Sub GridDataEx.GetMetrics(ByVal Metric As Integer, ByRef CX As Long, ByRef CY As Long)
		Dim As Single FactorX = 1, FactorY = 1
		If TwipsPerPixelX() > 0 Then FactorX = 15 / TwipsPerPixelX()
		If TwipsPerPixelY() > 0 Then FactorY = 15 / TwipsPerPixelY()
		Select Case Metric
			Case FlexMetricDividerSpacing : CX = CLng(2 * FactorX) : CY = CLng(2 * FactorY)
			Case FlexMetricTextPadding : CX = CLng(3 * FactorX) : CY = CLng(1 * FactorY)
			Case FlexMetricCellSpacing : CX = 0 : CY = 0
			Case FlexMetricScrollBarSize
				#ifdef __USE_WINAPI__
					CX = GetSystemMetrics(SM_CXVSCROLL)
					CY = GetSystemMetrics(SM_CYHSCROLL)
				#else
					CX = OwnScrollBarSize() : CY = CX
				#endif
			Case FlexMetricCheckBoxSize
				CX = CvCheckBoxSize() : CY = CX
			Case Else : CX = 0 : CY = 0
		End Select
	End Sub

	Function GridDataEx.CvCheckBoxSize() As Long
		'Checkbox glyph size in pixels, scaled with DPI.
		Dim As Single FactorY = 15 / TwipsPerPixelY()
		If FactorY <= 0 Then FactorY = 1
		Dim As Long BaseSize = 13
		#ifdef __USE_WINAPI__
			BaseSize = Max(GetSystemMetrics(SM_CXVSCROLL) - 2, 11)
		#endif
		Return Max(11, CLng(CDbl(BaseSize) * FactorY))
	End Function

	Function GridDataEx.GetComboCueWidth(ByVal aCol As Long) As Long
		'Width of the combo cue button drawn at the cell's right edge.
		If aCol < 0 OrElse aCol > FCols - 1 Then Return 0
		If ColsArr(aCol).ComboCue < FlexComboCueDropDown Then Return 0
		Return Max(12, GetRowHeightPx(0) \ 2)
	End Function

	'=== Text measurement ===

	Function GridDataEx.TextWidthOf(ByRef Value As WString) As Long
		If Handle = 0 Then Return Len(Value) * 8
		#ifdef __USE_WINAPI__
			Dim As HDC Dc = GetDC(Handle)
			Canvas.SetHandle(Dc)
			UsePhysicalCanvas
			Dim As Long Result = Canvas.TextWidth(Value)
			Canvas.UnSetHandle
			ReleaseDC(Handle, Dc)
			Return Result
		#else
			'Measure through a Pango layout on a scratch cairo surface: a layout
			'can be created from any cairo context, no live paint is needed
			#ifdef __USE_GTK__
				Dim As cairo_surface_t Ptr Surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 1, 1)
				Dim As cairo_t Ptr cr = cairo_create(Surface)
				Canvas.SetHandle(cr)
				Canvas.Font = This.Font
				Dim As Long Result = Canvas.TextWidth(Value)
				Canvas.Handle = 0
				Canvas.HandleSetted = False
				cairo_destroy(cr)
				cairo_surface_destroy(Surface)
				Return Result
			#else
				'The Web and Android measure without a running paint
				Canvas.Font = This.Font
				Return Canvas.TextWidth(Value)
			#endif
		#endif
	End Function

	Function GridDataEx.TextHeightOf(ByRef Value As WString) As Long
		If Handle = 0 Then Return 16
		#ifdef __USE_WINAPI__
			Dim As HDC Dc = GetDC(Handle)
			Canvas.SetHandle(Dc)
			UsePhysicalCanvas
			Dim As Long Result = Canvas.TextHeight(Value)
			Canvas.UnSetHandle
			ReleaseDC(Handle, Dc)
			Return Result
		#else
			#ifdef __USE_GTK__
				Dim As cairo_surface_t Ptr Surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 1, 1)
				Dim As cairo_t Ptr cr = cairo_create(Surface)
				Canvas.SetHandle(cr)
				Canvas.Font = This.Font
				Dim As Long Result = Canvas.TextHeight(Value)
				Canvas.Handle = 0
				Canvas.HandleSetted = False
				cairo_destroy(cr)
				cairo_surface_destroy(Surface)
				Return Result
			#else
				'The Web and Android measure without a running paint
				Canvas.Font = This.Font
				Return Canvas.TextHeight(Value)
			#endif
		#endif
	End Function

	Sub GridDataEx.Refresh()
		RepaintGrid
	End Sub

	'=== Cell drop-down editors (combo list / calendar / calculator) ===

	Function GridDataEx.CellEditorRect(ByRef L As Long, ByRef T As Long, ByRef W As Long, ByRef H As Long) As Boolean
		'Client-space rectangle of the merged current cell.
		If FEditRow < 0 OrElse FEditCol < 0 Then Return False
		Dim As Long MR1, MC1, MR2, MC2
		GetMergedRange(FEditRow, FEditCol, MR1, MC1, MR2, MC2)
		L = ColLeftX(MC1) : T = RowTopY(MR1)
		W = ColLeftX(MC2 + 1) - L
		H = RowTopY(MR2 + 1) - T
		Dim As Long BorderSize = GetGridLineOffsets_AreaTop()
		L += BorderSize : T += BorderSize
		Return W > 0 AndAlso H > 0
	End Function

	Sub GridDataEx.EnsureComboEdit(ByVal AStyle As Integer)
		'Creates (or recreates when the style changed) the in-place combo editor.
		If ComboEdit_ <> 0 AndAlso FComboEditStyle <> AStyle Then
			ComboEdit_->Visible = False
			Delete ComboEdit_
			ComboEdit_ = 0
		End If
		If ComboEdit_ = 0 Then
			ComboEdit_ = New ComboBoxEdit
			FComboEditStyle = AStyle
			With *ComboEdit_
				.Designer = @This
				.Style = Cast(ComboBoxEditStyle, AStyle)
				.Parent = @This
				.Visible = False
				.OnSelected = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ComboBoxEdit, ByVal ItemIndex As Integer), @ComboEdit_Selected)
				.OnCloseUp = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ComboBoxEdit), @ComboEdit_CloseUp)
				.OnKeyDown = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ComboBoxEdit, Key As Integer, Shift As Integer), @ComboEdit_KeyDown)
				.OnChange = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ComboBoxEdit), @ComboEdit_Changed)
			End With
		End If
	End Sub

	Sub GridDataEx.EnsureComboCalendar()
		If ComboCalendar_ = 0 Then
			ComboCalendar_ = New MonthCalendar
			With *ComboCalendar_
				.Designer = @This
				.Parent = @This
				.Visible = False
				.TodaySelector = True
				.OnSelect = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As MonthCalendar), @ComboCal_Select)
			End With
		End If
	End Sub

	Sub GridDataEx.EnsureCalcPanel()
		If CalcPanel_ <> 0 Then Exit Sub
		CalcPanel_ = New Panel
		With *CalcPanel_
			.Designer = @This
			.Parent = @This
			.Visible = False
		End With
		CalcDisplay_ = New Label
		With *CalcDisplay_
			.Designer = @This
			.Parent = CalcPanel_
			.Alignment = AlignmentConstants.taRight
			.SetBounds 4, 4, 164, 22
			.BackColor = &HFFFFFF
			.Caption = "0"
		End With
		Dim As String CalcKeys(0 To 19) = {"C", "<-", "/", "*", "7", "8", "9", "-", "4", "5", "6", "+", "1", "2", "3", "=", "+/-", "0", ".", "CE"}
		For i As Integer = 0 To 19
			CalcBtn_(i) = New CommandButton
			With *CalcBtn_(i)
				.Designer = @This
				.Parent = CalcPanel_
				.Text = CalcKeys(i)
				.SetBounds 4 + (i Mod 4) * 42, 30 + (i \ 4) * 38, 40, 34
				.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @CalcBtn_Click)
			End With
		Next i
	End Sub

	Sub GridDataEx.FillComboItems()
		'Loads the column combo items (CR separated) into the combo editor.
		If ComboEdit_ = 0 OrElse FEditCol < 0 OrElse FEditCol > FCols - 1 Then Exit Sub
		ComboEdit_->Clear
		Dim As UString Items = ColComboItems(FEditCol)
		If Len(Items) = 0 Then Exit Sub
		Dim As Long P = 1
		Do While P <= Len(Items)
			Dim As UString Chunk = Mid(Items, P)
			Dim As Long CR = InStr(Chunk, Chr(13))
			Dim As UString One
			If CR > 0 Then One = Mid(Chunk, 1, CR - 1) Else One = Chunk
			'Multi-column item (tab fields): show the first two fields joined.
			Dim As Long T1 = InStr(One, Chr(9))
			If T1 > 0 Then
				Dim As UString F0 = Mid(One, 1, T1 - 1)
				Dim As UString Rest2 = Mid(One, T1 + 1)
				Dim As Long T2 = InStr(Rest2, Chr(9))
				Dim As UString F1
				If T2 > 0 Then F1 = Mid(Rest2, 1, T2 - 1) Else F1 = Rest2
				One = F0 & "  " & F1
			End If
			ComboEdit_->AddItem(One)
			If CR = 0 Then Exit Do
			P += CR
		Loop
	End Sub

	Function GridDataEx.ComboItemValue(ByRef Item As WString) ByRef As WString
		'Extracts the bound tab field of a combo item (1-based ComboBoundColumn)
		'and translates it back to its lookup key when the column has one.
		Dim As Long Bnd = 0
		If FEditCol >= 0 AndAlso FEditCol <= FCols - 1 Then Bnd = ColsArr(FEditCol).ComboBoundColumn
		WLet(FTextTmp, Item)
		If Bnd > 1 Then
			Dim As Long P = 1
			For f As Long = 2 To Bnd
				Dim As Long TabPos = InStr(P, Item, Chr(9))
				If TabPos = 0 Then Return ""
				P = TabPos + 1
			Next f
			WLet(FTextTmp, Mid(Item, P))
			Dim As Long TabPos2 = InStr(*FTextTmp, Chr(9))
			If TabPos2 > 0 Then WLetEx(FTextTmp, Mid(*FTextTmp, 1, TabPos2 - 1))
		End If
		If FEditCol >= 0 AndAlso FEditCol <= FCols - 1 Then
			If HasLookup(FEditCol) Then WLetEx(FTextTmp, LookupTranslate(*FTextTmp, FlexLookupConvKey, FEditCol))
		End If
		If FTextTmp <> 0 Then Return *FTextTmp Else Return ""
	End Function

	Sub GridDataEx.ShowDropDown()
		'Opens the drop-down editor of the current cell (starts an edit if needed).
		If FInEdit = False Then
			If FAllowUserEditing = False Then Exit Sub
			FEditReason = FlexEditReasonComboCueF4
			If StartEdit = False Then Exit Sub
		End If
		If FEditCol < 0 OrElse FEditCol > FCols - 1 Then Exit Sub
		Select Case ColsArr(FEditCol).ComboMode
			Case FlexComboModeDropDown, FlexComboModeEditable
				If ComboEdit_ <> 0 Then
					ComboEdit_->ShowDropDown(True)
					FComboDropped = True
				End If
			Case FlexComboModeCalendar, FlexComboModeCalculator
				FComboDropped = True
		End Select
	End Sub

	Sub GridDataEx.CloseDropDown(ByVal bCommit As Boolean)
		If FComboDropped = False AndAlso _
		   CBool(ComboEdit_ = 0 OrElse ComboEdit_->Visible = False) AndAlso _
		   CBool(ComboCalendar_ = 0 OrElse ComboCalendar_->Visible = False) AndAlso _
		   CBool(CalcPanel_ = 0 OrElse CalcPanel_->Visible = False) Then Exit Sub
		FComboDropped = False
		If ComboEdit_ <> 0 Then ComboEdit_->Visible = False
		If ComboCalendar_ <> 0 Then ComboCalendar_->Visible = False
		If CalcPanel_ <> 0 Then CalcPanel_->Visible = False
		If bCommit AndAlso FInEdit Then CommitEditInternal(FlexEditCloseModeLostFocus)
	End Sub

	'=== Calculator engine ===

	Function GridDataEx.CalcApplyOp(ByVal A As Double, ByVal B As Double, ByVal Op As Long) As Double
		Select Case Op
			Case Asc("+") : Return A + B
			Case Asc("-") : Return A - B
			Case Asc("*") : Return A * B
			Case Asc("/")
				If B = 0 Then Return 0
				Return A / B
		End Select
		Return B
	End Function

	Function GridDataEx.CalcNumStr(ByVal R As Double) ByRef As WString
		'Formats the result; honors the column numeric scale when set.
		Dim As Long Scale = 0
		If FEditCol >= 0 AndAlso FEditCol <= FCols - 1 Then Scale = ColsArr(FEditCol).NumericScale
		WLet(FTextTmp, Str(R))
		If Scale <= 0 Then Return *FTextTmp
		'Manual fixed-decimal formatting (MFF redefines Format for dates).
		Dim As Double Mul = 10 ^ Scale
		Dim As Long IV = CLng(Fix(Abs(R) * Mul + 0.5))
		Dim As UString FracTxt = Str(IV Mod CLng(Mul))
		Do While Len(FracTxt) < Scale
			FracTxt = "0" & FracTxt
		Loop
		WLet(FTextTmp, Str(IV \ CLng(Mul)) & "." & FracTxt)
		If R < 0 Then WAdd(FTextTmp,  "-", True)
		If FTextTmp <> 0 Then Return *FTextTmp Else Return ""
	End Function

	Sub GridDataEx.CalcUpdateDisplay()
		If CalcDisplay_ <> 0 Then CalcDisplay_->Caption = *FCalcEntry
	End Sub

	Sub GridDataEx.CalcApplyKey(ByRef KeyCh As WString)
		'Immediate-execution calculator: digits, ops, =, C, CE, back, sign.
		Select Case KeyCh
			Case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
				If FCalcFresh Then
					WLet(FCalcEntry, KeyCh)
					FCalcFresh = False
				ElseIf Len(*FCalcEntry) < 18 Then
					WAdd(FCalcEntry, KeyCh)
				End If
			Case "."
				If FCalcFresh Then
					WLet(FCalcEntry, "0.")
					FCalcFresh = False
				ElseIf InStr(*FCalcEntry, ".") = 0 Then
					WAdd(FCalcEntry, ".")
				End If
			Case "+", "-", "*", "/"
				If (FCalcOp <> 0) AndAlso (FCalcFresh = False) Then
					FCalcAccum = CalcApplyOp(FCalcAccum, Val(*FCalcEntry), FCalcOp)
					WLet(FCalcEntry, CalcNumStr(FCalcAccum))
				Else
					FCalcAccum = Val(*FCalcEntry)
				End If
				FCalcOp = Asc(KeyCh)
				FCalcFresh = True
			Case "="
				Dim As Double R
				If FCalcOp <> 0 Then
					R = CalcApplyOp(FCalcAccum, Val(*FCalcEntry), FCalcOp)
				Else
					R = Val(*FCalcEntry)
				End If
				FCalcOp = 0
				FCalcAccum = 0
				WLet(FCalcEntry, CalcNumStr(R))
				FCalcFresh = True
				CalcUpdateDisplay
				'Write the result into the cell and finish the edit.
				If FInEdit Then
					EditText_->Text = *FCalcEntry
					FEditChanged = True
					CloseDropDown(True)
				End If
				Exit Sub
			Case "C"
				WLet(FCalcEntry, "0")
				FCalcAccum = 0
				FCalcOp = 0
				FCalcFresh = True
			Case "CE"
				WLet(FCalcEntry, "0")
				FCalcFresh = True
			Case "<-"
				If Len(*FCalcEntry) > 1 Then
					WLet(FCalcEntry, Mid(*FCalcEntry, 1, Len(*FCalcEntry) - 1))
				Else
					WLet(FCalcEntry, "0")
				End If
			Case "+/-"
				If Mid(*FCalcEntry, 1, 1) = "-" Then
					WLet(FCalcEntry, Mid(*FCalcEntry, 2))
				ElseIf Val(*FCalcEntry) <> 0 Then
					WLet(FCalcEntry, "-" & *FCalcEntry)
				End If
		End Select
		CalcUpdateDisplay
	End Sub

	'=== Drop-down event handlers (member convention: Designer omitted) ===

	Sub GridDataEx.ComboEdit_Selected(ByRef Sender As ComboBoxEdit, ByVal ItemIndex As Integer)
		If FInEdit = False Then Exit Sub
		If ItemIndex < 0 OrElse ItemIndex >= Sender.ItemCount Then Exit Sub
		'Resolve the original (possibly tab-separated) item from the column
		'list: the combo only shows a shortened display text.
		Dim As UString OrigItem = Sender.Item(ItemIndex)
		If FEditCol >= 0 AndAlso FEditCol <= FCols - 1 Then
			Dim As UString Items = ColComboItems(FEditCol)
			Dim As Long P = 1, Idx = 0
			Do While P <= Len(Items)
				Dim As UString Chunk = Mid(Items, P)
				Dim As Long CR = InStr(Chunk, Chr(13))
				Dim As UString One
				If CR > 0 Then One = Mid(Chunk, 1, CR - 1) Else One = Chunk
				If Idx = ItemIndex Then
					OrigItem = One
					Exit Do
				End If
				Idx += 1
				If CR = 0 Then Exit Do
				P += CR
			Loop
		End If
		EditText_->Text = ComboItemValue(OrigItem)
		FEditChanged = True
		CommitEditInternal(FlexEditCloseModeCode)
	End Sub

	Sub GridDataEx.ComboEdit_CloseUp(ByRef Sender As ComboBoxEdit)
		If FInEdit = False Then Exit Sub
		If FComboDropped Then
			EditText_->Text = Sender.Text
			FEditChanged = True
			CommitEditInternal(FlexEditCloseModeCode)
		End If
	End Sub

	Sub GridDataEx.ComboEdit_KeyDown(ByRef Sender As ComboBoxEdit, Key As Integer, Shift As Integer)
		#ifdef __USE_GTK__
			Key = FlexKeyToVK(Key)
		#endif
		Select Case Key
			Case VK_ESCAPE
				CloseDropDown(False)
				CancelEdit
			Case VK_RETURN
				If FInEdit Then
					EditText_->Text = Sender.Text
					FEditChanged = True
					CommitEditInternal(FlexEditCloseModeReturn)
				End If
		End Select
	End Sub

	Sub GridDataEx.ComboEdit_Changed(ByRef Sender As ComboBoxEdit)
		FEditChanged = True
	End Sub

	Sub GridDataEx.ComboCal_Select(ByRef Sender As MonthCalendar)
		'Writes the picked date as YYYY-MM-DD into the cell and closes.
		If FInEdit = False Then Exit Sub
		Dim As Long D = Sender.SelectedDate
		EditText_->Text = Right("000" & Year(D), 4) & "-" & Right("0" & Month(D), 2) & "-" & Right("0" & Day(D), 2)
		FEditChanged = True
		CommitEditInternal(FlexEditCloseModeCode)
	End Sub

	Sub GridDataEx.CalcBtn_Click(ByRef Sender As Control)
		'The button caption is the calculator key.
		CalcApplyKey(Sender.Text)
	End Sub

	'=== AutoSize (real text measurement) ===

	Function GridDataEx.ColWraps(ByVal aCol As Long, ByVal bFixed As Boolean) As Boolean
		'Does the column wrap its text? (per-column option overrides WordWrap)
		If aCol < 0 OrElse aCol > FCols - 1 Then Return FWordWrap
		Dim As Long O = ColsArr(aCol).WordWrapOption
		If bFixed AndAlso ColsArr(aCol).WordWrapOptionFixed >= 0 Then O = ColsArr(aCol).WordWrapOptionFixed
		If O <= 0 Then Return FWordWrap
		If O = FlexSingleLine Then Return False
		Return CBool(O >= FlexWordBreak)
	End Function

	Sub GridDataEx.MeasureCellText(ByVal aRow As Long, ByVal aCol As Long, ByRef W As Long, ByRef H As Long)
		'Measures the cell text with its effective (per-cell) font.
		W = 0 : H = 0
		Dim As FlexCell Ptr C = CellAt(aRow, aCol)
		Dim As UString TextValue = ""
		If C <> 0 AndAlso C->FText <> 0 Then TextValue = *C->FText
		#ifdef __USE_WINAPI__
			Dim As HDC Dc = GetDC(Handle)
			Canvas.SetHandle(Dc)
			UsePhysicalCanvas
			'Apply the per-cell font when present.
			Dim As Boolean NeedFont = False
			Dim As String SavedName = ""
			Dim As Integer SavedSize = 0
			Dim As Boolean SavedBold = False, SavedItalic = False, SavedUnderline = False, SavedStrikeOut = False
			If C <> 0 AndAlso C->Fmtg <> 0 Then
				Dim As String CellName = ""
				If C->Fmtg->FontName <> 0 Then CellName = *C->Fmtg->FontName
				NeedFont = CBool(Len(CellName) > 0) OrElse (C->Fmtg->FontSize > 0) OrElse (C->Fmtg->FontStyle <> 0)
				If NeedFont Then
					SavedName = Canvas.Font.Name
					SavedSize = Canvas.Font.Size
					SavedBold = Canvas.Font.Bold
					SavedItalic = Canvas.Font.Italic
					SavedUnderline = Canvas.Font.Underline
					SavedStrikeOut = Canvas.Font.StrikeOut
					If Len(CellName) > 0 Then Canvas.Font.Name = CellName
					If C->Fmtg->FontSize > 0 Then Canvas.Font.Size = C->Fmtg->FontSize
					Canvas.Font.Bold = IIf(C->Fmtg->FontStyle <> 0, CBool((C->Fmtg->FontStyle And FLEX_FS_BOLD) <> 0), SavedBold)
					Canvas.Font.Italic = IIf(C->Fmtg->FontStyle <> 0, CBool((C->Fmtg->FontStyle And FLEX_FS_ITALIC) <> 0), SavedItalic)
					Canvas.Font.Underline = IIf(C->Fmtg->FontStyle <> 0, CBool((C->Fmtg->FontStyle And FLEX_FS_UNDERLINE) <> 0), SavedUnderline)
					Canvas.Font.StrikeOut = IIf(C->Fmtg->FontStyle <> 0, CBool((C->Fmtg->FontStyle And FLEX_FS_STRIKEOUT) <> 0), SavedStrikeOut)
				End If
			End If
			If Len(TextValue) > 0 Then
				W = Canvas.TextWidth(TextValue)
				H = Canvas.TextHeight(TextValue)
			Else
				H = Canvas.TextHeight("Ag")
			End If
			If NeedFont Then
				Canvas.Font.Name = SavedName
				Canvas.Font.Size = SavedSize
				Canvas.Font.Bold = SavedBold
				Canvas.Font.Italic = SavedItalic
				Canvas.Font.Underline = SavedUnderline
				Canvas.Font.StrikeOut = SavedStrikeOut
			End If
			Canvas.UnSetHandle
			ReleaseDC(Handle, Dc)
		#else
			H = 16
			W = Len(TextValue) * 8
		#endif
	End Sub

	Sub GridDataEx.AutoSize(ByVal RowOrCol1 As Long, ByVal RowOrCol2 As Long, ByVal Mode As Integer, ByVal ScopeVal As Integer, ByVal Equal As Boolean, ByVal ExtraSpace As Long)
		'Best-fit column widths / row heights using real text measurement,
		'honoring per-cell fonts, word wrap lines and the BestFitMode reserves.
		Dim As Long i, j
		Dim As Single TppX = TwipsPerPixelX(), TppY = TwipsPerPixelY()
		If Mode = FlexAutoSizeModeColWidth Then
			Dim As Long c1 = Max(0, RowOrCol1), c2 = IIf(RowOrCol2 < 0, RowOrCol1, RowOrCol2)
			c2 = Min(c2, FCols - 1)
			Dim As Long GlobalMax = 0
			For j = c1 To c2
				Dim As Long StartRow = 0, EndRow = FRows - 1
				Select Case ScopeVal
					Case FlexAutoSizeScopeFixed : EndRow = FFixedRows - 1
					Case FlexAutoSizeScopeScrollable : StartRow = FFixedRows + FFrozenRows
					Case FlexAutoSizeScopeMovable : StartRow = FFixedRows
					Case FlexAutoSizeScopeFrozen : StartRow = FFixedRows : EndRow = FFixedRows + FFrozenRows - 1
				End Select
				'BestFitMode picks what reserves space besides the text.
				Dim As Long Extra = 0
				Dim As Boolean WithExtras = False
				Select Case FBestFitMode
					Case FlexBestFitModeFull
						WithExtras = True
						If ColsArr(j).SortArrow <> FlexSortArrowNone Then Extra += 14
						If (ColsArr(j).State And FLEX_CLIS_CELLBUTTONS) <> 0 Then Extra += 10
						If ColsArr(j).ComboCue >= FlexComboCueDropDown Then Extra += GetComboCueWidth(j)
						If (ColsArr(j).State And FLEX_CLIS_CHECKBOXES) <> 0 Then Extra += CvCheckBoxSize() + 4
					Case FlexBestFitModeSortArrowText
						If ColsArr(j).SortArrow <> FlexSortArrowNone Then Extra += 14
					Case FlexBestFitModeOtherText
						'Only non-fixed rows take part in the measurement.
						StartRow = Max(StartRow, FFixedRows + FFrozenRows)
				End Select
				If (ColsArr(j).State And FLEX_CLIS_HIDDEN) <> 0 Then Continue For
				Dim As Long MaxW = 0
				For i = StartRow To EndRow
					If (RowsArr(i).State And FLEX_RWIS_HIDDEN) <> 0 Then Continue For
					Dim As Long TW = 0, TH = 0
					MeasureCellText(i, j, TW, TH)
					Dim As Long W = TW + Extra + ExtraSpace * 2
					If WithExtras Then
						'Reserve space for a cell picture / icon and check marks.
						Dim As FlexCell Ptr C = CellAt(i, j)
						If C <> 0 AndAlso C->Fmtg <> 0 AndAlso C->Fmtg->PictureHandle <> 0 Then
							Dim As Long PW = C->Fmtg->PictureWidth
							If PW <= 0 Then
								Dim As Long NW = 0, NH = 0
								GetGraphicSize(C->Fmtg->PictureHandle, C->Fmtg->PictureIsIcon, NW, NH)
								PW = NW
							End If
							If PW > 0 Then W += PW + 6
						End If
						If CheckBoxesActive(i, j) Then W += CvCheckBoxSize() + 5
					End If
					If W > MaxW Then MaxW = W
				Next i
				MaxW += 8 'cell padding
				If Equal Then
					If MaxW > GlobalMax Then GlobalMax = MaxW
				Else
					ColWidth(j) = Max(120, CLng(MaxW * TppX))
				End If
			Next j
			If Equal Then
				For j = c1 To c2
					ColWidth(j) = Max(120, CLng(GlobalMax * TppX))
				Next j
			End If
		Else
			'Row heights: count the wrapped lines per column.
			Dim As Long r1 = Max(0, RowOrCol1), r2 = IIf(RowOrCol2 < 0, RowOrCol1, RowOrCol2)
			r2 = Min(r2, FRows - 1)
			Dim As Long GlobalMax = 0
			For i = r1 To r2
				Dim As Long StartCol = 0, EndCol = FCols - 1
				Select Case ScopeVal
					Case FlexAutoSizeScopeFixed : EndCol = FFixedCols - 1
					Case FlexAutoSizeScopeScrollable : StartCol = FFixedCols + FFrozenCols
					Case FlexAutoSizeScopeMovable : StartCol = FFixedCols
					Case FlexAutoSizeScopeFrozen : StartCol = FFixedCols : EndCol = FFixedCols + FFrozenCols - 1
				End Select
				Dim As Long MaxH = 0
				For j = StartCol To EndCol
					If (ColsArr(j).State And FLEX_CLIS_HIDDEN) <> 0 Then Continue For
					Dim As Long TW = 0, TH = 0
					MeasureCellText(i, j, TW, TH)
					If TH <= 0 Then TH = 16
					Dim As Long Lines = 1
					If TW > 0 AndAlso ColWraps(j, CBool(i < FFixedRows)) Then
						Dim As Long Avail = GetColWidthPx(j) - 8
						If Avail < 8 Then Avail = 8
						Lines = Max(1, (TW + Avail - 1) \ Avail)
					End If
					Dim As Long H = Lines * TH + 4
					If H > MaxH Then MaxH = H
				Next j
				If Equal Then
					If MaxH > GlobalMax Then GlobalMax = MaxH
				Else
					RowHeight(i) = Max(120, CLng(MaxH * TppY))
				End If
			Next i
			If Equal Then
				For i = r1 To r2
					RowHeight(i) = Max(120, CLng(GlobalMax * TppY))
				Next i
			End If
		End If
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Sub
	Sub GridDataEx.AutoSizeCol(ByVal aCol As Long, ByVal bIncludeFixed As Boolean = False)
		If bIncludeFixed Then
			AutoSize(aCol, aCol, FlexAutoSizeModeColWidth, FlexAutoSizeScopeAll, False, 0)
		Else
			AutoSize(aCol, aCol, FlexAutoSizeModeColWidth, FlexAutoSizeScopeScrollable, False, 0)
		End If
	End Sub

	'=== Undo / Redo ===

	Sub GridDataEx.PushUndo(ByVal aRow As Long, ByVal aCol As Long, ByRef OldText As WString, ByRef NewText As WString, ByVal SelRow As Long = -1, ByVal SelCol As Long = -1)
		'Drop the redo tail.
		Do While UBound(UndoQueue) > FUndoPos
			If UBound(UndoQueue) < 0 Then Exit Do
			Delete UndoQueue(UBound(UndoQueue))
			ReDim Preserve UndoQueue(0 To UBound(UndoQueue) - 1)
		Loop
		If FUndoLimit <= 0 Then Exit Sub
		Dim As Long Count = UBound(UndoQueue) + 1
		If Count >= FUndoLimit Then
			'Remove the oldest entry.
			If Count > 0 Then
				Delete UndoQueue(0)
				For i As Long = 0 To Count - 2
					UndoQueue(i) = UndoQueue(i + 1)
				Next i
				ReDim Preserve UndoQueue(0 To Count - 2)
				FUndoPos -= 1
			End If
		End If
		Dim As FlexUndoEntry Ptr E = New FlexUndoEntry
		WLet(E->OldText, OldText)
		WLet(E->NewText, NewText)
		E->Row = aRow : E->Col = aCol
		E->RowSel = IIf(SelRow < 0, aRow, SelRow)
		E->ColSel = IIf(SelCol < 0, aCol, SelCol)
		Dim As Long NewCount = UBound(UndoQueue) + 2
		ReDim Preserve UndoQueue(0 To NewCount - 1)
		UndoQueue(NewCount - 1) = E
		FUndoPos = NewCount - 1
	End Sub

	Sub GridDataEx.ClearUndoQueue()
		Dim i As Long
		For i = 0 To UBound(UndoQueue)
			If UndoQueue(i) <> 0 Then Delete UndoQueue(i)
			UndoQueue(i) = 0
		Next i
		Erase UndoQueue
		FUndoPos = -1
	End Sub

	Function GridDataEx.CanUndo() As Boolean
		Return (FUndoPos >= 0)
	End Function

	Function GridDataEx.CanRedo() As Boolean
		Return (FUndoPos < UBound(UndoQueue))
	End Function

	Sub GridDataEx.Undo()
		If CanUndo = False Then Exit Sub
		Dim As FlexUndoEntry Ptr E = UndoQueue(FUndoPos)
		TextToCell(*E->OldText, E->Row, E->Col)
		'Keep the entry for redo by swapping old/new.
		WLet(E->NewText, TextMatrix(E->Row, E->Col))
		FRow = E->Row : FCol = E->Col
		FUndoPos -= 1
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Sub

	Sub GridDataEx.Redo()
		If CanRedo = False Then Exit Sub
		FUndoPos += 1
		Dim As FlexUndoEntry Ptr E = UndoQueue(FUndoPos)
		TextToCell(*E->NewText, E->Row, E->Col)
		WLet(E->OldText, TextMatrix(E->Row, E->Col))
		FRow = E->Row : FCol = E->Col
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Sub

	Sub GridDataEx.ResetUndoQueue()
		ClearUndoQueue
	End Sub

	'=== Central cell text setter ===

	Function GridDataEx.TextToCell(ByRef Value As WString, ByVal aRow As Long, ByVal aCol As Long) As Boolean
		If aRow < 0 OrElse aCol < 0 OrElse aRow > FRows - 1 OrElse aCol > FCols - 1 Then Return False
		Dim As FlexCell Ptr C = CellCreate(aRow, aCol)
		If C = 0 Then Return False
		C->Text = Value
		InvalidateMergeCache
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
		Return True
	End Function

	'=== System clipboard ===

	Property GridDataEx.ClipSeparatorCol ByRef As WString
		If FClipSeparatorsCol = 0 Then Return WChr(9)
		Return *FClipSeparatorsCol
	End Property

	Property GridDataEx.ClipSeparatorCol(ByRef Value As WString)
		WLet(FClipSeparatorsCol, Value)
	End Property

	Property GridDataEx.ClipSeparatorRow ByRef As WString
		If FClipSeparatorsRow = 0 Then Return WChr(13)
		Return *FClipSeparatorsRow
	End Property

	Property GridDataEx.ClipSeparatorRow(ByRef Value As WString)
		WLet(FClipSeparatorsRow, Value)
	End Property

	Property GridDataEx.ClipMode As Integer
		Return FClipMode
	End Property

	Property GridDataEx.ClipMode(ByVal Value As Integer)
		FClipMode = Value
	End Property

	Property GridDataEx.ClipCopyMode As Integer
		Return FClipCopyMode
	End Property

	Property GridDataEx.ClipCopyMode(ByVal Value As Integer)
		FClipCopyMode = Value
	End Property

	Property GridDataEx.ClipPasteMode As Integer
		Return FClipPasteMode
	End Property

	Property GridDataEx.ClipPasteMode(ByVal Value As Integer)
		FClipPasteMode = Value
	End Property

	Function GridDataEx.ClipGet() ByRef As WString
		'Serializes the selected range with the configured separators.
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		GetSelRange(r1, c1, r2, c2)
		Dim As WString Ptr Result = 0
		Dim i As Long, j As Long
		For i = r1 To r2
			If (RowsArr(i).State And FLEX_RWIS_HIDDEN) = 0 OrElse (FClipMode <> FlexClipModeExcludeHidden AndAlso FClipMode <> FlexClipModeLookupConvExcludeHidden) Then
				For j = c1 To c2
					If (ColsArr(j).State And FLEX_CLIS_HIDDEN) = 0 OrElse (FClipMode <> FlexClipModeExcludeHidden AndAlso FClipMode <> FlexClipModeLookupConvExcludeHidden) Then
						WAdd(Result, TextMatrix(i, j))
						If j < c2 Then WAdd(Result, ClipSeparatorCol)
					End If
				Next j
				If i < r2 Then WAdd(Result, ClipSeparatorRow)
			End If
		Next i
		If Result <> 0 Then
			GridDataEx.ClipGet = *Result
			WDeAllocate(Result)
		End If
	End Function

	Property GridDataEx.Clip ByRef As WString
		Return ClipGet()
	End Property

	Property GridDataEx.Clip(ByRef Value As WString)
		ClipSet(Value)
	End Property

	Sub GridDataEx.ClipSet(ByRef Value As WString)
		'Parses separator-delimited text into the grid starting at the current cell.
		Dim As UString RowSep = ClipSeparatorRow
		Dim As UString ColSep = ClipSeparatorCol
		Dim As Long RowIdx = min(FRow, FRowSel)
		Dim As Long ColIdxStart = min(FCol, FColSel)
		Dim As Long PosStart = 1
		Dim As Long GrowRows = 0, GrowCols = 0
		'Count needed size first.
		Dim As Long NeedRows = 0, NeedCols = 0
		Dim As UString LineChunk, LineText
		Do While PosStart <= Len(Value) + 1
			LineChunk = Mid(Value, PosStart)
			Dim As Long SepPos = InStr(LineChunk, RowSep)
			If SepPos > 0 Then LineText = Mid(LineChunk, 1, SepPos - 1) Else LineText = LineChunk
			NeedRows += 1
			Dim As Long FieldStart = 1, Fields = 0
			Do While FieldStart <= Len(LineText) + 1
				Dim As Long TabPos = InStr(Mid(LineText, FieldStart), ColSep)
				Fields += 1
				If TabPos = 0 Then Exit Do
				FieldStart += TabPos
			Loop
			If Fields > NeedCols Then NeedCols = Fields
			If SepPos = 0 Then Exit Do
			PosStart += SepPos
		Loop
		GrowRows = Max(0, RowIdx + NeedRows - FRows)
		GrowCols = Max(0, ColIdxStart + NeedCols - FCols)
		If GrowRows > 0 OrElse GrowCols > 0 Then
			Dim As Long NewRows = FRows + GrowRows, NewCols = FCols + GrowCols
			If FClipPasteMode = FlexClipPasteModeAutoSelection OrElse FClipPasteMode = FlexClipPasteModeExtendedAutoSelection Then
				Rows = NewRows
				Cols = NewCols
			Else
				Rows = Max(FRows, NewRows)
				Cols = Max(FCols, NewCols)
			End If
		End If
		'Write the fields.
		PosStart = 1
		Dim As Long RowCur = RowIdx
		Do While PosStart <= Len(Value) + 1 AndAlso RowCur <= FRows - 1
			LineChunk = Mid(Value, PosStart)
			Dim As Long SepPos = InStr(LineChunk, RowSep)
			If SepPos > 0 Then LineText = Mid(LineChunk, 1, SepPos - 1) Else LineText = LineChunk
			Dim As Long ColCur = ColIdxStart
			Dim As Long FieldStart = 1
			Dim As UString Rest, CellTextValue
			Do While FieldStart <= Len(LineText) + 1 AndAlso ColCur <= FCols - 1
				Rest = Mid(LineText, FieldStart)
				Dim As Long TabPos = InStr(Rest, ColSep)
				If TabPos > 0 Then CellTextValue = Mid(Rest, 1, TabPos - 1) Else CellTextValue = Rest
				TextToCell(CellTextValue, RowCur, ColCur)
				ColCur += 1
				If TabPos = 0 Then Exit Do
				FieldStart += TabPos
			Loop
			RowCur += 1
			If SepPos = 0 Then Exit Do
			PosStart += SepPos
		Loop
		If FClipPasteMode = FlexClipPasteModeAutoSelection OrElse FClipPasteMode = FlexClipPasteModeExtendedAutoSelection Then
			'Select the pasted range.
			FRowSel = min(FRows - 1, RowIdx + NeedRows - 1)
			FColSel = min(FCols - 1, ColIdxStart + NeedCols - 1)
			If OnSelChange Then OnSelChange(*Designer, This)
		End If
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Sub

	Sub GridDataEx.Copy()
		Dim As Boolean Cxl = False
		If OnBeforeClipboardAction Then OnBeforeClipboardAction(*Designer, This, FlexClipboardActionCopy, Cxl)
		If Cxl Then Exit Sub
		Clipboard.SetAsText(ClipGet())
		If OnAfterClipboardAction Then OnAfterClipboardAction(*Designer, This, FlexClipboardActionCopy)
	End Sub

	Sub GridDataEx.Cut()
		Dim As Boolean Cxl = False
		If OnBeforeClipboardAction Then OnBeforeClipboardAction(*Designer, This, FlexClipboardActionCut, Cxl)
		If Cxl Then Exit Sub
		Clipboard.SetAsText(ClipGet())
		DeleteSel
		If OnAfterClipboardAction Then OnAfterClipboardAction(*Designer, This, FlexClipboardActionCut)
	End Sub

	Sub GridDataEx.Paste()
		Dim As Boolean Cxl = False
		If OnBeforeClipboardAction Then OnBeforeClipboardAction(*Designer, This, FlexClipboardActionPaste, Cxl)
		If Cxl Then Exit Sub
		Dim As UString Text_ = Clipboard.GetAsText()
		If Len(Text_) > 0 Then ClipSet(Text_)
		If OnAfterClipboardAction Then OnAfterClipboardAction(*Designer, This, FlexClipboardActionPaste)
	End Sub

	Function GridDataEx.CanPaste() As Boolean
		#ifdef __USE_WINAPI__
			#ifdef __USE_WINAPI__
				Return Clipboard.HasFormat(CF_UNICODETEXT)
			#endif
		#endif
		'GTK/web builds have no format query: an empty clipboard cannot paste.
		Return Len(Clipboard.GetAsText()) > 0
	End Function

	Sub GridDataEx.DeleteSel()
		Dim As Boolean Cxl = False
		If OnBeforeClipboardAction Then OnBeforeClipboardAction(*Designer, This, FlexClipboardActionDelete, Cxl)
		If Cxl Then Exit Sub
		'Clears the text of the selected range (respecting merged masters).
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		GetSelRange(r1, c1, r2, c2)
		Dim i As Long, j As Long
		Dim As UString OldText
		For i = r1 To r2
			For j = c1 To c2
				Dim As Long MR1, MC1, MR2, MC2
				GetMergedRange(i, j, MR1, MC1, MR2, MC2)
				If (i = MR1) AndAlso (j = MC1) Then
					OldText = TextMatrix(i, j)
					If Len(OldText) > 0 Then
						TextToCell("", i, j)
						PushUndo(i, j, OldText, "")
					End If
				End If
			Next j
		Next i
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
		If OnAfterClipboardAction Then OnAfterClipboardAction(*Designer, This, FlexClipboardActionDelete)
	End Sub

	'=== Edit state properties ===

	Property GridDataEx.EditRow As Long
		Return FEditRow
	End Property

	Property GridDataEx.EditCol As Long
		Return FEditCol
	End Property

	Property GridDataEx.EditReason As Integer
		Return FEditReason
	End Property

	Property GridDataEx.EditCloseMode As Integer
		Return FEditCloseMode
	End Property

	Property GridDataEx.EditText ByRef As WString
		If FInEdit AndAlso EditText_ <> 0 Then Return EditText_->Text
		Return ""
	End Property

	Property GridDataEx.EditText(ByRef Value As WString)
		If FInEdit AndAlso EditText_ <> 0 Then EditText_->Text = Value
	End Property

	Property GridDataEx.EditLocked As Boolean
		Return FEditLocked
	End Property

	Property GridDataEx.EditLocked(ByVal Value As Boolean)
		FEditLocked = Value
	End Property

	Property GridDataEx.EditMaxLength As Long
		Return FEditMaxLength
	End Property

	Property GridDataEx.EditMaxLength(ByVal Value As Long)
		FEditMaxLength = Max(0, Value)
		#ifdef __USE_WINAPI__
			If EditText_ <> 0 AndAlso EditText_->Handle <> 0 Then
				SendMessage(EditText_->Handle, EM_SETLIMITTEXT, IIf(FEditMaxLength > 0, FEditMaxLength, 32767), 0)
			End If
		#endif
	End Property

	Property GridDataEx.EditSelStart As Long
		If FInEdit AndAlso EditText_ <> 0 Then Return EditText_->SelStart
		Return 0
	End Property

	Property GridDataEx.EditSelStart(ByVal Value As Long)
		If FInEdit AndAlso EditText_ <> 0 Then
			Value = Max(0, min(Value, Len(EditText_->Text)))
			EditText_->SetSel(Value, Value + EditText_->SelLength)
		End If
	End Property

	Property GridDataEx.EditSelLength As Long
		If FInEdit AndAlso EditText_ <> 0 Then Return EditText_->SelLength
		Return 0
	End Property

	Property GridDataEx.EditSelLength(ByVal Value As Long)
		If FInEdit AndAlso EditText_ <> 0 Then
			Value = Max(0, min(Value, Len(EditText_->Text) - EditText_->SelStart))
			EditText_->SetSel(EditText_->SelStart, EditText_->SelStart + Value)
		End If
	End Property

	Property GridDataEx.EditSelText ByRef As WString
		If FInEdit AndAlso EditText_ <> 0 Then Return EditText_->SelText
		Return ""
	End Property

	Property GridDataEx.EditSelText(ByRef Value As WString)
		If FInEdit AndAlso EditText_ <> 0 Then
			'Replace the selection with Value.
			Dim As Long S = EditText_->SelStart, L = EditText_->SelLength
			Dim As UString T = EditText_->Text
			EditText_->Text = Mid(T, 1, S) & Value & Mid(T, S + L + 1)
			EditText_->SetSel(S + Len(Value), S + Len(Value))
			FEditChanged = True
		End If
	End Property

	Property GridDataEx.IncrementalSearchString ByRef As WString
		If FIncrSearchString = 0 Then Return ""
		Return *FIncrSearchString
	End Property

	Property GridDataEx.Version As Integer
		Return 183
	End Property

	Sub GridDataEx.IncrementalSearchAdvance(ByVal CharCode As Long)
		'Extends the incremental search string and moves to the next match.
		If FAllowIncrementalSearch = False Then Exit Sub
		Dim As Long Ch = CharCode And &HFF
		If Ch < 32 Then
			If Ch = VK_BACK Then
				'Strip last character.
				If FIncrSearchString <> 0 AndAlso Len(*FIncrSearchString) > 0 Then
					WLet(FIncrSearchString, Mid(*FIncrSearchString, 1, Len(*FIncrSearchString) - 1))
				Else
					FIncrSearchActive = False
				End If
			Else
				If CBool(FIncrSearchActive) AndAlso OnEndIncrementalSearch <> 0 Then OnEndIncrementalSearch(*Designer, This)
				FIncrSearchActive = False
				WLet(FIncrSearchString, "")
			End If
		Else
			If FIncrSearchActive = False Then
				Dim As Long BRow = FRow, BCol = FCol
				Dim As Boolean BCase = False, BNoWrap = False, BCancel = False
				If OnBeginIncrementalSearch Then OnBeginIncrementalSearch(*Designer, This, BRow, BCol, BCase, BNoWrap, BCancel)
				If BCancel Then Exit Sub
				FIncrSearchActive = True
				FRow = Max(0, min(BRow, FRows - 1))
				FCol = Max(0, min(BCol, FCols - 1))
				WLet(FIncrSearchString, "")
			End If
			WAdd(FIncrSearchString, Chr(Ch))
		End If
		Dim As UString SearchText = ""
		If FIncrSearchString <> 0 Then SearchText = *FIncrSearchString
		If Len(SearchText) = 0 Then Exit Sub
		Dim As Long StartRow = FRow, StartCol = FCol
		Dim i As Long, j As Long
		i = StartRow : j = StartCol + 1
		Do While i <= FRows - 1
			Do While j <= FCols - 1
				If InStr(UCase(TextMatrix(i, j)), UCase(SearchText)) = 1 Then
					Row = i
					Col = j
					Exit Sub
				End If
				j += 1
			Loop
			i += 1 : j = FFixedCols
		Loop
	End Sub

	'=== Cell picture / icon rendering ===

	Sub GridDataEx.GetGraphicSize(ByVal Handle As Any Ptr, ByVal IsIcon As Boolean, ByRef W As Long, ByRef H As Long)
		'Returns the native pixel size of an HICON/HBITMAP (Windows) or GdkPixbuf (GTK).
		W = 0 : H = 0
		If Handle = 0 Then Exit Sub
		#ifdef __USE_GTK__
			'On GTK the graphic of a cell is a GdkPixbuf (My.Sys.Drawing.Bitmap.Handle)
			Dim pixbuf As GdkPixbuf Ptr = Cast(GdkPixbuf Ptr, Handle)
			W = gdk_pixbuf_get_width(pixbuf)
			H = gdk_pixbuf_get_height(pixbuf)
		#elseif defined(__USE_WINAPI__)
			If IsIcon Then
				Dim As ICONINFO II
				If GetIconInfo(Cast(HICON, Handle), @II) <> 0 Then
					Dim As BITMAP BM
					If II.hbmColor <> 0 AndAlso GetObject(II.hbmColor, SizeOf(Bitmap), @BM) <> 0 Then
						W = BM.bmWidth
						H = BM.bmHeight
					End If
					If II.hbmColor <> 0 Then DeleteObject(II.hbmColor)
					If II.hbmMask <> 0 Then DeleteObject(II.hbmMask)
				End If
				If W <= 0 Then
					W = GetSystemMetrics(SM_CXICON)
					H = GetSystemMetrics(SM_CYICON)
				End If
			Else
				Dim As BITMAP BM
				If GetObject(Handle, SizeOf(Bitmap), @BM) <> 0 Then
					W = BM.bmWidth
					H = BM.bmHeight
				End If
			End If
		#endif
	End Sub

	Sub GridDataEx.RenderGraphic(ByRef Cv As My.Sys.Drawing.Canvas, ByVal Handle As Any Ptr, ByVal IsIcon As Boolean, ByVal X As Long, ByVal Y As Long, ByVal W As Long, ByVal H As Long)
		'Draws the graphic at X/Y scaled to W x H (Windows: GDI, GTK: cairo).
		If Handle = 0 OrElse W <= 0 OrElse H <= 0 Then Exit Sub
		#ifdef __USE_GTK__
			'The graphic of a cell is a GdkPixbuf on GTK (icons included)
			Dim pixbuf As GdkPixbuf Ptr = Cast(GdkPixbuf Ptr, Handle)
			Dim cr As cairo_t Ptr = Cast(cairo_t Ptr, Cv.Handle)
			If cr = 0 Then Exit Sub
			Dim NW As Long = gdk_pixbuf_get_width(pixbuf)
			Dim NH As Long = gdk_pixbuf_get_height(pixbuf)
			If NW <= 0 OrElse NH <= 0 Then NW = W : NH = H
			cairo_save(cr)
			cairo_translate(cr, X, Y)
			cairo_scale(cr, W / NW, H / NH)
			gdk_cairo_set_source_pixbuf(cr, pixbuf, 0, 0)
			cairo_rectangle(cr, 0, 0, NW, NH)
			cairo_fill(cr)
			cairo_restore(cr)
		#elseif defined(__USE_WINAPI__)
			If IsIcon Then
				DrawIconEx(Cast(HDC, Cv.Handle), X, Y, Cast(HICON, Handle), W, H, 0, NULL, DI_NORMAL)
			Else
				Dim As Long NW = 0, NH = 0
				GetGraphicSize(Handle, False, NW, NH)
				If NW <= 0 OrElse NH <= 0 Then NW = W : NH = H
				Dim As HDC MemDC = CreateCompatibleDC(Cast(HDC, Cv.Handle))
				If MemDC = 0 Then Exit Sub
				Dim As HGDIOBJ OldBmp = SelectObject(MemDC, Cast(HGDIOBJ, Handle))
				If (W = NW) AndAlso (H = NH) Then
					BitBlt(Cast(HDC, Cv.Handle), X, Y, W, H, MemDC, 0, 0, SRCCOPY)
				Else
					SetStretchBltMode(Cast(HDC, Cv.Handle), COLORONCOLOR)
					StretchBlt(Cast(HDC, Cv.Handle), X, Y, W, H, MemDC, 0, 0, NW, NH, SRCCOPY)
				End If
				SelectObject(MemDC, OldBmp)
				DeleteDC(MemDC)
			End If
		#endif
	End Sub

	Sub GridDataEx.DrawCellPicture(ByRef Cv As My.Sys.Drawing.Canvas, ByVal RCLeft As Long, ByVal RCTop As Long, ByVal RCRight As Long, ByVal RCBottom As Long, ByVal aRow As Long, ByVal aCol As Long, ByRef IndentL As Long, ByRef IndentR As Long)
		'Draws the cell's picture/icon at its configured size in its configured
		'direction. For the NoOverlap alignments the text indents are widened so
		'the caption does not run beneath the graphic.
		'The placement logic is platform independent; RenderGraphic hides the
		'backend (HBITMAP/HICON on Windows, GdkPixbuf on GTK).
		IndentL = 0 : IndentR = 0
		Dim As FlexCell Ptr C = CellAt(aRow, aCol)
		If C = 0 OrElse C->Fmtg = 0 Then Exit Sub
		Dim As FlexCellFormat Ptr F = C->Fmtg
		If F->PictureHandle = 0 Then Exit Sub
		Dim As Long Align = F->PictureAlignment
		If Align < FlexPictureAlignmentLeftTop Then Align = FlexPictureAlignmentLeftTop
		Dim As Long Pad = 2
		Dim As Long CellW = RCRight - RCLeft, CellH = RCBottom - RCTop
		'Render size: configured values or the native size.
		Dim As Long W = F->PictureWidth, H = F->PictureHeight
		If W <= 0 OrElse H <= 0 Then
			Dim As Long NW = 0, NH = 0
			GetGraphicSize(F->PictureHandle, F->PictureIsIcon, NW, NH)
			If W <= 0 Then W = IIf(NW > 0, NW, 16)
			If H <= 0 Then H = IIf(NH > 0, NH, 16)
		End If
		If Align = FlexPictureAlignmentStretch Then
			'Fill the whole cell minus a small margin.
			RenderGraphic(Cv, F->PictureHandle, F->PictureIsIcon, RCLeft + Pad, RCTop + Pad, Max(1, CellW - Pad * 2), Max(1, CellH - Pad * 2))
			Exit Sub
		End If
		If Align = FlexPictureAlignmentTile Then
			'Repeat at the configured (or native) size across the cell.
			Dim As Long Y = RCTop + Pad
			Do While Y < RCBottom
				Dim As Long X = RCLeft + Pad
				Do While X < RCRight
					RenderGraphic(Cv, F->PictureHandle, F->PictureIsIcon, X, Y, W, H)
					X += W
				Loop
				Y += H
			Loop
			Exit Sub
		End If
		'Nine-grid placement.
		Dim As Long X = RCLeft + Pad, Y = RCTop + Pad
		Select Case Align
			Case FlexPictureAlignmentCenterTop, FlexPictureAlignmentCenterCenter, FlexPictureAlignmentCenterBottom
				X = RCLeft + (CellW - W) \ 2
			Case FlexPictureAlignmentRightTop, FlexPictureAlignmentRightCenter, FlexPictureAlignmentRightBottom, _
			     FlexPictureAlignmentRightTopNoOverlap, FlexPictureAlignmentRightCenterNoOverlap, FlexPictureAlignmentRightBottomNoOverlap
				X = RCRight - Pad - W
		End Select
		Select Case Align
			Case FlexPictureAlignmentLeftCenter, FlexPictureAlignmentCenterCenter, FlexPictureAlignmentRightCenter, _
			     FlexPictureAlignmentRightCenterNoOverlap
				Y = RCTop + (CellH - H) \ 2
			Case FlexPictureAlignmentLeftBottom, FlexPictureAlignmentCenterBottom, FlexPictureAlignmentRightBottom, _
			     FlexPictureAlignmentLeftBottomNoOverlap, FlexPictureAlignmentRightBottomNoOverlap
				Y = RCBottom - Pad - H
		End Select
		RenderGraphic(Cv, F->PictureHandle, F->PictureIsIcon, X, Y, W, H)
		'Text avoidance for the NoOverlap variants.
		If Align >= FlexPictureAlignmentLeftTopNoOverlap Then
			Select Case Align
				Case FlexPictureAlignmentLeftTopNoOverlap, FlexPictureAlignmentLeftCenterNoOverlap, FlexPictureAlignmentLeftBottomNoOverlap
					IndentL = W + Pad * 2
				Case FlexPictureAlignmentRightTopNoOverlap, FlexPictureAlignmentRightCenterNoOverlap, FlexPictureAlignmentRightBottomNoOverlap
					IndentR = W + Pad * 2
			End Select
		End If
	End Sub

	'=== Visibility helpers ===

	Function GridDataEx.IsRowVisible(ByVal aRow As Long) As Boolean
		If aRow < 0 OrElse aRow > FRows - 1 Then Return False
		Return CBool((RowsArr(aRow).State And FLEX_RWIS_HIDDEN) = 0)
	End Function

	Function GridDataEx.IsColVisible(ByVal aCol As Long) As Boolean
		If aCol < 0 OrElse aCol > FCols - 1 Then Return False
		Return CBool((ColsArr(aCol).State And FLEX_CLIS_HIDDEN) = 0)
	End Function

	'=== Drawing helpers ===

	Sub GridDataEx.DrawSortArrow(ByRef Cv As My.Sys.Drawing.Canvas, ByVal XCenter As Long, ByVal YCenter As Long, ByVal Direction As Integer, ByVal Clr As Long)
		'Draws a small filled triangle: Direction 1 = ascending (up), 2 = descending (down).
		Dim As Long HalfW = 4, HalfH = 3
		Dim As My.Sys.Drawing.Point Tri(0 To 2)
		If Direction = FlexSortArrowAscending Then
			Tri(0).X = XCenter : Tri(0).Y = YCenter - HalfH
			Tri(1).X = XCenter - HalfW : Tri(1).Y = YCenter + HalfH
			Tri(2).X = XCenter + HalfW : Tri(2).Y = YCenter + HalfH
		Else
			Tri(0).X = XCenter : Tri(0).Y = YCenter + HalfH
			Tri(1).X = XCenter - HalfW : Tri(1).Y = YCenter - HalfH
			Tri(2).X = XCenter + HalfW : Tri(2).Y = YCenter - HalfH
		End If
		Dim As Long SavedPen = Cv.Pen.Color
		Dim As Long SavedBrush = Cv.Brush.Color
		Cv.Pen.Color = Clr
		Cv.Brush.Color = Clr
		Cv.Polygon(Tri(), 3)
		Cv.Pen.Color = SavedPen
		Cv.Brush.Color = SavedBrush
	End Sub

	Sub GridDataEx.DrawCheckBoxGlyph(ByRef Cv As My.Sys.Drawing.Canvas, ByVal XLeft As Long, ByVal YTop As Long, ByVal Size As Long, ByVal CheckedState As Integer, ByVal bDisabled As Boolean)
		'Owner-drawn checkbox: flat frame, check mark / gray fill.
		Dim As Long ClrFrame = FlexWinColor(&H808080)
		Dim As Long ClrBack = FlexWinColor(&HFFFFFF)
		Dim As Long ClrMark = FlexWinColor(&H000000)
		Dim As Long ClrGray = FlexWinColor(&HC0C0C0)
		If bDisabled Then
			ClrMark = FlexWinColor(&HA0A0A0)
		End If
		Dim As My.Sys.Drawing.Rect RC
		RC.Left = XLeft : RC.Top = YTop : RC.Right = XLeft + Size : RC.Bottom = YTop + Size
		Cv.FillRect(RC, ClrBack)
		Cv.Rectangle(XLeft, YTop, XLeft + Size, YTop + Size)
		Cv.Line(XLeft, YTop, XLeft + Size, YTop, ClrFrame)
		Cv.Line(XLeft, YTop, XLeft, YTop + Size, ClrFrame)
		Select Case CheckedState
			Case FlexChecked
				'Draw a check mark.
				Dim As Long x1 = XLeft + Size \ 5, y1 = YTop + Size \ 2
				Dim As Long x2 = XLeft + Size \ 2, y2 = YTop + Size * 4 \ 5
				Dim As Long x3 = XLeft + Size * 9 \ 10, y3 = YTop + Size \ 5
				Cv.Line(x1, y1, x2, y2, ClrMark)
				Cv.Line(x2, y2, x3, y3, ClrMark)
			Case FlexGrayed
				Dim As My.Sys.Drawing.Rect RCG
				RCG.Left = XLeft + 2 : RCG.Top = YTop + 2
				RCG.Right = XLeft + Size - 2 : RCG.Bottom = YTop + Size - 2
				Cv.FillRect(RCG, ClrGray)
		End Select
	End Sub

	Sub GridDataEx.DrawFloodFill(ByRef Cv As My.Sys.Drawing.Canvas, ByVal RCLeft As Long, ByVal RCTop As Long, ByVal RCRight As Long, ByVal RCBottom As Long, ByVal Percent As Integer, ByVal Clr As Long)
		'Fills Percent% of the cell width with Clr (like a progress bar).
		If Percent <= 0 Then Exit Sub
		Dim As Long W = RCRight - RCLeft
		Dim As Long FillW = CLng(W * Percent / 100)
		If FillW <= 0 Then Exit Sub
		Dim As My.Sys.Drawing.Rect RC
		RC.Left = RCLeft : RC.Top = RCTop : RC.Right = RCLeft + FillW : RC.Bottom = RCBottom
		Cv.FillRect(RC, FlexWinColor(Clr))
	End Sub

	Sub GridDataEx.ApplyTextStyleFrame(ByRef Cv As My.Sys.Drawing.Canvas, ByVal RCLeft As Long, ByVal RCTop As Long, ByVal RCRight As Long, ByVal RCBottom As Long, ByVal Style As Integer, ByVal bLight As Boolean)
		'Applies the VB text style bevel around the cell.
		Dim As Long ClrWhite = FlexWinColor(&HFFFFFF)
		Dim As Long ClrBlack = FlexWinColor(&H000000)
		Dim As Long ClrGray = FlexWinColor(&H808080)
		Select Case Style
			Case FlexTextStyleRaised, FlexTextStyleInset
				Dim As Long Hi = IIf(Style = FlexTextStyleRaised, ClrWhite, ClrBlack)
				Dim As Long Lo = IIf(Style = FlexTextStyleRaised, ClrBlack, ClrWhite)
				Cv.Line(RCLeft, RCBottom - 1, RCRight - 1, RCBottom - 1, Hi)
				Cv.Line(RCRight - 1, RCTop, RCRight - 1, RCBottom - 1, Hi)
				Cv.Line(RCLeft, RCTop, RCRight - 2, RCTop, Lo)
				Cv.Line(RCLeft, RCTop, RCLeft, RCBottom - 2, Lo)
			Case FlexTextStyleRaisedLight, FlexTextStyleInsetLight
				Dim As Long Hi = IIf(Style = FlexTextStyleRaisedLight, ClrWhite, ClrGray)
				Dim As Long Lo = IIf(Style = FlexTextStyleRaisedLight, ClrGray, ClrWhite)
				Cv.Line(RCLeft, RCBottom - 1, RCRight - 1, RCBottom - 1, Hi)
				Cv.Line(RCRight - 1, RCTop, RCRight - 1, RCBottom - 1, Hi)
				Cv.Line(RCLeft, RCTop, RCRight - 2, RCTop, Lo)
				Cv.Line(RCLeft, RCTop, RCLeft, RCBottom - 2, Lo)
		End Select
	End Sub

	Function GridDataEx.GetCellAlign(ByVal aRow As Long, ByVal aCol As Long, ByVal bFixedArea As Boolean) As Integer
		If aCol < 0 OrElse aCol > FCols - 1 Then Return FlexAlignmentGeneral
		If bFixedArea Then
			If ColsArr(aCol).FixedAlignment >= 0 Then Return ColsArr(aCol).FixedAlignment
		End If
		Return ColsArr(aCol).Alignment
	End Function

	Function GridDataEx.GetGridLineColor(ByVal aRow As Long, ByVal aCol As Long, ByVal bFixedArea As Boolean) As Long
		'Resolves the grid line color for the given cell (frozen/fixed/normal).
		Dim As Boolean IsFrozenRow = CBool((aRow >= FFixedRows) AndAlso (aRow < FFixedRows + FFrozenRows))
		Dim As Boolean IsFrozenCol = CBool((aCol >= FFixedCols) AndAlso (aCol < FFixedCols + FFrozenCols))
		If bFixedArea Then Return FlexWinColor(FGridColorFixed)
		If IsFrozenRow OrElse IsFrozenCol Then
			If FGridColorFrozen >= 0 Then Return FlexWinColor(FGridColorFrozen)
		End If
		Return FlexWinColor(FGridColor)
	End Function
	'=== FlexEditTextBox: the in-place editor ===

	Sub FlexEditTextBox.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_WINAPI__
		Dim As GridDataEx Ptr G = Cast(GridDataEx Ptr, Grid)
		If G <> 0 AndAlso Message.Msg = WM_KEYDOWN Then
			Dim As Integer KeyCode = CInt(Message.wParam)
			Dim As Integer ShiftState = FlexGetShiftStateFromMsg()
			If G->EditBoxKeyDown(KeyCode, ShiftState) Then
				Message.Result = 0
				Return
			End If
		End If
		#endif
		Base.ProcessMessage(Message)
	End Sub

	#ifndef __USE_WINAPI__
		Sub FlexEditTextBox.Edit_KeyDown(ByRef Designer As My.Sys.Object, ByRef Sender As Control, Key As Integer, Shift As Integer)
			Dim As GridDataEx Ptr G = Cast(GridDataEx Ptr, Cast(FlexEditTextBox Ptr, @Sender)->Grid)
			If G = 0 Then Exit Sub
			#ifdef __USE_GTK__
				G->EditBoxKeyDown(FlexKeyToVK(Key), FlexGdkShift(Shift))
			#else
				G->EditBoxKeyDown(Key, FlexGdkShift(Shift))
			#endif
		End Sub
	#endif

	Sub GridDataEx.EditBoxChanged()
		'Enforce EditMaxLength cross-platform, then notify.
		If FEditMaxLength > 0 AndAlso EditText_ <> 0 AndAlso Len(EditText_->Text) > FEditMaxLength Then
			EditText_->Text = Mid(EditText_->Text, 1, FEditMaxLength)
		End If
		FEditChanged = True
		If OnEditChange Then OnEditChange(*Designer, This)
	End Sub

	Sub GridDataEx.EditBoxLostFocus()
		'Commit on focus loss unless a drop-down popup is interacting.
		If FComboDropped Then Exit Sub
		If FFilterEditActive Then
			ApplyFilterEdit
			Exit Sub
		End If
		If FInEdit Then CommitEditInternal(FlexEditCloseModeLostFocus)
	End Sub

	Function GridDataEx.EditBoxKeyDown(ByVal KeyCode As Long, ByVal Shift As Integer) As Boolean
		'Called by the in-place editor for each key down. Returns True when consumed.
		'While the filter criteria editor is open Return/Tab apply and Esc cancels.
		If FFilterEditActive Then
			Select Case KeyCode
				Case VK_RETURN, VK_TAB : ApplyFilterEdit : Return True
				Case VK_ESCAPE : CancelFilterEdit : Return True
			End Select
			Return False
		End If
		'While the calculator popup is open it receives the keys.
		If CalcPanel_ <> 0 AndAlso CalcPanel_->Visible Then
			Select Case KeyCode
				Case VK_ESCAPE : CancelEdit : Return True
				Case VK_RETURN : CalcApplyKey("=") : Return True
				Case VK_BACK : CalcApplyKey("<-") : Return True
				Case VK_DIVIDE : CalcApplyKey("/") : Return True
				Case VK_MULTIPLY : CalcApplyKey("*") : Return True
				Case VK_SUBTRACT : CalcApplyKey("-") : Return True
				Case VK_ADD : CalcApplyKey("+") : Return True
				Case VK_DECIMAL, &HBE : CalcApplyKey(".") : Return True
				Case &H30 To &H39 : CalcApplyKey(Chr(KeyCode)) : Return True
				Case &H60 To &H69 : CalcApplyKey(Chr(KeyCode - &H60 + &H30)) : Return True
				Case VK_F4
					If FComboDropped Then CloseDropDown(True) Else ShowDropDown
					Return True
			End Select
			Return True
		End If
		Select Case KeyCode
			Case VK_F4
				If FComboDropped Then
					CloseDropDown(True)
				Else
					ShowDropDown
				End If
				Return True
			Case VK_DOWN
				If (Shift And FLEX_ALT_MASK) = FLEX_ALT_MASK Then
					If FComboDropped = False Then ShowDropDown
					Return True
				End If
				If (Shift And FLEX_CTRL_MASK) = FLEX_CTRL_MASK Then
					If FInEdit Then CommitEditInternal(FlexEditCloseModeNavigationKey)
					If Row < FRows - 1 Then Row = Row + 1
					Return True
				End If
			Case VK_RETURN
				If FWantReturn = False Then
					If FInEdit Then CommitEditInternal(FlexEditCloseModeReturn)
					Return True
				End If
			Case VK_ESCAPE
				If FInEdit Then CancelEdit
				Return True
			Case VK_TAB
				If FTabBehavior = FlexTabCells Then
					If FInEdit Then
						CommitEditInternal(IIf((Shift And FLEX_SHIFT_MASK) = FLEX_SHIFT_MASK, FlexEditCloseModeShiftTab, FlexEditCloseModeTab))
					End If
					Return True
				End If
			Case VK_UP
				If (Shift And FLEX_CTRL_MASK) = FLEX_CTRL_MASK Then
					If FInEdit Then CommitEditInternal(FlexEditCloseModeNavigationKey)
					If Row > FFixedRows Then Row = Row - 1
					Return True
				End If
			Case VK_LEFT, VK_RIGHT
				'Ctrl+Left/Right move the current cell while editing.
				If (Shift And FLEX_CTRL_MASK) = FLEX_CTRL_MASK Then
					If FInEdit Then CommitEditInternal(FlexEditCloseModeNavigationKey)
					If KeyCode = VK_RIGHT AndAlso Col < FCols - 1 Then Col = Col + 1
					If KeyCode = VK_LEFT AndAlso Col > FFixedCols Then Col = Col - 1
					Return True
				End If
		End Select
		Return False
	End Function

	Sub FlexEditTextBox.Edit_Change(ByRef Designer As My.Sys.Object, ByRef Sender As TextBox)
		Dim As FlexEditTextBox Ptr E = Cast(FlexEditTextBox Ptr, @Sender)
		Dim As GridDataEx Ptr G = Cast(GridDataEx Ptr, E->Grid)
		If G = 0 Then Exit Sub
		G->EditBoxChanged
	End Sub

	Sub FlexEditTextBox.Edit_LostFocus(ByRef Designer As My.Sys.Object, ByRef Sender As TextBox)
		Dim As FlexEditTextBox Ptr E = Cast(FlexEditTextBox Ptr, @Sender)
		Dim As GridDataEx Ptr G = Cast(GridDataEx Ptr, E->Grid)
		If G = 0 Then Exit Sub
		G->EditBoxLostFocus
	End Sub

	'=== The cursor and the capture of the mouse ===

	Sub GridDataEx.SetGridCursor(ByVal Kind As Integer)
		#ifdef __USE_WINAPI__
			Select Case Kind
			Case 1: SetCursor(LoadCursor(NULL, IDC_SIZEWE))
			Case 2: SetCursor(LoadCursor(NULL, IDC_SIZENS))
			Case 3: SetCursor(LoadCursor(NULL, IDC_HAND))
			End Select
		#else
			'InputMouseMove shows it after the move (the arrow when no part asked for another one)
			FPendingCursor = Kind
		#endif
	End Sub

	Sub GridDataEx.GridCapture(ByVal Value As Boolean)
		#ifdef __USE_WINAPI__
			If Value Then
				SetCapture(Handle)
			Else
				ReleaseCapture()
			End If
		#endif
	End Sub

	#ifndef __USE_WINAPI__
	'=== GTK, the Web and Android: the own scroll bars ===
	'The grid has no scroll bars of a window there: it draws them at the right and
	'the bottom edge of its client area and handles their presses and drags.

	Function GridDataEx.OwnScrollBarSize() As Long
		Return LogicalToPxX(14)
	End Function

	'The whole client area in the pixels of the painting and of the mouse
	Function GridDataEx.OwnFullWidth() As Long
		#ifdef __USE_GTK__
			If widget = 0 Then Return 0
			#ifdef __USE_GTK4__
				Return gtk_widget_get_width(widget)
			#else
				Return gtk_widget_get_allocated_width(widget)
			#endif
		#else
			Return ScaleX(ClientWidth)
		#endif
	End Function

	Function GridDataEx.OwnFullHeight() As Long
		#ifdef __USE_GTK__
			If widget = 0 Then Return 0
			#ifdef __USE_GTK4__
				Return gtk_widget_get_height(widget)
			#else
				Return gtk_widget_get_allocated_height(widget)
			#endif
		#else
			Return ScaleY(ClientHeight)
		#endif
	End Function

	Sub GridDataEx.SetScrollBarsInternal
		Dim As Long FullW = OwnFullWidth(), FullH = OwnFullHeight()
		Dim As Long SB = OwnScrollBarSize()
		Dim As Long TotalHeight = RowTopY(FRows) + FilterBarHeightPx()
		Dim As Long TotalWidth = ColLeftX(FCols)
		Dim As Boolean NeedV = False, NeedH = False
		'Twice: a bar takes the room of the other direction
		For iPass As Integer = 1 To 2
			NeedV = CBool(FScrollBars = 2 OrElse FScrollBars = 3) AndAlso TotalHeight > FullH - IIf(NeedH, SB, 0)
			NeedH = CBool(FScrollBars = 1 OrElse FScrollBars = 3) AndAlso TotalWidth > FullW - IIf(NeedV, SB, 0)
		Next
		FOwnVScroll = NeedV
		FOwnHScroll = NeedH
		FScrollBarsDirty = False
	End Sub

	Sub GridDataEx.ScrollGridPixels(ByVal dX As Long, ByVal dY As Long)
		RepaintGrid
	End Sub

	'The track and the thumb of a bar along it (Vertical: the rows from TopRow, else
	'the columns from LeftCol); False when the bar is not shown
	Function GridDataEx.OwnScrollBarRects(ByVal Vertical As Boolean, ByRef TrackLen As Long, ByRef ThumbStart As Long, ByRef ThumbLen As Long) As Boolean
		Dim As Long SB = OwnScrollBarSize()
		Dim As Long First, Count, Position, Page
		If Vertical Then
			If FOwnVScroll = False Then Return False
			TrackLen = OwnFullHeight() - IIf(FOwnHScroll, SB, 0)
			First = FFixedRows + FFrozenRows
			Count = FRows - First
			Position = FTopRow - First
			Page = Max(1, RowsPerPage)
		Else
			If FOwnHScroll = False Then Return False
			TrackLen = OwnFullWidth() - IIf(FOwnVScroll, SB, 0)
			First = FFixedCols + FFrozenCols
			Count = FCols - First
			Position = FLeftCol - First
			Page = Max(1, ColsPerPage)
		End If
		If TrackLen <= 0 OrElse Count <= 0 Then Return False
		ThumbLen = Max(SB, CLng(CDbl(TrackLen) * Min(1.0, Page / Count)))
		If ThumbLen > TrackLen Then ThumbLen = TrackLen
		ThumbStart = CLng(CDbl(TrackLen - ThumbLen) * Min(1.0, Max(0, Position) / Max(1, Count - 1)))
		Return True
	End Function

	Sub GridDataEx.DrawOwnScrollBars(ByRef Cv As My.Sys.Drawing.Canvas)
		Dim As Long SB = OwnScrollBarSize()
		Dim As Long FullW = OwnFullWidth(), FullH = OwnFullHeight()
		Dim As Long TrackLen, ThumbStart, ThumbLen
		Dim As Long ClrTrack = FlexWinColor(FBackColorFixed), ClrThumb = FlexWinColor(FGridColor)
		Dim As My.Sys.Drawing.Rect R
		If OwnScrollBarRects(True, TrackLen, ThumbStart, ThumbLen) Then
			R.Left = FullW - SB : R.Top = 0 : R.Right = FullW : R.Bottom = TrackLen
			Cv.FillRect(R, ClrTrack)
			R.Left = FullW - SB + 3 : R.Top = ThumbStart + 2 : R.Right = FullW - 3 : R.Bottom = ThumbStart + ThumbLen - 2
			Cv.FillRect(R, ClrThumb)
		End If
		If OwnScrollBarRects(False, TrackLen, ThumbStart, ThumbLen) Then
			R.Left = 0 : R.Top = FullH - SB : R.Right = TrackLen : R.Bottom = FullH
			Cv.FillRect(R, ClrTrack)
			R.Left = ThumbStart + 2 : R.Top = FullH - SB + 3 : R.Right = ThumbStart + ThumbLen - 2 : R.Bottom = FullH - 3
			Cv.FillRect(R, ClrThumb)
		End If
		If FOwnVScroll AndAlso FOwnHScroll Then
			R.Left = FullW - SB : R.Top = FullH - SB : R.Right = FullW : R.Bottom = FullH
			Cv.FillRect(R, ClrTrack)
		End If
	End Sub

	'A press on a scroll bar: the track pages, the thumb starts a drag. True when
	'the press was on a bar (the cells do not get it then)
	Function GridDataEx.OwnScrollBarDown(ByVal X As Long, ByVal Y As Long) As Boolean
		Dim As Long SB = OwnScrollBarSize()
		Dim As Long FullW = OwnFullWidth(), FullH = OwnFullHeight()
		Dim As Long TrackLen, ThumbStart, ThumbLen
		If X >= FullW - SB AndAlso OwnScrollBarRects(True, TrackLen, ThumbStart, ThumbLen) AndAlso Y < TrackLen Then
			If FInEdit Then CommitEdit
			If Y < ThumbStart Then
				TopRow = TopRow - RowsPerPage
			ElseIf Y >= ThumbStart + ThumbLen Then
				TopRow = TopRow + RowsPerPage
			Else
				FOwnScrollDrag = 1
				FOwnScrollDragPos = Y
				FOwnScrollDragFirst = FTopRow
			End If
			Return True
		End If
		If Y >= FullH - SB AndAlso OwnScrollBarRects(False, TrackLen, ThumbStart, ThumbLen) AndAlso X < TrackLen Then
			If FInEdit Then CommitEdit
			If X < ThumbStart Then
				LeftCol = LeftCol - ColsPerPage
			ElseIf X >= ThumbStart + ThumbLen Then
				LeftCol = LeftCol + ColsPerPage
			Else
				FOwnScrollDrag = 2
				FOwnScrollDragPos = X
				FOwnScrollDragFirst = FLeftCol
			End If
			Return True
		End If
		'The corner between the bars
		Return FOwnVScroll AndAlso FOwnHScroll AndAlso X >= FullW - SB AndAlso Y >= FullH - SB
	End Function

	Function GridDataEx.OwnScrollBarMove(ByVal X As Long, ByVal Y As Long) As Boolean
		If FOwnScrollDrag = 0 Then Return False
		Dim As Long TrackLen, ThumbStart, ThumbLen
		If FOwnScrollDrag = 1 Then
			If OwnScrollBarRects(True, TrackLen, ThumbStart, ThumbLen) AndAlso TrackLen > ThumbLen Then
				Dim As Long Count = FRows - (FFixedRows + FFrozenRows)
				TopRow = FOwnScrollDragFirst + CLng(CDbl(Y - FOwnScrollDragPos) * Max(1, Count - 1) / (TrackLen - ThumbLen))
			End If
		Else
			If OwnScrollBarRects(False, TrackLen, ThumbStart, ThumbLen) AndAlso TrackLen > ThumbLen Then
				Dim As Long Count = FCols - (FFixedCols + FFrozenCols)
				LeftCol = FOwnScrollDragFirst + CLng(CDbl(X - FOwnScrollDragPos) * Max(1, Count - 1) / (TrackLen - ThumbLen))
			End If
		End If
		Return True
	End Function

	Function GridDataEx.OwnScrollBarUp() As Boolean
		If FOwnScrollDrag = 0 Then Return False
		FOwnScrollDrag = 0
		Return True
	End Function

	'=== GTK, the Web and Android: the painting and the mouse ===

	'Cv.Handle is the paint context of GTK (cairo) or of the canvas of the Web / Android
	Sub GridDataEx.PaintOwn(ByRef Cv As My.Sys.Drawing.Canvas)
		#ifdef __USE_GTK__
			'The default row height (240 twips) is for Tahoma 8: the default font of GTK is
			'bigger, the rows grow to it once (before the first paint)
			If FDefaultRowFitted = False Then
				FDefaultRowFitted = True
				Dim As Long NeedPx = TextHeightOf("Ag") + LogicalToPxY(4)
				If FDefaultRowHeight = 240 AndAlso NeedPx > GetDefaultRowHeightPx() Then
					FDefaultRowHeight = CLng(NeedPx * TwipsPerPixelY())
					InvalidateRowGeometry
					FScrollBarsDirty = True
				End If
			End If
		#endif
		If FScrollBarsDirty Then SetScrollBarsInternal
		'The grid passes the pixels of the painting: the Canvas must not scale them again
		Dim As Single SavedX = Cv.xdpi, SavedY = Cv.ydpi
		Cv.xdpi = 1
		Cv.ydpi = 1
		DrawGridArea(Cv, 0, 0, ClientWidthPx(), ClientHeightPx())
		DrawOwnScrollBars(Cv)
		Cv.xdpi = SavedX
		Cv.ydpi = SavedY
	End Sub

	#ifdef __USE_GTK__
		Sub GridDataEx.GTK_Paint(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Cv As My.Sys.Drawing.Canvas)
			Cast(GridDataEx Ptr, @Sender)->PaintOwn(Cv)
		End Sub

		'A key of GTK: the key code of Windows for GridKeyDown, then its character like WM_CHAR
		Function GridDataEx.InputKeyDown(ByVal KeyVal As Long, ByVal ShiftState As Integer) As Boolean
			Dim As Boolean Handled
			Dim As Long VK = FlexKeyToVK(KeyVal)
			If VK <> 0 Then Handled = GridKeyDown(VK, ShiftState)
			If FInEdit = False AndAlso (ShiftState And FLEX_CTRL_MASK) = 0 Then
				Dim As Long KeyChar = gdk_keyval_to_unicode(KeyVal)
				If KeyChar >= 32 Then GridKeyPress(KeyChar)
			End If
			Return Handled
		End Function
	#endif

	Sub GridDataEx.ApplyOwnCursor(ByVal Kind As Integer)
		If Kind = FLastCursor Then Exit Sub
		FLastCursor = Kind
		#ifdef __USE_GTK__
			If widget = 0 Then Exit Sub
			Dim As String CursorName = "default"
			Select Case Kind
			Case 1: CursorName = "col-resize"
			Case 2: CursorName = "row-resize"
			Case 3: CursorName = "pointer"
			End Select
			#ifdef __USE_GTK4__
				gtk_widget_set_cursor_from_name(widget, CursorName)
			#else
				Dim As GdkCursor Ptr pcursor = gdk_cursor_new_from_name(gtk_widget_get_display(widget), CursorName)
				Dim As GdkWindow Ptr win = gtk_widget_get_window(widget)
				If GTK_IS_LAYOUT(widget) Then win = gtk_layout_get_bin_window(GTK_LAYOUT(widget))
				If win <> 0 Then gdk_window_set_cursor(win, pcursor)
				If pcursor <> 0 Then g_object_unref(pcursor)
			#endif
		#endif
		'The Web and Android keep the cursor of the page (Android has none)
	End Sub

	Sub GridDataEx.InputMouseDown(ByVal Button As Integer, ByVal X As Long, ByVal Y As Long, ByVal ShiftState As Integer)
		If Button = 0 AndAlso OwnScrollBarDown(X, Y) Then Exit Sub
		#ifdef __USE_JNI__
			'A touch: a move of the finger after the press pans the grid (InputMouseMove)
			If Button = 0 Then
				FTouchDown = True
				FTouchPanning = False
				FTouchX = X
				FTouchY = Y
			End If
		#endif
		GridMouseDown(Button, X, Y, ShiftState)
	End Sub

	Sub GridDataEx.InputMouseMove(ByVal X As Long, ByVal Y As Long)
		If OwnScrollBarMove(X, Y) Then Exit Sub
		#ifdef __USE_JNI__
			If FTouchDown AndAlso FDragMode = 0 Then
				Dim As Long Slop = LogicalToPxX(8)
				If FTouchPanning = False AndAlso (Abs(X - FTouchX) > Slop OrElse Abs(Y - FTouchY) > Slop) Then FTouchPanning = True
				If FTouchPanning Then
					'Whole rows and columns: the rest of the move waits for the next one
					Dim As Long RowH = Max(1, GetDefaultRowHeightPx()), ColW = Max(1, GetDefaultColWidthPx())
					Dim As Long dRows = (FTouchY - Y) \ RowH, dCols = (FTouchX - X) \ ColW
					If dRows <> 0 Then
						TopRow = TopRow + dRows
						FTouchY -= dRows * RowH
					End If
					If dCols <> 0 Then
						LeftCol = LeftCol + dCols
						FTouchX -= dCols * ColW
					End If
					Exit Sub
				End If
			End If
		#endif
		FPendingCursor = 0
		GridMouseMove(X, Y)
		If FDragMode = 0 Then ApplyOwnCursor(FPendingCursor)
	End Sub

	Sub GridDataEx.InputMouseUp(ByVal Button As Integer, ByVal X As Long, ByVal Y As Long)
		If OwnScrollBarUp() Then Exit Sub
		#ifdef __USE_JNI__
			FTouchDown = False
			If FTouchPanning Then
				FTouchPanning = False
				Exit Sub
			End If
		#endif
		GridMouseUp(Button, X, Y)
		#ifdef __USE_WASM__
			'The browser focuses the grid after the press which opened the editor (a double
			'click): the editor gets the focus again when the button is released
			If FInEdit AndAlso EditText_ <> 0 AndAlso EditText_->Visible Then EditText_->SetFocus
		#endif
	End Sub
	#endif

	'=== Persistence, CSV interop, search, statistics, header sort (batch 3) ===

	Function GridDataEx.IsNumericText(ByRef S As WString) As Boolean
		'True when the text parses as a (possibly signed, decimal, exponent) number.
		Dim As String T = Trim(S)
		If Len(T) = 0 Then Return False
		Dim As Long i = 1, L = Len(T)
		If Mid(T, i, 1) = "+" OrElse Mid(T, i, 1) = "-" Then i += 1
		Dim As Boolean DotSeen = False, DigitSeen = False
		Do While i <= L
			Dim As String Ch = Mid(T, i, 1)
			If Ch >= "0" AndAlso Ch <= "9" Then
				DigitSeen = True
			ElseIf Ch = "." AndAlso DotSeen = False Then
				DotSeen = True
			ElseIf UCase(Ch) = "E" AndAlso DigitSeen Then
				'Optional sign then digits until the end.
				Dim As Long k = i + 1
				If k <= L AndAlso (Mid(T, k, 1) = "+" OrElse Mid(T, k, 1) = "-") Then k += 1
				If k > L Then Return False
				Do While k <= L
					Dim As String C2 = Mid(T, k, 1)
					If C2 < "0" OrElse C2 > "9" Then Return False
					k += 1
				Loop
				Return True
			Else
				Return False
			End If
			i += 1
		Loop
		Return DigitSeen
	End Function

	Function GridDataEx.EscapeLayoutText(ByRef S As WString) As String
		'Escapes the characters that would break the line-oriented layout format
		'(line breaks, field separators, the key=value split and commas).
		If InStr(S, "\") = 0 AndAlso InStr(S, Chr(13)) = 0 AndAlso InStr(S, Chr(10)) = 0 AndAlso _
		   InStr(S, Chr(9)) = 0 AndAlso InStr(S, "|") = 0 AndAlso InStr(S, "=") = 0 AndAlso InStr(S, ",") = 0 Then Return S
		Dim As String R = ""
		For i As Long = 1 To Len(S)
			Dim As String Ch = Mid(S, i, 1)
			Select Case Ch
				Case "\" : R &= "\\"
				Case Chr(13) : R &= "\r"
				Case Chr(10) : R &= "\n"
				Case Chr(9) : R &= "\t"
				Case "|" : R &= "\p"
				Case "=" : R &= "\e"
				Case "," : R &= "\c"
				Case Else : R &= Ch
			End Select
		Next i
		Return R
	End Function

	Sub GridDataEx.UnescapeLayoutText(ByRef S As WString)
		If InStr(S, "\") = 0 Then Exit Sub
		Dim As String R = ""
		Dim As Long i = 1
		Do While i <= Len(S)
			If Mid(S, i, 1) = "\" AndAlso i < Len(S) Then
				Dim As String N = Mid(S, i + 1, 1)
				Select Case N
					Case "\" : R &= "\"
					Case "r" : R &= Chr(13)
					Case "n" : R &= Chr(10)
					Case "t" : R &= Chr(9)
					Case "p" : R &= "|"
					Case "e" : R &= "="
					Case "c" : R &= ","
					Case Else : R &= N
				End Select
				i += 2
			Else
				R &= Mid(S, i, 1)
				i += 1
			End If
		Loop
		S = R
	End Sub

	Function GridDataEx.FindNext() As Boolean
		'Continues the last FindItem search from the cell after (or before, when
		'searching upward) the current one; FindItem wraps, so a full pass of the
		'data area is covered from any start point.
		If Len(FFindText) = 0 Then Return False
		Dim As Long StartRow = FRow, StartCol = FCol
		If FFindDir = FlexFindDirectionUp Then
			StartCol -= 1
			If StartCol < FFixedCols Then
				StartCol = FCols - 1
				StartRow -= 1
			End If
			If StartRow < FFixedRows Then StartRow = FRows - 1
		Else
			StartCol += 1
			If StartCol > FCols - 1 Then
				StartCol = FFixedCols
				StartRow += 1
			End If
			If StartRow > FRows - 1 Then StartRow = FFixedRows
		End If
		Dim As Boolean OK = FindItem(FFindText, StartRow, StartCol, FFindMatch, FFindCase, False, True, FFindDir)
		If OK AndAlso Handle <> 0 Then EnsureVisibleCell(FRow, FCol)
		Return OK
	End Function

	Function GridDataEx.ReplaceAll(ByRef What As WString, ByRef WithText As WString, ByVal Match As Integer = FlexFindMatchPartial, ByVal CaseSensitive As Boolean = False) As Long
		'Replaces every match of What by WithText over the data cells; returns the
		'number of cells changed. FlexFindMatchExact replaces whole cell contents.
		Dim As Long Count = 0
		If Len(What) = 0 Then Return 0
		Redraw = False
		Dim As UString V, Haystack, Needle, OutWStr
		For i As Long = FFixedRows To FRows - 1
			For j As Long = FFixedCols To FCols - 1
				V = TextMatrix(i, j)
				If Len(V) = 0 Then Continue For
				Haystack = V
				If CaseSensitive = False Then Haystack = UCase(V)
				If Match = FlexFindMatchExact Then
					If CaseSensitive = False Then Haystack = UCase(What)
					If Haystack = What Then
						TextMatrix(i, j, WithText)
						Count += 1
					End If
				Else
					Needle = What
					If CaseSensitive = False Then Needle = UCase(What)
					Dim As Long P = 1, FoundAt
					OutWStr = ""
					Dim As Boolean Changed = False
					Do
						FoundAt = InStr(P, Haystack, Needle)
						If FoundAt = 0 Then Exit Do
						OutWStr &= Mid(V, P, FoundAt - P) & WithText
						P = FoundAt + Len(Needle)
						Changed = True
					Loop
					If Changed Then
						OutWStr &= Mid(V, P)
						TextMatrix(i, j, OutWStr)
						Count += 1
					End If
				End If
			Next j
		Next i
		Redraw = True
		Return Count
	End Function

	Function GridDataEx.SaveLayout(ByRef FileName As WString, ByVal IncludeData As Boolean = False) As Boolean
		'Writes the grid's properties, column/row geometry and (optionally) every
		'cell as an INI-style UTF-8 text file. Cell texts are escaped, so one
		'line always holds exactly one record.
		Dim As Integer ff = FreeFile
		If Dir(FileName) <> "" Then Kill FileName
		Open FileName For Output Encoding "utf8" As #ff
		Print #ff, "[Grid]"
		Print #ff, "FormatVersion=1"
		Print #ff, "Rows=" & FRows
		Print #ff, "Cols=" & FCols
		Print #ff, "FixedRows=" & FFixedRows
		Print #ff, "FixedCols=" & FFixedCols
		Print #ff, "FrozenRows=" & FFrozenRows
		Print #ff, "FrozenCols=" & FFrozenCols
		Print #ff, "BorderStyle=" & FBorderStyle
		Print #ff, "GridLines=" & FGridLines
		Print #ff, "GridLinesFixed=" & FGridLinesFixed
		Print #ff, "GridLinesFrozen=" & FGridLinesFrozen
		Print #ff, "ScrollBars=" & FScrollBars
		Print #ff, "SelectionMode=" & FSelectionMode
		Print #ff, "AllowUserResizing=" & FAllowUserResizing
		Print #ff, "AllowUserEditing=" & CInt(FAllowUserEditing)
		Print #ff, "AllowSelection=" & CInt(FAllowSelection)
		Print #ff, "AllowBigSelection=" & CInt(FAllowBigSelection)
		Print #ff, "AllowMultiSelection=" & CInt(FAllowMultiSelection)
		Print #ff, "TabBehavior=" & FTabBehavior
		Print #ff, "DirectionAfterReturn=" & FDirectionAfterReturn
		Print #ff, "WordWrap=" & CInt(FWordWrap)
		Print #ff, "EllipsisFormat=" & FEllipsisFormat
		Print #ff, "ExtendLastCol=" & CInt(FExtendLastCol)
		Print #ff, "SheetBorder=" & CInt(FSheetBorder)
		Print #ff, "HighLight=" & FHighLight
		Print #ff, "FocusRect=" & FFocusRect
		Print #ff, "DoubleBuffer=" & CInt(FDoubleBuffer)
		Print #ff, "MergeCells=" & FMergeCells
		Print #ff, "RowHeightMin=" & FRowHeightMin
		Print #ff, "RowHeightMax=" & FRowHeightMax
		Print #ff, "ColWidthMin=" & FColWidthMin
		Print #ff, "ColWidthMax=" & FColWidthMax
		Print #ff, "DefaultRowHeight=" & FDefaultRowHeight
		Print #ff, "DefaultColWidth=" & FDefaultColWidth
		Print #ff, "SortOnClick=" & CInt(FSortOnClick)
		Print #ff, "ShowFilterBar=" & CInt(FShowFilterBar)
		Print #ff, "Zoom=" & FZoom
		Print #ff, "[Colors]"
		Print #ff, "BackColorBkg=" & FBackColorBkg
		Print #ff, "BackColorAlt=" & FBackColorAlt
		Print #ff, "BackColorFixed=" & FBackColorFixed
		Print #ff, "BackColorSel=" & FBackColorSel
		Print #ff, "ForeColorFixed=" & FForeColorFixed
		Print #ff, "ForeColorSel=" & FForeColorSel
		Print #ff, "GridColor=" & FGridColor
		Print #ff, "GridColorFixed=" & FGridColorFixed
		Print #ff, "GridColorFrozen=" & FGridColorFrozen
		Print #ff, "FloodColor=" & FFloodColor
		Print #ff, "SortArrowColor=" & FSortArrowColor
		Print #ff, "[Font]"
		'The base (unzoomed) font size is persisted so Zoom round-trips.
		Print #ff, "Font=" & EscapeLayoutText(Font.Name) & "|" & IIf(FZoomBaseFont > 0, FZoomBaseFont, Font.Size) & "|" & CInt(Font.Bold) & "|" & CInt(Font.Italic) & "|" & CInt(Font.Underline) & "|" & CInt(Font.StrikeOut)
		Print #ff, "[Cols]"
		'width|hidden|align|fixedalign|wrap|sortmode|sortarrow|cue|checkbox|combomode|merge|key|comboitems|filter
		For j As Long = 0 To FCols - 1
			Print #ff, "Col" & j & "=" & ColsArr(j).Width & "|" & IIf((ColsArr(j).State And FLEX_CLIS_HIDDEN) <> 0, "1", "0") & "|" & _
				ColsArr(j).Alignment & "|" & ColsArr(j).FixedAlignment & "|" & ColsArr(j).WordWrapOption & "|" & _
				ColsArr(j).SortMode & "|" & ColsArr(j).SortArrow & "|" & ColsArr(j).ComboCue & "|" & _
				IIf(ColsArr(j).CheckBoxes <> 0, "1", "0") & "|" & ColsArr(j).ComboMode & "|" & IIf(FMergeCols(j), "1", "0") & "|" & _
				EscapeLayoutText(ColKey(j)) & "|" & EscapeLayoutText(ColComboItems(j)) & "|" & EscapeLayoutText(ColFilter(j)) & "|" & _
				IIf((ColsArr(j).State And FLEX_CLIS_CELLBUTTONS) <> 0, "1", "0")
		Next j
		Print #ff, "[Rows]"
		'height|hidden|merge|bookmark
		For i As Long = 0 To FRows - 1
			Print #ff, "Row" & i & "=" & RowsArr(i).Height & "|" & IIf((RowsArr(i).State And FLEX_RWIS_HIDDEN) <> 0, "1", "0") & "|" & IIf(FMergeRows(i), "1", "0") & "|" & IIf((RowsArr(i).State And FLEX_RWIS_BOOKMARK) <> 0, "1", "0")
		Next i
		Print #ff, "[Selection]"
		Print #ff, "Row=" & FRow
		Print #ff, "Col=" & FCol
		Print #ff, "TopRow=" & FTopRow
		Print #ff, "LeftCol=" & FLeftCol
		If IncludeData Then
			Print #ff, "[CellData]"
			'Cell=i,j,hasfmt[,back,fore,checked,floodpct,floodcolor,fontstyle],escapedText
			For i As Long = 0 To FRows - 1
				For j As Long = 0 To FCols - 1
					Dim As FlexCell Ptr C = CellAt(i, j)
					If C = 0 Then Continue For
					Dim As String TxtPart = EscapeLayoutText(CellTextRaw(i, j))
					If C->Fmtg <> 0 Then
						Print #ff, "Cell=" & i & "," & j & ",1," & C->Fmtg->BackColor & "," & C->Fmtg->ForeColor & "," & _
							C->Fmtg->Checked & "," & C->Fmtg->FloodPercent & "," & C->Fmtg->FloodColor & "," & _
							C->Fmtg->FontStyle & "," & TxtPart
					Else
						Print #ff, "Cell=" & i & "," & j & ",0," & TxtPart
					End If
				Next j
			Next i
		End If
		Close #ff
		Return True
	End Function

	Function GridDataEx.LoadLayout(ByRef FileName As WString, ByVal IncludeData As Boolean = False) As Boolean
		'Restores a file written by SaveLayout. Geometry keys ([Grid]) apply first,
		'then colors, columns, rows, selection and cells.
		If Dir(FileName) = "" Then Return False
		Dim As Integer ff = FreeFile
		Open FileName For Input Encoding "utf8" As #ff
		Dim lines(Any) As String
		Dim As Long n = 0
		ReDim lines(255)
		Dim As String L
		Do While EOF(ff) = False
			Line Input #ff, L
			n += 1
			If n > UBound(lines) + 1 Then ReDim Preserve lines(UBound(lines) * 2 + 1)
			lines(n - 1) = L
		Loop
		Close #ff
		If n = 0 Then Return False
		Redraw = False
		'Pass 1: geometry only, so [Cols]/[Rows]/[CellData] have a sized grid.
		Dim As String Section = ""
		For li As Long = 0 To n - 1
			L = lines(li)
			If Mid(L, 1, 1) = "[" Then
				Section = L
			ElseIf Section = "[Grid]" AndAlso InStr(L, "=") > 0 Then
				Dim As String Key = Mid(L, 1, InStr(L, "=") - 1)
				Dim As Long V = Val(Mid(L, InStr(L, "=") + 1))
				Select Case Key
					Case "Rows" : Rows = V
					Case "Cols" : Cols = V
					Case "FixedRows" : FixedRows = V
					Case "FixedCols" : FixedCols = V
					Case "FrozenRows" : FrozenRows = V
					Case "FrozenCols" : FrozenCols = V
				End Select
			End If
		Next li
		'Pass 2: everything else.
		Section = ""
		For li As Long = 0 To n - 1
			L = lines(li)
			If Mid(L, 1, 1) = "[" Then
				Section = L
				Continue For
			End If
			Dim As Long Eq = InStr(L, "=")
			If Eq < 2 Then Continue For
			Dim As String Key = Mid(L, 1, Eq - 1)
			Dim As String Value = Mid(L, Eq + 1)
			Select Case Section
				Case "[Grid]"
					Dim As Long V = Val(Value)
					Select Case Key
						Case "BorderStyle" : FBorderStyle = V
						Case "GridLines" : FGridLines = V
						Case "GridLinesFixed" : FGridLinesFixed = V
						Case "GridLinesFrozen" : FGridLinesFrozen = V
						Case "ScrollBars" : FScrollBars = V
						Case "SelectionMode" : FSelectionMode = V
						Case "AllowUserResizing" : FAllowUserResizing = V
						Case "AllowUserEditing" : FAllowUserEditing = CBool(V)
						Case "AllowSelection" : FAllowSelection = CBool(V)
						Case "AllowBigSelection" : FAllowBigSelection = CBool(V)
						Case "AllowMultiSelection" : FAllowMultiSelection = CBool(V)
						Case "TabBehavior" : FTabBehavior = V
						Case "DirectionAfterReturn" : FDirectionAfterReturn = V
						Case "WordWrap" : FWordWrap = CBool(V)
						Case "EllipsisFormat" : FEllipsisFormat = V
						Case "ExtendLastCol" : FExtendLastCol = CBool(V)
						Case "SheetBorder" : FSheetBorder = CBool(V)
						Case "HighLight" : FHighLight = V
						Case "FocusRect" : FFocusRect = V
						Case "DoubleBuffer" : FDoubleBuffer = CBool(V)
						Case "MergeCells" : FMergeCells = V
						Case "RowHeightMin" : FRowHeightMin = V
						Case "RowHeightMax" : FRowHeightMax = V
						Case "ColWidthMin" : FColWidthMin = V
						Case "ColWidthMax" : FColWidthMax = V
						Case "DefaultRowHeight" : FDefaultRowHeight = V
						Case "DefaultColWidth" : FDefaultColWidth = V
						Case "SortOnClick" : FSortOnClick = CBool(V)
						Case "ShowFilterBar" : FShowFilterBar = CBool(V)
						Case "Zoom" : FZoom = Max(0.25, Min(4, Val(Value)))
					End Select
				Case "[Colors]"
					Dim As Long V = Val(Value)
					Select Case Key
						Case "BackColorBkg" : FBackColorBkg = V
						Case "BackColorAlt" : FBackColorAlt = V
						Case "BackColorFixed" : FBackColorFixed = V
						Case "BackColorSel" : FBackColorSel = V
						Case "ForeColorFixed" : FForeColorFixed = V
						Case "ForeColorSel" : FForeColorSel = V
						Case "GridColor" : FGridColor = V
						Case "GridColorFixed" : FGridColorFixed = V
						Case "GridColorFrozen" : FGridColorFrozen = V
						Case "FloodColor" : FFloodColor = V
						Case "SortArrowColor" : FSortArrowColor = V
					End Select
				Case "[Font]"
					If Key = "Font" Then
						Dim As Long p = 1
						Dim As String Part(1 To 6)
						For k As Long = 1 To 6
							Dim As Long Bar = InStr(p, Value, "|")
							If k = 6 Then
								Part(k) = Mid(Value, p)
							ElseIf Bar > 0 Then
								Part(k) = Mid(Value, p, Bar - p)
								p = Bar + 1
							Else
								Part(k) = ""
							End If
						Next k
						UnescapeLayoutText(Part(1))
						Font.Name = Part(1)
						If Val(Part(2)) > 0 Then Font.Size = Val(Part(2))
						Font.Bold = CBool(Val(Part(3)))
						Font.Italic = CBool(Val(Part(4)))
						Font.Underline = CBool(Val(Part(5)))
						Font.StrikeOut = CBool(Val(Part(6)))
					End If
				Case "[Cols]"
					If Mid(Key, 1, 3) = "Col" Then
						Dim As Long j = Val(Mid(Key, 4))
						If j >= 0 AndAlso j <= FCols - 1 Then
							Dim As Long p = 1
							Dim As String Part(1 To 15)
							For k As Long = 1 To 15
								Dim As Long Bar = InStr(p, Value, "|")
								If k = 15 Then
									Part(k) = Mid(Value, p)
								ElseIf Bar > 0 Then
									Part(k) = Mid(Value, p, Bar - p)
									p = Bar + 1
								Else
									Part(k) = ""
								End If
							Next k
							ColsArr(j).Width = Val(Part(1))
							If Val(Part(2)) <> 0 Then ColsArr(j).State Or= FLEX_CLIS_HIDDEN Else ColsArr(j).State And= Not FLEX_CLIS_HIDDEN
							ColsArr(j).Alignment = Val(Part(3))
							ColsArr(j).FixedAlignment = Val(Part(4))
							ColsArr(j).WordWrapOption = Val(Part(5))
							ColsArr(j).SortMode = Val(Part(6))
							ColsArr(j).SortArrow = Val(Part(7))
							ColsArr(j).ComboCue = Val(Part(8))
							ColsArr(j).CheckBoxes = Val(Part(9))
							ColsArr(j).ComboMode = Val(Part(10))
							FMergeCols(j) = CBool(Val(Part(11)))
							UnescapeLayoutText(Part(12))
							WLet(ColsArr(j).Key, Part(12))
							UnescapeLayoutText(Part(13))
							WLet(ColsArr(j).ComboItems, Part(13))
							'Part 14 (filter) / part 15 (cell buttons) are optional for
							'older files.
							UnescapeLayoutText(Part(14))
							WLet(ColsArr(j).Filter, Part(14))
							If Val(Part(15)) <> 0 Then ColsArr(j).State Or= FLEX_CLIS_CELLBUTTONS Else ColsArr(j).State And= Not FLEX_CLIS_CELLBUTTONS
						End If
					End If
				Case "[Rows]"
					If Mid(Key, 1, 3) = "Row" Then
						Dim As Long i = Val(Mid(Key, 4))
						If i >= 0 AndAlso i <= FRows - 1 Then
							Dim As Long Bar1 = InStr(Value, "|")
							Dim As Long Bar2 = IIf(Bar1 > 0, InStr(Bar1 + 1, Value, "|"), 0)
							Dim As Long Bar3 = IIf(Bar2 > 0, InStr(Bar2 + 1, Value, "|"), 0)
							RowsArr(i).Height = Val(Value)
							Dim As Boolean Hdn = IIf(Bar1 > 0, CBool(Val(Mid(Value, Bar1 + 1, IIf(Bar2 > Bar1, Bar2 - Bar1 - 1, 9999)))), False)
							If Hdn Then RowsArr(i).State Or= FLEX_RWIS_HIDDEN Else RowsArr(i).State And= Not FLEX_RWIS_HIDDEN
							FMergeRows(i) = IIf(Bar2 > Bar1, CBool(Val(Mid(Value, Bar2 + 1))), False)
							'Bookmark flag (4th part, optional for older files).
							If (Bar3 > Bar2) AndAlso (CBool(Val(Mid(Value, Bar3 + 1)))) Then RowsArr(i).State Or= FLEX_RWIS_BOOKMARK
						End If
					End If
				Case "[Selection]"
					Dim As Long V = Val(Value)
					Select Case Key
						Case "Row" : FRow = V
						Case "Col" : FCol = V
						Case "TopRow" : FTopRow = V
						Case "LeftCol" : FLeftCol = V
					End Select
				Case "[CellData]"
					If Key = "Cell" AndAlso IncludeData Then
						Dim As String Part(1 To 10)
						Dim As Long p = 1, nparts = 0
						'Cell=i,j,hasfmt[,6 fmt values],escapedText - text has no raw
						'commas (they are escaped), so a plain comma split is safe.
						For k As Long = 1 To 10
							Dim As Long Comma = InStr(p, Value, ",")
							If Comma > 0 Then
								Part(k) = Mid(Value, p, Comma - p)
								p = Comma + 1
							Else
								Part(k) = Mid(Value, p)
								nparts = k
								Exit For
							End If
							nparts = k
						Next k
						Dim As Long i = Val(Part(1)), j = Val(Part(2)), HasFmt = Val(Part(3))
						If i >= 0 AndAlso i <= FRows - 1 AndAlso j >= 0 AndAlso j <= FCols - 1 Then
							If HasFmt <> 0 AndAlso nparts >= 9 Then
								Dim As FlexCellFormat Ptr F = EnsureFmtg(i, j)
								If F <> 0 Then
									F->BackColor = Val(Part(4))
									F->ForeColor = Val(Part(5))
									F->Checked = Val(Part(6))
									F->FloodPercent = Val(Part(7))
									F->FloodColor = Val(Part(8))
									F->FontStyle = Val(Part(9))
								End If
								UnescapeLayoutText(Part(10))
								TextMatrix(i, j, Part(10))
							Else
								UnescapeLayoutText(Part(4))
								TextMatrix(i, j, Part(4))
							End If
						End If
					End If
			End Select
		Next li
		'Re-apply the zoom scale to the freshly loaded (base) font, then
		're-evaluate the restored filter criteria.
		If FZoom <> 1 Then
			FZoomBaseFont = Font.Size
			Font.Size = Max(1, CInt(FZoomBaseFont * FZoom))
		End If
		InvalidateMergeCache
		InvalidateRowGeometry
		InvalidateColGeometry
		SetScrollBarsInternal
		Redraw = True
		If Handle <> 0 Then RepaintGrid
		Dim As Boolean AnyFilter = False
		For j As Long = 0 To FCols - 1
			If ColsArr(j).Filter <> 0 AndAlso Len(*ColsArr(j).Filter) > 0 Then
				AnyFilter = True
				Exit For
			End If
		Next j
		If AnyFilter Then ApplyFilters
		Return True
	End Function

	Function GridDataEx.ExportCSV(ByRef FileName As WString, ByVal WithHeaders As Boolean = True) As Boolean
		'Writes the visible cells as comma-separated values; fields containing
		'commas, quotes or line breaks are quoted with doubled inner quotes.
		Dim As Integer ff = FreeFile
		Dim As Long FirstRow = IIf(WithHeaders, 0, FFixedRows)
		Open FileName For Output Encoding "utf8" As #ff
		Dim As UString V, L, QV
		For i As Long = FirstRow To FRows - 1
			If (RowsArr(i).State And FLEX_RWIS_HIDDEN) = 0 Then
				L = ""
				For j As Long = 0 To FCols - 1
					If (ColsArr(j).State And FLEX_CLIS_HIDDEN) = 0 Then
						V = CellTextRaw(i, j)
						If InStr(V, ",") > 0 OrElse InStr(V, """") > 0 OrElse InStr(V, Chr(13)) > 0 OrElse InStr(V, Chr(10)) > 0 Then
							QV = Replace(V, """", """""")
							L &= IIf(L = "", "", ",") & """" & QV & """"
						Else
							L &= IIf(L = "", "", ",") & V
						End If
					End If
				Next j
				Print #ff, L
			End If
		Next i
		Close #ff
		Return True
	End Function

	Function GridDataEx.ImportCSV(ByRef FileName As WString, ByVal HasHeaders As Boolean = True) As Boolean
		'Loads comma-separated values: with HasHeaders the first line lands in the
		'fixed row(s) header row 0, the rest become data rows. The grid resizes to
		'the widest line; short lines leave the trailing cells empty.
		If Dir(FileName) = "" Then Return False
		Dim As Integer ff = FreeFile
		Open FileName For Input Encoding "utf8" As #ff
		Dim lines(Any) As String
		Dim As Long n = 0
		ReDim lines(255)
		Dim As String L
		Do While EOF(ff) = False
			Line Input #ff, L
			n += 1
			If n > UBound(lines) + 1 Then ReDim Preserve lines(UBound(lines) * 2 + 1)
			lines(n - 1) = L
		Loop
		Close #ff
		If n = 0 Then Return False
		'Parse every line into fields (quoted-aware), remember the widest.
		Dim As Long ncols = 1
		Dim counts(n - 1) As Long
		For li As Long = 0 To n - 1
			Dim As String cur = ""
			Dim As Long c = 0, p = 1
			Dim As Boolean InQ = False
			Dim As String src = lines(li)
			'Grow per line: temporary dynamic array, then copy in.
			Dim tmpFields(Any) As String
			ReDim tmpFields(15)
			Do
				c += 1
				If c > UBound(tmpFields) + 1 Then ReDim Preserve tmpFields(UBound(tmpFields) * 2 + 1)
				cur = ""
				Do While p <= Len(src)
					Dim As String Ch = Mid(src, p, 1)
					If InQ Then
						If Ch = """" Then
							If p < Len(src) AndAlso Mid(src, p + 1, 1) = """" Then
								cur &= """"
								p += 2
							Else
								InQ = False
								p += 1
							End If
						Else
							cur &= Ch
							p += 1
						End If
					Else
						If Ch = """" AndAlso cur = "" Then
							InQ = True
							p += 1
						ElseIf Ch = "," Then
							p += 1
							Exit Do
						Else
							cur &= Ch
							p += 1
						End If
					End If
				Loop
				tmpFields(c - 1) = cur
			Loop While p <= Len(src)
			counts(li) = c
			If c > ncols Then ncols = c
			'Store: reuse the lines() array via a join on a control character that
			'cannot appear ( Chr(1) ), so a second matrix is not needed.
			Dim As String Joined = ""
			For k As Long = 0 To c - 1
				If k = 0 Then
				Joined = tmpFields(k)
			Else
				Joined &= Chr(1) & tmpFields(k)
			End If
			Next k
			lines(li) = Joined
		Next li
		'Resize and fill.
		Redraw = False
		Dim As Long FirstData = IIf(HasHeaders AndAlso FFixedRows > 0, 1, 0)
		Dim As Long NeedRows = FFixedRows + (n - FirstData)
		If NeedRows < 1 Then NeedRows = 1
		Rows = NeedRows
		If Cols < ncols Then Cols = ncols
		For li As Long = FirstData To n - 1
			Dim As Long r = FFixedRows + (li - FirstData)
			Dim As Long c = counts(li)
			Dim As Long p = 1
			For k As Long = 0 To c - 1
				Dim As Long Sep = InStr(p, lines(li), Chr(1))
				Dim As String FieldValue = IIf(Sep > 0, Mid(lines(li), p, Sep - p), Mid(lines(li), p))
				If r <= FRows - 1 AndAlso k <= FCols - 1 Then TextMatrix(r, k, FieldValue)
				If Sep = 0 Then Exit For
				p = Sep + 1
			Next k
		Next li
		'Headers line into the first fixed row when present.
		If FirstData = 1 AndAlso FFixedRows > 0 Then
			Dim As Long p = 1
			For k As Long = 0 To counts(0) - 1
				Dim As Long Sep = InStr(p, lines(0), Chr(1))
				Dim As String FieldValue = IIf(Sep > 0, Mid(lines(0), p, Sep - p), Mid(lines(0), p))
				If k <= FCols - 1 Then TextMatrix(0, k, FieldValue)
				If Sep = 0 Then Exit For
				p = Sep + 1
			Next k
		End If
		Row = FFixedRows
		Col = FFixedCols
		TopRow = FFixedRows
		LeftCol = FFixedCols
		SetScrollBarsInternal
		Redraw = True
		If Handle <> 0 Then RepaintGrid
		Return True
	End Function

	Function GridDataEx.Aggregate(ByVal Func As Integer, ByVal Row1 As Long, ByVal Col1 As Long, ByVal Row2 As Long, ByVal Col2 As Long) As Double
		'Range statistics over the cell texts; cells that do not parse as numbers
		'are counted (Count) but excluded from Sum/Average/Min/Max.
		Dim As Long r1 = Max(0, min(Row1, Row2)), r2 = min(FRows - 1, Max(Row1, Row2))
		Dim As Long c1 = Max(0, min(Col1, Col2)), c2 = min(FCols - 1, Max(Col1, Col2))
		Dim As Double Sum = 0, MinV = 0, MaxV = 0, Cnt = 0, NumCnt = 0
		Dim As Boolean FirstNum = True
		Dim As UString V
		For i As Long = r1 To r2
			For j As Long = c1 To c2
				V = TextMatrix(i, j)
				If Len(Trim(V)) > 0 Then Cnt += 1
				If IsNumericText(V) Then
					Dim As Double N = Val(V)
					Sum += N
					NumCnt += 1
					If FirstNum Then
						MinV = N : MaxV = N : FirstNum = False
					Else
						If N < MinV Then MinV = N
						If N > MaxV Then MaxV = N
					End If
				End If
			Next j
		Next i
		Select Case Func
			Case GridAggCount : Return Cnt
			Case GridAggCountNumeric : Return NumCnt
			Case GridAggAverage : Return IIf(NumCnt > 0, Sum / NumCnt, 0)
			Case GridAggMin : Return IIf(NumCnt > 0, MinV, 0)
			Case GridAggMax : Return IIf(NumCnt > 0, MaxV, 0)
			Case Else : Return Sum
		End Select
	End Function

	Function GridDataEx.AggregateSelection(ByVal Func As Integer) As Double
		'Statistics over the current selection range.
		Dim r1 As Long, c1 As Long, r2 As Long, c2 As Long
		GetSelRange(r1, c1, r2, c2)
		Return Aggregate(Func, r1, c1, r2, c2)
	End Function

	Property GridDataEx.SortOnClick As Boolean
		Return FSortOnClick
	End Property

	Property GridDataEx.SortOnClick(ByVal Value As Boolean)
		FSortOnClick = Value
	End Property

	'=== Batch 4: filter bar, multi-sort, bookmarks, zoom, HTML/JSON export ===

	Function GridDataEx.FilterBarHeightPx() As Long
		'Pixel height of the filter bar band (0 when disabled). Falls back to
		'the default row height when the first row is hidden.
		If FShowFilterBar = False Then Return 0
		Dim As Long H = GetRowHeightPx(0)
		If H <= 0 Then H = GetDefaultRowHeightPx()
		Return H
	End Function

	Property GridDataEx.ColCellButtons(ByVal aIndex As Long) As Boolean
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return False
		Return CBool((ColsArr(aIndex).State And FLEX_CLIS_CELLBUTTONS) <> 0)
	End Property

	Property GridDataEx.ColCellButtons(ByVal aIndex As Long, ByVal Value As Boolean)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		If Value Then
			ColsArr(aIndex).State Or= FLEX_CLIS_CELLBUTTONS
		Else
			ColsArr(aIndex).State And= Not FLEX_CLIS_CELLBUTTONS
		End If
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.ShowFilterBar As Boolean
		Return FShowFilterBar
	End Property

	Property GridDataEx.ShowFilterBar(ByVal Value As Boolean)
		If Value = FShowFilterBar Then Exit Property
		FShowFilterBar = Value
		If FFilterEditActive Then CancelFilterEdit
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.ColFilter(ByVal aIndex As Long) ByRef As WString
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return ""
		If ColsArr(aIndex).Filter = 0 Then Return ""
		Return *ColsArr(aIndex).Filter
	End Property

	Property GridDataEx.ColFilter(ByVal aIndex As Long, ByRef Value As WString)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		WLet(ColsArr(aIndex).Filter, Value)
	End Property

	Function GridDataEx.FilterMatchText(ByRef V As WString, ByRef Crit As WString) As Boolean
		'Evaluates one filter criterion against one cell text (case-insensitive):
		'">x" "<x" ">=x" "<=x" "<>x" "=x" (numeric when both sides parse as
		'numbers), "x*" starts with, "*x" ends with, "*x*" contains, plain
		'text contains. An empty criterion matches everything.
		Dim As UString C = UCase(Trim(Crit))
		If Len(C) = 0 Then Return True
		Dim As UString T = UCase(V)
		Dim As Integer Op = 0 '1 ">" 2 "<" 3 "=" 4 "<>" 5 ">=" 6 "<="
		Dim As UString Rest = C
		If Mid(C, 1, 2) = ">=" Then
			Op = 5 : Rest = Mid(C, 3)
		ElseIf Mid(C, 1, 2) = "<=" Then
			Op = 6 : Rest = Mid(C, 3)
		ElseIf Mid(C, 1, 2) = "<>" Then
			Op = 4 : Rest = Mid(C, 3)
		ElseIf Mid(C, 1, 1) = ">" Then
			Op = 1 : Rest = Mid(C, 2)
		ElseIf Mid(C, 1, 1) = "<" Then
			Op = 2 : Rest = Mid(C, 2)
		ElseIf Mid(C, 1, 1) = "=" Then
			Op = 3 : Rest = Mid(C, 2)
		End If
		Rest = Trim(Rest)
		If Op > 0 Then
			If Op = 4 Then Return (T <> Rest)
			If Op = 3 Then Return (T = Rest)
			If IsNumericText(V) AndAlso IsNumericText(Rest) Then
				Dim As Double A = Val(V), B = Val(Rest)
				Select Case Op
					Case 1 : Return A > B
					Case 2 : Return A < B
					Case 5 : Return A >= B
					Case 6 : Return A <= B
				End Select
			Else
				Select Case Op
					Case 1 : Return T > Rest
					Case 2 : Return T < Rest
					Case 5 : Return T >= Rest
					Case 6 : Return T <= Rest
				End Select
			End If
		End If
		'Wildcard forms.
		If Rest = "*" Then Return True
		If Mid(Rest, 1, 1) = "*" AndAlso Mid(Rest, Len(Rest), 1) = "*" AndAlso Len(Rest) > 1 Then
			Return InStr(T, Mid(Rest, 2, Len(Rest) - 2)) > 0
		End If
		If Mid(Rest, 1, 1) = "*" Then
			Dim As UString Suf = Mid(Rest, 2)
			If Len(T) < Len(Suf) Then Return False
			Return Mid(T, Len(T) - Len(Suf) + 1) = Suf
		End If
		If Mid(Rest, Len(Rest), 1) = "*" Then
			Return Mid(T, 1, Len(Rest) - 1) = Mid(Rest, 1, Len(Rest) - 1)
		End If
		Return InStr(T, Rest) > 0
	End Function

	Sub GridDataEx.ApplyFilters()
		'Hides every scrollable row that does not satisfy all non-empty column
		'criteria. Rows hidden by the filter carry FLEX_RWIS_FILTERED so
		'ClearFilters can restore exactly those (user-hidden rows stay hidden).
		Dim As Boolean AnyFilter = False
		For j As Long = 0 To FCols - 1
			If ColsArr(j).Filter <> 0 AndAlso Len(*ColsArr(j).Filter) > 0 Then
				AnyFilter = True
				Exit For
			End If
		Next j
		Redraw = False
		Dim As UString Crit
		For i As Long = FFixedRows To FRows - 1
			Dim As Boolean Keep = True
			If AnyFilter Then
				For j As Long = 0 To FCols - 1
					Crit = ColFilter(j)
					If Len(Crit) = 0 Then Continue For
					If FilterMatchText(TextMatrix(i, j), Crit) = False Then
						Keep = False
						Exit For
					End If
				Next j
			End If
			If Keep Then
				If (RowsArr(i).State And FLEX_RWIS_FILTERED) <> 0 Then RowsArr(i).State And= Not (FLEX_RWIS_FILTERED Or FLEX_RWIS_HIDDEN)
			Else
				If (RowsArr(i).State And FLEX_RWIS_FILTERED) = 0 Then RowsArr(i).State Or= (FLEX_RWIS_FILTERED Or FLEX_RWIS_HIDDEN)
			End If
		Next i
		'Move the current cell off a hidden row (silently, no event storm).
		If (FRow >= FFixedRows) AndAlso (FRow <= FRows - 1) Then
			If (RowsArr(FRow).State And FLEX_RWIS_HIDDEN) <> 0 Then
				For i As Long = FFixedRows To FRows - 1
					If (RowsArr(i).State And FLEX_RWIS_HIDDEN) = 0 Then
						FRow = i
						FRowSel = i
						Exit For
					End If
				Next i
			End If
		End If
		EnsureVisibleCell(FRow, FCol)
		InvalidateRowGeometry
		FScrollBarsDirty = True
		Redraw = True
		If Handle <> 0 Then
			SetScrollBarsInternal
			RepaintGrid
		End If
	End Sub

	Sub GridDataEx.ClearFilters()
		'Empties every column criterion and restores the rows the filters hid.
		Redraw = False
		For j As Long = 0 To FCols - 1
			WDeAllocate(ColsArr(j).Filter)
			ColsArr(j).Filter = 0
		Next j
		For i As Long = 0 To FRows - 1
			If (RowsArr(i).State And FLEX_RWIS_FILTERED) <> 0 Then RowsArr(i).State And= Not (FLEX_RWIS_FILTERED Or FLEX_RWIS_HIDDEN)
		Next i
		InvalidateRowGeometry
		FScrollBarsDirty = True
		Redraw = True
		If Handle <> 0 Then
			SetScrollBarsInternal
			RepaintGrid
		End If
		If OnFilterChange Then OnFilterChange(*Designer, This, -1)
	End Sub

	Property GridDataEx.FilteredRowCount As Long
		Dim As Long i, Count = 0
		For i = FFixedRows To FRows - 1
			If (RowsArr(i).State And FLEX_RWIS_FILTERED) <> 0 Then Count += 1
		Next i
		Return Count
	End Property

	Function GridDataEx.StartFilterEdit(ByVal aCol As Long) As Boolean
		'Opens the inline criteria editor over the filter band cell of aCol.
		If FShowFilterBar = False Then Return False
		If aCol < 0 OrElse aCol > FCols - 1 Then Return False
		If FInEdit Then CommitEditInternal(FlexEditCloseModeCode)
		If FFilterEditActive Then
			If FFilterEditCol = aCol Then Return True
			ApplyFilterEdit
		End If
		If EditText_ = 0 Then
			EditText_ = New FlexEditTextBox
			With *EditText_
				.Grid = @This
				.Parent = @This
				.BorderStyle = BorderStyles.bsNone
				.Visible = False
				.OnChange = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TextBox), @FlexEditTextBox.Edit_Change)
				.OnLostFocus = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TextBox), @FlexEditTextBox.Edit_LostFocus)
				#ifndef __USE_WINAPI__
					.OnKeyDown = @FlexEditTextBox.Edit_KeyDown
				#endif
			End With
		End If
		FFilterEditCol = aCol
		FFilterEditActive = True
		EditText_->Text = ColFilter(aCol)
		PositionEditBox
		EditText_->Visible = True
		EditText_->SetFocus
		EditText_->SetSel(0, Len(EditText_->Text))
		Return True
	End Function

	Sub GridDataEx.ApplyFilterEdit()
		'Commits the filter editor: stores the text as the column criterion and
		're-evaluates all filters.
		If FFilterEditActive = False Then Exit Sub
		Dim As Long ColIdx = FFilterEditCol
		FFilterEditActive = False
		FFilterEditCol = -1
		If EditText_ <> 0 Then
			Dim As UString NewCrit = EditText_->Text
			EditText_->Visible = False
			If (ColIdx >= 0) AndAlso (ColIdx <= FCols - 1) Then
				If NewCrit <> ColFilter(ColIdx) Then
					ColFilter(ColIdx) = NewCrit
					ApplyFilters
					If OnFilterChange Then OnFilterChange(*Designer, This, ColIdx)
				End If
			End If
		End If
		SetFocus
	End Sub

	Sub GridDataEx.CancelFilterEdit()
		'Aborts the filter editor without changing the criteria.
		If FFilterEditActive = False Then Exit Sub
		FFilterEditActive = False
		FFilterEditCol = -1
		If EditText_ <> 0 Then EditText_->Visible = False
		SetFocus
	End Sub

	Sub GridDataEx.DrawFilterBar(ByRef Cv As My.Sys.Drawing.Canvas, ByVal YTop As Long, ByVal XFixed As Long, ByVal XScroll As Long, ByVal FixedColCount As Long, ByVal LeftColDraw As Long, ByVal AreaRight As Long)
		'Draws the filter bar band: one cell per column showing its criterion
		'(or a faint "(All)" hint) plus a small drop-down cue, in two passes
		'like the row drawing (fixed columns, then the scrolled columns).
		Dim As Long H = FilterBarHeightPx()
		If H <= 0 Then Exit Sub
		Dim As My.Sys.Drawing.Rect RCBand
		RCBand.Left = XFixed
		RCBand.Top = YTop
		RCBand.Right = AreaRight
		RCBand.Bottom = YTop + H
		Cv.FillRect(RCBand, FlexWinColor(FBackColorFixed))
		Dim As Long PassStart(0 To 1), PassCol1(0 To 1), PassCol2(0 To 1)
		PassStart(0) = XFixed : PassStart(1) = XScroll
		PassCol1(0) = 0 : PassCol1(1) = LeftColDraw
		PassCol2(0) = FixedColCount - 1 : PassCol2(1) = FCols - 1
		Dim As Long LineClr = FlexWinColor(FGridColorFixed)
		For p As Integer = 0 To 1
			Dim As Long XCur = PassStart(p)
			For j As Long = PassCol1(p) To PassCol2(p)
				Dim As Long ColW = GetColWidthPx(j)
				If XCur > AreaRight Then Exit For
				'Hidden columns leave their band cell blank (zero width).
				If (ColsArr(j).State And FLEX_CLIS_HIDDEN) = 0 Then
					If j > 0 Then Cv.Line(XCur, YTop, XCur, YTop + H - 1, LineClr)
					'Criterion text, or the "(All)" hint for unfiltered columns.
					Dim As UString Crit = ColFilter(j)
					Dim As Long TextClr
					If Len(Crit) > 0 Then
						TextClr = FlexWinColor(FForeColorFixed)
					Else
						Crit = "(All)"
						TextClr = FlexWinColor(&HA0A0A0)
					End If
					Dim As Long Tx = XCur + 4
					Dim As Long Ty = YTop + (H - Cv.TextHeight(Crit)) \ 2
					Cv.TextOut(Tx, Ty, Crit, TextClr, -1)
					'Drop-down cue arrow: dark when this column filters, gray otherwise.
					Dim As Long CueClr = FlexWinColor(&HB0B0B0)
					If Len(ColFilter(j)) > 0 Then CueClr = FlexWinColor(&H404040)
					DrawSortArrow(Cv, XCur + ColW - 8, YTop + H \ 2, FlexSortArrowDescending, CueClr)
				End If
				XCur += ColW
			Next j
		Next p
		Cv.Line(XFixed, YTop + H - 1, AreaRight, YTop + H - 1, LineClr)
	End Sub

	Sub GridDataEx.DrawCellButtonGlyph(ByRef Cv As My.Sys.Drawing.Canvas, ByVal RCLeft As Long, ByVal RCTop As Long, ByVal RCRight As Long, ByVal RCBottom As Long, ByRef Caption As WString, ByVal Selected As Boolean, ByVal Disabled As Boolean)
		'Flat command button filling the cell minus a 2px margin; the colors
		'follow the current (light/dark) palette so dark mode stays coherent.
		Dim As Long Pad = 2
		Dim As Long BL = RCLeft + Pad, BT = RCTop + Pad
		Dim As Long BR = RCRight - Pad, BB = RCBottom - Pad
		Dim As Long BackClr, TextClr
		If Selected Then
			BackClr = FBackColorSel
			TextClr = IIf(FUseForeColorSel, FForeColorSel, FForeColorFixed)
		Else
			BackClr = FBackColorFixed
			TextClr = FForeColorFixed
		End If
		If Disabled Then BackClr = FBackColorBkg
		Dim As My.Sys.Drawing.Rect RC
		RC.Left = BL : RC.Top = BT : RC.Right = BR : RC.Bottom = BB
		Cv.FillRect(RC, FlexWinColor(BackClr))
		Dim As Long FrameClr = FlexWinColor(&H808080)
		Dim As Long HotClr = FlexWinColor(&H505050)
		Cv.Line(BL, BT, BR - 1, BT, FrameClr)
		Cv.Line(BL, BB - 1, BR - 1, BB - 1, FrameClr)
		Cv.Line(BL, BT, BL, BB - 1, FrameClr)
		Cv.Line(BR - 1, BT, BR - 1, BB - 1, HotClr)
		Dim As Long TW = Cv.TextWidth(Caption)
		Dim As Long TH = Cv.TextHeight(Caption)
		Dim As Long TX = BL + Max(2, ((BR - BL) - TW) \ 2)
		Dim As Long TY = BT + Max(1, ((BB - BT) - TH) \ 2)
		Cv.TextOut(TX, TY, Caption, FlexWinColor(TextClr), -1)
	End Sub

	'Sub GridDataEx.DrawBookmarkMark: bookmark ribbon with a notched bottom edge.
	Sub GridDataEx.DrawBookmarkMark(ByRef Cv As My.Sys.Drawing.Canvas, ByVal X As Long, ByVal Y As Long, ByVal W As Long, ByVal H As Long, ByVal Clr As Long)
		Dim As My.Sys.Drawing.Point Pts(0 To 4)
		Pts(0).X = X : Pts(0).Y = Y
		Pts(1).X = X + W : Pts(1).Y = Y
		Pts(2).X = X + W : Pts(2).Y = Y + H
		Pts(3).X = X + W \ 2 : Pts(3).Y = Y + Max(0, H - 4)
		Pts(4).X = X : Pts(4).Y = Y + H
		Dim As Long SavedPen = Cv.Pen.Color
		Dim As Long SavedBrush = Cv.Brush.Color
		Cv.Pen.Color = Clr
		Cv.Brush.Color = Clr
		Cv.Polygon(Pts(), 5)
		Cv.Pen.Color = SavedPen
		Cv.Brush.Color = SavedBrush
	End Sub

	Property GridDataEx.RowBookmarked(ByVal aIndex As Long) As Boolean
		If aIndex < 0 OrElse aIndex > FRows - 1 Then Return False
		Return CBool((RowsArr(aIndex).State And FLEX_RWIS_BOOKMARK) <> 0)
	End Property

	Property GridDataEx.RowBookmarked(ByVal aIndex As Long, ByVal Value As Boolean)
		If aIndex < 0 OrElse aIndex > FRows - 1 Then Exit Property
		If Value Then
			RowsArr(aIndex).State Or= FLEX_RWIS_BOOKMARK
		Else
			RowsArr(aIndex).State And= Not FLEX_RWIS_BOOKMARK
		End If
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.BookmarkCount As Long
		Dim As Long i, Count = 0
		For i = 0 To FRows - 1
			If (RowsArr(i).State And FLEX_RWIS_BOOKMARK) <> 0 Then Count += 1
		Next i
		Return Count
	End Property

	Function GridDataEx.NextBookmark(ByVal FromRow As Long = -1) As Long
		'First bookmarked row after FromRow (or after the current row), -1 if none.
		Dim As Long Start = IIf(FromRow < 0, FRow, FromRow) + 1
		For i As Long = Start To FRows - 1
			If (RowsArr(i).State And FLEX_RWIS_BOOKMARK) <> 0 Then Return i
		Next i
		Return -1
	End Function

	Function GridDataEx.PreviousBookmark(ByVal FromRow As Long = -1) As Long
		'First bookmarked row before FromRow (or before the current row), -1 if none.
		Dim As Long Start = IIf(FromRow < 0, FRow, FromRow) - 1
		For i As Long = Start To FFixedRows Step -1
			If (RowsArr(i).State And FLEX_RWIS_BOOKMARK) <> 0 Then Return i
		Next i
		Return -1
	End Function

	Sub GridDataEx.ClearBookmarks()
		Dim As Boolean Had = False
		For i As Long = 0 To FRows - 1
			If (RowsArr(i).State And FLEX_RWIS_BOOKMARK) <> 0 Then
				RowsArr(i).State And= Not FLEX_RWIS_BOOKMARK
				Had = True
			End If
		Next i
		If Had AndAlso FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Sub

	Sub GridDataEx.MultiSortClear()
		If LBound(FSortKeys) <= UBound(FSortKeys) Then Erase FSortKeys
	End Sub

	Sub GridDataEx.MultiSortAdd(ByVal aCol As Long, ByVal SortType As Integer = FlexSortGenericAscending)
		'Appends a sort key; the first key added is the primary column.
		If aCol < FFixedCols OrElse aCol > FCols - 1 Then Exit Sub
		Dim As Long n = 0
		If LBound(FSortKeys) <= UBound(FSortKeys) Then n = UBound(FSortKeys) - LBound(FSortKeys) + 1
		ReDim Preserve FSortKeys(0 To n)
		FSortKeys(n).Col = aCol
		FSortKeys(n).SortType = SortType
	End Sub

	Property GridDataEx.MultiSortCount As Long
		If LBound(FSortKeys) > UBound(FSortKeys) Then Return 0
		Return UBound(FSortKeys) - LBound(FSortKeys) + 1
	End Property

	Property GridDataEx.MultiSortCol(ByVal aIndex As Long) As Long
		If LBound(FSortKeys) > UBound(FSortKeys) Then Return -1
		If aIndex < 0 OrElse aIndex > UBound(FSortKeys) - LBound(FSortKeys) Then Return -1
		Return FSortKeys(aIndex).Col
	End Property

	Property GridDataEx.MultiSortType(ByVal aIndex As Long) As Integer
		If LBound(FSortKeys) > UBound(FSortKeys) Then Return FlexSortNone
		If aIndex < 0 OrElse aIndex > UBound(FSortKeys) - LBound(FSortKeys) Then Return FlexSortNone
		Return FSortKeys(aIndex).SortType
	End Property

	Sub GridDataEx.MultiSortRun()
		'Applies the queued keys bottom-up through the stable insertion Sort,
		'so the first key ends up as the primary ordering, then refreshes the
		'sort arrows (each key column shows its direction).
		Dim As Long n = MultiSortCount
		If n = 0 Then Exit Sub
		Redraw = False
		For k As Long = n - 1 To 0 Step -1
			Sort(FSortKeys(k).Col, FSortKeys(k).SortType)
		Next k
		Redraw = True
		For j As Long = 0 To FCols - 1
			ColSortArrow(j) = FlexSortArrowNone
		Next j
		For k As Long = 0 To n - 1
			Dim As Boolean Desc = (FSortKeys(k).SortType = FlexSortGenericDescending) OrElse _
			                      (FSortKeys(k).SortType = FlexSortNumericDescending) OrElse _
			                      (FSortKeys(k).SortType = FlexSortStringNoCaseDescending) OrElse _
			                      (FSortKeys(k).SortType = FlexSortStringDescending) OrElse _
			                      (FSortKeys(k).SortType = FlexSortCurrencyDescending) OrElse _
			                      (FSortKeys(k).SortType = FlexSortDateDescending)
			ColSortArrow(FSortKeys(k).Col) = IIf(Desc, FlexSortArrowDescending, FlexSortArrowAscending)
		Next k
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Sub

	Property GridDataEx.Zoom As Double
		Return FZoom
	End Property

	Property GridDataEx.Zoom(ByVal Value As Double)
		If Value < 0.25 Then Value = 0.25
		If Value > 4 Then Value = 4
		If Value = FZoom Then Exit Property
		'Capture the design font size once so zooming is reversible.
		If FZoomBaseFont = 0 Then FZoomBaseFont = Font.Size
		FZoom = Value
		If FZoomBaseFont > 0 Then
			Dim As Integer NewSize = CInt(FZoomBaseFont * FZoom)
			If NewSize < 1 Then NewSize = 1
			Font.Size = NewSize
		End If
		InvalidateRowGeometry
		InvalidateColGeometry
		PositionEditBox
		SetScrollBarsInternal
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Function GridDataEx.EscapeHTMLText(ByRef S As WString) As String
		'Escapes the characters that are special inside HTML.
		If InStr(S, "&") = 0 AndAlso InStr(S, "<") = 0 AndAlso InStr(S, ">") = 0 AndAlso _
		   InStr(S, """") = 0 AndAlso InStr(S, "'") = 0 Then Return S
		Dim As String R = ""
		For i As Long = 1 To Len(S)
			Dim As String Ch = Mid(S, i, 1)
			Select Case Ch
				Case "&" : R &= "&amp;"
				Case "<" : R &= "&lt;"
				Case ">" : R &= "&gt;"
				Case """" : R &= "&quot;"
				Case "'" : R &= "&#39;"
				Case Else : R &= Ch
			End Select
		Next i
		Return R
	End Function

	Function GridDataEx.ExportHTML(ByRef FileName As WString, ByVal WithHeaders As Boolean = True, ByVal WithStyles As Boolean = True) As Boolean
		'Writes the visible cells as a self-contained HTML table document (UTF-8).
		Dim As Integer ff = FreeFile
		If Dir(FileName) <> "" Then Kill FileName
		Open FileName For Output Encoding "utf8" As #ff
		Print #ff, "<!DOCTYPE html>"
		Print #ff, "<html>"
		Print #ff, "<head>"
		Print #ff, "<meta charset=""utf-8"">"
		Print #ff, "<title>GridDataEx Export</title>"
		If WithStyles Then
			Print #ff, "<style>"
			Print #ff, "body{font-family:'Segoe UI',Arial,sans-serif;margin:16px}"
			Print #ff, "table{border-collapse:collapse;font-size:13px}"
			Print #ff, "th,td{border:1px solid #c0c0c0;padding:3px 8px;white-space:nowrap}"
			Print #ff, "th{background:#e8e8e8;text-align:left}"
			Print #ff, "tbody tr:nth-child(even) td{background:#f7f7f7}"
			Print #ff, "</style>"
		End If
		Print #ff, "</head>"
		Print #ff, "<body>"
		Print #ff, "<table>"
		If WithHeaders AndAlso (FFixedRows > 0) Then
			Print #ff, "<thead>"
			For i As Long = 0 To FFixedRows - 1
				If (RowsArr(i).State And FLEX_RWIS_HIDDEN) = 0 Then
					Dim As String Hdr = "<tr>"
					For j As Long = 0 To FCols - 1
						If (ColsArr(j).State And FLEX_CLIS_HIDDEN) = 0 Then
							Hdr &= "<th>" & EscapeHTMLText(CellTextRaw(i, j)) & "</th>"
						End If
					Next j
					Print #ff, Hdr & "</tr>"
				End If
			Next i
			Print #ff, "</thead>"
		End If
		Print #ff, "<tbody>"
		For i As Long = FFixedRows To FRows - 1
			If (RowsArr(i).State And FLEX_RWIS_HIDDEN) = 0 Then
				Dim As String RowHtml = "<tr>"
				For j As Long = 0 To FCols - 1
					If (ColsArr(j).State And FLEX_CLIS_HIDDEN) = 0 Then
						RowHtml &= "<td>" & EscapeHTMLText(CellTextRaw(i, j)) & "</td>"
					End If
				Next j
				Print #ff, RowHtml & "</tr>"
			End If
		Next i
		Print #ff, "</tbody>"
		Print #ff, "</table>"
		Print #ff, "</body>"
		Print #ff, "</html>"
		Close #ff
		Return True
	End Function

	Function GridDataEx.EscapeJSONText(ByRef S As WString) As String
		'Escapes a string for use inside a JSON literal.
		If InStr(S, "\") = 0 AndAlso InStr(S, """") = 0 AndAlso _
		   InStr(S, Chr(8)) = 0 AndAlso InStr(S, Chr(12)) = 0 AndAlso _
		   InStr(S, Chr(10)) = 0 AndAlso InStr(S, Chr(13)) = 0 AndAlso _
		   InStr(S, Chr(9)) = 0 Then Return S
		Dim As String R = ""
		For i As Long = 1 To Len(S)
			Dim As Long CC = Asc(S, i)
			Select Case CC
				Case 34 : R &= "\"""
				Case 92 : R &= "\\"
				Case 8 : R &= "\b"
				Case 12 : R &= "\f"
				Case 10 : R &= "\n"
				Case 13 : R &= "\r"
				Case 9 : R &= "\t"
				Case Else
					If CC < 32 Then
						Dim As String HX = Hex(CC)
						Do While Len(HX) < 4
							HX = "0" & HX
						Loop
						R &= "\u" & HX
					Else
						R &= Mid(S, i, 1)
					End If
			End Select
		Next i
		Return R
	End Function

	Function GridDataEx.ExportJSON(ByRef FileName As WString, ByVal WithHeaders As Boolean = True) As Boolean
		'Writes the visible cells as a JSON array: objects keyed by the header
		'text of row 0 (or ColKey) when WithHeaders, else arrays of arrays.
		If FCols < 1 Then Return False
		Dim As Boolean UseObjects = WithHeaders AndAlso (FFixedRows > 0)
		'Column names for the object form.
		Dim names(0 To FCols - 1) As String
		For j As Long = 0 To FCols - 1
			Dim As String NK = ColKey(j)
			If Len(NK) = 0 Then NK = CellTextRaw(0, j)
			names(j) = NK
		Next j
		Dim As WString Ptr Out = 0
		WAdd(Out, "[")
		Dim As Long Written = 0
		For i As Long = FFixedRows To FRows - 1
			If (RowsArr(i).State And FLEX_RWIS_HIDDEN) <> 0 Then Continue For
			If Written > 0 Then WAdd(Out, ",")
			If UseObjects Then WAdd(Out, "{") Else WAdd(Out, "[")
			Dim As Long fc = 0
			For j As Long = 0 To FCols - 1
				If (ColsArr(j).State And FLEX_CLIS_HIDDEN) <> 0 Then Continue For
				If fc > 0 Then WAdd(Out, ",")
				If UseObjects Then WAdd(Out, """" & EscapeJSONText(names(j)) & """:")
				WAdd(Out, """" & EscapeJSONText(CellTextRaw(i, j)) & """")
				fc += 1
			Next j
			If UseObjects Then WAdd(Out, "}") Else WAdd(Out, "]")
			Written += 1
		Next i
		WAdd(Out, "]")
		Dim As Integer ff = FreeFile
		If Dir(FileName) <> "" Then Kill FileName
		Open FileName For Output Encoding "utf8" As #ff
		Print #ff, *Out
		Close #ff
		WDeAllocate(Out)
		'FB's "utf8" output always writes a BOM; strict JSON parsers reject it,
		'so strip the three leading bytes back off (rebuild the file, since a
		'Binary Put would leave the old tail in place).
		Dim As Integer fb2 = FreeFile
		Open FileName For Binary As #fb2
		If Lof(fb2) >= 3 Then
			Dim As String B3 = String(3, 0)
			Get #fb2, 1, B3
			If B3 = Chr(&HEF) & Chr(&HBB) & Chr(&HBF) Then
				Dim As String Rest = String(Lof(fb2) - 3, 0)
				Get #fb2, 4, Rest
				Close #fb2
				Kill FileName
				Dim As Integer fb3 = FreeFile
				Open FileName For Binary As #fb3
				Put #fb3, 1, Rest
				Close #fb3
			Else
				Close #fb2
			End If
		Else
			Close #fb2
		End If
		Return True
	End Function

	'=== Batch 5: VBFlexGrid 1.8 remaining public surface ===
	Property GridDataEx.ShowInfoTips As Boolean
		Return FShowInfoTips
	End Property

	Property GridDataEx.ShowInfoTips(ByVal Value As Boolean)
		FShowInfoTips = Value
	End Property

	Property GridDataEx.ShowLabelTips As Boolean
		Return FShowLabelTips
	End Property

	Property GridDataEx.ShowLabelTips(ByVal Value As Boolean)
		FShowLabelTips = Value
	End Property

	Property GridDataEx.ShowScrollTips As Boolean
		Return FShowScrollTips
	End Property

	Property GridDataEx.ShowScrollTips(ByVal Value As Boolean)
		FShowScrollTips = Value
	End Property

	Property GridDataEx.AllowScrollLock As Boolean
		Return FAllowScrollLock
	End Property

	Property GridDataEx.AllowScrollLock(ByVal Value As Boolean)
		FAllowScrollLock = Value
	End Property



	Function GridDataEx.HasLookup(ByVal aCol As Long) As Boolean
		If aCol < 0 OrElse aCol > FCols - 1 Then Return False
		Return ColsArr(aCol).Lookup <> 0 AndAlso Len(*ColsArr(aCol).Lookup) > 0
	End Function

	Function GridDataEx.LookupTranslate(ByRef Txt As WString, ByVal Conversion As Integer, ByVal aCol As Long) ByRef As WString
		'ColLookup format: "key;value|key;value|..."; items without ";" have
		'an empty key. Value -> key is case-insensitive, key -> value matches
		'the value exactly (both like the VB6 original).
		If HasLookup(aCol) = False Then Return Txt
		Dim As UString Prop, Item, K, V
		Prop = *ColsArr(aCol).Lookup
		Dim As Long P1 = 1
		Do
			Dim As Long Bar = InStr(P1, Prop, "|")
			If Bar > 0 Then Item = Mid(Prop, P1, Bar - P1) Else Item = Mid(Prop, P1)
			Dim As Long Semi = InStr(Item, ";")
			K = ""
			V = ""
			If Semi > 0 Then
				K = Mid(Item, 1, Semi - 1)
				V = Mid(Item, Semi + 1)
			Else
				V = Item
			End If
			If Conversion = FlexLookupConvValue Then
				If UCase(K) = UCase(Txt) Then
					WLet(FTextTmp, V)
					Return *FTextTmp
				End If
			Else
				If V = Txt Then 
					WLet(FTextTmp, K)
					Return *FTextTmp
				End If
			End If
			If Bar = 0 Then Exit Do
			P1 = Bar + 1
		Loop
		Return Txt
	End Function

	Property GridDataEx.ColLookup(ByVal aIndex As Long) ByRef As WString
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return ""
		If ColsArr(aIndex).Lookup = 0 Then Return ""
		Return *ColsArr(aIndex).Lookup
	End Property

	Property GridDataEx.ColLookup(ByVal aIndex As Long, ByRef Value As WString)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		WLet(ColsArr(aIndex).Lookup, Value)
		InvalidateMergeCache
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Function GridDataEx.LookupConv(ByRef Txt As WString, ByVal Conversion As Integer, ByVal aCol As Long = -1) ByRef As WString
		If aCol < 0 Then aCol = FCol
		Return LookupTranslate(Txt, Conversion, aCol)
	End Function

	Function GridDataEx.TextDisplay(ByVal aRow As Long, ByVal aCol As Long) ByRef As WString
		'The cell text as shown to the user (lookup-translated when set).
		Return LookupTranslate(TextMatrix(aRow, aCol), FlexLookupConvValue, aCol)
	End Function

	Property GridDataEx.FormatString ByRef As WString
		If FFormatString = 0 Then Return ""
		Return *FFormatString
	End Property

	Property GridDataEx.FormatString(ByRef Value As WString)
		'First ";" splits the column headers part (row 0) from the row headers
		'part (column 0). Alignment prefix per column: < left, ^ center, > right.
		WLet(FFormatString, Value)
		If Len(Value) = 0 OrElse FFixedRows < 1 Then Exit Property
		Dim As UString FormatCol = "", FormatRow = ""
		Dim As Long PosSemi = InStr(Value, ";")
		If PosSemi > 0 Then
			FormatCol = Mid(Value, 1, PosSemi - 1)
			FormatRow = Mid(Value, PosSemi + 1)
		Else
			FormatCol = Value
		End If
		Redraw = False
		Dim As Long Pos1 = 0, Pos2 = 0, Idx = 0
		If Len(FormatCol) > 0 Then
			'Count and size the grid first.
			Dim As Long nCols = 1
			For i As Long = 1 To Len(FormatCol)
				If Mid(FormatCol, i, 1) = "|" Then nCols += 1
			Next i
			If nCols > FCols Then Cols = nCols
			Do
				Pos1 = InStr(Pos1 + 1, FormatCol, "|")
				Dim As UString Tk
				If Pos1 > 0 Then Tk = Mid(FormatCol, Pos2 + 1, Pos1 - Pos2 - 1) Else Tk = Mid(FormatCol, Pos2 + 1)
				Dim As Integer Al = FlexAlignmentGeneral
				Select Case Mid(Tk, 1, 1)
					Case "<" : Al = FlexAlignmentLeftCenter : Tk = Mid(Tk, 2)
					Case "^" : Al = FlexAlignmentCenterCenter : Tk = Mid(Tk, 2)
					Case ">" : Al = FlexAlignmentRightCenter : Tk = Mid(Tk, 2)
				End Select
				Tk = Trim(Tk)
				If Idx <= FCols - 1 Then
					ColsArr(Idx).Alignment = Al
					Dim As Long BestPx = TextWidthOf(Tk)
					ColsArr(Idx).Width = CLng((BestPx + 10) * TwipsPerPixelX())
					TextMatrix(0, Idx, Tk)
				End If
				Pos2 = Pos1
				Idx += 1
			Loop Until Pos1 = 0
		End If
		If (Len(FormatRow) > 0 OrElse PosSemi > 0) AndAlso FFixedCols > 0 Then
			Dim As Long nRows = 1
			For i As Long = 1 To Len(FormatRow)
				If Mid(FormatRow, i, 1) = "|" Then nRows += 1
			Next i
			If nRows > FRows Then Rows = nRows
			Pos1 = 0 : Pos2 = 0 : Idx = 0
			Do
				Pos1 = InStr(Pos1 + 1, FormatRow, "|")
				Dim As UString Tk
				If Pos1 > 0 Then Tk = Mid(FormatRow, Pos2 + 1, Pos1 - Pos2 - 1) Else Tk = Mid(FormatRow, Pos2 + 1)
				Tk = Trim(Tk)
				If Idx <= FRows - 1 Then
					TextMatrix(Idx, 0, Tk)
					Dim As Long BestPx = TextWidthOf(Tk)
					Dim As Long Want = CLng((BestPx + 10) * TwipsPerPixelX())
					If Want > ColWidth(0) Then ColWidth(0) = Want
				End If
				Pos2 = Pos1
				Idx += 1
			Loop Until Pos1 = 0
		End If
		InvalidateColGeometry
		SetScrollBarsInternal
		Redraw = True
		If Handle <> 0 Then RepaintGrid
	End Property

	Function GridDataEx.DoDragRowCol(ByVal RowIdx As Long, ByVal ColIdx As Long) As Long
		'Modal drag loop: shows the insert mark as feedback, auto-scrolls near
		'the viewport edges and returns the drop target index (or the original
		'index when canceled with Escape).
		Dim As Long Result = IIf(RowIdx > -1, RowIdx, ColIdx)
		Dim As Boolean IsRow = (RowIdx > -1)
		Dim As Long FixedBound = IIf(IsRow, FFixedRows, FFixedCols)
		Dim As Long FrozenAdd = IIf(IsRow, FFrozenRows, FFrozenCols)
		Dim As Long LastIdx = IIf(IsRow, FRows - 1, FCols - 1)
		If Result < FixedBound OrElse Result > LastIdx Then Return Result
		#ifdef __USE_WINAPI__
		If Handle = 0 Then Return Result
		If (FlexGetMouseState() And (FLEX_LEFT_BUTTON Or FLEX_RIGHT_BUTTON)) = 0 Then Return Result
		FDragRowColActive = True
		SetCapture(Handle)
		Dim As Long TrackIdx = Result
		Dim As Boolean Done = False, Escaped = False
		Dim As MSG M
		While Done = False
			If PeekMessage(@M, NULL, 0, 0, PM_REMOVE) = 0 Then
				WaitMessage()
				Continue While
			End If
			Select Case M.message
				Case WM_MOUSEMOVE
					Dim As POINT PtW
					GetCursorPos(@PtW)
					Dim As My.Sys.Drawing.Point Pt
					Pt.x = PtW.x : Pt.y = PtW.y
					ScreenToClient(Pt)
					If IsRow Then
						Dim As Long GR = RowAtY(GridYFromClient(Pt.y))
						If GR >= FixedBound + FrozenAdd Then
							TrackIdx = Min(GR, LastIdx)
						ElseIf Pt.y < RowTopY(FixedBound + FrozenAdd) Then
							TrackIdx = FixedBound + FrozenAdd
							'Auto-scroll up while over the fixed band.
							If TopRow > FixedBound + FrozenAdd Then TopRow = TopRow - 1
						Else
							'Below the last row: scroll down if possible.
							If TopRow < FRows - 1 Then TopRow = TopRow + 1
						End If
					Else
						Dim As Long GC = ColAtX(GridXFromClient(Pt.x))
						If GC >= FixedBound + IIf(IsRow = False, FFrozenCols, 0) Then
							TrackIdx = Min(GC, LastIdx)
						ElseIf Pt.x < ColLeftX(FixedBound + FFrozenCols) Then
							TrackIdx = FixedBound + FFrozenCols
							If LeftCol > FixedBound + FFrozenCols Then LeftCol = LeftCol - 1
						Else
							If LeftCol < FCols - 1 Then LeftCol = LeftCol + 1
						End If
					End If
					InsertMark(False) = TrackIdx
				Case WM_LBUTTONUP, WM_RBUTTONUP
					Done = True
				Case WM_KEYDOWN
					If M.wParam = VK_ESCAPE Then
						Done = True
						Escaped = True
					End If
					'Drag keys are consumed, everything else is dispatched.
				Case Else
					TranslateMessage(@M)
					DispatchMessage(@M)
			End Select
		Wend
		ReleaseCapture()
		InsertMark(False) = -1
		FDragRowColActive = False
		If Escaped Then Return Result
		Return Max(FixedBound + FrozenAdd, Min(TrackIdx, LastIdx))
		#else
		Return Result
		#endif
	End Function

	Function GridDataEx.DragRow(ByVal Index As Long) As Long
		InsertMarkMode = FlexDropTargetModeByRow
		Return DoDragRowCol(Index, -1)
	End Function

	Function GridDataEx.DragCol(ByVal Index As Long) As Long
		InsertMarkMode = FlexDropTargetModeByColumn
		Return DoDragRowCol(-1, Index)
	End Function

	Property GridDataEx.InsertMark(ByRef After As Boolean) As Long
		After = FInsertMarkAfter
		Return FInsertMark
	End Property

	Property GridDataEx.InsertMark(ByVal After As Boolean, ByVal Value As Long)
		If Value <> -1 Then
			If FInsertMarkMode = FlexDropTargetModeByRow Then
				If Value < 0 OrElse Value > FRows - 1 Then Exit Property
			Else
				If Value < 0 OrElse Value > FCols - 1 Then Exit Property
			End If
		End If
		If FInsertMark = Value AndAlso FInsertMarkAfter = After Then Exit Property
		FInsertMark = Value
		FInsertMarkAfter = After
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.InsertMarkMode As Integer
		Return FInsertMarkMode
	End Property

	Property GridDataEx.InsertMarkMode(ByVal Value As Integer)
		If Value = FInsertMarkMode Then Exit Property
		FInsertMarkMode = Value
		FInsertMark = -1
		FInsertMarkAfter = False
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Function GridDataEx.HitTestInsertMark(ByVal X As Long, ByVal Y As Long, ByRef After As Boolean) As Long
		'Returns the row/column at the position; After is True when the
		'position sits in the lower/right half of it.
		After = False
		Dim As Long HitIdx = -1
		If FInsertMarkMode = FlexDropTargetModeByRow Then
			Dim As Long GR = RowAtY(GridYFromClient(Y))
			HitIdx = Max(FFixedRows, Min(IIf(GR < 0, FRows - 1, GR), FRows - 1))
			Dim As Long MidPix = RowTopY(HitIdx) + GetRowHeightPx(HitIdx) \ 2
			After = (GridYFromClient(Y) > MidPix)
		Else
			Dim As Long GC = ColAtX(GridXFromClient(X))
			HitIdx = Max(FFixedCols, Min(IIf(GC < 0, FCols - 1, GC), FCols - 1))
			Dim As Long MidPixC = ColLeftX(HitIdx) + GetColWidthPx(HitIdx) \ 2
			After = (GridXFromClient(X) > MidPixC)
		End If
		Return HitIdx
	End Function

	Property GridDataEx.DropHighlight As Long
		Return FDropHighlight
	End Property

	Property GridDataEx.DropHighlight(ByVal Value As Long)
		If FDropHighlightMode = FlexDropTargetModeByRow Then
			If Value <> -1 AndAlso (Value < 0 OrElse Value > FRows - 1) Then Exit Property
		Else
			If Value <> -1 AndAlso (Value < 0 OrElse Value > FCols - 1) Then Exit Property
		End If
		If FDropHighlight = Value Then Exit Property
		FDropHighlight = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.DropHighlightMode As Integer
		Return FDropHighlightMode
	End Property

	Property GridDataEx.DropHighlightMode(ByVal Value As Integer)
		If Value = FDropHighlightMode Then Exit Property
		FDropHighlightMode = Value
		FDropHighlight = -1
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Sub GridDataEx.DrawInsertMark(ByRef Cv As My.Sys.Drawing.Canvas)
		'Thick arrow with a shaft at the row/column boundary.
		If FInsertMark < 0 Then Exit Sub
		Dim As Long Clr = FInsertMarkColor
		If Clr < 0 Then Clr = &H0000A5FF 'orange
		Clr = FlexWinColor(Clr)
		Dim As Long BorderSize = GetGridLineOffsets_AreaTop()
		Dim As Long X1 = BorderSize, Y1 = BorderSize
		Dim As Long X2 = ClientWidthPx() - BorderSize, Y2 = ClientHeightPx() - BorderSize
		Dim As My.Sys.Drawing.Point Tri(0 To 2)
		Dim As Long SavedPen = Cv.Pen.Color
		Dim As Long SavedBrush = Cv.Brush.Color
		Cv.Pen.Color = Clr
		Cv.Brush.Color = Clr
		If FInsertMarkMode = FlexDropTargetModeByRow Then
			Dim As Long FixedTotal = FFixedRows + FFrozenRows
			Dim As Long Y = BorderSize + RowTopY(FixedTotal) + FilterBarHeightPx() + (RowTopY(FInsertMark) - RowTopY(Max(FTopRow, FixedTotal)))
			If FInsertMarkAfter Then Y += GetRowHeightPx(FInsertMark)
			If Y < Y1 Then Y = Y1
			If Y > Y2 Then Y = Y2
			Cv.Line(X1, Y - 1, X1 + 14, Y - 1, Clr)
			Cv.Line(X1, Y, X1 + 14, Y, Clr)
			Tri(0).X = X1 + 14 : Tri(0).Y = Y - 5
			Tri(1).X = X1 + 14 : Tri(1).Y = Y + 4
			Tri(2).X = X1 + 21 : Tri(2).Y = Y
			Cv.Polygon(Tri(), 3)
		Else
			Dim As Long FixedTotalC = FFixedCols + FFrozenCols
			Dim As Long X = BorderSize + ColLeftX(FixedTotalC) + (ColLeftX(FInsertMark) - ColLeftX(Max(FLeftCol, FixedTotalC)))
			If FInsertMarkAfter Then X += GetColWidthPx(FInsertMark)
			If X < X1 Then X = X1
			If X > X2 Then X = X2
			Cv.Line(X - 1, Y1, X - 1, Y1 + 14, Clr)
			Cv.Line(X, Y1, X, Y1 + 14, Clr)
			Tri(0).X = X - 5 : Tri(0).Y = Y1 + 14
			Tri(1).X = X + 4 : Tri(1).Y = Y1 + 14
			Tri(2).X = X : Tri(2).Y = Y1 + 21
			Cv.Polygon(Tri(), 3)
		End If
		Cv.Pen.Color = SavedPen
		Cv.Brush.Color = SavedBrush
	End Sub

	Sub GridDataEx.DrawDropHighlight(ByRef Cv As My.Sys.Drawing.Canvas)
		'2px outline around the highlighted target row/column band.
		If FDropHighlight < 0 Then Exit Sub
		Dim As Long Clr = FlexWinColor(FBackColorSel)
		Dim As Long BorderSize = GetGridLineOffsets_AreaTop()
		Dim As My.Sys.Drawing.Rect RC
		If FDropHighlightMode = FlexDropTargetModeByRow Then
			Dim As Long FixedTotal = FFixedRows + FFrozenRows
			Dim As Long YTop = BorderSize + RowTopY(FixedTotal) + FilterBarHeightPx() + (RowTopY(FDropHighlight) - RowTopY(Max(FTopRow, FixedTotal)))
			Dim As Long YBot = YTop + GetRowHeightPx(FDropHighlight)
			RC.Left = BorderSize : RC.Top = YTop
			RC.Right = ClientWidthPx() - BorderSize : RC.Bottom = YBot
		Else
			Dim As Long FixedTotalC = FFixedCols + FFrozenCols
			Dim As Long XL = BorderSize + ColLeftX(FixedTotalC) + (ColLeftX(FDropHighlight) - ColLeftX(Max(FLeftCol, FixedTotalC)))
			Dim As Long XR = XL + GetColWidthPx(FDropHighlight)
			RC.Left = XL : RC.Top = BorderSize
			RC.Right = XR : RC.Bottom = ClientHeightPx() - BorderSize
		End If
		Dim As Long k
		For k = 0 To 1
			Cv.Line(RC.Left, RC.Top + k, RC.Right - 1, RC.Top + k, Clr)
			Cv.Line(RC.Left, RC.Bottom - 1 - k, RC.Right - 1, RC.Bottom - 1 - k, Clr)
			Cv.Line(RC.Left + k, RC.Top, RC.Left + k, RC.Bottom - 1, Clr)
			Cv.Line(RC.Right - 1 - k, RC.Top, RC.Right - 1 - k, RC.Bottom - 1, Clr)
		Next k
	End Sub

	Property GridDataEx.WallPaper As Any Ptr
		Return FWallPaper
	End Property

	Property GridDataEx.WallPaper(ByVal Value As Any Ptr)
		FWallPaper = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.WallPaperAlignment As Integer
		Return FWallPaperAlignment
	End Property

	Property GridDataEx.WallPaperAlignment(ByVal Value As Integer)
		FWallPaperAlignment = Value
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Sub GridDataEx.DrawWallPaperArea(ByRef Cv As My.Sys.Drawing.Canvas, ByVal RCLeft As Long, ByVal RCTop As Long, ByVal RCRight As Long, ByVal RCBottom As Long)
		'Nine-grid / stretch / tile placement across the grid area.
		#ifdef __USE_WINAPI__
		If FWallPaper = 0 Then Exit Sub
		Dim As Long W = 0, H = 0
		GetGraphicSize(FWallPaper, False, W, H)
		If W <= 0 OrElse H <= 0 Then W = 16 : H = 16
		Dim As Long RCW = RCRight - RCLeft, RCH = RCBottom - RCTop
		Dim As Long X = RCLeft, Y = RCTop
		Select Case FWallPaperAlignment
			Case FlexWallPaperAlignmentStretch
				RenderGraphic(Cv, FWallPaper, False, RCLeft, RCTop, RCW, RCH)
				Exit Sub
			Case FlexWallPaperAlignmentTile
				Dim As Long YY = RCTop
				Do While YY < RCBottom
					Dim As Long XX = RCLeft
					Do While XX < RCRight
						RenderGraphic(Cv, FWallPaper, False, XX, YY, W, H)
						XX += W
					Loop
					YY += H
				Loop
				Exit Sub
			Case FlexWallPaperAlignmentLeftCenter, FlexWallPaperAlignmentCenterCenter, FlexWallPaperAlignmentRightCenter
				Y = RCTop + (RCH - H) \ 2
			Case FlexWallPaperAlignmentLeftBottom, FlexWallPaperAlignmentCenterBottom, FlexWallPaperAlignmentRightBottom
				Y = RCBottom - H
		End Select
		Select Case FWallPaperAlignment
			Case FlexWallPaperAlignmentCenterTop, FlexWallPaperAlignmentCenterCenter, FlexWallPaperAlignmentCenterBottom
				X = RCLeft + (RCW - W) \ 2
			Case FlexWallPaperAlignmentRightTop, FlexWallPaperAlignmentRightCenter, FlexWallPaperAlignmentRightBottom
				X = RCRight - W
		End Select
		RenderGraphic(Cv, FWallPaper, False, X, Y, W, H)
		#endif
	End Sub

	Property GridDataEx.AllowDropFiles As Boolean
		Return FAllowDropFiles
	End Property

	Property GridDataEx.AllowDropFiles(ByVal Value As Boolean)
		FAllowDropFiles = Value
		#ifdef __USE_WINAPI__
			If Handle <> 0 Then DragAcceptFiles(Handle, IIf(Value, 1, 0))
		#endif
	End Property

	Property GridDataEx.AllowReaderMode As Boolean
		Return FAllowReaderMode
	End Property

	Property GridDataEx.AllowReaderMode(ByVal Value As Boolean)
		FAllowReaderMode = Value
	End Property

	Property GridDataEx.MouseTrack As Boolean
		Return FMouseTrack
	End Property

	Property GridDataEx.MouseTrack(ByVal Value As Boolean)
		FMouseTrack = Value
	End Property

	Property GridDataEx.ColTextIndent(ByVal aIndex As Long) As Boolean
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return False
		Return CBool((ColsArr(aIndex).State And FLEX_CLIS_TEXTINDENT) <> 0)
	End Property

	Property GridDataEx.ColTextIndent(ByVal aIndex As Long, ByVal Value As Boolean)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		If Value Then
			ColsArr(aIndex).State Or= FLEX_CLIS_TEXTINDENT
		Else
			ColsArr(aIndex).State And= Not FLEX_CLIS_TEXTINDENT
		End If
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.ColMimicTextBox(ByVal aIndex As Long) As Boolean
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return False
		Return CBool(ColsArr(aIndex).MimicTextBox <> 0)
	End Property

	Property GridDataEx.ColMimicTextBox(ByVal aIndex As Long, ByVal Value As Boolean)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		ColsArr(aIndex).MimicTextBox = IIf(Value, FlexMimicTextBoxOn, FlexMimicTextBoxOff)
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.ScrollTipText ByRef As WString
		If FScrollTipText = 0 Then Return ""
		Return *FScrollTipText
	End Property

	Property GridDataEx.ScrollTipText(ByRef Value As WString)
		WLet(FScrollTipText, Value)
	End Property

	Sub GridDataEx.EnsureScrollTip()
		#ifdef __USE_WINAPI__
		If FScrollTipHwnd <> 0 Then Exit Sub
		Dim As WString * 50 ClsName = "tooltips_class32"
		FScrollTipHwnd = Cast(Any Ptr, CreateWindowEx(WS_EX_TOOLWINDOW Or WS_EX_TOPMOST Or WS_EX_TRANSPARENT, _
			@ClsName, NULL, WS_POPUP Or TTS_ALWAYSTIP Or TTS_NOPREFIX, _
			0, 0, 0, 0, Handle, NULL, Cast(HINSTANCE, GetModuleHandle(NULL)), NULL))
		If FScrollTipHwnd <> 0 Then
			Dim As TOOLINFO TI
			TI.cbSize = SizeOf(TOOLINFO)
			TI.hWnd = Handle
			TI.uId = 0
			TI.uFlags = TTF_TRACK
			SendMessage(Cast(HWND, FScrollTipHwnd), TTM_SETMAXTIPWIDTH, 0, Cast(LPARAM, &H7FFF))
			SendMessage(Cast(HWND, FScrollTipHwnd), TTM_ADDTOOL, 0, Cast(LPARAM, @TI))
		End If
		#endif
	End Sub

	Sub GridDataEx.UpdateScrollTip(ByVal wBar As Long, ByVal TrackPos As Long)
		#ifdef __USE_WINAPI__
		If FShowScrollTips = False Then Exit Sub
		Dim As Long TipRow = -1, TipCol = -1
		If wBar = SB_HORZ Then
			TipCol = Min((FFixedCols + FFrozenCols) + TrackPos, FCols - 1)
		Else
			TipRow = Min((FFixedRows + FFrozenRows) + TrackPos, FRows - 1)
		End If
		WLet(FScrollTipText, "")
		If OnScrollTip Then OnScrollTip(*Designer, This, TipRow, TipCol)
		EnsureScrollTip()
		If FScrollTipHwnd = 0 Then Exit Sub
		If FScrollTipText = 0 OrElse  *FScrollTipText = "" Then Exit Sub
		Dim As TOOLINFO TI
		TI.cbSize = SizeOf(TOOLINFO)
		TI.hWnd = Handle
		TI.uId = 0
		TI.lpszText = FScrollTipText
		SendMessage(Cast(HWND, FScrollTipHwnd), TTM_UPDATETIPTEXT, 0, Cast(LPARAM, @TI))
		Dim As RECT WR
		GetWindowRect(Handle, @WR)
		Dim As POINT mp
		GetCursorPos(@mp)
		Dim As Long Tx, Ty
		If wBar = SB_VERT Then
			Tx = WR.Right
			Ty = mp.y
		Else
			Tx = mp.x
			Ty = WR.Bottom
		End If
		SendMessage(Cast(HWND, FScrollTipHwnd), TTM_TRACKPOSITION, 0, Cast(LPARAM, (Tx And &HFFFF) Or ((Ty And &HFFFF) Shl 16)))
		If FScrollTipShown = False Then
			SendMessage(Cast(HWND, FScrollTipHwnd), TTM_TRACKACTIVATE, 1, Cast(LPARAM, @TI))
			FScrollTipShown = True
		End If
		#endif
	End Sub

	Sub GridDataEx.CancelScrollTip()
		#ifdef __USE_WINAPI__
		If FScrollTipShown AndAlso FScrollTipHwnd <> 0 Then
			Dim As TOOLINFO TI
			TI.cbSize = SizeOf(TOOLINFO)
			TI.hWnd = Handle
			TI.uId = 0
			TI.lpszText = NULL
			SendMessage(Cast(HWND, FScrollTipHwnd), TTM_TRACKACTIVATE, 0, Cast(LPARAM, @TI))
			FScrollTipShown = False
		End If
		#endif
	End Sub

	Function GridDataEx.GetAreaLineWidth(ByVal bFixedArea As Boolean, ByVal bFrozenArea As Boolean) As Long
		Dim As Long W
		If bFixedArea Then
			W = FGridLineWidthFixed
			If W < 1 Then W = FGridLineWidth
		ElseIf bFrozenArea Then
			W = FGridLineWidthFrozen
			If W < 1 Then W = FGridLineWidthFixed
			If W < 1 Then W = FGridLineWidth
		Else
			W = FGridLineWidth
		End If
		Return Max(1, Min(8, W))
	End Function

	Function GridDataEx.DrawThickHLine(ByRef Cv As My.Sys.Drawing.Canvas, ByVal X1 As Long, ByVal X2 As Long, ByVal Y As Long, ByVal W As Long, ByVal Clr As Long) As Long
		For k As Long = 0 To W - 1
			Cv.Line(X1, Y + k, X2, Y + k, Clr)
		Next k
		Return 0
	End Function

	Function GridDataEx.DrawThickVLine(ByRef Cv As My.Sys.Drawing.Canvas, ByVal X As Long, ByVal Y1 As Long, ByVal Y2 As Long, ByVal W As Long, ByVal Clr As Long) As Long
		For k As Long = 0 To W - 1
			Cv.Line(X + k, Y1, X + k, Y2, Clr)
		Next k
		Return 0
	End Function

	Property GridDataEx.GridLineWidth As Long
		Return FGridLineWidth
	End Property

	Property GridDataEx.GridLineWidth(ByVal Value As Long)
		FGridLineWidth = Max(1, Min(8, Value))
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.GridLineWidthFixed As Long
		If FGridLineWidthFixed < 1 Then Return FGridLineWidth
		Return FGridLineWidthFixed
	End Property

	Property GridDataEx.GridLineWidthFixed(ByVal Value As Long)
		FGridLineWidthFixed = Max(1, Min(8, Value))
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.GridLineWidthFrozen As Long
		If FGridLineWidthFrozen < 1 Then Return GridLineWidthFixed
		Return FGridLineWidthFrozen
	End Property

	Property GridDataEx.GridLineWidthFrozen(ByVal Value As Long)
		FGridLineWidthFrozen = Max(1, Min(8, Value))
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.FocusRectWidth As Long
		Return FFocusRectWidth
	End Property

	Property GridDataEx.FocusRectWidth(ByVal Value As Long)
		FFocusRectWidth = Max(1, Min(8, Value))
		If FRedraw AndAlso Handle <> 0 Then RepaintGrid
	End Property

	Property GridDataEx.AlwaysAllowComboCues As Boolean
		Return FAlwaysAllowComboCues
	End Property

	Property GridDataEx.AlwaysAllowComboCues(ByVal Value As Boolean)
		FAlwaysAllowComboCues = Value
	End Property

	Property GridDataEx.ColCheckBoxesHitTestInvisible(ByVal aIndex As Long) As Boolean
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return False
		Return CBool((ColsArr(aIndex).State And FLEX_CLIS_CHECKBOXESHTI) <> 0)
	End Property

	Property GridDataEx.ColCheckBoxesHitTestInvisible(ByVal aIndex As Long, ByVal Value As Boolean)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		If Value Then
			ColsArr(aIndex).State Or= FLEX_CLIS_CHECKBOXESHTI
		Else
			ColsArr(aIndex).State And= Not FLEX_CLIS_CHECKBOXESHTI
		End If
	End Property

	Property GridDataEx.ColCheckBoxesHitTestInvisibleFixed(ByVal aIndex As Long) As Boolean
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Return False
		Return CBool((ColsArr(aIndex).State And FLEX_CLIS_CHECKBOXESHTIFIXED) <> 0)
	End Property

	Property GridDataEx.ColCheckBoxesHitTestInvisibleFixed(ByVal aIndex As Long, ByVal Value As Boolean)
		If aIndex < 0 OrElse aIndex > FCols - 1 Then Exit Property
		If Value Then
			ColsArr(aIndex).State Or= FLEX_CLIS_CHECKBOXESHTIFIXED
		Else
			ColsArr(aIndex).State And= Not FLEX_CLIS_CHECKBOXESHTIFIXED
		End If
	End Property

	Property GridDataEx.HwndEdit As Long
		'A handle is pointer-sized: route it through the pointer-wide integer
		'before narrowing (a direct Cast(Long, pointer) is a type mismatch on 64-bit)
		If FInEdit AndAlso EditText_ <> 0 Then Return Cast(Long, Cast(Integer, EditText_->Handle))
		Return 0
	End Property

	Property GridDataEx.ComboCalendarValue ByRef As WString
		'The calendar's selected date as YYYY-MM-DD (today when never opened).
		Dim As Long D = 0
		If ComboCalendar_ <> 0 Then D = ComboCalendar_->SelectedDate
		If D = 0 Then D = DateSerial(Year(Now), Month(Now), Day(Now))
		WLet(FTextTmp, Right("000" & Year(D), 4) & "-" & Right("0" & Month(D), 2) & "-" & Right("0" & Day(D), 2))
		If FTextTmp <> 0 Then Return *FTextTmp Else Return ""
	End Property
	
'Accepts YYYY-MM-DD, YYYY/MM/DD, M/D/YYYY (and an optional time tail).
	Function GridDataEx.ParseDateText(ByRef S As WString) As Double
		Dim As String T = Trim(S)
		If Len(T) < 6 Then Return 0
		Dim As String Sep = "-"
		Dim As Long P1 = InStr(T, Sep)
		If P1 = 0 Then Sep = "/" : P1 = InStr(T, Sep)
		If P1 = 0 Then Sep = "." : P1 = InStr(T, Sep)
		If P1 = 0 Then Return 0
		Dim As Long P2 = InStr(P1 + 1, T, Sep)
		If P2 = 0 Then Return 0
		Dim As Long N1 = Val(Mid(T, 1, P1 - 1))
		Dim As Long N2 = Val(Mid(T, P1 + 1, P2 - P1 - 1))
		Dim As String RestD = Mid(T, P2 + 1)
		Dim As Long Sp = InStr(RestD, " ")
		If Sp > 0 Then RestD = Mid(RestD, 1, Sp - 1)
		Dim As Long N3 = Val(RestD)
		Dim As Long YY, MM, DD
		If N1 > 99 Then
			YY = N1 : MM = N2 : DD = N3
		ElseIf N3 > 99 Then
			YY = N3 : MM = N1 : DD = N2
		Else
			YY = 2000 + N1 : MM = N2 : DD = N3
		End If
		Return DateSerial(YY, MM, DD)
	End Function

	Function GridDataEx.SaveArray(Arr() As WString Ptr, ByVal Order As Integer = FlexColumnMajor, ByVal MaxRows As Long = -1, ByVal MaxCols As Long = -1, ByVal StartRow As Long = -1, ByVal StartCol As Long = -1, ByVal ExcludeHidden As Boolean = False, ByVal OneDim As Boolean = False) As Boolean
		'Writes the range (or the whole grid) into a String array. FlexRowMajor
		'fills Arr(row, col); FlexColumnMajor fills Arr(col, row) like GetRows.
		Dim As Long r1 = Max(0, IIf(StartRow < 0, 0, StartRow))
		Dim As Long rn = IIf(MaxRows < 0, FRows - r1, MaxRows)
		Dim As Long r2 = min(FRows - 1, r1 + rn - 1)
		Dim As Long c1 = Max(0, IIf(StartCol < 0, 0, StartCol))
		Dim As Long cn = IIf(MaxCols < 0, FCols - c1, MaxCols)
		Dim As Long c2 = min(FCols - 1, c1 + cn - 1)
		If r2 < r1 OrElse c2 < c1 Then Return False
		Dim RowMap(Any) As Long, ColMap(Any) As Long
		Dim As Long NR = 0, NC = 0
		For i As Long = r1 To r2
			If ExcludeHidden = False OrElse (RowsArr(i).State And FLEX_RWIS_HIDDEN) = 0 Then
				ReDim Preserve RowMap(0 To IIf(NR = 0, 0, NR))
				'Build maps growing by one each pass.
				RowMap(IIf(NR = 0, 0, NR)) = i
				NR += 1
			End If
		Next i
		For j As Long = c1 To c2
			If ExcludeHidden = False OrElse (ColsArr(j).State And FLEX_CLIS_HIDDEN) = 0 Then
				ReDim Preserve ColMap(0 To IIf(NC = 0, 0, NC))
				ColMap(IIf(NC = 0, 0, NC)) = j
				NC += 1
			End If
		Next j
		If NR = 0 OrElse NC = 0 Then Return False
		If OneDim Then
			ReDim Arr(0 To NR * NC - 1)
		Else
			ReDim Arr(0 To NR - 1, 0 To NC - 1)
		End If
		For i As Long = 0 To NR - 1
			For j As Long = 0 To NC - 1
				If Order = FlexRowMajor Then
					If OneDim Then
						WLet(Arr(i * NC + j), CellTextRaw(RowMap(i), ColMap(j)))
					Else
						WLet(Arr(i, j), CellTextRaw(RowMap(i), ColMap(j)))
					End If
				Else
					If OneDim Then
						WLet(Arr(j * NR + i), CellTextRaw(RowMap(i), ColMap(j)))
					Else
						WLet(Arr(j, i), CellTextRaw(RowMap(i), ColMap(j)))
					End If
				End If
			Next j
		Next i
		Return True
	End Function

	Function GridDataEx.LoadArray(Arr() As WString Ptr, ByVal Order As Integer = FlexColumnMajor, ByVal StartRow As Long = -1, ByVal StartCol As Long = -1, ByVal RestrictRows As Boolean = False, ByVal RestrictCols As Boolean = False, ByVal OneDim As Boolean = False) As Boolean
		'Reads a String array into the grid starting at Row/Col (first
		'scrollable cell by default); grows the grid unless restricted.
		Dim As Long NR, NC
		If OneDim Then
			NR = UBound(Arr) - LBound(Arr) + 1
			NC = 1
		Else
			NR = UBound(Arr, 1) - LBound(Arr, 1) + 1
			NC = UBound(Arr, 2) - LBound(Arr, 2) + 1
		End If
		If NR < 1 OrElse NC < 1 Then Return False
		Dim As Long r1 = IIf(StartRow < 0, FFixedRows, StartRow)
		Dim As Long c1 = IIf(StartCol < 0, FFixedCols, StartCol)
		If RestrictRows = False AndAlso r1 + NR > FRows Then Rows = r1 + NR
		If RestrictCols = False AndAlso c1 + NC > FCols Then Cols = c1 + NC
		For i As Long = 0 To NR - 1
			If r1 + i > FRows - 1 Then Exit For
			For j As Long = 0 To NC - 1
				If c1 + j > FCols - 1 Then Exit For
				Dim As UString V
				If Order = FlexRowMajor Then
					If OneDim Then V = *Arr(LBound(Arr) + i) Else V = *Arr(LBound(Arr, 1) + i, LBound(Arr, 2) + j)
				Else
					If OneDim Then V = *Arr(LBound(Arr) + j) Else V = *Arr(LBound(Arr, 1) + j, LBound(Arr, 2) + i)
				End If
				TextMatrix(r1 + i, c1 + j, V)
			Next j
		Next i
		Return True
	End Function

	Sub GridDataEx.ParseClip(ByRef ClipText As WString, Arr() As WString Ptr)
		'Splits a clip string into a 2D array using the clip separators.
		Dim As UString RowSep = ClipSeparatorRow
		Dim As UString ColSep = ClipSeparatorCol
		Dim As Long nRows = 0, nCols = 1
		Dim As Long PosStart = 1
		Do
			Dim As UString LineChunk = Mid(ClipText, PosStart)
			Dim As Long SepPos = InStr(LineChunk, RowSep)
			Dim As UString LineText
			If SepPos > 0 Then LineText = Mid(LineChunk, 1, SepPos - 1) Else LineText = LineChunk
			nRows += 1
			Dim As Long FieldStart = 1, Fields = 1
			Do While FieldStart <= Len(LineText)
				Dim As Long TabPos = InStr(FieldStart, LineText, ColSep)
				If TabPos = 0 Then Exit Do
				Fields += 1
				FieldStart = TabPos + Len(ColSep)
			Loop
			If Fields > nCols Then nCols = Fields
			If SepPos = 0 Then Exit Do
			PosStart += SepPos + Len(RowSep) - 1
		Loop
		ReDim Arr(0 To nRows - 1, 0 To nCols - 1)
		Dim As Long RowCur = 0
		PosStart = 1
		Do
			Dim As UString LineChunk = Mid(ClipText, PosStart)
			Dim As Long SepPos = InStr(LineChunk, RowSep)
			Dim As UString LineText
			If SepPos > 0 Then LineText = Mid(LineChunk, 1, SepPos - 1) Else LineText = LineChunk
			Dim As Long ColCur = 0, FieldStart = 1
			Do While FieldStart <= Len(LineText) + 1
				Dim As Long TabPos = InStr(FieldStart, LineText, ColSep)
				If RowCur <= nRows - 1 AndAlso ColCur <= nCols - 1 Then 
					If TabPos > 0 Then WLet(Arr(RowCur, ColCur), Mid(LineText, FieldStart, TabPos - FieldStart)) Else WLet(Arr(RowCur, ColCur), Mid(LineText, FieldStart))
				End If
				ColCur += 1
				If TabPos = 0 Then Exit Do
				FieldStart = TabPos + Len(ColSep)
			Loop
			RowCur += 1
			If SepPos = 0 Then Exit Do
			PosStart += SepPos + Len(RowSep) - 1
		Loop
	End Sub

	Function GridDataEx.ConstructClip(Arr() As WString Ptr) ByRef As WString
		Dim As Integer Capacity
		WLet(FTextTmp, "")
		For i As Long = LBound(Arr, 1) To UBound(Arr, 1)
			If i > LBound(Arr, 1) Then WAdd(FTextTmp, ClipSeparatorRow, , Capacity)
			For j As Long = LBound(Arr, 2) To UBound(Arr, 2)
				If j > LBound(Arr, 2) Then WAdd(FTextTmp, ClipSeparatorCol, , Capacity)
				If Arr(i, j) <> 0 Then WAdd(FTextTmp, *Arr(i, j), , Capacity)
			Next j
		Next i
		If FTextTmp = 0 Then Return "" Else Return *FTextTmp
	End Function

	Function GridDataEx.FindTag(ByVal TagValue As Any Ptr, ByVal aRow As Long = -1, ByVal aCol As Long = -1, ByVal ExcludeHidden As Boolean = False, ByVal Wrap As Boolean = True, ByVal Direction As Integer = FlexFindDirectionDown) As Boolean
		'Finds the first cell whose CellTag equals the given pointer.
		Dim As Long i = IIf(aRow < 0, FFixedRows, aRow)
		Dim As Long j = IIf(aCol < 0, FFixedCols, aCol)
		Dim As Long Scanned = 0, TotalCells = (FRows - FFixedRows) * (FCols - FFixedCols)
		Do While Scanned <= TotalCells
			If i >= FFixedRows AndAlso j >= FFixedCols AndAlso i <= FRows - 1 AndAlso j <= FCols - 1 Then
				Scanned += 1
				Dim As Boolean VisOK = True
				If ExcludeHidden Then VisOK = IsRowVisible(i) AndAlso IsColVisible(j)
				If VisOK Then
					Dim As FlexCell Ptr C = CellAt(i, j)
					If C <> 0 AndAlso C->TagPtr = TagValue Then
						Row = i
						Col = j
						Return True
					End If
				End If
			End If
			j += 1
			If j > FCols - 1 Then
				If Wrap = False Then Return False
				j = FFixedCols
				i += 1
				If i > FRows - 1 Then
					i = FFixedRows
					If Scanned >= TotalCells Then Return False
				End If
			End If
			If Scanned > TotalCells Then Return False
		Loop
		Return False
	End Function

	Property GridDataEx.RowsNonHidden As Long
		Dim As Long i, Count = 0
		For i = 0 To FRows - 1
			If (RowsArr(i).State And FLEX_RWIS_HIDDEN) = 0 Then Count += 1
		Next i
		Return Count
	End Property

	Property GridDataEx.ColsNonHidden As Long
		Dim As Long j, Count = 0
		For j = 0 To FCols - 1
			If (ColsArr(j).State And FLEX_CLIS_HIDDEN) = 0 Then Count += 1
		Next j
		Return Count
	End Property

	Property GridDataEx.RowPositionFromNonHidden(ByVal NonHiddenIndex As Long) As Long
		'Maps a 0-based non-hidden position to the real row index (-1 if absent).
		Dim As Long i, Count = 0
		For i = 0 To FRows - 1
			If (RowsArr(i).State And FLEX_RWIS_HIDDEN) = 0 Then
				If Count = NonHiddenIndex Then Return i
				Count += 1
			End If
		Next i
		Return -1
	End Property

	Property GridDataEx.ColPositionFromNonHidden(ByVal NonHiddenIndex As Long) As Long
		Dim As Long j, Count = 0
		For j = 0 To FCols - 1
			If (ColsArr(j).State And FLEX_CLIS_HIDDEN) = 0 Then
				If Count = NonHiddenIndex Then Return j
				Count += 1
			End If
		Next j
		Return -1
	End Property

	Property GridDataEx.RowNonHiddenPosition(ByVal Index As Long) As Long
		If Index < 0 OrElse Index > FRows - 1 Then Return -1
		Dim As Long i, Count = 0
		For i = 0 To Index
			If (RowsArr(i).State And FLEX_RWIS_HIDDEN) = 0 Then Count += 1
		Next i
		If (RowsArr(Index).State And FLEX_RWIS_HIDDEN) <> 0 Then Return -1
		Return Count - 1
	End Property

	Property GridDataEx.ColNonHiddenPosition(ByVal Index As Long) As Long
		If Index < 0 OrElse Index > FCols - 1 Then Return -1
		Dim As Long j, Count = 0
		For j = 0 To Index
			If (ColsArr(j).State And FLEX_CLIS_HIDDEN) = 0 Then Count += 1
		Next j
		If (ColsArr(Index).State And FLEX_CLIS_HIDDEN) <> 0 Then Return -1
		Return Count - 1
	End Property

	Property GridDataEx.IncrementalSearchTime As Long
		Return FIncrSearchTime
	End Property

	Property GridDataEx.IncrementalSearchTime(ByVal Value As Long)
		FIncrSearchTime = Max(0, Value)
	End Property

	Property GridDataEx.Picture As Any Ptr
		'Renders the current view into a new HBITMAP; the caller deletes it.
		#ifndef __USE_WINAPI__
			Return 0
		#else
			If Handle = 0 Then Return 0
			Dim As Long W = ClientWidthPx(), H = ClientHeightPx()
			If W <= 0 OrElse H <= 0 Then Return 0
			Dim As HDC Dc = GetDC(Handle)
			Dim As HDC Mem = CreateCompatibleDC(Dc)
			Dim As HBITMAP Bmp = CreateCompatibleBitmap(Dc, W, H)
			Dim As HGDIOBJ OldSel = SelectObject(Mem, Cast(HGDIOBJ, Bmp))
			Canvas.SetHandle(Mem)
			UsePhysicalCanvas
			DrawGridArea(Canvas, 0, 0, W, H)
			Canvas.UnSetHandle
			SelectObject(Mem, OldSel)
			DeleteDC(Mem)
			ReleaseDC(Handle, Dc)
			Return Cast(Any Ptr, Bmp)
		#endif
	End Property

	Sub GridDataEx.PrintToClipboard()
		#ifdef __USE_WINAPI__
			Dim As Any Ptr Bmp = Picture
			If Bmp = 0 Then Exit Sub
			If OpenClipboard(Handle) <> 0 Then
				EmptyClipboard()
				SetClipboardData(CF_BITMAP, Bmp)
				CloseClipboard()
			Else
				DeleteObject(Cast(HGDIOBJ, Bmp))
			End If
		#endif
	End Sub

End Namespace