'###############################################################################
'#  DateTimePicker.bi                                                          #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
    #DEFINE QDateTimePicker(__Ptr__) *Cast(DateTimePicker Ptr, __Ptr__)
    
    Type DateTimePicker Extends Control
        Private:
			#IfNDef __USE_GTK__
				Declare Static Sub WndProc(ByRef Message As Message)
				Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			#EndIf
			Declare Sub ProcessMessage(ByRef Message As Message)
        Public:
            Declare Operator Cast As My.Sys.Forms.Control Ptr
            Declare Constructor
            Declare Destructor
    End Type
End Namespace

#IfNDef __USE_MAKE__
	#Include Once "DateTimePicker.bas"
#EndIf
