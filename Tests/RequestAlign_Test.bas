'###############################################################################
'#  RequestAlign_Test.bas                                                      #
'#  RequestAlign 批处理优化的正确性回归测试。                                   #
'#  (UTF-8 BOM; 控制台输出仅 ASCII)                                            #
'#                                                                             #
'#  验证:                                                                      #
'#   1. 停靠布局结果 (alTop/alLeft/alRight/alBottom/alClient) 正确              #
'#   2. 锚定控件在父容器缩放后位置/尺寸正确                                     #
'#   3. 嵌套 RequestAlign 的结果与逐层调用一致                                  #
'#   4. 窗口真的被重绘 (批处理不能把重绘丢掉)                                   #
'#   5. 连续两次 RequestAlign 结果相同 (幂等)                                   #
'#   6. WM_DPICHANGED 后尺寸按新比例缩放                                        #
'###############################################################################
#ifndef UNICODE
	#define UNICODE
#endif
#include once "windows.bi"
#include once "mff/Form.bi"
#include once "mff/Panel.bi"
#include once "mff/Label.bi"

Using My.Sys.Forms

Dim Shared As Integer nPassed, nFailed
Dim Shared As String sGroup

Sub Check(bOK As Boolean, ByRef sWhat As String)
	If bOK Then
		nPassed += 1
	Else
		nFailed += 1
		Print "  FAIL [" & sGroup & "] " & sWhat
	End If
End Sub

Sub CheckEq(a As Integer, b As Integer, ByRef sWhat As String)
	If a = b Then
		nPassed += 1
	Else
		nFailed += 1
		Print "  FAIL [" & sGroup & "] " & sWhat & " got=" & a & " expect=" & b
	End If
End Sub

Sub BeginGroup(ByRef s As String)
	sGroup = s
	Print "--- " & s & " ---"
End Sub

' 重绘探针: 用子类化统计 WM_PAINT 次数
Dim Shared As Integer nPaints
Dim Shared As HWND hProbe
Dim Shared As Any Ptr pOldProc

Function ProbeProc(hWnd As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
	If Msg = WM_PAINT Then nPaints += 1
	Return CallWindowProc(pOldProc, hWnd, Msg, wParam, lParam)
End Function

'==============================================================================
Dim As Form frm
frm.Name = "AlignTest"
frm.Width = 800
frm.Height = 600
frm.CreateWnd
Check(frm.Handle <> 0, "form created")

Dim As Panel pnlTop, pnlLeft, pnlRight, pnlBottom, pnlClient
pnlTop.Parent = @frm    : pnlTop.Align = alTop    : pnlTop.Height = 30 : pnlTop.CreateWnd
pnlLeft.Parent = @frm   : pnlLeft.Align = alLeft  : pnlLeft.Width = 150 : pnlLeft.CreateWnd
pnlRight.Parent = @frm  : pnlRight.Align = alRight : pnlRight.Width = 120 : pnlRight.CreateWnd
pnlBottom.Parent = @frm : pnlBottom.Align = alBottom : pnlBottom.Height = 80 : pnlBottom.CreateWnd
pnlClient.Parent = @frm : pnlClient.Align = alClient : pnlClient.CreateWnd

frm.RequestAlign
Dim As Integer cw = frm.ClientWidth, ch = frm.ClientHeight

BeginGroup("dock")
CheckEq(pnlTop.Left, 0, "top.Left")
CheckEq(pnlTop.Top, 0, "top.Top")
CheckEq(pnlTop.Width, cw, "top.Width")
CheckEq(pnlTop.Height, 30, "top.Height")

CheckEq(pnlLeft.Top, 30, "left.Top below top panel")
CheckEq(pnlLeft.Width, 150, "left.Width")
CheckEq(pnlLeft.Height, ch - 30 - 80, "left.Height between top and bottom")

CheckEq(pnlRight.Left, cw - 120, "right.Left at right edge")
CheckEq(pnlRight.Top, 30, "right.Top")
CheckEq(pnlRight.Width, 120, "right.Width")

CheckEq(pnlBottom.Top, ch - 80, "bottom.Top")
CheckEq(pnlBottom.Left, 150, "bottom.Left after left panel")
CheckEq(pnlBottom.Width, cw - 150 - 120, "bottom.Width between left and right")

CheckEq(pnlClient.Left, 150, "client.Left")
CheckEq(pnlClient.Top, 30, "client.Top")
CheckEq(pnlClient.Width, cw - 150 - 120, "client.Width")
CheckEq(pnlClient.Height, ch - 30 - 80, "client.Height")

'==============================================================================
BeginGroup("anchor")
Dim As Label lbl1, lbl2
lbl1.Parent = @pnlClient : lbl1.Left = 10 : lbl1.Top = 10 : lbl1.Width = 50 : lbl1.Height = 20
lbl1.Anchor.Right = asAnchor : lbl1.Anchor.Bottom = asAnchor
lbl1.CreateWnd
lbl2.Parent = @pnlClient : lbl2.Left = 10 : lbl2.Top = 40 : lbl2.Width = 50 : lbl2.Height = 20
lbl2.CreateWnd
frm.RequestAlign

' 放大窗体, 右/下锚定的控件跟着变, 只左/上锚定的不动
frm.Width = 1000 : frm.Height = 700
frm.RequestAlign
Dim As Integer dw = frm.ClientWidth - cw, dh = frm.ClientHeight - ch
Check(dw > 0 AndAlso dh > 0, "form really got bigger")
CheckEq(lbl1.Left, 10, "anchored label keeps Left")
CheckEq(lbl1.Top, 10, "anchored label keeps Top")
CheckEq(lbl1.Width, 50 + dw, "anchored label grows with right edge")
CheckEq(lbl1.Height, 20 + dh, "anchored label grows with bottom edge")
CheckEq(lbl2.Left, 10, "unanchored label keeps Left")
CheckEq(lbl2.Width, 50, "unanchored label keeps Width")

'==============================================================================
BeginGroup("idempotent")
Dim As Integer l1 = lbl1.Left, t1 = lbl1.Top, w1 = lbl1.Width, h1 = lbl1.Height
frm.RequestAlign
CheckEq(lbl1.Left, l1, "second pass keeps Left")
CheckEq(lbl1.Top, t1, "second pass keeps Top")
CheckEq(lbl1.Width, w1, "second pass keeps Width")
CheckEq(lbl1.Height, h1, "second pass keeps Height")
Dim As Integer l2 = lbl2.Left, w2 = lbl2.Width
frm.RequestAlign
CheckEq(lbl2.Left, l2, "third pass keeps Left")
CheckEq(lbl2.Width, w2, "third pass keeps Width")

'==============================================================================
BeginGroup("nested")
' 内层容器自己请求布局, 结果应与窗体级布局一致
pnlClient.RequestAlign
CheckEq(pnlClient.Left, 150, "nested pass keeps client.Left")
CheckEq(pnlClient.Width, frm.ClientWidth - 150 - 120, "nested pass keeps client.Width")
CheckEq(lbl1.Width, w1, "nested pass keeps anchored width")

' 子面板单独布局
pnlLeft.RequestAlign
CheckEq(pnlLeft.Width, 150, "panel self align keeps width")

'==============================================================================
BeginGroup("repaint")
' 批处理结束后必须有重绘: 移动后区域要重画
hProbe = pnlClient.Handle
pOldProc = Cast(Any Ptr, SetWindowLongPtr(hProbe, GWLP_WNDPROC, Cast(LONG_PTR, @ProbeProc)))
nPaints = 0
frm.Width = 900
frm.RequestAlign
UpdateWindow(frm.Handle)
Check(nPaints > 0, "container repainted after a layout pass (" & nPaints & ")")

' 布局没有实际变化时不该反复整树重绘
nPaints = 0
frm.RequestAlign
UpdateWindow(frm.Handle)
CheckEq(nPaints, 0, "no repaint when nothing moved")
SetWindowLongPtr(hProbe, GWLP_WNDPROC, Cast(LONG_PTR, pOldProc))

'==============================================================================
BeginGroup("dpi")
' WM_DPICHANGED: 120 dpi (125%) 后控件应按新比例放大
Dim As Integer wBefore = pnlTop.Height
SendMessageW(frm.Handle, WM_DPICHANGED, (CULng(120) Or (CULng(120) Shl 16)), 0)
UpdateWindow(frm.Handle)
CheckEq(pnlTop.Height, 30, "logical height unchanged after DPI change")
Check(CInt(pnlTop.Handle) <> 0, "control still alive after DPI change")
' 逻辑坐标不变, 物理像素变大
Dim As RECT R
GetWindowRect(pnlTop.Handle, @R)
Check((R.Bottom - R.Top) > wBefore, "physical height grew with the new scale")

' 再切回 96 dpi
SendMessageW(frm.Handle, WM_DPICHANGED, (CULng(96) Or (CULng(96) Shl 16)), 0)
UpdateWindow(frm.Handle)
GetWindowRect(pnlTop.Handle, @R)
CheckEq(CInt(R.Bottom - R.Top), wBefore, "physical height restored at 96 dpi")

'==============================================================================
BeginGroup("survives")
' 反复切换不应让重绘永久失效
nPaints = 0
hProbe = pnlClient.Handle
pOldProc = Cast(Any Ptr, SetWindowLongPtr(hProbe, GWLP_WNDPROC, Cast(LONG_PTR, @ProbeProc)))
For i As Integer = 1 To 5
	SendMessageW(frm.Handle, WM_DPICHANGED, (CULng(120) Or (CULng(120) Shl 16)), 0)
	SendMessageW(frm.Handle, WM_DPICHANGED, (CULng(96) Or (CULng(96) Shl 16)), 0)
Next i
UpdateWindow(frm.Handle)
Check(nPaints > 0, "repaint still happens after repeated DPI changes (" & nPaints & ")")
SetWindowLongPtr(hProbe, GWLP_WNDPROC, Cast(LONG_PTR, pOldProc))

Print ""
Print "============================================================"
Print " RequestAlign_Test: passed " & nPassed & ", failed " & nFailed
Print "============================================================"
If nFailed = 0 Then End 0 Else End 1
