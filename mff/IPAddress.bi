﻿'###############################################################################
'#  IPAddress.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov                                                #
'###############################################################################

#include once "Control.bi"

Namespace My.Sys.Forms
	#define QIPAddress(__Ptr__) (*Cast(IPAddress Ptr, __Ptr__))
	
	'`IPAddress` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`IPAddress` - An Internet Protocol (IP) address control allows the user to enter an IP address in an easily understood format.
	Private Type IPAddress Extends Control
	Private:
	Protected:
		#ifdef __USE_GTK__
			Dim As GtkWidget Ptr Layouts(3), Entries(3), CurrentEntry
			Dim As PangoContext Ptr pcontext
			Dim As PangoLayout Ptr layout
			Dim As GdkDisplay Ptr pdisplay
			Dim As GdkWindow Ptr win
			Dim As Boolean bCreated
			Dim As Integer Position
			Declare Static Sub Layout_SizeAllocate(widget As GtkWidget Ptr, allocation As GdkRectangle Ptr, user_data As Any Ptr)
			Declare Static Function Layout_Draw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Declare Static Function Layout_ExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			Declare Static Function Entry_KeyPress(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
			Declare Static Sub Entry_Activate(entry As GtkEntry Ptr, user_data As Any Ptr)
			Declare Static Sub Entry_Changed(entry As GtkEntry Ptr, user_data As Any Ptr)
			Declare Static Sub Entry_GrabFocus(widget As GtkWidget Ptr, user_data As Any Ptr)
		#else
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			Declare Static Function IPAddressWndProc(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		#ifndef ReadProperty_Off
			'Loads IP configuration from stream
			Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves IP configuration to stream
			Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property TabIndex As Integer
		'Controls focus order in tab sequence
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		'Enables/disables focus via Tab key
		Declare Property TabStop(Value As Boolean)
		Declare Property Text ByRef As WString
		'Current IP address in dotted notation (e.g., "192.168.1.1")
		Declare Property Text(ByRef Value As WString)
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		'Resets all fields to zero values
		Declare Sub Clear
		Declare Constructor
		Declare Destructor
		'Triggered when any address field is modified
		OnChange        As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As IPAddress)
		'Raised when specific octet changes
		OnFieldChanged  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As IPAddress, iField As Integer, iValue As Integer)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "IPAddress.bas"
#endif
