'###############################################################################
'#  NumericUpDown.bi                                                                  #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TUpDown.bi                                                                #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "NumericUpDown.bi"
'Const UDN_DELTAPOS = (UDN_FIRST - 1)

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function NumericUpDown.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "arrowkeys": FBooleanTemp = UpDownControl.ArrowKeys: Return @FBooleanTemp
			Case "decimalplaces": Return @FDecimalPlaces
			Case "increment": FDoubleTemp = UpDownControl.Increment: Return @FDoubleTemp
			Case "maxvalue": FIntegerTemp = UpDownControl.MaxValue: Return @FIntegerTemp
			Case "minvalue": FIntegerTemp = UpDownControl.MinValue: Return @FIntegerTemp
			Case "position": FDoubleTemp = UpDownControl.Position: Return @FDoubleTemp
			Case "style": Return @FStyle
			Case "tabindex": Return @FTabIndex
			Case "text": Text: Return @FText
			Case "thousands": FBooleanTemp = UpDownControl.Thousands: Return @FBooleanTemp
			Case "updownwidth": FIntegerTemp = UpDownControl.Width: Return @FIntegerTemp
			Case "wrap": FBooleanTemp = UpDownControl.Wrap: Return @FBooleanTemp
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function NumericUpDown.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "arrowkeys": ArrowKeys = QBoolean(Value)
				Case "decimalplaces": DecimalPlaces = QInteger(Value)
				Case "increment": Increment = QDouble(Value)
				Case "maxvalue": MaxValue = QInteger(Value)
				Case "minvalue": MinValue = QInteger(Value)
				Case "position": Position  = QDouble(Value)
				Case "style": Style = *Cast(UpDownOrientation Ptr, Value)
				Case "tabindex": TabIndex = QInteger(Value)
				Case "text": Text = QWString(Value)
				Case "thousands": Thousands = QBoolean(Value)
				Case "updownwidth": UpDownWidth = QInteger(Value)
				Case "wrap": Wrap = QBoolean(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Property NumericUpDown.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property NumericUpDown.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property NumericUpDown.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property NumericUpDown.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Property NumericUpDown.MinValue As Double
		If FDecimalPlaces > 0 Then Return UpDownControl.MinValue / FScaleFactor Else Return UpDownControl.MinValue
	End Property
	
	Private Property NumericUpDown.MinValue(Value As Double)
		UpDownControl.MinValue = IIf(FDecimalPlaces > 0,  Value * FScaleFactor, Value)
	End Property
	
	Private Property NumericUpDown.MaxValue As Double
		If FDecimalPlaces > 0 Then Return UpDownControl.MaxValue / FScaleFactor Else Return UpDownControl.MaxValue
	End Property
	
	Private Property NumericUpDown.MaxValue(Value As Double)
		UpDownControl.MaxValue = IIf(FDecimalPlaces > 0,  Value * FScaleFactor, Value)
	End Property
	
	Private Property NumericUpDown.Position As Double
		If FDecimalPlaces > 0 Then Return UpDownControl.Position / FScaleFactor Else Return UpDownControl.Position
	End Property
	
	Private Property NumericUpDown.Position(Value As Double)
		UpDownControl.Position = IIf(FDecimalPlaces > 0,  Value * FScaleFactor, Value)
	End Property
	
	Private Property NumericUpDown.Increment As Double
		If FDecimalPlaces > 0 Then Return UpDownControl.Increment / FScaleFactor Else Return UpDownControl.Increment
	End Property
	
	Private Property NumericUpDown.Increment(Value As Double)
		UpDownControl.Increment = IIf(FDecimalPlaces > 0,  Value * FScaleFactor, Value)
	End Property
	
	Private Property NumericUpDown.DecimalPlaces As Integer
		Return FDecimalPlaces
	End Property
	
	Private Property NumericUpDown.DecimalPlaces(Value As Integer)
		FDecimalPlaces = Value
		FScaleFactor = Val(Mid("1000000", 1, FDecimalPlaces + 1))
		'If FDecimalPlaces > 1 Then UpDownControl.Increment = FScaleFactor / Val(Mid("1000000", 1, FDecimalPlaces))
	End Property
	Private Property NumericUpDown.Text ByRef As WString
		#ifdef __USE_GTK__
			FText = UpDownControl.Text
		#else
			FText = IIf(FDecimalPlaces > 0,  WStr(Val(Base.Text) / FScaleFactor), Base.Text)
		#endif
		Return FText
	End Property
	
	Private Property NumericUpDown.Text(ByRef Value As WString)
		Dim As Integer DotPos = InStr(Value, ".")
		If DotPos > 0 Then
			FDecimalPlaces = Len(Value) - DotPos
			FScaleFactor = Val(Mid("1000000", 1, FDecimalPlaces))
		Else
			FDecimalPlaces = 0: FScaleFactor = 1
		End If
		If UpDownControl.Text <> Value Then
			UpDownControl.Text = IIf(FDecimalPlaces > 0, WStr(Val(Value) * FScaleFactor), Value)
		End If
		Base.Text = IIf(FDecimalPlaces > 0, WStr(Val(Value) / FScaleFactor), Value)
	End Property
	
	Private Property NumericUpDown.Thousands As Boolean
		Return UpDownControl.Thousands
	End Property
	
	Private Property NumericUpDown.Thousands(Value As Boolean)
		UpDownControl.Thousands = Value
	End Property
	
	Private Property NumericUpDown.ArrowKeys As Boolean
		Return UpDownControl.ArrowKeys
	End Property
	
	Private Property NumericUpDown.ArrowKeys(Value As Boolean)
		UpDownControl.ArrowKeys = Value
	End Property
	
	Private Property NumericUpDown.Wrap As Boolean
		Return UpDownControl.Wrap
	End Property
	
	Private Property NumericUpDown.Wrap(Value As Boolean)
		UpDownControl.Wrap = Value
	End Property
	
	Private Property NumericUpDown.Style As UpDownOrientation
		Return FStyle
	End Property
	
	Private Property NumericUpDown.Style(Value As UpDownOrientation)
		FStyle = Value
		UpDownControl.Associate = 0
		UpDownControl.Style = FStyle
		UpDownControl.Associate = @This
		#ifdef __USE_WINAPI__
			MoveUpDownControl
		#endif
	End Property
	
	Private Property NumericUpDown.UpDownWidth As Integer
		Return UpDownControl.Width
	End Property
	
	Private Property NumericUpDown.UpDownWidth(Value As Integer)
		UpDownControl.Width = Value
		MoveUpDownControl
	End Property
	
	Private Sub NumericUpDown.SelectAll
		#ifdef __USE_GTK__
			'If GTK_IS_EDITABLE(widget) Then
			'	gtk_editable_select_region(GTK_EDITABLE(widget), 0, -1)
			'Else
			'	Dim As GtkTextIter _start, _end
			'	gtk_text_buffer_get_iter_at_offset(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, 0)
			'	gtk_text_buffer_get_iter_at_offset(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_end, gtk_text_buffer_get_char_count(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget))))
			'	gtk_text_buffer_select_range(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, @_end)
			'End If
		#elseif defined(__USE_WINAPI__)
			If FHandle Then Perform(EM_SETSEL, 0, -1)
		#endif
	End Sub
	
	#ifndef __USE_GTK__
		Function NumericUpDown.HookChildProc(hDlg As HWND, uMsg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			Dim As NumericUpDown Ptr nud = GetProp(hDlg, "MFFControl")
			If nud Then
				Dim Message As Message
				Message = Type(nud, hDlg, uMsg, wParam, lParam, 0, LoWord(wParam), HiWord(wParam), LoWord(lParam), HiWord(lParam), Message.Captured)
				nud->UpDownControl.ProcessMessage(Message)
				If Message.Handled Then
					Return Message.Result
				ElseIf Message.Result = -1 Then
					Return Message.Result
				ElseIf Message.Result = -2 Then
					uMsg = Message.Msg
					wParam = Message.wParam
					lParam = Message.lParam
				ElseIf Message.Result <> 0 Then
					Return Message.Result
				End If
			End If
			Return CallWindowProc(GetProp(hDlg, "@@@@Proc"), hDlg, uMsg, wParam, lParam)
		End Function
	
		Private Sub NumericUpDown.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QNumericUpDown(Sender.Child)
					.FHandleIsAllocated = True
					MoveWindow .FHandle, .ScaleX(.FLeft), .ScaleY(.FTop), .ScaleX(.FWidth), .ScaleY(.FHeight), True
					'MoveWindow .UpDownControl.Handle, ScaleX(.Width - .UpDownControl.Width - 2) - 1, -1, ScaleX(.UpDownControl.Width), ScaleY(.Height) - 2, True
					.MoveUpDownControl
					'SendMessage(.FHandle, EM_SETMARGINS, EC_RIGHTMARGIN Or EC_LEFTMARGIN, MAKEWORD(ScaleX(0), ScaleX(.UpDownControl.Width)))
					Dim h As HWND = .UpDownControl.Handle
					If GetWindowLongPtr(h, GWLP_WNDPROC) <> @HookChildProc Then
						SetProp(h, "MFFControl", .Child)
						SetProp(h, "@@@@Proc", Cast(..WNDPROC, SetWindowLongPtr(h, GWLP_WNDPROC, CInt(@HookChildProc))))
					End If
				End With
			End If
		End Sub
		
		Private Sub NumericUpDown.WndProc(ByRef Message As Message)
		End Sub
	#elseif defined(__USE_GTK__)
		Private Sub NumericUpDown.SpinButton_ValueChanged(self As GtkSpinButton Ptr, user_data As Any Ptr)
			Dim As NumericUpDown Ptr nud = user_data
			If nud->OnChange Then nud->OnChange(*nud->Designer, *nud)
		End Sub
	#endif
	
	Private Sub NumericUpDown.MoveUpDownControl
		#ifdef __USE_WINAPI__
			If Not FHandleIsAllocated Then Exit Sub
			MoveWindow UpDownControl.Handle, ScaleX(Width - UpDownControl.Width) - 3, 0, ScaleX(UpDownControl.Width), ScaleY(Height) - 3, True
		#endif
	End Sub
	
	Private Sub NumericUpDown.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_WINAPI__
			Select Case Message.Msg
			Case WM_SIZE
				With This
					MoveUpDownControl
				End With
			Case WM_PAINT, WM_MOUSELEAVE, WM_MOUSEMOVE
				If g_darkModeSupported AndAlso g_darkModeEnabled AndAlso (CBool(Message.Msg <> WM_MOUSEMOVE) OrElse (CBool(Message.Msg = WM_MOUSEMOVE) AndAlso FMouseInClient)) Then
					If Not FDarkMode Then
						FDarkMode = True
						Brush.Handle = hbrBkgnd
						SetWindowTheme(FHandle, "DarkMode_Explorer", nullptr)
						SendMessageW(FHandle, WM_THEMECHANGED, 0, 0)
						Repaint
					End If
					Dim As Any Ptr cp = GetClassProc(Message.hWnd)
					If cp <> 0 Then
						Message.Result = CallWindowProc(cp, Message.hWnd, Message.Msg, Message.wParam, Message.lParam)
					End If
					Dim As HDC Dc
					Dc = GetWindowDC(Handle)
					Dim As Rect r = Type( 0 )
					GetWindowRect(Message.hWnd, @r)
					r.Right -= r.Left + 1
					r.Bottom -= r.Top + 1
					r.Left = 1
					r.Top = 1
					Dim As HPEN NewPen = CreatePen(PS_SOLID, 1, darkBkColor)
					Dim As HPEN PrevPen = SelectObject(Dc, NewPen)
					Dim As HPEN PrevBrush = SelectObject(Dc, GetStockObject(NULL_BRUSH))
					Rectangle Dc, r.Left, r.Top, r.Right, r.Bottom
					SelectObject(Dc, PrevPen)
					SelectObject(Dc, PrevBrush)
					ReleaseDC(Handle, Dc)
					DeleteObject NewPen
					Message.Result = 0
					Return
				End If
			Case CM_COMMAND
				Select Case Message.wParamHi
				Case EN_CHANGE
					If OnChange Then OnChange(*Designer, This)
				End Select
			Case WM_DESTROY
				FHandleIsAllocated = False
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Operator NumericUpDown.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Constructor NumericUpDown
		#ifdef __USE_GTK__
			widget = UpDownControl.Handle
			g_signal_connect(widget, "value_changed", G_CALLBACK(@SpinButton_ValueChanged), @This)
		#endif
		With This
			.Child             = @This
			UpDownControl.Associate = @This
			.Add @UpDownControl
			FTabIndex          = -1
			FTabStop         = True
			#ifndef __USE_GTK__
				.RegisterClass "NumericUpDown", "Edit"
				.ChildProc         = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
				.ExStyle     = WS_EX_CLIENTEDGE
				Base.Style       = WS_CHILD Or ES_AUTOHSCROLL Or WS_TABSTOP Or ES_NUMBER
				.Width       = 121
				.Height      = ScaleY(Font.Size / 72 * 96 + 6) '21
			#endif
			WLet(FClassName, "NumericUpDown")
			WLet(FClassAncestor, "Edit")
		End With
	End Constructor
	
	Private Destructor NumericUpDown
		#ifdef __USE_GTK__
		If GTK_IS_WIDGET(widget) Then
			g_signal_handlers_disconnect_by_func(widget, G_CALLBACK(@SpinButton_ValueChanged), @This)
		End If
		widget = 0
		#endif
	End Destructor
End Namespace
