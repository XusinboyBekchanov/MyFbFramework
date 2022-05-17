'###############################################################################
'#  WStringList.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                      #
'#  Based on:                                                                  #
'#   TStringList.bi                                                            #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Adapted to WString by Xusinboy Bekchanov(2018-2019)  Liu XiaLin            #
'###############################################################################

#include once "List.bi"

#define QWStringListItem(__Ptr__) *Cast(WStringListItem Ptr,__Ptr__)
#define QWStringList(__Ptr__) *Cast(WStringList Ptr,__Ptr__)

Private Type WStringList
Private:
	FText               As WString Ptr
	FMatchCase          As Boolean
	FMatchFullWords     As Boolean
	FSorted             As Boolean
	FCount              As Integer
	Items               As List
	Objects             As List
Public:
	Tag As Any Ptr
	Declare Property Count As Integer
	Declare Property Count(iValue As Integer)
	Declare Property Item(Index As Integer) ByRef As WString
	Declare Property Item(Index As Integer, iValue As Const WString)
	Declare Property MatchCase As Boolean 
	Declare Property MatchCase(iValue As Boolean)
	Declare Property MatchFullWords As Boolean 
	Declare Property MatchFullWords(iValue As Boolean)
	Declare Property Sorted As Boolean 
	Declare Property Sorted(iValue As Boolean)
	Declare Property Text ByRef As WString
	Declare Property Text(ByRef Value As WString)
	Declare Property Object(Index As Integer) As Any Ptr
	Declare Property Object(Index As Integer, FObj As Any Ptr)
	Declare Function Add(ByRef iValue As Const WString, FObj As Any Ptr = 0) As Integer
	Declare Function Insert(ByVal Index As Integer, ByRef iValue As Const WString, FObj As Any Ptr = 0) As Integer 
	Declare Sub Exchange(Index1 As Integer, Index2 As Integer)
	Declare Sub Remove(Index As Integer)
	Declare Sub Sort(iLeft As Integer = 0, iRight As Integer = 0)
	Declare Sub Clear
	Declare Function IndexOf(ByRef iValue As Const WString, ByVal MatchCase As Boolean = False, ByVal MatchFullWords As Boolean = True, ByVal iStart As Integer = 0) As Integer
	Declare Function IndexOfObject(FObj As Any Ptr) As Integer
	Declare Function Contains(ByRef iValue As Const WString, ByVal MatchCase As Boolean = False, ByVal MatchFullWords As Boolean = True, ByVal iStart As Integer = 0) As Boolean
	Declare Function ContainsObject(FObj As Any Ptr) As Boolean
	Declare Function CountOf(ByRef FItem As WString) As Integer
	Declare Sub SaveToFile(ByRef FileName As WString)
	Declare Sub LoadFromFile(ByRef FileName As WString)
	Declare Operator Let(ByRef Value As WString)
	Declare Operator Cast As Any Ptr
	Declare Constructor
	Declare Destructor
	OnAdd      As Sub(ByRef Sender As WStringList, iValue As Const WString, FObj As Any Ptr = 0)
	OnInsert   As Sub(ByRef Sender As WStringList, Index As Integer, ByRef iValue As Const WString, FObj As Any Ptr = 0)
	OnRemove   As Sub(ByRef Sender As WStringList, Index As Integer)
	OnExchange As Sub(ByRef Sender As WStringList, Index1 As Integer, Index2 As Integer)
	OnClear    As Sub(ByRef Sender As WStringList)
	OnChange   As Sub(ByRef Sender As WStringList)
End Type

#ifndef __USE_MAKE__
	#include once "WStringList.bas"
#endif
 
