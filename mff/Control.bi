'###############################################################################
'#  Control.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TControl.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.1                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "Menus.bi"
#include once "List.bi"
#include once "Graphics.bi"
#include once "Canvas.bi"
#ifndef __USE_GTK__
	#include once "win/commctrl.bi"
	#include once "win/shellapi.bi"
#endif

Using My.Sys.ComponentModel

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
			FControlParent     As Integer
			FStartPosition     As Integer
			FStyle             As Integer
			FText              As UString
			FHint              As UString
			FShowHint          As Boolean
			FAlign             As Integer
			FClientWidth       As Integer
			FClientHeight      As Integer
			FBackColor         As Integer
			FBackColorRed      As Integer
			FBackColorGreen    As Integer
			FBackColorBlue     As Integer
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
			Declare Sub ChangeExStyle(iStyle As Integer, Value As Boolean)
			Declare Sub ChangeStyle(iStyle As Integer, Value As Boolean)
			Declare Sub AddProperty(Name As String, Type As String, ByRef Comment As WString)
			Declare Function ExStyleExists(iStyle As Integer) As Boolean
			Declare Function StyleExists(iStyle As Integer) As Boolean
			Declare Property Style As Integer
			Declare Property Style(Value As Integer)
			Declare Property ExStyle As Integer
			Declare Property ExStyle(Value As Integer)
			Declare Function SelectNextControl(CurControl As Control Ptr, Prev As Boolean = False) As Control Ptr
			Declare Virtual Sub ProcessMessage(ByRef message As Message)
			Declare Virtual Sub ProcessMessageAfter(ByRef message As Message)
			OnActiveControlChanged As Sub(ByRef Sender As Control)
			#ifndef __USE_GTK__
				OnHandleIsAllocated As Sub(ByRef Sender As Control)
				OnHandleIsDestroyed As Sub(ByRef Sender As Control)
			#endif
		Public:
			Canvas        As My.Sys.Drawing.Canvas
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
			'Returns/sets the edges of the container to which a control is bound and determines how a control is resized with its parent.
			Anchor             As AnchorType
			Declare Property ID As Integer
			Declare Property ID(Value As Integer)
			'Returns/sets the border style for an object.
			Declare Property BorderStyle As Integer 'BorderStyles
			Declare Property BorderStyle(Value As Integer)
			'Returns/sets the PopupMenu associated with this control.
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
			'Returns/sets the parent container of the control.
			Declare Property Parent As Control Ptr
			Declare Property Parent(Value As Control Ptr)
			'Returns/sets which control borders are docked to its parent control and determines how a control is resized with its parent.
			Declare Property Align As Integer 'DockStyle
			Declare Property Align(Value As Integer) 'DockStyle
			'Returns/sets the width of the client area of the control.
			Declare Function ClientWidth As Integer
			'Returns/sets the height of the client area of the control.
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
			'Retrieves the form that the control is on.
			Declare Function GetForm() As Control Ptr
			'Returns the parent control that is not parented by another Forms control. Typically, this is the outermost Form that the control is contained in.
			Declare Function TopLevelControl() As Control Ptr
			'Returns a value indicating whether the control has input focus.
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
			'Invalidates the entire surface of the control and causes the control to be redrawn.
			Declare Sub Invalidate
			Declare Sub Repaint
			'Causes the control to redraw the invalidated regions within its client area.
			Declare Sub Update
			Declare Sub UpdateLock
			Declare Sub UpdateUnLock
			Declare Sub SetFocus
			'Brings the control to the front of the z-order.
			Declare Sub BringToFront
			'Sends the control to the back of the z-order.
			Declare Sub SendToBack
			Declare Sub RequestAlign(iClientWidth As Integer = -1, iClientHeight As Integer = -1, bInDraw As Boolean = False)
			'Displays the control to the user.
			Declare Sub Show
			'Conceals the control from the user.
			Declare Sub Hide
			Declare Sub SetMargins(mLeft As Integer, mTop As Integer, mRight As Integer, mBottom As Integer, NoScale As Boolean = False)
			Declare Sub Add(Ctrl As Control Ptr)
			Declare Sub AddRange cdecl(CountArgs As Integer, ...)
			Declare Sub Remove(Ctrl As Control Ptr)
			Declare Operator Cast As Any Ptr
			Declare Operator Let(ByRef Value As Control Ptr)
			Declare Constructor
			Declare Destructor
			'Raises the Create event.
			OnCreate     As Sub(ByRef Sender As Control)
			'Raises the Destroy event.
			OnDestroy    As Sub(ByRef Sender As Control)
			'Raises the DropFile event.
			OnDropFile   As Sub(ByRef Sender As Control, ByRef Filename As WString)
			'Raises the Paint event.
			OnPaint      As Sub(ByRef Sender As Control, Canvas As My.Sys.Drawing.Canvas)
			'Raises the MouseDown event.
			OnMouseDown  As Sub(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
			'Raises the MouseMove event.
			OnMouseMove  As Sub(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
			'Raises the MouseUp event.
			OnMouseUp    As Sub(ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
			'Raises the MouseWheel event.
			OnMouseWheel As Sub(ByRef Sender As Control, Direction As Integer, x As Integer, y As Integer, Shift As Integer)
			'Raises the MouseOver event.
			OnMouseOver  As Sub(ByRef Sender As Control)
			'Raises the MouseLeave event.
			OnMouseLeave As Sub(ByRef Sender As Control)
			'Raises the Click event.
			OnClick      As Sub(ByRef Sender As Control)
			'Raises the DclClick event.
			OnDblClick   As Sub(ByRef Sender As Control)
			'Raises the KeyPress event.
			OnKeyPress   As Sub(ByRef Sender As Control, Key As Byte)
			'Raises the KeyDown event.
			OnKeyDown    As Sub(ByRef Sender As Control, Key As Integer, Shift As Integer)
			'Raises the KeyUp event.
			OnKeyUp      As Sub(ByRef Sender As Control, Key As Integer, Shift As Integer)
			'Raises the Resize event.
			OnResize     As Sub(ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
			'Raises the Scroll event.
			OnScroll     As Sub(ByRef Sender As Control)
			'Raises the GotFocus event.
			OnGotFocus   As Sub(ByRef Sender As Control)
			'Raises the LostFocus event.
			OnLostFocus  As Sub(ByRef Sender As Control)
			'Raises the Update event.
			OnUpdate     As Sub(ByRef Sender As Control)
		End Type
		
		Dim Shared CreationControl As Control Ptr
	#endif
End Namespace

#ifdef __EXPORT_PROCS__
	Declare Sub RemoveControl Alias "RemoveControl"(Parent As My.Sys.Forms.Control Ptr, Ctrl As My.Sys.Forms.Control Ptr)
	
	Declare Function ControlByIndex Alias "ControlByIndex"(Parent As My.Sys.Forms.Control Ptr, Index As Integer) As My.Sys.Forms.Control Ptr
	
	Declare Function ControlByName Alias "ControlByName"(Parent As My.Sys.Forms.Control Ptr, CtrlName As String) As My.Sys.Forms.Control Ptr
	
	Declare Function IsControl Alias "IsControl"(Cpnt As My.Sys.ComponentModel.Component Ptr) As Boolean
	
	Declare Sub ControlSetFocus Alias "ControlSetFocus"(Ctrl As My.Sys.Forms.Control Ptr)
	
	Declare Sub ControlFreeWnd Alias "ControlFreeWnd"(Ctrl As My.Sys.Forms.Control Ptr)
#endif

#ifndef __USE_MAKE__
	#include once "Control.bas"
#endif
