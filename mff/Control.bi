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
#include once "NotifyIcon.bi"
#include once "DarkMode/DarkMode.bi"
#ifdef __USE_WINAPI__
	#include once "win/commctrl.bi"
	#include once "win/shellapi.bi"
	#include once "win/shlobj.bi"
	#include once "win/windowsx.bi"
	#include once "CDropTarget/CDropTarget.bi"
	#include once "CDropSource/CDropSource.bi"
	#include once "CDataObject/CDataObject.bi"
#endif
#define WM_DPICHANGED               &h02E0
#define WM_DPICHANGED_BEFOREPARENT  &h02E2
#define WM_DPICHANGED_AFTERPARENT   &h02E3
#define WM_GETDPISCALEDSIZE         &h02E4

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
		
		Private Type CompareParaType
			Parent        As Any Ptr
			SortIndex     As Integer
			SortOrder     As SortStyle
			SortOrderLast As SortStyle
			SortAsNumber  As Boolean
			MatchCase     As Boolean
		End Type
		
		Enum DataFormats
			dfText = 1
			dfBitmap = 2
			dfMetaFilePict = 3
			dfSylk = 4
			dfDif = 5
			dfTIFF = 6
			dfOEMText = 7
			dfDIB = 8
			dfPalette = 9
			dfPenData = 10
			dfRIFF = 11
			dfWave = 12
			dfUnicodeText = 13
			dfENHMetaFile = 14
			dfHDrop = 15
			dfLocale = 16
			dfDIBV5 = 17
			dfMax = 18
		End Enum
		
		Enum DragDropEffects
			deScroll = -2147483648
			deAll = -2147483648
			deNone = 0
			deCopy = 1
			deMove = 2
			deLink = 4
		End Enum
		
		Enum DragAction
			daContinue = 0
			daDrop = 1
			daCancel = 2
		End Enum
		
		Type DataObject
			#ifdef __USE_WINAPI__
				Dim As IDataObject Ptr pDataObject
			#else
				Dim As Any Ptr pDataObject
			#endif
			Declare Function GetDataPresent(DataType As DataFormats) As Boolean
			Declare Function GetData(DataType As DataFormats) As Any Ptr
			Declare Sub GetFileDropList(filePaths() As UString)
			Declare Sub SetData(DataType As DataFormats, pData As Any Ptr, Bytes As Integer = 0)
			Declare Sub SetFileDropList(filePaths() As UString)
		End Type
	
		Private Enum StretchMode
			smNone, smStretch, smStretchProportional
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
			FHorizontalSpacing As Integer
			FVerticalSpacing As Integer
			FLastNotifyIcon As NotifyIcon Ptr
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
				FClass As String
				Declare Virtual Function GetContent() As UString
			#elseif defined(__USE_WINAPI__)
				FParentHandle As HWND
				FClient As HWND
				As Integer FClientX, FClientY, FClientW, FClientH
				FToolInfo          As TOOLINFO
				FDarkMode          As Boolean
				FDropTarget        As CDropTarget
				FDropSource        As CDropSource
			#endif
			FBorderStyle       As Integer
			FExStyle           As Integer
			FAllowDrop         As Boolean
			FAllowDropFiles    As Boolean
			FControlIndex      As Integer
			FControlParent     As Integer
			FStartPosition     As Integer
			FStyle             As Integer
			FText              As UString
			FHint              As WString Ptr
			FProgID             As WString Ptr
			FShowCaption       As Boolean
			FShowHint          As Boolean
			FAlign             As DockStyle
			FClientWidth       As Integer
			FClientHeight      As Integer
			FCurrent           As My.Sys.Drawing.Point
			FDefaultBackColor  As Integer
			FBackColor         As Integer
			FBackColorRed      As Double
			FBackColorGreen    As Double
			FBackColorBlue     As Double
			FDefaultForeColor  As Integer
			FForeColor         As Integer
			FForeColorRed      As Double
			FForeColorGreen    As Double
			FForeColorBlue     As Double
			FHoverTime         As Integer
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
				'Reads value from the name of property (Windows, Linux, Android, Web).
				Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
			#endif
			#ifndef WriteProperty_Off
				'Writes value to the name of property (Windows, Linux, Android, Web).
				Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			#endif
			'Returs/sets a value indicating type is subclass or not (Windows only).
			SubClass            As Boolean
			'Returns a Font object (Windows, Linux, Web).
			Font               As My.Sys.Drawing.Font
			'Returns/sets the type of mouse pointer displayed when over part of an object (Windows, Linux).
			Cursor             As My.Sys.Drawing.Cursor
			'Specifies the default Help file context ID for an object (Windows only).
			HelpContext        As Integer
			'Specifies the size constraints for the control (Windows, Linux, Android, Web).
			Constraints        As SizeConstraints
			'Gets or sets a value indicating whether this control should redraw its surface using a secondary buffer to reduce or prevent flicker (Windows only)
			DoubleBuffered     As Boolean
			'Gets the collection of controls contained within the control (Windows, Linux, Android, Web).
			Controls           As Control Ptr Ptr
			'Returns/sets the edges of the container to which a control is bound and determines how a control is resized with its parent (Windows, Linux, Android, Web).
			Anchor             As AnchorType
			'Gets or sets a value indicating whether the control can accept data that the user drags onto it (Windows, Linux).
			Declare Property AllowDrop As Boolean
			Declare Property AllowDrop(Value As Boolean)
			'Gets or sets a value indicating whether the control can accept files that the user drags onto it (Windows, Linux).
			Declare Property AllowDropFiles As Boolean
			Declare Property AllowDropFiles(Value As Boolean)
			'Gets or sets the programmatic identifier assigned to the control (Windows, Android).
			Declare Property ID As Integer
			Declare Property ID(Value As Integer)
			'Returns/sets the border style for an object (Windows, Linux).
			Declare Property BorderStyle As Integer 'BorderStyles
			Declare Property BorderStyle(Value As Integer)
			'Returns/sets the PopupMenu associated with this control (Windows, Linux).
			Declare Property ContextMenu As PopupMenu Ptr
			Declare Property ContextMenu(Value As PopupMenu Ptr)
			'Returns/sets the object's index within the parent object's children collection (Windows, Linux, Android, Web).
			Declare Property ControlIndex As Integer
			Declare Property ControlIndex(Value As Integer)
			'Returns/sets the text contained in the control (Windows, Linux, Android, Web).
			Declare Virtual Property Text ByRef As WString
			Declare Virtual Property Text(ByRef Value As WString)
			'Returns/sets the text displayed when the mouse is paused over the control (Windows, Linux).
			Declare Property Hint ByRef As WString
			Declare Property Hint(ByRef Value As WString)
			'Returns/sets the value indicating show Caption. (Windows only).
			Declare Property ShowCaption As Boolean
			Declare Property ShowCaption(Value As Boolean)
			'Returns/sets the value indicating show hint (Windows, Linux).
			Declare Property ShowHint As Boolean
			Declare Property ShowHint(Value As Boolean)
			'Returns/sets the coordinates of the upper-left corner of the text layout relative to the upper-left corner of its container (Windows only).
			Declare Property Current As My.Sys.Drawing.Point
			Declare Property Current(Value As My.Sys.Drawing.Point)
			'Returns/sets the coordinates of the upper-left corner of the control relative to the upper-left corner of its container (Windows, Linux, Android, Web).
			Declare Property Location As My.Sys.Drawing.Point
			Declare Property Location(Value As My.Sys.Drawing.Point)
			'Returns/sets the height and width of the control (Windows, Linux, Android, Web).
			Declare Property Size As My.Sys.Drawing.Size
			Declare Property Size(Value As My.Sys.Drawing.Size)
			'Returns/sets the background color used to display text and graphics in an object (Windows, Linux, Web).
			Declare Property BackColor As Integer
			Declare Property BackColor(Value As Integer)
			'Returns/sets the foreground color used to display text and graphics in an object (Windows, Web).
			Declare Property ForeColor As Integer
			Declare Property ForeColor(Value As Integer)
			'Determines the time interval, after which the element, over which the mouse cursor hovers, is highlighted (Windows, Linux).
			Declare Property HoverTime As Integer
			Declare Property HoverTime(Value As Integer)
			'Returns/sets the parent container of the control (Windows, Linux, Android, Web).
			Declare Property Parent As Control Ptr
			Declare Property Parent(Value As Control Ptr)
			'Returns/sets which control borders are docked to its parent control and determines how a control is resized with its parent (Windows, Linux, Android, Web).
			Declare Property Align As DockStyle
			Declare Property Align(Value As DockStyle)
			'Returns/sets the width of the client area of the control (Windows, Linux, Android, Web).
			Declare Function ClientWidth As Integer
			'Returns/sets the height of the client area of the control (Windows, Linux, Android, Web).
			Declare Function ClientHeight As Integer
			'Returns/sets the value indicating the first control of a group of controls (Windows only).
			Declare Property Grouped As Boolean
			Declare Property Grouped(Value As Boolean)
			'Determines whether a window is a child window or descendant window of a specified parent window (Windows, Linux).
			Declare Property IsChild As Boolean
			Declare Property IsChild(Value As Boolean)
			'Returns/sets a value that determines whether an object can respond to user-generated events (Windows, Linux).
			Declare Property Enabled As Boolean
			Declare Property Enabled(Value As Boolean)
			'Returns/sets a value that determines whether an object is visible or hidden (Windows, Linux, Web).
			Declare Virtual Property Visible As Boolean
			Declare Virtual Property Visible(Value As Boolean)
			'Gets the number of controls in the Control collection (Windows, Linux, Android, Web).
			Declare Function ControlCount() As Integer
			'Determines the length, in characters, of the text associated with a window (Windows, Linux, Android, Web).
			Declare Function GetTextLength() As Integer
			'Retrieves the form that the control is on (Windows, Linux, Android, Web).
			Declare Function GetForm() As Control Ptr
			'Begins a drag operation (Windows only)
			Declare Function DoDragDrop(ByRef DataObject As DataObject, AllowedEffects As DragDropEffects) As DragDropEffects
			'Returns the parent control that is not parented by another Forms control. Typically, this is the outermost Form that the control is contained in (Windows, Linux, Android, Web).
			Declare Function TopLevelControl() As Control Ptr
			'Returns a value indicating whether the control has input focus (Windows, Linux).
			Declare Function Focused As Boolean
			'Retrieves the index of a specified Control object in the collection (Windows, Linux, Android, Web).
			Declare Function IndexOf(Ctrl As Control Ptr) As Integer
			Declare Function IndexOf(CtrlName As String) As Integer
			'Retrieves the Control object from Control name in the collection (Windows, Linux, Android, Web).
			Declare Function ControlByName(CtrlName As String) As Control Ptr
			'Creates the window (Windows, Android, Web)
			Declare Virtual Sub CreateWnd
			'Recreates the window (Windows only)
			Declare Sub RecreateWnd
			'Destroys the specified window handle (Windows, Linux).
			Declare Sub FreeWnd
			'Converts the client-area coordinates of a specified point to screen coordinates (Windows only).
			Declare Sub ClientToScreen(ByRef P As My.Sys.Drawing.Point)
			'Converts the screen coordinates of a specified point on the screen to client coordinates (Windows only).
			Declare Sub ScreenToClient(ByRef P As My.Sys.Drawing.Point)
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
			'Brings the control to the front of the z-order (Windows, Linux).
			Declare Sub BringToFront
			'Sends the control to the back of the z-order (Windows, Linux).
			Declare Sub SendToBack
			'Instructs the parent of a control to reposition the control, enforcing its Align property (Windows, Linux, Android, Web).
			Declare Sub RequestAlign(iClientWidth As Integer = -1, iClientHeight As Integer = -1, bInDraw As Boolean = False, bWithoutControl As Control Ptr = 0)
			'Displays the control to the user (Windows, Linux, Android, Web).
			Declare Virtual Sub Show
			'Conceals the control from the user (Windows, Linux, Android, Web).
			Declare Virtual Sub Hide
			'Sets the left, top, right, bottom margins for a container control (Windows, Linux, Android, Web).
			Declare Sub SetMargins(mLeft As Integer, mTop As Integer, mRight As Integer, mBottom As Integer)
			'Adds the specified control to the control collection (Windows, Linux, Android, Web).
			Declare Virtual Sub Add(Ctrl As Control Ptr, Index As Integer = -1)
			'Adds the specified controls range to the control collection (Windows, Linux, Android, Web).
			Declare Sub AddRange cdecl(CountArgs As Integer, ...)
			'Removes the specified control from the control collection (Windows, Linux, Android, Web).
			Declare Sub Remove(Ctrl As Control Ptr)
			Declare Operator Cast As Any Ptr
			Declare Operator Let(ByRef Value As Control Ptr)
			Declare Constructor
			Declare Destructor
			'Occurs when the control is created (Windows, Linux, Android, Web).
			OnCreate     As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
			'Occurs when the control's handle is in the process of being destroyed (Windows, Linux, Android, Web).
			OnDestroy    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
			'Occurs when a drag-and-drop operation is completed (Windows only).
			OnDragDrop   As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef DataObject As DataObject, AllowedEffect As DragDropEffects, Effect As DragDropEffects, KeyState As ULong, X As Integer, Y As Integer)
			'Occurs when an object is dragged into the control's bounds (Windows only).
			OnDragEnter  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef DataObject As DataObject, AllowedEffect As DragDropEffects, Effect As DragDropEffects, KeyState As ULong, X As Integer, Y As Integer)
			'Occurs when an object is dragged out of the control's bounds (Windows only).
			OnDragLeave  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
			'Occurs when an object is dragged while the mouse pointer is within the control's bounds (Windows only).
			OnDragOver   As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef DataObject As DataObject, AllowedEffect As DragDropEffects, Effect As DragDropEffects, KeyState As ULong, X As Integer, Y As Integer)
			'Occurs when the user drops a file on the window of an application that has registered itself as a recipient of dropped files (Windows, Linux).
			OnDropFile   As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Filename As WString)
			'Occurs during a drag operation (Windows only).
			OnGiveFeedback As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Effect As DragDropEffects, UseDefaultCursors As Boolean)
			'Occurs when the control is redrawn (Windows, Linux).
			OnPaint      As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
			'Occurs during a drag-and-drop operation and enables the drag source to determine whether the drag-and-drop operation should be canceled (Windows only).
			OnQueryContinueDrag As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, Action As DragAction, EscapePressed As Boolean, KeyState As ULong)
			'Occurs when the mouse pointer is moved over the control (Windows, Linux, Web).
			OnMouseMove  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
			'Occurs when the mouse pointer is over the control and a mouse button is pressed (Windows, Linux, Web).
			OnMouseDown  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
			'Occurs when the mouse pointer is over the control and a mouse button is released (Windows, Linux, Web).
			OnMouseUp    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
			'Occurs when the mouse wheel moves while the control has focus (Windows, Linux, Web).
			OnMouseWheel As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, Direction As Integer, x As Integer, y As Integer, Shift As Integer)
			'Occurs when the mouse pointer rests on the control (Windows only).
			OnMouseHover As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer)
			'Occurs when the mouse pointer enters the control (Windows, Linux, Web).
			OnMouseEnter As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
			'Occurs when the mouse pointer leaves the control (Windows, Linux, Web).
			OnMouseLeave As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
			'Occurs when the control is moved (Windows, Linux).
			OnMove       As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
			'Occurs when the control is clicked (Windows, Linux, Android, Web).
			OnClick      As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
			'Occurs when the control is double-clicked (Windows, Linux, Web).
			OnDblClick   As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
			'Occurs when a character. space or backspace key is pressed while the control has focus (Windows, Linux, Web).
			OnKeyPress   As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, Key As Integer)
			'Occurs when a key is pressed while the control has focus (Windows, Linux, Web).
			OnKeyDown    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, Key As Integer, Shift As Integer)
			'Occurs when a key is released while the control has focus (Windows, Linux, Web).
			OnKeyUp      As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, Key As Integer, Shift As Integer)
			'Occurs when the window receives a message (Windows, Linux).
			OnMessage    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Msg As Message)
			'Occurs when the control is resized (Windows, Linux, Android).
			OnResize     As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, NewWidth As Integer, NewHeight As Integer)
			'Occurs when the scroll box has been moved by either a mouse or keyboard action (Windows, Linux).
			OnScroll     As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
			'Occurs when the control receives focus (Windows, Linux, Web).
			OnGotFocus   As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
			'Occurs when the control loses focus (Windows, Linux, Web).
			OnLostFocus  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control)
		End Type
		
		Dim Shared CreationControl As Control Ptr
	#endif
	#ifdef __USE_JNI__
		Dim Shared AppMainForm As Control Ptr
	#endif
End Namespace

#ifdef __USE_WINAPI__
	#include once "CDropTarget/CDropTarget.bas"
	#include once "CDropSource/CDropSource.bas"
#endif

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

