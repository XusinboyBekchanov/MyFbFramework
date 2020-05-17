'################################################################################
'#  PageSetupDialog.bas                                                         #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Aloberoger, Xusinboy Bekchanov                                     #
'#  Based on:                                                                   #
'#   TPageSetupDLG.bas                                                          #
'#   GUITK-S Windows GUI FB Wrapper Library                                     #
'#   Copyright (c) Aloberoger                                                   #
'################################################################################

#Include Once "PageSetupDialog.bi"

PROPERTY PageSetupDialog.Left() AS integer: RETURN xLeft: END PROPERTY
PROPERTY PageSetupDialog.Left(value AS integer): xLeft=value: END PROPERTY
PROPERTY PageSetupDialog.PrinterName() AS string: RETURN xPrinterName: END PROPERTY
PROPERTY PageSetupDialog.PrinterName(value AS string): END PROPERTY            ' Read only
PROPERTY PageSetupDialog.Top() AS integer: RETURN xTop: END PROPERTY
PROPERTY PageSetupDialog.Top(value AS integer): xTop=value: END PROPERTY

#IfNDef __USE_GTK__
	FUNCTION PageHookProc(hWnd AS HWND, uMsg AS UINT, wParam AS WPARAM, lParam AS LPARAM) AS LRESULT
		IF uMsg=WM_INITDIALOG THEN                              ' ALL initializing is done here
			DIM AS PAGESETUPDLG PTR lpPSD=CAST(PAGESETUPDLG PTR,lParam)
			DIM AS PageSetupDialog PTR lpPSDDlg=CAST(PageSetupDialog PTR, lpPSD->lCustData)
			DIM AS integer X, Y, W, H
			X=lpPSDDlg->Left: Y=lpPSDDlg->Top
			IF (X<0) OR (Y<0) THEN
				DIM AS RECT rct
				GetWindowRect(hWnd, @rct)
				IF X<0 THEN W=rct.Right-rct.Left: X=(GetSystemMetrics(SM_CXSCREEN) - W)\2
				IF Y<0 THEN H=rct.Bottom-rct.Top: Y=(GetSystemMetrics(SM_CYSCREEN) - H)\2
			END IF
			SetWindowPos(hWnd, 0, X, Y, 0, 0, SWP_NOSIZE OR SWP_NOZORDER)
			IF lpPSDDlg->Caption <> "" THEN SetWindowText(hWnd, lpPSDDlg->Caption)
			RETURN 1
		END IF
		RETURN 0
	END FUNCTION
#EndIf

FUNCTION PageSetupDialog.Execute() AS Boolean
	#IfNDef __USE_GTK__
		DIM AS PAGESETUPDLG psd
		DIM AS double value, divsor=100.0                                  ' Default metric
		
		CLEAR(@psd, 0, SIZEOF(PAGESETUPDLG))
		psd.lStructSize=SIZEOF(PAGESETUPDLG)
		psd.hwndOwner=pApp->MainForm->Handle
		psd.lCustData=CAST(LPARAM, @THIS)                        ' Pass ptr to printdlg struc
		psd.Flags=PSD_ENABLEPAGESETUPHOOK
		IF Metric THEN
			psd.Flags OR= PSD_INHUNDREDTHSOFMILLIMETERS
		ELSE
			psd.Flags OR= PSD_INTHOUSANDTHSOFINCHES
		END IF
		psd.lpfnPageSetupHook=CAST(LPPAGESETUPHOOK, @PageHookProc)
		IF PageSetupDlg(@psd) THEN
			DIM AS DEVNAMES PTR dn
			dn=GlobalLock(psd.hDevNames)
			xPrinterName=*CAST(zString PTR, CAST(BYTE PTR, dn) + dn->wDeviceOffset)
			GlobalUnlock(dn)
			IF Metric THEN
				PaperWidth=psd.ptPaperSize.x/100.0: PaperHeight=psd.ptPaperSize.y/100.0
				LeftMargin=psd.rtMargin.Left/100.0: TopMargin=psd.rtMargin.Top/100.0
				RightMargin=psd.rtMargin.Right/100.0: BottomMargin=psd.rtMargin.Bottom/100.0
			ELSE
				PaperWidth=psd.ptPaperSize.x/1000.0: PaperHeight=psd.ptPaperSize.y/1000.0
				LeftMargin=psd.rtMargin.Left/1000.0: TopMargin=psd.rtMargin.Top/1000.0
				RightMargin=psd.rtMargin.Right/1000.0: BottomMargin=psd.rtMargin.Bottom/1000.0
			END IF
			RETURN True
		END IF
	#EndIf
	RETURN False
END FUNCTION
