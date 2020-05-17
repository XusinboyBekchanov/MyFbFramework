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
Property WStringListItem.Value ByRef As WString
	Return WGet(FValue)
End Property

Property WStringListItem.Value(ByRef V As WString)
	WLet FValue, V
End Property

Operator WStringListItem.Cast As Any Ptr
	Return Object
End Operator

Operator WStringListItem.Cast As String
	Return Value
End Operator

Operator WStringListItem.Let(V As Any Ptr)
	Object = V
End Operator

Operator WStringListItem.Let(ByRef V As WString)
	WLet FValue, V
End Operator

Constructor WStringListItem
	Value = ""
	Object  = 0
End Constructor

Destructor WStringListItem
	If FValue Then Deallocate FValue
	Object  = 0
End Destructor

Operator WStringList.Cast As Any Ptr
	Return @This
End Operator

Property WStringList.Count As Integer
	Return FItems.Count
End Property

Property WStringList.Count(Value As Integer)
End Property

Property WStringList.Text ByRef As WString
	WLet FText, ""
	For i As Integer = 0 To FCount -1
		If i <> FCount -1 Then
			WLet FText, *FText & Item(i) & Chr(13) & Chr(10)
		Else
			WLet FText, *FText & Item(i)
		End If
	Next i
	Return *FText
End Property

Property WStringList.Text(ByRef Value As WString)
	WLet FText, ""
	This.Clear
	For i As Integer = 0 To Len(Value)
		WLet FText, *FText & WChr(Value[i])
		If Value[i] = 10 Or Value[i] = 0 Then
			Add Trim(Mid(*FText, 1, Len(*FText) - 1), Any WChr(13))
			WLet FText, ""
		End If
	Next i
End Property

Property WStringList.Item(Index As Integer) ByRef As WString
	If Index >= 0 And Index <= FCount -1 Then
		Return QWStringListItem(FItems.Items[Index]).Value
	End If
	Return ""
End Property

Property WStringList.Item(Index As Integer, ByRef FItem As WString)
	If Index >= 0 And Index <= FCount -1 Then
		QWStringListItem(FItems.Items[Index]).Value = FItem
	End If
End Property

Property WStringList.Object(Index As Integer) As Any Ptr
	If Index >= 0 And Index <= FCount -1 Then
		Return QWStringListItem(FItems.Items[Index]).Object
	End If
	Return 0
End Property

Property WStringList.Object(Index As Integer, FObj As Any Ptr)
	If Index >= 0 And Index <= FCount -1 Then
		QWStringListItem(FItems.Items[Index]).Object = FObj
	End If
End Property

Sub WStringList.Add(ByRef FItem As WString, FObj As Any Ptr = 0)
	Dim As WStringListItem Ptr nItem = New WStringListItem
	With *nItem
		.Value  = FItem
		.Object = FObj
	End With
	FItems.Add nItem
	If OnAdd Then OnAdd(This, FItem, FObj)
	FCount = FItems.Count
End Sub

Sub WStringList.Insert(Index As Integer, ByRef FItem As WString, FObj As Any Ptr = 0)
	Dim As WStringListItem Ptr nItem = New WStringListItem
	With *nItem
		.Value  = FItem
		.Object = FObj
	End With
	FItems.Insert Index, nItem
	If OnInsert Then OnInsert(This, Index, FItem, FObj)
	FCount = FItems.Count
End Sub

Sub WStringList.Exchange(Index1 As Integer, Index2 As Integer)
	FItems.Exchange(Index1, Index2)
	If OnExchange Then OnExchange(This, Index1, Index2)
End Sub

Sub WStringList.Remove(Index As Integer)
	Delete Cast(WStringListItem Ptr, FItems.Items[Index])
	FItems.Remove Index
	FCount -=1' FItems.Count
	If OnRemove Then OnRemove(This, Index)
End Sub

Sub WStringList.Sort(MatchCase As Boolean = False)
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

Sub WStringList.Clear
	If FCount < 1 Then Exit Sub
	For i As Integer = FCount - 1 To 0 Step -1
		If FItems.Items[i] <> 0 Then Delete Cast(WStringListItem Ptr, FItems.Items[i])
	Next i
	FItems.Clear
	FCount = 0
	If OnClear Then OnClear(This)
End Sub

Sub WStringList.SaveToFile(ByRef FileName As WString)
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

Sub WStringList.LoadFromFile(ByRef FileName As WString)
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

Function WStringList.IndexOf(ByRef FItem As WString) As Integer
	For i As Integer = 0 To FCount -1
		If LCase(QWStringListItem(FItems.Items[i]).Value) = LCase(FItem) Then Return i
	Next i
	Return -1
End Function

Function WStringList.IndexOfObject(FObj As Any Ptr) As Integer
	For i As Integer = 0 To FCount -1
		If QWStringListItem(FItems.Items[i]).Object = FObj Then Return i
	Next i
	Return -1
End Function

Function WStringList.Contains(ByRef FItem As WString) As Boolean
	Return IndexOf(FItem) <> -1
End Function

Constructor WStringList
	FItems.Clear
	FCount = 0
End Constructor

Destructor WStringList
	If FCount>0 Then
		For i As Integer = FCount - 1 To 0 Step -1
			Delete Cast(WStringListItem Ptr, FItems.Items[i])
		Next i
	End If
	If FText Then Deallocate FText
End Destructor
