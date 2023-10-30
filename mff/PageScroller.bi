'################################################################################
'#  PageScroller.bi                                                             #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#include once "ContainerControl.bi"

Namespace My.Sys.Forms
	#define QPageScroller(__Ptr__) (*Cast(PageScroller Ptr, __Ptr__))
	
	Private Enum PageScrollerStyle
		psHorizontal, psVertical
	End Enum
	
	'The PageScroller control is used to scroll a panel along with the components placed on it.
	Private Type PageScroller Extends ContainerControl
	Private:
		FArrowChangeSize    As Integer
		FAutoScroll         As Boolean
		FChildDragDrop      As Boolean
		FPosition           As Integer
		FStyle              As Integer
		#ifdef __USE_GTK__
			Dim As GtkWidget Ptr Layout1, Layout2, EndedLayout, PressedLayout, EnteredLayout
			Declare Static Sub Layout_SizeAllocate(widget As GtkWidget Ptr, allocation As GdkRectangle Ptr, user_data As Any Ptr)
			Declare Static Function Layout_Draw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Declare Static Function Layout_ExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			Declare Static Function Layout_EventProc(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
			Declare Static Function Layout_hover_cb(ByVal user_data As gpointer) As gboolean
			Declare Sub Layout_Press(widget As GtkWidget Ptr)
			Dim As Boolean bCreated
		#else
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#endif
	Protected:
		ChildControl        As Control Ptr
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
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
		Declare Sub Add(Ctrl As Control Ptr, Index As Integer = -1)
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		OnScroll As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As PageScroller, ByRef NewPos As Integer)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "PageScroller.bas"
#endif
