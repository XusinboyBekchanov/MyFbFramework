'###############################################################################
'#  Component.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'###############################################################################

#include once "Object.bi"
#include once "List.bi"

Namespace My.Sys.ComponentModel
	#define QComponent(__Ptr__) (*Cast(Component Ptr, __Ptr__))
	
	Private Type MarginsType Extends My.Sys.Object
		Declare Function ToString ByRef As WString
		Left         As Integer
		Top          As Integer
		Right        As Integer
		Bottom       As Integer
	End Type
	
	'Provides the base class for the components (Windows, Linux, Android, Web).
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
		FComponents         As List
		FTempString         As String
		#ifdef __USE_GTK__
			box 			As GtkWidget Ptr
			fixedwidget		As GtkWidget Ptr
			scrolledwidget	As GtkWidget Ptr
			eventboxwidget  As GtkWidget Ptr
			overlaywidget   As GtkWidget Ptr
			containerwidget As GtkWidget Ptr
		#elseif defined(__USE_JNI__)
			FHandle         As jobject
		#elseif defined(__USE_WINAPI__)
			FHandle         As HWND
		#elseif defined(__USE_WASM__) OrElse defined(__USE_APPLE__)
			FHandle         As Any Ptr
		#endif
		Declare Sub FreeWidget()
		Declare Virtual Sub Move(cLeft As Integer, cTop As Integer, cWidth As Integer, cHeight As Integer)
	Public:
		#ifdef __USE_JNI__
			'Android: the title bar of the designed form (the designer of the IDE) is above its view like the one of a
			'window of Windows: the view is lower by its height (FormDesignFrame draws it)
			Declare Function DesignCaptionHeight() As Integer
		#endif
		'Stores any extra data needed for your program (Windows, Linux, Android, Web).
		Tag As Any Ptr
		'Returns/sets the space between controls (Windows, Linux, Android, Web).
		Margins             As MarginsType
		'Returns/sets the extra space between controls (Windows, Linux, Android, Web).
		ExtraMargins        As MarginsType
		#ifdef __USE_GTK__
			'Gets the window handle that the control is bound to (Windows, Linux, Android, Web).
			Declare Property Handle As GtkWidget Ptr
			Declare Property Handle(Value As GtkWidget Ptr)
			Declare Property LayoutHandle As GtkWidget Ptr
			Declare Property LayoutHandle(Value As GtkWidget Ptr)
		#elseif defined(__USE_JNI__)
			'Gets the window handle that the control is bound to (Windows, Linux, Android, Web).
			Declare Property Handle As jobject
			Declare Property Handle(Value As jobject)
			Declare Property LayoutHandle As jobject
			Declare Property LayoutHandle(Value As jobject)
		#elseif defined(__USE_WINAPI__)
			'Gets the window handle that the control is bound to (Windows, Linux, Android, Web).
			Declare Property Handle As HWND
			Declare Property Handle(Value As HWND)
			Declare Property LayoutHandle As HWND
			Declare Property LayoutHandle(Value As HWND)
		#elseif defined(__USE_WASM__) OrElse defined(__USE_APPLE__)
			'Gets the window handle that the control is bound to (Windows, Linux, Android, Web).
			Declare Property Handle As Any Ptr
			Declare Property Handle(Value As Any Ptr)
			Declare Property LayoutHandle As Any Ptr
			Declare Property LayoutHandle(Value As Any Ptr)
		#endif
		#ifndef ReadProperty_Off
			'Reads value from the name of property (Windows, Linux, Android, Web).
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Writes value to the name of property (Windows, Linux, Android, Web).
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Returns a string that represents the current object (Windows, Linux, Android, Web).
		Declare Virtual Function ToString ByRef As WString
		'Returns ancestor class of control (Windows, Linux, Android, Web).
		Declare Function ClassAncestor ByRef As WString
		'Determines if the control is a top-level control (Windows, Linux, Android, Web).
		Declare Function GetTopLevel As Component Ptr
		'Returns/sets the distance between the internal left edge of an object and the left edge of its container (Windows, Linux, Android, Web).
		Declare Property Left As Integer
		Declare Property Left(Value As Integer)
		'Returns/sets the distance between the internal top edge of an object and the top edge of its container (Windows, Linux, Android, Web).
		Declare Property Top As Integer
		Declare Property Top(Value As Integer)
		'Returns/sets the width of an object (Windows, Linux, Android, Web).
		Declare Property Width As Integer
		Declare Property Width(Value As Integer)
		'Returns/sets the height of an object (Windows, Linux, Android, Web).
		Declare Property Height As Integer
		Declare Property Height(Value As Integer)
		'Gets the bounds of the control to the specified location and size (Windows, Linux, Android, Web).
		Declare Sub GetBounds(ByRef ALeft As Integer, ByRef ATop As Integer, ByRef AWidth As Integer, ByRef AHeight As Integer)
		'Sets the bounds of the control to the specified location and size (Windows, Linux, Android, Web).
		Declare Sub SetBounds(ALeft As Integer, ATop As Integer, AWidth As Integer, AHeight As Integer)
		'Gets a value that indicates whether the Component is currently in design mode (Windows, Linux, Android, Web).
		Declare Virtual Property DesignMode As Boolean
		Declare Virtual Property DesignMode(Value As Boolean)
		'Returns the name used in code to identify an object (Windows, Linux, Android, Web).
		Declare Property Name ByRef As WString
		Declare Property Name(ByRef Value As WString)
		'Gets or sets the parent container of the control (Windows, Linux, Android, Web).
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
	#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__) OrElse defined(__USE_APPLE__)
		'The handle of the control (code written for Windows reads it)
		hWnd     As Any Ptr
		Msg      As Integer
		wParam   As Integer
		lParam   As Integer
		Result   As Integer
		'The words of wParam / lParam like on Windows, for a control which handles the messages of Windows (EditControl)
		wParamLo As Integer
		wParamHi As Integer
		lParamLo As Integer
		lParamHi As Integer
	#endif
	Handled As Boolean
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
		Const GDK_KEY_1 = &h31
		Const GDK_KEY_2 = &h32
		Const GDK_KEY_3 = &h33
		Const GDK_KEY_4 = &h34
		Const GDK_KEY_5 = &h35
		Const GDK_KEY_6 = &h36
		Const GDK_KEY_7 = &h37
		Const GDK_KEY_8 = &h38
		Const GDK_KEY_9 = &h39
		Const GDK_KEY_0 = &h30
		Const GDK_KEY_a = &h61
		Const GDK_KEY_b = &h62
		Const GDK_KEY_c = &h63
		Const GDK_KEY_d = &h64
		Const GDK_KEY_e = &h65
		Const GDK_KEY_f = &h66
		Const GDK_KEY_g = &h67
		Const GDK_KEY_h = &h68
		Const GDK_KEY_i = &h69
		Const GDK_KEY_j = &h6a
		Const GDK_KEY_k = &h6b
		Const GDK_KEY_l = &h6c
		Const GDK_KEY_m = &h6d
		Const GDK_KEY_n = &h6e
		Const GDK_KEY_o = &h6f
		Const GDK_KEY_p = &h70
		Const GDK_KEY_q = &h71
		Const GDK_KEY_r = &h72
		Const GDK_KEY_s = &h73
		Const GDK_KEY_t = &h74
		Const GDK_KEY_u = &h75
		Const GDK_KEY_v = &h76
		Const GDK_KEY_w = &h77
		Const GDK_KEY_x = &h78
		Const GDK_KEY_y = &h79
		Const GDK_KEY_z = &h7a
		Const GDK_KEY_F13 = &hffca
		Const GDK_KEY_F14 = &hffcb
		Const GDK_KEY_F15 = &hffcc
		Const GDK_KEY_F16 = &hffcd
		Const GDK_KEY_F17 = &hffce
		Const GDK_KEY_F18 = &hffcf
		Const GDK_KEY_F19 = &hffd0
		Const GDK_KEY_F20 = &hffd1
		Const GDK_KEY_F21 = &hffd2
		Const GDK_KEY_F22 = &hffd3
		Const GDK_KEY_F23 = &hffd4
		Const GDK_KEY_F24 = &hffd5
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
	#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__) OrElse defined(__USE_APPLE__)
		'The key codes of Windows (CM_KEYDOWN of the Web / Android side); the masks are the state of the CM_KEY* messages
		Key_Esc = &h1B
		Key_Left = &h25
		Key_Right = &h27
		Key_Up = &h26
		Key_Down = &h28
		Key_Home = &h24
		Key_End = &h23
		Key_Delete = &h2E
		Key_Enter = &h0D
		ShiftMask = 1
		CtrlMask = 2
		AltMask = 4
		LockMask = 8
		Key_1 = &h31
		Key_2 = &h32
		Key_3 = &h33
		Key_4 = &h34
		Key_5 = &h35
		Key_6 = &h36
		Key_7 = &h37
		Key_8 = &h38
		Key_9 = &h39
		Key_0 = &h30
		Key_A = &h41
		Key_B = &h42
		Key_C = &h43
		Key_D = &h44
		Key_E = &h45
		Key_F = &h46
		Key_G = &h47
		Key_H = &h48
		Key_I = &h49
		Key_J = &h4A
		Key_K = &h4B
		Key_L = &h4C
		Key_M = &h4D
		Key_N = &h4E
		Key_O = &h4F
		Key_P = &h50
		Key_Q = &h51
		Key_R = &h52
		Key_S = &h53
		Key_T = &h54
		Key_U = &h55
		Key_V = &h56
		Key_W = &h57
		Key_X = &h58
		Key_Y = &h59
		Key_Z = &h5A
		F1 = &h70
		F2 = &h71
		F3 = &h72
		F4 = &h73
		F5 = &h74
		F6 = &h75
		F7 = &h76
		F8 = &h77
		F9 = &h78
		F10 = &h79
		F11 = &h7A
		F12 = &h7B
		F13 = &h7C
		F14 = &h7D
		F15 = &h7E
		F16 = &h7F
		F17 = &h80
		F18 = &h81
		F19 = &h82
		F20 = &h83
		F21 = &h84
		F22 = &h85
		F23 = &h86
		F24 = &h87
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

#ifndef __USE_WASM__
	'Greater than 0 while a pass sets the bounds of many controls (RequestAlign) or
	'rescales a whole tree (WM_DPICHANGED). In such a pass a single move or font change
	'must not repaint its control: a synchronous paint of a half finished layout costs
	'more than the move itself. The outermost pass repaints its container once at the end.
	'Every pass restores the value it found, so a stuck counter cannot stop repainting.
	Common Shared AlignLock As Integer
	'Set by a move of such a pass which really changed the bounds: only then the
	'outermost pass repaints, a pass which moved nothing leaves the container alone.
	'1 = repaint the places in AlignRgn, 2 = repaint the whole container (a rescale)
	Common Shared AlignMoved As Integer
	#ifdef __USE_WINAPI__
		'Open DeferWindowPos batch of the running pass: one call reaches the window manager
		'instead of one per moved control (about eight times faster for a large form)
		Common Shared AlignDefer As HDWP
		'Container whose children the open batch collects: all windows of one DeferWindowPos
		'batch must have the same parent, otherwise DeferWindowPos fails and drops the batch
		Common Shared AlignDeferParent As HWND
		'Greater than 0 while WM_DPICHANGED rescales a tree. Every rescaled control requests a
		'layout of its parent (a ReBar for every band, a ToolBar for every rebuild): such a
		'request only goes into the list and the outermost rescale lays out each container once
		Common Shared DpiPass As Integer
		Common Shared DpiPendingCount As Integer
		Common Shared DpiPending As Any Ptr Ptr
		'Screen region of the old and the new places of the windows moved in the pass
		Common Shared AlignRgn As HRGN
		Declare Sub AlignAddRect(ByVal pRect As RECT Ptr)
		'Notes a window whose content changed in the pass (a new font) for the repaint
		Declare Sub AlignAddWindow(ByVal hWnd As HWND)
		Declare Sub AlignClear
		'Ends the outermost pass: repaints the noted places of the container (bNow: at once)
		Declare Sub AlignRedraw(ByVal hContainer As HWND, ByVal bNow As Boolean = False)
	#endif
#endif

Declare Sub ThreadsEnter

Declare Sub ThreadsLeave

Declare Function ThreadCreate_(ByVal ProcPtr_ As Sub ( ByVal userdata As Any Ptr ), ByVal param As Any Ptr = 0, ByVal stack_size As Integer = 0) As Any Ptr

Declare Sub ComponentGetBounds Alias "ComponentGetBounds" (Ctrl As My.Sys.ComponentModel.Component Ptr, ByRef ALeft As Integer, ByRef ATop As Integer, ByRef AWidth As Integer, ByRef AHeight As Integer)

Declare Sub ComponentSetBounds Alias "ComponentSetBounds"(Ctrl As My.Sys.ComponentModel.Component Ptr, ALeft As Integer, ATop As Integer, AWidth As Integer, AHeight As Integer)

#ifdef __USE_WASM__
	'Set by TimerComponent, called by the ONTIMER export of Form.bas (always exported, even without TimerComponent)
	'(Not Common Shared: WebAssembly does not support common symbols, clang crashes)
	Extern TimerComponentProc As Sub(Id As Integer)
#elseif defined(__USE_APPLE__)
	'Set by TimerComponent, called by mffOnTimer of Control.bas (the host always calls it, even without TimerComponent)
	Extern TimerComponentProc As Sub(Id As Integer)
	'Set by Form, called by mffOnClose of Control.bas (the close button of a window): Form.CloseForm
	Extern FormCloseProc As Sub(Ctrl As Any Ptr)
#endif

#ifndef __USE_MAKE__
	#include once "Component.bas"
#endif
