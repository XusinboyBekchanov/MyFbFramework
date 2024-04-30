'################################################################################
'#  CHTTP_Curl.frm                                                              #
'#  This file is an examples of MyFBFramework.                                  #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'################################################################################

'Please copy the three files (libcurl.dll, libcurl-x64.dll, curl-ca-bundle.crt) 
'from "VisualFBEditor\Controls\MyFbFramework\Lib\" to the current execution file directory.


'#Region "Form"
	#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
		#define __MAIN_FILE__
		#ifdef __FB_WIN32__
			'#cmdline "-static"
		#endif
		Const _MAIN_FILE_ = __FILE__
	#endif
	#include once "mff/Form.bi"
	#include once "mff/TextBox.bi"
	#include once "mff/ComboBoxEdit.bi"
	#include once "mff/CommandButton.bi"
	#include once "mff/Label.bi"
	#include once "mff/RichTextBox.bi"
	
	#include once "inc/CHttp.bi"
	Using My.Sys.Forms
	
	Type Form1Type Extends Form
		Declare Sub cmdRun_Click(ByRef Sender As Control)
		Declare Constructor
		
		Dim As RichTextBox RtfReceive
		Dim As ComboBoxEdit cboURL
		Dim As CommandButton cmdRun
		Dim As Label Label1
	End Type
	
	Constructor Form1Type
		#if _MAIN_FILE_ = __FILE__
			With App
				.CurLanguagePath = ExePath & "/Languages/"
				.CurLanguage = .Language
				Debug.Print "CurLanguage=" & .CurLanguage
			End With
		#endif
		' Form1
		With This
			.Name = "Form1"
			.Text = "Form1"
			.Designer = @This
			.SetBounds 0, 0, 360, 300
		End With
		' RtfReceive
		With RtfReceive
			.Name = "RtfReceive"
			.Text = ML("Waiting...")
			.TabIndex = 0
			.Anchor.Right = AnchorStyle.asAnchor
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Bottom = AnchorStyle.asAnchor
			.WordWraps = True
			.ID = 1016
			.Multiline = True
			.ScrollBars = ScrollBarsType.Both
			.SetBounds 10, 30, 330, 230
			.Designer = @This
			.Parent = @This
		End With
		' cboURL
		With cboURL
			.Name = "cboURL"
			.AddItem "https://www.freebasic.net/"
			.AddItem "https://www.bing.com/"
			.AddItem "https://www.baidu.com/"
			.AddItem "https://www.baidu.com/"
			.Text = "https://www.freebasic.net/"
			.Anchor.Right = AnchorStyle.asAnchor
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Bottom = AnchorStyle.asAnchor
			.Style = cbDropDown
			.TabIndex = 1
			.SetBounds 50, 10, 260, 16
			.Designer = @This
			.Parent = @This
		End With
		' cmdRun
		With cmdRun
			.Name = "cmdRun"
			.Text = "Run"
			.TabIndex = 2
			.Caption = "Run"
			.DoubleBuffered = True
			.Anchor.Right = AnchorStyle.asAnchor
			.SetBounds 310, 10, 30, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdRun_Click)
			.Parent = @This
		End With
		' Label1
		With Label1
			.Name = "Label1"
			.Text = "URL："
			.TabIndex = 3
			.SetBounds 10, 10, 40, 20
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

Private Sub Form1Type.cmdRun_Click(ByRef Sender As Control)
	'' create object
		Dim As CHttpStream stream
		'' get the page
		'If( stream.receive( "www.freebasic.net" ) ) Then
		RtfReceive.Text = "Start..."
		If( stream.receive( Trim(cboURL.Text)) ) Then
			RtfReceive.Text = FromUtf8(stream.read())
			If Not cboURL.Contains(Trim(cboURL.Text)) Then 
				cboURL.AddItem Trim(cboURL.Text)
			End If
		Else
			RtfReceive.Text = "nothing found! " & cboURL.Text
		End If
	
		'' the stream will be closed when the object is destroyed
End Sub
