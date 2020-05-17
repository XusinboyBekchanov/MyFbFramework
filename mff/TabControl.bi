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

Namespace My.Sys.Forms
	#define QTabControl(__Ptr__) *Cast(TabControl Ptr,__Ptr__)
	#define QTabPage(__Ptr__) *Cast(TabPage Ptr, __Ptr__)
	
	Enum TabStyle
		tsTabs,tsButtons,tsOwnerDrawFixed
	End Enum
	
	Enum TabPosition
		tpLeft,tpRight,tpTop,tpBottom
	End Enum
	
	Type PTabControl As TabControl Ptr
	
	Type TabPage Extends Panel
	Protected:
		FCaption    As WString Ptr
		FObject     As Any Ptr
		FImageIndex As Integer
		FImageKey   As WString Ptr
		#ifndef __USE_GTK__
			FTheme		As HTHEME
		#endif
	Public:
		Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Declare Sub ProcessMessage(ByRef msg As Message)
		#ifdef __USE_GTK__
			_Box			As GtkWidget Ptr
			_Icon			As GtkWidget Ptr
			_Label			As GtkWidget Ptr
		#else
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#endif
		UseVisualStyleBackColor As Boolean
		Declare Property Index As Integer
		Declare Property Caption ByRef As WString
		Declare Property Caption(ByRef Value As WString)
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Property Object As Any Ptr
		Declare Property Object(Value As Any Ptr)
		Declare Property ImageIndex As Integer
		Declare Property ImageIndex(Value As Integer)
		Declare Property ImageKey ByRef As WString
		Declare Property ImageKey(ByRef Value As WString)
		Declare Property Parent As PTabControl
		Declare Property Parent(Value As PTabControl)
		Declare Operator Let(ByRef Value As WString)
		Declare Operator Cast As Control Ptr
		Declare Operator Cast As Any Ptr
		Declare Sub SelectTab()
		Declare Sub Update()
		Declare Constructor
		Declare Destructor
		OnSelected   As Sub(ByRef Sender As TabPage)
		OnDeSelected As Sub(ByRef Sender As TabPage)
	End Type
	
	Type TabControl Extends ContainerControl
	Private:
		FTabIndex     As Integer
		FTabCount     As Integer
		FMultiline    As Boolean
		FReorderable  As Boolean
		FFlatButtons  As Boolean
		FTabPosition  As My.Sys.Forms.TabPosition
		FTabStyle     As My.Sys.Forms.TabStyle
		FMousePos     As Integer
		Declare Sub SetMargins()
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			Declare Sub ProcessMessage(ByRef Message As Message)
		#endif
	Public:
		Images        As ImageList Ptr
		Tabs             As TabPage Ptr Ptr
		Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
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
		Declare Property SelectedTab As TabPage Ptr
		Declare Property SelectedTab(Value As TabPage Ptr)
		Declare Property Tab(Index As Integer) As TabPage Ptr
		Declare Property Tab(Index As Integer, Value As TabPage Ptr)
		Declare Function ItemLeft(Index As Integer) As Integer
		Declare Function ItemTop(Index As Integer) As Integer
		Declare Function ItemWidth(Index As Integer) As Integer
		Declare Function ItemHeight(Index As Integer) As Integer
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Function IndexOfTab(Value As TabPage Ptr) As Integer
		Declare Function AddTab(ByRef Caption As WString, AObject As Any Ptr = 0, ImageIndex As Integer = -1) As TabPage Ptr
		Declare Function AddTab(ByRef Caption As WString, AObject As Any Ptr = 0, ByRef ImageKey As WString) As TabPage Ptr
		Declare Sub AddTab(ByRef tTab As TabPage Ptr)
		Declare Sub DeleteTab(Index As Integer)
		Declare Sub InsertTab(Index As Integer, ByRef Caption As WString, AObject As Any Ptr = 0)
		Declare Sub InsertTab(Index As Integer, ByRef tTab As TabPage Ptr)
		Declare Sub ReorderTab(ByVal tp As TabPage Ptr, Index As Integer)
		Declare Sub Clear
		Declare Constructor
		Declare Destructor
		OnSelChange   As Sub(ByRef Sender As TabControl, NewIndex As Integer)
		OnSelChanging As Sub(ByRef Sender As TabControl, NewIndex As Integer)
		OnGotFocus   As Sub(ByRef Sender As TabControl)
		OnLostFocus   As Sub(ByRef Sender As TabControl)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "TabControl.bas"
#endif
