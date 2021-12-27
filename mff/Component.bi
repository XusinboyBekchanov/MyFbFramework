'###############################################################################
'#  Component.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'###############################################################################

#include once "Object.bi"

Namespace My.Sys.ComponentModel
	#define QComponent(__Ptr__) *Cast(Component Ptr, __Ptr__)
	
	Private Type MarginsType Extends My.Sys.Object
		Declare Function ToString ByRef As WString
		Left         As Integer
		Top          As Integer
		Right        As Integer
		Bottom       As Integer
	End Type
	
	Private Type Component Extends My.Sys.Object
	Protected:
		FClassAncestor      As WString Ptr
		FDesignMode         As Boolean
		FCreated            As Boolean
		FID                 As Integer
		FName               As WString Ptr
		FLeft               As Integer
		FTop                As Integer
		FWidth              As Integer
		FHeight             As Integer
		FMinWidth           As Integer
		FMinHeight          As Integer
		FParent             As Component Ptr
		FTempString         As String
		#ifdef __USE_GTK__
			widget 			As GtkWidget Ptr
			box 			As GtkWidget Ptr
			fixedwidget		As GtkWidget Ptr
			scrolledwidget	As GtkWidget Ptr
			eventboxwidget  As GtkWidget Ptr
			overlaywidget   As GtkWidget Ptr
		#elseif defined(__USE_JNI__)
			FHandle         As jobject
		#else
			FHandle         As HWND
		#endif
		Declare Virtual Sub Move(cLeft As Integer, cTop As Integer, cWidth As Integer, cHeight As Integer)
	Public:
		'Stores any extra data needed for your program.
		Tag As Any Ptr
		'Returns/sets the space between controls.
		Margins             As MarginsType
		'Returns/sets the extra space between controls.
		ExtraMargins        As MarginsType
		#ifdef __USE_GTK__
			'Gets the window handle that the control is bound to.
			Declare Property Handle As GtkWidget Ptr
			Declare Property Handle(Value As GtkWidget Ptr)
		#elseif defined(__USE_JNI__)
			'Gets the window handle that the control is bound to.
			Declare Property Handle As jobject
			Declare Property Handle(Value As jobject)
		#else
			'Gets the window handle that the control is bound to.
			Declare Property Handle As HWND
			Declare Property Handle(Value As HWND)
		#endif
		Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		'Returns a string that represents the current object.
		Declare Virtual Function ToString ByRef As WString
		'Returns ancestor class of control.
		Declare Function ClassAncestor ByRef As WString
		'Determines if the control is a top-level control.
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
		Declare Sub GetBounds(ByRef ALeft As Integer, ByRef ATop As Integer, ByRef AWidth As Integer, ByRef AHeight As Integer)
		'Sets the bounds of the control to the specified location and size.
		Declare Sub SetBounds(ALeft As Integer, ATop As Integer, AWidth As Integer, AHeight As Integer)
		'Gets a value that indicates whether the Component is currently in design mode.
		Declare Virtual Property DesignMode As Boolean
		Declare Virtual Property DesignMode(Value As Boolean)
		'Returns the name used in code to identify an object.
		Declare Property Name ByRef As WString
		Declare Property Name(ByRef Value As WString)
		'Gets or sets the parent container of the control.
		Declare Property Parent As Component Ptr 'ContainerControl
		Declare Property Parent(Value As Component Ptr)
		Declare Destructor
	End Type
End Namespace

Private Type Message
	Sender   As Any Ptr
	#ifdef __USE_GTK__
		widget As GtkWidget Ptr
		Event As GdkEvent Ptr
		Result   As Boolean
	#elseif defined(__USE_WINAPI__)
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
		Const GDK_KEY_KP_Enter = &hff8d
		Const GDK_KEY_Paste = &h1008ff6d
		Const GDK_KEY_Redo = &hff66
		Const GDK_KEY_Undo = &hff65
		Const GDK_KEY_Page_Up = &hff55
		Const GDK_KEY_Page_Down = &hff56
		Const GDK_KEY_Insert = &hff63
		Const GDK_KEY_F1 = &hffbe
		Const GDK_KEY_F2 = &hffbf
		Const GDK_KEY_F3 = &hffc0
		Const GDK_KEY_F4 = &hffc1
		Const GDK_KEY_F5 = &hffc2
		Const GDK_KEY_F6 = &hffc3
		Const GDK_KEY_F7 = &hffc4
		Const GDK_KEY_F8 = &hffc5
		Const GDK_KEY_F9 = &hffc6
		Const GDK_KEY_F10 = &hffc7
		Const GDK_KEY_F11 = &hffc8
		Const GDK_KEY_F12 = &hffc9
		Const GDK_KEY_Tab = &hff09
		Const GDK_KEY_ISO_Left_Tab = &hfe20
		Const GDK_KEY_SPACE = &h020
		Const GDK_KEY_BACKSPACE = &hff08
		Const GDK_KEY_Return = &hff0d
	#endif
#endif

Private Enum Keys
	#ifdef __USE_GTK__
		Key_Esc = GDK_KEY_ESCAPE
		Key_Left = GDK_KEY_LEFT
		Key_Right = GDK_KEY_RIGHT
		Key_Up = GDK_KEY_UP
		Key_Down = GDK_KEY_DOWN
		Key_Home = GDK_KEY_HOME
		Key_End = GDK_KEY_END
		Key_Delete = GDK_KEY_DELETE
		Key_Enter = GDK_KEY_RETURN
		F1 = GDK_KEY_F1
		F2 = GDK_KEY_F2
		F3 = GDK_KEY_F3
		F4 = GDK_KEY_F4
		F5 = GDK_KEY_F5
		F6 = GDK_KEY_F6
		F7 = GDK_KEY_F7
		F8 = GDK_KEY_F8
		F9 = GDK_KEY_F9
		F10 = GDK_KEY_F10
		F11 = GDK_KEY_F11
		F12 = GDK_KEY_F12
	#elseif defined(__USE_JNI__)
		Key_Esc = 0
	#else
		Key_Esc = VK_ESCAPE
		Key_Left = VK_LEFT
		Key_Right = VK_RIGHT
		Key_Up = VK_UP
		Key_Down = VK_DOWN
		Key_Home = VK_HOME
		Key_End = VK_END
		Key_Delete = VK_DELETE
		Key_Enter = VK_RETURN
		F1 = VK_F1
		F2 = VK_F2
		F3 = VK_F3
		F4 = VK_F4
		F5 = VK_F5
		F6 = VK_F6
		F7 = VK_F7
		F8 = VK_F8
		F9 = VK_F9
		F10 = VK_F10
		F11 = VK_F11
		F12 = VK_F12
	#endif
End Enum

Declare Sub ThreadsEnter

Declare Sub ThreadsLeave

Declare Sub ComponentGetBounds Alias "ComponentGetBounds" (Ctrl As My.Sys.ComponentModel.Component Ptr, ByRef ALeft As Integer, ByRef ATop As Integer, ByRef AWidth As Integer, ByRef AHeight As Integer)
	
Declare Sub ComponentSetBounds Alias "ComponentSetBounds"(Ctrl As My.Sys.ComponentModel.Component Ptr, ALeft As Integer, ATop As Integer, AWidth As Integer, AHeight As Integer)
	
#ifndef __USE_MAKE__
	#include once "Component.bas"
#endif
