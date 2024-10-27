'################################################################################
'#  Object.bi                                                                   #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2022)                                     #
'################################################################################

#include once "SysUtils.bi"

#define QBoolean(__Ptr__) (*Cast(Boolean Ptr, __Ptr__))
#define QInteger(__Ptr__) (*Cast(Integer Ptr, __Ptr__))
#define QULong(__Ptr__) (*Cast(ULong Ptr, __Ptr__))
#define QLong(__Ptr__) (*Cast(Long Ptr, __Ptr__))
#define QSingle(__Ptr__) (*Cast(Single Ptr, __Ptr__))
#define QDouble(__Ptr__) (*Cast(Double Ptr, __Ptr__))
#define QWString(__Ptr__) (*Cast(WString Ptr, __Ptr__))
#define QZString(__Ptr__) (*Cast(ZString Ptr, __Ptr__))
#define QString(__Ptr__) (*Cast(String Ptr, __Ptr__))
#define QObject(__Ptr__) (*Cast(My.Sys.Object Ptr, __Ptr__))
	
Namespace My.Sys
	Private Type Object Extends Object
	Protected:
		#ifdef __USE_GTK__
			Accelerator     As GtkAccelGroup Ptr
			widget          As GtkWidget Ptr
			layoutwidget    As GtkWidget Ptr
		#elseif defined(__USE_JNI__)
			layoutview      As jobject
		#elseif defined(__USE_WINAPI__)
			Accelerator        As HACCEL
		#endif
		FTemp As WString Ptr
		FClassName As WString Ptr
		FDynamic As Boolean
		oldxdpi As Single
		oldydpi As Single
		#ifdef __USE_GTK__
			FActivated As Boolean
			FDeactivated As Boolean
		#elseif defined(__USE_WASM__)
			FBody As WString Ptr
		#endif
	Public:
		xdpi As Single
		ydpi As Single
		'Returns a string that represents the current object (Windows, Linux, Android, Web).
		Declare Virtual Function ToString ByRef As WString
		'Used to get correct class name of the object (Windows, Linux, Android, Web).
		Declare Function ClassName ByRef As WString
		'Returns/sets the object that enables you to access the design characteristics of a object (Windows, Linux, Android, Web).
		Designer As Object Ptr
		' Function to get any typename in the inheritance up hierarchy
		' of the type of an instance (address: 'po') compatible with the built-in 'Object'
		'
		' ('baseIndex =  0' to get the typename of the instance)
		' ('baseIndex = -1' to get the base.typename of the instance, or "" if not existing)
		' ('baseIndex = -2' to get the base.base.typename of the instance, or "" if not existing)
		Declare Function FullTypeName(ByVal baseIndex As Integer = 0) As UString
		'Returns a Boolean value indicating whether a object has been initialized (Windows, Linux, Android, Web).
		Declare Function IsEmpty() As Boolean
		Declare Operator Cast As Any Ptr
		Declare Operator Cast ByRef As WString
		#ifndef ReadProperty_Off
			'Reads value from the name of property (Windows, Linux, Android, Web).
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Writes value to the name of property (Windows, Linux, Android, Web).
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		#ifdef __USE_JNI__
			Declare Function ScaleX(ByVal cx As Single) As Integer
			Declare Function ScaleY(ByVal cy As Single) As Integer
			Declare Function UnScaleX(ByVal cx As Single) As Integer
			Declare Function UnScaleY(ByVal cy As Single) As Integer
		#else
			Declare Function ScaleX(ByVal cx As Single) As Single
			Declare Function ScaleY(ByVal cy As Single) As Single
			Declare Function UnScaleX(ByVal cx As Single) As Single
			Declare Function UnScaleY(ByVal cy As Single) As Single
		#endif
		Declare Destructor
	End Type
	
	Private Type NotifyEvent     As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object)
'	Private Type CloseEvent      As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object, ByRef CloseAction As Integer)
'	Private Type ScrollEvent     As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object, Code As Integer, ByRef ScrollPos As Integer)
'	Private Type MouseDownEvent  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object, MouseButton As Short, X As Integer, Y As Integer, Shift As Integer)
'	Private Type MouseUpEvent    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object, MouseButton As Short, X As Integer, Y As Integer, Shift As Integer)
'	Private Type MouseMoveEvent  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object, X As Integer, Y As Integer, Shift As Integer)
'	Private Type MouseWheelEvent As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object, Direction As Short, X As Integer, Y As Integer, Shift As Integer)
'	Private Type KeyPressEvent   As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object, Key As Integer)
'	Private Type KeyDownEvent    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object, Key As Integer, Shift As Integer)
'	Private Type KeyUpEvent      As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object, Key As Integer, Shift As Integer)
'	Private Type TimerEvent      As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object, TimerId As Integer, TimerProc As Any Ptr = 0)
	
End Namespace

#ifdef __EXPORT_PROCS__
	#ifndef ToString_Off
		Declare Function ToString Alias "ToString"(Obj As My.Sys.Object Ptr) ByRef As WString
	#endif
	
	#ifndef ReadProperty_Off
		Declare Function ReadProperty Alias "ReadProperty"(Ctrl As My.Sys.Object Ptr, ByRef PropertyName As String) As Any Ptr
	#endif
	
	#ifndef WriteProperty_Off
		Declare Function WriteProperty Alias "WriteProperty"(Ctrl As My.Sys.Object Ptr, ByRef PropertyName As String, Value As Any Ptr) As Boolean
	#endif
#endif

#ifndef __USE_MAKE__
	#include once "Object.bas"
#endif
