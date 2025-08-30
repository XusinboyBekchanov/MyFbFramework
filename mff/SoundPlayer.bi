'###############################################################################
'#  SoundPlayer.bi                                                             #
'#  This file is part of MyFBFramework                                         #
'#  Authors: D.J.Peters (Joshy), Xusinboy Bekchanov, Liu XiaLin                #
'#  Based on:                                                                  #
'#   FBsound_oop.bi                                                            #
'#   A free sound library primarily for games                                  #
'#   Copyright 2005-2020 by D.J.Peters (Joshy)                                 #
'#   Version 1.2.0                                                             #
'###############################################################################
'#include once "fbsound.bi"
'#include once "fbsound/fbs-config.bi"
#ifndef __FBSOUND_OOP_BI__
	#define __FBSOUND_OOP_BI__
#endif ' #define __FBSOUND_OOP_BI__
#include once "fbsound/fbs-config.bi"
#if Not defined(FBSOUND_USE_DYNAMIC )
	'#define FBSOUND_USE_STATIC
	#include once "fbsound/fbsound.bi"
	#include once "fbsound/fbsound.bas"
	#include once "fbsound/plug.bi"
	#include once "fbsound/plug-static.bi"
	#include once "fbsound/plug-ds.bas"
	#include once "fbsound/plug-static.bas"
	#include once "fbsound/plug-mm.bas"
	#inclib "dumb"
	#inclib "mad"
	
#else
	'#define FBSOUND_USE_DYNAMIC
	#include once "fbsound/fbsound_dynamic.bi"
#endif

'Namespace My.Sys.Media
Type SoundDevice
	Declare Constructor(ByVal nRate As Integer = 44100, _
	ByVal nChannels    As Integer=    2, _
	ByVal nBuffers     As Integer=    3, _
	ByVal nFrames      As Integer= 2048, _
	ByVal nPlugIndex   As Integer=    0, _
	ByVal nDeviceIndex As Integer =    0)
	Declare Function Init(ByVal nRate As Integer = 44100, _
	ByVal nChannels    As Integer=    2, _
	ByVal nBuffers     As Integer=    3, _
	ByVal nFrames      As Integer= 2048, _
	ByVal nPlugIndex   As Integer=    0, _
	ByVal nDeviceIndex As Integer =    0) As Boolean
	Declare Property Volume As Single
	Declare Property Volume(ByVal newVolume As Single)
Private:
	As Boolean IsInit
End Type

Type SampleBuffer
	Declare Constructor
	Declare Constructor(ByVal nSamples As Integer, ByRef pSamples As Any Ptr)
	Declare Constructor(ByRef FileName As WString)
	Declare Function getHandle() As Integer
	Declare Function Create(ByVal nSamples As Integer, ByRef pSamples As Any Ptr) As Boolean
	Declare Function Load(ByRef FileName As WString) As Boolean
	Declare Function Destroy() As Boolean
	Declare Function Length() As Double
	
	Declare Sub AddReference
	Declare Sub FreeReference
	As String lastError
Private:
	As Integer hWave
	As Integer nReferences
End Type

Type SoundPlayer
	Declare Constructor
	Declare Constructor(ByRef buffer As SampleBuffer)
	Declare Constructor(ByVal BufferPtr As SampleBuffer Ptr)
	Declare Constructor(ByRef FileName As WString)
	Declare Destructor
	Declare Function Create(ByRef buffer As SampleBuffer) As Boolean
	Declare Function Create(ByVal BufferPtr As SampleBuffer Ptr) As Boolean
	Declare Function Load(ByRef FileName As WString) As Boolean
	Declare Sub      Destroy()
	Declare Property Volume As Single
	Declare Property Volume(ByVal newVolume As Single)
	Declare Property SoundLocation ByRef As WString
	Declare Property SoundLocation(ByRef FileName As WString)
	Declare Property MasterVolume As Single
	Declare Property MasterVolume(ByVal newVolume As Single)
	Declare Property Loops As Integer
	Declare Property Loops(ByVal newLoop As Integer)
	Declare Property Speed As Single
	Declare Property Speed(ByVal newSpeed As Single)
	Declare Property Pan As Single
	Declare Property Pan(ByVal newPan As Single)
	Declare Function Play(ByVal nLoops As Integer = 1) As Boolean
	Declare Property Pause As Boolean
	Declare Property Pause(ByVal bMute As Boolean)
	Declare Property Mute As Boolean
	Declare Property Mute(ByVal bMute As Boolean)
	Declare Function Playposition As Single
	Declare Function Length() As Double
Private:
	As SampleBuffer Ptr pBuffer
	As Integer          hSound
	As Double           pLength = 0.0
	As WString * 260    FSoundLocation
End Type
'End Namespace
#ifndef __USE_MAKE__
	#include once "SoundPlayer.bas"
#endif