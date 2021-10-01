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
		Case "showupdown": Return @FShowUpDown
		Case "selecteddate": Return @FSelectedDate
		Case "selecteddatetime": Return @FSelectedDateTime
		Case "selectedtime": Return @FSelectedTime
		Case "tabindex": Return @FTabIndex
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function DateTimePicker.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "calendarrightalign": CalendarRightAlign = QBoolean(Value) 
		Case "dateformat": DateFormat = *Cast(DateTimePickerFormat Ptr, Value)
		Case "formatcustom": FormatCustom = QWString(Value)
		Case "showupdown": ShowUpDown = QBoolean(Value) 
		Case "selecteddate": SelectedDate = QLong(Value)
		Case "selecteddatetime": SelectedDateTime = QDouble(Value)
		Case "selectedtime": SelectedTime = QDouble(Value)
		Case "tabindex": TabIndex = QInteger(Value)
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
		If FHandle Then
			#ifndef __USE_GTK__
				Dim As SYSTEMTIME pst
				DateTime_GetSystemTime(FHandle, @pst)
				FText = _
				StrRSet(WStr(pst.wYear),    4, "0") & "." & _
				StrRSet(WStr(pst.wMonth),   2, "0") & "." & _
				StrRSet(WStr(pst.wDay),     2, "0") & " " & _
				StrRSet(WStr(pst.wHour),    2, "0") & ":" & _
				StrRSet(WStr(pst.wMinute),  2, "0") & ":" & _
				StrRSet(WStr(pst.wSecond),  2, "0")
			#endif
		End If
		Return *FText.vptr
	End Property
	
	Property DateTimePicker.Text(ByRef Value As WString)
		FText = Value
		If FHandle Then
			#ifndef __USE_GTK__
				Dim As SYSTEMTIME pst
				FSelectedDate = DateValue(Trim(Left(Value, 10)))
				FSelectedTime = TimeValue(Trim(Mid(Value, 11)))
				DateTime_SetSystemTime(FHandle, GDT_VALID, @pst)
			#endif
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
		If FHandle Then
			#ifndef __USE_GTK__
				FRightAlign = StyleExists(DTS_RIGHTALIGN)
			#endif
		End If
		Return FRightAlign
	End Property
	
	Property DateTimePicker.CalendarRightAlign(Value As Boolean)
		FRightAlign = Value
		If FHandle Then
			#ifndef __USE_GTK__
				ChangeStyle DTS_RIGHTALIGN, Value
			#endif
			This.Repaint
		End If
	End Property
	
	Property DateTimePicker.ShowUpDown As Boolean
		If FHandle Then
			#ifndef __USE_GTK__
				FShowUpDown = StyleExists(DTS_UPDOWN)
			#endif
		End If
		Property = FShowUpDown
	End Property
	
	Property DateTimePicker.ShowUpDown(Value As Boolean)
		FShowUpDown = Value
		If FHandle Then
			' Apparently this style can not be changed after control creation.
			#ifndef __USE_GTK__
				ChangeStyle DTS_UPDOWN, Value
			#endif
			This.Repaint
		End If
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
		If FHandle Then
			#ifndef __USE_GTK__
				' Need to rebuild the control
				ChangeStyle DTS_LONGDATEFORMAT, Value = DateTimePickerFormat.LongDate
				ChangeStyle DTS_SHORTDATEFORMAT, Value = DateTimePickerFormat.ShortDate
				ChangeStyle DTS_SHORTDATECENTURYFORMAT, Value =  DateTimePickerFormat.ShortDateCentury
				ChangeStyle DTS_TIMEFORMAT, Value = DateTimePickerFormat.TimeFormat
				RecreateWnd
				If DateTimePickerFormat.CustomFormat Then
					DateTime_SetFormat(FHandle, FFormatCustom)
				End If
			#endif
		End If
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
					Var SMD = Sender.Handle
					Dim ST As SYSTEMTIME
					ST.wYear=2020
					ST.wmonth=1
					ST.wday=1
					ST.wHour=0
					ST.wMinute=1
					ST.wSecond=0
					Dim s As String
					s = "HH" & ":" & "mm" & ":" & "ss"
					'SendMessage(SMD, DTM_SETFORMATW,0, Cast(LPARAM,@s))
					SendMessage(SMD,DTM_SETSYSTEMTIME,0,Cast(LPARAM,@ST))
				End With
			End If
		End Sub
		
		Sub DateTimePicker.WndProc(ByRef Message As Message)
		End Sub
		
	#endif
	
'	Property DateTimePicker.TimePicker As Boolean 'David Change
'		Return FTimePicker
'	End Property
'	
'	Property DateTimePicker.TimePicker(Value As Boolean)'David Change
'		If FTimePicker <> Value Then
'			FTimePicker = Value
'		End If
'		#ifndef __USE_GTK__
'			If FTimePicker Then
'				This.Style  = WS_CHILD Or DTS_TIMEFOrMAT Or DTS_UPDOWN Or DTS_SHOWNONE ' NO repons
'			Else
'				This.Style  = WS_CHILD Or DTS_SHORTDATEFORMAT
'			End If
'		#endif
'	End Property
	
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
			#ifndef __USE_GTK__
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
