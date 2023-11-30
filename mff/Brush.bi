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
	Const As COLORREF darkBkColor = &h383838 '&h202020, &h1e1e1e
	Const As COLORREF darkHlBkColor = &h626262
	Const As COLORREF darkTextColor = &hFFFFFF
	
	' ugly colors for illustration purposes
	Dim Shared As HBRUSH g_brItemBackground
	Dim Shared As HBRUSH g_brItemBackgroundHot
	Dim Shared As HBRUSH g_brItemBackgroundSelected
	Dim Shared As HBRUSH hbrBkgnd, hbrHlBkgnd
	Dim Shared As HTHEME g_menuTheme = 0
#else
	Const As Integer darkBkColor = &h383838
	Const As Integer darkHlBkColor = &h626262
	Const As Integer darkTextColor = &hFFFFFF
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
