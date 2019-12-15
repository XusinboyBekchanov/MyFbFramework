'###############################################################################
'#  LinkLabel.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
    #DEFINE QLinkLabel(__Ptr__) *Cast(LinkLabel Ptr, __Ptr__)
    
    Type LinkLabel Extends Control
        Private:
			#IfNDef __USE_GTK__
				Declare Static Sub WndProc(ByRef Message As Message)
				Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			#Else
				Declare Static Function ActivateLink(label As GtkLabel Ptr, uri As gchar Ptr, user_data As gpointer) As Boolean
			#EndIf
			Declare Sub ProcessMessage(ByRef Message As Message)
        Public:
            Declare Property Text ByRef As WString
            Declare Property Text(ByRef Value As WString)
            Declare Operator Cast As My.Sys.Forms.Control Ptr
            Declare Constructor
            Declare Destructor
            OnLinkClicked As Sub(ByRef Sender As LinkLabel, ByVal ItemIndex As Integer, ByRef Action As Integer)
    End Type
End Namespace

#IfNDef __USE_MAKE__
	#Include Once "LinkLabel.bas"
#EndIf
