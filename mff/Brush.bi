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

Namespace My.Sys.Drawing
	#ifdef __USE_GTK__
		Enum BrushStyle
			bsSolid
			bsClear
			bsHatch
			bsPattern
		End Enum
		
		Enum HatchStyle
			hsHorizontal
			hsVertical
			hsFDiagonal
			hsDiagonal
			hsCross
			hsDiagCross
		End Enum
	#else
		Enum BrushStyle
			bsSolid   = BS_SOLID
			bsClear   = BS_NULL
			bsHatch   = BS_HATCHED
			bsPattern = BS_PATTERN
		End Enum
		
		Enum HatchStyle
			hsHorizontal = HS_HORIZONTAL
			hsVertical   = HS_VERTICAL
			hsFDiagonal  = HS_FDIAGONAL
			hsDiagonal   = HS_BDIAGONAL
			hsCross      = HS_CROSS
			hsDiagCross  = HS_DIAGCROSS
		End Enum
	#endif
	
	Type Brush Extends My.Sys.Object
	Private:
		FColor       As Integer
		FStyle       As BrushStyle
		FHatchStyle  As HatchStyle
		Declare Sub Create
	Public:
		#ifndef __USE_GTK__
			Handle       As HBRUSH
		#endif
		Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Declare Property Color As Integer
		Declare Property Color(Value As Integer)
		Declare Property Style As Integer 'BrushStyle
		Declare Property Style(Value As Integer)
		Declare Property HatchStyle As Integer 'HatchStyle
		Declare Property HatchStyle(Value As Integer)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "Brush.bas"
#endif
