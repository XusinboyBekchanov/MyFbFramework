'################################################################################
'#  Printer.bi                                                                  #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Aloberoger, Xusinboy Bekchanov                                     #
'#  Based on:                                                                   #
'#   TPrinter.bi                                                                #
'#   GUITK-S Windows GUI FB Wrapper Library                                     #
'#   Copyright (c) Aloberoger                                                   #
'################################################################################

#include once "Canvas.bi"
#ifdef __USE_WINAPI__
	#include once "win/winspool.bi"
#endif

Namespace My.Sys.ComponentModel
	Private Enum PrinterOrientation
		#ifndef __USE_GTK__
			poPortait =DMORIENT_PORTRAIT
			poLandscape=DMORIENT_LANDSCAPE
		#else
			poPortait
			poLandscape
		#endif
	End Enum
	
	Private Enum PrinterQuality
		#ifndef __USE_GTK__
			pqDraft=DMRES_DRAFT
			pqLow =DMRES_LOW
			pqMedium =DMRES_MEDIUM
			pqHigh=DMRES_HIGH
		#else
			pqDraft
			pqLow
			pqMedium
			pqHigh
		#endif
	End Enum
	
	Private Enum PrinterDuplexMode
		pdmSimplex = 1
		pdmHorizontal = 2
		pdmVertical = 3
	End Enum
	
	Private Enum PrinterPaperSize
		#ifndef __USE_GTK__
			ppsLetter=DMPAPER_LETTER	'Letter, 8 1/2- by 11-inches
			ppsLEGALr=DMPAPER_LEGAL	'Legal, 8 1/2- by 14-inches
			ppsA4=DMPAPER_A4	'A4 Sheet, 210- by 297-millimeters
			ppsCSHEET=DMPAPER_CSHEET	'C Sheet, 17- by 22-inches
			ppsDSHEET=DMPAPER_DSHEET	'D Sheet, 22- by 34-inches
			ppsESHEET=DMPAPER_ESHEET	'E Sheet, 34- by 44-inches
			ppsLETTERSMALL=DMPAPER_LETTERSMALL	'Letter Small, 8 1/2- by 11-inches
			ppsTABLOID=DMPAPER_TABLOID	'Tabloid, 11- by 17-inches
			ppsLEDGER=DMPAPER_LEDGER	'Ledger, 17- by 11-inches
			ppsSTATEMENT=DMPAPER_STATEMENT	'Statement, 5 1/2- by 8 1/2-inches
			ppsEXECUTIVE=DMPAPER_EXECUTIVE	'Executive, 7 1/4- by 10 1/2-inches
			ppsA3=DMPAPER_A3	'A3 sheet, 297- by 420-millimeters
			ppsA4SMALL=DMPAPER_A4SMALL	'A4 small sheet, 210- by 297-millimeters
			'ppsLetter=DMPAPER_A5	'A5 sheet, 148- by 210-millimeters
			'ppsLetter=DMPAPER_B4	'B4 sheet, 250- by 354-millimeters
			'ppsLetter=DMPAPER_B5	'B5 sheet, 182- by 257-millimeter paper
			'ppsLetter=DMPAPER_FOLIO	'Folio, 8 1/2- by 13-inch paper
			'ppsLetter=DMPAPER_QUARTO	'Quarto, 215- by 275-millimeter paper
			'ppsLetter=DMPAPER_10X14	'10- by 14-inch sheet
			'ppsLetter=DMPAPER_11X17	'11- by 17-inch sheet
			'ppsLetter=DMPAPER_NOTE	'Note, 8 1/2- by 11-inches
			'ppsLetter=DMPAPER_ENV_9	'#9 Envelope, 3 7/8- by 8 7/8-inches
			'ppsLetter=DMPAPER_ENV_10	'#10 Envelope, 4 1/8- by 9 1/2-inches
			'ppsLetter=DMPAPER_ENV_11	'#11 Envelope, 4 1/2- by 10 3/8-inches
			'ppsLetter=DMPAPER_ENV_12	'#12 Envelope, 4 3/4- by 11-inches
			'ppsLetter=DMPAPER_ENV_14	'#14 Envelope, 5- by 11 1/2-inches
			'ppsLetter=DMPAPER_ENV_DL	'DL Envelope, 110- by 220-millimeters
			'ppsLetter=DMPAPER_ENV_C5	'C5 Envelope, 162- by 229-millimeters
			'ppsLetter=DMPAPER_ENV_C3	'C3 Envelope,  324- by 458-millimeters
			'ppsLetter=DMPAPER_ENV_C4	'C4 Envelope,  229- by 324-millimeters
			'ppsLetter=DMPAPER_ENV_C6	'C6 Envelope,  114- by 162-millimeters
			'ppsLetter=DMPAPER_ENV_C65	'C65 Envelope, 114- by 229-millimeters
			'ppsLetter=DMPAPER_ENV_B4	'B4 Envelope,  250- by 353-millimeters
			'ppsLetter=DMPAPER_ENV_B5	'B5 Envelope,  176- by 250-millimeters
			'ppsLetter=DMPAPER_ENV_B6	'B6 Envelope,  176- by 125-millimeters
			'ppsLetter=DMPAPER_ENV_ITALY	'Italy Envelope, 110- by 230-millimeters
			'ppsLetter=DMPAPER_ENV_MONARCH	'Monarch Envelope, 3 7/8- by 7 1/2-inches
			'ppsLetter=DMPAPER_ENV_PERSONAL	'6 3/4 Envelope, 3 5/8- by 6 1/2-inches
			'ppsLetter=DMPAPER_FANFOLD_US	'US Std Fanfold, 14 7/8- by 11-inches
			'ppsLetter=DMPAPER_FANFOLD_STD_GERMAN	'German Std Fanfold, 8 1/2- by 12-inches
			'ppsLetter=DMPAPER_FANFOLD_LGL_GERMAN	'German Legal Fanfold, 8 1/2- by 13-inches
		#else
			ppsLetter	'Letter, 8 1/2- by 11-inches
			ppsLEGALr	'Legal, 8 1/2- by 14-inches
			ppsA4	'A4 Sheet, 210- by 297-millimeters
			ppsCSHEET	'C Sheet, 17- by 22-inches
			ppsDSHEET	'D Sheet, 22- by 34-inches
			ppsESHEET	'E Sheet, 34- by 44-inches
			ppsLETTERSMALL	'Letter Small, 8 1/2- by 11-inches
			ppsTABLOID	'Tabloid, 11- by 17-inches
			ppsLEDGER	'Ledger, 17- by 11-inches
			ppsSTATEMENT	'Statement, 5 1/2- by 8 1/2-inches
			ppsEXECUTIVE	'Executive, 7 1/4- by 10 1/2-inches
			ppsA3	'A3 sheet, 297- by 420-millimeters
			ppsA4SMALL	'A4 small sheet, 210- by 297-millimeters
		#endif
	End Enum
	
	Type PaperSize Extends Object
		Height As Integer
		Kind As PrinterPaperSize
		PaperName As UString
		RawKind As Integer
		Width As Integer
	End Type
	
	Type PaperSizeCollection Extends Object
	Private:
		FItems As List
	Public:
		Declare Function Add(Index As Integer = -1) As PaperSize Ptr
		Declare Sub Clear
		Declare Function Contains(PaperSizeItem As PaperSize Ptr) As Boolean
		Declare Property Count As Integer
		Declare Function IndexOf(PaperSizeItem As PaperSize Ptr) As Integer
		Declare Function Insert(Index As Integer, PaperSizeItem As PaperSize Ptr) As PaperSize Ptr
		Declare Property Item(Index As Integer) As PaperSize Ptr
		Declare Property Item(Index As Integer, Value As PaperSize Ptr)
		Declare Sub Remove(Index As Integer)
		Declare Constructor
		Declare Destructor
	End Type
	
	'Enables you to communicate with a system printer (initially the default printer) (Windows only).
	Private Type Printer Extends Component
	Private:
		#ifndef __USE_GTK__
			m_hdc As HDC               'handle of a display device context
			m_hFont As HFONT             'handle of current font
			hOrigFont As HFONT       'handle of original font
			hDevMode As DEVMODE Ptr          'handle to DEVMODE structure
		#endif
		#ifndef CRLF
			#define CRLF Chr(10, 13)
		#endif
		#ifdef __USE_WINAPI__
			Declare Function GetDocumentProperties(Field As DWORD) As Long
		#endif
		m_Name As String
		m_PortName As String
		m_Page As Integer
		m_PageSize As Integer
		m_Quality  As Integer
		m_Copies As Integer
		m_FromPage As Integer
		m_ToPage As Integer
		charHt As Integer          'character height
		leftMargin As Integer      'left margin
		rightMargin As Integer     'right margin
		topMargin As Integer       'top margin
		bottomMargin As Integer    'bottom margin
		printerName As String     'name of printer
		origDuplex As Long        'original duplex mode
		origOrient As Long        'original orientation mode
		As Integer xPos, yPos       'default position for text print
		As Integer FPageNumber = 1
		m_Duplex As PrinterDuplexMode
		m_ColorMode As Long
		FTitle  As String
		Declare Function Parse Overload (source As String, delimiter As String = "|", index As Integer) As String
		Declare Function Parse(source As String, index As Integer, delimiter As String = ",") As String
		Declare Function StrReverse(S As String) As String
		Declare Sub      OrientPrint(n As Long)
		
		Declare Function SetPrinterOrientation2 (ByRef PrinterName As WString, ByVal nOrientation As Long) As Long
		
		Declare Function SetPrinterOrientation (ByRef PrinterName As WString, ByVal nOrientation As Long) As Long
		Declare Function GetPrinterOrientation (ByRef PrinterName As WString) As Long
		Declare Function GetPrinterNeededSize(ByRef PrinterName As WString) As Long
		Declare Function PrinterPaperNames (ByRef PrinterName As WString) As String
		Declare Sub GetPrinterPaperSizes(ByRef PrinterName As WString)
		Declare Function GetPrinterPaperSizesAsString(ByRef PrinterName As WString) As String
		Declare Function GetPrinterPaperSize (ByRef PrinterName As WString) As Long
		Declare Function SetPrinterPaperSize (ByRef PrinterName As WString, ByVal nSize As Long) As Long
		Declare Function GetPrinterPort (ByRef PrinterName As WString) As String
		Declare Function GetPrinterFromPort (ByRef PortName As WString) As String
		Declare Function GetPrinterQualityMode (ByRef PrinterName As WString) As PrinterQuality
		Declare Function SetPrinterQuality (ByRef PrinterName As WString, ByVal nMode As PrinterQuality) As Long
		Declare Function GetPrinterScale (ByRef PrinterName As WString) As Long
		Declare Function GetPrinterScalingFactorX (ByRef PrinterName As WString) As Long
		Declare Function GetPrinterScalingFactorY (ByRef PrinterName As WString) As Long
		Declare Function SetPrinterColorMode (ByRef PrinterName As WString, ByVal nMode As Long) As Long
		Declare Function SetPrinterCopies (ByRef PrinterName As WString, ByVal nCopies As Long) As Long
		Declare Function SetPrinterDuplexMode (ByRef PrinterName As WString, ByVal nDuplexMode As Long) As Long
		Declare Function GetPrinterDuplex (ByRef PrinterName As WString) As Long
		
		
		Declare Function GetPrinterDriverVersion (ByRef PrinterName As WString) As Long
		Declare Function GetPrinterHorizontalResolution (ByRef PrinterName As WString) As Long ' printableWidth
		Declare Function GetPrinterVerticalResolution (ByRef PrinterName As WString) As Long
		Declare Function GetPrinterMaxCopies (ByRef PrinterName As WString) As Long
		Declare Function GetPrinterMaxPaperHeight (ByRef PrinterName As WString) As Long
		Declare Function GetPrinterMaxPaperWidth (ByRef PrinterName As WString) As Long
		Declare Function EnumPrinterPorts () As String
		Declare Function EnumPrinters_ () As String
		' Declare FUNCTION  DefaultPrinter () AS String
		Declare Function GetDefaultPrinterDevice () As String
		Declare Function GetDefaultPrinterDriver () As String
		Declare Function GetDefaultPrinterPort () As String
		Declare Sub ShowPrinterProperties()
		Declare Sub UpdateMargeins()
	Public:
		#ifndef ReadProperty_Off
			Declare Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Canvas As My.Sys.Drawing.Canvas
		PaperSizes As PaperSizeCollection
		Declare Sub reportError( ByVal n As Long)
		Declare Property Name(vData As String)
		Declare Property Name() As String
		Declare Property PortName(vData As String)
		Declare Property PortName() As String
		#ifndef __USE_GTK__
			Declare Property  HANDLE() As HDC
		#endif
		Declare Property PageLength As  Integer
		Declare Property PageWidth As  Integer
		Declare Property MarginLeft As  Integer
		Declare Property MarginLeft(value As  Integer)
		Declare Property MarginTop As  Integer
		Declare Property MarginTop(value As  Integer)
		Declare Property MarginRight As  Integer
		Declare Property MarginRight(value As  Integer)
		Declare Property Marginbottom As  Integer
		Declare Property Marginbottom(value As  Integer)
		Declare Property Page(vData As Integer)
		Declare Property Page() As Integer
		Declare Property PageSize(vData As Integer)
		Declare Property PageSize() As Integer
		Declare Property PrintableWidth() As Long
		Declare Property PrintableHeight() As Long
		Declare Property Orientation(vData As PrinterOrientation)
		Declare Property Orientation() As PrinterOrientation
		Declare Property Copies(vData As Integer)
		Declare Property Copies() As Integer
		Declare Property Quality(vData As PrinterQuality)
		Declare Property Quality() As PrinterQuality
		Declare Property FromPage(vData As Integer)
		Declare Property FromPage() As Integer
		Declare Property ToPage(vData As Integer)
		Declare Property ToPage() As Integer
		Declare Property Scale () As Long
		Declare Property ScaleFactorX() As Long
		Declare Property ScaleFactorY() As Long
		Declare Property ColorMode (ByVal nMode As Long)
		Declare Property ColorMode() As Long
		Declare Property DriveVersion() As Long
		
		Declare Property MaxCopies() As Long
		Declare Property MaxPaperHeight() As Long
		Declare Property MaxPaperWidth() As Long
		Declare Function DefaultPrinter() As String
		Declare Function ChoosePrinter() As String
		Declare Sub GetPageSize(ByRef wi As Integer, ByRef ht As Integer)
		Declare Sub GetCharSize(ByRef wi As Integer, ByRef ht As Integer)
		Declare Function GetLines( ByVal y As Integer = 0) As Long
		Declare Property DuplexMode(Value As PrinterDuplexMode)
		Declare Property DuplexMode() As PrinterDuplexMode
		Declare Property Title() As String
		Declare Property Title(value As String)
		Declare Sub StartDoc()
		Declare Sub StartPage
		Declare Sub EndDPage
		Declare Sub NewPage
		Declare Sub EndDoc
		Declare Sub CalcPageSize(ByRef Rows As Long, ByRef Columns As Long)
		Declare Property FontSize() As Integer
		Declare Property FontSize(As Integer)
		#ifndef __USE_GTK__
			Declare Function NewFont(fName As String = "times new Roman", fSize As Long = 12, ibold As Long = False, iunderline As Long = False, iitalic As Long = False ) As HFONT
		#endif
		Declare Constructor()
		'Declare Operator Cast() As TCONTROL Ptr
		'Declare Constructor
	End Type
	Dim Shared As WStringList PrinterSizesList
End Namespace

#ifndef __USE_MAKE__
	#include once "Printer.bas"
#endif

