'################################################################################
'#  Toggle.bi                                                                   #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Liu XiaLin                                                         #
'#  Based on:                                                                   #
'#   PsToggle (Paul Squires, PlanetSquires Software, MPL 2.0)                   #
'#   https://github.com/PaulSquires/PsControls                                  #
'#  A fully owner-drawn toggle switch rendered through the control Canvas       #
'#  (GDI+ on Windows, cairo on GTK, mcairo on WASM/Android): a rounded pill     #
'#  with a knob that sits left for OFF and right for ON, hot / pressed /        #
'#  disabled / focus states, Space+Enter activation and a user-driven           #
'#  OnCheckChanged event (programmatic Checked is silent).                      #
'################################################################################

#include once "Control.bi"
#include once "TimerComponent.bi"

Namespace My.Sys.Forms
	#define QToggle(__Ptr__) (*Cast(Toggle Ptr, __Ptr__))

	'COLORREF layout on every platform: R in bits 0..7 (shared with Progress.bi)
	#ifndef PRGB
		#define PRGB(r, g, b) (Cast(ULong, (r) Or ((g) Shl 8) Or ((b) Shl 16)))
	#endif

	Private Type ToggleRect
		Left As Long
		Top As Long
		Right As Long
		Bottom As Long
	End Type

	Private Enum ToggleJustifies
		tjLeft
		tjCenter
		tjRight
	End Enum

	Private Const TOGGLE_DEFAULT_TRACK_W As Long = 40
	Private Const TOGGLE_DEFAULT_TRACK_H As Long = 20
	Private Const TOGGLE_DEFAULT_KNOB_INSET As Long = 2
	Private Const TOGGLE_DEFAULT_BORDER_THICK As Long = 1
	Private Const TOGGLE_DEFAULT_FOCUS_GAP As Long = 3
	Private Const TOGGLE_DEFAULT_FOCUS_THICK As Long = 1
	Private Const TOGGLE_HOTTRACK_MS As Long = 100

	'`Toggle` is an owner-drawn toggle switch Control within the MyFbFramework,
	'part of the freeBasic framework (Windows, Linux, WASM, Android).
	Private Type Toggle Extends Control
	Private:
		'--- State ---
		Dim isChecked As Boolean = False
		Dim isHot As Boolean = False        'the mouse is over the client
		Dim isFocused As Boolean = False
		Dim isPressed As Boolean = False    'a live left press (capture held)
		'--- Layout (logical pixels; device values scale by nScale) ---
		Dim m_TrackWidth As Long = TOGGLE_DEFAULT_TRACK_W
		Dim m_TrackHeight As Long = TOGGLE_DEFAULT_TRACK_H
		Dim m_KnobInset As Long = TOGGLE_DEFAULT_KNOB_INSET
		Dim m_BorderThickness As Long = TOGGLE_DEFAULT_BORDER_THICK
		Dim m_FocusGap As Long = TOGGLE_DEFAULT_FOCUS_GAP
		Dim m_FocusThickness As Long = TOGGLE_DEFAULT_FOCUS_THICK
		Dim m_Justify As ToggleJustifies = tjCenter
		Dim rcTrack As ToggleRect
		Dim rcKnob As ToggleRect
		Dim rcVisual As ToggleRect
		Dim bLayoutDirty As Boolean = True
		'--- Colors (COLORREF layout on every platform) ---
		Dim m_FocusRingColor As ULong = PRGB(86, 156, 214)
		'checked (ON)
		Dim m_TrackColorOn As ULong = PRGB(74, 108, 140)
		Dim m_TrackColorOnHot As ULong = PRGB(92, 132, 170)
		Dim m_TrackColorOnDisabled As ULong = PRGB(56, 70, 84)
		Dim m_TrackBorderColorOn As ULong = PRGB(74, 108, 140)
		Dim m_TrackBorderColorOnHot As ULong = PRGB(92, 132, 170)
		Dim m_TrackBorderColorOnDisabled As ULong = PRGB(56, 70, 84)
		Dim m_KnobColorOn As ULong = PRGB(216, 220, 226)
		Dim m_KnobColorOnHot As ULong = PRGB(255, 255, 255)
		Dim m_KnobColorOnDisabled As ULong = PRGB(120, 126, 134)
		'unchecked (OFF)
		Dim m_TrackColorOff As ULong = PRGB(51, 55, 63)
		Dim m_TrackColorOffHot As ULong = PRGB(62, 67, 77)
		Dim m_TrackColorOffDisabled As ULong = PRGB(44, 48, 55)
		Dim m_TrackBorderColorOff As ULong = PRGB(107, 114, 128)
		Dim m_TrackBorderColorOffHot As ULong = PRGB(138, 146, 161)
		Dim m_TrackBorderColorOffDisabled As ULong = PRGB(72, 77, 86)
		Dim m_KnobColorOff As ULong = PRGB(138, 144, 153)
		Dim m_KnobColorOffHot As ULong = PRGB(176, 182, 191)
		Dim m_KnobColorOffDisabled As ULong = PRGB(84, 89, 97)

		Dim nScale As Single = 0
		Dim tmrHotTrack As TimerComponent

		#ifdef __USE_WINAPI__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#elseif defined(__USE_GTK__)
			Dim As PangoContext Ptr pcontext
			Dim As PangoLayout Ptr layout
			Declare Static Function OnDraw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As gpointer) As Boolean
			#ifndef __USE_GTK4__
				Declare Static Function OnExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As gpointer) As Boolean
			#endif
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		Declare Sub InitProperties()
		Declare Static Sub tmrHotTrack_Timer_(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent)
		Declare Sub tmrHotTrack_Timer(ByRef Sender As TimerComponent)
		'--- Geometry ---
		Declare Sub LayoutToggle()
		Declare Function RingPad() As Long
		Declare Function KnobDiameter() As Long
		'--- Painting helpers ---
		Declare Function ARGB(clr As ULong, Opacity As Long = 100) As ULong
		Declare Sub TrackColors(ByRef clrTrack As ULong, ByRef clrBorder As ULong, ByRef clrKnob As ULong)
		Declare Sub Draw()
		Declare Sub UpdateHotTimer()
		Declare Sub CancelPress()
	Public:
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Sub Refresh()
		Declare Sub GetIdealSize(ByRef nWidth As Long, ByRef nHeight As Long)
		Declare Function GetTrackRect(ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		Declare Function GetKnobRect(ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		Declare Property Checked As Boolean
		Declare Property Checked(Value As Boolean)
		Declare Property TrackWidth As Long
		Declare Property TrackWidth(Value As Long)
		Declare Property TrackHeight As Long
		Declare Property TrackHeight(Value As Long)
		Declare Property KnobInset As Long
		Declare Property KnobInset(Value As Long)
		Declare Property BorderThickness As Long
		Declare Property BorderThickness(Value As Long)
		Declare Property FocusGap As Long
		Declare Property FocusGap(Value As Long)
		Declare Property FocusThickness As Long
		Declare Property FocusThickness(Value As Long)
		Declare Property Justify As ToggleJustifies
		Declare Property Justify(Value As ToggleJustifies)
		Declare Property FocusRingColor As ULong
		Declare Property FocusRingColor(Value As ULong)
		Declare Property TrackColorOn As ULong
		Declare Property TrackColorOn(Value As ULong)
		Declare Property TrackColorOnHot As ULong
		Declare Property TrackColorOnHot(Value As ULong)
		Declare Property TrackColorOnDisabled As ULong
		Declare Property TrackColorOnDisabled(Value As ULong)
		Declare Property TrackBorderColorOn As ULong
		Declare Property TrackBorderColorOn(Value As ULong)
		Declare Property TrackBorderColorOnHot As ULong
		Declare Property TrackBorderColorOnHot(Value As ULong)
		Declare Property TrackBorderColorOnDisabled As ULong
		Declare Property TrackBorderColorOnDisabled(Value As ULong)
		Declare Property KnobColorOn As ULong
		Declare Property KnobColorOn(Value As ULong)
		Declare Property KnobColorOnHot As ULong
		Declare Property KnobColorOnHot(Value As ULong)
		Declare Property KnobColorOnDisabled As ULong
		Declare Property KnobColorOnDisabled(Value As ULong)
		Declare Property TrackColorOff As ULong
		Declare Property TrackColorOff(Value As ULong)
		Declare Property TrackColorOffHot As ULong
		Declare Property TrackColorOffHot(Value As ULong)
		Declare Property TrackColorOffDisabled As ULong
		Declare Property TrackColorOffDisabled(Value As ULong)
		Declare Property TrackBorderColorOff As ULong
		Declare Property TrackBorderColorOff(Value As ULong)
		Declare Property TrackBorderColorOffHot As ULong
		Declare Property TrackBorderColorOffHot(Value As ULong)
		Declare Property TrackBorderColorOffDisabled As ULong
		Declare Property TrackBorderColorOffDisabled(Value As ULong)
		Declare Property KnobColorOff As ULong
		Declare Property KnobColorOff(Value As ULong)
		Declare Property KnobColorOffHot As ULong
		Declare Property KnobColorOffHot(Value As ULong)
		Declare Property KnobColorOffDisabled As ULong
		Declare Property KnobColorOffDisabled(Value As ULong)
		Declare Function GetWindowsDPI() As Double
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		'The USER flipped the toggle (click release, Space or Enter). Programmatic
		'Checked = is silent, following the Win32 BM_SETCHECK / BN_CLICKED precedent.
		OnCheckChanged As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Toggle, ByVal isChecked As Boolean)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "Toggle.bas"
#endif
