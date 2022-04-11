'###############################################################################
'#  DateTimePicker.bi                                                          #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                    #
'###############################################################################

#include once "DateTimePicker.bi"

Namespace My.Sys.Forms
	Private Function DateTimePicker.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "calendarrightalign": Return @FRightAlign
		Case "checked": Return @FChecked
		Case "dateformat": Return @FDateFormat
		Case "customformat": Return FCustomFormat
		Case "shownone": Return @FShowNone
		Case "showupdown": Return @FShowUpDown
		Case "selecteddate": Return @FSelectedDate
		Case "selecteddatetime": Return @FSelectedDateTime
		Case "selectedtime": Return @FSelectedTime
		Case "tabindex": Return @FTabIndex
		Case "timepicker": Return @FTimePicker
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Private Function DateTimePicker.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "calendarrightalign": CalendarRightAlign = QBoolean(Value)
		Case "checked": Checked = QBoolean(Value)
		Case "dateformat": DateFormat = *Cast(DateTimePickerFormat Ptr, Value)
		Case "customformat": CustomFormat = QWString(Value)
		Case "shownone": ShowNone = QBoolean(Value)
		Case "showupdown": ShowUpDown = QBoolean(Value)
		Case "selecteddate": SelectedDate = QLong(Value)
		Case "selecteddatetime": SelectedDateTime = QDouble(Value)
		Case "selectedtime": SelectedTime = QDouble(Value)
		Case "tabindex": TabIndex = QInteger(Value)
		Case "timepicker": TimePicker = QBoolean(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Private Property DateTimePicker.CustomFormat ByRef As WString
		Return WGet(FCustomFormat)
	End Property
	
	Private Property DateTimePicker.CustomFormat(ByRef Value As WString)
		WLet(FCustomFormat, Value)
		If FHandle Then
			If FDateFormat = DateTimePickerFormat.CustomFormat Then
				#ifdef __USE_GTK__
					WLet FFormat, Replace(Value, "'", """")
					SelectedDateTime = FSelectedDateTime
				#else
					DateTime_SetFormat(FHandle, FCustomFormat)
				#endif
			End If
		End If
	End Property
	
	Private Property DateTimePicker.AutoNextPart As Boolean
		Return FAutoNextPart
	End Property
		
	Private Property DateTimePicker.AutoNextPart(Value As Boolean)
		FAutoNextPart = Value 
	End Property
	
	Private Property DateTimePicker.Checked As Boolean
		If FHandle Then
			#ifdef __USE_GTK__
				FChecked = gtk_toggle_button_get_active(gtk_toggle_button(CheckWidget))
			#else
				FChecked = DateTime_GetSystemTime(FHandle, 0)
			#endif
		End If
		Return FChecked
	End Property
	
	Private Property DateTimePicker.Checked(Value As Boolean)
		FChecked = Value
		If FHandle Then
			#ifdef __USE_GTK__
				gtk_toggle_button_set_active(gtk_toggle_button(CheckWidget), Value)
			#else
				' The incoming date string should be in the format YYYYMMDD
				Dim As SYSTEMTIME pst
				Dim As Double sDateTime = This.SelectedDateTime
				pst.wYear  = Year(sDateTime)
				pst.wMonth = Month(sDateTime)
				pst.wDay   = Day(sDateTime)
				pst.wHour   = Hour(sDateTime)
				pst.wMinute = Minute(sDateTime)
				pst.wSecond = Second(sDateTime)
				If Value Then
					DateTime_SetSystemTime(FHandle, GDT_VALID, @pst)
				Else
					DateTime_SetSystemTime(FHandle, GDT_NONE, @pst)
				End If
			#endif
		End If
	End Property
	
	Private Property DateTimePicker.SelectedDate As Long
		If FHandle Then
			#ifdef __USE_GTK__
				FSelectedDate = DateSerial(Year(FSelectedDateTime), Month(FSelectedDateTime), Day(FSelectedDateTime))
			#else
				Dim As SYSTEMTIME pst
				Dim As DWORD Result
				Result = DateTime_GetSystemTime(FHandle, @pst)
				FSelectedDate = DateSerial(pst.wYear, pst.wMonth, pst.wDay)
				If Result = GDT_NONE Then
					
				End If
			#endif
		End If
		Return FSelectedDate
	End Property
	
	Private Property DateTimePicker.SelectedDate(Value As Long)
		FSelectedDate = Value
		If FHandle Then
			#ifdef __USE_GTK__
				SelectedDateTime = Value + SelectedTime
			#else
				' The incoming date string should be in the format YYYYMMDD
				Dim As SYSTEMTIME pst
				pst.wYear  = Year(Value)
				pst.wMonth = Month(Value)
				pst.wDay   = Day(Value)
				Dim As Double sTime = This.SelectedTime
				pst.wHour   = Hour(sTime)
				pst.wMinute = Minute(sTime)
				pst.wSecond = Second(sTime)
				DateTime_SetSystemTime(FHandle, GDT_VALID, @pst)
			#endif
		End If
	End Property
	
	Private Property DateTimePicker.SelectedDateTime As Double
		If FHandle Then
			#ifndef __USE_GTK__
				Dim As SYSTEMTIME pst
				DateTime_GetSystemTime(FHandle, @pst)
				FSelectedDateTime = DateSerial(pst.wYear, pst.wMonth, pst.wDay) + TimeSerial(pst.wHour, pst.wMinute, pst.wSecond)
			#endif
		End If
		Return FSelectedDateTime
	End Property
	
	Private Property DateTimePicker.SelectedDateTime(Value As Double)
		FSelectedDateTime = Value
		If FHandle Then
			#ifdef __USE_GTK__
				gtk_entry_set_text(gtk_entry(widget), ToUTF8(Format(Value, *FFormat)))
				If OnDateTimeChanged Then OnDateTimeChanged(This)
			#else
				Dim As SYSTEMTIME pst
				pst.wYear  = Year(Value)
				pst.wMonth = Month(Value)
				pst.wDay   = Day(Value)
				pst.wHour   = Hour(Value)
				pst.wMinute = Minute(Value)
				pst.wSecond = Second(Value)
				DateTime_SetSystemTime(FHandle, GDT_VALID, @pst)
			#endif
		End If
	End Property
	
	Private Property DateTimePicker.Text ByRef As WString
		#ifdef __USE_GTK__
			FText = WStr(*gtk_entry_get_text(gtk_entry(widget)))
			Return *FText.vptr
		#else
			Return Base.Text
		#endif
	End Property
	
	Private Property DateTimePicker.Text(ByRef Value As WString)
		If IsDate(Value) Then
			FText = Value
			Dim As Integer Pos1 = InStr(Value, ":")
			If Pos1 > 0 Then
				SelectedDate = DateValue(Trim(..Left(Value, Pos1 - 3)))
				SelectedTime = TimeValue(Trim(Mid(Value, Pos1 - 2)))
			Else
				SelectedDate = DateValue(Trim(Value))
			End If
		End If
	End Property
	
	Private Property DateTimePicker.SelectedTime As Double
		If FHandle Then
			#ifdef __USE_GTK__
				FSelectedTime = TimeSerial(Hour(FSelectedDateTime), Minute(FSelectedDateTime), Second(FSelectedDateTime))
			#else
				Dim As SYSTEMTIME pst
				DateTime_GetSystemTime(FHandle, @pst)
				FSelectedTime = TimeSerial(pst.wHour, pst.wMinute, pst.wSecond)
			#endif
		End If
		Return FSelectedTime
	End Property
	
	Private Property DateTimePicker.SelectedTime(Value As Double)
		FSelectedTime = Value
		If FHandle Then
			#ifdef __USE_GTK__
				SelectedDateTime = SelectedDate + Value
			#else
				Dim As SYSTEMTIME pst
				Dim As Long lDate = This.SelectedDate
				pst.wYear  = Year(lDate)
				pst.wMonth = Month(lDate)
				pst.wDay   = Day(lDate)
				pst.wHour   = Hour(Value)
				pst.wMinute = Minute(Value)
				pst.wSecond = Second(Value)
				DateTime_SetSystemTime(FHandle, GDT_VALID, @pst)
			#endif
		End If
	End Property
	
	Private Property DateTimePicker.CalendarRightAlign As Boolean
		#ifndef __USE_GTK__
			FRightAlign = StyleExists(DTS_RIGHTALIGN)
		#endif
		Return FRightAlign
	End Property
	
	Private Property DateTimePicker.CalendarRightAlign(Value As Boolean)
		FRightAlign = Value
		#ifndef __USE_GTK__
			ChangeStyle DTS_RIGHTALIGN, Value
		#endif
		If FHandle Then RecreateWnd
	End Property
	
	Private Property DateTimePicker.ShowUpDown As Boolean
		#ifndef __USE_GTK__
			FShowUpDown = StyleExists(DTS_UPDOWN)
		#endif
		Return FShowUpDown
	End Property
	
	Private Property DateTimePicker.ShowUpDown(Value As Boolean)
		FShowUpDown = Value
		#ifdef __USE_GTK__
			If Value Then
				widget = UpDownWidget
				gtk_widget_show(UpDownWidget)
				gtk_widget_hide(TextWidget)
				#ifdef __USE_GTK3__
					gtk_widget_hide(ButtonWidget)
				#else
					gtk_widget_hide(ButtonLayoutWidget)
				#endif
			Else
				widget = TextWidget
				gtk_widget_hide(UpDownWidget)
				gtk_widget_show(TextWidget)
				#ifdef __USE_GTK3__
					gtk_widget_show(ButtonWidget)
				#else
					gtk_widget_show(ButtonLayoutWidget)
				#endif
			End If
		#else
			ChangeStyle DTS_UPDOWN, Value
		#endif
		If FHandle Then RecreateWnd
	End Property
	
	Private Property DateTimePicker.ShowNone As Boolean
		#ifndef __USE_GTK__
			FShowNone = StyleExists(DTS_SHOWNONE)
		#endif
		Return FShowNone
	End Property
	
	Private Property DateTimePicker.ShowNone(Value As Boolean)
		FShowNone = Value
		#ifdef __USE_GTK__
			If Value Then
				#ifdef __USE_GTK3__
					gtk_widget_show(CheckWidget)
				#else
					gtk_widget_show(CheckLayoutWidget)
				#endif
			Else
				#ifdef __USE_GTK3__
					gtk_widget_hide(CheckWidget)
				#else
					gtk_widget_hide(CheckLayoutWidget)
				#endif
			End If
		#else
			ChangeStyle DTS_SHOWNONE, Value
		#endif
		If FHandle Then RecreateWnd
	End Property
	
	Private Property DateTimePicker.DateFormat As DateTimePickerFormat
		If FHandle Then
			#ifndef __USE_GTK__
				Dim As DWORD dwStyle = GetWindowLong(FHandle, GWL_STYLE)
				If (dwStyle And DTS_LONGDATEFORMAT) Then
					FDateFormat = DateTimePickerFormat.LongDate
				ElseIf (dwStyle And DTS_SHORTDATEFORMAT) Then
					FDateFormat = DateTimePickerFormat.ShortDate
				ElseIf (dwStyle And DTS_SHORTDATECENTURYFORMAT) Then
					FDateFormat = DateTimePickerFormat.ShortDateCentury
				ElseIf (dwStyle And DTS_TIMEFORMAT) Then
					FDateFormat = DateTimePickerFormat.TimeFormat
				Else
					FDateFormat = DateTimePickerFormat.CustomFormat
				End If
			#endif
		End If
		Return FDateFormat
	End Property
	
	Private Property DateTimePicker.DateFormat(Value As DateTimePickerFormat)
		FDateFormat = Value
		#ifdef __USE_GTK__
			Select Case Value
			Case DateTimePickerFormat.LongDate: WLet FFormat, "dd MMMM yyyy"
			Case DateTimePickerFormat.ShortDate: WLet FFormat, "dd.MM.yyyy"
			Case DateTimePickerFormat.ShortDateCentury: WLet FFormat, "dd.MM.yyyy"
			Case DateTimePickerFormat.TimeFormat: WLet FFormat, "HH:mm:ss"
			Case DateTimePickerFormat.CustomFormat: WLet FFormat, Replace(*FCustomFormat, "'", """")
			End Select
			SelectedDateTime = FSelectedDateTime
		#else
			ChangeStyle DTS_LONGDATEFORMAT, Value = DateTimePickerFormat.LongDate
			ChangeStyle DTS_SHORTDATEFORMAT, Value = DateTimePickerFormat.ShortDate
			ChangeStyle DTS_SHORTDATECENTURYFORMAT, Value =  DateTimePickerFormat.ShortDateCentury
			ChangeStyle DTS_TIMEFORMAT, Value = DateTimePickerFormat.TimeFormat
			If FHandle Then
				' Need to rebuild the control
				RecreateWnd
				If Value = DateTimePickerFormat.CustomFormat Then
					DateTime_SetFormat(FHandle, FCustomFormat)
				End If
			End If
		#endif
	End Property
	
	Private Property DateTimePicker.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property DateTimePicker.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property DateTimePicker.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property DateTimePicker.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	#ifndef __USE_GTK__
		Private Sub DateTimePicker.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QDateTimePicker(Sender.Child)
					If .FDateFormat = DateTimePickerFormat.CustomFormat Then DateTime_SetFormat(.FHandle, .FCustomFormat)
					.SelectedDateTime = .SelectedDateTime
				End With
			End If
		End Sub
		
		Private Sub DateTimePicker.WndProc(ByRef Message As Message)
		End Sub
		
	#endif
	
	Private Property DateTimePicker.TimePicker As Boolean 'David Change
		Return FTimePicker
	End Property
	
	Private Property DateTimePicker.TimePicker(Value As Boolean)'David Change
		If FTimePicker <> Value Then
			FTimePicker = Value
		End If
		#ifdef __USE_GTK__
			If FTimePicker Then
				ShowNone = True
				ShowUpDown = True
				DateFormat = DateTimePickerFormat.TimeFormat
			Else
				ShowNone = False
				ShowUpDown = False
				DateFormat = DateTimePickerFormat.ShortDate
			End If
		#else
			If FTimePicker Then
				This.Style  = WS_CHILD Or DTS_TIMEFOrMAT Or DTS_UPDOWN Or DTS_SHOWNONE ' NO repons
			Else
				This.Style  = WS_CHILD Or DTS_SHORTDATEFORMAT
			End If
			If FHandle Then RecreateWnd
		#endif
	End Property
	
	#ifdef __USE_GTK__
		Private Sub DateTimePicker.SelectRegion(Start As Integer = -1, Direction As Integer = 0)
			Dim As Integer FirstSelStart, FirstSelEnd, Length, iCount, iStart, iEnd, iStep, Steps, CharIndex
			PrevDateTimePart = FDateTimePart
			If Start = -1 Then
				CharIndex = gtk_editable_get_position(gtk_editable(widget))
			Else
				CharIndex = Start
			End If
			Dim As UString res(Any), FormatNew, s, p, f
			Dim As Boolean ToEnd, ToNext
			Split(*FFormat, """", res())
			For i As Integer = 0 To UBound(res)
				If i Mod 2 = 0 Then
					FormatNew &= res(i)
				Else
					FormatNew &= Space(Len(res(i)))
				End If
			Next
			p = ""
			iStart = 0
			For i As Integer = 1 To Len(FormatNew & " ")
				s = Mid(FormatNew, i, 1)
				If p <> s Then
					Length = Len(f)
					Select Case ..Left(f, 1)
					Case "y", "M", "m", "d", "H", "h", "s"
						iCount += 1
						iEnd = i - 1 + Steps
						iStep = 0
						Select Case ..Left(f, 1)
						Case "y"
							If Length = 1 Then
								iStep = 1
								iEnd += iStep
							ElseIf Length = 3 Then
								iStart += 1
							ElseIf Length > 4 Then
								iStart = iEnd - 4 - 1
							End If
						Case "M", "m"
							If ..Left(f, 1) = "m" AndAlso InStr(LCase(..Left(FormatNew, i - 1)), "h") > 0 AndAlso Length < 3 Then
								If Length = 1 Then
									If Minute(FSelectedDateTime) > 9 Then
										iStep = 1
										iEnd += iStep
									End If
								End If
							Else
								f = UCase(f)
								If Length = 1 Then
									If Month(FSelectedDateTime) > 9 Then
										iStep = 1
										iEnd += iStep
									End If
								ElseIf Length = 3 OrElse Length = 4 Then
									iStep = Len(Format(DateSerial(2021, Month(FSelectedDateTime), 1), f)) - Length
									iEnd += iStep
								ElseIf Length > 4 Then
									iStart += Length - 4
									iStep = Len(Format(DateSerial(2021, Month(FSelectedDateTime), 1), f)) - Length
									iEnd += iStep
								End If
							End If
						Case "d"
							If Length = 1 Then
								If Day(FSelectedDateTime) > 9 Then
									iStep = 1
									iEnd += iStep
								End If
							ElseIf Length = 3 OrElse Length = 4 OrElse Length = 5 Then
								iStep = Len(Format(DateSerial(2021, 1, Day(FSelectedDateTime)), f)) - Length
								iEnd += iStep
							ElseIf Length > 5 Then
								iStart += Length - 5
								iStep = 5
								iEnd = iStart + 10 + 1
							End If
						Case "H", "h"
							If Length = 1 Then
								If Hour(FSelectedDateTime) > 9 Then
									iStep = 1
									iEnd += iStep
								End If
							ElseIf Length > 2 Then
								iStart = iEnd - 2 - 1
							End If
						Case "s"
							If Length = 1 Then
								If Second(FSelectedDateTime) > 9 Then
									iStep = 1
									iEnd += iStep
								End If
							ElseIf Length > 2 Then
								iStart = iEnd - 2 - 1
							End If
						End Select
						Steps += iStep
						If Not ToEnd Then
							If CharIndex <= iEnd Then
								If Direction = -1 Then
									If iCount = 1 Then
										ToEnd = True
									Else
										If PrevPart <> iCount - 1 Then SetDateTime(Val(PressedNumber), PrevDateTimePart, FDateTimePart)
										PrevPart = iCount - 1
										gtk_editable_select_region(gtk_editable(widget), *Cast(gint Ptr, @SelStart), *Cast(gint Ptr, @SelEnd))
										Exit Sub
									End If
								End If
							End If
						End If
						SelStart = iStart
						SelEnd = iEnd
						FDateTimePart = f
						If iCount = 1 Then
							FirstSelStart = SelStart
							FirstSelEnd = SelEnd
						End If
						If ToNext Then
							If PrevPart <> iCount Then SetDateTime(Val(PressedNumber), PrevDateTimePart, FDateTimePart)
							PrevPart = iCount
							gtk_editable_select_region(gtk_editable(widget), *Cast(gint Ptr, @SelStart), *Cast(gint Ptr, @SelEnd))
							Exit Sub
						ElseIf Not ToEnd Then
							If CharIndex <= iEnd Then
								If Direction = 0 Then
									If PrevPart <> iCount Then SetDateTime(Val(PressedNumber), PrevDateTimePart, FDateTimePart)
									PrevPart = iCount
									gtk_editable_select_region(gtk_editable(widget), *Cast(gint Ptr, @SelStart), *Cast(gint Ptr, @SelEnd))
									Exit Sub
								ElseIf Direction = 1 Then
									ToNext = True
								End If
							End If
						End If
					End Select
					f = ""
					iStart = i - 1 + Steps
				End If
				f &= s
				p = s
			Next
			If ToEnd Then
				If PrevPart <> iCount Then SetDateTime(Val(PressedNumber), PrevDateTimePart, FDateTimePart)
				PrevPart = iCount
				gtk_editable_select_region(gtk_editable(widget), *Cast(gint Ptr, @SelStart), *Cast(gint Ptr, @SelEnd))
			Else
				If PrevPart <> 1 Then SetDateTime(Val(PressedNumber), PrevDateTimePart, FDateTimePart)
				PrevPart = 1
				SelStart = FirstSelStart
				SelEnd = FirstSelEnd
				gtk_editable_select_region(gtk_editable(widget), *Cast(gint Ptr, @SelStart), *Cast(gint Ptr, @SelEnd))
			End If
		End Sub
		
		Private Function DateTimePicker.GetLastDay(lYear As Long, lMonth As Long) As Long
			Return Day(DateSerial(IIf(lMonth = 12, lYear + 1, lYear), IIf(lMonth = 12, 1, lMonth + 1), 1) - 1)
		End Function
		
		Private Sub DateTimePicker.SetDateTime(PressedNumberValue As Long, DateTimePart As String, NewDateTimePart As String)
			If PressedNumberValue <> 0 Then
				Select Case ..Left(DateTimePart, 1)
				Case "y"
					SelectedDateTime = DateSerial(PressedNumberValue, Month(FSelectedDateTime), Day(FSelectedDateTime)) + SelectedTime
				Case "M"
					SelectedDateTime = DateSerial(Year(FSelectedDateTime), PressedNumberValue, Day(FSelectedDateTime)) + SelectedTime
				Case "d"
					SelectedDateTime = DateSerial(Year(FSelectedDateTime), Month(FSelectedDateTime), PressedNumberValue) + SelectedTime
				Case "H", "h"
					SelectedDateTime = SelectedDate + TimeSerial(PressedNumberValue, Minute(FSelectedDateTime), Second(FSelectedDateTime))
				Case "m"
					SelectedDateTime = SelectedDate + TimeSerial(Hour(FSelectedDateTime), PressedNumberValue, Second(FSelectedDateTime))
				Case "s"
					SelectedDateTime = SelectedDate + TimeSerial(Hour(FSelectedDateTime), Minute(FSelectedDateTime), PressedNumberValue)
				End Select
				PressedNumber = ""
			End If
'			If DateTimePart <> NewDateTimePart AndAlso gtk_is_spin_button(widget) Then
'				Select Case Left(NewDateTimePart, 1)
'				Case "y"
'					gtk_spin_button_set_range(gtk_spin_button(widget), 0, 9999)
'					gtk_spin_button_set_value(gtk_spin_button(widget), Year(FSelectedDateTime))
'				Case "M"
'					gtk_spin_button_set_range(gtk_spin_button(widget), 1, 12)
'					gtk_spin_button_set_value(gtk_spin_button(widget), Month(FSelectedDateTime))
'				Case "d"
'					gtk_spin_button_set_range(gtk_spin_button(widget), 1, GetLastDay(Year(FSelectedDateTime), Month(FSelectedDateTime)))
'					gtk_spin_button_set_value(gtk_spin_button(widget), Day(FSelectedDateTime))
'				Case "H", "h"
'					gtk_spin_button_set_range(gtk_spin_button(widget), 0, 23)
'					gtk_spin_button_set_value(gtk_spin_button(widget), Hour(FSelectedDateTime))
'				Case "m", "n"
'					gtk_spin_button_set_range(gtk_spin_button(widget), 0, 59)
'					gtk_spin_button_set_value(gtk_spin_button(widget), Minute(FSelectedDateTime))
'				Case "s"
'					gtk_spin_button_set_range(gtk_spin_button(widget), 0, 59)
'					gtk_spin_button_set_value(gtk_spin_button(widget), Second(FSelectedDateTime))
'				End Select
'			ElseIf PressedNumberValue <> 0 Then
'				SelectedDateTime = FSelectedDateTime
'			End If
		End Sub
		
		Private Sub DateTimePicker.DatePartUp
			Select Case ..Left(FDateTimePart, 1)
			Case "y"
				SelectedDate = DateSerial(IIf(Year(SelectedDate) = 9999, 1601, Year(SelectedDate) + 1), Month(SelectedDate), Day(SelectedDate))
			Case "M"
				SelectedDate = DateSerial(Year(SelectedDate), IIf(Month(SelectedDate) = 12, 1, Month(SelectedDate) + 1), Day(SelectedDate))
			Case "d"
				SelectedDate = DateSerial(Year(SelectedDate), Month(SelectedDate), IIf(Day(SelectedDate) = GetLastDay(Year(SelectedDate), Month(SelectedDate)), 1, Day(SelectedDate) + 1))
			Case "H", "h"
				SelectedTime = TimeSerial(IIf(Hour(SelectedTime) = 23, 0, Hour(SelectedTime) + 1), Minute(SelectedTime), Second(SelectedTime))
			Case "m"
				SelectedTime = TimeSerial(Hour(SelectedTime), IIf(Minute(SelectedTime) = 59, 0, Minute(SelectedTime) + 1), Second(SelectedTime))
			Case "s"
				SelectedTime = TimeSerial(Hour(SelectedTime), Minute(SelectedTime), IIf(Second(SelectedTime) = 59, 0, Second(SelectedTime) + 1))
			End Select
			SelectRegion SelStart + 1
		End Sub
		
		Private Sub DateTimePicker.DatePartDown
			Select Case ..Left(FDateTimePart, 1)
			Case "y"
				SelectedDate = DateSerial(IIf(Year(SelectedDate) = 1601, 9999, Year(SelectedDate) - 1), Month(SelectedDate), Day(SelectedDate))
			Case "M"
				SelectedDate = DateSerial(Year(SelectedDate), IIf(Month(SelectedDate) = 1, 12, Month(SelectedDate) - 1), Day(SelectedDate))
			Case "d"
				SelectedDate = DateSerial(Year(SelectedDate), Month(SelectedDate), IIf(Day(SelectedDate) = 1, GetLastDay(Year(SelectedDate), Month(SelectedDate)), Day(SelectedDate) - 1))
			Case "H", "h"
				SelectedTime = TimeSerial(IIf(Hour(SelectedTime) = 0, 23, Hour(SelectedTime) - 1), Minute(SelectedTime), Second(SelectedTime))
			Case "m"
				SelectedTime = TimeSerial(Hour(SelectedTime), IIf(Minute(SelectedTime) = 0, 59, Minute(SelectedTime) - 1), Second(SelectedTime))
			Case "s"
				SelectedTime = TimeSerial(Hour(SelectedTime), Minute(SelectedTime), IIf(Second(SelectedTime) = 0, 59, Second(SelectedTime) - 1))
			End Select
			SelectRegion SelStart + 1
		End Sub
	#endif
	
	Private Sub DateTimePicker.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_GTK__
			Dim As GdkEvent Ptr e = Message.event
			Select Case Message.event->Type
			Case GDK_BUTTON_PRESS
'				SelectRegion
'				Message.Result = True
				Return
			Case GDK_BUTTON_RELEASE
				SelectRegion
				#ifdef __USE_GTK3__
'					If Not FDesignMode Then
'						Message.Result = True
'					End If
				#endif
				Return
			Case GDK_FOCUS_CHANGE
				If Cast(GdkEventFocus Ptr, e)->in Then
					SelectRegion 0
					Message.Result = True
					Return
				End If
			Case GDK_SCROLL
				If e->Scroll.direction = GDK_SCROLL_UP Then
					DatePartUp
				Else
					DatePartDown
				End If
			Case GDK_KEY_PRESS
				Select Case e->Key.keyval
				Case GDK_KEY_Escape
					If gtk_widget_get_visible(PopupWindow) Then
						gtk_widget_hide(PopupWindow)
					End If
				Case GDK_KEY_F4
					Button_Clicked(gtk_button(ButtonWidget), @This)
				Case GDK_KEY_TAB, GDK_KEY_Return, GDK_KEY_KP_Enter
				Case Else
					Select Case e->Key.keyval
					Case GDK_KEY_Left
						SelectRegion , -1
					Case GDK_KEY_Right
						SelectRegion , 1
					Case GDK_KEY_Home
						Select Case ..Left(FDateTimePart, 1)
						Case "y"
							SelectedDate = DateSerial(1601, Month(SelectedDate), Day(SelectedDate))
						Case "M"
							SelectedDate = DateSerial(Year(SelectedDate), 1, Day(SelectedDate))
						Case "d"
							SelectedDate = DateSerial(Year(SelectedDate), Month(SelectedDate), 1)
						Case "H", "h"
							SelectedTime = TimeSerial(0, Minute(SelectedTime), Second(SelectedTime))
						Case "m"
							SelectedTime = TimeSerial(Hour(SelectedTime), 0, Second(SelectedTime))
						Case "s"
							SelectedTime = TimeSerial(Hour(SelectedTime), Minute(SelectedTime), 0)
						End Select
						SelectRegion SelStart + 1
					Case GDK_KEY_End
						Select Case ..Left(FDateTimePart, 1)
						Case "y"
							SelectedDate = DateSerial(9999, Month(SelectedDate), Day(SelectedDate))
						Case "M"
							SelectedDate = DateSerial(Year(SelectedDate), 12, Day(SelectedDate))
						Case "d"
							SelectedDate = DateSerial(Year(SelectedDate), Month(SelectedDate), GetLastDay(Year(SelectedDate), Month(SelectedDate)))
						Case "H", "h"
							SelectedTime = TimeSerial(23, Minute(SelectedTime), Second(SelectedTime))
						Case "m"
							SelectedTime = TimeSerial(Hour(SelectedTime), 59, Second(SelectedTime))
						Case "s"
							SelectedTime = TimeSerial(Hour(SelectedTime), Minute(SelectedTime), 59)
						End Select
						SelectRegion SelStart + 1
					Case GDK_KEY_UP
						DatePartUp
					Case GDK_KEY_Down
						DatePartDown
					End Select
					Select Case *e->key.string
					Case "0" To "9"
						PressedNumber &= *e->key.string
						Select Case ..Left(FDateTimePart, 1)
						Case "y"
						Case "M"
							If Len(PressedNumber) = 2 AndAlso (Val(PressedNumber) = 0 OrElse Val(PressedNumber) > 12) Then PressedNumber = *e->key.string
						Case "d"
							If Len(PressedNumber) = 2 AndAlso (Val(PressedNumber) = 0 OrElse Val(PressedNumber) > GetLastDay(Year(SelectedDate), Month(SelectedDate))) Then PressedNumber = *e->key.string
						Case "H", "h"
							If Len(PressedNumber) = 2 AndAlso Val(PressedNumber) > 23 Then PressedNumber = *e->key.string
						Case "m"
							If Len(PressedNumber) = 2 AndAlso Val(PressedNumber) > 59 Then PressedNumber = *e->key.string
						Case "s"
							If Len(PressedNumber) = 2 AndAlso Val(PressedNumber) > 59 Then PressedNumber = *e->key.string
						End Select
						If Not (StartsWith(LCase(FDateTimePart), "mmm") OrElse StartsWith(LCase(FDateTimePart), "ddd")) Then
							Dim As UString txt = Text
							Dim As String sp = " "
							gtk_entry_set_text(gtk_entry(widget), ToUTF8(..Left(txt, SelStart) & String(SelEnd - SelStart - Len(PressedNumber), sp) & Right(PressedNumber, SelEnd - SelStart) & Mid(txt, SelEnd + 1)))
						End If
						SelectRegion SelStart + 1
						If Len(PressedNumber) = IIf(..Left(FDateTimePart, 1) = "y", 4, 2) Then
							If AutoNextPart Then
								SelectRegion , 1
							Else
								SetDateTime Val(PressedNumber), FDateTimePart, FDateTimePart
							End If
						End If
					Case "+", "-", "/", "\", ",", ".", ":"
						SelectRegion , 1
					End Select
					Message.Result = True
					Return
				End Select
			End Select
		#else
			Select Case Message.Msg
			Case WM_KEYDOWN
				PressedKey = LoWord(Message.WParam)
			Case WM_CHAR
				PressedKey = Message.WParam
			Case WM_KEYUP
				PressedKey = 0
				'David Change
				'bShift = GetKeyState(VK_SHIFT) And 8000
				'bCtrl = GetKeyState(VK_CONTROL) And 8000
				If ParentHandle>0 Then
					Select Case message.wParam
					Case VK_RETURN, VK_ESCAPE,VK_LEFT,VK_RIGHT,VK_TAB 'VK_DOWN, VK_UP
						PostMessage(ParentHandle, CM_COMMAND, Message.wParam, 9993)
						'case VK_HOME,VK_END,VK_PRIOR,VK_NEXT,VK_INSERT,VK_DELETE,VK_BACK
						'case VK_MENU 'VK_CONTROL VK_SHIFT
						'print "TextBox VK_MENU: ",VK_MENU
						'case else
					End Select
				End If
				InvalidateRect(Handle,Null,False)
				UpdateWindow Handle
			Case CM_NOTIFY 'WM_PAINT
				Dim lpChange As NMDATETIMECHANGE Ptr = Cast(NMDATETIMECHANGE Ptr, message.lparam)
				Select Case lpChange->nmhdr.code
				Case DTN_DATETIMECHANGE
					If OnDateTimeChanged Then OnDateTimeChanged(This)
					If FAutoNextPart AndAlso PressedKey >= Asc("0") AndAlso PressedKey <= Asc("9") Then
						Perform WM_KEYDOWN, VK_RIGHT, 0
					End If
				End Select
				InvalidateRect(Handle,Null,False)
				UpdateWindow Handle
			Case Else
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Operator DateTimePicker.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Private Sub DateTimePicker.SizeAllocate(widget As GtkWidget Ptr, allocation As GdkRectangle Ptr, user_data As Any Ptr)
			Dim As DateTimePicker Ptr dtp = user_data
			If allocation->width <> dtp->AllocatedWidth OrElse allocation->height <> dtp->AllocatedHeight Then
				Dim As GtkAllocation TextAllocation, CheckAllocation, ButtonAllocation
				dtp->AllocatedWidth = allocation->width
				dtp->AllocatedHeight = allocation->height
				gtk_widget_set_size_request(dtp->Handle, allocation->width, allocation->height)
				gtk_widget_set_size_request(dtp->UpDownWidget, allocation->width, allocation->height)
				#ifndef __USE_GTK3__
					gtk_widget_set_size_request(dtp->ButtonLayoutWidget, allocation->height - 4, allocation->height - 4)
				#endif
				gtk_widget_set_size_request(dtp->ButtonWidget, allocation->height - 2, allocation->height - 2)
				gtk_widget_get_allocation(dtp->Handle, @TextAllocation)
				#ifdef __USE_GTK3__
					gtk_widget_get_allocation(dtp->CheckWidget, @CheckAllocation)
					gtk_widget_get_allocation(dtp->ButtonWidget, @ButtonAllocation)
				#else
					gtk_widget_get_allocation(dtp->CheckLayoutWidget, @CheckAllocation)
					gtk_widget_get_allocation(dtp->ButtonLayoutWidget, @ButtonAllocation)
				#endif
				If dtp->ShowNone Then
					Dim As GdkPixbuf Ptr EmptyPixbuf
					#ifdef __USE_GTK3__
						gtk_layout_move(gtk_layout(widget), dtp->CheckWidget, (allocation->height - CheckAllocation.height) / 2, (allocation->height - CheckAllocation.height) / 2)
						EmptyPixbuf = gdk_pixbuf_new(GDK_COLORSPACE_RGB, True, 8, allocation->height * 2, 16)
					#else
						gtk_layout_move(gtk_layout(widget), dtp->CheckLayoutWidget, (allocation->height - CheckAllocation.height) / 2, (allocation->height - CheckAllocation.height) / 2)
						EmptyPixbuf = gdk_pixbuf_new(GDK_COLORSPACE_RGB, True, 8, 1, 16)
					#endif
					gdk_pixbuf_fill(EmptyPixbuf, 0)
					gtk_entry_set_icon_from_pixbuf(gtk_entry(dtp->Handle), GTK_ENTRY_ICON_PRIMARY, EmptyPixbuf)
					g_object_unref(EmptyPixbuf)
				ElseIf gtk_entry_get_icon_pixbuf(gtk_entry(dtp->Handle), GTK_ENTRY_ICON_PRIMARY) <> 0 Then
					gtk_entry_set_icon_from_pixbuf(gtk_entry(dtp->Handle), GTK_ENTRY_ICON_PRIMARY, 0)
				End If
				If TextAllocation.height > allocation->height Then
					gtk_widget_set_size_request(Widget, allocation->width, TextAllocation.height)
				End If
				#ifdef __USE_GTK3__
					gtk_layout_move(gtk_layout(widget), dtp->ButtonWidget, allocation->width - ButtonAllocation.width, 0)
				#else
					gtk_layout_move(gtk_layout(widget), dtp->ButtonLayoutWidget, allocation->width - allocation->height + 2, 2)
				#endif
				If dtp->OnResize Then dtp->OnResize(*dtp, allocation->width, allocation->height)
			End If
		End Sub
		
		Private Function DateTimePicker.DateTimePicker_Draw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Dim As Control Ptr Ctrl = Cast(Any Ptr, data1)
			If Ctrl <> 0 AndAlso (gtk_is_layout(widget) OrElse gtk_is_event_box(widget)) Then
				Dim allocation As GtkAllocation
				gtk_widget_get_allocation(widget, @allocation)
				If allocation.width <> Ctrl->AllocatedWidth OrElse allocation.height <> Ctrl->AllocatedHeight Then
					SizeAllocate(widget, @allocation, data1)
				End If
				Ctrl->Canvas.HandleSetted = True
				Ctrl->Canvas.Handle = cr
				If Ctrl->OnPaint Then Ctrl->OnPaint(*Ctrl, Ctrl->Canvas)
				Ctrl->Canvas.HandleSetted = False
			End If
			Return False
		End Function
		
		Private Function DateTimePicker.ExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			Dim As cairo_t Ptr cr = gdk_cairo_create(Event->window)
			DateTimePicker_Draw(widget, cr, data1)
			cairo_destroy(cr)
			Return False
		End Function
		
		Private Sub DateTimePicker.Entry_Activate(entry As GtkEntry Ptr, user_data As Any Ptr)
			Dim As DateTimePicker Ptr dtp = user_data
			Dim As Control Ptr btn = dtp->GetForm()->FDefaultButton
			'dtp->SelectedDateTime = dtp->SelectedDateTime
			If btn AndAlso btn->OnClick Then btn->OnClick(*btn)
		End Sub
		
		Private Function DateTimePicker.SpinButton_Input(spin_button As GtkSpinButton Ptr, new_value As Any Ptr, user_data As Any Ptr) As Integer
			Dim As DateTimePicker Ptr dtp = user_data
			If gtk_spin_button_get_value(GTK_spin_button(spin_button)) > 20 Then
				dtp->DatePartDown
			ElseIf gtk_spin_button_get_value(GTK_spin_button(spin_button)) < 20 Then
				dtp->DatePartUp
			End If
			Return True
		End Function
		
		Private Function DateTimePicker.SpinButton_Output(spin_button As GtkSpinButton Ptr, user_data As Any Ptr) As Integer
			Dim As DateTimePicker Ptr dtp = user_data
			gtk_entry_set_text(GTK_ENTRY(spin_button), ToUTF8(Format(dtp->SelectedDateTime, *dtp->FFormat)))
			Return True
		End Function
		
		Private Sub DateTimePicker.CheckButton_Toggled(widget As GtkToggleButton Ptr, user_data As Any Ptr)
			Dim As DateTimePicker Ptr dtp = user_data
			gtk_widget_set_sensitive(dtp->Handle, gtk_toggle_button_get_active(gtk_toggle_button(widget)))
		End Sub
		
		Private Sub DateTimePicker.Button_Clicked(widget As GtkButton Ptr, user_data As Any Ptr)
			Dim As DateTimePicker Ptr dtp = user_data
			If dtp->FFocusChanged Then
				dtp->FFocusChanged = False
			Else
				Dim As gint x, y
				gdk_window_get_origin(gtk_widget_get_window(dtp->Handle), @x, @y)
				Dim As GtkAllocation CalendarAllocation
				gtk_widget_get_allocation(dtp->CalendarWidget, @CalendarAllocation)
				gtk_window_move(gtk_window(dtp->PopupWindow), x + IIf(dtp->CalendarRightAlign, dtp->Width - CalendarAllocation.width, 0), y + dtp->Height)
				Dim SelDate As Long = dtp->SelectedDate
				gtk_calendar_select_month(gtk_calendar(dtp->CalendarWidget), Month(SelDate) - 1, Year(SelDate))
				gtk_calendar_select_day(gtk_calendar(dtp->CalendarWidget), Day(SelDate))
				If Month(SelDate) = Month(Now) AndAlso Year(SelDate) = Year(Now) Then
					gtk_calendar_mark_day(gtk_calendar(dtp->CalendarWidget), Day(Now))
				End If
				gtk_window_set_transient_for(GTK_WINDOW(dtp->PopupWindow), gtk_window(gtk_widget_get_toplevel(dtp->Handle)))
				gtk_widget_show_all(dtp->PopupWindow)
				gtk_window_present(gtk_window(dtp->PopupWindow))
				'				gtk_window_activate_focus(gtk_window(dtp->PopupWindow))
				'				gtk_window_activate_default(gtk_window(dtp->PopupWindow))
				'gtk_widget_grab_focus(dtp->PopupWindow)
			End If
		End Sub
		
		Private Sub DateTimePicker.Calendar_DaySelected(calendar As GtkCalendar Ptr, user_data As Any Ptr)
			Dim As DateTimePicker Ptr dtp = user_data
			Dim As guint y, m, d
			gtk_calendar_get_date(calendar, @y, @m, @d)
			If Month(dtp->SelectedDate) = m + 1 AndAlso Year(dtp->SelectedDate) = y Then
				gtk_widget_hide(dtp->PopupWindow)
				gtk_widget_grab_focus(dtp->Widget)
			End If
			dtp->SelectedDate = DateSerial(y, m + 1, d)
		End Sub
		
		Private Function DateTimePicker.deactivate_cb(ByVal user_data As gpointer) As gboolean
			Dim As DateTimePicker Ptr dtp = user_data
			dtp->FFocusChanged = False
			Return False
		End Function
		
		Private Function DateTimePicker.Calendar_FocusOut(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
			Dim As DateTimePicker Ptr dtp = user_data
			dtp->FFocusChanged = True
			g_timeout_add(500, Cast(GSourceFunc, @deactivate_cb), dtp)
			gtk_widget_hide(dtp->PopupWindow)
			Return True
		End Function
		
		Private Function DateTimePicker.Calendar_KeyPress(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
			Dim As DateTimePicker Ptr dtp = user_data
			Select Case Event->key.keyval
			Case GDK_KEY_Escape
				gtk_widget_hide(dtp->PopupWindow)
			Case GDK_KEY_Return, GDK_KEY_KP_Enter
				Event->key.keyval = GDK_KEY_Space
			End Select
			Return False
		End Function
		
		Private Function DateTimePicker.Calendar_KeyRelease(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
			Return False
		End Function
	#endif
	
	Private Constructor DateTimePicker
		Dim As Boolean Result
		
		'Dim As INITCOMMONCONTROLSEX ICC
		
		'ICC.dwSize = SizeOF(ICC)
		
		'ICC.dwICC  = ICC_DATE_CLASSES
		
		'Result = InitCommonControlsEx(@ICC)
		'If Not Result Then InitCommonControls
		WLet(FFormat, "dd MMMM yyyy")
		FChecked = True
		FTabIndex          = -1
		FTabStop           = True
		With This
			WLet(FClassName, "DateTimePicker")
			WLet(FClassAncestor, "SysDateTimePick32")
			#ifdef __USE_GTK__
				CheckWidget = gtk_check_button_new_with_label("")
				TextWidget = gtk_entry_new()
				ButtonWidget = gtk_button_new_with_label(ToUTF8("˅"))
				UpDownWidget = gtk_spin_button_new_with_range(1, 40, 1)
				gtk_spin_button_set_increments(gtk_spin_button(UpDownWidget), 1, 1)
				'PopupWindow = gtk_window_new(GTK_WINDOW_POPUP)
				PopupWindow = gtk_window_new(GTK_WINDOW_TOPLEVEL)
				'gtk_widget_set_can_focus(PopupWindow, True)
				gtk_window_set_decorated(GTK_WINDOW(PopupWindow), False)
				gtk_window_set_type_hint(GTK_WINDOW(PopupWindow), GDK_WINDOW_TYPE_HINT_POPUP_MENU)
				gtk_window_set_destroy_with_parent(GTK_WINDOW(PopupWindow), True)
				CalendarWidget = gtk_calendar_new()
				gtk_container_add(gtk_container(PopupWindow), CalendarWidget)
				widget = UpDownWidget
				Base.RegisterClass WStr("DateTimePicker"), @This
				widget = TextWidget
				layoutwidget = gtk_layout_new(NULL, NULL)
				gtk_toggle_button_set_active(gtk_toggle_button(CheckWidget), True)
				gtk_widget_set_size_request(layoutwidget, 175, 21)
				gtk_widget_set_size_request(TextWidget, 175, 21)
				gtk_widget_set_size_request(UpDownWidget, 175, 21)
				gtk_widget_set_size_request(ButtonWidget, 21, 21)
				gtk_layout_put(gtk_layout(layoutwidget), TextWidget, 0, 0)
				gtk_layout_put(gtk_layout(layoutwidget), UpDownWidget, 0, 0)
				gtk_widget_set_no_show_all(TextWidget, True)
				gtk_widget_set_no_show_all(UpDownWidget, True)
				gtk_button_set_alignment(gtk_button(ButtonWidget), 0.5, 0.5)
				#ifdef __USE_GTK3__
					gtk_widget_set_no_show_all(CheckWidget, True)
					gtk_widget_set_no_show_all(ButtonWidget, True)
					gtk_widget_show(ButtonWidget)
					gtk_layout_put(gtk_layout(layoutwidget), CheckWidget, 0, 0)
					gtk_layout_put(gtk_layout(layoutwidget), ButtonWidget, 175 - gtk_widget_get_allocated_width(ButtonWidget), 0)
				#else
					CheckLayoutWidget = gtk_layout_new(NULL, NULL)
					ButtonLayoutWidget = gtk_layout_new(NULL, NULL)
					gtk_widget_set_no_show_all(CheckLayoutWidget, True)
					gtk_widget_set_no_show_all(ButtonLayoutWidget, True)
					gtk_widget_set_size_request(CheckWidget, 17, 15)
					gtk_widget_set_size_request(CheckLayoutWidget, 15, 15)
					gtk_widget_set_size_request(ButtonLayoutWidget, 20, 20)
					gtk_layout_put(gtk_layout(CheckLayoutWidget), CheckWidget, -2, 0)
					gtk_layout_put(gtk_layout(ButtonLayoutWidget), ButtonWidget, -1, -1)
					gtk_layout_put(gtk_layout(layoutwidget), CheckLayoutWidget, 0, 0)
					gtk_layout_put(gtk_layout(layoutwidget), ButtonLayoutWidget, 0, (TextWidget->allocation.height - ButtonLayoutWidget->allocation.height) / 2) '175 - ButtonLayoutWidget->allocation.width - 50
					gtk_widget_show(ButtonLayoutWidget)
					gtk_widget_show(CheckWidget)
					gtk_widget_show(ButtonWidget)
				#endif
				gtk_drag_dest_unset(TextWidget)
				gtk_drag_dest_unset(UpDownWidget)
				gtk_drag_source_unset(TextWidget)
				gtk_drag_source_unset(UpDownWidget)
				gtk_widget_set_can_focus(ButtonWidget, False)
				gtk_entry_set_icon_activatable(gtk_entry(TextWidget), GTK_ENTRY_ICON_PRIMARY, False)
				gtk_entry_set_icon_activatable(gtk_entry(UpDownWidget), GTK_ENTRY_ICON_PRIMARY, False)
				g_signal_connect(CheckWidget, "toggled", G_CALLBACK(@CheckButton_Toggled), @This)
				g_signal_connect(gtk_entry(TextWidget), "activate", G_CALLBACK(@Entry_Activate), @This)
				g_signal_connect(gtk_entry(UpDownWidget), "activate", G_CALLBACK(@Entry_Activate), @This)
				g_signal_connect(gtk_entry(UpDownWidget), "input", G_CALLBACK(@SpinButton_Input), @This)
				g_signal_connect(gtk_entry(UpDownWidget), "output", G_CALLBACK(@SpinButton_Output), @This)
				#ifdef __USE_GTK3__
					g_signal_connect(layoutwidget, "draw", G_CALLBACK(@DateTimePicker_Draw), @This)
				#else
					g_signal_connect(layoutwidget, "expose-event", G_CALLBACK(@ExposeEvent), @This)
					g_signal_connect(layoutwidget, "size-allocate", G_CALLBACK(@SizeAllocate), @This)
				#endif
				g_signal_connect(ButtonWidget, "clicked", G_CALLBACK(@Button_Clicked), @This)
				g_signal_connect(CalendarWidget, "day-selected", G_CALLBACK(@Calendar_DaySelected), @This)
				g_signal_connect(CalendarWidget, "focus-out-event", G_CALLBACK(@Calendar_FocusOut), @This)
				g_signal_connect(CalendarWidget, "key-press-event", G_CALLBACK(@Calendar_KeyPress), @This)
				g_signal_connect(CalendarWidget, "key-release-event", G_CALLBACK(@Calendar_KeyRelease), @This)
				gtk_spin_button_set_numeric(gtk_spin_button(UpDownWidget), False)
				
				gtk_spin_button_set_update_policy(gtk_spin_button(UpDownWidget), GTK_UPDATE_ALWAYS)
				gtk_spin_button_set_wrap(gtk_spin_button(UpDownWidget), True)
				Base.RegisterClass WStr("DateTimePicker"), @This
			#else
				Base.RegisterClass WStr("DateTimePicker"), WStr("SysDateTimePick32")
				.ExStyle      = 0 'WS_EX_LEFT OR WS_EX_LTRREADING OR WS_EX_RIGHTSCROLLBAR OR WS_EX_CLIENTEDGE
				.Style        = WS_CHILD Or DTS_SHORTDATEFORMAT
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.SelectedDateTime = Now
			.Width        = 175
			.Height       = 21
			.Child        = @This
		End With
	End Constructor
	
	Private Destructor DateTimePicker
		#ifndef __USE_GTK__
			UnregisterClass "DateTimePicker",GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
