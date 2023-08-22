'################################################################################
'#  MonthCalendar.bi                                                            #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#include once "MonthCalendar.bi"

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function MonthCalendar.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "selecteddate": FSelectedDate = SelectedDate: Return @FSelectedDate
			Case "weeknumbers": Return @FWeekNumbers
			Case "todaycircle": Return @FTodayCircle
			Case "todayselector": Return @FTodaySelector
			Case "trailingdates": Return @FTrailingDates
			Case "shortdaynames": Return @FShortDayNames
			Case "tabindex": Return @FTabIndex
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function MonthCalendar.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "selecteddate": SelectedDate = QLong(Value)
				Case "weeknumbers": WeekNumbers = QBoolean(Value)
				Case "todaycircle": TodayCircle = QBoolean(Value)
				Case "todayselector": TodaySelector = QBoolean(Value)
				Case "trailingdates": TrailingDates = QBoolean(Value)
				Case "shortdaynames": ShortDayNames = QBoolean(Value)
				Case "tabindex": TabIndex = QInteger(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Property MonthCalendar.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property MonthCalendar.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property MonthCalendar.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property MonthCalendar.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Property MonthCalendar.SelectedDate() As Long
		If This.FHandle Then
			#ifdef __USE_GTK__
				Dim As guint y, m, d
				gtk_calendar_get_date(gtk_calendar(FHandle), @y, @m, @d)
				FSelectedDate = DateSerial(y, m + 1, d)
			#elseif defined(__USE_WINAPI__)
				Dim As SYSTEMTIME pst
				MonthCal_GetCurSel(This.FHandle, @pst)
				FSelectedDate = DateSerial(pst.wYear, pst.wMonth, pst.wDay)
			#elseif defined(__USE_JNI__)
				FSelectedDate = (*env)->CallLongMethod(env, FHandle, GetMethodID(*FClassAncestor, "getDate", "()J"))
			#endif
		End If
		Return FSelectedDate
	End Property
	
	Private Property MonthCalendar.SelectedDate(ByVal Value As Long)
		If This.FHandle Then
			#ifdef __USE_GTK__
				gtk_calendar_select_month(gtk_calendar(FHandle), Month(FSelectedDate) - 1, Year(FSelectedDate))
				gtk_calendar_select_day(gtk_calendar(FHandle), Day(FSelectedDate))
				If FTodayCircle Then
					If Month(FSelectedDate) = Month(Now) AndAlso Year(FSelectedDate) = Year(Now) Then
						gtk_calendar_mark_day(gtk_calendar(FHandle), Day(Now))
					Else
						gtk_calendar_unmark_day(gtk_calendar(FHandle), Day(Now))
					End If
				End If
			#elseif defined(__USE_WINAPI__)
				Dim As SYSTEMTIME pst
				pst.wYear  = Year(Value)
				pst.wMonth = Month(Value)
				pst.wDay   = Day(Value)
				MonthCal_SetCurSel(This.FHandle, @pst)
			#elseif defined(__USE_JNI__)
				 (*env)->CallVoidMethod(env, FHandle, GetMethodID(*FClassAncestor, "setDate", "(J)V"), FSelectedDate)
			#endif
		End If
		FSelectedDate = Value
	End Property
	
	
	Private Property MonthCalendar.WeekNumbers() As Boolean
		If This.FHandle Then
			#ifdef __USE_GTK__
				FStyle = gtk_calendar_get_display_options(gtk_calendar(FHandle))
				FWeekNumbers = StyleExists(GTK_CALENDAR_SHOW_WEEK_NUMBERS)
			#elseif defined(__USE_WINAPI__)
				FWeekNumbers = StyleExists(MCS_WEEKNUMBERS)
			#endif
		End If
		Return FWeekNumbers
	End Property
	
	Private Property MonthCalendar.WeekNumbers(ByVal Value As Boolean)
		If This.FHandle Then
			#ifdef __USE_GTK__
				FStyle = gtk_calendar_get_display_options(gtk_calendar(FHandle))
				ChangeStyle GTK_CALENDAR_SHOW_WEEK_NUMBERS, Value
				gtk_calendar_set_display_options(gtk_calendar(FHandle), FStyle)
			#elseif defined(__USE_WINAPI__)
				ChangeStyle MCS_WEEKNUMBERS, Value
				This.Repaint
			#endif
		End If
		FWeekNumbers = Value
	End Property
	
	Private Property MonthCalendar.TodayCircle() As Boolean
		If This.FHandle Then
			#ifdef __USE_WINAPI__
				FTodayCircle = Not StyleExists(MCS_NOTODAYCIRCLE)
			#endif
		End If
		Return FTodayCircle
	End Property
	
	Private Property MonthCalendar.TodayCircle(ByVal Value As Boolean)
		If This.FHandle Then
			#ifdef __USE_WINAPI__
				ChangeStyle MCS_NOTODAYCIRCLE, Not Value
				This.Repaint
			#endif
		End If
		FTodayCircle = Value
	End Property
	
	Private Property MonthCalendar.TodaySelector() As Boolean
		If This.FHandle Then
			#ifdef __USE_WINAPI__
				FTodaySelector = Not StyleExists(MCS_NOTODAY)
			#endif
		End If
		Return FTodaySelector
	End Property
	
	Private Property MonthCalendar.TodaySelector(ByVal Value As Boolean)
		If This.FHandle Then
			#ifdef __USE_WINAPI__
				ChangeStyle MCS_NOTODAY, Not Value
				This.Repaint
			#endif
		End If
		FTodaySelector = Value
	End Property
	
	Private Property MonthCalendar.TrailingDates() As Boolean
		If This.FHandle Then
			#ifdef __USE_WINAPI__
				#if _WIN32_WINNT >= &h0600
					FTrailingDates = Not StyleExists(MCS_NOTRAILINGDATES)
				#endif
				This.Repaint
			#endif
		End If
		Return FTrailingDates
	End Property
	
	Private Property MonthCalendar.TrailingDates(ByVal Value As Boolean)
		If This.FHandle Then
			#ifdef __USE_WINAPI__
				#if _WIN32_WINNT >= &h0600
					ChangeStyle MCS_NOTRAILINGDATES, Not Value
				#endif
				This.Repaint
			#endif
		End If
		FTrailingDates = Value
	End Property
	
	Private Property MonthCalendar.ShortDayNames() As Boolean
		If This.FHandle Then
			#ifdef __USE_GTK__
				FStyle = gtk_calendar_get_display_options(GTK_CALENDAR(FHandle))
				FShortDayNames = StyleExists(GTK_CALENDAR_SHOW_DAY_NAMES)
			#elseif defined(__USE_WINAPI__)
				#if _WIN32_WINNT >= &h0600
					FShortDayNames = StyleExists(MCS_SHORTDAYSOFWEEK)
				#endif
			#endif
		End If
		Return FShortDayNames
	End Property
	
	Private Property MonthCalendar.ShortDayNames(ByVal Value As Boolean)
		If This.FHandle Then
			#ifdef __USE_GTK__
				FStyle = gtk_calendar_get_display_options(GTK_CALENDAR(FHandle))
				ChangeStyle GTK_CALENDAR_SHOW_DAY_NAMES, Value
				gtk_calendar_set_display_options(GTK_CALENDAR(FHandle), FStyle)
			#elseif defined(__USE_WINAPI__)
				#if _WIN32_WINNT >= &h0600
					ChangeStyle MCS_SHORTDAYSOFWEEK, Value
				#endif
				This.Repaint
			#endif
		End If
		FShortDayNames = Value
	End Property
	
	#ifdef __USE_WINAPI__
		Private Sub MonthCalendar.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QMonthCalendar(Sender.Child)
					
				End With
			End If
		End Sub
		
		Private Sub MonthCalendar.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Private Sub MonthCalendar.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_WINAPI__
			Select Case Message.Msg
			Case CM_NOTIFY
				Dim lpChange As NMSELCHANGE Ptr = Cast(NMSELCHANGE Ptr, Message.lParam)
				Select Case lpChange->nmhdr.code
				Case MCN_SELECT
					If OnClick Then OnClick(*Designer, This)
					If OnSelect Then OnSelect(*Designer, This)
				Case MCN_SELCHANGE
					If OnSelectionChanged Then OnSelectionChanged(*Designer, This)
				End Select
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Operator MonthCalendar.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Private Sub MonthCalendar.Calendar_DaySelected(calendar As GtkCalendar Ptr, user_data As Any Ptr)
			Dim As MonthCalendar Ptr cal = user_data
			If cal->OnSelect Then cal->OnSelect(*cal->Designer, *cal)
		End Sub
	#endif
	
	Private Constructor MonthCalendar
		With This
			WLet(FClassName, "MonthCalendar")
			FTabIndex          = -1
			FTabStop           = True
			#ifdef __USE_GTK__
				widget = gtk_calendar_new ()
				g_signal_connect(widget, "day-selected", G_CALLBACK(@Calendar_DaySelected), @This)
				.RegisterClass "MonthCalendar", @This
			#elseif defined(__USE_WINAPI__)
				.RegisterClass "MonthCalendar", "SysMonthCal32"
				WLet(FClassAncestor, "SysMonthCal32")
				.Style        = WS_CHILD
				.ExStyle      = 0
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#elseif defined(__USE_JNI__)
				WLet(FClassAncestor, "android/widget/CalendarView")
			#endif
			.Width        = 175
			.Height       = 21
			.Child        = @This
		End With
	End Constructor
	
	Private Destructor MonthCalendar
		#ifdef __USE_WINAPI__
			UnregisterClass "MonthCalendar",GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
