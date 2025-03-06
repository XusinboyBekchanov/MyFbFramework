'#Region "Form"
	#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
		#define __MAIN_FILE__
		#ifdef __FB_WIN32__
			#cmdline "Form1.rc"
		#endif
		Const _MAIN_FILE_ = __FILE__
	#endif
	#include once "mff/Form.bi"
	#include once "mff/StatusBar.bi"
	
	Using My.Sys.Forms
	
	Type Form1Type Extends Form
		Declare Sub StatusBar1_PanelClick(ByRef Sender As StatusBar, ByRef stPanel As StatusPanel, MouseButton As Integer, x As Integer, y As Integer)
		Declare Constructor
		
		Dim As StatusBar StatusBar1
		Dim As StatusPanel StatusPanel1, StatusPanel2, StatusPanel3
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
		' StatusBar1
		With StatusBar1
			.Name = "StatusBar1"
			.Text = "StatusBar1"
			.Align = DockStyle.alBottom
			.SetBounds 0, 238, 334, 23
			.Designer = @This
			.OnPanelClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As StatusBar, ByRef stPanel As StatusPanel, MouseButton As Integer, x As Integer, y As Integer), @StatusBar1_PanelClick)
			.Parent = @This
		End With
		' StatusPanel1
		With StatusPanel1
			.Name = "StatusPanel1"
			.Designer = @This
			.Caption = "First"
			.Parent = @StatusBar1
		End With
		' StatusPanel2
		With StatusPanel2
			.Name = "StatusPanel2"
			.Designer = @This
			.Caption = "Second"
			.Parent = @StatusBar1
		End With
		' StatusPanel3
		With StatusPanel3
			.Name = "StatusPanel3"
			.Designer = @This
			.Caption = "Third"
			.Parent = @StatusBar1
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

Private Sub Form1Type.StatusBar1_PanelClick(ByRef Sender As StatusBar, ByRef stPanel As StatusPanel, MouseButton As Integer, x As Integer, y As Integer)
	If Not stPanel.IsEmpty Then
		?stPanel.Caption, MouseButton, x, y
	End If
End Sub
