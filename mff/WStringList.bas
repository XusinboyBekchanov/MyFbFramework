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
			WAdd(FText, Item(i), , Capacity)
		End If
	Next i
	If FText Then Return *FText Else Return ""
End Property

#ifndef WStringList_Text_Set_Off
	Private Property WStringList.Text(ByRef Value As WString)
		WLet(FText, "")
		This.Clear
		Dim As Integer Capacity
		For i As Integer = 0 To Len(Value)
			WAdd(FText, WChr(Value[i]), , Capacity)
			If Value[i] = 10 Or Value[i] = 0 Then
				This.Add Trim(Mid(*FText, 1, Len(*FText) - 1), Any WChr(13))
				WLet(FText, "")
			End If
		Next i
	End Property
#endif

Private Operator WStringList.[](Index As Integer) ByRef As WString
	Dim As Any Ptr FItemsItemsIndex = FItems.Item(Index)
	If FItemsItemsIndex <> 0 Then
		Return QWStringListItem(FItemsItemsIndex).Value
	Else
		Return ""
	End If
End Operator

Private Property WStringList.Item(Index As Integer) ByRef As WString
	Dim As Any Ptr FItemsItemsIndex = FItems.Item(Index)
	If FItemsItemsIndex <> 0 Then
		Return QWStringListItem(FItemsItemsIndex).Value
	Else
		Return ""
	End If
End Property

Private Property WStringList.Item(Index As Integer, iValue As WString)
	Dim As Any Ptr FItemsItemsIndex = FItems.Item(Index)
	If FItemsItemsIndex <> 0 Then QWStringListItem(FItemsItemsIndex).Value = iValue
End Property

Private Property WStringList.Object(Index As Integer) As Any Ptr
	Dim As Any Ptr FItemsItemsIndex = FItems.Item(Index)
	If FItemsItemsIndex <> 0 Then
		Return QWStringListItem(FItemsItemsIndex).Object
	Else
		Return 0
	End If
End Property

Private Property WStringList.Object(Index As Integer, Obj As Any Ptr)
	Dim As Any Ptr FItemsItemsIndex = FItems.Item(Index)
	If FItemsItemsIndex <> 0 Then QWStringListItem(FItemsItemsIndex).Object = Obj
End Property

#ifndef WStringList_Add_Off
	Private Function WStringList.Add(ByRef iValue As WString, Obj As Any Ptr = 0) As Integer
		'If iValue = "" Then Return -1 'We should allow add a empty records. Will gpt trouble in TreeListview if not allowed.
		If CBool(FCount > 0) AndAlso FSorted Then
			Return This.Insert(-1, iValue, Obj)
		Else
			'Dim As WString Ptr iText = CAllocate_((Len(iValue) + 1) * SizeOf(WString))
			'*iText = iValue
			'Items.Add iText
			'Objects.Add Obj
			'FCount = Items.Count
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
		Dim As Integer iStart = 0
		Dim As Integer LeftIndex = iStart, RightIndex = FCount - 1,  MidIndex = (FCount - 1 + iStart) \ 2
		j = FCount
		If FMatchCase Then  ' Action with the same sorting mode only
			While (LeftIndex <= RightIndex And LeftIndex < FCount And RightIndex >= 0 )
				MidIndex = (RightIndex + LeftIndex) \ 2
				If Item(MidIndex) > iValue AndAlso (MidIndex = 0 OrElse Item(MidIndex - 1) <= iValue) Then
					j = MidIndex: Exit While
				ElseIf Item(MidIndex) <= iValue Then
					LeftIndex = MidIndex + 1
				Else
					RightIndex = MidIndex - 1
				End If
			Wend
		Else
			While (LeftIndex <= RightIndex And LeftIndex < FCount And RightIndex >= 0 )
				MidIndex = (RightIndex + LeftIndex) \ 2
				If LCase(Item(MidIndex)) > LCase(iValue) AndAlso (MidIndex = 0 OrElse LCase(Item(MidIndex - 1)) <= LCase(iValue)) Then
					j = MidIndex: Exit While
				ElseIf LCase(Item(MidIndex)) <= LCase(iValue) Then
					LeftIndex = MidIndex + 1
				Else
					RightIndex = MidIndex - 1
				End If
			Wend
		End If
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
	Return j
	If OnInsert Then OnInsert(This, Index, iValue, Obj)
End Function

Private Sub WStringList.Exchange(Index1 As Integer, Index2 As Integer)
	'Items.Exchange Index1, Index2
	'Objects.Exchange Index1, Index2
	FItems.Exchange Index1, Index2
	If OnExchange Then OnExchange(This, Index1, Index2)
End Sub

Private Sub WStringList.Remove(Index As Integer)
	If Index < 0 OrElse Index >= FCount Then Exit Sub
	'If Items.Item(Index) > 0 Then Deallocate_(Items.Item(Index))
	'Items.Remove Index
	''If Objects.Item(Index) > 0 Then Delete Objects.Item(Index)
	'Objects.Remove Index
	'FCount = Items.Count
	_Delete(Cast(WStringListItem Ptr, FItems.Items[Index]))
	FItems.Remove Index 'Maybe not remove success
	FCount = FItems.Count
	If OnRemove Then OnRemove(This, Index)
End Sub
#ifndef WStringList_Sort_Off
	Private Function WStringList.CompareStrings(ByRef s1 As WString, ByRef s2 As WString, ByVal bMatchCase As Boolean = True, ByVal bNaturalSort As Boolean = False, ByVal iDirection As Long = 1) As Integer
		Dim As Integer iLen1 = Len(s1)
		Dim As Integer iLen2 = Len(s2)
		Dim As Integer i1 = 0, i2 = 0
		Dim As Long c1, c2
		
		While i1 < iLen1 AndAlso i2 < iLen2
			c1 = s1[i1]
			c2 = s2[i2]
			Dim isNum1 As Boolean = (c1 >= 48 AndAlso c1 <= 57) OrElse _
			((c1 = 43 OrElse c1 = 45) AndAlso (i1 + 1 < iLen1) AndAlso (s1[i1 + 1] >= 48 AndAlso s1[i1 + 1] <= 57))
			Dim isNum2 As Boolean = (c2 >= 48 AndAlso c2 <= 57) OrElse _
			((c2 = 43 OrElse c2 = 45) AndAlso (i2 + 1 < iLen2) AndAlso (s2[i2 + 1] >= 48 AndAlso s2[i2 + 1] <= 57))
			If bNaturalSort AndAlso isNum1 AndAlso isNum2 Then
				Dim sign1 As Double = 1.0
				If s1[i1] = 43 Then
					i1 += 1 '+'
				ElseIf s1[i1] = 45 Then   '-
					sign1 = -1.0
					i1 += 1
				End If
				Dim num1_int As LongInt = 0
				While i1 < iLen1 AndAlso s1[i1] >= 48 AndAlso s1[i1] <= 57
					num1_int = num1_int * 10 + (s1[i1] - 48)
					i1 += 1
				Wend
				
				Dim num1_frac As Double = 0.0
				If i1 < iLen1 AndAlso s1[i1] = 46 Then ' "."  Decimal part
					i1 += 1
					Dim divisor As Double = 10.0
					While i1 < iLen1 AndAlso s1[i1] >= 48 AndAlso s1[i1] <= 57
						num1_frac = num1_frac + (s1[i1] - 48) / divisor
						divisor *= 10.0
						i1 += 1
					Wend
				End If
				Dim val1 As Double = sign1 * (num1_int + num1_frac)
				
				Dim sign2 As Double = 1.0
				If s2[i2] = 43 Then
					i2 += 1
				ElseIf s2[i2] = 45 Then
					sign2 = -1.0
					i2 += 1
				End If
				
				Dim num2_int As LongInt = 0
				While i2 < iLen2 AndAlso s2[i2] >= 48 AndAlso s2[i2] <= 57
					num2_int = num2_int * 10 + (s2[i2] - 48)
					i2 += 1
				Wend
				
				Dim num2_frac As Double = 0.0
				If i2 < iLen2 AndAlso s2[i2] = 46 Then ' "."  Decimal part
					i2 += 1
					Dim divisor As Double = 10.0
					While i2 < iLen2 AndAlso s2[i2] >= 48 AndAlso s2[i2] <= 57
						num2_frac = num2_frac + (s2[i2] - 48) / divisor
						divisor *= 10.0
						i2 += 1
					Wend
				End If
				Dim val2 As Double = sign2 * (num2_int + num2_frac)
				If val1 < val2 Then Return -1 * iDirection
				If val1 > val2 Then Return 1 * iDirection
				Continue While
			End If
			
			If Not bMatchCase Then
				If c1 >= 65 AndAlso c1 <= 90 Then c1 += 32 ' A-Z -> a-z
				If c2 >= 65 AndAlso c2 <= 90 Then c2 += 32
			End If
			If c1 < c2 Then Return -1 * iDirection
			If c1 > c2 Then Return 1 * iDirection
			
			i1 += 1
			i2 += 1
		Wend
		If iLen1 < iLen2 Then Return -1 * iDirection
		If iLen1 > iLen2 Then Return 1 * iDirection
		Return 0
		
	End Function
	' iDirection: SORT_ASCENDING (1) 为升序(默认), SORT_DESCENDING (-1) 为降序
	Sub WStringList.Sort(ByVal bMatchCase As Boolean = False, ByVal iDirection As Long = 1, ByVal bNaturalSort As Boolean = False)
		If FCount <= 1 Then Return
		Const INSERTION_SORT_THRESHOLD As Long = 32 'can be 16
		Dim As Long iLBound = 0
		Dim As Long iUBound = FCount - 1
		If iUBound <= iLBound Then Return
		Type SortStackItem
			iLow As Long
			iHigh As Long
		End Type
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
				While iL <= iHigh AndAlso CompareStrings(Item(iL), *sPivotPtr, bMatchCase, bNaturalSort, iDirection) < 0
					iL += 1
				Wend
				While iR >= iLow AndAlso CompareStrings(Item(iR), *sPivotPtr, bMatchCase, bNaturalSort, iDirection) > 0
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
			While j > iLBound AndAlso CompareStrings(Item(j - 1), Item(j), bMatchCase, bNaturalSort) * iDirection > 0
				Exchange j - 1, j
				j -= 1
			Wend
		Next i
		FSorted = True
		If OnChange Then OnChange(This)
	End Sub
#endif

Private Sub WStringList.Clear
	If FCount = 0 Then Return
	For i As Integer = FCount - 1 To 0 Step -1
		If FItems.Items[i] <> 0 Then _Delete(Cast(WStringListItem Ptr, FItems.Items[i]))
	Next
	'Items.Clear
	'Objects.Clear
	FItems.Clear
	FCount = 0
	If OnClear Then OnClear(This)
End Sub

Private Sub WStringList.SaveToFile(ByRef FileName As WString)
	Dim As Integer Fn
	Fn = FreeFile_
	If Open(FileName For Output Encoding "utf-8" As #Fn) = 0 Then 'David Change
		For i As Integer = 0 To FCount -1
			'Print #Fn, *Cast(WString Ptr, Items.Item(i))
			Print #Fn, Item(i)
		Next
	End If
	CloseFile_(Fn)
End Sub

Private Sub WStringList.LoadFromFile(ByRef FileName As WString)
	'Items.LoadFromFile File
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
		Dim As WString Ptr ItemTextPtr
		If FCount < 1 Then Return -1
		If iStart < 0 Then iStart = 0
		If FMatchCase <> bMatchCase Then
			FMatchCase = bMatchCase
			This.Sort(bMatchCase, 0, FCount - 1)
		End If
		If FSorted AndAlso FCount > 1 Then  'Fast Binary Search
			Dim As Integer LeftIndex = iStart, RightIndex = FCount - 1,  MidIndex = (FCount - 1 + iStart) \ 2
			If FMatchCase Then  ' Action with the same sorting mode only
				While (LeftIndex <= RightIndex And LeftIndex < FCount And RightIndex >= 0 )
					MidIndex = (RightIndex + LeftIndex) \ 2
					ItemPtr = FItems.Item(MidIndex)
					If ItemPtr = 0 Then Return -1
					ItemTextPtr = @(ItemPtr->Value)
					If ItemTextPtr = 0 Then Return -1
					If *ItemTextPtr = iValue AndAlso (MidIndex = 0 OrElse Item(MidIndex - 1) <> iValue) Then
						Return MidIndex
					ElseIf *ItemTextPtr < iValue Then
						LeftIndex = MidIndex + 1
					Else
						RightIndex = MidIndex - 1
					End If
				Wend
				Return IIf(FMatchFullWords, -1, LeftIndex)
			Else
				Dim As WString Ptr iValuePtr
				WLet(iValuePtr, LCase(iValue))
				While (LeftIndex <= RightIndex And LeftIndex < FCount And RightIndex >= 0 )
					MidIndex = (RightIndex + LeftIndex) \ 2
					ItemPtr = FItems.Item(MidIndex)
					If ItemPtr = 0 Then
						If iValuePtr Then _Deallocate(iValuePtr)
						Return -1
					End If
					'ItemTextPtr = Items.Item(MidIndex)
					ItemTextPtr = @(ItemPtr->Value)
					If ItemTextPtr = 0 Then Return -1
					'If LCase(*ItemTextPtr) =  *iValuePtr  AndAlso (MidIndex = 0 OrElse LCase(*Cast(WString Ptr, Items.Item(MidIndex - 1))) <>  *iValuePtr ) Then
					If LCase(*ItemTextPtr) = *iValuePtr  AndAlso (MidIndex = 0 OrElse LCase(Item(MidIndex - 1)) <>  *iValuePtr ) Then
						If iValuePtr Then _Deallocate(iValuePtr)
						Return MidIndex
					ElseIf LCase(*ItemTextPtr) <  *iValuePtr  Then
						LeftIndex = MidIndex + 1
					Else
						RightIndex = MidIndex - 1
					End If
				Wend
				If iValuePtr Then _Deallocate(iValuePtr)
				Return IIf(FMatchFullWords, -1, LeftIndex)
			End If
		Else
			If FMatchCase Then
				For j As Integer = iStart To FCount - 1
					ItemPtr = FItems.Item(j)
					If ItemPtr = 0 Then Return -1
					'ItemTextPtr = Items.Item(j)
					ItemTextPtr = @(ItemPtr->Value)
					If ItemTextPtr = 0 Then Return -1
					If *ItemTextPtr = iValue Then Return j
				Next
			Else
				Dim As WString Ptr iValuePtr
				'Print "iValue=|" & iValue & "|"
				WLet(iValuePtr, LCase(iValue))
				For j As Integer = iStart To FCount - 1
					ItemPtr = FItems.Item(j)
					If ItemPtr = 0 Then
						If iValuePtr Then _Deallocate(iValuePtr)
						Return -1
					End If
					'ItemTextPtr = Items.Item(j)
					ItemTextPtr = @(ItemPtr->Value)
					If ItemTextPtr = 0 Then Return -1
					If LCase(*ItemTextPtr) =  *iValuePtr Then
						If iValuePtr Then _Deallocate(iValuePtr)
						Return j
					End If
				Next
			End If
			Return -1
		End If
	End Function
#endif

Private Function WStringList.Contains(ByRef iValue As Const WString, ByVal bMatchCase As Boolean = False, ByVal bMatchFullWords As Boolean = True, ByVal iStart As Integer = 0, ByRef Idx As Integer = -1, ByRef ListItem As WStringListItem Ptr = 0) As Boolean
	Idx = IndexOf(iValue, bMatchCase, True, iStart, ListItem)
	Return Idx <> -1
End Function

#ifndef WStringList_IndexOObject_Off
	Private Function WStringList.IndexOfObject(Obj As Any Ptr) As Integer
		If Obj = 0 OrElse FCount < 1 Then Return -1
		For j As Integer = 0 To FCount - 1
			'If Objects.Item(j) = Obj Then Return j
			If QWStringListItem(FItems.Item(j)).Object = Obj Then Return j
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
	'Items.Clear
	'Objects.Clear
	'This.Clear
	FCount = 0
	FMatchFullWords = True
	'FSorted = True
End Constructor

Private Destructor WStringList
	This.Clear
	If FText Then Deallocate((FText))
End Destructor