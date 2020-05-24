'###############################################################################
'#  ContainerControl.bi                                                        #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'###############################################################################

#include once "Control.bi"

Namespace My.Sys.Forms
	#define QContainerControl(__Ptr__) *Cast(ContainerControl Ptr,__Ptr__)
	
	Type ContainerControl Extends Control
	Private:
	Protected:
		Declare Virtual Sub ProcessMessage(ByRef message As Message)
	Public:
		#ifdef __USE_GTK__
			Declare Function RegisterClass(ByRef wClassName As WString, Obj As Any Ptr, WndProcAddr As Any Ptr = 0) As Boolean
		#endif
		Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Declare Operator Cast As Control Ptr
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifdef __EXPORT_PROCS__
	Declare Function ControlIsContainer Alias "ControlIsContainer"(Ctrl As My.Sys.Forms.Control Ptr) As Boolean
#endif

#ifndef __USE_MAKE__
	#include once "ContainerControl.bas"
#endif
