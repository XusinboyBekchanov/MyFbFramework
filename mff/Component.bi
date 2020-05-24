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

#ifndef __FB_WIN32__
	Type Point
		X As Integer
		Y As Integer
	End Type
	
	Type Rect
		Left As Integer
		Top As Integer
		Right As Integer
		Bottom As Integer
	End Type
#endif

Namespace My.Sys.ComponentModel
	#define QComponent(__Ptr__) *Cast(Component Ptr,__Ptr__)
	
	Type MarginsType Extends My.Sys.Object
		Declare Function ToString ByRef As WString
		Left         As Integer
		Top          As Integer
		Right        As Integer
		Bottom       As Integer
	End Type
	
	Type Component Extends My.Sys.Object
	Protected:
		FClassAncestor As WString Ptr
		FDesignMode As Boolean
		FName As WString Ptr
		FLeft              As Integer
		FTop               As Integer
		FWidth             As Integer
		FHeight            As Integer
		FMinWidth          As Integer
		FMinHeight         As Integer
		FParent            As Component Ptr
		FTempString As String
		#ifndef __USE_GTK__
			FHandle As HWND
		#endif
		Declare Sub Move(cLeft As Integer, cTop As Integer, cWidth As Integer, cHeight As Integer)
	Public:
		'Stores any extra data needed for your program.
		Tag As Any Ptr
		'Returns/sets the space between controls.
		Margins            As MarginsType
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
		'Returns/sets the distance between the internal left edge of an object and the left edge of its container.
		Declare Property Left As Integer
		Declare Property Left(Value As Integer)
		'Returns/sets the distance between the internal top edge of an object and the top edge of its container.
		Declare Property Top As Integer
		Declare Property Top(Value As Integer)
		'Returns/sets the width of an object.
		Declare Property Width As Integer
		Declare Property Width(Value As Integer)
		'Returns/sets the height of an object.
		Declare Property Height As Integer
		Declare Property Height(Value As Integer)
		'Gets the bounds of the control to the specified location and size.
		Declare Sub GetBounds(ALeft As Integer Ptr, ATop As Integer Ptr, AWidth As Integer Ptr, AHeight As Integer Ptr)
		'Sets the bounds of the control to the specified location and size.
		Declare Sub SetBounds(ALeft As Integer, ATop As Integer, AWidth As Integer, AHeight As Integer, NoScale As Boolean = False)
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

Declare Sub ComponentGetBounds Alias "ComponentGetBounds"(Ctrl As My.Sys.ComponentModel.Component Ptr, ALeft As Integer Ptr, ATop As Integer Ptr, AWidth As Integer Ptr, AHeight As Integer Ptr)
	
Declare Sub ComponentSetBounds Alias "ComponentSetBounds"(Ctrl As My.Sys.ComponentModel.Component Ptr, ALeft As Integer, ATop As Integer, AWidth As Integer, AHeight As Integer)
	
#ifndef __USE_MAKE__
	#include once "Component.bas"
#endif
