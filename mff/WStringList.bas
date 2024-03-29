﻿'###############################################################################
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
	Return WGet(FValue)
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
	Value = ""
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
	For i As Integer = 0 To FCount -1
		If i <> FCount -1 Then
			'WAdd FText, *Cast(WString Ptr, Items.Item(i)) + Chr(13) + Chr(10)
			WAdd FText, Item(i) + Chr(13) + Chr(10)
		Else
			WAdd FText, Item(i)
		End If
	Next i
	Return *FText
End Property

#ifndef WStringList_Text_Set_Off
	Private Property WStringList.Text(ByRef Value As WString)
		WLet(FText, "")
		This.Clear
		For i As Integer = 0 To Len(Value)
			WAdd FText, WChr(Value[i])
			If Value[i] = 10 Or Value[i] = 0 Then
				This.Add Trim(Mid(*FText, 1, Len(*FText) - 1), Any WChr(13))
				WLet(FText, "")
			End If
		Next i
	End Property
#endif

Private Operator WStringList.[](Index As Integer) ByRef As WString
	If Index >= 0 And Index <= FCount - 1 Then
		Return QWStringListItem(FItems.Items[Index]).Value
	End If
	Return ""
End Operator

Private Property WStringList.Item(Index As Integer) ByRef As WString
	'If (Index > -1 And Index < FCount) AndAlso Items.Item(Index) > 0 Then Return *Cast(WString Ptr, Items.Item(Index)) Else Return ""
	If Index >= 0 And Index <= FCount - 1 Then
		Return QWStringListItem(FItems.Items[Index]).Value
	End If
	Return ""
End Property

Private Property WStringList.Item(Index As Integer, iValue As WString)
	If Index > -1 And Index < FCount Then
		'WDeAllocate(Items.Item(Index))
		'Dim As WString Ptr iText = CAllocate_((Len(iValue) + 1) * SizeOf(WString))
		'*iText = iValue
		'Items.Item(Index) = iText
		QWStringListItem(FItems.Items[Index]).Value = iValue
	End If
End Property

Private Property WStringList.Object(Index As Integer) As Any Ptr
	'If Index > -1 And Index < FCount Then Return Objects.Item(Index) Else Return 0
	If Index > -1 And Index < FCount Then Return QWStringListItem(FItems.Items[Index]).Object Else Return 0
End Property

Private Property WStringList.Object(Index As Integer, FObj As Any Ptr)
	'If Index > -1 And Index < FCount Then Objects.Item(Index) = FObj
	If Index > -1 And Index < FCount Then QWStringListItem(FItems.Items[Index]).Object = FObj
End Property

#ifndef WStringList_Add_Off
	Private Function WStringList.Add(ByRef iValue As WString, FObj As Any Ptr = 0) As Integer
		'If iValue = "" Then Return -1 'We should allow add a empty records. Will gpt trouble in TreeListview if not allowed.
		If CBool(FCount > 0) AndAlso FSorted Then
			Return This.Insert(-1, iValue, FObj)
		Else
			'Dim As WString Ptr iText = CAllocate_((Len(iValue) + 1) * SizeOf(WString))
			'*iText = iValue
			'Items.Add iText
			'Objects.Add FObj
			'FCount = Items.Count
			Dim As WStringListItem Ptr nItem = _New(WStringListItem)
			With *nItem
				.Value  = iValue
				.Object = FObj
			End With
			FItems.Add nItem
			FCount = FItems.Count
			If OnAdd Then OnAdd(This, iValue, FObj)
			Return FCount - 1
		End If
	End Function
#endif

Private Function WStringList.Insert(ByVal Index As Integer, ByRef iValue As WString, FObj As Any Ptr = 0) As Integer
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
	'?j, FCount, *Cast(WString Ptr, Items.Item(j - 1)), iValue, *Cast(WString Ptr, Items.Item(j))
	'Dim As WString Ptr iText = CAllocate_((Len(iValue) + 1) * SizeOf(WString))
	'*iText = iValue
	'Items.Insert j, iText
	'Objects.Insert j, FObj
	'FCount = Items.Count
	Dim As WStringListItem Ptr nItem = _New( WStringListItem)
	With *nItem
		.Value  = iValue
		.Object = FObj
	End With
	FItems.Insert j, nItem
	FCount = FItems.Count
	Return j
	If OnInsert Then OnInsert(This, Index, iValue, FObj)
End Function

Private Sub WStringList.Exchange(Index1 As Integer, Index2 As Integer)
	'Items.Exchange Index1, Index2
	'Objects.Exchange Index1, Index2
	FItems.Exchange Index1, Index2
	If OnExchange Then OnExchange(This, Index1, Index2)
End Sub

Private Sub WStringList.Remove(Index As Integer)
	If FCount < 1 OrElse Index < 0 OrElse Index > FCount - 1 Then Exit Sub
	'If Items.Item(Index) > 0 Then Deallocate_(Items.Item(Index))
	'Items.Remove Index
	''If Objects.Item(Index) > 0 Then Delete Objects.Item(Index)
	'Objects.Remove Index
	'FCount = Items.Count
	_Delete(Cast(WStringListItem Ptr, FItems.Items[Index]))
	FItems.Remove Index
	FCount -= 1 ' FItems.Count
	If OnRemove Then OnRemove(This, Index)
End Sub

#ifndef WStringList_Sort_Off
	Private Sub WStringList.Sort(iLeft As Integer = 0, iRight As Integer = 0)
		If FCount <= 1 Then Return
		If iRight = 0 Then iRight = FCount - 1
		If iLeft < 0 Then iLeft = 0
		If (iRight <> 0 AndAlso (iLeft >= iRight)) Then Return
		Dim As Integer i = iLeft, j = iRight
		'QuickSort
		Dim As WString Ptr iKey = @(Item(i))
		If MatchCase Then
			While (i < FCount And j >= 0 And i <= j) '/*控制在当组内寻找一遍
				While (*iKey < Item(j) AndAlso i < j)
					j -= 1
				Wend
				If i <= j Then Exchange i, j: i += 1
				While (*iKey >= Item(i) AndAlso i < j)
					i += 1
				Wend
				If i <= j Then Exchange i, j:  j -= 1
			Wend
		Else
			While (i < FCount And j >= 0 And i <= j) '/*控制在当组内寻找一遍
				While (LCase(*iKey) < LCase(Item(j)) AndAlso i < j)
					j -= 1
				Wend
				If i <= j Then Exchange i, j: i += 1
				While (LCase(*iKey) >= LCase(Item(i)) AndAlso i < j)
					i += 1
				Wend
				If i <= j Then Exchange i, j: j -= 1
			Wend
		End If
		'Items.Item(i) = iKey  'NOT OK /*当在当组内找完一遍以后就把中间数key回归*/
		'Objects.Item(i) = iObj
		If j > iLeft Then This.Sort(iLeft, j) '*最后用同样的方式对分出来的左边的小组进行同上的做法*/
		If i < iRight Then This.Sort(i, iRight) ';/*用同样的方式对分出来的右边的小组进行同上的做法, 当然最后可能会出现很多分左右，直到每一组的i = j
		
		'	'bubbleSort , Add flag for fast quit if it is sorted already
		'	Dim As Boolean flag
		'	For i = 0 To FCount - 1
		'		flag = False
		'		For j = 0 To FCount - i - 2
		'			If MatchCase Then
		'				If *Cast(WString Ptr, Items.Item(j)) > *Cast(WString Ptr, Items.Item(j + 1)) Then Exchange j , j + 1 : flag = True
		'			Else
		'				If (LCase(*Cast(WString Ptr, Items.Item(j))) > LCase(*Cast(WString Ptr, Items.Item(j + 1)))) Then Exchange j, j + 1 : flag = True
		'			End If
		'		Next
		'		If flag = False Then Return
		'	Next
		
		FSorted = True
		If OnChange Then OnChange(This)
	End Sub
#endif

Private Sub WStringList.Clear
	For i As Integer = FCount - 1 To 0 Step -1
		'WDeAllocate(Items.Item(i))
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
	Dim Buff As WString * 2000 'David Change for V1.07 Line Input not working fine
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
	Private Function WStringList.IndexOf(ByRef iValue As Const WString, ByVal bMatchCase As Boolean = False, ByVal bMatchFullWords As Boolean = True, ByVal iStart As Integer = 0, ByRef ListItem As WStringListItem Ptr = 0) As Integer
		'If iValue = "" OrElse FCount < 1 Then Return -1 'We should allow add a empty records. Will get trouble in TreeListview if not allowed.
		Dim ItemText As WString Ptr
		If FCount < 1 Then Return -1
		If iStart < 0 Then iStart = 0
		If FSorted AndAlso FCount > 1 Then  'Fast Binary Search
			Dim As Integer LeftIndex = iStart, RightIndex = FCount - 1,  MidIndex = (FCount - 1 + iStart) \ 2
			If FMatchCase Then  ' Action with the same sorting mode only
				While (LeftIndex <= RightIndex And LeftIndex < FCount And RightIndex >= 0 )
					MidIndex = (RightIndex + LeftIndex) \ 2
					ListItem = FItems.Item(MidIndex)
					'ItemText = Items.Item(MidIndex)
					ItemText = @(ListItem->Value)
					'If *ItemText = iValue AndAlso (MidIndex = 0 OrElse *Cast(WString Ptr, Items.Item(MidIndex - 1)) <> iValue) Then
					If *ItemText = iValue AndAlso (MidIndex = 0 OrElse Item(MidIndex - 1) <> iValue) Then
						Return MidIndex
					ElseIf *ItemText < iValue Then
						LeftIndex = MidIndex + 1
					Else
						RightIndex = MidIndex - 1
					End If
				Wend
				Return IIf(bMatchFullWords, -1, LeftIndex)
			Else
				While (LeftIndex <= RightIndex And LeftIndex < FCount And RightIndex >= 0 )
					MidIndex = (RightIndex + LeftIndex) \ 2
					ListItem = FItems.Item(MidIndex)
					'ItemText = Items.Item(MidIndex)
					ItemText = @(ListItem->Value)
					'If LCase(*ItemText) = LCase(iValue) AndAlso (MidIndex = 0 OrElse LCase(*Cast(WString Ptr, Items.Item(MidIndex - 1))) <> LCase(iValue)) Then
					If LCase(*ItemText) = LCase(iValue) AndAlso (MidIndex = 0 OrElse LCase(Item(MidIndex - 1)) <> LCase(iValue)) Then
						Return MidIndex
					ElseIf LCase(*ItemText) < LCase(iValue) Then
						LeftIndex = MidIndex + 1
					Else
						RightIndex = MidIndex - 1
					End If
				Wend
				Return IIf(MatchFullWords, -1, LeftIndex)
			End If
		Else
			If MatchCase Then
				For j As Integer = 0 To FCount - 1
					ListItem = FItems.Item(j)
					'ItemText = Items.Item(j)
					ItemText = @(ListItem->Value)
					If *ItemText = iValue Then Return j
				Next
			Else
				For j As Integer = 0 To FCount - 1
					ListItem = FItems.Item(j)
					'ItemText = Items.Item(j)
					ItemText = @(ListItem->Value)
					If LCase(*ItemText) = LCase(iValue) Then Return j
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

#ifndef WStringList_IndexOfObject_Off
	Private Function WStringList.IndexOfObject(FObj As Any Ptr) As Integer
		If FObj = 0 OrElse FCount < 1 Then Return -1
		For j As Integer = 0 To FCount - 1
			'If Objects.Item(j) = FObj Then Return j
			If QWStringListItem(FItems.Item(j)).Object = FObj Then Return j
		Next
		Return -1
	End Function
#endif

Private Function WStringList.ContainsObject(FObj As Any Ptr) As Boolean
	Return IndexOfObject(FObj) <> -1
End Function

Private Function WStringList.CountOf(ByRef FItem As WString) As Integer
	Dim _Count As Integer
	For i As Integer = 0 To FCount - 1
		'If LCase(*Cast(WString Ptr, Items.Item(i))) = LCase(FItem) Then _Count += 1
		If LCase(Item(i)) = LCase(FItem) Then _Count += 1
	Next i
	Return _Count
End Function

Private Operator WStringList.Let(ByRef Value As WString)
	This.Text = Value
End Operator

Private Constructor WStringList
	'Items.Clear
	'Objects.Clear
	This.Clear
	FCount = 0
	FMatchFullWords = True
	'FSorted = True
End Constructor

Private Destructor WStringList
	This.Clear
	FCount = 0
End Destructor

