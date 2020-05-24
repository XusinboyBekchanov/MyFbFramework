'###############################################################################
'#  LinkLabel.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#include once "LinkLabel.bi"

Namespace My.Sys.Forms
	Property LinkLabel.Text ByRef As WString
		Return Base.Text
	End Property
	
	Property LinkLabel.Text(ByRef Value As WString)
		Base.Text = Value
		#ifdef __USE_GTK__
			gtk_label_set_markup_with_mnemonic(gtk_label(widget), ToUtf8(Replace(Value, "&", "_")))
		#endif
	End Property
	
	#ifndef __USE_GTK__
		Sub LinkLabel.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QLinkLabel(Sender.Child)
					
				End With
			End If
		End Sub
		
		Sub LinkLabel.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Sub LinkLabel.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Select Case Message.Msg
			Case CM_NOTIFY
				Select Case Cast(LPNMHDR, Message.lParam)->code
				Case NM_CLICK, NM_RETURN
					Dim As PNMLINK pNMLink1 = Cast(PNMLINK, Message.lParam)
					Dim As LITEM item = pNMLink1->item
					Dim As Integer Action = 1
					If OnLinkClicked Then OnLinkClicked(This, item.iLink, item.szUrl, Action)
					If Action = 1 AndAlso item.szUrl <> "" Then
						ShellExecute(NULL, "open", item.szUrl, NULL, NULL, SW_SHOW)
					End If
				End Select
			End Select
		#endif
		Base.ProcessMessage Message
	End Sub
	
	#ifdef __USE_GTK__
		Function LinkLabel.ActivateLink(label As GtkLabel Ptr, uri As gchar Ptr, user_data As gpointer) As Boolean
			Dim As LinkLabel Ptr lab = user_data
			Dim As Integer Action = 1
			If lab->OnLinkClicked Then lab->OnLinkClicked(*lab, 0, *uri, Action)
			If Action = 1 AndAlso *uri <> "" Then
				'ShellExecute(NULL, "open", uri, NULL, NULL, SW_SHOW)
				Return False
			Else
				Return True
			End If
		End Function
	#endif
	
	Operator LinkLabel.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	Constructor LinkLabel
		With This
			WLet FClassName, "LinkLabel"
			#ifdef __USE_GTK__
				widget = gtk_label_new("")
				scrolledwidget = gtk_scrolled_window_new(NULL, NULL)
				gtk_scrolled_window_set_policy(gtk_scrolled_window(scrolledwidget), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
				#ifdef __USE_GTK3__
					gtk_container_add(gtk_container(scrolledwidget), widget)
				#else
					gtk_scrolled_window_add_with_viewport(gtk_scrolled_window(scrolledwidget), widget)
				#endif
				g_signal_connect(widget, "activate-link", G_CALLBACK(@ActivateLink), @This)
				.RegisterClass "LinkLabel", @This
			#else
				.RegisterClass "LinkLabel", WC_LINK
				WLet FClassAncestor, WC_LINK
				.ExStyle      = 0
				.Style        = WS_CHILD
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.Width        = 100
			.Height       = 32
			.Child        = @This
		End With
	End Constructor
	
	Destructor LinkLabel
		#ifndef __USE_GTK__
			UnregisterClass "LinkLabel", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
