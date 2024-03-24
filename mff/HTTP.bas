#include once "HTTP.bi"

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
		#endif
	End Sub
	
	Constructor HTTPConnection
		WLet(FClassName, "HTTPConnection")
	End Constructor
	
	Destructor HTTPConnection
		
	End Destructor
End Namespace

