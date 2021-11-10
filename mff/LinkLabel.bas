'###############################################################################
'#  LinkLabel.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#include once "LinkLabel.bi"

Namespace My.Sys.Forms
	Private Function LinkLabel.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "tabindex": Return @FTabIndex
		Case "text": Return FText.vptr
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Private Function LinkLabel.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "tabindex": TabIndex = QInteger(Value)
		Case "text": Text = QWString(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Private Property LinkLabel.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property LinkLabel.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property LinkLabel.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property LinkLabel.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Property LinkLabel.Text ByRef As WString
		Return Base.Text
	End Property
	
	Private Property LinkLabel.Text(ByRef Value As WString)
		Base.Text = Value
		#ifdef __USE_GTK__
			gtk_label_set_markup_with_mnemonic(gtk_label(widget), ToUtf8(Replace(Value, "&", "_")))
		#endif
	End Property
	
	#ifndef __USE_GTK__
		Private Sub LinkLabel.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QLinkLabel(Sender.Child)
					
				End With
			End If
		End Sub
		
		Private Sub LinkLabel.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Private Sub LinkLabel.ProcessMessage(ByRef Message As Message)
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
		Private Function LinkLabel.ActivateLink(label As GtkLabel Ptr, uri As gchar Ptr, user_data As gpointer) As Boolean
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
	
	Private Operator LinkLabel.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	Private Constructor LinkLabel
		With This
			WLet(FClassName, "LinkLabel")
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
				WLet(FClassAncestor, WC_LINK)
				.ExStyle      = 0
				.Style        = WS_CHILD
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			FTabIndex          = -1
			.Width        = 100
			.Height       = 32
			.Child        = @This
		End With
	End Constructor
	
	Private Destructor LinkLabel
		#ifndef __USE_GTK__
			UnregisterClass "LinkLabel", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
