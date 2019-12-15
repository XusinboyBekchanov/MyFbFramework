'################################################################################
'#  PageSetupDialog.bi                                                          #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Aloberoger, Xusinboy Bekchanov                                     #
'#  Based on:                                                                   #
'#   TPageSetupDLG.bi                                                           #
'#   GUITK-S Windows GUI FB Wrapper Library                                     #
'#   Copyright (c) Aloberoger                                                   #
'################################################################################

#Include Once "Dialogs.bi"

TYPE PageSetupDialog Extends Dialog
	xLeft AS integer        = -1                        ' Default to center
	xTop AS integer         = -1                        ' ditto
	Width AS integer                                    ' Not used
	Height AS integer                                   ' Not used
	Caption AS string       = ""
	
	Metric AS integer       = True                      ' mm (True) or inches?
	PaperWidth AS single                                ' Converted to mm: ptPaperSize AS POINT (in 100ths of mm)
	PaperHeight AS single
	MinLeftMargin AS single                             '|
	MinTopMargin AS single                              '| rtMinMargin AS RECT
	MinRightMargin AS single                            '| Converted to mm
	MinBottomMargin AS single                           '|
	LeftMargin AS single                                '|
	TopMargin AS single                                 '| rtMargin AS RECT
	RightMargin AS single                               '| Converted to mm
	BottomMargin AS single                              '|
	
	xPrinterName AS string
	
	DECLARE PROPERTY Left() AS integer
	DECLARE PROPERTY Left(value AS integer)
	DECLARE PROPERTY PrinterName() AS string
	DECLARE PROPERTY PrinterName(value AS string)
	DECLARE PROPERTY Top() AS integer
	DECLARE PROPERTY Top(value AS integer)
	
	DECLARE FUNCTION Execute() AS Boolean
	
END Type

#IfNDef __USE_MAKE__
	#Include Once "PageSetupDialog.bas"
#EndIf
