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
	Private Function  Printer.PARSE(source As String, index As Integer, delimiter As String = ",") As String
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
	
	
	Private Function Printer.PARSE (source As String, delimiter As String = "|", index As Integer) As String
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
	
	Private Function Printer.STRREVERSE (S As String) As String
		Dim As Integer j=Len(s)
		Dim rstr As String=Space(j)
		While (j<>0)
			j=j-1
			rstr[j] = s[Len(s)-j-1]
		Wend
		Return rstr
	End Function
	
	Private Sub Printer.reportError(  ByVal n As Long)
		Dim s As String
		If n = 1 Then
			s = "Document printing error"
		ElseIf n = 2 Then
			s = "Page printing error"
		Else
			s = "Unspecified printer error"
		End If
		#ifndef __USE_GTK__
			MesSaGeBOX NULL,s, "Printer Error",  MB_ICONERROR
		#endif
	End Sub
	
	' ========================================================================================
	' Sets the printer orientation.
	' DMORIENT_PORTRAIT = Portrait
	' DMORIENT_LANDSCAPE = Landscape
	' ========================================================================================
	Private Function Printer.SetprinterOrientation (ByVal PrinterName As String, ByVal nOrientation As Long) As Long
		#ifndef __USE_GTK__
			Dim hPrinter As HWND
			Dim pDevMode As DEVMODE Ptr
			Dim pi2 As PRINTER_INFO_2 Ptr
			Dim pd As PRINTER_DEFAULTS
			Dim bufferPrn As String
			Dim bufferDoc As String
			Dim dwNeeded As DWORD
			Dim nRet As Long
			
			If nOrientation <> DMORIENT_PORTRAIT And nOrientation <> DMORIENT_LANDSCAPE Then Exit Function
			
			' // Start by opening the printer
			pd.DesiredAccess = PRINTER_ALL_ACCESS
			If OpenPrinter ( PrinterName, @hPrinter, @pd) = 0 Then Exit Function
			
			' // The first GetPrinter tells you how big the buffer should be in
			' // order to hold all of PRINTER_INFO_2. Note that this should fail with
			' // ERROR_INSUFFICIENT_BUFFER.  If GetPrinter fails for any other reason
			' // or dwNeeded isn't set for some reason, then there is a problem...
			nRet = Getprinter (hPrinter, 2, ByVal NULL, 0, @dwNeeded)
			If nRet = 0 And GetLastError <> ERROR_INSUFFICIENT_BUFFER Then
				ClosePrinter(hPrinter)
				Exit Function
			End If
			' // Allocate enough space for PRINTER_INFO_2...
			bufferPrn = Space(dwNeeded)
			' // The second GetPrinter fills in all the current settings, so all you
			' // need to do is modify what you're interested in...
			nRet = Getprinter (hPrinter, 2,   StrPtr(bufferPrn), dwNeeded, @dwNeeded)
			If nRet = 0 Then
				ClosePrinter(hPrinter)
				Exit Function
			End If
			
			' // If GetPrinter didn't fill in the DEVMODE, try to get it by calling
			' // DocumentProperties...
			pi2 = Cast(PRINTER_INFO_2 Ptr,StrPtr(bufferPrn))
			If pi2->pDevMode = NULL Then
				' // Allocate a buffer of the correct size
				dwNeeded = DocumentProperties (NULL, hPrinter,   PrinterName, ByVal NULL, ByVal NULL, 0)
				bufferDoc = Space(dwNeeded)
				pDevMode= GlobalAlloc(GMEM_FIXED,dwNeeded)
				' // Retrieve the printer configuration data
				nRet = DocumentProperties (NULL, hPrinter,   PrinterName,   pDevMode  , ByVal NULL, DM_OUT_BUFFER)
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
	Private Function printer.SetprinterOrientation2 (ByVal PrinterName As String, ByVal nOrientation As Long) As Long
		#ifndef __USE_GTK__
			Dim hPrinter As HWND
			Dim pDevMode As DEVMODE Ptr
			Dim pi2 As PRINTER_INFO_2 Ptr
			Dim pd As PRINTER_DEFAULTS
			Dim bufferPrn As String
			Dim bufferDoc As String
			Dim dwNeeded As DWORD
			Dim nRet As Long
			
			If nOrientation <> DMORIENT_PORTRAIT And nOrientation <> DMORIENT_LANDSCAPE Then Exit Function
			
			' // Start by opening the printer
			pd.DesiredAccess = PRINTER_ALL_ACCESS
			If OpenPrinter ( PrinterName, @hPrinter, @pd) = 0 Then Exit Function
			
			' // The first GetPrinter tells you how big the buffer should be in
			' // order to hold all of PRINTER_INFO_2. Note that this should fail with
			' // ERROR_INSUFFICIENT_BUFFER.  If GetPrinter fails for any other reason
			' // or dwNeeded isn't set for some reason, then there is a problem...
			nRet = Getprinter (hPrinter, 2, ByVal NULL, 0, @dwNeeded)
			If nRet = 0 And GetLastError <> ERROR_INSUFFICIENT_BUFFER Then
				ClosePrinter(hPrinter)
				Exit Function
			End If
			' // Allocate enough space for PRINTER_INFO_2...
			bufferPrn = Space(dwNeeded)
			' // The second GetPrinter fills in all the current settings, so all you
			' // need to do is modify what you're interested in...
			nRet = Getprinter (hPrinter, 2,   StrPtr(bufferPrn), dwNeeded, @dwNeeded)
			If nRet = 0 Then
				ClosePrinter(hPrinter)
				Exit Function
			End If
			
			' // If GetPrinter didn't fill in the DEVMODE, try to get it by calling
			' // DocumentProperties...
			pi2 = Cast(PRINTER_INFO_2 Ptr,StrPtr(bufferPrn))
			If pi2->pDevMode = NULL Then
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
	Private Function Printer.GetPrinterOrientation (ByVal PrinterName As String) As Long
		#ifndef __USE_GTK__
			Dim hPrinter As HWND
			Dim pDevMode As DEVMODE Ptr
			Dim pi2 As PRINTER_INFO_2 Ptr
			Dim bufferDoc As String
			Dim dwNeeded As DWORD
			Dim nRet As Long
			
			' // Start by opening the printer
			If OpenPrinter (PrinterName, Cast(LPHANDLE,@hPrinter), ByVal NULL) = 0 Then Exit Function
			' // Allocate a buffer of the correct size
			dwNeeded = DocumentProperties (NULL, hPrinter,PrinterName, ByVal NULL, ByVal NULL, 0)
			bufferDoc = Space(dwNeeded)
			' // Retrieve the printer configuration data
			pDevMode= GlobalAlloc(GMEM_FIXED,dwNeeded)
			nRet = DocumentProperties (NULL, hPrinter, PrinterName, pDevMode, ByVal NULL, DM_OUT_BUFFER)
			If nRet <> IDOK Then
				ClosePrinter(hPrinter)
				Exit Function
			End If
			' // Cast it to a DEVMODE structure
			'pDevMode = STRPTR(bufferDoc)
			' // Return the orientation
			Function = pDevMode->dmOrientation
			
			' // Finished with the printer
			ClosePrinter(hPrinter)
		#else
			Function = 0
		#endif
	End Function
	
	Private Property Printer.Name(vData As String)
		m_Name=vData
	End Property
	
	Private Property Printer.Name As String
		Return m_Name
	End Property
	
	
	Private Property Printer.PortName(vData As String)
	End Property
	
	Private Property Printer.PortName As String
		m_PortName=GetprinterPort (PrinterName)
		Return m_PortName
	End Property
	
	
	Private Property Printer.Page(vData As Integer)
		m_Page=vData
	End Property
	
	Private Property Printer.Page As Integer
		Return m_Page
	End Property
	
	
	Private Property Printer.PageSize(vData As Integer)
		m_PageSize=vData
	End Property
	
	Private Property Printer.PageSize As Integer
		Return m_PageSize
	End Property
	
	Private Property Printer.Copies(vData As Integer)
		m_Copies=vData
		SetprinterCopies ( PrinterName ,vData)
	End Property
	
	Private Property Printer.Copies As Integer
		Return m_Copies
	End Property
	
	Private Property Printer.Quality(vData As PrinterQuality)
		m_Quality=vData
		SetprinterQuality (PrinterName, vData)
	End Property
	
	Private Property Printer.Quality As PrinterQuality
		m_Quality=GetprinterQualityMode (PrinterName)
		Return m_Quality
	End Property
	
	Private Property Printer.FromPage(vData As Integer)
		m_FromPage=vData
	End Property
	
	Private Property Printer.FromPage As Integer
		Return m_FromPage
	End Property
	
	
	Private Property Printer.ToPage(vData As Integer)
		m_ToPage=vData
	End Property
	
	Private Property Printer.ToPage As Integer
		Return m_ToPage
	End Property
	
	
	
	
	Private Property Printer.Scale () As Long
		Return GetprinterScale ( PrinterName )
	End Property
	
	Private Property Printer.ScaleFactorX () As Long
		Return GetprinterScalingFactorX ( PrinterName )
	End Property
	
	Private Property Printer.ScaleFactorY () As Long
		Return GetprinterScalingFactorY ( PrinterName)
	End Property
	
	Private Property Printer.ColorMode (ByVal nMode As Long)
		SetprinterColorMode (PrinterName ,nMode)
		m_colorMode=nMode
	End Property
	
	Private Property Printer.ColorMode () As Long
		Return  m_colorMode
	End Property
	
	Private Property printer.DriveVersion () As Long
		Return GetprinterDriverVersion ( PrinterName )
	End Property
	
	Private Property  printer.printableWidth () As Long
		Return GetPrinterHorizontalResolution (PrinterName )
	End Property
	
	
	Private Property  printer.printableHeight() As Long
		Return GetPrinterVerticalResolution (PrinterName)
	End Property
	
	Private Property  printer.MaxCopies () As Long
		Return GetPrinterMaxCopies (PrinterName)
	End Property
	
	Private Property  printer.MaxPaperHeight () As Long
		Return GetPrinterMaxPaperHeight (PrinterName )
	End Property
	
	Private Property  printer.MaxPaperWidth () As Long
		Return GetPrinterMaxPaperWidth (PrinterName )
	End Property
	
	#ifndef __USE_GTK__
		Private Property printer.Handle() As HDC
			If m_hdc  = 0 Then printerName = This.defaultprinter()
			Return m_hdc
		End Property
	#endif
	
	Private Property printer.PageWidth As  Integer
		#ifndef __USE_GTK__
			If m_hdc  = 0 Then printerName = This.defaultprinter
			Return GetDeviceCaps(m_hdc ,PHYSICALWIDTH)
		#else
			Return 0
		#endif
	End Property
	
	Private Property printer.PageHeight() As Integer
		#ifndef __USE_GTK__
			Return GetDeviceCaps(m_hdc ,PHYSICALHEIGHT)
		#else
			Return 0
		#endif
	End Property
	
	Private Property printer.MarginLeft As  Integer
		Return leftMargin
	End Property
	
	Private Property printer.MarginLeft(value As  Integer)
		leftMargin =value
	End Property
	
	Private Property printer.MarginTop As  Integer
		Return topMargin
	End Property
	
	Private Property printer.MarginTop(value As  Integer)
		topMargin =value
	End Property
	
	
	Private Property printer.MarginRight As  Integer
		Return rightMargin
	End Property
	
	Private Property printer.MarginRight(value As  Integer)
		rightMargin =value
	End Property
	
	
	Private Property printer.Marginbottom As  Integer
		Return bottomMargin
	End Property
	
	Private Property printer.Marginbottom(value As  Integer)
		bottomMargin =value
	End Property
	
	
	Private Function printer.defaultprinter() As String    'determine default printer and device context handle
		#ifndef __USE_GTK__
			Dim hPrinter As HWND, dwNeeded As Long, n As Long
			Dim tm As TEXTMETRIC, sz As WString*128
			Dim pDevMode As DEVMODE Ptr
			GetProfileString "WINDOWS", "DEVICE", "", sz, 127
			sz = Trim(PARSE(sz, ",", 1)): printerName = sz
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
		#endif
		Return printerName
	End Function
	
	Private Function printer.choosePrinter() As String  'choose printer and determine device context handle
		Dim n As Long
		#ifndef __USE_GTK__
			Dim hPrinter As HWND
			Dim pd As PRINTDLG , pDevNames As DEVNAMES Ptr
			Dim tm As TEXTMETRIC, psz As ZString Ptr
			pd.lStructSize = SizeOf(pd)
			pd.Flags =  PD_RETURNDC Or  PD_HIDEPRINTTOFILE Or PD_PRINTSETUP
			pd.Flags = pd.Flags Or  PD_ALLPAGES Or  PD_NOSELECTION Or  PD_NOPAGENUMS
			If PrintDlg(@pd) Then 'call print dialog to select printer
				pDevNames = GlobalLock(pd.hDevNames)
				psz =Cast(ZString Ptr,Cast(Byte Ptr, pDevNames) +  pDevNames->wDeviceOffset)
				printerName = *psz
				OpenPrinter(*psz, @hPrinter, NULL)
				m_hdc = pd.hDC
				GlobalUnlock pd.hDevnames
				
			End If
			
			GetTextMetrics m_hdc , @tm
			n = tm.tmHeight + tm.tmExternalLeading
			charHt = n
			hDevMode = pd.hDevMode
			Canvas.Handle=m_hdc
			'canvas.Font.parent=hPrinter
		#endif
		Return printerName
		
	End Function
	
	#ifndef __USE_GTK__
		Private Function printer.newFont(fName As String, fSize As Long, ibold As Long = False, iunderline As Long = False, iitalic As Long = False ) As HFONT
			'define a new font using a font name, font size in points, and font attributes
			'combine attributes: "b" for bold, "u" for underline, "i" for italic
			Dim As Long yppi, charSize, hn
			Dim n  As HFONT
			Dim wt As DWORD, nBold As DWORD, underline As DWORD, italic As DWORD, s As String
			Dim tm As TEXTMETRIC
			If m_hFont Then DeleteObject m_hFont
			If m_hdc  = 0 Then printerName=This.defaultprinter
			
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
			If hOrigFont = 0 Then hOrigFont = n
			GetTextMetrics m_hdc , @tm
			hn = tm.tmHeight + tm.tmExternalLeading
			charHt = hn
			Return m_hFont
		End Function
	#endif
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
	
	
	
	
	
	Private Sub printer.getCharSize(ByRef wi As Integer, ByRef ht As Integer) 'character width and height in inches 'average character width if proportional font
		#ifndef __USE_GTK__
			Dim tm As TEXTMETRIC
			If m_hdc  = 0 Then printerName=This.defaultprinter
			GetTextMetrics m_hdc , @tm
			wi = tm.tmMaxCharWidth  'tm.tmAveCharWidth
			ht = charHt
		#endif
	End Sub
	
	Private Function printer.getLines(  ByVal y As Integer) As Long 'determine number of remaining lines from y to bottom margin
		#ifndef __USE_GTK__
			Dim  As Long yppi, paperHt, topNoPrn, bottomNoPrn
			Dim yn As Integer
			If m_hdc  = 0 Then printerName=This.defaultprinter
			yppi = GetDeviceCaps(m_hdc ,LOGPIXELSY)
			paperHt = GetDeviceCaps(m_hdc ,PHYSICALHEIGHT)
			topNoPrn = GetDeviceCaps(m_hdc ,PHYSICALOFFSETY)
			bottomNoPrn = paperHt - topNoPrn - GetDeviceCaps(m_hdc ,  VERTRES)
			If topMargin>(topNoPrn  ) Then y = topMargin Else y=topNoPrn
			
			yn = paperHt  - MAX(bottomMargin, bottomNoPrn ) - y
			Function = Int(yn / charHt)
		#else
			Return 0
		#endif
	End Function
	
	Private Property printer.duplexMode() As PrinterDuplexMode
		#ifndef __USE_GTK__
			m_duplex=GetPrinterDuplex (PrinterName)
		#endif
		Return m_duplex
	End Property
	
	Private Property printer.duplexMode(n As PrinterDuplexMode)   'n = 1 Simplex  'n = 2 Horizontal  'n = 3 Vertical
		#ifndef __USE_GTK__
			Dim pDevMode As DEVMODE Ptr
			If hDevMode = 0 Or n = 0 Then Exit Property
			pDevMode = GlobalLock(Cast(HGLOBAL,hDevMode))
			If origDuplex = 0 Then origDuplex = pDevMode->dmDuplex
			If pDevMode->dmFields And  DM_DUPLEX Then
				pDevMode->dmDuplex = n
				pDevMode->dmFields = pDevMode->dmFields Or  DM_DUPLEX
				ResetDC m_hdc , pDevMode
				GlobalUnlock Cast(HGLOBAL,hDevMode)
			End If
		#endif
	End Property
	
	Private Sub printer.orientPrint(n As Long) 'n = 1 Portrait 'n = 2 Landscape
		' If SetPrinterOrientation(printername,n)=FALSE Then Print "Error on Orientation"
		' Return
		#ifndef __USE_GTK__
			Dim lpDevMode As DEVMODE Ptr
			If hDevMode = 0 Then Exit Sub
			lpDevMode = GlobalLock(Cast(HGLOBAL,hDevMode))
			If origOrient = 0 Then origOrient = lpDevMode->dmOrientation
			If n And  lpDevMode->dmFields And DM_ORIENTATION  Then
				If n Then lpDevMode->dmOrientation = n
				lpDevMode->dmFields = lpDevMode->dmFields Or  DM_ORIENTATION
				ResetDC m_hdc , lpDevMode
				GlobalUnlock Cast(HGLOBAL,hDevMode)
			End If
		#endif
	End Sub
	
	Private Property printer.Orientation(value As Long)
		SetPrinterOrientation2(printername,value) ' orientPrint(value)
	End Property
	
	Private Property printer.Orientation() As Long
		Return GetPrinterOrientation(printername)
	End Property
	
	
	
	
	
	
	Private Sub printer.UpdateMargeins()
		'x, y are measured from the left and top edges of the paper
		'if x or y are omitted then last valuew, xLast, yLast are used
		Dim As Long xc, yc, xm, leftNoPrn, rightNoPrn, topNoPrn, bottomNoPrn
		Dim As Long paperWi, paperHt, xMax, yMax, xppi, yppi
		#ifndef __USE_GTK__
			If m_hdc  = 0 Then printerName=This.defaultprinter
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
		#endif
	End Sub
	
	Private Property printer.Title( value As String)
		Ftitle=value
	End Property
	
	Private Property printer.Title() As String
		Return Ftitle
	End Property
	
	Private Sub printer.StartDoc()
		#ifndef __USE_GTK__
			Dim nErr As Long, sz As WString*64
			Dim di As DOCINFO
			If m_hdc  = 0 Then printerName=This.defaultprinter
			sz = Ftitle
			di.cbSize = SizeOf(DOCINFO)
			di.lpszDocName = VarPtr(sz)
			nErr = .StartDoc(m_hdc , @di)
			If nErr <= 0 Then This.reportError(1)
		#endif
	End Sub
	
	Private Sub printer.StartPage
		#ifndef __USE_GTK__
			Dim nErr As Long
			nErr = .StartPage(m_hdc )
			If nErr <= 0 Then This.reportError(2)
		#endif
	End Sub
	
	Private Sub printer.EndDPage
		#ifndef __USE_GTK__
			.EndPage(m_hdc )
		#endif
	End Sub
	
	Private Sub printer.NewPage
		#ifndef __USE_GTK__
			.EndPage(m_hdc )
			.StartPage(m_hdc)
			FPageNumber+=1
		#endif
	End Sub
	
	Private Sub printer.EndDoc
		#ifndef __USE_GTK__
			.EndDoc(m_hdc )
			SelectObject m_hdc , hOrigFont
			DeleteObject m_hFont
			deleteDC m_hdc
			origDuplex = 0
			origOrient = 0
			hOrigFont = 0
		#endif
	End Sub
	
	
	'------------------------------------------------------------------------------
	' Calculate the text resolution based on the default font for the Device
	' Context. Works with both window and printer DC's. Requires %MM_TEXT mode.
	'
	Private Sub printer.CalcPageSize(ByRef Rows As Long, ByRef Columns As Long)
		#ifndef __USE_GTK__
			Dim tm As TEXTMETRIC
			GetTextMetrics m_hdc, @tm
			Rows    = GetDeviceCaps(m_hdc, VERTRES) \ (tm.tmHeight + tm.tmExternalLeading)
			Columns = GetDeviceCaps(m_hdc, HORZRES) \ tm.tmAveCharWidth
		#endif
	End Sub
	
	Private Function printer.PrinterPaperNames (ByVal PrinterName As String) As String
		Dim Names As String
		#ifndef __USE_GTK__
			Dim i As Long
			Dim r As Long
			r = DeviceCapabilities (PrinterName, ByVal NULL, DC_PAPERNAMES, ByVal NULL, ByVal NULL)
			If r = -1 Then Exit Function
			ReDim wszNames(r - 1) As WString * 64
			r = DeviceCapabilities (PrinterName, ByVal NULL, DC_PAPERNAMES, @wszNames(0), ByVal NULL)
			If r < 1 Then Exit Function
			For i = 0 To r - 1
				Names += wszNames(i)
				If i < r - 1 Then Names += ";"
			Next
		#endif
		Function = Names
	End Function
	
	
	
	' ========================================================================================
	' Returns a list of each supported paper sizes, in tenths of a millimeter.
	' Each entry if formated as "<width> x <height>" and separated by a carriage return and a
	' line feed characters.
	' ========================================================================================
	Private Function printer.GetPrinterPaperSizes (ByVal PrinterName As String) As String
		Dim i As Long, r As Long, Sizes As String
		#ifndef __USE_GTK__
			r = DeviceCapabilities (PrinterName, ByVal NULL, DC_PAPERSIZE, ByVal NULL, ByVal NULL)
			If r = -1 Then Exit Function
			ReDim pSizes(r - 1) As Point
			r = DeviceCapabilities (PrinterName, ByVal NULL, DC_PAPERSIZE, Cast( LPTSTR,@pSizes(0)), ByVal NULL)
			If r < 1 Then Exit Function
			For i = 0 To r - 1
				Sizes += WStr(pSizes(i).x) & " x " & WStr(pSizes(i).y)
				If i < r - 1 Then Sizes += CRLF
			Next
		#endif
		Function = Sizes
	End Function
	
	
	
	Private Function printer.GetPrinterPort (ByVal PrinterName As String) As String ' Returns the port name for a given printer name.
		Dim i As Long, Level As Long, cbNeeded As Long, cbReturned As Long
		#ifndef __USE_GTK__
			Dim   Pi5( ) As PRINTER_INFO_5
			Level = 5
			EnumPrinters  PRINTER_ENUM_LOCAL, ByVal NULL, Level, ByVal NULL, 0, @cbNeeded, @cbReturned
			ReDim Pi5(0 To cbNeeded \ SizeOf(Pi5(0)))
			EnumPrinters  PRINTER_ENUM_LOCAL, "", Level, Cast( LPBYTE,@Pi5(0)), _
			SizeOf(Pi5(0)) * (UBound(Pi5) + 1), @cbNeeded, @cbReturned
			For i = 0 To cbReturned - 1
				If UCase(*Pi5(i).pPrinterName) = UCase(PrinterName) Then
					Function = *Pi5(i).pPortName
					Exit For
				End If
			Next
		#else
			Return ""
		#endif
	End Function
	
	
	
	' ========================================================================================
	' Returns the printer print quality mode.
	' The return value can be one of the following:
	' - DMRES_DRAFT  = Draft
	' - DMRES_LOW    = Low
	' - DMRES_MEDIUM = Medium
	' - DMRES_HIGH   = High
	' ========================================================================================
	Private Function printer.GetPrinterQualityMode (ByVal PrinterName As String) As PrinterQuality
		#ifndef __USE_GTK__
			Dim hPrinter As HWND
			Dim pDevMode As DEVMODE Ptr
			Dim pi2 As PRINTER_INFO_2 Ptr
			Dim bufferDoc As String
			Dim dwNeeded As DWORD
			Dim nRet As Long
			
			' // Start by opening the printer
			If OpenPrinter (  PrinterName, @hPrinter, ByVal NULL) = 0 Then Exit Function
			' // Allocate a buffer of the correct size
			dwNeeded = DocumentProperties (NULL, hPrinter,   PrinterName, ByVal NULL, ByVal NULL, 0)
			bufferDoc = Space(dwNeeded)
			pDevMode= GlobalAlloc(GMEM_FIXED,dwNeeded)
			' // Retrieve the printer configuration data
			nRet = DocumentProperties (NULL, hPrinter,   PrinterName,pDevMode, ByVal NULL, DM_OUT_BUFFER)
			If nRet <> IDOK Then
				ClosePrinter(hPrinter)
				Exit Function
			End If
			' // Cast it to a DEVMODE structure
			' pDevMode = STRPTR(bufferDoc)
			' // Return the orientation
			Function = pDevMode->dmPrintQuality
			
			' // Finished with the printer
			ClosePrinter(hPrinter)
		#else
			Return 0
		#endif
	End Function
	' ========================================================================================
	
	' ========================================================================================
	' Specifies the factor by which the printed output is to be scaled. The apparent page size
	' is scaled from the physical page size by a factor of dmScale /100. For example, a
	' letter-sized page with a dmScale value of 50 would contain as much data as a page of
	' 17- by 22-inches because the output text and graphics would be half their original
	' height and width.
	' ========================================================================================
	Private Function printer.GetPrinterScale (ByVal PrinterName As String) As Long
		#ifndef __USE_GTK__
			Dim hPrinter As HWND
			Dim pDevMode As DEVMODE Ptr
			Dim pi2 As PRINTER_INFO_2 Ptr
			Dim bufferDoc As String
			Dim dwNeeded As DWORD
			Dim nRet As Long
			
			' // Start by opening the printer
			If OpenPrinter (  PrinterName, @hPrinter, ByVal NULL) = 0 Then Exit Function
			' // Allocate a buffer of the correct size
			dwNeeded = DocumentProperties (NULL, hPrinter,   PrinterName, ByVal NULL, ByVal NULL, 0)
			bufferDoc = Space(dwNeeded)
			' // Retrieve the printer configuration data
			pDevMode= GlobalAlloc(GMEM_FIXED,dwNeeded)
			nRet = DocumentProperties (NULL, hPrinter,   PrinterName, pDevMode, ByVal NULL, DM_OUT_BUFFER)
			If nRet <> IDOK Then
				ClosePrinter(hPrinter)
				Exit Function
			End If
			' // Cast it to a DEVMODE structure
			'pDevMode = STRPTR(bufferDoc)
			' // Return the number of copies
			Function = pDevMode->dmScale
			
			' // Finished with the printer
			ClosePrinter(hPrinter)
		#else
			Return 0
		#endif
	End Function
	
	Private Function printer.GetPrinterScalingFactorX (ByVal PrinterName As String) As Long  ' Scaling factor for the x-axis of the printer.
		Dim nResult As Long
		#ifndef __USE_GTK__
			Dim hdc As HDC
			hdc = CreateIC (NULL,PrinterName, ByVal NULL, ByVal NULL)
			If hdc = 0 Then Exit Function
			nResult = GetDeviceCaps(hdc, SCALINGFACTORX)
			DeleteDC hdc
		#endif
		Function = nResult
	End Function
	
	
	
	Private Function printer.GetPrinterScalingFactorY (ByVal PrinterName As String) As Long ' Scaling factor for the y-axis of the printer.
		Dim nResult As Long
		#ifndef __USE_GTK__
			Dim hdc As HDC
			hdc = CreateIC (ByVal NULL,   PrinterName, ByVal NULL, ByVal NULL)
			If hdc = 0 Then Exit Function
			nResult = GetDeviceCaps(hdc, SCALINGFACTORY)
			DeleteDC hdc
		#endif
		Function = nResult
	End Function
	
	
	' ========================================================================================
	' Switches between color and monochrome on color printers.
	' The following are the possible values:
	'   DMCOLOR_COLOR
	'   DMCOLOR_MONOCHROME
	' ========================================================================================
	Private Function printer.SetPrinterColorMode (ByVal PrinterName As String, ByVal nMode As Long) As Long
		#ifndef __USE_GTK__
			Dim hPrinter As HWND
			Dim pDevMode As DEVMODE Ptr
			Dim pi2 As PRINTER_INFO_2 Ptr
			Dim pd As PRINTER_DEFAULTS
			Dim bufferPrn As String
			Dim bufferDoc As String
			Dim dwNeeded As DWORD
			Dim nRet As Long
			
			' // Start by opening the printer
			pd.DesiredAccess = PRINTER_ALL_ACCESS
			If OpenPrinter (  PrinterName, @hPrinter, @pd) = 0 Then Exit Function
			
			' // The first GetPrinter tells you how big the buffer should be in
			' // order to hold all of PRINTER_INFO_2. Note that this should fail with
			' // ERROR_INSUFFICIENT_BUFFER.  If GetPrinter fails for any other reason
			' // or dwNeeded isn't set for some reason, then there is a problem...
			nRet = GetPrinter (hPrinter, 2, ByVal NULL, 0, @dwNeeded)
			If nRet = 0 And GetLastError <> ERROR_INSUFFICIENT_BUFFER Then
				ClosePrinter(hPrinter)
				Exit Function
			End If
			' // Allocate enough space for PRINTER_INFO_2...
			bufferPrn = Space(dwNeeded)
			' // The second GetPrinter fills in all the current settings, so all you
			' // need to do is modify what you're interested in...
			nRet = GetPrinter (hPrinter, 2, ByVal StrPtr(bufferPrn),  dwNeeded, @dwNeeded)
			If nRet = 0 Then
				ClosePrinter(hPrinter)
				Exit Function
			End If
			
			' // If GetPrinter didn't fill in the DEVMODE, try to get it by calling
			' // DocumentProperties...
			pi2 = Cast(PRINTER_INFO_2 Ptr,StrPtr(bufferPrn))
			If pi2->pDevMode = NULL Then
				' // Allocate a buffer of the correct size
				dwNeeded = DocumentProperties (NULL, hPrinter,   PrinterName, ByVal NULL, ByVal NULL, 0)
				bufferDoc = Space(dwNeeded)
				pDevMode= GlobalAlloc(GMEM_FIXED,dwNeeded)
				' // Retrieve the printer configuration data
				nRet = DocumentProperties (NULL, hPrinter,   PrinterName, pDevMode, ByVal NULL, DM_OUT_BUFFER)
				If nRet <> IDOK Then
					ClosePrinter(hPrinter)
					Exit Function
				End If
				' // Cast it to a DEVMODE structure
				'pDevMode = STRPTR(bufferDoc)
				pi2->pDevMode = pDevMode
			End If
			
			' // Specify exactly what we are attempting to change...
			pi2->pDevMode->dmColor = nMode
			
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
			
			' // Update printer information...
			nRet = SetPrinter (hPrinter, 2, Cast( LPBYTE,pi2), 0)
			If nRet = 0 Then
				' // The driver doesn't support, or it is unable to make the change...
				ClosePrinter(hPrinter)
				Exit Function
			End If
			
			' // Finished with the printer
			ClosePrinter(hPrinter)
			
			If nRet <> IDOK Then Exit Function
		#endif
		Function  = True
		
	End Function
	
	' ========================================================================================
	' Selects the number of copies printed if the device supports multiple-page copies.
	' ========================================================================================
	Private Function printer.SetPrinterCopies (ByVal PrinterName As String, ByVal nCopies As Long) As Long
		#ifndef __USE_GTK__
			Dim hPrinter As HWND
			Dim pDevMode As DEVMODE Ptr
			Dim pi2 As PRINTER_INFO_2 Ptr
			Dim pd As PRINTER_DEFAULTS
			Dim bufferPrn As String
			Dim bufferDoc As String
			Dim dwNeeded As DWORD
			Dim nRet As Long
			
			' // Start by opening the printer
			pd.DesiredAccess = PRINTER_ALL_ACCESS
			If OpenPrinter (  PrinterName, @hPrinter, @pd) = 0 Then Exit Function
			
			' // The first GetPrinter tells you how big the buffer should be in
			' // order to hold all of PRINTER_INFO_2. Note that this should fail with
			' // ERROR_INSUFFICIENT_BUFFER.  If GetPrinter fails for any other reason
			' // or dwNeeded isn't set for some reason, then there is a problem...
			nRet = GetPrinter (hPrinter, 2, ByVal NULL, 0, @dwNeeded)
			If nRet = 0 And GetLastError <> ERROR_INSUFFICIENT_BUFFER Then
				ClosePrinter(hPrinter)
				Exit Function
			End If
			' // Allocate enough space for PRINTER_INFO_2...
			bufferPrn = Space(dwNeeded)
			' // The second GetPrinter fills in all the current settings, so all you
			' // need to do is modify what you're interested in...
			nRet = GetPrinter (hPrinter, 2, ByVal StrPtr(bufferPrn), dwNeeded, @dwNeeded)
			If nRet = 0 Then
				ClosePrinter(hPrinter)
				Exit Function
			End If
			
			' // If GetPrinter didn't fill in the DEVMODE, try to get it by calling
			' // DocumentProperties...
			pi2 = Cast(PRINTER_INFO_2 Ptr,StrPtr(bufferPrn))
			If pi2->pDevMode = NULL Then
				' // Allocate a buffer of the correct size
				dwNeeded = DocumentProperties (NULL, hPrinter,PrinterName, ByVal NULL, ByVal NULL, 0)
				bufferDoc = Space(dwNeeded)
				pDevMode= GlobalAlloc(GMEM_FIXED,dwNeeded)
				' // Retrieve the printer configuration data
				nRet = DocumentProperties (NULL, hPrinter,PrinterName, pDevMode, ByVal NULL, DM_OUT_BUFFER)
				If nRet <> IDOK Then
					ClosePrinter(hPrinter)
					Exit Function
				End If
				' // Cast it to a DEVMODE structure
				' pDevMode = STRPTR(bufferDoc)
				pi2->pDevMode = pDevMode
			End If
			
			' // Specify exactly what we are attempting to change...
			pi2->pDevMode->dmCopies = nCopies
			
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
			
			' // Update printer information...
			nRet = SetPrinter (hPrinter, 2, Cast(LPBYTE,pi2), 0)
			If nRet = 0 Then
				' // The driver doesn't support, or it is unable to make the change...
				ClosePrinter(hPrinter)
				Exit Function
			End If
			
			' // Finished with the printer
			ClosePrinter(hPrinter)
			
			If nRet <> IDOK Then Exit Function
		#endif
		Function  = True
		
	End Function
	
	' ========================================================================================
	' Sets the printer duplex mode
	' DMDUP_SIMPLEX = Single sided printing
	' DMDUP_VERTICAL = Page flipped on the vertical edge
	' DMDUP_HORIZONTAL = Page flipped on the horizontal edge
	' ========================================================================================
	Private Function printer.SetPrinterDuplexMode (ByVal PrinterName As String, ByVal nDuplexMode As Long) As Long
		#ifndef __USE_GTK__
			Dim hPrinter As HWND
			Dim pDevMode As DEVMODE Ptr
			Dim pi2 As PRINTER_INFO_2 Ptr
			Dim pd As PRINTER_DEFAULTS
			Dim bufferPrn As String
			Dim bufferDoc As String
			Dim dwNeeded As DWORD
			Dim nRet As Long
			
			If nDuplexMode <> DMDUP_SIMPLEX And nDuplexMode <> DMDUP_VERTICAL And nDuplexMode <> DMDUP_HORIZONTAL  Then Exit Function
			
			' // Start by opening the printer
			pd.DesiredAccess = PRINTER_ALL_ACCESS
			If OpenPrinter (  PrinterName, @hPrinter, @pd) = 0 Then Exit Function
			
			' // The first GetPrinter tells you how big the buffer should be in
			' // order to hold all of PRINTER_INFO_2. Note that this should fail with
			' // ERROR_INSUFFICIENT_BUFFER.  If GetPrinter fails for any other reason
			' // or dwNeeded isn't set for some reason, then there is a problem...
			nRet = GetPrinter (hPrinter, 2, ByVal NULL, 0, @dwNeeded)
			If nRet = 0 And GetLastError <> ERROR_INSUFFICIENT_BUFFER Then
				ClosePrinter(hPrinter)
				Exit Function
			End If
			' // Allocate enough space for PRINTER_INFO_2...
			bufferPrn = Space(dwNeeded)
			' // The second GetPrinter fills in all the current settings, so all you
			' // need to do is modify what you're interested in...
			nRet = GetPrinter (hPrinter, 2, ByVal StrPtr(bufferPrn), dwNeeded, @dwNeeded)
			If nRet = 0 Then
				ClosePrinter(hPrinter)
				Exit Function
			End If
			
			' // If GetPrinter didn't fill in the DEVMODE, try to get it by calling
			' // DocumentProperties...
			pi2 = Cast(PRINTER_INFO_2 Ptr,StrPtr(bufferPrn))
			If pi2->pDevMode = NULL Then
				' // Allocate a buffer of the correct size
				dwNeeded = DocumentProperties (NULL, hPrinter,PrinterName, ByVal NULL, ByVal NULL, 0)
				bufferDoc = Space(dwNeeded)
				pDevMode= GlobalAlloc(GMEM_FIXED,dwNeeded)
				' // Retrieve the printer configuration data
				nRet = DocumentProperties (NULL, hPrinter,PrinterName,  pDevMode, ByVal NULL, DM_OUT_BUFFER)
				If nRet <> IDOK Then
					ClosePrinter(hPrinter)
					Exit Function
				End If
				' // Cast it to a DEVMODE structure
				'  pDevMode = STRPTR(bufferDoc)
				pi2->pDevMode = pDevMode
			End If
			
			' // Driver is reporting that it doesn't support this change...
			If (pi2->pDevMode->dmFields And DM_DUPLEX) = 0 Then
				ClosePrinter(hPrinter)
				Exit Function
			End If
			
			' // Specify exactly what we are attempting to change...
			pi2->pDevMode->dmDuplex = nDuplexMode
			
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
			
			' // Update printer information...
			nRet = SetPrinter (hPrinter, 2, Cast(LPBYTE,pi2), 0)
			IF nRet = 0 THEN
				' // The driver doesn't support, or it is unable to make the change...
				ClosePrinter(hPrinter)
				Exit Function
			End If
			
			' // Finished with the printer
			ClosePrinter(hPrinter)
			
			If nRet <> IDOK Then Exit Function
		#endif
		Function  = True
		
	End Function
	
	
	
	Private Function printer.SetPrinterPaperSize (ByVal PrinterName As String, ByVal nSize As Long) As Long ' Sets the printer paper size.
		#ifndef __USE_GTK__
			Dim hPrinter As HWND
			Dim pDevMode As DEVMODE Ptr
			Dim pi2 As PRINTER_INFO_2 Ptr
			Dim pd As PRINTER_DEFAULTS
			Dim bufferPrn As String
			Dim bufferDoc As String
			Dim dwNeeded As DWORD
			Dim nRet As Long
			
			' // Start by opening the printer
			pd.DesiredAccess = PRINTER_ALL_ACCESS
			If OpenPrinter (  PrinterName, @hPrinter, @pd) = 0 Then Exit Function
			
			' // The first GetPrinter tells you how big the buffer should be in
			' // order to hold all of PRINTER_INFO_2. Note that this should fail with
			' // ERROR_INSUFFICIENT_BUFFER.  If GetPrinter fails for any other reason
			' // or dwNeeded isn't set for some reason, then there is a problem...
			nRet = GetPrinter (hPrinter, 2, ByVal NULL, 0, @dwNeeded)
			If nRet = 0 And GetLastError <> ERROR_INSUFFICIENT_BUFFER Then
				ClosePrinter(hPrinter)
				Exit Function
			End If
			' // Allocate enough space for PRINTER_INFO_2...
			bufferPrn = Space(dwNeeded)
			' // The second GetPrinter fills in all the current settings, so all you
			' // need to do is modify what you're interested in...
			nRet = GetPrinter (hPrinter, 2, ByVal StrPtr(bufferPrn),  dwNeeded, @dwNeeded)
			If nRet = 0 Then
				ClosePrinter(hPrinter)
				Exit Function
			End If
			
			' // If GetPrinter didn't fill in the DEVMODE, try to get it by calling
			' // DocumentProperties...
			pi2 = Cast(PRINTER_INFO_2 Ptr,StrPtr(bufferPrn))
			If pi2->pDevMode = NULL Then
				' // Allocate a buffer of the correct size
				dwNeeded = DocumentProperties (NULL, hPrinter,   PrinterName, ByVal NULL, ByVal NULL, 0)
				bufferDoc = Space(dwNeeded)
				pDevMode= GlobalAlloc(GMEM_FIXED,dwNeeded)
				' // Retrieve the printer configuration data
				nRet = DocumentProperties (NULL, hPrinter,   PrinterName,  pDevMode, ByVal NULL, DM_OUT_BUFFER)
				If nRet <> IDOK Then
					ClosePrinter(hPrinter)
					Exit Function
				End If
				' // Cast it to a DEVMODE structure
				' pDevMode = STRPTR(bufferDoc)
				pi2->pDevMode = pDevMode
			End If
			
			' // Specify exactly what we are attempting to change...
			pi2->pDevMode->dmPaperSize = nSize
			
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
			
			' // Update printer information...
			nRet = SetPrinter (hPrinter, 2, Cast(LPBYTE,pi2), 0)
			If nRet = 0 Then
				' // The driver doesn't support, or it is unable to make the change...
				ClosePrinter(hPrinter)
				Exit Function
			End If
			
			' // Finished with the printer
			ClosePrinter(hPrinter)
			
			IF nRet <> IDOK THEN EXIT FUNCTION
		#endif
		Function  = True
		
	End Function
	
	Private Function printer.SetPrinterQuality (ByVal PrinterName As String, ByVal nMode As PrinterQuality) As Long ' Specifies the printer resolution.
		#ifndef __USE_GTK__
			Dim hPrinter As HWND
			Dim pDevMode As DEVMODE Ptr
			Dim pi2 As PRINTER_INFO_2 Ptr
			Dim pd As PRINTER_DEFAULTS
			Dim bufferPrn As String
			Dim bufferDoc As String
			Dim dwNeeded As DWORD
			Dim nRet As Long
			
			' // Start by opening the printer
			pd.DesiredAccess = PRINTER_ALL_ACCESS
			If OpenPrinter (  PrinterName, @hPrinter, @pd) = 0 Then Exit Function
			
			' // The first GetPrinter tells you how big the buffer should be in
			' // order to hold all of PRINTER_INFO_2. Note that this should fail with
			' // ERROR_INSUFFICIENT_BUFFER.  If GetPrinter fails for any other reason
			' // or dwNeeded isn't set for some reason, then there is a problem...
			nRet = GetPrinter (hPrinter, 2, ByVal NULL, 0, @dwNeeded)
			If nRet = 0 And GetLastError <> ERROR_INSUFFICIENT_BUFFER Then
				ClosePrinter(hPrinter)
				Exit Function
			End If
			' // Allocate enough space for PRINTER_INFO_2...
			bufferPrn = Space(dwNeeded)
			' // The second GetPrinter fills in all the current settings, so all you
			' // need to do is modify what you're interested in...
			nRet = GetPrinter (hPrinter, 2, ByVal StrPtr(bufferPrn),  dwNeeded, @dwNeeded)
			If nRet = 0 Then
				ClosePrinter(hPrinter)
				Exit Function
			End If
			
			' // If GetPrinter didn't fill in the DEVMODE, try to get it by calling
			' // DocumentProperties...
			pi2 = Cast(PRINTER_INFO_2 Ptr,StrPtr(bufferPrn))
			If pi2->pDevMode = NULL Then
				' // Allocate a buffer of the correct size
				dwNeeded = DocumentProperties (NULL, hPrinter,   PrinterName, ByVal NULL, ByVal NULL, 0)
				bufferDoc = Space(dwNeeded)
				pDevMode= GlobalAlloc(GMEM_FIXED,dwNeeded)
				' // Retrieve the printer configuration data
				nRet = DocumentProperties (NULL, hPrinter,   PrinterName,  pDevMode, ByVal NULL, DM_OUT_BUFFER)
				If nRet <> IDOK Then
					ClosePrinter(hPrinter)
					Exit Function
				End If
				' // Cast it to a DEVMODE structure
				' pDevMode = STRPTR(bufferDoc)
				pi2->pDevMode = pDevMode
			End If
			
			' // Specify exactly what we are attempting to change...
			pi2->pDevMode->dmPrintQuality = nMode
			
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
			
			' // Update printer information...
			nRet = SetPrinter (hPrinter, 2, Cast(LPBYTE,pi2), 0)
			If nRet = 0 Then
				' // The driver doesn't support, or it is unable to make the change...
				ClosePrinter(hPrinter)
				Exit Function
			End If
			
			' // Finished with the printer
			ClosePrinter(hPrinter)
			
			If nRet <> IDOK Then Exit Function
		#endif
		Function  = True
		
	End Function
	
	
	Private Function printer.GetPrinterDriverVersion (ByVal PrinterName As String) As Long  ' Returns the version number of the printer driver.
		#ifndef __USE_GTK__
			Function = DeviceCapabilities (PrinterName, ByVal NULL, DC_DRIVER, ByVal NULL, ByVal NULL)
		#else
			Function = 0
		#endif
	End Function
	
	Private Function printer.GetPrinterDuplex (ByVal PrinterName As String) As Long  ' If the printer supports duplex printing, the return value is 1; otherwise, the return value is zero.
		#ifndef __USE_GTK__
			Function = DeviceCapabilities (PrinterName, ByVal NULL, DC_DUPLEX, ByVal NULL, ByVal NULL)
		#else
			Function = 0
		#endif
	End Function
	
	
	Private Function printer.GetPrinterFromPort (ByVal sPortName As String) As String ' Returns the printer name for a given port name.
		Dim i As Long, Level As Long, cbNeeded As Long, cbReturned As Long, Names As String
		#ifndef __USE_GTK__
			Dim   Pi5() As PRINTER_INFO_5
			Level = 5
			EnumPrinters  PRINTER_ENUM_LOCAL, ByVal NULL, Level, ByVal NULL, 0, @cbNeeded, @cbReturned
			ReDim Pi5(0 To cbNeeded \ SizeOf(Pi5(0)))
			EnumPrinters  PRINTER_ENUM_LOCAL, "", Level, Cast( LPBYTE,@Pi5(0)), _
			SizeOf(Pi5(0)) * (UBound(Pi5) + 1), @cbNeeded, @cbReturned
			For i = 0 To cbReturned - 1
				If UCase(*Pi5(i).pPortName) = UCase(sPortName) Then
					Names += *Pi5(i).pPrinterName & CRLF
				End If
			Next
			' // Remove the last $CRLF
			If Len(Names) Then Names = ..LEFT(Names, Len(Names) - 2)
		#endif
		Function = Names
	End Function
	
	
	Private Function printer.GetPrinterHorizontalResolution (ByVal PrinterName As String) As Long ' Width, in pixels, of the printable area of the page.
		Dim nResult As Long
		#ifndef __USE_GTK__
			Dim hdc As HDC
			hdc = CreateIC (ByVal NULL,   PrinterName, ByVal NULL, ByVal NULL)
			If hdc = 0 Then Exit Function
			nResult = GetDeviceCaps(hdc, HORZRES)
			DeleteDC hdc
		#endif
		Function = nResult
	End Function
	
	
	Private Function printer.GetPrinterVerticalResolution (ByVal PrinterName As String) As Long ' Width, in pixels, of the printable area of the page.
		Dim nResult As Long
		#ifndef __USE_GTK__
			Dim hdc As HDC
			hdc = CreateIC (ByVal NULL,   PrinterName, ByVal NULL, ByVal NULL)
			If hdc = 0 Then Exit Function
			nResult = GetDeviceCaps(hdc, VERTRES)
			DeleteDC hdc
		#endif
		Function = nResult
	End Function
	
	' ========================================================================================
	' Returns the maximum number of copies the device can print.
	' If the function returns -1, this may mean either that the capability is not supported or
	' there was a general function failure.
	' ========================================================================================
	Private Function printer.GetPrinterMaxCopies (ByVal PrinterName As String) As Long
		#ifndef __USE_GTK__
			Function = DeviceCapabilities (  PrinterName, ByVal NULL, DC_COPIES, ByVal NULL, ByVal NULL)
		#else
			Function = 0
		#endif
	End Function
	
	Private Function printer.GetPrinterMaxPaperHeight (ByVal PrinterName As String) As Long  ' Returns the maximum paper width in tenths of a millimeter.
		#ifndef __USE_GTK__
			Dim r As Long
			r = DeviceCapabilities (PrinterName, ByVal NULL,DC_MAXEXTENT, ByVal NULL, ByVal NULL)
			If r = -1 Then Exit Function
			Function = HiWord( r)
		#else
			Function = 0
		#endif
	End Function
	
	Private Function printer.GetPrinterMaxPaperWidth (ByVal PrinterName As String) As Long ' Returns the maximum paper width in tenths of a millimeter.
		#ifndef __USE_GTK__
			Dim r As Long
			r = DeviceCapabilities (PrinterName, ByVal NULL, DC_MAXEXTENT, ByVal NULL, ByVal NULL)
			If r = -1 Then Exit Function
			Function = LoWord(r)
		#else
			Function = 0
		#endif
	End Function
	
	
	
	
	' ========================================================================================
	' Returns a list with port names of the available printers, print servers, domains, or print providers.
	' Names are separated with a carriage return and a line feed characters.
	' ========================================================================================
	Private Function printer.EnumPrinterPorts () As String
		Dim i As Long, Level As Long, cbNeeded As Long, cbReturned As Long, Names As String
		#ifndef __USE_GTK__
			Dim   Pi5( ) As  PRINTER_INFO_5
			Level = 5
			EnumPrinters  PRINTER_ENUM_LOCAL, NULL, Level,  NULL, 0, @cbNeeded, @cbReturned
			ReDim Pi5(0 To cbNeeded \ SizeOf(Pi5(0)))
			EnumPrinters  PRINTER_ENUM_LOCAL, "", Level,Cast( LPBYTE,@Pi5(0)), SizeOf(Pi5(0)) * (UBound(Pi5) + 1), @cbNeeded, @cbReturned
			For i = 0 To cbReturned - 1
				Names += *Pi5(i).pPortName
				If i < cbReturned - 1 Then Names += CRLF
			Next
		#endif
		Function = Names
	End Function
	
	' ========================================================================================
	' Returns a list with the available printers, print servers, domains, or print providers.
	' Names are separated with a carriage return and a line feed characters.
	' ========================================================================================
	Private Function printer.EnumPrinters_ () As String
		Dim i As Long, Level As Long, cbNeeded As Long, cbReturned As Long, Names As String
		#ifndef __USE_GTK__
			Dim   Pi5( )  As PRINTER_INFO_5
			Level = 5
			EnumPrinters PRINTER_ENUM_LOCAL, ByVal NULL, Level, ByVal NULL, 0, @cbNeeded, @cbReturned
			ReDim Pi5(0 To cbNeeded \ SizeOf(Pi5(0)))
			EnumPrinters PRINTER_ENUM_LOCAL, "", Level, Cast( LPBYTE,@Pi5(0)),SizeOf(Pi5(0)) * (UBound(Pi5) + 1), @cbNeeded, @cbReturned
			For i = 0 To cbReturned - 1
				Names += *Pi5(i).pPrinterName
				If i < cbReturned - 1 Then Names +=  CRLF
			Next
		#endif
		Function = Names
	End Function
	
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
	
	Private Function printer.GetdefaultprinterDevice () As String  ' Retrieves the name of the default printer device.
		#ifndef __USE_GTK__
			Dim buffer As ZString * MAX_PATH
			GetProfileString "WINDOWS", "DEVICE", "", buffer, SizeOf(buffer)
			Function = PARSE (buffer, 2)
		#else
			Function = ""
		#endif
	End Function
	
	
	Private Function printer.GetdefaultprinterDriver () As String  ' Retrieves the name of the default printer driver.
		#ifndef __USE_GTK__
			Dim buffer As ZString * MAX_PATH
			GetProfileString "WINDOWS", "DEVICE", "", buffer, SizeOf(buffer)
			Function = PARSE (buffer, 1)
		#else
			Function = ""
		#endif
	End Function
	
	
	Private Function printer.GetdefaultprinterPort () As String  ' Retrieves the name of the default printer port.
		#ifndef __USE_GTK__
			Dim buffer As ZString * MAX_PATH
			GetProfileString  "WINDOWS", "DEVICE", "", buffer, SizeOf(buffer)
			Function = PARSE (buffer, 3)
		#else
			Function = ""
		#endif
	End Function
	
	Private Sub printer.ShowPrinterProperties()
		#ifndef __USE_GTK__
			Dim hPrinter As HWND
			OpenPrinter printername, @hPrinter, ByVal 0&
			PrinterProperties  getactiveWindow(), hPrinter
			ClosePrinter hPrinter
		#endif
	End Sub
	
	Private Constructor printer
		Canvas.Ctrl = @This
		WLet(FClassName, "Printer")
	End Constructor
End Namespace
