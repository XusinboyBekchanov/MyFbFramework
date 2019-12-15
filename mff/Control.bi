'###############################################################################
'#  Control.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TControl.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.1                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "Menus.bi"
#include once "List.bi"
#include once "Graphics.bi"
#ifndef __USE_GTK__
	#include once "win/commctrl.bi"
	#include once "win/shellapi.bi"
#endif

Using My.Sys.ComponentModel

#ifdef __USE_GTK__
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

Namespace My.Sys.Forms
	#ifndef Control_Off
		#define QControl(__Ptr__) *Cast(Control Ptr,__Ptr__)
		
		Enum BorderStyles
			bsNone, bsClient
		End Enum
		
		Enum DockStyle
			alNone, alLeft, alRight, alTop, alBottom, alClient
		End Enum
		
		Enum AnchorStyle
			asNone
			asAnchor
			asAnchorProportional
		End Enum
		
		Type SizeConstraints Extends My.Sys.Object
			Declare Function ToString ByRef As WString
			Left  As Integer
			Top    As Integer
			Width As Integer
			Height As Integer
		End Type
		
		Type ControlProperty
			Name As String * 50
			Type As String * 50
			Comment As WString Ptr
		End Type
		
		Type PControl As Control Ptr
		
		Type AnchorType Extends My.Sys.Object
			Declare Function ToString ByRef As WString
			Left         As Integer 'AnchorStyle
			Top          As Integer 'AnchorStyle
			Right        As Integer 'AnchorStyle
			Bottom       As Integer 'AnchorStyle
		End Type
		
		Type MarginsType Extends My.Sys.Object '...'
			Declare Function ToString ByRef As WString
			Left         As Integer
			Top          As Integer
			Right        As Integer
			Bottom       As Integer        
		End Type
		
		Type ControlCollection Extends My.Sys.Object '...'
			
		End Type
		
		Type Control Extends Component
			Private:
			Tracked As Boolean
			FAnchoredLeft     As Integer
			FAnchoredTop     As Integer
			FAnchoredRight     As Integer
			FAnchoredBottom As Integer
			FAnchoredParentWidth As Integer
			FAnchoredParentHeight As Integer
			#ifndef __USE_GTK__
				Dim As Rect R, RR
			#endif
			Protected:
			FID                As Integer
			FOwner             As Control Ptr
			FDisposed As Boolean
			#ifdef __USE_GTK__
				FParentWidget As GtkWidget Ptr
			#else
				FParentHandle As HWND
			#endif
			#ifdef __USE_GTK__
				AllocatedHeight As Integer
				AllocatedWidth As Integer
				Declare Static Sub Control_SizeAllocate(widget As GtkWidget Ptr, allocation As GdkRectangle Ptr, user_data As Any Ptr)
				Declare Static Function Control_Draw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
				Declare Static Function Control_ExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			#else
				FToolInfo          As TOOLINFO
			#endif
			FBorderStyle       As Integer
			FExStyle           As Integer
			FStartPosition     As Integer
			FStyle             As Integer
			FText              As WString Ptr
			FHint              As WString Ptr
			FShowHint          As Boolean
			FAlign             As Integer
			FLeft              As Integer
			FTop               As Integer
			FWidth             As Integer
			FHeight            As Integer
			FClientWidth       As Integer
			FClientHeight      As Integer
			FBackColor         As Integer
			FStoredFont        As My.Sys.Drawing.Font
			FMenu              As MainMenu Ptr
			FContextMenu       As PopupMenu Ptr
			FGrouped           As Boolean  
			FTabStop           As Boolean
			FIsChild           As Boolean
			FEnabled           As Boolean
			FVisible           As Boolean
			DownButton         As Integer = -1
			FDefaultButton     As Control Ptr
			FCancelButton      As Control Ptr
			FActiveControl     As Control Ptr
			FPopupMenuItems    As List
			FControlCount      As Integer
			PrevProc           As Any Ptr
			Child              As Any Ptr
			ChildProc          As Any Ptr 'Function(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			Brush              As My.Sys.Drawing.Brush
			CreateParam        As Any Ptr
			Declare Function EnumPopupMenuItems(Item As MenuItem) As Boolean
			Declare Sub GetPopupMenuItems
			Declare Sub AllocateHint
			Declare Sub Move(cLeft As Integer, cTop As Integer, cWidth As Integer, cHeight As Integer)
			Declare Sub ChangeExStyle(iStyle As Integer, Value As Boolean)
			Declare Sub ChangeStyle(iStyle As Integer, Value As Boolean)
			Declare Sub AddProperty(Name As String, Type As String, ByRef Comment As WString)
			Declare Function ExStyleExists(iStyle As Integer) As Boolean
			Declare Function StyleExists(iStyle As Integer) As Boolean
			Declare Property Style As Integer
			Declare Property Style(Value As Integer)
			Declare Property ExStyle As Integer
			Declare Property ExStyle(Value As Integer)
			Declare Function SelectNext(CurControl As Control Ptr, Prev As Boolean = False) As Control Ptr
			Declare Virtual Sub ProcessMessage(ByRef message As Message)
			Declare Virtual Sub ProcessMessageAfter(ByRef message As Message)
			OnActiveControlChanged As Sub(ByRef Sender As Control)
			#ifndef __USE_GTK__
				OnHandleIsAllocated As Sub(ByRef Sender As Control)
				OnHandleIsDestroyed As Sub(ByRef Sender As Control)
			#endif
			Public:
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			#ifdef __USE_GTK__
				Declare Function RegisterClass(ByRef wClassName As WString, Obj As Any Ptr, WndProcAddr As Any Ptr = 0) As Boolean
				Declare Static Function EventProc(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
				Declare Static Function EventAfterProc(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
			#else
				Declare Static Function RegisterClass(ByRef wClassName As WString, ByRef wClassAncestor As WString = "", WndProcAddr As Any Ptr = 0) As Integer
				Declare Static Function WindowProc(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
				Declare Static Function DefWndProc(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
				Declare Static Function CallWndProc(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
				Declare Static Function SuperWndProc(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
				ToolTipHandle       As HWND
			#endif
			SubClass            As Boolean
			'Returns a Font object.
			Font               As My.Sys.Drawing.Font
			'Returns/sets the type of mouse pointer displayed when over part of an object.
			Cursor             As My.Sys.Drawing.Cursor Ptr
			'Specifies the default Help file context ID for an object.
			HelpContext        As Integer
			Constraints        As SizeConstraints
			DoubleBuffered     As Boolean
			Controls           As Control Ptr Ptr
			Anchor             As AnchorType
			Margins            As MarginsType
			Declare Property ID As Integer
			Declare Property ID(Value As Integer)
			'Returns/sets the border style for an object.
			Declare Property BorderStyle As Integer 'BorderStyles
			Declare Property BorderStyle(Value As Integer)
			Declare Property ContextMenu As PopupMenu Ptr
			Declare Property ContextMenu(Value As PopupMenu Ptr)
			'Returns/sets the text contained in the control
			Declare Property Text ByRef As WString
			Declare Property Text(ByRef Value As WString)
			'Returns/sets the text displayed when the mouse is paused over the control.
			Declare Property Hint ByRef As WString
			Declare Property Hint(ByRef Value As WString)
			Declare Property ShowHint As Boolean
			Declare Property ShowHint(Value As Boolean)
			'Returns/sets the background color used to display text and graphics in an object.
			Declare Property BackColor As Integer
			Declare Property BackColor(Value As Integer)
			'
			Declare Property Parent As Control Ptr
			Declare Property Parent(Value As Control Ptr)
			'
			Declare Property Align As Integer 'DockStyle
			Declare Property Align(Value As Integer) 'DockStyle
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
			Declare Function ClientWidth As Integer
			Declare Function ClientHeight As Integer
			'Returns/sets a value indicating whether a user can use the TAB key to give the focus to an object.
			Declare Property TabStop As Boolean
			Declare Property TabStop(Value As Boolean)
			Declare Property Grouped As Boolean
			Declare Property Grouped(Value As Boolean)
			Declare Property IsChild As Boolean
			Declare Property IsChild(Value As Boolean)
			'Returns/sets a value that determines whether an object can respond to user-generated events.
			Declare Property Enabled As Boolean
			Declare Property Enabled(Value As Boolean)
			#ifdef __USE_GTK__
				Declare Property ParentWidget As GtkWidget Ptr
				Declare Property ParentWidget(Value As GtkWidget Ptr)
			#else
				Declare Property ParentHandle As HWND
				Declare Property ParentHandle(Value As HWND)
			#endif
			'Returns/sets a value that determines whether an object is visible or hidden.
			Declare Property Visible As Boolean
			Declare Property Visible(Value As Boolean)
			Declare Function ControlCount() As Integer
			Declare Function GetTextLength() As Integer
			#ifndef __USE_GTK__ 
				Declare Function Perform(Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			#endif
			Declare Function GetForm() As Control Ptr
			Declare Function TopLevelControl() As Control Ptr
			Declare Function Focused As Boolean
			Declare Function IndexOf(Ctrl As Control Ptr) As Integer
			Declare Function IndexOf(CtrlName As String) As Integer
			Declare Function ControlByName(CtrlName As String) As Control Ptr
			Declare Sub CreateWnd
			Declare Sub RecreateWnd
			Declare Sub FreeWnd
			#ifndef __USE_GTK__
				Declare Sub ClientToScreen(ByRef P As Point)
				Declare Sub ScreenToClient(ByRef P As Point)
			#endif
			Declare Sub Invalidate
			Declare Sub Repaint
			Declare Sub Update
			Declare Sub UpdateLock
			Declare Sub UpdateUnLock
			Declare Sub SetFocus
			Declare Sub BringToFront
			Declare Sub SendToBack
			Declare Sub RequestAlign(iClientWidth As Integer = -1, iClientHeight As Integer = -1, bInDraw As Boolean = False)
			Declare Sub Show
			Declare Sub Hide
			Declare Sub GetBounds(ALeft As Integer Ptr, ATop As Integer Ptr, AWidth As Integer Ptr, AHeight As Integer Ptr)
			Declare Sub SetBounds(ALeft As Integer, ATop As Integer, AWidth As Integer, AHeight As Integer)
			Declare Sub SetMargins(mLeft As Integer, mTop As Integer, mRight As Integer, mBottom As Integer)
			Declare Sub Add(Ctrl As Control Ptr)
			Declare Sub AddRange cdecl(CountArgs As Integer, ...)
			Declare Sub Remove(Ctrl As Control Ptr)
			Declare Operator Cast As Any Ptr
			Declare Operator Let(ByRef Value As Control Ptr)
			Declare Constructor
			Declare Destructor
			OnCreate     As Sub(ByRef Sender As Control)
			OnDestroy    As Sub(ByRef Sender As Control)
			OnDropFile   As Sub(ByRef Sender As Control, ByRef Filename As WString)
			OnPaint      As Sub(ByRef Sender As Control)
			OnMouseDown  As Sub(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
			OnMouseMove  As Sub(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
			OnMouseUp    As Sub(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
			OnMouseWheel As Sub(ByRef Sender As Control, Direction As Integer, x As Integer, y As Integer, Shift As Integer)
			OnMouseOver  As Sub(ByRef Sender As Control)
			OnMouseLeave As Sub(ByRef Sender As Control)
			OnClick      As Sub(ByRef Sender As Control)
			OnDblClick   As Sub(ByRef Sender As Control)
			OnKeyPress   As Sub(ByRef Sender As Control, Key As Byte)
			OnKeyDown    As Sub(ByRef Sender As Control, Key As Integer, Shift As Integer)
			OnKeyUp      As Sub(ByRef Sender As Control, Key As Integer, Shift As Integer)
			OnResize     As Sub(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
			OnScroll     As Sub(ByRef Sender As Control)
			OnGotFocus   As Sub(ByRef Sender As Control)
			OnLostFocus  As Sub(ByRef Sender As Control)
			OnUpdate     As Sub(ByRef Sender As Control)
		End Type
		
		Dim Shared CreationControl As Control Ptr
	#endif
End Namespace

#ifdef __EXPORT_PROCS__
	Declare Sub RemoveControl Alias "RemoveControl"(Parent As My.Sys.Forms.Control Ptr, Ctrl As My.Sys.Forms.Control Ptr)
	
	Declare Function ControlByIndex Alias "ControlByIndex"(Parent As My.Sys.Forms.Control Ptr, Index As Integer) As My.Sys.Forms.Control Ptr
	
	Declare Function ControlByName Alias "ControlByName"(Parent As My.Sys.Forms.Control Ptr, CtrlName As String) As My.Sys.Forms.Control Ptr
	
	Declare Sub ControlGetBounds Alias "ControlGetBounds"(Ctrl As My.Sys.Forms.Control Ptr, ALeft As Integer Ptr, ATop As Integer Ptr, AWidth As Integer Ptr, AHeight As Integer Ptr)
	
	Declare Sub ControlSetBounds Alias "ControlSetBounds"(Ctrl As My.Sys.Forms.Control Ptr, ALeft As Integer, ATop As Integer, AWidth As Integer, AHeight As Integer)
	
	Declare Function IsControl Alias "IsControl"(Cpnt As My.Sys.ComponentModel.Component Ptr) As Boolean
	
	Declare Sub ControlSetFocus Alias "ControlSetFocus"(Ctrl As My.Sys.Forms.Control Ptr)
	
	Declare Sub ControlFreeWnd Alias "ControlFreeWnd"(Ctrl As My.Sys.Forms.Control Ptr)
#endif

#IfNDef __USE_MAKE__
	#Include Once "Control.bas"
#EndIf
