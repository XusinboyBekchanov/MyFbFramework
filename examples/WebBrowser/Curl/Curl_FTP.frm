'################################################################################
'#  Curl_FTP.frm                                                              #
'#  This file is an examples of MyFBFramework.                                  #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'################################################################################

'Please copy the three files (libcurl.dll, libcurl-x64.dll, curl-ca-bundle.crt)
'from "VisualFBEditor\Controls\MyFbFramework\Lib\" to the current execution file directory.


'#Region "Form"
	#if defined(__FB_MAIN__) AndAlso Not defined(__MAIN_FILE__)
		#define __MAIN_FILE__
		#ifdef __FB_WIN32__
			'#cmdline "-static"
		#endif
		Const _MAIN_FILE_ = __FILE__
	#endif
	#include once "mff/Form.bi"
	#include once "mff/TextBox.bi"
	#include once "mff/ComboBoxEdit.bi"
	#include once "mff/CommandButton.bi"
	#include once "mff/Label.bi"
	#include once "mff/RichTextBox.bi"
	#include once "curl.bi"
	
	Using My.Sys.Forms
	
	Type Form1Type Extends Form
		Declare Sub cmdRun_Click(ByRef Sender As Control)
		Declare Function Read_Callback cdecl (ByVal buffer As UByte Ptr, ByVal size As Integer, ByVal nitems As Integer, ByVal userdata As Any Ptr) As Integer
		Declare Sub Send_File(ByRef filename As WString)
		Declare Constructor
		
		Dim As RichTextBox RtfReceive
		Dim As ComboBoxEdit cboURL
		Dim As CommandButton cmdRun
		Dim As Label Label1
	End Type
	
	Constructor Form1Type
		#if _MAIN_FILE_ = __FILE__
			With App
				.CurLanguagePath = ExePath & "/Languages/"
				.CurLanguage = .Language
				Print "CurLanguage=" & .CurLanguage
			End With
		#endif
		' Form1
		With This
			.Name = "Form1"
			.Text = "Form1"
			.Designer = @This
			.SetBounds 0, 0, 360, 300
		End With
		' RtfReceive
		With RtfReceive
			.Name = "RtfReceive"
			.Text = ML("Waiting...")
			.TabIndex = 0
			.Anchor.Right = AnchorStyle.asAnchor
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Bottom = AnchorStyle.asAnchor
			.WordWraps = True
			.ID = 1016
			.Multiline = True
			.ScrollBars = ScrollBarsType.Both
			.SetBounds 10, 30, 330, 230
			.Designer = @This
			.Parent = @This
		End With
		' cboURL
		With cboURL
			.Name = "cboURL"
			.AddItem "ftp://ftp.secureftp-test.com/"
			.AddItem "ftp.gnu.org"
			.Text = "ftp://ftp.secureftp-test.com/"
			.Anchor.Right = AnchorStyle.asAnchor
			.Anchor.Left = AnchorStyle.asAnchor
			.Anchor.Top = AnchorStyle.asAnchor
			.Anchor.Bottom = AnchorStyle.asAnchor
			.Style = cbDropDown
			.TabIndex = 1
			.SetBounds 50, 10, 260, 16
			.Designer = @This
			.Parent = @This
		End With
		' cmdRun
		With cmdRun
			.Name = "cmdRun"
			.Text = "Run"
			.TabIndex = 2
			.Caption = "Run"
			.DoubleBuffered = True
			.Anchor.Right = AnchorStyle.asAnchor
			.SetBounds 310, 10, 30, 20
			.Designer = @This
			.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @cmdRun_Click)
			.Parent = @This
		End With
		' Label1
		With Label1
			.Name = "Label1"
			.Text = "URL："
			.TabIndex = 3
			.SetBounds 10, 10, 40, 20
			.Designer = @This
			.Parent = @This
		End With
	End Constructor
	
	Dim Shared Form1 As Form1Type
	
	#if _MAIN_FILE_ = __FILE__
		App.DarkMode = True
		Form1.MainForm = True
		Form1.Show
		App.Run
	#endif
'#End Region

'https://www.freebasic.net/forum/viewtopic.php?p=186333&hilit=curl_easy_setopt#p186333
'' Callback that libcurl will use to get the bytes to send from us
Private Function Form1Type.Read_Callback cdecl (ByVal buffer As UByte Ptr, ByVal size As Integer, ByVal nitems As Integer, ByVal userdata As Any Ptr) As Integer
	
	Dim As Integer bytestoread, bytesread, filenum
	
	'' Write some bytes to libcurl's buffer,
	'' but never more than size*nitems.
	'' Ideally we should write exactly size*nitems bytes everytime.
	RtfReceive.Text = RtfReceive.Text & Chr(13, 10) & "read_callback(): libcurl requested " & size & " * " & nitems & " = " & bytesread & " bytes"
	bytestoread = size * nitems
	
	'' We've passed the file number to CURLOPT_READDATA, let's use it
	filenum = CInt( userdata )
	
	'' Read some bytes from the file into libcurl's buffer
	If ( Get( #filenum, , *buffer, bytestoread, bytesread ) <> 0 ) Then
		RtfReceive.Text = RtfReceive.Text & Chr(13,10) & "read_callback(): file input error"
	End If
	
	'' Returning the amount of bytes that were written into libcurl's buffer
	RtfReceive.Text = RtfReceive.Text & Chr(13,10) & "read_callback(): read " & bytesread & " bytes"
	Function = bytesread
End Function

Sub Form1Type.Send_File(ByRef filename As WString)
	RtfReceive.Text = RtfReceive.Text & Chr(13,10) & "trying to upload file '" & filename & "'..."
	
	Dim As Integer filenum = FreeFile( )
	If ( Open( filename, For Binary, Access Read, As #filenum ) <> 0 ) Then
		RtfReceive.Text = RtfReceive.Text & Chr(13,10) & "could not open file '" & filename & "'"
		Exit Sub
	End If
	
	'' Create a new curl easy handle
	Dim As CURL Ptr curl = curl_easy_init( )
	If ( curl = 0 ) Then
		RtfReceive.Text = RtfReceive.Text & Chr(13,10) & "curl_easy_init() failed"
		Close #filenum
		Exit Sub
	End If
	
	filename = "foo.txt"
	
	'' Debug output for testing
	curl_easy_setopt( curl, CURLOPT_VERBOSE, 1 )
	
	'' We want to upload
	curl_easy_setopt( curl, CURLOPT_UPLOAD, 1 )
	
	'' Callback that libcurl will use to get the bytes it should send
	curl_easy_setopt( curl, CURLOPT_READFUNCTION, @Read_Callback )
	
	'' User-data libcurl will pass to the read callback
	curl_easy_setopt( curl, CURLOPT_READDATA, CPtr( Any Ptr, filenum ) )
	
	'' To this URL
	Dim As ZString * 255 sURL = "ftp://ftp.secureftp-test.com/" + filename
	curl_easy_setopt( curl, CURLOPT_URL, @sURL )
	
	'' File size in bytes
	curl_easy_setopt( curl, CURLOPT_INFILESIZE_LARGE, Cast( curl_off_t, LOF( filenum ) ) )
	
	'' Hard-coded username/password for testing
	curl_easy_setopt( curl, CURLOPT_USERPWD, "test:test" )
	
	'' Do it now
	RtfReceive.Text = RtfReceive.Text & Chr(13,10) & "curl_easy_perform()..."
	Dim As Integer e = curl_easy_perform( curl )
	If ( e = 0 ) Then
		RtfReceive.Text = RtfReceive.Text & Chr(13,10) & "upload ok"
	Else
		RtfReceive.Text = RtfReceive.Text & Chr(13,10) & "error " & e & ": " & *curl_easy_strerror( e )
	End If
	
	'' end
	curl_easy_cleanup( curl )
	Close #filenum
End Sub


Private Sub Form1Type.cmdRun_Click(ByRef Sender As Control)
	
	If ( curl_global_init( CURL_GLOBAL_ALL ) <> 0 ) Then
		RtfReceive.Text = RtfReceive.Text & Chr(13, 10) & "curl_global_init() failed"
	End If
	RtfReceive.Text = RtfReceive.Text & Chr(13, 10) & "Send_File " & __FILE__ 
	''send_file( "test.txt" )
	Send_File( __FILE__ )
	
	curl_global_cleanup( )
End Sub
