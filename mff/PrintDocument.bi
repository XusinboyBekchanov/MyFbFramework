#include once "Component.bi"
#include once "Canvas.bi"
#include once "Printer.bi"
#include once "List.bi"
#ifdef __USE_WINAPI__
	#include once "win\wingdi.bi"
#elseif defined(__USE_JNI__)
	'Android: the DPI of the main form for the pixels of the pages (PrintDocument.Repaint)
	#include once "Application.bi"
#endif

Namespace My.Sys.ComponentModel
	Type PrintDocumentPage Extends Object
		#ifdef __USE_WINAPI__
			Handle As HENHMETAFILE
		#elseif defined(__USE_GTK__)
			' Recording surface with the page drawing (like the enhanced metafile on WinAPI)
			Surface As cairo_surface_t Ptr
		#elseif defined(__USE_JNI__) OrElse defined(__USE_APPLE__)
			'Android: the MffPage of the page (a global reference, PageCreate); macOS, iOS: its picture
			Handle As Any Ptr
		#endif
		Canvas As My.Sys.Drawing.Canvas
		Declare Constructor
		Declare Destructor
	End Type
	
	Type PrintDocumentPages Extends Object
	Private:
		FItems As List
	Public:
		Declare Function Add(Index As Integer = -1) As PrintDocumentPage Ptr
		Declare Sub Clear
		Declare Function Contains(PageItem As PrintDocumentPage Ptr) As Boolean
		Declare Property Count As Integer
		Declare Function IndexOf(PageItem As PrintDocumentPage Ptr) As Integer
		Declare Function Insert(Index As Integer, PageItem As PrintDocumentPage Ptr) As PrintDocumentPage Ptr
		Declare Property Item(Index As Integer) As PrintDocumentPage Ptr
		Declare Property Item(Index As Integer, Value As PrintDocumentPage Ptr)
		Declare Sub Remove(Index As Integer)
		Declare Constructor
		Declare Destructor
	End Type
	
	'Defines a reusable object that sends output to a printer.
	Type PrintDocument Extends Component
	Private:
		#ifdef __USE_WINAPI__
			Declare Sub Paint(hwnd As HWND, hdcDestination As HDC, ByVal PageNumber As Integer)
			Declare Function PrintTo(ByRef OutputFileName As WString) As Boolean
		#elseif defined(__USE_GTK__)
			Declare Static Sub PrintOperation_DrawPage(op As GtkPrintOperation Ptr, context As GtkPrintContext Ptr, page_nr As gint, user_data As gpointer)
			Declare Function RunPrintOperation(Action As GtkPrintOperationAction, ByRef ExportFileName As WString) As Boolean
		#endif
	Public:
		#ifndef ReadProperty_Off
			Declare Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		DocumentName As UString
		Pages As PrintDocumentPages
		PrinterSettings As Printer
		Declare Sub Print
		'Writes the pages (painted by Repaint before, or now when there are none) to the PDF file FileName without a dialog.
		'Windows: through the printer PrinterName ("Microsoft Print to PDF"); GTK: by the PDF export of GTK. False when the
		'file is not written or the platform has no PDF file output (Android, macOS, iOS, Web: Print, the print dialog of
		'the system saves a PDF).
		Declare Function ExportToPDF(ByRef FileName As WString, ByRef PrinterName As WString = "Microsoft Print to PDF") As Boolean
		Declare Sub Repaint
		OnPrintPage As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As PrintDocument, ByRef Canvas As My.Sys.Drawing.Canvas, ByRef HasMorePages As Boolean)
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "PrintDocument.bas"
#endif
