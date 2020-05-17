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

#Include Once "List.bi"

#DEFINE QIntegerListItem(__Ptr__) *Cast(IntegerListItem Ptr,__Ptr__)
#DEFINE QIntegerList(__Ptr__) *Cast(IntegerList Ptr,__Ptr__)

Type IntegerListItem Extends Object
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

Type IntegerList Extends Object
Private:
	FCount   As Integer
	FItems   As List
Public:
	Declare Property Count As Integer
	Declare Property Count(Value As Integer)
	Declare Property Item(Index As Integer) As Integer
	Declare Property Item(Index As Integer, FItem As Integer)
	Declare Property Object(Index As Integer) As Any Ptr
	Declare Property Object(Index As Integer, FObj As Any Ptr)
	Declare Sub Add(Item As Integer, FObj As Any Ptr = 0)
	Declare Sub Insert(Index As Integer, FItem As Integer, FObj As Any Ptr = 0)
	Declare Sub Exchange(Index1 As Integer, Index2 As Integer)
	Declare Sub Remove(Index As Integer)
	Declare Sub Sort
	Declare Sub Clear
	Declare Function IndexOf(FItem As Integer) As Integer
	Declare Function IndexOfObject(FObj As Any Ptr) As Integer
	Declare Function Contains(FItem As Integer) As Boolean
	Declare Operator Cast As Any Ptr
	Declare Constructor
	Declare Destructor
End Type

#IfNDef __USE_MAKE__
	#Include Once "IntegerList.bas"
#EndIf
