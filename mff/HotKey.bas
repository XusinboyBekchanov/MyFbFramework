'###############################################################################
'#  HotKey.bi                                                                  #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'###############################################################################

#include once "HotKey.bi"

Namespace My.Sys.Forms
	#ifndef __USE_GTK__
		Sub HotKey.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QHotKey(Sender.Child)
					
				End With
			End If
		End Sub
		
		Sub HotKey.WndProc(ByRef Message As Message)
		End Sub
		
		Sub HotKey.ProcessMessage(ByRef Message As Message)
			Base.ProcessMessage(Message)
		End Sub
	#endif
	
	Operator HotKey.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	Constructor HotKey
		With This
			WLet FClassName, "HotKey"
			WLet FClassAncestor, "msctls_hotkey32"
			FTabStop           = True
			#ifndef __USE_GTK__
				.RegisterClass "HotKey","msctls_hotkey32"
				.Style        = WS_CHILD
				.ExStyle      = 0
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.Width        = 175
			.Height       = 21
			.Child        = @This
		End With
	End Constructor
	
	Destructor HotKey
		#ifndef __USE_GTK__
			UnregisterClass "HotKey",GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
