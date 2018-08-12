'################################################################################
'#  HotKey.bi                                                                  #
'#  This file is part of MyFBFramework                                            #
'#  Version 1.0.0                                                                  #
'################################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
    #DEFINE QHotKey(__Ptr__) *Cast(HotKey Ptr, __Ptr__)
    
    Type HotKey Extends Control
        Private:
            Declare Static Sub WndProc(ByRef Message As Message)
            Declare Sub ProcessMessage(ByRef Message As Message)
            Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
        Public:
            Declare Operator Cast As My.Sys.Forms.Control Ptr
            Declare Constructor
            Declare Destructor
    End Type
    
    Sub HotKey.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
        If Sender.Child Then
            With QHotKey(Sender.Child)
                 
            End With
        End If
    End Sub

    Sub HotKey.WndProc(ByRef Message As Message)
    End Sub

    Sub HotKey.ProcessMessage(ByRef Message As Message)
    End Sub

    Operator HotKey.Cast As My.Sys.Forms.Control Ptr
         Return Cast(My.Sys.Forms.Control Ptr, @This)
    End Operator

    Constructor HotKey
        With This
            .RegisterClass "HotKey","msctls_hotkey32"
            .ClassName = "HotKey"
            .ClassAncestor = "msctls_hotkey32"
            .Style        = WS_CHILD
            .ExStyle      = 0
            .Width        = 175
            .Height       = 21
            .Child        = @This
            .ChildProc    = @WndProc
            .OnHandleIsAllocated = @HandleIsAllocated
        End With
    End Constructor

    Destructor HotKey
        UnregisterClass "HotKey",GetModuleHandle(NULL)
    End Destructor
End Namespace
