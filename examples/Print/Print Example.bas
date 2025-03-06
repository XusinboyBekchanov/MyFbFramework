'#Region "Form"
	#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
		#define __MAIN_FILE__
		#ifdef __FB_WIN32__
			#cmdline "Form1.rc"
		#endif
		Const _MAIN_FILE_ = __FILE__
	#endif
	#include once "mff/Form.bi"
	#include once "mff/PrintDocument.bi"
	#include once "mff/Printer.bi"
	#include once "mff/PrintDialog.bi"
	#include once "mff/PrintPreviewDialog.bi"
	#include once "mff/PrintPreviewControl.bi"
	#include once "mff/CommandButton.bi"
	#include once "mff/HorizontalBox.bi"
	
	Using My.Sys.Forms
	
	Type Form1Type Extends Form
		Declare Sub PrintDocument1_PrintPage(ByRef Sender As PrintDocument, ByRef Canvas As My.Sys.Drawing.Canvas, ByRef HasMorePages As Boolean)
		Declare Sub cmdShowPrintPreviewDialog_Click(ByRef Sender As Control)
		Declare Sub lblMinus_Click(ByRef Sender As Control)
		Declare Sub lblPlus_Click(ByRef Sender As Control)
		Declare Sub lblPrevious_Click(ByRef Sender As Control)
		Declare Sub lblNext_Click(ByRef Sender As Control)
		Declare Sub trbPercent_Change(ByRef Sender As TrackBar, Position As Integer)
		Declare Sub cboSize_Selected(ByRef Sender As ComboBoxEdit, ItemIndex As Integer)
		Declare Sub cmdFitToWindow_Click(ByRef Sender As Control)
		Declare Sub cboOrientation_Selected(ByRef Sender As ComboBoxEdit, ItemIndex As Integer)
		Declare Sub Form_Show(ByRef Sender As Form)
		Declare Sub cmdPrint_Click(ByRef Sender As Control)
		Declare Sub txtPageNumber_Activate(ByRef Sender As TextBox)
		Declare Sub PrintPreviewControl1_CurrentPageChanged(ByRef Sender As PrintPreviewControl)
		Declare Sub PrintPreviewControl1_Zoom(ByRef Sender As PrintPreviewControl)
		Declare Sub ChangePagesCount()
		Declare Constructor
		
		Dim As PrintDocument PrintDocument1
		Dim As PrintDialog PrintDialog1
		Dim As PrintPreviewDialog PrintPreviewDialog1
		Dim As PrintPreviewControl PrintPreviewControl1
		Dim As CommandButton cmdShowPrintPreviewDialog
		Dim As HorizontalBox hbxCommands
		Dim As CommandButton cmdPrint, cmdFitToWindow
		Dim As TrackBar trbPercent
		Dim As Label lblPercent, lblMinus, lblPlus, lblPrevious, lblNext, lblPagesCount
		Dim As ComboBoxEx cboOrientation, cboSize
		Dim As TextBox txtPageNumber
	End Type
	
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
			.Text = ML("Print Preview Dialog")
			.Designer = @This
			.SetBounds 0, 0, 930, 500
			.OnShow = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Form), @Form_Show)
		End With
		' PrintDocument1
		With PrintDocument1
			.Name = "PrintDocument1"
			.SetBounds 100, 210, 16, 16
			.Designer = @This
			.OnPrintPage = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As PrintDocument, ByRef Canvas As My.Sys.Drawing.Canvas, ByRef HasMorePages As Boolean), @PrintDocument1_PrintPage)
			.Parent = @This
		End With
		' PrintDialog1
		With PrintDialog1
			.Name = "PrintDialog1"
			.SetBounds 70, 210, 16, 16
			.Designer = @This
			.Parent = @This
		End With
		' PrintPreviewDialog1
		With PrintPreviewDialog1
			.Name = "PrintPreviewDialog1"
			.Document = @PrintDocument1
			.SetBounds 40, 210, 16, 16
			.Designer = @This
			.Parent = @This
		End With
		' hbxCommands
		With hbxCommands
			.Name = "hbxCommands"
			.Text = "HorizontalBox1"
			.TabIndex = 0
			.Align = DockStyle.alTop
			.SetBounds 0, 0, 910, 22
			.Designer = @This
			.Parent = @This
		End With
		' cmdPrint
		With cmdPrint
			.Name = "cmdPrint"
			.Text = ML("Print")
			.TabIndex = 1
			.SetBounds 0, 0, 50, 22
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdPrint_Click)
			.Parent = @hbxCommands
		End With
		' PrintPreviewDialog1
		With cmdShowPrintPreviewDialog
			.Name = "cmdShowPrintPreviewDialog"
			.Text = ML("Show Print Preview Dialog")
			.TabIndex = 1
			.ControlIndex = 12
			.SetBounds 30, 120, 140, 22
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdShowPrintPreviewDialog_Click)
			.Parent = @hbxCommands
		End With
		' PrintPreviewControl1
		With PrintPreviewControl1
			.Name = "PrintPreviewControl1"
			.Text = "Panel1"
			.TabIndex = 11
			.Align = DockStyle.alNone
			.BackColor = 12632256
			.DoubleBuffered = True
			PrintPreviewControl1.Document = @PrintDocument1
			PrintPreviewControl1.Anchor.Top = AnchorStyle.asAnchor
			PrintPreviewControl1.Anchor.Right = AnchorStyle.asAnchor
			PrintPreviewControl1.Anchor.Left = AnchorStyle.asAnchor
			PrintPreviewControl1.Anchor.Bottom = AnchorStyle.asAnchor
			.SetBounds 130, 122, 654, 259
			.Designer = @This
			.OnCurrentPageChanged = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As PrintPreviewControl), @PrintPreviewControl1_CurrentPageChanged)
			.OnZoom = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As PrintPreviewControl), @PrintPreviewControl1_Zoom)
			.Parent = @This
		End With
		' cboOrientation
		With cboOrientation
			.Name = "cboOrientation"
			.Text = "ComboBoxEx1"
			.TabIndex = 8
			.ControlIndex = 2
			.SetBounds 190, 0, 100, 22
			.Designer = @This
			.Parent = @hbxCommands
			.AddItem ML("Portrait")
			.AddItem ML("Landscape")
			.OnSelected = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ComboBoxEdit, ItemIndex As Integer), @cboOrientation_Selected)
			.ItemIndex = 0
		End With
		' cboSize
		With cboSize
			.Name = "cboSize"
			.Text = "ComboBoxEx1"
			.TabIndex = 3
			.ControlIndex = 1
			.SetBounds 150, 0, 140, 22
			.Designer = @This
			.Parent = @hbxCommands
			Dim As PaperSize Ptr pPaperSize
			For i As Integer = 0 To PrintDocument1.PrinterSettings.PaperSizes.Count - 1
				pPaperSize = PrintDocument1.PrinterSettings.PaperSizes.Item(i)
				.AddItem pPaperSize->PaperName
				.ItemData(i) = pPaperSize
			Next
			.OnSelected = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ComboBoxEdit, ItemIndex As Integer), @cboSize_Selected)
			.ItemIndex = 0
			PrintPreviewControl1.PageWidth = 2100
			PrintPreviewControl1.PageLength = 2970
		End With
		' lblPrevious
		With lblPrevious
			.Name = "lblPrevious"
			.Text = "<"
			.TabIndex = 4
			.Caption = "<"
			.CenterImage = True
			.ID = 1012
			.Alignment = AlignmentConstants.taCenter
			.SetBounds 600, 0, 20, 22
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @lblPrevious_Click)
			.Parent = @hbxCommands
		End With
		' txtPageNumber
		With txtPageNumber
			.Name = "txtPageNumber"
			.Text = "1"
			.TabIndex = 5
			.ID = 1012
			.Alignment = AlignmentConstants.taCenter
			.SetBounds 310, 0, 20, 22
			.Designer = @This
			.OnActivate = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TextBox), @txtPageNumber_Activate)
			.Parent = @hbxCommands
		End With
		' lblPagesCount
		With lblPagesCount
			.Name = "lblPagesCount"
			.Text = " of 1"
			.TabIndex = 6
			.Caption = " of 1"
			.CenterImage = True
			.ID = 1012
			.Alignment = AlignmentConstants.taCenter
			.SetBounds 600, 0, 50, 22
			.Designer = @This
			.Parent = @hbxCommands
		End With
		' lblNext
		With lblNext
			.Name = "lblNext"
			.Text = ">"
			.TabIndex = 6
			.Caption = ">"
			.CenterImage = True
			.ID = 1012
			.Alignment = AlignmentConstants.taCenter
			.SetBounds 600, 0, 20, 22
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @lblNext_Click)
			.Parent = @hbxCommands
		End With
		' cmdFitToWindow
		With cmdFitToWindow
			.Name = "cmdFitToWindow"
			.Text = ML("Fit to Window")
			.TabIndex = 10
			.ControlIndex = 5
			.Align = DockStyle.alRight
			.SetBounds 10, 0, 80, 22
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdFitToWindow_Click)
			.Parent = @hbxCommands
		End With
		' lblPlus
		With lblPlus
			.Name = "lblPlus"
			.Text = "+"
			.TabIndex = 7
			.ControlIndex = 3
			.Caption = "+"
			.CenterImage = True
			.ID = 1010
			.Align = DockStyle.alRight
			.Alignment = AlignmentConstants.taCenter
			.SetBounds 280, 0, 20, 22
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @lblPlus_Click)
			.Parent = @hbxCommands
		End With
		' trbPercent
		With trbPercent
			.Name = "trbPercent"
			.Text = ""
			.TabIndex = 2
			.MinValue = 10
			.MaxValue = 500
			.Position = 75
			.Align = DockStyle.alRight
			.SetBounds 380, 0, 200, 22
			.Designer = @This
			.OnChange = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TrackBar, Position As Integer), @trbPercent_Change)
			.Parent = @hbxCommands
			PrintPreviewControl1.Zoom = 75
		End With
		' lblMinus
		With lblMinus
			.Name = "lblMinus"
			.Text = "-"
			.TabIndex = 6
			.Caption = "-"
			.CenterImage = True
			.ID = 1012
			.Align = DockStyle.alRight
			.Alignment = AlignmentConstants.taCenter
			.SetBounds 600, 0, 20, 22
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @lblMinus_Click)
			.Parent = @hbxCommands
		End With
		' lblPercent
		With lblPercent
			.Name = "lblPercent"
			.Text = "75%"
			.TabIndex = 4
			.CenterImage = True
			.ID = 1007
			.Caption = "75%"
			.Align = DockStyle.alRight
			.Alignment = AlignmentConstants.taCenter
			.SetBounds 570, 0, 50, 22
			.Designer = @This
			.Parent = @hbxCommands
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

Private Sub Form1Type.cmdShowPrintPreviewDialog_Click(ByRef Sender As Control)
	PrintPreviewDialog1.Execute
End Sub

Private Sub Form1Type.lblMinus_Click(ByRef Sender As Control)
	trbPercent.Position = Max(0, trbPercent.Position - 1)
End Sub

Private Sub Form1Type.lblPlus_Click(ByRef Sender As Control)
	trbPercent.Position = Min(500, trbPercent.Position + 1)
End Sub

Private Sub Form1Type.trbPercent_Change(ByRef Sender As TrackBar, Position As Integer)
	lblPercent.Caption = Position & "%"
	PrintPreviewControl1.Zoom = Position
End Sub

Private Sub Form1Type.ChangePagesCount()
	lblPagesCount.Caption = " of " & Str(PrintDocument1.Pages.Count)
End Sub

Private Sub Form1Type.cboSize_Selected(ByRef Sender As ComboBoxEdit, ItemIndex As Integer)
	With PrintPreviewControl1
		.PageSize = Cast(PaperSize Ptr, cboSize.ItemData(ItemIndex))->RawKind
		.PageLength = Cast(PaperSize Ptr, cboSize.ItemData(ItemIndex))->Height
		.PageWidth = Cast(PaperSize Ptr, cboSize.ItemData(ItemIndex))->Width
		.Repaint
	End With
	ChangePagesCount
End Sub

Private Sub Form1Type.cmdFitToWindow_Click(ByRef Sender As Control)
	Dim As Integer iWidth = PrintDocument1.PrinterSettings.PrintableWidth
	Dim As Integer iHeight = PrintDocument1.PrinterSettings.PrintableHeight
	Dim As Integer WidthPercent = Int((PrintPreviewControl1.ClientWidth - 20) / iWidth * 100)
	Dim As Integer HeightPercent = Int((PrintPreviewControl1.ClientHeight - 20) / iHeight * 100)
	Dim As Integer iPercent = IIf(WidthPercent < HeightPercent, WidthPercent, HeightPercent)
	trbPercent.Position = iPercent
End Sub

Private Sub Form1Type.cboOrientation_Selected(ByRef Sender As ComboBoxEdit, ItemIndex As Integer)
	If ItemIndex = 0 Then
	'	If FPageHeight < FPageWidth Then Swap FPageWidth, FPageHeight
		PrintPreviewControl1.Orientation = PrinterOrientation.poPortait
	ElseIf ItemIndex = 1 Then
	'	If FPageWidth < FPageHeight Then Swap FPageWidth, FPageHeight
		PrintPreviewControl1.Orientation = PrinterOrientation.poLandscape
	End If
	'PrintPreviewControl1.Repaint
	ChangePagesCount
End Sub

Private Sub Form1Type.Form_Show(ByRef Sender As Form)
	PrintPreviewControl1.Document->Repaint
	ChangePagesCount
End Sub

Private Sub Form1Type.cmdPrint_Click(ByRef Sender As Control)
	If PrintDialog1.Execute Then
		PrintPreviewControl1.Document->Print
	End If
End Sub

Private Sub Form1Type.lblPrevious_Click(ByRef Sender As Control)
	txtPageNumber.Text = Str(Max(1, Val(txtPageNumber.Text) - 1))
	PrintPreviewControl1.CurrentPage = Val(txtPageNumber.Text)
End Sub

Private Sub Form1Type.lblNext_Click(ByRef Sender As Control)
	txtPageNumber.Text = Str(Max(1, Min(PrintPreviewControl1.Document->Pages.Count, Val(txtPageNumber.Text) + 1)))
	PrintPreviewControl1.CurrentPage = Val(txtPageNumber.Text)
End Sub

Private Sub Form1Type.txtPageNumber_Activate(ByRef Sender As TextBox)
	txtPageNumber.Text = Str(Max(1, Min(PrintPreviewControl1.Document->Pages.Count, Val(txtPageNumber.Text))))
	PrintPreviewControl1.CurrentPage = Val(txtPageNumber.Text)
End Sub

Private Sub Form1Type.PrintPreviewControl1_CurrentPageChanged(ByRef Sender As PrintPreviewControl)
	txtPageNumber.Text = Str(PrintPreviewControl1.CurrentPage)
End Sub

Private Sub Form1Type.PrintPreviewControl1_Zoom(ByRef Sender As PrintPreviewControl)
	trbPercent.Position = Sender.Zoom
End Sub

Private Sub Form1Type.PrintDocument1_PrintPage(ByRef Sender As PrintDocument, ByRef Canvas As My.Sys.Drawing.Canvas, ByRef HasMorePages As Boolean)
	Canvas.Font.Size= 8
	Canvas.TextOut 100, 100, "Hello World!", clBlue, clYellow
	Canvas.Font.Size= 12
	Canvas.TextOut 100, 150, "Hello World!", clGreen, clRed
	Canvas.Font.Size= 16
	Canvas.TextOut 100, 200, "Hello World!", clRed, clGreen
	Canvas.Font.Size= 22
	Canvas.TextOut 100, 300, "Hello World!", clPink, clYellowGreen
End Sub

