'################################################################################
'#  NativeFontControl.bi                                                                  #
'#  This file is part of MyFBFramework                                            #
'#  Version 1.0.0                                                                  #
'################################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
    #DEFINE QNativeFontControl(__Ptr__) *Cast(NativeFontControl Ptr, __Ptr__)
    
    Type NativeFontControl Extends Control
        Private:
            Declare Static Sub WndProc(ByRef Message As Message)
            Declare Sub ProcessMessage(ByRef Message As Message)
            Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
        Public:
            Declare Operator Cast As My.Sys.Forms.Control Ptr
            Declare Constructor
            Declare Destructor
    End Type
    
    Sub NativeFontControl.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
        If Sender.Child Then
            With QNativeFontControl(Sender.Child)
                 
            End With
        End If
    End Sub

    Sub NativeFontControl.WndProc(ByRef Message As Message)
    End Sub

    Sub NativeFontControl.ProcessMessage(ByRef Message As Message)
    End Sub

    Operator NativeFontControl.Cast As My.Sys.Forms.Control Ptr
         Return Cast(My.Sys.Forms.Control Ptr, @This)
    End Operator

    Constructor NativeFontControl
        With This
            .RegisterClass "NativeFontControl","NativeFontCtl"
            .ClassName = "NativeFontControl"
            .ClassAncestor = "NativeFontCtl"
            .Style        = WS_CHILD
            .ExStyle      = 0
            .Width        = 175
            .Height       = 21
            .Child        = @This
            .ChildProc    = @WndProc
            .OnHandleIsAllocated = @HandleIsAllocated
        End With
    End Constructor

    Destructor NativeFontControl
        UnregisterClass "NativeFontControl",GetModuleHandle(NULL)
    End Destructor
End Namespace
