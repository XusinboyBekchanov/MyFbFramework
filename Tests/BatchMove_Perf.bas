'###############################################################################
'#  BatchMove_Perf.bas                                                         #
'#  比较 300 个窗口移动的几种策略。                                             #
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

Const N = 300

Dim As Form frm
frm.Width = 1200 : frm.Height = 800
frm.CreateWnd
Dim As Panel pnl
pnl.Parent = @frm : pnl.Align = alClient : pnl.CreateWnd

Dim As Label lbl(N - 1)
For i As Integer = 0 To N - 1
	lbl(i).Parent = @pnl
	lbl(i).Text = "item " & i
	lbl(i).Left = (i Mod 10) * 60
	lbl(i).Top = (i \ 10) * 20
	lbl(i).Width = 56
	lbl(i).Height = 18
	lbl(i).CreateWnd
Next i
UpdateWindow(frm.Handle)

Dim As Double t0, dt
Dim As Integer iRounds = 30

' --- A: 逐个 SetWindowPos SWP_NOREDRAW --------------------------------------
t0 = TimerHiRes
For r As Integer = 1 To iRounds
	For i As Integer = 0 To N - 1
		SetWindowPos(lbl(i).Handle, 0, (i Mod 10) * 60 + (r And 1), (i \ 10) * 20, 56, 18, SWP_NOZORDER Or SWP_NOACTIVATE Or SWP_NOREDRAW)
	Next i
	UpdateWindow(frm.Handle)
Next r
dt = (TimerHiRes - t0) * 1000 / iRounds
Print "A per-window SWP_NOREDRAW          : " & Str(dt)

' --- B: WM_SETREDRAW FALSE 包住逐个 SetWindowPos -----------------------------
t0 = TimerHiRes
For r As Integer = 1 To iRounds
	SendMessageW(frm.Handle, WM_SETREDRAW, 0, 0)
	For i As Integer = 0 To N - 1
		SetWindowPos(lbl(i).Handle, 0, (i Mod 10) * 60 + (r And 1), (i \ 10) * 20, 56, 18, SWP_NOZORDER Or SWP_NOACTIVATE Or SWP_NOREDRAW)
	Next i
	SendMessageW(frm.Handle, WM_SETREDRAW, 1, 0)
	RedrawWindow(frm.Handle, 0, 0, RDW_INVALIDATE Or RDW_ALLCHILDREN)
	UpdateWindow(frm.Handle)
Next r
dt = (TimerHiRes - t0) * 1000 / iRounds
Print "B WM_SETREDRAW(FALSE) + per-window  : " & Str(dt)

' --- C: BeginDeferWindowPos 一次提交 ----------------------------------------
t0 = TimerHiRes
For r As Integer = 1 To iRounds
	Dim As HDWP h = BeginDeferWindowPos(N)
	For i As Integer = 0 To N - 1
		h = DeferWindowPos(h, lbl(i).Handle, 0, (i Mod 10) * 60 + (r And 1), (i \ 10) * 20, 56, 18, SWP_NOZORDER Or SWP_NOACTIVATE Or SWP_NOREDRAW)
	Next i
	EndDeferWindowPos(h)
	UpdateWindow(frm.Handle)
Next r
dt = (TimerHiRes - t0) * 1000 / iRounds
Print "C DeferWindowPos batch             : " & Str(dt)

' --- D: WM_SETREDRAW FALSE + DeferWindowPos --------------------------------
t0 = TimerHiRes
For r As Integer = 1 To iRounds
	SendMessageW(frm.Handle, WM_SETREDRAW, 0, 0)
	Dim As HDWP h = BeginDeferWindowPos(N)
	For i As Integer = 0 To N - 1
		h = DeferWindowPos(h, lbl(i).Handle, 0, (i Mod 10) * 60 + (r And 1), (i \ 10) * 20, 56, 18, SWP_NOZORDER Or SWP_NOACTIVATE Or SWP_NOREDRAW)
	Next i
	EndDeferWindowPos(h)
	SendMessageW(frm.Handle, WM_SETREDRAW, 1, 0)
	RedrawWindow(frm.Handle, 0, 0, RDW_INVALIDATE Or RDW_ALLCHILDREN)
	UpdateWindow(frm.Handle)
Next r
dt = (TimerHiRes - t0) * 1000 / iRounds
Print "D WM_SETREDRAW(FALSE) + defer      : " & Str(dt)

' --- E: 全部 true redraw (原行为) -------------------------------------------
t0 = TimerHiRes
For r As Integer = 1 To 10
	For i As Integer = 0 To N - 1
		MoveWindow(lbl(i).Handle, (i Mod 10) * 60 + (r And 1), (i \ 10) * 20, 56, 18, True)
	Next i
Next r
dt = (TimerHiRes - t0) * 1000 / 10
Print "E per-window MoveWindow(repaint)    : " & Str(dt)

Print "DONE"
End 0
