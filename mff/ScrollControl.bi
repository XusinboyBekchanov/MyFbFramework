'###############################################################################
'#  ScrollControl.bi                                                           #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#include once "ContainerControl.bi"

Namespace My.Sys.Forms
	#define QScrollControl(__Ptr__) (*Cast(ScrollControl Ptr, __Ptr__))
	
	Private Type ScrollControl Extends ContainerControl
	Private:
		OldClientHeight As Integer
		OldClientWidth As Integer
		OldMaxHeight As Integer
		OldMaxWidth As Integer
		InRecalculate As Boolean
		#ifndef __USE_GTK__
			Declare Static Sub WNDPROC(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#else
			
		#endif
	Protected:
		Dim As Integer FHorizontalArrowChangeSize
		Dim As Integer FVerticalArrowChangeSize
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		#ifndef ReadProperty_Off
			Declare Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		Declare Sub Add(Ctrl As Control Ptr, Index As Integer = -1)
		Declare Sub RecalculateScrollBars
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnScroll As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ScrollControl)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "ScrollControl.bas"
#endif
