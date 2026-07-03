'###############################################################################
'#  IntegerList.bi                                                             #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TStringList.bi                                                            #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Adapted to Integer by Xusinboy Bekchanov (2018-2019)                       #
'###############################################################################

#include once "List.bi"

#define QIntegerListItem(__Ptr__) (*Cast(IntegerListItem Ptr,__Ptr__))
#define QIntegerList(__Ptr__) (*Cast(IntegerList Ptr,__Ptr__))

Private Type IntegerListItem Extends Object
Private:
	FValue   As Integer
Public:
	Declare Property Value As Integer
	Declare Property Value(V As Integer)
	Object  As Any Ptr
	Declare Operator Cast As Any Ptr
	Declare Operator Cast As String
	Declare Operator Let(V As Any Ptr)
	Declare Operator Let(V As Integer)
	Declare Constructor
	Declare Destructor
End Type

'Represents a list of integers that can be accessed by index. Provides methods to search, sort, and manipulate lists (Windows, Linux, Android, Web).
Private Type IntegerList Extends Object
Private:
	FCount   As Integer
	FSorted  As Boolean
	FItems   As List
Public:
	Declare Property Count As Integer
	Declare Property Count(Value As Integer)
	Declare Property Item(Index As Integer) As Integer
	Declare Property Item(Index As Integer, iValue As Integer)
	Declare Property Object(Index As Integer) As Any Ptr
	Declare Property Object(Index As Integer, Obj As Any Ptr)
	Declare Property Sorted As Boolean 
	Declare Property Sorted(iValue As Boolean)
	Declare Function Add(iValue As Integer, Obj As Any Ptr = 0) As Integer
	Declare Function Insert(Index As Integer, iValue As Integer, Obj As Any Ptr = 0) As Integer
	Declare Sub Exchange(Index1 As Integer, Index2 As Integer)
	Declare Sub Remove(Index As Integer)
	Declare Function Get(iValue As Integer, Obj As Any Ptr = 0) As Any Ptr
	Declare Sub Set(iValue As Integer, Obj As Any Ptr)
	Declare Sub Sort(ByVal iDirection As Long = 1)
	Declare Sub Clear
	Declare Function IndexOf(iValue As Integer) As Integer
	Declare Function IndexOfObject(Obj As Any Ptr) As Integer
	Declare Function Contains(iValue As Integer) As Boolean
	Declare Operator Cast As Any Ptr
	Declare Operator [](Index As Integer) As Integer
	Declare Constructor
	Declare Destructor
End Type

#ifndef __USE_MAKE__
	#include once "IntegerList.bas"
#endif