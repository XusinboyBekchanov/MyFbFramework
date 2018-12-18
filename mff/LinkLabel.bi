'################################################################################
'#  IPAddress.bi                                                                  #
'#  This file is part of MyFBFramework                                            #
'#  Version 1.0.0                                                                  #
'################################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
    #DEFINE QLinkLabel(__Ptr__) *Cast(LinkLabel Ptr, __Ptr__)
    
    Type LinkLabel Extends Control
        Private:
			#IfNDef __USE_GTK__
				Declare Static Sub WndProc(ByRef Message As Message)
				Declare Sub ProcessMessage(ByRef Message As Message)
				Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			#EndIf
        Public:
            Declare Operator Cast As My.Sys.Forms.Control Ptr
            Declare Constructor
            Declare Destructor
    End Type
    
    #IfNDef __USE_GTK__
		Sub LinkLabel.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QLinkLabel(Sender.Child)
					 
				End With
			End If
		End Sub

		Sub LinkLabel.WndProc(ByRef Message As Message)
		End Sub

		Sub LinkLabel.ProcessMessage(ByRef Message As Message)
			'Base.ProcessMessage Message
		End Sub
	#EndIf

    Operator LinkLabel.Cast As My.Sys.Forms.Control Ptr
         Return Cast(My.Sys.Forms.Control Ptr, @This)
    End Operator

    Constructor LinkLabel
        With This
			WLet FClassName, "LinkLabel"
			#IfDef __USE_GTK__
				widget = gtk_link_button_new_With_label("", "")
				.RegisterClass "HotKey", @This
			#Else
				.RegisterClass "LinkLabel", WC_LINK
				WLet FClassAncestor, WC_LINK
				.ExStyle      = 0
				.Style        = WS_CHILD
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#EndIf
            .Width        = 100
            .Height       = 32
            .Child        = @This            
        End With
    End Constructor

    Destructor LinkLabel
		#IfNDef __USE_GTK__
			UnregisterClass "LinkLabel",GetModuleHandle(NULL)
		#EndIf
    End Destructor
End Namespace
