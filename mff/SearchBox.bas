'################################################################################
'#  SearchBox.bas                                                               #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2024)                                          #
'################################################################################

#include once "SearchBox.bi"

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function SearchBox.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "tabindex": Return @FTabIndex
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function SearchBox.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "tabindex": TabIndex = QInteger(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Property SearchBox.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property SearchBox.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property SearchBox.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property SearchBox.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	#ifdef __USE_WINAPI__
		Private Sub SearchBox.WndProc(ByRef message As Message)
		End Sub
		
		Private Sub SearchBox.MoveIcons
			Dim rcClient As Rect
			GetClientRect(FHandle, @rcClient)
			imgSearch.SetBounds 1, Fix(UnScaleY(rcClient.Bottom) - 16) / 2, 16, 17
			imgClear.SetBounds UnScaleY(rcClient.Right) - 16, (UnScaleY(rcClient.Bottom) - 16) / 2, 16, 16
		End Sub
	#endif
	
	Private Sub SearchBox.ProcessMessage(ByRef message As Message)
		#ifdef __USE_WINAPI__
			Select Case message.Msg
			Case WM_SIZE
				MoveIcons
			Case CM_COMMAND
				Select Case message.wParamHi
				Case EN_CHANGE
					imgClear.Visible = Text <> ""
				End Select
			End Select
		#endif
		Base.ProcessMessage(message)
	End Sub
	
	#ifdef __USE_WINAPI__
		Sub SearchBox.imgSearch_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
			Dim hPen As HPEN
			Dim As ..Rect R
			GetClientRect Sender.Handle, @R
			FillRect(Canvas.Handle, @R, Brush.Handle)
			Dim As HBRUSH PrevBrush = SelectObject(Canvas.Handle, GetStockObject(NULL_BRUSH))
			If FDarkMode Then
				hPen = CreatePen(PS_SOLID, 2, BGR(61, 61, 118))
			Else
				hPen = CreatePen(PS_SOLID, 2, BGR(171, 171, 227))
			End If
			SelectObject(Canvas.Handle, hPen)
			Ellipse(Canvas.Handle, 0, 1, ScaleX(13), ScaleY(14))
			DeleteObject(hPen)
			If FDarkMode Then
				hPen = CreatePen(PS_SOLID, 1, BGR(89, 94, 95))
			Else
				hPen = CreatePen(PS_SOLID, 1, BGR(95, 95, 95))
			End If
			SelectObject(Canvas.Handle, hPen)
			Ellipse(Canvas.Handle, 0, 1, ScaleX(13), ScaleY(14))
			DeleteObject(hPen)
			If FDarkMode Then
				hPen = CreatePen(PS_SOLID, 2, BGR(89, 94, 95))
			Else
				hPen = CreatePen(PS_SOLID, 2, BGR(95, 95, 95))
			End If
			SelectObject(Canvas.Handle, hPen)
			MoveToEx(Canvas.Handle, ScaleX(10), ScaleY(11), NULL)
			LineTo(Canvas.Handle, ScaleX(16), ScaleY(17))
			MoveToEx(Canvas.Handle, ScaleX(10), ScaleY(11), NULL)
			LineTo(Canvas.Handle, ScaleX(16), ScaleY(17))
			SelectObject(Canvas.Handle, PrevBrush)
			DeleteObject(hPen)
		End Sub
		
		Sub SearchBox.imgClear_Paint(ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas)
			Dim hPen As HPEN
			Dim As ..Rect R
			GetClientRect Sender.Handle, @R
			FillRect(Canvas.Handle, @R, Brush.Handle)
			If FDarkMode Then
				hPen = CreatePen(PS_SOLID, 2, BGR(89, 94, 95))
			Else
				hPen = CreatePen(PS_SOLID, 2, BGR(95, 95, 95))
			End If
			SelectObject(Canvas.Handle, hPen)
			MoveToEx(Canvas.Handle, ScaleX(4), ScaleY(4), NULL)
			LineTo(Canvas.Handle, ScaleX(12), ScaleY(12))
			MoveToEx(Canvas.Handle, ScaleX(12), ScaleY(4), NULL)
			LineTo(Canvas.Handle, ScaleX(4), ScaleY(12))
			DeleteObject(hPen)
		End Sub
		
		Sub SearchBox.imgClear_Click(ByRef Sender As Control)
			Text = ""
		End Sub
		
		Private Sub SearchBox.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QSearchBox(Sender.Child)
					#ifdef __USE_WASM__
						If .OnChange Then SetChangeEvent(.FHandle)
					#elseif defined(__USE_WINAPI__)
						If .FMaxLength = 0 Then
							.Perform(EM_LIMITTEXT, -1, 0)
						Else
							.Perform(EM_LIMITTEXT, .FMaxLength, 0)
						End If
						If .ReadOnly Then .Perform(EM_SETREADONLY, True, 0)
						If .FMasked Then .Masked = True
						If .FSelStart <> 0 OrElse .FSelEnd <> 0 Then .SetSel .FSelStart, .FSelEnd
						If .FLeftMargin <> 0 Then
							SendMessage(.FHandle, EM_SETMARGINS, EC_LEFTMARGIN, MAKELPARAM(.ScaleX(.FLeftMargin), .ScaleX(.FRightMargin)))
						End If
						If .FRightMargin <> 0 Then
							SendMessage(.FHandle, EM_SETMARGINS, EC_RIGHTMARGIN, MAKELPARAM(.ScaleX(.FLeftMargin), .ScaleX(.FRightMargin)))
						End If
						.MoveIcons
					#endif
				End With
			End If
		End Sub
	#endif
	
	Private Operator SearchBox.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Constructor SearchBox
		With This
			#ifdef __USE_GTK__
				#ifdef __USE_GTK2__
					WidgetEntry = gtk_entry_new()
				#else
					WidgetEntry = gtk_search_entry_new()
				#endif
				WidgetTextView = gtk_text_view_new()
				gtk_entry_set_activates_default(GTK_ENTRY(WidgetEntry), True)
				gtk_entry_set_width_chars(GTK_ENTRY(WidgetEntry), 0)
				g_signal_connect(GTK_ENTRY(WidgetEntry), "activate", G_CALLBACK(@Entry_Activate), @This)
				g_signal_connect(GTK_ENTRY(WidgetEntry), "changed", G_CALLBACK(@Entry_Changed), @This)
				g_signal_connect(GTK_WIDGET(WidgetEntry), "focus-in-event", G_CALLBACK(@Entry_FocusInEvent), @This)
				g_signal_connect(GTK_WIDGET(WidgetEntry), "focus-out-event", G_CALLBACK(@Entry_FocusOutEvent), @This)
				g_signal_connect(GTK_WIDGET(WidgetEntry), "copy-clipboard", G_CALLBACK(@Entry_CopyClipboard), @This)
				g_signal_connect(GTK_WIDGET(WidgetEntry), "cut-clipboard", G_CALLBACK(@Entry_CutClipboard), @This)
				g_signal_connect(GTK_WIDGET(WidgetEntry), "paste-clipboard", G_CALLBACK(@Entry_PasteClipboard), @This)
				g_signal_connect(GTK_WIDGET(WidgetTextView), "copy-clipboard", G_CALLBACK(@Entry_CopyClipboard), @This)
				g_signal_connect(GTK_WIDGET(WidgetTextView), "cut-clipboard", G_CALLBACK(@Entry_CutClipboard), @This)
				g_signal_connect(GTK_WIDGET(WidgetTextView), "paste-clipboard", G_CALLBACK(@Entry_PasteClipboard), @This)
				#ifdef __USE_GTK3__
					g_signal_connect(gtk_scrollable_get_hadjustment(GTK_SCROLLABLE(WidgetTextView)), "value-changed", G_CALLBACK(@Adjustment_ValueChanged), @This)
					g_signal_connect(gtk_scrollable_get_vadjustment(GTK_SCROLLABLE(WidgetTextView)), "value-changed", G_CALLBACK(@Adjustment_ValueChanged), @This)
				#else
					g_signal_connect(GTK_WIDGET(WidgetTextView), "set-scroll-adjustments", G_CALLBACK(@TextView_SetScrollAdjustments), @This)
				#endif
				g_signal_connect(GTK_TEXT_VIEW(WidgetTextView), "preedit-changed", G_CALLBACK(@Preedit_Changed), @This)
				g_signal_connect(GTK_ENTRY(WidgetEntry), "preedit-changed", G_CALLBACK(@Preedit_Changed), @This)
				g_signal_connect(gtk_text_view_get_buffer(GTK_TEXT_VIEW(WidgetTextView)), "changed", G_CALLBACK(@TextBuffer_Changed), @This)
				#ifndef __USE_GTK3__
					g_signal_connect(GTK_EDITABLE(WidgetEntry), "insert-text", G_CALLBACK(@Entry_InsertText), @This)
				#endif
				WidgetScrolledWindow = gtk_scrolled_window_new(NULL, NULL)
				gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(WidgetScrolledWindow), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
				gtk_scrolled_window_set_shadow_type(GTK_SCROLLED_WINDOW(WidgetScrolledWindow), GTK_SHADOW_OUT)
				gtk_container_add(GTK_CONTAINER(WidgetScrolledWindow), WidgetTextView)
				scrolledwidget = WidgetScrolledWindow
				widget = WidgetTextView
				This.RegisterClass "SearchBox", @This
				scrolledwidget = 0
				widget = WidgetEntry
				This.RegisterClass "SearchBox", @This
			#else
				RegisterClass "SearchBox", "Edit"
				OnHandleIsAllocated = @HandleIsAllocated
				ChildProc = @WndProc
				WLet(FClassAncestor, "Edit")
				FLeftMargin = 20
				FRightMargin = 20
				imgSearch.DoubleBuffered = True
				imgSearch.Designer = @This
				imgSearch.OnPaint = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas), @imgSearch_Paint)
				imgSearch.Parent = @This
				imgClear.DoubleBuffered = True
				imgClear.Designer = @This
				imgClear.OnPaint = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control, ByRef Canvas As My.Sys.Drawing.Canvas), @imgClear_Paint)
				imgClear.OnClick = Cast(Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Control), @imgClear_Click)
				imgClear.Visible = False
				imgClear.Parent = @This
			#endif
			FHideSelection    = False
			FTabIndex          = -1
			FTabStop           = True
			WLet(FClassName, "SearchBox")
			Child       = @This
			Width       = 121
			Height      = ScaleY(Font.Size / 72 * 96 + 6) '21
		End With
	End Constructor
	
	Private Destructor SearchBox
		#ifdef __USE_WINAPI__
			DestroyWindow FHandle
		#endif
	End Destructor
End Namespace
