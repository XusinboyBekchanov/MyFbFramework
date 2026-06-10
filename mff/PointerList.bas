'###############################################################################
'#  PointerList.bas                                                            #
'#  This file is part of MyFBFramework                                         #
'#  Version 1.0.0                                                              #
'###############################################################################

#include once "DoubleList.bi"

Private Operator PointerList.Cast As Any Ptr
	Return @This
End Operator

Private Function PointerList.Count As Integer
	Return FCount
End Function

Private Operator PointerList.[](Index As Integer) As Any Ptr
	Dim As PointerListItem Ptr FItemsItemsIndex = Cast(PointerListItem Ptr, FItems.Item(Index))
	If FItemsItemsIndex <> 0 Then Return QPointerListItem(FItemsItemsIndex).Object Else Return 0
End Operator

Private Property PointerList.Item(Index As Integer) As Any Ptr
	Dim As PointerListItem Ptr FItemsItemsIndex = Cast(PointerListItem Ptr, FItems.Item(Index))
	If FItemsItemsIndex <> 0 Then Return QPointerListItem(FItemsItemsIndex).Value Else Return 0
End Property

Private Property PointerList.Item(Index As Integer, Value As Any Ptr)
	Dim As PointerListItem Ptr FItemsItemsIndex = Cast(PointerListItem Ptr, FItems.Item(Index))
	If FItemsItemsIndex <> 0 Then QPointerListItem(FItemsItemsIndex).Value = Value
End Property

Private Property PointerList.Object(Index As Integer) As Any Ptr
	Dim As PointerListItem Ptr FItemsItemsIndex = Cast(PointerListItem Ptr, FItems.Item(Index))
	If FItemsItemsIndex <> 0 Then Return QPointerListItem(FItemsItemsIndex).Object Else Return 0
End Property

Private Property PointerList.Object(Index As Integer, Value As Any Ptr)
	Dim As PointerListItem Ptr FItemsItemsIndex = Cast(PointerListItem Ptr, FItems.Item(Index))
	If FItemsItemsIndex <> 0 Then QPointerListItem(FItemsItemsIndex).Object = Value
End Property

Private Sub PointerList.Add(_Item As Any Ptr, Obj As Any Ptr = 0)
	Dim As PointerListItem Ptr nItem = _New(PointerListItem)
	If nItem = 0 Then Return
	With *nItem
		.Value  = _Item
		.Object = Obj
	End With
	FItems.Add nItem
	FCount += 1
End Sub

Private Sub PointerList.Insert(Index As Integer, _Item As Any Ptr, Obj As Any Ptr = 0)
	Dim As PointerListItem Ptr nItem = _New(PointerListItem)
	If nItem = 0 Then Return
	With *nItem
		.Value  = _Item
		.Object = Obj
	End With
	FItems.Insert Index, nItem
	FCount += 1
End Sub

Private Sub PointerList.Exchange(Index1 As Integer, Index2 As Integer)
	FItems.Exchange(Index1, Index2)
End Sub

Private Sub PointerList.Remove(Index As Integer)
	If Index >= 0 And Index < FCount Then
		_Delete(Cast(PointerListItem Ptr, FItems.Items[Index]))
		FItems.Remove Index  'Maybe not remove success
		FCount = FItems.Count
	End If
End Sub

Private Sub PointerList.Clear
	If FCount = 0 Then Return
	For i As Integer = FCount - 1 To 0 Step -1
		Dim As PointerListItem Ptr pItem = Cast(PointerListItem Ptr, FItems.Items[i])
		If pItem Then _Delete(pItem)
	Next i
	FItems.Clear
	FCount = 0
End Sub

Private Function PointerList.IndexOf(_Item As Any Ptr) As Integer
	For i As Integer = 0 To FCount - 1
		If QPointerListItem(FItems.Items[i]).Value = _Item Then Return i
	Next i
	Return -1
End Function

Private Function PointerList.IndexOfObject(Obj As Any Ptr) As Integer
	For i As Integer = 0 To FCount - 1
		If QPointerListItem(FItems.Items[i]).Object = Obj Then Return i
	Next i
	Return -1
End Function

Private Function PointerList.Contains(_Item As Any Ptr, ByRef Idx As Integer = -1) As Boolean
	Idx = IndexOf(_Item)
	Return Idx <> -1
End Function

Private Function PointerList.ContainsObject(Obj As Any Ptr) As Boolean
	Return IndexOfObject(Obj) <> -1
End Function

Private Function PointerList.Get(_Item As Any Ptr, Obj As Any Ptr = 0) As Any Ptr
	For i As Integer = 0 To FCount - 1
		If QPointerListItem(FItems.Items[i]).Value = _Item Then Return QPointerListItem(FItems.Items[i]).Object
	Next i
	Return Obj
End Function

Private Sub PointerList.Set(_Item As Any Ptr, Obj As Any Ptr)
	For i As Integer = 0 To FCount - 1
		If QPointerListItem(FItems.Items[i]).Value = _Item Then
			QPointerListItem(FItems.Items[i]).Object = Obj
			Exit Sub
		End If
	Next i
End Sub

Private Constructor PointerList
	
End Constructor

Private Destructor PointerList
	This.Clear
End Destructor
