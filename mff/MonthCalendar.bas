'################################################################################
'#  MonthCalendar.bi                                                            #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#include once "MonthCalendar.bi"

Namespace My.Sys.Forms
	#ifndef __USE_GTK__
		Sub MonthCalendar.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QMonthCalendar(Sender.Child)
					
				End With
			End If
		End Sub
		
		Sub MonthCalendar.WndProc(ByRef Message As Message)
		End Sub
		
		Sub MonthCalendar.ProcessMessage(ByRef Message As Message)
			Base.ProcessMessage(Message)
		End Sub
	#endif
	
	Operator MonthCalendar.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	Constructor MonthCalendar
		With This
			WLet FClassName, "MonthCalendar"
			WLet FClassAncestor, "SysMonthCal32"
			FTabStop           = True
			#ifdef __USE_GTK__
				widget = gtk_calendar_new ()
				.RegisterClass "MonthCalendar", @This
			#else
				.RegisterClass "MonthCalendar","SysMonthCal32"
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
	
	Destructor MonthCalendar
		#ifndef __USE_GTK__
			UnregisterClass "MonthCalendar",GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
