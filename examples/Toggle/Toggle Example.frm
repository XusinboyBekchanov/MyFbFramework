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
	#include once "mff/Toggle.bi"
	Using My.Sys.Forms

	'Toggle demo: a plain switch, a big green one, a disabled pair and a
	'master switch that enables / disables the others.
	Type Form1Type Extends Form
		Declare Sub tglWifi_CheckChanged(ByRef Sender As Toggle, ByVal isChecked As Boolean)
		Declare Sub tglBig_CheckChanged(ByRef Sender As Toggle, ByVal isChecked As Boolean)
		Declare Sub tglMaster_CheckChanged(ByRef Sender As Toggle, ByVal isChecked As Boolean)
		Declare Constructor

		Dim As Toggle tglWifi, tglBig, tglOff, tglOn, tglMaster
		Dim As Label lblWifi, lblBig, lblOff, lblOn, lblMaster, lblInfo
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
			.Text = "Toggle Example"
			.Designer = @This
			.SetBounds 0, 0, 380, 320
		End With
		' lblWifi
		With lblWifi
			.Name = "lblWifi"
			.Text = "Wi-Fi"
			.SetBounds 20, 22, 200, 20
			.Designer = @This
			.Parent = @This
		End With
		' tglWifi
		With tglWifi
			.Name = "tglWifi"
			.SetBounds 240, 18, 60, 28
			.Checked = True
			.Designer = @This
			.OnCheckChanged = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Toggle, ByVal isChecked As Boolean), @tglWifi_CheckChanged)
			.Parent = @This
		End With
		' lblBig
		With lblBig
			.Name = "lblBig"
			.Text = "Big green switch"
			.SetBounds 20, 66, 200, 20
			.Designer = @This
			.Parent = @This
		End With
		' tglBig
		With tglBig
			.Name = "tglBig"
			.SetBounds 240, 56, 80, 40
			.TrackWidth = 64
			.TrackHeight = 32
			.KnobInset = 4
			.TrackColorOn = PRGB(46, 160, 67)
			.TrackColorOnHot = PRGB(60, 190, 85)
			.TrackBorderColorOn = PRGB(46, 160, 67)
			.TrackBorderColorOnHot = PRGB(60, 190, 85)
			.Designer = @This
			.OnCheckChanged = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Toggle, ByVal isChecked As Boolean), @tglBig_CheckChanged)
			.Parent = @This
		End With
		' lblOff
		With lblOff
			.Name = "lblOff"
			.Text = "Disabled (off)"
			.SetBounds 20, 116, 200, 20
			.Designer = @This
			.Parent = @This
		End With
		' tglOff
		With tglOff
			.Name = "tglOff"
			.SetBounds 240, 112, 60, 28
			.Enabled = False
			.Designer = @This
			.Parent = @This
		End With
		' lblOn
		With lblOn
			.Name = "lblOn"
			.Text = "Disabled (on)"
			.SetBounds 20, 156, 200, 20
			.Designer = @This
			.Parent = @This
		End With
		' tglOn
		With tglOn
			.Name = "tglOn"
			.SetBounds 240, 152, 60, 28
			.Checked = True
			.Enabled = False
			.Designer = @This
			.Parent = @This
		End With
		' lblMaster
		With lblMaster
			.Name = "lblMaster"
			.Text = "Enable the two switches above"
			.SetBounds 20, 202, 210, 20
			.Designer = @This
			.Parent = @This
		End With
		' tglMaster
		With tglMaster
			.Name = "tglMaster"
			.SetBounds 240, 198, 60, 28
			.Designer = @This
			.OnCheckChanged = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Toggle, ByVal isChecked As Boolean), @tglMaster_CheckChanged)
			.Parent = @This
		End With
		' lblInfo
		With lblInfo
			.Name = "lblInfo"
			.Text = "Click a switch or press Space / Enter on it"
			.SetBounds 20, 245, 330, 20
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

Private Sub Form1Type.tglWifi_CheckChanged(ByRef Sender As Toggle, ByVal isChecked As Boolean)
	lblInfo.Text = "Wi-Fi: " & IIf(isChecked, "On", "Off")
End Sub

Private Sub Form1Type.tglBig_CheckChanged(ByRef Sender As Toggle, ByVal isChecked As Boolean)
	lblInfo.Text = "Big switch: " & IIf(isChecked, "On", "Off")
End Sub

Private Sub Form1Type.tglMaster_CheckChanged(ByRef Sender As Toggle, ByVal isChecked As Boolean)
	tglOff.Enabled = isChecked
	tglOn.Enabled = isChecked
	lblInfo.Text = "The two switches are " & IIf(isChecked, "enabled", "disabled")
End Sub
