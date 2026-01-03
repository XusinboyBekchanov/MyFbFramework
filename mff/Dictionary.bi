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

#define QDictionaryItem(__Ptr__) (*Cast(DictionaryItem Ptr,__Ptr__))
#define QDictionary(__Ptr__) (*Cast(Dictionary Ptr,__Ptr__))

Private Type DictionaryItem
Private:
	FKey            As WString Ptr
	FText           As WString Ptr
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

'Represents a collection of keys and values (Windows, Linux, Android, Web).
Private Type Dictionary
Private:
	FCount             As Integer
	FText              As WString Ptr
	FItems             As List
	FSortKeysMatchCase  As Boolean 
	FSortMatchCase      As Boolean 
Public:
	Tag                As Any Ptr
	Sorted            As Boolean 
	SortKeysed      As Boolean
	Declare Property Count As Integer
	Declare Property Count(value As Integer)
	Declare Property Item(Index As Integer) As DictionaryItem Ptr
	Declare Property Item(Index As Integer, iItem As DictionaryItem Ptr)
	Declare Property Item(ByRef iKey As WString) As DictionaryItem Ptr
	Declare Property Item(ByRef iKey As WString, iItem As DictionaryItem Ptr)
	Declare Property Text ByRef As WString
	Declare Property Text(ByRef value As WString)
	Declare Sub Add(ByRef iKey As WString = "", ByRef wText As WString = "", iObject As Any Ptr = 0)
	Declare Sub Insert(Index As Integer, ByRef iKey As WString = "", ByRef wText As WString = "", iObject As Any Ptr = 0)
	Declare Sub Remove(Index As Integer)
	Declare Sub Remove(ByRef iKey As WString)
	Declare Sub Exchange(Index1 As Integer, Index2 As Integer)
	Declare Sub Sort(MatchCase As Boolean = False, ileft As Integer = 0, iRight As Integer = 0)
	Declare Sub SortKeys(MatchCase As Boolean = False, ileft As Integer = 0, iRight As Integer = 0)
	Declare Sub Clear
	Declare Function IndexOf(ByRef wText As Const WString, ByVal MatchCase As Boolean = False, ByVal MatchFullWords As Boolean = True, ByVal iStart As Integer = 0) As Integer
	Declare Function IndexOfKey(ByRef iKey As Const WString, iObject As Any Ptr = 0, ByVal MatchCase As Boolean = False) As Integer
	Declare Function IndexOfObject(iObject As Any Ptr) As Integer
	Declare Sub Set(ByRef iKey As WString, ByRef wText As WString = "", iObject As Any Ptr = 0)
	Declare Function Get(ByRef iKey As WString, ByRef DefaultText As WString = "") ByRef As WString
	Declare Function Get(Index As Integer, ByRef DefaultText As WString = "") ByRef As WString
	Declare Function GetKey(ByRef wText As WString, ByVal MatchCase As Boolean = False) ByRef As WString
	Declare Function GetKey(iObject As Any Ptr) ByRef As WString
	Declare Function GetText(ByRef iKey As WString, ByVal MatchCase As Boolean = False) ByRef As WString
	Declare Function GetObject(ByRef iKey As WString, ByVal MatchCase As Boolean = False) As Any Ptr
	Declare Function GetObject(Index As Integer) As Any Ptr
	Declare Function Contains(ByRef wText As WString, ByVal MatchCase As Boolean = False) As Boolean
	Declare Function ContainsKey(ByRef iKey As WString, iObject As Any Ptr = 0, ByVal MatchCase As Boolean = False) As Boolean
	Declare Function ContainsObject(iObject As Any Ptr) As Boolean
	Declare Sub SaveToFile(ByRef FileName As WString)
	Declare Sub LoadFromFile(ByRef FileName As WString)
	Declare Operator Let(ByRef value As WString)
	Declare Operator Cast As Any Ptr
	Declare Operator [](ByRef iKey As WString) ByRef As WString
	Declare Constructor
	Declare Destructor
	OnChange   As Sub(ByRef Sender As Dictionary)
End Type

#ifndef __USE_MAKE__
	#include once "Dictionary.bas"
#endif
 
