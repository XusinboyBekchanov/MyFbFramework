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
	
	#ifndef __USE_GTK__
		Sub IPAddress.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QIPAddress(Sender.Child)
					
				End With
			End If
		End Sub
		
		Sub IPAddress.WndProc(ByRef Message As Message)
		End Sub
		
		Sub IPAddress.ProcessMessage(ByRef Message As Message)
			'Base.ProcessMessage Message
		End Sub
	#endif
	
	Operator IPAddress.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	Constructor IPAddress
		#ifndef __USE_GTK__
'			Dim As INITCOMMONCONTROLSEX icex
'			
'			icex.dwSize = SizeOf(INITCOMMONCONTROLSEX)
'			icex.dwICC =  ICC_INTERNET_CLASSES
'			
'			InitCommonControlsEx(@icex)
		#endif
		
		With This
			WLet(FClassName, "IPAddress")
			FTabIndex          = -1
			FTabStop           = True
			#ifndef __USE_GTK__
				.RegisterClass "IPAddress", WC_IPADDRESS
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
			UnregisterClass "IPAddress",GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
