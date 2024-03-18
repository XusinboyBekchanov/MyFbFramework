'###############################################################################
'#  ContainerControl.bi                                                        #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'###############################################################################

#include once "ContainerControl.bi"

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function ContainerControl.ReadProperty(ByRef PropertyName As String) As Any Ptr
			FTempString = LCase(PropertyName)
			Select Case FTempString
			Case "autosize": Return @FAutoSize
			Case "canvas": Return @Canvas
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function ContainerControl.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "autosize": AutoSize = QBoolean(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	
	#ifdef __USE_GTK__
		Private Function ContainerControl.RegisterClass(ByRef wClassName As WString, Obj As Any Ptr, WndProcAddr As Any Ptr = 0) As Boolean
			If CInt(widget) AndAlso CInt(GTK_IS_NOTEBOOK(widget) <> 1) Then
				Dim PROC As Function(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean = WndProcAddr
				If GTK_IS_WIDGET(widget) AndAlso gtk_widget_is_toplevel(widget) Then
					#ifndef __USE_GTK2__
						box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0)
					#else
						box = gtk_vbox_new(False, 0)
					#endif
					If GTK_IS_WIDGET(box) Then gtk_container_add(GTK_CONTAINER(widget), box)
					layoutwidget = gtk_layout_new(NULL, NULL)
					'gtk_container_add(GTK_CONTAINER(widget), layoutwidget)
					#ifdef __USE_GTK4__
						gtk_box_pack_end(GTK_BOX(box), layoutwidget)
					#else
						gtk_box_pack_end(GTK_BOX(box), layoutwidget, True, True, 0)
					#endif
					'g_signal_connect(layoutwidget, "event", G_CALLBACK(IIF(WndProcAddr = 0, @EventProc, Proc)), Obj)
					'g_signal_connect(layoutwidget, "event-after", G_CALLBACK(IIF(WndProcAddr = 0, @EventAfterProc, Proc)), Obj)
					'g_signal_connect(layoutwidget, "size-allocate", G_CALLBACK(@Control_SizeAllocate), Obj)
					'gtk_widget_set_child_visible(scrolledwidget, true)
				ElseIf GTK_IS_LAYOUT(widget) = 1 Then
					layoutwidget = widget
				ElseIf GTK_IS_FIXED(widget) = 1 Then
					fixedwidget = widget
				ElseIf GTK_IS_BOX(widget) = 1 Then
					box = widget
				#ifdef __USE_GTK3__
				ElseIf GTK_IS_stack(widget) = 1 Then
				#endif
				ElseIf GTK_IS_SCROLLED_WINDOW(widget) Then
					fixedwidget = gtk_fixed_new()
					#ifdef __USE_GTK4__
						gtk_container_add(GTK_CONTAINER(widget), fixedwidget)
					#else
						gtk_scrolled_window_add_with_viewport(GTK_SCROLLED_WINDOW(widget), fixedwidget)
					#endif
				Else
					'box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0)
					'gtk_container_add(GTK_CONTAINER(widget), box)
					layoutwidget = gtk_layout_new(NULL, NULL)
					If GTK_IS_WIDGET(layoutwidget) Then gtk_container_add(GTK_CONTAINER(widget), layoutwidget)
					'gtk_box_pack_end(Gtk_Box(box), layoutwidget, true, true, 0)
					'g_signal_connect(layoutwidget, "event", G_CALLBACK(IIF(WndProcAddr = 0, @EventProc, Proc)), Obj)
					'g_signal_connect(layoutwidget, "event-after", G_CALLBACK(IIF(WndProcAddr = 0, @EventAfterProc, Proc)), Obj)
					'g_signal_connect(layoutwidget, "size-allocate", G_CALLBACK(@Control_SizeAllocate), Obj)
					'fixedwidget = gtk_fixed_new()
					'gtk_container_add(GTK_CONTAINER(widget), fixedwidget)
					'g_signal_connect(fixedwidget, "event", G_CALLBACK(IIF(WndProcAddr = 0, @EventProc, Proc)), Obj)
					'g_signal_connect(fixedwidget, "event-after", G_CALLBACK(IIF(WndProcAddr = 0, @EventAfterProc, Proc)), Obj)
					'g_signal_connect(fixedwidget, "size-allocate", G_CALLBACK(@Control_SizeAllocate), Obj)
				End If
			End If
			Return Base.RegisterClass(wClassName, Obj, WndProcAddr)
		End Function
	#endif
	
	Private Sub ContainerControl.ProcessMessage(ByRef Message As Message)
		Base.ProcessMessage(Message)
	End Sub
	
	Property ContainerControl.Visible As Boolean
		Return Base.Visible
	End Property
	
	Property ContainerControl.Visible(Value As Boolean)
		Base.Visible = Value
	End Property
	
	Property ContainerControl.AutoSize As Boolean
		Return FAutoSize
	End Property
	
	Property ContainerControl.AutoSize(Value As Boolean)
		FAutoSize = Value
	End Property
	
	Private Operator ContainerControl.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Operator ContainerControl.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor ContainerControl
		WLet(FClassName, "ContainerControl")
		FControlParent = True
	End Constructor
	
	Private Destructor ContainerControl
	End Destructor
End Namespace

#ifdef __EXPORT_PROCS__
	Function ControlIsContainer Alias "ControlIsContainer"(Ctrl As My.Sys.Forms.Control Ptr) As Boolean Export
		Return (*Ctrl Is My.Sys.Forms.ContainerControl)
	End Function
#endif
