'###############################################################################
'#  StatusBar.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TStatusBar.bi                                                             #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "Control.bi"
#include once "Menus.bi"

Namespace My.Sys.Forms
	#define QStatusBar(__Ptr__) (*Cast(StatusBar Ptr, __Ptr__))
	#define QStatusPanel(__Ptr__) (*Cast(StatusPanel Ptr, __Ptr__))
	
	#ifdef __USE_GTK__
		Private Enum BevelStyle
			pbLowered
			pbNone
			pbRaised
			pbOwnerDraw
			pbRtlReading
			pbNoTabParsing
		End Enum
	#else
		Private Enum BevelStyle
			pbLowered    = 0
			pbNone       = SBT_NOBORDERS
			pbRaised     = SBT_POPOUT
			pbOwnerDraw  = SBT_OWNERDRAW
			pbRtlReading = SBT_RTLREADING
			pbNoTabParsing = SBT_NOTABPARSING
		End Enum
	#endif
	
	'`StatusPanel` - Represents an individual panel within a StatusBar control for displaying status information.
	Private Type StatusPanel Extends My.Sys.Object
	Private:
		FAlignment  As Integer
		FCaption    As WString Ptr
		FPanelIndex As Integer
		FName       As WString Ptr
		FBevel      As BevelStyle
		FWidth      As Integer
		FRealWidth  As Integer
		Declare Static Sub IconChanged(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.Icon)
	Public:
		#ifndef ReadProperty_Off
			'Deserializes from persistence stream
			Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Serializes to persistence stream
			Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Owning StatusBar instance
		StatusBarControl As My.Sys.Forms.Control Ptr
		'Returns panel's position in collection (zero-based)
		Index      As Integer
		#ifdef __USE_GTK__
			'Custom message ID for event handling
			message_id As guint
			'Internal identifier for localization support
			label As GtkWidget Ptr
		#endif
		'Gets/sets icon displayed alongside text
		Icon As My.Sys.Drawing.Icon
		Declare Property Alignment As Integer
		'Gets/sets text alignment (Left/Center/Right)
		Declare Property Alignment(Value As Integer)
		Declare Property Bevel As BevelStyle
		'Controls 3D border style (None/Sunken/Raised)
		Declare Property Bevel(Value As BevelStyle)
		Declare Property Caption ByRef As WString
		'Gets/sets displayed text content
		Declare Property Caption(ByRef Value As WString)
		Declare Property Name ByRef As WString
		'Unique programmatic identifier
		Declare Property Name(ByRef Value As WString)
		Declare Property PanelIndex As Integer
		'Gets logical position in parent StatusBar
		Declare Property PanelIndex(Value As Integer)
		Declare Property Parent As Control Ptr
		'Reference to containing StatusBar
		Declare Property Parent(Value As Control Ptr)
		Declare Property Width As Integer
		'Gets/sets design-time width (pixels or percentage)
		Declare Property Width(Value As Integer)
		Declare Property RealWidth As Integer
		Declare Operator Cast As Any Ptr
		Declare Operator Let(ByRef Value As WString)
		Declare Constructor
		Declare Destructor
	End Type
	
	'`StatusBar` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`StatusBar` - A status bar is a horizontal window at the bottom of a parent window in which an application can display various kinds of status information.
	Private Type StatusBar Extends Control
	Private:
		FSimpleText   As WString Ptr
		FSimplePanel  As Boolean
		FSizeGrip     As Boolean
		AStyle(2)     As Integer
		#ifdef __USE_GTK__
			Dim As guint context_id
		#else
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Virtual Sub ProcessMessage(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#endif
	Public:
		#ifndef ReadProperty_Off
			'Loads properties from persistence stream
			Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves properties to persistence stream
			Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Returns the number of panels in the status bar
		Count         As Integer
		'Font          As My.Sys.Drawing.Font
		Panels        As StatusPanel Ptr Ptr
		'Indexed access to individual status panels
		Declare Property Panel(Index As Integer) As StatusPanel Ptr
		'Indexed access to individual status panels
		Declare Property Panel(Index As Integer, Value As StatusPanel Ptr)
		Declare Property BackColor As Integer
		'Gets/sets the background color of the status bar
		Declare Property BackColor(Value As Integer)
		'Returns the index of a specified panel
		Declare Function IndexOf(ByRef stPanel As StatusPanel Ptr) As Integer
		Declare Property SimpleText ByRef As WString
		'Gets/sets text in single-panel mode
		Declare Property SimpleText(ByRef Value As WString)
		Declare Property SimplePanel As Boolean
		'Determines if single-panel mode is active
		Declare Property SimplePanel(Value As Boolean)
		Declare Property SizeGrip As Boolean
		'Controls visibility of the resize grip in bottom-right corner
		Declare Property SizeGrip(Value As Boolean)
		'Appends a new status panel to the bar
		Declare Function Add(ByRef wText As WString) As StatusPanel Ptr
		'Appends a new status panel to the bar
		Declare Sub Add(stPanel As StatusPanel Ptr)
		'Deletes a specific status panel
		Declare Sub Remove(Index As Integer)
		'Removes all status panels
		Declare Sub Clear
		'Moves a panel to a new position in the collection
		Declare Sub ChangePanelIndex(ByRef stPanel As StatusPanel Ptr, Index As Integer)
		'Refreshes panel layout and appearance
		Declare Sub UpdatePanels
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		'Triggered when a status panel is clicked
		OnPanelClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As StatusBar, ByRef stPanel As StatusPanel, MouseButton As Integer, x As Integer, y As Integer)
		'Raised when a status panel is double-clicked
		OnPanelDblClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As StatusBar, ByRef stPanel As StatusPanel, MouseButton As Integer, x As Integer, y As Integer)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "StatusBar.bas"
#endif
