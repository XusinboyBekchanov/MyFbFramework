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
				Responce.Body = "ERROR: Failed to open Internet session"
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
				Responce.Body = "ERROR: Failed to open URL"
				If OnReceive Then OnReceive(*Designer, This, Request, Responce.Body)
				If OnComplete Then OnComplete(*Designer, This, Request, Responce)
				InternetCloseHandle(hSession)
				Return
			End If
			
			hRequest = HttpOpenRequest(hConnect, HTTPMethod, "/" & Request.ResourceAddress, NULL, NULL, NULL, IIf(Port = 80, INTERNET_FLAG_RELOAD, INTERNET_FLAG_SECURE Or INTERNET_FLAG_RELOAD), 0)
			If hRequest = 0 Then
				Responce.StatusCode= 407
				Responce.Body = "ERROR: Failed to open request"
				If OnReceive Then OnReceive(*Designer, This, Request, Responce.Body)
				If OnComplete Then OnComplete(*Designer, This, Request, Responce)
				InternetCloseHandle(hConnect)
				InternetCloseHandle(hSession)
				Return
			End If
			
			hSendRequest = HttpSendRequest(hRequest, Request.Headers, Len(Request.Headers), Cast(LPVOID, StrPtr(Request.Body)), Len(Request.Body))
			If hSendRequest = False Then
				Responce.StatusCode= 408
				Responce.Body = "ERROR: Failed to send request"
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
			Dim As ZString Ptr BufferPtr = Allocate(dwBufferSize)
			Do
				bResult = InternetReadFile(hRequest, BufferPtr, dwBufferSize, @bytesRead)
				If bResult AndAlso bytesRead > 0 Then
					(*BufferPtr)[bytesRead] = 0 
				Else
					FAbort = True
					(*BufferPtr)[0] = 0
				End If
				Responce.Body &= *BufferPtr
				If OnReceive Then OnReceive(*Designer, This, Request, *BufferPtr)
			Loop While FAbort = False
			Deallocate BufferPtr
			If OnComplete Then OnComplete(*Designer, This, Request, Responce)
			InternetCloseHandle(hRequest)
			InternetCloseHandle(hConnect)
			InternetCloseHandle(hSession)
		#endif
	End Sub
	
	Constructor HTTPConnection
		WLet(FClassName, "HTTPConnection")
	End Constructor
	
	Destructor HTTPConnection
		
	End Destructor
End Namespace