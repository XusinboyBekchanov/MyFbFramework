#ifdef __FB_WIN32__
	'#Compile -exx -s gui "Example.rc"
#else
	'#Compile -exx
#endif
#include "mff/Form.bi"
#include "mff/CommandButton.bi"

Using My.Sys.Forms

Dim Shared frm As Form, cmd As CommandButton

Sub cmd_Click(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
	MsgBox "Hello"
End Sub

cmd.Text = "Click me!"
cmd.SetBounds 100, 100, 150, 30
cmd.OnClick = @cmd_Click
frm.Add @cmd

frm.CenterToScreen
frm.Show

App.Run
