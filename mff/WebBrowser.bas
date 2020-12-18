'################################################################################
'#  WebBrowser.bi                                                               #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#include once "WebBrowser.bi"

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Function WebBrowser.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "tabindex": Return @FTabIndex
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Function WebBrowser.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "tabindex": TabIndex = QInteger(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Property WebBrowser.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Property WebBrowser.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	#ifndef __USE_GTK__
		Sub WebBrowser.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QWebBrowser(Sender.Child)
					
				End With
			End If
		End Sub
		
		Sub WebBrowser.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Sub WebBrowser.ProcessMessage(ByRef Message As Message)
	End Sub
	
	Operator WebBrowser.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	Constructor WebBrowser
		With This
			WLet(FClassName, "WebBrowser")
			FTabIndex          = -1
			FTabStop           = True
			'WLet FClassAncestor, "ReBarWindow32"
			#ifndef __USE_GTK__
				.RegisterClass "WebBrowser" ',"ReBarWindow32"
				.Style        = WS_CHILD
				.ExStyle      = 0
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.Width        = 175
			.Height       = 21
			.Child        = @This
		End With
	End Constructor
	
	Destructor WebBrowser
		#ifndef __USE_GTK__
			UnregisterClass "WebBrowser",GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
