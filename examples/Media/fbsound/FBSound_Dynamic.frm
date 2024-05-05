'################################################################################
'#  FBSound_Dynamic.frm                                                         #
'#  This file is an examples of MyFBFramework.                                  #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'#  FBSound V1.2 Copyright 2005 - 2020 by D.J.Peters (Joshy)                    #
'#   d.j.peters@web.de                                                          #
'# https://github.com/jayrm/fbsound                                             #
'# https://www.freebasic.net/forum/viewtopic.php?t=28905                        #
'################################################################################

'Please copy those files (fbsound-32.dll,fbsound-mm-32.dll,fbsound-64.dll,,fbsound-mm-64.dll)
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
	#define __FBSOUND_DYNAMIC_BI__ 
	#include "tests-common.bi"
	#include once "inc/fbsound/fbsound_oop.bi"
	Using My.Sys.Forms
	Dim Shared As Boolean Playing
	Type Form1Type Extends Form
		Declare Sub cmdPlay_Click(ByRef Sender As Control)
		Declare Sub cmdVolChange_Click(ByRef Sender As Control)
		Declare Sub cmdChannels_Click(ByRef Sender As Control)
		Declare Sub cmdVolumeChanged_Click(ByRef Sender As Control)
		Declare Sub cmdExplore_Click(ByRef Sender As Control)
		Declare Sub Form_Close(ByRef Sender As Form, ByRef Action As Integer)
		Declare Sub cmdStop_Click(ByRef Sender As Control)
		Declare Constructor
		Dim As RichTextBox RtfReceive
		Dim As ComboBoxEdit cboFileName
		Dim As CommandButton cmdPlay, cmdChannels, cmdVolumeChanged, cmdExplore, cmdStop
		Dim As Label Label1
		Dim As OpenFileDialog OpenFileDialog1
	End Type
	
	Constructor Form1Type
		#if _MAIN_FILE_ = __FILE__
			With App
				.CurLanguagePath = ExePath & "/Languages/"
				.CurLanguage = .Language
			End With
		#endif
		' Form1
		With This
			.Name = "Form1"
			.Text = "Form1"
			.Designer = @This
			.OnClose = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Form, ByRef Action As Integer), @Form_Close)
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
		' cmdPlay
		With cmdPlay
			.Name = "cmdPlay"
			.Text = ML("Play")
			.TabIndex = 2
			.DoubleBuffered = True
			.Anchor.Right = AnchorStyle.asAnchor
			.SetBounds 260, 30, 80, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdPlay_Click)
			.Parent = @This
		End With
		' Label1
		With Label1
			.Name = "Label1"
			.Text = ML("File:")
			.TabIndex = 3
			.SetBounds 10, 10, 40, 20
			.Designer = @This
			.Parent = @This
		End With
		' cmdChannels
		With cmdChannels
			.Name = "cmdChannels"
			.Text = ML("Channels")
			.TabIndex = 5
			.ControlIndex = 3
			.DoubleBuffered = True
			.Anchor.Right = AnchorStyle.asAnchor
			.SetBounds 260, 90, 80, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdChannels_Click)
			.Parent = @This
		End With
		' cmdVolumeChanged
		With cmdVolumeChanged
			.Name = "cmdVolumeChanged"
			.Text = ML("Volume")
			.TabIndex = 6
			.ControlIndex = 4
			.DoubleBuffered = True
			.Anchor.Right = AnchorStyle.asAnchor
			.SetBounds 260, 120, 80, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdVolumeChanged_Click)
			.Parent = @This
		End With
		' cmdExplore
		With cmdExplore
			.Name = "cmdExplore"
			.Text = "..."
			.TabIndex = 7
			.ControlIndex = 2
			.DoubleBuffered = True
			.Anchor.Right = AnchorStyle.asAnchor
			.SetBounds 310, 10, 30, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdExplore_Click)
			.Parent = @This
		End With
		' cmdStop
		With cmdStop
			.Name = "cmdStop"
			.Text = ML("Stop")
			.Anchor.Right = AnchorStyle.asAnchor
			.TabIndex = 8
			.ControlIndex = 2
			.DoubleBuffered = True
			.SetBounds 260, 60, 80, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdStop_Click)
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


Private Sub Form1Type.cmdPlay_Click(ByRef Sender As Control)
	cmdPlay.Enabled = False
	' Sound.Play([nLoops])
	' Samples.Length
	Dim As SoundDevice Device
	Dim As SampleBuffer Samples = SampleBuffer(Trim(cboFileName.Text))
	If Samples.Length > 0 Then
		Playing = True
		Dim As SoundBuffer Sound   = SoundBuffer(Samples)
		Sound.Play
		RtfReceive.Text =  RtfReceive.Text & Chr(13, 10)
		RtfReceive.Text =  RtfReceive.Text & Chr(13, 10) & ML("Normal playing")
		RtfReceive.Text =  RtfReceive.Text & Chr(13, 10) & ML("play time:") & Samples.Length & " " & ML("seconds")
		RtfReceive.Text =  RtfReceive.Text & Chr(13, 10) & ML("wait on end of playback ...")
		While Sound.Playposition() < 1.0 AndAlso Playing
			App.DoEvents
		Wend
	Else
		RtfReceive.Text =  RtfReceive.Text & Chr(13, 10) & ML("Can not load file.") & Trim(cboFileName.Text)
	End If
	Samples.Destroy
	cmdPlay.Enabled = True
	Playing = False
End Sub

Private Sub Form1Type.cmdChannels_Click(ByRef Sender As Control)
	cmdChannels.Enabled = False
	' Sound.PlayPosition
	' Sound.Pan
	Dim As SoundDevice Device
	Dim As SampleBuffer Samples = SampleBuffer(Trim(cboFileName.Text))
	If Samples.Length > 0 Then
		Playing = True
		Dim As SoundBuffer Sound   = SoundBuffer(Samples)
		Device.Volume = 1
		Sound.Pan = 1
		Var w=0.0
		Sound.Play
		RtfReceive.Text =  RtfReceive.Text & Chr(13, 10)
		RtfReceive.Text =  RtfReceive.Text & Chr(13, 10) & ML("Channels Changed")
		RtfReceive.Text =  RtfReceive.Text & Chr(13, 10) & ML("play time:") & Samples.Length & " " & ML("seconds")
		RtfReceive.Text =  RtfReceive.Text & Chr(13, 10) & ML("wait on end of playback ...")
		While Sound.Playposition() < 1.0 AndAlso Playing
			Sound.Pan = Sin(w) : w += 0.01
			Sleep 10, 1
			App.DoEvents
		Wend
	Else
		RtfReceive.Text =  RtfReceive.Text & Chr(13, 10) & ML("Can not load file.") & Trim(cboFileName.Text)
	End If
	Samples.Destroy
	cmdChannels.Enabled = True
	Playing = False
End Sub

Private Sub Form1Type.cmdVolumeChanged_Click(ByRef Sender As Control)
	cmdVolumeChanged.Enabled = False
	' 	Device.Volume
	Dim As SoundDevice Device
	Dim As SampleBuffer Samples = SampleBuffer(Trim(cboFileName.Text))
	If Samples.Length > 0 Then
		Playing = True
		Dim As SoundBuffer Sound   = SoundBuffer(Samples)
		Dim As Single w = 0.0
		Sound.Pan = 1
		Device.Volume = 1
		Sound.Play
		RtfReceive.Text =  RtfReceive.Text & Chr(13, 10) & ML("Volume Changed")
		RtfReceive.Text =  RtfReceive.Text & Chr(13, 10) & ML("play time:") & Samples.Length & " " & ML("seconds")
		RtfReceive.Text =  RtfReceive.Text & Chr(13, 10) & ML("wait on end of playback ...")
		While Sound.Playposition() < 1.0 AndAlso Playing
			Device.Volume = 0.6 + Sin(w) * 0.4 : w += 0.01
			Sleep 10, 1
			App.DoEvents
		Wend
	Else
		RtfReceive.Text =  RtfReceive.Text & Chr(13, 10) & ML("Can not load file.") & Trim(cboFileName.Text)
	End If
	Samples.Destroy
	cmdVolumeChanged.Enabled = True
	Playing = False
End Sub

Private Sub Form1Type.cmdExplore_Click(ByRef Sender As Control)
	If OpenFileDialog1.Execute() Then
		cboFileName.Text = OpenFileDialog1.FileName
		If cboFileName.Contains(OpenFileDialog1.FileName) = False Then
			cboFileName.AddItem OpenFileDialog1.FileName
			'cboFileName.SaveToFile(ExePath & "\PlayList.txt")
		End If
		cmdPlay.SetFocus
	End If
End Sub

Private Sub Form1Type.Form_Close(ByRef Sender As Form, ByRef Action As Integer)
	Playing = False
End Sub

Private Sub Form1Type.cmdStop_Click(ByRef Sender As Control)
	Playing = False
End Sub
