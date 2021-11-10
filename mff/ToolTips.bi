'################################################################################
'#  ToolTips.bi                                                                 #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#include once "Component.bi"

Namespace My.Sys.Forms
	#define QToolTips(__Ptr__) *Cast(ToolTips Ptr, __Ptr__)
	
	Private Type ToolTips Extends My.Sys.ComponentModel.Component
	Private:
		'			#IfNDef __USE_GTK__
		'				Declare Static Sub WndProc(ByRef Message As Message)
		'				Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		'				Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		'			#EndIf
	Public:
		Declare Operator Cast As My.Sys.ComponentModel.Component Ptr
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "ToolTips.bas"
#endif
