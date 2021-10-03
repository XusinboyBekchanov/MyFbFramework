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
		LongDate = 0
		ShortDate
		ShortDateCentury
		TimeFormat
		CustomFormat
	End Enum
	
	Type DateTimePicker Extends Control
	Private:
		PressedKey          As Integer
		PressedNumber       As String
		SelStart            As Integer
		SelEnd              As Integer
		PrevPart            As Integer
		PrevDateTimePart    As String
		#ifdef __USE_GTK__
			Dim As GtkWidget Ptr CheckWidget, TextWidget, ButtonWidget, UpDownWidget, PopupWindow, CalendarWidget
			Declare Static Sub SizeAllocate(widget As GtkWidget Ptr, allocation As GdkRectangle Ptr, user_data As Any Ptr)
			Declare Static Function DateTimePicker_Draw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Declare Static Function ExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			Declare Static Sub Entry_Activate(entry As GtkEntry Ptr, user_data As Any Ptr)
			Declare Static Function SpinButton_Input(spin_button As GtkSpinButton Ptr, new_value As Any Ptr, user_data As Any Ptr) As Integer
			Declare Static Function SpinButton_Output(spin_button As GtkSpinButton Ptr, user_data As Any Ptr) As Integer
			Declare Static Sub CheckButton_Toggled(widget As GtkToggleButton Ptr, user_data As Any Ptr)
			Declare Static Sub Button_Clicked(widget As GtkButton Ptr, user_data As Any Ptr)
			Declare Static Sub Calendar_DaySelected(calendar As GtkCalendar Ptr, user_data As Any Ptr)
			Declare Static Function Calendar_FocusOut(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
			Declare Static Function Calendar_KeyPress(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
			Declare Static Function Calendar_KeyRelease(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
			Declare Static Function deactivate_cb(ByVal user_data As gpointer) As gboolean
			Declare Sub SelectRegion(Start As Integer = -1, Direction As Integer = 0)
			Declare Function GetLastDay(lYear As Long, lMonth As Long) As Long
			Declare Sub SetDateTime(PressedNumberValue As Long, DateTimePart As String)
		#else
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#endif
	Protected:
		FDateTimePart       As String
		FFocusChanged       As Boolean
		FAutoNextPart       As Boolean
		FChecked            As Boolean
		FSelectedDate       As Long
		FSelectedDateTime   As Double
		FSelectedTime       As Double
		FRightAlign         As Boolean = False
		FDateFormat         As DateTimePickerFormat = DateTimePickerFormat.ShortDateCentury
		FCustomFormat       As WString Ptr
		FFormat             As WString Ptr
		FShowNone           As Boolean = False
		FShowUpDown         As Boolean = False
		FTimePicker         As Boolean = False
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Declare Property AutoNextPart As Boolean
		Declare Property AutoNextPart(Value As Boolean)
		Declare Property Checked As Boolean
		Declare Property Checked(Value As Boolean)
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
		Declare Property CustomFormat ByRef As WString
		Declare Property CustomFormat(ByRef Value As WString)
		Declare Property ShowNone As Boolean
		Declare Property ShowNone(Value As Boolean)
		Declare Property ShowUpDown As Boolean
		Declare Property ShowUpDown(Value As Boolean)
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Property TimePicker As Boolean
		Declare Property TimePicker(Value As Boolean)
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		OnDateTimeChanged As Sub(ByRef Sender As DateTimePicker)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "DateTimePicker.bas"
#endif
