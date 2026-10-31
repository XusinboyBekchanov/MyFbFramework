'###############################################################################
'#  DateTimePicker.bi                                                          #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                    #
'###############################################################################

#include once "DateTimePicker.bi"

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
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
	#endif
	
	#ifndef WriteProperty_Off
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
	#endif
	
	Private Property DateTimePicker.CustomFormat ByRef As WString
		Return WGet(FCustomFormat)
	End Property
	
	Private Property DateTimePicker.CustomFormat(ByRef Value As WString)
		WLet(FCustomFormat, Value)
		If FHandle Then
			If FDateFormat = DateTimePickerFormat.CustomFormat Then
				#ifdef __USE_GTK__
					WLet(FFormat, Replace(Value, "'", """"))
					SelectedDateTime = FSelectedDateTime
				#elseif defined(__USE_WINAPI__)
					DateTime_SetFormat(FHandle, FCustomFormat)
				#endif
			End If
		End If
		#ifdef __USE_WASM__
			If FDateFormat = DateTimePickerFormat.CustomFormat Then
				If (InStr(*FCustomFormat, "d") > 0 OrElse InStr(*FCustomFormat, "M") > 0 OrElse InStr(*FCustomFormat, "y") > 0) AndAlso (InStr(*FCustomFormat, "h") > 0 OrElse InStr(*FCustomFormat, "m") > 0 OrElse InStr(*FCustomFormat, "s") > 0) Then
					FType = "datetime-local"
				ElseIf InStr(*FCustomFormat, "h") > 0 OrElse InStr(*FCustomFormat, "m") > 0 OrElse InStr(*FCustomFormat, "s") > 0 Then
					FType = "time"
				Else
					FType = "date"
				End If
			End If
		#endif
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
			#elseif defined(__USE_WINAPI__)
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
			#elseif defined(__USE_WINAPI__)
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
	
	#ifdef __USE_WASM__
		'The value of <input type="date">, "time" and "datetime-local" as a date serial and back
		Private Function DateTimePickerFromHtml(ByRef Value As WString) As Double
			Dim As String s = Value
			Dim As Double Result
			Dim As String sTime
			If Len(s) >= 10 AndAlso Mid(s, 5, 1) = "-" Then
				Result = DateSerial(Val(Mid(s, 1, 4)), Val(Mid(s, 6, 2)), Val(Mid(s, 9, 2)))
				If InStr(s, "T") > 0 Then sTime = Mid(s, InStr(s, "T") + 1)
			ElseIf InStr(s, ":") > 0 Then
				sTime = s
			End If
			If sTime <> "" Then Result += TimeSerial(Val(Mid(sTime, 1, 2)), Val(Mid(sTime, 4, 2)), Val(Mid(sTime, 7, 2)))
			Return Result
		End Function

		Private Function DateTimePickerToHtml(ByRef sType As String, Value As Double) As String
			Select Case sType
			Case "date": Return Format(Value, "yyyy-mm-dd")
			Case "time": Return Format(Value, "hh:nn:ss")
			Case Else: Return Format(Value, "yyyy-mm-dd") & "T" & Format(Value, "hh:nn:ss")
			End Select
		End Function
	#endif

	Private Property DateTimePicker.SelectedDate As Long
		If FHandle Then
			#ifdef __USE_GTK__
				FSelectedDate = DateSerial(Year(FSelectedDateTime), Month(FSelectedDateTime), Day(FSelectedDateTime))
			#elseif defined(__USE_WINAPI__)
				Dim As SYSTEMTIME pst
				Dim As DWORD Result
				Result = DateTime_GetSystemTime(FHandle, @pst)
				FSelectedDate = DateSerial(pst.wYear, pst.wMonth, pst.wDay)
				If Result = GDT_NONE Then
					
				End If
			#elseif defined(__USE_WASM__)
				If FType <> "time" Then FSelectedDate = Int(DateTimePickerFromHtml(Text))
			#elseif defined(__USE_JNI__)
				Dim As Integer YMD = GetPosition(FHandle)
				If YMD > 0 Then FSelectedDate = DateSerial(YMD \ 10000, (YMD \ 100) Mod 100, YMD Mod 100)
			#endif
		End If
		Return FSelectedDate
	End Property
	
	Private Property DateTimePicker.SelectedDate(Value As Long)
		FSelectedDate = Value
		If FHandle Then
			#ifdef __USE_GTK__
				SelectedDateTime = Value + SelectedTime
			#elseif defined(__USE_WINAPI__)
				' The incoming date string should be in the format YYYYMMDD
				Dim As SYSTEMTIME pst
				pst.wYear  = Year(Value)
				pst.wMonth = Month(Value)
				pst.wDay   = Day(Value)
				Dim As Double sTime = This.SelectedTime
				pst.wHour   = Hour(sTime)
				pst.wMinute = Minute(sTime)
				pst.wSecond = Second(sTime)
				DateTime_SetSystemtime(FHandle, GDT_VALID, @pst)
			#elseif defined(__USE_WASM__)
				SetStringValue(FHandle, DateTimePickerToHtml(FType, Value + SelectedTime))
			#elseif defined(__USE_JNI__)
				SetPosition(FHandle, Year(Value) * 10000 + Month(Value) * 100 + Day(Value))
			#endif
		End If
	End Property
	
	Private Property DateTimePicker.SelectedDateTime As Double
		If FHandle Then
			#ifdef __USE_WINAPI__
				Dim As SYSTEMTIME pst
				DateTime_GetSystemtime(FHandle, @pst)
				FSelectedDateTime = DateSerial(pst.wYear, pst.wMonth, pst.wDay) + TimeSerial(pst.wHour, pst.wMinute, pst.wSecond)
			#elseif defined(__USE_WASM__)
				FSelectedDateTime = DateTimePickerFromHtml(Text)
				If FType = "date" Then FSelectedDateTime += FSelectedTime
			#elseif defined(__USE_JNI__)
				FSelectedDateTime = SelectedDate + FSelectedTime
			#endif
		End If
		Return FSelectedDateTime
	End Property
	
	Private Property DateTimePicker.SelectedDateTime(Value As Double)
		FSelectedDateTime = Value
		If FHandle Then
			#ifdef __USE_GTK__
				#ifdef __USE_GTK4__
					gtk_entry_set_text(GTK_ENTRY(widget), ToUtf8(Format(Value, *FFormat)))
				#else
					gtk_entry_buffer_set_text(gtk_entry_get_buffer(GTK_ENTRY(widget)), ToUtf8(Format(Value, *FFormat)), -1)
				#endif
				If OnDateTimeChanged Then OnDateTimeChanged(*Designer, This)
			#elseif defined(__USE_WINAPI__)
				Dim As SYSTEMTIME pst
				pst.wYear  = Year(Value)
				pst.wMonth = Month(Value)
				pst.wDay   = Day(Value)
				pst.wHour   = Hour(Value)
				pst.wMinute = Minute(Value)
				pst.wSecond = Second(Value)
				DateTime_SetSystemtime(FHandle, GDT_VALID, @pst)
			#elseif defined(__USE_WASM__)
				SetStringValue(FHandle, DateTimePickerToHtml(FType, Value))
			#elseif defined(__USE_JNI__)
				FSelectedTime = Frac(Value)
				SetPosition(FHandle, Year(Value) * 10000 + Month(Value) * 100 + Day(Value))
			#endif
		End If
	End Property
	
	Private Property DateTimePicker.Text ByRef As WString
		#ifdef __USE_GTK__
			#ifdef __USE_GTK4__
				WLet(FText, WStr(*gtk_entry_buffer_get_text(gtk_entry_get_buffer(GTK_ENTRY(widget)))))
			#else
				WLet(FText, WStr(*gtk_entry_get_text(GTK_ENTRY(widget))))
			#endif
			If FText = 0 Then Return "" Else Return *FText
		#elseif defined(__USE_WASM__)
			ReadElementValue(@This, FText)
			If FText = 0 Then Return "" Else Return *FText
		#else
			Return Base.Text
		#endif
	End Property
	
	Private Property DateTimePicker.Text(ByRef Value As WString)
		If IsDate(Value) Then
			WLet(FText, Value)
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
			#elseif defined(__USE_WINAPI__)
				Dim As SYSTEMTIME pst
				DateTime_GetSystemTime(FHandle, @pst)
				FSelectedTime = TimeSerial(pst.wHour, pst.wMinute, pst.wSecond)
			#elseif defined(__USE_WASM__)
				If FType <> "date" Then FSelectedTime = Frac(DateTimePickerFromHtml(Text))
			#endif
		End If
		Return FSelectedTime
	End Property
	
	Private Property DateTimePicker.SelectedTime(Value As Double)
		FSelectedTime = Value
		If FHandle Then
			#ifdef __USE_GTK__
				SelectedDateTime = SelectedDate + Value
			#elseif defined(__USE_WINAPI__)
				Dim As SYSTEMTIME pst
				Dim As Long lDate = This.SelectedDate
				pst.wYear  = Year(lDate)
				pst.wMonth = Month(lDate)
				pst.wDay   = Day(lDate)
				pst.wHour   = Hour(Value)
				pst.wMinute = Minute(Value)
				pst.wSecond = Second(Value)
				DateTime_SetSystemTime(FHandle, GDT_VALID, @pst)
			#elseif defined(__USE_WASM__)
				SetStringValue(FHandle, DateTimePickerToHtml(FType, SelectedDate + Value))
			#endif
		End If
	End Property
	
	Private Property DateTimePicker.CalendarRightAlign As Boolean
		#ifdef __USE_WINAPI__
			FRightAlign = StyleExists(DTS_RIGHTALIGN)
		#endif
		Return FRightAlign
	End Property
	
	Private Property DateTimePicker.CalendarRightAlign(Value As Boolean)
		FRightAlign = Value
		#ifdef __USE_WINAPI__
			ChangeStyle DTS_RIGHTALIGN, Value
		#endif
		If FHandle Then RecreateWnd
	End Property
	
	Private Property DateTimePicker.ShowUpDown As Boolean
		#ifdef __USE_WINAPI__
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
				#ifndef __USE_GTK2__
					gtk_widget_hide(ButtonWidget)
				#else
					gtk_widget_hide(ButtonLayoutWidget)
				#endif
			Else
				widget = TextWidget
				gtk_widget_hide(UpDownWidget)
				gtk_widget_show(TextWidget)
				#ifndef __USE_GTK2__
					gtk_widget_show(ButtonWidget)
				#else
					gtk_widget_show(ButtonLayoutWidget)
				#endif
			End If
		#elseif defined(__USE_WINAPI__)
			ChangeStyle DTS_UPDOWN, Value
		#endif
		If FHandle Then RecreateWnd
	End Property
	
	Private Property DateTimePicker.ShowNone As Boolean
		#ifdef __USE_WINAPI__
			FShowNone = StyleExists(DTS_SHOWNONE)
		#endif
		Return FShowNone
	End Property
	
	Private Property DateTimePicker.ShowNone(Value As Boolean)
		FShowNone = Value
		#ifdef __USE_GTK__
			If Value Then
				#ifndef __USE_GTK2__
					gtk_widget_show(CheckWidget)
				#else
					gtk_widget_show(CheckLayoutWidget)
				#endif
			Else
				#ifndef __USE_GTK2__
					gtk_widget_hide(CheckWidget)
				#else
					gtk_widget_hide(CheckLayoutWidget)
				#endif
			End If
		#elseif defined(__USE_WINAPI__)
			ChangeStyle DTS_SHOWNONE, Value
		#endif
		If FHandle Then RecreateWnd
	End Property
	
	Private Property DateTimePicker.DateFormat As DateTimePickerFormat
		If FHandle Then
			#ifdef __USE_WINAPI__
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
			Case DateTimePickerFormat.LongDate: WLet(FFormat, "dd MMMM yyyy")
			Case DateTimePickerFormat.ShortDate: WLet(FFormat, "dd.MM.yyyy")
			Case DateTimePickerFormat.ShortDateCentury: WLet(FFormat, "dd.MM.yyyy")
			Case DateTimePickerFormat.TimeFormat: WLet(FFormat, "HH:mm:ss")
			Case DateTimePickerFormat.CustomFormat: WLet(FFormat, Replace(*FCustomFormat, "'", """"))
			End Select
			SelectedDateTime = FSelectedDateTime
		#elseif defined(__USE_WINAPI__)
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
		#elseif defined(__USE_WASM__)
			Select Case Value
			Case DateTimePickerFormat.LongDate: FType = "date": WLet(FFormat, "dd MMMM yyyy")
			Case DateTimePickerFormat.ShortDate: FType = "date": WLet(FFormat, "dd.MM.yyyy")
			Case DateTimePickerFormat.ShortDateCentury: FType = "date": WLet(FFormat, "dd.MM.yyyy")
			Case DateTimePickerFormat.TimeFormat: FType = "time": WLet(FFormat, "HH:mm:ss")
			Case DateTimePickerFormat.CustomFormat: WLet(FFormat, Replace(*FCustomFormat, "'", """"))
				If (InStr(*FCustomFormat, "d") > 0 OrElse InStr(*FCustomFormat, "M") > 0 OrElse InStr(*FCustomFormat, "y") > 0) AndAlso (InStr(*FCustomFormat, "h") > 0 OrElse InStr(*FCustomFormat, "m") > 0 OrElse InStr(*FCustomFormat, "s") > 0) Then
					FType = "datetime-local"
				ElseIf InStr(*FCustomFormat, "h") > 0 OrElse InStr(*FCustomFormat, "m") > 0 OrElse InStr(*FCustomFormat, "s") > 0 Then
					FType = "time"
				Else
					FType = "date"
				End If
			End Select
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
	
	#ifdef __USE_WINAPI__
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
		
	#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__) OrElse defined(__USE_APPLE__)
		Private Sub DateTimePicker.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QDateTimePicker(Sender.Child)
					.SelectedDateTime = .FSelectedDateTime
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
		#elseif defined(__USE_WINAPI__)
			If FTimePicker Then
				This.Style  = WS_CHILD Or DTS_TIMEFORMAT Or DTS_UPDOWN Or DTS_SHOWNONE ' NO repons
			Else
				This.Style  = WS_CHILD Or DTS_SHORTDATEFORMAT
			End If
			If FHandle Then RecreateWnd
		#elseif defined(__USE_WASM__)
			If FTimePicker Then
				FType = "time"
			Else
				FType = "date"
			End If
			'If FHandle Then RecreateWnd
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
										Dim As gint iSelStart = SelStart, iSelEnd = SelEnd
										gtk_editable_select_region(GTK_EDITABLE(widget), iSelStart, iSelEnd)
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
							Dim As gint iSelStart = SelStart, iSelEnd = SelEnd
							gtk_editable_select_region(GTK_EDITABLE(widget), iSelStart, iSelEnd)
							Exit Sub
						ElseIf Not ToEnd Then
							If CharIndex <= iEnd Then
								If Direction = 0 Then
									If PrevPart <> iCount Then SetDateTime(Val(PressedNumber), PrevDateTimePart, FDateTimePart)
									PrevPart = iCount
									Dim As gint iSelStart = SelStart, iSelEnd = SelEnd
									gtk_editable_select_region(GTK_EDITABLE(widget), iSelStart, iSelEnd)
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
				Dim As gint iSelStart = SelStart, iSelEnd = SelEnd
				gtk_editable_select_region(GTK_EDITABLE(widget), iSelStart, iSelEnd)
			Else
				If PrevPart <> 1 Then SetDateTime(Val(PressedNumber), PrevDateTimePart, FDateTimePart)
				PrevPart = 1
				SelStart = FirstSelStart
				SelEnd = FirstSelEnd
				Dim As gint iSelStart = SelStart, iSelEnd = SelEnd
				gtk_editable_select_region(GTK_EDITABLE(widget), iSelStart, iSelEnd)
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
		#if defined(__USE_WASM__) OrElse defined(__USE_JNI__) OrElse defined(__USE_APPLE__)
			If Message.Msg = CM_CHANGE Then
				#if defined(__USE_JNI__) OrElse defined(__USE_APPLE__)
					Dim As Integer YMD = Message.wParam
					FSelectedDate = DateSerial(YMD \ 10000, (YMD \ 100) Mod 100, YMD Mod 100)
					FSelectedDateTime = FSelectedDate + FSelectedTime
				#else
					FSelectedDateTime = SelectedDateTime
				#endif
				If OnDateTimeChanged Then OnDateTimeChanged(*Designer, This)
				Message.Handled = True
			End If
		#endif
		#ifdef __USE_GTK__
			Dim As GdkEvent Ptr e = Message.event
			' The event fields are read once (GdkEvent is opaque in GTK4)
			Dim As Integer EventType, ScrollDir, FocusIn
			Dim As guint KeyVal
			Dim As String KeyStr
			#ifdef __USE_GTK4__
				EventType = gtk4compat_event_type(e)
				Select Case EventType
				Case GDK_SCROLL
					ScrollDir = gdk_scroll_event_get_direction(e)
					If ScrollDir = GDK_SCROLL_SMOOTH Then
						Dim As gdouble dx, dy
						gdk_scroll_event_get_deltas(e, @dx, @dy)
						ScrollDir = IIf(dy < 0, GDK_SCROLL_UP, GDK_SCROLL_DOWN)
					End If
				Case GDK_KEY_PRESS, GDK_KEY_RELEASE
					KeyVal = gdk_key_event_get_keyval(e)
					Dim As guint32 KeyChar = gdk_keyval_to_unicode(KeyVal)
					If KeyChar > 0 AndAlso KeyChar < 128 Then KeyStr = Chr(KeyChar)
				End Select
			#else
				EventType = e->type
				Select Case EventType
				Case GDK_SCROLL
					ScrollDir = e->scroll.direction
				Case GDK_KEY_PRESS, GDK_KEY_RELEASE
					KeyVal = e->key.keyval
					KeyStr = *e->key.string
				Case GDK_FOCUS_CHANGE
					FocusIn = Cast(GdkEventFocus Ptr, e)->in
				End Select
			#endif
			Select Case EventType
			Case GDK_BUTTON_PRESS
'				SelectRegion
'				Message.Result = True
				Return
			Case GDK_BUTTON_RELEASE
				SelectRegion
				#ifndef __USE_GTK2__
'					If Not FDesignMode Then
'						Message.Result = True
'					End If
				#endif
				Return
			#ifndef __USE_GTK4__
			Case GDK_FOCUS_CHANGE
			#else
			Case -1
			#endif
				If FocusIn Then
					SelectRegion 0
					Message.Result = True
					Return
				End If
			Case GDK_SCROLL
				If ScrollDir = GDK_SCROLL_UP Then
					DatePartUp
				Else
					DatePartDown
				End If
			Case GDK_KEY_PRESS
				Select Case KeyVal
				Case GDK_KEY_Escape
					If gtk_widget_get_visible(PopupWindow) Then
						gtk_widget_hide(PopupWindow)
					End If
				Case GDK_KEY_F4
					Button_Clicked(gtk_button(ButtonWidget), @This)
				Case GDK_KEY_TAB, GDK_KEY_Return, GDK_KEY_KP_Enter
				Case Else
					Select Case KeyVal
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
					Select Case KeyStr
					Case "0" To "9"
						PressedNumber &= KeyStr
						Select Case ..Left(FDateTimePart, 1)
						Case "y"
						Case "M"
							If Len(PressedNumber) = 2 AndAlso (Val(PressedNumber) = 0 OrElse Val(PressedNumber) > 12) Then PressedNumber = KeyStr
						Case "d"
							If Len(PressedNumber) = 2 AndAlso (Val(PressedNumber) = 0 OrElse Val(PressedNumber) > GetLastDay(Year(SelectedDate), Month(SelectedDate))) Then PressedNumber = KeyStr
						Case "H", "h"
							If Len(PressedNumber) = 2 AndAlso Val(PressedNumber) > 23 Then PressedNumber = KeyStr
						Case "m"
							If Len(PressedNumber) = 2 AndAlso Val(PressedNumber) > 59 Then PressedNumber = KeyStr
						Case "s"
							If Len(PressedNumber) = 2 AndAlso Val(PressedNumber) > 59 Then PressedNumber = KeyStr
						End Select
						If Not (StartsWith(LCase(FDateTimePart), "mmm") OrElse StartsWith(LCase(FDateTimePart), "ddd")) Then
							Dim As UString txt = Text
							Dim As String sp = " "
							#ifdef __USE_GTK4__
								gtk_entry_buffer_set_text(gtk_entry_get_buffer(GTK_ENTRY(widget)), ToUtf8(..Left(txt, SelStart) & String(SelEnd - SelStart - Len(PressedNumber), sp) & Right(PressedNumber, SelEnd - SelStart) & Mid(txt, SelEnd + 1)), -1)
							#else
								gtk_entry_set_text(GTK_ENTRY(widget), ToUtf8(..Left(txt, SelStart) & String(SelEnd - SelStart - Len(PressedNumber), sp) & Right(PressedNumber, SelEnd - SelStart) & Mid(txt, SelEnd + 1)))
							#endif
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
		#elseif defined(__USE_WINAPI__)
			Select Case Message.Msg
			Case WM_KEYDOWN
				PressedKey = LoWord(Message.wParam)
			Case WM_CHAR
				PressedKey = Message.wParam
			Case WM_KEYUP
				PressedKey = 0
				'David Change
				'bShift = GetKeyState(VK_SHIFT) And 8000
				'bCtrl = GetKeyState(VK_CONTROL) And 8000
				If ParentHandle>0 Then
					Select Case Message.wParam
					Case VK_RETURN, VK_ESCAPE,VK_LEFT,VK_RIGHT,VK_TAB 'VK_DOWN, VK_UP
						PostMessage(ParentHandle, CM_COMMAND, Message.wParam, 9993)
						'case VK_HOME,VK_END,VK_PRIOR,VK_NEXT,VK_INSERT,VK_DELETE,VK_BACK
						'case VK_MENU 'VK_CONTROL VK_SHIFT
						'print "TextBox VK_MENU: ",VK_MENU
						'case else
					End Select
				End If
				InvalidateRect(Handle,NULL,False)
				UpdateWindow Handle
			Case CM_NOTIFY 'WM_PAINT
				Dim lpChange As NMDATETIMECHANGE Ptr = Cast(NMDATETIMECHANGE Ptr, Message.lParam)
				Select Case lpChange->nmhdr.code
				Case DTN_DATETIMECHANGE
					If OnDateTimeChanged Then OnDateTimeChanged(*Designer, This)
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
				#ifdef __USE_GTK2__
					gtk_widget_set_size_request(dtp->ButtonLayoutWidget, allocation->height - 4, allocation->height - 4)
				#endif
				gtk_widget_set_size_request(dtp->ButtonWidget, allocation->height - 2, allocation->height - 2)
				gtk_widget_get_allocation(dtp->Handle, @TextAllocation)
				#ifndef __USE_GTK2__
					gtk_widget_get_allocation(dtp->CheckWidget, @CheckAllocation)
					gtk_widget_get_allocation(dtp->ButtonWidget, @ButtonAllocation)
				#else
					gtk_widget_get_allocation(dtp->CheckLayoutWidget, @CheckAllocation)
					gtk_widget_get_allocation(dtp->ButtonLayoutWidget, @ButtonAllocation)
				#endif
				If dtp->ShowNone Then
					Dim As GdkPixbuf Ptr EmptyPixbuf
					#ifndef __USE_GTK2__
						gtk_layout_move(GTK_LAYOUT(widget), dtp->CheckWidget, (allocation->height - CheckAllocation.height) / 2, (allocation->height - CheckAllocation.height) / 2)
						EmptyPixbuf = gdk_pixbuf_new(GDK_COLORSPACE_RGB, True, 8, allocation->height * 2, 16)
					#else
						gtk_layout_move(GTK_LAYOUT(widget), dtp->CheckLayoutWidget, (allocation->height - CheckAllocation.height) / 2, (allocation->height - CheckAllocation.height) / 2)
						EmptyPixbuf = gdk_pixbuf_new(GDK_COLORSPACE_RGB, True, 8, 1, 16)
					#endif
					gdk_pixbuf_fill(EmptyPixbuf, 0)
					gtk_entry_set_icon_from_pixbuf(GTK_ENTRY(dtp->Handle), GTK_ENTRY_ICON_PRIMARY, EmptyPixbuf)
					g_object_unref(EmptyPixbuf)
				ElseIf gtk_entry_get_icon_pixbuf(GTK_ENTRY(dtp->Handle), GTK_ENTRY_ICON_PRIMARY) <> 0 Then
					gtk_entry_set_icon_from_pixbuf(GTK_ENTRY(dtp->Handle), GTK_ENTRY_ICON_PRIMARY, 0)
				End If
				If TextAllocation.height > allocation->height Then
					gtk_widget_set_size_request(widget, allocation->width, TextAllocation.height)
				End If
				#ifndef __USE_GTK2__
					gtk_layout_move(GTK_LAYOUT(widget), dtp->ButtonWidget, allocation->width - ButtonAllocation.width, 0)
				#else
					gtk_layout_move(GTK_LAYOUT(widget), dtp->ButtonLayoutWidget, allocation->width - allocation->height + 2, 2)
				#endif
				If dtp->OnResize Then dtp->OnResize(*dtp->Designer, *dtp, dtp->UnScaleX(allocation->width), dtp->UnScaleY(allocation->height))
			End If
		End Sub
		
		Private Function DateTimePicker.DateTimePicker_Draw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Dim As Control Ptr Ctrl = Cast(Any Ptr, data1)
			If Ctrl <> 0 AndAlso (GTK_IS_LAYOUT(widget) OrElse GTK_IS_EVENT_BOX(widget)) Then
				Dim allocation As GtkAllocation
				gtk_widget_get_allocation(widget, @allocation)
				#ifndef __USE_GTK4__
					If allocation.width <> Ctrl->AllocatedWidth OrElse allocation.height <> Ctrl->AllocatedHeight Then
						SizeAllocate(widget, @allocation, data1)
					End If
				#endif
				Ctrl->Canvas.HandleSetted = True
				Ctrl->Canvas.Handle = cr
				If Ctrl->OnPaint Then Ctrl->OnPaint(*Ctrl->Designer, *Ctrl, Ctrl->Canvas)
				Ctrl->Canvas.HandleSetted = False
			End If
			Return False
		End Function
		
		Private Function DateTimePicker.ExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			#ifndef __USE_GTK4__
				Dim As cairo_t Ptr cr = gdk_cairo_create(Event->window)
				DateTimePicker_Draw(widget, cr, data1)
				cairo_destroy(cr)
			#endif
			Return False
		End Function
		
		Private Sub DateTimePicker.Entry_Activate(entry As GtkEntry Ptr, user_data As Any Ptr)
			Dim As DateTimePicker Ptr dtp = user_data
			Dim As Control Ptr btn = dtp->GetForm()->FDefaultButton
			'dtp->SelectedDateTime = dtp->SelectedDateTime
			If btn AndAlso btn->OnClick Then btn->OnClick(*btn->Designer, *btn)
		End Sub
		
		Private Function DateTimePicker.SpinButton_Input(spin_button As GtkSpinButton Ptr, new_value As Any Ptr, user_data As Any Ptr) As Integer
			Dim As DateTimePicker Ptr dtp = user_data
			If gtk_spin_button_get_value(GTK_SPIN_BUTTON(spin_button)) > 20 Then
				dtp->DatePartDown
			ElseIf gtk_spin_button_get_value(GTK_SPIN_BUTTON(spin_button)) < 20 Then
				dtp->DatePartUp
			End If
			Return True
		End Function
		
		Private Function DateTimePicker.SpinButton_Output(spin_button As GtkSpinButton Ptr, user_data As Any Ptr) As Integer
			Dim As DateTimePicker Ptr dtp = user_data
			#ifdef __USE_GTK4__
				gtk_editable_set_text(GTK_EDITABLE(spin_button), ToUtf8(Format(dtp->SelectedDateTime, *dtp->FFormat)))
			#else
				gtk_entry_set_text(GTK_ENTRY(spin_button), ToUtf8(Format(dtp->SelectedDateTime, *dtp->FFormat)))
			#endif
			Return True
		End Function
		
		Private Sub DateTimePicker.CheckButton_Toggled(widget As GtkToggleButton Ptr, user_data As Any Ptr)
			Dim As DateTimePicker Ptr dtp = user_data
			#ifdef __USE_GTK4__
				gtk_widget_set_sensitive(dtp->Handle, gtk_check_button_get_active(GTK_CHECK_BUTTON(widget)))
			#else
				gtk_widget_set_sensitive(dtp->Handle, gtk_toggle_button_get_active(GTK_TOGGLE_BUTTON(widget)))
			#endif
		End Sub
		
		Private Sub DateTimePicker.Button_Clicked(widget As GtkButton Ptr, user_data As Any Ptr)
			Dim As DateTimePicker Ptr dtp = user_data
			If dtp->FFocusChanged Then
				dtp->FFocusChanged = False
			Else
				#ifdef __USE_GTK4__
					' The calendar is in a popover under the control
					Dim SelDate As Long = dtp->SelectedDate
					Dim As GDateTime Ptr dt = g_date_time_new_local(Year(SelDate), Month(SelDate), Day(SelDate), 0, 0, 0)
					gtk_calendar_select_day(GTK_CALENDAR(dtp->CalendarWidget), dt)
					g_date_time_unref(dt)
					gtk_calendar_clear_marks(GTK_CALENDAR(dtp->CalendarWidget))
					If Month(SelDate) = Month(Now) AndAlso Year(SelDate) = Year(Now) Then
						gtk_calendar_mark_day(GTK_CALENDAR(dtp->CalendarWidget), Day(Now))
					End If
					Dim As GdkRectangle r
					r.x = IIf(dtp->CalendarRightAlign, gtk_widget_get_width(dtp->layoutwidget), 0)
					r.y = gtk_widget_get_height(dtp->layoutwidget)
					r.width = 1: r.height = 1
					gtk_popover_set_pointing_to(GTK_POPOVER(dtp->PopupWindow), @r)
					gtk_popover_popup(GTK_POPOVER(dtp->PopupWindow))
				#else
				Dim As gint x, y
				gdk_window_get_origin(gtk_widget_get_window(dtp->Handle), @x, @y)
				Dim As GtkAllocation CalendarAllocation
				gtk_widget_get_allocation(dtp->CalendarWidget, @CalendarAllocation)
				gtk_window_move(GTK_WINDOW(dtp->PopupWindow), x + IIf(dtp->CalendarRightAlign, dtp->Width - CalendarAllocation.width, 0), y + dtp->Height)
				Dim SelDate As Long = dtp->SelectedDate
				gtk_calendar_select_month(gtk_calendar(dtp->CalendarWidget), Month(SelDate) - 1, Year(SelDate))
				#ifdef __USE_GTK4__
					gtk4compat_calendar_select_day(gtk_calendar(dtp->CalendarWidget), Day(SelDate))
				#else
					gtk_calendar_select_day(gtk_calendar(dtp->CalendarWidget), Day(SelDate))
				#endif
				If Month(SelDate) = Month(Now) AndAlso Year(SelDate) = Year(Now) Then
					gtk_calendar_mark_day(gtk_calendar(dtp->CalendarWidget), Day(Now))
				End If
				gtk_window_set_transient_for(GTK_WINDOW(dtp->PopupWindow), gtk_window(gtk_widget_get_toplevel(dtp->Handle)))
				gtk_widget_show_all(dtp->PopupWindow)
				gtk_window_present(gtk_window(dtp->PopupWindow))
				'				gtk_window_activate_focus(gtk_window(dtp->PopupWindow))
				'				gtk_window_activate_default(gtk_window(dtp->PopupWindow))
				'gtk_widget_grab_focus(dtp->PopupWindow)
				#endif
			End If
		End Sub
		
		Private Sub DateTimePicker.Calendar_DaySelected(calendar As GtkCalendar Ptr, user_data As Any Ptr)
			Dim As DateTimePicker Ptr dtp = user_data
			Dim As guint y, m, d
			#ifdef __USE_GTK4__
				' GTK3 months are 0-based
				Dim As GDateTime Ptr dt = gtk_calendar_get_date(calendar)
				y = g_date_time_get_year(dt): m = g_date_time_get_month(dt) - 1: d = g_date_time_get_day_of_month(dt)
				g_date_time_unref(dt)
			#else
				gtk_calendar_get_date(calendar, @y, @m, @d)
			#endif
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
			#ifndef __USE_GTK4__
				Select Case Event->key.keyval
				Case GDK_KEY_Escape
					gtk_widget_hide(dtp->PopupWindow)
				Case GDK_KEY_Return, GDK_KEY_KP_Enter
					Event->key.keyval = GDK_KEY_Space
				End Select
			#endif
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
				CalendarWidget = gtk_calendar_new()
				#ifdef __USE_GTK4__
					PopupWindow = gtk_popover_new()
					gtk_popover_set_child(GTK_POPOVER(PopupWindow), CalendarWidget)
					gtk_popover_set_position(GTK_POPOVER(PopupWindow), GTK_POS_BOTTOM)
				#else
					PopupWindow = gtk_window_new(GTK_WINDOW_TOPLEVEL)
					'gtk_widget_set_can_focus(PopupWindow, True)
					gtk_window_set_decorated(GTK_WINDOW(PopupWindow), False)
					gtk_window_set_type_hint(GTK_WINDOW(PopupWindow), GDK_WINDOW_TYPE_HINT_POPUP_MENU)
					gtk_window_set_destroy_with_parent(GTK_WINDOW(PopupWindow), True)
					gtk_container_add(gtk_container(PopupWindow), CalendarWidget)
				#endif
				widget = UpDownWidget
				Base.RegisterClass WStr("DateTimePicker"), @This
				widget = TextWidget
				layoutwidget = gtk_layout_new(NULL, NULL)
				#ifdef __USE_GTK4__
					gtk_widget_set_parent(PopupWindow, layoutwidget)
					gtk_check_button_set_active(GTK_CHECK_BUTTON(CheckWidget), True)
				#else
					gtk_toggle_button_set_active(gtk_toggle_button(CheckWidget), True)
				#endif
				gtk_widget_set_size_request(layoutwidget, 175, 21)
				gtk_widget_set_size_request(TextWidget, 175, 21)
				gtk_widget_set_size_request(UpDownWidget, 175, 21)
				gtk_widget_set_size_request(ButtonWidget, 21, 21)
				gtk_layout_put(gtk_layout(layoutwidget), TextWidget, 0, 0)
				gtk_layout_put(gtk_layout(layoutwidget), UpDownWidget, 0, 0)
				gtk_widget_set_no_show_all(TextWidget, True)
				gtk_widget_set_no_show_all(UpDownWidget, True)
				gtk_button_set_alignment(gtk_button(ButtonWidget), 0.5, 0.5)
				#ifndef __USE_GTK2__
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
				#ifndef __USE_GTK4__
					gtk_drag_dest_unset(TextWidget)
					gtk_drag_dest_unset(UpDownWidget)
					gtk_drag_source_unset(TextWidget)
					gtk_drag_source_unset(UpDownWidget)
				#endif
				gtk_widget_set_can_focus(ButtonWidget, False)
				gtk_entry_set_icon_activatable(gtk_entry(TextWidget), GTK_ENTRY_ICON_PRIMARY, False)
				g_signal_connect(CheckWidget, "toggled", G_CALLBACK(@CheckButton_Toggled), @This)
				g_signal_connect(TextWidget, "activate", G_CALLBACK(@Entry_Activate), @This)
				#ifdef __USE_GTK4__
					' GtkSpinButton is not a GtkEntry in GTK4
					g_signal_connect(UpDownWidget, "activate", G_CALLBACK(@Entry_Activate), @This)
					g_signal_connect(UpDownWidget, "input", G_CALLBACK(@SpinButton_Input), @This)
					g_signal_connect(UpDownWidget, "output", G_CALLBACK(@SpinButton_Output), @This)
				#else
					gtk_entry_set_icon_activatable(gtk_entry(UpDownWidget), GTK_ENTRY_ICON_PRIMARY, False)
					g_signal_connect(gtk_entry(UpDownWidget), "activate", G_CALLBACK(@Entry_Activate), @This)
					g_signal_connect(gtk_entry(UpDownWidget), "input", G_CALLBACK(@SpinButton_Input), @This)
					g_signal_connect(gtk_entry(UpDownWidget), "output", G_CALLBACK(@SpinButton_Output), @This)
				#endif
				#ifdef __USE_GTK4__
					mff_widget_set_draw_func(layoutwidget, @DateTimePicker_Draw, @This)
					mff_widget_set_size_allocate_func(layoutwidget, @SizeAllocate, @This)
				#elseif Not defined(__USE_GTK2__)
					#ifdef __USE_GTK4__
						gtk4compat_signal_connect(layoutwidget, "draw", G_CALLBACK(@DateTimePicker_Draw), @This)
					#else
						g_signal_connect(layoutwidget, "draw", G_CALLBACK(@DateTimePicker_Draw), @This)
					#endif
				#else
					g_signal_connect(layoutwidget, "expose-event", G_CALLBACK(@ExposeEvent), @This)
					#ifdef __USE_GTK4__
						gtk4compat_signal_connect(layoutwidget, "size-allocate", G_CALLBACK(@SizeAllocate), @This)
					#else
						g_signal_connect(layoutwidget, "size-allocate", G_CALLBACK(@SizeAllocate), @This)
					#endif
				#endif
				g_signal_connect(ButtonWidget, "clicked", G_CALLBACK(@Button_Clicked), @This)
				g_signal_connect(CalendarWidget, "day-selected", G_CALLBACK(@Calendar_DaySelected), @This)
				#ifndef __USE_GTK4__
					' The popover closes itself (Escape, click outside)
					#ifdef __USE_GTK4__
						gtk4compat_signal_connect(CalendarWidget, "focus-out-event", G_CALLBACK(@Calendar_FocusOut), @This)
					#else
						g_signal_connect(CalendarWidget, "focus-out-event", G_CALLBACK(@Calendar_FocusOut), @This)
					#endif
					#ifdef __USE_GTK4__
						gtk4compat_signal_connect(CalendarWidget, "key-press-event", G_CALLBACK(@Calendar_KeyPress), @This)
					#else
						g_signal_connect(CalendarWidget, "key-press-event", G_CALLBACK(@Calendar_KeyPress), @This)
					#endif
					#ifdef __USE_GTK4__
						gtk4compat_signal_connect(CalendarWidget, "key-release-event", G_CALLBACK(@Calendar_KeyRelease), @This)
					#else
						g_signal_connect(CalendarWidget, "key-release-event", G_CALLBACK(@Calendar_KeyRelease), @This)
					#endif
				#endif
				gtk_spin_button_set_numeric(gtk_spin_button(UpDownWidget), False)
				
				gtk_spin_button_set_update_policy(gtk_spin_button(UpDownWidget), GTK_UPDATE_ALWAYS)
				gtk_spin_button_set_wrap(gtk_spin_button(UpDownWidget), True)
				Base.RegisterClass WStr("DateTimePicker"), @This
			#elseif defined(__USE_WINAPI__)
				Base.RegisterClass WStr("DateTimePicker"), WStr("SysDateTimePick32")
				.ExStyle      = 0 'WS_EX_LEFT OR WS_EX_LTRREADING OR WS_EX_RIGHTSCROLLBAR OR WS_EX_CLIENTEDGE
				.Style        = WS_CHILD Or DTS_SHORTDATEFORMAT
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#elseif defined(__USE_WASM__)
				WLet(FClassAncestor, "input")
				FType = "date"
				.OnHandleIsAllocated = @HandleIsAllocated
			#elseif defined(__USE_JNI__)
				WLet(FClassAncestor, "mff:DatePicker")
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.SelectedDateTime = Now
			.Width        = 175
			.Height       = 21
			.Child        = @This
		End With
	End Constructor
	
	Private Destructor DateTimePicker
		#ifdef __USE_WINAPI__
			'UnregisterClass "DateTimePicker",GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
