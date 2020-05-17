'################################################################################
'#  MonthCalendar.bi                                                            #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#Include Once "SysUtils.bi"

Namespace My.Sys
	#DEFINE QBoolean(__Ptr__) *Cast(Boolean Ptr,__Ptr__)
	#DEFINE QInteger(__Ptr__) *Cast(Integer Ptr,__Ptr__)
	#DEFINE QWString(__Ptr__) *Cast(WString Ptr,__Ptr__)
	#DEFINE QZString(__Ptr__) *Cast(ZString Ptr,__Ptr__)
	#DEFINE QObject(__Ptr__) *Cast(My.Sys.Object Ptr,__Ptr__)
	
	Type Object Extends Object
	Protected:
		FTemp As WString Ptr
		FClassName As WString Ptr
	Public:
		Declare Virtual Function ToString ByRef As WString
		Declare Function ClassName ByRef As WString
		Declare Operator Cast As Any Ptr
		Declare Operator Cast ByRef As WString
		Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Declare Sub Free
		Declare Sub Dispose
		Declare Constructor
		Declare Destructor
	End Type
	
	Type NotifyEvent     As Sub(ByRef Sender As My.Sys.Object)
	Type CloseEvent      As Sub(ByRef Sender As My.Sys.Object, ByRef CloseAction As Integer)
	Type ScrollEvent     As Sub(ByRef Sender As My.Sys.Object, Code As Integer, ByRef ScrollPos As Integer)
	Type MouseDownEvent  As Sub(ByRef Sender As My.Sys.Object, MouseButton As Short, X As Integer, Y As Integer, Shift As Integer)
	Type MouseUpEvent    As Sub(ByRef Sender As My.Sys.Object, MouseButton As Short, X As Integer, Y As Integer, Shift As Integer)
	Type MouseMoveEvent  As Sub(ByRef Sender As My.Sys.Object, X As Integer, Y As Integer, Shift As Integer)
	Type MouseWheelEvent As Sub(ByRef Sender As My.Sys.Object, Direction As Short, X As Integer, Y As Integer, Shift As Integer)
	Type KeyPressEvent   As Sub(ByRef Sender As My.Sys.Object, Key As Byte)
	Type KeyDownEvent    As Sub(ByRef Sender As My.Sys.Object, Key As Integer, Shift As Integer)
	Type KeyUpEvent      As Sub(ByRef Sender As My.Sys.Object, Key As Integer, Shift As Integer)
	Type TimerEvent      As Sub(ByRef Sender As My.Sys.Object, TimerId As Integer, TimerProc As Any Ptr = 0)
	
End Namespace

#IfDef __EXPORT_PROCS__
	#IfNDef ToString_Off
		Declare Function ToString Alias "ToString"(Obj As My.Sys.Object Ptr) ByRef As WString
	#EndIf
	
	#IfNDef ReadProperty_Off
		Declare Function ReadProperty Alias "ReadProperty"(Ctrl As My.Sys.Object Ptr, ByRef PropertyName As String) As Any Ptr
	#EndIf
	
	#IfNDef WriteProperty_Off
		Declare Function WriteProperty Alias "WriteProperty"(Ctrl As My.Sys.Object Ptr, ByRef PropertyName As String, Value As Any Ptr) As Boolean
	#EndIf
#EndIf

#IfNDef __USE_MAKE__
	#Include Once "Object.bas"
#EndIf
