'#Region "Form"
	#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
		#define __MAIN_FILE__
		#ifdef __FB_WIN32__
			#cmdline "Form1.rc" '
		#endif
		Const _MAIN_FILE_ = __FILE__
	#endif
	#include once "mff/Form.bi"
	#include once "mff/Panel.bi"
	#include once "mff/CommandButton.bi"
	#include once "mff/Label.bi"
	#include once "mff/GridDataEx.bi"

	Using My.Sys.Forms

	'Feature demo (batch 2): 22 columns x 500 data rows. Flood fills, check
	'boxes, combo cue columns, banding, merge, frozen panes, resizing, undo.
    Dim Shared As Boolean DataReady 
	Type Form1Type Extends Form
		Dim As GridDataEx GridData1
		Dim As CommandButton cmdSort, cmdCheck, cmdUndo, cmdRedo, cmdCopy, cmdPaste, cmdAutoSize, cmdAltColor, cmdMerge, cmdFrozen
		Dim As Panel Panel1
		Dim As Label lblInfo
		Dim As Integer AltMode = 0
		Declare Sub cmdSort_Click(ByRef Sender As Control)
		Declare Sub cmdCheck_Click(ByRef Sender As Control)
		Declare Sub cmdUndo_Click(ByRef Sender As Control)
		Declare Sub cmdRedo_Click(ByRef Sender As Control)
		Declare Sub cmdCopy_Click(ByRef Sender As Control)
		Declare Sub cmdPaste_Click(ByRef Sender As Control)
		Declare Sub cmdAutoSize_Click(ByRef Sender As Control)
		Declare Sub cmdAltColor_Click(ByRef Sender As Control)
		Declare Sub cmdMerge_Click(ByRef Sender As Control)
		Declare Sub cmdFrozen_Click(ByRef Sender As Control)
		Declare Sub grid_CellClick(ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByVal Button As Integer)
		Declare Sub grid_CellCheck(ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long)
		Declare Sub grid_BeforeEdit(ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByVal Reason As Integer, ByRef Cancel As Boolean)
		Declare Sub grid_AfterEdit(ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByRef NewText As WString)
		Declare Sub grid_RowColChange(ByRef Sender As GridDataEx)
		Declare Sub grid_EnterCell(ByRef Sender As GridDataEx)
		Declare Sub grid_BeforeUserResize(ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByRef Cancel As Boolean)
		Declare Sub grid_AfterUserResize(ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByVal NewSize As Long)
		Declare Sub grid_KeyDown(ByRef Sender As GridDataEx, ByRef KeyCode As Integer, ByVal Shift As Integer)
		Declare Constructor
	End Type

	Constructor Form1Type
		' Form1
		With This
			.Name = "Form1"
			.Text = "GridDataEx FreeBASIC - feature demo (batch 2)"
			.Designer = @This
			.SetBounds 0, 0, 1000, 580
		End With
		
		' GridData1
		With GridData1
			.Name = "GridData1"
			.Designer = @This
			.SetBounds 8, 8, 970, 520
			.Anchor.Top = AnchorStyle.asAnchorProportional
			.Anchor.Right = AnchorStyle.asAnchorProportional
			.Anchor.Left = AnchorStyle.asAnchorProportional
			.Anchor.Bottom = AnchorStyle.asAnchorProportional
			.Rows = 501
			.Cols = 22
			.FixedRows = 1
			.FixedCols = 1
			.FrozenRows = 0
			.FrozenCols = 0
			.GridLines = GridDataLineFlat
			.GridLinesFixed = GridDataLineInset
			.GridColorFixed = &HC0C0C0
			.BackColorAlt = &HF2EBDD
			.AllowUserResizing = FlexAllowUserResizingBoth
			.AllowUserEditing = True
			.AllowBigSelection = True
			.AllowMultiSelection = True
			.TabBehavior = FlexTabCells
			.DirectionAfterReturn = FlexDirectionAfterReturnDown
			.ScrollBars = 3
			.OnCellClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByVal Button As Integer), @grid_CellClick)
			.OnCellCheck = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long), @grid_CellCheck)
			.OnBeforeEdit = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByVal Reason As Integer, ByRef Cancel As Boolean), @grid_BeforeEdit)
			.OnAfterEdit = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByRef NewText As WString), @grid_AfterEdit)
			.OnRowColChange = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx), @grid_RowColChange)
			.OnEnterCell = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx), @grid_EnterCell)
			.OnBeforeUserResize = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByRef Cancel As Boolean), @grid_BeforeUserResize)
			.OnAfterUserResize = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByVal NewSize As Long), @grid_AfterUserResize)
			.OnKeyDown = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByRef KeyCode As Integer, ByVal Shift As Integer), @grid_KeyDown)
			.Parent = @This
		End With
		'Header row + sort arrows.
		GridData1.TextMatrix(0, 0, "#")
		GridData1.TextMatrix(0, 1, "Product")
		GridData1.TextMatrix(0, 2, "Qty")
		GridData1.TextMatrix(0, 3, "Price")
		GridData1.TextMatrix(0, 4, "Stock")
		GridData1.TextMatrix(0, 5, "Note")
		GridData1.TextMatrix(0, 6, "Category")
		GridData1.TextMatrix(0, 7, "Region")
		GridData1.TextMatrix(0, 8, "Supplier")
		GridData1.TextMatrix(0, 9, "Weight")
		GridData1.TextMatrix(0, 10, "Color")
		GridData1.TextMatrix(0, 11, "Size")
		GridData1.TextMatrix(0, 12, "Rating")
		GridData1.TextMatrix(0, 13, "Code")
		GridData1.TextMatrix(0, 14, "Discount")
		GridData1.TextMatrix(0, 15, "Total")
		GridData1.TextMatrix(0, 16, "Status")
		GridData1.TextMatrix(0, 17, "Date")
		GridData1.TextMatrix(0, 18, "Tag")
		GridData1.TextMatrix(0, 19, "Memo")
		GridData1.TextMatrix(0, 20, "Flag")
		GridData1.TextMatrix(0, 21, "Extra")
		GridData1.ColKey(1) = "Product"
		GridData1.ColKey(2) = "Qty"
		GridData1.ColAlignment(2) = FlexAlignmentRightCenter
		GridData1.ColAlignment(3) = FlexAlignmentRightCenter
		GridData1.ColAlignment(4) = FlexAlignmentCenterCenter
		GridData1.ColAlignment(9) = FlexAlignmentRightCenter
		GridData1.ColAlignment(12) = FlexAlignmentCenterCenter
		GridData1.ColAlignment(14) = FlexAlignmentRightCenter
		GridData1.ColAlignment(15) = FlexAlignmentRightCenter
		GridData1.ColAlignment(17) = FlexAlignmentCenterCenter
		GridData1.ColCheckBoxes(4) = True
		GridData1.ColCheckBoxes(12) = True
		GridData1.ColComboCue(5) = FlexComboCueDropDown
		GridData1.ColComboCue(6) = FlexComboCueDropDown
		GridData1.ColSortArrow(2) = FlexSortArrowAscending
		GridData1.FixedAlignment(2) = FlexAlignmentRightCenter
		GridData1.FixedAlignment(4) = FlexAlignmentCenterCenter
		GridData1.FixedAlignment(12) = FlexAlignmentCenterCenter
		GridData1.ColWidth(1) = 2400
		GridData1.ColWidth(5) = 2200
		GridData1.ColWidth(19) = 2600
		'Data rows: 500 x 22. Flood percent in col 3, checked states in cols
		'4/12, group texts for the merge demo in cols 5/6/7.
		Dim As String Cats(5) = {"Widget", "Gadget", "Sprocket", "Flange", "Bracket", "Gasket"}
		Dim As String ColorNames(5) = {"Red", "Green", "Blue", "Black", "White", "Silver"}
		Dim As String Statuses(3) = {"Open", "Hold", "Done", "Sent"}
		Dim i As Integer
		For i = 1 To 500
			GridData1.TextMatrix(i, 0, Str(i))
			GridData1.TextMatrix(i, 1, "Item " & Chr(64 + (i Mod 8) + 1) & "-" & i)
			GridData1.TextMatrix(i, 2, Str((i * 7) Mod 100))
			GridData1.CellBackColorAt(i, 3, -1)
			GridData1.Row = i : GridData1.Col = 3
			GridData1.CellFloodPercent = (i * 13) Mod 105
			GridData1.CellFloodColor = &H4488FF
			GridData1.TextMatrix(i, 3, Str(Fix(i * 137) / 100.0))
			GridData1.Col = 4
			GridData1.CellChecked = IIf(i Mod 3 = 0, FlexChecked, IIf(i Mod 7 = 0, FlexGrayed, FlexUnchecked))
			GridData1.TextMatrix(i, 5, "pick " & (i Mod 10))
			GridData1.TextMatrix(i, 6, Cats(i Mod 6))
			GridData1.TextMatrix(i, 7, "Region " & (i Mod 8 + 1))
			GridData1.TextMatrix(i, 8, "Supp " & (i Mod 12 + 1))
			GridData1.TextMatrix(i, 9, Str(Fix((i * 31 Mod 4000) / 100.0)))
			GridData1.TextMatrix(i, 10, ColorNames(i Mod 6))
			GridData1.TextMatrix(i, 11, Str(20 + (i Mod 15)))
			GridData1.Col = 12
			GridData1.CellChecked = IIf(i Mod 4 = 0, FlexChecked, FlexUnchecked)
			GridData1.TextMatrix(i, 13, "C" & Right("0000" & Str(i * 3), 5))
			GridData1.TextMatrix(i, 14, Str(i Mod 25) & "%")
			GridData1.TextMatrix(i, 15, Str(Fix(i * 13.7)))
			GridData1.TextMatrix(i, 16, Statuses(i Mod 4))
			GridData1.TextMatrix(i, 17, "2026-" & Right("0" & Str(i Mod 12 + 1), 2) & "-" & Right("0" & Str(i Mod 28 + 1), 2))
			GridData1.TextMatrix(i, 18, "T" & (i Mod 16 + 1))
			GridData1.TextMatrix(i, 19, "Memo " & i & " col 19")
			GridData1.TextMatrix(i, 20, IIf(i Mod 2 = 0, "A", "B"))
			GridData1.TextMatrix(i, 21, "Extra " & i)
		Next i
		'Merge demo on Note column header cells.
		GridData1.MergeCells = FlexMergeCellsRestrictColumns
		GridData1.MergeCol(5) = True
		GridData1.Row = 1
		GridData1.Col = 1
		DataReady = True 
		With Panel1
			.Name = "Panel1"
			.Text = "Panel1"
			.SetBounds 8, 520, 970, 42
			.Anchor.Top = AnchorStyle.asAnchorProportional
			.Anchor.Right = AnchorStyle.asAnchorProportional
			.Anchor.Left = AnchorStyle.asAnchorProportional
			'.Anchor.Bottom = AnchorStyle.asAnchorProportional
			.Designer = @This
			.Parent = @This
		End With
		
		'Buttons.
		With cmdSort
			.Name = "cmdSort" : .Text = "Sort by Qty" : .Designer = @This
			.SetBounds 8, 2, 90, 24
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdSort_Click)
			.Parent = @Panel1
		End With
		With cmdCheck
			.Name = "cmdCheck" : .Text = "Check all" : .Designer = @This
			.SetBounds 102, 2, 90, 24
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdCheck_Click)
			.Parent = @Panel1
		End With
		With cmdUndo
			.Name = "cmdUndo" : .Text = "Undo" : .Designer = @This
			.SetBounds 196, 2, 60, 24
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdUndo_Click)
			.Parent = @Panel1
		End With
		With cmdRedo
			.Name = "cmdRedo" : .Text = "Redo" : .Designer = @This
			.SetBounds 260, 2, 60, 24
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdRedo_Click)
			.Parent = @Panel1
		End With
		With cmdCopy
			.Name = "cmdCopy" : .Text = "Copy" : .Designer = @This
			.SetBounds 324, 2, 60, 24
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdCopy_Click)
			.Parent = @Panel1
		End With
		With cmdPaste
			.Name = "cmdPaste" : .Text = "Paste" : .Designer = @This
			.SetBounds 388, 2, 60, 24
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdPaste_Click)
			.Parent = @Panel1
		End With
		With cmdAutoSize
			.Name = "cmdAutoSize" : .Text = "Auto fit" : .Designer = @This
			.SetBounds 452, 2, 70, 24
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdAutoSize_Click)
			.Parent = @Panel1
		End With
		With cmdAltColor
			.Name = "cmdAltColor" : .Text = "Banding" : .Designer = @This
			.SetBounds 526, 2, 70, 24
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdAltColor_Click)
			.Parent = @Panel1
		End With
		With cmdMerge
			.Name = "cmdMerge" : .Text = "Merge off" : .Designer = @This
			.SetBounds 600, 2, 75, 24
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdMerge_Click)
			.Parent = @Panel1
		End With
		With cmdFrozen
			.Name = "cmdFrozen" : .Text = "Freeze 2" : .Designer = @This
			.SetBounds 679, 2, 75, 24
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdFrozen_Click)
			.Parent = @Panel1
		End With
		' Info label
		With lblInfo
			.Name = "lblInfo" 
			.Text = "Cell: -,  -    SelectedRows: 0    F2/double-click/type to edit; Ctrl+click toggles row select" 
			.AutoSize = True 
			.SetBounds 750, 2, 400, 30
			.Designer = @This
			.Parent = @Panel1
		End With
	End Constructor

	Sub Form1Type.cmdSort_Click(ByRef Sender As Control)
		GridData1.Sort 2, FlexSortNumericAscending
		GridData1.ColSortArrow(2) = FlexSortArrowAscending
		GridData1.ColSortArrow(1) = FlexSortArrowNone
	End Sub

	Sub Form1Type.cmdCheck_Click(ByRef Sender As Control)
		Dim i As Integer
		For i = 1 To GridData1.Rows - 1
			GridData1.CellBackColorAt(i, 4, -1)
			GridData1.Row = i : GridData1.Col = 4
			GridData1.CellChecked = FlexChecked
		Next i
	End Sub

	Sub Form1Type.cmdUndo_Click(ByRef Sender As Control)
		GridData1.Undo
	End Sub

	Sub Form1Type.cmdRedo_Click(ByRef Sender As Control)
		GridData1.Redo
	End Sub

	Sub Form1Type.cmdCopy_Click(ByRef Sender As Control)
		GridData1.Copy
		Debug.Print "Copied: " & GridData1.Clip
	End Sub

	Sub Form1Type.cmdPaste_Click(ByRef Sender As Control)
		GridData1.Paste
	End Sub

	Sub Form1Type.cmdAutoSize_Click(ByRef Sender As Control)
		GridData1.AutoSize 0, GridData1.Cols - 1, FlexAutoSizeModeColWidth, FlexAutoSizeScopeAll, False, 2
	End Sub

	Sub Form1Type.cmdAltColor_Click(ByRef Sender As Control)
		AltMode = (AltMode + 1) Mod 3
		Select Case AltMode
			Case 0 : GridData1.BackColorAlt = &HF2EBDD
			Case 1 : GridData1.BackColorAlt = &HE8F2E0
			Case 2 : GridData1.BackColorAlt = -1
		End Select
	End Sub

	Sub Form1Type.cmdMerge_Click(ByRef Sender As Control)
		If GridData1.MergeCells = FlexMergeCellsNever Then
			GridData1.MergeCells = FlexMergeCellsRestrictColumns
			Sender.Text = "Merge off"
		Else
			GridData1.MergeCells = FlexMergeCellsNever
			Sender.Text = "Merge on"
		End If
	End Sub

	Sub Form1Type.cmdFrozen_Click(ByRef Sender As Control)
		If GridData1.FrozenCols = 0 Then
			GridData1.FrozenCols = 2
			GridData1.FrozenRows = 1
			GridData1.GridColorFrozen = &H4040B0
			Sender.Text = "Unfreeze"
		Else
			GridData1.FrozenCols = 0
			GridData1.FrozenRows = 0
			Sender.Text = "Freeze 2"
		End If
	End Sub

	Sub Form1Type.grid_CellClick(ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByVal Button As Integer)
		Debug.Print "CellClick " & Row & "," & Col
	End Sub

	Sub Form1Type.grid_CellCheck(ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long)
		Debug.Print "CellCheck " & Row & "," & Col & " = " & Sender.CellChecked
	End Sub

	Sub Form1Type.grid_BeforeEdit(ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByVal Reason As Integer, ByRef Cancel As Boolean)
		'Column 0 (index column) stays read-only.
		If Col = 0 Then Cancel = True
		Debug.Print "BeforeEdit " & Row & "," & Col & " reason=" & Reason
	End Sub

	Sub Form1Type.grid_AfterEdit(ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByRef NewText As WString)
		Debug.Print "AfterEdit " & Row & "," & Col & " -> " & NewText
	End Sub

	Sub Form1Type.grid_RowColChange(ByRef Sender As GridDataEx)
		lblInfo.Text = "Cell: " & Sender.Row & ", " & Sender.Col & "    SelectedRows: " & Sender.SelectedRows & "    Version: " & Sender.Version
	End Sub

	Sub Form1Type.grid_EnterCell(ByRef Sender As GridDataEx)
		If DataReady Then Debug.Print "EnterCell " & Sender.Row & "," & Sender.Col
	End Sub

	Sub Form1Type.grid_BeforeUserResize(ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByRef Cancel As Boolean)
		Debug.Print "BeforeUserResize row=" & Row & " col=" & Col
	End Sub

	Sub Form1Type.grid_AfterUserResize(ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByVal NewSize As Long)
		Debug.Print "AfterUserResize row=" & Row & " col=" & Col & " newSize=" & NewSize
	End Sub

	Sub Form1Type.grid_KeyDown(ByRef Sender As GridDataEx, ByRef KeyCode As Integer, ByVal Shift As Integer)
		Debug.Print "KeyDown code=" & KeyCode & " shift=" & Shift
	End Sub

	Dim Shared Form1 As Form1Type

	#if _MAIN_FILE_ = __FILE__
		App.DarkMode = True
		Form1.MainForm = True
		Form1.Show
		App.Run
	#endif
'#End Region