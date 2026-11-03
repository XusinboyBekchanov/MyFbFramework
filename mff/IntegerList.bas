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

#include once "IntegerList.bi"

'IntegerListItem
Private Property IntegerListItem.Value As Integer
	Return FValue
End Property

Private Property IntegerListItem.Value(V As Integer)
	FValue = V
End Property

Private Operator IntegerListItem.Cast As Any Ptr
	Return Object
End Operator

Private Operator IntegerListItem.Let(V As Any Ptr)
	Object = V
End Operator

Private Operator IntegerListItem.Let(V As Integer)
	FValue = V
End Operator

Private Constructor IntegerListItem
	Value = 0
	Object  = 0
End Constructor

Private Destructor IntegerListItem
	FValue = 0
	Object  = 0
End Destructor

Private Operator IntegerList.Cast As Any Ptr
	Return @This
End Operator

Private Property IntegerList.Count As Integer
	Return FCount
End Property

Private Property IntegerList.Count(Value As Integer)
End Property

Private Operator IntegerList.[](Index As Integer) As Integer
	Dim As IntegerListItem Ptr ItemPtr = FItems.Item(Index)
	If ItemPtr <> 0 Then Return ItemPtr->Value Else Return 0
End Operator

Private Property IntegerList.Item(Index As Integer) As Integer
	Dim As IntegerListItem Ptr ItemPtr = FItems.Item(Index)
	If ItemPtr <> 0 Then Return ItemPtr->Value Else Return 0
End Property

Private Property IntegerList.Item(Index As Integer, iValue As Integer)
	Dim As IntegerListItem Ptr ItemPtr = FItems.Item(Index)
	If ItemPtr <> 0 Then ItemPtr->Value = iValue
End Property

Private Property IntegerList.Object(Index As Integer) As Any Ptr
	Dim As IntegerListItem Ptr ItemPtr = FItems.Item(Index)
	If ItemPtr <> 0 Then Return ItemPtr->Object Else Return 0
End Property

Private Property IntegerList.Object(Index As Integer, Obj As Any Ptr)
	Dim As IntegerListItem Ptr ItemPtr = FItems.Item(Index)
	If ItemPtr <> 0 Then ItemPtr->Object = Obj
End Property

Private Function IntegerList.Add(iValue As Integer, Obj As Any Ptr = 0) As Integer
	If CBool(FCount > 0) AndAlso FSorted Then
		Return This.Insert(-1, iValue, Obj)
	Else
		Dim As IntegerListItem Ptr nItem = _New(IntegerListItem)
		If nItem = 0 Then Return FCount - 1
		With *nItem
			.Value  = iValue
			.Object = Obj
		End With
		FItems.Add nItem
		FCount = FItems.Count
		Return FCount - 1
	End If
End Function

Private Function IntegerList.Insert(Index As Integer, iValue As Integer, Obj As Any Ptr = 0) As Integer
	Dim As Integer j
	Dim As Integer ItemValue
	If (CBool(Index = -1) OrElse FSorted) AndAlso CBool(FCount > 0) Then ' Sorted Insert
		Dim As Integer LeftIndex = 0, RightIndex = FCount - 1, MidIndex, cmpResult
		While LeftIndex <= RightIndex
			MidIndex = (RightIndex + LeftIndex) \ 2
			ItemValue = Item(MidIndex)
				If ItemValue < iValue Then 
					cmpResult = -1 * SortedDirection
				ElseIf ItemValue > iValue Then
					cmpResult = 1 * SortedDirection
				Else
					cmpResult = 0
				End If
			If cmpResult > 0 Then
				RightIndex = MidIndex - 1
			Else
				LeftIndex = MidIndex + 1
			End If
		Wend
		j = LeftIndex
		FSorted = True
	Else
		j = IIf(Index > -1, Index, FCount)
		FSorted = False
	End If
	Dim As IntegerListItem Ptr nItem = _New( IntegerListItem)
	If nItem = 0 Then Return -1
	With *nItem
		.Value  = iValue
		.Object = Obj
	End With
	FItems.Insert j, nItem
	FCount = FItems.Count
	Return j
End Function
	
Private Sub IntegerList.Exchange(Index1 As Integer, Index2 As Integer)
	FItems.Exchange(Index1, Index2)
End Sub

Private Sub IntegerList.Remove(Index As Integer)
	Dim As IntegerListItem Ptr ItemPtr = FItems.Item(Index)
	If ItemPtr <> 0 Then _Delete( ItemPtr)
	FItems.Remove Index 'Maybe not remove success
	FCount = FItems.Count
End Sub

Private Property IntegerList.Sorted(iValue As Boolean)
	If FSorted <> iValue AndAlso iValue = True Then This.Sort(SortedDirection)
	FSorted = iValue
End Property

Private Property IntegerList.Sorted As Boolean
	Return FSorted
End Property

' iDirection: SORT_ASCENDING (1) 为升序(默认), SORT_DESCENDING (-1) 为降序
' 基数排序: 有符号整数 -> 保序无符号键(翻转符号位), 与比较完全无关, 8 趟
Private Function IntegerListItemSortKey(ByVal item As Any Ptr) As ULongInt
	Return CulngInt(Cast(IntegerListItem Ptr, item)->Value) Xor (CulngInt(1) Shl 63)
End Function

Sub IntegerList.Sort(ByVal iDirection As Long = 1)
	If FCount <= 1 Then Return
	FItems.SortByKey(@IntegerListItemSortKey, iDirection)
	FSorted = True
	FDirection = iDirection
	SortedDirection = iDirection
End Sub

Private Sub IntegerList.Clear
	FSorted = False : FDirection = 1 : SortedDirection = 1
	If FCount = 0 Then Return
	For i As Integer = FCount - 1 To 0 Step -1
		If FItems.Items[i] <> 0 Then _Delete( Cast(IntegerListItem Ptr, FItems.Items[i]))
	Next i
	FItems.Clear
	FCount = 0
End Sub

#ifndef IntegerList_IndexOf_Off
	Private Function IntegerList.IndexOf(iValue As Integer) As Integer
		If FCount < 1 Then Return -1
		If SortedDirection <> FDirection Then This.Sort(SortedDirection)
		Dim As Integer ItemValue
		If FSorted AndAlso FCount > 1 Then  'Fast Binary Search
			Dim As Integer LeftIndex = 0, RightIndex = FCount - 1, MidIndex, cmpResult
			Dim As Integer FoundIndex = -1 '用于记录找到的第一个索引
			While LeftIndex <= RightIndex
				MidIndex = (RightIndex + LeftIndex) \ 2
				ItemValue = Item(MidIndex)
				If ItemValue < iValue Then 
					cmpResult = -1 * SortedDirection
				ElseIf ItemValue > iValue Then
					cmpResult = 1 * SortedDirection
				Else
					cmpResult = 0
				End If
				If cmpResult > 0 Then
					RightIndex = MidIndex - 1
				ElseIf cmpResult < 0 Then
					LeftIndex = MidIndex + 1
				Else
					FoundIndex = MidIndex     ' 记录当前找到的位置
					RightIndex = MidIndex - 1 ' 继续向左收缩，寻找更早出现（首次）的索引
				End If
			Wend
			Return FoundIndex
		Else
			For i As Integer = 0 To FCount - 1
				If Item(i) = iValue Then Return i
			Next i
			Return -1
		End If
	End Function
#endif

Private Function IntegerList.IndexOfObject(Obj As Any Ptr) As Integer
	If Obj = 0 OrElse FCount < 1 Then Return -1
	For i As Integer = 0 To FCount - 1
		If Object(i) = Obj Then Return i
	Next i
	Return -1
End Function

Private Function IntegerList.Contains(iValue As Integer) As Boolean
	Return IndexOf(iValue) <> -1
End Function

Private Function IntegerList.Get(iValue As Integer, Obj As Any Ptr = 0) As Any Ptr
	For i As Integer = 0 To FCount - 1
		If Item(i) = iValue Then Return Object(i)
	Next i
	Return Obj
End Function

Private Sub IntegerList.Set(iValue As Integer, Obj As Any Ptr)
	For i As Integer = 0 To FCount - 1
		If Item(i) = iValue Then
			Object(i) = Obj
			Exit Sub
		End If
	Next i
End Sub

Private Constructor IntegerList
	'FItems.Clear
	SortedDirection = 1
	FDirection = 1
	FCount = 0
End Constructor

Private Destructor IntegerList
	This.Clear
End Destructor