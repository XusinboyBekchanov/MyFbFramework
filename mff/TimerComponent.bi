'################################################################################
'#  TimerComponent.bi                                                           #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#include once "Component.bi"
#include once "IntegerList.bi"

Using My.Sys.ComponentModel

Dim Shared TimersList As IntegerList

Namespace My.Sys.Forms
	
	Type TimerComponent Extends Component
	Private:
		FEnabled As Boolean
		#ifndef __USE_GTK__
			Declare Static Sub TimerProc(hwnd As HWND, uMsg As Uint, idEvent As Integer, dwTime As DWord)
		#endif
	Public:
		ID            As Integer
		Interval      As Integer
		Declare Function ReadProperty(PropertyName As String) As Any Ptr
		Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Declare Property Enabled As Boolean
		Declare Property Enabled(Value As Boolean)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		OnTimer As Sub(ByRef Sender As TimerComponent)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "TimerComponent.bas"
#endif
