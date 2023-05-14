'###############################################################################
'#  IntegerList.bi                                                             #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TStringList.bi                                                            #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Adapted to Integer by Xusinboy Bekchanov (2018-2019)                       #
'###############################################################################

#include once "IntegerList.bi"

'IntegerListItem
Private Property IntegerListItem.Value As Integer
	Return FValue
End Property

Private Property IntegerListItem.Value(V As Integer)
	FValue = V
End Property

Private Operator IntegerListItem.Cast As Any Ptr
	Return Object
End Operator

Private Operator IntegerListItem.Let(V As Any Ptr)
	Object = V
End Operator

Private Operator IntegerListItem.Let(V As Integer)
	FValue = V
End Operator

Private Constructor IntegerListItem
	Value = 0
	Object  = 0
End Constructor

Private Destructor IntegerListItem
	FValue = 0
	Object  = 0
End Destructor

Private Operator IntegerList.Cast As Any Ptr
	Return @This
End Operator

Private Property IntegerList.Count As Integer
	Return FItems.Count
End Property

Private Property IntegerList.Count(Value As Integer)
End Property

Private Operator IntegerList.[](Index As Integer) As Integer
	If Index >= 0 And Index <= Count -1 Then
		Return QIntegerListItem(FItems.Items[Index]).Value
	End If
	Return 0
End Operator

Private Property IntegerList.Item(Index As Integer) As Integer
	If Index >= 0 And Index <= Count -1 Then
		Return QIntegerListItem(FItems.Items[Index]).Value
	End If
	Return 0
End Property

Private Property IntegerList.Item(Index As Integer, FItem As Integer)
	If Index >= 0 And Index <= Count -1 Then
		QIntegerListItem(FItems.Items[Index]).Value = FItem
	End If
End Property

Private Property IntegerList.Object(Index As Integer) As Any Ptr
	If Index >= 0 And Index <= Count -1 Then
		Return QIntegerListItem(FItems.Items[Index]).Object
	End If
	Return 0
End Property

Private Property IntegerList.Object(Index As Integer, FObj As Any Ptr)
	If Index >= 0 And Index <= Count -1 Then
		QIntegerListItem(FItems.Items[Index]).Object = FObj
	End If
End Property

Private Sub IntegerList.Add(iItem As Integer, Obj As Any Ptr = 0)
	Dim As IntegerListItem Ptr nItem = New_( IntegerListItem)
	With *nItem
		.Value  = iItem
		.Object = Obj
	End With
	FItems.Add nItem
End Sub

Private Sub IntegerList.Insert(Index As Integer, FItem As Integer, FObj As Any Ptr = 0)
	Dim As IntegerListItem Ptr nItem = New_( IntegerListItem)
	With *nItem
		.Value  = FItem
		.Object = FObj
	End With
	FItems.Insert Index, nItem
End Sub

Private Sub IntegerList.Exchange(Index1 As Integer, Index2 As Integer)
	FItems.Exchange(Index1, Index2)
End Sub

Private Sub IntegerList.Remove(Index As Integer)
	If Index = -1 Then Exit Sub
	Delete_( Cast(IntegerListItem Ptr, FItems.Items[Index]))
	FItems.Remove Index
End Sub

Private Sub IntegerList.Sort
	Dim As Integer i,j
	For i = 1 To Count -1
		For j = Count -1 To i Step -1
			If (Item(j) < Item(j - 1)) Then
				Exchange j - 1, j
			End If
		Next
	Next
End Sub

Private Sub IntegerList.Clear
	For i As Integer = Count -1 To 0 Step -1
		Delete_( Cast(IntegerListItem Ptr, FItems.Items[i]))
	Next i
	FItems.Clear
End Sub

#ifndef IntegerList_IndexOf_Off
	Private Function IntegerList.IndexOf(FItem As Integer) As Integer
		For i As Integer = 0 To Count -1
			If QIntegerListItem(FItems.Items[i]).Value = FItem Then Return i
		Next i
		Return -1
	End Function
#endif

Private Function IntegerList.IndexOfObject(FObj As Any Ptr) As Integer
	For i As Integer = 0 To Count -1
		If QIntegerListItem(FItems.Items[i]).Object = FObj Then Return i
	Next i
	Return -1
End Function

Private Function IntegerList.Contains(FItem As Integer) As Boolean
	Return IndexOf(FItem) <> -1
End Function

Private Function IntegerList.Get(iItem As Integer, Obj As Any Ptr = 0) As Any Ptr
	For i As Integer = 0 To Count - 1
        If QIntegerListItem(FItems.Items[i]).Value = iItem Then Return QIntegerListItem(FItems.Items[i]).Object
	Next i
	Return Obj
End Function

Private Sub IntegerList.Set(iItem As Integer, Obj As Any Ptr)
	For i As Integer = 0 To Count - 1
        If QIntegerListItem(FItems.Items[i]).Value = iItem Then 
        	QIntegerListItem(FItems.Items[i]).Object = Obj
        	Exit Sub
        End If
	Next i
End Sub

Private Constructor IntegerList
	FItems.Clear
End Constructor

Private Destructor IntegerList
	For i As Integer = Count -1 To 0 Step -1
		Delete_( Cast(IntegerListItem Ptr, FItems.Items[i]))
	Next i
End Destructor
