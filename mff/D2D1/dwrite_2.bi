'###############################################################################
' This file is part of MyFBFramework
' Authors: UEZ, Xusinboy Bekchanov, Liu XiaLin
' Based on UEZ's abstract version.
' Direct2D 1.2 API - FreeBASIC Translation
' Adapted by Xusinboy Bekchanov, Liu XiaLin
'###############################################################################

#pragma once
#include once "dwrite_1.bi"
' ============================================================================
' DirectWrite 2 - Enumerations
' ============================================================================
Type DWRITE_OPTICAL_ALIGNMENT As Long
Enum
    DWRITE_OPTICAL_ALIGNMENT_NONE
    DWRITE_OPTICAL_ALIGNMENT_NO_SIDE_BEARINGS
End Enum
Type DWRITE_GRID_FIT_MODE As Long
Enum
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
Type IDWriteTextRenderer1Vtbl As IDWriteTextRenderer1Vtbl_
Type IDWriteTextRenderer1
    lpVtbl As IDWriteTextRenderer1Vtbl Ptr
End Type
Type IDWriteTextRenderer1Vtbl_     '' Extends IDWriteTextRendererVtbl_
    QueryInterface As Function(ByVal This As IDWriteTextRenderer1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteTextRenderer1 Ptr) As ULong
    Release As Function(ByVal This As IDWriteTextRenderer1 Ptr) As ULong
        
    IsPixelSnappingDisabled As Function(ByVal This As IDWriteTextRenderer1 Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal isDisabled As Long Ptr ) As HRESULT
        ' 5. GetCurrentTransform
    GetCurrentTransform As Function(ByVal This As IDWriteTextRenderer1 Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal transform As DWRITE_MATRIX Ptr ) As HRESULT
        ' 6. GetPixelsPerDip
    GetPixelsPerDip As Function(ByVal This As IDWriteTextRenderer1 Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal pixelsPerDip As Single Ptr ) As HRESULT
        
    DrawGlyphRun As Function(ByVal This As IDWriteTextRenderer1 Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr, ByVal clientDrawingEffect As IUnknown Ptr ) As HRESULT
        ' 8. DrawUnderline
    DrawUnderline As Function(ByVal This As IDWriteTextRenderer1 Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal underline As DWRITE_UNDERLINE Ptr, ByVal clientDrawingEffect As IUnknown Ptr ) As HRESULT
        ' 9. DrawStrikethrough
    DrawStrikethrough As Function(ByVal This As IDWriteTextRenderer1 Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal strikethrough As DWRITE_STRIKETHROUGH Ptr, ByVal clientDrawingEffect As IUnknown Ptr ) As HRESULT
        ' 10. DrawInlineObject
    DrawInlineObject As Function(ByVal This As IDWriteTextRenderer1 Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal originX As Single, ByVal originY As Single, ByVal inlineObject As Any Ptr, ByVal isSideways As Long, ByVal isRightToLeft As Long, ByVal clientDrawingEffect As IUnknown Ptr ) As HRESULT

        
    DrawGlyphRun1 As Function(ByVal This As IDWriteTextRenderer1 Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal orientationAngle As DWRITE_GLYPH_ORIENTATION_ANGLE, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr, ByVal clientDrawingEffect As IUnknown Ptr ) As HRESULT
        ' 12. DrawUnderline (mit Glyph-Orientierung)
    DrawUnderline1 As Function(ByVal This As IDWriteTextRenderer1 Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal orientationAngle As DWRITE_GLYPH_ORIENTATION_ANGLE, ByVal underline As DWRITE_UNDERLINE Ptr, ByVal clientDrawingEffect As IUnknown Ptr ) As HRESULT
        ' 13. DrawStrikethrough (mit Glyph-Orientierung)
    DrawStrikethrough1 As Function(ByVal This As IDWriteTextRenderer1 Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal orientationAngle As DWRITE_GLYPH_ORIENTATION_ANGLE, ByVal strikethrough As DWRITE_STRIKETHROUGH Ptr, ByVal clientDrawingEffect As IUnknown Ptr ) As HRESULT
        ' 14. DrawInlineObject (mit Glyph-Orientierung)
    DrawInlineObject1 As Function(ByVal This As IDWriteTextRenderer1 Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal originX As Single, ByVal originY As Single, ByVal orientationAngle As DWRITE_GLYPH_ORIENTATION_ANGLE, ByVal inlineObject As IDWriteInlineObject Ptr, ByVal isSideways As Long, ByVal isRightToLeft As Long, ByVal clientDrawingEffect As IUnknown Ptr ) As HRESULT
End Type
#define IDWriteTextRenderer1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteTextRenderer1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteTextRenderer1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteTextRenderer1_IsPixelSnappingDisabled(p, a, b) (p)->lpVtbl->IsPixelSnappingDisabled(p, a, b)
#define IDWriteTextRenderer1_GetCurrentTransform(p, a, b) (p)->lpVtbl->GetCurrentTransform(p, a, b)
#define IDWriteTextRenderer1_GetPixelsPerDip(p, a, b) (p)->lpVtbl->GetPixelsPerDip(p, a, b)
#define IDWriteTextRenderer1_DrawGlyphRun(p, a, b, c, d, e, f, g) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d, e, f, g)
#define IDWriteTextRenderer1_DrawUnderline(p, a, b, c, d, e) (p)->lpVtbl->DrawUnderline(p, a, b, c, d, e)
#define IDWriteTextRenderer1_DrawStrikethrough(p, a, b, c, d, e) (p)->lpVtbl->DrawStrikethrough(p, a, b, c, d, e)
#define IDWriteTextRenderer1_DrawInlineObject(p, a, b, c, d, e, f, g) (p)->lpVtbl->DrawInlineObject(p, a, b, c, d, e, f, g)
#define IDWriteTextRenderer1_DrawGlyphRun1(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->DrawGlyphRun1(p, a, b, c, d, e, f, g, h)
#define IDWriteTextRenderer1_DrawUnderline1(p, a, b, c, d, e, f) (p)->lpVtbl->DrawUnderline1(p, a, b, c, d, e, f)
#define IDWriteTextRenderer1_DrawStrikethrough1(p, a, b, c, d, e, f) (p)->lpVtbl->DrawStrikethrough1(p, a, b, c, d, e, f)
#define IDWriteTextRenderer1_DrawInlineObject1(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->DrawInlineObject1(p, a, b, c, d, e, f, g, h)

' ============================================================================
' IDWriteFontFallback
' ============================================================================
Type IDWriteFontFallbackVtbl As IDWriteFontFallbackVtbl_
Type IDWriteFontFallback
    lpVtbl As IDWriteFontFallbackVtbl Ptr
End Type
Type IDWriteFontFallbackVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontFallback Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontFallback Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontFallback Ptr) As ULong

        
    MapCharacters As Function(ByVal This As IDWriteFontFallback Ptr,  ByVal analysisSource As IDWriteTextAnalysisSource Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal baseFontCollection As IDWriteFontCollection Ptr, ByVal baseFamilyName As WString Ptr, ByVal baseWeight As DWRITE_FONT_WEIGHT, ByVal baseStyle As DWRITE_FONT_STYLE, ByVal baseStretch As DWRITE_FONT_STRETCH, ByVal mappedLength As ULong Ptr, ByVal mappedFont As IDWriteFont Ptr Ptr, ByVal scale As Single Ptr ) As HRESULT
End Type
#define IDWriteFontFallback_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontFallback_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontFallback_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontFallback_MapCharacters(p, a, b, c, d, e, f, g, h, i, j, k) (p)->lpVtbl->MapCharacters(p, a, b, c, d, e, f, g, h, i, j, k)

' ============================================================================
' IDWriteTextFormat1
' ============================================================================
Type IDWriteTextFormat1Vtbl As IDWriteTextFormat1Vtbl_
Type IDWriteTextFormat1
    lpVtbl As IDWriteTextFormat1Vtbl Ptr
End Type
Type IDWriteTextFormat1Vtbl_     '' Extends IDWriteTextFormatVtbl_
    QueryInterface As Function(ByVal This As IDWriteTextFormat1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteTextFormat1 Ptr) As ULong
    Release As Function(ByVal This As IDWriteTextFormat1 Ptr) As ULong
        
    SetTextAlignment As Function(ByVal This As IDWriteTextFormat1 Ptr,  ByVal textAlignment As DWRITE_TEXT_ALIGNMENT ) As HRESULT
        ' 5. SetParagraphAlignment
    SetParagraphAlignment As Function(ByVal This As IDWriteTextFormat1 Ptr,  ByVal paragraphAlignment As DWRITE_PARAGRAPH_ALIGNMENT ) As HRESULT
        ' 6. SetWordWrapping
    SetWordWrapping As Function(ByVal This As IDWriteTextFormat1 Ptr,  ByVal wordWrapping As DWRITE_WORD_WRAPPING ) As HRESULT
        ' 7. SetReadingDirection
    SetReadingDirection As Function(ByVal This As IDWriteTextFormat1 Ptr,  ByVal readingDirection As DWRITE_READING_DIRECTION ) As HRESULT
        ' 8. SetFlowDirection
    SetFlowDirection As Function(ByVal This As IDWriteTextFormat1 Ptr,  ByVal flowDirection As DWRITE_FLOW_DIRECTION ) As HRESULT
        ' 9. SetIncrementalTabStop
    SetIncrementalTabStop As Function(ByVal This As IDWriteTextFormat1 Ptr,  ByVal incrementalTabStop As Single ) As HRESULT
        ' 10. SetTrimming
    SetTrimming As Function(ByVal This As IDWriteTextFormat1 Ptr,  ByVal trimmingOptions As DWRITE_TRIMMING Ptr, ByVal trimmingSign As Any Ptr ) As HRESULT
        ' 11. SetLineSpacing
    SetLineSpacing As Function(ByVal This As IDWriteTextFormat1 Ptr,  ByVal lineSpacingMethod As DWRITE_LINE_SPACING_METHOD, ByVal lineSpacing As Single, ByVal baseline As Single ) As HRESULT
        ' 12. GetTextAlignment
    GetTextAlignment As Function(ByVal This As IDWriteTextFormat1 Ptr) As DWRITE_TEXT_ALIGNMENT
        ' 13. GetParagraphAlignment
    GetParagraphAlignment As Function(ByVal This As IDWriteTextFormat1 Ptr) As DWRITE_PARAGRAPH_ALIGNMENT
        ' 14. GetWordWrapping
    GetWordWrapping As Function(ByVal This As IDWriteTextFormat1 Ptr) As DWRITE_WORD_WRAPPING
        ' 15. GetReadingDirection
    GetReadingDirection As Function(ByVal This As IDWriteTextFormat1 Ptr) As DWRITE_READING_DIRECTION
        ' 16. GetFlowDirection
    GetFlowDirection As Function(ByVal This As IDWriteTextFormat1 Ptr) As DWRITE_FLOW_DIRECTION
        ' 17. GetIncrementalTabStop
    GetIncrementalTabStop As Function(ByVal This As IDWriteTextFormat1 Ptr) As Single
        ' 18. GetTrimming
    GetTrimming As Function(ByVal This As IDWriteTextFormat1 Ptr,  ByVal trimmingOptions As DWRITE_TRIMMING Ptr, ByVal trimmingSign As Any Ptr Ptr ) As HRESULT
        ' 19. GetLineSpacing
    GetLineSpacing As Function(ByVal This As IDWriteTextFormat1 Ptr,  ByVal lineSpacingMethod As DWRITE_LINE_SPACING_METHOD Ptr, ByVal lineSpacing As Single Ptr, ByVal baseline As Single Ptr ) As HRESULT
        ' 20. GetFontCollection
    GetFontCollection As Function(ByVal This As IDWriteTextFormat1 Ptr,  ByVal fontCollection As Any Ptr Ptr ) As HRESULT
        ' 21. GetFontFamilyNameLength
    GetFontFamilyNameLength As Function(ByVal This As IDWriteTextFormat1 Ptr) As ULong
        ' 22. GetFontFamilyName
    GetFontFamilyName As Function(ByVal This As IDWriteTextFormat1 Ptr,  ByVal fontFamilyName As WString Ptr, ByVal nameSize As ULong ) As HRESULT
        ' 23. GetFontWeight
    GetFontWeight As Function(ByVal This As IDWriteTextFormat1 Ptr) As DWRITE_FONT_WEIGHT
        ' 24. GetFontStyle
    GetFontStyle As Function(ByVal This As IDWriteTextFormat1 Ptr) As DWRITE_FONT_STYLE
        ' 25. GetFontStretch
    GetFontStretch As Function(ByVal This As IDWriteTextFormat1 Ptr) As DWRITE_FONT_STRETCH
        ' 26. GetFontSize
    GetFontSize As Function(ByVal This As IDWriteTextFormat1 Ptr) As Single
        ' 27. GetLocaleNameLength
    GetLocaleNameLength As Function(ByVal This As IDWriteTextFormat1 Ptr) As ULong
        ' 28. GetLocaleName
    GetLocaleName As Function(ByVal This As IDWriteTextFormat1 Ptr,  ByVal localeName As WString Ptr, ByVal nameSize As ULong ) As HRESULT

        
    SetVerticalGlyphOrientation As Function(ByVal This As IDWriteTextFormat1 Ptr,  ByVal glyphOrientation As DWRITE_VERTICAL_GLYPH_ORIENTATION ) As HRESULT
        ' 30. GetVerticalGlyphOrientation
    GetVerticalGlyphOrientation As Function(ByVal This As IDWriteTextFormat1 Ptr) As DWRITE_VERTICAL_GLYPH_ORIENTATION
        ' 31. SetLastLineWrapping
    SetLastLineWrapping As Function(ByVal This As IDWriteTextFormat1 Ptr,  ByVal isLastLineWrappingEnabled As Long ) As HRESULT
        ' 32. GetLastLineWrapping
    GetLastLineWrapping As Function(ByVal This As IDWriteTextFormat1 Ptr) As Long
        ' 33. SetOpticalAlignment
    SetOpticalAlignment As Function(ByVal This As IDWriteTextFormat1 Ptr,  ByVal opticalAlignment As DWRITE_OPTICAL_ALIGNMENT ) As HRESULT
        ' 34. GetOpticalAlignment
    GetOpticalAlignment As Function(ByVal This As IDWriteTextFormat1 Ptr) As DWRITE_OPTICAL_ALIGNMENT
        ' 35. SetFontFallback
    SetFontFallback As Function(ByVal This As IDWriteTextFormat1 Ptr,  ByVal fontFallback As IDWriteFontFallback Ptr ) As HRESULT
        ' 36. GetFontFallback
    GetFontFallback As Function(ByVal This As IDWriteTextFormat1 Ptr,  ByVal fontFallback As IDWriteFontFallback Ptr Ptr ) As HRESULT
End Type
#define IDWriteTextFormat1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteTextFormat1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteTextFormat1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteTextFormat1_SetTextAlignment(p, a) (p)->lpVtbl->SetTextAlignment(p, a)
#define IDWriteTextFormat1_SetParagraphAlignment(p, a) (p)->lpVtbl->SetParagraphAlignment(p, a)
#define IDWriteTextFormat1_SetWordWrapping(p, a) (p)->lpVtbl->SetWordWrapping(p, a)
#define IDWriteTextFormat1_SetReadingDirection(p, a) (p)->lpVtbl->SetReadingDirection(p, a)
#define IDWriteTextFormat1_SetFlowDirection(p, a) (p)->lpVtbl->SetFlowDirection(p, a)
#define IDWriteTextFormat1_SetIncrementalTabStop(p, a) (p)->lpVtbl->SetIncrementalTabStop(p, a)
#define IDWriteTextFormat1_SetTrimming(p, a, b) (p)->lpVtbl->SetTrimming(p, a, b)
#define IDWriteTextFormat1_SetLineSpacing(p, a, b, c) (p)->lpVtbl->SetLineSpacing(p, a, b, c)
#define IDWriteTextFormat1_GetTextAlignment(p, a) (p)->lpVtbl->GetTextAlignment(p, a)
#define IDWriteTextFormat1_GetParagraphAlignment(p, a) (p)->lpVtbl->GetParagraphAlignment(p, a)
#define IDWriteTextFormat1_GetWordWrapping(p, a) (p)->lpVtbl->GetWordWrapping(p, a)
#define IDWriteTextFormat1_GetReadingDirection(p, a) (p)->lpVtbl->GetReadingDirection(p, a)
#define IDWriteTextFormat1_GetFlowDirection(p, a) (p)->lpVtbl->GetFlowDirection(p, a)
#define IDWriteTextFormat1_GetIncrementalTabStop(p, a) (p)->lpVtbl->GetIncrementalTabStop(p, a)
#define IDWriteTextFormat1_GetTrimming(p, a, b) (p)->lpVtbl->GetTrimming(p, a, b)
#define IDWriteTextFormat1_GetLineSpacing(p, a, b, c) (p)->lpVtbl->GetLineSpacing(p, a, b, c)
#define IDWriteTextFormat1_GetFontCollection(p, a) (p)->lpVtbl->GetFontCollection(p, a)
#define IDWriteTextFormat1_GetFontFamilyNameLength(p, a) (p)->lpVtbl->GetFontFamilyNameLength(p, a)
#define IDWriteTextFormat1_GetFontFamilyName(p, a, b) (p)->lpVtbl->GetFontFamilyName(p, a, b)
#define IDWriteTextFormat1_GetFontWeight(p, a) (p)->lpVtbl->GetFontWeight(p, a)
#define IDWriteTextFormat1_GetFontStyle(p, a) (p)->lpVtbl->GetFontStyle(p, a)
#define IDWriteTextFormat1_GetFontStretch(p, a) (p)->lpVtbl->GetFontStretch(p, a)
#define IDWriteTextFormat1_GetFontSize(p, a) (p)->lpVtbl->GetFontSize(p, a)
#define IDWriteTextFormat1_GetLocaleNameLength(p, a) (p)->lpVtbl->GetLocaleNameLength(p, a)
#define IDWriteTextFormat1_GetLocaleName(p, a, b) (p)->lpVtbl->GetLocaleName(p, a, b)
#define IDWriteTextFormat1_SetVerticalGlyphOrientation(p, a) (p)->lpVtbl->SetVerticalGlyphOrientation(p, a)
#define IDWriteTextFormat1_GetVerticalGlyphOrientation(p, a) (p)->lpVtbl->GetVerticalGlyphOrientation(p, a)
#define IDWriteTextFormat1_SetLastLineWrapping(p, a) (p)->lpVtbl->SetLastLineWrapping(p, a)
#define IDWriteTextFormat1_GetLastLineWrapping(p, a) (p)->lpVtbl->GetLastLineWrapping(p, a)
#define IDWriteTextFormat1_SetOpticalAlignment(p, a) (p)->lpVtbl->SetOpticalAlignment(p, a)
#define IDWriteTextFormat1_GetOpticalAlignment(p, a) (p)->lpVtbl->GetOpticalAlignment(p, a)
#define IDWriteTextFormat1_SetFontFallback(p, a) (p)->lpVtbl->SetFontFallback(p, a)
#define IDWriteTextFormat1_GetFontFallback(p, a) (p)->lpVtbl->GetFontFallback(p, a)

' ============================================================================
' IDWriteTextLayout2
' ============================================================================
Type IDWriteTextLayout2Vtbl As IDWriteTextLayout2Vtbl_
Type IDWriteTextLayout2
    lpVtbl As IDWriteTextLayout2Vtbl Ptr
End Type
Type IDWriteTextLayout2Vtbl_     '' Extends IDWriteTextLayout1Vtbl_
    QueryInterface As Function(ByVal This As IDWriteTextLayout2 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteTextLayout2 Ptr) As ULong
    Release As Function(ByVal This As IDWriteTextLayout2 Ptr) As ULong
        
    SetTextAlignment As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal textAlignment As DWRITE_TEXT_ALIGNMENT ) As HRESULT
        ' 5. SetParagraphAlignment
    SetParagraphAlignment As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal paragraphAlignment As DWRITE_PARAGRAPH_ALIGNMENT ) As HRESULT
        ' 6. SetWordWrapping
    SetWordWrapping As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal wordWrapping As DWRITE_WORD_WRAPPING ) As HRESULT
        ' 7. SetReadingDirection
    SetReadingDirection As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal readingDirection As DWRITE_READING_DIRECTION ) As HRESULT
        ' 8. SetFlowDirection
    SetFlowDirection As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal flowDirection As DWRITE_FLOW_DIRECTION ) As HRESULT
        ' 9. SetIncrementalTabStop
    SetIncrementalTabStop As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal incrementalTabStop As Single ) As HRESULT
        ' 10. SetTrimming
    SetTrimming As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal trimmingOptions As DWRITE_TRIMMING Ptr, ByVal trimmingSign As Any Ptr ) As HRESULT
        ' 11. SetLineSpacing
    SetLineSpacing As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal lineSpacingMethod As DWRITE_LINE_SPACING_METHOD, ByVal lineSpacing As Single, ByVal baseline As Single ) As HRESULT
        ' 12. GetTextAlignment
    GetTextAlignment As Function(ByVal This As IDWriteTextLayout2 Ptr) As DWRITE_TEXT_ALIGNMENT
        ' 13. GetParagraphAlignment
    GetParagraphAlignment As Function(ByVal This As IDWriteTextLayout2 Ptr) As DWRITE_PARAGRAPH_ALIGNMENT
        ' 14. GetWordWrapping
    GetWordWrapping As Function(ByVal This As IDWriteTextLayout2 Ptr) As DWRITE_WORD_WRAPPING
        ' 15. GetReadingDirection
    GetReadingDirection As Function(ByVal This As IDWriteTextLayout2 Ptr) As DWRITE_READING_DIRECTION
        ' 16. GetFlowDirection
    GetFlowDirection As Function(ByVal This As IDWriteTextLayout2 Ptr) As DWRITE_FLOW_DIRECTION
        ' 17. GetIncrementalTabStop
    GetIncrementalTabStop As Function(ByVal This As IDWriteTextLayout2 Ptr) As Single
        ' 18. GetTrimming
    GetTrimming As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal trimmingOptions As DWRITE_TRIMMING Ptr, ByVal trimmingSign As Any Ptr Ptr ) As HRESULT
        ' 19. GetLineSpacing
    GetLineSpacing As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal lineSpacingMethod As DWRITE_LINE_SPACING_METHOD Ptr, ByVal lineSpacing As Single Ptr, ByVal baseline As Single Ptr ) As HRESULT
        ' 20. GetFontCollection
    GetFontCollection As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal fontCollection As Any Ptr Ptr ) As HRESULT
        ' 21. GetFontFamilyNameLength
    GetFontFamilyNameLength As Function(ByVal This As IDWriteTextLayout2 Ptr) As ULong
        ' 22. GetFontFamilyName
    GetFontFamilyName As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal fontFamilyName As WString Ptr, ByVal nameSize As ULong ) As HRESULT
        ' 23. GetFontWeight
    GetFontWeight As Function(ByVal This As IDWriteTextLayout2 Ptr) As DWRITE_FONT_WEIGHT
        ' 24. GetFontStyle
    GetFontStyle As Function(ByVal This As IDWriteTextLayout2 Ptr) As DWRITE_FONT_STYLE
        ' 25. GetFontStretch
    GetFontStretch As Function(ByVal This As IDWriteTextLayout2 Ptr) As DWRITE_FONT_STRETCH
        ' 26. GetFontSize
    GetFontSize As Function(ByVal This As IDWriteTextLayout2 Ptr) As Single
        ' 27. GetLocaleNameLength
    GetLocaleNameLength As Function(ByVal This As IDWriteTextLayout2 Ptr) As ULong
        ' 28. GetLocaleName
    GetLocaleName As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal localeName As WString Ptr, ByVal nameSize As ULong ) As HRESULT
        
    SetMaxWidth As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal maxWidth As Single ) As HRESULT
        ' 30. SetMaxHeight
    SetMaxHeight As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal maxHeight As Single ) As HRESULT
        ' 31. SetFontCollection
    SetFontCollection As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal fontCollection As Any Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 32. SetFontFamilyName
    SetFontFamilyName As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal fontFamilyName As WString Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 33. SetFontWeight
    SetFontWeight As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal fontWeight As DWRITE_FONT_WEIGHT, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 34. SetFontStyle
    SetFontStyle As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal fontStyle As DWRITE_FONT_STYLE, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 35. SetFontStretch
    SetFontStretch As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal fontStretch As DWRITE_FONT_STRETCH, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 36. SetFontSize
    SetFontSize As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal fontSize As Single, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 37. SetUnderline
    SetUnderline As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal hasUnderline As Long, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 38. SetStrikethrough
    SetStrikethrough As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal hasStrikethrough As Long, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 39. SetDrawingEffect
    SetDrawingEffect As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal drawingEffect As IUnknown Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 40. SetInlineObject
    SetInlineObject As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal inlineObject As Any Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 41. SetTypography
    SetTypography As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal typography As Any Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 42. SetLocaleName
    SetLocaleName As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal localeName As WString Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 43. GetMaxWidth
    GetMaxWidth As Function(ByVal This As IDWriteTextLayout2 Ptr) As Single
        ' 44. GetMaxHeight
    GetMaxHeight As Function(ByVal This As IDWriteTextLayout2 Ptr) As Single
        ' 45. GetFontCollection
    GetFontCollection1 As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal currentPosition As ULong, ByVal fontCollection As Any Ptr Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 46. GetFontFamilyNameLength
    GetFontFamilyNameLength1 As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal currentPosition As ULong, ByVal nameLength As ULong Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 47. GetFontFamilyName
    GetFontFamilyName1 As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal currentPosition As ULong, ByVal fontFamilyName As WString Ptr, ByVal nameSize As ULong, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 48. GetFontWeight
    GetFontWeight1 As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal currentPosition As ULong, ByVal fontWeight As DWRITE_FONT_WEIGHT Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 49. GetFontStyle
    GetFontStyle1 As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal currentPosition As ULong, ByVal fontStyle As DWRITE_FONT_STYLE Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 50. GetFontStretch
    GetFontStretch1 As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal currentPosition As ULong, ByVal fontStretch As DWRITE_FONT_STRETCH Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 51. GetFontSize
    GetFontSize1 As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal currentPosition As ULong, ByVal fontSize As Single Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 52. GetUnderline
    GetUnderline As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal currentPosition As ULong, ByVal hasUnderline As Long Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 53. GetStrikethrough
    GetStrikethrough As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal currentPosition As ULong, ByVal hasStrikethrough As Long Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 54. GetDrawingEffect
    GetDrawingEffect As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal currentPosition As ULong, ByVal drawingEffect As IUnknown Ptr Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 55. GetInlineObject
    GetInlineObject As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal currentPosition As ULong, ByVal inlineObject As Any Ptr Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 56. GetTypography
    GetTypography As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal currentPosition As ULong, ByVal typography As Any Ptr Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 57. GetLocaleNameLength
    GetLocaleNameLength1 As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal currentPosition As ULong, ByVal nameLength As ULong Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 58. GetLocaleName
    GetLocaleName1 As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal currentPosition As ULong, ByVal localeName As WString Ptr, ByVal nameSize As ULong, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 59. Draw
    Draw As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal renderer As Any Ptr, ByVal originX As Single, ByVal originY As Single ) As HRESULT
        ' 60. GetLineMetrics
    GetLineMetrics As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal lineMetrics As DWRITE_LINE_METRICS Ptr, ByVal maxLineCount As ULong, ByVal actualLineCount As ULong Ptr ) As HRESULT
        ' 61. GetMetrics
    GetMetrics As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal textMetrics As DWRITE_TEXT_METRICS Ptr ) As HRESULT
        ' 62. GetOverhangMetrics
    GetOverhangMetrics As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal overhangs As DWRITE_OVERHANG_METRICS Ptr ) As HRESULT
        ' 63. GetClusterMetrics
    GetClusterMetrics As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal clusterMetrics As DWRITE_CLUSTER_METRICS Ptr, ByVal maxClusterCount As ULong, ByVal actualClusterCount As ULong Ptr ) As HRESULT
        ' 64. DetermineMinWidth
    DetermineMinWidth As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal minWidth As Single Ptr ) As HRESULT
        ' 65. HitTestPoint
    HitTestPoint As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal pointX As Single, ByVal pointY As Single, ByVal isTrailingHit As Long Ptr, ByVal isInside As Long Ptr, ByVal hitTestMetrics As DWRITE_HIT_TEST_METRICS Ptr ) As HRESULT
        ' 66. HitTestTextPosition
    HitTestTextPosition As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal textPosition As ULong, ByVal isTrailingHit As Long, ByVal pointX As Single Ptr, ByVal pointY As Single Ptr, ByVal hitTestMetrics As DWRITE_HIT_TEST_METRICS Ptr ) As HRESULT
        ' 67. HitTestTextRange
    HitTestTextRange As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal textPosition As ULong, ByVal textLength As ULong, ByVal originX As Single, ByVal originY As Single, ByVal hitTestMetrics As DWRITE_HIT_TEST_METRICS Ptr, ByVal maxHitTestMetricsCount As ULong, ByVal actualHitTestMetricsCount As ULong Ptr ) As HRESULT
        
    SetPairKerning As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal isPairKerningEnabled As Long, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 69. GetPairKerning
    GetPairKerning As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal currentPosition As ULong, ByVal isPairKerningEnabled As Long Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 70. SetCharacterSpacing
    SetCharacterSpacing As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal leadingSpacing As Single, ByVal trailingSpacing As Single, ByVal minimumAdvanceWidth As Single, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 71. GetCharacterSpacing
    GetCharacterSpacing As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal currentPosition As ULong, ByVal leadingSpacing As Single Ptr, ByVal trailingSpacing As Single Ptr, ByVal minimumAdvanceWidth As Single Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT

        
    GetMetrics1 As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal textMetrics As DWRITE_TEXT_METRICS1 Ptr ) As HRESULT
        ' 73. SetVerticalGlyphOrientation
    SetVerticalGlyphOrientation As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal glyphOrientation As DWRITE_VERTICAL_GLYPH_ORIENTATION ) As HRESULT
        ' 74. GetVerticalGlyphOrientation
    GetVerticalGlyphOrientation As Function(ByVal This As IDWriteTextLayout2 Ptr) As DWRITE_VERTICAL_GLYPH_ORIENTATION
        ' 75. SetLastLineWrapping
    SetLastLineWrapping As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal isLastLineWrappingEnabled As Long ) As HRESULT
        ' 76. GetLastLineWrapping
    GetLastLineWrapping As Function(ByVal This As IDWriteTextLayout2 Ptr) As Long
        ' 77. SetOpticalAlignment
    SetOpticalAlignment As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal opticalAlignment As DWRITE_OPTICAL_ALIGNMENT ) As HRESULT
        ' 78. GetOpticalAlignment
    GetOpticalAlignment As Function(ByVal This As IDWriteTextLayout2 Ptr) As DWRITE_OPTICAL_ALIGNMENT
        ' 79. SetFontFallback
    SetFontFallback As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal fontFallback As IDWriteFontFallback Ptr ) As HRESULT
        ' 80. GetFontFallback
    GetFontFallback As Function(ByVal This As IDWriteTextLayout2 Ptr,  ByVal fontFallback As IDWriteFontFallback Ptr Ptr ) As HRESULT
End Type
#define IDWriteTextLayout2_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteTextLayout2_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteTextLayout2_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteTextLayout2_SetTextAlignment(p, a) (p)->lpVtbl->SetTextAlignment(p, a)
#define IDWriteTextLayout2_SetParagraphAlignment(p, a) (p)->lpVtbl->SetParagraphAlignment(p, a)
#define IDWriteTextLayout2_SetWordWrapping(p, a) (p)->lpVtbl->SetWordWrapping(p, a)
#define IDWriteTextLayout2_SetReadingDirection(p, a) (p)->lpVtbl->SetReadingDirection(p, a)
#define IDWriteTextLayout2_SetFlowDirection(p, a) (p)->lpVtbl->SetFlowDirection(p, a)
#define IDWriteTextLayout2_SetIncrementalTabStop(p, a) (p)->lpVtbl->SetIncrementalTabStop(p, a)
#define IDWriteTextLayout2_SetTrimming(p, a, b) (p)->lpVtbl->SetTrimming(p, a, b)
#define IDWriteTextLayout2_SetLineSpacing(p, a, b, c) (p)->lpVtbl->SetLineSpacing(p, a, b, c)
#define IDWriteTextLayout2_GetTextAlignment(p, a) (p)->lpVtbl->GetTextAlignment(p, a)
#define IDWriteTextLayout2_GetParagraphAlignment(p, a) (p)->lpVtbl->GetParagraphAlignment(p, a)
#define IDWriteTextLayout2_GetWordWrapping(p, a) (p)->lpVtbl->GetWordWrapping(p, a)
#define IDWriteTextLayout2_GetReadingDirection(p, a) (p)->lpVtbl->GetReadingDirection(p, a)
#define IDWriteTextLayout2_GetFlowDirection(p, a) (p)->lpVtbl->GetFlowDirection(p, a)
#define IDWriteTextLayout2_GetIncrementalTabStop(p, a) (p)->lpVtbl->GetIncrementalTabStop(p, a)
#define IDWriteTextLayout2_GetTrimming(p, a, b) (p)->lpVtbl->GetTrimming(p, a, b)
#define IDWriteTextLayout2_GetLineSpacing(p, a, b, c) (p)->lpVtbl->GetLineSpacing(p, a, b, c)
#define IDWriteTextLayout2_GetFontCollection(p, a) (p)->lpVtbl->GetFontCollection(p, a)
#define IDWriteTextLayout2_GetFontFamilyNameLength(p, a) (p)->lpVtbl->GetFontFamilyNameLength(p, a)
#define IDWriteTextLayout2_GetFontFamilyName(p, a, b) (p)->lpVtbl->GetFontFamilyName(p, a, b)
#define IDWriteTextLayout2_GetFontWeight(p, a) (p)->lpVtbl->GetFontWeight(p, a)
#define IDWriteTextLayout2_GetFontStyle(p, a) (p)->lpVtbl->GetFontStyle(p, a)
#define IDWriteTextLayout2_GetFontStretch(p, a) (p)->lpVtbl->GetFontStretch(p, a)
#define IDWriteTextLayout2_GetFontSize(p, a) (p)->lpVtbl->GetFontSize(p, a)
#define IDWriteTextLayout2_GetLocaleNameLength(p, a) (p)->lpVtbl->GetLocaleNameLength(p, a)
#define IDWriteTextLayout2_GetLocaleName(p, a, b) (p)->lpVtbl->GetLocaleName(p, a, b)
#define IDWriteTextLayout2_SetMaxWidth(p, a) (p)->lpVtbl->SetMaxWidth(p, a)
#define IDWriteTextLayout2_SetMaxHeight(p, a) (p)->lpVtbl->SetMaxHeight(p, a)
#define IDWriteTextLayout2_SetFontCollection(p, a, b) (p)->lpVtbl->SetFontCollection(p, a, b)
#define IDWriteTextLayout2_SetFontFamilyName(p, a, b) (p)->lpVtbl->SetFontFamilyName(p, a, b)
#define IDWriteTextLayout2_SetFontWeight(p, a, b) (p)->lpVtbl->SetFontWeight(p, a, b)
#define IDWriteTextLayout2_SetFontStyle(p, a, b) (p)->lpVtbl->SetFontStyle(p, a, b)
#define IDWriteTextLayout2_SetFontStretch(p, a, b) (p)->lpVtbl->SetFontStretch(p, a, b)
#define IDWriteTextLayout2_SetFontSize(p, a, b) (p)->lpVtbl->SetFontSize(p, a, b)
#define IDWriteTextLayout2_SetUnderline(p, a, b) (p)->lpVtbl->SetUnderline(p, a, b)
#define IDWriteTextLayout2_SetStrikethrough(p, a, b) (p)->lpVtbl->SetStrikethrough(p, a, b)
#define IDWriteTextLayout2_SetDrawingEffect(p, a, b) (p)->lpVtbl->SetDrawingEffect(p, a, b)
#define IDWriteTextLayout2_SetInlineObject(p, a, b) (p)->lpVtbl->SetInlineObject(p, a, b)
#define IDWriteTextLayout2_SetTypography(p, a, b) (p)->lpVtbl->SetTypography(p, a, b)
#define IDWriteTextLayout2_SetLocaleName(p, a, b) (p)->lpVtbl->SetLocaleName(p, a, b)
#define IDWriteTextLayout2_GetMaxWidth(p, a) (p)->lpVtbl->GetMaxWidth(p, a)
#define IDWriteTextLayout2_GetMaxHeight(p, a) (p)->lpVtbl->GetMaxHeight(p, a)
#define IDWriteTextLayout2_GetFontCollection1(p, a, b, c) (p)->lpVtbl->GetFontCollection1(p, a, b, c)
#define IDWriteTextLayout2_GetFontFamilyNameLength1(p, a, b, c) (p)->lpVtbl->GetFontFamilyNameLength1(p, a, b, c)
#define IDWriteTextLayout2_GetFontFamilyName1(p, a, b, c, d) (p)->lpVtbl->GetFontFamilyName1(p, a, b, c, d)
#define IDWriteTextLayout2_GetFontWeight1(p, a, b, c) (p)->lpVtbl->GetFontWeight1(p, a, b, c)
#define IDWriteTextLayout2_GetFontStyle1(p, a, b, c) (p)->lpVtbl->GetFontStyle1(p, a, b, c)
#define IDWriteTextLayout2_GetFontStretch1(p, a, b, c) (p)->lpVtbl->GetFontStretch1(p, a, b, c)
#define IDWriteTextLayout2_GetFontSize1(p, a, b, c) (p)->lpVtbl->GetFontSize1(p, a, b, c)
#define IDWriteTextLayout2_GetUnderline(p, a, b, c) (p)->lpVtbl->GetUnderline(p, a, b, c)
#define IDWriteTextLayout2_GetStrikethrough(p, a, b, c) (p)->lpVtbl->GetStrikethrough(p, a, b, c)
#define IDWriteTextLayout2_GetDrawingEffect(p, a, b, c) (p)->lpVtbl->GetDrawingEffect(p, a, b, c)
#define IDWriteTextLayout2_GetInlineObject(p, a, b, c) (p)->lpVtbl->GetInlineObject(p, a, b, c)
#define IDWriteTextLayout2_GetTypography(p, a, b, c) (p)->lpVtbl->GetTypography(p, a, b, c)
#define IDWriteTextLayout2_GetLocaleNameLength1(p, a, b, c) (p)->lpVtbl->GetLocaleNameLength1(p, a, b, c)
#define IDWriteTextLayout2_GetLocaleName1(p, a, b, c, d) (p)->lpVtbl->GetLocaleName1(p, a, b, c, d)
#define IDWriteTextLayout2_Draw(p, a, b, c, d) (p)->lpVtbl->Draw(p, a, b, c, d)
#define IDWriteTextLayout2_GetLineMetrics(p, a, b, c) (p)->lpVtbl->GetLineMetrics(p, a, b, c)
#define IDWriteTextLayout2_GetMetrics(p, a) (p)->lpVtbl->GetMetrics(p, a)
#define IDWriteTextLayout2_GetOverhangMetrics(p, a) (p)->lpVtbl->GetOverhangMetrics(p, a)
#define IDWriteTextLayout2_GetClusterMetrics(p, a, b, c) (p)->lpVtbl->GetClusterMetrics(p, a, b, c)
#define IDWriteTextLayout2_DetermineMinWidth(p, a) (p)->lpVtbl->DetermineMinWidth(p, a)
#define IDWriteTextLayout2_HitTestPoint(p, a, b, c, d, e) (p)->lpVtbl->HitTestPoint(p, a, b, c, d, e)
#define IDWriteTextLayout2_HitTestTextPosition(p, a, b, c, d, e) (p)->lpVtbl->HitTestTextPosition(p, a, b, c, d, e)
#define IDWriteTextLayout2_HitTestTextRange(p, a, b, c, d, e, f, g) (p)->lpVtbl->HitTestTextRange(p, a, b, c, d, e, f, g)
#define IDWriteTextLayout2_SetPairKerning(p, a, b) (p)->lpVtbl->SetPairKerning(p, a, b)
#define IDWriteTextLayout2_GetPairKerning(p, a, b, c) (p)->lpVtbl->GetPairKerning(p, a, b, c)
#define IDWriteTextLayout2_SetCharacterSpacing(p, a, b, c, d) (p)->lpVtbl->SetCharacterSpacing(p, a, b, c, d)
#define IDWriteTextLayout2_GetCharacterSpacing(p, a, b, c, d, e) (p)->lpVtbl->GetCharacterSpacing(p, a, b, c, d, e)
#define IDWriteTextLayout2_GetMetrics1(p, a) (p)->lpVtbl->GetMetrics1(p, a)
#define IDWriteTextLayout2_SetVerticalGlyphOrientation(p, a) (p)->lpVtbl->SetVerticalGlyphOrientation(p, a)
#define IDWriteTextLayout2_GetVerticalGlyphOrientation(p, a) (p)->lpVtbl->GetVerticalGlyphOrientation(p, a)
#define IDWriteTextLayout2_SetLastLineWrapping(p, a) (p)->lpVtbl->SetLastLineWrapping(p, a)
#define IDWriteTextLayout2_GetLastLineWrapping(p, a) (p)->lpVtbl->GetLastLineWrapping(p, a)
#define IDWriteTextLayout2_SetOpticalAlignment(p, a) (p)->lpVtbl->SetOpticalAlignment(p, a)
#define IDWriteTextLayout2_GetOpticalAlignment(p, a) (p)->lpVtbl->GetOpticalAlignment(p, a)
#define IDWriteTextLayout2_SetFontFallback(p, a) (p)->lpVtbl->SetFontFallback(p, a)
#define IDWriteTextLayout2_GetFontFallback(p, a) (p)->lpVtbl->GetFontFallback(p, a)

' ============================================================================
' IDWriteTextAnalyzer2
' ============================================================================
Type IDWriteTextAnalyzer2Vtbl As IDWriteTextAnalyzer2Vtbl_
Type IDWriteTextAnalyzer2
    lpVtbl As IDWriteTextAnalyzer2Vtbl Ptr
End Type
Type IDWriteTextAnalyzer2Vtbl_     '' Extends IDWriteTextAnalyzer1Vtbl_
    QueryInterface As Function(ByVal This As IDWriteTextAnalyzer2 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteTextAnalyzer2 Ptr) As ULong
    Release As Function(ByVal This As IDWriteTextAnalyzer2 Ptr) As ULong
        ' --- IUnknown (1-3) ---
        ' 2. AddRef
        ' 4.
    AnalyzeScript As Function(ByVal This As IDWriteTextAnalyzer2 Ptr, ByVal analysisSource As IDWriteTextAnalysisSource Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal analysisSink As IDWriteTextAnalysisSink Ptr) As HRESULT
    AnalyzeBidi As Function(ByVal This As IDWriteTextAnalyzer2 Ptr, ByVal analysisSource As IDWriteTextAnalysisSource Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal analysisSink As IDWriteTextAnalysisSink Ptr) As HRESULT
    AnalyzeNumberSubstitution As Function(ByVal This As IDWriteTextAnalyzer2 Ptr, ByVal analysisSource As IDWriteTextAnalysisSource Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal analysisSink As IDWriteTextAnalysisSink Ptr) As HRESULT
    AnalyzeLineBreakpoints As Function(ByVal This As IDWriteTextAnalyzer2 Ptr, ByVal analysisSource As IDWriteTextAnalysisSource Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal analysisSink As IDWriteTextAnalysisSink Ptr) As HRESULT
        ' Weist den Glyphen die korrekten OpenType-Features zu (Shaping).
    GetGlyphs As Function(ByVal This As IDWriteTextAnalyzer2 Ptr, ByVal textString As WString Ptr, ByVal textLength As ULong, ByVal fontFace As IDWriteFontFace Ptr, ByVal isSideways As Long, ByVal isRightToLeft As Long, ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS Ptr, ByVal localeName As WString Ptr, ByVal numberSubstitution As IDWriteNumberSubstitution Ptr, ByVal features As DWRITE_TYPOGRAPHIC_FEATURES Ptr Ptr, ByVal featureRangeLengths As ULong Ptr, ByVal featureRanges As ULong, ByVal maxGlyphCount As ULong, ByRef clusters As UShort Ptr, ByRef textProps As DWRITE_SHAPING_TEXT_PROPERTIES Ptr, ByRef glyphIndices As UShort Ptr, ByRef glyphProps As DWRITE_SHAPING_GLYPH_PROPERTIES Ptr, ByRef actualGlyphCount As ULong) As HRESULT
        ' Ermittelt die Platzierung der Glyphen (Advances und Offsets).
    GetGlyphPlacements As Function(ByVal This As IDWriteTextAnalyzer2 Ptr, ByVal textString As WString Ptr, ByVal clusters As UShort Ptr, ByRef textProps As DWRITE_SHAPING_TEXT_PROPERTIES Ptr, ByVal textLength As ULong, ByVal glyphIndices As UShort Ptr, ByRef glyphProps As DWRITE_SHAPING_GLYPH_PROPERTIES Ptr, ByVal glyphCount As ULong, ByVal fontFace As IDWriteFontFace Ptr, ByVal fontEmSize As Single, ByVal isSideways As Long, ByVal isRightToLeft As Long, ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS Ptr, ByVal localeName As WString Ptr, ByVal features As DWRITE_TYPOGRAPHIC_FEATURES Ptr Ptr, ByVal featureRangeLengths As ULong Ptr, ByVal featureRanges As ULong, ByRef glyphAdvances As Single Ptr, ByRef glyphOffsets As DWRITE_GLYPH_OFFSET Ptr) As HRESULT
        ' Platziert Glyphen so, dass sie exakt mit dem GDI-Raster übereinstimmen.
    GetGdiCompatibleGlyphPlacements As Function(ByVal This As IDWriteTextAnalyzer2 Ptr, ByVal textString As WString Ptr, ByVal clusters As UShort Ptr, ByRef textProps As DWRITE_SHAPING_TEXT_PROPERTIES Ptr, ByVal textLength As ULong, ByVal glyphIndices As UShort Ptr, ByRef glyphProps As DWRITE_SHAPING_GLYPH_PROPERTIES Ptr, ByVal glyphCount As ULong, ByVal fontFace As IDWriteFontFace Ptr, ByVal fontEmSize As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal useGdiNatural As Long, ByVal isSideways As Long, ByVal isRightToLeft As Long, ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS Ptr, ByVal localeName As WString Ptr, ByVal features As DWRITE_TYPOGRAPHIC_FEATURES Ptr Ptr, ByVal featureRangeLengths As ULong Ptr, ByVal featureRanges As ULong, ByRef glyphAdvances As Single Ptr, ByRef glyphOffsets As DWRITE_GLYPH_OFFSET Ptr) As HRESULT
        
        ' ApplyCharacterSpacing
    ApplyCharacterSpacing As Function(ByVal This As IDWriteTextAnalyzer2 Ptr,  ByVal leadingSpacing As Single, ByVal trailingSpacing As Single, ByVal minimumAdvanceWidth As Single, ByVal textLength As ULong, ByVal glyphCount As ULong, ByVal clusterMap As UShort Ptr, ByVal glyphAdvances As Single Ptr, ByVal glyphOffsets As DWRITE_GLYPH_OFFSET Ptr, ByVal glyphProperties As DWRITE_SHAPING_GLYPH_PROPERTIES Ptr, ByVal modifiedGlyphAdvances As Single Ptr, ByVal modifiedGlyphOffsets As DWRITE_GLYPH_OFFSET Ptr ) As HRESULT
        ' GetBaseline
    GetBaseline As Function(ByVal This As IDWriteTextAnalyzer2 Ptr,  ByVal fontFace As Any Ptr, ByVal baseline As DWRITE_BASELINE, ByVal isVertical As Long, ByVal isSimulationAllowed As Long, ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS, ByVal localeName As WString Ptr, ByVal baselineCoordinate As Long Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' AnalyzeVerticalGlyphOrientation
    AnalyzeVerticalGlyphOrientation As Function(ByVal This As IDWriteTextAnalyzer2 Ptr,  ByVal analysisSource As Any Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal analysisSink As Any Ptr ) As HRESULT
        ' GetGlyphOrientationTransform
    GetGlyphOrientationTransform As Function(ByVal This As IDWriteTextAnalyzer2 Ptr,  ByVal glyphOrientationAngle As DWRITE_GLYPH_ORIENTATION_ANGLE, ByVal isSideways As Long, ByVal transform As DWRITE_MATRIX Ptr ) As HRESULT
        ' GetScriptProperties
    GetScriptProperties As Function(ByVal This As IDWriteTextAnalyzer2 Ptr,  ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS, ByVal scriptProperties As DWRITE_SCRIPT_PROPERTIES Ptr ) As HRESULT
        ' GetTextComplexity
    GetTextComplexity As Function(ByVal This As IDWriteTextAnalyzer2 Ptr,  ByVal textString As WString Ptr, ByVal textLength As ULong, ByVal fontFace As Any Ptr, ByVal isTextSimple As Long Ptr, ByVal textLengthRead As ULong Ptr, ByVal glyphIndices As UShort Ptr ) As HRESULT
        ' GetJustificationOpportunities
    GetJustificationOpportunities As Function(ByVal This As IDWriteTextAnalyzer2 Ptr,  ByVal fontFace As Any Ptr, ByVal fontEmSize As Single, ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS, ByVal textLength As ULong, ByVal glyphCount As ULong, ByVal textString As WString Ptr, ByVal clusterMap As UShort Ptr, ByVal glyphProperties As DWRITE_SHAPING_GLYPH_PROPERTIES Ptr, ByVal justificationOpportunities As DWRITE_JUSTIFICATION_OPPORTUNITY Ptr ) As HRESULT
        ' JustifyGlyphAdvances
    JustifyGlyphAdvances As Function(ByVal This As IDWriteTextAnalyzer2 Ptr,  ByVal lineWidth As Single, ByVal glyphCount As ULong, ByVal justificationOpportunities As DWRITE_JUSTIFICATION_OPPORTUNITY Ptr, ByVal glyphAdvances As Single Ptr, ByVal glyphOffsets As DWRITE_GLYPH_OFFSET Ptr, ByVal justifiedGlyphAdvances As Single Ptr, ByVal justifiedGlyphOffsets As DWRITE_GLYPH_OFFSET Ptr ) As HRESULT
        ' GetJustifiedGlyphs
    GetJustifiedGlyphs As Function(ByVal This As IDWriteTextAnalyzer2 Ptr,  ByVal fontFace As Any Ptr, ByVal fontEmSize As Single, ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS, ByVal textLength As ULong, ByVal glyphCount As ULong, ByVal maxGlyphCount As ULong, ByVal clusterMap As UShort Ptr, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvances As Single Ptr, ByVal justifiedGlyphAdvances As Single Ptr, ByVal justifiedGlyphOffsets As DWRITE_GLYPH_OFFSET Ptr, ByVal glyphProperties As DWRITE_SHAPING_GLYPH_PROPERTIES Ptr, ByVal actualGlyphCount As ULong Ptr, ByVal modifiedClusterMap As UShort Ptr, ByVal modifiedGlyphIndices As UShort Ptr, ByVal modifiedGlyphAdvances As Single Ptr, ByVal modifiedGlyphOffsets As DWRITE_GLYPH_OFFSET Ptr ) As HRESULT

        
        ' GetGlyphOrientationTransform (erweiterte Version mit Origin)
    GetGlyphOrientationTransform1 As Function(ByVal This As IDWriteTextAnalyzer2 Ptr,  ByVal glyphOrientationAngle As DWRITE_GLYPH_ORIENTATION_ANGLE, ByVal isSideways As Long, ByVal originX As Single, ByVal originY As Single, ByVal transform As DWRITE_MATRIX Ptr ) As HRESULT
        ' GetTypographicFeatures
    GetTypographicFeatures As Function(ByVal This As IDWriteTextAnalyzer2 Ptr,  ByVal fontFace As IDWriteFontFace Ptr, ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS, ByVal localeName As WString Ptr, ByVal maxTagCount As ULong, ByVal actualTagCount As ULong Ptr, ByVal tags As DWRITE_FONT_FEATURE_TAG Ptr ) As HRESULT
        ' CheckTypographicFeature
    CheckTypographicFeature As Function(ByVal This As IDWriteTextAnalyzer2 Ptr,  ByVal fontFace As IDWriteFontFace Ptr, ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS, ByVal localeName As WString Ptr, ByVal featureTag As DWRITE_FONT_FEATURE_TAG, ByVal glyphCount As ULong, ByVal glyphIndices As UShort Ptr, ByVal featureApplies As Byte Ptr ) As HRESULT
End Type
#define IDWriteTextAnalyzer2_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteTextAnalyzer2_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteTextAnalyzer2_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteTextAnalyzer2_AnalyzeScript(p, a, b, c, d) (p)->lpVtbl->AnalyzeScript(p, a, b, c, d)
#define IDWriteTextAnalyzer2_AnalyzeBidi(p, a, b, c, d) (p)->lpVtbl->AnalyzeBidi(p, a, b, c, d)
#define IDWriteTextAnalyzer2_AnalyzeNumberSubstitution(p, a, b, c, d) (p)->lpVtbl->AnalyzeNumberSubstitution(p, a, b, c, d)
#define IDWriteTextAnalyzer2_AnalyzeLineBreakpoints(p, a, b, c, d) (p)->lpVtbl->AnalyzeLineBreakpoints(p, a, b, c, d)
#define IDWriteTextAnalyzer2_GetGlyphs(p, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, q, r) (p)->lpVtbl->GetGlyphs(p, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, q, r)
#define IDWriteTextAnalyzer2_GetGlyphPlacements(p, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, q, r, s) (p)->lpVtbl->GetGlyphPlacements(p, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, q, r, s)
#define IDWriteTextAnalyzer2_GetGdiCompatibleGlyphPlacements(p, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, q, r, s, t, u, v) (p)->lpVtbl->GetGdiCompatibleGlyphPlacements(p, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, q, r, s, t, u, v)
#define IDWriteTextAnalyzer2_ApplyCharacterSpacing(p, a, b, c, d, e, f, g, h, i, j, k) (p)->lpVtbl->ApplyCharacterSpacing(p, a, b, c, d, e, f, g, h, i, j, k)
#define IDWriteTextAnalyzer2_GetBaseline(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetBaseline(p, a, b, c, d, e, f, g, h)
#define IDWriteTextAnalyzer2_AnalyzeVerticalGlyphOrientation(p, a, b, c, d) (p)->lpVtbl->AnalyzeVerticalGlyphOrientation(p, a, b, c, d)
#define IDWriteTextAnalyzer2_GetGlyphOrientationTransform(p, a, b, c) (p)->lpVtbl->GetGlyphOrientationTransform(p, a, b, c)
#define IDWriteTextAnalyzer2_GetScriptProperties(p, a, b) (p)->lpVtbl->GetScriptProperties(p, a, b)
#define IDWriteTextAnalyzer2_GetTextComplexity(p, a, b, c, d, e, f) (p)->lpVtbl->GetTextComplexity(p, a, b, c, d, e, f)
#define IDWriteTextAnalyzer2_GetJustificationOpportunities(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->GetJustificationOpportunities(p, a, b, c, d, e, f, g, h, i)
#define IDWriteTextAnalyzer2_JustifyGlyphAdvances(p, a, b, c, d, e, f, g) (p)->lpVtbl->JustifyGlyphAdvances(p, a, b, c, d, e, f, g)
#define IDWriteTextAnalyzer2_GetJustifiedGlyphs(p, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, q, r) (p)->lpVtbl->GetJustifiedGlyphs(p, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, q, r)
#define IDWriteTextAnalyzer2_GetGlyphOrientationTransform1(p, a, b, c, d, e) (p)->lpVtbl->GetGlyphOrientationTransform1(p, a, b, c, d, e)
#define IDWriteTextAnalyzer2_GetTypographicFeatures(p, a, b, c, d, e, f) (p)->lpVtbl->GetTypographicFeatures(p, a, b, c, d, e, f)
#define IDWriteTextAnalyzer2_CheckTypographicFeature(p, a, b, c, d, e, f, g) (p)->lpVtbl->CheckTypographicFeature(p, a, b, c, d, e, f, g)

' ============================================================================
' IDWriteFontFallbackBuilder
' ============================================================================
Type IDWriteFontFallbackBuilderVtbl As IDWriteFontFallbackBuilderVtbl_
Type IDWriteFontFallbackBuilder
    lpVtbl As IDWriteFontFallbackBuilderVtbl Ptr
End Type
Type IDWriteFontFallbackBuilderVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontFallbackBuilder Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontFallbackBuilder Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontFallbackBuilder Ptr) As ULong

        
    AddMapping As Function(ByVal This As IDWriteFontFallbackBuilder Ptr,  ByVal ranges As DWRITE_UNICODE_RANGE Ptr, ByVal rangesCount As ULong, ByVal targetFamilyNames As WString Ptr Ptr, ByVal targetFamilyNamesCount As ULong, ByVal fontCollection As IDWriteFontCollection Ptr = 0, ByVal localeName As WString Ptr = 0, ByVal baseFamilyName As WString Ptr = 0, ByVal scale As Single = 1.0 ) As HRESULT
        ' 5. AddMappings
    AddMappings As Function(ByVal This As IDWriteFontFallbackBuilder Ptr,  ByVal fontFallback As IDWriteFontFallback Ptr ) As HRESULT
        ' 6. CreateFontFallback
    CreateFontFallback As Function(ByVal This As IDWriteFontFallbackBuilder Ptr,  ByVal fontFallback As IDWriteFontFallback Ptr Ptr ) As HRESULT
End Type
#define IDWriteFontFallbackBuilder_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontFallbackBuilder_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontFallbackBuilder_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontFallbackBuilder_AddMapping(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->AddMapping(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFallbackBuilder_AddMappings(p, a) (p)->lpVtbl->AddMappings(p, a)
#define IDWriteFontFallbackBuilder_CreateFontFallback(p, a) (p)->lpVtbl->CreateFontFallback(p, a)

' ============================================================================
' IDWriteFont2
' ============================================================================
Type IDWriteFont2Vtbl As IDWriteFont2Vtbl_
Type IDWriteFont2
    lpVtbl As IDWriteFont2Vtbl Ptr
End Type
Type IDWriteFont2Vtbl_     '' Extends IDWriteFont1Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFont2 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFont2 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFont2 Ptr) As ULong
        
    GetFontFamily As Function(ByVal This As IDWriteFont2 Ptr,  ByVal family As Any Ptr Ptr ) As HRESULT
        ' 5. GetWeight
    GetWeight As Function(ByVal This As IDWriteFont2 Ptr) As DWRITE_FONT_WEIGHT
        ' 6. GetStretch
    GetStretch As Function(ByVal This As IDWriteFont2 Ptr) As DWRITE_FONT_STRETCH
        ' 7. GetStyle
    GetStyle As Function(ByVal This As IDWriteFont2 Ptr) As DWRITE_FONT_STYLE
        ' 8. IsSymbolFont
    IsSymbolFont As Function(ByVal This As IDWriteFont2 Ptr) As Long
        ' 9. GetFaceNames
    GetFaceNames As Function(ByVal This As IDWriteFont2 Ptr,  ByVal names As Any Ptr Ptr ) As HRESULT
        ' 10. GetInformationalStrings
    GetInformationalStrings As Function(ByVal This As IDWriteFont2 Ptr,  ByVal informationalStringID As DWRITE_INFORMATIONAL_STRING_ID, ByVal informationalStrings As Any Ptr Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 11. GetSimulations
    GetSimulations As Function(ByVal This As IDWriteFont2 Ptr) As DWRITE_FONT_SIMULATIONS
        ' 12. GetMetrics
    GetMetrics As Sub(ByVal This As IDWriteFont2 Ptr,  ByVal fontMetrics As DWRITE_FONT_METRICS Ptr )
        ' 13. HasCharacter
    HasCharacter As Function(ByVal This As IDWriteFont2 Ptr,  ByVal unicodeValue As ULong, ByVal exists As Long Ptr ) As HRESULT
        ' 14. CreateFontFace
    CreateFontFace As Function(ByVal This As IDWriteFont2 Ptr,  ByVal fontFace As Any Ptr Ptr ) As HRESULT
        
    GetMetrics1 As Sub(ByVal This As IDWriteFont2 Ptr,  ByVal fontMetrics As DWRITE_FONT_METRICS1 Ptr )
        ' 16. GetPanose
    GetPanose As Sub(ByVal This As IDWriteFont2 Ptr,  ByVal panose As DWRITE_PANOSE Ptr )
        ' 17. GetUnicodeRanges
    GetUnicodeRanges As Function(ByVal This As IDWriteFont2 Ptr,  ByVal maxCount As ULong, ByVal unicodeRanges As DWRITE_UNICODE_RANGE Ptr, ByVal actualCount As ULong Ptr ) As HRESULT
        ' 18. IsMonospacedFont
    IsMonospacedFont As Function(ByVal This As IDWriteFont2 Ptr) As Long

        
    IsColorFont As Function(ByVal This As IDWriteFont2 Ptr) As Long
End Type
#define IDWriteFont2_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFont2_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFont2_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFont2_GetFontFamily(p, a) (p)->lpVtbl->GetFontFamily(p, a)
#define IDWriteFont2_GetWeight(p, a) (p)->lpVtbl->GetWeight(p, a)
#define IDWriteFont2_GetStretch(p, a) (p)->lpVtbl->GetStretch(p, a)
#define IDWriteFont2_GetStyle(p, a) (p)->lpVtbl->GetStyle(p, a)
#define IDWriteFont2_IsSymbolFont(p, a) (p)->lpVtbl->IsSymbolFont(p, a)
#define IDWriteFont2_GetFaceNames(p, a) (p)->lpVtbl->GetFaceNames(p, a)
#define IDWriteFont2_GetInformationalStrings(p, a, b, c) (p)->lpVtbl->GetInformationalStrings(p, a, b, c)
#define IDWriteFont2_GetSimulations(p, a) (p)->lpVtbl->GetSimulations(p, a)
#define IDWriteFont2_GetMetrics(p, a) (p)->lpVtbl->GetMetrics(p, a)
#define IDWriteFont2_HasCharacter(p, a, b) (p)->lpVtbl->HasCharacter(p, a, b)
#define IDWriteFont2_CreateFontFace(p, a) (p)->lpVtbl->CreateFontFace(p, a)
#define IDWriteFont2_GetMetrics1(p, a) (p)->lpVtbl->GetMetrics1(p, a)
#define IDWriteFont2_GetPanose(p, a) (p)->lpVtbl->GetPanose(p, a)
#define IDWriteFont2_GetUnicodeRanges(p, a, b, c) (p)->lpVtbl->GetUnicodeRanges(p, a, b, c)
#define IDWriteFont2_IsMonospacedFont(p, a) (p)->lpVtbl->IsMonospacedFont(p, a)
#define IDWriteFont2_IsColorFont(p, a) (p)->lpVtbl->IsColorFont(p, a)

' ============================================================================
' IDWriteFontFace2
' ============================================================================
Type IDWriteFontFace2Vtbl As IDWriteFontFace2Vtbl_
Type IDWriteFontFace2
    lpVtbl As IDWriteFontFace2Vtbl Ptr
End Type
Type IDWriteFontFace2Vtbl_     '' Extends IDWriteFontFace1Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFontFace2 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontFace2 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontFace2 Ptr) As ULong
        
    GetType As Function(ByVal This As IDWriteFontFace2 Ptr) As DWRITE_FONT_FACE_TYPE
        ' 5. GetFiles
    GetFiles As Function(ByVal This As IDWriteFontFace2 Ptr,  ByVal number_of_files As ULong Ptr, ByVal fontfiles As Any Ptr Ptr ) As HRESULT
        ' 6. GetIndex
    GetIndex As Function(ByVal This As IDWriteFontFace2 Ptr) As ULong
        ' 7. GetSimulations
    GetSimulations As Function(ByVal This As IDWriteFontFace2 Ptr) As DWRITE_FONT_SIMULATIONS
        ' 8. IsSymbolFont
    IsSymbolFont As Function(ByVal This As IDWriteFontFace2 Ptr) As Long
        ' 9. GetMetrics
    GetMetrics As Sub(ByVal This As IDWriteFontFace2 Ptr,  ByVal metrics As DWRITE_FONT_METRICS Ptr )
        ' 10. GetGlyphCount
    GetGlyphCount As Function(ByVal This As IDWriteFontFace2 Ptr) As UShort
        ' 11. GetDesignGlyphMetrics
    GetDesignGlyphMetrics As Function(ByVal This As IDWriteFontFace2 Ptr,  ByVal glyph_indices As UShort Ptr, ByVal glyph_count As ULong, ByVal metrics As DWRITE_GLYPH_METRICS Ptr, ByVal is_sideways As Long ) As HRESULT
        ' 12. GetGlyphIndices
    GetGlyphIndices As Function(ByVal This As IDWriteFontFace2 Ptr,  ByVal codepoints As ULong Ptr, ByVal count As ULong, ByVal glyph_indices As UShort Ptr ) As HRESULT
        ' 13. TryGetFontTable
    TryGetFontTable As Function(ByVal This As IDWriteFontFace2 Ptr,  ByVal table_tag As ULong, ByVal table_data As Any Ptr Ptr, ByVal table_size As ULong Ptr, ByVal context As Any Ptr Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 14. ReleaseFontTable
    ReleaseFontTable As Sub(ByVal This As IDWriteFontFace2 Ptr,  ByVal table_context As Any Ptr )
        ' 15. GetGlyphRunOutline
    GetGlyphRunOutline As Function(ByVal This As IDWriteFontFace2 Ptr,  ByVal emSize As Single, ByVal glyph_indices As UShort Ptr, ByVal glyph_advances As Single Ptr, ByVal glyph_offsets As DWRITE_GLYPH_OFFSET Ptr, ByVal glyph_count As ULong, ByVal is_sideways As Long, ByVal is_rtl As Long, ByVal geometrysink As Any Ptr ) As HRESULT
        ' 16. GetRecommendedRenderingMode
    GetRecommendedRenderingMode As Function(ByVal This As IDWriteFontFace2 Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal mode As DWRITE_MEASURING_MODE, ByVal params As IDWriteRenderingParams Ptr, ByVal rendering_mode As DWRITE_RENDERING_MODE Ptr ) As HRESULT
        ' 17. GetGdiCompatibleMetrics
    GetGdiCompatibleMetrics As Function(ByVal This As IDWriteFontFace2 Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal metrics As DWRITE_FONT_METRICS Ptr ) As HRESULT
        ' 18. GetGdiCompatibleGlyphMetrics
    GetGdiCompatibleGlyphMetrics As Function(ByVal This As IDWriteFontFace2 Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal use_gdi_natural As Long, ByVal glyph_indices As UShort Ptr, ByVal glyph_count As ULong, ByVal metrics As DWRITE_GLYPH_METRICS Ptr, ByVal is_sideways As Long ) As HRESULT
        
    GetMetrics1 As Sub(ByVal This As IDWriteFontFace2 Ptr,  ByVal metrics As DWRITE_FONT_METRICS1 Ptr )
        ' 20. GetGdiCompatibleMetrics
    GetGdiCompatibleMetrics1 As Function(ByVal This As IDWriteFontFace2 Ptr,  ByVal emSize As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal metrics As DWRITE_FONT_METRICS1 Ptr ) As HRESULT
        ' 21. GetCaretMetrics
    GetCaretMetrics As Sub(ByVal This As IDWriteFontFace2 Ptr,  ByVal metrics As DWRITE_CARET_METRICS Ptr )
        ' 22. GetUnicodeRanges
    GetUnicodeRanges As Function(ByVal This As IDWriteFontFace2 Ptr,  ByVal maxCount As ULong, ByVal ranges As DWRITE_UNICODE_RANGE Ptr, ByVal count As ULong Ptr ) As HRESULT
        ' 23. IsMonospacedFont
    IsMonospacedFont As Function(ByVal This As IDWriteFontFace2 Ptr) As Long
        ' 24. GetDesignGlyphAdvances
    GetDesignGlyphAdvances As Function(ByVal This As IDWriteFontFace2 Ptr,  ByVal glyphCount As ULong, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvances As Long Ptr, ByVal isSideways As Long = 0 ) As HRESULT
        ' 25. GetGdiCompatibleGlyphAdvances
    GetGdiCompatibleGlyphAdvances As Function(ByVal This As IDWriteFontFace2 Ptr,  ByVal emSize As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal useGdiNatural As Long, ByVal isSideways As Long, ByVal glyphCount As ULong, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvances As Long Ptr ) As HRESULT
        ' 26. GetKerningPairAdjustments
    GetKerningPairAdjustments As Function(ByVal This As IDWriteFontFace2 Ptr,  ByVal glyphCount As ULong, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvanceAdjustments As Long Ptr ) As HRESULT
        ' 27. HasKerningPairs
    HasKerningPairs As Function(ByVal This As IDWriteFontFace2 Ptr) As Long
        ' 28. GetRecommendedRenderingMode
    GetRecommendedRenderingMode1 As Function(ByVal This As IDWriteFontFace2 Ptr,  ByVal fontEmSize As Single, ByVal dpiX As Single, ByVal dpiY As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal isSideways As Long, ByVal outlineThreshold As DWRITE_OUTLINE_THRESHOLD, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal renderingMode As DWRITE_RENDERING_MODE Ptr ) As HRESULT
        ' 29. GetVerticalGlyphVariants
    GetVerticalGlyphVariants As Function(ByVal This As IDWriteFontFace2 Ptr,  ByVal glyphCount As ULong, ByVal nominalGlyphIndices As UShort Ptr, ByVal verticalGlyphIndices As UShort Ptr ) As HRESULT
        ' 30. HasVerticalGlyphVariants
    HasVerticalGlyphVariants As Function(ByVal This As IDWriteFontFace2 Ptr) As Long

        
    IsColorFont As Function(ByVal This As IDWriteFontFace2 Ptr) As Long
        ' 32. GetColorPaletteCount
    GetColorPaletteCount As Function(ByVal This As IDWriteFontFace2 Ptr) As ULong
        ' 33. GetPaletteEntryCount
    GetPaletteEntryCount As Function(ByVal This As IDWriteFontFace2 Ptr) As ULong
        ' 34. GetPaletteEntries
    GetPaletteEntries As Function(ByVal This As IDWriteFontFace2 Ptr,  ByVal colorPaletteIndex As ULong, ByVal firstEntryIndex As ULong, ByVal entryCount As ULong, ByVal paletteEntries As DWRITE_COLOR_F Ptr ) As HRESULT
        ' 35. GetRecommendedRenderingMode
    GetRecommendedRenderingMode2 As Function(ByVal This As IDWriteFontFace2 Ptr,  ByVal fontEmSize As Single, ByVal dpiX As Single, ByVal dpiY As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal isSideways As Long, ByVal outlineThreshold As DWRITE_OUTLINE_THRESHOLD, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal renderingParams As IDWriteRenderingParams Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE Ptr, ByVal gridFitMode As DWRITE_GRID_FIT_MODE Ptr ) As HRESULT
End Type
#define IDWriteFontFace2_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontFace2_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontFace2_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontFace2_GetType(p, a) (p)->lpVtbl->GetType(p, a)
#define IDWriteFontFace2_GetFiles(p, a, b) (p)->lpVtbl->GetFiles(p, a, b)
#define IDWriteFontFace2_GetIndex(p, a) (p)->lpVtbl->GetIndex(p, a)
#define IDWriteFontFace2_GetSimulations(p, a) (p)->lpVtbl->GetSimulations(p, a)
#define IDWriteFontFace2_IsSymbolFont(p, a) (p)->lpVtbl->IsSymbolFont(p, a)
#define IDWriteFontFace2_GetMetrics(p, a) (p)->lpVtbl->GetMetrics(p, a)
#define IDWriteFontFace2_GetGlyphCount(p, a) (p)->lpVtbl->GetGlyphCount(p, a)
#define IDWriteFontFace2_GetDesignGlyphMetrics(p, a, b, c, d) (p)->lpVtbl->GetDesignGlyphMetrics(p, a, b, c, d)
#define IDWriteFontFace2_GetGlyphIndices(p, a, b, c) (p)->lpVtbl->GetGlyphIndices(p, a, b, c)
#define IDWriteFontFace2_TryGetFontTable(p, a, b, c, d, e) (p)->lpVtbl->TryGetFontTable(p, a, b, c, d, e)
#define IDWriteFontFace2_ReleaseFontTable(p, a) (p)->lpVtbl->ReleaseFontTable(p, a)
#define IDWriteFontFace2_GetGlyphRunOutline(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGlyphRunOutline(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace2_GetRecommendedRenderingMode(p, a, b, c, d, e) (p)->lpVtbl->GetRecommendedRenderingMode(p, a, b, c, d, e)
#define IDWriteFontFace2_GetGdiCompatibleMetrics(p, a, b, c, d) (p)->lpVtbl->GetGdiCompatibleMetrics(p, a, b, c, d)
#define IDWriteFontFace2_GetGdiCompatibleGlyphMetrics(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGdiCompatibleGlyphMetrics(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace2_GetMetrics1(p, a) (p)->lpVtbl->GetMetrics1(p, a)
#define IDWriteFontFace2_GetGdiCompatibleMetrics1(p, a, b, c, d) (p)->lpVtbl->GetGdiCompatibleMetrics1(p, a, b, c, d)
#define IDWriteFontFace2_GetCaretMetrics(p, a) (p)->lpVtbl->GetCaretMetrics(p, a)
#define IDWriteFontFace2_GetUnicodeRanges(p, a, b, c) (p)->lpVtbl->GetUnicodeRanges(p, a, b, c)
#define IDWriteFontFace2_IsMonospacedFont(p, a) (p)->lpVtbl->IsMonospacedFont(p, a)
#define IDWriteFontFace2_GetDesignGlyphAdvances(p, a, b, c, d) (p)->lpVtbl->GetDesignGlyphAdvances(p, a, b, c, d)
#define IDWriteFontFace2_GetGdiCompatibleGlyphAdvances(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGdiCompatibleGlyphAdvances(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace2_GetKerningPairAdjustments(p, a, b, c) (p)->lpVtbl->GetKerningPairAdjustments(p, a, b, c)
#define IDWriteFontFace2_HasKerningPairs(p, a) (p)->lpVtbl->HasKerningPairs(p, a)
#define IDWriteFontFace2_GetRecommendedRenderingMode1(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetRecommendedRenderingMode1(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace2_GetVerticalGlyphVariants(p, a, b, c) (p)->lpVtbl->GetVerticalGlyphVariants(p, a, b, c)
#define IDWriteFontFace2_HasVerticalGlyphVariants(p, a) (p)->lpVtbl->HasVerticalGlyphVariants(p, a)
#define IDWriteFontFace2_IsColorFont(p, a) (p)->lpVtbl->IsColorFont(p, a)
#define IDWriteFontFace2_GetColorPaletteCount(p, a) (p)->lpVtbl->GetColorPaletteCount(p, a)
#define IDWriteFontFace2_GetPaletteEntryCount(p, a) (p)->lpVtbl->GetPaletteEntryCount(p, a)
#define IDWriteFontFace2_GetPaletteEntries(p, a, b, c, d) (p)->lpVtbl->GetPaletteEntries(p, a, b, c, d)
#define IDWriteFontFace2_GetRecommendedRenderingMode2(p, a, b, c, d, e, f, g, h, i, j) (p)->lpVtbl->GetRecommendedRenderingMode2(p, a, b, c, d, e, f, g, h, i, j)

' ============================================================================
' IDWriteColorGlyphRunEnumerator
' ============================================================================
Type IDWriteColorGlyphRunEnumeratorVtbl As IDWriteColorGlyphRunEnumeratorVtbl_
Type IDWriteColorGlyphRunEnumerator
    lpVtbl As IDWriteColorGlyphRunEnumeratorVtbl Ptr
End Type
Type IDWriteColorGlyphRunEnumeratorVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteColorGlyphRunEnumerator Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteColorGlyphRunEnumerator Ptr) As ULong
    Release As Function(ByVal This As IDWriteColorGlyphRunEnumerator Ptr) As ULong

        
    MoveNext As Function(ByVal This As IDWriteColorGlyphRunEnumerator Ptr,  ByVal hasRun As Long Ptr ) As HRESULT
        ' 5. GetCurrentRun
    GetCurrentRun As Function(ByVal This As IDWriteColorGlyphRunEnumerator Ptr,  ByVal colorGlyphRun As DWRITE_COLOR_GLYPH_RUN Ptr Ptr ) As HRESULT
End Type
#define IDWriteColorGlyphRunEnumerator_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteColorGlyphRunEnumerator_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteColorGlyphRunEnumerator_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteColorGlyphRunEnumerator_MoveNext(p, a) (p)->lpVtbl->MoveNext(p, a)
#define IDWriteColorGlyphRunEnumerator_GetCurrentRun(p, a) (p)->lpVtbl->GetCurrentRun(p, a)

' ============================================================================
' IDWriteRenderingParams2
' ============================================================================
Type IDWriteRenderingParams2Vtbl As IDWriteRenderingParams2Vtbl_
Type IDWriteRenderingParams2
    lpVtbl As IDWriteRenderingParams2Vtbl Ptr
End Type
Type IDWriteRenderingParams2Vtbl_     '' Extends IDWriteRenderingParams1Vtbl_
    QueryInterface As Function(ByVal This As IDWriteRenderingParams2 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteRenderingParams2 Ptr) As ULong
    Release As Function(ByVal This As IDWriteRenderingParams2 Ptr) As ULong
        
    GetGamma As Function(ByVal This As IDWriteRenderingParams2 Ptr) As Single
        ' 5. GetEnhancedContrast
    GetEnhancedContrast As Function(ByVal This As IDWriteRenderingParams2 Ptr) As Single
        ' 6. GetClearTypeLevel
    GetClearTypeLevel As Function(ByVal This As IDWriteRenderingParams2 Ptr) As Single
        ' 7. GetPixelGeometry
    GetPixelGeometry As Function(ByVal This As IDWriteRenderingParams2 Ptr) As DWRITE_PIXEL_GEOMETRY
        ' 8. GetRenderingMode
    GetRenderingMode As Function(ByVal This As IDWriteRenderingParams2 Ptr) As DWRITE_RENDERING_MODE
        
    GetGrayscaleEnhancedContrast As Function(ByVal This As IDWriteRenderingParams2 Ptr) As Single

        
    GetGridFitMode As Function(ByVal This As IDWriteRenderingParams2 Ptr) As DWRITE_GRID_FIT_MODE
End Type
#define IDWriteRenderingParams2_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteRenderingParams2_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteRenderingParams2_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteRenderingParams2_GetGamma(p, a) (p)->lpVtbl->GetGamma(p, a)
#define IDWriteRenderingParams2_GetEnhancedContrast(p, a) (p)->lpVtbl->GetEnhancedContrast(p, a)
#define IDWriteRenderingParams2_GetClearTypeLevel(p, a) (p)->lpVtbl->GetClearTypeLevel(p, a)
#define IDWriteRenderingParams2_GetPixelGeometry(p, a) (p)->lpVtbl->GetPixelGeometry(p, a)
#define IDWriteRenderingParams2_GetRenderingMode(p, a) (p)->lpVtbl->GetRenderingMode(p, a)
#define IDWriteRenderingParams2_GetGrayscaleEnhancedContrast(p, a) (p)->lpVtbl->GetGrayscaleEnhancedContrast(p, a)
#define IDWriteRenderingParams2_GetGridFitMode(p, a) (p)->lpVtbl->GetGridFitMode(p, a)

' ============================================================================
' IDWriteFactory2
' ============================================================================
Type IDWriteFactory2Vtbl As IDWriteFactory2Vtbl_
Type IDWriteFactory2
    lpVtbl As IDWriteFactory2Vtbl Ptr
End Type
Type IDWriteFactory2Vtbl_     '' Extends IDWriteFactory1Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFactory2 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFactory2 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFactory2 Ptr) As ULong
        
    GetSystemFontCollection As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal fontCollection As Any Ptr Ptr, ByVal checkForUpdates As Long = 0 ) As HRESULT
        ' 5. CreateCustomFontCollection
    CreateCustomFontCollection As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal collectionLoader As Any Ptr, ByVal collectionKey As Any Ptr, ByVal collectionKeySize As ULong, ByVal fontCollection As Any Ptr Ptr ) As HRESULT
        ' 6. RegisterFontCollectionLoader
    RegisterFontCollectionLoader As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal fontCollectionLoader As Any Ptr ) As HRESULT
        ' 7. UnregisterFontCollectionLoader
    UnregisterFontCollectionLoader As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal fontCollectionLoader As Any Ptr ) As HRESULT
        ' 8. CreateFontFileReference
    CreateFontFileReference As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal filePath As WString Ptr, ByVal lastWriteTime As FILETIME Ptr, ByVal fontFile As Any Ptr Ptr ) As HRESULT
        ' 9. CreateCustomFontFileReference
    CreateCustomFontFileReference As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal fontFileReferenceKey As Any Ptr, ByVal fontFileReferenceKeySize As ULong, ByVal fontFileLoader As Any Ptr, ByVal fontFile As Any Ptr Ptr ) As HRESULT
        ' 10. CreateFontFace
    CreateFontFace As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal fontFaceType As DWRITE_FONT_FACE_TYPE, ByVal numberOfFiles As ULong, ByVal fontFiles As Any Ptr Ptr, ByVal faceIndex As ULong, ByVal fontFaceSimulationFlags As DWRITE_FONT_SIMULATIONS, ByVal fontFace As Any Ptr Ptr ) As HRESULT
        ' 11. CreateRenderingParams
    CreateRenderingParams As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 12. CreateMonitorRenderingParams
    CreateMonitorRenderingParams As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal monitor As HMONITOR, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 13. CreateCustomRenderingParams
    CreateCustomRenderingParams As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 14. RegisterFontFileLoader
    RegisterFontFileLoader As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal fontFileLoader As Any Ptr ) As HRESULT
        ' 15. UnregisterFontFileLoader
    UnregisterFontFileLoader As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal fontFileLoader As Any Ptr ) As HRESULT
        ' 16. CreateTextFormat
    CreateTextFormat As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal fontFamilyName As WString Ptr, ByVal fontCollection As Any Ptr, ByVal fontWeight As DWRITE_FONT_WEIGHT, ByVal fontStyle As DWRITE_FONT_STYLE, ByVal fontStretch As DWRITE_FONT_STRETCH, ByVal fontSize As Single, ByVal localeName As WString Ptr, ByVal textFormat As IDWriteTextFormat Ptr Ptr ) As HRESULT
        ' 17. CreateTypography
    CreateTypography As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal typography As Any Ptr Ptr ) As HRESULT
        ' 18. GetGdiInterop
    GetGdiInterop As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal gdiInterop As Any Ptr Ptr ) As HRESULT
        ' 19. CreateTextLayout
    CreateTextLayout As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal string As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal maxWidth As Single, ByVal maxHeight As Single, ByVal textLayout As Any Ptr Ptr ) As HRESULT
        ' 20. CreateGdiCompatibleTextLayout
    CreateGdiCompatibleTextLayout As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal string As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal layoutWidth As Single, ByVal layoutHeight As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal useGdiNatural As Long, ByVal textLayout As Any Ptr Ptr ) As HRESULT
        ' 21. CreateEllipsisTrimmingSign
    CreateEllipsisTrimmingSign As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal textFormat As Any Ptr, ByVal trimmingSign As Any Ptr Ptr ) As HRESULT
        ' 22. CreateTextAnalyzer
    CreateTextAnalyzer As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal textAnalyzer As Any Ptr Ptr ) As HRESULT
        ' 23. CreateNumberSubstitution
    CreateNumberSubstitution As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal substitutionMethod As DWRITE_NUMBER_SUBSTITUTION_METHOD, ByVal localeName As WString Ptr, ByVal ignoreUserOverride As Long, ByVal numberSubstitution As Any Ptr Ptr ) As HRESULT
        ' 24. CreateGlyphRunAnalysis
    CreateGlyphRunAnalysis As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRunAnalysis As Any Ptr Ptr ) As HRESULT
        
    GetEudcFontCollection As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal collection As Any Ptr Ptr, ByVal checkForUpdates As Long = 0 ) As HRESULT
        ' 26. CreateCustomRenderingParams
    CreateCustomRenderingParams1 As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal enhancedContrastGrayscale As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal renderingParams As Any Ptr Ptr ) As HRESULT

        
    GetSystemFontFallback As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal fontFallback As IDWriteFontFallback Ptr Ptr ) As HRESULT
        ' 28. CreateFontFallbackBuilder
    CreateFontFallbackBuilder As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal fontFallbackBuilder As IDWriteFontFallbackBuilder Ptr Ptr ) As HRESULT
        ' 29. TranslateColorGlyphRun
    TranslateColorGlyphRun As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal worldToDeviceTransform As DWRITE_MATRIX Ptr, ByVal colorPaletteIndex As ULong, ByVal colorLayers As IDWriteColorGlyphRunEnumerator Ptr Ptr ) As HRESULT
        ' 30. CreateCustomRenderingParams
    CreateCustomRenderingParams2 As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal grayscaleEnhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal renderingParams As IDWriteRenderingParams2 Ptr Ptr ) As HRESULT
        ' 31. CreateGlyphRunAnalysis
    CreateGlyphRunAnalysis1 As Function(ByVal This As IDWriteFactory2 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal transform As DWRITE_MATRIX Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal antialiasMode As DWRITE_TEXT_ANTIALIAS_MODE, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRunAnalysis As IDWriteGlyphRunAnalysis Ptr Ptr ) As HRESULT
End Type
#define IDWriteFactory2_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFactory2_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFactory2_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFactory2_GetSystemFontCollection(p, a, b) (p)->lpVtbl->GetSystemFontCollection(p, a, b)
#define IDWriteFactory2_CreateCustomFontCollection(p, a, b, c, d) (p)->lpVtbl->CreateCustomFontCollection(p, a, b, c, d)
#define IDWriteFactory2_RegisterFontCollectionLoader(p, a) (p)->lpVtbl->RegisterFontCollectionLoader(p, a)
#define IDWriteFactory2_UnregisterFontCollectionLoader(p, a) (p)->lpVtbl->UnregisterFontCollectionLoader(p, a)
#define IDWriteFactory2_CreateFontFileReference(p, a, b, c) (p)->lpVtbl->CreateFontFileReference(p, a, b, c)
#define IDWriteFactory2_CreateCustomFontFileReference(p, a, b, c, d) (p)->lpVtbl->CreateCustomFontFileReference(p, a, b, c, d)
#define IDWriteFactory2_CreateFontFace(p, a, b, c, d, e, f) (p)->lpVtbl->CreateFontFace(p, a, b, c, d, e, f)
#define IDWriteFactory2_CreateRenderingParams(p, a) (p)->lpVtbl->CreateRenderingParams(p, a)
#define IDWriteFactory2_CreateMonitorRenderingParams(p, a, b) (p)->lpVtbl->CreateMonitorRenderingParams(p, a, b)
#define IDWriteFactory2_CreateCustomRenderingParams(p, a, b, c, d, e, f) (p)->lpVtbl->CreateCustomRenderingParams(p, a, b, c, d, e, f)
#define IDWriteFactory2_RegisterFontFileLoader(p, a) (p)->lpVtbl->RegisterFontFileLoader(p, a)
#define IDWriteFactory2_UnregisterFontFileLoader(p, a) (p)->lpVtbl->UnregisterFontFileLoader(p, a)
#define IDWriteFactory2_CreateTextFormat(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateTextFormat(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory2_CreateTypography(p, a) (p)->lpVtbl->CreateTypography(p, a)
#define IDWriteFactory2_GetGdiInterop(p, a) (p)->lpVtbl->GetGdiInterop(p, a)
#define IDWriteFactory2_CreateTextLayout(p, a, b, c, d, e, f) (p)->lpVtbl->CreateTextLayout(p, a, b, c, d, e, f)
#define IDWriteFactory2_CreateGdiCompatibleTextLayout(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->CreateGdiCompatibleTextLayout(p, a, b, c, d, e, f, g, h, i)
#define IDWriteFactory2_CreateEllipsisTrimmingSign(p, a, b) (p)->lpVtbl->CreateEllipsisTrimmingSign(p, a, b)
#define IDWriteFactory2_CreateTextAnalyzer(p, a) (p)->lpVtbl->CreateTextAnalyzer(p, a)
#define IDWriteFactory2_CreateNumberSubstitution(p, a, b, c, d) (p)->lpVtbl->CreateNumberSubstitution(p, a, b, c, d)
#define IDWriteFactory2_CreateGlyphRunAnalysis(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateGlyphRunAnalysis(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory2_GetEudcFontCollection(p, a, b) (p)->lpVtbl->GetEudcFontCollection(p, a, b)
#define IDWriteFactory2_CreateCustomRenderingParams1(p, a, b, c, d, e, f, g) (p)->lpVtbl->CreateCustomRenderingParams1(p, a, b, c, d, e, f, g)
#define IDWriteFactory2_GetSystemFontFallback(p, a) (p)->lpVtbl->GetSystemFontFallback(p, a)
#define IDWriteFactory2_CreateFontFallbackBuilder(p, a) (p)->lpVtbl->CreateFontFallbackBuilder(p, a)
#define IDWriteFactory2_TranslateColorGlyphRun(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->TranslateColorGlyphRun(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory2_CreateCustomRenderingParams2(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateCustomRenderingParams2(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory2_CreateGlyphRunAnalysis1(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->CreateGlyphRunAnalysis1(p, a, b, c, d, e, f, g, h, i)

