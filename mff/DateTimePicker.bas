'###############################################################################
'#  DateTimePicker.bi                                                          #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                    #
'###############################################################################

#include once "DateTimePicker.bi"

Namespace My.Sys.Forms
	Function DateTimePicker.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "calendarrightalign": Return @FRightAlign
		Case "dateformat": Return @FDateFormat
		Case "formatcustom": Return FFormatCustom
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
	
	Function DateTimePicker.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "calendarrightalign": CalendarRightAlign = QBoolean(Value) 
		Case "dateformat": DateFormat = *Cast(DateTimePickerFormat Ptr, Value)
		Case "formatcustom": FormatCustom = QWString(Value)
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
	
	Property DateTimePicker.FormatCustom ByRef As WString
		Return WGet(FFormatCustom)
	End Property
	
	Property DateTimePicker.FormatCustom(ByRef Value As WString)
		WLet FFormatCustom, Value
		If FHandle Then
			If FDateFormat = DateTimePickerFormat.CustomFormat Then
				#ifndef __USE_GTK__
					DateTime_SetFormat(FHandle, FFormatCustom)
				#endif
			End If
		End If
	End Property
	
	Property DateTimePicker.SelectedDate As Long
		If FHandle Then
			#ifndef __USE_GTK__
				Dim As SYSTEMTIME pst
				DateTime_GetSystemTime(FHandle, @pst)
				FSelectedDate = DateSerial(pst.wYear, pst.wMonth, pst.wDay)
			#endif
		End If
		Return FSelectedDate
	End Property
	
	Property DateTimePicker.SelectedDate(Value As Long)
		FSelectedDate = Value
		If FHandle Then
			#ifndef __USE_GTK__
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
	
	Property DateTimePicker.SelectedDateTime As Double
		If FHandle Then
			#ifndef __USE_GTK__
				Dim As SYSTEMTIME pst
				DateTime_GetSystemTime(FHandle, @pst)
				FSelectedDateTime = DateSerial(pst.wYear, pst.wMonth, pst.wDay) + TimeSerial(pst.wHour, pst.wMinute, pst.wSecond)
			#endif
		End If
		Return FSelectedDateTime
	End Property
	
	Property DateTimePicker.SelectedDateTime(Value As Double)
		FSelectedDateTime = Value
		If FHandle Then
			#ifndef __USE_GTK__
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
	
	Property DateTimePicker.Text ByRef As WString
		Return Base.Text
	End Property
	
	Property DateTimePicker.Text(ByRef Value As WString)
		FText = Value
		Dim As Integer Pos1 = InStr(Value, ":")
		If Pos1 > 0 Then
			SelectedDate = DateValue(Trim(Left(Value, Pos1 - 3)))
			SelectedTime = TimeValue(Trim(Mid(Value, Pos1 - 2)))
		Else
			SelectedDate = DateValue(Trim(Value))
		End If
	End Property
	
	Property DateTimePicker.SelectedTime As Double
		If FHandle Then
			#ifndef __USE_GTK__
				Dim As SYSTEMTIME pst
				DateTime_GetSystemTime(FHandle, @pst)
				FSelectedTime = TimeSerial(pst.wHour, pst.wMinute, pst.wSecond)
			#endif
		End If
		Return FSelectedTime
	End Property
	
	Property DateTimePicker.SelectedTime(Value As Double)
		FSelectedTime = Value
		If FHandle Then
			#ifndef __USE_GTK__
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
	
	Property DateTimePicker.CalendarRightAlign As Boolean
		#ifndef __USE_GTK__
			FRightAlign = StyleExists(DTS_RIGHTALIGN)
		#endif
		Return FRightAlign
	End Property
	
	Property DateTimePicker.CalendarRightAlign(Value As Boolean)
		FRightAlign = Value
		#ifndef __USE_GTK__
			ChangeStyle DTS_RIGHTALIGN, Value
		#endif
		If FHandle Then RecreateWnd
	End Property
	
	Property DateTimePicker.ShowUpDown As Boolean
		#ifndef __USE_GTK__
			FShowUpDown = StyleExists(DTS_UPDOWN)
		#endif
		Return FShowUpDown
	End Property
	
	Property DateTimePicker.ShowUpDown(Value As Boolean)
		FShowUpDown = Value
		#ifndef __USE_GTK__
			ChangeStyle DTS_UPDOWN, Value
		#endif
		If FHandle Then RecreateWnd
	End Property
	
	Property DateTimePicker.ShowNone As Boolean
		#ifndef __USE_GTK__
			FShowNone = StyleExists(DTS_SHOWNONE)
		#endif
		Return FShowNone
	End Property
	
	Property DateTimePicker.ShowNone(Value As Boolean)
		FShowNone = Value
		#ifndef __USE_GTK__
			ChangeStyle DTS_SHOWNONE, Value
		#endif
		If FHandle Then RecreateWnd
	End Property
	
	Property DateTimePicker.DateFormat As DateTimePickerFormat
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
	
	Property DateTimePicker.DateFormat(Value As DateTimePickerFormat)
		FDateFormat = Value
		#ifndef __USE_GTK__
			ChangeStyle DTS_LONGDATEFORMAT, Value = DateTimePickerFormat.LongDate
			ChangeStyle DTS_SHORTDATEFORMAT, Value = DateTimePickerFormat.ShortDate
			ChangeStyle DTS_SHORTDATECENTURYFORMAT, Value =  DateTimePickerFormat.ShortDateCentury
			ChangeStyle DTS_TIMEFORMAT, Value = DateTimePickerFormat.TimeFormat
			If FHandle Then
				' Need to rebuild the control
				RecreateWnd
				If DateTimePickerFormat.CustomFormat Then
					DateTime_SetFormat(FHandle, FFormatCustom)
				End If
			End If
		#endif
	End Property
	
	Property DateTimePicker.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Property DateTimePicker.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Property DateTimePicker.TabStop As Boolean
		Return FTabStop
	End Property
	
	Property DateTimePicker.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	#ifndef __USE_GTK__
		Sub DateTimePicker.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QDateTimePicker(Sender.Child)
					If .FDateFormat = DateTimePickerFormat.CustomFormat Then DateTime_SetFormat(.FHandle, .FFormatCustom)
					.SelectedDateTime = .SelectedDateTime
				End With
			End If
		End Sub
		
		Sub DateTimePicker.WndProc(ByRef Message As Message)
		End Sub
		
	#endif
	
	Property DateTimePicker.TimePicker As Boolean 'David Change
		Return FTimePicker
	End Property
	
	Property DateTimePicker.TimePicker(Value As Boolean)'David Change
		If FTimePicker <> Value Then
			FTimePicker = Value
		End If
		#ifndef __USE_GTK__
			If FTimePicker Then
				This.Style  = WS_CHILD Or DTS_TIMEFOrMAT Or DTS_UPDOWN Or DTS_SHOWNONE ' NO repons
			Else
				This.Style  = WS_CHILD Or DTS_SHORTDATEFORMAT
			End If
			If FHandle Then RecreateWnd
		#endif
	End Property
	
	Sub DateTimePicker.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Select Case Message.Msg
			Case WM_KEYUP
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
				End Select
				InvalidateRect(Handle,Null,False)
				UpdateWindow Handle
			Case Else
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Operator DateTimePicker.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	Constructor DateTimePicker
		Dim As Boolean Result
		
		'Dim As INITCOMMONCONTROLSEX ICC
		
		'ICC.dwSize = SizeOF(ICC)
		
		'ICC.dwICC  = ICC_DATE_CLASSES
		
		'Result = InitCommonControlsEx(@ICC)
		'If Not Result Then InitCommonControls
		Text = ""
		FTabIndex          = -1
		FTabStop           = True
		With This
			WLet(FClassName, "DateTimePicker")
			WLet(FClassAncestor, "SysDateTimePick32")
			#ifdef __USE_GTK__
				Widget = gtk_spin_button_new(NULL, 1, 0)
'				CheckWidget = gtk_check_button_new_with_label("")
'				TextWidget = gtk_entry_new()
'				ButtonWidget = gtk_button_new_with_label(ToUTF8("˅"))
'				UpDownWidget = gtk_spin_button_new(NULL, 1, 0)
'				OverlayWidget = gtk_overlay_new()
'				gtk_container_add(gtk_overlay(OverlayWidget), UpDownWidget)
'				gtk_overlay_add_overlay(gtk_overlay(OverlayWidget), CheckWidget)
'				gtk_overlay_add_overlay(gtk_overlay(OverlayWidget), ButtonWidget)
''				gtk_box_pack_start(gtk_box(widget), CheckWidget, False, False, 0)
''				gtk_box_pack_start(gtk_box(widget), TextWidget, True, True, 0)
''				gtk_box_pack_start(gtk_box(widget), ButtonWidget, False, False, 0)
''				gtk_box_pack_start(gtk_box(widget), UpDownWidget, False, False, 0)
'				gtk_spin_button_set_numeric(gtk_spin_button(UpDownWidget), False)
'				gtk_entry_set_text(gtk_entry(UpDownWidget), ToUTF8("dsdsd"))
'				
'				gtk_spin_button_set_update_policy(gtk_spin_button(UpDownWidget), GTK_UPDATE_ALWAYS)
'				gtk_spin_button_set_wrap(gtk_spin_button(UpDownWidget), True)
'				gtk_widget_hide(CheckWidget)
				'gtk_container_set_border_width(gtk_container(widget), 10)
				Base.RegisterClass WStr("DateTimePicker"), @This
			#else
				Base.RegisterClass WStr("DateTimePicker"), WStr("SysDateTimePick32")
				.ExStyle      = 0 'WS_EX_LEFT OR WS_EX_LTRREADING OR WS_EX_RIGHTSCROLLBAR OR WS_EX_CLIENTEDGE
				.Style        = WS_CHILD Or DTS_SHORTDATEFORMAT
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.Width        = 175
			.Height       = 21
			.Child        = @This
		End With
	End Constructor
	
	Destructor DateTimePicker
		#ifndef __USE_GTK__
			UnregisterClass "DateTimePicker",GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
