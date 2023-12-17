'################################################################################
'#  Form.bi                                                                     #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                      #
'#  Based on:                                                                   #
'#   TForm.bi                                                                   #
'#   FreeBasic Windows GUI ToolKit                                              #
'#   Copyright (c) 2007-2008 Nastase Eodor                                      #
'#   Version 1.0.0                                                              #
'#  Updated and added cross-platform                                            #
'#  by Xusinboy Bekchanov (2018-2019), Liu XiaLin (2020)                        #
'################################################################################

#include once "Form.bi"
#include once "Application.bi"
#ifdef __USE_WINAPI__
	#include once "win/uxtheme.bi"
	#include once "DarkMode/UAHMenuBar.bi"
#endif

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function Form.ReadProperty(ByRef PropertyName As String) As Any Ptr
			FTempString = LCase(PropertyName)
			Select Case FTempString
			Case "activecontrol": Return FActiveControl
			Case "borderstyle": Return @FBorderStyle
			Case "cancelbutton": Return FCancelButton
			Case "caption": Return This.FText.vptr
			Case "defaultbutton": Return FDefaultButton
			Case "icon": Return @Icon
			Case "controlbox": Return @FControlBox
			Case "keypreview": Return @FKeyPreview
			Case "minimizebox": Return @FMinimizeBox
			Case "maximizebox": Return @FMaximizeBox
			Case "formstyle": Return @FFormStyle
			Case "menu": Return Menu
			Case "mainform": Return @FMainForm
			Case "modalresult": Return @ModalResult
			Case "opacity": Return @FOpacity
			Case "owner": Return FOwner
			Case "transparent": Return @FTransparent
			Case "transparentcolor": Return @FTransparentColor
			Case "windowstate": Return @FWindowState
			Case "startposition": Return @FStartPosition
			Case "graphic": Return Cast(Any Ptr, @This.Graphic)
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function Form.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case "activecontrol": This.ActiveControl = 0
				Case "menu": This.Menu = 0
				Case "cancelbutton": This.CancelButton = 0
				Case "defaultbutton": This.DefaultButton = 0
				Case "owner": This.Owner = 0
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "activecontrol": This.ActiveControl = Cast(Control Ptr, Value)
				Case "borderstyle": This.BorderStyle = QInteger(Value)
				Case "cancelbutton": This.CancelButton = Cast(Control Ptr, Value)
				Case "caption": This.Caption = QWString(Value)
				Case "defaultbutton": This.DefaultButton = Cast(Control Ptr, Value)
				Case "formstyle": This.FormStyle = QInteger(Value)
				Case "controlbox": This.ControlBox = QBoolean(Value)
				Case "keypreview": This.KeyPreview = QBoolean(Value)
				Case "minimizebox": This.MinimizeBox = QBoolean(Value)
				Case "maximizebox": This.MaximizeBox = QBoolean(Value)
				Case "icon": This.Icon = QWString(Value)
				Case "mainform": This.MainForm = QBoolean(Value)
				Case "menu": This.Menu = Cast(MainMenu Ptr, Value)
				Case "modalresult": This.ModalResult = QInteger(Value)
				Case "opacity": This.Opacity = QInteger(Value)
				Case "owner": This.Owner = Cast(Form Ptr, Value)
					#ifdef __USE_GTK__
					Case "parentwidget": This.ParentWidget = Value
					#endif
				Case "text": This.Text = QWString(Value)
				Case "transparent": This.Transparent = QBoolean(Value)
				Case "transparentcolor": This.TransparentColor = QInteger(Value)
				Case "windowstate": This.WindowState = QInteger(Value)
				Case "startposition": This.StartPosition = QInteger(Value)
				Case "visible": This.Visible = QBoolean(Value)
				Case "graphic": This.Graphic = QWString(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Property Form.ActiveControl As Control Ptr
		Return FActiveControl
	End Property
	
	Private Property Form.ActiveControl(Value As Control Ptr)
		FActiveControl = Value
		If FActiveControl Then FActiveControl->SetFocus
		If OnActiveControlChange Then OnActiveControlChange(*Designer, This)
	End Property
	
	Private Property Form.Owner As Form Ptr
		Return Cast(Form Ptr, FOwner)
	End Property
	
	Private Property Form.Owner(Value As Form Ptr)
		If Value <> FOwner Then
			FOwner = Value
			#ifdef __USE_WINAPI__
				If Handle AndAlso FOwner AndAlso FOwner->Handle Then
					SetParent FOwner->Handle, Handle
				End If
			#endif
		End If
	End Property
	
	Private Property Form.KeyPreview As Boolean
		Return FKeyPreview
	End Property
	
	Private Property Form.KeyPreview(Value As Boolean)
		FKeyPreview = Value
	End Property
	
	#ifdef __USE_GTK__
		Private Property Form.ParentWidget As GtkWidget Ptr
			Return FParentWidget
		End Property
		
		Private Property Form.ParentWidget(Value As GtkWidget Ptr)
			If Not GTK_IS_BOX(widget) Then
				g_object_ref(box)
				gtk_container_remove(GTK_CONTAINER(WindowWidget), box)
				widget = box
				gtk_widget_set_size_request(widget, FWidth, FHeight)
				#ifdef __USE_GTK3__
					HeaderBarWidget = gtk_header_bar_new()
					gtk_widget_set_sensitive(HeaderBarWidget, False)
					gtk_header_bar_set_has_subtitle(GTK_HEADER_BAR(HeaderBarWidget), False)
					'gtk_widget_set_size_request(widget, FW, 1)
					gtk_header_bar_set_title(GTK_HEADER_BAR(HeaderBarWidget), ToUtf8(FText))
					'gtk_header_bar_set_show_close_button(gtk_header_bar(HeaderBarWidget), True)
				#else
					HeaderBarWidget = gtk_label_new(ToUtf8(FText))
					'Dim As GdkColor color1, color2
					'gdk_color_parse ("black", @color1)
					'gtk_widget_modify_bg(HeaderBarWidget, GTK_STATE_NORMAL, @color1)
					'gdk_color_parse ("white", @color2)
					'gtk_widget_modify_fg(HeaderBarWidget, GTK_STATE_NORMAL, @color2)
				#endif
				#ifdef __USE_GTK4__
					gtk_box_pack_start(GTK_BOX(widget), HeaderBarWidget)
				#else
					gtk_box_pack_start(GTK_BOX(widget), HeaderBarWidget, False, False, 0)
				#endif
				Base.ParentWidget = Value
				BorderStyle = BorderStyle
			End If
		End Property
	#elseif defined(__USE_WASM__)
		Private Function Form.GetContent() As UString
			Return ""
		End Function
	#endif
	
	Private Property Form.DefaultButton As Control Ptr
		Return FDefaultButton
	End Property
	
	Private Property Form.DefaultButton(Value As Control Ptr)
		FDefaultButton = Value
		#ifdef __USE_GTK__
			If Value <> 0 Then
				gtk_widget_set_can_default(Value->widget, True)
				If GTK_IS_WINDOW(widget) Then
					gtk_window_set_default(GTK_WINDOW(widget), Value->widget)
				End If
				'gtk_widget_grab_default(Value->Widget)
			Else
				If GTK_IS_WINDOW(widget) Then
					gtk_window_set_default(GTK_WINDOW(widget), NULL)
				End If
			End If
		#endif
		If FDefaultButton AndAlso UCase((*FDefaultButton).ClassName) = "COMMANDBUTTON" Then
			
		End If
	End Property
	
	Private Property Form.CancelButton As Control Ptr
		Return FCancelButton
	End Property
	
	Private Property Form.CancelButton(Value As Control Ptr)
		FCancelButton = Value
	End Property
	
	Private Property Form.MainForm As Boolean
		Return FMainForm
	End Property
	
	Private Property Form.MainForm(Value As Boolean)
		If Value <> FMainForm Then
			FMainForm = Value
			If pApp <> 0 Then
				If pApp->MainForm <> 0 Then Cast(Form Ptr, pApp->MainForm)->MainForm = False
				#ifdef __USE_WINAPI__
					ChangeExStyle WS_EX_APPWINDOW, Value
				#elseif defined(__USE_GTK__)
					If GTK_IS_BOX(widget) Then Exit Property
				#endif
				If FMainForm Then
					pApp->MainForm = @This
				Else
					pApp->MainForm = 0
				End If
			End If
		End If
	End Property
	
	Private Property Form.Menu As MainMenu Ptr
		Return FMenu
	End Property
	
	Private Property Form.Menu(Value As MainMenu Ptr)
		FMenu = Value
		If FMenu Then FMenu->ParentWindow = @This
	End Property
	
	Private Property Form.StartPosition As Integer
		Return FStartPosition
	End Property
	
	Private Property Form.StartPosition(Value As Integer)
		FStartPosition = Value
		If Not FDesignMode Then
			#ifdef __USE_GTK__
				If GTK_IS_WINDOW(widget) Then
					Select Case FStartPosition
					Case 0: gtk_window_set_position(GTK_WINDOW(widget), GTK_WIN_POS_NONE) ' Manual
					Case 1, 4 ' CenterScreen, CenterParent
						If FStartPosition = 4 AndAlso FParent Then ' CenterParent
							gtk_window_set_position(GTK_WINDOW(widget), GTK_WIN_POS_CENTER_ON_PARENT)
							With *Cast(Control Ptr, FParent)
								gtk_window_move(GTK_WINDOW(widget), ScaleX(.Left + (.Width - This.FWidth) \ 2), ScaleY(.Top + (.Height - This.FHeight) \ 2))
							End With
						Else ' CenterScreen
							gtk_window_set_position(GTK_WINDOW(widget), GTK_WIN_POS_CENTER)
							#ifdef __USE_GTK4__
								Dim As GdkRectangle workarea
								gdk_monitor_get_workarea(gdk_display_get_primary_monitor(gdk_display_get_default()), @workarea)
								gtk_window_move(GTK_WINDOW(widget), (workarea.width - ScaleX(This.FWidth)) \ 2, (workarea.height - ScaleY(This.FHeight)) \ 2)
							#else
								gtk_window_move(GTK_WINDOW(widget), (gdk_screen_width() - ScaleX(This.FWidth)) \ 2, (gdk_screen_height() - ScaleY(This.FHeight)) \ 2)
							#endif
						End If
					Case 2: gtk_window_set_position(GTK_WINDOW(widget), GTK_WIN_POS_MOUSE) ' DefaultLocation
					Case 3: 'gtk_window_set_default_size(gtk_window(widget), -1, -1) ' DefaultBounds
						gtk_window_resize(GTK_WINDOW(widget), 1000, 600)
					End Select
				End If
			#elseif defined(__USE_WINAPI__)
				If FStartPosition = FormStartPosition.CenterParent Then
					CenterToParent
				ElseIf FStartPosition = FormStartPosition.CenterScreen Then
					CenterToScreen
				End If
			#endif
		End If
	End Property
	
	Private Property Form.Opacity As Integer
		Return FOpacity
	End Property
	
	Private Property Form.Opacity(Value As Integer)
		FOpacity = Value
		#ifdef __USE_GTK__
			#ifdef __USE_GTK3__
				gtk_widget_set_opacity(widget, Value / 255.0)
			#else
				If GTK_IS_WINDOW(widget) Then
					#ifdef __USE_GTK4__
						gtk_widget_set_opacity(GTK_WIDGET(widget), Value / 255.0)
					#else
						gtk_window_set_opacity(GTK_WINDOW(widget), Value / 255.0)
					#endif
				End If
			#endif
		#elseif defined(__USE_WINAPI__)
			ChangeExStyle WS_EX_LAYERED, FOpacity <> 255 OrElse FTransparent
			If FHandle Then SetLayeredWindowAttributes(FHandle, IIf(FTransparentColor = -1, FBackColor, FTransparentColor), FOpacity, IIf(FTransparent, LWA_COLORKEY, 0) Or LWA_ALPHA)
		#endif
	End Property
	
	Private Property Form.Transparent As Boolean
		Return FTransparent
	End Property
	
	Private Property Form.Transparent(Value As Boolean)
		FTransparent = Value
		#ifdef __USE_WINAPI__
			ChangeExStyle WS_EX_LAYERED, FOpacity <> 255 OrElse FTransparent
			If FHandle Then SetLayeredWindowAttributes(FHandle, IIf(FTransparentColor = -1, FBackColor, FTransparentColor), FOpacity, IIf(FTransparent, LWA_COLORKEY, 0) Or LWA_ALPHA)
		#endif
	End Property
	
	Private Property Form.TransparentColor As Integer
		Return FTransparentColor
	End Property
	
	Private Property Form.TransparentColor(Value As Integer)
		FTransparentColor = Value
		#ifdef __USE_WINAPI__
			If FHandle Then SetLayeredWindowAttributes(FHandle, IIf(FTransparentColor = -1, FBackColor, FTransparentColor), FOpacity, IIf(FTransparent, LWA_COLORKEY, 0) Or LWA_ALPHA)
		#endif
	End Property
	
	Private Property Form.ControlBox As Boolean
		Return FControlBox
	End Property
	
	Private Property Form.ControlBox(Value As Boolean)
		FControlBox = Value
		#ifdef __USE_WINAPI__
			ChangeStyle WS_SYSMENU, Value
			SetWindowPos(FHandle, 0, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE Or SWP_DRAWFRAME)
		#endif
	End Property
	
	Private Property Form.MinimizeBox As Boolean
		Return FMinimizeBox
	End Property
	
	Private Property Form.MinimizeBox(Value As Boolean)
		FMinimizeBox = Value
		#ifdef __USE_WINAPI__
			ChangeStyle WS_MINIMIZEBOX, Value
			SetWindowPos(FHandle, 0, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE Or SWP_DRAWFRAME)
		#endif
	End Property
	
	Private Property Form.MaximizeBox As Boolean
		Return FMaximizeBox
	End Property
	
	Private Property Form.MaximizeBox(Value As Boolean)
		FMaximizeBox = Value
		#ifdef __USE_WINAPI__
			ChangeStyle WS_MAXIMIZEBOX, Value
			SetWindowPos(FHandle, 0, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE Or SWP_DRAWFRAME)
		#endif
	End Property
	
	Private Property Form.BorderStyle As Integer
		Return FBorderStyle
	End Property
	
	Private Property Form.BorderStyle(Value As Integer)
		FBorderStyle = Value
		#ifdef __USE_GTK__
			Select Case Value
			Case FormBorderStyle.None, FormBorderStyle.FixedToolWindow, FormBorderStyle.Fixed3D, FormBorderStyle.FixedSingle, FormBorderStyle.FixedDialog
				Dim As GdkGeometry hints
				hints.base_width = FWidth
				hints.base_height = FHeight
				hints.min_width = FWidth
				hints.min_height = FHeight
				hints.width_inc = 1
				hints.height_inc = 1
				If GTK_IS_WINDOW(widget) Then
					#ifndef __USE_GTK4__
						gtk_window_set_geometry_hints(GTK_WINDOW(widget), NULL, @hints, GDK_HINT_RESIZE_INC Or GDK_HINT_MIN_SIZE Or GDK_HINT_BASE_SIZE)
					#endif
				End If
			Case FormBorderStyle.SizableToolWindow, FormBorderStyle.Sizable
				
			End Select
			Select Case Value
			Case FormBorderStyle.None
				If GTK_IS_WINDOW(widget) Then
					gtk_window_set_decorated(GTK_WINDOW(widget), False)
					gtk_window_set_type_hint(GTK_WINDOW(widget), GDK_WINDOW_TYPE_HINT_SPLASHSCREEN)
					'#ifndef __USE_GTK3__
					'	gtk_window_set_resizable(GTK_WINDOW(widget), False)
					'#endif
				Else
					gtk_widget_set_visible(HeaderBarWidget, False)
				End If
			Case FormBorderStyle.SizableToolWindow
				If GTK_IS_WINDOW(widget) Then
					gtk_window_set_decorated(GTK_WINDOW(widget), True)
					gtk_window_set_type_hint(GTK_WINDOW(widget), GDK_WINDOW_TYPE_HINT_DOCK)
					gtk_window_set_resizable(GTK_WINDOW(widget), True)
				Else
					gtk_widget_set_visible(HeaderBarWidget, True)
				End If
			Case FormBorderStyle.FixedToolWindow
				If GTK_IS_WINDOW(widget) Then
					gtk_window_set_decorated(GTK_WINDOW(widget), True)
					gtk_window_set_type_hint(GTK_WINDOW(widget), GDK_WINDOW_TYPE_HINT_DOCK)
					'#ifndef __USE_GTK3__
					'	gtk_window_set_resizable(GTK_WINDOW(widget), False)
					'#endif
				Else
					gtk_widget_set_visible(HeaderBarWidget, True)
				End If
			Case FormBorderStyle.Sizable
				If GTK_IS_WINDOW(widget) Then
					gtk_window_set_decorated(GTK_WINDOW(widget), True)
					gtk_window_set_type_hint(GTK_WINDOW(widget), GDK_WINDOW_TYPE_HINT_NORMAL)
					gtk_window_set_resizable(GTK_WINDOW(widget), True)
				Else
					gtk_widget_set_visible(HeaderBarWidget, True)
				End If
			Case FormBorderStyle.Fixed3D
				If GTK_IS_WINDOW(widget) Then
					gtk_window_set_decorated(GTK_WINDOW(widget), True)
					gtk_window_set_type_hint(GTK_WINDOW(widget), GDK_WINDOW_TYPE_HINT_DIALOG)
					'#ifndef __USE_GTK3__
					'	gtk_window_set_resizable(GTK_WINDOW(widget), False)
					'#endif
				Else
					gtk_widget_set_visible(HeaderBarWidget, True)
				End If
			Case FormBorderStyle.FixedSingle
				If GTK_IS_WINDOW(widget) Then
					gtk_window_set_decorated(GTK_WINDOW(widget), True)
					gtk_window_set_type_hint(GTK_WINDOW(widget), GDK_WINDOW_TYPE_HINT_DIALOG)
					'#ifndef __USE_GTK3__
					'	gtk_window_set_resizable(GTK_WINDOW(widget), False)
					'#endif
				Else
					gtk_widget_set_visible(HeaderBarWidget, True)
				End If
			Case FormBorderStyle.FixedDialog
				If GTK_IS_WINDOW(widget) Then
					gtk_window_set_decorated(GTK_WINDOW(widget), True)
					gtk_window_set_type_hint(GTK_WINDOW(widget), GDK_WINDOW_TYPE_HINT_DIALOG)
					'#ifndef __USE_GTK3__
					'	gtk_window_set_resizable(GTK_WINDOW(widget), False)
					'#endif
				Else
					gtk_widget_set_visible(HeaderBarWidget, True)
				End If
			End Select
		#elseif defined(__USE_WINAPI__)
			ChangeStyle WS_POPUP, False
			ChangeStyle WS_BORDER, False
			ChangeStyle WS_THICKFRAME, False
			ChangeStyle WS_DLGFRAME, False
			ChangeStyle DS_CONTROL, False
			ChangeExStyle WS_EX_TOOLWINDOW, False
			ChangeExStyle WS_EX_CLIENTEDGE, False
			ChangeExStyle WS_EX_WINDOWEDGE, False
			ChangeExStyle WS_EX_DLGMODALFRAME, False
			Select Case Value
			Case FormBorderStyle.None
				ChangeStyle WS_CAPTION, False
				ChangeStyle DS_CONTROL, True
				If Not FDesignMode Then ChangeStyle WS_POPUP, True
				ChangeExStyle WS_EX_CONTROLPARENT, True
			Case FormBorderStyle.SizableToolWindow
				ChangeStyle WS_BORDER, True
				ChangeStyle WS_THICKFRAME, True
				ChangeExStyle WS_EX_TOOLWINDOW, True
			Case FormBorderStyle.FixedToolWindow
				ChangeStyle WS_BORDER, True
				ChangeStyle WS_DLGFRAME, True
				ChangeExStyle WS_EX_TOOLWINDOW, True
			Case FormBorderStyle.Sizable
				ChangeStyle WS_THICKFRAME, True
				ChangeStyle WS_DLGFRAME, True
				ChangeStyle WS_BORDER, True
				ChangeExStyle WS_EX_WINDOWEDGE, True
			Case FormBorderStyle.Fixed3D
				ChangeStyle WS_DLGFRAME, True
				ChangeStyle WS_BORDER, True
				ChangeExStyle WS_EX_WINDOWEDGE, True
				ChangeExStyle WS_EX_CLIENTEDGE, True
			Case FormBorderStyle.FixedSingle
				ChangeStyle WS_DLGFRAME, True
				ChangeStyle WS_BORDER, True
				ChangeExStyle WS_EX_WINDOWEDGE, True
			Case FormBorderStyle.FixedDialog
				ChangeStyle WS_DLGFRAME, True
				ChangeStyle WS_BORDER, True
				ChangeExStyle WS_EX_DLGMODALFRAME, True
			End Select
			If Not FShowCaption Then ChangeStyle WS_CAPTION, False
			If FHandle Then SetWindowPos(FHandle, 0, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE Or SWP_DRAWFRAME)
		#endif
	End Property
	
	Private Property Form.FormStyle As Integer
		Return FFormStyle
	End Property
	
	#ifdef __USE_GTK__
		Private Function Form.Client_Draw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			If GTK_IS_LAYOUT(widget) Then
				#ifndef __USE_GTK2__
					Dim As Integer AllocatedWidth = gtk_widget_get_allocated_width(widget), AllocatedHeight = gtk_widget_get_allocated_height(widget)
				#else
					Dim As Integer AllocatedWidth = widget->allocation.width, AllocatedHeight = widget->allocation.height
				#endif
				cairo_rectangle(cr, 0.0, 0.0, AllocatedWidth, AllocatedHeight)
				cairo_set_source_rgb(cr, 171 / 255.0, 171 / 255.0, 171 / 255.0)
				cairo_fill(cr)
			End If
			Return False
		End Function
		
		Private Function Form.Client_ExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			#ifdef __USE_GTK2__
				Dim As cairo_t Ptr cr = gdk_cairo_create(Event->window)
				Client_Draw(widget, cr, data1)
				cairo_destroy(cr)
			#endif
			Return False
		End Function
	#endif
	
	Private Property Form.FormStyle(Value As Integer)
		If Value = FFormStyle Then Exit Property
		FFormStyle = Value
		Select Case FFormStyle
		Case 0 'fsNormal
			#ifdef __USE_GTK__
				If GTK_IS_WINDOW(widget) Then
					gtk_window_set_keep_above (GTK_WINDOW(widget), False)
				End If
			#elseif defined(__USE_WINAPI__)
				If (ExStyle And WS_EX_TOPMOST) = WS_EX_TOPMOST Then
					ExStyle = ExStyle And Not WS_EX_TOPMOST
					If FHandle Then SetWindowPos Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOACTIVATE Or SWP_NOSIZE
				End If
			#endif
		Case 1 'fsMDIForm
			#ifdef __USE_GTK__
				FClient = gtk_layout_new(NULL, NULL)
				#ifdef __USE_GTK3__
					g_signal_connect(FClient, "draw", G_CALLBACK(@Client_Draw), @This)
				#else
					g_signal_connect(FClient, "expose-event", G_CALLBACK(@Client_ExposeEvent), @This)
				#endif
				If GTK_IS_WIDGET(layoutwidget) Then gtk_container_add(GTK_CONTAINER(layoutwidget), FClient)
			#endif
		Case 2 'fsMDIChild
			#ifdef __USE_WINAPI__
				ChangeExStyle WS_EX_MDICHILD, True
				If FHandle <> 0 AndAlso Not DesignMode Then RecreateWnd
			#endif
		Case 3 'fsStayOnTop
			#ifdef __USE_GTK__
				If GTK_IS_WINDOW(widget) Then
					gtk_window_set_keep_above (GTK_WINDOW(widget), True)
				End If
			#elseif defined(__USE_WINAPI__)
				If (ExStyle And WS_EX_TOPMOST) <> WS_EX_TOPMOST Then
					ExStyle = ExStyle Or WS_EX_TOPMOST
					If FHandle Then SetWindowPos Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOACTIVATE Or SWP_NOSIZE
				End If
			#endif
		End Select
	End Property
	
	Private Property Form.Parent As Control Ptr
		Return Cast(Control Ptr, @FParent)
	End Property
	
	Private Property Form.Parent(value As Control Ptr)
		#ifdef __USE_GTK__
			If FormStyle = fsMDIChild Then
				Base.FParent = value
			Else
				Base.Parent = value
			End If
		#else
			Base.Parent = value
		#endif
		If *value Is Form Then
			If Cast(Form Ptr, value)->FFormStyle = fsMDIForm Then
				#ifdef __USE_GTK__
					ParentWidget = Cast(Form Ptr, value)->FClient
				#elseif defined(__USE_WINAPI__)
					If IsWindow(FHandle) Then
						SetParent(FHandle, IIf(value, Cast(Form Ptr, value)->FClient, 0))
					End If
				#endif
			End If
		End If
	End Property
	
	Property Form.WindowState As Integer
		#ifdef __USE_GTK__
			If GTK_IS_WINDOW(widget) Then
				#ifdef __USE_GTK4__
					If gtk_window_is_maximized(GTK_WINDOW(widget)) Then
				#else
					If gdk_window_get_state(gtk_widget_get_window(widget)) And GDK_WINDOW_STATE_MAXIMIZED = GDK_WINDOW_STATE_MAXIMIZED Then
				#endif
					FWindowState = WindowStates.wsMaximized
					#ifndef __USE_GTK4__
					ElseIf gdk_window_get_state(gtk_widget_get_window(widget)) And GDK_WINDOW_STATE_ICONIFIED = GDK_WINDOW_STATE_ICONIFIED Then
						FWindowState = WindowStates.wsMinimized
					#endif
				Else
					FWindowState = WindowStates.wsNormal
				End If
			End If
		#elseif defined(__USE_WINAPI__)
			If Handle Then
				If IsIconic(Handle) Then
					FWindowState = WindowStates.wsMinimized
				ElseIf IsZoomed(Handle) Then
					FWindowState = WindowStates.wsMaximized
				Else
					FWindowState = WindowStates.wsNormal
				End If
			End If
		#endif
		Return FWindowState
	End Property
	
	Private Property Form.WindowState(Value As Integer)
		FWindowState = Value
		#ifdef __USE_GTK__
			If GTK_IS_WINDOW(widget) Then
				gtk_window_deiconify(GTK_WINDOW(widget))
				gtk_window_unmaximize(GTK_WINDOW(widget))
				Select Case FWindowState
				Case WindowStates.wsMinimized:  gtk_window_iconify(GTK_WINDOW(widget))
				Case WindowStates.wsMaximized:  gtk_window_maximize(GTK_WINDOW(widget))
				Case WindowStates.wsNormal:
				Case WindowStates.wsHide:       gtk_widget_hide(widget)
				End Select
			End If
		#elseif defined(__USE_WINAPI__)
			If Handle Then
				If Not FDesignMode Then
					Dim nState As Long
					Select Case FWindowState
					Case WindowStates.wsMinimized:  nState = SW_SHOWMINIMIZED
					Case WindowStates.wsMaximized:  nState = SW_SHOWMAXIMIZED
					Case WindowStates.wsNormal:     nState = SW_SHOWNORMAL
					Case WindowStates.wsHide:       nState = SW_HIDE
					End Select
					ShowWindow(Handle, nState)
				End If
			Else
				ChangeStyle WS_MINIMIZE, False
				ChangeStyle WS_MAXIMIZE, False
				ChangeStyle WS_VISIBLE, True
				Select Case FWindowState
				Case WindowStates.wsMinimized:  ChangeStyle WS_MINIMIZE, True
				Case WindowStates.wsMaximized:  ChangeStyle WS_MAXIMIZE, True
				Case WindowStates.wsNormal:
				Case WindowStates.wsHide:       ChangeStyle WS_VISIBLE, False
				End Select
			End If
		#endif
	End Property
	
	Private Property Form.Caption ByRef As WString
		Return Text
	End Property
	
	Private Property Form.Caption(ByRef Value As WString)
		Text = Value
	End Property
	
	Private Property Form.Text ByRef As WString
		Return Base.Text
	End Property
	
	Private Property Form.Text(ByRef Value As WString)
		Base.Text = Value
		#ifdef __USE_GTK__
			If GTK_IS_WINDOW(widget) Then
				If Value = "" Then
					gtk_window_set_title(GTK_WINDOW(widget), !"\0")
				Else
					gtk_window_set_title(GTK_WINDOW(widget), ToUtf8(Value))
				End If
			ElseIf HeaderBarWidget Then
				#ifdef __USE_GTK3__
					If Value = "" Then
						gtk_header_bar_set_title(GTK_HEADER_BAR(HeaderBarWidget), !"\0")
					Else
						gtk_header_bar_set_title(GTK_HEADER_BAR(HeaderBarWidget), ToUtf8(Value))
					End If
				#else
					If Value = "" Then
						gtk_label_set_text(GTK_LABEL(HeaderBarWidget), !"\0")
					Else
						gtk_label_set_text(GTK_LABEL(HeaderBarWidget), ToUtf8(Value))
					End If
				#endif
			End If
		#elseif defined(__USE_JNI__)
			If FHandle Then
				(*env)->CallVoidMethod(env, FHandle, GetMethodID(*FClassAncestor, "setTitle", "(Ljava/lang/CharSequence;)V"), (*env)->NewStringUTF(env, ToUtf8(FText)))
			End If
		#elseif defined(__USE_WASM__)
			SetTitle(Value)
		#endif
	End Property
	
	Private Property Form.Enabled As Boolean
		Return Base.Enabled
	End Property
	
	Private Property Form.Enabled(Value As Boolean)
		Base.Enabled = Value
	End Property
	
	Private Sub Form.ActiveControlChanged(ByRef Sender As Control)
		If Sender.Child Then
			With QForm(Sender.Child)
				If .OnActiveControlChange Then .OnActiveControlChange(*QForm(Sender.Child).Designer, QForm(Sender.Child))
			End With
		End If
	End Sub
	
	#ifdef __USE_WINAPI__
		Private Sub Form.WNDPROC(ByRef message As Message)
			
		End Sub
		
		Private Sub Form.HandleIsDestroyed(ByRef Sender As Control)
			If Sender.Child Then
				With QForm(Sender.Child)
					SetMenu .Handle, NULL
					DrawMenuBar .Handle
				End With
			End If
		End Sub
		
		'		Function GetAscKeyCode(HotKey As String) As Integer
		'	        Select Case HotKey
		'	        Case "Backspace", "Back": Return 08
		'	        Case "Tab": Return 09
		'	        Case "Enter", "Return": Return 13
		'	        Case "Escape", "Esc": Return 27
		'	        Case "Space": Return 32
		'	        Case "PageUp": Return 33
		'	        Case "PageDown": Return 34
		'	        Case "End": Return 35
		'	        Case "Home": Return 36
		'	        Case "Left": Return 37
		'	        Case "Up": Return 38
		'	        Case "Right": Return 39
		'	        Case "Down": Return 40
		'	        Case "Print": Return 42
		'	        Case "Insert", "Ins": Return 45
		'	        Case "Num0": Return 96
		'	        Case "Num1": Return 97
		'	        Case "Num2": Return 98
		'	        Case "Num3": Return 99
		'	        Case "Num4": Return 100
		'	        Case "Num5": Return 101
		'	        Case "Num6": Return 102
		'	        Case "Num7": Return 103
		'	        Case "Num8": Return 104
		'	        Case "Num9": Return 105
		'	        Case "F1": Return 112
		'	        Case "F2": Return 113
		'	        Case "F3": Return 114
		'	        Case "F4": Return 115
		'	        Case "F5": Return 116
		'	        Case "F6": Return 117
		'	        Case "F7": Return 118
		'	        Case "F8": Return 119
		'	        Case "F9": Return 120
		'	        Case "F10": Return 121
		'	        Case "F11": Return 122
		'	        Case "F12": Return 123
		'	        Case "Delete", "Del": : Return 127
		'	        Case Else: Return Asc(HotKey)
		'	        End Select
		'	    End Function
		
		Function Form.HookClientProc(hDlg As HWND, uMsg As UINT, WPARAM As WPARAM, LPARAM As LPARAM) As LRESULT
			Dim As Form Ptr frm = GetProp(hDlg, "MFFControl")
			If frm Then
				Select Case uMsg
				Case WM_WINDOWPOSCHANGING
					Dim As WINDOWPOS Ptr lpwp = Cast(WINDOWPOS Ptr, LPARAM)
					lpwp->x = ScaleX(frm->FClientX)
					lpwp->y = ScaleY(frm->FClientY)
					lpwp->cx = ScaleX(frm->FClientW)
					lpwp->cy = ScaleY(frm->FClientH)
				End Select
			End If
			Return CallWindowProc(GetProp(hDlg, "@@@@Proc"), hDlg, uMsg, WPARAM, LPARAM)
		End Function
	#endif
	
	#ifndef __USE_GTK__
		Private Sub Form.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QForm(Sender.Child)
					#ifdef __USE_WASM__
						If .OnShow Then SetLoadEvent(.FHandle)
					#elseif defined(__USE_WINAPI__)
						Dim As HMENU NoNeedSysMenu
						'xdpi = 0: ydpi = 0 'For muilti screen and have diffrent values.
						Dim hDC As HDC
						hDC = GetDC(.Handle)
						xdpi = GetDeviceCaps(hDC, LOGPIXELSX) / 96
						ydpi = GetDeviceCaps(hDC, LOGPIXELSY) / 96
						ReleaseDC(.Handle, hDC)
						If xdpi = 0 Then xdpi = 1
						If ydpi = 0 Then ydpi = 1
						.FDpiFormX = xdpi : .FDpiFormY = ydpi
						SetClassLong(.Handle,GCL_STYLE,.FClassStyle(.BorderStyle))
						If .FBorderStyle = 2 Then
							SetClassLongPtr(.Handle,GCLP_HICON,NULL)
							SendMessage(.Handle, WM_SETICON, 1, NULL)
							NoNeedSysMenu = GetSystemMenu(.Handle, False)
							DeleteMenu(NoNeedSysMenu, SC_TASKLIST, MF_BYCOMMAND)
							DeleteMenu(NoNeedSysMenu, 7, MF_BYPOSITION)
							DeleteMenu(NoNeedSysMenu, 5, MF_BYPOSITION)
							DeleteMenu(NoNeedSysMenu, SC_MAXIMIZE, MF_BYCOMMAND)
							DeleteMenu(NoNeedSysMenu, SC_MINIMIZE, MF_BYCOMMAND)
							DeleteMenu(NoNeedSysMenu, SC_SIZE, MF_BYCOMMAND)
							DeleteMenu(NoNeedSysMenu, SC_RESTORE, MF_BYCOMMAND)
						Else
							SendMessage(.Handle, WM_SETICON, 1, CInt(.Icon.Handle))
							'GetSystemMenu(.Handle, True)
							'EnableMenuItem(NoNeedSysMenu, SC_MINIMIZE, MF_BYCOMMAND Or MF_GRAYED)
							'EnableMenuItem(NoNeedSysMenu, SC_MAXIMIZE, MF_BYCOMMAND Or MF_GRAYED)
						End If
						If .Opacity <> 255 OrElse .Transparent Then SetLayeredWindowAttributes(.Handle, IIf(.TransparentColor = -1, .BackColor, .TransparentColor), .Opacity, IIf(.Transparent, LWA_COLORKEY, 0) Or LWA_ALPHA)
						.ChangeTabIndex -2
						SendMessage(.Handle, WM_UPDATEUISTATE, MAKEWPARAM(UIS_CLEAR, UISF_HIDEFOCUS), NULL)
						If .Menu Then .Menu->ParentWindow = @Sender
						Select Case .FFormStyle
						Case fsMDIForm
							Dim FClientStruct As CLIENTCREATESTRUCT
							FClientStruct.hWindowMenu = 0 'GetSubMenu(GetMenu(.FHandle), WINDOWMENU)
							FClientStruct.idFirstChild = &H00FF
							.FClient = CreateWindowEx(0, "MDICLIENT", "", WS_CHILD Or WS_VISIBLE Or WS_VSCROLL Or WS_HSCROLL Or WS_CLIPSIBLINGS Or WS_CLIPCHILDREN, 0, 0, 100, 100, .FHandle, Cast(HMENU, &hcac), Instance, @FClientStruct)
							If GetWindowLongPtr(.FClient, GWLP_WNDPROC) <> @HookClientProc Then
								SetProp(.FClient, "MFFControl", Sender.Child)
								SetProp(.FClient, "@@@@Proc", Cast(..WNDPROC, SetWindowLongPtr(.FClient, GWLP_WNDPROC, CInt(@HookClientProc))))
							End If
							ShowWindow(.FClient, SW_SHOW)
						Case fsMDIChild
							If .FParent Then
								If *(.FParent) Is Form Then
									If Cast(Form Ptr, .FParent)->FFormStyle = fsMDIForm Then
										SetParent(.FHandle, Cast(Form Ptr, .FParent)->FClient)
									End If
								End If
							End If
						End Select
						'					.GetMenuItems
						'					Dim As String mnuCaption, HotKey
						'					Dim As Integer Pos1, CountOfHotKeys = 0
						'					Dim As MenuItem Ptr mi
						'					ReDim accl(1) As ACCEL
						'					For i As Integer = 0 To .FMenuItems.Count - 1
						'						mi = .FMenuItems.Items[i]
						'						mnuCaption = mi->Caption
						'						Pos1 = InStr(mnuCaption, !"\t")
						'						If Pos1 > 0 Then
						'							CountOfHotKeys = CountOfHotKeys + 1
						'							HotKey = Mid(mnuCaption, Pos1 + 1)
						'							ReDim Preserve accl(CountOfHotKeys - 1) As ACCEL
						'							If InStr(HotKey, "Ctrl") > 0 Then accl(CountOfHotKeys - 1).fVirt = accl(CountOfHotKeys - 1).fVirt Or FCONTROL
						'							If InStr(HotKey, "Shift") > 0 Then accl(CountOfHotKeys - 1).fVirt = accl(CountOfHotKeys - 1).fVirt Or FSHIFT
						'							If InStr(HotKey, "Alt") > 0 Then accl(CountOfHotKeys - 1).fVirt = accl(CountOfHotKeys - 1).fVirt Or FALT
						'							accl(CountOfHotKeys - 1).fVirt = accl(CountOfHotKeys - 1).fVirt Or FVIRTKEY
						'							Pos1 = InStrRev(HotKey, "+")
						'							If Pos1 > 0 Then HotKey = Mid(HotKey, Pos1 + 1)
						'							accl(CountOfHotKeys - 1).key = GetAscKeyCode(HotKey)
						'							accl(CountOfHotKeys - 1).cmd = mi->Command
						'						End If
						'					Next i
						'					If .Accelerator <> 0 Then DestroyAcceleratorTable(.Accelerator)
						'					.Accelerator = CreateAcceleratorTable(Cast(LPACCEL, @accl(0)), CountOfHotKeys)
						'					Erase accl
					#endif
				End With
			End If
		End Sub
	#endif
	
	#if defined(__USE_GTK__)
		Private Function Form.deactivate_cb(ByVal user_data As gpointer) As gboolean
			pApp->FDeactivated = False
			If pApp->FActivated Then
				pApp->FActivated = False
			Else
				Dim As Form Ptr frm = user_data
				If frm->OnDeActivateApp Then frm->OnDeActivateApp(*frm->Designer, *frm)
			End If
			Return False
		End Function
	#endif
	
	#ifdef __USE_WINAPI__
		Private Sub Form.SetDark(Value As Boolean)
			Base.SetDark Value
			RefreshTitleBarThemeColor(FHandle)
			If FClient Then
				SetWindowTheme(FClient, "DarkMode_Explorer", nullptr)
				AllowDarkModeForWindow(FClient, g_darkModeEnabled)
				SendMessageW(FClient, WM_THEMECHANGED, 0, 0)
			End If
			RedrawWindow FHandle, 0, 0, RDW_INVALIDATE Or RDW_ALLCHILDREN
		End Sub
	#endif
	
	Private Sub Form.ProcessMessage(ByRef msg As Message)
		Dim As Integer Action = 1
		#ifdef __USE_GTK__
			Select Case msg.Event->type
			Case GDK_DELETE
				If OnClose Then OnClose(*Designer, This, Action)
				Select Case Action
				Case 0
					msg.Result = -1
				Case 1
					If MainForm Then
						#ifdef __USE_GTK__
							gtk_main_quit()
							'End 0
						#else
							PostQuitMessage 0
						#endif
					Else
						'#ifdef __USE_GTK3__
						
						'#else
						If GTK_IS_WINDOW(widget) Then
							If gtk_window_get_modal (GTK_WINDOW(widget)) Then
								gtk_main_quit()
							End If
						End If
						gtk_widget_hide(widget)
						FCreated = False
						msg.Result = -1
						'#endif
					End If
				Case 2
					msg.Result = -1
				End Select
			Case GDK_FOCUS_CHANGE
				If Cast(GdkEventFocus Ptr, msg.Event)->in Then
					If OnActivateApp OrElse OnDeActivateApp Then
						If pApp Then
							pApp->FActivated = True
							If OnActivateApp AndAlso CInt(pApp->FDeactivated = False) Then OnActivateApp(*Designer, This)
						End If
					End If
					pApp->ActiveForm = @This
					If OnActivate Then OnActivate(*Designer, This)
				Else
					If OnDeActivate Then OnDeActivate(*Designer, This)
					If OnActivateApp OrElse OnDeActivateApp Then
						If pApp Then
							pApp->FDeactivated = True
							g_timeout_add(500, Cast(GSourceFunc, @deactivate_cb), @This)
						End If
					End If
				End If
			Case GDK_WINDOW_STATE
				
			Case Else
				
			End Select
		#elseif defined(__USE_WINAPI__)
			Static As Boolean IsMenuItem
			Select Case msg.Msg
			Case WM_GETMINMAXINFO
				'David Change
				'不要为MDI子窗体处理此消息，因为它会干扰子窗体的最大化 - Do not process this message for MDI child forms, as it will interfere with the maximization of child forms
				If (GetWindowLongPtr(Handle, GWL_EXSTYLE) And WS_EX_MDICHILD) = WS_EX_MDICHILD Then
					'DefWindowProcW(Handle, Msg.Msg, Msg.wParam, Msg.lParam)
					Dim FLY_pMinMaxInfo As MINMAXINFO Ptr = Cast(MINMAXINFO Ptr, msg.lParam)
					msg.Result = 0
				End If
			Case WM_THEMECHANGED
				If (g_darkModeSupported) Then
					AllowDarkModeForWindow(msg.hWnd, g_darkModeEnabled)
					RefreshTitleBarThemeColor(msg.hWnd)
					UpdateWindow(msg.hWnd)
				End If
			Case WM_DPICHANGED
				'Print "DPICHANGED Forms xdpi=" & xdpi & "ydpi=" & ydpi
				Dim hDC As HDC
				hDC = GetDC(FHandle)
				xdpi = GetDeviceCaps(hDC, LOGPIXELSX) / 96
				ydpi = GetDeviceCaps(hDC, LOGPIXELSY) / 96
				ReleaseDC(FHandle, hDC)
				If xdpi = 0 Then xdpi = FDpiFormX
				If ydpi = 0 Then ydpi = FDpiFormY
				If Not IsIconic(FHandle) AndAlso (xdpi <> FDpiFormX OrElse ydpi <> FDpiFormY) Then
					FDpiFormX = xdpi
					FDpiFormY = ydpi
					RequestAlign
				End If
			Case WM_UAHDRAWMENU
				If g_darkModeSupported AndAlso g_darkModeEnabled Then
					Dim As UAHMENU Ptr pUDM = Cast(UAHMENU Ptr, msg.lParam)
					Dim As ..Rect rc = Type( 0 )
					
					' Get the menubar rect
					Dim As MENUBARINFO mbi = Type(  SizeOf(mbi) )
					GetMenuBarInfo(msg.hWnd, OBJID_MENU, 0, @mbi)
					
					Dim As ..Rect rcWindow
					GetWindowRect(msg.hWnd, @rcWindow)
					
					' the rcBar is offset by the window rect
					rc = mbi.rcBar
					OffsetRect(@rc, -rcWindow.Left, -rcWindow.Top)
					
					FillRect(pUDM->hdc, @rc, hbrBkgnd)
					
					msg.Result = True
					Return
				End If
			Case WM_UAHDRAWMENUITEM
				If g_darkModeSupported AndAlso g_darkModeEnabled Then
					Dim As UAHDRAWMENUITEM Ptr pUDMI = Cast(UAHDRAWMENUITEM Ptr, msg.lParam)
					
					Dim As HBRUSH Ptr pbrBackground = @hbrBkgnd
					
					' get the menu item string
					Dim As WString * 256 menuString
					Dim As MENUITEMINFO mii = Type( SizeOf(mii), MIIM_STRING Or MIIM_BITMAP)
					mii.dwTypeData = @menuString
					mii.cch = 256
					
					GetMenuItemInfo(pUDMI->um.hmenu, pUDMI->umi.iPosition, True, @mii)
					
					If mii.hbmpItem = HBMMENU_MBAR_MINIMIZE OrElse mii.hbmpItem = HBMMENU_MBAR_RESTORE OrElse mii.hbmpItem = HBMMENU_MBAR_CLOSE Then
						If mii.hbmpItem = HBMMENU_MBAR_MINIMIZE Then
							Dim As MENUITEMINFO mii0 = Type( SizeOf(mii), MIIM_STRING Or MIIM_BITMAP Or MIIM_CHECKMARKS Or MIIM_DATA)
							mii0.dwTypeData = @menuString
							mii0.cch = 256
							GetMenuItemInfo(pUDMI->um.hmenu, 0, True, @mii0)
							Dim As HWND h = Cast(HWND, SendMessage(FClient, WM_MDIGETACTIVE, 0, 0))
							If h Then
								Dim As HICON hIco = Cast(HICON, SendMessage(h, WM_GETICON, Cast(WPARAM, ICON_SMALL), 0))
								Dim As Integer iTop = ScaleY(31) + (pUDMI->dis.rcItem.Bottom - pUDMI->dis.rcItem.Top - 1 - ScaleY(16)) / 2
								If hIco = 0 Then hIco = LoadIcon(0, IDI_APPLICATION)
								DrawIconEx(pUDMI->um.hdc, 15, iTop, hIco, ScaleX(16), ScaleY(16), 0, 0, DI_NORMAL)
							End If
						End If
						
						Dim As HPEN Pen = CreatePen(PS_SOLID, 0, IIf(pUDMI->dis.itemState And ODS_SELECTED, BGR(153, 153, 153), BGR(98, 98, 98)))
						Dim As HPEN PrevPen = SelectObject(pUDMI->um.hdc, Pen)
						Dim As HBRUSH PrevBrush = SelectObject(pUDMI->um.hdc, hbrBkgnd)
						
						FillRect(pUDMI->um.hdc, @pUDMI->dis.rcItem, *pbrBackground)
						
						If pUDMI->dis.itemState And ODS_SELECTED Then SelectObject(pUDMI->um.hdc, hbrHlBkgnd)
						Rectangle pUDMI->um.hdc, pUDMI->dis.rcItem.Left, pUDMI->dis.rcItem.Top + 1, pUDMI->dis.rcItem.Right - 1, pUDMI->dis.rcItem.Bottom
						DeleteObject(Pen)
						
						Dim As Integer iLeft = pUDMI->dis.rcItem.Left + (pUDMI->dis.rcItem.Right - 1 - pUDMI->dis.rcItem.Left - 8) / 2
						Dim As Integer iTop = pUDMI->dis.rcItem.Top + (pUDMI->dis.rcItem.Bottom - 1 - pUDMI->dis.rcItem.Top - 8) / 2 + 1
						Select Case mii.hbmpItem
						Case HBMMENU_MBAR_MINIMIZE
							Pen = CreatePen(PS_SOLID, 0, BGR(122, 136, 150))
							SelectObject(pUDMI->um.hdc, Pen)
							Rectangle pUDMI->um.hdc, iLeft, iTop + 6, iLeft + 6, iTop + 6 + 2
							DeleteObject(Pen)
						Case HBMMENU_MBAR_RESTORE
							Pen = CreatePen(PS_SOLID, 0, BGR(122, 136, 150))
							SelectObject(pUDMI->um.hdc, Pen)
							Rectangle pUDMI->um.hdc, iLeft, iTop + 4, iLeft + 6, iTop + 4 + 4
							MoveToEx pUDMI->um.hdc, iLeft, iTop + 3, 0
							LineTo pUDMI->um.hdc, iLeft + 6, iTop + 3
							SetPixel pUDMI->um.hdc, iLeft + 2, iTop + 2, BGR(122, 136, 150)
							MoveToEx pUDMI->um.hdc, iLeft + 7, iTop + 2, 0
							LineTo pUDMI->um.hdc, iLeft + 7, iTop + 5
							Rectangle pUDMI->um.hdc, iLeft + 2, iTop, iLeft + 8, iTop + 2
							DeleteObject(Pen)
						Case HBMMENU_MBAR_CLOSE
							Pen = CreatePen(PS_SOLID, 2, BGR(122, 136, 150))
							SelectObject(pUDMI->um.hdc, Pen)
							MoveToEx pUDMI->um.hdc, iLeft + 1, iTop + 1, 0
							LineTo pUDMI->um.hdc, iLeft + 7, iTop + 7
							MoveToEx pUDMI->um.hdc, iLeft + 7, iTop + 1, 0
							LineTo pUDMI->um.hdc, iLeft + 1, iTop + 7
							DeleteObject(Pen)
						End Select
						
						SelectObject(pUDMI->um.hdc, PrevPen)
						SelectObject(pUDMI->um.hdc, PrevBrush)
						
					Else
						' get the item state for drawing
						
						Dim As DWORD dwFlags = DT_CENTER Or DT_SINGLELINE Or DT_VCENTER
						
						Enum POPUPITEMSTATES
							MPI_NORMAL = 1,
							MPI_HOT = 2,
							MPI_DISABLED = 3,
							MPI_DISABLEDHOT = 4,
						End Enum
						
						Dim As Integer iTextStateID = 0
						Dim As Integer iBackgroundStateID = 0
						If ((pUDMI->dis.itemState And ODS_INACTIVE) Or (pUDMI->dis.itemState And ODS_DEFAULT)) Then
							' normal display
							iTextStateID = MPI_NORMAL
							iBackgroundStateID = MPI_NORMAL
						End If
						If (pUDMI->dis.itemState And ODS_HOTLIGHT) Then
							' hot tracking
							iTextStateID = MPI_HOT
							iBackgroundStateID = MPI_HOT
							
							pbrBackground = @hbrHlBkgnd '@g_brItemBackgroundHot
						End If
						If (pUDMI->dis.itemState And ODS_SELECTED) Then
							' clicked -- MENU_POPUPITEM has no state for this, though MENU_BARITEM does
							iTextStateID = MPI_HOT
							iBackgroundStateID = MPI_HOT
							
							pbrBackground = @hbrHlBkgnd '@g_brItemBackgroundSelected
						End If
						If ((pUDMI->dis.itemState And ODS_GRAYED) Or (pUDMI->dis.itemState And ODS_DISABLED)) Then
							' disabled / grey text
							iTextStateID = MPI_DISABLED
							iBackgroundStateID = MPI_DISABLED
							pbrBackground = @hbrBkgnd
						End If
						If (pUDMI->dis.itemState And ODS_NOACCEL) Then
							dwFlags Or = DT_HIDEPREFIX
						End If
						
						If (g_menuTheme = 0) Then
							g_menuTheme = OpenThemeData(msg.hWnd, "Menu")
						End If
						
						'Dim As DTTOPTS opts = Type( SizeOf(opts), DTT_TEXTCOLOR, IIf(iTextStateID <> MPI_DISABLED, RGB(&h00, &h00, &h20), RGB(&h40, &h40, &h40) )
						
						FillRect(pUDMI->um.hdc, @pUDMI->dis.rcItem, *pbrBackground)
						SetBkMode pUDMI->um.hdc, Transparent
						If iTextStateID = MPI_DISABLED Then
							SetTextColor pUDMI->um.hdc, darkHlBkColor
						Else
							SetTextColor pUDMI->um.hdc, darkTextColor
						End If
						SetBkColor pUDMI->um.hdc, darkBkColor
						DrawText pUDMI->um.hdc, menuString, mii.cch, @pUDMI->dis.rcItem, dwFlags
						SetBkMode pUDMI->um.hdc, OPAQUE
						'DrawThemeTextEx(g_menuTheme, pUDMI->um.hdc, MENU_BARITEM, MBI_NORMAL, menuString, mii.cch, dwFlags, @pUDMI->dis.rcItem, @opts)
					End If
					
					msg.Result = True
					Return
				End If
			Case WM_NCPAINT, WM_NCACTIVATE
				If g_darkModeSupported AndAlso g_darkModeEnabled Then
					DefWindowProc(msg.hWnd, msg.Msg, msg.wParam, msg.lParam)
					Dim As MENUBARINFO mbi = Type( SizeOf(mbi) )
					If (GetMenuBarInfo(msg.hWnd, OBJID_MENU, 0, @mbi) = 0) Then
						msg.Result = True
						Return
					End If
					
					Dim As Rect rcClient = Type( 0 )
					GetClientRect(msg.hWnd, @rcClient)
					MapWindowPoints(msg.hWnd, nullptr, Cast(Point Ptr, @rcClient), 2)
					
					Dim As Rect rcWindow = Type( 0 )
					GetWindowRect(msg.hWnd, @rcWindow)
					
					OffsetRect(@rcClient, -rcWindow.Left, -rcWindow.Top)
					
					' the rcBar is offset by the window rect
					Dim As Rect rcAnnoyingLine = rcClient
					rcAnnoyingLine.Bottom = rcAnnoyingLine.Top
					rcAnnoyingLine.Top -= 1
					
					Dim As HDC Dc = GetWindowDC(msg.hWnd)
					FillRect(Dc, @rcAnnoyingLine, hbrBkgnd)
					ReleaseDC(msg.hWnd, Dc)
					msg.Result = True
					Return
				End If
			Case WM_PAINT ', WM_ERASEBKGND, WM_CREATE
				If g_darkModeSupported AndAlso g_darkModeEnabled Then
					If Not FDarkMode Then
						SetDark True
						'FDarkMode = True
						'RefreshTitleBarThemeColor(FHandle)
						'If FDefaultBackColor = FBackColor Then
						'	Brush.Handle = hbrBkgnd
						'End If
						'SendMessageW(FHandle, WM_THEMECHANGED, 0, 0)
						'RedrawWindow FHandle, 0, 0, RDW_INVALIDATE Or RDW_ALLCHILDREN
					End If
				Else
					If FDarkMode Then
						SetDark False
						'FDarkMode = False
						'RefreshTitleBarThemeColor(FHandle)
						'If FBackColor = -1 Then
						'	Brush.Handle = 0
						'Else
						'	Brush.Color = FBackColor
						'End If
						'SendMessageW(FHandle, WM_THEMECHANGED, 0, 0)
						'RedrawWindow FHandle, 0, 0, RDW_INVALIDATE Or RDW_ALLCHILDREN
					End If
				End If
				Dim As HDC Dc, memDC
				Dim As PAINTSTRUCT Ps
				Dim As ..Rect R
				GetClientRect Handle, @R
				Dim As HBITMAP Bmp
				Dc = BeginPaint(Handle, @Ps)
				Canvas.HandleSetted = True
				If DoubleBuffered Then
					memDC = CreateCompatibleDC(Dc)
					Bmp   = CreateCompatibleBitmap(Dc, R.Right - R.left, R.Bottom - R.Top) 
					SelectObject(memDC, Bmp)
					FillRect memDC, @R, Brush.Handle
					Canvas.Handle = memDC
				Else
					FillRect Dc, @R, Brush.Handle
					Canvas.Handle = Dc
				End If
				If Graphic.Visible AndAlso Graphic.Bitmap.Handle > 0 Then
					With This
						Select Case Graphic.StretchImage
						Case StretchMode.smNone
							Canvas.DrawAlpha Graphic.StartX, Graphic.StartY, , , Graphic.Bitmap
						Case StretchMode.smStretch
							Canvas.DrawAlpha Graphic.StartX, Graphic.StartY, ScaleX(.Width) * Graphic.ScaleFactor, ScaleY(.Height) * Graphic.ScaleFactor, Graphic.Bitmap
						Case Else 'StretchMode.smStretchProportional
							Dim As Double imgWidth = Graphic.Bitmap.Width
							Dim As Double imgHeight = Graphic.Bitmap.Height
							Dim As Double PicBoxWidth = ScaleX(This.Width) * Graphic.ScaleFactor
							Dim As Double PicBoxHeight = ScaleY(This.Height) * Graphic.ScaleFactor
							Dim As Double img_ratio = imgWidth / imgHeight
							Dim As Double PicBox_ratio =  This.Width / This.Height
							If (PicBox_ratio >= img_ratio) Then
								imgHeight = PicBoxHeight
								imgWidth = imgHeight *img_ratio
							Else
								imgWidth = PicBoxWidth
								imgHeight = imgWidth / img_ratio
							End If
							If Graphic.CenterImage Then
								Canvas.DrawAlpha Max((PicBoxWidth - imgWidth * Graphic.ScaleFactor) / 2, Graphic.StartX), Max((PicBoxHeight - imgHeight * Graphic.ScaleFactor) / 2, Graphic.StartY), imgWidth * Graphic.ScaleFactor, imgHeight * Graphic.ScaleFactor, Graphic.Bitmap
							Else
								Canvas.DrawAlpha Graphic.StartX, Graphic.StartY, imgWidth, imgHeight, Graphic.Bitmap
							End If
						End Select
					End With
				End If
				If OnPaint Then OnPaint(*Designer, This, Canvas)
				If DoubleBuffered Then
					BitBlt(Dc, 0, 0, R.Right - R.left, R.Bottom - R.top, memDC, 0, 0, SRCCOPY)
					DeleteObject(Bmp)
					DeleteDC(memDC)
				End If
				Canvas.HandleSetted = False
				EndPaint Handle, @Ps
			Case WM_SIZE
				xdpi = FDpiFormX
				ydpi = FDpiFormY
				If OnResize Then OnResize(*Designer, This, This.Width, This.Height)
				If Not IsIconic(FHandle) Then
					RequestAlign
					If Graphic.Visible AndAlso Graphic.Bitmap.Handle > 0 Then Repaint
				End If
			Case WM_CLOSE
				If OnClose Then
					OnClose(*Designer, This, Action)
				End If
				Select Case Action
				Case 0
					msg.Result = -1
				Case 1
					If MainForm Then
						'PostQuitMessage 0
						End 0
					Else
						If InShowModal Then
							For i As Integer = 0 To pApp->FormCount - 1
								pApp->Forms[i]->Enabled = True
							Next i
						End If
						#ifdef __HIDE_NO_MAIN_FORM_ON_CLOSE__
							ShowWindow Handle, SW_HIDE
							msg.Result = -1
						#endif
					End If
				Case 2
					ShowWindow Handle, SW_MINIMIZE
					msg.Result = -1
				Case 3
					ShowWindow Handle, SW_HIDE
					msg.Result = -1
				End Select
			Case WM_COMMAND
				GetMenuItems
				Dim As MenuItem Ptr mi
				For i As Integer = 0 To FMenuItems.Count -1
					mi = FMenuItems.Items[i]
					With *mi
						If .Command = msg.wParamLo Then
							If .OnClick Then .OnClick(*mi->Designer, *mi)
							msg.Result = -2
							msg.Msg = 0
							Exit For
						End If
					End With
				Next i
				IsMenuItem = False
			Case WM_MENUSELECT
				IsMenuItem = True
			Case WM_INITMENU
			Case WM_INITMENUPOPUP
				'			Case WM_TIMER
				'				If OnTimer Then OnTimer(This)
			Case WM_MDIACTIVATE
				If msg.lParam = msg.hWnd Then
					pApp->ActiveMDIChild = @This
					If OnActivate Then OnActivate(*Designer, This)
				End If
				If msg.wParam = msg.hWnd Then
					If OnDeActivate Then OnDeActivate(*Designer, This)
				End If
			Case WM_ACTIVATE
				xdpi = FDpiFormX
				ydpi = FDpiFormY
				Select Case msg.wParamLo
				Case WA_ACTIVE, WA_CLICKACTIVE
					pApp->ActiveForm = @This
					If OnActivate Then OnActivate(*Designer, This)
				Case WA_INACTIVE
					If OnDeActivate Then OnDeActivate(*Designer, This)
				End Select
			Case WM_ACTIVATEAPP
				Select Case msg.wParam
				Case 1
					If OnActivateApp Then OnActivateApp(*Designer, This)
				Case 0
					If OnDeActivateApp Then OnDeActivateApp(*Designer, This)
				End Select
			Case WM_DESTROY
				If Accelerator Then DestroyAcceleratorTable(Accelerator)
			Case WM_DRAWITEM
				Dim As DRAWITEMSTRUCT Ptr diStruct
				diStruct = Cast(DRAWITEMSTRUCT Ptr, msg.lParam)
				Select Case diStruct->CtlType
				Case ODT_MENU
					'If This.Menu AndAlso This.Menu->ImagesList AndAlso This.Menu->ImagesList->Handle AndAlso diStruct->itemData <> 0 Then
					'    ImageList_Draw(This.Menu->ImagesList->Handle, Cast(MenuItem Ptr, diStruct->itemData)->ImageIndex, diStruct->hDC, 2, 2, ILD_NORMAL)
					'End If
				End Select
			Case CM_HELP
				Dim As Point P
				Dim As HWND HControl
				Dim As Control Ptr Ctrl
				Dim As Integer ContextID,Id,i
				Dim As HELPINFO Ptr HIF
				HIF = Cast(HELPINFO Ptr, msg.lParam)
				If HIF->iContextType = HELPINFO_WINDOW Then
					HControl = HIF->hItemHandle
					Ctrl = Cast(Control Ptr, GetWindowLongPtr(HControl, GWLP_USERDATA))
					If Ctrl Then
						If Ctrl->HelpContext <> 0 Then
							ContextID = Ctrl->HelpContext
						Else
							If Ctrl->Parent Then
								Ctrl= Ctrl->Parent
								ContextID = Ctrl->HelpContext
							Else
								Exit Select
							End If
						End If
					End If
					Ctrl->ClientToScreen(P)
				Else  ' Message.HelpInfo.iContextType = HELPINFO_MENUITEM
					Id = 0
					If This.Menu Then
						For i = 0 To This.Menu->Count -1
							If This.Menu->Item(i)->Command = HIF->iCtrlId Then
								Id = i
								Exit For
							End If
						Next i
					End If
					'                 If Id Then ContextID = MainMenu.Item(Id)->HelpContext
					'                 If ContextID = 0 Then
					'                     For i = 0 to MainMenu.Count -1
					'                          If MainMenu.Items[i]->CommandID = HIF->iCtrlID Then
					'                              Id = i
					'                              Exit For
					'                          End If
					'                     Next i
					'                     If Id then ContextID = PopupMenu.Items[Id]->HelpContext
					'                 End If
					This.ClientToScreen(P)
				End If
				If (GetWindowLong(Handle,GWL_EXSTYLE) And WS_EX_CONTEXTHELP) = WS_EX_CONTEXTHELP Then
					pApp->HelpCommand(HELP_SETPOPUP_POS, CInt(@P))
					pApp->HelpCommand(HELP_CONTEXTPOPUP, ContextID)
				Else
					pApp->HelpContext(ContextID)
				End If
			End Select
		#endif
		Base.ProcessMessage(msg)
		#ifdef __USE_WINAPI__
			If msg.Result = 0 Then
				Select Case FFormStyle
				Case fsMDIChild
					msg.Result = -3
				Case fsMDIForm
					msg.hWnd = FClient
					msg.Result = -4
				End Select
			End If
		#endif
	End Sub
	
	'David Change
	Private Sub Form.BringToFront
		#ifdef __USE_WINAPI__
			'If Handle Then BringWindowToTop Handle
			'Const HWND_TOPMOST = -1
			'Const HWND_NOTOPMOST = -2
			If Handle Then SetWindowPos(Handle, HWND_TOP,0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE)' This.Left, This.Top, This.Width, This.Height, 0)
		#endif
	End Sub
	
	Private Sub Form.SendToBack
		#ifdef __USE_WINAPI__
			If Handle Then SetWindowPos Handle, HWND_BOTTOM, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE
		#endif
	End Sub
	
	Private Property Form.Visible() As Boolean
		#ifdef __USE_WINAPI__
			If FHandle Then
				FVisible = IsWindowVisible(FHandle)
			End If
		#endif
		Return FVisible
	End Property
	
	Private Property Form.Visible(Value As Boolean)
		FVisible = Value
		If Value Then
			Show
		Else
			Hide
		End If
	End Property
	
	Private Sub Form.ShowItems(Ctrl As Control Ptr)
		#ifdef __USE_GTK__
			If CInt(Ctrl->FVisible) OrElse CInt(GTK_IS_NOTEBOOK(gtk_widget_get_parent(Ctrl->widget))) Then
				If Ctrl->box Then gtk_widget_show(Ctrl->box)
				If Ctrl->scrolledwidget Then gtk_widget_show(Ctrl->scrolledwidget)
				If Ctrl->eventboxwidget Then gtk_widget_show(Ctrl->eventboxwidget)
				If Ctrl->layoutwidget Then gtk_widget_show(Ctrl->layoutwidget)
				#ifdef __USE_GTK4__
					If Ctrl->widget Then gtk_widget_show(Ctrl->widget)
				#else
					If Ctrl->widget Then If Not *Ctrl Is ContainerControl Then gtk_widget_show_all(Ctrl->widget) Else gtk_widget_show(Ctrl->widget)
				#endif
			End If
			For i As Integer = 0 To Ctrl->ControlCount - 1
				ShowItems Ctrl->Controls[i]
			Next
		#endif
	End Sub
	
	Private Sub Form.HideItems(Ctrl As Control Ptr)
		#ifdef __USE_GTK__
			If Not (CInt(Ctrl->FVisible) OrElse CInt(GTK_IS_NOTEBOOK(gtk_widget_get_parent(Ctrl->widget)))) Then
				If Ctrl->box Then gtk_widget_hide(Ctrl->box)
				If Ctrl->scrolledwidget Then gtk_widget_hide(Ctrl->scrolledwidget)
				If Ctrl->eventboxwidget Then gtk_widget_hide(Ctrl->eventboxwidget)
				If Ctrl->layoutwidget Then gtk_widget_hide(Ctrl->layoutwidget)
				If Ctrl->widget Then gtk_widget_hide(Ctrl->widget)
			End If
			For i As Integer = 0 To Ctrl->ControlCount - 1
				HideItems Ctrl->Controls[i]
			Next
		#endif
	End Sub
	
	Private Sub Form.Show
		#ifdef __USE_GTK__
			RequestAlign
			If widget Then
				If Not FCreated Then
					If OnCreate Then OnCreate(*Designer, This)
					FCreated = True
				End If
				If Not FFormCreated Then
					FFormCreated = True
					If FStartPosition <> 0 Then StartPosition = FStartPosition
					If Icon.ResName <> "" Then
						If GTK_IS_WINDOW(widget) Then
							Dim As GList Ptr list1 = NULL
							Dim As GError Ptr gerr
							Dim As GdkPixbuf Ptr gtkicon
							If Icon.ResName <> "" Then
								gtkicon = gdk_pixbuf_new_from_file_at_size(ToUtf8(Icon.ResName), 16, 16, @gerr)
								If gtkicon <> 0 Then list1 = g_list_append(list1, gtkicon)
								gtkicon = gdk_pixbuf_new_from_file_at_size(ToUtf8(Icon.ResName), 48, 48, @gerr)
								If gtkicon <> 0 Then list1 = g_list_append(list1, gtkicon)
								gtk_window_set_icon_list(GTK_WINDOW(widget), list1)
							End If
						End If
					End If
					If GTK_IS_WINDOW(widget) Then
						'Select Case FBorderStyle
						'Case FormBorderStyle.None, FormBorderStyle.FixedToolWindow, FormBorderStyle.Fixed3D, FormBorderStyle.FixedSingle, FormBorderStyle.FixedDialog
						'	Dim As GdkGeometry hints
						'	hints.base_width = FWidth
						'	hints.base_height = FHeight
						'	hints.min_width = FWidth
						'	hints.min_height = FHeight
						'	hints.max_width = FWidth
						'	hints.max_height = FHeight
						'	hints.width_inc = 1
						'	hints.height_inc = 1
						'	#ifndef __USE_GTK4__
						'	gtk_window_set_geometry_hints(GTK_WINDOW(widget), NULL, @hints, GDK_HINT_RESIZE_INC Or GDK_HINT_MIN_SIZE Or GDK_HINT_MAX_SIZE Or GDK_HINT_BASE_SIZE)
						'   #endif
						'Case FormBorderStyle.SizableToolWindow, FormBorderStyle.Sizable
						'
						'End Select
						If Constraints.Width <> 0 OrElse Constraints.Height <> 0 Then
							Dim As GdkGeometry hints
							#ifdef __USE_GTK4__
								Dim As GdkRectangle workarea
								gdk_monitor_get_workarea(gdk_display_get_primary_monitor(gdk_display_get_default()), @workarea)
								gtk_window_move(GTK_WINDOW(widget), (workarea.width - This.FWidth) \ 2, (workarea.height - This.FHeight) \ 2)
							#endif
							If Constraints.Width <> 0 Then
								hints.base_width = Constraints.Width
								hints.min_width = Constraints.Width
								hints.max_width = Constraints.Width
								hints.width_inc = 1
							Else
								hints.base_width = FWidth
								hints.min_width = 0
								#ifdef __USE_GTK4__
									hints.max_width = workarea.width
								#else
									hints.max_width = gdk_screen_get_width(gtk_widget_get_screen(widget))
								#endif
								hints.width_inc = 1
							End If
							If Constraints.Height <> 0 Then
								hints.base_height = Constraints.Height
								hints.min_height = Constraints.Height
								hints.max_height = Constraints.Height
								hints.height_inc = 1
							Else
								hints.base_height = FHeight
								hints.min_height = 0
								#ifdef __USE_GTK4__
									hints.max_width = workarea.height
								#else
									hints.max_height = gdk_screen_get_height(gtk_widget_get_screen(widget))
								#endif
								hints.height_inc = 1
							End If
							#ifndef __USE_GTK4__
								gtk_window_set_geometry_hints(GTK_WINDOW(widget), NULL, @hints, GDK_HINT_RESIZE_INC Or GDK_HINT_MIN_SIZE Or GDK_HINT_MAX_SIZE Or GDK_HINT_BASE_SIZE)
							#endif
						End If
						Select Case FBorderStyle
						Case FormBorderStyle.None
							'#ifndef __USE_GTK3__
							'	gtk_window_set_resizable(GTK_WINDOW(widget), False)
							'#endif
						Case FormBorderStyle.SizableToolWindow
							gtk_window_set_resizable(GTK_WINDOW(widget), True)
						Case FormBorderStyle.FixedToolWindow
							'#ifndef __USE_GTK3__
							'	gtk_window_set_resizable(GTK_WINDOW(widget), False)
							'#endif
						Case FormBorderStyle.Sizable
							gtk_window_set_resizable(GTK_WINDOW(widget), True)
						Case FormBorderStyle.Fixed3D
							'#ifndef __USE_GTK3__
							'	gtk_window_set_resizable(GTK_WINDOW(widget), False)
							'#endif
						Case FormBorderStyle.FixedSingle
							'#ifndef __USE_GTK3__
							'	gtk_window_set_resizable(GTK_WINDOW(widget), False)
							'#endif
						Case FormBorderStyle.FixedDialog
							'#ifndef __USE_GTK3__
							'	gtk_window_set_resizable(GTK_WINDOW(widget), False)
							'#endif
						End Select
					End If
				Else
					StartPosition = Manual
				End If
				'If Menu Then gtk_widget_show_all(Menu->widget)
				'				gtk_widget_show(ImageWidget)
				'				If box Then gtk_widget_show(box)
				'				If layoutwidget Then gtk_widget_show(layoutwidget)
				'				gtk_widget_show(widget)
				#ifdef __USE_GTK4__
					gtk_widget_show(widget)
				#else
					gtk_widget_show_all(widget)
					'ShowItems @This
					FVisible = True
					HideItems @This
				#endif
				'Requests @This
			End If
		#elseif defined(__USE_WINAPI__)
			If IsIconic(Handle) Then
				ShowWindow Handle, SW_SHOWNORMAL
				'			ElseIf IsWindowVisible(Handle) Then
				'				This.SetFocus
			Else
				If Handle Then
					ShowWindow Handle, FCmdShow(FWindowState)
					If FParent Then Cast(Control Ptr, FParent)->RequestAlign
				Else
					CreateWnd
					Exit Sub
				End If
			End If
			SelectNextControl
		#endif
		If OnShow Then OnShow(*Designer, This)
	End Sub
	
	Private Sub Form.Show(ByRef OwnerForm As Form)
		This.FParent = @OwnerForm
		#ifdef __USE_GTK__
			If GTK_IS_WINDOW(widget) AndAlso GTK_IS_WINDOW(OwnerForm.widget) Then
				gtk_window_set_transient_for(GTK_WINDOW(widget), GTK_WINDOW(OwnerForm.widget))
			End If
		#endif
		This.Show
	End Sub
	
	#ifndef Form_ShowModal_Off
		Private Function Form.ShowModal(ByRef OwnerForm As Form) As Integer
			This.FParent = @OwnerForm
			CenterToParent
			Return This.ShowModal()
		End Function
		
		Private Function Form.ShowModal() As Integer
			#ifdef __USE_GTK__
				If pApp AndAlso pApp->ActiveForm <> 0 Then gtk_window_set_transient_for(GTK_WINDOW(widget), GTK_WINDOW(pApp->ActiveForm->widget))
				gtk_window_set_modal(GTK_WINDOW(widget), True)
				This.Show
				'If OnShow Then OnShow(This)
				gtk_main()
				gtk_window_set_modal(GTK_WINDOW(widget), False)
			#elseif defined(__USE_WINAPI__)
				Dim As Integer i
				Dim As Any Ptr Mtx
				FParentHandle = GetFocus()
				If IsWindowVisible(FHandle) Then
					This.SetFocus
					Exit Function
				End If
				If GetCapture <> 0 Then SendMessage(GetCapture,WM_CANCELMODE,0,0)
				'?"..." & GetCapture
				'ReleaseCapture
				For i = 0 To pApp->FormCount - 1
					pApp->Forms[i]->Enabled = False
				Next i
				Enabled = True
				Visible = True
				InShowModal = True
				Dim As MSG msg
				Dim TranslateAndDispatch As Boolean
				While GetMessage(@msg, NULL, 0, 0)
					TranslateAndDispatch = True
					If Accelerator Then TranslateAndDispatch = TranslateAccelerator(FHandle, Accelerator, @msg) = 0
					If TranslateAndDispatch Then
						Select Case msg.message
						Case WM_KEYDOWN
							Select Case msg.wParam
							Case VK_TAB ', VK_LEFT, VK_UP, VK_DOWN, VK_RIGHT, VK_PRIOR, VK_NEXT
								If Not GetFocus() = Handle Then
									SelectNextControl(GetKeyState(VK_SHIFT) And 8000)
									TranslateAndDispatch = False
								ElseIf IsDialogMessage(Handle, @msg) Then
									TranslateAndDispatch = False
								End If
							End Select
						End Select
					End If
					If TranslateAndDispatch Then
						TranslateMessage @msg
						DispatchMessage @msg
					End If
					If IsWindowVisible(FHandle) = 0 Then Exit While
				Wend
				For i = 0 To pApp->FormCount - 1
					pApp->Forms[i]->Enabled = True
				Next i
				InShowModal = False
				Visible = False
				ReleaseCapture
				'SetForegroundWindow FParentHandle
			#endif
			Function = ModalResult
		End Function
	#endif
	
	Private Sub Form.Hide
		#ifdef __USE_GTK__
			If widget Then
				#ifdef __USE_GTK3__
					If gtk_widget_is_visible(widget) Then
				#else
					If gtk_widget_get_visible(widget) Then
				#endif
					If OnHide Then OnHide(*Designer, This)
					If GTK_IS_WINDOW(widget) Then
						If gtk_window_get_modal (GTK_WINDOW(widget)) Then
							gtk_main_quit()
						End If
					End If
					gtk_widget_hide(widget)
				End If
			End If
		#elseif defined(__USE_WINAPI__)
			If Handle Then
				If IsWindowVisible(Handle) Then
					If OnHide Then OnHide(*Designer, This)
					ShowWindow Handle, SW_HIDE
				End If
			End If
		#endif
	End Sub
	
	Private Sub Form.Maximize
		#ifdef __USE_GTK__
			If GTK_IS_WINDOW(widget) Then
				gtk_window_maximize(GTK_WINDOW(widget))
			End If
		#elseif defined(__USE_WINAPI__)
			If IsIconic(Handle) = 0 Then
				ShowWindow Handle, SW_MAXIMIZE
			End If
		#endif
	End Sub
	
	Private Sub Form.Minimize
		#ifdef __USE_GTK__
			If GTK_IS_WINDOW(widget) Then
				gtk_window_iconify(GTK_WINDOW(widget))
			End If
		#elseif defined(__USE_WINAPI__)
			If IsIconic(Handle) = 0 Then
				ShowWindow Handle, SW_MINIMIZE
			End If
		#endif
	End Sub
	
	Private Sub Form.CloseForm
		#ifdef __USE_GTK__
			'#ifdef __USE_GTK3__
			'	gtk_window_close(Gtk_Window(widget))
			'#else
			Dim As Integer Action = 1
			If OnClose Then OnClose(*Designer, This, Action)
			Select Case Action
			Case 0
			Case 1
				If MainForm Then
					If GTK_IS_WIDGET(widget) Then
						#ifdef __USE_GTK4__
							g_object_unref(widget)
						#else
							gtk_widget_destroy(widget)
						#endif
					End If
					gtk_main_quit()
				Else
					If GTK_IS_WINDOW(widget) Then
						If gtk_window_get_modal (GTK_WINDOW(widget)) Then
							gtk_main_quit()
						End If
					End If
					gtk_widget_hide(widget)
				End If
			Case 2
			End Select
			'#endif
		#elseif defined(__USE_WINAPI__)
			If Handle Then SendMessage(Handle, WM_CLOSE, 0, 0)
		#endif
	End Sub
	
	Private Sub Form.CenterToParent()
		If FParent Then
			With *Cast(Control Ptr, FParent)
				#ifdef __USE_GTK__
					If GTK_IS_WINDOW(widget) Then
						gtk_window_set_position(GTK_WINDOW(widget), GTK_WIN_POS_CENTER)
						gtk_window_move(GTK_WINDOW(widget), ScaleX(.Left + (.Width - This.FWidth) \ 2), ScaleY(.Top + (.Height - This.FHeight) \ 2))
					End If
				#else
					This.Left = .Left + (.Width - This.Width) \ 2: This.Top  = .Top + (.Height - This.Height) \ 2
					This.Move This.Left, This.Top, This.Width, This.Height
				#endif
			End With
		End If
	End Sub
	
	Private Sub Form.CenterToScreen(ByVal ScrLeft As Integer = 0, ByVal ScrTop As Integer = 0, ByVal ScrWidth As Integer = 0, ByVal ScrHeight As Integer = 0)
		#ifdef __USE_GTK__
			If GTK_IS_WINDOW(widget) Then
				#ifdef __USE_GTK4__
					Dim As GdkRectangle workarea
					gdk_monitor_get_workarea(gdk_display_get_primary_monitor(gdk_display_get_default()), @workarea)
					gtk_window_move(GTK_WINDOW(widget), (workarea.width - ScaleX(This.FWidth)) \ 2, (workarea.height - ScaleY(This.FHeight)) \ 2)
				#else
					gtk_window_move(GTK_WINDOW(widget), (gdk_screen_width() - ScaleX(This.FWidth)) \ 2, (gdk_screen_height() - ScaleY(This.FHeight)) \ 2)
				#endif
			End If
			'gtk_window_set_position(gtk_window(widget), GTK_WIN_POS_CENTER) '_ALWAYS
		#elseif defined(__USE_WINAPI__)
			If ScrHeight = 0 AndAlso ScrWidth = 0 Then
				This.Left = (UnScaleX(GetSystemMetrics(SM_CXSCREEN)) - This.Width) \ 2
				This.Top  = (UnScaleY(GetSystemMetrics(SM_CYSCREEN)) - This.Height) \ 2
			Else
				This.Left = ScrLeft + (ScrWidth - This.Width) \ 2
				This.Top  = ScrTop + (ScrHeight - This.Height) \ 2
			End If
			Move This.Left, This.Top, This.Width, This.Height
		#endif
	End Sub
	
	Private Function Form.EnumMenuItems(Item As MenuItem) As Boolean
		FMenuItems.Add Item
		For i As Integer = 0 To Item.Count -1
			EnumMenuItems *Item.Item(i)
		Next i
		Return True
	End Function
	
	Private Sub Form.GetMenuItems
		FMenuItems.Clear
		If This.Menu Then
			#ifdef __USE_WINAPI__
				If IsMenu(This.Menu->Handle) = 0 Then Exit Sub
			#endif
			For i As Integer = 0 To This.Menu->Count -1
				EnumMenuItems *This.Menu->Item(i)
			Next i
		End If
	End Sub
	
	Private Sub Form.GraphicChange(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
		With Sender
			If .Ctrl->Child Then
				#ifdef __USE_GTK__
					If GTK_IS_IMAGE(QForm(.Ctrl->Child).ImageWidget) Then
						Select Case ImageType
						Case 0
							gtk_image_set_from_pixbuf(GTK_IMAGE(QForm(.Ctrl->Child).ImageWidget), .Bitmap.Handle)
						Case 1
							gtk_image_set_from_pixbuf(GTK_IMAGE(QForm(.Ctrl->Child).ImageWidget), .Icon.Handle)
						End Select
					End If
				#else
					'					Select Case ImageType
					'					Case 0
					'						QForm(.Ctrl->Child).ChangeStyle SS_BITMAP, True
					'						QForm(.Ctrl->Child).Perform(BM_SETIMAGE, ImageType, CInt(Sender.Bitmap.Handle))
					'					Case 1
					'						QForm(.Ctrl->Child).ChangeStyle SS_ICON, True
					'						QForm(.Ctrl->Child).Perform(BM_SETIMAGE, ImageType, CInt(Sender.Icon.Handle))
					'					Case 2
					'						QForm(.Ctrl->Child).ChangeStyle SS_ICON, True
					'						QForm(.Ctrl->Child).Perform(BM_SETIMAGE, ImageType, CInt(Sender.Icon.Handle))
					'					Case 3
					'						QForm(.Ctrl->Child).ChangeStyle SS_ENHMETAFILE, True
					'						QForm(.Ctrl->Child).Perform(BM_SETIMAGE, ImageType, CInt(0))
					'					End Select
					.Ctrl->Repaint
				#endif
			End If
		End With
	End Sub
	
	Private Operator Form.Cast As Control Ptr
		Return @This
	End Operator
	
	Private Sub Form.IconChanged(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.Icon)
		With *Cast(Form Ptr, Sender.Graphic)
			#ifdef __USE_WINAPI__
				SendMessage(.Handle, WM_SETICON, 1, CInt(.Icon.Handle))
			#endif
		End With
	End Sub
	
	Private Constructor Form
		#ifdef __USE_GTK__
			ImageWidget = gtk_image_new()
			WindowWidget = gtk_window_new(GTK_WINDOW_TOPLEVEL)
			widget = WindowWidget
			'gtk_window_set_policy(GTK_WINDOW(widget), true, false, false)
			This.RegisterClass "Form", @This
			If GTK_IS_WIDGET(layoutwidget) Then gtk_layout_put(GTK_LAYOUT(layoutwidget), ImageWidget, 0, 0)
		#elseif defined(__USE_WINAPI__)
			FMainStyle(0)  = 0
			FMainStyle(1)  = WS_EX_APPWINDOW
			FClassStyle(0) = CS_VREDRAW Or CS_HREDRAW Or CS_DBLCLKS
			FClassStyle(1) = CS_DBLCLKS
			FClassStyle(2) = CS_DBLCLKS Or CS_SAVEBITS Or CS_BYTEALIGNWINDOW
			FClassStyle(3) = CS_DBLCLKS
			FClassStyle(4) = CS_DBLCLKS
			FClassStyle(5) = CS_DBLCLKS
			FExStyle(0)    = WS_EX_CONTROLPARENT
			FExStyle(1)    = WS_EX_CONTROLPARENT
			FExStyle(2)    = WS_EX_CONTROLPARENT Or WS_EX_DLGMODALFRAME
			FExStyle(3)    = WS_EX_CONTROLPARENT
			FExStyle(4)    = WS_EX_CONTROLPARENT Or WS_EX_TOOLWINDOW
			FExStyle(5)    = WS_EX_CONTROLPARENT Or WS_EX_TOOLWINDOW
			FStyle(0)      = DS_CONTROL
			FStyle(1)      = WS_CAPTION Or WS_BORDER Or DS_CONTROL
			FStyle(2)      = WS_CAPTION Or WS_BORDER Or WS_SYSMENU
			FStyle(3)      = WS_OVERLAPPEDWINDOW
			FStyle(4)      = WS_CAPTION Or WS_BORDER Or WS_SYSMENU
			FStyle(5)      = WS_CAPTION Or WS_THICKFRAME Or WS_SYSMENU
			FChild(0) = 0
			FChild(1) = WS_CHILD
			FCmdShow(0) = SW_HIDE
			FCmdShow(1) = SW_SHOWNORMAL
			FCmdShow(2) = SW_SHOWMAXIMIZED
			FCmdShow(3) = SW_SHOWMINIMIZED
			This.RegisterClass "Form"
		#endif
		Text = "Form"
		FBorderStyle   = 3
		FWindowState   = 1
		FControlBox = True
		FMinimizeBox = True
		FMaximizeBox = True
		FOpacity = 255
		FTransparentColor = -1
		Canvas.Ctrl    = @This
		Graphic.Ctrl = @This
		Graphic.OnChange = @GraphicChange
		Icon.Graphic = @This
		Icon.Changed = @IconChanged
		With This
			.Child             = @This
			#ifdef __USE_WINAPI__
				.ChildProc         = @WNDPROC
			#endif
			WLet(FClassName, "Form")
			.OnActiveControlChanged = @ActiveControlChanged
			#ifdef __USE_WINAPI__
				.ExStyle           = WS_EX_CONTROLPARENT Or WS_EX_WINDOWEDGE 'FExStyle(FBorderStyle) OR FMainStyle(FMainForm)
				.Style             = WS_CAPTION Or WS_SYSMENU Or WS_MINIMIZEBOX Or WS_MAXIMIZEBOX Or WS_THICKFRAME Or WS_DLGFRAME Or WS_BORDER 'FStyle(FBorderStyle) Or FChild(Abs_(FIsChild))
				.BackColor             = GetSysColor(COLOR_BTNFACE)
				FDefaultBackColor = .BackColor
				.OnHandleIsAllocated = @HandleIsAllocated
				.Width             = 350 'CW_USEDEFAULT
				.Height            = 300 'CW_USEDEFAULT
				WLet(FClassAncestor, "")
			#elseif defined(__USE_JNI__)
				.Width             = 350
				.Height            = 300
				WLet(FClassAncestor, Replace(__FB_QUOTE__(Package), "_", "/") & "/mffActivity")
			#elseif defined(__USE_GTK__)
				.Width             = 350
				.Height            = 300
				WLet(FClassAncestor, "GtkWindow")
			#elseif defined(__USE_WASM__)
				.Width             = 350
				.Height            = 300
				WLet(FClassAncestor, "div")
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.StartPosition = DefaultLocation
		End With
		If pApp->MainForm = 0 Then
			pApp->MainForm = @This
			FMainForm = True
			
		End If
		#ifdef __AUTOMATE_CREATE_FORM__
			CreateWnd
		#endif
	End Constructor
	
	Private Destructor Form
		'		If OnFree Then OnFree(This)
		'		#ifndef __USE_GTK__
		'			If FHandle Then FreeWnd
		'		#endif
		This.Menu = 0
		FMenuItems.Clear
		#ifdef __USE_WINAPI__
			If Accelerator Then DestroyAcceleratorTable(Accelerator)
		#endif
		'UnregisterClass ClassName, GetModuleHandle(NULL)
	End Destructor
End Namespace

#ifdef __USE_JNI__
	Sub mffActivity_onCreate Alias AddToPackage(Package, mffActivity_onCreate) (ByVal env1 As JNIEnv Ptr, This_ As jobject, layout As jobject) Export
		If pApp Then
			If env = 0 Then
				env = env1
				Dim As jclass activityThread = (*env)->FindClass(env, "android/app/ActivityThread")
				Dim As jmethodID currentActivityThread = (*env)->GetStaticMethodID(env, activityThread, "currentActivityThread", "()Landroid/app/ActivityThread;")
				Dim As jobject at = (*env)->CallStaticObjectMethod(env, activityThread, currentActivityThread)
				Dim As jmethodID getApplication = (*env)->GetMethodID(env, activityThread, "getApplication", "()Landroid/app/Application;")
				pApp->Instance = (*env)->CallObjectMethod(env, at, getApplication)
				Instance = pApp->Instance
				Dim As jobject res = CallObjectMethod(pApp->Instance, "android/content/Context", "getResources", "()Landroid/content/res/Resources;")
				Dim As jobject displaymetrics = CallObjectMethod(res, "android/content/res/Resources", "getDisplayMetrics", "()Landroid/util/DisplayMetrics;")
				Dim As jclass displaymetricsClass = (*env)->FindClass(env, "android/util/DisplayMetrics")
				Dim As jfieldID xdpiField = (*env)->GetFieldID(env, displaymetricsClass, "xdpi", "F")
				Dim As jfieldID ydpiField = (*env)->GetFieldID(env, displaymetricsClass, "ydpi", "F")
				xdpi = (*env)->GetFloatField(env, displaymetrics, xdpiField) / 100
				ydpi = (*env)->GetFloatField(env, displaymetrics, ydpiField) / 100
				If pApp->MainForm Then
					pApp->MainForm->Handle = This_
					'				Dim As jmethodID getWindow = (*env)->GetMethodID(env, activityClass, "getWindow", "()Landroid/view/Window;")
					'				Dim As jobject iWindow = (*env)->CallObjectMethod(env, This_, getWindow)
					'				Dim As jclass windowClass = (*env)->FindClass(env, "android/view/Window")
					'				Dim As jmethodID getDecorView = (*env)->GetMethodID(env, windowClass, "getDecorView", "()Landroid/view/View;")
					'				Dim As jobject decorView = (*env)->CallObjectMethod(env, iWindow, getDecorView)
					'				Dim As jclass viewgroupClass = (*env)->FindClass(env, "android/view/ViewGroup")
					'				Dim As jmethodID getChildAt = (*env)->GetMethodID(env, viewgroupClass, "getChildAt", "(I)Landroid/view/View;")
					'				Dim As jobject ViewGroup = (*env)->CallObjectMethod(env, decorView, getChildAt, 0)
					'Dim As jobject ViewGroup2 = (*env)->CallObjectMethod(env, ViewGroup, getChildAt, 0)
					pApp->MainForm->LayoutHandle = layout 'ViewGroup
					pApp->MainForm->CreateWnd
					pApp->MainForm->Text = pApp->MainForm->Text 'ViewGroup
				End If
			End If
		End If
	End Sub
	
	Sub mffActivity_onDestroy Alias AddToPackage(Package, mffActivity_onDestroy) (ByVal env1 As JNIEnv Ptr, This_ As jobject, layout As jobject) Export
		If pApp Then
			If env <> 0 Then
				For i As Integer = 0 To Handles.Count - 1
					If Handles.Item(i) <> 0 Then
						Cast(My.Sys.Forms.Control Ptr, Handles.Item(i))->Handle = 0
					End If
				Next
				env = 0
			End If
		End If
	End Sub
#elseif defined(__USE_WASM__)
	Sub OnStart() Export
		If pApp Then
			If pApp->MainForm AndAlso pApp->MainForm->Handle = 0 Then
				pApp->MainForm->CreateWnd
				pApp->MainForm->Text = pApp->MainForm->Text
			End If
		End If
	End Sub
	
	Sub OnLoad(Id As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			If Ctrl AndAlso *Ctrl Is My.Sys.Forms.Form AndAlso Cast(My.Sys.Forms.Form Ptr, Ctrl)->OnShow Then Cast(My.Sys.Forms.Form Ptr, Ctrl)->OnShow(*Ctrl->Designer, *Cast(My.Sys.Forms.Form Ptr, Ctrl))
		End If
	End Sub
	
	Sub OnChange(Id As Integer) Export
		If Id > 0 Then
			'Dim As My.Sys.Forms.TextBox Ptr txt = Cast(Any Ptr, Id)
			'If txt AndAlso txt->OnChange Then txt->OnClick(*txt->Designer, *txt)
		End If
	End Sub
	
	Sub OnClick(Id As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			If Ctrl AndAlso Ctrl->OnClick Then Ctrl->OnClick(*Ctrl->Designer, *Ctrl)
		End If
	End Sub
	
	Sub OnDblClick(Id As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			If Ctrl AndAlso Ctrl->OnDblClick Then Ctrl->OnDblClick(*Ctrl->Designer, *Ctrl)
		End If
	End Sub
	
	Sub OnGotFocus(Id As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			If Ctrl AndAlso Ctrl->OnGotFocus Then Ctrl->OnGotFocus(*Ctrl->Designer, *Ctrl)
		End If
	End Sub
	
	Sub OnLostFocus(Id As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			If Ctrl AndAlso Ctrl->OnLostFocus Then Ctrl->OnLostFocus(*Ctrl->Designer, *Ctrl)
		End If
	End Sub
	
	Sub OnKeyDown(Id As Integer, Key As Integer, Shift As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			If Ctrl AndAlso Ctrl->OnKeyDown Then Ctrl->OnKeyDown(*Ctrl->Designer, *Ctrl, Key, Shift)
		End If
	End Sub
	
	Sub OnKeyPress(Id As Integer, Key As Integer, Shift As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			If Ctrl AndAlso Ctrl->OnKeyPress Then Ctrl->OnKeyPress(*Ctrl->Designer, *Ctrl, Key)
		End If
	End Sub
	
	Sub OnKeyUp(Id As Integer, Key As Integer, Shift As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			If Ctrl AndAlso Ctrl->OnKeyUp Then Ctrl->OnKeyUp(*Ctrl->Designer, *Ctrl, Key, Shift)
		End If
	End Sub
	
	Sub OnMouseDown(Id As Integer, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			If Ctrl AndAlso Ctrl->OnMouseDown Then Ctrl->OnMouseDown(*Ctrl->Designer, *Ctrl, MouseButton, x, y, Shift)
		End If
	End Sub
	
	Sub OnMouseMove(Id As Integer, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			If Ctrl AndAlso Ctrl->OnMouseMove Then Ctrl->OnMouseMove(*Ctrl->Designer, *Ctrl, MouseButton, x, y, Shift)
		End If
	End Sub
	
	Sub OnMouseUp(Id As Integer, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			If Ctrl AndAlso Ctrl->OnMouseUp Then Ctrl->OnMouseUp(*Ctrl->Designer, *Ctrl, MouseButton, x, y, Shift)
		End If
	End Sub
	
	Sub OnMouseEnter(Id As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			If Ctrl AndAlso Ctrl->OnMouseEnter Then Ctrl->OnMouseEnter(*Ctrl->Designer, *Ctrl)
		End If
	End Sub
	
	Sub OnMouseLeave(Id As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			If Ctrl AndAlso Ctrl->OnMouseLeave Then Ctrl->OnMouseLeave(*Ctrl->Designer, *Ctrl)
		End If
	End Sub
	
	Sub OnMouseWheel(Id As Integer, Direction As Integer, x As Integer, y As Integer, Shift As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			If Ctrl AndAlso Ctrl->OnMouseWheel Then Ctrl->OnMouseWheel(*Ctrl->Designer, *Ctrl, Direction, x, y, Shift)
		End If
	End Sub
	
	Sub OnUnload(Id As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			If Ctrl AndAlso Ctrl->OnDestroy Then Ctrl->OnDestroy(*Ctrl->Designer, *Ctrl)
		End If
	End Sub
	
	#if __FB_GUI__ = 0
		SetVisibleByStringId("termContainer", True)
	#endif
#endif
