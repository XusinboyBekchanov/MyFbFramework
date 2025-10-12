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
#include once "WStringList.bi"

Namespace My.Sys.ComponentModel
	#ifndef ReadProperty_Off
		Private Function Printer.ReadProperty(PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "Name": Return @m_Name
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function Printer.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "Name": Name = QString(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	
	Private Function PaperSizeCollection.Add(Index As Integer = -1) As PaperSize Ptr
		Dim As PaperSize Ptr NewPaperSize = _New(PaperSize)
		If Index > -1 Then
			FItems.Insert Index, NewPaperSize
		Else
			FItems.Add NewPaperSize
		End If
		Return NewPaperSize
	End Function
	
	Private Sub PaperSizeCollection.Clear
		For i As Integer = Count - 1 To 0 Step -1
			_Delete(Cast(PaperSize Ptr, FItems.Items[i]))
		Next i
		FItems.Clear
	End Sub
	
	Private Property PaperSizeCollection.Count As Integer
		Return FItems.Count
	End Property
	
	Private Function PaperSizeCollection.Contains(PaperSizeItem As PaperSize Ptr) As Boolean
		Return IndexOf(PaperSizeItem) <> -1
	End Function
	
	Private Function PaperSizeCollection.IndexOf(PaperSizeItem As PaperSize Ptr) As Integer
		Return FItems.IndexOf(PaperSizeItem)
	End Function
	
	Private Function PaperSizeCollection.Insert(Index As Integer, PageItem As PaperSize Ptr) As PaperSize Ptr
		FItems.Insert(Index, PageItem)
		Return PageItem
	End Function
	
	Private Property PaperSizeCollection.Item(Index As Integer) As PaperSize Ptr
		Return Cast(PaperSize Ptr, FItems.Item(Index))
	End Property
	
	Private Property PaperSizeCollection.Item(Index As Integer, Value As PaperSize Ptr)
		FItems.Item(Index) = Value
	End Property
	
	Private Sub PaperSizeCollection.Remove(Index As Integer)
		_Delete(Item(Index))
		FItems.Remove Index
	End Sub
	
	Private Constructor PaperSizeCollection
		This.Clear
	End Constructor
	
	Private Destructor PaperSizeCollection
		This.Clear
	End Destructor
	
	Private Function  Printer.Parse(source As String, index As Integer, delimiter As String = ",") As String
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
	
	
	Private Function Printer.Parse (source As String, delimiter As String = "|", index As Integer) As String
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
	
	Private Function Printer.StrReverse (S As String) As String
		Dim As Integer j=Len(S)
		Dim rstr As String=Space(j)
		While (j<>0)
			j=j-1
			rstr[j] = S[Len(S)-j-1]
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
			MessageBox NULL,s, "Printer Error",  MB_ICONERROR
		#endif
	End Sub
	
	' ========================================================================================
	' Sets the printer orientation.
	' DMORIENT_PORTRAIT = Portrait
	' DMORIENT_LANDSCAPE = Landscape
	' ========================================================================================
	Private Function Printer.SetPrinterOrientation (ByRef PrinterName As WString, ByVal nOrientation As Long) As Long
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
			nRet = GetPrinter (hPrinter, 2, ByVal NULL, 0, @dwNeeded)
			If nRet = 0 And GetLastError <> ERROR_INSUFFICIENT_BUFFER Then
				ClosePrinter(hPrinter)
				Exit Function
			End If
			' // Allocate enough space for PRINTER_INFO_2...
			bufferPrn = Space(dwNeeded)
			' // The second GetPrinter fills in all the current settings, so all you
			' // need to do is modify what you're interested in...
			nRet = GetPrinter (hPrinter, 2,   StrPtr(bufferPrn), dwNeeded, @dwNeeded)
			If nRet = 0 Then
				ClosePrinter(hPrinter)
				Exit Function
			End If
			
			' // If GetPrinter didn't fill in the DEVMODE, try to get it by calling
			' // DocumentProperties...
			pi2 = Cast(PRINTER_INFO_2 Ptr,StrPtr(bufferPrn))
			If pi2->pDevMode = NULL Then
				' // Allocate a buffer of the correct size
				dwNeeded = GetPrinterNeededSize(PrinterName)
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
			
			' // Update printer information...
			pi2->pSecurityDescriptor=NULL
			nRet = SetPrinter (hPrinter, 2,Cast(LPBYTE, pi2), 0)
			
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
	' Sets the printer orientation.
	' DMORIENT_PORTRAIT = Portrait
	' DMORIENT_LANDSCAPE = Landscape
	' ========================================================================================
	Private Function Printer.SetPrinterOrientation2 (ByRef PrinterName As WString, ByVal nOrientation As Long) As Long
		#ifndef __USE_GTK__
			Dim hPrinter As HWND
			Dim pDevMode As DEVMODE Ptr
			Dim pi2 As PRINTER_INFO_2 Ptr
			Dim pd As PRINTER_DEFAULTS
			Dim dwNeeded As DWORD
			
			If nOrientation <> DMORIENT_PORTRAIT And nOrientation <> DMORIENT_LANDSCAPE Then Exit Function
			
			' // Start by opening the printer
			pd.pDatatype = 0
			pd.pDevMode = 0
			pd.DesiredAccess = PRINTER_ALL_ACCESS
			
			If OpenPrinter ( PrinterName, @hPrinter, @pd) = 0 Then Exit Function
			
			' Получаем размер структуры DEVMODE
			dwNeeded = GetPrinterNeededSize(PrinterName)
			If dwNeeded = 0 Then Return False
			
			' Выделяем память для структуры DEVMODE
			pDevMode = _Allocate(dwNeeded)
			If pDevMode = NULL Then Return False
			
			' Заполняем структуру DEVMODE текущими настройками
			If DocumentProperties(NULL, hPrinter, NULL, pDevMode, NULL, DM_OUT_BUFFER) <> IDOK Then
				_Deallocate((pDevMode))
				Return False
			End If
			
			' Устанавливаем новую ориентацию
			pDevMode->dmOrientation = nOrientation
			pDevMode->dmFields = DM_ORIENTATION ' Устанавливаем флаг, что изменяется ориентация
			
			' Применяем изменения
			If DocumentProperties(NULL, hPrinter, NULL, pDevMode, pDevMode, DM_IN_BUFFER Or DM_OUT_BUFFER) <> IDOK Then
				_Deallocate((pDevMode))
				Return False
			End If
			
			' Устанавливаем принтер с новыми параметрами
			If GetPrinter(hPrinter, 2, NULL, 0, @dwNeeded) = 0 AndAlso GetLastError() = ERROR_INSUFFICIENT_BUFFER Then
				pi2 = _Allocate(dwNeeded)
				If pi2 <> NULL Then
					If GetPrinter(hPrinter, 2, Cast(LPBYTE, pi2), dwNeeded, @dwNeeded) <> 0 Then
						pi2->pDevMode = pDevMode
						SetPrinter(hPrinter, 2, Cast(LPBYTE, pi2), 0)
					End If
					_Deallocate((pi2))
				End If
			End If
			
			' Освобождаем память
			_Deallocate((pDevMode))
			
			ClosePrinter(hPrinter)
		#endif
		Return True
	End Function
	
	Private Function Printer.GetPrinterNeededSize(ByRef PrinterName As WString) As Long
		#ifdef __USE_WINAPI__
			Dim As WStringListItem Ptr li
			Var Idx = PrinterSizesList.IndexOf(PrinterName, , , , li)
			If Idx >= 0 Then
				Return CInt(li->Object)
			End If
			
			Dim As .HANDLE hPrinter
			Dim As PRINTER_DEFAULTS pd
			Dim As DEVMODE Ptr pDevMode
			Dim As Long dwNeeded
			
			pd.pDatatype = NULL
			pd.pDevMode = NULL
			pd.DesiredAccess = PRINTER_ACCESS_USE
			
			If OpenPrinter(@PrinterName, @hPrinter, @pd) = 0 Then
				Print "Failed to open printer"
				Return -1
			End If
			
			dwNeeded = DocumentProperties(NULL, hPrinter, @PrinterName, NULL, NULL, 0)
			If dwNeeded <= 0 Then
				Print "DocumentProperties (1) did not return size"
				ClosePrinter(hPrinter)
				Return -1
			End If
			
			ClosePrinter(hPrinter)
			
			PrinterSizesList.Add PrinterName, Cast(Any Ptr, CInt(dwNeeded))
			
			Return dwNeeded
		#endif
	End Function
	
	' ========================================================================================
	' Returns the printer orientation.
	' The return value can be one of the following:
	' - DMORIENT_PORTRAIT = Portrait
	' - DMORIENT_LANDSCAPE = Landscape
	' ========================================================================================
	Private Function Printer.GetPrinterOrientation (ByRef PrinterName As WString) As Long
		#ifndef __USE_GTK__
			Dim As .HANDLE hPrinter
			Dim As PRINTER_DEFAULTS pd
			Dim As DEVMODE Ptr pDevMode
			Dim As Long dwNeeded, nRet
			
			' Настраиваем структуру по умолчанию
			pd.pDatatype = NULL
			pd.pDevMode = NULL
			pd.DesiredAccess = PRINTER_ACCESS_USE
			
			' Открываем принтер
			If OpenPrinter(@PrinterName, @hPrinter, @pd) = 0 Then
				Print "Failed to open printer"
				Return -1
			End If
			
			' Узнаем размер буфера DEVMODE
			dwNeeded = GetPrinterNeededSize(PrinterName)
			If dwNeeded <= 0 Then
				Print "DocumentProperties (1) did not return size"
				ClosePrinter(hPrinter)
				Return -1
			End If
			
			' Выделяем память под DEVMODE
			pDevMode = Cast(DEVMODE Ptr, GlobalAlloc(GMEM_FIXED Or GMEM_ZEROINIT, dwNeeded))
			If pDevMode = NULL Then
				Print "GlobalAlloc error"
				ClosePrinter(hPrinter)
				Return -1
			End If
			
			' Получаем структуру DEVMODE
			nRet = DocumentProperties(NULL, hPrinter, @PrinterName, pDevMode, NULL, DM_OUT_BUFFER)
			If nRet <> IDOK Then
				Print "DocumentProperties(2) returned an error " & nRet
				GlobalFree(pDevMode)
				ClosePrinter(hPrinter)
				Return -1
			End If
			
			' Читаем ориентацию
			Dim iOrientation As Integer = pDevMode->dmOrientation
			
			' Освобождаем ресурсы
			GlobalFree(pDevMode)
			ClosePrinter(hPrinter)
			
			Return iOrientation
		#else
			Function = 0
		#endif
	End Function
	
	
	Private Property Printer.Name(vData As String)
		m_Name= vData
		GetPrinterPaperSizes(m_Name)
	End Property
	
	Private Property Printer.Name As String
		Return m_Name
	End Property
	
	
	Private Property Printer.PortName(vData As String)
	End Property
	
	Private Property Printer.PortName As String
		m_PortName=GetPrinterPort (printerName)
		Return m_PortName
	End Property
	
	
	Private Property Printer.Page(vData As Integer)
		m_Page=vData
	End Property
	
	Private Property Printer.Page As Integer
		Return m_Page
	End Property
	
	
	Private Property Printer.PageSize(vData As Integer)
		m_PageSize = vData
		SetPrinterPaperSize printerName, vData
	End Property
	
	Private Property Printer.PageSize As Integer
		Return m_PageSize
	End Property
	
	Private Property Printer.Copies(vData As Integer)
		m_Copies=vData
		SetPrinterCopies ( printerName ,vData)
	End Property
	
	Private Property Printer.Copies As Integer
		Return m_Copies
	End Property
	
	Private Property Printer.Quality(vData As PrinterQuality)
		m_Quality=vData
		SetPrinterQuality (printerName, vData)
	End Property
	
	Private Property Printer.Quality As PrinterQuality
		m_Quality=GetPrinterQualityMode (printerName)
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
		Return GetPrinterScale ( printerName )
	End Property
	
	Private Property Printer.ScaleFactorX () As Long
		Return GetPrinterScalingFactorX ( printerName )
	End Property
	
	Private Property Printer.ScaleFactorY () As Long
		Return GetPrinterScalingFactorY ( printerName)
	End Property
	
	Private Property Printer.ColorMode (ByVal nMode As Long)
		SetPrinterColorMode (printerName ,nMode)
		m_ColorMode=nMode
	End Property
	
	Private Property Printer.ColorMode () As Long
		Return  m_ColorMode
	End Property
	
	Private Property Printer.DriveVersion () As Long
		Return GetPrinterDriverVersion ( printerName )
	End Property
	
	Private Property  Printer.PrintableWidth() As Long
		Dim As Long nResult, pixHorzRes, mmHorzSize
		#ifndef __USE_GTK__
			Dim hdc As HDC
			'hdc = CreateIC (ByVal NULL,   printerName, ByVal NULL, ByVal NULL)
			hdc = GetDC(0)
			If hdc = 0 Then Exit Property
			If Orientation = PrinterOrientation.poPortait Then
				nResult = PageWidth
			Else
				nResult = PageLength
			End If
			pixHorzRes = GetDeviceCaps(hdc, HORZRES)
			mmHorzSize = GetDeviceCaps(hdc, HORZSIZE)
			nResult = nResult * pixHorzRes / mmHorzSize / 10
			ReleaseDC 0, hdc
			'DeleteDC hdc
		#endif
		Return nResult
		'Return GetPrinterHorizontalResolution(printerName)
	End Property
	
	
	Private Property  Printer.PrintableHeight() As Long
		Dim As Long nResult, pixVertRes, mmVertSize
		#ifndef __USE_GTK__
			Dim hdc As HDC
			'hdc = CreateIC (ByVal NULL,   printerName, ByVal NULL, ByVal NULL)
			hdc = GetDC(0)
			If hdc = 0 Then Exit Property
			If Orientation = PrinterOrientation.poPortait Then
				nResult = PageLength
			Else
				nResult = PageWidth
			End If
			pixVertRes = GetDeviceCaps(hdc, VERTRES)
			mmVertSize = GetDeviceCaps(hdc, VERTSIZE)
			nResult = nResult * pixVertRes / mmVertSize / 10
			ReleaseDC 0, hdc
			'DeleteDC hdc
		#endif
		Return nResult
		'Return GetPrinterVerticalResolution(printerName)
	End Property
	
	Private Property  Printer.MaxCopies () As Long
		Return GetPrinterMaxCopies (printerName)
	End Property
	
	Private Property  Printer.MaxPaperHeight () As Long
		Return GetPrinterMaxPaperHeight (printerName )
	End Property
	
	Private Property  Printer.MaxPaperWidth () As Long
		Return GetPrinterMaxPaperWidth (printerName )
	End Property
	
	#ifndef __USE_GTK__
		Private Property Printer.Handle() As HDC
			If m_hdc  = 0 Then printerName = This.DefaultPrinter()
			Return m_hdc
		End Property
	#endif
	
	Private Property Printer.PageWidth As  Integer
		#ifndef __USE_GTK__
			Return GetDocumentProperties(DM_PAPERWIDTH)
		#else
			Return 0
		#endif
	End Property
	
	Private Property Printer.PageLength() As Integer
		#ifndef __USE_GTK__
			Return GetDocumentProperties(DM_PAPERLENGTH)
		#else
			Return 0
		#endif
	End Property
	
	Private Property Printer.MarginLeft As  Integer
		Return leftMargin
	End Property
	
	Private Property Printer.MarginLeft(value As  Integer)
		leftMargin =value
	End Property
	
	Private Property Printer.MarginTop As  Integer
		Return topMargin
	End Property
	
	Private Property Printer.MarginTop(value As  Integer)
		topMargin =value
	End Property
	
	
	Private Property Printer.MarginRight As  Integer
		Return rightMargin
	End Property
	
	Private Property Printer.MarginRight(value As  Integer)
		rightMargin =value
	End Property
	
	
	Private Property Printer.Marginbottom As  Integer
		Return bottomMargin
	End Property
	
	Private Property Printer.Marginbottom(value As  Integer)
		bottomMargin =value
	End Property
	
	
	Private Function Printer.DefaultPrinter() As String    'determine default printer and device context handle
		#ifndef __USE_GTK__
			Dim hPrinter As .HANDLE, dwNeeded As Long, n As Long
			Dim tm As TEXTMETRIC, sz As WString * 128
			Dim As HGLOBAL hDevMode
			Dim pDevMode As LPVOID
			GetProfileString "WINDOWS", "DEVICE", "", sz, 127
			sz = Trim(Parse(sz, ",", 1)): printerName = sz
			'OpenPrinter(sz, @hPrinter, NULL) 'to obtain hPrinter
			'dwNeeded = GetPrinterNeededSize(PrinterName)
			'hDevMode = Cast(DEVMODE Ptr,GlobalAlloc( GHND_, dwNeeded))
			'pDevMode = GlobalLock(Cast(HGLOBAL, hDevMode))
			'DocumentProperties 0, hPrinter, @sz,  pDevMode, NULL,  DM_OUT_BUFFER
			'm_hdc = CreateDC("WINSPOOL", sz, NULL, pDevMode)
			'
			'Canvas.SetHandle m_hdc
			'
			'GlobalUnlock hDevMode
			'GlobalFree(hDevMode)
			'
			'ClosePrinter hPrinter
			''canvas.Font.parent=hPrinter
			'
			'
			'GetTextMetrics m_hdc, @tm
			'n = tm.tmHeight + tm.tmExternalLeading
			'charHt = n
			'DeleteDC(m_hdc)
		#endif
		Return printerName
	End Function
	
	Private Function Printer.ChoosePrinter() As String  'choose printer and determine device context handle
		Dim n As Long
		#ifndef __USE_GTK__
			Dim hPrinter As HWND
			Dim pd As PRINTDLG , pDevNames As DEVNAMES Ptr
			Dim tm As TEXTMETRIC, psz As ZString Ptr
			pd.lStructSize = SizeOf(pd)
			pd.Flags =  PD_RETURNDC Or  PD_HIDEPRINTTOFILE Or PD_PRINTSETUP
			pd.Flags = pd.Flags Or  PD_ALLPAGES Or  PD_NOSELECTION Or  PD_NOPAGENUMS
			If PRINTDLG(@pd) Then 'call print dialog to select printer
				pDevNames = GlobalLock(pd.hDevNames)
				psz =Cast(ZString Ptr,Cast(Byte Ptr, pDevNames) +  pDevNames->wDeviceOffset)
				printerName = *psz
				OpenPrinter(*psz, @hPrinter, NULL)
				m_hdc = pd.hDC
				GlobalUnlock pd.hDevNames
				
			End If
			
			GetTextMetrics m_hdc , @tm
			n = tm.tmHeight + tm.tmExternalLeading
			charHt = n
			hDevMode = pd.hDevMode
			Canvas.SetHandle m_hdc
			'canvas.Font.parent=hPrinter
		#endif
		Return printerName
		
	End Function
	
	#ifndef __USE_GTK__
		Private Function Printer.newFont(fName As String, fSize As Long, ibold As Long = False, iunderline As Long = False, iitalic As Long = False ) As HFONT
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
	
	Private Property Printer.DuplexMode() As PrinterDuplexMode
		#ifndef __USE_GTK__
			m_Duplex=GetPrinterDuplex (printerName)
		#endif
		Return m_Duplex
	End Property
	
	Private Property Printer.DuplexMode(n As PrinterDuplexMode)   'n = 1 Simplex  'n = 2 Horizontal  'n = 3 Vertical
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
	
	Private Sub Printer.orientPrint(n As Long) 'n = 1 Portrait 'n = 2 Landscape
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
	
	Private Property Printer.Orientation(value As PrinterOrientation)
		SetPrinterOrientation2(printerName, value) ' orientPrint(value)
	End Property
	
	Private Property Printer.Orientation() As PrinterOrientation
		Return GetPrinterOrientation(printerName)
	End Property
	
	
	
	
	
	
	Private Sub Printer.UpdateMargeins()
		'x, y are measured from the left and top edges of the paper
		'if x or y are omitted then last valuew, xLast, yLast are used
		Dim As Long xc, yc, xm, leftNoPrn, rightNoPrn, topNoPrn, bottomNoPrn
		Dim As Long paperWi, paperHt, xMax, yMax, xppi, yppi
		#ifndef __USE_GTK__
			If m_hdc  = 0 Then printerName=This.DefaultPrinter
			paperWi = GetDeviceCaps(m_hdc ,  PHYSICALWIDTH)
			paperHt = GetDeviceCaps(m_hdc ,  PHYSICALHEIGHT)
			leftNoPrn = GetDeviceCaps(m_hdc ,  PHYSICALOFFSETX)
			rightNoPrn = paperWi - leftNoPrn - GetDeviceCaps(m_hdc ,HORZRES)
			topNoPrn = GetDeviceCaps(m_hdc ,  PHYSICALOFFSETY)
			bottomNoPrn = paperHt - topNoPrn - GetDeviceCaps(m_hdc ,VERTRES)
			xppi = GetDeviceCaps(m_hdc ,  LOGPIXELSX): yppi = GetDeviceCaps(m_hdc ,LOGPIXELSY)
			xMax = paperWi - leftNoPrn -  rightMargin
			yMax = paperHt - topNoPrn -   bottomMargin
			
			leftMargin= Max(leftMargin,leftNoPrn)
			topMargin =  Max(topNoPrn,topMargin)
		#endif
	End Sub
	
	Private Property Printer.Title( value As String)
		FTitle=value
	End Property
	
	Private Property Printer.Title() As String
		Return FTitle
	End Property
	
	Private Sub Printer.StartDoc()
		#ifndef __USE_GTK__
			Dim nErr As Long, sz As WString*64
			Dim di As DOCINFO
			If m_hdc  = 0 Then printerName=This.defaultprinter
			sz = FTitle
			di.cbSize = SizeOf(DOCINFO)
			di.lpszDocName = VarPtr(sz)
			nErr = .StartDoc(m_hdc , @di)
			If nErr <= 0 Then This.reportError(1)
		#endif
	End Sub
	
	Private Sub Printer.StartPage
		#ifndef __USE_GTK__
			Dim nErr As Long
			nErr = .StartPage(m_hdc )
			If nErr <= 0 Then This.reportError(2)
		#endif
	End Sub
	
	Private Sub Printer.EndDPage
		#ifndef __USE_GTK__
			.EndPage(m_hdc )
		#endif
	End Sub
	
	Private Sub Printer.NewPage
		#ifndef __USE_GTK__
			.EndPage(m_hdc )
			.StartPage(m_hdc)
			FPageNumber+=1
		#endif
	End Sub
	
	Private Sub Printer.EndDoc
		#ifndef __USE_GTK__
			.EndDoc(m_hdc )
			SelectObject m_hdc , hOrigFont
			DeleteObject m_hFont
			DeleteDC m_hdc
			origDuplex = 0
			origOrient = 0
			hOrigFont = 0
		#endif
	End Sub
	
	
	'------------------------------------------------------------------------------
	' Calculate the text resolution based on the default font for the Device
	' Context. Works with both window and printer DC's. Requires %MM_TEXT mode.
	'
	Private Sub Printer.CalcPageSize(ByRef Rows As Long, ByRef Columns As Long)
		#ifndef __USE_GTK__
			Dim tm As TEXTMETRIC
			GetTextMetrics m_hdc, @tm
			Rows    = GetDeviceCaps(m_hdc, VERTRES) \ (tm.tmHeight + tm.tmExternalLeading)
			Columns = GetDeviceCaps(m_hdc, HORZRES) \ tm.tmAveCharWidth
		#endif
	End Sub
	
	Private Function Printer.PrinterPaperNames (ByRef PrinterName As WString) As String
		Dim Names As String
		#ifndef __USE_GTK__
			Dim i As Long
			Dim r As Long
			r = DeviceCapabilities (@PrinterName, ByVal NULL, DC_PAPERNAMES, ByVal NULL, ByVal NULL)
			If r = -1 Then Exit Function
			ReDim wszNames(r - 1) As WString * 64
			r = DeviceCapabilities (@PrinterName, ByVal NULL, DC_PAPERNAMES, @wszNames(0), ByVal NULL)
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
	Private Function Printer.GetPrinterPaperSizesAsString(ByRef PrinterName As WString) As String
		Dim i As Long, r As Long, Sizes As String
		#ifndef __USE_GTK__
			r = DeviceCapabilities (PrinterName, ByVal NULL, DC_PAPERSIZE, ByVal NULL, ByVal NULL)
			If r = -1 Then Exit Function
			ReDim pSizes(r - 1) As Point
			r = DeviceCapabilities (PrinterName, ByVal NULL, DC_PAPERSIZE, Cast( LPTSTR,@pSizes(0)), ByVal NULL)
			If r < 1 Then Exit Function
			For i = 0 To r - 1
				Sizes += WStr(pSizes(i).X) & " x " & WStr(pSizes(i).Y)
				If i < r - 1 Then Sizes += CRLF
			Next
		#endif
		Function = Sizes
	End Function
	
	Sub Printer.GetPrinterPaperSizes(ByRef PrinterName As WString)
		Dim paperCount As Integer
		Dim paperIDs As Integer Ptr
		Dim paperNames As WString Ptr
		Dim paperWidth As Integer
		Dim paperHeight As Integer
		Dim i As Integer
		
		#ifdef __USE_WINAPI__
			' Получаем количество поддерживаемых размеров бумаги
			paperCount = DeviceCapabilities(@PrinterName, NULL, DC_PAPERS, NULL, NULL)
			
			If paperCount <= 0 Then
				Print "Не удалось получить размеры бумаги."
				Exit Sub
			End If
			
			' Получаем названия размеров бумаги
			paperNames = _Allocate(Len(WString) * CInt(64) * paperCount) ' 64 символа на название
			If paperNames = NULL Then
				Print "Ошибка выделения памяти для названий бумаги."
				'_Deallocate((paperIDs))
				Exit Sub
			End If
			
			' Получаем список размеров бумаги
			ReDim paperKinds(paperCount - 1) As Short
			DeviceCapabilities(@PrinterName, ByVal NULL, DC_PAPERS, Cast(LPWSTR, @paperKinds(0)), ByVal NULL)
			
			DeviceCapabilities(@PrinterName, ByVal NULL, DC_PAPERNAMES, Cast(LPWSTR, paperNames), ByVal NULL)
			
			ReDim pSizes(paperCount - 1) As ..Point
			DeviceCapabilities (@PrinterName, ByVal NULL, DC_PAPERSIZE, Cast(LPWSTR, @pSizes(0)), ByVal NULL)
			
			PaperSizes.Clear
			Dim pPaperSize As PaperSize Ptr
			
			' Печатаем список размеров бумаги
			For i = 0 To paperCount - 1
				pPaperSize = PaperSizes.Add
				pPaperSize->Kind = paperKinds(i)
				pPaperSize->RawKind = paperKinds(i)
				pPaperSize->PaperName = *Cast(WString Ptr, Cast(Integer, paperNames) + i * 64 * 2)
				pPaperSize->Width = pSizes(i).x ' " десятых миллиметра"
				pPaperSize->Height = pSizes(i).y ' " десятых миллиметра"
			Next
			
			' Освобождаем выделенную память
			'_Deallocate((paperIDs))
			_Deallocate((paperNames))
		#endif
	End Sub
	
	Private Function Printer.GetPrinterPort (ByRef PrinterName As WString) As String ' Returns the port name for a given printer name.
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
	Private Function Printer.GetPrinterQualityMode (ByRef PrinterName As WString) As PrinterQuality
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
			dwNeeded = GetPrinterNeededSize(PrinterName)
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
	Private Function Printer.GetPrinterScale (ByRef PrinterName As WString) As Long
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
			dwNeeded = GetPrinterNeededSize(PrinterName)
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
	
	Private Function Printer.GetPrinterScalingFactorX (ByRef PrinterName As WString) As Long  ' Scaling factor for the x-axis of the printer.
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
	
	
	
	Private Function printer.GetPrinterScalingFactorY (ByRef PrinterName As WString) As Long ' Scaling factor for the y-axis of the printer.
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
	Private Function printer.SetPrinterColorMode (ByRef PrinterName As WString, ByVal nMode As Long) As Long
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
				dwNeeded = GetPrinterNeededSize(PrinterName)
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
	Private Function printer.SetPrinterCopies (ByRef PrinterName As WString, ByVal nCopies As Long) As Long
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
				dwNeeded = GetPrinterNeededSize(PrinterName)
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
	Private Function printer.SetPrinterDuplexMode (ByRef PrinterName As WString, ByVal nDuplexMode As Long) As Long
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
				dwNeeded = GetPrinterNeededSize(PrinterName)
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
	
	
	
	Private Function Printer.SetPrinterPaperSize (ByRef PrinterName As WString, ByVal nSize As Long) As Long ' Sets the printer paper size.
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
				dwNeeded = GetPrinterNeededSize(PrinterName)
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
			pi2->pDevMode->dmFields = DM_PAPERSIZE
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
	
	Private Function Printer.SetPrinterQuality (ByRef PrinterName As WString, ByVal nMode As PrinterQuality) As Long ' Specifies the printer resolution.
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
				dwNeeded = GetPrinterNeededSize(PrinterName)
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
	
	
	Private Function Printer.GetPrinterDriverVersion (ByRef PrinterName As WString) As Long  ' Returns the version number of the printer driver.
		#ifndef __USE_GTK__
			Function = DeviceCapabilities (PrinterName, ByVal NULL, DC_DRIVER, ByVal NULL, ByVal NULL)
		#else
			Function = 0
		#endif
	End Function
	
	Private Function Printer.GetPrinterDuplex (ByRef PrinterName As WString) As Long  ' If the printer supports duplex printing, the return value is 1; otherwise, the return value is zero.
		#ifndef __USE_GTK__
			Function = DeviceCapabilities (PrinterName, ByVal NULL, DC_DUPLEX, ByVal NULL, ByVal NULL)
		#else
			Function = 0
		#endif
	End Function
	
	
	Private Function Printer.GetPrinterFromPort (ByRef sPortName As WString) As String ' Returns the printer name for a given port name.
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
			If Len(Names) Then Names = ..Left(Names, Len(Names) - 2)
		#endif
		Function = Names
	End Function
	
	
	Private Function Printer.GetPrinterHorizontalResolution (ByRef PrinterName As WString) As Long ' Width, in pixels, of the printable area of the page.
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
	
	
	Private Function Printer.GetPrinterVerticalResolution (ByRef PrinterName As WString) As Long ' Width, in pixels, of the printable area of the page.
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
	
	#ifdef __USE_WINAPI__
		Private Function Printer.GetDocumentProperties(dField As DWORD) As Long
			Dim hPrinter As ..HANDLE
			If OpenPrinter(m_Name, @hPrinter, NULL) = False Then Return 0
			Dim cbNeeded As DWORD = DocumentProperties(NULL, hPrinter, m_Name, NULL, NULL, 0)
			Dim bufferDoc As String = Space(cbNeeded)
			Dim Result As Long = DocumentProperties(NULL, hPrinter, m_Name, Cast(DEVMODEW Ptr, StrPtr(bufferDoc)), NULL, DM_OUT_BUFFER)
			If Result = IDOK Then
				Dim pDevMode As DEVMODEW Ptr = Cast(DEVMODEW Ptr, StrPtr(bufferDoc))
				ClosePrinter(hPrinter)
				Select Case dField
				Case DM_COLLATE       : Return pDevMode->dmCollate
				Case DM_COPIES        : Return pDevMode->dmCopies
				Case DM_ORIENTATION   : Return pDevMode->dmOrientation
				Case DM_PAPERSIZE     : Return pDevMode->dmPaperSize
				Case DM_PRINTQUALITY  : Return pDevMode->dmPrintQuality
				Case DM_SCALE         : Return pDevMode->dmScale
				Case DM_DEFAULTSOURCE : Return pDevMode->dmDefaultSource
				Case DM_PAPERLENGTH   : Return pDevMode->dmPaperLength
				Case DM_PAPERWIDTH    : Return pDevMode->dmPaperWidth
				Case DM_DUPLEX        : Return pDevMode->dmDuplex
				End Select
			End If
			Return Result
		End Function
	#endif
	
	Private Function Printer.GetPrinterMaxCopies (ByRef PrinterName As WString) As Long
		#ifndef __USE_GTK__
			Function = DeviceCapabilities (  PrinterName, ByVal NULL, DC_COPIES, ByVal NULL, ByVal NULL)
		#else
			Function = 0
		#endif
	End Function
	
	Private Function Printer.GetPrinterMaxPaperHeight (ByRef PrinterName As WString) As Long  ' Returns the maximum paper width in tenths of a millimeter.
		#ifndef __USE_GTK__
			Dim r As Long
			r = DeviceCapabilities (PrinterName, ByVal NULL,DC_MAXEXTENT, ByVal NULL, ByVal NULL)
			If r = -1 Then Exit Function
			Function = HiWord( r)
		#else
			Function = 0
		#endif
	End Function
	
	Private Function Printer.GetPrinterMaxPaperWidth (ByRef PrinterName As WString) As Long ' Returns the maximum paper width in tenths of a millimeter.
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
	Private Function Printer.EnumPrinterPorts () As String
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
	Private Function Printer.EnumPrinters_ () As String
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
	
	Private Function Printer.GetDefaultPrinterDevice () As String  ' Retrieves the name of the default printer device.
		#ifndef __USE_GTK__
			Dim buffer As ZString * MAX_PATH
			GetProfileString "WINDOWS", "DEVICE", "", buffer, SizeOf(buffer)
			Function = Parse (buffer, 2)
		#else
			Function = ""
		#endif
	End Function
	
	
	Private Function Printer.GetDefaultPrinterDriver () As String  ' Retrieves the name of the default printer driver.
		#ifndef __USE_GTK__
			Dim buffer As ZString * MAX_PATH
			GetProfileString "WINDOWS", "DEVICE", "", buffer, SizeOf(buffer)
			Function = Parse (buffer, 1)
		#else
			Function = ""
		#endif
	End Function
	
	
	Private Function Printer.GetDefaultPrinterPort () As String  ' Retrieves the name of the default printer port.
		#ifndef __USE_GTK__
			Dim buffer As ZString * MAX_PATH
			GetProfileString  "WINDOWS", "DEVICE", "", buffer, SizeOf(buffer)
			Function = Parse (buffer, 3)
		#else
			Function = ""
		#endif
	End Function
	
	Private Sub Printer.ShowPrinterProperties()
		#ifndef __USE_GTK__
			Dim hPrinter As HWND
			OpenPrinter printerName, @hPrinter, ByVal 0&
			PrinterProperties  GetActiveWindow(), hPrinter
			ClosePrinter hPrinter
		#endif
	End Sub
	
	
	Private Constructor Printer
		Canvas.Ctrl = @This
		WLet(FClassName, "Printer")
	End Constructor
End Namespace
