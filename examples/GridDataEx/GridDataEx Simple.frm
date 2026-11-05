'#Region "Form"
	#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
		#define __MAIN_FILE__
		#ifdef __FB_WIN32__
			#cmdline "Form1.rc" '
		#endif
		Const _MAIN_FILE_ = __FILE__
	#endif
	#include once "mff/Form.bi"
	#include once "mff/CommandButton.bi"
	#include once "mff/Label.bi"
	#include once "mff/GridDataEx.bi"

	Using My.Sys.Forms

	'The first steps with GridDataEx: the cells are written with TextMatrix(Row, Col, Text)
	'and read with TextMatrix(Row, Col); "Total" sums a column, "Preview" and "Print" show
	'and print the grid as a report (every platform)
	Type Form1Type Extends Form
		Dim As GridDataEx GridData1
		Dim As CommandButton cmdAdd, cmdTotal, cmdPreview, cmdPrint
		Dim As Label lblTotal
		Declare Sub cmdAdd_Click(ByRef Sender As Control)
		Declare Sub cmdTotal_Click(ByRef Sender As Control)
		Declare Sub cmdPreview_Click(ByRef Sender As Control)
		Declare Sub cmdPrint_Click(ByRef Sender As Control)
		Declare Sub GridData1_AfterEdit(ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByRef NewText As WString)
		Declare Sub AddProduct(ByRef Product As WString, ByVal Qty As Long, ByVal Price As Double)
		Declare Constructor
	End Type

	Constructor Form1Type
		' Form1
		With This
			.Name = "Form1"
			.Text = "GridDataEx - first steps"
			.Designer = @This
			.SetBounds 0, 0, 560, 400
		End With
		' GridData1
		With GridData1
			.Name = "GridData1"
			.Designer = @This
			.SetBounds 8, 8, 528, 300
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Right = AnchorStyle.asAnchor
			.Anchor.Bottom = AnchorStyle.asAnchor
			.Rows = 1
			.Cols = 4
			.FixedRows = 1
			.FixedCols = 0
			.AllowUserEditing = True
			.AllowUserResizing = FlexAllowUserResizingColumns
			.OnAfterEdit = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByRef NewText As WString), @GridData1_AfterEdit)
			.Parent = @This
		End With
		' The header row: TextMatrix(Row, Col, Text) writes a cell (TextMatrix(Row, Col) = Text
		' does not: FreeBASIC has no properties with two indexes)
		GridData1.TextMatrix(0, 0, "Product")
		GridData1.TextMatrix(0, 1, "Qty")
		GridData1.TextMatrix(0, 2, "Price")
		GridData1.TextMatrix(0, 3, "Sum")
		GridData1.ColWidth(0) = 2400
		AddProduct "Notebook", 3, 2.5
		AddProduct "Pencil", 12, 0.4
		AddProduct "Ruler", 2, 1.2
		AddProduct "Eraser", 5, 0.3
		'The current cell: the first data row (the grid was made without data rows)
		GridData1.Row = 1
		GridData1.Col = 0
		' cmdAdd
		With cmdAdd
			.Name = "cmdAdd" : .Text = "Add row" : .Designer = @This
			.SetBounds 8, 318, 80, 26
			.Anchor.Left = AnchorStyle.asAnchor : .Anchor.Bottom = AnchorStyle.asAnchor
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdAdd_Click)
			.Parent = @This
		End With
		' cmdTotal
		With cmdTotal
			.Name = "cmdTotal" : .Text = "Total" : .Designer = @This
			.SetBounds 94, 318, 80, 26
			.Anchor.Left = AnchorStyle.asAnchor : .Anchor.Bottom = AnchorStyle.asAnchor
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdTotal_Click)
			.Parent = @This
		End With
		' cmdPreview
		With cmdPreview
			.Name = "cmdPreview" : .Text = "Preview" : .Designer = @This
			.SetBounds 180, 318, 80, 26
			.Anchor.Left = AnchorStyle.asAnchor : .Anchor.Bottom = AnchorStyle.asAnchor
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdPreview_Click)
			.Parent = @This
		End With
		' cmdPrint
		With cmdPrint
			.Name = "cmdPrint" : .Text = "Print" : .Designer = @This
			.SetBounds 266, 318, 80, 26
			.Anchor.Left = AnchorStyle.asAnchor : .Anchor.Bottom = AnchorStyle.asAnchor
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdPrint_Click)
			.Parent = @This
		End With
		' lblTotal
		With lblTotal
			.Name = "lblTotal" : .Text = "" : .Designer = @This
			.SetBounds 356, 322, 180, 20
			.Anchor.Left = AnchorStyle.asAnchor : .Anchor.Bottom = AnchorStyle.asAnchor
			.Parent = @This
		End With
	End Constructor

	' A new row at the end: Rows grows by one, the cells of the row are written
	Sub Form1Type.AddProduct(ByRef Product As WString, ByVal Qty As Long, ByVal Price As Double)
		Dim As Long r = GridData1.Rows
		GridData1.Rows = r + 1
		GridData1.TextMatrix(r, 0, Product)
		GridData1.TextMatrix(r, 1, Str(Qty))
		GridData1.TextMatrix(r, 2, Format(Price, "0.00"))
		GridData1.TextMatrix(r, 3, Format(Qty * Price, "0.00"))
	End Sub

	Sub Form1Type.cmdAdd_Click(ByRef Sender As Control)
		AddProduct "New product", 1, 1
		GridData1.Row = GridData1.Rows - 1
		GridData1.Col = 0
	End Sub

	' Reading: TextMatrix(Row, Col) returns the text of a cell
	Sub Form1Type.cmdTotal_Click(ByRef Sender As Control)
		Dim As Double Total
		For r As Long = GridData1.FixedRows To GridData1.Rows - 1
			Total += Val(GridData1.TextMatrix(r, 3))
		Next
		lblTotal.Text = "Total: " & Format(Total, "0.00")
	End Sub

	' The sum of a row follows an edited quantity or price
	Sub Form1Type.GridData1_AfterEdit(ByRef Sender As GridDataEx, ByVal Row As Long, ByVal Col As Long, ByRef NewText As WString)
		If Col = 1 OrElse Col = 2 Then
			Sender.TextMatrix(Row, 3, Format(Val(Sender.TextMatrix(Row, 1)) * Val(Sender.TextMatrix(Row, 2)), "0.00"))
		End If
	End Sub

	Sub Form1Type.cmdPreview_Click(ByRef Sender As Control)
		GridData1.PrintPreview "Products"
	End Sub

	Sub Form1Type.cmdPrint_Click(ByRef Sender As Control)
		GridData1.PrintOut "Products"
	End Sub

	Dim Shared Form1 As Form1Type

	#if _MAIN_FILE_ = __FILE__
		Form1.MainForm = True
		Form1.Show
		App.Run
	#endif
'#End Region
