'###############################################################################
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
	Dim As DoubleListItem Ptr FItemsItemsIndex = Cast(DoubleListItem Ptr, FItems.Item(Index))
	If FItemsItemsIndex <> 0 Then Return QDoubleListItem(FItemsItemsIndex).Value Else Return 0
End Property

Private Property DoubleList.Item(Index As Integer, FItem As Double)
	Dim As DoubleListItem Ptr FItemsItemsIndex = Cast(DoubleListItem Ptr, FItems.Item(Index))
	If FItemsItemsIndex <> 0 Then QDoubleListItem(FItemsItemsIndex).Value = FItem
End Property

Private Property DoubleList.Object(Index As Integer) As Any Ptr
	Dim As DoubleListItem Ptr FItemsItemsIndex = Cast(DoubleListItem Ptr, FItems.Item(Index))
	If FItemsItemsIndex <> 0 Then Return QDoubleListItem(FItemsItemsIndex).Object Else Return 0
End Property

Private Property DoubleList.Object(Index As Integer, FObj As Any Ptr)
	Dim As DoubleListItem Ptr FItemsItemsIndex = Cast(DoubleListItem Ptr, FItems.Item(Index))
	If FItemsItemsIndex <> 0 Then QDoubleListItem(FItemsItemsIndex).Object = FObj
End Property

#ifndef DoubleList_Add_Off
	Private Sub DoubleList.Add(FItem As Double, FObj As Any Ptr = 0)
		Dim As DoubleListItem Ptr nItem = _New( DoubleListItem)
		If nItem = 0 Then Return
		With *nItem
			.Value  = FItem
			.Object = FObj
		End With
		FItems.Add nItem
		FCount += 1
	End Sub
#endif

Private Sub DoubleList.Insert(Index As Integer, FItem As Double, FObj As Any Ptr = 0)
	Dim As DoubleListItem Ptr nItem = _New( DoubleListItem)
	If nItem = 0 Then Return
	With *nItem
		.Value  = FItem
		.Object = FObj
	End With
	FItems.Insert Index, nItem
	FCount += 1
End Sub

#ifndef DoubleList_Exchange_Off
	Private Sub DoubleList.Exchange(Index1 As Integer, Index2 As Integer)
		FItems.Exchange(Index1, Index2)
	End Sub
#endif

Private Sub DoubleList.Remove(Index As Integer)
	If Index < 0 OrElse Index >= FCount Then Exit Sub
	_Delete( Cast(DoubleListItem Ptr, FItems.Item(Index)))
	FItems.Remove Index  'Maybe not remove success
	FCount = FItems.Count
End Sub

Private Sub DoubleList.Sort
	Dim As Integer i,j
	For i = 1 To FCount - 1
		For j = FCount - 1 To i Step -1
			If (Item(j) < Item(j - 1)) Then
				Exchange j - 1, j
			End If
		Next
	Next
	FSorted = True
End Sub

Private Sub DoubleList.Clear
	If FCount < 1 Then Return
	For i As Integer = FCount - 1 To 0 Step -1
		_Delete( Cast(DoubleListItem Ptr, FItems.Items[i]))
	Next i
	FItems.Clear
	FCount = 0
End Sub

#ifndef DoubleList_IndexOf_Off
	Private Function DoubleList.IndexOf(FItem As Double) As Integer
		For i As Integer = 0 To Count -1
			If Item(i) = FItem Then Return i
		Next i
		Return -1
	End Function
#endif

Private Function DoubleList.IndexOfObject(FObj As Any Ptr) As Integer
	For i As Integer = 0 To Count -1
		If Object(i) = FObj Then Return i
	Next i
	Return -1
End Function

Private Function DoubleList.Contains(FItem As Double) As Boolean
	Return IndexOf(FItem) <> -1
End Function

Private Constructor DoubleList
	
End Constructor

Private Destructor DoubleList
	This.Clear
End Destructor
