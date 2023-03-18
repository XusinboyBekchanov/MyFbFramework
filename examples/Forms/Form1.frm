'################################################################################
'#  Form1.frm                                                                   #
'#  This file is an examples of MyFBFramework.                                  #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'################################################################################

'#Region "Form"
	#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
		#define __MAIN_FILE__
		Const _MAIN_FILE_ = __FILE__
		#ifdef __FB_WIN32__
			#cmdline "Form1.rc"
		#endif
	#endif
	#include once "mff/Form.bi"
	#include once "mff/Menus.bi"
	#include once "mff/Panel.bi"
	#include once "mff/CommandButton.bi"
	
	Using My.Sys.Forms
	
	Type Form1Type Extends Form
		Declare Static Sub _MenuItem2_Click(ByRef Sender As MenuItem)
		Declare Sub MenuItem2_Click(ByRef Sender As MenuItem)
		Declare Static Sub _CommandButton1_Click(ByRef Sender As Control)
		Declare Sub CommandButton1_Click(ByRef Sender As Control)
		Declare Static Sub _Form_Click(ByRef Sender As Control)
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
			.OnClick = @_Form_Click
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
			.OnClick = @_MenuItem2_Click
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
			.OnClick = @_CommandButton1_Click
			.Designer = @This
			.Parent = @This
		End With
	End Constructor
	
	Private Sub Form1Type._Form_Click(ByRef Sender As Control)
		(*Cast(Form1Type Ptr, Sender.Designer)).Form_Click(Sender)
	End Sub
	
	Private Sub Form1Type._MenuItem2_Click(ByRef Sender As MenuItem)
		(*Cast(Form1Type Ptr, Sender.Designer)).MenuItem2_Click(Sender)
	End Sub
	
		Private Sub Form1Type._CommandButton1_Click(ByRef Sender As Control)
		(*Cast(Form1Type Ptr, Sender.Designer)).CommandButton1_Click(Sender)
	End Sub
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
