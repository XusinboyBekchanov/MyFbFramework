'###############################################################################
'#  WStringList.bi                                                             #
'#  This file is part of MyFBFramework			                         #
'#  Version 1.0.0                                                              #
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
    Return *FKey
End Property

Property DictionaryItem.Key(ByRef V As WString)
    WLet FKey, V
End Property

Property DictionaryItem.Text ByRef As WString
    Return *FText
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

Property WStringList.Count As Integer
    Return FItems.Count
End Property

Property WStringList.Count(Value As Integer)
End Property

Property WStringList.Text ByRef As WString
    WLet FText, ""
    For i As Integer = 0 To Count -1
        If i <> Count -1 Then 
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
    If Index >= 0 AND Index <= Count -1 Then
       Return QWStringListItem(FItems.Items[Index]).Value
    End If 
    Return ""
End Property

Property WStringList.Item(Index As Integer, ByRef FItem As WString)
    If Index >= 0 AND Index <= Count -1 Then
       QWStringListItem(FItems.Items[Index]).Value = FItem
    End If 
End Property

Property WStringList.Object(Index As Integer) As Any Ptr
    If Index >= 0 AND Index <= Count -1 Then
       Return QWStringListItem(FItems.Items[Index]).Object
    End If 
    Return 0
End Property

Property WStringList.Object(Index As Integer, FObj As Any Ptr)
    If Index >= 0 AND Index <= Count -1 Then
       QWStringListItem(FItems.Items[Index]).Object = FObj
    End If 
End Property

Sub WStringList.Add(ByRef FItem As WString, FObj As Any Ptr = 0)
    Dim As WStringListItem Ptr nItem = New WStringListItem
    with *nItem
        .Value  = FItem
        .Object = FObj
    End With
    FItems.Add nItem
    If OnAdd Then OnAdd(This, FItem, FObj)
End Sub

Sub WStringList.Insert(Index As Integer, ByRef FItem As WString, FObj As Any Ptr = 0)
    Dim As WStringListItem Ptr nItem = New WStringListItem
    with *nItem
        .Value  = FItem
        .Object = FObj
    End With
    FItems.Insert Index, nItem 
    If OnInsert Then OnInsert(This, Index, FItem, FObj)
End Sub

Sub WStringList.Exchange(Index1 As Integer, Index2 As Integer)
    FItems.Exchange(Index1, Index2)
    If OnExchange Then OnExchange(This, Index1, Index2)
End Sub

Sub WStringList.Remove(Index As Integer)
    Delete Cast(WStringListItem Ptr, FItems.Items[Index])
    FItems.Remove Index
    If OnRemove Then OnRemove(This, Index)
End Sub

Sub WStringList.Sort
    Dim As Integer i,j
    For i = 1 To Count -1
        For j = Count -1 To i Step -1
            If (Item(j) < Item(j - 1)) Then
               Exchange j - 1, j
            End If 
        Next
    Next
End Sub

Sub WStringList.Clear
    For i As Integer = Count -1 To 0 Step -1
        Delete Cast(WStringListItem Ptr, FItems.Items[i])
    Next i
    FItems.Clear
    If OnClear Then OnClear(This)
End Sub

Sub WStringList.SaveToFile(ByRef File As WString)
    Dim As Integer F
    F = FreeFile
    If Open(File For Binary Access Write As #F) = 0 Then
        For i As Integer = 0 To Count -1 
            Print #F, Item(i)
        Next i    
        Close #F
    Else
        'Error
    End If
End Sub

Sub WStringList.LoadFromFile(ByRef File As WString)
    Dim As Integer F
    F = FreeFile
    If Open(File For Binary Access Read As #F) = 0 Then
	  WReallocate FText, Lof(F) + 1
        This.Clear
        While NOT EOF(F)
            Line Input #F, *FText
            Add *FText
        WEnd    
        Close #F
    Else
        'Error
    End If
End Sub

Function WStringList.IndexOf(ByRef FItem As WString) As Integer
    For i As Integer = 0 To Count -1
        If QWStringListItem(FItems.Items[i]).Value = FItem Then Return i
    Next i
    Return -1
End Function

Function WStringList.IndexOfObject(FObj As Any Ptr) As Integer
    For i As Integer = 0 To Count -1
        If QWStringListItem(FItems.Items[i]).Object = FObj Then Return i
    Next i
    Return -1
End Function

Function WStringList.Contains(ByRef FItem As WString) As Boolean
    Return IndexOf(FItem) <> -1
End Function

Constructor WStringList
	FItems.Clear
End Constructor

Destructor WStringList
    	For i As Integer = Count -1 To 0 Step -1
      	Delete Cast(WStringListItem Ptr, FItems.Items[i])
    	Next i
	If FText Then Deallocate FText
End Destructor
