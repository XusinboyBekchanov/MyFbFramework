'###############################################################################
'#  LinkLabel.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#include once "Control.bi"

Namespace My.Sys.Forms
	#define QLinkLabel(__Ptr__) *Cast(LinkLabel Ptr, __Ptr__)
	
	Type LinkLabel Extends Control
	Private:
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#else
			Declare Static Function ActivateLink(label As GtkLabel Ptr, uri As gchar Ptr, user_data As gpointer) As Boolean
		#endif
		Declare Sub ProcessMessage(ByRef Message As Message)
	Public:
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		OnLinkClicked As Sub(ByRef Sender As LinkLabel, ByVal ItemIndex As Integer, ByRef Link As WString, ByRef Action As Integer)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "LinkLabel.bas"
#endif
