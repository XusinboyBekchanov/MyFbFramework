'###############################################################################
'#  ProgressBar.bi                                                             #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TProgressBar.bi                                                           #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "ProgressBar.bi"

Namespace My.Sys.Forms
	Private Function ProgressBar.ReadProperty(ByRef PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "marquee": Return @FMarquee
		Case "maxvalue": Return @FMaxValue
		Case "minvalue": Return @FMinValue
		Case "orientation": Return @FOrientation
		Case "position": Return @FPosition
		Case "smooth": Return @FSmooth
		Case "stepvalue": Return @FStep
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Private Function ProgressBar.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		If Value = 0 Then
			Select Case LCase(PropertyName)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		Else
			Select Case LCase(PropertyName)
			Case "marquee": Marquee = QBoolean(Value)
			Case "maxvalue": MaxValue = QInteger(Value)
			Case "minvalue": MinValue = QInteger(Value)
			Case "orientation": Orientation = *Cast(ProgressBarOrientation Ptr, Value)
			Case "smooth": Smooth = QBoolean(Value)
			Case "stepvalue": StepValue = QInteger(Value)
			Case "position": Position = QInteger(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		End If
		Return True
	End Function
	
	Private Sub ProgressBar.SetRange(AMin As Integer, AMax As Integer)
		If AMax < AMin Then Exit Sub
		If Not CInt(FMode32) And ((AMin < 0) Or (AMin > 85535) Or (AMax < 0) Or (AMax > 85535)) Then Exit Sub
		If (FMinValue <> AMin) Or (FMaxValue <> AMax) Then
			#ifndef __USE_GTK__
				If Handle Then
					If FMode32 Then
						Perform(PBM_SETRANGE32, AMin, AMax)
					Else
						Perform(PBM_SETRANGE, 0, MakeLong(AMin, AMax))
					End If
					If FMinValue > AMin Then Perform(PBM_SETPOS, AMin, 0)
				End If
			#endif
		End If
		FMinValue = AMin
		FMaxValue = AMax
	End Sub
	
	#ifdef __USE_GTK__
		Private Function ProgressBar.progress_cb(ByVal user_data As gpointer) As gboolean
			Dim As ProgressBar Ptr prb = Cast(ProgressBar Ptr, user_data)
			gtk_progress_bar_pulse(GTK_PROGRESS_BAR(prb->widget))
			If prb->progress_bar_timer_id = 0 Then
				Return False
				'Return G_SOURCE_REMOVE
			Else
				Return True
			End If
		End Function
	#endif

	Private Sub ProgressBar.SetMarquee(MarqueeOn As Boolean, Interval As Integer)
		FMarqueeOn = MarqueeOn
		FMarqueeInterval = Interval
		#ifdef __USE_GTK__
			If FMarqueeOn Then
				progress_bar_timer_id = g_timeout_add(FMarqueeInterval, Cast(GSourceFunc, @progress_cb), @This)
			Else
				progress_bar_timer_id = 0
			End If
		#else
			SendMessage(Handle, PBM_SETMARQUEE, Cast(WPARAM, FMarqueeOn), Cast(LPARAM, FMarqueeInterval))
		#endif
	End Sub
	
	Private Sub ProgressBar.StopMarquee()
		FMarqueeOn = False
		#ifdef __USE_GTK__
			If progress_bar_timer_id <> 0 Then
				'g_source_remove_ progress_bar_timer_id
				progress_bar_timer_id = 0
			End If
		#else
			SendMessage(Handle, PBM_SETMARQUEE, Cast(WPARAM, FMarqueeOn), Cast(LPARAM, FMarqueeInterval))
		#endif
	End Sub
	
	Private Property ProgressBar.MinValue As Integer
		Return FMinValue
	End Property
	
	Private Property ProgressBar.MinValue(Value As Integer)
		FMinValue = Value
		SetRange(FMinValue,FMaxValue)
	End Property
	
	Private Property ProgressBar.MaxValue As Integer
		Return FMaxValue
	End Property
	
	Private Property ProgressBar.MaxValue(Value As Integer)
		FMaxValue = Value
		SetRange(FMinValue,FMaxValue)
	End Property
	
	Private Property ProgressBar.Position As Integer
		#ifdef __USE_GTK__
			FPosition = FMinValue + (FMaxValue - FMinValue) * gtk_progress_bar_get_fraction(gtk_progress_bar(widget))
		#else
			If Handle Then
				If FMode32 Then
					Return Perform(PBM_GETPOS, 0, 0)
				Else
					Return Perform(PBM_DELTAPOS, 0, 0)
				End If
			End If
		#endif
		Return FPosition
	End Property
	
	Private Property ProgressBar.Position(Value As Integer)
		If Not CInt(FMode32) And ((Value < 0) Or (Value  > 65535)) Then Exit Property
		FPosition = Value
		#ifdef __USE_GTK__
			If FMaxValue <> FMinValue Then
				gtk_progress_bar_set_fraction(gtk_progress_bar(widget), FPosition / (FMaxValue - FMinValue))
			End If
		#else
			If Handle Then Perform(PBM_SETPOS, Value, 0)
		#endif
	End Property
	
	Private Property ProgressBar.StepValue As Integer
		Return FStep
	End Property
	
	Private Property ProgressBar.StepValue(Value As Integer)
		If Value <> FStep Then
			FStep = Value
			#ifdef __USE_GTK__
				If FMaxValue <> FMinValue Then
					gtk_progress_bar_set_pulse_step(gtk_progress_bar(widget), FStep / (FMaxValue - FMinValue))
				End If
			#else
				If Handle Then Perform(PBM_SETSTEP, FStep, 0)
			#endif
		End If
	End Property
	
	Private Property ProgressBar.Smooth As Boolean
		Return FSmooth
	End Property
	
	Private Property ProgressBar.Smooth(Value As Boolean)
		If FSmooth <> Value Then
			FSmooth = Value
			#ifndef __USE_GTK__
				Style = WS_CHILD Or AOrientation(Abs_(FOrientation)) Or ASmooth(Abs_(FSmooth)) Or AMarquee(Abs_(FMarquee))
			#endif
		End If
	End Property
	
	Private Property ProgressBar.Marquee As Boolean
		Return FMarquee
	End Property
	
	Private Property ProgressBar.Marquee(Value As Boolean)
		If FMarquee <> Value Then
			FMarquee = Value
			#ifndef __USE_GTK__
				Style = WS_CHILD Or AOrientation(Abs_(FOrientation)) Or ASmooth(Abs_(FSmooth)) Or AMarquee(Abs_(FMarquee))
			#endif
		End If
	End Property
	
	Private Property ProgressBar.Orientation As ProgressBarOrientation
		Return FOrientation
	End Property
	
	Private Property ProgressBar.Orientation(Value As ProgressBarOrientation)
		Dim As Integer OldOrientation, iWidth, iHeight
		OldOrientation = FOrientation
		If FOrientation <> Value Then
			FOrientation = Value
			If OldOrientation = 0 Then
				iWidth = This.Width
				iHeight = This.Height
				#ifdef __USE_GTK__
					#ifdef __USE_GTK3__
						gtk_orientable_set_orientation(gtk_orientable(widget), GTK_ORIENTATION_VERTICAL)
					#else
						gtk_progress_bar_set_orientation(gtk_progress_bar(widget), GTK_PROGRESS_BOTTOM_TO_TOP)
					#endif
				#endif
				This.Width = iHeight
				This.Height = iWidth
			Else
				iWidth = This.Width
				iHeight = This.Height
				#ifdef __USE_GTK__
					#ifdef __USE_GTK3__
						gtk_orientable_set_orientation(gtk_orientable(widget), GTK_ORIENTATION_HORIZONTAL)
					#else
						gtk_progress_bar_set_orientation(gtk_progress_bar(widget), GTK_PROGRESS_LEFT_TO_RIGHT)
					#endif
				#endif
				This.Width = iHeight
				This.Height = iWidth
			End If
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or AOrientation(Abs_(FOrientation)) Or ASmooth(Abs_(FSmooth)) Or AMarquee(Abs_(FMarquee))
			#endif
		End If
	End Property
	
	#ifndef __USE_GTK__
		Private Sub ProgressBar.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With  QProgressBar(Sender.Child)
					If .FMode32 Then
						.Perform(PBM_SETRANGE32, .FMinValue, .FMaxValue)
					Else
						.Perform(PBM_SETRANGE, 0, MakeLong(.FMinValue, .FMaxValue))
					End If
					.Perform(PBM_SETSTEP, .FStep, 0)
					.Position = .FPosition
					If .FMarqueeInterval <> 0 Then .Perform(PBM_SETMARQUEE, Cast(WPARAM, .FMarqueeOn), Cast(LPARAM, .FMarqueeInterval))
				End With
			End If
		End Sub
		
		Private Sub ProgressBar.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Private Sub ProgressBar.ProcessMessage(ByRef Message As Message)
		Base.ProcessMessage(Message)
	End Sub
	
	Private Sub ProgressBar.StepIt
		#ifdef __USE_GTK__
			If FMarquee Then
				gtk_progress_bar_pulse(GTK_PROGRESS_BAR(widget))
			Else
				Position = Position + FStep
			End If
		#else
			If Handle Then Perform(PBM_STEPIT, 0, 0)
		#endif
	End Sub
	
	Private Sub ProgressBar.StepBy(Delta As Integer)
		#ifdef __USE_GTK__
			If FMarquee Then
				gtk_progress_bar_pulse(GTK_PROGRESS_BAR(widget))
			Else
				Position = Position + Delta
			End If
		#else
			If Handle Then  Perform(PBM_DELTAPOS, Delta, 0)
		#endif
	End Sub
	
	Private Operator ProgressBar.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Constructor ProgressBar
		#ifdef __USE_GTK__
			widget = gtk_progress_bar_new()
		#else
			Dim As INITCOMMONCONTROLSEX ICC
			ICC.dwSize = SizeOf(ICC)
			ICC.dwICC  = ICC_PROGRESS_CLASS
			FMode32 = InitCommonControlsEx(@ICC)
			ASmooth(0) = 0
			ASmooth(1) = PBS_SMOOTH
			AMarquee(0) = 0
			AMarquee(1) = PBS_MARQUEE
			AOrientation(0)  = 0
			AOrientation(1)  = PBS_VERTICAL
		#endif
		FMinValue  = 0
		FMaxValue  = 100
		FStep      = 10
		FMarquee = False
		With This
			.Child             = @This
			#ifndef __USE_GTK__
				.RegisterClass "ProgressBar", PROGRESS_CLASS
				.ChildProc         = @WndProc
				.ExStyle           = 0
				Base.Style             = WS_CHILD Or AOrientation(Abs_(FOrientation)) Or ASmooth(Abs_(FSmooth)) Or AMarquee(Abs_(FMarquee))
				.OnHandleIsAllocated = @HandleIsAllocated
				WLet(FClassAncestor, PROGRESS_CLASS)
				.Height            = GetSystemMetrics(SM_CYVSCROLL)
				.DoubleBuffered = True
			#endif
			WLet(FClassName, "ProgressBar")
			.Width             = 150
		End With
	End Constructor
	
	Private Destructor ProgressBar
	End Destructor
End Namespace
