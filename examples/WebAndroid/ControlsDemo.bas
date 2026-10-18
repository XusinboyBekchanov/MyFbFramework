'ControlsDemo: the same form for Windows, Linux, Web (WASM) and Android.
'Web:     in VisualFBEditor choose the WASM define and compile; the IDE runs fbc64_js.exe (when present) and emcc
'         with --js-library mff/Web/mff_lib.js. Open the resulting .html through an HTTP server.
'Android: put this file into app/src/main/bas/Form1.bas of an "Android Project" and build it with gradlew.
#ifdef __FB_ANDROID__
	#define package mff_example_application
#endif

#include once "mff/Form.bi"
#include once "mff/CommandButton.bi"
#include once "mff/Label.bi"
#include once "mff/TextBox.bi"
#include once "mff/CheckBox.bi"
#include once "mff/RadioButton.bi"
#include once "mff/ComboBoxEdit.bi"
#include once "mff/ListControl.bi"
#include once "mff/Panel.bi"
#include once "mff/GroupBox.bi"
Using My.Sys.Forms
Type Form1Type Extends Form
	Declare Static Sub txt_Change(ByRef Designer As My.Sys.Object, ByRef Sender As TextBox)
	Declare Static Sub chk_Click(ByRef Designer As My.Sys.Object, ByRef Sender As CheckBox)
	Declare Static Sub opt_Click(ByRef Designer As My.Sys.Object, ByRef Sender As RadioButton)
	Declare Static Sub cbo_Selected(ByRef Designer As My.Sys.Object, ByRef Sender As ComboBoxEdit, ItemIndex As Integer)
	Declare Static Sub lst_Change(ByRef Designer As My.Sys.Object, ByRef Sender As ListControl)
	Declare Static Sub cmd_Click(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
	Declare Constructor
	Dim As Label lbl
	Dim As TextBox txt
	Dim As CheckBox chk
	Dim As GroupBox grp
	Dim As RadioButton opt1, opt2
	Dim As ComboBoxEdit cbo
	Dim As ListControl lst
	Dim As Panel pnl
	Dim As CommandButton cmd
End Type
Constructor Form1Type
	This.Name = "Form1": This.Text = "Синов 3": This.SetBounds 0, 0, 420, 360
	lbl.Name = "lbl": lbl.Text = "-": lbl.SetBounds 10, 10, 390, 20: lbl.Parent = @This
	txt.Name = "txt": txt.SetBounds 10, 35, 200, 24: txt.OnChange = @txt_Change: txt.Parent = @This
	chk.Name = "chk": chk.Text = "Белги": chk.SetBounds 220, 35, 150, 24: chk.OnClick = @chk_Click: chk.Parent = @This
	grp.Name = "grp": grp.Text = "Танлов": grp.SetBounds 10, 65, 200, 80: grp.Parent = @This
	opt1.Name = "opt1": opt1.Text = "Бир": opt1.SetBounds 10, 20, 150, 22: opt1.OnClick = @opt_Click: opt1.Parent = @grp
	opt2.Name = "opt2": opt2.Text = "Икки": opt2.SetBounds 10, 45, 150, 22: opt2.OnClick = @opt_Click: opt2.Parent = @grp
	cbo.Name = "cbo": cbo.SetBounds 220, 65, 180, 24: cbo.AddItem "Олма": cbo.AddItem "Нок": cbo.AddItem "Узум": cbo.OnSelected = @cbo_Selected: cbo.Parent = @This
	lst.Name = "lst": lst.SetBounds 220, 100, 180, 90: lst.AddItem "Тошкент": lst.AddItem "Самарқанд": lst.AddItem "Хива": lst.OnChange = @lst_Change: lst.Parent = @This
	pnl.Name = "pnl": pnl.SetBounds 10, 200, 390, 60: pnl.BackColor = &hE0F0E0: pnl.Parent = @This
	cmd.Name = "cmd": cmd.Text = "Ичидаги тугма": cmd.SetBounds 10, 15, 150, 30: cmd.OnClick = @cmd_Click: cmd.Parent = @pnl
End Constructor
Dim Shared f As Form1Type
Private Sub Form1Type.txt_Change(ByRef Designer As My.Sys.Object, ByRef Sender As TextBox)
	f.lbl.Text = "txt: " & Sender.Text
End Sub
Private Sub Form1Type.chk_Click(ByRef Designer As My.Sys.Object, ByRef Sender As CheckBox)
	f.lbl.Text = "chk: " & Sender.Checked
End Sub
Private Sub Form1Type.opt_Click(ByRef Designer As My.Sys.Object, ByRef Sender As RadioButton)
	f.lbl.Text = "opt: " & Sender.Text
End Sub
Private Sub Form1Type.cbo_Selected(ByRef Designer As My.Sys.Object, ByRef Sender As ComboBoxEdit, ItemIndex As Integer)
	f.lbl.Text = "cbo: " & ItemIndex & " " & Sender.Item(ItemIndex)
End Sub
Private Sub Form1Type.lst_Change(ByRef Designer As My.Sys.Object, ByRef Sender As ListControl)
	f.lbl.Text = "lst: " & Sender.ItemIndex & " " & Sender.Item(Sender.ItemIndex)
End Sub
Private Sub Form1Type.cmd_Click(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
	f.lbl.Text = "cmd: " & Sender.Text
End Sub
f.Show
App.Run
