'###############################################################################
'#  DateTimePicker.bi                                                          #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                    #
'###############################################################################

#include once "Control.bi"
#include once "vbcompat.bi"

Namespace My.Sys.Forms
	#define QDateTimePicker(__Ptr__) *Cast(DateTimePicker Ptr, __Ptr__)
	
	Enum DateTimePickerFormat
		LongDate = 1
		ShortDate
		ShortDateCentury
		TimeFormat
		CustomFormat
	End Enum
	
	Type DateTimePicker Extends Control
	Private:
		FSelectedDate       As Long
		FSelectedDateTime   As Double
		FSelectedTime       As Double
		FRightAlign         As Boolean = False
		FDateFormat         As DateTimePickerFormat = DateTimePickerFormat.ShortDateCentury
		FFormatCustom       As WString Ptr
		FShowUpDown         As Boolean = False
		FTimePicker         As Boolean = False
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Declare Property SelectedDate As Long
		Declare Property SelectedDate(Value As Long)
		Declare Property SelectedDateTime As Double
		Declare Property SelectedDateTime(Value As Double)
		Declare Property SelectedTime As Double
		Declare Property SelectedTime(Value As Double)
		Declare Property CalendarRightAlign As Boolean
		Declare Property CalendarRightAlign(Value As Boolean)
		Declare Property DateFormat As DateTimePickerFormat
		Declare Property DateFormat(ByVal Value As DateTimePickerFormat)
		Declare Property FormatCustom ByRef As WString
		Declare Property FormatCustom(ByRef Value As WString)
		Declare Property ShowUpDown As Boolean
		Declare Property ShowUpDown(Value As Boolean)
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
'		Declare Property TimePicker As Boolean
'		Declare Property TimePicker(Value As Boolean)
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		OnDateTimeChanged As Sub(ByRef Sender As DateTimePicker)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "DateTimePicker.bas"
#endif
