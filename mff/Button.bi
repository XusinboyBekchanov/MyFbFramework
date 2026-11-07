'################################################################################
'#  Button.bi                                                                   #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Liu XiaLin                                                         #
'#  Based on:                                                                   #
'#   PsButton (Paul Squires, PlanetSquires Software, MPL 2.0)                   #
'#   https://github.com/PaulSquires/PsControls                                  #
'#  A fully owner-drawn command button rendered through the control Canvas      #
'#  (GDI+ on Windows, cairo on GTK, mcairo on WASM/Android): a rounded rect     #
'#  with an optional Fluent glyph on the left, an optional caption and an       #
'#  optional glyph on the right, four moods with a real pressed set, a          #
'#  default-button border overlay, Space+Enter activation and a Click event     #
'#  that also fires for the programmatic Click action. Momentary - it never     #
'#  latches. The native CommandButton wrapper keeps its name; "Button" is       #
'#  free in this framework, so no Ex suffix is needed.                          #
'################################################################################

#include once "Control.bi"
#include once "TimerComponent.bi"

Namespace My.Sys.Forms
	#define QPushButton(__Ptr__) (*Cast(Button Ptr, __Ptr__))

	'COLORREF layout on every platform: R in bits 0..7 (shared with Progress.bi)
	#ifndef PRGB
		#define PRGB(r, g, b) (Cast(ULong, (r) Or ((g) Shl 8) Or ((b) Shl 16)))
	#endif

	'Where the caption sits in the span between the two icon cells. The icon
	'cells are PINNED to the padding and are never moved by the alignment - so
	'with a left icon and baCenter the caption is centred on the LEFTOVER span,
	'not on the button.
	Private Enum ButtonAligns
		baLeft
		baCenter
		baRight
	End Enum

	'Which of the four colour sets the painter uses: disabled > pressed > hot
	'> idle. isDefault is deliberately NOT a mood - it overlays one colour,
	'the border, on top of whichever mood resolved.
	Private Enum ButtonMoods
		bmIdle
		bmHot
		bmPressed
		bmDisabled
	End Enum

	'Polling timer that guarantees hot-tracking is cleared when the mouse
	'leaves the control
	Private Const BUTTON_HOTTRACK_MS As Long = 100

	'Default geometry (logical pixels; device values scale by nScale). The two
	'THICKNESS values are NOT DPI-scaled: a hairline stays a hairline.
	Private Const BUTTON_DEFAULT_PADLEFT As Long = 12
	Private Const BUTTON_DEFAULT_PADRIGHT As Long = 12
	Private Const BUTTON_DEFAULT_PADTOP As Long = 6
	Private Const BUTTON_DEFAULT_PADBOTTOM As Long = 6
	'Gap between an icon cell and the caption; spent only when there IS a caption
	Private Const BUTTON_DEFAULT_ICONGAP As Long = 8
	'The icon cell. DECLARED, never measured: a glyph font too large for the
	'cell simply clips rather than resizing the button.
	Private Const BUTTON_DEFAULT_ICONWIDTH As Long = 16
	Private Const BUTTON_DEFAULT_ICONHEIGHT As Long = 16
	'Corner RADIUS (logical pixels) of the rounded chrome; the whole family
	'speaks radius now - ResolveCornerRadius turns -1 into the framework
	'default (g_DefaultCornerRadius) or this built-in
	Private Const BUTTON_DEFAULT_CURVATURE As Long = 6
	'0 disables the border outright
	Private Const BUTTON_DEFAULT_BORDERTHICK As Long = 1
	Private Const BUTTON_DEFAULT_FOCUSGAP As Long = 2
	Private Const BUTTON_DEFAULT_FOCUSTHICK As Long = 1
	Private Const BUTTON_DEFAULT_GLYPHPOINT As Long = 12

	'`Button` is an owner-drawn command button Control within the MyFbFramework,
	'part of the freeBasic framework (Windows, Linux, WASM, Android).
	Private Type Button Extends Control
	Private:
		'--- Content. The caption lives in the base Control's Text. ---
		Dim FGlyphLeft As WString Ptr
		Dim FGlyphRight As WString Ptr
		Dim FGlyphFontName As WString Ptr
		Dim FGlyphFontPoint As Integer = BUTTON_DEFAULT_GLYPHPOINT
		'--- State. Momentary: there is no checked state to hold. ---
		Dim isHot As Boolean = False        'the mouse is over the client
		Dim isFocused As Boolean = False
		Dim isPressed As Boolean = False    'a live left press (capture held)
		Dim m_IsDefault As Boolean = False  'appearance only
		Dim m_ID As Long = 0                'host command id, reported by OnClick
		'Set when a WM_KEYDOWN we consume will be followed by a WM_CHAR, so that
		'character can be swallowed too; without it the system BEEPS on every
		'Enter/Space - the keystroke still works, the beep is the only symptom
		Dim bAteKeyDown As Boolean = False
		'--- Layout inputs (logical pixels; device values scale by nScale) ---
		Dim m_TextAlign As ButtonAligns = baCenter
		Dim m_AutoSize As Boolean = False
		Dim m_PadLeft As Long = BUTTON_DEFAULT_PADLEFT
		Dim m_PadTop As Long = BUTTON_DEFAULT_PADTOP
		Dim m_PadRight As Long = BUTTON_DEFAULT_PADRIGHT
		Dim m_PadBottom As Long = BUTTON_DEFAULT_PADBOTTOM
		Dim m_IconGap As Long = BUTTON_DEFAULT_ICONGAP
		Dim m_IconWidth As Long = BUTTON_DEFAULT_ICONWIDTH
		Dim m_IconHeight As Long = BUTTON_DEFAULT_ICONHEIGHT
		Dim m_Curvature As Long = BUTTON_DEFAULT_CURVATURE
		Dim m_BorderThickness As Long = BUTTON_DEFAULT_BORDERTHICK
		Dim m_FocusGap As Long = BUTTON_DEFAULT_FOCUSGAP
		Dim m_FocusThickness As Long = BUTTON_DEFAULT_FOCUSTHICK
		'--- Layout outputs (device pixels; derived in LayoutButton) ---
		Dim nTextWidth As Long = 0
		Dim nTextHeight As Long = 0
		Dim nIdealW As Long = 0
		Dim nIdealH As Long = 0
		Dim rcButton As Rect
		Dim rcIconLeft As Rect
		Dim rcText As Rect    'the SPAN between the icons, not the ink
		Dim rcIconRight As Rect
		Dim rcVisual As Rect
		Dim bLayoutDirty As Boolean = True
		'--- Colors (COLORREF layout on every platform). FOUR MOODS, precedence
		'    disabled > pressed > hot > idle, with a real PRESSED set - a
		'    command button's press is the one piece of feedback the user
		'    relies on. The button reads BORDERLESS by default because every
		'    BorderColorXxx defaults EQUAL to the matching BackColorXxx; the
		'    icon follows the caption the same way. ---
		Dim m_BackColorHot As ULong = PRGB(55, 61, 72)
		Dim m_BackColorPressed As ULong = PRGB(38, 79, 120)
		Dim m_BackColorDisabled As ULong = PRGB(40, 44, 51)
		Dim m_ForeColor As ULong = PRGB(200, 205, 214)
		Dim m_ForeColorHot As ULong = PRGB(226, 230, 238)
		Dim m_ForeColorPressed As ULong = PRGB(255, 255, 255)
		Dim m_ForeColorDisabled As ULong = PRGB(96, 102, 112)
		Dim m_BorderColor As ULong = PRGB(44, 49, 58)
		Dim m_BorderColorHot As ULong = PRGB(55, 61, 72)
		Dim m_BorderColorPressed As ULong = PRGB(38, 79, 120)
		Dim m_BorderColorDisabled As ULong = PRGB(40, 44, 51)
		Dim m_IconColor As ULong = PRGB(200, 205, 214)
		Dim m_IconColorHot As ULong = PRGB(226, 230, 238)
		Dim m_IconColorPressed As ULong = PRGB(255, 255, 255)
		Dim m_IconColorDisabled As ULong = PRGB(96, 102, 112)
		Dim m_FocusRingColor As ULong = PRGB(97, 175, 239)
		'The ONLY colour that is not part of a mood: it replaces whatever
		'border the resolved mood would have used, which is what makes "the
		'default button" a single visible outline on an otherwise borderless
		'button
		Dim m_DefaultBorderColor As ULong = PRGB(97, 175, 239)

		Dim nScale As Single = 0
		Dim tmrHotTrack As TimerComponent

		#ifdef __USE_WINAPI__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#elseif defined(__USE_GTK__)
			Dim As PangoContext Ptr pcontext
			Dim As PangoLayout Ptr layout
			Declare Static Function OnDraw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As gpointer) As Boolean
			#ifndef __USE_GTK4__
				Declare Static Function OnExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As gpointer) As Boolean
			#endif
			Declare Static Sub OnSizeAllocate(widget As GtkWidget Ptr, allocation As GdkRectangle Ptr, user_data As Any Ptr)
		#elseif defined(__USE_WASM__) OrElse defined(__USE_JNI__)
			Declare Static Sub HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		Declare Sub InitProperties()
		Declare Static Sub tmrHotTrack_Timer_(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent)
		Declare Sub tmrHotTrack_Timer(ByRef Sender As TimerComponent)
		'--- Geometry ---
		Declare Function RingPad() As Long
		Declare Function HasText() As Boolean
		Declare Function HasIconLeft() As Boolean
		Declare Function HasIconRight() As Boolean
		Declare Sub MeasureText(ByRef nWidth As Long, ByRef nHeight As Long)
		Declare Sub LayoutButton()
		Declare Function ResolvedMood() As ButtonMoods
		'The factory mood palette per app theme; False = the manual m_* set
		Declare Function ThemeColors(ByVal mood As ButtonMoods, ByRef clrBack As ULong, ByRef clrFore As ULong, ByRef clrBorder As ULong, ByRef clrIcon As ULong) As Boolean
		'The parent's effective background (theme-resolved) for the corner band
		Declare Function ParentBack() As ULong
		Declare Sub ResolvedColors(ByRef clrBack As ULong, ByRef clrFore As ULong, ByRef clrBorder As ULong, ByRef clrIcon As ULong)
		Declare Sub ApplyAutoSize()
		'--- Painting helpers ---
		Declare Function ARGB(clr As ULong, Opacity As Long = 100) As ULong
		#ifdef __USE_WINAPI__
			Declare Function FontHasGlyph(ByRef sFace As WString) As Boolean
		#endif
		Declare Function ResolveGlyphFontName() As WString Ptr
		Declare Function Ellipsize(ByRef sText As WString, ByVal nMaxWidth As Long) As WString Ptr
		Declare Sub DrawGlyph(ByRef rcCell As Rect, ByRef sGlyph As WString, ByVal clrIcon As ULong)
		Declare Sub Draw()
		'--- Interaction ---
		Declare Sub CancelPress()
		Declare Sub ClearHot()
		Declare Sub FireClick()
		Declare Sub UpdateHotTimer()
	Public:
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Sub Refresh()
		'The codepoints drawn in the icon cells; "" removes the cell (and its
		'gap), which changes the ideal width
		Declare Property GlyphLeft ByRef As WString
		Declare Property GlyphLeft(ByRef Value As WString)
		Declare Property GlyphRight ByRef As WString
		Declare Property GlyphRight(ByRef Value As WString)
		'Font that supplies the icon glyphs (a Fluent Icons face). An empty
		'name falls back to the caption font. Windows resolves a missing glyph
		'font through Segoe MDL2 Assets / Segoe UI Symbol.
		Declare Property GlyphFontName ByRef As WString
		Declare Property GlyphFontName(ByRef Value As WString)
		Declare Property GlyphFontPoint As Integer
		Declare Property GlyphFontPoint(Value As Integer)
		'Appearance only: draws DefaultBorderColor over whichever mood's border
		'would have been used, and does nothing else
		Declare Property IsDefault As Boolean
		Declare Property IsDefault(Value As Boolean)
		'Host command id, reported by OnClick
		Declare Property ID As Long
		Declare Property ID(Value As Long)
		Declare Property TextAlign As ButtonAligns
		Declare Property TextAlign(Value As ButtonAligns)
		'Opt-in: the control sizes ITSELF to the ideal size whenever something
		'that changes it changes. Default False: the host measures and sizes.
		Declare Property AutoSize As Boolean
		Declare Property AutoSize(Value As Boolean)
		Declare Property PadLeft As Long
		Declare Property PadLeft(Value As Long)
		Declare Property PadTop As Long
		Declare Property PadTop(Value As Long)
		Declare Property PadRight As Long
		Declare Property PadRight(Value As Long)
		Declare Property PadBottom As Long
		Declare Property PadBottom(Value As Long)
		Declare Property IconGap As Long
		Declare Property IconGap(Value As Long)
		Declare Property IconWidth As Long
		Declare Property IconWidth(Value As Long)
		Declare Property IconHeight As Long
		Declare Property IconHeight(Value As Long)
	'Corner RADIUS (logical pixels) of the chrome; -1 follows the framework
	'default (Application.DefaultCornerRadius), 0 = square corners
	Declare Property CornerCurvature As Long
	Declare Property CornerCurvature(Value As Long)
		Declare Property BorderThickness As Long
		Declare Property BorderThickness(Value As Long)
		Declare Property FocusGap As Long
		Declare Property FocusGap(Value As Long)
		Declare Property FocusThickness As Long
		Declare Property FocusThickness(Value As Long)
		Declare Property BackColorHot As ULong
		Declare Property BackColorHot(Value As ULong)
		Declare Property BackColorPressed As ULong
		Declare Property BackColorPressed(Value As ULong)
		Declare Property BackColorDisabled As ULong
		Declare Property BackColorDisabled(Value As ULong)
		Declare Property ForeColor As ULong
		Declare Property ForeColor(Value As ULong)
		Declare Property ForeColorHot As ULong
		Declare Property ForeColorHot(Value As ULong)
		Declare Property ForeColorPressed As ULong
		Declare Property ForeColorPressed(Value As ULong)
		Declare Property ForeColorDisabled As ULong
		Declare Property ForeColorDisabled(Value As ULong)
		Declare Property BorderColor As ULong
		Declare Property BorderColor(Value As ULong)
		Declare Property BorderColorHot As ULong
		Declare Property BorderColorHot(Value As ULong)
		Declare Property BorderColorPressed As ULong
		Declare Property BorderColorPressed(Value As ULong)
		Declare Property BorderColorDisabled As ULong
		Declare Property BorderColorDisabled(Value As ULong)
		Declare Property IconColor As ULong
		Declare Property IconColor(Value As ULong)
		Declare Property IconColorHot As ULong
		Declare Property IconColorHot(Value As ULong)
		Declare Property IconColorPressed As ULong
		Declare Property IconColorPressed(Value As ULong)
		Declare Property IconColorDisabled As ULong
		Declare Property IconColorDisabled(Value As ULong)
		Declare Property FocusRingColor As ULong
		Declare Property FocusRingColor(Value As ULong)
		Declare Property DefaultBorderColor As ULong
		Declare Property DefaultBorderColor(Value As ULong)
		'The measured size: valid BEFORE the control has ever been sized, which
		'is the whole point - a host calls it to decide how big to make us
		Declare Sub GetIdealSize(ByRef nWidth As Long, ByRef nHeight As Long)
		Declare Function GetRect(ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		Declare Function GetTextRect(ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		Declare Function GetIconLeftRect(ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		Declare Function GetIconRightRect(ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		Declare Function GetVisualRect(ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		Declare Function GetWindowsDPI() As Double
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		'An ACTION, not a setter: FIRES OnClick (refused while disabled), the
		'door a host's accelerator uses. It reports an action, it does not
		'animate a press flash.
		Declare Sub Click()
		'The button was clicked: a matched press+release with the cursor still
		'inside, or Space/Enter while focused, or the programmatic Click.
		'Nothing fires for a cancelled gesture (press, slide off, release).
		OnClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Button)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "Button.bas"
#endif
