'################################################################################
'#  PageScroller.bi                                                                  #
'#  This file is part of MyFBFramework                                            #
'#  Version 1.0.0                                                                  #
'################################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
    #DEFINE QPageScroller(__Ptr__) *Cast(PageScroller Ptr, __Ptr__)
    
    Type PageScroller Extends Control
        Private:
            Declare Static Sub WndProc(ByRef Message As Message)
            Declare Sub ProcessMessage(ByRef Message As Message)
            Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
        Public:
            Declare Operator Cast As My.Sys.Forms.Control Ptr
            Declare Constructor
            Declare Destructor
    End Type
    
    Sub PageScroller.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
        If Sender.Child Then
            With QPageScroller(Sender.Child)
                 
            End With
        End If
    End Sub

    Sub PageScroller.WndProc(ByRef Message As Message)
    End Sub

    Sub PageScroller.ProcessMessage(ByRef Message As Message)
    End Sub

    Operator PageScroller.Cast As My.Sys.Forms.Control Ptr
         Return Cast(My.Sys.Forms.Control Ptr, @This)
    End Operator

    Constructor PageScroller
        With This
            .RegisterClass "PageScroller","SysPager"
            WLet FClassName, "PageScroller"
            WLet FClassAncestor, "SysPager"
            .Style        = WS_CHILD
            .ExStyle      = 0
            .Width        = 175
            .Height       = 21
            .Child        = @This
            .ChildProc    = @WndProc
            .OnHandleIsAllocated = @HandleIsAllocated
        End With
    End Constructor

    Destructor PageScroller
        UnregisterClass "PageScroller",GetModuleHandle(NULL)
    End Destructor
End Namespace
