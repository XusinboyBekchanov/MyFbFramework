#include once "Component.bi"
#include once "Canvas.bi"
#include once "Printer.bi"
#ifdef __USE_WINAPI__
	#include once "win\wingdi.bi"
#endif

Namespace My.Sys.ComponentModel
	Type PrintDocumentPage Extends Object
		#ifdef __USE_WINAPI__
			Handle As HENHMETAFILE
		#endif
		Canvas As My.Sys.Drawing.Canvas
		Declare Constructor
		Declare Destructor
	End Type
	
	Type PrintDocumentPages Extends List
	Public:
		Declare Function Add(Index As Integer = -1) As PrintDocumentPage Ptr
		Declare Sub Clear
		Declare Function Contains(PageItem As PrintDocumentPage Ptr) As Boolean
		Declare Function IndexOf(PageItem As PrintDocumentPage Ptr) As Integer
		Declare Function Insert(Index As Integer, PageItem As PrintDocumentPage Ptr) As PrintDocumentPage Ptr
		Declare Property Item(Index As Integer) As PrintDocumentPage Ptr
		Declare Property Item(Index As Integer, Value As PrintDocumentPage Ptr)
		Declare Sub Remove(Index As Integer)
		Declare Constructor
		Declare Destructor
	End Type
	
	Type PrintDocument Extends Component
	Private:
		Declare Sub Paint(hwnd As HWND, hdcDestination As HDC, ByVal PageNumber As Integer)
	Public:
		DocumentName As UString
		Pages As PrintDocumentPages
		PrinterSettings As Printer
		Declare Sub Print
		Declare Sub Repaint
		OnPrintPage As Sub(ByRef Sender As PrintDocument, ByRef Canvas As My.Sys.Drawing.Canvas, ByRef HasMorePages As Boolean)
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "PrintDocument.bas"
#endif
