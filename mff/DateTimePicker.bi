'###############################################################################
'#  DateTimePicker.bi                                                          #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                    #
'###############################################################################

#include once "Control.bi"

Namespace My.Sys.Forms
	#define QDateTimePicker(__Ptr__) *Cast(DateTimePicker Ptr, __Ptr__)
	
	Type DateTimePicker Extends Control
	Private:
		FTimePicker         As Boolean = False
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TimePicker As Boolean
		Declare Property TimePicker(Value As Boolean)
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "DateTimePicker.bas"
#endif
