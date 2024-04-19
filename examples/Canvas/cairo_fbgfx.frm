'################################################################################
'#  cairo_fbgfx.frm                                                              #
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
	Using My.Sys.Forms
	#define __fbgfx_bi__
	#define __USE_CAIRO__
	'This is where you define module-level Shared variables and Add include file.
	'The "RenderProj" sub is the main rendering code subroutine.
	'在这儿定义模块级别共享变量和添加引用。“RenderProj”过程是主要的渲染代码主过程。
	Declare Sub RenderProj(Param As Any Ptr)
	Dim Shared As Any Ptr HandleRender
	'' include fbgfx.bi for some useful definitions
	#include once "fbgfx.bi"
	#include once "cairo/cairo.bi"
	
	'if drawing with RayLib
	'#include once "inc/raymath.bi"
	'#include once "inc/raylib.bi"
	'Using RayLib
	'
	
	Dim Shared As cairo_surface_t Ptr cairoSurface
	Dim Shared As cairo_t Ptr cairoCreate
	Dim Shared As Any Ptr image
	Dim Shared As Any Ptr pixels
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
		Declare Constructor
		
		Dim As Panel PanelRender
		Dim As Label lblFPS, lblLanguage
		Dim As CommandButton cmdPause, cmdPlay
		Dim As TrackBar TrackBarFPS
	End Type
	
	Constructor Form1Type
		#if _MAIN_FILE_ = __FILE__
			With App
				.CurLanguagePath = ExePath & "/"
				.CurLanguage = "Chinese (Simplified)" '.Language
			End With
		#endif
		' Form1
		With This
			.Name = "Form1"
			.Text = "VisualFBEditor-Cairo with fbgfx"
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
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Right = AnchorStyle.asAnchor
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Bottom = AnchorStyle.asAnchor
			.SetBounds 90, 10, 510, 400
			.Designer = @This
			.OnResize = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer), @PanelRender_Resize)
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
			.Enabled = False 
			.SetBounds 20, 100, 60, 20
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
	End Constructor
	
	Dim Shared Form1 As Form1Type
	
	#if _MAIN_FILE_ = __FILE__
		App.DarkMode = False
		Form1.MainForm = True
		Form1.Show
		' Put the Render code here
		'ThreadcairoCreateeate_(@RenderProj, 0)
		RenderProj(0)
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
	#ifdef __fbgfx_bi__
		Do While Not Ending
			If Not Playing  Then Exit Do
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
			
			ScreenLock()
			Put (0, 0), image, PSet
			ScreenUnlock()
			'speed = Form1.TrackBarFPS.Position
			'Playing = Form1.cmdPlay.Enabled
			Form1.lblFPS.Text = "FPS:" & speed
			App.DoEvents
			Ending = Len(Inkey) > 0
			Sleep regulate(speed, fps), 1
		Loop
	#elseif defined(RAYLIB_H)
		
	#endif
End Sub

Private Sub Form1Type.Form_Create(ByRef Sender As Control)
	'Initialize the drawing engine in sub Form_Create or Form_Show. The official freeBasic drawing engine is fbgfx,
	'and third-party drawing engines like RayLib are employed. It cannot be mixed simultaneously.
	'在Form_Create或者Form_Show初始化绘图引擎。freeBasic官方绘图引擎是fbgfx，第三方绘图引擎如RayLib。不能同时混用。
	#ifdef __fbgfx_bi__
		Dim As Integer IMAGE_W = ScaleX(PanelRender.Width)
		Dim As Integer IMAGE_H = ScaleY(PanelRender.Height)
		ScreenRes IMAGE_W, IMAGE_H, 32
		ScreenControl(2, Cast(Integer, HandleRender))
		'Line (0, 0) - (Sender.Width, Sender.Height), RGB(192, 192, 192), BF
		image = ImageCreate(IMAGE_W, IMAGE_H)
		ImageInfo(image, IMAGE_W, IMAGE_H, , , pixels)
		Dim As Long stride = cairo_format_stride_for_width(CAIRO_FORMAT_ARGB32, IMAGE_W) ' https://www.freebasic.net/forum/viewtopic.php?p=215065#p215065
		cairoSurface = cairo_image_surface_create_for_data(pixels, CAIRO_FORMAT_ARGB32, IMAGE_W, IMAGE_H, stride)
		cairoCreate = cairo_create(cairoSurface)
		' Adjust speed here
		speed = 60 ' Frames Per Second
		
	#elseif defined(RAYLIB_H)
		
	#endif
	
	'Move the render windows to container PanelRender.
	'将渲染绘画窗口移动到容器PanelRender。
	If HandleRender > 0 Then
		SetParent(HandleRender, PanelRender.Handle)
		SetWindowLongW(HandleRender, GWL_STYLE, WS_VISIBLE)
		MoveWindow(HandleRender, 0, 0, IMAGE_W, IMAGE_H, True)
	End If
End Sub

Private Sub Form1Type.Form_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
	
End Sub


Private Sub Form1Type.Form_Close(ByRef Sender As Form, ByRef Action As Integer)
	Ending = True
	#ifdef __fbgfx_bi__
		cairo_destroy(cairoCreate)
		cairo_surface_destroy(cairoSurface)
		ImageDestroy image
	#elseif defined(RAYLIB_H)
		
	#endif
End Sub

Private Sub Form1Type.PanelRender_Resize(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
	#if defined(__fbgfx_bi__)
		
	#elseif defined(RAYLIB_H)
		MoveWindow(HandleRender, 0, 0, ScaleX(PanelRender.Width), ScaleY(PanelRender.Height), True)
	#endif
End Sub

Private Sub Form1Type.cmdPlay_Click(ByRef Sender As Control)
	Playing = True
	cmdPlay.Enabled = Not Playing
	cmdPause.Enabled = Playing
	If Playing Then RenderProj(0)
End Sub

Private Sub Form1Type.cmdPause_Click(ByRef Sender As Control)
	Playing = False
	cmdPlay.Enabled = Not Playing
	cmdPause.Enabled = Playing
	If Playing Then RenderProj(0)
End Sub

Private Sub Form1Type.TrackBarFPS_Change(ByRef Sender As TrackBar, Position As Integer)
	If Sender.Position < 10 Then Sender.Position = 10
	speed = Sender.Position
	lblFPS.Text = "FPS:" & speed
End Sub

Private Sub Form1Type.Form_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
	
End Sub
