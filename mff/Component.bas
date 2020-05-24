'###############################################################################
'#  Component.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'###############################################################################

#include once "Component.bi"

Namespace My.Sys.ComponentModel
	
	Function MarginsType.ToString ByRef As WString
		WLet FTemp, This.Left & "; " & This.Top & "; " & This.Right & "; " & This.Bottom
		Return *FTemp
	End Function
	
	Function Component.ReadProperty(ByRef PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "designmode": Return @FDesignMode
		Case "classancestor": Return FClassAncestor
		Case "tag": Return Tag
			#ifdef __USE_GTK__
			Case "handle": Return widget
			Case "widget": Return widget
			Case "layoutwidget": Return layoutwidget
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
		Case "name": Return FName
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function Component.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		If Value <> 0 Then
			Select Case LCase(PropertyName)
			Case "tag": This.Tag = Value
			Case "name": This.Name = QWString(Value)
			Case "designmode": This.DesignMode = QBoolean(Value)
				#ifdef __USE_GTK__
				Case "handle": This.Handle = Value
				Case "widget": This.widget = Value
				Case "layoutwidget": This.layoutwidget = Value
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
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		End If
		Return True
	End Function
	
	#ifndef GetTopLevel_Off
		Function Component.GetTopLevel As Component Ptr
			If FParent = 0 Then
				Return @This
			Else
				Return FParent->GetTopLevel()
			End If
		End Function
	#endif
	
	#ifndef Parent_Off
		Property Component.Parent As Component Ptr
			Return FParent
		End Property
		
		Property Component.Parent(Value As Component Ptr)
			If FParent <> Value Then
				FParent = Value
				#ifdef __USE_GTK__
					If FDesignMode AndAlso widget <> 0 AndAlso Value <> 0 AndAlso Value->layoutwidget <> 0 Then
						If gtk_widget_get_parent(widget) <> Value->layoutwidget Then
							If gtk_widget_get_parent(widget) <> 0 Then gtk_widget_unparent(widget)
							gtk_layout_put(GTK_LAYOUT(Value->layoutwidget), widget, FLeft, FTop)
						Else
							gtk_layout_move(GTK_LAYOUT(Value->layoutwidget), widget, FLeft, FTop)
						End If
					End If
				#else
					If FDesignMode AndAlso FHandle <> 0 AndAlso Value <> 0 AndAlso Value->Handle <> 0 Then
						If GetParent(FHandle) <> Value->Handle Then
							SetParent FHandle, Value->Handle
						End If
					End If
				#endif
			End If
		End Property
	#endif
	
	Function Component.ClassAncestor ByRef As WString
		Return WGet(FClassAncestor)
	End Function
	
	Property Component.DesignMode As Boolean
		Return FDesignMode
	End Property
	
	Property Component.DesignMode(Value As Boolean)
		FDesignMode = Value
	End Property
	
	Property Component.Name ByRef As WString
		Return WGet(FName)
	End Property
	
	Property Component.Name(ByRef Value As WString)
		WLet FName, Value
		#ifdef __USE_GTK__
			If gtk_is_widget(widget) Then gtk_widget_set_name(widget, Value)
		#endif
	End Property
	
	#ifndef Handle_Off
		#ifdef __USE_GTK__
			Property Component.Handle As GtkWidget Ptr
				Return widget
			End Property
			
			Property Component.Handle(Value As GtkWidget Ptr)
				widget = Value
			End Property
		#else
			Property Component.Handle As HWND
				Return FHandle
			End Property
			
			Property Component.Handle(Value As HWND)
				FHandle = Value
			End Property
		#endif
	#endif
	
	#ifndef Move_Off
		Sub Component.Move(cLeft As Integer, cTop As Integer, cWidth As Integer, cHeight As Integer)
			'#ifdef __USE_GTK__
			'	Dim As Integer iLeft = FLeft, iTop = FTop, iWidth = FWidth, iHeight = FHeight
			'#else
				Dim As Integer iLeft = cLeft, iTop = cTop, iWidth = cWidth, iHeight = cHeight
			'#endif
			If FParent Then
				Dim As Component Ptr cParent = FParent
				If cParent Then
					#ifdef __USE_GTK__
						If cParent->widget AndAlso gtk_is_frame(cParent->widget) Then
							iTop -= 20
						End If
					#endif
					iLeft = iLeft + cParent->Margins.Left
					iTop = iTop + cParent->Margins.Top
					iWidth = iWidth - cParent->Margins.Left - cParent->Margins.Right
					iHeight = iHeight - cParent->Margins.Top - cParent->Margins.Bottom
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
						If Parent Then
							If Parent->layoutwidget Then
								'gtk_widget_size_allocate(IIF(scrolledwidget, scrolledwidget, widget), @allocation)
								gtk_layout_move(gtk_layout(Parent->layoutwidget), IIf(scrolledwidget, scrolledwidget, widget), iLeft, iTop)
							ElseIf Parent->fixedwidget Then
								gtk_fixed_move(gtk_fixed(Parent->fixedwidget), IIf(scrolledwidget, scrolledwidget, widget), iLeft, iTop)
							End If
						End If
						'gtk_widget_set_size_allocation(widget, @allocation)
						gtk_widget_set_size_request(IIf(scrolledwidget, scrolledwidget, widget), Max(0, iWidth), Max(0, iHeight))
						'gtk_widget_size_allocate(IIF(scrolledwidget, scrolledwidget, widget), @allocation)
						'gtk_widget_queue_draw(widget)
						'?ClassName, FWidth, gtk_widget_get_allocated_width(widget)
						'FHeight = gtk_widget_get_allocated_height(widget)
						If gtk_is_layout(IIf(scrolledwidget, scrolledwidget, widget)) Then
							'?"width: " & gtk_widget_get_allocated_width(widget), "height: " & gtk_widget_get_allocated_height(widget), classname,;
							'If Parent Then ?parent->classname Else ?
						End If
						'RequestAlign iWidth, iHeight
						'Requests @This
					End If
				EndIf
			#else
				If FHandle Then MoveWindow FHandle, iLeft, iTop, iWidth, iHeight, True
			#endif
		End Sub
	#endif
	
	Sub Component.GetBounds(ALeft As Integer Ptr, ATop As Integer Ptr, AWidth As Integer Ptr, AHeight As Integer Ptr)
		*ALeft = This.Left
		*ATop = This.Top
		*AWidth = This.Width
		*AHeight = This.Height
	End Sub
	
	Sub Component.SetBounds(ALeft As Integer, ATop As Integer, AWidth As Integer, AHeight As Integer, NoScale As Boolean = False)
		If NoScale Then 'David Change
			FLeft   = ALeft
			FTop    = ATop
			FWidth  = AWidth
			FHeight = AHeight
		Else
			FLeft   = ScaleX(ALeft)
			FTop    = ScaleY(ATop)
			FWidth  = ScaleX(AWidth)
			FHeight = ScaleY(AHeight)
		End If
		FWidth = Max(FMinWidth, FWidth)
		FHeight = Max(FMinHeight, FHeight)
		Move FLeft, FTop, FWidth, FHeight
	End Sub
	
	#ifndef Left_Off
		Property Component.Left As Integer
			#ifdef __USE_GTK__
				If widget AndAlso gtk_widget_get_mapped(widget) Then
					Dim allocation As GtkAllocation
					gtk_widget_get_allocation(widget, @allocation)
					FLeft = allocation.x
				End If
			#else
				If FHandle Then
					If FParent AndAlso UCase(FParent->ClassName) = "TABCONTROL" Then
					Else
						Dim As Rect R
						GetWindowRect Handle,@R
						MapWindowPoints 0,GetParent(Handle),Cast(Point Ptr,@R), 2
						FLeft = R.Left
					End If
				End If
			#endif
			Return FLeft
		End Property
		
		Property Component.Left(Value As Integer)
			FLeft = Value
			Move FLeft, Top, This.Width, Height
		End Property
	#endif
	
	#ifndef Top_Off
		Property Component.Top As Integer
			#ifdef __USE_GTK__
				If widget AndAlso gtk_widget_get_mapped(widget) Then
					Dim allocation As GtkAllocation
					gtk_widget_get_allocation(widget, @allocation)
					FTop = allocation.y
				End If
			#else
				If FHandle Then
					If FParent AndAlso UCase(FParent->ClassName) = "SYSTABCONTROL32" Or UCase(FParent->ClassName) = "TABCONTROL" Then
					Else
						Dim As Rect R
						GetWindowRect Handle,@R
						MapWindowPoints 0,GetParent(Handle),Cast(Point Ptr,@R),2
						FTop = R.Top
					End If
				End If
			#endif
			Return FTop
		End Property
		
		Property Component.Top(Value As Integer)
			FTop = Value
			Move This.Left, FTop, This.Width, Height
		End Property
	#endif
	
	#ifndef Width_Off
		Property Component.Width As Integer
			#ifdef __USE_GTK__
				If gtk_is_widget(widget) AndAlso gtk_widget_get_realized(widget) Then
					If layoutwidget AndAlso gtk_widget_is_toplevel(widget) Then
						#ifdef __USE_GTK3__
							FWidth = gtk_widget_get_allocated_width(widget)
						#else
							FWidth = widget->allocation.width
						#endif
					ElseIf widget Then
						#ifdef __USE_GTK3__
							If gtk_widget_get_allocated_width(widget) > 1 Then FWidth = gtk_widget_get_allocated_width(widget)
						#else
							If widget->allocation.width > 1 Then FWidth = widget->allocation.width
						#endif
						'Dim As GtkAllocation alloc
						'gtk_widget_get_allocation (widget, @alloc)
						'FWidth = alloc.width
						'If gtk_widget_get_allocated_width(widget) > 1 Then FWidth = gtk_widget_get_allocated_width(widget)
						'FWidth = Max(gtk_widget_get_allocated_width(widget), FWidth)
					End If
				End If
			#else
				If FHandle Then
					Dim As Rect R
					GetWindowRect Handle, @R
					MapWindowPoints 0, GetParent(FHandle), Cast(Point Ptr, @R), 2
					FWidth = R.Right - R.Left
				End If
			#endif
			Return FWidth
		End Property
		
		Property Component.Width(Value As Integer)
			FWidth = Max(FMinWidth, Value)
			Move This.Left, This.Top, FWidth, Height
		End Property
	#endif
	
	#ifndef Height_Off
		Property Component.Height As Integer
			#ifdef __USE_GTK__
				If gtk_is_widget(widget) AndAlso gtk_widget_get_realized(widget) Then
					If layoutwidget AndAlso gtk_widget_is_toplevel(widget) Then
						#ifdef __USE_GTK3__
							FHeight = gtk_widget_get_allocated_height(widget)
						#else
							FHeight = widget->allocation.height
						#endif
					ElseIf widget Then
						#ifdef __USE_GTK3__
							If gtk_widget_get_allocated_height(widget) > 1 Then FHeight = gtk_widget_get_allocated_height(widget)
						#else
							If widget->allocation.height > 1 Then FHeight = widget->allocation.height
						#endif
					End If
				End If
			#else
				If FHandle Then
					Dim As Rect R
					GetWindowRect Handle, @R
					MapWindowPoints 0, GetParent(FHandle), Cast(Point Ptr, @R), 2
					FHeight = R.Bottom - R.Top
				End If
			#endif
			Return FHeight
		End Property
		
		Property Component.Height(Value As Integer)
			FHeight = Max(FMinHeight, Value)
			Move This.Left, This.Top, This.Width, FHeight
		End Property
	#endif
	
	Function Component.ToString ByRef As WString
		Return This.Name
	End Function
	
	Destructor Component
		WDeallocate FName
		WDeallocate FClassAncestor
		#ifdef __USE_GTK__
			If gtk_is_widget(Widget) Then
				gtk_widget_destroy(Widget)
				Widget = 0
			End If
			If gtk_is_widget(ScrolledWidget) Then
				gtk_widget_destroy(ScrolledWidget)
				ScrolledWidget = 0
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
		#else
			If FHandle Then
				DestroyWindow FHandle
				FHandle = 0
			End If
		#endif
	End Destructor
End Namespace

Sub ThreadsEnter
	#ifdef __USE_GTK__
		gdk_threads_enter()
	#endif
End Sub

Sub ThreadsLeave
	#ifdef __USE_GTK__
		gdk_threads_leave()
	#endif
End Sub

Function Q_Component Alias "Q_Component"(Cpnt As Any Ptr) As My.Sys.ComponentModel.Component Ptr __EXPORT__
	Return Cast(My.Sys.ComponentModel.Component Ptr, Cpnt)
End Function

Sub ComponentGetBounds Alias "ComponentGetBounds"(Cpnt As My.Sys.ComponentModel.Component Ptr, ALeft As Integer Ptr, ATop As Integer Ptr, AWidth As Integer Ptr, AHeight As Integer Ptr) __EXPORT__
	Cpnt->GetBounds(ALeft, ATop, AWidth, AHeight)
End Sub

Sub ComponentSetBounds Alias "ComponentSetBounds"(Cpnt As My.Sys.ComponentModel.Component Ptr, ALeft As Integer, ATop As Integer, AWidth As Integer, AHeight As Integer) __EXPORT__
	Cpnt->SetBounds(ALeft, ATop, AWidth, AHeight)
End Sub

