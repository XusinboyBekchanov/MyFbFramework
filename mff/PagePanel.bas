'###############################################################################
'#  PagePanel.bas                                                              #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#include once "PagePanel.bi"
'#Include Once "Canvas.bi"

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function PagePanel.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "selectedpanel": Return SelectedPanel
			Case "selectedpanelindex": Return @FSelectedPanelIndex
			Case "tabindex": Return @FTabIndex
			Case "transparent": Return @FTransparent
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function PagePanel.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "designmode": DesignMode = QBoolean(Value)
					If FDesignMode Then 
						#if defined(__USE_GTK__) AndAlso defined(__USE_GTK3__)
							gtk_widget_set_can_focus(UpDownButton.widget, False)
							gtk_overlay_add_overlay(GTK_OVERLAY(overlaywidget), NumericUpDownControl.widget)
							gtk_overlay_add_overlay(GTK_OVERLAY(overlaywidget), UpDownButton.widget)
							g_signal_connect(overlaywidget, "get-child-position", G_CALLBACK(@Overlay_get_child_position), @This)
						#else
							'FDesignMode = False
							'This.Add @StackPanel
							This.Add @NumericUpDownControl
							'FDesignMode = True
							MoveNumericUpDownControl
						#endif
					End If
				Case "selectedpanel": SelectedPanel = Value
				Case "selectedpanelindex": 
					If FDesignMode Then
						NumericUpDownControl.Position = QInteger(Value)
					Else
						SelectedPanelIndex = QInteger(Value)
					End If
				Case "tabindex": TabIndex = QInteger(Value)
				Case "transparent": This.Transparent = QBoolean(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Sub PagePanel.MoveNumericUpDownControl
		NumericUpDownControl.Width = 70
		'NumericUpDownControl.ExtraMargins.Left = (ClientWidth - NumericUpDownControl.Width) / 2
		'NumericUpDownControl.ExtraMargins.Right = NumericUpDownControl.ExtraMargins.Left
		NumericUpDownControl.SetBounds (ClientWidth - NumericUpDownControl.Width) / 2, ClientHeight - NumericUpDownControl.Height, 70, NumericUpDownControl.Height
	End Sub
	
	Private Property PagePanel.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property PagePanel.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property PagePanel.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property PagePanel.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	#ifdef __USE_WINAPI__
		Private Sub PagePanel.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QPagePanel(Sender.Child)
					.MoveNumericUpDownControl
					.RequestAlign
					.SelectedPanelIndex = .FSelectedPanelIndex
					#ifdef __USE_WINAPI__
						If .FDesignMode Then .NumericUpDownControl.BringToFront
					#endif
				End With
			End If
		End Sub
		
		Private Sub PagePanel.WNDPROC(ByRef Message As Message)
		End Sub
	#endif
	
	#ifdef __USE_WASM__
		Private Function PagePanel.GetContent() As UString
			Return ""
		End Function
	#elseif defined(__USE_GTK__) AndAlso defined(__USE_GTK3__)
		Private Function PagePanel.Overlay_get_child_position(self As GtkOverlay Ptr, widget As GtkWidget Ptr, allocation As GdkRectangle Ptr, user_data As Any Ptr) As Boolean
			Dim As PagePanel Ptr pp = user_data
			If GTK_IS_BUTTON(widget) Then
				pp->UpDownButton.Width = 30
				allocation->x = pp->ScaleX((pp->ClientWidth - pp->NumericUpDownControl.Width) / 2 + pp->NumericUpDownControl.Width - 105)
				allocation->y = pp->ScaleY(pp->ClientHeight - 32)
				allocation->width = pp->ScaleX(35)
				allocation->height = pp->ScaleY(30)
			Else
				pp->NumericUpDownControl.Width = 150
				pp->NumericUpDownControl.Height = 34
				allocation->x = pp->ScaleX((pp->ClientWidth - pp->NumericUpDownControl.Width) / 2)
				allocation->y = pp->ScaleY(pp->ClientHeight - pp->NumericUpDownControl.Height)
				allocation->width = pp->ScaleX(pp->NumericUpDownControl.Width)
				allocation->height = pp->ScaleY(pp->NumericUpDownControl.Height)
			End If
			Return True
		End Function
	#endif
	
	Private Sub PagePanel.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_WINAPI__
			Select Case Message.Msg
			Case CM_CTLCOLOR
				Static As HDC Dc
				Dc = Cast(HDC, Message.wParam)
				SetBkMode Dc, Transparent
				SetTextColor Dc, Font.Color
				If Not FTransparent OrElse FDesignMode Then
					SetBkColor Dc, FBackColor
					SetBkMode Dc, OPAQUE
				Else
					Message.Result = Cast(LRESULT, GetStockObject(NULL_BRUSH))
				End If
			Case WM_PAINT, WM_ERASEBKGND
				Dim As HDC Dc, memDC
				Dim As HBITMAP MemBmp
				Dim As PAINTSTRUCT Ps
				Dim As ..Rect R
				GetClientRect Handle, @R
				Dc = BeginPaint(Handle, @Ps)
				If Dc = 0 Then
					EndPaint This.Handle, @Ps
					Message.Result = 0
					Return
				End If
				If g_darkModeSupported AndAlso g_darkModeEnabled Then
					If Not FDarkMode Then SetDark True
				Else
					If FDarkMode Then SetDark False
				End If
				If DoubleBuffered Then
					memDC = CreateCompatibleDC(Dc)
					MemBmp   = CreateCompatibleBitmap(Dc, R.Right - R.Left, R.Bottom - R.Top)
					SelectObject(memDC, MemBmp)
					FillRect memDC, @R, Brush.Handle
					Canvas.SetHandle memDC
				Else
					FillRect Dc, @R, Brush.Handle
					Canvas.SetHandle Dc
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
							Dim As Double PicBoxWidth = ScaleX(.Width) * Graphic.ScaleFactor
							Dim As Double PicBoxHeight = ScaleY(.Height) * Graphic.ScaleFactor
							Dim As Double img_ratio = imgWidth / imgHeight
							Dim As Double PicBox_ratio =  PicBoxWidth / PicBoxHeight
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
				If ShowCaption Then
					Canvas.TextOut(Current.X, Current.Y, FText, Font.Color, FBackColor)
				End If
				If OnPaint Then OnPaint(*Designer, This, Canvas)
				Canvas.UnSetHandle
				If DoubleBuffered Then
					BitBlt(Dc, 0, 0, R.Right - R.left, R.Bottom - R.top, memDC, 0, 0, SRCCOPY)
					DeleteObject(MemBmp)
					DeleteDC(memDC)
				End If
				EndPaint Handle, @Ps
				If FDesignMode AndAlso NeedBringToFront Then NeedBringToFront = False: NumericUpDownControl.BringToFront
				Message.Result = 0
				Return
			Case CM_COMMAND
				If Message.wParamHi = STN_CLICKED Then
					If OnClick Then OnClick(*Designer, This)
				End If
				If Message.wParamHi = STN_DBLCLK Then
					If OnDblClick Then OnDblClick(*Designer, This)
				End If
			Case WM_COMMAND
				If IsWindow(Cast(HWND, Message.lParam)) Then
				Else
					Dim As MenuItem Ptr mi
					For i As Integer = 0 To mnuShowPanel.Count - 1
						mi = mnuShowPanel.Item(i)
						If mi->Command = LoWord(Message.wParam) Then
							If mi->OnClick Then mi->OnClick(This, *mi)
							Exit For
						End If
					Next i
				End If
			Case WM_SIZE
				InvalidateRect(Handle, NULL, True)
				If FDesignMode Then
					MoveNumericUpDownControl
				End If
			Case CM_DRAWITEM
				
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Property PagePanel.SelectedPanel As Control Ptr
		If FSelectedPanelIndex >= 0 AndAlso FSelectedPanelIndex <= FControlCount - 1 Then Return Controls[FSelectedPanelIndex]
		Return 0
	End Property
	
	Private Property PagePanel.SelectedPanel(Value As Control Ptr)
		If IndexOf(Value) > -1 Then
			SelectedPanelIndex = IndexOf(Value)
		End If
	End Property
	
	Private Property PagePanel.SelectedPanelIndex As Integer
		Return FSelectedPanelIndex
	End Property
	
	Private Property PagePanel.SelectedPanelIndex(Value As Integer)
		If Value >= -1 AndAlso Value <= FControlCount - 1 Then
			FSelectedPanelIndex = Value
			#if defined(__USE_GTK__) AndAlso defined(__USE_GTK3__)
				Dim As Boolean bVisible
				If FSelectedPanelIndex = -1 Then
					bVisible = False
				Else
					bVisible = True
					gtk_stack_set_visible_child(GTK_STACK(widget), Controls[FSelectedPanelIndex]->widget)
				End If
				For i As Integer = 0 To FControlCount - 1
					If Controls[i] = @NumericUpDownControl Then Continue For
					Controls[i]->Visible = bVisible
					If FDesignMode Then 
						If scrolledwidget Then
							If bVisible Then
								#ifdef __USE_GTK4__
									gtk_widget_set_visible(scrolledwidget, True)
								#else
									gtk_widget_show_all(scrolledwidget)
								#endif
								If Value Then gtk_widget_queue_draw(scrolledwidget)
							Else
								gtk_widget_set_visible(scrolledwidget, bVisible)
							End If
						ElseIf widget Then
							gtk_widget_set_visible(widget, bVisible)
							If Value Then gtk_widget_queue_draw(widget)
						End If
					End If
				Next
			#else
				Dim j As Integer = -1
				For i As Integer = 0 To FControlCount - 1
					If Controls[i] = @NumericUpDownControl Then Continue For
					j = j + 1
					Dim As Boolean bVisible = (j = FSelectedPanelIndex)
					Controls[i]->Visible = bVisible
					#ifdef __USE_WINAPI__
						If FDesignMode Then ShowWindow(Controls[i]->Handle, IIf(bVisible, SW_SHOW, SW_HIDE))
						If bVisible Then
							SetWindowPos FHandle, IIf(FDesignMode, NumericUpDownControl.Handle, HWND_TOP), 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE
						End If
					#else
						If FDesignMode Then 
							If scrolledwidget Then
								If bVisible Then
									#ifdef __USE_GTK4__
										gtk_widget_set_visible(scrolledwidget, True)
									#else
										gtk_widget_show_all(scrolledwidget)
									#endif
									If Value Then gtk_widget_queue_draw(scrolledwidget)
								Else
									gtk_widget_set_visible(scrolledwidget, bVisible)
								End If
							ElseIf widget Then
								gtk_widget_set_visible(widget, bVisible)
								If Value Then gtk_widget_queue_draw(widget)
							End If
						End If
					#endif
				Next
			#endif
		End If
	End Property
	
	Private Property PagePanel.Transparent As Boolean
		Return FTransparent
	End Property
	
	Private Property PagePanel.Transparent(Value As Boolean)
		FTransparent = Value
	End Property
	
	Private Operator PagePanel.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Sub PagePanel.Add(Ctrl As Control Ptr, Index As Integer = -1)
		Base.Add(Ctrl, Index)
		If FDesignMode Then
			#if defined(__USE_GTK__) AndAlso defined(__USE_GTK3__)
				NumericUpDownControl.MaxValue = Max(-1, ControlCount - 1)
				NumericUpDownControl.Position = ControlCount - 1
			#else
				NumericUpDownControl.MaxValue = Max(-1, ControlCount - 2)
				UpDownControl.Enabled = NumericUpDownControl.MaxValue >= 0
				NeedBringToFront = True
				NumericUpDownControl.ControlIndex = ControlCount - 1
				NumericUpDownControl.Position = ControlCount - 2
			#endif
		End If
	End Sub
	
	Private Sub PagePanel.CreateWnd
		Base.CreateWnd
		#ifdef __USE_JNI__
			layoutview = FHandle
		#endif
	End Sub
	
	Private Sub PagePanel.GraphicChange(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
		With Sender
			If .Ctrl->Child Then
				#ifdef __USE_GTK__
				#else
					.Ctrl->Repaint
				#endif
			End If
		End With
	End Sub
	
	Private Sub PagePanel.NumericUpDownControl_Change(ByRef Sender As NumericUpDown)
		If OnSelChanging Then OnSelChanging(*Designer, This, Val(NumericUpDownControl.Text))
		SelectedPanelIndex = Val(NumericUpDownControl.Text)
		'NumericUpDownControl.BringToFront
		If OnSelChange Then OnSelChange(*Designer, This, FSelectedPanelIndex)
	End Sub
	
	#if defined(__USE_GTK__) AndAlso defined(__USE_GTK3__)
	Private Sub PagePanel.UpDownButton_Click(ByRef Sender As Control)
	#else
	Private Sub PagePanel.UpDownControl_Changing(ByRef Sender As UpDown, Value As Integer, Direction As Integer)
	#endif
		Dim j As Integer = -1
		mnuShowPanel.Clear
		Var mnu = mnuShowPanel.Add(WStr(j) & ": " & Name, "", , Cast(NotifyEvent, @MenuItem_Click))
		mnu->Designer = @This
		For i As Integer = 0 To ControlCount - 1
			If Controls[i] = @NumericUpDownControl Then Continue For
			j = j + 1
			Var mnu = mnuShowPanel.Add(WStr(j) & ": " & Controls[i]->Name, "", , Cast(NotifyEvent, @MenuItem_Click))
			mnu->Designer = @This
		Next
		#if defined(__USE_GTK__) AndAlso defined(__USE_GTK3__)
			Dim p As My.Sys.Drawing.Point = Type(UpDownButton.Left, UpDownButton.Top + UpDownButton.Height)
		#else
			Dim p As My.Sys.Drawing.Point = Type(UpDownPanel.Left, UpDownPanel.Top + UpDownPanel.Height)
		#endif
		NumericUpDownControl.ClientToScreen p
		mnuContext.Popup p.X, p.Y
	End Sub
	
	Private Sub PagePanel.MenuItem_Click(ByRef Sender As MenuItem)
		NumericUpDownControl.Position = mnuShowPanel.IndexOf(@Sender) - 1
	End Sub
	
	Private Constructor PagePanel
		With This
			.Child          = @This
			.Canvas.Ctrl    = @This
			.Graphic.Ctrl   = @This
			.Graphic.OnChange = @GraphicChange
			NumericUpDownControl.Name = "PagePanel_NumericUpDownControl"
			'NumericUpDownControl.Align = DockStyle.alBottom
			#ifdef __USE_GTK__
				NumericUpDownControl.Width = 100
			#else
				NumericUpDownControl.Width = 70
			#endif
			NumericUpDownControl.Style = udHorizontal
			NumericUpDownControl.MinValue = -1
			NumericUpDownControl.Position = -1
			NumericUpDownControl.UpDownWidth = 28
			NumericUpDownControl.Designer = @This
			NumericUpDownControl.OnChange = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As NumericUpDown), @NumericUpDownControl_Change)
			#if defined(__USE_GTK__) AndAlso defined(__USE_GTK3__)
				UpDownButton.Caption = "V"
				UpDownButton.Designer = @This
				UpDownButton.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @UpDownButton_Click)
			#else
				UpDownPanel.SetBounds(NumericUpDownControl.Width - NumericUpDownControl.Height - NumericUpDownControl.UpDownWidth + 2, 0, NumericUpDownControl.Height - 4, NumericUpDownControl.Height)
				UpDownPanel.Parent = @NumericUpDownControl
				UpDownControl.SetBounds(UnScaleX(-1), -NumericUpDownControl.Height + 3, UpDownPanel.Width + 2, NumericUpDownControl.Height * 2 - 6)
				UpDownControl.Designer = @This
				UpDownControl.OnChanging = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As UpDown, Value As Integer, Direction As Integer), @UpDownControl_Changing)
				UpDownControl.Parent = @UpDownPanel
			#endif
			mnuShowPanel.Caption = "Show Panel"
			mnuContext.ParentWindow = @This
			mnuContext.Add @mnuShowPanel
			#ifdef __USE_WINAPI__
				.RegisterClass "PagePanel"
				.ChildProc   = @WNDPROC
				.ExStyle     = 0
				.Style       = WS_CHILD
				.BackColor       = GetSysColor(COLOR_BTNFACE)
				FDefaultBackColor = GetSysColor(COLOR_BTNFACE)
				.OnHandleIsAllocated = @HandleIsAllocated
			#elseif defined(__USE_JNI__)
				WLet(FClassAncestor, "android/widget/AbsoluteLayout")
			#elseif defined(__USE_WASM__)
				WLet(FClassAncestor, "div")
			#elseif defined(__USE_GTK__)
				#ifdef __USE_GTK3__
					widget = gtk_stack_new()
					overlaywidget = gtk_overlay_new()
					gtk_container_add(GTK_CONTAINER(overlaywidget), widget)
				#else
					widget = gtk_layout_new(NULL, NULL)
				#endif
				.RegisterClass "PagePanel", @This
			#endif
			FTabIndex          = -1
			WLet(FClassName, "PagePanel")
			.Width       = 121
			.Height      = 41
			.ShowCaption = False
			MoveNumericUpDownControl
		End With
	End Constructor
	
	Private Destructor PagePanel
		#ifdef __USE_WINAPI__
			UnregisterClass "PagePanel", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace


