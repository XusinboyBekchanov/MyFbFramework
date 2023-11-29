'################################################################################
'#  CanvasDraw.frm                                                              #
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
	#include once "mff/Label.bi"
	Using My.Sys.Forms

	Type Form1Type Extends Form
		Declare Sub CommandButton1_Click(ByRef Sender As Control)
		Declare Sub Label1_Click(ByRef Sender As Label)
		Declare Constructor
	
		Dim As Label Label1(3)

	End Type
	
	Constructor Form1Type
		' Form1
		With This
			.Name = "Form1"
			.Text = "VisualFBEditor-Label Rotate testing"
			.Designer = @This
			.BackColor = 32768
			.Graphic.LoadFromFile(ExePath & "/../Resources/background.png")
			.StartPosition = FormStartPosition.CenterScreen
			.SetBounds -112, 0, 410, 605
		End With
		' Label1(2)
		With Label1(2)
			.Name = "Label1(2)"
			.Text = "Hello World Label2 (WordWraps)"
			.TabIndex = 3
			.Alignment = AlignmentConstants.taLeft
			.Font.Size = 14
			.Font.Name = "Tahoma"
			'.Font.Orientation = 90
			.ForeColor = 255
			.BackColor = 32768 'clBlue
			.Border = LabelBorder.sbNone
			.ID = 2051
			.WordWraps = True
			.SetBounds 92, 206, 110, 80
			.Designer = @This
			.Parent = @This
		End With
		' Label1(0)
		With Label1(0)
			.Name = "Label1(0)"
			.Text = "Hello World Label0(AutoSize)"
			.TabIndex = 0 
			.DoubleBuffered = True 
			.BackColor = 32768
			.ForeColor = 255
			'.ShowText = True 
			.Font.Size = 14
			.Font.Name = "Tahoma"
			.Font.Orientation = 0 
			.SetBounds 63, 16, 280, 70
			.ID = 1099
			.Alignment = AlignmentConstants.taLeft
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Right = AnchorStyle.asAnchor
			.Anchor.Left = AnchorStyle.asAnchor 
			'.Caption = "Hello World "
			.WordWraps = False
			.AutoSize = True
			.Designer = @This
			.Parent = @This
		End With
		' Label1(1)
		With Label1(1)
			.Name = "Label1(1)"
			.Text = "Hello World Label1"
			.TabIndex = 1 
			.BackColor = 32768
			.ForeColor = 255
			.Alignment = AlignmentConstants.taCenter
			.ControlIndex = 1
			.Font.Size = 24
			.Font.Name = "Tahoma"
			.Font.Orientation = -90
			.ID = 2048
			.SetBounds 222, 56, 360, 310
			.WordWraps = False
			.Designer = @This
			.Parent = @This
		End With

		' Label1(3)
		With Label1(3)
			.Name = "Label1(3)"
			.Text = "           Label3"
			.TabIndex = 2
			.DoubleBuffered = True 
			.BackColor = 32768
			.ForeColor = 255
			.Alignment = AlignmentConstants.taLeft
			.ControlIndex = 1
			.Font.Size = 24
			.Font.Name = "Tahoma"
			.Font.Orientation = 90
			.ID = 1280
			.SetBounds 12, 60, 40, 160
			.WordWraps = True
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Label), @Label1_Click)
			.Parent = @This
		End With
	End Constructor
	
	Dim Shared Form1 As Form1Type
	
	#if _MAIN_FILE_ = __FILE__
		'App.DarkMode = True
		Form1.MainForm = True
		Form1.Show
		App.Run
	#endif
'#End Region
 

Private Sub Form1Type.Label1_Click(ByRef Sender As Label)
	Dim As Integer Index = Val(Mid(Sender.Name, InStrRev(Sender.Name, "(") + 1))
End Sub
