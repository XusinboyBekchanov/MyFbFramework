'###############################################################################
'#  IntegerList.bi                                                             #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TStringList.bi                                                            #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Adapted to Integer by Xusinboy Bekchanov (2018-2019)                       #
'###############################################################################

#Include Once "IntegerList.bi"

'IntegerListItem
Property IntegerListItem.Value As Integer
	Return FValue
End Property

Property IntegerListItem.Value(V As Integer)
	FValue = V
End Property

Operator IntegerListItem.Cast As Any Ptr
	Return Object
End Operator

Operator IntegerListItem.Let(V As Any Ptr)
	Object = V
End Operator

Operator IntegerListItem.Let(V As Integer)
	FValue = V
End Operator

Constructor IntegerListItem
	Value = 0
	Object  = 0
End Constructor

Destructor IntegerListItem
	FValue = 0
	Object  = 0
End Destructor

Operator IntegerList.Cast As Any Ptr
	Return @This
End Operator

Property IntegerList.Count As Integer
	Return FItems.Count
End Property

Property IntegerList.Count(Value As Integer)
End Property

Property IntegerList.Item(Index As Integer) As Integer
	If Index >= 0 AND Index <= Count -1 Then
		Return QIntegerListItem(FItems.Items[Index]).Value
	End If
	Return 0
End Property

Property IntegerList.Item(Index As Integer, FItem As Integer)
	If Index >= 0 AND Index <= Count -1 Then
		QIntegerListItem(FItems.Items[Index]).Value = FItem
	End If
End Property

Property IntegerList.Object(Index As Integer) As Any Ptr
	If Index >= 0 AND Index <= Count -1 Then
		Return QIntegerListItem(FItems.Items[Index]).Object
	End If
	Return 0
End Property

Property IntegerList.Object(Index As Integer, FObj As Any Ptr)
	If Index >= 0 AND Index <= Count -1 Then
		QIntegerListItem(FItems.Items[Index]).Object = FObj
	End If
End Property

Sub IntegerList.Add(FItem As Integer, FObj As Any Ptr = 0)
	Dim As IntegerListItem Ptr nItem = New IntegerListItem
	with *nItem
		.Value  = FItem
		.Object = FObj
	End With
	FItems.Add nItem
End Sub

Sub IntegerList.Insert(Index As Integer, FItem As Integer, FObj As Any Ptr = 0)
	Dim As IntegerListItem Ptr nItem = New IntegerListItem
	with *nItem
		.Value  = FItem
		.Object = FObj
	End With
	FItems.Insert Index, nItem
End Sub

Sub IntegerList.Exchange(Index1 As Integer, Index2 As Integer)
	FItems.Exchange(Index1, Index2)
End Sub

Sub IntegerList.Remove(Index As Integer)
	If Index = -1 Then Exit Sub
	Delete Cast(IntegerListItem Ptr, FItems.Items[Index])
	FItems.Remove Index
End Sub

Sub IntegerList.Sort
	Dim As Integer i,j
	For i = 1 To Count -1
		For j = Count -1 To i Step -1
			If (Item(j) < Item(j - 1)) Then
				Exchange j - 1, j
			End If
		Next
	Next
End Sub

Sub IntegerList.Clear
	For i As Integer = Count -1 To 0 Step -1
		Delete Cast(IntegerListItem Ptr, FItems.Items[i])
	Next i
	FItems.Clear
End Sub

Function IntegerList.IndexOf(FItem As Integer) As Integer
	For i As Integer = 0 To Count -1
		If QIntegerListItem(FItems.Items[i]).Value = FItem Then Return i
	Next i
	Return -1
End Function

Function IntegerList.IndexOfObject(FObj As Any Ptr) As Integer
	For i As Integer = 0 To Count -1
		If QIntegerListItem(FItems.Items[i]).Object = FObj Then Return i
	Next i
	Return -1
End Function

Function IntegerList.Contains(FItem As Integer) As Boolean
	Return IndexOf(FItem) <> -1
End Function

Constructor IntegerList
	FItems.Clear
End Constructor

Destructor IntegerList
	For i As Integer = Count -1 To 0 Step -1
		Delete Cast(IntegerListItem Ptr, FItems.Items[i])
	Next i
End Destructor
