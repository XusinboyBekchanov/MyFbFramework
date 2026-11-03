'###############################################################################
'#  Chart_100k_Test.bas                                                        #
'#  Chart Canvas pipeline + 100000-point stress benchmark (UTF-8 BOM).         #
'#  Output: ASCII console lines "BENCH ... PASS/FAIL" for automation.          #
'#  Timing uses TimerHiRes (QueryPerformanceCounter precision; the built-in    #
'#  Timer tick is ~15.6 ms and cannot resolve single paints).                  #
'###############################################################################
#include once "mff/Form.bi"
#include once "mff/Chart.bi"
#ifndef UNICODE
	#define UNICODE
#endif
#include once "windows.bi"

Using My.Sys.Forms

Const BIG_N As Long = 100000
Const PAINTS As Long = 30
Const WARMUPS As Long = 3

Dim Shared nFailed As Long

Private Sub Check(ByRef sWhat As String, bOK As Boolean)
	If bOK Then
		Print "  ok - " & sWhat
	Else
		nFailed += 1
		Print "  FAIL - " & sWhat
	End If
End Sub

Type Form1 Extends Form
	Declare Static Sub Chart1_Create_(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
	Declare Sub Chart1_Create(ByRef Sender As Control)
	Declare Constructor
	Dim As Chart Chart1
End Type

Constructor Form1
	With This
		.Name = "Form1"
		.Text = "Chart 100k Test"
		.SetBounds 0, 0, 820, 520
	End With
	With Chart1
		.Name = "Chart1"
		.Title = "Area 100k"
		.SetBounds 10, 10, 780, 460
		.Designer = @This
		.OnCreate = @Chart1_Create_
		.ChartStyle = ChartStyles.CS_Area
		.Border = False
		.FillOpacity = 50
		.FillGradient = True
		.LabelsFormats = "{V}"
		.Parent = @This
	End With
End Constructor

Dim Shared fForm1 As Form1

Private Sub Form1.Chart1_Create_(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
	(*Cast(Form1 Ptr, Sender.Designer)).Chart1_Create(Sender)
End Sub

Private Sub Form1.Chart1_Create(ByRef Sender As Control)
	Dim Axis As WStringList Ptr = New WStringList
	Dim V1 As DoubleList Ptr = New DoubleList
	Dim V2 As DoubleList Ptr = New DoubleList
	For k As Long = 0 To BIG_N - 1
		Axis->Add "P" & k
		V1->Add 50 + 45 * Sin(k / 500.0) + 5 * Sin(k / 17.0)
		V2->Add 50 + 40 * Cos(k / 800.0) + 8 * Cos(k / 23.0)
	Next
	Chart1.AddAxisItems Axis
	Chart1.AddSerie "S1", clRed, V1
	Chart1.AddSerie "S2", clBlue, V2
End Sub

Private Function BenchPaint(c As Chart Ptr, ByVal n As Long, ByVal bWarmup As Boolean) As Double
	Dim t0 As Double = TimerHiRes
	For i As Long = 1 To n
		c->Refresh
		UpdateWindow(c->Handle)
		'Pump the queue: a thread that never pumps gets its window flagged
		'hung after ~5 s and UpdateWindow stops delivering WM_PAINT
		App.DoEvents
		If bWarmup Then Sleep 1
	Next
	Return (TimerHiRes - t0) * 1000.0 / n
End Function

'Returns the share of non-background pixels on a scan line through the plot
'(0.0 would mean the chart body was never painted)
Private Function PlotCoverage(c As Chart Ptr, ByVal yHint As Long) As Double
	Dim hdc As HDC = GetDC(c->Handle)
	If hdc = 0 Then Return 0
	Dim As Long hits, total
	Dim As Integer px
	For x As Long = 80 To 700 Step 4
		px = GetPixel(hdc, x, yHint)
		total += 1
		If px <> -1 AndAlso (px And &HFFFFFF) <> &HFFFFFF Then hits += 1
	Next
	ReleaseDC(c->Handle, hdc)
	If total = 0 Then Return 0
	Return hits / total
End Function

	fForm1.Show
	UpdateWindow(fForm1.Handle)
	Sleep 100

	'Warmup: the first paints build the value caches and GDI+ structures
	BenchPaint(@fForm1.Chart1, WARMUPS, True)

	Dim As Double ms = BenchPaint(@fForm1.Chart1, PAINTS, False)
	Print "BENCH area100k_2series_gradient: " & Format(ms, "0.00") & " ms/paint"
	Debug.Print "Chart 100k paint: " & Format(ms, "0.00") & " ms/paint over " & PAINTS & " paints"

	'Verify the plot really rendered (scan through the middle of the plot area)
	Dim As Double cov = PlotCoverage(@fForm1.Chart1, 260)
	Print "VERIFY plot_coverage: " & Format(cov * 100, "0") & "%"
	Dim hdcChk As HDC = GetDC(fForm1.Chart1.Handle)
	Print "  raw pixels: " & Hex(GetPixel(hdcChk, 300, 260), 8) & " " & Hex(GetPixel(hdcChk, 400, 260), 8) & " " & Hex(GetPixel(hdcChk, 500, 200), 8)
	ReleaseDC(fForm1.Chart1.Handle, hdcChk)

	'No-gradient variant
	fForm1.Chart1.FillGradient = False
	Dim As Double msSolid = BenchPaint(@fForm1.Chart1, PAINTS, False)
	Print "BENCH area100k_2series_solid: " & Format(msSolid, "0.00") & " ms/paint"

	'Gate: a regression TRIPWIRE, not a performance claim. With the pixel-column
	'downsampling in place a full 2x100k repaint measures ~70-80 ms on an idle
	'machine (and ~100-300 ms when the box is busy - the DWM/compositor share is
	'outside our control, which is why an absolute tight bound is not stable).
	'Without the downsampling the same paint takes seconds, so 400 ms catches
	'the regression this test exists for; the printed numbers are the record.
	Check "100k paint under the regression tripwire", msSolid <= 400.0
	Print IIf(nFailed = 0 AndAlso cov > 0.05, "PASS", "FAIL")
	End
