'###############################################################################
'#  DoubleList.bi                                                             #
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

#define QDoubleListItem(__Ptr__) (*Cast(DoubleListItem Ptr,__Ptr__))
#define QDoubleList(__Ptr__) (*Cast(DoubleList Ptr,__Ptr__))

Private Type DoubleListItem Extends Object
Private:
	FValue   As Double
Public:
	Declare Property Value As Double
	Declare Property Value(V As Double)
	Object  As Any Ptr
	Declare Operator Cast As Any Ptr
	Declare Operator Cast As String
	Declare Operator Let(V As Any Ptr)
	Declare Operator Let(V As Double)
	Declare Constructor
	Declare Destructor
End Type

'Represents a list of doubles that can be accessed by index. Provides methods to search, sort, and manipulate lists (Windows, Linux, Android, Web).
Private Type DoubleList Extends Object
Private:
	FCount   As Integer
	FItems   As List
	FSorted  As Boolean
Public:
	Declare Property Count As Integer
	Declare Property Count(Value As Integer)
	Declare Property Item(Index As Integer) As Double
	Declare Property Item(Index As Integer, iValue As Double)
	Declare Property Object(Index As Integer) As Any Ptr
	Declare Property Object(Index As Integer, Obj As Any Ptr)
	Declare Property Sorted As Boolean 
	Declare Property Sorted(iValue As Boolean)
	Declare Function Add(iValue As Double, Obj As Any Ptr = 0) As Integer
	Declare Function Insert(Index As Integer, iValue As Double, Obj As Any Ptr = 0) As Integer
	Declare Sub Exchange(Index1 As Integer, Index2 As Integer)
	Declare Sub Remove(Index As Integer)
	Declare Sub Sort(ByVal iDirection As Long = 1)
	Declare Sub Clear
	Declare Function IndexOf(iValue As Double) As Integer
	Declare Function IndexOfObject(Obj As Any Ptr) As Integer
	Declare Function Contains(iValue As Double) As Boolean
	Declare Operator Cast As Any Ptr
	Declare Constructor
	Declare Destructor
End Type

#ifndef __USE_MAKE__
	#include once "DoubleList.bas"
#endif