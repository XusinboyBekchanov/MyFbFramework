'################################################################################
'#  PageScroller.bi                                                             #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#Include Once "PageScroller.bi"

Namespace My.Sys.Forms
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
				.DoubleBuffered = True
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
