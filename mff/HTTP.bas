#include once "HTTP.bi"
#ifdef __USE_WINAPI__
	#include once "win/wininet.bi"
#endif

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function HTTPConnection.ReadProperty(PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "host": Return Cast(Any Ptr, StrPtr(This.Host))
			Case "port": Return Cast(Any Ptr, @This.Port)
			Case "timeout" : Return Cast(Any Ptr, @This.Timeout)
			Case "abort" : Return @FAbort
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function HTTPConnection.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "host": This.Host = *Cast(ZString Ptr, Value)
			Case "port": This.Port = QInteger(Value)
			Case "timeout" : This.Timeout = QInteger(Value)
			Case "abort" : This.Abort = QBoolean(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	Private Property HTTPConnection.Abort As Boolean
		Return FAbort
	End Property
	
	Private Property HTTPConnection.Abort(Value As Boolean)
		FAbort = Value
	End Property
	
	Private Sub HTTPConnection.CallMethod(HTTPMethod As String, ByRef Request As HTTPRequest, ByRef Responce As HTTPResponce)
		FAbort = False
		#ifdef __USE_WASM__
			Dim ptr_ As ZString Ptr = SendHTTPRequest("http" & IIf(Port = 80, "", "s") & "://" & Host & ":" & IIf(Port = 80 OrElse Port = 443, "", Trim(Str(Port))) & "/" & Request.ResourceAddress, HTTPMethod, Request.Body)
			Var Pos1 = InStr(*ptr_, ":")
			If Pos1 > 0 Then
				Responce.StatusCode = Val(.Left(*ptr_, Pos1 - 1))
				Responce.Body = Mid(*ptr_, Pos1 + 1)
			Else
				Responce.Body = *ptr_
			End If
			FreePtr(ptr_)
		#elseif defined(__USE_WINAPI__)
			Dim As HINTERNET hSession, hConnect, hRequest
			Dim As Boolean hSendRequest
			Dim As String result
			
			hSession = InternetOpen("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36", INTERNET_OPEN_TYPE_DIRECT, "", "", 0)
			If hSession = 0 Then
				Responce.StatusCode= 405
				Responce.Body = "{""Error"":{""Message"":""FAILED To Open Internet session"",""code"":405}}"
				If OnReceive Then OnReceive(*Designer, This, Request, Responce.Body)
				If OnComplete Then OnComplete(*Designer, This, Request, Responce)
				Return
			End If
			'CONNECT_TIMEOUT
			InternetSetOption(hSession, INTERNET_OPTION_CONNECT_TIMEOUT, @Timeout, SizeOf(Timeout))
			' RECEIVE_TIMEOUT
			InternetSetOption(hSession, INTERNET_OPTION_RECEIVE_TIMEOUT, @Timeout, SizeOf(Timeout))
			' SEND_TIMEOUT
			InternetSetOption(hSession, INTERNET_OPTION_SEND_TIMEOUT, @Timeout, SizeOf(Timeout))
			
			'hConnect = InternetOpenUrl(hSession, "http" & IIf(Port = 80, "", "s") & "://" & Host & IIf(Port = 80 OrElse Port = 443, "", ":" & Trim(Str(Port))), "", 0, INTERNET_FLAG_RELOAD, 0)
			hConnect = InternetConnect(hSession, Host, IIf(Port = 80, INTERNET_DEFAULT_HTTP_PORT, INTERNET_DEFAULT_HTTPS_PORT), NULL, NULL, INTERNET_SERVICE_HTTP, 0, 0)
			If hConnect = 0 Then
				Responce.StatusCode= 406
				Responce.Body = "{""error"":{""message"":""Failed to open URL"",""code"":406}}"
				If OnReceive Then OnReceive(*Designer, This, Request, Responce.Body)
				If OnComplete Then OnComplete(*Designer, This, Request, Responce)
				InternetCloseHandle(hSession)
				Return
			End If
			
			hRequest = HttpOpenRequest(hConnect, HTTPMethod, "/" & Request.ResourceAddress, NULL, NULL, NULL, IIf(Port = 80, INTERNET_FLAG_RELOAD Or INTERNET_FLAG_NO_CACHE_WRITE, INTERNET_FLAG_SECURE Or INTERNET_FLAG_RELOAD Or INTERNET_FLAG_NO_CACHE_WRITE), 0)
			If hRequest = 0 Then
				Responce.StatusCode= 407
				Responce.Body = "{""error"":{""message"":""Failed to open request"",""code"":407}}"
				If OnReceive Then OnReceive(*Designer, This, Request, Responce.Body)
				If OnComplete Then OnComplete(*Designer, This, Request, Responce)
				InternetCloseHandle(hConnect)
				InternetCloseHandle(hSession)
				Return
			End If
			
			' Send request with retry logic
			Dim retryCount As Integer = 0
			Do While retryCount < 3
				hSendRequest = HttpSendRequest(hRequest, Request.Headers, Len(Request.Headers), Cast(LPVOID, StrPtr(Request.Body)), Len(Request.Body))
				If hSendRequest Then Exit Do
				retryCount += 1
				Sleep(1000)
			Loop
			
			If retryCount >= 3 Then
				Responce.StatusCode= 408
				Responce.Body = "{""error"":{""message"":""Failed to send request after 3 attempts (Error: " &  GetLastError() & ")"", ""code"": 408}}"
				If OnReceive Then OnReceive(*Designer, This, Request, Responce.Body)
				If OnComplete Then OnComplete(*Designer, This, Request, Responce)
				InternetCloseHandle(hRequest)
				InternetCloseHandle(hConnect)
				InternetCloseHandle(hSession)
				Return
			End If
			
			Dim As Integer statusCode
			Dim As DWORD statusCodeSize = SizeOf(statusCode)
			HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_CODE Or HTTP_QUERY_FLAG_NUMBER, @statusCode, @statusCodeSize, 0)
			Responce.StatusCode = statusCode
			
			Dim As DWORD responseHeadersSize = 0
			HttpQueryInfo(hRequest, HTTP_QUERY_RAW_HEADERS_CRLF, 0, @responseHeadersSize, 0)
			If responseHeadersSize > 0 Then
				'Dim As ZString * 4096 responseHeadersBytes
				'If HttpQueryInfo(hRequest, HTTP_QUERY_RAW_HEADERS_CRLF, @responseHeadersBytes, SizeOf(responseHeadersBytes), 0) Then
				'	Responce.Headers = responseHeadersBytes
				'End If
			End If
			
			'更安全的缓冲区处理
			Dim As DWORD bytesRead, dwBufferSize = 8192
			Dim As Long bResult
			Dim As DWORD dwBytesRead
			Dim As ZString Ptr BufferPtr = _Allocate(dwBufferSize)
			Dim As String szBuffer
			Do
				bResult = InternetReadFile(hRequest, BufferPtr, dwBufferSize, @bytesRead)
				If bResult AndAlso bytesRead > 0 Then
					szBuffer = String(bytesRead, 0)
					memcpy(StrPtr(szBuffer), BufferPtr, bytesRead)
				Else
					FAbort = True
					szBuffer = ""
				End If
				Responce.Body &= szBuffer '*BufferPtr
				If OnReceive Then OnReceive(*Designer, This, Request, szBuffer)
			Loop While FAbort = False
			_Deallocate(BufferPtr)
			If OnComplete Then OnComplete(*Designer, This, Request, Responce)
			InternetCloseHandle(hRequest)
			InternetCloseHandle(hConnect)
			InternetCloseHandle(hSession)
		#elseif defined(__USE_GTK__)
			Dim out As GOutputStream Ptr
			Dim inp As GInputStream Ptr
			Dim client As GSocketClient Ptr = g_socket_client_new()
			g_socket_client_set_family(client, G_SOCKET_FAMILY_IPV4)
			Dim As GError Ptr error_ = NULL
			Dim socket As GSocketConnection Ptr = g_socket_client_connect_to_host(client, Host, Port, 0, @error_)
			If socket = 0 Then
				Print "Error: " & *error_->message
				g_error_free(error_)
				Return
			End If
			Dim tls_conn As GIOStream Ptr
			If Port = 443 Then
				tls_conn = g_tls_client_connection_new(Cast(GIOStream Ptr, socket), 0, @error_)
				If tls_conn = 0 Then
					Print "Error: " & *error_->message
					g_error_free(error_)
					Return
				End If
				g_tls_client_connection_set_server_identity(G_TLS_CLIENT_CONNECTION(tls_conn), G_SOCKET_CONNECTABLE(g_network_address_new(Host, Port)))
				out = g_io_stream_get_output_stream(tls_conn)
				inp = g_io_stream_get_input_stream(tls_conn)
			Else
				out = g_io_stream_get_output_stream(G_IO_STREAM(socket))
				inp = g_io_stream_get_input_stream(G_IO_STREAM(socket))
			End If
			
			Dim body As String = Request.Body
			Dim strrequest As String
			strrequest = UCase(HTTPMethod) & " /" & Request.ResourceAddress & " HTTP/1.1" & Chr(13) & Chr(10)
			strrequest += "Host: " & Host & Chr(13) & Chr(10)
			strrequest += Request.Headers
			strrequest += "Content-Length: " & Str(Len(body)) & Chr(13) & Chr(10)
			strrequest += "Connection: close" & Chr(13) & Chr(10) & Chr(13) & Chr(10)
			strrequest += body
			
			Dim bytes_written As Long = g_output_stream_write(out, StrPtr(strrequest), Len(strrequest), 0, 0)
			
			Dim buffer As ZString * 1024
			Dim bytes_read As Long
			Do
				bytes_read = g_input_stream_read(inp, @buffer, 1024, 0, 0)
				If bytes_read > 0 Then
					Responce.Body &= bytes_read
					If OnReceive Then OnReceive(*Designer, This, Request, buffer)
				End If
			Loop Until bytes_read <= 0
			
			g_object_unref(tls_conn)
			g_object_unref(socket)
			g_object_unref(client)
		#endif
	End Sub
	
	Constructor HTTPConnection
		WLet(FClassName, "HTTPConnection")
	End Constructor
	
	Destructor HTTPConnection
		
	End Destructor
End Namespace
