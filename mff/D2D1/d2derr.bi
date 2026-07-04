'###############################################################################
' This file is part of MyFBFramework
' Authors: UEZ, Xusinboy Bekchanov, Liu XiaLin
' Based on UEZ's abstract version.
' Direct2D 1.2 API - FreeBASIC Translation
' Adapted by Xusinboy Bekchanov, Liu XiaLin
'###############################################################################

#pragma once
' ---------------------------------------------------------------------------
' D2D Error Codes (from d2derr.h)
' ---------------------------------------------------------------------------
#ifndef __D2DERR_BI
#define __D2DERR_BI
' Hilfsmakro für HRESULT_FROM_WIN32, falls nicht bereits definiert
#ifndef HRESULT_FROM_WIN32
#define HRESULT_FROM_WIN32(x) Cast(HRESULT, IIf(Cast(Long, x) <= 0, Cast(Long, x), Cast(Long, (x And &h0000FFFF) Or &h80070000)))
#endif
' Fehlerdefinitionen
#define D2DERR_FILE_NOT_FOUND           HRESULT_FROM_WIN32(2) ' ERROR_FILE_NOT_FOUND = 2
#define D2DERR_INSUFFICIENT_BUFFER      HRESULT_FROM_WIN32(122) ' ERROR_INSUFFICIENT_BUFFER = 122
' Dieser Wert stammt normalerweise aus der wincodec.h (Windows Imaging Component)
#ifndef WINCODEC_ERR_UNSUPPORTEDPIXELFORMAT
#define WINCODEC_ERR_UNSUPPORTEDPIXELFORMAT Cast(HRESULT, &h88982F80)
#endif
#define D2DERR_UNSUPPORTED_PIXEL_FORMAT WINCODEC_ERR_UNSUPPORTEDPIXELFORMAT
#endif ' __D2DERR_BI
