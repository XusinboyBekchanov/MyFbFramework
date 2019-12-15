'################################################################################
'#  WebBrowser.bi                                                               #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#Include Once "WebBrowser.bi"

Namespace My.Sys.Forms
    #IfNDef __USE_GTK__
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
	#EndIf

    Operator WebBrowser.Cast As My.Sys.Forms.Control Ptr
         Return Cast(My.Sys.Forms.Control Ptr, @This)
    End Operator

    Constructor WebBrowser
        With This
            WLet FClassName, "WebBrowser"
            'WLet FClassAncestor, "ReBarWindow32"
            #IfNDef __USE_GTK__
				.RegisterClass "WebBrowser" ',"ReBarWindow32"
				.Style        = WS_CHILD
				.ExStyle      = 0
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#EndIf
            .Width        = 175
            .Height       = 21
            .Child        = @This
        End With
    End Constructor

    Destructor WebBrowser
		#IfNDef __USE_GTK__
			UnregisterClass "WebBrowser",GetModuleHandle(NULL)
		#EndIf
	End Destructor
End Namespace
