'#Region "Form"
	#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
		#define __MAIN_FILE__
		#ifdef __FB_WIN32__
			#cmdline "Form1.rc"
		#endif
		Const _MAIN_FILE_ = __FILE__
	#endif
	#include once "mff/Form.bi"
	#include once "mff/Progress.bi"
	#include once "mff/TextBox.bi"
	#include once "mff/CheckBox.bi"
	Using My.Sys.Forms

	' Ported from PsControls/PsProgressBar/frmMain.inc(bi) (Paul Squires, MPL 2.0):
	' twelve horizontal bars (percent text, gradient sheen, blocks, blocks+one
	' horizontal ramp, indeterminate BOUNCE, indeterminate WRAP, paused/error
	' states, disabled, reverse, square+border) and three vertical bars
	' (bottom-up, reversed top-down, indeterminate blocks). A demo clock drives
	' the determinate rows toward 100 and wraps; the Ps host-paint row and the
	' tooltip doors have no MFF counterpart yet and are noted.
	
	Type Form1Type Extends Form
		Declare Constructor
		Declare Static Sub tmrDemo_Timer_(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent)
		Declare Sub tmrDemo_Timer(ByRef Sender As TimerComponent)
		Declare Static Sub chkDark_Check_(ByRef Designer As My.Sys.Object, ByRef Sender As CheckBox)
		Declare Sub chkDark_Check(ByRef Sender As CheckBox)
		Declare Sub LogLine(ByVal sMsg As String)
		
		Dim As Progress bar(0 To 11)   'the twelve horizontal variants
		Dim As Progress vbar(0 To 4)   'the vertical strip
		Dim As TextBox txtLog
		Dim As CheckBox chkDark        'dark mode toggle (every example ships one)
		Dim As TimerComponent tmrDemo  'the demo's own clock
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
			.Text = "Progress Example - PsProgressBar demo port"
			.Designer = @This
			.SetBounds 0, 0, 760, 560
		End With

		' txtLog - the demo clock's wraps
		With txtLog
			.Name = "txtLog"
			.Text = "--- demo clock ---"
			.SetBounds 8, 396, 500, 128
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
			.SetBounds This.Width - 130, This.Height - 34, 120, 24
			.Designer = @This
			.Parent = @This
			.OnClick = @chkDark_Check_
		End With

		'--- the twelve horizontal rows (all at 45 like the Ps demo) -------------
		For i As Long = 0 To 11
			bar(i).Name = "bar" & i
			bar(i).SetBounds 8, 8 + i * 32, 500, 24
			bar(i).Designer = @This
			bar(i).Parent = @This
			bar(i).Position = 45
		Next
		' Row 0 - the defaults + a percentage.
		bar(0).TextMode = ptPercent
		' Row 1 - gradient-filled (the default gradient mode is the vertical
		' glossy sheen rather than a left-to-right ramp).
		bar(1).FillStyle = pfGradient
		bar(1).TextMode = ptPercent
		' Row 2 - blocks, flat colour.
		bar(2).Segmented = True
		' Row 3 - blocks AND gradient: each block takes its slice of ONE ramp.
		bar(3).Segmented = True
		bar(3).FillStyle = pfGradient
		' Row 4 - indeterminate, bouncing.
		bar(4).FillStyle = pfGradient
		bar(4).Mode = pmIndeterminate
		' Row 5 - indeterminate, wrapping: the chunk slides off one end and back.
		bar(5).MarqueeStyle = msWrap
		bar(5).ChunkPercent = 18
		bar(5).Mode = pmIndeterminate
		' Row 6 - PBM_SETSTATE's paused colours, with the raw value written.
		bar(6).State = psPaused
		bar(6).TextMode = ptValue
		' Row 7 - the error colours (the Ps host TEXT callback has no MFF
		' counterpart yet; the value text stands in for the callback string).
		bar(7).State = psError
		bar(7).FillStyle = pfGradient
		bar(7).TextMode = ptCustom
		' Row 8 - disabled: the split-colour text collapses to one colour.
		bar(8).TextMode = ptPercent
		bar(8).Enabled = False
		' Row 9 - reverse: mirrored growth direction.
		bar(9).FillStyle = pfGradient
		bar(9).Reverse = True
		' Row 10 - square corners and a visible track border.
		bar(10).Curvature = 0
		bar(10).BorderThickness = 1
		bar(10).BarInset = 2
		' Row 11 - the Ps host-paint row (chips); noted, geometry only here.
		bar(11).TextMode = ptPercent
		'--- the vertical strip ---------------------------------------------------
		For i As Long = 0 To 4
			vbar(i).Name = "vbar" & i
			vbar(i).SetBounds 524 + i * 40, 8, 24, 380
			vbar(i).Designer = @This
			vbar(i).Parent = @This
			vbar(i).FillStyle = pfGradient
			vbar(i).Orientation = poVertical
			vbar(i).Position = 60
		Next
		
		' v1 - reversed, i.e. top-down.
		vbar(1).Reverse = True
		' v2 - indeterminate blocks, so the bounce is seen on the other axis.
		vbar(2).Segmented = True
		vbar(2).Mode = pmIndeterminate
		vbar(4).SetBounds 524 + 3 * 40, 100, 50, 50
		vbar(3).Shape = ProgressShapes.pshRingLarge
		vbar(3).Thickness = 6
		vbar(4).SetBounds 524 + 4 * 40, 200, 50, 50
		vbar(4).Shape = ProgressShapes.pshRingSmall
		vbar(4).Thickness = 16
		vbar(4).TextMode = ptPercent
		'--- the demo clock -------------------------------------------------------
		tmrDemo.Designer = @This
		tmrDemo.Interval = 60
		tmrDemo.OnTimer = @tmrDemo_Timer_
		tmrDemo.Enabled = True
	End Constructor

	Private Sub Form1Type.LogLine(ByVal sMsg As String)
		txtLog.Text = txtLog.Text & sMsg & !"\r\n"
	End Sub

	Private Sub Form1Type.tmrDemo_Timer_(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent)
		(*Cast(Form1Type Ptr, Sender.Designer)).tmrDemo_Timer(Sender)
	End Sub

	Private Sub Form1Type.tmrDemo_Timer(ByRef Sender As TimerComponent)
		'The determinate rows march together and wrap at 100, like the Ps clock.
		Static nPos As Long = 45
		nPos += 3
		If nPos > 100 Then
			nPos = 0
			LogLine "determinate rows wrapped"
		End If
		For i As Long = 0 To 3
			bar(i).Position = nPos
		Next
		bar(6).Position = nPos
		bar(7).Position = nPos
		bar(8).Position = nPos
		bar(9).Position = nPos
		bar(10).Position = nPos
		bar(11).Position = nPos
		vbar(0).Position = 100 - nPos
		vbar(1).Position = nPos
		vbar(3).Position = 100 - nPos
		vbar(4).Position = nPos
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
