'################################################################################
'#  Printer.bas                                                                 #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Aloberoger, Xusinboy Bekchanov                                     #
'#  Based on:                                                                   #
'#   TPrinter.bas                                                               #
'#   GUITK-S Windows GUI FB Wrapper Library                                     #
'#   Copyright (c) Aloberoger                                                   #
'################################################################################

#include once "Printer.bi"

Namespace My.Sys.ComponentModel
	Function  Printer.PARSE(source As String, index As Integer, delimiter As String=",") As String
		Dim As Long i,s,c,l
		s=1
		l=Len(delimiter)
		Do
			If c=index-1 Then
				Function=Mid(source,s,InStr(s,source,delimiter)-s)
				Exit Function
			End If
			i=InStr(s,source,delimiter)
			If i>0 Then
				c+=1
				s=i+l
			End If
		Loop Until i=0
	End Function
	
	
	Function Printer.PARSE (source As String, delimiter As String="|", index As Integer)As String
		Dim As Long i,s,c,l
		s=1
		l=Len(delimiter)
		Do
			If c=index-1 Then
				Function=Mid(source,s,InStr(s,source,delimiter)-s)
				Exit Function
			End If
			i=InStr(s,source,delimiter)
			If i>0 Then
				c+=1
				s=i+l
			End If
		Loop Until i=0
	End Function
	
	Function Printer.STRREVERSE (S As String)As String
		Dim As Integer j=len(s)
		dim rstr As String=Space(j)
		while (j<>0)
			j=j-1
			rstr[j] = s[Len(s)-j-1]
		Wend
		return rstr
	End Function
	
	Sub Printer.reportError(  BYVAL n AS LONG)
		Dim s AS STRING
		IF n = 1 THEN
			s = "Document printing error"
		ELSEIF n = 2 THEN
			s = "Page printing error"
		ELSE
			s = "Unspecified printer error"
		END IF
		#IfNDef __USE_GTK__
			MesSaGeBOX NULL,s, "Printer Error",  MB_ICONERROR
		#EndIf
	END Sub
	
	' ========================================================================================
	' Sets the printer orientation.
	' DMORIENT_PORTRAIT = Portrait
	' DMORIENT_LANDSCAPE = Landscape
	' ========================================================================================
	FUNCTION Printer.SetprinterOrientation (BYVAL PrinterName AS String, BYVAL nOrientation AS LONG) AS Long  __EXPORT__
		#IfNDef __USE_GTK__
			Dim hPrinter AS HWND
			Dim pDevMode AS DEVMODE PTR
			Dim pi2 AS PRINTER_INFO_2 PTR
			Dim pd AS PRINTER_DEFAULTS
			Dim bufferPrn AS STRING
			Dim bufferDoc AS STRING
			Dim dwNeeded AS DWORD
			Dim nRet AS LONG
			
			IF nOrientation <> DMORIENT_PORTRAIT AND nOrientation <> DMORIENT_LANDSCAPE THEN EXIT FUNCTION
			
			' // Start by opening the printer
			pd.DesiredAccess = PRINTER_ALL_ACCESS
			IF OpenPrinter ( PrinterName, @hPrinter, @pd) = 0 THEN EXIT FUNCTION
			
			' // The first GetPrinter tells you how big the buffer should be in
			' // order to hold all of PRINTER_INFO_2. Note that this should fail with
			' // ERROR_INSUFFICIENT_BUFFER.  If GetPrinter fails for any other reason
			' // or dwNeeded isn't set for some reason, then there is a problem...
			nRet = Getprinter (hPrinter, 2, BYVAL NULL, 0, @dwNeeded)
			IF nRet = 0 AND GetLastError <> ERROR_INSUFFICIENT_BUFFER THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			' // Allocate enough space for PRINTER_INFO_2...
			bufferPrn = Space(dwNeeded)
			' // The second GetPrinter fills in all the current settings, so all you
			' // need to do is modify what you're interested in...
			nRet = Getprinter (hPrinter, 2,   STRPTR(bufferPrn), dwNeeded, @dwNeeded)
			IF nRet = 0 THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			
			' // If GetPrinter didn't fill in the DEVMODE, try to get it by calling
			' // DocumentProperties...
			pi2 = Cast(PRINTER_INFO_2 Ptr,StrPtr(bufferPrn))
			IF pi2->pDevMode = NULL THEN
				' // Allocate a buffer of the correct size
				dwNeeded = DocumentProperties (NULL, hPrinter,   PrinterName, BYVAL NULL, BYVAL NULL, 0)
				bufferDoc = Space(dwNeeded)
				pDevMode= GlobalAlloc(GMEM_FIXED,dwNeeded)
				' // Retrieve the printer configuration data
				nRet = DocumentProperties (NULL, hPrinter,   PrinterName,   pDevMode  , BYVAL NULL, DM_OUT_BUFFER)
				IF nRet <> IDOK THEN
					ClosePrinter(hPrinter)
					EXIT FUNCTION
				END IF
				' // Cast it to a DEVMODE structure
				' pDevMode =  StrPtr(bufferDoc)
				pi2->pDevMode = pDevMode
			END IF
			
			' // Driver is reporting that it doesn't support this change...
			IF (pi2->pDevMode->dmFields AND DM_ORIENTATION) = 0 THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			
			' // Specify exactly what we are attempting to change...
			pi2->pDevMode->dmFields = DM_ORIENTATION
			pi2->pDevMode->dmOrientation = nOrientation
			
			' // Do not attempt to set security descriptor...
			pi2->pSecurityDescriptor = NULL
			
			' // Make sure the driver-dependent part of devmode is updated...
			nRet = DocumentProperties (NULL, hPrinter,   PrinterName, _
			BYVAL pi2->pDevMode, BYVAL pi2->pDevMode, _
			DM_IN_BUFFER OR DM_OUT_BUFFER)
			
			IF nRet <> IDOK THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			
			' // Update printer information...
			pi2->pSecurityDescriptor=NULL
			nRet = Setprinter (hPrinter, 2,Cast(LPBYTE, pi2), 0)
			
			IF nRet = 0 THEN
				' // The driver doesn't support, or it is unable to make the change...
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			
			' // Finished with the printer
			ClosePrinter(hPrinter)
			
			IF nRet <> IDOK THEN EXIT FUNCTION
		#EndIf
		FUNCTION  = TRUE
		
	END Function
	' ========================================================================================
	' Sets the printer orientation.
	' DMORIENT_PORTRAIT = Portrait
	' DMORIENT_LANDSCAPE = Landscape
	' ========================================================================================
	FUNCTION printer.SetprinterOrientation2 (BYVAL PrinterName AS String, BYVAL nOrientation AS LONG) AS LONG
		#IfNDef __USE_GTK__
			Dim hPrinter AS HWND
			Dim pDevMode AS DEVMODE PTR
			Dim pi2 AS PRINTER_INFO_2 PTR
			Dim pd AS PRINTER_DEFAULTS
			Dim bufferPrn AS STRING
			Dim bufferDoc AS STRING
			Dim dwNeeded AS DWORD
			Dim nRet AS LONG
			
			IF nOrientation <> DMORIENT_PORTRAIT AND nOrientation <> DMORIENT_LANDSCAPE THEN EXIT FUNCTION
			
			' // Start by opening the printer
			pd.DesiredAccess = PRINTER_ALL_ACCESS
			IF OpenPrinter ( PrinterName, @hPrinter, @pd) = 0 THEN EXIT FUNCTION
			
			' // The first GetPrinter tells you how big the buffer should be in
			' // order to hold all of PRINTER_INFO_2. Note that this should fail with
			' // ERROR_INSUFFICIENT_BUFFER.  If GetPrinter fails for any other reason
			' // or dwNeeded isn't set for some reason, then there is a problem...
			nRet = Getprinter (hPrinter, 2, BYVAL NULL, 0, @dwNeeded)
			IF nRet = 0 AND GetLastError <> ERROR_INSUFFICIENT_BUFFER THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			' // Allocate enough space for PRINTER_INFO_2...
			bufferPrn = Space(dwNeeded)
			' // The second GetPrinter fills in all the current settings, so all you
			' // need to do is modify what you're interested in...
			nRet = Getprinter (hPrinter, 2,   STRPTR(bufferPrn), dwNeeded, @dwNeeded)
			IF nRet = 0 THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			
			' // If GetPrinter didn't fill in the DEVMODE, try to get it by calling
			' // DocumentProperties...
			pi2 = Cast(PRINTER_INFO_2 Ptr,StrPtr(bufferPrn))
			IF pi2->pDevMode = NULL THEN
				' // Allocate a buffer of the correct size
				dwNeeded = DocumentProperties (NULL, hPrinter,   PrinterName, BYVAL NULL, BYVAL NULL, 0)
				bufferDoc = Space(dwNeeded)
				pDevMode= GlobalAlloc(GMEM_FIXED,dwNeeded)
				' // Retrieve the printer configuration data
				nRet = DocumentProperties (NULL, hPrinter,   PrinterName,   pDevMode  , ByVal NULL, DM_OUT_BUFFER)
				If nRet <> IDOK Then
					ClosePrinter(hPrinter)
					Exit Function
				End If
				' // Cast it to a DEVMODE structure
				' pDevMode =  StrPtr(bufferDoc)
				pi2->pDevMode = pDevMode
			End If
			
			' // Driver is reporting that it doesn't support this change...
			If (pi2->pDevMode->dmFields And DM_ORIENTATION) = 0 Then
				ClosePrinter(hPrinter)
				Exit Function
			End If
			
			' // Specify exactly what we are attempting to change...
			pi2->pDevMode->dmFields = DM_ORIENTATION
			pi2->pDevMode->dmOrientation = nOrientation
			
			' // Do not attempt to set security descriptor...
			pi2->pSecurityDescriptor = NULL
			
			' // Make sure the driver-dependent part of devmode is updated...
			nRet = DocumentProperties (NULL, hPrinter,   PrinterName, _
			ByVal pi2->pDevMode, ByVal pi2->pDevMode, _
			DM_IN_BUFFER Or DM_OUT_BUFFER)
			
			If nRet <> IDOK Then
				ClosePrinter(hPrinter)
				Exit Function
			End If
			
			
			' // Finished with the printer
			ClosePrinter(hPrinter)
		#endif
		
		Function  = True
		
	End Function
	' ========================================================================================
	' Returns the printer orientation.
	' The return value can be one of the following:
	' - DMORIENT_PORTRAIT = Portrait
	' - DMORIENT_LANDSCAPE = Landscape
	' ========================================================================================
	Function Printer.GetPrinterOrientation (ByVal PrinterName As String) As Long  __EXPORT__
		#ifndef __USE_GTK__
			Dim hPrinter As HWND
			Dim pDevMode As DEVMODE Ptr
			Dim pi2 As PRINTER_INFO_2 Ptr
			Dim bufferDoc As String
			Dim dwNeeded As DWORD
			Dim nRet As Long
			
			' // Start by opening the printer
			IF OpenPrinter (PrinterName, Cast(LPHANDLE,@hPrinter), BYVAL NULL) = 0 THEN EXIT FUNCTION
			' // Allocate a buffer of the correct size
			dwNeeded = DocumentProperties (NULL, hPrinter,PrinterName, BYVAL NULL, BYVAL NULL, 0)
			bufferDoc = SPACE(dwNeeded)
			' // Retrieve the printer configuration data
			pDevMode= GlobalAlloc(GMEM_FIXED,dwNeeded)
			nRet = DocumentProperties (NULL, hPrinter, PrinterName, pDevMode, BYVAL NULL, DM_OUT_BUFFER)
			IF nRet <> IDOK THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			' // Cast it to a DEVMODE structure
			'pDevMode = STRPTR(bufferDoc)
			' // Return the orientation
			FUNCTION = pDevMode->dmOrientation
			
			' // Finished with the printer
			ClosePrinter(hPrinter)
		#Else
			FUNCTION = 0
		#EndIf
	END Function
	
	Property Printer.Name(vData As String)  __EXPORT__
		m_Name=vData
	End Property
	
	Property Printer.Name As String  __EXPORT__
		Return m_Name
	End Property
	
	
	Property Printer.PortName(vData As String)  __EXPORT__
	End Property
	
	Property Printer.PortName As String  __EXPORT__
		m_PortName=GetprinterPort (PrinterName)
		Return m_PortName
	End Property
	
	
	Property Printer.Page(vData As Integer)  __EXPORT__
		m_Page=vData
	End Property
	
	Property Printer.Page As Integer  __EXPORT__
		Return m_Page
	End Property
	
	
	Property Printer.PageSize(vData As Integer)  __EXPORT__
		m_PageSize=vData
	End Property
	
	Property Printer.PageSize As Integer  __EXPORT__
		Return m_PageSize
	End Property
	
	Property Printer.Copies(vData As Integer)  __EXPORT__
		m_Copies=vData
		SetprinterCopies ( PrinterName ,vData)
	End Property
	
	Property Printer.Copies As Integer  __EXPORT__
		Return m_Copies
	End Property
	
	Property Printer.Quality(vData As PrinterQuality)  __EXPORT__
		m_Quality=vData
		SetprinterQuality (PrinterName, vData)
	End Property
	
	Property Printer.Quality As PrinterQuality  __EXPORT__
		m_Quality=GetprinterQualityMode (PrinterName)
		Return m_Quality
	End Property
	
	Property Printer.FromPage(vData As Integer)  __EXPORT__
		m_FromPage=vData
	End Property
	
	Property Printer.FromPage As Integer  __EXPORT__
		Return m_FromPage
	End Property
	
	
	Property Printer.ToPage(vData As Integer)  __EXPORT__
		m_ToPage=vData
	End Property
	
	Property Printer.ToPage As Integer  __EXPORT__
		Return m_ToPage
	End Property
	
	
	
	
	Property Printer.Scale () As Long  __EXPORT__
		Return GetprinterScale ( PrinterName )
	End Property
	
	Property Printer.ScaleFactorX () AS Long  __EXPORT__
		Return GetprinterScalingFactorX ( PrinterName )
	End Property
	
	Property Printer.ScaleFactorY () AS Long  __EXPORT__
		Return GetprinterScalingFactorY ( PrinterName)
	End Property
	
	Property Printer.ColorMode (BYVAL nMode AS LONG)  __EXPORT__
		SetprinterColorMode (PrinterName ,nMode)
		m_colorMode=nMode
	End Property
	
	Property Printer.ColorMode () AS LONG   __EXPORT__
		Return  m_colorMode
	End Property
	
	Property printer.DriveVersion () AS Long  __EXPORT__
		Return GetprinterDriverVersion ( PrinterName )
	End Property
	
	Property  printer.printableWidth () AS Long  __EXPORT__
		Return GetPrinterHorizontalResolution (PrinterName )
	End Property
	
	
	Property  printer.printableHeight() As Long   __EXPORT__
		Return GetPrinterVerticalResolution (PrinterName)
	End Property
	
	Property  printer.MaxCopies () AS Long  __EXPORT__
		Return GetPrinterMaxCopies (PrinterName)
	End Property
	
	Property  printer.MaxPaperHeight () AS Long   __EXPORT__
		Return GetPrinterMaxPaperHeight (PrinterName )
	End Property
	
	Property  printer.MaxPaperWidth () AS Long  __EXPORT__
		Return GetPrinterMaxPaperWidth (PrinterName )
	End Property
	
	#IfNDef __USE_GTK__
		Property printer.Handle() AS HDC   __EXPORT__
			IF m_hdc  = 0 THEN printerName=This.defaultprinter()
			Return m_hdc
		End Property
	#EndIf
	
	Property printer.PageWidth As  Integer  __EXPORT__
		#IfNDef __USE_GTK__
			IF m_hdc  = 0 THEN printerName=This.defaultprinter
			Return GetDeviceCaps(m_hdc ,PHYSICALWIDTH)
		#Else
			Return 0
		#EndIf
	End Property
	
	Property printer.PageHeight() AS Integer  __EXPORT__
		#IfNDef __USE_GTK__
			Return GetDeviceCaps(m_hdc ,PHYSICALHEIGHT)
		#Else
			Return 0
		#EndIf
	End Property
	
	Property printer.MarginLeft as  Integer   __EXPORT__
		Return leftMargin
	End Property
	
	Property printer.MarginLeft(value as  Integer)  __EXPORT__
		leftMargin =value
	End Property
	
	Property printer.MarginTop as  Integer   __EXPORT__
		Return topMargin
	End Property
	
	Property printer.MarginTop(value as  Integer)  __EXPORT__
		topMargin =value
	End Property
	
	
	Property printer.MarginRight as  Integer   __EXPORT__
		Return rightMargin
	End Property
	
	Property printer.MarginRight(value as  Integer)  __EXPORT__
		rightMargin =value
	End Property
	
	
	Property printer.Marginbottom as  Integer   __EXPORT__
		Return bottomMargin
	End Property
	
	Property printer.Marginbottom(value as  Integer)  __EXPORT__
		bottomMargin =value
	End Property
	
	
	Function printer.defaultprinter() AS String  __EXPORT__    'determine default printer and device context handle
		#IfNDef __USE_GTK__
			Dim hPrinter As HWND, dwNeeded AS Long, n As LONG
			Dim tm AS TEXTMETRIC, sz AS WString*128
			Dim pDevMode AS DEVMODE PTR
			GetProfileString "WINDOWS", "DEVICE", "", sz, 127
			sz = TRIM(PARSE(sz, ",", 1)): printerName = sz
			OpenPrinter(sz, @hPrinter, NULL) 'to obtain hPrinter
			dwNeeded = DocumentProperties(0, hPrinter, sz, NULL, NULL, 0)
			hDevMode = Cast(DEVMODE Ptr,GlobalAlloc( GHND_, dwNeeded))
			pDevMode = GlobalLock(Cast(HGLOBAL,hDevMode))
			DocumentProperties 0, hPrinter, @sz,  pDevMode, NULL,  DM_OUT_BUFFER
			m_hdc = CreateDC("WINSPOOL", sz, NULL, pDevMode)
			
			Canvas.Handle=m_hdc
			
			GlobalUnlock pDevMode
			'canvas.Font.parent=hPrinter
			
			
			GetTextMetrics m_hdc, @tm
			n = tm.tmHeight + tm.tmExternalLeading
			charHt = n
		#EndIf
		Return printerName
	END Function
	
	Function printer.choosePrinter() AS String  __EXPORT__  'choose printer and determine device context handle
		Dim n AS LONG
		#IfNDef __USE_GTK__
			Dim hPrinter As HWND
			Dim pd AS PRINTDLG , pDevNames AS DEVNAMES PTR
			Dim tm AS TEXTMETRIC, psz AS ZString PTR
			pd.lStructSize = SIZEOF(pd)
			pd.Flags =  PD_RETURNDC OR  PD_HIDEPRINTTOFILE Or PD_PRINTSETUP
			pd.Flags = pd.Flags OR  PD_ALLPAGES OR  PD_NOSELECTION OR  PD_NOPAGENUMS
			IF PrintDlg(@pd) THEN 'call print dialog to select printer
				pDevNames = GlobalLock(pd.hDevNames)
				psz =Cast(ZString Ptr,Cast(Byte Ptr, pDevNames) +  pDevNames->wDeviceOffset)
				printerName = *psz
				OpenPrinter(*psz, @hPrinter, NULL)
				m_hdc = pd.hDC
				GlobalUnlock pd.hDevnames
				
			END IF
			
			GetTextMetrics m_hdc , @tm
			n = tm.tmHeight + tm.tmExternalLeading
			charHt = n
			hDevMode = pd.hDevMode
			Canvas.Handle=m_hdc
			'canvas.Font.parent=hPrinter
		#EndIf
		Return printerName
		
	End Function
	
	#IfNDef __USE_GTK__
		Function printer.newFont(fName AS STRING, fSize AS LONG,ibold As Long=FALSE, iunderline As Long=FALSE, iitalic As Long=FALSE ) AS HFONT __EXPORT__
			'define a new font using a font name, font size in points, and font attributes
			'combine attributes: "b" for bold, "u" for underline, "i" for italic
			Dim AS Long yppi, charSize, hn
			Dim n  As HFONT
			Dim wt AS DWORD, nBold AS DWORD, underline AS DWORD, italic AS DWORD, s AS STRING
			Dim tm AS TEXTMETRIC
			IF m_hFont THEN DeleteObject m_hFont
			IF m_hdc  = 0 THEN printerName=This.defaultprinter
			
			nBold = ibold*300
			underline = iunderline
			italic = iitalic
			
			yppi  = GetDeviceCaps(m_hdc ,  LOGPIXELSY)
			charSize = (fSize * yppi) \ 72
			wt =  FW_NORMAL + nBold
			m_hFont = CreateFont(-charSize, 0, 0, 0, wt, italic, underline, 0, _
			ANSI_CHARSET,  OUT_TT_PRECIS,  CLIP_DEFAULT_PRECIS, _
			DEFAULT_QUALITY,  FF_DONTCARE, Cast( LPCTSTR,@fName))
			n = SelectObject(m_hdc , m_hFont)
			IF hOrigFont = 0 THEN hOrigFont = n
			GetTextMetrics m_hdc , @tm
			hn = tm.tmHeight + tm.tmExternalLeading
			charHt = hn
			Return m_hFont
		End Function
	#EndIf
	/'
	FUNCTION printer.getTextWidth(txt AS STRING) AS Integer
	'get the text width in inches
	Dim cSize AS SIZEL
	IF m_hdc  = 0 THEN printerName=This.defaultprinter
	GetTextExtentPoint32 m_hdc , BYVAL STRPTR(txt), LEN(txt), @cSize
	Function = cSize.cx
	END FUNCTION
	
	Function printer.truncate(s AS STRING, BYVAL wi AS Integer) AS STRING
	'truncate the text to a specified width, in inches
	'if wi > 0, truncate the back end, else truncate the front end
	Dim nFit AS LONG, cSize AS SIZEL, ss AS STRING
	IF m_hdc  = 0 THEN printerName=This.defaultprinter
	'wi = GetDeviceCaps(m_hdc ,  LOGPIXELSX) * wi 'width in pixels (logical units)
	IF wi > 0 THEN
	ss = s
	GetTextExtentExPoint m_hdc , StrPtr(ss), LEN(ss), wi, Cast(LPINT,nFit), NULL, @cSize
	Return LEFT(ss, nFit)
	ELSEIF wi < 0 THEN
	wi = ABS(wi): ss = STRREVERSE$(s)
	GetTextExtentExPoint m_hdc , StrPtr(ss), LEN(ss), wi, Cast(LPINT,nFit),NULL, @cSize
	Function =STRREVERSE$(LEFT(ss, nFit))
	END IF
	END Function
	'/
	
	
	
	
	
	Sub printer.getCharSize(ByRef wi AS Integer,ByRef ht AS Integer) __EXPORT__ 'character width and height in inches 'average character width if proportional font
		#IfNDef __USE_GTK__
			Dim tm AS TEXTMETRIC
			IF m_hdc  = 0 THEN printerName=This.defaultprinter
			GetTextMetrics m_hdc , @tm
			wi = tm.tmMaxCharWidth  'tm.tmAveCharWidth
			ht = charHt
		#EndIf
	END Sub
	
	Function printer.getLines(  BYVAL y AS Integer) AS Long  __EXPORT__'determine number of remaining lines from y to bottom margin
		#IfNDef __USE_GTK__
			Dim  AS Long yppi, paperHt, topNoPrn, bottomNoPrn
			Dim yn AS Integer
			IF m_hdc  = 0 THEN printerName=This.defaultprinter
			yppi = GetDeviceCaps(m_hdc ,LOGPIXELSY)
			paperHt = GetDeviceCaps(m_hdc ,PHYSICALHEIGHT)
			topNoPrn = GetDeviceCaps(m_hdc ,PHYSICALOFFSETY)
			bottomNoPrn = paperHt - topNoPrn - GetDeviceCaps(m_hdc ,  VERTRES)
			If topMargin>(topNoPrn  ) Then y = topMargin Else y=topNoPrn
			
			yn = paperHt  - MAX(bottomMargin, bottomNoPrn ) - y
			Function = INT(yn / charHt)
		#Else
			Return 0
		#EndIf
	END Function
	
	Property printer.duplexMode() AS PrinterDuplexMode
		#IfNDef __USE_GTK__
			m_duplex=GetPrinterDuplex (PrinterName)
		#EndIf
		Return m_duplex
	End Property
	
	Property printer.duplexMode(n AS PrinterDuplexMode)   __EXPORT__   'n = 1 Simplex  'n = 2 Horizontal  'n = 3 Vertical
		#IfNDef __USE_GTK__
			Dim pDevMode AS DEVMODE PTR
			IF hDevMode = 0 OR n = 0 THEN Exit Property
			pDevMode = GlobalLock(Cast(HGLOBAL,hDevMode))
			IF origDuplex = 0 THEN origDuplex = pDevMode->dmDuplex
			IF pDevMode->dmFields AND  DM_DUPLEX THEN
				pDevMode->dmDuplex = n
				pDevMode->dmFields = pDevMode->dmFields OR  DM_DUPLEX
				ResetDC m_hdc , pDevMode
				GlobalUnlock Cast(HGLOBAL,hDevMode)
			END IF
		#EndIf
	END Property
	
	Sub printer.orientPrint(n AS LONG)  __EXPORT__ 'n = 1 Portrait 'n = 2 Landscape
		' If SetPrinterOrientation(printername,n)=FALSE Then Print "Error on Orientation"
		' Return
		#IfNDef __USE_GTK__
			DIM lpDevMode AS DEVMODE PTR
			IF hDevMode = 0 THEN EXIT Sub
			lpDevMode = GlobalLock(Cast(HGLOBAL,hDevMode))
			IF origOrient = 0 THEN origOrient = lpDevMode->dmOrientation
			IF n AND  lpDevMode->dmFields AND DM_ORIENTATION  THEN
				IF n THEN lpDevMode->dmOrientation = n
				lpDevMode->dmFields = lpDevMode->dmFields OR  DM_ORIENTATION
				ResetDC m_hdc , lpDevMode
				GlobalUnlock Cast(HGLOBAL,hDevMode)
			END IF
		#EndIf
	END Sub
	
	Property printer.Orientation(value As Long)  __EXPORT__
		SetPrinterOrientation2(printername,value) ' orientPrint(value)
	End Property
	
	Property printer.Orientation() As Long   __EXPORT__
		Return GetPrinterOrientation(printername)
	End Property
	
	
	
	
	
	
	Sub printer.UpdateMargeins()  __EXPORT__
		'x, y are measured from the left and top edges of the paper
		'if x or y are omitted then last valuew, xLast, yLast are used
		Dim AS Long xc, yc, xm, leftNoPrn, rightNoPrn, topNoPrn, bottomNoPrn
		Dim AS Long paperWi, paperHt, xMax, yMax, xppi, yppi
		#IfNDef __USE_GTK__
			IF m_hdc  = 0 THEN printerName=This.defaultprinter
			paperWi = GetDeviceCaps(m_hdc ,  PHYSICALWIDTH)
			paperHt = GetDeviceCaps(m_hdc ,  PHYSICALHEIGHT)
			leftNoPrn = GetDeviceCaps(m_hdc ,  PHYSICALOFFSETX)
			rightNoPrn = paperWi - leftNoPrn - GetDeviceCaps(m_hdc ,HORZRES)
			topNoPrn = GetDeviceCaps(m_hdc ,  PHYSICALOFFSETY)
			bottomNoPrn = paperHt - topNoPrn - GetDeviceCaps(m_hdc ,VERTRES)
			xppi = GetDeviceCaps(m_hdc ,  LOGPIXELSX): yppi = GetDeviceCaps(m_hdc ,LOGPIXELSY)
			xMax = paperWi - leftNoPrn -  rightMargin
			yMax = paperHt - topNoPrn -   bottomMargin
			
			leftMargin= max(leftMargin,leftNoPrn)
			topMargin =  max(topNoPrn,topMargin)
		#EndIf
	End Sub
	
	Property printer.Title( value As String)  __EXPORT__
		Ftitle=value
	End Property
	
	Property printer.Title() As String   __EXPORT__
		Return Ftitle
	End Property
	
	Sub printer.StartDoc()  __EXPORT__
		#IfNDef __USE_GTK__
			Dim nErr AS LONG, sz AS WSTRING*64
			Dim di AS DOCINFO
			IF m_hdc  = 0 THEN printerName=This.defaultprinter
			sz = Ftitle
			di.cbSize = SIZEOF(DOCINFO)
			di.lpszDocName = VARPTR(sz)
			nErr = .StartDoc(m_hdc , @di)
			IF nErr <= 0 THEN This.reportError(1)
		#EndIf
	END Sub
	
	Sub printer.StartPage  __EXPORT__
		#IfNDef __USE_GTK__
			DIM nErr AS LONG
			nErr = .StartPage(m_hdc )
			IF nErr <= 0 THEN This.reportError(2)
		#EndIf
	END Sub
	
	Sub printer.EndDPage __EXPORT__
		#IfNDef __USE_GTK__
			.EndPage(m_hdc )
		#EndIf
	END Sub
	
	Sub printer.NewPage   __EXPORT__
		#IfNDef __USE_GTK__
			.EndPage(m_hdc )
			.StartPage(m_hdc)
			FPageNumber+=1
		#EndIf
	End Sub
	
	Sub printer.EndDoc   __EXPORT__
		#IfNDef __USE_GTK__
			.EndDoc(m_hdc )
			SelectObject m_hdc , hOrigFont
			DeleteObject m_hFont
			deleteDC m_hdc
			origDuplex = 0
			origOrient = 0
			hOrigFont = 0
		#EndIf
	END Sub
	
	
	'------------------------------------------------------------------------------
	' Calculate the text resolution based on the default font for the Device
	' Context. Works with both window and printer DC's. Requires %MM_TEXT mode.
	'
	Sub printer.CalcPageSize(byref Rows AS LONG,byref Columns AS LONG)    __EXPORT__
		#IfNDef __USE_GTK__
			DIM tm As TEXTMETRIC
			GetTextMetrics m_hdc, @tm
			Rows    = GetDeviceCaps(m_hdc, VERTRES) \ (tm.tmHeight + tm.tmExternalLeading)
			Columns = GetDeviceCaps(m_hdc, HORZRES) \ tm.tmAveCharWidth
		#EndIf
	End SUB
	
	FUNCTION printer.PrinterPaperNames (BYVAL PrinterName AS STRING) AS String  __EXPORT__
		Dim Names AS String
		#IfNDef __USE_GTK__
			Dim i AS LONG
			Dim r AS LONG
			r = DeviceCapabilities (PrinterName, BYVAL NULL, DC_PAPERNAMES, BYVAL NULL, BYVAL NULL)
			IF r = -1 THEN EXIT FUNCTION
			REDIM wszNames(r - 1) AS WString * 64
			r = DeviceCapabilities (PrinterName, BYVAL NULL, DC_PAPERNAMES, @wszNames(0), BYVAL NULL)
			IF r < 1 THEN EXIT FUNCTION
			FOR i = 0 TO r - 1
				Names += wszNames(i)
				IF i < r - 1 THEN Names += ";"
			NEXT
		#EndIf
		FUNCTION = Names
	END Function
	
	
	
	' ========================================================================================
	' Returns a list of each supported paper sizes, in tenths of a millimeter.
	' Each entry if formated as "<width> x <height>" and separated by a carriage return and a
	' line feed characters.
	' ========================================================================================
	FUNCTION printer.GetPrinterPaperSizes (BYVAL PrinterName AS STRING) AS String  __EXPORT__
		Dim i AS Long, r AS LONG, Sizes AS String
		#IfNDef __USE_GTK__
			r = DeviceCapabilities (PrinterName, BYVAL NULL, DC_PAPERSIZE, BYVAL NULL, BYVAL NULL)
			IF r = -1 THEN EXIT FUNCTION
			REDIM pSizes(r - 1) AS POINT
			r = DeviceCapabilities (PrinterName, BYVAL NULL, DC_PAPERSIZE, Cast( LPTSTR,@pSizes(0)), BYVAL NULL)
			IF r < 1 THEN EXIT FUNCTION
			FOR i = 0 TO r - 1
				Sizes += WStr(pSizes(i).x) & " x " & WStr(pSizes(i).y)
				IF i < r - 1 THEN Sizes += CRLF
			NEXT
		#EndIf
		FUNCTION = Sizes
	END Function
	
	
	
	FUNCTION printer.GetPrinterPort (BYVAL PrinterName AS STRING) AS String   __EXPORT__ ' Returns the port name for a given printer name.
		Dim i AS Long, Level AS Long, cbNeeded AS Long, cbReturned AS LONG
		#IfNDef __USE_GTK__
			DIM   Pi5( ) As PRINTER_INFO_5
			Level = 5
			EnumPrinters  PRINTER_ENUM_LOCAL, BYVAL NULL, Level, BYVAL NULL, 0, @cbNeeded, @cbReturned
			REDIM Pi5(0 TO cbNeeded \ SIZEOF(Pi5(0)))
			EnumPrinters  PRINTER_ENUM_LOCAL, "", Level, Cast( LPBYTE,@Pi5(0)), _
			SIZEOF(Pi5(0)) * (UBOUND(Pi5) + 1), @cbNeeded, @cbReturned
			FOR i = 0 TO cbReturned - 1
				IF UCASE(*Pi5(i).pPrinterName) = UCase(PrinterName) THEN
					FUNCTION = *Pi5(i).pPortName
					EXIT FOR
				END IF
			NEXT
		#Else
			Return ""
		#EndIf
	END Function
	
	
	
	' ========================================================================================
	' Returns the printer print quality mode.
	' The return value can be one of the following:
	' - DMRES_DRAFT  = Draft
	' - DMRES_LOW    = Low
	' - DMRES_MEDIUM = Medium
	' - DMRES_HIGH   = High
	' ========================================================================================
	FUNCTION printer.GetPrinterQualityMode (BYVAL PrinterName AS String) AS PrinterQuality  __EXPORT__
		#IfNDef __USE_GTK__
			Dim hPrinter AS HWND
			Dim pDevMode AS DEVMODE PTR
			Dim pi2 AS PRINTER_INFO_2 PTR
			Dim bufferDoc AS STRING
			Dim dwNeeded AS DWORD
			Dim nRet AS LONG
			
			' // Start by opening the printer
			IF OpenPrinter (  PrinterName, @hPrinter, BYVAL NULL) = 0 THEN EXIT FUNCTION
			' // Allocate a buffer of the correct size
			dwNeeded = DocumentProperties (NULL, hPrinter,   PrinterName, BYVAL NULL, BYVAL NULL, 0)
			bufferDoc = Space(dwNeeded)
			pDevMode= GlobalAlloc(GMEM_FIXED,dwNeeded)
			' // Retrieve the printer configuration data
			nRet = DocumentProperties (NULL, hPrinter,   PrinterName,pDevMode, BYVAL NULL, DM_OUT_BUFFER)
			IF nRet <> IDOK THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			' // Cast it to a DEVMODE structure
			' pDevMode = STRPTR(bufferDoc)
			' // Return the orientation
			FUNCTION = pDevMode->dmPrintQuality
			
			' // Finished with the printer
			ClosePrinter(hPrinter)
		#Else
			Return 0
		#EndIf
	END FUNCTION
	' ========================================================================================
	
	' ========================================================================================
	' Specifies the factor by which the printed output is to be scaled. The apparent page size
	' is scaled from the physical page size by a factor of dmScale /100. For example, a
	' letter-sized page with a dmScale value of 50 would contain as much data as a page of
	' 17- by 22-inches because the output text and graphics would be half their original
	' height and width.
	' ========================================================================================
	FUNCTION printer.GetPrinterScale (BYVAL PrinterName AS String) AS Long  __EXPORT__
		#IfNDef __USE_GTK__
			Dim hPrinter AS HWND
			Dim pDevMode AS DEVMODE PTR
			Dim pi2 AS PRINTER_INFO_2 PTR
			Dim bufferDoc AS STRING
			Dim dwNeeded AS DWORD
			Dim nRet AS LONG
			
			' // Start by opening the printer
			IF OpenPrinter (  PrinterName, @hPrinter, BYVAL NULL) = 0 THEN EXIT FUNCTION
			' // Allocate a buffer of the correct size
			dwNeeded = DocumentProperties (NULL, hPrinter,   PrinterName, BYVAL NULL, BYVAL NULL, 0)
			bufferDoc = Space(dwNeeded)
			' // Retrieve the printer configuration data
			pDevMode= GlobalAlloc(GMEM_FIXED,dwNeeded)
			nRet = DocumentProperties (NULL, hPrinter,   PrinterName, pDevMode, BYVAL NULL, DM_OUT_BUFFER)
			IF nRet <> IDOK THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			' // Cast it to a DEVMODE structure
			'pDevMode = STRPTR(bufferDoc)
			' // Return the number of copies
			FUNCTION = pDevMode->dmScale
			
			' // Finished with the printer
			ClosePrinter(hPrinter)
		#Else
			Return 0
		#EndIf
	END FUNCTION
	
	FUNCTION printer.GetPrinterScalingFactorX (BYVAL PrinterName AS String) AS Long  ' Scaling factor for the x-axis of the printer.
		Dim nResult AS LONG
		#IfNDef __USE_GTK__
			Dim hdc AS HDC
			hdc = CreateIC (NULL,PrinterName, BYVAL NULL, BYVAL NULL)
			IF hdc = 0 THEN EXIT FUNCTION
			nResult = GetDeviceCaps(hdc, SCALINGFACTORX)
			DeleteDC hdc
		#EndIf
		FUNCTION = nResult
	END FUNCTION
	
	
	
	FUNCTION printer.GetPrinterScalingFactorY (BYVAL PrinterName AS String) AS Long ' Scaling factor for the y-axis of the printer.
		Dim nResult AS LONG
		#IfNDef __USE_GTK__
			Dim hdc AS HDC
			hdc = CreateIC (ByVal NULL,   PrinterName, BYVAL NULL, BYVAL NULL)
			IF hdc = 0 THEN EXIT FUNCTION
			nResult = GetDeviceCaps(hdc, SCALINGFACTORY)
			DeleteDC hdc
		#EndIf
		FUNCTION = nResult
	END Function
	
	
	' ========================================================================================
	' Switches between color and monochrome on color printers.
	' The following are the possible values:
	'   DMCOLOR_COLOR
	'   DMCOLOR_MONOCHROME
	' ========================================================================================
	FUNCTION printer.SetPrinterColorMode (BYVAL PrinterName AS String, BYVAL nMode AS LONG) AS Long  __EXPORT__
		#IfNDef __USE_GTK__
			Dim hPrinter AS HWND
			Dim pDevMode AS DEVMODE PTR
			Dim pi2 AS PRINTER_INFO_2 PTR
			Dim pd AS PRINTER_DEFAULTS
			Dim bufferPrn AS STRING
			Dim bufferDoc AS STRING
			Dim dwNeeded AS DWORD
			Dim nRet AS LONG
			
			' // Start by opening the printer
			pd.DesiredAccess = PRINTER_ALL_ACCESS
			IF OpenPrinter (  PrinterName, @hPrinter, @pd) = 0 THEN EXIT FUNCTION
			
			' // The first GetPrinter tells you how big the buffer should be in
			' // order to hold all of PRINTER_INFO_2. Note that this should fail with
			' // ERROR_INSUFFICIENT_BUFFER.  If GetPrinter fails for any other reason
			' // or dwNeeded isn't set for some reason, then there is a problem...
			nRet = GetPrinter (hPrinter, 2, BYVAL NULL, 0, @dwNeeded)
			IF nRet = 0 AND GetLastError <> ERROR_INSUFFICIENT_BUFFER THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			' // Allocate enough space for PRINTER_INFO_2...
			bufferPrn = Space(dwNeeded)
			' // The second GetPrinter fills in all the current settings, so all you
			' // need to do is modify what you're interested in...
			nRet = GetPrinter (hPrinter, 2, BYVAL STRPTR(bufferPrn),  dwNeeded, @dwNeeded)
			IF nRet = 0 THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			
			' // If GetPrinter didn't fill in the DEVMODE, try to get it by calling
			' // DocumentProperties...
			pi2 = Cast(PRINTER_INFO_2 Ptr,StrPtr(bufferPrn))
			IF pi2->pDevMode = NULL THEN
				' // Allocate a buffer of the correct size
				dwNeeded = DocumentProperties (NULL, hPrinter,   PrinterName, BYVAL NULL, BYVAL NULL, 0)
				bufferDoc = Space(dwNeeded)
				pDevMode= GlobalAlloc(GMEM_FIXED,dwNeeded)
				' // Retrieve the printer configuration data
				nRet = DocumentProperties (NULL, hPrinter,   PrinterName, pDevMode, BYVAL NULL, DM_OUT_BUFFER)
				IF nRet <> IDOK THEN
					ClosePrinter(hPrinter)
					EXIT FUNCTION
				END IF
				' // Cast it to a DEVMODE structure
				'pDevMode = STRPTR(bufferDoc)
				pi2->pDevMode = pDevMode
			END IF
			
			' // Specify exactly what we are attempting to change...
			pi2->pDevMode->dmColor = nMode
			
			' // Do not attempt to set security descriptor...
			pi2->pSecurityDescriptor = NULL
			
			' // Make sure the driver-dependent part of devmode is updated...
			nRet = DocumentProperties (NULL, hPrinter,   PrinterName, _
			BYVAL pi2->pDevMode, BYVAL pi2->pDevMode, _
			DM_IN_BUFFER OR DM_OUT_BUFFER)
			IF nRet <> IDOK THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			
			' // Update printer information...
			nRet = SetPrinter (hPrinter, 2, Cast( LPBYTE,pi2), 0)
			IF nRet = 0 THEN
				' // The driver doesn't support, or it is unable to make the change...
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			
			' // Finished with the printer
			ClosePrinter(hPrinter)
			
			IF nRet <> IDOK THEN EXIT FUNCTION
		#EndIf
		FUNCTION  = TRUE
		
	END FUNCTION
	
	' ========================================================================================
	' Selects the number of copies printed if the device supports multiple-page copies.
	' ========================================================================================
	FUNCTION printer.SetPrinterCopies (BYVAL PrinterName AS String, BYVAL nCopies AS LONG) AS LONG __EXPORT__
		#IfNDef __USE_GTK__
			Dim hPrinter AS HWND
			Dim pDevMode AS DEVMODE PTR
			Dim pi2 AS PRINTER_INFO_2 PTR
			Dim pd AS PRINTER_DEFAULTS
			Dim bufferPrn AS STRING
			Dim bufferDoc AS STRING
			Dim dwNeeded AS DWORD
			Dim nRet AS LONG
			
			' // Start by opening the printer
			pd.DesiredAccess = PRINTER_ALL_ACCESS
			IF OpenPrinter (  PrinterName, @hPrinter, @pd) = 0 THEN EXIT FUNCTION
			
			' // The first GetPrinter tells you how big the buffer should be in
			' // order to hold all of PRINTER_INFO_2. Note that this should fail with
			' // ERROR_INSUFFICIENT_BUFFER.  If GetPrinter fails for any other reason
			' // or dwNeeded isn't set for some reason, then there is a problem...
			nRet = GetPrinter (hPrinter, 2, BYVAL NULL, 0, @dwNeeded)
			IF nRet = 0 AND GetLastError <> ERROR_INSUFFICIENT_BUFFER THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			' // Allocate enough space for PRINTER_INFO_2...
			bufferPrn = Space(dwNeeded)
			' // The second GetPrinter fills in all the current settings, so all you
			' // need to do is modify what you're interested in...
			nRet = GetPrinter (hPrinter, 2, BYVAL STRPTR(bufferPrn), dwNeeded, @dwNeeded)
			IF nRet = 0 THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			
			' // If GetPrinter didn't fill in the DEVMODE, try to get it by calling
			' // DocumentProperties...
			pi2 = Cast(PRINTER_INFO_2 Ptr,StrPtr(bufferPrn))
			IF pi2->pDevMode = NULL THEN
				' // Allocate a buffer of the correct size
				dwNeeded = DocumentProperties (NULL, hPrinter,PrinterName, BYVAL NULL, BYVAL NULL, 0)
				bufferDoc = Space(dwNeeded)
				pDevMode= GlobalAlloc(GMEM_FIXED,dwNeeded)
				' // Retrieve the printer configuration data
				nRet = DocumentProperties (NULL, hPrinter,PrinterName, pDevMode, BYVAL NULL, DM_OUT_BUFFER)
				IF nRet <> IDOK THEN
					ClosePrinter(hPrinter)
					EXIT FUNCTION
				END IF
				' // Cast it to a DEVMODE structure
				' pDevMode = STRPTR(bufferDoc)
				pi2->pDevMode = pDevMode
			END IF
			
			' // Specify exactly what we are attempting to change...
			pi2->pDevMode->dmCopies = nCopies
			
			' // Do not attempt to set security descriptor...
			pi2->pSecurityDescriptor = NULL
			
			' // Make sure the driver-dependent part of devmode is updated...
			nRet = DocumentProperties (NULL, hPrinter,   PrinterName, _
			BYVAL pi2->pDevMode, BYVAL pi2->pDevMode, _
			DM_IN_BUFFER OR DM_OUT_BUFFER)
			IF nRet <> IDOK THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			
			' // Update printer information...
			nRet = SetPrinter (hPrinter, 2, cast(LPBYTE,pi2), 0)
			IF nRet = 0 THEN
				' // The driver doesn't support, or it is unable to make the change...
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			
			' // Finished with the printer
			ClosePrinter(hPrinter)
			
			IF nRet <> IDOK THEN EXIT FUNCTION
		#EndIf
		FUNCTION  = TRUE
		
	END FUNCTION
	
	' ========================================================================================
	' Sets the printer duplex mode
	' DMDUP_SIMPLEX = Single sided printing
	' DMDUP_VERTICAL = Page flipped on the vertical edge
	' DMDUP_HORIZONTAL = Page flipped on the horizontal edge
	' ========================================================================================
	FUNCTION printer.SetPrinterDuplexMode (BYVAL PrinterName AS String, BYVAL nDuplexMode AS LONG) AS Long  __EXPORT__
		#IfNDef __USE_GTK__
			Dim hPrinter AS HWND
			Dim pDevMode AS DEVMODE PTR
			Dim pi2 AS PRINTER_INFO_2 PTR
			Dim pd AS PRINTER_DEFAULTS
			Dim bufferPrn AS STRING
			Dim bufferDoc AS STRING
			Dim dwNeeded AS DWORD
			Dim nRet AS LONG
			
			IF nDuplexMode <> DMDUP_SIMPLEX AND nDuplexMode <> DMDUP_VERTICAL AND nDuplexMode <> DMDUP_HORIZONTAL  THEN EXIT FUNCTION
			
			' // Start by opening the printer
			pd.DesiredAccess = PRINTER_ALL_ACCESS
			IF OpenPrinter (  PrinterName, @hPrinter, @pd) = 0 THEN EXIT FUNCTION
			
			' // The first GetPrinter tells you how big the buffer should be in
			' // order to hold all of PRINTER_INFO_2. Note that this should fail with
			' // ERROR_INSUFFICIENT_BUFFER.  If GetPrinter fails for any other reason
			' // or dwNeeded isn't set for some reason, then there is a problem...
			nRet = GetPrinter (hPrinter, 2, BYVAL NULL, 0, @dwNeeded)
			IF nRet = 0 AND GetLastError <> ERROR_INSUFFICIENT_BUFFER THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			' // Allocate enough space for PRINTER_INFO_2...
			bufferPrn = Space(dwNeeded)
			' // The second GetPrinter fills in all the current settings, so all you
			' // need to do is modify what you're interested in...
			nRet = GetPrinter (hPrinter, 2, BYVAL STRPTR(bufferPrn), dwNeeded, @dwNeeded)
			IF nRet = 0 THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			
			' // If GetPrinter didn't fill in the DEVMODE, try to get it by calling
			' // DocumentProperties...
			pi2 = Cast(PRINTER_INFO_2 Ptr,StrPtr(bufferPrn))
			IF pi2->pDevMode = NULL THEN
				' // Allocate a buffer of the correct size
				dwNeeded = DocumentProperties (NULL, hPrinter,PrinterName, BYVAL NULL, BYVAL NULL, 0)
				bufferDoc = Space(dwNeeded)
				pDevMode= GlobalAlloc(GMEM_FIXED,dwNeeded)
				' // Retrieve the printer configuration data
				nRet = DocumentProperties (NULL, hPrinter,PrinterName,  pDevMode, BYVAL NULL, DM_OUT_BUFFER)
				IF nRet <> IDOK THEN
					ClosePrinter(hPrinter)
					EXIT FUNCTION
				END IF
				' // Cast it to a DEVMODE structure
				'  pDevMode = STRPTR(bufferDoc)
				pi2->pDevMode = pDevMode
			END IF
			
			' // Driver is reporting that it doesn't support this change...
			IF (pi2->pDevMode->dmFields AND DM_DUPLEX) = 0 THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			
			' // Specify exactly what we are attempting to change...
			pi2->pDevMode->dmDuplex = nDuplexMode
			
			' // Do not attempt to set security descriptor...
			pi2->pSecurityDescriptor = NULL
			
			' // Make sure the driver-dependent part of devmode is updated...
			nRet = DocumentProperties (NULL, hPrinter,   PrinterName, _
			BYVAL pi2->pDevMode, BYVAL pi2->pDevMode, _
			DM_IN_BUFFER OR DM_OUT_BUFFER)
			IF nRet <> IDOK THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			
			' // Update printer information...
			nRet = SetPrinter (hPrinter, 2, cast(LPBYTE,pi2), 0)
			IF nRet = 0 THEN
				' // The driver doesn't support, or it is unable to make the change...
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			
			' // Finished with the printer
			ClosePrinter(hPrinter)
			
			IF nRet <> IDOK THEN EXIT FUNCTION
		#EndIf
		FUNCTION  = TRUE
		
	END Function
	
	
	
	FUNCTION printer.SetPrinterPaperSize (BYVAL PrinterName AS String, BYVAL nSize AS LONG) AS Long  __EXPORT__' Sets the printer paper size.
		#IfNDef __USE_GTK__
			Dim hPrinter AS HWND
			Dim pDevMode AS DEVMODE PTR
			Dim pi2 AS PRINTER_INFO_2 PTR
			Dim pd AS PRINTER_DEFAULTS
			Dim bufferPrn AS STRING
			Dim bufferDoc AS STRING
			Dim dwNeeded AS DWORD
			Dim nRet AS LONG
			
			' // Start by opening the printer
			pd.DesiredAccess = PRINTER_ALL_ACCESS
			IF OpenPrinter (  PrinterName, @hPrinter, @pd) = 0 THEN EXIT FUNCTION
			
			' // The first GetPrinter tells you how big the buffer should be in
			' // order to hold all of PRINTER_INFO_2. Note that this should fail with
			' // ERROR_INSUFFICIENT_BUFFER.  If GetPrinter fails for any other reason
			' // or dwNeeded isn't set for some reason, then there is a problem...
			nRet = GetPrinter (hPrinter, 2, BYVAL NULL, 0, @dwNeeded)
			IF nRet = 0 AND GetLastError <> ERROR_INSUFFICIENT_BUFFER THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			' // Allocate enough space for PRINTER_INFO_2...
			bufferPrn = Space(dwNeeded)
			' // The second GetPrinter fills in all the current settings, so all you
			' // need to do is modify what you're interested in...
			nRet = GetPrinter (hPrinter, 2, BYVAL STRPTR(bufferPrn),  dwNeeded, @dwNeeded)
			IF nRet = 0 THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			
			' // If GetPrinter didn't fill in the DEVMODE, try to get it by calling
			' // DocumentProperties...
			pi2 = Cast(PRINTER_INFO_2 Ptr,StrPtr(bufferPrn))
			IF pi2->pDevMode = NULL THEN
				' // Allocate a buffer of the correct size
				dwNeeded = DocumentProperties (NULL, hPrinter,   PrinterName, BYVAL NULL, BYVAL NULL, 0)
				bufferDoc = Space(dwNeeded)
				pDevMode= GlobalAlloc(GMEM_FIXED,dwNeeded)
				' // Retrieve the printer configuration data
				nRet = DocumentProperties (NULL, hPrinter,   PrinterName,  pDevMode, BYVAL NULL, DM_OUT_BUFFER)
				IF nRet <> IDOK THEN
					ClosePrinter(hPrinter)
					EXIT FUNCTION
				END IF
				' // Cast it to a DEVMODE structure
				' pDevMode = STRPTR(bufferDoc)
				pi2->pDevMode = pDevMode
			END IF
			
			' // Specify exactly what we are attempting to change...
			pi2->pDevMode->dmPaperSize = nSize
			
			' // Do not attempt to set security descriptor...
			pi2->pSecurityDescriptor = NULL
			
			' // Make sure the driver-dependent part of devmode is updated...
			nRet = DocumentProperties (NULL, hPrinter,   PrinterName, _
			BYVAL pi2->pDevMode, BYVAL pi2->pDevMode, _
			DM_IN_BUFFER OR DM_OUT_BUFFER)
			IF nRet <> IDOK THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			
			' // Update printer information...
			nRet = SetPrinter (hPrinter, 2, cast(LPBYTE,pi2), 0)
			IF nRet = 0 THEN
				' // The driver doesn't support, or it is unable to make the change...
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			
			' // Finished with the printer
			ClosePrinter(hPrinter)
			
			IF nRet <> IDOK THEN EXIT FUNCTION
		#EndIf
		FUNCTION  = TRUE
		
	END FUNCTION
	
	FUNCTION printer.SetPrinterQuality (BYVAL PrinterName AS String, BYVAL nMode AS PrinterQuality) AS Long   __EXPORT__ ' Specifies the printer resolution.
		#IfNDef __USE_GTK__
			Dim hPrinter AS HWND
			Dim pDevMode AS DEVMODE PTR
			Dim pi2 AS PRINTER_INFO_2 PTR
			Dim pd AS PRINTER_DEFAULTS
			Dim bufferPrn AS STRING
			Dim bufferDoc AS STRING
			Dim dwNeeded AS DWORD
			Dim nRet AS LONG
			
			' // Start by opening the printer
			pd.DesiredAccess = PRINTER_ALL_ACCESS
			IF OpenPrinter (  PrinterName, @hPrinter, @pd) = 0 THEN EXIT FUNCTION
			
			' // The first GetPrinter tells you how big the buffer should be in
			' // order to hold all of PRINTER_INFO_2. Note that this should fail with
			' // ERROR_INSUFFICIENT_BUFFER.  If GetPrinter fails for any other reason
			' // or dwNeeded isn't set for some reason, then there is a problem...
			nRet = GetPrinter (hPrinter, 2, BYVAL NULL, 0, @dwNeeded)
			IF nRet = 0 AND GetLastError <> ERROR_INSUFFICIENT_BUFFER THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			' // Allocate enough space for PRINTER_INFO_2...
			bufferPrn = Space(dwNeeded)
			' // The second GetPrinter fills in all the current settings, so all you
			' // need to do is modify what you're interested in...
			nRet = GetPrinter (hPrinter, 2, BYVAL STRPTR(bufferPrn),  dwNeeded, @dwNeeded)
			IF nRet = 0 THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			
			' // If GetPrinter didn't fill in the DEVMODE, try to get it by calling
			' // DocumentProperties...
			pi2 = Cast(PRINTER_INFO_2 Ptr,StrPtr(bufferPrn))
			IF pi2->pDevMode = NULL THEN
				' // Allocate a buffer of the correct size
				dwNeeded = DocumentProperties (NULL, hPrinter,   PrinterName, BYVAL NULL, BYVAL NULL, 0)
				bufferDoc = SPACE(dwNeeded)
				pDevMode= GlobalAlloc(GMEM_FIXED,dwNeeded)
				' // Retrieve the printer configuration data
				nRet = DocumentProperties (NULL, hPrinter,   PrinterName,  pDevMode, BYVAL NULL, DM_OUT_BUFFER)
				IF nRet <> IDOK THEN
					ClosePrinter(hPrinter)
					EXIT FUNCTION
				END IF
				' // Cast it to a DEVMODE structure
				' pDevMode = STRPTR(bufferDoc)
				pi2->pDevMode = pDevMode
			END IF
			
			' // Specify exactly what we are attempting to change...
			pi2->pDevMode->dmPrintQuality = nMode
			
			' // Do not attempt to set security descriptor...
			pi2->pSecurityDescriptor = NULL
			
			' // Make sure the driver-dependent part of devmode is updated...
			nRet = DocumentProperties (NULL, hPrinter,   PrinterName, _
			BYVAL pi2->pDevMode, BYVAL pi2->pDevMode, _
			DM_IN_BUFFER OR DM_OUT_BUFFER)
			IF nRet <> IDOK THEN
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			
			' // Update printer information...
			nRet = SetPrinter (hPrinter, 2, cast(LPBYTE,pi2), 0)
			If nRet = 0 THEN
				' // The driver doesn't support, or it is unable to make the change...
				ClosePrinter(hPrinter)
				EXIT FUNCTION
			END IF
			
			' // Finished with the printer
			ClosePrinter(hPrinter)
			
			IF nRet <> IDOK THEN EXIT FUNCTION
		#EndIf
		FUNCTION  = TRUE
		
	END Function
	
	
	FUNCTION printer.GetPrinterDriverVersion (BYVAL PrinterName AS String) AS Long  __EXPORT__  ' Returns the version number of the printer driver.
		#IfNDef __USE_GTK__
			FUNCTION = DeviceCapabilities (PrinterName, BYVAL NULL, DC_DRIVER, BYVAL NULL, BYVAL NULL)
		#Else
			Function = 0
		#EndIf
	END FUNCTION
	
	FUNCTION printer.GetPrinterDuplex (BYVAL PrinterName AS String) AS Long   __EXPORT__  ' If the printer supports duplex printing, the return value is 1; otherwise, the return value is zero.
		#IfNDef __USE_GTK__
			FUNCTION = DeviceCapabilities (PrinterName, BYVAL NULL, DC_DUPLEX, BYVAL NULL, BYVAL NULL)
		#Else
			Function = 0
		#EndIf
	END FUNCTION
	
	
	FUNCTION printer.GetPrinterFromPort (BYVAL sPortName AS STRING) AS String   __EXPORT__' Returns the printer name for a given port name.
		Dim i AS Long, Level AS Long, cbNeeded AS Long, cbReturned AS LONG, Names AS String
		#IfNDef __USE_GTK__
			DIM   Pi5() As PRINTER_INFO_5
			Level = 5
			EnumPrinters  PRINTER_ENUM_LOCAL, BYVAL NULL, Level, BYVAL NULL, 0, @cbNeeded, @cbReturned
			REDIM Pi5(0 TO cbNeeded \ SIZEOF(Pi5(0)))
			EnumPrinters  PRINTER_ENUM_LOCAL, "", Level, Cast( LPBYTE,@Pi5(0)), _
			SIZEOF(Pi5(0)) * (UBOUND(Pi5) + 1), @cbNeeded, @cbReturned
			FOR i = 0 TO cbReturned - 1
				IF UCASE(*Pi5(i).pPortName) = UCASE(sPortName) THEN
					Names += *Pi5(i).pPrinterName & CRLF
				END IF
			NEXT
			' // Remove the last $CRLF
			IF LEN(Names) THEN Names = LEFT(Names, LEN(Names) - 2)
		#EndIf
		FUNCTION = Names
	END FUNCTION
	
	
	FUNCTION printer.GetPrinterHorizontalResolution (BYVAL PrinterName AS String) AS Long  __EXPORT__' Width, in pixels, of the printable area of the page.
		Dim nResult AS LONG
		#IfNDef __USE_GTK__
			Dim hdc AS HDC
			hdc = CreateIC (ByVal NULL,   PrinterName, BYVAL NULL, BYVAL NULL)
			IF hdc = 0 THEN EXIT FUNCTION
			nResult = GetDeviceCaps(hdc, HORZRES)
			DeleteDC hdc
		#EndIf
		FUNCTION = nResult
	END Function
	
	
	FUNCTION printer.GetPrinterVerticalResolution (BYVAL PrinterName AS String) AS Long  __EXPORT__' Width, in pixels, of the printable area of the page.
		Dim nResult AS LONG
		#IfNDef __USE_GTK__
			Dim hdc AS HDC
			hdc = CreateIC (ByVal NULL,   PrinterName, BYVAL NULL, BYVAL NULL)
			IF hdc = 0 THEN EXIT FUNCTION
			nResult = GetDeviceCaps(hdc, VERTRES)
			DeleteDC hdc
		#EndIf
		FUNCTION = nResult
	END Function
	
	' ========================================================================================
	' Returns the maximum number of copies the device can print.
	' If the function returns -1, this may mean either that the capability is not supported or
	' there was a general function failure.
	' ========================================================================================
	FUNCTION printer.GetPrinterMaxCopies (BYVAL PrinterName AS String) AS Long  __EXPORT__
		#IfNDef __USE_GTK__
			FUNCTION = DeviceCapabilities (  PrinterName, BYVAL NULL, DC_COPIES, BYVAL NULL, BYVAL NULL)
		#else
			Function = 0
		#EndIf
	END FUNCTION
	
	FUNCTION printer.GetPrinterMaxPaperHeight (BYVAL PrinterName AS String) AS Long  __EXPORT__  ' Returns the maximum paper width in tenths of a millimeter.
		#IfNDef __USE_GTK__
			Dim r AS LONG
			r = DeviceCapabilities (PrinterName, BYVAL NULL,DC_MAXEXTENT, BYVAL NULL, BYVAL NULL)
			IF r = -1 THEN EXIT FUNCTION
			FUNCTION = HIWORD( r)
		#Else
			Function = 0
		#EndIf
	END FUNCTION
	
	FUNCTION printer.GetPrinterMaxPaperWidth (BYVAL PrinterName AS String) AS Long  __EXPORT__ ' Returns the maximum paper width in tenths of a millimeter.
		#IfNDef __USE_GTK__
			Dim r AS LONG
			r = DeviceCapabilities (PrinterName, BYVAL NULL, DC_MAXEXTENT, BYVAL NULL, BYVAL NULL)
			IF r = -1 THEN EXIT FUNCTION
			FUNCTION = LOWORD(r)
		#Else
			Function = 0
		#EndIf
	END Function
	
	
	
	
	' ========================================================================================
	' Returns a list with port names of the available printers, print servers, domains, or print providers.
	' Names are separated with a carriage return and a line feed characters.
	' ========================================================================================
	FUNCTION printer.EnumPrinterPorts () AS String  __EXPORT__
		Dim i AS Long, Level AS Long, cbNeeded AS Long, cbReturned AS LONG, Names AS String
		#IfNDef __USE_GTK__
			DIM   Pi5( ) As  PRINTER_INFO_5
			Level = 5
			EnumPrinters  PRINTER_ENUM_LOCAL, NULL, Level,  NULL, 0, @cbNeeded, @cbReturned
			REDIM Pi5(0 TO cbNeeded \ SIZEOF(Pi5(0)))
			EnumPrinters  PRINTER_ENUM_LOCAL, "", Level,Cast( LPBYTE,@Pi5(0)), SizeOf(Pi5(0)) * (UBOUND(Pi5) + 1), @cbNeeded, @cbReturned
			FOR i = 0 TO cbReturned - 1
				Names += *Pi5(i).pPortName
				IF i < cbReturned - 1 THEN Names += CRLF
			NEXT
		#EndIf
		FUNCTION = Names
	END FUNCTION
	
	' ========================================================================================
	' Returns a list with the available printers, print servers, domains, or print providers.
	' Names are separated with a carriage return and a line feed characters.
	' ========================================================================================
	FUNCTION printer.EnumPrinters_ () AS String
		DIM i AS Long, Level AS Long, cbNeeded AS Long, cbReturned AS LONG, Names AS String
		#IfNDef __USE_GTK__
			DIM   Pi5( )  As PRINTER_INFO_5
			Level = 5
			EnumPrinters PRINTER_ENUM_LOCAL, BYVAL NULL, Level, BYVAL NULL, 0, @cbNeeded, @cbReturned
			REDIM Pi5(0 TO cbNeeded \ SIZEOF(Pi5(0)))
			EnumPrinters PRINTER_ENUM_LOCAL, "", Level, Cast( LPBYTE,@Pi5(0)),SIZEOF(Pi5(0)) * (UBOUND(Pi5) + 1), @cbNeeded, @cbReturned
			FOR i = 0 TO cbReturned - 1
				Names += *Pi5(i).pPrinterName
				IF i < cbReturned - 1 THEN Names +=  CRLF
			NEXT
		#EndIf
		FUNCTION = Names
	END FUNCTION
	
	' ========================================================================================
	' Retrieves the name of the default printer.
	' ========================================================================================
	/'
	FUNCTION  printer.defaultprinter () AS String
	Dim buffer AS ZSTRING * MAX_PATH
	GetProfileString "WINDOWS", "DEVICE", "", buffer, SIZEOF(buffer)
	FUNCTION = PARSE (buffer, 1)
	END FUNCTION
	'/
	
	FUNCTION printer.GetdefaultprinterDevice () AS String  __EXPORT__  ' Retrieves the name of the default printer device.
		#IfNDef __USE_GTK__
			Dim buffer As ZString * MAX_PATH
			GetProfileString "WINDOWS", "DEVICE", "", buffer, SizeOf(buffer)
			Function = PARSE (buffer, 2)
		#else
			Function = ""
		#endif
	End Function
	
	
	Function printer.GetdefaultprinterDriver () As String  __EXPORT__ ' Retrieves the name of the default printer driver.
		#ifndef __USE_GTK__
			Dim buffer As ZString * MAX_PATH
			GetProfileString "WINDOWS", "DEVICE", "", buffer, SizeOf(buffer)
			Function = PARSE (buffer, 1)
		#else
			Function = ""
		#endif
	End Function
	
	
	Function printer.GetdefaultprinterPort () As String  __EXPORT__ ' Retrieves the name of the default printer port.
		#ifndef __USE_GTK__
			Dim buffer As ZString * MAX_PATH
			GetProfileString  "WINDOWS", "DEVICE", "", buffer, SizeOf(buffer)
			Function = PARSE (buffer, 3)
		#else
			Function = ""
		#endif
	End Function
	
	Sub printer.ShowPrinterProperties()  __EXPORT__
		#ifndef __USE_GTK__
			Dim hPrinter As HWND
			OpenPrinter printername, @hPrinter, ByVal 0&
			PrinterProperties  getactiveWindow(), hPrinter
			ClosePrinter hPrinter
		#endif
	End Sub
	
	Constructor printer  __EXPORT__
		Canvas.Ctrl = @This
		WLet FClassName, "Printer"
	End Constructor
End Namespace
