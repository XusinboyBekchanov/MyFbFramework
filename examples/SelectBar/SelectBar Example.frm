'#Region "Form"
	#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
		#define __MAIN_FILE__
		#ifdef __FB_WIN32__
			#cmdline "Form1.rc"
		#endif
		Const _MAIN_FILE_ = __FILE__
	#endif
	#include once "mff/Form.bi"
	#include once "mff/Label.bi"
	#include once "mff/SelectBar.bi"
	Using My.Sys.Forms

	'SelectBar demo: a view switcher whose current panel picks the text shown
	'below it, and a second bar with its own colours and a thick indicator.
	Type Form1Type Extends Form
		Declare Sub barView_Select(ByRef Sender As SelectBar, ByVal Index As Long)
		Declare Sub barPeriod_Select(ByRef Sender As SelectBar, ByVal Index As Long)
		Declare Constructor

		Dim As SelectBar barView, barPeriod
		Dim As Label lblView, lblPeriod
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
			.Text = "SelectBar Example"
			.Designer = @This
			.SetBounds 0, 0, 480, 300
		End With
		' barView
		With barView
			.Name = "barView"
			.SetBounds 10, 10, 440, 32
			.AddPanel "All", 1
			.AddPanel "Active", 2
			.AddPanel "Completed", 3
			.AddPanel "Archived", 4
			.SetEnabled 3, False
			.CurSel = 0
			.Designer = @This
			.OnSelect = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As SelectBar, ByVal Index As Long), @barView_Select)
			.Parent = @This
		End With
		' lblView
		With lblView
			.Name = "lblView"
			.Text = "View: All (panel ID 1)"
			.SetBounds 20, 55, 430, 40
			.Designer = @This
			.Parent = @This
		End With
		' barPeriod
		With barPeriod
			.Name = "barPeriod"
			.SetBounds 10, 120, 440, 36
			.AddPanel "Day"
			.AddPanel "Week"
			.AddPanel "Month"
			.AddPanel "Year"
			.PadLeft = 18
			.PadRight = 18
			.IndicatorHeight = 4
			.IndicatorColor = PRGB(255, 170, 0)
			.BarForeColorSelect = PRGB(255, 170, 0)
			.BarBackColor = PRGB(24, 28, 36)
			.BarBackColorHot = PRGB(36, 42, 54)
			.BarBackColorSelect = PRGB(24, 28, 36)
			.CurSel = 1
			.Designer = @This
			.OnSelect = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As SelectBar, ByVal Index As Long), @barPeriod_Select)
			.Parent = @This
		End With
		' lblPeriod
		With lblPeriod
			.Name = "lblPeriod"
			.Text = "Period: Week"
			.SetBounds 20, 170, 430, 20
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

Private Sub Form1Type.barView_Select(ByRef Sender As SelectBar, ByVal Index As Long)
	lblView.Text = "View: " & Sender.GetText(Index) & " (panel ID " & Sender.GetPanelID(Index) & ")"
End Sub

Private Sub Form1Type.barPeriod_Select(ByRef Sender As SelectBar, ByVal Index As Long)
	lblPeriod.Text = "Period: " & Sender.GetText(Index)
End Sub
