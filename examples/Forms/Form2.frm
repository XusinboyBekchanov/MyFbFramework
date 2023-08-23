'################################################################################
'#  Form2.frm                                                                   #
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
	#include once "mff/CommandButton.bi"
	
	Using My.Sys.Forms
	
	Type Form2Type Extends Form
		Declare Sub CommandButton1_Click(ByRef Sender As Control)
		Declare Sub Form_Click(ByRef Sender As Control)
		Declare Constructor
		
		Dim As CommandButton CommandButton1
	End Type
	
	Constructor Form2Type
		' Form2
		With This
			.Name = "Form2"
			.Text = "Form2"
			.FormStyle = FormStyles.fsNormal
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @Form_Click)
			.SetBounds 0, 0, 350, 300
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
	
	Dim Shared Form2 As Form2Type
	
	#if _MAIN_FILE_ = __FILE__
		Form2.MainForm = True
		Form2.Show
		App.Run
	#endif
'#End Region

#include once "Form3.frm"

Private Sub Form2Type.CommandButton1_Click(ByRef Sender As Control)
	Form3.Show Form2
End Sub

Private Sub Form2Type.Form_Click(ByRef Sender As Control)
	MsgBox "This is form2"
	Form3.Show Form2
End Sub
