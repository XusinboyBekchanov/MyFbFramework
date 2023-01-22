'###############################################################################
'#  StatusBar.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor                                                     #
'#  Based on:                                                                  #
'#   TStringList.bi                                                            #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'###############################################################################

#include once "StringList.bi"

'StringListItem
Private Operator StringListItem.Cast As Any Ptr
	Return Object
End Operator

Private Operator StringListItem.Let(V As Any Ptr)
	Object = V
End Operator

Private Operator StringListItem.Let(ByRef V As String)
	Value = V
End Operator

Private Constructor StringListItem
	Value = ""
	Object = 0
End Constructor

Private Destructor StringListItem
	Object = 0
End Destructor

'StringList
Private Operator StringList.Cast As Any Ptr
	Return @This
End Operator

Private Property StringList.Count As Integer
	Return FCount
End Property

Private Property StringList.Count(Value As Integer)
End Property

#ifndef WStringList_MatchCase_Get_Off
	Private Property StringList.MatchCase As Boolean
		Return FMatchCase
	End Property
#endif

#ifndef WStringList_MatchCase_Set_Off
	Private Property StringList.MatchCase(iValue As Boolean)
		FMatchCase = iValue
	End Property
#endif

Private Property StringList.MatchFullWords(iValue As Boolean)
	FMatchFullWords = iValue
End Property

Private Property StringList.MatchFullWords As Boolean
	Return FMatchFullWords
End Property

Private Property StringList.Sorted(iValue As Boolean)
	FSorted = iValue
End Property

Private Property StringList.Sorted As Boolean
	Return FSorted
End Property

Private Property StringList.Text As String
	FText = ""
	For i As Integer = 0 To FCount -1
		If i <> FCount -1 Then
			FText = FText + Item(i) + Chr(13) + Chr(10)
		Else
			FText = FText + Item(i)
		End If
	Next i
	Return FText
End Property

Private Property StringList.Text(Value As String)
	FText = ""
	This.Clear
	For i As Integer = 0 To Len(Value)
		FText = FText + Chr(Value[i])
		If Value[i] = 10 Or Value[i] = 0 Then
			This.Add Trim(Mid(FText, 1, Len(FText) - 1), Any Chr(13))
			FText = ""
		End If
	Next i
End Property

Private Property StringList.Item(Index As Integer) As String
	If Index >= 0 And Index <= FCount - 1 Then
		Return QStringListItem(FItems.Items[Index]).Value
	End If
	Return ""
End Property

Private Property StringList.Item(Index As Integer, FItem As String)
	If Index > -1 And Index < FCount Then
		QStringListItem(FItems.Items[Index]).Value = FItem
	End If
End Property

Private Property StringList.Object(Index As Integer) As Any Ptr
	If Index > -1 And Index < FCount Then Return QStringListItem(FItems.Items[Index]).Object Else Return 0
End Property

Private Property StringList.Object(Index As Integer, FObj As Any Ptr)
	If Index > -1 And Index < FCount Then QStringListItem(FItems.Items[Index]).Object = FObj
End Property

Private Function StringList.Add(FItem As String, FObj As Any Ptr = 0) As Integer
	If CBool(FCount > 0) AndAlso FSorted Then
		Return This.Insert(-1, FItem, FObj)
	Else
		Dim As StringListItem Ptr nItem = New_(StringListItem)
		With *nItem
			.Value  = FItem
			.Object = FObj
		End With
		FItems.Add nItem
		FCount = FItems.Count
		If OnAdd Then OnAdd(This, FItem, FObj)
		Return FCount - 1
	End If
End Function

Private Function StringList.Insert(Index As Integer, FItem As String, FObj As Any Ptr = 0) As Integer
	Dim As Integer j
	If (CBool(Index = -1) OrElse FSorted) AndAlso CBool(FCount > 0) Then ' Sorted Insert
		Dim As Integer iStart = 0
		Dim As Integer LeftIndex = iStart, RightIndex = FCount - 1,  MidIndex = (FCount - 1 + iStart) \ 2
		j = FCount
		If FMatchCase Then  ' Action with the same sorting mode only
			While (LeftIndex <= RightIndex And LeftIndex < FCount And RightIndex >= 0 )
				MidIndex = (RightIndex + LeftIndex) \ 2
				If Item(MidIndex) > FItem AndAlso (MidIndex = 0 OrElse Item(MidIndex - 1) <= FItem) Then
					j = MidIndex: Exit While
				ElseIf Item(MidIndex) <= FItem Then
					LeftIndex = MidIndex + 1
				Else
					RightIndex = MidIndex - 1
				End If
			Wend
		Else
			While (LeftIndex <= RightIndex And LeftIndex < FCount And RightIndex >= 0 )
				MidIndex = (RightIndex + LeftIndex) \ 2
				If LCase(Item(MidIndex)) > LCase(FItem) AndAlso (MidIndex = 0 OrElse LCase(Item(MidIndex - 1)) <= LCase(FItem)) Then
					j = MidIndex: Exit While
				ElseIf LCase(Item(MidIndex)) <= LCase(FItem) Then
					LeftIndex = MidIndex + 1
				Else
					RightIndex = MidIndex - 1
				End If
			Wend
		End If
		FSorted = True
	Else
		j = IIf(Index > 0, Index, FCount)
		FSorted = False
	End If
	Dim As StringListItem Ptr nItem = New_(StringListItem)
	With *nItem
		.Value  = FItem
		.Object = FObj
	End With
	FItems.Insert j, nItem
	FCount = FItems.Count
	Return j
	If OnInsert Then OnInsert(This, Index, FItem, FObj)
End Function

Private Sub StringList.Exchange(Index1 As Integer, Index2 As Integer)
	FItems.Exchange Index1, Index2
	If OnExchange Then OnExchange(This, Index1, Index2)
End Sub

Private Sub StringList.Remove(Index As Integer)
	If FCount < 1 OrElse Index < 0 OrElse Index > FCount - 1 Then Exit Sub
	Delete_(Cast(StringListItem Ptr, FItems.Items[Index]))
	FItems.Remove Index
	FCount -= 1 ' FItems.Count
	If OnRemove Then OnRemove(This, Index)
End Sub

Private Sub StringList.Sort(iLeft As Integer = 0, iRight As Integer = 0)
	If FCount <= 1 Then Return
		If iRight = 0 Then iRight = FCount - 1
		If iLeft < 0 Then iLeft = 0
		If (iRight <> 0 AndAlso (iLeft >= iRight)) Then Return
		Dim As Integer i = iLeft, j = iRight
		'QuickSort
		Dim As String iKey = Item(i)
		If MatchCase Then
			While (i < FCount And j >= 0 And i <= j)
				While (iKey < Item(j) AndAlso i < j)
					j -= 1
				Wend
				If i <= j Then Exchange i, j: i += 1
				While (iKey >= Item(i) AndAlso i < j)
					i += 1
				Wend
				If i <= j Then Exchange i, j:  j -= 1
			Wend
		Else
			While (i < FCount And j >= 0 And i <= j)
				While (LCase(iKey) < LCase(Item(j)) AndAlso i < j)
					j -= 1
				Wend
				If i <= j Then Exchange i, j: i += 1
				While (LCase(iKey) >= LCase(Item(i)) AndAlso i < j)
					i += 1
				Wend
				If i <= j Then Exchange i, j: j -= 1
			Wend
		End If
		If j > iLeft Then This.Sort(iLeft, j)
		If i < iRight Then This.Sort(i, iRight)
		FSorted = True
		If OnChange Then OnChange(This)
End Sub

Private Sub StringList.Clear
	For i As Integer = FCount - 1 To 0 Step -1
		If FItems.Items[i] <> 0 Then Delete_(Cast(StringListItem Ptr, FItems.Items[i]))
	Next
	FItems.Clear
	FCount = 0
	If OnClear Then OnClear(This)
End Sub

Private Sub StringList.SaveToFile(ByRef File As WString)
	Dim As Integer Fn
	Fn = FreeFile_
	If Open(File For Output As #Fn) = 0 Then
		For i As Integer = 0 To FCount -1
			Print #Fn, Item(i)
		Next
	End If
	CloseFile_(Fn)
End Sub

Private Sub StringList.LoadFromFile(ByRef File As WString)
	Dim As Integer Fn = FreeFile_, Result = -1
	Dim Buff As String
	Result = Open(File For Input As #Fn)
	If Result = 0 Then
		This.Clear
		While Not EOF(Fn)
			Line Input #Fn, Buff
			Add Trim(Buff)
		Wend
	End If
	CloseFile_(Fn)
End Sub

Private Function StringList.IndexOf(FItem As String, ByVal bMatchCase As Boolean = False, ByVal bMatchFullWords As Boolean = True, ByVal iStart As Integer = 0, ByRef ListItem As StringListItem Ptr = 0) As Integer
	If FCount < 1 Then Return -1
	If iStart < 0 Then iStart = 0
	If FSorted AndAlso FCount > 1 Then  'Fast Binary Search
		Dim As Integer LeftIndex = iStart, RightIndex = FCount - 1,  MidIndex = (FCount - 1 + iStart) \ 2
		If FMatchCase Then  ' Action with the same sorting mode only
			While (LeftIndex <= RightIndex And LeftIndex < FCount And RightIndex >= 0)
				MidIndex = (RightIndex + LeftIndex) \ 2
				ListItem = FItems.Item(MidIndex)
				If ListItem->Value = FItem AndAlso (MidIndex = 0 OrElse Item(MidIndex - 1) <> FItem) Then
					Return MidIndex
				ElseIf ListItem->Value < FItem Then
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
				If LCase(ListItem->Value) = LCase(FItem) AndAlso (MidIndex = 0 OrElse LCase(Item(MidIndex - 1)) <> LCase(FItem)) Then
					Return MidIndex
				ElseIf LCase(ListItem->Value) < LCase(FItem) Then
					LeftIndex = MidIndex + 1
				Else
					RightIndex = MidIndex - 1
				End If
			Wend
			Return IIf(MatchFullWords, -1, LeftIndex)
		End If
	Else
		If bMatchCase Then
			For j As Integer = 0 To FCount - 1
				ListItem = FItems.Item(j)
				If ListItem->Value = FItem Then Return j
			Next
		Else
			For j As Integer = 0 To FCount - 1
				ListItem = FItems.Item(j)
				If LCase(ListItem->Value) = LCase(FItem) Then Return j
			Next
		End If
		Return -1
	End If
End Function

Private Function StringList.IndexOfObject(FObj As Any Ptr) As Integer
	If FObj = 0 OrElse FCount < 1 Then Return -1
	For j As Integer = 0 To FCount - 1
		If QStringListItem(FItems.Item(j)).Object = FObj Then Return j
	Next
	Return -1
End Function

Private Function StringList.Contains(FItem As String, ByVal bMatchCase As Boolean = False, ByVal bMatchFullWords As Boolean = True, ByVal iStart As Integer = 0, ByRef Idx As Integer = -1, ByRef ListItem As StringListItem Ptr = 0) As Boolean
	Idx = IndexOf(FItem, bMatchCase, True, iStart, ListItem)
	Return Idx <> -1
End Function

Private Function StringList.ContainsObject(FObj As Any Ptr) As Boolean
	Return IndexOfObject(FObj) <> -1
End Function

Private Function StringList.CountOf(ByRef FItem As String) As Integer
	Dim _Count As Integer
	For i As Integer = 0 To FCount - 1
		If LCase(Item(i)) = LCase(FItem) Then _Count += 1
	Next i
	Return _Count
End Function

Private Operator StringList.Let(ByRef Value As String)
	This.Text = Value
End Operator

Private Constructor StringList
	This.Clear
	FCount = 0
	FMatchFullWords = True
End Constructor

Private Destructor StringList
	This.Clear
	FCount = 0
End Destructor
