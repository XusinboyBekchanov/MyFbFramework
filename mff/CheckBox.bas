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

Namespace My.Sys.Forms
	Private Function CheckBox.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "alignment": Return @FAlignment
		Case "caption": Return FText.vptr
		Case "text": Return FText.vptr
		Case "checked": Return @FChecked
		Case "tabindex": Return @FTabIndex
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Private Function CheckBox.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "alignment": Alignment = *Cast(CheckAlignmentConstants Ptr, Value)
		Case "caption": This.Caption = QWString(Value)
		Case "text": This.text = QWString(Value)
		Case "checked": Checked = QBoolean(Value)
		Case "tabindex": TabIndex = QInteger(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Private Property CheckBox.Alignment As CheckAlignmentConstants
		Return FAlignment
	End Property
	
	Private Property CheckBox.Alignment(Value As CheckAlignmentConstants)
		If Value <> FAlignment Then
			FAlignment = Value
			#ifndef __USE_GTK__
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
		#endif
	End Property
	
	Private Property CheckBox.Checked As Boolean
		#ifdef __USE_GTK__
			If widget Then FChecked = gtk_toggle_button_get_active(gtk_toggle_button(widget))
		#else
			If FHandle Then FChecked = Perform(BM_GETCHECK, 0, 0)
		#endif
		Return FChecked
	End Property
	
	Private Property CheckBox.Checked(Value As Boolean)
		FChecked = Value
		#ifdef __USE_GTK__
			If widget Then gtk_toggle_button_set_active(gtk_toggle_button(widget), Value)
		#else
			If Handle Then Perform(BM_SETCHECK,FChecked,0)
		#endif
	End Property
	
	Private Sub CheckBox.HandleIsAllocated(ByRef Sender As Control)
		If Sender.Child Then
			#ifndef __USE_GTK__
				With QCheckBox(Sender.Child)
					.Perform(BM_SETCHECK, .FChecked, 0)
				End With
			#endif
		End If
	End Sub
	
	#ifndef __USE_GTK__
		Private Sub CheckBox.WndProc(ByRef Message As Message)
			'        If Message.Sender Then
			'            If Cast(TControl Ptr,Message.Sender)->Child Then
			'               Cast(CheckBox Ptr,Cast(TControl Ptr,Message.Sender)->Child)->ProcessMessage(Message)
			'            End If
			'        End If
		End Sub
	#endif
	
	Private Sub CheckBox.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Select Case Message.Msg
			Case CM_CTLCOLOR
				Static As HDC Dc
				Dc = Cast(HDC, Message.wParam)
				SetBKMode Dc, TRANSPARENT
				SetTextColor Dc, Font.Color
				SetBKColor Dc, This.BackColor
				SetBKMode Dc, OPAQUE
			Case CM_COMMAND
				If Message.wParamHi = BN_CLICKED Then
					If Checked = 0 Then
						Checked = 1
					Else
						Checked = 0
					End If
					If OnClick Then OnClick(This)
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
			#else
				.RegisterClass "CheckBox", "Button"
				.ChildProc              = @WndProc
			#endif
			WLet(FClassName, "CheckBox")
			WLet(FClassAncestor, "Button")
			FTabIndex = -1
			FTabStop = True
			#ifndef __USE_GTK__
				.ExStyle                = 0
				.Style                  = WS_CHILD Or BS_CHECKBOX
				.BackColor                  = GetSysColor(COLOR_BTNFACE)
				.OnHandleIsAllocated    = @HandleIsAllocated
			#endif
			.Width                  = 90
			.Height                 = 17
			.FTabIndex              = -1
			.FTabStop               = True
		End With
	End Constructor
	
	Private Destructor CheckBox
	End Destructor
End Namespace
