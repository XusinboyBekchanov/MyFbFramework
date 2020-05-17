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

#include once "Brush.bi"

Namespace My.Sys.Drawing
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
		#ifndef __USE_GTK__
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
		#endif
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
		#ifndef __USE_GTK__
			If Handle Then DeleteObject Handle
		#endif
	End Destructor
End Namespace
