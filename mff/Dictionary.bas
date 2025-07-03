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
		Cast(DictionaryItem Ptr, FItems.Items[Index])->Text = wText
		Cast(DictionaryItem Ptr, FItems.Items[Index])->Object = iObject
	End If
	If OnChange Then OnChange(This)
End Sub

Private Function Dictionary.Get(ByRef iKey As WString, ByRef DefaultText As WString = "") ByRef As WString
	Dim As Integer Index = IndexOfKey(iKey)
	If Index >= 0 And Index <= Count - 1 Then
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
	Private Sub Dictionary.Sort(MatchCase As Boolean = False, ileft As Integer = 0, iRight As Integer = 0)
		If FItems.Count <= 1 Then Return
		'Dim As Boolean flag
		Sorted = True
		SortKeysed  = False
		FSortMatchCase = MatchCase
		
		If iRight = 0 Then iRight = FItems.Count - 1
		If ileft < 0 Then ileft = 0
		If (iRight <> 0 AndAlso (ileft >= iRight)) Then Return
		Dim As Integer i = ileft, j = iRight
		
		'QuickSort
		Dim As DictionaryItem Ptr iKey = Item(i)
		If MatchCase Then
			While (i <= j) '/*控制在当组内寻找一遍
				While (iKey->Text < Item(j)->Text AndAlso i < j)
					j -= 1
				Wend
				If i <= j Then Exchange i, j: i += 1
				While (iKey->Text >= Item(i)->Text AndAlso i < j)
					i += 1
				Wend
				If i <= j Then Exchange i, j:  j -= 1
			Wend
		Else
			While (i <= j) '/*控制在当组内寻找一遍
				While (LCase(iKey->Text) < LCase(Item(j)->Text) AndAlso i < j)
					j -= 1
				Wend
				If i <= j Then Exchange i, j: i += 1
				While (LCase(iKey->Text) >= LCase(Item(i)->Text) AndAlso i < j)
					i += 1
				Wend
				If i <= j Then Exchange i, j:  j -= 1
			Wend
		End If
		If j  > ileft Then This.Sort(MatchCase, ileft, j) '*最后用同样的方式对分出来的左边的小组进行同上的做法*/
		If i  < iRight Then This.Sort(MatchCase, i, iRight) ';/*用同样的方式对分出来的右边的小组进行同上的做法, 当然最后可能会出现很多分左右，直到每一组的i = j
		
		'	'bubbleSort , Add flag for fast quit if it is sorted already
		'	Dim As Boolean flag
		'	For i = 0 To FCount - 1
		'		flag = False
		'		For j = 0 To FCount - i - 2
		'			If MatchCase Then
		'				If Item(j)->Text > Item(j+1)->Text Then Exchange j , j + 1 : flag = True
		'			Else
		'				If (LCase(Item(j)->Text) > LCase(Item(j+1)->Text)) Then Exchange j, j + 1 : flag = True
		'			End If
		'		Next
		'		If flag = False Then Return
		'	Next
		
		If OnChange Then OnChange(This)
	End Sub
#endif

#ifndef Dictionary_SortKeys_Off
	Private Sub Dictionary.SortKeys(MatchCase As Boolean = False, ileft As Integer = 0, iRight As Integer = 0)
		If FItems.Count <= 1 Then Return
		'Dim As Boolean flag
		FSortKeysMatchCase = MatchCase
		SortKeysed = True
		Sorted = False
		If iRight = 0 Then iRight = FItems.Count - 1
		If ileft < 0 Then ileft = 0
		If (iRight <> 0 AndAlso (ileft >= iRight)) Then Return
		Dim As Integer i = ileft, j = iRight
		
		'QuickSort
		Dim As DictionaryItem Ptr iKey = Item(i)
		If MatchCase Then
			While (i <= j) '/*控制在当组内寻找一遍
				While (iKey->Key < Item(j)->Key AndAlso i < j)
					j -= 1
				Wend
				If i <= j Then Exchange i, j: i += 1
				While (iKey->Key >= Item(i)->Key AndAlso i < j)
					i += 1
				Wend
				If i <= j Then Exchange i, j:  j -= 1
			Wend
		Else
			While (i <= j) '/*控制在当组内寻找一遍
				While (LCase(iKey->Key) < LCase(Item(j)->Key) AndAlso i < j)
					j -= 1
				Wend
				If i <= j Then Exchange i, j: i += 1
				While (LCase(iKey->Key) >= LCase(Item(i)->Key) AndAlso i < j)
					i += 1
				Wend
				If i <= j Then Exchange i, j:  j -= 1
			Wend
		End If
		If j > ileft Then This.SortKeys(MatchCase, ileft, j) '*最后用同样的方式对分出来的左边的小组进行同上的做法*/
		If i < iRight Then This.SortKeys(MatchCase, i, iRight) ';/*用同样的方式对分出来的右边的小组进行同上的做法, 当然最后可能会出现很多分左右，直到每一组的i = j
		
		'	'bubbleSort , Add flag for fast quit if it is sorted already
		'	Dim As Boolean flag
		'	For i = 0 To FCount - 1
		'		flag = False
		'		For j = 0 To FCount - i - 2
		'			If MatchCase Then
		'				If Item(j)->Key > Item(j+1)->Key Then Exchange j , j + 1 : flag = True
		'			Else
		'				If (LCase(Item(j)->Key) > LCase(Item(j+1)->Key)) Then Exchange j, j + 1 : flag = True
		'			End If
		'		Next
		'		If flag = False Then Return
		'	Next
		
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
			Print #Fn, Item(i)->Key & Chr(9) & Item(i)->Text 'David Change
		Next
	End If
	CloseFile_(Fn)
End Sub

Private Sub Dictionary.LoadFromFile(ByRef Filename As WString)
	Dim As Integer Fn = FreeFile_, Result = -1, Pos1 = -1, FileSize
	Dim As Boolean IsTextStr
	Dim As WString Ptr pBuff
	Result = Open(Filename For Input Encoding "utf-8" As #Fn)
	If Result = 0 Then
		This.Clear
		FileSize = LOF(Fn) + 1
		WLet(pBuff, WInput(FileSize, #Fn))
	End If
	CloseFile_(Fn)
	If pBuff > 0 AndAlso Trim(*pBuff, "") <> "" Then
		Dim As WString Ptr res(Any)
		Split(*pBuff, Chr(9), res())
		If UBound(res) < 1 Then Exit Sub
		Dim As DictionaryItem Ptr nItem = _New(DictionaryItem)
		For j As Integer = 0 To UBound(res) - 1 Step 2
			With *nItem
				.Key  = *res(j)
				.Text = *res(j + 1)
			End With
			FItems.Add nItem
			Deallocate res(j)
			Deallocate res(j + 1)
		Next
		Erase res
	End If
	WDeAllocate(pBuff)
	If OnChange Then OnChange(This)
End Sub

#ifndef Dictionary_IndexOf_Off
	Private Function Dictionary.IndexOf(ByRef wText As Const WString, ByVal MatchCase As Boolean = False, ByVal MatchFullWords As Boolean = True, ByVal iStart As Integer = 0) As Integer
		If Trim(wText) = "" OrElse FItems.Count < 1 Then Return -1
		If Sorted AndAlso MatchFullWords = False Then  'Fast Binary Search
			Dim As Integer LeftIndex = iStart , RightIndex = FItems.Count - 1,  MidIndex = (FItems.Count - 1 + iStart) \ 2
			If FSortMatchCase Then  ' Action with the same sorting mode only
				While (LeftIndex <= RightIndex And LeftIndex < FItems.Count And RightIndex >= 0)
					MidIndex = (RightIndex + LeftIndex) Shr 1
					If QDictionaryItem(FItems.Items[MidIndex]).Text = wText Then
						Return MidIndex
					ElseIf QDictionaryItem(FItems.Items[MidIndex]).Text < wText Then
						LeftIndex = MidIndex + 1
					Else
						RightIndex = MidIndex - 1
					End If
				Wend
				Return -1
			Else
				While (LeftIndex <= RightIndex And LeftIndex < FItems.Count And RightIndex >= 0)
					MidIndex = (RightIndex + LeftIndex) Shr 1
					If LCase(QDictionaryItem(FItems.Items[MidIndex]).Text) = LCase(wText) Then
						Return MidIndex
					ElseIf LCase(QDictionaryItem(FItems.Items[MidIndex]).Text) < LCase(wText) Then
						LeftIndex = MidIndex + 1
					Else
						RightIndex = MidIndex - 1
					End If
				Wend
				Return -1
			End If
		Else
			If MatchFullWords Then
				If MatchCase Then
					For i As Integer = iStart To FItems.Count - 1
						If QDictionaryItem(FItems.Items[i]).Text = wText Then Return i
					Next
				Else
					For i As Integer = iStart To FItems.Count - 1
						If LCase(QDictionaryItem(FItems.Items[i]).Text) = LCase(wText) Then Return i
					Next
				End If
			Else
				If MatchCase Then
					For i As Integer = iStart To FItems.Count - 1
						If InStr(QDictionaryItem(FItems.Items[i]).Text, wText) Then Return i
					Next
				Else
					For i As Integer = iStart To FItems.Count - 1
						If InStr(LCase(QDictionaryItem(FItems.Items[i]).Text), LCase(wText)) Then Return i
					Next
				End If
			End If
		End If
		Return -1
	End Function
#endif

#ifndef Dictionary_IndexOfKey_Off
	Private Function Dictionary.IndexOfKey(ByRef iKey As Const WString, iObject As Any Ptr = 0, ByVal MatchCase As Boolean = False) As Integer
		If Trim(iKey) = "" OrElse FItems.Count < 1 Then Return -1
		If SortKeysed Then  'Fast Binary Search
			Dim As Integer LeftIndex = 0, RightIndex = FItems.Count - 1,  MidIndex = (FItems.Count - 1) Shr 1
			If FSortKeysMatchCase Then  ' Action with the same sorting mode only
				While (LeftIndex <= RightIndex)
					MidIndex = (RightIndex + LeftIndex) Shr 1
					If QDictionaryItem(FItems.Items[MidIndex]).Key = iKey AndAlso (iObject = 0 OrElse QDictionaryItem(FItems.Items[MidIndex]).Object = iObject) Then
						Return MidIndex
					ElseIf QDictionaryItem(FItems.Items[MidIndex]).Key < iKey Then
						LeftIndex = MidIndex + 1
					Else
						RightIndex = MidIndex - 1
					End If
				Wend
				Return -1
			Else
				While (LeftIndex <= RightIndex)
					MidIndex = (RightIndex + LeftIndex) Shr 1
					If LCase(QDictionaryItem(FItems.Items[MidIndex]).Key) = LCase(iKey) AndAlso (iObject = 0 OrElse QDictionaryItem(FItems.Items[MidIndex]).Object = iObject) Then
						Return MidIndex
					ElseIf LCase(QDictionaryItem(FItems.Items[MidIndex]).Key) < LCase(iKey) Then
						LeftIndex = MidIndex + 1
					Else
						RightIndex = MidIndex - 1
					End If
				Wend
				Return -1
			End If
		Else
			If MatchCase Then
				For i As Integer = 0 To FItems.Count - 1
					If QDictionaryItem(FItems.Items[i]).Key = iKey AndAlso (iObject = 0 OrElse QDictionaryItem(FItems.Items[i]).Object = iObject) Then
						Return i
					End If
				Next i
			Else
				For i As Integer = 0 To FItems.Count - 1
					If LCase(QDictionaryItem(FItems.Items[i]).Key) = LCase(iKey) AndAlso (iObject = 0 OrElse QDictionaryItem(FItems.Items[i]).Object = iObject) Then
						Return i
					End If
				Next i
			End If
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
	If iIndex >= 0 Then
		Return QDictionaryItem(FItems.Items[iIndex]).Text
	Else
		Return ""
	End If
End Operator

Private Function Dictionary.GetText(ByRef iKey As WString, ByVal MatchCase As Boolean = False) ByRef As WString
	Dim As Integer iIndex = IndexOfKey(iKey, , MatchCase)
	If iIndex >= 0 Then
		Return QDictionaryItem(FItems.Items[iIndex]).Text
	Else
		Return ""
	End If
End Function

Private Function Dictionary.GetObject(ByRef iKey As WString, ByVal MatchCase As Boolean = False) As Any Ptr
	Dim As Integer iIndex = IndexOfKey(iKey, , MatchCase)
	If iIndex >= 0 Then
		Return QDictionaryItem(FItems.Items[iIndex]).Object
	Else
		Return 0
	End If
End Function

Private Function Dictionary.GetObject(Index As Integer) As Any Ptr
	If Index >= 0 AndAlso Index <= Count - 1 Then Return QDictionaryItem(FItems.Items[Index]).Object Else Return 0
End Function

Private Function Dictionary.GetKey(ByRef wText As WString, ByVal MatchCase As Boolean = False) ByRef As WString
	Dim As Integer iIndex = IndexOf(wText, MatchCase)
	If iIndex >= 0 Then
		Return QDictionaryItem(FItems.Items[iIndex]).Key
	Else
		Return ""
	End If
End Function

Private Function Dictionary.GetKey(iObject As Any Ptr) ByRef As WString
	Dim As Integer iIndex = IndexOfObject(iObject)
	If iIndex >= 0 Then
		Return QDictionaryItem(FItems.Items[iIndex]).Key
	Else
		Return ""
	End If
End Function

#ifndef Dictionary_Text_Get_Off
	Private Property Dictionary.Text ByRef As WString
		If FItems.Count < 1 Then Return ""
		WLet(FText, "")
		For i As Integer = 0 To FItems.Count - 1
			If i <> FItems.Count - 1 Then
				WLet(FText, *FText & Item(i)->Key & Chr(9) & " " & Item(i)->Text & Chr(13) & Chr(10))
			Else
				WLet(FText, *FText & Item(i)->Key & Chr(9) & " " & Item(i)->Text)
			End If
		Next i
		If FText > 0 Then Return *FText Else Return ""
	End Property
#endif

#ifndef Dictionary_Text_Set_Off
	Private Property Dictionary.Text(ByRef value As WString)
		WLet(FText, "")
		This.Clear
		Dim As Integer Pos1
		For i As Integer = 0 To Len(value)
			If value[i] = 10 Or value[i] = 0 Then
				WLet(FText, Trim(Mid(*FText, 1, Len(*FText)), Any WChr(13) & WChr(10)))
				Pos1 = InStr(*FText, WChr(9) & " ")
				Dim As DictionaryItem Ptr nItem = _New(DictionaryItem)
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
			Else
				WAdd FText, WChr(value[i])
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
