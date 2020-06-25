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

#include once "WStringList.bi"
'#include once "Control.bi"

#define QListItems(__Ptr__) *Cast(ListItems Ptr,__Ptr__)

Type ListItems Extends Object
Private:
	FItems As WStringList
Public:
	'Parent   As My.Sys.Forms.Control Ptr
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

#ifndef __USE_MAKE__
	#include once "ListItems.bas"
#endif
