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
	#define QToolBar(__Ptr__) *Cast(ToolBar Ptr,__Ptr__)
	#define QToolButton(__Ptr__) *Cast(ToolButton Ptr,__Ptr__)
	
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
	End Enum
	
	Private Enum ToolButtonState
		tstIndeterminate	= 16
		tstEnabled			= 4
		tstHidden			= 8
		tstEllipses			= 64
		tstChecked			= 1
		tstPressed			= 2
		tstMarked			= 128
		tstWrap				= 32
	End Enum
	
	Private Type ToolButton Extends My.Sys.Object
	Private:
		FCaption      As WString Ptr
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
			Widget    As GtkWidget Ptr
		#endif
		Ctrl          As Control Ptr
		DropDownMenu  As PopupMenu
		Tag           As Any Ptr
		Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Declare Virtual Function ToString ByRef As WString
		Declare Property ButtonIndex As Integer
		Declare Property ButtonIndex(Value As Integer)
		Declare Property Caption ByRef As WString
		Declare Property Caption(ByRef Value As WString)
		Declare Property Name ByRef As WString
		Declare Property Name(ByRef Value As WString)
		Declare Property Hint ByRef As WString
		Declare Property Hint(ByRef Value As WString)
		Declare Property ShowHint As Boolean
		Declare Property ShowHint(Value As Boolean)
		Declare Property ImageIndex As Integer
		Declare Property ImageIndex(Value As Integer)
		Declare Property ImageKey ByRef As WString
		Declare Property ImageKey(ByRef Value As WString)
		Declare Property Parent As Control Ptr
		Declare Property Parent(Value As Control Ptr)
		Declare Property Style As Integer 'ToolButtonStyle
		Declare Property Style(Value As Integer)
		Declare Property State As Integer 'ToolButtonState
		Declare Property State(Value As Integer)
		Declare Property CommandID As Integer
		Declare Property CommandID(Value As Integer)
		Declare Property Left As Integer
		Declare Property Left(Value As Integer)
		Declare Property Top As Integer
		Declare Property Top(Value As Integer)
		Declare Property Width As Integer
		Declare Property Width(Value As Integer)
		Declare Property Height As Integer
		Declare Property Height(Value As Integer)
		Declare Property Visible As Boolean
		Declare Property Visible(Value As Boolean)
		Declare Property Checked As Boolean
		Declare Property Checked(Value As Boolean)
		Declare Property Enabled As Boolean
		Declare Property Enabled(Value As Boolean)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		OnClick As Sub(ByRef Sender As My.Sys.Object)
	End Type
	
	Private Type ToolButtons Extends My.Sys.Object
	Private:
		FButtons As List
	Public:
		Parent   As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Item(Index As Integer) As ToolButton Ptr
		Declare Property Item(ByRef Key As WString) As ToolButton Ptr
		Declare Property Item(Index As Integer, Value As ToolButton Ptr)
		Declare Sub Add(Value As ToolButton Ptr, Index As Integer = -1)
		Declare Function Add(FStyle As Integer = tbsAutosize, FImageIndex As Integer = -1, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As Integer = tstEnabled) As ToolButton Ptr
		Declare Function Add(FStyle As Integer = tbsAutosize, ByRef ImageKey As WString, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As Integer = tstEnabled) As ToolButton Ptr
		Declare Sub Remove(Index As Integer)
		Declare Function IndexOf(ByRef FButton As ToolButton Ptr) As Integer
		Declare Function IndexOf(ByRef Key As WString) As Integer
		Declare Sub Clear
		Declare Sub ChangeIndex(FButton As ToolButton Ptr, Index As Integer)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
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
		FButtonsCount As Integer
		Declare Static Sub WndProc(ByRef Message As Message)
		Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		Declare Static Sub HandleIsDestroyed(ByRef Sender As Control)
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		Declare Sub GetDropDownMenuItems
		#ifdef __USE_WINAPI__
			Declare Virtual Sub SetDark(Value As Boolean)
		#endif
	Public:
		Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Buttons         As ToolButtons
		ImagesList      As ImageList Ptr
		HotImagesList   As ImageList Ptr
		DisabledImagesList As ImageList Ptr
		'Declare Function Buttons(Index As Integer) As ToolButton
		Declare Sub ChangeButtonIndex(Btn As ToolButton Ptr, Index As Integer)
		Declare Property Caption ByRef As WString
		Declare Property Caption(ByRef Value As WString)
		Declare Property AutoSize As Boolean
		Declare Property AutoSize(Value As Boolean)
		Declare Property Flat As Boolean
		Declare Property Flat(Value As Boolean)
		Declare Property List As Boolean
		Declare Property List(Value As Boolean)
		Declare Property Wrapable As Boolean
		Declare Property Wrapable(Value As Boolean)
		Declare Property Transparency As Boolean
		Declare Property Transparency(Value As Boolean)
		Declare Property Divider As Boolean
		Declare Property Divider(Value As Boolean)
		Declare Property ButtonWidth As Integer
		Declare Property ButtonWidth(Value As Integer)
		Declare Property ButtonHeight As Integer
		Declare Property ButtonHeight(Value As Integer)
		Declare Property BitmapWidth As Integer
		Declare Property BitmapWidth(Value As Integer)
		Declare Property BitmapHeight As Integer
		Declare Property BitmapHeight(Value As Integer)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnButtonClick As Sub(ByRef Sender As ToolBar, ByRef Button As ToolButton)
	End Type
	
	#ifdef __USE_GTK__
		Declare Sub ToolButtonClicked(gtoolbutton As GtkToolButton Ptr, user_data As Any Ptr)
	#endif
End Namespace

#ifdef __EXPORT_PROCS__
	Declare Function ToolBarAddButtonWithImageIndex Alias "ToolBarAddButtonWithImageIndex"(tb As My.Sys.Forms.ToolBar Ptr, FStyle As Integer = My.Sys.Forms.tbsAutosize, FImageIndex As Integer = -1, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As Integer = My.Sys.Forms.tstEnabled) As My.Sys.Forms.ToolButton Ptr
	
	Declare Function ToolBarAddButtonWithImageKey Alias "ToolBarAddButtonWithImageKey"(tb As My.Sys.Forms.ToolBar Ptr, FStyle As Integer = My.Sys.Forms.tbsAutosize, ByRef ImageKey As WString, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As Integer = My.Sys.Forms.tstEnabled) As My.Sys.Forms.ToolButton Ptr
	
	Declare Sub ToolBarRemoveButton Alias "ToolBarRemoveButton"(tb As My.Sys.Forms.ToolBar Ptr, Index As Integer)
	
	Declare Function ToolBarIndexOfButton Alias "ToolBarIndexOfButton"(tb As My.Sys.Forms.ToolBar Ptr, Btn As My.Sys.Forms.ToolButton Ptr) As Integer
#endif

#ifndef __USE_MAKE__
	#include once "ToolBar.bas"
#endif
