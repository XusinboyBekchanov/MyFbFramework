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
Private Property DictionaryItem.Key ByRef As WString
	Return WGet(FKey)
End Property

Private Property DictionaryItem.Key(ByRef V As WString)
	WLet(FKey, V)
End Property

Private Property DictionaryItem.Text ByRef As WString
	Return WGet(FText)
End Property

Private Property DictionaryItem.Text(ByRef V As WString)
	WLet(FText, V)
End Property

Private Constructor DictionaryItem
	Key = ""
	Text = ""
	Object = 0
End Constructor

Private Destructor DictionaryItem
	If FKey Then Deallocate_( FKey)
	If FText Then Deallocate_( FText)
End Destructor
Private Operator DictionaryItem.Cast As Any Ptr
	Return @This
End Operator

Private Property Dictionary.Count As Integer
	Return FItems.Count
End Property

Private Property Dictionary.Count(Value As Integer)
End Property

Private Property Dictionary.Item(Index As Integer) As DictionaryItem Ptr
	If Index >= 0 And Index <= Count -1 Then
		Return FItems.Items[Index]
	End If
	Return 0
End Property

Private Property Dictionary.Item(Index As Integer, FItem As DictionaryItem Ptr)
	If Index >= 0 And Index <= Count -1 Then
		FItems.Items[Index] = FItem
		If OnChange Then OnChange(This)
	End If
End Property

Private Property Dictionary.Item(ByRef Key As WString) As DictionaryItem Ptr
	Return Item(IndexOfKey(Key))
End Property

Private Property Dictionary.Item(ByRef Key As WString, FItem As DictionaryItem Ptr)
	Item(IndexOfKey(Key)) = FItem
	If OnChange Then OnChange(This)
End Property

Private Sub Dictionary.Add(ByRef Key As WString = "", ByRef wText As WString = "", Object As Any Ptr = 0)
	Dim As DictionaryItem Ptr nItem = New_( DictionaryItem)
	With *nItem
		.Key  = Key
		.Text = wText
		.Object = Object
	End With
	FItems.Add nItem
	If OnChange Then OnChange(This)
End Sub

Private Sub Dictionary.Set(ByRef Key As WString, ByRef wText As WString = "", Object As Any Ptr = 0)
	If Not ContainsKey(Key) Then
		This.Add Key, wText, Object
	Else
		Item(Key)->Text = wText
		Item(Key)->Object = Object
	End If
	If OnChange Then OnChange(This)
End Sub

Private Function Dictionary.Get(ByRef Key As WString, ByRef DefaultText As WString = "") ByRef As WString
	If Not ContainsKey(Key) Then
		Return DefaultText
	Else
		Return Item(Key)->Text
	End If
End Function

Private Function Dictionary.Get(Index As Integer, ByRef DefaultText As WString = "") ByRef As WString
	If Index >= 0 And Index <= Count - 1 Then
		Return Item(Index)->Text
	Else
		Return DefaultText
	End If
End Function

Private Sub Dictionary.Insert(Index As Integer, ByRef Key As WString = "", ByRef wText As WString = "", Object As Any Ptr = 0)
	Dim As DictionaryItem Ptr nItem = New_( DictionaryItem)
	With *nItem
		.Key  = Key
		.Text = wText
		.Object = Object
	End With
	FItems.Insert Index, nItem
	If OnChange Then OnChange(This)
End Sub

Private Sub Dictionary.Exchange(Index1 As Integer, Index2 As Integer)
	FItems.Exchange(Index1, Index2)
	If OnChange Then OnChange(This)
End Sub

Private Sub Dictionary.Remove(Index As Integer)
	Delete_( Cast(DictionaryItem Ptr, FItems.Items[Index]))
	FItems.Remove Index
	If OnChange Then OnChange(This)
End Sub

Private Sub Dictionary.Sort
	Dim As Integer i, j
	For i = 1 To Count - 1
		For j = Count - 1 To i Step -1
			If (Item(j)->Text < Item(j - 1)->Text) Then
				Exchange j - 1, j
			End If
		Next
	Next
	If OnChange Then OnChange(This)
End Sub

Private Sub Dictionary.SortKeys
	Dim As Integer i, j
	For i = 1 To Count - 1
		For j = Count - 1 To i Step -1
			If (Item(j)->Key < Item(j - 1)->Key) Then
				Exchange j - 1, j
			End If
		Next
	Next
	If OnChange Then OnChange(This)
End Sub

Private Sub Dictionary.Clear
	For i As Integer = Count - 1 To 0 Step -1
		Delete_( Cast(DictionaryItem Ptr, FItems.Items[i]))
	Next i
	FItems.Clear
	If OnChange Then OnChange(This)
End Sub

Private Sub Dictionary.SaveToFile(ByRef FileName As WString)
	Dim As Integer Fn = FreeFile
	'If Open(FileName For Binary Access Write As #F) = 0 Then
	If Open(FileName For Output Encoding "utf-8" As #Fn) = 0 Then 'David Change
		For i As Integer = 0 To Count - 1
			Print #Fn, Item(i)->Key & ": " & Item(i)->Text 'David Change
		Next
	End If
	Close #Fn
End Sub

Private Sub Dictionary.LoadFromFile(ByRef FileName As WString)
	Dim As Integer Fn = FreeFile, Result = -1, Pos1 = -1
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
			If Trim(Buff, Any !"\t ") <> "" Then 'David Change
				Pos1 = InStr(Buff, ": ")
				If Pos1 > 0 Then
					Dim As DictionaryItem Ptr nItem = New_( DictionaryItem)
					With *nItem
						If Pos1 > 0 Then
							.Key  = ..Left(*FText, Pos1 - 1)
							.Text = Mid(*FText, Pos1 + 2)
						Else
							.Key  = *FText
						End If
					End With
					FItems.Add nItem
				End If
			End If
		Wend
	End If
	Close #Fn
	If OnChange Then OnChange(This)
End Sub

Private Function Dictionary.IndexOf(ByRef wText As WString) As Integer
	For i As Integer = 0 To Count - 1
		If QDictionaryItem(FItems.Items[i]).Text = wText Then Return i
	Next i
	Return -1
End Function

Private Function Dictionary.IndexOfKey(ByRef Key As WString) As Integer
	For i As Integer = 0 To Count - 1
		If QDictionaryItem(FItems.Items[i]).Key = Key Then Return i
	Next i
	Return -1
End Function

Private Function Dictionary.IndexOfObject(Object As Any Ptr) As Integer
	For i As Integer = 0 To Count - 1
		If QDictionaryItem(FItems.Items[i]).Object = Object Then Return i
	Next i
	Return -1
End Function

Private Function Dictionary.GetText(ByRef Key As WString) ByRef As WString
	For i As Integer = 0 To Count - 1
		If QDictionaryItem(FItems.Items[i]).Key = Key Then Return QDictionaryItem(FItems.Items[i]).Text
	Next i
	Return ""
End Function

Private Function Dictionary.GetObject(ByRef Key As WString) As Any Ptr
	For i As Integer = 0 To Count - 1
		If QDictionaryItem(FItems.Items[i]).Key = Key Then Return QDictionaryItem(FItems.Items[i]).Object
	Next i
	Return 0
End Function

Private Function Dictionary.GetKey(ByRef wText As WString) ByRef As WString
	For i As Integer = 0 To Count - 1
		If QDictionaryItem(FItems.Items[i]).Text = wText Then Return QDictionaryItem(FItems.Items[i]).Key
	Next i
	Return ""
End Function

Private Function Dictionary.GetKey(Object As Any Ptr) ByRef As WString
	For i As Integer = 0 To Count - 1
		If QDictionaryItem(FItems.Items[i]).Object = Object Then Return QDictionaryItem(FItems.Items[i]).Key
	Next i
	Return ""
End Function

Private Property Dictionary.Text ByRef As WString
	WLet(FText, "")
	For i As Integer = 0 To FItems.Count - 1
		If i <> FItems.Count - 1 Then
			WLet(FText, *FText & Item(i)->Key & ": " & Item(i)->Text & Chr(13) & Chr(10))
		Else
			WLet(FText, *FText & Item(i)->Key & ": " & Item(i)->Text)
		End If
	Next i
	Return *FText
End Property

Private Property Dictionary.Text(ByRef Value As WString)
	WLet(FText, "")
	This.Clear
	Dim As Integer Pos1
	For i As Integer = 0 To Len(Value)
		If Value[i] = 10 Or Value[i] = 0 Then
			WLet(*FText, Trim(Mid(*FText, 1, Len(*FText)), Any WChr(13) & WChr(10)))
			Pos1 = InStr(*FText, ": ")
			Dim As DictionaryItem Ptr nItem = New_( DictionaryItem)
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
			WLet(FText, *FText & WChr(Value[i]))
		End If
	Next i
	If OnChange Then OnChange(This)
End Property

Private Function Dictionary.Contains(ByRef wText As WString) As Boolean
	Return IndexOf(wText) <> -1
End Function

Private Function Dictionary.ContainsKey(ByRef Key As WString) As Boolean
	Return IndexOfKey(Key) <> -1
End Function

Private Function Dictionary.ContainsObject(Object As Any Ptr) As Boolean
	Return IndexOfObject(Object) <> -1
End Function

Private Operator Dictionary.Let(ByRef Value As WString)
	This.Text = Value
End Operator

Private Constructor Dictionary
	FItems.Clear
End Constructor

Private Destructor Dictionary
'	For i As Integer = Count - 1 To 0 Step -1
'		Delete_( Cast(DictionaryItem Ptr, FItems.Items[i]))
'	Next i
'	FItems.Clear
	This.Clear
	If FText Then Deallocate_( FText)
End Destructor
