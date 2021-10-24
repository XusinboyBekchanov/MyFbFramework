'################################################################################
'#  PageScroller.bi                                                             #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#include once "ContainerControl.bi"

Namespace My.Sys.Forms
	#define QPageScroller(__Ptr__) *Cast(PageScroller Ptr, __Ptr__)
	
	#ifndef __USE_GTK__
		Type NMPGSCROLL2 Field = 1
		    As NMHDR hdr
		    As Short fwKeys
		    As ..RECT rcParent
		    As Integer iDir
		    As Integer iXpos
		    As Integer iYpos
		    As Integer iScroll
		End Type
	#endif
	
	Enum PageScrollerStyle
		psHorizontal, psVertical
	End Enum
	
	Type PageScroller Extends ContainerControl
	Private:
		FArrowChangeSize    As Integer
		FAutoScroll         As Boolean
		FChildDragDrop      As Boolean
		FPosition           As Integer
		FStyle              As Integer
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#endif
	Protected:
		ChildControl        As Control Ptr
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Declare Property ArrowChangeSize As Integer
		Declare Property ArrowChangeSize(Value As Integer)
		Declare Property AutoScroll As Boolean
		Declare Property AutoScroll(Value As Boolean)
		Declare Property ChildDragDrop As Boolean
		Declare Property ChildDragDrop(Value As Boolean)
		Declare Property Position As Integer
		Declare Property Position(Value As Integer)
		Declare Property Style As PageScrollerStyle
		Declare Property Style(Value As PageScrollerStyle)
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		'Adds the specified control to the control collection (Windows, Linux).
		Declare Sub Add(Ctrl As Control Ptr)
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		OnScroll As Sub(ByRef Sender As PageScroller, ByRef NewPos As Integer)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "PageScroller.bas"
#endif
