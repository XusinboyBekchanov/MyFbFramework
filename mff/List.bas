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
Operator List.Cast As Any Ptr
	Return @This
End Operator

Property List.Item(Index As Integer) As Any Ptr
	If Index >= 0 And Index <= Count -1 Then
		Return Items[Index]
	Else
		Return 0
	End If
End Property

Property List.Item(Index As Integer,FItem As Any Ptr)
	If Index >= 0 And Index <= Count -1 Then
		Items[Index] = FItem
	End If
End Property

Sub List.Add(FItem As Any Ptr)
	Count += 1
	Items = Reallocate(Items,Count*SizeOf(Any Ptr))
	Items[Count -1] = FItem
End Sub

Sub List.Insert(Index As Integer,FItem As Any Ptr)
	'David Change
	Dim As Integer i
	If Index >= 0 And Index <= Count -1 Then
		Count += 1
		Items = Reallocate(Items, Count*SizeOf(Any Ptr))
		For i = Count -1 To Index+1 Step -1
			Items[i] = Items[i-1]
		Next i
		Items[Index] = FItem
	ElseIf Index > Count -1 Then
		This.Add FItem
	End If
End Sub

Sub List.Exchange(Index1 As Integer,Index2 As Integer)
	Dim As Any Ptr P
	If ((Index1 >= 0 And Index1 <= Count -1) And (Index2 >= 0 And Index2 <= Count -1)) Then
		P = Items[Index1]
		Items[Index1] = Items[Index2]
		Items[Index2] = P
	End If
End Sub

Sub List.Remove(Index As Integer)
	'David Change
	Dim As Integer i
	If Count>0 AndAlso Index >= 0 AndAlso Index <= Count -1 Then
		Count -= 1
		For i = Index To Count -1
			Items[i] = Items[i+1]
		Next i
		Items = Reallocate(Items,Count*SizeOf(Any Ptr))
	End If
End Sub

Sub List.Clear
	Count = 0
	If Items <> 0 Then Deallocate Items
	Items = 0
	Items = CAllocate(Count)
End Sub

Function List.IndexOf(FItem As Any Ptr) As Integer
	Dim i As Integer
	For i = 0 To Count -1
		If Items[i] = FItem Then Return i
	Next i
	Return -1
End Function

Function List.Contains(FItem As Any Ptr) As Boolean
	Return IndexOf(FItem) <> -1
End Function

Constructor List
	Items = CAllocate(0)
	Count = 0
End Constructor

Destructor List
	Deallocate Items
	Items = 0
End Destructor
