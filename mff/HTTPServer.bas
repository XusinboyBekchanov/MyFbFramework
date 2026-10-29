' courtesy https://www.freebasic.net/forum/viewtopic.php?t=4199&hilit=Simple+Web+Server
' Simple Web Server, (c) Anselme Dewavrin 2006 - dewavrin@yahoo.com
' Feel free to use it, provided you mention my name.
' based on the example provided with freebasic tweaked by thrive4 march 2024.
' Improved by Xusinboy Bekchanov, 2024.

#include once "HTTPServer.bi"

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function HTTPServer.ReadProperty(PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "address": Return Cast(Any Ptr, StrPtr(This.Address))
			Case "homedir": Return Cast(Any Ptr, StrPtr(This.HomeDir))
			Case "port": Return Cast(Any Ptr, @This.Port)
			Case "onreceive": Return Cast(Any Ptr, This.OnReceive)
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function HTTPServer.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "address": This.Address = *Cast(ZString Ptr, Value)
			Case "homedir": This.HomeDir = *Cast(ZString Ptr, Value)
			Case "port": This.Port = QInteger(Value)
			Case "onreceive": This.OnReceive = Value
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	
	' multithreaded socket handling
	Private Sub HTTPServer.Del(ByVal client As CLIENT Ptr)
		#ifdef __MFF_HTTPSERVER_SOCKETS__
			Dim s As SOCKET
			Dim t As Any Ptr
			'Taking the socket and removing from the list are done under the lock: Quit, Accept and
			'the recv threads change the list at the same time. Without the lock two clients removed
			'at once could leave a closed client as the list head, and Quit looped on it forever
			MutexLock(globmutex)
			s = client->_socket
			client->_socket = NULL
			' not already removed?
			If (s <> NULL) Then
				' remove from list
				If (client->next_) Then
					client->next_->prev = client->prev
				End If
				If (client->prev) Then
					client->prev->next_ = client->next_
				Else
					clientlisthead = client->next_
				End If
				client->prev = NULL
				client->next_ = NULL
				'Del is called from the recv thread itself too: then the thread is already detached
				t = client->recvthread
				client->recvthread = NULL
			End If
			MutexUnlock(globmutex)
			If (s <> NULL) Then
				' close connection
				shutdown(s, 2)
				closesocket(s)
				' recv thread stills running?
				If (t <> NULL) Then
					ThreadWait(t)
				End If
			End If
		#endif
	End Sub
	
	Private Function HTTPServer.Quit() As Integer
		Dim client As CLIENT Ptr
		isrunning = False
		
		#ifdef __MFF_HTTPSERVER_SOCKETS__
			' close the listening socket
			If (_socket <> 0) Then
				shutdown(_socket, 2)
				closesocket(_socket)
				_socket = 0
			End If
			
			' remove all clients yet running
			Dim i As Integer
			Do
				client = clientlisthead
				If (client = NULL) Then
					Exit Do
				End If
				Del(client)
			Loop
			#ifdef __FB_WIN32__
				' shutdown winsock
				Function = WSACleanup( )
			#else
				Function = 0
			#endif
		#else
			Function = 0
		#endif
	End Function
	
	' thread waiting for data to arrive, parsing HTTP GET requests and sending responses
	'The Content-Type of a file by its extension (application/wasm is needed for the WebAssembly streaming compilation)
	Private Function ContentTypeOf(ByRef FileName As String) As String
		Select Case LCase(Mid(FileName, InStrRev(FileName, ".") + 1))
		Case "html", "htm": Return "text/html; charset=utf-8"
		Case "js", "mjs": Return "text/javascript; charset=utf-8"
		Case "wasm": Return "application/wasm"
		Case "css": Return "text/css; charset=utf-8"
		Case "json": Return "application/json"
		Case "txt", "bas", "bi", "ini": Return "text/plain; charset=utf-8"
		Case "png": Return "image/png"
		Case "jpg", "jpeg": Return "image/jpeg"
		Case "gif": Return "image/gif"
		Case "svg": Return "image/svg+xml"
		Case "ico": Return "image/x-icon"
		Case Else: Return "application/octet-stream"
		End Select
	End Function

	Private Sub HTTPServer.Receive(ByVal client As CLIENT Ptr)
		
		Dim PacketBuffer(BuffSize) As Byte
		'The request is collected in a String: the body of a POST can be big and have any bytes (also Chr(0))
		Dim As String   Received
		Dim As Integer  HeaderEnd, ContentLength
		Dim As String   stNL   = Chr(13) & Chr(10)
		Dim As String   stNLNL = stNL & stNL
		
		Dim FileBuffer() As Byte 'fix for fb0.16beta, thx v1ctor
		Dim SendBuffer() As Byte 'fix for fb0.16beta, thx v1ctor
		Dim FileHandle As UByte
		
		#ifdef __MFF_HTTPSERVER_SOCKETS__
			'receive loop
			Do While(Cast(HTTPServer Ptr, client->server)->isrunning And (client->_socket <> NULL))
				' block until some data
				Dim bytes As Integer
				bytes = recv(client->_socket, @PacketBuffer(0), BuffSize, 0)
				' connection closed?
				If (bytes <= 0) Then
					Exit Do
				End If
				
				' accumulate received data
				Dim As String Chunk = Space(bytes)
				Dim i As Integer
				For i = 0 To bytes - 1
					Chunk[i] = PacketBuffer(i)
				Next i
				Received &= Chunk
				'CRLF found twice: the headers are there, Content-Length is the size of the body (0 without it, a GET)
				If HeaderEnd = 0 Then
					HeaderEnd = InStr(Received, Chr(13, 10, 13, 10))
					If HeaderEnd = 0 Then Continue Do
					Dim As String LowerHeaders = LCase(.Left(Received, HeaderEnd - 1))
					Var Pos1 = InStr(LowerHeaders, "content-length:")
					If Pos1 > 0 Then
						Var Pos2 = InStr(Pos1, LowerHeaders, Chr(13))
						If Pos2 = 0 Then Pos2 = Len(LowerHeaders) + 1
						ContentLength = ValInt(Mid(LowerHeaders, Pos1 + 15, Pos2 - Pos1 - 15))
					End If
				End If
				Var Pos0 = HeaderEnd
				If Pos0 > 0 Then
					If Len(Received) < Pos0 + 3 + ContentLength Then Continue Do
					'extract get path + url decoding (special chars are coded %XY)
					Dim As HTTPServerRequest Request
					Request.Headers = .Left(Received, Pos0 - 1)
					Request.Body = Mid(Received, Pos0 + 4, ContentLength)
					'The path of the URL (after the method): HomeDir is not in it, it can have ".." itself (a folder like src/../)
					Dim As String URLPath
					Dim As Integer iAcc = 0, iHex = 0
					Var Pos3 = InStr(Received, " ")
					If Pos3 > 0 Then
						Request.HTTPMethod = .Left(Received, Pos3 - 1)
					End If
					'Pos3 (1-based) is the 0-based index of the "/" after the space
					For i = Pos3 To Pos0 - 1
						Dim c As UByte
						c = Received[i]
						If c = Asc(" ") Then Exit For
						If iHex <> 0 Then
							iHex += 1   'decode hex code (%XY: 0-9, A-F, a-f)
							iAcc *= 16
							Select Case c
							Case Asc("0") To Asc("9"): iAcc += c - Asc("0")
							Case Asc("A") To Asc("F"): iAcc += c - Asc("A") + 10
							Case Asc("a") To Asc("f"): iAcc += c - Asc("a") + 10
							End Select
							If iHex = 3 Then
								c = iAcc
								iAcc = 0
								iHex = 0
							End If
						ElseIf c = Asc("%") Then 'hex code coming ?
							iHex = 1
							iAcc = 0
						End If
						If iHex = 0 Then URLPath += Chr(c)
					Next i
					' tricky hack to accept parameters append to url aka page.html?title=etc
					If InStr(URLPath, "?") > 0 Then URLPath = Mid(URLPath, 1, InStr(URLPath, "?") - 1)
					'default page and restrict to wwwroot (only the URL can not go up with "..")
					If (URLPath = "/") OrElse (URLPath = "") OrElse (InStr(URLPath, "..") <> 0) Then URLPath = "/index.html"
					Dim As String stPath = Cast(HTTPServer Ptr, client->server)->HomeDir & URLPath
					Request.RelativeURL = stPath
					
					' get rid of received data
					Received = ""
					HeaderEnd = 0
					ContentLength = 0
					
					' prepare response
					Dim As HTTPServerResponce Responce
					Dim As String  stReponseHeader
					Dim As Integer FileLength = 0
					Print Request.HTTPMethod, stPath
					Responce.BodyFileName = stPath
					If Request.HTTPMethod = "POST" Then
						stReponseHeader = "HTTP/1.1 200 OK" '& stNL & stNL
						'Responce.Headers = stReponseHeader
						Responce.StatusCode = 200
						Responce.Reason = "OK"
					Else
						' read requested file from disk (no mutex, thanx to Zerospeed)
						'A missing file is 404 (the page errors/404.html of the program if it has one), a file which can
						'not be read is 403
						Dim As Integer ErrorCode
						'The requests are received in parallel threads (a page loads its pictures at the same time): Dir and
						'FreeFile...Open are not thread-safe, without the lock a file is sometimes not found (404) or not opened (403)
						MutexLock(Cast(HTTPServer Ptr, client->server)->filemutex)
						If Dir(stPath) = "" Then
							ErrorCode = 404
						Else
							FileHandle = FreeFile
							If Open( stPath For Binary Access Read Shared As #FileHandle ) <> 0 Then ErrorCode = 403
						End If
						If ErrorCode <> 0 Then
							Responce.StatusCode = ErrorCode
							Responce.Reason = IIf(ErrorCode = 404, "Not Found", "Forbidden")
							Dim As String ErrorPage = ExePath + "/errors/" & ErrorCode & ".html"
							FileHandle = FreeFile
							If Dir(ErrorPage) <> "" AndAlso Open(ErrorPage For Binary Access Read Shared As #FileHandle) = 0 Then
								Responce.Body = Space(LOF(FileHandle))
								If Len(Responce.Body) Then Get #FileHandle, , Responce.Body
								Close #FileHandle
								stReponseHeader = "Content-Type: text/html; charset=utf-8"
							Else
								Responce.Body = ErrorCode & " " & Responce.Reason & ": " & URLPath
								stReponseHeader = "Content-Type: text/plain; charset=utf-8"
							End If
							FileLength = Len(Responce.Body)
							Responce.Headers = stReponseHeader & stNL & "Content-Length: " & FileLength & stNL & "Connection: close"
							Responce.BodyFileName = stPath
						Else
							FileLength = LOF(FileHandle)    'file len
							If FileLength <> 0 Then
								'ReDim FileBuffer(FileLength) As Byte
								Responce.Body = Space(FileLength)
								Get #FileHandle, , Responce.Body 'FileBuffer()
							End If
							Close #FileHandle
							'stReponseHeader = "HTTP/1.1 200 OK" & stNL
							'no-cache: a rebuilt page (the .js, .wasm and .data of a WebAssembly program) is loaded again
							stReponseHeader = "Cache-Control: no-cache" & stNL
							stReponseHeader += "Content-Type: " & ContentTypeOf(stPath) & stNL
							stReponseHeader += "Content-Length: " & Str(FileLength) & stNL
							stReponseHeader += "Connection: close"
							Responce.Headers = stReponseHeader
							Responce.StatusCode = 200
							Responce.Reason = "OK"
						End If
						MutexUnlock(Cast(HTTPServer Ptr, client->server)->filemutex)
					End If
					If Cast(HTTPServer Ptr, client->server)->OnReceive Then Cast(HTTPServer Ptr, client->server)->OnReceive(* (Cast(HTTPServer Ptr, client->server)->Designer), *Cast(HTTPServer Ptr, client->server), Request, Responce)
					If Responce.BodyFileName <> stPath Then
						stPath = Responce.BodyFileName
						MutexLock(Cast(HTTPServer Ptr, client->server)->filemutex)
						FileHandle = FreeFile
						If Open( stPath For Binary Access Read Shared As #FileHandle ) <> 0 Then
							'Responce.Headers = "HTTP/1.1 403 Forbbiden" & stNL & stNL
							Responce.StatusCode = 403
							Responce.BodyFileName = ExePath + "/errors/403.html"
							Responce.Reason = "Forbbiden"
						Else
							FileLength = LOF(FileHandle)    'file len
							If FileLength <> 0 Then
								'ReDim FileBuffer(FileLength) As Byte
								Get #FileHandle, , Responce.Body 'FileBuffer()
							End If
							Close #FileHandle
						End If
						MutexUnlock(Cast(HTTPServer Ptr, client->server)->filemutex)
					ElseIf Request.HTTPMethod = "POST" Then
						FileLength = Len(Responce.Body)
					End If
					If Responce.Headers = "" Then
						stReponseHeader = "HTTP/1.1 " & Trim(Str(Responce.StatusCode)) & " " & Responce.Reason & stNL & stNL
					Else
						stReponseHeader = "HTTP/1.1 " & Trim(Str(Responce.StatusCode)) & " " & Responce.Reason & stNL & Responce.Headers & stNL & stNL
					End If
					'the response header and the data in one buffer (a big file, like a .wasm, is not copied byte by byte)
					Dim As String SendData = stReponseHeader & .Left(Responce.Body, FileLength)
					Dim As Integer SendBufferLen = Len(SendData)
					'send response
					Dim As Byte Ptr sendptr
					sendptr = Cast(Byte Ptr, StrPtr(SendData))
					Do While (Cast(HTTPServer Ptr, client->server)->isrunning And (client->_socket <> NULL) And (SendBufferLen > 0))
						' loop until the whole buffer is sent
						bytes = send(client->_socket, sendptr, SendBufferLen, HTTPServerSendFlags)
						' connection closed?
						If ( bytes <= 0 ) Then
							Exit Do
						End If
						sendptr       += bytes
						SendBufferLen -= bytes
					Loop 'send loop
					
					' remove client
					' possible fix for issue with increasing handles
					'Under the lock: Quit (Del) may take the thread at the same time to wait for it
					Dim As Any Ptr DetachThread
					MutexLock(Cast(HTTPServer Ptr, client->server)->globmutex)
					DetachThread = client->recvthread
					client->recvthread = NULL
					MutexUnlock(Cast(HTTPServer Ptr, client->server)->globmutex)
					If DetachThread <> NULL Then ThreadDetach(DetachThread)
					Cast(HTTPServer Ptr, client->server)->Del(client)
					
				End If 'bFound
			Loop 'receive loop
			
			' remove client
			Dim As Any Ptr OwnThread
			MutexLock(Cast(HTTPServer Ptr, client->server)->globmutex)
			OwnThread = client->recvthread
			client->recvthread = NULL
			MutexUnlock(Cast(HTTPServer Ptr, client->server)->globmutex)
			If OwnThread <> NULL Then ThreadDetach(OwnThread)
		#endif
		
		Cast(HTTPServer Ptr, client->server)->Del(client)
	End Sub
	
	
	Private Sub HTTPServer.Accept(server As HTTPServer Ptr)
		#ifdef __MFF_HTTPSERVER_SOCKETS__
			Dim sa As SOCKADDR_IN
			Dim s  As SOCKET
		
			Do While (server->isrunning)
				
				#ifdef __FB_WIN32__
					Dim salen As Long
				#else
					Dim salen As socklen_t
				#endif
				salen = Len(SOCKADDR_IN)
				s = .accept(server->_socket, CPtr(PSOCKADDR, @sa), @salen)
				If (s = INVALID_SOCKET) Then
					Exit Do
				End If
				#ifdef __FB_WIN32__
					'A request which runs a compilation: its programs do not get the connection (like the socket of Run)
					SetHandleInformation(Cast(Any Ptr, s), HANDLE_FLAG_INHERIT, 0)
				#endif
				Dim client1 As CLIENT Ptr
				
				' access global data, lock it
				MutexLock(server->globmutex)
				
				' allocate node
				client1 = _Allocate(Len(CLIENT))

				' setup the client before it is in the list (Quit may read it at once)
				client1->_socket      = s
				client1->server       = server
				client1->ip          = (@sa)->sin_addr.s_addr
				client1->port        = (@sa)->sin_port
				' add to head of list
				client1->next_ = server->clientlisthead
				server->clientlisthead = client1
				If client1->next_ Then client1->next_->prev = client1
				client1->prev = NULL
				' start new recv and send threads (still under the lock: the thread reads recvthread under it)
				client1->recvthread  = ThreadCreate(Cast(Sub(ByVal As Any Ptr), @Receive), client1)
				MutexUnlock(server->globmutex)
			Loop
		#endif
		
		server->isrunning = False
	End Sub
	
	
	Private Function HTTPServer.Run() As Integer
		#ifdef __MFF_HTTPSERVER_SOCKETS__
			#ifdef __FB_WIN32__
				' start winsock
				Dim wsaData As WSADATA
				If (WSAStartup(MAKEWORD(2, 0), @wsaData) <> 0) Then
					'print "error calling WSAStartup: "; WSAGetLastError( )
					Return False
				End If

				If (wsaData.wVersion <> MAKEWORD(2, 0)) Then
					WSACleanup()
					Return False
				End If
			#endif

			' create a socket for listening
			_socket = opensocket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
			If (_socket = INVALID_SOCKET) Then
				'print "error calling opensocket: "; WSAGetLastError( )
				_socket = 0
				Return False
			End If
			#ifdef __FB_WIN32__
				'The programs which the program starts do not get the socket: a long-lived one (the daemon of Gradle of a
				'compilation) would keep the port after the program ended and take its connections
				SetHandleInformation(Cast(Any Ptr, _socket), HANDLE_FLAG_INHERIT, 0)
			#else
				'The port can be listened to again at once after the program ended (without it: about a minute later)
				Dim As Long ReuseAddress = 1
				setsockopt(_socket, SOL_SOCKET, SO_REUSEADDR, @ReuseAddress, SizeOf(ReuseAddress))
			#endif
			
			' bind it to the server port
			Dim sa As SOCKADDR_IN
			sa.sin_port         = htons(Port)
			sa.sin_family       = AF_INET
			'Address: 127.0.0.1 (the default) - only this computer can connect, "" or 0.0.0.0 - every network interface
			sa.sin_addr.s_addr  = IIf(Address = "" OrElse Address = "0.0.0.0", INADDR_ANY, inet_addr(Address))
			'The port is used by another program: the socket is closed, Run can be called again
			If (bind(_socket, CPtr(PSOCKADDR, @sa), Len(sa)) = SOCKET_ERROR) OrElse (listen(_socket, SOMAXCONN) = SOCKET_ERROR) Then
				'print "error calling bind: "; WSAGetLastError( )
				closesocket(_socket)
				_socket = 0
				Return False
			End If
			
			clientlisthead = NULL
			isrunning = True
			globmutex = MutexCreate()
			filemutex = MutexCreate()
			acceptthread = ThreadCreate(Cast(Sub(ByVal As Any Ptr), @Accept), @This) 'launch accept thread
		#else
			Return False
		#endif
		Function = True
	End Function
	
	Constructor HTTPServer
		WLet(FClassName, "HTTPServer")
	End Constructor
	
	Destructor HTTPServer
		If isrunning Then
			Quit
		End If
	End Destructor
End Namespace
