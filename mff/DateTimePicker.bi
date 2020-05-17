'###############################################################################
'#  DateTimePicker.bi                                                          #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                    #
'###############################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
	#DEFINE QDateTimePicker(__Ptr__) *Cast(DateTimePicker Ptr, __Ptr__)
	
	Type DateTimePicker Extends Control
	Private:
		FTimePicker         As Boolean = False
		#IfNDef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#EndIf
		Declare Sub ProcessMessage(ByRef Message As Message)
	Public:
		Declare Property TimePicker As Boolean
		Declare Property TimePicker(Value As Boolean)
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#IfNDef __USE_MAKE__
	#Include Once "DateTimePicker.bas"
#EndIf
