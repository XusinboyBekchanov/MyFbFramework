'################################################################################
'#  NumericUpDownEx.bi                                                          #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Liu XiaLin                                                         #
'#  Based on:                                                                   #
'#   PsNumericUpDown (Paul Squires, PlanetSquires Software, MPL 2.0)            #
'#   https://github.com/PsControls                                              #
'#  A fully owner-drawn numeric up/down: a rounded frame holding a "-" button,  #
'#  an editable numeric field and a "+" button, separated by hairline           #
'#  dividers. The value field is an embedded TextBoxEx in numeric mode (its     #
'#  own child does the editing on every platform), exactly the role the         #
'#  PsTextBox plays in the Ps source; the frame, cells, dividers and the -/+    #
'#  glyph bars are drawn through this control's Canvas. The value has a range,  #
'#  a decimal grid and an increment; buttons auto-repeat while held and grey    #
'#  out at a limit; typing commits on ENTER or on focus loss. The native        #
'#  NumericUpDown wrapper keeps its name, so the Ex suffix marks this one.      #
'################################################################################

#include once "Control.bi"
#include once "TextBoxEx.bi"
#include once "TimerComponent.bi"

Namespace My.Sys.Forms
	#define QNumericUpDownEx(__Ptr__) (*Cast(NumericUpDownEx Ptr, __Ptr__))

	'COLORREF layout on every platform: R in bits 0..7 (shared with Progress.bi)
	#ifndef PRGB
		#define PRGB(r, g, b) (Cast(ULong, (r) Or ((g) Shl 8) Or ((b) Shl 16)))
	#endif

	Private Type NumericUpDownExRect
		Left As Long
		Top As Long
		Right As Long
		Bottom As Long
	End Type

	'The hit-testable parts, plus "nothing". The value cell is reported for
	'completeness, but the container never acts on it - that area belongs to
	'the embedded TextBoxEx, which receives its own mouse messages.
	Private Enum NumericUpDownExParts
		nxNone
		nxMinus
		nxValue
		nxPlus
	End Enum

	'Hot-tracking safety net; WM_MOUSELEAVE is not reliable on fast exits
	Private Const NUDX_HOTTRACK_MS As Long = 100

	'Defaults. The SIZE values are logical pixels (device values scale by
	'nScale). The BORDER and DIVIDER thicknesses are NOT DPI-scaled - a rule
	'that thickens with the display stops reading as a rule - while the GLYPH
	'thickness IS, because the bars of "-" and "+" are the strokes of an ICON,
	'and an icon whose length scales while its weight does not gets thinner
	'and thinner relative to itself.
	Private Const NUDX_DEFAULT_BUTTONW As Long = 28
	Private Const NUDX_DEFAULT_VALUEPAD As Long = 6
	Private Const NUDX_DEFAULT_VERTPAD As Long = 5
	Private Const NUDX_DEFAULT_CORNERRADIUS As Long = 6
	Private Const NUDX_DEFAULT_BORDERTHICK As Long = 1
	Private Const NUDX_DEFAULT_DIVIDERTHICK As Long = 1
	Private Const NUDX_DEFAULT_GLYPHLENGTH As Long = 10
	Private Const NUDX_DEFAULT_GLYPHTHICK As Long = 1
	'Auto-repeat: hold a button and it keeps stepping. Either at 0 disables
	'repeating entirely (one click = one step).
	Private Const NUDX_DEFAULT_REPEATDELAY As Long = 400
	Private Const NUDX_DEFAULT_REPEATINTERVAL As Long = 60
	'Value defaults. The range is deliberately wide: a host that never touches
	'Range gets a control that does not silently clamp, but the machinery is
	'always present so the buttons can grey out at a limit.
	Private Const NUDX_DEFAULT_MIN As Double = -1000000.0
	Private Const NUDX_DEFAULT_MAX As Double = 1000000.0
	Private Const NUDX_DEFAULT_INCREMENT As Double = 1.0

	'`NumericUpDownEx` is an owner-drawn spinner Control within the MyFbFramework,
	'part of the freeBasic framework (Windows, Linux, WASM, Android).
	Private Type NumericUpDownEx Extends Control
	Private:
		'--- The embedded value editor (numeric mode, borderless). MFF controls
		'    parent to controls the way the Ps source embeds a PsTextBox. ---
		Dim FEdit As TextBoxEx Ptr = 0
		'--- State ---
		Dim isFocused As Boolean = False   'the value field owns the keyboard focus
		Dim m_ReadOnly As Boolean = False
		Dim hotPart As Long = nxNone       'NUDX part under the cursor
		Dim pressedPart As Long = nxNone   'which button is held (capture held)
		Dim bRepeatFast As Boolean = False 'the repeat timer switched to its fast cadence
		Dim isRepeating As Boolean = False
		'--- Value. THE EDITOR'S TEXT IS THE SOURCE OF TRUTH; m_Value is the
		'    last value the control committed, kept so a change is reported once. ---
		Dim m_Value As Double = 0.0
		Dim m_Min As Double = NUDX_DEFAULT_MIN
		Dim m_Max As Double = NUDX_DEFAULT_MAX
		Dim m_Increment As Double = NUDX_DEFAULT_INCREMENT
		Dim m_LargeIncrement As Double = NUDX_DEFAULT_INCREMENT * 10.0
		Dim m_DecimalPlaces As Long = 0
		Dim m_RepeatDelayMs As Long = NUDX_DEFAULT_REPEATDELAY
		Dim m_RepeatIntervalMs As Long = NUDX_DEFAULT_REPEATINTERVAL
		'Sub-notch wheel accumulation, the scrollbar siblings' rule
		Dim m_WheelAccum As Long = 0
		'--- Colors (COLORREF layout on every platform). The control reads as ONE
		'    FLAT CELL until a button is hovered, because ButtonBackColor defaults
		'    EQUAL to ValueBackColor - the dividers are the only thing separating
		'    the three parts at rest. The value cell's two colours are pushed into
		'    the embedded editor rather than painted here. ---
		Dim m_BorderColor As ULong = PRGB(60, 66, 77)
		Dim m_FocusBorderColor As ULong = PRGB(86, 156, 214)
		Dim m_BorderColorDisabled As ULong = PRGB(48, 52, 60)
		Dim m_DividerColor As ULong = PRGB(60, 66, 77)
		Dim m_DividerColorDisabled As ULong = PRGB(48, 52, 60)
		Dim m_ValueBackColor As ULong = PRGB(44, 49, 58)
		Dim m_ValueForeColor As ULong = PRGB(215, 218, 224)
		Dim m_ValueBackColorDisabled As ULong = PRGB(38, 42, 49)
		Dim m_ValueForeColorDisabled As ULong = PRGB(90, 96, 106)
		Dim m_ButtonBackColor As ULong = PRGB(44, 49, 58)
		Dim m_ButtonBackColorHot As ULong = PRGB(56, 62, 73)
		Dim m_ButtonBackColorPressed As ULong = PRGB(38, 79, 120)
		Dim m_ButtonBackColorDisabled As ULong = PRGB(38, 42, 49)
		Dim m_GlyphColor As ULong = PRGB(190, 196, 206)
		Dim m_GlyphColorHot As ULong = PRGB(255, 255, 255)
		Dim m_GlyphColorPressed As ULong = PRGB(255, 255, 255)
		Dim m_GlyphColorDisabled As ULong = PRGB(90, 96, 106)
		'Any explicit colour Set* marks the palette customized and stops the
		'auto theme resolution in Draw (the family's ListTreeEx rule)
		bColorsCustomized As Boolean = False
		'--- Layout. Every rect derived in LayoutControl; NO DC is taken - the
		'    value text is measured by the editor, not by us. ---
		Dim m_ButtonWidth As Long = NUDX_DEFAULT_BUTTONW
		Dim m_ValuePadLeft As Long = NUDX_DEFAULT_VALUEPAD
		Dim m_ValuePadRight As Long = NUDX_DEFAULT_VALUEPAD
		Dim m_VertPadding As Long = NUDX_DEFAULT_VERTPAD
		Dim m_CornerRadius As Long = NUDX_DEFAULT_CORNERRADIUS
		Dim m_BorderThick As Long = NUDX_DEFAULT_BORDERTHICK
		Dim m_DividerThick As Long = NUDX_DEFAULT_DIVIDERTHICK
		Dim m_GlyphLength As Long = NUDX_DEFAULT_GLYPHLENGTH
		Dim m_GlyphThick As Long = NUDX_DEFAULT_GLYPHTHICK
		Dim rcFrame As NumericUpDownExRect
		Dim rcMinus As NumericUpDownExRect
		Dim rcDiv1 As NumericUpDownExRect
		Dim rcValue As NumericUpDownExRect
		Dim rcDiv2 As NumericUpDownExRect
		Dim rcPlus As NumericUpDownExRect
		Dim rcMinusBar As NumericUpDownExRect
		Dim rcPlusBarH As NumericUpDownExRect
		Dim rcPlusBarV As NumericUpDownExRect
		Dim bLayoutDirty As Boolean = True

		Dim nScale As Single = 0
		Dim tmrHotTrack As TimerComponent
		Dim tmrRepeat As TimerComponent

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
		Declare Static Sub tmrRepeat_Timer_(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent)
		Declare Sub tmrRepeat_Timer(ByRef Sender As TimerComponent)
		'--- Embedded editor callbacks ---
		Declare Sub CreateEdit()
		Declare Static Sub FEdit_Enter_(ByRef Designer As My.Sys.Object, ByRef Sender As TextBoxEx)
		Declare Sub FEdit_Enter(ByRef Sender As TextBoxEx)
		Declare Static Sub FEdit_Focus_(ByRef Designer As My.Sys.Object, ByRef Sender As TextBoxEx, ByVal bGotFocus As Boolean)
		Declare Sub FEdit_Focus(ByRef Sender As TextBoxEx, ByVal bGotFocus As Boolean)
		Declare Static Sub FEdit_Wheel_(ByRef Designer As My.Sys.Object, ByRef Sender As TextBoxEx, ByVal nDelta As Long)
		Declare Sub FEdit_Wheel(ByRef Sender As TextBoxEx, ByVal nDelta As Long)
		Declare Static Sub FEdit_KeyDown_(ByRef Designer As My.Sys.Object, ByRef Sender As TextBoxEx, ByVal vKey As Long)
		Declare Sub FEdit_KeyDown(ByRef Sender As TextBoxEx, ByVal vKey As Long)
		'--- Value laws (pure) ---
		Declare Function SnapToPlaces(ByVal nValue As Double) As Double
		Declare Function ClampToRange(ByVal nValue As Double) As Double
		Declare Function FormatValue(ByVal nValue As Double) As WString Ptr
		'--- Layout & painting ---
		Declare Sub LayoutControl()
		Declare Sub PlaceEdit()
		Declare Function HitPart(ByVal x As Long, ByVal y As Long) As Long
	Declare Function ARGB(clr As ULong, Opacity As Long = 100) As ULong
	'Resolves the palette per theme at paint time unless a colour was Set
	Declare Sub ApplyThemeColors()
	Declare Sub Draw()
		'--- Interaction & value plumbing ---
		Declare Sub UpdateDisplay()
		Declare Sub CommitTyped()
		Declare Sub StepByUser(ByVal nDir As Long, ByVal bLarge As Boolean)
		Declare Sub StepSilent(ByVal nDir As Long, ByVal bLarge As Boolean)
		Declare Function AtMin() As Boolean
		Declare Function AtMax() As Boolean
		Declare Sub StartRepeat()
		Declare Sub StopRepeat()
		Declare Sub CancelPress()
		Declare Sub ClearHot()
		Declare Sub SyncEnabledToEdit()
	Public:
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Sub Refresh()
		'SetValue clamps to the range and snaps to the decimal grid, so what you
		'set is what GetValue returns, and it is what is displayed. SILENT.
		Declare Property Value As Double
		Declare Property Value(nValue As Double)
		'SetRange re-clamps the current value (silently) and swaps an inverted pair
		Declare Property MinValue As Double
		Declare Property MinValue(nValue As Double)
		Declare Property MaxValue As Double
		Declare Property MaxValue(nValue As Double)
		Declare Property Increment As Double
		Declare Property Increment(nValue As Double)
		Declare Property LargeIncrement As Double
		Declare Property LargeIncrement(nValue As Double)
		'SetDecimalPlaces re-formats the displayed value; 0 means integers only
		Declare Property DecimalPlaces As Long
		Declare Property DecimalPlaces(nPlaces As Long)
		'Stops TYPING only: the buttons, the arrow keys and the wheel still work
		Declare Property EditReadOnly As Boolean
		Declare Property EditReadOnly(Value As Boolean)
		'Auto-repeat: milliseconds; either <= 0 disables repeating
		Declare Property RepeatDelay As Long
		Declare Property RepeatDelay(Value As Long)
		Declare Property RepeatInterval As Long
		Declare Property RepeatInterval(Value As Long)
		Declare Property ButtonWidth As Long
		Declare Property ButtonWidth(Value As Long)
		Declare Property CornerRadius As Long
		Declare Property CornerRadius(Value As Long)
		Declare Property BorderThickness As Long
		Declare Property BorderThickness(Value As Long)
		Declare Property DividerThickness As Long
		Declare Property DividerThickness(Value As Long)
		Declare Property GlyphLength As Long
		Declare Property GlyphLength(Value As Long)
		Declare Property GlyphThickness As Long
		Declare Property GlyphThickness(Value As Long)
		Declare Property BorderColor As ULong
		Declare Property BorderColor(Value As ULong)
		Declare Property FocusBorderColor As ULong
		Declare Property FocusBorderColor(Value As ULong)
		Declare Property BorderColorDisabled As ULong
		Declare Property BorderColorDisabled(Value As ULong)
		Declare Property DividerColor As ULong
		Declare Property DividerColor(Value As ULong)
		Declare Property DividerColorDisabled As ULong
		Declare Property DividerColorDisabled(Value As ULong)
		Declare Property ValueBackColor As ULong
		Declare Property ValueBackColor(Value As ULong)
		Declare Property ValueForeColor As ULong
		Declare Property ValueForeColor(Value As ULong)
		Declare Property ValueBackColorDisabled As ULong
		Declare Property ValueBackColorDisabled(Value As ULong)
		Declare Property ValueForeColorDisabled As ULong
		Declare Property ValueForeColorDisabled(Value As ULong)
		Declare Property ButtonBackColor As ULong
		Declare Property ButtonBackColor(Value As ULong)
		Declare Property ButtonBackColorHot As ULong
		Declare Property ButtonBackColorHot(Value As ULong)
		Declare Property ButtonBackColorPressed As ULong
		Declare Property ButtonBackColorPressed(Value As ULong)
		Declare Property ButtonBackColorDisabled As ULong
		Declare Property ButtonBackColorDisabled(Value As ULong)
		Declare Property GlyphColor As ULong
		Declare Property GlyphColor(Value As ULong)
		Declare Property GlyphColorHot As ULong
		Declare Property GlyphColorHot(Value As ULong)
		Declare Property GlyphColorPressed As ULong
		Declare Property GlyphColorPressed(Value As ULong)
		Declare Property GlyphColorDisabled As ULong
		Declare Property GlyphColorDisabled(Value As ULong)
		'Does the value field own the keyboard focus? Focus sits on the editor's
		'own child two levels down, so GetFocus() = Handle is ALWAYS false
		Declare Function HasFocus() As Boolean
		'What the value cell shows right now (the editor's buffer)
		Declare Property DisplayText ByRef As WString
		'The editing child's own edit handle (the RichEdit on Windows), for
		'edit-specific messages the flat API does not cover. 0 where no child.
		#ifdef __USE_WINAPI__
			Declare Property ChildEditHandle As Any Ptr
		#endif
		'The programmatic door to exactly what the buttons do - and, being
		'programmatic, they do NOT notify
		Declare Sub StepUp()
		Declare Sub StepDown()
		'Same as the Value property setter, the Ps-family name
		Declare Sub SetValue(ByVal nValue As Double)
		'Measures the WIDEST value the range can produce at the current decimal
		'places, plus padding, both buttons, both dividers and the border - valid
		'BEFORE the control has ever been sized
		Declare Sub GetIdealSize(ByRef nWidth As Long, ByRef nHeight As Long)
		Declare Function GetFrameRect(ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		Declare Function GetMinusRect(ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		Declare Function GetValueRect(ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		Declare Function GetPlusRect(ByRef rcLeft As Long, ByRef rcTop As Long, ByRef rcRight As Long, ByRef rcBottom As Long) As Boolean
		'Which part is at (x, y) in CLIENT coordinates? Public so a host can
		'special-case a region, and so tests can assert layout agreement
		Declare Function HitTest(ByVal x As Long, ByVal y As Long) As Long
		Declare Function GetWindowsDPI() As Double
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		'The value changed through USER interaction: a button click, an auto-repeat
		'tick, an arrow key or the wheel - all complete values - and a TYPED value
		'fires on COMMIT only (ENTER, or focus leaving the field). The programmatic
		'setters (Value, Range, StepUp, StepDown) are all SILENT.
		OnValueChanged As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As NumericUpDownEx, ByVal nValue As Double)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "NumericUpDownEx.bas"
#endif
