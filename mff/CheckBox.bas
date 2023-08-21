'################################################################################
'#  CheckBox.bas                                                                #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                      #
'#  Based on:                                                                   #
'#   TCheckBox.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                              #
'#   Copyright (c) 2007-2008 Nastase Eodor                                      #
'#   Version 1.0.0                                                              #
'#  Updated and added cross-platform                                            #
'#  by Xusinboy Bekchanov (2018-2019), Liu XiaLin                               #
'################################################################################

#include once "CheckBox.bi"
#ifdef __USE_WINAPI__
	#include once "win\tmschema.bi"
#endif

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function CheckBox.ReadProperty(PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "alignment": Return @FAlignment
			Case "autosize": Return @FAutoSize
			Case "caption": Return FText.vptr
			Case "text": Return FText.vptr
			Case "checked": Return @FChecked
			Case "tabindex": Return @FTabIndex
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function CheckBox.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "alignment": Alignment = *Cast(CheckAlignmentConstants Ptr, Value)
			Case "autosize": AutoSize = QBoolean(Value)
			Case "caption": This.Caption = QWString(Value)
			Case "text": This.Text = QWString(Value)
			Case "checked": Checked = QBoolean(Value)
			Case "tabindex": TabIndex = QInteger(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	
	Private Property CheckBox.Alignment As CheckAlignmentConstants
		Return FAlignment
	End Property
	
	Private Property CheckBox.Alignment(Value As CheckAlignmentConstants)
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
	
	Private Property CheckBox.AutoSize As Boolean
		Return FAutoSize
	End Property
	
	Private Property CheckBox.AutoSize(Value As Boolean)
		FAutoSize = Value
		#ifdef __USE_WINAPI__
			If FHandle Then
				Width = 1
			End If
		#endif
	End Property
	
	Private Property CheckBox.Caption ByRef As WString
		Return Text
	End Property
	
	Private Property CheckBox.Caption(ByRef Value As WString)
		Text = Value
	End Property
	
	Private Property CheckBox.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property CheckBox.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property CheckBox.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property CheckBox.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Property CheckBox.Text ByRef As WString
		Return Base.Text
	End Property
	
	Private Property CheckBox.Text(ByRef Value As WString)
		Base.Text = Value
		#ifdef __USE_GTK__
			gtk_button_set_label(GTK_BUTTON(widget), ToUtf8(Value))
		#elseif defined(__USE_JNI__)
			If FHandle Then
				(*env)->CallVoidMethod(env, FHandle, GetMethodID(*FClassAncestor, "setText", "(Ljava/lang/CharSequence;)V"), (*env)->NewStringUTF(env, ToUtf8(FText)))
			End If
		#elseif defined(__USE_WINAPI__)
			If FAutoSize Then AutoSize = True
		#endif
	End Property
	
	Private Property CheckBox.Checked As Boolean
		If FHandle Then
			#ifdef __USE_GTK__
				FChecked = gtk_toggle_button_get_active(GTK_TOGGLE_BUTTON(widget))
			#elseif defined(__USE_WINAPI__)
				FChecked = Perform(BM_GETCHECK, 0, 0)
			#elseif defined(__USE_JNI__)
				FChecked = (*env)->CallBooleanMethod(env, FHandle, GetMethodID(*FClassAncestor, "isChecked", "()Z"))
			#endif
		End If
		Return FChecked
	End Property
	
	Private Property CheckBox.Checked(Value As Boolean)
		FChecked = Value
		If FHandle Then
			#ifdef __USE_GTK__
				gtk_toggle_button_set_active(GTK_TOGGLE_BUTTON(widget), Value)
			#elseif defined(__USE_WINAPI__)
				Perform(BM_SETCHECK, FChecked, 0)
			#elseif defined(__USE_JNI__)
				(*env)->CallVoidMethod(env, FHandle, GetMethodID(*FClassAncestor, "setChecked", "(Z)V"), _Abs(Value))
			#endif
		End If
	End Property
	
	Private Sub CheckBox.HandleIsAllocated(ByRef Sender As Control)
		#ifdef __USE_WINAPI__
			If Sender.Child Then
				With QCheckBox(Sender.Child)
					.Perform(BM_SETCHECK, .FChecked, 0)
				End With
			End If
		#elseif defined(__USE_JNI__)
			With QCheckBox(@Sender)
				If .FChecked Then .Checked = .FChecked
			End With
		#endif
	End Sub
	
	#ifdef __USE_WINAPI__
		Private Sub CheckBox.WndProc(ByRef Message As Message)
			'        If Message.Sender Then
			'            If Cast(TControl Ptr,Message.Sender)->Child Then
			'               Cast(CheckBox Ptr,Cast(TControl Ptr,Message.Sender)->Child)->ProcessMessage(Message)
			'            End If
			'        End If
		End Sub
	#endif
	
	Private Sub CheckBox.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_WINAPI__
			Select Case Message.Msg
			Case CM_CTLCOLOR
				Static As HDC Dc
				Dc = Cast(HDC, Message.wParam)
				SetBkMode Dc, TRANSPARENT
				SetTextColor Dc, Font.Color
				SetBkColor Dc, This.BackColor
				SetBkMode Dc, OPAQUE
			Case CM_COMMAND
				If Message.wParamHi = BN_CLICKED Then
					If Checked = 0 Then
						Checked = 1
					Else
						Checked = 0
					End If
					If OnClick Then OnClick(*Designer, This)
				End If
			Case WM_WINDOWPOSCHANGING
				If FAutoSize Then
					Dim As ..Size Size_
					SendMessage(FHandle, BCM_GETIDEALSIZE, 0, Cast(LPARAM, @Size_))
					With *Cast(WINDOWPOS Ptr, Message.lParam)
						.cx = Size_.cx
						.cy = Size_.cy
					End With
				End If
			Case CM_NOTIFY
				If (g_darkModeSupported AndAlso g_darkModeEnabled OrElse FForeColor <> 0) AndAlso Cast(LPNMHDR, Message.lParam)->code = NM_CUSTOMDRAW Then
					Dim As NMCUSTOMDRAW Ptr pnm = Cast(LPNMCUSTOMDRAW, Message.lParam)
					Select Case pnm->dwDrawStage
					Case CDDS_PREERASE
						Dim As HRESULT hr = DrawThemeParentBackground(pnm->hdr.hwndFrom, pnm->hdc, @pnm->rc)
						If FAILED(hr) Then ' If failed draw without theme
							SetWindowLongPtr(Message.hWnd, DWLP_MSGRESULT, Cast(LONG_PTR, CDRF_DODEFAULT))
							Message.Result = True
							Return
						End If
						
						Dim As HTHEME hTheme = OpenThemeData(pnm->hdr.hwndFrom, "BUTTON")
						
						If hTheme = 0 Then ' If failed draw without theme
							CloseThemeData(hTheme)
							SetWindowLongPtr(Message.hWnd, DWLP_MSGRESULT, Cast(LONG_PTR, CDRF_DODEFAULT))
							Message.Result = True
							Return
						End If
						
						Dim As LRESULT state = SendMessage(pnm->hdr.hwndFrom, BM_GETSTATE, 0, 0)
						
						Dim As Integer stateID ' parameter for DrawThemeBackground
						
						Dim As UINT uiItemState = pnm->uItemState
						Dim As BOOL bChecked = This.Checked
						
						If (uiItemState And CDIS_DISABLED) Then
							stateID = IIf(bChecked, CBS_CHECKEDDISABLED, CBS_UNCHECKEDDISABLED)
						ElseIf (uiItemState And CDIS_SELECTED) Then
							stateID = IIf(bChecked, CBS_CHECKEDPRESSED, CBS_UNCHECKEDPRESSED)
						Else
							If (uiItemState And CDIS_HOT) Then
								stateID = IIf(bChecked, CBS_CHECKEDHOT, CBS_UNCHECKEDHOT)
							Else
								stateID = IIf(bChecked, CBS_CHECKEDNORMAL, CBS_UNCHECKEDNORMAL)
							End If
						End If
						
						Dim As ..Rect r
						Dim As ..Size s
						
						' Get check box dimensions so we can calculate
						' rectangle dimensions For text
						GetThemePartSize(hTheme, pnm->hdc, BP_CHECKBOX, stateID, NULL, TS_TRUE, @s)
						
						r.Left = pnm->rc.Left
						r.Top = pnm->rc.Top ' + 2
						r.Right = pnm->rc.Left + s.cx
						r.Bottom = pnm->rc.Bottom ' r.top + s.cy
						
						DrawThemeBackground(hTheme, pnm->hdc, BP_CHECKBOX, stateID, @r, NULL)
						
						' adjust rectangle for text drawing
						'pnm->rc.top += r.top - 2
						pnm->rc.Left += 3 + s.cx
						If (uiItemState And CDIS_DISABLED) Then
							SetTextColor(pnm->hdc, darkHlBkColor)
						End If
						Dim As HFONT OldFontHandle, NewFontHandle
						OldFontHandle = SelectObject(pnm->hdc, This.Font.Handle)
						DrawText(pnm->hdc, This.Text, -1, @pnm->rc, DT_SINGLELINE Or DT_VCENTER)
						If (uiItemState And CDIS_FOCUS) Then
							Dim Sz As ..Size
							GetTextExtentPoint32(pnm->hdc, @This.Text, Len(This.Text), @Sz)
							pnm->rc.Left -= 1
							pnm->rc.Top = (pnm->rc.Bottom - r.Top - (s.cy + 2)) / 2
							pnm->rc.Right = pnm->rc.Left + Sz.cx + 2
							pnm->rc.Bottom = pnm->rc.Top + s.cy + 2
							DrawFocusRect(pnm->hdc, @pnm->rc)
						End If
						NewFontHandle = SelectObject(pnm->hdc, OldFontHandle)
						CloseThemeData(hTheme)
						Message.Result = Cast(LONG_PTR, CDRF_SKIPDEFAULT)
						Return
					End Select
				End If
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Operator CheckBox.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Private Sub CheckBox_Toggled(widget As GtkToggleButton Ptr, user_data As Any Ptr)
			Dim As CheckBox Ptr but = user_data
			If but->OnClick Then but->OnClick(*but)
		End Sub
	#endif
	
	Private Constructor CheckBox
		With This
			.Child                  = @This
			#ifdef __USE_GTK__
				widget = gtk_check_button_new_with_label("")
				.RegisterClass "CheckBox", @This
				g_signal_connect(widget, "toggled", G_CALLBACK(@CheckBox_Toggled), @This)
			#elseif defined(__USE_WINAPI__)
				.RegisterClass "CheckBox", "Button"
				WLet(FClassAncestor, "Button")
				.ChildProc              = @WndProc
			#elseif defined(__USE_JNI__)
				WLet(FClassAncestor, "android/widget/CheckBox")
			#endif
			WLet(FClassName, "CheckBox")
			FTabIndex = -1
			FTabStop = True
			#ifdef __USE_WINAPI__
				.ExStyle                = 0
				.Style                  = WS_CHILD Or BS_CHECKBOX
				.BackColor                  = GetSysColor(COLOR_BTNFACE)
				FDefaultBackColor = .BackColor
			#endif
			.OnHandleIsAllocated    = @HandleIsAllocated
			.Width                  = 90
			.Height                 = 17
			.FTabIndex              = -1
			.FTabStop               = True
		End With
	End Constructor
	
	Private Destructor CheckBox
	End Destructor
End Namespace
