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
	#include once "mff/Panel.bi"
	#include once "mff/CommandButton.bi"
	#include once "mff/ColorPicker.bi"
	Using My.Sys.Forms

	'ColorPicker demo: a picker embedded in the form (the swatch on the right
	'follows it live, OK commits the colour) and the modal ShowColorPicker
	'dialog opened from a button.
	Type Form1Type Extends Form
		Declare Sub cpColor_ColorChanged(ByRef Sender As ColorPicker, ByVal clr As ULong, ByVal nAlpha As UByte, ByVal nPhase As Long)
		Declare Sub cpColor_OK(ByRef Sender As ColorPicker)
		Declare Sub cpColor_Cancel(ByRef Sender As ColorPicker)
		Declare Sub cmdDialog_Click(ByRef Sender As Control)
		Declare Sub ShowColor(ByRef Prefix As WString, ByVal clr As ULong, ByVal nAlpha As UByte)
		Declare Constructor

		Dim As ColorPicker cpColor
		Dim As Panel pnlLive, pnlCommitted
		Dim As Label lblLive, lblCommitted, lblInfo
		Dim As CommandButton cmdDialog
		Dim As ULong CommittedColor = PRGB(30, 144, 255)
	End Type

	Constructor Form1Type
		#if _MAIN_FILE_ = __FILE__
			With App
				.CurLanguagePath = ExePath & "/Languages/"
				.CurLanguage = My.Sys.Language
			End With
		#endif
		Dim As Long pw, ph
		cpColor.GetIdealSize pw, ph
		' Form1
		With This
			.Name = "Form1"
			.Text = "ColorPicker Example"
			.Designer = @This
			.SetBounds 0, 0, pw + 300, ph + 60
		End With
		' cpColor
		With cpColor
			.Name = "cpColor"
			.SetBounds 10, 10, pw, ph
			.SetInitialColor CommittedColor
			.Designer = @This
			.OnColorChanged = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ColorPicker, ByVal clr As ULong, ByVal nAlpha As UByte, ByVal nPhase As Long), @cpColor_ColorChanged)
			.OnOK = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ColorPicker), @cpColor_OK)
			.OnCancel = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ColorPicker), @cpColor_Cancel)
			.Parent = @This
		End With
		' lblLive
		With lblLive
			.Name = "lblLive"
			.Text = "Live:"
			.SetBounds pw + 30, 10, 240, 20
			.Designer = @This
			.Parent = @This
		End With
		' pnlLive
		With pnlLive
			.Name = "pnlLive"
			.SetBounds pw + 30, 34, 240, 60
			.BackColor = CommittedColor
			.Designer = @This
			.Parent = @This
		End With
		' lblCommitted
		With lblCommitted
			.Name = "lblCommitted"
			.Text = "Committed (OK):"
			.SetBounds pw + 30, 110, 240, 20
			.Designer = @This
			.Parent = @This
		End With
		' pnlCommitted
		With pnlCommitted
			.Name = "pnlCommitted"
			.SetBounds pw + 30, 134, 240, 60
			.BackColor = CommittedColor
			.Designer = @This
			.Parent = @This
		End With
		' cmdDialog
		With cmdDialog
			.Name = "cmdDialog"
			.Text = "Modal dialog..."
			.SetBounds pw + 30, 214, 140, 30
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdDialog_Click)
			.Parent = @This
		End With
		' lblInfo
		With lblInfo
			.Name = "lblInfo"
			.Text = ""
			.SetBounds pw + 30, 260, 240, 60
			.Designer = @This
			.Parent = @This
		End With
		ShowColor "Initial", CommittedColor, 255
	End Constructor

	Dim Shared Form1 As Form1Type

	#if _MAIN_FILE_ = __FILE__
		App.DarkMode = True
		Form1.MainForm = True
		Form1.Show
		App.Run
	#endif
'#End Region

Private Sub Form1Type.ShowColor(ByRef Prefix As WString, ByVal clr As ULong, ByVal nAlpha As UByte)
	lblInfo.Text = Prefix & ": R=" & (clr And &hFF) & " G=" & ((clr Shr 8) And &hFF) & " B=" & ((clr Shr 16) And &hFF) & " A=" & nAlpha
End Sub

Private Sub Form1Type.cpColor_ColorChanged(ByRef Sender As ColorPicker, ByVal clr As ULong, ByVal nAlpha As UByte, ByVal nPhase As Long)
	'cpPhaseBegin / cpPhaseMove arrive while dragging, cpPhaseEnd once it is released
	pnlLive.BackColor = clr
	ShowColor IIf(nPhase = cpPhaseEnd, "Changed", "Dragging"), clr, nAlpha
End Sub

Private Sub Form1Type.cpColor_OK(ByRef Sender As ColorPicker)
	CommittedColor = Sender.PickedColor
	pnlCommitted.BackColor = CommittedColor
	ShowColor "Committed", CommittedColor, Sender.PickedAlpha
End Sub

Private Sub Form1Type.cpColor_Cancel(ByRef Sender As ColorPicker)
	'Esc: go back to the last committed colour
	Sender.SetInitialColor CommittedColor
	pnlLive.BackColor = CommittedColor
	ShowColor "Cancelled", CommittedColor, 255
End Sub

Private Sub Form1Type.cmdDialog_Click(ByRef Sender As Control)
	Dim As ULong clr
	Dim As UByte nAlpha
	If ShowColorPicker(CommittedColor, clr, nAlpha, True, "Pick a colour") Then
		CommittedColor = clr
		pnlCommitted.BackColor = clr
		pnlLive.BackColor = clr
		cpColor.SetInitialColor clr, nAlpha
		ShowColor "From dialog", clr, nAlpha
	Else
		ShowColor "Dialog cancelled", CommittedColor, 255
	End If
End Sub
