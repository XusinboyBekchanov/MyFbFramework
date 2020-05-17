'################################################################################
'#  PrintDialog.bi                                                              #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Aloberoger, Xusinboy Bekchanov                                     #
'#  Based on:                                                                   #
'#   TPrintDialog.bi                                                            #
'#   GUITK-S Windows GUI FB Wrapper Library                                     #
'#   Copyright (c) Aloberoger                                                   #
'################################################################################

#Include Once "Dialogs.bi"

TYPE PrintDialog Extends Dialog
Private:
	xLeft AS integer        = -1                        ' Default to center
	xTop AS integer         = -1
Public:
	Width AS integer                                    ' Not used
	Height AS integer                                   ' Not used
	Caption AS string       = ""
	
	xSetupDialog AS integer = False                     ' SetupDialog or PrintDialog
	PrinterName AS string
	AllowToFile AS integer      = True
	AllowToNetwork AS integer   = True
	ShowHelpButton AS integer   = False
	HelpFile AS string      = ""
	FromPage AS integer     = 1
	ToPage AS integer       = 3
	
	DECLARE PROPERTY Left() AS integer
	DECLARE PROPERTY Left(value AS integer)
	DECLARE PROPERTY Top() AS integer
	DECLARE PROPERTY Top(value AS integer)
	DECLARE PROPERTY SetupDialog() AS integer
	DECLARE PROPERTY SetupDialog(value AS integer)
	
	DECLARE FUNCTION Execute() AS Boolean
	
END TYPE

#IfNDef __USE_MAKE__
	#Include Once "PrintDialog.bas"
#EndIf
