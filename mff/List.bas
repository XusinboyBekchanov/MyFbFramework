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
Private Operator List.Cast As Any Ptr
	Return @This
End Operator

Private Property List.Item(Index As Integer) As Any Ptr
	If Index >= 0 And Index <= Count -1 Then
		Return Items[Index]
	Else
		Return 0
	End If
End Property

Private Property List.Item(Index As Integer, FItem As Any Ptr)
	If Index >= 0 And Index <= Count -1 Then
		Items[Index] = FItem
	End If
End Property

Private Sub List.Add(FItem As Any Ptr)
	Items = Reallocate_(Items, (Count + 1) * SizeOf(Any Ptr))
	Items[Count] = FItem
	Count += 1
End Sub

Private Sub List.Insert(Index As Integer, FItem As Any Ptr)
	'David Change
	Dim As Integer i
	If Index >= 0 And Index <= Count -1 Then
		Count += 1
		Items = Reallocate_(Items, Count*SizeOf(Any Ptr))
		For i = Count -1 To Index+1 Step -1
			Items[i] = Items[i-1]
		Next i
		Items[Index] = FItem
	ElseIf Index > Count -1 Then
		This.Add FItem
	End If
End Sub

Private Sub List.Exchange(Index1 As Integer, Index2 As Integer)
	Dim As Any Ptr P
	If ((Index1 >= 0 And Index1 <= Count -1) And (Index2 >= 0 And Index2 <= Count -1)) Then
		P = Items[Index1]
		Items[Index1] = Items[Index2]
		Items[Index2] = P
	End If
End Sub

Private Sub List.ChangeIndex(FItem As Any Ptr, Index As Integer)
	Dim OldIndex As Integer = This.IndexOf(FItem)
	If OldIndex > -1 AndAlso OldIndex <> Index AndAlso Index <= Count - 1 Then
		If Index < OldIndex Then
			For i As Integer = OldIndex - 1 To Index Step -1
				Items[i + 1] = Items[i]
			Next i
			Items[Index] = FItem
		Else
			For i As Integer = OldIndex + 1 To Index
				Items[i - 1] = Items[i]
			Next i
			Items[Index] = FItem
		End If
	End If
End Sub

Private Sub List.Remove(Index As Integer)
	'David Change
	Dim As Integer i
	If Count>0 AndAlso Index >= 0 AndAlso Index <= Count -1 Then
		Count -= 1
		If Count = 0 Then
			Deallocate_(Items)
			Items = 0
		Else
			For i = Index To Count -1
				Items[i] = Items[i+1]
			Next i
			Items = Reallocate_(Items,Count*SizeOf(Any Ptr))
		End If
	End If
End Sub

Private Sub List.Clear
	Count = 0
	If Items <> 0 Then Deallocate_(Items)
	Items = 0
	Items = 0' CAllocate_(Count)
End Sub

Private Function List.IndexOf(FItem As Any Ptr) As Integer
	Dim i As Integer
	For i = 0 To Count -1
		If Items[i] = FItem Then Return i
	Next i
	Return -1
End Function

Private Function List.Contains(FItem As Any Ptr, ByRef Idx As Integer = -1) As Boolean
	Idx = IndexOf(FItem)
	Return Idx <> -1
End Function

Private Constructor List
	Items = 0 'CAllocate_(0)
	Count = 0
End Constructor

Private Destructor List
	If Items <> 0 Then Deallocate_(Items)
	Items = 0
End Destructor
