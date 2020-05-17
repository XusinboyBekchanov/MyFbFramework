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
Property DictionaryItem.Key ByRef As WString
	Return WGet(FKey)
End Property

Property DictionaryItem.Key(ByRef V As WString)
	WLet FKey, V
End Property

Property DictionaryItem.Text ByRef As WString
	Return WGet(FText)
End Property

Property DictionaryItem.Text(ByRef V As WString)
	WLet FText, V
End Property

Constructor DictionaryItem
	Key = ""
	Text = ""
End Constructor

Destructor DictionaryItem
	If FKey Then Deallocate FKey
	If FText Then Deallocate FText
End Destructor

Operator DictionaryItem.Cast As Any Ptr
	Return @This
End Operator

Property Dictionary.Count As Integer
	Return FItems.Count
End Property

Property Dictionary.Count(Value As Integer)
End Property

Property Dictionary.Item(Index As Integer) As DictionaryItem Ptr
	If Index >= 0 And Index <= Count -1 Then
		Return FItems.Items[Index]
	End If
	Return 0
End Property

Property Dictionary.Item(Index As Integer, FItem As DictionaryItem Ptr)
	If Index >= 0 And Index <= Count -1 Then
		FItems.Items[Index] = FItem
	End If
End Property

Property Dictionary.Item(ByRef Key As WString) As DictionaryItem Ptr
	Return Item(IndexOfKey(Key))
End Property

Property Dictionary.Item(ByRef Key As WString, FItem As DictionaryItem Ptr)
	Item(IndexOfKey(Key)) = FItem
End Property

Sub Dictionary.Add(ByRef Key As WString = "", ByRef Text As WString)
	Dim As DictionaryItem Ptr nItem = New DictionaryItem
	With *nItem
		.Key  = Key
		.Text = Text
	End With
	FItems.Add nItem
End Sub

Sub Dictionary.Set(ByRef Key As WString, ByRef Text As WString)
	If Not ContainsKey(Key) Then
		This.Add Key, Text
	Else
		Item(Key)->Text = Text
	End If
End Sub

Function Dictionary.Get(ByRef Key As WString, ByRef DefaultText As WString = "") ByRef As WString
	If Not ContainsKey(Key) Then
		Return DefaultText
	Else
		Return Item(Key)->Text
	End If
End Function

Sub Dictionary.Insert(Index As Integer, ByRef Key As WString = "", ByRef Text As WString)
	Dim As DictionaryItem Ptr nItem = New DictionaryItem
	With *nItem
		.Key  = Key
		.Text = Text
	End With
	FItems.Insert Index, nItem
End Sub

Sub Dictionary.Exchange(Index1 As Integer, Index2 As Integer)
	FItems.Exchange(Index1, Index2)
End Sub

Sub Dictionary.Remove(Index As Integer)
	Delete Cast(DictionaryItem Ptr, FItems.Items[Index])
	FItems.Remove Index
End Sub

Sub Dictionary.Sort
	Dim As Integer i, j
	For i = 1 To Count - 1
		For j = Count - 1 To i Step -1
			If (Item(j)->Text < Item(j - 1)->Text) Then
				Exchange j - 1, j
			End If
		Next
	Next
End Sub

Sub Dictionary.SortKeys
	Dim As Integer i, j
	For i = 1 To Count - 1
		For j = Count - 1 To i Step -1
			If (Item(j)->Key < Item(j - 1)->Key) Then
				Exchange j - 1, j
			End If
		Next
	Next
End Sub

Sub Dictionary.Clear
	For i As Integer = Count - 1 To 0 Step -1
		Delete Cast(DictionaryItem Ptr, FItems.Items[i])
	Next i
	FItems.Clear
End Sub

Sub Dictionary.SaveToFile(ByRef FileName As WString)
	Dim As Integer Fn = FreeFile
	'If Open(FileName For Binary Access Write As #F) = 0 Then
	If Open(FileName For Output Encoding "utf-8" As #Fn) = 0 Then 'David Change
		For i As Integer = 0 To Count -1
			Print #Fn, Item(i)->Key & WChr(9) & " " & Item(i)->Text 'David Change
		Next
	End If
	Close #Fn
End Sub

Sub Dictionary.LoadFromFile(ByRef FileName As WString)
	Dim As Integer Fn = FreeFile, Result = -1, Posi = -1
	Dim Buff As WString * 2000 'David Change for V1.07 Line Input not working fine
	'If Open(FileName For Binary Access Read As #Fn) = 0 Then
	Result = Open(FileName For Input Encoding "utf-8" As #Fn)
	If Result <> 0 Then Result = Open(FileName For Input Encoding "utf-16" As #Fn)
	If Result <> 0 Then Result = Open(FileName For Input Encoding "utf-32" As #Fn)
	If Result <> 0 Then Result = Open(FileName For Input As #Fn)
	If Result = 0 Then  'David Change
		'Dim FText As WString Ptr
		'WReallocate FText, LOF(F) + 1
		This.Clear
		While Not EOF(Fn)
			Line Input #Fn, Buff
			If Trim(Buff, Any !"\t ")<>"" Then  'David Change
				Posi=InStr(Buff,WChr(9))
				If Posi>0 Then Add Left(Buff,Posi), Trim(Mid(Buff,Posi+2))
			End If
		WEnd
	End If
	Close #Fn
End Sub

Function Dictionary.IndexOf(ByRef Text As WString) As Integer
	For i As Integer = 0 To Count - 1
		If QDictionaryItem(FItems.Items[i]).Text = Text Then Return i
	Next i
	Return -1
End Function

Function Dictionary.IndexOfKey(ByRef Key As WString) As Integer
	For i As Integer = 0 To Count - 1
		If QDictionaryItem(FItems.Items[i]).Key = Key Then Return i
	Next i
	Return -1
End Function

Function Dictionary.GetText(ByRef Key As WString) ByRef As WString
	For i As Integer = 0 To Count - 1
		If QDictionaryItem(FItems.Items[i]).Key = Key Then Return QDictionaryItem(FItems.Items[i]).Text
	Next i
	Return ""
End Function

Function Dictionary.GetKey(ByRef Text As WString) ByRef As WString
	For i As Integer = 0 To Count - 1
		If QDictionaryItem(FItems.Items[i]).Text = Text Then Return QDictionaryItem(FItems.Items[i]).Key
	Next i
	Return ""
End Function

Function Dictionary.Contains(ByRef Text As WString) As Boolean
	Return IndexOf(Text) <> -1
End Function

Function Dictionary.ContainsKey(ByRef Key As WString) As Boolean
	Return IndexOfKey(Key) <> -1
End Function

Constructor Dictionary
	FItems.Clear
End Constructor

Destructor Dictionary
	For i As Integer = Count - 1 To 0 Step -1
		Delete Cast(DictionaryItem Ptr, FItems.Items[i])
	Next i
	FItems.Clear
End Destructor
