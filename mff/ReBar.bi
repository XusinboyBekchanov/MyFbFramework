'################################################################################
'#  ReBar.bi                                                                    #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
    #DEFINE QReBar(__Ptr__) *Cast(ReBar Ptr, __Ptr__)
    
    Type ReBar Extends Control
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
		Sub ReBar.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QReBar(Sender.Child)
					 
				End With
			End If
		End Sub

		Sub ReBar.WndProc(ByRef Message As Message)
		End Sub

		Sub ReBar.ProcessMessage(ByRef Message As Message)
			Base.ProcessMessage(Message)
		End Sub
	#EndIf

    Operator ReBar.Cast As My.Sys.Forms.Control Ptr
         Return Cast(My.Sys.Forms.Control Ptr, @This)
    End Operator

    Constructor ReBar
        With This
            WLet FClassName, "ReBar"
            WLet FClassAncestor, "ReBarWindow32"
            #IfNDef __USE_GTK__
				.RegisterClass "ReBar","ReBarWindow32"
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

    Destructor ReBar
		#IfNDef __USE_GTK__
			UnregisterClass "ReBar",GetModuleHandle(NULL)
		#EndIf
	End Destructor
End Namespace
