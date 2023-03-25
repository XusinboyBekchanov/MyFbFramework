'#Region "Form"
	#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
		#define __MAIN_FILE__
		#ifdef __FB_WIN32__
			#cmdline "Form1.rc"
		#endif
		Const _MAIN_FILE_ = __FILE__
	#endif
	#include once "mff/Form.bi"
	#include once "mff/Grid.bi"
	
	Using My.Sys.Forms
	
	Type Form1Type Extends Form
		Declare Constructor
		
		Dim As Grid Grid1
	End Type
	
	Constructor Form1Type
		' Form1
		With This
			.Name = "Form1"
			.Text = "Form1"
			.Designer = @This
			.SetBounds 0, 0, 350, 300
		End With
		' Grid1
		With Grid1
			.Name = "Grid1"
			.Text = "Grid1"
			.TabIndex = 0
			.Hint = "Enter Confirm input!"
			.Anchor.Right = AnchorStyle.asAnchor
			.Anchor.Bottom = AnchorStyle.asAnchor
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Left = AnchorStyle.asAnchor
			.SetBounds 10, 20, 320, 240
			.Columns.Add "No", , 50
			.Columns.Add "Column 1", , 100
			.Columns.Add "Column 2", , 100
			.Columns.Add "Column 3", , 100
			.Columns.Add "Column 4", , 100
			.Columns.Add "Column 5", , 100
			.Columns[1].Tag = @"0"
			
			.Rows.Add "1"
			.Rows.Add "2"
			.Rows.Add "3"
			.Rows.Add "4"
			
			'Control's Name
			Grid1[0][1].Text = "Row 1 Column 1"
			Grid1[1][1].Text = "Row 2 Column 1"
			Grid1[2][1].Text = "Row 3 Column 1"
			Grid1[3][1].Text = "Row 4 Column 1"
			'Like Array 
			.Rows[0][2].Text = "Row 1 Column 2"
			.Rows[1][2].Text = "Row 2 Column 2"
			.Rows[2][2].Text = "Row 3 Column 2"
			.Rows[3][2].Text = "Row 4 Column 2"
			
			'Cell Like ExCEL
			.Cell(0, 3)->Text = "Row 1 Column 3"
			.Cell(1, 3)->Text = "Row 2 Column 3"
			.Cell(2, 3)->Text = "Row 3 Column 3"
			.Cell(3, 3)->Text = "Row 4 Column 3"
			
			.Rows[3].Tag = @"1"
			.Designer = @This
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


