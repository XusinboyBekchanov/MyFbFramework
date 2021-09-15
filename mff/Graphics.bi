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

#include once "Object.bi"

'Namespace My.Sys.Drawing
#ifdef __USE_GTK__
	#define clScrollBar           &H000000
	#define clBackground          &H000000
	#define clActiveCaption       &H000000
	#define clInactiveCaption     &H000000
	#define clMenu                &H000000
	#define clWindow              &H000000
	#define clWindowFrame         &H000000
	#define clMenuText            &H000000
	#define clWindowText          &H000000
	#define clCaptionText         &H000000
	#define clActiveBorder        &H000000
	#define clInactiveBorder      &H000000
	#define clAppWorkSpace        &H000000
	#define clHighlight           clOrange
	#define clHighlightText       clWhite
	#define clBtnFace             clGray
	#define clBtnShadow           clLtGray
	#define clGrayText            &H000000
	#define clBtnText             &H000000
	#define clInactiveCaptionText &H000000
	#define clBtnHighlight        &H000000
	#define cl3DDkShadow          &H000000
	#define cl3DLight             &H000000
	#define clInfoText            &H000000
	#define clInfoBk              &H000000
#else
	#define clScrollBar           GetSysColor(COLOR_SCROLLBAR)
	#define clBackground          GetSysColor(COLOR_BACKGROUND)
	#define clActiveCaption       GetSysColor(COLOR_ACTIVECAPTION)
	#define clInactiveCaption     GetSysColor(COLOR_INACTIVECAPTION)
	#define clMenu                GetSysColor(COLOR_MENU)
	#define clWindow              GetSysColor(COLOR_WINDOW)
	#define clWindowFrame         GetSysColor(COLOR_WINDOWFRAME)
	#define clMenuText            GetSysColor(COLOR_MENUTEXT)
	#define clWindowText          GetSysColor(COLOR_WINDOWTEXT)
	#define clCaptionText         GetSysColor(COLOR_CAPTIONTEXT)
	#define clActiveBorder        GetSysColor(COLOR_ACTIVEBORDER)
	#define clInactiveBorder      GetSysColor(COLOR_INACTIVEBORDER)
	#define clAppWorkSpace        GetSysColor(COLOR_APPWORKSPACE)
	#define clHighlight           GetSysColor(COLOR_HIGHLIGHT)
	#define clHighlightText       GetSysColor(COLOR_HIGHLIGHTTEXT)
	#define clBtnFace             GetSysColor(COLOR_BTNFACE)
	#define clBtnShadow           GetSysColor(COLOR_BTNSHADOW)
	#define clGrayText            GetSysColor(COLOR_GRAYTEXT)
	#define clBtnText             GetSysColor(COLOR_BTNTEXT)
	#define clInactiveCaptionText GetSysColor(COLOR_INACTIVECAPTIONTEXT)
	#define clBtnHighlight        GetSysColor(COLOR_BTNHIGHLIGHT)
	#define cl3DDkShadow          GetSysColor(COLOR_3DDKSHADOW)
	#define cl3DLight             GetSysColor(COLOR_3DLIGHT)
	#define clInfoText            GetSysColor(COLOR_INFOTEXT)
	#define clInfoBk              GetSysColor(COLOR_INFOBK)
#endif

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
Declare Function GetRed(FColor As Long) As Integer
Declare Function GetGreen(FColor As Long) As Integer
Declare Function GetBlue(FColor As Long) As Integer
#ifdef __USE_GTK__
	#define BGR(r, g, b) (Cast(UByte, (r)) Or (Cast(UShort, Cast(UByte, (g))) Shl 8)) Or (Cast(UShort, Cast(UByte, (b))) Shl 16)
#endif

'End Namespace

#include once "Pen.bi"
#include once "Brush.bi"
#include once "Icon.bi"
#include once "Cursor.bi"
#include once "Bitmap.bi"
#include once "Font.bi"

#ifndef __USE_MAKE__
	#include once "Graphics.bas"
#endif
