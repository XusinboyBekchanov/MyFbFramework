#include once "PrintPreviewDialog.bi"

#ifndef ReadProperty_Off
	Private Function PrintPreviewDialog.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "caption": Return @frmDialog.Caption
		Case "document": Return Document
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
#endif

#ifndef WriteProperty_Off
	Private Function PrintPreviewDialog.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "caption": Caption = QWString(Value)
		Case "document": Document = Value
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
#endif

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
	frmDialog.ShowModal(*pApp->MainForm)
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
		.PageSize = Cast(PaperSize Ptr, cboSize.ItemData(ItemIndex))->RawKind
		.PageLength = Cast(PaperSize Ptr, cboSize.ItemData(ItemIndex))->Height
		.PageWidth = Cast(PaperSize Ptr, cboSize.ItemData(ItemIndex))->Width
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
	If pdPrint.Execute Then
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
		.ControlIndex = 2
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
		.TabIndex = 3
		.ControlIndex = 1
		.SetBounds 150, 0, 140, 22
		.Designer = @This
		.Parent = @hbxCommands
		Dim As PaperSize Ptr pPaperSize
		For i As Integer = 0 To pnlPrintPreviewControl.Document->PrinterSettings.PaperSizes.Count - 1
			pPaperSize = pnlPrintPreviewControl.Document->PrinterSettings.PaperSizes.Item(i)
			.AddItem pPaperSize->PaperName
			.ItemData(i) = pPaperSize
		Next
		.OnSelected = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ComboBoxEdit, ItemIndex As Integer), @cboSize_Selected)
		.ItemIndex = 0
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
