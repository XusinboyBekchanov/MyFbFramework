#include once "HTTP.bi"
#ifdef __USE_WINAPI__
	#include once "win/wininet.bi"
#endif

Namespace My.Sys.Forms
	Private Sub HTTPConnection.CallMethod(HTTPMethod As String, ByRef Request As HTTPRequest, ByRef Responce As HTTPResponce)
		#ifdef __USE_WASM__
			Dim ptr_ As ZString Ptr = SendHTTPRequest("http://" & Host & ":" & IIf(Port = 80, "", Trim(Str(Port))) & "/" & Request.ResourceAddress, HTTPMethod, Request.Body)
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
			Dim As String result
			
			hSession = InternetOpen("FreeBASIC HTTP", INTERNET_OPEN_TYPE_PRECONFIG, "", "", 0)
			If hSession = 0 Then
				Print "Failed to open Internet session"
				Return ""
			End If
			
			hConnect = InternetOpenUrl(hSession, "http://" & Host & ":" & IIf(Port = 80, "", Trim(Str(Port))) & "/" & Request.ResourceAddress, "", 0, INTERNET_FLAG_RELOAD, 0)
			If hConnect = 0 Then
				Print "Failed to open URL"
				InternetCloseHandle(hSession)
				Return ""
			End If
			
			hRequest = HttpOpenRequest(hConnect, HTTPMethod, "/", "", "", 0, 0, 0)
			If hRequest = 0 Then
				Print "Failed to open request"
				InternetCloseHandle(hConnect)
				InternetCloseHandle(hSession)
				Return 0
			End If
			
			If Not HttpSendRequest(hRequest, Request.Headers, Len(Request.Headers), Request.Body, Len(Request.Body)) Then
				Print "Failed to send request"
				InternetCloseHandle(hRequest)
				InternetCloseHandle(hConnect)
				InternetCloseHandle(hSession)
				Return 0
			End If
			
			Dim As Integer statusCode
			Dim As DWORD statusCodeSize = Len(statusCode)
			HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_CODE Or HTTP_QUERY_FLAG_NUMBER, @statusCode, @statusCodeSize, 0)
			
			Dim As DWORD responseHeadersSize = 0
			HttpQueryInfo(hRequest, HTTP_QUERY_RAW_HEADERS_CRLF, 0, @responseHeadersSize, 0)
			If responseHeadersSize > 0 Then
				Dim As String responseHeadersBytes(responseHeadersSize)
				If HttpQueryInfo(hRequest, HTTP_QUERY_RAW_HEADERS_CRLF, @responseHeadersBytes(0), @responseHeadersSize, 0) Then
					Responce.Headers = responseHeadersBytes
				End If
			End If
			
			Do
				Dim As String buffer
				Dim As DWORD bytesRead
				If InternetReadFile(hRequest, @buffer, Len(buffer), @bytesRead) = 0 Then
					Print "Failed to read data"
					Exit Do
				End If
				If bytesRead = 0 Then Exit Do ' Конец файла
				Responce.Body += buffer
			Loop
			
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

