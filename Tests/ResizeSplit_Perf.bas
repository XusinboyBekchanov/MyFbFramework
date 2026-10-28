'###############################################################################
'#  ResizeSplit_Perf.bas                                                       #
'#  resize 耗时里"布局移动"与"真正绘制"各占多少。                               #
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
Dim As Panel pnlTop, pnlLeft, pnlRight, pnlBottom, pnlClient
pnlTop.Parent = @frm : pnlTop.Align = alTop : pnlTop.Height = 32 : pnlTop.CreateWnd
pnlLeft.Parent = @frm : pnlLeft.Align = alLeft : pnlLeft.Width = 260 : pnlLeft.CreateWnd
pnlRight.Parent = @frm : pnlRight.Align = alRight : pnlRight.Width = 260 : pnlRight.CreateWnd
pnlBottom.Parent = @frm : pnlBottom.Align = alBottom : pnlBottom.Height = 200 : pnlBottom.CreateWnd
pnlClient.Parent = @frm : pnlClient.Align = alClient : pnlClient.CreateWnd
Dim As Panel inner1, inner2
inner1.Parent = @pnlClient : inner1.Align = alClient : inner1.CreateWnd
inner2.Parent = @inner1 : inner2.Align = alClient : inner2.CreateWnd

Dim As Label lbl(N - 1)
For i As Integer = 0 To N - 1
	lbl(i).Parent = @inner2
	lbl(i).Text = "item " & i
	lbl(i).Left = (i Mod 10) * 60
	lbl(i).Top = (i \ 10) * 20
	lbl(i).Width = 56
	lbl(i).Height = 18
	lbl(i).Anchor.Left = asAnchor
	lbl(i).Anchor.Top = asAnchor
	lbl(i).Anchor.Right = asAnchor
	lbl(i).Anchor.Bottom = asAnchor
	lbl(i).CreateWnd
Next i
frm.RequestAlign
UpdateWindow(frm.Handle)

Dim As Double t0, dt
Dim As Integer iRounds = 100

' A: 正常 resize (布局 + 绘制)
t0 = TimerHiRes
For i As Integer = 1 To iRounds
	SetWindowPos(frm.Handle, 0, 0, 0, 1200 + (i And 1) * 40, 800 + (i And 1) * 40, SWP_NOMOVE Or SWP_NOZORDER Or SWP_NOACTIVATE)
Next i
dt = (TimerHiRes - t0) * 1000 / iRounds
Print "A resize with painting        : " & Str(dt)

' B: 只调布局, 禁止任何绘制 (WM_SETREDRAW FALSE)
SendMessageW(frm.Handle, WM_SETREDRAW, 0, 0)
t0 = TimerHiRes
For i As Integer = 1 To iRounds
	SetWindowPos(frm.Handle, 0, 0, 0, 1200 + (i And 1) * 40, 800 + (i And 1) * 40, SWP_NOMOVE Or SWP_NOZORDER Or SWP_NOACTIVATE)
Next i
dt = (TimerHiRes - t0) * 1000 / iRounds
Print "B resize painting disabled    : " & Str(dt)
SendMessageW(frm.Handle, WM_SETREDRAW, 1, 0)

' C: 只调布局, 不 invalidate (RequestAlign 里 RedrawWindow 去掉的效果)
t0 = TimerHiRes
For i As Integer = 1 To iRounds
	SetWindowPos(frm.Handle, 0, 0, 0, 1200 + (i And 1) * 40, 800 + (i And 1) * 40, SWP_NOMOVE Or SWP_NOZORDER Or SWP_NOACTIVATE Or SWP_NOREDRAW)
Next i
dt = (TimerHiRes - t0) * 1000 / iRounds
Print "C resize SWP_NOREDRAW on form : " & Str(dt)

' D: 什么都不做, 只是 SetWindowPos 同尺寸 (基线)
t0 = TimerHiRes
For i As Integer = 1 To iRounds
	SetWindowPos(frm.Handle, 0, 0, 0, 1240, 840, SWP_NOMOVE Or SWP_NOZORDER Or SWP_NOACTIVATE Or SWP_NOSIZE)
Next i
dt = (TimerHiRes - t0) * 1000 / iRounds
Print "D SetWindowPos no-op          : " & Str(dt)

Print "DONE"
End 0
