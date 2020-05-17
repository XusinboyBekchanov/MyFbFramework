'################################################################################
'#  Chart.bi                                                                    #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2019)                                          #
'################################################################################

#include once "Chart.bi"

Namespace My.Sys.Forms
	#ifndef __USE_GTK__
		Sub Chart.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QChart(Sender.Child)
					
				End With
			End If
		End Sub
		
		Sub Chart.WndProc(ByRef Message As Message)
		End Sub
		
		Sub Chart.ProcessMessage(ByRef Message As Message)
		End Sub
	#endif
	
	Operator Chart.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	Constructor Chart
		With This
			WLet FClassName, "Chart"
			'WLet FClassAncestor, "ReBarWindow32"
			#ifndef __USE_GTK__
				.RegisterClass "Chart" ',"ReBarWindow32"
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
	
	Destructor Chart
		#ifndef __USE_GTK__
			UnregisterClass "Chart",GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
