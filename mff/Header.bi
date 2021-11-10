'###############################################################################
'#  Header.bi                                                                  #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   THeader.bi                                                                #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Modified by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                      #
'###############################################################################

#include once "Control.bi"
#include once "ImageList.bi"
#include once "List.bi"

Namespace My.Sys.Forms
	#define QHeader(__Ptr__) *Cast(Header Ptr,__Ptr__)
	#define QHeaderSection(__Ptr__) *Cast(HeaderSection Ptr, __Ptr__)
	
	Private Type PHeaderControl As Header
	
	Private Enum HeaderSectionStyle
		hdsText, hdsOwnerDraw
	End Enum
	
	Private Type HeaderSection Extends My.Sys.Object
	Private:
		FCaption      As WString Ptr
		FAlignment    As Integer
		FImageIndex   As Integer
		FImageKey     As WString Ptr
		FResizable    As Boolean
		FStyle        As HeaderSectionStyle
		FWidth        As Integer
		AFmt(4)       As Integer
	Public:
		#ifdef __USE_GTK__
			Dim As GtkTreeViewColumn Ptr Handle
			Dim As GtkWidget Ptr BoxHandle
			Dim As GtkWidget Ptr ButtonHandle
			Dim As GtkWidget Ptr ImageHandle
			Dim As GtkWidget Ptr LabelHandle
			Dim As Integer AllocatedWidth
		#endif
		HeaderControl As PHeaderControl Ptr
		Tag           As Any Ptr
		Declare Property Caption ByRef As WString
		Declare Property Caption(ByRef Value As WString)
		Declare Property Alignment As Integer
		Declare Property Alignment(Value As Integer)
		Declare Property ImageIndex As Integer
		Declare Property ImageIndex(Value As Integer)
		Declare Property ImageKey ByRef As WString
		Declare Property ImageKey(ByRef Value As WString)
		Declare Property Resizable As Boolean
		Declare Property Resizable(Value As Boolean)
		Declare Property Width As Integer
		Declare Property Width(Value As Integer)
		Declare Property Style As HeaderSectionStyle
		Declare Property Style(Value As HeaderSectionStyle)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	Private Enum HeaderStyle
		hsNormal = 0, hsOwnerDraw
	End Enum
	
	Private Type Header Extends Control
	Private:
		FStyle            As HeaderStyle
		FFullDrag         As Boolean
		FDragReorder      As Boolean
		FHotTrack         As Boolean
		FResizable        As Boolean
'		AStyle(2)         As Integer
'		AHotTrack(2)      As Integer
'		AFullDrag(2)      As Integer
'		ADragReorder(2)   As Integer
		AFmt(4)           As Integer
		FSectionCount     As Integer
		#ifdef __USE_GTK__
			Declare Static Sub Column_Clicked(treeviewcolumn As GtkTreeViewColumn Ptr, user_data As Any Ptr)
			Declare Static Sub Header_Map(widget As GtkWidget Ptr, user_data As Any Ptr)
			Declare Static Function Header_Draw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Declare Static Function Header_ExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			Declare Static Function Column_Draw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Declare Static Function Column_ExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			Declare Static Function Column_ButtonPressEvent(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
			ListStore As GtkListStore Ptr
			ColumnTypes As GType Ptr
		#else
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#endif
	Protected:
		#ifdef __USE_GTK__
			AllocatedHeight As Integer
			AllocatedWidth As Integer
		#endif
		FSections         As List
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		Declare Function EnumMenuItems(Item As MenuItem, ByRef List As List) As Boolean
		Declare Sub Init()
	Public:
		Declare Function ReadProperty(PropertyName As String) As Any Ptr
		Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Images            As ImageList Ptr
		Declare Property Style As HeaderStyle
		Declare Property Style(Value As HeaderStyle)
		Declare Property HotTrack As Boolean
		Declare Property HotTrack(Value As Boolean)
		Declare Property FullDrag As Boolean
		Declare Property FullDrag(Value As Boolean)
		Declare Property DragReorder As Boolean
		Declare Property DragReorder(Value As Boolean)
		Declare Property Resizable As Boolean
		Declare Property Resizable(Value As Boolean)
		Declare Property SectionCount As Integer
		Declare Property SectionCount(Value As Integer)
		Declare Property Section(Index As Integer) As HeaderSection Ptr
		Declare Property Section(Index As Integer, Value As HeaderSection Ptr)
		Declare Property Captions(Index As Integer) ByRef As WString
		Declare Property Captions(Index As Integer, ByRef Value As WString)
		Declare Property Widths(Index As Integer) As Integer
		Declare Property Widths(Index As Integer, Value As Integer)
		Declare Property Alignments(Index As Integer) As Integer
		Declare Property Alignments(Index As Integer, Value As Integer)
		Declare Property ImageIndexes(Index As Integer) As Integer
		Declare Property ImageIndexes(Index As Integer, Value As Integer)
		Declare Operator Cast As Control Ptr
		Declare Function AddSection(ByRef FCaption As WString = "", FImageIndex As Integer = -1, FWidth As Integer = -1, FAlignment As Integer = 0, bResizable As Boolean = True) As HeaderSection Ptr
		Declare Function AddSection(ByRef FCaption As WString = "", ByRef FImageKey As WString, FWidth As Integer = -1, FAlignment As Integer = 0, bResizable As Boolean = True) As HeaderSection Ptr
		Declare Sub AddSections cdecl(FCount As Integer, ...)
		Declare Sub RemoveSection(Index As Integer)
		Declare Sub UpdateItems
		Declare Constructor
		Declare Destructor
		OnSectionClick    As Sub(ByRef Sender As Header, ByRef Section As HeaderSection, Index As Integer, MouseButton As Integer)
		OnSectionDblClick As Sub(ByRef Sender As Header, ByRef Section As HeaderSection, Index As Integer, MouseButton As Integer)
		OnChange          As Sub(ByRef Sender As Header, ByRef Section As HeaderSection)
		OnChanging        As Sub(ByRef Sender As Header, ByRef Section As HeaderSection, ByRef Cancel As Boolean)
		OnBeginTrack      As Sub(ByRef Sender As Header, ByRef Section As HeaderSection)
		OnEndTrack        As Sub(ByRef Sender As Header, ByRef Section As HeaderSection)
		OnTrack           As Sub(ByRef Sender As Header, ByRef Section As HeaderSection)
		OnDividerDblClick As Sub(ByRef Sender As Header, Index As Integer, MouseButton As Integer)
		#ifndef __USE_GTK__
			OnDrawSection     As Sub(ByRef Sender As Header, ByRef Section As HeaderSection, R As My.Sys.Drawing.Rect, State As Integer)
		#endif
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "Header.bas"
#endif
