'################################################################################
'#  IPAddress.bi                                                                  #
'#  This file is part of MyFBFramework                                            #
'#  Version 1.0.0                                                                  #
'################################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
    #DEFINE QLinkLabel(__Ptr__) *Cast(LinkLabel Ptr, __Ptr__)
    
    Type LinkLabel Extends Control
        Private:
            Declare Static Sub WndProc(ByRef Message As Message)
            Declare Sub ProcessMessage(ByRef Message As Message)
            Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
        Public:
            Declare Operator Cast As My.Sys.Forms.Control Ptr
            Declare Constructor
            Declare Destructor
    End Type
    
    Sub LinkLabel.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
        If Sender.Child Then
            With QLinkLabel(Sender.Child)
                 
            End With
        End If
    End Sub

    Sub LinkLabel.WndProc(ByRef Message As Message)
    End Sub

    Sub LinkLabel.ProcessMessage(ByRef Message As Message)
        'Base.ProcessMessage Message
    End Sub

    Operator LinkLabel.Cast As My.Sys.Forms.Control Ptr
         Return Cast(My.Sys.Forms.Control Ptr, @This)
    End Operator

    Constructor LinkLabel
        With This
            .RegisterClass "LinkLabel", WC_LINK
            .ClassName = "LinkLabel"
            .ClassAncestor = WC_LINK
            .ExStyle      = 0
            .Style        = WS_CHILD
            .Width        = 100
            .Height       = 32
            .Child        = @This
            .ChildProc    = @WndProc
            .OnHandleIsAllocated = @HandleIsAllocated
        End With
    End Constructor

    Destructor LinkLabel
        UnregisterClass "LinkLabel",GetModuleHandle(NULL)
    End Destructor
End Namespace
