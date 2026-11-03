'#Region "Form"
	#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
		#define __MAIN_FILE__
		#ifdef __FB_WIN32__
			#cmdline "Form1.rc"
		#endif
		Const _MAIN_FILE_ = __FILE__
	#endif
	#include once "mff/Form.bi"
	#include once "mff/Panel.bi"
	#include once "mff/Label.bi"
	#include once "mff/CommandButton.bi"
	#include once "mff/Ruler.bi"
	Using My.Sys.Forms

	'Ruler demo: a horizontal ruler above and a vertical one beside a design
	'surface. Moving the mouse over the surface drives both tracker lines, the
	'vertical ruler marks the band boundaries drawn on the surface and the
	'buttons switch the units.
	Type Form1Type Extends Form
		Declare Sub pnlSurface_MouseMove(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Sub pnlSurface_MouseLeave(ByRef Sender As Control)
		Declare Sub pnlSurface_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
		Declare Sub cmdUnits_Click(ByRef Sender As Control)
		Declare Constructor

		Dim As Ruler rulTop, rulLeft
		Dim As Panel pnlSurface
		Dim As Label lblInfo
		Dim As CommandButton cmdPixels, cmdInches, cmdCentimeters
		Dim As Integer Bands(4) = {0, 60, 180, 300, 340}
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
			.Text = "Ruler Example"
			.Designer = @This
			.SetBounds 0, 0, 560, 470
		End With
		' rulTop
		With rulTop
			.Name = "rulTop"
			.Orientation = ruHorizontal
			.Units = ruPixels
			.SetBounds 34, 10, 500, 24
			.Designer = @This
			.Parent = @This
		End With
		' rulLeft
		With rulLeft
			.Name = "rulLeft"
			.Orientation = ruVertical
			.Units = ruPixels
			.SetBounds 10, 34, 24, 340
			For i As Integer = 0 To UBound(Bands)
				.AddMarker Bands(i)
			Next
			.Designer = @This
			.Parent = @This
		End With
		' pnlSurface
		With pnlSurface
			.Name = "pnlSurface"
			.SetBounds 34, 34, 500, 340
			.BackColor = BGR(255, 255, 255)
			.Designer = @This
			.OnMouseMove = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer), @pnlSurface_MouseMove)
			.OnMouseLeave = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @pnlSurface_MouseLeave)
			.OnPaint = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas), @pnlSurface_Paint)
			.Parent = @This
		End With
		' cmdPixels
		With cmdPixels
			.Name = "cmdPixels"
			.Text = "Pixels"
			.SetBounds 34, 386, 100, 28
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdUnits_Click)
			.Parent = @This
		End With
		' cmdInches
		With cmdInches
			.Name = "cmdInches"
			.Text = "Inches"
			.SetBounds 140, 386, 100, 28
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdUnits_Click)
			.Parent = @This
		End With
		' cmdCentimeters
		With cmdCentimeters
			.Name = "cmdCentimeters"
			.Text = "Centimeters"
			.SetBounds 246, 386, 100, 28
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdUnits_Click)
			.Parent = @This
		End With
		' lblInfo
		With lblInfo
			.Name = "lblInfo"
			.Text = "Move the mouse over the surface"
			.SetBounds 360, 392, 180, 20
			.Designer = @This
			.Parent = @This
		End With
	End Constructor

	Dim Shared Form1 As Form1Type

	#if _MAIN_FILE_ = __FILE__
		App.DarkMode = True
		Form1.MainForm = True
		Form1.Show
		App.Run
	#endif
'#End Region

Private Sub Form1Type.pnlSurface_MouseMove(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
	rulTop.MousePosition = x
	rulLeft.MousePosition = y
	lblInfo.Text = "X: " & x & "  Y: " & y
End Sub

Private Sub Form1Type.pnlSurface_MouseLeave(ByRef Sender As Control)
	rulTop.MousePosition = -1
	rulLeft.MousePosition = -1
End Sub

Private Sub Form1Type.pnlSurface_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
	'The report-like bands whose boundaries the vertical ruler marks
	For i As Integer = 1 To UBound(Bands)
		Canvas.Line 0, Bands(i), Sender.Width, Bands(i), BGR(200, 200, 210)
	Next
	Canvas.TextOut 8, 20, "Page header", BGR(90, 90, 100), -1
	Canvas.TextOut 8, 110, "Detail", BGR(90, 90, 100), -1
	Canvas.TextOut 8, 230, "Summary", BGR(90, 90, 100), -1
	Canvas.TextOut 8, 312, "Page footer", BGR(90, 90, 100), -1
End Sub

Private Sub Form1Type.cmdUnits_Click(ByRef Sender As Control)
	Dim As RulerUnits u
	If @Sender = @cmdInches Then
		u = ruInches
	ElseIf @Sender = @cmdCentimeters Then
		u = ruCentimeters
	Else
		u = ruPixels
	End If
	rulTop.Units = u
	rulLeft.Units = u
End Sub
