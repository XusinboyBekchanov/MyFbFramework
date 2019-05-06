'###############################################################################
'#  RadioButton.bi                                                             #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TRadioButton.bi                                                           #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
	#DEFINE QRadioButton(__Ptr__) *Cast(RadioButton Ptr,__Ptr__)

	Type RadioButton Extends Control
		Private:
			FChecked    As Boolean
			#IfNDef __USE_GTK__
				Declare Static Sub WndProc(BYREF Message As Message)
				Declare Sub ProcessMessage(BYREF Message As Message)
				Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
			#EndIf
		Public:
			Declare Function ReadProperty(PropertyName As String) As Any Ptr
            Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
            Declare Property Caption ByRef As WString
			Declare Property Caption(ByRef Value As WString)
			Declare Property Text ByRef As WString
			Declare Property Text(ByRef Value As WString)
			Declare Property Checked As Boolean
			Declare Property Checked(Value As Boolean)
			Declare Property Grouped As Boolean
			Declare Property Grouped(Value As Boolean)
			Declare Operator Cast As Control Ptr
			Declare Constructor
			Declare Destructor
			OnClick As Sub(BYREF Sender As RadioButton)
	End Type

	Function RadioButton.ReadProperty(PropertyName As String) As Any Ptr
        Select Case LCase(PropertyName)
        Case "caption": Return Cast(Any Ptr, This.FText)
        Case "text": Return Cast(Any Ptr, This.FText)
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
	
	Property RadioButton.Text ByRef As WString
        Return Base.Text
    End Property

    Property RadioButton.Text(ByRef Value As WString)
        Base.Text = Value
        #IfDef __USE_GTK__
        	gtk_label_set_text_with_mnemonic(gtk_label(gtk_bin_get_child(gtk_bin(widget))), ToUtf8(Replace(Value, "&", "_")))
		#EndIf
    End Property

	Property RadioButton.Checked As Boolean
		#IfNDef __USE_GTK__ 
			If Handle Then
			   FChecked = Perform(BM_GETCHECK, 0, 0)
			End If
		#EndIf
		Return FChecked
	End Property

	Property RadioButton.Checked(Value As Boolean)
		FChecked = Value
		#IfNDef __USE_GTK__ 
			If Handle Then Perform(BM_SETCHECK,FChecked,0)
		#EndIf
	End Property

	#IfNDef __USE_GTK__ 
		Sub RadioButton.HandleIsAllocated(BYREF Sender As Control)
			If Sender.Child Then
				With QRadioButton(Sender.Child)
					 .Perform(BM_SETCHECK,.Checked,0)
				End With
			End If
		End Sub
		
		Sub RadioButton.WndProc(BYREF Message As Message)
			If Message.Sender Then
				
			End If
		End Sub

		Sub RadioButton.ProcessMessage(BYREF Message As Message)
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
	#EndIf

	Operator RadioButton.Cast As Control Ptr 
		Return Cast(Control Ptr, @This)
	End Operator

	Constructor RadioButton
		With This
			.Child       = @This
			#IfDef __USE_GTK__
				widget = gtk_radio_button_new_with_label (NULL, "")
				.RegisterClass "RadioButton", @This
			#Else 
				.RegisterClass "RadioButton","Button"
				.ChildProc   = @WndProc
				.ExStyle     = 0
				.Style       = WS_CHILD OR BS_AUTORADIOBUTTON
				.BackColor       = GetSysColor(COLOR_BTNFACE)
				.OnHandleIsAllocated = @HandleIsAllocated	
			#EndIf
			WLet FClassName, "RadioButton"
			WLet FClassAncestor, "Button"
			.Width       = 90
			.Height      = 17
		End With  
	End Constructor

	Destructor RadioButton
	End Destructor
End namespace
