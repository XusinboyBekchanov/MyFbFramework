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

Namespace My.Sys.Forms
	#ifndef Control_Off
		Function SizeConstraints.ToString ByRef As WString '...'
			WLet(FTemp, This.Left & "; " & This.Top & "; " & This.Width & "; " & This.Height)
			Return *FTemp
		End Function
		
		Function AnchorType.ToString ByRef As WString
			WLet(FTemp, This.Left & "; " & This.Top & "; " & This.Right & "; " & This.Bottom)
			Return *FTemp
		End Function
		
		#ifndef ReadProperty_Off
			Function Control.ReadProperty(ByRef PropertyName As String) As Any Ptr
				FTempString = LCase(PropertyName)
				Select Case FTempString
				Case "align": Return @FAlign
				Case "anchor": Return @Anchor
				Case "anchor.left": Return @Anchor.Left
				Case "anchor.right": Return @Anchor.Right
				Case "anchor.top": Return @Anchor.Top
				Case "anchor.bottom": Return @Anchor.Bottom
				Case "borderstyle": Return @FBorderStyle
				Case "cursor": Return Cursor
				Case "backcolor": Return @FBackColor
				Case "constraints": Return @Constraints
				Case "constraints.left": Return @Constraints.Left
				Case "constraints.top": Return @Constraints.Top
				Case "constraints.width": Return @Constraints.Width
				Case "constraints.height": Return @Constraints.Height
				Case "contextmenu": Return ContextMenu
				Case "controlcount": Return @FControlCount
				Case "doublebuffered": Return @DoubleBuffered
				Case "grouped": Return @FGrouped
				Case "helpcontext": Return @HelpContext
					#ifdef __USE_GTK__
					Case "parentwidget": Return FParentWidget
					#else
					Case "parenthandle": Return @FParentHandle
					#endif
				Case "enabled": Return @FEnabled
				Case "font": Return @This.Font
				Case "id": Return @FID
				Case "ischild": Return @FIsChild
				Case "parent": Return FParent
				Case "showhint": Return @FShowHint
				Case "hint": Return FHint.vptr
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
			Function Control.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
				If Value = 0 Then
					Select Case LCase(PropertyName)
					Case "parent": This.Parent = Value
					Case "cursor": This.Cursor = Value
					Case Else: Return Base.WriteProperty(PropertyName, Value)
					End Select
				Else
					Select Case LCase(PropertyName)
					Case "align": This.Align = QInteger(Value)
					Case "anchor.left": This.Anchor.Left = QInteger(Value)
					Case "anchor.right": This.Anchor.Right = QInteger(Value)
					Case "anchor.top": This.Anchor.Top = QInteger(Value)
					Case "anchor.bottom": This.Anchor.Bottom = QInteger(Value)
					Case "cursor": This.Cursor = Cast(My.Sys.Drawing.Cursor Ptr, Value)
					Case "doublebuffered": This.DoubleBuffered = QBoolean(Value)
					Case "borderstyle": This.BorderStyle = QInteger(Value)
					Case "backcolor": This.BackColor = QInteger(Value)
					Case "constraints.left": This.Constraints.Left = QInteger(Value)
					Case "constraints.top": This.Constraints.Top = QInteger(Value)
					Case "constraints.width": This.Constraints.Width = QInteger(Value)
					Case "constraints.height": This.Constraints.Height = QInteger(Value)
					Case "contextmenu": This.ContextMenu = Cast(PopupMenu Ptr, Value)
					Case "enabled": This.Enabled = QBoolean(Value)
					Case "grouped": This.Grouped = QBoolean(Value)
					Case "helpcontext": This.HelpContext = QInteger(Value)
					Case "font": This.Font = *Cast(My.Sys.Drawing.Font Ptr, Value)
					Case "id": This.ID = QInteger(Value)
					Case "ischild": This.IsChild = QInteger(Value)
					Case "parent": This.Parent = QControl(Value)
						#ifdef __USE_GTK__
						Case "parentwidget": This.ParentWidget = Value
						#else
						Case "parenthandle": This.ParentHandle = *Cast(HWND Ptr, Value)
						#endif
					Case "tabstop": This.TabStop = QBoolean(Value)
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
		
		#ifndef ControlCount_Off
			Function Control.ControlCount As Integer
				Return FControlCount
			End Function
		#endif
		
		#ifndef Focused_Off
			Function Control.Focused As Boolean
				#ifdef __USE_GTK__
					Return widget AndAlso gtk_widget_is_focus(widget)
				#else
					Return GetFocus = FHandle
				#endif
			End Function
		#endif
		
		#ifndef GetTextLength_Off
			Function Control.GetTextLength() As Integer
				#ifndef __USE_GTK__
					If FHandle Then
						Return Perform(WM_GETTEXTLENGTH, 0, 0)
					Else
						Return Len(FText)
					EndIf
				#else
					Return 0
				#endif
			End Function
		#endif
		
		#ifndef GetForm_Off
			Function Control.GetForm As Control Ptr
				If FParent = 0 OrElse This.ClassName = "Form" Then
					Return @This
				Else
					Return QControl(FParent)->GetForm()
				End If
			End Function
		#endif
		
		#ifndef TopLevelControl_Off
			Function Control.TopLevelControl As Control Ptr
				If FParent = 0 Then
					Return @This
				Else
					Return QControl(FParent)->TopLevelControl()
				End If
			End Function
		#endif
		
		#ifndef BorderStyle_Off
			Property Control.BorderStyle As Integer
				Return FBorderStyle
			End Property
			
			Property Control.BorderStyle(Value As Integer)
				FBorderStyle = Value
				#ifndef __USE_GTK__
					ChangeExStyle WS_EX_CLIENTEDGE, Value
				#endif
			End Property
		#endif
		
		#ifndef Style_Off
			Property Control.Style As Integer
				#ifndef __USE_GTK__
					If Handle Then
						FStyle = GetWindowLong(Handle, GWL_STYLE)
					End If
				#endif
				Return FStyle
			End Property
			
			Property Control.Style(Value As Integer)
				FStyle = Value
				#ifndef __USE_GTK__
					If FHandle Then SetWindowLong(FHandle, GWL_STYLE, FStyle) 'RecreateWnd
				#endif
			End Property
		#endif
		
		#ifndef ExStyle_Off
			Property Control.ExStyle As Integer
				#ifndef __USE_GTK__
					If Handle Then
						FExStyle = GetWindowLong(Handle, GWL_EXSTYLE)
					End If
				#endif
				Return FExStyle
			End Property
			
			Property Control.ExStyle(Value As Integer)
				FExStyle = Value
				'If Handle Then RecreateWnd
			End Property
		#endif
		
		#ifndef IsChild_Off
			Property Control.IsChild As Boolean
				Return FIsChild
			End Property
			
			Property Control.IsChild(Value As Boolean)
				FIsChild = Value
				#ifndef __USE_GTK__
					ChangeStyle WS_CHILD, Value
					If Handle Then RecreateWnd
				#endif
			End Property
		#endif
		
		#ifndef ID_Off
			Property Control.ID As Integer
				#ifndef __USE_GTK__
					If Handle Then
						FID = GetDlgCtrlID(Handle)
					End If
				#endif
				Return FID
			End Property
			
			Property Control.ID(Value As Integer)
				FID = Value
			End Property
		#endif
		
		#ifndef Text_Off
			Property Control.Text ByRef As WString
				#ifndef __USE_GTK__
					If FHandle Then
						Dim As Integer L
						L = Perform(WM_GETTEXTLENGTH, 0, 0)
						FText.Resize(L + 1) '  = WString(L + 1 + 1, 0)
						GetWindowText(FHandle, FText.vptr, L + 1)
					End If
				#endif
				Return WGet(FText.vptr)
			End Property
			
			Dim Shared TempString As String
			Property Control.Text(ByRef Value As WString)
				FText = Value
				#ifdef __USE_GTK__
					If widget Then
						If GTK_IS_WINDOW(widget) Then
							gtk_window_set_title(GTK_WINDOW(widget), ToUtf8(Value))
						End If
					End If
				#else
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
			Property Control.Hint ByRef As WString
				Return *FHint.vptr
			End Property
			
			Property Control.Hint(ByRef Value As WString)
				FHint = Value
				#ifndef __USE_GTK__
					If FHandle Then
						If ToolTipHandle Then
							SendMessage(ToolTipHandle, TTM_GETTOOLINFO, 0, CInt(@FToolInfo))
							FToolInfo.lpszText = FHint.vptr
							SendMessage(ToolTipHandle, TTM_UPDATETIPTEXT, 0, CInt(@FToolInfo))
						End If
					End If
				#endif
			End Property
		#endif
		
		#ifndef Align_Off
			Property Control.Align As Integer
				Return FAlign
			End Property
			
			Property Control.Align(Value As Integer)
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
			Function Control.ClientWidth As Integer
				#ifdef __USE_GTK__
					Dim As GtkRequisition minimum, requisition
					If layoutwidget Then
						#ifdef __USE_GTK3__
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
				#else
					If FHandle Then
						GetClientRect Handle ,@R
						FClientWidth = R.Right
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
				#endif
				Return FClientWidth
			End Function
		#endif
		
		#ifndef ClientHeight_Off
			Function Control.ClientHeight As Integer
				#ifdef __USE_GTK__
					Dim As GtkRequisition minimum, requisition
					If layoutwidget Then
						#ifdef __USE_GTK3__
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
				#else
					If Handle Then
						GetClientRect Handle ,@R
						FClientHeight = R.Bottom
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
				#endif
				Return FClientHeight
			End Function
		#endif
		
		#ifndef ShowHint_Off
			Property Control.ShowHint As Boolean
				Return FShowHint
			End Property
			
			Property Control.ShowHint(Value As Boolean)
				FShowHint = Value
				#ifndef __USE_GTK__
					If Handle Then
						If ToolTipHandle Then SendMessage(ToolTipHandle,TTM_ACTIVATE,FShowHint,0)
					End If
				#endif
			End Property
		#endif
		
		#ifndef Color_Off
			Property Control.BackColor As Integer
				Return FBackColor
			End Property
			
			Property Control.BackColor(Value As Integer)
				FBackColor = Value
				FBackColorRed = GetRed(Value) / 255.0
				FBackColorGreen = GetGreen(Value) / 255.0
				FBackColorBlue = GetBlue(Value) / 255.0
				Brush.Color = FBackColor
				Invalidate
			End Property
			
			Property Control.ForeColor As Integer
				Return FForeColor
			End Property
			
			Property Control.ForeColor(Value As Integer)
				FForeColor = Value
				FForeColorRed = GetRed(Value) / 255.0
				FForeColorGreen = GetGreen(Value) / 255.0
				FForeColorBlue = GetBlue(Value) / 255.0
				Font.Color = FForeColor
				Invalidate
			End Property
		#endif
		
		#ifndef Parent_Off
			Property Control.Parent As Control Ptr
				Return Cast(Control Ptr, FParent)
			End Property
			
			Property Control.Parent(Value As Control Ptr)
				FParent = Value
				If Value Then Value->Add(@This)
			End Property
		#endif
		
		#ifndef StyleExists_Off
			Function Control.StyleExists(iStyle As Integer) As Boolean
				Return (Style And iStyle) = iStyle
			End Function
		#endif
		
		Function Control.ExStyleExists(iStyle As Integer) As Boolean '...'
			Return (ExStyle AND iStyle) = iStyle
		End Function
		
		Sub Control.ChangeStyle(iStyle As Integer, Value As Boolean)
			If Value Then
				If ((Style And iStyle) <> iStyle) Then Style = Style Or iStyle
			ElseIf ((Style And iStyle) = iStyle) Then
				Style = Style And Not iStyle
			End If
		End Sub
		
		Sub Control.ChangeExStyle(iStyle As Integer, Value As Boolean)
			If Value Then
				If ((ExStyle And iStyle) <> iStyle) Then ExStyle = ExStyle Or iStyle
			ElseIf ((ExStyle And iStyle) = iStyle) Then
				ExStyle = ExStyle And Not iStyle
			End If
		End Sub
		
		Sub Control.ChangeTabIndex(Value As Integer)
			Dim As Control Ptr ParentCtrl = Cast(Control Ptr, GetTopLevel)
			Dim As Control Ptr Ctrl
			FTabIndex = Value
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
				.FTabIndexList.Insert FTabIndex, FTabIndex, @This
				For i As Integer = 0 To .FTabIndexList.Count - 1
					Ctrl = .FTabIndexList.Object(i)
					Ctrl->FTabIndex = i
				Next
			End With
		End Sub
		
		#ifdef __USE_GTK__
			Property Control.ParentWidget As GtkWidget Ptr
				Return FParentWidget
			End Property
			
			Property Control.ParentWidget(Value As GtkWidget Ptr)
				FParentWidget = Value
				If GTK_IS_LAYOUT(Value) Then
					gtk_layout_put(GTK_LAYOUT(Value), widget, FLeft, FTop)
				ElseIf GTK_IS_FIXED(Value) Then
					gtk_fixed_put(GTK_FIXED(Value), widget, FLeft, FTop)
				ElseIf GTK_IS_CONTAINER(Value) Then
					gtk_container_add(GTK_CONTAINER(Value), widget)
				End If
			End Property
		#else
			Property Control.ParentHandle As HWND
				Return FParentHandle
			End Property
			
			Property Control.ParentHandle(Value As HWND)
				FParentHandle = Value
			End Property
		#endif
		
		Property Control.TabStop As Boolean
			#ifndef __USE_GTK__
				FTabStop = StyleExists(WS_TABSTOP)
			#endif
			Return FTabStop
		End Property
		
		Property Control.TabStop(Value As Boolean)
			FTabStop = Value
			#ifndef __USE_GTK__
				ChangeStyle WS_TABSTOP, Value
			#endif
		End Property
		
		Property Control.Grouped As Boolean
			#ifndef __USE_GTK__
				FGrouped = StyleExists(WS_GROUP)
			#endif
			Return FGrouped
		End Property
		
		Property Control.Grouped(Value As Boolean)
			FGrouped = Value
			#ifndef __USE_GTK__
				ChangeStyle WS_GROUP, Value
			#endif
		End Property
		
		Property Control.Enabled As Boolean
			#ifndef __USE_GTK__
				If Handle Then FEnabled = IsWindowEnabled(Handle)
			#endif
			Return FEnabled
		End Property
		
		Property Control.Enabled(Value As Boolean)
			FEnabled = Value
			#ifdef __USE_GTK__
				If Widget Then gtk_widget_set_sensitive(Widget, FEnabled)
			#else
				If FHandle Then EnableWindow FHandle, FEnabled
			#endif
		End Property
		
		Property Control.Visible() As Boolean
			#ifndef __USE_GTK__
				If FHandle Then FVisible = IsWindowVisible(FHandle)
			#endif
			Return FVisible
		End Property
		
		Property Control.Visible(Value As Boolean)
			FVisible = Value
			If (Not DesignMode) OrElse Value Then
				#ifdef __USE_GTK__
					If widget Then
						'If Not gtk_widget_is_toplevel(widget) Then gtk_widget_set_child_visible(widget, Value)
						gtk_widget_set_visible(widget, Value)
					End If
				#else
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
		
		Sub Control.Show
			Visible = True
		End Sub
		
		Sub Control.Hide '...'
			Visible = False
		End Sub
		
		Sub Control.CreateWnd
			Dim As Long nLeft   = FLeft
			Dim As Long nTop    = FTop
			Dim As Long nWidth  = FWidth
			Dim As Long nHeight = FHeight
			#ifndef __USE_GTK__
				If Handle Then Exit Sub
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
						HParent = FParent->Handle
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
								nLeft = .Left + (.Width - nWidth) \ 2: nTop  = .Top + (.Height - nHeight) \ 2
							End With
						Else ' CenterScreen
							nLeft = (GetSystemMetrics(SM_CXSCREEN) - nWidth) \ 2: nTop  = (GetSystemMetrics(SM_CYSCREEN) - nHeight) \ 2
						End If
					Case 2: nLeft = CW_USEDEFAULT: nTop = CW_USEDEFAULT ' WindowsDefaultLocation
					Case 3: nLeft = CW_USEDEFAULT: nTop = CW_USEDEFAULT: nWidth = CW_USEDEFAULT: nHeight = CW_USEDEFAULT ' WindowsDefaultBounds
					End Select
					Dim As Integer AControlParent(2) => {0, WS_EX_CONTROLPARENT}
					Dim As Integer ATabStop(2) => {0,WS_TABSTOP},AGrouped(2) = >{0,WS_GROUP}
					If ClassName = "IPAddress" Then
						Text = ""
						Style = WS_TABSTOP Or WS_CHILD Or WS_VISIBLE
						ExStyle = 0
					Else
						If (Style And (WS_CLIPCHILDREN Or WS_CLIPSIBLINGS)) <> (WS_CLIPCHILDREN Or WS_CLIPSIBLINGS) Then
							Style = Style Or (WS_CLIPCHILDREN Or WS_CLIPSIBLINGS)
						End If
						If (Style And (ATabStop(Abs_(FTabStop)) Or AGrouped(Abs_(FGrouped)))) <> (ATabStop(Abs_(FTabStop)) Or AGrouped(Abs_(FGrouped))) Then
							Style = Style Or (ATabStop(Abs_(FTabStop)) Or AGrouped(Abs_(FGrouped)))
						End If
						If (ExStyle And AControlParent(Abs_(FControlParent))) <> AControlParent(Abs_(FControlParent)) Then
							ExStyle = ExStyle Or AControlParent(Abs_(FControlParent))
						End If
					End If
					CreationControl = @This
					'RegisterClass ClassName, ClassAncestor
					FHandle = CreateWindowExW(FExStyle,_
					IIf(*FClassName = "IPAddress", @WC_IPADDRESS, FClassName),_
					FText.vptr,_
					FStyle,_
					nLeft,_
					nTop,_
					nWidth,_
					nHeight,_
					HParent,_
					Cast(HMENU, ControlID),_
					Instance,_
					@This) ' '
				#endif
				If Handle Then
					SetWindowLongPtr(Handle, GWLP_USERDATA, CInt(Child))
					If SubClass Then
						PrevProc = Cast(Any Ptr, SetWindowLongPtr(Handle, GWLP_WNDPROC, CInt(@CallWndProc)))
					End If
					BringToFront
					If This.Font Then This.Font.Parent = @This
					SendMessage FHandle, CM_CREATE, 0, 0
					If ShowHint Then AllocateHint
					If OnHandleIsAllocated Then OnHandleIsAllocated(This)
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
					If OnCreate Then OnCreate(This)
					If FVisible Then ShowWindow(FHandle, SW_SHOWNORMAL)
					Update
				End If
			#endif
		End Sub
		
		Sub Control.RecreateWnd
			Dim As Integer i
			#ifndef __USE_GTK__
				If Handle = 0 Then Exit Sub
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
		
		Sub Control.FreeWnd
			#ifdef __USE_GTK__
'				If gtk_is_widget(Widget) Then
'					gtk_widget_destroy(Widget)
'				End If
'				If gtk_is_widget(ScrolledWidget) Then
'					gtk_widget_destroy(ScrolledWidget)
'				End If
			#else
				If OnHandleIsDestroyed Then OnHandleIsDestroyed(This)
				If FHandle Then
					'					For i As Integer = 0 To ControlCount - 1
					'						Controls[i]->FreeWnd
					'					Next
					DestroyWindow FHandle
					FHandle = 0
				End If
				If ToolTipHandle Then
					DestroyWindow ToolTipHandle
					ToolTipHandle = 0
				End If
			#endif
		End Sub
		
		Property Control.ContextMenu As PopupMenu Ptr
			Return FContextMenu
		End Property
		
		Property Control.ContextMenu(Value As PopupMenu Ptr)
			FContextMenu = Value
			If FContextMenu Then FContextMenu->ParentWindow = @This
		End Property
		
		Sub Control.ProcessMessage(ByRef Message As Message)
			Static bShift As Boolean, bCtrl As Boolean
			#ifdef __USE_GTK__
				Dim As GdkEvent Ptr e = Message.event 
				Select Case Message.event->Type
				Case GDK_NOTHING
				Case GDK_BUTTON_PRESS
					'Message.Result = True
					DownButton = e->button.button - 1
					If OnMouseDown Then OnMouseDown(This, e->button.button - 1, e->button.x, e->button.y, e->button.state)
				Case GDK_BUTTON_RELEASE
					'Message.Result = True
					DownButton = -1
					If gtk_is_button(widget) = 0 Then
						If OnClick Then OnClick(This)
					End If
					If OnMouseUp Then OnMouseUp(This, e->button.button - 1, e->button.x, e->button.y, e->button.state)
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
					If OnMouseMove Then OnMouseMove(This, DownButton, e->Motion.x, e->Motion.y, e->Motion.state)
				Case GDK_KEY_PRESS
					'Message.Result = True
					If OnKeyDown Then OnKeyDown(This, e->Key.keyval, e->Key.state)
					If CInt(OnKeyPress) AndAlso CInt(Not Message.Result) Then OnKeyPress(This, Asc(*e->Key.string))
				Case GDK_KEY_RELEASE
					'Message.Result = True
					If OnKeyUp Then OnKeyUp(This, e->Key.keyval, e->Key.state)
				Case GDK_ENTER_NOTIFY
					If OnMouseOver Then OnMouseOver(This)
				Case GDK_LEAVE_NOTIFY
					If OnMouseLeave Then OnMouseLeave(This)
				Case GDK_CONFIGURE
					'If OnResize Then OnResize(This)
					RequestAlign
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
						If OnMouseWheel Then OnMouseWheel(This, e->Scroll.delta_x, e->Scroll.x, e->Scroll.y, e->Scroll.state)
					#else
						If e->Scroll.direction = GDK_SCROLL_UP Then
							If OnMouseWheel Then OnMouseWheel(This, -1, e->Scroll.x, e->Scroll.y, e->Scroll.state)
						Else
							If OnMouseWheel Then OnMouseWheel(This, 1, e->Scroll.x, e->Scroll.y, e->Scroll.state)
						End If
					#endif
				Case GDK_FOCUS_CHANGE
					If Cast(GdkEventFocus Ptr, e)->in Then
						If OnGotFocus Then OnGotFocus(This)
						Dim frm As Control Ptr = GetForm
						If frm Then
							frm->FActiveControl = @This
							If frm->OnActiveControlChanged Then frm->OnActiveControlChanged(*frm)
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
			#else
				bShift = GetKeyState(VK_SHIFT) And 8000
				bCtrl = GetKeyState(VK_CONTROL) And 8000
				Select Case Message.Msg
				Case WM_NCHITTEST
					If DesignMode Then
						If ClassName <> "Form" AndAlso ClassName <> "GroupBox" Then
							Message.Result = HTTRANSPARENT
						End If
					End If
				Case WM_PAINT
					If OnPaint Then OnPaint(This, Canvas)
				Case WM_SETCURSOR
					If CInt(This.Cursor <> 0) AndAlso CInt(LoWord(message.lParam) = HTCLIENT) AndAlso CInt(Not DesignMode) Then
						Message.Result = Cast(LResult, SetCursor(This.Cursor->Handle))
					End If
				Case WM_HSCROLL
					If Not Message.LParam = Null Then
						SendMessage Cast(HWND, Message.LParam), CM_HSCROLL, Cast(WParam, Message.WParam), Cast(LParam, Message.LParam)
					Else
						If OnScroll Then OnScroll(This)
					End If
				Case WM_VSCROLL
					If Not Message.LParam = Null Then
						SendMessage Cast(HWND, Message.LParam), CM_VSCROLL, Cast(WParam, Message.WParam), Cast(LParam, Message.LParam)
					Else
						If OnScroll Then OnScroll(This)
					End If
				Case WM_CTLCOLORMSGBOX To WM_CTLCOLORSTATIC
					Dim As Control Ptr Child
					If Message.Msg = WM_CTLCOLORSTATIC Then
						If (GetWindowLong(CPtr(HWND,Message.LParam), GWL_STYLE) And SS_SIMPLE) = SS_SIMPLE Then
							Exit Select
						End If
					End If
					Child = Cast(Control Ptr,GetWindowLongPtr(CPtr(HWND,Message.LParam),GWLP_USERDATA))
					If Child Then
						With *Child
							SendMessage(CPtr(HWND,Message.LParam),CM_CTLCOLOR,Message.wParam, Message.lParam)
							message.result = Cast(LRESULT,.Brush.Handle)
						End With
					Else
						Dim As HDC Dc
						DC = Cast(HDC,Message.wParam)
						Child = Cast(Control Ptr,GetWindowLongPtr(Message.hWnd,GWLP_USERDATA))
						If Child Then
							SetBKMode(DC,TRANSPARENT)
							SetBKColor(DC,Child->BackColor)
							If Child->Font Then SetTextColor(DC,Child->Font.Color)
							SetBKMode(DC,OPAQUE)
							message.result = Cast(LRESULT,Brush.Handle)
						End If
					End If
				Case WM_SIZE
					If Controls Then
						RequestAlign
					End If
					If OnReSize Then OnReSize(This, This.Width, This.Height)
				Case WM_WINDOWPOSCHANGING
					If Constraints.Left <> 0 Then *Cast(WINDOWPOS Ptr, Message.lParam).x  = Constraints.Left
					If Constraints.Top <> 0 Then *Cast(WINDOWPOS Ptr, Message.lParam).y  = Constraints.Top
					If Constraints.Width <> 0 Then *Cast(WINDOWPOS Ptr, Message.lParam).cx = Constraints.Width
					If Constraints.Height <> 0 Then *Cast(WINDOWPOS Ptr, Message.lParam).cy = Constraints.Height
				Case WM_CANCELMODE
					SendMessage(Handle,CM_CANCELMODE,0,0)
				Case WM_LBUTTONDOWN
					DownButton = 0
					If OnMouseDown Then OnMouseDown(This,0,Message.lParamLo,Message.lParamHi,Message.wParam And &HFFFF)
				Case WM_LBUTTONDBLCLK
					If OnDblClick Then OnDblClick(This)
				Case WM_LBUTTONUP
					DownButton = -1
					If OnClick Then OnClick(This)
					If OnMouseUp Then OnMouseUp(This,0,Message.lParamLo,Message.lParamHi,Message.wParam And &HFFFF)
				Case WM_MBUTTONDOWN
					DownButton = 2
					If OnMouseDown Then OnMouseDown(This,2,Message.lParamLo,Message.lParamHi,Message.wParam And &HFFFF)
				Case WM_MBUTTONUP
					DownButton = -1
					If OnMouseUp Then OnMouseUp(This,2,Message.lParamLo,Message.lParamHi,Message.wParam And &HFFFF)
				Case WM_RBUTTONDOWN
					DownButton = 1
					If OnMouseDown Then OnMouseDown(This,1,Message.lParamLo,Message.lParamHi,Message.wParam And &HFFFF)
				Case WM_RBUTTONUP
					DownButton = -1
					If OnMouseUp Then OnMouseUp(This,1,Message.lParamLo,Message.lParamHi,Message.wParam And &HFFFF)
					If ContextMenu Then
						If ContextMenu->Handle Then
							Dim As Point P
							P.x = Message.lParamLo
							P.y = Message.lParamHi
							.ClientToScreen(This.Handle, @P)
							ContextMenu->Popup(P.x, P.y)
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
						SendMessage(GetDlgItem(Handle,Message.wParam),CM_MEASUREITEM,Message.wParam,Message.lParam)
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
					SendMessage(Cast(HWND,Message.lParam),CM_COMMAND,Message.wParam,Message.lParam)
				Case WM_MOUSEMOVE
					If OnMouseMove Then OnMouseMove(This, DownButton, Message.lParamLo,Message.lParamHi,Message.wParam And &HFFFF)
					If This.Tracked = False Then
						Dim As TRACKMOUSEEVENT event_
						event_.cbSize = SizeOf(TRACKMOUSEEVENT)
						event_.dwFlags = TME_LEAVE
						event_.hwndTrack = Handle
						event_.dwHoverTime = 10
						TrackMouseEvent(@event_)
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
					If OnMouseWheel Then OnMouseWheel(This, scrDirection, Message.lParamLo,Message.lParamHi,Message.wParam And &HFFFF)
				Case WM_MOUSELEAVE
					If OnMouseLeave Then OnMouseLeave(This)
					This.Tracked = False
				Case WM_DROPFILES
					If OnDropFile Then
						Dim As HDrop iDrop = Cast(HDrop, Message.wParam)
						Dim As Integer filecount, length, i
						filecount = DragQueryFile(iDrop, -1, NULL, 0)
						Dim As WString Ptr filename
						For i = 0 To filecount - 1
							WReallocate(filename, MAX_PATH)
							length = DragQueryFile(iDrop, i, filename, MAX_PATH)
							'*filename = Left(*filename, length)
							If OnDropFile Then OnDropFile(This, *filename)
						Next
						DragFinish iDrop
					End If
				Case WM_CHAR
					If OnKeyPress Then OnKeyPress(This, Message.WParam)
				Case WM_KEYDOWN
					If OnKeyDown Then OnKeyDown(This, Message.WParam, Message.lParam And &HFFFF)
					If GetKeyState(VK_MENU) >= 0 Then
						Select Case LoWord(message.wParam)
						Case VK_TAB
							Dim Frm As Control Ptr = Cast(Control Ptr, GetTopLevel)
							If Frm Then
								Frm->SelectNextControl bShift
								Message.Result = -1:
								Exit Sub
							End If
						Case VK_RETURN
							Dim Frm As Control Ptr = GetForm
							If Frm AndAlso frm->FDefaultButton AndAlso frm->FDefaultButton->OnClick Then
								frm->FDefaultButton->OnClick(*frm->FDefaultButton)
								Message.Result = -1:
								Exit Sub
							End If
						Case VK_ESCAPE
							Dim Frm As Control Ptr = GetForm
							If Frm AndAlso frm->FCancelButton AndAlso frm->FCancelButton->OnClick Then
								frm->FCancelButton->OnClick(*frm->FCancelButton)
								Message.Result = -1:
								Exit Sub
							End If
						End Select
					End If
				Case WM_KEYUP
					If OnKeyUp Then OnKeyUp(This,LoWord(Message.WParam),Message.lParam And &HFFFF)
				Case WM_SETFOCUS
					If OnGotFocus Then OnGotFocus(This)
					Dim frm As Control Ptr = GetForm
					If frm Then
						frm->FActiveControl = @This
						If frm->OnActiveControlChanged Then frm->OnActiveControlChanged(*frm)
					End If
				Case WM_KILLFOCUS
					If OnLostFocus Then OnLostFocus(This)
				Case WM_NOTIFY
					Dim As LPNMHDR NM
					Static As HWND FWindow
					NM = Cast(LPNMHDR,Message.lParam)
					If NM->Code = TTN_NEEDTEXT Then
						If FWindow Then SendMessage FWindow,CM_NEEDTEXT,Message.wParam, Message.lParam
					Else
						FWindow = NM->hwndFrom
						SendMessage FWindow, CM_NOTIFY, Message.wParam, Message.lParam
					End If
				Case WM_HELP
					'If (GetWindowLong(message.hwnd,GWL_STYLE) And WS_CHILD) <> WS_CHILD Then SendMessage(message.hwnd,CM_HELP,message.wParam,message.LParam)
				Case WM_NEXTDLGCTL
					Dim As Control Ptr NextCtrl
					Dim As Control Ptr frm = Cast(Control Ptr, GetTopLevel)
					If frm Then
						NextCtrl = frm->SelectNextControl()
						If NextCtrl Then NextCtrl->SetFocus
					End If
				Case WM_DESTROY
					SetWindowLongPtr(FHandle, GWLP_USERDATA, 0)
					If OnDestroy Then OnDestroy(This)
					'FHandle = 0
				End Select
			#endif
		End Sub
		
		Sub Control.ProcessMessageAfter(ByRef Message As Message)
			#ifdef __USE_GTK__
				Dim As GdkEvent Ptr e = Message.event
				Select Case Message.event->Type
				Case GDK_CONFIGURE
					
				Case GDK_WINDOW_STATE
					
				End Select
				Message.Result = True
			#else
				Select Case Message.Msg
				Case WM_NCHITTEST
					If DesignMode Then
						If ClassName <> "Form" Then
							'Message.Result = HTTRANSPARENT
						End If
					End If
				Case WM_DESTROY
					SetWindowLongPtr(FHandle, GWLP_USERDATA, 0)
					If OnDestroy Then OnDestroy(This)
					'FHandle = 0
				End Select
			#endif
		End Sub
		
		Function Control.EnumPopupMenuItems(ByRef Item As MenuItem) As Boolean
			FPopupMenuItems.Add Item
			For i As Integer = 0 To Item.Count -1
				EnumPopupMenuItems *Item.Item(i)
			Next i
			Return True
		End Function
		
		Sub Control.GetPopupMenuItems
			FPopupMenuItems.Clear
			If ContextMenu Then
				For i As Integer = 0 To ContextMenu->Count -1
					EnumPopupMenuItems *ContextMenu->Item(i)
				Next i
			End If
		End Sub
		
		Function Control.EnumControls(Item As Control Ptr) As Boolean
			FControls.Add Item
			For i As Integer = 0 To Item->ControlCount - 1
				EnumControls Item->Controls[i]
			Next i
			Return True
		End Function
		
		Sub Control.GetControls
			FControls.Clear
			For i As Integer = 0 To ControlCount - 1
				EnumControls Controls[i]
			Next i
		End Sub
		
		#ifdef __USE_GTK__
			Function Control.EventProc(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
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
			
			Function Control.EventAfterProc(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
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
		#else
			Function Control.DefWndProc(FWindow As HWND,Msg As UINT,wParam As WPARAM,lParam As LPARAM) As LRESULT
				Dim Message As Message
				Dim As Control Ptr Ctrl = Cast(Any Ptr, GetWindowLongPtr(FWindow, GWLP_USERDATA))
				Message = Type(Ctrl, FWindow,Msg,wParam,lParam,0,LoWord(wParam),HiWord(wParam),LoWord(lParam),HiWord(lParam), 0)
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
						ElseIf Message.Result <> 0 Then
							Return Message.Result
						End If
					End If
				End If
				Message.Result = DefWindowProc(FWindow,Msg,wParam,lParam)
				'				If Ctrl Then
				'					Ctrl->ProcessMessageAfter(Message)
				'				End If
				Return Message.Result
			End Function
			
			Function Control.CallWndProc(FWindow As HWND,Msg As UINT,wParam As WPARAM,lParam As LPARAM) As LRESULT
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
			
			Function Control.SuperWndProc(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
				'    			On Error Goto ErrorHandler
				Dim As Control Ptr Ctrl
				Dim Message As Message
				Ctrl = Cast(Any Ptr, GetWindowLongPtr(FWindow, GWLP_USERDATA))
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
				'				If Ctrl Then
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
			
			Function Control.Perform(Msg As UINT,wParam As WPARAM,lParam As LPARAM) As LRESULT
				If Handle Then
					Return SendMessageW(Handle, Msg, wParam, lParam)
				Else
					Return 0
				End If
			End Function
		#endif
		
		Function Control.SelectNextControl(Prev As Boolean = False) As Control Ptr
			Static As Integer Index
			If FActiveControl Then
				'If CurControl->Parent Then
					#ifndef __USE_GTK__
'						Dim As HWND CtrlHandle = GetNextDlgTabItem(CurControl->Parent->Handle, CurControl->Handle, Prev)
'						.SetFocus(CtrlHandle)
					#else
						
					#endif
				'End If
			End If
			Return NULL
		End Function
		
		#ifdef __USE_GTK__
			Sub Control.Control_SizeAllocate(widget As GtkWidget Ptr, allocation As GdkRectangle Ptr, user_data As Any Ptr)
				Dim As Control Ptr Ctrl = Cast(Any Ptr, user_data)
				If gtk_is_layout(widget) Then
					#ifdef __USE_GTK3__
						Dim As Integer AllocatedWidth = gtk_widget_get_allocated_width(widget), AllocatedHeight = gtk_widget_get_allocated_height(widget)
					#else
						Dim As Integer AllocatedWidth = widget->allocation.width, AllocatedHeight = widget->allocation.height
					#endif
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
			
			Function Control.Control_Draw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
				Dim As Control Ptr Ctrl = Cast(Any Ptr, data1)
				If gtk_is_layout(widget) AndAlso Ctrl <> 0 Then
					Ctrl->Canvas.HandleSetted = True 
					Ctrl->Canvas.Handle = cr
					If Ctrl->OnPaint Then Ctrl->OnPaint(*Ctrl, Ctrl->Canvas)
					#ifdef __USE_GTK3__
						Dim As Integer AllocatedWidth = gtk_widget_get_allocated_width(widget), AllocatedHeight = gtk_widget_get_allocated_height(widget)
					#else
						Dim As Integer AllocatedWidth = widget->allocation.width, AllocatedHeight = widget->allocation.height
					#endif
					If Ctrl->BackColor <> -1 Then
						Dim As Integer iColor = Ctrl->BackColor
						cairo_rectangle(cr, 0.0, 0.0, AllocatedWidth, AllocatedHeight)
						cairo_set_source_rgb(cr, Ctrl->FBackColorRed, Ctrl->FBackColorGreen, Ctrl->FBackColorBlue)
						cairo_fill(cr)
					End If
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
			
			Function Control.Control_ExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
				Dim As cairo_t Ptr cr = gdk_cairo_create(Event->window)
				Control_Draw(widget, cr, data1)
				cairo_destroy(cr)
				Return False
			End Function
			
			Function Control.RegisterClass(ByRef wClassName As WString, Obj As Any Ptr, WndProcAddr As Any Ptr = 0) As Boolean
				Dim As Boolean Result
				Dim Proc As Function(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean = WndProcAddr
				If layoutwidget Then
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
					#else
						g_signal_connect(layoutwidget, "expose-event", G_CALLBACK(@Control_ExposeEvent), Obj)
						g_signal_connect(layoutwidget, "size-allocate", G_CALLBACK(@Control_SizeAllocate), Obj)
					#endif
				End If
				If widget Then
					Font.Parent = @This
					gtk_widget_set_events(widget, _
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
				End If
				Return Result
			End Function
		#else
			Function Control.RegisterClass(ByRef wClassName As WString, ByRef wClassAncestor As WString = "", WndProcAddr As Any Ptr = 0) As Integer
				If wClassName = "IPAddress" Then Exit Function
				Dim As Integer Result
				Dim As WNDCLASSEX Wc
				Dim As Any Ptr ClassProc
				Dim Proc As Function(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT = WndProcAddr
				Wc.cbsize = SizeOf(WNDCLASSEX)
				If wClassAncestor <> "" Then
					If GetClassInfoEx(0, wClassAncestor, @Wc) <> 0 Then
						ClassProc = Wc.lpfnWndProc
						Wc.lpszClassName = @wClassName
						Wc.lpfnWndProc   = IIf(WndProcAddr = 0, @SuperWndProc, Proc)
						Wc.hInstance     = Instance
						'If Cursor AndAlso Cursor->Handle Then Wc.hCursor = Cursor->Handle
						Wc.cbWndExtra += 4
						Result = .RegisterClassEx(@Wc)
						If Result Then
							StoreClass wClassName, wClassAncestor, ClassProc
						End If
					ElseIf GetClassInfoEx(Instance, wClassAncestor, @Wc) <> 0 Then
						ClassProc = GetClassProc(wClassAncestor)
						'If Cursor AndAlso Cursor->Handle Then Wc.hCursor = Cursor->Handle
						Wc.lpszClassName = @wClassName
						Wc.lpfnWndProc   = IIf(WndProcAddr = 0, @DefWndProc, Proc)
						Result = .RegisterClassEx(@Wc)
						If Result Then
							StoreClass wClassName, wClassAncestor, ClassProc
						End If
					Else
						MessageBox NULL, wClassName & "' sinfini qayd qilish imkoni yo`q.", "Control", MB_ICONERROR
					End If
				Else
					If GetClassInfoEx(GetModuleHandle(NULL), wClassName, @Wc) = 0 Then
						Wc.lpszClassName = @wClassName
						Wc.lpfnWndProc   = IIf(WndProcAddr = 0, @DefWndProc, Proc)
						Wc.Style = CS_DBLCLKS Or CS_HREDRAW Or CS_VREDRAW
						Wc.hInstance     = Instance
						Wc.hCursor       = LoadCursor(NULL, IDC_ARROW)
						Wc.hbrBackground = Cast(HBRUSH, 16)
						Result = .RegisterClassEx(@Wc)
					End If
				End If
				Return Result
			End Function
		#endif
		
		Sub Control.SetMargins(mLeft As Integer, mTop As Integer, mRight As Integer, mBottom As Integer,NOSCALE As Boolean = False)
			If NOSCALE Then
				Margins.Left   = mLeft
				Margins.Top    = mTop
				Margins.Right  = mRight
				Margins.Bottom = mBottom
			Else
				Margins.Left   = ScaleX(mLeft)
				Margins.Top    = ScaleY(mTop)
				Margins.Right  = ScaleX(mRight)
				Margins.Bottom = ScaleY(mBottom)
			End If
			RequestAlign
		End Sub
		
		Sub Control.RequestAlign(iClientWidth As Integer = -1, iClientHeight As Integer = -1, bInDraw As Boolean = False)
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
			If ControlCount = 0 Then Exit Sub
			If iClientWidth = -1 Then iClientWidth = ClientWidth
			If iClientHeight = -1 Then iClientHeight = ClientHeight
			lLeft = 0
			rLeft = iClientWidth
			tTop  = 0
			bTop  = iClientHeight
			#ifdef __USE_GTK__
				If rLeft <= 1 And bTop <= 1 Then
					Exit Sub
				End If
				If layoutwidget Then
					'gtk_layout_set_size(gtk_layout(layoutwidget), rLeft, bTop)
					'gtk_widget_set_size_request(layoutwidget, Max(0, rLeft), Max(0, tTop))
				ElseIf fixedwidget Then
					gtk_widget_set_size_request(fixedwidget, Max(0, rLeft), Max(0, tTop))
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
			For i = 0 To ControlCount -1
				'If Controls[i]->Handle = 0 Then Continue For
				Select Case Controls[i]->Align
				Case 1'alLeft
					LeftCount += 1
					ListLeft = Reallocate_(ListLeft,SizeOf(Control)*LeftCount)
					ListLeft[LeftCount -1] = Controls[i]
				Case 2'alRight
					RightCount += 1
					ListRight = Reallocate_(ListRight,SizeOf(Control)*RightCount)
					ListRight[RightCount -1] = Controls[i]
				Case 3'alTop
					TopCount += 1
					ListTop = Reallocate_(ListTop,SizeOf(Control)*TopCount)
					ListTop[TopCount -1] = Controls[i]
				Case 4'alBottom
					BottomCount += 1
					ListBottom = Reallocate_(ListBottom,SizeOf(Control)*BottomCount)
					ListBottom[BottomCount -1] = Controls[i]
				Case 5'alClient
					ClientCount += 1
					ListClient = Reallocate_(ListClient,SizeOf(Control)*ClientCount)
					ListClient[ClientCount -1] = Controls[i]
				Case Else
					With *Controls[i]
						If Cast(Integer, .Anchor.Left) + Cast(Integer, .Anchor.Right) + Cast(Integer, .Anchor.Top) + Cast(Integer, .Anchor.Bottom) <> 0 Then
							#ifdef __USE_GTK__
								If CInt(.FVisible) Then
							#else
								If CInt(.FVisible) AndAlso CInt(.FHandle) Then
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
								.SetBounds(aLeft, aTop, aWidth, aHeight)
							End If
						End If
					End With
				End Select
				'                Select Case Controls[i]->Align
				'						Case 0 'None
				'							gtk_widget_set_halign(Controls[i]->widget, GTK_ALIGN_BASELINE)
				'							gtk_widget_set_valign(Controls[i]->widget, GTK_ALIGN_BASELINE)
				'						Case 1 'Left
				'							gtk_widget_set_halign(Controls[i]->widget, GTK_ALIGN_START)
				'							gtk_widget_set_valign(Controls[i]->widget, GTK_ALIGN_FILL)
				'						Case 2 'Right
				'							gtk_widget_set_halign(Controls[i]->widget, GTK_ALIGN_END)
				'							gtk_widget_set_valign(Controls[i]->widget, GTK_ALIGN_FILL)
				'						Case 3 'Top
				'							gtk_widget_set_halign(Controls[i]->widget, GTK_ALIGN_FILL)
				'							gtk_widget_set_valign(Controls[i]->widget, GTK_ALIGN_START)
				'						Case 4 'Bottom
				'							gtk_widget_set_halign(Controls[i]->widget, GTK_ALIGN_FILL)
				'							gtk_widget_set_valign(Controls[i]->widget, GTK_ALIGN_END)
				'						Case 5 'Client
				'							gtk_widget_set_halign(Controls[i]->widget, GTK_ALIGN_FILL)
				'							gtk_widget_set_valign(Controls[i]->widget, GTK_ALIGN_FILL)
				'						End Select
				
			Next i
			'#IfDef __USE_GTK__
			'#Else
			'?ClassName, rLeft, bTop
			For i = 0 To TopCount -1
				With *ListTop[i]
					If .FVisible Then
						tTop += .Height
						.SetBounds(0,tTop - .Height,rLeft,.Height)
					End If
				End With
			Next i
			'bTop = ClientHeight
			For i = 0 To BottomCount -1
				With *ListBottom[i]
					If .FVisible Then
						bTop -= .Height
						.SetBounds(0,bTop,rLeft,.Height)
					End If
				End With
			Next i
			'lLeft = 0
			For i = 0 To LeftCount -1
				With *ListLeft[i]
					If .FVisible Then
						lLeft += .Width
						.SetBounds(lLeft - .Width, tTop, .Width, bTop - tTop)
					End If
				End With
			Next i
			'rLeft = ClientWidth
			For i = 0 To RightCount -1
				With *ListRight[i]
					If .FVisible Then
						rLeft -= .Width
						.SetBounds(rLeft, tTop, .Width, bTop - tTop)
					End If
				End With
			Next i
			For i = 0 To ClientCount -1
				With *ListClient[i]
					If .FVisible Then
						.SetBounds(lLeft,tTop,rLeft - lLeft,bTop - tTop)
					End If
				End With
			Next i
			'#EndIf
			If ListLeft   Then Deallocate_( ListLeft)
			If ListRight  Then Deallocate_( ListRight)
			If ListTop    Then Deallocate_( ListTop)
			If ListBottom Then Deallocate_( ListBottom)
			If ListClient Then Deallocate_( ListClient)
			'This.UpdateUnLock
		End Sub
		
		#ifndef __USE_GTK__
			Sub Control.ClientToScreen(ByRef P As Point) '...'
				If Handle Then .ClientToScreen Handle,@P
			End Sub
			
			Sub Control.ScreenToClient(ByRef P As Point) '...'
				If Handle Then .ScreenToClient Handle,@P
			End Sub
		#endif
		
		Sub Control.Invalidate
			#ifndef __USE_GTK__
				If Handle Then InvalidateRect Handle, 0, True
			#endif
		End Sub
		
		Sub Control.Repaint
			#ifndef __USE_GTK__
				If Handle Then
					RedrawWindow Handle,0,0,RDW_ERASE Or RDW_INVALIDATE
					Update
				End If
			#endif
		End Sub
		
		Sub Control.Update
			#ifdef __USE_GTK__
				If widget Then gtk_widget_queue_draw(widget)
			#else
				If Handle Then UpdateWindow Handle
			#endif
		End Sub
		
		Sub Control.UpdateLock
			#ifndef __USE_GTK__
				If FHandle Then LockWindowUpdate FHandle
			#endif
		End Sub
		
		Sub Control.UpdateUnLock
			#ifndef __USE_GTK__
				If FHandle Then LockWindowUpdate 0
			#endif
		End Sub
		
		Sub Control.SetFocus
			#ifdef __USE_GTK__
				If widget Then gtk_widget_grab_focus(widget)
			#else
				If Handle Then .SetFocus Handle
			#endif
		End Sub
		
		Sub Control.BringToFront
			#ifndef __USE_GTK__
				If Handle Then SetWindowPos Handle, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE 'BringWindowToTop Handle
			#endif
		End Sub
		
		Sub Control.SendToBack
			#ifndef __USE_GTK__
				If Handle Then SetWindowPos Handle, HWND_BOTTOM, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE
			#endif
		End Sub
		
		Sub Control.AllocateHint
			#ifndef __USE_GTK__
				If Handle Then
					ToolTipHandle = CreateWindowEx(0, TOOLTIPS_CLASS, "", TTS_ALWAYSTIP Or WS_POPUP, 0, 0, 0, 0, FHandle, NULL, GetModuleHandle(NULL), NULL)
					FToolInfo.cbSize=SizeOf(TOOLINFO)
					FToolInfo.uFlags   = TTF_IDISHWND Or TTF_SUBCLASS
					SendMessage(ToolTipHandle, TTM_SETDELAYTIME, TTDT_INITIAL, 100)
					If FParent Then FToolInfo.hwnd = FParent->Handle
					FToolInfo.hinst    = GetModuleHandle(NULL)
					FToolInfo.uId      = Cast(Integer, Handle)
					FToolInfo.lpszText = FHint.vptr
					SendMessage(ToolTipHandle, TTM_ADDTOOL, 0, CInt(@FToolInfo))
				End If
			#endif
		End Sub
		
		Sub Control.Add(Ctrl As Control Ptr)
			If Ctrl Then
				Dim As Control Ptr FSaveParent = Ctrl->Parent
				Ctrl->FParent = @This
				FControlCount += 1
				Controls = Reallocate_(Controls, SizeOf(Control)*FControlCount)
				Controls[FControlCount -1] = Ctrl
				If FTabIndex = -1 Then Ctrl->ChangeTabIndex -1
				#ifdef __USE_GTK__
					Dim As Integer FrameTop
					If widget AndAlso gtk_is_frame(widget) Then FrameTop = 20
					Dim As GtkWidget Ptr Ctrlwidget = IIf(Ctrl->scrolledwidget, Ctrl->scrolledwidget, Ctrl->widget)
					If layoutwidget Then
						If gtk_widget_get_parent(Ctrlwidget) <> 0 Then gtk_widget_unparent(Ctrlwidget)
						gtk_layout_put(GTK_LAYOUT(layoutwidget), Ctrlwidget, Ctrl->FLeft, Ctrl->FTop - FrameTop)
					ElseIf fixedwidget Then
						If gtk_widget_get_parent(Ctrlwidget) <> 0 Then gtk_widget_unparent(Ctrlwidget)
						gtk_fixed_put(GTK_FIXED(fixedwidget), Ctrlwidget, Ctrl->FLeft, Ctrl->FTop - FrameTop)
					End If
					Ctrl->FAnchoredParentWidth = This.FWidth
					Ctrl->FAnchoredParentHeight = This.FHeight
					Ctrl->FAnchoredLeft = Ctrl->FLeft
					Ctrl->FAnchoredTop = Ctrl->FTop
					Ctrl->FAnchoredRight = Ctrl->FAnchoredParentWidth - Ctrl->FWidth - Ctrl->FLeft
					Ctrl->FAnchoredBottom = Ctrl->FAnchoredParentHeight - Ctrl->FHeight - Ctrl->FTop
				#else
					If Ctrl->Handle Then
						If Handle Then
							SetParent Ctrl->Handle, Handle
							Ctrl->FAnchoredParentWidth = This.Width
							Ctrl->FAnchoredParentHeight = This.Height
							Ctrl->FAnchoredLeft = Ctrl->FLeft
							Ctrl->FAnchoredTop = Ctrl->FTop
							Ctrl->FAnchoredRight = Ctrl->FAnchoredParentWidth - Ctrl->FWidth - Ctrl->FLeft
							Ctrl->FAnchoredBottom = Ctrl->FAnchoredParentHeight - Ctrl->FHeight - Ctrl->FTop
						End If
					ElseIf Handle Then
						'#IFDEF __AUTOMATE_CREATE_CHILDS__
						Ctrl->CreateWnd
						'#ENDIF
					End If
				#endif
				RequestAlign
				If FSaveParent Then
					If FSaveParent <> @This Then
						FSaveParent->Remove Ctrl
						FSaveParent->RequestAlign
					End If
				End If
			End If
		End Sub
		
		#if Not defined(__FB_64BIT__) And Not defined(__FB_GCC__)
			Sub Control.AddRange cdecl(CountArgs As Integer, ...)
				Dim value As Any Ptr
				value = va_first()
				For i As Integer = 1 To CountArgs
					Add(va_arg(value, Control Ptr))
					value = va_next(value, Long)
				Next
			End Sub
		#endif
		
		Sub Control.Remove(Ctrl As Control Ptr)
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
					Controls = Reallocate_(Controls,FControlCount*SizeOf(Control))
				End If
				'DeAllocate P
			End If
		End Sub
		
		Function Control.IndexOf(Ctrl As Control Ptr) As Integer
			Dim As Integer i
			For i = 0 To ControlCount -1
				If Controls[i] = Ctrl Then Return i
			Next i
			Return -1
		End Function
		
		Function Control.IndexOf(CtrlName As String) As Integer
			Dim As Integer i
			For i = 0 To ControlCount -1
				If Controls[i]->Name = CtrlName Then Return i
			Next i
			Return -1
		End Function
		
		Function Control.ControlByName(CtrlName As String) As Control Ptr
			Dim i As Integer = IndexOf(CtrlName)
			If i <> -1 Then
				Return Controls[i]
			Else
				Return 0
			End If
		End Function
		
		Operator Control.Cast As Any Ptr '...'
			Return @This
		End Operator
		
		Operator Control.Let(ByRef Value As Control Ptr)
			If Value Then
				This = *Cast(Control Ptr,Value)
			End If
		End Operator
		
		Constructor Control
			WLet(FClassName, "Control")
			WLet(FClassAncestor, "")
			Text = ""
			FLeft = 0
			FTop = 0
			FWidth = 0
			FHeight = 0
			FBackColor = -1
			FTabIndex = -2
			FShowHint = True
			FVisible = True
			FEnabled = True
			'FHint = CAllocate(0)
		End Constructor
		
		Destructor Control
			FreeWnd
			'If FText Then Deallocate FText
			'If FHint Then Deallocate FHint
			'			Dim As Integer i
			'			For i = 0 To ControlCount -1
			'			    If Controls[i] Then Controls[i]->Free
			'			Next i
			If Controls Then Deallocate_( Controls)
			FPopupMenuItems.Clear
		End Destructor
	#endif
End Namespace

#ifdef __EXPORT_PROCS__
	Function Q_Control Alias "QControl"(Ctrl As Any Ptr) As My.Sys.Forms.Control Ptr __EXPORT__
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
#endif
