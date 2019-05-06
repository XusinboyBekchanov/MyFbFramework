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
    
    Property LinkLabel.Text ByRef As WString
        Return Base.Text
    End Property

    Property LinkLabel.Text(ByRef Value As WString)
        Base.Text = Value
        #IfDef __USE_GTK__
        	gtk_label_set_markup_with_mnemonic(gtk_label(widget), ToUtf8(Replace(Value, "&", "_")))
		#EndIf
    End Property

    #IfNDef __USE_GTK__
		Sub LinkLabel.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QLinkLabel(Sender.Child)
					 
				End With
			End If
		End Sub

		Sub LinkLabel.WndProc(ByRef Message As Message)
		End Sub
	#EndIf
	
	Sub LinkLabel.ProcessMessage(ByRef Message As Message)
		#IfNDef __USE_GTK__
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
		#EndIf
		Base.ProcessMessage Message
	End Sub

	#IfDef __USE_GTK__
		Function LinkLabel.ActivateLink(label As GtkLabel Ptr, uri As gchar Ptr, user_data As gpointer) As Boolean
			Dim As LinkLabel Ptr lab = user_data
			Dim As Integer Action = 1
    		If lab->OnLinkClicked Then lab->OnLinkClicked(*lab, 0, Action)
    		If Action = 1 AndAlso *uri <> "" Then
				'ShellExecute(NULL, "open", uri, NULL, NULL, SW_SHOW)
				Return False
			Else
				Return True
			End If
		End Function
	#EndIf
	
    Operator LinkLabel.Cast As My.Sys.Forms.Control Ptr
         Return Cast(My.Sys.Forms.Control Ptr, @This)
    End Operator

	Constructor LinkLabel
        With This
			WLet FClassName, "LinkLabel"
			#IfDef __USE_GTK__
				scrolledwidget = gtk_scrolled_window_new(NULL, NULL)
				gtk_scrolled_window_set_policy(gtk_scrolled_window(scrolledwidget), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
				widget = gtk_label_new("")
				gtk_container_add(gtk_container(scrolledwidget), widget)
				g_signal_connect(widget, "activate-link", G_CALLBACK(@ActivateLink), @This)
				.RegisterClass "LinkLabel", @This
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
