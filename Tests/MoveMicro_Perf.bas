'###############################################################################
'#  MoveMicro_Perf.bas                                                         #
'#  微基准: 单控件移动/重绘/字体重建的真实开销。                                #
'#  (UTF-8 BOM; 控制台输出仅 ASCII)                                            #
'###############################################################################
#ifndef UNICODE
	#define UNICODE
#endif
#include once "windows.bi"
#include once "mff/Form.bi"
#include once "mff/Panel.bi"
#include once "mff/Label.bi"
#include once "mff/CommandButton.bi"
#include once "mff/SysUtils.bi"

Using My.Sys.Forms

Dim As Form frm
frm.Width = 1000 : frm.Height = 700
frm.CreateWnd

Dim As Panel pnl
pnl.Parent = @frm : pnl.Align = alClient : pnl.CreateWnd

Dim As Label lbl
lbl.Parent = @pnl : lbl.Text = "hello world" : lbl.Left = 10 : lbl.Top = 10 : lbl.Width = 100 : lbl.Height = 20
lbl.CreateWnd

Dim As CommandButton btn
btn.Parent = @pnl : btn.Text = "Button" : btn.Left = 10 : btn.Top = 40 : btn.Width = 100 : btn.Height = 26
btn.CreateWnd

Dim As Integer N = 2000
Dim As Double t0, dt

' 1) MoveWindow bRepaint = TRUE (当前 Component.Move 的行为)
t0 = TimerHiRes
For i As Integer = 1 To N
	MoveWindow(lbl.Handle, 10 + (i And 1), 10, 100, 20, True)
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "MoveWindow Label   repaint=True  : " & Str(dt) & " ms"

' 2) MoveWindow bRepaint = FALSE
t0 = TimerHiRes
For i As Integer = 1 To N
	MoveWindow(lbl.Handle, 10 + (i And 1), 10, 100, 20, False)
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "MoveWindow Label   repaint=False : " & Str(dt) & " ms"

' 3) SetWindowPos SWP_NOREDRAW
t0 = TimerHiRes
For i As Integer = 1 To N
	SetWindowPos(lbl.Handle, 0, 10 + (i And 1), 10, 100, 20, SWP_NOZORDER Or SWP_NOACTIVATE Or SWP_NOREDRAW)
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "SetWindowPos Label SWP_NOREDRAW  : " & Str(dt) & " ms"

' 4) SetWindowPos 无移动 (仅判断是否真的会重绘)
t0 = TimerHiRes
For i As Integer = 1 To N
	SetWindowPos(lbl.Handle, 0, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE Or SWP_NOZORDER Or SWP_NOACTIVATE)
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "SetWindowPos Label  no-op        : " & Str(dt) & " ms"

' 5) CommandButton (主题绘制, 更贵)
t0 = TimerHiRes
For i As Integer = 1 To N
	MoveWindow(btn.Handle, 10 + (i And 1), 40, 100, 26, True)
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "MoveWindow Button  repaint=True  : " & Str(dt) & " ms"

t0 = TimerHiRes
For i As Integer = 1 To N
	MoveWindow(btn.Handle, 10 + (i And 1), 40, 100, 26, False)
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "MoveWindow Button  repaint=False : " & Str(dt) & " ms"

' 6) 字体重建 (WM_DPICHANGED 路径里 Font.Size = Font.Size)
N = 500
t0 = TimerHiRes
For i As Integer = 1 To N
	lbl.Font.Size = lbl.Font.Size
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "Font.Size reassign Label         : " & Str(dt) & " ms"

t0 = TimerHiRes
For i As Integer = 1 To N
	btn.Font.Size = btn.Font.Size
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "Font.Size reassign Button        : " & Str(dt) & " ms"

' 7) GetWindowRect + MapWindowPoints (Left/Top/Width/Height 读取成本)
N = 5000
t0 = TimerHiRes
For i As Integer = 1 To N
	Dim As RECT R
	GetWindowRect(lbl.Handle, @R)
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "GetWindowRect                    : " & Str(dt) & " ms"

t0 = TimerHiRes
For i As Integer = 1 To N
	Dim As Integer w = lbl.Width, h = lbl.Height, l = lbl.Left, t = lbl.Top
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "Width/Height/Left/Top (4 calls)  : " & Str(dt) & " ms"

' 8) 批处理 BeginDeferWindowPos
t0 = TimerHiRes
For i As Integer = 1 To N
	Dim As HDWP h = BeginDeferWindowPos(1)
	h = DeferWindowPos(h, lbl.Handle, 0, 10 + (i And 1), 10, 100, 20, SWP_NOZORDER Or SWP_NOACTIVATE Or SWP_NOREDRAW)
	EndDeferWindowPos(h)
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "DeferWindowPos (1 window)        : " & Str(dt) & " ms"

Print "DONE"
End 0
