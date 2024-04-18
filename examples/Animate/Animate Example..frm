'################################################################################
'#  Animate Example.frm                                                           #
'#  This file is an examples of MyFBFramework                                   #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'################################################################################

'#Region "Form"
	#define GIFPlayOn
	#define MoviePlayOn
	#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
		#ifdef __FB_WIN32__
			'#cmdline "AnimatePlayer.rc"
		#endif
		#define __MAIN_FILE__ __FILE__
	#endif
	#include once "mff/Form.bi"
	#include once "mff/sys.bi"
	#include once "mff/CommandButton.bi"
	#include once "mff/Panel.bi"
	#include once "mff/ImageBox.bi"
	#include once "mff/TextBox.bi"
	#include once "mff/TrackBar.bi"
	#include once "mff/Label.bi"
	#include once "mff/Dialogs.bi"
	#include once "mff/Picture.bi"
	#include once "mff/TimerComponent.bi"
	#include once "mff/ComboBoxEdit.bi"
	#include once "mff/ImageList.bi"
	#include once "mff/ComboBoxEx.bi"
	#include once "mff/CheckBox.bi"
	#include once "mff/Animate.bi"
	#include once "string.bi"
	
	Using My.Sys.Forms
	
	Dim Shared As Double Duration
	
	Private Function Sec2Time(Sec As Single, hfmt As String = "#,#0", mfmt As String = "#00", sfmt As String = "#00") ByRef As String
		Dim h As Long
		Dim m As Long
		Dim s As Single
		Static r As String
		h = Sec \ 3600
		m = (Sec - h * 3600) \ 60
		s = Sec - h * 3600 - m * 60
		r = Format(h, hfmt) & ":" & Format(m, mfmt) & ":" & Format(s, sfmt)
		Return r
	End Function
	
	Type frmAnimateType Extends Form
		Declare Sub cboFileName_DblClick(ByRef Sender As Control)
		Declare Sub Form_Create(ByRef Sender As Control)
		Declare Sub Form_Close(ByRef Sender As Form, ByRef Action As Integer)
		Declare Sub cmdBtn_Click(ByRef Sender As Control)
		Declare Sub Form_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
		Declare Sub tbAudio_Change(ByRef Sender As TrackBar, Position As Integer)
		Declare Sub tbAudio_MouseUp(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Sub tbBalance_Change(ByRef Sender As TrackBar, Position As Integer)
		Declare Sub tbBalance_MouseUp(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Sub TimerComponent1_Timer(ByRef Sender As TimerComponent)
		Declare Sub tbPosition_Change(ByRef Sender As TrackBar, Position As Integer)
		Declare Sub tbPosition_MouseDown(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Sub tbPosition_MouseUp(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
		Declare Sub Animate1_Message(ByRef Sender As Control, ByRef MSG As Message)
		Declare Sub cboChanel_Selected(ByRef Sender As ComboBoxEdit, ItemIndex As Integer)
		Declare Sub cmdBrowse_Click(ByRef Sender As Control)
		Declare Sub cmdFull_Click(ByRef Sender As Control)
		Declare Sub chkLoop_Click(ByRef Sender As CheckBox)
		Declare Sub cmdRate_Click(ByRef Sender As Control)
		Declare Sub chkRatio_Click(ByRef Sender As CheckBox)
		Declare Constructor
		
		Dim As Panel PanelControl, PanelPosition
		Dim As CommandButton cmdOpen, cmdPlay, cmdClose, cmdFull(3), cmdBrowse, cmdRate(1)
		Dim As ComboBoxEdit cboFileName
		Dim As TrackBar tbVolume, tbBalance, tbPosition
		Dim As Label lblVolume, lblBalance, lblLength, lblPosition
		Dim As OpenFileDialog OpenFileDialog1
		Dim As TimerComponent TimerComponent1
		Dim As CheckBox chkLoop, chkRatio
		Dim As Animate Animate1
	End Type
	
	Constructor frmAnimateType
		#if _MAIN_FILE_ = __FILE__
			With App
				.CurLanguagePath = ExePath & "/Languages/"
				.CurLanguage = My.Sys.Language
				Print  "CurLanguage =" & .CurLanguage 
			End With
		#endif

		' frmAnimate
		With This
			.Name = "frmAnimate"
			.Text = ML("VisualFBEditor Animate Player")
			#ifdef __FB_64BIT__
				.Caption = ML("VisualFBEditor Animate Player(X64)")
			#else
				.Caption = ML("VisualFBEditor Animate Player(X32)")
			#endif
			.Designer = @This
			.OnCreate = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @Form_Create)
			.OnClose = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Form, ByRef Action As Integer), @Form_Close)
			.OnResize = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer), @Form_Resize)
			.StartPosition = FormStartPosition.CenterScreen
			.BackColor = 8421376
			.SetBounds 0, 0, 800, 480
		End With
		' Animate1
		With Animate1
			.Name = "Animate1"
			.Text = "Animate1"
			.AutoSize = True
			.Center = True
			.Transparency = True
			'.FILE = "D:\Faster (2010) 720p BluRay AC3 x264 - AdiT.mkv"
			'.FILE = "ExePath & "/../Resources/horse.gif"
			.BackColor = 16776960
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Right = AnchorStyle.asAnchor
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Bottom = AnchorStyle.asAnchor
			.SetBounds 0, 25, 785, 375
			.OnMessage = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef MSG As Message), @Animate1_Message)
			.SendToBack
			.Designer = @This
			.Parent = @This
		End With
		' PanelPosition
		With PanelPosition
			.Name = "PanelPosition"
			.Text = "PanelPosition"
			.TabIndex = 0
			.Align = DockStyle.alBottom
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Right = AnchorStyle.asAnchor
			.Anchor.Top = AnchorStyle.asNone
			.ControlIndex = 0
			.Location = Type<My.Sys.Drawing.Point>(0, 415)
			.SetBounds 0, 415, 789, 50
			.BringToFront
			.Parent = @This
		End With
		' PanelControl
		With PanelControl
			.Name = "PanelControl"
			.Text = "PanelControl"
			.TabIndex = 0
			.Align = DockStyle.alTop
			.SetBounds 10, 0, 789, 26
			.Parent = @This
		End With
		' cmdOpen
		With cmdOpen
			.Name = "cmdOpen"
			.Text = ML("Open")
			.TabIndex = 6
			.SetBounds 8, 2, 50, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdBtn_Click)
			.Parent = @PanelControl
		End With
		' cmdPlay
		With cmdPlay
			.Name = "cmdPlay"
			.Text = ML("Play")
			.TabIndex = 7
			.Enabled = False
			.SetBounds 59, 2, 50, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdBtn_Click)
			.Parent = @PanelControl
		End With
		' cmdClose
		With cmdClose
			.Name = "cmdClose"
			.Text = ML("Close")
			.TabIndex = 9
			.ControlIndex = 4
			.Enabled = False
			.SetBounds 110, 2, 50, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdBtn_Click)
			.Parent = @PanelControl
		End With
		' cmdFull(0)
		With cmdFull(0)
			.Name = "cmdFull(0)"
			.Text = ML("Full")
			.TabIndex = 10
			.Enabled = False
			.SetBounds 170, 2, 20, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdBtn_Click)
			.Parent = @PanelControl
		End With
		' cboFileName
		With cboFileName
			.Name = "cboFileName"
			.Text = "../Resources/horse.gif"
			.Hint = ML("Double click to select a file from local disk.")
			.TabIndex = 12
			.Style = cbDropDown
			.Align = DockStyle.alNone
			.ExtraMargins.Right = 10
			.ExtraMargins.Left = 10
			.ExtraMargins.Top = 10
			.ExtraMargins.Bottom = 10
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Right = AnchorStyle.asAnchor
			.SetBounds 260, 2, 489, 16
			.Designer = @This
			.OnDblClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cboFileName_DblClick)
			.Parent = @PanelControl
		End With
		
		' lblVolume
		With lblVolume
			.Name = "lblVolume"
			.Text = ML("Volume:")
			.TabIndex = 14
			.Alignment = AlignmentConstants.taLeft
			.Align = DockStyle.alNone
			.ID = 1004
			.Enabled = False
			.SetBounds 10, 2, 110, 16
			.Parent = @PanelPosition
		End With
		' tbVolume
		With tbVolume
			.Name = "tbVolume"
			.Text = "tbVolume"
			.TabIndex = 15
			.ExtraMargins.Left = 2
			.MaxValue = 0
			.MinValue = -100
			.Position = 0
			.Enabled = False
			.ThumbLength = 20
			.TickStyle = TickStyles.tsAuto
			.ID = 1004
			.TickMark = TickMarks.tmTopLeft
			.Frequency = 10
			.PageSize = 10
			.SetBounds 0, 16, 110, 30
			.Designer = @This
			.OnChange = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TrackBar, Position As Integer), @tbAudio_Change)
			.OnMouseUp = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer), @tbAudio_MouseUp)
			.Parent = @PanelPosition
		End With
		' lblBalance
		With lblBalance
			.Name = "lblBalance"
			.Text = ML("Balance:")
			.TabIndex = 16
			.Alignment = AlignmentConstants.taLeft
			.Enabled = False
			.SetBounds 120, 2, 110, 16
			.Parent = @PanelPosition
		End With
		' tbBalance
		With tbBalance
			.Name = "tbBalance"
			.Text = "tbBalance"
			.TabIndex = 16
			.MaxValue = 50
			.MinValue = -50
			.Enabled = False
			.TickStyle = TickStyles.tsAuto
			.ID = 1004
			.TickMark = TickMarks.tmTopLeft
			.Style = TrackBarOrientation.tbHorizontal
			.SubClass = True
			.Frequency = 10
			.PageSize = 10
			.SetBounds 110, 16, 110, 30
			.Designer = @This
			.OnChange = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TrackBar, Position As Integer), @tbAudio_Change)
			.OnMouseUp = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer), @tbAudio_MouseUp)
			.Parent = @PanelPosition
		End With
		' lblPosition
		With lblPosition
			.Name = "lblPosition"
			.Text = ML("Position:")
			.TabIndex = 17
			.Enabled = False
			.Designer = @This
			.SetBounds 280, 2, 220, 16
			.Parent = @PanelPosition
		End With
		' lblLength
		With lblLength
			.Name = "lblLength"
			.Text = ML("Length:")
			.TabIndex = 18
			.Enabled = False
			.Designer = @This
			.Anchor.Right = AnchorStyle.asAnchor
			.Location = Type<My.Sys.Drawing.Point>(677, 2)
			.SetBounds 677, 2, 100, 15
			.Parent = @PanelPosition
		End With
		' tbPosition
		With tbPosition
			.Name = "tbPosition"
			.Text = "tbPosition"
			.TabIndex = 19
			.Align = DockStyle.alNone
			.PageSize = 10
			.MaxValue = 100
			.TickMark = TickMarks.tmBoth
			.TickStyle = TickStyles.tsAuto
			.ThumbLength = 20
			.ID = 1002
			.LineSize = 10
			.Frequency = 10
			.Style = TrackBarOrientation.tbHorizontal
			.Enabled = False
			.Anchor.Right = AnchorStyle.asAnchor
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Bottom = AnchorStyle.asNone
			.Anchor.Top = AnchorStyle.asNone
			.SetBounds 270, 16, 488, 20
			.Designer = @This
			.OnChange = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TrackBar, Position As Integer), @tbPosition_Change)
			.OnMouseDown = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer), @tbPosition_MouseDown)
			.OnMouseUp = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer), @tbPosition_MouseUp)
			.Parent = @PanelPosition
		End With
		' cmdRate(0)
		With cmdRate(0)
			.Name = "cmdRate(0)"
			.Text = "<<"
			.TabIndex = 20
			.SetBounds 250, 18, 22, 16
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdRate_Click)
			.Parent = @PanelPosition
		End With
		
		' cmdRate(0)
		With cmdRate(1)
			.Name = "cmdRate(1)"
			.Text = ">>"
			.TabIndex = 24
			.Anchor.Right = AnchorStyle.asAnchor
			.SetBounds 760, 18, 22, 16
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdRate_Click)
			.Parent = @PanelPosition
		End With
		' OpenFileDialog1
		With OpenFileDialog1
			.Name = "OpenFileDialog1"
			.SetBounds 0, 0, 16, 16
			.Designer = @This
			.Parent = @This
		End With
		' TimerComponent1
		With TimerComponent1
			.Name = "TimerComponent1"
			.Interval = 20
			.SetBounds 20, 0, 16, 16
			.Designer = @This
			.OnTimer = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent), @TimerComponent1_Timer)
			.Parent = @This
		End With
		' chkLoop
		With chkLoop
			.Name = "chkLoop"
			.Text = ML("Loop")
			.TabIndex = 19
			.Caption = ML("Loop")
			.Checked = True
			.Enabled = False
			.SetBounds 460, 1, 40, 16
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @chkLoop_Click)
			.Parent = @PanelPosition
		End With
		' cmdBrowse
		With cmdBrowse
			.Name = "cmdBrowse"
			.Text = "..."
			.TabIndex = 22
			.ControlIndex = 0
			.Align = DockStyle.alNone
			.Caption = "..."
			.Anchor.Right = AnchorStyle.asAnchor
			.SetBounds 750, 2, 29, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdBrowse_Click)
			.Parent = @PanelControl
		End With
		' cmdFull(1)
		With cmdFull(1)
			.Name = "cmdFull(1)"
			.Text = "1X"
			.TabIndex = 21
			.ControlIndex = 3
			.Enabled = False
			.Caption = "1X"
			.SetBounds 190, 2, 20, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdFull_Click)
			.Parent = @PanelControl
		End With
		' cmdFull(2)
		With cmdFull(2)
			.Name = "cmdFull(2)"
			.Text = "2X"
			.TabIndex = 22
			.ControlIndex = 4
			.Enabled = False
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdFull_Click)
			.Caption = "2X"
			.SetBounds 210, 2, 20, 20
			.Designer = @This
			.Parent = @PanelControl
		End With
		' cmdFull(3)
		With cmdFull(3)
			.Name = "cmdFull(3)"
			.Text = "3X"
			.TabIndex = 23
			.ControlIndex = 6
			.Enabled = False
			.Caption = "3X"
			.SetBounds 230, 2, 20, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdFull_Click)
			.Parent = @PanelControl
		End With
		
		' chkRatio
		With chkRatio
			.Name = "chkRatio"
			.Text = ML("Ratio Fixed")
			.TabIndex = 22
			.ControlIndex = 9
			.Checked = True
			.Enabled = False
			.SetBounds 520, 1, 80, 16
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @chkRatio_Click)
			.Parent = @PanelPosition
		End With
	End Constructor
	
	Dim Shared frmAnimate As frmAnimateType
	
	#if __MAIN_FILE__ = __FILE__
		App.DarkMode = True
		frmAnimate.Show
		App.Run
	#endif
'#End Region

Private Sub frmAnimateType.cboFileName_DblClick(ByRef Sender As Control)
	If OpenFileDialog1.Execute() Then
		cboFileName.Text = OpenFileDialog1.FileName
		cmdPlay.SetFocus
	End If
End Sub

Private Sub frmAnimateType.Form_Create(ByRef Sender As Control)
	
	If Dir(ExePath & "\PlayList.txt") <> "" Then
		cboFileName.LoadFromFile(ExePath & "\PlayList.txt")
		cboFileName.ItemIndex = cboFileName.ItemCount - 1
	End If
End Sub

Private Sub frmAnimateType.Form_Close(ByRef Sender As Form, ByRef Action As Integer)
	Animate1.Close
End Sub

Private Sub frmAnimateType.Form_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
	
	This.Caption = Mid(This.Caption, 1, Len(ML("VisualFBEditor Animate Player(X64)")) + 1) & " - " & CLng(Animate1.FrameWidth) & "X" & (Animate1.FrameHeight)
	
End Sub

Private Sub frmAnimateType.cmdBtn_Click(ByRef Sender As Control)
	Dim b As Boolean = False
	Select Case Sender.Name
	Case "cmdOpen"
		Animate1.Close
		If ..Left(Trim(cboFileName.Text), 9) = "OS System" Then
			Animate1.CommonAvi = CommonAVIs.aviCopyFile 'Val(Trim(Mid(Trim(cboFileName.Text), 10))) 'CommonAVIs.aviCopyFile '
			Animate1.OpenFile
		Else
			If Animate1.OpenFile(cboFileName.Text) = 0 Then
				MsgBox("Open File failure!" & Chr(13, 10) & Animate1.GetErrorInfo)
				Exit Sub
			End If
		End If
		Duration = Animate1.FrameCount
		If Duration > 0 Then
			tbPosition.MaxValue = CInt(Duration)
			tbPosition.PageSize = CInt(Duration / 10)
			tbPosition.Frequency = CInt(Duration / 10)
			lblLength.Text = ML("Length:") & Sec2Time(Duration)
			lblLength.Enabled = True
			chkLoop.Enabled = True
			chkRatio.Enabled = True
			TimerComponent1.Enabled = True
		Else
			tbPosition.Enabled = False
			lblLength.Text = ML("Length: NA")
			lblLength.Enabled = False
			chkLoop.Enabled = False
			chkRatio.Enabled = False
		End If
		tbVolume.Position = Animate1.Volume
		lblVolume.Text = ML("Volume:") & tbVolume.Position
		tbBalance.Position = Animate1.Balance
		lblBalance.Text = ML("Balance:") & tbBalance.Position
		tbPosition.Position = 0
		'Animate1.Play
		cmdPlay.Text = ML("Pause")
		b = True
	Case "cmdPlay"
		Select Case Sender.Text
		Case "Play"
			cmdPlay.Text = ML("Pause")
			Animate1.Play
			TimerComponent1.Enabled = True
			b = True
		Case "Pause"
			cmdPlay.Text = ML("Play")
			Animate1.Pause
			TimerComponent1.Enabled = False
			b = True
		End Select
	Case "cmdClose"
		Animate1.Stop
		TimerComponent1.Enabled = False
		b = False
	Case "cmdFull(0)"
		Animate1.FullScreenMode = True
		Exit Sub
	Case Else
		Exit Sub
	End Select
	If Duration > 0 Then tbPosition.Enabled = True
	tbVolume.Enabled = b
	tbBalance.Enabled = b
	lblVolume.Enabled = b
	lblBalance.Enabled = b
	lblPosition.Enabled = b
	cmdPlay.Enabled = b
	cmdClose.Enabled = b
	cmdFull(0).Enabled = b
	cmdFull(1).Enabled = b
	cmdFull(2).Enabled = b
	cmdFull(3).Enabled = b
	cmdOpen.Enabled = Not b
	tbPosition.SetFocus
End Sub

Private Sub frmAnimateType.tbAudio_Change(ByRef Sender As TrackBar, Position As Integer)
	Select Case Sender.Name
	Case "tbVolume"
		Animate1.Volume= Position * 100
		lblVolume.Text = ML("Volume:") & Position
	Case "tbBalance"
		Animate1.Balance = Position * 100
		lblBalance.Text = ML("Balance:") & Animate1.Balance/ 100
	End Select
End Sub

Private Sub frmAnimateType.tbAudio_MouseUp(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
	Select Case Sender.Name
	Case "tbVolume"
		Animate1.Volume = tbVolume.Position * 100
		Debug.Print "Animate1.Volume=" & Animate1.Volume
	Case "tbBalance"
		Animate1.Balance= tbBalance.Position * 100
		Debug.Print "Animate1.Balance=" & Animate1.Balance
	End Select
End Sub

Private Sub frmAnimateType.tbPosition_Change(ByRef Sender As TrackBar, Position As Integer)
	If TimerComponent1.Enabled = True Then Exit Sub
	lblPosition.Text = ML("Position:") & Sec2Time(Position)
End Sub

Private Sub frmAnimateType.tbPosition_MouseDown(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
	If MouseButton = 0 Then
		TimerComponent1.Enabled = False
	End If
End Sub

Private Sub frmAnimateType.tbPosition_MouseUp(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
	If MouseButton = 0 AndAlso TimerComponent1.Enabled = False Then
		Animate1.Position = tbPosition.Position
		TimerComponent1.Enabled = True
	End If
End Sub

Private Sub frmAnimateType.TimerComponent1_Timer(ByRef Sender As TimerComponent)
	If tbPosition.Enabled Then
		Dim As Double Animate1Position = Animate1.Position
		If tbPosition.MaxValue - Animate1Position <= 1 AndAlso tbPosition.MaxValue > 2 Then
			If chkLoop.Checked Then
				Animate1.Position = 0 : Animate1Position = 0
			Else
				cmdBtn_Click(cmdPlay)
			End If
		End If
		tbPosition.Position = Animate1Position
		lblPosition.Text = ML("Position:") & Sec2Time(Animate1Position) & "  Play Rate: " & Animate1.Rate
	End If
End Sub

'https://learn.microsoft.com/en-us/windows/win32/directshow/event-notification-codes.
Private Sub frmAnimateType.Animate1_Message(ByRef Sender As Control, ByRef msg As Message)
	
End Sub

Private Sub frmAnimateType.cboChanel_Selected(ByRef Sender As ComboBoxEdit, ItemIndex As Integer)
	This.Caption = Mid(This.Caption, 1, Len(ML("VisualFBEditor Animate Player(X64)")) + 1)
End Sub

Private Sub frmAnimateType.cmdBrowse_Click(ByRef Sender As Control)
	If OpenFileDialog1.Execute() Then
		cboFileName.Text = OpenFileDialog1.FileName
		If cboFileName.Contains(OpenFileDialog1.FileName) = False Then
			cboFileName.AddItem OpenFileDialog1.FileName
			cboFileName.SaveToFile(ExePath & "\PlayList.txt")
		End If
		This.Caption = Mid(This.Caption, 1, Len(ML("VisualFBEditor Animate Player(X64)")) + 1)
		cmdPlay.SetFocus
	End If
End Sub

Private Sub frmAnimateType.cmdFull_Click(ByRef Sender As Control)
	Dim As Integer Index = Val(Mid(Sender.Name, InStrRev(Sender.Name, "(") + 1))
	If Index > 0 Then 'mVideoWidth, mVideoHeight
		Animate1.AutoSize = True
		Animate1.FrameWidth = Animate1.FrameWidthOriginal * Index : Animate1.FrameHeight = Animate1.FrameHeightOriginal * Index
		This.Caption = Mid(This.Caption, 1, Len(ML("VisualFBEditor Animate Player(X64)")))  & " - " & Animate1.FrameWidthOriginal * Index & "X" & Animate1.FrameHeightOriginal * Index
	End If
End Sub

Private Sub frmAnimateType.cmdRate_Click(ByRef Sender As Control)
	Dim As Integer Index = Val(Mid(Sender.Name, InStrRev(Sender.Name, "(") + 1))
	If Index = 1 Then
		Animate1.Rate= Animate1.Rate * 2
	Else
		Animate1.Rate= Animate1.Rate / 2
	End If
	If Abs(Animate1.Rate) >  32 OrElse Animate1.Rate< 0.06 Then Animate1.Rate= 1
End Sub


Private Sub frmAnimateType.chkLoop_Click(ByRef Sender As CheckBox)
	Animate1.Repeat = IIf(chkLoop.Checked, 1, 0)
End Sub

Private Sub frmAnimateType.chkRatio_Click(ByRef Sender As CheckBox)
	Animate1.RatioFixed = chkRatio.Checked
End Sub
