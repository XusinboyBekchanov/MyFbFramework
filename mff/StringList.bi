'###############################################################################
'#  StatusBar.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor                                                     #
'#  Based on:                                                                  #
'#   TStringList.bi                                                            #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'###############################################################################

#include once "ListItems.bi"

#define QStringList(__Ptr__) *Cast(StringList Ptr,__Ptr__)

Type StringList
Private:
	FText   As String
Public:
	'Control As My.Sys.Forms.Control Ptr
	Items   As ListItems
	Declare Property Count As Integer
	Declare Property Count(Value As Integer)
	Declare Property Text As String
	Declare Property Text(Value As String)
	Declare Property Item(Index As Integer) As String
	Declare Property Item(Index As Integer, FItem As String)
	Declare Property Object(Index As Integer) As Any Ptr
	Declare Property Object(Index As Integer, FObj As Any Ptr)
	Declare Sub Add(Item As String, FObj As Any Ptr = 0)
	Declare Sub Insert(Index As Integer, FItem As String, FObj As Any Ptr = 0)
	Declare Sub Exchange(Index1 As Integer, Index2 As Integer)
	Declare Sub Remove(Index As Integer)
	Declare Sub Sort
	Declare Sub Clear
	Declare Function IndexOf(FItem As String) As Integer
	Declare Function IndexOfObject(FObj As Any Ptr) As Integer
	Declare Function Contains(FItem As String) As Boolean
	Declare Sub SaveToFile(ByRef File As WString)
	Declare Sub LoadFromFile(ByRef File As WString)
	Declare Operator Cast As Any Ptr
	Declare Constructor
	Declare Destructor
	OnAdd      As Sub(BYREF Sender As StringList, FItem As String, FObj As Any Ptr = 0)
	OnInsert   As Sub(BYREF Sender As StringList, FIndex As Integer, ByRef FItem As WString, FObj As Any Ptr = 0)
	OnRemove   As Sub(BYREF Sender As StringList, FIndex As Integer)
	OnExchange As Sub(BYREF Sender As StringList, FIndex1 As Integer, FIndex2 As Integer)
	OnClear    As Sub(BYREF Sender As StringList)
End Type

#IfNDef __USE_MAKE__
	#Include Once "StringList.bas"
#EndIf
