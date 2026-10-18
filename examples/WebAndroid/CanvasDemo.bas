'CanvasDemo: drawing with Canvas (OnPaint), Ruler and Chart on Windows, Linux, Web (WASM) and Android.
'Web:     in VisualFBEditor choose the WASM define and compile; open the resulting .html through an HTTP server.
'Android: put this file into app/src/main/bas/Form1.bas of an "Android Project" and build it with gradlew.
#ifdef __FB_ANDROID__
	#define package mff_example_application
#endif

#include once "mff/Form.bi"
#include once "mff/Panel.bi"
#include once "mff/Ruler.bi"
#include once "mff/Chart.bi"
#include once "mff/CommandButton.bi"
Using My.Sys.Forms
Using My.Sys.Drawing
Type Form1Type Extends Form
	Declare Static Sub pnl_Paint(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
	Declare Static Sub cmd_Click(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
	Declare Constructor
	Dim As Ruler rul
	Dim As Panel pnl
	Dim As Chart cht
	Dim As CommandButton cmd
	Dim As Integer Turn
End Type
Constructor Form1Type
	This.Name = "Form1": This.Text = "Canvas": This.SetBounds 0, 0, 460, 460
	rul.Name = "rul": rul.SetBounds 10, 10, 430, 30: rul.Parent = @This
	pnl.Name = "pnl": pnl.SetBounds 10, 50, 210, 200: pnl.BackColor = &hFFFFFF: pnl.OnPaint = @pnl_Paint: pnl.Parent = @This
	cmd.Name = "cmd": cmd.Text = "Айлантириш": cmd.SetBounds 10, 260, 210, 30: cmd.OnClick = @cmd_Click: cmd.Parent = @This
	cht.Name = "cht": cht.SetBounds 230, 50, 210, 240: cht.ChartStyle = CS_Pie: cht.Title = "Мевалар": cht.Parent = @This
	Dim As WStringList Ptr Names = New WStringList
	Names->Add "Олма": Names->Add "Нок": Names->Add "Узум"
	cht.AddAxisItems Names
	Dim As DoubleList Ptr Values = New DoubleList
	Values->Add 10: Values->Add 15: Values->Add 5
	cht.AddSerie "2026", clRed, Values
End Constructor
Dim Shared f As Form1Type
Private Sub Form1Type.pnl_Paint(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
	Dim As Double a = f.Turn * 3.1415926 / 12
	Canvas.Pen.Color = &h808080
	Canvas.Brush.Color = &hF0D0A0
	Canvas.Rectangle 10, 10, 200, 190
	Canvas.Pen.Color = &h0000C0
	Canvas.DrawWidth = 3
	Canvas.Line 105, 100, 105 + 80 * Cos(a), 100 + 80 * Sin(a)
	Canvas.DrawWidth = 1
	Canvas.Brush.Color = &h40C040
	Canvas.Ellipse 85, 80, 125, 120
	Canvas.TextOut 20, 20, "Canvas: " & f.Turn, &h000000, -1
End Sub
Private Sub Form1Type.cmd_Click(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
	f.Turn += 1
	f.pnl.Repaint
End Sub
f.Show
App.Run
