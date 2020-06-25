'################################################################################
'#  PrintDialog.bas                                                             #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Aloberoger, Xusinboy Bekchanov                                     #
'#  Based on:                                                                   #
'#   TPrintDialog.bas                                                           #
'#   GUITK-S Windows GUI FB Wrapper Library                                     #
'#   Copyright (c) Aloberoger                                                   #
'################################################################################

#include once "PrintDialog.bi"

'Property PrintDialog.Left() As Integer: Return xLeft: End Property
'Property PrintDialog.Left(value As Integer): xLeft=value: End Property
'Property PrintDialog.Top() As Integer: Return xTop: End Property
'Property PrintDialog.Top(value As Integer): xTop=value: End Property
Property PrintDialog.SetupDialog() As Integer: Return xSetupDialog: End Property
Property PrintDialog.SetupDialog(value As Integer)
	If value Then xSetupDialog=True Else xSetupDialog=False
End Property

#ifndef __USE_GTK__
	' Currently, these two HookProcs are exactly the same code, but may change....
	Function PrintHookProc(hWnd As HWND, uMsg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
		If uMsg=WM_INITDIALOG Then                              ' ALL initializing is done here
			Dim As PRINTDLG Ptr lpPRN=Cast(PRINTDLG Ptr,lParam)
			Dim As PrintDialog Ptr lpPRNDlg=Cast(PrintDialog Ptr, lpPRN->lCustData)
			Dim As Integer X, Y, W, H
			X=lpPRNDlg->Left: Y=lpPRNDlg->Top
			If (X<0) Or (Y<0) Then
				Dim As RECT rct
				GetWindowRect(hWnd, @rct)
				If X<0 Then W=rct.Right-rct.Left: X=(GetSystemMetrics(SM_CXSCREEN) - W)\2
				If Y<0 Then H=rct.Bottom-rct.Top: Y=(GetSystemMetrics(SM_CYSCREEN) - H)\2
			End If
			SetWindowPos(hWnd, 0, X, Y, 0, 0, SWP_NOSIZE Or SWP_NOZORDER)
			If lpPRNDlg->Caption <> "" Then SetWindowText(hWnd, lpPRNDlg->Caption)
			Return 1
		End If
		Return 0
	End Function
	Function SetUpHookProc(hWnd As HWND, uMsg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
		If uMsg=WM_INITDIALOG Then                              ' ALL initializing is done here
			Dim As PRINTDLG Ptr lpPRN=Cast(PRINTDLG Ptr,lParam)
			Dim As PrintDialog Ptr lpPRNDlg=Cast(PrintDialog Ptr, lpPRN->lCustData)
			Dim As Integer X, Y, W, H
			X=lpPRNDlg->Left: Y=lpPRNDlg->Top
			If (X<0) Or (Y<0) Then
				Dim As RECT rct
				GetWindowRect(hWnd, @rct)
				If X<0 Then W=rct.Right-rct.Left: X=(GetSystemMetrics(SM_CXSCREEN) - W)\2
				If Y<0 Then H=rct.Bottom-rct.Top: Y=(GetSystemMetrics(SM_CYSCREEN) - H)\2
			End If
			SetWindowPos(hWnd, 0, X, Y, 0, 0, SWP_NOSIZE Or SWP_NOZORDER)
			If lpPRNDlg->Caption <> "" Then SetWindowText(hWnd, lpPRNDlg->Caption)
			Return 1
		End If
		Return 0
	End Function
#endif
' Handles either a Print Setup dialog or Printer dialog
Function PrintDialog.Execute() As Boolean
	#ifndef __USE_GTK__
		Dim As PRINTDLG pd
		
		'Clear(@pd, 0, SizeOf(PRINTDLG))
		pd.lStructSize=SizeOf(PRINTDLG)
		pd.hwndOwner=pApp->MainForm->Handle
		pd.lCustData=Cast(LPARAM, @This)                        ' Pass ptr to printdlg struc
		If SetupDialog Then
			pd.Flags=PD_PRINTSETUP Or PD_ENABLESETUPHOOK
			pd.lpfnSetupHook=Cast(LPSETUPHOOKPROC, @SetUpHookProc)
		Else
			pd.lpfnPrintHook=Cast(LPPRINTHOOKPROC, @PrintHookProc)
			pd.Flags=PD_ENABLEPRINTHOOK                             ' OR PD_PAGENUMS causes error!
			If AllowToFile=False Then pd.Flags=pd.Flags Or PD_HIDEPRINTTOFILE
			If AllowToNetwork=False Then pd.Flags=pd.Flags Or PD_NONETWORKBUTTON
			If ShowHelpButton Then pd.Flags=pd.Flags Or PD_SHOWHELP
			pd.nFromPage=Cast(word,FromPage): pd.nToPage=Cast(word,ToPage)
		End If
		If PrintDlg(@pd) Then
			Dim As DEVNAMES Ptr dn
			dn=GlobalLock(pd.hDevNames)
			PrinterName=*Cast(ZString Ptr, Cast(Byte Ptr, dn) + dn->wDeviceOffset)
			GlobalUnlock(dn)
			Return True
		End If
	#endif
	Return False
End Function

Constructor PrintDialog
	WLet FClassName, "PrintDialog"
End Constructor
