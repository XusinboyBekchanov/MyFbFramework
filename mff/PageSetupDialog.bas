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
Property PageSetupDialog.PrinterName() As String: Return xPrinterName: End Property
Property PageSetupDialog.PrinterName(value As String): End Property            ' Read only
'Property PageSetupDialog.Top() As Integer: Return xTop: End Property
'Property PageSetupDialog.Top(value As Integer): xTop=value: End Property

#ifndef __USE_GTK__
	Function PageHookProc(hWnd As HWND, uMsg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
		If uMsg=WM_INITDIALOG Then                              ' ALL initializing is done here
			Dim As PAGESETUPDLG Ptr lpPSD=Cast(PAGESETUPDLG Ptr,lParam)
			Dim As PageSetupDialog Ptr lpPSDDlg=Cast(PageSetupDialog Ptr, lpPSD->lCustData)
			Dim As Integer X, Y, W, H
			'X=lpPSDDlg->xLeft: Y=lpPSDDlg->xTop
			'If (X<0) Or (Y<0) Then
				Dim As RECT rct
				GetWindowRect(hWnd, @rct)
				If X=0 Then W=rct.Right-rct.Left: X=(GetSystemMetrics(SM_CXSCREEN) - W)\2
				If Y=0 Then H=rct.Bottom-rct.Top: Y=(GetSystemMetrics(SM_CYSCREEN) - H)\2
			'End If
			SetWindowPos(hWnd, 0, X, Y, 0, 0, SWP_NOSIZE Or SWP_NOZORDER)
			If lpPSDDlg->Caption <> "" Then SetWindowText(hWnd, lpPSDDlg->Caption)
			Return 1
		End If
		Return 0
	End Function
#endif

Function PageSetupDialog.Execute() As Boolean
	#ifndef __USE_GTK__
		Dim As PAGESETUPDLG psd
		Dim As Double value, divsor=100.0                                  ' Default metric
		
		'Clear(@psd, 0, SizeOf(PAGESETUPDLG))
		psd.lStructSize=SizeOf(PAGESETUPDLG)
		psd.hwndOwner=pApp->MainForm->Handle
		psd.lCustData=Cast(LPARAM, @This)                        ' Pass ptr to printdlg struc
		psd.Flags=PSD_ENABLEPAGESETUPHOOK
		If Metric Then
			psd.Flags Or= PSD_INHUNDREDTHSOFMILLIMETERS
		Else
			psd.Flags Or= PSD_INTHOUSANDTHSOFINCHES
		End If
		psd.lpfnPageSetupHook=Cast(LPPAGESETUPHOOK, @PageHookProc)
		If PageSetupDlg(@psd) Then
			Dim As DEVNAMES Ptr dn
			dn=GlobalLock(psd.hDevNames)
			xPrinterName=*Cast(ZString Ptr, Cast(Byte Ptr, dn) + dn->wDeviceOffset)
			GlobalUnlock(dn)
			If Metric Then
				PaperWidth=psd.ptPaperSize.x/100.0: PaperHeight=psd.ptPaperSize.y/100.0
				LeftMargin=psd.rtMargin.Left/100.0: TopMargin=psd.rtMargin.Top/100.0
				RightMargin=psd.rtMargin.Right/100.0: BottomMargin=psd.rtMargin.Bottom/100.0
			Else
				PaperWidth=psd.ptPaperSize.x/1000.0: PaperHeight=psd.ptPaperSize.y/1000.0
				LeftMargin=psd.rtMargin.Left/1000.0: TopMargin=psd.rtMargin.Top/1000.0
				RightMargin=psd.rtMargin.Right/1000.0: BottomMargin=psd.rtMargin.Bottom/1000.0
			End If
			Return True
		End If
	#endif
	Return False
End Function

Constructor PageSetupDialog
	WLet FClassName, "PageSetupDialog"
End Constructor
