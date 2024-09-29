'################################################################################
'#  Brush.bi                                                                    #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                      #
'#  Based on:                                                                   #
'#   TBrush.bi                                                                  #
'#   FreeBasic Windows GUI ToolKit                                              #
'#   Copyright (c) 2007-2008 Nastase Eodor                                      #
'#   Version 1.0.0                                                              #
'#  Modified by Xusinboy Bekchanov (2018-2019), Liu XiaLin (2020)               #
'################################################################################

#include once "Object.bi"

#ifdef __USE_WINAPI__
	Dim Shared As COLORREF darkBkColorTitle = BGR(10, 10, 10)
	Dim Shared As COLORREF darkBkColorMenu = BGR(41, 41, 41) 
	Dim Shared As COLORREF darkBkColorGreen = BGR(55, 166, 96)
	Dim Shared As COLORREF darkBkColorBlue = BGR(89, 143, 236)
	Dim Shared As COLORREF darkBkColor = &h383838
	Dim Shared As COLORREF darkBkColorDark = BGR(31, 31, 31)
	Dim Shared As COLORREF darkHlBkColor = &h626262
	Dim Shared As COLORREF darkTextColor = BGR(255, 255, 255) 
	
	' ugly colors for illustration purposes
	Dim Shared As HBRUSH g_brItemBackground
	Dim Shared As HBRUSH g_brItemBackgroundHot
	Dim Shared As HBRUSH g_brItemBackgroundSelected
	Dim Shared As HBRUSH hbrBkgnd, hbrHlBkgnd, hbrBkgndMenu
	Dim Shared As HTHEME g_menuTheme = 0
#else
	Dim Shared As Integer darkBkColorTitle = BGR(10, 10, 10) 
	Dim Shared As Integer darkBkColorMenu = BGR(41, 41, 41)
	Dim Shared As Integer darkBkColorGreen = BGR(55, 166, 96)
	Dim Shared As Integer darkBkColorBlue = BGR(89, 143, 236)
	Dim Shared As Integer darkBkColor = BGR(38, 38, 38)
	Dim Shared As Integer darkBkColorDark = BGR(31, 31, 31)
	Dim Shared As Integer darkHlBkColor = BGR(62, 62, 62) 
	Dim Shared As Integer darkTextColor = BGR(255, 255, 255) 
#endif

Namespace My.Sys.Drawing
	#ifdef __USE_WINAPI__
		Private Enum BrushStyles
			bsSolid   = BS_SOLID
			bsClear   = BS_NULL
			bsHatch   = BS_HATCHED
			bsPattern = BS_PATTERN
		End Enum
		
		Private Enum HatchStyles
			hsHorizontal = HS_HORIZONTAL
			hsVertical   = HS_VERTICAL
			hsFDiagonal  = HS_FDIAGONAL
			hsDiagonal   = HS_BDIAGONAL
			hsCross      = HS_CROSS
			hsDiagCross  = HS_DIAGCROSS
		End Enum
	#else
		Private Enum BrushStyles
			bsSolid
			bsClear
			bsHatch
			bsPattern
		End Enum
		
		Private Enum HatchStyles
			hsHorizontal
			hsVertical
			hsFDiagonal
			hsDiagonal
			hsCross
			hsDiagCross
		End Enum
	#endif
	
	Private Type Brush Extends My.Sys.Object
	Private:
		FColor       As Integer
		FStyle       As BrushStyles
		FHatchStyle  As HatchStyles
		Declare Sub Create
	Public:
		#ifdef __USE_WINAPI__
			Handle       As HBRUSH
		#endif
		Parent As My.Sys.Object Ptr
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property Color As Integer
		Declare Property Color(Value As Integer)
		Declare Property Style As BrushStyles
		Declare Property Style(Value As BrushStyles)
		Declare Property HatchStyle As HatchStyles
		Declare Property HatchStyle(Value As HatchStyles)
		Declare Operator Cast As Any Ptr
		#ifdef __USE_WINAPI__
			Declare Operator Let(Value As HBRUSH)
		#endif
		OnCreate As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Brush)
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "Brush.bas"
#endif
