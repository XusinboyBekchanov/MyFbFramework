'###############################################################################
'#  ResizeProf.bas                                                             #
'#  只做 resize 循环, 便于 profgen 归因。                                       #
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
Const iRounds = 300

' 只有内层容器重新布局 (300 个锚定控件)
t0 = TimerHiRes
For i As Integer = 1 To iRounds
	inner2.RequestAlign
Next i
dt = (TimerHiRes - t0) * 1000 / iRounds
Print "inner2.RequestAlign (300 labels): " & Str(dt)

' 整个窗体 resize
t0 = TimerHiRes
For i As Integer = 1 To iRounds
	SetWindowPos(frm.Handle, 0, 0, 0, 1200 + (i And 1) * 40, 800 + (i And 1) * 40, SWP_NOMOVE Or SWP_NOZORDER Or SWP_NOACTIVATE)
Next i
dt = (TimerHiRes - t0) * 1000 / iRounds
Print "form resize cascade            : " & Str(dt)

Print "DONE"
End 0
