'################################################################################
'#  FBSound.frm                                                              #
'#  This file is an examples of MyFBFramework.                                  #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'################################################################################

'Please copy the three files (fbsound-32.dll,fbsound-64.dll)
'from "VisualFBEditor\Controls\MyFbFramework\Lib\" to the current execution file directory.


'#Region "Form"
	#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
		#define __MAIN_FILE__
		#ifdef __FB_WIN32__
			'#cmdline "-static"
		#endif
		Const _MAIN_FILE_ = __FILE__
	#endif
	#include once "mff/Form.bi"
	#include once "mff/TextBox.bi"
	#include once "mff/ComboBoxEdit.bi"
	#include once "mff/CommandButton.bi"
	#include once "mff/Label.bi"
	#include once "mff/RichTextBox.bi"
	#include once "mff/Dialogs.bi"
	#include once "inc/fbsound_oop.bi"
	
	Using My.Sys.Forms
	
	Type Form1Type Extends Form
		Declare Sub cmdRun_Click(ByRef Sender As Control)
		Declare Sub cmdVolChange_Click(ByRef Sender As Control)
		Declare Sub cmdRun2_Click(ByRef Sender As Control)
		Declare Sub cmdRun3_Click(ByRef Sender As Control)
		Declare Sub cmdExplore_Click(ByRef Sender As Control)
		Declare Constructor
		Dim As RichTextBox RtfReceive
		Dim As ComboBoxEdit cboFileName
		Dim As CommandButton cmdRun, cmdVolChange, cmdRun2, cmdRun3, cmdExplore
		Dim As Label Label1
		Dim As OpenFileDialog OpenFileDialog1
	End Type
	
	Constructor Form1Type
		#if _MAIN_FILE_ = __FILE__
			With App
				.CurLanguagePath = ExePath & "/Languages/"
				.CurLanguage = .Language
				Print "CurLanguage=" & .CurLanguage
			End With
		#endif
		' Form1
		With This
			.Name = "Form1"
			.Text = "Form1"
			.Designer = @This
			.SetBounds 0, 0, 360, 300
		End With
		' RtfReceive
		With RtfReceive
			.Name = "RtfReceive"
			.Text = ML("Waiting...")
			.TabIndex = 0
			.Anchor.Right = AnchorStyle.asAnchor
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Bottom = AnchorStyle.asAnchor
			.WordWraps = True
			.ID = 1016
			.Multiline = True
			.ScrollBars = ScrollBarsType.Both
			.SetBounds 10, 30, 230, 230
			.Designer = @This
			.Parent = @This
		End With
		' cboFileName
		With cboFileName
			.Name = "cboFileName"
			.AddItem "../../Resources/sound.wav"
			.AddItem "../../Resources/country.mp3"
			.Text = "../../Resources/country.mp3"
			.Anchor.Right = AnchorStyle.asAnchor
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Bottom = AnchorStyle.asAnchor
			.Style = cbDropDown
			.TabIndex = 1
			.SetBounds 50, 10, 260, 16
			.Designer = @This
			.Parent = @This
		End With
		' cmdRun
		With cmdRun
			.Name = "cmdRun"
			.Text = "Run"
			.TabIndex = 2
			.Caption = "Run"
			.DoubleBuffered = True
			.Anchor.Right = AnchorStyle.asAnchor
			.SetBounds 260, 30, 80, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdRun_Click)
			.Parent = @This
		End With
		' Label1
		With Label1
			.Name = "Label1"
			.Text = "File："
			.TabIndex = 3
			.SetBounds 10, 10, 40, 20
			.Designer = @This
			.Parent = @This
		End With
		' cmdVolChange
		With cmdVolChange
			.Name = "cmdVolChange"
			.Text = "Volume"
			.TabIndex = 4
			.ControlIndex = 2
			.DoubleBuffered = True
			.Anchor.Right = AnchorStyle.asAnchor
			.SetBounds 260, 60, 80, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdVolChange_Click)
			.Parent = @This
		End With
		' cmdRun2
		With cmdRun2
			.Name = "cmdRun2"
			.Text = "PlayPosition"
			.TabIndex = 5
			.ControlIndex = 3
			.DoubleBuffered = True
			.Anchor.Right = AnchorStyle.asAnchor
			.SetBounds 260, 90, 80, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdRun2_Click)
			.Parent = @This
		End With
		' cmdRun3
		With cmdRun3
			.Name = "cmdRun3"
			.Text = "Device"
			.TabIndex = 6
			.ControlIndex = 4
			.DoubleBuffered = True
			.Caption = "Device"
			.Anchor.Right = AnchorStyle.asAnchor
			.SetBounds 260, 120, 80, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdRun3_Click)
			.Parent = @This
		End With
		' cmdExplore
		With cmdExplore
			.Name = "cmdExplore"
			.Text = "..."
			.TabIndex = 7
			.ControlIndex = 2
			.DoubleBuffered = True
			.Caption = "..."
			.Anchor.Right = AnchorStyle.asAnchor
			.SetBounds 310, 10, 30, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdExplore_Click)
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


Private Sub Form1Type.cmdRun_Click(ByRef Sender As Control)
	
	' Sound.Play([nLoops])
	' Samples.Length
	
	Var Device  = SoundDevice()
	Var Samples = SampleBuffer(Trim(cboFileName.Text))
	Var Sound   = SoundBuffer(Samples)
	Sound.Play
	RtfReceive.Text =  RtfReceive.Text & Chr(13, 10) & "Normal playing"
	RtfReceive.Text =  RtfReceive.Text & Chr(13, 10) & "play time: " & Samples.Length & " seconds"
	
End Sub

Private Sub Form1Type.cmdVolChange_Click(ByRef Sender As Control)
	' Sound.Play([nLoops])
	' Sound.Volume
	
	Var Device  = SoundDevice()
	Var Samples = SampleBuffer(Trim(cboFileName.Text))
	Var Sound   = SoundBuffer(Samples)
	Sound.Volume = 0.8
	Sound.Play
	RtfReceive.Text =  RtfReceive.Text & Chr(13, 10) & "Volume playing"
	RtfReceive.Text =  RtfReceive.Text & Chr(13, 10) & "play time: " & Samples.Length & " seconds"
	
End Sub

Private Sub Form1Type.cmdRun2_Click(ByRef Sender As Control)
	' Sound.PlayPosition
	' Sound.Pan
	
	Var Device  = SoundDevice()
	Var Samples = SampleBuffer(Trim(cboFileName.Text))
	Var Sound   = SoundBuffer(Samples)
	Var w=0.0
	Sound.Play
	RtfReceive.Text =  RtfReceive.Text & Chr(13, 10) & "play time: " & Samples.Length & " seconds"
	RtfReceive.Text =  RtfReceive.Text & Chr(13, 10) & "wait on end of playback ..."
	While Sound.Playposition() < 1.0
		Sound.Pan = Sin(w) : w+=0.01
		Sleep 10, 1
		App.DoEvents
	Wend
End Sub

Private Sub Form1Type.cmdRun3_Click(ByRef Sender As Control)
	' 	Device.Volume
	Var Device  = SoundDevice()
	Var Samples = SampleBuffer(Trim(cboFileName.Text))
	Var Sound   = SoundBuffer(Samples)
	Var w=0.0
	Sound.Play
	RtfReceive.Text =  RtfReceive.Text & Chr(13, 10) & "play time: " & Samples.Length & " seconds"
	RtfReceive.Text =  RtfReceive.Text & Chr(13, 10) & "wait on end of playback ..."
	While Sound.Playposition() < 1.0
		Device.Volume = 0.6 + Sin(w) * 0.4 : w += 0.01
		Sleep 10, 1
		App.DoEvents
	Wend
	
	
End Sub

Private Sub Form1Type.cmdExplore_Click(ByRef Sender As Control)
	If OpenFileDialog1.Execute() Then
		cboFileName.Text = OpenFileDialog1.FileName
		If cboFileName.Contains(OpenFileDialog1.FileName) = False Then
			cboFileName.AddItem OpenFileDialog1.FileName
			'cboFileName.SaveToFile(ExePath & "\PlayList.txt")
		End If
		cmdRun.SetFocus
	End If
End Sub
