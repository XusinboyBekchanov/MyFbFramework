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

#Include Once "ListItems.bi"

#DEFINE QStringList(__Ptr__) *Cast(StringList Ptr,__Ptr__)

Type StringList
    Private:
		FText   As String
    Public:
		Control As My.Sys.Forms.Control Ptr
		Items   As ListItems
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Text As String
		Declare Property Text(Value As String)
		Declare Property Item(Index As Integer) As String
		Declare Property Item(Index As Integer, FItem As String)
		Declare Property Object(Index As Integer) As Any Ptr
		Declare Property Object(Index As Integer, FObj As Any Ptr)
		Declare Sub Add(Item As String, FObj As Any Ptr = 0)
		Declare Sub Insert(Index As Integer, FItem As String, FObj As Any Ptr = 0)
		Declare Sub Exchange(Index1 As Integer, Index2 As Integer)
		Declare Sub Remove(Index As Integer)
		Declare Sub Sort
		Declare Sub Clear
		Declare Function IndexOf(FItem As String) As Integer
		Declare Function IndexOfObject(FObj As Any Ptr) As Integer
		Declare Function Contains(FItem As String) As Boolean
		Declare Sub SaveToFile(ByRef File As WString)
		Declare Sub LoadFromFile(ByRef File As WString)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		OnAdd      As Sub(BYREF Sender As StringList, FItem As String, FObj As Any Ptr = 0)
		OnInsert   As Sub(BYREF Sender As StringList, FIndex As Integer, ByRef FItem As WString, FObj As Any Ptr = 0)
		OnRemove   As Sub(BYREF Sender As StringList, FIndex As Integer)
		OnExchange As Sub(BYREF Sender As StringList, FIndex1 As Integer, FIndex2 As Integer)
		OnClear    As Sub(BYREF Sender As StringList)
End Type

Operator StringList.Cast As Any Ptr 
    Return @This
End Operator

Property StringList.Count As Integer
    Return Items.Count
End Property

Property StringList.Count(Value As Integer)
End Property

Property StringList.Text As String
    Return Items.Text
End Property

Property StringList.Text(Value As String)
    Items.Text = Value
End Property

Property StringList.Item(Index As Integer) As String 
    Return Items.Item(Index)
End Property

Property StringList.Item(Index As Integer, FItem As String)
    Items.Item(Index) = FItem
End Property

Property StringList.Object(Index As Integer) As Any Ptr
    Return Items.Object(Index)
End Property

Property StringList.Object(Index As Integer, FObj As Any Ptr)
    Items.Object(Index) = FObj
End Property

Sub StringList.Add(FItem As String, FObj As Any Ptr = 0)
    Items.Add FItem, FObj
    If OnAdd Then OnAdd(This, FItem, FObj)
End Sub

Sub StringList.Insert(Index As Integer, FItem As String, FObj As Any Ptr = 0)
    Items.Insert Index, FItem, FObj
    If OnInsert Then OnInsert(This, Index, FItem, FObj)
End Sub

Sub StringList.Exchange(Index1 As Integer, Index2 As Integer)
    Items.Exchange Index1, Index2
    If OnExchange Then OnExchange(This, Index1, Index2)
End Sub

Sub StringList.Remove(Index As Integer)
    Items.Remove Index
    If OnRemove Then OnRemove(This, Index)
End Sub

Sub StringList.Sort
    Items.Sort
End Sub

Sub StringList.Clear
    Items.Clear
    If OnClear Then OnClear(This)
End Sub

Sub StringList.SaveToFile(ByRef File As WString)
    Items.SaveToFile File
End Sub

Sub StringList.LoadFromFile(ByRef File As WString)
    Items.LoadFromFile File
End Sub

Function StringList.IndexOf(FItem As String) As Integer
    Return Items.IndexOF(FItem)
End Function

Function StringList.IndexOfObject(FObj As Any Ptr) As Integer
    Return Items.IndexOFObject(FObj)
End Function

Function StringList.Contains(FItem As String) As Boolean
    Return Items.IndexOF(FItem) <> -1
End Function

Constructor StringList
    Items.Clear
End Constructor

Destructor StringList
    Items.Clear
End Destructor
