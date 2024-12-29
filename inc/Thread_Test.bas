'https://www.freebasic.net/forum/viewtopic.php?t=24227
#include once "inc/Thread.bi"
Sub TestSub(ByVal p As Any Ptr)
	'' user task
End Sub

Function TestFunc(ByVal p As Any Ptr) As String
	'' user task
	Return ""
End Function

'---------------------------------------------------
'Time wasted when running a user task either by procedure calling or by various threading methods
Print "Mean time wasted when running a user task :"
Print "   either by procedure calling method,"
Print "   or by various threading methods."
Print

Scope
	Dim As Double t = Timer
	For I As Integer = 1 To 1000000
		TestSub(0)
	Next I
	t = Timer - t
	Print Using "      - Using procedure calling method        : ###.###### ms"; t / 1000
	Print
End Scope

Scope
	Dim As Any Ptr P
	Dim As Double t = Timer
	For I As Integer = 1 To 1000
		P = ThreadCreate(@TestSub)
		ThreadWait(P)
	Next I
	t = Timer - t
	Print Using "      - Using elementary threading method     : ###.###### ms"; t
	Print
End Scope

Scope
	Dim As ThreadInitThenMultiStart ts
	Dim As Double t = Timer
	ts.ThreadInit(@TestFunc)
	For I As Integer = 1 To 10000
		ts.ThreadStart()
		ts.ThreadWait()
	Next I
	t = Timer - t
	Print Using "      - Using ThreadInitThenMultiStart method : ###.###### ms"; t / 10
End Scope

Scope
	Dim As ThreadPooling tp
	Dim As Double t = Timer
	For I As Integer = 1 To 10000
		tp.PoolingSubmit(@TestFunc)
	Next I
	tp.PoolingWait()
	t = Timer - t
	Print Using "      - Using ThreadPooling method            : ###.###### ms"; t / 10
End Scope

Scope
	Dim As ThreadDispatching td
	Dim As Double t = Timer
	For I As Integer = 1 To 10000
		td.DispatchingSubmit(@TestFunc)
	Next I
	td.DispatchingWait()
	t = Timer - t
	Print Using "      - Using ThreadDispatching method        : ###.###### ms"; t / 10
End Scope

Print


'---------------------------------------------------

Dim Shared As Double TestArray(1 To 800000)  '' only used by the [For...Next] waiting loop in UserCode()

Sub UserCodeSub (ByVal p As Any Ptr)
    Dim As String Ptr ps = p
    For I As Integer = 1 To 2
        Print *ps;
        For J As Integer = 1 To 800000
            TestArray(J) = Tan(J) * Atn(J) * Exp(J) * Log(J)  '' [For...Next] waiting loop not freeing any CPU resource
        Next J
    Next I
End Sub

Function UserCodeFct (ByVal p As Any Ptr) As String
    Dim As String Ptr ps = p
    For I As Integer = 1 To 2
        Print *ps;
        For J As Integer = 1 To 800000
            TestArray(J) = Tan(J) * Atn(J) * Exp(J) * Log(J)  '' [For...Next] waiting loop not freeing any CPU resource
        Next J
    Next I
    Return ""
End Function

Dim As String TestStr(0 To 31)
For i As Integer = 0 To 15
    TestStr(i) = Str(Hex(i))
Next i
For i As Integer = 16 To 31
    TestStr(i) = Chr(55 + i)
Next i

'---------------------------------------------------

#macro ThreadInitThenMultiStartSequence(nbThread)
    ReDim Preserve As ThreadInitThenMultiStart ts(nbThread - 1)
    Scope
        Print "   ";
        Dim As Double t = Timer
        For I As Integer = 0 To 32 - nbThread Step nbThread
            For J As Integer = 0 To nbThread - 1
                Static As Integer count
                If (count Mod 2) = 0 Then
                    ts(J).ThreadInit(@UserCodeSub, @TestStr(I + J))
                Else
                    ts(J).ThreadInit(@UserCodeFct, @TestStr(I + J))
                End If
                ts(J).ThreadStart()
                count += 1
            Next J
            For J As Integer = 0 To nbThread - 1
                ts(J).ThreadWait()
            Next J
        Next I
        t = Timer - t
        Print Using " : ####.## s"; t
    End Scope
#endmacro

#macro ThreadPoolingSequence(nbThread)
    ReDim Preserve As ThreadPooling tp(nbThread - 1)
    Scope
        Print "   ";
        Dim As Double t = Timer
        For I As Integer = 0 To 32 - nbThread Step nbThread
            For J As Integer = 0 To nbThread - 1
                Static As Integer count
                If (count Mod 2) = 0 Then
                    tp(J).PoolingSubmit(@UserCodeSub, @TestStr(I + J))
                Else
                    tp(J).PoolingSubmit(@UserCodeFct, @TestStr(I + J))
                End If
                count += 1
            Next J
        Next I
        For I As Integer = 0 To nbThread - 1
            tp(I).PoolingWait()
        Next I
        t = Timer - t
        Print Using " : ####.## s"; t
    End Scope
#endmacro

#macro ThreadDispatchingSequence(nbThreadmax)
    Scope
        Dim As ThreadDispatching td##nbThreadmax = nbThreadmax
        Print "   ";
        Dim As Double t = Timer
        For I As Integer = 0 To 31
            Static As Integer count
            If (count Mod 2) = 0 Then
                td##nbThreadmax.DispatchingSubmit(@UserCodeSub, @TestStr(I))
            Else
                td##nbThreadmax.DispatchingSubmit(@UserCodeFct, @TestStr(I))
            End If
            count += 1
        Next I
        td##nbThreadmax.DispatchingWait()
        t = Timer - t
        Print Using " : ####.## s"; t
    End Scope
#endmacro
    
'---------------------------------------------------

Print "'ThreadInitThenMultiStart' with 1 secondary thread:"
ThreadInitThenMultiStartSequence(1)

Print "'ThreadPooling' with 1 secondary thread:"
ThreadPoolingSequence(1)

Print "'ThreadDispatching' with 1 secondary thread max:"
ThreadDispatchingSequence(1)
Print

'---------------------------------------------------

Print "'ThreadInitThenMultiStart' with 2 secondary threads:"
ThreadInitThenMultiStartSequence(2)

Print "'ThreadPooling' with 2 secondary threads:"
ThreadPoolingSequence(2)

Print "'ThreadDispatching' with 2 secondary threads max:"
ThreadDispatchingSequence(2)
Print

'---------------------------------------------------

Print "'ThreadInitThenMultiStart' with 4 secondary threads:"
ThreadInitThenMultiStartSequence(4)

Print "'ThreadPooling' with 4 secondary threads:"
ThreadPoolingSequence(4)

Print "'ThreadDispatching' with 4 secondary threads max:"
ThreadDispatchingSequence(4)
Print

'---------------------------------------------------

Print "'ThreadInitThenMultiStart' with 8 secondary threads:"
ThreadInitThenMultiStartSequence(8)

Print "'ThreadPooling' with 8 secondary threads:"
ThreadPoolingSequence(8)

Print "'ThreadDispatching' with 8 secondary threads max:"
ThreadDispatchingSequence(8)
Print

'---------------------------------------------------

Print "'ThreadInitThenMultiStart' with 16 secondary threads:"
ThreadInitThenMultiStartSequence(16)

Print "'ThreadPooling' with 16 secondary threads:"
ThreadPoolingSequence(16)

Print "'ThreadDispatching' with 16 secondary threads max:"
ThreadDispatchingSequence(16)
Print

'---------------------------------------------------

Print "'ThreadInitThenMultiStart' with 32 secondary threads:"
ThreadInitThenMultiStartSequence(32)

Print "'ThreadPooling' with 32 secondary threads:"
ThreadPoolingSequence(32)

Print "'ThreadDispatching' with 32 secondary threads max:"
ThreadDispatchingSequence(32)
Print

Sleep


