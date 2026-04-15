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
Public:
	Declare Function Count As Integer
	Declare Property Item(Index As Integer) As Any Ptr
	Declare Property Item(Index As Integer, Value As Any Ptr)
	Declare Property Object(Index As Integer) As Any Ptr
	Declare Property Object(Index As Integer, Value As Any Ptr)
	Declare Sub Add(_Item As Any Ptr, Obj As Any Ptr = 0)
	Declare Sub Insert(Index As Integer, _Item As Any Ptr, Obj As Any Ptr = 0)
	Declare Sub Exchange(Index1 As Integer, Index2 As Integer)
	Declare Sub Remove(Index As Integer)
	Declare Function Get(_Item As Any Ptr, Obj As Any Ptr = 0) As Any Ptr
	Declare Sub Set(_Item As Any Ptr, Obj As Any Ptr)
	Declare Sub Clear
	Declare Function IndexOf(Item As Any Ptr) As Integer
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
