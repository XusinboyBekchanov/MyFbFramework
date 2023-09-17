'################################################################################
'#  Hello.frm                                                              #
'#  This file is an examples of MyFBFramework.                                  #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'################################################################################

'#Region "Form"
	#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
		#define __MAIN_FILE__
		#ifdef __FB_WIN32__
			#cmdline "Hello.rc"
		#endif
		Const _MAIN_FILE_ = __FILE__
	#endif
	#include once "mff/Form.bi"
	#include once "mff/CommandButton.bi"
	
	Using My.Sys.Forms
	
	Type Form1Type Extends Form
		Declare Sub CommandButton1_Click(ByRef Sender As Control)
		Declare Constructor
		
		Dim As CommandButton CommandButton1
	End Type
	
	Constructor Form1Type
		' Form1
		With This
			.Name = "Form1"
			.Text = "Form1"
			#ifdef __USE_GTK__
				.Icon.LoadFromFile(ExePath & "VisualFBEditor.ico")
			#else
				.BorderStyle = FormBorderStyle.FixedDialog
				.Icon.LoadFromResourceID(1)
			#endif
			.Designer = @This
			.SetBounds 0, 0, 350, 300
		End With
		' CommandButton1
		With CommandButton1
			.Name = "CommandButton1"
			.Text = "CommandButton1"
			.TabIndex = 0
			.SetBounds 80, 110, 140, 30
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @CommandButton1_Click)
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

Private Sub Form1Type.CommandButton1_Click(ByRef Sender As Control)
	Debug.Print  "Hello", True, True
End Sub
