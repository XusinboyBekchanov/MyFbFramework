'################################################################################
'#  Form4.frm                                                                   #
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
	
	Using My.Sys.Forms
	
	Type Form4Type Extends Form
		Declare Constructor
		
	End Type
	
	Constructor Form4Type
		' Form4
		With This
			.Name = "Form4"
			.Text = "Form4"
			.FormStyle = FormStyles.fsNormal
			.Designer = @This
			.SetBounds 0, 0, 350, 300
		End With
	End Constructor
	
	Dim Shared Form4 As Form4Type
	#if _MAIN_FILE_ = __FILE__
		Form4.MainForm = True
		Form4.Show
		App.Run
	#endif
'#End Region
