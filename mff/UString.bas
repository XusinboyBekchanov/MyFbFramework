#include once "UString.bi"

#ifdef __USE_WASM__
	#define GrowLength 2
#else
	#define GrowLength 1
#endif

Private Constructor UString()
	m_Length = 0
	m_BytesCount = SizeOf(WString)
	m_Data = _Allocate(SizeOf(WString))
	If m_Data <> 0 Then
		m_Data[0] = 0
	End If
End Constructor

Private Constructor UString(ByRef Value As WString)
	m_Length = Len(Value)
	m_BytesCount = (m_Length + 1) * SizeOf(WString) * GrowLength
	m_Data = _Allocate(m_BytesCount)
	If m_Data <> 0 Then
		*m_Data = Value
	End If
End Constructor

Private Constructor UString(ByRef Value As UString)
	m_Length = Value.m_Length
	m_BytesCount = Value.m_BytesCount
	m_Data = _Allocate(m_BytesCount)
	If m_Data <> 0 Then
		*m_Data = *Value.m_Data
	End If
End Constructor

Private Destructor UString
	If m_Data <> 0 Then
		_Deallocate(m_Data)
	End If
End Destructor

Private Function UString.StartsWith(ByRef Value As WString) As Boolean
	'Return Left(*m_Data, Value.m_Length) = * (Value.vptr)
	Dim As Integer vLen = Len(Value)
	If m_Length < vLen Then Return False
	For i As Integer = 0 To vLen - 1
		If (*m_Data)[i] <> Value[i] Then Return False
	Next
	Return True
End Function

Private Function UString.EndsWith(ByRef Value As WString) As Boolean
	'Return Right(*m_Data, Value.m_Length) = * (Value.vptr)
	Dim As Integer vLen = Len(Value)
	If m_Length < vLen Then Return False
	Dim j As Integer = m_Length - vLen
	For i As Integer = 0 To vLen - 1
		If (*m_Data)[j] <> Value[i] Then Return False
		j += 1
	Next
	Return True
End Function

Private Function UString.Contains(ByRef Value As WString) As Boolean
	Return InStr(*m_Data, Value) > 0
End Function

Private Function UString.ToLower As UString
	Return LCase(*m_Data)
End Function

Private Function UString.ToUpper As UString
	Return UCase(*m_Data)
End Function

Private Function UString.TrimAll As UString
	Return Trim(*m_Data, Any !"\t ")
End Function

Private Function UString.TrimEnd As UString
	Return RTrim(*m_Data, Any !"\t ")
End Function

Private Function UString.TrimStart As UString
	Return LTrim(*m_Data, Any !"\t ")
End Function

Private Function UString.SubString(ByVal start As Integer, ByVal n As Integer, ByRef expression As Const String = "") As UString
	If expression = "" Then
		Return Mid(*m_Data, start, n)
	Else
		Mid(*m_Data, start, n) = expression
		m_Length = Len(*m_Data)
		m_BytesCount = (m_Length + 1) * SizeOf(WString) *  GrowLength
		Return *m_Data
	End If
End Function
#if MEMCHECK
	#define WReAllocate(subject, lLen) If subject <> 0 Then: subject = _Reallocate(subject, (lLen + 1) * SizeOf(WString) * GrowLength): Else: subject = _Allocate((lLen + 1) * SizeOf(WString) * GrowLength): End If
#define WLet(subject, txt) Scope: Dim As UString txt1 = txt: WReAllocate(subject, Len(txt1)): *subject = txt1: End Scope
#define WDeAllocate(subject) If subject <> 0 Then: _Deallocate(subject): End If: subject = 0
#define ZLet(subject, txt) Scope: subject = Reallocate(subject, (Len(txt) + 1) * SizeOf(ZString)): *subject = txt1: End Scope
#define ZDeAllocate(subject) If subject <> 0 Then: _Deallocate(subject): End If: subject = 0
#else
	Private Sub WReAllocate(ByRef subject As WString Ptr, lLen As Integer)
		If subject <> 0 Then
			#ifdef __USE_GTK__
				subject = _Reallocate(subject, (lLen + 1) * SizeOf(WString) * GrowLength) 'Cast(WString Ptr, )
			#else
				_Deallocate(subject)
				subject = _Allocate((lLen + 1) * SizeOf(WString) * GrowLength)
			#endif
		Else
			subject = _Allocate((lLen + 1) * SizeOf(WString) * GrowLength) 'Cast(WString Ptr, )
		End If
	End Sub
	
	Private Sub ZLet(ByRef subject As ZString Ptr, ByRef txt As ZString)
		subject = Reallocate(subject, (Len(txt) + 1) * SizeOf(ZString))
		*subject = txt
	End Sub
	
	Private Sub ZDeAllocate(ByRef subject As ZString Ptr)
		If subject <> 0 Then Deallocate(subject)
		subject = 0
	End Sub
	
	Private Sub WLet(ByRef subject As WString Ptr, ByRef txt As WString)
		WReAllocate(subject, Len(txt))
		*subject = txt
	End Sub
	
	Private Sub WDeAllocate Overload(ByRef subject As WString Ptr)
		If subject <> 0 Then _Deallocate(subject)
		subject = 0
	End Sub
#endif

Private Sub WDeAllocateEx Overload(subject() As WString Ptr)
	For i As Integer = 0 To UBound(subject)
		'If subject(i) <> 0 Then Deallocate(subject(i))
		subject(i) = 0
	Next
End Sub

' Using WLetEx if the length of target is longer than the length of source.
Private Sub WLetEx(ByRef subject As WString Ptr, ByRef txt As WString, ExistsSubjectInTxt As Boolean = True)
	If ExistsSubjectInTxt Then
		Dim As WString Ptr TempWStr = _Allocate((Len(txt) + 1) * SizeOf(WString) * GrowLength)
		If TempWStr > 0 Then
			*TempWStr = txt
			WDeAllocate(subject)
			subject = TempWStr
		End If
	Else
		WReAllocate(subject, Len(txt))
		*subject = txt
	End If
End Sub

#ifndef WAdd_Off
	Private Sub WAdd(ByRef subject As WString Ptr, ByRef txt As WString, AddBefore As Boolean = False)
		Dim TempWStr As WString Ptr
		If AddBefore Then
			WLet(TempWStr, txt & WGet(subject))
		Else
			WLet(TempWStr, WGet(subject) & txt)
		End If
		WDeAllocate(subject)
		subject = TempWStr
	End Sub
#endif

Private Sub UString.Resize(NewLength As Integer)
	'If NewLength > m_Length Then
	m_BytesCount = (NewLength + 1) * SizeOf(WString) * GrowLength
	If m_Length < NewLength Then
		WReAllocate(m_Data, NewLength)
	End If
	m_Length = NewLength
	'		If m_Data <> 0 Then
	'			Deallocate_(m_Data)
	'		End If
	'		m_Data = Allocate_(m_BytesCount)
	'End If
End Sub

Private Function UString.AppendBuffer(ByVal addrMemory As Any Ptr, ByVal NumBytes As ULong) As Boolean
	This.Resize(m_Length + NumBytes)
	If m_Data = 0 Then Return False
	#ifdef __USE_WINAPI__
		memcpy(m_Data + m_BufferLen, addrMemory, NumBytes)
	#else
		Fb_MemCopy(* (m_Data + m_BufferLen), addrMemory, NumBytes)
	#endif
	m_BufferLen += NumBytes
	Return True
End Function

Private Operator UString.[](ByVal Index As Integer) ByRef As UShort
	Static Zero As UShort = 0
	If Index < 0 Or Index > m_Length Then Return Zero
	Operator = *Cast(UShort Ptr, m_Data + (Index * 2))
End Operator

Private Operator UString.Let(ByRef lhs As UString)
	If @This <> @lhs Then
		If lhs.m_Length > m_Length Then
			If m_Data <> 0 Then
				_Deallocate(m_Data)
			End If
			m_Data = _Allocate(lhs.m_BytesCount)
		End If
		m_Length = lhs.m_Length
		m_BytesCount = lhs.m_BytesCount
		m_BufferLen = lhs.m_BufferLen
		
		If m_Data <> 0 Then
			*m_Data = *lhs.m_Data
		End If
	End If
End Operator

Private Operator UString.Let(ByRef lhs As WString)
	Resize Len(lhs)
	If m_Data <> 0 Then
		*m_Data = lhs
		m_BufferLen = Len(lhs) * 2
	End If
End Operator

Private Operator UString.Let(ByRef Value As Const ZString)
	Resize Len(Value)
	If m_Data <> 0 Then
		*m_Data = Value
		m_BufferLen = Len(Value) * 2
	End If
End Operator

Private Property UString.Length() As Integer
	Return m_Length
End Property

Private Operator UString.Cast() ByRef As WString
	Return *m_Data
End Operator

Private Operator UString.Cast() As Any Ptr
	Return CPtr(Any Ptr, m_Data)
End Operator

Private Function UString.vptr As WString Ptr
	Return m_Data
End Function

Private Function Val Overload(ByRef subject As UString) As Double
	Return Val(*(subject.vptr))
End Function

Private Operator Len(ByRef lhs As UString) As Integer
	Return Len(*lhs.vptr)
End Operator

Private Function WStrPtr(ByRef Value As UString) As WString Ptr
	Return Value.vptr
End Function

Private Operator & (ByRef lhs As UString, ByRef rhs As UString) As UString
	Return *(lhs.vptr) & *(rhs.vptr)
End Operator

Private Function Left Overload(ByRef subject As UString, ByVal n As Integer) As UString
	Return Left(*(subject.vptr), n)
End Function

#ifndef Replace_Off
	'Private Function tallynumW Overload(ByRef somestring As WString, ByRef partstring As WString) As Integer
	'	Dim As Integer i, j, ln, lnp, count, num
	'	ln=Len(somestring):If ln=0 Then Return 0
	'	lnp=Len(partstring):If lnp=0 Then Return 0
	'	count=0
	'	i=-1
	'	Do
	'		i+=1
	'		If somestring[i] <> partstring[0] Then Continue Do
	'		If somestring[i] = partstring[0] Then
	'			For j=0 To lnp-1
	'				If somestring[j+i]<>partstring[j] Then Continue Do
	'			Next j
	'		End If
	'		count+=1
	'		i=i+lnp-1
	'	Loop Until i>=ln-1
	'	Return count
	'End Function
	
	
	'
	'Parameters
	'   Expression
	'       String expression containing substring to replace.
	'   FindingText
	'       Substring being searched for.
	'   ReplacingText
	'       Replacement substring.
	'   Start
	'       Start position for the substring of Expression to be searched and returned. If omitted, 1 is assumed.
	'   Count
	'       Number of substring substitutions to perform. If omitted, the default value is -1, which means, make all possible substitutions.
	'   MatchCase
	'       Boolean value indicating the kind of comparison to use when evaluating substrings.
	
	'Returns a string, which is a substring of a string expression beginning at the start position (defaults to 1), in which a specified substring has been replaced with another substring a specified number of times.
	Private Function Replace(ByRef Expression As WString, ByRef FindingText As WString, ByRef ReplacingText As WString, ByVal Start As Integer = 1, ByVal Count As Integer = -1, MatchCase As Boolean = True, ByRef CountReplaced As Integer = 0) As UString
		If Len(FindingText) = 0 Then Return Expression
		Dim As WString Ptr original, find
		If MatchCase Then
			original = @Expression
			find = @FindingText
		Else
			WLet(original, LCase(Expression))
			WLet(find, LCase(FindingText))
		End If
		Dim As Integer i, j, ln, lnp, countof, num
		ln = Len(*original) * GrowLength: 'If ln = 0 Then Return 0
		lnp = Len(*find) * GrowLength: 'If lnp = 0 Then Return 0
		countof = 0
		If ln <> 0 AndAlso lnp <> 0 Then
			i = -1
			Do
				i += 1
				If (*original)[i] <> (*find)[0] Then Continue Do
				If (*original)[i] = (*find)[0] Then
					For j = 0 To lnp - 1
						If (*original)[j + i] <> (*find)[j] Then Continue Do
					Next j
				End If
				countof += 1
				i = i + lnp - 1
			Loop Until i >= ln - 1
		End If
		Var t = countof 'tallynumW(*original, *find)                 'find occurencies of find
		If t = 0 Then Return Expression
		Dim As Long found, n, staid, m, c
		Var Lf = Len(FindingText) * GrowLength, Lr = Len(ReplacingText) * GrowLength, Lo = Len(Expression) * GrowLength
		t = Len(Expression) * GrowLength - t * Lf + t * Lr               'length of output string
		Dim As UString res
		res.Resize t                                        'output string
		Dim As WString Ptr wres = res.vptr
		n = Start - 1
		For i As Integer = 0 To n - 1
			(*wres)[i] = Expression[i]
		Next
		Do
			If c = Count Then Goto lbl
			If (*original)[n] = (*find)[0] Then             'got a possible
				For m = 0 To Lf - 1
					If (*original)[n + m] <> (*find)[m] Then Goto lbl 'no
				Next m
				found = 1                                   'Bingo
			End If
			If found Then
				For m = 0 To Lr - 1
					(*wres)[staid] = ReplacingText[m]   'insert the replacerment
					staid += 1
				Next m
				n += Lf
				found = 0
				c += 1
				Continue Do
			End If
			lbl:
			(*wres)[staid] = Expression[n]
			staid += 1
			n += 1
		Loop Until n >= Lo
		(*wres)[staid] = 0
		CountReplaced = c
		If Not MatchCase Then
			WDeAllocate(original)
			WDeAllocate(find)
		End If
		Return *wres
	End Function
#endif

'Dereferences a WString pointer to <a href="https://www.freebasic.net/wiki/KeyPgWString">WString</a>.
'
'Parameters
'   subject
'       WString Pointer to dereference. If the value is NULL, zero-length string ("") is returned.
'
'Example
'#include "mff/UString.bi"
'
'Dim p As WString Ptr
'
'Print WGet(p)
'
'p = Allocate(SizeOf(WString) * 5)
'
'*p = "Good"
'
'Print WGet(p)
'
'Delete p
'
'Sleep
'
'See also
'   iGet
'   ZGet
Private Function WGet(ByRef subject As WString Ptr) ByRef As WString
	If subject = 0 Then Return WStr("") Else Return *subject
End Function

Private Function ToUtf8(ByRef nWString As WString) As String
	'	#ifdef __USE_GTK__
	'		Static As gchar Ptr s = NULL
	'		Dim As GError Ptr Error1 = NULL
	'		Dim As gsize r_bytes, w_bytes
	'		Dim As ZString Ptr fc
	'		Dim As gchar Ptr from_codeset = NULL
	'
	'		If nWString = "" Then Return ""
	'		'If (t = 0) Then g_assert_not_reached()
	'		'If (g_utf8_validate(Cast(gchar Ptr, @nWString), -1, NULL)) Then Return nWString
	'
	'		/' so we got a non-UTF-8 '/
	'
	'		If Len(Environ("SMB_CODESET")) <> 0 Then
	'			from_codeset = g_strdup(Environ("SMB_CODESET"))
	'		Else
	'			g_get_charset(@fc)
	'			If (fc) Then
	'				from_codeset = g_strdup(fc)
	'			Else
	'				from_codeset = g_strdup("ISO-8859-1")
	'			End If
	'		End If
	'
	'		If *from_codeset = "ISO-" Then
	'			g_free(from_codeset)
	'			from_codeset = g_strdup("ISO-8859-1")
	'		End If
	'		If (s) Then g_free(s)
	'
	''		For c As Integer = 0 To Len(nWString)
	''			If (@nWString)[c] < 32 AndAlso (@nWString)[c] <> Asc(!"\n") Then (@nWString)[c] = Asc(" ")
	''		Next
	'		s = g_convert(nWString, Len(nWString), "UTF-8", from_codeset, @r_bytes, @w_bytes, @Error1)
	'		g_free(from_codeset)
	'
	''		If (s = 0) Then
	''			s = g_strdup(Cast(gchar Ptr, @nWString))
	''			For c As Integer = 0 To Len(*s)
	''				If s[c] > 128 Then s[c] = Asc("?")
	''			Next
	''		End If
	'		If (Error1) Then
	'			'Print ("DBG: %s. Codeset for system is: %s\n", Error->message,from_codeset)
	'			'Print ("DBG: You should set the environment variable SMB_CODESET To ISO-8859-1\n")
	'			g_error_free(Error1)
	'		End If
	'		Return *s
	'		'Return *g_locale_to_utf8(nWString, Len(nWString), 0, 0, 0)
	'	#else
	'		Dim cbLen As Integer
	'		Dim m_BufferLen As Integer = Len(nWString)
	'		If m_BufferLen = 0 Then Return ""
	'		Dim buffer As String = String(m_BufferLen * 5 + 1, 0)
	'		Return *Cast(ZString Ptr, WCharToUTF(1, @nWString, m_BufferLen * 2, StrPtr(buffer), @cbLen))
	Dim As Integer m_BufferLen = Len(nWString)
	Dim i1 As ULong = m_BufferLen * 5 + 1                   'if all unicode chars use 5 bytes in utf8
	Dim As String ansiStr = String(i1, 0)
	#ifdef __USE_WINAPI__
		Dim As Integer iLen = WideCharToMultiByte(CP_UTF8, 0, @nWString, m_BufferLen, StrPtr(ansiStr), Len(ansiStr), NULL, NULL)
		If iLen Then Return Left(ansiStr, iLen) Else Return ""
	#else
		Return *Cast(ZString Ptr, WCharToUTF(1, @nWString, m_BufferLen, StrPtr(ansiStr), Cast(Integer Ptr, @i1)))
	#endif
End Function

Private Function FromUtf8(pZString As ZString Ptr) As WString Ptr
	'	#ifdef __USE_GTK__
	'		Return g_locale_from_utf8(*pZString, Len(*pZString), 0, 0, 0)
	'	#else
	'UTF-8: EF BB BF
	'UTF-16: FF FE
	'UTF-16 big-endian: FE FF
	'UTF-32 little-endian: FF FE 00 00
	'UTF-32 big-endian: 00 00 FE FF
	Dim m_BufferLen As Integer = IIf(pZString <> 0, Len(*pZString) + 1, 0)
	If m_BufferLen = 0 Then Return 0
	Dim As WString Ptr buffer
	WReAllocate(buffer, m_BufferLen)
	*buffer = String(m_BufferLen, 0)
	Return UTFToWChar(1, pZString, buffer, @m_BufferLen)
End Function

Function FromHexStrUnicode(ByRef HexString As WString) As String
	If InStr(HexString, "\u") < 1 OrElse HexString = "" Then Return HexString
	Dim As WString Ptr Result
	Dim As Integer codePoint, iStart, iLen = Len(HexString)
	iStart = InStr(HexString, "!")
	If iStart > 0 Then WLet(Result, Mid(HexString, 1, iStart - 1) & Chr(34)) Else iStart = 0
	For i As Integer = iStart To iLen - 1
		If HexString[i] = 92 AndAlso HexString[i + 1] = 117 AndAlso ((HexString[i + 3] > 47 AndAlso HexString[i + 3] < 58) OrElse (HexString[i + 3] > 64 AndAlso HexString[i + 3] < 91)) Then 'Asc("u")
			codePoint = Val("&h" & Chr(HexString[2 + i]) & Chr(HexString[3 + i]) & Chr(HexString[4 + i]) & Chr(HexString[5 + i]))
			If codePoint < 32 Then  codePoint = 32
			WAdd(Result, WChr(codePoint))
			i += 5
		Else
			If i > iStart Then WAdd(Result, WChr(HexString[i]))
		End If
	Next
	Function = *Result
	Deallocate Result
End Function

Function ToHexStrUnicode(ByRef iString As WString) As String
	If Len(iString) = 0 Then Return ""
	Dim rr As String = "!"""
	Dim As Integer iStart = 0, i
	'Skip it if the first letter is chr(34)
	iStart = InStr(iString, Chr(34))
	If iStart > 0 Then rr = Mid(iString, 1, iStart - 1) & "!""" Else iStart = 0
	For i = iStart To Len(iString) - 1
		rr &= "\u" & Hex(iString[i], 4)
		If iString[i + 1] = 34 Then
			i += 1
			rr &= Mid(iString, i + 1)
			Return rr
		End If
	Next
	rr &= """" & Mid(iString, i + 1)
	Return rr
End Function

Function FromHexStrUTF8(ByRef HexString As WString) As String
	If HexString = "" Then Return ""
	Dim As Integer IPos2, iPos1, iPos = InStr(HexString, "CH_"), iLen = Len(HexString)
	If iPos < 1 OrElse iLen < 6 OrElse iPos > iLen - 4 Then Return HexString
	If HexString[iPos + 2] = 95 OrElse HexString[iPos + 3] = 95 Then Return HexString
	iPos1 = InStr(iPos + 4, HexString, "_")
	If iPos1 < 1 Then Return HexString
	IPos2 = InStr(iPos + 1, HexString, Any ".# ->=+-*/\()[]{},?'""^&!$@")
	'Print "IPos2 < iPos1", IPos2, iPos1, iPos
	If IPos2 > 0 AndAlso IPos2 < iPos1 Then Return HexString
	Dim As Integer codePoint, iStart, byteCount
	Dim As ZString Ptr ResultUTF8Ptr = Allocate((iLen * 2 + 1) * SizeOf(ZString))
	Dim As WString Ptr Result
	Dim As Boolean bFlag
	For i As Integer = 0 To iLen - 1
		If HexString[i] < 32 Then HexString[i] = 32
		If bFlag = False AndAlso HexString[i] = 67 AndAlso HexString[i + 1] = 72 AndAlso HexString[i + 2] = 95 AndAlso InStr(i + 3, HexString, "_") > 0 AndAlso HexString[i + 4] < 127 AndAlso HexString[i + 4] > 47 Then
			WAdd(Result, "_L_")
			i += 2
			bFlag = True
			byteCount = 0
			Continue For
		End If
		If bFlag Then
			If HexString[i] = 95 Then 'Asc("_") Then
				ResultUTF8Ptr[byteCount] = 0
				ResultUTF8Ptr[byteCount + 1] = 0
				WAdd(Result, FromUtf8(ResultUTF8Ptr) & "_")
				i -= 1
				bFlag = False
			End If
			ResultUTF8Ptr[byteCount] = Val("&h" + Chr(HexString[i]) & Chr(HexString[i + 1]))
			byteCount += 1
			i += 1
		Else
			WAdd(Result, WChr(HexString[i]))
		End If
		If HexString[i] = 0 Then Exit For
	Next
	Deallocate ResultUTF8Ptr
	Function = *Result
	Deallocate Result
End Function

Function ToHexStrUTF8(ByRef iString As WString) As String
	If iString = "" Then Return ""
	Dim As Integer IPos2, iPos1, iPos = InStr(iString, "_L_"), iLen = Len(iString)
	If iPos < 1 OrElse iPos > iLen - 4 Then Return iString
	If iString[iPos + 2] = 95 OrElse iString[iPos + 3] = 95 Then Return iString
	iPos1 = InStr(iPos + 4, iString, "_")
	If iPos1 < 1 Then Return iString
	IPos2 = InStr(iPos + 1, iString, Any ".# ->=+-*/\()[]{},?'""^&!$@")
	If IPos2 > 0 AndAlso IPos2 < iPos1 Then Return iString
	
	Dim As WString Ptr ResultUTF8Ptr, Result
	Dim As String ResultUTF8 = ""
	Dim As Integer iStart, byteCount
	Dim As Boolean bFlag
	For i As Integer = 0 To iLen
		If bFlag = False AndAlso i < iLen - 3 AndAlso iString[i] = 67 AndAlso iString[i + 1] = 72 AndAlso iString[i + 2] = 95 AndAlso InStr(i + 3, iString, "_") > 0 AndAlso iString[i + 4] > 64 Then
			WAdd(Result, "CH_")
			WLet(ResultUTF8Ptr, String(iLen * 3, 0))
			i += 2
			bFlag = True
			byteCount = 0
			Continue For
		End If
		If bFlag Then
			If iString[i] = 95 Then 'Asc("_") Then
				ResultUTF8Ptr[byteCount] = 0
				ResultUTF8 = ToUtf8(*ResultUTF8Ptr)
				For j As Integer = 0 To Len(ResultUTF8) - 1
					WAdd(Result, Hex(iString[j], 3))
				Next
				WAdd(Result, "_")
				i -= 1
				bFlag = False
			End If
			ResultUTF8Ptr[byteCount] = WChr(iString[i])
			byteCount += 1
		Else
			WAdd(Result, WChr(iString[i]))
		End If
		If iString[i] = 0 Then Exit For
	Next
	Deallocate ResultUTF8Ptr
	Function = *Result
	Deallocate Result
End Function

Private Function ZGet(ByRef subject As ZString Ptr) As String
	If subject = 0 Then Return ""
	Return *subject
End Function

Private Function StrLSet(ByRef MainStr As Const WString, ByVal StringLength As Long, ByRef PadCharacter As Const WString = " ") As UString
	Dim strn As UString = WString(StringLength, PadCharacter)
	Mid(strn, 1, Len(MainStr)) = MainStr
	Return strn
End Function

Private Function StrRSet(ByRef MainStr As Const WString, ByVal StringLength As Long, ByRef PadCharacter As Const WString = " ") As UString
	If Len(MainStr) > StringLength Then Return Left(MainStr, StringLength)
	Dim strn As UString = WString(StringLength, PadCharacter)
	Mid(strn, StringLength - Len(MainStr) + 1, Len(MainStr)) = MainStr
	Return strn
End Function

#ifndef StringParseCount_Off
	' ========================================================================================
	' * Returns the count of delimited fields from a string expression.
	' If wszMainStr is empty (a null string) or contains no delimiter character(s), the string
	' is considered to contain exactly one sub-field. In this case, AfxStrParseCount returns the value 0.
	' Delimiter contains a string (one or more characters) that must be fully matched.
	' Delimiters are case-sensitive.
	' Example: StringParseCount("one,two,three", ",")   -> 3
	' ========================================================================================
	Private Function StringParseCount(ByRef MainStr As WString, ByRef Delimiter As Const WString = ",", MatchCase As Boolean = True) As Long
		If MainStr = "" OrElse Delimiter = "" Then Return 1
		Dim nCount As Long = 1
		Dim nPos As Long = 1
		Do
			If MatchCase Then
				nPos = InStr(nPos, MainStr, Delimiter)
			Else
				nPos = InStr(nPos, UCase(MainStr), UCase(Delimiter))
			End If
			If nPos = 0 Then Exit Do
			nCount += 1
			nPos += Len(Delimiter)
		Loop
		Return nCount
	End Function
	
	Private Function InStrCount(ByRef subject As WString, ByRef searchtext As WString, start As Integer = 1, MatchCase As Boolean = True) As Long
		Return StringParseCount(subject, searchtext, MatchCase) - 1
	End Function
#endif

'Function InStrPos(ByRef subject As WString, ByRef searchtext() AS Wstring, start As Integer = 1) As Integer
'FOr i As Integer = 1 To Len(subject)
'For j As Integer = 0 To Ubound(searchtext)
'If Mid(subject, i, Len(searchtext(j)) = searchtext(j) Then Return i
'Next j
'Next
'Return 0
'End Function
'
'Function InStrRevPos(ByRef subject As WString, ByRef searchtext() AS Wstring, start As Integer = 1) As Integer
'FOr i As Integer = Len(subject) To 1 Step -1
'For j As Integer = 0 To Ubound(searchtext)
'If Mid(subject, i, Len(searchtext(j)) = searchtext(j) Then Return i
'Next j
'Next
'Return 0
'End Function

'Private Function Replace Overload(ByRef wszMainStr As WString, ByRef wszMatchStr As Const WString, ByRef wszReplaceWith As Const WString, ByVal Start As Integer = 1, ByRef Count As Integer = 0, MatchCase As Boolean = True) As String
'	If wszMainStr = "" OrElse wszMatchStr = "" OrElse wszMatchStr = wszReplaceWith Then Return wszMainStr
'	Dim As WString Ptr TempString
'	WLet TempString, wszMainStr
'	Dim nLenReplaceWith As Long = Len(wszReplaceWith)
'	Dim nLen As Long = Len(wszMatchStr)
'	If Start < 0 Then Start = nLen + Start + 1
'	Dim As Long nPos = Start, C =0
'	Do
'		C += 1
'		If MatchCase Then
'			nPos = InStr(nPos, *TempString, wszMatchStr)
'		Else
'			nPos = InStr(nPos, UCase(*TempString), UCase(wszMatchStr))
'		End If
'		If nPos = 0 Then Exit Do
'		WLet TempString, Mid(*TempString, 1, nPos - 1) + wszReplaceWith + Mid(*TempString, nPos + nLen)
'		nPos += nLenReplaceWith
'	Loop
'	Count = C
'	Function = *TempString
'	Deallocate TempString
'End Function
'
'' ========================================================================================
'' * Within a specified string, replace all occurrences of any of the individual string
'' specified in the wszMainStr string.
'' Will skip the one which is one of the wszReplaceWith
'' Example: ReplaceAny("abacadabra", "abc", "*")  ->  a*aa*aada*ara   ' -> *****d**r*
'' Example: ReplaceAny("abacadabefra", "ab|bc|ef", "*")  ->  a*aa*aada*ara   ' ->
'' ========================================================================================
'Private Function Replace Overload(ByRef wszMainStr As WString, MatchedStr() As WString Ptr, ReplaceWith() As WString Ptr, ByVal Start As Integer = 1, ByRef Count As Integer = 0, MatchCase As Boolean = True) As String
'	Dim As Long i = 1, nLen = Len(wszMainStr), nLen1 = UBound(MatchedStr), nLen2 = UBound(ReplaceWith), C = 0
'	If nLen = 0 OrElse nLen1 = 0 OrElse nLen2 = 0  OrElse nLen2 <> nLen Then Return wszMainStr
'	Dim As WString Ptr TempString
'	Dim As String wszMatchStr, wszReplaceWith
'	WLet TempString, wszMainStr
'	nLen = nLen1
'	For j As Integer = 0 To nLen
'		wszReplaceWith = *ReplaceWith(j) : wszMatchStr = *MatchedStr(j)
'		nLen1 = Len(wszMatchStr) : nLen2 = Len(wszReplaceWith)
'		For x As Integer = 1 To nLen1
'			'skip the one which is one of the wszReplaceWith
'			If InStr(Start, wszReplaceWith, Mid(wszMatchStr, x, 1)) > 0 Then Continue For
'			C += 1
'			Do While i <= Len(*TempString)
'				If MatchCase Then
'					If Mid(wszMatchStr, x, 1) = Mid(*TempString, i, 1) Then
'						'Mid(*TempString, i, 1) = wszReplaceWith
'						WLet TempString, Mid(*TempString, 1, i - 1) + wszReplaceWith + Mid(*TempString, i + 1)
'						i += nLen2
'					End If
'				Else
'					If UCase(Mid(wszMatchStr, x, 1)) = UCase(Mid(*TempString, i, 1)) Then
'						WLet TempString, Mid(*TempString, 1, i - 1) + wszReplaceWith + Mid(*TempString, i + 1)
'						i += nLen2
'					End If
'				End If
'				i +=1
'			Loop
'			i=1
'		Next
'	Next
'	Count = C
'	Function = *TempString
'	Deallocate TempString
'End Function

Private Function StartsWith(ByRef a As Const WString, ByRef b As Const WString, Start As Integer = 0) As Boolean
	'If a = "" OrElse b = "" Then Return False Else Return Left(a, Len(b)) = b
	If Len(a) < Len(b) Then Return False
	Dim j As Integer = Start
	For i As Integer = 0 To Len(b) - 1
		If a[j] <> b[i] Then Return False
		j += 1
	Next
	Return True
End Function


Private Function EndsWith(ByRef a As Const WString, ByRef b As Const WString) As Boolean
	'If a = "" OrElse b = "" Then Return False Else Return Right(a, Len(b)) = b
	If Len(a) < Len(b) Then Return False
	Dim j As Integer = Len(a) - Len(b)
	For i As Integer = 0 To Len(b) - 1
		If a[j] <> b[i] Then Return False
		j += 1
	Next
	Return True
End Function

'https://www.freebasic.net/forum/viewtopic.php?p=305672&hilit=Split#p305672
'Returns a zero-based, one-dimensional array containing a specified number of substrings.
'Parameters
'   Subject
'       String expression containing substrings and delimiters. If expression is a zero-length string(""), Split returns an empty array, that is, an array with no elements and no data.
'   Delimiter
'       String character used to identify substring limits. If delimiter is a zero-length string, a single-element array containing the entire expression string is returned.
'   Result
'       Variable where the result is returned.
'   MatchCase
'       Boolean value indicating the kind of comparison to use when evaluating substrings.
'    skipEmptyElement
'     Boolean value indicating the kind of skip Empty Element.
Private Function Split Overload(ByRef wszMainStr As String, ByRef Delimiter As Const String, Result() As String, MatchCase As Boolean = True, skipEmptyElement As Boolean = False) As Long
	'The following code from FXM, (https://www.freebasic.net/forum/viewtopic.php?p=305672&hilit=Split#p305672)
	Dim As Any Ptr P1 = CPtr(Any Ptr Ptr, @wszMainStr)[0]
	Dim As Integer L1 = CPtr(Integer Ptr, @wszMainStr)[1]
	Dim As Integer L2 = CPtr(Integer Ptr, @Delimiter)[1]
	Dim As Integer i = 0 'UBound(Result) + 1
	Dim As Integer N, N0 = 1
	If L1 < 1 OrElse L2 < 1 Then
		ReDim Result(0)
		Return 0
	End If
	ReDim Preserve Result(0 To i + L1 / L2) 'LBound(Result)
	Do
		If MatchCase Then
			N = InStr(N0, wszMainStr, Delimiter)
		Else
			N = InStr(N0, LCase(wszMainStr), LCase(Delimiter))
		End If
		If N > 0 Then
			If (Not skipEmptyElement) OrElse (N - N0) > 0 Then
				CPtr(Any Ptr Ptr, @wszMainStr)[0] = P1 + N0 - 1
				CPtr(Integer Ptr, @wszMainStr)[1] = N - N0
				Result(i) = wszMainStr
				CPtr(Any Ptr Ptr, @wszMainStr)[0] = P1
				CPtr(Integer Ptr, @wszMainStr)[1] = L1
				i += 1
			End If
			N0 = N + L2
		Else
			If (Not skipEmptyElement) OrElse (L1 - N0 + 1) > 0 Then
				CPtr(Any Ptr Ptr, @wszMainStr)[0] = P1 + N0 - 1
				CPtr(Integer Ptr, @wszMainStr)[1] = L1 - N0 + 1
				Result(i) = wszMainStr
				CPtr(Any Ptr Ptr, @wszMainStr)[0] = P1
				CPtr(Integer Ptr, @wszMainStr)[1] = L1
			Else
				i -= 1
			End If
			ReDim Preserve Result(0 To i)  'LBound(Result)
			Exit Do
		End If
	Loop
	Return i + 1
End Function

Private Function Split(ByRef wszMainStr As WString, ByRef Delimiter As Const WString, Result() As UString, MatchCase As Boolean = True, skipEmptyElement As Boolean = False) As Long
	''The following code from FXM, (https://www.freebasic.net/forum/viewtopic.php?p=305672&hilit=Split#p305672)
	Dim As Integer L1 = Len(wszMainStr)
	Dim As Integer L2 = Len(Delimiter)
	If L1 < 1 OrElse L2 < 1 Then
		ReDim Result(0)
		Return 0
	End If
	Dim As Integer i = 0'UBound(Result) + 1
	Dim As Integer L, n, n0 = 1
	Dim As WString Ptr p, p1 = @wszMainStr
	ReDim Preserve Result(0 To i + L1 / L2) 'LBound(Result)
	Do
		If MatchCase Then n = InStr(n0, wszMainStr, Delimiter) Else n = InStr(n0, LCase(wszMainStr), LCase(Delimiter))
		If n > 0 Then
			If (Not skipEmptyElement) OrElse (n - n0) > 0 Then
				p = p1 + n0 - 1
				L = n - n0
				Dim As WString * 1 w
				Swap w[0], (*p)[L]
				Result(i) = * (p)
				Swap w[0], (*p)[L]
				i += 1
			End If
			n0 = n + L2
		Else
			If (Not skipEmptyElement) OrElse (L1 - n0 + 1) > 0 Then
				p = p1 + n0 - 1
				L = L1 - n0 + 1
				Result(i) = * (p)
			Else
				i -= 1
			End If
			ReDim Preserve Result(0 To i) 'LBound(Result)
			Exit Do
		End If
	Loop
	Return i + 1
	'' Old version
	'Dim As Long n = 0, p = 1, items = 50, i = 1
	'Dim As Long tLen = Len(Delimiter)
	'Dim As Long ls = Len(wszMainStr)
	'Dim As Boolean tFlag
	'If ls < 1 OrElse tLen < 1 Then
	'	ReDim Result(0)
	'	Return 0
	'End If
	'ReDim Result(0 To items - 1)
	'Do While i <= ls
	'	If MatchCase Then tFlag = StartsWith(wszMainStr, Delimiter, i - 1) Else tFlag = StartsWith(LCase(wszMainStr), LCase(Delimiter), i - 1)
	'	If tFlag Then
	'		'If Mid(subject, i, tLen) = Delimiter Then
	'		If (Not skipEmptyElement) OrElse i - p > 0 Then
	'			n = n + 1
	'			If (n >= items + 1 ) Then
	'				items += 50
	'				ReDim Preserve Result(0 To items - 1)
	'			End If
	'			Result(n - 1) = Mid(wszMainStr, p, i - p)
	'		End If
	'		p = i + tLen
	'		i = p
	'		Continue Do
	'	End If
	'	i = i + 1
	'Loop
	'If (Not skipEmptyElement) OrElse ls - p + 1 > 0 Then
	'	n += 1
	'	ReDim Preserve Result(n - 1)
	'	Result(n - 1) = Mid(wszMainStr, p, ls - p + 1)
	'End If
	'Return n
	
End Function

Private Function Split(ByRef wszMainStr As WString, ByRef Delimiter As Const WString, Result() As String, MatchCase As Boolean = True, skipEmptyElement As Boolean = False) As Long
	'The following code from FXM, (https://www.freebasic.net/forum/viewtopic.php?p=305672&hilit=Split#p305672)
	Dim As Integer L1 = Len(wszMainStr)
	Dim As Integer L2 = Len(Delimiter)
	If L1 < 1 OrElse L2 < 1 Then
		ReDim Result(0)
		Return 0
	End If
	Dim As Integer i = 0 'UBound(Result) + 1
	Dim As Integer L, n, n0 = 1
	Dim As WString Ptr p, p1 = @wszMainStr
	ReDim Preserve Result(0 To i + L1 / L2) 'LBound(Result)
	Do
		If MatchCase Then n = InStr(n0, wszMainStr, Delimiter) Else n = InStr(n0, LCase(wszMainStr), LCase(Delimiter))
		If n > 0 Then
			If (Not skipEmptyElement) OrElse (n - n0) > 0 Then
				p = p1 + n0 - 1
				L = n - n0
				Dim As WString * 1 w
				Swap w[0], (*p)[L]
				Result(i) = * (p)
				Swap w[0], (*p)[L]
				i += 1
			End If
			n0 = n + L2
		Else
			If (Not skipEmptyElement) OrElse (L1 - n0 + 1) > 0 Then
				p = p1 + n0 - 1
				L = L1 - n0 + 1
				Result(i) = * (p)
			Else
				i -= 1
			End If
			ReDim Preserve Result(0 To i) 'LBound(Result)
			Exit Do
		End If
	Loop
	Return i + 1
End Function

Private Function Split(ByRef wszMainStr As WString, ByRef Delimiter As Const WString, Result() As WString Ptr, MatchCase As Boolean = True, skipEmptyElement As Boolean = False) As Long
	'The following code from FXM, (https://www.freebasic.net/forum/viewtopic.php?p=305672&hilit=Split#p305672)
	Dim As Integer L1 = Len(wszMainStr)
	Dim As Integer L2 = Len(Delimiter)
	If L1 < 1 OrElse L2 < 1 Then
		ReDim Result(0)
		Return 0
	End If
	Dim As Integer i = 0 'UBound(Result) + 1
	Dim As Integer L, n, n0 = 1
	Dim As WString Ptr p, p1 = @wszMainStr
	ReDim Preserve Result(0 To i + L1 / L2) 'LBound(Result)
	Do
		If MatchCase Then n = InStr(n0, wszMainStr, Delimiter) Else n = InStr(n0, LCase(wszMainStr), LCase(Delimiter))
		If n > 0 Then
			If (Not skipEmptyElement) OrElse (n - n0) > 0 Then
				p = p1 + n0 - 1
				L = n - n0
				Dim As WString * 1 w
				Result(i) = CAllocate((L + 1) * SizeOf(WString))
				Swap w[0], (*p)[L]
				*Result(i) = *(p)
				Swap w[0], (*p)[L]
				i += 1
			End If
			n0 = n + L2
		Else
			If (Not skipEmptyElement) OrElse (L1 - n0 + 1) > 0 Then
				p = p1 + n0 - 1
				L = L1 - n0 + 1
				Result(i) = CAllocate((L + 1) * SizeOf(WString))
				*Result(i) = * (p)
			Else
				i -= 1
			End If
			ReDim Preserve Result(0 To i) 'LBound(Result)
			Exit Do
		End If
	Loop
	Return i + 1
	
	' Old version
	'Dim As Long n = 0, p = 1, items = 50, i = 1
	'Dim As Long tLen = Len(Delimiter)
	'Dim As Long ls = Len(wszMainStr)
	'Dim As Boolean tFlag
	'If ls < 1 OrElse tLen < 1 Then
	'	ReDim Result(0)
	'	Return 0
	'End If
	'ReDim Result(0 To items - 1)
	'Do While i <= ls
	'	If MatchCase Then tFlag = StartsWith(wszMainStr, Delimiter, i - 1) Else tFlag = StartsWith(LCase(wszMainStr), LCase(Delimiter), i - 1)
	'	If tFlag Then
	'		'If Mid(subject, i, tLen) = Delimiter Then
	'		If (Not skipEmptyElement) OrElse i - p > 0 Then
	'			n = n + 1
	'			If (n >= items + 1 ) Then
	'				items += 50
	'				ReDim Preserve Result(0 To items - 1)
	'			End If
	'			WLet(Result(n - 1),  Mid(wszMainStr, p, i - p))
	'		End If
	'		p = i + tLen
	'		i = p
	'		Continue Do
	'	End If
	'	i = i + 1
	'Loop
	'If (Not skipEmptyElement) OrElse ls - p + 1 > 0 Then
	'	n += 1
	'	ReDim Preserve Result(n - 1)
	'	WLet(Result(n - 1),  Mid(wszMainStr, p, ls - p + 1))
	'End If
	'Return n
	'
	'If (Not skipEmptyElement) OrElse ls - p + 1 > 0 Then
	'	n += 1
	'	ReDim Preserve Result(n - 1)
	'	WLet(Result(n - 1),  Mid(wszMainStr, p, ls - p + 1))
	'End If
	'Return n
End Function

Private Function Split(ByRef wszMainStr As ZString, ByRef Delimiter As Const ZString, Result() As ZString Ptr, MatchCase As Boolean = True, skipEmptyElement As Boolean = False) As Long
	'The following code from FXM, (https://www.freebasic.net/forum/viewtopic.php?p=305672&hilit=Split#p305672)
	Dim As Integer L1 = Len(wszMainStr)
	Dim As Integer L2 = Len(Delimiter)
	If L1 < 1 OrElse L2 < 1 Then
		ReDim Result(0)
		Return 0
	End If
	Dim As Integer i = 0 'UBound(Result) + 1
	Dim As Integer L, n, n0 = 1
	Dim As ZString Ptr p, p1 = @wszMainStr
	ReDim Preserve Result(0 To i + L1 / L2) 'LBound(Result)
	Do
		If MatchCase Then n = InStr(n0, wszMainStr, Delimiter) Else n = InStr(n0, LCase(wszMainStr), LCase(Delimiter))
		If n > 0 Then
			If (Not skipEmptyElement) OrElse (n - n0) > 0 Then
				p = p1 + n0 - 1
				L = n - n0
				Dim As ZString * 1 w
				Result(i) = CAllocate((L + 1) * SizeOf(ZString))
				Swap w[0], (*p)[L]
				*Result(i) = *(p)
				Swap w[0], (*p)[L]
				i += 1
			End If
			n0 = n + L2
		Else
			If (Not skipEmptyElement) OrElse (L1 - n0 + 1) > 0 Then
				p = p1 + n0 - 1
				L = L1 - n0 + 1
				Result(i) = CAllocate((L + 1) * SizeOf(ZString))
				*Result(i) = * (p)
			Else
				i -= 1
			End If
			ReDim Preserve Result(0 To i) 'LBound(Result)
			Exit Do
		End If
	Loop
	Return i + 1
	
End Function

'Returns a string created by joining a number of substrings contained in an array.
'
'Parameters
'   Subject
'       One-dimensional array containing substrings to be joined.
'   Delimiter
'       String character used to separate the substrings in the returned string.If delimiter is a zero-length string (""), all items in the list are concatenated with no delimiters.
'   iStart
'       Set from what position to install the separator
'   iStep
'       Determines with what step to combine
'See also
'   Split
Function Join Overload(Subject() As String, ByRef Delimiter As Const String, ByVal skipEmptyElement As Boolean = False, iStart As Integer = 0, iStep As Integer = 1) As String
	Dim As Integer Size
	Dim As Integer Lj = max(LBound(Subject), 0)
	Dim As Integer Uj = UBound(Subject)
	Dim As Integer ls = Len(Delimiter)
	
	For i As Integer = Lj To Uj - 1
		If skipEmptyElement = False OrElse Len(Subject(i)) <> 0 Then Size += Len(Subject(i)) + ls
	Next i
	If skipEmptyElement = False OrElse Len(Subject(Uj)) <> 0 Then Size += Len(Subject(Uj))
	
	Dim As String so = String(Size, Chr(0))
	Dim As Integer n
	For i As Integer = Lj To Uj - 1 Step iStep
		If skipEmptyElement = False OrElse Len(Subject(i)) <> 0 Then
			Fb_MemCopy(so[n], Subject(i)[0], Len(Subject(i)))
			n += Len(Subject(i))
			Fb_MemCopy(so[n], Delimiter[0], ls)
			n+= ls
		End If
	Next i
	If skipEmptyElement = False OrElse Len(Subject(Uj)) <> 0 Then
		Fb_MemCopy(so[n], Subject(Uj)[0], Len(Subject(Uj)))
	Else
		so[Size - 1] = 0
		CPtr(Integer Ptr, @so)[1] = Size - 1
	End If
	Return so
	
	'Old Code
	'For i As Integer = iStart To UBound(Subject) Step iStep
	'	Result &= IIf(i = iStart, "", Delimiter) & Subject(i)
	'Next
	'Return Result
End Function

Function Join(Subject() As UString, ByRef Delimiter As Const WString, ByVal skipEmptyElement As Boolean = False, iStart As Integer = 0, iStep As Integer = 1) As String
	Dim As UString Result
	For i As Integer = iStart To UBound(Subject) Step iStep
		Result &= IIf(i = iStart, "", Delimiter) & Subject(i)
	Next
	Return Result
	'Dim As Integer Size
	'Dim As Integer Lj = Max(LBound(Subject), 0)
	'Dim As Integer Uj = UBound(Subject)
	'Dim As Integer ls = Len(Delimiter)
	'
	'For i As Integer = Lj To Uj - 1
	'	If skipEmptyElement = False OrElse Len(Subject(i)) <> 0 Then Size += Len(Subject(i)) + ls
	'Next i
	'If skipEmptyElement = False OrElse Len(Subject(Uj)) <> 0 Then Size += Len(Subject(Uj))
	'
	'Dim As String so = String(Size, Chr(0))
	'Dim As Integer n
	'For i As Integer = Lj To Uj - 1 Step iStep
	'	If skipEmptyElement = False OrElse Len(Subject(i)) <> 0 Then
	'		Fb_MemCopy(so[n], Subject(i)[0], Len(Subject(i)))
	'		n+= Len(Subject(i))
	'		Fb_MemCopy(so[n], Delimiter[0], ls)
	'		n+= ls
	'	End If
	'Next i
	'If skipEmptyElement = False OrElse Len(Subject(Uj)) <> 0 Then
	'	Fb_MemCopy(so[n], Subject(Uj)[0], Len(Subject(Uj)))
	'Else
	'	so[Size - 1] = 0
	'	CPtr(Integer Ptr, @so)[1] = Size - 1
	'End If
	'Return so
End Function

Function Join(SubjectPtr() As WString Ptr, ByRef Delimiter As Const WString, ByVal skipEmptyElement As Boolean = False, iStart As Integer = 0, iStep As Integer = 1) As WString Ptr
	Dim As Integer size
	Dim As Integer lj = max(LBound(SubjectPtr), 0)
	Dim As Integer uj = UBound(SubjectPtr)
	Dim As Integer ls = Len(Delimiter)
	
	For i As Integer = lj To uj - 1 Step iStep
		If skipEmptyElement = False OrElse Len(*SubjectPtr(i)) <> 0 Then size += Len(*SubjectPtr(i)) + ls
	Next i
	If skipEmptyElement = False OrElse Len(*SubjectPtr(uj)) <> 0 Then size += Len(*SubjectPtr(uj))
	
	Dim As WString Ptr ResultPtr = CAllocate((size + 1) * SizeOf(WString))
	Dim As Integer n
	For i As Integer = lj To uj - 1 Step iStep
		If skipEmptyElement = False OrElse Len(*SubjectPtr(i)) <> 0 Then
			Fb_MemCopy((*ResultPtr)[n], (*SubjectPtr(i))[0], Len(*SubjectPtr(i)) * SizeOf(WString))
			n += Len(*SubjectPtr(i))
			Fb_MemCopy((*ResultPtr)[n], Delimiter[0], ls * SizeOf(WString))
			n+= ls
		End If
	Next i
	If skipEmptyElement = False OrElse Len(*SubjectPtr(uj)) <> 0 Then
		Fb_MemCopy((*ResultPtr)[n], (*SubjectPtr(uj))[0], Len(*SubjectPtr(uj)) * SizeOf(WString))
	Else
		(*ResultPtr)[size - 1] = 0
	End If
	Return ResultPtr
	
	'Old Code
	'Dim As WString Ptr TmpString
	'WLet(TmpString, "")
	'For i As Integer = iStart To UBound(Subject) Step iStep
	'	WAdd TmpString, IIf(i = iStart, "", Delimiter) & *Subject(i)
	'Next
	'Return TmpString
End Function

Function Join(SubjectPtr() As ZString Ptr, ByRef Delimiter As Const ZString, ByVal skipEmptyElement As Boolean = False, iStart As Integer = 0, iStep As Integer = 1) As ZString Ptr
	Dim As Integer size
	Dim As Integer lj = max(LBound(SubjectPtr), 0)
	Dim As Integer uj = UBound(SubjectPtr)
	Dim As Integer ls = Len(Delimiter)
	
	For i As Integer = lj To uj - 1 Step iStep
		If skipEmptyElement = False OrElse Len(*SubjectPtr(i)) <> 0 Then size += Len(*SubjectPtr(i)) + ls
	Next i
	If skipEmptyElement = False OrElse Len(*SubjectPtr(uj)) <> 0 Then size += Len(*SubjectPtr(uj))
	
	Dim As ZString Ptr ResultPtr = CAllocate((size + 1) * SizeOf(ZString))
	Dim As Integer n
	For i As Integer = lj To uj - 1 Step iStep
		If skipEmptyElement = False OrElse Len(*SubjectPtr(i)) <> 0 Then
			Fb_MemCopy((*ResultPtr)[n], (*SubjectPtr(i))[0], Len(*SubjectPtr(i)) * SizeOf(ZString))
			n += Len(*SubjectPtr(i))
			Fb_MemCopy((*ResultPtr)[n], Delimiter[0], ls * SizeOf(ZString))
			n+= ls
		End If
	Next i
	If skipEmptyElement = False OrElse Len(*SubjectPtr(uj)) <> 0 Then
		Fb_MemCopy((*ResultPtr)[n], (*SubjectPtr(uj))[0], Len(*SubjectPtr(uj)) * SizeOf(ZString))
	Else
		(*ResultPtr)[size - 1] = 0
	End If
	Return ResultPtr
End Function

' ========================================================================================
'  Parses a path/file name to extract component parts.
'  This function evaluates a text path/file text name, and returns a requested part of the
'  name. The functionality is strictly one of string parsing alone.
'  wszOption is one of the following words which is used to specify the requested part:
'  PATH
'        Returns the path portion of the path/file Name. That is the text up to and
'        including the last backslash (\) or colon (:).
'  NAME
'        Returns the name portion of the path/file Name. That is the text to the right
'        of the last backslash (\) or colon (:), ending just before the last period (.).
'  EXTN
'        Returns the extension portion of the path/file name. That is the last
'        period (.) in the string plus the text to the right of it.
'  NAMEX
'        Returns the name and the EXTN parts combined.
'   Example: StringPathName("C:\VisualFBEditor\Poject.Bas")           ->C:\Visual Free Basic\
'            StringPathName("C:\VisualFBEditor\Poject.Bas","NAME")    ->Poject
'            StringPathName("C:\VisualFBEditor\Poject.Bas","NAMEEX")  ->Poject.Bas
'            StringPathName("C:\VisualFBEditor\Poject.Bas","EXTN")     -> .Bas
' ========================================================================================
Private Function StringPathName(ByRef wszFileSpec As WString, ByRef wszOption As Const WString = "PATH") As UString
	If Len(wszFileSpec) = 0 Then Return ""
	Dim As UString Result
	Select Case UCase(wszOption)
	Case "PATH"
		' // Returns the path portion of file spec
		Dim nPos As Long = InStrRev(wszFileSpec, Any ":/\")
		If nPos Then Result = Mid(wszFileSpec, 1, nPos)
		
	Case "NAME"
		' // Retrieve the full filename
		Dim nPos As Long = InStrRev(wszFileSpec, Any ":/\")
		If nPos Then Result = Mid(wszFileSpec, nPos + 1)
		' // Retrieve the filename
		nPos = InStrRev(Result, ".")
		If nPos Then Result = Mid(Result, 1, nPos - 1)
	Case "NAMEEX"
		' // Retrieve the name and extension combined
		Dim nPos As Long = InStrRev(wszFileSpec, Any ":/\")
		If nPos Then Result = Mid(wszFileSpec, nPos + 1)
		
	Case "EXTN"
		' // Retrieve the name and extension combined
		Dim nPos As Long = InStrRev(wszFileSpec, Any ":/\")
		If nPos Then Result = Mid(wszFileSpec, nPos + 1)
		' // Retrieve the extension
		nPos = InStrRev(Result, ".")
		If nPos Then
			Result = Mid(Result, nPos+1)
		Else
			Return ""
		End If
	End Select
	Return Result
End Function

Private Function StringExtract Overload(ByRef wszMainStr As WString, ByRef wszMatchStr As Const WString, ByVal nStart As Long = 1, ByVal MatchCase As Boolean = True) As UString
	Dim As Long nLen = Len(wszMainStr), nPos =0
	If (nStart = 0) OrElse (nStart > nLen) OrElse nLen =0 Then Return wszMainStr
	If nStart < 0 Then nStart = nLen + nStart + 1
	If MatchCase Then
		nPos = InStr(nStart, wszMainStr, wszMatchStr)
	Else
		nPos = InStr(nStart, UCase(wszMainStr), UCase(wszMatchStr))
	End If
	If nPos Then
		Return Mid(wszMainStr, nStart, nPos - nStart)
	End If
	'SubString after the wszMatchStr
	If MatchCase Then
		nPos = InStr(1, wszMainStr, wszMatchStr)
	Else
		nPos = InStr(1, UCase(wszMainStr), UCase(wszMatchStr))
	End If
	If nPos Then
		Return Mid(wszMainStr,nPos + Len(wszMatchStr))
	End If
	Return Mid(wszMainStr, nStart)
End Function

Private Function StringExtract(ByRef wszMainStr As WString, ByRef wszDelim1 As Const WString, ByRef wszDelim2 As Const WString, ByVal nStart As Long = 1, ByVal MatchCase As Boolean = True) As UString
	Dim As Long nLen = Len(wszMainStr), nPos1, nPos2
	If (nStart = 0) OrElse (nStart > nLen) Then Return wszMainStr
	If nStart < 0 Then nStart = nLen + nStart + 1
	If MatchCase Then
		nPos1= InStr(nStart, wszMainStr, wszDelim1)
	Else
		nPos1= InStr(nStart, UCase(wszMainStr), UCase(wszDelim1))
	End If
	If nPos1 = 0 Then Return ""
	nPos1 += Len(wszDelim1)
	If MatchCase Then
		nPos2 = InStr(nPos1, wszMainStr, wszDelim2)
	Else
		nPos2 = InStr(nPos1, UCase(wszMainStr), UCase(wszDelim2))
	End If
	If nPos2 = 0 Then Return ""
	nLen = nPos2 - nPos1
	Return Mid(wszMainStr, nPos1, nLen)
End Function

Private Function StringSubStringAll(ByRef wszMainStr As WString, ByRef ParseStart As Const WString, ByRef ParseEnd As Const WString, Result() As WString Ptr, MatchCase As Boolean = True) As Long
	Dim As Long PositionStart = 1, PositionEnd = 1, n = 0
	If Len(wszMainStr) < Len(ParseStart + ParseEnd) OrElse ParseStart="" OrElse ParseEnd = "" Then Return -1
	Do
		If MatchCase Then
			PositionStart = InStr(PositionEnd, wszMainStr, ParseStart)
		Else
			PositionStart = InStr(PositionEnd, UCase(wszMainStr), UCase(ParseStart))
		End If
		If PositionStart > 0 Then
			PositionStart = PositionStart + Len(ParseStart)
			If MatchCase Then
				PositionEnd = InStr(PositionStart, wszMainStr, ParseEnd)
			Else
				PositionEnd = InStr(PositionStart, UCase(wszMainStr), UCase(ParseEnd))
			End If
			If PositionEnd > PositionStart Then
				n = n + 1
				ReDim Preserve Result(n - 1)
				WLet(Result(n - 1), Mid(wszMainStr, PositionStart, PositionEnd - PositionStart))
			End If
		End If
	Loop Until (PositionStart < 1 Or PositionEnd < 1)
	Return n
End Function

#ifndef Match_Off
	Private Function Match(ByRef Subject As WString Ptr, ByRef Pattern As WString Ptr) As Boolean
		
		#define CH_QUOTE 63 '' ASCII for ?
		#define CH_MULT  42 '' ASCII for *
		
		If (*Pattern)[0] = 0 Then 'AndAlso (*subject)[0] = 0 Then
			Return True
		End If
		
		If (*Pattern)[0] = CH_QUOTE OrElse (*Pattern)[0] = (*Subject)[0] Then
			Return Match(Subject + 1, Pattern + 1)
		End If
		
		If (*Pattern)[0] = CH_MULT Then
			Return Match(Subject, Pattern + 1) OrElse Match(Subject + 1, Pattern)
		End If
		
		Return False
		
	End Function
	
	Private Function InStrMatch(ByRef subject As WString, ByRef pattern As WString, Start As Integer = 1) As Integer
		For i As Integer = Start To Len(subject)
			If Match(@subject + (i - 1), @pattern) Then Return i
		Next
		Return 0
	End Function
#endif

#ifndef Choose_Off
	Private Function Choose cdecl(Index As Integer, ...) As UString
		Dim args As Cva_List
		Cva_Start(args, Index)
		For i As Integer = 1 To Index - 1
			Dim As WString * 1 result = * (Cva_Arg(args, WString Ptr))
		Next
		
		Choose = * (Cva_Arg(args, WString Ptr))
		Cva_End(args)
	End Function
#endif

#ifndef Switch_Off
	Private Function Switch cdecl(Condition As Boolean, ...) As UString
		Dim args As Cva_List
		Cva_Start(args, Condition)
		Dim As Boolean bCondition = Condition
		While bCondition = False
			Dim As WString * 1 wResult = * (Cva_Arg(args, WString Ptr))
			bCondition = Cva_Arg(args, Boolean)
		Wend
		Switch = * (Cva_Arg(args, WString Ptr))
		Cva_End(args)
	End Function
#endif

#if (Not defined(__USE_JNI__)) AndAlso (Not defined(__USE_WASM__))
	Private Function FileExists (ByRef FileName As UString) As Boolean
		#ifdef __USE_GTK__
			If *FileName.vptr <> "" AndAlso g_file_test(ToUtf8(*FileName.vptr), G_FILE_TEST_EXISTS) Then
				Return True
			Else
				Return False
			End If
		#elseif __USE_JNI__
			Return 0
		#else
			If PathFileExistsW(FileName.vptr) Then
				Return True
			Else
				Return False
			End If
		#endif
	End Function
	
	Private Function FileExists Overload(ByRef FileName As WString) As Boolean
		#ifdef __USE_GTK__
			If FileName <> "" AndAlso g_file_test(ToUtf8(FileName), G_FILE_TEST_EXISTS) Then
				Return True
			Else
				Return False
			End If
		#elseif __USE_JNI__
			Return 0
		#else
			If PathFileExistsW(FileName) Then
				Return True
			Else
				Return False
			End If
		#endif
	End Function
#endif
