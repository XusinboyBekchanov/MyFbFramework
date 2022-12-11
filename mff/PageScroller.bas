'################################################################################
'#  PageScroller.bi                                                             #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#include once "PageScroller.bi"

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function PageScroller.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "arrowchangesize": Return @FArrowChangeSize
			Case "autoscroll": Return @FAutoScroll
			Case "childdragdrop": Return @FChildDragDrop
			Case "position": Position: Return @FPosition
			Case "style": Return @This.FStyle
			Case "tabindex": Return @FTabIndex
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function PageScroller.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "arrowchangesize": This.ArrowChangeSize = QInteger(Value)
				Case "autoscroll": This.AutoScroll = QBoolean(Value)
				Case "childdragdrop": This.ChildDragDrop = QBoolean(Value)
				Case "position": This.Position = QInteger(Value)
				Case "style": This.Style = *Cast(PageScrollerStyle Ptr, Value)
				Case "tabindex": TabIndex = QInteger(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Property PageScroller.ArrowChangeSize As Integer
		Return FArrowChangeSize
	End Property
	
	Private Property PageScroller.ArrowChangeSize(Value As Integer)
		FArrowChangeSize = Value
	End Property
	
	Private Property PageScroller.AutoScroll As Boolean
		Return FAutoScroll
	End Property
	
	Private Property PageScroller.AutoScroll(Value As Boolean)
		FAutoScroll = Value
		#ifndef __USE_GTK__
			ChangeStyle PGS_AUTOSCROLL, Value
		#endif
	End Property
	
	Private Property PageScroller.ChildDragDrop As Boolean
		Return FChildDragDrop
	End Property
	
	Private Property PageScroller.ChildDragDrop(Value As Boolean)
		FChildDragDrop = Value
		#ifndef __USE_GTK__
			ChangeStyle PGS_DRAGNDROP, Value
		#endif
	End Property
	
	Private Property PageScroller.Position As Integer
		#ifndef __USE_GTK__
			If FHandle Then
				FPosition = SendMessage(FHandle, PGM_GETPOS, 0, 0)
			End If
		#endif
		Return FPosition
	End Property
	
	Private Property PageScroller.Position(Value As Integer)
		FPosition = Max(0, Value)
		#ifdef __USE_GTK__
			If ChildControl AndAlso ChildControl->Handle Then
				Select Case This.Style
				Case psHorizontal
					FPosition = Min(ChildControl->Width - This.Width, FPosition)
					gtk_layout_move(gtk_layout(FHandle), ChildControl->Handle, -FPosition, 0)
					If FPosition = 0 Then gtk_widget_hide(Layout1) Else gtk_widget_show(Layout2)
					If FPosition = ChildControl->Width - This.Width OrElse ChildControl->Width = This.Width Then gtk_widget_hide(Layout2) Else gtk_widget_show(Layout1)
				Case psVertical
					FPosition = Min(ChildControl->Height - This.Height, FPosition)
					gtk_layout_move(gtk_layout(FHandle), ChildControl->Handle, 0, -FPosition)
					If FPosition = 0 Then gtk_widget_hide(Layout1) Else gtk_widget_show(Layout2)
					If FPosition = ChildControl->Height - This.Height OrElse ChildControl->Height = This.Height Then gtk_widget_hide(Layout2) Else gtk_widget_show(Layout1)
				End Select
				If OnScroll Then OnScroll(This, FPosition)
			End If
		#else
			If FHandle Then
				SendMessage(FHandle, PGM_SETPOS, 0, Cast(LPARAM, FPosition))
			End If
		#endif
	End Property
	
	Private Property PageScroller.Style As PageScrollerStyle
		Return FStyle
	End Property
	
	Private Property PageScroller.Style(Value As PageScrollerStyle)
		Dim As PageScrollerStyle OldStyle
		Dim As Integer iWidth, iHeight
		OldStyle = FStyle
		If Value <> FStyle Then
			#ifndef __USE_GTK__
				ChangeStyle PGS_HORZ, False
				ChangeStyle PGS_VERT, False
			#endif
			Select Case Value
			Case psHorizontal
				#ifndef __USE_GTK__
					ChangeStyle PGS_HORZ, True
				#endif
			Case psVertical
				#ifndef __USE_GTK__
					ChangeStyle PGS_VERT, True
				#endif
			End Select
			FStyle = Value
		End If
	End Property
	
	Private Property PageScroller.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property PageScroller.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property PageScroller.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property PageScroller.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	#ifndef __USE_GTK__
		Private Sub PageScroller.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QPageScroller(Sender.Child)
					If .ChildControl AndAlso .ChildControl->Handle Then SendMessage(.Handle, PGM_SETCHILD, 0, Cast(LPARAM, .ChildControl->Handle))
				End With
			End If
		End Sub
		
		Private Sub PageScroller.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Private Sub PageScroller.Add(Ctrl As Control Ptr, Index As Integer = -1)
		If ChildControl = 0 Then
			ChildControl = Ctrl
			Base.Add(Ctrl)
			#ifdef __USE_GTK__
				g_object_ref(Layout1)
				g_object_ref(Layout2)
				gtk_container_remove(GTK_CONTAINER(widget), Layout1)
				gtk_container_remove(GTK_CONTAINER(widget), Layout2)
				gtk_layout_put(GTK_LAYOUT(widget), Layout1, 0, 0)
				gtk_layout_put(GTK_LAYOUT(widget), Layout2, 0, 0)
			#else
				If FHandle AndAlso Ctrl->Handle Then
					SendMessage(FHandle, PGM_SETCHILD, 0, Cast(LPARAM, Ctrl->Handle))
				End If
			#endif
		Else
			Print "MFF: Can't add second control to PageScroller"
		End If
	End Sub
	
	Private Sub PageScroller.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Select Case Message.Msg
			Case WM_PAINT
				Dim As HDC Dc
				Dim As PAINTSTRUCT Ps
				Dc = BeginPaint(FHandle, @Ps)
				FillRect Dc, @Ps.rcPaint, Brush.Handle
				EndPaint FHandle, @Ps
				Message.Result = 0
				Return
			Case CM_NOTIFY
				Dim As NMHDR Ptr nmhdr_ = Cast(NMHDR Ptr, Message.lParam)
				If nmhdr_->code = PGN_CALCSIZE Then
					Dim As NMPGCALCSIZE Ptr nmcal = Cast(NMPGCALCSIZE Ptr, Message.lParam)
					If nmcal->dwFlag = PGF_CALCWIDTH Then
						nmcal->iWidth = ChildControl->Width
					ElseIf nmcal->dwFlag = PGF_CALCHEIGHT Then
						nmcal->iHeight = ChildControl->Height
					EndIf
				ElseIf nmhdr_->code = PGN_SCROLL Then
					Dim As NMPGSCROLL2 Ptr nmgs = Cast(NMPGSCROLL2 Ptr, Message.lParam)
					Dim As Integer NewPos = nmgs->iXpos + nmgs->iYpos
					Select Case nmgs->iDir
					Case PGF_SCROLLDOWN
						NewPos = Min(ChildControl->Height, NewPos + FArrowChangeSize)
					Case PGF_SCROLLRIGHT
						NewPos = Min(ChildControl->Width, NewPos + FArrowChangeSize)
					Case PGF_SCROLLUP, PGF_SCROLLLEFT
						NewPos = Max(0, NewPos - FArrowChangeSize)
					End Select
					nmgs->iScroll = FArrowChangeSize
					If OnScroll Then OnScroll(This, NewPos)
				EndIf
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Operator PageScroller.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Private Sub PageScroller.Layout_SizeAllocate(widget As GtkWidget Ptr, allocation As GdkRectangle Ptr, user_data As Any Ptr)
			Dim As PageScroller Ptr psc = user_data
			If allocation->Width <> psc->AllocatedWidth OrElse allocation->height <> psc->AllocatedHeight Then
				psc->AllocatedWidth = allocation->Width
				psc->AllocatedHeight = allocation->height
				If widget = psc->Handle Then
					Select Case psc->Style
					Case psHorizontal
						gtk_widget_set_size_request(psc->Layout1, 12, allocation->height)
						gtk_widget_set_size_request(psc->Layout2, 12, allocation->height)
						gtk_layout_move(GTK_LAYOUT(psc->Handle), psc->Layout2, allocation->Width - 12, 0)
					Case psVertical
						gtk_widget_set_size_request(psc->Layout1, allocation->width, 12)
						gtk_widget_set_size_request(psc->Layout2, allocation->width, 12)
						gtk_layout_move(gtk_layout(psc->Handle), psc->Layout2, 0, allocation->height - 12)
					End Select
					If psc->ChildControl AndAlso psc->ChildControl->Handle Then
						Dim ChildAllocation As GtkAllocation
						gtk_widget_get_allocation(psc->ChildControl->Handle, @ChildAllocation)
						Select Case psc->Style
						Case psHorizontal
							gtk_widget_set_size_request(psc->ChildControl->Handle, ChildAllocation.width, allocation->height)
						Case psVertical
							gtk_widget_set_size_request(psc->ChildControl->Handle, allocation->width, ChildAllocation.height)
						End Select
						gtk_layout_move(gtk_layout(psc->Handle), psc->ChildControl->Handle, 0, 0)
					End If
				End If
				If psc->OnResize Then psc->OnResize(*psc, allocation->width, allocation->height)
			End If
		End Sub
		
		Private Sub PageScroller.Layout_Press(widget As GtkWidget Ptr)
			Dim As PageScroller Ptr psc = @This
			Dim allocation As GtkAllocation
			Dim As Integer NewPosition
			gtk_widget_get_allocation(widget, @allocation)
			If widget = psc->Layout1 Then
				Select Case psc->Style
				Case psHorizontal
					Dim ChildAllocation As GtkAllocation
					gtk_widget_get_allocation(psc->ChildControl->Handle, @ChildAllocation)
					If ChildAllocation.x < 0 Then
						NewPosition = Min(0, ChildAllocation.x + psc->FArrowChangeSize)
						gtk_layout_move(gtk_layout(psc->Handle), psc->ChildControl->Handle, NewPosition, 0)
						If NewPosition = 0 Then EndedLayout = widget: gtk_widget_queue_draw(widget): Else gtk_widget_show(psc->Layout2)
						psc->FPosition = Abs(NewPosition)
						If psc->OnScroll Then psc->OnScroll(*psc, psc->FPosition)
					End If
				Case psVertical
					Dim ChildAllocation As GtkAllocation
					gtk_widget_get_allocation(psc->ChildControl->Handle, @ChildAllocation)
					If ChildAllocation.y < 0 Then
						NewPosition = Min(0, ChildAllocation.y + psc->FArrowChangeSize)
						gtk_layout_move(gtk_layout(psc->Handle), psc->ChildControl->Handle, 0, Min(0, ChildAllocation.y + psc->FArrowChangeSize))
						If NewPosition = 0 Then EndedLayout = widget: gtk_widget_queue_draw(widget): Else gtk_widget_show(psc->Layout2)
						psc->FPosition = Abs(NewPosition)
						If psc->OnScroll Then psc->OnScroll(*psc, psc->FPosition)
					End If
				End Select
			ElseIf widget = psc->Layout2 Then
				Select Case psc->Style
				Case psHorizontal
					Dim As GtkAllocation ChildAllocation, LayoutAllocation
					gtk_widget_get_allocation(psc->ChildControl->Handle, @ChildAllocation)
					gtk_widget_get_allocation(psc->Handle, @LayoutAllocation)
					If ChildAllocation.x + ChildAllocation.width > LayoutAllocation.width Then
						NewPosition = Max(LayoutAllocation.width - ChildAllocation.width, ChildAllocation.x - psc->FArrowChangeSize)
						gtk_layout_move(gtk_layout(psc->Handle), psc->ChildControl->Handle, Max(LayoutAllocation.width - ChildAllocation.width, ChildAllocation.x - psc->FArrowChangeSize), 0)
						If NewPosition = LayoutAllocation.width - ChildAllocation.width Then EndedLayout = widget: gtk_widget_queue_draw(widget): Else gtk_widget_show(psc->Layout1)
						psc->FPosition = Abs(NewPosition)
						If psc->OnScroll Then psc->OnScroll(*psc, psc->FPosition)
					End If
				Case psVertical
					Dim As GtkAllocation ChildAllocation, LayoutAllocation
					gtk_widget_get_allocation(psc->ChildControl->Handle, @ChildAllocation)
					gtk_widget_get_allocation(psc->Handle, @LayoutAllocation)
					If ChildAllocation.y + ChildAllocation.height > LayoutAllocation.height Then
						NewPosition = Max(LayoutAllocation.height - ChildAllocation.height, ChildAllocation.y - psc->FArrowChangeSize)
						gtk_layout_move(gtk_layout(psc->Handle), psc->ChildControl->Handle, 0, Max(LayoutAllocation.height - ChildAllocation.height, ChildAllocation.y - psc->FArrowChangeSize))
						If NewPosition = LayoutAllocation.height - ChildAllocation.height Then EndedLayout = widget: gtk_widget_queue_draw(widget): Else gtk_widget_show(psc->Layout1)
						psc->FPosition = Abs(NewPosition)
						If psc->OnScroll Then psc->OnScroll(*psc, psc->FPosition)
					End If
				End Select
			End If
		End Sub
		
		Private Function PageScroller.Layout_Draw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Dim As PageScroller Ptr psc = Cast(Any Ptr, data1)
			Dim allocation As GtkAllocation
			Dim As Integer Pressed = 0
			gtk_widget_get_allocation(widget, @allocation)
			If widget <> psc->EndedLayout Then
				If widget = psc->PressedLayout Then
					Pressed = 1
					cairo_set_source_rgb(cr, 160 / 255.0, 160 / 255.0, 160 / 255.0)
					cairo_move_to(cr, allocation.width - 1, 0)
					cairo_line_to(cr, 0, 0)
					cairo_line_to(cr, 0, allocation.height - 1)
					cairo_stroke(cr)
					cairo_set_source_rgb(cr, 1.0, 1.0, 1.0)
					cairo_move_to(cr, allocation.width, 0)
					cairo_line_to(cr, allocation.width, allocation.height)
					cairo_line_to(cr, 0, allocation.height)
					cairo_stroke(cr)
				ElseIf widget = psc->EnteredLayout Then
					cairo_set_source_rgb(cr, 1.0, 1.0, 1.0)
					cairo_move_to(cr, allocation.width - 1, 0)
					cairo_line_to(cr, 0, 0)
					cairo_line_to(cr, 0, allocation.height - 1)
					cairo_stroke(cr)
					cairo_set_source_rgb(cr, 160 / 255.0, 160 / 255.0, 160 / 255.0)
					cairo_move_to(cr, allocation.width, 0)
					cairo_line_to(cr, allocation.width, allocation.height)
					cairo_line_to(cr, 0, allocation.height)
					cairo_stroke(cr)
				End If
			End If
			If widget = psc->Layout1 Then
				If widget = psc->EndedLayout Then
					cairo_set_source_rgb(cr, 160 / 255.0, 160 / 255.0, 160 / 255.0)
				Else
					cairo_set_source_rgb(cr, 0.0, 0.0, 0.0)
				End If
				Select Case psc->Style
				Case psHorizontal
					cairo_move_to(cr, (allocation.width - 3) / 2 + 3 + Pressed, (allocation.height - 5) / 2 + Pressed)
					cairo_line_to(cr, (allocation.width - 3) / 2 + 3 + Pressed, (allocation.height - 5) / 2 + 5 + Pressed)
					cairo_line_to(cr, (allocation.width - 3) / 2 + Pressed, (allocation.height - 5) / 2 + 3 + Pressed)
					cairo_line_to(cr, (allocation.width - 3) / 2 + 3 + Pressed, (allocation.height - 5) / 2 + Pressed)
					cairo_fill(cr)
					If widget = psc->EndedLayout Then
						cairo_set_source_rgb(cr, 1.0, 1.0, 1.0)
						cairo_move_to(cr, (allocation.width - 3) / 2 + 3 + 1, (allocation.height - 5) / 2 + 1)
						cairo_line_to(cr, (allocation.width - 3) / 2 + 3 + 1, (allocation.height - 5) / 2 + 5 + 1)
						cairo_stroke(cr)
					End If
				Case psVertical
					cairo_move_to(cr, (allocation.width - 5) / 2 + Pressed, (allocation.height - 3) / 2 + 3 + Pressed)
					cairo_line_to(cr, (allocation.width - 5) / 2 + 5 + Pressed, (allocation.height - 3) / 2 + 3 + Pressed)
					cairo_line_to(cr, (allocation.width - 5) / 2 + 3 + Pressed, (allocation.height - 3) / 2 + Pressed)
					cairo_line_to(cr, (allocation.width - 5) / 2 + Pressed, (allocation.height - 3) / 2 + 3 + Pressed)
					cairo_fill(cr)
					If widget = psc->EndedLayout Then
						cairo_set_source_rgb(cr, 1.0, 1.0, 1.0)
						cairo_move_to(cr, (allocation.width - 5) / 2 + 1, (allocation.height - 3) / 2 + 3 + 1)
						cairo_line_to(cr, (allocation.width - 3) / 2 + 5 + 1, (allocation.height - 3) / 2 + 3 + 1)
						cairo_stroke(cr)
					End If
				End Select
			ElseIf widget = psc->Layout2 Then
				If widget = psc->EndedLayout Then
					cairo_set_source_rgb(cr, 160 / 255.0, 160 / 255.0, 160 / 255.0)
				Else
					cairo_set_source_rgb(cr, 0.0, 0.0, 0.0)
				End If
				Select Case psc->Style
				Case psHorizontal
					cairo_move_to(cr, (allocation.width - 3) / 2 + Pressed, (allocation.height - 5) / 2 + Pressed)
					cairo_line_to(cr, (allocation.width - 3) / 2 + Pressed, (allocation.height - 5) / 2 + 5 + Pressed)
					cairo_line_to(cr, (allocation.width - 3) / 2 + 3 + Pressed, (allocation.height - 5) / 2 + 3 + Pressed)
					cairo_line_to(cr, (allocation.width - 3) / 2 + Pressed, (allocation.height - 5) / 2 + Pressed)
					cairo_fill(cr)
					If widget = psc->EndedLayout Then
						cairo_set_source_rgb(cr, 1.0, 1.0, 1.0)
						cairo_move_to(cr, (allocation.width - 3) / 2 - 1, (allocation.height - 5) / 2 - 1)
						cairo_line_to(cr, (allocation.width - 3) / 2 - 1, (allocation.height - 3) / 2 + 5 - 1)
						cairo_stroke(cr)
					End If
				Case psVertical
					cairo_move_to(cr, (allocation.width - 5) / 2 + Pressed, (allocation.height - 3) / 2 + Pressed)
					cairo_line_to(cr, (allocation.width - 5) / 2 + 5 + Pressed, (allocation.height - 3) / 2 + Pressed)
					cairo_line_to(cr, (allocation.width - 5) / 2 + 3 + Pressed, (allocation.height - 3) / 2 + 3 + Pressed)
					cairo_line_to(cr, (allocation.width - 5) / 2 + Pressed, (allocation.height - 3) / 2 + Pressed)
					cairo_fill(cr)
					If widget = psc->EndedLayout Then
						cairo_set_source_rgb(cr, 1.0, 1.0, 1.0)
						cairo_move_to(cr, (allocation.width - 5) / 2 - 1, (allocation.height - 3) / 2 - 1)
						cairo_line_to(cr, (allocation.width - 5) / 2 + 5 - 1, (allocation.height - 3) / 2 - 1)
						cairo_stroke(cr)
					End If
				End Select
			ElseIf widget = psc->Handle Then
				If allocation.width <> psc->AllocatedWidth OrElse allocation.height <> psc->AllocatedHeight Then
					Layout_SizeAllocate(widget, @allocation, data1)
				End If
				If Not psc->bCreated Then
					gtk_widget_hide(psc->Layout1)
					Dim As GtkAllocation ChildAllocation, LayoutAllocation
					gtk_widget_get_allocation(psc->ChildControl->Handle, @ChildAllocation)
					gtk_widget_get_allocation(psc->Handle, @LayoutAllocation)
					If ChildAllocation.height = LayoutAllocation.height AndAlso ChildAllocation.width = LayoutAllocation.width Then
						gtk_widget_hide(psc->Layout2)
					End If
					psc->bCreated = True
				End If
				psc->Canvas.HandleSetted = True
				psc->Canvas.Handle = cr
				If psc->OnPaint Then psc->OnPaint(*psc, psc->Canvas)
				psc->Canvas.HandleSetted = False
			End If
			Return False
		End Function
		
		Private Function PageScroller.Layout_ExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			Dim As PageScroller Ptr psc = Cast(Any Ptr, data1)
			Dim As cairo_t Ptr cr = gdk_cairo_create(Event->window)
			Layout_Draw(widget, cr, data1)
			cairo_destroy(cr)
			Return False
		End Function
		
		Private Function PageScroller.Layout_hover_cb(ByVal user_data As gpointer) As gboolean
			If hover_timer_id Then
				If user_data = MouseHoverMessage.Widget Then
					Dim As PageScroller Ptr psc = Cast(PageScroller Ptr, MouseHoverMessage.Sender)
					psc->Layout_Press(MouseHoverMessage.Widget)
					Return True
				End If
			End If
			Return False
		End Function
		
		Private Function PageScroller.Layout_EventProc(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
			Dim As PageScroller Ptr psc = user_data
			Dim As GdkEvent Ptr e = Event
			Select Case Event->Type
			Case GDK_BUTTON_PRESS
				psc->PressedLayout = widget
				psc->Layout_Press(widget)
				gtk_widget_queue_draw(widget)
				If gtk_layout_get_bin_window(gtk_layout(widget)) = e->Motion.window Then
					hover_timer_id = 0
					If widget <> psc->EndedLayout Then
						MouseHoverMessage = Type(psc, e->Motion.x, e->Motion.y, e->Motion.state, 0, widget)
						hover_timer_id = g_timeout_add(500, Cast(GSourceFunc, @Layout_hover_cb), widget)
						Return True
					End If
				End If
				Return True
			Case GDK_BUTTON_RELEASE
				psc->PressedLayout = 0
				hover_timer_id = 0
				gtk_widget_queue_draw(widget)
				Return True
			Case GDK_MOTION_NOTIFY
				If psc->EnteredLayout = 0 Then
					psc->EnteredLayout = widget
					gtk_widget_queue_draw(widget)
				End If
				If gtk_layout_get_bin_window(gtk_layout(widget)) = e->Motion.window Then
					hover_timer_id = 0
					If widget <> psc->EndedLayout AndAlso psc->FAutoScroll = True Then
						MouseHoverMessage = Type(psc, e->Motion.x, e->Motion.y, e->Motion.state, 0, widget)
						hover_timer_id = g_timeout_add(500, Cast(GSourceFunc, @Layout_hover_cb), widget)
						Return True
					End If
				End If
			Case GDK_ENTER_NOTIFY
				psc->EnteredLayout = widget
				gtk_widget_queue_draw(widget)
			Case GDK_LEAVE_NOTIFY
				psc->EnteredLayout = 0
				gtk_widget_queue_draw(widget)
				If widget = psc->EndedLayout Then gtk_widget_hide(widget): psc->EndedLayout = 0
			End Select
			Return False
		End Function
	#endif
	
	Private Constructor PageScroller
		With This
			WLet(FClassName, "PageScroller")
			WLet(FClassAncestor, "SysPager")
			FArrowChangeSize = 40
			#ifdef __USE_GTK__
				widget = gtk_layout_new(NULL, NULL)
				layoutwidget = widget
				Layout1 = gtk_layout_new(NULL, NULL)
				Layout2 = gtk_layout_new(NULL, NULL)
				gtk_layout_put(gtk_layout(widget), Layout1, 0, 0)
				gtk_layout_put(gtk_layout(widget), Layout2, 0, 0)
				#ifdef __USE_GTK3__
					g_signal_connect(widget, "draw", G_CALLBACK(@Layout_Draw), @This)
					g_signal_connect(Layout1, "draw", G_CALLBACK(@Layout_Draw), @This)
					g_signal_connect(Layout2, "draw", G_CALLBACK(@Layout_Draw), @This)
				#else
					g_signal_connect(widget, "expose-event", G_CALLBACK(@Layout_ExposeEvent), @This)
					g_signal_connect(widget, "size-allocate", G_CALLBACK(@Layout_SizeAllocate), @This)
					g_signal_connect(Layout1, "expose-event", G_CALLBACK(@Layout_ExposeEvent), @This)
					g_signal_connect(Layout2, "expose-event", G_CALLBACK(@Layout_ExposeEvent), @This)
				#endif
				gtk_widget_set_events(Layout1, _
				GDK_EXPOSURE_MASK Or _
				GDK_SCROLL_MASK Or _
				GDK_STRUCTURE_MASK Or _
				GDK_KEY_PRESS_MASK Or _
				GDK_KEY_RELEASE_MASK Or _
				GDK_FOCUS_CHANGE_MASK Or _
				GDK_LEAVE_NOTIFY_MASK Or _
				GDK_BUTTON_PRESS_MASK Or _
				GDK_BUTTON_RELEASE_MASK Or _
				GDK_POINTER_MOTION_MASK Or _
				GDK_POINTER_MOTION_HINT_MASK)
				gtk_widget_set_events(Layout2, _
				GDK_EXPOSURE_MASK Or _
				GDK_SCROLL_MASK Or _
				GDK_STRUCTURE_MASK Or _
				GDK_KEY_PRESS_MASK Or _
				GDK_KEY_RELEASE_MASK Or _
				GDK_FOCUS_CHANGE_MASK Or _
				GDK_LEAVE_NOTIFY_MASK Or _
				GDK_BUTTON_PRESS_MASK Or _
				GDK_BUTTON_RELEASE_MASK Or _
				GDK_POINTER_MOTION_MASK Or _
				GDK_POINTER_MOTION_HINT_MASK)
				g_signal_connect(Layout1, "event", G_CALLBACK(@Layout_EventProc), @This)
				g_signal_connect(Layout2, "event", G_CALLBACK(@Layout_EventProc), @This)
				.RegisterClass "PageScroller", @This
			#else
				.RegisterClass "PageScroller", "SysPager"
				Base.Style        = WS_CHILD Or PGS_HORZ
				.ExStyle      = 0
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
				.DoubleBuffered = True
			#endif
			FTabIndex          = -1
			.Width        = 175
			.Height       = 21
			.Child        = @This
		End With
	End Constructor
	
	Private Destructor PageScroller
		#ifndef __USE_GTK__
			UnregisterClass "PageScroller", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
