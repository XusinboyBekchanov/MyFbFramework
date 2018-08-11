'###############################################################################
'#  Graphics.bi                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Version 1.0.0                                                              #
'###############################################################################

#Include Once "Object.bi"

'Namespace My.Sys.Drawing
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

	Const clBlack   = &H000000
	Const clMaroon  = &H000080
	Const clGreen   = &H008000
	Const clOlive   = &H008080
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
		  Return GetSysColor(FColor And &H000000FF) 
	   Else
		  Return FColor
	   End If  
	End Function

	Function GetRed(FColor As Long) As Byte
		Return FColor And &HFF
	End Function

	Function GetGreen(FColor As Long) As Byte
		Return (FColor And &HFF00) \ &H100
	End Function

	Function GetBlue(FColor As Long) As Byte
		Return (FColor And &HFF0000) \ &H10000
	End Function
'End Namespace

#INCLUDE Once "Pen.bi"
#INCLUDE Once "Brush.bi"
#INCLUDE Once "Icon.bi"
#INCLUDE Once "Cursor.bi"
#INCLUDE Once "Bitmap.bi"
#INCLUDE Once "Font.bi"
