'################################################################################
'#  Printer.bi                                                                  #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Aloberoger, Xusinboy Bekchanov                                     #
'#  Based on:                                                                   #
'#   TPrinter.bi                                                                #
'#   GUITK-S Windows GUI FB Wrapper Library                                     #
'#   Copyright (c) Aloberoger                                                   #
'################################################################################

#Ifndef CRLF
	#Define CRLF Chr(10,13)
#endif
#Include Once "Canvas.bi"
#IfDef __FB_Win32__
	#Include Once "win/winspool.bi"
#EndIf

Namespace My.Sys.ComponentModel
	Enum PrinterOrientation
		#IfNDef __USE_GTK__
			poPortait =DMORIENT_PORTRAIT
			poLandscape=DMORIENT_LANDSCAPE
		#Else
			poPortait
			poLandscape
		#EndIf
	End Enum
	
	Enum PrinterQuality
		#IfNDef __USE_GTK__
			pqDraft=DMRES_DRAFT 
			pqLow =DMRES_LOW
			pqMedium =DMRES_MEDIUM
			pqHigh=DMRES_HIGH
		#Else
			pqDraft
			pqLow
			pqMedium
			pqHigh
		#EndIf
	End Enum
	
	Enum PrinterDuplexMode
		pdmSimplex = 1  
		pdmHorizontal = 2 
		pdmVertical = 3  
	End Enum
	
	Enum PrinterPaperSize
		#IfNDef __USE_GTK__
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
		#Else
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
		#EndIf
	End Enum
	
	Type Printer extends Component
		Private:
		#IfNDef __USE_GTK__
			m_hdc AS HDC               'handle of a display device context 
			m_hFont AS HFONT             'handle of current font
			hOrigFont AS HFONT       'handle of original font
			hDevMode AS DEVMODE Ptr          'handle to DEVMODE structure
		#EndIf
		m_Name As String
		m_PortName As String
		m_Page As Integer
		m_PageSize As Integer
		m_Quality  As Integer 
		m_Copies As Integer
		m_FromPage As Integer
		m_ToPage As Integer
		charHt AS Integer          'character height
		leftMargin AS Integer      'left margin
		rightMargin AS Integer     'right margin
		topMargin AS Integer       'top margin
		bottomMargin AS Integer    'bottom margin
		printerName AS STRING     'name of printer
		origDuplex AS LONG        'original duplex mode
		origOrient AS LONG        'original orientation mode
		As Integer xPos, yPos       'default position for text print
		As Integer FPageNumber=1
		m_duplex As PrinterDuplexMode
		m_colorMode As Long
		FTitle  As String 
		Declare FUNCTION PARSE OverLoad (source as string, delimiter as String="|", index as integer)as String
		Declare FUNCTION PARSE (source as String, index as integer, delimiter as String=",")as String
		Declare Function STRREVERSE (S As String)As String
		DECLARE Sub       orientPrint(n AS LONG) 
		
		DECLARE Function  SetPrinterOrientation2 (BYVAL PrinterName AS String, BYVAL nOrientation AS LONG) AS LONG
		
		Declare FUNCTION SetPrinterOrientation (BYVAL PrinterName AS String, BYVAL nOrientation AS LONG) AS LONG
		Declare FUNCTION GetPrinterOrientation (BYVAL PrinterName AS String) AS Long
		Declare FUNCTION PrinterPaperNames (BYVAL PrinterName AS STRING) AS String
		Declare FUNCTION GetPrinterPaperSizes (BYVAL PrinterName AS STRING) AS String
		Declare FUNCTION SetPrinterPaperSize (BYVAL PrinterName AS String, BYVAL nSize AS LONG) AS Long
		Declare FUNCTION GetPrinterPort (BYVAL PrinterName AS STRING) AS String
		Declare FUNCTION GetPrinterFromPort (BYVAL PortName AS STRING) AS String
		Declare FUNCTION GetPrinterQualityMode (BYVAL PrinterName AS String) AS PrinterQuality
		Declare FUNCTION SetPrinterQuality (BYVAL PrinterName AS String, BYVAL nMode AS PrinterQuality) AS Long
		Declare FUNCTION GetPrinterScale (BYVAL PrinterName AS String) AS Long
		Declare FUNCTION GetPrinterScalingFactorX (BYVAL PrinterName AS String) AS LONG
		Declare FUNCTION GetPrinterScalingFactorY (BYVAL PrinterName AS String) AS Long
		Declare FUNCTION SetPrinterColorMode (BYVAL PrinterName AS String, BYVAL nMode AS LONG) AS Long
		Declare FUNCTION SetPrinterCopies (BYVAL PrinterName AS String, BYVAL nCopies AS LONG) AS LONG
		Declare FUNCTION SetPrinterDuplexMode (BYVAL PrinterName AS String, BYVAL nDuplexMode AS LONG) AS LONG
		Declare Function GetPrinterDuplex (BYVAL PrinterName AS String) AS Long
		
		
		Declare FUNCTION GetPrinterDriverVersion (BYVAL PrinterName AS String) AS Long
		Declare FUNCTION  GetPrinterHorizontalResolution (BYVAL PrinterName AS String) AS Long ' printableWidth
		DECLARE FUNCTION  GetPrinterVerticalResolution (BYVAL PrinterName AS String) AS Long
		Declare FUNCTION  GetPrinterMaxCopies (BYVAL PrinterName AS String) AS Long
		Declare FUNCTION  GetPrinterMaxPaperHeight (BYVAL PrinterName AS String) AS Long
		Declare FUNCTION  GetPrinterMaxPaperWidth (BYVAL PrinterName AS String) AS Long
		Declare FUNCTION  EnumPrinterPorts () AS String
		Declare FUNCTION  EnumPrinters_ () AS String
		' Declare FUNCTION  DefaultPrinter () AS String
		Declare FUNCTION GetDefaultPrinterDevice () AS String
		Declare FUNCTION GetDefaultPrinterDriver () AS String
		Declare Function GetDefaultPrinterPort () AS String
		Declare Sub ShowPrinterProperties()
		Declare   Sub UpdateMargeins()
		Public:
		Canvas As My.Sys.Drawing.Canvas
		DECLARE Sub       reportError( BYVAL n AS LONG) 
		Declare Property  Name(vData As String)
		Declare Property  Name() As String
		Declare Property  PortName(vData As String)
		Declare Property  PortName() As String
		#IfNDef __USE_GTK__
			DECLARE Property  Handle() AS HDC
		#EndIf
		DECLARE Property  PageHeight as  Integer 
		DECLARE Property  PageWidth as  Integer 
		DECLARE Property  MarginLeft as  Integer 
		Declare Property  MarginLeft(value as  Integer)
		Declare  Property MarginTop as  Integer 
		Declare  Property MarginTop(value as  Integer)
		Declare  Property MarginRight as  Integer 
		Declare  Property MarginRight(value as  Integer)
		Declare  Property Marginbottom as  Integer 
		Declare  Property Marginbottom(value As  Integer)
		Declare Property  Page(vData As Integer)
		Declare Property  Page() As Integer
		Declare Property  PageSize(vData As Integer)
		Declare Property  PageSize() As Integer
		Declare Property  printableWidth() AS Long 
		Declare Property  printableHeight() AS Long 
		Declare Property  Orientation(vData As Long)
		Declare Property  Orientation() As Long
		Declare Property  Copies(vData As Integer)
		Declare Property  Copies() As Integer
		Declare Property  Quality(vData As PrinterQuality)
		Declare Property  Quality() As PrinterQuality 
		Declare Property  FromPage(vData As Integer)
		Declare Property  FromPage() As Integer
		Declare Property  ToPage(vData As Integer)
		Declare Property  ToPage() As Integer
		Declare Property Scale () AS Long
		Declare Property ScaleFactorX() AS LONG
		Declare Property ScaleFactorY() AS Long
		Declare Property ColorMode (BYVAL nMode AS LONG)
		Declare Property ColorMode() AS LONG 
		Declare Property DriveVersion() AS Long
		
		Declare Property  MaxCopies() AS Long
		Declare Property  MaxPaperHeight() AS Long
		Declare Property  MaxPaperWidth() AS Long
		Declare Function  defaultPrinter() AS STRING
		Declare Function  choosePrinter() AS STRING
		Declare Sub       getPageSize(ByRef wi AS Integer,ByRef ht AS Integer) 
		Declare Sub       getCharSize(ByRef wi AS Integer,ByRef ht AS Integer) 
		DECLARE Function  getLines( BYVAL y AS Integer=0) AS LONG
		DECLARE Property  duplexMode(n As PrinterDuplexMode)    
		Declare Property  duplexMode() AS PrinterDuplexMode 
		Declare  Property   Title() As String 
		Declare  Property   Title(value As String) 
		Declare Sub       StartDoc() 
		DECLARE Sub       StartPage
		DECLARE Sub       EndDPage
		DECLARE Sub       NewPage
		DECLARE Sub       EndDoc
		Declare Sub       CalcPageSize(byref Rows AS LONG,byref Columns AS LONG) 
		Declare Property FontSize() As Integer
		Declare Property fontsize(As Integer)
		#IfNDef __USE_GTK__
			declare Function newFont(fName AS String="times new Roman", fSize AS Long=12,ibold As Long=FALSE, iunderline As Long=FALSE, iitalic As Long=FALSE ) AS HFONT
		#EndIf
		Declare Constructor()
		'Declare Operator Cast() As TCONTROL Ptr
		'Declare Constructor
	End Type
	
End Namespace

#IfNDef __USE_MAKE__
	#Include Once "Printer.bas"
#EndIf

