'###############################################################################
'#  Chart_Styles_Test.bas                                                      #
'#  Regression: every ChartStyle branch still renders after the Canvas         #
'#  conversion. Each chart gets small data; coverage is sampled from the       #
'#  screen (UTF-8 BOM, ASCII output).                                          #
'###############################################################################
#include once "mff/Form.bi"
#include once "mff/Chart.bi"
#ifndef UNICODE
	#define UNICODE
#endif
#include once "windows.bi"

Using My.Sys.Forms

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
	Declare Static Sub Charts_Create_(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
	Declare Sub Charts_Create(ByRef Sender As Control)
	Declare Constructor
	Dim As Chart cPie, cDonut, cArea, cGrouped, cStackedV, cStackedH
End Type

Constructor Form1
	With This
		.Name = "Form1"
		.Text = "Chart Styles Test"
		.SetBounds 0, 0, 660, 390
	End With
	With cPie
		.Name = "cPie": .Title = "Pie"
		.SetBounds 10, 10, 204, 161
		.Designer = @This: .OnCreate = @Charts_Create_
		.ChartStyle = ChartStyles.CS_Pie
		.Parent = @This
	End With
	With cDonut
		.Name = "cDonut": .Title = "Donut"
		.SetBounds 220, 10, 204, 161
		.ChartStyle = ChartStyles.CS_Donut
		.LabelsPosition = LabelsPositions.LP_TwoColumns
		.Parent = @This
	End With
	With cArea
		.Name = "cArea": .Title = "Area"
		.SetBounds 430, 10, 204, 161
		.ChartStyle = ChartStyles.CS_Area
		.FillOpacity = 50
		.Parent = @This
	End With
	With cGrouped
		.Name = "cGrouped": .Title = "Grouped"
		.SetBounds 10, 180, 204, 161
		.ChartStyle = ChartStyles.CS_GroupedColumn
		.FillOpacity = 50
		.Parent = @This
	End With
	With cStackedV
		.Name = "cStackedV": .Title = "Stacked V"
		.SetBounds 220, 180, 204, 161
		.ChartStyle = ChartStyles.CS_StackedBars
		.FillOpacity = 50
		.Parent = @This
	End With
	With cStackedH
		.Name = "cStackedH": .Title = "Stacked H"
		.SetBounds 430, 180, 204, 161
		.ChartStyle = ChartStyles.CS_StackedBars
		.ChartOrientation = ChartOrientations.CO_Horizontal
		.FillOpacity = 50
		.Parent = @This
	End With
End Constructor

Dim Shared fForm1 As Form1

Private Sub Form1.Charts_Create_(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
	(*Cast(Form1 Ptr, Sender.Designer)).Charts_Create(Sender)
End Sub

Private Sub Form1.Charts_Create(ByRef Sender As Control)
	Dim Axis As WStringList Ptr = New WStringList
	Axis->Add "2018": Axis->Add "2019": Axis->Add "2020"
	Dim V1 As DoubleList Ptr = New DoubleList
	V1->Add 10: V1->Add 15: V1->Add 5
	Dim V2 As DoubleList Ptr = New DoubleList
	V2->Add 8: V2->Add 4: V2->Add 12

	fForm1.cArea.AddAxisItems Axis
	fForm1.cArea.AddSerie "S1", clRed, V1
	fForm1.cArea.AddSerie "S2", clBlue, V2

	fForm1.cGrouped.AddAxisItems Axis
	fForm1.cGrouped.AddSerie "S1", clRed, V1
	fForm1.cGrouped.AddSerie "S2", clBlue, V2

	fForm1.cStackedV.AddAxisItems Axis
	fForm1.cStackedV.AddSerie "S1", clRed, V1
	fForm1.cStackedV.AddSerie "S2", clBlue, V2

	fForm1.cStackedH.AddAxisItems Axis
	fForm1.cStackedH.AddSerie "S1", clRed, V1
	fForm1.cStackedH.AddSerie "S2", clBlue, V2

	fForm1.cPie.AddItem "Juan", 70, clRed
	fForm1.cPie.AddItem "Adan", 20, clGreen
	fForm1.cPie.AddItem "Pedro", 10, clBlue

	fForm1.cDonut.AddItem "Juan", 70, clRed
	fForm1.cDonut.AddItem "Adan", 20, clGreen
	fForm1.cDonut.AddItem "Pedro", 10, clBlue
End Sub

'Returns the share of non-uniform pixels on a scan row inside the chart body
Private Function ChartCoverage(c As Chart Ptr, ByVal yHint As Long) As Double
	Dim hdc As HDC = GetDC(c->Handle)
	If hdc = 0 Then Return -1
	Dim w As Long = c->Width, hits As Long = 0, total As Long = 0
	Dim As Integer px, first = -2
	For x As Long = 20 To w - 20 Step 3
		px = GetPixel(hdc, x, yHint)
		total += 1
		If first = -2 Then first = px
		If px <> first Then hits += 1
	Next
	ReleaseDC(c->Handle, hdc)
	If total = 0 Then Return -1
	Return hits / total
End Function

	fForm1.Show
	UpdateWindow(fForm1.Handle)
	Sleep 120
	App.DoEvents
	Sleep 120
	App.DoEvents

	'Client-coordinate scan rows: the column charts' plot body sits in the
	'middle band of the 161 px tall control
	Dim c1 As Double = ChartCoverage(@fForm1.cPie, 60)
	Dim c2 As Double = ChartCoverage(@fForm1.cDonut, 60)
	Dim c3 As Double = ChartCoverage(@fForm1.cArea, 90)
	Dim c4 As Double = ChartCoverage(@fForm1.cGrouped, 110)
	Dim c5 As Double = ChartCoverage(@fForm1.cStackedV, 110)
	Dim c6 As Double = ChartCoverage(@fForm1.cStackedH, 100)
	Print Using "VERIFY pie=## donut=## area=## grouped=## stackedV=## stackedH=##"; CInt(c1 * 100); CInt(c2 * 100); CInt(c3 * 100); CInt(c4 * 100); CInt(c5 * 100); CInt(c6 * 100)
	Check "pie renders", c1 > 0
	Check "donut renders", c2 > 0
	Check "area renders", c3 > 0
	Check "grouped columns render", c4 > 0
	Check "stacked vertical renders", c5 > 0
	Check "stacked horizontal renders", c6 > 0

	Print IIf(nFailed = 0, "PASS", "FAIL")
	End
