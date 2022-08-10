'###############################################################################
'#  ScrollControl.bi                                                           #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#include once "Control.bi"

Namespace My.Sys.Forms
	#define QScrollControl(__Ptr__) *Cast(ScrollControl Ptr, __Ptr__)
	
	Private Type ScrollControl Extends ContainerControl
	Private:
		#ifndef __USE_GTK__
			Declare Static Sub WNDPROC(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#else
			
		#endif
	Protected:
		Dim As Integer FHorizontalArrowChangeSize
		Dim As Integer FVerticalArrowChangeSize
		Declare Sub SetScrollsInfo
		Declare Sub GetMax(ByRef MaxWidth As Integer, ByRef MaxHeight As Integer)
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		Declare Function ReadProperty(PropertyName As String) As Any Ptr
		Declare Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnScroll As Sub(ByRef Sender As ScrollControl)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "ScrollControl.bas"
#endif
