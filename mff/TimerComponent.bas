'################################################################################
'#  TimerComponent.bi                                                           #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#include once "TimerComponent.bi"

Namespace My.Sys.Forms
	Function TimerComponent.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "enabled": Return Cast(Any Ptr, @This.FEnabled)
		Case "interval": Return Cast(Any Ptr, @This.FInterval)
		Case "ontimer": Return Cast(Any Ptr, This.OnTimer)
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function TimerComponent.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "enabled": This.Enabled = QBoolean(Value)
		Case "interval": This.Interval = QInteger(Value)
		Case "ontimer": This.OnTimer = Value
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	#ifdef __USE_GTK__
		Function TimerProc(ByVal user_data As gpointer) As gboolean
			With TimersList
				Dim As TimerComponent Ptr tmr = user_data
				If tmr <> 0 Then
					If tmr->OnTimer Then tmr->OnTimer(*tmr)
				End If
				Return tmr->Enabled
			End With
		End Function
	#else
		Sub TimerComponent.TimerProc(hwnd As HWND, uMsg As Uint, idEvent As Integer, dwTime As DWord)
			With TimersList
				If .Contains(idEvent) Then
					Var tmr = Cast(TimerComponent Ptr, .Object(.IndexOf(idEvent)))
					If tmr->OnTimer Then tmr->OnTimer(*tmr)
				End If
			End With
		End Sub
	#endif
	
	Property TimerComponent.Enabled As Boolean
		Return FEnabled
	End Property
	
	Property TimerComponent.Enabled(Value As Boolean)
		FEnabled = Value
		If FInterval <> 0 AndAlso Not FDesignMode Then
			#ifdef __USE_GTK__
				If FEnabled Then
					ID = g_timeout_add(Interval, Cast(GSOURCEFUNC, @TimerProc), Cast(gpointer, @This))
					TimersList.Add ID, @This
				Else
					TimersList.Remove TimersList.IndexOf(ID)
				End If
			#else
				If FEnabled Then
					ID = SetTimer(Null, 0, Interval, @TimerProc)
					TimersList.Add ID, @This
				Else
					If ID Then KillTimer Null, ID
					TimersList.Remove TimersList.IndexOf(ID)
				End If
			#endif
		End If
	End Property
	
	Property TimerComponent.Interval As Integer
		Return FInterval
	End Property
	
	Property TimerComponent.Interval(Value As Integer)
		FInterval = Value
		If FEnabled AndAlso Not FDesignMode Then
			TimersList.Remove TimersList.IndexOf(ID)
			#ifndef __USE_GTK__
				If ID Then KillTimer Null, ID
			#endif
			ID = 0
			If FInterval > 0 Then
				#ifdef __USE_GTK__
					ID = g_timeout_add(Interval, Cast(GSOURCEFUNC, @TimerProc), Cast(gpointer, @This))
				#else
					ID = SetTimer(Null, 0, Interval, @TimerProc)
				#endif
				TimersList.Add ID, @This
			End If
		End If
	End Property
	
	Operator TimerComponent.Cast As Any Ptr
		Return @This
	End Operator
	
	Constructor TimerComponent
		Interval = 10
		WLet(FClassName, "TimerComponent")
		FEnabled = False
	End Constructor
	
	Destructor TimerComponent
		Enabled = False
	End Destructor
End Namespace
