'###############################################################################
'#  LinkLabel.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#include once "LinkLabel.bi"

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function LinkLabel.ReadProperty(PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "tabindex": Return @FTabIndex
			Case "text": Return FText
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function LinkLabel.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "tabindex": TabIndex = QInteger(Value)
			Case "text": Text = QWString(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	
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
			gtk_label_set_markup_with_mnemonic(GTK_LABEL(widget), ToUtf8(Replace(Value, "&", "_")))
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			If FHandle Then SetInnerHTML(FHandle, ToUtf8(Value))
		#endif
	End Property
	
	#ifdef __USE_WINAPI__
		Private Sub LinkLabel.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QLinkLabel(Sender.Child)
					
				End With
			End If
		End Sub
		
		Private Sub LinkLabel.WndProc(ByRef Message As Message)
		End Sub
	#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
		Private Sub LinkLabel.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QLinkLabel(Sender.Child)
					#ifdef __USE_WASM__
						SetLinkEvent(.FHandle)
					#else
						If .FText Then SetInnerHTML(.FHandle, ToUtf8(*.FText))
					#endif
				End With
			End If
		End Sub
		
		Private Sub LinkLabel.WndProc(ByRef Message As Message)
		End Sub
		
		#ifdef __USE_WASM__
			'The text is SysLink markup: <a href="...">...</a>
			Private Function LinkLabel.GetContent() As UString
				If FText = 0 Then Return ""
				Return *FText
			End Function
		#endif
	#endif
	
	Private Sub LinkLabel.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_WASM__
			If Message.Msg = CM_CHANGE Then
				Dim As Integer Action = 1, ItemIndex = GetPosition(FHandle)
				Dim As ZString Ptr pLink = GetAttribute(FHandle, "data-link")
				Dim As WString Ptr pWide = FromUtf8(pLink)
				FreePtr(pLink)
				Dim As UString sLink = IIf(pWide, *pWide, "")
				If pWide Then WDeAllocate(pWide)
				If OnLinkClicked Then OnLinkClicked(*Designer, This, ItemIndex, sLink, Action)
				If Action = 1 AndAlso sLink <> "" Then OpenURL(ToUtf8(sLink))
				Message.Handled = True
			End If
		#endif
		#ifdef __USE_WINAPI__
			Select Case Message.Msg
			Case WM_ERASEBKGND 'WM_PAINT, WM_ERASEBKGND
				If Not FCreated Then
					FCreated = True
					UpdateWindow Message.hWnd
					Message.Result = -1
					Return
				End If
			Case CM_NOTIFY
				Select Case Cast(LPNMHDR, Message.lParam)->code
				Case NM_CLICK, NM_RETURN
					Dim As PNMLINK pNMLink1 = Cast(PNMLINK, Message.lParam)
					Dim As LITEM item = pNMLink1->item
					Dim As Integer Action = 1
					If OnLinkClicked Then OnLinkClicked(*Designer, This, item.iLink, item.szUrl, Action)
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
			If lab->OnLinkClicked Then lab->OnLinkClicked(*lab->Designer, *lab, 0, *uri, Action)
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
				#ifdef __USE_GTK4__
					scrolledwidget = gtk_scrolled_window_new()
				#else
					scrolledwidget = gtk_scrolled_window_new(NULL, NULL)
				#endif
				gtk_scrolled_window_set_policy(gtk_scrolled_window(scrolledwidget), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
				#ifndef __USE_GTK2__
					gtk_container_add(gtk_container(scrolledwidget), widget)
				#else
					gtk_scrolled_window_add_with_viewport(gtk_scrolled_window(scrolledwidget), widget)
				#endif
				g_signal_connect(widget, "activate-link", G_CALLBACK(@ActivateLink), @This)
				.RegisterClass "LinkLabel", @This
			#elseif defined(__USE_WINAPI__)
				.RegisterClass "LinkLabel", WC_LINK
				WLet(FClassAncestor, WC_LINK)
				.ExStyle      = 0
				.Style        = WS_CHILD
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#elseif defined(__USE_WASM__)
				WLet(FClassAncestor, "div")
				'The lines of the text are kept (CR LF like the SysLink of Windows), the markup is HTML
				FElementStyle = "white-space: pre-wrap;"
				.OnHandleIsAllocated = @HandleIsAllocated
			#elseif defined(__USE_JNI__)
				WLet(FClassAncestor, "mff:Link")
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			FTabIndex          = -1
			.Width        = 100
			.Height       = 32
			.Child        = @This
		End With
	End Constructor
	
	Private Destructor LinkLabel
		'The class is not unregistered: it is shared by all LinkLabels (for example the tooltips of the
		'code editor tabs), the other ones (frmAbout) could not create their window after it
	End Destructor
End Namespace
