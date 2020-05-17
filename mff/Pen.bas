'###############################################################################
'#  Pen.bi                                                                     #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TPen.bi                                                                   #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Modified by Xusinboy Bekchanov (2018-2019)                                 #
'###############################################################################

#include once "Pen.bi"

Namespace My.Sys.Drawing
	Function Pen.ReadProperty(ByRef PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "color": Return @FColor
		Case "style": Return @FStyle
		Case "mode": Return @FMode
		Case "size": Return @FSize
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function Pen.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "color": This.Color = QInteger(Value)
		Case "style": This.Style = QInteger(Value)
		Case "mode": This.Mode = QInteger(Value)
		Case "size": This.Size = QInteger(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Property Pen.Color As Integer
		Return FColor
	End Property
	
	Property Pen.Color(Value As Integer)
		FColor = Value
		Create
	End Property
	
	Property Pen.Style As Integer
		Return FStyle
	End Property
	
	Property Pen.Style(Value As Integer)
		FStyle = Value
		Create
	End Property
	
	Property Pen.Mode As Integer
		Return FMode
	End Property
	
	Property Pen.Mode(Value As Integer)
		FMode = Value
		Create
	End Property
	
	Property Pen.Size As Integer
		Return FSize
	End Property
	
	Property Pen.Size(Value As Integer)
		FSize = Value
		Create
	End Property
	
	Sub Pen.Create
		#ifndef __USE_GTK__
			If Handle Then DeleteObject Handle
			Handle = CreatePen(FStyle,FSize,FColor)
		#endif
	End Sub
	
	Operator Pen.Cast As Any Ptr
		Return @This
	End Operator
	
	Constructor Pen
		FSize  = 1
		FColor = 0
		FMode  = pmCopy
		FStyle = psSolid
		Create
		WLet FClassName, "Pen"
	End Constructor
	
	Destructor Pen
		#ifndef __USE_GTK__
			If Handle Then DeleteObject Handle
		#endif
	End Destructor
End Namespace
