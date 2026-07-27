'###############################################################################
'#  WStringList.bi                                                             #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TStringList.bi                                                            #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Adapted to WString by Xusinboy Bekchanov(2018-2019)  Liu XiaLin            #
'###############################################################################

#include once "WStringList.bi"

'WStringListItem
Private Property WStringListItem.Value ByRef As WString
	If FValue Then Return *FValue Else Return ""
End Property

Private Property WStringListItem.Value(ByRef V As WString)
	WLet(FValue, V)
End Property

Private Operator WStringListItem.Cast As Any Ptr
	Return Object
End Operator

Private Operator WStringListItem.Cast As String
	Return Value
End Operator

Private Operator WStringListItem.Let(V As Any Ptr)
	Object = V
End Operator

Private Operator WStringListItem.Let(ByRef V As WString)
	WLet(FValue, V)
End Operator

Private Constructor WStringListItem
	WLet(FValue, "")
	Object = 0
End Constructor

Private Destructor WStringListItem
	If FValue Then _Deallocate((FValue))
	Object = 0
End Destructor

'WStringList
Private Operator WStringList.Cast As Any Ptr
	Return @This
End Operator

Private Property WStringList.Count As Integer
	Return FCount
End Property

Private Property WStringList.Count(iValue As Integer)
End Property

#ifndef WStringList_MatchCase_Get_Off
	Private Property WStringList.MatchCase As Boolean
		Return FMatchCase
	End Property
#endif

#ifndef WStringList_MatchCase_Set_Off
	Private Property WStringList.MatchCase(iValue As Boolean)
		FMatchCase = iValue
	End Property
#endif

Private Property WStringList.MatchFullWords(iValue As Boolean)
	FMatchFullWords = iValue
End Property

Private Property WStringList.MatchFullWords As Boolean
	Return FMatchFullWords
End Property

Private Property WStringList.Sorted(iValue As Boolean)
	If FSorted <> iValue AndAlso iValue = True Then This.Sort(FMatchCase, FDirection, FNaturalSort)
	FSorted = iValue
End Property

Private Property WStringList.Sorted As Boolean
	Return FSorted
End Property

Private Property WStringList.Text ByRef As WString
	WLet(FText, "")
	Dim As Integer Capacity
	For i As Integer = 0 To FCount -1
		If i <> FCount -1 Then
			'WAdd FText, *Cast(WString Ptr, Items.Item(i)) + Chr(13) + Chr(10)
			WAdd(FText, Item(i) + Chr(13) + Chr(10), , Capacity)
		Else
			WAdd(FText, Item(i), , 0)
		End If
	Next i
	If FText Then Return *FText Else Return ""
End Property

#ifndef WStringList_Text_Set_Off
	Private Property WStringList.Text(ByRef Value As WString)
		This.Clear
		Dim As Integer iLen = Len(Value)
		Dim As Integer iLineStart = 0, i
		For i = 0 To iLen
			If Value[i] = 10 Or Value[i] = 0 Then
				Dim As Integer iLineLen = i - iLineStart
				If iLineLen > 1 AndAlso Value[i - 1] = 13 Then iLineLen -= 1
				If iLineLen > 0 Then
					This.Add Mid(Value, iLineStart + 1, iLineLen)
				End If
				iLineStart = i + 1
			End If
			If Value[i] = 0 Then Exit For
		Next i
	End Property
#endif

Private Operator WStringList.[](Index As Integer) ByRef As WString
	Dim As WStringListItem Ptr ItemPtr = FItems.Item(Index)
	If ItemPtr <> 0 Then Return ItemPtr->Value Else Return ""
End Operator

Private Property WStringList.Item(Index As Integer) ByRef As WString
	Dim As WStringListItem Ptr ItemPtr = FItems.Item(Index)
	If ItemPtr <> 0 Then Return ItemPtr->Value Else Return ""
End Property

Private Property WStringList.Item(Index As Integer, iValue As WString)
	Dim As WStringListItem Ptr ItemPtr = FItems.Item(Index)
	If ItemPtr <> 0 Then ItemPtr->Value = iValue
End Property

Private Property WStringList.Object(Index As Integer) As Any Ptr
	Dim As WStringListItem Ptr ItemPtr = FItems.Item(Index)
	If ItemPtr <> 0 Then Return ItemPtr->Object Else Return 0
End Property

Private Property WStringList.Object(Index As Integer, Obj As Any Ptr)
	Dim As WStringListItem Ptr ItemPtr = FItems.Item(Index)
	If ItemPtr <> 0 Then ItemPtr->Object = Obj
End Property

#ifndef WStringList_Add_Off
	Private Function WStringList.Add(ByRef iValue As WString, Obj As Any Ptr = 0) As Integer
		'If iValue = "" Then Return -1 'We should allow add a empty records. Will get trouble in TreeListview if not allowed.
		If CBool(FCount > 0) AndAlso FSorted Then
			Return This.Insert(-1, iValue, Obj)
		Else
			Dim As WStringListItem Ptr nItem = _New(WStringListItem)
			If nItem = 0 Then Return FCount - 1
			With *nItem
				.Value  = iValue
				.Object = Obj
			End With
			FItems.Add nItem
			FCount = FItems.Count
			If OnAdd Then OnAdd(This, iValue, Obj)
			Return FCount - 1
		End If
	End Function
#endif

Private Function WStringList.Insert(ByVal Index As Integer, ByRef iValue As WString, Obj As Any Ptr = 0) As Integer
	Dim As Integer j
	If (CBool(Index = -1) OrElse FSorted) AndAlso CBool(FCount > 0) Then ' Sorted Insert
		Dim As Integer LeftIndex = 0, RightIndex = FCount - 1, MidIndex, cmpResult
		While LeftIndex <= RightIndex
			MidIndex = (RightIndex + LeftIndex) \ 2
			cmpResult = StringsCompare(Item(MidIndex), iValue, FMatchCase, FDirection, FNaturalSort)
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
	Dim As WStringListItem Ptr nItem = _New( WStringListItem)
	If nItem = 0 Then Return -1
	With *nItem
		.Value  = iValue
		.Object = Obj
	End With
	FItems.Insert j, nItem
	FCount = FItems.Count
	If OnInsert Then OnInsert(This, Index, iValue, Obj)
	Return j
End Function

Private Sub WStringList.Exchange(Index1 As Integer, Index2 As Integer)
	FItems.Exchange Index1, Index2
	If OnExchange Then OnExchange(This, Index1, Index2)
End Sub

Private Sub WStringList.Remove(Index As Integer)
	If Index < 0 OrElse Index >= FCount Then Exit Sub
	If FItems.Items[Index] <> 0 Then _Delete(Cast(WStringListItem Ptr, FItems.Items[Index]))
	FItems.Remove Index 'Maybe not remove success
	FCount = FItems.Count
	If OnRemove Then OnRemove(This, Index)
End Sub

#ifndef WStringList_Sort_Off
	' iDirection: SORT_ASCENDING (1) 为升序(默认), SORT_DESCENDING (-1) 为降序
	Sub WStringList.Sort(ByVal bMatchCase As Boolean = False, ByVal iDirection As Integer = 1, ByVal bNaturalSort As Boolean = False)
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
			Dim As WString Ptr sPivotPtr = @(Item((iLow + iHigh) \ 2))
			If sPivotPtr = 0 Then Return
			Do
				' iDirection 乘数直接控制比较逻辑，无需重写两套排序代码
				While iL <= iHigh AndAlso StringsCompare(Item(iL), *sPivotPtr, bMatchCase, iDirection, bNaturalSort) < 0
					iL += 1
				Wend
				While iR >= iLow AndAlso StringsCompare(Item(iR), *sPivotPtr, bMatchCase, iDirection, bNaturalSort) > 0
					iR -= 1
				Wend
				
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
			While j > iLBound AndAlso StringsCompare(Item(j - 1), Item(j), bMatchCase, iDirection, bNaturalSort) > 0
				Exchange j - 1, j
				j -= 1
			Wend
		Next i
		FSorted = True
		FMatchCase = bMatchCase : FNaturalSort = bNaturalSort : FDirection = iDirection
		If OnChange Then OnChange(This)
	End Sub
#endif

Private Sub WStringList.Clear
	FSorted = False : FMatchCase = False : FDirection = 1 : FNaturalSort = False : FMatchFullWords = False 
	If FCount = 0 Then Return
	For i As Integer = FCount - 1 To 0 Step -1
		If FItems.Items[i] <> 0 Then _Delete(Cast(WStringListItem Ptr, FItems.Items[i]))
	Next
	FItems.Clear
	FCount = 0
	If OnClear Then OnClear(This)
End Sub

Private Sub WStringList.SaveToFile(ByRef FileName As WString)
	Dim As Integer Fn
	Fn = FreeFile_
	If Open(FileName For Output Encoding "utf-8" As #Fn) = 0 Then 'David Change
		For i As Integer = 0 To FCount -1
			Print #Fn, Item(i)
		Next
	End If
	CloseFile_(Fn)
End Sub

Private Sub WStringList.LoadFromFile(ByRef FileName As WString)
	Dim As Integer Fn = FreeFile_, Result = -1
	Dim Buff As WString * 2048 'David Change for V1.07 Line Input not working fine
	'If Open(FileName For Binary Access Read As #F) = 0 Then
	Result = Open(FileName For Input Encoding "utf-8" As #Fn)
	If Result <> 0 Then Result = Open(FileName For Input Encoding "utf-16" As #Fn)
	If Result <> 0 Then Result = Open(FileName For Input Encoding "utf-32" As #Fn)
	If Result <> 0 Then Result = Open(FileName For Input As #Fn)
	If Result = 0 Then  'David Change
		' WReallocate FText, LOF(F) + 1
		This.Clear
		While Not EOF(Fn)
			Line Input #Fn, Buff
			Add Trim(Buff)
		Wend
	End If
	CloseFile_(Fn)
End Sub

#ifndef WStringList_IndexOf_Off
	Private Function WStringList.IndexOf(ByRef iValue As Const WString, ByVal bMatchCase As Boolean = False, ByVal bMatchFullWords As Boolean = True, ByVal iStart As Integer = 0, ByRef ItemPtr As WStringListItem Ptr = 0) As Integer
		'If iValue = "" OrElse FCount < 1 Then Return -1 'We should allow add a empty records. Will get trouble in TreeListview if not allowed.
		If FCount < 1 Then Return -1
		If iStart < 0 Then iStart = 0
		If FMatchCase <> bMatchCase Then
			FMatchCase = bMatchCase
			This.Sort(bMatchCase, FDirection, FNaturalSort)
		End If
		If FSorted AndAlso FCount > 1 Then  'Fast Binary Search
			Dim As Integer LeftIndex = iStart, RightIndex = FCount - 1, MidIndex, cmpResult
			Dim As Integer FoundIndex = -1 '用于记录找到的第一个索引
			While LeftIndex <= RightIndex
				MidIndex = (RightIndex + LeftIndex) \ 2
				ItemPtr = FItems.Item(MidIndex)
				If ItemPtr = 0 Then Return -1
				cmpResult = StringsCompare(ItemPtr->Value, iValue, bMatchCase, FDirection, FNaturalSort)
				If cmpResult > 0 Then
					RightIndex = MidIndex - 1
				ElseIf cmpResult < 0 Then
					LeftIndex = MidIndex + 1
				Else
					FoundIndex = MidIndex     ' 记录当前找到的位置
					RightIndex = MidIndex - 1 ' 继续向左收缩，寻找更早出现（首次）的索引
				End If
			Wend
			Return IIf(bMatchFullWords, FoundIndex, LeftIndex)
		Else
			For j As Integer = iStart To FCount - 1
				ItemPtr = FItems.Item(j)
				If ItemPtr = 0 Then Return -1
				If StringsCompare(ItemPtr->Value, iValue, bMatchCase, FDirection, FNaturalSort) = 0 Then Return j
			Next
			Return -1
		End If
	End Function
#endif

Private Function WStringList.Contains(ByRef iValue As Const WString, ByVal bMatchCase As Boolean = False, ByVal bMatchFullWords As Boolean = True, ByVal iStart As Integer = 0, ByRef Idx As Integer = -1, ByRef ListItem As WStringListItem Ptr = 0) As Boolean
	Idx = IndexOf(iValue, bMatchCase, bMatchFullWords, iStart, ListItem)
	Return Idx <> -1
End Function

#ifndef WStringList_IndexOObject_Off
	Private Function WStringList.IndexOfObject(Obj As Any Ptr) As Integer
		If Obj = 0 OrElse FCount < 1 Then Return -1
		For j As Integer = 0 To FCount - 1
			If Object(j) = Obj Then Return j
		Next
		Return -1
	End Function
#endif

Private Function WStringList.ContainsObject(Obj As Any Ptr) As Boolean
	Return IndexOfObject(Obj) <> -1
End Function

Private Function WStringList.CountOf(ByRef iValue As WString) As Integer
	Dim iCount As Integer
	For i As Integer = 0 To FCount - 1
		If LCase(Item(i)) = LCase(iValue) Then iCount += 1
	Next i
	Return iCount
End Function

Private Operator WStringList.Let(ByRef Value As WString)
	This.Text = Value
End Operator

Private Constructor WStringList
	FCount = 0
	FMatchFullWords = True
	FDirection = 1
End Constructor

Private Destructor WStringList
	This.Clear
	If FText Then Deallocate((FText))
End Destructor