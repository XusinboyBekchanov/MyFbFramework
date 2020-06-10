#include once "UString.bi"

Constructor UString()
	m_Length = 0
	m_BytesCount = SizeOf(WString)
	m_Data = CAllocate(SizeOf(WString))
	If m_Data <> 0 Then
		m_Data[0] = 0
	End If
End Constructor

Constructor UString(ByRef Value As WString)
	m_Length = Len(Value)
	m_BytesCount = (m_Length + 1) * SizeOf(WString)
	m_Data = CAllocate(m_BytesCount)
	If m_Data <> 0 Then
		*m_Data = Value
	End If
End Constructor

Constructor UString(ByRef Value As UString)
	m_Length = Value.m_Length
	m_BytesCount = Value.m_BytesCount
	m_Data = CAllocate(m_BytesCount)
	If m_Data <> 0 Then
		*m_Data = *Value.m_Data
	End If
End Constructor

Destructor UString
	If m_Data <> 0 Then
		Deallocate(m_Data)
	End If
End Destructor

Function UString.StartsWith(ByRef Value As UString) As Boolean
	Return Left(*m_Data, Value.Length) = *(Value.vptr)
End Function

Function UString.EndsWith(ByRef Value As UString) As Boolean
	Return Right(*m_Data, Value.Length) = *(Value.vptr)
End Function

Function UString.ToLower As UString
	Return LCase(*m_Data)
End Function

Function UString.ToUpper As UString
	Return UCase(*m_Data)
End Function

Function UString.TrimAll As UString
	Return Trim(*m_Data)
End Function

Function UString.TrimEnd As UString
	Return RTrim(*m_Data)
End Function

Function UString.TrimStart As UString
	Return LTrim(*m_Data)
End Function

Sub UString.Resize(NewLength As Integer)
	If NewLength > m_Length Then
		m_BytesCount = (NewLength + 1) * SizeOf(WString)
		m_Length = NewLength
		If m_Data <> 0 Then
			Deallocate(m_Data)
		End If
		m_Data = CAllocate(m_BytesCount)
	End If
End Sub

Operator UString.Let(ByRef lhs As UString)
	If @This <> @lhs Then
		If lhs.m_Length > m_Length Then
			If m_Data <> 0 Then
				Deallocate(m_Data)
			End If
			m_Data = CAllocate(lhs.m_BytesCount)
		End If
		m_Length = lhs.m_Length
		m_BytesCount = lhs.m_BytesCount
		
		If m_Data <> 0 Then
			*m_Data = *lhs.m_Data
		End If
	End If
End Operator

Operator UString.Let(ByRef lhs As WString)
	Resize Len(lhs)
	If m_Data <> 0 Then
		*m_Data = lhs
	End If
End Operator

Property UString.Length() As Integer
	Return m_Length
End Property

Operator UString.Cast() ByRef As WString
	Return *m_Data
End Operator

Operator UString.Cast() As Any Ptr
	Return CPtr(Any Ptr, m_Data)
End Operator

Function UString.vptr As WString Ptr
	Return m_Data
End Function

Function Val Overload(ByRef subject As UString) As Double
	Return Val(*(subject.vptr))
End Function

Operator Len(ByRef lhs As UString) As Integer
	Return lhs.Length
End Operator

Function WStrPtr(ByRef Value As UString) As WString Ptr
	Return Value.vptr
End Function

Function Replace(ByRef subject As WString, ByRef oldtext As Const WString, ByRef newtext As Const WString, ByVal start As Integer = 1, ByRef count As Integer = 0, MatchCase As Boolean = True) As UString
	Dim As Integer n, c, ls = Len(subject), lo = Len(oldtext), ln = Len(newtext)
	If subject <> "" And oldtext <> "" And oldtext <> newtext Then
		Dim As UString Result = subject
		If MatchCase Then
			n = InStr(start, Result, oldtext)
		Else
			n = InStr(start, LCase(Result), LCase(oldtext))
		End If
		Do While n <> 0
			c = c + 1
			Result = Left(*WStrPtr(Result), n - 1) & newtext & Mid(Result, n + lo)
			If MatchCase Then
				n = InStr(n + ln, Result, oldtext)
			Else
				n = InStr(n + ln, LCase(Result), LCase(oldtext))
			End If
		Loop
		count = c
		Return Result
	Else
		Return subject
	EndIf
End Function

Operator & (ByRef lhs As UString, ByRef rhs As UString) As UString
	Return *(lhs.vptr) & *(rhs.vptr)
End Operator

Function Left Overload(ByRef subject As UString, ByVal n As Integer) As UString
	Return Left(*(subject.vptr), n)
End Function

Function FileExists(ByRef filename As UString) As Long
	#ifndef __USE_GTK__
		If PathFileExistsW(filename.vptr) Then
			Return -1
		Else
			Return 0
		End If
	#else
		If g_find_program_in_path(*filename.vptr) = NULL Then
			Return 0
		Else
			Return -1
		End If
	#endif
End Function

