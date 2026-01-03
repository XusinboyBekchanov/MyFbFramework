'###############################################################################
'#  DateTimePicker.bi                                                          #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                    #
'###############################################################################

#include once "Control.bi"
#include once "vbcompat.bi"

Namespace My.Sys.Forms
	#define QDateTimePicker(__Ptr__) (*Cast(DateTimePicker Ptr, __Ptr__))
	
	Private Enum DateTimePickerFormat
		LongDate = 0
		ShortDate
		ShortDateCentury
		TimeFormat
		CustomFormat
	End Enum
	
	'`DateTimePicker` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`DateTimePicker` - Represents a Windows control that allows the user to select a date and a time and to display the date and time with a specified format (Windows, Linux, Web).
	Private Type DateTimePicker Extends Control
	Private:
		PressedKey          As Integer
		PressedNumber       As String
		SelStart            As Integer
		SelEnd              As Integer
		PrevPart            As Integer
		PrevDateTimePart    As String
		#ifdef __USE_GTK__
			#ifndef __USE_GTK3__
				Dim As GtkWidget Ptr CheckLayoutWidget, ButtonLayoutWidget
			#endif
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
			Declare Sub SetDateTime(PressedNumberValue As Long, DateTimePart As String, NewDateTimePart As String)
			Declare Sub DatePartUp
			Declare Sub DatePartDown
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
		#ifndef ReadProperty_Off
			'Loads configuration from persistence stream
			Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves configuration to persistence stream
			Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property AutoNextPart As Boolean
		'Automatically advances focus between date/time segments
		Declare Property AutoNextPart(Value As Boolean)
		Declare Property Checked As Boolean
		'Indicates if a valid value is selected
		Declare Property Checked(Value As Boolean)
		Declare Property SelectedDate As Long
		'Date-only portion of selection
		Declare Property SelectedDate(Value As Long)
		Declare Property SelectedDateTime As Double
		'Complete DateTime value including time
		Declare Property SelectedDateTime(Value As Double)
		Declare Property SelectedTime As Double
		'Time-only portion of selection
		Declare Property SelectedTime(Value As Double)
		Declare Property CalendarRightAlign As Boolean
		'Aligns dropdown calendar to the right edge
		Declare Property CalendarRightAlign(Value As Boolean)
		Declare Property DateFormat As DateTimePickerFormat
		'Predefined format options (Short/Long)
		Declare Property DateFormat(ByVal Value As DateTimePickerFormat)
		Declare Property CustomFormat ByRef As WString
		'Custom datetime format string (e.g., "yyyy-MM-dd HH:mm")
		Declare Property CustomFormat(ByRef Value As WString)
		Declare Property ShowNone As Boolean
		'Displays "None" checkbox for nullable values
		Declare Property ShowNone(Value As Boolean)
		Declare Property ShowUpDown As Boolean
		'Uses spin buttons instead of dropdown
		Declare Property ShowUpDown(Value As Boolean)
		Declare Property TabIndex As Integer
		'Position in tab navigation order
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		'Enables focus via Tab key
		Declare Property TabStop(Value As Boolean)
		Declare Property Text ByRef As WString
		'Formatted display string
		Declare Property Text(ByRef Value As WString)
		Declare Property TimePicker As Boolean
		'Enables time selection component
		Declare Property TimePicker(Value As Boolean)
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		'Triggered when date/time value changes
		OnDateTimeChanged As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As DateTimePicker)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "DateTimePicker.bas"
#endif
