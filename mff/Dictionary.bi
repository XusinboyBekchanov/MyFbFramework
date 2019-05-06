'###############################################################################
'#  Dictionary.bi                                                              #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TStringList.bi                                                            #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Adapted to Dictionary by Xusinboy Bekchanov (2018-2019)                    #
'###############################################################################

#Include Once "List.bi"
#Include Once "SysUtils.bi"

#DEFINE QDictionaryItem(__Ptr__) *Cast(DictionaryItem Ptr,__Ptr__)
#DEFINE QDictionary(__Ptr__) *Cast(Dictionary Ptr,__Ptr__)

Type DictionaryItem Extends Object
    Private:
		      FKey   As WString Ptr
        FText    As WString Ptr
    Public:
    		Declare Property Key ByRef As WString
    		Declare Property Key(ByRef V As WString)
    		Declare Property Text ByRef As WString
    		Declare Property Text(ByRef V As WString)
    		Declare Operator Cast As Any Ptr
    		Declare Constructor
    		Declare Destructor
End Type

Type Dictionary Extends Object
    Private:
    		  FCount   As Integer
    		  FItems   As List
    Public:
        		Declare Property Count As Integer
        		Declare Property Count(Value As Integer)
        		Declare Property Item(Index As Integer) As DictionaryItem Ptr
        		Declare Property Item(Index As Integer, FItem As DictionaryItem Ptr)
        		Declare Property Item(ByRef Key As WString) As DictionaryItem Ptr
        		Declare Property Item(ByRef Key As WString, FItem As DictionaryItem Ptr)
        		Declare Sub Add(ByRef Key As WString = "", ByRef Text As WString)
        		Declare Sub Insert(Index As Integer, ByRef Key As WString = "", ByRef Text As WString)
        		Declare Sub Remove(Index As Integer)
        		Declare Sub Remove(ByRef Key As WString)
          Declare Sub Exchange(Index1 As Integer, Index2 As Integer)
        		Declare Sub Sort
        		Declare Sub SortKeys
        		Declare Sub Clear
        		Declare Function IndexOf(ByRef Text As WString) As Integer
        		Declare Function IndexOfKey(ByRef Key As WString) As Integer
        		Declare Function Contains(ByRef Text As WString) As Boolean
        		Declare Function ContainsKey(ByRef Key As WString) As Boolean
        		Declare Sub SaveToFile(ByRef File As WString)
        		Declare Sub LoadFromFile(ByRef File As WString)
        		Declare Operator Cast As Any Ptr
        		Declare Constructor
        		Declare Destructor
End Type

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
    If Index >= 0 AND Index <= Count -1 Then
       Return FItems.Items[Index]
    End If 
    Return 0
End Property

Property Dictionary.Item(Index As Integer, FItem As DictionaryItem Ptr)
    If Index >= 0 AND Index <= Count -1 Then
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
    with *nItem
        .Key  = Key
        .Text = Text
    End With
    FItems.Add nItem
End Sub

Sub Dictionary.Insert(Index As Integer, ByRef Key As WString = "", ByRef Text As WString)
    Dim As DictionaryItem Ptr nItem = New DictionaryItem
    with *nItem
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

Sub Dictionary.SaveToFile(ByRef File As WString)
    Dim As Integer F
    F = FreeFile
    If Open(File For Binary Access Write As #F) = 0 Then
        For i As Integer = 0 To Count -1 
            Print #F, Item(i)->Text
        Next i    
        Close #F
    Else
        'Error
    End If
End Sub

Sub Dictionary.LoadFromFile(ByRef File As WString)
    Dim As Integer F
    F = FreeFile
    If Open(File For Binary Access Read As #F) = 0 Then
    	   Dim FText As WString Ptr    
        WReallocate FText, Lof(F) + 1
        This.Clear
        While NOT EOF(F)
            Line Input #F, *FText
            Add "", *FText
        WEnd    
        Close #F
        If FText Then Deallocate FText
    Else
        'Error
    End If
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
End Destructor
