'###############################################################################
'#  DoubleList.bi                                                             #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TStringList.bi                                                            #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Adapted to Double by Xusinboy Bekchanov (2018-2019)                       #
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
	Return FCount
End Property

Private Property DoubleList.Count(Value As Integer)
End Property

Private Operator DoubleList.[](Index As Integer) As Double
	Dim As DoubleListItem Ptr ItemPtr = FItems.Item(Index)
	If ItemPtr <> 0 Then Return ItemPtr->Value Else Return 0
End Operator

Private Property DoubleList.Item(Index As Integer) As Double
	Dim As DoubleListItem Ptr ItemPtr = FItems.Item(Index)
	If ItemPtr <> 0 Then Return ItemPtr->Value Else Return 0
End Property

Private Property DoubleList.Item(Index As Integer, iValue As Double)
	Dim As DoubleListItem Ptr ItemPtr = FItems.Item(Index)
	If ItemPtr <> 0 Then ItemPtr->Value = iValue
End Property

Private Property DoubleList.Object(Index As Integer) As Any Ptr
	Dim As DoubleListItem Ptr ItemPtr = FItems.Item(Index)
	If ItemPtr <> 0 Then Return ItemPtr->Object Else Return 0
End Property

Private Property DoubleList.Object(Index As Integer, Obj As Any Ptr)
	Dim As DoubleListItem Ptr ItemPtr = FItems.Item(Index)
	If ItemPtr <> 0 Then ItemPtr->Object = Obj
End Property

Private Function DoubleList.Add(iValue As Double, Obj As Any Ptr = 0) As Integer
	If CBool(FCount > 0) AndAlso FSorted Then
		Return This.Insert(-1, iValue, Obj)
	Else
		Dim As DoubleListItem Ptr nItem = _New(DoubleListItem)
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

Private Function DoubleList.Insert(Index As Integer, iValue As Double, Obj As Any Ptr = 0) As Integer
	Dim As Integer j
	Dim As Double ItemValue
	If (CBool(Index = -1) OrElse FSorted) AndAlso CBool(FCount > 0) Then ' Sorted Insert
		Dim As Integer LeftIndex = 0, RightIndex = FCount - 1, MidIndex, cmpResult
		While LeftIndex <= RightIndex
			MidIndex = (RightIndex + LeftIndex) \ 2
			ItemValue = Item(MidIndex)
			If ItemValue < iValue - EPSILON Then
				cmpResult = -1 * SortedDirection
			ElseIf ItemValue > iValue + EPSILON Then
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
	Dim As DoubleListItem Ptr nItem = _New( DoubleListItem)
	If nItem = 0 Then Return -1
	With *nItem
		.Value  = iValue
		.Object = Obj
	End With
	FItems.Insert j, nItem
	FCount = FItems.Count
	Return j
End Function

Private Sub DoubleList.Exchange(Index1 As Integer, Index2 As Integer)
	FItems.Exchange(Index1, Index2)
End Sub

Private Sub DoubleList.Remove(Index As Integer)
	Dim As DoubleListItem Ptr ItemPtr = FItems.Item(Index)
	If ItemPtr <> 0 Then _Delete( ItemPtr)
	FItems.Remove Index 'Maybe not remove success
	FCount = FItems.Count
End Sub

Private Property DoubleList.Sorted(iValue As Boolean)
	FSorted = iValue
End Property

Private Property DoubleList.Sorted As Boolean
	Return FSorted
End Property

' iDirection: SORT_ASCENDING (1) 为升序(默认), SORT_DESCENDING (-1) 为降序
Sub DoubleList.Sort(ByVal iDirection As Long = 1)
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
		Dim As Double sPivot = Item((iLow + iHigh) \ 2)
		Do
			If iDirection = 1 Then 'SORT_ASCENDING
				While iL <= iHigh AndAlso Item(iL) < sPivot - EPSILON
					iL += 1
				Wend
				While iR >= iLow AndAlso Item(iR) > sPivot + EPSILON
					iR -= 1
				Wend
			Else  'SORT_DESCENDING
				While iL <= iHigh AndAlso Item(iL) > sPivot + EPSILON
					iL += 1
				Wend
				While iR >= iLow AndAlso Item(iR) < sPivot - EPSILON
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
			While j > iLBound AndAlso Item(j - 1) > Item(j) + EPSILON
				Exchange j - 1, j
				j -= 1
			Wend
		Else
			While j > iLBound AndAlso Item(j - 1) < Item(j) - EPSILON
				Exchange j - 1, j
				j -= 1
			Wend
		End If
	Next i
	FSorted = True
	FDirection = iDirection
	SortedDirection = iDirection
End Sub

Private Sub DoubleList.Clear
	FSorted = False : FDirection = 1 : SortedDirection = 1
	If FCount = 0 Then Return
	Dim As DoubleListItem Ptr ItemPtr
	For i As Integer = FCount - 1 To 0 Step -1
		ItemPtr = FItems.Item(i)
		If ItemPtr <> 0 Then _Delete( ItemPtr)
	Next i
	FItems.Clear
	FCount = 0
End Sub

#ifndef DoubleList_IndexOf_Off
	Private Function DoubleList.IndexOf(iValue As Double) As Integer
		If FCount < 1 Then Return -1
		If SortedDirection <> FDirection Then This.Sort(SortedDirection)
		Dim As Double ItemValue
		If FSorted AndAlso FCount > 1 Then  'Fast Binary Search
			Dim As Integer LeftIndex = 0, RightIndex = FCount - 1, MidIndex, cmpResult
			Dim As Integer FoundIndex = -1 '用于记录找到的第一个索引
			While LeftIndex <= RightIndex
				MidIndex = (RightIndex + LeftIndex) \ 2
				ItemValue = Item(MidIndex)
				If ItemValue < iValue- EPSILON Then
					cmpResult = -1 * SortedDirection
				ElseIf ItemValue > iValue + EPSILON Then
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
				If Abs(Item(i) - iValue) < EPSILON Then Return i
			Next i
			Return -1
		End If
	End Function
#endif

Private Function DoubleList.IndexOfObject(Obj As Any Ptr) As Integer
	If Obj = 0 OrElse FCount < 1 Then Return -1
	For i As Integer = 0 To FCount - 1
		If Object(i) = Obj Then Return i
	Next i
	Return -1
End Function

Private Function DoubleList.Contains(iValue As Double) As Boolean
	Return IndexOf(iValue) <> -1
End Function

Private Function DoubleList.Get(iValue As Double, DefaultObj As Any Ptr = 0) As Any Ptr
	For i As Integer = 0 To FCount - 1
		If Abs(Item(i) - iValue) < EPSILON Then Return Object(i)
	Next i
	Return DefaultObj
End Function

Private Sub DoubleList.Set(iValue As Double, Obj As Any Ptr)
	For i As Integer = 0 To FCount - 1
		If Abs(Item(i) - iValue) < EPSILON Then
			Object(i) = Obj
			Exit Sub
		End If
	Next i
End Sub

Private Constructor DoubleList
	'FItems.Clear
	SortedDirection = 1
	FDirection = 1
	FCount = 0
End Constructor

Private Destructor DoubleList
	This.Clear
End Destructor