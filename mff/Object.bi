'################################################################################
'#  MonthCalendar.bi                                                            #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#include once "SysUtils.bi"
#ifdef __USE_GTK__
	#ifdef __USE_GTK4__
		#include once "cairo/cairo.bi"
		#include once "gir_headers/Gir/PangoCairo-1.0.bi"
		#include once "gir_headers/Gir/Gtk-4.0.bi"
		#include once "gir_headers/Gir/_GObjectMacros-2.0.bi"
	#else
		#include once "gtk/gtk.bi"
		#ifdef __USE_GTK3__
			#include once "glib-object.bi"
		#endif
	#endif
#endif

Namespace My.Sys
	#define QBoolean(__Ptr__) *Cast(Boolean Ptr,__Ptr__)
	#define QInteger(__Ptr__) *Cast(Integer Ptr,__Ptr__)
	#define QULong(__Ptr__) *Cast(ULong Ptr,__Ptr__)
	#define QLong(__Ptr__) *Cast(Long Ptr,__Ptr__)
	#define QSingle(__Ptr__) *Cast(Single Ptr,__Ptr__)
	#define QDouble(__Ptr__) *Cast(Double Ptr,__Ptr__)
	#define QWString(__Ptr__) *Cast(WString Ptr,__Ptr__)
	#define QZString(__Ptr__) *Cast(ZString Ptr,__Ptr__)
	#define QObject(__Ptr__) *Cast(My.Sys.Object Ptr,__Ptr__)
	
	Private Type Object Extends Object
	Protected:
		#ifdef __USE_GTK__
			Accelerator     As GtkAccelGroup Ptr
			layoutwidget	As GtkWidget Ptr
		#elseif defined(__USE_JNI__)
			layoutview      As jobject
		#elseif defined(__USE_WINAPI__)
			Accelerator        As HACCEL
		#endif
		Designer As Object Ptr
		FTemp As WString Ptr
		FClassName As WString Ptr
		FDynamic As Boolean
		#ifdef __USE_GTK__
			FActivated As Boolean
			FDeactivated As Boolean
		#endif
	Public:
		Declare Virtual Function ToString ByRef As WString
		Declare Function ClassName ByRef As WString
		' Function to get any typename in the inheritance up hierarchy
		' of the type of an instance (address: 'po') compatible with the built-in 'Object'
		'
		' ('baseIndex =  0' to get the typename of the instance)
		' ('baseIndex = -1' to get the base.typename of the instance, or "" if not existing)
		' ('baseIndex = -2' to get the base.base.typename of the instance, or "" if not existing)
		Declare Function FullTypeName(ByVal baseIndex As Integer = 0) As UString
		Declare Operator Cast As Any Ptr
		Declare Operator Cast ByRef As WString
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off		
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Constructor
		Declare Destructor
	End Type
	
	Private Type NotifyEvent     As Sub(ByRef Sender As My.Sys.Object)
'	Private Type CloseEvent      As Sub(ByRef Sender As My.Sys.Object, ByRef CloseAction As Integer)
'	Private Type ScrollEvent     As Sub(ByRef Sender As My.Sys.Object, Code As Integer, ByRef ScrollPos As Integer)
'	Private Type MouseDownEvent  As Sub(ByRef Sender As My.Sys.Object, MouseButton As Short, X As Integer, Y As Integer, Shift As Integer)
'	Private Type MouseUpEvent    As Sub(ByRef Sender As My.Sys.Object, MouseButton As Short, X As Integer, Y As Integer, Shift As Integer)
'	Private Type MouseMoveEvent  As Sub(ByRef Sender As My.Sys.Object, X As Integer, Y As Integer, Shift As Integer)
'	Private Type MouseWheelEvent As Sub(ByRef Sender As My.Sys.Object, Direction As Short, X As Integer, Y As Integer, Shift As Integer)
'	Private Type KeyPressEvent   As Sub(ByRef Sender As My.Sys.Object, Key As Integer)
'	Private Type KeyDownEvent    As Sub(ByRef Sender As My.Sys.Object, Key As Integer, Shift As Integer)
'	Private Type KeyUpEvent      As Sub(ByRef Sender As My.Sys.Object, Key As Integer, Shift As Integer)
'	Private Type TimerEvent      As Sub(ByRef Sender As My.Sys.Object, TimerId As Integer, TimerProc As Any Ptr = 0)
	
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
