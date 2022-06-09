'###############################################################################
'#  Component.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'###############################################################################

#include once "Component.bi"

Namespace My.Sys.ComponentModel
	Private Function MarginsType.ToString ByRef As WString
		WLet(FTemp, This.Left & "; " & This.Top & "; " & This.Right & "; " & This.Bottom)
		Return *FTemp
	End Function
	
	Private Function Component.ReadProperty(ByRef PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "designmode": Return @FDesignMode
		Case "classancestor": Return FClassAncestor
		Case "tag": Return Tag
			#ifdef __USE_GTK__
			Case "handle": Return widget
			Case "widget": Return widget
			Case "layoutwidget": Return layoutwidget
			Case "overlaywidget": Return overlaywidget
			Case "eventboxwidget": Return eventboxwidget
			#else
			Case "handle": Return @FHandle
			#endif
		Case "left": FLeft = This.Left: Return @FLeft
		Case "top": FTop = This.Top: Return @FTop
		Case "width": FWidth = This.Width: Return @FWidth
		Case "height": FHeight = This.Height: Return @FHeight
		Case "parent": Return FParent
		Case "margins": Return @Margins
		Case "margins.left": Return @Margins.Left
		Case "margins.right": Return @Margins.Right
		Case "margins.top": Return @Margins.Top
		Case "margins.bottom": Return @Margins.Bottom
		Case "extramargins": Return @ExtraMargins
		Case "extramargins.left": Return @ExtraMargins.Left
		Case "extramargins.right": Return @ExtraMargins.Right
		Case "extramargins.top": Return @ExtraMargins.Top
		Case "extramargins.bottom": Return @ExtraMargins.Bottom
		Case "name": Return FName
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Private Function Component.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		If Value <> 0 Then
			Select Case LCase(PropertyName)
			Case "tag": This.Tag = Value
			Case "name": This.Name = QWString(Value)
			Case "designmode": This.DesignMode = QBoolean(Value)
				#ifdef __USE_GTK__
				Case "handle": This.Handle = Value
				Case "widget": This.widget = Value
				Case "layoutwidget": This.layoutwidget = Value
				Case "overlaywidget": This.overlaywidget = Value
				Case "eventboxwidget": This.eventboxwidget = Value
				#elseif defined(__USE_JNI__)
				Case "handle": This.Handle = *Cast(jobject Ptr, Value)
				#else
				Case "handle": This.Handle = *Cast(HWND Ptr, Value)
				#endif
			Case "left": This.Left = QInteger(Value)
			Case "top": This.Top = QInteger(Value)
			Case "width": This.Width = QInteger(Value)
			Case "height": This.Height = QInteger(Value)
			Case "parent": This.Parent = Value
			Case "margins.left": This.Margins.Left = QInteger(Value)
			Case "margins.right": This.Margins.Right = QInteger(Value)
			Case "margins.top": This.Margins.Top = QInteger(Value)
			Case "margins.bottom": This.Margins.Bottom = QInteger(Value)
			Case "extramargins.left": This.ExtraMargins.Left = QInteger(Value)
			Case "extramargins.right": This.ExtraMargins.Right = QInteger(Value)
			Case "extramargins.top": This.ExtraMargins.Top = QInteger(Value)
			Case "extramargins.bottom": This.ExtraMargins.Bottom = QInteger(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		End If
		Return True
	End Function
	
	#ifndef GetTopLevel_Off
		Private Function Component.GetTopLevel As Component Ptr
			If FParent = 0 Then
				Return @This
			Else
				Return FParent->GetTopLevel()
			End If
		End Function
	#endif
	
	#ifndef Parent_Off
		Private Property Component.Parent As Component Ptr
			Return FParent
		End Property
		
		Private Property Component.Parent(Value As Component Ptr)
			If FParent <> Value Then
				FParent = Value
				#ifdef __USE_GTK__
					If FDesignMode AndAlso widget <> 0 AndAlso gtk_is_widget(widget) AndAlso Value <> 0 AndAlso Value->layoutwidget <> 0 Then
						If gtk_widget_get_parent(widget) <> Value->layoutwidget Then
							If gtk_widget_get_parent(widget) <> 0 Then gtk_widget_unparent(widget)
							gtk_layout_put(GTK_LAYOUT(Value->layoutwidget), widget, FLeft, FTop)
						Else
							gtk_layout_move(GTK_LAYOUT(Value->layoutwidget), widget, FLeft, FTop)
						End If
					End If
				#elseif defined(__USE_WINAPI__)
					If FDesignMode AndAlso FHandle <> 0 AndAlso Value <> 0 AndAlso Value->Handle <> 0 Then
						If GetParent(FHandle) <> Value->Handle Then
							SetParent FHandle, Value->Handle
						End If
					End If
				#endif
			End If
		End Property
	#endif
	
	Private Function Component.ClassAncestor ByRef As WString
		Return WGet(FClassAncestor)
	End Function
	
	Private Property Component.DesignMode As Boolean
		Return FDesignMode
	End Property
	
	Private Property Component.DesignMode(Value As Boolean)
		FDesignMode = Value
	End Property
	
	Private Property Component.Name ByRef As WString
		Return WGet(FName)
	End Property
	
	Private Property Component.Name(ByRef Value As WString)
		WLet(FName, Value)
		#ifdef __USE_GTK__
			If gtk_is_widget(widget) Then gtk_widget_set_name(widget, Value)
		#endif
	End Property
	
	#ifndef Handle_Off
		#ifdef __USE_GTK__
			Private Property Component.Handle As GtkWidget Ptr
				Return widget
			End Property
			
			Private Property Component.Handle(Value As GtkWidget Ptr)
				widget = Value
			End Property
			
			Private Property Component.LayoutHandle As GtkWidget Ptr
				Return layoutwidget
			End Property
			
			Private Property Component.LayoutHandle(Value As GtkWidget Ptr)
				layoutwidget = Value
			End Property
		#elseif defined(__USE_JNI__)
			Private Property Component.Handle As jobject
				Return FHandle
			End Property
			
			Private Property Component.Handle(Value As jobject)
				FHandle = Value
			End Property
			
			Private Property Component.LayoutHandle As jobject
				Return layoutview
			End Property
			
			Private Property Component.LayoutHandle(Value As jobject)
				layoutview = Value
			End Property
		#elseif defined(__USE_WINAPI__)
			Private Property Component.Handle As HWND
				Return FHandle
			End Property
			
			Private Property Component.Handle(Value As HWND)
				FHandle = Value
			End Property
			
			Private Property Component.LayoutHandle As HWND
				Return FHandle
			End Property
			
			Private Property Component.LayoutHandle(Value As HWND)
				FHandle = Value
			End Property
		#endif
	#endif
	
	#ifndef Move_Off
		Private Sub Component.Move(cLeft As Integer, cTop As Integer, cWidth As Integer, cHeight As Integer)
			'#ifdef __USE_GTK__
			'	Dim As Integer iLeft = FLeft, iTop = FTop, iWidth = FWidth, iHeight = FHeight
			'#else
				Dim As Integer iLeft = cLeft, iTop = cTop, iWidth = cWidth, iHeight = cHeight
			'#endif
			If FParent Then
				Dim As Component Ptr cParent = FParent
				If cParent Then
					#ifdef __USE_GTK__
						'If Not FDesignMode Then
							If cParent->widget AndAlso gtk_is_frame(cParent->widget) Then
								iTop -= 20
							End If
						'End If
					#endif
'					iLeft = iLeft + cParent->Margins.Left
'					iTop = iTop + cParent->Margins.Top
					'iWidth = iWidth - cParent->Margins.Left - cParent->Margins.Right
					'iHeight = iHeight - cParent->Margins.Top - cParent->Margins.Bottom
					'iWidth = Min(iWidth, Max(0, cParent->Width - iLeft - cParent->Margins.Right))
					'iHeight = Min(iHeight, Max(0, cParent->Height - iTop - cParent->Margins.Bottom))
				End If
			End If
			#ifdef __USE_GTK__
'				Dim allocation As GtkAllocation
'				allocation.x = iLeft
'				allocation.y = iTop
'				allocation.width = iWidth
'				allocation.height = iHeight
				'gtk_widget_set_allocation(widget, @allocation)
				If iWidth <= 1 Or iHeight <= 1 Then
					Exit Sub
				End If
				If widget Then
					If gtk_is_widget(widget) AndAlso gtk_widget_is_toplevel(widget) Then
						gtk_window_move(GTK_WINDOW(widget), iLeft, iTop)
						gtk_window_resize(GTK_WINDOW(widget), Max(0, iWidth), Max(0, iHeight - 20))
						'gtk_window_resize(GTK_WINDOW(widget), Max(1, iWidth), Max(1, iHeight))
						'RequestAlign iWidth, iHeight
					Else
						'gdk_window_move(gtk_widget_get_window (widget), iLeft, iTop)
						'gdk_window_resize(gtk_widget_get_window (widget), Max(1, iWidth), Max(1, iHeight))
						'If Parent AndAlso Parent->fixedwidget Then gtk_fixed_move(gtk_fixed(Parent->fixedwidget), widget, iLeft, iTop)
						Dim As GtkWidget Ptr CtrlWidget = IIf(scrolledwidget, scrolledwidget, IIf(overlaywidget, overlaywidget, IIf(layoutwidget AndAlso gtk_widget_get_parent(layoutwidget) <> widget, layoutwidget, IIf(eventboxwidget, eventboxwidget, widget))))
						If Parent Then
							If Parent->layoutwidget AndAlso gtk_is_layout(gtk_widget_get_parent(CtrlWidget)) Then
								'gtk_widget_size_allocate(IIF(scrolledwidget, scrolledwidget, widget), @allocation)
								gtk_layout_move(gtk_layout(Parent->layoutwidget), CtrlWidget, iLeft, iTop)
							ElseIf Parent->fixedwidget Then
								gtk_fixed_move(gtk_fixed(Parent->fixedwidget), CtrlWidget, iLeft, iTop)
							ElseIf gtk_is_text_view(Parent->widget) Then
								gtk_text_view_move_child(gtk_text_view(Parent->widget), CtrlWidget, iLeft, iTop)
							End If
						End If
						'gtk_widget_set_size_allocation(widget, @allocation)
						'gtk_widget_set_size_request(widget, Max(0, iWidth), Max(0, iHeight))
						gtk_widget_set_size_request(CtrlWidget, Max(0, iWidth), Max(0, iHeight))
						'gtk_widget_set_size_request(widget, Max(0, iWidth), Max(0, iHeight))
						'gtk_widget_size_allocate(IIF(scrolledwidget, scrolledwidget, widget), @allocation)
						'gtk_widget_queue_draw(widget)
						'?ClassName, FWidth, gtk_widget_get_allocated_width(widget)
						'FHeight = gtk_widget_get_allocated_height(widget)
						'RequestAlign iWidth, iHeight
						'Requests @This
					End If
				EndIf
			#elseif defined(__USE_WINAPI__)
				If FHandle Then 
					MoveWindow FHandle, ScaleX(iLeft), ScaleY(iTop), ScaleX(iWidth), ScaleY(iHeight), True
				End If
			#elseif defined(__USE_JNI__)
				If env = 0 OrElse FHandle = 0 Then Exit Sub
				Dim As jclass class_view = (*env)->FindClass(env, "android/view/View")
				Dim As jmethodID setLayoutParams = (*env)->GetMethodID(env, class_view, "setLayoutParams", "(Landroid/view/ViewGroup$LayoutParams;)V")
				Dim As jclass class_LayoutParams = (*env)->FindClass(env, "android/widget/AbsoluteLayout$LayoutParams")
				Dim As jmethodID ConstructorMethod = (*env)->GetMethodID(env, class_LayoutParams, "<init>", "(IIII)V")
				Dim As jobject LayoutParams = (*env)->NewObject(env, class_LayoutParams, ConstructorMethod, ScaleX(FWidth), ScaleY(FHeight), ScaleX(FLeft), ScaleY(FTop))
				'Dim As jfieldID LeftField = (*env)->GetFieldID(env, class_MarginLayoutParams, "leftMargin", "I")
				'CallVoidMethod(FHandle, "android/widget/Button", "setText", "(Ljava/lang/CharSequence;)V", (*env)->NewStringUTF(env, ToUTF8(Str((*env)->GetIntField(env, MarginLayoutParams, LeftField)))))
'				Dim As jfieldID TopField = (*env)->GetFieldID(env, class_MarginLayoutParams, "topMargin", "I")
'				(*env)->SetIntField(env, MarginLayoutParams, TopField, FTop)
				(*env)->CallVoidMethod(env, FHandle, setLayoutParams, LayoutParams)
			#endif
		End Sub
	#endif
	
	Private Sub Component.GetBounds(ByRef ALeft As Integer, ByRef ATop As Integer, ByRef AWidth As Integer, ByRef AHeight As Integer)
		ALeft = This.Left
		ATop = This.Top
		AWidth = This.Width
		AHeight = This.Height
	End Sub
	
	Private Sub Component.SetBounds(ALeft As Integer, ATop As Integer, AWidth As Integer, AHeight As Integer)
		FLeft   = ALeft
		FTop    = ATop
		FWidth  = AWidth
		FHeight = AHeight
		FWidth = Max(FMinWidth, FWidth)
		FHeight = Max(FMinHeight, FHeight)
		Move FLeft, FTop, FWidth, FHeight
	End Sub
	
	#ifndef Left_Off
		Private Property Component.Left As Integer
			#ifdef __USE_GTK__
				If gtk_is_window(widget) Then
					gtk_window_get_position(gtk_window(widget), Cast(gint Ptr, @FLeft), Cast(gint Ptr, @FTop))
				Else
					Dim As GtkWidget Ptr CtrlWidget = IIf(scrolledwidget, scrolledwidget, IIf(overlaywidget, overlaywidget, IIf(layoutwidget AndAlso gtk_widget_get_parent(layoutwidget) <> widget, layoutwidget, IIf(eventboxwidget, eventboxwidget, widget))))
					If CtrlWidget AndAlso gtk_widget_get_mapped(CtrlWidget) Then
						Dim allocation As GtkAllocation
						gtk_widget_get_allocation(CtrlWidget, @allocation)
						FLeft = allocation.x
						'If FParent Then FLeft -= FParent->Margins.Left
					End If
				End If
			#elseif defined(__USE_WINAPI__)
				If FHandle Then
					If FParent AndAlso UCase(FParent->ClassName) = "TABCONTROL" Then
					Else
						Dim As Rect R
						GetWindowRect Handle, @R
						MapWindowPoints 0, GetParent(Handle), Cast(Point Ptr, @R), 2
						FLeft = UnScaleX(R.Left)
						'If FParent Then FLeft -= FParent->Margins.Left
					End If
				End If
			#elseif defined(__USE_JNI__)
				If ClassName = "Form" Then
					FLeft = 0
				Else
					If FHandle Then
						Dim As jclass class_view = (*env)->FindClass(env, "android/view/View")
						Dim As jmethodID getLayoutParamsMethod = (*env)->GetMethodID(env, class_view, "getLayoutParams", "()Landroid/view/ViewGroup$LayoutParams;")
						Dim As jobject MarginLayoutParams = (*env)->CallObjectMethod(env, FHandle, getLayoutParamsMethod)
						Dim As jclass class_MarginLayoutParams = (*env)->FindClass(env, "android/widget/AbsoluteLayout$LayoutParams")
						Dim As jfieldID xField = (*env)->GetFieldID(env, class_MarginLayoutParams, "x", "I")
						FLeft = UnScaleX((*env)->GetIntField(env, MarginLayoutParams, xField))
						'If FParent Then FLeft -= FParent->Margins.Left
					End If
				End If
			#endif
			Return FLeft
		End Property
		
		Private Property Component.Left(Value As Integer)
			FLeft = Value
			Move FLeft, Top, This.Width, Height
		End Property
	#endif
	
	#ifndef Top_Off
		Private Property Component.Top As Integer
			#ifdef __USE_GTK__
				Dim ControlChanged As Boolean
				If gtk_is_window(widget) Then
					gtk_window_get_position(gtk_window(widget), Cast(gint Ptr, @FLeft), Cast(gint Ptr, @FTop))
				Else
					Dim As GtkWidget Ptr CtrlWidget = IIf(scrolledwidget, scrolledwidget, IIf(overlaywidget, overlaywidget, IIf(layoutwidget AndAlso gtk_widget_get_parent(layoutwidget) <> widget, layoutwidget, IIf(eventboxwidget, eventboxwidget, widget))))
					If CtrlWidget AndAlso gtk_widget_get_mapped(CtrlWidget) Then
						Dim allocation As GtkAllocation
						gtk_widget_get_allocation(CtrlWidget, @allocation)
						FTop = allocation.y
						'If FParent Then FTop -= FParent->Margins.Top
						ControlChanged = True
					End If
				End If
				If CInt(ControlChanged) AndAlso CInt(Parent) AndAlso CInt(Parent->ClassName = "GroupBox") Then
					FTop + = 20
				End If
			#elseif defined(__USE_WINAPI__)
				If FHandle Then
					If FParent AndAlso UCase(FParent->ClassName) = "SYSTABCONTROL32" Or UCase(FParent->ClassName) = "TABCONTROL" Then
					Else
						Dim As Rect R
						GetWindowRect Handle,@R
						MapWindowPoints 0, GetParent(Handle), Cast(Point Ptr, @R), 2
						FTop = UnScaleY(R.Top)
						'If FParent Then FTop -= FParent->Margins.Top
					End If
				End If
			#elseif defined(__USE_JNI__)
				If ClassName = "Form" Then
					FLeft = 0
				Else
					If FHandle Then
						Dim As jobject MarginLayoutParams = CallObjectMethod(FHandle, "android/view/View", "getLayoutParams", "()Landroid/view/ViewGroup$LayoutParams;")
						FTop = UnScaleY(GetIntField(MarginLayoutParams, "android/widget/AbsoluteLayout$LayoutParams", "y", "I"))
						'If FParent Then FTop -= FParent->Margins.Top
					End If
				End If
			#endif
			Return FTop
		End Property
		
		Private Property Component.Top(Value As Integer)
			FTop = Value
			Move This.Left, FTop, This.Width, Height
		End Property
	#endif
	
	#ifndef Width_Off
		Private Property Component.Width As Integer
			#ifdef __USE_GTK__
				If gtk_is_widget(widget) AndAlso gtk_widget_get_realized(widget) Then
					Dim As GtkWidget Ptr CtrlWidget = IIf(scrolledwidget, scrolledwidget, IIf(layoutwidget AndAlso gtk_widget_get_parent(layoutwidget) <> widget, layoutwidget, widget))
					If layoutwidget AndAlso gtk_widget_is_toplevel(widget) Then
						#ifndef __USE_GTK2__
							FWidth = gtk_widget_get_allocated_width(widget)
						#else
							FWidth = widget->allocation.width
						#endif
					ElseIf CtrlWidget Then
						#ifndef __USE_GTK2__
							If gtk_widget_get_allocated_width(CtrlWidget) > 1 Then FWidth = gtk_widget_get_allocated_width(CtrlWidget)
						#else
							If CtrlWidget->allocation.width > 1 Then FWidth = CtrlWidget->allocation.width
						#endif
						'Dim As GtkAllocation alloc
						'gtk_widget_get_allocation (widget, @alloc)
						'FWidth = alloc.width
						'If gtk_widget_get_allocated_width(widget) > 1 Then FWidth = gtk_widget_get_allocated_width(widget)
						'FWidth = Max(gtk_widget_get_allocated_width(widget), FWidth)
					End If
				End If
			#elseif defined(__USE_WINAPI__)
				If FHandle Then
					Dim As Rect R
					GetWindowRect Handle, @R
					MapWindowPoints 0, GetParent(FHandle), Cast(Point Ptr, @R), 2
					FWidth = UnScaleX(R.Right - R.Left)
					'#endif
				End If
			#elseif defined(__USE_JNI__)
				If FHandle Then
					If ClassName = "Form" Then
						Dim As jobject iWindow = CallObjectMethod(FHandle, "android/app/Activity", "getWindow", "()Landroid/view/Window;")
						Dim As jobject decorView = CallObjectMethod(iWindow, "android/view/Window", "getDecorView", "()Landroid/view/View;")
						FWidth = UnScaleX(CallIntMethod(decorView, "android/view/View", "getWidth", "()I"))
					Else
						Dim As jobject LayoutParams = CallObjectMethod(FHandle, "android/view/View", "getLayoutParams", "()Landroid/view/ViewGroup$LayoutParams;")
						FWidth = UnScaleX(GetIntField(LayoutParams, "android/widget/AbsoluteLayout$LayoutParams", "width", "I"))
					End If
				End If
			#endif
			Return FWidth
		End Property
		
		Private Property Component.Width(Value As Integer)
			FWidth = Max(FMinWidth, Value)
			Move This.Left, This.Top, FWidth, Height
		End Property
	#endif
	
	#ifndef Height_Off
		Private Property Component.Height As Integer
			#ifdef __USE_GTK__
				If gtk_is_widget(widget) AndAlso gtk_widget_get_realized(widget) Then
					Dim As GtkWidget Ptr CtrlWidget = IIf(scrolledwidget, scrolledwidget, IIf(layoutwidget AndAlso gtk_widget_get_parent(layoutwidget) <> widget, layoutwidget, widget))
					If layoutwidget AndAlso gtk_widget_is_toplevel(widget) Then
						#ifndef __USE_GTK2__
							FHeight = gtk_widget_get_allocated_height(widget)
						#else
							FHeight = widget->allocation.height
						#endif
					ElseIf CtrlWidget Then
						#ifndef __USE_GTK2__
							If gtk_widget_get_allocated_height(CtrlWidget) > 1 Then FHeight = gtk_widget_get_allocated_height(CtrlWidget)
						#else
							If CtrlWidget->allocation.height > 1 Then FHeight = CtrlWidget->allocation.height
						#endif
					End If
				End If
			#elseif defined(__USE_WINAPI__)
				If FHandle Then
					Dim As Rect R
					GetWindowRect Handle, @R
					MapWindowPoints 0, GetParent(FHandle), Cast(Point Ptr, @R), 2
					FHeight = UnScaleY(R.Bottom - R.Top)
				End If
			#elseif defined(__USE_JNI__)
				If FHandle Then
					If ClassName = "Form" Then
						Dim As jobject iWindow = CallObjectMethod(FHandle, "android/app/Activity", "getWindow", "()Landroid/view/Window;")
						Dim As jobject decorView = CallObjectMethod(iWindow, "android/view/Window", "getDecorView", "()Landroid/view/View;")
						FHeight = UnScaleY(CallIntMethod(decorView, "android/view/View", "getHeight", "()I"))
					Else
						Dim As jobject LayoutParams = CallObjectMethod(FHandle, "android/view/View", "getLayoutParams", "()Landroid/view/ViewGroup$LayoutParams;")
						FHeight = UnScaleY(GetIntField(LayoutParams, "android/widget/AbsoluteLayout$LayoutParams", "height", "I"))
					End If
				End If
			#endif
			Return FHeight
		End Property
		
		Private Property Component.Height(Value As Integer)
			FHeight = Max(FMinHeight, Value)
			Move This.Left, This.Top, This.Width, FHeight
		End Property
	#endif
	
	Private Function Component.ToString ByRef As WString
		Return This.Name
	End Function
	
	Private Destructor Component
		WDeallocate FName
		WDeallocate FClassAncestor
		#ifdef __USE_GTK__
			#ifndef __FB_WIN32__
				If gtk_is_widget(Widget) Then
					#ifdef __USE_GTK3__
						gtk_widget_destroy(Widget)
					#else
						If gtk_is_menu_shell(Widget) = 0 Then
							gtk_widget_destroy(Widget)
						End If
					#endif
					Widget = 0
				End If
				If gtk_is_widget(overlaywidget) Then
					gtk_widget_destroy(overlaywidget)
					overlaywidget = 0
				End If
				If gtk_is_widget(ScrolledWidget) Then
					gtk_widget_destroy(ScrolledWidget)
					ScrolledWidget = 0
				End If
				If gtk_is_widget(EventBoxWidget) Then
					gtk_widget_destroy(EventBoxWidget)
					EventBoxWidget = 0
				End If
				If gtk_is_widget(fixedwidget) Then
					gtk_widget_destroy(fixedwidget)
					fixedwidget = 0
				End If
				If gtk_is_widget(layoutwidget) Then
					gtk_widget_destroy(layoutwidget)
					layoutwidget = 0
				End If
				If gtk_is_widget(box) Then
					gtk_widget_destroy(box)
					box = 0
				End If
			#endif
		#elseif defined(__USE_WINAPI__)
			If FHandle Then
				DestroyWindow FHandle
				FHandle = 0
			End If
		#endif
	End Destructor
End Namespace

Function ThreadCreate_(ByVal ProcPtr_ As Sub ( ByVal userdata As Any Ptr ), ByVal param As Any Ptr = 0, ByVal stack_size As Integer = 0) As Any Ptr
	#if defined(__USE_GTK__) AndAlso defined(__FB_WIN32__)
		ProcPtr_(param)
		Return 0
	#else
		Return ThreadCreate(ProcPtr_, param, stack_size)
	#endif
End Function

Private Sub ThreadsEnter
	#if defined(__USE_GTK__) AndAlso Not defined(__FB_WIN32__)
		gdk_threads_enter()
	#endif
End Sub

Private Sub ThreadsLeave
	#ifdef __USE_GTK__ 
		#ifdef __FB_WIN32__
			If gtk_events_pending() Then gtk_main_iteration()
		#else
			gdk_threads_leave()
		#endif
	#endif
End Sub

#ifdef __EXPORT_PROCS__
	Function Q_Component Alias "Q_Component"(Cpnt As Any Ptr) As My.Sys.ComponentModel.Component Ptr __EXPORT__
		Return Cast(My.Sys.ComponentModel.Component Ptr, Cpnt)
	End Function
	
	Sub ComponentGetBounds Alias "ComponentGetBounds" (Cpnt As My.Sys.ComponentModel.Component Ptr, ByRef ALeft As Integer, ByRef ATop As Integer, ByRef AWidth As Integer, ByRef AHeight As Integer) __EXPORT__
		Cpnt->GetBounds(ALeft, ATop, AWidth, AHeight)
	End Sub
	
	Sub ComponentSetBounds Alias "ComponentSetBounds"(Cpnt As My.Sys.ComponentModel.Component Ptr, ALeft As Integer, ATop As Integer, AWidth As Integer, AHeight As Integer) __EXPORT__
		Cpnt->SetBounds(ALeft, ATop, AWidth, AHeight)
	End Sub
	
	Function IsComponent Alias "IsComponent"(Obj As My.Sys.Object Ptr) As Boolean Export
		Return *Obj Is My.Sys.ComponentModel.Component
	End Function
#endif
