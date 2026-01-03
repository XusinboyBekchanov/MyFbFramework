'###############################################################################
'#  ToolBar.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TToolBar.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "Control.bi"

Namespace My.Sys.Forms
	#define QToolBar(__Ptr__) (*Cast(ToolBar Ptr, __Ptr__))
	#define QToolButton(__Ptr__) (*Cast(ToolButton Ptr, __Ptr__))
	
	'#DEFINE TBSTYLE_TRANSPARENT &H8000
	'#DEFINE TBN_DROPDOWN (TBN_FIRST - 10)
	
	Private Enum ToolButtonStyle
		tbsAutosize      = 16
		tbsButton        = 0
		tbsCheck         = 2
		tbsCheckGroup    = 6
		tbsGroup         = 4
		tbsDropDown      = 8
		tbsNoPrefix      = 32
		tbsSeparator     = 1
		tbsShowText      = 64
		tbsWholeDropdown = 128
		tbsCustom = 3
	End Enum
	
	Private Enum ToolButtonState
		tstNone             = 0
		tstIndeterminate    = 16
		tstEnabled          = 4
		tstHidden           = 8
		tstEllipses         = 64
		tstChecked          = 1
		tstPressed          = 2
		tstMarked           = 128
		tstWrap             = 32
	End Enum
	
	'`ToolButton` - Represents a button item in a toolbar, supporting icons, text, dropdown menus, and state management (Windows, Linux).
	Private Type ToolButton Extends My.Sys.Object
	Private:
		FCaption      As WString Ptr
		FChild        As Control Ptr
		FImageIndex   As Integer
		FImageKey     As WString Ptr
		FStyle        As Integer
		FState        As Integer
		FHint         As WString Ptr
		FShowHint     As Boolean
		FDown         As Boolean
		FWidth        As Integer
		FHeight       As Integer
		FVisible      As Boolean
		FEnabled      As Boolean
		FExpand       As Boolean
		FChecked      As Boolean
		FCommandID    As Integer
		FButtonIndex  As Integer
		FButtonLeft   As Integer
		FButtonTop    As Integer
		FButtonWidth  As Integer
		FButtonHeight As Integer
	Protected:
		FName         As WString Ptr
	Public:
		#ifdef __USE_GTK__
			'Native UI toolkit handle
			Widget    As GtkWidget Ptr
		#endif
		'Associated control for advanced interactions
		Ctrl          As Control Ptr
		'Context menu for dropdown-style buttons
		DropDownMenu  As PopupMenu
		'Custom data storage object
		Tag           As Any Ptr
		#ifndef ReadProperty_Off
			'Loads state from persistence stream
			Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves state to persistence stream
			Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Virtual Function ToString ByRef As WString
		Declare Property ButtonIndex As Integer
		'Gets the zero-based position in parent toolbar
		Declare Property ButtonIndex(Value As Integer)
		Declare Property Caption ByRef As WString
		'Display text for the button
		Declare Property Caption(ByRef Value As WString)
		Declare Property Child As Control Ptr
		'Embedded child control (e.g., combobox)
		Declare Property Child(Value As Control Ptr)
		Declare Property Name ByRef As WString
		'Programmatic identifier
		Declare Property Name(ByRef Value As WString)
		Declare Property Hint ByRef As WString
		'Tooltip text displayed on hover
		Declare Property Hint(ByRef Value As WString)
		Declare Property ShowHint As Boolean
		'Determines tooltip visibility
		Declare Property ShowHint(Value As Boolean)
		Declare Property ImageIndex As Integer
		'ImageList index for default icon
		Declare Property ImageIndex(Value As Integer)
		Declare Property ImageKey ByRef As WString
		'ImageList key for default icon
		Declare Property ImageKey(ByRef Value As WString)
		Declare Property Parent As Control Ptr
		'Containing toolbar reference
		Declare Property Parent(Value As Control Ptr)
		Declare Property Style As ToolButtonStyle
		'Display mode (Button/DropDown/Separator)
		Declare Property Style(Value As ToolButtonStyle)
		Declare Property State As ToolButtonState
		'Current visual state (Normal/Hot/Pressed/Disabled)
		Declare Property State(Value As ToolButtonState)
		Declare Property CommandID As Integer
		'Unique identifier for command routing
		Declare Property CommandID(Value As Integer)
		Declare Property Left As Integer
		'X-coordinate relative to parent
		Declare Property Left(Value As Integer)
		Declare Property Top As Integer
		'Y-coordinate relative to parent
		Declare Property Top(Value As Integer)
		Declare Property Width As Integer
		'Rendered width in pixels
		Declare Property Width(Value As Integer)
		Declare Property Height As Integer
		'Rendered height in pixels
		Declare Property Height(Value As Integer)
		Declare Property Visible As Boolean
		'Rendering visibility toggle
		Declare Property Visible(Value As Boolean)
		Declare Property Checked As Boolean
		'Toggles pressed/checked visual state
		Declare Property Checked(Value As Boolean)
		Declare Property Enabled As Boolean
		'Controls interactive availability
		Declare Property Enabled(Value As Boolean)
		Declare Property Expand As Boolean
		'Enables stretch-to-fill spacing behavior
		Declare Property Expand(Value As Boolean)
		'Forces visual refresh
		Declare Sub Update()
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		'Raised when activated via click/touch
		OnClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object)
	End Type
	
	Private Type ToolButtons Extends My.Sys.Object
	Private:
		FButtons As List
		#ifdef __USE_GTK__
			Declare Static Sub ToolButtonClicked(gtoolbutton As GtkToolButton Ptr, user_data As Any Ptr)
		#endif
	Public:
		'Containing toolbar reference
		Parent   As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Item(Index As Integer) As ToolButton Ptr
		Declare Property Item(ByRef Key As WString) As ToolButton Ptr
		Declare Property Item(Index As Integer, Value As ToolButton Ptr)
		Declare Function Add(Value As ToolButton Ptr, Index As Integer = -1) As ToolButton Ptr
		Declare Function Add(FStyle As ToolButtonStyle = tbsAutosize, FImageIndex As Integer = -1, Index As Integer = -1, FClick As NotifyEvent = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As ToolButtonState = tstEnabled) As ToolButton Ptr
		Declare Function Add(FStyle As ToolButtonStyle = tbsAutosize, ByRef ImageKey As WString, Index As Integer = -1, FClick As NotifyEvent = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As ToolButtonState = tstEnabled) As ToolButton Ptr
		Declare Sub Remove(Index As Integer)
		Declare Function IndexOf(ByRef FButton As ToolButton Ptr) As Integer
		Declare Function IndexOf(ByRef Key As WString) As Integer
		Declare Sub Clear
		Declare Sub ChangeIndex(FButton As ToolButton Ptr, Index As Integer)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	'`ToolBar` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`ToolBar` - A toolbar is a control that contains one or more buttons (Windows, Linux).
	Private Type ToolBar Extends Control
	Private:
		FButtonWidth    As Integer
		FButtonHeight   As Integer
		FBitmapWidth    As Integer
		FBitmapHeight   As Integer
		FColor          As Integer
		FAutosize       As Boolean
		FFlat           As Boolean
		FList           As Boolean
		FDivider        As Boolean
		FVisible        As Boolean
		FEnabled        As Boolean
		FTransparent    As Boolean
		FWrapable       As Integer
		ATransparent(2) As Integer
		AFlat(2)        As Integer
		ADivider(2)     As Integer
		AAutosize(2)    As Integer
		AList(2)        As Integer
		AState(6)       As Integer
		AWrap(2)        As Integer
		FButtons        As List
		FButtonsCount   As Integer
		bDropdownIndex  As Integer = -1
		Declare Static Sub WndProc(ByRef Message As Message)
		Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		Declare Static Sub HandleIsDestroyed(ByRef Sender As Control)
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		Declare Sub GetDropDownMenuItems
		#ifdef __USE_WINAPI__
			Declare Virtual Sub SetDark(Value As Boolean)
		#endif
	Public:
		#ifndef ReadProperty_Off
			'Loads properties from serialization stream
			Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves properties to serialization stream
			Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Collection of ToolButton objects in the toolbar
		Buttons         As ToolButtons
		'Default ImageList for button images
		ImagesList      As ImageList Ptr
		'ImageList containing hover state button images
		HotImagesList   As ImageList Ptr
		'ImageList containing disabled state button images
		DisabledImagesList As ImageList Ptr
		'Collection of ToolButton objects in the toolbar
		'Declare Function Buttons(Index As Integer) As ToolButton
		Declare Sub ChangeButtonIndex(Btn As ToolButton Ptr, Index As Integer)
		Declare Property Caption ByRef As WString
		'Gets/sets the toolbar's display text (when applicable)
		Declare Property Caption(ByRef Value As WString)
		Declare Property AutoSize As Boolean
		'Determines if toolbar automatically adjusts height to fit buttons
		Declare Property AutoSize(Value As Boolean)
		Declare Property Flat As Boolean
		'Enables flat-style appearance without 3D borders
		Declare Property Flat(Value As Boolean)
		Declare Property List As Boolean
		'Enables text display alongside images on buttons
		Declare Property List(Value As Boolean)
		Declare Property Wrapable As Boolean
		'Allows buttons to wrap to new line when resized
		Declare Property Wrapable(Value As Boolean)
		Declare Property Transparency As Boolean
		'Sets opacity level (0-255 where 255 is fully opaque)
		Declare Property Transparency(Value As Boolean)
		Declare Property Divider As Boolean
		'Determines if a divider line is shown above the toolbar
		Declare Property Divider(Value As Boolean)
		Declare Property ButtonWidth As Integer
		'Gets/sets the width of toolbar buttons
		Declare Property ButtonWidth(Value As Integer)
		Declare Property ButtonHeight As Integer
		'Gets/sets the height of toolbar buttons
		Declare Property ButtonHeight(Value As Integer)
		Declare Property BitmapWidth As Integer
		'Gets/sets the width of button images in pixels
		Declare Property BitmapWidth(Value As Integer)
		Declare Property BitmapHeight As Integer
		'Gets/sets the height of button images in pixels
		Declare Property BitmapHeight(Value As Integer)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		'Raised when any toolbar button is clicked
		OnButtonClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ToolBar, ByRef Button As ToolButton)
	End Type
	
	#ifdef __USE_GTK__
		Declare Sub ToolButtonClicked(gtoolbutton As GtkToolButton Ptr, user_data As Any Ptr)
	#endif
End Namespace

#ifdef __EXPORT_PROCS__
	Declare Function ToolBarAddButtonWithImageIndex Alias "ToolBarAddButtonWithImageIndex" (tb As My.Sys.Forms.ToolBar Ptr, FStyle As ToolButtonStyle = My.Sys.Forms.tbsAutosize, FImageIndex As Integer = -1, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As ToolButtonState = My.Sys.Forms.tstEnabled) As My.Sys.Forms.ToolButton Ptr
	
	Declare Function ToolBarAddButtonWithImageKey Alias "ToolBarAddButtonWithImageKey"(tb As My.Sys.Forms.ToolBar Ptr, FStyle As ToolButtonStyle = My.Sys.Forms.tbsAutosize, ByRef ImageKey As WString, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As ToolButtonState = My.Sys.Forms.tstEnabled) As My.Sys.Forms.ToolButton Ptr
	
	Declare Sub ToolBarRemoveButton Alias "ToolBarRemoveButton"(tb As My.Sys.Forms.ToolBar Ptr, Index As Integer)
	
	Declare Function ToolBarIndexOfButton Alias "ToolBarIndexOfButton"(tb As My.Sys.Forms.ToolBar Ptr, Btn As My.Sys.Forms.ToolButton Ptr) As Integer
#endif

#ifndef __USE_MAKE__
	#include once "ToolBar.bas"
#endif
