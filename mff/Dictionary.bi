'###############################################################################
'#  Dictionary.bi                                                              #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TStringList.bi                                                            #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.2.2                                                             #
'#  Adapted to Dictionary by Xusinboy Bekchanov(2018-2019)  Liu XiaLin         #
'###############################################################################

#include once "List.bi"
#include once "SysUtils.bi"

#define QDictionaryItem(__Ptr__) *Cast(DictionaryItem Ptr,__Ptr__)
#define QDictionary(__Ptr__) *Cast(Dictionary Ptr,__Ptr__)

Type DictionaryItem Extends Object
Private:
	FKey   As WString Ptr
	FText    As WString Ptr
Public:
	Declare Property Key ByRef As WString
	Declare Property Key(ByRef V As WString)
	Declare Property Text ByRef As WString
	Declare Property Text(ByRef V As WString)
	Object As Any Ptr
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
	Declare Sub Add(ByRef Key As WString = "", ByRef Text As WString = "", Object As Any Ptr = 0)
	Declare Sub Insert(Index As Integer, ByRef Key As WString = "", ByRef Text As WString = "", Object As Any Ptr = 0)
	Declare Sub Remove(Index As Integer)
	Declare Sub Remove(ByRef Key As WString)
	Declare Sub Exchange(Index1 As Integer, Index2 As Integer)
	Declare Sub Sort
	Declare Sub SortKeys
	Declare Sub Clear
	Declare Function IndexOf(ByRef Text As WString) As Integer
	Declare Function IndexOfKey(ByRef Key As WString) As Integer
	Declare Function IndexOfObject(FObj As Any Ptr) As Integer
	Declare Sub Set(ByRef Key As WString, ByRef Text As WString = "", Object As Any Ptr = 0)
	Declare Function Get(ByRef Key As WString, ByRef DefaultText As WString = "") ByRef As WString
	Declare Function GetKey(ByRef Text As WString) ByRef As WString
	Declare Function GetKey(Object As Any Ptr) ByRef As WString
	Declare Function GetText(ByRef Key As WString) ByRef As WString
	Declare Function GetObject(ByRef Key As WString) As Any Ptr
	Declare Function Contains(ByRef Text As WString) As Boolean
	Declare Function ContainsKey(ByRef Key As WString) As Boolean
	Declare Function ContainsObject(Object As Any Ptr) As Boolean
	Declare Sub SaveToFile(ByRef FileName As WString)
	Declare Sub LoadFromFile(ByRef FileName As WString)
	Declare Operator Cast As Any Ptr
	Declare Constructor
	Declare Destructor
End Type

#ifndef __USE_MAKE__
	#include once "Dictionary.bas"
#endif
