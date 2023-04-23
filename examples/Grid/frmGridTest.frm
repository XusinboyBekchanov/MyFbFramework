'#Region "Form"
	#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
		#define __MAIN_FILE__
		#ifdef __FB_WIN32__
			#ifdef __FB_64BIT__
				#cmdline "-gen gas64"
			#endif
			#cmdline "Form1.rc"
		#endif
		Const _MAIN_FILE_ = __FILE__
	#endif
	#include once "mff/Form.bi"
	#include once "mff/Grid.bi"
	#include once "mff/CommandButton.bi"
	#include once "mff/Label.bi"
	Using My.Sys.Forms
	/'test comment '/
	Type Form1Type Extends Form
		Declare Static Sub _cmdRowInsert_Click(ByRef Sender As Control)
		Declare Sub cmdRowInsert_Click(ByRef Sender As Control)
		Declare Static Sub _cmdRowDele_Click(ByRef Sender As Control)
		Declare Sub cmdRowDele_Click(ByRef Sender As Control)
		Declare Static Sub _cmdColInsert_Click(ByRef Sender As Control)
		Declare Sub cmdColInsert_Click(ByRef Sender As Control)
		Declare Static Sub _cmdColDele_Click(ByRef Sender As Control)
		Declare Sub cmdColDele_Click(ByRef Sender As Control)
		Declare Static Sub _cmdColInsertAf_Click(ByRef Sender As Control)
		Declare Sub cmdColInsertAf_Click(ByRef Sender As Control)
		Declare Static Sub _cmdRowInsertAfter_Click(ByRef Sender As Control)
		Declare Sub cmdRowInsertAfter_Click(ByRef Sender As Control)
		Declare Static Sub _cmdBigData_Click(ByRef Sender As Control)
		Declare Sub cmdBigData_Click(ByRef Sender As Control)
		Declare Static Sub _Grid1_GetDispInfo(ByRef Sender As Grid, ByRef NewText As WString, ByVal RowIndex As Integer, ByVal ColumnIndex As Integer, iMask As UINT)
		Declare Sub Grid1_GetDispInfo(ByRef Sender As Grid, ByRef NewText As WString, ByVal RowIndex As Integer, ByVal ColumnIndex As Integer, iMask As UINT)
		Declare Static Sub _Grid1_CacheHint(ByRef Sender As Grid, ByVal iFrom As Integer, ByVal iTo As Integer)
		Declare Sub Grid1_CacheHint(ByRef Sender As Grid, ByVal iFrom As Integer, ByVal iTo As Integer)
		Declare Constructor
		
		Dim As Grid Grid1
		Dim As CommandButton cmdRowInsert, cmdColInsert, cmdRowDele, cmdColDele, cmdColInsertAfter, cmdRowInsertAfter, cmdBigData
		Dim As Label Label1
		
	End Type
	
	Constructor Form1Type
		' Form1
		With This
			.Name = "Form1"
			.Text = "Form1"
			.Designer = @This
			.SetBounds 0, 0, 640, 300
		End With
		' Grid1
		With Grid1
			.Name = "Grid1"
			.Text = "Grid1"
			'.TabIndex = 0
			.Hint = "Double Click or press space start edit, Enter Confirm input!"
			.Anchor.Right = AnchorStyle.asAnchor
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Left = AnchorStyle.asAnchor
			.SetBounds 10, 30, 610, 230
			.Columns.Add "NO.", , 30
			.Columns.Add "Column 1", , 100, cfRight, , clRed, clBlue
			.Columns.Add "Column 2", , 100, cfRight, True, clYellow, clRed
			.Columns.Add "Column 3", , 100, cfRight, , clBlue, clYellow
			.Columns.Add "Column 4", , 100, cfRight, , clGreen, clBlue
			.Columns.Add "Column 5", , 100, cfRight, True, clPurple, clGreen
			.Columns[1].Tag = @"0"
			
			For i As Integer = 0 To 3  '返回的代码: 3221225477 - 堆栈溢出 就是行不够
				.Rows.Add Str(i + 1)
			Next
			Grid1.RowsCount = 50
			'Control's Name
			Grid1[0][1].Text = "Row 1 Column 1"
			Grid1[1][1].Text = "Row 2 Column 1"
			Grid1[2][1].Text = "Row 3 Column 1"
			Grid1[3][1].Text = "Row 4 Column 1"
			Grid1[0][1].Editable = True
			
			'Like Array
			.Rows[0][2].Text = "Row1ColC2 AllowEdit"
			.Rows[1][2].Text = "Row2ColC2 AllowEdit"
			.Rows[2][2].Text = "Row3ColC2 AllowEdit"
			.Rows[3][2].Text = "Row4ColC2 AllowEdit"
			For i As Integer = 0 To 3
				.Rows[i][2].Editable = True
			Next
			'Cell Like Excel
			.Cells(0, 3)->Text = "Row 1 Column 3"
			.Cells(1, 3)->Text = "Row 2 Column 3"
			.Cells(2, 3)->Text = "Row 3 Column 3"
			.Cells(3, 3)->Text = "Row 4 Column 3"
			.Cells(2, 3)->Editable = True
			.Cells(2, 3)->BackColor = clGreen
			.Rows[0][5].Text = "Row1Col5 AllowEdit"
			.Rows[1][5].Text = "Row2Col5 AllowEdit"
			.Rows[2][5].Text = "Row3Col5 AllowEdit"
			.Rows[3][5].Text = "Row4Col5 AllowEdit"
			.Rows[3].Tag = @"3"
			.SelectedRowIndex = 0
			.Designer = @This
			.Parent = @This
		End With
		' cmdRowInsert
		With cmdRowInsert
			.Name = "cmdRowInsert"
			.Text = "Insert Row before"
			.TabIndex = 0
			.SetBounds 10, 4, 85, 20
			.Designer = @This
			.OnClick = @_cmdRowInsert_Click
			.Parent = @This
		End With
		' cmdColInsert
		With cmdColInsert
			.Name = "cmdColInsert"
			.Text = "Insert Col before"
			.TabIndex = 2
			.ControlIndex = 1
			.SetBounds 250, 4, 85, 20
			.Designer = @This
			.OnClick = @_cmdColInsert_Click
			.Parent = @This
		End With
		' cmdRowDele
		With cmdRowDele
			.Name = "cmdRowDele"
			.Text = "Dele one Row"
			.TabIndex = 3
			.ControlIndex = 2
			.SetBounds 180, 4, 65, 20
			.Designer = @This
			.OnClick = @_cmdRowDele_Click
			.Parent = @This
		End With
		' cmdColDele
		With cmdColDele
			.Name = "cmdColDele"
			.Text = "Dele one Col"
			.TabIndex = 4
			.ControlIndex = 2
			.SetBounds 420, 4, 65, 20
			.Designer = @This
			.OnClick = @_cmdColDele_Click
			.Parent = @This
		End With
		' Grid1
		With Grid1
			.Name = "Grid1"
			.Text = "Grid1"
			.Anchor.Bottom = AnchorStyle.asAnchor
			.SetBounds 10, 30, 610, 230
			.Designer = @This
			.OnGetDispInfo = @_Grid1_GetDispInfo
			.OnCacheHint = @_Grid1_CacheHint
			.Parent = @This
		End With
		' Label1
		With Label1
			.Name = "Label1"
			.Text = "Double Click or press space start edit, Enter Confirm input!"
			.TabIndex = 6
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Right = AnchorStyle.asAnchor
			.BackColor = 65535
			.SetBounds 520, 0, 100, 28
			.Designer = @This
			.Parent = @This
		End With
		' ="cmdColInsertAf
		With cmdColInsertAfter
			.Name = "cmdColInsertAfter"
			.Text = "Insert Col after"
			.TabIndex = 7
			.SetBounds 340, 4, 75, 20
			.Designer = @This
			.OnClick = @_cmdColInsertAf_Click
			.Parent = @This
		End With
		' ="cmdRowInsertAfter
		With cmdRowInsertAfter
			.Name = "cmdRowInsertAfter"
			.Text = "Insert Row After"
			.TabIndex = 8
			.SetBounds 100, 4, 75, 20
			.Designer = @This
			.OnClick = @_cmdRowInsertAfter_Click
			.Parent = @This
		End With
		' cmdBigData
		With cmdBigData
			.Name = "cmdBigData"
			.Text = "大数据"
			.TabIndex = 9
			.SetBounds 490, 0, 30, 20
			.Designer = @This
			.OnClick = @_cmdBigData_Click
			.Parent = @This
		End With
	End Constructor
	
	Private Sub Form1Type._Grid1_CacheHint(ByRef Sender As Grid, ByVal iFrom As Integer, ByVal iTo As Integer)
		(*Cast(Form1Type Ptr, Sender.Designer)).Grid1_CacheHint(Sender, iFrom, iTo)
	End Sub
	
	Private Sub Form1Type._Grid1_GetDispInfo(ByRef Sender As Grid, ByRef NewText As WString, ByVal RowIndex As Integer, ByVal ColumnIndex As Integer, iMask As UINT)
		(*Cast(Form1Type Ptr, Sender.Designer)).Grid1_GetDispInfo(Sender, NewText, RowIndex, ColumnIndex, iMask)
	End Sub
	
	Private Sub Form1Type._cmdBigData_Click(ByRef Sender As Control)
		(*Cast(Form1Type Ptr, Sender.Designer)).cmdBigData_Click(Sender)
	End Sub
	
	Private Sub Form1Type._cmdRowInsertAfter_Click(ByRef Sender As Control)
		(*Cast(Form1Type Ptr, Sender.Designer)).cmdRowInsertAfter_Click(Sender)
	End Sub
	
	Private Sub Form1Type._cmdColInsertAf_Click(ByRef Sender As Control)
		(*Cast(Form1Type Ptr, Sender.Designer)).cmdColInsertAf_Click(Sender)
	End Sub
	
	Private Sub Form1Type._cmdColDele_Click(ByRef Sender As Control)
		(*Cast(Form1Type Ptr, Sender.Designer)).cmdColDele_Click(Sender)
	End Sub
	
	Private Sub Form1Type._cmdColInsert_Click(ByRef Sender As Control)
		(*Cast(Form1Type Ptr, Sender.Designer)).cmdColInsert_Click(Sender)
	End Sub
	
	Private Sub Form1Type._cmdRowDele_Click(ByRef Sender As Control)
		(*Cast(Form1Type Ptr, Sender.Designer)).cmdRowDele_Click(Sender)
	End Sub
	
	Private Sub Form1Type._cmdRowInsert_Click(ByRef Sender As Control)
		(*Cast(Form1Type Ptr, Sender.Designer)).cmdRowInsert_Click(Sender)
	End Sub
	
	Dim Shared Form1 As Form1Type
	
	#if _MAIN_FILE_ = __FILE__
		App.DarkMode = True
		Form1.MainForm = True
		Form1.Show
		App.Run
	#endif
'#End Region

Private Sub Form1Type.cmdRowInsert_Click(ByRef Sender As Control)
	Dim As Integer Curr = Grid1.SelectedRowIndex
	'Print "CurrRow=" &  Curr
	Grid1.Rows.Insert(Curr, Str(Curr), , , , True)
	Grid1.Repaint
End Sub

Private Sub Form1Type.cmdRowDele_Click(ByRef Sender As Control)
	Dim As Integer Curr = Grid1.SelectedRowIndex
	'Print "CurrRow=" &  Curr
	Grid1.Rows.Remove(Curr)
	Grid1.Repaint
End Sub

Private Sub Form1Type.cmdColInsert_Click(ByRef Sender As Control)
	Dim As Integer Curr = Grid1.SelectedColumnIndex
	'Print "CurrCol=" &  Curr
	Grid1.Columns.Insert(Curr, "Column " & Curr, , 100, cfRight, , True, clBlue, clGreen)
	Grid1.Repaint
End Sub

Private Sub Form1Type.cmdColDele_Click(ByRef Sender As Control)
	Dim As Integer Curr = Grid1.SelectedColumnIndex
	'Print "CurrCol=" &  Curr
	Grid1.Columns.Remove(Curr)
End Sub

Private Sub Form1Type.cmdColInsertAf_Click(ByRef Sender As Control)
	Dim As Integer Curr = Grid1.SelectedColumnIndex
	Grid1.Columns.Insert(Curr, "Column " & Curr, , 100, cfRight, False, True, clYellow, clRed)
End Sub

Private Sub Form1Type.cmdRowInsertAfter_Click(ByRef Sender As Control)
	Dim As Integer Curr = Grid1.SelectedRowIndex
	Grid1.Rows.Insert(Curr, Str(Curr), , , , False, False)
	Grid1.Repaint
End Sub

Private Sub Form1Type.cmdBigData_Click(ByRef Sender As Control)
	Grid1.SetFocus
	Dim As Double StartShow = Timer
	Dim As WString * 255 RowStr
	'For i As Integer = Grid1.Rows.Count - 1 To 0 Step -1  'Need at least one row for refresh the grid
	'	Grid1.Rows.Remove(i)
	'Next
	Grid1.RowsCount = 2001
	
	Grid1.SelectedRowIndex = 0 'Grid1.Rows.Count - 1
	
	' This is take too long. 花费太多时间赋值。建议使用CacheHint赋值
	'For iRow As Long = 0 To 20000
	'	'If iRow = 100 Then Grid1.SetFocus: Grid1.Repaint: Grid1.SelectedRowIndex = 0
	'	RowStr = Str(iRow + 1)
	'	For iCol As Integer = 1 To Grid1.Columns.Count - 1
	'		RowStr += Chr(9) + "行" + Str(iRow+1) + "列" + Str(iCol)
	'	Next
	'	'Add the Data
	'	Grid1.Rows.Add RowStr, , , , , True
	'	'Grid1.Rows.Add RowStr
	'	If iRow Mod 10 = 0 Then App.DoEvents  'if rows.count=666666  :254.144s   1 Million: 364.829s    5 Million:512.616s
	'Next
	Debug.Print " Elasped time: " & Str(Int((Timer - StartShow) * 1000 + 0.5) / 1000) & "s. with Data " & (Grid1.Rows.Count - 1) * (Grid1.Columns.Count - 1)
	'MsgBox " Elasped time: " & Str(Int((Timer - StartShow) * 1000 + 0.5) / 1000)  & "s. with Data " & (Grid1.Rows.Count - 1) * (Grid1.Columns.Count - 1)
End Sub

Private Sub Form1Type.Grid1_GetDispInfo(ByRef Sender As Grid, ByRef NewText As WString, ByVal RowIndex As Integer, ByVal ColumnIndex As Integer, iMask As UINT)
	'This sub send the data to control and overwrite the data in grid 将覆盖表格中原来的数据
	Select Case iMask
	Case LVIF_TEXT
		'NewText = IIf(ColumnIndex = 0, WStr(RowIndex), "行" + Str(RowIndex) + "列" + Str(ColumnIndex))
		'Print "NewText GetDispInfo " = NewText
	Case LVIF_IMAGE
		NewText = "1"
	Case LVIF_INDENT
		NewText = WStr(ColumnIndex)
	Case LVIF_PARAM
	Case LVIF_STATE
	End Select
		
	End Sub
	
	Private Sub Form1Type.Grid1_CacheHint(ByRef Sender As Grid, ByVal iFrom As Integer, ByVal iTo As Integer)
		'upload the data to grid here also
		Debug.Print " iFrom=" & iFrom  & " iTo=" & iTo
		For iRow As Integer = iFrom To iTo
			For iCol As Integer = 1 To Grid1.Columns.Count - 1
				Grid1.Cells(iRow, iCol)->Text = "行" + Str(iRow + 1) + "列" + Str(iCol)
			Next
		Next
	End Sub
