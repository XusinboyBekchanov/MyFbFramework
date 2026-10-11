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
Private Property PrintDialog.SetupDialog() As Integer: Return xSetupDialog: End Property
Private Property PrintDialog.SetupDialog(value As Integer)
	If value Then xSetupDialog=True Else xSetupDialog=False
End Property

#ifndef __USE_GTK__
	' Currently, these two HookProcs are exactly the same code, but may change....
	Private Function PrintDialog.PrintHookProc(hWnd As HWND, uMsg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
		If uMsg=WM_INITDIALOG Then                              ' ALL initializing is done here
			Dim As PRINTDLG Ptr lpPRN=Cast(PRINTDLG Ptr,lParam)
			Dim As PrintDialog Ptr lpPRNDlg=Cast(PrintDialog Ptr, lpPRN->lCustData)
			Dim As Integer X, Y, W, H
			X=lpPRNDlg->Left: Y=lpPRNDlg->Top
			If (X<0) Or (Y<0) Then
				Dim As Rect rct
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
	Private Function PrintDialog.SetUpHookProc(hWnd As HWND, uMsg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
		If uMsg=WM_INITDIALOG Then                              ' ALL initializing is done here
			Dim As PRINTDLG Ptr lpPRN=Cast(PRINTDLG Ptr,lParam)
			Dim As PrintDialog Ptr lpPRNDlg=Cast(PrintDialog Ptr, lpPRN->lCustData)
			Dim As Integer X, Y, W, H
			X=lpPRNDlg->Left: Y=lpPRNDlg->Top
			If (X<0) Or (Y<0) Then
				Dim As Rect rct
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
#ifdef __USE_GTK__
	' Called when the user presses Print: the settings are taken and the operation is cancelled,
	' because this dialog only selects the printer and the page range
	Private Sub PrintDialog.BeginPrint(op As GtkPrintOperation Ptr, context As GtkPrintContext Ptr, user_data As gpointer)
		Dim As PrintDialog Ptr Dlg = Cast(Any Ptr, user_data)
		If Dlg Then Dlg->FAccepted = True
		gtk_print_operation_cancel(op)
	End Sub
#endif

' Handles either a Print Setup dialog or Printer dialog
Private Function PrintDialog.Execute() As Boolean
	#ifdef __USE_GTK__
		Dim As GtkWindow Ptr win
		If pApp AndAlso pApp->ActiveForm AndAlso GTK_IS_WINDOW(pApp->ActiveForm->widget) Then
			win = GTK_WINDOW(pApp->ActiveForm->widget)
		ElseIf pApp AndAlso pApp->MainForm AndAlso GTK_IS_WINDOW(pApp->MainForm->widget) Then
			win = GTK_WINDOW(pApp->MainForm->widget)
		End If
		If SetupDialog Then
			' GTK has no separate printer setup dialog, the page setup dialog is the closest one
			Dim As GtkPageSetup Ptr ps = gtk_print_run_page_setup_dialog(win, NULL, NULL)
			If ps Then g_object_unref(ps)
			Return True
		End If

		Dim As GtkPrintOperation Ptr op = gtk_print_operation_new()
		gtk_print_operation_set_n_pages(op, Max(1, ToPage))

		Dim As GtkPrintSettings Ptr Settings = gtk_print_settings_new()
		If PrinterName <> "" Then gtk_print_settings_set_printer(Settings, PrinterName)
		If FromPage > 0 AndAlso ToPage >= FromPage Then
			' GtkPageRange is {start, end}, zero based
			Dim As gint Range(1) = {FromPage - 1, ToPage - 1}
			gtk_print_settings_set_print_pages(Settings, GTK_PRINT_PAGES_RANGES)
			gtk_print_settings_set_page_ranges(Settings, Cast(GtkPageRange Ptr, @Range(0)), 1)
		End If
		gtk_print_operation_set_print_settings(op, Settings)
		g_object_unref(Settings)

		FAccepted = False
		g_signal_connect(op, "begin-print", G_CALLBACK(@BeginPrint), @This)
		gtk_print_operation_run(op, GTK_PRINT_OPERATION_ACTION_PRINT_DIALOG, win, NULL)

		If FAccepted Then
			Settings = gtk_print_operation_get_print_settings(op)
			If Settings Then
				Dim As Const gchar Ptr pPrinter = gtk_print_settings_get_printer(Settings)
				If pPrinter Then PrinterName = *pPrinter
				If gtk_print_settings_get_print_pages(Settings) = GTK_PRINT_PAGES_RANGES Then
					Dim As gint nRanges
					Dim As gint Ptr pRanges = Cast(gint Ptr, gtk_print_settings_get_page_ranges(Settings, @nRanges))
					If pRanges Then
						If nRanges > 0 Then
							FromPage = pRanges[0] + 1
							ToPage = pRanges[(nRanges - 1) * 2 + 1] + 1
						End If
						g_free(pRanges)
					End If
				End If
			End If
		End If
		g_object_unref(op)
		Return FAccepted
	#else
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
			pd.nFromPage=Cast(WORD,FromPage): pd.nToPage=Cast(WORD,ToPage)
		End If
		If PRINTDLG(@pd) Then
			Dim As DEVNAMES Ptr dn
			dn=GlobalLock(pd.hDevNames)
			PrinterName=*Cast(ZString Ptr, Cast(Byte Ptr, dn) + dn->wDeviceOffset)
			GlobalUnlock(dn)
			Return True
		End If
	#endif
	Return False
End Function

Private Constructor PrintDialog
	WLet(FClassName, "PrintDialog")
End Constructor
