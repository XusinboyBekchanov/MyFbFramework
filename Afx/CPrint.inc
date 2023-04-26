' ########################################################################################
' Microsoft Windows
' File: CPrint.inc
' Contents: Class for printing
' Compiler: FreeBasic 32 & 64-bit
' Copyright (c) 2018 José Roca. Freeware. Use at your own risk.
' THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
' EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
' MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
' ########################################################################################

#pragma once
#include once "windows.bi"
#INCLUDE ONCE "win/winspool.bi"
#INCLUDE ONCE "win/shellapi.bi"
#INCLUDE ONCE "win/commdlg.bi"
#INCLUDE ONCE "Afx/AfxGdiplus.inc"
#INCLUDE ONCE "Afx/CWSTR.inc"
#INCLUDE ONCE "Afx/AfxStr.inc"

NAMESPACE Afx

' ========================================================================================
' CPrint class
' ========================================================================================
TYPE CPrint

Public:
   m_hDC AS HDC
   m_wszPrinterName AS WSTRING * 260

Public:
   DECLARE CONSTRUCTOR
   DECLARE DESTRUCTOR
   DECLARE FUNCTION GetDefaultPrinter () AS CWSTR
   DECLARE FUNCTION GetDefaultPrinterDriver () AS CWSTR
   DECLARE FUNCTION GetDefaultPrinterPort () AS CWSTR
   DECLARE FUNCTION ChoosePrinter (BYVAL hwndOwner AS HWND = NULL) AS BOOLEAN
   DECLARE FUNCTION EnumPrinterNames () AS CWSTR
   DECLARE FUNCTION AttachPrinter (BYREF wszPrinterName AS WSTRING = "") AS BOOLEAN
   DECLARE FUNCTION PageSetup (BYVAL hwndOwner AS HWND = NULL) AS BOOLEAN
   DECLARE FUNCTION GetDC () AS HDC
   DECLARE FUNCTION GetPrinterName () AS CWSTR
   DECLARE FUNCTION GetPPIX () AS LONG
   DECLARE FUNCTION GetPPIY () AS LONG
   DECLARE FUNCTION GetHorizontalUnits () AS LONG
   DECLARE FUNCTION GetVerticalUnits () AS LONG
   DECLARE FUNCTION GetHorizontalResolution () AS LONG
   DECLARE FUNCTION GetVerticalResolution () AS LONG
   DECLARE FUNCTION PixelsToUnitsX (BYVAL pix AS LONG) AS LONG
   DECLARE FUNCTION PixelsToUnitsY (BYVAL pix AS LONG) AS LONG
   DECLARE FUNCTION UnitsToPixelsX (BYVAL units AS LONG) AS LONG
   DECLARE FUNCTION UnitsToPixelsY (BYVAL units AS LONG) AS LONG
   DECLARE FUNCTION PixelsToPointsX (BYVAL pix AS LONG) AS LONG
   DECLARE FUNCTION PixelsToPointsY (BYVAL pix AS LONG) AS LONG
   DECLARE FUNCTION PointsToPixelsX (BYVAL pts AS LONG) AS LONG
   DECLARE FUNCTION PointsToPixelsY (BYVAL pts AS LONG) AS LONG
   DECLARE FUNCTION GetDocumentProperties (BYVAL dmField AS DWORD) AS LONG
   DECLARE FUNCTION SetPrinterInfo (BYVAL dmField AS DWORD, BYVAL nValue AS LONG) AS BOOLEAN
   DECLARE PROPERTY Collate () AS BOOLEAN
   DECLARE PROPERTY CollateMode () AS LONG
   DECLARE PROPERTY CollateMode (BYVAL nMode AS LONG)
   DECLARE PROPERTY Color () AS BOOLEAN
   DECLARE PROPERTY ColorMode () AS LONG
   DECLARE PROPERTY ColorMode (BYVAL nMode AS LONG)
   DECLARE PROPERTY Copies () AS LONG
   DECLARE PROPERTY Copies (BYVAL nCopies AS LONG)
   DECLARE PROPERTY Duplex () AS BOOLEAN
   DECLARE PROPERTY DuplexMode () AS LONG
   DECLARE PROPERTY DuplexMode (BYVAL nDuplexMode AS LONG)
   DECLARE PROPERTY Orientation () AS LONG
   DECLARE PROPERTY Orientation (BYVAL nOrientation AS LONG)
   DECLARE PROPERTY PaperSize () AS LONG
   DECLARE PROPERTY PaperSize (BYVAL nSize AS LONG)
   DECLARE FUNCTION SetPaperSize (BYVAL nLength AS LONG, BYVAL nWidth AS LONG) AS BOOLEAN
   DECLARE PROPERTY PaperLength () AS LONG
   DECLARE PROPERTY PaperLength (BYVAL nLength AS LONG)
   DECLARE PROPERTY PaperWidth () AS LONG
   DECLARE PROPERTY PaperWidth (BYVAL nWidth AS LONG)
   DECLARE FUNCTION GetPaperNames () AS CWSTR
   DECLARE PROPERTY Quality () AS LONG
   DECLARE PROPERTY Quality (BYVAL nMode AS LONG)
   DECLARE FUNCTION GetTrayNames () AS CWSTR
   DECLARE PROPERTY Scale () AS LONG
   DECLARE PROPERTY Scale (BYVAL nScale AS LONG)
   DECLARE PROPERTY Tray () AS LONG
   DECLARE PROPERTY Tray (BYVAL nTray AS LONG)
   DECLARE SUB GetMarginPixels (BYREF nLeft AS LONG, BYREF nTop AS LONG, BYREF nRight AS LONG, BYREF nBottom AS LONG)
   DECLARE SUB GetMarginUnits (BYREF nLeft AS LONG, BYREF nTop AS LONG, BYREF nRight AS LONG, BYREF nBottom AS LONG)
   DECLARE FUNCTION PrintBitmap (BYREF wszDocName AS WSTRING, BYVAL hbmp AS HBITMAP, BYVAL bStretch AS BOOLEAN = FALSE, _
                    BYVAL nStretchMode AS LONG = InterpolationModeHighQualityBicubic) AS BOOLEAN
   DECLARE FUNCTION PrintBitmapToFile (BYREF wszDocName AS WSTRING, BYREF wszOutputFileName AS WSTRING, BYVAL hbmp AS HBITMAP, BYVAL bStretch AS BOOLEAN = FALSE, _
                    BYVAL nStretchMode AS LONG = InterpolationModeHighQualityBicubic) AS BOOLEAN

END TYPE
' ========================================================================================

' ========================================================================================
' CPrint constructor
' ========================================================================================
PRIVATE CONSTRUCTOR CPrint
END CONSTRUCTOR
' ========================================================================================

' ========================================================================================
' CPrint destructor
' ========================================================================================
PRIVATE DESTRUCTOR CPrint
   IF m_hDC then DeleteDC m_hDC
END DESTRUCTOR
' ========================================================================================

' ========================================================================================
' Retrieves the name of the default printer.
' ========================================================================================
PRIVATE FUNCTION CPrint.GetDefaultPrinter () AS CWSTR
   DIM buffer AS WSTRING * MAX_PATH
   GetProfileStringW "WINDOWS", "DEVICE", "", buffer, SIZEOF(buffer)
   RETURN AfxStrParse(buffer, 1, ",")
END FUNCTION
' ========================================================================================

' ========================================================================================
' Retrieves the name of the default printer driver.
' ========================================================================================
PRIVATE FUNCTION CPrint.GetDefaultPrinterDriver () AS CWSTR
   DIM buffer AS WSTRING * MAX_PATH
   GetProfileStringW "WINDOWS", "DEVICE", "", buffer, SIZEOF(buffer)
   RETURN AfxStrParse(buffer, 2, ",")
END FUNCTION
' ========================================================================================

' ========================================================================================
' Retrieves the name of the default printer port.
' ========================================================================================
PRIVATE FUNCTION CPrint.GetDefaultPrinterPort () AS CWSTR
   DIM buffer AS WSTRING * MAX_PATH
   GetProfileStringW "WINDOWS", "DEVICE", "", buffer, SIZEOF(buffer)
   RETURN AfxStrParse(buffer, 3, ",")
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns a list with the available printers, print servers, domains, or print providers.
' Names are separated with a carriage return and a line feed characters.
' ========================================================================================
PRIVATE FUNCTION CPrint.EnumPrinterNames () AS CWSTR
   DIM i AS LONG, cbNeeded AS DWORD, cbReturned AS DWORD
   DIM Pi5(ANY) AS PRINTER_INFO_5W
   DIM wstrNames AS CWSTR
   DIM dwLevel AS DWORD = 5
   EnumPrintersW PRINTER_ENUM_LOCAL, NULL, dwLevel, NULL, 0, @cbNeeded, @cbReturned
   REDIM Pi5(0 TO cbNeeded \ SIZEOF(PRINTER_INFO_5W))
   EnumPrintersW PRINTER_ENUM_LOCAL, "", dwLevel, cast(BYTE PTR, VARPTR(Pi5(0))), _
         SIZEOF(PRINTER_INFO_5W) * (UBOUND(Pi5) + 1), @cbNeeded, @cbReturned
   FOR i = 0 TO cbReturned - 1
      wstrNames += *Pi5(i).pPrinterName
      IF i < cbReturned - 1 THEN wstrNames += CHR(13, 10)
   NEXT
   RETURN wstrNames
END FUNCTION
' ========================================================================================

' ========================================================================================
' Displays the printer dialog to select a printer.
' If the user clicks the OK button, the return value is true.
' If the user canceled or closed the Print dialog box or an error occurred, the return value is false.
' ========================================================================================
PRIVATE FUNCTION CPrint.ChoosePrinter (BYVAL hwndOwner AS HWND = NULL) AS BOOLEAN
   DIM pd AS PRINTDLGW
   pd.lStructSize = SIZEOF(pd)
   pd.hwndOwner = hwndOwner
   pd.flags = PD_RETURNDC OR PD_HIDEPRINTTOFILE OR PD_DISABLEPRINTTOFILE OR PD_NOSELECTION OR PD_NOPAGENUMS
   IF PrintDlgW(@pd) THEN
      IF pd.hDevMode THEN GlobalFree(pd.hDevMode)
      IF pd.hDevNames THEN
         DIM pName as WSTRING PTR
         DIM pdn AS DEVNAMES PTR
         pdn = GlobalLock(pd.hdevnames)
         pName = cast(WSTRING PTR, pdn) + pdn->wdeviceoffset
         m_wszPrinterName = *pName
         GlobalUnlock(pd.hdevnames)
         GlobalFree(pd.hDevNames)
      END IF
      IF m_hDC THEN DeleteDC m_hDC
      m_hDC = pd.hDC
      RETURN TRUE
   END IF
   RETURN FALSE
END FUNCTION
' ========================================================================================

' ========================================================================================
' Attaches the specified printer to the class. Returns true of false.
' Example:
' DIM pPrint AS CPrint
' pPrint.AttachPrinter("OKI DATA CORP B410")
' ========================================================================================
PRIVATE FUNCTION CPrint.AttachPrinter (BYREF wszPrinterName AS WSTRING = "") AS BOOLEAN
   m_wszPrinterName = wszPrinterName
   IF LEN(m_wszPrinterName) = 0 THEN m_wszPrinterName = this.GetDefaultPrinter
   ' // Create a device context for the printer
   DIM _hDC AS .HDC = CreateDCW(NULL, m_wszPrinterName, NULL, NULL)
   IF _hDC THEN
      IF m_hDC THEN DeleteDC m_hDC
      m_hDC = _hDC
      RETURN TRUE
   END IF
   RETURN FALSE
END FUNCTION
' ========================================================================================

' ========================================================================================
' Displays a Page Setup dialog box that enables the user to specify the attributes of a
' printed page. These attributes include the paper size and source, the page orientation
' (portrait or landscape), and the width of the page margins.
' ========================================================================================
PRIVATE FUNCTION CPrint.PageSetup (BYVAL hwndOwner AS HWND = NULL) AS BOOLEAN
   DIM psd AS PAGESETUPDLGW
   psd.lStructSize = SIZEOF(PAGESETUPDLGW)
   psd.hwndOwner = hwndOwner
   IF PageSetupDlgW(@psd) THEN
      IF psd.hDevMode THEN GlobalFree(psd.hDevMode)
      IF psd.hDevNames THEN GlobalFree(psd.hDevNames)
      RETURN TRUE
   END IF
   RETURN FALSE
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the handle of the device context of the attached printer
' ========================================================================================
PRIVATE FUNCTION CPrint.GetDC () AS HDC
   RETURN m_hDC
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the name of the attached printer
' ========================================================================================
PRIVATE FUNCTION CPrint.GetPrinterName () AS CWSTR
   RETURN m_wszPrinterName
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the number of pixels per inch of the specified host printer page (horizontal resolution).
' ========================================================================================
PRIVATE FUNCTION CPrint.GetPPIX () AS LONG
   IF m_hDC THEN RETURN GetDeviceCaps(m_hDC, LOGPIXELSX)
END FUNCTION
' ========================================================================================
' ========================================================================================
' Returns the number of pixels per inch of the specified host printer page (vertical resolution).
' ========================================================================================
PRIVATE FUNCTION CPrint.GetPPIY () AS LONG
   IF m_hDC THEN RETURN GetDeviceCaps(m_hDC, LOGPIXELSY)
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the width, in world units, of the printable area of the page.
' ========================================================================================
PRIVATE FUNCTION CPrint.GetHorizontalUnits () AS LONG
   IF m_hDC = NULL THEN RETURN 0
   ' // Get the horizontal PPI of the printer
   DIM ppix AS LONG = GetDeviceCaps(m_hDC, LOGPIXELSX)
   ' // Calculate the width according to the PPI of the printer
   RETURN GetDeviceCaps(m_hDC, HORZRES) / (ppix / 100)
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the height, in world units, of the printable area of the page.
' ========================================================================================
PRIVATE FUNCTION CPrint.GetVerticalUnits () AS LONG
   IF m_hDC = NULL THEN RETURN 0
   ' // Get the horizontal PPI of the printer
   DIM ppiy AS LONG = GetDeviceCaps(m_hDC, LOGPIXELSY)
   ' // Calculate the width according to the PPI of the printer
   RETURN GetDeviceCaps(m_hDC, VERTRES) / (ppiy / 100)
END FUNCTION
' ========================================================================================

' ========================================================================================
' Width, in pixels, of the printable area of the page.
' ========================================================================================
PRIVATE FUNCTION CPrint.GetHorizontalResolution () AS LONG
   IF m_hDC THEN RETURN GetDeviceCaps(m_hDC, HORZRES)
END FUNCTION
' ========================================================================================
' ========================================================================================
' Height, in pixels, of the printable area of the page.
' ========================================================================================
PRIVATE FUNCTION CPrint.GetVerticalResolution () AS LONG
   IF m_hDC THEN RETURN GetDeviceCaps(m_hDC, VERTRES)
END FUNCTION
' ========================================================================================

' ========================================================================================
' Converts pixels to world units.
' ========================================================================================
' Horizontal resolution
PRIVATE FUNCTION CPrint.PixelsToUnitsX (BYVAL pix AS LONG) AS LONG
   IF m_hDC = NULL THEN RETURN 0
   ' // Get the horizontal PPI of the printer
   DIM ppix AS LONG = GetDeviceCaps(m_hDC, LOGPIXELSX)
   ' // Calculate the size according to the PPI of the printer
   RETURN pix / (ppix / 100)
END FUNCTION
' ========================================================================================
' ========================================================================================
' Vertical resolution
PRIVATE FUNCTION CPrint.PixelsToUnitsY (BYVAL pix AS LONG) AS LONG
   IF m_hDC = NULL THEN RETURN 0
   ' // Get the vertical PPI of the printer
   DIM ppiy AS LONG = GetDeviceCaps(m_hDC, LOGPIXELSY)
   ' // Calculate the size according to the PPI of the printer
   RETURN pix / (ppiy / 100)
END FUNCTION
' ========================================================================================

' ========================================================================================
' Converts world units to pixels.
' ========================================================================================
' Horizontal resolution
PRIVATE FUNCTION CPrint.UnitsToPixelsX (BYVAL units AS LONG) AS LONG
   IF m_hDC = NULL THEN RETURN 0
   ' // Get the horizontal PPI of the printer
   DIM ppix AS LONG = GetDeviceCaps(m_hDC, LOGPIXELSX)
   ' // Calculate the size according to the PPI of the printer
   RETURN MulDiv(units, ppix, 100)
END FUNCTION
' ========================================================================================
' ========================================================================================
' Vertical resolution
PRIVATE FUNCTION CPrint.UnitsToPixelsY (BYVAL units AS LONG) AS LONG
   IF m_hDC = NULL THEN RETURN 0
   ' // Get the vertical PPI of the printer
   DIM ppiy AS LONG = GetDeviceCaps(m_hDC, LOGPIXELSY)
   ' // Calculate the size according to the PPI of the printer
   RETURN MulDiv(units, ppiy, 100)
END FUNCTION
' ========================================================================================

' ========================================================================================
' Converts pixels to point size (1/72 of an inch).
' ========================================================================================
' Horizontal resolution
PRIVATE FUNCTION CPrint.PixelsToPointsX (BYVAL pix AS LONG) AS LONG
   IF m_hDC = NULL THEN RETURN 0
   ' // Get the horizontal PPI of the printer
   DIM ppix AS LONG = GetDeviceCaps(m_hDC, LOGPIXELSX)
   ' // Calculate the size according to the PPI of the printer
   RETURN pix * 72 / ppix
END FUNCTION
' ========================================================================================
' ========================================================================================
' Vertical resolution
PRIVATE FUNCTION CPrint.PixelsToPointsY (BYVAL pix AS LONG) AS LONG
   IF m_hDC = NULL THEN RETURN 0
   ' // Get the vertical PPI of the printer
   DIM ppiy AS LONG = GetDeviceCaps(m_hDC, LOGPIXELSY)
   ' // Calculate the size according to the PPI of the printer
   RETURN pix * 72 / ppiy
END FUNCTION
' ========================================================================================

' ========================================================================================
' Converts a point size (1/72 of an inch) to pixels.
' ========================================================================================
' Horizontal resolution
PRIVATE FUNCTION CPrint.PointsToPixelsX (BYVAL pts AS LONG) AS LONG
   IF m_hDC = NULL THEN RETURN 0
   ' // Get the horizontal PPI of the printer
   DIM ppix AS LONG = GetDeviceCaps(m_hDC, LOGPIXELSX)
   ' // Calculate the size according to the PPI of the printer
   RETURN MulDiv(pts, ppix, 72)
END FUNCTION
' ========================================================================================
' ========================================================================================
' Vertical resolution
PRIVATE FUNCTION CPrint.PointsToPixelsY (BYVAL pts AS LONG) AS LONG
   IF m_hDC = NULL THEN RETURN 0
   ' // Get the vertical PPI of the printer
   DIM ppiy AS LONG = GetDeviceCaps(m_hDC, LOGPIXELSY)
   ' // Calculate the size according to the PPI of the printer
   RETURN MulDiv(pts, ppiy, 72)
END FUNCTION
' ========================================================================================

' ========================================================================================
' Retrieves printer initialization information.
' If the function is successful, the return value is IDOK (1).
' If the function fails, the return value is 0 or less than zero.
' ========================================================================================
PRIVATE FUNCTION CPrint.GetDocumentProperties (BYVAL dmField AS DWORD) AS LONG
   ' // Start by opening the printer
   DIM hPrinter AS HANDLE
   IF OpenPrinterW(m_wszPrinterName, @hPrinter, NULL) = FALSE THEN RETURN 0
   ' // Allocate a buffer of the correct size
   DIM cbNeeded AS DWORD = DocumentPropertiesW(NULL, hPrinter, m_wszPrinterName, NULL, NULL, 0)
   DIM bufferDoc AS STRING = SPACE(cbNeeded)
   ' // Retrieve the printer configuration data
   DIM nRet AS LONG = DocumentPropertiesW(NULL, hPrinter, m_wszPrinterName, _
      cast(DEVMODEW PTR, STRPTR(bufferDoc)), NULL, DM_OUT_BUFFER)
   IF nRet = IDOK THEN
      ' // Cast it to a DEVMODEW structure
      DIM pDevMode AS DEVMODEW PTR = cast(DEVMODEW PTR, STRPTR(bufferDoc))
      ' // Finished with the printer
      ClosePrinter(hPrinter)
      ' // Return the requested value
      SELECT CASE dmField
         CASE DM_COLLATE       : RETURN pDevMode->dmCollate
         CASE DM_COPIES        : RETURN pDevMode->dmCopies
         CASE DM_ORIENTATION   : RETURN pDevMode->dmOrientation
         CASE DM_PAPERSIZE     : RETURN pDevMode->dmPaperSize
         CASE DM_PRINTQUALITY  : RETURN pDevMode->dmPrintQuality
         CASE DM_SCALE         : RETURN pDevMode->dmScale
         CASE DM_DEFAULTSOURCE : RETURN pDevMode->dmDefaultSource
         CASE DM_PAPERLENGTH   : RETURN pDevMode->dmPaperLength
         CASE DM_PAPERWIDTH    : RETURN pDevMode->dmPaperWidth
         CASE DM_DUPLEX        : RETURN pDevMode->dmDuplex
      END SELECT
   END IF
   RETURN nRet
END FUNCTION
' ========================================================================================

' ========================================================================================
' Sets data for a specified printer.
' - wszPrinterName : The name of the printer.
' - dmField : Field to change
' - nValue  : New value
' ========================================================================================
PRIVATE FUNCTION CPrint.SetPrinterInfo (BYVAL dmField AS DWORD, BYVAL nValue AS LONG) AS BOOLEAN

   ' // Start by opening the printer
   DIM hPrinter AS HANDLE
   DIM pd AS PRINTER_DEFAULTSW
   pd.DesiredAccess = PRINTER_ALL_ACCESS
   IF OpenPrinterW(m_wszPrinterName, @hPrinter, @pd) = FALSE THEN RETURN FALSE

   ' // The first GetPrinterW call tells you how big the buffer should be in
   ' // order to hold all of PRINTER_INFO_2. Note that this should fail with
   ' // ERROR_INSUFFICIENT_BUFFER. If GetPrinterW fails for any other reason
   ' // or cbNeeded isn't set for some reason, then there is a problem...
   DIM dwLevel AS DWORD = 2, cbNeeded AS DWORD
   DIM nRet AS LONG = GetPrinterW(hPrinter, dwLevel, NULL, 0, @cbNeeded)
   IF nRet = 0 AND GetLastError <> ERROR_INSUFFICIENT_BUFFER THEN
      ClosePrinter(hPrinter)
      RETURN FALSE
   END IF

   ' // Allocate enough space for PRINTER_INFO_2...
   DIM bufferPrn AS STRING
   bufferPrn = SPACE(cbNeeded)
   ' // The second GetPrinterW fills in all the current settings, so all you
   ' // need to do is modify what you're interested in...
   nRet = GetPrinterW(hPrinter, dwLevel, CAST(BYTE PTR, STRPTR(bufferPrn)), cbNeeded, @cbNeeded)
   IF nRet = 0 THEN
      ClosePrinter(hPrinter)
      RETURN FALSE
   END IF

   ' // If GetPrinterW didn't fill in the DEVMODE, try to get it by calling DocumentProperties...
   DIM pi2 AS PRINTER_INFO_2W PTR
   pi2 = CAST(PRINTER_INFO_2W PTR, STRPTR(bufferPrn))
   DIM bufferDoc AS STRING
   DIM pDevMode AS DEVMODEW PTR
   IF pi2->pDevMode = NULL THEN
      ' // Allocate a buffer of the correct size
      cbNeeded = DocumentPropertiesW(NULL, hPrinter, m_wszPrinterName, NULL, NULL, 0)
      bufferDoc = SPACE(cbNeeded)
      ' // Retrieve the printer configuration data
      nRet = DocumentPropertiesW(NULL, hPrinter, m_wszPrinterName, _
         cast(DEVMODEW PTR, STRPTR(bufferDoc)), NULL, DM_OUT_BUFFER)
      IF nRet <> IDOK THEN
         ClosePrinter(hPrinter)
         RETURN FALSE
      END IF
      ' // Cast it to a DEVMODEW structure
      pDevMode = cast(DEVMODEW PTR, STRPTR(bufferDoc))
      pi2->pDevMode = pDevMode
   END IF

   ' // Specify exactly what we are attempting to change...
   SELECT CASE dmField
      CASE DM_COLLATE       : IF (pi2->pDevMode->dmFields AND DM_COLLATE) THEN pi2->pDevMode->dmCollate = nValue
      CASE DM_COLOR         : IF (pi2->pDevMode->dmFields AND DM_COLOR) THEN pi2->pDevMode->dmColor = nValue
      CASE DM_COPIES        : IF (pi2->pDevMode->dmFields AND DM_COPIES) THEN pi2->pDevMode->dmCopies = nValue
      CASE DM_DUPLEX        : IF (pi2->pDevMode->dmFields AND DM_DUPLEX) THEN pi2->pDevMode->dmDuplex = nValue
      CASE DM_ORIENTATION   : IF (pi2->pDevMode->dmFields AND DM_ORIENTATION) THEN pi2->pDevMode->dmOrientation = nValue
      CASE DM_PAPERSIZE     : IF (pi2->pDevMode->dmFields AND DM_PAPERSIZE) THEN pi2->pDevMode->dmPaperSize = nValue
      CASE DM_PRINTQUALITY  : IF (pi2->pDevMode->dmFields AND DM_PRINTQUALITY) THEN pi2->pDevMode->dmPrintQuality = nValue
      CASE DM_DEFAULTSOURCE : IF (pi2->pDevMode->dmFields AND DM_DEFAULTSOURCE) THEN pi2->pDevMode->dmDefaultSource = nValue
      CASE DM_SCALE         : IF (pi2->pDevMode->dmFields AND DM_SCALE) THEN pi2->pDevMode->dmScale = nValue
      CASE DM_PAPERLENGTH   : IF (pi2->pDevMode->dmFields AND DM_PAPERLENGTH) THEN pi2->pDevMode->dmPaperLength = nValue
      CASE DM_PAPERWIDTH    : IF (pi2->pDevMode->dmFields AND DM_PAPERWIDTH) THEN pi2->pDevMode->dmPaperWidth = nValue
   END SELECT

   ' // Do not attempt to set security descriptor...
   pi2->pSecurityDescriptor = NULL

   ' // Make sure the driver-dependent part of devmode is updated...
   nRet = DocumentPropertiesW(NULL, hPrinter, m_wszPrinterName, _
             pi2->pDevMode, pi2->pDevMode, DM_IN_BUFFER OR DM_OUT_BUFFER)
   IF nRet <> IDOK THEN
      ClosePrinter(hPrinter)
      RETURN FALSE
   END IF

   ' // Update printer information...
   nRet = SetPrinterW(hPrinter, dwLevel, cast(BYTE PTR, pi2), 0)
   IF nRet = 0 THEN
      ' // The driver doesn't support, or it is unable to make the change...
      ClosePrinter(hPrinter)
      RETURN FALSE
   END IF

   ' // Finished with the printer
   ClosePrinter(hPrinter)

   IF nRet <> IDOK THEN RETURN FALSE
   RETURN TRUE

END FUNCTION
' ========================================================================================

' ========================================================================================
' If the printer supports collating, the return value is TRUE; otherwise, the return value is FALSE.
' If TRUE, the pages that are printed should be collated. To collate is to print out the
' entire document before printing the next copy, as opposed to printing out each page of
' the document the required number of times.
' ========================================================================================
PRIVATE PROPERTY CPrint.Collate () AS BOOLEAN
   RETURN DeviceCapabilitiesW(m_wszPrinterName, NULL, DC_COLLATE, NULL, NULL)
END PROPERTY
' ========================================================================================
' ========================================================================================
' Specifies whether collation should be used when printing multiple copies.
' The following are the possible values:
'   DMCOLLATE_TRUE = 1
'   DMCOLLATE_FALSE = 0
' Remarks: Not all printers can collate.
' ========================================================================================
PRIVATE PROPERTY CPrint.CollateMode () AS LONG
   RETURN this.GetDocumentProperties(DM_COLLATE)
END PROPERTY
' ========================================================================================
' ========================================================================================
PRIVATE PROPERTY CPrint.CollateMode (BYVAL nMode AS LONG)
   this.SetPrinterInfo(DM_COLLATE, nMode)
END PROPERTY
' ========================================================================================

' ========================================================================================
' If the printer supports color mode, the return value is TRUE; otherwise, the return value is FALSE.
' ========================================================================================
PRIVATE PROPERTY CPrint.Color () AS BOOLEAN
   RETURN DeviceCapabilitiesW(m_wszPrinterName, NULL, DC_COLORDEVICE, NULL, NULL)
END PROPERTY
' ========================================================================================
' ========================================================================================
' Returns the printer color mode: DMCOLOR_MONOCHROME or DMCOLOR_COLOR.
' Some color printers have the capability to print using true black instead of a combination
' of cyan, magenta, and yellow (CMY). This usually creates darker and sharper text for
' documents. This option is only useful for color printers that support true black printing.
' ========================================================================================
PRIVATE PROPERTY CPrint.ColorMode () AS LONG
   RETURN this.GetDocumentProperties(DM_COLOR)
END PROPERTY
' ========================================================================================
' ========================================================================================
' Switches between color and monochrome on color printers.
' The following are the possible values:
'   DMCOLOR_MONOCHROME = 1
'   DMCOLOR_COLOR = 2
' ========================================================================================
PRIVATE PROPERTY CPrint.ColorMode (BYVAL nMode AS LONG)
   this.SetPrinterInfo(DM_COLOR, nMode)
END PROPERTY
' ========================================================================================

' ========================================================================================
' Returns the number of copies to print if the device supports multiple-page copies.
' ========================================================================================
PRIVATE PROPERTY CPrint.Copies () AS LONG
   RETURN this.GetDocumentProperties(DM_COPIES)
END PROPERTY
' ========================================================================================
' ========================================================================================
' Selects the number of copies to print if the device supports multiple-page copies.
' ========================================================================================
PRIVATE PROPERTY CPrint.Copies (BYVAL nCopies AS LONG)
   this.SetPrinterInfo(DM_COPIES, nCopies)
END PROPERTY
' ========================================================================================

' ========================================================================================
' If the printer supports duplex printing, the return value is TRUE; otherwise, the return value is FALSE.
' ========================================================================================
PRIVATE PROPERTY CPrint.Duplex () AS BOOLEAN
   RETURN DeviceCapabilitiesW(m_wszPrinterName, NULL, DC_DUPLEX, NULL, NULL)
END PROPERTY
' ========================================================================================

' ========================================================================================
' If the printer supports duplex printing, returns the current duplex mode
' DMDUP_SIMPLEX = 1 (Single sided printing)
' DMDUP_VERTICAL = 2 (Page flipped on the vertical edge)
' DMDUP_HORIZONTAL = 3 (Page flipped on the horizontal edge)
' ========================================================================================
PRIVATE PROPERTY CPrint.DuplexMode () AS LONG
   RETURN this.GetDocumentProperties(DM_DUPLEX)
END PROPERTY
' ========================================================================================
' ========================================================================================
' Sets the printer duplex mode
' DMDUP_SIMPLEX = 1 (Single sided printing)
' DMDUP_VERTICAL = 2 (Page flipped on the vertical edge)
' DMDUP_HORIZONTAL = 3 (Page flipped on the horizontal edge)
' ========================================================================================
PRIVATE PROPERTY CPrint.DuplexMode (BYVAL nDuplexMode AS LONG)
   this.SetPrinterInfo(DM_DUPLEX, nDuplexMode)
END PROPERTY
' ========================================================================================

' ========================================================================================
' Returns the printer orientation.
' The return value can be one of the following:
' DMORIENT_PORTRAIT (1) = Portrait
' DMORIENT_LANDSCAPE (2) = Landscape
' ========================================================================================
PRIVATE PROPERTY CPrint.Orientation () AS LONG
   RETURN this.GetDocumentProperties(DM_ORIENTATION)
END PROPERTY
' ========================================================================================
' ========================================================================================
' Sets the printer orientation.
' DMORIENT_PORTRAIT (1) = Portrait
' DMORIENT_LANDSCAPE (2) = Landscape
' ========================================================================================
PRIVATE PROPERTY CPrint.Orientation (BYVAL nOrientation AS LONG)
   this.SetPrinterInfo(DM_ORIENTATION, nOrientation)
END PROPERTY
' ========================================================================================

' ========================================================================================
' Specifies the printer paper size, with DMPAPER_LETTER, DMPAPER_LEGAL, DMPAPER_A3, and
' DMPAPER_A4 being the most typical. Note that the paper size types cannot be combined with
' one another. For a list of paper sizes see https://docs.microsoft.com/en-us/windows/desktop/intl/paper-sizes.
' ========================================================================================
PRIVATE PROPERTY CPrint.PaperSize () AS LONG
   RETURN this.GetDocumentProperties(DM_PAPERSIZE)
END PROPERTY
' ========================================================================================
' ========================================================================================
' Sets the printer paper size.
' ========================================================================================
PRIVATE PROPERTY CPrint.PaperSize (BYVAL nSize AS LONG)
   this.SetPrinterInfo(DM_PAPERSIZE, nSize)
END PROPERTY
' ========================================================================================

' ========================================================================================
' Sets the printer paper length and width in units of 1/10 of a millimeter.
' ========================================================================================
PRIVATE FUNCTION CPrint.SetPaperSize (BYVAL nLength AS LONG, BYVAL nWidth AS LONG) AS BOOLEAN
   DIM bRes AS BOOLEAN = this.SetPrinterInfo(DM_PAPERLENGTH, nLength)
   IF bRes = FALSE THEN RETURN FALSE
   bRes = this.SetPrinterInfo(DM_PAPERWIDTH, nWidth)
   IF bRes = FALSE THEN RETURN FALSE
   RETURN TRUE
END FUNCTION
' ========================================================================================
' ========================================================================================
' Returns the printer paper length in units of 1/10 of a millimeter.
' ========================================================================================
PRIVATE PROPERTY CPrint.PaperLength () AS LONG
   RETURN this.GetDocumentProperties(DM_PAPERLENGTH)
END PROPERTY
' ========================================================================================
' ========================================================================================
' Sets the printer paper length in units of 1/10 of a millimeter. This value overrides the 
' length of the paper specified by PaperSize, and is used if the paper is of a custom size,
' or if the device is a dot matrix printer, which can print a page of arbitrary length.
' ========================================================================================
PRIVATE PROPERTY CPrint.PaperLength (BYVAL nLength AS LONG)
   this.SetPrinterInfo(DM_PAPERLENGTH, nLength)
END PROPERTY
' ========================================================================================
' ========================================================================================
' Returns the printer paper width in units of 1/10 of a millimeter.
' ========================================================================================
PRIVATE PROPERTY CPrint.PaperWidth () AS LONG
   RETURN this.GetDocumentProperties(DM_PAPERWIDTH)
END PROPERTY
' ========================================================================================
' ========================================================================================
' Sets the printer paper width in units of 1/10 of a millimeter. This value overrides the 
' width of the paper specified by PaperSize. This MUST be used if PaperLength is used.
' ========================================================================================
PRIVATE PROPERTY CPrint.PaperWidth (BYVAL nWidth AS LONG)
   this.SetPrinterInfo(DM_PAPERWIDTH, nWidth)
END PROPERTY
' ========================================================================================
' ========================================================================================
' Returns a list of supported paper names (for example, Letter or Legal).
' The names are separated by a carriage return and a line feed characters.
' ========================================================================================
PRIVATE FUNCTION CPrint.GetPaperNames () AS CWSTR
   DIM wstrNames AS CWSTR, wszNames(ANY) AS WSTRING * 64
   DIM r AS LONG = DeviceCapabilitiesW(m_wszPrinterName, NULL, DC_PAPERNAMES, NULL, NULL)
   IF r = -1 THEN RETURN ""
   REDIM wszNames(r - 1) AS WSTRING * 64
   r = DeviceCapabilitiesW(m_wszPrinterName, NULL, DC_PAPERNAMES, @wszNames(0), NULL)
   IF r < 1 THEN RETURN ""
   DIM i AS LONG
   FOR i = 0 TO r - 1
      wstrNames += wszNames(i)
      IF i < r - 1 THEN wstrNames += CHR(13, 10)
   NEXT
   RETURN wstrNames
END FUNCTION
' ========================================================================================

' ========================================================================================
' Returns the printer print quality mode.
' There are four predefined device-independent values:
' - DMRES_DRAFT  = Draft (-1)
' - DMRES_LOW    = Low (-2)
' - DMRES_MEDIUM = Medium (-3)
' - DMRES_HIGH   = High (-4)
' If a positive value is returned, it specifies the number of pixels per inch (PPI) and is
' therefore device dependent.
' ========================================================================================
PRIVATE PROPERTY CPrint.Quality () AS LONG
   RETURN this.GetDocumentProperties(DM_PRINTQUALITY)
END PROPERTY
' ========================================================================================
' ========================================================================================
' Specifies the printer print quality mode.
' There are four predefined device-independent values:
' - DMRES_DRAFT  = Draft (-1)
' - DMRES_LOW    = Low (-2)
' - DMRES_MEDIUM = Medium (-3)
' - DMRES_HIGH   = High (-4)
' If a positive value is specified, it represents the number of pixels per inch (PPI) for
' the x resolution.
' ========================================================================================
PRIVATE PROPERTY CPrint.Quality (BYVAL nMode AS LONG)
   this.SetPrinterInfo(DM_PRINTQUALITY, nMode)
END PROPERTY
' ========================================================================================

' ========================================================================================
' Specifies the factor by which the printed output is to be scaled. The apparent page size
' is scaled from the physical page size by a factor of dmScale /100. For example, a
' letter-sized page with a dmScale value of 50 would contain as much data as a page of
' 17- by 22-inches because the output text and graphics would be half their original
' height and width.
' ========================================================================================
PRIVATE PROPERTY CPrint.Scale () AS LONG
   RETURN this.GetDocumentProperties(DM_SCALE)
END PROPERTY
' ========================================================================================
' ========================================================================================
' Specifies the factor by which the printed output is to be scaled. The apparent page size
' is scaled from the physical page size by a factor of nScale / 100. For example, a
' letter-sized page with a nScale value of 50 would contain as much data as a page of
' 17- by 22-inches because the output text and graphics would be half their original
' height and width.
' ========================================================================================
PRIVATE PROPERTY CPrint.Scale (BYVAL nScale AS LONG)
   this.SetPrinterInfo(DM_SCALE, nScale)
END PROPERTY
' ========================================================================================

' ========================================================================================
' Specifies the paper source.
' Returns one of the following values: DMBIN_UPPER = 1; DMBIN_LOWER = 2; DMBIN_MIDDLE = 3;
' DMBIN_MANUAL = 4; DMBIN_ENVELOPE = 5; DMBIN_ENVMANUAL = 6; DMBIN_AUTO = 7;
' DMBIN_TRACTOR = 8; DMBIN_SMALLFMT = 9; DMBIN_LARGEFMT = 10; DMBIN_LARGECAPACITY = 11;
' DMBIN_CASSETTE = 14; DMBIN_FORMSOURCE = 15
' ========================================================================================
PRIVATE PROPERTY CPrint.Tray () AS LONG
   RETURN this.GetDocumentProperties(DM_DEFAULTSOURCE)
END PROPERTY
' ========================================================================================
' ========================================================================================
' Sets the paper source. Can be one of the following values, or it can be a device-specific
' value greater than or equal to DMBIN_USER (256).
' DMBIN_UPPER = 1; DMBIN_LOWER = 2; DMBIN_MIDDLE = 3; DMBIN_MANUAL = 4; DMBIN_ENVELOPE = 5;
' DMBIN_ENVMANUAL = 6; DMBIN_AUTO = 7;  DMBIN_TRACTOR = 8; DMBIN_SMALLFMT = 9;
' DMBIN_LARGEFMT = 10; DMBIN_LARGECAPACITY = 11; DMBIN_CASSETTE = 14; DMBIN_FORMSOURCE = 15
' ========================================================================================
PRIVATE PROPERTY CPrint.Tray (BYVAL nTray AS LONG)
   this.SetPrinterInfo(DM_DEFAULTSOURCE, nTray)
END PROPERTY
' ========================================================================================

' ========================================================================================
' Retrieves the margins (the non-printable area) of the printer page, in pixels.
' ========================================================================================
PRIVATE SUB CPrint.GetMarginPixels (BYREF nLeft AS LONG, BYREF nTop AS LONG, BYREF nRight AS LONG, BYREF nBottom AS LONG)
   IF m_hDC = NULL THEN RETURN
   DIM totalWidth AS LONG = GetDeviceCaps(m_hdc, PHYSICALWIDTH)
   DIM printWidth AS LONG = GetDeviceCaps(m_hdc, HORZRES)
   DIM leftMargin AS LONG = GetDeviceCaps(m_hdc, PHYSICALOFFSETX)
   DIM rightMargin AS LONG = totalWidth - printWidth - leftMargin
   DIM totalHeight AS LONG = GetDeviceCaps(m_hdc, PHYSICALHEIGHT)
   DIM printHeight AS LONG = GetDeviceCaps(m_hdc, VERTRES)
   DIM topMargin AS LONG = GetDeviceCaps(m_hdc, PHYSICALOFFSETY)
   DIM bottomMargin AS LONG = totalHeight - printHeight - topMargin
   IF VARPTR(nLeft) THEN nLeft = leftMargin
   IF VARPTR(nTop) THEN nTop = topMargin
   IF VARPTR(nRight) THEN nRight = rightMargin
   IF VARPTR(nBottom) THEN nBottom = bottomMargin
END SUB
' ========================================================================================
' ========================================================================================
' Retrieves the margins (the non-printable area) of the printer page, in world units.
' ========================================================================================
PRIVATE SUB CPrint.GetMarginUnits (BYREF nLeft AS LONG, BYREF nTop AS LONG, BYREF nRight AS LONG, BYREF nBottom AS LONG)
   IF m_hDC = NULL THEN RETURN
   ' // Get the horizontal PPI of the printer
   DIM ppix AS LONG = GetDeviceCaps(m_hDC, LOGPIXELSX)
   ' // Get the vertical PPI of the printer
   DIM ppiy AS LONG = GetDeviceCaps(m_hDC, LOGPIXELSY)
   ' // Calculate the margins according to the PPI of the printer
   DIM totalWidth AS LONG = GetDeviceCaps(m_hdc, PHYSICALWIDTH) / (ppix / 100)
   DIM printWidth AS LONG = GetDeviceCaps(m_hdc, HORZRES) / (ppix / 100)
   DIM leftMargin AS LONG = GetDeviceCaps(m_hdc, PHYSICALOFFSETX) / (ppix / 100)
   DIM rightMargin AS LONG = totalWidth - printWidth - leftMargin
   DIM totalHeight AS LONG = GetDeviceCaps(m_hdc, PHYSICALHEIGHT) / (ppiy / 100)
   DIM printHeight AS LONG = GetDeviceCaps(m_hdc, VERTRES) / (ppiy / 100)
   DIM topMargin AS LONG = GetDeviceCaps(m_hdc, PHYSICALOFFSETY) / (ppiy / 100)
   DIM bottomMargin AS LONG = totalHeight - printHeight - topMargin
   IF VARPTR(nLeft) THEN nLeft = leftMargin
   IF VARPTR(nTop) THEN nTop = topMargin
   IF VARPTR(nRight) THEN nRight = rightMargin
   IF VARPTR(nBottom) THEN nBottom = bottomMargin
END SUB
' ========================================================================================

' ========================================================================================
' Prints a Windows bitmap to the selected printer.
' Parameters:
' - wszDocName = Document name.
' - hbmp = Handle to the bitmap.
' - bStretch = Stretch the image.
' - nStretchMode = Stretching mode. Default value = InterpolationModeHighQualityBicubic.
'   InterpolationModeLowQuality = 1
'   InterpolationModeHighQuality = 2
'   InterpolationModeBilinear = 3
'   InterpolationModeBicubic = 4
'   InterpolationModeNearestNeighbor = 5
'   InterpolationModeHighQualityBilinear = 6
'   InterpolationModeHighQualityBicubic = 7
' Return value: Returns TRUE if the bitmap has been printed successfully, or FALSE otherwise.
' ========================================================================================
PRIVATE FUNCTION CPrint.PrintBitmap ( _
   BYREF wszDocName AS WSTRING, _
   BYVAL hbmp AS HBITMAP, _
   BYVAL bStretch AS BOOLEAN = FALSE, _
   BYVAL nStretchMode AS LONG = InterpolationModeHighQualityBicubic _
   ) AS BOOLEAN

   IF m_hDC = NULL THEN RETURN FALSE
   DIM _wszDocName AS WSTRING * 260 = wszDocName

   ' // Initialize Gdiplus
   DIM token AS ULONG_PTR = AfxGdipInit
   IF token = NULL THEN EXIT FUNCTION

   DIM pGraphics AS GpGraphics PTR
   DIM pBitmap AS GpBitmap PTR

   ' // Note: Using a DO... LOOP, with an EXIT DO before LOOP, to avoid the use of GOTO.
   DO
      GdipCreateFromHDC(m_hDC, @pGraphics)
      IF pGraphics = NULL THEN EXIT DO
      ' // Create a Bitmap object from an HBITMAP
      GdipCreateBitmapFromHBITMAP(hbmp, NULL, @pBitmap)
      IF pBitmap = NULL THEN EXIT DO
      ' // Stretching
      DIM cx AS SINGLE, cy AS SINGLE
      IF bStretch THEN GdipSetInterpolationMode(pGraphics, nStretchMode)
      ' // Get the DPIs of the printer
      DIM dpiX AS SINGLE, dpiY AS SINGLE
      GdipGetDpiX(pGraphics, @dpiX)
      GdipGetDpiY(pGraphics, @dpiY)
      ' // Calculate the width and height according to the DPIs of the printer
      cx = GetDeviceCaps(m_hDC, HORZRES) / (dpiX / 100)
      cy = GetDeviceCaps(m_hDC, VERTRES) / (dpiY / 100)
      ' // Print the bitmap
      DIM di AS DOCINFOW
      di.cbSize = SIZEOF(DOCINFOW)
      di.lpszDocName = @_wszDocName
      DIM hr AS LONG = StartDocW(m_hDC, @di)
      IF hr <= 0 THEN EXIT DO
      DIM nCopies AS LONG = this.Copies
      IF nCopies < 1 THEN nCopies = 1
      FOR i AS LONG = 1 TO nCopies
         IF StartPage(m_hDC) THEN
            ' // Draw the image
            IF bStretch THEN
               GdipDrawImageRect(pGraphics, CAST(GpImage PTR, pBitmap), 0, 0, cx, cy)
            ELSE
               GdipDrawImage(pGraphics, CAST(GpImage PTR, pBitmap), 0, 0)
            END IF
            EndPage(m_hDC)
         END IF
      NEXT
      EndDoc(m_hDC)
      FUNCTION = TRUE
      EXIT DO
   LOOP

   IF pBitmap THEN GdipDisposeImage(cast(GpImage PTR, pBitmap))
   IF pGraphics THEN GdipDeleteGraphics(pGraphics)
   ' // Shutdown Gdiplus
   GdiplusShutdown token

END FUNCTION
' ========================================================================================

' ========================================================================================
' Prints a Windows bitmap to the specified file.
' Parameters:
' - wszDocName = Document name.
' - wszOutputFileName = Output file name.
' - hbmp = Handle to the bitmap.
' - bStretch = Stretch the image.
' - nStretchMode = Stretching mode. Default value = InterpolationModeHighQualityBicubic.
'   InterpolationModeLowQuality = 1
'   InterpolationModeHighQuality = 2
'   InterpolationModeBilinear = 3
'   InterpolationModeBicubic = 4
'   InterpolationModeNearestNeighbor = 5
'   InterpolationModeHighQualityBilinear = 6
'   InterpolationModeHighQualityBicubic = 7
' Return value: Returns TRUE if the bitmap has been printed successfully, or FALSE otherwise.
' ========================================================================================
PRIVATE FUNCTION CPrint.PrintBitmapToFile ( _
   BYREF wszDocName AS WSTRING, _
   BYREF wszOutputFileName AS WSTRING, _
   BYVAL hbmp AS HBITMAP, _
   BYVAL bStretch AS BOOLEAN = FALSE, _
   BYVAL nStretchMode AS LONG = InterpolationModeHighQualityBicubic _
   ) AS BOOLEAN

   IF m_hDC = NULL THEN RETURN FALSE
   DIM _wszDocName AS WSTRING * 260 = wszDocName
   DIM _wszOutputFileName AS WSTRING * MAX_PATH = wszOutputFileName

   ' // Initialize Gdiplus
   DIM token AS ULONG_PTR = AfxGdipInit
   IF token = NULL THEN EXIT FUNCTION

   DIM pGraphics AS GpGraphics PTR
   DIM pBitmap AS GpBitmap PTR

   ' // Note: Using a DO... LOOP, with an EXIT DO before LOOP, to avoid the use of GOTO.
   DO
      GdipCreateFromHDC(m_hDC, @pGraphics)
      IF pGraphics = NULL THEN EXIT DO
      ' // Create a Bitmap object from an HBITMAP
      GdipCreateBitmapFromHBITMAP(hbmp, NULL, @pBitmap)
      IF pBitmap = NULL THEN EXIT DO
      ' // Stretching
      DIM cx AS SINGLE, cy AS SINGLE
      IF bStretch THEN GdipSetInterpolationMode(pGraphics, nStretchMode)
      ' // Get the DPIs of the printer
      DIM dpiX AS SINGLE, dpiY AS SINGLE
      GdipGetDpiX(pGraphics, @dpiX)
      GdipGetDpiY(pGraphics, @dpiY)
      ' // Calculate the width and height according to the DPIs of the printer
      cx = GetDeviceCaps(m_hDC, HORZRES) / (dpiX / 100)
      cy = GetDeviceCaps(m_hDC, VERTRES) / (dpiY / 100)
      ' // Print the bitmap
      DIM di AS DOCINFOW
      di.cbSize = SIZEOF(DOCINFOW)
      di.lpszDocName = @_wszDocName
      di.lpszOutput = @_wszOutputFileName
      DIM hr AS LONG = StartDocW(m_hDC, @di)
      IF hr <= 0 THEN EXIT DO
      DIM nCopies AS LONG = this.Copies
      IF nCopies < 1 THEN nCopies = 1
      FOR i AS LONG = 1 TO nCopies
         IF StartPage(m_hDC) THEN
            ' // Draw the image
            IF bStretch THEN
               GdipDrawImageRect(pGraphics, CAST(GpImage PTR, pBitmap), 0, 0, cx, cy)
            ELSE
               GdipDrawImage(pGraphics, CAST(GpImage PTR, pBitmap), 0, 0)
            END IF
            EndPage(m_hDC)
         END IF
      NEXT
      EndDoc(m_hDC)
      FUNCTION = TRUE
      EXIT DO
   LOOP

   IF pBitmap THEN GdipDisposeImage(cast(GpImage PTR, pBitmap))
   IF pGraphics THEN GdipDeleteGraphics(pGraphics)
   ' // Shutdown Gdiplus
   GdiplusShutdown token

END FUNCTION
' ========================================================================================

END NAMESPACE
