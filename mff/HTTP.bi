#include once "Component.bi"

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
	
	Type HTTPConnection Extends My.Sys.ComponentModel.Component
	Public:
		As String Host = "127.0.0.1"
		As Integer Port = 80
		Declare Sub CallMethod(HTTPMethod As String, ByRef Request As HTTPRequest, ByRef Responce As HTTPResponce)
		Declare Constructor
		Declare Destructor
		OnReceive As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As HTTPConnection, ByRef Request As HTTPRequest, ByRef Responce As HTTPResponce)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "HTTP.bas"
#endif
