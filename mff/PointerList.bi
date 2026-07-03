'###############################################################################
'#  PointerList.bi                                                             #
'#  This file is part of MyFBFramework                                     #
'#  Version 1.0.0                                                              #
'###############################################################################

#include once "List.bi"

#define QPointerListItem(__Ptr__) (*Cast(PointerListItem Ptr,__Ptr__))
#define QPointerList(__Ptr__) (*Cast(PointerList Ptr,__Ptr__))

Private Type PointerListItem Extends Object
    Value As Any Ptr
    Object As Any Ptr
End Type

'Represents a list of pointers that can be accessed by index. Provides methods to search, sort, and manipulate lists (Windows, Linux, Android, Web).
Private Type PointerList Extends Object
	Private:
	FCount   As Integer
	FItems   As List
	FSorted  As Boolean
Public:
	Declare Function Count As Integer
	Declare Property Item(Index As Integer) As Any Ptr
	Declare Property Item(Index As Integer, Value As Any Ptr)
	Declare Property Object(Index As Integer) As Any Ptr
	Declare Property Object(Index As Integer, Value As Any Ptr)
	Declare Property Sorted As Boolean 
	Declare Property Sorted(iValue As Boolean)
	Declare Function Add(iValue As Any Ptr, Obj As Any Ptr = 0) As Integer
	Declare Function Insert(Index As Integer, iValue As Any Ptr, Obj As Any Ptr = 0) As Integer
	Declare Sub Exchange(Index1 As Integer, Index2 As Integer)
	Declare Sub Remove(Index As Integer)
	'iDirection: SORT_ASCENDING (1) 为升序(默认), SORT_DESCENDING (-1) 为降序
	Declare Sub Sort(ByVal iDirection As Long = 1)
	Declare Function Get(iValue As Any Ptr, Obj As Any Ptr = 0) As Any Ptr
	Declare Sub Set(iValue As Any Ptr, Obj As Any Ptr)
	Declare Sub Clear
	Declare Function IndexOf(iValue As Any Ptr) As Integer
	Declare Function IndexOfObject(Obj As Any Ptr) As Integer
	Declare Function Contains(Item As Any Ptr, ByRef Idx As Integer = -1) As Boolean
	Declare Function ContainsObject(Obj As Any Ptr) As Boolean
	Declare Operator Cast As Any Ptr
	Declare Operator [](Index As Integer) As Any Ptr
	Declare Constructor
	Declare Destructor
End Type

#ifndef __USE_MAKE__
	#include once "PointerList.bas"
#endif