'###############################################################################
'#  TrackBar.bi                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TTrackBar.bi                                                              #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "TrackBar.bi"

Namespace My.Sys.Forms
	Function TrackBar.ReadProperty(ByRef PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "frequency": Return @FFrequency
		Case "maxvalue": Return @FMaxValue
		Case "minvalue": Return @FMinValue
		Case "linesize": Return @FLineSize
		Case "pagesize": Return @FPageSize
		Case "position": Return @FPosition
		Case "selstart": Return @FSelStart
		Case "selend": Return @FSelEnd
		Case "slidervisible": Return @FSliderVisible
		Case "style": Return @FStyle
		Case "tabindex": Return @FTabIndex
		Case "tickmark": Return @FTickMark
		Case "tickstyle": Return @FTickStyle
		Case "thumblength": Return @FThumbLength
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function TrackBar.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		If Value = 0 Then
			Select Case LCase(PropertyName)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		Else
			Select Case LCase(PropertyName)
			Case "frequency": This.Frequency = QInteger(Value)
			Case "maxvalue": MaxValue = QInteger(Value)
			Case "minvalue": MinValue = QInteger(Value)
			Case "linesize": LineSize = QInteger(Value)
			Case "pagesize": PageSize = QInteger(Value)
			Case "position": Position = QInteger(Value)
			Case "selstart": SelStart = QInteger(Value)
			Case "selend": SelEnd = QInteger(Value)
			Case "slidervisible": SliderVisible = QBoolean(Value)
			Case "style": This.Style = *Cast(TrackBarOrientation Ptr, Value)
			Case "tabindex": This.TabIndex = QInteger(Value)
			Case "tickmark": This.TickMark = *Cast(TickMarks Ptr, Value)
			Case "tickstyle": This.TickStyle = *Cast(TickStyles Ptr, Value)
			Case "thumblength": ThumbLength = QInteger(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		End If
		Return True
	End Function
	
	Property TrackBar.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Property TrackBar.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Property TrackBar.TabStop As Boolean
		Return FTabStop
	End Property
	
	Property TrackBar.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Sub TrackBar.SetRanges(APosition As Integer, AMin As Integer, AMax As Integer)
		If AMax < AMin Then Exit Sub
		If APosition < AMin Then APosition = AMin
		If APosition > AMax Then APosition = AMax
		If FMinValue <> AMin Then
			FMinValue = AMin
			#ifndef __USE_GTK__
				If Handle Then Perform(TBM_SETRANGEMIN, 1, AMin)
			#endif
		End If
		If FMaxValue <> AMax Then
			FMaxValue = AMax
			#ifndef __USE_GTK__
				If Handle Then Perform(TBM_SETRANGEMAX, 1, AMax)
			#endif
		End If
		If FPosition <> APosition Then
			FPosition = APosition
			#ifndef __USE_GTK__
				If Handle Then Perform(TBM_SETPOS, 1, APosition)
			#endif
			If OnChange Then OnChange(This,Position)
		End If
	End Sub
	
	Property TrackBar.MinValue As Integer
		Return FMinValue
	End Property
	
	Property TrackBar.MinValue(Value As Integer)
		FMinValue = Value
		#ifdef __USE_GTK__
			If Value <= FMaxValue Then
				gtk_range_set_range(gtk_range(widget), Value, FMaxValue)
			End If
			TickStyle = FTickStyle
		#else
			If Handle Then Perform(TBM_SETRANGEMIN, 1, Value)
		#endif
		'SetRanges(FPosition, Value, FMaxValue)
	End Property
	
	Property TrackBar.MaxValue As Integer
		Return FMaxValue
	End Property
	
	Property TrackBar.MaxValue(Value As Integer)
		FMaxValue = Value
		#ifdef __USE_GTK__
			gtk_range_set_range(gtk_range(widget), FMinValue, Value)
			TickStyle = FTickStyle
		#else
			If Handle Then Perform(TBM_SETRANGEMAX, 1, Value)
		#endif
		'SetRanges(FPosition, FMinValue, Value)
	End Property
	
	Property TrackBar.Position As Integer
		#ifdef __USE_GTK__
			FPosition = gtk_range_get_value(gtk_range(widget))
		#else
			If Handle Then FPosition = Perform(TBM_GETPOS, 0, 0)
		#endif
		Return FPosition
	End Property
	
	Property TrackBar.Position(Value As Integer)
		FPosition = Value
		#ifdef __USE_GTK__
			gtk_range_set_value(gtk_range(widget), CDbl(Value))
		#else
			If Handle Then Perform(TBM_SETPOS, FPosition, True)
		#endif
		If OnChange Then OnChange(This, FPosition)
		'SetRanges(Value, FMinValue, FMaxValue)
	End Property
	
	Property TrackBar.LineSize  As Integer
		Return FLineSize
	End Property
	
	Property TrackBar.LineSize(Value As Integer)
		If Value <> FLineSize Then
			FLineSize = Value
			#ifdef __USE_GTK__
				gtk_range_set_increments(gtk_range(widget), FLineSize, FPageSize)
			#else
				If Handle Then Perform(TBM_SETLINESIZE, 0, FLineSize)
			#endif
		End If
	End Property
	
	Property TrackBar.PageSize  As Integer
		Return FPageSize
	End Property
	
	Property TrackBar.PageSize(Value As Integer)
		If Value <> FPageSize Then
			FPageSize = Value
			#ifdef __USE_GTK__
				gtk_range_set_increments(gtk_range(widget), FLineSize, FPageSize)
			#else
				If Handle Then Perform(TBM_SETPAGESIZE, 0, FPageSize)
			#endif
		End If
	End Property
	
	Property TrackBar.ThumbLength  As Integer
		Return FThumbLength
	End Property
	
	Property TrackBar.ThumbLength(Value As Integer)
		If Value <> FThumbLength Then
			FThumbLength = Value
			#ifdef __USE_GTK__
				gtk_range_set_min_slider_size(gtk_range(widget), Value)
			#else
				If Handle Then Perform(TBM_SETTHUMBLENGTH, Value, 0)
			#endif
		End If
	End Property
	
	Property TrackBar.Frequency As Integer
		Return FFrequency
	End Property
	
	Property TrackBar.Frequency(Value As Integer)
		If Value <> FFrequency Then
			FFrequency = Value
			#ifdef __USE_GTK__
				TickStyle = FTickStyle
			#else
				If Handle Then Perform(TBM_SETTICFREQ, FFrequency, 1)
			#endif
		End If
	End Property
	
	Property TrackBar.SliderVisible As Boolean
		Return FSliderVisible
	End Property
	
	Property TrackBar.SliderVisible(Value As Boolean)
		If Value <> FSliderVisible Then
			FSliderVisible = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or TBS_FIXEDLENGTH Or TBS_ENABLESELRANGE Or AStyle(Abs_(FStyle)) Or ATickStyles(Abs_(FTickStyle)) Or ATickMarks(Abs_(FTickMark)) Or ASliderVisible(Abs_(FSliderVisible))
			#endif
		End If
	End Property
	
	Property TrackBar.SelStart As Integer
		Return FSelStart
	End Property
	
	Property TrackBar.SelStart(Value As Integer)
		If Value <> FSelStart Then
			FSelStart = Value
			#ifndef __USE_GTK__
				If Handle Then
					If (FSelStart = 0) And (FSelEnd = 0) Then
						Perform(TBM_CLEARSEL, 1, 0)
					Else
						Perform(TBM_SETSEL, 1, MakeLong(FSelStart, FSelEnd))
					End If
				End If
			#endif
		End If
	End Property
	
	Property TrackBar.SelEnd As Integer
		Return FSelEnd
	End Property
	
	Property TrackBar.SelEnd(Value As Integer)
		If Value <> SelEnd Then
			FSelEnd = Value
			#ifndef __USE_GTK__
				If Handle Then
					If (FSelStart = 0) And (FSelEnd = 0) Then
						Perform(TBM_CLEARSEL, 1, 0)
					Else
						Perform(TBM_SETSEL, 1, MakeLong(FSelStart, FSelEnd))
					End If
				End If
			#endif
		End If
	End Property
	
	Sub TrackBar.AddTickMark(Value As Integer)
		#ifdef __USE_GTK__
			If FTickMark = tmTopLeft Then
				gtk_scale_add_mark(gtk_scale(widget), Value, IIf(FStyle = tbHorizontal, GTK_POS_TOP, GTK_POS_LEFT), 0)
			ElseIf FTickMark = tmBottomRight Then
				gtk_scale_add_mark(gtk_scale(widget), Value, IIf(FStyle = tbHorizontal, GTK_POS_BOTTOM, GTK_POS_RIGHT), 0)
			ElseIf FTickMark = tmBoth Then
				gtk_scale_add_mark(gtk_scale(widget), Value, IIf(FStyle = tbHorizontal, GTK_POS_TOP, GTK_POS_LEFT), 0)
				gtk_scale_add_mark(gtk_scale(widget), Value, IIf(FStyle = tbHorizontal, GTK_POS_BOTTOM, GTK_POS_RIGHT), 0)
			End If
		#else
			If Handle Then Perform(TBM_SETTIC, 0, Value)
		#endif
	End Sub
	
	
	Sub TrackBar.ClearTickMarks
		#ifdef __USE_GTK__
			gtk_scale_clear_marks(gtk_scale(widget))
			If FTickMark = tmTopLeft Then
				gtk_scale_add_mark(gtk_scale(widget), FMinValue, IIf(FStyle = tbHorizontal, GTK_POS_TOP, GTK_POS_LEFT), 0)
				gtk_scale_add_mark(gtk_scale(widget), FMaxValue, IIf(FStyle = tbHorizontal, GTK_POS_TOP, GTK_POS_LEFT), 0)
			ElseIf FTickMark = tmBottomRight Then
				gtk_scale_add_mark(gtk_scale(widget), FMinValue, IIf(FStyle = tbHorizontal, GTK_POS_BOTTOM, GTK_POS_RIGHT), 0)
				gtk_scale_add_mark(gtk_scale(widget), FMaxValue, IIf(FStyle = tbHorizontal, GTK_POS_BOTTOM, GTK_POS_RIGHT), 0)
			ElseIf FTickMark = tmBoth Then
				gtk_scale_add_mark(gtk_scale(widget), FMinValue, IIf(FStyle = tbHorizontal, GTK_POS_TOP, GTK_POS_LEFT), 0)
				gtk_scale_add_mark(gtk_scale(widget), FMinValue, IIf(FStyle = tbHorizontal, GTK_POS_BOTTOM, GTK_POS_RIGHT), 0)
				gtk_scale_add_mark(gtk_scale(widget), FMaxValue, IIf(FStyle = tbHorizontal, GTK_POS_TOP, GTK_POS_LEFT), 0)
				gtk_scale_add_mark(gtk_scale(widget), FMaxValue, IIf(FStyle = tbHorizontal, GTK_POS_BOTTOM, GTK_POS_RIGHT), 0)
			End If
		#else
			If Handle Then Perform(TBM_CLEARTICS, True, 0)
		#endif
	End Sub
	
	Property TrackBar.TickMark As TickMarks
		Return FTickMark
	End Property
	
	Property TrackBar.TickMark(Value As TickMarks)
		FTickMark = Value
		#ifdef __USE_GTK__
			TickStyle = FTickStyle 
		#else
			Base.Style = WS_CHILD Or TBS_FIXEDLENGTH Or TBS_ENABLESELRANGE Or AStyle(Abs_(FStyle)) Or ATickStyles(Abs_(FTickStyle)) Or ATickMarks(Abs_(FTickMark)) Or ASliderVisible(Abs_(FSliderVisible))
			RecreateWnd
		#endif
	End Property
	
	Property TrackBar.TickStyle As TickStyles
		Return FTickStyle
	End Property
	
	Property TrackBar.TickStyle(Value As TickStyles)
		FTickStyle = Value
		#ifdef __USE_GTK__
			Select Case FTickStyle
			Case 0: gtk_scale_clear_marks(gtk_scale(widget))
			Case 1: gtk_scale_clear_marks(gtk_scale(widget))
				For i As Integer = FMinValue To FMaxValue Step FFrequency
					If FTickMark = tmTopLeft Then
						gtk_scale_add_mark(gtk_scale(widget), i, IIf(FStyle = tbHorizontal, GTK_POS_TOP, GTK_POS_LEFT), 0)
					ElseIf FTickMark = tmBottomRight Then
						gtk_scale_add_mark(gtk_scale(widget), i, IIf(FStyle = tbHorizontal, GTK_POS_BOTTOM, GTK_POS_RIGHT), 0)
					ElseIf FTickMark = tmBoth Then
						gtk_scale_add_mark(gtk_scale(widget), i, IIf(FStyle = tbHorizontal, GTK_POS_TOP, GTK_POS_LEFT), 0)
						gtk_scale_add_mark(gtk_scale(widget), i, IIf(FStyle = tbHorizontal, GTK_POS_BOTTOM, GTK_POS_RIGHT), 0)
					End If
				Next
			Case 2: gtk_scale_clear_marks(gtk_scale(widget))
				If FTickMark = tmTopLeft Then
					gtk_scale_add_mark(gtk_scale(widget), FMinValue, IIf(FStyle = tbHorizontal, GTK_POS_TOP, GTK_POS_LEFT), 0)
					gtk_scale_add_mark(gtk_scale(widget), FMaxValue, IIf(FStyle = tbHorizontal, GTK_POS_TOP, GTK_POS_LEFT), 0)
				ElseIf FTickMark = tmBottomRight Then
					gtk_scale_add_mark(gtk_scale(widget), FMinValue, IIf(FStyle = tbHorizontal, GTK_POS_BOTTOM, GTK_POS_RIGHT), 0)
					gtk_scale_add_mark(gtk_scale(widget), FMaxValue, IIf(FStyle = tbHorizontal, GTK_POS_BOTTOM, GTK_POS_RIGHT), 0)
				ElseIf FTickMark = tmBoth Then
					gtk_scale_add_mark(gtk_scale(widget), FMinValue, IIf(FStyle = tbHorizontal, GTK_POS_TOP, GTK_POS_LEFT), 0)
					gtk_scale_add_mark(gtk_scale(widget), FMinValue, IIf(FStyle = tbHorizontal, GTK_POS_BOTTOM, GTK_POS_RIGHT), 0)
					gtk_scale_add_mark(gtk_scale(widget), FMaxValue, IIf(FStyle = tbHorizontal, GTK_POS_TOP, GTK_POS_LEFT), 0)
					gtk_scale_add_mark(gtk_scale(widget), FMaxValue, IIf(FStyle = tbHorizontal, GTK_POS_BOTTOM, GTK_POS_RIGHT), 0)
				End If
			End Select
		#else
			Base.Style = WS_CHILD Or TBS_FIXEDLENGTH Or TBS_ENABLESELRANGE Or AStyle(Abs_(FStyle)) Or ATickStyles(Abs_(FTickStyle)) Or ATickMarks(Abs_(FTickMark)) Or ASliderVisible(Abs_(FSliderVisible))
			RecreateWnd
		#endif
	End Property
	
	Property TrackBar.Style As TrackBarOrientation
		Return FStyle
	End Property
	
	Property TrackBar.Style(Value As TrackBarOrientation)
		Dim As Integer OldStyle
		Dim As Integer iWidth, iHeight
		OldStyle = FStyle
		If FStyle <> Value Then
			FStyle = Value
			If OldStyle = 0 Then
				iHeight = Height
				iWidth = This.Width
				#ifdef __USE_GTK__
					gtk_orientable_set_orientation(gtk_orientable(widget), GTK_ORIENTATION_VERTICAL)
				#endif
				Height = iWidth
				This.Width  = iHeight
			Else
				iWidth = This.Width
				iHeight = Height
				#ifdef __USE_GTK__
					gtk_orientable_set_orientation(gtk_orientable(widget), GTK_ORIENTATION_HORIZONTAL)
				#endif
				This.Width = iHeight
				Height  = iWidth
			End If
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or TBS_FIXEDLENGTH Or TBS_ENABLESELRANGE Or AStyle(Abs_(FStyle)) Or ATickStyles(Abs_(FTickStyle)) Or ATickMarks(Abs_(FTickMark)) Or ASliderVisible(Abs_(FSliderVisible))
			#endif
		End If
	End Property
	
	#ifndef __USE_GTK__
		Sub TrackBar.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QTrackBar(Sender.Child)
					.Perform(TBM_SETTHUMBLENGTH, .FThumbLength, 0)
					.Perform(TBM_SETLINESIZE, 0, .FLineSize)
					.Perform(TBM_SETPAGESIZE, 0, .FPageSize)
					.Perform(TBM_SETRANGEMIN, 0, .FMinValue)
					.Perform(TBM_SETRANGEMAX, 0, .FMaxValue)
					If (.FSelStart = 0) And (.FSelEnd = 0) Then
						.Perform(TBM_CLEARSEL, 1, 0)
					Else
						.Perform(TBM_SETSEL, 1, MakeLong(.FSelStart, .FSelEnd))
					End If
					.Perform(TBM_SETPOS, 1, .FPosition)
					.Perform(TBM_SETTICFREQ, .FFrequency, 1)
				End With
			End If
		End Sub
		
		Sub TrackBar.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Sub TrackBar.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Select Case Message.Msg
			Case CM_HSCROLL
				FPosition = Perform(TBM_GETPOS, 0, 0)
				If OnChange Then OnChange(This, Position)
			Case CM_VSCROLL
				FPosition = Perform(TBM_GETPOS, 0, 0)
				If OnChange Then OnChange(This, Position)
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Operator TrackBar.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Sub TrackBar.Range_ValueChanged(range As GtkRange Ptr, user_data As Any Ptr)
			Dim As TrackBar Ptr trb = user_data
			If trb->OnScroll Then trb->OnScroll(*trb)
			If trb->OnChange Then trb->OnChange(*trb, gtk_range_get_value(range))
		End Sub
	#endif
	
	Constructor TrackBar
		Dim As Boolean Result
		#ifdef __USE_GTK__
			#ifdef __USE_GTK3__
				widget = gtk_scale_new(GTK_ORIENTATION_HORIZONTAL, NULL)
			#else
				widget = gtk_hscale_new(NULL)
			#endif
			gtk_range_set_slider_size_fixed(gtk_range(widget), True)
			gtk_scale_set_draw_value(gtk_scale(widget), False)
			g_signal_connect(widget, "value-changed", G_CALLBACK(@Range_ValueChanged), @This)
			This.RegisterClass "TrackBar", @This
		#else
			Dim As INITCOMMONCONTROLSEX ICC
			ICC.dwSize = SizeOf(ICC)
			ICC.dwICC  = ICC_BAR_CLASSES
			Result = InitCommonControlsEx(@ICC)
			If Not Result Then InitCommonControls
			AStyle(0)         = TBS_HORZ
			AStyle(1)         = TBS_VERT
			ATickStyles(0)    = TBS_NOTICKS
			ATickStyles(1)    = TBS_AUTOTICKS
			ATickStyles(2)    = 0
			ATickMarks(0)     = TBS_BOTTOM
			ATickMarks(1)     = TBS_TOP
			ATickMarks(2)     = TBS_BOTH
			ASliderVisible(0) = TBS_NOTHUMB
			ASliderVisible(1) = 0
		#endif
		MaxValue         = 10
		MinValue         = 0
		Frequency        = 1
		SliderVisible    = 1
		LineSize         = 1
		PageSize         = 2
		Frequency        = 1
		ThumbLength      = 20
		TickMark         = tmBottomRight
		TickStyle        = tsAuto
		FTabIndex        = -1
		FTabStop         = True
		With This
			.Child       = @This
			#ifndef __USE_GTK__
				.RegisterClass "TrackBar", TRACKBAR_CLASS
				.ChildProc         = @WndProc
				.ExStyle           = 0
				Base.Style             = WS_CHILD Or TBS_FIXEDLENGTH Or TBS_ENABLESELRANGE Or AStyle(Abs_(FStyle)) Or ATickStyles(Abs_(FTickStyle)) Or ATickMarks(Abs_(FTickMark)) Or ASliderVisible(Abs_(FSliderVisible))
				.BackColor             = GetSysColor(COLOR_BTNFACE)
				WLet(FClassAncestor, TRACKBAR_CLASS)
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			WLet(FClassName, "TrackBar")
			.Width             = 150
			.Height            = 45
		End With
	End Constructor
	
	Destructor TrackBar
	End Destructor
End Namespace
