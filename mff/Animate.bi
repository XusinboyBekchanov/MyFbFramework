'###############################################################################
'#  Animate.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor                                                     #
'#  Based on:                                                                  #
'#   TAnimate.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'###############################################################################

#include once "Control.bi"

Namespace My.Sys.Forms
	#define QAnimate(__Ptr__) *Cast(Animate Ptr,__Ptr__)
	
	Enum CommonAVIs
		aviNone         = 0
		aviFindFolder   = 150
		aviFindFile     = 151
		aviFindComputer = 152
		aviCopyFiles    = 160
		aviCopyFile     = 161
		aviRecycleFile  = 162
		aviEmptyRecycle = 163
		aviDeleteFile   = 164
		aviCopyFileEx   = 165
	End Enum
	
	Type Animate Extends Control
	Private:
		FFrameCount     As Integer
		FFrameWidth     As Integer
		FFrameHeight    As Integer
		FStartFrame     As Integer
		FStopFrame      As Integer
		FAutoSize       As Boolean
		FRepeat         As Integer
		FCommonAvi      As CommonAVIs
		FAutoPlay       As Boolean
		FTransparent    As Boolean
		FCenter         As Boolean
		FTimers         As Boolean
		FFile           As WString Ptr
		ATimer(2)       As Integer
		ACenter(2)      As Integer
		ATransparent(2) As Integer
		AAutoPlay(2)    As Integer
		SupportsAlpha   As Boolean
		#ifdef __USE_GTK__
			Declare Static Sub Screen_Changed(widget As GtkWidget Ptr, old_screen As GdkScreen Ptr, userdata As gpointer)
			Declare Static Function DesignDraw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Declare Static Function DesignExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			Declare Static Function Timer_cb(ByVal user_data As gpointer) As gboolean
			Dim As GdkPixbufAnimation Ptr pixbuf_animation
			Dim As GdkPixbufAnimationIter Ptr iter
		#else
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#endif
	Protected:
		FOpen           As Boolean
		FPlay           As Boolean
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		Declare Sub GetAnimateInfo
	Public:
		Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Declare Property Center As Boolean
		Declare Property Center(Value As Boolean)
		Declare Property Transparency As Boolean
		Declare Property Transparency(Value As Boolean)
		Declare Property Timers As Boolean
		Declare Property Timers(Value As Boolean)
		Declare Property File ByRef As WString
		Declare Property File(ByRef Value As WString)
		Declare Property AutoPlay As Boolean
		Declare Property AutoPlay(Value As Boolean)
		Declare Property AutoSize As Boolean
		Declare Property AutoSize(Value As Boolean)
		Declare Property CommonAvi As CommonAVIs
		Declare Property CommonAvi(Value As CommonAVIs)
		Declare Property Repeat As Integer
		Declare Property Repeat(Value As Integer)
		Declare Property StartFrame As Integer
		Declare Property StartFrame(Value As Integer)
		Declare Property StopFrame As Integer
		Declare Property StopFrame(Value As Integer)
		Declare Function FrameCount As Integer
		Declare Operator Cast As Control Ptr
		Declare Sub Open
		Declare Sub Play
		Declare Sub Stop
		Declare Sub Close
		Declare Constructor
		Declare Destructor
		OnOpen  As Sub(ByRef Sender As Animate)
		OnClose As Sub(ByRef Sender As Animate)
		OnStart As Sub(ByRef Sender As Animate)
		OnStop  As Sub(ByRef Sender As Animate)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "Animate.bas"
#endif
