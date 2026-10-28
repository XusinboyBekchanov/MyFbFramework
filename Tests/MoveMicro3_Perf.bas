'###############################################################################
'#  MoveMicro3_Perf.bas                                                        #
'#  WM_SETFONT 的 redraw 参数成本, 以及 dpi 未变时重建字体的浪费。              #
'#  (UTF-8 BOM; 控制台输出仅 ASCII)                                            #
'###############################################################################
#ifndef UNICODE
	#define UNICODE
#endif
#include once "windows.bi"
#include once "mff/Form.bi"
#include once "mff/Panel.bi"
#include once "mff/Label.bi"
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

Dim As Integer N = 2000
Dim As Double t0, dt
Dim As HFONT hf = lbl.Font.Handle

t0 = TimerHiRes
For i As Integer = 1 To N
	SendMessageW(lbl.Handle, WM_SETFONT, CUInt(hf), True)
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "WM_SETFONT redraw=TRUE   : " & Str(dt)

t0 = TimerHiRes
For i As Integer = 1 To N
	SendMessageW(lbl.Handle, WM_SETFONT, CUInt(hf), False)
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "WM_SETFONT redraw=FALSE  : " & Str(dt)

' 一次 UpdateWindow 把挂起的重绘清掉, 避免后续测量被拖累
UpdateWindow(frm.Handle)

' Font.Size 赋值 (含 CreateFontW + WM_SETFONT)
t0 = TimerHiRes
For i As Integer = 1 To N
	lbl.Font.Size = lbl.Font.Size
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "Font.Size = Font.Size    : " & Str(dt)

Print "DONE"
End 0
