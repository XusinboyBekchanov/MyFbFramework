' ==========================================
' 大容量数组排序库: TimSort(字符串) + 基数排序(数值)
'
' 对外接口:
'   SortStringArray(arr() As WString, bMatchCase, iDirection, bNaturalSort)
'       —— 唯一的字符串入口, 内部即 TimSort (稳定, 最坏 O(n log n), 近似有序输入接近 O(n))
'   TimSort(同上)                   —— 同一实现, 保留算法名
'   RadixSortByte/Short/Integer/Long/LongInt/ULong/ULongInt/Single/Double
'       —— 数值类型, 全部由两个宏生成, 一份源码覆盖所有类型
'
' 性能要点(实测):
'   1) 字符串一律用 WString。数组元素类型必须与比较函数形参类型一致, 否则每次比较
'      都会隐式产生两个临时宽字符串(分配 + 转换 + 释放)。旧版本 arr() As String
'      配 WString 形参, 这项开销占总耗时的一半以上。
'   2) 比较函数把"自然排序/大小写"判断放到独立分支, 常态比较不再逐字符做
'      数值起始判断。
'   3) 基数排序用 8 位一趟 + 符号位翻转: 整数只需 Xor 常量, 浮点用
'      "负数按位取反 / 非负翻转符号位" 的 IEEE754 保序变换; 趟数 = 字节数。
'   4) 注意: 本编译器 Integer 与 LongInt 同宽(8 字节), 所以 RadixSortInteger
'      按 SizeOf(Integer) 在 16/32/64 位核心之间自动选择, 换编译器也不会越界。
' ==========================================
#include once "mff/NoInterface.bi"
#include once "String.bi"

' 排序方向常量
Const SORT_ASCENDING As Long = 1
Const SORT_DESCENDING As Long = -1

' ==========================================
' 自然排序用的数值段解析与精确比较
' 说明: 旧实现把数值段解析成 Double 后比较, 小数部分靠 divisor *= 10 做浮点除法,
'       既慢又会在位数较多时出现精度/溢出误差。下面按"符号 + 整数位数 + 逐位 + 小数
'       逐位(缺位补 0)"直接比较十进制字面量, 结果精确且更快。
' ==========================================

' [i] 处是否是数值段起点: 数字, 或后跟数字的 +/- 符号
Private Function IsNumStart(p As UShort Ptr, ByVal i As Integer, ByVal iLen As Integer) As Boolean
	Dim As Long c = p[i]
	If c >= 48 AndAlso c <= 57 Then Return True
	If (c = 43 OrElse c = 45) AndAlso i + 1 < iLen Then
		Dim As Long c2 = p[i + 1]
		If c2 >= 48 AndAlso c2 <= 57 Then Return True
	End If
	Return False
End Function

' 返回 [i] 处数值段的结束位置(不含): [+-]? 数字* (. 数字*)?
Private Function NumEnd(p As UShort Ptr, ByVal i As Integer, ByVal iLen As Integer) As Integer
	If i < iLen Then
		If p[i] = 43 OrElse p[i] = 45 Then i += 1   ' '+' / '-'
	End If
	While i < iLen AndAlso p[i] >= 48 AndAlso p[i] <= 57
		i += 1
	Wend
	If i < iLen AndAlso p[i] = 46 Then              ' '.'
		i += 1
		While i < iLen AndAlso p[i] >= 48 AndAlso p[i] <= 57
			i += 1
		Wend
	End If
	Return i
End Function

' [b,e) 内是否没有任何 1-9 的数位(即数值为 0)
Private Function IsAllZero(p As UShort Ptr, ByVal b As Integer, ByVal e As Integer) As Boolean
	For k As Integer = b To e - 1
		If p[k] >= 49 AndAlso p[k] <= 57 Then Return False
	Next
	Return True
End Function

' 精确比较两个数值段 [b1,e1) 与 [b2,e2), 返回 -1/0/1
Private Function CmpNumRange(p1 As UShort Ptr, ByVal b1 As Integer, ByVal e1 As Integer, _
                             p2 As UShort Ptr, ByVal b2 As Integer, ByVal e2 As Integer) As Integer
	Dim As Integer sgn1 = 1, sgn2 = 1
	If b1 < e1 Then
		If p1[b1] = 45 Then
			sgn1 = -1 : b1 += 1
		ElseIf p1[b1] = 43 Then
			b1 += 1
		End If
	End If
	If b2 < e2 Then
		If p2[b2] = 45 Then
			sgn2 = -1 : b2 += 1
		ElseIf p2[b2] = 43 Then
			b2 += 1
		End If
	End If

	' --- 整数部分: 去掉前导 0 后先比有效位数, 位数相同再逐位比 ---
	Dim As Integer ie1 = b1, ie2 = b2
	While ie1 < e1 AndAlso p1[ie1] >= 48 AndAlso p1[ie1] <= 57
		ie1 += 1
	Wend
	While ie2 < e2 AndAlso p2[ie2] >= 48 AndAlso p2[ie2] <= 57
		ie2 += 1
	Wend
	Dim As Integer z1 = b1, z2 = b2
	While z1 < ie1 AndAlso p1[z1] = 48
		z1 += 1
	Wend
	While z2 < ie2 AndAlso p2[z2] = 48
		z2 += 1
	Wend

	Dim As Integer n1 = ie1 - z1, n2 = ie2 - z2
	Dim As Integer mag = 0        ' 绝对值比较结果
	If n1 <> n2 Then
		If n1 > n2 Then mag = 1 Else mag = -1
	Else
		For k As Integer = 0 To n1 - 1
			If p1[z1 + k] <> p2[z2 + k] Then
				If p1[z1 + k] > p2[z2 + k] Then mag = 1 Else mag = -1
				Exit For
			End If
		Next
	End If

	' --- 整数部分相同则比小数部分, 缺位按 0 补 ---
	If mag = 0 Then
		Dim As Integer f1 = ie1, f2 = ie2
		If f1 < e1 AndAlso p1[f1] = 46 Then f1 += 1
		If f2 < e2 AndAlso p2[f2] = 46 Then f2 += 1
		While f1 < e1 OrElse f2 < e2
			Dim As Long d1 = 0, d2 = 0
			If f1 < e1 Then d1 = p1[f1] - 48
			If f2 < e2 Then d2 = p2[f2] - 48
			If d1 <> d2 Then
				If d1 > d2 Then mag = 1 Else mag = -1
				Exit While
			End If
			f1 += 1 : f2 += 1
		Wend
	End If

	' 先判符号: 异号时负数一定更小(只有 -0 与 +0 例外)。
	' 注意不能拿"绝对值相等"当相等 —— 0.5 与 -0.5 绝对值相等但必须分出大小。
	If sgn1 <> sgn2 Then
		If mag <> 0 Then
			If sgn1 < 0 Then Return -1 Else Return 1
		End If
		If IsAllZero(p1, b1, e1) AndAlso IsAllZero(p2, b2, e2) Then Return 0
		If sgn1 < 0 Then Return -1 Else Return 1
	End If
	If mag = 0 Then Return 0                   ' 同号且数值相等
	If sgn1 < 0 Then mag = -mag
	Return mag
End Function

' ==========================================
' 高性能字符串比较函数 (避免 LCase/UCase 产生临时字符串内存分配)
' 返回值: -1 (s1 < s2), 0 (s1 = s2), 1 (s1 > s2)
' bMatchCase   : True 区分大小写, False 时只折叠 ASCII A-Z
' bNaturalSort : True 时连续的数字段按数值大小比较
' ==========================================
Private Function CompareStrings(ByRef s1 As WString, ByRef s2 As WString, _
                                ByVal bMatchCase As Boolean = True, _
                                ByVal bNaturalSort As Boolean = False) As Integer
	Dim As Integer iLen1 = Len(s1)
	Dim As Integer iLen2 = Len(s2)
	' 字符数据指针只取一次, 避免之后每次下标访问都反引用字符串描述符
	Dim As UShort Ptr p1 = Cast(UShort Ptr, StrPtr(s1))
	Dim As UShort Ptr p2 = Cast(UShort Ptr, StrPtr(s2))
	Dim As Integer i1 = 0, i2 = 0
	Dim As Long c1, c2

	If bNaturalSort Then
		' --- 自然排序: 数字段按数值比, 其它字符按大小写设置比 ---
		While i1 < iLen1 AndAlso i2 < iLen2
			c1 = p1[i1]
			c2 = p2[i2]

			If IsNumStart(p1, i1, iLen1) AndAlso IsNumStart(p2, i2, iLen2) Then
				Dim As Integer e1 = NumEnd(p1, i1, iLen1)
				Dim As Integer e2 = NumEnd(p2, i2, iLen2)
				Dim As Integer r = CmpNumRange(p1, i1, e1, p2, i2, e2)
				i1 = e1 : i2 = e2
				If r <> 0 Then Return r
				Continue While          ' 数值相等, 继续比较后续字符
			End If

			If Not bMatchCase Then
				If c1 >= 65 AndAlso c1 <= 90 Then c1 += 32 ' A-Z -> a-z
				If c2 >= 65 AndAlso c2 <= 90 Then c2 += 32
			End If
			If c1 < c2 Then Return -1
			If c1 > c2 Then Return 1
			i1 += 1
			i2 += 1
		Wend
	ElseIf bMatchCase Then
		' --- 最快路径: 区分大小写且无自然排序 ---
		While i1 < iLen1 AndAlso i2 < iLen2
			c1 = p1[i1]
			c2 = p2[i2]
			If c1 < c2 Then Return -1
			If c1 > c2 Then Return 1
			i1 += 1
			i2 += 1
		Wend
	Else
		' --- 不区分大小写 ---
		While i1 < iLen1 AndAlso i2 < iLen2
			c1 = p1[i1]
			c2 = p2[i2]
			If c1 >= 65 AndAlso c1 <= 90 Then c1 += 32 ' A-Z -> a-z
			If c2 >= 65 AndAlso c2 <= 90 Then c2 += 32
			If c1 < c2 Then Return -1
			If c1 > c2 Then Return 1
			i1 += 1
			i2 += 1
		Wend
	End If

	' 前缀完全相同, 较短的字符串更小
	If iLen1 < iLen2 Then Return -1
	If iLen1 > iLen2 Then Return 1
	Return 0
End Function

' ==========================================
' 字符串排序: TimSort (唯一的字符串排序入口)
' 排序索引数组, 只有 n 次字符串深拷贝; 稳定; 最坏 O(n log n)
' ==========================================

Type RunInfo
	startIdx As Long
	length As Long
End Type

' ---------- 插入排序（操作 idx） ----------
Private Sub InsertionSortIdx(idx() As Long, arr() As WString, iLeft As Long, iRight As Long, _
                             ByVal bMatchCase As Boolean, ByVal bNaturalSort As Boolean, _
                             ByVal iDirection As Long)
	Dim As Long i, j
	For i = iLeft + 1 To iRight
		Dim As Long key = idx(i)
		j = i - 1
		While j >= iLeft AndAlso _
		      CompareStrings(arr(idx(j)), arr(key), bMatchCase, bNaturalSort) * iDirection > 0
			idx(j + 1) = idx(j)
			j -= 1
		Wend
		idx(j + 1) = key
	Next
End Sub

' ---------- minrun ----------
Private Function CalcMinrun(n As Long) As Long
	Dim As Long r = 0
	While n >= 64
		r Or= (n And 1)
		n Shr= 1
	Wend
	Return n + r
End Function

' ---------- 归并（操作 idx，比较 arr） ----------
' iTmp 由调用方复用, 避免每次归并都分配内存。只把较短的一段拷入临时区。
Private Sub MergeRunsIdx(idx() As Long, arr() As WString, iTmp() As Long, _
                         iLeft As Long, iMid As Long, iRight As Long, _
                         ByVal bMatchCase As Boolean, ByVal bNaturalSort As Boolean, _
                         ByVal iDirection As Long)
	Dim As Long len1 = iMid - iLeft + 1
	Dim As Long len2 = iRight - iMid
	If len1 <= 0 OrElse len2 <= 0 Then Return

	' 两段拼起来已经有序就不用合并(顺序/近似顺序输入接近 O(n))
	If CompareStrings(arr(idx(iMid)), arr(idx(iMid + 1)), bMatchCase, bNaturalSort) * iDirection <= 0 Then Return

	Dim As Long i, j, k
	If len1 <= len2 Then
		For i = 0 To len1 - 1
			iTmp(i) = idx(iLeft + i)
		Next
		i = 0 : j = iMid + 1 : k = iLeft
		While i < len1 AndAlso j <= iRight
			' <= 0 时取左段, 保证稳定性
			If CompareStrings(arr(iTmp(i)), arr(idx(j)), bMatchCase, bNaturalSort) * iDirection <= 0 Then
				idx(k) = iTmp(i) : i += 1
			Else
				idx(k) = idx(j) : j += 1
			End If
			k += 1
		Wend
		While i < len1
			idx(k) = iTmp(i) : i += 1 : k += 1
		Wend
	Else
		' 从右往左合并, 相等时先放右段, 同样保证稳定性
		For j = 0 To len2 - 1
			iTmp(j) = idx(iMid + 1 + j)
		Next
		i = iMid : j = len2 - 1 : k = iRight
		While i >= iLeft AndAlso j >= 0
			If CompareStrings(arr(idx(i)), arr(iTmp(j)), bMatchCase, bNaturalSort) * iDirection > 0 Then
				idx(k) = idx(i) : i -= 1
			Else
				idx(k) = iTmp(j) : j -= 1
			End If
			k -= 1
		Wend
		While j >= 0
			idx(k) = iTmp(j) : j -= 1 : k -= 1
		Wend
	End If
End Sub

' ---------- 合并 stack(iM) 与 stack(iM+1)，并压缩栈 ----------
Private Sub MergeAtIdx(idx() As Long, arr() As WString, iTmp() As Long, stack() As RunInfo, _
                       ByRef top As Long, ByVal iM As Long, _
                       ByVal bMatchCase As Boolean, ByVal bNaturalSort As Boolean, _
                       ByVal iDirection As Long)
	MergeRunsIdx(idx(), arr(), iTmp(), _
		stack(iM).startIdx, _
		stack(iM).startIdx + stack(iM).length - 1, _
		stack(iM + 1).startIdx + stack(iM + 1).length - 1, _
		bMatchCase, bNaturalSort, iDirection)
	stack(iM).length += stack(iM + 1).length
	For k As Long = iM + 1 To top - 2
		stack(k) = stack(k + 1)
	Next
	top -= 1
End Sub

' ---------- 栈平衡 ----------
' 标准 TimSort 不变式:
'   top >= 3: lenX <= lenY + lenZ 时合并(X<Z 则合并 X,Y, 否则合并 Y,Z)
'             否则 lenY <= lenZ 时合并 Y,Z
'   top == 2: lenX <= lenY 时合并
' 漏掉 top == 2 这一条会让尾部 run 一路向左堆叠, 归并量退化成 O(n^2/minrun)。
Private Sub MaintainStackIdx(idx() As Long, arr() As WString, iTmp() As Long, stack() As RunInfo, ByRef top As Long, _
                             ByVal bMatchCase As Boolean, ByVal bNaturalSort As Boolean, _
                             ByVal iDirection As Long)
	Do While top > 1
		Dim As Long n = top - 2      ' 最后一个三段组的中间位置
		If (n > 0 AndAlso stack(n - 1).length <= stack(n).length + stack(n + 1).length) OrElse _
		   (n > 1 AndAlso stack(n - 2).length <= stack(n - 1).length + stack(n).length) Then
			Dim As Long iM = n
			If stack(n - 1).length < stack(n + 1).length Then iM = n - 1
			MergeAtIdx(idx(), arr(), iTmp(), stack(), top, iM, bMatchCase, bNaturalSort, iDirection)
		ElseIf stack(n).length <= stack(n + 1).length Then
			MergeAtIdx(idx(), arr(), iTmp(), stack(), top, n, bMatchCase, bNaturalSort, iDirection)
		Else
			Exit Do
		End If
	Loop
End Sub

' ---------- 主函数 ----------
'   arr          待排序字符串数组（可以是任意 LBound/UBound）
'   bMatchCase   是否区分大小写，默认 True
'   iDirection   1=升序, -1=降序，默认升序
'   bNaturalSort 是否启用自然排序（数字感知），默认 False
Sub TimSort(arr() As WString, _
            ByVal bMatchCase As Boolean = True, _
            ByVal iDirection As Long = 1, _
            ByVal bNaturalSort As Boolean = False)
	Dim As Long iLB = LBound(arr)
	Dim As Long iUB = UBound(arr)
	Dim As Long realN = iUB - iLB + 1
	If realN < 2 Then Return

	' ---- 1. 建立索引数组 ----
	Dim As Long idx()
	ReDim idx(iLB To iUB)
	For i As Long = iLB To iUB
		idx(i) = i
	Next

	Dim As Long minrun = CalcMinrun(realN)
	Dim As Long maxRuns = realN \ minrun + 2

	Dim As RunInfo stack()
	ReDim stack(0 To maxRuns - 1)

	' 归并临时区只分配一次, 全程复用
	Dim As Long iTmp()
	ReDim iTmp(0 To realN - 1)

	Dim As Long top = 0
	Dim As Long cur = iLB

	' ---- 2. 扫描 run（只操作 idx） ----
	While cur <= iUB
		Dim As Long runLen = 1

		If cur + 1 <= iUB Then
			' 用目标方向下的比较结果判断：<=0 视为"符合方向"，>0 视为"逆序"
			Dim As Long c01 = CompareStrings(arr(idx(cur)), arr(idx(cur + 1)), _
			                                 bMatchCase, bNaturalSort) * iDirection
			If c01 <= 0 Then
				While cur + runLen <= iUB AndAlso _
				      CompareStrings(arr(idx(cur + runLen - 1)), arr(idx(cur + runLen)), _
				                     bMatchCase, bNaturalSort) * iDirection <= 0
					runLen += 1
				Wend
			Else
				While cur + runLen <= iUB AndAlso _
				      CompareStrings(arr(idx(cur + runLen - 1)), arr(idx(cur + runLen)), _
				                     bMatchCase, bNaturalSort) * iDirection > 0
					runLen += 1
				Wend
				' 逆序 run: 反转 idx 区间即可变成有序 run
				Dim As Long L = cur, R = cur + runLen - 1
				While L < R
					Swap idx(L), idx(R)   ' Long 交换, O(1)
					L += 1 : R -= 1
				Wend
			End If
		End If

		' 短 run 用插入排序扩展到 minrun
		If runLen < minrun Then
			Dim As Long forceEnd = cur + minrun - 1
			If forceEnd > iUB Then forceEnd = iUB
			InsertionSortIdx(idx(), arr(), cur, forceEnd, bMatchCase, bNaturalSort, iDirection)
			runLen = forceEnd - cur + 1
		End If

		stack(top).startIdx = cur
		stack(top).length = runLen
		top += 1

		MaintainStackIdx(idx(), arr(), iTmp(), stack(), top, bMatchCase, bNaturalSort, iDirection)
		cur += runLen
	Wend

	' ---- 3. 合并剩余 run ----
	While top > 1
		If top = 2 Then
			MergeAtIdx(idx(), arr(), iTmp(), stack(), top, 0, bMatchCase, bNaturalSort, iDirection)
		ElseIf stack(top - 3).length < stack(top - 1).length Then
			MergeAtIdx(idx(), arr(), iTmp(), stack(), top, top - 3, bMatchCase, bNaturalSort, iDirection)
		Else
			MergeAtIdx(idx(), arr(), iTmp(), stack(), top, top - 2, bMatchCase, bNaturalSort, iDirection)
		End If
	Wend

	' ---- 4. 按 idx 一次性重排原数组（只有 n 次深拷贝） ----
	Dim As WString tmp()
	ReDim tmp(iLB To iUB)
	For i As Long = iLB To iUB
		tmp(i) = arr(idx(i))          ' n 次深拷贝
	Next
	For i As Long = iLB To iUB
		Swap arr(i), tmp(i)           ' n 次 O(1) 交换
	Next
End Sub

' ==========================================
' 唯一的字符串排序入口 (兼容旧名字, 实现就是 TimSort)
' iDirection: SORT_ASCENDING (1) 升序(默认), SORT_DESCENDING (-1) 降序
' ==========================================
Sub SortStringArray(arr() As WString, _
                    ByVal bMatchCase As Boolean = True, _
                    ByVal iDirection As Long = 1, _
                    ByVal bNaturalSort As Boolean = False)
	TimSort(arr(), bMatchCase, iDirection, bNaturalSort)
End Sub

' ==========================================
' 数值排序: 两个宏生成"定宽核心", 公开函数只是包装/分派
'   整数族: 键 = 位模式 Xor 常量(翻转符号位); 无符号类型传 0
'   浮点族: 键 = 负数按位取反 / 非负翻转符号位 (IEEE754 保序变换)
'   LSD, 每趟 8 位, 趟数 = 字节数
' ==========================================
#macro DEF_RADIX_CORE_INT(NAME, T, UT, PASSES, XORMASK)
	Private Sub NAME(p As T Ptr, ByVal n As Long)
		If n < 2 Then Return
		Dim As UT xorKey = XORMASK
		Dim As UT Ptr u = Cast(UT Ptr, p)
		Dim As UT Ptr bufA = New UT[n]
		Dim As UT Ptr bufB = New UT[n]
		Dim As Long cnt(0 To 255)
		Dim As Long i, sh
		For i = 0 To n - 1
			bufA[i] = u[i] Xor xorKey
		Next
		For sh = 0 To (PASSES - 1) * 8 Step 8
			For i = 0 To 255
				cnt(i) = 0
			Next
			For i = 0 To n - 1
				cnt(Cast(Long, (bufA[i] Shr sh) And 255)) += 1
			Next
			Dim As Long acc = 0
			For i = 0 To 255
				Dim As Long c = cnt(i)
				cnt(i) = acc
				acc += c
			Next
			For i = 0 To n - 1
				Dim As Long k = Cast(Long, (bufA[i] Shr sh) And 255)
				bufB[cnt(k)] = bufA[i]
				cnt(k) += 1
			Next
			Swap bufA, bufB
		Next
		For i = 0 To n - 1
			u[i] = bufA[i] Xor xorKey
		Next
		Delete[] bufA
		Delete[] bufB
	End Sub
#endmacro

#macro DEF_RADIX_CORE_FLOAT(NAME, T, UT, PASSES, FLIP)
	Private Sub NAME(p As T Ptr, ByVal n As Long)
		If n < 2 Then Return
		Dim As UT flipKey = FLIP
		Dim As UT Ptr u = Cast(UT Ptr, p)
		Dim As UT Ptr bufA = New UT[n]
		Dim As UT Ptr bufB = New UT[n]
		Dim As Long cnt(0 To 255)
		Dim As Long i, sh
		For i = 0 To n - 1
			Dim As UT bits = u[i]
			If (bits And flipKey) <> 0 Then
				bufA[i] = Not bits
			Else
				bufA[i] = bits Xor flipKey
			End If
		Next
		For sh = 0 To (PASSES - 1) * 8 Step 8
			For i = 0 To 255
				cnt(i) = 0
			Next
			For i = 0 To n - 1
				cnt(Cast(Long, (bufA[i] Shr sh) And 255)) += 1
			Next
			Dim As Long acc = 0
			For i = 0 To 255
				Dim As Long c = cnt(i)
				cnt(i) = acc
				acc += c
			Next
			For i = 0 To n - 1
				Dim As Long k = Cast(Long, (bufA[i] Shr sh) And 255)
				bufB[cnt(k)] = bufA[i]
				cnt(k) += 1
			Next
			Swap bufA, bufB
		Next
		For i = 0 To n - 1
			Dim As UT bits = bufA[i]
			If (bits And flipKey) <> 0 Then
				u[i] = bits Xor flipKey
			Else
				u[i] = Not bits
			End If
		Next
		Delete[] bufA
		Delete[] bufB
	End Sub
#endmacro

DEF_RADIX_CORE_INT(RadixCoreS8, Byte, UByte, 1, &h80)
DEF_RADIX_CORE_INT(RadixCoreS16, Short, UShort, 2, &h8000)
DEF_RADIX_CORE_INT(RadixCoreS32, Long, ULong, 4, Culng(1) Shl 31)
DEF_RADIX_CORE_INT(RadixCoreS64, LongInt, ULongInt, 8, CulngInt(1) Shl 63)
DEF_RADIX_CORE_INT(RadixCoreU32, ULong, ULong, 4, 0)
DEF_RADIX_CORE_INT(RadixCoreU64, ULongInt, ULongInt, 8, 0)
DEF_RADIX_CORE_FLOAT(RadixCoreF32, Single, ULong, 4, Culng(1) Shl 31)
DEF_RADIX_CORE_FLOAT(RadixCoreF64, Double, ULongInt, 8, CulngInt(1) Shl 63)

' ---------- 公开包装 ----------
Sub RadixSortByte(rs() As Byte)
	Dim As Long lb = LBound(rs), n = UBound(rs) - lb + 1
	If n < 2 Then Return
	RadixCoreS8(@rs(lb), n)
End Sub

Sub RadixSortShort(rs() As Short)
	Dim As Long lb = LBound(rs), n = UBound(rs) - lb + 1
	If n < 2 Then Return
	RadixCoreS16(@rs(lb), n)
End Sub

' Integer 的宽度随编译器而定(本编译器为 8 字节), 按 SizeOf 分派, 换编译器也不会越界
Sub RadixSortInteger(rs() As Integer)
	Dim As Long lb = LBound(rs), n = UBound(rs) - lb + 1
	If n < 2 Then Return
	Select Case SizeOf(Integer)
	Case 8
		RadixCoreS64(Cast(LongInt Ptr, @rs(lb)), n)
	Case 4
		RadixCoreS32(Cast(Long Ptr, @rs(lb)), n)
	Case 2
		RadixCoreS16(Cast(Short Ptr, @rs(lb)), n)
	End Select
End Sub

Sub RadixSortLong(rs() As Long)
	Dim As Long lb = LBound(rs), n = UBound(rs) - lb + 1
	If n < 2 Then Return
	RadixCoreS32(@rs(lb), n)
End Sub

Sub RadixSortLongInt(rs() As LongInt)
	Dim As Long lb = LBound(rs), n = UBound(rs) - lb + 1
	If n < 2 Then Return
	RadixCoreS64(@rs(lb), n)
End Sub

Sub RadixSortULong(rs() As ULong)
	Dim As Long lb = LBound(rs), n = UBound(rs) - lb + 1
	If n < 2 Then Return
	RadixCoreU32(@rs(lb), n)
End Sub

Sub RadixSortULongInt(rs() As ULongInt)
	Dim As Long lb = LBound(rs), n = UBound(rs) - lb + 1
	If n < 2 Then Return
	RadixCoreU64(@rs(lb), n)
End Sub

Sub RadixSortSingle(rs() As Single)
	Dim As Long lb = LBound(rs), n = UBound(rs) - lb + 1
	If n < 2 Then Return
	RadixCoreF32(@rs(lb), n)
End Sub

Sub RadixSortDouble(rs() As Double)
	Dim As Long lb = LBound(rs), n = UBound(rs) - lb + 1
	If n < 2 Then Return
	RadixCoreF64(@rs(lb), n)
End Sub

' ==========================================
' 测试 / 基准代码
' 测试规模可在编译期覆盖, 便于快速定位规模相关的问题:
'   fbc -d BENCH_SIZE=20000 ...
' 整个测试段可用 -d NO_TESTS 关掉, 把本文件当排序函数库 #include 到别的程序里。
' ==========================================
#ifndef NO_TESTS

Private Function GenerateRandomString(ByVal iLength As Long) As WString
	Dim As WString sResult
	Dim As Long i, iCode
	For i = 1 To iLength
		' 随机生成大写或小写字母, 方便测试大小写敏感度
		' 注意: 必须先存进 Long 再喂给 WChr —— 本构建的 WChr(<Double 实参>) 会返回 NUL,
		' 直接写 WChr(65 + Int(Rnd * 26)) 会生成一串空字符。
		If Rnd > 0.5 Then
			iCode = 65 + Int(Rnd * 26) ' A-Z
		Else
			iCode = 97 + Int(Rnd * 26) ' a-z
		End If
		sResult &= WChr(iCode)
	Next i
	Return sResult
End Function

' ---------- 结果自检 ----------
Private Function IsSortedW(arr() As WString, ByVal bMatchCase As Boolean, _
                           ByVal iDirection As Long, ByVal bNaturalSort As Boolean) As Boolean
	For i As Long = LBound(arr) + 1 To UBound(arr)
		If CompareStrings(arr(i - 1), arr(i), bMatchCase, bNaturalSort) * iDirection > 0 Then Return False
	Next
	Return True
End Function

' 小数据量参考实现: Double 插入排序
Private Sub RefSortD(a() As Double)
	For j As Long = LBound(a) + 1 To UBound(a)
		Dim As Double key = a(j)
		Dim As Long m = j - 1
		While m >= LBound(a) AndAlso a(m) > key
			a(m + 1) = a(m)
			m -= 1
		Wend
		a(m + 1) = key
	Next
End Sub

Private Function IsSortedLong(arr() As Long) As Boolean
	For j As Long = LBound(arr) + 1 To UBound(arr)
		If arr(j - 1) > arr(j) Then Return False
	Next
	Return True
End Function

Private Function IsSortedDouble(arr() As Double) As Boolean
	For j As Long = LBound(arr) + 1 To UBound(arr)
		If arr(j - 1) > arr(j) Then Return False
	Next
	Return True
End Function

Private Function OkText(ByVal bOk As Boolean) As String
	If bOk Then Return "PASS" Else Return "FAIL"
End Function

Private Sub Show10(arr() As WString)
	Dim As WString sLine
	For i As Long = LBound(arr) To LBound(arr) + 9
		sLine &= " | " & arr(i)
	Next
	Debug.Print sLine, , , , , True
End Sub

Private Sub Show10Num(ByRef sLine As String)
	Debug.Print sLine, , , , , True
End Sub

#ifndef BENCH_SIZE
	#define BENCH_SIZE 100000 ' 10万条测试
#endif
Dim As Long iArraySize = BENCH_SIZE
Dim As WString myStrings(1 To iArraySize)
Dim As Double dStartTime, dEndTime
Dim As Long i

Randomize(TimerHiRes)
For i = 1 To iArraySize
	myStrings(i) = GenerateRandomString(5 + Int(Rnd * 10))
Next i

Debug.Print "=== Test 1: SortStringArray (case-sensitive, ascending) ===", , , , , True
dStartTime = TimerHiRes
SortStringArray(myStrings(), , SORT_ASCENDING)
dEndTime = TimerHiRes
Debug.Print "The first 10 items: ", , , , , True
Show10(myStrings())
Debug.Print "sorted check: " & OkText(IsSortedW(myStrings(), True, SORT_ASCENDING, False)), , , , , True
Debug.Print "elapsed: " & Format(dEndTime - dStartTime, "0.000") & " s", , , , , True

' 随机打乱重排
For i = 1 To iArraySize
	Swap myStrings(i), myStrings(Int(Rnd * iArraySize) + 1)
Next i

Debug.Print !"\n=== Test 2: SortStringArray (case-insensitive, descending) ===", , , , , True
dStartTime = TimerHiRes
SortStringArray(myStrings(), False, SORT_DESCENDING)
dEndTime = TimerHiRes
Debug.Print "The first 10 items: ", , , , , True
Show10(myStrings())
Debug.Print "sorted check: " & OkText(IsSortedW(myStrings(), False, SORT_DESCENDING, False)), , , , , True
Debug.Print "elapsed: " & Format(dEndTime - dStartTime, "0.000") & " s", , , , , True

Debug.Print !"\n=== Test 3: natural sort (numeric aware) ===", , , , , True
For i = 1 To iArraySize
	If i Mod 10 Then
		myStrings(i) = !"-" & WStr(i + Rnd * 10)
	Else
		myStrings(i) = WStr(i + Rnd * 100)
	End If
Next i

dStartTime = TimerHiRes
SortStringArray(myStrings(), , SORT_ASCENDING, True)
dEndTime = TimerHiRes
Debug.Print "The first 10 items (ascending): ", , , , , True
Show10(myStrings())
Debug.Print "sorted check: " & OkText(IsSortedW(myStrings(), True, SORT_ASCENDING, True)), , , , , True
Debug.Print "elapsed: " & Format(dEndTime - dStartTime, "0.000") & " s", , , , , True

' 打乱后测降序
For i = 1 To iArraySize
	Swap myStrings(i), myStrings(Int(Rnd * iArraySize) + 1)
Next i

dStartTime = TimerHiRes
SortStringArray(myStrings(), , SORT_DESCENDING, True)
dEndTime = TimerHiRes
Debug.Print "The first 10 items (descending): ", , , , , True
Show10(myStrings())
Debug.Print "sorted check: " & OkText(IsSortedW(myStrings(), True, SORT_DESCENDING, True)), , , , , True
Debug.Print "elapsed: " & Format(dEndTime - dStartTime, "0.000") & " s", , , , , True

' ==========================================
' 数值类型: 与 Double 插入排序参考实现逐元素比对
' ==========================================
Const SMALLN As Long = 400
Dim As Double ref(0 To SMALLN - 1)
Dim As Boolean bOk

Debug.Print !"\n=== Test 4: radix sorts vs insertion-sort reference ===", , , , , True
Debug.Print "SizeOf: Byte=" & SizeOf(Byte) & " Short=" & SizeOf(Short) & " Integer=" & SizeOf(Integer) & _
            " Long=" & SizeOf(Long) & " LongInt=" & SizeOf(LongInt) & _
            " Single=" & SizeOf(Single) & " Double=" & SizeOf(Double), , , , , True

Dim As Byte vB(1 To SMALLN)
For i = 1 To SMALLN
	vB(i) = CByte(Int(Rnd * 256) - 128)
	ref(i - 1) = vB(i)
Next
RefSortD(ref()) : RadixSortByte(vB())
bOk = True
For i = 1 To SMALLN
	If vB(i) <> ref(i - 1) Then bOk = False
Next
Debug.Print "Byte   : " & OkText(bOk) & "  (1 pass)", , , , , True

Dim As Short vS(1 To SMALLN)
For i = 1 To SMALLN
	vS(i) = CShort(Int(Rnd * 60001) - 30000)
	ref(i - 1) = vS(i)
Next
RefSortD(ref()) : RadixSortShort(vS())
bOk = True
For i = 1 To SMALLN
	If vS(i) <> ref(i - 1) Then bOk = False
Next
Debug.Print "Short  : " & OkText(bOk) & "  (2 passes)", , , , , True

Dim As Integer vI(1 To SMALLN)
For i = 1 To SMALLN
	vI(i) = CLng(Int(Rnd * 60001) - 30000)
	ref(i - 1) = vI(i)
Next
RefSortD(ref()) : RadixSortInteger(vI())
bOk = True
For i = 1 To SMALLN
	If vI(i) <> ref(i - 1) Then bOk = False
Next
Debug.Print "Integer: " & OkText(bOk) & "  (auto width)", , , , , True

Dim As Long vL(1 To SMALLN)
For i = 1 To SMALLN
	vL(i) = CLng(Int(Rnd * 2000001) - 1000000)
	ref(i - 1) = vL(i)
Next
RefSortD(ref()) : RadixSortLong(vL())
bOk = True
For i = 1 To SMALLN
	If vL(i) <> ref(i - 1) Then bOk = False
Next
Debug.Print "Long   : " & OkText(bOk) & "  (4 passes)", , , , , True

Dim As LongInt vLI(1 To SMALLN)
For i = 1 To SMALLN
	vLI(i) = CLngInt(Int(Rnd * 2000001) - 1000000)
	ref(i - 1) = vLI(i)
Next
RefSortD(ref()) : RadixSortLongInt(vLI())
bOk = True
For i = 1 To SMALLN
	If vLI(i) <> ref(i - 1) Then bOk = False
Next
Debug.Print "LongInt: " & OkText(bOk) & "  (8 passes)", , , , , True

Dim As Single vF(1 To SMALLN)
For i = 1 To SMALLN
	vF(i) = CSng(Rnd * 2000 - 1000)
	ref(i - 1) = vF(i)
Next
RefSortD(ref()) : RadixSortSingle(vF())
bOk = True
For i = 1 To SMALLN
	If vF(i) <> ref(i - 1) Then bOk = False
Next
Debug.Print "Single : " & OkText(bOk) & "  (4 passes)", , , , , True

Dim As Double vD(1 To SMALLN)
For i = 1 To SMALLN
	vD(i) = Rnd * 2000 - 1000
	ref(i - 1) = vD(i)
Next
RefSortD(ref()) : RadixSortDouble(vD())
bOk = True
For i = 1 To SMALLN
	If vD(i) <> ref(i - 1) Then bOk = False
Next
Debug.Print "Double : " & OkText(bOk) & "  (8 passes)", , , , , True

' ==========================================
' 大数组计时
' ==========================================
Dim As Long myLong(1 To iArraySize)
Dim As Double myDouble(1 To iArraySize)
For i = 1 To iArraySize
	If i Mod 10 Then
		myLong(i) = -CLng(i + Rnd * 10)
	Else
		myLong(i) = CLng(i + Rnd * 100)
	End If
	myDouble(i) = myLong(i) + Rnd
Next i

Debug.Print !"\n=== Test 5: radix sort timing ===", , , , , True
dStartTime = TimerHiRes
RadixSortLong(myLong())
dEndTime = TimerHiRes
Dim As String sLine = ""
For i = 1 To 10
	sLine &= " | " & Str(myLong(i))
Next
Show10Num(sLine)
Debug.Print "Long  sorted check: " & OkText(IsSortedLong(myLong())) & "  elapsed: " & Format(dEndTime - dStartTime, "0.000") & " s", , , , , True

dStartTime = TimerHiRes
RadixSortDouble(myDouble())
dEndTime = TimerHiRes
sLine = ""
For i = 1 To 10
	sLine &= " | " & Str(myDouble(i))
Next
Show10Num(sLine)
Debug.Print "Double sorted check: " & OkText(IsSortedDouble(myDouble())) & "  elapsed: " & Format(dEndTime - dStartTime, "0.000") & " s", , , , , True

Debug.Print !"\nTest finished.", , , , , True
' 等待按键必须留在 NO_TESTS 里面: 否则本文件被 #include 当函数库用时,
' 宿主程序每次退出都会卡在这里等输入。
Print
Print "Press any key to exit..."
Sleep
#endif