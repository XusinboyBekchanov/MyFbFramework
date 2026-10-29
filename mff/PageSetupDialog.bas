'################################################################################
'#  PageSetupDialog.bas                                                         #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Aloberoger, Xusinboy Bekchanov                                     #
'#  Based on:                                                                   #
'#   TPageSetupDLG.bas                                                          #
'#   GUITK-S Windows GUI FB Wrapper Library                                     #
'#   Copyright (c) Aloberoger                                                   #
'################################################################################

#include once "PageSetupDialog.bi"

#if defined(__USE_WASM__) OrElse defined(__USE_JNI__)
	'The papers of the list: the kind and the size in millimeters (portrait)
	Dim Shared As PrinterPaperSize PageSetupPapers(6) = {PrinterPaperSize.ppsA4, PrinterPaperSize.ppsA3, PrinterPaperSize.ppsLetter, _
		PrinterPaperSize.ppsLEGALr, PrinterPaperSize.ppsTABLOID, PrinterPaperSize.ppsEXECUTIVE, PrinterPaperSize.ppsSTATEMENT}
	Dim Shared As Single PageSetupPaperSizes(6, 1) = {{210, 297}, {297, 420}, {215.9, 279.4}, {215.9, 355.6}, {279.4, 431.8}, {184.2, 266.7}, {139.7, 215.9}}
	
	'Web and Android: there is no page setup dialog. The form of Page Setup like the one of Windows: the paper, the
	'orientation and the margins in millimeters. It is made at the first Execute (a form made before the main form
	'would be the main form); the values are read in the click of OK (a closed form has no elements)
	Namespace My.Sys.Forms
	Type PageSetupForm Extends Form
		Dim As Label lblPaper, lblOrientation, lblMargins, lblLeft, lblRight, lblTop, lblBottom
		Dim As ComboBoxEdit cboPaper
		Dim As RadioButton optPortrait, optLandscape
		Dim As TextBox txtLeft, txtRight, txtTop, txtBottom
		Dim As CommandButton cmdOK, cmdCancel
		PaperIndex As Integer
		Landscape As Boolean
		Margins(3) As Single
		Declare Sub AddLabel(ByRef lbl As Label, ByRef Caption As WString, x As Integer, y As Integer, w As Integer)
		Declare Sub AddTextBox(ByRef txt As TextBox, x As Integer, y As Integer)
		Declare Sub cmdOK_Click(ByRef Sender As Control)
		Declare Sub cmdCancel_Click(ByRef Sender As Control)
		Declare Constructor
	End Type
	
	Sub PageSetupForm.AddLabel(ByRef lbl As Label, ByRef Caption As WString, x As Integer, y As Integer, w As Integer)
		lbl.Text = Caption
		lbl.SetBounds x, y, w, 16
		lbl.Parent = @This
	End Sub
	
	Sub PageSetupForm.AddTextBox(ByRef txt As TextBox, x As Integer, y As Integer)
		txt.SetBounds x, y, 60, 21
		txt.Parent = @This
	End Sub
	
	Sub PageSetupForm.cmdOK_Click(ByRef Sender As Control)
		PaperIndex = cboPaper.ItemIndex
		Landscape = optLandscape.Checked
		Margins(0) = Val(txtLeft.Text): Margins(1) = Val(txtTop.Text)
		Margins(2) = Val(txtRight.Text): Margins(3) = Val(txtBottom.Text)
		ModalResult = ModalResults.OK
		CloseForm
	End Sub
	
	Sub PageSetupForm.cmdCancel_Click(ByRef Sender As Control)
		ModalResult = ModalResults.Cancel
		CloseForm
	End Sub
	
	Constructor PageSetupForm
		Name = "frmPageSetup"
		Caption = "Page Setup"
		BorderStyle = FormBorderStyle.FixedDialog
		MinimizeBox = False
		MaximizeBox = False
		StartPosition = FormStartPosition.CenterParent
		SetBounds 0, 0, 310, 215
		AddLabel lblPaper, "Paper size:", 10, 12, 85
		With cboPaper
			.Style = cbDropDownList
			.AddItem "A4 (210 x 297 mm)"
			.AddItem "A3 (297 x 420 mm)"
			.AddItem "Letter (8.5 x 11 in)"
			.AddItem "Legal (8.5 x 14 in)"
			.AddItem "Tabloid (11 x 17 in)"
			.AddItem "Executive (7.25 x 10.5 in)"
			.AddItem "Statement (5.5 x 8.5 in)"
			.SetBounds 100, 8, 190, 21
			.Parent = @This
		End With
		AddLabel lblOrientation, "Orientation:", 10, 42, 85
		With optPortrait
			.Text = "Portrait"
			.SetBounds 100, 40, 90, 20
			.Parent = @This
		End With
		With optLandscape
			.Text = "Landscape"
			.SetBounds 195, 40, 95, 20
			.Parent = @This
		End With
		AddLabel lblMargins, "Margins (millimeters):", 10, 70, 280
		AddLabel lblLeft, "Left:", 10, 96, 45
		AddTextBox txtLeft, 55, 92
		AddLabel lblRight, "Right:", 150, 96, 45
		AddTextBox txtRight, 200, 92
		AddLabel lblTop, "Top:", 10, 124, 45
		AddTextBox txtTop, 55, 120
		AddLabel lblBottom, "Bottom:", 150, 124, 45
		AddTextBox txtBottom, 200, 120
		With cmdOK
			.Text = "OK"
			.Default = True
			.SetBounds 120, 152, 80, 25
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdOK_Click)
			.Parent = @This
		End With
		With cmdCancel
			.Text = "Cancel"
			.Cancel = True
			.SetBounds 210, 152, 80, 25
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdCancel_Click)
			.Parent = @This
		End With
		DefaultButton = @cmdOK
		CancelButton = @cmdCancel
	End Constructor
	End Namespace
#endif

'Property PageSetupDialog.Left() As Integer: Return xLeft: End Property
'Property PageSetupDialog.Left(value As Integer): xLeft=value: End Property
Private Property PageSetupDialog.PrinterName() As String: Return xPrinterName: End Property
Private Property PageSetupDialog.PrinterName(value As String): End Property            ' Read only
'Property PageSetupDialog.Top() As Integer: Return xTop: End Property
'Property PageSetupDialog.Top(value As Integer): xTop=value: End Property

#ifdef __USE_WINAPI__
	Private Function PageSetupDialog.PageHookProc(hWnd As HWND, uMsg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
		If uMsg = WM_INITDIALOG Then                              ' ALL initializing is done here
			Dim As PAGESETUPDLG Ptr lpPSD = Cast(PAGESETUPDLG Ptr, lParam)
			Dim As PageSetupDialog Ptr lpPSDDlg = Cast(PageSetupDialog Ptr, lpPSD->lCustData)
			Dim As Integer X, Y, W, H
			'X=lpPSDDlg->xLeft: Y=lpPSDDlg->xTop
			'If (X<0) Or (Y<0) Then
				Dim As Rect rct
				GetWindowRect(hWnd, @rct)
				If X=0 Then W=rct.Right-rct.Left: X=(GetSystemMetrics(SM_CXSCREEN) - W)\2
				If Y=0 Then H=rct.Bottom-rct.Top: Y=(GetSystemMetrics(SM_CYSCREEN) - H)\2
			'End If
			SetWindowPos(hWnd, 0, X, Y, 0, 0, SWP_NOSIZE Or SWP_NOZORDER)
			If lpPSDDlg->Caption <> "" Then SetWindowText(hWnd, lpPSDDlg->Caption)
			If lpPSDDlg AndAlso lpPSDDlg->Orientation = PrinterOrientation.poLandscape Then
				SendMessage(GetDlgItem(hWnd, 1057), BM_CLICK, 0, 0)
			End If
			Return 1
		End If
		Return 0
	End Function
#endif

Private Function PageSetupDialog.Execute() As Boolean
	#ifdef __USE_GTK__
		Dim As GtkWindow Ptr win
		If pApp AndAlso pApp->ActiveForm AndAlso GTK_IS_WINDOW(pApp->ActiveForm->widget) Then
			win = GTK_WINDOW(pApp->ActiveForm->widget)
		ElseIf pApp AndAlso pApp->MainForm AndAlso GTK_IS_WINDOW(pApp->MainForm->widget) Then
			win = GTK_WINDOW(pApp->MainForm->widget)
		End If
		Dim As GtkUnit Unit_ = GTK_UNIT_MM
		If Metric = 0 Then Unit_ = GTK_UNIT_INCH

		' Initial paper: known sizes by name, otherwise custom from PaperWidth/PaperHeight
		Dim As GtkPaperSize Ptr Paper
		Select Case PaperSize
		Case PrinterPaperSize.ppsA4: Paper = gtk_paper_size_new("iso_a4")
		Case PrinterPaperSize.ppsLetter: Paper = gtk_paper_size_new("na_letter")
		Case PrinterPaperSize.ppsLEGALr: Paper = gtk_paper_size_new("na_legal")
		Case Else
			If PaperWidth > 0 AndAlso PaperHeight > 0 Then
				' Paper sizes are portrait, orientation is set separately
				If PaperWidth <= PaperHeight Then
					Paper = gtk_paper_size_new_custom("custom", "Custom", PaperWidth, PaperHeight, Unit_)
				Else
					Paper = gtk_paper_size_new_custom("custom", "Custom", PaperHeight, PaperWidth, Unit_)
				End If
			Else
				Paper = gtk_paper_size_new(NULL)
			End If
		End Select

		Dim As GtkPageSetup Ptr OldSetup = gtk_page_setup_new()
		gtk_page_setup_set_paper_size(OldSetup, Paper)
		gtk_paper_size_free(Paper)
		If Orientation = PrinterOrientation.poLandscape Then
			gtk_page_setup_set_orientation(OldSetup, GTK_PAGE_ORIENTATION_LANDSCAPE)
		Else
			gtk_page_setup_set_orientation(OldSetup, GTK_PAGE_ORIENTATION_PORTRAIT)
		End If

		Dim As GtkPrintSettings Ptr Settings = gtk_print_settings_new()
		If xPrinterName <> "" Then gtk_print_settings_set_printer(Settings, xPrinterName)

		Dim As GtkPageSetup Ptr NewSetup = gtk_print_run_page_setup_dialog(win, OldSetup, Settings)

		' The dialog always returns a page setup (a copy of the old one on Cancel), so compare
		Dim As Boolean bChanged
		If NewSetup Then
			Dim As GtkPaperSize Ptr OldPaper = gtk_page_setup_get_paper_size(OldSetup)
			Dim As GtkPaperSize Ptr NewPaper = gtk_page_setup_get_paper_size(NewSetup)
			bChanged = gtk_paper_size_is_equal(OldPaper, NewPaper) = 0 OrElse _
				gtk_page_setup_get_orientation(OldSetup) <> gtk_page_setup_get_orientation(NewSetup)
			If bChanged Then
				Select Case *gtk_paper_size_get_name(NewPaper)
				Case "iso_a4": PaperSize = PrinterPaperSize.ppsA4
				Case "na_letter": PaperSize = PrinterPaperSize.ppsLetter
				Case "na_legal": PaperSize = PrinterPaperSize.ppsLEGALr
				End Select
				If gtk_page_setup_get_orientation(NewSetup) = GTK_PAGE_ORIENTATION_LANDSCAPE Then
					Orientation = PrinterOrientation.poLandscape
				Else
					Orientation = PrinterOrientation.poPortait
				End If
				' Sizes with orientation applied, like ptPaperSize on WinAPI
				PaperWidth = gtk_page_setup_get_paper_width(NewSetup, Unit_)
				PaperHeight = gtk_page_setup_get_paper_height(NewSetup, Unit_)
				' The dialog does not edit margins: keep the user margins, report the paper defaults as minimum
				MinLeftMargin = gtk_page_setup_get_left_margin(NewSetup, Unit_)
				MinTopMargin = gtk_page_setup_get_top_margin(NewSetup, Unit_)
				MinRightMargin = gtk_page_setup_get_right_margin(NewSetup, Unit_)
				MinBottomMargin = gtk_page_setup_get_bottom_margin(NewSetup, Unit_)
				Dim As Const gchar Ptr pPrinter = gtk_print_settings_get_printer(Settings)
				If pPrinter Then xPrinterName = *pPrinter
			End If
			g_object_unref(NewSetup)
		End If
		g_object_unref(Settings)
		g_object_unref(OldSetup)
		Return bChanged
	#elseif defined(__USE_WINAPI__)
		Dim As PAGESETUPDLG psd
		Dim As Double value, divsor=100.0                                  ' Default metric
		
		'Clear(@psd, 0, SizeOf(PAGESETUPDLG))
		psd.lStructSize=SizeOf(PAGESETUPDLG)
		psd.hwndOwner=pApp->MainForm->Handle
		psd.lCustData=Cast(LPARAM, @This)                        ' Pass ptr to printdlg struc
		psd.Flags = PSD_ENABLEPAGESETUPHOOK Or PSD_MARGINS
		If Metric Then
			psd.Flags Or= PSD_INHUNDREDTHSOFMILLIMETERS
		Else
			psd.Flags Or= PSD_INTHOUSANDTHSOFINCHES
		End If
		Dim As DEVMODE Ptr dm
		Dim As DEVMODE dmm
		psd.hDevMode = GlobalAlloc(GMEM_MOVEABLE Or GMEM_ZEROINIT, SizeOf(DEVMODE))
		If psd.hDevMode Then
			dm = Cast(DEVMODE Ptr, GlobalLock(psd.hDevMode))
			If dm Then
				dmm.dmSize = SizeOf(DEVMODE)
				dmm.dmFields = DM_ORIENTATION Or DM_PAPERSIZE
				dmm.dmOrientation = Orientation
				dmm.dmPaperSize = PaperSize
				memcpy dm, @dmm, SizeOf(DEVMODE)
			End If
			GlobalUnlock(psd.hDevMode)
		End If
		If Metric Then
			psd.ptPaperSize.X = PaperWidth * 100.0: psd.ptPaperSize.Y = PaperHeight * 100.0
			psd.rtMargin.Left = LeftMargin * 100.0: psd.rtMargin.Top = TopMargin * 100.0
			psd.rtMargin.Right = RightMargin * 100.0: psd.rtMargin.Bottom = BottomMargin * 100.0
		Else
			psd.ptPaperSize.X = PaperWidth * 1000.0: psd.ptPaperSize.Y = PaperHeight * 1000.0
			psd.rtMargin.Left = LeftMargin * 1000.0: psd.rtMargin.Top = TopMargin * 1000.0
			psd.rtMargin.Right = RightMargin * 1000.0: psd.rtMargin.Bottom = BottomMargin * 1000.0
		End If
		psd.lpfnPageSetupHook=Cast(LPPAGESETUPHOOK, @PageHookProc)
		If PAGESETUPDLG(@psd) Then
			Dim As DEVNAMES Ptr dn
			dn = GlobalLock(psd.hDevNames)
			xPrinterName = *Cast(ZString Ptr, Cast(Byte Ptr, dn) + dn->wDeviceOffset)
			GlobalUnlock(dn)
			dm = GlobalLock(psd.hDevMode)
			Orientation = dm->dmOrientation
			PaperSize = dm->dmPaperSize
			GlobalUnlock(dm)
			If Metric Then
				PaperWidth = psd.ptPaperSize.X / 100.0: PaperHeight = psd.ptPaperSize.Y / 100.0
				LeftMargin = psd.rtMargin.Left / 100.0: TopMargin = psd.rtMargin.Top / 100.0
				RightMargin = psd.rtMargin.Right / 100.0: BottomMargin = psd.rtMargin.Bottom / 100.0
			Else
				PaperWidth = psd.ptPaperSize.X / 1000.0: PaperHeight = psd.ptPaperSize.Y / 1000.0
				LeftMargin = psd.rtMargin.Left / 1000.0: TopMargin = psd.rtMargin.Top / 1000.0
				RightMargin = psd.rtMargin.Right / 1000.0: BottomMargin = psd.rtMargin.Bottom / 1000.0
			End If
			Return True
		End If
	#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
		Static As My.Sys.Forms.PageSetupForm Ptr frm
		If frm = 0 Then frm = _New(My.Sys.Forms.PageSetupForm)
		If frm = 0 OrElse pApp = 0 OrElse pApp->MainForm = 0 Then Return False
		With *frm
			If Caption <> "" Then .Caption = Caption
			.cboPaper.ItemIndex = 0
			For i As Integer = 0 To UBound(PageSetupPapers)
				If PageSetupPapers(i) = PaperSize Then .cboPaper.ItemIndex = i: Exit For
			Next
			.optPortrait.Checked = Orientation <> PrinterOrientation.poLandscape
			.optLandscape.Checked = Orientation = PrinterOrientation.poLandscape
			.txtLeft.Text = Str(LeftMargin): .txtTop.Text = Str(TopMargin)
			.txtRight.Text = Str(RightMargin): .txtBottom.Text = Str(BottomMargin)
			.ModalResult = 0
			If .ShowModal(*pApp->MainForm) <> My.Sys.Forms.ModalResults.OK Then Return False
			Dim As Integer Index = Max(0, Min(.PaperIndex, UBound(PageSetupPapers)))
			PaperSize = PageSetupPapers(Index)
			Orientation = IIf(.Landscape, PrinterOrientation.poLandscape, PrinterOrientation.poPortait)
			'The sizes with the orientation like on GTK
			PaperWidth = PageSetupPaperSizes(Index, IIf(.Landscape, 1, 0))
			PaperHeight = PageSetupPaperSizes(Index, IIf(.Landscape, 0, 1))
			If .Margins(0) >= 0 Then LeftMargin = .Margins(0)
			If .Margins(1) >= 0 Then TopMargin = .Margins(1)
			If .Margins(2) >= 0 Then RightMargin = .Margins(2)
			If .Margins(3) >= 0 Then BottomMargin = .Margins(3)
		End With
		Return True
	#endif
	Return False
End Function

Private Constructor PageSetupDialog
	WLet(FClassName, "PageSetupDialog")
	Orientation = PrinterOrientation.poPortait
	LeftMargin = 30
	TopMargin = 20
	RightMargin = 15
	BottomMargin = 20
	PaperWidth = 297
	PaperHeight = 210
	PaperSize = PrinterPaperSize.ppsA4
End Constructor
