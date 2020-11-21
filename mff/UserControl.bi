'################################################################################
'#  UserControl.bi                                                              #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov                                                 #
'################################################################################

#include once "ContainerControl.bi"
'#Include Once "Canvas.bi"

Namespace My.Sys.Forms
	#define QUserControl(__Ptr__) *Cast(UserControl Ptr,__Ptr__)
	
	Type UserControl Extends ContainerControl
	Private:
		#ifndef __USE_GTK__
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			Declare Static Sub WndProc(ByRef Message As Message)
		#endif
	Public:
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		'Canvas        As My.Sys.Drawing.Canvas
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "UserControl.bas"
#endif
