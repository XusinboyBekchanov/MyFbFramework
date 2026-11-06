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
	' one END - and the status band follows the drag. The Ps demo centred its
	' third popup and decorated it with a paint callback; the MFF picker instead
	' EMBEDS as a control, which shows the same machinery without a popup.

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
			.Text = "ColorPicker Example - PsColorPicker demo port"
			.Designer = @This
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
		"An EMBEDDED ColorPicker with the colour callback: one BEGIN, many MOVEs, one END - the status band below follows the drag."}
		For i As Long = 0 To 2
			With lblHead(i)
				.Name = "lblHead" & i
				.Text = sHead(i)
				.SetBounds 140, 18 + i * 130, 380, 20
				.Designer = @This
				.Parent = @This
			End With
			With lblNote(i)
				.Name = "lblNote" & i
				.Text = sNote(i)
				.SetBounds 140, 42 + i * 130, 380, 56
				.Designer = @This
				.Parent = @This
			End With
			With btnPick(i)
				.Name = "btnPick" & i
				.Text = "Pick colour..."
				.SetBounds 8, 22 + i * 130, 120, 26
				.Designer = @This
				.Parent = @This
				.OnClick = @btnPick_Click_
			End With
		Next

		' pnlSwatch - the three swatches, painted with their alpha
		With pnlSwatch
			.Name = "pnlSwatch"
			.SetBounds 140, 100 + 0 * 130, 0, 0
			.DoubleBuffered = True
			.Designer = @This
			.Parent = @This
			.OnPaint = @pnlSwatch_Paint_
		End With
		pnlSwatch.SetBounds 8, 60, 120, 48
		pnlSwatch.SetBounds 8, 190, 120, 48
		' the third swatch is drawn by the same panel; widen it to cover row 2
		pnlSwatch.SetBounds 8, 60, 120, 250

		' picker - row 2's LIVE embedded picker (the Ps demo centred a popup and
		' decorated it; here the same machinery is shown without a popup)
		Dim iw As Long, ih As Long
		picker.GetIdealSize iw, ih
		With picker
			.Name = "picker"
			.SetInitialColor nColor(2), nAlpha(2)
			.OnColorChanged = @picker_Changed_
			.Designer = @This
			.Parent = @This
			.SetBounds 540, 6, iw, ih + 120
		End With
		
		' txtStatus - the status band (colour + phase), like the Ps demo's footer
		With txtStatus
			.Name = "txtStatus"
			.Text = ""
			.SetBounds 8, 96 + 250 + 8, 386, 120
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
			.SetBounds 10, This.Height - 64, 120, 24
			.Designer = @This
			.Parent = @This
			.OnClick = @chkDark_Check_
		End With

		UpdateStatus
	End Constructor

	Private Function ClrToStr(ByVal clr As ULong, ByVal nA As UByte) As String
		Dim nR As Long = clr And &hFF
		Dim nG As Long = (clr Shr 8) And &hFF
		Dim nB As Long = (clr Shr 16) And &hFF
		Return "R=" & nR & " G=" & nG & " B=" & nB & "  A=" & nA & "  (&h" & Hex(clr, 6) & ")"
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
		'The three swatches, alpha composited over the panel's own background.
		For i As Long = 0 To 2
			Dim nR As Long = nColor(i) And &hFF
			Dim nG As Long = (nColor(i) Shr 8) And &hFF
			Dim nB As Long = (nColor(i) Shr 16) And &hFF
			Dim nBlendR As Long = (nR * nAlpha(i) + 255 * (255 - nAlpha(i))) \ 255
			Dim nBlendG As Long = (nG * nAlpha(i) + 255 * (255 - nAlpha(i))) \ 255
			Dim nBlendB As Long = (nB * nAlpha(i) + 255 * (255 - nAlpha(i))) \ 255
			Dim r As My.Sys.Drawing.Rect
			r.Left = 6 : r.Top = 6 + i * 82 : r.Right = 114 : r.Bottom = 6 + i * 82 + 48
			Canvas.FillRect(r, Cast(Integer, PRGB(nBlendR, nBlendG, nBlendB)))
			Canvas.Line(6, 6 + i * 82, 114, 6 + i * 82, -1)
			Canvas.Line(6, 6 + i * 82 + 48, 114, 6 + i * 82 + 48, -1)
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
