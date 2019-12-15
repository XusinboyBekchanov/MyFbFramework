'###############################################################################
'#  WStringList.bi                                                             #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TStringList.bi                                                            #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Adapted to WString by Xusinboy Bekchanov (2018-2019)                       #
'###############################################################################

#Include Once "List.bi"
#Include Once "SysUtils.bi"

#DEFINE QWStringListItem(__Ptr__) *Cast(WStringListItem Ptr,__Ptr__)
#DEFINE QWStringList(__Ptr__) *Cast(WStringList Ptr,__Ptr__)

Type WStringListItem Extends Object
    Private:
		FValue   As WString Ptr
    Public:
		Declare Property Value ByRef As WString
		Declare Property Value(ByRef V As WString)
		Object  As Any Ptr
		Declare Operator Cast As Any Ptr
		Declare Operator Cast As String
		Declare Operator Let(V As Any Ptr)
		Declare Operator Let(ByRef V As WString)
		Declare Constructor
		Declare Destructor
End Type

Type WStringList Extends Object
    Private:
		FCount   As Integer
		FText    As WString Ptr
		FItems   As List
    Public:
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Property Item(Index As Integer) ByRef As WString
		Declare Property Item(Index As Integer, ByRef FItem As WString)
		Declare Property Object(Index As Integer) As Any Ptr
		Declare Property Object(Index As Integer, FObj As Any Ptr)
		Declare Sub Add(ByRef Item As WString, FObj As Any Ptr = 0)
		Declare Sub Insert(Index As Integer, ByRef FItem As WString, FObj As Any Ptr = 0)
		Declare Sub Exchange(Index1 As Integer, Index2 As Integer)
		Declare Sub Remove(Index As Integer)
		Declare Sub Sort
		Declare Sub Clear
		Declare Function IndexOf(ByRef FItem As WString) As Integer
		Declare Function IndexOfObject(FObj As Any Ptr) As Integer
		Declare Function Contains(ByRef FItem As WString) As Boolean
		Declare Sub SaveToFile(ByRef File As WString)
		Declare Sub LoadFromFile(ByRef File As WString)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		OnAdd      As Sub(BYREF Sender As WStringList, ByRef FItem As WString, FObj As Any Ptr = 0)
		OnInsert   As Sub(BYREF Sender As WStringList, FIndex As Integer, ByRef FItem As WString, FObj As Any Ptr = 0)
		OnRemove   As Sub(BYREF Sender As WStringList, FIndex As Integer)
		OnExchange As Sub(BYREF Sender As WStringList, FIndex1 As Integer, FIndex2 As Integer)
		OnClear    As Sub(BYREF Sender As WStringList)
End Type

#IfNDef __USE_MAKE__
	#Include Once "WStringList.bas"
#EndIf
