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
#include once "IntegerList.bi"
#include once "DarkMode/DarkMode.bi"
#ifdef __USE_WINAPI__
	#include once "win/commctrl.bi"
	#include once "win/shellapi.bi"
	#include once "win/windowsx.bi"
#endif
#define WM_DPICHANGED       &h02E0

Using My.Sys.ComponentModel

Namespace My.Sys.Forms
	#ifndef Control_Off
		#define QControl(__Ptr__) (*Cast(Control Ptr,__Ptr__))
		
		Private Enum BorderStyles
			bsNone, bsClient
		End Enum
		
		Private Enum DockStyle
			alNone, alLeft, alRight, alTop, alBottom, alClient
		End Enum
		
		Private Enum AnchorStyle
			asNone
			asAnchor
			asAnchorProportional
		End Enum
		
		Private Enum AlignmentConstants
			taLeft, taCenter, taRight
		End Enum
		
		Private Enum CheckAlignmentConstants
			chLeft, chRight
		End Enum
		
		Const LVCFMT_FILL = &h200000
		
		Private Enum SortStyle
			ssNone
			ssSortAscending
			ssSortDescending
		End Enum
		
		Private Enum ListSortDirection
			sdAscending
			sdDescending
		End Enum
		
		#ifdef __USE_WINAPI__
			Private Enum ViewStyle
				vsIcon = LV_VIEW_ICON
				vsDetails = LV_VIEW_DETAILS
				vsSmallIcon = LV_VIEW_SMALLICON
				vsList = LV_VIEW_LIST
				vsTile = LV_VIEW_TILE
				vsMax = LV_VIEW_MAX
			End Enum
			
			Private Enum ColumnFormat
				cfLeft = LVCFMT_LEFT
				cfRight = LVCFMT_RIGHT
				cfCenter = LVCFMT_CENTER
				cfJustifyMask = LVCFMT_JUSTIFYMASK
				cfImage = LVCFMT_IMAGE
				cfBitmapOnRight = LVCFMT_BITMAP_ON_RIGHT
				cfColHasImages = LVCFMT_COL_HAS_IMAGES
				'cfFixedWidth = LVCFMT_FIXED_WIDTH
				'cfNoDpiScale = LVCFMT_NO_DPI_SCALE
				'cfFixedRatio = LVCFMT_FIXED_RATIO
				'cfLineBreak = LVCFMT_LINE_BREAK
				cfFill = LVCFMT_FILL
				'cfWrap = LVCFMT_WRAP
				'cfNoTitle = LVCFMT_NO_TITLE
				'cfSplitButton = LVCFMT_SPLITBUTTON
				'cfTilePlacementMask = LVCFMT_TILE_PLACEMENTMASK
			End Enum
		#else
			Private Enum ViewStyle
				vsIcon
				vsDetails
				vsSmallIcon
				vsList
				vsTile
				vsMax
			End Enum
			
			Private Enum ColumnFormat
				cfLeft
				cfRight
				cfCenter
				cfJustifyMask
				cfImage
				cfBitmapOnRight
				cfColHasImages
				'cfFixedWidth
				'cfNoDpiScale
				'cfFixedRatio
				'cfLineBreak
				cfFill
				'cfWrap
				'cfNoTitle
				'cfSplitButton
				'cfTilePlacementMask
			End Enum
		#endif
		
		Private Type SizeConstraints Extends My.Sys.Object
			Declare Function ToString ByRef As WString
			Left  As Integer
			Top    As Integer
			Width As Integer
			Height As Integer
		End Type
		
		Private Type ControlProperty
			Name As String * 50
			Type As String * 50
			Comment As WString Ptr
		End Type
		
		Private Type PControl As Control Ptr
		
		Private Type AnchorType Extends My.Sys.Object
			Declare Function ToString ByRef As WString
			Left         As Integer 'AnchorStyle
			Top          As Integer 'AnchorStyle
			Right        As Integer 'AnchorStyle
			Bottom       As Integer 'AnchorStyle
		End Type
		
		Private Type ControlCollection Extends My.Sys.Object
			
		End Type
		
		#ifdef __USE_GTK__
			Private Type MouseHoverMessageType
				Sender As PControl
				X As Double
				Y As Double
				State As Integer
				pBoolean As Boolean Ptr
				Widget As GtkWidget Ptr
			End Type
			Dim Shared MouseHoverMessage As MouseHoverMessageType
			Dim Shared hover_timer_id As UInteger
		#endif
		
		Private Type Control Extends Component
		Private:
			Tracked As Boolean
			FAnchoredLeft     As Integer
			FAnchoredTop     As Integer
			FAnchoredRight     As Integer
			FAnchoredBottom As Integer
			FAnchoredParentWidth As Integer
			FAnchoredParentHeight As Integer
		Protected:
			FAutoSize As Boolean
			FMainForm      As Boolean
			FMouseInClient As Boolean
			FOwner             As Control Ptr
			FDisposed As Boolean
			#ifdef __USE_GTK__
				FParentWidget As GtkWidget Ptr
				FClient As GtkWidget Ptr
				AllocatedHeight As Integer
				AllocatedWidth As Integer
				Declare Static Sub Control_SizeAllocate(widget As GtkWidget Ptr, allocation As GdkRectangle Ptr, user_data As Any Ptr)
				Declare Static Function Control_Draw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
				Declare Static Function Control_ExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
				Declare Static Sub DragDataReceived(self As GtkWidget Ptr, CONTEXT As GdkDragContext Ptr, x As gint, y As gint, Data As GtkSelectionData Ptr, info As guint, Time As guint, user_data As Any Ptr)
				Declare Static Function ConfigureEventProc(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
			#elseif defined(__USE_WASM__)
				FType As String
				FElementStyle As String
				Declare Virtual Function GetContent() As UString
			#elseif defined(__USE_WINAPI__)
				FParentHandle As HWND
				FClient As HWND
				As Integer FClientX, FClientY, FClientW, FClientH
				FToolInfo          As TOOLINFO
				FDarkMode          As Boolean
			#endif
			FBorderStyle       As Integer
			FExStyle           As Integer
			FAllowDrop         As Boolean
			FControlIndex      As Integer
			FControlParent     As Integer
			FStartPosition     As Integer
			FStyle             As Integer
			FText              As UString
			FHint              As WString Ptr
			FShowHint          As Boolean
			FAlign             As DockStyle
			FClientWidth       As Integer
			FClientHeight      As Integer
			FDefaultBackColor  As Integer
			FBackColor         As Integer
			FBackColorRed      As Double
			FBackColorGreen    As Double
			FBackColorBlue     As Double
			FForeColor         As Integer
			FForeColorRed      As Double
			FForeColorGreen    As Double
			FForeColorBlue     As Double
			FStoredFont        As My.Sys.Drawing.Font
			FMenu              As MainMenu Ptr
			FContextMenu       As PopupMenu Ptr
			FGrouped           As Boolean
			FTabStop           As Boolean
			FTabIndex          As Integer
			FTabIndexList      As IntegerList
			FIsChild           As Boolean
			FEnabled           As Boolean
			FVisible           As Boolean
			DownButton         As Integer = -1
			FDefaultButton     As Control Ptr
			FCancelButton      As Control Ptr
			FActiveControl     As Control Ptr
			FPopupMenuItems    As List
			FControls          As List
			FControlCount      As Integer
			PrevProc           As Any Ptr
			Child              As Any Ptr
			ChildProc          As Any Ptr 'Function(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			Brush              As My.Sys.Drawing.Brush
			CreateParam        As Any Ptr
			Declare Function EnumPopupMenuItems(ByRef Item As MenuItem) As Boolean
			Declare Function EnumControls(Item As Control Ptr) As Boolean
			Declare Sub GetPopupMenuItems
			Declare Sub GetControls
			Declare Sub ChangeExStyle(iStyle As Integer, Value As Boolean)
			Declare Sub ChangeStyle(iStyle As Integer, Value As Boolean)
			Declare Sub ChangeControlIndex(Ctrl As Control Ptr, Index As Integer)
			Declare Sub ChangeTabIndex(Value As Integer)
			Declare Sub ChangeTabStop(Value As Boolean)
			Declare Sub AddProperty(Name As String, Type As String, ByRef Comment As WString)
			Declare Function ExStyleExists(iStyle As Integer) As Boolean
			Declare Function StyleExists(iStyle As Integer) As Boolean
			Declare Property Style As Integer
			Declare Property Style(Value As Integer)
			Declare Property ExStyle As Integer
			Declare Property ExStyle(Value As Integer)
			Declare Virtual Sub Move(cLeft As Integer, cTop As Integer, cWidth As Integer, cHeight As Integer)
			OnActiveControlChanged As Sub(ByRef Sender As Control)
			OnHandleIsAllocated As Sub(ByRef Sender As Control)
			OnHandleIsDestroyed As Sub(ByRef Sender As Control)
			#ifdef __USE_GTK__
				Declare Function RegisterClass(ByRef wClassName As WString, Obj As Any Ptr, WndProcAddr As Any Ptr = 0) As Boolean
				Declare Static Function EventProc(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
				Declare Static Function EventAfterProc(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
				Declare Static Function hover_cb(ByVal user_data As gpointer) As gboolean
				Declare Static Function Control_Scroll(self As GtkScrolledWindow Ptr, scroll As GtkScrollType Ptr, Horizontal As Boolean, user_data As Any Ptr) As Boolean
			#elseif defined(__USE_WINAPI__)
				Declare Static Function RegisterClass(ByRef wClassName As WString, ByRef wClassAncestor As WString = "", WndProcAddr As Any Ptr = 0) As Integer
				Declare Static Function WindowProc(FWindow As HWND, MSG As UINT, WPARAM As WPARAM, LPARAM As LPARAM) As LRESULT
				Declare Static Function DefWndProc(FWindow As HWND, MSG As UINT, WPARAM As WPARAM, LPARAM As LPARAM) As LRESULT
				Declare Static Function CallWndProc(FWindow As HWND, MSG As UINT, WPARAM As WPARAM, LPARAM As LPARAM) As LRESULT
				Declare Static Function SuperWndProc(FWindow As HWND, MSG As UINT, WPARAM As WPARAM, LPARAM As LPARAM) As LRESULT
				Declare Function Perform(MSG As UINT, WPARAM As WPARAM, LPARAM As LPARAM) As LRESULT
				Declare Virtual Sub SetDark(Value As Boolean)
				Declare Sub AllocateHint
			#endif
			#ifdef __USE_GTK__
				Declare Property ParentWidget As GtkWidget Ptr
				Declare Property ParentWidget(Value As GtkWidget Ptr)
			#elseif defined(__USE_WINAPI__)
				Declare Property ParentHandle As HWND
				Declare Property ParentHandle(Value As HWND)
				ToolTipHandle       As HWND
			#endif
			Declare Sub GetMax(ByRef MaxWidth As Integer, ByRef MaxHeight As Integer)
			Declare Virtual Sub ProcessMessageAfter(ByRef message As Message)
		Public:
			Declare Virtual Sub ProcessMessage(ByRef message As Message)
			'Canvas is all about drawing in a container (Windows, Linux).
			Canvas        As My.Sys.Drawing.Canvas
			'Activates the next control (Windows only).
			Declare Function SelectNextControl(Prev As Boolean = False) As Control Ptr
			#ifndef ReadProperty_Off
				'Reads value from the name of property (Windows, Linux).
				Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
			#endif
			#ifndef WriteProperty_Off
				'Writes value to the name of property (Windows, Linux).
				Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			#endif
			'Returs/sets a value indicating type is subclass or not (Windows only).
			SubClass            As Boolean
			'Returns a Font object (Windows, Linux).
			Font               As My.Sys.Drawing.Font
			'Returns/sets the type of mouse pointer displayed when over part of an object (Windows, Linux).
			Cursor             As My.Sys.Drawing.Cursor
			'Specifies the default Help file context ID for an object (Windows only).
			HelpContext        As Integer
			'Specifies the size constraints for the control (Windows, Linux).
			Constraints        As SizeConstraints
			'Gets or sets a value indicating whether this control should redraw its surface using a secondary buffer to reduce or prevent flicker (Windows only)
			DoubleBuffered     As Boolean
			'Gets the collection of controls contained within the control (Windows, Linux).
			Controls           As Control Ptr Ptr
			'Returns/sets the edges of the container to which a control is bound and determines how a control is resized with its parent (Windows, Linux).
			Anchor             As AnchorType
			'Gets or sets a value indicating whether the control can accept data that the user drags onto it (Windows, Linux).
			Declare Property AllowDrop As Boolean
			Declare Property AllowDrop(Value As Boolean)
			'Gets or sets the programmatic identifier assigned to the control (Windows only).
			Declare Property ID As Integer
			Declare Property ID(Value As Integer)
			'Returns/sets the border style for an object (Windows, Linux).
			Declare Property BorderStyle As Integer 'BorderStyles
			Declare Property BorderStyle(Value As Integer)
			'Returns/sets the PopupMenu associated with this control (Windows, Linux).
			Declare Property ContextMenu As PopupMenu Ptr
			Declare Property ContextMenu(Value As PopupMenu Ptr)
			Declare Property ControlIndex As Integer
			Declare Property ControlIndex(Value As Integer)
			'Returns/sets the text contained in the control (Windows, Linux).
			Declare Virtual Property Text ByRef As WString
			Declare Virtual Property Text(ByRef Value As WString)
			'Returns/sets the text displayed when the mouse is paused over the control (Windows, Linux).
			Declare Property Hint ByRef As WString
			Declare Property Hint(ByRef Value As WString)
			'Returns/sets the value indicating show hint (Windows, Linux).
			Declare Property ShowHint As Boolean
			Declare Property ShowHint(Value As Boolean)
			'Returns/sets the coordinates of the upper-left corner of the control relative to the upper-left corner of its container.
			Declare Property Location As My.Sys.Drawing.Point
			Declare Property Location(Value As My.Sys.Drawing.Point)
			'Returns/sets the height and width of the control.
			Declare Property Size As My.Sys.Drawing.Size
			Declare Property Size(Value As My.Sys.Drawing.Size)
			'Returns/sets the background color used to display text and graphics in an object (Windows, Linux).
			Declare Property BackColor As Integer
			Declare Property BackColor(Value As Integer)
			'Returns/sets the foreground color used to display text and graphics in an object (Windows, Linux).
			Declare Property ForeColor As Integer
			Declare Property ForeColor(Value As Integer)
			'Returns/sets the parent container of the control (Windows, Linux).
			Declare Property Parent As Control Ptr
			Declare Property Parent(Value As Control Ptr)
			'Returns/sets which control borders are docked to its parent control and determines how a control is resized with its parent (Windows, Linux).
			Declare Property Align As DockStyle
			Declare Property Align(Value As DockStyle)
			'Returns/sets the width of the client area of the control (Windows, Linux).
			Declare Function ClientWidth As Integer
			'Returns/sets the height of the client area of the control (Windows, Linux).
			Declare Function ClientHeight As Integer
			'Returns/sets the value indicating the first control of a group of controls (Windows only).
			Declare Property Grouped As Boolean
			Declare Property Grouped(Value As Boolean)
			'Determines whether a window is a child window or descendant window of a specified parent window (Windows only).
			Declare Property IsChild As Boolean
			Declare Property IsChild(Value As Boolean)
			'Returns/sets a value that determines whether an object can respond to user-generated events (Windows, Linux).
			Declare Property Enabled As Boolean
			Declare Property Enabled(Value As Boolean)
			'Returns/sets a value that determines whether an object is visible or hidden (Windows, Linux).
			Declare Virtual Property Visible As Boolean
			Declare Virtual Property Visible(Value As Boolean)
			'Gets the number of controls in the Control collection (Windows, Linux).
			Declare Function ControlCount() As Integer
			'Determines the length, in characters, of the text associated with a window (Windows, Linux).
			Declare Function GetTextLength() As Integer
			'Retrieves the form that the control is on (Windows, Linux).
			Declare Function GetForm() As Control Ptr
			'Returns the parent control that is not parented by another Forms control. Typically, this is the outermost Form that the control is contained in (Windows, Linux).
			Declare Function TopLevelControl() As Control Ptr
			'Returns a value indicating whether the control has input focus (Windows, Linux).
			Declare Function Focused As Boolean
			'Retrieves the index of a specified Control object in the collection (Windows, Linux).
			Declare Function IndexOf(Ctrl As Control Ptr) As Integer
			Declare Function IndexOf(CtrlName As String) As Integer
			'Retrieves the Control object from Control name in the collection (Windows, Linux).
			Declare Function ControlByName(CtrlName As String) As Control Ptr
			'Creates the window (Windows only)
			Declare Virtual Sub CreateWnd
			'Recreates the window (Windows only)
			Declare Sub RecreateWnd
			'Destroys the specified window handle (Windows, Linux).
			Declare Sub FreeWnd
			#ifdef __USE_WINAPI__
				'Converts the client-area coordinates of a specified point to screen coordinates (Windows only).
				Declare Sub ClientToScreen(ByRef P As Point)
				'Converts the screen coordinates of a specified point on the screen to client coordinates (Windows only).
				Declare Sub ScreenToClient(ByRef P As Point)
			#endif
			'Invalidates the entire surface of the control and causes the control to be redrawn (Windows only).
			Declare Sub Invalidate
			'Forces the control to invalidate its client area and immediately redraw itself and any child controls (Windows, Linux).
			Declare Sub Repaint
			'Causes the control to redraw the invalidated regions within its client area (Windows, Linux).
			Declare Sub Update
			'Disables drawing in the specified window (Windows only).
			Declare Sub UpdateLock
			'Enables drawing in the specified window (Windows only).
			Declare Sub UpdateUnLock
			'Moves the focus to the specified form or the specified control on the active form (Windows, Linux).
			Declare Sub SetFocus
			'Brings the control to the front of the z-order (Windows only).
			Declare Sub BringToFront
			'Sends the control to the back of the z-order (Windows only).
			Declare Sub SendToBack
			'Instructs the parent of a control to reposition the control, enforcing its Align property (Windows, Linux).
			Declare Sub RequestAlign(iClientWidth As Integer = -1, iClientHeight As Integer = -1, bInDraw As Boolean = False, bWithoutControl As Control Ptr = 0)
			'Displays the control to the user (Windows, Linux).
			Declare Virtual Sub Show
			'Conceals the control from the user (Windows, Linux).
			Declare Virtual Sub Hide
			'Sets the left, top, right, bottom margins for a container control (Windows, Linux).
			Declare Sub SetMargins(mLeft As Integer, mTop As Integer, mRight As Integer, mBottom As Integer)
			'Adds the specified control to the control collection (Windows, Linux).
			Declare Virtual Sub Add(Ctrl As Control Ptr, Index As Integer = -1)
			'Adds the specified controls range to the control collection (Windows, Linux).
			Declare Sub AddRange cdecl(CountArgs As Integer, ...)
			'Removes the specified control from the control collection (Windows, Linux).
			Declare Sub Remove(Ctrl As Control Ptr)
			Declare Operator Cast As Any Ptr
			Declare Operator Let(ByRef Value As Control Ptr)
			Declare Constructor
			Declare Destructor
			'Occurs when the control is created (Windows, Linux).
			OnCreate     As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
			'Occurs when the control's handle is in the process of being destroyed (Windows, Linux).
			OnDestroy    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
			'Occurs when the user drops a file on the window of an application that has registered itself as a recipient of dropped files (Windows, Linux).
			OnDropFile   As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Filename As WString)
			'Occurs when the control is redrawn (Windows, Linux).
			OnPaint      As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
			'Occurs when the mouse pointer is moved over the control (Windows, Linux).
			OnMouseMove  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
			'Occurs when the mouse pointer is over the control and a mouse button is pressed (Windows, Linux).
			OnMouseDown  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
			'Occurs when the mouse pointer is over the control and a mouse button is released (Windows, Linux).
			OnMouseUp    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
			'Occurs when the mouse wheel moves while the control has focus (Windows, Linux).
			OnMouseWheel As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, Direction As Integer, x As Integer, y As Integer, Shift As Integer)
			'Occurs when the mouse pointer rests on the control (Windows only).
			OnMouseHover As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
			'Occurs when the mouse pointer enters the control (Windows, Linux).
			OnMouseEnter As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
			'Occurs when the mouse pointer leaves the control (Windows, Linux).
			OnMouseLeave As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
			'Occurs when the control is moved (Windows, Linux).
			OnMove       As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
			'Occurs when the control is clicked (Windows, Linux).
			OnClick      As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
			'Occurs when the control is double-clicked (Windows, Linux).
			OnDblClick   As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
			'Occurs when a character. space or backspace key is pressed while the control has focus (Windows, Linux).
			OnKeyPress   As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, Key As Integer)
			'Occurs when a key is pressed while the control has focus (Windows, Linux).
			OnKeyDown    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, Key As Integer, Shift As Integer)
			'Occurs when a key is released while the control has focus (Windows, Linux).
			OnKeyUp      As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, Key As Integer, Shift As Integer)
			'Occurs when the window receives a message (Windows, Linux).
			OnMessage    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Msg As Message)
			'Occurs when the control is resized (Windows, Linux).
			OnResize     As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
			'Occurs when the scroll box has been moved by either a mouse or keyboard action (Windows only).
			OnScroll     As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
			'Occurs when the control receives focus (Windows, Linux).
			OnGotFocus   As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
			'Occurs when the control loses focus (Windows, Linux).
			OnLostFocus  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
		End Type
		
		Dim Shared CreationControl As Control Ptr
	#endif
	#ifdef __USE_JNI__
		Dim Shared AppMainForm As Control Ptr
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

