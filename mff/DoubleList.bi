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

#define QDoubleListItem(__Ptr__) *Cast(DoubleListItem Ptr,__Ptr__)
#define QDoubleList(__Ptr__) *Cast(DoubleList Ptr,__Ptr__)

Private Type DoubleListItem Extends Object
Private:
	FValue   As Integer
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

Private Type DoubleList Extends Object
Private:
	FCount   As Integer
	FItems   As List
Public:
	Declare Property Count As Integer
	Declare Property Count(Value As Integer)
	Declare Property Item(Index As Integer) As Double
	Declare Property Item(Index As Integer, FItem As Double)
	Declare Property Object(Index As Integer) As Any Ptr
	Declare Property Object(Index As Integer, FObj As Any Ptr)
	Declare Sub Add(Item As Double, FObj As Any Ptr = 0)
	Declare Sub Insert(Index As Integer, FItem As Double, FObj As Any Ptr = 0)
	Declare Sub Exchange(Index1 As Integer, Index2 As Integer)
	Declare Sub Remove(Index As Integer)
	Declare Sub Sort
	Declare Sub Clear
	Declare Function IndexOf(FItem As Double) As Integer
	Declare Function IndexOfObject(FObj As Any Ptr) As Integer
	Declare Function Contains(FItem As Double) As Boolean
	Declare Operator Cast As Any Ptr
	Declare Constructor
	Declare Destructor
End Type

#ifndef __USE_MAKE__
	#include once "DoubleList.bas"
#endif
