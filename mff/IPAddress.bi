'###############################################################################
'#  IPAddress.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
	#DEFINE QIPAddress(__Ptr__) *Cast(IPAddress Ptr, __Ptr__)
	
	Type IPAddress Extends Control
	Private:
		#IfNdef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Sub ProcessMessage(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#EndIf
	Public:
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#IfNDef __USE_MAKE__
	#Include Once "IPAddress.bas"
#EndIf
