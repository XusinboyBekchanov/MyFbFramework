'###############################################################################
'#  TabControl.bi                                                              #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TTabControl.bi                                                            #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)  Liu XiaLin                              #
'###############################################################################

#include once "Panel.bi"
#include once "Menus.bi"
#include once "ImageList.bi"
#ifdef __USE_WINAPI__
	#include once "UpDown.bi"
#endif

Namespace My.Sys.Forms
	#define QTabControl(__Ptr__) (*Cast(TabControl Ptr,__Ptr__))
	#define QTabPage(__Ptr__) (*Cast(TabPage Ptr, __Ptr__))
	
	Private Enum TabStyle
		tsTabs,tsButtons,tsOwnerDrawFixed
	End Enum
	
	Private Enum TabPosition
		tpLeft,tpRight,tpTop,tpBottom
	End Enum
	
	Private Type PTabControl As TabControl Ptr
	
	'`TabPage` - Represents a single tab page in a TabControl.
	Private Type TabPage Extends Panel
	Protected:
		FCaption    As WString Ptr
		FObject     As Any Ptr
		FImageIndex As Integer
		FImageKey   As WString Ptr
		#ifndef __USE_GTK__
			FTheme		As HTHEME
		#endif
	Public:
		#ifndef ReadProperty_Off
			'Reads a property value from a stream
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Writes a property value to a stream
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Processes Windows messages for the control
		Declare Virtual Sub ProcessMessage(ByRef msg As Message)
		#ifdef __USE_GTK__
			_Box			As GtkWidget Ptr
			_Icon			As GtkWidget Ptr
			_Label			As GtkWidget Ptr
		#else
			'Checks if the window handle has been created
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#endif
		'Determines if the control uses visual style colors for background
		UseVisualStyleBackColor As Boolean
		Declare Property Index As Integer
		Declare Property Caption ByRef As WString
		'Gets or sets the text displayed in the tab page's header
		Declare Property Caption(ByRef Value As WString)
		Declare Property TabIndex As Integer
		'Gets/sets the tab order of the control within its container
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		'Indicates whether users can tab to this control
		Declare Property TabStop(Value As Boolean)
		Declare Property Text ByRef As WString
		'Gets or sets the text associated with the tab page
		Declare Property Text(ByRef Value As WString)
		Declare Property Object As Any Ptr
		'Gets/sets user-defined data associated with the tab page
		Declare Property Object(Value As Any Ptr)
		Declare Property ImageIndex As Integer
		'Gets/sets the index of the image shown in the tab header
		Declare Property ImageIndex(Value As Integer)
		Declare Property ImageKey ByRef As WString
		'Gets/sets the key of the image shown in the tab header
		Declare Property ImageKey(ByRef Value As WString)
		Declare Property Parent As PTabControl
		'Gets the parent TabControl containing this tab page
		Declare Property Parent(Value As PTabControl)
		'Returns/sets a value that determines whether an object is visible or hidden (Windows, Linux).
		Declare Virtual Property Visible As Boolean
		Declare Virtual Property Visible(Value As Boolean)
		Declare Operator Let(ByRef Value As WString)
		Declare Operator Cast As Control Ptr
		Declare Operator Cast As Any Ptr
		'Determines if this tab page is currently selected
		Declare Function IsSelected() As Boolean
		'Makes this tab page the active/selected tab
		Declare Sub SelectTab()
		'Forces the control to redraw invalid regions
		Declare Sub Update()
		Declare Constructor
		Declare Destructor
		'Triggered when the tab page becomes selected
		OnSelected   As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TabPage)
		'Triggered when the tab page loses selection
		OnDeSelected As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TabPage)
	End Type
	
	'Represents a control that contains multiple items that share the same space on the screen.
	Private Type TabControl Extends ContainerControl
	Private:
		FGroupName          As WString Ptr
		FSelectedTabIndex   As Integer
		FTabCount           As Integer
		FMultiline          As Boolean
		FDetachable         As Boolean
		FReorderable        As Boolean
		FFlatButtons        As Boolean
		FTabPosition        As My.Sys.Forms.TabPosition
		FTabStyle           As My.Sys.Forms.TabStyle
		FMousePos           As Integer
		DownTab             As TabPage Ptr
		Declare Sub SetMargins()
		#ifdef __USE_WINAPI__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Function HookChildProc(hDlg As HWND, uMsg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			'Checks if the window handle has been created
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			Declare Function GetChildTabControl(ParentHwnd As HWND, X As Integer, Y As Integer) As TabControl Ptr
		#elseif defined(__USE_GTK__)
			Declare Static Sub TabControl_SwitchPage(notebook As GtkNotebook Ptr, page As GtkWidget Ptr, page_num As UInteger, user_data As Any Ptr)
			Declare Static Sub TabControl_PageAdded(notebook As GtkNotebook Ptr, page As GtkWidget Ptr, page_num As UInteger, user_data As Any Ptr)
			Declare Static Sub TabControl_PageRemoved(notebook As GtkNotebook Ptr, page As GtkWidget Ptr, page_num As UInteger, user_data As Any Ptr)
			Declare Static Sub TabControl_PageReordered(notebook As GtkNotebook Ptr, page As GtkWidget Ptr, page_num As UInteger, user_data As Any Ptr)
		#endif
		Declare Sub SetTabPageIndex(tp As TabPage Ptr, Index As Integer)
	Protected:
		#ifdef __USE_WINAPI__
			UpDownControl As UpDown
		#endif
		'Processes Windows messages for the control
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		Images        As ImageList Ptr
		Tabs          As TabPage Ptr Ptr
		#ifndef ReadProperty_Off
			'Reads a property value from a stream
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Writes a property value to a stream
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property GroupName ByRef As WString
		Declare Property GroupName(ByRef Value As WString)
		Declare Property SelectedTabIndex As Integer
		Declare Property SelectedTabIndex(Value As Integer)
		Declare Property TabIndex As Integer
		'Gets/sets the tab order of the control within its container
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		'Indicates whether users can tab to this control
		Declare Property TabStop(Value As Boolean)
		Declare Property TabCount As Integer
		Declare Property TabCount(Value As Integer)
		Declare Property TabPosition As My.Sys.Forms.TabPosition
		Declare Property TabPosition(Value As My.Sys.Forms.TabPosition)
		Declare Property TabStyle As My.Sys.Forms.TabStyle
		Declare Property TabStyle(Value As My.Sys.Forms.TabStyle)
		Declare Property FlatButtons As Boolean
		Declare Property FlatButtons(Value As Boolean)
		Declare Property Multiline As Boolean
		Declare Property Multiline(Value As Boolean)
		Declare Property Reorderable As Boolean
		Declare Property Reorderable(Value As Boolean)
		Declare Property Detachable As Boolean
		Declare Property Detachable(Value As Boolean)
		Declare Property SelectedTab As TabPage Ptr
		Declare Property SelectedTab(Value As TabPage Ptr)
		Declare Property Tab(Index As Integer) As TabPage Ptr
		Declare Property Tab(Index As Integer, Value As TabPage Ptr)
		Declare Function ItemLeft(Index As Integer) As Integer
		Declare Function ItemTop(Index As Integer) As Integer
		Declare Function ItemWidth(Index As Integer) As Integer
		Declare Function ItemHeight(Index As Integer) As Integer
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		'Gets the zero-based index of the tab page in its parent TabControl
		Declare Function IndexOfTab(Value As TabPage Ptr) As Integer
		Declare Function AddTab(ByRef Caption As WString, AObject As Any Ptr = 0, ImageIndex As Integer = -1) As TabPage Ptr
		Declare Function AddTab(ByRef Caption As WString, AObject As Any Ptr = 0, ByRef ImageKey As WString) As TabPage Ptr
		Declare Sub AddTab(ByRef tTab As TabPage Ptr)
		Declare Sub DeleteTab(Index As Integer)
		Declare Sub DeleteTab(Value As TabPage Ptr)
		Declare Sub InsertTab(Index As Integer, ByRef Caption As WString, AObject As Any Ptr = 0)
		Declare Sub InsertTab(Index As Integer, ByRef tTab As TabPage Ptr)
		Declare Sub ReorderTab(ByVal tp As TabPage Ptr, Index As Integer, bNoActivate As Boolean = False)
		Declare Sub Clear
		Declare Constructor
		Declare Destructor
		OnSelChange    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TabControl, NewIndex As Integer)
		OnSelChanging  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TabControl, NewIndex As Integer)
		OnGotFocus     As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TabControl)
		OnLostFocus    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TabControl)
		OnTabAdded     As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TabControl, Page As TabPage Ptr, NewIndex As Integer)
		OnTabRemoved   As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TabControl, Page As TabPage Ptr, FromIndex As Integer)
		OnTabReordered As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TabControl, Page As TabPage Ptr, NewIndex As Integer)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "TabControl.bas"
#endif
