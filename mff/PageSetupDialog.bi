﻿'################################################################################
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
