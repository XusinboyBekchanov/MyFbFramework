'###############################################################################
'#  Ruler.bi                                                                   #
'#  This file is part of MyFBFramework                                        #
'#  Authors: Xusinboy Bekchanov                                               #
'#                                                                             #
'#  A thin, dockable ruler strip (horizontal or vertical) in the style of     #
'#  Xojo's Layout/Report Editor rulers or Microsoft Word's rulers. Meant to   #
'#  sit along the top and/or left edge of any design surface - the Report     #
'#  designer in particular can call AddMarker once per ReportBand.Top so the  #
'#  vertical ruler shows every section boundary, and MousePosition from the   #
'#  surface's OnMouseMove to get the live moving tracker line.                #
'###############################################################################

#include once "Panel.bi"

Namespace My.Sys.Forms
	#define QRuler(__Ptr__) (*Cast(Ruler Ptr, __Ptr__))

	Const RULER_MAX_MARKERS As Integer = 64

	'Which edge of the design surface a Ruler is docked to.
	Private Enum RulerOrientation
		ruHorizontal 'Runs left-to-right; dock it along the top of the surface
		ruVertical   'Runs top-to-bottom; dock it along the left of the surface
	End Enum

	'The measurement major ticks (and their printed numbers) are spaced by.
	Private Enum RulerUnits
		ruPixels       'A "unit" is 50px, purely for even major-tick spacing
		ruInches
		ruCentimeters
	End Enum

	'`Ruler` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`Ruler` - A Word/Xojo-style measuring ruler (Windows, Linux). Dock a horizontal one above,
	'and/or a vertical one beside, a design or report surface; keep ZeroOffset equal to the
	'surface's scroll position so the ticks stay aligned with what is drawn under them.
	'
	'Ruler draws itself independently of the inherited public OnPaint event - it never assigns
	'OnPaint internally, so a user (or the property grid) is free to hook OnPaint on a Ruler
	'instance for their own overlay without silently disabling the tick/marker/tracker drawing.
	'The ruler's own drawing happens in ProcessMessage (Win32: right after WM_PAINT is handled
	'by the base Panel, via its own GetDC pass; GTK: a separate "draw" signal connected after
	'the base one) and reacts to SetDark for light/dark palettes, same as any other control.
	Private Type Ruler Extends Control
	Private:
		FOrientation As RulerOrientation
		FUnits       As RulerUnits
		FDPI         As Integer
		FZeroOffset  As Integer
		FMousePos    As Integer
		FMarkers(RULER_MAX_MARKERS - 1) As Integer
		FMarkerCount As Integer
		Declare Sub DrawRuler(ByRef Canvas As My.Sys.Drawing.Canvas)
		#ifdef __USE_GTK__
			Declare Function GtkDrawAfter(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As gpointer) As Boolean
			Declare Static Sub HandleAllocated(ByRef Sender As Control)
		#endif
		#ifdef __USE_WINAPI__
			Declare Virtual Sub SetDark(Value As Boolean)
		#endif
	Protected:
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		Declare Property Orientation As RulerOrientation
		'Horizontal (top-docked) or vertical (left-docked); switching it also flips the ruler's
		'own thickness (Height for horizontal, Width for vertical) to the standard 24px
		Declare Property Orientation(Value As RulerOrientation)
		Declare Property Units As RulerUnits
		'Pixels/Inches/Centimeters - which unit the major ticks and numbers are measured in
		Declare Property Units(Value As RulerUnits)
		Declare Property DPI As Integer
		'Pixels-per-inch used to convert Inches/Centimeters to screen pixels (default 96)
		Declare Property DPI(Value As Integer)
		Declare Property ZeroOffset As Integer
		'Shifts the ruler's zero point - set this to minus the design surface's scroll position
		'(0 if it doesn't scroll) so ruler ticks track whatever is drawn on the surface
		Declare Property ZeroOffset(Value As Integer)
		Declare Property MousePosition As Integer
		'Surface-relative X (horizontal ruler) or Y (vertical ruler) of the mouse; feed this from
		'the design surface's MouseMove for the live tracker line Word/Xojo show. -1 hides it
		Declare Property MousePosition(Value As Integer)
		'Removes every marker added via AddMarker (call before re-adding a form's current bands)
		Declare Sub ClearMarkers()
		'Adds a section-boundary tick (and accent line) at Position pixels from the ruler's zero
		'point - call once per ReportBand.Top/ReportBand.Top+Height so a vertical Ruler mirrors
		'the report's band layout, the way Xojo's Report Editor ruler highlights each section
		Declare Sub AddMarker(Position As Integer)
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "Ruler.bas"
#endif
