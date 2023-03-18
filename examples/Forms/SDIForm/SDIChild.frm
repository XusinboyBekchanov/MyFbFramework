'################################################################################
'#  SDIChild.frm                                                                #
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
	#include once "mff/TextBox.bi"
	
	Using My.Sys.Forms
	
	Type SDIChildType Extends Form
		Declare Static Sub _Form_Destroy(ByRef Sender As Control)
		Declare Sub Form_Destroy(ByRef Sender As Control)
		Declare Static Sub _Form_Activate(ByRef Sender As Form)
		Declare Sub Form_Activate(ByRef Sender As Form)
		Declare Constructor
		
		Dim As TextBox TextBox1
	End Type
	
	Constructor SDIChildType
		'SDIChild
		With This
			.Name = "SDIChild"
			.Text = "SDIChild"
			.Designer = @This
			.FormStyle = FormStyles.fsNormal
			.OnDestroy = @_Form_Destroy
			.OnActivate = @_Form_Activate
			.SetBounds 0, 0, 260, 190
		End With
		' TextBox1
		With TextBox1
			.Name = "TextBox1"
			.Text = ""
			.TabIndex = 0
			.Multiline = True
			.ScrollBars = ScrollBarsType.Both
			.Align = DockStyle.alClient
			.SetBounds 0, 0, 244, 151
			.Designer = @This
			.Parent = @This
		End With
	End Constructor
	
	Private Sub SDIChildType._Form_Activate(ByRef Sender As Form)
		(*Cast(SDIChildType Ptr, Sender.Designer)).Form_Activate(Sender)
	End Sub
	
	Private Sub SDIChildType._Form_Destroy(ByRef Sender As Control)
		(*Cast(SDIChildType Ptr, Sender.Designer)).Form_Destroy(Sender)
	End Sub
	
	Dim Shared SDIChild As SDIChildType
	
	#if _MAIN_FILE_ = __FILE__
		SDIChild.MainForm = True
		SDIChild.Show
		App.Run
	#endif
'#End Region

Private Sub SDIChildType.Form_Destroy(ByRef Sender As Control)
	SDIMain.SDIChildDestroy(@This)
End Sub

Private Sub SDIChildType.Form_Activate(ByRef Sender As Form)
	SDIMain.SDIChildActivate(@This)
End Sub
