'################################################################################
'#  MonthCalendar.bi                                                            #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#include once "MonthCalendar.bi"

Namespace My.Sys.Forms
	Function MonthCalendar.ReadProperty(ByRef PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "tabindex": Return @FTabIndex
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function MonthCalendar.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		If Value = 0 Then
			Select Case LCase(PropertyName)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		Else
			Select Case LCase(PropertyName)
			Case "tabindex": TabIndex = QInteger(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		End If
		Return True
	End Function
	
	Property MonthCalendar.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Property MonthCalendar.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	#ifndef __USE_GTK__
		Sub MonthCalendar.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QMonthCalendar(Sender.Child)
					
				End With
			End If
		End Sub
		
		Sub MonthCalendar.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Sub MonthCalendar.ProcessMessage(ByRef Message As Message)
		Base.ProcessMessage(Message)
	End Sub
	
	Operator MonthCalendar.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	Constructor MonthCalendar
		With This
			WLet(FClassName, "MonthCalendar")
			WLet(FClassAncestor, "SysMonthCal32")
			FTabIndex          = -1
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
