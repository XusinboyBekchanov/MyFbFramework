'################################################################################
'#  ColorPicker.bi                                                              #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Liu XiaLin                                                         #
'#  Based on:                                                                   #
'#   PsColorPicker (Paul Squires, PlanetSquires Software, MPL 2.0)              #
'#   https://github.com/PaulSquires/PsControls                                  #
'#  A fully owner-drawn colour picker rendered through the control Canvas       #
'#  (GDI+ on Windows, cairo on GTK, mcairo on WASM/Android): a tab strip over   #
'#  a Web named-colour list and a 16x14 hue/lightness matrix, a split           #
'#  Initial/Current preview, hand-rolled R/G/B(/A) entry fields and a single    #
'#  OK button that commits. Use the module-level ShowColorPicker to run it as   #
'#  a modal dialog (MFF Form.ShowModal) and get the answer back.                #
'#                                                                              #
'#  Deliberate departures from PsColorPicker:                                   #
'#   - The System tab reads GetSysColor (Windows-only) and is omitted.          #
'#   - The list scrollbar is drawn in-control instead of a child scrollbar,     #
'#     so the popup keeps zero child windows on every platform.                 #
'#   - The modal shell is a fixed-dialog Form (MFF convention), so a click      #
'#     outside is not reachable - Esc is the cancel path.                       #
'################################################################################

#include once "Control.bi"
#include once "TimerComponent.bi"

Namespace My.Sys.Forms
	#define QColorPicker(__Ptr__) (*Cast(ColorPicker Ptr, __Ptr__))

	'COLORREF layout on every platform: R in bits 0..7 (shared with Progress.bi)
	#ifndef PRGB
		#define PRGB(r, g, b) (Cast(ULong, (r) Or ((g) Shl 8) Or ((b) Shl 16)))
	#endif

	Private Type ColorPickerRect
		Left As Long
		Top As Long
		Right As Long
		Bottom As Long
	End Type

	'The two tabs. The System tab of PsColorPicker is Windows-only and is not ported.
	Private Enum ColorPickerTabs
		cpTabWeb = 0
		cpTabCustom = 1
	End Enum

	'Phase of a change, mirroring PsSplitter: dragging the matrix emits BEGIN,
	'many MOVEs, then END; a swatch click or a committed field emits one END.
	'A host driving a live preview coalesces MOVE notifications.
	Private Enum ColorPickerPhases
		cpPhaseBegin = 0
		cpPhaseMove
		cpPhaseEnd
	End Enum

	'The entry fields, in Tab order (the order is also the visual order)
	Private Enum ColorPickerFields
		cpFieldR = 0
		cpFieldG
		cpFieldB
		cpFieldA
		cpFieldCount
	End Enum

	'Layout constants, logical pixels (device values scale by nScale)
	Private Const COLORPICKER_PAD As Long = 8
	Private Const COLORPICKER_GAP As Long = 6
	Private Const COLORPICKER_TAB_H As Long = 24
	Private Const COLORPICKER_TAB_PAD As Long = 14
	Private Const COLORPICKER_MATRIX_COLS As Long = 16
	Private Const COLORPICKER_MATRIX_ROWS As Long = 14
	Private Const COLORPICKER_CELL_W As Long = 18
	Private Const COLORPICKER_CELL_H As Long = 22
	Private Const COLORPICKER_SWATCH_W As Long = 34
	Private Const COLORPICKER_LIST_ROWS As Long = 14
	Private Const COLORPICKER_ROW_H As Long = 22
	Private Const COLORPICKER_SCROLL_W As Long = 12
	Private Const COLORPICKER_PREVIEW_W As Long = 92
	Private Const COLORPICKER_PREVIEW_H As Long = 46
	Private Const COLORPICKER_FIELD_W As Long = 58
	Private Const COLORPICKER_FIELD_H As Long = 24
	Private Const COLORPICKER_LABEL_W As Long = 52
	Private Const COLORPICKER_OK_W As Long = 92
	Private Const COLORPICKER_OK_H As Long = 30
	Private Const COLORPICKER_CURVATURE As Long = 4   'corner RADIUS (logical px) of the swatches and buttons; -1 on the control follows the framework default
	Private Const COLORPICKER_RING_INSET As Long = 1
	Private Const COLORPICKER_HOTTRACK_MS As Long = 100
	Private Const COLORPICKER_CARET_MS As Long = 500

	'`ColorPicker` is an owner-drawn colour picker Control within the MyFbFramework,
	'part of the freeBasic framework (Windows, Linux, WASM, Android).
	Private Type ColorPicker Extends Control
	Private:
		'--- The value ---
		Dim m_Color As ULong = 0
		Dim m_Alpha As UByte = 255
		Dim m_InitialColor As ULong = 0
		Dim m_InitialAlpha As UByte = 255
		'--- Tabs / body selection ---
		Dim m_Tab As Long = cpTabCustom
		Dim m_ShowAlpha As Boolean = True
		Dim m_BodySel As Long = -1        'cell of the current tab's body, re-derived
		Dim m_ScrollTop As Long = 0       'first visible row of the Web list
	'--- Modal-free state ---
	Dim m_IsDragging As Boolean = False
	Dim m_HotTab As Long = -1
	Dim m_HotSwatch As Long = -1
	Dim m_HotField As Long = -1
	Dim m_OKHot As Boolean = False
	Dim m_OKPressed As Boolean = False
	'--- Corner radius (LOGICAL pixels) of the swatches and buttons; -1 follows
	'the framework default (g_DefaultCornerRadius) ---
	Dim m_Curvature As Long = -1
		'--- The one edit buffer (only the focused field can be edited) ---
		Dim m_FocusField As Long = -1
		Dim m_Edit As String
		Dim m_EditFresh As Boolean = False
		Dim m_Caret As Long = 0
		Dim m_CaretOn As Boolean = False
		'--- Layout rects (device pixels, derived in LayoutPicker) ---
		Dim rcTabs As ColorPickerRect
		Dim rcBody As ColorPickerRect
		Dim rcMatrix As ColorPickerRect
		Dim rcList As ColorPickerRect
		Dim rcScroll As ColorPickerRect
		Dim rcScrollThumb As ColorPickerRect
		Dim rcPreview As ColorPickerRect
		Dim rcInitial As ColorPickerRect
		Dim rcCurrent As ColorPickerRect
		Dim rcInitialLabel As ColorPickerRect
		Dim rcCurrentLabel As ColorPickerRect
		Dim rcFields As ColorPickerRect
		Dim rcField(cpFieldCount - 1) As ColorPickerRect
		Dim rcFieldLabel(cpFieldCount - 1) As ColorPickerRect
		Dim rcOK As ColorPickerRect
		Dim m_TabTextW(1) As Long
		Dim bLayoutDirty As Boolean = True
		Dim m_bScrollingThumb As Boolean = False
		'--- Colors (COLORREF layout on every platform) ---
		Dim m_ChromeBackColor As ULong = PRGB(44, 49, 58)
		Dim m_ForeColor As ULong = PRGB(200, 205, 214)
		Dim m_BorderColor As ULong = PRGB(68, 74, 86)
		Dim m_TabBackColor As ULong = PRGB(44, 49, 58)
		Dim m_TabBackColorSel As ULong = PRGB(55, 61, 72)
		Dim m_TabForeColor As ULong = PRGB(150, 156, 167)
		Dim m_TabForeColorSel As ULong = PRGB(226, 230, 238)
		Dim m_FieldBackColor As ULong = PRGB(33, 37, 43)
		Dim m_FieldForeColor As ULong = PRGB(200, 205, 214)
		Dim m_FieldBorderColor As ULong = PRGB(68, 74, 86)
		Dim m_FieldBorderColorSel As ULong = PRGB(97, 175, 239)
		Dim m_HotRingColor As ULong = PRGB(255, 255, 255)
		Dim m_SelRingColor As ULong = PRGB(97, 175, 239)
		Dim m_FocusRingColor As ULong = PRGB(97, 175, 239)
		Dim m_OKBackColor As ULong = PRGB(55, 61, 72)
		Dim m_OKBackColorHot As ULong = PRGB(68, 74, 86)
		Dim m_OKBackColorPressed As ULong = PRGB(40, 45, 53)
		Dim m_OKForeColor As ULong = PRGB(226, 230, 238)
		Dim m_OKBorderColor As ULong = PRGB(68, 74, 86)
		'--- Host words (the control does no localization) ---
		Dim m_TextOK As WString Ptr
		Dim m_TextInitial As WString Ptr
		Dim m_TextCurrent As WString Ptr
		Dim m_TextField(cpFieldCount - 1) As WString Ptr

		Dim nScale As Single = 0
		Dim tmrHotTrack As TimerComponent
		Dim tmrCaret As TimerComponent

		#ifdef __USE_WINAPI__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#elseif defined(__USE_GTK__)
			Dim As PangoContext Ptr pcontext
			Dim As PangoLayout Ptr layout
			Declare Static Function OnDraw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As gpointer) As Boolean
			Declare Static Sub GTK_MouseDown(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, X As Integer, Y As Integer, Shift As Integer)
			Declare Static Sub GTK_MouseMove(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, X As Integer, Y As Integer, Shift As Integer)
			Declare Static Sub GTK_MouseUp(ByRef Designer As My.Sys.Object, ByRef Sender As Control, MouseButton As Integer, X As Integer, Y As Integer, Shift As Integer)
			Declare Static Sub GTK_MouseWheel(ByRef Designer As My.Sys.Object, ByRef Sender As Control, Delta As Integer, X As Integer, Y As Integer, Shift As Integer)
			Declare Static Sub GTK_KeyDown(ByRef Designer As My.Sys.Object, ByRef Sender As Control, Key As Integer, Shift As Integer)
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		Declare Sub InitProperties()
		Declare Static Sub tmrHotTrack_Timer_(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent)
		Declare Sub tmrHotTrack_Timer(ByRef Sender As TimerComponent)
		Declare Static Sub tmrCaret_Timer_(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent)
		Declare Sub tmrCaret_Timer(ByRef Sender As TimerComponent)
		'--- Layout ---
		Declare Sub LayoutPicker()
		Declare Sub BodyRects
		'--- Pure colour laws ---
		Declare Static Function MatrixColorAt(ByVal nCol As Long, ByVal nRow As Long, ByVal nCols As Long, ByVal nRows As Long) As ULong
		Declare Static Sub HSLtoRGB(ByVal h As Double, ByVal s As Double, ByVal l As Double, ByRef nR As Long, ByRef nG As Long, ByRef nB As Long)
		Declare Function MatrixIndexOf(ByVal clr As ULong, ByRef nCol As Long, ByRef nRow As Long) As Boolean
		Declare Function CellFromPoint(ByVal x As Long, ByVal y As Long, ByRef rc As ColorPickerRect, ByVal nCols As Long, ByRef nCol As Long, ByRef nRow As Long) As Boolean
		'--- Web table ---
		Declare Static Function WebColorCount() As Long
		Declare Static Function WebColorAt(ByVal idx As Long) As ULong
		Declare Static Function WebColorName(ByVal idx As Long) As UString
		'Measures a label on a private canvas so a live paint session is not disturbed
		Declare Function TextWidthOf(ByRef Value As WString) As Long
		'--- Painting helpers ---
		Declare Function ARGB(clr As ULong, Opacity As Long = 100) As ULong
		'This picker's resolved corner radius (DEVICE pixels) for swatches/buttons
		Declare Function CurvDev() As Long
		Declare Sub FillRectPath(ByVal x As Long, ByVal y As Long, ByVal w As Long, ByVal h As Long, clr As ULong)
		Declare Sub StrokeRectPath(ByVal x As Long, ByVal y As Long, ByVal w As Long, ByVal h As Long, clr As ULong, ByVal PenWidth As Single = 1)
		Declare Sub Draw()
		Declare Sub DrawMatrix
		Declare Sub DrawList
		Declare Sub DrawFooter
		Declare Function ChannelText(ByVal idx As Long) As String
		'--- Interaction ---
		Declare Function HitTestField(ByVal x As Long, ByVal y As Long) As Long
		Declare Function TabFromPoint(ByVal x As Long, ByVal y As Long) As Long
		Declare Function ListRowCount() As Long
		Declare Sub SetScrollTop(ByVal Value As Long, ByVal bRepaint As Boolean = True)
		Declare Sub SyncBodySel
		Declare Sub SetColorInternal(ByVal clr As ULong, ByVal nPhase As Long)
		Declare Function EnterField(ByVal idx As Long) As Boolean
		Declare Sub CommitField
		Declare Function KeyEdit(KeyCode As Long) As Boolean
		Declare Sub HandleChar(ByVal ch As Long)
		Declare Sub MouseDownAt(ByVal x As Long, ByVal y As Long)
		Declare Sub MouseMoveAt(ByVal x As Long, ByVal y As Long)
		Declare Sub MouseUpAt(ByVal x As Long, ByVal y As Long)
		Declare Sub WheelAt(ByVal Delta As Long)
		Declare Sub RepaintAsync
		Declare Sub SetHotTab(ByVal idx As Long)
		Declare Sub SetHotSwatch(ByVal idx As Long)
		Declare Sub SetHotField(ByVal idx As Long)
		Declare Sub CancelOKPress
		Public:
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Sub Refresh()
		Declare Sub GetIdealSize(ByRef nWidth As Long, ByRef nHeight As Long)
		Declare Sub SetInitialColor(ByVal clr As ULong, ByVal nAlpha As UByte = 255)
		Declare Property PickedColor As ULong
		Declare Property PickedColor(Value As ULong)
		Declare Property PickedAlpha As UByte
		Declare Property PickedAlpha(Value As UByte)
		Declare Property ShowAlpha As Boolean
		Declare Property ShowAlpha(Value As Boolean)
		Declare Property PickerTab As Long
		Declare Property PickerTab(Value As Long)
		'Corner RADIUS (logical pixels) of the swatches and buttons; -1 follows
		'the framework default (Application.DefaultCornerRadius)
		Declare Property CornerCurvature As Long
		Declare Property CornerCurvature(Value As Long)
		Declare Property TextOK() ByRef As WString
		Declare Property TextOK(Value As WString)
		Declare Property TextInitial() ByRef As WString
		Declare Property TextInitial(Value As WString)
		Declare Property TextCurrent() ByRef As WString
		Declare Property TextCurrent(Value As WString)
		Declare Property TextFieldLabel(ByVal idx As Long) As UString
		Declare Property TextFieldLabel(ByVal idx As Long, Value As WString)
		Declare Property ChromeBackColor As ULong
		Declare Property ChromeBackColor(Value As ULong)
		Declare Property ChromeForeColor As ULong
		Declare Property ChromeForeColor(Value As ULong)
		Declare Property ChromeBorderColor As ULong
		Declare Property ChromeBorderColor(Value As ULong)
		Declare Function GetWindowsDPI() As Double
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		'USER changed the value (matrix drag with BEGIN/MOVE/END phases, swatch
		'click or committed field = one END). Programmatic PickedColor is silent.
		OnColorChanged As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ColorPicker, ByVal clr As ULong, ByVal nAlpha As UByte, ByVal nPhase As Long)
		'The USER switched tabs. Programmatic PickerTab is silent.
		OnTabChanged As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ColorPicker, ByVal nTab As Long)
		'The USER pressed OK - the only commit path. The Esc key raises OnCancel.
		OnOK As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ColorPicker)
		OnCancel As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ColorPicker)
	End Type

	'Standalone modal helper: runs the picker in a fixed-dialog Form and returns
	'TRUE with the chosen colour (and alpha) written back, FALSE if cancelled.
	Declare Function ShowColorPicker(ByRef InitialColor As ULong, ByRef OutColor As ULong, ByRef OutAlpha As UByte, ByVal ShowAlphaCh As Boolean = True, ByRef Caption As WString = "Select color") As Boolean
End Namespace

#ifndef __USE_MAKE__
	#include once "ColorPicker.bas"
#endif
