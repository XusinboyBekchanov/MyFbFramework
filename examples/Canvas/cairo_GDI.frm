'################################################################################
'#  cairo_GDI.frm                                                              #
'#  This file is an examples of MyFBFramework.                                  #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'################################################################################

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
	#include once "mff/TrackBar.bi"
	#include once "mff/TimerComponent.bi"
	Using My.Sys.Forms
	#include once "cairo/cairo-win32.bi"
	
	Dim Shared As cairo_surface_t Ptr cairoSurface
	Dim Shared As cairo_t Ptr cairoCreate
	
	Dim Shared As Boolean Ending, Playing = True
	' Adjust speed here
	Dim Shared As Long speed = 160 ' Frames Per Second
	' Adjust speed here
	Dim Shared As Long fps
	Const PI = 3.1415926535897932
	
	Const g = 39.81 ' gravitational effect
	Const length = 290 ' length of sticks
	
	Dim Shared As Double angle1 = 39.6, angle2 = 40.3, angle3 = 47, angle4 = 41.1, angle5 = 41.8, angle6 = 42.2
	Dim Shared As Double vel1 = 0, vel2 = 0, vel3 = 0, vel4 = 0, vel5 = 0, vel6 = 0
	Dim Shared As Double accel1, accel2, accel3, accel4, accel5, accel6
	Dim Shared As Double dt = 0.05
	
	Type Form1Type Extends Form
		Declare Sub Form_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
		Declare Sub Form_Create(ByRef Sender As Control)
		Declare Sub Form_Close(ByRef Sender As Form, ByRef Action As Integer)
		Declare Sub PanelRender_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
		Declare Sub cmdPlay_Click(ByRef Sender As Control)
		Declare Sub cmdPause_Click(ByRef Sender As Control)
		Declare Sub TrackBarFPS_Change(ByRef Sender As TrackBar, Position As Integer)
		Declare Sub Form_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
		Declare Sub PanelRender_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
		Declare Sub TimerFPS_Timer(ByRef Sender As TimerComponent)
		Declare Constructor
		
		Dim As Panel PanelRender
		Dim As Label lblFPS, lblLanguage
		Dim As CommandButton cmdPause, cmdPlay
		Dim As TrackBar TrackBarFPS
		Dim As TimerComponent TimerFPS
	End Type
	
	Constructor Form1Type
		#if _MAIN_FILE_ = __FILE__
			With App
				.CurLanguagePath = ExePath & "/Languages/"
				.CurLanguage = "Chinese (Simplified)" '.Language
			End With
		#endif
		' Form1
		With This
			.Name = "Form1"
			.Text = "VisualFBEditor-Cairo with GDI"
			.Designer = @This
			.StartPosition = FormStartPosition.CenterScreen
			.OnResize = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer), @Form_Resize)
			.OnCreate = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @Form_Create)
			.OnClose = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Form, ByRef Action As Integer), @Form_Close)
			.OnPaint = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas), @Form_Paint)
			.SetBounds 0, 0, 620, 450
		End With
		
		' PanelRender
		With PanelRender
			.Name = "PanelRender"
			.Text = "PanelRender"
			.TabIndex = 2
			.BackColor = 8421376
			.DoubleBuffered = True 
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Right = AnchorStyle.asAnchor
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Bottom = AnchorStyle.asAnchor
			.SetBounds 90, 10, 510, 400
			.Designer = @This
			.OnResize = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer), @PanelRender_Resize)
			.OnPaint = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas), @PanelRender_Paint)
			.Parent = @This
		End With
		' lblFPS
		With lblFPS
			.Name = "lblFPS"
			.Text = "FPS："
			.TabIndex = 1
			.SetBounds 10, 40, 70, 20
			.Designer = @This
			.Parent = @This
		End With
		' cmdPause
		With cmdPause
			.Name = "cmdPause"
			.Text = ML("Pause")
			.TabIndex = 2
			.SetBounds 20, 70, 60, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdPause_Click)
			.Parent = @This
		End With
		' cmdPlay
		With cmdPlay
			.Name = "cmdPlay"
			.Text = ML("Play")
			.TabIndex = 3
			.ControlIndex = 2
			.SetBounds 20, 100, 60, 20
			.Enabled = False 
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdPlay_Click)
			.Parent = @This
		End With
		' TrackBarFPS
		With TrackBarFPS
			.Name = "TrackBarFPS"
			.Text = "TrackBarFPS"
			.TabIndex = 4
			.ControlIndex = 4
			.Hint = ML("change the FPS")
			.MaxValue = 255
			.MinValue = 10
			.Position = speed
			.SetBounds 8, 55, 77, 10
			.Designer = @This
			.OnChange = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TrackBar, Position As Integer), @TrackBarFPS_Change)
			.Parent = @This
		End With
		' lblLanguage
		With lblLanguage
			.Name = "lblLanguage"
			.Text = ML("Language:") & App.CurLanguage
			.TabIndex = 5
			.ControlIndex = 1
			.SetBounds 10, 0, 80, 40
			.Designer = @This
			.Parent = @This
		End With
		' TimerFPS
		With TimerFPS
			.Name = "TimerFPS"
			.Interval = 50
			.Enabled = True
			.SetBounds 20, 170, 16, 16
			.Designer = @This
			.OnTimer = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent), @TimerFPS_Timer)
			.Parent = @This
		End With
	End Constructor
	
	Dim Shared Form1 As Form1Type
	
	#if _MAIN_FILE_ = __FILE__
		App.DarkMode = False
		Form1.MainForm = True
		Form1.Show
		App.Run
	#endif
'#End Region

Function regulate(ByVal myfps As Long, ByRef fps As Long) As Long
	Static As Double timervalue, _lastsleeptime, t3, frames
	frames += 1
	If (Timer - t3) >= 1 Then t3 = Timer : fps = frames : frames = 0
	Var sleeptime = _lastsleeptime + ((1 / myfps) - Timer + timervalue) * 1000
	If sleeptime < 1 Then sleeptime = 1
	_lastsleeptime = sleeptime
	timervalue = Timer
	Return sleeptime
End Function

'the main rendering code.  渲染代码主过程。
Sub RenderProj(Param As Any Ptr)
	
End Sub

Private Sub Form1Type.Form_Create(ByRef Sender As Control)
	
End Sub

Private Sub Form1Type.Form_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
	
End Sub


Private Sub Form1Type.Form_Close(ByRef Sender As Form, ByRef Action As Integer)
	Ending = True
	
End Sub

Private Sub Form1Type.PanelRender_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
	
End Sub

Private Sub Form1Type.cmdPlay_Click(ByRef Sender As Control)
	Playing = True
	cmdPlay.Enabled = Not Playing
	cmdPause.Enabled = Playing
	If Playing Then RenderProj(0)
	TimerFPS.Enabled = Playing
End Sub

Private Sub Form1Type.cmdPause_Click(ByRef Sender As Control)
	Playing = False
	cmdPlay.Enabled = Not Playing
	cmdPause.Enabled = Playing
	If Playing Then RenderProj(0)
	TimerFPS.Enabled = Playing
End Sub

Private Sub Form1Type.TrackBarFPS_Change(ByRef Sender As TrackBar, Position As Integer)
	If Sender.Position < 10 Then Sender.Position = 10
	speed = Sender.Position
	lblFPS.Text = "FPS:" & speed
End Sub

Private Sub Form1Type.Form_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
	
End Sub

Private Sub Form1Type.PanelRender_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
	cairoSurface = cairo_win32_surface_create(Canvas.Handle)
	cairoCreate = cairo_create(cairoSurface)

		
		cairo_set_source_rgb(cairoCreate, 0, 0, 0)
		cairo_paint(cairoCreate)
		
		' circle for pivot
		cairo_arc(cairoCreate, 320, 320, 10, 0, 2 * PI) : cairo_set_source_rgb(cairoCreate, 0, 1, 1) : cairo_fill(cairoCreate)
		
		' Draw sticks
		cairo_move_to(cairoCreate, 320, 320) : cairo_line_to(cairoCreate, 320 + length * Sin(angle1), 320 + length * Cos(angle1)) : cairo_set_source_rgb(cairoCreate, 1, 0, 1) : cairo_stroke(cairoCreate)
		cairo_arc(cairoCreate, 320 + length * Sin(angle1), 320 + length * Cos(angle1), 15, 0, 2 * PI) : cairo_set_source_rgb(cairoCreate, 1, 0, 1) : cairo_fill(cairoCreate)
		cairo_move_to(cairoCreate, 320, 320) : cairo_line_to(cairoCreate, 320 + length * Sin(angle2), 320 + length * Cos(angle2)) : cairo_set_source_rgb(cairoCreate, 0, 1, 0) : cairo_stroke(cairoCreate)
		cairo_arc(cairoCreate, 320 + length * Sin(angle2), 320 + length * Cos(angle2), 15, 0, 2 * PI) : cairo_set_source_rgb(cairoCreate, 0, 1, 0) : cairo_fill(cairoCreate)
		cairo_move_to(cairoCreate, 320, 320) : cairo_line_to(cairoCreate, 320 + length * Sin(angle3), 320 + length * Cos(angle3)) : cairo_set_source_rgb(cairoCreate, 1, 1, 0) : cairo_stroke(cairoCreate)
		cairo_arc(cairoCreate, 320 + length * Sin(angle3), 320 + length * Cos(angle3), 15, 0, 2 * PI) : cairo_set_source_rgb(cairoCreate, 1, 1, 0) : cairo_fill(cairoCreate)
		cairo_move_to(cairoCreate, 320, 320) : cairo_line_to(cairoCreate, 320 + length * Sin(angle4), 320 + length * Cos(angle4)) : cairo_set_source_rgb(cairoCreate, 0, 1, 1) : cairo_stroke(cairoCreate)
		cairo_arc(cairoCreate, 320 + length * Sin(angle4), 320 + length * Cos(angle4), 15, 0, 2 * PI) : cairo_set_source_rgb(cairoCreate, 0, 1, 1) : cairo_fill(cairoCreate)
		cairo_move_to(cairoCreate, 320, 320) : cairo_line_to(cairoCreate, 320 + length * Sin(angle5), 320 + length * Cos(angle5)) : cairo_set_source_rgb(cairoCreate, 1, 0, 0) : cairo_stroke(cairoCreate)
		cairo_arc(cairoCreate, 320 + length * Sin(angle5), 320 + length * Cos(angle5), 15, 0, 2 * PI) : cairo_set_source_rgb(cairoCreate, 1, 0, 0) : cairo_fill(cairoCreate)
		cairo_move_to(cairoCreate, 320, 320) : cairo_line_to(cairoCreate, 320 + length * Sin(angle6), 320 + length * Cos(angle6)) : cairo_set_source_rgb(cairoCreate, 1, 1, 1) : cairo_stroke(cairoCreate)
		cairo_arc(cairoCreate, 320 + length * Sin(angle6), 320 + length * Cos(angle6), 15, 0, 2 * PI) : cairo_set_source_rgb(cairoCreate, 1, 1, 1) : cairo_fill(cairoCreate)
		Form1.lblFPS.Text = "FPS:" & speed
		
	cairo_destroy(cairoCreate)
	cairo_surface_destroy(cairoSurface)
End Sub

Private Sub Form1Type.TimerFPS_Timer(ByRef Sender As TimerComponent)
		' Calculate acceleration
		accel1 = -g / length * Sin(angle1)
		accel2 = -g / length * Sin(angle2)
		accel3 = -g / length * Sin(angle3)
		accel4 = -g / length * Sin(angle4)
		accel5 = -g / length * Sin(angle5)
		accel6 = -g / length * Sin(angle6)
		
		' Update velocities
		vel1 += accel1 * dt
		vel2 += accel2 * dt
		vel3 += accel3 * dt
		vel4 += accel4 * dt
		vel5 += accel5 * dt
		vel6 += accel6 * dt
		
		' Update angles
		angle1 += vel1 * dt
		angle2 += vel2 * dt
		angle3 += vel3 * dt
		angle4 += vel4 * dt
		angle5 += vel5 * dt
		angle6 += vel6 * dt
		App.DoEvents
		PanelRender.Repaint
		Sleep regulate(speed, fps), 1
		
End Sub
