﻿'###############################################################################
'#  DoubleList.bi                                                             #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TStringList.bi                                                            #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Adapted to Integer by Xusinboy Bekchanov (2018-2019)                       #
'###############################################################################

#include once "DoubleList.bi"

'DoubleListItem
Private Property DoubleListItem.Value As Double
	Return FValue
End Property

Private Property DoubleListItem.Value(V As Double)
	FValue = V
End Property

Private Operator DoubleListItem.Cast As Any Ptr
	Return Object
End Operator

Private Operator DoubleListItem.Let(V As Any Ptr)
	Object = V
End Operator

Private Operator DoubleListItem.Let(V As Double)
	FValue = V
End Operator

Private Constructor DoubleListItem
	Value = 0
	Object  = 0
End Constructor

Private Destructor DoubleListItem
	FValue = 0
	Object  = 0
End Destructor

Private Operator DoubleList.Cast As Any Ptr
	Return @This
End Operator

Private Property DoubleList.Count As Integer
	Return FItems.Count
End Property

Private Property DoubleList.Count(Value As Integer)
End Property

Private Property DoubleList.Item(Index As Integer) As Double
	If Index >= 0 And Index <= Count -1 Then
		Return QDoubleListItem(FItems.Items[Index]).Value
	End If
	Return 0
End Property

Private Property DoubleList.Item(Index As Integer, FItem As Double)
	If Index >= 0 And Index <= Count -1 Then
		QDoubleListItem(FItems.Items[Index]).Value = FItem
	End If
End Property

Private Property DoubleList.Object(Index As Integer) As Any Ptr
	If Index >= 0 And Index <= Count -1 Then
		Return QDoubleListItem(FItems.Items[Index]).Object
	End If
	Return 0
End Property

Private Property DoubleList.Object(Index As Integer, FObj As Any Ptr)
	If Index >= 0 And Index <= Count -1 Then
		QDoubleListItem(FItems.Items[Index]).Object = FObj
	End If
End Property

Private Sub DoubleList.Add(FItem As Double, FObj As Any Ptr = 0)
	Dim As DoubleListItem Ptr nItem = New_( DoubleListItem)
	With *nItem
		.Value  = FItem
		.Object = FObj
	End With
	FItems.Add nItem
End Sub

Private Sub DoubleList.Insert(Index As Integer, FItem As Double, FObj As Any Ptr = 0)
	Dim As DoubleListItem Ptr nItem = New_( DoubleListItem)
	With *nItem
		.Value  = FItem
		.Object = FObj
	End With
	FItems.Insert Index, nItem
End Sub

Private Sub DoubleList.Exchange(Index1 As Integer, Index2 As Integer)
	FItems.Exchange(Index1, Index2)
End Sub

Private Sub DoubleList.Remove(Index As Integer)
	If Index = -1 Then Exit Sub
	Delete_( Cast(DoubleListItem Ptr, FItems.Items[Index]))
	FItems.Remove Index
End Sub

Private Sub DoubleList.Sort
	Dim As Integer i,j
	For i = 1 To Count -1
		For j = Count -1 To i Step -1
			If (Item(j) < Item(j - 1)) Then
				Exchange j - 1, j
			End If
		Next
	Next
End Sub

Private Sub DoubleList.Clear
	For i As Integer = Count -1 To 0 Step -1
		Delete_( Cast(DoubleListItem Ptr, FItems.Items[i]))
	Next i
	FItems.Clear
End Sub

Private Function DoubleList.IndexOf(FItem As Double) As Integer
	For i As Integer = 0 To Count -1
		If QDoubleListItem(FItems.Items[i]).Value = FItem Then Return i
	Next i
	Return -1
End Function

Private Function DoubleList.IndexOfObject(FObj As Any Ptr) As Integer
	For i As Integer = 0 To Count -1
		If QDoubleListItem(FItems.Items[i]).Object = FObj Then Return i
	Next i
	Return -1
End Function

Private Function DoubleList.Contains(FItem As Double) As Boolean
	Return IndexOf(FItem) <> -1
End Function

Private Constructor DoubleList
	FItems.Clear
End Constructor

Private Destructor DoubleList
	For i As Integer = Count -1 To 0 Step -1
		Delete_( Cast(DoubleListItem Ptr, FItems.Items[i]))
	Next i
End Destructor
