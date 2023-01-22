﻿'###############################################################################
'#  StatusBar.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor                                                     #
'#  Based on:                                                                  #
'#   TStringList.bi                                                            #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'###############################################################################

#include once "List.bi"

#define QStringList(__Ptr__) (*Cast(StringList Ptr,__Ptr__))
#define QStringListItem(__Ptr__) (*Cast(StringListItem Ptr, __Ptr__))

Private Type StringListItem Extends Object
Public:
	Value As String
	Object  As Any Ptr
	Declare Operator Cast As Any Ptr
	Declare Operator Let(V As Any Ptr)
	Declare Operator Let(ByRef V As String)
	Declare Constructor
	Declare Destructor
End Type

Private Type StringList
Private:
	FText               As String
	FMatchCase          As Boolean
	FMatchFullWords     As Boolean
	FSorted             As Boolean
	FCount              As Integer
	FItems              As List
Public:
	Tag As Any Ptr
	Declare Property Count As Integer
	Declare Property Count(Value As Integer)
	Declare Property Item(Index As Integer) As String
	Declare Property Item(Index As Integer, FItem As String)
	Declare Property MatchCase As Boolean 
	Declare Property MatchCase(iValue As Boolean)
	Declare Property MatchFullWords As Boolean 
	Declare Property MatchFullWords(iValue As Boolean)
	Declare Property Sorted As Boolean 
	Declare Property Sorted(iValue As Boolean)
	Declare Property Text As String
	Declare Property Text(Value As String)
	Declare Property Object(Index As Integer) As Any Ptr
	Declare Property Object(Index As Integer, FObj As Any Ptr)
	Declare Function Add(Item As String, FObj As Any Ptr = 0) As Integer
	Declare Function Insert(Index As Integer, FItem As String, FObj As Any Ptr = 0) As Integer
	Declare Sub Exchange(Index1 As Integer, Index2 As Integer)
	Declare Sub Remove(Index As Integer)
	Declare Sub Sort(iLeft As Integer = 0, iRight As Integer = 0)
	Declare Sub Clear
	Declare Function IndexOf(FItem As String, ByVal MatchCase As Boolean = False, ByVal MatchFullWords As Boolean = True, ByVal iStart As Integer = 0, ByRef ListItem As StringListItem Ptr = 0) As Integer
	Declare Function IndexOfObject(FObj As Any Ptr) As Integer
	Declare Function Contains(FItem As String, ByVal MatchCase As Boolean = False, ByVal MatchFullWords As Boolean = True, ByVal iStart As Integer = 0, ByRef Idx As Integer = -1, ByRef ListItem As StringListItem Ptr = 0) As Boolean
	Declare Function ContainsObject(FObj As Any Ptr) As Boolean
	Declare Function CountOf(ByRef FItem As String) As Integer
	Declare Sub SaveToFile(ByRef File As WString)
	Declare Sub LoadFromFile(ByRef File As WString)
	Declare Operator Let(ByRef Value As String)
	Declare Operator Cast As Any Ptr
	Declare Constructor
	Declare Destructor
	OnAdd      As Sub(ByRef Sender As StringList, FItem As String, FObj As Any Ptr = 0)
	OnInsert   As Sub(ByRef Sender As StringList, FIndex As Integer, ByRef FItem As WString, FObj As Any Ptr = 0)
	OnRemove   As Sub(ByRef Sender As StringList, FIndex As Integer)
	OnExchange As Sub(ByRef Sender As StringList, FIndex1 As Integer, FIndex2 As Integer)
	OnClear    As Sub(ByRef Sender As StringList)
	OnChange   As Sub(ByRef Sender As StringList)
End Type

#ifndef __USE_MAKE__
	#include once "StringList.bas"
#endif
