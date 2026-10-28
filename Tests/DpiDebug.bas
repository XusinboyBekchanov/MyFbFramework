'###############################################################################
'#  DpiDebug.bas - WM_DPICHANGED 尺寸变化插桩                                  #
'###############################################################################
#ifndef UNICODE
	#define UNICODE
#endif
#include once "windows.bi"
#include once "mff/Form.bi"
#include once "mff/Panel.bi"
#include once "mff/Label.bi"

Using My.Sys.Forms

Sub Dump(ByRef s As String, frm As Form, pnl As Panel)
	Dim As RECT R
	GetWindowRect(frm.Handle, @R)
	Dim As RECT P
	GetWindowRect(pnl.Handle, @P)
	Print s
	Print "  form: xdpi=" & Str(frm.xdpi) & " ydpi=" & Str(frm.ydpi) & " L=" & Str(frm.Left) & " T=" & Str(frm.Top) & " W=" & Str(frm.Width) & " H=" & Str(frm.Height) & " physW=" & Str(R.Right - R.Left) & " physH=" & Str(R.Bottom - R.Top)
	Print "  pnl : xdpi=" & Str(pnl.xdpi) & " ydpi=" & Str(pnl.ydpi) & " L=" & Str(pnl.Left) & " T=" & Str(pnl.Top) & " W=" & Str(pnl.Width) & " H=" & Str(pnl.Height) & " physW=" & Str(P.Right - P.Left) & " physH=" & Str(P.Bottom - P.Top)
End Sub

Dim As Form frm
frm.Width = 800 : frm.Height = 600
frm.CreateWnd

Dim As Panel pnlTop, pnlClient
pnlTop.Parent = @frm : pnlTop.Align = alTop : pnlTop.Height = 30 : pnlTop.CreateWnd
pnlClient.Parent = @frm : pnlClient.Align = alClient : pnlClient.CreateWnd
frm.RequestAlign
Dump("before", frm, pnlTop)

SendMessageW(frm.Handle, WM_DPICHANGED, (CULng(120) Or (CULng(120) Shl 16)), 0)
UpdateWindow(frm.Handle)
Dump("after 120dpi", frm, pnlTop)

SendMessageW(frm.Handle, WM_DPICHANGED, (CULng(96) Or (CULng(96) Shl 16)), 0)
UpdateWindow(frm.Handle)
Dump("after 96dpi", frm, pnlTop)

End 0
