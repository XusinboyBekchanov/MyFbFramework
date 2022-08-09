'******************************************************************************
'* List                                                                       *
'* This file is part of MyFBFramework                                         *
'* Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     *
'* Based on:                                                                  *
'*  TList                                                                     *
'*  FreeBasic Windows GUI ToolKit                                             *
'*  Copyright (c) 2007-2008 Nastase Eodor                                     *
'*  Version 1.0.0                                                             *
'*  nastase_eodor@yahoo.com                                                   *
'*  Modified by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                     *
'******************************************************************************

#include once "SysUtils.bi"

#define QList(__Ptr__) *Cast(List Ptr,__Ptr__)

Private Type List
Private:
Public:
	Count As Integer = 0
	Items As Any Ptr Ptr
	Declare Property Item(Index As Integer) As Any Ptr
	Declare Property Item(Index As Integer, FItem As Any Ptr)
	Declare Sub Add(FItem As Any Ptr)
	Declare Sub Insert(Index As Integer, FItem As Any Ptr)
	Declare Sub Exchange(Index1 As Integer, Index2 As Integer)
	Declare Sub Remove(Index As Integer)
	Declare Sub Clear
	Declare Function IndexOf(FItem As Any Ptr) As Integer
	Declare Function Contains(FItem As Any Ptr, ByRef Idx As Integer = -1) As Boolean
	Declare Operator Cast As Any Ptr
	Declare Constructor
	Declare Destructor
End Type

#ifndef __USE_MAKE__
	#include once "List.bas"
#endif
