'###############################################################################
'#  Component.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'###############################################################################

#include once "Object.bi"
#ifdef __USE_GTK__
	#include once "gtk/gtk.bi"
	#ifdef __USE_GTK3__
		#include once "glib-object.bi"
	#endif
#endif

Namespace My.Sys.ComponentModel
	#define QComponent(__Ptr__) *Cast(Component Ptr,__Ptr__)
	
	Type Component Extends My.Sys.Object
	Protected:
		FClassAncestor As WString Ptr
		FDesignMode As Boolean
		FName As WString Ptr
		FParent            As Component Ptr
		FTempString As String
		#ifndef __USE_GTK__
			FHandle As HWND
		#endif
	Public:
		'Stores any extra data needed for your program.
		Tag As Any Ptr
		#ifdef __USE_GTK__
			Accelerator     As GtkAccelGroup Ptr
			Declare Property Handle As GtkWidget Ptr
			Declare Property Handle(Value As GtkWidget Ptr)
			widget 			As GtkWidget Ptr
			box 			As GtkWidget Ptr
			fixedwidget		As GtkWidget Ptr
			scrolledwidget	As GtkWidget Ptr
			layoutwidget	As GtkWidget Ptr
		#else
			Accelerator        As HACCEL
			Declare Property Handle As HWND
			Declare Property Handle(Value As HWND)
		#endif
		Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Declare Virtual Function ToString ByRef As WString
		Declare Function ClassAncestor ByRef As WString
		Declare Function GetTopLevel As Component Ptr
		Declare Property DesignMode As Boolean
		Declare Property DesignMode(Value As Boolean)
		'Returns the name used in code to identify an object.
		Declare Property Name ByRef As WString
		Declare Property Name(ByRef Value As WString)
		Declare Property Parent As Component Ptr 'ContainerControl
		Declare Property Parent(Value As Component Ptr)
		Declare Destructor
	End Type
End Namespace

Type Message
	Sender   As Any Ptr
	#ifdef __USE_GTK__
		widget As GtkWidget Ptr
		Event As GdkEvent Ptr
		Result   As Boolean
	#else
		hWnd     As HWND
		Msg      As UINT
		wParam   As WPARAM
		lParam   As LPARAM
		Result   As LRESULT
		wParamLo As Integer
		wParamHi As Integer
		lParamLo As Integer
		lParamHi As Integer
		Captured As Any Ptr
	#endif
End Type

#ifdef __USE_GTK__
	#ifndef __USE_GTK3__
		Const GDK_KEY_Escape = &hff1b
		Const GDK_KEY_Left = &hff51
		Const GDK_KEY_Right = &hff53
		Const GDK_KEY_Up = &hff52
		Const GDK_KEY_Down = &hff54
		Const GDK_KEY_Home = &hff50
		Const GDK_KEY_End = &hff57
		Const GDK_KEY_Delete = &hffff
		Const GDK_KEY_Cut = &h1008ff58
		Const GDK_KEY_Copy = &h1008ff57
		Const GDK_KEY_Paste = &h1008ff6d
		Const GDK_KEY_Redo = &hff66
		Const GDK_KEY_Undo = &hff65
		Const GDK_KEY_Page_Up = &hff55
		Const GDK_KEY_Page_Down = &hff56
		Const GDK_KEY_Insert = &hff63
		Const GDK_KEY_F9 = &hffc6
		Const GDK_KEY_F6 = &hffc3
		Const GDK_KEY_Tab = &hff09
		Const GDK_KEY_ISO_Left_Tab = &hfe20
		Const GDK_KEY_SPACE = &h020
		Const GDK_KEY_BACKSPACE = &hff08
		Const GDK_KEY_Return = &hff0d
	#endif
#endif

Enum Keys
	#ifdef __USE_GTK__
		Esc = GDK_KEY_ESCAPE
		Left = GDK_KEY_LEFT
		Right = GDK_KEY_RIGHT
		Up = GDK_KEY_UP
		Down = GDK_KEY_DOWN
		Home = GDK_KEY_HOME
		EndKey = GDK_KEY_END
		DeleteKey = GDK_KEY_DELETE
		Enter = GDK_KEY_RETURN
	#else
		Esc = VK_ESCAPE
		Left = VK_LEFT
		Right = VK_RIGHT
		Up = VK_UP
		Down = VK_DOWN
		Home = VK_HOME
		EndKey = VK_END
		DeleteKey = VK_DELETE
		Enter = VK_RETURN
	#endif
End Enum

Declare Sub ThreadsEnter

Declare Sub ThreadsLeave

#ifndef __USE_MAKE__
	#include once "Component.bas"
#endif
