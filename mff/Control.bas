'###############################################################################
'#  Control.bas                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TControl.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.1                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "Control.bi"
#include once "Application.bi"

Namespace My.Sys.Forms
	#ifndef Control_Off
		Private Function SizeConstraints.ToString ByRef As WString
			WLet(FTemp, This.Left & "; " & This.Top & "; " & This.Width & "; " & This.Height)
			Return *FTemp
		End Function
		
		Private Function AnchorType.ToString ByRef As WString
			WLet(FTemp, This.Left & "; " & This.Top & "; " & This.Right & "; " & This.Bottom)
			Return *FTemp
		End Function
		
		#ifndef ReadProperty_Off
			Private Function Control.ReadProperty(ByRef PropertyName As String) As Any Ptr
				FTempString = LCase(PropertyName)
				Select Case FTempString
				Case "align": Return @FAlign
				Case "allowdrop": Return @FAllowDrop
				Case "anchor": Return @Anchor
				Case "anchor.left": Return @Anchor.Left
				Case "anchor.right": Return @Anchor.Right
				Case "anchor.top": Return @Anchor.Top
				Case "anchor.bottom": Return @Anchor.Bottom
				Case "borderstyle": Return @FBorderStyle
				Case "backcolor": Return @FBackColor
				Case "constraints": Return @Constraints
				Case "constraints.left": Return @Constraints.Left
				Case "constraints.top": Return @Constraints.Top
				Case "constraints.width": Return @Constraints.Width
				Case "constraints.height": Return @Constraints.Height
				Case "contextmenu": Return ContextMenu
				Case "controlindex": FControlIndex = ControlIndex: Return @FControlIndex
				Case "controlcount": Return @FControlCount
				Case "cursor": Return @This.Cursor
				Case "doublebuffered": Return @DoubleBuffered
				Case "grouped": Return @FGrouped
				Case "helpcontext": Return @HelpContext
					#ifdef __USE_GTK__
					Case "parentwidget": Return FParentWidget
					#elseif defined(__USE_WINAPI__)
					Case "parenthandle": Return @FParentHandle
					#endif
				Case "enabled": Return @FEnabled
				Case "forecolor": Return @FForeColor
				Case "font": Return @This.Font
				Case "id": Return @FID
				Case "ischild": Return @FIsChild
				Case "parent": Return FParent
				Case "showhint": Return @FShowHint
				Case "hint": Return FHint
				Case "subclass": Return @SubClass
				Case "tabstop": Return @FTabStop
				Case "text": Return FText.vptr
				Case "visible": Return @FVisible
				Case Else: Return Base.ReadProperty(PropertyName)
				End Select
				Return 0
			End Function
		#endif
		
		#ifndef WriteProperty_Off
			Private Function Control.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
				If Value = 0 Then
					Select Case LCase(PropertyName)
					Case "parent": This.Parent = Value
					Case Else: Return Base.WriteProperty(PropertyName, Value)
					End Select
				Else
					Select Case LCase(PropertyName)
					Case "align": This.Align = *Cast(DockStyle Ptr, Value)
					Case "allowdrop": This.AllowDrop = QBoolean(Value)
					Case "anchor.left": This.Anchor.Left = QInteger(Value)
					Case "anchor.right": This.Anchor.Right = QInteger(Value)
					Case "anchor.top": This.Anchor.Top = QInteger(Value)
					Case "anchor.bottom": This.Anchor.Bottom = QInteger(Value)
					Case "cursor": This.Cursor = QWString(Value)
					Case "doublebuffered": This.DoubleBuffered = QBoolean(Value)
					Case "borderstyle": This.BorderStyle = QInteger(Value)
					Case "backcolor": This.BackColor = QInteger(Value)
					Case "constraints.left": This.Constraints.Left = QInteger(Value)
					Case "constraints.top": This.Constraints.Top = QInteger(Value)
					Case "constraints.width": This.Constraints.Width = QInteger(Value)
					Case "constraints.height": This.Constraints.Height = QInteger(Value)
					Case "controlindex": This.ControlIndex = QInteger(Value)
					Case "contextmenu": This.ContextMenu = Cast(PopupMenu Ptr, Value)
					Case "enabled": This.Enabled = QBoolean(Value)
					Case "grouped": This.Grouped = QBoolean(Value)
					Case "helpcontext": This.HelpContext = QInteger(Value)
					Case "font": This.Font = *Cast(My.Sys.Drawing.Font Ptr, Value)
					Case "id": This.ID = QInteger(Value)
					Case "ischild": This.IsChild = QInteger(Value)
					Case "forecolor": This.ForeColor = QInteger(Value)
					Case "parent": This.Parent = Value
						#ifdef __USE_GTK__
						Case "parentwidget": This.ParentWidget = Value
						#elseif defined(__USE_WINAPI__)
						Case "parenthandle": This.ParentHandle = *Cast(HWND Ptr, Value)
						#endif
					Case "tabstop": ChangeTabStop QBoolean(Value)
					Case "text": This.Text = QWString(Value)
					Case "visible": This.Visible = QBoolean(Value)
					Case "showhint": This.ShowHint = QBoolean(Value)
					Case "hint": This.Hint = QWString(Value)
					Case "subclass": This.SubClass = QBoolean(Value)
					Case Else: Return Base.WriteProperty(PropertyName, Value)
					End Select
				End If
				Return True
			End Function
		#endif
		
		'Sub Requests(Cpnt As Component Ptr)
		'	If Cpnt AndAlso *Cpnt Is Control Then
		'		Dim Ctrl As Control Ptr = Cast(Control Ptr, Cpnt)
		'		If Ctrl->Controls Then
		'			Ctrl->RequestAlign
		'			For i As Integer = 0 To Ctrl->ControlCount - 1
		'				Requests Ctrl->Controls[i]
		'			Next i
		'			Ctrl->RequestAlign
		'		End If
		'		If Ctrl->OnReSize Then Ctrl->OnReSize(*Ctrl)
		'	End If
		'End Sub
		
		'    Property Control.Location As LocationType
		'        Return FLocation
		'    End Property
		'
		'    Property Control.Location(Value As LocationType)
		'        FLocation = Value
		'        FLeft = Value.X
		'        FTop = Value.Y
		'        If FHandle Then Move
		'    End Property
		
		Private Property Control.Location As My.Sys.Drawing.Point
			Return Type(This.Left, This.Top)
		End Property
		
		Private Property Control.Location(Value As My.Sys.Drawing.Point)
			This.SetBounds Value.X, Value.Y, This.Width, This.Height
		End Property
		
		Private Property Control.Size As My.Sys.Drawing.Size
			Return Type(This.Width, This.Height)
		End Property
		
		Private Property Control.Size(Value As My.Sys.Drawing.Size)
			This.SetBounds This.Left, This.Top, Value.Width, Value.Height
		End Property
		
		Private Property Control.AllowDrop As Boolean
			Return FAllowDrop
		End Property
		
		Private Property Control.AllowDrop(Value As Boolean)
			FAllowDrop = Value
			#ifdef __USE_GTK__
				If Value Then
					If GTK_IS_ENTRY(widget) OrElse GTK_IS_TEXT_VIEW(widget) Then
						#ifndef __USE_GTK3__
							Dim As GtkTargetEntry mytargets
							mytargets.target = Allocate(SizeOf(gchar) * 14)
							*mytargets.target = "text/uri-list"
							gtk_drag_dest_set(widget, GTK_DEST_DEFAULT_HIGHLIGHT, @mytargets, 1, GDK_ACTION_COPY)
							Deallocate mytargets.target
						#else
							gtk_drag_dest_set(widget, GTK_DEST_DEFAULT_HIGHLIGHT, gtk_target_entry_new("text/uri-list", 4, 0), 1, GDK_ACTION_COPY)
						#endif
						'gtk_drag_dest_add_text_targets(widget)
					Else
						Dim As GtkTargetEntry target_table(0)
						target_table(0).target = Cast(gchar Ptr, @"text/uri-list")
						target_table(0).flags = 4
						target_table(0).info  = 0
						gtk_drag_dest_set(widget, GTK_DEST_DEFAULT_ALL, @target_table(0), 1, GDK_ACTION_COPY)
						gtk_drag_dest_add_text_targets(widget)
					End If
					g_signal_connect(widget, "drag-data-received", G_CALLBACK(@DragDataReceived), @This)
				Else
					gtk_drag_dest_unset(widget)
				End If
			#elseif defined(__USE_WINAPI__)
				ChangeExStyle WS_EX_ACCEPTFILES, Value
				If FHandle AndAlso CInt(Not FDesignMode) Then RecreateWnd
			#endif
		End Property
		
		#ifndef ControlCount_Off
			Private Function Control.ControlCount As Integer
				Return FControlCount
			End Function
		#endif
		
		#ifndef Focused_Off
			Private Function Control.Focused As Boolean
				#ifdef __USE_GTK__
					Return widget AndAlso gtk_widget_is_focus(widget)
				#elseif defined(__USE_WINAPI__)
					Return GetFocus = FHandle
				#else
					Return False
				#endif
			End Function
		#endif
		
		#ifndef Control_GetTextLength_Off
			Private Function Control.GetTextLength() As Integer
				#ifdef __USE_WINAPI__
					If FHandle Then
						Return Perform(WM_GETTEXTLENGTH, 0, 0)
					Else
						Return Len(FText)
					EndIf
				#else
					Return Len(This.Text)
				#endif
			End Function
		#endif
		
		#ifndef GetForm_Off
			Private Function Control.GetForm As Control Ptr
				If FParent = 0 OrElse WGet(FClassName) = "Form" OrElse WGet(FClassName) = "UserControl" Then
					Return @This
				Else
					Return QControl(FParent)->GetForm()
				End If
			End Function
		#endif
		
		#ifndef Control_TopLevelControl_Off
			Private Function Control.TopLevelControl As Control Ptr
				If FParent = 0 Then
					Return @This
				Else
					Return QControl(FParent)->TopLevelControl()
				End If
			End Function
		#endif
		
		#ifndef BorderStyle_Off
			Private Property Control.BorderStyle As Integer
				Return FBorderStyle
			End Property
			
			Private Property Control.BorderStyle(Value As Integer)
				FBorderStyle = Value
				#ifdef __USE_GTK__
					If scrolledwidget Then
						If Value Then
							gtk_scrolled_window_set_shadow_type(GTK_SCROLLED_WINDOW(scrolledwidget), GTK_SHADOW_OUT)
						Else
							gtk_scrolled_window_set_shadow_type(GTK_SCROLLED_WINDOW(scrolledwidget), GTK_SHADOW_NONE)
						End If
					End If
				#elseif defined(__USE_WINAPI__)
					ChangeExStyle WS_EX_CLIENTEDGE, Value
				#endif
			End Property
		#endif
		
		#ifndef Style_Off
			Private Property Control.Style As Integer
				#ifdef __USE_WINAPI__
					If FHandle Then
						FStyle = GetWindowLong(FHandle, GWL_STYLE)
					End If
				#endif
				Return FStyle
			End Property
			
			Private Property Control.Style(Value As Integer)
				FStyle = Value
				#ifdef __USE_WINAPI__
					If FHandle Then
						SetWindowLong(FHandle, GWL_STYLE, FStyle)
						'SetWindowPos(FHandle, 0, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE Or SWP_DRAWFRAME)
						'RecreateWnd
					End If
				#endif
			End Property
		#endif
		
		#ifndef ExStyle_Off
			Private Property Control.ExStyle As Integer
				#ifdef __USE_WINAPI__
					If FHandle Then
						FExStyle = GetWindowLong(FHandle, GWL_EXSTYLE)
					End If
				#endif
				Return FExStyle
			End Property
			
			Private Property Control.ExStyle(Value As Integer)
				FExStyle = Value
				'If FHandle Then RecreateWnd
			End Property
		#endif
		
		#ifndef IsChild_Off
			Private Property Control.IsChild As Boolean
				#ifdef __USE_GTK__
					FIsChild = gtk_widget_get_parent(IIf(scrolledwidget, scrolledwidget, IIf(eventboxwidget, eventboxwidget, widget))) <> 0
				#elseif defined(__USE_WINAPI__)
					FIsChild = StyleExists(WS_CHILD)
				#endif
				Return FIsChild
			End Property
			
			Private Property Control.IsChild(Value As Boolean)
				FIsChild = Value
				#ifdef __USE_GTK__
					If FIsChild <> Value Then
						If Value Then
							If Parent AndAlso Parent->layoutwidget Then
								gtk_layout_put(GTK_LAYOUT(Parent->layoutwidget), IIf(scrolledwidget, scrolledwidget, IIf(layoutwidget, layoutwidget, IIf(eventboxwidget, eventboxwidget, widget))), FLeft, FTop)
							End If
						Else
							Dim As GtkWidget Ptr CtrlWidget = IIf(scrolledwidget, scrolledwidget, IIf(overlaywidget, overlaywidget, IIf(layoutwidget AndAlso gtk_widget_get_parent(layoutwidget) <> widget, layoutwidget, IIf(eventboxwidget, eventboxwidget, widget))))
							g_object_ref(G_OBJECT(CtrlWidget))
							gtk_widget_unparent(CtrlWidget)
						End If
					End If
				#elseif defined(__USE_WINAPI__)
					ChangeStyle WS_CHILD, Value
					If FHandle Then RecreateWnd
				#endif
			End Property
		#endif
		
		#ifndef ID_Off
			Private Property Control.ID As Integer
				#ifdef __USE_WINAPI__
					If FHandle Then
						FID = GetDlgCtrlID(FHandle)
					End If
				#endif
				Return FID
			End Property
			
			Private Property Control.ID(Value As Integer)
				FID = Value
			End Property
		#endif
		
		Private Property Control.ControlIndex As Integer
			If This.FParent Then
				Return Cast(Control Ptr, This.FParent)->IndexOf(@This)
			Else
				Return -1
			End If
		End Property
		
		Private Property Control.ControlIndex(Value As Integer)
			If This.FParent Then
				With *Cast(Control Ptr, This.FParent)
					.ChangeControlIndex @This, Value
					.RequestAlign
				End With
			End If
		End Property
			
		#ifndef Text_Off
			Private Property Control.Text ByRef As WString
				#ifdef __USE_WINAPI__
					If FHandle Then
						Dim As Integer L
						L = Perform(WM_GETTEXTLENGTH, 0, 0)
						FText.Resize(L + 1) '  = WString(L + 1 + 1, 0)
						GetWindowText(FHandle, FText.vptr, L + 1)
					End If
				#endif
				Return WGet(FText.vptr)
			End Property
			
			Private Property Control.Text(ByRef Value As WString)
				FText = Value
				#ifdef __USE_GTK__
					If widget Then
						If GTK_IS_WINDOW(widget) Then
							If Value = "" Then
								gtk_window_set_title(GTK_WINDOW(widget), !"\0")
							Else
								gtk_window_set_title(GTK_WINDOW(widget), ToUtf8(Value))
							End If
						End If
					End If
				#elseif defined(__USE_WINAPI__)
					If FHandle Then
						'If Value = "" Then
						'    SetWindowTextA FHandle, TempString
						'Else
						SetWindowTextW FHandle, FText.vptr
						'End If
					End If
				#endif
			End Property
		#endif
		
		#ifndef Hint_Off
			Private Property Control.Hint ByRef As WString
				Return WGet(FHint)
			End Property
			
			Private Property Control.Hint(ByRef Value As WString)
				WLet(FHint, Value)
				#ifdef __USE_GTK__
					If FShowHint Then
						If widget Then gtk_widget_set_tooltip_text(widget, ToUtf8(Value))
					End If
				#elseif defined(__USE_WINAPI__)
					If FHandle Then
						If ToolTipHandle Then
							SendMessage(ToolTipHandle, TTM_GETTOOLINFO, 0, CInt(@FToolInfo))
							FToolInfo.lpszText = FHint
							SendMessage(ToolTipHandle, TTM_UPDATETIPTEXT, 0, CInt(@FToolInfo))
						ElseIf FShowHint Then
							AllocateHint
						End If
					End If
				#endif
			End Property
		#endif
		
		#ifndef Align_Off
			Private Property Control.Align As DockStyle
				Return FAlign
			End Property
			
			Private Property Control.Align(Value As DockStyle)
				FAlign = Value
				'                #IfDef __USE_GTK__
				'					If widget Then
				'						Select Case FAlign
				'						Case 0 'None
				'							gtk_widget_set_halign(widget, GTK_ALIGN_BASELINE)
				'							gtk_widget_set_valign(widget, GTK_ALIGN_BASELINE)
				'						Case 1 'Left
				'							gtk_widget_set_halign(widget, GTK_ALIGN_START)
				'							gtk_widget_set_valign(widget, GTK_ALIGN_FILL)
				'						Case 2 'Right
				'							gtk_widget_set_halign(widget, GTK_ALIGN_END)
				'							gtk_widget_set_valign(widget, GTK_ALIGN_FILL)
				'						Case 3 'Top
				'							gtk_widget_set_halign(widget, GTK_ALIGN_FILL)
				'							gtk_widget_set_valign(widget, GTK_ALIGN_START)
				'						Case 4 'Bottom
				'							gtk_widget_set_halign(widget, GTK_ALIGN_FILL)
				'							gtk_widget_set_valign(widget, GTK_ALIGN_END)
				'						Case 5 'Client
				'							gtk_widget_set_halign(widget, GTK_ALIGN_FILL)
				'							gtk_widget_set_valign(widget, GTK_ALIGN_FILL)
				'						End Select
				'					End If
				'                #EndIf
				If FParent <> 0 Then QControl(FParent).RequestAlign
			End Property
		#endif
		
		#ifndef ClientWidth_Off
			Private Function Control.ClientWidth As Integer
				#ifdef __USE_GTK__
					Dim As GtkRequisition minimum, requisition
					If layoutwidget Then
						#ifndef __USE_GTK2__
							FClientWidth = gtk_widget_get_allocated_width(layoutwidget)
						#else
							FClientWidth = layoutwidget->allocation.width
						#endif
						'ElseIf fixedwidget Then
						'	FClientWidth = gtk_widget_get_allocated_width(fixedwidget)
						
						'	Dim As guint width_, height_
						'gtk_widget_get_preferred_size(scrolledwidget, @minimum, @requisition)
						'	gtk_layout_get_size(GTK_LAYOUT(layoutwidget), @width_, @height_)
						'	FClientWidth = width_
						'If scrolledwidget Then
						'gtk_widget_get_preferred_size(scrolledwidget, @minimum, @requisition)
						'FClientWidth = gtk_widget_get_allocated_width(scrolledwidget)
						'FClientWidth = minimum.width
						'ElseIf fixedwidget Then
						'	FClientWidth = gtk_widget_get_allocated_width(fixedwidget)
					ElseIf widget Then
						'gtk_widget_get_preferred_size(widget, @minimum, @requisition)
						'FClientWidth = gtk_widget_get_allocated_width(widget)
						FClientWidth = This.Width
						'FClientWidth = minimum.width
					End If
				#elseif defined(__USE_WINAPI__)
					If FHandle Then
						Dim As ..Rect R
						GetClientRect FHandle , @R
						FClientWidth = UnScaleX(R.Right)
						'            If UCase(ClassName) = "SYSTABCONTROL32" OR UCase(ClassName) = "TABCONTROL" Then
						'                InflateRect @R, -4, -4
						'                If (FParent->StyleExists(TCS_VERTICAL)) Then
						'                    Perform(TCM_GETITEMRECT, 0, CInt(@RR))
						'                    FClientWidth = R.Right - (RR.Right - RR.Left) - 3
						'                else
						'                    FClientWidth = R.Right - 2
						'                End If
						'            End If
					End If
				#elseif defined(__USE_JNI__)
					If FHandle Then
						If layoutview Then
							FClientWidth = UnScaleX(CallIntMethod(layoutview, "android/view/View", "getWidth", "()I"))
						Else
							FClientWidth = This.Width
						End If
					End If
				#endif
				Return FClientWidth
			End Function
		#endif
		
		#ifndef ClientHeight_Off
			Private Function Control.ClientHeight As Integer
				#ifdef __USE_GTK__
					Dim As GtkRequisition minimum, requisition
					If layoutwidget Then
						#ifndef __USE_GTK2__
							FClientHeight = gtk_widget_get_allocated_height(layoutwidget)
						#else
							FClientHeight = layoutwidget->allocation.height
						#endif
						'ElseIf fixedwidget Then
						'	FClientHeight = gtk_widget_get_allocated_height(fixedwidget)
						'	Dim As guint width_, height_
						'gtk_widget_get_preferred_size(scrolledwidget, @minimum, @requisition)
						'	gtk_layout_get_size(GTK_LAYOUT(layoutwidget), @width_, @height_)
						'	FClientHeight = height_
						'If scrolledwidget Then
						'gtk_widget_get_preferred_size(scrolledwidget, @minimum, @requisition)
						'	FClientHeight = gtk_widget_get_allocated_height(scrolledwidget) - 10
						'ElseIf fixedwidget Then
						'	FClientHeight = gtk_widget_get_allocated_height(fixedwidget)
					ElseIf widget Then
						'gtk_widget_get_preferred_size(widget, @minimum, @requisition)
						'FClientHeight = gtk_widget_get_allocated_height(widget) - 10
						FClientHeight = This.Height
					End If
				#elseif defined(__USE_WINAPI__)
					If FHandle Then
						Dim As ..Rect R
						GetClientRect FHandle, @R
						FClientHeight = UnScaleY(R.Bottom)
						'            If UCase(ClassName) = "SYSTABCONTROL32" OR UCase(ClassName) = "TABCONTROL" Then
						'                InflateRect @R,-4, -4
						'                If (Not FParent->StyleExists(TCS_VERTICAL)) Then
						'                    Perform(TCM_GETITEMRECT,0,CInt(@RR))
						'                    FClientHeight = R.Bottom - (RR.Bottom - RR.Top) - 3
						'                Else
						'                    FClientHeight = R.Bottom - 2
						'                End If
						'            End If
					End If
				#elseif defined(__USE_JNI__)
					If FHandle Then
						If layoutview Then
							FClientHeight = UnScaleY(CallIntMethod(layoutview, "android/view/View", "getHeight", "()I"))
						Else
							FClientHeight = This.Height
						End If
					End If
				#endif
				Return FClientHeight
			End Function
		#endif
		
		#ifndef ShowHint_Off
			Private Property Control.ShowHint As Boolean
				Return FShowHint
			End Property
			
			Private Property Control.ShowHint(Value As Boolean)
				FShowHint = Value
				#ifdef __USE_GTK__
					If widget Then gtk_widget_set_has_tooltip(widget, Value)
					If WGet(FHint) <> "" Then
						If Value Then
							gtk_widget_set_tooltip_text(widget, ToUtf8(*FHint))
						Else
							gtk_widget_set_tooltip_text(widget, "")
						End If
					End If
				#elseif defined(__USE_WINAPI__)
					If FHandle Then
						If ToolTipHandle Then SendMessage(ToolTipHandle, TTM_ACTIVATE, FShowHint, 0)
					End If
				#endif
			End Property
		#endif
		
		#ifndef Color_Off
			Private Property Control.BackColor As Integer
				Return FBackColor
			End Property
			
			Private Property Control.BackColor(Value As Integer)
				FBackColor = Value
				FBackColorRed = GetRed(Value) / 255.0
				FBackColorGreen = GetGreen(Value) / 255.0
				FBackColorBlue = GetBlue(Value) / 255.0
				Brush.Color = FBackColor
				Canvas.BackColor = FBackColor
				Invalidate
			End Property
			
			Private Property Control.ForeColor As Integer
				Return FForeColor
			End Property
			
			Private Property Control.ForeColor(Value As Integer)
				FForeColor = Value
				FForeColorRed = GetRed(Value) / 255.0
				FForeColorGreen = GetGreen(Value) / 255.0
				FForeColorBlue = GetBlue(Value) / 255.0
				Font.Color = FForeColor
				Canvas.Font.Color = FForeColor
				Invalidate
			End Property
		#endif
		
		#ifndef Control_Parent_Off
			#ifndef Control_Parent_Get_Off
				Private Property Control.Parent As Control Ptr
					Return Cast(Control Ptr, FParent)
				End Property
			#endif
			
			#ifndef Control_Parent_Set_Off
				Private Property Control.Parent(Value As Control Ptr)
					If FParent <> Value Then
						FParent = Value
						If Value Then Value->Add(@This)
					End If
				End Property
			#endif
		#endif
		
		#ifndef Control_StyleExists_Off
			Private Function Control.StyleExists(iStyle As Integer) As Boolean
				Return (Style And iStyle) = iStyle
			End Function
		#endif
		
		#ifndef Control_ExStyleExists_Off
			Private Function Control.ExStyleExists(iStyle As Integer) As Boolean
				Return (ExStyle And iStyle) = iStyle
			End Function
		#endif
		
		#ifndef Control_ChangeStyle_Off
			Private Sub Control.ChangeStyle(iStyle As Integer, Value As Boolean)
				If Value Then
					If ((Style And iStyle) <> iStyle) Then Style = Style Or iStyle
				ElseIf ((Style And iStyle) = iStyle) Then
					Style = Style And Not iStyle
				End If
			End Sub
		#endif
		
		Private Sub Control.ChangeExStyle(iStyle As Integer, Value As Boolean)
			If Value Then
				If ((ExStyle And iStyle) <> iStyle) Then ExStyle = ExStyle Or iStyle
			ElseIf ((ExStyle And iStyle) = iStyle) Then
				ExStyle = ExStyle And Not iStyle
			End If
		End Sub
		
		#ifndef Control_ChangeControlIndex_Off
			Private Sub Control.ChangeControlIndex(Ctrl As Control Ptr, Index As Integer)
				Dim OldIndex As Integer = This.IndexOf(Ctrl)
				If OldIndex > -1 AndAlso OldIndex <> Index AndAlso Index <= FControlCount - 1 Then
					If Index < OldIndex Then
						For i As Integer = OldIndex - 1 To Index Step -1
							Controls[i + 1] = Controls[i]
						Next i
						Controls[Index] = Ctrl
					Else
						For i As Integer = OldIndex + 1 To Index
							Controls[i - 1] = Controls[i]
						Next i
						Controls[Index] = Ctrl
					End If
				End If
			End Sub
		#endif
		
		Private Sub Control.ChangeTabIndex(Value As Integer)
			FTabIndex = Value
			#ifndef __USE_GTK__
				If FHandle = 0 Then Exit Sub
			#endif
			Dim As Control Ptr ParentCtrl = GetForm
			Dim As Control Ptr Ctrl
			If ParentCtrl Then
				With *ParentCtrl
					.GetControls
					.FTabIndexList.Clear
					Dim As Integer Idx
					For i As Integer = 0 To .FControls.Count - 1
						Ctrl = .FControls.Item(i)
						If Ctrl <> @This AndAlso Ctrl->FTabIndex <> -2 Then .FTabIndexList.Add Ctrl->FTabIndex, Ctrl
					Next
					If FTabIndex = -1 OrElse FTabIndex > .FTabIndexList.Count Then FTabIndex = .FTabIndexList.Count
					.FTabIndexList.Sort
					If FTabIndex <> -2 Then .FTabIndexList.Insert FTabIndex, FTabIndex, @This
					For i As Integer = 0 To .FTabIndexList.Count - 1
						Ctrl = .FTabIndexList.Object(i)
						Ctrl->FTabIndex = i
					Next
				End With
			End If
		End Sub
		
		#ifdef __USE_GTK__
			Private Property Control.ParentWidget As GtkWidget Ptr
				Return FParentWidget
			End Property
			
			Private Property Control.ParentWidget(Value As GtkWidget Ptr)
				FParentWidget = Value
				If GTK_IS_WIDGET(widget) Then
					If GTK_IS_LAYOUT(Value) Then
						gtk_layout_put(GTK_LAYOUT(Value), widget, FLeft, FTop)
					ElseIf GTK_IS_FIXED(Value) Then
						gtk_fixed_put(GTK_FIXED(Value), widget, FLeft, FTop)
					ElseIf GTK_IS_CONTAINER(Value) Then
						gtk_container_add(GTK_CONTAINER(Value), widget)
					End If
				End If
			End Property
		#elseif defined(__USE_WINAPI__)
			Private Property Control.ParentHandle As HWND
				Return FParentHandle
			End Property
			
			Private Property Control.ParentHandle(Value As HWND)
				FParentHandle = Value
			End Property
		#endif
		
		#ifndef Control_ChangeTabStop_Off
			Private Sub Control.ChangeTabStop(Value As Boolean)
				FTabStop = Value
				#ifdef __USE_WINAPI__
					ChangeStyle WS_TABSTOP, Value
				#endif
			End Sub
		#endif
		
		Private Property Control.Grouped As Boolean
			#ifdef __USE_WINAPI__
				FGrouped = StyleExists(WS_GROUP)
			#endif
			Return FGrouped
		End Property
		
		Private Property Control.Grouped(Value As Boolean)
			FGrouped = Value
			#ifdef __USE_WINAPI__
				ChangeStyle WS_GROUP, Value
			#endif
		End Property
		
		Private Property Control.Enabled As Boolean
			#ifdef __USE_WINAPI__
				If FHandle Then FEnabled = IsWindowEnabled(FHandle)
			#endif
			Return FEnabled
		End Property
		
		Private Property Control.Enabled(Value As Boolean)
			FEnabled = Value
			#ifdef __USE_GTK__
				If widget Then gtk_widget_set_sensitive(widget, FEnabled)
			#elseif defined(__USE_WINAPI__)
				If FHandle Then EnableWindow FHandle, FEnabled
			#endif
		End Property
		
		Private Property Control.Visible() As Boolean
			#ifdef __USE_WINAPI__
				If FHandle Then FVisible = IsWindowVisible(FHandle)
			#endif
			Return FVisible
		End Property
		
		Private Property Control.Visible(Value As Boolean)
			FVisible = Value
			If (Not FDesignMode) OrElse Value Then
				#ifdef __USE_GTK__
					If widget Then
						'If Not gtk_widget_is_toplevel(widget) Then gtk_widget_set_child_visible(widget, Value)
						gtk_widget_set_visible(widget, Value)
						'gtk_widget_set_no_show_all(widget, Not Value)
						If Value Then RequestAlign
					End If
				#elseif defined(__USE_WINAPI__)
					If FHandle = 0 And CInt(Value) Then
						CreateWnd
					End If
					'If FParent Then FParent->RequestAlign
					If FHandle Then
						If Value Then
							ShowWindow(FHandle, SW_SHOW)
							'UpdateWindow(FHandle)
						Else
							ShowWindow(FHandle, SW_HIDE)
						End If
					End If
				#endif
			End If
		End Property
		
		Private Sub Control.Show
			Visible = True
		End Sub
		
		Private Sub Control.Hide '...'
			Visible = False
		End Sub
		
		#ifdef __USE_WINAPI__
			Private Sub Control.SetDark(Value As Boolean)
				FDarkMode = Value
				If Value Then
					If FDefaultBackColor = FBackColor Then
						Brush.Handle = hbrBkgnd
					End If
					SetWindowTheme(FHandle, "DarkMode_Explorer", nullptr)
					If ToolTipHandle <> 0 Then SetWindowTheme(ToolTipHandle, "DarkMode_Explorer", nullptr)
				Else
					SetWindowTheme(FHandle, NULL, NULL)
					If ToolTipHandle <> 0 Then SetWindowTheme(ToolTipHandle, NULL, NULL)
					If FBackColor = -1 Then
						Brush.Handle = 0
					Else
						Brush.Color = FBackColor
					End If
				End If
				AllowDarkModeForWindow(FHandle, g_darkModeEnabled)
				'SendMessageW(FHandle, WM_THEMECHANGED, 0, 0)
			End Sub
		#endif
		
		Private Sub Control.CreateWnd
			Dim As Long nLeft   = ScaleX(FLeft)
			Dim As Long nTop    = ScaleY(FTop)
			Dim As Long nWidth  = ScaleX(FWidth)
			Dim As Long nHeight = ScaleY(FHeight)
			#ifdef __USE_WINAPI__
				If FHandle Then Exit Sub
				Dim As HWND HParent
				Dim As Integer ControlID = 0
				If (Style And WS_CHILD) = WS_CHILD Then
					If FParent Then
						HParent = FParent->Handle
						FID =  1000 + Cast(Control Ptr, FParent)->ControlCount
						ControlID = FID
					ElseIf FOwner <> 0 AndAlso FOwner->Handle Then
						HParent = FOwner->Handle
					ElseIf FParentHandle <> 0 Then
						HParent = FParentHandle
					Else
						Exit Sub
					End If
				Else
					If FParent Then
						If Cast(Control Ptr, FParent)->FClient Then
							HParent = Cast(Control Ptr, FParent)->FClient
						Else
							HParent = FParent->Handle
						End If
					Else
						HParent = NULL
						'						If MainHandle Then
						'							HParent = MainHandle
						'						End If
						If FOwner Then
							HParent = FOwner->Handle
						End If
					End If
					ControlID = NULL
				End If
				#if __USE_X11__
					Dim As Display Ptr dpy
					Dim As Integer Screen
					Dim As Window win
					Dim As XEvent Event
					
					
					dpy = XOpenDisplay()
					
					
					If dpy = 0 Then
						Exit Sub
					End If
					
					
					Screen = DefaultScreen(dpy)
					
					
					win = XCreateSimpleWindow(dpy, RootWindow(dpy, Screen), FLeft, FTop, FWidth, FHeight, 1, BlackPixel(dpy, Screen), WhitePixel(dpy, Screen))
					
					
					XSelectInput(dpy, win, ExposureMask Or KeyPressMask)
					XMapWindow(dpy, win)
				#else
					Select Case FStartPosition
					Case 0 ' Manual
					Case 1, 4 ' CenterScreen, CenterParent
						If FStartPosition = 4 AndAlso FParent Then ' CenterParent
							With *Cast(Control Ptr, FParent)
								nLeft = ScaleX(.Left) + (ScaleX(.Width) - nWidth) \ 2: nTop  = ScaleY(.Top) + (ScaleY(.Height) - nHeight) \ 2
							End With
						Else ' CenterScreen
							nLeft = (GetSystemMetrics(SM_CXSCREEN) - nWidth) \ 2: nTop  = (GetSystemMetrics(SM_CYSCREEN) - nHeight) \ 2
						End If
					Case 2: nLeft = CW_USEDEFAULT: nTop = CW_USEDEFAULT ' WindowsDefaultLocation
					Case 3: nLeft = CW_USEDEFAULT: nTop = CW_USEDEFAULT: nWidth = CW_USEDEFAULT: nHeight = CW_USEDEFAULT ' WindowsDefaultBounds
					End Select
					Dim As Integer AControlParent(2) => {0, WS_EX_CONTROLPARENT}
					Dim As Integer ATabStop(2) => {0,WS_TABSTOP},AGrouped(2) = >{0,WS_GROUP}
					If ClassName = "WebBrowser" Then
						'Style = WS_TABSTOP Or WS_CHILD Or WS_VISIBLE
						'ExStyle = 0
						'					ElseIf ClassName = "IPAddress" Then
						'						Text = ""
						'						Style = WS_TABSTOP Or WS_CHILD Or WS_VISIBLE Or WS_OVERLAPPED
						'						ExStyle = 0
					Else
						If (Style And (WS_CLIPCHILDREN Or WS_CLIPSIBLINGS)) <> (WS_CLIPCHILDREN Or WS_CLIPSIBLINGS) Then
							Style = Style Or (WS_CLIPCHILDREN Or WS_CLIPSIBLINGS)
						End If
						If (Style And (ATabStop(abs_(FTabStop)) Or AGrouped(abs_(FGrouped)))) <> (ATabStop(abs_(FTabStop)) Or AGrouped(abs_(FGrouped))) Then
							Style = Style Or (ATabStop(abs_(FTabStop)) Or AGrouped(abs_(FGrouped)))
						End If
						If (ExStyle And AControlParent(abs_(FControlParent))) <> AControlParent(abs_(FControlParent)) Then
							ExStyle = ExStyle Or AControlParent(abs_(FControlParent))
						End If
					End If
					CreationControl = @This
					'RegisterClass ClassName, ClassAncestor
					Dim As DWORD dExStyle = FExStyle
					Dim As DWORD dStyle = FStyle
					'					If ExStyleExists(WS_EX_MDICHILD) Then
					'						Dim As MDICREATESTRUCT mdicreate
					'						mdicreate.szClass = FClassName
					'						mdicreate.szTitle = FText.vptr
					'						mdicreate.hOwner  = GetModuleHandle(0)
					'						mdicreate.x       = nLeft
					'						mdicreate.y       = nTop
					'						mdicreate.cx      = nWidth
					'						mdicreate.cy      = nHeight
					'						mdicreate.style   = dStyle
					'						mdicreate.lParam  = Cast(LPARAM, @This)
					'						FHandle = Cast(HWND, SendMessage(HParent, WM_MDICREATE, 0, Cast(LPARAM, @mdicreate)))
					'					Else
					FHandle = CreateWindowExW(dExStyle, _
					FClassName, _
					IIf(CInt(*FClassName = "WebBrowser") AndAlso CInt(FParent <> 0) AndAlso CInt(FParent->FDesignMode), 0, FText.vptr), _
					dStyle, _
					nLeft, _
					nTop, _
					nWidth, _
					nHeight, _
					HParent, _
					Cast(HMENU, ControlID), _
					Instance, _
					@This) ' '
					'End If
				#endif
			#elseif defined(__USE_JNI__)
				If pApp = 0 OrElse env = 0 OrElse pApp->Instance = 0 Then Exit Sub
				If FHandle = 0 AndAlso *FClassAncestor <> "" Then
					Dim As jclass class_object = (*env)->FindClass(env, *FClassAncestor)
					Dim As jmethodID ConstructorMethod = (*env)->GetMethodID(env, class_object, "<init>", "(Landroid/content/Context;)V")
					FHandle = (*env)->NewObject(env, class_object, ConstructorMethod, pApp->Instance)
				End If
				Text = FText
			#endif
			#if defined(__USE_WINAPI__) OrElse defined(__USE_JNI__)
				If FHandle Then
					#ifdef __USE_WINAPI__
						If GetWindowLongPtr(FHandle, GWLP_USERDATA) = 0 Then
							SetWindowLongPtr(FHandle, GWLP_USERDATA, CInt(Child))
						End If
						SetProp(FHandle, "MFFControl", @This)
						If SubClass Then
							PrevProc = Cast(Any Ptr, SetWindowLongPtr(FHandle, GWLP_WNDPROC, CInt(@CallWndProc)))
						End If
						If (g_darkModeSupported AndAlso g_darkModeEnabled) Then
							SetDark True
							'							If FDefaultBackColor = FBackColor Then
							'								Brush.Handle = hbrBkgnd
							'							End If
							'							SetWindowTheme(FHandle, "DarkMode_Explorer", nullptr)
							'							SendMessageW(FHandle, WM_THEMECHANGED, 0, 0)
						End If
					#elseif defined(__USE_JNI__)
						If pApp AndAlso env Then
							Handles.Add @This
							FHandle = (*env)->NewGlobalRef(env, FHandle)
							If layoutview Then
								layoutview = (*env)->NewGlobalRef(env, layoutview)
								Dim As jclass class_view = (*env)->FindClass(env, "android/view/View")
								(*env)->CallVoidMethod(env, layoutview, (*env)->GetMethodID(env, class_view, "setId", "(I)V"), FID)
								Dim As jmethodID setOnClickListener = (*env)->GetMethodID(env, class_view, "setOnClickListener", "(Landroid/view/View$OnClickListener;)V")
								(*env)->CallVoidMethod(env, layoutview, setOnClickListener, pApp->MainForm->Handle)
								Dim As jmethodID addOnLayoutChangeListener = (*env)->GetMethodID(env, class_view, "addOnLayoutChangeListener", "(Landroid/view/View$OnLayoutChangeListener;)V")
								(*env)->CallVoidMethod(env, layoutview, addOnLayoutChangeListener, pApp->MainForm->Handle)
							End If
							FID = Handles.Count - 1
							If This.Parent AndAlso This.Parent->layoutview Then
								(*env)->CallVoidMethod(env, FHandle, GetMethodID("android/view/View", "setId", "(I)V"), FID)
								Dim As jclass class_viewgroup = (*env)->FindClass(env, "android/view/ViewGroup")
								Dim As jmethodID addviewMethod = (*env)->GetMethodID(env, class_viewgroup, "addView", "(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V")
								Dim As jclass class_MarginLayoutParams = (*env)->FindClass(env, "android/widget/AbsoluteLayout$LayoutParams")
								Dim As jmethodID ConstructorMethod = (*env)->GetMethodID(env, class_MarginLayoutParams, "<init>", "(IIII)V")
								Dim As jobject MarginLayoutParams = (*env)->NewObject(env, class_MarginLayoutParams, ConstructorMethod, ScaleX(FWidth), ScaleY(FHeight), ScaleX(FLeft), ScaleY(FTop))
								'								Dim As jfieldID LeftField = (*env)->GetFieldID(env, class_MarginLayoutParams, "leftMargin", "I")
								'								(*env)->SetIntField(env, MarginLayoutParams, LeftField, FLeft)
								'								Dim As jfieldID TopField = (*env)->GetFieldID(env, class_MarginLayoutParams, "topMargin", "I")
								'								(*env)->SetIntField(env, MarginLayoutParams, TopField, FTop)
								(*env)->CallVoidMethod(env, This.Parent->layoutview, addviewMethod, FHandle, MarginLayoutParams)
								'Text = Str(1)
								If OnClick Then
									Dim As jclass class_view = (*env)->FindClass(env, "android/view/View")
									Dim As jmethodID setOnClickListener = (*env)->GetMethodID(env, class_view, "setOnClickListener", "(Landroid/view/View$OnClickListener;)V")
									(*env)->CallVoidMethod(env, FHandle, setOnClickListener, pApp->MainForm->Handle)
									Dim As jmethodID addOnLayoutChangeListener = (*env)->GetMethodID(env, class_view, "addOnLayoutChangeListener", "(Landroid/view/View$OnLayoutChangeListener;)V")
									(*env)->CallVoidMethod(env, FHandle, addOnLayoutChangeListener, pApp->MainForm->Handle)
								End If
								'								Dim As jclass class_MarginLayoutParams = (*env)->FindClass(env, "android/view/ViewGroup$MarginLayoutParams")
								'								Dim As jmethodID ConstructorMethod = (*env)->GetMethodID(env, class_MarginLayoutParams, "<init>", "(II)V")
								'								Dim As jobject MarginLayoutParams = (*env)->NewObject(env, class_MarginLayoutParams, ConstructorMethod, FWidth, FHeight)
								'								Dim As jfieldID LeftField = (*env)->GetFieldID(env, class_MarginLayoutParams, "leftMargin", "I")
								'								(*env)->SetIntField(env, MarginLayoutParams, LeftField, FLeft)
								'								Dim As jfieldID TopField = (*env)->GetFieldID(env, class_MarginLayoutParams, "topMargin", "I")
								'								(*env)->SetIntField(env, MarginLayoutParams, TopField, FTop)
								'								(*env)->CallVoidMethod(env, This.Parent->layoutview, addviewMethod, FHandle, MarginLayoutParams)
								'								Dim As jclass class_view = (*env)->FindClass(env, "android/view/View")
								'								Dim As jmethodID setLeftMethod = (*env)->GetMethodID(env, class_view, "setLeft", "(I)V")
								'								Dim As jmethodID setTopMethod = (*env)->GetMethodID(env, class_view, "setTop", "(I)V")
								'								(*env)->CallVoidMethod(env, FHandle, setLeftMethod, FLeft)
								'								(*env)->CallVoidMethod(env, FHandle, setTopMethod, FTop)
							End If
						End If
					#endif
					BringToFront
					This.Font.Parent = @This 'If This.Font Then
					#ifdef __USE_WINAPI__
						SendMessage FHandle, CM_CREATE, 0, 0
						If ShowHint AndAlso Hint <> "" Then AllocateHint
					#endif
					If FParent Then
						FAnchoredParentWidth = Cast(Control Ptr, FParent)->Width
						FAnchoredParentHeight = Cast(Control Ptr, FParent)->Height
						FAnchoredLeft = FLeft
						FAnchoredTop = FTop
						FAnchoredRight = FAnchoredParentWidth - FWidth - FLeft
						FAnchoredBottom = FAnchoredParentHeight - FHeight - FTop
					End If
					Dim i As Integer
					This.RequestAlign
					For i = 0 To This.ControlCount - 1
						This.Controls[i]->RequestAlign
						This.Controls[i]->CreateWnd
					Next i
					This.RequestAlign
					If This.ContextMenu Then This.ContextMenu->ParentWindow = @This
					If OnHandleIsAllocated Then OnHandleIsAllocated(This)
					If OnCreate Then OnCreate(This)
					If Not FEnabled Then Enabled = FEnabled
					#ifdef __USE_WINAPI__
						If FVisible Then If ClassName = "Form" Then This.Show Else ShowWindow(FHandle, SW_SHOWNORMAL)
						Update
					#elseif defined(__USE_JNI__)
						If FVisible Then This.Show
					#endif
				Else
					'Print ClassName, GetErrorString(GetLastError, , True)
				End If
			#endif
		End Sub
		
		#ifndef Control_RecreateWnd_Off
			Private Sub Control.RecreateWnd
				Dim As Integer i
				#ifndef __USE_GTK__
					If FHandle = 0 Then Exit Sub
					'For i = 0 To ControlCount -1
					'    Controls[i]->FreeWnd
					'Next i
					FreeWnd
					CreateWnd
					For i = 0 To ControlCount -1
						Controls[i]->RecreateWnd
						Controls[i]->RequestAlign
					Next i
					RequestAlign
				#endif
			End Sub
		#endif
		
		Private Sub Control.FreeWnd
			#ifdef __USE_GTK__
				'				If gtk_is_widget(Widget) Then
				'					gtk_widget_destroy(Widget)
				'				End If
				'				If gtk_is_widget(ScrolledWidget) Then
				'					gtk_widget_destroy(ScrolledWidget)
				'				End If
			#elseif defined(__USE_WINAPI__)
				If OnHandleIsDestroyed Then OnHandleIsDestroyed(This)
				If FHandle Then
					'					For i As Integer = 0 To ControlCount - 1
					'						Controls[i]->FreeWnd
					'					Next
					If ClassName <> "IPAddress" Then DestroyWindow FHandle
					Handle = 0
				End If
				If ToolTipHandle Then
					DestroyWindow ToolTipHandle
					ToolTipHandle = 0
				End If
			#endif
		End Sub
		
		Private Property Control.ContextMenu As PopupMenu Ptr
			Return FContextMenu
		End Property
		
		Private Property Control.ContextMenu(Value As PopupMenu Ptr)
			FContextMenu = Value
			If FContextMenu Then FContextMenu->ParentWindow = @This
		End Property
		
		#ifdef __USE_GTK__
			Private Function Control.hover_cb(ByVal user_data As gpointer) As gboolean
				Delete Cast(Boolean Ptr, user_data)
				If hover_timer_id Then
					If user_data = MouseHoverMessage.pBoolean Then
						Dim As Control Ptr Ctrl = MouseHoverMessage.Sender
						If Ctrl->OnMouseHover Then Ctrl->OnMouseHover(*Ctrl, Ctrl->DownButton, MouseHoverMessage.X, MouseHoverMessage.Y, MouseHoverMessage.State)
					End If
				End If
				Return False
			End Function
		#endif
		
		#define WM_DPICHANGED       &h02E0
		
		Private Sub Control.ProcessMessage(ByRef Message As Message)
			Static bShift As Boolean, bCtrl As Boolean
			If OnMessage Then OnMessage(This, Message)
			#ifdef __USE_GTK__
				Dim As GdkEvent Ptr e = Message.Event
				Select Case Message.Event->type
				Case GDK_NOTHING
				Case GDK_BUTTON_PRESS
					'Message.Result = True
					DownButton = e->button.button - 1
					#ifdef __USE_GTK4__
						If gtk_widget_get_window(widget) = e->motion.window Then
							If OnMouseDown Then OnMouseDown(This, e->button.button - 1, e->button.x, e->button.y, e->button.state)
						End If
					#else
						If gtk_widget_get_window(widget) = e->motion.window OrElse (layoutwidget AndAlso gtk_layout_get_bin_window(GTK_LAYOUT(layoutwidget)) = e->motion.window) Then
							If OnMouseDown Then OnMouseDown(This, e->button.button - 1, e->button.x, e->button.y, e->button.state)
						End If
					#endif
				Case GDK_BUTTON_RELEASE
					'Message.Result = True
					DownButton = -1
					If GTK_IS_BUTTON(widget) = 0 Then
						If OnClick Then OnClick(This)
					End If
					#ifdef __USE_GTK4__
						If gtk_widget_get_window(widget) = e->motion.window Then
							If OnMouseUp Then OnMouseUp(This, e->button.button - 1, e->button.x, e->button.y, e->button.state)
						End If
					#else
						If gtk_widget_get_window(widget) = e->motion.window OrElse (layoutwidget AndAlso gtk_layout_get_bin_window(GTK_LAYOUT(layoutwidget)) = e->motion.window) Then
							If OnMouseUp Then OnMouseUp(This, e->button.button - 1, e->button.x, e->button.y, e->button.state)
						End If
					#endif
					If e->button.button = 3 AndAlso ContextMenu Then
						Message.Result = True
						If ContextMenu->widget Then
							ContextMenu->Popup(e->button.x, e->button.y, @Message)
						End If
					End If
					#ifdef __USE_GTK3__
					Case GDK_2BUTTON_PRESS, GDK_DOUBLE_BUTTON_PRESS
					#else
					Case GDK_2BUTTON_PRESS
					#endif
					If OnDblClick Then OnDblClick(This)
					Message.Result = True
					#ifdef __USE_GTK3__
					Case GDK_3BUTTON_PRESS, GDK_TRIPLE_BUTTON_PRESS
					#else
					Case GDK_3BUTTON_PRESS
					#endif
				Case GDK_MOTION_NOTIFY
					'Message.Result = True
					#ifdef __USE_GTK4__
						If gtk_widget_get_window(widget) = e->motion.window Then
					#else
						If gtk_widget_get_window(widget) = e->motion.window OrElse (layoutwidget AndAlso gtk_layout_get_bin_window(GTK_LAYOUT(layoutwidget)) = e->motion.window) Then
					#endif
						If OnMouseMove Then OnMouseMove(This, DownButton, e->motion.x, e->motion.y, e->motion.state)
						hover_timer_id = 0
						If OnMouseHover Then
							Dim As Boolean Ptr pBoolean = New Boolean
							MouseHoverMessage = Type(@This, e->motion.x, e->motion.y, e->motion.state, pBoolean, widget)
							hover_timer_id = g_timeout_add(1000, Cast(GSourceFunc, @hover_cb), pBoolean)
							Message.Result = True
						End If
					End If
				Case GDK_KEY_PRESS
					'Message.Result = True
					If OnKeyDown Then OnKeyDown(This, e->key.keyval, e->key.state)
					If CInt(OnKeyPress) AndAlso CInt(Not Message.Result) Then OnKeyPress(This, Asc(*e->key.string))
				Case GDK_KEY_RELEASE
					'Message.Result = True
					If OnKeyUp Then OnKeyUp(This, e->key.keyval, e->key.state)
				Case GDK_ENTER_NOTIFY
					If OnMouseEnter Then OnMouseEnter(This)
				Case GDK_LEAVE_NOTIFY
					If OnMouseLeave Then OnMouseLeave(This)
				Case GDK_CONFIGURE
					'					If Constraints.Left <> 0 OrElse Constraints.Top <> 0 OrElse Constraints.Width <> 0 OrElse Constraints.Height <> 0 Then
					'						g_signal_handlers_block_by_func(G_OBJECT(Message.widget), G_CALLBACK(@EventProc), @This)
					'						SetBounds(IIf(Constraints.Left, Constraints.Left, e->configure.x), IIf(Constraints.Top, Constraints.Top, e->configure.y), IIf(Constraints.Width, Constraints.Width, e->configure.Width), IIf(Constraints.Height, Constraints.Height, e->configure.Height))
					'						g_signal_handlers_unblock_by_func(G_OBJECT (Message.widget), G_CALLBACK(@EventProc), @This)
					'						g_signal_stop_emission_by_name(G_OBJECT(Message.widget), "event")
					'						Message.Result = True
					'					End If
					'					If gtk_is_window(widget) Then
					'						If Constraints.Left <> 0 Then gtk_window_move(gtk_window(widget), Constraints.Left, e->configure.y): Message.Result = True: Return
					'						If Constraints.Top <> 0 Then gtk_window_move(gtk_window(widget), e->configure.x, Constraints.Top): Message.Result = True: Return
					'						If Constraints.Width <> 0 Then gtk_window_resize(gtk_window(widget), Constraints.Width, e->configure.height): Message.Result = True: Return
					'						If Constraints.Height <> 0 Then gtk_window_resize(gtk_window(widget), e->configure.width, Constraints.Height): Message.Result = True: Return
					'					End If
					If OnMove Then OnMove(This)
					'If OnResize Then OnResize(This)
					'RequestAlign
					'Requests @This
					'Message.Result = True
				Case GDK_DRAG_ENTER
				Case GDK_DRAG_LEAVE
					'Case GDK_DRAG_MOTION
					'Case GDK_DRAG_STATUS
				Case GDK_DROP_START
				Case GDK_DROP_FINISHED
					#ifdef __USE_GTK3__
					Case GDK_TOUCH_BEGIN
					Case GDK_TOUCH_UPDATE
					Case GDK_TOUCH_END
					Case GDK_TOUCH_CANCEL
					#endif
					'Case GDK_PAD_BUTTON_PRESS
					'Case GDK_PAD_BUTTON_RELEASE
					'Case GDK_PAD_RING
					'Case GDK_PAD_STRIP
					'Case GDK_PAD_GROUP_MODE
				Case GDK_MAP
					If Not FCreated Then
						If OnCreate Then OnCreate(This)
						FCreated = True
					End If
				Case GDK_UNMAP
				Case GDK_VISIBILITY_NOTIFY
				Case GDK_PROPERTY_NOTIFY
				Case GDK_SELECTION_CLEAR
				Case GDK_SELECTION_REQUEST
				Case GDK_SELECTION_NOTIFY
				Case GDK_PROXIMITY_IN
				Case GDK_PROXIMITY_OUT
				Case GDK_CLIENT_EVENT
				Case GDK_DAMAGE
				Case GDK_GRAB_BROKEN
				Case GDK_OWNER_CHANGE
				Case GDK_SETTING
				Case GDK_WINDOW_STATE
					'Requests @This
					'RequestAlign
				Case GDK_SCROLL
					#ifdef __USE_GTK3__
						If OnMouseWheel Then OnMouseWheel(This, e->scroll.delta_x, e->scroll.x, e->scroll.y, e->scroll.state)
					#else
						If e->scroll.direction = GDK_SCROLL_UP Then
							If OnMouseWheel Then OnMouseWheel(This, -1, e->scroll.x, e->scroll.y, e->scroll.state)
						Else
							If OnMouseWheel Then OnMouseWheel(This, 1, e->scroll.x, e->scroll.y, e->scroll.state)
						End If
					#endif
				Case GDK_FOCUS_CHANGE
					If Cast(GdkEventFocus Ptr, e)->in Then
						If OnGotFocus Then OnGotFocus(This)
						If Not FDesignMode Then
							Dim frm As Control Ptr = GetForm
							If frm Then
								frm->FActiveControl = @This
								If frm->OnActiveControlChanged Then frm->OnActiveControlChanged(*frm)
							End If
						End If
					Else
						If OnLostFocus Then OnLostFocus(This)
					End If
				Case GDK_DELETE
				Case GDK_DESTROY
					If OnDestroy Then OnDestroy(This)
				Case GDK_EXPOSE
					If OnPaint Then OnPaint(This, Canvas)
				Case GDK_EVENT_LAST
				End Select
			#elseif defined(__USE_WINAPI__)
				bShift = GetKeyState(VK_SHIFT) And 8000
				bCtrl = GetKeyState(VK_CONTROL) And 8000
				Select Case Message.Msg
				Case WM_NCHITTEST
					If FDesignMode Then
						If ClassName <> "Form" AndAlso ClassName <> "GroupBox" Then
							Message.Result = HTTRANSPARENT
						End If
					End If
				Case WM_PAINT ', WM_NCPAINT
					If g_darkModeSupported AndAlso g_darkModeEnabled Then
						If Not FDarkMode Then
							SetDark True
							'							FDarkMode = True
							'							SetWindowTheme(FHandle, "DarkMode_Explorer", nullptr)
							'							If FDefaultBackColor = FBackColor Then
							'								Brush.Handle = hbrBkgnd
							'							End If
							'							SendMessageW(FHandle, WM_THEMECHANGED, 0, 0)
							'							_AllowDarkModeForWindow(FHandle, g_darkModeEnabled)
							Repaint
						End If
					Else
						If FDarkMode Then
							SetDark False
							'							FDarkMode = False
							'							SetWindowTheme(FHandle, NULL, NULL)
							'							If FBackColor = -1 Then
							'								Brush.Handle = 0
							'							Else
							'								Brush.Color = FBackColor
							'							End If
							'							_AllowDarkModeForWindow(FHandle, g_darkModeEnabled)
							'							SendMessageW(FHandle, WM_THEMECHANGED, 0, 0)
							Repaint
						End If
					End If
					If OnPaint Then
						Dim As HDC DC = GetDC(FHandle)
						Canvas.HandleSetted = True
						Canvas.Handle = DC
						OnPaint(This, Canvas)
						Canvas.HandleSetted = False
						ReleaseDC FHandle, DC
					End If
				Case WM_SETCURSOR
					If CInt(This.Cursor.Handle <> 0) AndAlso CInt(LoWord(Message.lParam) = HTCLIENT) AndAlso CInt(Not FDesignMode) Then
						Message.Result = Cast(LRESULT, SetCursor(This.Cursor.Handle))
					End If
				Case WM_HSCROLL
					If Not Message.lParam = NULL Then
						SendMessage Cast(HWND, Message.lParam), CM_HSCROLL, Cast(WPARAM, Message.wParam), Cast(LPARAM, Message.lParam)
					Else
						If OnScroll Then OnScroll(This)
					End If
				Case WM_VSCROLL
					If Not Message.lParam = NULL Then
						SendMessage Cast(HWND, Message.lParam), CM_VSCROLL, Cast(WPARAM, Message.wParam), Cast(LPARAM, Message.lParam)
					Else
						If OnScroll Then OnScroll(This)
					End If
				Case WM_CTLCOLORMSGBOX To WM_CTLCOLORSTATIC, WM_CTLCOLORBTN
					Dim As Control Ptr Child
					If Message.Msg = WM_CTLCOLORSTATIC Then
						If (GetWindowLong(CPtr(HWND, Message.lParam), GWL_STYLE) And SS_SIMPLE) = SS_SIMPLE Then
							Exit Select
						End If
					End If
					
					Child = GetProp(CPtr(HWND, Message.lParam), "MFFControl")
					If Child Then
						With *Child
							If (g_darkModeSupported AndAlso g_darkModeEnabled AndAlso .FDefaultBackColor = .FBackColor) Then
								If .ClassAncestor <> "ScrollBar" Then
									Dim As HDC hd = Cast(HDC, Message.wParam)
									'SetBkMode hd, TRANSPARENT
									SetTextColor(hd, darkTextColor)
									SetBkColor(hd, darkBkColor)
									'SetBkMode hd, OPAQUE
									If .Brush.Handle <> hbrBkgnd Then
										.Brush.Handle = hbrBkgnd
									End If
									Message.Result = Cast(LRESULT, .Brush.Handle)
								End If
							Else
								SendMessage(CPtr(HWND, Message.lParam), CM_CTLCOLOR, Message.wParam, Message.lParam)
								'								If .Brush.Handle = hbrBkgnd Then
								'									.Brush.Color = .FBackColor
								'									SetWindowTheme(.FHandle, NULL, NULL)
								'								End If
								Message.Result = Cast(LRESULT, .Brush.Handle)
							End If
							Return
						End With
					Else
						Dim As HDC DC
						DC = Cast(HDC, Message.wParam)
						'Child = Cast(Control Ptr, GetWindowLongPtr(Message.hWnd, GWLP_USERDATA))
						'If Child Then
						If (g_darkModeSupported AndAlso g_darkModeEnabled AndAlso FDefaultBackColor = FBackColor) Then
							Dim As HDC hd = Cast(HDC, Message.wParam)
							SetTextColor(hd, darkTextColor)
							SetBkColor(hd, darkBkColor)
							If Brush.Handle <> hbrBkgnd Then
								Brush.Handle = hbrBkgnd
							End If
						Else
							SetBkMode(DC, TRANSPARENT)
							SetBkColor(DC, BackColor)
							SetTextColor(DC, Font.Color)
							SetBkMode(DC, OPAQUE)
							'								If Brush.Handle = hbrBkgnd Then
							'									Brush.Color = FBackColor
							'									SetWindowTheme(FHandle, NULL, NULL)
							'								End If
						End If
						Message.Result = Cast(LRESULT, Brush.Handle)
						Return
						'End If
					End If
				Case WM_SETTINGCHANGE
					If g_darkModeSupported AndAlso CBool(IsColorSchemeChangeMessage(Message.lParam)) Then
						SendMessageW(Message.hWnd, WM_THEMECHANGED, 0, 0)
					End If
				Case WM_DPICHANGED
					Dim As ..Rect Ptr rc = Cast(Rect Ptr, Message.lParam)
					If rc <> 0 Then
						oldxdpi = xdpi
						oldydpi = ydpi
						xdpi = LoWord(Message.wParam) / 96
						ydpi = HiWord(Message.wParam) / 96
					End If
					For i As Integer = 0 To ControlCount - 1
						Controls[i]->Perform(WM_DPICHANGED, Message.wParam, 0)
					Next
					If rc = 0 Then
						Move This.Left * (xdpi / oldxdpi), This.Top * (ydpi / oldydpi), This.Width * (xdpi / oldxdpi), This.Height * (ydpi / oldydpi)
					Else
						Move UnScaleX(rc->Left), UnScaleY(rc->Top), UnScaleX(rc->Right - rc->Left), UnScaleY(rc->Bottom - rc->Top)
					End If
					Font.Size = Font.Size
					Message.Result = 0
					Return
				Case WM_THEMECHANGED
					'					If g_darkModeSupported Then
					'						_AllowDarkModeForWindow(Message.hWnd, g_darkModeEnabled)
					'						RefreshTitleBarThemeColor(Message.hWnd)
					'						UpdateWindow(Message.hWnd)
					'					End If
				Case WM_CTLCOLORBTN
					'?1
				Case WM_SIZE
					If Controls Then
						RequestAlign
					End If
					If OnResize Then OnResize(This, This.Width, This.Height)
				Case WM_WINDOWPOSCHANGING
					If Constraints.Left <> 0 Then *Cast(WINDOWPOS Ptr, Message.lParam).x  = Constraints.Left
					If Constraints.Top <> 0 Then *Cast(WINDOWPOS Ptr, Message.lParam).y  = Constraints.Top
					If Constraints.Width <> 0 Then *Cast(WINDOWPOS Ptr, Message.lParam).cx = Constraints.Width
					If Constraints.Height <> 0 Then *Cast(WINDOWPOS Ptr, Message.lParam).cy = Constraints.Height
				Case WM_WINDOWPOSCHANGED
					If OnMove Then OnMove(This)
				Case WM_CANCELMODE
					SendMessage(FHandle, CM_CANCELMODE, 0, 0)
				Case WM_LBUTTONDOWN
					DownButton = 0
					If OnMouseDown Then OnMouseDown(This, 0, UnScaleX(Message.lParamLo), UnScaleY(Message.lParamHi), Message.wParam And &HFFFF)
				Case WM_LBUTTONDBLCLK
					If OnDblClick Then OnDblClick(This)
				Case WM_LBUTTONUP
					DownButton = -1
					If OnClick Then OnClick(This)
					If OnMouseUp Then OnMouseUp(This, 0, UnScaleX(Message.lParamLo), UnScaleY(Message.lParamHi), Message.wParam And &HFFFF)
				Case WM_MBUTTONDOWN
					DownButton = 2
					If OnMouseDown Then OnMouseDown(This, 2, UnScaleX(Message.lParamLo), UnScaleY(Message.lParamHi), Message.wParam And &HFFFF)
				Case WM_MBUTTONUP
					DownButton = -1
					If OnMouseUp Then OnMouseUp(This, 2, UnScaleX(Message.lParamLo), UnScaleY(Message.lParamHi), Message.wParam And &HFFFF)
				Case WM_RBUTTONDOWN
					DownButton = 1
					If OnMouseDown Then OnMouseDown(This, 1, UnScaleX(Message.lParamLo), UnScaleX(Message.lParamHi), Message.wParam And &HFFFF)
				Case WM_RBUTTONUP
					DownButton = -1
					If OnMouseUp Then OnMouseUp(This, 1, UnScaleX(Message.lParamLo), UnScaleY(Message.lParamHi), Message.wParam And &HFFFF)
					If ContextMenu Then
						If ContextMenu->Handle Then
							Dim As ..Point P
							P.X = Message.lParamLo
							P.Y = Message.lParamHi
							.ClientToScreen(This.Handle, @P)
							ContextMenu->Popup(P.X, P.Y)
						End If
					End If
				Case WM_MEASUREITEM
					Dim As MEASUREITEMSTRUCT Ptr miStruct
					miStruct = Cast(MEASUREITEMSTRUCT Ptr,Message.lParam)
					Select Case miStruct->CtlType
					Case ODT_MENU
						'miStruct->itemWidth = miStruct->itemWidth + 8
						'If miStruct->itemHeight < 18 Then miStruct->itemHeight = 18
					Case ODT_LISTBOX,ODT_COMBOBOX
						SendMessage(GetDlgItem(FHandle, Message.wParam), CM_MEASUREITEM, Message.wParam, Message.lParam)
					End Select
				Case WM_DRAWITEM
					Dim As DRAWITEMSTRUCT Ptr diStruct
					diStruct = Cast(DRAWITEMSTRUCT Ptr,Message.lParam)
					Select Case diStruct->CtlType
					Case ODT_MENU
						'If This.ContextMenu AndAlso This.ContextMenu->ImagesList AndAlso This.ContextMenu->ImagesList->Handle AndAlso diStruct->itemData <> 0 Then
						'    ImageList_Draw(This.ContextMenu->ImagesList->Handle, Cast(MenuItem Ptr, diStruct->itemData)->ImageIndex, diStruct->hDC, 2, 2, ILD_NORMAL)
						'End If
					Case ODT_BUTTON,ODT_COMBOBOX,ODT_HEADER,ODT_LISTBOX,ODT_LISTVIEW,ODT_STATIC,ODT_TAB
						SendMessage(Cast(HWND,diStruct->hwndItem),CM_DRAWITEM,Message.wParam,Message.lParam)
					End Select
				Case WM_COMMAND
					GetPopupMenuItems
					Dim As MenuItem Ptr mi
					For i As Integer = 0 To FPopupMenuItems.Count -1
						mi = FPopupMenuItems.Items[i]
						If mi->Command = Message.wParamLo Then
							If mi->OnClick Then mi->OnClick(*mi)
							Exit For
						End If
					Next i
					SendMessage(Cast(HWND, Message.lParam), CM_COMMAND, Message.wParam, Message.lParam)
				Case WM_MOUSEMOVE
					If Not This.FMouseInClient Then
						This.FMouseInClient = True
						If OnMouseEnter Then OnMouseEnter(This)
					End If
					If OnMouseMove Then OnMouseMove(This, DownButton, UnScaleX(Message.lParamLo), UnScaleY(Message.lParamHi), Message.wParam And &HFFFF)
					If CInt(This.Tracked = False) AndAlso CInt((OnMouseLeave OrElse OnMouseHover OrElse OnMouseEnter)) Then
						Dim As TRACKMOUSEEVENT event_
						event_.cbSize = SizeOf(TRACKMOUSEEVENT)
						event_.dwFlags = TME_LEAVE Or TME_HOVER
						event_.hwndTrack = FHandle
						'event_.dwHoverTime = 10
						TRACKMOUSEEVENT(@event_)
						This.Tracked = True
					End If
				Case WM_MOUSEWHEEL
					Static scrDirection As Integer
					#ifdef __FB_64BIT__
						If Message.wParam < 4000000000 Then
							scrDirection = 1
						Else
							scrDirection = -1
						End If
					#else
						scrDirection = Sgn(Message.wParam)
					#endif
					If OnMouseWheel Then OnMouseWheel(This, scrDirection, UnScaleX(Message.lParamLo), UnScaleY(Message.lParamHi), Message.wParam And &HFFFF)
				Case WM_MOUSELEAVE
					If OnMouseLeave Then OnMouseLeave(This)
					This.FMouseInClient = False
					This.Tracked = False
				Case WM_MOUSEHOVER
					If OnMouseHover Then OnMouseHover(This, DownButton, UnScaleX(Message.lParamLo), UnScaleX(Message.lParamHi), Message.wParam And &HFFFF)
					This.Tracked = False
				Case WM_DROPFILES
					If OnDropFile Then
						Dim As HDROP iDrop = Cast(HDROP, Message.wParam)
						Dim As Integer filecount, length, i
						filecount = DragQueryFile(iDrop, -1, NULL, 0)
						Dim As WString Ptr filename
						For i = 0 To filecount - 1
							WReAllocate(filename, MAX_PATH)
							length = DragQueryFile(iDrop, i, filename, MAX_PATH)
							'*filename = Left(*filename, length)
							If OnDropFile Then OnDropFile(This, *filename)
						Next
						DragFinish iDrop
					End If
				Case WM_CHAR
					If OnKeyPress Then OnKeyPress(This, Message.wParam)
				Case WM_KEYDOWN
					If OnKeyDown Then OnKeyDown(This, Message.wParam, Message.lParam And &HFFFF)
					If GetKeyState(VK_MENU) >= 0 Then
						Select Case LoWord(Message.wParam)
						Case VK_TAB
							'							Dim Frm As Control Ptr = GetForm
							'							If Frm Then
							'								Frm->SelectNextControl bShift
							'								Message.Result = -1:
							'								Exit Sub
							'							End If
						Case VK_RETURN
							Dim frm As Control Ptr = GetForm
							If frm AndAlso frm->FDefaultButton AndAlso frm->FDefaultButton->OnClick Then
								frm->FDefaultButton->OnClick(*frm->FDefaultButton)
								Message.Result = -1:
								Exit Sub
							End If
						Case VK_ESCAPE
							Dim frm As Control Ptr = GetForm
							If frm AndAlso frm->FCancelButton AndAlso frm->FCancelButton->OnClick Then
								frm->FCancelButton->OnClick(*frm->FCancelButton)
								Message.Result = -1:
								Exit Sub
							End If
						End Select
					End If
				Case WM_KEYUP
					If OnKeyUp Then OnKeyUp(This, LoWord(Message.wParam), Message.lParam And &HFFFF)
				Case WM_SETFOCUS
					If OnGotFocus Then OnGotFocus(This)
					If Not FDesignMode Then
						Dim frm As Control Ptr = GetForm
						If frm Then
							frm->FActiveControl = @This
							If frm->OnActiveControlChanged Then frm->OnActiveControlChanged(*frm)
						End If
					End If
				Case WM_KILLFOCUS
					If OnLostFocus Then OnLostFocus(This)
				Case WM_NOTIFY
					Dim As LPNMHDR NM
					Static As HWND FWindow
					NM = Cast(LPNMHDR, Message.lParam)
					If NM->code = TTN_NEEDTEXT Then
						If FWindow Then SendMessage FWindow,CM_NEEDTEXT,Message.wParam, Message.lParam
					Else
						FWindow = NM->hwndFrom
						Dim As Control Ptr Ctrl = Cast(Any Ptr, GetWindowLongPtr(FWindow, GWLP_USERDATA))
						If Ctrl <> 0 Then
							If IndexOf(Ctrl) <> -1 Then
								Message.Msg = CM_NOTIFY
								Ctrl->ProcessMessage(Message)
							Else
								SendMessage FWindow, CM_NOTIFY, Message.wParam, Message.lParam
							End If
						End If
					End If
				Case WM_HELP
					'If (GetWindowLong(message.hwnd,GWL_STYLE) And WS_CHILD) <> WS_CHILD Then SendMessage(message.hwnd,CM_HELP,message.wParam,message.LParam)
				Case WM_NEXTDLGCTL
					Dim As Control Ptr NextCtrl
					Dim As Control Ptr frm = GetForm
					If frm Then
						NextCtrl = frm->SelectNextControl()
						If NextCtrl Then NextCtrl->SetFocus
					End If
				Case WM_DESTROY
					If Brush.Handle = hbrBkgnd Then Brush.Handle = 0
					SetWindowLongPtr(FHandle, GWLP_USERDATA, 0)
					If OnDestroy Then OnDestroy(This) Else Handle = 0
				End Select
			#endif
		End Sub
		
		Private Sub Control.ProcessMessageAfter(ByRef Message As Message)
			#ifdef __USE_GTK__
				Dim As GdkEvent Ptr e = Message.Event
				Select Case Message.Event->type
				Case GDK_CONFIGURE
					
				Case GDK_WINDOW_STATE
					
				End Select
				Message.Result = True
			#elseif defined(__USE_WINAPI__)
				Select Case Message.Msg
				Case WM_NCHITTEST
					If FDesignMode Then
						If ClassName <> "Form" Then
							'Message.Result = HTTRANSPARENT
						End If
					End If
				Case WM_DESTROY
					SetWindowLongPtr(FHandle, GWLP_USERDATA, 0)
					If OnDestroy Then OnDestroy(This)
					'Handle = 0
				End Select
			#endif
		End Sub
		
		Private Function Control.EnumPopupMenuItems(ByRef Item As MenuItem) As Boolean
			FPopupMenuItems.Add Item
			For i As Integer = 0 To Item.Count -1
				EnumPopupMenuItems *Item.Item(i)
			Next i
			Return True
		End Function
		
		Private Sub Control.GetPopupMenuItems
			FPopupMenuItems.Clear
			If ContextMenu Then
				For i As Integer = 0 To ContextMenu->Count - 1
					EnumPopupMenuItems *ContextMenu->Item(i)
				Next i
			End If
		End Sub
		
		Private Function Control.EnumControls(Item As Control Ptr) As Boolean
			FControls.Add Item
			For i As Integer = 0 To Item->ControlCount - 1
				EnumControls Item->Controls[i]
			Next i
			Return True
		End Function
		
		Private Sub Control.GetControls
			FControls.Clear
			For i As Integer = 0 To ControlCount - 1
				EnumControls Controls[i]
			Next i
		End Sub
		
		#ifdef __USE_GTK__
			Private Function Control.EventProc(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
				Dim Message As Message
				Dim As Control Ptr Ctrl = user_data
				Message = Type(Ctrl, widget, Event, False)
				If Ctrl Then
					'If Ctrl->DesignMode Then Return True
					Message.Sender = Ctrl
					Ctrl->ProcessMessage(Message)
				End If
				Return Message.Result
			End Function
			
			Private Function Control.EventAfterProc(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
				Dim Message As Message
				Dim As Control Ptr Ctrl = user_data
				Message = Type(Ctrl, widget, Event, False)
				If Ctrl Then
					'If Ctrl->DesignMode Then Return True
					Message.Sender = Ctrl
					Ctrl->ProcessMessageAfter(Message)
				End If
				Return Message.Result
			End Function
		#elseif defined(__USE_WINAPI__)
			Private Function Control.DefWndProc(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
				Dim Message As Message
				Dim As Control Ptr Ctrl = Cast(Any Ptr, GetWindowLongPtr(FWindow, GWLP_USERDATA))
				Message = Type(Ctrl, FWindow, Msg, wParam, lParam, 0, LoWord(wParam), HiWord(wParam), LoWord(lParam), HiWord(lParam), 0)
				If Ctrl Then
					'?Ctrl
					If Ctrl->ClassName <> "" Then
						Ctrl->ProcessMessage(Message)
						If Message.Result = -1 Then
							Return Message.Result
						ElseIf Message.Result = -2 Then
							Msg = Message.Msg
							wParam = Message.wParam
							lParam = Message.lParam
						ElseIf Message.Result = -3 Then
							Message.Result = DefMDIChildProc(FWindow, Msg, wParam, lParam)
							Return Message.Result
						ElseIf Message.Result = -4 Then
							Message.Result = DefFrameProc(FWindow, Message.hWnd, Msg, wParam, lParam)
							Return Message.Result
						ElseIf Message.Result <> 0 Then
							Return Message.Result
						End If
					End If
				End If
				Message.Result = DefWindowProc(FWindow, Msg, wParam, lParam)
				'				If Ctrl Then
				'					Ctrl->ProcessMessageAfter(Message)
				'				End If
				Return Message.Result
			End Function
			
			Private Function Control.CallWndProc(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
				Dim Message As Message
				Dim As Control Ptr Ctrl
				Dim As Any Ptr Proc = @DefWindowProc
				Ctrl = Cast(Any Ptr,GetWindowLongPtr(FWindow,GWLP_USERDATA))
				Message = Type(Ctrl, FWindow,Msg,wParam,lParam,0,LoWord(wParam),HiWord(wParam),LoWord(lParam),HiWord(lParam),Message.Captured)
				If Ctrl Then
					Proc = Ctrl->PrevProc
					Ctrl->ProcessMessage(Message)
					If Message.Result = -1 Then
						Return Message.Result
					ElseIf Message.Result = -2 Then
						Msg = Message.Msg
						wParam = Message.wParam
						lParam = Message.lParam
					ElseIf Message.Result <> 0 Then
						Return Message.Result
					End If
					Message.Result = CallWindowProc(Proc,FWindow,Msg,wParam,lParam)
					'					If Ctrl Then
					'						Ctrl->ProcessMessageAfter(Message)
					'					End If
				End If
				Return Message.Result
			End Function
			
			Private Function Control.SuperWndProc(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
				'    			On Error Goto ErrorHandler
				Dim As Control Ptr Ctrl
				Dim Message As Message
				Ctrl = Cast(Any Ptr, GetWindowLongPtr(FWindow, GWLP_USERDATA))
				'Ctrl = GetProp(FWindow, "MFFControl")
				Message = Type(Ctrl, FWindow, Msg, wParam, lParam, 0, LoWord(wParam), HiWord(wParam), LoWord(lParam), HiWord(lParam), Message.Captured)
				If Ctrl Then
					With *Ctrl
						If Ctrl->ClassName <> "" Then
							.ProcessMessage(Message)
							If Message.Result = -1 Then
								Return Message.Result
							ElseIf Message.Result = -2 Then
								Msg = Message.Msg
								wParam = Message.wParam
								lParam = Message.lParam
							ElseIf Message.Result <> 0 Then
								Return Message.Result
							End If
						End If
					End With
				End If
				Dim As Any Ptr cp = GetClassProc(FWindow)
				If cp <> 0 Then
					Message.Result = CallWindowProc(cp, FWindow, Msg, wParam, lParam)
				End If
				'				If Ctrl AndAlso Ctrl->ClassName <> "" Then
				'					Ctrl->ProcessMessageAfter(Message)
				'				End If
				Return Message.Result
				'    Exit Function
				'ErrorHandler:
				'    ?GetMessageName(msg) & " " & ErrDescription(Err) & " (" & Err & ") " & _
				'        "in line " & Erl() & " " & _
				'        "in function " & ZGet(Erfn()) & " " & _
				'        "in module " & ZGet(Ermn())
				'        Sleep
			End Function
			
			Private Function Control.Perform(Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
				If FHandle Then
					Return SendMessageW(FHandle, Msg, wParam, lParam)
				Else
					Return 0
				End If
			End Function
		#endif
		
		Private Function Control.SelectNextControl(Prev As Boolean = False) As Control Ptr
			#ifdef __USE_GTK__
				
			#else
				Dim As Control Ptr ParentCtrl = GetForm
				Dim As Control Ptr Ctrl
				If ParentCtrl Then
					With ParentCtrl->FTabIndexList
						Dim As Integer Idx = .IndexOfObject(FActiveControl)
						If Prev Then
							For i As Integer = Idx - 1 To 0 Step -1
								Ctrl = .Object(i)
								If Ctrl->FTabStop AndAlso Ctrl->Visible AndAlso Ctrl->Enabled Then Ctrl->SetFocus: Return Ctrl
							Next
							For i As Integer = .Count - 1 To Idx + 1 Step -1
								Ctrl = .Object(i)
								If Ctrl->FTabStop AndAlso Ctrl->Visible AndAlso Ctrl->Enabled Then Ctrl->SetFocus: Return Ctrl
							Next
						Else
							For i As Integer = Idx + 1 To .Count - 1
								Ctrl = .Object(i)
								If Ctrl->FTabStop AndAlso Ctrl->Visible AndAlso Ctrl->Enabled Then Ctrl->SetFocus: Return Ctrl
							Next
							For i As Integer = 0 To Idx - 1
								Ctrl = .Object(i)
								If Ctrl->FTabStop AndAlso Ctrl->Visible AndAlso Ctrl->Enabled Then Ctrl->SetFocus: Return Ctrl
							Next
						End If
					End With
				End If
			#endif
			Return NULL
		End Function
		
		Private Sub Control.Move(cLeft As Integer, cTop As Integer, cWidth As Integer, cHeight As Integer)
			Base.Move IIf(Constraints.Left, Constraints.Left, cLeft), IIf(Constraints.Top, Constraints.Top, cTop), IIf(Constraints.Width, Constraints.Width, cWidth), IIf(Constraints.Height, Constraints.Height, cHeight)
		End Sub
		
		#ifdef __USE_GTK__
			Private Sub Control.Control_SizeAllocate(widget As GtkWidget Ptr, allocation As GdkRectangle Ptr, user_data As Any Ptr)
				Dim As Control Ptr Ctrl = Cast(Any Ptr, user_data)
				If GTK_IS_LAYOUT(widget) OrElse GTK_IS_SCROLLED_WINDOW(widget) Then
					Dim As Integer AllocatedWidth = allocation->Width, AllocatedHeight = allocation->height
					'					#ifdef __USE_GTK3__
					'						Dim As Integer AllocatedWidth = gtk_widget_get_allocated_width(widget), AllocatedHeight = gtk_widget_get_allocated_height(widget)
					'					#else
					'						Dim As Integer AllocatedWidth = widget->allocation.width, AllocatedHeight = widget->allocation.height
					'					#endif
					''					If Ctrl->BackColor <> -1 Then
					''						Dim As Integer iColor = Ctrl->BackColor
					''						cairo_rectangle(cr, 0.0, 0.0, AllocatedWidth, AllocatedHeight)
					''						cairo_set_source_rgb(cr, Abs(GetRed(iColor) / 255.0), Abs(GetGreen(iColor) / 255.0), Abs(GetBlue(iColor) / 255.0))
					''						cairo_fill(cr)
					''					End If
					If AllocatedWidth <> Ctrl->AllocatedWidth Or AllocatedHeight <> Ctrl->AllocatedHeight Then
						Ctrl->AllocatedWidth = AllocatedWidth
						Ctrl->AllocatedHeight = AllocatedHeight
						Ctrl->RequestAlign AllocatedWidth, AllocatedHeight, True
						If Ctrl->OnResize Then Ctrl->OnResize(*Ctrl, AllocatedWidth, AllocatedHeight)
					End If
				End If
			End Sub
			
			Private Function Control.Control_Draw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
				Dim As Control Ptr Ctrl = Cast(Any Ptr, data1)
				#ifdef __USE_GTK4__
					If Ctrl <> 0 AndAlso (GTK_IS_LAYOUT(widget)) Then
				#else
					If Ctrl <> 0 AndAlso (GTK_IS_LAYOUT(widget) OrElse GTK_IS_EVENT_BOX(widget)) Then
				#endif
					Ctrl->Canvas.HandleSetted = True
					Ctrl->Canvas.Handle = cr
					'					Dim allocation As GtkAllocation
					'					gtk_widget_get_allocation(widget, @allocation)
					#ifndef __USE_GTK2__
						Dim As Integer AllocatedWidth = gtk_widget_get_allocated_width(widget), AllocatedHeight = gtk_widget_get_allocated_height(widget)
					#else
						Dim As Integer AllocatedWidth = widget->allocation.width, AllocatedHeight = widget->allocation.height
					#endif
					'Dim As Integer AllocatedWidth = allocation.width, AllocatedHeight = allocation.height
					If Ctrl->BackColor <> -1 Then
						Dim As Integer iColor = Ctrl->BackColor
						cairo_rectangle(cr, 0.0, 0.0, AllocatedWidth, AllocatedHeight)
						cairo_set_source_rgb(cr, Ctrl->FBackColorRed, Ctrl->FBackColorGreen, Ctrl->FBackColorBlue)
						cairo_fill(cr)
					End If
					If Ctrl->OnPaint Then Ctrl->OnPaint(*Ctrl, Ctrl->Canvas)
					'					#ifdef __USE_GTK3__
					'						Control_SizeAllocate(widget, @allocation, data1)
					'					#endif
					If AllocatedWidth <> Ctrl->AllocatedWidth Or AllocatedHeight <> Ctrl->AllocatedHeight Then
						Ctrl->AllocatedWidth = AllocatedWidth
						Ctrl->AllocatedHeight = AllocatedHeight
						Ctrl->RequestAlign AllocatedWidth, AllocatedHeight, True
						If Ctrl->OnResize Then Ctrl->OnResize(*Ctrl, AllocatedWidth, AllocatedHeight)
					End If
					Ctrl->Canvas.HandleSetted = False
				End If
				Return False
			End Function
			
			Private Function Control.Control_ExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
				#ifdef __USE_GTK2__
					Dim As cairo_t Ptr cr = gdk_cairo_create(Event->window)
					Control_Draw(widget, cr, data1)
					cairo_destroy(cr)
				#endif
				Return False
			End Function
			
			Private Function Control.Control_Scroll(self As GtkScrolledWindow Ptr, scroll As GtkScrollType Ptr, horizontal As Boolean, user_data As Any Ptr) As Boolean
				Dim As Control Ptr Ctrl = user_data
				If Ctrl->OnScroll Then Ctrl->OnScroll(*Ctrl)
				Return False
			End Function
			
			Private Sub Control.DragDataReceived(self As GtkWidget Ptr, context As GdkDragContext Ptr, x As gint, y As gint, selection_data As GtkSelectionData Ptr, info As guint, Time As guint, user_data As Any Ptr)
				Dim As Control Ptr Ctrl = user_data
				If info = 0 Then
					If Ctrl->OnDropFile Then
						Dim As UString res(Any)
						Dim As UString datatext = *Cast(gchar Ptr, gtk_selection_data_get_data(selection_data)) '*g_locale_from_utf8(gtk_selection_data_get_text(selection_data), -1, 0, 0, 0)
						'If StartsWith(datatext, "file://") Then
						datatext = Mid(datatext, 8)
						Split(datatext, Chr(13) & Chr(10), res())
						For i As Integer = 0 To UBound(res)
							If StartsWith(res(i), "file://") Then res(i) = Mid(res(i), 8)
							If Trim(res(i)) <> "" Then
								Ctrl->OnDropFile(*Ctrl, res(i))
							End If
						Next
						'End If
					End If
					gtk_drag_finish(context, True, False, Time)
				Else
					gtk_drag_finish(context, False, False, Time)
				End If
			End Sub
			
			Private Function Control.ConfigureEventProc(widget As GtkWidget Ptr, e As GdkEvent Ptr, user_data As Any Ptr) As Boolean
				Dim As Control Ptr Ctrl = user_data
				If Ctrl Then
					If Ctrl->Constraints.Left <> 0 OrElse Ctrl->Constraints.Top <> 0 OrElse Ctrl->Constraints.Width <> 0 OrElse Ctrl->Constraints.Height <> 0 Then
						If GTK_IS_WINDOW(widget) Then
							'g_signal_handlers_block_by_func(G_OBJECT(widget), G_CALLBACK(@ConfigureEventProc), user_data)
							If Ctrl->Constraints.Left <> 0 OrElse Ctrl->Constraints.Top <> 0 Then
								Dim As GdkRectangle rect
								gdk_window_get_frame_extents(gtk_widget_get_window(widget), @rect)
								If Ctrl->Constraints.Left <> 0 AndAlso Ctrl->Constraints.Left <> rect.x OrElse Ctrl->Constraints.Top <> 0 AndAlso Ctrl->Constraints.Top <> rect.y Then
									gtk_window_move(GTK_WINDOW(widget), _
									IIf(Ctrl->Constraints.Left, Ctrl->Constraints.Left, rect.x), _
									IIf(Ctrl->Constraints.Top, Ctrl->Constraints.Top, rect.y))
								End If
							End If
							'							If Ctrl->Constraints.Left <> 0 OrElse Ctrl->Constraints.Top <> 0 Then
							'								If Ctrl->Constraints.Left <> 0 AndAlso Ctrl->Constraints.Left <> e->configure.x OrElse Ctrl->Constraints.Top <> 0 AndAlso Ctrl->Constraints.Top <> e->configure.y - 37 Then
							'									gtk_window_move(gtk_window(widget), _
							'										IIf(Ctrl->Constraints.Left, Ctrl->Constraints.Left, e->configure.x), _
							'										IIf(Ctrl->Constraints.Top, Ctrl->Constraints.Top, e->configure.y - 37))
							'								End If
							'							End If
							'g_signal_handlers_unblock_by_func(G_OBJECT (widget), G_CALLBACK(@ConfigureEventProc), user_data)
							'g_signal_stop_emission_by_name(G_OBJECT(widget), "configure-event")
							Return True
						End If
					End If
				End If
				Return False
			End Function
			
			Private Function Control.RegisterClass(ByRef wClassName As WString, Obj As Any Ptr, WndProcAddr As Any Ptr = 0) As Boolean
				Dim As Boolean Result
				Dim Proc As Function(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean = WndProcAddr
				g_object_set_data(G_OBJECT(widget), "MFFControl", Cast(gpointer, @This))
				If layoutwidget Then
					#ifdef __USE_GTK4__
						'						Dim As GtkEventController Ptr controller = gtk_event_controller_key_new()
						'						g_signal_connect(controller, "key-pressed", Cast(GCallback, @keypress_cb), Obj)
						'						gtk_widget_add_controller(layoutwidget, controller)
					#else
						gtk_widget_set_events(layoutwidget, _
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
						'Result = g_signal_connect(layoutwidget, "event", G_CALLBACK(IIF(WndProcAddr = 0, @EventProc, Proc)), Obj)
						'Result = g_signal_connect(layoutwidget, "event-after", G_CALLBACK(IIF(WndProcAddr = 0, @EventAfterProc, Proc)), Obj)
						#ifdef __USE_GTK3__
							g_signal_connect(layoutwidget, "draw", G_CALLBACK(@Control_Draw), Obj)
							'g_signal_connect(layoutwidget, "size-allocate", G_CALLBACK(@Control_SizeAllocate), Obj)
						#else
							g_signal_connect(layoutwidget, "expose-event", G_CALLBACK(@Control_ExposeEvent), Obj)
							g_signal_connect(layoutwidget, "size-allocate", G_CALLBACK(@Control_SizeAllocate), Obj)
						#endif
					#endif
				End If
				If widget Then
					Font.Parent = @This
					#ifdef __USE_GTK4__
						'						Dim As GtkEventController Ptr controller = gtk_event_controller_key_new()
						'						g_signal_connect(controller, "key-pressed", Cast(GCallback, @keypress_cb), Obj)
						'						gtk_widget_add_controller(layoutwidget, controller)
					#else
						gtk_widget_set_events(IIf(eventboxwidget, eventboxwidget, widget), _
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
						Result = g_signal_connect(widget, "event", G_CALLBACK(IIf(WndProcAddr = 0, @EventProc, Proc)), Obj)
						Result = g_signal_connect(widget, "event-after", G_CALLBACK(IIf(WndProcAddr = 0, @EventAfterProc, Proc)), Obj)
						Result = g_signal_connect(G_OBJECT(widget), "configure-event", G_CALLBACK(@ConfigureEventProc), @This)
						#ifdef __USE_GTK3__
							g_signal_connect(widget, "draw", G_CALLBACK(@Control_Draw), Obj)
						#else
							g_signal_connect(widget, "expose-event", G_CALLBACK(@Control_ExposeEvent), Obj)
						#endif
					#endif
					If GTK_IS_SCROLLED_WINDOW(widget) Then
						g_signal_connect(widget, "size-allocate", G_CALLBACK(@Control_SizeAllocate), Obj)
					End If
				End If
				#ifndef __USE_GTK4__
					If eventboxwidget Then
						Font.Parent = @This
						gtk_widget_set_events(IIf(eventboxwidget, eventboxwidget, widget), _
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
						Result = g_signal_connect(eventboxwidget, "event", G_CALLBACK(IIf(WndProcAddr = 0, @EventProc, Proc)), Obj)
						Result = g_signal_connect(eventboxwidget, "event-after", G_CALLBACK(IIf(WndProcAddr = 0, @EventAfterProc, Proc)), Obj)
						#ifdef __USE_GTK3__
							g_signal_connect(eventboxwidget, "draw", G_CALLBACK(@Control_Draw), Obj)
						#else
							g_signal_connect(eventboxwidget, "expose-event", G_CALLBACK(@Control_ExposeEvent), Obj)
						#endif
					End If
				#endif
				If scrolledwidget Then
					Result = g_signal_connect(scrolledwidget, "scroll-child", G_CALLBACK(@Control_Scroll), @This)
				End If
				Return Result
			End Function
		#elseif defined(__USE_WINAPI__)
			Private Function Control.RegisterClass(ByRef wClassName As WString, ByRef wClassAncestor As WString = "", WndProcAddr As Any Ptr = 0) As Integer
				Dim As Integer Result
				Dim As WNDCLASSEX Wc
				Dim As Any Ptr ClassProc
				Dim PROC As Function(FWindow As HWND, MSG As UINT, WPARAM As WPARAM, LPARAM As LPARAM) As LRESULT = WndProcAddr
				ZeroMemory(@Wc, SizeOf(WNDCLASSEX))
				Wc.cbSize = SizeOf(WNDCLASSEX)
				If wClassAncestor <> "" Then
					If GetClassInfoEx(0, wClassAncestor, @Wc) <> 0 Then
						ClassProc = Wc.lpfnWndProc
						Wc.lpszClassName = @wClassName
						If wClassName <> "WebBrowser" Then
							Wc.lpfnWndProc   = IIf(WndProcAddr = 0, @SuperWndProc, PROC)
							Wc.cbWndExtra += 4
						End If
						Wc.hInstance     = Instance
						'If Cursor AndAlso Cursor->Handle Then Wc.hCursor = Cursor->Handle
						Result = .RegisterClassEx(@Wc)
						If Result Then
							StoreClass wClassName, wClassAncestor, ClassProc
						End If
					ElseIf GetClassInfoEx(Instance, wClassAncestor, @Wc) <> 0 Then
						ClassProc = GetClassProc(wClassAncestor)
						'If Cursor AndAlso Cursor->Handle Then Wc.hCursor = Cursor->Handle
						Wc.lpszClassName = @wClassName
						Wc.lpfnWndProc   = IIf(WndProcAddr = 0, @DefWndProc, PROC)
						Result = .RegisterClassEx(@Wc)
						If Result Then
							StoreClass wClassName, wClassAncestor, ClassProc
						End If
					Else
						MessageBox NULL, "Unable to register class" & " '" & wClassName & "'", "Control", MB_ICONERROR
					End If
				Else
					If GetClassInfoEx(GetModuleHandle(NULL), wClassName, @Wc) = 0 Then
						Wc.lpszClassName = @wClassName
						Wc.lpfnWndProc   = IIf(WndProcAddr = 0, @DefWndProc, PROC)
						Wc.style = CS_DBLCLKS Or CS_HREDRAW Or CS_VREDRAW
						Wc.hInstance     = Instance
						Wc.hCursor       = LoadCursor(NULL, IDC_ARROW)
						Wc.hbrBackground = Cast(HBRUSH, 0)
						Result = .RegisterClassEx(@Wc)
					End If
				End If
				Return Result
			End Function
		#endif
		
		Private Sub Control.SetMargins(mLeft As Integer, mTop As Integer, mRight As Integer, mBottom As Integer)
			Margins.Left   = mLeft
			Margins.Top    = mTop
			Margins.Right  = mRight
			Margins.Bottom = mBottom
			RequestAlign
		End Sub
		
		Sub Control.GetMax(ByRef MaxWidth As Integer, ByRef MaxHeight As Integer)
			MaxWidth = 0
			MaxHeight = 0
			For i As Integer = 0 To ControlCount - 1
				With *Controls[i]
					If .FVisible Then 
						If MaxWidth < .Left + .Width + .ExtraMargins.Right Then MaxWidth = .Left + .Width + .ExtraMargins.Right
						If MaxHeight < .Top + .Height + .ExtraMargins.Bottom Then MaxHeight = .Top + .Height + .ExtraMargins.Bottom
					End If
				End With
			Next
			MaxWidth += Margins.Right
			MaxHeight += Margins.Bottom
		End Sub
		
		Private Sub Control.RequestAlign(iClientWidth As Integer = -1, iClientHeight As Integer = -1, bInDraw As Boolean = False, bWithoutControl As Control Ptr = 0)
			#ifdef __USE_GTK__
				If GTK_IS_NOTEBOOK(widget) Then
					For i As Integer = 0 To ControlCount - 1
						'Controls[i]->Width = FWidth 'gtk_widget_get_allocated_width(widget) - 30
						'Controls[i]->Height = FHeight 'gtk_widget_get_allocated_height(widget) - 25
						Controls[i]->RequestAlign
					Next i
					Exit Sub
				End If
				If bInDraw = False Then
					AllocatedWidth = 0
					AllocatedHeight = 0
					Exit Sub
				End If
			#endif
			Dim As Control Ptr Ptr ListLeft, ListRight, ListTop, ListBottom, ListClient
			Dim As Integer i,LeftCount = 0, RightCount = 0, TopCount = 0, BottomCount = 0, ClientCount = 0
			Dim As Integer tTop, bTop, lLeft, rLeft
			Dim As Integer aLeft, aTop, aWidth, aHeight
			If iClientWidth = -1 Then iClientWidth = ClientWidth
			If iClientHeight = -1 Then iClientHeight = ClientHeight
			'If ClassName = "ScrollControl" Then iClientWidth = Width: iClientHeight = Height
			If iClientWidth <= 0 OrElse iClientHeight <= 0 Then Exit Sub
			lLeft = Margins.Left
			rLeft = iClientWidth - Margins.Right
			tTop  = Margins.Top
			bTop  = iClientHeight - Margins.Bottom
			If ControlCount <> 0 Then
				#ifdef __USE_GTK__
					If rLeft <= 1 And bTop <= 1 Then
						Exit Sub
					End If
					If layoutwidget Then
						'gtk_layout_set_size(gtk_layout(layoutwidget), rLeft, bTop)
						'gtk_widget_set_size_request(layoutwidget, Max(0, rLeft), Max(0, tTop))
					ElseIf fixedwidget Then
						'gtk_widget_set_size_request(fixedwidget, Max(0, rLeft), Max(0, tTop))
					End If
					'If FMenu AndAlso FMenu->widget Then
					'	tTop = gtk_widget_get_allocated_height(FMenu->widget)
					'	gtk_widget_set_size_request(FMenu->widget, Max(0, rLeft), Max(0, tTop))
					'End If
					'If fixedwidget Then
					'	gtk_widget_set_size_request(fixedwidget, Max(0, rLeft), Max(0, bTop))
					'End If
				#endif
				'This.UpdateLock
				'#ifdef __USE_GTK__
				'	Dim bNotPainted As Boolean
				'	For i = 0 To ControlCount - 1
				'		If Controls[i]->FAutoSize Then
				'			If Controls[i]->AllocatedWidth = 0 AndAlso Controls[i]->AllocatedHeight = 0 Then
				'				Controls[i]->Repaint
				'				bNotPainted = True
				'			End If
				'		End If
				'	Next
				'	If bNotPainted Then
				'		AllocatedWidth = 0
				'		AllocatedHeight = 0
				'		Repaint
				'		'If FAutoSize AndAlso This.Parent Then
				'			This.Parent->AllocatedWidth = 0
				'			This.Parent->AllocatedHeight = 0
				'		'	This.Parent->Repaint
				'		'End If
				'		Exit Sub
				'	End If
				'#endif
				For i = 0 To ControlCount - 1
					'If Controls[i]->Handle = 0 Then Continue For
					Select Case Controls[i]->Align
					Case 1'alLeft
						LeftCount += 1
						ListLeft = Reallocate_(ListLeft,SizeOf(Control Ptr)*LeftCount)
						ListLeft[LeftCount - 1] = Controls[i]
					Case 2'alRight
						RightCount += 1
						ListRight = Reallocate_(ListRight,SizeOf(Control Ptr)*RightCount)
						ListRight[RightCount - 1] = Controls[i]
					Case 3'alTop
						TopCount += 1
						ListTop = Reallocate_(ListTop, SizeOf(Control Ptr)*TopCount)
						ListTop[TopCount - 1] = Controls[i]
					Case 4'alBottom
						BottomCount += 1
						ListBottom = Reallocate_(ListBottom,SizeOf(Control Ptr)*BottomCount)
						ListBottom[BottomCount - 1] = Controls[i]
					Case 5'alClient
						ClientCount += 1
						ListClient = Reallocate_(ListClient,SizeOf(Control Ptr)*ClientCount)
						ListClient[ClientCount - 1] = Controls[i]
					End Select
					With *Controls[i]
						If Cast(Integer, .Anchor.Left) + Cast(Integer, .Anchor.Right) + Cast(Integer, .Anchor.Top) + Cast(Integer, .Anchor.Bottom) <> 0 Then
							#ifdef __USE_GTK__
								If CInt(.FVisible) Then
							#else
								If CInt(.FVisible) AndAlso CInt(.Handle) Then
							#endif
								aLeft = .FLeft: aTop = .FTop: aWidth = .FWidth: aHeight = .FHeight
								This.FWidth = This.Width: This.FHeight = This.Height
								If .Anchor.Left <> asNone Then
									If .Anchor.Left = asAnchorProportional Then aLeft = This.FWidth / .FAnchoredParentWidth * .FAnchoredLeft
									If .Anchor.Right <> asNone Then aWidth = This.FWidth - aLeft - IIf(.Anchor.Right = asAnchor, .FAnchoredRight, This.FWidth / .FAnchoredParentWidth * .FAnchoredRight)
								ElseIf .Anchor.Right <> asNone Then
									aLeft = This.FWidth - .FWidth - IIf(.Anchor.Right = asAnchor, .FAnchoredRight, This.FWidth / .FAnchoredParentWidth * .FAnchoredRight)
								End If
								If .Anchor.Top <> asNone Then
									If .Anchor.Top = asAnchorProportional Then aTop = This.FHeight / .FAnchoredParentHeight * .FAnchoredTop
									If .Anchor.Bottom <> asNone Then aHeight = This.FHeight - aTop - IIf(.Anchor.Bottom = asAnchor, .FAnchoredBottom, This.FHeight / .FAnchoredParentHeight * .FAnchoredBottom)
								ElseIf .Anchor.Bottom <> asNone Then
									aTop = This.FHeight - .FHeight - IIf(.Anchor.Bottom = asAnchor, .FAnchoredBottom, This.FHeight / .FAnchoredParentHeight * .FAnchoredBottom)
								End If
								If bWithoutControl <> Controls[i] Then .SetBounds(aLeft, aTop, aWidth, aHeight)
							End If
						End If
					End With
					'Select Case Controls[i]->Align
					'Case 0 'None
					'	gtk_widget_set_halign(Controls[i]->widget, GTK_ALIGN_BASELINE)
					'	gtk_widget_set_valign(Controls[i]->widget, GTK_ALIGN_BASELINE)
					'Case 1 'Left
					'	gtk_widget_set_halign(Controls[i]->widget, GTK_ALIGN_START)
					'	gtk_widget_set_valign(Controls[i]->widget, GTK_ALIGN_FILL)
					'Case 2 'Right
					'	gtk_widget_set_halign(Controls[i]->widget, GTK_ALIGN_END)
					'	gtk_widget_set_valign(Controls[i]->widget, GTK_ALIGN_FILL)
					'Case 3 'Top
					'	gtk_widget_set_halign(Controls[i]->widget, GTK_ALIGN_FILL)
					'	gtk_widget_set_valign(Controls[i]->widget, GTK_ALIGN_START)
					'Case 4 'Bottom
					'	gtk_widget_set_halign(Controls[i]->widget, GTK_ALIGN_FILL)
					'	gtk_widget_set_valign(Controls[i]->widget, GTK_ALIGN_END)
					'Case 5 'Client
					'	gtk_widget_set_halign(Controls[i]->widget, GTK_ALIGN_FILL)
					'	gtk_widget_set_valign(Controls[i]->widget, GTK_ALIGN_FILL)
					'End Select
				Next i
				'#IfDef __USE_GTK__
				'#Else
				'?ClassName, rLeft, bTop
				For i = 0 To TopCount -1
					With *ListTop[i]
						If .FVisible Then
							tTop += .ExtraMargins.Top + .Height + .ExtraMargins.Bottom
							If bWithoutControl <> ListTop[i] Then .SetBounds(lLeft + .ExtraMargins.Left, tTop - .Height - .ExtraMargins.Bottom, rLeft - lLeft - .ExtraMargins.Left - .ExtraMargins.Right, .Height)
						End If
					End With
				Next i
				'bTop = ClientHeight
				For i = 0 To BottomCount -1
					With *ListBottom[i]
						If .FVisible Then
							bTop -= .ExtraMargins.Top + .Height + .ExtraMargins.Bottom
							If bWithoutControl <> ListBottom[i] Then .SetBounds(lLeft + .ExtraMargins.Left, bTop + .ExtraMargins.Top, rLeft - lLeft - .ExtraMargins.Left - .ExtraMargins.Right, .Height)
						End If
					End With
				Next i
				'lLeft = 0
				For i = 0 To LeftCount -1
					With *ListLeft[i]
						If .FVisible Then
							lLeft += .ExtraMargins.Left + .Width + .ExtraMargins.Right
							If bWithoutControl <> ListLeft[i] Then .SetBounds(lLeft - .Width - .ExtraMargins.Right, tTop + .ExtraMargins.Top, .Width, bTop - tTop - .ExtraMargins.Top - .ExtraMargins.Bottom)
						End If
					End With
				Next i
				'rLeft = ClientWidth
				For i = 0 To RightCount -1
					With *ListRight[i]
						If .FVisible Then
							rLeft -= .ExtraMargins.Left + .Width + .ExtraMargins.Right
							If bWithoutControl <> ListRight[i] Then .SetBounds(rLeft + .ExtraMargins.Left, tTop + .ExtraMargins.Top, .Width, bTop - tTop - .ExtraMargins.Top - .ExtraMargins.Bottom)
						End If
					End With
				Next i
				For i = 0 To ClientCount -1
					With *ListClient[i]
						'If .FVisible Then
						If bWithoutControl <> ListClient[i] Then .SetBounds(lLeft + .ExtraMargins.Left, tTop + .ExtraMargins.Top, rLeft - lLeft - .ExtraMargins.Left - .ExtraMargins.Right, bTop - tTop - .ExtraMargins.Top - .ExtraMargins.Bottom)
						'End If
					End With
				Next i
			End If
			If FAutoSize Then
				Dim As Integer MaxWidth, MaxHeight
				
				GetMax MaxWidth, MaxHeight
				#ifdef __USE_GTK__
					If Height <> MaxHeight Then '+ AllocatedHeight - iClientHeight Then
						Height = MaxHeight ' + AllocatedHeight - iClientHeight
						'This.AllocatedWidth = 0
						'This.AllocatedHeight = 0
						'This.Repaint
						'If This.Parent Then
						'	'This.Parent->RequestAlign , , True
						'	This.Parent->AllocatedWidth = 0
						'	This.Parent->AllocatedHeight = 0
						'	'This.Parent->Repaint
						'End If
					End If
				#else
					If MaxHeight + Height - iClientHeight <> 0 AndAlso ControlCount <> 0 Then Move FLeft, FTop, MaxWidth + Width - iClientWidth, MaxHeight + Height - iClientHeight
				#endif
			End If
			#ifdef __USE_GTK__
				If FClient Then
					gtk_layout_move(GTK_LAYOUT(layoutwidget), FClient, lLeft, tTop)
					gtk_widget_set_size_request(FClient, Max(0, rLeft - lLeft), Max(0, bTop - tTop))
				End If
			#elseif defined(__USE_WINAPI__)
				If FClient Then
					FClientX = lLeft: FClientY = tTop: FClientW = Max(0, rLeft - lLeft): FClientH = Max(0, bTop - tTop)
					MoveWindow FClient, ScaleX(FClientX), ScaleY(FClientY), ScaleX(FClientW), ScaleY(FClientH), True
				End If
			#endif
			'#EndIf
			If ListLeft   Then Deallocate_( ListLeft)
			If ListRight  Then Deallocate_( ListRight)
			If ListTop    Then Deallocate_( ListTop)
			If ListBottom Then Deallocate_( ListBottom)
			If ListClient Then Deallocate_( ListClient)
			'This.UpdateUnLock
		End Sub
		
		#ifdef __USE_WINAPI__
			Private Sub Control.ClientToScreen(ByRef P As Point)
				If FHandle Then .ClientToScreen FHandle, Cast(..Point Ptr, @P)
			End Sub
			
			Private Sub Control.ScreenToClient(ByRef P As Point)
				If FHandle Then .ScreenToClient FHandle, Cast(..Point Ptr, @P)
			End Sub
		#endif
		
		Private Sub Control.Invalidate
			#ifdef __USE_WINAPI__
				If FHandle Then InvalidateRect FHandle, 0, True
			#endif
		End Sub
		
		Private Sub Control.Repaint
			#ifdef __USE_GTK__
				If GTK_IS_WIDGET(widget) Then gtk_widget_queue_draw(widget)
			#elseif defined(__USE_WINAPI__)
				If FHandle Then
					RedrawWindow FHandle, 0, 0, RDW_INVALIDATE
					Update
				End If
			#endif
		End Sub
		
		Private Sub Control.Update
			#ifdef __USE_GTK__
				If GTK_IS_WIDGET(widget) Then gtk_widget_queue_draw(widget)
			#elseif defined(__USE_WINAPI__)
				If FHandle Then UpdateWindow FHandle
			#endif
		End Sub
		
		Private Sub Control.UpdateLock
			#ifdef __USE_WINAPI__
				If FHandle Then LockWindowUpdate FHandle
			#endif
		End Sub
		
		Private Sub Control.UpdateUnLock
			#ifdef __USE_WINAPI__
				If FHandle Then LockWindowUpdate 0
			#endif
		End Sub
		
		Private Sub Control.SetFocus
			#ifdef __USE_GTK__
				If widget Then gtk_widget_grab_focus(widget)
			#elseif defined(__USE_WINAPI__)
				If FHandle Then .SetFocus FHandle
			#endif
		End Sub
		
		Private Sub Control.BringToFront
			#ifdef __USE_GTK__
				If This.Parent AndAlso This.Parent->layoutwidget Then
					Dim As Integer iLeft = This.Left, iTop = This.Top
					Dim As GtkWidget Ptr CtrlWidget = widget
					Select Case gtk_widget_get_parent(CtrlWidget)
					Case scrolledwidget, overlaywidget, layoutwidget, eventboxwidget
						CtrlWidget = gtk_widget_get_parent(CtrlWidget)
					End Select
					g_object_ref(CtrlWidget)
					gtk_container_remove(GTK_CONTAINER(This.Parent->layoutwidget), CtrlWidget)
					gtk_layout_put(GTK_LAYOUT(This.Parent->layoutwidget), CtrlWidget, iLeft, iTop)
				End If
			#elseif defined(__USE_WINAPI__)
				If FHandle Then SetWindowPos FHandle, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE 'BringWindowToTop Handle
			#endif
		End Sub
		
		Private Sub Control.SendToBack
			#ifdef __USE_GTK__
				If This.Parent AndAlso This.Parent->layoutwidget Then
					Dim As Integer iLeft, iTop
					Dim As GtkWidget Ptr CtrlWidget
					For i As Integer = 0 To This.Parent->ControlCount - 1
						If widget <> This.Parent->Controls[i]->widget Then
							CtrlWidget = This.Parent->Controls[i]->widget
							Select Case gtk_widget_get_parent(CtrlWidget)
							Case This.Parent->Controls[i]->scrolledwidget, This.Parent->Controls[i]->overlaywidget, This.Parent->Controls[i]->layoutwidget AndAlso gtk_widget_get_parent(This.Parent->Controls[i]->layoutwidget) <> This.Parent->Controls[i]->widget, This.Parent->Controls[i]->eventboxwidget
								CtrlWidget = gtk_widget_get_parent(CtrlWidget)
							End Select
							iLeft = This.Parent->Controls[i]->Left
							iTop = This.Parent->Controls[i]->Top
							g_object_ref(CtrlWidget)
							gtk_container_remove(GTK_CONTAINER(This.Parent->layoutwidget), CtrlWidget)
							gtk_layout_put(GTK_LAYOUT(This.Parent->layoutwidget), CtrlWidget, iLeft, iTop)
						End If
					Next
				End If
			#elseif defined(__USE_WINAPI__)
				If FHandle Then SetWindowPos FHandle, HWND_BOTTOM, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE
			#endif
		End Sub
		
		#ifdef __USE_WINAPI__
			Private Sub Control.AllocateHint
				If FHandle Then
					If ToolTipHandle Then DestroyWindow ToolTipHandle
					ToolTipHandle = CreateWindowEx(0, TOOLTIPS_CLASS, "", TTS_ALWAYSTIP Or WS_POPUP, 0, 0, 0, 0, FHandle, NULL, GetModuleHandle(NULL), NULL)
					FToolInfo.cbSize=SizeOf(TOOLINFO)
					FToolInfo.uFlags   = TTF_IDISHWND Or TTF_SUBCLASS
					SendMessage(ToolTipHandle, TTM_SETDELAYTIME, TTDT_INITIAL, 100)
					If FParent Then FToolInfo.hwnd = FParent->Handle
					FToolInfo.hinst    = GetModuleHandle(NULL)
					FToolInfo.uId      = Cast(Integer, FHandle)
					FToolInfo.lpszText = FHint
					SendMessage(ToolTipHandle, TTM_ADDTOOL, 0, CInt(@FToolInfo))
				End If
			End Sub
		#endif
		
		Private Sub Control.Add(Ctrl As Control Ptr, Index As Integer = -1)
			On Error Goto ErrorHandler
			If Ctrl Then
				If WGet(FClassName) = "Form1" Then
					Ctrl = Ctrl
				End If
				Dim As Control Ptr FSaveParent = Ctrl->Parent
				Ctrl->FParent = @This
				FControlCount += 1
				Controls = Reallocate_(Controls, SizeOf(Control Ptr)*FControlCount)
				If Index = -1 Then
					Controls[FControlCount - 1] = Ctrl
				Else
					For i As Integer = Index To FControlCount - 2
						Controls[i + 1] = Controls[i]
					Next
					Controls[Index] = Ctrl
				End If
				#ifdef __USE_GTK__
					Dim As Integer FrameTop
					Dim As Boolean bAdded
					'If Not FDesignMode Then
					If widget AndAlso GTK_IS_FRAME(widget) Then FrameTop = 20
					'End If
					Dim As GtkWidget Ptr Ctrlwidget = IIf(Ctrl->scrolledwidget, Ctrl->scrolledwidget, IIf(Ctrl->overlaywidget, Ctrl->overlaywidget, IIf(Ctrl->layoutwidget AndAlso gtk_widget_get_parent(Ctrl->layoutwidget) <> Ctrl->widget, Ctrl->layoutwidget, IIf(Ctrl->eventboxwidget, Ctrl->eventboxwidget, Ctrl->widget))))
					If GTK_IS_WIDGET(Ctrlwidget) Then
						If layoutwidget Then
							If gtk_widget_get_parent(Ctrlwidget) <> 0 Then gtk_widget_unparent(Ctrlwidget)
							gtk_layout_put(GTK_LAYOUT(layoutwidget), Ctrlwidget, Ctrl->FLeft, Ctrl->FTop - FrameTop)
							bAdded = True
						ElseIf fixedwidget Then
							If gtk_widget_get_parent(Ctrlwidget) <> 0 Then gtk_widget_unparent(Ctrlwidget)
							gtk_fixed_put(GTK_FIXED(fixedwidget), Ctrlwidget, Ctrl->FLeft, Ctrl->FTop - FrameTop)
							bAdded = True
						ElseIf GTK_IS_TEXT_VIEW(widget) Then
							If gtk_widget_get_parent(Ctrlwidget) <> 0 Then gtk_widget_unparent(Ctrlwidget)
							gtk_text_view_add_child_in_window(GTK_TEXT_VIEW(widget), Ctrlwidget, GTK_TEXT_WINDOW_WIDGET, Ctrl->FLeft, Ctrl->FTop - FrameTop)
							bAdded = True
						ElseIf GTK_IS_BOX(widget) Then
							If gtk_widget_get_parent(Ctrlwidget) <> 0 Then gtk_widget_unparent(Ctrlwidget)
							#ifdef __USE_GTK3__
								gtk_widget_set_margin_left(Ctrlwidget, Ctrl->ExtraMargins.Left)
								gtk_widget_set_margin_top(Ctrlwidget, Ctrl->ExtraMargins.Top)
								gtk_widget_set_margin_right(Ctrlwidget, Ctrl->ExtraMargins.Right)
								gtk_widget_set_margin_bottom(Ctrlwidget, Ctrl->ExtraMargins.Bottom)
							#endif
							If Ctrl->Align = DockStyle.alRight OrElse Ctrl->Align = DockStyle.alBottom Then
								#ifdef __USE_GTK4__
									gtk_box_pack_end(GTK_BOX(widget), Ctrlwidget)
								#else
									gtk_box_pack_end(GTK_BOX(widget), Ctrlwidget, False, False, 0)
								#endif
							ElseIf Ctrl->Align = DockStyle.alClient Then
								#ifdef __USE_GTK4__
									gtk_box_pack_start(GTK_BOX(widget), Ctrlwidget)
								#else
									gtk_box_pack_start(GTK_BOX(widget), Ctrlwidget, True, True, 0)
								#endif
							Else
								#ifdef __USE_GTK4__
									gtk_box_pack_start(GTK_BOX(widget), Ctrlwidget)
								#else
									gtk_box_pack_start(GTK_BOX(widget), Ctrlwidget, False, False, 0)
								#endif
							End If
							bAdded = True
						End If
					End If
					If Ctrl->eventboxwidget Then g_object_set_data(G_OBJECT(Ctrl->eventboxwidget), "@@@Control2", Ctrl)
					If Ctrl->scrolledwidget Then g_object_set_data(G_OBJECT(Ctrl->scrolledwidget), "@@@Control2", Ctrl)
					If Ctrl->overlaywidget Then g_object_set_data(G_OBJECT(Ctrl->overlaywidget), "@@@Control2", Ctrl)
					If Ctrl->widget Then g_object_set_data(G_OBJECT(Ctrl->widget), "@@@Control2", Ctrl)
					If Ctrl->layoutwidget Then g_object_set_data(G_OBJECT(Ctrl->layoutwidget), "@@@Control2", Ctrl)
					If CInt(bAdded) AndAlso CInt(CInt(Ctrl->FVisible) OrElse CInt(GTK_IS_NOTEBOOK(gtk_widget_get_parent(Ctrl->widget)))) Then
						If Ctrl->eventboxwidget Then gtk_widget_show(Ctrl->eventboxwidget)
						If Ctrl->scrolledwidget Then gtk_widget_show(Ctrl->scrolledwidget)
						If Ctrl->overlaywidget Then gtk_widget_show(Ctrl->overlaywidget)
						If Ctrl->widget Then gtk_widget_show(Ctrl->widget)
						If Ctrl->layoutwidget Then gtk_widget_show(Ctrl->layoutwidget)
					End If
					Ctrl->FAnchoredParentWidth = This.FWidth
					Ctrl->FAnchoredParentHeight = This.FHeight
					Ctrl->FAnchoredLeft = Ctrl->FLeft
					Ctrl->FAnchoredTop = Ctrl->FTop
					Ctrl->FAnchoredRight = Ctrl->FAnchoredParentWidth - Ctrl->FWidth - Ctrl->FLeft
					Ctrl->FAnchoredBottom = Ctrl->FAnchoredParentHeight - Ctrl->FHeight - Ctrl->FTop
				#elseif defined(__USE_WINAPI__)
					If Ctrl->Handle Then
						If FHandle Then
							SetParent Ctrl->Handle, FHandle
							Ctrl->FAnchoredParentWidth = This.Width
							Ctrl->FAnchoredParentHeight = This.Height
							Ctrl->FAnchoredLeft = Ctrl->FLeft
							Ctrl->FAnchoredTop = Ctrl->FTop
							Ctrl->FAnchoredRight = Ctrl->FAnchoredParentWidth - Ctrl->FWidth - Ctrl->FLeft
							Ctrl->FAnchoredBottom = Ctrl->FAnchoredParentHeight - Ctrl->FHeight - Ctrl->FTop
						End If
					ElseIf FHandle Then
						'#IFDEF __AUTOMATE_CREATE_CHILDS__
						Ctrl->CreateWnd
						'#ENDIF
					End If
				#endif
				If Ctrl->FTabIndex = -1 Then Ctrl->ChangeTabIndex - 1
				RequestAlign
				If FSaveParent Then
					If FSaveParent <> @This Then
						FSaveParent->Remove Ctrl
						FSaveParent->RequestAlign
					End If
				End If
			End If
			Exit Sub
			ErrorHandler:
			Print ErrDescription(Err) & " (" & Err & ") " & _
			"in line " & Erl() & " (Handler line: " & __LINE__ & ") " & _
			"in function " & ZGet(Erfn()) & " (Handler function: " & __FUNCTION__ & ") " & _
			"in module " & ZGet(Ermn()) & " (Handler file: " & __FILE__ & ") "
		End Sub
		
		Private Sub Control.AddRange cdecl(CountArgs As Integer, ...)
			'Dim value As Any Ptr
			Dim args As Cva_List
			'value = va_first()
			Cva_Start(args, CountArgs)
			For i As Integer = 1 To CountArgs
				'Add(va_arg(value, Control Ptr))
				Add(Cva_Arg(args, Control Ptr))
				'value = va_next(value, Long)
			Next
			Cva_End(args)
		End Sub
		
		Private Sub Control.Remove(Ctrl As Control Ptr)
			Dim As Any Ptr P
			Dim As Integer i,x,Index
			If Ctrl->FTabIndex <> -2 Then Ctrl->ChangeTabIndex -1
			Index = IndexOf(Ctrl)
			If Index >= 0 And Index <= FControlCount -1 Then
				For i = Index + 1 To FControlCount -1
					P = Controls[i]
					Controls[i -1] = P
				Next i
				FControlCount -= 1
				If FControlCount = 0 Then
					Deallocate_(Controls)
					Controls = 0
				Else
					Controls = Reallocate_(Controls,FControlCount*SizeOf(Control Ptr))
				End If
				'DeAllocate P
			End If
		End Sub
		
		Private Function Control.IndexOf(Ctrl As Control Ptr) As Integer
			Dim As Integer i
			For i = 0 To ControlCount -1
				If Controls[i] = Ctrl Then Return i
			Next i
			Return -1
		End Function
		
		#ifndef Control_IndexOf_String_Off
			Private Function Control.IndexOf(CtrlName As String) As Integer
				Dim As Integer i
				For i = 0 To ControlCount -1
					If Controls[i]->Name = CtrlName Then Return i
				Next i
				Return -1
			End Function
		#endif
		
		Private Function Control.ControlByName(CtrlName As String) As Control Ptr
			Dim i As Integer = IndexOf(CtrlName)
			If i <> -1 Then
				Return Controls[i]
			Else
				Return 0
			End If
		End Function
		
		Private Operator Control.Cast As Any Ptr
			Return @This
		End Operator
		
		Private Operator Control.Let(ByRef Value As Control Ptr)
			If Value Then
				This = *Cast(Control Ptr,Value)
			End If
		End Operator
		
		Private Constructor Control
			WLet(FClassName, "Control")
			WLet(FClassAncestor, "")
			Text = ""
			FLeft = 0
			FTop = 0
			FWidth = 0
			FHeight = 0
			FBackColor = -1
			FDefaultBackColor = FBackColor
			FTabIndex = -2
			FShowHint = True
			FVisible = True
			FEnabled = True
			'FHint = CAllocate(0)
		End Constructor
		
		Private Destructor Control
			#ifndef __FB_WIN32__
				#ifdef __USE_GTK__
					If GTK_IS_WIDGET(layoutwidget) Then
						#ifdef __USE_GTK3__
							g_signal_handlers_disconnect_by_func(layoutwidget, G_CALLBACK(@Control_Draw), @This)
						#else
							g_signal_handlers_disconnect_by_func(layoutwidget, G_CALLBACK(@Control_ExposeEvent), @This)
							g_signal_handlers_disconnect_by_func(layoutwidget, G_CALLBACK(@Control_SizeAllocate), @This)
						#endif
					End If
					If GTK_IS_WIDGET(widget) Then
						g_signal_handlers_disconnect_by_func(IIf(eventboxwidget, eventboxwidget, widget), G_CALLBACK(@EventProc), @This)
						g_signal_handlers_disconnect_by_func(IIf(eventboxwidget, eventboxwidget, widget), G_CALLBACK(@EventAfterProc), @This)
						g_signal_handlers_disconnect_by_func(G_OBJECT(widget), G_CALLBACK(@ConfigureEventProc), @This)
					End If
					If GTK_IS_WIDGET(scrolledwidget) Then
						g_signal_handlers_disconnect_by_func(scrolledwidget, G_CALLBACK(@Control_Scroll), @This)
					End If
				#endif
			#endif
			FreeWnd
			'If FText Then Deallocate FText
			If FHint Then Deallocate FHint
			'			Dim As Integer i
			'			For i = 0 To ControlCount -1
			'			    If Controls[i] Then Controls[i]->Free
			'			Next i
			If Controls Then Deallocate_( Controls)
			FPopupMenuItems.Clear
		End Destructor
	#endif
End Namespace

#ifdef __USE_JNI__
	Sub onClick Alias AddToPackage(Package, mffActivity_onClick) (ByVal env As JNIEnv Ptr, This_ As jobject, v As jobject) Export
		Dim As Integer ID = CallIntMethod(v, "android/view/View", "getId", "()I")
		Dim As My.Sys.Forms.Control Ptr Ctrl = Handles.Item(ID)
		If Ctrl Then
			If Ctrl->OnClick Then Ctrl->OnClick(*Ctrl)
		End If
	End Sub
	
	Sub onLayoutChange Alias AddToPackage(Package, mffActivity_onLayoutChange) (ByVal env As JNIEnv Ptr, This_ As jobject, v As jobject, lLeft As jint, tTop As jint, rRight As jint, bBottom As jint, oldLeft As jint, oldTop As jint, oldRight As jint, oldBottom As jint) Export
		Dim As Integer ID = CallIntMethod(v, "android/view/View", "getId", "()I")
		Dim As My.Sys.Forms.Control Ptr Ctrl = Handles.Item(ID)
		If Ctrl Then
			If Ctrl->Controls Then
				Ctrl->RequestAlign
			End If
			If Ctrl->OnResize Then Ctrl->OnResize(*Ctrl, rRight - lLeft, bBottom - tTop)
		End If
	End Sub
#endif

#ifdef __EXPORT_PROCS__
	Function Q_Control Alias "QControl" (Ctrl As Any Ptr) As My.Sys.Forms.Control Ptr __EXPORT__
		Return Cast(My.Sys.Forms.Control Ptr, Ctrl)
	End Function
	
	Sub RemoveControl Alias "RemoveControl"(Parent As My.Sys.Forms.Control Ptr, Ctrl As My.Sys.Forms.Control Ptr) Export
		Parent->Remove Ctrl
	End Sub
	
	Function ControlByIndex Alias "ControlByIndex"(Parent As My.Sys.Forms.Control Ptr, Index As Integer) As My.Sys.Forms.Control Ptr Export
		Return Parent->Controls[Index]
	End Function
	
	Function ControlByName Alias "ControlByName"(Parent As My.Sys.Forms.Control Ptr, CtrlName As String) As My.Sys.Forms.Control Ptr Export
		Return Parent->ControlByName(CtrlName)
	End Function
	
	Function IsControl Alias "IsControl"(Cpnt As My.Sys.ComponentModel.Component Ptr) As Boolean Export
		Return *Cpnt Is My.Sys.Forms.Control
	End Function
	
	Sub ControlSetFocus Alias "ControlSetFocus"(Ctrl As My.Sys.Forms.Control Ptr) Export
		Ctrl->SetFocus()
	End Sub
	
	Sub ControlFreeWnd Alias "ControlFreeWnd"(Ctrl As My.Sys.Forms.Control Ptr) Export
		Ctrl->FreeWnd()
	End Sub
	
	Sub ControlRepaint Alias "ControlRepaint" (Ctrl As My.Sys.Forms.Control Ptr) Export
		Ctrl->Repaint()
	End Sub
#endif
