#include "mff/NoInterface.bi"
'SetConsoleOutputCP(65001)
'SetConsoleOutputCP(936)
Dim ArrUString() As UString
Dim ArrString() As String
Dim ArrWStringPtr() As WString Ptr
Dim nLen As Integer

Dim As Long i, n = 2000
Dim As String  TestString
Dim As UString TestUString
Dim As WString * 400960 TestWString

Dim As ULong t

Function JoinOld Overload(Subject() As String, ByRef Delimiter As Const String, ByVal skipEmptyElement As Boolean = False, iStart As Integer = 0, iStep As Integer = 1) As String
	
	Dim As String Result = Subject(iStart)
	Dim As Integer n
	For i As Integer = iStart + 1 To UBound(Subject) Step iStep
		Result &= Delimiter
		Result &= Subject(i)
	Next
	Return Result
End Function

Function JoinOld Overload(SubjectPtr() As WString Ptr, ByRef Delimiter As Const WString, ByVal skipEmptyElement As Boolean = False, iStart As Integer = 0, iStep As Integer = 1) As WString Ptr
	Dim As WString Ptr TmpString
	WLet(TmpString, *SubjectPtr(iStart))
	For i As Integer = iStart + 1 To UBound(SubjectPtr) Step iStep
		WAdd TmpString, Delimiter & *SubjectPtr(i)
	Next
	Return TmpString
End Function

Private Function SplitOld Overload(ByRef wszMainStr As String, ByRef Delimiter As Const WString, Result() As String, MatchCase As Boolean = True, skipEmptyElement As Boolean = False) As Long
	Dim As Long n = 0, p = 1, items = 50, i = 1
	Dim As Long tLen = Len(Delimiter)
	Dim As Long ls = Len(wszMainStr)
	Dim As Boolean tFlag
	If ls < 1 OrElse tLen < 1 Then
		ReDim Result(0)
		Return 0
	End If
	ReDim Result(0 To items - 1)
	Do While i <= ls
		If MatchCase Then tFlag = StartsWith(wszMainStr, Delimiter, i - 1) Else tFlag = StartsWith(LCase(wszMainStr), LCase(Delimiter), i - 1)
		If tFlag Then
			'If Mid(subject, i, tLen) = Delimiter Then
			If (Not skipEmptyElement) OrElse i - p > 0 Then
				n = n + 1
				If (n >= items + 1 ) Then
					items += 50
					ReDim Preserve Result(0 To items - 1)
				End If
				Result(n - 1) = Mid(wszMainStr, p, i - p)
			End If
			p = i + tLen
			i = p
			Continue Do
		End If
		i = i + 1
	Loop
	If (Not skipEmptyElement) OrElse ls - p + 1 > 0 Then
		n += 1
		ReDim Preserve Result(n - 1)
		Result(n - 1) = Mid(wszMainStr, p, ls - p + 1)
	End If
	Return n
	
End Function

Private Function SplitOld(ByRef wszMainStr As WString, ByRef Delimiter As Const WString, Result() As WString Ptr, MatchCase As Boolean = True, skipEmptyElement As Boolean = False) As Long
	Dim As Long n = 0, p = 1, items = 50, i = 1
	Dim As Long tLen = Len(Delimiter)
	Dim As Long ls = Len(wszMainStr)
	Dim As Boolean tFlag
	If ls < 1 OrElse tLen < 1 Then
		ReDim Result(0)
		Return 0
	End If
	ReDim Result(0 To items - 1)
	Do While i <= ls
		If MatchCase Then tFlag = StartsWith(wszMainStr, Delimiter, i - 1) Else tFlag = StartsWith(LCase(wszMainStr), LCase(Delimiter), i - 1)
		If tFlag Then
			'If Mid(subject, i, tLen) = Delimiter Then
			If (Not skipEmptyElement) OrElse i - p > 0 Then
				n = n + 1
				If (n >= items + 1 ) Then
					items += 50
					ReDim Preserve Result(0 To items - 1)
				End If
				WLet(Result(n - 1), Mid(wszMainStr, p, i - p))
			End If
			p = i + tLen
			i = p
			Continue Do
		End If
		i = i + 1
	Loop
	If (Not skipEmptyElement) OrElse ls - p + 1 > 0 Then
		n += 1
		ReDim Preserve Result(n - 1)
		WLet(Result(n - 1), Mid(wszMainStr, p, ls - p + 1))
	End If
	Return n
	
End Function

Debug.Print "The Count of element n=" & n
Debug.Print "Testing String Build.........................Testing String Build"
TestString = ""
t = GetTickCount()
For i = 0 To n
	TestString = TestString + "abcde"
Next
t = GetTickCount() - t
Debug.Print "s = s + abcde String ", Str(t), Str(Len(TestString))

TestUString = ""
t = GetTickCount()
For i = 0 To n
	TestUString = TestUString + "abcde"
Next
t = GetTickCount() - t
Debug.Print "s = s + abcde UString",  Str(t), Str(Len(TestUString))
Print

TestString = ""
t = GetTickCount()
For i = 0 To n
	TestString +=  "abcde"
Next
t = GetTickCount() - t
Debug.Print "s += abcde String ", Str(t), Str(Len(TestString))

TestUString = ""
t = GetTickCount()
For i = 0 To n
	TestUString += "abcde"
Next
t = GetTickCount() - t
Debug.Print "s += abcde UString",  Str(t), Str(Len(TestUString))
Print

TestString = ""
t = GetTickCount()
For i = 0 To n
	TestString = TestString & "abcde"
Next
t = GetTickCount() - t
Debug.Print "s = s & abcde String ", Str(t), Str(Len(TestString))

TestUString = ""
t = GetTickCount()
For i = 0 To n
	TestUString = TestUString & "abcde"
Next
t = GetTickCount() - t
Debug.Print "s = s & abcde UString",  Str(t), Str(Len(TestUString))

Dim As WString * 100 Delimiter = Chr(9) + "一二三"
TestString = ""
t = GetTickCount()
For i = 0 To n - 1
	TestString &= "你好abcde" + Delimiter
Next
t = GetTickCount() - t
Debug.Print "s &= abcde String ", Str(t), Str(Len(TestString))

TestWString = ""
t = GetTickCount()
For i = 0 To n - 1
	TestWString &= "你好abcde" + Delimiter
Next
t = GetTickCount() - t
Debug.Print "s &= abcde WString",  Str(t), Str(Len(TestWString))



Debug.Print " "
ReDim ArrString(0)
Debug.Print "Split Testing  ==========================❶❷❸㊊㊋㊌㊍㊎=   Split Testing  "
nLen = Split(TestString, Delimiter, ArrString())
Debug.Print "Source type: String     Array type: String     nLen=" & nLen
For n As Integer = 0 To min(5, nLen - 1)
	Debug.Print n & " " & ArrString(n)
Next
Erase ArrString

Debug.Print " "
ReDim ArrString(0)
nLen = Split(TestString, Delimiter, ArrString(), , True)
Debug.Print "Source type: String     Array type: String     nLen=" & nLen
Debug.Print "Skip empty element"
For n As Integer = 0 To min(5, nLen - 1)
	Debug.Print n & " " & ArrString(n)
Next
Erase ArrString

Debug.Print " "
ReDim ArrString(0)
nLen = Split(TestString, Delimiter, ArrString())
Debug.Print "Source type: Wstring     Array type: String      nLen=" & nLen
For n As Integer = 0 To min(5, nLen - 1)
	Debug.Print n & " " & ArrString(n)
Next
Erase ArrString

Debug.Print " "
ReDim ArrString(0)
nLen = Split(TestWString, Delimiter, ArrString(), , True)
Debug.Print "Source type: Wstring     Array type: String      nLen=" & nLen
Debug.Print "Skip empty element"
For n As Integer = 0 To min(5, nLen - 1)
	Debug.Print n & " " & ArrString(n)
Next
Erase ArrString

Debug.Print " "
ReDim ArrWStringPtr(0)
nLen = Split(TestWString, Delimiter, ArrWStringPtr())
Debug.Print "Source type: Wstring     Array type: WString Ptr  nLen=" & nLen
For n As Integer = 0 To min(5, nLen - 1)
	Debug.Print n & " " & *ArrWStringPtr(n)
	Deallocate ArrWStringPtr(n)
Next
Erase ArrWStringPtr

Debug.Print " "
ReDim ArrUString(0)
nLen = Split(TestWString, Delimiter, ArrUString())
Debug.Print "Source type: Wstring     Array type: UString      nLen=" & nLen
For n As Integer = 0 To min(5, nLen - 1)
	Debug.Print n & " " & ArrUString(n)
Next
Erase ArrUString

Debug.Print " "
Debug.Print " "
Debug.Print "Split Function Time  ==========================❶❷❸㊊㊋㊌㊍㊎=   Split Function Time  "
Debug.Print " "
ReDim ArrString(0)
t = GetTickCount()
nLen = SplitOld(TestString, Delimiter, ArrString())
t = GetTickCount() - t
Debug.Print "Source type: String     Array type: String        nLen=" & nLen, "   Old Split Function Time " & t
For n As Integer = 0 To min(5, nLen)
	Debug.Print n & " " & ArrString(n)
Next
Erase ArrString

Debug.Print " "
ReDim ArrString(0)
t = GetTickCount()
nLen = Split(TestString, Delimiter, ArrString())
t = GetTickCount() - t
Debug.Print "Source type: String     Array type: String        nLen=" & nLen, " FXM's Split Function Time " & t
For n As Integer = 0 To min(5, nLen - 1)
	Debug.Print n & " " & ArrString(n)
Next

Debug.Print " "
ReDim ArrWStringPtr(0)
t = GetTickCount()
nLen = SplitOld(TestWString, Delimiter, ArrWStringPtr())
t = GetTickCount() - t
Debug.Print "Source type: WString     Array type: WString Ptr  nLen=" & nLen, "   Old Split Function Time " & t
For n As Integer = 0 To min(5, nLen - 1)
	Debug.Print n & " " & *ArrWStringPtr(n)
	Deallocate ArrWStringPtr(n)
Next
Erase ArrWStringPtr

Debug.Print " "
ReDim ArrWStringPtr(0)
t = GetTickCount()
nLen = Split(TestWString, Delimiter, ArrWStringPtr())
t = GetTickCount() - t
Debug.Print "Source type: WString     Array type:      UString  nLen=" & nLen, " FXM's Split Function Time " & t
For n As Integer = 0 To min(5, nLen - 1)
	Debug.Print n & " " & *ArrWStringPtr(n)
Next


Debug.Print " "
Debug.Print "Join Testing  ==========================❶❷❸㊊㊋㊌㊍㊎=   Join Testing  "
Debug.Print " "
t = GetTickCount()
TestString = JoinOld(ArrString(), Delimiter)
t = GetTickCount() - t
Debug.Print "Source type: String     Array type: String" , "      Old Join Function Time " & t

Debug.Print " "
t = GetTickCount()
TestString = Join(ArrString(), Delimiter)
t = GetTickCount() - t
Debug.Print "Source type: String     Array type: String" , "      FXM Join Function Time " & t

Debug.Print " "
t = GetTickCount()
Dim As WString Ptr ResultWStringPtr = JoinOld(ArrWStringPtr(), Delimiter)
t = GetTickCount() - t
Debug.Print "Source type: WString     Array type: WString Ptr" , "      Old Join Function Time " & t
Deallocate ResultWStringPtr
Debug.Print " "
t = GetTickCount()
Dim As WString Ptr ResultWStringPtr1 = Join(ArrWStringPtr(), Delimiter)
t = GetTickCount() - t
Debug.Print "Source type: WString     Array type: WString Ptr" , "      FXM Join Function Time " & t
Deallocate ResultWStringPtr1

Debug.Print " Press any key for continue"

'free the array
Erase ArrString
For n As Integer = 0 To min(5, nLen - 1)
	Deallocate ArrWStringPtr(n)
Next
Erase ArrWStringPtr
Sleep(80000)
End

