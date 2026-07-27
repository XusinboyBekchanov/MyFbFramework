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
		If Index >= 0 And Index <= FCount - 1 Then Return FItems.Items[Index] Else Return 0
	End Property
#endif

Private Property Dictionary.Item(Index As Integer, iItem As DictionaryItem Ptr)
	If Index >= 0 And Index <= FCount - 1 Then
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
		FCount = FItems.Count
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
	If Index >= 0 And Index <= FCount - 1 AndAlso FItems.Items[Index] <> 0 Then
		Return Cast(DictionaryItem Ptr, FItems.Items[Index])->Text
	Else
		Return DefaultText
	End If
End Function

Private Function Dictionary.Get(Index As Integer, ByRef DefaultText As WString = "") ByRef As WString
	If Index >= 0 And Index <= FCount - 1 Then
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
	FCount = FItems.Count
	If OnChange Then OnChange(This)
End Sub

Private Sub Dictionary.Exchange(Index1 As Integer, Index2 As Integer)
	FItems.Exchange(Index1, Index2)
	If OnChange Then OnChange(This)
End Sub

Private Sub Dictionary.Remove(Index As Integer)
	If Index >= 0 And Index <= FCount - 1 Then
		If FItems.Items[Index] <> 0 Then _Delete(Cast(DictionaryItem Ptr, FItems.Items[Index]))
		FItems.Remove Index
		FCount = FItems.Count
		If OnChange Then OnChange(This)
	End If
End Sub

#ifndef Dictionary_Sort_Off
	' iDirection: SORT_ASCENDING (1) 为升序(默认), SORT_DESCENDING (-1) 为降序
	Sub Dictionary.Sort(ByVal bMatchCase As Boolean = False, ByVal iDirection As Long = 1, ByVal bNaturalSort As Boolean = False)
		If FCount <= 1 Then Return
		' 栈元素结构
		Type SortStackItem
			iLow As Long
			iHigh As Long
		End Type
		' 插入排序的阈值，小于此值切换为插入排序
		Const INSERTION_SORT_THRESHOLD As Long = 32 'can be 16
		Dim As Long iLBound = 0
		Dim As Long iUBound = FCount  - 1
		If iUBound <= iLBound Then Return
		'栈最大深度 (应对极度偏斜的划分，64足够处理2^64个元素)
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
			Dim As DictionaryItem Ptr sPivotPtr = Item((iLow + iHigh) \ 2)
			If sPivotPtr = 0 Then Return
			Do
				' iDirection 乘数直接控制比较逻辑，无需重写两套排序代码
				While StringsCompare(Item(iL)->Text, sPivotPtr->Text, bMatchCase, iDirection, bNaturalSort) < 0
					iL += 1
				Wend
				While StringsCompare(Item(iR)->Text, sPivotPtr->Text, bMatchCase, iDirection, bNaturalSort) > 0
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
			While j > iLBound AndAlso StringsCompare(Item(j - 1)->Text, Item(j)->Text, bMatchCase, iDirection, bNaturalSort) > 0
				Exchange j - 1, j
				j -= 1
			Wend
		Next i
		Sorted = True 
		SortKeysed = False
		SortedMatchCase = bMatchCase
		SortedDirection = iDirection
		SortedNaturalSort = bNaturalSort
		If OnChange Then OnChange(This)
	End Sub
#endif

#ifndef Dictionary_SortKeys_Off
	Private Sub Dictionary.SortKeys(ByVal bMatchCase As Boolean = False, ByVal iDirection As Long = 1, ByVal bNaturalSort As Boolean = False)
		If FCount <= 1 Then Return
		' 栈元素结构
		Type SortStackItem
			iLow As Long
			iHigh As Long
		End Type
		' 插入排序的阈值，小于此值切换为插入排序
		Const INSERTION_SORT_THRESHOLD As Long = 32 'can be 16
		Dim As Long iLBound = 0
		Dim As Long iUBound = FCount  - 1
		If iUBound <= iLBound Then Return
		'栈最大深度 (应对极度偏斜的划分，64足够处理2^64个元素)
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
			Dim As DictionaryItem Ptr sPivotPtr = Item((iLow + iHigh) \ 2)
			If sPivotPtr = 0 Then Return
			Do
				' iDirection 乘数直接控制比较逻辑，无需重写两套排序代码
				While StringsCompare(Item(iL)->Key, sPivotPtr->Key, bMatchCase, iDirection, bNaturalSort) < 0
					iL += 1
				Wend
				While StringsCompare(Item(iR)->Key, sPivotPtr->Key, bMatchCase, iDirection, bNaturalSort) > 0
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
			While j > iLBound AndAlso StringsCompare(Item(j - 1)->Key, Item(j)->Key, bMatchCase, iDirection, bNaturalSort) > 0
				Exchange j - 1, j
				j -= 1
			Wend
		Next i
		Sorted = False
		SortKeysed = True
		SortKeysMatchCase = bMatchCase
		SortKeysDirection = iDirection
		SortKeysNaturalSort = bNaturalSort
		If OnChange Then OnChange(This)
	End Sub
#endif

Private Sub Dictionary.Clear
	Sorted = False : SortedMatchCase = False : SortedDirection = 1 : SortedNaturalSort = False : SortedMatchFullWords = False 
	SortKeysed = False : SortKeysMatchCase = False : SortKeysDirection = 1 : SortKeysNaturalSort = False
	If FCount = 0 Then Return
	For i As Integer = FCount - 1 To 0 Step -1
		If FItems.Items[i] <> 0 Then _Delete(Cast(DictionaryItem Ptr, FItems.Items[i]))
	Next i
	FItems.Clear
	FCount = 0
	If OnChange Then OnChange(This)
End Sub

Private Sub Dictionary.SaveToFile(ByRef FileName As WString)
	If FCount < 1 Then Exit Sub
	Dim As Integer Fn = FreeFile_
	'If Open(FileName For Binary Access Write As #F) = 0 Then
	If Open(FileName For Output Encoding "utf-8" As #Fn) = 0 Then 'David Change
		For i As Integer = 0 To FCount - 1
			If Item(i) = 0 Then Continue For
			Print #Fn, Replace(Item(i)->Key, Chr(9), "    ") & Chr(9) & Replace(Item(i)->Text, Chr(9), "    ")
		Next
	End If
	CloseFile_(Fn)
End Sub

Private Sub Dictionary.LoadFromFile(ByRef Filename As WString)
	Dim As Integer Fn = FreeFile_
	If Open(Filename For Input Encoding "utf-8" As #Fn) <> 0 Then Exit Sub
	Dim FileSize As Integer = LOF(Fn)
	If FileSize = 0 Then Close #Fn : Exit Sub
	Dim pBuff As WString Ptr
	WLet(pBuff, WInput(FileSize, #Fn))
	Close #Fn
	If pBuff > 0 AndAlso Trim(*pBuff, "") <> "" Then
		Dim As WString Ptr lines(Any), parts(Any)
		Split(*pBuff, WChr(10), lines())
		For i As Integer = 0 To UBound(lines)
			If lines(i) = 0 OrElse *lines(i) = "" Then Continue For
			Split(RTrim(*lines(i), !"\r"), WChr(9), parts())
			If UBound(parts) >= 1 Then
				Dim As DictionaryItem Ptr nItem = _New(DictionaryItem)
				If nItem Then
					nItem->Key = *parts(0)
					nItem->Text = *parts(1)
					FItems.Add nItem
				End If
			End If
			For k As Integer = 0 To UBound(parts)
				If parts(k) Then _Deallocate(parts(k))
			Next
			Erase parts
			If lines(i) Then _Deallocate(lines(i))
		Next
		Erase lines
	End If
	WDeAllocate(pBuff)
	If OnChange Then OnChange(This)
End Sub

#ifndef Dictionary_IndexOf_Off
	Private Function Dictionary.IndexOf(ByRef wText As WString, ByVal bMatchCase As Boolean = False, ByVal bMatchFullWords As Boolean = True, ByVal iStart As Integer = 0) As Integer
		If Trim(wText) = "" OrElse FCount < 1 Then Return -1
		If iStart < 0 Then iStart = 0
		Dim As DictionaryItem Ptr ItemPtr
		If Sorted AndAlso bMatchFullWords = False AndAlso bMatchCase = SortedMatchCase Then  'Fast Binary Search
			Dim As Integer LeftIndex = iStart, RightIndex = FCount - 1, MidIndex, cmpResult
			Dim As Integer FoundIndex = -1 '用于记录找到的第一个索引
			While LeftIndex <= RightIndex 
				MidIndex = (RightIndex + LeftIndex) \ 2
				ItemPtr = Item(MidIndex)
				If ItemPtr = 0 Then Return -1
				cmpResult = StringsCompare(ItemPtr->Text, wText, bMatchCase, SortedDirection, SortedNaturalSort)
				If cmpResult < 0 Then
					LeftIndex = MidIndex + 1
				ElseIf cmpResult > 0 Then
					RightIndex = MidIndex - 1
				Else
					FoundIndex = MidIndex     ' 记录当前找到的位置
					RightIndex = MidIndex - 1 ' 继续向左收缩，寻找更早出现（首次）的索引
				End If
			Wend
			Return IIf(bMatchFullWords, FoundIndex, LeftIndex)
		Else
			For j As Integer = iStart To FCount - 1
				ItemPtr = Item(j)
				If ItemPtr = 0 Then Return -1
				If StringsCompare(ItemPtr->Text, wText, bMatchCase, SortedDirection, SortedNaturalSort) = 0 Then Return j
			Next
			Return -1
		End If
	End Function
#endif

#ifndef Dictionary_IndexOfKey_Off
	Private Function Dictionary.IndexOfKey(ByRef iKey As WString, iObject As Any Ptr = 0, ByVal bMatchCase As Boolean = False) As Integer
		If Trim(iKey) = "" OrElse FCount < 1 Then Return -1
		Dim As DictionaryItem Ptr ItemPtr
		If SortKeysed AndAlso bMatchCase = SortKeysMatchCase Then  'Fast Binary Search
			Dim As Integer LeftIndex = 0, RightIndex = FCount - 1, MidIndex, cmpResult
			Dim As Integer FoundIndex = -1 '用于记录找到的第一个索引
			While LeftIndex <= RightIndex
				MidIndex = (RightIndex + LeftIndex) \ 2
				ItemPtr = Item(MidIndex)
				If ItemPtr = 0 Then Return -1
				cmpResult = StringsCompare(ItemPtr->Key, iKey, bMatchCase, SortKeysDirection)
				If cmpResult < 0 Then
					LeftIndex = MidIndex + 1
				ElseIf cmpResult > 0 Then
					RightIndex = MidIndex - 1
				Else
					FoundIndex = MidIndex     ' 记录当前找到的位置
					RightIndex = MidIndex - 1 ' 继续向左收缩，寻找更早出现（首次）的索引
				End If
			Wend
			Return FoundIndex
		Else
			For j As Integer = 0 To FCount - 1
				ItemPtr = Item(j)
				If ItemPtr = 0 Then Return -1
				If StringsCompare(ItemPtr->Key, iKey, bMatchCase, SortKeysDirection) = 0 Then Return j
			Next j
			Return -1
		End If
	End Function
#endif

#ifndef Dictionary_IndexOfObject_Off
	Private Function Dictionary.IndexOfObject(iObject As Any Ptr) As Integer
		If iObject = 0 OrElse FCount < 1 Then Return -1
		Dim As DictionaryItem Ptr ItemPtr
		For i As Integer = 0 To FCount - 1
			ItemPtr = Item(i)
			If ItemPtr = 0 Then Return -1
			If ItemPtr->Object = iObject Then Return i
		Next i
		Return -1
	End Function
#endif
Private Operator Dictionary.[](ByRef iKey As WString) ByRef As WString
	Dim As Integer iIndex = IndexOfKey(iKey)
	If iIndex >= 0 Then Return QDictionaryItem(FItems.Items[iIndex]).Text
	Return ""
End Operator

Private Function Dictionary.GetText(ByRef iKey As WString, ByVal bMatchCase As Boolean = False) ByRef As WString
	Dim As Integer iIndex = IndexOfKey(iKey, , bMatchCase)
	If iIndex >= 0 Then Return QDictionaryItem(FItems.Items[iIndex]).Text
	Return ""
End Function

Private Function Dictionary.GetObject(ByRef iKey As WString, ByVal bMatchCase As Boolean = False) As Any Ptr
	Dim As Integer iIndex = IndexOfKey(iKey, , bMatchCase)
	If iIndex >= 0 Then Return QDictionaryItem(FItems.Items[iIndex]).Object
	Return 0
End Function

Private Function Dictionary.GetObject(Index As Integer) As Any Ptr
	If Index >= 0 AndAlso Index <= Count - 1 AndAlso FItems.Items[Index] <> 0 Then Return QDictionaryItem(FItems.Items[Index]).Object Else Return 0
End Function

Private Function Dictionary.GetKey(ByRef wText As WString, ByVal bMatchCase As Boolean = False) ByRef As WString
	Dim As Integer iIndex = IndexOf(wText, bMatchCase)
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
		If FCount < 1 Then Return ""
		WLet(FText, "")
		Dim As Integer Capacity
		For i As Integer = 0 To FCount - 1
			If i <> FCount - 1 Then
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

Private Function Dictionary.Contains(ByRef wText As WString, ByVal bMatchCase As Boolean = False) As Boolean
	Return IndexOf(wText, bMatchCase) <> -1
End Function

Private Function Dictionary.ContainsKey(ByRef Key As WString, iObject As Any Ptr = 0, ByVal bMatchCase As Boolean = False) As Boolean
	Return IndexOfKey(Key, iObject, bMatchCase) <> -1
End Function

Private Function Dictionary.ContainsObject(iObject As Any Ptr) As Boolean
	Return IndexOfObject(iObject) <> -1
End Function

Private Operator Dictionary.Let(ByRef value As WString)
	This.Text = value
End Operator

Private Constructor Dictionary
	FItems.Clear
	SortKeysDirection = 1
	SortedDirection= 1
End Constructor

Private Destructor Dictionary
	This.Clear
	If FText Then _Deallocate(FText)
End Destructor