'###############################################################################
'#  gtk4compat.bi                                                              #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'#  GTK3 style helpers implemented with GTK4 (used only with __USE_GTK4__)     #
'###############################################################################

#ifdef __USE_GTK4__
#ifndef __GTK4COMPAT_BI__
#define __GTK4COMPAT_BI__

' IIf needs the same pointer types
#undef g_list_next
#undef g_list_previous
#undef g_slist_next
#define g_list_next(list_) IIf((list_), Cast(GList Ptr, (list_))->next, Cast(GList Ptr, NULL))
#define g_list_previous(list_) IIf((list_), Cast(GList Ptr, (list_))->prev, Cast(GList Ptr, NULL))
#define g_slist_next(slist) IIf((slist), Cast(GSList Ptr, (slist))->next, Cast(GSList Ptr, NULL))

#ifndef GDK_TYPE_PIXBUF
	#define GDK_TYPE_PIXBUF (gdk_pixbuf_get_type())
#endif

' Removed or renamed constants
#define GDK_MOD1_MASK GDK_ALT_MASK
#define GTK_SELECTION_EXTENDED GTK_SELECTION_MULTIPLE
Const GTK_ACCEL_VISIBLE = 1
Const GTK_ACCEL_LOCKED = 2

Type As Long GtkShadowType
Enum
	GTK_SHADOW_NONE = 0
	GTK_SHADOW_IN = 1
	GTK_SHADOW_OUT = 2
	GTK_SHADOW_ETCHED_IN = 3
	GTK_SHADOW_ETCHED_OUT = 4
End Enum

Type As Long GtkWindowPosition
Enum
	GTK_WIN_POS_NONE = 0
	GTK_WIN_POS_CENTER = 1
	GTK_WIN_POS_MOUSE = 2
	GTK_WIN_POS_CENTER_ALWAYS = 3
	GTK_WIN_POS_CENTER_ON_PARENT = 4
End Enum

Type As Long GdkWindowTypeHint
Enum
	GDK_WINDOW_TYPE_HINT_NORMAL = 0
	GDK_WINDOW_TYPE_HINT_DIALOG = 1
	GDK_WINDOW_TYPE_HINT_MENU = 2
	GDK_WINDOW_TYPE_HINT_TOOLBAR = 3
	GDK_WINDOW_TYPE_HINT_SPLASHSCREEN = 4
	GDK_WINDOW_TYPE_HINT_UTILITY = 5
	GDK_WINDOW_TYPE_HINT_DOCK = 6
	GDK_WINDOW_TYPE_HINT_DESKTOP = 7
	GDK_WINDOW_TYPE_HINT_DROPDOWN_MENU = 8
	GDK_WINDOW_TYPE_HINT_POPUP_MENU = 9
	GDK_WINDOW_TYPE_HINT_TOOLTIP = 10
	GDK_WINDOW_TYPE_HINT_NOTIFICATION = 11
	GDK_WINDOW_TYPE_HINT_COMBO = 12
	GDK_WINDOW_TYPE_HINT_DND = 13
End Enum

Type As Long GdkWindowHints
Enum
	GDK_HINT_POS = 1
	GDK_HINT_MIN_SIZE = 2
	GDK_HINT_MAX_SIZE = 4
	GDK_HINT_BASE_SIZE = 8
	GDK_HINT_ASPECT = 16
	GDK_HINT_RESIZE_INC = 32
	GDK_HINT_WIN_GRAVITY = 64
	GDK_HINT_USER_POS = 128
	GDK_HINT_USER_SIZE = 256
End Enum

' Event masks (gtk_widget_set_events does nothing in GTK4)
Enum GdkEventMask
	GDK_EXPOSURE_MASK = 2
	GDK_POINTER_MOTION_MASK = 4
	GDK_POINTER_MOTION_HINT_MASK = 8
	GDK_BUTTON_MOTION_MASK = 16
	GDK_BUTTON1_MOTION_MASK = 32
	GDK_BUTTON2_MOTION_MASK = 64
	GDK_BUTTON3_MOTION_MASK = 128
	GDK_BUTTON_PRESS_MASK = 256
	GDK_BUTTON_RELEASE_MASK = 512
	GDK_KEY_PRESS_MASK = 1024
	GDK_KEY_RELEASE_MASK = 2048
	GDK_ENTER_NOTIFY_MASK = 4096
	GDK_LEAVE_NOTIFY_MASK = 8192
	GDK_FOCUS_CHANGE_MASK = 16384
	GDK_STRUCTURE_MASK = 32768
	GDK_PROPERTY_CHANGE_MASK = 65536
	GDK_VISIBILITY_NOTIFY_MASK = 131072
	GDK_PROXIMITY_IN_MASK = 262144
	GDK_PROXIMITY_OUT_MASK = 524288
	GDK_SUBSTRUCTURE_MASK = 1048576
	GDK_SCROLL_MASK = 2097152
	GDK_TOUCH_MASK = 4194304
	GDK_SMOOTH_SCROLL_MASK = 8388608
	GDK_ALL_EVENTS_MASK = &hFFFFFE
End Enum

Type GdkGeometry
	As gint min_width, min_height
	As gint max_width, max_height
	As gint base_width, base_height
	As gint width_inc, height_inc
	As gdouble min_aspect, max_aspect
	As gint win_gravity
End Type

Type GdkColor
	As guint32 pixel
	As guint16 red, green, blue
End Type

' Classic cursor types, mapped to CSS cursor names
Enum GdkCursorType
	GDK_X_CURSOR = 0
	GDK_ARROW = 2
	GDK_BOTTOM_LEFT_CORNER = 12
	GDK_BOTTOM_RIGHT_CORNER = 14
	GDK_BOTTOM_SIDE = 16
	GDK_CROSS = 30
	GDK_CROSSHAIR = 34
	GDK_FLEUR = 52
	GDK_HAND1 = 58
	GDK_HAND2 = 60
	GDK_LEFT_PTR = 68
	GDK_LEFT_SIDE = 70
	GDK_PENCIL = 86
	GDK_PLUS = 90
	GDK_QUESTION_ARROW = 92
	GDK_RIGHT_SIDE = 96
	GDK_SB_H_DOUBLE_ARROW = 108
	GDK_SB_V_DOUBLE_ARROW = 116
	GDK_SIZING = 120
	GDK_TOP_LEFT_CORNER = 134
	GDK_TOP_RIGHT_CORNER = 136
	GDK_TOP_SIDE = 138
	GDK_WATCH = 150
	GDK_XTERM = 152
	GDK_BLANK_CURSOR = -2
	GDK_CURSOR_IS_PIXMAP = -1
End Enum

' Removed types
Type GdkWindow As GdkSurface
Type GdkScreen As GdkDisplay
Type GtkContainer As GtkWidget
Type GtkBin As GtkWidget
Type GtkMisc As GtkWidget
Type GtkLayout As GtkFixed
Type GtkClipboard As GdkClipboard
Type GtkAccelGroup As GtkEventController
Type GdkAtom As gpointer

' GdkEvent is opaque, the event structures do not exist anymore (use the gdk_event_* functions)
Type GdkEventAny As GdkEvent
Type GdkEventExpose As GdkEvent
Type GdkEventButton As GdkEvent
Type GdkEventMotion As GdkEvent
Type GdkEventKey As GdkEvent
Type GdkEventFocus As GdkEvent
Type GdkEventScroll As GdkEvent
Type GdkEventCrossing As GdkEvent
Type GdkEventConfigure As GdkEvent
Type GdkEventWindowState As GdkEvent
Type GdkDragContext As GdkDrop
Type GtkSelectionData As Any Ptr

#undef GTK_WINDOW
#define GTK_WINDOW(obj) Cast(GtkWindow Ptr, obj)
' gtk_box_pack_* also accept other containers
#undef GTK_BOX
#define GTK_BOX(obj) Cast(GtkBox Ptr, obj)
#define GTK_CONTAINER(obj) Cast(GtkWidget Ptr, obj)
#define GTK_BIN(obj) Cast(GtkWidget Ptr, obj)
#define GTK_MISC(obj) Cast(GtkWidget Ptr, obj)
#define GTK_IS_CONTAINER(obj) GTK_IS_WIDGET(obj)
#define GTK_IS_BIN(obj) GTK_IS_WIDGET(obj)
#define GTK_LAYOUT(obj) GTK_FIXED(obj)
#define GTK_IS_LAYOUT(obj) GTK_IS_FIXED(obj)
#define GTK_EVENT_BOX(obj) GTK_OVERLAY(obj)
#define GTK_IS_EVENT_BOX(obj) GTK_IS_OVERLAY(obj)

#define GDK_SELECTION_PRIMARY Cast(GdkAtom, 1)
#define GDK_SELECTION_CLIPBOARD Cast(GdkAtom, 69)

' -----------------------------------------------------------------------------
' Main loop (process wide, shared by the IDE and the library via g_dataset)
' -----------------------------------------------------------------------------
Type Gtk4CompatLoops
	Loops(0 To 63) As GMainLoop Ptr
	Depth As Integer
	' The button press event which is a double click (see gtk4compat_event_type)
	DoubleClickEvent As Any Ptr
	' A removed event type (e.g. GDK_MAP) sent from a signal handler without event
	PseudoEventType As Integer
	' The widget for the event coordinates (see gtk4compat_event_x)
	CurrentEventWidget As Any Ptr
	' GDK_FOCUS_CHANGE sent by the focus controller: focus in or out
	FocusIn As Boolean
End Type

Private Function gtk4compat_loops() As Gtk4CompatLoops Ptr
	Dim As Gtk4CompatLoops Ptr p = g_dataset_get_data(g_main_context_default(), "mff-gtk4-loops")
	If p = 0 Then
		p = g_malloc0(SizeOf(Gtk4CompatLoops))
		g_dataset_set_data(g_main_context_default(), "mff-gtk4-loops", p)
	End If
	Return p
End Function

' GTK4 has no double and triple click events. The controls get the second press
' once more as GDK_2BUTTON_PRESS (like GTK3), read the type with gtk4compat_event_type
#define GDK_2BUTTON_PRESS 1000
#define GDK_DOUBLE_BUTTON_PRESS 1000
#define GDK_3BUTTON_PRESS 1001
#define GDK_TRIPLE_BUTTON_PRESS 1001
' Removed event types. GDK_MAP, GDK_UNMAP and GDK_DESTROY come from the signals with Message.Event = 0
#define GDK_NOTHING 1100
#define GDK_DESTROY 1101
#define GDK_EXPOSE 1102
#define GDK_CONFIGURE 1103
#define GDK_MAP 1104
#define GDK_UNMAP 1105
#define GDK_PROPERTY_NOTIFY 1106
#define GDK_SELECTION_CLEAR 1107
#define GDK_SELECTION_REQUEST 1108
#define GDK_SELECTION_NOTIFY 1109
#define GDK_DRAG_STATUS 1110
#define GDK_DROP_FINISHED 1111
#define GDK_CLIENT_EVENT 1112
#define GDK_VISIBILITY_NOTIFY 1113
#define GDK_WINDOW_STATE 1114
#define GDK_SETTING 1115
#define GDK_OWNER_CHANGE 1116
#define GDK_DAMAGE 1117

#define GTK_ICON_LOOKUP_USE_BUILTIN 0
#define GTK_ICON_LOOKUP_NO_SVG 0
#define GTK_ICON_LOOKUP_FORCE_SVG 0
#define GTK_ICON_LOOKUP_GENERIC_FALLBACK 0
#define GTK_ICON_LOOKUP_FORCE_SIZE 0

Private Function gtk4compat_event_type(ByVal e As GdkEvent Ptr) As Integer
	Dim As Gtk4CompatLoops Ptr p = gtk4compat_loops()
	If p->PseudoEventType <> 0 Then Return p->PseudoEventType
	If e = 0 Then Return -1
	If p->DoubleClickEvent = e Then Return GDK_2BUTTON_PRESS
	Return gdk_event_get_event_type(e)
End Function

Private Function gtk4compat_event_keyval(ByVal e As GdkEvent Ptr) As guint
	Select Case gdk_event_get_event_type(e)
	Case GDK_KEY_PRESS, GDK_KEY_RELEASE: Return gdk_key_event_get_keyval(e)
	End Select
	Return 0
End Function

Private Function gtk4compat_event_button(ByVal e As GdkEvent Ptr) As guint
	Select Case gdk_event_get_event_type(e)
	Case GDK_BUTTON_PRESS, GDK_BUTTON_RELEASE: Return gdk_button_event_get_button(e)
	End Select
	Return 0
End Function

' The character of a key event as a string (like GdkEventKey.string in GTK3)
Private Function gtk4compat_event_string(ByVal e As GdkEvent Ptr) As String
	' Like the string of the key event of GTK3: the keypad Enter has no character
	Select Case gtk4compat_event_keyval(e)
	Case GDK_KEY_Return, GDK_KEY_KP_Enter, GDK_KEY_ISO_Enter: Return Chr(13)
	End Select
	Dim As guint32 KeyChar = gdk_keyval_to_unicode(gtk4compat_event_keyval(e))
	If KeyChar = 0 Then Return ""
	If KeyChar < 128 Then Return Chr(KeyChar)
	Dim As ZString * 8 Buffer
	g_unichar_to_utf8(KeyChar, @Buffer)
	Return Buffer
End Function

Private Sub gtk_main()
	Dim As Gtk4CompatLoops Ptr p = gtk4compat_loops()
	Dim As GMainLoop Ptr loop_ = g_main_loop_new(NULL, False)
	If p->Depth <= UBound(p->Loops) Then p->Loops(p->Depth) = loop_
	p->Depth += 1
	g_main_loop_run(loop_)
	p->Depth -= 1
	If p->Depth <= UBound(p->Loops) Then p->Loops(p->Depth) = 0
	g_main_loop_unref(loop_)
End Sub

Private Sub gtk_main_quit()
	Dim As Gtk4CompatLoops Ptr p = gtk4compat_loops()
	If p->Depth > 0 AndAlso p->Depth - 1 <= UBound(p->Loops) Then
		If p->Loops(p->Depth - 1) Then g_main_loop_quit(p->Loops(p->Depth - 1))
	End If
End Sub

Private Function gtk_main_level() As guint
	Return gtk4compat_loops()->Depth
End Function

Private Function gtk_events_pending() As gboolean
	Return g_main_context_pending(NULL)
End Function

Private Function gtk_main_iteration() As gboolean
	g_main_context_iteration(NULL, True)
	Return False
End Function

Private Function gtk_main_iteration_do(ByVal blocking As gboolean) As gboolean
	g_main_context_iteration(NULL, blocking)
	Return False
End Function

Private Sub gdk_threads_init()
End Sub

Private Sub gdk_threads_enter()
End Sub

Private Sub gdk_threads_leave()
End Sub

' -----------------------------------------------------------------------------
' Containers
' -----------------------------------------------------------------------------
' The first child packed with gtk_box_pack_end is marked, all following children are inserted before it
Private Function gtk4compat_box_first_end_child(ByVal box As GtkBox Ptr) As GtkWidget Ptr
	Dim As GtkWidget Ptr child = gtk_widget_get_first_child(GTK_WIDGET(box))
	While child
		If g_object_get_data(G_OBJECT(child), "mff-pack-end") Then Return child
		child = gtk_widget_get_next_sibling(child)
	Wend
	Return 0
End Function

' Widgets like GtkStatusbar do not unparent the children which were only parented (gtk_widget_set_parent)
' when they are disposed: the children keep a pointer to the freed parent. "destroy" is emitted
' after the own children were removed, the remaining children are unparented here
Private Sub gtk4compat_unparent_children CDecl(ByVal widget As GtkWidget Ptr, ByVal user_data As gpointer)
	Dim As GtkWidget Ptr child = gtk_widget_get_first_child(widget)
	While child
		Dim As GtkWidget Ptr NextChild = gtk_widget_get_next_sibling(child)
		gtk_widget_unparent(child)
		child = NextChild
	Wend
End Sub

' Parents the child and unparents it when the parent is disposed (see above)
Private Sub gtk4compat_set_parent(ByVal child As GtkWidget Ptr, ByVal parent As GtkWidget Ptr)
	gtk_widget_set_parent(child, parent)
	If g_object_get_data(G_OBJECT(parent), "mff-unparent-children") = 0 Then
		g_object_set_data(G_OBJECT(parent), "mff-unparent-children", Cast(gpointer, 1))
		g_signal_connect(parent, "destroy", G_CALLBACK(@gtk4compat_unparent_children), NULL)
	End If
End Sub

' Functions added after GTK 4.4 are found at run time, so the program also starts with older GTK4 versions
Declare Function gtk4compat_dlsym Cdecl Alias "dlsym"(ByVal handle As Any Ptr, ByVal symbol As Const ZString Ptr) As Any Ptr

Type gtk4compat_set_child_func As Sub Cdecl(ByVal widget As Any Ptr, ByVal child As GtkWidget Ptr)
Type gtk4compat_get_child_func As Function Cdecl(ByVal widget As Any Ptr) As GtkWidget Ptr
Type gtk4compat_content_fit_func As Sub Cdecl(ByVal picture As GtkPicture Ptr, ByVal content_fit As Long)
Type gtk4compat_get_color_func As Sub Cdecl(ByVal widget As GtkWidget Ptr, ByVal pColor As GdkRGBA Ptr)
Type gtk4compat_load_string_func As Sub Cdecl(ByVal provider As GtkCssProvider Ptr, ByVal s As Const gchar Ptr)

Private Function gtk4compat_symbol(ByVal SymbolName As Const ZString Ptr) As Any Ptr
	' RTLD_DEFAULT (0): searches the already loaded libraries
	Return gtk4compat_dlsym(0, SymbolName)
End Function

' GTK 4.8+
Private Sub gtk4compat_check_button_set_child(ByVal button As GtkCheckButton Ptr, ByVal child As GtkWidget Ptr)
	Static As Boolean bLoaded
	Static As gtk4compat_set_child_func pFunc
	If Not bLoaded Then pFunc = Cast(gtk4compat_set_child_func, gtk4compat_symbol("gtk_check_button_set_child")): bLoaded = True
	If pFunc Then
		pFunc(button, child)
	ElseIf child = 0 Then
		gtk_check_button_set_label(button, NULL)
	ElseIf GTK_IS_LABEL(child) Then
		' Older GTK4: the check button has only a text label
		gtk_check_button_set_label(button, gtk_label_get_text(GTK_LABEL(child)))
	End If
End Sub

' GTK 4.8+
Private Function gtk4compat_check_button_get_child(ByVal button As GtkCheckButton Ptr) As GtkWidget Ptr
	Static As Boolean bLoaded
	Static As gtk4compat_get_child_func pFunc
	If Not bLoaded Then pFunc = Cast(gtk4compat_get_child_func, gtk4compat_symbol("gtk_check_button_get_child")): bLoaded = True
	If pFunc Then Return pFunc(button)
	Return NULL
End Function

' GTK 4.6+
Private Sub gtk4compat_menu_button_set_child(ByVal button As GtkMenuButton Ptr, ByVal child As GtkWidget Ptr)
	Static As Boolean bLoaded
	Static As gtk4compat_set_child_func pFunc
	If Not bLoaded Then pFunc = Cast(gtk4compat_set_child_func, gtk4compat_symbol("gtk_menu_button_set_child")): bLoaded = True
	If pFunc Then
		pFunc(button, child)
	ElseIf child = 0 Then
	ElseIf GTK_IS_LABEL(child) Then
		' Older GTK4: the menu button has only a text label or an icon
		gtk_menu_button_set_label(button, gtk_label_get_text(GTK_LABEL(child)))
	ElseIf GTK_IS_IMAGE(child) Then
		If gtk_image_get_icon_name(GTK_IMAGE(child)) <> 0 Then gtk_menu_button_set_icon_name(button, gtk_image_get_icon_name(GTK_IMAGE(child)))
	End If
End Sub

' GTK 4.6+
Private Function gtk4compat_menu_button_get_child(ByVal button As GtkMenuButton Ptr) As GtkWidget Ptr
	Static As Boolean bLoaded
	Static As gtk4compat_get_child_func pFunc
	If Not bLoaded Then pFunc = Cast(gtk4compat_get_child_func, gtk4compat_symbol("gtk_menu_button_get_child")): bLoaded = True
	If pFunc Then Return pFunc(button)
	Return NULL
End Function

' GTK 4.8+
Private Sub gtk4compat_picture_set_content_fit(ByVal picture As GtkPicture Ptr, ByVal content_fit As Long)
	Static As Boolean bLoaded
	Static As gtk4compat_content_fit_func pFunc
	If Not bLoaded Then pFunc = Cast(gtk4compat_content_fit_func, gtk4compat_symbol("gtk_picture_set_content_fit")): bLoaded = True
	If pFunc Then
		pFunc(picture, content_fit)
	Else
		gtk_picture_set_keep_aspect_ratio(picture, content_fit <> GTK_CONTENT_FIT_FILL)
	End If
End Sub

' GTK 4.10+
Private Sub gtk4compat_widget_get_color(ByVal widget As GtkWidget Ptr, ByVal pColor As GdkRGBA Ptr)
	Static As Boolean bLoaded
	Static As gtk4compat_get_color_func pFunc
	If Not bLoaded Then pFunc = Cast(gtk4compat_get_color_func, gtk4compat_symbol("gtk_widget_get_color")): bLoaded = True
	If pFunc Then
		pFunc(widget, pColor)
	Else
		gtk_style_context_get_color(gtk_widget_get_style_context(widget), pColor)
	End If
End Sub

' GTK 4.12+
Private Sub gtk4compat_css_provider_load_from_string(ByVal provider As GtkCssProvider Ptr, ByVal s As Const gchar Ptr)
	Static As Boolean bLoaded
	Static As gtk4compat_load_string_func pFunc
	If Not bLoaded Then pFunc = Cast(gtk4compat_load_string_func, gtk4compat_symbol("gtk_css_provider_load_from_string")): bLoaded = True
	If pFunc Then
		pFunc(provider, s)
	Else
		gtk_css_provider_load_from_data(provider, s, -1)
	End If
End Sub

Private Sub gtk4compat_box_pack(ByVal box As GtkBox Ptr, ByVal child As GtkWidget Ptr, ByVal expand As gboolean, ByVal fill As gboolean, ByVal padding As guint, ByVal AtEnd As Boolean)
	If box = 0 OrElse child = 0 Then Exit Sub
	If GTK_IS_BOX(box) = 0 Then
		If gtk_widget_get_parent(child) Then gtk_widget_unparent(child)
		gtk4compat_set_parent child, GTK_WIDGET(box)
		Exit Sub
	End If
	Dim As GtkWidget Ptr FirstEnd = gtk4compat_box_first_end_child(box)
	Dim As Boolean Horizontal = gtk_orientable_get_orientation(GTK_ORIENTABLE(box)) = GTK_ORIENTATION_HORIZONTAL
	If FirstEnd = 0 Then
		gtk_box_append(box, child)
	Else
		gtk_box_insert_child_after(box, child, gtk_widget_get_prev_sibling(FirstEnd))
	End If
	If expand Then
		If Horizontal Then
			gtk_widget_set_hexpand(child, True): gtk_widget_set_halign(child, GTK_ALIGN_FILL)
		Else
			gtk_widget_set_vexpand(child, True): gtk_widget_set_valign(child, GTK_ALIGN_FILL)
		End If
	End If
	If padding Then
		If Horizontal Then
			gtk_widget_set_margin_start(child, padding): gtk_widget_set_margin_end(child, padding)
		Else
			gtk_widget_set_margin_top(child, padding): gtk_widget_set_margin_bottom(child, padding)
		End If
	End If
	If AtEnd Then
		g_object_set_data(G_OBJECT(child), "mff-pack-end", Cast(gpointer, 1))
		If FirstEnd = 0 AndAlso expand = 0 Then
			' Pushes the end children to the end of the box
			If Horizontal Then
				gtk_widget_set_hexpand(child, True): gtk_widget_set_halign(child, GTK_ALIGN_END)
			Else
				gtk_widget_set_vexpand(child, True): gtk_widget_set_valign(child, GTK_ALIGN_END)
			End If
		End If
	End If
End Sub

Private Sub gtk_box_pack_start(ByVal box As GtkBox Ptr, ByVal child As GtkWidget Ptr, ByVal expand As gboolean = False, ByVal fill As gboolean = False, ByVal padding As guint = 0)
	gtk4compat_box_pack box, child, expand, fill, padding, False
End Sub

Private Sub gtk_box_pack_end(ByVal box As GtkBox Ptr, ByVal child As GtkWidget Ptr, ByVal expand As gboolean = False, ByVal fill As gboolean = False, ByVal padding As guint = 0)
	gtk4compat_box_pack box, child, expand, fill, padding, True
End Sub

Private Sub gtk_container_add(ByVal container As GtkWidget Ptr, ByVal child As GtkWidget Ptr)
	If container = 0 OrElse child = 0 Then Exit Sub
	' Emulated menus keep their items in an inner box
	Dim As GtkWidget Ptr MenuBox = g_object_get_data(G_OBJECT(container), "mff-menu-box")
	If MenuBox Then container = MenuBox
	If GTK_IS_WINDOW(container) Then
		gtk_window_set_child(GTK_WINDOW(container), child)
	ElseIf GTK_IS_SCROLLED_WINDOW(container) Then
		gtk_scrolled_window_set_child(GTK_SCROLLED_WINDOW(container), child)
	ElseIf GTK_IS_BOX(container) Then
		gtk4compat_box_pack GTK_BOX(container), child, False, False, 0, False
	ElseIf GTK_IS_FIXED(container) Then
		gtk_fixed_put(GTK_FIXED(container), child, 0, 0)
	ElseIf GTK_IS_FRAME(container) Then
		gtk_frame_set_child(GTK_FRAME(container), child)
	ElseIf GTK_IS_MENU_BUTTON(container) Then
		gtk4compat_menu_button_set_child(GTK_MENU_BUTTON(container), child)
	ElseIf GTK_IS_BUTTON(container) Then
		gtk_button_set_child(GTK_BUTTON(container), child)
	ElseIf GTK_IS_CHECK_BUTTON(container) Then
		gtk4compat_check_button_set_child(GTK_CHECK_BUTTON(container), child)
	ElseIf GTK_IS_POPOVER(container) Then
		gtk_popover_set_child(GTK_POPOVER(container), child)
	ElseIf GTK_IS_VIEWPORT(container) Then
		gtk_viewport_set_child(GTK_VIEWPORT(container), child)
	ElseIf GTK_IS_OVERLAY(container) Then
		If gtk_overlay_get_child(GTK_OVERLAY(container)) = 0 Then
			gtk_overlay_set_child(GTK_OVERLAY(container), child)
		Else
			gtk_overlay_add_overlay(GTK_OVERLAY(container), child)
		End If
	ElseIf GTK_IS_EXPANDER(container) Then
		gtk_expander_set_child(GTK_EXPANDER(container), child)
	ElseIf GTK_IS_REVEALER(container) Then
		gtk_revealer_set_child(GTK_REVEALER(container), child)
	ElseIf GTK_IS_LIST_BOX(container) Then
		gtk_list_box_append(GTK_LIST_BOX(container), child)
	ElseIf GTK_IS_LIST_BOX_ROW(container) Then
		gtk_list_box_row_set_child(GTK_LIST_BOX_ROW(container), child)
	ElseIf GTK_IS_FLOW_BOX(container) Then
		gtk_flow_box_insert(GTK_FLOW_BOX(container), child, -1)
	ElseIf GTK_IS_STACK(container) Then
		gtk_stack_add_child(GTK_STACK(container), child)
	ElseIf GTK_IS_GRID(container) Then
		gtk_grid_attach(GTK_GRID(container), child, 0, 0, 1, 1)
	ElseIf GTK_IS_PANED(container) Then
		If gtk_paned_get_start_child(GTK_PANED(container)) = 0 Then
			gtk_paned_set_start_child(GTK_PANED(container), child)
		Else
			gtk_paned_set_end_child(GTK_PANED(container), child)
		End If
	ElseIf GTK_IS_NOTEBOOK(container) Then
		gtk_notebook_append_page(GTK_NOTEBOOK(container), child, NULL)
	ElseIf GTK_IS_SEARCH_BAR(container) Then
		gtk_search_bar_set_child(GTK_SEARCH_BAR(container), child)
	ElseIf GTK_IS_ACTION_BAR(container) Then
		gtk_action_bar_pack_start(GTK_ACTION_BAR(container), child)
	ElseIf GTK_IS_HEADER_BAR(container) Then
		gtk_header_bar_pack_start(GTK_HEADER_BAR(container), child)
	ElseIf GTK_IS_ASPECT_FRAME(container) Then
		gtk_aspect_frame_set_child(GTK_ASPECT_FRAME(container), child)
	ElseIf GTK_IS_TEXT_VIEW(container) Then
		gtk_text_view_add_overlay(GTK_TEXT_VIEW(container), child, 0, 0)
	Else
		gtk4compat_set_parent child, container
	End If
End Sub

Private Sub gtk_container_remove(ByVal container As GtkWidget Ptr, ByVal child As GtkWidget Ptr)
	If container = 0 OrElse child = 0 Then Exit Sub
	If gtk_widget_get_parent(child) = 0 Then Exit Sub
	' Pages of notebooks are in an inner stack: removing them from the stack left the page in the notebook
	If GTK_IS_STACK(gtk_widget_get_parent(child)) AndAlso GTK_IS_NOTEBOOK(gtk_widget_get_parent(gtk_widget_get_parent(child))) Then
		Dim As GtkNotebook Ptr Notebook = GTK_NOTEBOOK(gtk_widget_get_parent(gtk_widget_get_parent(child)))
		Dim As gint PageIndex = gtk_notebook_page_num(Notebook, child)
		If PageIndex >= 0 Then gtk_notebook_remove_page(Notebook, PageIndex): Exit Sub
	End If
	If GTK_IS_FLOW_BOX_CHILD(gtk_widget_get_parent(child)) AndAlso GTK_IS_FLOW_BOX_CHILD(container) = 0 Then
		Dim As GtkWidget Ptr FlowBoxChild = gtk_widget_get_parent(child)
		If GTK_IS_FLOW_BOX(gtk_widget_get_parent(FlowBoxChild)) Then gtk_flow_box_remove(GTK_FLOW_BOX(gtk_widget_get_parent(FlowBoxChild)), FlowBoxChild)
		Exit Sub
	End If
	' Emulated menus keep their items in an inner box
	Dim As GtkWidget Ptr MenuBox = g_object_get_data(G_OBJECT(container), "mff-menu-box")
	If MenuBox Then container = MenuBox
	' Single child containers: other children (e.g. popovers) are only parented
	Dim As GtkWidget Ptr MainChild
	Dim As Boolean SingleChild = True
	If GTK_IS_WINDOW(container) Then
		MainChild = gtk_window_get_child(GTK_WINDOW(container))
	ElseIf GTK_IS_SCROLLED_WINDOW(container) Then
		MainChild = gtk_scrolled_window_get_child(GTK_SCROLLED_WINDOW(container))
	ElseIf GTK_IS_FRAME(container) Then
		MainChild = gtk_frame_get_child(GTK_FRAME(container))
	ElseIf GTK_IS_MENU_BUTTON(container) Then
		MainChild = gtk4compat_menu_button_get_child(GTK_MENU_BUTTON(container))
	ElseIf GTK_IS_BUTTON(container) Then
		MainChild = gtk_button_get_child(GTK_BUTTON(container))
	ElseIf GTK_IS_CHECK_BUTTON(container) Then
		MainChild = gtk4compat_check_button_get_child(GTK_CHECK_BUTTON(container))
	ElseIf GTK_IS_POPOVER(container) Then
		MainChild = gtk_popover_get_child(GTK_POPOVER(container))
	ElseIf GTK_IS_VIEWPORT(container) Then
		MainChild = gtk_viewport_get_child(GTK_VIEWPORT(container))
	ElseIf GTK_IS_EXPANDER(container) Then
		MainChild = gtk_expander_get_child(GTK_EXPANDER(container))
	ElseIf GTK_IS_REVEALER(container) Then
		MainChild = gtk_revealer_get_child(GTK_REVEALER(container))
	Else
		SingleChild = False
	End If
	If SingleChild Then
		If MainChild <> child Then
			gtk_widget_unparent(child)
		ElseIf GTK_IS_WINDOW(container) Then
			gtk_window_set_child(GTK_WINDOW(container), NULL)
		ElseIf GTK_IS_SCROLLED_WINDOW(container) Then
			gtk_scrolled_window_set_child(GTK_SCROLLED_WINDOW(container), NULL)
		ElseIf GTK_IS_FRAME(container) Then
			gtk_frame_set_child(GTK_FRAME(container), NULL)
		ElseIf GTK_IS_MENU_BUTTON(container) Then
			gtk4compat_menu_button_set_child(GTK_MENU_BUTTON(container), NULL)
		ElseIf GTK_IS_BUTTON(container) Then
			gtk_button_set_child(GTK_BUTTON(container), NULL)
		ElseIf GTK_IS_CHECK_BUTTON(container) Then
			gtk4compat_check_button_set_child(GTK_CHECK_BUTTON(container), NULL)
		ElseIf GTK_IS_POPOVER(container) Then
			gtk_popover_set_child(GTK_POPOVER(container), NULL)
		ElseIf GTK_IS_VIEWPORT(container) Then
			gtk_viewport_set_child(GTK_VIEWPORT(container), NULL)
		ElseIf GTK_IS_EXPANDER(container) Then
			gtk_expander_set_child(GTK_EXPANDER(container), NULL)
		ElseIf GTK_IS_REVEALER(container) Then
			gtk_revealer_set_child(GTK_REVEALER(container), NULL)
		End If
	ElseIf GTK_IS_BOX(container) Then
		gtk_box_remove(GTK_BOX(container), child)
	ElseIf GTK_IS_FIXED(container) Then
		gtk_fixed_remove(GTK_FIXED(container), child)
	ElseIf GTK_IS_OVERLAY(container) Then
		If gtk_overlay_get_child(GTK_OVERLAY(container)) = child Then
			gtk_overlay_set_child(GTK_OVERLAY(container), NULL)
		Else
			gtk_overlay_remove_overlay(GTK_OVERLAY(container), child)
		End If
	ElseIf GTK_IS_LIST_BOX(container) Then
		gtk_list_box_remove(GTK_LIST_BOX(container), child)
	ElseIf GTK_IS_FLOW_BOX(container) Then
		gtk_flow_box_remove(GTK_FLOW_BOX(container), child)
	ElseIf GTK_IS_STACK(container) Then
		gtk_stack_remove(GTK_STACK(container), child)
	ElseIf GTK_IS_GRID(container) Then
		gtk_grid_remove(GTK_GRID(container), child)
	ElseIf GTK_IS_PANED(container) Then
		If gtk_paned_get_start_child(GTK_PANED(container)) = child Then
			gtk_paned_set_start_child(GTK_PANED(container), NULL)
		ElseIf gtk_paned_get_end_child(GTK_PANED(container)) = child Then
			gtk_paned_set_end_child(GTK_PANED(container), NULL)
		Else
			gtk_widget_unparent(child)
		End If
	ElseIf GTK_IS_NOTEBOOK(container) Then
		Dim As gint Index = gtk_notebook_page_num(GTK_NOTEBOOK(container), child)
		If Index >= 0 Then gtk_notebook_remove_page(GTK_NOTEBOOK(container), Index) Else gtk_widget_unparent(child)
	ElseIf GTK_IS_TEXT_VIEW(container) Then
		gtk_text_view_remove(GTK_TEXT_VIEW(container), child)
	ElseIf GTK_IS_ACTION_BAR(container) Then
		gtk_action_bar_remove(GTK_ACTION_BAR(container), child)
	ElseIf GTK_IS_HEADER_BAR(container) Then
		gtk_header_bar_remove(GTK_HEADER_BAR(container), child)
	Else
		gtk_widget_unparent(child)
	End If
End Sub

Private Function gtk_bin_get_child(ByVal bin_ As GtkWidget Ptr) As GtkWidget Ptr
	If bin_ = 0 Then Return 0
	' Emulated menu items return their label
	Dim As GtkWidget Ptr MenuLabel = g_object_get_data(G_OBJECT(bin_), "mff-menu-label")
	If MenuLabel Then Return MenuLabel
	If GTK_IS_WINDOW(bin_) Then
		Return gtk_window_get_child(GTK_WINDOW(bin_))
	ElseIf GTK_IS_SCROLLED_WINDOW(bin_) Then
		Return gtk_scrolled_window_get_child(GTK_SCROLLED_WINDOW(bin_))
	ElseIf GTK_IS_FRAME(bin_) Then
		Return gtk_frame_get_child(GTK_FRAME(bin_))
	ElseIf GTK_IS_MENU_BUTTON(bin_) Then
		Return gtk4compat_menu_button_get_child(GTK_MENU_BUTTON(bin_))
	ElseIf GTK_IS_BUTTON(bin_) Then
		Return gtk_button_get_child(GTK_BUTTON(bin_))
	ElseIf GTK_IS_CHECK_BUTTON(bin_) Then
		Return gtk4compat_check_button_get_child(GTK_CHECK_BUTTON(bin_))
	ElseIf GTK_IS_POPOVER(bin_) Then
		Return gtk_popover_get_child(GTK_POPOVER(bin_))
	ElseIf GTK_IS_VIEWPORT(bin_) Then
		Return gtk_viewport_get_child(GTK_VIEWPORT(bin_))
	ElseIf GTK_IS_OVERLAY(bin_) Then
		Return gtk_overlay_get_child(GTK_OVERLAY(bin_))
	ElseIf GTK_IS_EXPANDER(bin_) Then
		Return gtk_expander_get_child(GTK_EXPANDER(bin_))
	ElseIf GTK_IS_REVEALER(bin_) Then
		Return gtk_revealer_get_child(GTK_REVEALER(bin_))
	ElseIf GTK_IS_LIST_BOX_ROW(bin_) Then
		Return gtk_list_box_row_get_child(GTK_LIST_BOX_ROW(bin_))
	ElseIf GTK_IS_FLOW_BOX_CHILD(bin_) Then
		Return gtk_flow_box_child_get_child(GTK_FLOW_BOX_CHILD(bin_))
	ElseIf GTK_IS_COMBO_BOX(bin_) Then
		Return gtk_combo_box_get_child(GTK_COMBO_BOX(bin_))
	ElseIf GTK_IS_ASPECT_FRAME(bin_) Then
		Return gtk_aspect_frame_get_child(GTK_ASPECT_FRAME(bin_))
	ElseIf GTK_IS_SEARCH_BAR(bin_) Then
		Return gtk_search_bar_get_child(GTK_SEARCH_BAR(bin_))
	End If
	Return gtk_widget_get_first_child(bin_)
End Function

' Returns a lst of the child widgets, free it with g_list_free
Private Function gtk_container_get_children(ByVal container As GtkWidget Ptr) As GList Ptr
	Dim As GList Ptr lst = NULL
	If container = 0 Then Return NULL
	Dim As GtkWidget Ptr MenuBox = g_object_get_data(G_OBJECT(container), "mff-menu-box")
	If MenuBox Then container = MenuBox
	If GTK_IS_NOTEBOOK(container) Then
		For i As Integer = 0 To gtk_notebook_get_n_pages(GTK_NOTEBOOK(container)) - 1
			lst = g_list_append(lst, gtk_notebook_get_nth_page(GTK_NOTEBOOK(container), i))
		Next
		Return lst
	End If
	Dim As GtkWidget Ptr child = gtk_widget_get_first_child(container)
	While child
		lst = g_list_append(lst, child)
		child = gtk_widget_get_next_sibling(child)
	Wend
	Return lst
End Function

Private Sub gtk_container_foreach(ByVal container As GtkWidget Ptr, ByVal callback As Sub CDecl(ByVal As GtkWidget Ptr, ByVal As gpointer), ByVal callback_data As gpointer)
	Dim As GList Ptr lst = gtk_container_get_children(container)
	Dim As GList Ptr l = lst
	While l
		callback(Cast(GtkWidget Ptr, l->data), callback_data)
		l = l->next
	Wend
	g_list_free(lst)
End Sub

Private Sub gtk_container_set_border_width(ByVal container As GtkWidget Ptr, ByVal border_width As guint)
	If container = 0 Then Exit Sub
	gtk_widget_set_margin_start(container, border_width)
	gtk_widget_set_margin_end(container, border_width)
	gtk_widget_set_margin_top(container, border_width)
	gtk_widget_set_margin_bottom(container, border_width)
End Sub


' -----------------------------------------------------------------------------
' MffLayout: GtkFixed with a draw callback and a size-allocate callback
' (replaces GtkLayout and the "draw" and "size-allocate" signals)
' -----------------------------------------------------------------------------
Type MffDrawFunc As Function(ByVal widget As GtkWidget Ptr, ByVal cr As cairo_t Ptr, ByVal user_data As Any Ptr) As Boolean
Type MffSizeAllocateFunc As Sub(ByVal widget As GtkWidget Ptr, ByVal allocation As GdkRectangle Ptr, ByVal user_data As Any Ptr)

Private Function gtk4compat_parent_class(ByVal TypeName As Const gchar Ptr) As GtkWidgetClass Ptr
	Dim As GType t = g_type_from_name(TypeName)
	If t = 0 Then Return 0
	Return Cast(GtkWidgetClass Ptr, g_type_class_peek(g_type_parent(t)))
End Function

' Painting outside of the frame cycle (Canvas without OnPaint) goes into a buffer of the widget
Private Function mff_widget_begin_paint(ByVal widget As GtkWidget Ptr) As cairo_t Ptr
	If widget = 0 Then Return 0
	Dim As gint iWidth = gtk_widget_get_width(widget), iHeight = gtk_widget_get_height(widget)
	If iWidth <= 0 OrElse iHeight <= 0 Then Return 0
	Dim As cairo_surface_t Ptr surface = g_object_get_data(G_OBJECT(widget), "mff-paint-buffer")
	If surface = 0 OrElse cairo_image_surface_get_width(surface) <> iWidth OrElse cairo_image_surface_get_height(surface) <> iHeight Then
		Dim As cairo_surface_t Ptr NewSurface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, iWidth, iHeight)
		If surface Then
			' Keeps the painted content
			Dim As cairo_t Ptr cr = cairo_create(NewSurface)
			cairo_set_source_surface(cr, surface, 0, 0)
			cairo_paint(cr)
			cairo_destroy(cr)
		End If
		g_object_set_data_full(G_OBJECT(widget), "mff-paint-buffer", NewSurface, Cast(GDestroyNotify, @cairo_surface_destroy))
		surface = NewSurface
	End If
	Return cairo_create(surface)
End Function

Private Sub mff_widget_end_paint(ByVal widget As GtkWidget Ptr, ByVal cr As cairo_t Ptr)
	If cr Then cairo_destroy(cr)
	If widget Then gtk_widget_queue_draw(widget)
End Sub

Private Sub mff_widget_clear_paint_buffer(ByVal widget As GtkWidget Ptr)
	If widget = 0 Then Exit Sub
	g_object_set_data(G_OBJECT(widget), "mff-paint-buffer", NULL)
	gtk_widget_queue_draw(widget)
End Sub

' The size callback changes the layout (positions and sizes of children), this is not allowed
' while GTK allocates: it runs after the allocation in an idle callback
Private Function mff_layout_size_allocate_idle CDecl(ByVal user_data As gpointer) As gboolean
	Dim As GtkWidget Ptr widget = user_data
	g_object_set_data(G_OBJECT(widget), "mff-size-allocate-pending", NULL)
	' Destroyed controls removed their widgets from the parent
	If gtk_widget_get_parent(widget) = 0 AndAlso GTK_IS_WINDOW(widget) = 0 Then Return False
	Dim As MffSizeAllocateFunc SizeFunc = g_object_get_data(G_OBJECT(widget), "mff-size-allocate-func")
	If SizeFunc Then
		Dim As GdkRectangle allocation
		allocation.width = gtk_widget_get_width(widget)
		allocation.height = gtk_widget_get_height(widget)
		g_object_set_data(G_OBJECT(widget), "mff-in-size-callback", Cast(gpointer, 1))
		SizeFunc(widget, @allocation, g_object_get_data(G_OBJECT(widget), "mff-size-allocate-data"))
		g_object_set_data(G_OBJECT(widget), "mff-in-size-callback", NULL)
	End If
	Return False
End Function

' Schedules the size callback if the allocated size changed (called after the allocation)
Private Sub gtk4compat_check_size(ByVal widget As GtkWidget Ptr)
	If g_object_get_data(G_OBJECT(widget), "mff-size-allocate-func") = 0 Then Exit Sub
	Dim As gint iWidth = gtk_widget_get_width(widget), iHeight = gtk_widget_get_height(widget)
	If CInt(Cast(Integer, g_object_get_data(G_OBJECT(widget), "mff-alloc-width"))) = iWidth AndAlso CInt(Cast(Integer, g_object_get_data(G_OBJECT(widget), "mff-alloc-height"))) = iHeight Then Exit Sub
	g_object_set_data(G_OBJECT(widget), "mff-alloc-width", Cast(gpointer, CInt(iWidth)))
	g_object_set_data(G_OBJECT(widget), "mff-alloc-height", Cast(gpointer, CInt(iHeight)))
	If g_object_get_data(G_OBJECT(widget), "mff-size-allocate-pending") Then Exit Sub
	g_object_set_data(G_OBJECT(widget), "mff-size-allocate-pending", Cast(gpointer, 1))
	g_idle_add_full(G_PRIORITY_HIGH_IDLE, Cast(GSourceFunc, @mff_layout_size_allocate_idle), g_object_ref(widget), Cast(GDestroyNotify, @g_object_unref))
End Sub

Private Function gtk4compat_queue_size_callback_idle CDecl(ByVal user_data As gpointer) As gboolean
	Dim As GtkWidget Ptr widget = user_data
	g_object_set_data(G_OBJECT(widget), "mff-size-queue-pending", NULL)
	gtk_widget_queue_draw(widget)
	Return False
End Function

' Runs the size callback after the next frame also if the size of the widget did not change
' (e.g. a child changed its size: the layout of the children must be aligned again, like the "draw" signal of GTK3)
Private Sub gtk4compat_queue_size_callback(ByVal widget As GtkWidget Ptr)
	If widget = 0 Then Exit Sub
	If g_object_get_data(G_OBJECT(widget), "mff-size-allocate-func") = 0 Then Exit Sub
	' A request from the callback itself (e.g. from OnResize) would repeat the callback in each frame
	If g_object_get_data(G_OBJECT(widget), "mff-in-size-callback") Then Exit Sub
	g_object_set_data(G_OBJECT(widget), "mff-alloc-width", Cast(gpointer, -1))
	' The snapshot (after the allocation of the children) checks the size. The redraw is queued in an idle
	' callback: this can be called while GTK draws (e.g. from OnPaint), the widget must not be invalidated then
	If g_object_get_data(G_OBJECT(widget), "mff-size-queue-pending") Then Exit Sub
	g_object_set_data(G_OBJECT(widget), "mff-size-queue-pending", Cast(gpointer, 1))
	g_idle_add_full(G_PRIORITY_HIGH_IDLE, Cast(GSourceFunc, @gtk4compat_queue_size_callback_idle), g_object_ref(widget), Cast(GDestroyNotify, @g_object_unref))
End Sub

Private Sub mff_layout_snapshot CDecl(ByVal widget As GtkWidget Ptr, ByVal snapshot As GtkSnapshot Ptr)
	gtk4compat_check_size widget
	Dim As MffDrawFunc DrawFunc = g_object_get_data(G_OBJECT(widget), "mff-draw-func")
	Dim As cairo_surface_t Ptr PaintBuffer = g_object_get_data(G_OBJECT(widget), "mff-paint-buffer")
	If DrawFunc <> 0 OrElse PaintBuffer <> 0 Then
		Dim As graphene_rect_t r
		graphene_rect_init(@r, 0, 0, gtk_widget_get_width(widget), gtk_widget_get_height(widget))
		Dim As cairo_t Ptr cr = gtk_snapshot_append_cairo(snapshot, @r)
		If DrawFunc Then
			cairo_save(cr)
			DrawFunc(widget, cr, g_object_get_data(G_OBJECT(widget), "mff-draw-data"))
			cairo_restore(cr)
		End If
		If PaintBuffer Then
			cairo_set_source_surface(cr, PaintBuffer, 0, 0)
			cairo_paint(cr)
		End If
		cairo_destroy(cr)
	End If
	Dim As GtkWidgetClass Ptr ParentClass = g_type_class_peek(GTK_TYPE_FIXED)
	If ParentClass AndAlso ParentClass->snapshot Then ParentClass->snapshot(widget, snapshot)
End Sub

' Widgets with a layout manager (GtkFixed) do not get the size_allocate vfunc, the snapshot checks the size too
Private Sub mff_layout_size_allocate CDecl(ByVal widget As GtkWidget Ptr, ByVal iWidth As gint, ByVal iHeight As gint, ByVal baseline As gint)
	Dim As GtkWidgetClass Ptr ParentClass = g_type_class_peek(GTK_TYPE_FIXED)
	If ParentClass AndAlso ParentClass->size_allocate Then ParentClass->size_allocate(widget, iWidth, iHeight, baseline)
	gtk4compat_check_size widget
End Sub

' GtkLayout (GTK2/3) does not request the size of its children, GtkFixed does: the window could not become
' smaller than its children (Wayland closes the connection if the maximized window gets bigger than configured).
' The minimum size of the children is needed only inside a viewport (for the scrolling)
Private Sub mff_fixed_layout_measure CDecl(ByVal manager As GtkLayoutManager Ptr, ByVal widget As GtkWidget Ptr, ByVal orientation As GtkOrientation, ByVal for_size As gint, ByVal minimum As gint Ptr, ByVal natural As gint Ptr, ByVal minimum_baseline As gint Ptr, ByVal natural_baseline As gint Ptr)
	Dim As GtkLayoutManagerClass Ptr ParentClass = g_type_class_peek(GTK_TYPE_FIXED_LAYOUT)
	If ParentClass AndAlso ParentClass->measure Then ParentClass->measure(manager, widget, orientation, for_size, minimum, natural, minimum_baseline, natural_baseline)
	If minimum <> 0 AndAlso GTK_IS_VIEWPORT(gtk_widget_get_parent(widget)) = 0 Then *minimum = 0
End Sub

Private Sub mff_fixed_layout_class_init CDecl(ByVal klass As gpointer, ByVal class_data As gpointer)
	Dim As GtkLayoutManagerClass Ptr lc = klass
	lc->measure = @mff_fixed_layout_measure
End Sub

Private Function mff_fixed_layout_get_type() As GType
	Static As GType t
	Static As Boolean bChecked
	If bChecked Then Return t
	bChecked = True
	' G_TYPE_FLAG_FINAL (1 Shl 6): GtkFixedLayout can not be derived, the children size is requested then.
	' The flag exists since GLib 2.70: before it g_type_test_flags returns True for it, the type can be derived
	If glib_check_version(2, 70, 0) = 0 AndAlso g_type_test_flags(GTK_TYPE_FIXED_LAYOUT, 1 Shl 6) Then Return 0
	Dim As GTypeQuery q
	g_type_query(GTK_TYPE_FIXED_LAYOUT, @q)
	If q.type = 0 Then Return 0
	Dim As String TypeName = "MffFixedLayout" & Hex(Cast(UInteger, @mff_fixed_layout_measure))
	t = g_type_from_name(TypeName)
	If t = 0 Then t = g_type_register_static_simple(GTK_TYPE_FIXED_LAYOUT, TypeName, q.class_size, Cast(GClassInitFunc, @mff_fixed_layout_class_init), q.instance_size, NULL, 0)
	Return t
End Function

Private Sub mff_layout_class_init CDecl(ByVal klass As gpointer, ByVal class_data As gpointer)
	Dim As GtkWidgetClass Ptr wc = klass
	wc->snapshot = @mff_layout_snapshot
	wc->size_allocate = @mff_layout_size_allocate
	Dim As GType LayoutType = mff_fixed_layout_get_type()
	If LayoutType Then gtk_widget_class_set_layout_manager_type(wc, LayoutType)
End Sub

Private Function mff_layout_get_type() As GType
	' Each module (the IDE and the library) has its own class with its own functions
	Static As GType t
	If t = 0 Then
		Dim As String TypeName = "MffLayout" & Hex(Cast(UInteger, @mff_layout_snapshot))
		t = g_type_from_name(TypeName)
		If t = 0 Then t = g_type_register_static_simple(GTK_TYPE_FIXED, TypeName, SizeOf(GtkFixedClass), Cast(GClassInitFunc, @mff_layout_class_init), SizeOf(GtkFixed), NULL, 0)
	End If
	Return t
End Function

Private Function mff_layout_new() As GtkWidget Ptr
	Return GTK_WIDGET(g_object_new(mff_layout_get_type(), NULL))
End Function

' Replaces g_signal_connect(widget, "draw", ...). Works with MffLayout and GtkDrawingArea
Private Sub gtk4compat_drawing_area_draw CDecl(ByVal area As GtkDrawingArea Ptr, ByVal cr As cairo_t Ptr, ByVal iWidth As gint, ByVal iHeight As gint, ByVal user_data As gpointer)
	Dim As MffDrawFunc DrawFunc = g_object_get_data(G_OBJECT(area), "mff-draw-func")
	If DrawFunc Then DrawFunc(GTK_WIDGET(area), cr, user_data)
End Sub

Private Sub mff_widget_set_draw_func(ByVal widget As GtkWidget Ptr, ByVal DrawFunc As Any Ptr, ByVal user_data As Any Ptr)
	If widget = 0 Then Exit Sub
	g_object_set_data(G_OBJECT(widget), "mff-draw-func", DrawFunc)
	g_object_set_data(G_OBJECT(widget), "mff-draw-data", user_data)
	If GTK_IS_DRAWING_AREA(widget) Then
		gtk_drawing_area_set_draw_func(GTK_DRAWING_AREA(widget), @gtk4compat_drawing_area_draw, user_data, NULL)
	End If
	gtk_widget_queue_draw(widget)
End Sub

' Replaces g_signal_connect(widget, "size-allocate", ...) for MffLayout and GtkDrawingArea
Private Sub gtk4compat_drawing_area_resize CDecl(ByVal area As GtkDrawingArea Ptr, ByVal iWidth As gint, ByVal iHeight As gint, ByVal user_data As gpointer)
	Dim As MffSizeAllocateFunc SizeFunc = g_object_get_data(G_OBJECT(area), "mff-size-allocate-func")
	If SizeFunc Then
		Dim As GdkRectangle allocation
		allocation.width = iWidth
		allocation.height = iHeight
		SizeFunc(GTK_WIDGET(area), @allocation, user_data)
	End If
End Sub

Private Sub mff_widget_set_size_allocate_func(ByVal widget As GtkWidget Ptr, ByVal SizeFunc As Any Ptr, ByVal user_data As Any Ptr)
	If widget = 0 Then Exit Sub
	g_object_set_data(G_OBJECT(widget), "mff-size-allocate-func", SizeFunc)
	g_object_set_data(G_OBJECT(widget), "mff-size-allocate-data", user_data)
	If GTK_IS_DRAWING_AREA(widget) Then
		g_signal_connect(widget, "resize", G_CALLBACK(@gtk4compat_drawing_area_resize), user_data)
	End If
End Sub

Private Function gtk_layout_new(ByVal hadjustment As GtkAdjustment Ptr = 0, ByVal vadjustment As GtkAdjustment Ptr = 0) As GtkWidget Ptr
	Return mff_layout_new()
End Function

Private Sub gtk_layout_put(ByVal layout As GtkFixed Ptr, ByVal child As GtkWidget Ptr, ByVal x As gint, ByVal y As gint)
	If layout = 0 OrElse child = 0 Then Exit Sub
	gtk_fixed_put(layout, child, x, y)
End Sub

Private Sub gtk_layout_move(ByVal layout As GtkFixed Ptr, ByVal child As GtkWidget Ptr, ByVal x As gint, ByVal y As gint)
	If layout = 0 OrElse child = 0 Then Exit Sub
	If gtk_widget_get_parent(child) = GTK_WIDGET(layout) Then gtk_fixed_move(layout, child, x, y)
End Sub

' GtkFixed grows with its children, the size of the scrollable area is not needed
Private Sub gtk_layout_set_size(ByVal layout As GtkFixed Ptr, ByVal iWidth As guint, ByVal iHeight As guint)
End Sub

Private Sub gtk_layout_get_size(ByVal layout As GtkFixed Ptr, ByVal iWidth As guint Ptr, ByVal iHeight As guint Ptr)
	If iWidth Then *iWidth = gtk_widget_get_width(GTK_WIDGET(layout))
	If iHeight Then *iHeight = gtk_widget_get_height(GTK_WIDGET(layout))
End Sub

' An overlay is a single child container that fills the child, like GtkEventBox
Private Function gtk_event_box_new() As GtkWidget Ptr
	Return gtk_overlay_new()
End Function

Private Sub gtk_event_box_set_visible_window(ByVal event_box As GtkWidget Ptr, ByVal visible_window As gboolean)
End Sub

Private Sub gtk_event_box_set_above_child(ByVal event_box As GtkWidget Ptr, ByVal above_child As gboolean)
End Sub

' -----------------------------------------------------------------------------
' Widgets
' -----------------------------------------------------------------------------
Private Sub gtk_widget_show_all(ByVal widget As GtkWidget Ptr)
	If widget Then gtk_widget_set_visible(widget, True)
End Sub

Private Sub gtk_widget_set_no_show_all(ByVal widget As GtkWidget Ptr, ByVal no_show_all As gboolean)
End Sub

Private Sub gtk_widget_set_events(ByVal widget As GtkWidget Ptr, ByVal events As gint)
End Sub

Private Sub gtk_widget_add_events(ByVal widget As GtkWidget Ptr, ByVal events As gint)
End Sub

Private Sub gtk_widget_set_app_paintable(ByVal widget As GtkWidget Ptr, ByVal app_paintable As gboolean)
End Sub

Private Sub gtk_widget_set_can_default(ByVal widget As GtkWidget Ptr, ByVal can_default As gboolean)
End Sub

Private Sub gtk_widget_set_double_buffered(ByVal widget As GtkWidget Ptr, ByVal double_buffered As gboolean)
End Sub

Private Function gtk_widget_is_toplevel(ByVal widget As GtkWidget Ptr) As gboolean
	Return widget <> 0 AndAlso GTK_IS_WINDOW(widget)
End Function

Private Function gtk_widget_get_toplevel(ByVal widget As GtkWidget Ptr) As GtkWidget Ptr
	If widget = 0 Then Return 0
	Dim As GtkRoot Ptr root = gtk_widget_get_root(widget)
	If root Then Return GTK_WIDGET(root)
	Return widget
End Function

Private Function gtk_widget_get_window(ByVal widget As GtkWidget Ptr) As GdkSurface Ptr
	If widget = 0 Then Return 0
	Dim As GtkNative Ptr native = gtk_widget_get_native(widget)
	If native = 0 Then Return 0
	Return gtk_native_get_surface(native)
End Function

Private Function gtk_widget_get_parent_window(ByVal widget As GtkWidget Ptr) As GdkSurface Ptr
	If widget = 0 Then Return 0
	Return gtk_widget_get_window(gtk_widget_get_parent(widget))
End Function

Private Function gtk_widget_get_screen(ByVal widget As GtkWidget Ptr) As GdkDisplay Ptr
	If widget Then Return gtk_widget_get_display(widget)
	Return gdk_display_get_default()
End Function

' Replaces gtk_widget_override_font: the font is set with a CSS provider of the widget.
' The font properties are inherited, the inner widgets (e.g. the label of a button) get the font too
Private Sub gtk4compat_widget_set_font(ByVal widget As GtkWidget Ptr, ByVal pfd As PangoFontDescription Ptr)
	If widget = 0 OrElse pfd = 0 Then Exit Sub
	Dim As GtkCssProvider Ptr provider = g_object_get_data(G_OBJECT(widget), "mff-font-provider")
	If provider = 0 Then
		provider = gtk_css_provider_new()
		gtk_style_context_add_provider(gtk_widget_get_style_context(widget), GTK_STYLE_PROVIDER(provider), GTK_STYLE_PROVIDER_PRIORITY_APPLICATION)
		g_object_set_data_full(G_OBJECT(widget), "mff-font-provider", provider, Cast(GDestroyNotify, @g_object_unref))
	End If
	Dim As String css = "* {"
	Dim As Const gchar Ptr family = pango_font_description_get_family(pfd)
	If family <> 0 AndAlso *family <> "" Then css &= " font-family: """ & *family & """;"
	Dim As gint iSize = pango_font_description_get_size(pfd)
	If iSize > 0 Then css &= " font-size: " & Str(iSize / PANGO_SCALE) & IIf(pango_font_description_get_size_is_absolute(pfd), "px", "pt") & ";"
	css &= " font-weight: " & Str(CInt(pango_font_description_get_weight(pfd))) & ";"
	css &= " font-style: " & IIf(pango_font_description_get_style(pfd) = PANGO_STYLE_ITALIC, "italic", IIf(pango_font_description_get_style(pfd) = PANGO_STYLE_OBLIQUE, "oblique", "normal")) & "; }"
	gtk4compat_css_provider_load_from_string(provider, StrPtr(css))
End Sub

' Like GTK3: windows are destroyed, other widgets are removed from their parent
Private Sub gtk_widget_destroy(ByVal widget As GtkWidget Ptr)
	If widget = 0 Then Exit Sub
	If GTK_IS_WINDOW(widget) Then
		gtk_window_destroy(GTK_WINDOW(widget))
	ElseIf GTK_IS_POPOVER(widget) AndAlso gtk_widget_get_parent(widget) <> 0 Then
		gtk_widget_unparent(widget)
	ElseIf gtk_widget_get_parent(widget) Then
		gtk_container_remove(gtk_widget_get_parent(widget), widget)
	ElseIf g_object_is_floating(widget) Then
		' A widget which was never added to a container
		g_object_ref_sink(widget)
		g_object_unref(widget)
	End If
End Sub

Private Sub gtk_widget_set_size_request_compat(ByVal widget As GtkWidget Ptr, ByVal iWidth As gint, ByVal iHeight As gint)
	gtk_widget_set_size_request(widget, iWidth, iHeight)
End Sub

Private Sub gtk_misc_set_alignment(ByVal misc As GtkWidget Ptr, ByVal xalign As gfloat, ByVal yalign As gfloat)
	If misc = 0 Then Exit Sub
	If GTK_IS_LABEL(misc) Then
		gtk_label_set_xalign(GTK_LABEL(misc), xalign)
		gtk_label_set_yalign(GTK_LABEL(misc), yalign)
	Else
		gtk_widget_set_halign(misc, IIf(xalign < 0.25, GTK_ALIGN_START, IIf(xalign > 0.75, GTK_ALIGN_END, GTK_ALIGN_CENTER)))
		gtk_widget_set_valign(misc, IIf(yalign < 0.25, GTK_ALIGN_START, IIf(yalign > 0.75, GTK_ALIGN_END, GTK_ALIGN_CENTER)))
	End If
End Sub

Private Sub gtk_misc_set_padding(ByVal misc As GtkWidget Ptr, ByVal xpad As gint, ByVal ypad As gint)
	If misc = 0 Then Exit Sub
	gtk_widget_set_margin_start(misc, xpad): gtk_widget_set_margin_end(misc, xpad)
	gtk_widget_set_margin_top(misc, ypad): gtk_widget_set_margin_bottom(misc, ypad)
End Sub

Private Sub gtk_label_set_line_wrap(ByVal label As GtkLabel Ptr, ByVal wrap As gboolean)
	gtk_label_set_wrap(label, wrap)
End Sub

Private Sub gtk_label_set_line_wrap_mode(ByVal label As GtkLabel Ptr, ByVal wrap_mode As PangoWrapMode)
	gtk_label_set_wrap_mode(label, wrap_mode)
End Sub

Private Sub gtk_button_set_alignment(ByVal button As GtkButton Ptr, ByVal xalign As gfloat, ByVal yalign As gfloat)
	If button = 0 Then Exit Sub
	Dim As GtkWidget Ptr child = gtk_button_get_child(button)
	If child Then gtk_misc_set_alignment(child, xalign, yalign)
End Sub

Private Sub gtk_scrolled_window_set_shadow_type(ByVal scrolled_window As GtkScrolledWindow Ptr, ByVal ShadowType As GtkShadowType)
	gtk_scrolled_window_set_has_frame(scrolled_window, ShadowType <> GTK_SHADOW_NONE)
End Sub

Private Sub gtk_scrolled_window_add_with_viewport(ByVal scrolled_window As GtkScrolledWindow Ptr, ByVal child As GtkWidget Ptr)
	gtk_scrolled_window_set_child(scrolled_window, child)
End Sub

Private Function gtk_tree_view_get_hadjustment(ByVal tree_view As GtkTreeView Ptr) As GtkAdjustment Ptr
	Return gtk_scrollable_get_hadjustment(GTK_SCROLLABLE(tree_view))
End Function

Private Function gtk_tree_view_get_vadjustment(ByVal tree_view As GtkTreeView Ptr) As GtkAdjustment Ptr
	Return gtk_scrollable_get_vadjustment(GTK_SCROLLABLE(tree_view))
End Function

Private Function gtk_layout_get_hadjustment(ByVal layout As GtkFixed Ptr) As GtkAdjustment Ptr
	Dim As GtkWidget Ptr parent = gtk_widget_get_parent(GTK_WIDGET(layout))
	If GTK_IS_VIEWPORT(parent) Then parent = gtk_widget_get_parent(parent)
	If GTK_IS_SCROLLED_WINDOW(parent) Then Return gtk_scrolled_window_get_hadjustment(GTK_SCROLLED_WINDOW(parent))
	Return 0
End Function

Private Function gtk_layout_get_vadjustment(ByVal layout As GtkFixed Ptr) As GtkAdjustment Ptr
	Dim As GtkWidget Ptr parent = gtk_widget_get_parent(GTK_WIDGET(layout))
	If GTK_IS_VIEWPORT(parent) Then parent = gtk_widget_get_parent(parent)
	If GTK_IS_SCROLLED_WINDOW(parent) Then Return gtk_scrolled_window_get_vadjustment(GTK_SCROLLED_WINDOW(parent))
	Return 0
End Function

Private Sub gtk_text_view_move_child(ByVal text_view As GtkTextView Ptr, ByVal child As GtkWidget Ptr, ByVal xpos As gint, ByVal ypos As gint)
	gtk_text_view_move_overlay(text_view, child, xpos, ypos)
End Sub

Private Sub gtk_text_view_add_child_in_window(ByVal text_view As GtkTextView Ptr, ByVal child As GtkWidget Ptr, ByVal which_window As gint, ByVal xpos As gint, ByVal ypos As gint)
	gtk_text_view_add_overlay(text_view, child, xpos, ypos)
End Sub

' Entries: the text belongs to GtkEditable
Private Sub gtk_entry_set_text(ByVal entry As GtkEntry Ptr, ByVal text As Const gchar Ptr)
	gtk_editable_set_text(GTK_EDITABLE(entry), IIf(text, text, @""))
End Sub

Private Function gtk_entry_get_text(ByVal entry As GtkEntry Ptr) As Const gchar Ptr
	Return gtk_editable_get_text(GTK_EDITABLE(entry))
End Function

Private Sub gtk_entry_set_width_chars(ByVal entry As GtkEntry Ptr, ByVal n_chars As gint)
	gtk_editable_set_width_chars(GTK_EDITABLE(entry), n_chars)
End Sub

Private Sub gtk_entry_set_max_width_chars(ByVal entry As GtkEntry Ptr, ByVal n_chars As gint)
	gtk_editable_set_max_width_chars(GTK_EDITABLE(entry), n_chars)
End Sub

Private Sub gtk_entry_set_editable(ByVal entry As GtkEntry Ptr, ByVal is_editable As gboolean)
	gtk_editable_set_editable(GTK_EDITABLE(entry), is_editable)
End Sub

Private Sub gtk_entry_set_alignment(ByVal entry As GtkEntry Ptr, ByVal xalign As gfloat)
	gtk_editable_set_alignment(GTK_EDITABLE(entry), xalign)
End Sub

Private Sub gtk_editable_copy_clipboard(ByVal editable As GtkEditable Ptr)
	gtk_widget_activate_action(GTK_WIDGET(editable), "clipboard.copy", NULL)
End Sub

Private Sub gtk_editable_cut_clipboard(ByVal editable As GtkEditable Ptr)
	gtk_widget_activate_action(GTK_WIDGET(editable), "clipboard.cut", NULL)
End Sub

Private Sub gtk_editable_paste_clipboard(ByVal editable As GtkEditable Ptr)
	gtk_widget_activate_action(GTK_WIDGET(editable), "clipboard.paste", NULL)
End Sub

Private Sub gtk_editable_delete_selection_compat(ByVal editable As GtkEditable Ptr)
	gtk_editable_delete_selection(editable)
End Sub

Private Sub gtk_entry_set_icon_from_pixbuf(ByVal entry As GtkEntry Ptr, ByVal icon_pos As GtkEntryIconPosition, ByVal pixbuf As GdkPixbuf Ptr)
	g_object_set_data_full(G_OBJECT(entry), IIf(icon_pos = GTK_ENTRY_ICON_PRIMARY, @"mff-icon-pixbuf-0", @"mff-icon-pixbuf-1"), IIf(pixbuf, g_object_ref(pixbuf), NULL), Cast(GDestroyNotify, @g_object_unref))
	If pixbuf Then
		Dim As GdkTexture Ptr texture = gdk_texture_new_for_pixbuf(pixbuf)
		gtk_entry_set_icon_from_paintable(entry, icon_pos, GDK_PAINTABLE(texture))
		g_object_unref(texture)
	Else
		gtk_entry_set_icon_from_paintable(entry, icon_pos, NULL)
	End If
End Sub

Private Function gtk_entry_get_icon_pixbuf(ByVal entry As GtkEntry Ptr, ByVal icon_pos As GtkEntryIconPosition) As GdkPixbuf Ptr
	Return g_object_get_data(G_OBJECT(entry), IIf(icon_pos = GTK_ENTRY_ICON_PRIMARY, @"mff-icon-pixbuf-0", @"mff-icon-pixbuf-1"))
End Function

Private Function gtk_image_new_from_icon_name_compat(ByVal icon_name As Const gchar Ptr, ByVal size As gint = 0) As GtkWidget Ptr
	Dim As GtkWidget Ptr img = gtk_image_new_from_icon_name(icon_name)
	If size > 0 Then gtk_image_set_pixel_size(GTK_IMAGE(img), size)
	Return img
End Function

Private Sub gtk_widget_set_margin_left(ByVal widget As GtkWidget Ptr, ByVal margin As gint)
	gtk_widget_set_margin_start(widget, margin)
End Sub

Private Sub gtk_widget_set_margin_right(ByVal widget As GtkWidget Ptr, ByVal margin As gint)
	gtk_widget_set_margin_end(widget, margin)
End Sub

Private Function gtk_widget_get_margin_left(ByVal widget As GtkWidget Ptr) As gint
	Return gtk_widget_get_margin_start(widget)
End Function

Private Function gtk_widget_get_margin_right(ByVal widget As GtkWidget Ptr) As gint
	Return gtk_widget_get_margin_end(widget)
End Function

' Header bars show a title widget in GTK4
Private Sub gtk_header_bar_set_title(ByVal bar As GtkHeaderBar Ptr, ByVal title As Const gchar Ptr)
	If bar = 0 Then Exit Sub
	Dim As GtkWidget Ptr lbl = gtk_header_bar_get_title_widget(bar)
	If lbl = 0 OrElse GTK_IS_LABEL(lbl) = 0 Then
		lbl = gtk_label_new(title)
		gtk_widget_add_css_class(lbl, "title")
		gtk_header_bar_set_title_widget(bar, lbl)
	Else
		gtk_label_set_text(GTK_LABEL(lbl), title)
	End If
End Sub

Private Sub gtk_header_bar_set_subtitle(ByVal bar As GtkHeaderBar Ptr, ByVal subtitle As Const gchar Ptr)
End Sub

Private Sub gtk_header_bar_set_has_subtitle(ByVal bar As GtkHeaderBar Ptr, ByVal setting As gboolean)
End Sub

Private Sub gtk_header_bar_set_show_close_button(ByVal bar As GtkHeaderBar Ptr, ByVal setting As gboolean)
	gtk_header_bar_set_show_title_buttons(bar, setting)
End Sub

' Copies the pixbuf into a cairo image surface
Private Function gdk_cairo_surface_create_from_pixbuf(ByVal pixbuf As Const GdkPixbuf Ptr, ByVal scale As gint, ByVal for_window As GdkSurface Ptr) As cairo_surface_t Ptr
	If pixbuf = 0 Then Return 0
	Dim As cairo_surface_t Ptr surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, gdk_pixbuf_get_width(pixbuf), gdk_pixbuf_get_height(pixbuf))
	Dim As cairo_t Ptr cr = cairo_create(surface)
	gdk_cairo_set_source_pixbuf(cr, pixbuf, 0, 0)
	cairo_paint(cr)
	cairo_destroy(cr)
	If scale > 1 Then cairo_surface_set_device_scale(surface, scale, scale)
	Return surface
End Function

' -----------------------------------------------------------------------------
' Popovers
' -----------------------------------------------------------------------------
' WSLg (weston RDP RAIL) does not show a popover again if its Wayland surface is reused.
' WSLg keeps the window of a hidden popup on the screen and does not show a reused surface: the closed
' popovers are unrealized. Not at once: the window of the closed popup is still the active window of
' Windows, when it is destroyed Windows activates the window below it (e.g. a terminal). They are
' unrealized after the next popover was shown. They wait in an array of the display
Private Function gtk4compat_stale_popovers() As GPtrArray Ptr
	Dim As GdkDisplay Ptr display = gdk_display_get_default()
	If display = 0 Then Return 0
	Dim As GPtrArray Ptr arr = g_object_get_data(G_OBJECT(display), "mff-stale-popovers")
	If arr = 0 Then
		arr = g_ptr_array_new_with_free_func(Cast(GDestroyNotify, @g_object_unref))
		g_object_set_data_full(G_OBJECT(display), "mff-stale-popovers", arr, Cast(GDestroyNotify, @g_ptr_array_unref))
	End If
	Return arr
End Function

' Nested submenus stay visible when their menu is closed and are shown again with it
Private Sub gtk4compat_popdown_children(ByVal widget As GtkWidget Ptr)
	Dim As GtkWidget Ptr child = gtk_widget_get_first_child(widget)
	While child
		If GTK_IS_POPOVER(child) AndAlso gtk_widget_get_visible(child) Then gtk_popover_popdown(GTK_POPOVER(child))
		gtk4compat_popdown_children child
		child = gtk_widget_get_next_sibling(child)
	Wend
End Sub

Private Function gtk4compat_popover_closed_idle CDecl(ByVal user_data As gpointer) As gboolean
	Dim As GtkWidget Ptr popover = user_data
	If gtk_widget_get_visible(popover) = 0 Then gtk4compat_popdown_children popover
	Return False
End Function

' The closed popovers are unrealized (Shown: the popover which was shown, it is not unrealized)
Private Function gtk4compat_popover_unrealize_stale CDecl(ByVal user_data As gpointer) As gboolean
	Dim As GtkWidget Ptr Shown = user_data
	Dim As GPtrArray Ptr arr = gtk4compat_stale_popovers()
	If arr = 0 Then Return False
	Dim As Integer i
	While i < arr->len
		Dim As GtkWidget Ptr popover = arr->pdata[i]
		If popover <> Shown AndAlso gtk_widget_get_visible(popover) = 0 AndAlso gtk_widget_get_realized(popover) Then gtk_widget_unrealize(popover)
		g_ptr_array_remove_index(arr, i)
	Wend
	Return False
End Function

Private Function gtk4compat_popover_closed_hook CDecl(ByVal ihint As GSignalInvocationHint Ptr, ByVal n_param_values As guint, ByVal param_values As Const GValue Ptr, ByVal user_data As gpointer) As gboolean
	If n_param_values > 0 Then
		Dim As GObject Ptr obj = g_value_get_object(@param_values[0])
		If obj AndAlso GTK_IS_POPOVER(obj) Then
			Dim As GPtrArray Ptr arr = gtk4compat_stale_popovers()
			If arr Then
				Dim As Boolean bFound
				For i As Integer = 0 To CInt(arr->len) - 1
					If arr->pdata[i] = obj Then bFound = True: Exit For
				Next
				If Not bFound Then g_ptr_array_add(arr, g_object_ref(obj))
			End If
			g_idle_add_full(G_PRIORITY_HIGH, Cast(GSourceFunc, @gtk4compat_popover_closed_idle), g_object_ref(obj), Cast(GDestroyNotify, @g_object_unref))
		End If
	End If
	Return True
End Function

' A popover shown again before it was unrealized keeps its surface (closed and opened by the same item).
' The other closed popovers are unrealized a moment after a popover was mapped, when Windows
' activated its window
Private Function gtk4compat_popover_map_hook CDecl(ByVal ihint As GSignalInvocationHint Ptr, ByVal n_param_values As guint, ByVal param_values As Const GValue Ptr, ByVal user_data As gpointer) As gboolean
	If n_param_values > 0 Then
		Dim As GObject Ptr obj = g_value_get_object(@param_values[0])
		If obj AndAlso GTK_IS_POPOVER(obj) Then g_timeout_add_full(G_PRIORITY_HIGH, 100, Cast(GSourceFunc, @gtk4compat_popover_unrealize_stale), g_object_ref(obj), Cast(GDestroyNotify, @g_object_unref))
	End If
	Return True
End Function

' Called after gtk_init. The IDE and the library include this file, the hook is installed once
Private Sub gtk4compat_install_popover_hook()
	Dim As GdkDisplay Ptr display = gdk_display_get_default()
	If display = 0 OrElse g_object_get_data(G_OBJECT(display), "mff-popover-hook") <> 0 Then Exit Sub
	g_object_set_data(G_OBJECT(display), "mff-popover-hook", Cast(gpointer, 1))
	' The signals of the class are created when the class is initialized
	g_type_class_ref(GTK_TYPE_POPOVER)
	g_signal_add_emission_hook(g_signal_lookup("closed", GTK_TYPE_POPOVER), 0, Cast(GSignalEmissionHook, @gtk4compat_popover_closed_hook), NULL, NULL)
	g_signal_add_emission_hook(g_signal_lookup("map", GTK_TYPE_WIDGET), 0, Cast(GSignalEmissionHook, @gtk4compat_popover_map_hook), NULL, NULL)
End Sub

' -----------------------------------------------------------------------------
' Windows
' -----------------------------------------------------------------------------
' Popup windows (GTK_WINDOW_POPUP) are popovers without autohide in GTK4.
' Set their parent with gtk_widget_set_parent, the positions are relative to the parent
Const GTK_WINDOW_TOPLEVEL = 0
Const GTK_WINDOW_POPUP = 1

Private Function gtk4compat_window_new(ByVal type_ As gint) As GtkWidget Ptr
	If type_ = GTK_WINDOW_POPUP Then
		Dim As GtkWidget Ptr popup = gtk_popover_new()
		gtk_popover_set_has_arrow(GTK_POPOVER(popup), False)
		gtk_popover_set_autohide(GTK_POPOVER(popup), False)
		gtk_popover_set_position(GTK_POPOVER(popup), GTK_POS_BOTTOM)
		gtk_widget_set_halign(popup, GTK_ALIGN_START)
		gtk_widget_add_css_class(popup, "mff-popup")
		' Lives also without a parent
		g_object_ref_sink(popup)
		Return popup
	End If
	Return gtk_window_new()
End Function

' Toplevel positions are under control of the window manager in GTK4
Private Sub gtk_window_move(ByVal window_ As GtkWindow Ptr, ByVal x As gint, ByVal y As gint)
	If window_ AndAlso GTK_IS_POPOVER(window_) Then
		Dim As GdkRectangle r
		r.x = x: r.y = y: r.width = 1: r.height = 1
		gtk_popover_set_pointing_to(GTK_POPOVER(window_), @r)
	End If
End Sub

Private Sub gdk_window_get_origin(ByVal window_ As GdkSurface Ptr, ByVal x As gint Ptr, ByVal y As gint Ptr)
	If x Then *x = 0
	If y Then *y = 0
End Sub

Private Function gdk_threads_add_timeout(ByVal interval As guint, ByVal func As GSourceFunc, ByVal data_ As gpointer) As guint
	Return g_timeout_add(interval, func, data_)
End Function

Private Function gdk_threads_add_idle(ByVal func As GSourceFunc, ByVal data_ As gpointer) As guint
	Return g_idle_add(func, data_)
End Function

' The message area of status bars was removed, the status bar is used
Private Function gtk_statusbar_get_message_area(ByVal statusbar As GtkStatusbar Ptr) As GtkWidget Ptr
	Return GTK_WIDGET(statusbar)
End Function

Private Sub gtk_window_get_position(ByVal window_ As GtkWindow Ptr, ByVal root_x As gint Ptr, ByVal root_y As gint Ptr)
	If root_x Then *root_x = 0
	If root_y Then *root_y = 0
End Sub

Private Sub gtk_window_set_position(ByVal window_ As GtkWindow Ptr, ByVal position As GtkWindowPosition)
End Sub

Private Sub gtk_window_resize(ByVal window_ As GtkWindow Ptr, ByVal iWidth As gint, ByVal iHeight As gint)
	If window_ AndAlso GTK_IS_POPOVER(window_) Then gtk_widget_set_size_request(GTK_WIDGET(window_), iWidth, iHeight): Exit Sub
	gtk_window_set_default_size(window_, IIf(iWidth < 1, 1, iWidth), IIf(iHeight < 1, 1, iHeight))
End Sub

Private Sub gtk_window_get_size(ByVal window_ As GtkWindow Ptr, ByVal iWidth As gint Ptr, ByVal iHeight As gint Ptr)
	Dim As gint w, h
	If window_ AndAlso GTK_IS_POPOVER(window_) Then
		If iWidth Then *iWidth = gtk_widget_get_width(GTK_WIDGET(window_))
		If iHeight Then *iHeight = gtk_widget_get_height(GTK_WIDGET(window_))
		Exit Sub
	End If
	If gtk_widget_get_realized(GTK_WIDGET(window_)) Then
		w = gtk_widget_get_width(GTK_WIDGET(window_))
		h = gtk_widget_get_height(GTK_WIDGET(window_))
	End If
	If w <= 0 OrElse h <= 0 Then gtk_window_get_default_size(window_, @w, @h)
	If iWidth Then *iWidth = w
	If iHeight Then *iHeight = h
End Sub

Private Sub gtk_window_set_type_hint(ByVal window_ As GtkWindow Ptr, ByVal hint As GdkWindowTypeHint)
End Sub

Private Sub gtk_window_set_keep_above(ByVal window_ As GtkWindow Ptr, ByVal setting As gboolean)
End Sub

Private Sub gtk_window_set_keep_below(ByVal window_ As GtkWindow Ptr, ByVal setting As gboolean)
End Sub

Private Sub gtk_window_set_skip_taskbar_hint(ByVal window_ As GtkWindow Ptr, ByVal setting As gboolean)
End Sub

Private Sub gtk_window_set_skip_pager_hint(ByVal window_ As GtkWindow Ptr, ByVal setting As gboolean)
End Sub

Private Sub gtk_window_set_opacity(ByVal window_ As GtkWindow Ptr, ByVal opacity As gdouble)
	gtk_widget_set_opacity(GTK_WIDGET(window_), opacity)
End Sub

Private Sub gtk_window_iconify(ByVal window_ As GtkWindow Ptr)
	gtk_window_minimize(window_)
End Sub

Private Sub gtk_window_deiconify(ByVal window_ As GtkWindow Ptr)
	gtk_window_unminimize(window_)
End Sub

Private Sub gtk_window_set_default(ByVal window_ As GtkWindow Ptr, ByVal default_widget As GtkWidget Ptr)
	gtk_window_set_default_widget(window_, default_widget)
End Sub

Private Sub gtk_window_set_icon(ByVal window_ As GtkWindow Ptr, ByVal icon As GdkPixbuf Ptr)
End Sub

Private Sub gtk_window_set_icon_list(ByVal window_ As GtkWindow Ptr, ByVal lst As GList Ptr)
End Sub

Private Function gtk_window_set_icon_from_file(ByVal window_ As GtkWindow Ptr, ByVal filename As Const gchar Ptr, ByVal error_ As GError Ptr Ptr) As gboolean
	Return False
End Function

Private Sub gtk_window_set_geometry_hints(ByVal window_ As GtkWindow Ptr, ByVal geometry_widget As GtkWidget Ptr, ByVal geometry As GdkGeometry Ptr, ByVal geom_mask As GdkWindowHints)
	If window_ = 0 OrElse geometry = 0 Then Exit Sub
	If geom_mask And GDK_HINT_MIN_SIZE Then
		gtk_widget_set_size_request(GTK_WIDGET(window_), IIf(geometry->min_width < -1, -1, geometry->min_width), IIf(geometry->min_height < -1, -1, geometry->min_height))
	End If
	If (geom_mask And GDK_HINT_MIN_SIZE) AndAlso (geom_mask And GDK_HINT_MAX_SIZE) Then
		If geometry->min_width = geometry->max_width AndAlso geometry->min_height = geometry->max_height Then
			gtk_window_set_resizable(window_, False)
		End If
	End If
End Sub

Private Sub gtk_window_add_accel_group(ByVal window_ As GtkWindow Ptr, ByVal accel_group As GtkEventController Ptr)
	If window_ = 0 OrElse accel_group = 0 Then Exit Sub
	If gtk_event_controller_get_widget(accel_group) = 0 Then gtk_widget_add_controller(GTK_WIDGET(window_), accel_group)
End Sub

Private Sub gtk_window_remove_accel_group(ByVal window_ As GtkWindow Ptr, ByVal accel_group As GtkEventController Ptr)
	If window_ = 0 OrElse accel_group = 0 Then Exit Sub
	If gtk_event_controller_get_widget(accel_group) = GTK_WIDGET(window_) Then
		g_object_ref(accel_group)
		gtk_widget_remove_controller(GTK_WIDGET(window_), accel_group)
	End If
End Sub

' Accelerators are implemented with a global shortcut controller
Private Function gtk_accel_group_new() As GtkEventController Ptr
	Dim As GtkEventController Ptr controller = gtk_shortcut_controller_new()
	gtk_shortcut_controller_set_scope(GTK_SHORTCUT_CONTROLLER(controller), GTK_SHORTCUT_SCOPE_GLOBAL)
	' The controller can be added to a window later
	g_object_ref_sink(controller)
	Return controller
End Function

Private Function gtk4compat_accel_activate CDecl(ByVal widget As GtkWidget Ptr, ByVal args As GVariant Ptr, ByVal user_data As gpointer) As gboolean
	Dim As gchar Ptr sig = g_object_get_data(G_OBJECT(user_data), "mff-accel-signal")
	If sig = 0 Then Return False
	If GTK_IS_WIDGET(user_data) AndAlso gtk_widget_is_sensitive(GTK_WIDGET(user_data)) = False Then Return False
	g_signal_emit_by_name(user_data, sig)
	Return True
End Function

Private Sub gtk_widget_add_accelerator(ByVal widget As GtkWidget Ptr, ByVal accel_signal As Const gchar Ptr, ByVal accel_group As GtkEventController Ptr, ByVal accel_key As guint, ByVal accel_mods As GdkModifierType, ByVal accel_flags As gint)
	If widget = 0 OrElse accel_group = 0 OrElse accel_key = 0 Then Exit Sub
	g_object_set_data_full(G_OBJECT(widget), "mff-accel-signal", g_strdup(accel_signal), Cast(GDestroyNotify, @g_free))
	' One accelerator per widget
	Dim As GtkShortcut Ptr OldShortcut = g_object_get_data(G_OBJECT(widget), "mff-accel-shortcut")
	Dim As GtkEventController Ptr OldGroup = g_object_get_data(G_OBJECT(widget), "mff-accel-group")
	If OldShortcut AndAlso OldGroup Then gtk_shortcut_controller_remove_shortcut(GTK_SHORTCUT_CONTROLLER(OldGroup), OldShortcut)
	g_object_set_data(G_OBJECT(widget), "mff-accel-group", accel_group)
	Dim As GtkShortcut Ptr shortcut = gtk_shortcut_new(gtk_keyval_trigger_new(accel_key, accel_mods), gtk_callback_action_new(@gtk4compat_accel_activate, widget, NULL))
	g_object_set_data(G_OBJECT(widget), "mff-accel-shortcut", shortcut)
	gtk_shortcut_controller_add_shortcut(GTK_SHORTCUT_CONTROLLER(accel_group), shortcut)
End Sub

Private Function gtk_widget_remove_accelerator(ByVal widget As GtkWidget Ptr, ByVal accel_group As GtkEventController Ptr, ByVal accel_key As guint, ByVal accel_mods As GdkModifierType) As gboolean
	If widget = 0 OrElse accel_group = 0 Then Return False
	Dim As GtkShortcut Ptr shortcut = g_object_get_data(G_OBJECT(widget), "mff-accel-shortcut")
	If shortcut = 0 Then Return False
	gtk_shortcut_controller_remove_shortcut(GTK_SHORTCUT_CONTROLLER(accel_group), shortcut)
	g_object_set_data(G_OBJECT(widget), "mff-accel-shortcut", NULL)
	Return True
End Function

' -----------------------------------------------------------------------------
' Dialogs: gtk_dialog_run with a nested main loop
' -----------------------------------------------------------------------------
Type Gtk4CompatRunInfo
	loop_ As GMainLoop Ptr
	response_id As gint
	destroyed As Boolean
End Type

Private Sub gtk4compat_run_response CDecl(ByVal dialog As gpointer, ByVal response_id As gint, ByVal user_data As gpointer)
	Dim As Gtk4CompatRunInfo Ptr ri = user_data
	ri->response_id = response_id
	If g_main_loop_is_running(ri->loop_) Then g_main_loop_quit(ri->loop_)
End Sub

Private Function gtk4compat_run_close_request CDecl(ByVal window_ As GtkWindow Ptr, ByVal user_data As gpointer) As gboolean
	Dim As Gtk4CompatRunInfo Ptr ri = user_data
	ri->response_id = GTK_RESPONSE_DELETE_EVENT
	If g_main_loop_is_running(ri->loop_) Then g_main_loop_quit(ri->loop_)
	Return True
End Function

Private Sub gtk4compat_run_destroy CDecl(ByVal widget As GtkWidget Ptr, ByVal user_data As gpointer)
	Dim As Gtk4CompatRunInfo Ptr ri = user_data
	ri->destroyed = True
	If g_main_loop_is_running(ri->loop_) Then g_main_loop_quit(ri->loop_)
End Sub

Private Function gtk_dialog_run(ByVal dialog As GtkDialog Ptr) As gint
	If dialog = 0 Then Return GTK_RESPONSE_NONE
	Dim As Gtk4CompatRunInfo ri
	ri.response_id = GTK_RESPONSE_NONE
	ri.loop_ = g_main_loop_new(NULL, False)
	g_object_ref(dialog)
	gtk_window_set_modal(GTK_WINDOW(dialog), True)
	Dim As gulong h1 = g_signal_connect(dialog, "response", G_CALLBACK(@gtk4compat_run_response), @ri)
	Dim As gulong h2 = g_signal_connect(dialog, "close-request", G_CALLBACK(@gtk4compat_run_close_request), @ri)
	Dim As gulong h3 = g_signal_connect(dialog, "destroy", G_CALLBACK(@gtk4compat_run_destroy), @ri)
	gtk_window_present(GTK_WINDOW(dialog))
	Dim As Gtk4CompatLoops Ptr p = gtk4compat_loops()
	If p->Depth <= UBound(p->Loops) Then p->Loops(p->Depth) = ri.loop_
	p->Depth += 1
	g_main_loop_run(ri.loop_)
	p->Depth -= 1
	If p->Depth <= UBound(p->Loops) Then p->Loops(p->Depth) = 0
	If Not ri.destroyed Then
		g_signal_handler_disconnect(dialog, h1)
		g_signal_handler_disconnect(dialog, h2)
		g_signal_handler_disconnect(dialog, h3)
		' Like GTK3: the caller hides or destroys the dialog
		gtk_widget_set_visible(GTK_WIDGET(dialog), False)
	End If
	g_main_loop_unref(ri.loop_)
	g_object_unref(dialog)
	Return ri.response_id
End Function

' The same for GtkNativeDialog (e.g. GtkFileChooserNative)
Private Function gtk_native_dialog_run(ByVal dialog As GtkNativeDialog Ptr) As gint
	If dialog = 0 Then Return GTK_RESPONSE_NONE
	Dim As Gtk4CompatRunInfo ri
	ri.response_id = GTK_RESPONSE_NONE
	ri.loop_ = g_main_loop_new(NULL, False)
	g_object_ref(dialog)
	gtk_native_dialog_set_modal(dialog, True)
	Dim As gulong h1 = g_signal_connect(dialog, "response", G_CALLBACK(@gtk4compat_run_response), @ri)
	gtk_native_dialog_show(dialog)
	Dim As Gtk4CompatLoops Ptr p = gtk4compat_loops()
	If p->Depth <= UBound(p->Loops) Then p->Loops(p->Depth) = ri.loop_
	p->Depth += 1
	g_main_loop_run(ri.loop_)
	p->Depth -= 1
	If p->Depth <= UBound(p->Loops) Then p->Loops(p->Depth) = 0
	g_signal_handler_disconnect(dialog, h1)
	g_main_loop_unref(ri.loop_)
	g_object_unref(dialog)
	Return ri.response_id
End Function

' File chooser: GFile based in GTK4, the filenames are newly allocated (free with g_free)
Private Function gtk_file_chooser_get_filename(ByVal chooser As GtkFileChooser Ptr) As gchar Ptr
	Dim As GFile Ptr file = gtk_file_chooser_get_file(chooser)
	If file = 0 Then Return NULL
	Dim As gchar Ptr path = g_file_get_path(file)
	g_object_unref(file)
	Return path
End Function

Private Function gtk_file_chooser_set_filename(ByVal chooser As GtkFileChooser Ptr, ByVal filename As Const gchar Ptr) As gboolean
	If filename = 0 Then Return False
	Dim As GFile Ptr file = g_file_new_for_path(filename)
	Dim As gboolean Result = gtk_file_chooser_set_file(chooser, file, NULL)
	g_object_unref(file)
	Return Result
End Function

Private Function gtk_file_chooser_get_filenames(ByVal chooser As GtkFileChooser Ptr) As GSList Ptr
	Dim As GSList Ptr lst = NULL
	Dim As GListModel Ptr files = gtk_file_chooser_get_files(chooser)
	If files = 0 Then Return NULL
	For i As guint = 0 To g_list_model_get_n_items(files) - 1
		Dim As GFile Ptr file = g_list_model_get_item(files, i)
		If file Then
			lst = g_slist_append(lst, g_file_get_path(file))
			g_object_unref(file)
		End If
	Next
	g_object_unref(files)
	Return lst
End Function

Private Function gtk_file_chooser_set_current_folder_path(ByVal chooser As GtkFileChooser Ptr, ByVal folder As Const gchar Ptr) As gboolean
	If folder = 0 OrElse *folder = "" Then Return False
	Dim As GFile Ptr file = g_file_new_for_path(folder)
	Dim As gboolean Result = gtk_file_chooser_set_current_folder(chooser, file, NULL)
	g_object_unref(file)
	Return Result
End Function

Private Function gtk_file_chooser_get_current_folder_path(ByVal chooser As GtkFileChooser Ptr) As gchar Ptr
	Dim As GFile Ptr file = gtk_file_chooser_get_current_folder(chooser)
	If file = 0 Then Return NULL
	Dim As gchar Ptr path = g_file_get_path(file)
	g_object_unref(file)
	Return path
End Function

' -----------------------------------------------------------------------------
' Clipboard
' -----------------------------------------------------------------------------
Private Function gtk_clipboard_get(ByVal selection As GdkAtom) As GdkClipboard Ptr
	If selection = GDK_SELECTION_PRIMARY Then Return gdk_display_get_primary_clipboard(gdk_display_get_default())
	Return gdk_display_get_clipboard(gdk_display_get_default())
End Function

Private Function gtk_clipboard_get_default(ByVal display As GdkDisplay Ptr) As GdkClipboard Ptr
	Return gdk_display_get_clipboard(IIf(display, display, gdk_display_get_default()))
End Function

Private Function gtk_widget_get_clipboard_compat(ByVal widget As GtkWidget Ptr, ByVal selection As GdkAtom) As GdkClipboard Ptr
	If selection = GDK_SELECTION_PRIMARY Then Return gtk_widget_get_primary_clipboard(widget)
	Return gtk_widget_get_clipboard(widget)
End Function

Private Sub gtk_clipboard_set_text(ByVal clipboard As GdkClipboard Ptr, ByVal text As Const gchar Ptr, ByVal length As gint = -1)
	If clipboard = 0 Then Exit Sub
	If length >= 0 Then
		Dim As gchar Ptr s = g_strndup(text, length)
		gdk_clipboard_set_text(clipboard, s)
		g_free(s)
	Else
		gdk_clipboard_set_text(clipboard, text)
	End If
End Sub

Private Sub gtk_clipboard_clear(ByVal clipboard As GdkClipboard Ptr)
	If clipboard Then gdk_clipboard_set_content(clipboard, NULL)
End Sub

Private Sub gtk_clipboard_store(ByVal clipboard As GdkClipboard Ptr)
End Sub

Type Gtk4CompatReadInfo
	loop_ As GMainLoop Ptr
	text As gchar Ptr
	texture As GdkTexture Ptr
End Type

Private Sub gtk4compat_read_text_ready CDecl(ByVal source As GObject Ptr, ByVal res As GAsyncResult Ptr, ByVal user_data As gpointer)
	Dim As Gtk4CompatReadInfo Ptr ri = user_data
	ri->text = gdk_clipboard_read_text_finish(GDK_CLIPBOARD(source), res, NULL)
	g_main_loop_quit(ri->loop_)
End Sub

Private Sub gtk4compat_read_texture_ready CDecl(ByVal source As GObject Ptr, ByVal res As GAsyncResult Ptr, ByVal user_data As gpointer)
	Dim As Gtk4CompatReadInfo Ptr ri = user_data
	ri->texture = gdk_clipboard_read_texture_finish(GDK_CLIPBOARD(source), res, NULL)
	g_main_loop_quit(ri->loop_)
End Sub

' Returns newly allocated text (free with g_free) or NULL
Private Function gtk_clipboard_wait_for_text(ByVal clipboard As GdkClipboard Ptr) As gchar Ptr
	If clipboard = 0 Then Return NULL
	Dim As Gtk4CompatReadInfo ri
	ri.loop_ = g_main_loop_new(NULL, False)
	gdk_clipboard_read_text_async(clipboard, NULL, @gtk4compat_read_text_ready, @ri)
	g_main_loop_run(ri.loop_)
	g_main_loop_unref(ri.loop_)
	Return ri.text
End Function

Private Function gtk_clipboard_wait_is_text_available(ByVal clipboard As GdkClipboard Ptr) As gboolean
	If clipboard = 0 Then Return False
	Return gdk_content_formats_contain_gtype(gdk_clipboard_get_formats(clipboard), G_TYPE_STRING)
End Function

Private Function gtk_clipboard_wait_is_image_available(ByVal clipboard As GdkClipboard Ptr) As gboolean
	If clipboard = 0 Then Return False
	Return gdk_content_formats_contain_gtype(gdk_clipboard_get_formats(clipboard), GDK_TYPE_TEXTURE)
End Function

Private Function gtk_clipboard_wait_for_image(ByVal clipboard As GdkClipboard Ptr) As GdkPixbuf Ptr
	If clipboard = 0 Then Return NULL
	Dim As Gtk4CompatReadInfo ri
	ri.loop_ = g_main_loop_new(NULL, False)
	gdk_clipboard_read_texture_async(clipboard, NULL, @gtk4compat_read_texture_ready, @ri)
	g_main_loop_run(ri.loop_)
	g_main_loop_unref(ri.loop_)
	If ri.texture = 0 Then Return NULL
	Dim As GdkPixbuf Ptr pixbuf = gdk_pixbuf_get_from_texture(ri.texture)
	g_object_unref(ri.texture)
	Return pixbuf
End Function

Private Sub gtk_clipboard_set_image(ByVal clipboard As GdkClipboard Ptr, ByVal pixbuf As GdkPixbuf Ptr)
	If clipboard = 0 OrElse pixbuf = 0 Then Exit Sub
	Dim As GdkTexture Ptr texture = gdk_texture_new_for_pixbuf(pixbuf)
	gdk_clipboard_set_texture(clipboard, texture)
	g_object_unref(texture)
End Sub

' -----------------------------------------------------------------------------
' Screen, monitors, cursors, colors
' -----------------------------------------------------------------------------
Private Function gdk_screen_get_default() As GdkDisplay Ptr
	Return gdk_display_get_default()
End Function

Private Function gdk_display_get_primary_monitor(ByVal display As GdkDisplay Ptr) As GdkMonitor Ptr
	If display = 0 Then display = gdk_display_get_default()
	If display = 0 Then Return 0
	Dim As GListModel Ptr monitors = gdk_display_get_monitors(display)
	If monitors = 0 OrElse g_list_model_get_n_items(monitors) = 0 Then Return 0
	Dim As GdkMonitor Ptr monitor = g_list_model_get_item(monitors, 0)
	' The display keeps a reference
	g_object_unref(monitor)
	Return monitor
End Function

Private Sub gdk_monitor_get_workarea(ByVal monitor As GdkMonitor Ptr, ByVal workarea As GdkRectangle Ptr)
	If workarea = 0 Then Exit Sub
	If monitor Then
		gdk_monitor_get_geometry(monitor, workarea)
	Else
		workarea->x = 0: workarea->y = 0: workarea->width = 1024: workarea->height = 768
	End If
End Sub

Private Function gdk_screen_get_primary_monitor(ByVal screen_ As GdkDisplay Ptr) As gint
	Return 0
End Function

Private Sub gdk_screen_get_monitor_geometry(ByVal screen_ As GdkDisplay Ptr, ByVal monitor_num As gint, ByVal dest As GdkRectangle Ptr)
	gdk_monitor_get_workarea(gdk_display_get_primary_monitor(screen_), dest)
End Sub

Private Sub gdk_screen_get_monitor_workarea(ByVal screen_ As GdkDisplay Ptr, ByVal monitor_num As gint, ByVal dest As GdkRectangle Ptr)
	gdk_monitor_get_workarea(gdk_display_get_primary_monitor(screen_), dest)
End Sub

Private Function gdk_screen_get_width(ByVal screen_ As GdkDisplay Ptr) As gint
	Dim As GdkRectangle r
	gdk_monitor_get_workarea(gdk_display_get_primary_monitor(screen_), @r)
	Return r.width
End Function

Private Function gdk_screen_get_height(ByVal screen_ As GdkDisplay Ptr) As gint
	Dim As GdkRectangle r
	gdk_monitor_get_workarea(gdk_display_get_primary_monitor(screen_), @r)
	Return r.height
End Function

' DPI from the gtk-xft-dpi setting (1024 * dots per inch)
Private Function gdk_screen_get_resolution(ByVal screen_ As GdkDisplay Ptr) As gdouble
	Dim As gint xftdpi
	Dim As GtkSettings Ptr settings = gtk_settings_get_default()
	If settings Then g_object_get(settings, "gtk-xft-dpi", @xftdpi, NULL)
	If xftdpi <= 0 Then Return 96
	Return xftdpi / 1024
End Function

Private Function gdk4compat_cursor_name(ByVal cursor_type As GdkCursorType) As Const gchar Ptr
	Select Case cursor_type
	Case GDK_XTERM: Return @"text"
	Case GDK_HAND1, GDK_HAND2: Return @"pointer"
	Case GDK_WATCH: Return @"wait"
	Case GDK_CROSSHAIR, GDK_CROSS, GDK_PLUS: Return @"crosshair"
	Case GDK_SB_H_DOUBLE_ARROW, GDK_LEFT_SIDE, GDK_RIGHT_SIDE: Return @"ew-resize"
	Case GDK_SB_V_DOUBLE_ARROW, GDK_TOP_SIDE, GDK_BOTTOM_SIDE: Return @"ns-resize"
	Case GDK_FLEUR: Return @"move"
	Case GDK_SIZING: Return @"all-scroll"
	Case GDK_QUESTION_ARROW: Return @"help"
	Case GDK_TOP_LEFT_CORNER, GDK_BOTTOM_RIGHT_CORNER: Return @"nwse-resize"
	Case GDK_TOP_RIGHT_CORNER, GDK_BOTTOM_LEFT_CORNER: Return @"nesw-resize"
	Case GDK_X_CURSOR: Return @"not-allowed"
	Case GDK_PENCIL: Return @"cell"
	Case GDK_BLANK_CURSOR: Return @"none"
	Case Else: Return @"default"
	End Select
End Function

Private Function gdk_cursor_new_for_display(ByVal display As GdkDisplay Ptr, ByVal cursor_type As GdkCursorType) As GdkCursor Ptr
	Return gdk_cursor_new_from_name(gdk4compat_cursor_name(cursor_type), NULL)
End Function

Private Function gdk_cursor_new(ByVal cursor_type As GdkCursorType) As GdkCursor Ptr
	Return gdk_cursor_new_from_name(gdk4compat_cursor_name(cursor_type), NULL)
End Function

Private Function gdk_cursor_new_from_pixbuf(ByVal display As GdkDisplay Ptr, ByVal pixbuf As GdkPixbuf Ptr, ByVal x As gint, ByVal y As gint) As GdkCursor Ptr
	If pixbuf = 0 Then Return NULL
	Dim As GdkTexture Ptr texture = gdk_texture_new_for_pixbuf(pixbuf)
	Dim As GdkCursor Ptr cursor = gdk_cursor_new_from_texture(texture, x, y, NULL)
	g_object_unref(texture)
	Return cursor
End Function

' The "window" can be a widget (see gtk_layout_get_bin_window)
Private Sub gdk_window_set_cursor(ByVal window_ As GdkSurface Ptr, ByVal cursor As GdkCursor Ptr)
	If window_ = 0 Then Exit Sub
	If GTK_IS_WIDGET(window_) Then
		gtk_widget_set_cursor(GTK_WIDGET(window_), cursor)
	ElseIf GDK_IS_SURFACE(window_) Then
		gdk_surface_set_cursor(window_, cursor)
	End If
End Sub

' GtkFixed has no own window, the layout itself is used for cursors
Private Function gtk_layout_get_bin_window(ByVal layout As GtkFixed Ptr) As GdkSurface Ptr
	Return Cast(GdkSurface Ptr, layout)
End Function

' Only used by expose handlers of GTK2 (not connected in GTK4)
Private Function gdk_cairo_create(ByVal window_ As Any Ptr) As cairo_t Ptr
	Dim As cairo_surface_t Ptr surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 1, 1)
	Dim As cairo_t Ptr cr = cairo_create(surface)
	cairo_surface_destroy(surface)
	Return cr
End Function

Private Function gdk_color_to_string(ByVal colour As Const GdkColor Ptr) As gchar Ptr
	Return g_strdup_printf("#%04x%04x%04x", CUInt(colour->red), CUInt(colour->green), CUInt(colour->blue))
End Function

Private Function gdk_color_parse(ByVal spec As Const gchar Ptr, ByVal colour As GdkColor Ptr) As gboolean
	Dim As GdkRGBA rgba_
	If gdk_rgba_parse(@rgba_, spec) = False Then Return False
	colour->red = rgba_.red * 65535
	colour->green = rgba_.green * 65535
	colour->blue = rgba_.blue * 65535
	Return True
End Function

' -----------------------------------------------------------------------------
' Icon theme
' -----------------------------------------------------------------------------
Private Function gtk_icon_theme_get_default() As GtkIconTheme Ptr
	Return gtk_icon_theme_get_for_display(gdk_display_get_default())
End Function

Private Sub gtk_icon_theme_append_search_path(ByVal icon_theme As GtkIconTheme Ptr, ByVal path As Const gchar Ptr)
	gtk_icon_theme_add_search_path(icon_theme, path)
End Sub

Private Function gtk_icon_theme_load_icon(ByVal icon_theme As GtkIconTheme Ptr, ByVal icon_name As Const gchar Ptr, ByVal size As gint, ByVal flags As gint, ByVal error_ As GError Ptr Ptr) As GdkPixbuf Ptr
	If icon_theme = 0 OrElse icon_name = 0 Then Return NULL
	If gtk_icon_theme_has_icon(icon_theme, icon_name) = False Then Return NULL
	Dim As GtkIconPaintable Ptr paintable = gtk_icon_theme_lookup_icon(icon_theme, icon_name, NULL, size, 1, GTK_TEXT_DIR_NONE, 0)
	If paintable = 0 Then Return NULL
	Dim As GdkPixbuf Ptr pixbuf
	Dim As GFile Ptr file = gtk_icon_paintable_get_file(paintable)
	If file Then
		Dim As gchar Ptr path = g_file_get_path(file)
		If path Then
			pixbuf = gdk_pixbuf_new_from_file_at_size(path, size, size, error_)
			g_free(path)
		Else
			' Icons from resources
			Dim As gchar Ptr uri = g_file_get_uri(file)
			If uri AndAlso Left(*uri, 11) = "resource://" Then
				pixbuf = gdk_pixbuf_new_from_resource_at_scale(uri + 11, size, size, True, error_)
			End If
			g_free(uri)
		End If
		g_object_unref(file)
	End If
	g_object_unref(paintable)
	Return pixbuf
End Function

' -----------------------------------------------------------------------------
' Events (GdkEvent is opaque in GTK4)
' -----------------------------------------------------------------------------
' Coordinates of the event relative to the widget
Private Function gtk4compat_event_get_widget_position(ByVal widget As GtkWidget Ptr, ByVal e As GdkEvent Ptr, ByVal x As gdouble Ptr, ByVal y As gdouble Ptr) As Boolean
	Dim As gdouble ex, ey, nx, ny, wx, wy
	If x Then *x = 0
	If y Then *y = 0
	If widget = 0 OrElse e = 0 Then Return False
	If gdk_event_get_position(e, @ex, @ey) = False Then Return False
	Dim As GtkNative Ptr native = gtk_widget_get_native(widget)
	If native = 0 Then Return False
	gtk_native_get_surface_transform(native, @nx, @ny)
	ex -= nx
	ey -= ny
	' Relative to the allocation (border box) like GTK3, not to the content box
	Dim As graphene_rect_t Bounds
	If gtk_widget_compute_bounds(widget, GTK_WIDGET(native), @Bounds) Then
		wx = ex - Bounds.origin.x
		wy = ey - Bounds.origin.y
	ElseIf gtk_widget_translate_coordinates(GTK_WIDGET(native), widget, ex, ey, @wx, @wy) = False Then
		Return False
	End If
	If x Then *x = wx
	If y Then *y = wy
	Return True
End Function

' Coordinates of the event relative to the control which processes it (like GdkEventButton.x in GTK3)
Private Function gtk4compat_event_x(ByVal e As GdkEvent Ptr) As gdouble
	Dim As gdouble x, y
	gtk4compat_event_get_widget_position(gtk4compat_loops()->CurrentEventWidget, e, @x, @y)
	Return x
End Function

Private Function gtk4compat_event_y(ByVal e As GdkEvent Ptr) As gdouble
	Dim As gdouble x, y
	gtk4compat_event_get_widget_position(gtk4compat_loops()->CurrentEventWidget, e, @x, @y)
	Return y
End Function

' The focus change sent as pseudo event (see Control_FocusEnter)
Private Function gtk4compat_event_focus_in(ByVal e As GdkEvent Ptr) As Boolean
	If e Then Return gdk_focus_event_get_in(e)
	Return gtk4compat_loops()->FocusIn
End Function

Private Function gtk4compat_event_delta_x(ByVal e As GdkEvent Ptr) As gdouble
	Dim As gdouble dx, dy
	If gdk_event_get_event_type(e) <> GDK_SCROLL Then Return 0
	Select Case gdk_scroll_event_get_direction(e)
	Case GDK_SCROLL_LEFT: Return -1
	Case GDK_SCROLL_RIGHT: Return 1
	Case GDK_SCROLL_SMOOTH: gdk_scroll_event_get_deltas(e, @dx, @dy): Return dx
	End Select
	Return 0
End Function

Private Function gtk4compat_event_delta_y(ByVal e As GdkEvent Ptr) As gdouble
	Dim As gdouble dx, dy
	If gdk_event_get_event_type(e) <> GDK_SCROLL Then Return 0
	Select Case gdk_scroll_event_get_direction(e)
	Case GDK_SCROLL_UP: Return -1
	Case GDK_SCROLL_DOWN: Return 1
	Case GDK_SCROLL_SMOOTH: gdk_scroll_event_get_deltas(e, @dx, @dy): Return dy
	End Select
	Return 0
End Function

' gtk_widget_translate_coordinates with integer results (GTK3 signature)
' The coordinates of GTK4 widgets begin at the content box (after the padding and the border), the coordinates
' of GTK3 at the allocation: the bounds (border box) give the coordinates of GTK3
Private Function gtk4compat_translate_coordinates(ByVal src_widget As GtkWidget Ptr, ByVal dest_widget As GtkWidget Ptr, ByVal src_x As gdouble, ByVal src_y As gdouble, ByVal dest_x As gint Ptr, ByVal dest_y As gint Ptr) As gboolean
	Dim As graphene_rect_t SrcBounds, DestBounds
	Dim As GtkNative Ptr native = gtk_widget_get_native(src_widget)
	If native = 0 OrElse gtk_widget_compute_bounds(src_widget, GTK_WIDGET(native), @SrcBounds) = False OrElse gtk_widget_compute_bounds(dest_widget, GTK_WIDGET(native), @DestBounds) = False Then
		Dim As gdouble dx, dy
		Dim As gboolean Result = gtk_widget_translate_coordinates(src_widget, dest_widget, src_x, src_y, @dx, @dy)
		If dest_x Then *dest_x = CInt(dx)
		If dest_y Then *dest_y = CInt(dy)
		Return Result
	End If
	If dest_x Then *dest_x = CInt(src_x + SrcBounds.origin.x - DestBounds.origin.x)
	If dest_y Then *dest_y = CInt(src_y + SrcBounds.origin.y - DestBounds.origin.y)
	Return True
End Function

' Scroll bars are not ranges in GTK4: the range functions for both (and adjustments)
Private Function gtk4compat_range_adjustment(ByVal widget As Any Ptr) As GtkAdjustment Ptr
	If widget = 0 Then Return 0
	If GTK_IS_ADJUSTMENT(widget) Then Return widget
	If GTK_IS_RANGE(widget) Then Return gtk_range_get_adjustment(GTK_RANGE(widget))
	If GTK_IS_SCROLLBAR(widget) Then Return gtk_scrollbar_get_adjustment(GTK_SCROLLBAR(widget))
	Return 0
End Function

Private Sub gtk4compat_range_set_range(ByVal widget As Any Ptr, ByVal min_ As gdouble, ByVal max_ As gdouble)
	If widget AndAlso GTK_IS_RANGE(widget) Then gtk_range_set_range(GTK_RANGE(widget), min_, max_): Exit Sub
	Dim As GtkAdjustment Ptr adj = gtk4compat_range_adjustment(widget)
	If adj = 0 Then Exit Sub
	gtk_adjustment_configure(adj, IIf(gtk_adjustment_get_value(adj) < min_, min_, IIf(gtk_adjustment_get_value(adj) > max_, max_, gtk_adjustment_get_value(adj))), min_, max_, gtk_adjustment_get_step_increment(adj), gtk_adjustment_get_page_increment(adj), gtk_adjustment_get_page_size(adj))
End Sub

Private Function gtk4compat_range_get_value(ByVal widget As Any Ptr) As gdouble
	Dim As GtkAdjustment Ptr adj = gtk4compat_range_adjustment(widget)
	If adj = 0 Then Return 0
	Return gtk_adjustment_get_value(adj)
End Function

Private Sub gtk4compat_range_set_value(ByVal widget As Any Ptr, ByVal value As gdouble)
	Dim As GtkAdjustment Ptr adj = gtk4compat_range_adjustment(widget)
	If adj Then gtk_adjustment_set_value(adj, value)
End Sub

Private Sub gtk4compat_range_set_increments(ByVal widget As Any Ptr, ByVal stepinc As gdouble, ByVal pageinc As gdouble)
	Dim As GtkAdjustment Ptr adj = gtk4compat_range_adjustment(widget)
	If adj = 0 Then Exit Sub
	gtk_adjustment_set_step_increment(adj, stepinc)
	gtk_adjustment_set_page_increment(adj, pageinc)
End Sub

' Debugging: prints the widget tree with the bounds
Private Sub gtk4compat_dump_tree(ByVal widget As GtkWidget Ptr, ByVal root As GtkWidget Ptr, ByVal Depth As Integer)
	If widget = 0 OrElse Depth > 40 Then Exit Sub
	Dim As graphene_rect_t r
	gtk_widget_compute_bounds(widget, root, @r)
	Dim As Any Ptr Ctrl = g_object_get_data(G_OBJECT(widget), "MFFControl")
	Print Space(Depth * 2) & *G_OBJECT_TYPE_NAME(widget) & " '" & *gtk_widget_get_name(widget) & "'" & IIf(Ctrl, " [mff]", "") & " vis=" & gtk_widget_get_visible(widget) & " x=" & CInt(r.origin.x) & " y=" & CInt(r.origin.y) & " w=" & CInt(r.size.width) & " h=" & CInt(r.size.height) & " req=" & gtk_widget_get_width(widget) & "x" & gtk_widget_get_height(widget) & " vexp=" & gtk_widget_get_vexpand(widget) & "/" & gtk_widget_get_vexpand_set(widget) & "/" & gtk_widget_compute_expand(widget, GTK_ORIENTATION_VERTICAL) & " valign=" & gtk_widget_get_valign(widget)
	If GTK_IS_IMAGE(widget) Then
		Dim As Const gchar Ptr IconName = gtk_image_get_icon_name(GTK_IMAGE(widget))
		If IconName Then Print Space(Depth * 2 + 2) & "icon=" & *IconName & " found=" & gtk_icon_theme_has_icon(gtk_icon_theme_get_for_display(gdk_display_get_default()), IconName) & " type=" & gtk_image_get_storage_type(GTK_IMAGE(widget)) & " pixelsize=" & gtk_image_get_pixel_size(GTK_IMAGE(widget)) Else Print Space(Depth * 2 + 2) & "type=" & gtk_image_get_storage_type(GTK_IMAGE(widget))
	End If
	Dim As GtkWidget Ptr child = gtk_widget_get_first_child(widget)
	While child
		gtk4compat_dump_tree child, root, Depth + 1
		child = gtk_widget_get_next_sibling(child)
	Wend
End Sub

Private Function gtk4compat_dump_timeout CDecl(ByVal user_data As gpointer) As gboolean
	Print "=== widget tree"
	gtk4compat_dump_tree user_data, user_data, 0
	Return False
End Function

' The widget under the pointer of the event
Private Function gtk4compat_event_get_target(ByVal widget As GtkWidget Ptr, ByVal e As GdkEvent Ptr) As GtkWidget Ptr
	Dim As gdouble ex, ey, nx, ny
	If widget = 0 OrElse e = 0 Then Return 0
	If gdk_event_get_position(e, @ex, @ey) = False Then Return 0
	Dim As GtkNative Ptr native = gtk_widget_get_native(widget)
	If native = 0 Then Return 0
	gtk_native_get_surface_transform(native, @nx, @ny)
	Return gtk_widget_pick(GTK_WIDGET(native), ex - nx, ey - ny, GTK_PICK_DEFAULT)
End Function

' The nearest widget with an object data of the key, beginning from the widget itself
Private Function gtk4compat_widget_find_data_owner(ByVal widget As GtkWidget Ptr, ByVal Key As Const gchar Ptr) As GtkWidget Ptr
	While widget
		If g_object_get_data(G_OBJECT(widget), Key) Then Return widget
		widget = gtk_widget_get_parent(widget)
	Wend
	Return 0
End Function

' -----------------------------------------------------------------------------
' Menus: GtkMenu, GtkMenuBar and GtkMenuItem were removed in GTK4.
' They are emulated with GtkPopover (menu), GtkBox (menu bar) and flat GtkButton (item).
' The items emit "clicked" (connect to "clicked" instead of "activate").
' -----------------------------------------------------------------------------
Type GtkMenuShell As GtkWidget
Type GtkMenu As GtkWidget
Type GtkMenuBar As GtkWidget
Type GtkMenuItem As GtkWidget
Type GtkCheckMenuItem As GtkWidget
Type GtkSeparatorMenuItem As GtkWidget
Type GtkAccelLabel As GtkWidget

Const MFF_MENU_KIND_BAR = 1
Const MFF_MENU_KIND_MENU = 2
Const MFF_MENU_KIND_ITEM = 3
Const MFF_MENU_KIND_CHECK = 4
Const MFF_MENU_KIND_SEPARATOR = 5

Private Function gtk4compat_menu_kind(ByVal obj As Any Ptr) As Integer
	If obj = 0 Then Return 0
	If G_IS_OBJECT(obj) = 0 Then Return 0
	Return CInt(Cast(Integer, g_object_get_data(G_OBJECT(obj), "mff-menu-kind")))
End Function

#define GTK_MENU_SHELL(obj) Cast(GtkWidget Ptr, obj)
#define GTK_MENU(obj) Cast(GtkWidget Ptr, obj)
#define GTK_MENU_BAR(obj) Cast(GtkWidget Ptr, obj)
#define GTK_MENU_ITEM(obj) Cast(GtkWidget Ptr, obj)
#define GTK_CHECK_MENU_ITEM(obj) Cast(GtkWidget Ptr, obj)
#define GTK_SEPARATOR_MENU_ITEM(obj) Cast(GtkWidget Ptr, obj)
#define GTK_ACCEL_LABEL(obj) Cast(GtkWidget Ptr, obj)
#define GTK_IS_MENU_BAR(obj) (-(gtk4compat_menu_kind(obj) = MFF_MENU_KIND_BAR))
#define GTK_IS_MENU(obj) (-(gtk4compat_menu_kind(obj) = MFF_MENU_KIND_MENU))
#define GTK_IS_MENU_SHELL(obj) (-(gtk4compat_menu_kind(obj) = MFF_MENU_KIND_BAR OrElse gtk4compat_menu_kind(obj) = MFF_MENU_KIND_MENU))
#define GTK_IS_MENU_ITEM(obj) (-(gtk4compat_menu_kind(obj) = MFF_MENU_KIND_ITEM OrElse gtk4compat_menu_kind(obj) = MFF_MENU_KIND_CHECK))
#define GTK_IS_CHECK_MENU_ITEM(obj) (-(gtk4compat_menu_kind(obj) = MFF_MENU_KIND_CHECK))
#define GTK_IS_SEPARATOR_MENU_ITEM(obj) (-(gtk4compat_menu_kind(obj) = MFF_MENU_KIND_SEPARATOR))

' Popovers parented to a widget must be unparented before the widget is finalized
Private Sub gtk4compat_unparent_popovers CDecl(ByVal widget As GtkWidget Ptr, ByVal user_data As gpointer)
	Dim As GtkWidget Ptr child = gtk_widget_get_first_child(widget)
	While child
		Dim As GtkWidget Ptr NextChild = gtk_widget_get_next_sibling(child)
		If GTK_IS_POPOVER(child) Then gtk_widget_unparent(child)
		child = NextChild
	Wend
End Sub

Private Function gtk_menu_bar_new() As GtkWidget Ptr
	Dim As GtkWidget Ptr bar = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0)
	gtk_widget_add_css_class(bar, "menubar")
	g_object_set_data(G_OBJECT(bar), "mff-menu-kind", Cast(gpointer, MFF_MENU_KIND_BAR))
	Return bar
End Function

Private Function gtk_menu_new() As GtkWidget Ptr
	Dim As GtkWidget Ptr popover = gtk_popover_new()
	gtk_popover_set_has_arrow(GTK_POPOVER(popover), False)
	gtk_widget_add_css_class(popover, "menu")
	gtk_widget_set_halign(popover, GTK_ALIGN_START)
	Dim As GtkWidget Ptr box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0)
	gtk_popover_set_child(GTK_POPOVER(popover), box)
	g_object_set_data(G_OBJECT(popover), "mff-menu-kind", Cast(gpointer, MFF_MENU_KIND_MENU))
	g_object_set_data(G_OBJECT(popover), "mff-menu-box", box)
	' The menu lives until it is destroyed (also while it has no parent)
	g_object_ref_sink(popover)
	Return popover
End Function

Private Sub gtk_menu_set_reserve_toggle_size(ByVal menu As GtkWidget Ptr, ByVal reserve_toggle_size As gboolean)
End Sub

' Closes the menus which contain the widget
Private Sub gtk4compat_menu_close_all(ByVal widget As GtkWidget Ptr)
	Dim As GtkWidget Ptr w = widget
	While w
		If GTK_IS_POPOVER(w) Then gtk_popover_popdown(GTK_POPOVER(w))
		w = gtk_widget_get_parent(w)
	Wend
End Sub

Private Sub gtk4compat_check_update(ByVal item As GtkWidget Ptr)
	Dim As GtkWidget Ptr img = g_object_get_data(G_OBJECT(item), "mff-check-image")
	If img Then gtk_widget_set_opacity(img, IIf(g_object_get_data(G_OBJECT(item), "mff-checked"), 1.0, 0.0))
End Sub

Private Sub gtk4compat_menu_item_clicked CDecl(ByVal button As GtkButton Ptr, ByVal user_data As gpointer)
	Dim As GtkWidget Ptr item = GTK_WIDGET(button)
	' Emitted by gtk_check_menu_item_set_active
	If g_object_get_data(G_OBJECT(item), "mff-no-toggle") Then Exit Sub
	Dim As GtkWidget Ptr submenu = g_object_get_data(G_OBJECT(item), "mff-submenu")
	If submenu Then
		If gtk4compat_menu_kind(gtk_widget_get_parent(item)) = MFF_MENU_KIND_BAR Then
			gtk_popover_set_position(GTK_POPOVER(submenu), GTK_POS_BOTTOM)
		Else
			gtk_popover_set_position(GTK_POPOVER(submenu), GTK_POS_RIGHT)
		End If
		gtk_popover_popup(GTK_POPOVER(submenu))
		Exit Sub
	End If
	If gtk4compat_menu_kind(item) = MFF_MENU_KIND_CHECK Then
		g_object_set_data(G_OBJECT(item), "mff-checked", Cast(gpointer, IIf(g_object_get_data(G_OBJECT(item), "mff-checked"), 0, 1)))
		gtk4compat_check_update item
	End If
	gtk4compat_menu_close_all item
End Sub

Private Function gtk4compat_menu_item_new_internal(ByVal Kind As Integer) As GtkWidget Ptr
	Dim As GtkWidget Ptr item = gtk_button_new()
	gtk_button_set_has_frame(GTK_BUTTON(item), False)
	gtk_widget_add_css_class(item, "menuitem")
	gtk_widget_set_focus_on_click(item, False)
	g_object_set_data(G_OBJECT(item), "mff-menu-kind", Cast(gpointer, Kind))
	g_signal_connect(item, "clicked", G_CALLBACK(@gtk4compat_menu_item_clicked), NULL)
	Return item
End Function

Private Function gtk_menu_item_new() As GtkWidget Ptr
	Return gtk4compat_menu_item_new_internal(MFF_MENU_KIND_ITEM)
End Function

Private Function gtk_menu_item_new_with_mnemonic(ByVal label As Const gchar Ptr) As GtkWidget Ptr
	Dim As GtkWidget Ptr item = gtk4compat_menu_item_new_internal(MFF_MENU_KIND_ITEM)
	Dim As GtkWidget Ptr lbl = gtk_label_new_with_mnemonic(label)
	gtk_label_set_xalign(GTK_LABEL(lbl), 0.0)
	gtk_button_set_child(GTK_BUTTON(item), lbl)
	Return item
End Function

Private Function gtk_menu_item_new_with_label(ByVal label As Const gchar Ptr) As GtkWidget Ptr
	Return gtk_menu_item_new_with_mnemonic(label)
End Function

Private Function gtk_check_menu_item_new_with_label(ByVal label As Const gchar Ptr) As GtkWidget Ptr
	Dim As GtkWidget Ptr item = gtk4compat_menu_item_new_internal(MFF_MENU_KIND_CHECK)
	Dim As GtkWidget Ptr box = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 6)
	Dim As GtkWidget Ptr img = gtk_image_new_from_icon_name("object-select-symbolic")
	Dim As GtkWidget Ptr lbl = gtk_label_new_with_mnemonic(label)
	gtk_label_set_xalign(GTK_LABEL(lbl), 0.0)
	gtk_widget_set_hexpand(lbl, True)
	gtk_box_append(GTK_BOX(box), img)
	gtk_box_append(GTK_BOX(box), lbl)
	gtk_button_set_child(GTK_BUTTON(item), box)
	g_object_set_data(G_OBJECT(item), "mff-check-image", img)
	g_object_set_data(G_OBJECT(item), "mff-menu-label", lbl)
	gtk4compat_check_update item
	Return item
End Function

Private Function gtk_check_menu_item_new_with_mnemonic(ByVal label As Const gchar Ptr) As GtkWidget Ptr
	Return gtk_check_menu_item_new_with_label(label)
End Function

Private Function gtk_check_menu_item_new() As GtkWidget Ptr
	Return gtk_check_menu_item_new_with_label("")
End Function

Private Function gtk_check_menu_item_get_active(ByVal item As GtkWidget Ptr) As gboolean
	If item = 0 Then Return False
	Return g_object_get_data(G_OBJECT(item), "mff-checked") <> 0
End Function

' Like GTK3 the item is activated if the state changes
Private Sub gtk_check_menu_item_set_active(ByVal item As GtkWidget Ptr, ByVal is_active As gboolean)
	If item = 0 Then Exit Sub
	Dim As Boolean OldValue = g_object_get_data(G_OBJECT(item), "mff-checked") <> 0
	g_object_set_data(G_OBJECT(item), "mff-checked", Cast(gpointer, IIf(is_active, 1, 0)))
	gtk4compat_check_update item
	If OldValue <> CBool(is_active) Then
		g_object_set_data(G_OBJECT(item), "mff-no-toggle", Cast(gpointer, 1))
		g_signal_emit_by_name(item, "clicked")
		g_object_set_data(G_OBJECT(item), "mff-no-toggle", NULL)
	End If
End Sub

Private Sub gtk_check_menu_item_set_draw_as_radio(ByVal item As GtkWidget Ptr, ByVal draw_as_radio As gboolean)
End Sub

Private Function gtk_separator_menu_item_new() As GtkWidget Ptr
	Dim As GtkWidget Ptr sep = gtk_separator_new(GTK_ORIENTATION_HORIZONTAL)
	g_object_set_data(G_OBJECT(sep), "mff-menu-kind", Cast(gpointer, MFF_MENU_KIND_SEPARATOR))
	Return sep
End Function

' Accelerator labels are plain labels (the accelerator is shown in another label)
Private Function gtk_accel_label_new(ByVal text As Const gchar Ptr) As GtkWidget Ptr
	Dim As GtkWidget Ptr lbl = gtk_label_new_with_mnemonic(text)
	gtk_label_set_xalign(GTK_LABEL(lbl), 0.0)
	Return lbl
End Function

Private Sub gtk_accel_label_set_accel_widget(ByVal accel_label As GtkWidget Ptr, ByVal accel_widget As GtkWidget Ptr)
	If accel_label = 0 OrElse accel_widget = 0 Then Exit Sub
	g_object_set_data(G_OBJECT(accel_widget), "mff-menu-label", accel_label)
End Sub

Private Sub gtk_menu_item_set_submenu(ByVal item As GtkWidget Ptr, ByVal submenu As GtkWidget Ptr)
	If item = 0 Then Exit Sub
	Dim As GtkWidget Ptr OldSubmenu = g_object_get_data(G_OBJECT(item), "mff-submenu")
	If OldSubmenu = submenu Then Exit Sub
	If OldSubmenu AndAlso gtk_widget_get_parent(OldSubmenu) = item Then gtk_widget_unparent(OldSubmenu)
	g_object_set_data(G_OBJECT(item), "mff-submenu", submenu)
	If submenu Then
		If gtk_widget_get_parent(submenu) Then gtk_widget_unparent(submenu)
		gtk_widget_set_parent(submenu, item)
		If g_object_get_data(G_OBJECT(item), "mff-unparent-connected") = 0 Then
			g_object_set_data(G_OBJECT(item), "mff-unparent-connected", Cast(gpointer, 1))
			g_signal_connect(item, "destroy", G_CALLBACK(@gtk4compat_unparent_popovers), NULL)
		End If
	End If
End Sub

Private Function gtk_menu_item_get_submenu(ByVal item As GtkWidget Ptr) As GtkWidget Ptr
	If item = 0 Then Return 0
	Return g_object_get_data(G_OBJECT(item), "mff-submenu")
End Function

Private Sub gtk_menu_item_activate(ByVal item As GtkWidget Ptr)
	If item Then g_signal_emit_by_name(item, "clicked")
End Sub

Private Sub gtk_menu_item_set_label(ByVal item As GtkWidget Ptr, ByVal label As Const gchar Ptr)
	Dim As GtkWidget Ptr lbl = gtk_bin_get_child(item)
	If lbl AndAlso GTK_IS_LABEL(lbl) Then gtk_label_set_text_with_mnemonic(GTK_LABEL(lbl), label)
End Sub

Private Function gtk4compat_menu_items_box(ByVal shell_ As GtkWidget Ptr) As GtkWidget Ptr
	Dim As GtkWidget Ptr MenuBox = g_object_get_data(G_OBJECT(shell_), "mff-menu-box")
	If MenuBox Then Return MenuBox
	Return shell_
End Function

Private Sub gtk_menu_shell_insert(ByVal shell_ As GtkWidget Ptr, ByVal child As GtkWidget Ptr, ByVal position As gint)
	If shell_ = 0 OrElse child = 0 Then Exit Sub
	Dim As GtkWidget Ptr box = gtk4compat_menu_items_box(shell_)
	If gtk_widget_get_parent(child) = box Then Exit Sub
	If gtk_widget_get_parent(child) Then gtk_container_remove(gtk_widget_get_parent(child), child)
	' Items of menu bars do not expand (labels inside the items expand)
	If gtk4compat_menu_kind(shell_) = MFF_MENU_KIND_BAR Then
		gtk_widget_set_hexpand(child, False)
		gtk_widget_set_vexpand(child, False)
	End If
	Dim As GtkWidget Ptr Sibling = gtk_widget_get_first_child(box)
	If position < 0 Then
		gtk_box_append(GTK_BOX(box), child)
	ElseIf position = 0 OrElse Sibling = 0 Then
		gtk_box_prepend(GTK_BOX(box), child)
	Else
		For i As Integer = 1 To position - 1
			If gtk_widget_get_next_sibling(Sibling) = 0 Then Exit For
			Sibling = gtk_widget_get_next_sibling(Sibling)
		Next
		gtk_box_insert_child_after(GTK_BOX(box), child, Sibling)
	End If
End Sub

Private Sub gtk_menu_shell_append(ByVal shell_ As GtkWidget Ptr, ByVal child As GtkWidget Ptr)
	gtk_menu_shell_insert shell_, child, -1
End Sub

Private Sub gtk_menu_shell_prepend(ByVal shell_ As GtkWidget Ptr, ByVal child As GtkWidget Ptr)
	gtk_menu_shell_insert shell_, child, 0
End Sub

' Shows the menu at the position (relative to the parent widget)
Private Sub gtk4compat_menu_popup_at(ByVal menu As GtkWidget Ptr, ByVal parent As GtkWidget Ptr, ByVal x As gdouble, ByVal y As gdouble)
	If menu = 0 Then Exit Sub
	If parent = 0 Then parent = gtk_widget_get_parent(menu)
	If parent = 0 Then Exit Sub
	If gtk_widget_get_parent(menu) <> parent Then
		If gtk_widget_get_parent(menu) Then gtk_widget_unparent(menu)
		gtk_widget_set_parent(menu, parent)
	End If
	Dim As GdkRectangle r
	r.x = x: r.y = y: r.width = 1: r.height = 1
	gtk_popover_set_pointing_to(GTK_POPOVER(menu), @r)
	gtk_popover_set_position(GTK_POPOVER(menu), GTK_POS_BOTTOM)
	gtk_popover_popup(GTK_POPOVER(menu))
End Sub

' The pointer position relative to the widget
Private Function gtk4compat_widget_get_pointer(ByVal widget As GtkWidget Ptr, ByVal x As gdouble Ptr, ByVal y As gdouble Ptr) As Boolean
	If x Then *x = 0
	If y Then *y = 0
	If widget = 0 Then Return False
	Dim As GtkNative Ptr native = gtk_widget_get_native(widget)
	If native = 0 Then Return False
	Dim As GdkSurface Ptr surface = gtk_native_get_surface(native)
	If surface = 0 Then Return False
	Dim As GdkSeat Ptr seat = gdk_display_get_default_seat(gtk_widget_get_display(widget))
	If seat = 0 Then Return False
	Dim As gdouble px, py, nx, ny, wx, wy
	If gdk_surface_get_device_position(surface, gdk_seat_get_pointer(seat), @px, @py, NULL) = False Then Return False
	gtk_native_get_surface_transform(native, @nx, @ny)
	If gtk_widget_translate_coordinates(GTK_WIDGET(native), widget, px - nx, py - ny, @wx, @wy) = False Then Return False
	If x Then *x = wx
	If y Then *y = wy
	Return True
End Function

Private Sub gtk_menu_popup_at_pointer(ByVal menu As GtkWidget Ptr, ByVal trigger_event As GdkEvent Ptr)
	If menu = 0 Then Exit Sub
	Dim As GtkWidget Ptr parent = gtk_widget_get_parent(menu)
	If parent = 0 Then Exit Sub
	Dim As gdouble x, y
	gtk4compat_widget_get_pointer parent, @x, @y
	gtk4compat_menu_popup_at menu, parent, x, y
End Sub

Private Sub gtk_menu_popup_at_widget(ByVal menu As GtkWidget Ptr, ByVal widget As GtkWidget Ptr, ByVal widget_anchor As gint, ByVal menu_anchor As gint, ByVal trigger_event As GdkEvent Ptr)
	If menu = 0 OrElse widget = 0 Then Exit Sub
	gtk4compat_menu_popup_at menu, widget, 0, gtk_widget_get_height(widget)
End Sub

Private Sub gtk_menu_popdown(ByVal menu As GtkWidget Ptr)
	If menu AndAlso GTK_IS_POPOVER(menu) Then gtk_popover_popdown(GTK_POPOVER(menu))
End Sub

Private Sub gtk_menu_shell_deactivate(ByVal shell_ As GtkWidget Ptr)
	gtk_menu_popdown shell_
End Sub

' -----------------------------------------------------------------------------
' Toolbars: GtkToolbar and the tool items were removed in GTK4.
' They are emulated with a GtkBox (toolbar) and flat buttons (tool buttons),
' the buttons emit "clicked" like GTK3.
' -----------------------------------------------------------------------------
Type GtkToolbar As GtkWidget
Type GtkToolItem As GtkWidget
Type GtkToolButton As GtkWidget
Type GtkToggleToolButton As GtkWidget
Type GtkRadioToolButton As GtkWidget
Type GtkMenuToolButton As GtkWidget
Type GtkSeparatorToolItem As GtkWidget
Type GtkMenuPositionFunc As Any Ptr

Enum GtkToolbarStyle
	GTK_TOOLBAR_ICONS = 0
	GTK_TOOLBAR_TEXT = 1
	GTK_TOOLBAR_BOTH = 2
	GTK_TOOLBAR_BOTH_HORIZ = 3
End Enum

Const MFF_TOOL_KIND_TOOLBAR = 1
Const MFF_TOOL_KIND_ITEM = 2
Const MFF_TOOL_KIND_SEPARATOR = 3
Const MFF_TOOL_KIND_BUTTON = 4
Const MFF_TOOL_KIND_TOGGLE = 5
Const MFF_TOOL_KIND_RADIO = 6
Const MFF_TOOL_KIND_MENU = 7

Private Function gtk4compat_tool_kind(ByVal obj As Any Ptr) As Integer
	If obj = 0 Then Return 0
	If G_IS_OBJECT(obj) = 0 Then Return 0
	Return CInt(Cast(Integer, g_object_get_data(G_OBJECT(obj), "mff-tool-kind")))
End Function

#define GTK_TOOLBAR(obj) Cast(GtkWidget Ptr, obj)
#define GTK_TOOL_ITEM(obj) Cast(GtkWidget Ptr, obj)
#define GTK_TOOL_BUTTON(obj) Cast(GtkWidget Ptr, obj)
#define GTK_TOGGLE_TOOL_BUTTON(obj) Cast(GtkWidget Ptr, obj)
#define GTK_RADIO_TOOL_BUTTON(obj) Cast(GtkWidget Ptr, obj)
#define GTK_MENU_TOOL_BUTTON(obj) Cast(GtkWidget Ptr, obj)
#define GTK_SEPARATOR_TOOL_ITEM(obj) Cast(GtkWidget Ptr, obj)
#define GTK_IS_TOOLBAR(obj) (-(gtk4compat_tool_kind(obj) = MFF_TOOL_KIND_TOOLBAR))
#define GTK_IS_TOOL_ITEM(obj) (-(gtk4compat_tool_kind(obj) >= MFF_TOOL_KIND_ITEM))
#define GTK_IS_SEPARATOR_TOOL_ITEM(obj) (-(gtk4compat_tool_kind(obj) = MFF_TOOL_KIND_SEPARATOR))
#define GTK_IS_TOOL_BUTTON(obj) (-(gtk4compat_tool_kind(obj) >= MFF_TOOL_KIND_BUTTON))
#define GTK_IS_TOGGLE_TOOL_BUTTON(obj) (-(gtk4compat_tool_kind(obj) = MFF_TOOL_KIND_TOGGLE OrElse gtk4compat_tool_kind(obj) = MFF_TOOL_KIND_RADIO))
#define GTK_IS_RADIO_TOOL_BUTTON(obj) (-(gtk4compat_tool_kind(obj) = MFF_TOOL_KIND_RADIO))
#define GTK_IS_MENU_TOOL_BUTTON(obj) (-(gtk4compat_tool_kind(obj) = MFF_TOOL_KIND_MENU))

Private Function gtk_toolbar_new() As GtkWidget Ptr
	Dim As GtkWidget Ptr bar = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0)
	gtk_widget_add_css_class(bar, "toolbar")
	g_object_set_data(G_OBJECT(bar), "mff-tool-kind", Cast(gpointer, MFF_TOOL_KIND_TOOLBAR))
	g_object_set_data(G_OBJECT(bar), "mff-toolbar-style", Cast(gpointer, GTK_TOOLBAR_BOTH_HORIZ))
	Return bar
End Function

' Shows the icon and the label of a tool button for the toolbar style
Private Sub gtk4compat_tool_button_update(ByVal item As GtkWidget Ptr)
	If gtk4compat_tool_kind(item) < MFF_TOOL_KIND_BUTTON Then Exit Sub
	Dim As GtkWidget Ptr box = g_object_get_data(G_OBJECT(item), "mff-tool-box")
	Dim As GtkWidget Ptr lbl = g_object_get_data(G_OBJECT(item), "mff-tool-label")
	Dim As GtkWidget Ptr icon = g_object_get_data(G_OBJECT(item), "mff-tool-icon")
	If box = 0 Then Exit Sub
	Dim As Integer Style = GTK_TOOLBAR_BOTH_HORIZ
	Dim As Boolean InPalette
	Dim As GtkWidget Ptr bar = gtk_widget_get_parent(item)
	While bar
		' GTK_TOOLBAR_ICONS is 0: toolbars and palettes always have a style
		If gtk4compat_tool_kind(bar) = MFF_TOOL_KIND_TOOLBAR OrElse g_object_get_data(G_OBJECT(bar), "mff-tool-palette") <> 0 Then
			Style = CInt(Cast(Integer, g_object_get_data(G_OBJECT(bar), "mff-toolbar-style")))
			InPalette = g_object_get_data(G_OBJECT(bar), "mff-tool-palette") <> 0
			Exit While
		End If
		bar = gtk_widget_get_parent(bar)
	Wend
	Dim As Boolean HasText = lbl <> 0 AndAlso *gtk_label_get_text(GTK_LABEL(lbl)) <> ""
	Dim As Boolean ShowLabel, ShowIcon = True
	Select Case Style
	Case GTK_TOOLBAR_ICONS: ShowLabel = icon = 0
	Case GTK_TOOLBAR_TEXT: ShowLabel = True: ShowIcon = icon = 0 OrElse Not HasText
	Case GTK_TOOLBAR_BOTH: ShowLabel = True
	' A tool palette of GTK3 shows the labels of all items beside the icons
	Case Else: ShowLabel = icon = 0 OrElse InPalette OrElse g_object_get_data(G_OBJECT(item), "mff-tool-important") <> 0
	End Select
	gtk_orientable_set_orientation(GTK_ORIENTABLE(box), IIf(Style = GTK_TOOLBAR_BOTH, GTK_ORIENTATION_VERTICAL, GTK_ORIENTATION_HORIZONTAL))
	If lbl Then gtk_widget_set_visible(lbl, ShowLabel AndAlso HasText)
	If icon Then gtk_widget_set_visible(icon, ShowIcon)
End Sub

Private Sub gtk_toolbar_set_style(ByVal toolbar As GtkWidget Ptr, ByVal style As GtkToolbarStyle)
	If toolbar = 0 Then Exit Sub
	g_object_set_data(G_OBJECT(toolbar), "mff-toolbar-style", Cast(gpointer, style))
	Dim As GtkWidget Ptr child = gtk_widget_get_first_child(toolbar)
	While child
		gtk4compat_tool_button_update child
		child = gtk_widget_get_next_sibling(child)
	Wend
End Sub

Private Function gtk_toolbar_get_style(ByVal toolbar As GtkWidget Ptr) As GtkToolbarStyle
	Return CInt(Cast(Integer, g_object_get_data(G_OBJECT(toolbar), "mff-toolbar-style")))
End Function

Private Sub gtk_toolbar_set_show_arrow(ByVal toolbar As GtkWidget Ptr, ByVal show_arrow As gboolean)
End Sub

Private Sub gtk_toolbar_set_icon_size(ByVal toolbar As GtkWidget Ptr, ByVal icon_size As gint)
End Sub

Private Function gtk_toolbar_get_n_items(ByVal toolbar As GtkWidget Ptr) As gint
	Dim As gint n
	Dim As GtkWidget Ptr child = gtk_widget_get_first_child(toolbar)
	While child
		n += 1
		child = gtk_widget_get_next_sibling(child)
	Wend
	Return n
End Function

Private Function gtk_toolbar_get_nth_item(ByVal toolbar As GtkWidget Ptr, ByVal n As gint) As GtkWidget Ptr
	Dim As GtkWidget Ptr child = gtk_widget_get_first_child(toolbar)
	While child AndAlso n > 0
		n -= 1
		child = gtk_widget_get_next_sibling(child)
	Wend
	Return child
End Function

Private Sub gtk_toolbar_insert(ByVal toolbar As GtkWidget Ptr, ByVal item As GtkWidget Ptr, ByVal pos_ As gint)
	If toolbar = 0 OrElse item = 0 Then Exit Sub
	If gtk_widget_get_parent(item) = toolbar Then Exit Sub
	If gtk_widget_get_parent(item) Then gtk_container_remove(gtk_widget_get_parent(item), item)
	If pos_ < 0 OrElse gtk_widget_get_first_child(toolbar) = 0 Then
		gtk_box_append(GTK_BOX(toolbar), item)
	ElseIf pos_ = 0 Then
		gtk_box_prepend(GTK_BOX(toolbar), item)
	Else
		gtk_box_insert_child_after(GTK_BOX(toolbar), item, gtk_toolbar_get_nth_item(toolbar, pos_ - 1))
	End If
	gtk4compat_tool_button_update item
End Sub

Private Function gtk_tool_item_new() As GtkWidget Ptr
	Dim As GtkWidget Ptr item = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 0)
	g_object_set_data(G_OBJECT(item), "mff-tool-kind", Cast(gpointer, MFF_TOOL_KIND_ITEM))
	Return item
End Function

Private Function gtk_separator_tool_item_new() As GtkWidget Ptr
	Dim As GtkWidget Ptr item = gtk_separator_new(GTK_ORIENTATION_VERTICAL)
	g_object_set_data(G_OBJECT(item), "mff-tool-kind", Cast(gpointer, MFF_TOOL_KIND_SEPARATOR))
	Return item
End Function

' Flat toggle buttons show the checked state hardly: like the toggle tool buttons of GTK3 they are shown pressed
Private Sub gtk4compat_tool_toggle_css()
	Dim As GdkDisplay Ptr display = gdk_display_get_default()
	If display = 0 OrElse g_object_get_data(G_OBJECT(display), "mff-tool-toggle-css") <> 0 Then Exit Sub
	Dim As GtkCssProvider Ptr provider = gtk_css_provider_new()
	gtk4compat_css_provider_load_from_string(provider, "button.mff-tool-toggle:checked { background-color: alpha(currentColor, 0.18); box-shadow: inset 0 0 0 1px alpha(currentColor, 0.35); }")
	gtk_style_context_add_provider_for_display(display, GTK_STYLE_PROVIDER(provider), GTK_STYLE_PROVIDER_PRIORITY_APPLICATION)
	g_object_set_data_full(G_OBJECT(display), "mff-tool-toggle-css", provider, Cast(GDestroyNotify, @g_object_unref))
End Sub

Private Sub gtk4compat_tool_button_setup(ByVal item As GtkWidget Ptr, ByVal Kind As Integer, ByVal icon_widget As GtkWidget Ptr, ByVal label As Const gchar Ptr)
	gtk_button_set_has_frame(GTK_BUTTON(item), False)
	If Kind = MFF_TOOL_KIND_TOGGLE OrElse Kind = MFF_TOOL_KIND_RADIO Then
		gtk_widget_add_css_class(item, "mff-tool-toggle")
		gtk4compat_tool_toggle_css
	End If
	gtk_widget_set_focus_on_click(item, False)
	g_object_set_data(G_OBJECT(item), "mff-tool-kind", Cast(gpointer, Kind))
	Dim As GtkWidget Ptr box = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 4)
	Dim As GtkWidget Ptr lbl = gtk_label_new_with_mnemonic(IIf(label, label, @""))
	If icon_widget Then gtk_box_append(GTK_BOX(box), icon_widget)
	gtk_box_append(GTK_BOX(box), lbl)
	gtk_button_set_child(GTK_BUTTON(item), box)
	g_object_set_data(G_OBJECT(item), "mff-tool-box", box)
	g_object_set_data(G_OBJECT(item), "mff-tool-label", lbl)
	g_object_set_data(G_OBJECT(item), "mff-tool-icon", icon_widget)
	gtk4compat_tool_button_update item
End Sub

Private Function gtk_tool_button_new(ByVal icon_widget As GtkWidget Ptr, ByVal label As Const gchar Ptr) As GtkWidget Ptr
	Dim As GtkWidget Ptr item = gtk_button_new()
	gtk4compat_tool_button_setup item, MFF_TOOL_KIND_BUTTON, icon_widget, label
	Return item
End Function

Private Function gtk_toggle_tool_button_new() As GtkWidget Ptr
	Dim As GtkWidget Ptr item = gtk_toggle_button_new()
	gtk4compat_tool_button_setup item, MFF_TOOL_KIND_TOGGLE, NULL, NULL
	Return item
End Function

Private Function gtk_radio_tool_button_new(ByVal group As GSList Ptr) As GtkWidget Ptr
	Dim As GtkWidget Ptr item = gtk_toggle_button_new()
	gtk4compat_tool_button_setup item, MFF_TOOL_KIND_RADIO, NULL, NULL
	Return item
End Function

Private Function gtk_radio_tool_button_new_from_widget(ByVal group As GtkWidget Ptr) As GtkWidget Ptr
	Dim As GtkWidget Ptr item = gtk_radio_tool_button_new(NULL)
	If group AndAlso GTK_IS_TOGGLE_BUTTON(group) Then gtk_toggle_button_set_group(GTK_TOGGLE_BUTTON(item), GTK_TOGGLE_BUTTON(group))
	Return item
End Function

Private Function gtk_toggle_tool_button_get_active(ByVal item As GtkWidget Ptr) As gboolean
	If item = 0 OrElse GTK_IS_TOGGLE_BUTTON(item) = 0 Then Return False
	Return gtk_toggle_button_get_active(GTK_TOGGLE_BUTTON(item))
End Function

Private Sub gtk_toggle_tool_button_set_active(ByVal item As GtkWidget Ptr, ByVal is_active As gboolean)
	If item AndAlso GTK_IS_TOGGLE_BUTTON(item) Then gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(item), is_active)
End Sub

' The dropdown arrow at the end of a menu tool button shows the menu
Private Sub gtk4compat_menu_tool_button_pressed CDecl(ByVal gesture As GtkGestureClick Ptr, ByVal n_press As gint, ByVal x As gdouble, ByVal y As gdouble, ByVal user_data As gpointer)
	Dim As GtkWidget Ptr item = gtk_event_controller_get_widget(GTK_EVENT_CONTROLLER(gesture))
	Dim As GtkWidget Ptr menu = g_object_get_data(G_OBJECT(item), "mff-tool-menu")
	If menu = 0 Then Exit Sub
	If x >= gtk_widget_get_width(item) - 20 Then
		gtk_gesture_set_state(GTK_GESTURE(gesture), GTK_EVENT_SEQUENCE_CLAIMED)
		gtk4compat_menu_popup_at menu, item, 0, gtk_widget_get_height(item)
	End If
End Sub

Private Function gtk_menu_tool_button_new(ByVal icon_widget As GtkWidget Ptr, ByVal label As Const gchar Ptr) As GtkWidget Ptr
	Dim As GtkWidget Ptr item = gtk_button_new()
	gtk4compat_tool_button_setup item, MFF_TOOL_KIND_MENU, icon_widget, label
	Dim As GtkWidget Ptr box = g_object_get_data(G_OBJECT(item), "mff-tool-box")
	gtk_box_append(GTK_BOX(box), gtk_image_new_from_icon_name("pan-down-symbolic"))
	Dim As GtkGesture Ptr gesture = gtk_gesture_click_new()
	gtk_event_controller_set_propagation_phase(GTK_EVENT_CONTROLLER(gesture), GTK_PHASE_CAPTURE)
	g_signal_connect(gesture, "pressed", G_CALLBACK(@gtk4compat_menu_tool_button_pressed), NULL)
	gtk_widget_add_controller(item, GTK_EVENT_CONTROLLER(gesture))
	Return item
End Function

Private Sub gtk_menu_tool_button_set_menu(ByVal item As GtkWidget Ptr, ByVal menu As GtkWidget Ptr)
	If item = 0 Then Exit Sub
	Dim As GtkWidget Ptr OldMenu = g_object_get_data(G_OBJECT(item), "mff-tool-menu")
	If OldMenu = menu Then Exit Sub
	If OldMenu AndAlso gtk_widget_get_parent(OldMenu) = item Then gtk_widget_unparent(OldMenu)
	g_object_set_data(G_OBJECT(item), "mff-tool-menu", menu)
	If menu Then
		If gtk_widget_get_parent(menu) Then gtk_widget_unparent(menu)
		gtk_widget_set_parent(menu, item)
		If g_object_get_data(G_OBJECT(item), "mff-unparent-connected") = 0 Then
			g_object_set_data(G_OBJECT(item), "mff-unparent-connected", Cast(gpointer, 1))
			g_signal_connect(item, "destroy", G_CALLBACK(@gtk4compat_unparent_popovers), NULL)
		End If
	End If
End Sub

Private Function gtk_menu_tool_button_get_menu(ByVal item As GtkWidget Ptr) As GtkWidget Ptr
	If item = 0 Then Return 0
	Return g_object_get_data(G_OBJECT(item), "mff-tool-menu")
End Function

Private Sub gtk_tool_button_set_label(ByVal item As GtkWidget Ptr, ByVal label As Const gchar Ptr)
	If item = 0 Then Exit Sub
	Dim As GtkWidget Ptr lbl = g_object_get_data(G_OBJECT(item), "mff-tool-label")
	If lbl Then gtk_label_set_text_with_mnemonic(GTK_LABEL(lbl), IIf(label, label, @""))
	gtk4compat_tool_button_update item
End Sub

Private Function gtk_tool_button_get_label(ByVal item As GtkWidget Ptr) As Const gchar Ptr
	If item = 0 Then Return NULL
	Dim As GtkWidget Ptr lbl = g_object_get_data(G_OBJECT(item), "mff-tool-label")
	If lbl = 0 Then Return NULL
	Return gtk_label_get_text(GTK_LABEL(lbl))
End Function

Private Sub gtk_tool_button_set_icon_widget(ByVal item As GtkWidget Ptr, ByVal icon_widget As GtkWidget Ptr)
	If item = 0 Then Exit Sub
	Dim As GtkWidget Ptr box = g_object_get_data(G_OBJECT(item), "mff-tool-box")
	If box = 0 Then Exit Sub
	Dim As GtkWidget Ptr OldIcon = g_object_get_data(G_OBJECT(item), "mff-tool-icon")
	If OldIcon = icon_widget Then Exit Sub
	If OldIcon AndAlso gtk_widget_get_parent(OldIcon) = box Then gtk_box_remove(GTK_BOX(box), OldIcon)
	If icon_widget Then gtk_box_prepend(GTK_BOX(box), icon_widget)
	g_object_set_data(G_OBJECT(item), "mff-tool-icon", icon_widget)
	gtk4compat_tool_button_update item
End Sub

Private Function gtk_tool_button_get_icon_widget(ByVal item As GtkWidget Ptr) As GtkWidget Ptr
	If item = 0 Then Return NULL
	Return g_object_get_data(G_OBJECT(item), "mff-tool-icon")
End Function

' The item is a box (GtkToolItem was a bin): its child (e.g. a combo box) expands too
Private Sub gtk_tool_item_set_expand(ByVal item As GtkWidget Ptr, ByVal expand As gboolean)
	If item = 0 Then Exit Sub
	gtk_widget_set_hexpand(item, expand)
	If gtk4compat_tool_kind(item) = MFF_TOOL_KIND_ITEM Then
		Dim As GtkWidget Ptr child = gtk_widget_get_first_child(item)
		While child
			gtk_widget_set_hexpand(child, expand)
			child = gtk_widget_get_next_sibling(child)
		Wend
	End If
End Sub

Private Sub gtk_tool_item_set_tooltip_text(ByVal item As GtkWidget Ptr, ByVal text As Const gchar Ptr)
	If item = 0 Then Exit Sub
	If text <> 0 AndAlso *text <> "" Then gtk_widget_set_tooltip_text(item, text) Else gtk_widget_set_tooltip_text(item, NULL)
End Sub

Private Sub gtk_tool_item_set_is_important(ByVal item As GtkWidget Ptr, ByVal is_important As gboolean)
	If item = 0 Then Exit Sub
	g_object_set_data(G_OBJECT(item), "mff-tool-important", Cast(gpointer, IIf(is_important, 1, 0)))
	gtk4compat_tool_button_update item
End Sub

Private Sub gtk_tool_item_set_homogeneous(ByVal item As GtkWidget Ptr, ByVal homogeneous As gboolean)
End Sub

Private Function gtk_get_current_event_time() As guint32
	Return 0
End Function

' -----------------------------------------------------------------------------
' Signals of GTK3 which were removed in GTK4: gtk4compat_signal_connect connects
' them with event controllers (the callbacks keep their GTK3 signatures).
' -----------------------------------------------------------------------------
Type Gtk4CompatEventFunc As Function(ByVal widget As GtkWidget Ptr, ByVal e As GdkEvent Ptr, ByVal user_data As gpointer) As gboolean

Type Gtk4CompatEventHandler
	Callback As Gtk4CompatEventFunc
	UserData As gpointer
	Filter1 As Integer
	Filter2 As Integer
	Filter3 As Integer
End Type

Private Function gtk4compat_legacy_event CDecl(ByVal controller As GtkEventController Ptr, ByVal e As GdkEvent Ptr, ByVal h As Gtk4CompatEventHandler Ptr) As gboolean
	If h = 0 OrElse h->Callback = 0 Then Return False
	Dim As Integer t = gdk_event_get_event_type(e)
	If h->Filter1 >= 0 AndAlso t <> h->Filter1 AndAlso t <> h->Filter2 AndAlso t <> h->Filter3 Then Return False
	Dim As Gtk4CompatLoops Ptr p = gtk4compat_loops()
	Dim As Any Ptr OldEventWidget = p->CurrentEventWidget
	p->CurrentEventWidget = gtk_event_controller_get_widget(controller)
	Dim As gboolean Result = h->Callback(gtk_event_controller_get_widget(controller), e, h->UserData)
	p->CurrentEventWidget = OldEventWidget
	Return Result
End Function

Private Sub gtk4compat_handler_enter CDecl(ByVal controller As GtkEventController Ptr, ByVal h As Gtk4CompatEventHandler Ptr)
	If h AndAlso h->Callback Then h->Callback(gtk_event_controller_get_widget(controller), NULL, h->UserData)
End Sub

Private Sub gtk4compat_handler_motion_enter CDecl(ByVal controller As GtkEventController Ptr, ByVal x As gdouble, ByVal y As gdouble, ByVal h As Gtk4CompatEventHandler Ptr)
	If h AndAlso h->Callback Then h->Callback(gtk_event_controller_get_widget(controller), NULL, h->UserData)
End Sub

' The event of the current signal (e.g. in a callback of a removed signal), 0 if none
Private Function gtk4compat_event_window(ByVal e As GdkEvent Ptr) As GdkSurface Ptr
	Return Cast(GdkSurface Ptr, gtk4compat_loops()->CurrentEventWidget)
End Function

Private Function gtk4compat_new_handler(ByVal c_handler As Any Ptr, ByVal user_data As gpointer, ByVal Filter1 As Integer = -1, ByVal Filter2 As Integer = -1, ByVal Filter3 As Integer = -1) As Gtk4CompatEventHandler Ptr
	Dim As Gtk4CompatEventHandler Ptr h = g_malloc0(SizeOf(Gtk4CompatEventHandler))
	h->Callback = c_handler
	h->UserData = user_data
	h->Filter1 = Filter1
	h->Filter2 = IIf(Filter2 = -1, Filter1, Filter2)
	h->Filter3 = IIf(Filter3 = -1, Filter1, Filter3)
	Return h
End Function

Private Function gtk4compat_signal_connect(ByVal instance As gpointer, ByVal detailed_signal As Const gchar Ptr, ByVal c_handler As GCallback, ByVal user_data As gpointer) As gulong
	If instance = 0 OrElse detailed_signal = 0 Then Return 0
	Dim As guint SignalId
	Dim As GQuark SignalDetail
	' Existing signals are connected normally
	If g_signal_parse_name(detailed_signal, G_OBJECT_TYPE(instance), @SignalId, @SignalDetail, False) Then
		Return g_signal_connect_data(instance, detailed_signal, c_handler, user_data, NULL, 0)
	End If
	Dim As String SignalName = *detailed_signal
	Dim As Integer Filter1 = -2, Filter2 = -1, Filter3 = -1
	' Entries delegate the text editing to a GtkText
	If GTK_IS_EDITABLE(instance) Then
		Dim As GtkEditable Ptr delegate_ = gtk_editable_get_delegate(GTK_EDITABLE(instance))
		If delegate_ <> 0 AndAlso g_signal_parse_name(detailed_signal, G_OBJECT_TYPE(delegate_), @SignalId, @SignalDetail, False) Then
			Return g_signal_connect_data(delegate_, detailed_signal, c_handler, user_data, NULL, 0)
		End If
	End If
	Select Case SignalName
	Case "draw"
		If GTK_IS_WIDGET(instance) Then mff_widget_set_draw_func(instance, c_handler, user_data)
		Return 0
	Case "size-allocate"
		If GTK_IS_WIDGET(instance) Then mff_widget_set_size_allocate_func(instance, c_handler, user_data)
		Return 0
	Case "expose-event", "configure-event", "screen-changed", "window-state-event", "style-set", "style-updated", "delete-event", "destroy-event", "grab-broken-event", "visibility-notify-event", "damage-event", "property-notify-event", "selection-clear-event", "selection-request-event", "selection-notify-event", "proximity-in-event", "proximity-out-event", "client-event", "drag-data-received", "drag-data-get", "drag-begin", "drag-end", "drag-motion", "drag-drop", "drag-leave", "popup-menu"
		Return 0
	Case "event", "event-after": Filter1 = -1
	Case "button-press-event": Filter1 = GDK_BUTTON_PRESS
	Case "button-release-event": Filter1 = GDK_BUTTON_RELEASE
	Case "key-press-event": Filter1 = GDK_KEY_PRESS
	Case "key-release-event": Filter1 = GDK_KEY_RELEASE
	Case "motion-notify-event": Filter1 = GDK_MOTION_NOTIFY
	Case "scroll-event": Filter1 = GDK_SCROLL
	Case "touch-event": Filter1 = GDK_TOUCH_BEGIN: Filter2 = GDK_TOUCH_UPDATE: Filter3 = GDK_TOUCH_END
	Case "focus-in-event", "focus-out-event"
		Dim As GtkEventController Ptr controller = gtk_event_controller_focus_new()
		Dim As Gtk4CompatEventHandler Ptr h = gtk4compat_new_handler(c_handler, user_data)
		g_object_set_data_full(G_OBJECT(controller), "mff-handler", h, Cast(GDestroyNotify, @g_free))
		Dim As gulong Result = g_signal_connect(controller, IIf(SignalName = "focus-in-event", @"enter", @"leave"), G_CALLBACK(@gtk4compat_handler_enter), h)
		gtk_widget_add_controller(instance, controller)
		Return Result
	Case "enter-notify-event", "leave-notify-event"
		Dim As GtkEventController Ptr controller = gtk_event_controller_motion_new()
		Dim As Gtk4CompatEventHandler Ptr h = gtk4compat_new_handler(c_handler, user_data)
		g_object_set_data_full(G_OBJECT(controller), "mff-handler", h, Cast(GDestroyNotify, @g_free))
		Dim As gulong Result
		If SignalName = "enter-notify-event" Then
			Result = g_signal_connect(controller, "enter", G_CALLBACK(@gtk4compat_handler_motion_enter), h)
		Else
			Result = g_signal_connect(controller, "leave", G_CALLBACK(@gtk4compat_handler_enter), h)
		End If
		gtk_widget_add_controller(instance, controller)
		Return Result
	End Select
	' Other removed signals are ignored
	If Filter1 = -2 Then Return 0
	If GTK_IS_WIDGET(instance) = 0 Then Return 0
	' Events through a legacy controller
	Dim As GtkEventController Ptr controller = gtk_event_controller_legacy_new()
	Dim As Gtk4CompatEventHandler Ptr h = gtk4compat_new_handler(c_handler, user_data, Filter1, Filter2, Filter3)
	g_object_set_data_full(G_OBJECT(controller), "mff-handler", h, Cast(GDestroyNotify, @g_free))
	Dim As gulong Result = g_signal_connect(controller, "event", G_CALLBACK(@gtk4compat_legacy_event), h)
	gtk_widget_add_controller(instance, controller)
	Return Result
End Function

' The "event" signal of GTK3 is emitted on the target widget before its own handlers (e.g. the click gesture
' of a button), a handler returning True stops the event. gtk4compat_signal_connect_capture emulates this with
' controllers in the capture phase: from the widgets connected so, only the innermost one under the pointer
' (during a press: the pressed one, like the implicit grab) gets the pointer events.
Private Function gtk4compat_capture_ancestor(ByVal w As GtkWidget Ptr) As GtkWidget Ptr
	While w
		If g_object_get_data(G_OBJECT(w), "mff-capture-event") Then Return w
		w = gtk_widget_get_parent(w)
	Wend
	Return 0
End Function

Private Function gtk4compat_capture_call(ByVal widget As GtkWidget Ptr, ByVal e As GdkEvent Ptr, ByVal h As Gtk4CompatEventHandler Ptr) As gboolean
	If h = 0 OrElse h->Callback = 0 Then Return False
	Dim As Gtk4CompatLoops Ptr p = gtk4compat_loops()
	Dim As Any Ptr OldEventWidget = p->CurrentEventWidget
	p->CurrentEventWidget = widget
	Dim As gboolean Result = h->Callback(widget, e, h->UserData)
	p->CurrentEventWidget = OldEventWidget
	Return Result
End Function

Private Function gtk4compat_capture_event CDecl(ByVal controller As GtkEventController Ptr, ByVal e As GdkEvent Ptr, ByVal h As Gtk4CompatEventHandler Ptr) As gboolean
	' The pressed widget and its handler: until the release they get the pointer events (like the implicit grab of GTK3)
	Static As GtkWidget Ptr PressTarget
	Static As Gtk4CompatEventHandler Ptr PressHandler
	' The event already handled by the pressed widget (the controllers of the ancestors are called too)
	Static As GdkEvent Ptr HandledEvent
	Static As gboolean HandledResult
	Static As guint32 HandledTime
	Static As Integer HandledType
	Dim As GtkWidget Ptr widget = gtk_event_controller_get_widget(controller)
	Dim As GtkWidget Ptr target
	Dim As Integer t = gdk_event_get_event_type(e)
	Select Case t
	Case GDK_BUTTON_RELEASE, GDK_MOTION_NOTIFY, GDK_SCROLL
		If PressTarget <> 0 AndAlso PressHandler <> 0 Then
			' GTK4 sends the release to the widget which got the press from GTK (e.g. a button instead of its label):
			' the first connected widget on the way gives it to the pressed one
			If e = HandledEvent AndAlso gdk_event_get_time(e) = HandledTime AndAlso t = HandledType Then Return HandledResult
			If widget <> PressTarget AndAlso gtk_widget_is_ancestor(PressTarget, widget) = 0 Then Return False
			HandledEvent = e: HandledTime = gdk_event_get_time(e): HandledType = t
			HandledResult = gtk4compat_capture_call(PressTarget, e, PressHandler)
			If t = GDK_BUTTON_RELEASE Then PressTarget = 0: PressHandler = 0
			Return HandledResult
		End If
	End Select
	Select Case t
	Case GDK_BUTTON_PRESS, GDK_BUTTON_RELEASE, GDK_MOTION_NOTIFY, GDK_SCROLL
		Dim As GtkNative Ptr native = gtk_widget_get_native(widget)
		Dim As gdouble ex, ey, nx, ny
		If native <> 0 AndAlso gdk_event_get_position(e, @ex, @ey) Then
			gtk_native_get_surface_transform(native, @nx, @ny)
			target = gtk4compat_capture_ancestor(gtk_widget_pick(GTK_WIDGET(native), ex - nx, ey - ny, GTK_PICK_DEFAULT))
		End If
	Case GDK_KEY_PRESS, GDK_KEY_RELEASE
		Dim As GtkRoot Ptr root = gtk_widget_get_root(widget)
		If root Then target = gtk4compat_capture_ancestor(gtk_root_get_focus(root))
	Case Else
		' Crossing and focus events are sent to each widget
		target = widget
	End Select
	If target <> widget Then Return False
	If t = GDK_BUTTON_PRESS Then PressTarget = widget: PressHandler = h
	Return gtk4compat_capture_call(widget, e, h)
End Function

Private Function gtk4compat_signal_connect_capture(ByVal instance As gpointer, ByVal detailed_signal As Const gchar Ptr, ByVal c_handler As GCallback, ByVal user_data As gpointer) As gulong
	If instance = 0 OrElse GTK_IS_WIDGET(instance) = 0 OrElse *detailed_signal <> "event" Then Return gtk4compat_signal_connect(instance, detailed_signal, c_handler, user_data)
	g_object_set_data(G_OBJECT(instance), "mff-capture-event", Cast(gpointer, 1))
	Dim As GtkEventController Ptr controller = gtk_event_controller_legacy_new()
	gtk_event_controller_set_propagation_phase(controller, GTK_PHASE_CAPTURE)
	Dim As Gtk4CompatEventHandler Ptr h = gtk4compat_new_handler(c_handler, user_data)
	g_object_set_data_full(G_OBJECT(controller), "mff-handler", h, Cast(GDestroyNotify, @g_free))
	Dim As gulong Result = g_signal_connect(controller, "event", G_CALLBACK(@gtk4compat_capture_event), h)
	gtk_widget_add_controller(instance, controller)
	Return Result
End Function

Private Function gtk4compat_signal_connect_after(ByVal instance As gpointer, ByVal detailed_signal As Const gchar Ptr, ByVal c_handler As GCallback, ByVal user_data As gpointer) As gulong
	Select Case *detailed_signal
	Case "draw", "size-allocate", "event", "event-after", "button-press-event", "button-release-event", "key-press-event", "key-release-event", "motion-notify-event", "scroll-event", "focus-in-event", "focus-out-event", "enter-notify-event", "leave-notify-event", "expose-event", "configure-event"
		Return gtk4compat_signal_connect(instance, detailed_signal, c_handler, user_data)
	End Select
	Dim As guint SignalId
	Dim As GQuark SignalDetail
	If g_signal_parse_name(detailed_signal, G_OBJECT_TYPE(instance), @SignalId, @SignalDetail, False) = False Then Return 0
	Return g_signal_connect_data(instance, detailed_signal, c_handler, user_data, NULL, G_CONNECT_AFTER)
End Function

' GTK3 widgets: radio buttons are grouped check buttons in GTK4
Type GtkRadioButton As GtkCheckButton
#define GTK_RADIO_BUTTON(obj) GTK_CHECK_BUTTON(obj)
#define GTK_IS_RADIO_BUTTON(obj) GTK_IS_CHECK_BUTTON(obj)

Private Function gtk_radio_button_new_with_label(ByVal group As GSList Ptr, ByVal label As Const gchar Ptr) As GtkWidget Ptr
	Return gtk_check_button_new_with_label(label)
End Function

Private Function gtk_radio_button_new_with_mnemonic(ByVal group As GSList Ptr, ByVal label As Const gchar Ptr) As GtkWidget Ptr
	Return gtk_check_button_new_with_mnemonic(label)
End Function

Private Function gtk_radio_button_new(ByVal group As GSList Ptr) As GtkWidget Ptr
	Return gtk_check_button_new()
End Function

Private Sub gtk_radio_button_join_group(ByVal radio_button As GtkCheckButton Ptr, ByVal group_source As GtkCheckButton Ptr)
	gtk_check_button_set_group(radio_button, group_source)
End Sub

#define GTK_TRUE 1
#define GTK_FALSE 0
Const GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER = 3

Private Sub gtk_range_set_min_slider_size(ByVal range_ As GtkRange Ptr, ByVal min_size As gint)
End Sub

Private Sub gtk_file_chooser_unselect_all(ByVal chooser As GtkFileChooser Ptr)
End Sub

Private Sub gtk_label_set_angle(ByVal label As GtkLabel Ptr, ByVal angle As gdouble)
End Sub

' Calendar: GDateTime in GTK4 (the month is 0-based like in GTK3)
Enum GtkCalendarDisplayOptions
	GTK_CALENDAR_SHOW_HEADING = 1
	GTK_CALENDAR_SHOW_DAY_NAMES = 2
	GTK_CALENDAR_NO_MONTH_CHANGE = 4
	GTK_CALENDAR_SHOW_WEEK_NUMBERS = 8
	GTK_CALENDAR_SHOW_DETAILS = 32
End Enum

Private Sub gtk4compat_calendar_get_date(ByVal calendar As GtkCalendar Ptr, ByVal year_ As guint Ptr, ByVal month_ As guint Ptr, ByVal day_ As guint Ptr)
	Dim As GDateTime Ptr dt = gtk_calendar_get_date(calendar)
	If year_ Then *year_ = g_date_time_get_year(dt)
	If month_ Then *month_ = g_date_time_get_month(dt) - 1
	If day_ Then *day_ = g_date_time_get_day_of_month(dt)
	g_date_time_unref(dt)
End Sub

Private Sub gtk4compat_calendar_select_date(ByVal calendar As GtkCalendar Ptr, ByVal year_ As gint, ByVal month_ As gint, ByVal day_ As gint)
	Dim As GDateTime Ptr dt = g_date_time_new_local(year_, month_ + 1, 1, 0, 0, 0)
	If dt = 0 Then Exit Sub
	Dim As gint LastDay = g_date_time_get_day_of_month(g_date_time_add_days(g_date_time_add_months(dt, 1), -1))
	g_date_time_unref(dt)
	dt = g_date_time_new_local(year_, month_ + 1, IIf(day_ > LastDay, LastDay, IIf(day_ < 1, 1, day_)), 0, 0, 0)
	gtk_calendar_select_day(calendar, dt)
	g_date_time_unref(dt)
End Sub

Private Sub gtk_calendar_select_month(ByVal calendar As GtkCalendar Ptr, ByVal month_ As guint, ByVal year_ As guint)
	Dim As guint y, m, d
	gtk4compat_calendar_get_date(calendar, @y, @m, @d)
	gtk4compat_calendar_select_date(calendar, year_, month_, d)
End Sub

Private Sub gtk4compat_calendar_select_day(ByVal calendar As GtkCalendar Ptr, ByVal day_ As guint)
	Dim As guint y, m, d
	gtk4compat_calendar_get_date(calendar, @y, @m, @d)
	gtk4compat_calendar_select_date(calendar, y, m, day_)
End Sub

Private Function gtk_calendar_get_display_options(ByVal calendar As GtkCalendar Ptr) As gint
	Dim As gint Options
	If gtk_calendar_get_show_heading(calendar) Then Options Or= GTK_CALENDAR_SHOW_HEADING
	If gtk_calendar_get_show_day_names(calendar) Then Options Or= GTK_CALENDAR_SHOW_DAY_NAMES
	If gtk_calendar_get_show_week_numbers(calendar) Then Options Or= GTK_CALENDAR_SHOW_WEEK_NUMBERS
	Return Options
End Function

Private Sub gtk_calendar_set_display_options(ByVal calendar As GtkCalendar Ptr, ByVal flags As gint)
	gtk_calendar_set_show_heading(calendar, (flags And GTK_CALENDAR_SHOW_HEADING) <> 0)
	gtk_calendar_set_show_day_names(calendar, (flags And GTK_CALENDAR_SHOW_DAY_NAMES) <> 0)
	gtk_calendar_set_show_week_numbers(calendar, (flags And GTK_CALENDAR_SHOW_WEEK_NUMBERS) <> 0)
End Sub

' Icon infos are icon paintables in GTK4
Type GtkIconInfo As GtkIconPaintable

Private Function gtk_icon_info_load_icon(ByVal icon_info As GtkIconPaintable Ptr, ByVal error_ As GError Ptr Ptr) As GdkPixbuf Ptr
	If icon_info = 0 Then Return NULL
	Dim As GdkPixbuf Ptr pixbuf
	Dim As GFile Ptr file = gtk_icon_paintable_get_file(icon_info)
	If file = 0 Then Return NULL
	Dim As gchar Ptr path = g_file_get_path(file)
	If path Then
		pixbuf = gdk_pixbuf_new_from_file(path, error_)
		g_free(path)
	Else
		Dim As gchar Ptr uri = g_file_get_uri(file)
		If uri AndAlso Left(*uri, 11) = "resource://" Then pixbuf = gdk_pixbuf_new_from_resource(uri + 11, error_)
		g_free(uri)
	End If
	g_object_unref(file)
	Return pixbuf
End Function

Private Function gtk4compat_icon_theme_lookup_icon(ByVal icon_theme As GtkIconTheme Ptr, ByVal icon_name As Const gchar Ptr, ByVal size As gint, ByVal flags As gint) As GtkIconPaintable Ptr
	If icon_theme = 0 OrElse icon_name = 0 Then Return NULL
	If gtk_icon_theme_has_icon(icon_theme, icon_name) = False Then Return NULL
	Return gtk_icon_theme_lookup_icon(icon_theme, icon_name, NULL, size, 1, GTK_TEXT_DIR_NONE, 0)
End Function

' -----------------------------------------------------------------------------
' Tool palettes: a vertical box of expanders (groups) with flow boxes of tool buttons
' -----------------------------------------------------------------------------
Type GtkToolPalette As GtkWidget
Type GtkToolItemGroup As GtkWidget
#define GTK_TOOL_PALETTE(obj) Cast(GtkWidget Ptr, obj)
#define GTK_TOOL_ITEM_GROUP(obj) Cast(GtkWidget Ptr, obj)
#define GTK_IS_TOOL_PALETTE(obj) (-(g_object_get_data(G_OBJECT(obj), "mff-tool-palette") <> 0))
#define GTK_IS_TOOL_ITEM_GROUP(obj) (-(g_object_get_data(G_OBJECT(obj), "mff-group-box") <> 0))

Private Function gtk_tool_palette_new() As GtkWidget Ptr
	Dim As GtkWidget Ptr palette_ = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0)
	g_object_set_data(G_OBJECT(palette_), "mff-tool-palette", Cast(gpointer, 1))
	g_object_set_data(G_OBJECT(palette_), "mff-toolbar-style", Cast(gpointer, GTK_TOOLBAR_BOTH_HORIZ))
	Return palette_
End Function

Private Sub gtk4compat_tool_update_all(ByVal widget As GtkWidget Ptr)
	Dim As GtkWidget Ptr child = gtk_widget_get_first_child(widget)
	While child
		gtk4compat_tool_button_update child
		gtk4compat_tool_update_all child
		child = gtk_widget_get_next_sibling(child)
	Wend
End Sub

Private Sub gtk_tool_palette_set_style(ByVal palette_ As GtkWidget Ptr, ByVal style As GtkToolbarStyle)
	If palette_ = 0 Then Exit Sub
	g_object_set_data(G_OBJECT(palette_), "mff-toolbar-style", Cast(gpointer, style))
	gtk4compat_tool_update_all palette_
End Sub

Private Function gtk_tool_item_group_new(ByVal label As Const gchar Ptr) As GtkWidget Ptr
	Dim As GtkWidget Ptr group = gtk_expander_new(label)
	Dim As GtkWidget Ptr flowbox = gtk_flow_box_new()
	gtk_flow_box_set_selection_mode(GTK_FLOW_BOX(flowbox), GTK_SELECTION_NONE)
	gtk_flow_box_set_homogeneous(GTK_FLOW_BOX(flowbox), False)
	gtk_flow_box_set_max_children_per_line(GTK_FLOW_BOX(flowbox), 1000)
	gtk_flow_box_set_row_spacing(GTK_FLOW_BOX(flowbox), 0)
	gtk_flow_box_set_column_spacing(GTK_FLOW_BOX(flowbox), 0)
	gtk_widget_set_valign(flowbox, GTK_ALIGN_START)
	gtk_expander_set_child(GTK_EXPANDER(group), flowbox)
	gtk_expander_set_expanded(GTK_EXPANDER(group), True)
	g_object_set_data(G_OBJECT(group), "mff-group-box", flowbox)
	Return group
End Function

Private Sub gtk_tool_item_group_set_label(ByVal group As GtkWidget Ptr, ByVal label As Const gchar Ptr)
	If group Then gtk_expander_set_label(GTK_EXPANDER(group), label)
End Sub

Private Sub gtk_tool_item_group_set_collapsed(ByVal group As GtkWidget Ptr, ByVal collapsed As gboolean)
	If group Then gtk_expander_set_expanded(GTK_EXPANDER(group), collapsed = False)
End Sub

Private Function gtk_tool_item_group_get_collapsed(ByVal group As GtkWidget Ptr) As gboolean
	If group = 0 Then Return False
	Return gtk_expander_get_expanded(GTK_EXPANDER(group)) = False
End Function

Private Sub gtk_tool_item_group_insert(ByVal group As GtkWidget Ptr, ByVal item As GtkWidget Ptr, ByVal position As gint)
	If group = 0 OrElse item = 0 Then Exit Sub
	Dim As GtkWidget Ptr flowbox = g_object_get_data(G_OBJECT(group), "mff-group-box")
	If flowbox = 0 Then Exit Sub
	gtk_flow_box_insert(GTK_FLOW_BOX(flowbox), item, position)
	gtk4compat_tool_button_update item
End Sub

Private Function gtk_tool_item_group_get_n_items(ByVal group As GtkWidget Ptr) As guint
	Dim As GtkWidget Ptr flowbox = g_object_get_data(G_OBJECT(group), "mff-group-box")
	If flowbox = 0 Then Return 0
	Dim As guint n
	Dim As GtkWidget Ptr child = gtk_widget_get_first_child(flowbox)
	While child
		n += 1
		child = gtk_widget_get_next_sibling(child)
	Wend
	Return n
End Function

' Pointer position (GdkDeviceManager was removed): relative to the window of the current event
Type GdkDeviceManager As GdkSeat

Private Function gdk_display_get_device_manager(ByVal display As GdkDisplay Ptr) As GdkSeat Ptr
	Return gdk_display_get_default_seat(display)
End Function

Private Function gdk_device_manager_get_client_pointer(ByVal device_manager As GdkSeat Ptr) As GdkDevice Ptr
	If device_manager = 0 Then Return 0
	Return gdk_seat_get_pointer(device_manager)
End Function

Private Sub gdk_device_get_position(ByVal device As GdkDevice Ptr, ByVal screen_ As Any Ptr, ByVal x As gint Ptr, ByVal y As gint Ptr)
	Dim As gdouble px, py
	Dim As GtkWidget Ptr widget = gtk4compat_loops()->CurrentEventWidget
	If device <> 0 AndAlso widget <> 0 AndAlso gtk_widget_get_native(widget) <> 0 Then
		gdk_surface_get_device_position(gtk_native_get_surface(gtk_widget_get_native(widget)), device, @px, @py, NULL)
	End If
	If x Then *x = px
	If y Then *y = py
End Sub

Private Sub gtk_text_buffer_insert_pixbuf(ByVal buffer As GtkTextBuffer Ptr, ByVal iter As GtkTextIter Ptr, ByVal pixbuf As GdkPixbuf Ptr)
	If pixbuf = 0 Then Exit Sub
	Dim As GdkTexture Ptr texture = gdk_texture_new_for_pixbuf(pixbuf)
	gtk_text_buffer_insert_paintable(buffer, iter, GDK_PAINTABLE(texture))
	g_object_unref(texture)
End Sub

' All signal connections of the following code go through gtk4compat_signal_connect:
' the removed GTK3 signals are emulated, unknown signals are ignored
#undef g_signal_connect
#undef g_signal_connect_after
#define g_signal_connect(instance, detailed_signal, c_handler, data) gtk4compat_signal_connect((instance), (detailed_signal), Cast(GCallback, (c_handler)), (data))
#define g_signal_connect_after(instance, detailed_signal, c_handler, data) gtk4compat_signal_connect_after((instance), (detailed_signal), Cast(GCallback, (c_handler)), (data))

#endif
#endif
