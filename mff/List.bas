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

'******************************************************************************
'* 排序辅助: 让各类 List 复用同一套算法                                      *
'*   SortByKey     : LSD 基数排序, 每趟 8 位 / 共 8 趟, 由 keyOf 提供 8 字节   *
'*                   无符号键, 不需要任何比较。                               *
'*   SortByCompare : TimSort, 稳定, 最坏 O(n log n), 近似有序输入接近 O(n)。   *
'* 两者都直接操作 Items[] 指针数组, 不触发 Exchange 回调。                     *
'******************************************************************************
Type ListSortRun
	startIdx As Long
	length As Long
End Type

Type ListSortCmpProc As Function(ByVal a As Any Ptr, ByVal b As Any Ptr, ByVal ctx As Any Ptr) As Long
Type ListSortIdxCmpProc As Function(ByVal a As Long, ByVal b As Long, ByVal ctx As Any Ptr) As Long

' TimSort 的比较上下文(模块级, 避免把参数层层传递)
Dim Shared ListSortCmp As ListSortCmpProc        ' 元素指针形式的比较器(List.SortByCompare 用)
Dim Shared ListSortIdxCmp As ListSortIdxCmpProc  ' 行索引形式的比较器(TimSortIndex 用)
Dim Shared ListSortCtx As Any Ptr
Dim Shared ListSortDir As Long
Dim Shared ListSortItems As Any Ptr Ptr

Private Function ListSortCmpPtrAt(ByVal a As Long, ByVal b As Long, ByVal ctx As Any Ptr) As Long
	Return ListSortCmp(ListSortItems[a], ListSortItems[b], ListSortCtx)
End Function

Private Function ListSortCmpAt(ByVal i As Long, ByVal j As Long) As Long
	Return ListSortIdxCmp(i, j, ListSortCtx) * ListSortDir
End Function

'List

Private Sub List.EnsureCapacity(NewSize As Integer)
	If NewSize > m_Capacity Then
		Dim As Integer NewCapacity = IIf(m_Capacity = 0, 4, m_Capacity * 2)
		If NewCapacity < NewSize Then NewCapacity = NewSize
		Dim As Any Ptr Ptr ItemsNew = _Reallocate(Items, NewCapacity * SizeOf(Any Ptr))
		If ItemsNew <> 0 Then
			Items = ItemsNew
			m_Capacity = NewCapacity
		End If
	End If
End Sub
Private Property List.Count As Integer
	Return m_Count
End Property

Private Operator List.Cast As Any Ptr
	Return @This
End Operator

Private Property List.Item(Index As Integer) As Any Ptr
	If Items <> 0 AndAlso Index >= 0 AndAlso Index < m_Count Then
		Return Items[Index]
	Else
		'Print __FUNCTION__ & ", Out of Index boundary. Index = " & Index & " of " & m_Count 
		Return 0
	End If
	
End Property

Private Property List.Item(Index As Integer, FItem As Any Ptr)
	If Items <> 0 AndAlso Index >= 0 AndAlso Index < m_Count Then
		Items[Index] = FItem
	Else
		'Print __FUNCTION__ & ", Out of Index boundary. Index = " & Index & " of " & m_Count 
	End If
End Property

Private Sub List.Add(FItem As Any Ptr)
	EnsureCapacity(m_Count + 1)
	Items[m_Count] = FItem
	m_Count += 1
End Sub

Private Sub List.Insert(Index As Integer, FItem As Any Ptr)
	If Index < 0 Or Index >= m_Count Then Index = m_Count
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
		Dim As Integer NewCapacity = m_Capacity \ 2
		Dim As Any Ptr Ptr ItemsNew = _Reallocate(Items, NewCapacity * SizeOf(Any Ptr))
		If ItemsNew <> 0 Then
			Items = ItemsNew
			m_Capacity = NewCapacity
		End If
	End If
End Sub

Private Sub List.Clear
	If m_Count = 0 Then Return
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
	Items = 0
	m_Count = 0
	m_Capacity = 0
End Constructor

Private Constructor List(ByRef Rhs As List)
	m_Count = 0
	m_Capacity = 0
	Items = 0
	This = Rhs
End Constructor

Private Operator List.Let(ByRef Rhs As List)
	If @This = @Rhs Then Return
	Clear
	If Rhs.m_Count > 0 Then
		EnsureCapacity(Rhs.m_Count)
		Fb_MemMove(Items, Rhs.Items, Rhs.m_Count * SizeOf(Any Ptr))
		m_Count = Rhs.m_Count
	End If
End Operator

Private Destructor List
	Clear
End Destructor

Private Function ListSortMinrun(ByVal n As Long) As Long
	Dim As Long r = 0
	While n >= 64
		r Or= (n And 1)
		n Shr= 1
	Wend
	Return n + r
End Function

Private Sub ListSortInsertion(idx As Long Ptr, ByVal iLeft As Long, ByVal iRight As Long)
	Dim As Long i, j, key
	For i = iLeft + 1 To iRight
		key = idx[i]
		j = i - 1
		While j >= iLeft AndAlso ListSortCmpAt(idx[j], key) > 0
			idx[j + 1] = idx[j]
			j -= 1
		Wend
		idx[j + 1] = key
	Next
End Sub

' 只把较短的一段拷进临时区; 两段已整体有序时直接跳过
Private Sub ListSortMerge(idx As Long Ptr, iTmp As Long Ptr, _
                          ByVal iLeft As Long, ByVal iMid As Long, ByVal iRight As Long)
	Dim As Long len1 = iMid - iLeft + 1
	Dim As Long len2 = iRight - iMid
	If len1 <= 0 OrElse len2 <= 0 Then Return
	If ListSortCmpAt(idx[iMid], idx[iMid + 1]) <= 0 Then Return

	Dim As Long i, j, k
	If len1 <= len2 Then
		For i = 0 To len1 - 1
			iTmp[i] = idx[iLeft + i]
		Next
		i = 0 : j = iMid + 1 : k = iLeft
		While i < len1 AndAlso j <= iRight
			If ListSortCmpAt(iTmp[i], idx[j]) <= 0 Then
				idx[k] = iTmp[i] : i += 1
			Else
				idx[k] = idx[j] : j += 1
			End If
			k += 1
		Wend
		While i < len1
			idx[k] = iTmp[i] : i += 1 : k += 1
		Wend
	Else
		For j = 0 To len2 - 1
			iTmp[j] = idx[iMid + 1 + j]
		Next
		i = iMid : j = len2 - 1 : k = iRight
		While i >= iLeft AndAlso j >= 0
			If ListSortCmpAt(idx[i], iTmp[j]) > 0 Then
				idx[k] = idx[i] : i -= 1
			Else
				idx[k] = iTmp[j] : j -= 1
			End If
			k -= 1
		Wend
		While j >= 0
			idx[k] = iTmp[j] : j -= 1 : k -= 1
		Wend
	End If
End Sub

Private Sub ListSortMergeAt(idx As Long Ptr, iTmp As Long Ptr, stack As ListSortRun Ptr, ByRef top As Long, ByVal iM As Long)
	ListSortMerge(idx, iTmp, stack[iM].startIdx, stack[iM].startIdx + stack[iM].length - 1, stack[iM + 1].startIdx + stack[iM + 1].length - 1)
	stack[iM].length += stack[iM + 1].length
	For k As Long = iM + 1 To top - 2
		stack[k] = stack[k + 1]
	Next
	top -= 1
End Sub

' 标准 TimSort 不变式(必须覆盖 top == 2 的情形, 否则尾部 run 会无尽堆叠)
Private Sub ListSortMaintain(idx As Long Ptr, iTmp As Long Ptr, stack As ListSortRun Ptr, ByRef top As Long)
	Do While top > 1
		Dim As Long n = top - 2
		If (n > 0 AndAlso stack[n - 1].length <= stack[n].length + stack[n + 1].length) OrElse _
		   (n > 1 AndAlso stack[n - 2].length <= stack[n - 1].length + stack[n].length) Then
			Dim As Long iM = n
			If stack[n - 1].length < stack[n + 1].length Then iM = n - 1
			ListSortMergeAt(idx, iTmp, stack, top, iM)
		ElseIf stack[n].length <= stack[n + 1].length Then
			ListSortMergeAt(idx, iTmp, stack, top, n)
		Else
			Exit Do
		End If
	Loop
End Sub

' 基数排序: 8 字节键, 8 趟, 每趟 256 个桶; 降序只需把键取反
Sub List.SortByKey(ByVal keyOf As Function(ByVal Item As Any Ptr) As ULongInt, ByVal iDirection As Long = 1)
	Dim As Long n = m_Count
	If n < 2 Then Return

	Type SortKV
		k As ULongInt
		v As Any Ptr
	End Type
	Dim As SortKV Ptr bufA = New SortKV[n]
	Dim As SortKV Ptr bufB = New SortKV[n]
	If bufA = 0 OrElse bufB = 0 Then
		If bufA Then Delete[] bufA
		If bufB Then Delete[] bufB
		Return
	End If
	Dim As Long cnt(0 To 255)
	Dim As Long i, sh, kk
	For i = 0 To n - 1
		bufA[i].v = Items[i]
		bufA[i].k = keyOf(Items[i])
		If iDirection < 0 Then bufA[i].k = Not bufA[i].k
	Next
	For sh = 0 To 56 Step 8
		For i = 0 To 255
			cnt(i) = 0
		Next
		For i = 0 To n - 1
			cnt(Cast(Long, (bufA[i].k Shr sh) And 255)) += 1
		Next
		Dim As Long acc = 0
		For i = 0 To 255
			Dim As Long c = cnt(i)
			cnt(i) = acc
			acc += c
		Next
		For i = 0 To n - 1
			kk = Cast(Long, (bufA[i].k Shr sh) And 255)
			bufB[cnt(kk)] = bufA[i]
			cnt(kk) += 1
		Next
		Swap bufA, bufB
	Next
	For i = 0 To n - 1
		Items[i] = bufA[i].v
	Next
	Delete[] bufA
	Delete[] bufB
End Sub

' 对索引数组做 TimSort: cmp(a, b, ctx) 用"行号"比较两个元素,
' 排完后由调用方按 idx 重排数据 —— 对"交换整行代价高"的二维结构特别划算。
' idx 由本函数初始化为 0..n-1。
Sub TimSortIndex(ByVal idx As Long Ptr, ByVal n As Long, _
                 ByVal cmp As Function(ByVal a As Long, ByVal b As Long, ByVal ctx As Any Ptr) As Long, _
                 ByVal iDirection As Long, ByVal ctx As Any Ptr)
	Dim As Long i
	If n < 2 Then Return
	If idx = 0 Then Return
	ListSortIdxCmp = cmp
	ListSortCtx = ctx
	ListSortDir = iDirection

	Dim As Long Ptr iTmp = New Long[n]
	If iTmp = 0 Then Return
	For i = 0 To n - 1
		idx[i] = i
	Next

	Dim As Long minrun = ListSortMinrun(n)
	Dim As Long maxRuns = n \ minrun + 2
	Dim As ListSortRun Ptr stack = New ListSortRun[maxRuns]
	Dim As Long top = 0
	Dim As Long cur = 0

	While cur < n
		Dim As Long runLen = 1
		If cur + 1 < n Then
			If ListSortCmpAt(idx[cur], idx[cur + 1]) <= 0 Then
				While cur + runLen < n AndAlso ListSortCmpAt(idx[cur + runLen - 1], idx[cur + runLen]) <= 0
					runLen += 1
				Wend
			Else
				While cur + runLen < n AndAlso ListSortCmpAt(idx[cur + runLen - 1], idx[cur + runLen]) > 0
					runLen += 1
				Wend
				' 逆序 run: 反转即可变成有序 run
				Dim As Long L = cur, R = cur + runLen - 1
				While L < R
					Swap idx[L], idx[R]
					L += 1 : R -= 1
				Wend
			End If
		End If
		If runLen < minrun Then
			Dim As Long forceEnd = cur + minrun - 1
			If forceEnd >= n Then forceEnd = n - 1
			ListSortInsertion(idx, cur, forceEnd)
			runLen = forceEnd - cur + 1
		End If
		stack[top].startIdx = cur
		stack[top].length = runLen
		top += 1
		ListSortMaintain(idx, iTmp, stack, top)
		cur += runLen
	Wend

	While top > 1
		If top = 2 Then
			ListSortMergeAt(idx, iTmp, stack, top, 0)
		ElseIf stack[top - 3].length < stack[top - 1].length Then
			ListSortMergeAt(idx, iTmp, stack, top, top - 3)
		Else
			ListSortMergeAt(idx, iTmp, stack, top, top - 2)
		End If
	Wend

	Delete[] iTmp
	Delete[] stack
End Sub

' TimSort: 排序索引数组, 最后一次性重排 Items
Sub List.SortByCompare(ByVal cmp As Function(ByVal a As Any Ptr, ByVal b As Any Ptr, ByVal ctx As Any Ptr) As Long, ByVal iDirection As Long = 1, ByVal ctx As Any Ptr = 0)
	Dim As Long n = m_Count
	If n < 2 Then Return

	ListSortCmp = cmp
	ListSortItems = Items

	Dim As Long Ptr idx = New Long[n]
	If idx = 0 Then Return

	TimSortIndex(idx, n, @ListSortCmpPtrAt, iDirection, ctx)

	' 按 idx 一次性重排
	Dim As Any Ptr Ptr outb = New Any Ptr[n]
	If outb <> 0 Then
		For i As Long = 0 To n - 1
			outb[i] = Items[idx[i]]
		Next
		For i As Long = 0 To n - 1
			Items[i] = outb[i]
		Next
		Delete[] outb
	End If

	Delete[] idx
End Sub