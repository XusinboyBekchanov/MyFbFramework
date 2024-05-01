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
		#ifdef __USE_WINAPI__
			Dim s As SOCKET
			' not already removed?
			If (client->_socket <> NULL) Then
				's = NULL
				Swap s, client->_socket        ' this should be atomic..
				' close connection
				shutdown(s, 2)
				closesocket(s)
				' recv thread stills running?
				If (client->recvthread <> NULL) Then
					ThreadWait(client->recvthread)
				End If
				' remove from list
				If (client->next_) Then
					client->next_->prev = client->prev
				End If
				If (client->prev) Then
					client->prev->next_ = client->next_
				Else
					clientlisthead = client->next_
				End If
			End If
		#endif
	End Sub
	
	Private Function HTTPServer.Quit() As Integer
		Dim client As CLIENT Ptr
		isrunning = False
		
		#ifdef __USE_WINAPI__
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
			' shutdown winsock
			Function = WSACleanup( )
		#else
			Function = 0
		#endif
	End Function
	
	' thread waiting for data to arrive, parsing HTTP GET requests and sending responses
	Private Sub HTTPServer.Receive(ByVal client As CLIENT Ptr)
		
		Dim PacketBuffer(BuffSize) As Byte
		Dim As Integer  ReceivedLen = 0
		Dim As Byte Ptr ReceivedBuffer = 0
		Dim As String   stNL   = Chr(13) & Chr(10)
		Dim As String   stNLNL = stNL & stNL
		
		Dim FileBuffer() As Byte 'fix for fb0.16beta, thx v1ctor
		Dim SendBuffer() As Byte 'fix for fb0.16beta, thx v1ctor
		Dim FileHandle As UByte
		
		#ifdef __USE_WINAPI__
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
				ReceivedBuffer = Reallocate(ReceivedBuffer, bytes + ReceivedLen)
				Dim i As Integer
				For i = 0 To bytes - 1
					ReceivedBuffer[ReceivedLen + i] = PacketBuffer(i)
				Next i
				ReceivedLen += bytes
				'CRLF found twice ?
				Var Pos0 = InStr(.Left(*Cast(ZString Ptr, ReceivedBuffer), ReceivedLen), Chr(13, 10, 13, 10))
				If Pos0 > 0 Then
					Var Pos1 = InStr(LCase(.Left(*Cast(ZString Ptr, ReceivedBuffer), ReceivedLen)), "content-length:")
					Var Pos2 = InStr(Pos1 + 1, LCase(.Left(*Cast(ZString Ptr, ReceivedBuffer), ReceivedLen)), Chr(13))
					Dim As Integer ContentLength = Val(Mid(.Left(*Cast(ZString Ptr, ReceivedBuffer), ReceivedLen), Pos1 + 15, Pos2 - Pos1 - 15))
					If Pos0 + ContentLength + 3 <> ReceivedLen Then Continue Do
					'extract get path + url decoding (special chars are coded %XY)
					Dim As HTTPServerRequest Request
					Request.Headers = .Left(*Cast(ZString Ptr, ReceivedBuffer), Pos0 - 1)
					Request.Body = Mid(.Left(*Cast(ZString Ptr, ReceivedBuffer), ReceivedLen), Pos0 + 4)
					Dim As String stPath = Cast(HTTPServer Ptr, client->server)->HomeDir
					Dim As Integer iAcc = 0, iHex = 0
					Var Pos3 = InStr(.Left(*Cast(ZString Ptr, ReceivedBuffer), ReceivedLen), " ")
					If Pos3 > 0 Then
						Request.HTTPMethod = .Left(*Cast(ZString Ptr, ReceivedBuffer), Pos3 - 1)
					End If
					For i = Pos3 + 1 To ReceivedLen - 1
						Dim c As Byte
						c = ReceivedBuffer[i]
						If c = Asc(" ") Then Exit For
						If iHex <> 0 Then
							iHex += 1   'decode hex code
							iAcc *= 16
							iAcc += (c-48)
							If iHex = 3 Then
								c = iAcc
								iAcc = 0
								iHex = 0
							End If
						End If
						If c=Asc("%") Then 'hex code coming ?
							iHex = 1
							iAcc = 0
						End If
						If iHex = 0 Then stPath += Chr(c)
					Next i
					' tricky hack to accept parameters append to url aka page.html?title=etc
					stPath = Mid(stPath, 1, InStrRev(stPath, "?") - 1)
					If (stPath = Cast(HTTPServer Ptr, client->server)->HomeDir + "/") Or _  'default page and
						(InStr(stPath, "..") <> 0) Then 'restrict to wwwroot
						stPath = Cast(HTTPServer Ptr, client->server)->HomeDir + "/index.html"
					End If
					Request.RelativeURL = stPath
					
					' get rid of received data
					ReceivedLen = 0
					Deallocate(ReceivedBuffer)
					
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
						If Dir(stPath) = "" Then
							'Responce.Headers = "HTTP/1.1 404 Not Found" & stNL & stNL
							Responce.StatusCode = 404
							Responce.BodyFileName = ExePath + "/errors/404.html"
							Responce.Reason = "Not Found"
							stReponseHeader = "HTTP/1.1 404 Not Found" '& stNL & stNL
							stPath = ExePath + "/errors/404.html"
						End If
						FileHandle = FreeFile
						If Open( stPath For Binary Access Read Shared As #FileHandle ) <> 0 Then
							'Responce.Headers = "HTTP/1.1 403 Forbbiden" & stNL & stNL
							Responce.StatusCode = 403
							Responce.BodyFileName = ExePath + "/errors/403.html"
							Responce.Reason = "Forbbiden"
							stReponseHeader = "HTTP/1.1 403 Forbbiden" '& stNL & stNL
							stPath = ExePath + "/errors/403.html"
						Else
							FileLength = LOF(FileHandle)    'file len
							If FileLength <> 0 Then
								'ReDim FileBuffer(FileLength) As Byte
								Responce.Body = Space(FileLength)
								Get #FileHandle, , Responce.Body 'FileBuffer()
							End If
							Close #FileHandle
							'stReponseHeader = "HTTP/1.1 200 OK" & stNL
							stReponseHeader = "Cache-Control: private" & stNL
							stReponseHeader += "content-length : " & Str(FileLength) '& stNL & stNL
							Responce.Headers = stReponseHeader
							Responce.StatusCode = 200
							Responce.Reason = "OK"
						End If
					End If
					If Cast(HTTPServer Ptr, client->server)->OnReceive Then Cast(HTTPServer Ptr, client->server)->OnReceive(* (Cast(HTTPServer Ptr, client->server)->Designer), *Cast(HTTPServer Ptr, client->server), Request, Responce)
					If Responce.BodyFileName <> stPath Then
						stPath = Responce.BodyFileName
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
					ElseIf Request.HTTPMethod = "POST" Then
						FileLength = Len(Responce.Body)
					End If
					stReponseHeader = "HTTP/1.1 " & Trim(Str(Responce.StatusCode)) & " " & Responce.Reason & IIf(Responce.Headers = "", "", stNL & Responce.Headers) & stNL & stNL
					'copy response header to sendbuffer
					Dim HeaderLength As Integer
					HeaderLength = Len(stReponseHeader)
					
					Dim As Integer SendBufferLen = HeaderLength + FileLength
					'Dim As String SendBuffer = stReponseHeader & Responce.Body
					ReDim SendBuffer(SendBufferLen) As Byte
					
					'copy loop (thx v1ctor for this simplified version)
					For i = 0 To HeaderLength - 1
						SendBuffer(i) = stReponseHeader[i]
					Next i
					
					'copy response data to sendbuffer
					If FileLength <> 0 Then
						For i = 0 To FileLength - 1
							SendBuffer(i + HeaderLength) = Responce.Body[i] 'FileBuffer(i)
						Next i
					End If
					'?Len(SendBuffer), SendBufferLen
					'send response
					Dim As Byte Ptr sendptr
					sendptr = @SendBuffer(0) 'Cast(Byte Ptr, @SendBuffer)
					Do While (Cast(HTTPServer Ptr, client->server)->isrunning And (client->_socket <> NULL) And (SendBufferLen > 0))
						' loop until the whole buffer is sent
						bytes = send(client->_socket, sendptr, SendBufferLen, 0 )
						' connection closed?
						If ( bytes <= 0 ) Then
							Exit Do
						End If
						sendptr       += bytes
						SendBufferLen -= bytes
					Loop 'send loop
					
					' remove client
					' possible fix for issue with increasing handles
					ThreadDetach(client->recvthread)
					client->recvthread = NULL
					Cast(HTTPServer Ptr, client->server)->Del(client)
					
				End If 'bFound
			Loop 'receive loop
			
			' remove client
			ThreadDetach(client->recvthread)
			client->recvthread = NULL
		#endif
		
		Cast(HTTPServer Ptr, client->server)->Del(client)
	End Sub
	
	
	Private Sub HTTPServer.Accept(server As HTTPServer Ptr)
		#ifdef __USE_WINAPI__
			Dim sa As SOCKADDR_IN
			Dim s  As SOCKET
		
			Do While (server->isrunning)
				
				Dim salen As Long
				salen = Len(SOCKADDR_IN)
				s = .accept(server->_socket, CPtr(PSOCKADDR, @sa), @salen)
				If (s = INVALID_SOCKET) Then
					Exit Do
				End If
				Dim client1 As CLIENT Ptr
				
				' access global data, lock it
				MutexLock(server->globmutex)
				
				' allocate node
				client1 = Allocate(Len(CLIENT))
				
				' add to head of list
				client1->next_ = server->clientlisthead
				server->clientlisthead = client1
				If client1->next_ Then client1->next_->prev = client1
				client1->prev = NULL
				MutexUnlock(server->globmutex)
				' setup the client
				client1->_socket      = s
				client1->server       = server
				client1->ip          = (@sa)->sin_addr.s_addr
				client1->port        = (@sa)->sin_port
				' start new recv and send threads
				client1->recvthread  = ThreadCreate(Cast(Sub(ByVal As Any Ptr), @Receive), client1)
			Loop
		#endif
		
		server->isrunning = False
	End Sub
	
	
	Private Function HTTPServer.Run() As Integer
		#ifdef __USE_WINAPI__
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
			
			' create a socket for listening
			_socket = opensocket(AF_INET, SOCK_STREAM, IPPROTO_TCP)
			If (_socket = NULL) Then
				'print "error calling opensocket: "; WSAGetLastError( )
				Return False
			End If
			
			' bind it to the server port
			Dim sa As SOCKADDR_IN
			sa.sin_port         = htons(Port)
			sa.sin_family       = AF_INET
			sa.sin_addr.s_addr  = INADDR_ANY
			If (bind(_socket, CPtr(PSOCKADDR, @sa), Len(sa)) = SOCKET_ERROR) Then
				'print "error calling bind: "; WSAGetLastError( )
				Return False
			End If
			
			If (listen(_socket, SOMAXCONN) = SOCKET_ERROR) Then
				Return False
			End If
			
			clientlisthead = NULL
			isrunning = True
			globmutex = MutexCreate()
			filemutex = MutexCreate()
			acceptthread = ThreadCreate(Cast(Sub(ByVal As Any Ptr), @Accept), @This) 'launch accept thread
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
