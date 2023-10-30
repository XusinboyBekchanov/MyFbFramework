'###############################################################################
'#  Animate.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#   TAnimate.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform code                                      #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                    #
'###############################################################################


#include once "Control.bi"
#ifdef GIFPlayOn
	#ifdef __FB_64BIT__
		#inclib "gdiplus"
		#include "win/gdiplus-c.bi"
	#else
		#include "win/gdiplus.bi"
		Using Gdiplus
	#endif
#endif
#ifndef __USE_GTK__
	#include once "win/dshow.bi"
#endif

Namespace My.Sys.Forms
	#define QAnimate(__Ptr__) (*Cast(Animate Ptr,__Ptr__))
	
	Private Enum CommonAVIs
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
	
	'An animate control is a window that displays an Audio-Video Interleaved (AVI) clip.
	Private Type Animate Extends Control
	Private:
		FFrameCount     As Double
		FFrameWidth     As Long
		FFrameHeight    As Long
		FFrameLeft      As Long
		FFrameTop       As Long
		FFrameWidthOrig  As Single
		FFrameHeightOrig As Single
		FPosition       As Double
		FBalance        As Long
		FVolume         As Long
		FRate           As Double
		FRatio          As Double
		FRatioFixed     As Boolean
		FFullScreenMode As Long
		FErrorInfo      As String
		FStartFrame     As Long
		FStopFrame      As Long
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
		#ifdef GIFPlayOn
			gdipToken     As ULONG_PTR
			GDIp          As GdiplusStartupInput
			gifGdipCanvas As Any Ptr 
			gifImagePtr   As Any Ptr 
			FFrameDelays(Any)  As ULong
			FFrameList    As GUID 
			gifInterval   As Integer
			gifDrawing    As Boolean
		#endif
		FFrameIndex     As Integer
		FPlayTimeStart  As Double
		FPlayTimePause  As Double
		FPlayTimePauseStart As Double
		FPlayTimeFramStart  As Double
		
		#ifdef __USE_GTK__
			Declare Static Sub Screen_Changed(widget As GtkWidget Ptr, old_screen As GdkScreen Ptr, userdata As gpointer)
			Declare Static Function DesignDraw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Declare Static Function DesignExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			Declare Static Function Timer_cb(ByVal user_data As gpointer) As gboolean
			Dim As GdkPixbufAnimation Ptr pixbuf_animation
			Dim As GdkPixbufAnimationIter Ptr iter
		#else
			Declare Static Sub WNDPROC(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			Declare Function Error_HR(ByVal hr As Integer, ByRef Inter_face As WString) As Integer
			#ifdef __USE_WINAPI__
				As IGraphBuilder   Ptr pGraph
				As IMediaControl   Ptr PControl
				As IMediaEvent     Ptr pEvent
				As IVideoWindow    Ptr VidWindow
				As IMediaSeeking   Ptr MedSeek
				As IMediaPosition  Ptr MedPosition
				As IBasicVideo     Ptr BasVideo
				As IBasicAudio     Ptr BasAudio
			#endif
		#endif
	Protected:
		FOpenMode          As Integer
		FPlay           As Boolean
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
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
		Declare Property Volume As Long
		Declare Property Volume(Value As Long)
		Declare Property Balance As Long
		Declare Property Balance(Value As Long)
		Declare Property Rate As Double
		Declare Property Rate(Value As Double)
		Declare Property RatioFixed As Boolean
		Declare Property RatioFixed(Value As Boolean)
		Declare Property FullScreenMode As Boolean
		Declare Property FullScreenMode(Value As Boolean)
		#ifdef GIFPlayOn
			Declare Sub DrawGif(ByVal FFrameIndex As Integer = 0)
		#endif
		Declare Property Position As Double
		Declare Property Position(Value As Double)
		Declare Property StartFrame As Long
		Declare Property StartFrame(Value As Long)
		Declare Property StopFrame As Long
		Declare Property StopFrame(Value As Long)
		Declare Property FrameHeight As Long
		Declare Property FrameHeight(Value As Long)
		Declare Property FrameWidth As Long
		Declare Property FrameWidth(Value As Long)
		Declare Function OpenMode As Integer
		Declare Function FrameCount As Long
		Declare Function FrameHeightOriginal As Long
		Declare Function FrameWidthOriginal As Long
		Declare Function Ratio As Double
		Declare Function IsPlaying As Boolean
		Declare Function GetErrorInfo As String
		Declare Sub SetMoviePosition(ByVal ALeft As Long, ByVal ATop As  Long, ByVal AWidth As Long, ByVal AHeight As Long)
		Declare Operator Cast As Control Ptr
		Declare Function OpenFile(ByRef FileName As WString = "") As Integer
		Declare Sub Play
		Declare Sub Pause
		Declare Sub Stop
		Declare Sub Close
		Declare Constructor
		Declare Destructor
		OnOpen  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Animate)
		OnClose As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Animate)
		OnStart As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Animate)
		OnPause As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Animate)
		OnStop  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Animate)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "Animate.bas"
#endif
