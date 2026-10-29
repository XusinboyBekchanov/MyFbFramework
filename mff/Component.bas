'###############################################################################
'#  Component.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'###############################################################################

#include once "Component.bi"

#ifdef __USE_WASM__
	Dim TimerComponentProc As Sub(Id As Integer)
#endif

Namespace My.Sys.ComponentModel
	Private Function MarginsType.ToString ByRef As WString
		WLet(FTemp, This.Left & "; " & This.Top & "; " & This.Right & "; " & This.Bottom)
		If FTemp <> 0 Then Return *FTemp Else Return ""
	End Function
	
	#ifndef ReadProperty_Off
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
				#elseif defined(__USE_WINAPI__) OrElse defined(__USE_WASM__) OrElse defined(__USE_JNI__)
				'Web: the handle is the address of the control (the id of its element), Android: the view; the designer of the
				'IDE reads it (SetParent of the designed form into its panel, Win32Compat.bi)
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
	#endif
	
	#ifndef WriteProperty_Off
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
					#elseif defined(__USE_WINAPI__)
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
	#endif
	
	#ifndef Component_GetTopLevel_Off
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
				Value->FComponents.Add @This
				#ifdef __USE_GTK__
					If FDesignMode AndAlso widget <> 0 AndAlso GTK_IS_WIDGET(widget) AndAlso Value <> 0 AndAlso Value->layoutwidget <> 0 Then
						If gtk_widget_get_parent(widget) <> Value->layoutwidget Then
							If gtk_widget_get_parent(widget) <> 0 Then gtk_widget_unparent(widget)
							gtk_layout_put(GTK_LAYOUT(Value->layoutwidget), widget, ScaleX(FLeft), ScaleY(FTop))
						Else
							gtk_layout_move(GTK_LAYOUT(Value->layoutwidget), widget, ScaleX(FLeft), ScaleY(FTop))
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
		If FClassAncestor Then Return *FClassAncestor Else Return ""
	End Function
	
	Private Property Component.DesignMode As Boolean
		Return FDesignMode
	End Property
	
	Private Property Component.DesignMode(Value As Boolean)
		FDesignMode = Value
	End Property
	
	Private Property Component.Name ByRef As WString
		If FName> 0 Then Return *FName Else Return ""
	End Property
	
	Private Property Component.Name(ByRef Value As WString)
		WLet(FName, Value)
		#ifdef __USE_GTK__
			If GTK_IS_WIDGET(widget) Then gtk_widget_set_name(widget, Value)
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
		#elseif defined(__USE_WASM__)
			Private Property Component.Handle As Any Ptr
				Return FHandle
			End Property
			
			Private Property Component.Handle(Value As Any Ptr)
				FHandle = Value
			End Property
			
			Private Property Component.LayoutHandle As Any Ptr
				Return FHandle
			End Property
			
			Private Property Component.LayoutHandle(Value As Any Ptr)
				FHandle = Value
			End Property
		#endif
	#endif
	
	#ifndef Move_Off
		#ifdef __USE_JNI__
			Private Function Component.DesignCaptionHeight() As Integer
				If FDesignMode AndAlso ClassName = "Form" Then Return 28
				Return 0
			End Function
		#endif

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
							If cParent->widget AndAlso GTK_IS_FRAME(cParent->widget) Then
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
					iLeft = ScaleX(iLeft)
					iTop = ScaleY(iTop)
					iWidth = ScaleX(iWidth)
					iHeight = ScaleY(iHeight)
					If GTK_IS_WIDGET(widget) AndAlso gtk_widget_is_toplevel(widget) Then
						gtk_window_move(GTK_WINDOW(widget), iLeft, iTop)
						#ifdef __USE_GTK4__
							' The default size of GTK4 includes the title bar (GTK3 adds it to the size)
							gtk_window_resize(GTK_WINDOW(widget), Max(0, iWidth), Max(0, iHeight))
						#else
							gtk_window_resize(GTK_WINDOW(widget), Max(0, iWidth), Max(0, iHeight - 20))
						#endif
						'gtk_window_resize(GTK_WINDOW(widget), Max(1, iWidth), Max(1, iHeight))
						'RequestAlign iWidth, iHeight
					Else
						'gdk_window_move(gtk_widget_get_window (widget), iLeft, iTop)
						'gdk_window_resize(gtk_widget_get_window (widget), Max(1, iWidth), Max(1, iHeight))
						'If Parent AndAlso Parent->fixedwidget Then gtk_fixed_move(gtk_fixed(Parent->fixedwidget), widget, iLeft, iTop)
						Dim As GtkWidget Ptr CtrlWidget = IIf(containerwidget, containerwidget, IIf(scrolledwidget, scrolledwidget, IIf(overlaywidget, overlaywidget, IIf(layoutwidget AndAlso gtk_widget_get_parent(layoutwidget) <> widget, layoutwidget, IIf(eventboxwidget, eventboxwidget, widget)))))
						If Parent Then
							If Parent->layoutwidget AndAlso GTK_IS_LAYOUT(gtk_widget_get_parent(CtrlWidget)) Then
								'gtk_widget_size_allocate(IIF(scrolledwidget, scrolledwidget, widget), @allocation)
								gtk_layout_move(GTK_LAYOUT(Parent->layoutwidget), CtrlWidget, iLeft, iTop)
							ElseIf Parent->fixedwidget Then
								gtk_fixed_move(GTK_FIXED(Parent->fixedwidget), CtrlWidget, iLeft, iTop)
							ElseIf GTK_IS_TEXT_VIEW(Parent->widget) Then
								gtk_text_view_move_child(GTK_TEXT_VIEW(Parent->widget), CtrlWidget, iLeft, iTop)
							End If
						End If
						'gtk_widget_set_size_allocation(widget, @allocation)
						'gtk_widget_set_size_request(widget, Max(0, iWidth), Max(0, iHeight))
						gtk_widget_set_size_request(CtrlWidget, Max(0, iWidth), Max(0, iHeight))
						#ifdef __USE_GTK4__
							' The widget fills its overlay or event box: a size request from before it was put into
							' the wrapper would be the minimum size of the wrapper (it could not become smaller)
							If CtrlWidget <> widget AndAlso (CtrlWidget = overlaywidget OrElse CtrlWidget = eventboxwidget) AndAlso GTK_IS_WIDGET(widget) Then
								gtk_widget_set_size_request(widget, -1, -1)
							End If
							' A page of a GtkStack (PagePanel) gets the size of the stack: the size request would be its minimum
							' size, the stack and the window could not become smaller (a ScrollControl page did not scroll)
							If GTK_IS_STACK(gtk_widget_get_parent(CtrlWidget)) Then gtk_widget_set_size_request(CtrlWidget, -1, -1)
						#endif
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
					Dim As Integer nLeft = ScaleX(iLeft), nTop = ScaleY(iTop), nWidth = ScaleX(iWidth), nHeight = ScaleY(iHeight)
					If AlignLock > 0 Then
						' A layout pass is running and repaints the container when it ends.
						' Repainting here would show a half finished layout and costs more than
						' the move itself; a window which already has the bounds is skipped
						Dim As RECT R, ROld, RNew
						Dim As HWND hParentWnd = GetParent(FHandle)
						GetWindowRect FHandle, @R
						ROld = R
						If R.Right - R.Left = nWidth AndAlso R.Bottom - R.Top = nHeight Then
							MapWindowPoints 0, hParentWnd, Cast(Point Ptr, @R), 2
							If R.Left = nLeft AndAlso R.Top = nTop Then Exit Sub
						End If
						If AlignMoved = 0 Then AlignMoved = 1
						' Only the old and the new place of the window are repainted when the pass ends
						RNew.Left = nLeft: RNew.Top = nTop: RNew.Right = nLeft + nWidth: RNew.Bottom = nTop + nHeight
						MapWindowPoints hParentWnd, 0, Cast(Point Ptr, @RNew), 2
						AlignAddRect @ROld
						AlignAddRect @RNew
						' Only children of the container of the batch may join it
						If AlignDefer AndAlso hParentWnd = AlignDeferParent Then
							AlignDefer = DeferWindowPos(AlignDefer, FHandle, 0, nLeft, nTop, nWidth, nHeight, SWP_NOZORDER Or SWP_NOACTIVATE Or SWP_NOREDRAW)
							If AlignDefer Then Exit Sub
							' The batch failed and is gone: the remaining moves are applied one by one
						End If
						SetWindowPos FHandle, 0, nLeft, nTop, nWidth, nHeight, SWP_NOZORDER Or SWP_NOACTIVATE Or SWP_NOREDRAW
						Exit Sub
					End If
					MoveWindow FHandle, nLeft, nTop, nWidth, nHeight, True
				End If
			#elseif defined(__USE_JNI__)
				'The bounds of Move (there is no WM_SIZE which gives them back like on Windows): an AutoSize container
				'(VerticalBox, RequestAlign) became larger only in its fields of the native side
				FLeft = iLeft: FTop = iTop: FWidth = iWidth: FHeight = iHeight
				If env = 0 OrElse FHandle = 0 Then Exit Sub
				Dim As jclass class_view = (*env)->FindClass(env, "android/view/View")
				'The main Form is the Activity: its size is the one of the screen
				If (*env)->IsInstanceOf(env, FHandle, class_view) = 0 Then Exit Sub
				'The edges in pixels: the right edge of a control is the left one of the control next to it (the left and the
				'width rounded apart gave a gap of a pixel or one over the other)
				Dim As Long PixelLeft = ScaleX(FLeft), PixelTop = ScaleY(FTop + DesignCaptionHeight)
				Dim As Long PixelWidth = ScaleX(FLeft + FWidth) - PixelLeft, PixelHeight = ScaleY(FTop + DesignCaptionHeight + FHeight) - PixelTop
				'The same bounds: no new layout (setLayoutParams asks for one, and the layout aligns the controls again)
				Scope
					Dim As jobject OldParams = CallObjectMethod(FHandle, "android/view/View", "getLayoutParams", "()Landroid/view/ViewGroup$LayoutParams;")
					'The view is not in an AbsoluteLayout (a second form in its activity, mffActivity.FormActivity: the scroll
					'views give its size): the bounds of AbsoluteLayout would not be the ones of that parent
					If OldParams <> 0 AndAlso IsAbsoluteLayoutParams(OldParams) = False Then
						(*env)->DeleteLocalRef(env, OldParams)
						Exit Sub
					End If
					If IsAbsoluteLayoutParams(OldParams) Then
						If GetIntField(OldParams, "android/widget/AbsoluteLayout$LayoutParams", "x", "I") = PixelLeft AndAlso GetIntField(OldParams, "android/widget/AbsoluteLayout$LayoutParams", "y", "I") = PixelTop AndAlso _
							GetIntField(OldParams, "android/widget/AbsoluteLayout$LayoutParams", "width", "I") = PixelWidth AndAlso GetIntField(OldParams, "android/widget/AbsoluteLayout$LayoutParams", "height", "I") = PixelHeight Then
							(*env)->DeleteLocalRef(env, OldParams)
							Exit Sub
						End If
					End If
					If OldParams Then (*env)->DeleteLocalRef(env, OldParams)
				End Scope
				Dim As jmethodID setLayoutParams = (*env)->GetMethodID(env, class_view, "setLayoutParams", "(Landroid/view/ViewGroup$LayoutParams;)V")
				Dim As jclass class_LayoutParams = (*env)->FindClass(env, "android/widget/AbsoluteLayout$LayoutParams")
				Dim As jmethodID ConstructorMethod = (*env)->GetMethodID(env, class_LayoutParams, "<init>", "(IIII)V")
				Dim As jobject LayoutParams = (*env)->NewObject(env, class_LayoutParams, ConstructorMethod, PixelWidth, PixelHeight, PixelLeft, PixelTop)
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
			If Not (FDesignMode AndAlso (Designer = @This)) Then
				#ifdef __USE_GTK__
					If GTK_IS_WINDOW(widget) Then
						Dim As gint iLeft, iTop
						gtk_window_get_position(GTK_WINDOW(widget), @iLeft, @iTop)
						FLeft = UnScaleX(iLeft)
						FTop = UnScaleY(iTop)
					Else
						Dim As GtkWidget Ptr CtrlWidget = IIf(containerwidget, containerwidget, IIf(scrolledwidget, scrolledwidget, IIf(overlaywidget, overlaywidget, IIf(layoutwidget AndAlso gtk_widget_get_parent(layoutwidget) <> widget, layoutwidget, IIf(eventboxwidget, eventboxwidget, widget)))))
						If CtrlWidget AndAlso GTK_IS_WIDGET(CtrlWidget) AndAlso gtk_widget_get_mapped(CtrlWidget) Then
							Dim allocation As GtkAllocation
							gtk_widget_get_allocation(CtrlWidget, @allocation)
							FLeft = UnScaleX(allocation.x)
							'If FParent Then FLeft -= FParent->Margins.Left
						End If
					End If
				#elseif defined(__USE_WINAPI__)
					If FHandle Then
						If FParent AndAlso UCase(FParent->ClassName) = "TABCONTROL" Then
						Else
							Dim As RECT R
							GetWindowRect Handle, @R
							MapWindowPoints 0, GetParent(Handle), Cast(Point Ptr, @R), 2
							FLeft = UnScaleX(R.left)
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
							If IsAbsoluteLayoutParams(MarginLayoutParams) Then
								Dim As jclass class_MarginLayoutParams = (*env)->FindClass(env, "android/widget/AbsoluteLayout$LayoutParams")
								Dim As jfieldID xField = (*env)->GetFieldID(env, class_MarginLayoutParams, "x", "I")
								FLeft = UnScaleX((*env)->GetIntField(env, MarginLayoutParams, xField))
							End If
							'If FParent Then FLeft -= FParent->Margins.Left
						End If
					End If
				#endif
			End If
			Return FLeft
		End Property
		
		#ifndef Component_Left_Set_Off
			Private Property Component.Left(Value As Integer)
				FLeft = Value
				Move FLeft, Top, This.Width, Height
			End Property
		#endif
	#endif
	
	#ifndef Top_Off
		Private Property Component.Top As Integer
			If Not (FDesignMode AndAlso (Designer = @This)) Then
				#ifdef __USE_GTK__
					Dim ControlChanged As Boolean
					If GTK_IS_WINDOW(widget) Then
						Dim As gint iLeft, iTop
						gtk_window_get_position(GTK_WINDOW(widget), @iLeft, @iTop)
						FLeft =  UnScaleX(iLeft)
						FTop =  UnScaleY(iTop)
					Else
						Dim As GtkWidget Ptr CtrlWidget = IIf(containerwidget, containerwidget, IIf(scrolledwidget, scrolledwidget, IIf(overlaywidget, overlaywidget, IIf(layoutwidget AndAlso gtk_widget_get_parent(layoutwidget) <> widget, layoutwidget, IIf(eventboxwidget, eventboxwidget, widget)))))
						If CtrlWidget AndAlso GTK_IS_WIDGET(CtrlWidget) AndAlso gtk_widget_get_mapped(CtrlWidget) Then
							Dim allocation As GtkAllocation
							gtk_widget_get_allocation(CtrlWidget, @allocation)
							FTop = UnScaleY(allocation.y)
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
							Dim As RECT R
							GetWindowRect Handle,@R
							MapWindowPoints 0, GetParent(Handle), Cast(Point Ptr, @R), 2
							FTop = UnScaleY(R.top)
							'If FParent Then FTop -= FParent->Margins.Top
						End If
					End If
				#elseif defined(__USE_JNI__)
					If ClassName = "Form" Then
						FLeft = 0
					Else
						If FHandle Then
							Dim As jobject MarginLayoutParams = CallObjectMethod(FHandle, "android/view/View", "getLayoutParams", "()Landroid/view/ViewGroup$LayoutParams;")
							If IsAbsoluteLayoutParams(MarginLayoutParams) Then FTop = UnScaleY(GetIntField(MarginLayoutParams, "android/widget/AbsoluteLayout$LayoutParams", "y", "I"))
							'If FParent Then FTop -= FParent->Margins.Top
						End If
					End If
				#endif
			End If
			Return FTop
		End Property
		
		#ifndef Component_Top_Set_Off
			Private Property Component.Top(Value As Integer)
				FTop = Value
				Move This.Left, FTop, This.Width, Height
			End Property
		#endif
	#endif
	
	#ifndef Width_Off
		Private Property Component.Width As Integer
			#ifdef __USE_GTK__
				If GTK_IS_WIDGET(widget) AndAlso gtk_widget_get_realized(widget) Then
					If GTK_IS_WINDOW(widget) Then
						Dim As gint iWidth, iHeight
						gtk_window_get_size(GTK_WINDOW(widget), @iWidth, @iHeight)
						FWidth = UnScaleX(iWidth)
					Else
						Dim As GtkWidget Ptr CtrlWidget = IIf(containerwidget, containerwidget, IIf(scrolledwidget, scrolledwidget, IIf(layoutwidget AndAlso gtk_widget_get_parent(layoutwidget) <> widget, layoutwidget, widget)))
						If layoutwidget AndAlso gtk_widget_is_toplevel(widget) Then
							#ifndef __USE_GTK2__
								FWidth = gtk_widget_get_allocated_width(widget)
							#else
								FWidth = widget->allocation.width
							#endif
							FWidth = UnScaleX(FWidth)
						ElseIf CtrlWidget Then
							#ifndef __USE_GTK2__
								If gtk_widget_get_allocated_width(CtrlWidget) > 1 Then FWidth = gtk_widget_get_allocated_width(CtrlWidget)
							#else
								If CtrlWidget->allocation.width > 1 Then FWidth = CtrlWidget->allocation.width
							#endif
							FWidth = UnScaleX(FWidth)
							'Dim As GtkAllocation alloc
							'gtk_widget_get_allocation (widget, @alloc)
							'FWidth = alloc.width
							'If gtk_widget_get_allocated_width(widget) > 1 Then FWidth = gtk_widget_get_allocated_width(widget)
							'FWidth = Max(gtk_widget_get_allocated_width(widget), FWidth)
						End If
					End If
				End If
			#elseif defined(__USE_WINAPI__)
				If FHandle Then
					Dim As RECT R
					GetWindowRect Handle, @R
					MapWindowPoints 0, GetParent(FHandle), Cast(Point Ptr, @R), 2
					FWidth = UnScaleX(R.right - R.left)
					'#endif
				End If
			#elseif defined(__USE_JNI__)
				If FHandle Then
					'A second Form is not the Activity and has no window, the size of the design is kept
					If ClassName = "Form" AndAlso (*env)->IsInstanceOf(env, FHandle, FindJNIClass("android/app/Activity")) Then
						Dim As jobject iWindow = CallObjectMethod(FHandle, "android/app/Activity", "getWindow", "()Landroid/view/Window;")
						Dim As jobject decorView = IIf(iWindow, CallObjectMethod(iWindow, "android/view/Window", "getDecorView", "()Landroid/view/View;"), 0)
						'Before the first layout the width is 0: the one of the design is kept
						Dim As Integer iWidth = IIf(decorView, CallIntMethod(decorView, "android/view/View", "getWidth", "()I"), 0)
						If iWidth > 0 Then FWidth = UnScaleX(iWidth)
					ElseIf ClassName <> "Form" AndAlso (*env)->IsInstanceOf(env, FHandle, FindJNIClass("android/view/View")) Then
						Dim As jobject LayoutParams = CallObjectMethod(FHandle, "android/view/View", "getLayoutParams", "()Landroid/view/ViewGroup$LayoutParams;")
						If IsAbsoluteLayoutParams(LayoutParams) Then FWidth = UnScaleX(GetIntField(LayoutParams, "android/widget/AbsoluteLayout$LayoutParams", "width", "I"))
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
				If GTK_IS_WIDGET(widget) AndAlso gtk_widget_get_realized(widget) Then
					If GTK_IS_WINDOW(widget) Then
						Dim As gint iWidth, iHeight
						gtk_window_get_size(GTK_WINDOW(widget), @iWidth, @iHeight)
						FHeight = UnScaleY(iHeight + 20)
					Else
						Dim As GtkWidget Ptr CtrlWidget = IIf(containerwidget, containerwidget, IIf(scrolledwidget, scrolledwidget, IIf(layoutwidget AndAlso gtk_widget_get_parent(layoutwidget) <> widget, layoutwidget, widget)))
						If layoutwidget AndAlso gtk_widget_is_toplevel(widget) Then
							#ifndef __USE_GTK2__
								FHeight = gtk_widget_get_allocated_height(widget)
							#else
								FHeight = widget->allocation.height
							#endif
							FHeight = UnScaleY(FHeight)
						ElseIf CtrlWidget Then
							#ifndef __USE_GTK2__
								If gtk_widget_get_allocated_height(CtrlWidget) > 1 Then FHeight = gtk_widget_get_allocated_height(CtrlWidget)
							#else
								If CtrlWidget->allocation.height > 1 Then FHeight = CtrlWidget->allocation.height
							#endif
							FHeight = UnScaleY(FHeight)
						End If
					End If
				End If
			#elseif defined(__USE_WINAPI__)
				If FHandle Then
					Dim As RECT R
					GetWindowRect Handle, @R
					MapWindowPoints 0, GetParent(FHandle), Cast(Point Ptr, @R), 2
					FHeight = UnScaleY(R.bottom - R.top)
				End If
			#elseif defined(__USE_JNI__)
				If FHandle Then
					'A second Form is not the Activity and has no window, the size of the design is kept
					If ClassName = "Form" AndAlso (*env)->IsInstanceOf(env, FHandle, FindJNIClass("android/app/Activity")) Then
						Dim As jobject iWindow = CallObjectMethod(FHandle, "android/app/Activity", "getWindow", "()Landroid/view/Window;")
						Dim As jobject decorView = IIf(iWindow, CallObjectMethod(iWindow, "android/view/Window", "getDecorView", "()Landroid/view/View;"), 0)
						'Before the first layout the height is 0: the one of the design is kept
						Dim As Integer iHeight = IIf(decorView, CallIntMethod(decorView, "android/view/View", "getHeight", "()I"), 0)
						If iHeight > 0 Then FHeight = UnScaleY(iHeight)
					ElseIf ClassName <> "Form" AndAlso (*env)->IsInstanceOf(env, FHandle, FindJNIClass("android/view/View")) Then
						Dim As jobject LayoutParams = CallObjectMethod(FHandle, "android/view/View", "getLayoutParams", "()Landroid/view/ViewGroup$LayoutParams;")
						If IsAbsoluteLayoutParams(LayoutParams) Then FHeight = UnScaleY(GetIntField(LayoutParams, "android/widget/AbsoluteLayout$LayoutParams", "height", "I"))
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
	
	Private Sub Component.FreeWidget()
		#ifdef __USE_GTK__
			If widget <> 0 AndAlso GTK_IS_WIDGET(widget) Then
				Dim As GtkWidget Ptr TempWidget = widget
				widget = 0
				#ifdef __USE_GTK4__
					gtk_widget_destroy(TempWidget)
				#else
					#ifndef __USE_GTK2__
						gtk_widget_destroy(TempWidget)
					#else
						If GTK_IS_MENU_SHELL(TempWidget) = 0 Then
							gtk_widget_destroy(TempWidget)
						End If
					#endif
				#endif
				
				If TempWidget = overlaywidget Then overlaywidget = 0
				If TempWidget = scrolledwidget Then scrolledwidget = 0
				If TempWidget = eventboxwidget Then eventboxwidget = 0
				If TempWidget = fixedwidget Then fixedwidget = 0
				If TempWidget = layoutwidget Then layoutwidget = 0
				If TempWidget = box Then box = 0
				If TempWidget = containerwidget Then containerwidget = 0
				widget = 0
			End If
			If overlaywidget <> 0 AndAlso GTK_IS_WIDGET(overlaywidget) Then
				#ifdef __USE_GTK4__
					gtk_widget_destroy(overlaywidget)
				#else
					gtk_widget_destroy(overlaywidget)
				#endif
				overlaywidget = 0
			End If
			If scrolledwidget <> 0 AndAlso GTK_IS_WIDGET(scrolledwidget) Then
				#ifdef __USE_GTK4__
					gtk_widget_destroy(scrolledwidget)
				#else
					gtk_widget_destroy(scrolledwidget)
				#endif
				scrolledwidget = 0
			End If
			If eventboxwidget <> 0 AndAlso GTK_IS_WIDGET(eventboxwidget) Then
				#ifdef __USE_GTK4__
					gtk_widget_destroy(eventboxwidget)
				#else
					gtk_widget_destroy(eventboxwidget)
				#endif
				eventboxwidget = 0
			End If
			If fixedwidget <> 0 AndAlso GTK_IS_WIDGET(fixedwidget) Then
				#ifdef __USE_GTK4__
					gtk_widget_destroy(fixedwidget)
				#else
					gtk_widget_destroy(fixedwidget)
				#endif
				fixedwidget = 0
			End If
			If layoutwidget <> 0 AndAlso GTK_IS_WIDGET(layoutwidget) Then
				#ifdef __USE_GTK4__
					gtk_widget_destroy(layoutwidget)
				#else
					gtk_widget_destroy(layoutwidget)
				#endif
				layoutwidget = 0
			End If
			If box <> 0 AndAlso GTK_IS_WIDGET(box) Then
				#ifdef __USE_GTK4__
					gtk_widget_destroy(box)
				#else
					gtk_widget_destroy(box)
				#endif
				box = 0
			End If
			If containerwidget <> 0 AndAlso GTK_IS_WIDGET(containerwidget) Then
				#ifdef __USE_GTK4__
					gtk_widget_destroy(containerwidget)
				#else
					gtk_widget_destroy(containerwidget)
				#endif
				containerwidget = 0
			End If
		#endif
	End Sub
	
	Destructor Component
		If FName Then _Deallocate(FName)
		If FClassAncestor Then _Deallocate(FClassAncestor)
		#ifdef __USE_GTK__
			FreeWidget()
		#elseif defined(__USE_WINAPI__)
			If FHandle Then
				DestroyWindow FHandle
				FHandle = 0
			End If
		#endif
	End Destructor
End Namespace

#ifdef __USE_WINAPI__
	Private Sub AlignAddRect(ByVal pRect As RECT Ptr)
		If pRect->Right <= pRect->Left OrElse pRect->Bottom <= pRect->Top Then Exit Sub
		If AlignRgn = 0 Then
			AlignRgn = CreateRectRgnIndirect(pRect)
		Else
			Dim As HRGN hRgn = CreateRectRgnIndirect(pRect)
			CombineRgn AlignRgn, AlignRgn, hRgn, RGN_OR
			DeleteObject hRgn
		End If
	End Sub

	Private Sub AlignAddWindow(ByVal hWnd As HWND)
		Dim As RECT R
		If hWnd = 0 OrElse GetWindowRect(hWnd, @R) = 0 Then Exit Sub
		If AlignMoved = 0 Then AlignMoved = 1
		AlignAddRect @R
	End Sub

	Private Sub AlignClear
		AlignMoved = 0
		If AlignRgn Then DeleteObject AlignRgn: AlignRgn = 0
	End Sub

	Private Sub AlignRedraw(ByVal hContainer As HWND, ByVal bNow As Boolean = False)
		If hContainer <> 0 AndAlso AlignMoved <> 0 Then
			Dim As UINT uFlags = RDW_INVALIDATE Or RDW_ERASE Or RDW_FRAME Or RDW_ALLCHILDREN Or IIf(bNow, RDW_UPDATENOW, 0)
			If AlignMoved = 1 AndAlso AlignRgn <> 0 Then
				' Only the places the moved windows left and took: the rest of the container stays valid
				Dim As .Point P
				ClientToScreen hContainer, @P
				OffsetRgn AlignRgn, -P.X, -P.Y
				RedrawWindow hContainer, 0, AlignRgn, uFlags
			Else
				RedrawWindow hContainer, 0, 0, uFlags
			End If
		End If
		AlignClear
	End Sub
#endif

Function ThreadCreate_(ByVal ProcPtr_ As Sub ( ByVal userdata As Any Ptr ), ByVal param As Any Ptr = 0, ByVal stack_size As Integer = 0) As Any Ptr
	'Android: the views are only of the main thread and the JNIEnv of the controls is the one of it (a control changed
	'by another thread crashed the program): the procedure runs in the main thread
	#if (defined(__USE_GTK__) AndAlso defined(__FB_WIN32__)) OrElse defined(__USE_JNI__)
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
		If Obj > 0  Then Return *Obj Is My.Sys.ComponentModel.Component Else Return  False
	End Function
#endif
