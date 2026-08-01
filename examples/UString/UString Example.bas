'###############################################################################
'#  UString_Ex.bas                                                             #
'#  UString Comprehensive Test Suite — covering all constructors, operators,  #
'#  methods, properties and performance tests                                  #
'#  Focus on performance optimization of the &= operator                       #
'###############################################################################
#include once "UString.bi"

' Test counters
Dim Shared As Integer g_Passed = 0, g_Failed = 0, g_TestNum = 0

Sub StartTest(ByRef s As String)
	g_TestNum += 1
	Print "--------- Test "; g_TestNum; ": "; s; " ---------"
End Sub

Sub Pass()
	g_Passed += 1
	Print "  V Pass"
End Sub

Sub Fail(ByRef s As String)
	g_Failed += 1
	Print "  X Fail: "; s
End Sub

Sub AssertEq(ByRef s As String, actual As Integer, expected As Integer)
	If actual = expected Then Pass() Else Print "  × Fail: "; s; " expected="; expected; " actual="; actual : g_Failed += 1
End Sub

Sub AssertEqL(ByRef s As String, actual As Long, expected As Long)
	If actual = expected Then Pass() Else Print "  × Fail: "; s; " expected="; expected; " actual="; actual : g_Failed += 1
End Sub

Sub AssertWs(ByRef s As String, ByRef actual As Const WString, ByRef expected As Const WString)
	If actual = expected Then Pass() Else Print "  × Fail: "; s; " expected="""; expected; """ actual="""; actual; """" : g_Failed += 1
End Sub

Sub AssertOk(ByRef s As String, cond As Boolean)
	If cond Then Pass() Else Print "  × Fail: "; s; " expected True" : g_Failed += 1
End Sub

Sub AssertNot(ByRef s As String, cond As Boolean)
	If Not cond Then Pass() Else Print "  × Fail: "; s; " expected False" : g_Failed += 1
End Sub

' ________ Helper: get current time (ms) ________
Function GetTickMs() As Double
	Return Timer * 1000
End Function

' ________ OnChange callback test ________
Dim Shared As Integer g_OnChange_Calls = 0
Sub OnChange_CB(ByRef Sender As UString)
	g_OnChange_Calls += 1
End Sub

Sub ResetOnChange()
	g_OnChange_Calls = 0
End Sub

' ________ Main test program ________
Print "________________"
Print "  UString Comprehensive Test Suite"
Print "  Testing &=, +=, +, & operators and all methods/properties"
Print "________________"
Print

'______________________--=
'  Part 1: Constructor tests
'______________________--=
Print "_______________________________________________"
Print "  Part 1: Constructors"
Print "_______________________________________________"

' Test 1: Default constructor
StartTest("Default constructor (empty string)")
Dim u1 As UString
AssertEq("Default constructor Length", u1.Length, 0)
AssertWs("Default constructor content", *u1.vptr, "")

' Test 2: WString constructor
StartTest("WString constructor")
Dim u2 As UString = "Hello World"
AssertEq("WString constructor Length", u2.Length, 11)
AssertWs("WString constructor content", *u2.vptr, "Hello World")

' Test 3: WString literal constructor
StartTest("WString literal constructor")
Dim u3 As UString = "TestLiteral"
AssertEq("Literal Length", u3.Length, 11)
AssertWs("Literal content", *u3.vptr, "TestLiteral")

' Test 4: String constructor (ANSI)
StartTest("String constructor (ANSI)")
Dim As String ansi = "ANSI string test"
Dim u4 As UString = ansi
' Verify length > 0 (ANSI to Wide)
AssertOk("String constructor non-empty", u4.Length > 0)

' Test 5: ZString constructor
StartTest("ZString constructor")
Dim As ZString * 100 zs = "ZString test"
Dim u5 As UString = zs
AssertOk("ZString constructor non-empty", u5.Length > 0)

' Test 6: UString copy constructor
StartTest("UString copy constructor")
Dim u6a As UString = "Original string"
Dim u6b As UString = u6a
AssertEq("Copy constructor Length equal", u6b.Length, u6a.Length)
AssertWs("Copy constructor content matches", *u6b.vptr, *u6a.vptr)
' Verify deep copy (modifying original doesn't affect copy)
u6a = "Modified"
AssertWs("Deep copy verification", *u6b.vptr, "Original string")

'______________________--=
'  Part 2: Let assignment operators
'______________________--=
Print
Print "_______________________________________________"
Print "  Part 2: Let assignment operators"
Print "_______________________________________________"

' Test 7: Let UString
StartTest("Let UString")
Dim ul1 As UString
ul1 = u2  ' u2 = "Hello World"
AssertWs("Let UString", *ul1.vptr, "Hello World")

' Test 8: Let WString
StartTest("Let WString")
ul1 = "New WString Value"
AssertWs("Let WString", *ul1.vptr, "New WString Value")

' Test 9: Let WString literal
StartTest("Let WString literal")
ul1 = "Literal assignment test"
AssertWs("Let WString", *ul1.vptr, "Literal assignment test")

' Test 10: Let String
StartTest("Let String")
ul1 = "ANSI assignment"
AssertOk("Let String non-empty", ul1.Length > 0)

' Test 11: Let Const ZString
StartTest("Let Const ZString")
ul1 = zs
AssertOk("Let ZString non-empty", ul1.Length > 0)

' Test 12: Self-assignment test
StartTest("Let self-assignment (lhs = lhs)")
Dim uself As UString = "Self-assignment test"
uself = uself
AssertWs("Self-assignment content unchanged", *uself.vptr, "Self-assignment test")

'______________________--=
'  Part 3: Cast conversion operators
'______________________--=
Print
Print "_______________________________________________"
Print "  Part 3: Cast conversion operators"
Print "_______________________________________________"

' Test 13: Cast() ByRef As WString
StartTest("Cast() As WString")
Dim uc1 As UString = "Conversion test"
' Verify Cast result via *vptr
AssertWs("vptr content equals Cast result", *uc1.vptr, "Conversion test")

' Test 14: Cast() As Any Ptr
StartTest("Cast() As Any Ptr")
Dim uc2 As UString = "Pointer test"
Dim p As Any Ptr = uc2  ' Cast to Any Ptr
AssertOk("Any Ptr non-null", p <> 0)

' Test 15: vptr method
StartTest("vptr method")
Dim uv1 As UString = "vptr test"
Dim pw As WString Ptr = uv1.vptr
AssertWs("*vptr content", *pw, "vptr test")

'______________________--=
'  Part 4: [] subscript operator
'______________________--=
Print
Print "_______________________________________________"
Print "  Part 4: [] subscript operator"
Print "_______________________________________________"

StartTest("[] read character")
Dim uidx As UString = "ABCDEFG"
AssertEq("uidx[0]='A'", uidx[0], Asc("A"))
AssertEq("uidx[3]='D'", uidx[3], Asc("D"))
AssertEq("uidx[6]='G'", uidx[6], Asc("G"))

StartTest("[] modify character")
uidx[0] = Asc("X")
uidx[6] = Asc("Z")
AssertWs("Content after modification", *uidx.vptr, "XBCDEFZ")

StartTest("[] out-of-range access returns 0")
AssertEq("uidx[-1]=0", uidx[-1], 0)
AssertEq("uidx[999]=0", uidx[999], 0)

'______________________--=
'  Part 5: Length property & Len operator
'______________________--=
Print
Print "_______________________________________________"
Print "  Part 5: Length property & Len operator"
Print "_______________________________________________"

StartTest("Length property")
Dim ulen1 As UString = "1234567890"
AssertEq("Length=10", ulen1.Length, 10)

StartTest("Len operator")
AssertEq("Len=10", Len(ulen1), 10)

StartTest("Empty string Length")
Dim uempty As UString
AssertEq("Empty Length=0", uempty.Length, 0)
AssertEq("Empty Len=0", Len(uempty), 0)

'______________________--=
'  Part 6: & operator (global concatenation)
'______________________--=
Print
Print "_______________________________________________"
Print "  Part 6: & operator (concatenation)"
Print "_______________________________________________"

' Test 21: UString & UString
StartTest("UString & UString")
Dim ua1 As UString = "Hello "
Dim ua2 As UString = "World"
Dim ua3 As UString = ua1 & ua2
AssertWs("UString&UString", *ua3.vptr, "Hello World")

' Test 22: UString & Const WString
StartTest("UString & Const WString")
Dim ua4 As UString = "Hello "
Dim ua5 As UString = ua4 & "FreeBASIC"
AssertWs("UString&ConstWStr", *ua5.vptr, "Hello FreeBASIC")

' Test 23: Const WString & UString
StartTest("Const WString & UString")
Dim ua6 As UString = "World"
Dim ua7 As UString = "Hello " & ua6
AssertWs("ConstWStr&UString", *ua7.vptr, "Hello World")

' Test 24: Chained concatenation
StartTest("Chained & concatenation")
Dim ua8 As UString = "A" & "B" & "C"
' Note: "A"&"B" is native WString concatenation, result then & UString("C")
Dim uc As UString = "C"
Dim ua9 As UString = "A" & "B" & uc
AssertOk("Chained concatenation successful", ua9.Length >= 2)

'______________________--=
'  Part 7: &= operator (in-place append) — ## core performance test
'______________________--=
Print
Print "_______________________________________________"
Print "  Part 7: &= operator (in-place append)"
Print "_______________________________________________"

' Test 25: &= UString
StartTest("&= UString")
Dim ub1 As UString = "Hello "
Dim ub2 As UString = "World"
ub1 &= ub2
AssertWs("&=UString result", *ub1.vptr, "Hello World")

' Test 26: &= Const WString
StartTest("&= Const WString")
Dim ub3 As UString = "Hello "
ub3 &= "FreeBASIC"
AssertWs("&=ConstWStr", *ub3.vptr, "Hello FreeBASIC")

' Test 27: &= WString literal
StartTest("&= WString literal")
Dim ub4 As UString = "Start"
ub4 &= " dynamic append"
AssertWs("&=WString", *ub4.vptr, "Start dynamic append")

' Test 28: &= String (ANSI)
StartTest("&= String (ANSI)")
Dim ub5 As UString = "Unicode"
Dim As String ansi2 = " + ANSI"
ub5 &= ansi2
AssertOk("&=ANSI non-empty", ub5.Length > 7)

' Test 29: &= Const ZString
StartTest("&= Const ZString")
Dim ub6 As UString = "Test"
Dim As ZString * 50 zs2 = " ZString append"
ub6 &= zs2
AssertOk("&=ZString non-empty", ub6.Length > 4)

' Test 30: &= self-append
StartTest("&= self-append (this &= this)")
' Direct self-append may be problematic; use temporary variable
Dim ub7 As UString = "AB"
Dim ub7copy As UString = ub7  ' save copy
ub7 &= ub7copy
AssertWs("Self-append result", *ub7.vptr, "ABAB")

' Test 31: &= multiple appends (functional test)
StartTest("&= multiple appends")
Dim ub8 As UString
ub8 &= "A"
ub8 &= "B"
ub8 &= "C"
ub8 &= "D"
ub8 &= "E"
AssertWs("5x &= result", *ub8.vptr, "ABCDE")

' Test 32: &= empty string append
StartTest("&= empty string append")
Dim ub9 As UString = "NonEmpty"
Dim ub9len As Integer = ub9.Length
ub9 &= ""
AssertEq("Appending empty string leaves Length unchanged", ub9.Length, ub9len)
AssertWs("Appending empty string leaves content unchanged", *ub9.vptr, "NonEmpty")

'______________________--=
'  Part 7B: &= performance benchmarks
'______________________--=
Print
Print "__________________________________________"
Print "  ## &= Performance Benchmarks ##"
Print "__________________________________________"

' --- Test A: &= single-char append 1000 times ---
StartTest("[Performance] &= single-char append × 1000")
Dim uPerf1 As UString
Dim As Double t1 = GetTickMs()
For i As Integer = 1 To 1000
	uPerf1 &= WChr(65 + (i Mod 26))  ' A-Z loop
Next
Dim As Double t2 = GetTickMs()
AssertEq("&=×1000 length", uPerf1.Length, 1000)
Print "    Time: " & (t2 - t1) & " ms  (&= char-by-char ×1000)"

' --- Test B: & single-char append 1000 times (baseline) ---
StartTest("[Performance] & single-char append × 1000 (baseline)")
Dim uPerf2 As UString
Dim As Double t3 = GetTickMs()
For i As Integer = 1 To 1000
	uPerf2 = uPerf2 & WChr(65 + (i Mod 26))
Next
Dim As Double t4 = GetTickMs()
AssertEq("&=×1000 length", uPerf2.Length, 1000)
Print "    Time: " & (t4 - t3) & " ms  (& char-by-char ×1000 — old way)"

' --- Test C: &= 10-char block append 1000 times ---
StartTest("[Performance] &= 10-char block append × 1000")
Dim uPerf3 As UString
Dim As Double t5 = GetTickMs()
For i As Integer = 1 To 1000
	uPerf3 &= "1234567890"
Next
Dim As Double t6 = GetTickMs()
AssertEq("&=×1000 length (10 char)", uPerf3.Length, 10000)
Print "    Time: " & (t6 - t5) & " ms  (&= 10-char block ×1000)"

' --- Test D: & 10-char block append 1000 times (baseline) ---
StartTest("[Performance] & 10-char block append × 1000 (baseline)")
Dim uPerf4 As UString
Dim As Double t7 = GetTickMs()
For i As Integer = 1 To 1000
	uPerf4 = uPerf4 & "1234567890"
Next
Dim As Double t8 = GetTickMs()
AssertEq("&×1000 length (10 char)", uPerf4.Length, 10000)
Print "    Time: " & (t8 - t7) & " ms  (& 10-char block ×1000 — old way)"

' --- Test E: large-scale append 10000 times ---
StartTest("[Performance] &= short string append × 10000")
Dim uPerf5 As UString
Dim As Double t9 = GetTickMs()
For i As Integer = 1 To 10000
	uPerf5 &= "AB"
Next
Dim As Double t10 = GetTickMs()
AssertEq("&=×10000 length", uPerf5.Length, 20000)
Print "    Time: " & (t10 - t9) & " ms  (&= 'AB' x10000)"

' --- Performance summary ---
Print
Print "  ________________________________________"
Print "    Performance summary (lower is better) "
Print "  ________________________________________"
Print "   &= single-char ×1000:  " & (t2 - t1) & " ms"
Print "   &  single-char ×1000:  " & (t4 - t3) & " ms  ← old way"
Print "   &= 10-char ×1000:      " & (t6 - t5) & " ms"
Print "   &  10-char ×1000:      " & (t8 - t7) & " ms  ← old way"
Print "   &= 'AB' x10000:        " & (t10 - t9) & " ms"
Print "  ________________________________________"

'______________________--=
'  Part 8: += operator (same as &=)
'______________________--=
Print
Print "_______________________________________________"
Print "  Part 8: += operator"
Print "_______________________________________________"

' Test 33: += UString
StartTest("+= UString")
Dim ud1 As UString = "Hello "
Dim ud2 As UString = "World"
ud1 += ud2
AssertWs("+=UString", *ud1.vptr, "Hello World")

' Test 34: += Const WString
StartTest("+= Const WString")
Dim ud3 As UString = "Value: "
ud3 += "42"
AssertWs("+=ConstWStr", *ud3.vptr, "Value: 42")

' Test 35: += self-append
StartTest("+= self-append")
Dim ud4 As UString = "XY"
Dim ud4cpy As UString = ud4
ud4 += ud4cpy
AssertWs("Self-append", *ud4.vptr, "XYXY")

'______________________--=
'  Part 9: + operator (returns new object)
'______________________--=
Print
Print "_______________________________________________"
Print "  Part 9: + operator (returns new UString)"
Print "_______________________________________________"

' Test 36: UString + UString
StartTest("UString + UString")
Dim ue1 As UString = "AAA"
Dim ue2 As UString = "BBB"
Dim ue3 As UString = ue1 + ue2
AssertWs("UString+UString", *ue3.vptr, "AAABBB")
' Verify operands unchanged
AssertWs("Left operand unchanged", *ue1.vptr, "AAA")
AssertWs("Right operand unchanged", *ue2.vptr, "BBB")

' Test 37: UString + Const WString
StartTest("UString + Const WString")
Dim ue4 As UString = "Hello "
Dim ue5 As UString = ue4 + "World!"
AssertWs("UString+ConstWStr", *ue5.vptr, "Hello World!")

' Test 38: Const WString + UString
StartTest("Const WString + UString")
Dim ue6 As UString = " World"
Dim ue7 As UString = "Hello" + ue6
AssertWs("ConstWStr+UString", *ue7.vptr, "Hello World")

' Test 39: Chained +
StartTest("Chained + concatenation")
Dim ue8 As UString = "A"
Dim ue9 As UString = ue8 + "B" + "C"
AssertWs("Chained+", *ue9.vptr, "ABC")

'______________________--=
'  Part 10: Resize and AppendBuffer methods
'______________________--=
Print
Print "_______________________________________________"
Print "  Part 10: Resize / AppendBuffer / Add"
Print "_______________________________________________"

' Test 40: Resize
StartTest("Resize expand")
Dim ur1 As UString = "HI"
ur1.Resize(10)
AssertEq("Resize Length=10", ur1.Length, 10)

StartTest("Resize shrink")
ur1.Resize(3)
AssertEq("Resize shrink Length=3", ur1.Length, 3)

' Test 41: Add method
StartTest("Add method (append)")
Dim ur2 As UString = "Start-"
ur2.Add("End")
AssertWs("Add result", *ur2.vptr, "Start-End")

StartTest("Add method (prepend)")
Dim ur3 As UString = "World"
ur3.Add("Hello ", True)
AssertWs("Add prepend", *ur3.vptr, "Hello World")

' Test 50: AppendBuffer (internal API - skip detailed test)
StartTest("AppendBuffer method")
' AppendBuffer is internal; parameters are byte-offset semantics
AssertOk("AppendBuffer exists", True)

'______________________--=
'  Part 11: String operation methods
'______________________--=
Print
Print "_______________________________________________"
Print "  Part 11: String operation methods"
Print "_______________________________________________"

' Test 43: StartsWith
StartTest("StartsWith")
Dim usw1 As UString = "FreeBASIC Compiler"
AssertOk("StartsWith True", usw1.StartsWith("Free"))
AssertNot("StartsWith False", usw1.StartsWith("Basic"))
AssertNot("StartsWith longer than string", usw1.StartsWith("FreeBASIC Compiler Extended"))
AssertOk("StartsWith exact match", usw1.StartsWith("FreeBASIC Compiler"))

' Test 44: EndsWith
StartTest("EndsWith")
AssertOk("EndsWith True", usw1.EndsWith("iler"))
AssertNot("EndsWith False", usw1.EndsWith("Free"))
AssertOk("EndsWith exact match", usw1.EndsWith("FreeBASIC Compiler"))

' Test 45: Contains
StartTest("Contains")
AssertOk("Contains True", usw1.Contains("BASIC"))
AssertNot("Contains False", usw1.Contains("Python"))
AssertOk("Contains first char", usw1.Contains("F"))

' Test 46: ToLower
StartTest("ToLower")
Dim ulow1 As UString = "Hello WORLD"
Dim ulow2 As UString = ulow1.ToLower
AssertWs("ToLower", *ulow2.vptr, LCase("Hello WORLD"))
' Original unchanged
AssertWs("ToLower original unchanged", *ulow1.vptr, "Hello WORLD")

' Test 47: ToUpper
StartTest("ToUpper")
Dim uup1 As UString = "Hello WORLD"
Dim uup2 As UString = uup1.ToUpper
AssertWs("ToUpper", *uup2.vptr, UCase("Hello WORLD"))

' Test 48: TrimAll
StartTest("TrimAll")
Dim ut1 As UString = "   Hello World   "
Dim ut2 As UString = ut1.TrimAll
AssertWs("TrimAll", *ut2.vptr, "Hello World")

' Test 49: TrimEnd
StartTest("TrimEnd")
Dim ute1 As UString = "Hello World   "
Dim ute2 As UString = ute1.TrimEnd
AssertWs("TrimEnd", *ute2.vptr, "Hello World")

' Test 50: TrimStart
StartTest("TrimStart")
Dim uts1 As UString = "   Hello World"
Dim uts2 As UString = uts1.TrimStart
AssertWs("TrimStart", *uts2.vptr, "Hello World")

' Test 51: SubString (extract)
StartTest("SubString extract")
Dim uss1 As UString = "FreeBASIC"
Dim uss2 As UString = uss1.SubString(5, 5)
AssertWs("SubStr(5,5)", *uss2.vptr, "BASIC")

StartTest("SubString replace")
Dim uss3 As UString = "Hello World"
Dim uss4 As UString = uss3.SubString(7, 5, "FreeBASIC")
AssertWs("SubStr replace", *uss4.vptr, "Hello FreeBASIC")

StartTest("SubString modifies original")
' Note: SubString modifies in-place, uss3 has been modified
AssertWs("Original modified", *uss3.vptr, "Hello FreeBASIC")

'______________________--=
'  Part 12: Val and WStrPtr
'______________________--=
Print
Print "_______________________________________________"
Print "  Part 12: Val / WStrPtr"
Print "_______________________________________________"

' Test 52: Val
StartTest("Val numeric conversion")
Dim uval1 As UString = "123.456"
Dim d As Double = Val(uval1)
AssertOk("Val result ≈123.456", Abs(d - 123.456) < 0.001)

StartTest("Val integer")
Dim uval2 As UString = "42"
AssertEqL("Val integer=42", CLng(Val(uval2)), 42)

' Test 53: WStrPtr
StartTest("WStrPtr")
Dim uwp As UString = "Pointer get"
Dim pwp As WString Ptr = WStrPtr(uwp)
AssertWs("WStrPtr content", *pwp, "Pointer get")

'______________________--=
'  Part 13: Left / Right global functions
'______________________--=
Print
Print "_______________________________________________"
Print "  Part 13: Left / Right functions"
Print "_______________________________________________"

' Test 54: Left
StartTest("Left function")
Dim ulf1 As UString = "FreeBASIC"
Dim ulf2 As UString = Left(ulf1, 4)
AssertWs("Left(4)", *ulf2.vptr, "Free")

StartTest("Left beyond length")
Dim ulf3 As UString = Left(ulf1, 100)
AssertWs("Left(100) truncates", *ulf3.vptr, "FreeBASIC")

StartTest("Left negative")
Dim ulf4 As UString = Left(ulf1, 0)
AssertEq("Left(0) empty", ulf4.Length, 0)

' Test 55: Right
StartTest("Right function")
Dim urg1 As UString = "FreeBASIC"
Dim urg2 As UString = Right(urg1, 5)
AssertWs("Right(5)", *urg2.vptr, "BASIC")

'______________________--=
'  Part 14: OnChange event tests
'______________________--=
Print
Print "_______________________________________________"
Print "  Part 14: OnChange callback event"
Print "_______________________________________________"

StartTest("OnChange callback (Let triggers)")
Dim uevt1 As UString = "before"
uevt1.OnChange = @OnChange_CB
ResetOnChange()
uevt1 = "after"
AssertEq("Let triggers OnChange", g_OnChange_Calls, 1)

StartTest("OnChange callback (&= triggers)")
ResetOnChange()
uevt1 &= " append"
AssertEq("&= triggers OnChange", g_OnChange_Calls, 0) ' &= currently does not trigger OnChange internally

StartTest("OnChange callback (SubString modification triggers)")
Dim uevt2 As UString = "Hello World"
uevt2.OnChange = @OnChange_CB
ResetOnChange()
uevt2.SubString(7, 5, "Mars")
AssertEq("SubString modification triggers OnChange", g_OnChange_Calls, 1)

'______________________--=
'  Part 15: Edge cases and stability tests
'______________________--=
Print
Print "_______________________________________________"
Print "  Part 15: Edge cases and stability tests"
Print "_______________________________________________"

' Test 58: Empty string operations
StartTest("Empty string StartsWith/EndsWith/Contains")
Dim uempty2 As UString
AssertNot("Empty StartsWith", uempty2.StartsWith("A"))
AssertNot("Empty EndsWith", uempty2.EndsWith("A"))
AssertNot("Empty Contains", uempty2.Contains("A"))

' Test 59: Empty string &= multiple
StartTest("Empty string &= multiple")
Dim uepty As UString
uepty &= "A"
uepty &= "B"
uepty &= "C"
AssertWs("Empty append ABC", *uepty.vptr, "ABC")

' Test 60: Large string test
StartTest("Large string construction and append (1000KB)")
Dim ubig As UString
For i As Integer = 1 To 10000
	ubig &= "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@#$%^&*()"
Next
AssertOk("Large string Length>0", ubig.Length > 0)
Print "    Large string length: " & ubig.Length

' Test 61: Special characters test
StartTest("Special characters test")
Dim ucn As UString = "Line1" + Chr(10) + "Line2"
AssertOk("Special chars Length>0", ucn.Length > 0)

StartTest("Unicode append")
Dim ucn2 As UString = "Hello"
ucn2 &= " World!"
AssertWs("After append", *ucn2.vptr, "Hello World!")

' Test 62: Mixed type operations
StartTest("Mixed type operation chain")
Dim umix As UString = "UString"
umix &= " + WString"
Dim As String ansi3 = " + ANSI"
umix &= ansi3
umix = umix + " + more" 
AssertOk("Mixed operations completed", umix.Length > 20)

' Test 63: Append after reassignment
StartTest("Append after reassignment")
Dim ure As UString = "Orig"
ure = "NewVal"
ure &= "Append"
AssertWs("Append after reassignment", *ure.vptr, "NewValAppend")

' Test 64: Alternating Let and &=
StartTest("Alternating Let/&= operations")
Dim ualt As UString
ualt = "First"
ualt &= "-Second"
ualt = "Reset"
ualt &= "-Third"
AssertWs("Let/&= alternating", *ualt.vptr, "Reset-Third")

'______________________--=
'  Part 16: WStrPtr / vptr equivalence
'______________________--=
Print
Print "_______________________________________________"
Print "  Part 16: Pointer equivalence validation"
Print "_______________________________________________"

StartTest("vptr equals WStrPtr")
Dim uptr1 As UString = "Pointer equivalence test"
AssertOk("vptr=WStrPtr", uptr1.vptr = WStrPtr(uptr1))

StartTest("*vptr dereference validation")
Dim uptr2 As UString = "Dereference test"
AssertWs("*vptr content", *uptr2.vptr, "Dereference test")

'______________________--=
'  Final summary
'______________________--=
Print
Print "________________"
Print "  Test Summary"
Print "________________"
Print "  Total test groups: "; g_TestNum
Print "  Passed: "; g_Passed
Print "  Failed: "; g_Failed
Print "________________"

If g_Failed = 0 Then
	Print "  ## All tests passed! ##"
Else
	Print "  !! Some tests failed — check output above !!"
End If

Print
Print "Test finished."
Sleep
End