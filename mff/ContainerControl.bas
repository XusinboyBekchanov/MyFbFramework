﻿'###############################################################################
'#  ContainerControl.bi                                                        #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'###############################################################################

#include once "ContainerControl.bi"

Namespace My.Sys.Forms
	Function ContainerControl.ReadProperty(ByRef PropertyName As String) As Any Ptr
		FTempString = LCase(PropertyName)
		Select Case FTempString
		Case "canvas": Return @Canvas
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function ContainerControl.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	#ifdef __USE_GTK__
		Function ContainerControl.RegisterClass(ByRef wClassName As WString, Obj As Any Ptr, WndProcAddr As Any Ptr = 0) As Boolean
			If CInt(widget) AndAlso CInt(GTK_IS_NOTEBOOK(widget) <> 1) Then
				Dim Proc As Function(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean = WndProcAddr
				If gtk_is_widget(widget) AndAlso gtk_widget_is_toplevel(widget) Then
					#ifdef __USE_GTK3__
						box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0)
					#else
						box = gtk_vbox_new(False, 0)
					#endif
					If gtk_is_widget(box) Then gtk_container_add(GTK_CONTAINER(widget), box)
					layoutwidget = gtk_layout_new(null, null)
					'gtk_container_add(GTK_CONTAINER(widget), layoutwidget)
					gtk_box_pack_end(Gtk_Box(box), layoutwidget, True, True, 0)
					'g_signal_connect(layoutwidget, "event", G_CALLBACK(IIF(WndProcAddr = 0, @EventProc, Proc)), Obj)
					'g_signal_connect(layoutwidget, "event-after", G_CALLBACK(IIF(WndProcAddr = 0, @EventAfterProc, Proc)), Obj)
					'g_signal_connect(layoutwidget, "size-allocate", G_CALLBACK(@Control_SizeAllocate), Obj)
					'gtk_widget_set_child_visible(scrolledwidget, true)
				ElseIf gtk_is_layout(widget) = 1 Then
					layoutwidget = widget
				ElseIf gtk_is_fixed(widget) = 1 Then
					fixedwidget = widget
				ElseIf gtk_is_box(widget) = 1 Then
					box = widget
				Else
					'box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0)
					'gtk_container_add(GTK_CONTAINER(widget), box)
					layoutwidget = gtk_layout_new(null, null)
					If gtk_is_widget(layoutwidget) Then gtk_container_add(GTK_CONTAINER(widget), layoutwidget)
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
	
	Sub ContainerControl.ProcessMessage(ByRef Message As Message)
		Base.ProcessMessage(Message)
	End Sub
	
	Operator ContainerControl.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Operator ContainerControl.Cast As Any Ptr
		Return @This
	End Operator
	
	Constructor ContainerControl
		WLet(FClassName, "ContainerControl")
		FControlParent = True
	End Constructor
	
	Destructor ContainerControl
	End Destructor
End Namespace

#ifdef __EXPORT_PROCS__
	Function ControlIsContainer Alias "ControlIsContainer"(Ctrl As My.Sys.Forms.Control Ptr) As Boolean Export
		Return (*Ctrl Is My.Sys.Forms.ContainerControl)
	End Function
#endif
