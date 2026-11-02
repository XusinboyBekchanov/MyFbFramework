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

#ifdef __FB_WIN32__
	#include once "UString.bi"
#else
	#include once "SysUtils.bi"
#endif

#define QList(__Ptr__) (*Cast(List Ptr,__Ptr__))

'Represents a list of objects that can be accessed by index. Provides methods to search, sort, and manipulate lists (Windows, Linux, Android, Web).
Private Type List
Private:
	m_Count As Integer = 0
    m_Capacity As Integer = 0
    Declare Sub EnsureCapacity(NewSize As Integer)
Public:
	Items As Any Ptr Ptr = 0
	Declare Property Count() As Integer
	Declare Property Item(Index As Integer) As Any Ptr
	Declare Property Item(Index As Integer, FItem As Any Ptr)
	Declare Sub Add(FItem As Any Ptr)
	Declare Sub ChangeIndex(FItem As Any Ptr, Index As Integer)
	Declare Sub Insert(Index As Integer, FItem As Any Ptr)
	Declare Sub Exchange(Index1 As Integer, Index2 As Integer)
	Declare Sub Remove(Index As Integer)
	Declare Sub Clear
	Declare Function IndexOf(FItem As Any Ptr) As Integer
	Declare Function Contains(FItem As Any Ptr, ByRef Idx As Integer = -1) As Boolean
	' --- 排序辅助: 让各类 List 复用同一套算法 ---
	' 基数排序: keyOf 把元素映射成"保持顺序的 8 字节无符号键", 与比较完全无关。
	'   有符号整数: 值 Xor 符号位; 浮点: IEEE754 保序变换(负数取反/非负翻符号位)。
	Declare Sub SortByKey(ByVal keyOf As Function(ByVal item As Any Ptr) As ULongInt, ByVal iDirection As Long = 1)
	' TimSort: cmp(a, b, ctx) 返回 -1/0/1。稳定, 最坏 O(n log n), 近似有序输入接近 O(n)。
	Declare Sub SortByCompare(ByVal cmp As Function(ByVal a As Any Ptr, ByVal b As Any Ptr, ByVal ctx As Any Ptr) As Long, ByVal iDirection As Long = 1, ByVal ctx As Any Ptr = 0)
	Declare Operator Cast As Any Ptr
	Declare Constructor
	Declare Constructor(ByRef Rhs As List)
	Declare Operator Let(ByRef Rhs As List)
	Declare Destructor
End Type

' 对索引数组做 TimSort: cmp(行号a, 行号b, ctx) 比较两个"行", idx 由本函数初始化为 0..n-1。
' 排完后由调用方按 idx 重排数据 —— 适合"交换整行代价高"的二维结构(如 Grid)。
' 稳定, 最坏 O(n log n), 近似有序输入接近 O(n)。
Declare Sub TimSortIndex(ByVal idx As Long Ptr, ByVal n As Long, _
                         ByVal cmp As Function(ByVal a As Long, ByVal b As Long, ByVal ctx As Any Ptr) As Long, _
                         ByVal iDirection As Long = 1, ByVal ctx As Any Ptr = 0)

#ifndef __USE_MAKE__
	#include once "List.bas"
#endif
