' courtesy https://www.freebasic.net/forum/viewtopic.php?t=4199&hilit=Simple+Web+Server
' Simple Web Server, (c) Anselme Dewavrin 2006 - dewavrin@yahoo.com
' Feel free to use it, provided you mention my name.
' based on the example provided with freebasic tweaked by thrive4 march 2024.
' Improved by Xusinboy Bekchanov, 2024.

#include once "Object.bi"
#include once "Dictionary.bi"
#if defined(__USE_WASM__) OrElse defined(__USE_JNI__) OrElse defined(__USE_APPLE__)
	'Web and Android: the program has no sockets to listen to
#elseif defined(__FB_WIN32__)
	'Windows (WinAPI and GTK): Winsock
	#define __MFF_HTTPSERVER_SOCKETS__
	#include once "win/winsock2.bi"
	#include once "windows.bi"
	#include once "win/shellapi.bi"
	#include once "fbthread.bi"
	#define HTTPServerSendFlags 0
#else
	'Linux and the other Unix systems: the sockets of the C library (crt/sys/socket.bi has the names of Winsock:
	'SOCKET, PSOCKADDR, SOCKET_ERROR, closesocket, opensocket)
	#define __MFF_HTTPSERVER_SOCKETS__
	#include once "crt/sys/socket.bi"
	#include once "crt/netinet/in.bi"
	#include once "crt/arpa/inet.bi"
	#include once "crt/unistd.bi"
	#include once "fbthread.bi"
	#ifndef INVALID_SOCKET
		#define INVALID_SOCKET (-1)
	#endif
	'A browser which closed the connection would end the program with SIGPIPE
	#define HTTPServerSendFlags MSG_NOSIGNAL
#endif

Using My.Sys.ComponentModel

Namespace My.Sys.Forms
	Type HTTPServerRequest
		Headers As String
		HTTPMethod As String
		RelativeURL As String
		Body As String
	End Type
	Type HTTPServerResponce
		Headers As String
		StatusCode As Integer
		Body As String
		BodyFileName As String
		Reason As String
	End Type
	
	Type CLIENT
		#ifdef __MFF_HTTPSERVER_SOCKETS__
			_socket     As SOCKET
		#endif
		ip          As Integer
		port        As Integer
		recvthread  As Any Ptr
		prev        As CLIENT Ptr
		next_       As CLIENT Ptr
		server      As Any Ptr
	End Type
	
	'This class implements a simple HTTP server (Windows, Linux and the other Unix systems).
	Type HTTPServer Extends Component
	Private:
		#define BuffSize 16384
		#ifdef __MFF_HTTPSERVER_SOCKETS__
			_socket     As SOCKET
		#endif
		acceptthread    As Any Ptr
		isrunning       As Integer
		globmutex       As Any Ptr
		filemutex       As Any Ptr
		clientlisthead  As CLIENT Ptr
		
		' multithreaded socket handling
		Declare Sub Del(ByVal client As CLIENT Ptr)
		Declare Function Quit() As Integer
		' thread waiting for data to arrive, parsing HTTP GET requests and sending responses
		Declare Static Sub Receive(ByVal client As CLIENT Ptr)
		Declare Static Sub Accept(server As HTTPServer Ptr)
	Public:
		#ifndef ReadProperty_Off
			Declare Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		As String Address = "127.0.0.1"
		As String HomeDir = "./"
		As Integer Port = 80
		Declare Function Run() As Integer
		Declare Constructor
		Declare Destructor
		OnReceive As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As HTTPServer, ByRef Request As HTTPServerRequest, ByRef Responce As HTTPServerResponce)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "HTTPServer.bas"
#endif
