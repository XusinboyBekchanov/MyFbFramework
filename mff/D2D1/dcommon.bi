'###############################################################################
' This file is part of MyFBFramework
' Authors: UEZ, Xusinboy Bekchanov, Liu XiaLin
' Based on UEZ's abstract version.
' Direct2D 1.2 API - FreeBASIC Translation
' Adapted by Xusinboy Bekchanov, Liu XiaLin
'###############################################################################

#pragma once
' ---------------------------------------------------------------------------
' DCommon (from dcommon.idl)
' ---------------------------------------------------------------------------
#include once "dxgicommon.bi"
#ifndef __DCOMMON_BI
#define __DCOMMON_BI
#endif
' Grundlegende Typdefinitionen
#ifndef UINT32
Type UINT32 As ULong
#endif
' Messmodi für Text (DirectWrite)
Type DWRITE_MEASURING_MODE As Long
Enum
    DWRITE_MEASURING_MODE_NATURAL
    DWRITE_MEASURING_MODE_GDI_CLASSIC
    DWRITE_MEASURING_MODE_GDI_NATURAL
    DWRITE_MEASURING_MODE_FORCE_DWORD = &hFFFFFFFF
End Enum
' Formate für Glyphen-Bilder
Type DWRITE_GLYPH_IMAGE_FORMATS As Long
Enum
    DWRITE_GLYPH_IMAGE_FORMATS_NONE                   = 0
    DWRITE_GLYPH_IMAGE_FORMATS_TRUETYPE               = 1 Shl 0
    DWRITE_GLYPH_IMAGE_FORMATS_CFF                    = 1 Shl 1
    DWRITE_GLYPH_IMAGE_FORMATS_COLR                   = 1 Shl 2
    DWRITE_GLYPH_IMAGE_FORMATS_SVG                    = 1 Shl 3
    DWRITE_GLYPH_IMAGE_FORMATS_PNG                    = 1 Shl 4
    DWRITE_GLYPH_IMAGE_FORMATS_JPEG                   = 1 Shl 5
    DWRITE_GLYPH_IMAGE_FORMATS_TIFF                   = 1 Shl 6
    DWRITE_GLYPH_IMAGE_FORMATS_PREMULTIPLIED_B8G8R8A8 = 1 Shl 7
    DWRITE_MEASURING_MODE_FORCE_DWORD = &hFFFFFFFF
End Enum
' D2D1_ALPHA_MODE documentation at https://learn.microsoft.com/windows/win32/api/dcommon/ne-dcommon-d2d1_alpha_mode
