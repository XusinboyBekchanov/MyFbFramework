'###############################################################################
'#  VerticalBox.bi                                                                   #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#include once "ContainerControl.bi"

Namespace My.Sys.Forms
	#define QVerticalBox(__Ptr__) (*Cast(VerticalBox Ptr,__Ptr__))
	
	'The Vertical Box lays out its child controls verically and will not wrap onto a new line in any circumstances (Windows, Linux, Android)
	Private Type VerticalBox Extends ContainerControl
	Private:
		#ifdef __USE_WINAPI__
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			Declare Static Sub WNDPROC(ByRef Message As Message)
		#endif
	Protected:
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property Spacing As Integer
		Declare Property Spacing(Value As Integer)
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		Declare Virtual Property Text ByRef As WString
		Declare Virtual Property Text(ByRef Value As WString)
		Declare Virtual Property Visible As Boolean
		Declare Virtual Property Visible(Value As Boolean)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "VerticalBox.bas"
#endif
