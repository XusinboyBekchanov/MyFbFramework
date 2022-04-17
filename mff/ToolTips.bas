'################################################################################
'#  ToolTips.bi                                                                 #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#include once "ToolTips.bi"

Namespace My.Sys.Forms
	#ifndef __USE_GTK__
		Sub ToolTips.HandleIsAllocated(ByRef Sender As Control)
			With QToolTips(@Sender)
				
			End With
		End Sub
		
		Sub ToolTips.WndProc(ByRef Message As Message)
		End Sub
		
		Sub ToolTips.ProcessMessage(ByRef Message As Message)
			Select Case Message.Msg
			Case WM_MOUSEMOVE
				Message.Result = -1
				Return
			End Select
			Base.ProcessMessage(Message)
		End Sub
	#endif
	
	Private Operator ToolTips.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Constructor ToolTips
		With This
			WLet(FClassName, "ToolTips")
			WLet(FClassAncestor, "tooltips_class32")
			#ifdef __USE_GTK__
				'Widget = gtk_tooltips_new()
			#else
				.RegisterClass "ToolTips", "tooltips_class32"
				.Style        = WS_POPUP
				.ExStyle      = WS_EX_TOPMOST
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.Width        = 175
			.Height       = 21
			.Child        = @This
		End With
	End Constructor
	
	Private Destructor ToolTips
		#ifndef __USE_GTK__
			UnregisterClass "ToolTips", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
