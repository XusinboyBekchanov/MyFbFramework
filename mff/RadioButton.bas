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
	Function RadioButton.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "caption": Return Cast(Any Ptr, This.FText.vptr)
		Case "text": Return Cast(Any Ptr, This.FText.vptr)
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function RadioButton.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "caption": If Value <> 0 Then This.Caption = *Cast(WString Ptr, Value)
		Case "text": If Value <> 0 Then This.Text = *Cast(WString Ptr, Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Property RadioButton.Caption ByRef As WString
		Return Text
	End Property
	
	Property RadioButton.Caption(ByRef Value As WString)
		Text = Value
	End Property
	
	Property RadioButton.Parent As Control Ptr
		Return Base.Parent
	End Property
	
	Property RadioButton.Parent(Value As Control Ptr)
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
	Property RadioButton.Text ByRef As WString
		Return Base.Text
	End Property
	
	Property RadioButton.Text(ByRef Value As WString)
		Base.Text = Value
		#ifdef __USE_GTK__
			gtk_label_set_text_with_mnemonic(gtk_label(gtk_bin_get_child(gtk_bin(widget))), ToUtf8(Replace(Value, "&", "_")))
		#endif
	End Property
	
	Property RadioButton.Checked As Boolean
		#ifndef __USE_GTK__
			If Handle Then
				FChecked = Perform(BM_GETCHECK, 0, 0)
			End If
		#endif
		Return FChecked
	End Property
	
	Property RadioButton.Checked(Value As Boolean)
		FChecked = Value
		#ifndef __USE_GTK__
			If Handle Then Perform(BM_SETCHECK, FChecked, 0)
		#endif
	End Property
	
	#ifndef __USE_GTK__
		Sub RadioButton.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QRadioButton(Sender.Child)
					.Perform(BM_SETCHECK, .FChecked, 0)
				End With
			End If
		End Sub
		
		Sub RadioButton.WndProc(ByRef Message As Message)
			If Message.Sender Then
				
			End If
		End Sub
		
		Sub RadioButton.ProcessMessage(ByRef Message As Message)
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
			Base.ProcessMessage(Message)
		End Sub
	#endif
	
	Operator RadioButton.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Constructor RadioButton
		With This
			.Child       = @This
			#ifdef __USE_GTK__
				widget = gtk_radio_button_new_with_label (NULL, "")
				.RegisterClass "RadioButton", @This
			#else
				.RegisterClass "RadioButton","Button"
				.ChildProc   = @WndProc
				.ExStyle     = 0
				.Style       = WS_CHILD Or BS_AUTORADIOBUTTON
				.BackColor       = GetSysColor(COLOR_BTNFACE)
				.DoubleBuffered = True
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			FTabStop = True
			WLet FClassName, "RadioButton"
			WLet FClassAncestor, "Button"
			.Width       = 90
			.Height      = 17
		End With
	End Constructor
	
	Destructor RadioButton
	End Destructor
End Namespace
