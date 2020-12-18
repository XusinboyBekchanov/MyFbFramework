'################################################################################
'#  Chart.bi                                                                    #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2019)                                     #
'################################################################################

#include once "Control.bi"

Namespace My.Sys.Forms
	#define QChart(__Ptr__) *Cast(Chart Ptr, __Ptr__)
	
	Type Chart Extends Control
	Private:
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Virtual Sub ProcessMessage(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#endif
	Public:
		Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "Chart.bas"
#endif
