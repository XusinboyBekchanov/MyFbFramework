'################################################################################
'#  ReBar.bi                                                                    #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#Include Once "ReBar.bi"

Namespace My.Sys.Forms
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
				.DoubleBuffered = True
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
