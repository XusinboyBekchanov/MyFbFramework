'******************************************************************************
'* List                                                                       *
'* This file is part of MyFBFramework                                         *
'* Authors: Nastase Eodor, Xusinboy Bekchanov                                 *
'* Based on:                                                                  *
'*  TList                                                                     *
'*  FreeBasic Windows GUI ToolKit                                             *
'*  Copyright (c) 2007-2008 Nastase Eodor                                     *
'*  Version 1.0.0                                                             *
'*  nastase_eodor@yahoo.com                                                   *
'*  Modified by Xusinboy Bekchanov (2018-2019)                                *
'******************************************************************************

#DEFINE QList(__Ptr__) *Cast(List Ptr,__Ptr__)

Type List
    Private:
    Public:
        Count As Integer
        Items As Any Ptr Ptr
        Declare Property Item(Index As Integer) As Any Ptr
        Declare Property Item(Index As Integer,FItem As Any Ptr)
        Declare Sub Add(FItem As Any Ptr)
        Declare Sub Insert(Index As Integer,FItem As Any Ptr)
        Declare Sub Exchange(Index1 As Integer,Index2 As Integer)
        Declare Sub Remove(Index As Integer)
        Declare Sub Clear
        Declare Function IndexOf(FItem As Any Ptr) As Integer
        Declare Function Contains(FItem As Any Ptr) As Boolean
        Declare Operator Cast As Any Ptr 
        Declare Constructor
        Declare Destructor
End Type

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
    Items = ReAllocate(Items,Count*SizeOf(Any Ptr))
    Items[Count -1] = FItem
End Sub

Sub List.Insert(Index As Integer,FItem As Any Ptr)
    Static As Any Ptr Ptr Temp
    Dim As Integer i
    If Index >= 0 And Index <= Count -1 Then
       Temp = ReAllocate(Temp, (Count+1)*SizeOf(Any Ptr))
       For i = 0 to Index
           Temp[i] = Items[i]
       Next i
       Temp[Index] = FItem 
       For i = Index to Count -1
           Temp[i +1] = Items[i]
       Next i
       Count += 1
       Items = ReAllocate(Items, Count*SizeOf(Any Ptr))
       For i = 0 to Count -1
           Items[i] = Temp[i]
       Next i
       'DeAllocate Temp
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
    Dim As Integer i,x
    Static As Any Ptr Ptr Temp
    If Index >= 0 And Index <= Count -1 Then
       Temp = ReAllocate(Temp, (Count)*SizeOf(Any Ptr)) 
       x = 0
       For i = 0 To Count -1
           If i <> Index Then
              x += 1
              Temp[x -1] = Items[i]
           End If
       Next i
       Count -= 1
       Deallocate Items
       Items = cAllocate(Count*SizeOf(Any Ptr))
       For i = 0 to Count -1
           Items[i] = Temp[i]
       Next i
       'DeAllocate Temp
    End If
End Sub

Sub List.Clear
    Count = 0
    If Items <> 0 Then Deallocate Items
    Items = 0
    Items = cAllocate(Count)
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
    Items = cAllocate(0)
End Constructor

Destructor List
    'Items = cAllocate(0)
    DeAllocate Items
    Items = 0
End Destructor
