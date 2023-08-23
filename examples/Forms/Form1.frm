'################################################################################
'#  Form1.frm                                                                   #
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
	#include once "mff/Menus.bi"
	#include once "mff/Panel.bi"
	#include once "mff/CommandButton.bi"
	
	Using My.Sys.Forms
	
	Type Form1Type Extends Form
		Declare Sub MenuItem2_Click(ByRef Sender As MenuItem)
		Declare Sub CommandButton1_Click(ByRef Sender As Control)
		Declare Sub Form_Click(ByRef Sender As Control)
		Declare Constructor
		
		Dim As MainMenu MainMenu1
		Dim As MenuItem MenuItem1, MenuItem2
		Dim As Panel Panel1
		Dim As CommandButton CommandButton1
	End Type
	
	Constructor Form1Type
		' Form1
		With This
			.Name = "Form1"
			.Text = "Form1"
			.Designer = @This
			.Menu = @MainMenu1
			.FormStyle = FormStyles.fsNormal
			'.WindowState = WindowStates.wsMaximized
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @Form_Click)
			.SetBounds 0, 0, 350, 319
		End With
		' MainMenu1
		With MainMenu1
			.Name = "MainMenu1"
			.SetBounds 35, 41, 16, 16
			.Designer = @This
			.Parent = @This
		End With
		' MenuItem1
		With MenuItem1
			.Name = "MenuItem1"
			.Designer = @This
			.Caption = "File"
			.ParentMenu = @MainMenu1
		End With
		' MenuItem2
		With MenuItem2
			.Name = "MenuItem2"
			.Designer = @This
			.Caption = "Open"
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @MenuItem2_Click)
			.Parent = @MenuItem1
		End With
		' Panel1
		With Panel1
			.Name = "Panel1"
			.Text = "Panel1"
			.TabIndex = 0
			.Align = DockStyle.alLeft
			.SetBounds 0, 0, 34, 261
			.Designer = @This
			.Parent = @This
		End With
		' CommandButton1
		With CommandButton1
			.Name = "CommandButton1"
			.Text = "Click me show another form"
			.TabIndex = 1
			.ControlIndex = 0
			.SetBounds 100, 76, 144, 52
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @CommandButton1_Click)
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

#include once "Form2.frm"
Private Sub Form1Type.MenuItem2_Click(ByRef Sender As MenuItem)
	Form2.Show Form1
End Sub

Private Sub Form1Type.Form_Click(ByRef Sender As Control)
	
End Sub

Private Sub Form1Type.CommandButton1_Click(ByRef Sender As Control)
	Form2.Show Form1
End Sub
