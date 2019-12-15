'###############################################################################
'#  Brush.bi                                                                   #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TBrush.bi                                                                 #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Modified by Xusinboy Bekchanov (2018-2019)                                 #
'###############################################################################

#Include Once "Object.bi"

Namespace My.Sys.Drawing
	#IfDef __USE_GTK__
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
	#Else
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
	#EndIf

    Type Brush Extends My.Sys.Object
        Private:
            FColor       As Integer
            FStyle       As BrushStyle
            FHatchStyle  As HatchStyle
            Declare Sub Create
        Public:
			#IfNDef __USE_GTK__
				Handle       As HBRUSH
			#EndIf
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
End namespace

#IfNDef __USE_MAKE__
	#Include Once "Brush.bas"
#EndIf
