'################################################################################
'#  SelectBar.bi                                                                #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Liu XiaLin                                                         #
'#  Based on:                                                                   #
'#   PsSelectBar (Paul Squires, PlanetSquires Software, MPL 2.0)                #
'#   https://github.com/PaulSquires/PsControls                                  #
'#  A fully owner-drawn selection bar rendered through the control Canvas       #
'#  (GDI+ on Windows, cairo on GTK, mcairo on WASM/Android): a flat row of      #
'#  text labels where exactly one is current, marked by a coloured line under  #
'#  the word. Reads as view choices rather than as tabs.                        #
'################################################################################

#include once "Control.bi"
#include once "TimerComponent.bi"

Namespace My.Sys.Forms
	#define QSelectBar(__Ptr__) (*Cast(SelectBar Ptr, __Ptr__))

	'COLORREF layout on every platform: R in bits 0..7 (shared with Progress.bi)
	#ifndef PRGB
		#define PRGB(r, g, b) (Cast(ULong, (r) Or ((g) Shl 8) Or ((b) Shl 16)))
	#endif

	Private Type ToggleRect2
		Left As Long
		Top As Long
		Right As Long
		Bottom As Long
	End Type

	Private Const SELECTBAR_DEFAULT_PAD_LEFT As Long = 12
	Private Const SELECTBAR_DEFAULT_PAD_RIGHT As Long = 12
	Private Const SELECTBAR_DEFAULT_INDICATOR_H As Long = 2
	Private Const SELECTBAR_DEFAULT_INDICATOR_GAP As Long = 4
	Private Const SELECTBAR_HOTTRACK_MS As Long = 100

	'One panel. nCellWidth/rc/rcText/rcIndicator are derived by LayoutPanels.
	Private Type SelectBarPanel
		Text As UString
		id As Long = 0
		ItemData As Integer = 0
		isEnabled As Boolean = True
		PadLeft As Long = -1            '-1 = inherit the bar's pad
		PadRight As Long = -1
		nCellWidth As Long = 0
		rc As ToggleRect2
		rcText As ToggleRect2
		rcIndicator As ToggleRect2
	End Type

	'`SelectBar` is an owner-drawn selection bar Control within the MyFbFramework,
	'part of the freeBasic framework (Windows, Linux, WASM, Android).
	Private Type SelectBar Extends Control
	Private:
		Dim m_Panel(Any) As SelectBarPanel Ptr
		Dim m_CurSel As Long = -1
		Dim m_HotIdx As Long = -1
		Dim m_PressedIdx As Long = -1
		'--- Layout (logical pixels; device values scale by nScale) ---
		Dim m_PadLeft As Long = SELECTBAR_DEFAULT_PAD_LEFT
		Dim m_PadRight As Long = SELECTBAR_DEFAULT_PAD_RIGHT
		Dim m_IndicatorHeight As Long = SELECTBAR_DEFAULT_INDICATOR_H
		Dim m_IndicatorGap As Long = SELECTBAR_DEFAULT_INDICATOR_GAP
		Dim bLayoutDirty As Boolean = True
		'--- Colors (COLORREF layout on every platform) ---
		Dim m_BackColor As ULong = PRGB(33, 37, 43)
		Dim m_ForeColor As ULong = PRGB(150, 156, 166)
		Dim m_BackColorHot As ULong = PRGB(33, 37, 43)
		Dim m_ForeColorHot As ULong = PRGB(215, 218, 224)
		Dim m_BackColorSelect As ULong = PRGB(33, 37, 43)
		Dim m_ForeColorSelect As ULong = PRGB(255, 255, 255)
		Dim m_ForeColorDisabled As ULong = PRGB(90, 96, 106)
		Dim m_IndicatorColor As ULong = PRGB(255, 255, 255)

		Dim nScale As Single = 0
		Dim tmrHotTrack As TimerComponent

		#ifdef __USE_WINAPI__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#elseif defined(__USE_GTK__)
			Declare Static Function OnDraw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As gpointer) As Boolean
			Declare Static Sub GTK_MouseDown(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, X As Integer, Y As Integer, Shift As Integer)
			Declare Static Sub GTK_MouseMove(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, X As Integer, Y As Integer, Shift As Integer)
			Declare Static Sub GTK_MouseUp(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, X As Integer, Y As Integer, Shift As Integer)
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		Declare Sub InitProperties()
		Declare Static Sub tmrHotTrack_Timer_(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent)
		Declare Sub tmrHotTrack_Timer(ByRef Sender As TimerComponent)
		'--- Internals ---
		Declare Function PanelCount() As Long
		Declare Function IsValidPanel(ByVal idx As Long) As Boolean
		Declare Sub LayoutPanels()
		Declare Function HitTest(ByVal x As Long, ByVal y As Long) As Long
		Declare Function TextWidthOf(ByRef Value As WString) As Long
		Declare Function TextHeightOf(ByRef Value As WString) As Long
		Declare Sub FillRectPath(ByVal x As Long, ByVal y As Long, ByVal w As Long, ByVal h As Long, clr As ULong)
		Declare Function ARGB(clr As ULong, Opacity As Long = 100) As ULong
		Declare Sub Draw()
		Declare Sub SetHot(ByVal idx As Long)
		Declare Sub SelectPanel(ByVal idx As Long)
		Declare Sub CancelPress()
	Public:
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Sub Refresh()
		Declare Sub Clear()
		Declare Function AddPanel(ByRef Text As WString, ByVal id As Long = 0, ByVal ItemData As Integer = 0) As Long
		Declare Function GetCount As Long
		'The rect queries force a pending layout, so results are always current
		Declare Function GetPanelRect(ByVal idx As Long, ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		Declare Function GetTextRect(ByVal idx As Long, ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		Declare Function GetIndicatorRect(ByVal idx As Long, ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		Declare Function GetText(ByVal idx As Long) As UString
		Declare Function SetText(ByVal idx As Long, ByRef Text As WString) As Boolean
		Declare Function GetPanelID(ByVal idx As Long) As Long
		Declare Function SetPanelID(ByVal idx As Long, ByVal id As Long) As Boolean
		Declare Function GetItemData(ByVal idx As Long) As Integer
		Declare Function SetItemData(ByVal idx As Long, ByVal ItemData As Integer) As Boolean
		Declare Function GetEnabled(ByVal idx As Long) As Boolean
		Declare Function SetEnabled(ByVal idx As Long, ByVal isEnabled As Boolean) As Boolean
		Declare Property CurSel As Long
		Declare Property CurSel(Value As Long)
		Declare Property PadLeft As Long
		Declare Property PadLeft(Value As Long)
		Declare Property PadRight As Long
		Declare Property PadRight(Value As Long)
		Declare Property IndicatorHeight As Long
		Declare Property IndicatorHeight(Value As Long)
		Declare Property IndicatorGap As Long
		Declare Property IndicatorGap(Value As Long)
		Declare Property BarBackColor As ULong
		Declare Property BarBackColor(Value As ULong)
		Declare Property BarForeColor As ULong
		Declare Property BarForeColor(Value As ULong)
		Declare Property BarForeColorHot As ULong
		Declare Property BarForeColorHot(Value As ULong)
		Declare Property BarBackColorHot As ULong
		Declare Property BarBackColorHot(Value As ULong)
		Declare Property BarBackColorSelect As ULong
		Declare Property BarBackColorSelect(Value As ULong)
		Declare Property BarForeColorSelect As ULong
		Declare Property BarForeColorSelect(Value As ULong)
		Declare Property BarForeColorDisabled As ULong
		Declare Property BarForeColorDisabled(Value As ULong)
		Declare Property IndicatorColor As ULong
		Declare Property IndicatorColor(Value As ULong)
		Declare Function GetWindowsDPI() As Double
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		'The USER picked a panel (click). Programmatic CurSel = is silent.
		OnSelect As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As SelectBar, ByVal Index As Long)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "SelectBar.bas"
#endif
