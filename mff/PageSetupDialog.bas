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

'Property PageSetupDialog.Left() As Integer: Return xLeft: End Property
'Property PageSetupDialog.Left(value As Integer): xLeft=value: End Property
Private Property PageSetupDialog.PrinterName() As String: Return xPrinterName: End Property
Private Property PageSetupDialog.PrinterName(value As String): End Property            ' Read only
'Property PageSetupDialog.Top() As Integer: Return xTop: End Property
'Property PageSetupDialog.Top(value As Integer): xTop=value: End Property

#ifndef __USE_GTK__
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
	#ifndef __USE_GTK__
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
