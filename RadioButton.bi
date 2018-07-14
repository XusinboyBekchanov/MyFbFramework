'###############################################################################
'#  RadioButton.bi                                                             #
'#  This file is part of MyFBFramework		                                   #
'#  Version 1.0.0                                                              #
'###############################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
	#DEFINE QRadioButton(__Ptr__) *Cast(RadioButton Ptr,__Ptr__)

	Type RadioButton Extends Control
		Private:
			FChecked    As Boolean
			Declare Static Sub WndProc(BYREF Message As Message)
			Declare Sub ProcessMessage(BYREF Message As Message)
			Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
		Public:
			Declare Property Caption ByRef As WString
			Declare Property Caption(ByRef Value As WString)
			Declare Property Checked As Boolean
			Declare Property Checked(Value As Boolean)
			Declare Property Grouped As Boolean
			Declare Property Grouped(Value As Boolean)
			Declare Operator Cast As Control Ptr
			Declare Constructor
			Declare Destructor
			OnClick As Sub(BYREF Sender As RadioButton)
	End Type

	Property RadioButton.Caption ByRef As WString
		Return Text
	End Property

	Property RadioButton.Caption(ByRef Value As WString)
		Text = Value
	End Property

	Property RadioButton.Checked As Boolean
		If Handle Then
		   FChecked = Perform(BM_GETCHECK, 0, 0)
		End If
		Return FChecked
	End Property

	Property RadioButton.Checked(Value As Boolean)
		FChecked = Value
		If Handle Then Perform(BM_SETCHECK,FChecked,0)
	End Property

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
		Base.ProcessMessage(Message)
		Select Case Message.Msg
		Case CM_CTLCOLOR
			Static As HDC Dc
			Dc = Cast(HDC,Message.wParam)
			SetBKMode Dc, TRANSPARENT
			SetTextColor Dc,Font.Color
			SetBKColor Dc,This.Color
			SetBKMode Dc,OPAQUE   
		Case CM_COMMAND
			If Message.wParamHi = BN_CLICKED Then
				If OnClick Then OnClick(This)
			End If
		End Select
	End Sub

	Operator RadioButton.Cast As Control Ptr 
		Return Cast(Control Ptr, @This)
	End Operator

	Constructor RadioButton
		With This
			.RegisterClass "RadioButton","Button"
			.Child       = @This
			.ChildProc   = @WndProc
			.ClassName   = "RadioButton"
			.ClassAncestor   = "Button"
			.ExStyle     = 0
			.Style       = WS_CHILD OR BS_AUTORADIOBUTTON
			.Color       = GetSysColor(COLOR_BTNFACE)
			.Width       = 90
			.Height      = 17
			.OnHandleIsAllocated = @HandleIsAllocated
		End With  
	End Constructor

	Destructor RadioButton
	End Destructor
End namespace