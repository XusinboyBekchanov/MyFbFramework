'################################################################################
'#  PageScroller.bi                                                             #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
    #DEFINE QPageScroller(__Ptr__) *Cast(PageScroller Ptr, __Ptr__)
    
    Type PageScroller Extends Control
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
		Sub PageScroller.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QPageScroller(Sender.Child)
					 
				End With
			End If
		End Sub

		Sub PageScroller.WndProc(ByRef Message As Message)
		End Sub

		Sub PageScroller.ProcessMessage(ByRef Message As Message)
			Base.ProcessMessage(Message)
		End Sub
	#EndIf

    Operator PageScroller.Cast As My.Sys.Forms.Control Ptr
         Return Cast(My.Sys.Forms.Control Ptr, @This)
    End Operator

    Constructor PageScroller
        With This
            WLet FClassName, "PageScroller"
            WLet FClassAncestor, "SysPager"
            #IfNDef __USE_GTK__
				.RegisterClass "PageScroller","SysPager"
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

    Destructor PageScroller
		#IfNDef __USE_GTK__
			UnregisterClass "PageScroller",GetModuleHandle(NULL)
		#EndIf
    End Destructor
End Namespace
