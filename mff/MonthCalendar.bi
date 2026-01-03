'################################################################################
'#  MonthCalendar.bi                                                            #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#include once "Control.bi"
#include once "vbcompat.bi"

Namespace My.Sys.Forms
	#define QMonthCalendar(__Ptr__) (*Cast(MonthCalendar Ptr, __Ptr__))
	
	'`MonthCalendar` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`MonthCalendar` - Represents a Windows control that enables the user to select a date using a visual monthly calendar display (Windows, Linux, Android).
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
			'Loads calendar config from persistence stream
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves calendar config to persistence stream
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Currently selected date value
		Declare Property SelectedDate() As Long
		'Currently selected date value
		Declare Property SelectedDate(ByVal Value As Long)
		'Shows week numbers in left margin
		Declare Property WeekNumbers() As Boolean
		'Shows week numbers in left margin
		Declare Property WeekNumbers(ByVal Value As Boolean)
		'Highlights current date with circular marker
		Declare Property TodayCircle() As Boolean
		'Highlights current date with circular marker
		Declare Property TodayCircle(ByVal Value As Boolean)
		'Visually indicates today's date
		Declare Property TodaySelector() As Boolean
		'Visually indicates today's date
		Declare Property TodaySelector(ByVal Value As Boolean)
		'Displays dates from adjacent months (grayed out)
		Declare Property TrailingDates() As Boolean
		'Displays dates from adjacent months (grayed out)
		Declare Property TrailingDates(ByVal Value As Boolean)
		'Custom abbreviated day names (e.g., "Mon", "Tue")
		Declare Property ShortDayNames() As Boolean
		'Custom abbreviated day names (e.g., "Mon", "Tue")
		Declare Property ShortDayNames(ByVal Value As Boolean)
		Declare Property TabIndex As Integer
		'Position in tab navigation order
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		'Enables focus via Tab key
		Declare Property TabStop(Value As Boolean)
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		'Triggered during date selection
		OnSelect As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As MonthCalendar)
		'Raised after date selection changes
		OnSelectionChanged As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As MonthCalendar)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "MonthCalendar.bas"
#endif
