'###############################################################################
'#  RequestAlign_Perf.bas                                                      #
'#  布局 (RequestAlign) 与 DPI 切换路径的性能基准。                            #
'#  (UTF-8 BOM; 控制台输出仅 ASCII)                                            #
'#                                                                             #
'#  用法: RequestAlign_Perf.exe [labels] [iters]                                #
'#     labels 最内层容器里的锚定控件数 (默认 300)                               #
'#     iters  RequestAlign 重复次数 (默认 100)                                  #
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

Dim Shared As Integer nLabels = 300, nIters = 100
If Command(1) <> "" Then nLabels = Val(Command(1))
If Command(2) <> "" Then nIters = Val(Command(2))

Dim As Form frm
frm.Name = "PerfForm"
frm.Width = 1200
frm.Height = 800
frm.CreateWnd
If frm.Handle = 0 Then
	Print "FAIL: form handle"
	End 1
End If
Print "step: form"

' --- 顶层停靠结构, 模拟 IDE: 工具栏 / 左 / 右 / 底 / 客户区 ------------------
Dim As Panel pnlTop, pnlLeft, pnlRight, pnlBottom, pnlClient
pnlTop.Parent = @frm : pnlTop.Align = alTop : pnlTop.Height = 32 : pnlTop.CreateWnd
pnlLeft.Parent = @frm : pnlLeft.Align = alLeft : pnlLeft.Width = 260 : pnlLeft.CreateWnd
pnlRight.Parent = @frm : pnlRight.Align = alRight : pnlRight.Width = 260 : pnlRight.CreateWnd
pnlBottom.Parent = @frm : pnlBottom.Align = alBottom : pnlBottom.Height = 200 : pnlBottom.CreateWnd
pnlClient.Parent = @frm : pnlClient.Align = alClient : pnlClient.CreateWnd
Print "step: dock panels"

' --- 客户区里再嵌两层容器 (像 TabWindow -> TabPage) -------------------------
Dim As Panel inner1, inner2
inner1.Parent = @pnlClient : inner1.Align = alClient : inner1.CreateWnd
inner2.Parent = @inner1 : inner2.Align = alClient : inner2.CreateWnd
Print "step: inner panels"

' --- 内层容器里放 nLabels 个锚定控件 ---------------------------------------
Dim As Label labels(nLabels - 1)
For i As Integer = 0 To nLabels - 1
	With labels(i)
		.Name = "lbl" & i
		.Text = "item " & i
		.Parent = @inner2
		.Left = (i Mod 10) * 60
		.Top = (i \ 10) * 20
		.Width = 56
		.Height = 18
		.Anchor.Left = asAnchor
		.Anchor.Top = asAnchor
		.Anchor.Right = asAnchor
		.Anchor.Bottom = asAnchor
		.CreateWnd
	End With
Next i
Print "step: anchored labels"

' 侧栏里再放一些停靠控件 (左/右/底部各 20 个)
Dim As Label sideLabels(59)
For i As Integer = 0 To 59
	With sideLabels(i)
		.Name = "side" & i
		.Text = "s" & i
		If i < 20 Then
			.Parent = @pnlLeft
		ElseIf i < 40 Then
			.Parent = @pnlRight
		Else
			.Parent = @pnlBottom
		End If
		.Left = 4
		.Top = 4 + (i Mod 20) * 22
		.Width = 120
		.Height = 18
		.CreateWnd
	End With
Next i
Print "step: side labels"

frm.RequestAlign
Print "step: first align"

Print "labels=" & nLabels & " iters=" & nIters & " form controls=" & frm.ControlCount

' --- 1) RequestAlign 基准 ---------------------------------------------------
Dim As Double t0 = TimerHiRes
For i As Integer = 1 To nIters
	frm.RequestAlign
Next i
Dim As Double tAlign = (TimerHiRes - t0) * 1000 / nIters
Print "RequestAlign      : " & Str(tAlign) & " ms/call"

' --- 2) 尺寸变化 (WM_SIZE -> RequestAlign 级联) ------------------------------
t0 = TimerHiRes
For i As Integer = 1 To nIters
	SetWindowPos(frm.Handle, 0, 0, 0, 1200 + (i Mod 2) * 40, 800 + (i Mod 2) * 40, SWP_NOMOVE Or SWP_NOZORDER Or SWP_NOACTIVATE)
Next i
Dim As Double tResize = (TimerHiRes - t0) * 1000 / nIters
Print "Resize (WM_SIZE)  : " & Str(tResize) & " ms/call"

' --- 3) DPI 切换路径 (WM_DPICHANGED, 模拟跨屏) ------------------------------
'     MFF 在 WM_DPICHANGED 里对每个子控件递归 Perform(WM_DPICHANGED) 并重建字体
t0 = TimerHiRes
SendMessageW(frm.Handle, WM_DPICHANGED, (CULng(120) Or (CULng(120) Shl 16)), 0)
Dim As Double tDpi = (TimerHiRes - t0) * 1000
Print "WM_DPICHANGED     : " & Str(tDpi) & " ms (one switch)"

' --- 4) 单次 SetBounds (Move -> MoveWindow) ---------------------------------
t0 = TimerHiRes
For i As Integer = 1 To nIters
	labels(0).SetBounds(10, 10, 56 + (i Mod 2), 18)
Next i
Dim As Double tMove = (TimerHiRes - t0) * 1000 / nIters
Print "SetBounds (1 ctrl): " & Str(tMove) & " ms/call"

Print "DONE"
End 0
