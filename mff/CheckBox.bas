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
	Function CheckBox.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "caption": Return FText.vptr
		Case "text": Return FText.vptr
		Case "checked": Return @FChecked
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function CheckBox.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "caption": This.Caption = QWString(Value)
		Case "text": This.text = QWString(Value)
		Case "checked": Checked = QBoolean(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Property CheckBox.Caption ByRef As WString
		Return Text
	End Property
	
	Property CheckBox.Caption(ByRef Value As WString)
		Text = Value
	End Property
	
	Property CheckBox.Text ByRef As WString
		Return Base.Text
	End Property
	
	Property CheckBox.Text(ByRef Value As WString)
		Base.Text = Value
		#IfDef __USE_GTK__
			gtk_button_set_label(GTK_BUTTON(widget), ToUtf8(Value))
		#EndIf
	End Property
	
	Property CheckBox.Checked As Boolean
		#IfDef __USE_GTK__
			If widget Then FChecked = gtk_toggle_button_get_active(gtk_toggle_button(widget))
		#Else
			If FHandle Then
			End If
		#EndIf
		Return FChecked
	End Property
	
	Property CheckBox.Checked(Value As Boolean)
		FChecked = Value
		#IfDef __USE_GTK__
			If widget Then gtk_toggle_button_set_active(gtk_toggle_button(widget), Value)
		#Else
			If Handle Then Perform(BM_SETCHECK,FChecked,0)
		#EndIf
	End Property
	
	Sub CheckBox.HandleIsAllocated(BYREF Sender As Control)
		If Sender.Child Then
			#IfNDef __USE_GTK__
				With QCheckBox(Sender.Child)
					.Perform(BM_SETCHECK, .Checked, 0)
				End With
			#EndIf
		End If
	End Sub
	
	#IfNDef __USE_GTK__
		Sub CheckBox.WndProc(BYREF Message As Message)
			'        If Message.Sender Then
			'            If Cast(TControl Ptr,Message.Sender)->Child Then
			'               Cast(CheckBox Ptr,Cast(TControl Ptr,Message.Sender)->Child)->ProcessMessage(Message)
			'            End If
			'        End If
		End Sub
	#EndIf
	
	#ifndef __USE_GTK__
		Sub CheckBox.ProcessMessage(ByRef Message As Message)
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
			Base.ProcessMessage(Message)
		End Sub
	#endif
	
	Operator CheckBox.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Sub CheckBox_Toggled(widget As GtkToggleButton Ptr, user_data As Any Ptr)
			Dim As CheckBox Ptr but = user_data
			If but->OnClick Then but->OnClick(*but)
		End Sub
	#endif
	
	Constructor CheckBox
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
			WLet FClassName, "CheckBox"
			WLet FClassAncestor, "Button"
			FTabStop = True
			#ifndef __USE_GTK__
				.ExStyle                = 0
				.Style                  = WS_CHILD Or BS_CHECKBOX
				.BackColor                  = GetSysColor(COLOR_BTNFACE)
				.OnHandleIsAllocated    = @HandleIsAllocated
			#endif
			.Width                  = 90
			.Height                 = 17
			.FTabStop               = True
		End With
	End Constructor
	
	Destructor CheckBox
	End Destructor
End Namespace
