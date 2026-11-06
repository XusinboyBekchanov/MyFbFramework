'################################################################################
'#  Progress.bi                                                                 #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Liu XiaLin                                                         #
'#  Based on:                                                                   #
'#   PsProgressBar (Paul Squires, PlanetSquires Software, MPL 2.0)              #
'#   https://github.com/PaulSquires/PsControls                                  #
'#  A fully owner-drawn progress bar rendered through the control Canvas        #
'#  (GDI+ on Windows, cairo on GTK, mcairo on WASM/Android): track with         #
'#  stadium/rounded corners, solid or gradient fill, optional segmented         #
'#  blocks, determinate position or a bouncing/wrapping marquee chunk, and      #
'#  normal / paused / error / disabled colour states.                           #
'################################################################################

#include once "Control.bi"
#include once "TimerComponent.bi"

Namespace My.Sys.Forms
	#define QProgress(__Ptr__) (*Cast(Progress Ptr, __Ptr__))

	'COLORREF layout on every platform: R in bits 0..7 (Canvas.TextOut, the
	'FillPath* family on cairo and GetRed/GetGreen/GetBlue all decode this)
	#ifndef PRGB
		#define PRGB(r, g, b) (Cast(ULong, (r) Or ((g) Shl 8) Or ((b) Shl 16)))
	#endif

	Private Type ProgressRect
		Left As Long
		Top As Long
		Right As Long
		Bottom As Long
	End Type

	Private Enum ProgressModes
		pmDeterminate
		pmIndeterminate
	End Enum

	Private Enum ProgressStates
		psNormal
		psPaused
		psError
	End Enum

	Private Enum ProgressFillStyles
		pfSolid
		pfGradient
	End Enum

	Private Enum ProgressTextModes
		ptNone
		ptPercent
		ptValue
		ptCustom
	End Enum

	'How the indeterminate chunk moves: ping-pong off the ends, or slide
	'through like the classic marquee
	Private Enum ProgressMarqueeStyles
		msBounce
		msWrap
	End Enum

	Private Enum ProgressOrientations
		poHorizontal
		poVertical
	End Enum

	'What geometry the progress draws as: the classic bar, a LARGE ring (thick
	'stroke, room for the centred text in the hole) or a SMALL ring (thin
	'stroke, spinner scale). A ring ignores Orientation/Segmented/Curvature;
	'its stroke width is Thickness when set, else one per shape.
	Private Enum ProgressShapes
		pshBar
		pshRingLarge
		pshRingSmall
	End Enum

	Private Const PROGRESS_DEFAULT_MARQUEE_MS As Long = 30
	Private Const PROGRESS_DEFAULT_MARQUEE_STEP As Long = 2
	Private Const PROGRESS_DEFAULT_CHUNK_PERCENT As Long = 25
	Private Const PROGRESS_DEFAULT_BLOCK_LEN As Long = 10
	Private Const PROGRESS_DEFAULT_BLOCK_GAP As Long = 3
	'Curvature sentinels: -2 = stadium (both ends exact semicircles), the
	'shipped look; -1 = follow the framework default (g_DefaultCornerRadius);
	'>= 0 = this control's own corner RADIUS (logical pixels)
	Private Const PROGRESS_CURVATURE_STADIUM As Long = -2
	Private Const PROGRESS_CURVATURE_FOLLOW As Long = -1

	'`Progress` is an owner-drawn progress bar Control within the MyFbFramework,
	'part of the freeBasic framework (Windows, Linux, WASM, Android).
	Private Type Progress Extends Control
	Private:
		'--- Model. Setters clamp, never wrap. ---
		Dim m_Min As Long = 0
		Dim m_Max As Long = 100
		Dim m_Position As Long = 0
		Dim m_StepValue As Long = 10
		'--- State ---
		Dim m_Mode As ProgressModes = pmDeterminate
		Dim m_State As ProgressStates = psNormal
		Dim m_FillStyle As ProgressFillStyles = pfSolid
		Dim m_TextMode As ProgressTextModes = ptNone
		Dim m_MarqueeStyle As ProgressMarqueeStyles = msBounce
		Dim m_Orientation As ProgressOrientations = poHorizontal
		Dim m_Shape As ProgressShapes = pshBar
		Dim m_Reverse As Boolean = False
		Dim m_Segmented As Boolean = False
		'--- Marquee (indeterminate mode only) ---
		Dim m_MarqueeInterval As Long = PROGRESS_DEFAULT_MARQUEE_MS
		Dim m_MarqueeStep As Long = PROGRESS_DEFAULT_MARQUEE_STEP
		Dim m_ChunkPercent As Long = PROGRESS_DEFAULT_CHUNK_PERCENT
		Dim m_Tick As Long = 0
		'--- Layout (device pixels, derived in LayoutProgress) ---
		Dim m_Thickness As Long = 0          '0 = fill the client's cross axis
		Dim m_BarInset As Long = 0
		Dim m_BlockLength As Long = PROGRESS_DEFAULT_BLOCK_LEN
		Dim m_BlockGap As Long = PROGRESS_DEFAULT_BLOCK_GAP
		Dim m_BorderThickness As Long = 0    '0 = no track border
		Dim m_Curvature As Long = PROGRESS_CURVATURE_STADIUM
		Dim rcTrack As ProgressRect
		Dim rcFill As ProgressRect
		Dim rcBar As ProgressRect
		Dim bLayoutDirty As Boolean = True
		'--- Colors (COLORREF layout on every platform) ---
		Dim m_TrackColor As ULong = PRGB(51, 55, 63)
		Dim m_TrackBorderColor As ULong = PRGB(72, 77, 86)
		Dim m_BarColor As ULong = PRGB(86, 156, 214)
		Dim m_BarColorEnd As ULong = PRGB(52, 110, 170)
		Dim m_BarColorPaused As ULong = PRGB(222, 184, 70)
		Dim m_BarColorPausedEnd As ULong = PRGB(178, 140, 34)
		Dim m_BarColorError As ULong = PRGB(224, 96, 96)
		Dim m_BarColorErrorEnd As ULong = PRGB(176, 56, 56)
		Dim m_BarColorDisabled As ULong = PRGB(84, 89, 97)
		Dim m_BarColorDisabledEnd As ULong = PRGB(62, 67, 75)
		Dim m_TextColor As ULong = PRGB(190, 196, 206)
		Dim m_TextColorOnBar As ULong = PRGB(255, 255, 255)
		Dim m_TextColorDisabled As ULong = PRGB(90, 96, 106)

		Dim tmrMarquee As TimerComponent

		Dim nScale As Single = 0

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
		Declare Static Sub tmrMarquee_Timer_(ByRef Designer As My.Sys.Object, ByRef Sender As TimerComponent)
		Declare Sub tmrMarquee_Timer(ByRef Sender As TimerComponent)
		'--- Geometry ---
		Declare Sub LayoutProgress()
		Declare Function ResolvedCurvature() As Long
		Declare Function FillLength() As Long
		Declare Function BarLength() As Long
		Declare Function BlockRectAt(ByVal idx As Long, ByRef rc As ProgressRect) As Boolean
	'--- Painting helpers ---
	Declare Function Percent() As Long
	Declare Function Fraction() As Single
	Declare Function ResolveBarColors(ByRef clr2 As ULong) As ULong
	Declare Function DisplayText() As UString
	Declare Function ARGB(clr As ULong, Opacity As Long = 100) As ULong
	Declare Sub Draw()
	Declare Sub DrawRing()
		'--- Pure marquee/fill laws (no window, no state) ---
		Declare Static Function ComputeBarLength(ByVal nPos As Long, ByVal nMin As Long, ByVal nMax As Long, ByVal nTrackLen As Long) As Long
		Declare Static Function ComputeMarqueeOffset(ByVal nTrackLen As Long, ByVal nChunkLen As Long, ByVal nStep As Long, ByVal nTick As Long, ByVal nStyle As Long) As Long
		Declare Static Function ComputeBlockCount(ByVal nLength As Long, ByVal nBlockLen As Long, ByVal nBlockGap As Long) As Long
		Declare Sub UpdateMarqueeTimer()
	Public:
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Sub Refresh()
		Declare Sub SetRange(AMin As Long, AMax As Long)
		Declare Function StepIt() As Long
		Declare Function StepBy(Delta As Long) As Long
		Declare Property MinValue As Long
		Declare Property MinValue(Value As Long)
		Declare Property MaxValue As Long
		Declare Property MaxValue(Value As Long)
		Declare Property Position As Long
		Declare Property Position(Value As Long)
		Declare Property StepValue As Long
		Declare Property StepValue(Value As Long)
		Declare Property PercentValue As Long
		Declare Property Mode As ProgressModes
		Declare Property Mode(Value As ProgressModes)
		Declare Property State As ProgressStates
		Declare Property State(Value As ProgressStates)
		Declare Property FillStyle As ProgressFillStyles
		Declare Property FillStyle(Value As ProgressFillStyles)
		Declare Property TextMode As ProgressTextModes
		Declare Property TextMode(Value As ProgressTextModes)
		Declare Property MarqueeStyle As ProgressMarqueeStyles
		Declare Property MarqueeStyle(Value As ProgressMarqueeStyles)
		Declare Property Orientation As ProgressOrientations
		Declare Property Orientation(Value As ProgressOrientations)
		Declare Property Shape As ProgressShapes
		Declare Property Shape(Value As ProgressShapes)
		Declare Property Segmented As Boolean
		Declare Property Segmented(Value As Boolean)
		Declare Property Reverse As Boolean
		Declare Property Reverse(Value As Boolean)
		Declare Property Thickness As Long
		Declare Property Thickness(Value As Long)
		Declare Property BarInset As Long
		Declare Property BarInset(Value As Long)
		Declare Property BlockLength As Long
		Declare Property BlockLength(Value As Long)
		Declare Property BlockGap As Long
		Declare Property BlockGap(Value As Long)
		Declare Property BorderThickness As Long
		Declare Property BorderThickness(Value As Long)
		Declare Property Curvature As Long
		Declare Property Curvature(Value As Long)
		Declare Property ChunkPercent As Long
		Declare Property ChunkPercent(Value As Long)
		Declare Property MarqueeInterval As Long
		Declare Property MarqueeInterval(Value As Long)
		Declare Property MarqueeStep As Long
		Declare Property MarqueeStep(Value As Long)
		Declare Property TrackColor As ULong
		Declare Property TrackColor(Value As ULong)
		Declare Property TrackBorderColor As ULong
		Declare Property TrackBorderColor(Value As ULong)
		Declare Property BarColor As ULong
		Declare Property BarColor(Value As ULong)
		Declare Property BarColorEnd As ULong
		Declare Property BarColorEnd(Value As ULong)
		Declare Property PausedColor As ULong
		Declare Property PausedColor(Value As ULong)
		Declare Property PausedColorEnd As ULong
		Declare Property PausedColorEnd(Value As ULong)
		Declare Property ErrorColor As ULong
		Declare Property ErrorColor(Value As ULong)
		Declare Property ErrorColorEnd As ULong
		Declare Property ErrorColorEnd(Value As ULong)
		Declare Property DisabledColor As ULong
		Declare Property DisabledColor(Value As ULong)
		Declare Property DisabledColorEnd As ULong
		Declare Property DisabledColorEnd(Value As ULong)
		Declare Property TextColor As ULong
		Declare Property TextColor(Value As ULong)
		Declare Property TextColorOnBar As ULong
		Declare Property TextColorOnBar(Value As ULong)
		Declare Property TextColorDisabled As ULong
		Declare Property TextColorDisabled(Value As ULong)
		Declare Function GetWindowsDPI() As Double
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "Progress.bas"
#endif
