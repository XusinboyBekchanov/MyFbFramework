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
			Case "caption": Return This.FText
			Case "defaultbutton": Return FDefaultButton
			Case "icon": Return @Icon
			Case "controlbox": Return @FControlBox
			Case "keypreview": Return @FKeyPreview
			Case "minimizebox": Return @FMinimizeBox
			Case "maximizebox": Return @FMaximizeBox
			Case "formstyle": Return @FFormStyle
			Case "menu": Return This.Menu
			Case "mainform": Return @FMainForm
			Case "modalresult": Return @ModalResult
			Case "opacity": Return @FOpacity
			Case "owner": Return FOwner
			Case "showintaskbar": Return @FShowInTaskbar
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
				Case "borderstyle": This.BorderStyle = *Cast(FormBorderStyle Ptr, Value)
				Case "cancelbutton": This.CancelButton = Cast(Control Ptr, Value)
				Case "caption": This.Caption = QWString(Value)
				Case "defaultbutton": This.DefaultButton = Cast(Control Ptr, Value)
				Case "formstyle": This.FormStyle = *Cast(FormStyles Ptr, Value)
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
				Case "showintaskbar": This.ShowInTaskbar = QBoolean(Value)
				Case "text": This.Text = QWString(Value)
				Case "transparent": This.Transparent = QBoolean(Value)
				Case "transparentcolor": This.TransparentColor = QInteger(Value)
				Case "windowstate": This.WindowState = *Cast(WindowStates Ptr, Value)
				Case "startposition": This.StartPosition = *Cast(FormStartPosition Ptr, Value)
				Case "visible": This.Visible = QBoolean(Value)
				Case "graphic": This.Graphic = QWString(Value)
				Case "xdpi": This.xdpi = QSingle(Value)
				Case "ydpi": This.ydpi = QSingle(Value)
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
				#ifndef __USE_GTK2__
					HeaderBarWidget = gtk_header_bar_new()
					gtk_widget_set_sensitive(HeaderBarWidget, False)
					gtk_header_bar_set_has_subtitle(GTK_HEADER_BAR(HeaderBarWidget), False)
					'gtk_widget_set_size_request(widget, FW, 1)
					If FText = 0 Then Return
					gtk_header_bar_set_title(GTK_HEADER_BAR(HeaderBarWidget), ToUtf8(*FText))
					'gtk_header_bar_set_show_close_button(gtk_header_bar(HeaderBarWidget), True)
				#else
					If FText = 0 Then Return
					HeaderBarWidget = gtk_label_new(ToUtf8(*FText))
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
		'A minimize or maximize button of the title bar like on Windows, hidden when MinimizeBox, MaximizeBox are False
		'(OnCaptionButton of the click, mff_lib.js)
		'Glyph: the character of the button (data-glyph, .mffcaptionbutton of mff.html)
		Private Function FormCaptionButton(ByRef Id As String, ByRef Kind As String, ByRef Hint As String, ByRef Glyph As String, Visible As Boolean) As String
			Return "<div class=""mffcaptionbutton"" id=""" & Id & Kind & "Button"" data-glyph=""" & Glyph & """ title=""" & Hint & """" & IIf(Visible, "", " style=""display: none""") & "></div>"
		End Function

		Private Function Form.GetContent() As UString
			'The class of the element (Control.CreateWnd calls GetContent before it uses FClass): a form which is
			'not the main one has a border and a shadow, without a border (a splash screen) only a shadow
			If FMainForm Then
				FClass = ""
			Else
				FClass = IIf(FBorderStyle = FormBorderStyle.None, "mffpopup", "mffdialog")
				'A designed form (the designer of the IDE) is in the panel of the designer: it is not over the page, its
				'title bar is in the panel above it like on Windows (.mffdesign of mff.html)
				If FDesignMode Then FClass &= " mffdesign"
			End If
			'A tool window has only the close button
			Dim As String CaptionButtons
			If FBorderStyle <> FormBorderStyle.SizableToolWindow AndAlso FBorderStyle <> FormBorderStyle.FixedToolWindow Then
				CaptionButtons = FormCaptionButton(Trim(Str(@This)), "Min", "Minimize", "min", FMinimizeBox) & _
					FormCaptionButton(Trim(Str(@This)), "Max", "Maximize", "max", FMaximizeBox)
			End If
			If FFormStyle = fsMDIForm Then
				Return "<div id=""" & Trim(Str(@This)) & "Client""></div>"
			ElseIf Not FMainForm AndAlso CBool(FBorderStyle <> FormBorderStyle.None) Then
				'BorderStyle None (a splash screen): no title bar. The title bar is above the client area of the
				'form (.mffcaption of mff.html): the controls keep their places, Height is the one of the client area
				Return "<div class=""mffcaption unselectable"" id=""" & Trim(Str(@This)) & "Header"">" & _
				"<span class=""mffcaptiontext"" id=""" & Trim(Str(@This)) & "Caption"">" & HtmlEscape(FText) & "</span>" & _
				CaptionButtons & _
				"<div class=""mffclose"" id=""" & Trim(Str(@This)) & "CloseButton"" title=""Close"">&#x2715;</div>" & _
				"</div>"
			Else
				Return ""
			End If
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
					App.MainForm = @This
				Else
					pApp->MainForm = 0
					App.MainForm = 0
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
	
	Private Property Form.StartPosition As FormStartPosition
		Return FStartPosition
	End Property
	
	#ifdef __USE_GTK__
		' Area of the primary monitor (gdk_screen_width/height cover all monitors together)
		Private Sub Form_PrimaryMonitorArea(widget As GtkWidget Ptr, ByRef Area As GdkRectangle)
			#ifdef __USE_GTK4__
				gdk_monitor_get_workarea(gdk_display_get_primary_monitor(gdk_display_get_default()), @Area)
			#else
				Dim As GdkScreen Ptr Screen_ = IIf(widget, gtk_widget_get_screen(widget), gdk_screen_get_default())
				Dim As gint Monitor = gdk_screen_get_primary_monitor(Screen_)
				#ifndef __USE_GTK2__
					gdk_screen_get_monitor_workarea(Screen_, Monitor, @Area)
				#else
					gdk_screen_get_monitor_geometry(Screen_, Monitor, @Area)
				#endif
			#endif
		End Sub
	#endif

	Private Property Form.StartPosition(Value As FormStartPosition)
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
							Dim As GdkRectangle workarea
							Form_PrimaryMonitorArea(widget, workarea)
							gtk_window_move(GTK_WINDOW(widget), workarea.x + (workarea.width - ScaleX(This.FWidth)) \ 2, workarea.y + (workarea.height - ScaleY(This.FHeight)) \ 2)
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
			#ifndef __USE_GTK2__
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
	
	#ifdef __USE_JNI__
		Private Property Form.ExternalEventAction ByRef As WString
			Return FExternalEventAction
		End Property
		
		Private Property Form.ExternalEventAction(ByRef Value As WString)
			FExternalEventAction = Value
			UpdateExternalEventFilter
		End Property
		
		Private Property Form.ExternalEventExtra ByRef As WString
			Return FExternalEventExtra
		End Property
		
		Private Property Form.ExternalEventExtra(ByRef Value As WString)
			FExternalEventExtra = Value
			UpdateExternalEventFilter
		End Property
		
		'Forwards the current ExternalEventAction/ExternalEventExtra values to the Java
		'Activity, which (re)registers its scanner BroadcastReceiver accordingly.
		Private Sub Form.UpdateExternalEventFilter
			If FHandle Then
				Dim As jmethodID func = GetMethodID(*FClassAncestor, "updateExternalEventFilter", "(Ljava/lang/String;Ljava/lang/String;)V")
				If func Then
					(*env)->CallVoidMethod(env, FHandle, func, (*env)->NewStringUTF(env, ToUtf8(FExternalEventAction)), (*env)->NewStringUTF(env, ToUtf8(FExternalEventExtra)))
				End If
			End If
		End Sub
	#endif
	
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
		#elseif defined(__USE_WASM__)
			If FHandle Then SetVisibleByStringId(Trim(Str(FHandle)) & "MinButton", Value)
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
		#elseif defined(__USE_WASM__)
			If FHandle Then SetVisibleByStringId(Trim(Str(FHandle)) & "MaxButton", Value)
		#endif
	End Property
	
	Private Property Form.BorderStyle As FormBorderStyle
		Return FBorderStyle
	End Property
	
	Private Property Form.BorderStyle(Value As FormBorderStyle)
		FBorderStyle = Value
		#ifdef __USE_JNI__
			'None: without the action bar (the main form, a form in its own activity); a dialog form is shown by the next Show
			ApplyAndroidStyle
		#endif
		#ifdef __USE_GTK__
			Select Case Value
			Case FormBorderStyle.None, FormBorderStyle.FixedToolWindow, FormBorderStyle.Fixed3D, FormBorderStyle.FixedSingle, FormBorderStyle.FixedDialog
				Dim As GdkGeometry hints
				hints.base_width = FWidth
				hints.base_height = FHeight
				hints.min_width = FWidth
				hints.min_height = FHeight
				hints.max_width = FWidth
				hints.max_height = FHeight
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
	
	Private Property Form.FormStyle As FormStyles
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
	
	Private Property Form.FormStyle(Value As FormStyles)
		If Value = FFormStyle Then Exit Property
		FFormStyle = Value
		#ifdef __USE_JNI__
			'Android has no MDI (fsMDIForm, fsMDIChild: normal forms); fsStayOnTop: over the other forms in its owner
			If FHandle <> 0 AndAlso FMainForm = False Then FormSetOnTop(FHandle, Value = FormStyles.fsStayOnTop)
		#endif
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
				#ifdef __USE_GTK4__
					mff_widget_set_draw_func(FClient, @Client_Draw, @This)
				#elseif Not defined(__USE_GTK2__)
					#ifdef __USE_GTK4__
						gtk4compat_signal_connect(FClient, "draw", G_CALLBACK(@Client_Draw), @This)
					#else
						g_signal_connect(FClient, "draw", G_CALLBACK(@Client_Draw), @This)
					#endif
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
			If FormStyle = fsMDIChild OrElse FParentWidget = 0 Then
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
	
	Private Property Form.ShowInTaskbar As Boolean
		Return FShowInTaskbar
	End Property
	
	Private Property Form.ShowInTaskbar(Value As Boolean)
		If FShowInTaskbar <> Value Then
			FShowInTaskbar = Value
			#ifdef __USE_WINAPI__
				Dim As ITaskbarList Ptr pTaskbarList
				'If SUCCEEDED(CoInitialize(NULL)) Then
					If SUCCEEDED(CoCreateInstance(@CLSID_TaskbarList, NULL, CLSCTX_INPROC_SERVER, @IID_ITaskbarList, Cast(LPVOID, @pTaskbarList))) Then
						pTaskbarList->lpVtbl->HrInit(pTaskbarList)
						If Value Then
							pTaskbarList->lpVtbl->DeleteTab(pTaskbarList, FHandle)
						Else
							pTaskbarList->lpVtbl->AddTab(pTaskbarList, FHandle)
						End If
						pTaskbarList->lpVtbl->Release(pTaskbarList)
					End If
					'CoUninitialize()
				'End If
			#endif
		End If
	End Property
	
	Property Form.WindowState As WindowStates
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
	
	Private Property Form.WindowState(Value As WindowStates)
		#ifdef __USE_WASM__
			'Web: a form with a title bar fills the page (maximized), only its title bar stays at the bottom left of the
			'page (minimized), it gets its bounds back (normal); the main form is the page
			If FHandle <> 0 AndAlso Not FMainForm AndAlso Value <> FWindowState AndAlso (Value = WindowStates.wsNormal OrElse Value = WindowStates.wsMinimized OrElse Value = WindowStates.wsMaximized) Then
				If FWindowState = WindowStates.wsNormal Then
					FRestoreLeft = FLeft: FRestoreTop = FTop: FRestoreWidth = FWidth: FRestoreHeight = FHeight
				End If
				FWindowState = Value
				'Left and Top are from the parent element (under the main menu), the page begins before it
				Dim As Integer OffsetX = UnScaleX(GetParentPageOffset(FHandle, 0)), OffsetY = UnScaleY(GetParentPageOffset(FHandle, 1))
				Select Case Value
				Case WindowStates.wsMaximized
					SetBounds -OffsetX, -OffsetY, UnScaleX(GetDocumentWidth), UnScaleY(GetDocumentHeight)
				Case WindowStates.wsMinimized
					'The title bar (28 pixels, .mffcaption of mff.html) and the border
					SetBounds -OffsetX, UnScaleY(GetDocumentHeight - 29) - OffsetY, 200, UnScaleY(29)
				Case Else
					SetBounds FRestoreLeft, FRestoreTop, FRestoreWidth, FRestoreHeight
				End Select
				SetCaptionState(FHandle, IIf(Value = WindowStates.wsMinimized, 1, IIf(Value = WindowStates.wsMaximized, 2, 0)))
				Exit Property
			End If
		#endif
		#ifdef __USE_JNI__
			'wsMinimized, wsHide: the main form goes to the background (Home), a second form is hidden; wsMaximized: the
			'bars of the system are hidden (immersive), a dialog fills its owner (the next Show); wsNormal: back
			If CBool(Not FDesignMode) AndAlso CBool(Value = WindowStates.wsMinimized OrElse Value = WindowStates.wsHide) Then
				If FMainForm Then
					ActivityMinimize
				ElseIf FHandle <> 0 Then
					Hide
				End If
				Exit Property
			End If
			FWindowState = Value
			ApplyAndroidStyle
			Exit Property
		#endif
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
				#ifndef __USE_GTK2__
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
			'Only the main Form is the Activity, another Form is a layout without a title
			If FHandle AndAlso (*env)->IsInstanceOf(env, FHandle, FindJNIClass("android/app/Activity")) Then
				(*env)->CallVoidMethod(env, FHandle, GetMethodID(*FClassAncestor, "setTitle", "(Ljava/lang/CharSequence;)V"), (*env)->NewStringUTF(env, ToUtf8(*FText)))
			ElseIf FHandle AndAlso DesignCaptionHeight Then
				'The title bar of the designed form (the designer of the IDE)
				FormDesignFrame(FHandle, ToUtf8(*FText), ScaleY(DesignCaptionHeight))
			ElseIf FHandle Then
				'The caption of the title bar of a second form (only when it was made by Show) or of its activity
				FormTitleBar(FHandle, ToUtf8(*FText), -1)
				FormActivityTitle(FHandle, ToUtf8(*FText))
			End If
		#elseif defined(__USE_WASM__)
			If FMainForm Then
				SetTitle(ToUtf8(Value))
			ElseIf FHandle Then
				'The text of the title bar (GetContent)
				SetInnerTextByStringId(Trim(Str(@This)) & "Caption", ToUtf8(Value))
			End If
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
					lpwp->x = frm->ScaleX(frm->FClientX)
					lpwp->y = frm->ScaleY(frm->FClientY)
					lpwp->cx = frm->ScaleX(frm->FClientW)
					lpwp->cy = frm->ScaleY(frm->FClientH)
				Case WM_PAINT, WM_ERASEBKGND
					SendMessage frm->Handle, uMsg, WPARAM, LPARAM
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
						If .Icon.ResName <> "" Then SetFormIcon(.FHandle, FindIconFile(ToUtf8(.Icon.ResName)), .FMainForm)
						'The main menu is a bar above the main form (SetMainMenu of mff_lib.js), its items are shown by OnMainMenu
						If .FMainForm AndAlso .FMenu <> 0 Then
							Dim As UString Captions
							For i As Integer = 0 To .FMenu->Count - 1
								If i > 0 Then Captions &= Chr(10)
								If .FMenu->Item(i) <> 0 AndAlso .FMenu->Item(i)->Visible Then Captions &= Replace(.FMenu->Item(i)->Caption, "&", "")
							Next
							SetMainMenu(.FHandle, ToUtf8(Captions))
						End If
					#elseif defined(__USE_WINAPI__)
						Dim As HMENU NoNeedSysMenu
						SetClassLong(.Handle, GCL_STYLE, .FClassStyle(.BorderStyle))
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
						If Not .FShowCaption Then .ShowCaption = False
						If Not .FShowInTaskbar Then .ShowInTaskbar = False
						If .Opacity <> 255 OrElse .Transparent Then SetLayeredWindowAttributes(.Handle, IIf(.TransparentColor = -1, .BackColor, .TransparentColor), .Opacity, IIf(.Transparent, LWA_COLORKEY, 0) Or LWA_ALPHA)
						.ChangeTabIndex - 2
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

	#ifdef __USE_GTK4__
		' The "close-request" signal (the delete event of GTK3). Returns True to keep the window
		Private Function Form.Form_CloseRequest(window_ As GtkWindow Ptr, user_data As Any Ptr) As Boolean
			Dim As Form Ptr frm = user_data
			If frm = 0 Then Return False
			Dim As Integer Action = 1
			If frm->OnClose Then frm->OnClose(*frm->Designer, *frm, Action)
			Select Case Action
			Case 0
				Return True
			Case 1
				If frm->MainForm Then
					gtk_main_quit()
					Return False
				Else
					If gtk_window_get_modal(window_) Then gtk_main_quit()
					gtk_widget_hide(GTK_WIDGET(window_))
					' See CloseForm (WSLg). GTK destroys the window in this signal too (default handler), unrealizing is safe
					If gtk_widget_get_realized(GTK_WIDGET(window_)) Then gtk_widget_unrealize(GTK_WIDGET(window_))
					frm->FCreated = False
					Return True
				End If
			Case Else
				Return True
			End Select
		End Function

		' The "notify::is-active" signal (the focus change event of GTK3)
		Private Sub Form.Form_ActiveChanged(window_ As GtkWindow Ptr, pspec As GParamSpec Ptr, user_data As Any Ptr)
			Dim As Form Ptr frm = user_data
			If frm = 0 Then Exit Sub
			If gtk_window_is_active(window_) Then
				If frm->OnActivateApp OrElse frm->OnDeActivateApp Then
					If pApp Then
						pApp->FActivated = True
						If frm->OnActivateApp AndAlso CInt(pApp->FDeactivated = False) Then frm->OnActivateApp(*frm->Designer, *frm)
					End If
				End If
				If pApp Then pApp->ActiveForm = frm
				If frm->OnActivate Then frm->OnActivate(*frm->Designer, *frm)
			Else
				If frm->OnDeActivate Then frm->OnDeActivate(*frm->Designer, *frm)
				If frm->OnActivateApp OrElse frm->OnDeActivateApp Then
					If pApp Then
						pApp->FDeactivated = True
						g_timeout_add(500, Cast(GSourceFunc, @deactivate_cb), frm)
					End If
				End If
			End If
		End Sub
	#endif
	
	#ifdef __USE_WINAPI__
		Private Sub Form.SetDark(Value As Boolean)
			Base.SetDark Value
			RefreshTitleBarThemeColor(FHandle)
			If FClient Then
				If Value Then
					SetWindowTheme(FClient, "DarkMode_Explorer", nullptr)
				Else
					SetWindowTheme(FClient, NULL, NULL)
				End If
				AllowDarkModeForWindow(FClient, g_darkModeEnabled)
				SendMessageW(FClient, WM_THEMECHANGED, 0, 0)
			End If
			SendMessage FHandle, WM_NCACTIVATE, False, 0
			SendMessage FHandle, WM_NCACTIVATE, True, 0
			SendMessage FHandle, WM_THEMECHANGED, 0, 0
			Repaint
		End Sub
	#endif
	
	Private Sub Form.ProcessMessage(ByRef msg As Message)
		Dim As Integer Action = 1
		#ifdef __USE_JNI__
			'The close button of the title bar of a second form or Back (mffActivity.formTitleBar)
			If msg.Msg = CM_CHANGE AndAlso msg.wParam = -1 AndAlso CInt(FMainForm) = 0 Then
				CloseForm
				msg.Result = -1
				Exit Sub
			End If
		#endif
		#ifdef __USE_GTK4__
			' See Form_CloseRequest and Form_ActiveChanged
		#elseif defined(__USE_GTK__)
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
				xdpi = msg.wParamLo / 96
				ydpi = msg.wParamHi / 96
				If xdpi = 0 Then xdpi = 1 'FDpiFormX
				If ydpi = 0 Then ydpi = 1 'FDpiFormY
				'If Not IsIconic(FHandle) Then 'AndAlso (xdpi <> FDpiFormX OrElse ydpi <> FDpiFormY) Then
				'	'FDpiFormX = xdpi
				'	'FDpiFormY = ydpi
				'	RequestAlign
				'End If
				FDPIChanging = True
				'Every control rebuilds its font and moves itself: repaint only once, when the
				'whole tree has the new scale (a paint in between shows a broken layout)
				'(Not deferred: the tree spans many parents, see Control.ProcessMessage)
				Dim As Integer iSavedAlignLock = AlignLock
				AlignLock = iSavedAlignLock + 1
				' A rescale always repaints: the fonts and the bounds changed
				If iSavedAlignLock = 0 Then AlignClear: AlignMoved = 2
				LockWindowUpdate(FHandle)
				Base.ProcessMessage(msg)
				' OnResize of the new window size waited for the rescaled tree (see WM_SIZE):
				'sizes computed from the children are right only now
				If OnResize AndAlso Not IsIconic(FHandle) Then OnResize(*Designer, This, This.Width, This.Height)
				LockWindowUpdate(0)
				AlignLock = iSavedAlignLock
				If iSavedAlignLock = 0 Then AlignRedraw FHandle
				FDPIChanging = False
				Return
			Case WM_SIZE
				'xdpi = FDpiFormX
				'ydpi = FDpiFormY
				' In a rescale OnResize runs once, when the whole tree has the new scale
				If OnResize AndAlso Not FDPIChanging Then OnResize(*Designer, This, This.Width, This.Height)
				If Not IsIconic(FHandle) Then
					'If Not FDPIChanging Then UpdateLock
					'RequestAlign
					'If Not FDPIChanging Then UpdateUnLock
					'If Graphic.Visible AndAlso Graphic.Bitmap.Handle > 0 Then Repaint
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
					If FormStyle = FormStyles.fsMDIChild Then
						DefMDIChildProc(msg.hWnd, msg.Msg, msg.wParam, msg.lParam)
					ElseIf FormStyle = FormStyles.fsMDIForm Then
						DefFrameProc(msg.hWnd, FClient, msg.Msg, msg.wParam, msg.lParam)
					Else
						DefWindowProc(msg.hWnd, msg.Msg, msg.wParam, msg.lParam)
					End If
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
			Case WM_PAINT
				If g_darkModeSupported AndAlso g_darkModeEnabled Then
					If Not FDarkMode Then SetDark True
				Else
					If FDarkMode Then SetDark False
				End If
				Dim As HDC Dc, memDC
				Dim As PAINTSTRUCT Ps
				Dim As ..Rect R
				GetClientRect Handle, @R
				Dim As HBITMAP Bmp, hOldBmp
				Dc = BeginPaint(Handle, @Ps)
				If DoubleBuffered Then
					memDC = CreateCompatibleDC(Dc)
					Bmp   = CreateCompatibleBitmap(Dc, R.Right - R.left, R.Bottom - R.Top)
					hOldBmp = SelectObject(memDC, Bmp)
					FillRect memDC, @R, Brush.Handle
					Canvas.SetHandle memDC
				Else
					FillRect Dc, @R, Brush.Handle
					Canvas.SetHandle Dc
				End If
				With Graphic
					If .Visible AndAlso .Bitmap.Handle > 0 Then
						Select Case Graphic.StretchImage
						Case StretchMode.smNone
							Canvas.DrawAlpha .StartX, .StartY, , , .Bitmap
						Case StretchMode.smStretch
							Canvas.DrawAlpha .StartX, .StartY, ScaleX(This.Width) * .ScaleFactor, ScaleY(This.Height) * .ScaleFactor, .Bitmap
						Case Else 'StretchMode.smStretchProportional
							Dim As Double imgWidth = .Bitmap.Width
							Dim As Double imgHeight = .Bitmap.Height
							Dim As Double PicBoxWidth = ScaleX(This.Width) * .ScaleFactor
							Dim As Double PicBoxHeight = ScaleY(This.Height) * .ScaleFactor
							Dim As Double img_ratio = imgWidth / imgHeight
							Dim As Double PicBox_ratio =  PicBoxWidth / PicBoxHeight
							If (PicBox_ratio >= img_ratio) Then
								imgHeight = PicBoxHeight
								imgWidth = imgHeight *img_ratio
							Else
								imgWidth = PicBoxWidth
								imgHeight = imgWidth / img_ratio
							End If
							If .CenterImage Then
								Canvas.DrawAlpha Max((PicBoxWidth - imgWidth * .ScaleFactor) / 2, .StartX), Max((PicBoxHeight - imgHeight * .ScaleFactor) / 2, Graphic.StartY), imgWidth * Graphic.ScaleFactor, imgHeight * .ScaleFactor, .Bitmap
							Else
								Canvas.DrawAlpha .StartX, .StartY, imgWidth, imgHeight, .Bitmap
							End If
						End Select
					End If
				End With
				If OnPaint Then OnPaint(*Designer, This, Canvas)
				Canvas.UnSetHandle
				If DoubleBuffered Then
					BitBlt(Dc, 0, 0, R.Right - R.left, R.Bottom - R.top, memDC, 0, 0, SRCCOPY)
					SelectObject memDC, hOldBmp
					DeleteObject(Bmp)
					DeleteDC(memDC)
				End If
				EndPaint Handle, @Ps
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
						If FParent AndAlso FParent->Handle Then
							SetWindowPos FParent->Handle, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE
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
				'xdpi = FDpiFormX
				'ydpi = FDpiFormY
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
			Case WM_MOUSEACTIVATE
				If Not FDesignMode Then
					If FFormStyle <> FormStyles.fsMDIChild Then
						If GetActiveWindow() <> FHandle Then
							msg.Result = MA_ACTIVATEANDEAT
							Return
						End If
					End If
				End If
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
				Dim As My.Sys.Drawing.Point P
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
				If Ctrl->containerwidget Then gtk_widget_show(Ctrl->containerwidget)
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
				If Ctrl->containerwidget Then gtk_widget_hide(Ctrl->containerwidget)
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
					If FStartPosition <> 0 Then StartPosition = Cast(FormStartPosition, FStartPosition)
					If Icon.ResName <> "" Then
						If GTK_IS_WINDOW(widget) Then
							Dim As GList Ptr list1 = NULL
							Dim As GError Ptr gerr
							Dim As GdkPixbuf Ptr gtkicon
							If Icon.ResName <> "" Then
								gtkicon = gdk_pixbuf_new_from_file_at_size(ToUtf8(Icon.ResName), 16, 16, @gerr)
								If gtkicon <> 0 Then list1 = g_list_append(list1, gtkicon)
								g_error_free(gerr)
								gerr = 0
								gtkicon = gdk_pixbuf_new_from_file_at_size(ToUtf8(Icon.ResName), 48, 48, @gerr)
								If gtkicon <> 0 Then list1 = g_list_append(list1, gtkicon)
								g_error_free(gerr)
								gerr = 0
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
					FVisible = True
					HideItems @This
					' MFF_GTK4_DUMP: prints the widget tree (debugging of the GTK4 layout)
					If Environ("MFF_GTK4_DUMP") <> "" Then g_timeout_add(Val(Environ("MFF_GTK4_DUMP")) * 1000 + 100, Cast(GSourceFunc, @gtk4compat_dump_timeout), widget)
				#else
					gtk_widget_show_all(widget)
					' An explicit arrow on the toplevel: child windows without own cursor inherit it.
					' With an unset (root) cursor XWayland/WSLg can keep the last shape, e.g. the I-beam of an editor
					If This.Cursor.Handle = 0 AndAlso gtk_widget_get_window(widget) Then
						gdk_window_set_cursor(gtk_widget_get_window(widget), gdk_cursor_new_for_display(gtk_widget_get_display(widget), GDK_LEFT_PTR))
					End If
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
		#elseif defined(__USE_WASM__)
			If FHandle = 0 Then
				'OnShow is raised by the load event of the new element (SetLoadEvent of HandleIsAllocated, ONLOAD) like
				'WM_SHOWWINDOW of Windows: it is not raised here a second time
				CreateWnd
				Exit Sub
			Else
				'A hidden form (Hide, CloseForm with Action 3) is shown again
				SetVisible(FHandle, True)
			End If
		#elseif defined(__USE_JNI__)
			'A Form which is not the Activity is a layout (a second form, the form of the designer of the IDE): it was made
			'hidden (View.GONE) and is shown like a control (View.VISIBLE)
			'A second form shown for the first time (Show(OwnerForm)) has no view yet: it is made in the layout of its owner
			'like a control; CreateWnd shows it (Show again, with its view) and raises OnShow
			If FHandle = 0 AndAlso env <> 0 AndAlso FParent <> 0 AndAlso Cast(Control Ptr, FParent)->layoutview <> 0 Then
				FVisible = True
				'The layout is transparent without a color: the form has the color of the dialogs of Windows (BTNFACE) over
				'the controls of its owner, the background of the dark theme in the night mode
				If FBackColor = -1 Then FBackColor = IIf(ActivityNightMode, &h121212, &hF0F0F0)
				CreateWnd
				If FHandle Then Exit Sub
			End If
			If FHandle AndAlso env AndAlso (*env)->IsInstanceOf(env, FHandle, FindJNIClass("android/view/View")) Then
				(*env)->CallVoidMethod(env, FHandle, GetMethodID("android/view/View", "setVisibility", "(I)V"), 0)
				FVisible = True
				'A second form of Show is a screen of its own (mffActivity.FormActivity: the caption in the action bar, Up; a
				'dialog of FixedDialog on a phone: the close button, a full-screen dialog which scrolls); a form of ShowModal,
				'a dialog on a tablet, a tool window, a form of fsStayOnTop (or without FormActivity in AndroidManifest.xml) is
				'a dialog over its owner
				If IsSecondForm Then
					ApplyAndroidStyle
					FormSetOnTop(FHandle, FFormStyle = FormStyles.fsStayOnTop)
					'A form which was made before (CreateWnd at the start of the program) has no color yet either
					If FBackColor = -1 Then FBackColor = IIf(ActivityNightMode, &h121212, &hF0F0F0): ApplyBackColor
				End If
				Dim As Boolean AsDialog = FInShowModal OrElse CBool(FBorderStyle = FormBorderStyle.FixedDialog AndAlso FormLargeScreen()) OrElse IsToolWindow OrElse CBool(FFormStyle = FormStyles.fsStayOnTop)
				If IsSecondForm AndAlso (AsDialog OrElse Not FormActivityShow(FHandle, ToUtf8(*FText))) AndAlso FormTitleBarHeight() > 0 Then
					'Like a full-screen dialog of Material: the form fills its owner under the title bar with the close
					'button and the caption (mffActivity.formTitleBar). On a tablet it is a dialog of its size (the one of
					'the designer) in the middle of its owner, the title bar is above it
					'A form of ShowModal is over the action bar too (like the dialogs of Android): its place is in the
					'window from the top of the action bar, the owner begins ActionBarHeight lower
					Dim As Integer ActionBarHeight = -1
					If FInShowModal Then ActionBarHeight = FormAttachTop(FHandle, Cast(Control Ptr, FParent)->layoutview)
					If ActionBarHeight < 0 Then
						FormAttach(FHandle, Cast(Control Ptr, FParent)->layoutview)
						ActionBarHeight = 0
					Else
						ActionBarHeight = UnScaleY(ActionBarHeight)
					End If
					If FDialogWidth = 0 Then FDialogLeft = FLeft: FDialogTop = FTop: FDialogWidth = FWidth: FDialogHeight = FHeight
					'BorderStyle None: no title bar, the form begins at the top of its owner
					Dim As Integer BarHeight = IIf(FBorderStyle = FormBorderStyle.None, 0, UnScaleY(FormTitleBarHeight()))
					With *Cast(Control Ptr, FParent)
						Dim As Integer OwnerWidth = IIf(.ClientWidth > 0, .ClientWidth, .Width), OwnerHeight = IIf(.ClientHeight > 0, .ClientHeight, .Height) + ActionBarHeight
						'Full-screen on a phone and maximized (wsMaximized); a dialog of its size on a tablet, a form of
						'ShowModal and a tool window of their size also on a phone (they scroll what does not fit)
						If FWindowState <> WindowStates.wsMaximized AndAlso (FormLargeScreen() OrElse IsToolWindow OrElse FInShowModal) Then
							Dim As Integer DialogWidth = Max(0, min(FDialogWidth, OwnerWidth - 32)), DialogHeight = Max(0, min(FDialogHeight, OwnerHeight - BarHeight - 32))
							Dim As Integer DialogLeft = (OwnerWidth - DialogWidth) \ 2, DialogTop = (OwnerHeight - DialogHeight + BarHeight) \ 2
							'StartPosition Manual: at Left and Top of the designer, in the owner
							If FStartPosition = FormStartPosition.Manual Then
								DialogLeft = Max(0, min(FDialogLeft, OwnerWidth - DialogWidth))
								DialogTop = Max(BarHeight, min(FDialogTop + BarHeight, OwnerHeight - DialogHeight))
							End If
							SetBounds DialogLeft, DialogTop, DialogWidth, DialogHeight
						Else
							SetBounds 0, BarHeight, OwnerWidth, OwnerHeight - BarHeight
						End If
					End With
					'The docked and anchored controls follow the new size at once (also the first time, before the layout)
					RequestAlign
					BringToFront
					'1 - shown, 2 - without the title bar, 8 - not modal (the owner gets the touches, no dim background)
					FormTitleBar(FHandle, ToUtf8(*FText), 1 Or IIf(FBorderStyle = FormBorderStyle.None, 2, 0) Or IIf(FInShowModal, 0, 8))
				End If
				If FParent Then Cast(Control Ptr, FParent)->RequestAlign
			End If
		#endif
		If OnShow Then OnShow(*Designer, This)
		#ifdef __USE_JNI__
			'The pictures of the controls whose state changed while they were not drawn (the form was hidden, OnCreate and
			'OnShow before the first drawing, outside of the scrolled part) stay at the beginning of their animation: a
			'checked RadioButton was only its ring
			If CBool(FHandle <> 0) AndAlso CBool(env <> 0) AndAlso FVisible AndAlso CBool((*env)->IsInstanceOf(env, FHandle, FindJNIClass("android/view/View")) <> 0) Then
				(*env)->CallVoidMethod(env, FHandle, GetMethodID("android/view/View", "jumpDrawablesToCurrentState", "()V"))
			End If
		#endif
	End Sub
	
	#ifdef __USE_JNI__
		'A second form of the program (made in the layout of its owner form, not the form of the designer of the IDE): Show
		'shows it in its own activity, ShowModal as a full-screen dialog
		Private Function Form.IsSecondForm As Boolean
			If FMainForm OrElse FDesignMode OrElse DesignCaptionHeight <> 0 OrElse FParent = 0 Then Return False
			Return *Cast(My.Sys.Object Ptr, FParent) Is Form
		End Function
		
		Private Function Form.IsToolWindow As Boolean
			Return FBorderStyle = FormBorderStyle.SizableToolWindow OrElse FBorderStyle = FormBorderStyle.FixedToolWindow
		End Function
		
		'BorderStyle None: without the action bar; FixedDialog: the close button instead of Up (a full-screen dialog);
		'WindowState wsMaximized: immersive (the bars of the system hidden). The main form is the activity of the
		'program, a second form of Show is its FormActivity
		Private Sub Form.ApplyAndroidStyle
			If FDesignMode OrElse CBool(Not FMainForm AndAlso FHandle = 0) Then Exit Sub
			Dim As Integer Style = IIf(FBorderStyle = FormBorderStyle.None, 1, 0) Or IIf(FWindowState = WindowStates.wsMaximized, 2, 0) Or IIf(FBorderStyle = FormBorderStyle.FixedDialog, 4, 0)
			If FMainForm Then FormSetStyle(0, Style) Else FormSetStyle(FHandle, Style)
		End Sub
	#endif
	
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
				If pApp AndAlso pApp->ActiveForm <> 0 AndAlso pApp->ActiveForm <> @This AndAlso GTK_IS_WINDOW(widget) AndAlso GTK_IS_WINDOW(pApp->ActiveForm->widget) Then
					gtk_window_set_transient_for(GTK_WINDOW(widget), GTK_WINDOW(pApp->ActiveForm->widget))
				End If
				If GTK_IS_WINDOW(widget) Then gtk_window_set_modal(GTK_WINDOW(widget), True)
				This.Show
				'If OnShow Then OnShow(This)
				gtk_main()
				' The main form widget is destroyed when it is closed
				If widget <> 0 AndAlso GTK_IS_WINDOW(widget) Then gtk_window_set_modal(GTK_WINDOW(widget), False)
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
			#elseif defined(__USE_WASM__)
				'The page has no loop of messages: the program waits (ASYNCIFY, ModalWait of mff_lib.js) until the
				'form is closed (CloseForm) or hidden (Hide), the events of the page run meanwhile
				InShowModal = True
				This.Show
				If FHandle Then ModalWait(FHandle)
				InShowModal = False
			#elseif defined(__USE_JNI__)
				'A full-screen dialog over its owner (the active form or the main form): the program waits in a nested
				'message loop of mffActivity until the form is hidden (CloseForm, Hide)
				If FParent = 0 AndAlso Not FMainForm AndAlso pApp <> 0 Then FParent = IIf(pApp->ActiveForm <> 0 AndAlso pApp->ActiveForm <> @This, pApp->ActiveForm, pApp->MainForm)
				FInShowModal = True
				This.Show
				If FHandle <> 0 AndAlso FVisible Then FormModalWait(FHandle)
				FInShowModal = False
			#endif
			Function = ModalResult
		End Function
	#endif
	
	Private Sub Form.Hide
		#ifdef __USE_GTK__
			If widget Then
				#ifndef __USE_GTK2__
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
		#elseif defined(__USE_WASM__)
			'The element is hidden (a waiting ShowModal returns)
			If FHandle Then
				If OnHide Then OnHide(*Designer, This)
				SetVisible(FHandle, False)
			End If
		#elseif defined(__USE_JNI__)
			'A Form which is not the Activity (a layout) is hidden like a control
			If FHandle AndAlso env AndAlso (*env)->IsInstanceOf(env, FHandle, FindJNIClass("android/view/View")) Then
				If OnHide Then OnHide(*Designer, This)
				(*env)->CallVoidMethod(env, FHandle, GetMethodID("android/view/View", "setVisibility", "(I)V"), 8)
				FVisible = False
				FormTitleBar(FHandle, ToUtf8(*FText), 0)
				FormActivityHide(FHandle)
				If FInShowModal Then FormModalEnd(FHandle)
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
	
	#ifdef __USE_WASM__
		'The element of a closed form is removed with the ones of its controls: the controls get the handle 0, the next
		'Show (ShowModal) makes their elements again (Control.CreateWnd does not make a second element of a handle)
		Private Sub FormClearElementHandles(Ctrl As Control Ptr)
			If Ctrl = 0 Then Exit Sub
			For i As Integer = 0 To Ctrl->ControlCount - 1
				FormClearElementHandles Ctrl->Controls[i]
				If Ctrl->Controls[i] Then Ctrl->Controls[i]->Handle = 0
			Next
		End Sub
	#endif
	
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
							gtk_widget_destroy(widget)
						#else
							gtk_widget_destroy(widget)
						#endif
						' The widget is freed, do not leave a dangling pointer for ShowModal/FreeWidget
						widget = 0
					End If
					gtk_main_quit()
				Else
					If GTK_IS_WINDOW(widget) Then
						If gtk_window_get_modal (GTK_WINDOW(widget)) Then
							gtk_main_quit()
						End If
					End If
					gtk_widget_hide(widget)
					#ifdef __USE_GTK4__
						' WSLg (weston RDP RAIL) can leave a hidden window on the screen while its Wayland surface
						' exists: the surface is destroyed, it is created again when the form is shown
						If GTK_IS_WINDOW(widget) AndAlso gtk_widget_get_realized(widget) Then gtk_widget_unrealize(widget)
					#endif
				End If
			Case 2
			End Select
			'#endif
		#elseif defined(__USE_WINAPI__)
			If Handle Then SendMessage(Handle, WM_CLOSE, 0, 0)
		#elseif defined(__USE_WASM__)
			Dim As Integer Action = 1
			If OnClose Then OnClose(*Designer, This, Action)
			Select Case Action
			Case 0
			Case 1
				If MainForm Then
					End 0
				Else
					#ifdef __HIDE_NO_MAIN_FORM_ON_CLOSE__
						SetVisible(FHandle, False)
					#else
						DeleteElement(FHandle)
						FHandle = 0
						FormClearElementHandles @This
					#endif
				End If
			Case 2
			Case 3
				SetVisible(FHandle, False)
			End Select
		#elseif defined(__USE_JNI__)
			'The main form is the Activity: it is not closed. A second form (a layout) is hidden, Show shows it again
			If FMainForm Then Exit Sub
			Dim As Integer Action = 1
			If OnClose Then OnClose(*Designer, This, Action)
			If Action <> 0 Then Hide
		#endif
	End Sub
	
	Private Sub Form.CenterToParent()
		#ifdef __USE_JNI__
			'A full-screen second form fills its owner (Show)
			If IsSecondForm Then Exit Sub
		#endif
		If FParent Then
			With *Cast(Control Ptr, FParent)
				#ifdef __USE_GTK__
					If GTK_IS_WINDOW(widget) Then
						gtk_window_set_position(GTK_WINDOW(widget), GTK_WIN_POS_CENTER)
						gtk_window_move(GTK_WINDOW(widget), ScaleX(.Left + (.Width - This.FWidth) \ 2), ScaleY(.Top + (.Height - This.FHeight) \ 2))
					End If
				#else
					This.Move .Left + (.Width - This.Width) \ 2, .Top + (.Height - This.Height) \ 2, This.Width, This.Height
				#endif
			End With
		End If
	End Sub
	
	Private Sub Form.CenterToScreen(ByVal ScrLeft As Integer = 0, ByVal ScrTop As Integer = 0, ByVal ScrWidth As Integer = 0, ByVal ScrHeight As Integer = 0)
		#ifdef __USE_GTK__
			If GTK_IS_WINDOW(widget) Then
				Dim As GdkRectangle workarea
				Form_PrimaryMonitorArea(widget, workarea)
				gtk_window_move(GTK_WINDOW(widget), workarea.x + (workarea.width - ScaleX(This.FWidth)) \ 2, workarea.y + (workarea.height - ScaleY(This.FHeight)) \ 2)
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
				#elseif defined(__USE_WINAPI__)
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
				#elseif defined(__USE_WASM__)
					Select Case ImageType
					Case 0
						.Ctrl->FElementStyle &= "background-image: url('" & .Bitmap.Handle & "');"
					Case 1
						.Ctrl->FElementStyle &= "background-image: url('" & .Icon.Handle & "');"
					End Select
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
			#elseif defined(__USE_WASM__)
				'Before the element of the form: HandleIsAllocated shows it
				If .FHandle Then SetFormIcon(.FHandle, FindIconFile(ToUtf8(.Icon.ResName)), .FMainForm)
			#endif
		End With
	End Sub
	
	Private Constructor Form
		#ifdef __USE_GTK__
			ImageWidget = gtk_image_new()
			#ifdef __USE_GTK4__
				WindowWidget = gtk_window_new()
			#else
				WindowWidget = gtk_window_new(GTK_WINDOW_TOPLEVEL)
			#endif
			widget = WindowWidget
			'gtk_window_set_policy(GTK_WINDOW(widget), true, false, false)
			This.RegisterClass "Form", @This
			#ifdef __USE_GTK4__
				g_signal_connect(widget, "close-request", G_CALLBACK(@Form_CloseRequest), @This)
				g_signal_connect(widget, "notify::is-active", G_CALLBACK(@Form_ActiveChanged), @This)
			#endif
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
			xdpi = 0
			ydpi = 0
			This.RegisterClass "Form"
		#endif
		Text = "Form"
		FBorderStyle   = 3
		FWindowState   = 1
		FControlBox = True
		FMinimizeBox = True
		FMaximizeBox = True
		FShowInTaskbar = True
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
				FDefaultBackColor = clWhite
				.BackColor       = clWhite
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
				Activity = (*env)->NewGlobalRef(env, This_)
				Dim As jobject res = CallObjectMethod(pApp->Instance, "android/content/Context", "getResources", "()Landroid/content/res/Resources;")
				Dim As jobject displaymetrics = CallObjectMethod(res, "android/content/res/Resources", "getDisplayMetrics", "()Landroid/util/DisplayMetrics;")
				Dim As jclass displaymetricsClass = (*env)->FindClass(env, "android/util/DisplayMetrics")
				Dim As jfieldID xdpiField = (*env)->GetFieldID(env, displaymetricsClass, "xdpi", "F")
				Dim As jfieldID ydpiField = (*env)->GetFieldID(env, displaymetricsClass, "ydpi", "F")
				Dim As jfieldID densityDpiField = (*env)->GetFieldID(env, displaymetricsClass, "densityDpi", "I")
				If pApp->MainForm Then
					' The designer is 96 dpi (AndroidDesignDpi): the form keeps its physical size (xdpi / ydpi are the physical pixels per inch);
					' some devices and emulators give no xdpi / ydpi, then the generalized densityDpi
					Dim As Single DensityDpi = (*env)->GetIntField(env, displaymetrics, densityDpiField)
					Dim As Single PhysicalXDpi = (*env)->GetFloatField(env, displaymetrics, xdpiField)
					Dim As Single PhysicalYDpi = (*env)->GetFloatField(env, displaymetrics, ydpiField)
					If PhysicalXDpi <= 0 Then PhysicalXDpi = DensityDpi
					If PhysicalYDpi <= 0 Then PhysicalYDpi = DensityDpi
					pApp->MainForm->xdpi = IIf(PhysicalXDpi > 0, PhysicalXDpi / IIf(AndroidDesignDpi > 0, AndroidDesignDpi, 96), 1)
					pApp->MainForm->ydpi = IIf(PhysicalYDpi > 0, PhysicalYDpi / IIf(AndroidDesignDpi > 0, AndroidDesignDpi, 96), 1)
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
					'BorderStyle None: without the action bar; WindowState wsMaximized: immersive
					FormSetStyle(0, IIf(pApp->MainForm->BorderStyle = My.Sys.Forms.FormBorderStyle.None, 1, 0) Or IIf(pApp->MainForm->WindowState = My.Sys.Forms.WindowStates.wsMaximized, 2, 0))
				End If
			End If
		End If
	End Sub
	
	'The captions of the items of the main menu of the main form, separated by Chr(10) ("" - a hidden item):
	'mffActivity shows them in the action bar (onPrepareOptionsMenu)
	Function mffActivity_mainMenuCaptions Alias AddToPackage(Package, mffActivity_mainMenuCaptions) (ByVal env1 As JNIEnv Ptr, This_ As jobject) As jstring Export
		Dim As UString Captions
		If pApp AndAlso pApp->MainForm AndAlso pApp->MainForm->Menu Then
			With *pApp->MainForm->Menu
				For i As Integer = 0 To .Count - 1
					If i > 0 Then Captions &= Chr(10)
					'Chr(9) & ">" - the item has items (the overflow menu shows an arrow by it)
					If .Item(i) <> 0 AndAlso .Item(i)->Visible Then Captions &= Replace(.Item(i)->Caption, "&", "") & IIf(.Item(i)->Count > 0, Chr(9) & ">", "")
				Next
			End With
		End If
		Return (*env1)->NewStringUTF(env1, ToUtf8(Captions))
	End Function
	
	'An item of the action bar was chosen: its items are shown as a popup menu, the chosen one is clicked
	Sub mffActivity_onMainMenu Alias AddToPackage(Package, mffActivity_onMainMenu) (ByVal env1 As JNIEnv Ptr, This_ As jobject, Index As jint) Export
		If pApp = 0 OrElse pApp->MainForm = 0 OrElse pApp->MainForm->Menu = 0 Then Exit Sub
		If Index < 0 OrElse Index >= pApp->MainForm->Menu->Count Then Exit Sub
		Dim As My.Sys.Forms.MenuItem Ptr mi = MenuItemShowItems(pApp->MainForm->Menu->Item(Index))
		If mi Then MenuItemChoose mi
	End Sub
	
	Sub mffActivity_onDestroy Alias AddToPackage(Package, mffActivity_onDestroy) (ByVal env1 As JNIEnv Ptr, This_ As jobject, layout As jobject) Export
		If pApp Then
			If env <> 0 Then
				For i As Integer = 0 To Handles.Count - 1
					If Handles.Item(i) <> 0 Then
						Dim As My.Sys.Forms.Control Ptr Ctrl = Handles.Item(i)
						If Ctrl->OnDestroy Then Ctrl->OnDestroy(* (Ctrl->Designer), *Ctrl)
						Ctrl->Handle = 0
					End If
				Next
				If Activity Then (*env)->DeleteGlobalRef(env, Activity): Activity = 0
				env = 0
			End If
		End If
	End Sub
	
	'Called from Java (Activity) side when an external event occurs, e.g. data received from a
	'barcode/QR code scanner. Forward the data to the main form's OnExternalEvent event.
	'On the Java side, declare a matching native method in the Activity, e.g.:
	'    public native void mffActivity_onExternalEvent(String data);
	'and call it whenever the scanner data arrives (BroadcastReceiver, onNewIntent, a Bluetooth/
	'Serial HID listener, etc.), passing the scanned text as the "data" argument.
	Sub mffActivity_onExternalEvent Alias AddToPackage(Package, mffActivity_onExternalEvent) (ByVal env1 As JNIEnv Ptr, This_ As jobject, Data_ As jstring) Export
		If pApp Then
			If env <> 0 AndAlso pApp->MainForm Then
				If Data_ <> 0 Then
					Dim As ZString Ptr pData = (*env)->GetStringUTFChars(env, Data_, 0)
					If pData Then
						Dim As WString Ptr Result = FromUtf8(Cast(ZString Ptr, pData))
						Dim As WString * 2048 wData = *Result
						(*env)->ReleaseStringUTFChars(env, Data_, pData)
						If pApp->MainForm->OnExternalEvent Then pApp->MainForm->OnExternalEvent(* (pApp->MainForm->Designer), *pApp->MainForm, wData)
						WDeAllocate(Result)
					End If
				End If
			End If
		End If
	End Sub
#elseif defined(__USE_WASM__)
	Sub OnStart() Export
		#if __FB_GUI__ = 0
			SetVisibleByStringId("termContainer", True)
		#endif
		If pApp Then
			If pApp->MainForm AndAlso pApp->MainForm->Handle = 0 Then
				pApp->MainForm->CreateWnd
				pApp->MainForm->Text = pApp->MainForm->Text
			End If
		End If
	End Sub
	
	'An item of the bar of the main menu was pressed (SetMainMenu of mff_lib.js): its items are shown as a popup menu
	'under it at x, y, the chosen one is clicked (an item without items is clicked itself)
	Sub OnMainMenu(Id As Integer, Index As Integer, x As Integer, y As Integer) Export
		If Id = 0 Then Exit Sub
		Dim As My.Sys.Forms.Form Ptr Frm = Cast(Any Ptr, Id)
		If Frm->Menu = 0 OrElse Index < 0 OrElse Index >= Frm->Menu->Count Then Exit Sub
		Dim As My.Sys.Forms.MenuItem Ptr mi = MenuItemShowItems(Frm->Menu->Item(Index), x, y)
		If mi Then MenuItemChoose mi
	End Sub

	'The main form got the size of the browser window (mff_lib.js): the anchored controls follow it
	Sub OnResize(Id As Integer, NewWidth As Integer, NewHeight As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			Ctrl->Width = Ctrl->UnScaleX(NewWidth)
			Ctrl->Height = Ctrl->UnScaleY(NewHeight)
			Ctrl->RequestAlign
			If Ctrl->OnResize Then Ctrl->OnResize(*Ctrl->Designer, *Ctrl, Ctrl->Width, Ctrl->Height)
		End If
	End Sub

	'Called by the setInterval of StartTimer (mff_lib.js)
	Sub OnTimer(Id As Integer) Export
		If TimerComponentProc Then TimerComponentProc(Id)
	End Sub

	'The canvas of the control got a new size or a picture of it was loaded (mff_lib.js)
	Sub OnPaint(Id As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			If Ctrl Then Ctrl->PaintCanvas
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
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			If Ctrl Then
				Dim As Message msg
				msg.Sender = Ctrl
				msg.Msg = CM_CHANGE
				DispatchControlMessage(Ctrl, msg)
			End If
		End If
	End Sub
	
	Sub OnClick(Id As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			If Ctrl Then
				Dim As Message msg
				msg.Sender = Ctrl
				msg.Msg = CM_CLICK
				DispatchControlMessage(Ctrl, msg)
				If (Not msg.Handled) AndAlso Ctrl->OnClick <> 0 Then Ctrl->OnClick(*Ctrl->Designer, *Ctrl)
			End If
		End If
	End Sub
	
	Sub OnClose(Id As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Form Ptr frm = Cast(Any Ptr, Id)
			'The close button of a designed form (the designer of the IDE) does not close it
			If frm = 0 OrElse frm->DesignMode Then Exit Sub
			Dim As Integer Action = 1
			If frm AndAlso frm->OnClose Then frm->OnClose(*frm->Designer, *frm, Action)
			Select Case Action
			Case 0
			Case 1
				If frm->MainForm Then
					End 0
				Else
					#ifdef __HIDE_NO_MAIN_FORM_ON_CLOSE__
						SetVisible(frm->Handle, False)
					#else
						DeleteElement(frm->Handle)
						frm->Handle = 0
						My.Sys.Forms.FormClearElementHandles frm
					#endif
				End If
			Case 2
			Case 3
				SetVisible(frm->Handle, False)
			End Select
		End If
	End Sub
	
	Sub OnDblClick(Id As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			If Ctrl AndAlso Ctrl->OnDblClick Then Ctrl->OnDblClick(*Ctrl->Designer, *Ctrl)
		End If
	End Sub
	
	Sub OnGotFocus(Id As Integer) Export
		If Id <= 0 Then Exit Sub
		SendControlInputMessage(Cast(Any Ptr, Id), CM_SETFOCUS, 0, 0)
		'The active control of the form like WM_SETFOCUS on Windows (Control.ProcessMessage)
		Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
		If Ctrl->DesignMode Then Exit Sub
		Dim As My.Sys.Forms.Form Ptr frm = Cast(My.Sys.Forms.Form Ptr, Ctrl->GetForm)
		If frm = 0 OrElse frm->ActiveControl = Ctrl Then Exit Sub
		frm->ActiveControl = Ctrl
	End Sub

	Sub OnLostFocus(Id As Integer) Export
		If Id > 0 Then SendControlInputMessage(Cast(Any Ptr, Id), CM_KILLFOCUS, 0, 0)
	End Sub

	'The key handlers return 1 if the control handled the key: mff_lib.js then stops the action of the browser
	Function OnKeyDown(Id As Integer, Key As Integer, Shift As Integer) As Integer Export
		If Id > 0 Then Return IIf(SendControlInputMessage(Cast(Any Ptr, Id), CM_KEYDOWN, Key, Shift), 1, 0)
	End Function

	Function OnKeyPress(Id As Integer, Key As Integer, Shift As Integer) As Integer Export
		If Id > 0 Then Return IIf(SendControlInputMessage(Cast(Any Ptr, Id), CM_CHAR, Key, Shift), 1, 0)
	End Function

	Function OnKeyUp(Id As Integer, Key As Integer, Shift As Integer) As Integer Export
		If Id > 0 Then Return IIf(SendControlInputMessage(Cast(Any Ptr, Id), CM_KEYUP, Key, Shift), 1, 0)
	End Function

	'The key code of the key of a shortcut ("F", "F3", "Del", "PgUp", "+"), 0 - unknown
	Private Function ShortcutKeyCode(ByRef KeyName As String) As Integer
		Dim As String k = UCase(Trim(KeyName))
		If Len(k) = 1 Then
			Select Case k
			Case "A" To "Z", "0" To "9": Return Asc(k)
			Case "+", "=": Return 187
			Case "-": Return 189
			Case ",": Return 188
			Case ".": Return 190
			Case "/": Return 191
			Case "`": Return 192
			Case "[": Return 219
			Case "\": Return 220
			Case "]": Return 221
			Case "'": Return 222
			Case ";": Return 186
			End Select
			Return 0
		End If
		If Left(k, 1) = "F" AndAlso Val(Mid(k, 2)) >= 1 AndAlso Val(Mid(k, 2)) <= 24 Then Return 111 + Val(Mid(k, 2))
		Select Case k
		Case "DEL", "DELETE": Return 46
		Case "INS", "INSERT": Return 45
		Case "HOME": Return 36
		Case "END": Return 35
		Case "PGUP", "PAGEUP": Return 33
		Case "PGDN", "PAGEDOWN": Return 34
		Case "UP": Return 38
		Case "DOWN": Return 40
		Case "LEFT": Return 37
		Case "RIGHT": Return 39
		Case "TAB": Return 9
		Case "ENTER", "RETURN": Return 13
		Case "ESC", "ESCAPE": Return 27
		Case "SPACE": Return 32
		Case "BACK", "BACKSPACE", "BKSP": Return 8
		End Select
		Return 0
	End Function

	'The shortcut of an item (ShortCut, or the text after Chr(9) of its caption like on Windows) is Key with Shift
	'(1 - Shift, 2 - Ctrl, 4 - Alt)
	Private Function ShortcutIs(mi As My.Sys.Forms.MenuItem Ptr, Key As Integer, Shift As Integer) As Boolean
		Dim As String sc = ToUtf8(mi->ShortCut)
		If sc = "" Then
			Dim As Integer p = InStr(mi->Caption, !"\t")
			If p = 0 Then Return False
			sc = ToUtf8(Mid(mi->Caption, p + 1))
		End If
		Dim As Integer Mods
		Do
			If UCase(Left(sc, 5)) = "CTRL+" Then
				Mods Or= 2: sc = Mid(sc, 6)
			ElseIf UCase(Left(sc, 6)) = "SHIFT+" Then
				Mods Or= 1: sc = Mid(sc, 7)
			ElseIf UCase(Left(sc, 4)) = "ALT+" Then
				Mods Or= 4: sc = Mid(sc, 5)
			Else
				Exit Do
			End If
		Loop
		Return Mods = Shift AndAlso ShortcutKeyCode(sc) = Key
	End Function

	'The enabled and visible item with the shortcut, in the item and its submenus
	Private Function FindShortcutItem(mi As My.Sys.Forms.MenuItem Ptr, Key As Integer, Shift As Integer) As My.Sys.Forms.MenuItem Ptr
		If CBool(mi = 0) OrElse Not mi->Enabled OrElse Not mi->Visible OrElse CBool(mi->Caption = "-") Then Return 0
		If mi->Count = 0 Then Return IIf(ShortcutIs(mi, Key, Shift), mi, 0)
		For i As Integer = 0 To mi->Count - 1
			Dim As My.Sys.Forms.MenuItem Ptr Found = FindShortcutItem(mi->Item(i), Key, Shift)
			If Found Then Return Found
		Next
		Return 0
	End Function

	'Hot keys (the keys of the page, mff_lib.js): the item of the main menu of the form of the focused control Id (of
	'the main form when no control has the focus, of the IDE and not of a designed form) whose shortcut is the key like
	'the accelerators of Windows, 0 - none. The page clicks the item after the key event (OnShortcutClick): a click can
	'wait (ShowModal), a key event can not
	Function OnShortcut(Id As Integer, Key As Integer, Shift As Integer) As Integer Export
		Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
		Do While Ctrl AndAlso (Ctrl->ClassName <> "Form" OrElse Ctrl->DesignMode)
			Ctrl = Ctrl->Parent
		Loop
		Dim As My.Sys.Forms.Form Ptr frm = IIf(Ctrl, Cast(My.Sys.Forms.Form Ptr, Ctrl), 0)
		'A form without a menu (a tool window like Find: a modal form does not get the keys, mff_lib.js) has the hot keys
		'of the main form
		If (frm = 0 OrElse frm->Menu = 0) AndAlso pApp <> 0 Then frm = Cast(My.Sys.Forms.Form Ptr, pApp->MainForm)
		If frm = 0 OrElse frm->Menu = 0 Then Return 0
		For i As Integer = 0 To frm->Menu->Count - 1
			Dim As My.Sys.Forms.MenuItem Ptr Found = FindShortcutItem(frm->Menu->Item(i), Key, Shift)
			If Found Then Return Cast(Integer, Found)
		Next
		Return 0
	End Function

	'The minimize (1) and maximize (2) buttons of the title bar (the double click on it: 2): the next state of the form
	Sub OnCaptionButton(Id As Integer, Button As Integer) Export
		Dim As My.Sys.Forms.Form Ptr frm = Cast(Any Ptr, Id)
		If frm = 0 Then Exit Sub
		If Button = 1 Then
			frm->WindowState = IIf(frm->WindowState = My.Sys.Forms.WindowStates.wsMinimized, My.Sys.Forms.WindowStates.wsNormal, My.Sys.Forms.WindowStates.wsMinimized)
		ElseIf frm->MaximizeBox Then
			frm->WindowState = IIf(frm->WindowState = My.Sys.Forms.WindowStates.wsNormal, My.Sys.Forms.WindowStates.wsMaximized, My.Sys.Forms.WindowStates.wsNormal)
		End If
	End Sub

	Sub OnShortcutClick(Item As Integer) Export
		If Item Then Cast(My.Sys.Forms.MenuItem Ptr, Item)->Click
	End Sub

	'The right button (contextmenu of the page): the control Id or its parent with ContextMenu like WM_CONTEXTMENU of
	'Windows (a designed control: the panel of the designer), 0 - none. The page shows it after the event
	'(OnContextMenuPopup): the popup menu waits for the chosen item
	Function OnContextMenu(Id As Integer) As Integer Export
		Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
		Do While Ctrl AndAlso Ctrl->ContextMenu = 0
			Ctrl = Ctrl->Parent
		Loop
		Return Cast(Integer, Ctrl)
	End Function

	'x, y: the place of the page
	Sub OnContextMenuPopup(Id As Integer, x As Integer, y As Integer) Export
		Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
		If Ctrl AndAlso Ctrl->ContextMenu Then Ctrl->ContextMenu->Popup(x, y)
	End Sub

	'Enter (13) and Escape (27) in a text box or a list of a form like a dialog of Windows: the button DefaultButton,
	'CancelButton of the form of the control Id, 0 - none. The page clicks it after the key event (OnClick)
	Function OnDialogKey(Id As Integer, Key As Integer) As Integer Export
		Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
		Do While Ctrl AndAlso Ctrl->ClassName <> "Form"
			Ctrl = Ctrl->Parent
		Loop
		If Ctrl = 0 OrElse Ctrl->DesignMode Then Return 0
		Dim As My.Sys.Forms.Control Ptr btn = IIf(Key = 13, Cast(My.Sys.Forms.Form Ptr, Ctrl)->DefaultButton, Cast(My.Sys.Forms.Form Ptr, Ctrl)->CancelButton)
		If CBool(btn = 0) OrElse Not btn->Enabled OrElse Not btn->Visible Then Return 0
		Return Cast(Integer, btn)
	End Function
	
	'The CM_MOUSE* message of the control (Chart), before its OnMouse* event
	Private Sub SendMouseMessage(Ctrl As My.Sys.Forms.Control Ptr, MsgId As Integer, MouseButton As Integer, x As Integer, y As Integer)
		Dim As Message msg
		msg.Sender = Ctrl
		msg.Msg = MsgId
		msg.wParam = MouseButton
		msg.lParam = MffPoint(x, y)
		DispatchControlMessage(Ctrl, msg)
	End Sub

	Sub OnMouseDown(Id As Integer, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			If Ctrl Then SendMouseMessage Ctrl, CM_MOUSEDOWN, MouseButton, x, y
			If Ctrl AndAlso Ctrl->OnMouseDown Then Ctrl->OnMouseDown(*Ctrl->Designer, *Ctrl, MouseButton, x, y, Shift)
		End If
	End Sub
	
	Sub OnMouseMove(Id As Integer, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			'MouseButton is e.buttons: 1 - left, 2 - right, 4 - middle
			If Ctrl Then SendMouseMessage Ctrl, CM_MOUSEMOVE, IIf(MouseButton And 1, 0, IIf(MouseButton And 2, 1, IIf(MouseButton And 4, 2, -1))), x, y
			If Ctrl AndAlso Ctrl->OnMouseMove Then Ctrl->OnMouseMove(*Ctrl->Designer, *Ctrl, MouseButton, x, y, Shift)
			'Like TrackMouseEvent of Windows: OnMouseHover when the mouse stays on the control (MouseHoverTimer)
			If Ctrl AndAlso Ctrl->OnMouseHover Then MouseHoverTimer(Ctrl, x, y, Shift)
		End If
	End Sub
	
	Sub OnMouseHover(Id As Integer, x As Integer, y As Integer, Shift As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			If Ctrl AndAlso Ctrl->OnMouseHover Then Ctrl->OnMouseHover(*Ctrl->Designer, *Ctrl, -1, x, y, Shift)
		End If
	End Sub
	
	Sub OnMouseUp(Id As Integer, MouseButton As Integer, x As Integer, y As Integer, Shift As Integer) Export
		If Id > 0 Then
			Dim As My.Sys.Forms.Control Ptr Ctrl = Cast(Any Ptr, Id)
			If Ctrl Then SendMouseMessage Ctrl, CM_MOUSEUP, MouseButton, x, y
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
			If Ctrl Then SendMouseMessage Ctrl, CM_MOUSELEAVE, -1, 0, 0
			If Ctrl AndAlso Ctrl->OnMouseLeave Then Ctrl->OnMouseLeave(*Ctrl->Designer, *Ctrl)
		End If
	End Sub
	
	Function OnMouseWheel(Id As Integer, Direction As Integer, x As Integer, y As Integer, Shift As Integer) As Integer Export
		If Id > 0 Then Return IIf(SendControlInputMessage(Cast(Any Ptr, Id), CM_MOUSEWHEEL, Direction, MffPoint(x, y), x, y, Shift), 1, 0)
	End Function
	
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