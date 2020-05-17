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

#Include Once "Control.bi"

Namespace My.Sys.Forms
	#DEFINE QToolBar(__Ptr__) *Cast(ToolBar Ptr,__Ptr__)
	#DEFINE QToolButton(__Ptr__) *Cast(ToolButton Ptr,__Ptr__)
	
	'#DEFINE TBSTYLE_TRANSPARENT &H8000
	'#DEFINE TBN_DROPDOWN (TBN_FIRST - 10)
	
	Enum ToolButtonStyle
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
	
	Enum ToolButtonState
		tstIndeterminate	= 16
		tstEnabled			= 4
		tstHidden			= 8
		tstEllipses			= 64
		tstChecked			= 1
		tstPressed			= 2
		tstMarked			= 128
		tstWrap				= 32
	End Enum
	
	Type ToolButton Extends My.Sys.Object
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
		FButtonLeft   As Integer
		FButtonTop    As Integer
		FButtonWidth  As Integer
		FButtonHeight As Integer
	Protected:
		FName           As WString Ptr
	Public:
		#IfDef __USE_GTK__
			Widget As GtkWidget Ptr
		#EndIf
		DropDownMenu  As PopupMenu
		Tag           As Any Ptr
		Ctrl       As Control Ptr
		Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Declare Virtual Function ToString ByRef As WString
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
		Declare Property Style As Integer
		Declare Property Style(Value As Integer)
		Declare Property State As Integer
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
		OnClick As Sub(BYREF Sender As My.Sys.Object)
	End Type
	
	Type ToolButtons
	Private:
		FButtons As List
	Public:
		Parent   As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Item(Index As Integer) As ToolButton Ptr
		Declare Property Item(ByRef Key As WString) As ToolButton Ptr
		Declare Property Item(Index As Integer, Value As ToolButton Ptr)
		Declare Function Add(FStyle As Integer = tbsAutosize, FImageIndex As Integer = -1, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As Integer = tstEnabled) As ToolButton Ptr
		Declare Function Add(FStyle As Integer = tbsAutosize, ByRef ImageKey As WString, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As Integer = tstEnabled) As ToolButton Ptr
		Declare Sub Remove(Index As Integer)
		Declare Function IndexOf(BYREF FButton As ToolButton Ptr) As Integer
		Declare Function IndexOf(ByRef Key As WString) As Integer
		Declare Sub Clear
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	Type ToolBar Extends Control
	Private:
		FButtonWidth    As Integer
		FButtonHeight   As Integer
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
		Declare Static Sub WndProc(BYREF Message As Message)
		Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
		Declare Static Sub HandleIsDestroyed(BYREF Sender As Control)
		Declare Sub ProcessMessage(BYREF Message As Message)
		Declare Sub GetDropDownMenuItems
	Public:
		Buttons         As ToolButtons
		ImagesList      As ImageList Ptr
		HotImagesList   As ImageList Ptr
		DisabledImagesList As ImageList Ptr
		'Declare Function Buttons(Index As Integer) As ToolButton
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
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnButtonClick As Sub(BYREF Sender As ToolBar,BYREF Button As ToolButton)
	End Type
	
	#IfDef __USE_GTK__
		Declare Sub ToolButtonClicked(gtoolbutton As GtkToolButton Ptr, user_data As Any Ptr)
	#EndIf
End Namespace

#IfDef __EXPORT_PROCS__
	Declare Function ToolBarAddButtonWithImageIndex Alias "ToolBarAddButtonWithImageIndex"(tb As My.Sys.Forms.ToolBar Ptr, FStyle As Integer = My.Sys.Forms.tbsAutosize, FImageIndex As Integer = -1, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As Integer = My.Sys.Forms.tstEnabled) As My.Sys.Forms.ToolButton Ptr
	
	Declare Function ToolBarAddButtonWithImageKey Alias "ToolBarAddButtonWithImageKey"(tb As My.Sys.Forms.ToolBar Ptr, FStyle As Integer = My.Sys.Forms.tbsAutosize, ByRef ImageKey As WString, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As Integer = My.Sys.Forms.tstEnabled) As My.Sys.Forms.ToolButton Ptr
	
	Declare Sub ToolBarRemoveButton Alias "ToolBarRemoveButton"(tb As My.Sys.Forms.ToolBar Ptr, Index As Integer)
	
	Declare Function ToolBarIndexOfButton Alias "ToolBarIndexOfButton"(tb As My.Sys.Forms.ToolBar Ptr, Btn As My.Sys.Forms.ToolButton Ptr) As Integer
#EndIf

#IfNDef __USE_MAKE__
	#Include Once "ToolBar.bas"
#EndIf
