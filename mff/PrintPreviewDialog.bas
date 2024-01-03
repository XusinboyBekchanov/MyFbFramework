#include once "PrintPreviewDialog.bi"

Private Property PrintPreviewDialog.Caption ByRef As WString
	Return frmDialog.Caption
End Property

Private Property PrintPreviewDialog.Caption(ByRef Value As WString)
	frmDialog.Caption = Value
End Property

Private Property PrintPreviewDialog.Document As PrintDocument Ptr
	Return pnlPrintPreviewControl.Document
End Property

Private Property PrintPreviewDialog.Document(Value As PrintDocument Ptr)
	pnlPrintPreviewControl.Document = Value
End Property

Private Sub PrintPreviewDialog.lblMinus_Click(ByRef Sender As Control)
	trbPercent.Position = Max(0, trbPercent.Position - 1)
End Sub

Private Function PrintPreviewDialog.Execute() As Boolean
	frmDialog.ShowModal
	Return True
End Function

Private Sub PrintPreviewDialog.lblPlus_Click(ByRef Sender As Control)
	trbPercent.Position = Min(500, trbPercent.Position + 1)
End Sub

Private Sub PrintPreviewDialog.trbPercent_Change(ByRef Sender As TrackBar, Position As Integer)
	lblPercent.Caption = Position & "%"
	pnlPrintPreviewControl.Zoom = Position
End Sub

Private Sub PrintPreviewDialog.ChangePagesCount()
	lblPagesCount.Caption = " of " & Str(Document->Pages.Count)
End Sub

Private Sub PrintPreviewDialog.cboSize_Selected(ByRef Sender As ComboBoxEdit, ItemIndex As Integer)
	With pnlPrintPreviewControl
		Select Case ItemIndex
		Case 0
			.PageLength = 11890
			.PageWidth = 8410
		Case 1
			.PageLength = 8410
			.PageWidth = 5940
		Case 2
			.PageLength = 5940
			.PageWidth = 4200
		Case 3
			.PageLength = 4200
			.PageWidth = 2970
		Case 4
			.PageLength = 2970
			.PageWidth = 2100
		Case 5
			.PageLength = 2100
			.PageWidth = 1480
		Case 6
			.PageLength = 1480
			.PageWidth = 1050
		End Select
		'pnlPrintPreviewControl.Repaint
	End With
	ChangePagesCount
End Sub

Private Sub PrintPreviewDialog.cmdFitToWindow_Click(ByRef Sender As Control)
	Dim As Integer iWidth = Document->PrinterSettings.PrintableWidth
	Dim As Integer iHeight = Document->PrinterSettings.PrintableHeight
	Dim As Integer WidthPercent = Int((pnlPrintPreviewControl.ClientWidth - 20) / iWidth * 100)
	Dim As Integer HeightPercent = Int((pnlPrintPreviewControl.ClientHeight - 20) / iHeight * 100)
	Dim As Integer iPercent = IIf(WidthPercent < HeightPercent, WidthPercent, HeightPercent)
	trbPercent.Position = iPercent
End Sub

Private Sub PrintPreviewDialog.cboOrientation_Selected(ByRef Sender As ComboBoxEdit, ItemIndex As Integer)
	If ItemIndex = 0 Then
	'	If FPageHeight < FPageWidth Then Swap FPageWidth, FPageHeight
		pnlPrintPreviewControl.Orientation = PrinterOrientation.poPortait
	ElseIf ItemIndex = 1 Then
	'	If FPageWidth < FPageHeight Then Swap FPageWidth, FPageHeight
		pnlPrintPreviewControl.Orientation = PrinterOrientation.poLandscape
	End If
	'pnlPrintPreviewControl.Repaint
	ChangePagesCount
End Sub

Private Sub PrintPreviewDialog.Form_Show(ByRef Sender As Form)
	pnlPrintPreviewControl.Document->Repaint
	ChangePagesCount
End Sub

Private Sub PrintPreviewDialog.cmdPrint_Click(ByRef Sender As Control)
	If pnlPrintPreviewControl.Document->PrinterSettings.ChoosePrinter <> "" Then
		pnlPrintPreviewControl.Document->Print
	End If
End Sub

Private Sub PrintPreviewDialog.lblPrevious_Click(ByRef Sender As Control)
	txtPageNumber.Text = Str(Max(1, Val(txtPageNumber.Text) - 1))
	pnlPrintPreviewControl.CurrentPage = Val(txtPageNumber.Text)
End Sub

Private Sub PrintPreviewDialog.lblNext_Click(ByRef Sender As Control)
	txtPageNumber.Text = Str(Max(1, Min(pnlPrintPreviewControl.Document->Pages.Count, Val(txtPageNumber.Text) + 1)))
	pnlPrintPreviewControl.CurrentPage = Val(txtPageNumber.Text)
End Sub

Private Sub PrintPreviewDialog.txtPageNumber_Activate(ByRef Sender As TextBox)
	txtPageNumber.Text = Str(Max(1, Min(pnlPrintPreviewControl.Document->Pages.Count, Val(txtPageNumber.Text))))
	pnlPrintPreviewControl.CurrentPage = Val(txtPageNumber.Text)
End Sub

Private Sub PrintPreviewDialog.pnlPrintPreviewControl_CurrentPageChanged(ByRef Sender As PrintPreviewControl)
	txtPageNumber.Text = Str(pnlPrintPreviewControl.CurrentPage)
End Sub

Private Sub PrintPreviewDialog.pnlPrintPreviewControl_Zoom(ByRef Sender As PrintPreviewControl)
	trbPercent.Position = Sender.Zoom
End Sub

Private Constructor PrintPreviewDialog
	WLet(FClassName, "PrintPreviewDialog")
	' frmDialog
	With frmDialog
		.Name = "frmDialog"
		.Text = "Print Preview"
		.Designer = @This
		.Caption = "Print Preview"
		.OnShow = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Form), @Form_Show)
		.SetBounds 0, 0, 900, 570
	End With
	' hbxCommands
	With hbxCommands
		.Name = "hbxCommands"
		.Text = "HorizontalBox1"
		.TabIndex = 0
		.Align = DockStyle.alTop
		.SetBounds 0, 0, 620, 22
		.Designer = @This
		.Parent = @frmDialog
	End With
	' cmdPrint
	With cmdPrint
		.Name = "cmdPrint"
		.Text = "Print"
		.TabIndex = 1
		.Caption = "Print"
		.SetBounds 0, 0, 50, 22
		.Designer = @This
		.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdPrint_Click)
		.Parent = @hbxCommands
	End With
	' pnlPrintPreviewControl
	With pnlPrintPreviewControl
		.Name = "pnlPrintPreviewControl"
		.Text = "Panel1"
		.TabIndex = 11
		.Align = DockStyle.alClient
		.BackColor = 12632256
		.DoubleBuffered = True
		.SetBounds 0, 22, 884, 509
		.Designer = @This
		.OnCurrentPageChanged = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As PrintPreviewControl), @pnlPrintPreviewControl_CurrentPageChanged)
		.OnZoom = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As PrintPreviewControl), @pnlPrintPreviewControl_Zoom)
		.Parent = @frmDialog
	End With
	' cboOrientation
	With cboOrientation
		.Name = "cboOrientation"
		.Text = "ComboBoxEx1"
		.TabIndex = 8
		.ControlIndex = 6
		.SetBounds 50, 0, 100, 22
		.Designer = @This
		.Parent = @hbxCommands
		.AddItem "Portrait"
		.AddItem "Landscape"
		.OnSelected = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ComboBoxEdit, ItemIndex As Integer), @cboOrientation_Selected)
		.ItemIndex = 0
	End With
	' cboSize
	With cboSize
		.Name = "cboSize"
		.Text = "ComboBoxEx1"
		.TabIndex = 10
		.ControlIndex = 1
		.SetBounds 150, 0, 140, 22
		.Designer = @This
		.Parent = @hbxCommands
		.AddItem "A0 (841 x 1189 mm)"
		.AddItem "A1 (594 x 841 mm)"
		.AddItem "A2 (420 x 594 mm)"
		.AddItem "A3 (297 x 420 mm)"
		.AddItem "A4 (210 x 297 mm)"
		.AddItem "A5 (148 x 210 mm)"
		.AddItem "A6 (105 x 148 mm)"
		.OnSelected = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ComboBoxEdit, ItemIndex As Integer), @cboSize_Selected)
		.ItemIndex = 4
		pnlPrintPreviewControl.PageWidth = 2100
		pnlPrintPreviewControl.PageLength = 2970
	End With
	' lblPrevious
	With lblPrevious
		.Name = "lblPrevious"
		.Text = "<"
		.TabIndex = 6
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
		.TabIndex = 6
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
		.Text = "Fit to Window"
		.TabIndex = 10
		.ControlIndex = 5
		.Caption = "Fit to Window"
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
		pnlPrintPreviewControl.Zoom = 75
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
