'#Region "Form"
	#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
		#define __MAIN_FILE__
		#ifdef __FB_WIN32__
			#cmdline "Form1.rc"
		#endif
		Const _MAIN_FILE_ = __FILE__
	#endif
	#include once "mff/Form.bi"
	#include once "mff/ColorPicker.bi"
	#include once "mff/CommandButton.bi"
	#include once "mff/Panel.bi"
	#include once "mff/Label.bi"
	#include once "mff/TextBox.bi"
	#include once "mff/CheckBox.bi"
	Using My.Sys.Forms

	' Ported from PsControls/PsColorPicker/frmMain.inc(bi) (Paul Squires, MPL 2.0):
	' three rows. 0: anchored popup WITHOUT alpha, opened on Navy - via the
	' ShowColorPicker helper's ShowAlphaCh=False. 1: the ONE-LINE call with alpha,
	' out-parameters written only on OK (Esc/outside click leaves the swatch).
	' 2: a LIVE embedded picker with the colour callback - one BEGIN, many MOVEs,
	' one END - and the status band follows the drag.
	'
	' MFF additions: every selected colour now reports its HSL and RGBH (#RRGGBB)
	' both in the status band and ON its swatch (the picker prints them on the
	' Initial/Current halves too). All layout is computed in ApplyLayout from the
	' form's client size, so resizing the form resizes the swatches and the
	' picker, whose matrix/Web blocks stretch with it.

	'COLORREF layout on every platform (the family's shared macro)
	#ifndef PRGB
		#define PRGB(r, g, b) (Cast(ULong, (r) Or ((g) Shl 8) Or ((b) Shl 16)))
	#endif

	Type Form1Type Extends Form
		Declare Constructor
		Declare Static Sub btnPick_Click_(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
		Declare Sub btnPick_Click(ByRef Sender As Control)
		Declare Static Sub picker_Changed_(ByRef Designer As My.Sys.Object, ByRef Sender As ColorPicker, ByVal clr As ULong, ByVal nAlpha As UByte, ByVal nPhase As Long)
		Declare Sub picker_Changed(ByRef Sender As ColorPicker, ByVal clr As ULong, ByVal nAlpha As UByte, ByVal nPhase As Long)
		Declare Static Sub pnlSwatch_Paint_(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
		Declare Sub pnlSwatch_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
		Declare Static Sub chkDark_Check_(ByRef Designer As My.Sys.Object, ByRef Sender As CheckBox)
		Declare Sub chkDark_Check(ByRef Sender As CheckBox)
		Declare Static Sub Form_Resize_(ByRef Designer As My.Sys.Object, ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
		Declare Sub Form_Resize(ByVal nWidth As Long, ByVal nHeight As Long)
		Declare Sub ApplyLayout(ByVal nClientW As Long, ByVal nClientH As Long)
		Declare Sub UpdateStatus()

		Dim As CommandButton btnPick(0 To 2)   'the three raisers
		Dim As Panel pnlSwatch                 'the three colour swatches
		Dim As Label lblHead(0 To 2)           'row headings
		Dim As Label lblNote(0 To 2)           'row notes
		Dim As ColorPicker picker              'row 2's LIVE picker
		Dim As TextBox txtStatus               'the status band
		Dim As CheckBox chkDark                'dark mode toggle (every example ships one)
		Dim nColor(0 To 2) As ULong
		Dim nAlpha(0 To 2) As UByte
		Dim sPhase As String = "press a button to open the popup"
	End Type

	Constructor Form1Type
		#if _MAIN_FILE_ = __FILE__
			With App
				.CurLanguagePath = ExePath & "/Languages/"
				.CurLanguage = My.Sys.Language
			End With
		#endif
		' Form1
		With This
			.Name = "Form1"
			.Text = "ColorPicker Example - HSL/RGBH + scalable swatches"
			.Designer = @This
			.StartPosition = FormStartPosition.CenterScreen
			.OnResize = @Form_Resize_
			.SetBounds 0, 0, 900, 640
		End With

		'--- the starting colours (the Ps demo's gRowColor/gRowAlpha) --------------
		nColor(0) = PRGB(0, 0, 128)     : nAlpha(0) = 255   ' Navy
		nColor(1) = PRGB(97, 175, 239)  : nAlpha(1) = 180
		nColor(2) = PRGB(152, 195, 121) : nAlpha(2) = 255

		'--- the three headings + notes --------------------------------------------
		Dim sHead(0 To 2) As String = {"Anchored, no alpha", "Anchored, the default", "Live, embedded"}
		Dim sNote(0 To 2) As String = { _
		"Opens on Navy - the helper runs with ShowAlphaCh=False so the alpha row is hidden. Cancel with Esc or a click outside and the swatch does not move.", _
		"ONE LINE: ShowColorPicker(color, outColor, outAlpha). The two out-parameters are written only on OK, which is why a host can pass its live variables straight in.", _
		"An EMBEDDED ColorPicker with the colour callback: BEGIN / MOVE / END. Resize the form: the swatches and the picker's colour blocks scale with it."}
		For i As Long = 0 To 2
			With lblHead(i)
				.Name = "lblHead" & i
				.Text = sHead(i)
				.Designer = @This
				.Parent = @This
			End With
			With lblNote(i)
				.Name = "lblNote" & i
				.Text = sNote(i)
				.WordWraps = True
				.Designer = @This
				.Parent = @This
			End With
			With btnPick(i)
				.Name = "btnPick" & i
				.Text = "Pick colour..."
				.Designer = @This
				.Parent = @This
				.OnClick = @btnPick_Click_
			End With
		Next

		' pnlSwatch - ONE panel paints all three swatches and their HSL/RGBH text
		With pnlSwatch
			.Name = "pnlSwatch"
			.DoubleBuffered = True
			.Designer = @This
			.Parent = @This
			.OnPaint = @pnlSwatch_Paint_
		End With

		' picker - row 2's LIVE embedded picker. Its bounds come from ApplyLayout,
		' so the control (and every colour block in it) follows the form size.
		With picker
			.Name = "picker"
			.SetInitialColor nColor(2), nAlpha(2)
			.OnColorChanged = @picker_Changed_
			.Designer = @This
			.Parent = @This
		End With

		' txtStatus - the status band: RGB + alpha + RGBH + HSL for every row
		With txtStatus
			.Name = "txtStatus"
			.Text = ""
			.Multiline = True
			.ReadOnly = True
			.ScrollBars = ScrollBarsType.Vertical
			.Designer = @This
			.Parent = @This
		End With

		' chkDark - the dark mode toggle: one flip re-themes the whole tree
		With chkDark
			.Name = "chkDark"
			.Text = "Dark mode"
			.Designer = @This
			.Parent = @This
			.OnClick = @chkDark_Check_
		End With

		'Before the handle exists ClientWidth/Height are not measurable yet; the
		'first WM_SIZE calls Form_Resize and replaces this with the real values.
		ApplyLayout(This.Width - 16, This.Height - 40)
		UpdateStatus
	End Constructor

	'The ONE layout pass. Both columns, all three rows, the status band and the
	'picker are derived from the client size: no hard-coded swatch rectangles.
	Private Sub Form1Type.ApplyLayout(ByVal nClientW As Long, ByVal nClientH As Long)
		Dim nPad As Long = 8
		If nClientW < 360 Then nClientW = 360
		If nClientH < 300 Then nClientH = 300

		'Right column: the embedded picker, about 40% of the width.
		Dim nPickerW As Long = nClientW * 2 \ 5
		If nPickerW < 260 Then nPickerW = 260
		If nPickerW > 360 Then nPickerW = 360
		Dim nPickerX As Long = nClientW - nPad - nPickerW
		Dim nLeftW As Long = nPickerX - nPad * 2

		'Left column: a swatch strip plus the explanatory text.
		Dim nSwatchW As Long = nLeftW \ 4
		If nSwatchW < 76 Then nSwatchW = 76
		If nSwatchW > 150 Then nSwatchW = 150
		Dim nTextX As Long = nPad + nSwatchW + nPad
		Dim nTextW As Long = nPickerX - nPad - nTextX
		If nTextW < 120 Then nTextW = 120

		Dim nStatusH As Long = nClientH \ 4
		If nStatusH < 110 Then nStatusH = 110
		If nStatusH > 170 Then nStatusH = 170
		Dim nRowsH As Long = nClientH - nPad * 3 - nStatusH - 24
		If nRowsH < 180 Then nRowsH = 180
		Dim nRowH As Long = nRowsH \ 3

		For i As Long = 0 To 2
			Dim nTop As Long = nPad + i * nRowH
			btnPick(i).SetBounds nPad, nTop + 2, nSwatchW, 26
			lblHead(i).SetBounds nTextX, nTop, nTextW, 20
			lblNote(i).SetBounds nTextX, nTop + 22, nTextW, nRowH - 26
		Next

		pnlSwatch.SetBounds nPad, nPad + 34, nSwatchW, nRowsH - 34
		txtStatus.SetBounds nPad, nPad + nRowsH + nPad, nPickerX - nPad * 2, nStatusH
		chkDark.SetBounds nPad, nClientH - nPad - 24, nSwatchW, 24
		picker.SetBounds nPickerX, nPad, nPickerW, nClientH - nPad * 2
	End Sub

	Private Sub Form1Type.Form_Resize_(ByRef Designer As My.Sys.Object, ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
		(*Cast(Form1Type Ptr, Sender.Designer)).Form_Resize(NewWidth, NewHeight)
	End Sub

	Private Sub Form1Type.Form_Resize(ByVal nWidth As Long, ByVal nHeight As Long)
		If nWidth < 200 OrElse nHeight < 200 Then Exit Sub
		ApplyLayout(This.ClientWidth, This.ClientHeight)
		pnlSwatch.Repaint
	End Sub

	Private Function ClrToStr(ByVal clr As ULong, ByVal nA As UByte) As String
		Dim nR As Long = clr And &hFF
		Dim nG As Long = (clr Shr 8) And &hFF
		Dim nB As Long = (clr Shr 16) And &hFF
		Return "R=" & nR & " G=" & nG & " B=" & nB & "  A=" & nA & _
		"  RGBH=" & ColorPickerRGBH(clr) & "  (&h" & Hex(clr, 6) & ")" & !"\r\n" & _
		"       HSL " & ColorPickerHSL(clr)
	End Function

	'A luminance-based ink so the values stay readable on black AND white blocks.
	Private Function ContrastInk(ByVal nR As Long, ByVal nG As Long, ByVal nB As Long) As Integer
		Dim nLum As Long = (nR * 299 + nG * 587 + nB * 114) \ 1000
		Dim clrInk As ULong
		If nLum > 140 Then
			clrInk = PRGB(24, 26, 30)
		Else
			clrInk = PRGB(250, 250, 250)
		End If
		Return Cast(Integer, clrInk)
	End Function

	Private Sub Form1Type.UpdateStatus
		txtStatus.Text = "Row 0: " & ClrToStr(nColor(0), nAlpha(0)) & !"\r\n" & _
		"Row 1: " & ClrToStr(nColor(1), nAlpha(1)) & !"\r\n" & _
		"Row 2: " & ClrToStr(nColor(2), nAlpha(2)) & !"\r\n" & _
		sPhase
		pnlSwatch.Repaint
	End Sub

	Private Sub Form1Type.btnPick_Click_(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
		(*Cast(Form1Type Ptr, Sender.Designer)).btnPick_Click(Sender)
	End Sub

	Private Sub Form1Type.btnPick_Click(ByRef Sender As Control)
		Dim idx As Long = -1
		For i As Long = 0 To 2
			If @Sender = @btnPick(i) Then
				idx = i
				Exit For
			End If
		Next
		If idx < 0 Then Exit Sub
		Dim outColor As ULong = nColor(idx)
		Dim outAlpha As UByte = nAlpha(idx)
		Dim bOK As Boolean
		If idx = 0 Then
			'Row 0: anchored popup WITHOUT the alpha row, opened on Navy.
			bOK = ShowColorPicker(nColor(0), outColor, outAlpha, False)
		Else
			'Row 1: the ONE-LINE call, alpha included.
			bOK = ShowColorPicker(nColor(1), outColor, outAlpha, True)
		End If
		If bOK Then
			nColor(idx) = outColor
			nAlpha(idx) = outAlpha
			sPhase = "row " & idx & " accepted a colour"
		Else
			sPhase = "row " & idx & " cancelled - the swatch does not move"
		End If
		UpdateStatus
	End Sub

	Private Sub Form1Type.picker_Changed_(ByRef Designer As My.Sys.Object, ByRef Sender As ColorPicker, ByVal clr As ULong, ByVal nAlpha As UByte, ByVal nPhase As Long)
		(*Cast(Form1Type Ptr, Sender.Designer)).picker_Changed(Sender, clr, nAlpha, nPhase)
	End Sub

	Private Sub Form1Type.picker_Changed(ByRef Sender As ColorPicker, ByVal clr As ULong, ByVal nA As UByte, ByVal nPhase As Long)
		'One BEGIN, many MOVEs, one END - the Ps demo's phase trace.
		Select Case nPhase
		Case 0: sPhase = "BEGIN"
		Case 1: sPhase = "MOVE"
		Case 2: sPhase = "END"
		End Select
		nColor(2) = clr
		nAlpha(2) = nA
		UpdateStatus
	End Sub

	Private Sub Form1Type.pnlSwatch_Paint_(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
		(*Cast(Form1Type Ptr, Sender.Designer)).pnlSwatch_Paint(Sender, Canvas)
	End Sub

	Private Sub Form1Type.pnlSwatch_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
		'Three blocks of equal height, alpha composited over white and sized from
		'the panel's OWN bounds - so they scale with the form. Each block also
		'prints the selected colour's RGBH and HSL values.
		Dim nW As Long = Sender.Width
		Dim nH As Long = Sender.Height
		If nW < 20 OrElse nH < 30 Then Exit Sub
		Canvas.Font = Sender.Font
		Dim nPad As Long = 4
		Dim nBlockH As Long = (nH - nPad * 4) \ 3
		If nBlockH < 8 Then Exit Sub
		For i As Long = 0 To 2
			Dim nR As Long = nColor(i) And &hFF
			Dim nG As Long = (nColor(i) Shr 8) And &hFF
			Dim nB As Long = (nColor(i) Shr 16) And &hFF
			Dim nBlendR As Long = (nR * nAlpha(i) + 255 * (255 - nAlpha(i))) \ 255
			Dim nBlendG As Long = (nG * nAlpha(i) + 255 * (255 - nAlpha(i))) \ 255
			Dim nBlendB As Long = (nB * nAlpha(i) + 255 * (255 - nAlpha(i))) \ 255
			'Canvas.FillRect rescales its Rect argument IN PLACE (device pixels),
			'so keep the logical edges separately for the lines and the text.
			Dim nLeft As Long = nPad
			Dim nTop As Long = nPad + i * (nBlockH + nPad)
			Dim nRight As Long = nW - nPad
			Dim nBottom As Long = nTop + nBlockH
			Dim r As My.Sys.Drawing.Rect
			r.Left = nLeft : r.Top = nTop : r.Right = nRight : r.Bottom = nBottom
			Canvas.FillRect(r, Cast(Integer, PRGB(nBlendR, nBlendG, nBlendB)))
			Canvas.Line(nLeft, nTop, nRight, nTop, -1)
			Canvas.Line(nLeft, nBottom, nRight, nBottom, -1)
			If nBlockH >= 34 Then
				Dim sLineA As String
				If nW >= 130 Then
					sLineA = "RGBH " & ColorPickerRGBH(nColor(i)) & "  A" & nAlpha(i)
				Else
					sLineA = ColorPickerRGBH(nColor(i)) & " A" & nAlpha(i)
				End If
				Dim sLineB As String = ColorPickerHSLCompact(nColor(i))
				Dim clrInk As Integer = ContrastInk(nBlendR, nBlendG, nBlendB)
				Canvas.TextOut(nLeft + 6, nTop + 3, WStr(sLineA), clrInk, -1)
				If nBlockH >= 50 Then Canvas.TextOut(nLeft + 6, nTop + 19, WStr(sLineB), clrInk, -1)
			End If
		Next
	End Sub

	Private Sub Form1Type.chkDark_Check_(ByRef Designer As My.Sys.Object, ByRef Sender As CheckBox)
		(*Cast(Form1Type Ptr, Sender.Designer)).chkDark_Check(Sender)
	End Sub

	Private Sub Form1Type.chkDark_Check(ByRef Sender As CheckBox)
		'One flip re-themes everything: owner-drawn chrome resolves its
		'palette at paint time, native surfaces re-read WM_CTLCOLOR.
		App.DarkMode = Sender.Checked
		This.RefreshAll
	End Sub

	Dim Shared Form1 As Form1Type

	#if _MAIN_FILE_ = __FILE__
		Form1.MainForm = True
		Form1.Show
		App.Run
	#endif
'#End Region
