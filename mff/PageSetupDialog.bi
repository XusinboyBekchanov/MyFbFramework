'################################################################################
'#  PageSetupDialog.bi                                                          #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Aloberoger, Xusinboy Bekchanov                                     #
'#  Based on:                                                                   #
'#   TPageSetupDLG.bi                                                           #
'#   GUITK-S Windows GUI FB Wrapper Library                                     #
'#   Copyright (c) Aloberoger                                                   #
'################################################################################

#include once "Dialogs.bi"
#include once "Printer.bi"
#if defined(__USE_WASM__) OrElse defined(__USE_JNI__) OrElse defined(__USE_APPLE__)
	'Web and Android: the form of Page Setup (PageSetupDialog.Execute)
	#include once "Form.bi"
	#include once "Label.bi"
	#include once "ComboBoxEdit.bi"
	#include once "RadioButton.bi"
	#include once "TextBox.bi"
	#include once "CommandButton.bi"

	Using My.Sys.Forms
#endif

'Enables users to change page-related print settings, including margins and paper orientation.
Private Type PageSetupDialog Extends Dialog
Private:
	xLeft As Integer        = -1                        ' Default to center
	xTop As Integer         = -1                        ' ditto
	xWidth As Integer                                    ' Not used
	xHeight As Integer                                   ' Not used
	xPrinterName As String
	#ifdef __USE_WINAPI__
		Declare Static Function PageHookProc(hWnd As HWND, uMsg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
	#endif
	#if defined(__USE_WASM__) OrElse defined(__USE_JNI__) OrElse defined(__USE_APPLE__)
		'Web, Android and Apple: there is no page setup dialog, the form of Page Setup like the one of Windows (like
		'frmDialog of PrintPreviewDialog); the values are read in the click of OK (a closed form has no elements)
		Declare Sub AddLabel(ByRef lbl As Label, ByRef LabelCaption As WString, x As Integer, y As Integer, w As Integer)
		Declare Sub AddTextBox(ByRef txt As TextBox, x As Integer, y As Integer)
		Declare Sub cmdOK_Click(ByRef Sender As Control)
		Declare Sub cmdCancel_Click(ByRef Sender As Control)

		Dim As Form frmDialog
		Dim As Label lblPaper, lblOrientation, lblMargins, lblLeft, lblRight, lblTop, lblBottom
		Dim As ComboBoxEdit cboPaper
		Dim As RadioButton optPortrait, optLandscape
		Dim As TextBox txtLeft, txtRight, txtTop, txtBottom
		Dim As CommandButton cmdOK, cmdCancel
		FPaperIndex As Integer
		FLandscape As Boolean
		FMargins(3) As Single
	#endif
Public:
	Caption As String       = ""
	
	Metric As Integer       = True                      ' mm (True) or inches?
	Orientation As PrinterOrientation
	PaperWidth As Single                                ' Converted to mm: ptPaperSize AS POINT (in 100ths of mm)
	PaperHeight As Single
	PaperSize As PrinterPaperSize
	MinLeftMargin As Single                             '|
	MinTopMargin As Single                              '| rtMinMargin AS RECT
	MinRightMargin As Single                            '| Converted to mm
	MinBottomMargin As Single                           '|
	LeftMargin As Single                                '|
	TopMargin As Single                                 '| rtMargin AS RECT
	RightMargin As Single                               '| Converted to mm
	BottomMargin As Single                              '|
	
	'Declare Property Left() As Integer
	'Declare Property Left(value As Integer)
	Declare Property PrinterName() As String
	Declare Property PrinterName(value As String)
	'Declare Property Top() As Integer
	'Declare Property Top(value As Integer)
	
	Declare Function Execute() As Boolean
	Declare Constructor
End Type

#ifndef __USE_MAKE__
	#include once "PageSetupDialog.bas"
#endif
