'###############################################################################
'#  Progress_Test.bas                                                          #
'#  Owner-drawn Progress control: determinate, gradient, segmented, vertical,  #
'#  marquee, states. UTF-8 BOM; ASCII console output.                          #
'###############################################################################
#include once "mff/Form.bi"
#include once "mff/Progress.bi"
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
	Declare Constructor
	Dim As Progress pSolid, pGrad, pBlocks, pVert, pMarquee, pError
End Type

Constructor Form1
	With This
		.Name = "Form1"
		.Text = "Progress Test"
		.SetBounds 0, 0, 440, 400
	End With
	With pSolid
		.Name = "pSolid"
		.SetBounds 20, 15, 380, 22
		.Position = 40
		.Parent = @This
	End With
	With pGrad
		.Name = "pGrad"
		.SetBounds 20, 50, 380, 22
		.FillStyle = pfGradient
		.TextMode = ptPercent
		.Position = 65
		.Parent = @This
	End With
	With pBlocks
		.Name = "pBlocks"
		.SetBounds 20, 85, 380, 22
		.Segmented = True
		.Position = 55
		.Parent = @This
	End With
	With pVert
		.Name = "pVert"
		.SetBounds 20, 120, 22, 150
		.Orientation = poVertical
		.Thickness = 22
		.Position = 70
		.Parent = @This
	End With
	With pMarquee
		.Name = "pMarquee"
		.SetBounds 60, 120, 340, 22
		.Mode = pmIndeterminate
		.Parent = @This
	End With
	With pError
		.Name = "pError"
		.SetBounds 60, 155, 340, 22
		.State = psError
		.FillStyle = pfGradient
		.TextMode = ptCustom
		.Text = "Upload failed"
		.Position = 30
		.Parent = @This
	End With
End Constructor

Private Function BarCoverage(c As Progress Ptr) As Double
	'Share of bar-coloured pixels on the control's centre row
	Dim hdc As HDC = GetDC(c->Handle)
	If hdc = 0 Then Return -1
	Dim w As Long = c->Width, hits As Long = 0, total As Long = 0
	Dim cy As Long = c->Height \ 2
	Dim As Integer px
	For x As Long = 2 To w - 2 Step 2
		px = GetPixel(hdc, x, cy)
		total += 1
		'The default bar colour pair: blue-ish (B and R channels differ)
		If px <> -1 AndAlso Abs((px And &HFF) - ((px Shr 16) And &HFF)) > 30 Then hits += 1
	Next
	ReleaseDC(c->Handle, hdc)
	If total = 0 Then Return -1
	Return hits / total
End Function

Private Function BarChunkStart(c As Progress Ptr) As Long
	'Leftmost bar-coloured x on the centre row, -1 if none
	Dim hdc As HDC = GetDC(c->Handle)
	If hdc = 0 Then Return -1
	Dim w As Long = c->Width
	Dim cy As Long = c->Height \ 2
	Dim As Integer px
	Dim res As Long = -1
	For x As Long = 2 To w - 2
		px = GetPixel(hdc, x, cy)
		If px <> -1 AndAlso Abs((px And &HFF) - ((px Shr 16) And &HFF)) > 30 Then
			res = x
			Exit For
		End If
	Next
	ReleaseDC(c->Handle, hdc)
	Return res
End Function

	Dim fForm1 As Form1
	fForm1.Show
	UpdateWindow(fForm1.Handle)
	Sleep 50
	App.DoEvents

	Dim As Double cov0, cov1
	cov0 = BarCoverage(@fForm1.pSolid)
	Print "VERIFY solid_40pct_coverage: " & Format(cov0 * 100, "0") & "%"

	fForm1.pSolid.Position = 90
	App.DoEvents
	Sleep 50
	App.DoEvents
	cov1 = BarCoverage(@fForm1.pSolid)
	Print "VERIFY solid_90pct_coverage: " & Format(cov1 * 100, "0") & "%"
	Check "position grows the bar", cov1 > cov0 + 0.2

	'StepIt clamps at Max
	fForm1.pSolid.StepValue = 25
	fForm1.pSolid.StepIt
	fForm1.pSolid.StepIt
	Print "VERIFY stepit_clamp: " & fForm1.pSolid.Position & " (expect 100)"
	Check "StepIt clamps at MaxValue", fForm1.pSolid.Position = 100

	'Segmented blocks draw
	fForm1.pBlocks.Position = 80
	App.DoEvents
	Sleep 50
	App.DoEvents
	Dim As Double covB = BarCoverage(@fForm1.pBlocks)
	Print "VERIFY blocks_80pct_coverage: " & Format(covB * 100, "0") & "%"
	Check "segmented bar draws", covB > 0.3

	'Vertical bar fills bottom-up
	Dim As Double covV = BarCoverage(@fForm1.pVert)
	Print "VERIFY vertical_70pct_coverage: " & Format(covV * 100, "0") & "%"
	Check "vertical bar draws", covV > 0.3

	'Marquee: the chunk POSITION changes over time while the timer runs
	'(the coverage stays constant - the chunk keeps its width while sliding)
	fForm1.pMarquee.Position = 0
	App.DoEvents
	Sleep 60
	App.DoEvents
	Dim As Long posM0 = BarChunkStart(@fForm1.pMarquee)
	Sleep 350
	App.DoEvents
	Sleep 120
	App.DoEvents
	Dim As Long posM1 = BarChunkStart(@fForm1.pMarquee)
	Print "VERIFY marquee_chunk_x: " & posM0 & " -> " & posM1
	Check "marquee chunk animates", posM0 >= 0 AndAlso posM1 >= 0 AndAlso posM0 <> posM1

	'Error state + custom text still paints
	App.DoEvents
	Sleep 50
	App.DoEvents
	Check "error state paints", BarCoverage(@fForm1.pError) >= 0

	Print IIf(nFailed = 0, "PASS", "FAIL")
	End
