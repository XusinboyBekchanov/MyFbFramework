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

#ifdef __USE_WINAPI__
	Const As COLORREF darkBkColor = &h383838 '&h202020, &h1e1e1e
	Const As COLORREF darkHlBkColor = &h626262
	Const As COLORREF darkTextColor = &hFFFFFF
	
	' ugly colors for illustration purposes
	Dim Shared As HBRUSH g_brItemBackground: g_brItemBackground = CreateSolidBrush(RGB(&hC0, &hC0, &hFF))
	Dim Shared As HBRUSH g_brItemBackgroundHot: g_brItemBackgroundHot = CreateSolidBrush(RGB(&hD0, &hD0, &hFF))
	Dim Shared As HBRUSH g_brItemBackgroundSelected: g_brItemBackgroundSelected = CreateSolidBrush(RGB(&hE0, &hE0, &hFF))
	Dim Shared As HBRUSH hbrBkgnd, hbrHlBkgnd
	Dim Shared As HTHEME g_menuTheme = 0
	hbrBkgnd = CreateSolidBrush(darkBkColor)
	hbrHlBkgnd = CreateSolidBrush(darkHlBkColor)
#endif

Namespace My.Sys.Drawing
	Private Function Brush.ReadProperty(ByRef PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "color": Return @FColor
		Case "style": Return @FStyle
		Case "hatchstyle": Return @FHatchStyle
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Private Function Brush.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "color": This.Color = QInteger(Value)
		Case "style": This.Style = *Cast(BrushStyles Ptr, Value)
		Case "hatchstyle": This.HatchStyle = *Cast(HatchStyles Ptr, Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Private Property Brush.Color As Integer
		Return FColor
	End Property
	
	Private Property Brush.Color(Value As Integer)
		FColor = Value
		Create
	End Property
	
	Private Property Brush.Style As BrushStyles
		Return FStyle
	End Property
	
	Private Property Brush.Style(Value As BrushStyles)
		FStyle = Value
		Create
	End Property
	
	Private Property Brush.HatchStyle As HatchStyles
		Return FHatchStyle
	End Property
	
	Private Property Brush.HatchStyle(Value As HatchStyles)
		FHatchStyle = Value
		Create
	End Property
	
	Private Sub Brush.Create
		#ifdef __USE_WINAPI__
			Dim As LOGBRUSH LB
			LB.lbColor = FColor
			LB.lbHatch = FHatchStyle
			Select Case FStyle
			Case bsClear
				LB.lbStyle = BS_NULL
			Case bsSolid
				LB.lbStyle = BS_SOLID
			Case bsHatch
				LB.lbStyle = BS_HATCHED
				LB.lbHatch = FHatchStyle
			End Select
			If Handle AndAlso Handle <> hbrBkgnd Then DeleteObject(Handle)
			Handle = CreateBrushIndirect(@LB)
			If Handle Then If OnCreate Then OnCreate(This)
		#endif
	End Sub
	
	Private Operator Brush.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor Brush
		FColor = &HFFFFFF
		FStyle = bsSolid
		'Create
		WLet(FClassName, "Brush")
	End Constructor
	
	Private Destructor Brush
		#ifdef __USE_WINAPI__
			If Handle AndAlso Handle <> hbrBkgnd Then DeleteObject Handle
		#endif
	End Destructor
End Namespace
