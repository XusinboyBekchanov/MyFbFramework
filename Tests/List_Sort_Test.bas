'###############################################################################
'#  List_Sort_Test.bas                                                         #
'#  Sort correctness for List.bas machinery as reached through the public      #
'#  wrappers: IntegerList.Sort / DoubleList.Sort / PointerList.Sort (radix)    #
'#  and TimSortIndex (stable TimSort over an index array).                     #
'#  Run under BOTH fbc64 and fbc32: IntegerListItem.Value is As Integer,       #
'#  which is 8 bytes on 64-bit and 4 bytes on 32-bit.                          #
'#  Console only, ASCII output, fixed RNG seed.                                #
'###############################################################################
#include once "mff/NoInterface.bi"
#include once "mff/DoubleList.bi"
#include once "mff/IntegerList.bi"
#include once "mff/PointerList.bi"

Dim Shared nFailed As Long

Private Sub Check(ByRef sWhat As String, bOK As Boolean)
	If bOK Then
		Print "  ok - " & sWhat
	Else
		nFailed += 1
		Print "  FAIL - " & sWhat
	End If
End Sub

' ======================== reference sorts (independent) ========================

Private Sub RefSortLong(a() As Long, ByVal lo As Long, ByVal hi As Long)
	'Stable bottom-up merge sort on Long
	Dim n As Long = hi - lo + 1
	If n < 2 Then Exit Sub
	Dim tmp(n - 1) As Long
	Dim wSpan As Long = 1
	Do While wSpan < n
		Dim i As Long = lo
		Do While i <= hi
			Dim iLeft As Long = i
			Dim iMid As Long = i + wSpan - 1
			If iMid > hi Then iMid = hi
			Dim iRight As Long = iMid + wSpan
			If iRight > hi Then iRight = hi
			Dim p As Long = iLeft
			Dim l As Long = iLeft
			Dim r As Long = iMid + 1
			Do While l <= iMid AndAlso r <= iRight
				If a(l) <= a(r) Then
					tmp(p) = a(l): l += 1
				Else
					tmp(p) = a(r): r += 1
				End If
				p += 1
			Loop
			Do While l <= iMid
				tmp(p) = a(l): l += 1: p += 1
			Loop
			Do While r <= iRight
				tmp(p) = a(r): r += 1: p += 1
			Loop
			i += wSpan * 2
		Loop
		For i = lo To hi
			a(i) = tmp(i - lo)
		Next
		wSpan *= 2
	Loop
End Sub

Private Sub RefSortDouble(a() As Double, ByVal lo As Long, ByVal hi As Long)
	'Stable bottom-up merge sort on Double (IEEE total order, NaN excluded)
	Dim n As Long = hi - lo + 1
	If n < 2 Then Exit Sub
	Dim tmp(n - 1) As Double
	Dim wSpan As Long = 1
	Do While wSpan < n
		Dim i As Long = lo
		Do While i <= hi
			Dim iLeft As Long = i
			Dim iMid As Long = i + wSpan - 1
			If iMid > hi Then iMid = hi
			Dim iRight As Long = iMid + wSpan
			If iRight > hi Then iRight = hi
			Dim p As Long = iLeft
			Dim l As Long = iLeft
			Dim r As Long = iMid + 1
			Do While l <= iMid AndAlso r <= iRight
				If a(l) <= a(r) Then
					tmp(p) = a(l): l += 1
				Else
					tmp(p) = a(r): r += 1
				End If
				p += 1
			Loop
			Do While l <= iMid
				tmp(p) = a(l): l += 1: p += 1
			Loop
			Do While r <= iRight
				tmp(p) = a(r): r += 1: p += 1
			Loop
			i += wSpan * 2
		Loop
		For i = lo To hi
			a(i) = tmp(i - lo)
		Next
		wSpan *= 2
	Loop
End Sub

' ======================== IntegerList.Sort (radix) ========================

Private Sub TestIntegerPattern(ByRef sName As String, a() As Long, ByVal n As Long, ByVal iDirection As Long)
	Dim As IntegerList il
	Dim i As Long
	For i = 0 To n - 1
		il.Add a(i)
	Next
	il.Sort(iDirection)
	'Reference
	Dim ref(Any) As Long
	If n > 0 Then ReDim ref(n - 1)
	For i = 0 To n - 1
		ref(i) = a(i)
	Next
	RefSortLong(ref(), 0, n - 1)
	Dim bOK As Boolean = True
	If iDirection >= 0 Then
		For i = 0 To n - 1
			If il.Item(i) <> ref(i) Then bOK = False: Exit For
		Next
	Else
		For i = 0 To n - 1
			If il.Item(i) <> ref(n - 1 - i) Then bOK = False: Exit For
		Next
	End If
	Check "IntegerList.Sort " & sName & " n=" & n & " dir=" & iDirection, bOK
End Sub

Private Sub TestIntegerList
	Randomize 12345
	Dim sizes(13) As Long = {0, 1, 2, 3, 4, 5, 63, 64, 65, 255, 256, 257, 1000, 10000}
	Dim si As Long
	For si = 0 To 13
		Dim n As Long = sizes(si)
		Dim a(Any) As Long
		If n > 0 Then ReDim a(n - 1)
		'Random full signed range incl. cross-sign
		For i As Long = 0 To n - 1
			a(i) = CInt(Rnd * 4294967295.0) - 2147483648
		Next
		TestIntegerPattern("random", a(), n, 1)
		If n > 0 Then
			'Sorted
			RefSortLong(a(), 0, n - 1)
			TestIntegerPattern("sorted", a(), n, 1)
			'Reverse
			Dim i As Long, j As Long
			For i = 0 To n \ 2 - 1
				j = n - 1 - i
				Swap a(i), a(j)
			Next
			TestIntegerPattern("reverse", a(), n, 1)
			'Constant
			For i = 0 To n - 1
				a(i) = 7
			Next
			TestIntegerPattern("constant", a(), n, 1)
			'Two distinct values
			For i = 0 To n - 1
				a(i) = IIf((i And 1) = 0, -3, 3)
			Next
			TestIntegerPattern("two-distinct", a(), n, 1)
			'Extreme signed values (valid on 32- and 64-bit Integer)
			For i = 0 To n - 1
				Select Case i Mod 5
				Case 0: a(i) = -2147483648
				Case 1: a(i) = 2147483647
				Case 2: a(i) = 0
				Case 3: a(i) = -1
				Case 4: a(i) = 1
				End Select
			Next
			TestIntegerPattern("extremes", a(), n, 1)
			'Descending direction on random data
			For i = 0 To n - 1
				a(i) = CInt(Rnd * 4294967295.0) - 2147483648
			Next
			TestIntegerPattern("random", a(), n, -1)
		End If
	Next
End Sub

' ======================== DoubleList.Sort (IEEE754 radix) ========================

Private Sub TestDoublePattern(ByRef sName As String, a() As Double, ByVal n As Long, ByVal iDirection As Long)
	Dim As DoubleList dl
	Dim i As Long
	For i = 0 To n - 1
		dl.Add a(i)
	Next
	dl.Sort(iDirection)
	Dim ref(Any) As Double
	If n > 0 Then ReDim ref(n - 1)
	For i = 0 To n - 1
		ref(i) = a(i)
	Next
	RefSortDouble(ref(), 0, n - 1)
	Dim bOK As Boolean = True
	If iDirection >= 0 Then
		For i = 0 To n - 1
			If dl.Item(i) <> ref(i) Then bOK = False: Exit For
		Next
	Else
		For i = 0 To n - 1
			If dl.Item(i) <> ref(n - 1 - i) Then bOK = False: Exit For
		Next
	End If
	Check "DoubleList.Sort " & sName & " n=" & n & " dir=" & iDirection, bOK
End Sub

Private Sub TestDoubleList
	Randomize 67890
	Dim sizes(9) As Long = {0, 1, 2, 3, 64, 65, 255, 256, 1000, 5000}
	Dim si As Long
	For si = 0 To 9
		Dim n As Long = sizes(si)
		Dim a(Any) As Double
		If n > 0 Then ReDim a(n - 1)
		'Random across magnitudes and signs (no NaN, no +-0 in the random set)
		For i As Long = 0 To n - 1
			Dim p As Double = Rnd * 2 - 1
			Dim e As Double = CInt(Rnd * 60.0) - 30
			a(i) = p * (2 ^ e)
		Next
		TestDoublePattern("random", a(), n, 1)
		If n > 0 Then
			Dim i As Long, j As Long
			RefSortDouble(a(), 0, n - 1)
			TestDoublePattern("sorted", a(), n, 1)
			For i = 0 To n \ 2 - 1
				j = n - 1 - i
				Swap a(i), a(j)
			Next
			TestDoublePattern("reverse", a(), n, 1)
			For i = 0 To n - 1
				a(i) = 1.5
			Next
			TestDoublePattern("constant", a(), n, 1)
			'Special values: +-Inf, +-DBL_MAX, denormal, duplicates
			For i = 0 To n - 1
				Select Case i Mod 7
				Case 0: a(i) = -1.0 / 0.0
				Case 1: a(i) = 1.0 / 0.0
				Case 2: a(i) = -1.7976931348623157e308
				Case 3: a(i) = 1.7976931348623157e308
				Case 4: a(i) = 5e-324
				Case 5: a(i) = -0.5
				Case 6: a(i) = 0.5
				End Select
			Next
			TestDoublePattern("specials", a(), n, 1)
			TestDoublePattern("specials", a(), n, -1)
		End If
	Next
	'-0.0 sorts before +0.0 under the IEEE754 key mapping (strict order)
	Dim As DoubleList dz
	'-0.0 through a variable: fbc folds a -0.0 literal argument to +0.0
	Dim As Double dPosZero = 0.0, dNegZero = -dPosZero
	dz.Add dPosZero
	dz.Add dNegZero
	dz.Sort(1)
	Dim d0 As Double = dz.Item(0)
	Dim d1 As Double = dz.Item(1)
	Dim bNeg0First As Boolean
	bNeg0First = (*Cast(ULongInt Ptr, @d0) Shr 63) = 1 AndAlso (*Cast(ULongInt Ptr, @d1) Shr 63) = 0
	Check "DoubleList -0.0 before +0.0", bNeg0First
End Sub

' ======================== PointerList.Sort (address key) ========================

Private Sub TestPointerList
	Randomize 24680
	Dim As PointerList pl
	Dim n As Long = 1000
	'Keys use the POINTER-WIDTH unsigned type (UInteger): 4 bytes on 32-bit,
	'8 bytes on 64-bit - only such values can round-trip through Any Ptr
	Dim keys(n - 1) As UInteger
	Dim i As Long
	For i = 0 To n - 1
		keys(i) = CUInt(Rnd * 65535.0)
		pl.Add(Cast(Any Ptr, keys(i)))
	Next
	'Reference: the values are small enough for a Long reference sort
	Dim ref(n - 1) As Long
	For i = 0 To n - 1
		ref(i) = CLng(keys(i))
	Next
	RefSortLong(ref(), 0, n - 1)
	pl.Sort(1)
	'PointerList.Item returns the stored value (Any Ptr) directly
	Dim bOK As Boolean = True
	For i = 0 To n - 1
		If Cast(UInteger, pl.Item(i)) <> ref(i) Then bOK = False: Exit For
	Next
	Check "PointerList.Sort ascending", bOK
	pl.Sort(-1)
	For i = 0 To n - 1
		If Cast(UInteger, pl.Item(i)) <> ref(n - 1 - i) Then bOK = False: Exit For
	Next
	Check "PointerList.Sort descending", bOK
	'Multiset preserved
	Dim total As UInteger = 0
	Dim totalRef As UInteger = 0
	For i = 0 To n - 1
		total += Cast(UInteger, pl.Item(i))
		totalRef += keys(i)
	Next
	Check "PointerList multiset preserved", total = totalRef
End Sub

' ======================== TimSortIndex (stable) ========================

Dim Shared RefKeys(9999) As Long
Dim Shared RefSeq(9999) As Long

Private Function TimCmp(ByVal a As Long, ByVal b As Long, ByVal ctx As Any Ptr) As Long
	If RefKeys(a) < RefKeys(b) Then Return -1
	If RefKeys(a) > RefKeys(b) Then Return 1
	Return 0
End Function

Private Sub TestTimSortIndex
	Randomize 13579
	Dim sizes(7) As Long = {0, 1, 2, 3, 64, 65, 257, 10000}
	Dim si As Long
	For si = 0 To 7
		Dim n As Long = sizes(si)
		Dim i As Long
		'Few distinct keys with a recorded insertion sequence: stability check
		For i = 0 To n - 1
			RefKeys(i) = CInt(Rnd * 10.0)
			RefSeq(i) = i
		Next
		Dim idx(Any) As Long
		If n > 0 Then ReDim idx(n - 1)
		If n > 0 Then TimSortIndex(@idx(0), n, @TimCmp, 1, 0)
		Dim bOK As Boolean = True
		For i = 1 To n - 1
			If RefKeys(idx(i - 1)) > RefKeys(idx(i)) Then bOK = False: Exit For
		Next
		Check "TimSortIndex sorted n=" & n, bOK
		'Stability (ascending): equal keys keep insertion order
		bOK = True
		For i = 1 To n - 1
			If RefKeys(idx(i - 1)) = RefKeys(idx(i)) AndAlso RefSeq(idx(i - 1)) > RefSeq(idx(i)) Then
				bOK = False
				Exit For
			End If
		Next
		Check "TimSortIndex stable n=" & n, bOK
		'Permutation check: every index appears exactly once
		bOK = True
		Dim seen(Any) As Long
		If n > 0 Then ReDim seen(n - 1)
		For i = 0 To n - 1
			If idx(i) < 0 OrElse idx(i) >= n Then bOK = False: Exit For
			seen(idx(i)) += 1
			If seen(idx(i)) > 1 Then bOK = False: Exit For
		Next
		Check "TimSortIndex permutation n=" & n, bOK
		'Descending direction: correctness only (run reversal is not stable by design)
		For i = 0 To n - 1
			RefKeys(i) = CInt(Rnd * 100.0)
		Next
		If n > 0 Then TimSortIndex(@idx(0), n, @TimCmp, -1, 0)
		bOK = True
		For i = 1 To n - 1
			If RefKeys(idx(i - 1)) < RefKeys(idx(i)) Then bOK = False: Exit For
		Next
		Check "TimSortIndex descending n=" & n, bOK
	Next
End Sub

	TestIntegerList
	TestDoubleList
	TestPointerList
	TestTimSortIndex
	Print IIf(nFailed = 0, "PASS", "FAIL")
	End
