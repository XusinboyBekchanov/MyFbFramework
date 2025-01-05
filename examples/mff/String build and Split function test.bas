#include "mff/NoInterface.bi"
'SetConsoleOutputCP(65001)
'SetConsoleOutputCP(936)
Dim As Long i, n = 10000
Dim As String  TestString
Dim As UString TestUString
Dim As WString * 150960 TestWString
Dim As ULong t

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
				wLet(Result(n - 1), Mid(wszMainStr, p, i - p))
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
		wLet(Result(n - 1), Mid(wszMainStr, p, ls - p + 1))
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
	TestString &= "明天你好abcde" + Delimiter
Next
t = GetTickCount() - t
Debug.Print "s &= abcde String ", Str(t), Str(Len(TestString))

TestWString = ""
t = GetTickCount()
For i = 0 To n - 1
	TestWString &= "明天你好abcde" + Delimiter
Next
t = GetTickCount() - t
Debug.Print "s &= abcde WString",  Str(t), Str(Len(TestWString))


Debug.Print "Split Testing  ==========================❶❷❸㊊㊋㊌㊍㊎=   Split Testing  "
Dim ArrStr(Any) As String
Dim nLen As Integer
t = GetTickCount()
'nLen = SplitStringVFBE(TestString, Delimiter, ArrStr())
nLen = Split(TestString, Delimiter, ArrStr())
t = GetTickCount() - t
Debug.Print "Source type: String     Array type: String        nLen=" & nLen, "   Old Split Function Time " & t
For n As Integer = 0 To min(10, UBound(ArrStr))
	Debug.Print n & " " & ArrStr(n)
Next
Erase ArrStr
Debug.Print " "

t = GetTickCount()
nLen = Split(TestString, Delimiter, ArrStr())
t = GetTickCount() - t
Debug.Print "Source type: String     Array type: String        nLen=" & nLen, " FXM's Split Function Time " & t
For n As Integer = 0 To min(10, UBound(ArrStr))
	Debug.Print n & " " & ArrStr(n)
Next
Erase ArrStr
Debug.Print " "

Dim Arr(Any) As WString Ptr
t = GetTickCount()
nLen = SplitOld(TestWString, Delimiter, Arr())
t = GetTickCount() - t
Debug.Print "Source type: WString     Array type: WString Ptr  nLen=" & nLen, "   Old Split Function Time " & t
For n As Integer = 0 To min(10, UBound(Arr))
	Debug.Print n & " " & *Arr(n)
	Deallocate Arr(n)
Next
Erase Arr
Debug.Print " "

Dim ArrUString(Any) As UString
t = GetTickCount()
nLen = Split(TestWString, Delimiter, ArrUString())
t = GetTickCount() - t
TestWString = ""
Debug.Print "Source type: WString     Array type:      UString  nLen=" & nLen, " FXM's Split Function Time " & t
For n As Integer = 0 To min(10, UBound(ArrUString))
	Debug.Print n & " " & ArrUString(n)
Next
Erase ArrUString

Debug.Print " "
Debug.Print "Split Testing  ==========================❶❷❸㊊㊋㊌㊍㊎=   Split Testing  "
Scope
	Dim As String Delimiter = Chr(9) + "一二三"
	'Dim As String TestStr = "abc" & Chr(0) + "一二三" & Chr(0) & "123" & Chr(0) + "ERT"
	Dim As String TestStr = Delimiter + "abc" + Delimiter + "一二三" + Delimiter + Delimiter + Delimiter + "123" + Delimiter ' + "ERT"
	'Dim As String TestStr = "abc" + Delimiter + "0fgh0" + Delimiter +Delimiter + "1234" + Delimiter + "ERT"
	Dim Arr() As String
	Dim nLen As Integer
	nLen = Split(TestStr, Delimiter, Arr())
	TestStr = ""
	Debug.Print "Source type: String     Array type: String     nLen=" & nLen
	For n As Integer = 0 To nLen - 1
		Debug.Print n & " " & Arr(n)
	Next
End Scope

Debug.Print " "
Scope
	Dim As String Delimiter = Chr(9) + "一二三"
	'Dim As String TestStr = "abc" & Chr(0) + "一二三" & Chr(0) & "123" & Chr(0) + "ERT"
	Dim As String TestStr = Delimiter + "abc" + Delimiter + "一二三" + Delimiter + Delimiter + Delimiter + "123" + Delimiter ' + "ERT"
	'Dim As String TestStr = "abc" + Delimiter + "0fgh0" + Delimiter +Delimiter + "1234" + Delimiter + "ERT"
	Dim Arr() As String
	Dim nLen As Integer
	nLen = Split(TestStr, Delimiter, Arr(), , True)
	TestStr = ""
	Debug.Print "Source type: String     Array type: String     nLen=" & nLen
	Debug.Print "Skip empty element"
	For n As Integer = 0 To nLen - 1
		Debug.Print n & " " & Arr(n)
	Next
End Scope

Debug.Print " "
Scope
	Dim As WString * 100 Delimiter = Chr(9) + "一二三"
	Dim As WString * 200 TestStr = Delimiter + "abc" + Delimiter + "一二三" + Delimiter + Delimiter + Delimiter + "123" + Delimiter
	
	Dim Arr(Any) As String
	Dim nLen As Integer
	nLen = Split(TestStr, Delimiter, Arr())
	TestStr = ""
	Debug.Print "Source type: Wstring     Array type: String      nLen=" & nLen
	For n As Integer = 0 To nLen - 1
		Debug.Print n & " " & Arr(n)
		'Deallocate a(n)
	Next
	'Erase a
End Scope

Debug.Print " "
Scope
	Dim As WString * 100 Delimiter = Chr(9) + "一二三"
	Dim As WString * 200 TestStr = Delimiter + "abc" + Delimiter + "一二三" + Delimiter + Delimiter + Delimiter + "123" + Delimiter
	
	Dim Arr(Any) As String
	Dim nLen As Integer
	nLen = Split(TestStr, Delimiter, Arr(), , True)
	TestStr = ""
	Debug.Print "Source type: Wstring     Array type: String      nLen=" & nLen
	Debug.Print "Skip empty element"
	For n As Integer = 0 To nLen - 1
		Debug.Print n & " " & Arr(n)
		'Deallocate a(n)
	Next
	'Erase a
End Scope

Debug.Print " "
Scope
	Dim As WString * 100 Delimiter = Chr(9) + " 一二三 "
	Dim As WString * 200 TestStr = Delimiter + "abc" + Delimiter + "一二三" + Delimiter + Delimiter + Delimiter + "123" + Delimiter
	
	Dim Arr(Any) As WString Ptr
	Dim nLen As Integer
	nLen = Split(TestStr, Delimiter, Arr())
	TestStr = ""
	Debug.Print "Source type: Wstring     Array type: WString Ptr  nLen=" & nLen
	For n As Integer = 0 To nLen - 1
		Debug.Print n & " " & *Arr(n)
		Deallocate Arr(n)
	Next
	Erase Arr
End Scope

Debug.Print " "
Scope
	Dim As WString * 100 Delimiter = Chr(9) + "一二三"
	Dim As WString * 200 TestStr = Delimiter + "abc" + Delimiter + "一二三" + Delimiter + Delimiter + Delimiter + "123" + Delimiter
	
	Dim Arr(Any) As WString Ptr
	Dim nLen As Integer
	nLen = Split(TestStr, Delimiter, Arr(), , True)
	TestStr = ""
	Debug.Print "Source type: Wstring     Array type: WString Ptr  nLen=" & nLen
	Debug.Print "Skip empty element"
	For n As Integer = 0 To nLen - 1
		Debug.Print n & " " & *Arr(n)
		Deallocate Arr(n)
	Next
	Erase Arr
End Scope

Debug.Print " "
Scope
	Dim As WString * 200 Delimiter = Chr(9) + "一二三"
	Dim As WString * 200 TestStr = Delimiter + "abc" + Delimiter + "一二三" + Delimiter + Delimiter + Delimiter + "123" + Delimiter
	
	Dim Arr(Any) As UString
	Dim nLen As Integer
	nLen = Split(TestStr, Delimiter, Arr())
	TestStr = ""
	Debug.Print "Source type: Wstring     Array type: UString      nLen=" & nLen
	For n As Integer = 0 To nLen - 1
		Debug.Print n & " " & Arr(n)
		'Deallocate a(n)
	Next
	'Erase a
End Scope

Debug.Print " "
Scope
	Dim As WString * 200 Delimiter = Chr(9) '+ "一二三"
	Dim As WString * 200 TestStr = Delimiter + "abc" + Delimiter + "一二三" + Delimiter + Delimiter + Delimiter + "123" + Delimiter
	
	Dim Arr(Any) As UString
	Dim nLen As Integer
	nLen = Split(TestStr, Delimiter, Arr(), , True)
	TestStr = ""
	Debug.Print "Source type: Wstring     Array type: UString      nLen=" & nLen
	Debug.Print "Skip empty element"
	For n As Integer = 0 To nLen - 1
		Debug.Print n & " " & Arr(n)
		'Deallocate a(n)
	Next
	'Erase a
End Scope

Sleep(80000)
End

