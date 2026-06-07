' Based on the C header files Wine project:
' Copyright (C) the Wine project
' Ported to FB by UEZ
' Build 2026-01-04 beta

#include "d2d1effects.bi"

#pragma once

' ---------------------------------------------------------------------------
' D2D1 Effects 1 (Übersetzt aus d2d1effects_1.idl)
' ---------------------------------------------------------------------------

#ifndef __D2D1EFFECTS_1_BI
#define __D2D1EFFECTS_1_BI

' Die GUID für den YCbCr-Effekt
' CLSID_D2D1YCbCr: 99503cc1-66c7-45c9-a875-8ad8a7914401
Dim Shared As GUID CLSID_D2D1YCbCr = Type<GUID>(&h99503cc1, &h66c7, &h45c9, {&ha8, &h75, &h8a, &hd8, &ha7, &h91, &h44, &h01})


' Enumeration für die YCbCr-Effekteigenschaften
Enum D2D1_YCBCR_PROP
    D2D1_YCBCR_PROP_CHROMA_SUBSAMPLING = &h0
    D2D1_YCBCR_PROP_TRANSFORM_MATRIX   = &h1
    D2D1_YCBCR_PROP_INTERPOLATION_MODE = &h2
    D2D1_YCBCR_PROP_FORCE_DWORD         = &hFFFFFFFF
End Enum

' Enumeration für das Chroma-Subsampling
Enum D2D1_YCBCR_CHROMA_SUBSAMPLING
    D2D1_YCBCR_CHROMA_SUBSAMPLING_AUTO = &h0
    D2D1_YCBCR_CHROMA_SUBSAMPLING_420  = &h1
    D2D1_YCBCR_CHROMA_SUBSAMPLING_422  = &h2
    D2D1_YCBCR_CHROMA_SUBSAMPLING_444  = &h3
    D2D1_YCBCR_CHROMA_SUBSAMPLING_440  = &h4
    D2D1_YCBCR_CHROMA_SUBSAMPLING_FORCE_DWORD = &hFFFFFFFF
End Enum

' Enumeration für den Interpolationsmodus
Enum D2D1_YCBCR_INTERPOLATION_MODE
    D2D1_YCBCR_INTERPOLATION_MODE_NEAREST_NEIGHBOR = &h0
    D2D1_YCBCR_INTERPOLATION_MODE_LINEAR           = &h1
    D2D1_YCBCR_INTERPOLATION_MODE_CUBIC            = &h2
    D2D1_YCBCR_INTERPOLATION_MODE_MULTI_SAMPLE_LINEAR = &h3
    D2D1_YCBCR_INTERPOLATION_MODE_ANISOTROPIC      = &h4
    D2D1_YCBCR_INTERPOLATION_MODE_HIGH_QUALITY_CUBIC = &h5
    D2D1_YCBCR_INTERPOLATION_MODE_FANT             = &h6
    D2D1_YCBCR_INTERPOLATION_MODE_MIPMAP_LINEAR    = &h7
    D2D1_YCBCR_INTERPOLATION_MODE_FORCE_DWORD      = &hFFFFFFFF
End Enum

#endif ' __D2D1EFFECTS_1_BI