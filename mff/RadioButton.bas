'###############################################################################
'#  RadioButton.bi                                                             #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TRadioButton.bi                                                           #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "RadioButton.bi"

Namespace My.Sys.Forms
	Private Function RadioButton.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "alignment": Return @FAlignment
		Case "caption": Return Cast(Any Ptr, This.FText.vptr)
		Case "checked": Return @FChecked
		Case "tabindex": Return @FTabIndex
		Case "text": Return Cast(Any Ptr, This.FText.vptr)
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Private Function RadioButton.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "alignment": Alignment = *Cast(CheckAlignmentConstants Ptr, Value)
		Case "caption": If Value <> 0 Then This.Caption = *Cast(WString Ptr, Value)
		Case "checked": Checked = QBoolean(Value)
		Case "tabindex": If Value <> 0 Then TabIndex = QInteger(Value)
		Case "text": If Value <> 0 Then This.Text = *Cast(WString Ptr, Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Private Property RadioButton.Alignment As CheckAlignmentConstants
		Return FAlignment
	End Property
	
	Private Property RadioButton.Alignment(Value As CheckAlignmentConstants)
		If Value <> FAlignment Then
			FAlignment = Value
			#ifdef __USE_WINAPI__
				ChangeStyle BS_LEFT, False
				ChangeStyle BS_RIGHTBUTTON, False
				Select Case Value
				Case chLeft: ChangeStyle BS_LEFT, True
				Case chRight: ChangeStyle BS_RIGHTBUTTON, True
				End Select
				RecreateWnd
			#endif
		End If
	End Property
	
	Private Property RadioButton.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property RadioButton.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property RadioButton.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property RadioButton.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Property RadioButton.Caption ByRef As WString
		Return Text
	End Property
	
	Private Property RadioButton.Caption(ByRef Value As WString)
		Text = Value
	End Property
	
	Private Property RadioButton.Parent As Control Ptr
		Return Base.Parent
	End Property
	
	Private Property RadioButton.Parent(Value As Control Ptr)
		#ifdef __USE_GTK__
			For i As Integer = 0 To Value->ControlCount - 1
				If Value->Controls[i]->ClassName = "RadioButton" Then
					#ifdef __USE_GTK3__
						gtk_radio_button_join_group(gtk_radio_button(widget), gtk_radio_button(Value->Controls[i]->Widget))
					#else
						gtk_radio_button_set_group(gtk_radio_button(widget), gtk_radio_button_get_group(gtk_radio_button(Value->Controls[i]->Widget)))
					#endif
					Exit For
				End If
			Next
		#endif
		Base.Parent = Value
	End Property
	Private Property RadioButton.Text ByRef As WString
		Return Base.Text
	End Property
	
	Private Property RadioButton.Text(ByRef Value As WString)
		Base.Text = Value
		#ifdef __USE_GTK__
			gtk_label_set_text_with_mnemonic(gtk_label(gtk_bin_get_child(gtk_bin(widget))), ToUtf8(Replace(Value, "&", "_")))
		#elseif defined(__USE_JNI__)
			If FHandle Then
				(*env)->CallVoidMethod(env, FHandle, GetMethodID(*FClassAncestor, "setText", "(Ljava/lang/CharSequence;)V"), (*env)->NewStringUTF(env, ToUTF8(FText)))
			End If
		#endif
	End Property
	
	Private Property RadioButton.Checked As Boolean
		If FHandle Then
			#ifdef __USE_GTK__
				FChecked = gtk_toggle_button_get_active(gtk_toggle_button(widget))
			#elseif defined(__USE_WINAPI__)
				FChecked = Perform(BM_GETCHECK, 0, 0)
			#elseif defined(__USE_JNI__)
				FChecked = (*env)->CallBooleanMethod(env, FHandle, GetMethodID(*FClassAncestor, "isChecked", "()Z"))
			#endif
		End If
		Return FChecked
	End Property
	
	Private Property RadioButton.Checked(Value As Boolean)
		FChecked = Value
		If FHandle Then
			#ifdef __USE_GTK__
				gtk_toggle_button_set_active(gtk_toggle_button(widget), Value)
			#elseif defined(__USE_WINAPI__)
				Perform(BM_SETCHECK, FChecked, 0)
			#elseif defined(__USE_JNI__)
				(*env)->CallVoidMethod(env, FHandle, GetMethodID(*FClassAncestor, "setChecked", "(Z)V"), _Abs(Value))
			#endif
		End If
	End Property
	
	Private Sub RadioButton.HandleIsAllocated(ByRef Sender As Control)
		#ifdef __USE_WINAPI__
			If Sender.Child Then
				With QRadioButton(Sender.Child)
					If g_darkModeSupported AndAlso g_darkModeEnabled AndAlso .FDefaultBackColor = .FBackColor Then
						SetWindowTheme(.FHandle, "", "")
						'SetWindowTheme(.FHandle, "DarkMode", nullptr)
						.Brush.Handle = hbrBkgnd
						SendMessageW(.FHandle, WM_THEMECHANGED, 0, 0)
					End If
					.Perform(BM_SETCHECK, .FChecked, 0)
				End With
			End If
		#elseif defined(__USE_JNI__)
			With QRadioButton(@Sender)
				If .FChecked Then .Checked = .FChecked
			End With
		#endif
	End Sub
	
	#ifdef __USE_WINAPI__
		Private Sub RadioButton.WndProc(ByRef Message As Message)
			If Message.Sender Then
				
			End If
		End Sub
	#endif
	
	Private Sub RadioButton.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_WINAPI__
			Select Case Message.Msg
			Case CM_CTLCOLOR
				Static As HDC Dc
				Dc = Cast(HDC,Message.wParam)
				SetBKMode Dc, TRANSPARENT
				SetTextColor Dc,Font.Color
				SetBKColor Dc,This.BackColor
				SetBKMode Dc,OPAQUE
			Case CM_COMMAND
				If Message.wParamHi = BN_CLICKED Then
					If OnClick Then OnClick(This)
				End If
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Operator RadioButton.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Private Sub RadioButton_Toggled(widget As GtkToggleButton Ptr, user_data As Any Ptr)
			Dim As RadioButton Ptr but = user_data
			If but->OnClick Then but->OnClick(*but)
		End Sub
	#endif
	
	Private Constructor RadioButton
		With This
			.Child       = @This
			#ifdef __USE_GTK__
				widget = gtk_radio_button_new_with_label (NULL, "")
				g_signal_connect(widget, "toggled", G_CALLBACK(@RadioButton_Toggled), @This)
				.RegisterClass "RadioButton", @This
			#elseif defined(__USE_WINAPI__)
				.RegisterClass "RadioButton","Button"
				.ChildProc   = @WndProc
				.ExStyle     = 0
				.Style       = WS_CHILD Or BS_AUTORADIOBUTTON
				.BackColor       = GetSysColor(COLOR_BTNFACE)
				FDefaultBackColor = .BackColor
				.DoubleBuffered = True
				WLet(FClassAncestor, "Button")
			#elseif defined(__USE_JNI__)
				WLet(FClassAncestor, "android/widget/RadioButton")
			#endif
			.OnHandleIsAllocated = @HandleIsAllocated
			FTabIndex          = -1
			FTabStop = True
			WLet(FClassName, "RadioButton")
			.Width       = 90
			.Height      = 17
		End With
	End Constructor
	
	Private Destructor RadioButton
	End Destructor
End Namespace
