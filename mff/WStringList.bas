'###############################################################################
'#  WStringList.bi                                                              #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                      #
'#  Based on:                                                                   #
'#   TStringList.bi                                                             #
'#   FreeBasic Windows GUI ToolKit                                              #
'#   Copyright (c) 2007-2008 Nastase Eodor                                      #
'#   Version 1.0.0                                                              #
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
	Return Obj
End Operator

Private Operator WStringListItem.Cast As String
	Return Value
End Operator

Private Operator WStringListItem.Let(V As Any Ptr)
	Obj = V
End Operator

Private Operator WStringListItem.Let(ByRef V As WString)
	WLet(FValue, V)
End Operator

Private Constructor WStringListItem
	Value = ""
	Obj  = 0
End Constructor

Private Destructor WStringListItem
	If FValue Then Deallocate_((FValue))
	Obj  = 0
End Destructor

Private Operator WStringList.Cast As Any Ptr
	Return @This
End Operator

Private Property WStringList.Count As Integer
	Return FItems.Count
End Property

Private Property WStringList.Count(Value As Integer)
End Property

Private Property WStringList.Text ByRef As WString
	WLet(FText, "")
	For i As Integer = 0 To FCount -1
		If i <> FCount -1 Then
			WLet(FText, *FText & Item(i) & Chr(13) & Chr(10))
		Else
			WLet(FText, *FText & Item(i))
		End If
	Next i
	Return *FText
End Property

Private Property WStringList.Text(ByRef Value As WString)
	WLet(FText, "")
	This.Clear
	For i As Integer = 0 To Len(Value)
		WLet(FText, *FText & WChr(Value[i]))
		If Value[i] = 10 Or Value[i] = 0 Then
			This.Add Trim(Mid(*FText, 1, Len(*FText) - 1), Any WChr(13))
			WLet(FText, "")
		End If
	Next i
End Property

Private Property WStringList.Item(Index As Integer) ByRef As WString
	If Index >= 0 And Index <= FCount -1 Then
		Return QWStringListItem(FItems.Items[Index]).Value
	End If
	Return ""
End Property

Private Property WStringList.Item(Index As Integer, ByRef FItem As WString)
	If Index >= 0 And Index <= FCount -1 Then
		QWStringListItem(FItems.Items[Index]).Value = FItem
	End If
End Property

Private Property WStringList.Object(Index As Integer) As Any Ptr
	If Index >= 0 And Index <= FItems.Count -1 Then
		Return QWStringListItem(FItems.Items[Index]).Obj
	End If
	Return 0
End Property

Private Property WStringList.Object(Index As Integer, FObj As Any Ptr)
	If Index >= 0 And Index <= FCount -1 Then
		QWStringListItem(FItems.Items[Index]).Obj = FObj
	End If
End Property

Private Function WStringList.Add(ByRef FItem As WString, FObj As Any Ptr = 0, SortInsert As Boolean = False) As Integer
	Dim As WStringListItem Ptr nItem = New_( WStringListItem)
	Dim As Integer Index
	With *nItem
		.Value  = FItem
		.Obj = FObj
	End With
	If SortInsert Then
		For Index = 0 To FItems.Count - 1
			If Item(Index) > FItem Then Exit For
		Next
		FItems.Insert Index, nItem
		If OnInsert Then OnInsert(This, Index, FItem, FObj)
	Else
		FItems.Add nItem
		Index = FItems.Count - 1
		If OnAdd Then OnAdd(This, FItem, FObj)
	End If
	If OnChange Then OnChange(This)
	FCount = FItems.Count
	Return Index
End Function

Private Sub WStringList.Insert(Index As Integer, ByRef FItem As WString, FObj As Any Ptr = 0)
	Dim As WStringListItem Ptr nItem = New_( WStringListItem)
	With *nItem
		.Value  = FItem
		.Obj = FObj
	End With
	FItems.Insert Index, nItem
	If OnInsert Then OnInsert(This, Index, FItem, FObj)
	If OnChange Then OnChange(This)
	FCount = FItems.Count
End Sub

Private Sub WStringList.Exchange(Index1 As Integer, Index2 As Integer)
	FItems.Exchange(Index1, Index2)
	If OnExchange Then OnExchange(This, Index1, Index2)
	If OnChange Then OnChange(This)
End Sub

Private Sub WStringList.Remove(Index As Integer)
	Delete_( Cast(WStringListItem Ptr, FItems.Items[Index]))
	FItems.Remove Index
	FCount -=1' FItems.Count
	If OnRemove Then OnRemove(This, Index)
	If OnChange Then OnChange(This)
End Sub

Private Sub WStringList.Sort(MatchCase As Boolean = False)
	Dim As Integer i,j
	For i = 1 To FCount -1
		For j = FCount -1 To i Step -1
			If MatchCase Then
				If (Item(j) < Item(j - 1)) Then Exchange j - 1, j
			Else
				If (LCase(Item(j)) < LCase(Item(j - 1))) Then Exchange j - 1, j
			End If
		Next
	Next
End Sub

Private Sub WStringList.Clear
	If FCount < 1 Then Exit Sub
	For i As Integer = FCount - 1 To 0 Step -1
		If FItems.Items[i] <> 0 Then Delete_( Cast(WStringListItem Ptr, FItems.Items[i]))
	Next i
	FItems.Clear
	FCount = 0
	If OnClear Then OnClear(This)
	If OnChange Then OnChange(This)
End Sub

Private Sub WStringList.SaveToFile(ByRef FileName As WString)
	Dim As Integer Fn
	Fn = FreeFile
	'If Open(FileName For Binary Access Write As #Fn) = 0 Then
	Print "FCount ", FCount
	If Open(FileName For Output Encoding "utf-8" As #Fn) Then 'David Change
		For i As Integer = 0 To FCount -1
			Print #Fn, Item(i)'QWStringListItem(FItems.Items[i]).Value
			'Print QWStringListItem(FItems.Items[i]).Value
			Print Item(i)
		Next
	End If
	Close #Fn
End Sub

Private Sub WStringList.LoadFromFile(ByRef FileName As WString)
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

Private Function WStringList.IndexOf(ByRef FItem As WString) As Integer
	For i As Integer = 0 To FCount -1
		If LCase(QWStringListItem(FItems.Items[i]).Value) = LCase(FItem) Then Return i
	Next i
	Return -1
End Function

Private Function WStringList.IndexOfObject(FObj As Any Ptr) As Integer
	For i As Integer = 0 To FCount -1
		If QWStringListItem(FItems.Items[i]).Obj = FObj Then Return i
	Next i
	Return -1
End Function

Private Function WStringList.Contains(ByRef FItem As WString) As Boolean
	Return IndexOf(FItem) <> -1
End Function

Private Function WStringList.ContainsObject(FObj As Any Ptr) As Boolean
	Return IndexOfObject(FObj) <> -1
End Function

Private Function WStringList.CountOf(ByRef FItem As WString) As Integer
	Dim _Count As Integer
	For i As Integer = 0 To FCount - 1
		If LCase(QWStringListItem(FItems.Items[i]).Value) = LCase(FItem) Then _Count += 1
	Next i
	Return _Count
End Function

Private Operator WStringList.Let(ByRef Value As WString)
	This.Text = Value
End Operator

Private Constructor WStringList
	FItems.Clear
	FCount = 0
End Constructor

Private Destructor WStringList
'	If FCount>0 Then
'		For i As Integer = FCount - 1 To 0 Step -1
'			Delete_( Cast(WStringListItem Ptr, FItems.Items[i]))
'		Next i
'	End If
	If FText Then Deallocate_( FText)
	This.Clear
End Destructor
