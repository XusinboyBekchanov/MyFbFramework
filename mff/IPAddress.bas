'###############################################################################
'#  IPAddress.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#include once "IPAddress.bi"

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function IPAddress.ReadProperty(PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "tabindex": Return @FTabIndex
			Case "text": Text: Return FText.vptr
			Case "onchange": Return OnChange
			Case "onfieldchanged": Return OnFieldChanged
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function IPAddress.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "tabindex": TabIndex = QInteger(Value)
			Case "text": Text = QWString(Value)
			Case "onchange": OnChange = Value
			Case "onfieldchanged": OnFieldChanged = Value
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	
	Private Property IPAddress.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property IPAddress.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property IPAddress.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property IPAddress.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Sub IPAddress.Clear
		#ifdef __USE_GTK__
			For i As Integer = 0 To 3
				#ifdef __USE_GTK4__
					gtk_entry_buffer_set_text(gtk_entry_get_buffer(GTK_ENTRY(Entries(i))), !"\0", -1)
				#else
					gtk_entry_set_text(GTK_ENTRY(Entries(i)), !"\0")
				#endif
			Next
		#else
			SendMessage FHandle, IPM_CLEARADDRESS, 0, 0
		#endif
	End Sub
	
	Private Property IPAddress.Text ByRef As WString
		#ifdef __USE_GTK__
			#ifdef __USE_GTK4__
				FText = Trim(WStr(*gtk_entry_buffer_get_text(gtk_entry_get_buffer(GTK_ENTRY(Entries(0))))))
			#else
				FText = Trim(WStr(*gtk_entry_get_text(GTK_ENTRY(Entries(0)))))
			#endif
			For i As Integer = 1 To 3
				#ifdef __USE_GTK4__
					FText &= "." & Trim(Str(Val(*gtk_entry_buffer_get_text(gtk_entry_get_buffer(GTK_ENTRY(Entries(i)))))))
				#else
					FText &= "." & Trim(Str(Val(*gtk_entry_get_text(GTK_ENTRY(Entries(i))))))
				#endif
			Next
			Return *FText.vptr
		#else
			Return Base.Text
		#endif
	End Property
	
	Private Property IPAddress.Text(ByRef Value As WString)
		FText = Value
		If Value = "" Then
			This.Clear
		Else
			Dim res(Any) As UString, Addresses(3) As Integer
			Split(Value, ".", res())
			For i As Integer = 0 To 3
				If UBound(res) >= i Then
					Addresses(i) = Max(0, Min(Val(res(i)), 255))
				End If
				#ifdef __USE_GTK__
					#ifdef __USE_GTK4__
						gtk_entry_buffer_set_text(gtk_entry_get_buffer(GTK_ENTRY(Entries(i))), Trim(Str(Addresses(i))), -1)
					#else
						gtk_entry_set_text(GTK_ENTRY(Entries(i)), Trim(Str(Addresses(i))))
					#endif
				#endif
			Next
			#ifndef __USE_GTK__
				SendMessage FHandle, IPM_SETADDRESS, 0, MAKEIPADDRESS(Addresses(0), Addresses(1), Addresses(2), Addresses(3))
			#endif
		End If
	End Property
	
	#ifndef __USE_GTK__
		Private Sub IPAddress.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			With *Cast(IPAddress Ptr, @Sender)
				.Text = .FText
			End With
		End Sub
		
		Private Sub IPAddress.WndProc(ByRef Message As Message)
		End Sub
		
		Private Function IPAddress.IPAddressWndProc(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			Dim As IPAddress Ptr Ctrl
			Dim Message As Message
			Ctrl = GetProp(FWindow, "MFFControl")
			Message = Type(Ctrl, FWindow, Msg, wParam, lParam, 0, LoWord(wParam), HiWord(wParam), LoWord(lParam), HiWord(lParam), Message.Captured)
			If Ctrl Then
				With *Ctrl
					If Ctrl->ClassName <> "" Then
						.ProcessMessage(Message)
						If Message.Result = -1 Then
							Return Message.Result
						ElseIf Message.Result = -2 Then
							Msg = Message.Msg
							wParam = Message.wParam
							lParam = Message.lParam
						ElseIf Message.Result <> 0 Then
							Return Message.Result
						End If
					End If
				End With
			End If
			Dim As Any Ptr cp = GetClassProc(FWindow)
			If cp <> 0 Then
				Message.Result = CallWindowProc(cp, FWindow, Msg, wParam, lParam)
			End If
			Return Message.Result
		End Function
	#endif
	
	Private Sub IPAddress.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_GTK__
			Dim As GdkEvent Ptr e = Message.Event
			Select Case Message.Event->type
			Case GDK_BUTTON_PRESS
				'Return
			Case GDK_BUTTON_RELEASE
				'SelectRegion
				'Return
			End Select
		#else
			Select Case Message.Msg
			Case CM_COMMAND
				Select Case Message.wParamHi
				Case EN_CHANGE
					If OnChange Then OnChange(*Designer, This)
				Case EN_KILLFOCUS
					If OnLostFocus Then OnLostFocus(*Designer, This)
				Case EN_SETFOCUS
					If OnGotFocus Then OnGotFocus(*Designer, This)
				End Select
				Message.Result = 0
			Case CM_NOTIFY
				Dim lpnmipa As NMIPADDRESS Ptr = Cast(NMIPADDRESS Ptr, Message.lParam)
				Select Case lpnmipa->hdr.code
				Case IPN_FIELDCHANGED
					If OnFieldChanged Then OnFieldChanged(*Designer, This, lpnmipa->iField, lpnmipa->iValue)
				End Select
			End Select
		#endif
		Base.ProcessMessage Message
	End Sub
	
	Private Operator IPAddress.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Private Sub IPAddress.Layout_SizeAllocate(widget As GtkWidget Ptr, allocation As GdkRectangle Ptr, user_data As Any Ptr)
			Dim As IPAddress Ptr ipa = user_data
			If allocation->width <> ipa->AllocatedWidth OrElse allocation->height <> ipa->AllocatedHeight Then
				ipa->AllocatedWidth = allocation->width
				ipa->AllocatedHeight = allocation->height
				If ipa->OnResize Then ipa->OnResize(*ipa->Designer, *ipa, allocation->width, allocation->height)
			End If
		End Sub
		
		Private Function IPAddress.Layout_Draw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Dim As IPAddress Ptr Ctrl = Cast(Any Ptr, data1)
			If Ctrl <> 0 AndAlso (GTK_IS_LAYOUT(widget) OrElse GTK_IS_EVENT_BOX(widget)) Then
				Dim allocation As GtkAllocation
				Dim bSizeChanged As Boolean
				gtk_widget_get_allocation(widget, @allocation)
				If allocation.width <> Ctrl->AllocatedWidth OrElse allocation.height <> Ctrl->AllocatedHeight Then
					Layout_SizeAllocate(widget, @allocation, data1)
					bSizeChanged = True
				End If
				Ctrl->Canvas.HandleSetted = True
				Ctrl->Canvas.Handle = cr
				cairo_rectangle(cr, 0.0, 0.0, Ctrl->AllocatedWidth, Ctrl->AllocatedHeight)
				cairo_set_source_rgb(cr, 1.0, 1.0, 1.0)
				cairo_fill(cr)
				cairo_rectangle(cr, 0.0, 0.0, Ctrl->AllocatedWidth, Ctrl->AllocatedHeight)
				cairo_set_source_rgb(cr, 192 / 255.0, 192 / 255.0, 192 / 255.0)
				cairo_stroke(cr)
				Dim As PangoRectangle extend
				Dim As PangoLayoutLine Ptr pl
				Dim As String sText
				Dim As Integer Offset
				Dim As Integer LayoutWidth
				If Not Ctrl->bCreated Then
					Ctrl->pdisplay = gtk_widget_get_display(widget)
					#ifdef __USE_GTK3__
						Ctrl->win = gtk_layout_get_bin_window(GTK_LAYOUT(widget))
					#endif
					gdk_window_set_cursor(Ctrl->win, gdk_cursor_new_for_display(Ctrl->pdisplay, GDK_XTERM))
				End If
				sText = ToUtf8("55555.")
				pango_layout_set_text(Ctrl->layout, sText, Len(sText))
				pango_cairo_update_layout(cr, Ctrl->layout)
				#ifdef pango_version
					pl = pango_layout_get_line_readonly(Ctrl->layout, 0)
				#else
					pl = pango_layout_get_line(Ctrl->layout, 0)
				#endif
				pango_layout_line_get_pixel_extents(pl, NULL, @extend)
				Offset = extend.width
				sText = ToUTF8("5555")
				pango_layout_set_text(Ctrl->layout, sText, Len(sText))
				pango_cairo_update_layout(cr, Ctrl->layout)
				#ifdef pango_version
					pl = pango_layout_get_line_readonly(Ctrl->layout, 0)
				#else
					pl = pango_layout_get_line(Ctrl->layout, 0)
				#endif
				pango_layout_line_get_pixel_extents(pl, NULL, @extend)
				LayoutWidth = extend.width
				Dim As GtkAllocation EntryAllocation
				gtk_widget_get_allocation(Ctrl->Entries(0), @EntryAllocation)
				sText = "."
				pango_layout_set_text(Ctrl->layout, sText, Len(sText))
				pango_cairo_update_layout(cr, Ctrl->layout)
				#ifdef pango_version
					pl = pango_layout_get_line_readonly(Ctrl->layout, 0)
				#else
					pl = pango_layout_get_line(Ctrl->layout, 0)
				#endif
				pango_layout_line_get_pixel_extents(pl, NULL, @extend)
				cairo_set_source_rgb(cr, 0.0, 0.0, 0.0)
				For i As Integer = 0 To 3
					'If bSizeChanged OrElse Not Ctrl->bCreated Then
						gtk_widget_set_size_request(Ctrl->Layouts(i), Min(LayoutWidth, Max(0, allocation.width - (i * Offset + extend.width) - 1)), Min(EntryAllocation.height - 6, allocation.height - 2))
					'End If
					If Not Ctrl->bCreated Then
						gtk_layout_move(GTK_LAYOUT(widget), Ctrl->Layouts(i), i * Offset + extend.width, 1)
						gtk_layout_move(GTK_LAYOUT(Ctrl->Layouts(i)), Ctrl->Entries(i), (LayoutWidth - EntryAllocation.width) / 2, -3)
					End If
					If i > 0 Then
						cairo_move_to(cr, i * Offset + extend.width - 2 * extend.width, (EntryAllocation.height - 6 - extend.height) / 2 + extend.height - 1)
						pango_cairo_show_layout_line(cr, pl)
					End If
				Next
				Ctrl->bCreated = True
				If Ctrl->OnPaint Then Ctrl->OnPaint(*Ctrl->Designer, *Ctrl, Ctrl->Canvas)
				Ctrl->Canvas.HandleSetted = False
			End If
			Return False
		End Function
		
		Private Function IPAddress.Layout_ExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			Dim As IPAddress Ptr ipa = Cast(Any Ptr, data1)
			Dim As cairo_t Ptr cr = gdk_cairo_create(Event->window)
			ipa->win = Event->window
			Layout_Draw(widget, cr, data1)
			cairo_destroy(cr)
			Return False
		End Function
		
		Private Function IPAddress.Entry_KeyPress(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
			Dim As IPAddress Ptr ipa = user_data
			Select Case Event->key.keyval
			Case GDK_KEY_Home
				ipa->Position = 0
				gtk_widget_grab_focus(ipa->Entries(0))
				Return True
			Case GDK_KEY_End
				ipa->Position = gtk_entry_get_text_length(GTK_ENTRY(ipa->Entries(3)))
				gtk_widget_grab_focus(ipa->Entries(3))
				Return True
			Case GDK_KEY_Tab, GDK_KEY_Return, GDK_KEY_KP_Enter, GDK_KEY_Delete
			Case GDK_KEY_BACKSPACE
				Dim As Integer Pos1 = gtk_editable_get_position(GTK_EDITABLE(widget)), Index, Length
				If Pos1 = 0 Then
					If widget = ipa->Entries(1) Then
						Index = 1
					ElseIf widget = ipa->Entries(2) Then
						Index = 2
					ElseIf widget = ipa->Entries(3) Then
						Index = 3
					End If
					If Index > 0 Then
						Length = gtk_entry_get_text_length(GTK_ENTRY(ipa->Entries(Index - 1)))
						If Length = 1 Then
							#ifdef __USE_GTK4__
								gtk_entry_buffer_set_text(gtk_entry_get_buffer(GTK_ENTRY(ipa->Entries(Index - 1))), !"\0", -1)
							#else
								gtk_entry_set_text(GTK_ENTRY(ipa->Entries(Index - 1)), !"\0")
							#endif
						ElseIf Length > 1 Then
							#ifdef __USE_GTK4__
								gtk_entry_buffer_set_text(gtk_entry_get_buffer(GTK_ENTRY(ipa->Entries(Index - 1))), ..Left(*gtk_entry_buffer_get_text(gtk_entry_get_buffer(GTK_ENTRY(ipa->Entries(Index - 1)))), Length - 1), -1)
							#else
								gtk_entry_set_text(GTK_ENTRY(ipa->Entries(Index - 1)), ..Left(*gtk_entry_get_text(GTK_ENTRY(ipa->Entries(Index - 1))), Length - 1))
							#endif
						End If
						ipa->Position = Length
						gtk_widget_grab_focus(ipa->Entries(Index - 1))
						'gtk_editable_select_region(gtk_editable(widget), Length, Length)
						'If ipa->OnFieldChanged Then ipa->OnFieldChanged(*ipa, Index, Val(*gtk_entry_get_text(gtk_entry(widget))))
						Return True
					End If
				End If
			Case GDK_KEY_Left
				If Event->key.state And GDK_SHIFT_MASK Then Return False
				Dim As Integer Pos1 = gtk_editable_get_position(GTK_EDITABLE(widget)), Index, Length
				If widget = ipa->Entries(1) Then
					Index = 1
				ElseIf widget = ipa->Entries(2) Then
					Index = 2
				ElseIf widget = ipa->Entries(3) Then
					Index = 3
				End If
				If Index > 0 Then
					If Event->key.state And GDK_CONTROL_MASK Then
						ipa->Position = -1
						gtk_widget_grab_focus(ipa->Entries(Index - 1))
					ElseIf Pos1 = 0 Then
						Length = gtk_entry_get_text_length(GTK_ENTRY(ipa->Entries(Index - 1)))
						ipa->Position = Length
						gtk_widget_grab_focus(ipa->Entries(Index - 1))
						'gtk_editable_select_region(gtk_editable(widget), Length, Length)
						'If ipa->OnFieldChanged Then ipa->OnFieldChanged(*ipa, Index, Val(*gtk_entry_get_text(gtk_entry(widget))))
						Return True
					End If
				End If
			Case GDK_KEY_Right
				If Event->key.state And GDK_SHIFT_MASK Then Return False
				Dim As Integer Pos1 = gtk_editable_get_position(GTK_EDITABLE(widget)), Index = 3
				If widget = ipa->Entries(0) Then
					Index = 0
				ElseIf widget = ipa->Entries(1) Then
					Index = 1
				ElseIf widget = ipa->Entries(2) Then
					Index = 2
				End If
				If Index < 3 Then
					If Event->key.state And GDK_CONTROL_MASK Then
						ipa->Position = -1
						gtk_widget_grab_focus(ipa->Entries(Index + 1))
					ElseIf Pos1 = gtk_entry_get_text_length(GTK_ENTRY(widget)) Then
						ipa->Position = 0
						gtk_widget_grab_focus(ipa->Entries(Index + 1))
						'gtk_editable_select_region(gtk_editable(widget), 0, 0)
						'If ipa->OnFieldChanged Then ipa->OnFieldChanged(*ipa, Index, Val(*gtk_entry_get_text(gtk_entry(widget))))
						Return True
					End If
				End If
			Case Else
				Select Case *Event->key.string
				Case "0" To "9"
					Dim As Integer Pos1 = gtk_editable_get_position(GTK_EDITABLE(widget)), Length = gtk_entry_get_text_length(GTK_ENTRY(widget))
					If Length = 2 Then
						#ifdef __USE_GTK4__
							Dim EntryText As String = *gtk_entry_buffer_get_text(gtk_entry_get_buffer(GTK_ENTRY(widget)))
						#else
							Dim EntryText As String = *gtk_entry_get_text(GTK_ENTRY(widget))
						#endif
						If Val(..Left(EntryText, Pos1) & *Event->key.string & Mid(EntryText, Pos1 + 1)) > 255 Then
							#ifdef __USE_GTK4__
								gtk_entry_buffer_set_text(gtk_entry_get_buffer(GTK_ENTRY(widget)), "255", -1)
							#else
								gtk_entry_set_text(GTK_ENTRY(widget), "255")
							#endif
						ElseIf Pos1 = 2 Then
							Dim As Integer Index = 3
							If widget = ipa->Entries(0) Then
								Index = 0
							ElseIf widget = ipa->Entries(1) Then
								Index = 1
							ElseIf widget = ipa->Entries(2) Then
								Index = 2
							End If
							If Index < 3 Then
								#ifdef __USE_GTK4__
									gtk_entry_buffer_set_text(gtk_entry_get_buffer(GTK_ENTRY(widget)), *gtk_entry_buffer_get_text(gtk_entry_get_buffer(GTK_ENTRY(widget))) & *Event->key.string, -1)
								#else
									gtk_entry_set_text(GTK_ENTRY(widget), *gtk_entry_get_text(GTK_ENTRY(widget)) & *Event->key.string)
								#endif
								ipa->Position = -1
								gtk_widget_grab_focus(ipa->Entries(Index + 1))
								'gtk_editable_select_region(gtk_editable(widget), 0, 0)
								Return True
							End If
						End If
					End If
				Case "."
					Dim As Integer Index = 3
					If widget = ipa->Entries(0) Then
						Index = 0
					ElseIf widget = ipa->Entries(1) Then
						Index = 1
					ElseIf widget = ipa->Entries(2) Then
						Index = 2
					End If
					If Index < 3 Then
						ipa->Position = -1
						gtk_widget_grab_focus(ipa->Entries(Index + 1))
						'gtk_editable_select_region(gtk_editable(widget), 0, 0)
						'If ipa->OnFieldChanged Then ipa->OnFieldChanged(*ipa, Index, Val(*gtk_entry_get_text(gtk_entry(widget))))
						Return True
					End If
				Case Else
					Return True
				End Select
			End Select
			Return False
		End Function
		
		Private Sub IPAddress.Entry_Activate(entry As GtkEntry Ptr, user_data As Any Ptr)
			Dim As IPAddress Ptr ipa = user_data
			Dim As Control Ptr btn = ipa->GetForm()->FDefaultButton
			If btn AndAlso btn->OnClick Then btn->OnClick(*btn->Designer, *btn)
		End Sub
		
		Private Sub IPAddress.Entry_Changed(entry As GtkEntry Ptr, user_data As Any Ptr)
			Dim As IPAddress Ptr ipa = user_data
			If ipa AndAlso ipa->OnChange Then ipa->OnChange(*ipa->Designer, *ipa)
		End Sub
		
		Private Sub IPAddress.Entry_GrabFocus(widget As GtkWidget Ptr, user_data As Any Ptr)
			Dim As IPAddress Ptr ipa = user_data
			If ipa->CurrentEntry <> 0 AndAlso ipa->CurrentEntry <> widget Then
				Dim As Integer Index = 3, Value
				If ipa->CurrentEntry = ipa->Entries(0) Then
					Index = 0
				ElseIf ipa->CurrentEntry = ipa->Entries(1) Then
					Index = 1
				ElseIf ipa->CurrentEntry = ipa->Entries(2) Then
					Index = 2
				ElseIf ipa->CurrentEntry = ipa->Entries(3) Then
					Index = 3
				End If
				#ifdef __USE_GTK4__
					Dim As String sText = *gtk_entry_buffer_get_text(gtk_entry_get_buffer(GTK_ENTRY(ipa->CurrentEntry)))
				#else
					Dim As String sText = *gtk_entry_get_text(GTK_ENTRY(ipa->CurrentEntry))
				#endif
				If sText = "" Then Value = -1 Else Value = Val(sText)
				If ipa->OnFieldChanged Then ipa->OnFieldChanged(*ipa->Designer, *ipa, Index, Value)
			End If
			ipa->CurrentEntry = widget
			If ipa->Position <> -1 Then
				gtk_editable_select_region(GTK_EDITABLE(widget), ipa->Position, ipa->Position)
				ipa->Position = -1
			End If
		End Sub
	#endif
	
	Private Constructor IPAddress
		#ifndef __USE_GTK__
			Dim As INITCOMMONCONTROLSEX icex
			
			icex.dwSize = SizeOf(INITCOMMONCONTROLSEX)
			icex.dwICC =  ICC_INTERNET_CLASSES
			
			InitCommonControlsEx(@icex)
		#endif
		
		With This
			WLet(FClassName, "IPAddress")
			FTabIndex          = -1
			FTabStop           = True
			#ifdef __USE_GTK__
				Widget = gtk_layout_new(NULL, NULL)
				'scrolledwidget = gtk_scrolled_window_new(NULL, NULL)
				'gtk_scrolled_window_set_policy(gtk_scrolled_window(scrolledwidget), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
				'gtk_scrolled_window_set_shadow_type(gtk_scrolled_window(scrolledwidget), GTK_SHADOW_OUT)
				'gtk_container_add(gtk_container(scrolledwidget), Widget)
				Canvas.Ctrl = @This
				pcontext = gtk_widget_create_pango_context(widget)
				layout = pango_layout_new(pcontext)
				Dim As PangoFontDescription Ptr desc
				desc = pango_font_description_from_string("Ubuntu 11")
				pango_layout_set_font_description (layout, desc)
				pango_font_description_free (desc)
				For i As Integer = 0 To 3
					Layouts(i) = gtk_layout_new(NULL, NULL)
					Entries(i) = gtk_entry_new()
					gtk_entry_set_alignment(gtk_entry(Entries(i)), 0.5)
					gtk_entry_set_max_length(gtk_entry(Entries(i)), 3)
					g_signal_connect(gtk_entry(Entries(i)), "activate", G_CALLBACK(@Entry_Activate), @This)
					g_signal_connect(Entries(i), "key-press-event", G_CALLBACK(@Entry_KeyPress), @This)
					g_signal_connect_after(Entries(i), "grab-focus", G_CALLBACK(@Entry_GrabFocus), @This)
					g_signal_connect(gtk_entry(Entries(i)), "changed", G_CALLBACK(@Entry_Changed), @This)
					gtk_layout_put(gtk_layout(Layouts(i)), Entries(i), -1, -1)
					gtk_layout_put(gtk_layout(Widget), Layouts(i), 0, 0)
					gtk_widget_show_all(Layouts(i))
				Next i
				#ifdef __USE_GTK3__
					g_signal_connect(widget, "draw", G_CALLBACK(@Layout_Draw), @This)
				#else
					g_signal_connect(widget, "expose-event", G_CALLBACK(@Layout_ExposeEvent), @This)
					g_signal_connect(widget, "size-allocate", G_CALLBACK(@Layout_SizeAllocate), @This)
				#endif
			#else
				.RegisterClass "IPAddress", WC_IPADDRESS, @IPAddressWndProc
				WLet(FClassAncestor, WC_IPADDRESS)
				.ExStyle      = 0
				.Style        = WS_CHILD
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.Width        = 150
			.Height       = 20
			.Child        = @This
		End With
	End Constructor
	
	Private Destructor IPAddress
		#ifndef __USE_GTK__
			Handle = 0
			UnregisterClass "IPAddress", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
