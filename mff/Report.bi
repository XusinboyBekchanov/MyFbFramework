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
	'instantiated on its own - Report owns them through Report.Bands (a ReportBandCollection,
	'the same role ReBarBandCollection plays for ReBar) instead of holding a collection of
	'separate band controls, so the component tree / toolbox never shows a "ReportBand"
	'alongside Report. Field controls belonging to a band are located purely by their Top
	'falling inside the band's vertical span (see Report.BandAt) - there is no per-control
	'parent/child relationship to a band, only to the Report itself.
	
	Type PReport As Report Ptr
	
	Private Type ReportBand Extends My.Sys.Object
	Private:
		FParent As Any Ptr 'the owning Report control (Cast internally)
		FHeight As Integer
		''The owning Report's FComponents list (where its ReportField/ReportImage/ReportLine/
		''ReportShape items live - they Extend Component, not Control). FComponents is a
		''Protected member of Component, so the collection can't reach it through Parent;
		''Report's own constructor hands it over here instead, right next to Parent.
		'Components As List Ptr
		'Keeps a control vertically inside the Report: never taller than it, never sticking out
		'past its bottom edge, never above 0. Left/Width are deliberately left alone - a
		'vertical re-flow has no business moving anything sideways. c may point to a native
		'Control or to a ReportControl (both reduce to Component, which is all this needs).
		Declare Sub ClampControlVertically(c As Any Ptr)
		'Moves every field control whose Top >= y down/up by Delta pixels - used when a
		'band's Height changes (or a band is added/removed) so every band (and its controls)
		'below it re-flows with no gap or overlap, the same job the old
		'ReportBand.RestackBands used to do. Also re-clamps every control to the Report's
		'bounds afterwards (see ClampControlVertically), since a Delta can just as easily push a
		'control past Report's right/bottom edge as it can create the gap/overlap this exists
		'to close. Two kinds of item can be dropped onto a band, and they live in two
		'different places: plain native Controls (e.g. a Label) in Parent's Controls()/
		'ControlCount as usual, and the ReportField/ReportLabel/ReportImage/ReportLine/
		'ReportShape items in Components (ReportControl.Parent puts them there).
		Declare Sub ShiftControlsFrom(y As Integer, Delta As Integer)
	Public:
		Components As List
		BandType      As ReportBandType
		GroupField    As WString Ptr
		NewPageBefore As Boolean
		NewPageAfter  As Boolean
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Y position (in design-surface / field-control coordinates, i.e. ignoring the band-
		'list strip) of the top edge of the band at Index. Index = Count gives the bottom
		'edge of the last band, i.e. where a band appended at the end would start.
		Declare Function TopOf(Index As Integer) As Integer
		Declare Property Height As Integer
		'Once this band belongs to a Report, changing this re-flows every band below it (and
		'its field controls) down/up to match - exactly like dragging the band's bottom edge
		'on the design surface - and grows/shrinks Report's own Height by the same amount, so
		'the bands keep filling it. Never smaller than 8px once attached to a Report.
		Declare Property Height(Value As Integer)
		'The Report control this band belongs to (Cast to My.Sys.Forms.Report Ptr internally).
		Declare Property Parent As PReport
		Declare Property Parent(Value As PReport)
		Declare Constructor
		Declare Destructor
	End Type

	'`ReportBandCollection` - owns and manages a Report's bands, the same role
	'`ReBarBandCollection` plays for a ReBar's bands: Report.Bands is the single point of
	'entry for adding/removing/looking up bands, instead of Report itself exposing raw
	'AddBand/RemoveBand/BandByIndex methods that reach into a private list directly.
	'Report.AddBand/RemoveBand/BandByIndex/BandCount/IndexOfBand/IndexOfBandType all still
	'exist too, as thin convenience wrappers around this collection (again, exactly like
	'ReBar.Add(Ctrl) is a thin wrapper around Bands.Add(Ctrl)) - existing code, and the
	'ReportBandByIndex/BandCount reflection Designer.bas relies on, keep working unchanged.
	Private Type ReportBandCollection
	Private:
		FItems As List
	Public:
		'The owning Report control.
		Parent As PReport
		Declare Function Count As Integer
		Declare Property Item(Index As Integer) As ReportBand Ptr
		Declare Property Item(Index As Integer, Value As ReportBand Ptr)
		'Appends a new band of NewBandType in canonical print order (the ReportBandType enum's
		'declaration order), stable relative to existing bands that share the same type (e.g.
		'nested groups). Height defaults to 32px for Report/Page bands, 24px for Group/Detail
		'bands. The returned pointer stays valid for the band's whole lifetime, but becomes
		'stale the moment Remove deletes that particular band.
		Declare Function Add(NewBandType As ReportBandType) As ReportBand Ptr
		'Copies NewBand's own properties (BandType/Height/GroupField/NewPageBefore/
		'NewPageAfter) into a freshly-allocated band this collection owns, and inserts it in
		'canonical print order - NewBand itself stays the caller's to manage/free.
		Declare Sub Add(NewBand As ReportBand Ptr)
		'Removes the band at Index; every field control that was inside it is also removed,
		'and every band below it (with its controls) re-flows up to close the gap.
		Declare Sub Remove(Index As Integer)
		'Same as Remove(Index), but takes a band pointer (as returned by Add, or by walking
		'the collection yourself) instead of an index. Does nothing if Band is 0 or doesn't
		'belong to this collection.
		Declare Sub Remove(Band As ReportBand Ptr)
		Declare Sub Clear
		'Index of Band within the collection, or -1 if it's 0 or doesn't belong to it.
		Declare Function IndexOf(Band As ReportBand Ptr) As Integer
		'First band index whose BandType is BT, or -1 if the report has none.
		Declare Function IndexOf(BT As ReportBandType) As Integer
		Declare Function Contains(Band As ReportBand Ptr) As Boolean
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
	'lists them in FComponents (setting SomeField.Parent = @SomeBand is all it takes to
	'register one - ReportControl.Parent adds it to its Report's FComponents, since the
	'Component.Parent it hides would want a Component, not a band) and is responsible for
	'drawing them
	'(Report.DrawReportControlContent, shared by the print engine and the design surface) -
	'there is no native window to paint itself or to route mouse messages through the way a
	'real Control has. Selecting/dragging one of these on the design surface is entirely
	'Designer's job (via reflection - see Report.FieldAt), not Report's own.
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
	Protected:
		FText      As WString Ptr
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
		FRowCount   As Integer
		FCurrentRow As Integer
		FDocument   As PrintDocument

		'Index of the band whose [Top, Top+Height) span contains y, or -1 if none (below the
		'last band).
		Declare Function BandAt(y As Integer) As Integer
		Declare Function BandCaption(Index As Integer) As String
		'Index into FComponents of the ReportControl whose bounds contain (x, y), searched
		'topmost (highest index, i.e. most-recently-added) first, or -1 if none.
		'Index into FComponents of the ReportControl whose bounds contain (x, y), searched
		'topmost (highest index, i.e. most-recently-added) first, or -1 if none. A plain
		'geometry query with no mouse/cursor/capture state of its own, so - unlike Report's old
		'HandleMouseDown/Move/Up - it stays here; Designer can call it (or BandAt/Bands.TopOf)
		'through reflection if a future field-drag feature there ever needs it.
		Declare Function FieldAt(x As Integer, y As Integer) As Integer
		'Draws the design surface (band strip + band backdrops + every field control, with a
		'selection frame around ActiveField) onto Canvas - called from ProcessMessage's own
		'WM_PAINT/GDK_EXPOSE handling, after Base.ProcessMessage has already let Panel paint
		'its own background/bevel and fire OnPaint for whoever is using this Report control.
		Declare Sub DrawDesignSurface(ByRef Canvas As My.Sys.Drawing.Canvas)
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

		'Width, in pixels, of the left-hand band-name strip - which is also the left edge of the
		'design area a band's field controls are dropped onto. Subtract it from a field
		'control's design-time Left to get its page-relative X when printing.
		Const BAND_LIST_WIDTH As Integer = 110
		'Row height, in pixels, of one entry in the band-name strip.
		Const BAND_LIST_ROW_H As Integer = 24

		'Owns and manages this Report's bands - see ReportBandCollection above. Backs the
		'ReportBandByIndex export that Designer.DrawReport calls through
		'Symbols(...)->ReportBandByIndexFunc (via Bands.Item) - see ReportBandByIndex below.
		Bands As ReportBandCollection

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
		'Every change to Report's size - Report.Height = 100, SetBounds, a designer drag, a
		'stream load - ends up here, so this is where "the bands always exactly fill the
		'report" is enforced: the last band absorbs whatever Height gained/lost (never below
		'its 8px minimum), every other band keeps its own height.
		Declare Virtual Sub Move(cLeft As Integer, cTop As Integer, cWidth As Integer, cHeight As Integer)
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
