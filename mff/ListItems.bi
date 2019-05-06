'###############################################################################
'#  ListItems.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor                                                     #
'#  Based on:                                                                  #
'#   TListItems.bi                                                             #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'###############################################################################

#Include Once "WStringList.bi"
#Include Once "Control.bi"

#DEFINE QListItems(__Ptr__) *Cast(ListItems Ptr,__Ptr__)

Type ListItems Extends Object
    Private:
       FItems As WStringList
    Public:
        Parent   As My.Sys.Forms.Control Ptr
        Declare Property Count As Integer
        Declare Property Count(Value As Integer)
        Declare Property Text ByRef As WString
        Declare Property Text(ByRef Value As WString)
        Declare Property Item(Index As Integer) ByRef As WString
        Declare Property Item(Index As Integer, ByRef Value As WString)
        Declare Property Object(Index As Integer) As Any Ptr
        Declare Property Object(Index As Integer, Value As Any Ptr)
        Declare Sub Add(ByRef FString As WString, FData As Any Ptr = 0)
        Declare Sub Insert(FIndex As Integer, ByRef FString As WString, FData As Any Ptr = 0)
        Declare Sub Remove(FIndex As Integer)
        Declare Sub Exchange(FIndex1 As Integer, FIndex2 As Integer)
        Declare Sub Sort
        Declare Sub Clear
        Declare Sub SaveToFile(ByRef File As WString)
        Declare Sub LoadFromFile(ByRef File As WString)
        Declare Function IndexOf(ByRef FString As WString) As Integer 
        Declare Function IndexOfObject(FData As Any Ptr) As Integer
        Declare Function Contains(ByRef FString As WString) As Boolean
        Declare Operator Cast As Any Ptr
        Declare Constructor
        Declare Destructor
End Type

Operator ListItems.Cast As Any Ptr 
    Return @This
End Operator

Property ListItems.Count As Integer
    Return FItems.Count
End Property

Property ListItems.Count(Value As Integer)
End Property

Property ListItems.Text ByRef As WString
    Return FItems.Text
End Property

Property ListItems.Text(ByRef Value As WString)
    FItems.Text = Value
End Property

Property ListItems.Item(Index As Integer) ByRef As WString 
    Return FItems.Item(Index)
End Property

Property ListItems.Item(Index As Integer, ByRef FItem As WString)
    FItems.Item(Index) = FItem
End Property

Property ListItems.Object(Index As Integer) As Any Ptr
    Return FItems.Object(Index)
End Property

Property ListItems.Object(Index As Integer, FObj As Any Ptr)
    FItems.Object(Index) = FObj
End Property

Sub ListItems.Add(ByRef FItem As WString, FObj As Any Ptr = 0)
    FItems.Add FItem, FObj
End Sub

Sub ListItems.Insert(Index As Integer, ByRef FItem As WString, FObj As Any Ptr = 0)
    FItems.Insert Index, FItem, FObj
End Sub

Sub ListItems.Exchange(Index1 As Integer, Index2 As Integer)
    FItems.Exchange Index1, Index2
End Sub

Sub ListItems.Remove(Index As Integer)
    FItems.Remove Index
End Sub

Sub ListItems.Sort
    FItems.Sort
End Sub

Sub ListItems.Clear
    FItems.Clear
End Sub

Sub ListItems.SaveToFile(ByRef File As WString)
    FItems.SaveToFile File
End Sub

Sub ListItems.LoadFromFile(ByRef File As WString)
    FItems.LoadFromFile File
End Sub

Function ListItems.IndexOf(ByRef FItem As WString) As Integer
    Return FItems.IndexOF(FItem)
End Function

Function ListItems.IndexOfObject(FObj As Any Ptr) As Integer
    Return FItems.IndexOFObject(FObj)
End Function

Function ListItems.Contains(ByRef FItem As WString) As Boolean
    Return FItems.IndexOF(FItem) <> -1
End Function

Constructor ListItems
    FItems.Clear
End Constructor

Destructor ListItems
    FItems.Clear
End Destructor
