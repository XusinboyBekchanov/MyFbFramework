'################################################################################
'#  ToolTips.bi                                                                 #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#include once "Control.bi"

Namespace My.Sys.Forms
	#define QToolTips(__Ptr__) *Cast(ToolTips Ptr, __Ptr__)
	
	Private Type ToolTips Extends Control
	Private:
		#ifndef __USE_GTK__
			Declare Static Sub WNDPROC(ByRef Message As Message)
			Declare Virtual Sub ProcessMessage(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#else
			Declare Static Function ActivateLink(Label As GtkLabel Ptr, uri As gchar Ptr, user_data As gpointer) As Boolean
			Dim As GtkWidget Ptr winTooltip
			lblTooltip As GtkWidget Ptr
		#endif
	Public:
		#ifndef __USE_GTK__
			Declare Sub CreateWnd
		#endif
		'Displays the ToolTip to the user (Windows only).
		Declare Virtual Sub Show
		'Conceals the ToolTip from the user (Windows only).
		Declare Virtual Sub Hide
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnLinkClicked As Sub(ByRef Sender As ToolTips, ByRef link As WString)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "ToolTips.bas"
#endif
