'###############################################################################
'#  MoveMicro2_Perf.bas                                                        #
'#  拆解 SetWindowPos / 重绘 / 字体重建 的真实成本。                            #
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

' 原生 static 控件作基线
Dim As HWND hRaw = CreateWindowExW(0, "STATIC", "hello world", WS_CHILD Or WS_VISIBLE, 10, 10, 100, 20, pnl.Handle, 0, GetModuleHandle(0), 0)

Dim As Integer N = 3000
Dim As Double t0, dt

t0 = TimerHiRes
For i As Integer = 1 To N
	MoveWindow(hRaw, 10 + (i And 1), 10, 100, 20, True)
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "raw STATIC  MoveWindow repaint=True   : " & Str(dt)

t0 = TimerHiRes
For i As Integer = 1 To N
	MoveWindow(hRaw, 10 + (i And 1), 10, 100, 20, False)
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "raw STATIC  MoveWindow repaint=False  : " & Str(dt)

t0 = TimerHiRes
For i As Integer = 1 To N
	MoveWindow(lbl.Handle, 10 + (i And 1), 10, 100, 20, True)
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "MFF Label   MoveWindow repaint=True   : " & Str(dt)

t0 = TimerHiRes
For i As Integer = 1 To N
	MoveWindow(lbl.Handle, 10 + (i And 1), 10, 100, 20, False)
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "MFF Label   MoveWindow repaint=False  : " & Str(dt)

t0 = TimerHiRes
For i As Integer = 1 To N
	SetWindowPos(lbl.Handle, 0, 10 + (i And 1), 10, 100, 20, SWP_NOZORDER Or SWP_NOACTIVATE Or SWP_NOREDRAW Or SWP_NOSENDCHANGING)
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "MFF Label   SWP_NOREDRAW+NOSENDCHANG  : " & Str(dt)

t0 = TimerHiRes
For i As Integer = 1 To N
	SetWindowPos(lbl.Handle, 0, 10 + (i And 1), 10, 100, 20, SWP_NOZORDER Or SWP_NOACTIVATE)
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "MFF Label   SetWindowPos (redraw)     : " & Str(dt)

t0 = TimerHiRes
For i As Integer = 1 To N
	InvalidateRect(lbl.Handle, 0, False)
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "MFF Label   InvalidateRect            : " & Str(dt)

' 字体: 只 CreateFontW, 不 SetFont
N = 1000
Dim As Single dpiY = 1
t0 = TimerHiRes
For i As Integer = 1 To N
	Dim As HFONT hf = CreateFontW(-MulDiv(9, dpiY * 96, 72), 0, 0, 0, 400, 0, 0, 0, 1, OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, FF_DONTCARE, "Tahoma")
	DeleteObject(hf)
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "CreateFontW+DeleteObject              : " & Str(dt)

t0 = TimerHiRes
For i As Integer = 1 To N
	lbl.Font.Size = 9
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "Label Font.Size=9 (Create+SetFont)    : " & Str(dt)

t0 = TimerHiRes
For i As Integer = 1 To N
	SendMessageW(lbl.Handle, WM_SETFONT, CUInt(lbl.Font.Handle), True)
Next i
dt = (TimerHiRes - t0) * 1000 / N
Print "Label WM_SETFONT redraw=True          : " & Str(dt)

' 整窗重绘一次的成本
t0 = TimerHiRes
For i As Integer = 1 To 200
	RedrawWindow(frm.Handle, 0, 0, RDW_INVALIDATE Or RDW_ALLCHILDREN)
	UpdateWindow(frm.Handle)
Next i
dt = (TimerHiRes - t0) * 1000 / 200
Print "RedrawWindow ALLCHILDREN + Update     : " & Str(dt)

Print "DONE"
End 0
