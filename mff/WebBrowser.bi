'################################################################################
'#  WebBrowser.bi                                                               #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
    #DEFINE QWebBrowser(__Ptr__) *Cast(WebBrowser Ptr, __Ptr__)
    
    Type WebBrowser Extends Control
        Private:
			#IfNDef __USE_GTK__
				Declare Static Sub WndProc(ByRef Message As Message)
				Declare Sub ProcessMessage(ByRef Message As Message)
				Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			#EndIf
        Public:
            Declare Operator Cast As My.Sys.Forms.Control Ptr
            Declare Constructor
            Declare Destructor
    End Type
    
    #IfNDef __USE_GTK__
		Sub WebBrowser.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QReBar(Sender.Child)
					 
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
