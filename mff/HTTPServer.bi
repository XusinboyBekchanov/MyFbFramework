' courtesy https://www.freebasic.net/forum/viewtopic.php?t=4199&hilit=Simple+Web+Server
' Simple Web Server, (c) Anselme Dewavrin 2006 - dewavrin@yahoo.com
' Feel free to use it, provided you mention my name.
' based on the example provided with freebasic tweaked by thrive4 march 2024.
' Improved by Xusinboy Bekchanov, 2024.

#include once "Object.bi"
#include once "Dictionary.bi"
#if defined(__USE_WASM__) OrElse defined(__USE_JNI__) OrElse defined(__USE_UIKIT__)
	'Web, Android and iOS: the program has no sockets to listen to
#elseif defined(__USE_COCOA__)
	'macOS: the headers of FreeBASIC have no sockets of Darwin
	#define __MFF_HTTPSERVER_SOCKETS__
	#include once "fbthread.bi"
	Type SOCKET As Long
	Type socklen_t As ULong
	Type in_addr_mff
		s_addr As ULong
	End Type
	Type SOCKADDR_IN
		sin_len As UByte
		sin_family As UByte
		sin_port As UShort
		sin_addr As in_addr_mff
		sin_zero(7) As UByte
	End Type
	Type PSOCKADDR As SOCKADDR_IN Ptr
	Extern "C"
		Declare Function socket_ Alias "socket"(ByVal Domain As Long, ByVal SocketType As Long, ByVal Protocol As Long) As Long
		Declare Function bind Alias "bind"(ByVal Fd As Long, ByVal Address As Any Ptr, ByVal AddressLength As ULong) As Long
		Declare Function listen Alias "listen"(ByVal Fd As Long, ByVal Backlog As Long) As Long
		Declare Function accept Alias "accept"(ByVal Fd As Long, ByVal Address As Any Ptr, ByVal AddressLength As ULong Ptr) As Long
		Declare Function recv Alias "recv"(ByVal Fd As Long, ByVal Buffer As Any Ptr, ByVal Length As UInteger, ByVal Flags As Long) As Integer
		Declare Function send Alias "send"(ByVal Fd As Long, ByVal Buffer As Any Ptr, ByVal Length As UInteger, ByVal Flags As Long) As Integer
		Declare Function shutdown Alias "shutdown"(ByVal Fd As Long, ByVal How As Long) As Long
		Declare Function closesocket Alias "close"(ByVal Fd As Long) As Long
		Declare Function setsockopt Alias "setsockopt"(ByVal Fd As Long, ByVal Level As Long, ByVal OptName As Long, ByVal OptValue As Any Ptr, ByVal OptLength As ULong) As Long
		Declare Function inet_addr Alias "inet_addr"(ByVal Address As Const ZString Ptr) As ULong
		Declare Function signal_ Alias "signal"(ByVal SigNum As Long, ByVal Handler As Any Ptr) As Any Ptr
	End Extern
	#define opensocket socket_
	#define htons(x) ((((x) And &hFF) Shl 8) Or (((x) Shr 8) And &hFF))
	#define AF_INET 2
	#define SOCK_STREAM 1
	#define IPPROTO_TCP 6
	#define SOL_SOCKET &hFFFF
	#define SO_REUSEADDR 4
	#define SOMAXCONN 128
	#define INADDR_ANY 0
	#define INVALID_SOCKET (-1)
	#define SOCKET_ERROR (-1)
	'SIGPIPE is ignored (HTTPServer.Run): macOS has no MSG_NOSIGNAL
	#define HTTPServerSendFlags 0
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
