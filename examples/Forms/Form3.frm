'################################################################################
'#  Form3.frm                                                                   #
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
	
	Type Form3Type Extends Form
		Declare Static Sub _Form_Click(ByRef Sender As Control)
		Declare Sub Form_Click(ByRef Sender As Control)
		Declare Static Sub _CommandButton1_Click(ByRef Sender As Control)
		Declare Sub CommandButton1_Click(ByRef Sender As Control)
		Declare Constructor
		
		Dim As CommandButton CommandButton1
	End Type
	
	Constructor Form3Type
		' Form3
		With This
			.Name = "Form3"
			.Text = "Form3"
			.FormStyle = FormStyles.fsNormal
			.Designer = @This
			.OnClick = @_Form_Click
			.SetBounds 0, 0, 350, 300
		End With
			' CommandButton1
		With CommandButton1
			.Name = "CommandButton1"
			.Text = "Click me show another form"
			.TabIndex = 1
			.ControlIndex = 0
			.SetBounds 110, 76, 144, 52
			.Designer = @This
			.OnClick = @_CommandButton1_Click
			.Parent = @This
		End With
	End Constructor
	
	Private Sub Form3Type._CommandButton1_Click(ByRef Sender As Control)
		(*Cast(Form3Type Ptr, Sender.Designer)).CommandButton1_Click(Sender)
	End Sub
	
	Private Sub Form3Type._Form_Click(ByRef Sender As Control)
		(*Cast(Form3Type Ptr, Sender.Designer)). Form_Click(Sender)
	End Sub
	
	Dim Shared Form3 As Form3Type
	#if _MAIN_FILE_ = __FILE__
		Form3.MainForm = True
		Form3.Show
		App.Run
	#endif
'#End Region

#include once "Form4.frm"

Private Sub Form3Type.Form_Click(ByRef Sender As Control)
	Form4.Show Form3
End Sub

Private Sub Form3Type.CommandButton1_Click(ByRef Sender As Control)
	Form4.Show Form3
End Sub
