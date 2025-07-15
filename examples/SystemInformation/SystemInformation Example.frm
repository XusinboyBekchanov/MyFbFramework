'#Region "Form"
	#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
		#define __MAIN_FILE__
		#ifdef __FB_WIN32__
			#cmdline "Form1.rc"
		#endif
		Const _MAIN_FILE_ = __FILE__
	#endif
	#include once "mff/Form.bi"
	#include once "mff/CommandButton.bi"
	#include once "mff/SystemInformation.bi"
	#include once "mff/TextBox.bi"
	Using My.Sys.Forms
	
	Type Form1Type Extends Form
		Declare Sub CommandButton1_Click(ByRef Sender As Control)
		Declare Constructor
		
		Dim As CommandButton CommandButton1
		Dim As TextBox TextBox1
	End Type
	
	Constructor Form1Type
		#if _MAIN_FILE_ = __FILE__
			With App
				.CurLanguagePath = ExePath & "/Languages/"
				.CurLanguage = My.Sys.Language
			End With
		#endif
		' Form1
		With This
			.Name = "Form1"
			.Text = "Form1"
			.Designer = @This
			.SetBounds 0, 0, 350, 300
		End With
		' CommandButton1
		With CommandButton1
			.Name = "CommandButton1"
			.Text = "Print"
			.TabIndex = 0
			.Caption = "Print"
			.SetBounds 60, 170, 190, 50
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @CommandButton1_Click)
			.Parent = @This
		End With
		' TextBox1
		With TextBox1
			.Name = "TextBox1"
			.Text = ""
			.TabIndex = 1
			.Multiline = True 
			.SetBounds 10, 10, 310, 150
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

Private Sub Form1Type.CommandButton1_Click(ByRef Sender As Control)
	TextBox1.Text = "Screen size: " & SystemInformation.ScreenWidth & " x= "  &  SystemInformation.ScreenHeight
	TextBox1.Text = TextBox1.Text & Chr(13, 10) & "Mouse button state: "  &  SystemInformation.MouseButtons
	TextBox1.Text = TextBox1.Text & Chr(13, 10) & "Double-click area: "  &  SystemInformation.DoubleClickSize.Width &  " x ="  &  SystemInformation.DoubleClickSize.Height
	Dim workArea As My.Sys.Drawing.Rect = SystemInformation.WorkingArea
	TextBox1.Text = TextBox1.Text & Chr(13, 10) & "Working area: "  &  workArea.right &  "x="  &  workArea.Bottom &  " @("  &  workArea.left &  ","  &  workArea.top &  ")"
	TextBox1.Text = TextBox1.Text & Chr(13, 10) & "Window border size: "  &  SystemInformation.BorderSize.Width &  "x = "  &  SystemInformation.BorderSize.Height
	TextBox1.Text = TextBox1.Text & Chr(13, 10) & "Max draggable window size: "  &  SystemInformation.MaxWindowTrackSize.Width &  "x ="  &  SystemInformation.MaxWindowTrackSize.Height
End Sub