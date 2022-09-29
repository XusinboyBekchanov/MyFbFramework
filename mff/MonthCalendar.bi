'################################################################################
'#  MonthCalendar.bi                                                            #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#include once "Control.bi"
#include once "vbcompat.bi"

Namespace My.Sys.Forms
	#define QMonthCalendar(__Ptr__) *Cast(MonthCalendar Ptr, __Ptr__)
	
	Private Type MonthCalendar Extends Control
	Private:
		#ifdef __USE_WINAPI__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#elseif defined(__USE_GTK__)
			Declare Static Sub Calendar_DaySelected(calendar As GtkCalendar Ptr, user_data As Any Ptr)
		#endif
	Protected:
		FSelectedDate    As Long
		FWeekNumbers     As Boolean = False
		FTodayCircle     As Boolean = True
		FTodaySelector   As Boolean = True
		FTrailingDates   As Boolean = True
		FShortDayNames   As Boolean = False
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property SelectedDate() As Long
		Declare Property SelectedDate(ByVal Value As Long)
		Declare Property WeekNumbers() As Boolean
		Declare Property WeekNumbers(ByVal Value As Boolean)
		Declare Property TodayCircle() As Boolean
		Declare Property TodayCircle(ByVal Value As Boolean)
		Declare Property TodaySelector() As Boolean
		Declare Property TodaySelector(ByVal Value As Boolean)
		Declare Property TrailingDates() As Boolean
		Declare Property TrailingDates(ByVal Value As Boolean)
		Declare Property ShortDayNames() As Boolean
		Declare Property ShortDayNames(ByVal Value As Boolean)
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		OnSelect As Sub(ByRef Sender As MonthCalendar)
		OnSelectionChanged As Sub(ByRef Sender As MonthCalendar)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "MonthCalendar.bas"
#endif
