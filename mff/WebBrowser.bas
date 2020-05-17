'################################################################################
'#  WebBrowser.bi                                                               #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#include once "WebBrowser.bi"

Namespace My.Sys.Forms
	#ifndef __USE_GTK__
		Sub WebBrowser.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QWebBrowser(Sender.Child)
					
				End With
			End If
		End Sub
		
		Sub WebBrowser.WndProc(ByRef Message As Message)
		End Sub
		
		Sub WebBrowser.ProcessMessage(ByRef Message As Message)
		End Sub
	#endif
	
	Operator WebBrowser.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	Constructor WebBrowser
		With This
			WLet FClassName, "WebBrowser"
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
