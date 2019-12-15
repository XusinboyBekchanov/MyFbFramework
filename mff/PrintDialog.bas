'################################################################################
'#  PrintDialog.bas                                                             #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Aloberoger, Xusinboy Bekchanov                                     #
'#  Based on:                                                                   #
'#   TPrintDialog.bas                                                           #
'#   GUITK-S Windows GUI FB Wrapper Library                                     #
'#   Copyright (c) Aloberoger                                                   #
'################################################################################

#Include Once "PrintDialog.bi"

PROPERTY PrintDialog.Left() AS integer: RETURN xLeft: END PROPERTY
PROPERTY PrintDialog.Left(value AS integer): xLeft=value: END PROPERTY
PROPERTY PrintDialog.Top() AS integer: RETURN xTop: END PROPERTY
PROPERTY PrintDialog.Top(value AS integer): xTop=value: END PROPERTY
PROPERTY PrintDialog.SetupDialog() AS integer: RETURN xSetupDialog: END PROPERTY
PROPERTY PrintDialog.SetupDialog(value AS integer)
	IF value THEN xSetupDialog=True ELSE xSetupDialog=False
END PROPERTY

#IfNDef __USE_GTK__
	' Currently, these two HookProcs are exactly the same code, but may change....
	FUNCTION PrintHookProc(hWnd AS HWND, uMsg AS UINT, wParam AS WPARAM, lParam AS LPARAM) AS LRESULT
		IF uMsg=WM_INITDIALOG THEN                              ' ALL initializing is done here
			DIM AS PRINTDLG PTR lpPRN=CAST(PRINTDLG PTR,lParam)
			DIM AS PrintDialog PTR lpPRNDlg=CAST(PrintDialog PTR, lpPRN->lCustData)
			DIM AS integer X, Y, W, H
			X=lpPRNDlg->Left: Y=lpPRNDlg->Top
			IF (X<0) Or (Y<0) THEN
				DIM AS RECT rct
				GetWindowRect(hWnd, @rct)
				IF X<0 THEN W=rct.Right-rct.Left: X=(GetSystemMetrics(SM_CXSCREEN) - W)\2
				IF Y<0 THEN H=rct.Bottom-rct.Top: Y=(GetSystemMetrics(SM_CYSCREEN) - H)\2
			END IF
			SetWindowPos(hWnd, 0, X, Y, 0, 0, SWP_NOSIZE OR SWP_NOZORDER)
			IF lpPRNDlg->Caption <> "" THEN SetWindowText(hWnd, lpPRNDlg->Caption)
			RETURN 1
		END IF
		RETURN 0
	END FUNCTION
	FUNCTION SetUpHookProc(hWnd AS HWND, uMsg AS UINT, wParam AS WPARAM, lParam AS LPARAM) AS LRESULT
		IF uMsg=WM_INITDIALOG THEN                              ' ALL initializing is done here
			DIM AS PRINTDLG PTR lpPRN=CAST(PRINTDLG PTR,lParam)
			DIM AS PrintDialog PTR lpPRNDlg=CAST(PrintDialog PTR, lpPRN->lCustData)
			DIM AS integer X, Y, W, H
			X=lpPRNDlg->Left: Y=lpPRNDlg->Top
			IF (X<0) OR (Y<0) THEN
				DIM AS RECT rct
				GetWindowRect(hWnd, @rct)
				IF X<0 THEN W=rct.Right-rct.Left: X=(GetSystemMetrics(SM_CXSCREEN) - W)\2
				IF Y<0 THEN H=rct.Bottom-rct.Top: Y=(GetSystemMetrics(SM_CYSCREEN) - H)\2
			END IF
			SetWindowPos(hWnd, 0, X, Y, 0, 0, SWP_NOSIZE OR SWP_NOZORDER)
			IF lpPRNDlg->Caption <> "" THEN SetWindowText(hWnd, lpPRNDlg->Caption)
			RETURN 1
		END IF
		RETURN 0
	END FUNCTION
#EndIf
' Handles either a Print Setup dialog or Printer dialog
FUNCTION PrintDialog.Execute() As Boolean
	#IfNDef __USE_GTK__
		DIM AS PRINTDLG pd
		
		CLEAR(@pd, 0, SIZEOF(PRINTDLG))
		pd.lStructSize=SIZEOF(PRINTDLG)
		pd.hwndOwner=pApp->MainForm->Handle
		pd.lCustData=CAST(LPARAM, @THIS)                        ' Pass ptr to printdlg struc
		IF SetupDialog THEN
			pd.Flags=PD_PRINTSETUP OR PD_ENABLESETUPHOOK
			pd.lpfnSetupHook=CAST(LPSETUPHOOKPROC, @SetUpHookProc)
		ELSE
			pd.lpfnPrintHook=CAST(LPPRINTHOOKPROC, @PrintHookProc)
			pd.Flags=PD_ENABLEPRINTHOOK                             ' OR PD_PAGENUMS causes error!
			IF AllowToFile=False THEN pd.Flags=pd.Flags OR PD_HIDEPRINTTOFILE
			IF AllowToNetwork=False THEN pd.Flags=pd.Flags OR PD_NONETWORKBUTTON
			IF ShowHelpButton THEN pd.Flags=pd.Flags OR PD_SHOWHELP
			pd.nFromPage=CAST(word,FromPage): pd.nToPage=CAST(word,ToPage)
		END IF
		IF PrintDlg(@pd) THEN
			DIM AS DEVNAMES PTR dn
			dn=GlobalLock(pd.hDevNames)
			PrinterName=*CAST(zString PTR, CAST(BYTE PTR, dn) + dn->wDeviceOffset)
			GlobalUnlock(dn)
			RETURN True
		END IF
	#EndIf
	RETURN False
END Function
