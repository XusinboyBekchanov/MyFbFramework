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
    
    Function Brush.ReadProperty(ByRef PropertyName As String) As Any Ptr
        Select Case LCase(PropertyName)
        Case "color": Return @FColor
        Case "style": Return @FStyle
        Case "hatchstyle": Return @FHatchStyle
        Case Else: Return Base.ReadProperty(PropertyName)
        End Select
        Return 0
    End Function
    
    Function Brush.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
        Select Case LCase(PropertyName)
        Case "color": This.Color = QInteger(Value)
        Case "style": This.Style = QInteger(Value)
        Case "hatchstyle": This.HatchStyle = QInteger(Value)
        Case Else: Return Base.WriteProperty(PropertyName, Value)
        End Select
        Return True
    End Function

    Property Brush.Color As Integer
        Return FColor
    End Property

    Property Brush.Color(Value As Integer)
        FColor = Value
        Create
    End Property

    Property Brush.Style As Integer
       Return FStyle
    End Property

    Property Brush.Style(Value As Integer)
        FStyle = Value
        Create
    End Property

    Property Brush.HatchStyle As Integer
        Return FHatchStyle
    End Property

    Property Brush.HatchStyle(Value As Integer)
        FHatchStyle = Value
        Create
    End Property

    Sub Brush.Create
		#IfNDef __USE_GTK__
			Dim As LOGBRUSH LB
			LB.lbColor = FColor
			LB.lbHatch = FHatchStyle
			If Handle Then DeleteObject Handle
			Select Case FStyle
			Case bsClear
				LB.lbStyle = BS_NULL
			Case bsSolid
				LB.lbStyle = BS_SOLID
			Case bsHatch
				LB.lbStyle = BS_HATCHED
				LB.lbHatch = FHatchStyle
			End Select
			Handle = CreateBrushIndirect(@LB)
		#EndIf
    End Sub

    Operator Brush.Cast As Any Ptr
        Return @This
    End Operator

    Constructor Brush
        FColor = &HFFFFFF
        FStyle = bsSolid
        Create
        WLet FClassName, "Brush"
    End Constructor

    Destructor Brush
		#IfNDef __USE_GTK__
			If Handle Then DeleteObject Handle
		#EndIf
    End Destructor
End namespace
