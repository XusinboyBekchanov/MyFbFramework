'###############################################################################
'#  UpDown.bi                                                                  #
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

#include once "UpDown.bi"
'Const UDN_DELTAPOS = (UDN_FIRST - 1)

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function UpDown.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "alignment": Return @FAlignment
			Case "arrowkeys": Return @FArrowKeys
			Case "associate": Return FAssociate
			Case "increment": Return @FIncrement
			Case "maxvalue": Return @FMaxValue
			Case "minvalue": Return @FMinValue
			Case "position": Return @FPosition
			Case "style": Return @FStyle
			Case "tabindex": Return @FTabIndex
			Case "text": Text: Return FText.vptr
			Case "thousands": Return @FThousands
			Case "wrap": Return @FWrap
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function UpDown.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "alignment": Alignment = *Cast(UpDownAlignment Ptr, Value)
				Case "arrowkeys": ArrowKeys = QBoolean(Value)
				Case "associate": Associate = Value
				Case "increment": Increment = QInteger(Value)
				Case "maxvalue": MaxValue = QInteger(Value)
				Case "minvalue": MinValue = QInteger(Value)
				Case "position": Position = QInteger(Value)
				Case "style": Style = *Cast(UpDownOrientation Ptr, Value)
				Case "tabindex": TabIndex = QInteger(Value)
				Case "text": Text = QWString(Value)
				Case "thousands": Thousands = QInteger(Value)
				Case "wrap": Wrap = QBoolean(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Property UpDown.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property UpDown.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property UpDown.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property UpDown.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Property UpDown.MinValue As Integer
		Return FMinValue
	End Property
	
	Private Property UpDown.MinValue(Value As Integer)
		FMinValue = Value
		#ifdef __USE_GTK__
			gtk_spin_button_set_range(GTK_SPIN_BUTTON(widget), FMinValue, FMaxValue)
		#else
			If Handle Then
				If FMinValue < 0 OrElse FMaxValue < 0 Then
					SendMessage(Handle, UDM_SETRANGE32, FMinValue, FMaxValue)
				Else
					SendMessage(Handle, UDM_SETRANGE, 0, MAKELPARAM(FMaxValue, FMinValue))
				End If
			End If
		#endif
	End Property
	
	Private Property UpDown.MaxValue As Integer
		Return FMaxValue
	End Property
	
	Private Property UpDown.MaxValue(Value As Integer)
		FMaxValue = Value
		#ifdef __USE_GTK__
			gtk_spin_button_set_range(GTK_SPIN_BUTTON(widget), FMinValue, FMaxValue)
		#else
			If Handle Then 
				If FMinValue < 0 OrElse FMaxValue < 0 Then
					SendMessage(Handle, UDM_SETRANGE32, FMinValue, FMaxValue)
				Else
					SendMessage(Handle, UDM_SETRANGE, 0, MAKELONG(FMaxValue, FMinValue))
				End If
			End If
		#endif
	End Property
	
	Private Property UpDown.Position As Integer
		#ifdef __USE_GTK__
			FPosition = gtk_spin_button_get_value(GTK_SPIN_BUTTON(widget))
		#else
			If Handle Then
				'FPosition = LoWord(SendMessage(Handle, UDM_GETPOS, 0, 0))
				FPosition = SendMessage(Handle, UDM_GETPOS32, 0, 0)
			End If
		#endif
		Return FPosition
	End Property
	
	Private Property UpDown.Position(Value As Integer)
		FPosition = Value
		#ifdef __USE_GTK__
			gtk_spin_button_set_value(GTK_SPIN_BUTTON(widget), FPosition)
		#else
			If Handle Then
				If FPosition < 0 Then
					SendMessage(Handle, UDM_SETPOS32, 0, FPosition)
				Else
					SendMessage(Handle, UDM_SETPOS, 0, MAKELONG(FPosition, 0))
				End If
				If FAssociate Then
					FAssociate->Text = Str(Position)
				End If
			End If
		#endif
	End Property
	
	Private Property UpDown.Increment As Integer
		Return FIncrement
	End Property
	
	Private Property UpDown.Increment(Value As Integer)
		If Value <> FIncrement Then
			FIncrement = Value
			#ifdef __USE_GTK__
				gtk_spin_button_set_increments(GTK_SPIN_BUTTON(widget), FIncrement, FIncrement)
			#else
				If Handle Then
					SendMessage(Handle, UDM_GETACCEL, 1, CInt(@FUDAccel(0)))
					FUDAccel(0).nInc = Value
					SendMessage(Handle, UDM_SETACCEL, 1, CInt(@FUDAccel(0)))
				End If
			#endif
		End If
	End Property
	
	Private Property UpDown.Text ByRef As WString
		FText = Str(Position)
		Return *FText.vptr
	End Property
	
	Private Property UpDown.Text(ByRef Value As WString)
		Position = Val(Value)
	End Property
	
	Private Property UpDown.Thousands As Boolean
		Return FThousands
	End Property
	
	Private Property UpDown.Thousands(Value As Boolean)
		If FThousands <> Value Then
			FThousands = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or UDS_SETBUDDYINT Or AStyle(abs_(FStyle)) Or AAlignment(abs_(FAlignment)) Or AWrap(abs_(FWrap)) Or AArrowKeys(abs_(FArrowKeys)) Or AAThousand(abs_(FThousands))
			#endif
		End If
	End Property
	
	Private Property UpDown.Wrap As Boolean
		Return FWrap
	End Property
	
	Private Property UpDown.Wrap(Value As Boolean)
		If FWrap <> Value Then
			FWrap = Value
			#ifdef __USE_GTK__
				gtk_spin_button_set_wrap(GTK_SPIN_BUTTON(widget), FWrap)
			#else
				Base.Style = WS_CHILD Or UDS_SETBUDDYINT Or AStyle(abs_(FStyle)) Or AAlignment(abs_(FAlignment)) Or AWrap(abs_(FWrap)) Or AArrowKeys(abs_(FArrowKeys)) Or AAThousand(abs_(FThousands))
			#endif
		End If
	End Property
	
	Private Property UpDown.Style As UpDownOrientation
		Return FStyle
	End Property
	
	Private Property UpDown.Style(Value As UpDownOrientation)
		Dim As Integer OldStyle,Temp
		OldStyle = FStyle
		If FStyle <> Value Then
			FStyle = Value
			If OldStyle = 0 Then
				Temp = This.Width
				This.Width = Height
				Height = Temp
			Else
				Temp = This.Height
				This.Height = Width
				Width = Temp
			End If
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or UDS_SETBUDDYINT Or AStyle(abs_(FStyle)) Or AAlignment(abs_(FAlignment)) Or AWrap(abs_(FWrap)) Or AArrowKeys(abs_(FArrowKeys)) Or AAThousand(abs_(FThousands))
				RecreateWnd
			#endif
		End If
	End Property
	
	Private Property UpDown.Alignment As UpDownAlignment
		Return FAlignment
	End Property
	
	Private Property UpDown.Alignment(Value As UpDownAlignment)
		If FAlignment <> Value Then
			FAlignment = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or UDS_SETBUDDYINT Or AStyle(abs_(FStyle)) Or AAlignment(abs_(FAlignment)) Or AWrap(abs_(FWrap)) Or AArrowKeys(abs_(FArrowKeys)) Or AAThousand(abs_(FThousands))
				RecreateWnd
			#endif
		End If
	End Property
	
	Private Property UpDown.Associate As Control Ptr
		Return FAssociate
	End Property
	
	Private Property UpDown.Associate(Value As Control Ptr)
		FAssociate = Value
		If FAssociate Then
			If UCase(FAssociate->ClassName) = "TEXTBOX" Then
				#ifndef __USE_GTK__
					SendMessage(Handle, UDM_SETBUDDY, CInt(FAssociate->Handle), 0)
				#endif
				FAssociate->Text = WStr(Position)
			Else
			End If
		End If
	End Property
	
	Private Property UpDown.ArrowKeys As Boolean
		Return FArrowKeys
	End Property
	
	Private Property UpDown.ArrowKeys(Value As Boolean)
		FArrowKeys = Value
		#ifdef __USE_WINAPI__
			Base.Style = WS_CHILD Or UDS_SETBUDDYINT Or AStyle(abs_(FStyle)) Or AAlignment(abs_(FAlignment)) Or AWrap(abs_(FWrap)) Or AArrowKeys(abs_(FArrowKeys)) Or AAThousand(abs_(FThousands))
		#endif
	End Property
	
	#ifndef __USE_GTK__
		Private Sub UpDown.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QUpDown(Sender.Child)
					If .FMinValue < 0 OrElse .FMaxValue < 0 Then
						SendMessage(.Handle, UDM_SETRANGE32, .FMinValue, .FMaxValue)
					Else
						SendMessage(.Handle, UDM_SETRANGE, 0, MAKELPARAM(.FMaxValue, .FMinValue))
					End If
					If .FMinValue < 0 Then
						SendMessage(.Handle, UDM_SETPOS32, 0, .FMinValue)
					Else
						SendMessage(.Handle, UDM_SETPOS, 0, MAKELONG(.FMinValue, 0))
					End If
					SendMessage(.Handle, UDM_GETACCEL, 1, CInt(@.FUDAccel(0)))
					.FUDAccel(0).nInc = .FIncrement
					SendMessage(.Handle, UDM_SETACCEL, 1, CInt(@.FUDAccel(0)))
					.Position = .FPosition
					If .FAssociate AndAlso (UCase(.FAssociate->ClassName) = "TEXTBOX" OrElse UCase(.FAssociate->ClassName) = "NUMERICUPDOWN") Then
						SendMessage(.Handle, UDM_SETBUDDY, CInt(.FAssociate->Handle), 0)
						.FAssociate->Text = WStr(.Position)
					Else
					End If
					.Width = .FWidth
				End With
			End If
		End Sub
		
		Private Sub UpDown.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Private Sub UpDown.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_WINAPI__
			Static As Integer DownButton, X, Y
			Static As Boolean MouseIn
			Select Case Message.Msg
				Case WM_PAINT
				If g_darkModeSupported AndAlso g_darkModeEnabled Then
					Dim As HDC Dc, memDC
					Dim As HBITMAP Bmp
					Dim As PAINTSTRUCT Ps
					Dim As ..Rect R
					Dim As Integer iWidth = ScaleX(Width), iHeight = ScaleY(Height)
					Canvas.HandleSetted = True
					Dc = BeginPaint(Handle, @Ps)
					Canvas.Handle = Dc
					Canvas.Pen.Color = BGR(56, 56, 56)
					Canvas.Brush.Color = BGR(51, 51, 51)
					Rectangle Dc, 0, 0, iWidth, iHeight
					Canvas.Pen.Color = BGR(155, 155, 155)
					If FStyle = UpDownOrientation.udVertical Then
						If MouseIn AndAlso Y < iHeight / 2 Then
							If DownButton = 1 Then
								Canvas.Brush.Color = BGR(102, 102, 102)
							Else
								Canvas.Brush.Color = BGR(69, 69, 69)
							End If
						Else
							Canvas.Brush.Color = BGR(51, 51, 51)
						End If
						Rectangle Dc, 1, 1, iWidth - 1, iHeight / 2 '- 1
						If MouseIn AndAlso Y > iHeight / 2 Then
							If DownButton = 1 Then
								Canvas.Brush.Color = BGR(102, 102, 102)
							Else
								Canvas.Brush.Color = BGR(69, 69, 69)
							End If
						Else
							Canvas.Brush.Color = BGR(51, 51, 51)
						End If
						Rectangle Dc, 1, iHeight / 2, iWidth - 1, iHeight - 1 '- 1
						Canvas.Pen.Color = BGR(173, 173, 173)
						MoveToEx Dc, Fix((iWidth - 3) / 2) + 1, 1 + Fix((iHeight / 2 - 4) / 2), 0
						LineTo Dc, Fix((iWidth - 3) / 2) + 2, 1 + Fix((iHeight / 2 - 4) / 2)
						MoveToEx Dc, Fix((iWidth - 3) / 2), 1 + Fix((iHeight / 2 - 4) / 2) + 1, 0
						LineTo Dc, Fix((iWidth - 3) / 2) + 3, 1 + Fix((iHeight / 2 - 4) / 2) + 1
						MoveToEx Dc, Fix((iWidth - 3) / 2) - 1, 1 + Fix((iHeight / 2 - 4) / 2) + 2, 0
						LineTo Dc, Fix((iWidth - 3) / 2) + 4, 1 + Fix((iHeight / 2 - 4) / 2) + 2
						
						MoveToEx Dc, Fix((iWidth - 3) / 2) - 1, 1 + Fix(iHeight / 2 - 1 + (iHeight / 2 - 4) / 2), 0
						LineTo Dc, Fix((iWidth - 3) / 2) + 4, 1 + Fix(iHeight / 2 - 1 + (iHeight / 2 - 4) / 2)
						MoveToEx Dc, Fix((iWidth - 3) / 2), 1 + Fix(iHeight / 2 - 1 + (iHeight / 2 - 4) / 2) + 1, 0
						LineTo Dc, Fix((iWidth - 3) / 2) + 3, 1 + Fix(iHeight / 2 - 1 + (iHeight / 2 - 4) / 2) + 1
						MoveToEx Dc, Fix((iWidth - 3) / 2) + 1, 1 + Fix(iHeight / 2 - 1 + (iHeight / 2 - 4) / 2) + 2, 0
						LineTo Dc, Fix((iWidth - 3) / 2) + 2, 1 + Fix(iHeight / 2 - 1 + (iHeight / 2 - 4) / 2) + 2
					Else
						If MouseIn AndAlso X < iWidth / 2 Then
							If DownButton = 1 Then
								Canvas.Brush.Color = BGR(102, 102, 102)
							Else
								Canvas.Brush.Color = BGR(69, 69, 69)
							End If
						Else
							Canvas.Brush.Color = BGR(51, 51, 51)
						End If
						Rectangle Dc, 1, 1, iWidth / 2, iHeight '- 1
						If MouseIn AndAlso X > iWidth / 2 Then
							If DownButton = 1 Then
								Canvas.Brush.Color = BGR(102, 102, 102)
							Else
								Canvas.Brush.Color = BGR(69, 69, 69)
							End If
						Else
							Canvas.Brush.Color = BGR(51, 51, 51)
						End If
						Rectangle Dc, iWidth / 2, 1, iWidth - 1, iHeight '- 1
						Canvas.Pen.Color = BGR(173, 173, 173)
						MoveToEx Dc, 1 + Fix((iWidth / 2 - 4) / 2), Fix((iHeight - 3) / 2) + 1, 0
						LineTo Dc, 1 + Fix((iWidth / 2 - 4) / 2), Fix((iHeight - 3) / 2) + 2
						MoveToEx Dc, 1 + Fix((iWidth / 2 - 4) / 2) + 1, Fix((iHeight - 3) / 2), 0
						LineTo Dc, 1 + Fix((iWidth / 2 - 4) / 2) + 1, Fix((iHeight - 3) / 2) + 3
						MoveToEx Dc, 1 + Fix((iWidth / 2 - 4) / 2) + 2, Fix((iHeight - 3) / 2) - 1, 0
						LineTo Dc, 1 + Fix((iWidth / 2 - 4) / 2) + 2, Fix((iHeight - 3) / 2) + 4
						
						MoveToEx Dc, 1 + Fix(iWidth / 2 + (iWidth / 2 - 4) / 2), Fix((iHeight - 3) / 2) - 1, 0
						LineTo Dc, 1 + Fix(iWidth / 2 + (iWidth / 2 - 4) / 2), Fix((iHeight - 3) / 2) + 4
						MoveToEx Dc, 1 + Fix(iWidth / 2 + (iWidth / 2 - 4) / 2) + 1, Fix((iHeight - 3) / 2), 0
						LineTo Dc, 1 + Fix(iWidth / 2 + (iWidth / 2 - 4) / 2) + 1, Fix((iHeight - 3) / 2) + 3
						MoveToEx Dc, 1 + Fix(iWidth / 2 + (iWidth / 2 - 4) / 2) + 2, Fix((iHeight - 3) / 2) + 1, 0
						LineTo Dc, 1 + Fix(iWidth / 2 + (iWidth / 2 - 4) / 2) + 2, Fix((iHeight - 3) / 2) + 2
					End If
					If OnPaint Then OnPaint(*Designer, This, Canvas)
					EndPaint Handle, @Ps
					Canvas.HandleSetted = False
					Message.Result = -1
					Return
				Else
					Message.Result = 0
				End If
			Case WM_LBUTTONDOWN
				DownButton = 1
				X = Message.lParamLo
				Y = Message.lParamHi
			Case WM_LBUTTONUP
				DownButton = 0
			Case WM_MOUSELEAVE
				MouseIn = False
			Case WM_MOUSEMOVE
				If Not MouseIn Then
					MouseIn = True
				End If
				X = Message.lParamLo
				Y = Message.lParamHi
			Case WM_SIZE
				Dim As ..Rect R
				GetClientRect Handle, @R
				InvalidateRect Handle, @R, True
			Case CM_NOTIFY
				Dim As NMHDR Ptr NM
				NM = Cast(LPNMHDR, Message.lParam)
				If NM->code = UDN_DELTAPOS Then
					Dim As NM_UPDOWN Ptr NMUD
					NMUD = Cast(NM_UPDOWN Ptr, Message.lParam)
					If OnChanging Then OnChanging(*Designer, This, NMUD->iPos, NMUD->iDelta)
					If FAssociate Then FAssociate->Text = WStr(NMUD->iPos)
				End If
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Operator UpDown.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Constructor UpDown
		Dim As Boolean Result
		#ifdef __USE_GTK__
			widget = gtk_spin_button_new_with_range(0, 100, 1)
			
		#else
			Dim As INITCOMMONCONTROLSEX ICC
			ICC.dwSize = SizeOf(ICC)
			ICC.dwICC  = ICC_UPDOWN_CLASS
			Result = INITCOMMONCONTROLSEX(@ICC)
			If Not Result Then InitCommonControls
			AStyle(0)        = 0
			AStyle(1)        = UDS_HORZ
			AAlignment(0)    = UDS_ALIGNRIGHT
			AAlignment(1)    = UDS_ALIGNLEFT
			AWrap(0)         = 0
			AWrap(1)         = UDS_WRAP
			AArrowKeys(0)    = 0
			AArrowKeys(1)    = UDS_ARROWKEYS
			AAThousand(0)    = UDS_NOTHOUSANDS
			AAThousand(1)    = 0
		#endif
		FMinValue        = 0
		FMaxValue        = 100
		FArrowKeys       = True
		FIncrement       = 1
		FAlignment       = 0
		FStyle           = 0
		FThousands       = True
		FTabIndex          = -1
		FTabStop         = True
		#ifndef __USE_GTK__
			FUDAccel(0).nInc = FIncrement
		#endif
		With This
			.Child             = @This
			#ifndef __USE_GTK__
				.RegisterClass "UpDown", UPDOWN_CLASS
				.ChildProc         = @WndProc
				WLet(FClassAncestor, UPDOWN_CLASS)
				.ExStyle           = 0
				Base.Style             = WS_CHILD Or UDS_SETBUDDYINT Or AStyle(abs_(FStyle)) Or AAlignment(abs_(FAlignment)) Or AWrap(abs_(FWrap)) Or AArrowKeys(abs_(FArrowKeys)) Or AAThousand(abs_(FThousands))
				.DoubleBuffered = True
				.OnHandleIsAllocated = @HandleIsAllocated
				.Width             = UnScaleX(GetSystemMetrics(SM_CXVSCROLL))
				.Height            = UnScaleY(GetSystemMetrics(SM_CYVSCROLL))
				.Height            = .Height + (.Height \ 2)
			#endif
			WLet(FClassName, "UpDown")
		End With
	End Constructor
	
	Private Destructor UpDown
	End Destructor
End Namespace
