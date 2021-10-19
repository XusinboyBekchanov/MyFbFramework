'###############################################################################
'#  IPAddress.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#include once "IPAddress.bi"

Namespace My.Sys.Forms
	Function IPAddress.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "tabindex": Return @FTabIndex
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function IPAddress.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "tabindex": TabIndex = QInteger(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Property IPAddress.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Property IPAddress.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Property IPAddress.TabStop As Boolean
		Return FTabStop
	End Property
	
	Property IPAddress.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Property IPAddress.Text ByRef As WString
		Return Base.Text
	End Property
	
	Property IPAddress.Text(ByRef Value As WString)
		Base.Text = Value
	End Property
	
	#ifndef __USE_GTK__
		Sub IPAddress.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		End Sub
		
		Sub IPAddress.WndProc(ByRef Message As Message)
		End Sub
		
		Function IPAddress.IPAddressWndProc(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			Dim As IPAddress Ptr Ctrl
			Dim Message As Message
			Ctrl = GetProp(FWindow, "MFFControl")
			Message = Type(Ctrl, FWindow, Msg, wParam, lParam, 0, LoWord(wParam), HiWord(wParam), LoWord(lParam), HiWord(lParam), Message.Captured)
			If Ctrl Then
				With *Ctrl
					If Ctrl->ClassName <> "" Then
						.ProcessMessage(Message)
						If Message.Result = -1 Then
							Return Message.Result
						ElseIf Message.Result = -2 Then
							Msg = Message.Msg
							wParam = Message.wParam
							lParam = Message.lParam
						ElseIf Message.Result <> 0 Then
							Return Message.Result
						End If
					End If
				End With
			End If
			Dim As Any Ptr cp = GetClassProc(FWindow)
			If cp <> 0 Then
				Message.Result = CallWindowProc(cp, FWindow, Msg, wParam, lParam)
			End If
			Return Message.Result
		End Function
	#endif
	
	Sub IPAddress.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_GTK__
			Dim As GdkEvent Ptr e = Message.event
			Select Case Message.event->Type
			Case GDK_BUTTON_PRESS
				Return
			Case GDK_BUTTON_RELEASE
				SelectRegion
				Return
			
			End Select
		#else
			Select Case Message.Msg
			Case CM_COMMAND
				Select Case Message.wParamHi
				Case EN_CHANGE
					If OnChange Then OnChange(This)
				Case EN_KILLFOCUS
					If OnLostFocus Then OnLostFocus(This)
				Case EN_SETFOCUS
					If OnGotFocus Then OnGotFocus(This)
				End Select
				Message.Result = 0
			End Select
		#endif
		Base.ProcessMessage Message
	End Sub
	
	Operator IPAddress.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	Constructor IPAddress
		#ifndef __USE_GTK__
			Dim As INITCOMMONCONTROLSEX icex
			
			icex.dwSize = SizeOf(INITCOMMONCONTROLSEX)
			icex.dwICC =  ICC_INTERNET_CLASSES
			
			InitCommonControlsEx(@icex)
		#endif
		
		With This
			WLet(FClassName, "IPAddress")
			FTabIndex          = -1
			FTabStop           = True
			#ifndef __USE_GTK__
				.RegisterClass "IPAddress", WC_IPADDRESS, @IPAddressWndProc
				WLet(FClassAncestor, WC_IPADDRESS)
				.ExStyle      = 0
				.Style        = WS_CHILD
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.Width        = 150
			.Height       = 20
			.Child        = @This
		End With
	End Constructor
	
	Destructor IPAddress
		#ifndef __USE_GTK__
			Handle = 0
			UnregisterClass "IPAddress", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
