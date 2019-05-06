'###############################################################################
'#  Graphics.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TGraphics.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#Include Once "Object.bi"

'Namespace My.Sys.Drawing
#IfDef __USE_GTK__
	#Define clScrollBar           &H000000
	#Define clBackground          &H000000
	#Define clActiveCaption       &H000000
	#Define clInactiveCaption     &H000000
	#Define clMenu                &H000000
	#Define clWindow              &H000000
	#Define clWindowFrame         &H000000
	#Define clMenuText            &H000000
	#Define clWindowText          &H000000
	#Define clCaptionText         &H000000
	#Define clActiveBorder        &H000000
	#Define clInactiveBorder      &H000000
	#Define clAppWorkSpace        &H000000
	#Define clHighlight           &H000000
	#Define clHighlightText       &H000000
	#Define clBtnFace             &H000000
	#Define clBtnShadow           &H000000
	#Define clGrayText            &H000000
	#Define clBtnText             &H000000
	#Define clInactiveCaptionText &H000000
	#Define clBtnHighlight        &H000000
	#Define cl3DDkShadow          &H000000
	#Define cl3DLight             &H000000
	#Define clInfoText            &H000000
	#Define clInfoBk              &H000000
#Else
	#Define clScrollBar           GetSysColor(COLOR_SCROLLBAR)
	#Define clBackground          GetSysColor(COLOR_BACKGROUND)
	#Define clActiveCaption       GetSysColor(COLOR_ACTIVECAPTION)
	#Define clInactiveCaption     GetSysColor(COLOR_INACTIVECAPTION)
	#Define clMenu                GetSysColor(COLOR_MENU)
	#Define clWindow              GetSysColor(COLOR_WINDOW)
	#Define clWindowFrame         GetSysColor(COLOR_WINDOWFRAME)
	#Define clMenuText            GetSysColor(COLOR_MENUTEXT)
	#Define clWindowText          GetSysColor(COLOR_WINDOWTEXT)
	#Define clCaptionText         GetSysColor(COLOR_CAPTIONTEXT)
	#Define clActiveBorder        GetSysColor(COLOR_ACTIVEBORDER)
	#Define clInactiveBorder      GetSysColor(COLOR_INACTIVEBORDER)
	#Define clAppWorkSpace        GetSysColor(COLOR_APPWORKSPACE)
	#Define clHighlight           GetSysColor(COLOR_HIGHLIGHT)
	#Define clHighlightText       GetSysColor(COLOR_HIGHLIGHTTEXT)
	#Define clBtnFace             GetSysColor(COLOR_BTNFACE)
	#Define clBtnShadow           GetSysColor(COLOR_BTNSHADOW)
	#Define clGrayText            GetSysColor(COLOR_GRAYTEXT)
	#Define clBtnText             GetSysColor(COLOR_BTNTEXT)
	#Define clInactiveCaptionText GetSysColor(COLOR_INACTIVECAPTIONTEXT)
	#Define clBtnHighlight        GetSysColor(COLOR_BTNHIGHLIGHT)
	#Define cl3DDkShadow          GetSysColor(COLOR_3DDKSHADOW)
	#Define cl3DLight             GetSysColor(COLOR_3DLIGHT)
	#Define clInfoText            GetSysColor(COLOR_INFOTEXT)
	#Define clInfoBk              GetSysColor(COLOR_INFOBK)
#EndIf

	Const clBlack   = &H000000
	Const clMaroon  = &H000080
	Const clGreen   = &H008000
	Const clOlive   = &H008080
	Const clOrange  = &HF07746
	Const clNavy    = &H800000
	Const clPurple  = &H800080
	Const clTeal    = &H808000
	Const clGray    = &H808080
	Const clSilver  = &HC0C0C0
	Const clRed     = &H0000FF
	Const clLime    = &H00FF00
	Const clYellow  = &H00FFFF
	Const clBlue    = &HFF0000
	Const clFuchsia = &HFF00FF
	Const clAqua    = &HFFFF00
	Const clLtGray  = &HC0C0C0
	Const clDkGray  = &H808080
	Const clWhite   = &HFFFFFF
	Const clNone    = &H1FFFFFFF
	Const clDefault = &H20000000

	Declare Function ColorToRGB(FColor As Integer) As Integer
	Declare Function GetRed(FColor As Long) As Byte
	Declare Function GetGreen(FColor As Long) As Byte
	Declare Function GetBlue(FColor As Long) As Byte

	Function ColorToRGB(FColor As Integer) As Integer
		If FColor < 0 then
	    #IFDef __USE_GTK__
			Return FColor
	    #Else
			Return GetSysColor(FColor And &H000000FF)
	    #EndIf 
	    Else
			Return FColor
	    End If  
	End Function

	'Function GetRed(FColor As Long) As Byte
	'	Return FColor And &HFF
	'End Function

	'Function GetGreen(FColor As Long) As Byte
	'	Return (FColor And &HFF00) \ &H100
	'End Function

	'Function GetBlue(FColor As Long) As Byte
	'	Return (FColor And &HFF0000) \ &H10000
	'End Function
	
	Function GetRed(FColor As Long) As Byte
		Return CUInt(FColor) And 255
	End Function

	Function GetGreen(FColor As Long) As Byte
		Return CUInt(FColor) shr 8 And 255
	End Function

	Function GetBlue(FColor As Long) As Byte
		'Return CUInt(FColor) And 255
		Return CUInt(FColor) Shr 16 And 255
	End Function
'End Namespace

#INCLUDE Once "Pen.bi"
#INCLUDE Once "Brush.bi"
#INCLUDE Once "Icon.bi"
#INCLUDE Once "Cursor.bi"
#INCLUDE Once "Bitmap.bi"
#INCLUDE Once "Font.bi"
