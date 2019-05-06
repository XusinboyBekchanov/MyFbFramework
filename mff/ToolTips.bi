'################################################################################
'#  ToolTips.bi                                                                 #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#Include Once "Component.bi"

Namespace My.Sys.Forms
    #DEFINE QToolTips(__Ptr__) *Cast(ToolTips Ptr, __Ptr__)
    
    Type ToolTips Extends My.Sys.ComponentModel.Component
        Private:
'			#IfNDef __USE_GTK__
'				Declare Static Sub WndProc(ByRef Message As Message)
'				Declare Sub ProcessMessage(ByRef Message As Message)
'				Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
'			#EndIf
		Public:
            Declare Operator Cast As My.Sys.ComponentModel.Component Ptr
            Declare Constructor
            Declare Destructor
    End Type
    
'    #IfNDef __USE_GTK__
'		Sub ToolTips.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
'			If Sender.Child Then
'				With QToolTips(Sender.Child)
'					 
'				End With
'			End If
'		End Sub
'
'		Sub ToolTips.WndProc(ByRef Message As Message)
'		End Sub
'
'		Sub ToolTips.ProcessMessage(ByRef Message As Message)
'			Base.ProcessMessage(Message)
'		End Sub
'	#EndIf
	
    Operator ToolTips.Cast As My.Sys.ComponentModel.Component Ptr
         Return Cast(My.Sys.ComponentModel.Component Ptr, @This)
    End Operator

    Constructor ToolTips
        With This
            WLet FClassName, "ToolTips"
            WLet FClassAncestor, "tooltips_class32"
            #IfDef __USE_GTK__
				'Widget = gtk_tooltips_new()
			#Else
'				.RegisterClass "ToolTips","tooltips_class32"
'				.Style        = TTS_ALWAYSTIP Or WS_POPUP
'				.ExStyle      = WS_EX_TOPMOST
'				.ChildProc    = @WndProc
'				.OnHandleIsAllocated = @HandleIsAllocated
			#EndIf
'            .Width        = 175
'            .Height       = 21
'            .Child        = @This
		End With
    End Constructor

    Destructor ToolTips
		#IfNDef __USE_GTK__
'			UnregisterClass "ToolTips",GetModuleHandle(NULL)
		#EndIf
    End Destructor
End Namespace
