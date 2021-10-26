'################################################################################
'#  PageScroller.bi                                                             #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#include once "PageScroller.bi"

Namespace My.Sys.Forms
	Function PageScroller.ReadProperty(ByRef PropertyName As String) As Any Ptr
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
	
	Function PageScroller.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
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
	
	Property PageScroller.ArrowChangeSize As Integer
		Return FArrowChangeSize
	End Property
	
	Property PageScroller.ArrowChangeSize(Value As Integer)
		FArrowChangeSize = Value
	End Property
	
	Property PageScroller.AutoScroll As Boolean
		Return FAutoScroll
	End Property
	
	Property PageScroller.AutoScroll(Value As Boolean)
		FAutoScroll = Value
		#ifndef __USE_GTK__
			ChangeStyle PGS_AUTOSCROLL, Value
		#endif
	End Property
	
	Property PageScroller.ChildDragDrop As Boolean
		Return FChildDragDrop
	End Property
	
	Property PageScroller.ChildDragDrop(Value As Boolean)
		FChildDragDrop = Value
		#ifndef __USE_GTK__
			ChangeStyle PGS_DRAGNDROP, Value
		#endif
	End Property
	
	Property PageScroller.Position As Integer
		#ifndef __USE_GTK__
			If FHandle Then
				FPosition = SendMessage(FHandle, PGM_GETPOS, 0, 0)
			End If
		#endif
		Return FPosition
	End Property
	
	Property PageScroller.Position(Value As Integer)
		FPosition = Value
		#ifndef __USE_GTK__
			If FHandle Then
				SendMessage(FHandle, PGM_SETPOS, 0, Cast(LPARAM, FPosition))
			End If
		#endif
	End Property
	
	Property PageScroller.Style As PageScrollerStyle
		Return FStyle
	End Property
	
	Property PageScroller.Style(Value As PageScrollerStyle)
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
	
	Property PageScroller.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Property PageScroller.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Property PageScroller.TabStop As Boolean
		Return FTabStop
	End Property
	
	Property PageScroller.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	#ifndef __USE_GTK__
		Sub PageScroller.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QPageScroller(Sender.Child)
					If .ChildControl AndAlso .ChildControl->Handle Then SendMessage(.Handle, PGM_SETCHILD, 0, Cast(LPARAM, .ChildControl->Handle))
				End With
			End If
		End Sub
		
		Sub PageScroller.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Sub PageScroller.Add(Ctrl As Control Ptr)
		If ChildControl = 0 Then
			ChildControl = Ctrl
			Base.Add(Ctrl)
			#ifdef __USE_GTK__
				g_object_ref(Layout1)
				g_object_ref(Layout2)
				gtk_container_remove(gtk_container(widget), Layout1)
				gtk_container_remove(gtk_container(widget), Layout2)
				gtk_layout_put(gtk_layout(widget), Layout1, 0, 0)
				gtk_layout_put(gtk_layout(widget), Layout2, 0, 0)
			#else
				If FHandle AndAlso Ctrl->Handle Then
					SendMessage(FHandle, PGM_SETCHILD, 0, Cast(LPARAM, Ctrl->Handle))
				End If
			#endif
		Else
			Print "MFF: Can't add second control to PageScroller"
		End If
	End Sub
	
	Sub PageScroller.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Select Case Message.Msg
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
	
	Operator PageScroller.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Sub PageScroller.Layout_SizeAllocate(widget As GtkWidget Ptr, allocation As GdkRectangle Ptr, user_data As Any Ptr)
			Dim As PageScroller Ptr psc = user_data
			If allocation->width <> psc->AllocatedWidth OrElse allocation->height <> psc->AllocatedHeight Then
				psc->AllocatedWidth = allocation->width
				psc->AllocatedHeight = allocation->height
				If widget = psc->Handle Then
					Select Case psc->Style
					Case psHorizontal
						gtk_widget_set_size_request(psc->Layout1, 12, allocation->height)
						gtk_widget_set_size_request(psc->Layout2, 12, allocation->height)
						gtk_layout_move(gtk_layout(psc->Handle), psc->Layout2, allocation->width - 12, 0)
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
		
		Function PageScroller.Layout_Draw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Dim As PageScroller Ptr psc = Cast(Any Ptr, data1)
			Dim allocation As GtkAllocation
			gtk_widget_get_allocation(widget, @allocation)
			If widget = psc->Layout1 Then
				cairo_set_source_rgb(cr, 0.0, 0.0, 0.0)
				Select Case psc->Style
				Case psHorizontal
					If psc->MouseButtonPressed Then
						Dim ChildAllocation As GtkAllocation
						gtk_widget_get_allocation(psc->ChildControl->Handle, @ChildAllocation)
						If ChildAllocation.x < 0 Then
							gtk_layout_move(gtk_layout(psc->Handle), psc->ChildControl->Handle, Min(0, ChildAllocation.x + psc->FArrowChangeSize), 0)
						End If
					End If
					cairo_move_to(cr, (allocation.width - 3) / 2 + 3, (allocation.height - 5) / 2)
					cairo_line_to(cr, (allocation.width - 3) / 2 + 3, (allocation.height - 5) / 2 + 5)
					cairo_line_to(cr, (allocation.width - 3) / 2, (allocation.height - 5) / 2 + 3)
					cairo_line_to(cr, (allocation.width - 3) / 2 + 3, (allocation.height - 5) / 2)
					cairo_fill(cr)
				Case psVertical
					If psc->MouseButtonPressed Then
						Dim ChildAllocation As GtkAllocation
						gtk_widget_get_allocation(psc->ChildControl->Handle, @ChildAllocation)
						If ChildAllocation.y < 0 Then
							gtk_layout_move(gtk_layout(psc->Handle), psc->ChildControl->Handle, 0, Min(0, ChildAllocation.y + psc->FArrowChangeSize))
						End If
					End If
					cairo_move_to(cr, (allocation.width - 5) / 2, (allocation.height - 3) / 2 + 3)
					cairo_line_to(cr, (allocation.width - 5) / 2 + 5, (allocation.height - 3) / 2 + 3)
					cairo_line_to(cr, (allocation.width - 5) / 2 + 3, (allocation.height - 3) / 2)
					cairo_line_to(cr, (allocation.width - 5) / 2, (allocation.height - 3) / 2 + 3)
					cairo_fill(cr)
				End Select
			ElseIf widget = psc->Layout2 Then
				Select Case psc->Style
				Case psHorizontal
					If psc->MouseButtonPressed Then
						Dim As GtkAllocation ChildAllocation, LayoutAllocation
						gtk_widget_get_allocation(psc->ChildControl->Handle, @ChildAllocation)
						gtk_widget_get_allocation(psc->Handle, @LayoutAllocation)
						If ChildAllocation.x + ChildAllocation.width > LayoutAllocation.width Then
							gtk_layout_move(gtk_layout(psc->Handle), psc->ChildControl->Handle, Max(LayoutAllocation.width - ChildAllocation.width, ChildAllocation.x - psc->FArrowChangeSize), 0)
						End If
					End If
					cairo_move_to(cr, (allocation.width - 3) / 2, (allocation.height - 5) / 2)
					cairo_line_to(cr, (allocation.width - 3) / 2, (allocation.height - 5) / 2 + 5)
					cairo_line_to(cr, (allocation.width - 3) / 2 + 3, (allocation.height - 5) / 2 + 3)
					cairo_line_to(cr, (allocation.width - 3) / 2, (allocation.height - 5) / 2)
					cairo_fill(cr)
				Case psVertical
					If psc->MouseButtonPressed Then
						Dim As GtkAllocation ChildAllocation, LayoutAllocation
						gtk_widget_get_allocation(psc->ChildControl->Handle, @ChildAllocation)
						gtk_widget_get_allocation(psc->Handle, @LayoutAllocation)
						If ChildAllocation.y + ChildAllocation.height > LayoutAllocation.height Then
							gtk_layout_move(gtk_layout(psc->Handle), psc->ChildControl->Handle, Max(LayoutAllocation.height - ChildAllocation.height, ChildAllocation.y - psc->FArrowChangeSize), 0)
						End If
					End If
					cairo_move_to(cr, (allocation.width - 5) / 2, (allocation.height - 3) / 2)
					cairo_line_to(cr, (allocation.width - 5) / 2 + 5, (allocation.height - 3) / 2)
					cairo_line_to(cr, (allocation.width - 5) / 2 + 3, (allocation.height - 3) / 2 + 3)
					cairo_line_to(cr, (allocation.width - 5) / 2, (allocation.height - 3) / 2)
					cairo_fill(cr)
				End Select
			ElseIf widget = psc->Handle Then
				If allocation.width <> psc->AllocatedWidth OrElse allocation.height <> psc->AllocatedHeight Then
					Layout_SizeAllocate(widget, @allocation, data1)
				End If
				psc->Canvas.HandleSetted = True
				psc->Canvas.Handle = cr
				If psc->OnPaint Then psc->OnPaint(*psc, psc->Canvas)
				psc->Canvas.HandleSetted = False
			End If
			Return False
		End Function
		
		Function PageScroller.Layout_ExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			Dim As PageScroller Ptr psc = Cast(Any Ptr, data1)
			Dim As cairo_t Ptr cr = gdk_cairo_create(Event->window)
			Layout_Draw(widget, cr, data1)
			cairo_destroy(cr)
			Return False
		End Function
		
		Function PageScroller.Layout_EventProc(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
			Dim As PageScroller Ptr psc = user_data
			Dim As GdkEvent Ptr e = Event
			Select Case Event->Type
			Case GDK_BUTTON_PRESS
				psc->MouseButtonPressed = True
				Return True
			Case GDK_BUTTON_RELEASE
				psc->MouseButtonPressed = False
				Return True
			Case GDK_MOTION_NOTIFY
				
			Case GDK_ENTER_NOTIFY
				psc->MouseButtonEntered = True 
			Case GDK_LEAVE_NOTIFY
				psc->MouseButtonEntered = False
			End Select
			Return False
		End Function
	#endif
	
	Constructor PageScroller
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
	
	Destructor PageScroller
		#ifndef __USE_GTK__
			UnregisterClass "PageScroller", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
