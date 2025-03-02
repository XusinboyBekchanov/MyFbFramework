'###############################################################################
'#  LinkLabel.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#include once "Control.bi"

Namespace My.Sys.Forms
	#define QLinkLabel(__Ptr__) (*Cast(LinkLabel Ptr, __Ptr__))
	
	'`LinkLabel` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`LinkLabel` - Represents a label control that can display hyperlinks.
	Private Type LinkLabel Extends Control
	Private:
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#else
			Declare Static Function ActivateLink(label As GtkLabel Ptr, uri As gchar Ptr, user_data As gpointer) As Boolean
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		#ifndef ReadProperty_Off
			'Loads hyperlink settings from stream
			Declare Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves hyperlink configuration to stream
			Declare Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property TabIndex As Integer
		'Controls focus order in tab sequence
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		'Enables/disables focus via Tab key
		Declare Property TabStop(Value As Boolean)
		Declare Property Text ByRef As WString
		'Hyperlink text with URL formatting
		Declare Property Text(ByRef Value As WString)
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		'Triggered when hyperlink is activated
		OnLinkClicked As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As LinkLabel, ByVal ItemIndex As Integer, ByRef Link As WString, ByRef Action As Integer)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "LinkLabel.bas"
#endif
