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

#include once "List.bi"

'List

Private Sub List.EnsureCapacity(NewSize As Integer)
	If NewSize > m_Capacity Then
		Dim As Integer NewCapacity = IIf(m_Capacity = 0, 4, m_Capacity * 2)
		If NewCapacity < NewSize Then NewCapacity = NewSize
		Items = _Reallocate(Items, NewCapacity * SizeOf(Any Ptr))
		m_Capacity = NewCapacity
	End If
End Sub
Private Property List.Count() As Integer
	Return m_Count
End Property

Private Operator List.Cast As Any Ptr
	Return @This
End Operator

Private Property List.Item(Index As Integer) As Any Ptr
	If Index >= 0 AndAlso Index < m_Count Then
		Return Items[Index]
	End If
	Return 0
End Property

#ifndef List_Item_Set_Off
	Private Property List.Item(Index As Integer, FItem As Any Ptr)
		If Index >= 0 AndAlso Index < m_Count Then
			Items[Index] = FItem
		End If
	End Property
#endif

Private Sub List.Add(FItem As Any Ptr)
	EnsureCapacity(m_Count + 1)
	Items[m_Count] = FItem
	m_Count += 1
End Sub

Private Sub List.Insert(Index As Integer, FItem As Any Ptr)
	If Index < 0 Or Index > m_Count Then Index = m_Count
	EnsureCapacity(m_Count + 1)
	If Index < m_Count Then
		Fb_MemMove(Items[Index + 1], Items[Index], (m_Count - Index) * SizeOf(Any Ptr))
	End If
	Items[Index] = FItem
	m_Count += 1
End Sub

Private Sub List.Exchange(Index1 As Integer, Index2 As Integer)
	If Index1 >= 0 AndAlso Index1 < m_Count AndAlso Index2 >= 0 AndAlso Index2 < m_Count AndAlso Index1 <> Index2 Then
		Swap Items[Index1], Items[Index2]
	End If
End Sub

Private Sub List.ChangeIndex(FItem As Any Ptr, Index As Integer)
	Dim As Integer OldIndex = IndexOf(FItem)
	If OldIndex = -1 OrElse Index < 0 OrElse Index >= m_Count Then Exit Sub
	
	If Index < OldIndex Then
		Fb_MemMove(Items[Index + 1], Items[Index], (OldIndex - Index) * SizeOf(Any Ptr))
	ElseIf Index > OldIndex Then
		Fb_MemMove(Items[OldIndex], Items[OldIndex + 1], (Index - OldIndex) * SizeOf(Any Ptr))
	End If
	Items[Index] = FItem
End Sub

Private Sub List.Remove(Index As Integer)
	If Index < 0 OrElse Index >= m_Count Then Exit Sub
	
	m_Count -= 1
	If Index < m_Count Then
		Fb_MemMove(Items[Index], Items[Index + 1], (m_Count - Index) * SizeOf(Any Ptr))
	End If
	
	' Optional: Shrink capacity when needed
	If m_Capacity > 8 AndAlso m_Count < m_Capacity \ 2 Then
		m_Capacity = m_Capacity \ 2
		Items = _Reallocate(Items, m_Capacity * SizeOf(Any Ptr))
	End If
End Sub

Private Sub List.Clear
	m_Count = 0
	m_Capacity = 0
	If Items Then _Deallocate(Items)
	Items = 0
End Sub

Private Function List.IndexOf(FItem As Any Ptr) As Integer
	For i As Integer = 0 To m_Count - 1
		If Items[i] = FItem Then Return i
	Next
	Return -1
End Function

Private Function List.Contains(FItem As Any Ptr, ByRef Idx As Integer = -1) As Boolean
	Idx = IndexOf(FItem)
	Return Idx <> -1
End Function

Private Constructor List
	m_Count = 0
	m_Capacity = 0
End Constructor

Private Destructor List
	m_Count = 0
	m_Capacity = 0
	If Items Then _Deallocate(Items)
	Items = 0
End Destructor
