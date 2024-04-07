'###############################################################################
'#  Component.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'###############################################################################

#include once "Object.bi"

Namespace My.Sys.ComponentModel
	#define QComponent(__Ptr__) (*Cast(Component Ptr, __Ptr__))
	
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
		#elseif defined(__USE_WINAPI__)
			FHandle         As HWND
		#elseif defined(__USE_WASM__)
			FHandle         As Any Ptr
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
			Declare Property LayoutHandle As GtkWidget Ptr
			Declare Property LayoutHandle(Value As GtkWidget Ptr)
		#elseif defined(__USE_JNI__)
			'Gets the window handle that the control is bound to.
			Declare Property Handle As jobject
			Declare Property Handle(Value As jobject)
			Declare Property LayoutHandle As jobject
			Declare Property LayoutHandle(Value As jobject)
		#elseif defined(__USE_WINAPI__)
			'Gets the window handle that the control is bound to.
			Declare Property Handle As HWND
			Declare Property Handle(Value As HWND)
			Declare Property LayoutHandle As HWND
			Declare Property LayoutHandle(Value As HWND)
		#elseif defined(__USE_WASM__)
			'Gets the window handle that the control is bound to.
			Declare Property Handle As Any Ptr
			Declare Property Handle(Value As Any Ptr)
			Declare Property LayoutHandle As Any Ptr
			Declare Property LayoutHandle(Value As Any Ptr)
		#endif
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
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
		'Declare Constructor
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
	#ifdef __USE_GTK2__
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
		Key_Esc = GDK_KEY_Escape
		Key_Left = GDK_KEY_Left
		Key_Right = GDK_KEY_Right
		Key_Up = GDK_KEY_Up
		Key_Down = GDK_KEY_Down
		Key_Home = GDK_KEY_Home
		Key_End = GDK_KEY_End
		Key_Delete = GDK_KEY_Delete
		Key_Enter = GDK_KEY_Return
		ShiftMask = GDK_SHIFT_MASK
		LockMask = GDK_LOCK_MASK
		CtrlMask = GDK_CONTROL_MASK
		AltMask = GDK_MOD1_MASK
		Key_1 = GDK_KEY_1
		Key_2 = GDK_KEY_2
		Key_3 = GDK_KEY_3
		Key_4 = GDK_KEY_4
		Key_5 = GDK_KEY_5
		Key_6 = GDK_KEY_6
		Key_7 = GDK_KEY_7
		Key_8 = GDK_KEY_8
		Key_9 = GDK_KEY_9
		Key_0 = GDK_KEY_0
		Key_A = GDK_KEY_a
		Key_B = GDK_KEY_b
		Key_C = GDK_KEY_c
		Key_D = GDK_KEY_d
		Key_E = GDK_KEY_e
		Key_F = GDK_KEY_f
		Key_G = GDK_KEY_g
		Key_H = GDK_KEY_h
		Key_I = GDK_KEY_i
		Key_J = GDK_KEY_j
		Key_K = GDK_KEY_k
		Key_L = GDK_KEY_l
		Key_M = GDK_KEY_m
		Key_N = GDK_KEY_n
		Key_O = GDK_KEY_o
		Key_P = GDK_KEY_p
		Key_Q = GDK_KEY_q
		Key_R = GDK_KEY_r
		Key_S = GDK_KEY_s
		Key_T = GDK_KEY_t
		Key_U = GDK_KEY_u
		Key_V = GDK_KEY_v
		Key_W = GDK_KEY_w
		Key_X = GDK_KEY_x
		Key_Y = GDK_KEY_y
		Key_Z = GDK_KEY_z
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
		F13 = GDK_KEY_F13
		F14 = GDK_KEY_F14
		F15 = GDK_KEY_F15
		F16 = GDK_KEY_F16
		F17 = GDK_KEY_F17
		F18 = GDK_KEY_F18
		F19 = GDK_KEY_F19
		F20 = GDK_KEY_F20
		F21 = GDK_KEY_F21
		F22 = GDK_KEY_F22
		F23 = GDK_KEY_F23
		F24 = GDK_KEY_F24
	#elseif defined(__USE_JNI__)
		Key_Esc = 0
	#elseif defined(__USE_WINAPI__)
		Key_Esc = VK_ESCAPE
		Key_Left = VK_LEFT
		Key_Right = VK_RIGHT
		Key_Up = VK_UP
		Key_Down = VK_DOWN
		Key_Home = VK_HOME
		Key_End = VK_END
		Key_Delete = VK_DELETE
		Key_Enter = VK_RETURN
		ShiftMask = 1 'VK_SHIFT
		LockMask = 2 'VK_SCROLL
		CtrlMask = 4 'VK_CONTROL
		AltMask = 8 'VK_MENU
		Key_1 = VK_1
		Key_2 = VK_2
		Key_3 = VK_3
		Key_4 = VK_4
		Key_5 = VK_5
		Key_6 = VK_6
		Key_7 = VK_7
		Key_8 = VK_8
		Key_9 = VK_9
		Key_0 = VK_0
		Key_A = VK_A
		Key_B = VK_B
		Key_C = VK_C
		Key_D = VK_D
		Key_E = VK_E
		Key_F = VK_F
		Key_G = VK_G
		Key_H = VK_H
		Key_I = VK_I
		Key_J = VK_J
		Key_K = VK_K
		Key_L = VK_L
		Key_M = VK_M
		Key_N = VK_N
		Key_O = VK_O
		Key_P = VK_P
		Key_Q = VK_Q
		Key_R = VK_R
		Key_S = VK_S
		Key_T = VK_T
		Key_U = VK_U
		Key_V = VK_V
		Key_W = VK_W
		Key_X = VK_X
		Key_Y = VK_Y
		Key_Z = VK_Z
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
		F13 = VK_F13
		F14 = VK_F14
		F15 = VK_F15
		F16 = VK_F16
		F17 = VK_F17
		F18 = VK_F18
		F19 = VK_F19
		F20 = VK_F20
		F21 = VK_F21
		F22 = VK_F22
		F23 = VK_F23
		F24 = VK_F24
	#else
		Key_Esc = 0
	#endif
End Enum

Declare Sub ThreadsEnter

Declare Sub ThreadsLeave

Declare Function ThreadCreate_(ByVal ProcPtr_ As Sub ( ByVal userdata As Any Ptr ), ByVal param As Any Ptr = 0, ByVal stack_size As Integer = 0) As Any Ptr

Declare Sub ComponentGetBounds Alias "ComponentGetBounds" (Ctrl As My.Sys.ComponentModel.Component Ptr, ByRef ALeft As Integer, ByRef ATop As Integer, ByRef AWidth As Integer, ByRef AHeight As Integer)

Declare Sub ComponentSetBounds Alias "ComponentSetBounds"(Ctrl As My.Sys.ComponentModel.Component Ptr, ALeft As Integer, ATop As Integer, AWidth As Integer, AHeight As Integer)

#ifndef __USE_MAKE__
	#include once "Component.bas"
#endif
