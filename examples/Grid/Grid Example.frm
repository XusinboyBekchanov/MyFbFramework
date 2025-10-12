'#Region "Form"
	#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
		#define __MAIN_FILE__
		#ifdef __FB_WIN32__
			#cmdline "Form1.rc"
		#endif
		#ifdef __FB_64BIT__
			#cmdline "-gen gas64"
		#endif
		#define __USE_GTK3__
		Const _MAIN_FILE_ = __FILE__
	#endif
	#include once "mff/Form.bi"
	#include once "mff/Grid.bi"
	#include once "mff/CommandButton.bi"
	#include once "mff/Label.bi"
	#include once "mff/CheckBox.bi"
	Using My.Sys.Forms
	/'test comment '/
	Type Form1Type Extends Form
		Declare Sub cmdRowInsert_Click(ByRef Sender As Control)
		Declare Sub cmdRowDele_Click(ByRef Sender As Control)
		Declare Sub cmdColInsert_Click(ByRef Sender As Control)
		Declare Sub cmdColDele_Click(ByRef Sender As Control)
		Declare Sub cmdColInsertAf_Click(ByRef Sender As Control)
		Declare Sub cmdRowInsertAfter_Click(ByRef Sender As Control)
		Declare Sub cmdLargeData_Click(ByRef Sender As Control)
		#ifdef __USE_WINAPI__
			Declare Sub Grid1_GetDispInfo(ByRef Sender As Grid, ByRef NewText As WString, ByVal RowIndex As Integer, ByVal ColumnIndex As Integer, iMask As UINT)
		#endif
		Declare Sub Grid1_CacheHint(ByRef Sender As Grid, ByVal iFrom As Integer, ByVal iTo As Integer)
		Declare Sub Grid1_CellEdited(ByRef Sender As Grid, ByVal RowIndex As Integer, ByVal ColumnIndex As Integer, ByRef NewText As WString)
		Declare Sub cmdSaveToFile_Click(ByRef Sender As Control)
		Declare Sub cmdLoadFromFile_Click(ByRef Sender As Control)
		Declare Sub chkOwnerData_Click(ByRef Sender As CheckBox)
		Declare Sub chkDarkMode_Click(ByRef Sender As CheckBox)
		Declare Sub Grid1_ColumnClick(ByRef Sender As Grid, ByVal ColIndex As Integer)
		Declare Sub chkFixCols_Click(ByRef Sender As CheckBox)
		Declare Sub chkDataArrayPtr_Click(ByRef Sender As CheckBox)
		Declare Constructor
		
		Dim As Grid Grid1
		Dim As CommandButton cmdRowInsert, cmdColInsert, cmdRowDele, cmdColDele, cmdColInsertAfter, cmdRowInsertAfter, cmdLargeData, cmdSaveToFile, cmdLoadFromFile
		Dim As Label Label1
		
		Dim As CheckBox chkOwnerData, chkDarkMode, chkFixCols, chkDataArrayPtr
	End Type
	DefaultFont.Size= 10
	DefaultFont.Name= "Arial"
	Constructor Form1Type
		#if _MAIN_FILE_ = __FILE__
			With App
				.CurLanguagePath = ExePath & "/Languages/"
				.CurLanguage = My.Sys.Language
			End With
		#endif
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
			.Text = ML("Grid1")
			'.TabIndex = 0
			.Hint = ML("Double Click or press space start edit, Enter Confirm input!")
			'.BackColor = clBlue
			'.ForeColor = clWhite
			'.BackColor = IIf(g_darkModeEnabled, darkBkColor, GetSysColor(COLOR_WINDOW))
			'.ForeColor = IIf(g_darkModeEnabled, darkTextColor, GetSysColor(COLOR_WINDOWTEXT))
			.Anchor.Right = AnchorStyle.asAnchor
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Bottom = AnchorStyle.asAnchor
			.OwnerData = True
			.SetBounds 10, 52, 610, 210
			.Columns.Add "NO.", , 30 , cfRight ', , clPurple, clBlue
			.Columns.Add ML("Column") & " 1", , 100, cfRight ', , clRed, clBlue
			.Columns.Add ML("Column") & " 2", , 100, cfRight, True, clYellow, clRed
			.Columns.Add ML("Column") & " 3", , 100, cfRight ', , clBlue, clYellow
			.Columns.Add ML("Column") & " 4", , 100, cfRight ', , clGreen, clBlue
			.Columns.Add ML("Column") & " 5", , 100, cfRight,  True, clPurple, clGreen
			.Columns[1].Tag = @"0"
			
			For i As Integer = 0 To 3  '返回的代码: 3221225477 - 堆栈溢出 就是行不够
				.Rows.Add
				.Rows.Item(i)->State = 1
			Next
			
			'Control's Name
			Grid1[0][1].Text = ML("Row") & " 1 " & ML("Column") & " 1"
			Grid1[1][1].Text = ML("Row") & " 2 " & ML("Column") & " 1"
			Grid1[2][1].Text = ML("Row") & " 3 " & ML("Column") & " 1"
			Grid1[3][1].Text = ML("Row") & " 4 " & ML("Column") & " 1"
			Grid1[0][1].Editable = True
			
			'Like Array
			.Rows[0][2].Text = ML("Row") & " 1 " & ML("Column") & " 2 " & ML("AllowEdit")
			.Rows[1][2].Text = ML("Row") & " 2 " & ML("Column") & " 2 " & ML("AllowEdit")
			.Rows[2][2].Text = ML("Row") & " 3 " & ML("Column") & " 2 " & ML("AllowEdit")
			.Rows[3][2].Text = ML("Row") & " 4 " & ML("Column") & " 2 " & ML("AllowEdit")
			For i As Integer = 0 To 3
				.Rows[i][2].Editable = True
			Next
			'Cell Like Excel
			.Cells(0, 3)->Text = ML("Row") & " 1 " & ML("Column") & " 3"
			.Cells(1, 3)->Text = ML("Row") & " 2 " & ML("Column") & " 3"
			.Cells(2, 3)->Text = ML("Row") & " 3 " & ML("Column") & " 3"
			.Cells(3, 3)->Text = ML("Row") & " 4 " & ML("Column") & " 3"
			.Cells(2, 3)->Editable = True
			.Cells(2, 3)->BackColor = clGreen
			.Cells(2, 2)->BackColor = clGreen
			.Cells(2, 1)->BackColor = clGreen
			.Rows[0][5].Text = ML("Row") & " 1 " & ML("Column") & " 5 " & ML("AllowEdit")
			.Rows[1][5].Text = ML("Row") & " 2 " & ML("Column") & " 5 " & ML("AllowEdit")
			.Rows[2][5].Text = ML("Row") & " 3 " & ML("Column") & " 5 " & ML("AllowEdit")
			.Rows[3][5].Text = ML("Row") & " 4 " & ML("Column") & " 5 " & ML("AllowEdit")
			.Rows[3].Tag = @"3"
			.SelectedRowIndex = 0
			#ifdef __USE_WINAPI__
				.OnGetDispInfo = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByRef NewText As WString, ByVal RowIndex As Integer, ByVal ColumnIndex As Integer, iMask As UINT), @Grid1_GetDispInfo)
			#endif
			.OnCacheHint = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByVal iFrom As Integer, ByVal iTo As Integer), @Grid1_CacheHint)
			.OnCellEdited = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByVal RowIndex As Integer, ByVal ColumnIndex As Integer, ByRef NewText As WString), @Grid1_CellEdited)
			.Designer = @This
			.OnColumnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByVal ColIndex As Integer), @Grid1_ColumnClick)
			.Parent = @This
		End With
		' cmdRowInsert
		With cmdRowInsert
			.Name = "cmdRowInsert"
			.Text = ML("Insert Row before")
			.TabIndex = 0
			.SetBounds 10, 4, 85, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdRowInsert_Click)
			.Parent = @This
		End With
		' cmdColInsert
		With cmdColInsert
			.Name = "cmdColInsert"
			.Text = ML("Insert Col before")
			.TabIndex = 2
			.ControlIndex = 1
			.SetBounds 250, 4, 85, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdColInsert_Click)
			.Parent = @This
		End With
		' cmdRowDele
		With cmdRowDele
			.Name = "cmdRowDele"
			.Text = ML("Dele one Row")
			.TabIndex = 3
			.ControlIndex = 2
			.SetBounds 180, 4, 75, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdRowDele_Click)
			.Parent = @This
		End With
		Dim i As String
		Dim u As AlignmentConstants
		u = AlignmentConstants.taLeft
		
		
		' cmdColDele
		With cmdColDele
			.Name = "cmdColDele"
			.Text = ML("Dele one Col")
			.TabIndex = 4
			.ControlIndex = 2
			.SetBounds 420, 4, 75, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdColDele_Click)
			.Parent = @This
		End With
		' Label1
		With Label1
			.Name = "Label1"
			.Text = ML("Double Click or press space start edit, Enter Confirm input!")
			.TabIndex = 6
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Right = AnchorStyle.asAnchor
			.BackColor = 65535
			.SetBounds 550, 0, 70, 28
			.Designer = @This
			.Parent = @This
		End With
		' ="cmdColInsertAf
		With cmdColInsertAfter
			.Name = "cmdColInsertAfter"
			.Text = ML("Insert Col after")
			.TabIndex = 7
			.SetBounds 340, 4, 75, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdColInsertAf_Click)
			.Parent = @This
		End With
		' ="cmdRowInsertAfter
		With cmdRowInsertAfter
			.Name = "cmdRowInsertAfter"
			.Text = ML("Insert Row After")
			.TabIndex = 8
			.SetBounds 100, 4, 75, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdRowInsertAfter_Click)
			.Parent = @This
		End With
		' cmdLargeData
		With cmdLargeData
			.Name = "cmdLargeData"
			.Text = ML("Large Data")
			.TabIndex = 9
			.SetBounds 490, 4, 60, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdLargeData_Click)
			.Parent = @This
		End With
		' cmdSaveToFile
		With cmdSaveToFile
			.Name = "cmdSaveToFile"
			.Text = ML("Save To File")
			.TabIndex = 10
			.SetBounds 440, 27, 80, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdSaveToFile_Click)
			.Parent = @This
		End With
		' cmdLoadFromFile
		With cmdLoadFromFile
			.Name = "cmdLoadFromFile"
			.Text = ML("Load From File")
			.TabIndex = 11
			.ControlIndex = 9
			.SetBounds 530, 27, 80, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdLoadFromFile_Click)
			.Parent = @This
		End With
		' chkOwnerData
		With chkOwnerData
			.Name = "chkOwnerData"
			.Text = ML("OwnerData")
			.TabIndex = 12
			.SetBounds 20, 27, 70, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As CheckBox), @chkOwnerData_Click)
			.Parent = @This
		End With
		' chkDarkMode
		With chkDarkMode
			.Name = "chkDarkMode"
			.Text = ML("DarkMode")
			.TabIndex = 13
			.ControlIndex = 11
			.Checked = True
			.SetBounds 100, 27, 60, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As CheckBox), @chkDarkMode_Click)
			.Parent = @This
		End With
		' chkFixCols
		With chkFixCols
			.Name = "chkFixCols"
			.Text = ML("Col 1 is the row index")
			.TabIndex = 14
			.Checked = True
			.ControlIndex = 12
			.SetBounds 170, 27, 120, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As CheckBox), @chkFixCols_Click)
			.Parent = @This
		End With
		' chkDataArrayPtr
		With chkDataArrayPtr
			.Name = "chkDataArrayPtr"
			.Text = ML("Using DataArrayPtr(,)")
			.TabIndex = 15
			.Checked = False
			.ControlIndex = 12
			.SetBounds 300, 27, 130, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As CheckBox), @chkDataArrayPtr_Click)
			.Parent = @This
		End With
	End Constructor
	
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
	Grid1.Rows.Insert(Curr, Str(Curr), , , , True)
	Grid1.Repaint
End Sub

Private Sub Form1Type.cmdRowDele_Click(ByRef Sender As Control)
	Dim As Integer Curr = Grid1.SelectedRowIndex
	Grid1.Rows.Remove(Curr)
	Grid1.Repaint
End Sub

Private Sub Form1Type.cmdColInsert_Click(ByRef Sender As Control)
	Dim As Integer Curr = Grid1.SelectedColumnIndex
	Grid1.Columns.Insert(Curr, ML("Column") & " "  & Curr, , 100, cfRight, , True)
	Grid1.Repaint
End Sub

Private Sub Form1Type.cmdColDele_Click(ByRef Sender As Control)
	Dim As Integer Curr = Grid1.SelectedColumnIndex
	'Print "CurrCol=" &  Curr
	Grid1.Columns.Remove(Curr)
End Sub

Private Sub Form1Type.cmdColInsertAf_Click(ByRef Sender As Control)
	Dim As Integer Curr = Grid1.SelectedColumnIndex
	Grid1.Columns.Insert(Curr, ML("Column") & " "  & Curr, , 100, cfRight, False, True, clYellow, clRed)
End Sub

Private Sub Form1Type.cmdRowInsertAfter_Click(ByRef Sender As Control)
	Dim As Integer Curr = Grid1.SelectedRowIndex
	Grid1.Rows.Insert(Curr, Str(Curr), , , , False, False)
	Grid1.Repaint
End Sub

Private Sub Form1Type.cmdLargeData_Click(ByRef Sender As Control)
	
	Dim As Double StartShow = Timer
	Dim As WString * 255 RowStr
    Dim As Integer  MAX_ROW = 20000
	With Grid1
		'chkOwnerData.Checked = Not chkDataArrayPtr.Checked
		.Clear
		.OwnerData = chkOwnerData.Checked
		.FixCols = IIf(chkFixCols.Checked, 1, 0)
		
		If .FixCols <> 0 Then .Columns.Add "NO.", , 30 , cfRight , , clPurple, clBlue
		.Columns.Add ML("Column") & " 0" , , 100, cfRight , , clRed, clBlue
		.Columns.Add ML("Column") & " 1", , 100, cfRight, True , clYellow, clRed
		.Columns.Add ML("Column") & " 2", , 100, cfRight , , clBlue, clYellow
		.Columns.Add ML("Column") & " 3", , 100, cfRight ', , clGreen, clBlue
		.Columns.Add ML("Column") & " 4", , 100, cfRight,  True , clPurple, clGreen
		.Columns[1].Tag = @"0"
		.SetFocus
		If .OwnerData Then 
			.Rows.Count = MAX_ROW
		End If
		If chkDataArrayPtr.Checked Then
			.Rows.Count = MAX_ROW
			ReDim .DataArrayPtr(MAX_ROW, .Columns.Count - .FixCols - 1)
			For iRow As Long = 0 To UBound(.DataArrayPtr, 1)
				For iCol As Integer = 0 To .Columns.Count - .FixCols -  1
					WLet(.DataArrayPtr(iRow, iCol), ML("Array") + ML("Row") + Str(iRow + 1) + ML("Col") + Str(iCol))
				Next
			Next
		ElseIf Not .OwnerData Then
			For iRow As Long = 0 To MAX_ROW
				RowStr = ML("Grid") + ML("Row") + Str(iRow + 1) + ML("Col0")
				Randomize
				For iCol As Integer = 1 To .Columns.Count - .FixCols - 1
					RowStr += Chr(9) + ML("Grid") + ML("Row")  + Str(Fix(Rnd * 10000000)) + ML("Col") + Str(iCol)
					'.Rows[iRow][iCol].Text = "行" + Str(iRow + 1) + "列" + Str(iCol)  ' Slowly in this ways
				Next
				'Add the Data ;  Gradient Color
				If iRow Mod 2 = 0 Then
					.Rows.Add RowStr, , , , , True, 8421504, clWhiteSmoke  '快速将数据添加到一行
				ElseIf iRow Mod 3 = 0 Then
					.Rows.Add RowStr, , , , , True, 10395294, clWhite      'Fast add the data to a row
				ElseIf iRow Mod 4 = 0 Then
					.Rows.Add RowStr, , , , , True, 14808000, clWhiteSmoke  'Fast add the data to a row
				Else
					.Rows.Add RowStr, , , , , True
				End If
				If iRow Mod 15 = 0 Then App.DoEvents  'if rows.count=666666  :254.144s   1 Million: 364.829s    5 Million:512.616s
			Next
		End If 
		.SelectedRowIndex = 0 '.Rows.Count - 1
		Debug.Print __FUNCTION__ & ": " & ML("Elasped time:") & Str(Int((Timer - StartShow) * 1000 + 0.5) / 1000) & ML("s. Total Rows/Cols:") & " " & (.Rows.Count - 1) & " / " & (.Columns.Count - 1)
	End With
End Sub

#ifdef __USE_WINAPI__
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
#endif

Private Sub Form1Type.Grid1_CacheHint(ByRef Sender As Grid, ByVal iFrom As Integer, ByVal iTo As Integer)
	'upload the data to grid here also
	With Grid1
		If Not .OwnerData Then Return
		.FixCols = IIf(chkFixCols.Checked, 1, 0)
		For iRow As Integer = iFrom To iTo
			'Debug.Print " iFrom=" & iFrom  & " iTo=" & iTo & " State=" & .Rows.Item(iRow)->State
			If .FixCols <> 0 Then .Rows[iRow][0].Text = Str(iRow + 1) Else .Rows[iRow][0].Text = ML("User") + ML("Row") + Str(iRow + 1) +  ML("Col")
			If .Rows.Item(iRow)->State = 1 Then Continue For
			For iCol As Integer = 1 To .Columns.Count - 1
				.Rows[iRow][iCol].Text =  ML("User") + ML("Row") + Str(iRow + 1) +  ML("Col") + Str(iCol)
			Next
			.Rows.Item(iRow)->State = 1
		Next
	End With
End Sub

Private Sub Form1Type.Grid1_CellEdited(ByRef Sender As Grid, ByVal RowIndex As Integer, ByVal ColumnIndex As Integer, ByRef NewText As WString)
	'Debug.Print " RowIndex=" & RowIndex  & " Col=" & ColumnIndex & " Text=" & NewText
End Sub

Private Sub Form1Type.cmdSaveToFile_Click(ByRef Sender As Control)
	Grid1.SaveToFile(ExePath & "\gridTest.csv")
End Sub

Private Sub Form1Type.cmdLoadFromFile_Click(ByRef Sender As Control)
	Dim As Double StartShow = Timer
	chkOwnerData.Checked = False
	Grid1.OwnerData = chkOwnerData.Checked
	Grid1.FixCols = chkFixCols.Checked
	Grid1.LoadFromFile(ExePath & "\gridTest.csv", , , chkDataArrayPtr.Checked)
	Debug.Print  ML("Elasped time:") & Str(Int((Timer - StartShow) * 1000 + 0.5) / 1000) & " s"
End Sub

Private Sub Form1Type.chkOwnerData_Click(ByRef Sender As CheckBox)
	'Grid1.Clear
	cmdLargeData_Click(Sender)
End Sub

Private Sub Form1Type.chkDarkMode_Click(ByRef Sender As CheckBox)
	SetDarkMode(chkDarkMode.Checked, chkDarkMode.Checked)
End Sub

Private Sub Form1Type.Grid1_ColumnClick(ByRef Sender As Grid, ByVal ColIndex As Integer)
	If Grid1.SortIndex = ColIndex Then
		If Grid1.SortOrder  = SortStyle.ssSortAscending Then
			Grid1.SortOrder = SortStyle.ssSortDescending
		Else
			Grid1.SortOrder = SortStyle.ssSortAscending
		End If
	Else
		Grid1.SortOrder = SortStyle.ssSortAscending
	End If
	Grid1.Rows.Sort Grid1.SortIndex, Grid1.SortOrder
End Sub

Private Sub Form1Type.chkFixCols_Click(ByRef Sender As CheckBox)
	cmdLargeData_Click(Sender)
End Sub

Private Sub Form1Type.chkDataArrayPtr_Click(ByRef Sender As CheckBox)
	cmdLargeData_Click(Sender)
End Sub