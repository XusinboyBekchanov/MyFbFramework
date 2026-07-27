'###############################################################################
'#  PointerList.bas                                                            #
'#  This file is part of MyFBFramework                                         #
'#  Version 1.0.0                                                              #
'###############################################################################

#include once "PointerList.bi"

Private Operator PointerList.Cast As Any Ptr
	Return @This
End Operator

Private Function PointerList.Count As Integer
	Return FCount
End Function

Private Operator PointerList.[](Index As Integer) As Any Ptr
	Dim As PointerListItem Ptr ItemPtr = Cast(PointerListItem Ptr, FItems.Item(Index))
	If ItemPtr <> 0 Then Return ItemPtr->Object Else Return 0
End Operator

Private Property PointerList.Item(Index As Integer) As Any Ptr
	Dim As PointerListItem Ptr ItemPtr = Cast(PointerListItem Ptr, FItems.Item(Index))
	If ItemPtr <> 0 Then Return ItemPtr->Value Else Return 0
End Property

Private Property PointerList.Item(Index As Integer, Value As Any Ptr)
	Dim As PointerListItem Ptr ItemPtr = Cast(PointerListItem Ptr, FItems.Item(Index))
	If ItemPtr <> 0 Then ItemPtr->Value = Value
End Property

Private Property PointerList.Object(Index As Integer) As Any Ptr
	Dim As PointerListItem Ptr ItemPtr = Cast(PointerListItem Ptr, FItems.Item(Index))
	If ItemPtr <> 0 Then Return ItemPtr->Object Else Return 0
End Property

Private Property PointerList.Object(Index As Integer, Value As Any Ptr)
	Dim As PointerListItem Ptr ItemPtr = Cast(PointerListItem Ptr, FItems.Item(Index))
	If ItemPtr <> 0 Then ItemPtr->Object = Value
End Property

Private Function PointerList.Add(iValue As Any Ptr, Obj As Any Ptr = 0) As Integer
	If CBool(FCount > 0) AndAlso FSorted Then
		Return Insert(-1, iValue, Obj)
	Else
		Dim As PointerListItem Ptr nItem = _New(PointerListItem)
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

Private Function PointerList.Insert(Index As Integer, iValue As Any Ptr, Obj As Any Ptr = 0) As Integer
	Dim As Integer j
	If (CBool(Index = -1) OrElse FSorted) AndAlso CBool(FCount > 0) Then ' Sorted Insert
		Dim As Integer LeftIndex = 0, RightIndex = FCount - 1, MidIndex, cmpResult
		Dim As Any Ptr ItemValue
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
	Dim As PointerListItem Ptr nItem = _New( PointerListItem)
	If nItem = 0 Then Return -1
	With *nItem
		.Value  = iValue
		.Object = Obj
	End With
	FItems.Insert j, nItem
	FCount = FItems.Count
	Return j
End Function

Private Sub PointerList.Exchange(Index1 As Integer, Index2 As Integer)
	FItems.Exchange(Index1, Index2)
End Sub

Private Sub PointerList.Remove(Index As Integer)
	Dim As PointerListItem Ptr ItemPtr = FItems.Item(Index)
	If ItemPtr <> 0 Then _Delete( ItemPtr)
	FItems.Remove Index 'Maybe not remove success
	FCount = FItems.Count
End Sub

Private Property PointerList.Sorted(iValue As Boolean)
	If FSorted <> iValue AndAlso iValue = True Then This.Sort(SortedDirection)
	FSorted = iValue
End Property

Private Property PointerList.Sorted As Boolean
	Return FSorted
End Property

Sub PointerList.Sort(ByVal iDirection As Long = 1)
	If FCount <= 1 Then Return
	Type SortStackItem
		iLow As Long
		iHigh As Long
	End Type
	Const INSERTION_SORT_THRESHOLD As Long = 32 'can be 16
	Dim As Long iLBound = 0
	Dim As Long iUBound = FCount - 1
	If iUBound <= iLBound Then Return
	Dim arrStack(0 To 127) As SortStackItem
	Dim As Long iStackTop = 0
	arrStack(iStackTop).iLow = iLBound
	arrStack(iStackTop).iHigh = iUBound
	iStackTop += 1
	Do While iStackTop > 0
		iStackTop -= 1
		Dim As Long iLow = arrStack(iStackTop).iLow
		Dim As Long iHigh = arrStack(iStackTop).iHigh
		Dim As Long iL = iLow
		Dim As Long iR = iHigh
		Dim As Any Ptr sPivot = Item((iLow + iHigh) \ 2)
		Do
			If iDirection = 1 Then 'SORT_ASCENDING
				While iL <= iHigh AndAlso Item(iL) < sPivot
					iL += 1
				Wend
				While iR >= iLow AndAlso Item(iR) > sPivot
					iR -= 1
				Wend
			Else  'SORT_DESCENDING
				While iL <= iHigh AndAlso Item(iL) > sPivot
					iL += 1
				Wend
				While iR >= iLow AndAlso Item(iR) < sPivot
					iR -= 1
				Wend
			End If
			If iL <= iR Then
				Exchange iL, iR
				iL += 1
				iR -= 1
			End If
		Loop Until iL > iR
		
		Dim As Long iSize1 = iR - iLow + 1
		Dim As Long iSize2 = iHigh - iL + 1
		
		If iSize1 > iSize2 Then
			If iSize2 > INSERTION_SORT_THRESHOLD Then
				arrStack(iStackTop).iLow = iL
				arrStack(iStackTop).iHigh = iHigh
				iStackTop += 1
			End If
			If iSize1 > INSERTION_SORT_THRESHOLD Then
				arrStack(iStackTop).iLow = iLow
				arrStack(iStackTop).iHigh = iR
				iStackTop += 1
			End If
		Else
			If iSize1 > INSERTION_SORT_THRESHOLD Then
				arrStack(iStackTop).iLow = iLow
				arrStack(iStackTop).iHigh = iR
				iStackTop += 1
			End If
			If iSize2 > INSERTION_SORT_THRESHOLD Then
				arrStack(iStackTop).iLow = iL
				arrStack(iStackTop).iHigh = iHigh
				iStackTop += 1
			End If
		End If
	Loop
	
	Dim As Long i
	Dim As Long j
	For i = iLBound + 1 To iUBound
		j = i
		If iDirection = 1 Then
			While j > iLBound AndAlso Item(j - 1) > Item(j)
				Exchange j - 1, j
				j -= 1
			Wend
		Else
			While j > iLBound AndAlso Item(j - 1) < Item(j)
				Exchange j - 1, j
				j -= 1
			Wend
		End If
	Next i
	FSorted = True
	FDirection = iDirection
	SortedDirection = iDirection
End Sub

Private Sub PointerList.Clear
	FSorted = False : FDirection = 1 : SortedDirection = 1
	If FCount = 0 Then Return
	Dim As PointerListItem Ptr ItemPtr
	For i As Integer = FCount - 1 To 0 Step -1
		ItemPtr = FItems.Item(i)
		If ItemPtr <> 0 Then _Delete(ItemPtr)
	Next i
	FItems.Clear
	FCount = 0
End Sub

Private Function PointerList.IndexOf(iValue As Any Ptr) As Integer
	If FCount < 1 Then Return -1
	If SortedDirection <> FDirection Then This.Sort(SortedDirection)
	Dim As Any Ptr ItemValue
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

Private Function PointerList.IndexOfObject(Obj As Any Ptr) As Integer
	If Obj = 0 OrElse FCount < 1 Then Return -1
	For i As Integer = 0 To FCount - 1
		If Object(i) = Obj Then Return i
	Next i
	Return -1
End Function

Private Function PointerList.Contains(iValue As Any Ptr, ByRef Idx As Integer = -1) As Boolean
	Idx = IndexOf(iValue)
	Return Idx <> -1
End Function

Private Function PointerList.ContainsObject(Obj As Any Ptr) As Boolean
	Return IndexOfObject(Obj) <> -1
End Function

Private Function PointerList.Get(iValue As Any Ptr, DefaultObj As Any Ptr = 0) As Any Ptr
	For i As Integer = 0 To FCount - 1
		If Item(i) = iValue Then Return Object(i)
	Next i
	Return DefaultObj
End Function

Private Sub PointerList.Set(iValue As Any Ptr, Obj As Any Ptr)
	For i As Integer = 0 To FCount - 1
		If Item(i) = iValue Then
			Object(i) = Obj
			Exit Sub
		End If
	Next i
End Sub

Private Constructor PointerList
	FDirection = 1
	SortedDirection = 1
	FCount = 0
End Constructor

Private Destructor PointerList
	This.Clear
End Destructor