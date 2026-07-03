'###############################################################################
'#  Dictionary.bi                                                              #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TStringList.bi                                                            #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Adapted to Dictionary by Xusinboy Bekchanov(2018-2019)  Liu XiaLin         #
'###############################################################################

#include once "Dictionary.bi"

'DictionaryItem
#ifndef DictionaryItem_Key_Get_Off
	Private Property DictionaryItem.Key ByRef As WString
		If FKey <> 0 Then Return *FKey Else Return ""
	End Property
#endif

Private Property DictionaryItem.Key(ByRef v As WString)
	WLet(FKey, v)
End Property

#ifndef DictionaryItem_Text_Get_Off
	Private Property DictionaryItem.Text ByRef As WString
		If FText <>0 Then Return *FText Else Return ""
	End Property
#endif

Private Property DictionaryItem.Text(ByRef v As WString)
	WLet(FText, v)
End Property

Private Constructor DictionaryItem
	Key = ""
	Text = ""
	Object = 0
End Constructor

Private Destructor DictionaryItem
	If FKey Then _Deallocate(FKey)
	If FText Then _Deallocate(FText)
End Destructor

Private Operator DictionaryItem.Cast As Any Ptr
	Return @This
End Operator

#ifndef Dictionary_Count_Get_Off
	Private Property Dictionary.Count As Integer
		Return FItems.Count
	End Property
#endif

Private Property Dictionary.Count(value As Integer)
End Property

#ifndef Dictionary_Item_Get_Integer_Off
	Private Property Dictionary.Item(Index As Integer) As DictionaryItem Ptr
		If Index >= 0 And Index <= Count - 1 Then Return FItems.Items[Index] Else Return 0
	End Property
#endif

Private Property Dictionary.Item(Index As Integer, iItem As DictionaryItem Ptr)
	If Index >= 0 And Index <= Count -1 Then
		FItems.Items[Index] = iItem
		Sorted = False
		SortKeysed = False
		If OnChange Then OnChange(This)
	End If
End Property

Private Property Dictionary.Item(ByRef iKey As WString) As DictionaryItem Ptr
	Dim As Integer Index = IndexOfKey(iKey)
	If Index >= 0 Then Return FItems.Items[Index] Else Return 0
End Property

Private Property Dictionary.Item(ByRef iKey As WString, iItem As DictionaryItem Ptr)
	Dim As Integer Index = IndexOfKey(iKey)
	If Index >= 0 Then
		FItems.Items[Index] = iItem
		If OnChange Then OnChange(This)
	End If
End Property

#ifndef Dictionary_Add_Off
	Private Sub Dictionary.Add(ByRef iKey As WString = "", ByRef wText As WString = "", iObject As Any Ptr = 0)
		Dim As DictionaryItem Ptr nItem = _New(DictionaryItem)
		If nItem = 0 Then Return
		With *nItem
			.Key  = iKey
			.Text = wText
			.Object = iObject
		End With
		FItems.Add nItem
		Sorted = False
		SortKeysed = False
		If OnChange Then OnChange(This)
	End Sub
#endif

Private Sub Dictionary.Set(ByRef iKey As WString, ByRef wText As WString = "", iObject As Any Ptr = 0)
	Dim As Integer Index = IndexOfKey(iKey)
	If Index = -1 Then
		This.Add iKey, wText, iObject
	Else
		If FItems.Items[Index] = 0 Then Return
		Cast(DictionaryItem Ptr, FItems.Items[Index])->Text = wText
		Cast(DictionaryItem Ptr, FItems.Items[Index])->Object = iObject
	End If
	Sorted = False
	SortKeysed = False
	If OnChange Then OnChange(This)
End Sub

Private Function Dictionary.Get(ByRef iKey As WString, ByRef DefaultText As WString = "") ByRef As WString
	Dim As Integer Index = IndexOfKey(iKey)
	If Index >= 0 And Index <= Count - 1 AndAlso FItems.Items[Index] <> 0 Then
		Return Cast(DictionaryItem Ptr, FItems.Items[Index])->Text
	Else
		Return DefaultText
	End If
End Function

Private Function Dictionary.Get(Index As Integer, ByRef DefaultText As WString = "") ByRef As WString
	If Index >= 0 And Index <= Count - 1 Then
		Return Item(Index)->Text
	Else
		Return DefaultText
	End If
End Function

Private Sub Dictionary.Insert(Index As Integer, ByRef iKey As WString = "", ByRef wText As WString = "", iObject As Any Ptr = 0)
	Dim As DictionaryItem Ptr nItem = _New(DictionaryItem)
	If nItem = 0 Then Return
	With *nItem
		.Key  = iKey
		.Text = wText
		.Object = iObject
	End With
	FItems.Insert Index, nItem
	Sorted = False
	SortKeysed = False
	If OnChange Then OnChange(This)
End Sub

Private Sub Dictionary.Exchange(Index1 As Integer, Index2 As Integer)
	FItems.Exchange(Index1, Index2)
	If OnChange Then OnChange(This)
End Sub

Private Sub Dictionary.Remove(Index As Integer)
	If Index >= 0 And Index <= Count - 1 Then
		_Delete(Cast(DictionaryItem Ptr, FItems.Items[Index]))
		FItems.Remove Index
		If OnChange Then OnChange(This)
	End If
End Sub

#ifndef Dictionary_Sort_Off
	Private Function Dictionary.CompareStrings(ByRef s1 As WString, ByRef s2 As WString, ByVal bMatchCase As Boolean = True, ByVal bNaturalSort As Boolean = False) As Integer
		Dim As Integer iLen1 = Len(s1)
		Dim As Integer iLen2 = Len(s2)
		Dim As Integer i1 = 0, i2 = 0
		Dim As Long c1, c2
		
		While i1 < iLen1 AndAlso i2 < iLen2
			c1 = s1[i1]
			c2 = s2[i2]
			' 判断当前字符是否构成数值的起始（数字，或后跟数字的 +/- 符号）
			Dim isNum1 As Boolean = (c1 >= 48 AndAlso c1 <= 57) OrElse _
			((c1 = 43 OrElse c1 = 45) AndAlso (i1 + 1 < iLen1) AndAlso (s1[i1+1] >= 48 AndAlso s1[i1+1] <= 57))
			Dim isNum2 As Boolean = (c2 >= 48 AndAlso c2 <= 57) OrElse _
			((c2 = 43 OrElse c2 = 45) AndAlso (i2 + 1 < iLen2) AndAlso (s2[i2+1] >= 48 AndAlso s2[i2+1] <= 57))
			
			' 开启数值排序，且两端当前都是数值起点
			If bNaturalSort AndAlso isNum1 AndAlso isNum2 Then
				' --- 解析 s1 数值 ---
				Dim sign1 As Double = 1.0
				If s1[i1] = 43 Then i1 += 1 '+'
				If s1[i1] = 45 Then sign1 = -1.0: i1 += 1 '-
				
				Dim num1_int As LongInt = 0
				While i1 < iLen1 AndAlso s1[i1] >= 48 AndAlso s1[i1] <= 57
					num1_int = num1_int * 10 + (s1[i1] - 48)
					i1 += 1
				Wend
				
				Dim num1_frac As Double = 0.0
				If i1 < iLen1 AndAlso s1[i1] = 46 Then ' 处理小数部分
					i1 += 1
					Dim divisor As Double = 10.0
					While i1 < iLen1 AndAlso s1[i1] >= 48 AndAlso s1[i1] <= 57
						num1_frac = num1_frac + (s1[i1] - 48) / divisor
						divisor *= 10.0
						i1 += 1
					Wend
				End If
				Dim val1 As Double = sign1 * (num1_int + num1_frac)
				
				' --- 解析 s2 数值 ---
				Dim sign2 As Double = 1.0
				If s2[i2] = 43 Then i2 += 1
				If s2[i2] = 45 Then sign2 = -1.0: i2 += 1
				
				Dim num2_int As LongInt = 0
				While i2 < iLen2 AndAlso s2[i2] >= 48 AndAlso s2[i2] <= 57
					num2_int = num2_int * 10 + (s2[i2] - 48)
					i2 += 1
				Wend
				
				Dim num2_frac As Double = 0.0
				If i2 < iLen2 AndAlso s2[i2] = 46 Then ' 处理小数部分
					i2 += 1
					Dim divisor As Double = 10.0
					While i2 < iLen2 AndAlso s2[i2] >= 48 AndAlso s2[i2] <= 57
						num2_frac = num2_frac + (s2[i2] - 48) / divisor
						divisor *= 10.0
						i2 += 1
					Wend
				End If
				Dim val2 As Double = sign2 * (num2_int + num2_frac)
				
				' --- 比较解析出的数值 ---
				If val1 < val2 Then Return -1
				If val1 > val2 Then Return 1
				' 数值相等则继续往后比较后续字符
				Continue While
			End If
			
			' 非数字字符按原逻辑处理大小写
			If Not bMatchCase Then
				If c1 >= 65 AndAlso c1 <= 90 Then c1 += 32 ' A-Z -> a-z
				If c2 >= 65 AndAlso c2 <= 90 Then c2 += 32
			End If
			
			If c1 < c2 Then Return -1
			If c1 > c2 Then Return 1
			
			i1 += 1
			i2 += 1
		Wend
		
		' 前缀完全相同，较短的字符串更小
		If iLen1 < iLen2 Then Return -1
		If iLen1 > iLen2 Then Return 1
		Return 0
		
	End Function
	' iDirection: SORT_ASCENDING (1) 为升序(默认), SORT_DESCENDING (-1) 为降序
	Sub Dictionary.Sort(ByVal bMatchCase As Boolean = False, ByVal iDirection As Long = 1, ByVal bNaturalSort As Boolean = False)
		If FItems.Count <= 1 Then Return
		'Dim As Boolean flag
		Sorted = True
		SortKeysed  = False
		FSortMatchCase = bMatchCase
		' 栈元素结构
		Type SortStackItem
			iLow As Long
			iHigh As Long
		End Type
		' 插入排序的阈值，小于此值切换为插入排序
		Const INSERTION_SORT_THRESHOLD As Long = 32 'can be 16
		Dim As Long iLBound = 0
		Dim As Long iUBound = FItems.Count  - 1
		If iUBound <= iLBound Then Return
		'栈最大深度 (应对极度偏斜的划分，64足够处理2^64个元素)
		Dim arrStack(0 To 63) As SortStackItem
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
			Dim As DictionaryItem Ptr sPivotPtr = Item((iLow + iHigh) \ 2)
			If sPivotPtr = 0 Then Return
			Do
				' iDirection 乘数直接控制比较逻辑，无需重写两套排序代码
				While CompareStrings(Item(iL)->Text, sPivotPtr->Text, bMatchCase, bNaturalSort) * iDirection < 0
					iL += 1
				Wend
				While CompareStrings(Item(iR)->Text, sPivotPtr->Text, bMatchCase, bNaturalSort) * iDirection > 0
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
			While j > iLBound AndAlso CompareStrings(Item(j - 1)->Text, Item(j)->Text, bMatchCase, bNaturalSort) * iDirection > 0
				Exchange j - 1, j
				j -= 1
			Wend
		Next i
		If OnChange Then OnChange(This)
	End Sub
#endif

#ifndef Dictionary_SortKeys_Off
	Private Sub Dictionary.SortKeys(ByVal bMatchCase As Boolean = False, ByVal iDirection As Long = 1, ByVal bNaturalSort As Boolean = False)
		If FItems.Count <= 1 Then Return
		'Dim As Boolean flag
		FSortKeysMatchCase = bMatchCase
		SortKeysed = True
		Sorted = False
		' 栈元素结构
		Type SortStackItem
			iLow As Long
			iHigh As Long
		End Type
		' 插入排序的阈值，小于此值切换为插入排序
		Const INSERTION_SORT_THRESHOLD As Long = 32 'can be 16
		Dim As Long iLBound = 0
		Dim As Long iUBound = FItems.Count  - 1
		If iUBound <= iLBound Then Return
		'栈最大深度 (应对极度偏斜的划分，64足够处理2^64个元素)
		Dim arrStack(0 To 64 - 1) As SortStackItem
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
			Dim As DictionaryItem Ptr sPivotPtr = Item((iLow + iHigh) \ 2)
			If sPivotPtr = 0 Then Return
			Do
				' iDirection 乘数直接控制比较逻辑，无需重写两套排序代码
				While CompareStrings(Item(iL)->Key, sPivotPtr->Key, bMatchCase, bNaturalSort) * iDirection < 0
					iL += 1
				Wend
				While CompareStrings(Item(iR)->Key, sPivotPtr->Key, bMatchCase, bNaturalSort) * iDirection > 0
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
			While j > iLBound AndAlso CompareStrings(Item(j - 1)->Key, Item(j)->Key, bMatchCase, bNaturalSort) * iDirection > 0
				Exchange j - 1, j
				j -= 1
			Wend
		Next i
		If OnChange Then OnChange(This)
	End Sub
#endif

Private Sub Dictionary.Clear
	If FItems.Count < 1 Then Exit Sub
	For i As Integer = FItems.Count - 1 To 0 Step -1
		_Delete(Cast(DictionaryItem Ptr, FItems.Items[i]))
	Next i
	FItems.Clear
	If OnChange Then OnChange(This)
End Sub

Private Sub Dictionary.SaveToFile(ByRef FileName As WString)
	If FItems.Count < 1 Then Exit Sub
	Dim As Integer Fn = FreeFile_
	'If Open(FileName For Binary Access Write As #F) = 0 Then
	If Open(FileName For Output Encoding "utf-8" As #Fn) = 0 Then 'David Change
		For i As Integer = 0 To FItems.Count - 1
			If Item(i) = 0 Then Continue For
			Print #Fn, Replace(Item(i)->Key, Chr(9), "    ") & Chr(9) & Replace(Item(i)->Text, Chr(9), "    ")
		Next
	End If
	CloseFile_(Fn)
End Sub

Private Sub Dictionary.LoadFromFile(ByRef Filename As WString)
	Dim As Integer Fn = FreeFile_
	Dim As Boolean IsTextStr
	If Open(Filename For Input Encoding "utf-8" As #Fn) <> 0 Then Exit Sub
	Dim FileSize As Integer = LOF(Fn)
	If FileSize = 0 Then Close #Fn : Exit Sub
	Dim pBuff As WString Ptr
	WLet(pBuff, WInput(FileSize, #Fn))
	Close #Fn
	If pBuff > 0 AndAlso Trim(*pBuff, "") <> "" Then
		Dim As WString Ptr res(Any)
		Split(*pBuff, Chr(9), res())
		If UBound(res) < 1 Then Exit Sub
		For j As Integer = 0 To UBound(res) - 1 Step 2
			If res(j) = 0 OrElse res(j + 1) = 0 Then Continue For
			Dim As DictionaryItem Ptr nItem = _New(DictionaryItem)
			If nItem Then
				nItem->Key = *res(j)
				nItem->Text = *res(j+1)
				FItems.Add nItem
			End If
			_Deallocate(res(j))
			_Deallocate(res(j + 1))
		Next
		Erase res
	End If
	WDeAllocate(pBuff)
	If OnChange Then OnChange(This)
End Sub

#ifndef Dictionary_IndexOf_Off
	Private Function Dictionary.IndexOf(ByRef wText As WString, ByVal MatchCase As Boolean = False, ByVal MatchFullWords As Boolean = True, ByVal iStart As Integer = 0) As Integer
		If Trim(wText) = "" OrElse FItems.Count < 1 Then Return -1
		Dim As WString Ptr pfindKey, curTextPtr
		If FSortMatchCase Then WLet(pfindKey, wText) Else WLet(pfindKey, LCase(wText))
		If pfindKey = 0 Then Return -1
		If Sorted AndAlso MatchFullWords = False AndAlso MatchCase = FSortMatchCase Then  'Fast Binary Search
			Dim As Integer LeftIndex = iStart , RightIndex = FItems.Count - 1,  MidIndex = (FItems.Count - 1 + iStart) \ 2
			While (LeftIndex <= RightIndex And LeftIndex < FItems.Count And RightIndex >= 0)
				MidIndex = (RightIndex + LeftIndex) \ 2
				If FSortMatchCase Then WLet(curTextPtr, QDictionaryItem(FItems.Items[MidIndex]).Text) Else WLet(curTextPtr, LCase(QDictionaryItem(FItems.Items[MidIndex]).Text))
				If curTextPtr = 0 Then Return -1
				If *curTextPtr = *pfindKey Then
					_Deallocate(pfindKey) : _Deallocate(curTextPtr)
					Return MidIndex
				ElseIf *curTextPtr < *pfindKey Then
					LeftIndex = MidIndex + 1
				Else
					RightIndex = MidIndex - 1
				End If
			Wend
			_Deallocate(pfindKey) : _Deallocate(curTextPtr)
			Return -1
		Else
			If MatchFullWords Then
				For i As Integer = iStart To FItems.Count - 1
					If MatchCase Then WLet(curTextPtr, QDictionaryItem(FItems.Items[i]).Text) Else WLet(curTextPtr, LCase(QDictionaryItem(FItems.Items[i]).Text))
					If curTextPtr = 0 Then Return -1
					If *curTextPtr = *pfindKey Then
						_Deallocate(pfindKey) : _Deallocate(curTextPtr)
						Return i
					End If
				Next
			Else
				For i As Integer = iStart To FItems.Count - 1
					If MatchCase Then WLet(curTextPtr, QDictionaryItem(FItems.Items[i]).Text) Else WLet(curTextPtr, LCase(QDictionaryItem(FItems.Items[i]).Text))
					If curTextPtr = 0 Then Return -1
					If InStr(*curTextPtr, *pfindKey) Then
						_Deallocate(pfindKey) : _Deallocate(curTextPtr)
						Return i
					End If
				Next
			End If
		End If
		_Deallocate(pfindKey) : _Deallocate(curTextPtr)
		Return -1
	End Function
#endif

#ifndef Dictionary_IndexOfKey_Off
	Private Function Dictionary.IndexOfKey(ByRef iKey As WString, iObject As Any Ptr = 0, ByVal MatchCase As Boolean = False) As Integer
		If Trim(iKey) = "" OrElse FItems.Count < 1 Then Return -1
		Dim As WString Ptr pfindKey, curTextPtr
		If Not MatchCase Then WLet(pfindKey, LCase(iKey)) Else WLet(pfindKey, iKey)
		If pfindKey = 0 Then Return -1
		If SortKeysed AndAlso MatchCase = FSortKeysMatchCase Then  'Fast Binary Search
			Dim As Integer LeftIndex = 0, RightIndex = FItems.Count - 1,  MidIndex = (FItems.Count - 1) Shr 1
			While (LeftIndex <= RightIndex)
				MidIndex = (RightIndex + LeftIndex) \ 2
				If MatchCase Then WLet(curTextPtr, QDictionaryItem(FItems.Items[MidIndex]).Key) Else WLet(curTextPtr, LCase(QDictionaryItem(FItems.Items[MidIndex]).Key))
				If curTextPtr = 0 Then Return -1
				If *curTextPtr = *pfindKey Then
					_Deallocate(pfindKey)
					Return MidIndex
				ElseIf *curTextPtr < *pfindKey Then
					LeftIndex = MidIndex + 1
				Else
					RightIndex = MidIndex - 1
				End If
			Wend
			_Deallocate(pfindKey) : _Deallocate(curTextPtr)
			Return -1
		Else
			For i As Integer = 0 To FItems.Count - 1
				If MatchCase Then WLet(curTextPtr, QDictionaryItem(FItems.Items[i]).Key) Else WLet(curTextPtr, LCase(QDictionaryItem(FItems.Items[i]).Key))
				If curTextPtr = 0 Then Return -1
				If *curTextPtr = *pfindKey Then
					_Deallocate(pfindKey) : _Deallocate(curTextPtr)
					Return i
				End If
			Next i
			_Deallocate(pfindKey) : _Deallocate(curTextPtr)
			Return -1
		End If
	End Function
#endif

#ifndef Dictionary_IndexOfObject_Off
	Private Function Dictionary.IndexOfObject(iObject As Any Ptr) As Integer
		If iObject = 0 OrElse FItems.Count < 1 Then Return -1
		For i As Integer = 0 To FItems.Count - 1
			If QDictionaryItem(FItems.Items[i]).Object = iObject Then Return i
		Next i
		Return -1
	End Function
#endif
Private Operator Dictionary.[](ByRef iKey As WString) ByRef As WString
	Dim As Integer iIndex = IndexOfKey(iKey)
	If iIndex >= 0 Then Return QDictionaryItem(FItems.Items[iIndex]).Text
	Return ""
End Operator

Private Function Dictionary.GetText(ByRef iKey As WString, ByVal MatchCase As Boolean = False) ByRef As WString
	Dim As Integer iIndex = IndexOfKey(iKey, , MatchCase)
	If iIndex >= 0 Then Return QDictionaryItem(FItems.Items[iIndex]).Text
	Return ""
End Function

Private Function Dictionary.GetObject(ByRef iKey As WString, ByVal MatchCase As Boolean = False) As Any Ptr
	Dim As Integer iIndex = IndexOfKey(iKey, , MatchCase)
	If iIndex >= 0 Then Return QDictionaryItem(FItems.Items[iIndex]).Object
	Return 0
End Function

Private Function Dictionary.GetObject(Index As Integer) As Any Ptr
	If Index >= 0 AndAlso Index <= Count - 1 Then Return QDictionaryItem(FItems.Items[Index]).Object Else Return 0
End Function

Private Function Dictionary.GetKey(ByRef wText As WString, ByVal MatchCase As Boolean = False) ByRef As WString
	Dim As Integer iIndex = IndexOf(wText, MatchCase)
	If iIndex >= 0 Then Return QDictionaryItem(FItems.Items[iIndex]).Key
	Return ""
End Function

Private Function Dictionary.GetKey(iObject As Any Ptr) ByRef As WString
	Dim As Integer iIndex = IndexOfObject(iObject)
	If iIndex >= 0 Then Return QDictionaryItem(FItems.Items[iIndex]).Key
	Return ""
End Function

#ifndef Dictionary_Text_Get_Off
	Private Property Dictionary.Text ByRef As WString
		If FItems.Count < 1 Then Return ""
		WLet(FText, "")
		Dim As Integer Capacity
		For i As Integer = 0 To FItems.Count - 1
			If i <> FItems.Count - 1 Then
				WAdd(FText, Item(i)->Key & Chr(9) & " " & Item(i)->Text & Chr(13) & Chr(10), , Capacity)
			Else
				Capacity = 0
				WAdd(FText, Item(i)->Key & Chr(9) & " " & Item(i)->Text, , Capacity)
			End If
		Next i
		If FText <> 0 Then Return *FText Else Return ""
	End Property
#endif

#ifndef Dictionary_Text_Set_Off
	Private Property Dictionary.Text(ByRef value As WString)
		WLet(FText, "")
		This.Clear
		Dim As Integer Pos1, Capacity
		For i As Integer = 0 To Len(value)
			If value[i] = 10 Or value[i] = 0 Then
				WLetEx(FText, Trim(Mid(*FText, 1, Len(*FText)), Any WChr(13) & WChr(10)))
				Pos1 = InStr(*FText, WChr(9) & " ")
				Dim As DictionaryItem Ptr nItem = _New(DictionaryItem)
				If nItem = 0 Then Return
				With *nItem
					If Pos1 > 0 Then
						.Key  = ..Left(*FText, Pos1 - 1)
						.Text = Mid(*FText, Pos1 + 2)
					Else
						.Key  = *FText
					End If
				End With
				FItems.Add nItem
				WLet(FText, "")
				Capacity = 0
			Else
				WAdd(FText, WChr(value[i]), , Capacity)
			End If
		Next i
		If OnChange Then OnChange(This)
	End Property
#endif

Private Function Dictionary.Contains(ByRef wText As WString, ByVal MatchCase As Boolean = False) As Boolean
	Return IndexOf(wText, MatchCase) <> -1
End Function

Private Function Dictionary.ContainsKey(ByRef Key As WString, iObject As Any Ptr = 0, ByVal MatchCase As Boolean = False) As Boolean
	Return IndexOfKey(Key, iObject, MatchCase) <> -1
End Function

Private Function Dictionary.ContainsObject(iObject As Any Ptr) As Boolean
	Return IndexOfObject(iObject) <> -1
End Function

Private Operator Dictionary.Let(ByRef value As WString)
	This.Text = value
End Operator

Private Constructor Dictionary
	FItems.Clear
End Constructor

Private Destructor Dictionary
	If FItems.Count > 0 Then
		For i As Integer = FItems.Count - 1 To 0 Step -1
			_Delete(Cast(DictionaryItem Ptr, FItems.Items[i]))
		Next i
		FItems.Clear
		This.Clear
	End If
	If FText Then _Deallocate(FText)
End Destructor