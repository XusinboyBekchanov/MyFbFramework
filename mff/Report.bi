'###############################################################################
'#  Report.bi                                                                  #
'#  This file is part of MyFBFramework                                        #
'#  Authors: Xusinboy Bekchanov                                               #
'#                                                                             #
'#  A Crystal-Reports/Xojo-Report-Editor-style, band based, WYSIWYG print      #
'#  report designer - drop ONE Report control onto a Form. Bands (Report      #
'#  Header/Footer, Page Header/Footer, Group Header/Footer, Detail) are NOT   #
'#  separate controls you drop one by one any more; they are plain data that  #
'#  Report itself owns and lists down a strip on the left (PageHeader, Body,  #
'#  PageFooter, ...), Xojo/Crystal-Reports "section list" style. Drop         #
'#  ReportField/ReportLabel/ReportImage/ReportLine/ReportShape controls straight    #
'#  onto the currently active band's area, to the right of that strip.        #
'#  ReportDocument paginates and prints/PDF-exports the result at run time.    #
'#  See Report.bas for an overview of the design.                             #
'###############################################################################

#include once "Form.bi"
#include once "Panel.bi"
#include once "Label.bi"
#include once "ImageBox.bi"
#include once "PrintDocument.bi"
#include once "PrintPreviewDialog.bi"
#include once "List.bi"

Namespace My.Sys.Forms
	Using My.Sys.ComponentModel

	#define QReportField(__Ptr__) (*Cast(ReportField Ptr, __Ptr__))
	#define QReportLabel(__Ptr__) (*Cast(ReportLabel Ptr, __Ptr__))
	#define QReportImage(__Ptr__) (*Cast(ReportImage Ptr, __Ptr__))
	#define QReportLine(__Ptr__)  (*Cast(ReportLine Ptr, __Ptr__))
	#define QReportShape(__Ptr__) (*Cast(ReportShape Ptr, __Ptr__))
	#define QReport(__Ptr__)      (*Cast(Report Ptr, __Ptr__))
	'Casts a List.Item(i)/List.IndexOf(...) Any Ptr back to a ReportBand Ptr.
	#define QReportBandPtr(__Ptr__) Cast(ReportBand Ptr, __Ptr__)

	'What role a band plays when ReportDocument paginates the report - mirrors Crystal
	'Reports' section types / Xojo's ReportSection kinds. This enum's declaration order IS
	'the canonical print/stacking order (see Report.RestackFrom).
	Private Enum ReportBandType
		rbtReportHeader  'Prints once, at the very start of the report
		rbtPageHeader    'Prints at the top of every page
		rbtGroupHeader   'Prints whenever GroupField's value changes
		rbtDetail        'Prints once per data row - labelled "Body" in the band-list strip
		rbtGroupFooter   'Prints just before GroupField's value changes (and at the end)
		rbtPageFooter    'Prints at the bottom of every page
		rbtReportFooter  'Prints once, at the very end of the report
	End Enum

	'Aggregate function a ReportField with a SummaryField should compute over the
	'rows of its enclosing group (or the whole report, in the ReportFooter).
	Private Enum ReportSummaryType
		rsNone, rsSum, rsAverage, rsCount, rsMin, rsMax
	End Enum

	'Kind of geometric shape a ReportShape draws.
	Private Enum ReportShapeKind
		rshRectangle, rshEllipse
	End Enum

	'A single band's metadata. Deliberately NOT a Control/Panel descendant and never
	'instantiated on its own - Report owns an internal array of these (FBands()) instead of
	'holding a collection of separate band controls, so the component tree / toolbox never
	'shows a "ReportBand" alongside Report. Field controls belonging to a band are located
	'purely by their Top falling inside the band's vertical span (see Report.BandAt) -
	'there is no per-control parent/child relationship to a band, only to the Report itself.
	
	Type PReport As Report Ptr
	
	Private Type ReportBand Extends My.Sys.Object
	Private:
		FParent As Any Ptr 'the owning Report control (Cast internally)
	Public:
		Components As List
		BandType      As ReportBandType
		Height        As Integer
		GroupField    As WString Ptr
		NewPageBefore As Boolean
		NewPageAfter  As Boolean
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'The Report control this band belongs to (Cast to My.Sys.Forms.Report Ptr internally).
		Declare Property Parent As PReport
		Declare Property Parent(Value As PReport)
		Declare Constructor
		Declare Destructor
	End Type

	#define QReportControl(__Ptr__) (*Cast(ReportControl Ptr, __Ptr__))
	'Casts a FComponents.Item(i)/IndexOf(...) Any Ptr back to a ReportControl Ptr.
	#define QReportControlPtr(__Ptr__) Cast(ReportControl Ptr, __Ptr__)

	'Common base for every lightweight item that lives on a Report's design surface
	'(ReportField/ReportImage/ReportLine/ReportShape). Deliberately Extends Component, NOT
	'Control/Panel: none of these are containers, none ever hold child controls of their
	'own, and none of them need (or get) a real OS window most of the time. Report owns and
	'lists them in FComponents (inherited straight from Component - setting
	'SomeField.Parent = @Rep is all it takes to register one, exactly like Component.Parent
	'already does for any Component) and is responsible for both drawing them
	'(Report.DrawReportControlContent, shared by the print engine and the design surface)
	'and hit-testing/selecting/dragging them on the design surface
	'(Report.HandleMouseDown/Move/Up) - there is no native window to paint itself or to
	'route mouse messages through the way a real Control has.
	'Handle (inherited from Component) is only ever created while This.DesignMode is True -
	'i.e. while actively being edited on a design surface - and is destroyed the instant
	'DesignMode goes back to False. A report that is only ever Print()ed/PrintPreview()ed/
	'ExportToPDF()ed (DesignMode never set True) never allocates a single native window for
	'any of its fields.
	Private Type ReportControl Extends Component
	Private:
		FBackColor As Integer
		FVisible   As Boolean
		FParent    As ReportBand Ptr
		'Only meaningful on __USE_WINAPI__ today: a plain, disabled child window with no
		'purpose but to exist while DesignMode is True (e.g. so something is there to anchor
		'a future in-place editor to). Every other backend, and WINAPI itself whenever
		'DesignMode is False, leaves Handle at 0 and relies purely on Report's own
		'Canvas-based drawing/hit-testing - see the module-level comment above.
		Declare Sub CreateHandle
		Declare Sub DestroyHandle
	Public:
		Declare Property BackColor As Integer
		Declare Property BackColor(Value As Integer)
		Declare Property Visible As Boolean
		Declare Property Visible(Value As Boolean)
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Overridden purely to gate Handle creation/destruction - see the type-level comment.
		Declare Property DesignMode As Boolean
		Declare Property DesignMode(Value As Boolean)
		Declare Property Parent As ReportBand Ptr
		Declare Property Parent(Value As ReportBand Ptr)
		Declare Constructor
		Declare Destructor
	End Type

	'`ReportField` is a report-design item within the MyFbFramework, part of the freeBasic
	'framework. `ReportField` - A data-bound (or static) text field on a report band, the
	'report-design equivalent of a Label (Windows, Linux). Set DataField to the name of the
	'data column to print (OnGetFieldValue on the owning Report supplies the actual value at
	'print time); leave it empty to print static Text instead, exactly like Crystal Reports'
	'Text Objects vs Field Objects, or Xojo's fixed vs bound report fields.
	Private Type ReportField Extends ReportControl
	Private:
		FDataField    As WString Ptr
		FFormatString As WString Ptr
		FSummaryField As WString Ptr
		FSummaryType  As ReportSummaryType
		FCanGrow      As Boolean
		FText         As WString Ptr
		FAlignment    As Integer
		FWordWraps    As Boolean
	Public:
		'Font used to draw Text/the resolved DataField value, both at design time and when
		'DrawBand prints this field - a plain field of Report's own, since ReportField no
		'longer inherits one from Label.
		Font As My.Sys.Drawing.Font
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property Text ByRef As WString
		'Static text to print when DataField is empty
		Declare Property Text(ByRef Value As WString)
		Declare Property Alignment As AlignmentConstants
		'Sets text alignment (Left/Center/Right)
		Declare Property Alignment(Value As AlignmentConstants)
		Declare Property WordWraps As Boolean
		'Enables automatic text line wrapping
		Declare Property WordWraps(Value As Boolean)
		Declare Property DataField ByRef As WString
		'Name of the data column to print here; setting it shows "[FieldName]" at design time
		Declare Property DataField(ByRef Value As WString)
		Declare Property FormatString ByRef As WString
		'Display format, e.g. "{0:N2}" for 2-decimal numbers or "%.2f" style specs
		Declare Property FormatString(ByRef Value As WString)
		Declare Property SummaryType As ReportSummaryType
		'Aggregate to compute (Sum/Average/Count/Min/Max) instead of printing a row value
		Declare Property SummaryType(Value As ReportSummaryType)
		Declare Property SummaryField ByRef As WString
		'Column to aggregate when SummaryType is set; defaults to DataField if left empty
		Declare Property SummaryField(ByRef Value As WString)
		Declare Property CanGrow As Boolean
		'Reserved for future vertical auto-grow support (currently WordWraps handles wrapping)
		Declare Property CanGrow(Value As Boolean)
		Declare Constructor
		Declare Destructor
	End Type

	'`ReportLabel` is a report-design item within the MyFbFramework, part of the freeBasic
	'framework. `ReportLabel` - A purely static caption on a report band (Windows, Linux),
	'the report-design equivalent of dropping a plain Label onto the surface, but built on
	'the same lightweight ReportControl base as ReportField/ReportImage/ReportLine/ReportShape
	'(no data-binding members at all - no DataField/FormatString/SummaryType/SummaryField/
	'CanGrow), rather than a real native Control. Use ReportField instead (leaving DataField
	'set) for anything that needs to be data-bound; use ReportLabel for titles, column
	'headings, and other text that never changes per row - Crystal Reports' plain Text
	'Object, or Xojo's static caption fields.
	Private Type ReportLabel Extends ReportControl
	Private:
		FText      As WString Ptr
		FAlignment As Integer
		FWordWraps As Boolean
	Public:
		'Font used to draw Text, both at design time and when DrawBand prints this label.
		Font As My.Sys.Drawing.Font
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property Text ByRef As WString
		'The caption to print
		Declare Property Text(ByRef Value As WString)
		Declare Property Alignment As AlignmentConstants
		'Sets text alignment (Left/Center/Right)
		Declare Property Alignment(Value As AlignmentConstants)
		Declare Property WordWraps As Boolean
		'Enables automatic text line wrapping
		Declare Property WordWraps(Value As Boolean)
		Declare Constructor
		Declare Destructor
	End Type

	'`ReportImage` is a report-design item within the MyFbFramework, part of the freeBasic
	'framework. `ReportImage` - Displays a picture on a report band (Windows, Linux). Assign
	'Graphic at design time for a fixed picture (a logo, a signature stamp...), or set
	'DataField to load a different picture per data row (a file path column) - each row's
	'image is (re)loaded through OnGetFieldValue at print time.
	Private Type ReportImage Extends ReportControl
	Private:
		FDataField As WString Ptr
	Public:
		'Image data object (Bitmap/Icon), a plain field of Report's own, since ReportImage no
		'longer inherits one from ImageBox.
		Graphic            As My.Sys.Drawing.GraphicType
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property DataField ByRef As WString
		'Data column holding an image file path to load per row; leave empty to use Graphic
		Declare Property DataField(ByRef Value As WString)
		Declare Constructor
		Declare Destructor
	End Type

	'`ReportLine` is a report-design item within the MyFbFramework, part of the freeBasic
	'framework. `ReportLine` - A horizontal or vertical ruling line on a report band
	'(Windows, Linux), the same role as Crystal Reports' Line object.
	Private Type ReportLine Extends ReportControl
	Private:
		FLineWidth As Integer
		FLineColor As Integer
		FVertical  As Boolean
	Public:
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property LineWidth As Integer
		'Thickness of the line in pixels
		Declare Property LineWidth(Value As Integer)
		Declare Property LineColor As Integer
		'RGB color of the line
		Declare Property LineColor(Value As Integer)
		Declare Property Vertical As Boolean
		'False draws a horizontal rule (default); True draws a vertical rule
		Declare Property Vertical(Value As Boolean)
		'Convenience alias for BackColor (inherited from ReportControl), so LineColor stays
		'mirrored onto it the way it used to mirror onto a thin filled Panel's background.
		Declare Property Color As Integer
		Declare Property Color(Value As Integer)
		Declare Constructor
		Declare Destructor
	End Type

	'`ReportShape` is a report-design item within the MyFbFramework, part of the freeBasic
	'framework. `ReportShape` - A rectangle or ellipse drawn on a report band (Windows,
	'Linux), the same role as Crystal Reports' Box/Ellipse drawing objects.
	Private Type ReportShape Extends ReportControl
	Private:
		FShapeKind   As ReportShapeKind
		FBorderColor As Integer
		FBorderWidth As Integer
		FFillColor   As Integer
		FFilled      As Boolean
	Public:
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property ShapeKind As ReportShapeKind
		'Rectangle or Ellipse
		Declare Property ShapeKind(Value As ReportShapeKind)
		Declare Property BorderColor As Integer
		Declare Property BorderColor(Value As Integer)
		Declare Property BorderWidth As Integer
		Declare Property BorderWidth(Value As Integer)
		Declare Property FillColor As Integer
		Declare Property FillColor(Value As Integer)
		Declare Property Filled As Boolean
		'True fills the shape with FillColor; False draws an outline only
		Declare Property Filled(Value As Boolean)
		'Convenience alias for BackColor (see ReportLine.Color).
		Declare Property Color As Integer
		Declare Property Color(Value As Integer)
		Declare Constructor
		Declare Destructor
	End Type

	'`Report` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`Report` - THE single band-based report design surface AND print/paginate/render engine
	'(Windows, Linux; printing itself is Windows-only in this framework). Drop ONE Report
	'control onto a Form; it owns its bands as plain ReportBand data (see above) - never as
	'separate controls - so the component tree / object inspector only ever lists the one
	'Report control, nothing underneath it. A narrow strip down the left edge (BAND_LIST_WIDTH
	'pixels wide) lists the bands by name - "Report Header", "Page Header", "Body" (the Detail
	'band), "Page Footer", ... - click one to make it ActiveBand; drop ReportField/Label/
	'ReportImage/ReportLine/ReportShape controls onto the design surface to its right and they
	'land in whichever band's vertical span their Top falls into. Hook OnGetFieldValue to
	'supply row data, and call Print/PrintPreview/ExportToPDF directly on this same control -
	'the same workflow as Crystal Reports' ReportDocument or Xojo's ReportView, minus both the
	'separate report-file format AND the separate non-visual print-engine component: the report
	'layout IS this control, and this control prints itself.
	Private Type Report Extends Panel
	Private:
		'Dynamically-growing band list (each item is a ReportBand Ptr owned by this Report) -
		'replaces the old fixed-size FBands(REPORT_MAX_BANDS-1) array, so a report is no longer
		'capped at REPORT_MAX_BANDS bands. Use FBands.Count instead of a separate FBandCount.
		FBands      As List
		FDragBand   As Integer 'index of the band whose bottom edge is being drag-resized, or -1
		FDragStartY As Integer
		FRowCount   As Integer
		FCurrentRow As Integer
		FDocument   As PrintDocument
		'Index into FComponents (inherited from Component) of the ReportControl currently
		'selected/framed on the design surface, or -1 if none. FDragField/FDragOffsetX/Y
		'track a left-button drag-to-move in progress on that same item.
		FDragField     As Integer
		FDragOffsetX   As Integer
		FDragOffsetY   As Integer

		'Y position (in design-surface / field-control coordinates, i.e. ignoring the band-
		'list strip) of the top edge of FBands(Index).
		Declare Function BandTop(Index As Integer) As Integer
		'Index of the band whose [Top, Top+Height) span contains y, or -1 if none (below the
		'last band).
		Declare Function BandAt(y As Integer) As Integer
		Declare Function BandCaption(Index As Integer) As String
		'Moves every field control whose Top >= y down/up by Delta pixels - used when a
		'band's Height changes so every band (and its controls) below it re-flows with no
		'gap or overlap, the same job the old ReportBand.RestackBands used to do.
		Declare Sub ShiftControlsFrom(y As Integer, Delta As Integer)
		'Neither a plain native Control (e.g. a Label dropped straight onto the surface) nor
		'a ReportControl (ReportField/ReportImage/ReportLine/ReportShape - see ReportControl)
		'has any reason to stick out past Report's own Panel bounds: the former is a leaf
		'control that never holds children of its own, and the latter is not even a Control,
		'just data Report itself draws and hit-tests. Clamps c's Left/Top/Width/Height so it
		'stays fully inside [DesignAreaLeft, Width) x [0, Height). c may point to either kind
		'(both ultimately reduce to Component, which is all this needs).
		Declare Sub ClampControlBounds(c As Any Ptr)
		'Index into FComponents of the ReportControl whose bounds contain (x, y), searched
		'topmost (highest index, i.e. most-recently-added) first, or -1 if none.
		Declare Function FieldAt(x As Integer, y As Integer) As Integer
		Declare Function OnBandEdge(Index As Integer, y As Integer) As Boolean
		'Draws the design surface (band strip + band backdrops + every field control, with a
		'selection frame around ActiveField) onto Canvas - called from ProcessMessage's own
		'WM_PAINT/GDK_EXPOSE handling, after Base.ProcessMessage has already let Panel paint
		'its own background/bevel and fire OnPaint for whoever is using this Report control.
		Declare Sub DrawDesignSurface(ByRef Canvas As My.Sys.Drawing.Canvas)
		'Selects/starts dragging whatever is at (x, y) - a field, a band edge, or a band row
		'in the strip - called from ProcessMessage's own left-button-down handling.
		Declare Sub HandleMouseDown(x As Integer, y As Integer)
		'Continues whatever drag HandleMouseDown started, or just updates the resize cursor
		'when nothing is being dragged - called from ProcessMessage's own mouse-move handling.
		Declare Sub HandleMouseMove(x As Integer, y As Integer)
		'Ends whatever drag HandleMouseDown started - called from ProcessMessage's own
		'left-button-up handling.
		Declare Sub HandleMouseUp()
		Declare Function MeasureBand(BandIndex As Integer, ByRef Canvas As My.Sys.Drawing.Canvas) As Integer
		Declare Sub DrawBand(ByRef Canvas As My.Sys.Drawing.Canvas, BandIndex As Integer, Top As Single, RowIndex As Integer)
		'Draws one ReportField/ReportLabel/ReportImage/ReportLine/ReportShape's content at (X, Y)
		'sized W x H on Canvas - shared by DrawBand (print/PDF, page coordinates) and
		'DrawDesignSurface (design surface, un-offset local coordinates) so the two always
		'agree pixel-for-pixel on what a field looks like. cn is c's ClassName (the caller
		'already has it in every case, so this doesn't re-derive it); c is a Control Ptr for
		'"Label" and a ReportControl Ptr (ReportField/ReportImage/ReportLine/ReportShape)
		'otherwise.
		Declare Sub DrawReportControlContent(ByRef Canvas As My.Sys.Drawing.Canvas, ByRef cn As String, c As Any Ptr, X As Single, Y As Single, W As Integer, H As Integer, RowIndex As Integer)
		Declare Function GroupKeyOf(BandIndex As Integer, RowIndex As Integer) ByRef As WString
		Declare Function FormatValue(ByRef Value As WString, ByRef Format As WString) As String
		Declare Function ComputeSummary(Field As Any Ptr, FromRow As Integer, ToRow As Integer) As Double
		Declare Static Sub PrintPageHandler(ByRef Designer As My.Sys.Object, ByRef Sender As PrintDocument, ByRef Canvas As My.Sys.Drawing.Canvas, ByRef HasMorePages As Boolean)
		#ifdef __USE_WINAPI__
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			Declare Static Sub WNDPROC(ByRef Message As Message)
		#endif
		Declare Static Sub GraphicChange(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
	Public:
		#ifndef ReadProperty_Off
			'Loads properties (including the band list) from the persistence stream
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves properties (including the band list) to the persistence stream
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif

		'Width, in pixels, of the left-hand band-name strip.
		Const BAND_LIST_WIDTH As Integer = 110
		'Row height, in pixels, of one entry in the band-name strip.
		Const BAND_LIST_ROW_H As Integer = 24

		'Left edge, in pixels, of the design area a band's field controls are dropped onto -
		'i.e. BAND_LIST_WIDTH. Used to translate a field control's design-time Left back to a
		'page-relative X when printing.
		Declare Function DesignAreaLeft() As Integer
		Declare Function BandCount() As Integer
		'Band at Index (0-based, in print order - the same order the band-name strip lists
		'them in), or 0 if Index is out of range. Backs the ReportBandByIndex export that
		'Designer.DrawReport calls through Symbols(...)->ReportBandByIndexFunc - see
		'ReportBandByIndex in mff.bas.
		Declare Function BandByIndex(Index As Integer) As ReportBand Ptr
		'Appends a new band of NewBandType at the end (height defaults to 32px for Report/
		'Page bands, 24px for Group/Detail bands) and returns a pointer to it. FBands is a
		'dynamically-growing List, so there is no longer a fixed cap on the number of bands.
		'The returned pointer stays valid for the band's whole lifetime (List.Insert/Remove
		'only reshuffle the pointers it holds, never the ReportBand instances themselves) -
		'but it becomes stale the moment RemoveBand deletes that particular band.
		Declare Function AddBand(NewBandType As ReportBandType) As ReportBand Ptr
		Declare Sub AddBand(NewBand As ReportBand Ptr)
		'Removes the band at Index; every field control that was inside it is also removed,
		'and every band below it (with its controls) re-flows up to close the gap.
		Declare Sub RemoveBand(Index As Integer)
		'Same as RemoveBand(Index), but takes a band pointer (as returned by AddBand, or by
		'walking the band list yourself) instead of an index. Does nothing if Band is 0 or
		'doesn't belong to this Report.
		Declare Sub RemoveBand(Band As ReportBand Ptr)
		Declare Property BandType(Index As Integer) As ReportBandType
		Declare Property BandType(Index As Integer, Value As ReportBandType)
		Declare Property BandHeight(Index As Integer) As Integer
		'Changing this re-flows every band below Index (and its field controls) down/up to
		'match - exactly like dragging the band's bottom edge on the design surface.
		Declare Property BandHeight(Index As Integer, Value As Integer)
		Declare Property BandGroupField(Index As Integer) ByRef As WString
		'Data field name that a GroupHeader/GroupFooter band breaks (starts a new group) on
		Declare Property BandGroupField(Index As Integer, ByRef Value As WString)
		Declare Property BandNewPageBefore(Index As Integer) As Boolean
		Declare Property BandNewPageBefore(Index As Integer, Value As Boolean)
		Declare Property BandNewPageAfter(Index As Integer) As Boolean
		Declare Property BandNewPageAfter(Index As Integer, Value As Boolean)
		'First band index whose BandType is BT, or -1 if the report has none.
		Declare Function IndexOfBandType(BT As ReportBandType) As Integer
Declare Property RowCount As Integer
		'Number of data rows to print; set this from your dataset's record count before Print()
		Declare Property RowCount(Value As Integer)
		Declare Property Document As PrintDocument Ptr
		'Underlying PrintDocument, for direct access to PrinterSettings (paper size, margins...)
		Declare Sub Print
		'Sends the report straight to PrinterSettings.Name
		Declare Sub PrintPreview
		'Shows the built-in Print Preview dialog before printing
		Declare Sub ExportToPDF(ByRef FileName As WString = "", ByRef PrinterName1 As WString = "Microsoft Print to PDF")
		'Prints through a PDF-writer virtual printer (Windows' own "Microsoft Print to PDF" by
		'default); Windows itself prompts for the destination file name on stock drivers
		'Overridden - rather than assigning OnPaint/OnMouseDown/OnMouseMove/OnMouseUp, the way
		'an ordinary library user would - because those On* events belong to whoever uses this
		'Report control, not to Report's own internal implementation. This is the framework's
		'own hook for a control to react to its raw messages (see Control.ProcessMessage);
		'calls Base.ProcessMessage so Panel's own painting and any On* handlers the library
		'user did set still run exactly as normal.
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		Declare Constructor
		Declare Destructor
		'Supplies the value for DataField/SummaryField at RowIndex; implement this to bind the
		'report to your dataset (a Table/Query/Recordset row, an array, anything).
		OnGetFieldValue As Function(ByRef Designer As My.Sys.Object, ByRef FieldName As WString, RowIndex As Integer) ByRef As WString
		'Fires once before the first page is generated - reset running totals here
		OnBeginPrint As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Report)
		'Fires once after the last page has been generated
		OnEndPrint As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Report)
	End Type

	'Splits Text on spaces so it fits within WidthPixels using Canvas' current Font. Shared
	'by Report.DrawBand for ReportField.WordWraps support.
	Declare Sub WordWrapLines(ByRef Canvas As My.Sys.Drawing.Canvas, ByRef Text As WString, WidthPixels As Integer, Lines() As String, ByRef LineCount As Integer)
End Namespace

#ifndef __USE_MAKE__
	#include once "Report.bas"
#endif
