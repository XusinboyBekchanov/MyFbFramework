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
			Case "timeout" : Return Cast(Any Ptr, @This.timeout)
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
			Case "timeout" : This.Port = QInteger(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	
	Private Sub HTTPConnection.CallMethod(HTTPMethod As String, ByRef Request As HTTPRequest, ByRef Responce As HTTPResponce)
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
			
			hSession = InternetOpen("FreeBASIC HTTP", INTERNET_OPEN_TYPE_DIRECT, "", "", 0)
			If hSession = 0 Then
				Print "Failed to open Internet session"
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
				Print "Failed to open URL"
				InternetCloseHandle(hSession)
				Return
			End If
			
			hRequest = HttpOpenRequest(hConnect, HTTPMethod, "/" & Request.ResourceAddress, NULL, NULL, NULL, IIf(Port = 80, INTERNET_FLAG_RELOAD, INTERNET_FLAG_SECURE Or INTERNET_FLAG_RELOAD), 0)
			If hRequest = 0 Then
				Print "Failed to open request"
				InternetCloseHandle(hConnect)
				InternetCloseHandle(hSession)
				Return
			End If
			
			hSendRequest = HttpSendRequest(hRequest, Request.Headers, Len(Request.Headers), Cast(LPVOID, StrPtr(Request.Body)), Len(Request.Body))
			If hSendRequest = False Then
				Print "Failed to send request"
				InternetCloseHandle(hRequest)
				InternetCloseHandle(hConnect)
				InternetCloseHandle(hSession)
				Return
			End If
			
			Dim As Integer statusCode
			Dim As DWORD statusCodeSize = Len(statusCode)
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
			Dim As String buffer = String(8192, 0) ' 增大缓冲区
			Dim As DWORD bytesRead
			Do
				buffer = String(8192, 0)
				If InternetReadFile(hRequest, StrPtr(buffer), Len(buffer), @bytesRead) = 0 Then Exit Do
				buffer = ..Left(buffer, bytesRead)
				Responce.Body &= buffer
				If OnReceive Then OnReceive(*Designer, This, Request, buffer)
			Loop While bytesRead > 0
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