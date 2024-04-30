'################################################################################
'#  frmWinSock.frm                                                              #
'#  This file is an examples of MyFBFramework                                   #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'################################################################################

#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
	#define __MAIN_FILE__
	#ifdef __FB_WIN32__
		#cmdline "Form1.rc"
		#ifdef __FB_64BIT__
			'#cmdline "-gen gas64"
		#endif
	#endif
	Const _MAIN_FILE_ = __FILE__
#endif

#ifndef __USE_GTK__
	'#Compile -exx "frmWinsockType.rc"
#else
	#define __USE_GTK3__
	#define _NOT_AUTORUN_FORMS_
#endif

#include once "mff/Form.bi"
#include once "vbcompat.bi"
#include once "mff/CommandButton.bi"
#include once "mff/TextBox.bi"
#include once "mff/CommandButton.bi"
#include once "mff/ComboBoxEdit.bi"
#include once "mff/Clipboard.bi"
#include once "mff/TimerComponent.bi"
#include once "mff/Dialogs.bi"
#include once "mff/Label.bi"

#ifdef __FB_WIN32__
	#include once "win/wininet.bi"
#else
	#include once "crt/netdb.bi"
	#include once "crt/sys/socket.bi"
	#include once "crt/netinet/in.bi"
	#include once "crt/arpa/inet.bi"
	#include once "crt/unistd.bi"
#endif

#ifndef recvbufflen
	#define RECVBUFFLEN 16384
#endif
#ifndef newline
	#define newline Chr(13,10)
#endif
Dim Shared As Double mHTTPGetTimeStart

Using My.Sys.Forms

'#Region "Form"
	Type frmWinsockType Extends Form
		Declare Sub cmdStart_Click(ByRef Sender As Control)
		Declare Sub TimerMonitorEdge_Timer(ByRef Sender As TimerComponent)
		Declare Sub Form_Close(ByRef Sender As Form, ByRef Action As Integer)
		Declare Sub Form_Show(ByRef Sender As Form)
		Declare Constructor
		
		Dim As TextBox txtContent
		Dim As CommandButton cmdStart
		Dim As TimerComponent TimerMonitorEdge
		Dim As ComboBoxEdit cboURL
		Dim As FolderBrowserDialog BrowsD
	End Type
	
	Constructor frmWinsockType
		
		' frmWinsock
		With This
			.Name = "frmWinsock"
			.Text = "frmWinsock"
			.Designer = @This
			.FormStyle = FormStyles.fsStayOnTop
			.OnClose = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Form, ByRef Action As Integer), @Form_Close)
			.OnShow = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Form), @Form_Show)
			.SetBounds 0, 0, 698, 420
		End With
		' txtContent
		With txtContent
			.Name = "txtContent"
			.Text = ML("Waiting......")
			.ID = 1009
			.TabIndex = 1
			.SetBounds 4, 31, 671, 349
			.Multiline  = True
			.WordWraps = True
			.Anchor.Right = AnchorStyle.asAnchor
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Bottom = AnchorStyle.asAnchor
			.ScrollBars = ScrollBarsType.Vertical
			.Designer = @This
			.Parent = @This
		End With
		' cmdStart
		With cmdStart
			.Name = "cmdStart"
			.Text = ML("Start")
			.SetBounds 588, 3, 76, 24
			.Anchor.Right = AnchorStyle.asAnchor
			.TabIndex = 2
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdStart_Click)
			.Parent = @This
		End With
		
		' TimerMonitorEdge
		With TimerMonitorEdge
			.Name = "TimerMonitorEdge"
			.Interval = 100
			.SetBounds 555, 3, 16, 16
			.Designer = @This
			.OnTimer = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent), @TimerMonitorEdge_Timer)
			.Parent = @This
		End With
		' cboURL
		With cboURL
			.Name = "cboURL"
			.Text = "https://www.freebasic.net/forum/index.php"
			.Hint = "Hello freebasic."
			.Style = cbDropDown
			.Align = DockStyle.alNone
			.ExtraMargins.Right = 10
			.ExtraMargins.Left = 10
			.ExtraMargins.Top = 10
			.ExtraMargins.Bottom = 10
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Right = AnchorStyle.asAnchor
			.TabIndex = 3
			.SetBounds 14, 10, 562, 15
			.Designer = @This
			.Parent = @This
		End With
		
		' BrowsD
		With BrowsD
			.Name = "BrowsD"
			.SetBounds 539, 0, 16, 16
			.Designer = @This
			.Parent = @This
		End With
	End Constructor
	
	Dim Shared frmWinsock As frmWinsockType
	#if _MAIN_FILE_ = __FILE__
		App.DarkMode = True
		frmWinsock.MainForm = True
		frmWinsock.Show
		App.Run
	#endif
'#End Region


Function TimeIntervalSince1970(ByVal tDate As Double,ByVal timeZoneDiffrence As Integer =0 ) As Long
	Return (Now()-DateSerial(1970,1,1))*86400 -timeZoneDiffrence*3600
End Function


Sub InitWinsock Constructor
	#ifdef __FB_WIN32__
		'' init winsock
		Dim wsaData As WSADATA
		If ( WSAStartup( MAKEWORD( 1, 1 ), @wsaData ) <> 0 ) Then
			Print "Error: WSAStartup failed"
			End 1
		End If
	#endif
End Sub

Sub ExitWinsock Destructor
	#ifdef __FB_WIN32__
		WSACleanup
	#endif
End Sub
'分离成域名与路径
'网络调用里使用，因为多要把 URL 分成：域名或者IP地址与页面路径使用
Sub URL_RemoveDomain(ByVal URL As String, ByRef domain As String, ByRef path As String, ByRef port As Integer) '分离成域名与路径
	'ByRef 域名 as String ,ByRef 路径 as String ,ByRef 端口
	Dim As String  tob,ltob
	Dim As Long  aa,bb
	tob = Trim(URL)
	ltob = LCase(tob)
	If Left(ltob, 7) = "http://" Then '去除
		tob = Mid(tob, 8)
		port = 80
		bb = 1
	ElseIf Left(ltob, 8) = "https://" Then
		tob = Mid(tob, 9)
		port = 443
		bb = 1
	Else
		If port = 0 Then port = 80
		bb = 0
	End If
	If bb = 1 Or Len(domain) = 0 Then  '带域名或 没有原域名
		'分离域名
		aa = InStr(tob, "/")
		If aa = 0 Then
			domain = Trim(tob)
			path = ""
		Else
			domain = Trim(Left(tob, aa -1))
			path = Trim(Mid(tob, aa + 1))
		End If
	Else   ' "HTTP/1.0 30" '转向 ，就用原域名
		tob = Trim(tob)
		If Left(tob, 1) = "/" Then
			path = Mid(tob, 2)
		Else
			path = tob
		End If
	End If
	
End Sub


Function Http_Get(ByVal URL As String, ByVal ref As String = "", ByVal user As String = "", ByVal pwd As String = "") As String
	Dim G_HTTP_Agent As ZString * MAX_PATH = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)"
	Dim G_HTTP_Head As ZString * 4096
	Dim G_HTTP_Accept As ZString * MAX_PATH = !"*/*"
	Dim G_HTTP_Ver As ZString * 32 = "HTTP/1.1"
	Dim G_HTTP_Block As UInteger = 4096
	Dim Prot As INTERNET_PORT
	Dim i As Long
	Dim As String sout,host,path
	URL_RemoveDomain URL, host, path, 0
	i = InStr(host, ":")
	If i > 0 Then  '指定了端口
		Prot = ValInt(Right(host, Len(host) - i))
		host = Left(host, i -1)
	Else
		Prot = INTERNET_DEFAULT_HTTP_PORT
	End If
	
	host &= Chr(0)
	path &= Chr(0)
	ref &= Chr(0)
	user &= Chr(0)
	pwd &= Chr(0)
	
	'DeleteUrlCacheEntry(StrPtr(URL))
	Dim  hInet As HWND = InternetOpenA(@G_HTTP_Agent, INTERNET_OPEN_TYPE_DIRECT, NULL, NULL, 0)
	If hInet Then
		Dim hConn As HWND = InternetConnectA(hInet, StrPtr(host), Prot, StrPtr(user), StrPtr(pwd), INTERNET_SERVICE_HTTP, 0, 0)
		If hConn Then
			Dim hRequ As HWND = HttpOpenRequestA(hConn, "GET", StrPtr(path), @G_HTTP_Ver, StrPtr(ref), Cast(LPCSTR Ptr, @G_HTTP_Accept), INTERNET_FLAG_CACHE_IF_NET_FAIL, 0)
			If hRequ Then
				Dim bRequ As Integer = HttpSendRequestA(hRequ, @G_HTTP_Head, -1, NULL, 0)
				If bRequ Then
					Dim tstr As String
					Dim bRead As Long
					tstr = String(G_HTTP_Block, 0)
					While InternetReadFile(hRequ, StrPtr(tstr), G_HTTP_Block, @bRead) AndAlso (bRead > 0)
						sout &= Left(tstr, bRead)
					Wend
					InternetCloseHandle hRequ
				End If
				InternetCloseHandle hRequ
			End If
			InternetCloseHandle hConn
		End If
		InternetCloseHandle(hInet)
	End If
	Return sout
End Function

Function StringExtractHTML(ByRef wszMainStr As WString, ByRef wszDelim1 As Const WString, ByRef wszDelim2 As Const WString, ByVal nStart As Long = 1, ByRef RemoveChar As WString = Chr(9) & Chr(13) & Chr(10) & " ", ByVal MatchCase As Boolean = True) ByRef As WString
	Dim As Long nLen = Len(wszMainStr), nPos1, nPos2
	If (nStart = 0) OrElse (nStart > nLen) Then Return wszMainStr
	If nStart < 0 Then nStart = nLen + nStart + 1
	If MatchCase Then
		nPos1= InStr(nStart, wszMainStr, wszDelim1)
	Else
		nPos1= InStr(nStart, UCase(wszMainStr), UCase(wszDelim1))
	End If
	If nPos1 = 0 Then InStr(nPos1, wszMainStr, "<!--")
	If nPos1 = 0 Then InStr(nPos1, wszMainStr, "-->")
	nPos1 += Len(wszDelim1)
	If MatchCase Then
		nPos2 = InStr(nPos1, wszMainStr, wszDelim2)
	Else
		nPos2 = InStr(nPos1, UCase(wszMainStr), UCase(wszDelim2))
	End If
	If nPos2 = 0 Then InStr(nPos1, wszMainStr, Space(10))
	If nPos2 = 0 Then InStr(nPos1, wszMainStr, "<div id=""goog-gt-tt")'<!-- end --><div id="goog-gt-tt"
	If nPos2 = 0 Then nPos2 =Len(wszMainStr)
	nLen = nPos2 - nPos1
	Dim As WString Ptr mTmpString
	WLet mTmpString, Mid(wszMainStr, nPos1, nLen)
	If Len(RemoveChar)>0 Then *mTmpString = Trim(*mTmpString, Any !"\t\n\r ")
	Function = *mTmpString
	Deallocate mTmpString
End Function

Private Sub frmWinsockType.Form_Close(ByRef Sender As Form, ByRef Action As Integer)
	'If mTmpString Then Deallocate mTmpString
End Sub


Private Sub frmWinsockType.Form_Show(ByRef Sender As Form)
	If Dir(ExePath & "\PlayList.txt") <> "" Then
		cboURL.LoadFromFile(ExePath & "\PlayList.txt")
		cboURL.ItemIndex = cboURL.ItemCount - 1
	End If
End Sub

Private Sub frmWinsockType.cmdStart_Click(ByRef Sender As Control)
	TimerMonitorEdge.Enabled = True
	txtContent.Text = FromUtf8(Http_Get(cboURL.Text))
	This.Caption = Mid(This.Caption, 1, Len(" VisualFBEditor WinSockt "))
End Sub


Private Sub frmWinsockType.TimerMonitorEdge_Timer(ByRef Sender As TimerComponent)
	
End Sub
