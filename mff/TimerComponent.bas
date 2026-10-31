'################################################################################
'#  TimerComponent.bi                                                           #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#include once "TimerComponent.bi"

#if defined(__USE_WASM__) OrElse defined(__USE_APPLE__)
	Declare Sub TimerComponent_OnTimer(Id As Integer)
#endif

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function TimerComponent.ReadProperty(PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "enabled": Return Cast(Any Ptr, @This.FEnabled)
			Case "interval": Return Cast(Any Ptr, @This.FInterval)
			Case "ontimer": Return Cast(Any Ptr, This.OnTimer)
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function TimerComponent.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "enabled": This.Enabled = QBoolean(Value)
			Case "interval": This.Interval = QInteger(Value)
			Case "ontimer": This.OnTimer = Value
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	
	#ifdef __USE_GTK__
		Private Function TimerComponent.TimerProc(ByVal user_data As gpointer) As gboolean
			With TimersList
				Dim As TimerComponent Ptr tmr = user_data
				If tmr <> 0 Then
					If tmr->OnTimer Then tmr->OnTimer(*tmr->Designer, *tmr)
				End If
				Return tmr->Enabled
			End With
		End Function
	#elseif defined(__USE_WINAPI__)
		Private Sub TimerComponent.TimerProc(hwnd As HWND, uMsg As UINT, idEvent As Integer, dwTime As DWORD)
			With TimersList
				If .Contains(idEvent) Then
					Var tmr = Cast(TimerComponent Ptr, .Object(.IndexOf(idEvent)))
					If tmr->OnTimer Then tmr->OnTimer(*tmr->Designer, *tmr)
				End If
			End With
		End Sub
	#endif
	
	Private Property TimerComponent.Enabled As Boolean
		Return FEnabled
	End Property
	
	Private Property TimerComponent.Enabled(Value As Boolean)
		FEnabled = Value
		If FInterval <> 0 AndAlso Not FDesignMode Then
			#ifdef __USE_GTK__
				If FEnabled Then
					ID = g_timeout_add(Interval, Cast(GSourceFunc, @TimerProc), Cast(gpointer, @This))
					TimersList.Add ID, @This
				Else
					TimersList.Remove TimersList.IndexOf(ID)
				End If
			#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__) OrElse defined(__USE_APPLE__)
				If FEnabled Then
					StartTimer(@This, FInterval)
				Else
					StopTimer(@This)
				End If
			#elseif defined(__USE_APPLE__)
				If FEnabled Then
					mffTimerStart(@This, FInterval)
				Else
					mffTimerStop(@This)
				End If
			#elseif defined(__USE_WINAPI__)
				If FEnabled Then
					ID = SetTimer(NULL, 0, Interval, @TimerProc)
					TimersList.Add ID, @This
				Else
					If ID Then KillTimer NULL, ID
					TimersList.Remove TimersList.IndexOf(ID)
				End If
			#endif
		End If
	End Property
	
	Private Property TimerComponent.Interval As Integer
		Return FInterval
	End Property
	
	Private Property TimerComponent.Interval(Value As Integer)
		FInterval = Value
		If FEnabled AndAlso Not FDesignMode Then
			TimersList.Remove TimersList.IndexOf(ID)
			#ifdef __USE_WINAPI__
				If ID Then KillTimer NULL, ID
			#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__) OrElse defined(__USE_APPLE__)
				StopTimer(@This)
			#elseif defined(__USE_APPLE__)
				mffTimerStop(@This)
			#endif
			ID = 0
			If FInterval > 0 Then
				#ifdef __USE_GTK__
					ID = g_timeout_add(Interval, Cast(GSourceFunc, @TimerProc), Cast(gpointer, @This))
				#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__) OrElse defined(__USE_APPLE__)
					StartTimer(@This, FInterval)
				#elseif defined(__USE_APPLE__)
					mffTimerStart(@This, FInterval)
				#elseif defined(__USE_WINAPI__)
					ID = SetTimer(NULL, 0, Interval, @TimerProc)
				#endif
				TimersList.Add ID, @This
			End If
		End If
	End Property
	
	Private Operator TimerComponent.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor TimerComponent
		Interval = 10
		WLet(FClassName, "TimerComponent")
		FEnabled = False
		#if defined(__USE_WASM__) OrElse defined(__USE_APPLE__)
			TimerComponentProc = @TimerComponent_OnTimer
		#endif
	End Constructor
	
	Private Destructor TimerComponent
		Enabled = False
		#if defined(__USE_WASM__) OrElse defined(__USE_JNI__) OrElse defined(__USE_APPLE__)
			StopTimer(@This)
		#elseif defined(__USE_APPLE__)
			mffTimerStop(@This)
		#endif
	End Destructor
End Namespace

#if defined(__USE_WASM__) OrElse defined(__USE_APPLE__)
	'Called by the ONTIMER export of Form.bas (Web), mffOnTimer of Control.bas (macOS, iOS) (setInterval of StartTimer, mff_lib.js)
	Sub TimerComponent_OnTimer(Id As Integer)
		If Id > 0 Then
			Dim As My.Sys.Forms.TimerComponent Ptr tmr = Cast(Any Ptr, Id)
			If tmr->OnTimer Then tmr->OnTimer(*tmr->Designer, *tmr)
		End If
	End Sub
#elseif defined(__USE_JNI__)
	'Called by the Handler of mffActivity.timerStart
	Sub mffActivity_onTimer Alias AddToPackage(Package, mffActivity_onTimer) (ByVal env1 As JNIEnv Ptr, This_ As jobject, Id As jlong) Export
		If Id <> 0 Then
			Dim As My.Sys.Forms.TimerComponent Ptr tmr = Cast(Any Ptr, CInt(Id))
			If tmr->OnTimer Then tmr->OnTimer(*tmr->Designer, *tmr)
		End If
	End Sub
#endif
