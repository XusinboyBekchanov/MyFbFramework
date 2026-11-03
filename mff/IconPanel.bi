'################################################################################
'#  IconPanel.bi                                                                #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Liu XiaLin                                                         #
'#  Based on:                                                                   #
'#   PsIconPanel (Paul Squires, PlanetSquires Software, MPL 2.0)                #
'#   https://github.com/PaulSquires/PsControls                                  #
'#  A fully owner-drawn icon strip rendered through the control Canvas          #
'#  (GDI+ on Windows, cairo on GTK, mcairo on WASM/Android): a run of glyph     #
'#  cells - latching toggles, momentary buttons and separator rules - laid out  #
'#  in the order supplied. Every cell width is declared, never measured.        #
'################################################################################

#include once "Control.bi"
#include once "TimerComponent.bi"

Namespace My.Sys.Forms
	#define QIconPanel(__Ptr__) (*Cast(IconPanel Ptr, __Ptr__))

	'COLORREF layout on every platform: R in bits 0..7 (shared with Progress.bi)
	#ifndef PRGB
		#define PRGB(r, g, b) (Cast(ULong, (r) Or ((g) Shl 8) Or ((b) Shl 16)))
	#endif

	Private Type IconPanelRect
		Left As Long
		Top As Long
		Right As Long
		Bottom As Long
	End Type

	'What a cell does when clicked: a toggle latches (multi-selection set),
	'a button fires and stays momentary, a separator is not interactive
	Private Enum IconPanelKinds
		ikToggle
		ikButton
		ikSeparator
	End Enum

	Private Enum IconPanelJustify
		ijLeft
		ijCenter
		ijRight
	End Enum

	Private Const ICONPANEL_DEFAULT_ICON_W As Long = 28
	Private Const ICONPANEL_DEFAULT_ICON_H As Long = 28
	Private Const ICONPANEL_DEFAULT_PAD_BEFORE As Long = 2
	Private Const ICONPANEL_DEFAULT_PAD_AFTER As Long = 2
	Private Const ICONPANEL_DEFAULT_SEPARATOR_W As Long = 9
	Private Const ICONPANEL_HOTTRACK_MS As Long = 100

	'One item. Every width below is DECLARED by the host or by the defaults -
	'nothing is measured. rcIcon/rc are derived by LayoutItems.
	Private Type IconPanelItem
		Kind As IconPanelKinds = ikButton
		Glyph As UString
		id As Long = 0
		ItemData As Integer = 0
		isSelected As Boolean = False
		isEnabled As Boolean = True
		IconWidth As Long = -1             '-1 = inherit the panel's icon size
		IconHeight As Long = -1
		PadBefore As Long = -1
		PadAfter As Long = -1
		rc As IconPanelRect                'the full cell, the FILL and HIT rect
		rcIcon As IconPanelRect            'the glyph square inside the cell
	End Type

	'`IconPanel` is an owner-drawn icon strip Control within the MyFbFramework,
	'part of the freeBasic framework (Windows, Linux, WASM, Android).
	Private Type IconPanel Extends Control
	Private:
		Dim m_Item(Any) As IconPanelItem Ptr
		Dim m_HotIdx As Long = -1
		Dim m_PressedIdx As Long = -1
		'--- Layout (logical pixels; device values scale by nScale) ---
		Dim m_IconWidth As Long = ICONPANEL_DEFAULT_ICON_W
		Dim m_IconHeight As Long = ICONPANEL_DEFAULT_ICON_H
		Dim m_PadBefore As Long = ICONPANEL_DEFAULT_PAD_BEFORE
		Dim m_PadAfter As Long = ICONPANEL_DEFAULT_PAD_AFTER
		Dim m_SeparatorWidth As Long = ICONPANEL_DEFAULT_SEPARATOR_W
		Dim m_Justify As IconPanelJustify = ijLeft
		Dim bLayoutDirty As Boolean = True
		'--- Colors (COLORREF layout on every platform) ---
		Dim m_BackColor As ULong = PRGB(33, 37, 43)
		Dim m_CellColor As ULong = PRGB(51, 55, 63)
		Dim m_CellColorHot As ULong = PRGB(62, 67, 77)
		Dim m_CellColorSelected As ULong = PRGB(74, 108, 140)
		Dim m_CellColorDisabled As ULong = PRGB(44, 48, 55)
		Dim m_GlyphColor As ULong = PRGB(190, 196, 206)
		Dim m_GlyphColorHot As ULong = PRGB(230, 234, 240)
		Dim m_GlyphColorSelected As ULong = PRGB(255, 255, 255)
		Dim m_GlyphColorDisabled As ULong = PRGB(90, 96, 106)
		Dim m_SeparatorColor As ULong = PRGB(72, 77, 86)

		Dim nScale As Single = 0
		Dim tmrHotTrack As TimerComponent

		#ifdef __USE_WINAPI__
			Declare Static Sub WndProc(ByRef Message As Message)
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
		Declare Function ItemCount() As Long
		Declare Function IsValidItem(ByVal idx As Long) As Boolean
		Declare Sub LayoutItems()
		Declare Function HitTest(ByVal x As Long, ByVal y As Long) As Long
		Declare Function ARGB(clr As ULong, Opacity As Long = 100) As ULong
		Declare Sub FillRectPath(ByVal x As Long, ByVal y As Long, ByVal w As Long, ByVal h As Long, clr As ULong)
		Declare Sub Draw()
		Declare Sub SetHot(ByVal idx As Long)
		Declare Sub ActivateItem(ByVal idx As Long)
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
		Declare Function AddItem(ByVal itemKind As IconPanelKinds, ByRef Glyph As WString, ByVal id As Long = 0, ByVal ItemData As Integer = 0) As Long
		Declare Function AddSeparator() As Long
		Declare Function GetCount As Long
		Declare Function GetItemKind(ByVal idx As Long) As IconPanelKinds
		Declare Function GetGlyph(ByVal idx As Long) As UString
		Declare Function SetGlyph(ByVal idx As Long, ByRef Glyph As WString) As Boolean
		Declare Function GetItemID(ByVal idx As Long) As Long
		Declare Function SetItemID(ByVal idx As Long, ByVal id As Long) As Boolean
		Declare Function GetItemData(ByVal idx As Long) As Integer
		Declare Function SetItemData(ByVal idx As Long, ByVal ItemData As Integer) As Boolean
		Declare Function GetSelected(ByVal idx As Long) As Boolean
		Declare Function SetSelected(ByVal idx As Long, ByVal isSelected As Boolean) As Boolean
		Declare Function GetEnabled(ByVal idx As Long) As Boolean
		Declare Function SetEnabled(ByVal idx As Long, ByVal isEnabled As Boolean) As Boolean
		Declare Function HitTestItem(ByVal x As Long, ByVal y As Long) As Long
		Declare Function GetItemRect(ByVal idx As Long, ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		Declare Function GetIdealWidth As Long
		Declare Property Justify As IconPanelJustify
		Declare Property Justify(Value As IconPanelJustify)
		Declare Property IconWidth As Long
		Declare Property IconWidth(Value As Long)
		Declare Property IconHeight As Long
		Declare Property IconHeight(Value As Long)
		Declare Property PadBefore As Long
		Declare Property PadBefore(Value As Long)
		Declare Property PadAfter As Long
		Declare Property PadAfter(Value As Long)
		Declare Property SeparatorWidth As Long
		Declare Property SeparatorWidth(Value As Long)
		Declare Property PanelBackColor As ULong
		Declare Property PanelBackColor(Value As ULong)
		Declare Property CellColor As ULong
		Declare Property CellColor(Value As ULong)
		Declare Property CellColorHot As ULong
		Declare Property CellColorHot(Value As ULong)
		Declare Property CellColorSelected As ULong
		Declare Property CellColorSelected(Value As ULong)
		Declare Property CellColorDisabled As ULong
		Declare Property CellColorDisabled(Value As ULong)
		Declare Property GlyphColor As ULong
		Declare Property GlyphColor(Value As ULong)
		Declare Property GlyphColorHot As ULong
		Declare Property GlyphColorHot(Value As ULong)
		Declare Property GlyphColorSelected As ULong
		Declare Property GlyphColorSelected(Value As ULong)
		Declare Property GlyphColorDisabled As ULong
		Declare Property GlyphColorDisabled(Value As ULong)
		Declare Property SeparatorColor As ULong
		Declare Property SeparatorColor(Value As ULong)
		Declare Function GetWindowsDPI() As Double
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		'The USER clicked a cell (a toggle flip reports its new state too)
		OnItemClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As IconPanel, ByVal Index As Long, ByVal itemKind As IconPanelKinds, ByVal isSelected As Boolean)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "IconPanel.bas"
#endif
