#include once "Component.bi"

Using My.Sys.ComponentModel

Namespace My.Sys.Forms
	Type HTTPRequest
		Headers As String
		ResourceAddress As String
		Body As String
	End Type
	Type HTTPResponce
		Headers As String
		StatusCode As Integer
		Body As String
		BodyFileName As String
		Reason As String
	End Type
	
	Type HTTPConnection Extends Component
		
	Private:
		FAbort As Boolean
	Public:
		#ifndef ReadProperty_Off
			Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Get or set request cancellation.
		Declare Property Abort As Boolean
		Declare Property Abort(Value As Boolean)
		
		As String Host = "127.0.0.1"
		As Integer Port = 80
		As Integer Timeout = 3000
		'Get response content and HTTP status code.
		Declare Sub CallMethod(HTTPMethod As String, ByRef Request As HTTPRequest, ByRef Responce As HTTPResponce)
		Declare Constructor
		Declare Destructor
		OnReceive  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As HTTPConnection, ByRef Request As HTTPRequest, ByRef Buffer As String)
		OnComplete As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As HTTPConnection, ByRef Request As HTTPRequest)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "HTTP.bas"
#endif
