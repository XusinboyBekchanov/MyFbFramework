' Based on the C header files Wine project:
' Copyright (C) the Wine project
' Ported to FB by UEZ
' Build 2026-01-04 beta

#pragma once

#include once "dwrite_1.bi"

' ============================================================================
' DirectWrite 2 - Vollständige Portierung nach FreeBASIC
' ============================================================================

' ============================================================================
' Enumerations
' ============================================================================

Enum DWRITE_OPTICAL_ALIGNMENT
    DWRITE_OPTICAL_ALIGNMENT_NONE
    DWRITE_OPTICAL_ALIGNMENT_NO_SIDE_BEARINGS
End Enum

Enum DWRITE_GRID_FIT_MODE
    DWRITE_GRID_FIT_MODE_DEFAULT
    DWRITE_GRID_FIT_MODE_DISABLED
    DWRITE_GRID_FIT_MODE_ENABLED
End Enum

' ============================================================================
' Strukturen / Typen
' ============================================================================

' DWRITE_TEXT_METRICS1
' Erweitert DWRITE_TEXT_METRICS um heightIncludingTrailingWhitespace
Type DWRITE_TEXT_METRICS1
    ' DWRITE_TEXT_METRICS fields
    left As Single
    top As Single
    width As Single
    widthIncludingTrailingWhitespace As Single
    height As Single
    layoutWidth As Single
    layoutHeight As Single
    maxBidiReorderingDepth As ULong
    lineCount As ULong
    ' DWRITE_TEXT_METRICS1 fields
    heightIncludingTrailingWhitespace As Single
End Type

' D3DCOLORVALUE
' Entspricht der DirectX D3DCOLORVALUE Struktur
#ifndef D3DCOLORVALUE_DEFINED
Type D3DCOLORVALUE
    Union
        r As Single
        dvR As Single
    End Union
    Union
        g As Single
        dvG As Single
    End Union
    Union
        b As Single
        dvB As Single
    End Union
    Union
        a As Single
        dvA As Single
    End Union
End Type
#define D3DCOLORVALUE_DEFINED
#endif

' DWRITE_COLOR_F
' Typedef für Farbwerte (identisch mit D3DCOLORVALUE)
Type DWRITE_COLOR_F As D3DCOLORVALUE

' DWRITE_COLOR_GLYPH_RUN
' Beschreibt einen farbigen Glyph-Run für Color-Fonts
Type DWRITE_COLOR_GLYPH_RUN
    glyphRun As DWRITE_GLYPH_RUN
    glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr
    baselineOriginX As Single
    baselineOriginY As Single
    runColor As DWRITE_COLOR_F
    paletteIndex As UShort
End Type

' ============================================================================
' IDWriteTextRenderer1
' ============================================================================
Type IDWriteTextRenderer1 Extends IDWriteTextRenderer
    ' 1-10: IDWriteTextRenderer
    
    ' 11. DrawGlyphRun (mit Glyph-Orientierung)
    Declare Abstract Function DrawGlyphRun Stdcall ( _
        ByVal clientDrawingContext As Any Ptr, _
        ByVal baselineOriginX As Single, _
        ByVal baselineOriginY As Single, _
        ByVal orientationAngle As DWRITE_GLYPH_ORIENTATION_ANGLE, _
        ByVal measuringMode As DWRITE_MEASURING_MODE, _
        ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, _
        ByVal glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr, _
        ByVal clientDrawingEffect As IUnknown Ptr _
    ) As HRESULT
    
    ' 12. DrawUnderline (mit Glyph-Orientierung)
    Declare Abstract Function DrawUnderline Stdcall ( _
        ByVal clientDrawingContext As Any Ptr, _
        ByVal baselineOriginX As Single, _
        ByVal baselineOriginY As Single, _
        ByVal orientationAngle As DWRITE_GLYPH_ORIENTATION_ANGLE, _
        ByVal underline As DWRITE_UNDERLINE Ptr, _
        ByVal clientDrawingEffect As IUnknown Ptr _
    ) As HRESULT
    
    ' 13. DrawStrikethrough (mit Glyph-Orientierung)
    Declare Abstract Function DrawStrikethrough Stdcall ( _
        ByVal clientDrawingContext As Any Ptr, _
        ByVal baselineOriginX As Single, _
        ByVal baselineOriginY As Single, _
        ByVal orientationAngle As DWRITE_GLYPH_ORIENTATION_ANGLE, _
        ByVal strikethrough As DWRITE_STRIKETHROUGH Ptr, _
        ByVal clientDrawingEffect As IUnknown Ptr _
    ) As HRESULT
    
    ' 14. DrawInlineObject (mit Glyph-Orientierung)
    Declare Abstract Function DrawInlineObject Stdcall ( _
        ByVal clientDrawingContext As Any Ptr, _
        ByVal originX As Single, _
        ByVal originY As Single, _
        ByVal orientationAngle As DWRITE_GLYPH_ORIENTATION_ANGLE, _
        ByVal inlineObject As IDWriteInlineObject Ptr, _
        ByVal isSideways As Long, _
        ByVal isRightToLeft As Long, _
        ByVal clientDrawingEffect As IUnknown Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontFallback
' ============================================================================
Type IDWriteFontFallback Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. MapCharacters
    Declare Abstract Function MapCharacters Stdcall ( _
        ByVal analysisSource As IDWriteTextAnalysisSource Ptr, _
        ByVal textPosition As ULong, _
        ByVal textLength As ULong, _
        ByVal baseFontCollection As IDWriteFontCollection Ptr, _
        ByVal baseFamilyName As WString Ptr, _
        ByVal baseWeight As DWRITE_FONT_WEIGHT, _
        ByVal baseStyle As DWRITE_FONT_STYLE, _
        ByVal baseStretch As DWRITE_FONT_STRETCH, _
        ByVal mappedLength As ULong Ptr, _
        ByVal mappedFont As IDWriteFont Ptr Ptr, _
        ByVal scale As Single Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteTextFormat1
' ============================================================================
Type IDWriteTextFormat1 Extends IDWriteTextFormat
    ' 1-28: IDWriteTextFormat
    
    ' 29. SetVerticalGlyphOrientation
    Declare Abstract Function SetVerticalGlyphOrientation Stdcall ( _
        ByVal glyphOrientation As DWRITE_VERTICAL_GLYPH_ORIENTATION _
    ) As HRESULT
    
    ' 30. GetVerticalGlyphOrientation
    Declare Abstract Function GetVerticalGlyphOrientation Stdcall () As DWRITE_VERTICAL_GLYPH_ORIENTATION
    
    ' 31. SetLastLineWrapping
    Declare Abstract Function SetLastLineWrapping Stdcall ( _
        ByVal isLastLineWrappingEnabled As Long _
    ) As HRESULT
    
    ' 32. GetLastLineWrapping
    Declare Abstract Function GetLastLineWrapping Stdcall () As Long
    
    ' 33. SetOpticalAlignment
    Declare Abstract Function SetOpticalAlignment Stdcall ( _
        ByVal opticalAlignment As DWRITE_OPTICAL_ALIGNMENT _
    ) As HRESULT
    
    ' 34. GetOpticalAlignment
    Declare Abstract Function GetOpticalAlignment Stdcall () As DWRITE_OPTICAL_ALIGNMENT
    
    ' 35. SetFontFallback
    Declare Abstract Function SetFontFallback Stdcall ( _
        ByVal fontFallback As IDWriteFontFallback Ptr _
    ) As HRESULT
    
    ' 36. GetFontFallback
    Declare Abstract Function GetFontFallback Stdcall ( _
        ByVal fontFallback As IDWriteFontFallback Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteTextLayout2
' ============================================================================
Type IDWriteTextLayout2 Extends IDWriteTextLayout1
    ' 1-71: IDWriteTextLayout1
    
    ' 72. GetMetrics
    Declare Abstract Function GetMetrics Stdcall ( _
        ByVal textMetrics As DWRITE_TEXT_METRICS1 Ptr _
    ) As HRESULT
    
    ' 73. SetVerticalGlyphOrientation
    Declare Abstract Function SetVerticalGlyphOrientation Stdcall ( _
        ByVal glyphOrientation As DWRITE_VERTICAL_GLYPH_ORIENTATION _
    ) As HRESULT
    
    ' 74. GetVerticalGlyphOrientation
    Declare Abstract Function GetVerticalGlyphOrientation Stdcall () As DWRITE_VERTICAL_GLYPH_ORIENTATION
    
    ' 75. SetLastLineWrapping
    Declare Abstract Function SetLastLineWrapping Stdcall ( _
        ByVal isLastLineWrappingEnabled As Long _
    ) As HRESULT
    
    ' 76. GetLastLineWrapping
    Declare Abstract Function GetLastLineWrapping Stdcall () As Long
    
    ' 77. SetOpticalAlignment
    Declare Abstract Function SetOpticalAlignment Stdcall ( _
        ByVal opticalAlignment As DWRITE_OPTICAL_ALIGNMENT _
    ) As HRESULT
    
    ' 78. GetOpticalAlignment
    Declare Abstract Function GetOpticalAlignment Stdcall () As DWRITE_OPTICAL_ALIGNMENT
    
    ' 79. SetFontFallback
    Declare Abstract Function SetFontFallback Stdcall ( _
        ByVal fontFallback As IDWriteFontFallback Ptr _
    ) As HRESULT
    
    ' 80. GetFontFallback
    Declare Abstract Function GetFontFallback Stdcall ( _
        ByVal fontFallback As IDWriteFontFallback Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteTextAnalyzer2
' ============================================================================
Type IDWriteTextAnalyzer2 Extends IDWriteTextAnalyzer1
    ' 1-N: IDWriteTextAnalyzer1
    
    ' GetGlyphOrientationTransform (erweiterte Version mit Origin)
    Declare Abstract Function GetGlyphOrientationTransform Stdcall ( _
        ByVal glyphOrientationAngle As DWRITE_GLYPH_ORIENTATION_ANGLE, _
        ByVal isSideways As Long, _
        ByVal originX As Single, _
        ByVal originY As Single, _
        ByVal transform As DWRITE_MATRIX Ptr _
    ) As HRESULT
    
    ' GetTypographicFeatures
    Declare Abstract Function GetTypographicFeatures Stdcall ( _
        ByVal fontFace As IDWriteFontFace Ptr, _
        ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS, _
        ByVal localeName As WString Ptr, _
        ByVal maxTagCount As ULong, _
        ByVal actualTagCount As ULong Ptr, _
        ByVal tags As DWRITE_FONT_FEATURE_TAG Ptr _
    ) As HRESULT
    
    ' CheckTypographicFeature
    Declare Abstract Function CheckTypographicFeature Stdcall ( _
        ByVal fontFace As IDWriteFontFace Ptr, _
        ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS, _
        ByVal localeName As WString Ptr, _
        ByVal featureTag As DWRITE_FONT_FEATURE_TAG, _
        ByVal glyphCount As ULong, _
        ByVal glyphIndices As UShort Ptr, _
        ByVal featureApplies As Byte Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontFallbackBuilder
' ============================================================================
Type IDWriteFontFallbackBuilder Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. AddMapping
    Declare Abstract Function AddMapping Stdcall ( _
        ByVal ranges As DWRITE_UNICODE_RANGE Ptr, _
        ByVal rangesCount As ULong, _
        ByVal targetFamilyNames As WString Ptr Ptr, _
        ByVal targetFamilyNamesCount As ULong, _
        ByVal fontCollection As IDWriteFontCollection Ptr = 0, _
        ByVal localeName As WString Ptr = 0, _
        ByVal baseFamilyName As WString Ptr = 0, _
        ByVal scale As Single = 1.0 _
    ) As HRESULT
    
    ' 5. AddMappings
    Declare Abstract Function AddMappings Stdcall ( _
        ByVal fontFallback As IDWriteFontFallback Ptr _
    ) As HRESULT
    
    ' 6. CreateFontFallback
    Declare Abstract Function CreateFontFallback Stdcall ( _
        ByVal fontFallback As IDWriteFontFallback Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFont2
' ============================================================================
Type IDWriteFont2 Extends IDWriteFont1
    ' 1-18: IDWriteFont1
    
    ' 19. IsColorFont
    Declare Abstract Function IsColorFont Stdcall () As Long
End Type

' ============================================================================
' IDWriteFontFace2
' ============================================================================
Type IDWriteFontFace2 Extends IDWriteFontFace1
    ' 1-30: IDWriteFontFace1
    
    ' 31. IsColorFont
    Declare Abstract Function IsColorFont Stdcall () As Long
    
    ' 32. GetColorPaletteCount
    Declare Abstract Function GetColorPaletteCount Stdcall () As ULong
    
    ' 33. GetPaletteEntryCount
    Declare Abstract Function GetPaletteEntryCount Stdcall () As ULong
    
    ' 34. GetPaletteEntries
    Declare Abstract Function GetPaletteEntries Stdcall ( _
        ByVal colorPaletteIndex As ULong, _
        ByVal firstEntryIndex As ULong, _
        ByVal entryCount As ULong, _
        ByVal paletteEntries As DWRITE_COLOR_F Ptr _
    ) As HRESULT
    
    ' 35. GetRecommendedRenderingMode
    Declare Abstract Function GetRecommendedRenderingMode Stdcall ( _
        ByVal fontEmSize As Single, _
        ByVal dpiX As Single, _
        ByVal dpiY As Single, _
        ByVal transform As DWRITE_MATRIX Ptr, _
        ByVal isSideways As Long, _
        ByVal outlineThreshold As DWRITE_OUTLINE_THRESHOLD, _
        ByVal measuringMode As DWRITE_MEASURING_MODE, _
        ByVal renderingParams As IDWriteRenderingParams Ptr, _
        ByVal renderingMode As DWRITE_RENDERING_MODE Ptr, _
        ByVal gridFitMode As DWRITE_GRID_FIT_MODE Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteColorGlyphRunEnumerator
' ============================================================================
Type IDWriteColorGlyphRunEnumerator Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. MoveNext
    Declare Abstract Function MoveNext Stdcall ( _
        ByVal hasRun As Long Ptr _
    ) As HRESULT
    
    ' 5. GetCurrentRun
    Declare Abstract Function GetCurrentRun Stdcall ( _
        ByVal colorGlyphRun As DWRITE_COLOR_GLYPH_RUN Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteRenderingParams2
' ============================================================================
Type IDWriteRenderingParams2 Extends IDWriteRenderingParams1
    ' 1-9: IDWriteRenderingParams1
    
    ' 10. GetGridFitMode
    Declare Abstract Function GetGridFitMode Stdcall () As DWRITE_GRID_FIT_MODE
End Type

' ============================================================================
' IDWriteFactory2
' ============================================================================
Type IDWriteFactory2 Extends IDWriteFactory1
    ' 1-26: IDWriteFactory1
    
    ' 27. GetSystemFontFallback
    Declare Abstract Function GetSystemFontFallback Stdcall ( _
        ByVal fontFallback As IDWriteFontFallback Ptr Ptr _
    ) As HRESULT
    
    ' 28. CreateFontFallbackBuilder
    Declare Abstract Function CreateFontFallbackBuilder Stdcall ( _
        ByVal fontFallbackBuilder As IDWriteFontFallbackBuilder Ptr Ptr _
    ) As HRESULT
    
    ' 29. TranslateColorGlyphRun
    Declare Abstract Function TranslateColorGlyphRun Stdcall ( _
        ByVal baselineOriginX As Single, _
        ByVal baselineOriginY As Single, _
        ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, _
        ByVal glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr, _
        ByVal measuringMode As DWRITE_MEASURING_MODE, _
        ByVal worldToDeviceTransform As DWRITE_MATRIX Ptr, _
        ByVal colorPaletteIndex As ULong, _
        ByVal colorLayers As IDWriteColorGlyphRunEnumerator Ptr Ptr _
    ) As HRESULT
    
    ' 30. CreateCustomRenderingParams
    Declare Abstract Function CreateCustomRenderingParams Stdcall ( _
        ByVal gamma As Single, _
        ByVal enhancedContrast As Single, _
        ByVal grayscaleEnhancedContrast As Single, _
        ByVal clearTypeLevel As Single, _
        ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, _
        ByVal renderingMode As DWRITE_RENDERING_MODE, _
        ByVal gridFitMode As DWRITE_GRID_FIT_MODE, _
        ByVal renderingParams As IDWriteRenderingParams2 Ptr Ptr _
    ) As HRESULT
    
    ' 31. CreateGlyphRunAnalysis
    Declare Abstract Function CreateGlyphRunAnalysis Stdcall ( _
        ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, _
        ByVal transform As DWRITE_MATRIX Ptr, _
        ByVal renderingMode As DWRITE_RENDERING_MODE, _
        ByVal measuringMode As DWRITE_MEASURING_MODE, _
        ByVal gridFitMode As DWRITE_GRID_FIT_MODE, _
        ByVal antialiasMode As DWRITE_TEXT_ANTIALIAS_MODE, _
        ByVal baselineOriginX As Single, _
        ByVal baselineOriginY As Single, _
        ByVal glyphRunAnalysis As IDWriteGlyphRunAnalysis Ptr Ptr _
    ) As HRESULT
End Type