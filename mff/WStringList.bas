'###############################################################################
'#  WStringList.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                      #
'#  Based on:                                                                  #
'#   TStringList.bi                                                            #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Adapted to WString by Xusinboy Bekchanov(2018-2019)  Liu XiaLin            #
'###############################################################################

#include once "WStringList.bi"

Private Operator WStringList.Cast As Any Ptr
	Return @This
End Operator

Private Property WStringList.Count As Integer
	Return FCount
End Property

Private Property WStringList.MatchCase(iValue As Boolean)
	FMatchCase = iValue
End Property

Private Property WStringList.MatchCase As Boolean
	Return FMatchCase
End Property

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

Private Property WStringList.Count(iValue As Integer)
End Property

Private Property WStringList.Text ByRef As WString
	WLet(FText, "")
	For i As Integer = 0 To FCount -1
		If i <> FCount -1 Then
			WAdd FText, *Cast(WString Ptr, Items.Item(i)) + Chr(13) + Chr(10)
		Else
			WAdd FText, *Cast(WString Ptr, Items.Item(i)) 
		End If
	Next i
	Return *FText
End Property

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

Private Property WStringList.Item(Index As Integer) ByRef As WString
	If (Index > -1 And Index < FCount) AndAlso Items.Item(Index) > 0 Then Return *Cast(WString Ptr, Items.Item(Index)) Else Return ""
End Property

Private Property WStringList.Item(Index As Integer, iValue As Const WString)
	If Index > -1 And Index < FCount Then
		Dim As WString Ptr iText = CAllocate((Len(iValue) + 1) * SizeOf(WString))
		*iText = iValue
		Items.Item(Index) = iText
	End If
End Property

Private Property WStringList.Object(Index As Integer) As Any Ptr
	If Index > -1 And Index < FCount Then Return Objects.Item(Index) Else Return 0
End Property

Private Property WStringList.Object(Index As Integer, FObj As Any Ptr)
	If Index > -1 And Index < FCount Then Objects.Item(Index) = FObj
End Property

Private Function WStringList.Add(ByRef iValue As Const WString, FObj As Any Ptr = 0) As Integer
	'If iValue = "" Then Return -1 'We should allow add a empty records. Will gpt trouble in TreeListview if not allowed.
	If CBool(FCount > 0) AndAlso FSorted Then
		Return This.Insert(-1, iValue, FObj)
	Else
		Dim As WString Ptr iText = CAllocate((Len(iValue) + 1) * SizeOf(WString))
		*Itext = iValue
		Items.Add iText
		Objects.Add FObj
		FCount = Items.Count
		Return Fcount - 1
	End If
	If OnAdd Then OnAdd(This, iValue, FObj)
End Function

Private Function WStringList.Insert(ByVal Index As Integer, ByRef iValue As Const WString, FObj As Any Ptr = 0) As Integer
	Dim As Integer j
	If (CBool(Index = -1) OrElse FSorted) AndAlso CBool(FCount > 0) Then ' Sorted Insert
		Dim As Integer iStart = 0
		Dim As Integer LeftIndex = iStart, RightIndex = FCount - 1,  MidIndex = (FCount - 1 + iStart) \ 2
		j = FCount
		If FMatchCase Then  ' Action with the same sorting mode only
			While (LeftIndex <= RightIndex And LeftIndex < FCount And RightIndex >= 0 )
				MidIndex = (RightIndex + LeftIndex) \ 2
				If *Cast(WString Ptr, Items.Item(MidIndex)) > iValue AndAlso (MidIndex = 0 OrElse *Cast(WString Ptr, Items.Item(MidIndex - 1)) <= iValue) Then
					j = MidIndex: Exit While
				ElseIf *Cast(WString Ptr, Items.Item(MidIndex)) <= iValue Then
					LeftIndex = MidIndex + 1
				Else
					RightIndex = MidIndex - 1
				End If
			Wend
		Else
			While (LeftIndex <= RightIndex And LeftIndex < FCount And RightIndex >= 0 )
				MidIndex = (RightIndex + LeftIndex) \ 2
				If LCase(*Cast(WString Ptr, Items.Item(MidIndex))) > LCase(iValue) AndAlso (MidIndex = 0 OrElse LCase(*Cast(WString Ptr, Items.Item(MidIndex - 1))) <= LCase(iValue)) Then
					j = MidIndex: Exit While
				ElseIf LCase(*Cast(WString Ptr, Items.Item(MidIndex))) <= LCase(iValue) Then
					LeftIndex = MidIndex + 1
				Else
					RightIndex = MidIndex - 1
				End If
			Wend
		End If
		FSorted = True
	Else
		j = IIf(Index > 0, Index, Fcount)
		FSorted = False
	End If
	'?j, FCount, *Cast(WString Ptr, Items.Item(j - 1)), iValue, *Cast(WString Ptr, Items.Item(j))
	Dim As WString Ptr iText = CAllocate((Len(iValue) + 1) * SizeOf(WString))
	*iText = iValue
	Items.Insert j, iText
	Objects.Insert j, FObj
	FCount = Items.Count
	Return j
	If OnInsert Then OnInsert(This, Index, iValue, FObj)
End Function

Private Sub WStringList.Exchange(Index1 As Integer, Index2 As Integer)
	Items.Exchange Index1, Index2
	Objects.Exchange Index1, Index2
	If OnExchange Then OnExchange(This, Index1, Index2)
End Sub

Private Sub WStringList.Remove(Index As Integer)
	If FCount < 1 OrElse Index < 0 OrElse Index > FCount - 1 Then Exit Sub
	If Items.Item(Index) > 0 Then Deallocate Items.Item(Index)
	Items.Remove Index
	'If Objects.Item(Index) > 0 Then Delete Objects.Item(Index)
	Objects.Remove Index
	FCount = Items.Count
	If OnRemove Then OnRemove(This, Index)
End Sub

Private Sub WStringList.Sort(iLeft As Integer = 0, iRight As Integer = 0)
	If FCount <= 1 Then Return
	If iRight = 0 Then iRight = FCount - 1
	If iLeft < 0 Then iLeft = 0
	If (iRight <> 0 AndAlso (iLeft >= iRight)) Then Return
	Dim As Integer i = ileft, j = iRight
	'QuickSort
	Dim As WString Ptr iKey = Cast (WString Ptr, Items.Item(i))
	If MatchCase Then
		While (i < FCount And j >= 0 And i <= j) '/*控制在当组内寻找一遍
			While (*iKey < *Cast(WString Ptr, Items.Item(j)) AndAlso i < j)
				j -= 1
			Wend
			If i <= j Then Exchange i, j: i += 1
			While (*iKey >= *Cast(WString Ptr, Items.Item(i)) AndAlso i < j)
				i += 1
			Wend
			If i <= j Then Exchange i, j:  j -= 1
		Wend
	Else
		While (i < FCount And j >= 0 And i <= j) '/*控制在当组内寻找一遍
			While (LCase(*iKey) < LCase(*Cast(WString Ptr, Items.Item(j))) AndAlso i < j)
				j -= 1
			Wend
			If i <= j Then Exchange i, j: i += 1
			While (LCase(*iKey) >= LCase(*Cast (WString Ptr, Items.Item(i))) AndAlso i < j)
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

Private Sub WStringList.Clear
	If FCount < 1 Then Exit Sub
	For i As Integer = FCount - 1 To 0
		If Items.Item(i) > 0 Then Deallocate Items.Item(i)
		'If Objects.Item(i) > 0 Then Delete Objects.Item(i)
		Objects.Remove i
		Items.Remove i
	Next
	Items.Clear
	Objects.Clear
	FCount = 0
	If OnClear Then OnClear(This)
End Sub

Private Sub WStringList.SaveToFile(ByRef FileName As WString)
	Dim As Integer Fn
	Fn = FreeFile()
	If Open(FileName For Output Encoding "utf-8" As #Fn) = 0 Then 'David Change
		For i As Integer = 0 To FCount -1
			Print #Fn, *Cast(WString Ptr, Items.Item(i))
			'Print #Fn, Item(i)
		Next
		Close #Fn
	End If
End Sub

Private Sub WStringList.LoadFromFile(ByRef FileName As WString)
	'Items.LoadFromFile File
	Dim As Integer Fn = FreeFile, Result = -1
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
	Close #Fn
End Sub

Private Function WStringList.IndexOf(ByRef iValue As Const WString, ByVal bMatchCase As Boolean = False, ByVal bMatchFullWords As Boolean = True, ByVal iStart As Integer = 0) As Integer
	'If iValue = "" OrElse FCount < 1 Then Return -1 'We should allow add a empty records. Will get trouble in TreeListview if not allowed.
	If FCount < 1 Then Return -1
	If iStart < 0 Then iStart = 0
	If FSorted AndAlso FCount > 1 Then  'Fast Binary Search
		Dim As Integer LeftIndex = iStart, RightIndex = FCount - 1,  MidIndex = (FCount - 1 + iStart) \ 2
		If FMatchCase Then  ' Action with the same sorting mode only
			While (LeftIndex <= RightIndex And LeftIndex < FCount And RightIndex >= 0 )
				MidIndex = (RightIndex + LeftIndex) \ 2
				If *Cast(WString Ptr, Items.Item(MidIndex)) = iValue AndAlso (MidIndex = 0 OrElse *Cast(WString Ptr, Items.Item(MidIndex - 1)) <> iValue) Then
					Return MidIndex
				ElseIf *Cast(WString Ptr, Items.Item(MidIndex)) < iValue Then
					LeftIndex = MidIndex + 1
				Else
					RightIndex = MidIndex - 1
				End If
			Wend
			Return IIf(bMatchFullWords, -1, LeftIndex)
		Else
			While (LeftIndex <= RightIndex And LeftIndex < FCount And RightIndex >= 0 )
				MidIndex = (RightIndex + LeftIndex) \ 2
				If LCase(*Cast(WString Ptr, Items.Item(MidIndex))) = LCase(iValue) AndAlso (MidIndex = 0 OrElse LCase(*Cast(WString Ptr, Items.Item(MidIndex - 1))) <> LCase(iValue)) Then
					Return MidIndex
				ElseIf LCase(*Cast(WString Ptr, Items.Item(MidIndex))) < LCase(iValue) Then
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
				If *Cast(WString Ptr, Items.Item(j)) = iValue Then Return j
			Next
		Else
			For j As Integer = 0 To FCount - 1
				If LCase(*Cast(WString Ptr, Items.Item(j))) = LCase(iValue) Then Return j
			Next
		End If
		Return -1
	End If
End Function

Private Function WStringList.Contains(ByRef iValue As Const WString, ByVal bMatchCase As Boolean = False, ByVal bMatchFullWords As Boolean = True, ByVal iStart As Integer = 0) As Boolean
	Return IndexOf(iValue, MatchCase, True, iStart) <> -1
End Function

Private Function WStringList.IndexOfObject(FObj As Any Ptr) As Integer
	If FObj = 0 OrElse FCount < 1 Then Return -1
	For j As Integer = 0 To FCount - 1
		If Objects.Item(j) = FObj Then Return j
	Next
	Return -1
End Function

Private Function WStringList.ContainsObject(FObj As Any Ptr) As Boolean
	Return IndexOfObject(FObj) <> -1
End Function

Private Function WStringList.CountOf(ByRef FItem As WString) As Integer
	Dim _Count As Integer
	For i As Integer = 0 To FCount - 1
		If LCase(*Cast(WString Ptr, Items.Item(i))) = LCase(FItem) Then _Count += 1
	Next i
	Return _Count
End Function

Private Operator WStringList.Let(ByRef Value As WString)
	This.Text = Value
End Operator

Private Constructor WStringList
	Items.Clear
	Objects.Clear
	FCount = 0
	FMatchFullWords = True
	'FSorted = True
End Constructor

Private Destructor WStringList
	Items.Clear
	Objects.Clear
	FCount = 0
	This.Clear
End Destructor

