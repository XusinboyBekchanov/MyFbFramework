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
	
	Private Type TimerComponent Extends Component
	Private:
		FEnabled As Boolean
		FInterval As Integer
		#ifndef __USE_GTK__
			Declare Static Sub TimerProc(hwnd As HWND, uMsg As UINT, idEvent As Integer, dwTime As DWORD)
		#endif
	Public:
		ID            As Integer
		#ifndef ReadProperty_Off
			Declare Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property Enabled As Boolean
		Declare Property Enabled(Value As Boolean)
		Declare Property Interval As Integer
		Declare Property Interval(Value As Integer)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		OnTimer As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "TimerComponent.bas"
#endif
