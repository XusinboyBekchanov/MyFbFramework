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
            OnLinkClicked As Sub(ByRef Sender As LinkLabel, ByVal ItemIndex As Integer, ByRef Action As Integer)
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
			Select Case Message.Msg
			Case CM_NOTIFY
				Select Case Cast(LPNMHDR, Message.lParam)->code
				Case NM_CLICK, NM_RETURN
					Dim As PNMLINK pNMLink1 = Cast(PNMLINK, Message.lParam)
					Dim As LITEM item = pNMLink1->item
					Dim As Integer Action = 1
					If OnLinkClicked Then OnLinkClicked(This, item.iLink, Action)
					If Action = 1 AndAlso item.szUrl <> "" Then
						ShellExecute(NULL, "open", item.szUrl, NULL, NULL, SW_SHOW)
					End If
				End Select
			End Select
			Base.ProcessMessage Message
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
