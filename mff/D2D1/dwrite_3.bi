'###############################################################################
' This file is part of MyFBFramework
' Authors: UEZ, Xusinboy Bekchanov, Liu XiaLin
' Based on UEZ's abstract version.
' Direct2D 1.2 API - FreeBASIC Translation
' Adapted by Xusinboy Bekchanov, Liu XiaLin
'###############################################################################

#pragma once
#include once "dwrite_2.bi"
' ============================================================================
' Forward Declarations
' ============================================================================
Type IDWriteFontFaceReference As IDWriteFontFaceReference_
Type IDWriteFontFaceReference1 As IDWriteFontFaceReference1_
Type IDWriteFontFace3 As IDWriteFontFace3_
Type IDWriteFontSet As IDWriteFontSet_
Type IDWriteFontDownloadQueue As IDWriteFontDownloadQueue_
Type IDWriteFontFace5 As IDWriteFontFace5_
Type IDWriteFontList2 As IDWriteFontList2_
' FONTSIGNATURE (already defined in wingdi.h but needed for WIDL)
#ifndef _WINGDI_
Type FONTSIGNATURE As FONTSIGNATURE_
#endif
' D2D1_GRADIENT_STOP (already defined in d2d1.idl)
'Type D2D1_GRADIENT_STOP As D2D1_GRADIENT_STOP_
' ============================================================================
' Enumerations
' ============================================================================
Type DWRITE_COLOR_COMPOSITE_MODE As Long
Enum
    DWRITE_COLOR_COMPOSITE_CLEAR
    DWRITE_COLOR_COMPOSITE_SRC
    DWRITE_COLOR_COMPOSITE_DEST
    DWRITE_COLOR_COMPOSITE_SRC_OVER
    DWRITE_COLOR_COMPOSITE_DEST_OVER
    DWRITE_COLOR_COMPOSITE_SRC_IN
    DWRITE_COLOR_COMPOSITE_DEST_IN
    DWRITE_COLOR_COMPOSITE_SRC_OUT
    DWRITE_COLOR_COMPOSITE_DEST_OUT
    DWRITE_COLOR_COMPOSITE_SRC_ATOP
    DWRITE_COLOR_COMPOSITE_DEST_ATOP
    DWRITE_COLOR_COMPOSITE_XOR
    DWRITE_COLOR_COMPOSITE_PLUS
    DWRITE_COLOR_COMPOSITE_SCREEN
    DWRITE_COLOR_COMPOSITE_OVERLAY
    DWRITE_COLOR_COMPOSITE_DARKEN
    DWRITE_COLOR_COMPOSITE_LIGHTEN
    DWRITE_COLOR_COMPOSITE_COLOR_DODGE
    DWRITE_COLOR_COMPOSITE_COLOR_BURN
    DWRITE_COLOR_COMPOSITE_HARD_LIGHT
    DWRITE_COLOR_COMPOSITE_SOFT_LIGHT
    DWRITE_COLOR_COMPOSITE_DIFFERENCE
    DWRITE_COLOR_COMPOSITE_EXCLUSION
    DWRITE_COLOR_COMPOSITE_MULTIPLY
    DWRITE_COLOR_COMPOSITE_HSL_HUE
    DWRITE_COLOR_COMPOSITE_HSL_SATURATION
    DWRITE_COLOR_COMPOSITE_HSL_COLOR
    DWRITE_COLOR_COMPOSITE_HSL_LUMINOSITY
End Enum
Type DWRITE_LOCALITY As Long
Enum
    DWRITE_LOCALITY_REMOTE
    DWRITE_LOCALITY_PARTIAL
    DWRITE_LOCALITY_LOCAL
End Enum
Type DWRITE_RENDERING_MODE1 As Long
Enum
    DWRITE_RENDERING_MODE1_DEFAULT
    DWRITE_RENDERING_MODE1_ALIASED
    DWRITE_RENDERING_MODE1_GDI_CLASSIC
    DWRITE_RENDERING_MODE1_GDI_NATURAL
    DWRITE_RENDERING_MODE1_NATURAL
    DWRITE_RENDERING_MODE1_NATURAL_SYMMETRIC
    DWRITE_RENDERING_MODE1_OUTLINE
    DWRITE_RENDERING_MODE1_NATURAL_SYMMETRIC_DOWNSAMPLED
End Enum
Type DWRITE_FONT_PROPERTY_ID As Long
Enum
    DWRITE_FONT_PROPERTY_ID_NONE
    DWRITE_FONT_PROPERTY_ID_WEIGHT_STRETCH_STYLE_FAMILY_NAME
    DWRITE_FONT_PROPERTY_ID_TYPOGRAPHIC_FAMILY_NAME
    DWRITE_FONT_PROPERTY_ID_WEIGHT_STRETCH_STYLE_FACE_NAME
    DWRITE_FONT_PROPERTY_ID_FULL_NAME
    DWRITE_FONT_PROPERTY_ID_WIN32_FAMILY_NAME
    DWRITE_FONT_PROPERTY_ID_POSTSCRIPT_NAME
    DWRITE_FONT_PROPERTY_ID_DESIGN_SCRIPT_LANGUAGE_TAG
    DWRITE_FONT_PROPERTY_ID_SUPPORTED_SCRIPT_LANGUAGE_TAG
    DWRITE_FONT_PROPERTY_ID_SEMANTIC_TAG
    DWRITE_FONT_PROPERTY_ID_WEIGHT
    DWRITE_FONT_PROPERTY_ID_STRETCH
    DWRITE_FONT_PROPERTY_ID_STYLE
    DWRITE_FONT_PROPERTY_ID_TYPOGRAPHIC_FACE_NAME
    DWRITE_FONT_PROPERTY_ID_TOTAL = DWRITE_FONT_PROPERTY_ID_STYLE + 1
    DWRITE_FONT_PROPERTY_ID_TOTAL_RS3 = DWRITE_FONT_PROPERTY_ID_TYPOGRAPHIC_FACE_NAME + 1
    DWRITE_FONT_PROPERTY_ID_FAMILY_NAME = DWRITE_FONT_PROPERTY_ID_TYPOGRAPHIC_FAMILY_NAME
    DWRITE_FONT_PROPERTY_ID_PREFERRED_FAMILY_NAME = DWRITE_FONT_PROPERTY_ID_WEIGHT_STRETCH_STYLE_FAMILY_NAME
    DWRITE_FONT_PROPERTY_ID_FACE_NAME = DWRITE_FONT_PROPERTY_ID_WEIGHT_STRETCH_STYLE_FACE_NAME
End Enum
' DWRITE_MAKE_FONT_AXIS_TAG macro
#define DWRITE_MAKE_FONT_AXIS_TAG(a,b,c,d) (DWRITE_MAKE_OPENTYPE_TAG(a,b,c,d))
Type DWRITE_FONT_AXIS_TAG As Long
Enum
    DWRITE_FONT_AXIS_TAG_WEIGHT       = &h74686777  '' 'wght'
    DWRITE_FONT_AXIS_TAG_WIDTH        = &h68746477  '' 'wdth'
    DWRITE_FONT_AXIS_TAG_SLANT        = &h746e6c73  '' 'slnt'
    DWRITE_FONT_AXIS_TAG_OPTICAL_SIZE = &h7a73706f  '' 'opsz'
    DWRITE_FONT_AXIS_TAG_ITALIC       = &h6c617469  '' 'ital'
End Enum
Type DWRITE_FONT_SOURCE_TYPE As Long
Enum
    DWRITE_FONT_SOURCE_TYPE_UNKNOWN
    DWRITE_FONT_SOURCE_TYPE_PER_MACHINE
    DWRITE_FONT_SOURCE_TYPE_PER_USER
    DWRITE_FONT_SOURCE_TYPE_APPX_PACKAGE
    DWRITE_FONT_SOURCE_TYPE_REMOTE_FONT_PROVIDER
End Enum
Type DWRITE_AUTOMATIC_FONT_AXES As Long
Enum
    DWRITE_AUTOMATIC_FONT_AXES_NONE
    DWRITE_AUTOMATIC_FONT_AXES_OPTICAL_SIZE
End Enum
Type DWRITE_FONT_AXIS_ATTRIBUTES As Long
Enum
    DWRITE_FONT_AXIS_ATTRIBUTES_NONE
    DWRITE_FONT_AXIS_ATTRIBUTES_VARIABLE
    DWRITE_FONT_AXIS_ATTRIBUTES_HIDDEN
End Enum
Type DWRITE_FONT_FAMILY_MODEL As Long
Enum
    DWRITE_FONT_FAMILY_MODEL_TYPOGRAPHIC
    DWRITE_FONT_FAMILY_MODEL_WEIGHT_STRETCH_STYLE
End Enum
Type DWRITE_PAINT_TYPE As Long
Enum
    DWRITE_PAINT_TYPE_NONE
    DWRITE_PAINT_TYPE_LAYERS
    DWRITE_PAINT_TYPE_SOLID_GLYPH
    DWRITE_PAINT_TYPE_SOLID
    DWRITE_PAINT_TYPE_LINEAR_GRADIENT
    DWRITE_PAINT_TYPE_RADIAL_GRADIENT
    DWRITE_PAINT_TYPE_SWEEP_GRADIENT
    DWRITE_PAINT_TYPE_GLYPH
    DWRITE_PAINT_TYPE_COLOR_GLYPH
    DWRITE_PAINT_TYPE_TRANSFORM
    DWRITE_PAINT_TYPE_COMPOSITE
End Enum
#ifndef DWRITE_PAINT_FEATURE_LEVEL_DEFINED
#define DWRITE_PAINT_FEATURE_LEVEL_DEFINED
Type DWRITE_PAINT_FEATURE_LEVEL As Long
Enum
    DWRITE_PAINT_FEATURE_LEVEL_NONE = 0
    DWRITE_PAINT_FEATURE_LEVEL_COLR_V0 = 1
    DWRITE_PAINT_FEATURE_LEVEL_COLR_V1 = 2
End Enum
#endif
Type DWRITE_PAINT_ATTRIBUTES As Long
Enum
    DWRITE_PAINT_ATTRIBUTES_NONE = 0
    DWRITE_PAINT_ATTRIBUTES_USES_PALETTE = &h01
    DWRITE_PAINT_ATTRIBUTES_USES_TEXT_COLOR = &h02
End Enum
Type DWRITE_FONT_LINE_GAP_USAGE As Long
Enum
    DWRITE_FONT_LINE_GAP_USAGE_DEFAULT
    DWRITE_FONT_LINE_GAP_USAGE_DISABLED
    DWRITE_FONT_LINE_GAP_USAGE_ENABLED
End Enum
Type DWRITE_CONTAINER_TYPE As Long
Enum
    DWRITE_CONTAINER_TYPE_UNKNOWN
    DWRITE_CONTAINER_TYPE_WOFF
    DWRITE_CONTAINER_TYPE_WOFF2
End Enum
' ============================================================================
' Strukturen / Typen
' ============================================================================
Type DWRITE_FONT_PROPERTY
    propertyId As DWRITE_FONT_PROPERTY_ID
    propertyValue As WString Ptr
    localeName As WString Ptr
End Type
Type DWRITE_FONT_AXIS_VALUE
    axisTag As DWRITE_FONT_AXIS_TAG
    value As Single
End Type
Type DWRITE_FONT_AXIS_RANGE
    axisTag As DWRITE_FONT_AXIS_TAG
    minValue As Single
    maxValue As Single
End Type
Type DWRITE_PAINT_COLOR
    value As DWRITE_COLOR_F
    paletteEntryIndex As UShort
    alphaMultiplier As Single
    colorAttributes As DWRITE_PAINT_ATTRIBUTES
End Type
' DWRITE_PAINT_ELEMENT - komplexe Struktur mit Union
Type PAINT_LAYERS
    childCount As ULong
End Type
Type PAINT_SOLID_GLYPH
    glyphIndex As ULong
    color As DWRITE_PAINT_COLOR
End Type
Type PAINT_LINEAR_GRADIENT
    extendMode As ULong
    gradientStopCount As ULong
    x0 As Single
    y0 As Single
    x1 As Single
    y1 As Single
    x2 As Single
    y2 As Single
End Type
Type PAINT_RADIAL_GRADIENT
    extendMode As ULong
    gradientStopCount As ULong
    x0 As Single
    y0 As Single
    radius0 As Single
    x1 As Single
    y1 As Single
    radius1 As Single
End Type
Type PAINT_SWEEP_GRADIENT
    extendMode As ULong
    gradientStopCount As ULong
    centerX As Single
    centerY As Single
    startAngle As Single
    endAngle As Single
End Type
Type PAINT_GLYPH
    glyphIndex As ULong
End Type
Type PAINT_COLOR_GLYPH
    glyphIndex As ULong
    clipBox As D2D1_RECT_F
End Type
Type PAINT_COMPOSITE
    mode As DWRITE_COLOR_COMPOSITE_MODE
End Type
Union PAINT_UNION
    layers As PAINT_LAYERS
    solidGlyph As PAINT_SOLID_GLYPH
    solid As DWRITE_PAINT_COLOR
    linearGradient As PAINT_LINEAR_GRADIENT
    radialGradient As PAINT_RADIAL_GRADIENT
    sweepGradient As PAINT_SWEEP_GRADIENT
    glyph As PAINT_GLYPH
    colorGlyph As PAINT_COLOR_GLYPH
    transform As DWRITE_MATRIX
    composite As PAINT_COMPOSITE
End Union
Type DWRITE_PAINT_ELEMENT
    paintType As DWRITE_PAINT_TYPE
    paint As PAINT_UNION
End Type
Type DWRITE_LINE_METRICS1
    length As ULong
    trailingWhitespaceLength As ULong
    newlineLength As ULong
    height As Single
    baseline As Single
    isTrimmed As Long
    leadingBefore As Single
    leadingAfter As Single
End Type
Type DWRITE_LINE_SPACING
    method As DWRITE_LINE_SPACING_METHOD
    height As Single
    baseline As Single
    leadingBefore As Single
    fontLineGapUsage As DWRITE_FONT_LINE_GAP_USAGE
End Type
Type DWRITE_GLYPH_IMAGE_DATA
    imageData As Any Ptr
    imageDataSize As ULong
    uniqueDataId As ULong
    pixelsPerEm As ULong
    pixelSize As D2D1_SIZE_U
    horizontalLeftOrigin As D2D1_POINT_2L
    horizontalRightOrigin As D2D1_POINT_2L
    verticalTopOrigin As D2D1_POINT_2L
    verticalBottomOrigin As D2D1_POINT_2L
End Type
' DWRITE_COLOR_GLYPH_RUN1
Type DWRITE_COLOR_GLYPH_RUN1
    glyphRun As DWRITE_GLYPH_RUN
    glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr
    baselineOriginX As Single
    baselineOriginY As Single
    runColor As DWRITE_COLOR_F
    paletteIndex As UShort
    #ifdef __FB_64BIT__
        _pad As ULong
    #endif
    glyphImageFormat As DWRITE_GLYPH_IMAGE_FORMATS
    measuringMode As DWRITE_MEASURING_MODE
End Type
Type DWRITE_FILE_FRAGMENT
    fileOffset As ULongInt
    fragmentSize As ULongInt
End Type
Type DWRITE_BITMAP_DATA_BGRA32
    width As ULong
    height As ULong
    pixels As ULong Ptr
End Type
' ============================================================================
' IDWriteFontDownloadListener
' ============================================================================
Type IDWriteFontDownloadListenerVtbl As IDWriteFontDownloadListenerVtbl_
Type IDWriteFontDownloadListener
    lpVtbl As IDWriteFontDownloadListenerVtbl Ptr
End Type
Type IDWriteFontDownloadListenerVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontDownloadListener Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontDownloadListener Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontDownloadListener Ptr) As ULong

        
    DownloadCompleted As Sub(ByVal This As IDWriteFontDownloadListener Ptr,  ByVal queue As IDWriteFontDownloadQueue Ptr, ByVal context As IUnknown Ptr, ByVal downloadResult As HRESULT )
End Type
#define IDWriteFontDownloadListener_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontDownloadListener_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontDownloadListener_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontDownloadListener_DownloadCompleted(p, a, b, c) (p)->lpVtbl->DownloadCompleted(p, a, b, c)

' ============================================================================
' IDWriteFontDownloadQueue
' ============================================================================
Type IDWriteFontDownloadQueue_Vtbl As IDWriteFontDownloadQueue_Vtbl_
Type IDWriteFontDownloadQueue_
    lpVtbl As IDWriteFontDownloadQueue_Vtbl Ptr
End Type
Type IDWriteFontDownloadQueue_Vtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontDownloadQueue_ Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontDownloadQueue_ Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontDownloadQueue_ Ptr) As ULong

        
    AddListener As Function(ByVal This As IDWriteFontDownloadQueue_ Ptr,  ByVal listener As IDWriteFontDownloadListener Ptr, ByVal token As ULong Ptr ) As HRESULT
        ' 5. RemoveListener
    RemoveListener As Function(ByVal This As IDWriteFontDownloadQueue_ Ptr,  ByVal token As ULong ) As HRESULT
        ' 6. IsEmpty
    IsEmpty As Function(ByVal This As IDWriteFontDownloadQueue_ Ptr) As Long
        ' 7. BeginDownload
    BeginDownload As Function(ByVal This As IDWriteFontDownloadQueue_ Ptr,  ByVal context As IUnknown Ptr ) As HRESULT
        ' 8. CancelDownload
    CancelDownload As Function(ByVal This As IDWriteFontDownloadQueue_ Ptr) As HRESULT
        ' 9. GetGenerationCount
    GetGenerationCount As Function(ByVal This As IDWriteFontDownloadQueue_ Ptr) As ULongInt
End Type
#define IDWriteFontDownloadQueue__QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontDownloadQueue__AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontDownloadQueue__Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontDownloadQueue__AddListener(p, a, b) (p)->lpVtbl->AddListener(p, a, b)
#define IDWriteFontDownloadQueue__RemoveListener(p, a) (p)->lpVtbl->RemoveListener(p, a)
#define IDWriteFontDownloadQueue__IsEmpty(p, a) (p)->lpVtbl->IsEmpty(p, a)
#define IDWriteFontDownloadQueue__BeginDownload(p, a) (p)->lpVtbl->BeginDownload(p, a)
#define IDWriteFontDownloadQueue__CancelDownload(p, a) (p)->lpVtbl->CancelDownload(p, a)
#define IDWriteFontDownloadQueue__GetGenerationCount(p, a) (p)->lpVtbl->GetGenerationCount(p, a)

' ============================================================================
' IDWriteRenderingParams3
' ============================================================================
Type IDWriteRenderingParams3Vtbl As IDWriteRenderingParams3Vtbl_
Type IDWriteRenderingParams3
    lpVtbl As IDWriteRenderingParams3Vtbl Ptr
End Type
Type IDWriteRenderingParams3Vtbl_     '' Extends IDWriteRenderingParams2Vtbl_
    QueryInterface As Function(ByVal This As IDWriteRenderingParams3 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteRenderingParams3 Ptr) As ULong
    Release As Function(ByVal This As IDWriteRenderingParams3 Ptr) As ULong
        
    GetGamma As Function(ByVal This As IDWriteRenderingParams3 Ptr) As Single
        ' 5. GetEnhancedContrast
    GetEnhancedContrast As Function(ByVal This As IDWriteRenderingParams3 Ptr) As Single
        ' 6. GetClearTypeLevel
    GetClearTypeLevel As Function(ByVal This As IDWriteRenderingParams3 Ptr) As Single
        ' 7. GetPixelGeometry
    GetPixelGeometry As Function(ByVal This As IDWriteRenderingParams3 Ptr) As DWRITE_PIXEL_GEOMETRY
        ' 8. GetRenderingMode
    GetRenderingMode As Function(ByVal This As IDWriteRenderingParams3 Ptr) As DWRITE_RENDERING_MODE
        
    GetGrayscaleEnhancedContrast As Function(ByVal This As IDWriteRenderingParams3 Ptr) As Single
        
    GetGridFitMode As Function(ByVal This As IDWriteRenderingParams3 Ptr) As DWRITE_GRID_FIT_MODE

        
    GetRenderingMode1 As Function(ByVal This As IDWriteRenderingParams3 Ptr) As DWRITE_RENDERING_MODE1
End Type
#define IDWriteRenderingParams3_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteRenderingParams3_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteRenderingParams3_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteRenderingParams3_GetGamma(p, a) (p)->lpVtbl->GetGamma(p, a)
#define IDWriteRenderingParams3_GetEnhancedContrast(p, a) (p)->lpVtbl->GetEnhancedContrast(p, a)
#define IDWriteRenderingParams3_GetClearTypeLevel(p, a) (p)->lpVtbl->GetClearTypeLevel(p, a)
#define IDWriteRenderingParams3_GetPixelGeometry(p, a) (p)->lpVtbl->GetPixelGeometry(p, a)
#define IDWriteRenderingParams3_GetRenderingMode(p, a) (p)->lpVtbl->GetRenderingMode(p, a)
#define IDWriteRenderingParams3_GetGrayscaleEnhancedContrast(p, a) (p)->lpVtbl->GetGrayscaleEnhancedContrast(p, a)
#define IDWriteRenderingParams3_GetGridFitMode(p, a) (p)->lpVtbl->GetGridFitMode(p, a)
#define IDWriteRenderingParams3_GetRenderingMode1(p, a) (p)->lpVtbl->GetRenderingMode1(p, a)

' ============================================================================
' IDWriteStringList
' ============================================================================
Type IDWriteStringListVtbl As IDWriteStringListVtbl_
Type IDWriteStringList
    lpVtbl As IDWriteStringListVtbl Ptr
End Type
Type IDWriteStringListVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteStringList Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteStringList Ptr) As ULong
    Release As Function(ByVal This As IDWriteStringList Ptr) As ULong

        
    GetCount As Function(ByVal This As IDWriteStringList Ptr) As ULong
        ' 5. GetLocaleNameLength
    GetLocaleNameLength As Function(ByVal This As IDWriteStringList Ptr,  ByVal listIndex As ULong, ByVal length As ULong Ptr ) As HRESULT
        ' 6. GetLocaleName
    GetLocaleName As Function(ByVal This As IDWriteStringList Ptr,  ByVal listIndex As ULong, ByVal localeName As WString Ptr, ByVal size As ULong ) As HRESULT
        ' 7. GetStringLength
    GetStringLength As Function(ByVal This As IDWriteStringList Ptr,  ByVal listIndex As ULong, ByVal length As ULong Ptr ) As HRESULT
        ' 8. GetString
    GetString As Function(ByVal This As IDWriteStringList Ptr,  ByVal listIndex As ULong, ByVal stringBuffer As WString Ptr, ByVal stringSize As ULong ) As HRESULT
End Type
#define IDWriteStringList_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteStringList_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteStringList_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteStringList_GetCount(p, a) (p)->lpVtbl->GetCount(p, a)
#define IDWriteStringList_GetLocaleNameLength(p, a, b) (p)->lpVtbl->GetLocaleNameLength(p, a, b)
#define IDWriteStringList_GetLocaleName(p, a, b, c) (p)->lpVtbl->GetLocaleName(p, a, b, c)
#define IDWriteStringList_GetStringLength(p, a, b) (p)->lpVtbl->GetStringLength(p, a, b)
#define IDWriteStringList_GetString(p, a, b, c) (p)->lpVtbl->GetString(p, a, b, c)

' ============================================================================
' IDWriteFontSet
' ============================================================================
Type IDWriteFontSet_Vtbl As IDWriteFontSet_Vtbl_
Type IDWriteFontSet_
    lpVtbl As IDWriteFontSet_Vtbl Ptr
End Type
Type IDWriteFontSet_Vtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontSet_ Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontSet_ Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontSet_ Ptr) As ULong

        
    GetFontCount As Function(ByVal This As IDWriteFontSet_ Ptr) As ULong
        ' 5. GetFontFaceReference
    GetFontFaceReference As Function(ByVal This As IDWriteFontSet_ Ptr,  ByVal listIndex As ULong, ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 6. FindFontFaceReference
    FindFontFaceReference As Function(ByVal This As IDWriteFontSet_ Ptr,  ByVal fontFaceReference As IDWriteFontFaceReference Ptr, ByVal listIndex As ULong Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 7. FindFontFace
    FindFontFace As Function(ByVal This As IDWriteFontSet_ Ptr,  ByVal fontFace As IDWriteFontFace Ptr, ByVal listIndex As ULong Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 8. GetPropertyValues__ (double underscore version)
    GetPropertyValues__ As Function(ByVal This As IDWriteFontSet_ Ptr,  ByVal propertyID As DWRITE_FONT_PROPERTY_ID, ByVal values As IDWriteStringList Ptr Ptr ) As HRESULT
        ' 9. GetPropertyValues_ (single underscore version)
    GetPropertyValues_ As Function(ByVal This As IDWriteFontSet_ Ptr,  ByVal propertyID As DWRITE_FONT_PROPERTY_ID, ByVal preferredLocaleNames As WString Ptr, ByVal values As IDWriteStringList Ptr Ptr ) As HRESULT
        ' 10. GetPropertyValues (by index)
    GetPropertyValues As Function(ByVal This As IDWriteFontSet_ Ptr,  ByVal listIndex As ULong, ByVal propertyId As DWRITE_FONT_PROPERTY_ID, ByVal exists As Long Ptr, ByVal values As IDWriteLocalizedStrings Ptr Ptr ) As HRESULT
        ' 11. GetPropertyOccurrenceCount
    GetPropertyOccurrenceCount As Function(ByVal This As IDWriteFontSet_ Ptr,  ByVal property As DWRITE_FONT_PROPERTY Ptr, ByVal propertyOccurrenceCount As ULong Ptr ) As HRESULT
        ' 12. GetMatchingFonts_ (by family and WWS)
    GetMatchingFonts_ As Function(ByVal This As IDWriteFontSet_ Ptr,  ByVal familyName As WString Ptr, ByVal fontWeight As DWRITE_FONT_WEIGHT, ByVal fontStretch As DWRITE_FONT_STRETCH, ByVal fontStyle As DWRITE_FONT_STYLE, ByVal filteredSet As IDWriteFontSet Ptr Ptr ) As HRESULT
        ' 13. GetMatchingFonts (by properties)
    GetMatchingFonts As Function(ByVal This As IDWriteFontSet_ Ptr,  ByVal properties As DWRITE_FONT_PROPERTY Ptr, ByVal propertyCount As ULong, ByVal filteredSet As IDWriteFontSet Ptr Ptr ) As HRESULT
End Type
#define IDWriteFontSet__QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontSet__AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontSet__Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontSet__GetFontCount(p, a) (p)->lpVtbl->GetFontCount(p, a)
#define IDWriteFontSet__GetFontFaceReference(p, a, b) (p)->lpVtbl->GetFontFaceReference(p, a, b)
#define IDWriteFontSet__FindFontFaceReference(p, a, b, c) (p)->lpVtbl->FindFontFaceReference(p, a, b, c)
#define IDWriteFontSet__FindFontFace(p, a, b, c) (p)->lpVtbl->FindFontFace(p, a, b, c)
#define IDWriteFontSet__GetPropertyValues__(p, a, b) (p)->lpVtbl->GetPropertyValues__(p, a, b)
#define IDWriteFontSet__GetPropertyValues_(p, a, b, c) (p)->lpVtbl->GetPropertyValues_(p, a, b, c)
#define IDWriteFontSet__GetPropertyValues(p, a, b, c, d) (p)->lpVtbl->GetPropertyValues(p, a, b, c, d)
#define IDWriteFontSet__GetPropertyOccurrenceCount(p, a, b) (p)->lpVtbl->GetPropertyOccurrenceCount(p, a, b)
#define IDWriteFontSet__GetMatchingFonts_(p, a, b, c, d, e) (p)->lpVtbl->GetMatchingFonts_(p, a, b, c, d, e)
#define IDWriteFontSet__GetMatchingFonts(p, a, b, c) (p)->lpVtbl->GetMatchingFonts(p, a, b, c)

' ============================================================================
' IDWriteFontResource
' ============================================================================
Type IDWriteFontResourceVtbl As IDWriteFontResourceVtbl_
Type IDWriteFontResource
    lpVtbl As IDWriteFontResourceVtbl Ptr
End Type
Type IDWriteFontResourceVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontResource Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontResource Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontResource Ptr) As ULong

        
    GetFontFile As Function(ByVal This As IDWriteFontResource Ptr,  ByVal fontFile As IDWriteFontFile Ptr Ptr ) As HRESULT
        ' 5. GetFontFaceIndex
    GetFontFaceIndex As Function(ByVal This As IDWriteFontResource Ptr) As ULong
        ' 6. GetFontAxisCount
    GetFontAxisCount As Function(ByVal This As IDWriteFontResource Ptr) As ULong
        ' 7. GetDefaultFontAxisValues
    GetDefaultFontAxisValues As Function(ByVal This As IDWriteFontResource Ptr,  ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong ) As HRESULT
        ' 8. GetFontAxisRanges
    GetFontAxisRanges As Function(ByVal This As IDWriteFontResource Ptr,  ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, ByVal fontAxisRangeCount As ULong ) As HRESULT
        ' 9. GetFontAxisAttributes
    GetFontAxisAttributes As Function(ByVal This As IDWriteFontResource Ptr,  ByVal axisIndex As ULong ) As DWRITE_FONT_AXIS_ATTRIBUTES
        ' 10. GetAxisNames
    GetAxisNames As Function(ByVal This As IDWriteFontResource Ptr,  ByVal axisIndex As ULong, ByVal names As IDWriteLocalizedStrings Ptr Ptr ) As HRESULT
        ' 11. GetAxisValueNameCount
    GetAxisValueNameCount As Function(ByVal This As IDWriteFontResource Ptr,  ByVal axisIndex As ULong ) As ULong
        ' 12. GetAxisValueNames
    GetAxisValueNames As Function(ByVal This As IDWriteFontResource Ptr,  ByVal axisIndex As ULong, ByVal axisValueIndex As ULong, ByVal fontAxisRange As DWRITE_FONT_AXIS_RANGE Ptr, ByVal names As IDWriteLocalizedStrings Ptr Ptr ) As HRESULT
        ' 13. HasVariations
    HasVariations As Function(ByVal This As IDWriteFontResource Ptr) As Long
        ' 14. CreateFontFace
    CreateFontFace As Function(ByVal This As IDWriteFontResource Ptr,  ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong, ByVal fontFace As IDWriteFontFace5 Ptr Ptr ) As HRESULT
        ' 15. CreateFontFaceReference
    CreateFontFaceReference As Function(ByVal This As IDWriteFontResource Ptr,  ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong, ByVal fontFaceReference As IDWriteFontFaceReference1 Ptr Ptr ) As HRESULT
End Type
#define IDWriteFontResource_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontResource_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontResource_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontResource_GetFontFile(p, a) (p)->lpVtbl->GetFontFile(p, a)
#define IDWriteFontResource_GetFontFaceIndex(p, a) (p)->lpVtbl->GetFontFaceIndex(p, a)
#define IDWriteFontResource_GetFontAxisCount(p, a) (p)->lpVtbl->GetFontAxisCount(p, a)
#define IDWriteFontResource_GetDefaultFontAxisValues(p, a, b) (p)->lpVtbl->GetDefaultFontAxisValues(p, a, b)
#define IDWriteFontResource_GetFontAxisRanges(p, a, b) (p)->lpVtbl->GetFontAxisRanges(p, a, b)
#define IDWriteFontResource_GetFontAxisAttributes(p, a) (p)->lpVtbl->GetFontAxisAttributes(p, a)
#define IDWriteFontResource_GetAxisNames(p, a, b) (p)->lpVtbl->GetAxisNames(p, a, b)
#define IDWriteFontResource_GetAxisValueNameCount(p, a) (p)->lpVtbl->GetAxisValueNameCount(p, a)
#define IDWriteFontResource_GetAxisValueNames(p, a, b, c, d) (p)->lpVtbl->GetAxisValueNames(p, a, b, c, d)
#define IDWriteFontResource_HasVariations(p, a) (p)->lpVtbl->HasVariations(p, a)
#define IDWriteFontResource_CreateFontFace(p, a, b, c, d) (p)->lpVtbl->CreateFontFace(p, a, b, c, d)
#define IDWriteFontResource_CreateFontFaceReference(p, a, b, c, d) (p)->lpVtbl->CreateFontFaceReference(p, a, b, c, d)

' ============================================================================
' IDWriteFontSet1
' ============================================================================
Type IDWriteFontSet1Vtbl As IDWriteFontSet1Vtbl_
Type IDWriteFontSet1
    lpVtbl As IDWriteFontSet1Vtbl Ptr
End Type
Type IDWriteFontSet1Vtbl_     '' Extends IDWriteFontSet_Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFontSet1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontSet1 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontSet1 Ptr) As ULong
        
    GetFontCount As Function(ByVal This As IDWriteFontSet1 Ptr) As ULong
        ' 5. GetFontFaceReference
    GetFontFaceReference As Function(ByVal This As IDWriteFontSet1 Ptr,  ByVal listIndex As ULong, ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 6. FindFontFaceReference
    FindFontFaceReference As Function(ByVal This As IDWriteFontSet1 Ptr,  ByVal fontFaceReference As IDWriteFontFaceReference Ptr, ByVal listIndex As ULong Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 7. FindFontFace
    FindFontFace As Function(ByVal This As IDWriteFontSet1 Ptr,  ByVal fontFace As IDWriteFontFace Ptr, ByVal listIndex As ULong Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 8. GetPropertyValues__ (double underscore version)
    GetPropertyValues__ As Function(ByVal This As IDWriteFontSet1 Ptr,  ByVal propertyID As DWRITE_FONT_PROPERTY_ID, ByVal values As IDWriteStringList Ptr Ptr ) As HRESULT
        ' 9. GetPropertyValues_ (single underscore version)
    GetPropertyValues_ As Function(ByVal This As IDWriteFontSet1 Ptr,  ByVal propertyID As DWRITE_FONT_PROPERTY_ID, ByVal preferredLocaleNames As WString Ptr, ByVal values As IDWriteStringList Ptr Ptr ) As HRESULT
        ' 10. GetPropertyValues (by index)
    GetPropertyValues As Function(ByVal This As IDWriteFontSet1 Ptr,  ByVal listIndex As ULong, ByVal propertyId As DWRITE_FONT_PROPERTY_ID, ByVal exists As Long Ptr, ByVal values As IDWriteLocalizedStrings Ptr Ptr ) As HRESULT
        ' 11. GetPropertyOccurrenceCount
    GetPropertyOccurrenceCount As Function(ByVal This As IDWriteFontSet1 Ptr,  ByVal property As DWRITE_FONT_PROPERTY Ptr, ByVal propertyOccurrenceCount As ULong Ptr ) As HRESULT
        ' 12. GetMatchingFonts_ (by family and WWS)
    GetMatchingFonts_ As Function(ByVal This As IDWriteFontSet1 Ptr,  ByVal familyName As WString Ptr, ByVal fontWeight As DWRITE_FONT_WEIGHT, ByVal fontStretch As DWRITE_FONT_STRETCH, ByVal fontStyle As DWRITE_FONT_STYLE, ByVal filteredSet As IDWriteFontSet Ptr Ptr ) As HRESULT
        ' 13. GetMatchingFonts (by properties)
    GetMatchingFonts As Function(ByVal This As IDWriteFontSet1 Ptr,  ByVal properties As DWRITE_FONT_PROPERTY Ptr, ByVal propertyCount As ULong, ByVal filteredSet As IDWriteFontSet Ptr Ptr ) As HRESULT

        
    GetMatchingFonts1 As Function(ByVal This As IDWriteFontSet1 Ptr,  ByVal fontProperty As DWRITE_FONT_PROPERTY Ptr, ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong, ByVal matchingFonts As IDWriteFontSet1 Ptr Ptr ) As HRESULT
        ' 15. GetFirstFontResources
    GetFirstFontResources As Function(ByVal This As IDWriteFontSet1 Ptr,  ByVal filteredFontSet As IDWriteFontSet1 Ptr Ptr ) As HRESULT
        ' 16. GetFilteredFonts__ (by indices)
    GetFilteredFonts__ As Function(ByVal This As IDWriteFontSet1 Ptr,  ByVal indices As ULong Ptr, ByVal indexCount As ULong, ByVal filteredFontSet As IDWriteFontSet1 Ptr Ptr ) As HRESULT
        ' 17. GetFilteredFonts_ (by axis ranges)
    GetFilteredFonts_ As Function(ByVal This As IDWriteFontSet1 Ptr,  ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, ByVal fontAxisRangeCount As ULong, ByVal selectAnyRange As Long, ByVal filteredFontSet As IDWriteFontSet1 Ptr Ptr ) As HRESULT
        ' 18. GetFilteredFonts (by properties)
    GetFilteredFonts As Function(ByVal This As IDWriteFontSet1 Ptr,  ByVal properties As DWRITE_FONT_PROPERTY Ptr, ByVal propertyCount As ULong, ByVal selectAnyProperty As Long, ByVal filteredFontSet As IDWriteFontSet1 Ptr Ptr ) As HRESULT
        ' 19. GetFilteredFontIndices_ (by axis ranges)
    GetFilteredFontIndices_ As Function(ByVal This As IDWriteFontSet1 Ptr,  ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, ByVal fontAxisRangeCount As ULong, ByVal selectAnyRange As Long, ByVal indices As ULong Ptr, ByVal maxIndexCount As ULong, ByVal actualIndexCount As ULong Ptr ) As HRESULT
        ' 20. GetFilteredFontIndices (by properties)
    GetFilteredFontIndices As Function(ByVal This As IDWriteFontSet1 Ptr,  ByVal properties As DWRITE_FONT_PROPERTY Ptr, ByVal propertyCount As ULong, ByVal selectAnyProperty As Long, ByVal indices As ULong Ptr, ByVal maxIndexCount As ULong, ByVal actualIndexCount As ULong Ptr ) As HRESULT
        ' 21. GetFontAxisRanges_ (by font index)
    GetFontAxisRanges_ As Function(ByVal This As IDWriteFontSet1 Ptr,  ByVal listIndex As ULong, ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, ByVal maxFontAxisRangeCount As ULong, ByVal actualFontAxisRangeCount As ULong Ptr ) As HRESULT
        ' 22. GetFontAxisRanges (all fonts)
    GetFontAxisRanges As Function(ByVal This As IDWriteFontSet1 Ptr,  ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, ByVal maxFontAxisRangeCount As ULong, ByVal actualFontAxisRangeCount As ULong Ptr ) As HRESULT
        ' 23. GetFontFaceReference
    GetFontFaceReference1 As Function(ByVal This As IDWriteFontSet1 Ptr,  ByVal listIndex As ULong, ByVal fontFaceReference As IDWriteFontFaceReference1 Ptr Ptr ) As HRESULT
        ' 24. CreateFontResource
    CreateFontResource As Function(ByVal This As IDWriteFontSet1 Ptr,  ByVal listIndex As ULong, ByVal fontResource As IDWriteFontResource Ptr Ptr ) As HRESULT
        ' 25. CreateFontFace
    CreateFontFace As Function(ByVal This As IDWriteFontSet1 Ptr,  ByVal listIndex As ULong, ByVal fontFace As IDWriteFontFace5 Ptr Ptr ) As HRESULT
        ' 26. GetFontLocality
    GetFontLocality As Function(ByVal This As IDWriteFontSet1 Ptr,  ByVal listIndex As ULong ) As DWRITE_LOCALITY
End Type
#define IDWriteFontSet1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontSet1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontSet1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontSet1_GetFontCount(p, a) (p)->lpVtbl->GetFontCount(p, a)
#define IDWriteFontSet1_GetFontFaceReference(p, a, b) (p)->lpVtbl->GetFontFaceReference(p, a, b)
#define IDWriteFontSet1_FindFontFaceReference(p, a, b, c) (p)->lpVtbl->FindFontFaceReference(p, a, b, c)
#define IDWriteFontSet1_FindFontFace(p, a, b, c) (p)->lpVtbl->FindFontFace(p, a, b, c)
#define IDWriteFontSet1_GetPropertyValues__(p, a, b) (p)->lpVtbl->GetPropertyValues__(p, a, b)
#define IDWriteFontSet1_GetPropertyValues_(p, a, b, c) (p)->lpVtbl->GetPropertyValues_(p, a, b, c)
#define IDWriteFontSet1_GetPropertyValues(p, a, b, c, d) (p)->lpVtbl->GetPropertyValues(p, a, b, c, d)
#define IDWriteFontSet1_GetPropertyOccurrenceCount(p, a, b) (p)->lpVtbl->GetPropertyOccurrenceCount(p, a, b)
#define IDWriteFontSet1_GetMatchingFonts_(p, a, b, c, d, e) (p)->lpVtbl->GetMatchingFonts_(p, a, b, c, d, e)
#define IDWriteFontSet1_GetMatchingFonts(p, a, b, c) (p)->lpVtbl->GetMatchingFonts(p, a, b, c)
#define IDWriteFontSet1_GetMatchingFonts1(p, a, b, c, d) (p)->lpVtbl->GetMatchingFonts1(p, a, b, c, d)
#define IDWriteFontSet1_GetFirstFontResources(p, a) (p)->lpVtbl->GetFirstFontResources(p, a)
#define IDWriteFontSet1_GetFilteredFonts__(p, a, b, c) (p)->lpVtbl->GetFilteredFonts__(p, a, b, c)
#define IDWriteFontSet1_GetFilteredFonts_(p, a, b, c, d) (p)->lpVtbl->GetFilteredFonts_(p, a, b, c, d)
#define IDWriteFontSet1_GetFilteredFonts(p, a, b, c, d) (p)->lpVtbl->GetFilteredFonts(p, a, b, c, d)
#define IDWriteFontSet1_GetFilteredFontIndices_(p, a, b, c, d, e, f) (p)->lpVtbl->GetFilteredFontIndices_(p, a, b, c, d, e, f)
#define IDWriteFontSet1_GetFilteredFontIndices(p, a, b, c, d, e, f) (p)->lpVtbl->GetFilteredFontIndices(p, a, b, c, d, e, f)
#define IDWriteFontSet1_GetFontAxisRanges_(p, a, b, c, d) (p)->lpVtbl->GetFontAxisRanges_(p, a, b, c, d)
#define IDWriteFontSet1_GetFontAxisRanges(p, a, b, c) (p)->lpVtbl->GetFontAxisRanges(p, a, b, c)
#define IDWriteFontSet1_GetFontFaceReference1(p, a, b) (p)->lpVtbl->GetFontFaceReference1(p, a, b)
#define IDWriteFontSet1_CreateFontResource(p, a, b) (p)->lpVtbl->CreateFontResource(p, a, b)
#define IDWriteFontSet1_CreateFontFace(p, a, b) (p)->lpVtbl->CreateFontFace(p, a, b)
#define IDWriteFontSet1_GetFontLocality(p, a) (p)->lpVtbl->GetFontLocality(p, a)

' ============================================================================
' IDWriteFont3
' ============================================================================
Type IDWriteFont3Vtbl As IDWriteFont3Vtbl_
Type IDWriteFont3
    lpVtbl As IDWriteFont3Vtbl Ptr
End Type
Type IDWriteFont3Vtbl_     '' Extends IDWriteFont2Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFont3 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFont3 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFont3 Ptr) As ULong
        
    GetFontFamily As Function(ByVal This As IDWriteFont3 Ptr,  ByVal family As Any Ptr Ptr ) As HRESULT
        ' 5. GetWeight
    GetWeight As Function(ByVal This As IDWriteFont3 Ptr) As DWRITE_FONT_WEIGHT
        ' 6. GetStretch
    GetStretch As Function(ByVal This As IDWriteFont3 Ptr) As DWRITE_FONT_STRETCH
        ' 7. GetStyle
    GetStyle As Function(ByVal This As IDWriteFont3 Ptr) As DWRITE_FONT_STYLE
        ' 8. IsSymbolFont
    IsSymbolFont As Function(ByVal This As IDWriteFont3 Ptr) As Long
        ' 9. GetFaceNames
    GetFaceNames As Function(ByVal This As IDWriteFont3 Ptr,  ByVal names As Any Ptr Ptr ) As HRESULT
        ' 10. GetInformationalStrings
    GetInformationalStrings As Function(ByVal This As IDWriteFont3 Ptr,  ByVal informationalStringID As DWRITE_INFORMATIONAL_STRING_ID, ByVal informationalStrings As Any Ptr Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 11. GetSimulations
    GetSimulations As Function(ByVal This As IDWriteFont3 Ptr) As DWRITE_FONT_SIMULATIONS
        ' 12. GetMetrics
    GetMetrics As Sub(ByVal This As IDWriteFont3 Ptr,  ByVal fontMetrics As DWRITE_FONT_METRICS Ptr )
        ' 13. HasCharacter
    HasCharacter As Function(ByVal This As IDWriteFont3 Ptr,  ByVal unicodeValue As ULong, ByVal exists As Long Ptr ) As HRESULT
        ' 14. CreateFontFace
    CreateFontFace As Function(ByVal This As IDWriteFont3 Ptr,  ByVal fontFace As Any Ptr Ptr ) As HRESULT
        
    GetMetrics1 As Sub(ByVal This As IDWriteFont3 Ptr,  ByVal fontMetrics As DWRITE_FONT_METRICS1 Ptr )
        ' 16. GetPanose
    GetPanose As Sub(ByVal This As IDWriteFont3 Ptr,  ByVal panose As DWRITE_PANOSE Ptr )
        ' 17. GetUnicodeRanges
    GetUnicodeRanges As Function(ByVal This As IDWriteFont3 Ptr,  ByVal maxCount As ULong, ByVal unicodeRanges As DWRITE_UNICODE_RANGE Ptr, ByVal actualCount As ULong Ptr ) As HRESULT
        ' 18. IsMonospacedFont
    IsMonospacedFont As Function(ByVal This As IDWriteFont3 Ptr) As Long
        
    IsColorFont As Function(ByVal This As IDWriteFont3 Ptr) As Long

        
    CreateFontFace1 As Function(ByVal This As IDWriteFont3 Ptr,  ByVal fontFace As IDWriteFontFace3 Ptr Ptr ) As HRESULT
        ' 21. Equals
    Equals As Function(ByVal This As IDWriteFont3 Ptr,  ByVal font As IDWriteFont Ptr ) As Long
        ' 22. GetFontFaceReference
    GetFontFaceReference As Function(ByVal This As IDWriteFont3 Ptr,  ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 23. HasCharacter
    HasCharacter1 As Function(ByVal This As IDWriteFont3 Ptr,  ByVal unicodeValue As ULong ) As Long
        ' 24. GetLocality
    GetLocality As Function(ByVal This As IDWriteFont3 Ptr) As DWRITE_LOCALITY
End Type
#define IDWriteFont3_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFont3_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFont3_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFont3_GetFontFamily(p, a) (p)->lpVtbl->GetFontFamily(p, a)
#define IDWriteFont3_GetWeight(p, a) (p)->lpVtbl->GetWeight(p, a)
#define IDWriteFont3_GetStretch(p, a) (p)->lpVtbl->GetStretch(p, a)
#define IDWriteFont3_GetStyle(p, a) (p)->lpVtbl->GetStyle(p, a)
#define IDWriteFont3_IsSymbolFont(p, a) (p)->lpVtbl->IsSymbolFont(p, a)
#define IDWriteFont3_GetFaceNames(p, a) (p)->lpVtbl->GetFaceNames(p, a)
#define IDWriteFont3_GetInformationalStrings(p, a, b, c) (p)->lpVtbl->GetInformationalStrings(p, a, b, c)
#define IDWriteFont3_GetSimulations(p, a) (p)->lpVtbl->GetSimulations(p, a)
#define IDWriteFont3_GetMetrics(p, a) (p)->lpVtbl->GetMetrics(p, a)
#define IDWriteFont3_HasCharacter(p, a, b) (p)->lpVtbl->HasCharacter(p, a, b)
#define IDWriteFont3_CreateFontFace(p, a) (p)->lpVtbl->CreateFontFace(p, a)
#define IDWriteFont3_GetMetrics1(p, a) (p)->lpVtbl->GetMetrics1(p, a)
#define IDWriteFont3_GetPanose(p, a) (p)->lpVtbl->GetPanose(p, a)
#define IDWriteFont3_GetUnicodeRanges(p, a, b, c) (p)->lpVtbl->GetUnicodeRanges(p, a, b, c)
#define IDWriteFont3_IsMonospacedFont(p, a) (p)->lpVtbl->IsMonospacedFont(p, a)
#define IDWriteFont3_IsColorFont(p, a) (p)->lpVtbl->IsColorFont(p, a)
#define IDWriteFont3_CreateFontFace1(p, a) (p)->lpVtbl->CreateFontFace1(p, a)
#define IDWriteFont3_Equals(p, a) (p)->lpVtbl->Equals(p, a)
#define IDWriteFont3_GetFontFaceReference(p, a) (p)->lpVtbl->GetFontFaceReference(p, a)
#define IDWriteFont3_HasCharacter1(p, a) (p)->lpVtbl->HasCharacter1(p, a)
#define IDWriteFont3_GetLocality(p, a) (p)->lpVtbl->GetLocality(p, a)

' ============================================================================
' IDWriteFontFamily1
' ============================================================================
Type IDWriteFontFamily1Vtbl As IDWriteFontFamily1Vtbl_
Type IDWriteFontFamily1
    lpVtbl As IDWriteFontFamily1Vtbl Ptr
End Type
Type IDWriteFontFamily1Vtbl_     '' Extends IDWriteFontFamilyVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontFamily1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontFamily1 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontFamily1 Ptr) As ULong
        ' --- IUnknown (1-3) ---
        ' 2. AddRef
        ' 4.
    GetFontCollection As Function(ByVal This As IDWriteFontFamily1 Ptr, ByRef fontCollection As any Ptr) As HRESULT 'IDWriteFontCollection Ptr
    GetFontCount As Function(ByVal This As IDWriteFontFamily1 Ptr) As ULong
    GetFont As Function(ByVal This As IDWriteFontFamily1 Ptr, ByVal index As ULong, ByRef font As IDWriteFont Ptr) As HRESULT
    GetFamilyNames As Function(ByVal This As IDWriteFontFamily1 Ptr, ByRef names As IDWriteLocalizedStrings Ptr) As HRESULT
    GetFirstMatchingFont As Function(ByVal This As IDWriteFontFamily1 Ptr, ByVal weight As ULong, ByVal stretch As ULong, ByVal style As ULong, ByRef matchingFont As IDWriteFont Ptr) As HRESULT
    GetMatchingFonts As Function(ByVal This As IDWriteFontFamily1 Ptr, ByVal weight As DWRITE_FONT_WEIGHT, ByVal stretch As ULong, ByVal style As ULong, ByRef matchingFonts As IDWriteFontList Ptr) As HRESULT

        
    GetFontLocality As Function(ByVal This As IDWriteFontFamily1 Ptr,  ByVal listIndex As ULong ) As DWRITE_LOCALITY
        ' 11. GetFont
    GetFont1 As Function(ByVal This As IDWriteFontFamily1 Ptr,  ByVal listIndex As ULong, ByVal font As IDWriteFont3 Ptr Ptr ) As HRESULT
        ' 12. GetFontFaceReference
    GetFontFaceReference As Function(ByVal This As IDWriteFontFamily1 Ptr,  ByVal listIndex As ULong, ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
End Type
#define IDWriteFontFamily1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontFamily1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontFamily1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontFamily1_GetFontCollection(p, a) (p)->lpVtbl->GetFontCollection(p, a)
#define IDWriteFontFamily1_GetFontCount(p, a) (p)->lpVtbl->GetFontCount(p, a)
#define IDWriteFontFamily1_GetFont(p, a, b) (p)->lpVtbl->GetFont(p, a, b)
#define IDWriteFontFamily1_GetFamilyNames(p, a) (p)->lpVtbl->GetFamilyNames(p, a)
#define IDWriteFontFamily1_GetFirstMatchingFont(p, a, b, c, d) (p)->lpVtbl->GetFirstMatchingFont(p, a, b, c, d)
#define IDWriteFontFamily1_GetMatchingFonts(p, a, b, c, d) (p)->lpVtbl->GetMatchingFonts(p, a, b, c, d)
#define IDWriteFontFamily1_GetFontLocality(p, a) (p)->lpVtbl->GetFontLocality(p, a)
#define IDWriteFontFamily1_GetFont1(p, a, b) (p)->lpVtbl->GetFont1(p, a, b)
#define IDWriteFontFamily1_GetFontFaceReference(p, a, b) (p)->lpVtbl->GetFontFaceReference(p, a, b)

' ============================================================================
' IDWriteFontFamily2
' ============================================================================
Type IDWriteFontFamily2Vtbl As IDWriteFontFamily2Vtbl_
Type IDWriteFontFamily2
    lpVtbl As IDWriteFontFamily2Vtbl Ptr
End Type
Type IDWriteFontFamily2Vtbl_     '' Extends IDWriteFontFamily1Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFontFamily2 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontFamily2 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontFamily2 Ptr) As ULong
        ' --- IUnknown (1-3) ---
        ' 2. AddRef
        ' 4.
    GetFontCollection As Function(ByVal This As IDWriteFontFamily2 Ptr, ByRef fontCollection As any Ptr) As HRESULT 'IDWriteFontCollection Ptr
    GetFontCount As Function(ByVal This As IDWriteFontFamily2 Ptr) As ULong
    GetFont As Function(ByVal This As IDWriteFontFamily2 Ptr, ByVal index As ULong, ByRef font As IDWriteFont Ptr) As HRESULT
    GetFamilyNames As Function(ByVal This As IDWriteFontFamily2 Ptr, ByRef names As IDWriteLocalizedStrings Ptr) As HRESULT
    GetFirstMatchingFont As Function(ByVal This As IDWriteFontFamily2 Ptr, ByVal weight As ULong, ByVal stretch As ULong, ByVal style As ULong, ByRef matchingFont As IDWriteFont Ptr) As HRESULT
    GetMatchingFonts As Function(ByVal This As IDWriteFontFamily2 Ptr, ByVal weight As DWRITE_FONT_WEIGHT, ByVal stretch As ULong, ByVal style As ULong, ByRef matchingFonts As IDWriteFontList Ptr) As HRESULT
        
    GetFontLocality As Function(ByVal This As IDWriteFontFamily2 Ptr,  ByVal listIndex As ULong ) As DWRITE_LOCALITY
        ' 11. GetFont
    GetFont1 As Function(ByVal This As IDWriteFontFamily2 Ptr,  ByVal listIndex As ULong, ByVal font As IDWriteFont3 Ptr Ptr ) As HRESULT
        ' 12. GetFontFaceReference
    GetFontFaceReference As Function(ByVal This As IDWriteFontFamily2 Ptr,  ByVal listIndex As ULong, ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT

        
    GetMatchingFonts1 As Function(ByVal This As IDWriteFontFamily2 Ptr,  ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong, ByVal matchingFonts As IDWriteFontList2 Ptr Ptr ) As HRESULT
        ' 14. GetFontSet
    GetFontSet As Function(ByVal This As IDWriteFontFamily2 Ptr,  ByVal fontSet As IDWriteFontSet1 Ptr Ptr ) As HRESULT
End Type
#define IDWriteFontFamily2_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontFamily2_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontFamily2_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontFamily2_GetFontCollection(p, a) (p)->lpVtbl->GetFontCollection(p, a)
#define IDWriteFontFamily2_GetFontCount(p, a) (p)->lpVtbl->GetFontCount(p, a)
#define IDWriteFontFamily2_GetFont(p, a, b) (p)->lpVtbl->GetFont(p, a, b)
#define IDWriteFontFamily2_GetFamilyNames(p, a) (p)->lpVtbl->GetFamilyNames(p, a)
#define IDWriteFontFamily2_GetFirstMatchingFont(p, a, b, c, d) (p)->lpVtbl->GetFirstMatchingFont(p, a, b, c, d)
#define IDWriteFontFamily2_GetMatchingFonts(p, a, b, c, d) (p)->lpVtbl->GetMatchingFonts(p, a, b, c, d)
#define IDWriteFontFamily2_GetFontLocality(p, a) (p)->lpVtbl->GetFontLocality(p, a)
#define IDWriteFontFamily2_GetFont1(p, a, b) (p)->lpVtbl->GetFont1(p, a, b)
#define IDWriteFontFamily2_GetFontFaceReference(p, a, b) (p)->lpVtbl->GetFontFaceReference(p, a, b)
#define IDWriteFontFamily2_GetMatchingFonts1(p, a, b, c) (p)->lpVtbl->GetMatchingFonts1(p, a, b, c)
#define IDWriteFontFamily2_GetFontSet(p, a) (p)->lpVtbl->GetFontSet(p, a)

' ============================================================================
' IDWriteFontCollection1
' ============================================================================
Type IDWriteFontCollection1Vtbl As IDWriteFontCollection1Vtbl_
Type IDWriteFontCollection1
    lpVtbl As IDWriteFontCollection1Vtbl Ptr
End Type
Type IDWriteFontCollection1Vtbl_     '' Extends IDWriteFontCollectionVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontCollection1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontCollection1 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontCollection1 Ptr) As ULong
        ' --- IUnknown (1-3) ---
        ' 2. AddRef
        ' 4.
    GetFontFamilyCount As Function(ByVal This As IDWriteFontCollection1 Ptr) As ULong
    GetFontFamily As Function(ByVal This As IDWriteFontCollection1 Ptr, ByVal index As ULong, ByRef fontFamily As IDWriteFontFamily Ptr) As HRESULT
    FindFamilyName As Function(ByVal This As IDWriteFontCollection1 Ptr, ByVal familyName As WString Ptr, ByRef index As ULong, ByRef exists As Long) As HRESULT
    GetFontFromFontFace As Function(ByVal This As IDWriteFontCollection1 Ptr, ByVal fontFace As IDWriteFontFace Ptr, ByRef font As IDWriteFont Ptr) As HRESULT

        
    GetFontSet As Function(ByVal This As IDWriteFontCollection1 Ptr,  ByVal fontSet As IDWriteFontSet Ptr Ptr ) As HRESULT
        ' 9. GetFontFamily
    GetFontFamily1 As Function(ByVal This As IDWriteFontCollection1 Ptr,  ByVal index As ULong, ByVal fontFamily As IDWriteFontFamily1 Ptr Ptr ) As HRESULT
End Type
#define IDWriteFontCollection1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontCollection1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontCollection1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontCollection1_GetFontFamilyCount(p, a) (p)->lpVtbl->GetFontFamilyCount(p, a)
#define IDWriteFontCollection1_GetFontFamily(p, a, b) (p)->lpVtbl->GetFontFamily(p, a, b)
#define IDWriteFontCollection1_FindFamilyName(p, a, b, c) (p)->lpVtbl->FindFamilyName(p, a, b, c)
#define IDWriteFontCollection1_GetFontFromFontFace(p, a, b) (p)->lpVtbl->GetFontFromFontFace(p, a, b)
#define IDWriteFontCollection1_GetFontSet(p, a) (p)->lpVtbl->GetFontSet(p, a)
#define IDWriteFontCollection1_GetFontFamily1(p, a, b) (p)->lpVtbl->GetFontFamily1(p, a, b)

' ============================================================================
' IDWriteFontCollection2
' ============================================================================
Type IDWriteFontCollection2Vtbl As IDWriteFontCollection2Vtbl_
Type IDWriteFontCollection2
    lpVtbl As IDWriteFontCollection2Vtbl Ptr
End Type
Type IDWriteFontCollection2Vtbl_     '' Extends IDWriteFontCollection1Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFontCollection2 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontCollection2 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontCollection2 Ptr) As ULong
        ' --- IUnknown (1-3) ---
        ' 2. AddRef
        ' 4.
    GetFontFamilyCount As Function(ByVal This As IDWriteFontCollection2 Ptr) As ULong
    GetFontFamily As Function(ByVal This As IDWriteFontCollection2 Ptr, ByVal index As ULong, ByRef fontFamily As IDWriteFontFamily Ptr) As HRESULT
    FindFamilyName As Function(ByVal This As IDWriteFontCollection2 Ptr, ByVal familyName As WString Ptr, ByRef index As ULong, ByRef exists As Long) As HRESULT
    GetFontFromFontFace As Function(ByVal This As IDWriteFontCollection2 Ptr, ByVal fontFace As IDWriteFontFace Ptr, ByRef font As IDWriteFont Ptr) As HRESULT
        
    GetFontSet As Function(ByVal This As IDWriteFontCollection2 Ptr,  ByVal fontSet As IDWriteFontSet Ptr Ptr ) As HRESULT
        ' 9. GetFontFamily
    GetFontFamily1 As Function(ByVal This As IDWriteFontCollection2 Ptr,  ByVal index As ULong, ByVal fontFamily As IDWriteFontFamily1 Ptr Ptr ) As HRESULT

        
    GetFontFamily2 As Function(ByVal This As IDWriteFontCollection2 Ptr,  ByVal index As ULong, ByVal fontFamily As IDWriteFontFamily2 Ptr Ptr ) As HRESULT
        ' 11. GetMatchingFonts
    GetMatchingFonts As Function(ByVal This As IDWriteFontCollection2 Ptr,  ByVal familyName As WString Ptr, ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong, ByVal fontList As IDWriteFontList2 Ptr Ptr ) As HRESULT
        ' 12. GetFontFamilyModel
    GetFontFamilyModel As Function(ByVal This As IDWriteFontCollection2 Ptr) As DWRITE_FONT_FAMILY_MODEL
        ' 13. GetFontSet
    GetFontSet1 As Function(ByVal This As IDWriteFontCollection2 Ptr,  ByVal fontSet As IDWriteFontSet1 Ptr Ptr ) As HRESULT
End Type
#define IDWriteFontCollection2_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontCollection2_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontCollection2_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontCollection2_GetFontFamilyCount(p, a) (p)->lpVtbl->GetFontFamilyCount(p, a)
#define IDWriteFontCollection2_GetFontFamily(p, a, b) (p)->lpVtbl->GetFontFamily(p, a, b)
#define IDWriteFontCollection2_FindFamilyName(p, a, b, c) (p)->lpVtbl->FindFamilyName(p, a, b, c)
#define IDWriteFontCollection2_GetFontFromFontFace(p, a, b) (p)->lpVtbl->GetFontFromFontFace(p, a, b)
#define IDWriteFontCollection2_GetFontSet(p, a) (p)->lpVtbl->GetFontSet(p, a)
#define IDWriteFontCollection2_GetFontFamily1(p, a, b) (p)->lpVtbl->GetFontFamily1(p, a, b)
#define IDWriteFontCollection2_GetFontFamily2(p, a, b) (p)->lpVtbl->GetFontFamily2(p, a, b)
#define IDWriteFontCollection2_GetMatchingFonts(p, a, b, c, d) (p)->lpVtbl->GetMatchingFonts(p, a, b, c, d)
#define IDWriteFontCollection2_GetFontFamilyModel(p, a) (p)->lpVtbl->GetFontFamilyModel(p, a)
#define IDWriteFontCollection2_GetFontSet1(p, a) (p)->lpVtbl->GetFontSet1(p, a)

' ============================================================================
' IDWriteFontCollection3
' ============================================================================
Type IDWriteFontCollection3Vtbl As IDWriteFontCollection3Vtbl_
Type IDWriteFontCollection3
    lpVtbl As IDWriteFontCollection3Vtbl Ptr
End Type
Type IDWriteFontCollection3Vtbl_     '' Extends IDWriteFontCollection2Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFontCollection3 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontCollection3 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontCollection3 Ptr) As ULong
        ' --- IUnknown (1-3) ---
        ' 2. AddRef
        ' 4.
    GetFontFamilyCount As Function(ByVal This As IDWriteFontCollection3 Ptr) As ULong
    GetFontFamily As Function(ByVal This As IDWriteFontCollection3 Ptr, ByVal index As ULong, ByRef fontFamily As IDWriteFontFamily Ptr) As HRESULT
    FindFamilyName As Function(ByVal This As IDWriteFontCollection3 Ptr, ByVal familyName As WString Ptr, ByRef index As ULong, ByRef exists As Long) As HRESULT
    GetFontFromFontFace As Function(ByVal This As IDWriteFontCollection3 Ptr, ByVal fontFace As IDWriteFontFace Ptr, ByRef font As IDWriteFont Ptr) As HRESULT
        
    GetFontSet As Function(ByVal This As IDWriteFontCollection3 Ptr,  ByVal fontSet As IDWriteFontSet Ptr Ptr ) As HRESULT
        ' 9. GetFontFamily
    GetFontFamily1 As Function(ByVal This As IDWriteFontCollection3 Ptr,  ByVal index As ULong, ByVal fontFamily As IDWriteFontFamily1 Ptr Ptr ) As HRESULT
        
    GetFontFamily2 As Function(ByVal This As IDWriteFontCollection3 Ptr,  ByVal index As ULong, ByVal fontFamily As IDWriteFontFamily2 Ptr Ptr ) As HRESULT
        ' 11. GetMatchingFonts
    GetMatchingFonts As Function(ByVal This As IDWriteFontCollection3 Ptr,  ByVal familyName As WString Ptr, ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong, ByVal fontList As IDWriteFontList2 Ptr Ptr ) As HRESULT
        ' 12. GetFontFamilyModel
    GetFontFamilyModel As Function(ByVal This As IDWriteFontCollection3 Ptr) As DWRITE_FONT_FAMILY_MODEL
        ' 13. GetFontSet
    GetFontSet1 As Function(ByVal This As IDWriteFontCollection3 Ptr,  ByVal fontSet As IDWriteFontSet1 Ptr Ptr ) As HRESULT

        
    GetExpirationEvent As Function(ByVal This As IDWriteFontCollection3 Ptr) As HANDLE
End Type
#define IDWriteFontCollection3_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontCollection3_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontCollection3_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontCollection3_GetFontFamilyCount(p, a) (p)->lpVtbl->GetFontFamilyCount(p, a)
#define IDWriteFontCollection3_GetFontFamily(p, a, b) (p)->lpVtbl->GetFontFamily(p, a, b)
#define IDWriteFontCollection3_FindFamilyName(p, a, b, c) (p)->lpVtbl->FindFamilyName(p, a, b, c)
#define IDWriteFontCollection3_GetFontFromFontFace(p, a, b) (p)->lpVtbl->GetFontFromFontFace(p, a, b)
#define IDWriteFontCollection3_GetFontSet(p, a) (p)->lpVtbl->GetFontSet(p, a)
#define IDWriteFontCollection3_GetFontFamily1(p, a, b) (p)->lpVtbl->GetFontFamily1(p, a, b)
#define IDWriteFontCollection3_GetFontFamily2(p, a, b) (p)->lpVtbl->GetFontFamily2(p, a, b)
#define IDWriteFontCollection3_GetMatchingFonts(p, a, b, c, d) (p)->lpVtbl->GetMatchingFonts(p, a, b, c, d)
#define IDWriteFontCollection3_GetFontFamilyModel(p, a) (p)->lpVtbl->GetFontFamilyModel(p, a)
#define IDWriteFontCollection3_GetFontSet1(p, a) (p)->lpVtbl->GetFontSet1(p, a)
#define IDWriteFontCollection3_GetExpirationEvent(p, a) (p)->lpVtbl->GetExpirationEvent(p, a)

' ============================================================================
' IDWriteFontFaceReference
' ============================================================================
Type IDWriteFontFaceReference_Vtbl As IDWriteFontFaceReference_Vtbl_
Type IDWriteFontFaceReference_
    lpVtbl As IDWriteFontFaceReference_Vtbl Ptr
End Type
Type IDWriteFontFaceReference_Vtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontFaceReference_ Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontFaceReference_ Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontFaceReference_ Ptr) As ULong

        
    CreateFontFace As Function(ByVal This As IDWriteFontFaceReference_ Ptr,  ByVal fontFace As IDWriteFontFace3 Ptr Ptr ) As HRESULT
        ' 5. CreateFontFaceWithSimulations
    CreateFontFaceWithSimulations As Function(ByVal This As IDWriteFontFaceReference_ Ptr,  ByVal fontFaceSimulationFlags As DWRITE_FONT_SIMULATIONS, ByVal fontFace As IDWriteFontFace3 Ptr Ptr ) As HRESULT
        ' 6. Equals
    Equals As Function(ByVal This As IDWriteFontFaceReference_ Ptr,  ByVal fontFaceReference As IDWriteFontFaceReference Ptr ) As Long
        ' 7. GetFontFaceIndex
    GetFontFaceIndex As Function(ByVal This As IDWriteFontFaceReference_ Ptr) As ULong
        ' 8. GetSimulations
    GetSimulations As Function(ByVal This As IDWriteFontFaceReference_ Ptr) As DWRITE_FONT_SIMULATIONS
        ' 9. GetFontFile
    GetFontFile As Function(ByVal This As IDWriteFontFaceReference_ Ptr,  ByVal fontFile As IDWriteFontFile Ptr Ptr ) As HRESULT
        ' 10. GetLocalFileSize
    GetLocalFileSize As Function(ByVal This As IDWriteFontFaceReference_ Ptr) As ULongInt
        ' 11. GetFileSize
    GetFileSize As Function(ByVal This As IDWriteFontFaceReference_ Ptr) As ULongInt
        ' 12. GetFileTime
    GetFileTime As Function(ByVal This As IDWriteFontFaceReference_ Ptr,  ByVal lastWriteTime As FILETIME Ptr ) As HRESULT
        ' 13. GetLocality
    GetLocality As Function(ByVal This As IDWriteFontFaceReference_ Ptr) As DWRITE_LOCALITY
        ' 14. EnqueueFontDownloadRequest
    EnqueueFontDownloadRequest As Function(ByVal This As IDWriteFontFaceReference_ Ptr) As HRESULT
        ' 15. EnqueueCharacterDownloadRequest
    EnqueueCharacterDownloadRequest As Function(ByVal This As IDWriteFontFaceReference_ Ptr,  ByVal characters As WString Ptr, ByVal characterCount As ULong ) As HRESULT
        ' 16. EnqueueGlyphDownloadRequest
    EnqueueGlyphDownloadRequest As Function(ByVal This As IDWriteFontFaceReference_ Ptr,  ByVal glyphIndices As UShort Ptr, ByVal glyphCount As ULong ) As HRESULT
        ' 17. EnqueueFileFragmentDownloadRequest
    EnqueueFileFragmentDownloadRequest As Function(ByVal This As IDWriteFontFaceReference_ Ptr,  ByVal fileOffset As ULongInt, ByVal fragmentSize As ULongInt ) As HRESULT
End Type
#define IDWriteFontFaceReference__QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontFaceReference__AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontFaceReference__Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontFaceReference__CreateFontFace(p, a) (p)->lpVtbl->CreateFontFace(p, a)
#define IDWriteFontFaceReference__CreateFontFaceWithSimulations(p, a, b) (p)->lpVtbl->CreateFontFaceWithSimulations(p, a, b)
#define IDWriteFontFaceReference__Equals(p, a) (p)->lpVtbl->Equals(p, a)
#define IDWriteFontFaceReference__GetFontFaceIndex(p, a) (p)->lpVtbl->GetFontFaceIndex(p, a)
#define IDWriteFontFaceReference__GetSimulations(p, a) (p)->lpVtbl->GetSimulations(p, a)
#define IDWriteFontFaceReference__GetFontFile(p, a) (p)->lpVtbl->GetFontFile(p, a)
#define IDWriteFontFaceReference__GetLocalFileSize(p, a) (p)->lpVtbl->GetLocalFileSize(p, a)
#define IDWriteFontFaceReference__GetFileSize(p, a) (p)->lpVtbl->GetFileSize(p, a)
#define IDWriteFontFaceReference__GetFileTime(p, a) (p)->lpVtbl->GetFileTime(p, a)
#define IDWriteFontFaceReference__GetLocality(p, a) (p)->lpVtbl->GetLocality(p, a)
#define IDWriteFontFaceReference__EnqueueFontDownloadRequest(p, a) (p)->lpVtbl->EnqueueFontDownloadRequest(p, a)
#define IDWriteFontFaceReference__EnqueueCharacterDownloadRequest(p, a, b) (p)->lpVtbl->EnqueueCharacterDownloadRequest(p, a, b)
#define IDWriteFontFaceReference__EnqueueGlyphDownloadRequest(p, a, b) (p)->lpVtbl->EnqueueGlyphDownloadRequest(p, a, b)
#define IDWriteFontFaceReference__EnqueueFileFragmentDownloadRequest(p, a, b) (p)->lpVtbl->EnqueueFileFragmentDownloadRequest(p, a, b)

' ============================================================================
' IDWriteFontFaceReference1
' ============================================================================
Type IDWriteFontFaceReference1_Vtbl As IDWriteFontFaceReference1_Vtbl_
Type IDWriteFontFaceReference1_
    lpVtbl As IDWriteFontFaceReference1_Vtbl Ptr
End Type
Type IDWriteFontFaceReference1_Vtbl_     '' Extends IDWriteFontFaceReference_Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFontFaceReference1_ Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontFaceReference1_ Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontFaceReference1_ Ptr) As ULong
        
    CreateFontFace As Function(ByVal This As IDWriteFontFaceReference1_ Ptr,  ByVal fontFace As IDWriteFontFace3 Ptr Ptr ) As HRESULT
        ' 5. CreateFontFaceWithSimulations
    CreateFontFaceWithSimulations As Function(ByVal This As IDWriteFontFaceReference1_ Ptr,  ByVal fontFaceSimulationFlags As DWRITE_FONT_SIMULATIONS, ByVal fontFace As IDWriteFontFace3 Ptr Ptr ) As HRESULT
        ' 6. Equals
    Equals As Function(ByVal This As IDWriteFontFaceReference1_ Ptr,  ByVal fontFaceReference As IDWriteFontFaceReference Ptr ) As Long
        ' 7. GetFontFaceIndex
    GetFontFaceIndex As Function(ByVal This As IDWriteFontFaceReference1_ Ptr) As ULong
        ' 8. GetSimulations
    GetSimulations As Function(ByVal This As IDWriteFontFaceReference1_ Ptr) As DWRITE_FONT_SIMULATIONS
        ' 9. GetFontFile
    GetFontFile As Function(ByVal This As IDWriteFontFaceReference1_ Ptr,  ByVal fontFile As IDWriteFontFile Ptr Ptr ) As HRESULT
        ' 10. GetLocalFileSize
    GetLocalFileSize As Function(ByVal This As IDWriteFontFaceReference1_ Ptr) As ULongInt
        ' 11. GetFileSize
    GetFileSize As Function(ByVal This As IDWriteFontFaceReference1_ Ptr) As ULongInt
        ' 12. GetFileTime
    GetFileTime As Function(ByVal This As IDWriteFontFaceReference1_ Ptr,  ByVal lastWriteTime As FILETIME Ptr ) As HRESULT
        ' 13. GetLocality
    GetLocality As Function(ByVal This As IDWriteFontFaceReference1_ Ptr) As DWRITE_LOCALITY
        ' 14. EnqueueFontDownloadRequest
    EnqueueFontDownloadRequest As Function(ByVal This As IDWriteFontFaceReference1_ Ptr) As HRESULT
        ' 15. EnqueueCharacterDownloadRequest
    EnqueueCharacterDownloadRequest As Function(ByVal This As IDWriteFontFaceReference1_ Ptr,  ByVal characters As WString Ptr, ByVal characterCount As ULong ) As HRESULT
        ' 16. EnqueueGlyphDownloadRequest
    EnqueueGlyphDownloadRequest As Function(ByVal This As IDWriteFontFaceReference1_ Ptr,  ByVal glyphIndices As UShort Ptr, ByVal glyphCount As ULong ) As HRESULT
        ' 17. EnqueueFileFragmentDownloadRequest
    EnqueueFileFragmentDownloadRequest As Function(ByVal This As IDWriteFontFaceReference1_ Ptr,  ByVal fileOffset As ULongInt, ByVal fragmentSize As ULongInt ) As HRESULT

        
    CreateFontFace1 As Function(ByVal This As IDWriteFontFaceReference1_ Ptr,  ByVal fontFace As IDWriteFontFace5 Ptr Ptr ) As HRESULT
        ' 19. GetFontAxisValueCount
    GetFontAxisValueCount As Function(ByVal This As IDWriteFontFaceReference1_ Ptr) As ULong
        ' 20. GetFontAxisValues
    GetFontAxisValues As Function(ByVal This As IDWriteFontFaceReference1_ Ptr,  ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong ) As HRESULT
End Type
#define IDWriteFontFaceReference1__QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontFaceReference1__AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontFaceReference1__Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontFaceReference1__CreateFontFace(p, a) (p)->lpVtbl->CreateFontFace(p, a)
#define IDWriteFontFaceReference1__CreateFontFaceWithSimulations(p, a, b) (p)->lpVtbl->CreateFontFaceWithSimulations(p, a, b)
#define IDWriteFontFaceReference1__Equals(p, a) (p)->lpVtbl->Equals(p, a)
#define IDWriteFontFaceReference1__GetFontFaceIndex(p, a) (p)->lpVtbl->GetFontFaceIndex(p, a)
#define IDWriteFontFaceReference1__GetSimulations(p, a) (p)->lpVtbl->GetSimulations(p, a)
#define IDWriteFontFaceReference1__GetFontFile(p, a) (p)->lpVtbl->GetFontFile(p, a)
#define IDWriteFontFaceReference1__GetLocalFileSize(p, a) (p)->lpVtbl->GetLocalFileSize(p, a)
#define IDWriteFontFaceReference1__GetFileSize(p, a) (p)->lpVtbl->GetFileSize(p, a)
#define IDWriteFontFaceReference1__GetFileTime(p, a) (p)->lpVtbl->GetFileTime(p, a)
#define IDWriteFontFaceReference1__GetLocality(p, a) (p)->lpVtbl->GetLocality(p, a)
#define IDWriteFontFaceReference1__EnqueueFontDownloadRequest(p, a) (p)->lpVtbl->EnqueueFontDownloadRequest(p, a)
#define IDWriteFontFaceReference1__EnqueueCharacterDownloadRequest(p, a, b) (p)->lpVtbl->EnqueueCharacterDownloadRequest(p, a, b)
#define IDWriteFontFaceReference1__EnqueueGlyphDownloadRequest(p, a, b) (p)->lpVtbl->EnqueueGlyphDownloadRequest(p, a, b)
#define IDWriteFontFaceReference1__EnqueueFileFragmentDownloadRequest(p, a, b) (p)->lpVtbl->EnqueueFileFragmentDownloadRequest(p, a, b)
#define IDWriteFontFaceReference1__CreateFontFace1(p, a) (p)->lpVtbl->CreateFontFace1(p, a)
#define IDWriteFontFaceReference1__GetFontAxisValueCount(p, a) (p)->lpVtbl->GetFontAxisValueCount(p, a)
#define IDWriteFontFaceReference1__GetFontAxisValues(p, a, b) (p)->lpVtbl->GetFontAxisValues(p, a, b)

' ============================================================================
' IDWriteFontList1
' ============================================================================
Type IDWriteFontList1Vtbl As IDWriteFontList1Vtbl_
Type IDWriteFontList1
    lpVtbl As IDWriteFontList1Vtbl Ptr
End Type
Type IDWriteFontList1Vtbl_     '' Extends IDWriteFontListVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontList1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontList1 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontList1 Ptr) As ULong
        ' --- IUnknown (1-3) ---
        ' 2. AddRef
        ' 4.
    GetFontCollection As Function(ByVal This As IDWriteFontList1 Ptr, ByRef fontCollection As any Ptr) As HRESULT 'IDWriteFontCollection Ptr
    GetFontCount As Function(ByVal This As IDWriteFontList1 Ptr) As ULong
    GetFont As Function(ByVal This As IDWriteFontList1 Ptr, ByVal index As ULong, ByRef font As IDWriteFont Ptr) As HRESULT

        
    GetFontLocality As Function(ByVal This As IDWriteFontList1 Ptr,  ByVal listIndex As ULong ) As DWRITE_LOCALITY
        ' 8. GetFont
    GetFont1 As Function(ByVal This As IDWriteFontList1 Ptr,  ByVal listIndex As ULong, ByVal font As IDWriteFont3 Ptr Ptr ) As HRESULT
        ' 9. GetFontFaceReference
    GetFontFaceReference As Function(ByVal This As IDWriteFontList1 Ptr,  ByVal listIndex As ULong, ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
End Type
#define IDWriteFontList1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontList1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontList1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontList1_GetFontCollection(p, a) (p)->lpVtbl->GetFontCollection(p, a)
#define IDWriteFontList1_GetFontCount(p, a) (p)->lpVtbl->GetFontCount(p, a)
#define IDWriteFontList1_GetFont(p, a, b) (p)->lpVtbl->GetFont(p, a, b)
#define IDWriteFontList1_GetFontLocality(p, a) (p)->lpVtbl->GetFontLocality(p, a)
#define IDWriteFontList1_GetFont1(p, a, b) (p)->lpVtbl->GetFont1(p, a, b)
#define IDWriteFontList1_GetFontFaceReference(p, a, b) (p)->lpVtbl->GetFontFaceReference(p, a, b)

' ============================================================================
' IDWriteFontList2
' ============================================================================
Type IDWriteFontList2_Vtbl As IDWriteFontList2_Vtbl_
Type IDWriteFontList2_
    lpVtbl As IDWriteFontList2_Vtbl Ptr
End Type
Type IDWriteFontList2_Vtbl_     '' Extends IDWriteFontList1Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFontList2_ Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontList2_ Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontList2_ Ptr) As ULong
        ' --- IUnknown (1-3) ---
        ' 2. AddRef
        ' 4.
    GetFontCollection As Function(ByVal This As IDWriteFontList2_ Ptr, ByRef fontCollection As any Ptr) As HRESULT 'IDWriteFontCollection Ptr
    GetFontCount As Function(ByVal This As IDWriteFontList2_ Ptr) As ULong
    GetFont As Function(ByVal This As IDWriteFontList2_ Ptr, ByVal index As ULong, ByRef font As IDWriteFont Ptr) As HRESULT
        
    GetFontLocality As Function(ByVal This As IDWriteFontList2_ Ptr,  ByVal listIndex As ULong ) As DWRITE_LOCALITY
        ' 8. GetFont
    GetFont1 As Function(ByVal This As IDWriteFontList2_ Ptr,  ByVal listIndex As ULong, ByVal font As IDWriteFont3 Ptr Ptr ) As HRESULT
        ' 9. GetFontFaceReference
    GetFontFaceReference As Function(ByVal This As IDWriteFontList2_ Ptr,  ByVal listIndex As ULong, ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT

        
    GetFontSet As Function(ByVal This As IDWriteFontList2_ Ptr,  ByVal fontSet As IDWriteFontSet1 Ptr Ptr ) As HRESULT
End Type
#define IDWriteFontList2__QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontList2__AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontList2__Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontList2__GetFontCollection(p, a) (p)->lpVtbl->GetFontCollection(p, a)
#define IDWriteFontList2__GetFontCount(p, a) (p)->lpVtbl->GetFontCount(p, a)
#define IDWriteFontList2__GetFont(p, a, b) (p)->lpVtbl->GetFont(p, a, b)
#define IDWriteFontList2__GetFontLocality(p, a) (p)->lpVtbl->GetFontLocality(p, a)
#define IDWriteFontList2__GetFont1(p, a, b) (p)->lpVtbl->GetFont1(p, a, b)
#define IDWriteFontList2__GetFontFaceReference(p, a, b) (p)->lpVtbl->GetFontFaceReference(p, a, b)
#define IDWriteFontList2__GetFontSet(p, a) (p)->lpVtbl->GetFontSet(p, a)

' ============================================================================
' IDWriteFontSet2
' ============================================================================
Type IDWriteFontSet2Vtbl As IDWriteFontSet2Vtbl_
Type IDWriteFontSet2
    lpVtbl As IDWriteFontSet2Vtbl Ptr
End Type
Type IDWriteFontSet2Vtbl_     '' Extends IDWriteFontSet1Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFontSet2 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontSet2 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontSet2 Ptr) As ULong
        
    GetFontCount As Function(ByVal This As IDWriteFontSet2 Ptr) As ULong
        ' 5. GetFontFaceReference
    GetFontFaceReference As Function(ByVal This As IDWriteFontSet2 Ptr,  ByVal listIndex As ULong, ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 6. FindFontFaceReference
    FindFontFaceReference As Function(ByVal This As IDWriteFontSet2 Ptr,  ByVal fontFaceReference As IDWriteFontFaceReference Ptr, ByVal listIndex As ULong Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 7. FindFontFace
    FindFontFace As Function(ByVal This As IDWriteFontSet2 Ptr,  ByVal fontFace As IDWriteFontFace Ptr, ByVal listIndex As ULong Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 8. GetPropertyValues__ (double underscore version)
    GetPropertyValues__ As Function(ByVal This As IDWriteFontSet2 Ptr,  ByVal propertyID As DWRITE_FONT_PROPERTY_ID, ByVal values As IDWriteStringList Ptr Ptr ) As HRESULT
        ' 9. GetPropertyValues_ (single underscore version)
    GetPropertyValues_ As Function(ByVal This As IDWriteFontSet2 Ptr,  ByVal propertyID As DWRITE_FONT_PROPERTY_ID, ByVal preferredLocaleNames As WString Ptr, ByVal values As IDWriteStringList Ptr Ptr ) As HRESULT
        ' 10. GetPropertyValues (by index)
    GetPropertyValues As Function(ByVal This As IDWriteFontSet2 Ptr,  ByVal listIndex As ULong, ByVal propertyId As DWRITE_FONT_PROPERTY_ID, ByVal exists As Long Ptr, ByVal values As IDWriteLocalizedStrings Ptr Ptr ) As HRESULT
        ' 11. GetPropertyOccurrenceCount
    GetPropertyOccurrenceCount As Function(ByVal This As IDWriteFontSet2 Ptr,  ByVal property As DWRITE_FONT_PROPERTY Ptr, ByVal propertyOccurrenceCount As ULong Ptr ) As HRESULT
        ' 12. GetMatchingFonts_ (by family and WWS)
    GetMatchingFonts_ As Function(ByVal This As IDWriteFontSet2 Ptr,  ByVal familyName As WString Ptr, ByVal fontWeight As DWRITE_FONT_WEIGHT, ByVal fontStretch As DWRITE_FONT_STRETCH, ByVal fontStyle As DWRITE_FONT_STYLE, ByVal filteredSet As IDWriteFontSet Ptr Ptr ) As HRESULT
        ' 13. GetMatchingFonts (by properties)
    GetMatchingFonts As Function(ByVal This As IDWriteFontSet2 Ptr,  ByVal properties As DWRITE_FONT_PROPERTY Ptr, ByVal propertyCount As ULong, ByVal filteredSet As IDWriteFontSet Ptr Ptr ) As HRESULT
        
    GetMatchingFonts1 As Function(ByVal This As IDWriteFontSet2 Ptr,  ByVal fontProperty As DWRITE_FONT_PROPERTY Ptr, ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong, ByVal matchingFonts As IDWriteFontSet2 Ptr Ptr ) As HRESULT
        ' 15. GetFirstFontResources
    GetFirstFontResources As Function(ByVal This As IDWriteFontSet2 Ptr,  ByVal filteredFontSet As IDWriteFontSet2 Ptr Ptr ) As HRESULT
        ' 16. GetFilteredFonts__ (by indices)
    GetFilteredFonts__ As Function(ByVal This As IDWriteFontSet2 Ptr,  ByVal indices As ULong Ptr, ByVal indexCount As ULong, ByVal filteredFontSet As IDWriteFontSet2 Ptr Ptr ) As HRESULT
        ' 17. GetFilteredFonts_ (by axis ranges)
    GetFilteredFonts_ As Function(ByVal This As IDWriteFontSet2 Ptr,  ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, ByVal fontAxisRangeCount As ULong, ByVal selectAnyRange As Long, ByVal filteredFontSet As IDWriteFontSet2 Ptr Ptr ) As HRESULT
        ' 18. GetFilteredFonts (by properties)
    GetFilteredFonts As Function(ByVal This As IDWriteFontSet2 Ptr,  ByVal properties As DWRITE_FONT_PROPERTY Ptr, ByVal propertyCount As ULong, ByVal selectAnyProperty As Long, ByVal filteredFontSet As IDWriteFontSet2 Ptr Ptr ) As HRESULT
        ' 19. GetFilteredFontIndices_ (by axis ranges)
    GetFilteredFontIndices_ As Function(ByVal This As IDWriteFontSet2 Ptr,  ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, ByVal fontAxisRangeCount As ULong, ByVal selectAnyRange As Long, ByVal indices As ULong Ptr, ByVal maxIndexCount As ULong, ByVal actualIndexCount As ULong Ptr ) As HRESULT
        ' 20. GetFilteredFontIndices (by properties)
    GetFilteredFontIndices As Function(ByVal This As IDWriteFontSet2 Ptr,  ByVal properties As DWRITE_FONT_PROPERTY Ptr, ByVal propertyCount As ULong, ByVal selectAnyProperty As Long, ByVal indices As ULong Ptr, ByVal maxIndexCount As ULong, ByVal actualIndexCount As ULong Ptr ) As HRESULT
        ' 21. GetFontAxisRanges_ (by font index)
    GetFontAxisRanges_ As Function(ByVal This As IDWriteFontSet2 Ptr,  ByVal listIndex As ULong, ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, ByVal maxFontAxisRangeCount As ULong, ByVal actualFontAxisRangeCount As ULong Ptr ) As HRESULT
        ' 22. GetFontAxisRanges (all fonts)
    GetFontAxisRanges As Function(ByVal This As IDWriteFontSet2 Ptr,  ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, ByVal maxFontAxisRangeCount As ULong, ByVal actualFontAxisRangeCount As ULong Ptr ) As HRESULT
        ' 23. GetFontFaceReference
    GetFontFaceReference1 As Function(ByVal This As IDWriteFontSet2 Ptr,  ByVal listIndex As ULong, ByVal fontFaceReference As IDWriteFontFaceReference1 Ptr Ptr ) As HRESULT
        ' 24. CreateFontResource
    CreateFontResource As Function(ByVal This As IDWriteFontSet2 Ptr,  ByVal listIndex As ULong, ByVal fontResource As IDWriteFontResource Ptr Ptr ) As HRESULT
        ' 25. CreateFontFace
    CreateFontFace As Function(ByVal This As IDWriteFontSet2 Ptr,  ByVal listIndex As ULong, ByVal fontFace As IDWriteFontFace5 Ptr Ptr ) As HRESULT
        ' 26. GetFontLocality
    GetFontLocality As Function(ByVal This As IDWriteFontSet2 Ptr,  ByVal listIndex As ULong ) As DWRITE_LOCALITY

        
    GetExpirationEvent As Function(ByVal This As IDWriteFontSet2 Ptr) As HANDLE
End Type
#define IDWriteFontSet2_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontSet2_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontSet2_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontSet2_GetFontCount(p, a) (p)->lpVtbl->GetFontCount(p, a)
#define IDWriteFontSet2_GetFontFaceReference(p, a, b) (p)->lpVtbl->GetFontFaceReference(p, a, b)
#define IDWriteFontSet2_FindFontFaceReference(p, a, b, c) (p)->lpVtbl->FindFontFaceReference(p, a, b, c)
#define IDWriteFontSet2_FindFontFace(p, a, b, c) (p)->lpVtbl->FindFontFace(p, a, b, c)
#define IDWriteFontSet2_GetPropertyValues__(p, a, b) (p)->lpVtbl->GetPropertyValues__(p, a, b)
#define IDWriteFontSet2_GetPropertyValues_(p, a, b, c) (p)->lpVtbl->GetPropertyValues_(p, a, b, c)
#define IDWriteFontSet2_GetPropertyValues(p, a, b, c, d) (p)->lpVtbl->GetPropertyValues(p, a, b, c, d)
#define IDWriteFontSet2_GetPropertyOccurrenceCount(p, a, b) (p)->lpVtbl->GetPropertyOccurrenceCount(p, a, b)
#define IDWriteFontSet2_GetMatchingFonts_(p, a, b, c, d, e) (p)->lpVtbl->GetMatchingFonts_(p, a, b, c, d, e)
#define IDWriteFontSet2_GetMatchingFonts(p, a, b, c) (p)->lpVtbl->GetMatchingFonts(p, a, b, c)
#define IDWriteFontSet2_GetMatchingFonts1(p, a, b, c, d) (p)->lpVtbl->GetMatchingFonts1(p, a, b, c, d)
#define IDWriteFontSet2_GetFirstFontResources(p, a) (p)->lpVtbl->GetFirstFontResources(p, a)
#define IDWriteFontSet2_GetFilteredFonts__(p, a, b, c) (p)->lpVtbl->GetFilteredFonts__(p, a, b, c)
#define IDWriteFontSet2_GetFilteredFonts_(p, a, b, c, d) (p)->lpVtbl->GetFilteredFonts_(p, a, b, c, d)
#define IDWriteFontSet2_GetFilteredFonts(p, a, b, c, d) (p)->lpVtbl->GetFilteredFonts(p, a, b, c, d)
#define IDWriteFontSet2_GetFilteredFontIndices_(p, a, b, c, d, e, f) (p)->lpVtbl->GetFilteredFontIndices_(p, a, b, c, d, e, f)
#define IDWriteFontSet2_GetFilteredFontIndices(p, a, b, c, d, e, f) (p)->lpVtbl->GetFilteredFontIndices(p, a, b, c, d, e, f)
#define IDWriteFontSet2_GetFontAxisRanges_(p, a, b, c, d) (p)->lpVtbl->GetFontAxisRanges_(p, a, b, c, d)
#define IDWriteFontSet2_GetFontAxisRanges(p, a, b, c) (p)->lpVtbl->GetFontAxisRanges(p, a, b, c)
#define IDWriteFontSet2_GetFontFaceReference1(p, a, b) (p)->lpVtbl->GetFontFaceReference1(p, a, b)
#define IDWriteFontSet2_CreateFontResource(p, a, b) (p)->lpVtbl->CreateFontResource(p, a, b)
#define IDWriteFontSet2_CreateFontFace(p, a, b) (p)->lpVtbl->CreateFontFace(p, a, b)
#define IDWriteFontSet2_GetFontLocality(p, a) (p)->lpVtbl->GetFontLocality(p, a)
#define IDWriteFontSet2_GetExpirationEvent(p, a) (p)->lpVtbl->GetExpirationEvent(p, a)

' ============================================================================
' IDWriteFontSet3
' ============================================================================
Type IDWriteFontSet3Vtbl As IDWriteFontSet3Vtbl_
Type IDWriteFontSet3
    lpVtbl As IDWriteFontSet3Vtbl Ptr
End Type
Type IDWriteFontSet3Vtbl_     '' Extends IDWriteFontSet2Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFontSet3 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontSet3 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontSet3 Ptr) As ULong
        
    GetFontCount As Function(ByVal This As IDWriteFontSet3 Ptr) As ULong
        ' 5. GetFontFaceReference
    GetFontFaceReference As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal listIndex As ULong, ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 6. FindFontFaceReference
    FindFontFaceReference As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal fontFaceReference As IDWriteFontFaceReference Ptr, ByVal listIndex As ULong Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 7. FindFontFace
    FindFontFace As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal fontFace As IDWriteFontFace Ptr, ByVal listIndex As ULong Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 8. GetPropertyValues__ (double underscore version)
    GetPropertyValues__ As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal propertyID As DWRITE_FONT_PROPERTY_ID, ByVal values As IDWriteStringList Ptr Ptr ) As HRESULT
        ' 9. GetPropertyValues_ (single underscore version)
    GetPropertyValues_ As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal propertyID As DWRITE_FONT_PROPERTY_ID, ByVal preferredLocaleNames As WString Ptr, ByVal values As IDWriteStringList Ptr Ptr ) As HRESULT
        ' 10. GetPropertyValues (by index)
    GetPropertyValues As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal listIndex As ULong, ByVal propertyId As DWRITE_FONT_PROPERTY_ID, ByVal exists As Long Ptr, ByVal values As IDWriteLocalizedStrings Ptr Ptr ) As HRESULT
        ' 11. GetPropertyOccurrenceCount
    GetPropertyOccurrenceCount As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal property As DWRITE_FONT_PROPERTY Ptr, ByVal propertyOccurrenceCount As ULong Ptr ) As HRESULT
        ' 12. GetMatchingFonts_ (by family and WWS)
    GetMatchingFonts_ As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal familyName As WString Ptr, ByVal fontWeight As DWRITE_FONT_WEIGHT, ByVal fontStretch As DWRITE_FONT_STRETCH, ByVal fontStyle As DWRITE_FONT_STYLE, ByVal filteredSet As IDWriteFontSet Ptr Ptr ) As HRESULT
        ' 13. GetMatchingFonts (by properties)
    GetMatchingFonts As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal properties As DWRITE_FONT_PROPERTY Ptr, ByVal propertyCount As ULong, ByVal filteredSet As IDWriteFontSet Ptr Ptr ) As HRESULT
        
    GetMatchingFonts1 As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal fontProperty As DWRITE_FONT_PROPERTY Ptr, ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong, ByVal matchingFonts As IDWriteFontSet3 Ptr Ptr ) As HRESULT
        ' 15. GetFirstFontResources
    GetFirstFontResources As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal filteredFontSet As IDWriteFontSet3 Ptr Ptr ) As HRESULT
        ' 16. GetFilteredFonts__ (by indices)
    GetFilteredFonts__ As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal indices As ULong Ptr, ByVal indexCount As ULong, ByVal filteredFontSet As IDWriteFontSet3 Ptr Ptr ) As HRESULT
        ' 17. GetFilteredFonts_ (by axis ranges)
    GetFilteredFonts_ As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, ByVal fontAxisRangeCount As ULong, ByVal selectAnyRange As Long, ByVal filteredFontSet As IDWriteFontSet3 Ptr Ptr ) As HRESULT
        ' 18. GetFilteredFonts (by properties)
    GetFilteredFonts As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal properties As DWRITE_FONT_PROPERTY Ptr, ByVal propertyCount As ULong, ByVal selectAnyProperty As Long, ByVal filteredFontSet As IDWriteFontSet3 Ptr Ptr ) As HRESULT
        ' 19. GetFilteredFontIndices_ (by axis ranges)
    GetFilteredFontIndices_ As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, ByVal fontAxisRangeCount As ULong, ByVal selectAnyRange As Long, ByVal indices As ULong Ptr, ByVal maxIndexCount As ULong, ByVal actualIndexCount As ULong Ptr ) As HRESULT
        ' 20. GetFilteredFontIndices (by properties)
    GetFilteredFontIndices As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal properties As DWRITE_FONT_PROPERTY Ptr, ByVal propertyCount As ULong, ByVal selectAnyProperty As Long, ByVal indices As ULong Ptr, ByVal maxIndexCount As ULong, ByVal actualIndexCount As ULong Ptr ) As HRESULT
        ' 21. GetFontAxisRanges_ (by font index)
    GetFontAxisRanges_ As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal listIndex As ULong, ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, ByVal maxFontAxisRangeCount As ULong, ByVal actualFontAxisRangeCount As ULong Ptr ) As HRESULT
        ' 22. GetFontAxisRanges (all fonts)
    GetFontAxisRanges As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, ByVal maxFontAxisRangeCount As ULong, ByVal actualFontAxisRangeCount As ULong Ptr ) As HRESULT
        ' 23. GetFontFaceReference
    GetFontFaceReference1 As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal listIndex As ULong, ByVal fontFaceReference As IDWriteFontFaceReference1 Ptr Ptr ) As HRESULT
        ' 24. CreateFontResource
    CreateFontResource As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal listIndex As ULong, ByVal fontResource As IDWriteFontResource Ptr Ptr ) As HRESULT
        ' 25. CreateFontFace
    CreateFontFace As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal listIndex As ULong, ByVal fontFace As IDWriteFontFace5 Ptr Ptr ) As HRESULT
        ' 26. GetFontLocality
    GetFontLocality As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal listIndex As ULong ) As DWRITE_LOCALITY
        
    GetExpirationEvent As Function(ByVal This As IDWriteFontSet3 Ptr) As HANDLE

        
    GetFontSourceType As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal fontIndex As ULong ) As DWRITE_FONT_SOURCE_TYPE
        ' 29. GetFontSourceNameLength
    GetFontSourceNameLength As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal listIndex As ULong ) As ULong
        ' 30. GetFontSourceName
    GetFontSourceName As Function(ByVal This As IDWriteFontSet3 Ptr,  ByVal listIndex As ULong, ByVal stringBuffer As WString Ptr, ByVal stringBufferSize As ULong ) As HRESULT
End Type
#define IDWriteFontSet3_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontSet3_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontSet3_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontSet3_GetFontCount(p, a) (p)->lpVtbl->GetFontCount(p, a)
#define IDWriteFontSet3_GetFontFaceReference(p, a, b) (p)->lpVtbl->GetFontFaceReference(p, a, b)
#define IDWriteFontSet3_FindFontFaceReference(p, a, b, c) (p)->lpVtbl->FindFontFaceReference(p, a, b, c)
#define IDWriteFontSet3_FindFontFace(p, a, b, c) (p)->lpVtbl->FindFontFace(p, a, b, c)
#define IDWriteFontSet3_GetPropertyValues__(p, a, b) (p)->lpVtbl->GetPropertyValues__(p, a, b)
#define IDWriteFontSet3_GetPropertyValues_(p, a, b, c) (p)->lpVtbl->GetPropertyValues_(p, a, b, c)
#define IDWriteFontSet3_GetPropertyValues(p, a, b, c, d) (p)->lpVtbl->GetPropertyValues(p, a, b, c, d)
#define IDWriteFontSet3_GetPropertyOccurrenceCount(p, a, b) (p)->lpVtbl->GetPropertyOccurrenceCount(p, a, b)
#define IDWriteFontSet3_GetMatchingFonts_(p, a, b, c, d, e) (p)->lpVtbl->GetMatchingFonts_(p, a, b, c, d, e)
#define IDWriteFontSet3_GetMatchingFonts(p, a, b, c) (p)->lpVtbl->GetMatchingFonts(p, a, b, c)
#define IDWriteFontSet3_GetMatchingFonts1(p, a, b, c, d) (p)->lpVtbl->GetMatchingFonts1(p, a, b, c, d)
#define IDWriteFontSet3_GetFirstFontResources(p, a) (p)->lpVtbl->GetFirstFontResources(p, a)
#define IDWriteFontSet3_GetFilteredFonts__(p, a, b, c) (p)->lpVtbl->GetFilteredFonts__(p, a, b, c)
#define IDWriteFontSet3_GetFilteredFonts_(p, a, b, c, d) (p)->lpVtbl->GetFilteredFonts_(p, a, b, c, d)
#define IDWriteFontSet3_GetFilteredFonts(p, a, b, c, d) (p)->lpVtbl->GetFilteredFonts(p, a, b, c, d)
#define IDWriteFontSet3_GetFilteredFontIndices_(p, a, b, c, d, e, f) (p)->lpVtbl->GetFilteredFontIndices_(p, a, b, c, d, e, f)
#define IDWriteFontSet3_GetFilteredFontIndices(p, a, b, c, d, e, f) (p)->lpVtbl->GetFilteredFontIndices(p, a, b, c, d, e, f)
#define IDWriteFontSet3_GetFontAxisRanges_(p, a, b, c, d) (p)->lpVtbl->GetFontAxisRanges_(p, a, b, c, d)
#define IDWriteFontSet3_GetFontAxisRanges(p, a, b, c) (p)->lpVtbl->GetFontAxisRanges(p, a, b, c)
#define IDWriteFontSet3_GetFontFaceReference1(p, a, b) (p)->lpVtbl->GetFontFaceReference1(p, a, b)
#define IDWriteFontSet3_CreateFontResource(p, a, b) (p)->lpVtbl->CreateFontResource(p, a, b)
#define IDWriteFontSet3_CreateFontFace(p, a, b) (p)->lpVtbl->CreateFontFace(p, a, b)
#define IDWriteFontSet3_GetFontLocality(p, a) (p)->lpVtbl->GetFontLocality(p, a)
#define IDWriteFontSet3_GetExpirationEvent(p, a) (p)->lpVtbl->GetExpirationEvent(p, a)
#define IDWriteFontSet3_GetFontSourceType(p, a) (p)->lpVtbl->GetFontSourceType(p, a)
#define IDWriteFontSet3_GetFontSourceNameLength(p, a) (p)->lpVtbl->GetFontSourceNameLength(p, a)
#define IDWriteFontSet3_GetFontSourceName(p, a, b, c) (p)->lpVtbl->GetFontSourceName(p, a, b, c)

' ============================================================================
' IDWriteFontSet4
' ============================================================================
Type IDWriteFontSet4Vtbl As IDWriteFontSet4Vtbl_
Type IDWriteFontSet4
    lpVtbl As IDWriteFontSet4Vtbl Ptr
End Type
Type IDWriteFontSet4Vtbl_     '' Extends IDWriteFontSet3Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFontSet4 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontSet4 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontSet4 Ptr) As ULong
        
    GetFontCount As Function(ByVal This As IDWriteFontSet4 Ptr) As ULong
        ' 5. GetFontFaceReference
    GetFontFaceReference As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal listIndex As ULong, ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 6. FindFontFaceReference
    FindFontFaceReference As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal fontFaceReference As IDWriteFontFaceReference Ptr, ByVal listIndex As ULong Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 7. FindFontFace
    FindFontFace As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal fontFace As IDWriteFontFace Ptr, ByVal listIndex As ULong Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 8. GetPropertyValues__ (double underscore version)
    GetPropertyValues__ As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal propertyID As DWRITE_FONT_PROPERTY_ID, ByVal values As IDWriteStringList Ptr Ptr ) As HRESULT
        ' 9. GetPropertyValues_ (single underscore version)
    GetPropertyValues_ As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal propertyID As DWRITE_FONT_PROPERTY_ID, ByVal preferredLocaleNames As WString Ptr, ByVal values As IDWriteStringList Ptr Ptr ) As HRESULT
        ' 10. GetPropertyValues (by index)
    GetPropertyValues As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal listIndex As ULong, ByVal propertyId As DWRITE_FONT_PROPERTY_ID, ByVal exists As Long Ptr, ByVal values As IDWriteLocalizedStrings Ptr Ptr ) As HRESULT
        ' 11. GetPropertyOccurrenceCount
    GetPropertyOccurrenceCount As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal property As DWRITE_FONT_PROPERTY Ptr, ByVal propertyOccurrenceCount As ULong Ptr ) As HRESULT
        ' 12. GetMatchingFonts_ (by family and WWS)
    GetMatchingFonts_ As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal familyName As WString Ptr, ByVal fontWeight As DWRITE_FONT_WEIGHT, ByVal fontStretch As DWRITE_FONT_STRETCH, ByVal fontStyle As DWRITE_FONT_STYLE, ByVal filteredSet As IDWriteFontSet Ptr Ptr ) As HRESULT
        ' 13. GetMatchingFonts (by properties)
    GetMatchingFonts As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal properties As DWRITE_FONT_PROPERTY Ptr, ByVal propertyCount As ULong, ByVal filteredSet As IDWriteFontSet Ptr Ptr ) As HRESULT
        
    GetMatchingFonts1 As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal fontProperty As DWRITE_FONT_PROPERTY Ptr, ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong, ByVal matchingFonts As IDWriteFontSet4 Ptr Ptr ) As HRESULT
        ' 15. GetFirstFontResources
    GetFirstFontResources As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal filteredFontSet As IDWriteFontSet4 Ptr Ptr ) As HRESULT
        ' 16. GetFilteredFonts__ (by indices)
    GetFilteredFonts__ As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal indices As ULong Ptr, ByVal indexCount As ULong, ByVal filteredFontSet As IDWriteFontSet4 Ptr Ptr ) As HRESULT
        ' 17. GetFilteredFonts_ (by axis ranges)
    GetFilteredFonts_ As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, ByVal fontAxisRangeCount As ULong, ByVal selectAnyRange As Long, ByVal filteredFontSet As IDWriteFontSet4 Ptr Ptr ) As HRESULT
        ' 18. GetFilteredFonts (by properties)
    GetFilteredFonts As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal properties As DWRITE_FONT_PROPERTY Ptr, ByVal propertyCount As ULong, ByVal selectAnyProperty As Long, ByVal filteredFontSet As IDWriteFontSet4 Ptr Ptr ) As HRESULT
        ' 19. GetFilteredFontIndices_ (by axis ranges)
    GetFilteredFontIndices_ As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, ByVal fontAxisRangeCount As ULong, ByVal selectAnyRange As Long, ByVal indices As ULong Ptr, ByVal maxIndexCount As ULong, ByVal actualIndexCount As ULong Ptr ) As HRESULT
        ' 20. GetFilteredFontIndices (by properties)
    GetFilteredFontIndices As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal properties As DWRITE_FONT_PROPERTY Ptr, ByVal propertyCount As ULong, ByVal selectAnyProperty As Long, ByVal indices As ULong Ptr, ByVal maxIndexCount As ULong, ByVal actualIndexCount As ULong Ptr ) As HRESULT
        ' 21. GetFontAxisRanges_ (by font index)
    GetFontAxisRanges_ As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal listIndex As ULong, ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, ByVal maxFontAxisRangeCount As ULong, ByVal actualFontAxisRangeCount As ULong Ptr ) As HRESULT
        ' 22. GetFontAxisRanges (all fonts)
    GetFontAxisRanges As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, ByVal maxFontAxisRangeCount As ULong, ByVal actualFontAxisRangeCount As ULong Ptr ) As HRESULT
        ' 23. GetFontFaceReference
    GetFontFaceReference1 As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal listIndex As ULong, ByVal fontFaceReference As IDWriteFontFaceReference1 Ptr Ptr ) As HRESULT
        ' 24. CreateFontResource
    CreateFontResource As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal listIndex As ULong, ByVal fontResource As IDWriteFontResource Ptr Ptr ) As HRESULT
        ' 25. CreateFontFace
    CreateFontFace As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal listIndex As ULong, ByVal fontFace As IDWriteFontFace5 Ptr Ptr ) As HRESULT
        ' 26. GetFontLocality
    GetFontLocality As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal listIndex As ULong ) As DWRITE_LOCALITY
        
    GetExpirationEvent As Function(ByVal This As IDWriteFontSet4 Ptr) As HANDLE
        
    GetFontSourceType As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal fontIndex As ULong ) As DWRITE_FONT_SOURCE_TYPE
        ' 29. GetFontSourceNameLength
    GetFontSourceNameLength As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal listIndex As ULong ) As ULong
        ' 30. GetFontSourceName
    GetFontSourceName As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal listIndex As ULong, ByVal stringBuffer As WString Ptr, ByVal stringBufferSize As ULong ) As HRESULT

        
    ConvertWeightStretchStyleToFontAxisValues As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal inputAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal inputAxisCount As ULong, ByVal fontWeight As DWRITE_FONT_WEIGHT, ByVal fontStretch As DWRITE_FONT_STRETCH, ByVal fontStyle As DWRITE_FONT_STYLE, ByVal fontSize As Single, ByVal outputAxisValues As DWRITE_FONT_AXIS_VALUE Ptr ) As ULong
        ' 32. GetMatchingFonts
    GetMatchingFonts2 As Function(ByVal This As IDWriteFontSet4 Ptr,  ByVal familyName As WString Ptr, ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong, ByVal allowedSimulations As DWRITE_FONT_SIMULATIONS, ByVal matchingFonts As IDWriteFontSet4 Ptr Ptr ) As HRESULT
End Type
#define IDWriteFontSet4_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontSet4_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontSet4_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontSet4_GetFontCount(p, a) (p)->lpVtbl->GetFontCount(p, a)
#define IDWriteFontSet4_GetFontFaceReference(p, a, b) (p)->lpVtbl->GetFontFaceReference(p, a, b)
#define IDWriteFontSet4_FindFontFaceReference(p, a, b, c) (p)->lpVtbl->FindFontFaceReference(p, a, b, c)
#define IDWriteFontSet4_FindFontFace(p, a, b, c) (p)->lpVtbl->FindFontFace(p, a, b, c)
#define IDWriteFontSet4_GetPropertyValues__(p, a, b) (p)->lpVtbl->GetPropertyValues__(p, a, b)
#define IDWriteFontSet4_GetPropertyValues_(p, a, b, c) (p)->lpVtbl->GetPropertyValues_(p, a, b, c)
#define IDWriteFontSet4_GetPropertyValues(p, a, b, c, d) (p)->lpVtbl->GetPropertyValues(p, a, b, c, d)
#define IDWriteFontSet4_GetPropertyOccurrenceCount(p, a, b) (p)->lpVtbl->GetPropertyOccurrenceCount(p, a, b)
#define IDWriteFontSet4_GetMatchingFonts_(p, a, b, c, d, e) (p)->lpVtbl->GetMatchingFonts_(p, a, b, c, d, e)
#define IDWriteFontSet4_GetMatchingFonts(p, a, b, c) (p)->lpVtbl->GetMatchingFonts(p, a, b, c)
#define IDWriteFontSet4_GetMatchingFonts1(p, a, b, c, d) (p)->lpVtbl->GetMatchingFonts1(p, a, b, c, d)
#define IDWriteFontSet4_GetFirstFontResources(p, a) (p)->lpVtbl->GetFirstFontResources(p, a)
#define IDWriteFontSet4_GetFilteredFonts__(p, a, b, c) (p)->lpVtbl->GetFilteredFonts__(p, a, b, c)
#define IDWriteFontSet4_GetFilteredFonts_(p, a, b, c, d) (p)->lpVtbl->GetFilteredFonts_(p, a, b, c, d)
#define IDWriteFontSet4_GetFilteredFonts(p, a, b, c, d) (p)->lpVtbl->GetFilteredFonts(p, a, b, c, d)
#define IDWriteFontSet4_GetFilteredFontIndices_(p, a, b, c, d, e, f) (p)->lpVtbl->GetFilteredFontIndices_(p, a, b, c, d, e, f)
#define IDWriteFontSet4_GetFilteredFontIndices(p, a, b, c, d, e, f) (p)->lpVtbl->GetFilteredFontIndices(p, a, b, c, d, e, f)
#define IDWriteFontSet4_GetFontAxisRanges_(p, a, b, c, d) (p)->lpVtbl->GetFontAxisRanges_(p, a, b, c, d)
#define IDWriteFontSet4_GetFontAxisRanges(p, a, b, c) (p)->lpVtbl->GetFontAxisRanges(p, a, b, c)
#define IDWriteFontSet4_GetFontFaceReference1(p, a, b) (p)->lpVtbl->GetFontFaceReference1(p, a, b)
#define IDWriteFontSet4_CreateFontResource(p, a, b) (p)->lpVtbl->CreateFontResource(p, a, b)
#define IDWriteFontSet4_CreateFontFace(p, a, b) (p)->lpVtbl->CreateFontFace(p, a, b)
#define IDWriteFontSet4_GetFontLocality(p, a) (p)->lpVtbl->GetFontLocality(p, a)
#define IDWriteFontSet4_GetExpirationEvent(p, a) (p)->lpVtbl->GetExpirationEvent(p, a)
#define IDWriteFontSet4_GetFontSourceType(p, a) (p)->lpVtbl->GetFontSourceType(p, a)
#define IDWriteFontSet4_GetFontSourceNameLength(p, a) (p)->lpVtbl->GetFontSourceNameLength(p, a)
#define IDWriteFontSet4_GetFontSourceName(p, a, b, c) (p)->lpVtbl->GetFontSourceName(p, a, b, c)
#define IDWriteFontSet4_ConvertWeightStretchStyleToFontAxisValues(p, a, b, c, d, e, f, g) (p)->lpVtbl->ConvertWeightStretchStyleToFontAxisValues(p, a, b, c, d, e, f, g)
#define IDWriteFontSet4_GetMatchingFonts2(p, a, b, c, d, e) (p)->lpVtbl->GetMatchingFonts2(p, a, b, c, d, e)

' ============================================================================
' IDWriteFontFace3
' ============================================================================
Type IDWriteFontFace3_Vtbl As IDWriteFontFace3_Vtbl_
Type IDWriteFontFace3_
    lpVtbl As IDWriteFontFace3_Vtbl Ptr
End Type
Type IDWriteFontFace3_Vtbl_     '' Extends IDWriteFontFace2Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFontFace3_ Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontFace3_ Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontFace3_ Ptr) As ULong
        
    GetType As Function(ByVal This As IDWriteFontFace3_ Ptr) As DWRITE_FONT_FACE_TYPE
        ' 5. GetFiles
    GetFiles As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal number_of_files As ULong Ptr, ByVal fontfiles As Any Ptr Ptr ) As HRESULT
        ' 6. GetIndex
    GetIndex As Function(ByVal This As IDWriteFontFace3_ Ptr) As ULong
        ' 7. GetSimulations
    GetSimulations As Function(ByVal This As IDWriteFontFace3_ Ptr) As DWRITE_FONT_SIMULATIONS
        ' 8. IsSymbolFont
    IsSymbolFont As Function(ByVal This As IDWriteFontFace3_ Ptr) As Long
        ' 9. GetMetrics
    GetMetrics As Sub(ByVal This As IDWriteFontFace3_ Ptr,  ByVal metrics As DWRITE_FONT_METRICS Ptr )
        ' 10. GetGlyphCount
    GetGlyphCount As Function(ByVal This As IDWriteFontFace3_ Ptr) As UShort
        ' 11. GetDesignGlyphMetrics
    GetDesignGlyphMetrics As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal glyph_indices As UShort Ptr, ByVal glyph_count As ULong, ByVal metrics As DWRITE_GLYPH_METRICS Ptr, ByVal is_sideways As Long ) As HRESULT
        ' 12. GetGlyphIndices
    GetGlyphIndices As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal codepoints As ULong Ptr, ByVal count As ULong, ByVal glyph_indices As UShort Ptr ) As HRESULT
        ' 13. TryGetFontTable
    TryGetFontTable As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal table_tag As ULong, ByVal table_data As Any Ptr Ptr, ByVal table_size As ULong Ptr, ByVal context As Any Ptr Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 14. ReleaseFontTable
    ReleaseFontTable As Sub(ByVal This As IDWriteFontFace3_ Ptr,  ByVal table_context As Any Ptr )
        ' 15. GetGlyphRunOutline
    GetGlyphRunOutline As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal emSize As Single, ByVal glyph_indices As UShort Ptr, ByVal glyph_advances As Single Ptr, ByVal glyph_offsets As DWRITE_GLYPH_OFFSET Ptr, ByVal glyph_count As ULong, ByVal is_sideways As Long, ByVal is_rtl As Long, ByVal geometrysink As Any Ptr ) As HRESULT
        ' 16. GetRecommendedRenderingMode
    GetRecommendedRenderingMode As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal mode As DWRITE_MEASURING_MODE, ByVal params As IDWriteRenderingParams Ptr, ByVal rendering_mode As DWRITE_RENDERING_MODE Ptr ) As HRESULT
        ' 17. GetGdiCompatibleMetrics
    GetGdiCompatibleMetrics As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal metrics As DWRITE_FONT_METRICS Ptr ) As HRESULT
        ' 18. GetGdiCompatibleGlyphMetrics
    GetGdiCompatibleGlyphMetrics As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal use_gdi_natural As Long, ByVal glyph_indices As UShort Ptr, ByVal glyph_count As ULong, ByVal metrics As DWRITE_GLYPH_METRICS Ptr, ByVal is_sideways As Long ) As HRESULT
        
    GetMetrics1 As Sub(ByVal This As IDWriteFontFace3_ Ptr,  ByVal metrics As DWRITE_FONT_METRICS1 Ptr )
        ' 20. GetGdiCompatibleMetrics
    GetGdiCompatibleMetrics1 As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal emSize As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal metrics As DWRITE_FONT_METRICS1 Ptr ) As HRESULT
        ' 21. GetCaretMetrics
    GetCaretMetrics As Sub(ByVal This As IDWriteFontFace3_ Ptr,  ByVal metrics As DWRITE_CARET_METRICS Ptr )
        ' 22. GetUnicodeRanges
    GetUnicodeRanges As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal maxCount As ULong, ByVal ranges As DWRITE_UNICODE_RANGE Ptr, ByVal count As ULong Ptr ) As HRESULT
        ' 23. IsMonospacedFont
    IsMonospacedFont As Function(ByVal This As IDWriteFontFace3_ Ptr) As Long
        ' 24. GetDesignGlyphAdvances
    GetDesignGlyphAdvances As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal glyphCount As ULong, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvances As Long Ptr, ByVal isSideways As Long = 0 ) As HRESULT
        ' 25. GetGdiCompatibleGlyphAdvances
    GetGdiCompatibleGlyphAdvances As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal emSize As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal useGdiNatural As Long, ByVal isSideways As Long, ByVal glyphCount As ULong, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvances As Long Ptr ) As HRESULT
        ' 26. GetKerningPairAdjustments
    GetKerningPairAdjustments As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal glyphCount As ULong, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvanceAdjustments As Long Ptr ) As HRESULT
        ' 27. HasKerningPairs
    HasKerningPairs As Function(ByVal This As IDWriteFontFace3_ Ptr) As Long
        ' 28. GetRecommendedRenderingMode
    GetRecommendedRenderingMode1 As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal fontEmSize As Single, ByVal dpiX As Single, ByVal dpiY As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal isSideways As Long, ByVal outlineThreshold As DWRITE_OUTLINE_THRESHOLD, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal renderingMode As DWRITE_RENDERING_MODE Ptr ) As HRESULT
        ' 29. GetVerticalGlyphVariants
    GetVerticalGlyphVariants As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal glyphCount As ULong, ByVal nominalGlyphIndices As UShort Ptr, ByVal verticalGlyphIndices As UShort Ptr ) As HRESULT
        ' 30. HasVerticalGlyphVariants
    HasVerticalGlyphVariants As Function(ByVal This As IDWriteFontFace3_ Ptr) As Long
        
    IsColorFont As Function(ByVal This As IDWriteFontFace3_ Ptr) As Long
        ' 32. GetColorPaletteCount
    GetColorPaletteCount As Function(ByVal This As IDWriteFontFace3_ Ptr) As ULong
        ' 33. GetPaletteEntryCount
    GetPaletteEntryCount As Function(ByVal This As IDWriteFontFace3_ Ptr) As ULong
        ' 34. GetPaletteEntries
    GetPaletteEntries As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal colorPaletteIndex As ULong, ByVal firstEntryIndex As ULong, ByVal entryCount As ULong, ByVal paletteEntries As DWRITE_COLOR_F Ptr ) As HRESULT
        ' 35. GetRecommendedRenderingMode
    GetRecommendedRenderingMode2 As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal fontEmSize As Single, ByVal dpiX As Single, ByVal dpiY As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal isSideways As Long, ByVal outlineThreshold As DWRITE_OUTLINE_THRESHOLD, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal renderingParams As IDWriteRenderingParams Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE Ptr, ByVal gridFitMode As DWRITE_GRID_FIT_MODE Ptr ) As HRESULT

        
    GetFontFaceReference As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 37. GetPanose
    GetPanose As Sub(ByVal This As IDWriteFontFace3_ Ptr,  ByVal panose As DWRITE_PANOSE Ptr )
        ' 38. GetWeight
    GetWeight As Function(ByVal This As IDWriteFontFace3_ Ptr) As DWRITE_FONT_WEIGHT
        ' 39. GetStretch
    GetStretch As Function(ByVal This As IDWriteFontFace3_ Ptr) As DWRITE_FONT_STRETCH
        ' 40. GetStyle
    GetStyle As Function(ByVal This As IDWriteFontFace3_ Ptr) As DWRITE_FONT_STYLE
        ' 41. GetFamilyNames
    GetFamilyNames As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal names As IDWriteLocalizedStrings Ptr Ptr ) As HRESULT
        ' 42. GetFaceNames
    GetFaceNames As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal names As IDWriteLocalizedStrings Ptr Ptr ) As HRESULT
        ' 43. GetInformationalStrings
    GetInformationalStrings As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal informationalStringID As DWRITE_INFORMATIONAL_STRING_ID, ByVal informationalStrings As IDWriteLocalizedStrings Ptr Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 44. HasCharacter
    HasCharacter As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal unicodeValue As ULong ) As Long
        ' 45. GetRecommendedRenderingMode
    GetRecommendedRenderingMode3 As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal fontEmSize As Single, ByVal dpiX As Single, ByVal dpiY As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal isSideways As Long, ByVal outlineThreshold As DWRITE_OUTLINE_THRESHOLD, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal renderingParams As IDWriteRenderingParams Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE1 Ptr, ByVal gridFitMode As DWRITE_GRID_FIT_MODE Ptr ) As HRESULT
        ' 46. IsCharacterLocal
    IsCharacterLocal As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal unicodeValue As ULong ) As Long
        ' 47. IsGlyphLocal
    IsGlyphLocal As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal glyphId As UShort ) As Long
        ' 48. AreCharactersLocal
    AreCharactersLocal As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal characters As WString Ptr, ByVal characterCount As ULong, ByVal enqueueIfNotLocal As Long, ByVal isLocal As Long Ptr ) As HRESULT
        ' 49. AreGlyphsLocal
    AreGlyphsLocal As Function(ByVal This As IDWriteFontFace3_ Ptr,  ByVal glyphIndices As UShort Ptr, ByVal glyphCount As ULong, ByVal enqueueIfNotLocal As Long, ByVal isLocal As Long Ptr ) As HRESULT
End Type
#define IDWriteFontFace3__QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontFace3__AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontFace3__Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontFace3__GetType(p, a) (p)->lpVtbl->GetType(p, a)
#define IDWriteFontFace3__GetFiles(p, a, b) (p)->lpVtbl->GetFiles(p, a, b)
#define IDWriteFontFace3__GetIndex(p, a) (p)->lpVtbl->GetIndex(p, a)
#define IDWriteFontFace3__GetSimulations(p, a) (p)->lpVtbl->GetSimulations(p, a)
#define IDWriteFontFace3__IsSymbolFont(p, a) (p)->lpVtbl->IsSymbolFont(p, a)
#define IDWriteFontFace3__GetMetrics(p, a) (p)->lpVtbl->GetMetrics(p, a)
#define IDWriteFontFace3__GetGlyphCount(p, a) (p)->lpVtbl->GetGlyphCount(p, a)
#define IDWriteFontFace3__GetDesignGlyphMetrics(p, a, b, c, d) (p)->lpVtbl->GetDesignGlyphMetrics(p, a, b, c, d)
#define IDWriteFontFace3__GetGlyphIndices(p, a, b, c) (p)->lpVtbl->GetGlyphIndices(p, a, b, c)
#define IDWriteFontFace3__TryGetFontTable(p, a, b, c, d, e) (p)->lpVtbl->TryGetFontTable(p, a, b, c, d, e)
#define IDWriteFontFace3__ReleaseFontTable(p, a) (p)->lpVtbl->ReleaseFontTable(p, a)
#define IDWriteFontFace3__GetGlyphRunOutline(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGlyphRunOutline(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace3__GetRecommendedRenderingMode(p, a, b, c, d, e) (p)->lpVtbl->GetRecommendedRenderingMode(p, a, b, c, d, e)
#define IDWriteFontFace3__GetGdiCompatibleMetrics(p, a, b, c, d) (p)->lpVtbl->GetGdiCompatibleMetrics(p, a, b, c, d)
#define IDWriteFontFace3__GetGdiCompatibleGlyphMetrics(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGdiCompatibleGlyphMetrics(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace3__GetMetrics1(p, a) (p)->lpVtbl->GetMetrics1(p, a)
#define IDWriteFontFace3__GetGdiCompatibleMetrics1(p, a, b, c, d) (p)->lpVtbl->GetGdiCompatibleMetrics1(p, a, b, c, d)
#define IDWriteFontFace3__GetCaretMetrics(p, a) (p)->lpVtbl->GetCaretMetrics(p, a)
#define IDWriteFontFace3__GetUnicodeRanges(p, a, b, c) (p)->lpVtbl->GetUnicodeRanges(p, a, b, c)
#define IDWriteFontFace3__IsMonospacedFont(p, a) (p)->lpVtbl->IsMonospacedFont(p, a)
#define IDWriteFontFace3__GetDesignGlyphAdvances(p, a, b, c, d) (p)->lpVtbl->GetDesignGlyphAdvances(p, a, b, c, d)
#define IDWriteFontFace3__GetGdiCompatibleGlyphAdvances(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGdiCompatibleGlyphAdvances(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace3__GetKerningPairAdjustments(p, a, b, c) (p)->lpVtbl->GetKerningPairAdjustments(p, a, b, c)
#define IDWriteFontFace3__HasKerningPairs(p, a) (p)->lpVtbl->HasKerningPairs(p, a)
#define IDWriteFontFace3__GetRecommendedRenderingMode1(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetRecommendedRenderingMode1(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace3__GetVerticalGlyphVariants(p, a, b, c) (p)->lpVtbl->GetVerticalGlyphVariants(p, a, b, c)
#define IDWriteFontFace3__HasVerticalGlyphVariants(p, a) (p)->lpVtbl->HasVerticalGlyphVariants(p, a)
#define IDWriteFontFace3__IsColorFont(p, a) (p)->lpVtbl->IsColorFont(p, a)
#define IDWriteFontFace3__GetColorPaletteCount(p, a) (p)->lpVtbl->GetColorPaletteCount(p, a)
#define IDWriteFontFace3__GetPaletteEntryCount(p, a) (p)->lpVtbl->GetPaletteEntryCount(p, a)
#define IDWriteFontFace3__GetPaletteEntries(p, a, b, c, d) (p)->lpVtbl->GetPaletteEntries(p, a, b, c, d)
#define IDWriteFontFace3__GetRecommendedRenderingMode2(p, a, b, c, d, e, f, g, h, i, j) (p)->lpVtbl->GetRecommendedRenderingMode2(p, a, b, c, d, e, f, g, h, i, j)
#define IDWriteFontFace3__GetFontFaceReference(p, a) (p)->lpVtbl->GetFontFaceReference(p, a)
#define IDWriteFontFace3__GetPanose(p, a) (p)->lpVtbl->GetPanose(p, a)
#define IDWriteFontFace3__GetWeight(p, a) (p)->lpVtbl->GetWeight(p, a)
#define IDWriteFontFace3__GetStretch(p, a) (p)->lpVtbl->GetStretch(p, a)
#define IDWriteFontFace3__GetStyle(p, a) (p)->lpVtbl->GetStyle(p, a)
#define IDWriteFontFace3__GetFamilyNames(p, a) (p)->lpVtbl->GetFamilyNames(p, a)
#define IDWriteFontFace3__GetFaceNames(p, a) (p)->lpVtbl->GetFaceNames(p, a)
#define IDWriteFontFace3__GetInformationalStrings(p, a, b, c) (p)->lpVtbl->GetInformationalStrings(p, a, b, c)
#define IDWriteFontFace3__HasCharacter(p, a) (p)->lpVtbl->HasCharacter(p, a)
#define IDWriteFontFace3__GetRecommendedRenderingMode3(p, a, b, c, d, e, f, g, h, i, j) (p)->lpVtbl->GetRecommendedRenderingMode3(p, a, b, c, d, e, f, g, h, i, j)
#define IDWriteFontFace3__IsCharacterLocal(p, a) (p)->lpVtbl->IsCharacterLocal(p, a)
#define IDWriteFontFace3__IsGlyphLocal(p, a) (p)->lpVtbl->IsGlyphLocal(p, a)
#define IDWriteFontFace3__AreCharactersLocal(p, a, b, c, d) (p)->lpVtbl->AreCharactersLocal(p, a, b, c, d)
#define IDWriteFontFace3__AreGlyphsLocal(p, a, b, c, d) (p)->lpVtbl->AreGlyphsLocal(p, a, b, c, d)

' ============================================================================
' IDWriteTextFormat2
' ============================================================================
Type IDWriteTextFormat2Vtbl As IDWriteTextFormat2Vtbl_
Type IDWriteTextFormat2
    lpVtbl As IDWriteTextFormat2Vtbl Ptr
End Type
Type IDWriteTextFormat2Vtbl_     '' Extends IDWriteTextFormat1Vtbl_
    QueryInterface As Function(ByVal This As IDWriteTextFormat2 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteTextFormat2 Ptr) As ULong
    Release As Function(ByVal This As IDWriteTextFormat2 Ptr) As ULong
        
    SetTextAlignment As Function(ByVal This As IDWriteTextFormat2 Ptr,  ByVal textAlignment As DWRITE_TEXT_ALIGNMENT ) As HRESULT
        ' 5. SetParagraphAlignment
    SetParagraphAlignment As Function(ByVal This As IDWriteTextFormat2 Ptr,  ByVal paragraphAlignment As DWRITE_PARAGRAPH_ALIGNMENT ) As HRESULT
        ' 6. SetWordWrapping
    SetWordWrapping As Function(ByVal This As IDWriteTextFormat2 Ptr,  ByVal wordWrapping As DWRITE_WORD_WRAPPING ) As HRESULT
        ' 7. SetReadingDirection
    SetReadingDirection As Function(ByVal This As IDWriteTextFormat2 Ptr,  ByVal readingDirection As DWRITE_READING_DIRECTION ) As HRESULT
        ' 8. SetFlowDirection
    SetFlowDirection As Function(ByVal This As IDWriteTextFormat2 Ptr,  ByVal flowDirection As DWRITE_FLOW_DIRECTION ) As HRESULT
        ' 9. SetIncrementalTabStop
    SetIncrementalTabStop As Function(ByVal This As IDWriteTextFormat2 Ptr,  ByVal incrementalTabStop As Single ) As HRESULT
        ' 10. SetTrimming
    SetTrimming As Function(ByVal This As IDWriteTextFormat2 Ptr,  ByVal trimmingOptions As DWRITE_TRIMMING Ptr, ByVal trimmingSign As Any Ptr ) As HRESULT
        ' 11. SetLineSpacing
    SetLineSpacing As Function(ByVal This As IDWriteTextFormat2 Ptr,  ByVal lineSpacingMethod As DWRITE_LINE_SPACING_METHOD, ByVal lineSpacing As Single, ByVal baseline As Single ) As HRESULT
        ' 12. GetTextAlignment
    GetTextAlignment As Function(ByVal This As IDWriteTextFormat2 Ptr) As DWRITE_TEXT_ALIGNMENT
        ' 13. GetParagraphAlignment
    GetParagraphAlignment As Function(ByVal This As IDWriteTextFormat2 Ptr) As DWRITE_PARAGRAPH_ALIGNMENT
        ' 14. GetWordWrapping
    GetWordWrapping As Function(ByVal This As IDWriteTextFormat2 Ptr) As DWRITE_WORD_WRAPPING
        ' 15. GetReadingDirection
    GetReadingDirection As Function(ByVal This As IDWriteTextFormat2 Ptr) As DWRITE_READING_DIRECTION
        ' 16. GetFlowDirection
    GetFlowDirection As Function(ByVal This As IDWriteTextFormat2 Ptr) As DWRITE_FLOW_DIRECTION
        ' 17. GetIncrementalTabStop
    GetIncrementalTabStop As Function(ByVal This As IDWriteTextFormat2 Ptr) As Single
        ' 18. GetTrimming
    GetTrimming As Function(ByVal This As IDWriteTextFormat2 Ptr,  ByVal trimmingOptions As DWRITE_TRIMMING Ptr, ByVal trimmingSign As Any Ptr Ptr ) As HRESULT
        ' 19. GetLineSpacing
    GetLineSpacing As Function(ByVal This As IDWriteTextFormat2 Ptr,  ByVal lineSpacingMethod As DWRITE_LINE_SPACING_METHOD Ptr, ByVal lineSpacing As Single Ptr, ByVal baseline As Single Ptr ) As HRESULT
        ' 20. GetFontCollection
    GetFontCollection As Function(ByVal This As IDWriteTextFormat2 Ptr,  ByVal fontCollection As Any Ptr Ptr ) As HRESULT
        ' 21. GetFontFamilyNameLength
    GetFontFamilyNameLength As Function(ByVal This As IDWriteTextFormat2 Ptr) As ULong
        ' 22. GetFontFamilyName
    GetFontFamilyName As Function(ByVal This As IDWriteTextFormat2 Ptr,  ByVal fontFamilyName As WString Ptr, ByVal nameSize As ULong ) As HRESULT
        ' 23. GetFontWeight
    GetFontWeight As Function(ByVal This As IDWriteTextFormat2 Ptr) As DWRITE_FONT_WEIGHT
        ' 24. GetFontStyle
    GetFontStyle As Function(ByVal This As IDWriteTextFormat2 Ptr) As DWRITE_FONT_STYLE
        ' 25. GetFontStretch
    GetFontStretch As Function(ByVal This As IDWriteTextFormat2 Ptr) As DWRITE_FONT_STRETCH
        ' 26. GetFontSize
    GetFontSize As Function(ByVal This As IDWriteTextFormat2 Ptr) As Single
        ' 27. GetLocaleNameLength
    GetLocaleNameLength As Function(ByVal This As IDWriteTextFormat2 Ptr) As ULong
        ' 28. GetLocaleName
    GetLocaleName As Function(ByVal This As IDWriteTextFormat2 Ptr,  ByVal localeName As WString Ptr, ByVal nameSize As ULong ) As HRESULT
        
    SetVerticalGlyphOrientation As Function(ByVal This As IDWriteTextFormat2 Ptr,  ByVal glyphOrientation As DWRITE_VERTICAL_GLYPH_ORIENTATION ) As HRESULT
        ' 30. GetVerticalGlyphOrientation
    GetVerticalGlyphOrientation As Function(ByVal This As IDWriteTextFormat2 Ptr) As DWRITE_VERTICAL_GLYPH_ORIENTATION
        ' 31. SetLastLineWrapping
    SetLastLineWrapping As Function(ByVal This As IDWriteTextFormat2 Ptr,  ByVal isLastLineWrappingEnabled As Long ) As HRESULT
        ' 32. GetLastLineWrapping
    GetLastLineWrapping As Function(ByVal This As IDWriteTextFormat2 Ptr) As Long
        ' 33. SetOpticalAlignment
    SetOpticalAlignment As Function(ByVal This As IDWriteTextFormat2 Ptr,  ByVal opticalAlignment As DWRITE_OPTICAL_ALIGNMENT ) As HRESULT
        ' 34. GetOpticalAlignment
    GetOpticalAlignment As Function(ByVal This As IDWriteTextFormat2 Ptr) As DWRITE_OPTICAL_ALIGNMENT
        ' 35. SetFontFallback
    SetFontFallback As Function(ByVal This As IDWriteTextFormat2 Ptr,  ByVal fontFallback As IDWriteFontFallback Ptr ) As HRESULT
        ' 36. GetFontFallback
    GetFontFallback As Function(ByVal This As IDWriteTextFormat2 Ptr,  ByVal fontFallback As IDWriteFontFallback Ptr Ptr ) As HRESULT

        
    SetLineSpacing1 As Function(ByVal This As IDWriteTextFormat2 Ptr,  ByVal lineSpacingOptions As DWRITE_LINE_SPACING Ptr ) As HRESULT
        ' 38. GetLineSpacing
    GetLineSpacing1 As Function(ByVal This As IDWriteTextFormat2 Ptr,  ByVal lineSpacingOptions As DWRITE_LINE_SPACING Ptr ) As HRESULT
End Type
#define IDWriteTextFormat2_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteTextFormat2_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteTextFormat2_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteTextFormat2_SetTextAlignment(p, a) (p)->lpVtbl->SetTextAlignment(p, a)
#define IDWriteTextFormat2_SetParagraphAlignment(p, a) (p)->lpVtbl->SetParagraphAlignment(p, a)
#define IDWriteTextFormat2_SetWordWrapping(p, a) (p)->lpVtbl->SetWordWrapping(p, a)
#define IDWriteTextFormat2_SetReadingDirection(p, a) (p)->lpVtbl->SetReadingDirection(p, a)
#define IDWriteTextFormat2_SetFlowDirection(p, a) (p)->lpVtbl->SetFlowDirection(p, a)
#define IDWriteTextFormat2_SetIncrementalTabStop(p, a) (p)->lpVtbl->SetIncrementalTabStop(p, a)
#define IDWriteTextFormat2_SetTrimming(p, a, b) (p)->lpVtbl->SetTrimming(p, a, b)
#define IDWriteTextFormat2_SetLineSpacing(p, a, b, c) (p)->lpVtbl->SetLineSpacing(p, a, b, c)
#define IDWriteTextFormat2_GetTextAlignment(p, a) (p)->lpVtbl->GetTextAlignment(p, a)
#define IDWriteTextFormat2_GetParagraphAlignment(p, a) (p)->lpVtbl->GetParagraphAlignment(p, a)
#define IDWriteTextFormat2_GetWordWrapping(p, a) (p)->lpVtbl->GetWordWrapping(p, a)
#define IDWriteTextFormat2_GetReadingDirection(p, a) (p)->lpVtbl->GetReadingDirection(p, a)
#define IDWriteTextFormat2_GetFlowDirection(p, a) (p)->lpVtbl->GetFlowDirection(p, a)
#define IDWriteTextFormat2_GetIncrementalTabStop(p, a) (p)->lpVtbl->GetIncrementalTabStop(p, a)
#define IDWriteTextFormat2_GetTrimming(p, a, b) (p)->lpVtbl->GetTrimming(p, a, b)
#define IDWriteTextFormat2_GetLineSpacing(p, a, b, c) (p)->lpVtbl->GetLineSpacing(p, a, b, c)
#define IDWriteTextFormat2_GetFontCollection(p, a) (p)->lpVtbl->GetFontCollection(p, a)
#define IDWriteTextFormat2_GetFontFamilyNameLength(p, a) (p)->lpVtbl->GetFontFamilyNameLength(p, a)
#define IDWriteTextFormat2_GetFontFamilyName(p, a, b) (p)->lpVtbl->GetFontFamilyName(p, a, b)
#define IDWriteTextFormat2_GetFontWeight(p, a) (p)->lpVtbl->GetFontWeight(p, a)
#define IDWriteTextFormat2_GetFontStyle(p, a) (p)->lpVtbl->GetFontStyle(p, a)
#define IDWriteTextFormat2_GetFontStretch(p, a) (p)->lpVtbl->GetFontStretch(p, a)
#define IDWriteTextFormat2_GetFontSize(p, a) (p)->lpVtbl->GetFontSize(p, a)
#define IDWriteTextFormat2_GetLocaleNameLength(p, a) (p)->lpVtbl->GetLocaleNameLength(p, a)
#define IDWriteTextFormat2_GetLocaleName(p, a, b) (p)->lpVtbl->GetLocaleName(p, a, b)
#define IDWriteTextFormat2_SetVerticalGlyphOrientation(p, a) (p)->lpVtbl->SetVerticalGlyphOrientation(p, a)
#define IDWriteTextFormat2_GetVerticalGlyphOrientation(p, a) (p)->lpVtbl->GetVerticalGlyphOrientation(p, a)
#define IDWriteTextFormat2_SetLastLineWrapping(p, a) (p)->lpVtbl->SetLastLineWrapping(p, a)
#define IDWriteTextFormat2_GetLastLineWrapping(p, a) (p)->lpVtbl->GetLastLineWrapping(p, a)
#define IDWriteTextFormat2_SetOpticalAlignment(p, a) (p)->lpVtbl->SetOpticalAlignment(p, a)
#define IDWriteTextFormat2_GetOpticalAlignment(p, a) (p)->lpVtbl->GetOpticalAlignment(p, a)
#define IDWriteTextFormat2_SetFontFallback(p, a) (p)->lpVtbl->SetFontFallback(p, a)
#define IDWriteTextFormat2_GetFontFallback(p, a) (p)->lpVtbl->GetFontFallback(p, a)
#define IDWriteTextFormat2_SetLineSpacing1(p, a) (p)->lpVtbl->SetLineSpacing1(p, a)
#define IDWriteTextFormat2_GetLineSpacing1(p, a) (p)->lpVtbl->GetLineSpacing1(p, a)

' ============================================================================
' IDWriteTextFormat3
' ============================================================================
Type IDWriteTextFormat3Vtbl As IDWriteTextFormat3Vtbl_
Type IDWriteTextFormat3
    lpVtbl As IDWriteTextFormat3Vtbl Ptr
End Type
Type IDWriteTextFormat3Vtbl_     '' Extends IDWriteTextFormat2Vtbl_
    QueryInterface As Function(ByVal This As IDWriteTextFormat3 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteTextFormat3 Ptr) As ULong
    Release As Function(ByVal This As IDWriteTextFormat3 Ptr) As ULong
        
    SetTextAlignment As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal textAlignment As DWRITE_TEXT_ALIGNMENT ) As HRESULT
        ' 5. SetParagraphAlignment
    SetParagraphAlignment As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal paragraphAlignment As DWRITE_PARAGRAPH_ALIGNMENT ) As HRESULT
        ' 6. SetWordWrapping
    SetWordWrapping As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal wordWrapping As DWRITE_WORD_WRAPPING ) As HRESULT
        ' 7. SetReadingDirection
    SetReadingDirection As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal readingDirection As DWRITE_READING_DIRECTION ) As HRESULT
        ' 8. SetFlowDirection
    SetFlowDirection As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal flowDirection As DWRITE_FLOW_DIRECTION ) As HRESULT
        ' 9. SetIncrementalTabStop
    SetIncrementalTabStop As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal incrementalTabStop As Single ) As HRESULT
        ' 10. SetTrimming
    SetTrimming As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal trimmingOptions As DWRITE_TRIMMING Ptr, ByVal trimmingSign As Any Ptr ) As HRESULT
        ' 11. SetLineSpacing
    SetLineSpacing As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal lineSpacingMethod As DWRITE_LINE_SPACING_METHOD, ByVal lineSpacing As Single, ByVal baseline As Single ) As HRESULT
        ' 12. GetTextAlignment
    GetTextAlignment As Function(ByVal This As IDWriteTextFormat3 Ptr) As DWRITE_TEXT_ALIGNMENT
        ' 13. GetParagraphAlignment
    GetParagraphAlignment As Function(ByVal This As IDWriteTextFormat3 Ptr) As DWRITE_PARAGRAPH_ALIGNMENT
        ' 14. GetWordWrapping
    GetWordWrapping As Function(ByVal This As IDWriteTextFormat3 Ptr) As DWRITE_WORD_WRAPPING
        ' 15. GetReadingDirection
    GetReadingDirection As Function(ByVal This As IDWriteTextFormat3 Ptr) As DWRITE_READING_DIRECTION
        ' 16. GetFlowDirection
    GetFlowDirection As Function(ByVal This As IDWriteTextFormat3 Ptr) As DWRITE_FLOW_DIRECTION
        ' 17. GetIncrementalTabStop
    GetIncrementalTabStop As Function(ByVal This As IDWriteTextFormat3 Ptr) As Single
        ' 18. GetTrimming
    GetTrimming As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal trimmingOptions As DWRITE_TRIMMING Ptr, ByVal trimmingSign As Any Ptr Ptr ) As HRESULT
        ' 19. GetLineSpacing
    GetLineSpacing As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal lineSpacingMethod As DWRITE_LINE_SPACING_METHOD Ptr, ByVal lineSpacing As Single Ptr, ByVal baseline As Single Ptr ) As HRESULT
        ' 20. GetFontCollection
    GetFontCollection As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal fontCollection As Any Ptr Ptr ) As HRESULT
        ' 21. GetFontFamilyNameLength
    GetFontFamilyNameLength As Function(ByVal This As IDWriteTextFormat3 Ptr) As ULong
        ' 22. GetFontFamilyName
    GetFontFamilyName As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal fontFamilyName As WString Ptr, ByVal nameSize As ULong ) As HRESULT
        ' 23. GetFontWeight
    GetFontWeight As Function(ByVal This As IDWriteTextFormat3 Ptr) As DWRITE_FONT_WEIGHT
        ' 24. GetFontStyle
    GetFontStyle As Function(ByVal This As IDWriteTextFormat3 Ptr) As DWRITE_FONT_STYLE
        ' 25. GetFontStretch
    GetFontStretch As Function(ByVal This As IDWriteTextFormat3 Ptr) As DWRITE_FONT_STRETCH
        ' 26. GetFontSize
    GetFontSize As Function(ByVal This As IDWriteTextFormat3 Ptr) As Single
        ' 27. GetLocaleNameLength
    GetLocaleNameLength As Function(ByVal This As IDWriteTextFormat3 Ptr) As ULong
        ' 28. GetLocaleName
    GetLocaleName As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal localeName As WString Ptr, ByVal nameSize As ULong ) As HRESULT
        
    SetVerticalGlyphOrientation As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal glyphOrientation As DWRITE_VERTICAL_GLYPH_ORIENTATION ) As HRESULT
        ' 30. GetVerticalGlyphOrientation
    GetVerticalGlyphOrientation As Function(ByVal This As IDWriteTextFormat3 Ptr) As DWRITE_VERTICAL_GLYPH_ORIENTATION
        ' 31. SetLastLineWrapping
    SetLastLineWrapping As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal isLastLineWrappingEnabled As Long ) As HRESULT
        ' 32. GetLastLineWrapping
    GetLastLineWrapping As Function(ByVal This As IDWriteTextFormat3 Ptr) As Long
        ' 33. SetOpticalAlignment
    SetOpticalAlignment As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal opticalAlignment As DWRITE_OPTICAL_ALIGNMENT ) As HRESULT
        ' 34. GetOpticalAlignment
    GetOpticalAlignment As Function(ByVal This As IDWriteTextFormat3 Ptr) As DWRITE_OPTICAL_ALIGNMENT
        ' 35. SetFontFallback
    SetFontFallback As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal fontFallback As IDWriteFontFallback Ptr ) As HRESULT
        ' 36. GetFontFallback
    GetFontFallback As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal fontFallback As IDWriteFontFallback Ptr Ptr ) As HRESULT
        
    SetLineSpacing1 As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal lineSpacingOptions As DWRITE_LINE_SPACING Ptr ) As HRESULT
        ' 38. GetLineSpacing
    GetLineSpacing1 As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal lineSpacingOptions As DWRITE_LINE_SPACING Ptr ) As HRESULT

        
    SetFontAxisValues As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong ) As HRESULT
        ' 40. GetFontAxisValueCount
    GetFontAxisValueCount As Function(ByVal This As IDWriteTextFormat3 Ptr) As ULong
        ' 41. GetFontAxisValues
    GetFontAxisValues As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong ) As HRESULT
        ' 42. GetAutomaticFontAxes
    GetAutomaticFontAxes As Function(ByVal This As IDWriteTextFormat3 Ptr) As DWRITE_AUTOMATIC_FONT_AXES
        ' 43. SetAutomaticFontAxes
    SetAutomaticFontAxes As Function(ByVal This As IDWriteTextFormat3 Ptr,  ByVal automaticFontAxes As DWRITE_AUTOMATIC_FONT_AXES ) As HRESULT
End Type
#define IDWriteTextFormat3_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteTextFormat3_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteTextFormat3_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteTextFormat3_SetTextAlignment(p, a) (p)->lpVtbl->SetTextAlignment(p, a)
#define IDWriteTextFormat3_SetParagraphAlignment(p, a) (p)->lpVtbl->SetParagraphAlignment(p, a)
#define IDWriteTextFormat3_SetWordWrapping(p, a) (p)->lpVtbl->SetWordWrapping(p, a)
#define IDWriteTextFormat3_SetReadingDirection(p, a) (p)->lpVtbl->SetReadingDirection(p, a)
#define IDWriteTextFormat3_SetFlowDirection(p, a) (p)->lpVtbl->SetFlowDirection(p, a)
#define IDWriteTextFormat3_SetIncrementalTabStop(p, a) (p)->lpVtbl->SetIncrementalTabStop(p, a)
#define IDWriteTextFormat3_SetTrimming(p, a, b) (p)->lpVtbl->SetTrimming(p, a, b)
#define IDWriteTextFormat3_SetLineSpacing(p, a, b, c) (p)->lpVtbl->SetLineSpacing(p, a, b, c)
#define IDWriteTextFormat3_GetTextAlignment(p, a) (p)->lpVtbl->GetTextAlignment(p, a)
#define IDWriteTextFormat3_GetParagraphAlignment(p, a) (p)->lpVtbl->GetParagraphAlignment(p, a)
#define IDWriteTextFormat3_GetWordWrapping(p, a) (p)->lpVtbl->GetWordWrapping(p, a)
#define IDWriteTextFormat3_GetReadingDirection(p, a) (p)->lpVtbl->GetReadingDirection(p, a)
#define IDWriteTextFormat3_GetFlowDirection(p, a) (p)->lpVtbl->GetFlowDirection(p, a)
#define IDWriteTextFormat3_GetIncrementalTabStop(p, a) (p)->lpVtbl->GetIncrementalTabStop(p, a)
#define IDWriteTextFormat3_GetTrimming(p, a, b) (p)->lpVtbl->GetTrimming(p, a, b)
#define IDWriteTextFormat3_GetLineSpacing(p, a, b, c) (p)->lpVtbl->GetLineSpacing(p, a, b, c)
#define IDWriteTextFormat3_GetFontCollection(p, a) (p)->lpVtbl->GetFontCollection(p, a)
#define IDWriteTextFormat3_GetFontFamilyNameLength(p, a) (p)->lpVtbl->GetFontFamilyNameLength(p, a)
#define IDWriteTextFormat3_GetFontFamilyName(p, a, b) (p)->lpVtbl->GetFontFamilyName(p, a, b)
#define IDWriteTextFormat3_GetFontWeight(p, a) (p)->lpVtbl->GetFontWeight(p, a)
#define IDWriteTextFormat3_GetFontStyle(p, a) (p)->lpVtbl->GetFontStyle(p, a)
#define IDWriteTextFormat3_GetFontStretch(p, a) (p)->lpVtbl->GetFontStretch(p, a)
#define IDWriteTextFormat3_GetFontSize(p, a) (p)->lpVtbl->GetFontSize(p, a)
#define IDWriteTextFormat3_GetLocaleNameLength(p, a) (p)->lpVtbl->GetLocaleNameLength(p, a)
#define IDWriteTextFormat3_GetLocaleName(p, a, b) (p)->lpVtbl->GetLocaleName(p, a, b)
#define IDWriteTextFormat3_SetVerticalGlyphOrientation(p, a) (p)->lpVtbl->SetVerticalGlyphOrientation(p, a)
#define IDWriteTextFormat3_GetVerticalGlyphOrientation(p, a) (p)->lpVtbl->GetVerticalGlyphOrientation(p, a)
#define IDWriteTextFormat3_SetLastLineWrapping(p, a) (p)->lpVtbl->SetLastLineWrapping(p, a)
#define IDWriteTextFormat3_GetLastLineWrapping(p, a) (p)->lpVtbl->GetLastLineWrapping(p, a)
#define IDWriteTextFormat3_SetOpticalAlignment(p, a) (p)->lpVtbl->SetOpticalAlignment(p, a)
#define IDWriteTextFormat3_GetOpticalAlignment(p, a) (p)->lpVtbl->GetOpticalAlignment(p, a)
#define IDWriteTextFormat3_SetFontFallback(p, a) (p)->lpVtbl->SetFontFallback(p, a)
#define IDWriteTextFormat3_GetFontFallback(p, a) (p)->lpVtbl->GetFontFallback(p, a)
#define IDWriteTextFormat3_SetLineSpacing1(p, a) (p)->lpVtbl->SetLineSpacing1(p, a)
#define IDWriteTextFormat3_GetLineSpacing1(p, a) (p)->lpVtbl->GetLineSpacing1(p, a)
#define IDWriteTextFormat3_SetFontAxisValues(p, a, b) (p)->lpVtbl->SetFontAxisValues(p, a, b)
#define IDWriteTextFormat3_GetFontAxisValueCount(p, a) (p)->lpVtbl->GetFontAxisValueCount(p, a)
#define IDWriteTextFormat3_GetFontAxisValues(p, a, b) (p)->lpVtbl->GetFontAxisValues(p, a, b)
#define IDWriteTextFormat3_GetAutomaticFontAxes(p, a) (p)->lpVtbl->GetAutomaticFontAxes(p, a)
#define IDWriteTextFormat3_SetAutomaticFontAxes(p, a) (p)->lpVtbl->SetAutomaticFontAxes(p, a)

' ============================================================================
' IDWriteTextLayout3
' ============================================================================
Type IDWriteTextLayout3Vtbl As IDWriteTextLayout3Vtbl_
Type IDWriteTextLayout3
    lpVtbl As IDWriteTextLayout3Vtbl Ptr
End Type
Type IDWriteTextLayout3Vtbl_     '' Extends IDWriteTextLayout2Vtbl_
    QueryInterface As Function(ByVal This As IDWriteTextLayout3 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteTextLayout3 Ptr) As ULong
    Release As Function(ByVal This As IDWriteTextLayout3 Ptr) As ULong
        
    SetTextAlignment As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal textAlignment As DWRITE_TEXT_ALIGNMENT ) As HRESULT
        ' 5. SetParagraphAlignment
    SetParagraphAlignment As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal paragraphAlignment As DWRITE_PARAGRAPH_ALIGNMENT ) As HRESULT
        ' 6. SetWordWrapping
    SetWordWrapping As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal wordWrapping As DWRITE_WORD_WRAPPING ) As HRESULT
        ' 7. SetReadingDirection
    SetReadingDirection As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal readingDirection As DWRITE_READING_DIRECTION ) As HRESULT
        ' 8. SetFlowDirection
    SetFlowDirection As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal flowDirection As DWRITE_FLOW_DIRECTION ) As HRESULT
        ' 9. SetIncrementalTabStop
    SetIncrementalTabStop As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal incrementalTabStop As Single ) As HRESULT
        ' 10. SetTrimming
    SetTrimming As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal trimmingOptions As DWRITE_TRIMMING Ptr, ByVal trimmingSign As Any Ptr ) As HRESULT
        ' 11. SetLineSpacing
    SetLineSpacing As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal lineSpacingMethod As DWRITE_LINE_SPACING_METHOD, ByVal lineSpacing As Single, ByVal baseline As Single ) As HRESULT
        ' 12. GetTextAlignment
    GetTextAlignment As Function(ByVal This As IDWriteTextLayout3 Ptr) As DWRITE_TEXT_ALIGNMENT
        ' 13. GetParagraphAlignment
    GetParagraphAlignment As Function(ByVal This As IDWriteTextLayout3 Ptr) As DWRITE_PARAGRAPH_ALIGNMENT
        ' 14. GetWordWrapping
    GetWordWrapping As Function(ByVal This As IDWriteTextLayout3 Ptr) As DWRITE_WORD_WRAPPING
        ' 15. GetReadingDirection
    GetReadingDirection As Function(ByVal This As IDWriteTextLayout3 Ptr) As DWRITE_READING_DIRECTION
        ' 16. GetFlowDirection
    GetFlowDirection As Function(ByVal This As IDWriteTextLayout3 Ptr) As DWRITE_FLOW_DIRECTION
        ' 17. GetIncrementalTabStop
    GetIncrementalTabStop As Function(ByVal This As IDWriteTextLayout3 Ptr) As Single
        ' 18. GetTrimming
    GetTrimming As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal trimmingOptions As DWRITE_TRIMMING Ptr, ByVal trimmingSign As Any Ptr Ptr ) As HRESULT
        ' 19. GetLineSpacing
    GetLineSpacing As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal lineSpacingMethod As DWRITE_LINE_SPACING_METHOD Ptr, ByVal lineSpacing As Single Ptr, ByVal baseline As Single Ptr ) As HRESULT
        ' 20. GetFontCollection
    GetFontCollection As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal fontCollection As Any Ptr Ptr ) As HRESULT
        ' 21. GetFontFamilyNameLength
    GetFontFamilyNameLength As Function(ByVal This As IDWriteTextLayout3 Ptr) As ULong
        ' 22. GetFontFamilyName
    GetFontFamilyName As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal fontFamilyName As WString Ptr, ByVal nameSize As ULong ) As HRESULT
        ' 23. GetFontWeight
    GetFontWeight As Function(ByVal This As IDWriteTextLayout3 Ptr) As DWRITE_FONT_WEIGHT
        ' 24. GetFontStyle
    GetFontStyle As Function(ByVal This As IDWriteTextLayout3 Ptr) As DWRITE_FONT_STYLE
        ' 25. GetFontStretch
    GetFontStretch As Function(ByVal This As IDWriteTextLayout3 Ptr) As DWRITE_FONT_STRETCH
        ' 26. GetFontSize
    GetFontSize As Function(ByVal This As IDWriteTextLayout3 Ptr) As Single
        ' 27. GetLocaleNameLength
    GetLocaleNameLength As Function(ByVal This As IDWriteTextLayout3 Ptr) As ULong
        ' 28. GetLocaleName
    GetLocaleName As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal localeName As WString Ptr, ByVal nameSize As ULong ) As HRESULT
        
    SetMaxWidth As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal maxWidth As Single ) As HRESULT
        ' 30. SetMaxHeight
    SetMaxHeight As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal maxHeight As Single ) As HRESULT
        ' 31. SetFontCollection
    SetFontCollection As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal fontCollection As Any Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 32. SetFontFamilyName
    SetFontFamilyName As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal fontFamilyName As WString Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 33. SetFontWeight
    SetFontWeight As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal fontWeight As DWRITE_FONT_WEIGHT, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 34. SetFontStyle
    SetFontStyle As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal fontStyle As DWRITE_FONT_STYLE, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 35. SetFontStretch
    SetFontStretch As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal fontStretch As DWRITE_FONT_STRETCH, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 36. SetFontSize
    SetFontSize As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal fontSize As Single, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 37. SetUnderline
    SetUnderline As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal hasUnderline As Long, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 38. SetStrikethrough
    SetStrikethrough As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal hasStrikethrough As Long, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 39. SetDrawingEffect
    SetDrawingEffect As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal drawingEffect As IUnknown Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 40. SetInlineObject
    SetInlineObject As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal inlineObject As Any Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 41. SetTypography
    SetTypography As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal typography As Any Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 42. SetLocaleName
    SetLocaleName As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal localeName As WString Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 43. GetMaxWidth
    GetMaxWidth As Function(ByVal This As IDWriteTextLayout3 Ptr) As Single
        ' 44. GetMaxHeight
    GetMaxHeight As Function(ByVal This As IDWriteTextLayout3 Ptr) As Single
        ' 45. GetFontCollection
    GetFontCollection1 As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal currentPosition As ULong, ByVal fontCollection As Any Ptr Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 46. GetFontFamilyNameLength
    GetFontFamilyNameLength1 As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal currentPosition As ULong, ByVal nameLength As ULong Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 47. GetFontFamilyName
    GetFontFamilyName1 As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal currentPosition As ULong, ByVal fontFamilyName As WString Ptr, ByVal nameSize As ULong, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 48. GetFontWeight
    GetFontWeight1 As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal currentPosition As ULong, ByVal fontWeight As DWRITE_FONT_WEIGHT Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 49. GetFontStyle
    GetFontStyle1 As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal currentPosition As ULong, ByVal fontStyle As DWRITE_FONT_STYLE Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 50. GetFontStretch
    GetFontStretch1 As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal currentPosition As ULong, ByVal fontStretch As DWRITE_FONT_STRETCH Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 51. GetFontSize
    GetFontSize1 As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal currentPosition As ULong, ByVal fontSize As Single Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 52. GetUnderline
    GetUnderline As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal currentPosition As ULong, ByVal hasUnderline As Long Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 53. GetStrikethrough
    GetStrikethrough As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal currentPosition As ULong, ByVal hasStrikethrough As Long Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 54. GetDrawingEffect
    GetDrawingEffect As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal currentPosition As ULong, ByVal drawingEffect As IUnknown Ptr Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 55. GetInlineObject
    GetInlineObject As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal currentPosition As ULong, ByVal inlineObject As Any Ptr Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 56. GetTypography
    GetTypography As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal currentPosition As ULong, ByVal typography As Any Ptr Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 57. GetLocaleNameLength
    GetLocaleNameLength1 As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal currentPosition As ULong, ByVal nameLength As ULong Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 58. GetLocaleName
    GetLocaleName1 As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal currentPosition As ULong, ByVal localeName As WString Ptr, ByVal nameSize As ULong, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 59. Draw
    Draw As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal renderer As Any Ptr, ByVal originX As Single, ByVal originY As Single ) As HRESULT
        ' 60. GetLineMetrics
    GetLineMetrics As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal lineMetrics As DWRITE_LINE_METRICS Ptr, ByVal maxLineCount As ULong, ByVal actualLineCount As ULong Ptr ) As HRESULT
        ' 61. GetMetrics
    GetMetrics As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal textMetrics As DWRITE_TEXT_METRICS Ptr ) As HRESULT
        ' 62. GetOverhangMetrics
    GetOverhangMetrics As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal overhangs As DWRITE_OVERHANG_METRICS Ptr ) As HRESULT
        ' 63. GetClusterMetrics
    GetClusterMetrics As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal clusterMetrics As DWRITE_CLUSTER_METRICS Ptr, ByVal maxClusterCount As ULong, ByVal actualClusterCount As ULong Ptr ) As HRESULT
        ' 64. DetermineMinWidth
    DetermineMinWidth As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal minWidth As Single Ptr ) As HRESULT
        ' 65. HitTestPoint
    HitTestPoint As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal pointX As Single, ByVal pointY As Single, ByVal isTrailingHit As Long Ptr, ByVal isInside As Long Ptr, ByVal hitTestMetrics As DWRITE_HIT_TEST_METRICS Ptr ) As HRESULT
        ' 66. HitTestTextPosition
    HitTestTextPosition As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal textPosition As ULong, ByVal isTrailingHit As Long, ByVal pointX As Single Ptr, ByVal pointY As Single Ptr, ByVal hitTestMetrics As DWRITE_HIT_TEST_METRICS Ptr ) As HRESULT
        ' 67. HitTestTextRange
    HitTestTextRange As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal textPosition As ULong, ByVal textLength As ULong, ByVal originX As Single, ByVal originY As Single, ByVal hitTestMetrics As DWRITE_HIT_TEST_METRICS Ptr, ByVal maxHitTestMetricsCount As ULong, ByVal actualHitTestMetricsCount As ULong Ptr ) As HRESULT
        
    SetPairKerning As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal isPairKerningEnabled As Long, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 69. GetPairKerning
    GetPairKerning As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal currentPosition As ULong, ByVal isPairKerningEnabled As Long Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 70. SetCharacterSpacing
    SetCharacterSpacing As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal leadingSpacing As Single, ByVal trailingSpacing As Single, ByVal minimumAdvanceWidth As Single, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 71. GetCharacterSpacing
    GetCharacterSpacing As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal currentPosition As ULong, ByVal leadingSpacing As Single Ptr, ByVal trailingSpacing As Single Ptr, ByVal minimumAdvanceWidth As Single Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        
    GetMetrics1 As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal textMetrics As DWRITE_TEXT_METRICS1 Ptr ) As HRESULT
        ' 73. SetVerticalGlyphOrientation
    SetVerticalGlyphOrientation As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal glyphOrientation As DWRITE_VERTICAL_GLYPH_ORIENTATION ) As HRESULT
        ' 74. GetVerticalGlyphOrientation
    GetVerticalGlyphOrientation As Function(ByVal This As IDWriteTextLayout3 Ptr) As DWRITE_VERTICAL_GLYPH_ORIENTATION
        ' 75. SetLastLineWrapping
    SetLastLineWrapping As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal isLastLineWrappingEnabled As Long ) As HRESULT
        ' 76. GetLastLineWrapping
    GetLastLineWrapping As Function(ByVal This As IDWriteTextLayout3 Ptr) As Long
        ' 77. SetOpticalAlignment
    SetOpticalAlignment As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal opticalAlignment As DWRITE_OPTICAL_ALIGNMENT ) As HRESULT
        ' 78. GetOpticalAlignment
    GetOpticalAlignment As Function(ByVal This As IDWriteTextLayout3 Ptr) As DWRITE_OPTICAL_ALIGNMENT
        ' 79. SetFontFallback
    SetFontFallback As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal fontFallback As IDWriteFontFallback Ptr ) As HRESULT
        ' 80. GetFontFallback
    GetFontFallback As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal fontFallback As IDWriteFontFallback Ptr Ptr ) As HRESULT

        
    InvalidateLayout As Function(ByVal This As IDWriteTextLayout3 Ptr) As HRESULT
        ' 82. SetLineSpacing
    SetLineSpacing1 As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal lineSpacingOptions As DWRITE_LINE_SPACING Ptr ) As HRESULT
        ' 83. GetLineSpacing
    GetLineSpacing1 As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal lineSpacingOptions As DWRITE_LINE_SPACING Ptr ) As HRESULT
        ' 84. GetLineMetrics
    GetLineMetrics1 As Function(ByVal This As IDWriteTextLayout3 Ptr,  ByVal lineMetrics As DWRITE_LINE_METRICS1 Ptr, ByVal maxLineCount As ULong, ByVal actualLineCount As ULong Ptr ) As HRESULT
End Type
#define IDWriteTextLayout3_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteTextLayout3_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteTextLayout3_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteTextLayout3_SetTextAlignment(p, a) (p)->lpVtbl->SetTextAlignment(p, a)
#define IDWriteTextLayout3_SetParagraphAlignment(p, a) (p)->lpVtbl->SetParagraphAlignment(p, a)
#define IDWriteTextLayout3_SetWordWrapping(p, a) (p)->lpVtbl->SetWordWrapping(p, a)
#define IDWriteTextLayout3_SetReadingDirection(p, a) (p)->lpVtbl->SetReadingDirection(p, a)
#define IDWriteTextLayout3_SetFlowDirection(p, a) (p)->lpVtbl->SetFlowDirection(p, a)
#define IDWriteTextLayout3_SetIncrementalTabStop(p, a) (p)->lpVtbl->SetIncrementalTabStop(p, a)
#define IDWriteTextLayout3_SetTrimming(p, a, b) (p)->lpVtbl->SetTrimming(p, a, b)
#define IDWriteTextLayout3_SetLineSpacing(p, a, b, c) (p)->lpVtbl->SetLineSpacing(p, a, b, c)
#define IDWriteTextLayout3_GetTextAlignment(p, a) (p)->lpVtbl->GetTextAlignment(p, a)
#define IDWriteTextLayout3_GetParagraphAlignment(p, a) (p)->lpVtbl->GetParagraphAlignment(p, a)
#define IDWriteTextLayout3_GetWordWrapping(p, a) (p)->lpVtbl->GetWordWrapping(p, a)
#define IDWriteTextLayout3_GetReadingDirection(p, a) (p)->lpVtbl->GetReadingDirection(p, a)
#define IDWriteTextLayout3_GetFlowDirection(p, a) (p)->lpVtbl->GetFlowDirection(p, a)
#define IDWriteTextLayout3_GetIncrementalTabStop(p, a) (p)->lpVtbl->GetIncrementalTabStop(p, a)
#define IDWriteTextLayout3_GetTrimming(p, a, b) (p)->lpVtbl->GetTrimming(p, a, b)
#define IDWriteTextLayout3_GetLineSpacing(p, a, b, c) (p)->lpVtbl->GetLineSpacing(p, a, b, c)
#define IDWriteTextLayout3_GetFontCollection(p, a) (p)->lpVtbl->GetFontCollection(p, a)
#define IDWriteTextLayout3_GetFontFamilyNameLength(p, a) (p)->lpVtbl->GetFontFamilyNameLength(p, a)
#define IDWriteTextLayout3_GetFontFamilyName(p, a, b) (p)->lpVtbl->GetFontFamilyName(p, a, b)
#define IDWriteTextLayout3_GetFontWeight(p, a) (p)->lpVtbl->GetFontWeight(p, a)
#define IDWriteTextLayout3_GetFontStyle(p, a) (p)->lpVtbl->GetFontStyle(p, a)
#define IDWriteTextLayout3_GetFontStretch(p, a) (p)->lpVtbl->GetFontStretch(p, a)
#define IDWriteTextLayout3_GetFontSize(p, a) (p)->lpVtbl->GetFontSize(p, a)
#define IDWriteTextLayout3_GetLocaleNameLength(p, a) (p)->lpVtbl->GetLocaleNameLength(p, a)
#define IDWriteTextLayout3_GetLocaleName(p, a, b) (p)->lpVtbl->GetLocaleName(p, a, b)
#define IDWriteTextLayout3_SetMaxWidth(p, a) (p)->lpVtbl->SetMaxWidth(p, a)
#define IDWriteTextLayout3_SetMaxHeight(p, a) (p)->lpVtbl->SetMaxHeight(p, a)
#define IDWriteTextLayout3_SetFontCollection(p, a, b) (p)->lpVtbl->SetFontCollection(p, a, b)
#define IDWriteTextLayout3_SetFontFamilyName(p, a, b) (p)->lpVtbl->SetFontFamilyName(p, a, b)
#define IDWriteTextLayout3_SetFontWeight(p, a, b) (p)->lpVtbl->SetFontWeight(p, a, b)
#define IDWriteTextLayout3_SetFontStyle(p, a, b) (p)->lpVtbl->SetFontStyle(p, a, b)
#define IDWriteTextLayout3_SetFontStretch(p, a, b) (p)->lpVtbl->SetFontStretch(p, a, b)
#define IDWriteTextLayout3_SetFontSize(p, a, b) (p)->lpVtbl->SetFontSize(p, a, b)
#define IDWriteTextLayout3_SetUnderline(p, a, b) (p)->lpVtbl->SetUnderline(p, a, b)
#define IDWriteTextLayout3_SetStrikethrough(p, a, b) (p)->lpVtbl->SetStrikethrough(p, a, b)
#define IDWriteTextLayout3_SetDrawingEffect(p, a, b) (p)->lpVtbl->SetDrawingEffect(p, a, b)
#define IDWriteTextLayout3_SetInlineObject(p, a, b) (p)->lpVtbl->SetInlineObject(p, a, b)
#define IDWriteTextLayout3_SetTypography(p, a, b) (p)->lpVtbl->SetTypography(p, a, b)
#define IDWriteTextLayout3_SetLocaleName(p, a, b) (p)->lpVtbl->SetLocaleName(p, a, b)
#define IDWriteTextLayout3_GetMaxWidth(p, a) (p)->lpVtbl->GetMaxWidth(p, a)
#define IDWriteTextLayout3_GetMaxHeight(p, a) (p)->lpVtbl->GetMaxHeight(p, a)
#define IDWriteTextLayout3_GetFontCollection1(p, a, b, c) (p)->lpVtbl->GetFontCollection1(p, a, b, c)
#define IDWriteTextLayout3_GetFontFamilyNameLength1(p, a, b, c) (p)->lpVtbl->GetFontFamilyNameLength1(p, a, b, c)
#define IDWriteTextLayout3_GetFontFamilyName1(p, a, b, c, d) (p)->lpVtbl->GetFontFamilyName1(p, a, b, c, d)
#define IDWriteTextLayout3_GetFontWeight1(p, a, b, c) (p)->lpVtbl->GetFontWeight1(p, a, b, c)
#define IDWriteTextLayout3_GetFontStyle1(p, a, b, c) (p)->lpVtbl->GetFontStyle1(p, a, b, c)
#define IDWriteTextLayout3_GetFontStretch1(p, a, b, c) (p)->lpVtbl->GetFontStretch1(p, a, b, c)
#define IDWriteTextLayout3_GetFontSize1(p, a, b, c) (p)->lpVtbl->GetFontSize1(p, a, b, c)
#define IDWriteTextLayout3_GetUnderline(p, a, b, c) (p)->lpVtbl->GetUnderline(p, a, b, c)
#define IDWriteTextLayout3_GetStrikethrough(p, a, b, c) (p)->lpVtbl->GetStrikethrough(p, a, b, c)
#define IDWriteTextLayout3_GetDrawingEffect(p, a, b, c) (p)->lpVtbl->GetDrawingEffect(p, a, b, c)
#define IDWriteTextLayout3_GetInlineObject(p, a, b, c) (p)->lpVtbl->GetInlineObject(p, a, b, c)
#define IDWriteTextLayout3_GetTypography(p, a, b, c) (p)->lpVtbl->GetTypography(p, a, b, c)
#define IDWriteTextLayout3_GetLocaleNameLength1(p, a, b, c) (p)->lpVtbl->GetLocaleNameLength1(p, a, b, c)
#define IDWriteTextLayout3_GetLocaleName1(p, a, b, c, d) (p)->lpVtbl->GetLocaleName1(p, a, b, c, d)
#define IDWriteTextLayout3_Draw(p, a, b, c, d) (p)->lpVtbl->Draw(p, a, b, c, d)
#define IDWriteTextLayout3_GetLineMetrics(p, a, b, c) (p)->lpVtbl->GetLineMetrics(p, a, b, c)
#define IDWriteTextLayout3_GetMetrics(p, a) (p)->lpVtbl->GetMetrics(p, a)
#define IDWriteTextLayout3_GetOverhangMetrics(p, a) (p)->lpVtbl->GetOverhangMetrics(p, a)
#define IDWriteTextLayout3_GetClusterMetrics(p, a, b, c) (p)->lpVtbl->GetClusterMetrics(p, a, b, c)
#define IDWriteTextLayout3_DetermineMinWidth(p, a) (p)->lpVtbl->DetermineMinWidth(p, a)
#define IDWriteTextLayout3_HitTestPoint(p, a, b, c, d, e) (p)->lpVtbl->HitTestPoint(p, a, b, c, d, e)
#define IDWriteTextLayout3_HitTestTextPosition(p, a, b, c, d, e) (p)->lpVtbl->HitTestTextPosition(p, a, b, c, d, e)
#define IDWriteTextLayout3_HitTestTextRange(p, a, b, c, d, e, f, g) (p)->lpVtbl->HitTestTextRange(p, a, b, c, d, e, f, g)
#define IDWriteTextLayout3_SetPairKerning(p, a, b) (p)->lpVtbl->SetPairKerning(p, a, b)
#define IDWriteTextLayout3_GetPairKerning(p, a, b, c) (p)->lpVtbl->GetPairKerning(p, a, b, c)
#define IDWriteTextLayout3_SetCharacterSpacing(p, a, b, c, d) (p)->lpVtbl->SetCharacterSpacing(p, a, b, c, d)
#define IDWriteTextLayout3_GetCharacterSpacing(p, a, b, c, d, e) (p)->lpVtbl->GetCharacterSpacing(p, a, b, c, d, e)
#define IDWriteTextLayout3_GetMetrics1(p, a) (p)->lpVtbl->GetMetrics1(p, a)
#define IDWriteTextLayout3_SetVerticalGlyphOrientation(p, a) (p)->lpVtbl->SetVerticalGlyphOrientation(p, a)
#define IDWriteTextLayout3_GetVerticalGlyphOrientation(p, a) (p)->lpVtbl->GetVerticalGlyphOrientation(p, a)
#define IDWriteTextLayout3_SetLastLineWrapping(p, a) (p)->lpVtbl->SetLastLineWrapping(p, a)
#define IDWriteTextLayout3_GetLastLineWrapping(p, a) (p)->lpVtbl->GetLastLineWrapping(p, a)
#define IDWriteTextLayout3_SetOpticalAlignment(p, a) (p)->lpVtbl->SetOpticalAlignment(p, a)
#define IDWriteTextLayout3_GetOpticalAlignment(p, a) (p)->lpVtbl->GetOpticalAlignment(p, a)
#define IDWriteTextLayout3_SetFontFallback(p, a) (p)->lpVtbl->SetFontFallback(p, a)
#define IDWriteTextLayout3_GetFontFallback(p, a) (p)->lpVtbl->GetFontFallback(p, a)
#define IDWriteTextLayout3_InvalidateLayout(p, a) (p)->lpVtbl->InvalidateLayout(p, a)
#define IDWriteTextLayout3_SetLineSpacing1(p, a) (p)->lpVtbl->SetLineSpacing1(p, a)
#define IDWriteTextLayout3_GetLineSpacing1(p, a) (p)->lpVtbl->GetLineSpacing1(p, a)
#define IDWriteTextLayout3_GetLineMetrics1(p, a, b, c) (p)->lpVtbl->GetLineMetrics1(p, a, b, c)

' ============================================================================
' IDWriteTextLayout4
' ============================================================================
Type IDWriteTextLayout4Vtbl As IDWriteTextLayout4Vtbl_
Type IDWriteTextLayout4
    lpVtbl As IDWriteTextLayout4Vtbl Ptr
End Type
Type IDWriteTextLayout4Vtbl_     '' Extends IDWriteTextLayout3Vtbl_
    QueryInterface As Function(ByVal This As IDWriteTextLayout4 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteTextLayout4 Ptr) As ULong
    Release As Function(ByVal This As IDWriteTextLayout4 Ptr) As ULong
        
    SetTextAlignment As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal textAlignment As DWRITE_TEXT_ALIGNMENT ) As HRESULT
        ' 5. SetParagraphAlignment
    SetParagraphAlignment As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal paragraphAlignment As DWRITE_PARAGRAPH_ALIGNMENT ) As HRESULT
        ' 6. SetWordWrapping
    SetWordWrapping As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal wordWrapping As DWRITE_WORD_WRAPPING ) As HRESULT
        ' 7. SetReadingDirection
    SetReadingDirection As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal readingDirection As DWRITE_READING_DIRECTION ) As HRESULT
        ' 8. SetFlowDirection
    SetFlowDirection As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal flowDirection As DWRITE_FLOW_DIRECTION ) As HRESULT
        ' 9. SetIncrementalTabStop
    SetIncrementalTabStop As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal incrementalTabStop As Single ) As HRESULT
        ' 10. SetTrimming
    SetTrimming As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal trimmingOptions As DWRITE_TRIMMING Ptr, ByVal trimmingSign As Any Ptr ) As HRESULT
        ' 11. SetLineSpacing
    SetLineSpacing As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal lineSpacingMethod As DWRITE_LINE_SPACING_METHOD, ByVal lineSpacing As Single, ByVal baseline As Single ) As HRESULT
        ' 12. GetTextAlignment
    GetTextAlignment As Function(ByVal This As IDWriteTextLayout4 Ptr) As DWRITE_TEXT_ALIGNMENT
        ' 13. GetParagraphAlignment
    GetParagraphAlignment As Function(ByVal This As IDWriteTextLayout4 Ptr) As DWRITE_PARAGRAPH_ALIGNMENT
        ' 14. GetWordWrapping
    GetWordWrapping As Function(ByVal This As IDWriteTextLayout4 Ptr) As DWRITE_WORD_WRAPPING
        ' 15. GetReadingDirection
    GetReadingDirection As Function(ByVal This As IDWriteTextLayout4 Ptr) As DWRITE_READING_DIRECTION
        ' 16. GetFlowDirection
    GetFlowDirection As Function(ByVal This As IDWriteTextLayout4 Ptr) As DWRITE_FLOW_DIRECTION
        ' 17. GetIncrementalTabStop
    GetIncrementalTabStop As Function(ByVal This As IDWriteTextLayout4 Ptr) As Single
        ' 18. GetTrimming
    GetTrimming As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal trimmingOptions As DWRITE_TRIMMING Ptr, ByVal trimmingSign As Any Ptr Ptr ) As HRESULT
        ' 19. GetLineSpacing
    GetLineSpacing As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal lineSpacingMethod As DWRITE_LINE_SPACING_METHOD Ptr, ByVal lineSpacing As Single Ptr, ByVal baseline As Single Ptr ) As HRESULT
        ' 20. GetFontCollection
    GetFontCollection As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal fontCollection As Any Ptr Ptr ) As HRESULT
        ' 21. GetFontFamilyNameLength
    GetFontFamilyNameLength As Function(ByVal This As IDWriteTextLayout4 Ptr) As ULong
        ' 22. GetFontFamilyName
    GetFontFamilyName As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal fontFamilyName As WString Ptr, ByVal nameSize As ULong ) As HRESULT
        ' 23. GetFontWeight
    GetFontWeight As Function(ByVal This As IDWriteTextLayout4 Ptr) As DWRITE_FONT_WEIGHT
        ' 24. GetFontStyle
    GetFontStyle As Function(ByVal This As IDWriteTextLayout4 Ptr) As DWRITE_FONT_STYLE
        ' 25. GetFontStretch
    GetFontStretch As Function(ByVal This As IDWriteTextLayout4 Ptr) As DWRITE_FONT_STRETCH
        ' 26. GetFontSize
    GetFontSize As Function(ByVal This As IDWriteTextLayout4 Ptr) As Single
        ' 27. GetLocaleNameLength
    GetLocaleNameLength As Function(ByVal This As IDWriteTextLayout4 Ptr) As ULong
        ' 28. GetLocaleName
    GetLocaleName As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal localeName As WString Ptr, ByVal nameSize As ULong ) As HRESULT
        
    SetMaxWidth As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal maxWidth As Single ) As HRESULT
        ' 30. SetMaxHeight
    SetMaxHeight As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal maxHeight As Single ) As HRESULT
        ' 31. SetFontCollection
    SetFontCollection As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal fontCollection As Any Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 32. SetFontFamilyName
    SetFontFamilyName As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal fontFamilyName As WString Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 33. SetFontWeight
    SetFontWeight As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal fontWeight As DWRITE_FONT_WEIGHT, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 34. SetFontStyle
    SetFontStyle As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal fontStyle As DWRITE_FONT_STYLE, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 35. SetFontStretch
    SetFontStretch As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal fontStretch As DWRITE_FONT_STRETCH, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 36. SetFontSize
    SetFontSize As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal fontSize As Single, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 37. SetUnderline
    SetUnderline As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal hasUnderline As Long, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 38. SetStrikethrough
    SetStrikethrough As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal hasStrikethrough As Long, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 39. SetDrawingEffect
    SetDrawingEffect As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal drawingEffect As IUnknown Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 40. SetInlineObject
    SetInlineObject As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal inlineObject As Any Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 41. SetTypography
    SetTypography As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal typography As Any Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 42. SetLocaleName
    SetLocaleName As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal localeName As WString Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 43. GetMaxWidth
    GetMaxWidth As Function(ByVal This As IDWriteTextLayout4 Ptr) As Single
        ' 44. GetMaxHeight
    GetMaxHeight As Function(ByVal This As IDWriteTextLayout4 Ptr) As Single
        ' 45. GetFontCollection
    GetFontCollection1 As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal currentPosition As ULong, ByVal fontCollection As Any Ptr Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 46. GetFontFamilyNameLength
    GetFontFamilyNameLength1 As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal currentPosition As ULong, ByVal nameLength As ULong Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 47. GetFontFamilyName
    GetFontFamilyName1 As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal currentPosition As ULong, ByVal fontFamilyName As WString Ptr, ByVal nameSize As ULong, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 48. GetFontWeight
    GetFontWeight1 As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal currentPosition As ULong, ByVal fontWeight As DWRITE_FONT_WEIGHT Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 49. GetFontStyle
    GetFontStyle1 As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal currentPosition As ULong, ByVal fontStyle As DWRITE_FONT_STYLE Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 50. GetFontStretch
    GetFontStretch1 As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal currentPosition As ULong, ByVal fontStretch As DWRITE_FONT_STRETCH Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 51. GetFontSize
    GetFontSize1 As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal currentPosition As ULong, ByVal fontSize As Single Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 52. GetUnderline
    GetUnderline As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal currentPosition As ULong, ByVal hasUnderline As Long Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 53. GetStrikethrough
    GetStrikethrough As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal currentPosition As ULong, ByVal hasStrikethrough As Long Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 54. GetDrawingEffect
    GetDrawingEffect As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal currentPosition As ULong, ByVal drawingEffect As IUnknown Ptr Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 55. GetInlineObject
    GetInlineObject As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal currentPosition As ULong, ByVal inlineObject As Any Ptr Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 56. GetTypography
    GetTypography As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal currentPosition As ULong, ByVal typography As Any Ptr Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 57. GetLocaleNameLength
    GetLocaleNameLength1 As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal currentPosition As ULong, ByVal nameLength As ULong Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 58. GetLocaleName
    GetLocaleName1 As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal currentPosition As ULong, ByVal localeName As WString Ptr, ByVal nameSize As ULong, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 59. Draw
    Draw As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal renderer As Any Ptr, ByVal originX As Single, ByVal originY As Single ) As HRESULT
        ' 60. GetLineMetrics
    GetLineMetrics As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal lineMetrics As DWRITE_LINE_METRICS Ptr, ByVal maxLineCount As ULong, ByVal actualLineCount As ULong Ptr ) As HRESULT
        ' 61. GetMetrics
    GetMetrics As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal textMetrics As DWRITE_TEXT_METRICS Ptr ) As HRESULT
        ' 62. GetOverhangMetrics
    GetOverhangMetrics As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal overhangs As DWRITE_OVERHANG_METRICS Ptr ) As HRESULT
        ' 63. GetClusterMetrics
    GetClusterMetrics As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal clusterMetrics As DWRITE_CLUSTER_METRICS Ptr, ByVal maxClusterCount As ULong, ByVal actualClusterCount As ULong Ptr ) As HRESULT
        ' 64. DetermineMinWidth
    DetermineMinWidth As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal minWidth As Single Ptr ) As HRESULT
        ' 65. HitTestPoint
    HitTestPoint As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal pointX As Single, ByVal pointY As Single, ByVal isTrailingHit As Long Ptr, ByVal isInside As Long Ptr, ByVal hitTestMetrics As DWRITE_HIT_TEST_METRICS Ptr ) As HRESULT
        ' 66. HitTestTextPosition
    HitTestTextPosition As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal textPosition As ULong, ByVal isTrailingHit As Long, ByVal pointX As Single Ptr, ByVal pointY As Single Ptr, ByVal hitTestMetrics As DWRITE_HIT_TEST_METRICS Ptr ) As HRESULT
        ' 67. HitTestTextRange
    HitTestTextRange As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal textPosition As ULong, ByVal textLength As ULong, ByVal originX As Single, ByVal originY As Single, ByVal hitTestMetrics As DWRITE_HIT_TEST_METRICS Ptr, ByVal maxHitTestMetricsCount As ULong, ByVal actualHitTestMetricsCount As ULong Ptr ) As HRESULT
        
    SetPairKerning As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal isPairKerningEnabled As Long, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 69. GetPairKerning
    GetPairKerning As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal currentPosition As ULong, ByVal isPairKerningEnabled As Long Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 70. SetCharacterSpacing
    SetCharacterSpacing As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal leadingSpacing As Single, ByVal trailingSpacing As Single, ByVal minimumAdvanceWidth As Single, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 71. GetCharacterSpacing
    GetCharacterSpacing As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal currentPosition As ULong, ByVal leadingSpacing As Single Ptr, ByVal trailingSpacing As Single Ptr, ByVal minimumAdvanceWidth As Single Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        
    GetMetrics1 As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal textMetrics As DWRITE_TEXT_METRICS1 Ptr ) As HRESULT
        ' 73. SetVerticalGlyphOrientation
    SetVerticalGlyphOrientation As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal glyphOrientation As DWRITE_VERTICAL_GLYPH_ORIENTATION ) As HRESULT
        ' 74. GetVerticalGlyphOrientation
    GetVerticalGlyphOrientation As Function(ByVal This As IDWriteTextLayout4 Ptr) As DWRITE_VERTICAL_GLYPH_ORIENTATION
        ' 75. SetLastLineWrapping
    SetLastLineWrapping As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal isLastLineWrappingEnabled As Long ) As HRESULT
        ' 76. GetLastLineWrapping
    GetLastLineWrapping As Function(ByVal This As IDWriteTextLayout4 Ptr) As Long
        ' 77. SetOpticalAlignment
    SetOpticalAlignment As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal opticalAlignment As DWRITE_OPTICAL_ALIGNMENT ) As HRESULT
        ' 78. GetOpticalAlignment
    GetOpticalAlignment As Function(ByVal This As IDWriteTextLayout4 Ptr) As DWRITE_OPTICAL_ALIGNMENT
        ' 79. SetFontFallback
    SetFontFallback As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal fontFallback As IDWriteFontFallback Ptr ) As HRESULT
        ' 80. GetFontFallback
    GetFontFallback As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal fontFallback As IDWriteFontFallback Ptr Ptr ) As HRESULT
        
    InvalidateLayout As Function(ByVal This As IDWriteTextLayout4 Ptr) As HRESULT
        ' 82. SetLineSpacing
    SetLineSpacing1 As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal lineSpacingOptions As DWRITE_LINE_SPACING Ptr ) As HRESULT
        ' 83. GetLineSpacing
    GetLineSpacing1 As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal lineSpacingOptions As DWRITE_LINE_SPACING Ptr ) As HRESULT
        ' 84. GetLineMetrics
    GetLineMetrics1 As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal lineMetrics As DWRITE_LINE_METRICS1 Ptr, ByVal maxLineCount As ULong, ByVal actualLineCount As ULong Ptr ) As HRESULT

        
    SetFontAxisValues As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 86. GetFontAxisValueCount
    GetFontAxisValueCount As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal currentPosition As ULong ) As ULong
        ' 87. GetFontAxisValues
    GetFontAxisValues As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal currentPosition As ULong, ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong, ByVal textRange As DWRITE_TEXT_RANGE Ptr ) As HRESULT
        ' 88. GetAutomaticFontAxes
    GetAutomaticFontAxes As Function(ByVal This As IDWriteTextLayout4 Ptr) As DWRITE_AUTOMATIC_FONT_AXES
        ' 89. SetAutomaticFontAxes
    SetAutomaticFontAxes As Function(ByVal This As IDWriteTextLayout4 Ptr,  ByVal automaticFontAxes As DWRITE_AUTOMATIC_FONT_AXES ) As HRESULT
End Type
#define IDWriteTextLayout4_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteTextLayout4_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteTextLayout4_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteTextLayout4_SetTextAlignment(p, a) (p)->lpVtbl->SetTextAlignment(p, a)
#define IDWriteTextLayout4_SetParagraphAlignment(p, a) (p)->lpVtbl->SetParagraphAlignment(p, a)
#define IDWriteTextLayout4_SetWordWrapping(p, a) (p)->lpVtbl->SetWordWrapping(p, a)
#define IDWriteTextLayout4_SetReadingDirection(p, a) (p)->lpVtbl->SetReadingDirection(p, a)
#define IDWriteTextLayout4_SetFlowDirection(p, a) (p)->lpVtbl->SetFlowDirection(p, a)
#define IDWriteTextLayout4_SetIncrementalTabStop(p, a) (p)->lpVtbl->SetIncrementalTabStop(p, a)
#define IDWriteTextLayout4_SetTrimming(p, a, b) (p)->lpVtbl->SetTrimming(p, a, b)
#define IDWriteTextLayout4_SetLineSpacing(p, a, b, c) (p)->lpVtbl->SetLineSpacing(p, a, b, c)
#define IDWriteTextLayout4_GetTextAlignment(p, a) (p)->lpVtbl->GetTextAlignment(p, a)
#define IDWriteTextLayout4_GetParagraphAlignment(p, a) (p)->lpVtbl->GetParagraphAlignment(p, a)
#define IDWriteTextLayout4_GetWordWrapping(p, a) (p)->lpVtbl->GetWordWrapping(p, a)
#define IDWriteTextLayout4_GetReadingDirection(p, a) (p)->lpVtbl->GetReadingDirection(p, a)
#define IDWriteTextLayout4_GetFlowDirection(p, a) (p)->lpVtbl->GetFlowDirection(p, a)
#define IDWriteTextLayout4_GetIncrementalTabStop(p, a) (p)->lpVtbl->GetIncrementalTabStop(p, a)
#define IDWriteTextLayout4_GetTrimming(p, a, b) (p)->lpVtbl->GetTrimming(p, a, b)
#define IDWriteTextLayout4_GetLineSpacing(p, a, b, c) (p)->lpVtbl->GetLineSpacing(p, a, b, c)
#define IDWriteTextLayout4_GetFontCollection(p, a) (p)->lpVtbl->GetFontCollection(p, a)
#define IDWriteTextLayout4_GetFontFamilyNameLength(p, a) (p)->lpVtbl->GetFontFamilyNameLength(p, a)
#define IDWriteTextLayout4_GetFontFamilyName(p, a, b) (p)->lpVtbl->GetFontFamilyName(p, a, b)
#define IDWriteTextLayout4_GetFontWeight(p, a) (p)->lpVtbl->GetFontWeight(p, a)
#define IDWriteTextLayout4_GetFontStyle(p, a) (p)->lpVtbl->GetFontStyle(p, a)
#define IDWriteTextLayout4_GetFontStretch(p, a) (p)->lpVtbl->GetFontStretch(p, a)
#define IDWriteTextLayout4_GetFontSize(p, a) (p)->lpVtbl->GetFontSize(p, a)
#define IDWriteTextLayout4_GetLocaleNameLength(p, a) (p)->lpVtbl->GetLocaleNameLength(p, a)
#define IDWriteTextLayout4_GetLocaleName(p, a, b) (p)->lpVtbl->GetLocaleName(p, a, b)
#define IDWriteTextLayout4_SetMaxWidth(p, a) (p)->lpVtbl->SetMaxWidth(p, a)
#define IDWriteTextLayout4_SetMaxHeight(p, a) (p)->lpVtbl->SetMaxHeight(p, a)
#define IDWriteTextLayout4_SetFontCollection(p, a, b) (p)->lpVtbl->SetFontCollection(p, a, b)
#define IDWriteTextLayout4_SetFontFamilyName(p, a, b) (p)->lpVtbl->SetFontFamilyName(p, a, b)
#define IDWriteTextLayout4_SetFontWeight(p, a, b) (p)->lpVtbl->SetFontWeight(p, a, b)
#define IDWriteTextLayout4_SetFontStyle(p, a, b) (p)->lpVtbl->SetFontStyle(p, a, b)
#define IDWriteTextLayout4_SetFontStretch(p, a, b) (p)->lpVtbl->SetFontStretch(p, a, b)
#define IDWriteTextLayout4_SetFontSize(p, a, b) (p)->lpVtbl->SetFontSize(p, a, b)
#define IDWriteTextLayout4_SetUnderline(p, a, b) (p)->lpVtbl->SetUnderline(p, a, b)
#define IDWriteTextLayout4_SetStrikethrough(p, a, b) (p)->lpVtbl->SetStrikethrough(p, a, b)
#define IDWriteTextLayout4_SetDrawingEffect(p, a, b) (p)->lpVtbl->SetDrawingEffect(p, a, b)
#define IDWriteTextLayout4_SetInlineObject(p, a, b) (p)->lpVtbl->SetInlineObject(p, a, b)
#define IDWriteTextLayout4_SetTypography(p, a, b) (p)->lpVtbl->SetTypography(p, a, b)
#define IDWriteTextLayout4_SetLocaleName(p, a, b) (p)->lpVtbl->SetLocaleName(p, a, b)
#define IDWriteTextLayout4_GetMaxWidth(p, a) (p)->lpVtbl->GetMaxWidth(p, a)
#define IDWriteTextLayout4_GetMaxHeight(p, a) (p)->lpVtbl->GetMaxHeight(p, a)
#define IDWriteTextLayout4_GetFontCollection1(p, a, b, c) (p)->lpVtbl->GetFontCollection1(p, a, b, c)
#define IDWriteTextLayout4_GetFontFamilyNameLength1(p, a, b, c) (p)->lpVtbl->GetFontFamilyNameLength1(p, a, b, c)
#define IDWriteTextLayout4_GetFontFamilyName1(p, a, b, c, d) (p)->lpVtbl->GetFontFamilyName1(p, a, b, c, d)
#define IDWriteTextLayout4_GetFontWeight1(p, a, b, c) (p)->lpVtbl->GetFontWeight1(p, a, b, c)
#define IDWriteTextLayout4_GetFontStyle1(p, a, b, c) (p)->lpVtbl->GetFontStyle1(p, a, b, c)
#define IDWriteTextLayout4_GetFontStretch1(p, a, b, c) (p)->lpVtbl->GetFontStretch1(p, a, b, c)
#define IDWriteTextLayout4_GetFontSize1(p, a, b, c) (p)->lpVtbl->GetFontSize1(p, a, b, c)
#define IDWriteTextLayout4_GetUnderline(p, a, b, c) (p)->lpVtbl->GetUnderline(p, a, b, c)
#define IDWriteTextLayout4_GetStrikethrough(p, a, b, c) (p)->lpVtbl->GetStrikethrough(p, a, b, c)
#define IDWriteTextLayout4_GetDrawingEffect(p, a, b, c) (p)->lpVtbl->GetDrawingEffect(p, a, b, c)
#define IDWriteTextLayout4_GetInlineObject(p, a, b, c) (p)->lpVtbl->GetInlineObject(p, a, b, c)
#define IDWriteTextLayout4_GetTypography(p, a, b, c) (p)->lpVtbl->GetTypography(p, a, b, c)
#define IDWriteTextLayout4_GetLocaleNameLength1(p, a, b, c) (p)->lpVtbl->GetLocaleNameLength1(p, a, b, c)
#define IDWriteTextLayout4_GetLocaleName1(p, a, b, c, d) (p)->lpVtbl->GetLocaleName1(p, a, b, c, d)
#define IDWriteTextLayout4_Draw(p, a, b, c, d) (p)->lpVtbl->Draw(p, a, b, c, d)
#define IDWriteTextLayout4_GetLineMetrics(p, a, b, c) (p)->lpVtbl->GetLineMetrics(p, a, b, c)
#define IDWriteTextLayout4_GetMetrics(p, a) (p)->lpVtbl->GetMetrics(p, a)
#define IDWriteTextLayout4_GetOverhangMetrics(p, a) (p)->lpVtbl->GetOverhangMetrics(p, a)
#define IDWriteTextLayout4_GetClusterMetrics(p, a, b, c) (p)->lpVtbl->GetClusterMetrics(p, a, b, c)
#define IDWriteTextLayout4_DetermineMinWidth(p, a) (p)->lpVtbl->DetermineMinWidth(p, a)
#define IDWriteTextLayout4_HitTestPoint(p, a, b, c, d, e) (p)->lpVtbl->HitTestPoint(p, a, b, c, d, e)
#define IDWriteTextLayout4_HitTestTextPosition(p, a, b, c, d, e) (p)->lpVtbl->HitTestTextPosition(p, a, b, c, d, e)
#define IDWriteTextLayout4_HitTestTextRange(p, a, b, c, d, e, f, g) (p)->lpVtbl->HitTestTextRange(p, a, b, c, d, e, f, g)
#define IDWriteTextLayout4_SetPairKerning(p, a, b) (p)->lpVtbl->SetPairKerning(p, a, b)
#define IDWriteTextLayout4_GetPairKerning(p, a, b, c) (p)->lpVtbl->GetPairKerning(p, a, b, c)
#define IDWriteTextLayout4_SetCharacterSpacing(p, a, b, c, d) (p)->lpVtbl->SetCharacterSpacing(p, a, b, c, d)
#define IDWriteTextLayout4_GetCharacterSpacing(p, a, b, c, d, e) (p)->lpVtbl->GetCharacterSpacing(p, a, b, c, d, e)
#define IDWriteTextLayout4_GetMetrics1(p, a) (p)->lpVtbl->GetMetrics1(p, a)
#define IDWriteTextLayout4_SetVerticalGlyphOrientation(p, a) (p)->lpVtbl->SetVerticalGlyphOrientation(p, a)
#define IDWriteTextLayout4_GetVerticalGlyphOrientation(p, a) (p)->lpVtbl->GetVerticalGlyphOrientation(p, a)
#define IDWriteTextLayout4_SetLastLineWrapping(p, a) (p)->lpVtbl->SetLastLineWrapping(p, a)
#define IDWriteTextLayout4_GetLastLineWrapping(p, a) (p)->lpVtbl->GetLastLineWrapping(p, a)
#define IDWriteTextLayout4_SetOpticalAlignment(p, a) (p)->lpVtbl->SetOpticalAlignment(p, a)
#define IDWriteTextLayout4_GetOpticalAlignment(p, a) (p)->lpVtbl->GetOpticalAlignment(p, a)
#define IDWriteTextLayout4_SetFontFallback(p, a) (p)->lpVtbl->SetFontFallback(p, a)
#define IDWriteTextLayout4_GetFontFallback(p, a) (p)->lpVtbl->GetFontFallback(p, a)
#define IDWriteTextLayout4_InvalidateLayout(p, a) (p)->lpVtbl->InvalidateLayout(p, a)
#define IDWriteTextLayout4_SetLineSpacing1(p, a) (p)->lpVtbl->SetLineSpacing1(p, a)
#define IDWriteTextLayout4_GetLineSpacing1(p, a) (p)->lpVtbl->GetLineSpacing1(p, a)
#define IDWriteTextLayout4_GetLineMetrics1(p, a, b, c) (p)->lpVtbl->GetLineMetrics1(p, a, b, c)
#define IDWriteTextLayout4_SetFontAxisValues(p, a, b, c) (p)->lpVtbl->SetFontAxisValues(p, a, b, c)
#define IDWriteTextLayout4_GetFontAxisValueCount(p, a) (p)->lpVtbl->GetFontAxisValueCount(p, a)
#define IDWriteTextLayout4_GetFontAxisValues(p, a, b, c, d) (p)->lpVtbl->GetFontAxisValues(p, a, b, c, d)
#define IDWriteTextLayout4_GetAutomaticFontAxes(p, a) (p)->lpVtbl->GetAutomaticFontAxes(p, a)
#define IDWriteTextLayout4_SetAutomaticFontAxes(p, a) (p)->lpVtbl->SetAutomaticFontAxes(p, a)

' ============================================================================
' IDWriteFontFallback1
' ============================================================================
Type IDWriteFontFallback1Vtbl As IDWriteFontFallback1Vtbl_
Type IDWriteFontFallback1
    lpVtbl As IDWriteFontFallback1Vtbl Ptr
End Type
Type IDWriteFontFallback1Vtbl_     '' Extends IDWriteFontFallbackVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontFallback1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontFallback1 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontFallback1 Ptr) As ULong
        
    MapCharacters As Function(ByVal This As IDWriteFontFallback1 Ptr,  ByVal analysisSource As IDWriteTextAnalysisSource Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal baseFontCollection As IDWriteFontCollection Ptr, ByVal baseFamilyName As WString Ptr, ByVal baseWeight As DWRITE_FONT_WEIGHT, ByVal baseStyle As DWRITE_FONT_STYLE, ByVal baseStretch As DWRITE_FONT_STRETCH, ByVal mappedLength As ULong Ptr, ByVal mappedFont As IDWriteFont Ptr Ptr, ByVal scale As Single Ptr ) As HRESULT

        
    MapCharacters1 As Function(ByVal This As IDWriteFontFallback1 Ptr,  ByVal analysisSource As IDWriteTextAnalysisSource Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal baseFontCollection As IDWriteFontCollection Ptr, ByVal baseFamilyName As WString Ptr, ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong, ByVal mappedLength As ULong Ptr, ByVal scale As Single Ptr, ByVal mappedFontFace As IDWriteFontFace5 Ptr Ptr ) As HRESULT
End Type
#define IDWriteFontFallback1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontFallback1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontFallback1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontFallback1_MapCharacters(p, a, b, c, d, e, f, g, h, i, j, k) (p)->lpVtbl->MapCharacters(p, a, b, c, d, e, f, g, h, i, j, k)
#define IDWriteFontFallback1_MapCharacters1(p, a, b, c, d, e, f, g, h, i, j) (p)->lpVtbl->MapCharacters1(p, a, b, c, d, e, f, g, h, i, j)

' ============================================================================
' IDWriteGdiInterop1
' ============================================================================
Type IDWriteGdiInterop1Vtbl As IDWriteGdiInterop1Vtbl_
Type IDWriteGdiInterop1
    lpVtbl As IDWriteGdiInterop1Vtbl Ptr
End Type
Type IDWriteGdiInterop1Vtbl_     '' Extends IDWriteGdiInteropVtbl_
    QueryInterface As Function(ByVal This As IDWriteGdiInterop1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteGdiInterop1 Ptr) As ULong
    Release As Function(ByVal This As IDWriteGdiInterop1 Ptr) As ULong
        
    CreateFontFromLOGFONT As Function(ByVal This As IDWriteGdiInterop1 Ptr,  ByVal logFont As LOGFONTW Ptr, ByVal font As Any Ptr Ptr ) As HRESULT
        ' 5. ConvertFontToLOGFONT
    ConvertFontToLOGFONT As Function(ByVal This As IDWriteGdiInterop1 Ptr,  ByVal font As Any Ptr, ByVal logFont As LOGFONTW Ptr, ByVal isSystemFont As Long Ptr ) As HRESULT
        ' 6. ConvertFontFaceToLOGFONT
    ConvertFontFaceToLOGFONT As Function(ByVal This As IDWriteGdiInterop1 Ptr,  ByVal font As Any Ptr, ByVal logFont As LOGFONTW Ptr ) As HRESULT
        ' 7. CreateFontFaceFromHdc
    CreateFontFaceFromHdc As Function(ByVal This As IDWriteGdiInterop1 Ptr,  ByVal hdc As HDC, ByVal fontFace As Any Ptr Ptr ) As HRESULT
        ' 8. CreateBitmapRenderTarget
    CreateBitmapRenderTarget As Function(ByVal This As IDWriteGdiInterop1 Ptr,  ByVal hdc As HDC, ByVal width As ULong, ByVal height As ULong, ByVal renderTarget As Any Ptr Ptr ) As HRESULT

        
    CreateFontFromLOGFONT1 As Function(ByVal This As IDWriteGdiInterop1 Ptr,  ByVal logFont As LOGFONTW Ptr, ByVal fontCollection As IDWriteFontCollection Ptr, ByVal font As IDWriteFont Ptr Ptr ) As HRESULT
        ' 10. GetFontSignature_ (FontFace version)
    GetFontSignature_ As Function(ByVal This As IDWriteGdiInterop1 Ptr,  ByVal fontFace As IDWriteFontFace Ptr, ByVal fontSignature As FONTSIGNATURE Ptr ) As HRESULT
        ' 11. GetFontSignature (Font version)
    GetFontSignature As Function(ByVal This As IDWriteGdiInterop1 Ptr,  ByVal font As IDWriteFont Ptr, ByVal fontSignature As FONTSIGNATURE Ptr ) As HRESULT
        ' 12. GetMatchingFontsByLOGFONT
    GetMatchingFontsByLOGFONT As Function(ByVal This As IDWriteGdiInterop1 Ptr,  ByVal logFont As LOGFONTW Ptr, ByVal fontSet As IDWriteFontSet Ptr, ByVal filteredSet As IDWriteFontSet Ptr Ptr ) As HRESULT
End Type
#define IDWriteGdiInterop1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteGdiInterop1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteGdiInterop1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteGdiInterop1_CreateFontFromLOGFONT(p, a, b) (p)->lpVtbl->CreateFontFromLOGFONT(p, a, b)
#define IDWriteGdiInterop1_ConvertFontToLOGFONT(p, a, b, c) (p)->lpVtbl->ConvertFontToLOGFONT(p, a, b, c)
#define IDWriteGdiInterop1_ConvertFontFaceToLOGFONT(p, a, b) (p)->lpVtbl->ConvertFontFaceToLOGFONT(p, a, b)
#define IDWriteGdiInterop1_CreateFontFaceFromHdc(p, a, b) (p)->lpVtbl->CreateFontFaceFromHdc(p, a, b)
#define IDWriteGdiInterop1_CreateBitmapRenderTarget(p, a, b, c, d) (p)->lpVtbl->CreateBitmapRenderTarget(p, a, b, c, d)
#define IDWriteGdiInterop1_CreateFontFromLOGFONT1(p, a, b, c) (p)->lpVtbl->CreateFontFromLOGFONT1(p, a, b, c)
#define IDWriteGdiInterop1_GetFontSignature_(p, a, b) (p)->lpVtbl->GetFontSignature_(p, a, b)
#define IDWriteGdiInterop1_GetFontSignature(p, a, b) (p)->lpVtbl->GetFontSignature(p, a, b)
#define IDWriteGdiInterop1_GetMatchingFontsByLOGFONT(p, a, b, c) (p)->lpVtbl->GetMatchingFontsByLOGFONT(p, a, b, c)

' ============================================================================
' IDWriteFontSetBuilder
' ============================================================================
Type IDWriteFontSetBuilderVtbl As IDWriteFontSetBuilderVtbl_
Type IDWriteFontSetBuilder
    lpVtbl As IDWriteFontSetBuilderVtbl Ptr
End Type
Type IDWriteFontSetBuilderVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontSetBuilder Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontSetBuilder Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontSetBuilder Ptr) As ULong

        
    AddFontFaceReference_ As Function(ByVal This As IDWriteFontSetBuilder Ptr,  ByVal fontFaceReference As IDWriteFontFaceReference Ptr, ByVal properties As DWRITE_FONT_PROPERTY Ptr, ByVal propertyCount As ULong ) As HRESULT
        ' 5. AddFontFaceReference (simple version)
    AddFontFaceReference As Function(ByVal This As IDWriteFontSetBuilder Ptr,  ByVal fontFaceReference As IDWriteFontFaceReference Ptr ) As HRESULT
        ' 6. AddFontSet
    AddFontSet As Function(ByVal This As IDWriteFontSetBuilder Ptr,  ByVal fontSet As IDWriteFontSet Ptr ) As HRESULT
        ' 7. CreateFontSet
    CreateFontSet As Function(ByVal This As IDWriteFontSetBuilder Ptr,  ByVal fontSet As IDWriteFontSet Ptr Ptr ) As HRESULT
End Type
#define IDWriteFontSetBuilder_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontSetBuilder_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontSetBuilder_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontSetBuilder_AddFontFaceReference_(p, a, b, c) (p)->lpVtbl->AddFontFaceReference_(p, a, b, c)
#define IDWriteFontSetBuilder_AddFontFaceReference(p, a) (p)->lpVtbl->AddFontFaceReference(p, a)
#define IDWriteFontSetBuilder_AddFontSet(p, a) (p)->lpVtbl->AddFontSet(p, a)
#define IDWriteFontSetBuilder_CreateFontSet(p, a) (p)->lpVtbl->CreateFontSet(p, a)

' ============================================================================
' IDWriteFontSetBuilder1
' ============================================================================
Type IDWriteFontSetBuilder1Vtbl As IDWriteFontSetBuilder1Vtbl_
Type IDWriteFontSetBuilder1
    lpVtbl As IDWriteFontSetBuilder1Vtbl Ptr
End Type
Type IDWriteFontSetBuilder1Vtbl_     '' Extends IDWriteFontSetBuilderVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontSetBuilder1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontSetBuilder1 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontSetBuilder1 Ptr) As ULong
        
    AddFontFaceReference_ As Function(ByVal This As IDWriteFontSetBuilder1 Ptr,  ByVal fontFaceReference As IDWriteFontFaceReference Ptr, ByVal properties As DWRITE_FONT_PROPERTY Ptr, ByVal propertyCount As ULong ) As HRESULT
        ' 5. AddFontFaceReference (simple version)
    AddFontFaceReference As Function(ByVal This As IDWriteFontSetBuilder1 Ptr,  ByVal fontFaceReference As IDWriteFontFaceReference Ptr ) As HRESULT
        ' 6. AddFontSet
    AddFontSet As Function(ByVal This As IDWriteFontSetBuilder1 Ptr,  ByVal fontSet As IDWriteFontSet Ptr ) As HRESULT
        ' 7. CreateFontSet
    CreateFontSet As Function(ByVal This As IDWriteFontSetBuilder1 Ptr,  ByVal fontSet As IDWriteFontSet Ptr Ptr ) As HRESULT

        
    AddFontFile As Function(ByVal This As IDWriteFontSetBuilder1 Ptr,  ByVal fontFile As IDWriteFontFile Ptr ) As HRESULT
End Type
#define IDWriteFontSetBuilder1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontSetBuilder1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontSetBuilder1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontSetBuilder1_AddFontFaceReference_(p, a, b, c) (p)->lpVtbl->AddFontFaceReference_(p, a, b, c)
#define IDWriteFontSetBuilder1_AddFontFaceReference(p, a) (p)->lpVtbl->AddFontFaceReference(p, a)
#define IDWriteFontSetBuilder1_AddFontSet(p, a) (p)->lpVtbl->AddFontSet(p, a)
#define IDWriteFontSetBuilder1_CreateFontSet(p, a) (p)->lpVtbl->CreateFontSet(p, a)
#define IDWriteFontSetBuilder1_AddFontFile(p, a) (p)->lpVtbl->AddFontFile(p, a)

' ============================================================================
' IDWriteFontSetBuilder2
' ============================================================================
Type IDWriteFontSetBuilder2Vtbl As IDWriteFontSetBuilder2Vtbl_
Type IDWriteFontSetBuilder2
    lpVtbl As IDWriteFontSetBuilder2Vtbl Ptr
End Type
Type IDWriteFontSetBuilder2Vtbl_     '' Extends IDWriteFontSetBuilder1Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFontSetBuilder2 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontSetBuilder2 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontSetBuilder2 Ptr) As ULong
        
    AddFontFaceReference_ As Function(ByVal This As IDWriteFontSetBuilder2 Ptr,  ByVal fontFaceReference As IDWriteFontFaceReference Ptr, ByVal properties As DWRITE_FONT_PROPERTY Ptr, ByVal propertyCount As ULong ) As HRESULT
        ' 5. AddFontFaceReference (simple version)
    AddFontFaceReference As Function(ByVal This As IDWriteFontSetBuilder2 Ptr,  ByVal fontFaceReference As IDWriteFontFaceReference Ptr ) As HRESULT
        ' 6. AddFontSet
    AddFontSet As Function(ByVal This As IDWriteFontSetBuilder2 Ptr,  ByVal fontSet As IDWriteFontSet Ptr ) As HRESULT
        ' 7. CreateFontSet
    CreateFontSet As Function(ByVal This As IDWriteFontSetBuilder2 Ptr,  ByVal fontSet As IDWriteFontSet Ptr Ptr ) As HRESULT
        
    AddFontFile As Function(ByVal This As IDWriteFontSetBuilder2 Ptr,  ByVal fontFile As IDWriteFontFile Ptr ) As HRESULT

        
    AddFont As Function(ByVal This As IDWriteFontSetBuilder2 Ptr,  ByVal fontFile As IDWriteFontFile Ptr, ByVal fontFaceIndex As ULong, ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong, ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, ByVal fontAxisRangeCount As ULong, ByVal properties As DWRITE_FONT_PROPERTY Ptr, ByVal propertyCount As ULong ) As HRESULT
        ' 10. AddFontFile (by path)
    AddFontFile1 As Function(ByVal This As IDWriteFontSetBuilder2 Ptr,  ByVal filePath As WString Ptr ) As HRESULT
End Type
#define IDWriteFontSetBuilder2_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontSetBuilder2_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontSetBuilder2_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontSetBuilder2_AddFontFaceReference_(p, a, b, c) (p)->lpVtbl->AddFontFaceReference_(p, a, b, c)
#define IDWriteFontSetBuilder2_AddFontFaceReference(p, a) (p)->lpVtbl->AddFontFaceReference(p, a)
#define IDWriteFontSetBuilder2_AddFontSet(p, a) (p)->lpVtbl->AddFontSet(p, a)
#define IDWriteFontSetBuilder2_CreateFontSet(p, a) (p)->lpVtbl->CreateFontSet(p, a)
#define IDWriteFontSetBuilder2_AddFontFile(p, a) (p)->lpVtbl->AddFontFile(p, a)
#define IDWriteFontSetBuilder2_AddFont(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->AddFont(p, a, b, c, d, e, f, g, h, i)
#define IDWriteFontSetBuilder2_AddFontFile1(p, a) (p)->lpVtbl->AddFontFile1(p, a)

' ============================================================================
' IDWriteFactory3
' ============================================================================
Type IDWriteFactory3Vtbl As IDWriteFactory3Vtbl_
Type IDWriteFactory3
    lpVtbl As IDWriteFactory3Vtbl Ptr
End Type
Type IDWriteFactory3Vtbl_     '' Extends IDWriteFactory2Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFactory3 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFactory3 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFactory3 Ptr) As ULong
        
    GetSystemFontCollection As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal fontCollection As Any Ptr Ptr, ByVal checkForUpdates As Long = 0 ) As HRESULT
        ' 5. CreateCustomFontCollection
    CreateCustomFontCollection As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal collectionLoader As Any Ptr, ByVal collectionKey As Any Ptr, ByVal collectionKeySize As ULong, ByVal fontCollection As Any Ptr Ptr ) As HRESULT
        ' 6. RegisterFontCollectionLoader
    RegisterFontCollectionLoader As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal fontCollectionLoader As Any Ptr ) As HRESULT
        ' 7. UnregisterFontCollectionLoader
    UnregisterFontCollectionLoader As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal fontCollectionLoader As Any Ptr ) As HRESULT
        ' 8. CreateFontFileReference
    CreateFontFileReference As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal filePath As WString Ptr, ByVal lastWriteTime As FILETIME Ptr, ByVal fontFile As Any Ptr Ptr ) As HRESULT
        ' 9. CreateCustomFontFileReference
    CreateCustomFontFileReference As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal fontFileReferenceKey As Any Ptr, ByVal fontFileReferenceKeySize As ULong, ByVal fontFileLoader As Any Ptr, ByVal fontFile As Any Ptr Ptr ) As HRESULT
        ' 10. CreateFontFace
    CreateFontFace As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal fontFaceType As DWRITE_FONT_FACE_TYPE, ByVal numberOfFiles As ULong, ByVal fontFiles As Any Ptr Ptr, ByVal faceIndex As ULong, ByVal fontFaceSimulationFlags As DWRITE_FONT_SIMULATIONS, ByVal fontFace As Any Ptr Ptr ) As HRESULT
        ' 11. CreateRenderingParams
    CreateRenderingParams As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 12. CreateMonitorRenderingParams
    CreateMonitorRenderingParams As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal monitor As HMONITOR, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 13. CreateCustomRenderingParams
    CreateCustomRenderingParams As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 14. RegisterFontFileLoader
    RegisterFontFileLoader As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal fontFileLoader As Any Ptr ) As HRESULT
        ' 15. UnregisterFontFileLoader
    UnregisterFontFileLoader As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal fontFileLoader As Any Ptr ) As HRESULT
        ' 16. CreateTextFormat
    CreateTextFormat As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal fontFamilyName As WString Ptr, ByVal fontCollection As Any Ptr, ByVal fontWeight As DWRITE_FONT_WEIGHT, ByVal fontStyle As DWRITE_FONT_STYLE, ByVal fontStretch As DWRITE_FONT_STRETCH, ByVal fontSize As Single, ByVal localeName As WString Ptr, ByVal textFormat As IDWriteTextFormat Ptr Ptr ) As HRESULT
        ' 17. CreateTypography
    CreateTypography As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal typography As Any Ptr Ptr ) As HRESULT
        ' 18. GetGdiInterop
    GetGdiInterop As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal gdiInterop As Any Ptr Ptr ) As HRESULT
        ' 19. CreateTextLayout
    CreateTextLayout As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal string As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal maxWidth As Single, ByVal maxHeight As Single, ByVal textLayout As Any Ptr Ptr ) As HRESULT
        ' 20. CreateGdiCompatibleTextLayout
    CreateGdiCompatibleTextLayout As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal string As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal layoutWidth As Single, ByVal layoutHeight As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal useGdiNatural As Long, ByVal textLayout As Any Ptr Ptr ) As HRESULT
        ' 21. CreateEllipsisTrimmingSign
    CreateEllipsisTrimmingSign As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal textFormat As Any Ptr, ByVal trimmingSign As Any Ptr Ptr ) As HRESULT
        ' 22. CreateTextAnalyzer
    CreateTextAnalyzer As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal textAnalyzer As Any Ptr Ptr ) As HRESULT
        ' 23. CreateNumberSubstitution
    CreateNumberSubstitution As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal substitutionMethod As DWRITE_NUMBER_SUBSTITUTION_METHOD, ByVal localeName As WString Ptr, ByVal ignoreUserOverride As Long, ByVal numberSubstitution As Any Ptr Ptr ) As HRESULT
        ' 24. CreateGlyphRunAnalysis
    CreateGlyphRunAnalysis As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRunAnalysis As Any Ptr Ptr ) As HRESULT
        
    GetEudcFontCollection As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal collection As Any Ptr Ptr, ByVal checkForUpdates As Long = 0 ) As HRESULT
        ' 26. CreateCustomRenderingParams
    CreateCustomRenderingParams1 As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal enhancedContrastGrayscale As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        
    GetSystemFontFallback As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal fontFallback As IDWriteFontFallback Ptr Ptr ) As HRESULT
        ' 28. CreateFontFallbackBuilder
    CreateFontFallbackBuilder As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal fontFallbackBuilder As IDWriteFontFallbackBuilder Ptr Ptr ) As HRESULT
        ' 29. TranslateColorGlyphRun
    TranslateColorGlyphRun As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal worldToDeviceTransform As DWRITE_MATRIX Ptr, ByVal colorPaletteIndex As ULong, ByVal colorLayers As IDWriteColorGlyphRunEnumerator Ptr Ptr ) As HRESULT
        ' 30. CreateCustomRenderingParams
    CreateCustomRenderingParams2 As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal grayscaleEnhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal renderingParams As IDWriteRenderingParams2 Ptr Ptr ) As HRESULT
        ' 31. CreateGlyphRunAnalysis
    CreateGlyphRunAnalysis1 As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal transform As DWRITE_MATRIX Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal antialiasMode As DWRITE_TEXT_ANTIALIAS_MODE, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRunAnalysis As IDWriteGlyphRunAnalysis Ptr Ptr ) As HRESULT

        
    CreateGlyphRunAnalysis2 As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal transform As DWRITE_MATRIX Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE1, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal antialiasMode As DWRITE_TEXT_ANTIALIAS_MODE, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRunAnalysis As IDWriteGlyphRunAnalysis Ptr Ptr ) As HRESULT
        ' 33. CreateCustomRenderingParams
    CreateCustomRenderingParams3 As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal grayscaleEnhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE1, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal renderingParams As IDWriteRenderingParams3 Ptr Ptr ) As HRESULT
        ' 34. CreateFontFaceReference_ (from file)
    CreateFontFaceReference_ As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal fontFile As IDWriteFontFile Ptr, ByVal faceIndex As ULong, ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 35. CreateFontFaceReference (from path)
    CreateFontFaceReference As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal filePath As WString Ptr, ByVal lastWriteTime As FILETIME Ptr, ByVal faceIndex As ULong, ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 36. GetSystemFontSet
    GetSystemFontSet As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal fontSet As IDWriteFontSet Ptr Ptr ) As HRESULT
        ' 37. CreateFontSetBuilder
    CreateFontSetBuilder As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal fontSetBuilder As IDWriteFontSetBuilder Ptr Ptr ) As HRESULT
        ' 38. CreateFontCollectionFromFontSet
    CreateFontCollectionFromFontSet As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal fontSet As IDWriteFontSet Ptr, ByVal fontCollection As IDWriteFontCollection1 Ptr Ptr ) As HRESULT
        ' 39. GetSystemFontCollection
    GetSystemFontCollection1 As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal includeDownloadableFonts As Long, ByVal fontCollection As IDWriteFontCollection1 Ptr Ptr, ByVal checkForUpdates As Long ) As HRESULT
        ' 40. GetFontDownloadQueue
    GetFontDownloadQueue As Function(ByVal This As IDWriteFactory3 Ptr,  ByVal fontDownloadQueue As IDWriteFontDownloadQueue Ptr Ptr ) As HRESULT
End Type
#define IDWriteFactory3_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFactory3_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFactory3_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFactory3_GetSystemFontCollection(p, a, b) (p)->lpVtbl->GetSystemFontCollection(p, a, b)
#define IDWriteFactory3_CreateCustomFontCollection(p, a, b, c, d) (p)->lpVtbl->CreateCustomFontCollection(p, a, b, c, d)
#define IDWriteFactory3_RegisterFontCollectionLoader(p, a) (p)->lpVtbl->RegisterFontCollectionLoader(p, a)
#define IDWriteFactory3_UnregisterFontCollectionLoader(p, a) (p)->lpVtbl->UnregisterFontCollectionLoader(p, a)
#define IDWriteFactory3_CreateFontFileReference(p, a, b, c) (p)->lpVtbl->CreateFontFileReference(p, a, b, c)
#define IDWriteFactory3_CreateCustomFontFileReference(p, a, b, c, d) (p)->lpVtbl->CreateCustomFontFileReference(p, a, b, c, d)
#define IDWriteFactory3_CreateFontFace(p, a, b, c, d, e, f) (p)->lpVtbl->CreateFontFace(p, a, b, c, d, e, f)
#define IDWriteFactory3_CreateRenderingParams(p, a) (p)->lpVtbl->CreateRenderingParams(p, a)
#define IDWriteFactory3_CreateMonitorRenderingParams(p, a, b) (p)->lpVtbl->CreateMonitorRenderingParams(p, a, b)
#define IDWriteFactory3_CreateCustomRenderingParams(p, a, b, c, d, e, f) (p)->lpVtbl->CreateCustomRenderingParams(p, a, b, c, d, e, f)
#define IDWriteFactory3_RegisterFontFileLoader(p, a) (p)->lpVtbl->RegisterFontFileLoader(p, a)
#define IDWriteFactory3_UnregisterFontFileLoader(p, a) (p)->lpVtbl->UnregisterFontFileLoader(p, a)
#define IDWriteFactory3_CreateTextFormat(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateTextFormat(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory3_CreateTypography(p, a) (p)->lpVtbl->CreateTypography(p, a)
#define IDWriteFactory3_GetGdiInterop(p, a) (p)->lpVtbl->GetGdiInterop(p, a)
#define IDWriteFactory3_CreateTextLayout(p, a, b, c, d, e, f) (p)->lpVtbl->CreateTextLayout(p, a, b, c, d, e, f)
#define IDWriteFactory3_CreateGdiCompatibleTextLayout(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->CreateGdiCompatibleTextLayout(p, a, b, c, d, e, f, g, h, i)
#define IDWriteFactory3_CreateEllipsisTrimmingSign(p, a, b) (p)->lpVtbl->CreateEllipsisTrimmingSign(p, a, b)
#define IDWriteFactory3_CreateTextAnalyzer(p, a) (p)->lpVtbl->CreateTextAnalyzer(p, a)
#define IDWriteFactory3_CreateNumberSubstitution(p, a, b, c, d) (p)->lpVtbl->CreateNumberSubstitution(p, a, b, c, d)
#define IDWriteFactory3_CreateGlyphRunAnalysis(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateGlyphRunAnalysis(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory3_GetEudcFontCollection(p, a, b) (p)->lpVtbl->GetEudcFontCollection(p, a, b)
#define IDWriteFactory3_CreateCustomRenderingParams1(p, a, b, c, d, e, f, g) (p)->lpVtbl->CreateCustomRenderingParams1(p, a, b, c, d, e, f, g)
#define IDWriteFactory3_GetSystemFontFallback(p, a) (p)->lpVtbl->GetSystemFontFallback(p, a)
#define IDWriteFactory3_CreateFontFallbackBuilder(p, a) (p)->lpVtbl->CreateFontFallbackBuilder(p, a)
#define IDWriteFactory3_TranslateColorGlyphRun(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->TranslateColorGlyphRun(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory3_CreateCustomRenderingParams2(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateCustomRenderingParams2(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory3_CreateGlyphRunAnalysis1(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->CreateGlyphRunAnalysis1(p, a, b, c, d, e, f, g, h, i)
#define IDWriteFactory3_CreateGlyphRunAnalysis2(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->CreateGlyphRunAnalysis2(p, a, b, c, d, e, f, g, h, i)
#define IDWriteFactory3_CreateCustomRenderingParams3(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateCustomRenderingParams3(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory3_CreateFontFaceReference_(p, a, b, c, d) (p)->lpVtbl->CreateFontFaceReference_(p, a, b, c, d)
#define IDWriteFactory3_CreateFontFaceReference(p, a, b, c, d, e) (p)->lpVtbl->CreateFontFaceReference(p, a, b, c, d, e)
#define IDWriteFactory3_GetSystemFontSet(p, a) (p)->lpVtbl->GetSystemFontSet(p, a)
#define IDWriteFactory3_CreateFontSetBuilder(p, a) (p)->lpVtbl->CreateFontSetBuilder(p, a)
#define IDWriteFactory3_CreateFontCollectionFromFontSet(p, a, b) (p)->lpVtbl->CreateFontCollectionFromFontSet(p, a, b)
#define IDWriteFactory3_GetSystemFontCollection1(p, a, b, c) (p)->lpVtbl->GetSystemFontCollection1(p, a, b, c)
#define IDWriteFactory3_GetFontDownloadQueue(p, a) (p)->lpVtbl->GetFontDownloadQueue(p, a)

' ============================================================================
' IDWriteFontFace4
' ============================================================================
Type IDWriteFontFace4Vtbl As IDWriteFontFace4Vtbl_
Type IDWriteFontFace4
    lpVtbl As IDWriteFontFace4Vtbl Ptr
End Type
Type IDWriteFontFace4Vtbl_     '' Extends IDWriteFontFace3_Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFontFace4 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontFace4 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontFace4 Ptr) As ULong
        
    GetType As Function(ByVal This As IDWriteFontFace4 Ptr) As DWRITE_FONT_FACE_TYPE
        ' 5. GetFiles
    GetFiles As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal number_of_files As ULong Ptr, ByVal fontfiles As Any Ptr Ptr ) As HRESULT
        ' 6. GetIndex
    GetIndex As Function(ByVal This As IDWriteFontFace4 Ptr) As ULong
        ' 7. GetSimulations
    GetSimulations As Function(ByVal This As IDWriteFontFace4 Ptr) As DWRITE_FONT_SIMULATIONS
        ' 8. IsSymbolFont
    IsSymbolFont As Function(ByVal This As IDWriteFontFace4 Ptr) As Long
        ' 9. GetMetrics
    GetMetrics As Sub(ByVal This As IDWriteFontFace4 Ptr,  ByVal metrics As DWRITE_FONT_METRICS Ptr )
        ' 10. GetGlyphCount
    GetGlyphCount As Function(ByVal This As IDWriteFontFace4 Ptr) As UShort
        ' 11. GetDesignGlyphMetrics
    GetDesignGlyphMetrics As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal glyph_indices As UShort Ptr, ByVal glyph_count As ULong, ByVal metrics As DWRITE_GLYPH_METRICS Ptr, ByVal is_sideways As Long ) As HRESULT
        ' 12. GetGlyphIndices
    GetGlyphIndices As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal codepoints As ULong Ptr, ByVal count As ULong, ByVal glyph_indices As UShort Ptr ) As HRESULT
        ' 13. TryGetFontTable
    TryGetFontTable As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal table_tag As ULong, ByVal table_data As Any Ptr Ptr, ByVal table_size As ULong Ptr, ByVal context As Any Ptr Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 14. ReleaseFontTable
    ReleaseFontTable As Sub(ByVal This As IDWriteFontFace4 Ptr,  ByVal table_context As Any Ptr )
        ' 15. GetGlyphRunOutline
    GetGlyphRunOutline As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal emSize As Single, ByVal glyph_indices As UShort Ptr, ByVal glyph_advances As Single Ptr, ByVal glyph_offsets As DWRITE_GLYPH_OFFSET Ptr, ByVal glyph_count As ULong, ByVal is_sideways As Long, ByVal is_rtl As Long, ByVal geometrysink As Any Ptr ) As HRESULT
        ' 16. GetRecommendedRenderingMode
    GetRecommendedRenderingMode As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal mode As DWRITE_MEASURING_MODE, ByVal params As IDWriteRenderingParams Ptr, ByVal rendering_mode As DWRITE_RENDERING_MODE Ptr ) As HRESULT
        ' 17. GetGdiCompatibleMetrics
    GetGdiCompatibleMetrics As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal metrics As DWRITE_FONT_METRICS Ptr ) As HRESULT
        ' 18. GetGdiCompatibleGlyphMetrics
    GetGdiCompatibleGlyphMetrics As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal use_gdi_natural As Long, ByVal glyph_indices As UShort Ptr, ByVal glyph_count As ULong, ByVal metrics As DWRITE_GLYPH_METRICS Ptr, ByVal is_sideways As Long ) As HRESULT
        
    GetMetrics1 As Sub(ByVal This As IDWriteFontFace4 Ptr,  ByVal metrics As DWRITE_FONT_METRICS1 Ptr )
        ' 20. GetGdiCompatibleMetrics
    GetGdiCompatibleMetrics1 As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal emSize As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal metrics As DWRITE_FONT_METRICS1 Ptr ) As HRESULT
        ' 21. GetCaretMetrics
    GetCaretMetrics As Sub(ByVal This As IDWriteFontFace4 Ptr,  ByVal metrics As DWRITE_CARET_METRICS Ptr )
        ' 22. GetUnicodeRanges
    GetUnicodeRanges As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal maxCount As ULong, ByVal ranges As DWRITE_UNICODE_RANGE Ptr, ByVal count As ULong Ptr ) As HRESULT
        ' 23. IsMonospacedFont
    IsMonospacedFont As Function(ByVal This As IDWriteFontFace4 Ptr) As Long
        ' 24. GetDesignGlyphAdvances
    GetDesignGlyphAdvances As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal glyphCount As ULong, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvances As Long Ptr, ByVal isSideways As Long = 0 ) As HRESULT
        ' 25. GetGdiCompatibleGlyphAdvances
    GetGdiCompatibleGlyphAdvances As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal emSize As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal useGdiNatural As Long, ByVal isSideways As Long, ByVal glyphCount As ULong, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvances As Long Ptr ) As HRESULT
        ' 26. GetKerningPairAdjustments
    GetKerningPairAdjustments As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal glyphCount As ULong, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvanceAdjustments As Long Ptr ) As HRESULT
        ' 27. HasKerningPairs
    HasKerningPairs As Function(ByVal This As IDWriteFontFace4 Ptr) As Long
        ' 28. GetRecommendedRenderingMode
    GetRecommendedRenderingMode1 As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal fontEmSize As Single, ByVal dpiX As Single, ByVal dpiY As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal isSideways As Long, ByVal outlineThreshold As DWRITE_OUTLINE_THRESHOLD, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal renderingMode As DWRITE_RENDERING_MODE Ptr ) As HRESULT
        ' 29. GetVerticalGlyphVariants
    GetVerticalGlyphVariants As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal glyphCount As ULong, ByVal nominalGlyphIndices As UShort Ptr, ByVal verticalGlyphIndices As UShort Ptr ) As HRESULT
        ' 30. HasVerticalGlyphVariants
    HasVerticalGlyphVariants As Function(ByVal This As IDWriteFontFace4 Ptr) As Long
        
    IsColorFont As Function(ByVal This As IDWriteFontFace4 Ptr) As Long
        ' 32. GetColorPaletteCount
    GetColorPaletteCount As Function(ByVal This As IDWriteFontFace4 Ptr) As ULong
        ' 33. GetPaletteEntryCount
    GetPaletteEntryCount As Function(ByVal This As IDWriteFontFace4 Ptr) As ULong
        ' 34. GetPaletteEntries
    GetPaletteEntries As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal colorPaletteIndex As ULong, ByVal firstEntryIndex As ULong, ByVal entryCount As ULong, ByVal paletteEntries As DWRITE_COLOR_F Ptr ) As HRESULT
        ' 35. GetRecommendedRenderingMode
    GetRecommendedRenderingMode2 As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal fontEmSize As Single, ByVal dpiX As Single, ByVal dpiY As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal isSideways As Long, ByVal outlineThreshold As DWRITE_OUTLINE_THRESHOLD, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal renderingParams As IDWriteRenderingParams Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE Ptr, ByVal gridFitMode As DWRITE_GRID_FIT_MODE Ptr ) As HRESULT
        
    GetFontFaceReference As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 37. GetPanose
    GetPanose As Sub(ByVal This As IDWriteFontFace4 Ptr,  ByVal panose As DWRITE_PANOSE Ptr )
        ' 38. GetWeight
    GetWeight As Function(ByVal This As IDWriteFontFace4 Ptr) As DWRITE_FONT_WEIGHT
        ' 39. GetStretch
    GetStretch As Function(ByVal This As IDWriteFontFace4 Ptr) As DWRITE_FONT_STRETCH
        ' 40. GetStyle
    GetStyle As Function(ByVal This As IDWriteFontFace4 Ptr) As DWRITE_FONT_STYLE
        ' 41. GetFamilyNames
    GetFamilyNames As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal names As IDWriteLocalizedStrings Ptr Ptr ) As HRESULT
        ' 42. GetFaceNames
    GetFaceNames As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal names As IDWriteLocalizedStrings Ptr Ptr ) As HRESULT
        ' 43. GetInformationalStrings
    GetInformationalStrings As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal informationalStringID As DWRITE_INFORMATIONAL_STRING_ID, ByVal informationalStrings As IDWriteLocalizedStrings Ptr Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 44. HasCharacter
    HasCharacter As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal unicodeValue As ULong ) As Long
        ' 45. GetRecommendedRenderingMode
    GetRecommendedRenderingMode3 As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal fontEmSize As Single, ByVal dpiX As Single, ByVal dpiY As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal isSideways As Long, ByVal outlineThreshold As DWRITE_OUTLINE_THRESHOLD, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal renderingParams As IDWriteRenderingParams Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE1 Ptr, ByVal gridFitMode As DWRITE_GRID_FIT_MODE Ptr ) As HRESULT
        ' 46. IsCharacterLocal
    IsCharacterLocal As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal unicodeValue As ULong ) As Long
        ' 47. IsGlyphLocal
    IsGlyphLocal As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal glyphId As UShort ) As Long
        ' 48. AreCharactersLocal
    AreCharactersLocal As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal characters As WString Ptr, ByVal characterCount As ULong, ByVal enqueueIfNotLocal As Long, ByVal isLocal As Long Ptr ) As HRESULT
        ' 49. AreGlyphsLocal
    AreGlyphsLocal As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal glyphIndices As UShort Ptr, ByVal glyphCount As ULong, ByVal enqueueIfNotLocal As Long, ByVal isLocal As Long Ptr ) As HRESULT

        
    GetGlyphImageFormats_ As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal glyphId As UShort, ByVal pixelsPerEmFirst As ULong, ByVal pixelsPerEmLast As ULong, ByVal glyphImageFormats As DWRITE_GLYPH_IMAGE_FORMATS Ptr ) As HRESULT
        ' 51. GetGlyphImageFormats (all supported formats)
    GetGlyphImageFormats As Function(ByVal This As IDWriteFontFace4 Ptr) As DWRITE_GLYPH_IMAGE_FORMATS
        ' 52. GetGlyphImageData
    GetGlyphImageData As Function(ByVal This As IDWriteFontFace4 Ptr,  ByVal glyphId As UShort, ByVal pixelsPerEm As ULong, ByVal glyphImageFormat As DWRITE_GLYPH_IMAGE_FORMATS, ByVal glyphData As DWRITE_GLYPH_IMAGE_DATA Ptr, ByVal glyphDataContext As Any Ptr Ptr ) As HRESULT
        ' 53. ReleaseGlyphImageData
    ReleaseGlyphImageData As Sub(ByVal This As IDWriteFontFace4 Ptr,  ByVal glyphDataContext As Any Ptr )
End Type
#define IDWriteFontFace4_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontFace4_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontFace4_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontFace4_GetType(p, a) (p)->lpVtbl->GetType(p, a)
#define IDWriteFontFace4_GetFiles(p, a, b) (p)->lpVtbl->GetFiles(p, a, b)
#define IDWriteFontFace4_GetIndex(p, a) (p)->lpVtbl->GetIndex(p, a)
#define IDWriteFontFace4_GetSimulations(p, a) (p)->lpVtbl->GetSimulations(p, a)
#define IDWriteFontFace4_IsSymbolFont(p, a) (p)->lpVtbl->IsSymbolFont(p, a)
#define IDWriteFontFace4_GetMetrics(p, a) (p)->lpVtbl->GetMetrics(p, a)
#define IDWriteFontFace4_GetGlyphCount(p, a) (p)->lpVtbl->GetGlyphCount(p, a)
#define IDWriteFontFace4_GetDesignGlyphMetrics(p, a, b, c, d) (p)->lpVtbl->GetDesignGlyphMetrics(p, a, b, c, d)
#define IDWriteFontFace4_GetGlyphIndices(p, a, b, c) (p)->lpVtbl->GetGlyphIndices(p, a, b, c)
#define IDWriteFontFace4_TryGetFontTable(p, a, b, c, d, e) (p)->lpVtbl->TryGetFontTable(p, a, b, c, d, e)
#define IDWriteFontFace4_ReleaseFontTable(p, a) (p)->lpVtbl->ReleaseFontTable(p, a)
#define IDWriteFontFace4_GetGlyphRunOutline(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGlyphRunOutline(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace4_GetRecommendedRenderingMode(p, a, b, c, d, e) (p)->lpVtbl->GetRecommendedRenderingMode(p, a, b, c, d, e)
#define IDWriteFontFace4_GetGdiCompatibleMetrics(p, a, b, c, d) (p)->lpVtbl->GetGdiCompatibleMetrics(p, a, b, c, d)
#define IDWriteFontFace4_GetGdiCompatibleGlyphMetrics(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGdiCompatibleGlyphMetrics(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace4_GetMetrics1(p, a) (p)->lpVtbl->GetMetrics1(p, a)
#define IDWriteFontFace4_GetGdiCompatibleMetrics1(p, a, b, c, d) (p)->lpVtbl->GetGdiCompatibleMetrics1(p, a, b, c, d)
#define IDWriteFontFace4_GetCaretMetrics(p, a) (p)->lpVtbl->GetCaretMetrics(p, a)
#define IDWriteFontFace4_GetUnicodeRanges(p, a, b, c) (p)->lpVtbl->GetUnicodeRanges(p, a, b, c)
#define IDWriteFontFace4_IsMonospacedFont(p, a) (p)->lpVtbl->IsMonospacedFont(p, a)
#define IDWriteFontFace4_GetDesignGlyphAdvances(p, a, b, c, d) (p)->lpVtbl->GetDesignGlyphAdvances(p, a, b, c, d)
#define IDWriteFontFace4_GetGdiCompatibleGlyphAdvances(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGdiCompatibleGlyphAdvances(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace4_GetKerningPairAdjustments(p, a, b, c) (p)->lpVtbl->GetKerningPairAdjustments(p, a, b, c)
#define IDWriteFontFace4_HasKerningPairs(p, a) (p)->lpVtbl->HasKerningPairs(p, a)
#define IDWriteFontFace4_GetRecommendedRenderingMode1(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetRecommendedRenderingMode1(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace4_GetVerticalGlyphVariants(p, a, b, c) (p)->lpVtbl->GetVerticalGlyphVariants(p, a, b, c)
#define IDWriteFontFace4_HasVerticalGlyphVariants(p, a) (p)->lpVtbl->HasVerticalGlyphVariants(p, a)
#define IDWriteFontFace4_IsColorFont(p, a) (p)->lpVtbl->IsColorFont(p, a)
#define IDWriteFontFace4_GetColorPaletteCount(p, a) (p)->lpVtbl->GetColorPaletteCount(p, a)
#define IDWriteFontFace4_GetPaletteEntryCount(p, a) (p)->lpVtbl->GetPaletteEntryCount(p, a)
#define IDWriteFontFace4_GetPaletteEntries(p, a, b, c, d) (p)->lpVtbl->GetPaletteEntries(p, a, b, c, d)
#define IDWriteFontFace4_GetRecommendedRenderingMode2(p, a, b, c, d, e, f, g, h, i, j) (p)->lpVtbl->GetRecommendedRenderingMode2(p, a, b, c, d, e, f, g, h, i, j)
#define IDWriteFontFace4_GetFontFaceReference(p, a) (p)->lpVtbl->GetFontFaceReference(p, a)
#define IDWriteFontFace4_GetPanose(p, a) (p)->lpVtbl->GetPanose(p, a)
#define IDWriteFontFace4_GetWeight(p, a) (p)->lpVtbl->GetWeight(p, a)
#define IDWriteFontFace4_GetStretch(p, a) (p)->lpVtbl->GetStretch(p, a)
#define IDWriteFontFace4_GetStyle(p, a) (p)->lpVtbl->GetStyle(p, a)
#define IDWriteFontFace4_GetFamilyNames(p, a) (p)->lpVtbl->GetFamilyNames(p, a)
#define IDWriteFontFace4_GetFaceNames(p, a) (p)->lpVtbl->GetFaceNames(p, a)
#define IDWriteFontFace4_GetInformationalStrings(p, a, b, c) (p)->lpVtbl->GetInformationalStrings(p, a, b, c)
#define IDWriteFontFace4_HasCharacter(p, a) (p)->lpVtbl->HasCharacter(p, a)
#define IDWriteFontFace4_GetRecommendedRenderingMode3(p, a, b, c, d, e, f, g, h, i, j) (p)->lpVtbl->GetRecommendedRenderingMode3(p, a, b, c, d, e, f, g, h, i, j)
#define IDWriteFontFace4_IsCharacterLocal(p, a) (p)->lpVtbl->IsCharacterLocal(p, a)
#define IDWriteFontFace4_IsGlyphLocal(p, a) (p)->lpVtbl->IsGlyphLocal(p, a)
#define IDWriteFontFace4_AreCharactersLocal(p, a, b, c, d) (p)->lpVtbl->AreCharactersLocal(p, a, b, c, d)
#define IDWriteFontFace4_AreGlyphsLocal(p, a, b, c, d) (p)->lpVtbl->AreGlyphsLocal(p, a, b, c, d)
#define IDWriteFontFace4_GetGlyphImageFormats_(p, a, b, c, d) (p)->lpVtbl->GetGlyphImageFormats_(p, a, b, c, d)
#define IDWriteFontFace4_GetGlyphImageFormats(p, a) (p)->lpVtbl->GetGlyphImageFormats(p, a)
#define IDWriteFontFace4_GetGlyphImageData(p, a, b, c, d, e) (p)->lpVtbl->GetGlyphImageData(p, a, b, c, d, e)
#define IDWriteFontFace4_ReleaseGlyphImageData(p, a) (p)->lpVtbl->ReleaseGlyphImageData(p, a)

' ============================================================================
' IDWriteFontFace5
' ============================================================================
Type IDWriteFontFace5_Vtbl As IDWriteFontFace5_Vtbl_
Type IDWriteFontFace5_
    lpVtbl As IDWriteFontFace5_Vtbl Ptr
End Type
Type IDWriteFontFace5_Vtbl_     '' Extends IDWriteFontFace4Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFontFace5_ Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontFace5_ Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontFace5_ Ptr) As ULong
        
    GetType As Function(ByVal This As IDWriteFontFace5_ Ptr) As DWRITE_FONT_FACE_TYPE
        ' 5. GetFiles
    GetFiles As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal number_of_files As ULong Ptr, ByVal fontfiles As Any Ptr Ptr ) As HRESULT
        ' 6. GetIndex
    GetIndex As Function(ByVal This As IDWriteFontFace5_ Ptr) As ULong
        ' 7. GetSimulations
    GetSimulations As Function(ByVal This As IDWriteFontFace5_ Ptr) As DWRITE_FONT_SIMULATIONS
        ' 8. IsSymbolFont
    IsSymbolFont As Function(ByVal This As IDWriteFontFace5_ Ptr) As Long
        ' 9. GetMetrics
    GetMetrics As Sub(ByVal This As IDWriteFontFace5_ Ptr,  ByVal metrics As DWRITE_FONT_METRICS Ptr )
        ' 10. GetGlyphCount
    GetGlyphCount As Function(ByVal This As IDWriteFontFace5_ Ptr) As UShort
        ' 11. GetDesignGlyphMetrics
    GetDesignGlyphMetrics As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal glyph_indices As UShort Ptr, ByVal glyph_count As ULong, ByVal metrics As DWRITE_GLYPH_METRICS Ptr, ByVal is_sideways As Long ) As HRESULT
        ' 12. GetGlyphIndices
    GetGlyphIndices As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal codepoints As ULong Ptr, ByVal count As ULong, ByVal glyph_indices As UShort Ptr ) As HRESULT
        ' 13. TryGetFontTable
    TryGetFontTable As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal table_tag As ULong, ByVal table_data As Any Ptr Ptr, ByVal table_size As ULong Ptr, ByVal context As Any Ptr Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 14. ReleaseFontTable
    ReleaseFontTable As Sub(ByVal This As IDWriteFontFace5_ Ptr,  ByVal table_context As Any Ptr )
        ' 15. GetGlyphRunOutline
    GetGlyphRunOutline As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal emSize As Single, ByVal glyph_indices As UShort Ptr, ByVal glyph_advances As Single Ptr, ByVal glyph_offsets As DWRITE_GLYPH_OFFSET Ptr, ByVal glyph_count As ULong, ByVal is_sideways As Long, ByVal is_rtl As Long, ByVal geometrysink As Any Ptr ) As HRESULT
        ' 16. GetRecommendedRenderingMode
    GetRecommendedRenderingMode As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal mode As DWRITE_MEASURING_MODE, ByVal params As IDWriteRenderingParams Ptr, ByVal rendering_mode As DWRITE_RENDERING_MODE Ptr ) As HRESULT
        ' 17. GetGdiCompatibleMetrics
    GetGdiCompatibleMetrics As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal metrics As DWRITE_FONT_METRICS Ptr ) As HRESULT
        ' 18. GetGdiCompatibleGlyphMetrics
    GetGdiCompatibleGlyphMetrics As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal use_gdi_natural As Long, ByVal glyph_indices As UShort Ptr, ByVal glyph_count As ULong, ByVal metrics As DWRITE_GLYPH_METRICS Ptr, ByVal is_sideways As Long ) As HRESULT
        
    GetMetrics1 As Sub(ByVal This As IDWriteFontFace5_ Ptr,  ByVal metrics As DWRITE_FONT_METRICS1 Ptr )
        ' 20. GetGdiCompatibleMetrics
    GetGdiCompatibleMetrics1 As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal emSize As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal metrics As DWRITE_FONT_METRICS1 Ptr ) As HRESULT
        ' 21. GetCaretMetrics
    GetCaretMetrics As Sub(ByVal This As IDWriteFontFace5_ Ptr,  ByVal metrics As DWRITE_CARET_METRICS Ptr )
        ' 22. GetUnicodeRanges
    GetUnicodeRanges As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal maxCount As ULong, ByVal ranges As DWRITE_UNICODE_RANGE Ptr, ByVal count As ULong Ptr ) As HRESULT
        ' 23. IsMonospacedFont
    IsMonospacedFont As Function(ByVal This As IDWriteFontFace5_ Ptr) As Long
        ' 24. GetDesignGlyphAdvances
    GetDesignGlyphAdvances As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal glyphCount As ULong, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvances As Long Ptr, ByVal isSideways As Long = 0 ) As HRESULT
        ' 25. GetGdiCompatibleGlyphAdvances
    GetGdiCompatibleGlyphAdvances As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal emSize As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal useGdiNatural As Long, ByVal isSideways As Long, ByVal glyphCount As ULong, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvances As Long Ptr ) As HRESULT
        ' 26. GetKerningPairAdjustments
    GetKerningPairAdjustments As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal glyphCount As ULong, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvanceAdjustments As Long Ptr ) As HRESULT
        ' 27. HasKerningPairs
    HasKerningPairs As Function(ByVal This As IDWriteFontFace5_ Ptr) As Long
        ' 28. GetRecommendedRenderingMode
    GetRecommendedRenderingMode1 As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal fontEmSize As Single, ByVal dpiX As Single, ByVal dpiY As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal isSideways As Long, ByVal outlineThreshold As DWRITE_OUTLINE_THRESHOLD, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal renderingMode As DWRITE_RENDERING_MODE Ptr ) As HRESULT
        ' 29. GetVerticalGlyphVariants
    GetVerticalGlyphVariants As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal glyphCount As ULong, ByVal nominalGlyphIndices As UShort Ptr, ByVal verticalGlyphIndices As UShort Ptr ) As HRESULT
        ' 30. HasVerticalGlyphVariants
    HasVerticalGlyphVariants As Function(ByVal This As IDWriteFontFace5_ Ptr) As Long
        
    IsColorFont As Function(ByVal This As IDWriteFontFace5_ Ptr) As Long
        ' 32. GetColorPaletteCount
    GetColorPaletteCount As Function(ByVal This As IDWriteFontFace5_ Ptr) As ULong
        ' 33. GetPaletteEntryCount
    GetPaletteEntryCount As Function(ByVal This As IDWriteFontFace5_ Ptr) As ULong
        ' 34. GetPaletteEntries
    GetPaletteEntries As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal colorPaletteIndex As ULong, ByVal firstEntryIndex As ULong, ByVal entryCount As ULong, ByVal paletteEntries As DWRITE_COLOR_F Ptr ) As HRESULT
        ' 35. GetRecommendedRenderingMode
    GetRecommendedRenderingMode2 As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal fontEmSize As Single, ByVal dpiX As Single, ByVal dpiY As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal isSideways As Long, ByVal outlineThreshold As DWRITE_OUTLINE_THRESHOLD, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal renderingParams As IDWriteRenderingParams Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE Ptr, ByVal gridFitMode As DWRITE_GRID_FIT_MODE Ptr ) As HRESULT
        
    GetFontFaceReference As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 37. GetPanose
    GetPanose As Sub(ByVal This As IDWriteFontFace5_ Ptr,  ByVal panose As DWRITE_PANOSE Ptr )
        ' 38. GetWeight
    GetWeight As Function(ByVal This As IDWriteFontFace5_ Ptr) As DWRITE_FONT_WEIGHT
        ' 39. GetStretch
    GetStretch As Function(ByVal This As IDWriteFontFace5_ Ptr) As DWRITE_FONT_STRETCH
        ' 40. GetStyle
    GetStyle As Function(ByVal This As IDWriteFontFace5_ Ptr) As DWRITE_FONT_STYLE
        ' 41. GetFamilyNames
    GetFamilyNames As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal names As IDWriteLocalizedStrings Ptr Ptr ) As HRESULT
        ' 42. GetFaceNames
    GetFaceNames As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal names As IDWriteLocalizedStrings Ptr Ptr ) As HRESULT
        ' 43. GetInformationalStrings
    GetInformationalStrings As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal informationalStringID As DWRITE_INFORMATIONAL_STRING_ID, ByVal informationalStrings As IDWriteLocalizedStrings Ptr Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 44. HasCharacter
    HasCharacter As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal unicodeValue As ULong ) As Long
        ' 45. GetRecommendedRenderingMode
    GetRecommendedRenderingMode3 As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal fontEmSize As Single, ByVal dpiX As Single, ByVal dpiY As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal isSideways As Long, ByVal outlineThreshold As DWRITE_OUTLINE_THRESHOLD, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal renderingParams As IDWriteRenderingParams Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE1 Ptr, ByVal gridFitMode As DWRITE_GRID_FIT_MODE Ptr ) As HRESULT
        ' 46. IsCharacterLocal
    IsCharacterLocal As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal unicodeValue As ULong ) As Long
        ' 47. IsGlyphLocal
    IsGlyphLocal As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal glyphId As UShort ) As Long
        ' 48. AreCharactersLocal
    AreCharactersLocal As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal characters As WString Ptr, ByVal characterCount As ULong, ByVal enqueueIfNotLocal As Long, ByVal isLocal As Long Ptr ) As HRESULT
        ' 49. AreGlyphsLocal
    AreGlyphsLocal As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal glyphIndices As UShort Ptr, ByVal glyphCount As ULong, ByVal enqueueIfNotLocal As Long, ByVal isLocal As Long Ptr ) As HRESULT
        
    GetGlyphImageFormats_ As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal glyphId As UShort, ByVal pixelsPerEmFirst As ULong, ByVal pixelsPerEmLast As ULong, ByVal glyphImageFormats As DWRITE_GLYPH_IMAGE_FORMATS Ptr ) As HRESULT
        ' 51. GetGlyphImageFormats (all supported formats)
    GetGlyphImageFormats As Function(ByVal This As IDWriteFontFace5_ Ptr) As DWRITE_GLYPH_IMAGE_FORMATS
        ' 52. GetGlyphImageData
    GetGlyphImageData As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal glyphId As UShort, ByVal pixelsPerEm As ULong, ByVal glyphImageFormat As DWRITE_GLYPH_IMAGE_FORMATS, ByVal glyphData As DWRITE_GLYPH_IMAGE_DATA Ptr, ByVal glyphDataContext As Any Ptr Ptr ) As HRESULT
        ' 53. ReleaseGlyphImageData
    ReleaseGlyphImageData As Sub(ByVal This As IDWriteFontFace5_ Ptr,  ByVal glyphDataContext As Any Ptr )

        
    GetFontAxisValueCount As Function(ByVal This As IDWriteFontFace5_ Ptr) As ULong
        ' 55. GetFontAxisValues
    GetFontAxisValues As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong ) As HRESULT
        ' 56. HasVariations
    HasVariations As Function(ByVal This As IDWriteFontFace5_ Ptr) As Long
        ' 57. GetFontResource
    GetFontResource As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal fontResource As IDWriteFontResource Ptr Ptr ) As HRESULT
        ' 58. Equals
    Equals As Function(ByVal This As IDWriteFontFace5_ Ptr,  ByVal fontFace As IDWriteFontFace Ptr ) As Long
End Type
#define IDWriteFontFace5__QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontFace5__AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontFace5__Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontFace5__GetType(p, a) (p)->lpVtbl->GetType(p, a)
#define IDWriteFontFace5__GetFiles(p, a, b) (p)->lpVtbl->GetFiles(p, a, b)
#define IDWriteFontFace5__GetIndex(p, a) (p)->lpVtbl->GetIndex(p, a)
#define IDWriteFontFace5__GetSimulations(p, a) (p)->lpVtbl->GetSimulations(p, a)
#define IDWriteFontFace5__IsSymbolFont(p, a) (p)->lpVtbl->IsSymbolFont(p, a)
#define IDWriteFontFace5__GetMetrics(p, a) (p)->lpVtbl->GetMetrics(p, a)
#define IDWriteFontFace5__GetGlyphCount(p, a) (p)->lpVtbl->GetGlyphCount(p, a)
#define IDWriteFontFace5__GetDesignGlyphMetrics(p, a, b, c, d) (p)->lpVtbl->GetDesignGlyphMetrics(p, a, b, c, d)
#define IDWriteFontFace5__GetGlyphIndices(p, a, b, c) (p)->lpVtbl->GetGlyphIndices(p, a, b, c)
#define IDWriteFontFace5__TryGetFontTable(p, a, b, c, d, e) (p)->lpVtbl->TryGetFontTable(p, a, b, c, d, e)
#define IDWriteFontFace5__ReleaseFontTable(p, a) (p)->lpVtbl->ReleaseFontTable(p, a)
#define IDWriteFontFace5__GetGlyphRunOutline(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGlyphRunOutline(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace5__GetRecommendedRenderingMode(p, a, b, c, d, e) (p)->lpVtbl->GetRecommendedRenderingMode(p, a, b, c, d, e)
#define IDWriteFontFace5__GetGdiCompatibleMetrics(p, a, b, c, d) (p)->lpVtbl->GetGdiCompatibleMetrics(p, a, b, c, d)
#define IDWriteFontFace5__GetGdiCompatibleGlyphMetrics(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGdiCompatibleGlyphMetrics(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace5__GetMetrics1(p, a) (p)->lpVtbl->GetMetrics1(p, a)
#define IDWriteFontFace5__GetGdiCompatibleMetrics1(p, a, b, c, d) (p)->lpVtbl->GetGdiCompatibleMetrics1(p, a, b, c, d)
#define IDWriteFontFace5__GetCaretMetrics(p, a) (p)->lpVtbl->GetCaretMetrics(p, a)
#define IDWriteFontFace5__GetUnicodeRanges(p, a, b, c) (p)->lpVtbl->GetUnicodeRanges(p, a, b, c)
#define IDWriteFontFace5__IsMonospacedFont(p, a) (p)->lpVtbl->IsMonospacedFont(p, a)
#define IDWriteFontFace5__GetDesignGlyphAdvances(p, a, b, c, d) (p)->lpVtbl->GetDesignGlyphAdvances(p, a, b, c, d)
#define IDWriteFontFace5__GetGdiCompatibleGlyphAdvances(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGdiCompatibleGlyphAdvances(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace5__GetKerningPairAdjustments(p, a, b, c) (p)->lpVtbl->GetKerningPairAdjustments(p, a, b, c)
#define IDWriteFontFace5__HasKerningPairs(p, a) (p)->lpVtbl->HasKerningPairs(p, a)
#define IDWriteFontFace5__GetRecommendedRenderingMode1(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetRecommendedRenderingMode1(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace5__GetVerticalGlyphVariants(p, a, b, c) (p)->lpVtbl->GetVerticalGlyphVariants(p, a, b, c)
#define IDWriteFontFace5__HasVerticalGlyphVariants(p, a) (p)->lpVtbl->HasVerticalGlyphVariants(p, a)
#define IDWriteFontFace5__IsColorFont(p, a) (p)->lpVtbl->IsColorFont(p, a)
#define IDWriteFontFace5__GetColorPaletteCount(p, a) (p)->lpVtbl->GetColorPaletteCount(p, a)
#define IDWriteFontFace5__GetPaletteEntryCount(p, a) (p)->lpVtbl->GetPaletteEntryCount(p, a)
#define IDWriteFontFace5__GetPaletteEntries(p, a, b, c, d) (p)->lpVtbl->GetPaletteEntries(p, a, b, c, d)
#define IDWriteFontFace5__GetRecommendedRenderingMode2(p, a, b, c, d, e, f, g, h, i, j) (p)->lpVtbl->GetRecommendedRenderingMode2(p, a, b, c, d, e, f, g, h, i, j)
#define IDWriteFontFace5__GetFontFaceReference(p, a) (p)->lpVtbl->GetFontFaceReference(p, a)
#define IDWriteFontFace5__GetPanose(p, a) (p)->lpVtbl->GetPanose(p, a)
#define IDWriteFontFace5__GetWeight(p, a) (p)->lpVtbl->GetWeight(p, a)
#define IDWriteFontFace5__GetStretch(p, a) (p)->lpVtbl->GetStretch(p, a)
#define IDWriteFontFace5__GetStyle(p, a) (p)->lpVtbl->GetStyle(p, a)
#define IDWriteFontFace5__GetFamilyNames(p, a) (p)->lpVtbl->GetFamilyNames(p, a)
#define IDWriteFontFace5__GetFaceNames(p, a) (p)->lpVtbl->GetFaceNames(p, a)
#define IDWriteFontFace5__GetInformationalStrings(p, a, b, c) (p)->lpVtbl->GetInformationalStrings(p, a, b, c)
#define IDWriteFontFace5__HasCharacter(p, a) (p)->lpVtbl->HasCharacter(p, a)
#define IDWriteFontFace5__GetRecommendedRenderingMode3(p, a, b, c, d, e, f, g, h, i, j) (p)->lpVtbl->GetRecommendedRenderingMode3(p, a, b, c, d, e, f, g, h, i, j)
#define IDWriteFontFace5__IsCharacterLocal(p, a) (p)->lpVtbl->IsCharacterLocal(p, a)
#define IDWriteFontFace5__IsGlyphLocal(p, a) (p)->lpVtbl->IsGlyphLocal(p, a)
#define IDWriteFontFace5__AreCharactersLocal(p, a, b, c, d) (p)->lpVtbl->AreCharactersLocal(p, a, b, c, d)
#define IDWriteFontFace5__AreGlyphsLocal(p, a, b, c, d) (p)->lpVtbl->AreGlyphsLocal(p, a, b, c, d)
#define IDWriteFontFace5__GetGlyphImageFormats_(p, a, b, c, d) (p)->lpVtbl->GetGlyphImageFormats_(p, a, b, c, d)
#define IDWriteFontFace5__GetGlyphImageFormats(p, a) (p)->lpVtbl->GetGlyphImageFormats(p, a)
#define IDWriteFontFace5__GetGlyphImageData(p, a, b, c, d, e) (p)->lpVtbl->GetGlyphImageData(p, a, b, c, d, e)
#define IDWriteFontFace5__ReleaseGlyphImageData(p, a) (p)->lpVtbl->ReleaseGlyphImageData(p, a)
#define IDWriteFontFace5__GetFontAxisValueCount(p, a) (p)->lpVtbl->GetFontAxisValueCount(p, a)
#define IDWriteFontFace5__GetFontAxisValues(p, a, b) (p)->lpVtbl->GetFontAxisValues(p, a, b)
#define IDWriteFontFace5__HasVariations(p, a) (p)->lpVtbl->HasVariations(p, a)
#define IDWriteFontFace5__GetFontResource(p, a) (p)->lpVtbl->GetFontResource(p, a)
#define IDWriteFontFace5__Equals(p, a) (p)->lpVtbl->Equals(p, a)

' ============================================================================
' IDWriteFontFace6
' ============================================================================
Type IDWriteFontFace6Vtbl As IDWriteFontFace6Vtbl_
Type IDWriteFontFace6
    lpVtbl As IDWriteFontFace6Vtbl Ptr
End Type
Type IDWriteFontFace6Vtbl_     '' Extends IDWriteFontFace5_Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFontFace6 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontFace6 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontFace6 Ptr) As ULong
        
    GetType As Function(ByVal This As IDWriteFontFace6 Ptr) As DWRITE_FONT_FACE_TYPE
        ' 5. GetFiles
    GetFiles As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal number_of_files As ULong Ptr, ByVal fontfiles As Any Ptr Ptr ) As HRESULT
        ' 6. GetIndex
    GetIndex As Function(ByVal This As IDWriteFontFace6 Ptr) As ULong
        ' 7. GetSimulations
    GetSimulations As Function(ByVal This As IDWriteFontFace6 Ptr) As DWRITE_FONT_SIMULATIONS
        ' 8. IsSymbolFont
    IsSymbolFont As Function(ByVal This As IDWriteFontFace6 Ptr) As Long
        ' 9. GetMetrics
    GetMetrics As Sub(ByVal This As IDWriteFontFace6 Ptr,  ByVal metrics As DWRITE_FONT_METRICS Ptr )
        ' 10. GetGlyphCount
    GetGlyphCount As Function(ByVal This As IDWriteFontFace6 Ptr) As UShort
        ' 11. GetDesignGlyphMetrics
    GetDesignGlyphMetrics As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal glyph_indices As UShort Ptr, ByVal glyph_count As ULong, ByVal metrics As DWRITE_GLYPH_METRICS Ptr, ByVal is_sideways As Long ) As HRESULT
        ' 12. GetGlyphIndices
    GetGlyphIndices As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal codepoints As ULong Ptr, ByVal count As ULong, ByVal glyph_indices As UShort Ptr ) As HRESULT
        ' 13. TryGetFontTable
    TryGetFontTable As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal table_tag As ULong, ByVal table_data As Any Ptr Ptr, ByVal table_size As ULong Ptr, ByVal context As Any Ptr Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 14. ReleaseFontTable
    ReleaseFontTable As Sub(ByVal This As IDWriteFontFace6 Ptr,  ByVal table_context As Any Ptr )
        ' 15. GetGlyphRunOutline
    GetGlyphRunOutline As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal emSize As Single, ByVal glyph_indices As UShort Ptr, ByVal glyph_advances As Single Ptr, ByVal glyph_offsets As DWRITE_GLYPH_OFFSET Ptr, ByVal glyph_count As ULong, ByVal is_sideways As Long, ByVal is_rtl As Long, ByVal geometrysink As Any Ptr ) As HRESULT
        ' 16. GetRecommendedRenderingMode
    GetRecommendedRenderingMode As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal mode As DWRITE_MEASURING_MODE, ByVal params As IDWriteRenderingParams Ptr, ByVal rendering_mode As DWRITE_RENDERING_MODE Ptr ) As HRESULT
        ' 17. GetGdiCompatibleMetrics
    GetGdiCompatibleMetrics As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal metrics As DWRITE_FONT_METRICS Ptr ) As HRESULT
        ' 18. GetGdiCompatibleGlyphMetrics
    GetGdiCompatibleGlyphMetrics As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal use_gdi_natural As Long, ByVal glyph_indices As UShort Ptr, ByVal glyph_count As ULong, ByVal metrics As DWRITE_GLYPH_METRICS Ptr, ByVal is_sideways As Long ) As HRESULT
        
    GetMetrics1 As Sub(ByVal This As IDWriteFontFace6 Ptr,  ByVal metrics As DWRITE_FONT_METRICS1 Ptr )
        ' 20. GetGdiCompatibleMetrics
    GetGdiCompatibleMetrics1 As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal emSize As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal metrics As DWRITE_FONT_METRICS1 Ptr ) As HRESULT
        ' 21. GetCaretMetrics
    GetCaretMetrics As Sub(ByVal This As IDWriteFontFace6 Ptr,  ByVal metrics As DWRITE_CARET_METRICS Ptr )
        ' 22. GetUnicodeRanges
    GetUnicodeRanges As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal maxCount As ULong, ByVal ranges As DWRITE_UNICODE_RANGE Ptr, ByVal count As ULong Ptr ) As HRESULT
        ' 23. IsMonospacedFont
    IsMonospacedFont As Function(ByVal This As IDWriteFontFace6 Ptr) As Long
        ' 24. GetDesignGlyphAdvances
    GetDesignGlyphAdvances As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal glyphCount As ULong, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvances As Long Ptr, ByVal isSideways As Long = 0 ) As HRESULT
        ' 25. GetGdiCompatibleGlyphAdvances
    GetGdiCompatibleGlyphAdvances As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal emSize As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal useGdiNatural As Long, ByVal isSideways As Long, ByVal glyphCount As ULong, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvances As Long Ptr ) As HRESULT
        ' 26. GetKerningPairAdjustments
    GetKerningPairAdjustments As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal glyphCount As ULong, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvanceAdjustments As Long Ptr ) As HRESULT
        ' 27. HasKerningPairs
    HasKerningPairs As Function(ByVal This As IDWriteFontFace6 Ptr) As Long
        ' 28. GetRecommendedRenderingMode
    GetRecommendedRenderingMode1 As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal fontEmSize As Single, ByVal dpiX As Single, ByVal dpiY As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal isSideways As Long, ByVal outlineThreshold As DWRITE_OUTLINE_THRESHOLD, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal renderingMode As DWRITE_RENDERING_MODE Ptr ) As HRESULT
        ' 29. GetVerticalGlyphVariants
    GetVerticalGlyphVariants As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal glyphCount As ULong, ByVal nominalGlyphIndices As UShort Ptr, ByVal verticalGlyphIndices As UShort Ptr ) As HRESULT
        ' 30. HasVerticalGlyphVariants
    HasVerticalGlyphVariants As Function(ByVal This As IDWriteFontFace6 Ptr) As Long
        
    IsColorFont As Function(ByVal This As IDWriteFontFace6 Ptr) As Long
        ' 32. GetColorPaletteCount
    GetColorPaletteCount As Function(ByVal This As IDWriteFontFace6 Ptr) As ULong
        ' 33. GetPaletteEntryCount
    GetPaletteEntryCount As Function(ByVal This As IDWriteFontFace6 Ptr) As ULong
        ' 34. GetPaletteEntries
    GetPaletteEntries As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal colorPaletteIndex As ULong, ByVal firstEntryIndex As ULong, ByVal entryCount As ULong, ByVal paletteEntries As DWRITE_COLOR_F Ptr ) As HRESULT
        ' 35. GetRecommendedRenderingMode
    GetRecommendedRenderingMode2 As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal fontEmSize As Single, ByVal dpiX As Single, ByVal dpiY As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal isSideways As Long, ByVal outlineThreshold As DWRITE_OUTLINE_THRESHOLD, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal renderingParams As IDWriteRenderingParams Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE Ptr, ByVal gridFitMode As DWRITE_GRID_FIT_MODE Ptr ) As HRESULT
        
    GetFontFaceReference As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 37. GetPanose
    GetPanose As Sub(ByVal This As IDWriteFontFace6 Ptr,  ByVal panose As DWRITE_PANOSE Ptr )
        ' 38. GetWeight
    GetWeight As Function(ByVal This As IDWriteFontFace6 Ptr) As DWRITE_FONT_WEIGHT
        ' 39. GetStretch
    GetStretch As Function(ByVal This As IDWriteFontFace6 Ptr) As DWRITE_FONT_STRETCH
        ' 40. GetStyle
    GetStyle As Function(ByVal This As IDWriteFontFace6 Ptr) As DWRITE_FONT_STYLE
        ' 41. GetFamilyNames
    GetFamilyNames As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal names As IDWriteLocalizedStrings Ptr Ptr ) As HRESULT
        ' 42. GetFaceNames
    GetFaceNames As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal names As IDWriteLocalizedStrings Ptr Ptr ) As HRESULT
        ' 43. GetInformationalStrings
    GetInformationalStrings As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal informationalStringID As DWRITE_INFORMATIONAL_STRING_ID, ByVal informationalStrings As IDWriteLocalizedStrings Ptr Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 44. HasCharacter
    HasCharacter As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal unicodeValue As ULong ) As Long
        ' 45. GetRecommendedRenderingMode
    GetRecommendedRenderingMode3 As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal fontEmSize As Single, ByVal dpiX As Single, ByVal dpiY As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal isSideways As Long, ByVal outlineThreshold As DWRITE_OUTLINE_THRESHOLD, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal renderingParams As IDWriteRenderingParams Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE1 Ptr, ByVal gridFitMode As DWRITE_GRID_FIT_MODE Ptr ) As HRESULT
        ' 46. IsCharacterLocal
    IsCharacterLocal As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal unicodeValue As ULong ) As Long
        ' 47. IsGlyphLocal
    IsGlyphLocal As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal glyphId As UShort ) As Long
        ' 48. AreCharactersLocal
    AreCharactersLocal As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal characters As WString Ptr, ByVal characterCount As ULong, ByVal enqueueIfNotLocal As Long, ByVal isLocal As Long Ptr ) As HRESULT
        ' 49. AreGlyphsLocal
    AreGlyphsLocal As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal glyphIndices As UShort Ptr, ByVal glyphCount As ULong, ByVal enqueueIfNotLocal As Long, ByVal isLocal As Long Ptr ) As HRESULT
        
    GetGlyphImageFormats_ As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal glyphId As UShort, ByVal pixelsPerEmFirst As ULong, ByVal pixelsPerEmLast As ULong, ByVal glyphImageFormats As DWRITE_GLYPH_IMAGE_FORMATS Ptr ) As HRESULT
        ' 51. GetGlyphImageFormats (all supported formats)
    GetGlyphImageFormats As Function(ByVal This As IDWriteFontFace6 Ptr) As DWRITE_GLYPH_IMAGE_FORMATS
        ' 52. GetGlyphImageData
    GetGlyphImageData As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal glyphId As UShort, ByVal pixelsPerEm As ULong, ByVal glyphImageFormat As DWRITE_GLYPH_IMAGE_FORMATS, ByVal glyphData As DWRITE_GLYPH_IMAGE_DATA Ptr, ByVal glyphDataContext As Any Ptr Ptr ) As HRESULT
        ' 53. ReleaseGlyphImageData
    ReleaseGlyphImageData As Sub(ByVal This As IDWriteFontFace6 Ptr,  ByVal glyphDataContext As Any Ptr )
        
    GetFontAxisValueCount As Function(ByVal This As IDWriteFontFace6 Ptr) As ULong
        ' 55. GetFontAxisValues
    GetFontAxisValues As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong ) As HRESULT
        ' 56. HasVariations
    HasVariations As Function(ByVal This As IDWriteFontFace6 Ptr) As Long
        ' 57. GetFontResource
    GetFontResource As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal fontResource As IDWriteFontResource Ptr Ptr ) As HRESULT
        ' 58. Equals
    Equals As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal fontFace As IDWriteFontFace Ptr ) As Long

        
    GetFamilyNames1 As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal fontFamilyModel As DWRITE_FONT_FAMILY_MODEL, ByVal names As IDWriteLocalizedStrings Ptr Ptr ) As HRESULT
        ' 60. GetFaceNames
    GetFaceNames1 As Function(ByVal This As IDWriteFontFace6 Ptr,  ByVal fontFamilyModel As DWRITE_FONT_FAMILY_MODEL, ByVal names As IDWriteLocalizedStrings Ptr Ptr ) As HRESULT
End Type
#define IDWriteFontFace6_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontFace6_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontFace6_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontFace6_GetType(p, a) (p)->lpVtbl->GetType(p, a)
#define IDWriteFontFace6_GetFiles(p, a, b) (p)->lpVtbl->GetFiles(p, a, b)
#define IDWriteFontFace6_GetIndex(p, a) (p)->lpVtbl->GetIndex(p, a)
#define IDWriteFontFace6_GetSimulations(p, a) (p)->lpVtbl->GetSimulations(p, a)
#define IDWriteFontFace6_IsSymbolFont(p, a) (p)->lpVtbl->IsSymbolFont(p, a)
#define IDWriteFontFace6_GetMetrics(p, a) (p)->lpVtbl->GetMetrics(p, a)
#define IDWriteFontFace6_GetGlyphCount(p, a) (p)->lpVtbl->GetGlyphCount(p, a)
#define IDWriteFontFace6_GetDesignGlyphMetrics(p, a, b, c, d) (p)->lpVtbl->GetDesignGlyphMetrics(p, a, b, c, d)
#define IDWriteFontFace6_GetGlyphIndices(p, a, b, c) (p)->lpVtbl->GetGlyphIndices(p, a, b, c)
#define IDWriteFontFace6_TryGetFontTable(p, a, b, c, d, e) (p)->lpVtbl->TryGetFontTable(p, a, b, c, d, e)
#define IDWriteFontFace6_ReleaseFontTable(p, a) (p)->lpVtbl->ReleaseFontTable(p, a)
#define IDWriteFontFace6_GetGlyphRunOutline(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGlyphRunOutline(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace6_GetRecommendedRenderingMode(p, a, b, c, d, e) (p)->lpVtbl->GetRecommendedRenderingMode(p, a, b, c, d, e)
#define IDWriteFontFace6_GetGdiCompatibleMetrics(p, a, b, c, d) (p)->lpVtbl->GetGdiCompatibleMetrics(p, a, b, c, d)
#define IDWriteFontFace6_GetGdiCompatibleGlyphMetrics(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGdiCompatibleGlyphMetrics(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace6_GetMetrics1(p, a) (p)->lpVtbl->GetMetrics1(p, a)
#define IDWriteFontFace6_GetGdiCompatibleMetrics1(p, a, b, c, d) (p)->lpVtbl->GetGdiCompatibleMetrics1(p, a, b, c, d)
#define IDWriteFontFace6_GetCaretMetrics(p, a) (p)->lpVtbl->GetCaretMetrics(p, a)
#define IDWriteFontFace6_GetUnicodeRanges(p, a, b, c) (p)->lpVtbl->GetUnicodeRanges(p, a, b, c)
#define IDWriteFontFace6_IsMonospacedFont(p, a) (p)->lpVtbl->IsMonospacedFont(p, a)
#define IDWriteFontFace6_GetDesignGlyphAdvances(p, a, b, c, d) (p)->lpVtbl->GetDesignGlyphAdvances(p, a, b, c, d)
#define IDWriteFontFace6_GetGdiCompatibleGlyphAdvances(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGdiCompatibleGlyphAdvances(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace6_GetKerningPairAdjustments(p, a, b, c) (p)->lpVtbl->GetKerningPairAdjustments(p, a, b, c)
#define IDWriteFontFace6_HasKerningPairs(p, a) (p)->lpVtbl->HasKerningPairs(p, a)
#define IDWriteFontFace6_GetRecommendedRenderingMode1(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetRecommendedRenderingMode1(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace6_GetVerticalGlyphVariants(p, a, b, c) (p)->lpVtbl->GetVerticalGlyphVariants(p, a, b, c)
#define IDWriteFontFace6_HasVerticalGlyphVariants(p, a) (p)->lpVtbl->HasVerticalGlyphVariants(p, a)
#define IDWriteFontFace6_IsColorFont(p, a) (p)->lpVtbl->IsColorFont(p, a)
#define IDWriteFontFace6_GetColorPaletteCount(p, a) (p)->lpVtbl->GetColorPaletteCount(p, a)
#define IDWriteFontFace6_GetPaletteEntryCount(p, a) (p)->lpVtbl->GetPaletteEntryCount(p, a)
#define IDWriteFontFace6_GetPaletteEntries(p, a, b, c, d) (p)->lpVtbl->GetPaletteEntries(p, a, b, c, d)
#define IDWriteFontFace6_GetRecommendedRenderingMode2(p, a, b, c, d, e, f, g, h, i, j) (p)->lpVtbl->GetRecommendedRenderingMode2(p, a, b, c, d, e, f, g, h, i, j)
#define IDWriteFontFace6_GetFontFaceReference(p, a) (p)->lpVtbl->GetFontFaceReference(p, a)
#define IDWriteFontFace6_GetPanose(p, a) (p)->lpVtbl->GetPanose(p, a)
#define IDWriteFontFace6_GetWeight(p, a) (p)->lpVtbl->GetWeight(p, a)
#define IDWriteFontFace6_GetStretch(p, a) (p)->lpVtbl->GetStretch(p, a)
#define IDWriteFontFace6_GetStyle(p, a) (p)->lpVtbl->GetStyle(p, a)
#define IDWriteFontFace6_GetFamilyNames(p, a) (p)->lpVtbl->GetFamilyNames(p, a)
#define IDWriteFontFace6_GetFaceNames(p, a) (p)->lpVtbl->GetFaceNames(p, a)
#define IDWriteFontFace6_GetInformationalStrings(p, a, b, c) (p)->lpVtbl->GetInformationalStrings(p, a, b, c)
#define IDWriteFontFace6_HasCharacter(p, a) (p)->lpVtbl->HasCharacter(p, a)
#define IDWriteFontFace6_GetRecommendedRenderingMode3(p, a, b, c, d, e, f, g, h, i, j) (p)->lpVtbl->GetRecommendedRenderingMode3(p, a, b, c, d, e, f, g, h, i, j)
#define IDWriteFontFace6_IsCharacterLocal(p, a) (p)->lpVtbl->IsCharacterLocal(p, a)
#define IDWriteFontFace6_IsGlyphLocal(p, a) (p)->lpVtbl->IsGlyphLocal(p, a)
#define IDWriteFontFace6_AreCharactersLocal(p, a, b, c, d) (p)->lpVtbl->AreCharactersLocal(p, a, b, c, d)
#define IDWriteFontFace6_AreGlyphsLocal(p, a, b, c, d) (p)->lpVtbl->AreGlyphsLocal(p, a, b, c, d)
#define IDWriteFontFace6_GetGlyphImageFormats_(p, a, b, c, d) (p)->lpVtbl->GetGlyphImageFormats_(p, a, b, c, d)
#define IDWriteFontFace6_GetGlyphImageFormats(p, a) (p)->lpVtbl->GetGlyphImageFormats(p, a)
#define IDWriteFontFace6_GetGlyphImageData(p, a, b, c, d, e) (p)->lpVtbl->GetGlyphImageData(p, a, b, c, d, e)
#define IDWriteFontFace6_ReleaseGlyphImageData(p, a) (p)->lpVtbl->ReleaseGlyphImageData(p, a)
#define IDWriteFontFace6_GetFontAxisValueCount(p, a) (p)->lpVtbl->GetFontAxisValueCount(p, a)
#define IDWriteFontFace6_GetFontAxisValues(p, a, b) (p)->lpVtbl->GetFontAxisValues(p, a, b)
#define IDWriteFontFace6_HasVariations(p, a) (p)->lpVtbl->HasVariations(p, a)
#define IDWriteFontFace6_GetFontResource(p, a) (p)->lpVtbl->GetFontResource(p, a)
#define IDWriteFontFace6_Equals(p, a) (p)->lpVtbl->Equals(p, a)
#define IDWriteFontFace6_GetFamilyNames1(p, a, b) (p)->lpVtbl->GetFamilyNames1(p, a, b)
#define IDWriteFontFace6_GetFaceNames1(p, a, b) (p)->lpVtbl->GetFaceNames1(p, a, b)

' ============================================================================
' IDWritePaintReader
' ============================================================================
Type IDWritePaintReaderVtbl As IDWritePaintReaderVtbl_
Type IDWritePaintReader
    lpVtbl As IDWritePaintReaderVtbl Ptr
End Type
Type IDWritePaintReaderVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWritePaintReader Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWritePaintReader Ptr) As ULong
    Release As Function(ByVal This As IDWritePaintReader Ptr) As ULong

        
    SetCurrentGlyph As Function(ByVal This As IDWritePaintReader Ptr,  ByVal glyphIndex As ULong, ByVal paintElement As DWRITE_PAINT_ELEMENT Ptr, ByVal structSize As ULong, ByVal clipBox As D2D1_RECT_F Ptr, ByVal glyphAttributes As DWRITE_PAINT_ATTRIBUTES Ptr = 0 ) As HRESULT
        ' 5. SetTextColor
    SetTextColor As Function(ByVal This As IDWritePaintReader Ptr,  ByVal textColor As DWRITE_COLOR_F Ptr ) As HRESULT
        ' 6. SetColorPaletteIndex
    SetColorPaletteIndex As Function(ByVal This As IDWritePaintReader Ptr,  ByVal colorPaletteIndex As ULong ) As HRESULT
        ' 7. SetCustomColorPalette
    SetCustomColorPalette As Function(ByVal This As IDWritePaintReader Ptr,  ByVal paletteEntries As DWRITE_COLOR_F Ptr, ByVal paletteEntryCount As ULong ) As HRESULT
        ' 8. MoveToFirstChild
    MoveToFirstChild As Function(ByVal This As IDWritePaintReader Ptr,  ByVal paintElement As DWRITE_PAINT_ELEMENT Ptr, ByVal structSize As ULong ) As HRESULT
        ' 9. MoveToNextSibling
    MoveToNextSibling As Function(ByVal This As IDWritePaintReader Ptr,  ByVal paintElement As DWRITE_PAINT_ELEMENT Ptr, ByVal structSize As ULong ) As HRESULT
        ' 10. MoveToParent
    MoveToParent As Function(ByVal This As IDWritePaintReader Ptr) As HRESULT
        ' 11. GetGradientStops
    GetGradientStops As Function(ByVal This As IDWritePaintReader Ptr,  ByVal firstGradientStopIndex As ULong, ByVal gradientStopCount As ULong, ByVal gradientStops As D2D1_GRADIENT_STOP Ptr ) As HRESULT
        ' 12. GetGradientStopColors
    GetGradientStopColors As Function(ByVal This As IDWritePaintReader Ptr,  ByVal firstGradientStopIndex As ULong, ByVal gradientStopCount As ULong, ByVal gradientStopColors As DWRITE_PAINT_COLOR Ptr ) As HRESULT
End Type
#define IDWritePaintReader_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWritePaintReader_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWritePaintReader_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWritePaintReader_SetCurrentGlyph(p, a, b, c, d, e) (p)->lpVtbl->SetCurrentGlyph(p, a, b, c, d, e)
#define IDWritePaintReader_SetTextColor(p, a) (p)->lpVtbl->SetTextColor(p, a)
#define IDWritePaintReader_SetColorPaletteIndex(p, a) (p)->lpVtbl->SetColorPaletteIndex(p, a)
#define IDWritePaintReader_SetCustomColorPalette(p, a, b) (p)->lpVtbl->SetCustomColorPalette(p, a, b)
#define IDWritePaintReader_MoveToFirstChild(p, a, b) (p)->lpVtbl->MoveToFirstChild(p, a, b)
#define IDWritePaintReader_MoveToNextSibling(p, a, b) (p)->lpVtbl->MoveToNextSibling(p, a, b)
#define IDWritePaintReader_MoveToParent(p, a) (p)->lpVtbl->MoveToParent(p, a)
#define IDWritePaintReader_GetGradientStops(p, a, b, c) (p)->lpVtbl->GetGradientStops(p, a, b, c)
#define IDWritePaintReader_GetGradientStopColors(p, a, b, c) (p)->lpVtbl->GetGradientStopColors(p, a, b, c)

' ============================================================================
' IDWriteFontFace7
' ============================================================================
Type IDWriteFontFace7Vtbl As IDWriteFontFace7Vtbl_
Type IDWriteFontFace7
    lpVtbl As IDWriteFontFace7Vtbl Ptr
End Type
Type IDWriteFontFace7Vtbl_     '' Extends IDWriteFontFace6Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFontFace7 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontFace7 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontFace7 Ptr) As ULong
        
    GetType As Function(ByVal This As IDWriteFontFace7 Ptr) As DWRITE_FONT_FACE_TYPE
        ' 5. GetFiles
    GetFiles As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal number_of_files As ULong Ptr, ByVal fontfiles As Any Ptr Ptr ) As HRESULT
        ' 6. GetIndex
    GetIndex As Function(ByVal This As IDWriteFontFace7 Ptr) As ULong
        ' 7. GetSimulations
    GetSimulations As Function(ByVal This As IDWriteFontFace7 Ptr) As DWRITE_FONT_SIMULATIONS
        ' 8. IsSymbolFont
    IsSymbolFont As Function(ByVal This As IDWriteFontFace7 Ptr) As Long
        ' 9. GetMetrics
    GetMetrics As Sub(ByVal This As IDWriteFontFace7 Ptr,  ByVal metrics As DWRITE_FONT_METRICS Ptr )
        ' 10. GetGlyphCount
    GetGlyphCount As Function(ByVal This As IDWriteFontFace7 Ptr) As UShort
        ' 11. GetDesignGlyphMetrics
    GetDesignGlyphMetrics As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal glyph_indices As UShort Ptr, ByVal glyph_count As ULong, ByVal metrics As DWRITE_GLYPH_METRICS Ptr, ByVal is_sideways As Long ) As HRESULT
        ' 12. GetGlyphIndices
    GetGlyphIndices As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal codepoints As ULong Ptr, ByVal count As ULong, ByVal glyph_indices As UShort Ptr ) As HRESULT
        ' 13. TryGetFontTable
    TryGetFontTable As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal table_tag As ULong, ByVal table_data As Any Ptr Ptr, ByVal table_size As ULong Ptr, ByVal context As Any Ptr Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 14. ReleaseFontTable
    ReleaseFontTable As Sub(ByVal This As IDWriteFontFace7 Ptr,  ByVal table_context As Any Ptr )
        ' 15. GetGlyphRunOutline
    GetGlyphRunOutline As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal emSize As Single, ByVal glyph_indices As UShort Ptr, ByVal glyph_advances As Single Ptr, ByVal glyph_offsets As DWRITE_GLYPH_OFFSET Ptr, ByVal glyph_count As ULong, ByVal is_sideways As Long, ByVal is_rtl As Long, ByVal geometrysink As Any Ptr ) As HRESULT
        ' 16. GetRecommendedRenderingMode
    GetRecommendedRenderingMode As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal mode As DWRITE_MEASURING_MODE, ByVal params As IDWriteRenderingParams Ptr, ByVal rendering_mode As DWRITE_RENDERING_MODE Ptr ) As HRESULT
        ' 17. GetGdiCompatibleMetrics
    GetGdiCompatibleMetrics As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal metrics As DWRITE_FONT_METRICS Ptr ) As HRESULT
        ' 18. GetGdiCompatibleGlyphMetrics
    GetGdiCompatibleGlyphMetrics As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal use_gdi_natural As Long, ByVal glyph_indices As UShort Ptr, ByVal glyph_count As ULong, ByVal metrics As DWRITE_GLYPH_METRICS Ptr, ByVal is_sideways As Long ) As HRESULT
        
    GetMetrics1 As Sub(ByVal This As IDWriteFontFace7 Ptr,  ByVal metrics As DWRITE_FONT_METRICS1 Ptr )
        ' 20. GetGdiCompatibleMetrics
    GetGdiCompatibleMetrics1 As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal emSize As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal metrics As DWRITE_FONT_METRICS1 Ptr ) As HRESULT
        ' 21. GetCaretMetrics
    GetCaretMetrics As Sub(ByVal This As IDWriteFontFace7 Ptr,  ByVal metrics As DWRITE_CARET_METRICS Ptr )
        ' 22. GetUnicodeRanges
    GetUnicodeRanges As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal maxCount As ULong, ByVal ranges As DWRITE_UNICODE_RANGE Ptr, ByVal count As ULong Ptr ) As HRESULT
        ' 23. IsMonospacedFont
    IsMonospacedFont As Function(ByVal This As IDWriteFontFace7 Ptr) As Long
        ' 24. GetDesignGlyphAdvances
    GetDesignGlyphAdvances As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal glyphCount As ULong, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvances As Long Ptr, ByVal isSideways As Long = 0 ) As HRESULT
        ' 25. GetGdiCompatibleGlyphAdvances
    GetGdiCompatibleGlyphAdvances As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal emSize As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal useGdiNatural As Long, ByVal isSideways As Long, ByVal glyphCount As ULong, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvances As Long Ptr ) As HRESULT
        ' 26. GetKerningPairAdjustments
    GetKerningPairAdjustments As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal glyphCount As ULong, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvanceAdjustments As Long Ptr ) As HRESULT
        ' 27. HasKerningPairs
    HasKerningPairs As Function(ByVal This As IDWriteFontFace7 Ptr) As Long
        ' 28. GetRecommendedRenderingMode
    GetRecommendedRenderingMode1 As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal fontEmSize As Single, ByVal dpiX As Single, ByVal dpiY As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal isSideways As Long, ByVal outlineThreshold As DWRITE_OUTLINE_THRESHOLD, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal renderingMode As DWRITE_RENDERING_MODE Ptr ) As HRESULT
        ' 29. GetVerticalGlyphVariants
    GetVerticalGlyphVariants As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal glyphCount As ULong, ByVal nominalGlyphIndices As UShort Ptr, ByVal verticalGlyphIndices As UShort Ptr ) As HRESULT
        ' 30. HasVerticalGlyphVariants
    HasVerticalGlyphVariants As Function(ByVal This As IDWriteFontFace7 Ptr) As Long
        
    IsColorFont As Function(ByVal This As IDWriteFontFace7 Ptr) As Long
        ' 32. GetColorPaletteCount
    GetColorPaletteCount As Function(ByVal This As IDWriteFontFace7 Ptr) As ULong
        ' 33. GetPaletteEntryCount
    GetPaletteEntryCount As Function(ByVal This As IDWriteFontFace7 Ptr) As ULong
        ' 34. GetPaletteEntries
    GetPaletteEntries As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal colorPaletteIndex As ULong, ByVal firstEntryIndex As ULong, ByVal entryCount As ULong, ByVal paletteEntries As DWRITE_COLOR_F Ptr ) As HRESULT
        ' 35. GetRecommendedRenderingMode
    GetRecommendedRenderingMode2 As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal fontEmSize As Single, ByVal dpiX As Single, ByVal dpiY As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal isSideways As Long, ByVal outlineThreshold As DWRITE_OUTLINE_THRESHOLD, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal renderingParams As IDWriteRenderingParams Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE Ptr, ByVal gridFitMode As DWRITE_GRID_FIT_MODE Ptr ) As HRESULT
        
    GetFontFaceReference As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 37. GetPanose
    GetPanose As Sub(ByVal This As IDWriteFontFace7 Ptr,  ByVal panose As DWRITE_PANOSE Ptr )
        ' 38. GetWeight
    GetWeight As Function(ByVal This As IDWriteFontFace7 Ptr) As DWRITE_FONT_WEIGHT
        ' 39. GetStretch
    GetStretch As Function(ByVal This As IDWriteFontFace7 Ptr) As DWRITE_FONT_STRETCH
        ' 40. GetStyle
    GetStyle As Function(ByVal This As IDWriteFontFace7 Ptr) As DWRITE_FONT_STYLE
        ' 41. GetFamilyNames
    GetFamilyNames As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal names As IDWriteLocalizedStrings Ptr Ptr ) As HRESULT
        ' 42. GetFaceNames
    GetFaceNames As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal names As IDWriteLocalizedStrings Ptr Ptr ) As HRESULT
        ' 43. GetInformationalStrings
    GetInformationalStrings As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal informationalStringID As DWRITE_INFORMATIONAL_STRING_ID, ByVal informationalStrings As IDWriteLocalizedStrings Ptr Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 44. HasCharacter
    HasCharacter As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal unicodeValue As ULong ) As Long
        ' 45. GetRecommendedRenderingMode
    GetRecommendedRenderingMode3 As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal fontEmSize As Single, ByVal dpiX As Single, ByVal dpiY As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal isSideways As Long, ByVal outlineThreshold As DWRITE_OUTLINE_THRESHOLD, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal renderingParams As IDWriteRenderingParams Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE1 Ptr, ByVal gridFitMode As DWRITE_GRID_FIT_MODE Ptr ) As HRESULT
        ' 46. IsCharacterLocal
    IsCharacterLocal As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal unicodeValue As ULong ) As Long
        ' 47. IsGlyphLocal
    IsGlyphLocal As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal glyphId As UShort ) As Long
        ' 48. AreCharactersLocal
    AreCharactersLocal As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal characters As WString Ptr, ByVal characterCount As ULong, ByVal enqueueIfNotLocal As Long, ByVal isLocal As Long Ptr ) As HRESULT
        ' 49. AreGlyphsLocal
    AreGlyphsLocal As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal glyphIndices As UShort Ptr, ByVal glyphCount As ULong, ByVal enqueueIfNotLocal As Long, ByVal isLocal As Long Ptr ) As HRESULT
        
    GetGlyphImageFormats_ As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal glyphId As UShort, ByVal pixelsPerEmFirst As ULong, ByVal pixelsPerEmLast As ULong, ByVal glyphImageFormats As DWRITE_GLYPH_IMAGE_FORMATS Ptr ) As HRESULT
        ' 51. GetGlyphImageFormats (all supported formats)
    GetGlyphImageFormats As Function(ByVal This As IDWriteFontFace7 Ptr) As DWRITE_GLYPH_IMAGE_FORMATS
        ' 52. GetGlyphImageData
    GetGlyphImageData As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal glyphId As UShort, ByVal pixelsPerEm As ULong, ByVal glyphImageFormat As DWRITE_GLYPH_IMAGE_FORMATS, ByVal glyphData As DWRITE_GLYPH_IMAGE_DATA Ptr, ByVal glyphDataContext As Any Ptr Ptr ) As HRESULT
        ' 53. ReleaseGlyphImageData
    ReleaseGlyphImageData As Sub(ByVal This As IDWriteFontFace7 Ptr,  ByVal glyphDataContext As Any Ptr )
        
    GetFontAxisValueCount As Function(ByVal This As IDWriteFontFace7 Ptr) As ULong
        ' 55. GetFontAxisValues
    GetFontAxisValues As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong ) As HRESULT
        ' 56. HasVariations
    HasVariations As Function(ByVal This As IDWriteFontFace7 Ptr) As Long
        ' 57. GetFontResource
    GetFontResource As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal fontResource As IDWriteFontResource Ptr Ptr ) As HRESULT
        ' 58. Equals
    Equals As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal fontFace As IDWriteFontFace Ptr ) As Long
        
    GetFamilyNames1 As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal fontFamilyModel As DWRITE_FONT_FAMILY_MODEL, ByVal names As IDWriteLocalizedStrings Ptr Ptr ) As HRESULT
        ' 60. GetFaceNames
    GetFaceNames1 As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal fontFamilyModel As DWRITE_FONT_FAMILY_MODEL, ByVal names As IDWriteLocalizedStrings Ptr Ptr ) As HRESULT

        
    GetPaintFeatureLevel As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal glyphImageFormat As DWRITE_GLYPH_IMAGE_FORMATS ) As DWRITE_PAINT_FEATURE_LEVEL
        ' 62. CreatePaintReader
    CreatePaintReader As Function(ByVal This As IDWriteFontFace7 Ptr,  ByVal glyphImageFormat As DWRITE_GLYPH_IMAGE_FORMATS, ByVal paintFeatureLevel As DWRITE_PAINT_FEATURE_LEVEL, ByVal paintReader As IDWritePaintReader Ptr Ptr ) As HRESULT
End Type
#define IDWriteFontFace7_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontFace7_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontFace7_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontFace7_GetType(p, a) (p)->lpVtbl->GetType(p, a)
#define IDWriteFontFace7_GetFiles(p, a, b) (p)->lpVtbl->GetFiles(p, a, b)
#define IDWriteFontFace7_GetIndex(p, a) (p)->lpVtbl->GetIndex(p, a)
#define IDWriteFontFace7_GetSimulations(p, a) (p)->lpVtbl->GetSimulations(p, a)
#define IDWriteFontFace7_IsSymbolFont(p, a) (p)->lpVtbl->IsSymbolFont(p, a)
#define IDWriteFontFace7_GetMetrics(p, a) (p)->lpVtbl->GetMetrics(p, a)
#define IDWriteFontFace7_GetGlyphCount(p, a) (p)->lpVtbl->GetGlyphCount(p, a)
#define IDWriteFontFace7_GetDesignGlyphMetrics(p, a, b, c, d) (p)->lpVtbl->GetDesignGlyphMetrics(p, a, b, c, d)
#define IDWriteFontFace7_GetGlyphIndices(p, a, b, c) (p)->lpVtbl->GetGlyphIndices(p, a, b, c)
#define IDWriteFontFace7_TryGetFontTable(p, a, b, c, d, e) (p)->lpVtbl->TryGetFontTable(p, a, b, c, d, e)
#define IDWriteFontFace7_ReleaseFontTable(p, a) (p)->lpVtbl->ReleaseFontTable(p, a)
#define IDWriteFontFace7_GetGlyphRunOutline(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGlyphRunOutline(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace7_GetRecommendedRenderingMode(p, a, b, c, d, e) (p)->lpVtbl->GetRecommendedRenderingMode(p, a, b, c, d, e)
#define IDWriteFontFace7_GetGdiCompatibleMetrics(p, a, b, c, d) (p)->lpVtbl->GetGdiCompatibleMetrics(p, a, b, c, d)
#define IDWriteFontFace7_GetGdiCompatibleGlyphMetrics(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGdiCompatibleGlyphMetrics(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace7_GetMetrics1(p, a) (p)->lpVtbl->GetMetrics1(p, a)
#define IDWriteFontFace7_GetGdiCompatibleMetrics1(p, a, b, c, d) (p)->lpVtbl->GetGdiCompatibleMetrics1(p, a, b, c, d)
#define IDWriteFontFace7_GetCaretMetrics(p, a) (p)->lpVtbl->GetCaretMetrics(p, a)
#define IDWriteFontFace7_GetUnicodeRanges(p, a, b, c) (p)->lpVtbl->GetUnicodeRanges(p, a, b, c)
#define IDWriteFontFace7_IsMonospacedFont(p, a) (p)->lpVtbl->IsMonospacedFont(p, a)
#define IDWriteFontFace7_GetDesignGlyphAdvances(p, a, b, c, d) (p)->lpVtbl->GetDesignGlyphAdvances(p, a, b, c, d)
#define IDWriteFontFace7_GetGdiCompatibleGlyphAdvances(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGdiCompatibleGlyphAdvances(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace7_GetKerningPairAdjustments(p, a, b, c) (p)->lpVtbl->GetKerningPairAdjustments(p, a, b, c)
#define IDWriteFontFace7_HasKerningPairs(p, a) (p)->lpVtbl->HasKerningPairs(p, a)
#define IDWriteFontFace7_GetRecommendedRenderingMode1(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetRecommendedRenderingMode1(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace7_GetVerticalGlyphVariants(p, a, b, c) (p)->lpVtbl->GetVerticalGlyphVariants(p, a, b, c)
#define IDWriteFontFace7_HasVerticalGlyphVariants(p, a) (p)->lpVtbl->HasVerticalGlyphVariants(p, a)
#define IDWriteFontFace7_IsColorFont(p, a) (p)->lpVtbl->IsColorFont(p, a)
#define IDWriteFontFace7_GetColorPaletteCount(p, a) (p)->lpVtbl->GetColorPaletteCount(p, a)
#define IDWriteFontFace7_GetPaletteEntryCount(p, a) (p)->lpVtbl->GetPaletteEntryCount(p, a)
#define IDWriteFontFace7_GetPaletteEntries(p, a, b, c, d) (p)->lpVtbl->GetPaletteEntries(p, a, b, c, d)
#define IDWriteFontFace7_GetRecommendedRenderingMode2(p, a, b, c, d, e, f, g, h, i, j) (p)->lpVtbl->GetRecommendedRenderingMode2(p, a, b, c, d, e, f, g, h, i, j)
#define IDWriteFontFace7_GetFontFaceReference(p, a) (p)->lpVtbl->GetFontFaceReference(p, a)
#define IDWriteFontFace7_GetPanose(p, a) (p)->lpVtbl->GetPanose(p, a)
#define IDWriteFontFace7_GetWeight(p, a) (p)->lpVtbl->GetWeight(p, a)
#define IDWriteFontFace7_GetStretch(p, a) (p)->lpVtbl->GetStretch(p, a)
#define IDWriteFontFace7_GetStyle(p, a) (p)->lpVtbl->GetStyle(p, a)
#define IDWriteFontFace7_GetFamilyNames(p, a) (p)->lpVtbl->GetFamilyNames(p, a)
#define IDWriteFontFace7_GetFaceNames(p, a) (p)->lpVtbl->GetFaceNames(p, a)
#define IDWriteFontFace7_GetInformationalStrings(p, a, b, c) (p)->lpVtbl->GetInformationalStrings(p, a, b, c)
#define IDWriteFontFace7_HasCharacter(p, a) (p)->lpVtbl->HasCharacter(p, a)
#define IDWriteFontFace7_GetRecommendedRenderingMode3(p, a, b, c, d, e, f, g, h, i, j) (p)->lpVtbl->GetRecommendedRenderingMode3(p, a, b, c, d, e, f, g, h, i, j)
#define IDWriteFontFace7_IsCharacterLocal(p, a) (p)->lpVtbl->IsCharacterLocal(p, a)
#define IDWriteFontFace7_IsGlyphLocal(p, a) (p)->lpVtbl->IsGlyphLocal(p, a)
#define IDWriteFontFace7_AreCharactersLocal(p, a, b, c, d) (p)->lpVtbl->AreCharactersLocal(p, a, b, c, d)
#define IDWriteFontFace7_AreGlyphsLocal(p, a, b, c, d) (p)->lpVtbl->AreGlyphsLocal(p, a, b, c, d)
#define IDWriteFontFace7_GetGlyphImageFormats_(p, a, b, c, d) (p)->lpVtbl->GetGlyphImageFormats_(p, a, b, c, d)
#define IDWriteFontFace7_GetGlyphImageFormats(p, a) (p)->lpVtbl->GetGlyphImageFormats(p, a)
#define IDWriteFontFace7_GetGlyphImageData(p, a, b, c, d, e) (p)->lpVtbl->GetGlyphImageData(p, a, b, c, d, e)
#define IDWriteFontFace7_ReleaseGlyphImageData(p, a) (p)->lpVtbl->ReleaseGlyphImageData(p, a)
#define IDWriteFontFace7_GetFontAxisValueCount(p, a) (p)->lpVtbl->GetFontAxisValueCount(p, a)
#define IDWriteFontFace7_GetFontAxisValues(p, a, b) (p)->lpVtbl->GetFontAxisValues(p, a, b)
#define IDWriteFontFace7_HasVariations(p, a) (p)->lpVtbl->HasVariations(p, a)
#define IDWriteFontFace7_GetFontResource(p, a) (p)->lpVtbl->GetFontResource(p, a)
#define IDWriteFontFace7_Equals(p, a) (p)->lpVtbl->Equals(p, a)
#define IDWriteFontFace7_GetFamilyNames1(p, a, b) (p)->lpVtbl->GetFamilyNames1(p, a, b)
#define IDWriteFontFace7_GetFaceNames1(p, a, b) (p)->lpVtbl->GetFaceNames1(p, a, b)
#define IDWriteFontFace7_GetPaintFeatureLevel(p, a) (p)->lpVtbl->GetPaintFeatureLevel(p, a)
#define IDWriteFontFace7_CreatePaintReader(p, a, b, c) (p)->lpVtbl->CreatePaintReader(p, a, b, c)

' ============================================================================
' IDWriteColorGlyphRunEnumerator1
' ============================================================================
Type IDWriteColorGlyphRunEnumerator1Vtbl As IDWriteColorGlyphRunEnumerator1Vtbl_
Type IDWriteColorGlyphRunEnumerator1
    lpVtbl As IDWriteColorGlyphRunEnumerator1Vtbl Ptr
End Type
Type IDWriteColorGlyphRunEnumerator1Vtbl_     '' Extends IDWriteColorGlyphRunEnumeratorVtbl_
    QueryInterface As Function(ByVal This As IDWriteColorGlyphRunEnumerator1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteColorGlyphRunEnumerator1 Ptr) As ULong
    Release As Function(ByVal This As IDWriteColorGlyphRunEnumerator1 Ptr) As ULong
        
    MoveNext As Function(ByVal This As IDWriteColorGlyphRunEnumerator1 Ptr,  ByVal hasRun As Long Ptr ) As HRESULT
        ' 5. GetCurrentRun
    GetCurrentRun As Function(ByVal This As IDWriteColorGlyphRunEnumerator1 Ptr,  ByVal colorGlyphRun As DWRITE_COLOR_GLYPH_RUN Ptr Ptr ) As HRESULT

        
    GetCurrentRun1 As Function(ByVal This As IDWriteColorGlyphRunEnumerator1 Ptr,  ByVal colorGlyphRun As DWRITE_COLOR_GLYPH_RUN1 Ptr Ptr ) As HRESULT
End Type
#define IDWriteColorGlyphRunEnumerator1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteColorGlyphRunEnumerator1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteColorGlyphRunEnumerator1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteColorGlyphRunEnumerator1_MoveNext(p, a) (p)->lpVtbl->MoveNext(p, a)
#define IDWriteColorGlyphRunEnumerator1_GetCurrentRun(p, a) (p)->lpVtbl->GetCurrentRun(p, a)
#define IDWriteColorGlyphRunEnumerator1_GetCurrentRun1(p, a) (p)->lpVtbl->GetCurrentRun1(p, a)

' ============================================================================
' IDWriteFactory4
' ============================================================================
Type IDWriteFactory4Vtbl As IDWriteFactory4Vtbl_
Type IDWriteFactory4
    lpVtbl As IDWriteFactory4Vtbl Ptr
End Type
Type IDWriteFactory4Vtbl_     '' Extends IDWriteFactory3Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFactory4 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFactory4 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFactory4 Ptr) As ULong
        
    GetSystemFontCollection As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal fontCollection As Any Ptr Ptr, ByVal checkForUpdates As Long = 0 ) As HRESULT
        ' 5. CreateCustomFontCollection
    CreateCustomFontCollection As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal collectionLoader As Any Ptr, ByVal collectionKey As Any Ptr, ByVal collectionKeySize As ULong, ByVal fontCollection As Any Ptr Ptr ) As HRESULT
        ' 6. RegisterFontCollectionLoader
    RegisterFontCollectionLoader As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal fontCollectionLoader As Any Ptr ) As HRESULT
        ' 7. UnregisterFontCollectionLoader
    UnregisterFontCollectionLoader As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal fontCollectionLoader As Any Ptr ) As HRESULT
        ' 8. CreateFontFileReference
    CreateFontFileReference As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal filePath As WString Ptr, ByVal lastWriteTime As FILETIME Ptr, ByVal fontFile As Any Ptr Ptr ) As HRESULT
        ' 9. CreateCustomFontFileReference
    CreateCustomFontFileReference As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal fontFileReferenceKey As Any Ptr, ByVal fontFileReferenceKeySize As ULong, ByVal fontFileLoader As Any Ptr, ByVal fontFile As Any Ptr Ptr ) As HRESULT
        ' 10. CreateFontFace
    CreateFontFace As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal fontFaceType As DWRITE_FONT_FACE_TYPE, ByVal numberOfFiles As ULong, ByVal fontFiles As Any Ptr Ptr, ByVal faceIndex As ULong, ByVal fontFaceSimulationFlags As DWRITE_FONT_SIMULATIONS, ByVal fontFace As Any Ptr Ptr ) As HRESULT
        ' 11. CreateRenderingParams
    CreateRenderingParams As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 12. CreateMonitorRenderingParams
    CreateMonitorRenderingParams As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal monitor As HMONITOR, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 13. CreateCustomRenderingParams
    CreateCustomRenderingParams As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 14. RegisterFontFileLoader
    RegisterFontFileLoader As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal fontFileLoader As Any Ptr ) As HRESULT
        ' 15. UnregisterFontFileLoader
    UnregisterFontFileLoader As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal fontFileLoader As Any Ptr ) As HRESULT
        ' 16. CreateTextFormat
    CreateTextFormat As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal fontFamilyName As WString Ptr, ByVal fontCollection As Any Ptr, ByVal fontWeight As DWRITE_FONT_WEIGHT, ByVal fontStyle As DWRITE_FONT_STYLE, ByVal fontStretch As DWRITE_FONT_STRETCH, ByVal fontSize As Single, ByVal localeName As WString Ptr, ByVal textFormat As IDWriteTextFormat Ptr Ptr ) As HRESULT
        ' 17. CreateTypography
    CreateTypography As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal typography As Any Ptr Ptr ) As HRESULT
        ' 18. GetGdiInterop
    GetGdiInterop As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal gdiInterop As Any Ptr Ptr ) As HRESULT
        ' 19. CreateTextLayout
    CreateTextLayout As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal string As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal maxWidth As Single, ByVal maxHeight As Single, ByVal textLayout As Any Ptr Ptr ) As HRESULT
        ' 20. CreateGdiCompatibleTextLayout
    CreateGdiCompatibleTextLayout As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal string As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal layoutWidth As Single, ByVal layoutHeight As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal useGdiNatural As Long, ByVal textLayout As Any Ptr Ptr ) As HRESULT
        ' 21. CreateEllipsisTrimmingSign
    CreateEllipsisTrimmingSign As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal textFormat As Any Ptr, ByVal trimmingSign As Any Ptr Ptr ) As HRESULT
        ' 22. CreateTextAnalyzer
    CreateTextAnalyzer As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal textAnalyzer As Any Ptr Ptr ) As HRESULT
        ' 23. CreateNumberSubstitution
    CreateNumberSubstitution As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal substitutionMethod As DWRITE_NUMBER_SUBSTITUTION_METHOD, ByVal localeName As WString Ptr, ByVal ignoreUserOverride As Long, ByVal numberSubstitution As Any Ptr Ptr ) As HRESULT
        ' 24. CreateGlyphRunAnalysis
    CreateGlyphRunAnalysis As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRunAnalysis As Any Ptr Ptr ) As HRESULT
        
    GetEudcFontCollection As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal collection As Any Ptr Ptr, ByVal checkForUpdates As Long = 0 ) As HRESULT
        ' 26. CreateCustomRenderingParams
    CreateCustomRenderingParams1 As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal enhancedContrastGrayscale As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        
    GetSystemFontFallback As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal fontFallback As IDWriteFontFallback Ptr Ptr ) As HRESULT
        ' 28. CreateFontFallbackBuilder
    CreateFontFallbackBuilder As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal fontFallbackBuilder As IDWriteFontFallbackBuilder Ptr Ptr ) As HRESULT
        ' 29. TranslateColorGlyphRun
    TranslateColorGlyphRun As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal worldToDeviceTransform As DWRITE_MATRIX Ptr, ByVal colorPaletteIndex As ULong, ByVal colorLayers As IDWriteColorGlyphRunEnumerator Ptr Ptr ) As HRESULT
        ' 30. CreateCustomRenderingParams
    CreateCustomRenderingParams2 As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal grayscaleEnhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal renderingParams As IDWriteRenderingParams2 Ptr Ptr ) As HRESULT
        ' 31. CreateGlyphRunAnalysis
    CreateGlyphRunAnalysis1 As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal transform As DWRITE_MATRIX Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal antialiasMode As DWRITE_TEXT_ANTIALIAS_MODE, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRunAnalysis As IDWriteGlyphRunAnalysis Ptr Ptr ) As HRESULT
        
    CreateGlyphRunAnalysis2 As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal transform As DWRITE_MATRIX Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE1, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal antialiasMode As DWRITE_TEXT_ANTIALIAS_MODE, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRunAnalysis As IDWriteGlyphRunAnalysis Ptr Ptr ) As HRESULT
        ' 33. CreateCustomRenderingParams
    CreateCustomRenderingParams3 As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal grayscaleEnhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE1, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal renderingParams As IDWriteRenderingParams3 Ptr Ptr ) As HRESULT
        ' 34. CreateFontFaceReference_ (from file)
    CreateFontFaceReference_ As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal fontFile As IDWriteFontFile Ptr, ByVal faceIndex As ULong, ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 35. CreateFontFaceReference (from path)
    CreateFontFaceReference As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal filePath As WString Ptr, ByVal lastWriteTime As FILETIME Ptr, ByVal faceIndex As ULong, ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 36. GetSystemFontSet
    GetSystemFontSet As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal fontSet As IDWriteFontSet Ptr Ptr ) As HRESULT
        ' 37. CreateFontSetBuilder
    CreateFontSetBuilder As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal fontSetBuilder As IDWriteFontSetBuilder Ptr Ptr ) As HRESULT
        ' 38. CreateFontCollectionFromFontSet
    CreateFontCollectionFromFontSet As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal fontSet As IDWriteFontSet Ptr, ByVal fontCollection As IDWriteFontCollection1 Ptr Ptr ) As HRESULT
        ' 39. GetSystemFontCollection
    GetSystemFontCollection1 As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal includeDownloadableFonts As Long, ByVal fontCollection As IDWriteFontCollection1 Ptr Ptr, ByVal checkForUpdates As Long ) As HRESULT
        ' 40. GetFontDownloadQueue
    GetFontDownloadQueue As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal fontDownloadQueue As IDWriteFontDownloadQueue Ptr Ptr ) As HRESULT

        
    TranslateColorGlyphRun1 As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal baselineOrigin As D2D1_POINT_2F, ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr, ByVal desiredGlyphImageFormats As DWRITE_GLYPH_IMAGE_FORMATS, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal worldAndDpiTransform As DWRITE_MATRIX Ptr, ByVal colorPaletteIndex As ULong, ByVal colorLayers As IDWriteColorGlyphRunEnumerator1 Ptr Ptr ) As HRESULT
        ' 42. ComputeGlyphOrigins_ (simple version)
    ComputeGlyphOrigins_ As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal baselineOrigin As D2D1_POINT_2F, ByVal glyphOrigins As D2D1_POINT_2F Ptr ) As HRESULT
        ' 43. ComputeGlyphOrigins (with measuring mode)
    ComputeGlyphOrigins As Function(ByVal This As IDWriteFactory4 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal baselineOrigin As D2D1_POINT_2F, ByVal worldAndDpiTransform As DWRITE_MATRIX Ptr, ByVal glyphOrigins As D2D1_POINT_2F Ptr ) As HRESULT
End Type
#define IDWriteFactory4_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFactory4_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFactory4_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFactory4_GetSystemFontCollection(p, a, b) (p)->lpVtbl->GetSystemFontCollection(p, a, b)
#define IDWriteFactory4_CreateCustomFontCollection(p, a, b, c, d) (p)->lpVtbl->CreateCustomFontCollection(p, a, b, c, d)
#define IDWriteFactory4_RegisterFontCollectionLoader(p, a) (p)->lpVtbl->RegisterFontCollectionLoader(p, a)
#define IDWriteFactory4_UnregisterFontCollectionLoader(p, a) (p)->lpVtbl->UnregisterFontCollectionLoader(p, a)
#define IDWriteFactory4_CreateFontFileReference(p, a, b, c) (p)->lpVtbl->CreateFontFileReference(p, a, b, c)
#define IDWriteFactory4_CreateCustomFontFileReference(p, a, b, c, d) (p)->lpVtbl->CreateCustomFontFileReference(p, a, b, c, d)
#define IDWriteFactory4_CreateFontFace(p, a, b, c, d, e, f) (p)->lpVtbl->CreateFontFace(p, a, b, c, d, e, f)
#define IDWriteFactory4_CreateRenderingParams(p, a) (p)->lpVtbl->CreateRenderingParams(p, a)
#define IDWriteFactory4_CreateMonitorRenderingParams(p, a, b) (p)->lpVtbl->CreateMonitorRenderingParams(p, a, b)
#define IDWriteFactory4_CreateCustomRenderingParams(p, a, b, c, d, e, f) (p)->lpVtbl->CreateCustomRenderingParams(p, a, b, c, d, e, f)
#define IDWriteFactory4_RegisterFontFileLoader(p, a) (p)->lpVtbl->RegisterFontFileLoader(p, a)
#define IDWriteFactory4_UnregisterFontFileLoader(p, a) (p)->lpVtbl->UnregisterFontFileLoader(p, a)
#define IDWriteFactory4_CreateTextFormat(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateTextFormat(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory4_CreateTypography(p, a) (p)->lpVtbl->CreateTypography(p, a)
#define IDWriteFactory4_GetGdiInterop(p, a) (p)->lpVtbl->GetGdiInterop(p, a)
#define IDWriteFactory4_CreateTextLayout(p, a, b, c, d, e, f) (p)->lpVtbl->CreateTextLayout(p, a, b, c, d, e, f)
#define IDWriteFactory4_CreateGdiCompatibleTextLayout(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->CreateGdiCompatibleTextLayout(p, a, b, c, d, e, f, g, h, i)
#define IDWriteFactory4_CreateEllipsisTrimmingSign(p, a, b) (p)->lpVtbl->CreateEllipsisTrimmingSign(p, a, b)
#define IDWriteFactory4_CreateTextAnalyzer(p, a) (p)->lpVtbl->CreateTextAnalyzer(p, a)
#define IDWriteFactory4_CreateNumberSubstitution(p, a, b, c, d) (p)->lpVtbl->CreateNumberSubstitution(p, a, b, c, d)
#define IDWriteFactory4_CreateGlyphRunAnalysis(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateGlyphRunAnalysis(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory4_GetEudcFontCollection(p, a, b) (p)->lpVtbl->GetEudcFontCollection(p, a, b)
#define IDWriteFactory4_CreateCustomRenderingParams1(p, a, b, c, d, e, f, g) (p)->lpVtbl->CreateCustomRenderingParams1(p, a, b, c, d, e, f, g)
#define IDWriteFactory4_GetSystemFontFallback(p, a) (p)->lpVtbl->GetSystemFontFallback(p, a)
#define IDWriteFactory4_CreateFontFallbackBuilder(p, a) (p)->lpVtbl->CreateFontFallbackBuilder(p, a)
#define IDWriteFactory4_TranslateColorGlyphRun(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->TranslateColorGlyphRun(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory4_CreateCustomRenderingParams2(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateCustomRenderingParams2(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory4_CreateGlyphRunAnalysis1(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->CreateGlyphRunAnalysis1(p, a, b, c, d, e, f, g, h, i)
#define IDWriteFactory4_CreateGlyphRunAnalysis2(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->CreateGlyphRunAnalysis2(p, a, b, c, d, e, f, g, h, i)
#define IDWriteFactory4_CreateCustomRenderingParams3(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateCustomRenderingParams3(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory4_CreateFontFaceReference_(p, a, b, c, d) (p)->lpVtbl->CreateFontFaceReference_(p, a, b, c, d)
#define IDWriteFactory4_CreateFontFaceReference(p, a, b, c, d, e) (p)->lpVtbl->CreateFontFaceReference(p, a, b, c, d, e)
#define IDWriteFactory4_GetSystemFontSet(p, a) (p)->lpVtbl->GetSystemFontSet(p, a)
#define IDWriteFactory4_CreateFontSetBuilder(p, a) (p)->lpVtbl->CreateFontSetBuilder(p, a)
#define IDWriteFactory4_CreateFontCollectionFromFontSet(p, a, b) (p)->lpVtbl->CreateFontCollectionFromFontSet(p, a, b)
#define IDWriteFactory4_GetSystemFontCollection1(p, a, b, c) (p)->lpVtbl->GetSystemFontCollection1(p, a, b, c)
#define IDWriteFactory4_GetFontDownloadQueue(p, a) (p)->lpVtbl->GetFontDownloadQueue(p, a)
#define IDWriteFactory4_TranslateColorGlyphRun1(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->TranslateColorGlyphRun1(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory4_ComputeGlyphOrigins_(p, a, b, c) (p)->lpVtbl->ComputeGlyphOrigins_(p, a, b, c)
#define IDWriteFactory4_ComputeGlyphOrigins(p, a, b, c, d, e) (p)->lpVtbl->ComputeGlyphOrigins(p, a, b, c, d, e)

' ============================================================================
' IDWriteAsyncResult
' ============================================================================
Type IDWriteAsyncResultVtbl As IDWriteAsyncResultVtbl_
Type IDWriteAsyncResult
    lpVtbl As IDWriteAsyncResultVtbl Ptr
End Type
Type IDWriteAsyncResultVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteAsyncResult Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteAsyncResult Ptr) As ULong
    Release As Function(ByVal This As IDWriteAsyncResult Ptr) As ULong

        
    GetWaitHandle As Function(ByVal This As IDWriteAsyncResult Ptr) As HANDLE
        ' 5. GetResult
    GetResult As Function(ByVal This As IDWriteAsyncResult Ptr) As HRESULT
End Type
#define IDWriteAsyncResult_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteAsyncResult_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteAsyncResult_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteAsyncResult_GetWaitHandle(p, a) (p)->lpVtbl->GetWaitHandle(p, a)
#define IDWriteAsyncResult_GetResult(p, a) (p)->lpVtbl->GetResult(p, a)

' ============================================================================
' IDWriteRemoteFontFileStream
' ============================================================================
Type IDWriteRemoteFontFileStreamVtbl As IDWriteRemoteFontFileStreamVtbl_
Type IDWriteRemoteFontFileStream
    lpVtbl As IDWriteRemoteFontFileStreamVtbl Ptr
End Type
Type IDWriteRemoteFontFileStreamVtbl_     '' Extends IDWriteFontFileStreamVtbl_
    QueryInterface As Function(ByVal This As IDWriteRemoteFontFileStream Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteRemoteFontFileStream Ptr) As ULong
    Release As Function(ByVal This As IDWriteRemoteFontFileStream Ptr) As ULong
        
    ReadFileFragment As Function(ByVal This As IDWriteRemoteFontFileStream Ptr,  ByVal fragment_start As Any Ptr Ptr, ByVal offset As ULongInt, ByVal fragment_size As ULongInt, ByVal fragment_context As Any Ptr Ptr ) As HRESULT
        ' 5. ReleaseFileFragment
    ReleaseFileFragment As Sub(ByVal This As IDWriteRemoteFontFileStream Ptr,  ByVal fragment_context As Any Ptr )
        ' 6. GetFileSize
    GetFileSize As Function(ByVal This As IDWriteRemoteFontFileStream Ptr,  ByVal size As ULongInt Ptr ) As HRESULT
        ' 7. GetLastWriteTime
    GetLastWriteTime As Function(ByVal This As IDWriteRemoteFontFileStream Ptr,  ByVal last_writetime As ULongInt Ptr ) As HRESULT

        
    GetLocalFileSize As Function(ByVal This As IDWriteRemoteFontFileStream Ptr,  ByVal localFileSize As ULongInt Ptr ) As HRESULT
        ' 9. GetFileFragmentLocality
    GetFileFragmentLocality As Function(ByVal This As IDWriteRemoteFontFileStream Ptr,  ByVal fileOffset As ULongInt, ByVal fragmentSize As ULongInt, ByVal isLocal As Long Ptr, ByVal partialSize As ULongInt Ptr ) As HRESULT
        ' 10. GetLocality
    GetLocality As Function(ByVal This As IDWriteRemoteFontFileStream Ptr) As DWRITE_LOCALITY
        ' 11. BeginDownload
    BeginDownload As Function(ByVal This As IDWriteRemoteFontFileStream Ptr,  ByVal downloadOperationID As GUID Ptr, ByVal fileFragments As DWRITE_FILE_FRAGMENT Ptr, ByVal fragmentCount As ULong, ByVal asyncResult As IDWriteAsyncResult Ptr Ptr ) As HRESULT
End Type
#define IDWriteRemoteFontFileStream_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteRemoteFontFileStream_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteRemoteFontFileStream_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteRemoteFontFileStream_ReadFileFragment(p, a, b, c, d) (p)->lpVtbl->ReadFileFragment(p, a, b, c, d)
#define IDWriteRemoteFontFileStream_ReleaseFileFragment(p, a) (p)->lpVtbl->ReleaseFileFragment(p, a)
#define IDWriteRemoteFontFileStream_GetFileSize(p, a) (p)->lpVtbl->GetFileSize(p, a)
#define IDWriteRemoteFontFileStream_GetLastWriteTime(p, a) (p)->lpVtbl->GetLastWriteTime(p, a)
#define IDWriteRemoteFontFileStream_GetLocalFileSize(p, a) (p)->lpVtbl->GetLocalFileSize(p, a)
#define IDWriteRemoteFontFileStream_GetFileFragmentLocality(p, a, b, c, d) (p)->lpVtbl->GetFileFragmentLocality(p, a, b, c, d)
#define IDWriteRemoteFontFileStream_GetLocality(p, a) (p)->lpVtbl->GetLocality(p, a)
#define IDWriteRemoteFontFileStream_BeginDownload(p, a, b, c, d) (p)->lpVtbl->BeginDownload(p, a, b, c, d)

' ============================================================================
' IDWriteRemoteFontFileLoader
' ============================================================================
Type IDWriteRemoteFontFileLoaderVtbl As IDWriteRemoteFontFileLoaderVtbl_
Type IDWriteRemoteFontFileLoader
    lpVtbl As IDWriteRemoteFontFileLoaderVtbl Ptr
End Type
Type IDWriteRemoteFontFileLoaderVtbl_     '' Extends IDWriteFontFileLoaderVtbl_
    QueryInterface As Function(ByVal This As IDWriteRemoteFontFileLoader Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteRemoteFontFileLoader Ptr) As ULong
    Release As Function(ByVal This As IDWriteRemoteFontFileLoader Ptr) As ULong
        
    CreateStreamFromKey As Function(ByVal This As IDWriteRemoteFontFileLoader Ptr,  ByVal key As Any Ptr, ByVal key_size As ULong, ByVal stream As Any Ptr Ptr ) As HRESULT

        
    CreateRemoteStreamFromKey As Function(ByVal This As IDWriteRemoteFontFileLoader Ptr,  ByVal fontFileReferenceKey As Any Ptr, ByVal fontFileReferenceKeySize As ULong, ByVal fontFileStream As IDWriteRemoteFontFileStream Ptr Ptr ) As HRESULT
        ' 6. GetLocalityFromKey
    GetLocalityFromKey As Function(ByVal This As IDWriteRemoteFontFileLoader Ptr,  ByVal fontFileReferenceKey As Any Ptr, ByVal fontFileReferenceKeySize As ULong, ByVal locality As DWRITE_LOCALITY Ptr ) As HRESULT
        ' 7. CreateFontFileReferenceFromUrl
    CreateFontFileReferenceFromUrl As Function(ByVal This As IDWriteRemoteFontFileLoader Ptr,  ByVal factory As IDWriteFactory Ptr, ByVal baseUrl As WString Ptr, ByVal fontFileUrl As WString Ptr, ByVal fontFile As IDWriteFontFile Ptr Ptr ) As HRESULT
End Type
#define IDWriteRemoteFontFileLoader_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteRemoteFontFileLoader_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteRemoteFontFileLoader_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteRemoteFontFileLoader_CreateStreamFromKey(p, a, b, c) (p)->lpVtbl->CreateStreamFromKey(p, a, b, c)
#define IDWriteRemoteFontFileLoader_CreateRemoteStreamFromKey(p, a, b, c) (p)->lpVtbl->CreateRemoteStreamFromKey(p, a, b, c)
#define IDWriteRemoteFontFileLoader_GetLocalityFromKey(p, a, b, c) (p)->lpVtbl->GetLocalityFromKey(p, a, b, c)
#define IDWriteRemoteFontFileLoader_CreateFontFileReferenceFromUrl(p, a, b, c, d) (p)->lpVtbl->CreateFontFileReferenceFromUrl(p, a, b, c, d)

' ============================================================================
' IDWriteInMemoryFontFileLoader
' ============================================================================
Type IDWriteInMemoryFontFileLoaderVtbl As IDWriteInMemoryFontFileLoaderVtbl_
Type IDWriteInMemoryFontFileLoader
    lpVtbl As IDWriteInMemoryFontFileLoaderVtbl Ptr
End Type
Type IDWriteInMemoryFontFileLoaderVtbl_     '' Extends IDWriteFontFileLoaderVtbl_
    QueryInterface As Function(ByVal This As IDWriteInMemoryFontFileLoader Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteInMemoryFontFileLoader Ptr) As ULong
    Release As Function(ByVal This As IDWriteInMemoryFontFileLoader Ptr) As ULong
        
    CreateStreamFromKey As Function(ByVal This As IDWriteInMemoryFontFileLoader Ptr,  ByVal key As Any Ptr, ByVal key_size As ULong, ByVal stream As Any Ptr Ptr ) As HRESULT

        
    CreateInMemoryFontFileReference As Function(ByVal This As IDWriteInMemoryFontFileLoader Ptr,  ByVal factory As IDWriteFactory Ptr, ByVal fontData As Any Ptr, ByVal fontDataSize As ULong, ByVal owner As IUnknown Ptr, ByVal fontFile As IDWriteFontFile Ptr Ptr ) As HRESULT
        ' 6. GetFileCount
    GetFileCount As Function(ByVal This As IDWriteInMemoryFontFileLoader Ptr) As ULong
End Type
#define IDWriteInMemoryFontFileLoader_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteInMemoryFontFileLoader_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteInMemoryFontFileLoader_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteInMemoryFontFileLoader_CreateStreamFromKey(p, a, b, c) (p)->lpVtbl->CreateStreamFromKey(p, a, b, c)
#define IDWriteInMemoryFontFileLoader_CreateInMemoryFontFileReference(p, a, b, c, d, e) (p)->lpVtbl->CreateInMemoryFontFileReference(p, a, b, c, d, e)
#define IDWriteInMemoryFontFileLoader_GetFileCount(p, a) (p)->lpVtbl->GetFileCount(p, a)

' ============================================================================
' IDWriteFactory5
' ============================================================================
Type IDWriteFactory5Vtbl As IDWriteFactory5Vtbl_
Type IDWriteFactory5
    lpVtbl As IDWriteFactory5Vtbl Ptr
End Type
Type IDWriteFactory5Vtbl_     '' Extends IDWriteFactory4Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFactory5 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFactory5 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFactory5 Ptr) As ULong
        
    GetSystemFontCollection As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal fontCollection As Any Ptr Ptr, ByVal checkForUpdates As Long = 0 ) As HRESULT
        ' 5. CreateCustomFontCollection
    CreateCustomFontCollection As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal collectionLoader As Any Ptr, ByVal collectionKey As Any Ptr, ByVal collectionKeySize As ULong, ByVal fontCollection As Any Ptr Ptr ) As HRESULT
        ' 6. RegisterFontCollectionLoader
    RegisterFontCollectionLoader As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal fontCollectionLoader As Any Ptr ) As HRESULT
        ' 7. UnregisterFontCollectionLoader
    UnregisterFontCollectionLoader As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal fontCollectionLoader As Any Ptr ) As HRESULT
        ' 8. CreateFontFileReference
    CreateFontFileReference As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal filePath As WString Ptr, ByVal lastWriteTime As FILETIME Ptr, ByVal fontFile As Any Ptr Ptr ) As HRESULT
        ' 9. CreateCustomFontFileReference
    CreateCustomFontFileReference As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal fontFileReferenceKey As Any Ptr, ByVal fontFileReferenceKeySize As ULong, ByVal fontFileLoader As Any Ptr, ByVal fontFile As Any Ptr Ptr ) As HRESULT
        ' 10. CreateFontFace
    CreateFontFace As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal fontFaceType As DWRITE_FONT_FACE_TYPE, ByVal numberOfFiles As ULong, ByVal fontFiles As Any Ptr Ptr, ByVal faceIndex As ULong, ByVal fontFaceSimulationFlags As DWRITE_FONT_SIMULATIONS, ByVal fontFace As Any Ptr Ptr ) As HRESULT
        ' 11. CreateRenderingParams
    CreateRenderingParams As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 12. CreateMonitorRenderingParams
    CreateMonitorRenderingParams As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal monitor As HMONITOR, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 13. CreateCustomRenderingParams
    CreateCustomRenderingParams As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 14. RegisterFontFileLoader
    RegisterFontFileLoader As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal fontFileLoader As Any Ptr ) As HRESULT
        ' 15. UnregisterFontFileLoader
    UnregisterFontFileLoader As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal fontFileLoader As Any Ptr ) As HRESULT
        ' 16. CreateTextFormat
    CreateTextFormat As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal fontFamilyName As WString Ptr, ByVal fontCollection As Any Ptr, ByVal fontWeight As DWRITE_FONT_WEIGHT, ByVal fontStyle As DWRITE_FONT_STYLE, ByVal fontStretch As DWRITE_FONT_STRETCH, ByVal fontSize As Single, ByVal localeName As WString Ptr, ByVal textFormat As IDWriteTextFormat Ptr Ptr ) As HRESULT
        ' 17. CreateTypography
    CreateTypography As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal typography As Any Ptr Ptr ) As HRESULT
        ' 18. GetGdiInterop
    GetGdiInterop As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal gdiInterop As Any Ptr Ptr ) As HRESULT
        ' 19. CreateTextLayout
    CreateTextLayout As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal string As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal maxWidth As Single, ByVal maxHeight As Single, ByVal textLayout As Any Ptr Ptr ) As HRESULT
        ' 20. CreateGdiCompatibleTextLayout
    CreateGdiCompatibleTextLayout As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal string As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal layoutWidth As Single, ByVal layoutHeight As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal useGdiNatural As Long, ByVal textLayout As Any Ptr Ptr ) As HRESULT
        ' 21. CreateEllipsisTrimmingSign
    CreateEllipsisTrimmingSign As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal textFormat As Any Ptr, ByVal trimmingSign As Any Ptr Ptr ) As HRESULT
        ' 22. CreateTextAnalyzer
    CreateTextAnalyzer As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal textAnalyzer As Any Ptr Ptr ) As HRESULT
        ' 23. CreateNumberSubstitution
    CreateNumberSubstitution As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal substitutionMethod As DWRITE_NUMBER_SUBSTITUTION_METHOD, ByVal localeName As WString Ptr, ByVal ignoreUserOverride As Long, ByVal numberSubstitution As Any Ptr Ptr ) As HRESULT
        ' 24. CreateGlyphRunAnalysis
    CreateGlyphRunAnalysis As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRunAnalysis As Any Ptr Ptr ) As HRESULT
        
    GetEudcFontCollection As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal collection As Any Ptr Ptr, ByVal checkForUpdates As Long = 0 ) As HRESULT
        ' 26. CreateCustomRenderingParams
    CreateCustomRenderingParams1 As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal enhancedContrastGrayscale As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        
    GetSystemFontFallback As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal fontFallback As IDWriteFontFallback Ptr Ptr ) As HRESULT
        ' 28. CreateFontFallbackBuilder
    CreateFontFallbackBuilder As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal fontFallbackBuilder As IDWriteFontFallbackBuilder Ptr Ptr ) As HRESULT
        ' 29. TranslateColorGlyphRun
    TranslateColorGlyphRun As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal worldToDeviceTransform As DWRITE_MATRIX Ptr, ByVal colorPaletteIndex As ULong, ByVal colorLayers As IDWriteColorGlyphRunEnumerator Ptr Ptr ) As HRESULT
        ' 30. CreateCustomRenderingParams
    CreateCustomRenderingParams2 As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal grayscaleEnhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal renderingParams As IDWriteRenderingParams2 Ptr Ptr ) As HRESULT
        ' 31. CreateGlyphRunAnalysis
    CreateGlyphRunAnalysis1 As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal transform As DWRITE_MATRIX Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal antialiasMode As DWRITE_TEXT_ANTIALIAS_MODE, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRunAnalysis As IDWriteGlyphRunAnalysis Ptr Ptr ) As HRESULT
        
    CreateGlyphRunAnalysis2 As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal transform As DWRITE_MATRIX Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE1, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal antialiasMode As DWRITE_TEXT_ANTIALIAS_MODE, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRunAnalysis As IDWriteGlyphRunAnalysis Ptr Ptr ) As HRESULT
        ' 33. CreateCustomRenderingParams
    CreateCustomRenderingParams3 As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal grayscaleEnhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE1, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal renderingParams As IDWriteRenderingParams3 Ptr Ptr ) As HRESULT
        ' 34. CreateFontFaceReference_ (from file)
    CreateFontFaceReference_ As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal fontFile As IDWriteFontFile Ptr, ByVal faceIndex As ULong, ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 35. CreateFontFaceReference (from path)
    CreateFontFaceReference As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal filePath As WString Ptr, ByVal lastWriteTime As FILETIME Ptr, ByVal faceIndex As ULong, ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 36. GetSystemFontSet
    GetSystemFontSet As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal fontSet As IDWriteFontSet Ptr Ptr ) As HRESULT
        ' 37. CreateFontSetBuilder
    CreateFontSetBuilder As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal fontSetBuilder As IDWriteFontSetBuilder Ptr Ptr ) As HRESULT
        ' 38. CreateFontCollectionFromFontSet
    CreateFontCollectionFromFontSet As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal fontSet As IDWriteFontSet Ptr, ByVal fontCollection As IDWriteFontCollection1 Ptr Ptr ) As HRESULT
        ' 39. GetSystemFontCollection
    GetSystemFontCollection1 As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal includeDownloadableFonts As Long, ByVal fontCollection As IDWriteFontCollection1 Ptr Ptr, ByVal checkForUpdates As Long ) As HRESULT
        ' 40. GetFontDownloadQueue
    GetFontDownloadQueue As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal fontDownloadQueue As IDWriteFontDownloadQueue Ptr Ptr ) As HRESULT
        
    TranslateColorGlyphRun1 As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal baselineOrigin As D2D1_POINT_2F, ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr, ByVal desiredGlyphImageFormats As DWRITE_GLYPH_IMAGE_FORMATS, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal worldAndDpiTransform As DWRITE_MATRIX Ptr, ByVal colorPaletteIndex As ULong, ByVal colorLayers As IDWriteColorGlyphRunEnumerator1 Ptr Ptr ) As HRESULT
        ' 42. ComputeGlyphOrigins_ (simple version)
    ComputeGlyphOrigins_ As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal baselineOrigin As D2D1_POINT_2F, ByVal glyphOrigins As D2D1_POINT_2F Ptr ) As HRESULT
        ' 43. ComputeGlyphOrigins (with measuring mode)
    ComputeGlyphOrigins As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal baselineOrigin As D2D1_POINT_2F, ByVal worldAndDpiTransform As DWRITE_MATRIX Ptr, ByVal glyphOrigins As D2D1_POINT_2F Ptr ) As HRESULT

        
    CreateFontSetBuilder1 As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal fontSetBuilder As IDWriteFontSetBuilder1 Ptr Ptr ) As HRESULT
        ' 45. CreateInMemoryFontFileLoader
    CreateInMemoryFontFileLoader As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal newLoader As IDWriteInMemoryFontFileLoader Ptr Ptr ) As HRESULT
        ' 46. CreateHttpFontFileLoader
    CreateHttpFontFileLoader As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal referrerUrl As WString Ptr, ByVal extraHeaders As WString Ptr, ByVal newLoader As IDWriteRemoteFontFileLoader Ptr Ptr ) As HRESULT
        ' 47. AnalyzeContainerType
    AnalyzeContainerType As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal fileData As Any Ptr, ByVal fileDataSize As ULong ) As DWRITE_CONTAINER_TYPE
        ' 48. UnpackFontFile
    UnpackFontFile As Function(ByVal This As IDWriteFactory5 Ptr,  ByVal containerType As DWRITE_CONTAINER_TYPE, ByVal fileData As Any Ptr, ByVal fileDataSize As ULong, ByVal unpackedFontStream As IDWriteFontFileStream Ptr Ptr ) As HRESULT
End Type
#define IDWriteFactory5_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFactory5_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFactory5_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFactory5_GetSystemFontCollection(p, a, b) (p)->lpVtbl->GetSystemFontCollection(p, a, b)
#define IDWriteFactory5_CreateCustomFontCollection(p, a, b, c, d) (p)->lpVtbl->CreateCustomFontCollection(p, a, b, c, d)
#define IDWriteFactory5_RegisterFontCollectionLoader(p, a) (p)->lpVtbl->RegisterFontCollectionLoader(p, a)
#define IDWriteFactory5_UnregisterFontCollectionLoader(p, a) (p)->lpVtbl->UnregisterFontCollectionLoader(p, a)
#define IDWriteFactory5_CreateFontFileReference(p, a, b, c) (p)->lpVtbl->CreateFontFileReference(p, a, b, c)
#define IDWriteFactory5_CreateCustomFontFileReference(p, a, b, c, d) (p)->lpVtbl->CreateCustomFontFileReference(p, a, b, c, d)
#define IDWriteFactory5_CreateFontFace(p, a, b, c, d, e, f) (p)->lpVtbl->CreateFontFace(p, a, b, c, d, e, f)
#define IDWriteFactory5_CreateRenderingParams(p, a) (p)->lpVtbl->CreateRenderingParams(p, a)
#define IDWriteFactory5_CreateMonitorRenderingParams(p, a, b) (p)->lpVtbl->CreateMonitorRenderingParams(p, a, b)
#define IDWriteFactory5_CreateCustomRenderingParams(p, a, b, c, d, e, f) (p)->lpVtbl->CreateCustomRenderingParams(p, a, b, c, d, e, f)
#define IDWriteFactory5_RegisterFontFileLoader(p, a) (p)->lpVtbl->RegisterFontFileLoader(p, a)
#define IDWriteFactory5_UnregisterFontFileLoader(p, a) (p)->lpVtbl->UnregisterFontFileLoader(p, a)
#define IDWriteFactory5_CreateTextFormat(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateTextFormat(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory5_CreateTypography(p, a) (p)->lpVtbl->CreateTypography(p, a)
#define IDWriteFactory5_GetGdiInterop(p, a) (p)->lpVtbl->GetGdiInterop(p, a)
#define IDWriteFactory5_CreateTextLayout(p, a, b, c, d, e, f) (p)->lpVtbl->CreateTextLayout(p, a, b, c, d, e, f)
#define IDWriteFactory5_CreateGdiCompatibleTextLayout(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->CreateGdiCompatibleTextLayout(p, a, b, c, d, e, f, g, h, i)
#define IDWriteFactory5_CreateEllipsisTrimmingSign(p, a, b) (p)->lpVtbl->CreateEllipsisTrimmingSign(p, a, b)
#define IDWriteFactory5_CreateTextAnalyzer(p, a) (p)->lpVtbl->CreateTextAnalyzer(p, a)
#define IDWriteFactory5_CreateNumberSubstitution(p, a, b, c, d) (p)->lpVtbl->CreateNumberSubstitution(p, a, b, c, d)
#define IDWriteFactory5_CreateGlyphRunAnalysis(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateGlyphRunAnalysis(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory5_GetEudcFontCollection(p, a, b) (p)->lpVtbl->GetEudcFontCollection(p, a, b)
#define IDWriteFactory5_CreateCustomRenderingParams1(p, a, b, c, d, e, f, g) (p)->lpVtbl->CreateCustomRenderingParams1(p, a, b, c, d, e, f, g)
#define IDWriteFactory5_GetSystemFontFallback(p, a) (p)->lpVtbl->GetSystemFontFallback(p, a)
#define IDWriteFactory5_CreateFontFallbackBuilder(p, a) (p)->lpVtbl->CreateFontFallbackBuilder(p, a)
#define IDWriteFactory5_TranslateColorGlyphRun(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->TranslateColorGlyphRun(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory5_CreateCustomRenderingParams2(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateCustomRenderingParams2(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory5_CreateGlyphRunAnalysis1(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->CreateGlyphRunAnalysis1(p, a, b, c, d, e, f, g, h, i)
#define IDWriteFactory5_CreateGlyphRunAnalysis2(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->CreateGlyphRunAnalysis2(p, a, b, c, d, e, f, g, h, i)
#define IDWriteFactory5_CreateCustomRenderingParams3(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateCustomRenderingParams3(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory5_CreateFontFaceReference_(p, a, b, c, d) (p)->lpVtbl->CreateFontFaceReference_(p, a, b, c, d)
#define IDWriteFactory5_CreateFontFaceReference(p, a, b, c, d, e) (p)->lpVtbl->CreateFontFaceReference(p, a, b, c, d, e)
#define IDWriteFactory5_GetSystemFontSet(p, a) (p)->lpVtbl->GetSystemFontSet(p, a)
#define IDWriteFactory5_CreateFontSetBuilder(p, a) (p)->lpVtbl->CreateFontSetBuilder(p, a)
#define IDWriteFactory5_CreateFontCollectionFromFontSet(p, a, b) (p)->lpVtbl->CreateFontCollectionFromFontSet(p, a, b)
#define IDWriteFactory5_GetSystemFontCollection1(p, a, b, c) (p)->lpVtbl->GetSystemFontCollection1(p, a, b, c)
#define IDWriteFactory5_GetFontDownloadQueue(p, a) (p)->lpVtbl->GetFontDownloadQueue(p, a)
#define IDWriteFactory5_TranslateColorGlyphRun1(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->TranslateColorGlyphRun1(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory5_ComputeGlyphOrigins_(p, a, b, c) (p)->lpVtbl->ComputeGlyphOrigins_(p, a, b, c)
#define IDWriteFactory5_ComputeGlyphOrigins(p, a, b, c, d, e) (p)->lpVtbl->ComputeGlyphOrigins(p, a, b, c, d, e)
#define IDWriteFactory5_CreateFontSetBuilder1(p, a) (p)->lpVtbl->CreateFontSetBuilder1(p, a)
#define IDWriteFactory5_CreateInMemoryFontFileLoader(p, a) (p)->lpVtbl->CreateInMemoryFontFileLoader(p, a)
#define IDWriteFactory5_CreateHttpFontFileLoader(p, a, b, c) (p)->lpVtbl->CreateHttpFontFileLoader(p, a, b, c)
#define IDWriteFactory5_AnalyzeContainerType(p, a, b) (p)->lpVtbl->AnalyzeContainerType(p, a, b)
#define IDWriteFactory5_UnpackFontFile(p, a, b, c, d) (p)->lpVtbl->UnpackFontFile(p, a, b, c, d)

' ============================================================================
' IDWriteFactory6
' ============================================================================
Type IDWriteFactory6Vtbl As IDWriteFactory6Vtbl_
Type IDWriteFactory6
    lpVtbl As IDWriteFactory6Vtbl Ptr
End Type
Type IDWriteFactory6Vtbl_     '' Extends IDWriteFactory5Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFactory6 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFactory6 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFactory6 Ptr) As ULong
        
    GetSystemFontCollection As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal fontCollection As Any Ptr Ptr, ByVal checkForUpdates As Long = 0 ) As HRESULT
        ' 5. CreateCustomFontCollection
    CreateCustomFontCollection As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal collectionLoader As Any Ptr, ByVal collectionKey As Any Ptr, ByVal collectionKeySize As ULong, ByVal fontCollection As Any Ptr Ptr ) As HRESULT
        ' 6. RegisterFontCollectionLoader
    RegisterFontCollectionLoader As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal fontCollectionLoader As Any Ptr ) As HRESULT
        ' 7. UnregisterFontCollectionLoader
    UnregisterFontCollectionLoader As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal fontCollectionLoader As Any Ptr ) As HRESULT
        ' 8. CreateFontFileReference
    CreateFontFileReference As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal filePath As WString Ptr, ByVal lastWriteTime As FILETIME Ptr, ByVal fontFile As Any Ptr Ptr ) As HRESULT
        ' 9. CreateCustomFontFileReference
    CreateCustomFontFileReference As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal fontFileReferenceKey As Any Ptr, ByVal fontFileReferenceKeySize As ULong, ByVal fontFileLoader As Any Ptr, ByVal fontFile As Any Ptr Ptr ) As HRESULT
        ' 10. CreateFontFace
    CreateFontFace As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal fontFaceType As DWRITE_FONT_FACE_TYPE, ByVal numberOfFiles As ULong, ByVal fontFiles As Any Ptr Ptr, ByVal faceIndex As ULong, ByVal fontFaceSimulationFlags As DWRITE_FONT_SIMULATIONS, ByVal fontFace As Any Ptr Ptr ) As HRESULT
        ' 11. CreateRenderingParams
    CreateRenderingParams As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 12. CreateMonitorRenderingParams
    CreateMonitorRenderingParams As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal monitor As HMONITOR, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 13. CreateCustomRenderingParams
    CreateCustomRenderingParams As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 14. RegisterFontFileLoader
    RegisterFontFileLoader As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal fontFileLoader As Any Ptr ) As HRESULT
        ' 15. UnregisterFontFileLoader
    UnregisterFontFileLoader As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal fontFileLoader As Any Ptr ) As HRESULT
        ' 16. CreateTextFormat
    CreateTextFormat As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal fontFamilyName As WString Ptr, ByVal fontCollection As Any Ptr, ByVal fontWeight As DWRITE_FONT_WEIGHT, ByVal fontStyle As DWRITE_FONT_STYLE, ByVal fontStretch As DWRITE_FONT_STRETCH, ByVal fontSize As Single, ByVal localeName As WString Ptr, ByVal textFormat As IDWriteTextFormat Ptr Ptr ) As HRESULT
        ' 17. CreateTypography
    CreateTypography As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal typography As Any Ptr Ptr ) As HRESULT
        ' 18. GetGdiInterop
    GetGdiInterop As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal gdiInterop As Any Ptr Ptr ) As HRESULT
        ' 19. CreateTextLayout
    CreateTextLayout As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal string As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal maxWidth As Single, ByVal maxHeight As Single, ByVal textLayout As Any Ptr Ptr ) As HRESULT
        ' 20. CreateGdiCompatibleTextLayout
    CreateGdiCompatibleTextLayout As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal string As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal layoutWidth As Single, ByVal layoutHeight As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal useGdiNatural As Long, ByVal textLayout As Any Ptr Ptr ) As HRESULT
        ' 21. CreateEllipsisTrimmingSign
    CreateEllipsisTrimmingSign As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal textFormat As Any Ptr, ByVal trimmingSign As Any Ptr Ptr ) As HRESULT
        ' 22. CreateTextAnalyzer
    CreateTextAnalyzer As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal textAnalyzer As Any Ptr Ptr ) As HRESULT
        ' 23. CreateNumberSubstitution
    CreateNumberSubstitution As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal substitutionMethod As DWRITE_NUMBER_SUBSTITUTION_METHOD, ByVal localeName As WString Ptr, ByVal ignoreUserOverride As Long, ByVal numberSubstitution As Any Ptr Ptr ) As HRESULT
        ' 24. CreateGlyphRunAnalysis
    CreateGlyphRunAnalysis As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRunAnalysis As Any Ptr Ptr ) As HRESULT
        
    GetEudcFontCollection As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal collection As Any Ptr Ptr, ByVal checkForUpdates As Long = 0 ) As HRESULT
        ' 26. CreateCustomRenderingParams
    CreateCustomRenderingParams1 As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal enhancedContrastGrayscale As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        
    GetSystemFontFallback As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal fontFallback As IDWriteFontFallback Ptr Ptr ) As HRESULT
        ' 28. CreateFontFallbackBuilder
    CreateFontFallbackBuilder As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal fontFallbackBuilder As IDWriteFontFallbackBuilder Ptr Ptr ) As HRESULT
        ' 29. TranslateColorGlyphRun
    TranslateColorGlyphRun As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal worldToDeviceTransform As DWRITE_MATRIX Ptr, ByVal colorPaletteIndex As ULong, ByVal colorLayers As IDWriteColorGlyphRunEnumerator Ptr Ptr ) As HRESULT
        ' 30. CreateCustomRenderingParams
    CreateCustomRenderingParams2 As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal grayscaleEnhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal renderingParams As IDWriteRenderingParams2 Ptr Ptr ) As HRESULT
        ' 31. CreateGlyphRunAnalysis
    CreateGlyphRunAnalysis1 As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal transform As DWRITE_MATRIX Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal antialiasMode As DWRITE_TEXT_ANTIALIAS_MODE, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRunAnalysis As IDWriteGlyphRunAnalysis Ptr Ptr ) As HRESULT
        
    CreateGlyphRunAnalysis2 As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal transform As DWRITE_MATRIX Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE1, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal antialiasMode As DWRITE_TEXT_ANTIALIAS_MODE, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRunAnalysis As IDWriteGlyphRunAnalysis Ptr Ptr ) As HRESULT
        ' 33. CreateCustomRenderingParams
    CreateCustomRenderingParams3 As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal grayscaleEnhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE1, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal renderingParams As IDWriteRenderingParams3 Ptr Ptr ) As HRESULT
        ' 34. CreateFontFaceReference_ (from file)
    CreateFontFaceReference_ As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal fontFile As IDWriteFontFile Ptr, ByVal faceIndex As ULong, ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 35. CreateFontFaceReference (from path)
    CreateFontFaceReference As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal filePath As WString Ptr, ByVal lastWriteTime As FILETIME Ptr, ByVal faceIndex As ULong, ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 36. GetSystemFontSet
    GetSystemFontSet As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal fontSet As IDWriteFontSet Ptr Ptr ) As HRESULT
        ' 37. CreateFontSetBuilder
    CreateFontSetBuilder As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal fontSetBuilder As IDWriteFontSetBuilder Ptr Ptr ) As HRESULT
        ' 38. CreateFontCollectionFromFontSet
    CreateFontCollectionFromFontSet As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal fontSet As IDWriteFontSet Ptr, ByVal fontCollection As IDWriteFontCollection1 Ptr Ptr ) As HRESULT
        ' 39. GetSystemFontCollection
    GetSystemFontCollection1 As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal includeDownloadableFonts As Long, ByVal fontCollection As IDWriteFontCollection1 Ptr Ptr, ByVal checkForUpdates As Long ) As HRESULT
        ' 40. GetFontDownloadQueue
    GetFontDownloadQueue As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal fontDownloadQueue As IDWriteFontDownloadQueue Ptr Ptr ) As HRESULT
        
    TranslateColorGlyphRun1 As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal baselineOrigin As D2D1_POINT_2F, ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr, ByVal desiredGlyphImageFormats As DWRITE_GLYPH_IMAGE_FORMATS, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal worldAndDpiTransform As DWRITE_MATRIX Ptr, ByVal colorPaletteIndex As ULong, ByVal colorLayers As IDWriteColorGlyphRunEnumerator1 Ptr Ptr ) As HRESULT
        ' 42. ComputeGlyphOrigins_ (simple version)
    ComputeGlyphOrigins_ As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal baselineOrigin As D2D1_POINT_2F, ByVal glyphOrigins As D2D1_POINT_2F Ptr ) As HRESULT
        ' 43. ComputeGlyphOrigins (with measuring mode)
    ComputeGlyphOrigins As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal baselineOrigin As D2D1_POINT_2F, ByVal worldAndDpiTransform As DWRITE_MATRIX Ptr, ByVal glyphOrigins As D2D1_POINT_2F Ptr ) As HRESULT
        
    CreateFontSetBuilder1 As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal fontSetBuilder As IDWriteFontSetBuilder1 Ptr Ptr ) As HRESULT
        ' 45. CreateInMemoryFontFileLoader
    CreateInMemoryFontFileLoader As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal newLoader As IDWriteInMemoryFontFileLoader Ptr Ptr ) As HRESULT
        ' 46. CreateHttpFontFileLoader
    CreateHttpFontFileLoader As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal referrerUrl As WString Ptr, ByVal extraHeaders As WString Ptr, ByVal newLoader As IDWriteRemoteFontFileLoader Ptr Ptr ) As HRESULT
        ' 47. AnalyzeContainerType
    AnalyzeContainerType As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal fileData As Any Ptr, ByVal fileDataSize As ULong ) As DWRITE_CONTAINER_TYPE
        ' 48. UnpackFontFile
    UnpackFontFile As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal containerType As DWRITE_CONTAINER_TYPE, ByVal fileData As Any Ptr, ByVal fileDataSize As ULong, ByVal unpackedFontStream As IDWriteFontFileStream Ptr Ptr ) As HRESULT

        
    CreateFontFaceReference1 As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal fontFile As IDWriteFontFile Ptr, ByVal faceIndex As ULong, ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong, ByVal fontFaceReference As IDWriteFontFaceReference1 Ptr Ptr ) As HRESULT
        ' 50. CreateFontResource
    CreateFontResource As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal fontFile As IDWriteFontFile Ptr, ByVal faceIndex As ULong, ByVal fontResource As IDWriteFontResource Ptr Ptr ) As HRESULT
        ' 51. GetSystemFontSet
    GetSystemFontSet1 As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal includeDownloadableFonts As Long, ByVal fontSet As IDWriteFontSet1 Ptr Ptr ) As HRESULT
        ' 52. GetSystemFontCollection
    GetSystemFontCollection2 As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal includeDownloadableFonts As Long, ByVal fontFamilyModel As DWRITE_FONT_FAMILY_MODEL, ByVal fontCollection As IDWriteFontCollection2 Ptr Ptr ) As HRESULT
        ' 53. CreateFontCollectionFromFontSet
    CreateFontCollectionFromFontSet1 As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal fontSet As IDWriteFontSet Ptr, ByVal fontFamilyModel As DWRITE_FONT_FAMILY_MODEL, ByVal fontCollection As IDWriteFontCollection2 Ptr Ptr ) As HRESULT
        ' 54. CreateFontSetBuilder
    CreateFontSetBuilder2 As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal fontSetBuilder As IDWriteFontSetBuilder2 Ptr Ptr ) As HRESULT
        ' 55. CreateTextFormat
    CreateTextFormat1 As Function(ByVal This As IDWriteFactory6 Ptr,  ByVal fontFamilyName As WString Ptr, ByVal fontCollection As IDWriteFontCollection Ptr, ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong, ByVal fontSize As Single, ByVal localeName As WString Ptr, ByVal textFormat As IDWriteTextFormat3 Ptr Ptr ) As HRESULT
End Type
#define IDWriteFactory6_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFactory6_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFactory6_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFactory6_GetSystemFontCollection(p, a, b) (p)->lpVtbl->GetSystemFontCollection(p, a, b)
#define IDWriteFactory6_CreateCustomFontCollection(p, a, b, c, d) (p)->lpVtbl->CreateCustomFontCollection(p, a, b, c, d)
#define IDWriteFactory6_RegisterFontCollectionLoader(p, a) (p)->lpVtbl->RegisterFontCollectionLoader(p, a)
#define IDWriteFactory6_UnregisterFontCollectionLoader(p, a) (p)->lpVtbl->UnregisterFontCollectionLoader(p, a)
#define IDWriteFactory6_CreateFontFileReference(p, a, b, c) (p)->lpVtbl->CreateFontFileReference(p, a, b, c)
#define IDWriteFactory6_CreateCustomFontFileReference(p, a, b, c, d) (p)->lpVtbl->CreateCustomFontFileReference(p, a, b, c, d)
#define IDWriteFactory6_CreateFontFace(p, a, b, c, d, e, f) (p)->lpVtbl->CreateFontFace(p, a, b, c, d, e, f)
#define IDWriteFactory6_CreateRenderingParams(p, a) (p)->lpVtbl->CreateRenderingParams(p, a)
#define IDWriteFactory6_CreateMonitorRenderingParams(p, a, b) (p)->lpVtbl->CreateMonitorRenderingParams(p, a, b)
#define IDWriteFactory6_CreateCustomRenderingParams(p, a, b, c, d, e, f) (p)->lpVtbl->CreateCustomRenderingParams(p, a, b, c, d, e, f)
#define IDWriteFactory6_RegisterFontFileLoader(p, a) (p)->lpVtbl->RegisterFontFileLoader(p, a)
#define IDWriteFactory6_UnregisterFontFileLoader(p, a) (p)->lpVtbl->UnregisterFontFileLoader(p, a)
#define IDWriteFactory6_CreateTextFormat(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateTextFormat(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory6_CreateTypography(p, a) (p)->lpVtbl->CreateTypography(p, a)
#define IDWriteFactory6_GetGdiInterop(p, a) (p)->lpVtbl->GetGdiInterop(p, a)
#define IDWriteFactory6_CreateTextLayout(p, a, b, c, d, e, f) (p)->lpVtbl->CreateTextLayout(p, a, b, c, d, e, f)
#define IDWriteFactory6_CreateGdiCompatibleTextLayout(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->CreateGdiCompatibleTextLayout(p, a, b, c, d, e, f, g, h, i)
#define IDWriteFactory6_CreateEllipsisTrimmingSign(p, a, b) (p)->lpVtbl->CreateEllipsisTrimmingSign(p, a, b)
#define IDWriteFactory6_CreateTextAnalyzer(p, a) (p)->lpVtbl->CreateTextAnalyzer(p, a)
#define IDWriteFactory6_CreateNumberSubstitution(p, a, b, c, d) (p)->lpVtbl->CreateNumberSubstitution(p, a, b, c, d)
#define IDWriteFactory6_CreateGlyphRunAnalysis(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateGlyphRunAnalysis(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory6_GetEudcFontCollection(p, a, b) (p)->lpVtbl->GetEudcFontCollection(p, a, b)
#define IDWriteFactory6_CreateCustomRenderingParams1(p, a, b, c, d, e, f, g) (p)->lpVtbl->CreateCustomRenderingParams1(p, a, b, c, d, e, f, g)
#define IDWriteFactory6_GetSystemFontFallback(p, a) (p)->lpVtbl->GetSystemFontFallback(p, a)
#define IDWriteFactory6_CreateFontFallbackBuilder(p, a) (p)->lpVtbl->CreateFontFallbackBuilder(p, a)
#define IDWriteFactory6_TranslateColorGlyphRun(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->TranslateColorGlyphRun(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory6_CreateCustomRenderingParams2(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateCustomRenderingParams2(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory6_CreateGlyphRunAnalysis1(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->CreateGlyphRunAnalysis1(p, a, b, c, d, e, f, g, h, i)
#define IDWriteFactory6_CreateGlyphRunAnalysis2(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->CreateGlyphRunAnalysis2(p, a, b, c, d, e, f, g, h, i)
#define IDWriteFactory6_CreateCustomRenderingParams3(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateCustomRenderingParams3(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory6_CreateFontFaceReference_(p, a, b, c, d) (p)->lpVtbl->CreateFontFaceReference_(p, a, b, c, d)
#define IDWriteFactory6_CreateFontFaceReference(p, a, b, c, d, e) (p)->lpVtbl->CreateFontFaceReference(p, a, b, c, d, e)
#define IDWriteFactory6_GetSystemFontSet(p, a) (p)->lpVtbl->GetSystemFontSet(p, a)
#define IDWriteFactory6_CreateFontSetBuilder(p, a) (p)->lpVtbl->CreateFontSetBuilder(p, a)
#define IDWriteFactory6_CreateFontCollectionFromFontSet(p, a, b) (p)->lpVtbl->CreateFontCollectionFromFontSet(p, a, b)
#define IDWriteFactory6_GetSystemFontCollection1(p, a, b, c) (p)->lpVtbl->GetSystemFontCollection1(p, a, b, c)
#define IDWriteFactory6_GetFontDownloadQueue(p, a) (p)->lpVtbl->GetFontDownloadQueue(p, a)
#define IDWriteFactory6_TranslateColorGlyphRun1(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->TranslateColorGlyphRun1(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory6_ComputeGlyphOrigins_(p, a, b, c) (p)->lpVtbl->ComputeGlyphOrigins_(p, a, b, c)
#define IDWriteFactory6_ComputeGlyphOrigins(p, a, b, c, d, e) (p)->lpVtbl->ComputeGlyphOrigins(p, a, b, c, d, e)
#define IDWriteFactory6_CreateFontSetBuilder1(p, a) (p)->lpVtbl->CreateFontSetBuilder1(p, a)
#define IDWriteFactory6_CreateInMemoryFontFileLoader(p, a) (p)->lpVtbl->CreateInMemoryFontFileLoader(p, a)
#define IDWriteFactory6_CreateHttpFontFileLoader(p, a, b, c) (p)->lpVtbl->CreateHttpFontFileLoader(p, a, b, c)
#define IDWriteFactory6_AnalyzeContainerType(p, a, b) (p)->lpVtbl->AnalyzeContainerType(p, a, b)
#define IDWriteFactory6_UnpackFontFile(p, a, b, c, d) (p)->lpVtbl->UnpackFontFile(p, a, b, c, d)
#define IDWriteFactory6_CreateFontFaceReference1(p, a, b, c, d, e, f) (p)->lpVtbl->CreateFontFaceReference1(p, a, b, c, d, e, f)
#define IDWriteFactory6_CreateFontResource(p, a, b, c) (p)->lpVtbl->CreateFontResource(p, a, b, c)
#define IDWriteFactory6_GetSystemFontSet1(p, a, b) (p)->lpVtbl->GetSystemFontSet1(p, a, b)
#define IDWriteFactory6_GetSystemFontCollection2(p, a, b, c) (p)->lpVtbl->GetSystemFontCollection2(p, a, b, c)
#define IDWriteFactory6_CreateFontCollectionFromFontSet1(p, a, b, c) (p)->lpVtbl->CreateFontCollectionFromFontSet1(p, a, b, c)
#define IDWriteFactory6_CreateFontSetBuilder2(p, a) (p)->lpVtbl->CreateFontSetBuilder2(p, a)
#define IDWriteFactory6_CreateTextFormat1(p, a, b, c, d, e, f, g) (p)->lpVtbl->CreateTextFormat1(p, a, b, c, d, e, f, g)

' ============================================================================
' IDWriteFactory7
' ============================================================================
Type IDWriteFactory7Vtbl As IDWriteFactory7Vtbl_
Type IDWriteFactory7
    lpVtbl As IDWriteFactory7Vtbl Ptr
End Type
Type IDWriteFactory7Vtbl_     '' Extends IDWriteFactory6Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFactory7 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFactory7 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFactory7 Ptr) As ULong
        
    GetSystemFontCollection As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal fontCollection As Any Ptr Ptr, ByVal checkForUpdates As Long = 0 ) As HRESULT
        ' 5. CreateCustomFontCollection
    CreateCustomFontCollection As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal collectionLoader As Any Ptr, ByVal collectionKey As Any Ptr, ByVal collectionKeySize As ULong, ByVal fontCollection As Any Ptr Ptr ) As HRESULT
        ' 6. RegisterFontCollectionLoader
    RegisterFontCollectionLoader As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal fontCollectionLoader As Any Ptr ) As HRESULT
        ' 7. UnregisterFontCollectionLoader
    UnregisterFontCollectionLoader As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal fontCollectionLoader As Any Ptr ) As HRESULT
        ' 8. CreateFontFileReference
    CreateFontFileReference As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal filePath As WString Ptr, ByVal lastWriteTime As FILETIME Ptr, ByVal fontFile As Any Ptr Ptr ) As HRESULT
        ' 9. CreateCustomFontFileReference
    CreateCustomFontFileReference As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal fontFileReferenceKey As Any Ptr, ByVal fontFileReferenceKeySize As ULong, ByVal fontFileLoader As Any Ptr, ByVal fontFile As Any Ptr Ptr ) As HRESULT
        ' 10. CreateFontFace
    CreateFontFace As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal fontFaceType As DWRITE_FONT_FACE_TYPE, ByVal numberOfFiles As ULong, ByVal fontFiles As Any Ptr Ptr, ByVal faceIndex As ULong, ByVal fontFaceSimulationFlags As DWRITE_FONT_SIMULATIONS, ByVal fontFace As Any Ptr Ptr ) As HRESULT
        ' 11. CreateRenderingParams
    CreateRenderingParams As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 12. CreateMonitorRenderingParams
    CreateMonitorRenderingParams As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal monitor As HMONITOR, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 13. CreateCustomRenderingParams
    CreateCustomRenderingParams As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 14. RegisterFontFileLoader
    RegisterFontFileLoader As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal fontFileLoader As Any Ptr ) As HRESULT
        ' 15. UnregisterFontFileLoader
    UnregisterFontFileLoader As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal fontFileLoader As Any Ptr ) As HRESULT
        ' 16. CreateTextFormat
    CreateTextFormat As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal fontFamilyName As WString Ptr, ByVal fontCollection As Any Ptr, ByVal fontWeight As DWRITE_FONT_WEIGHT, ByVal fontStyle As DWRITE_FONT_STYLE, ByVal fontStretch As DWRITE_FONT_STRETCH, ByVal fontSize As Single, ByVal localeName As WString Ptr, ByVal textFormat As IDWriteTextFormat Ptr Ptr ) As HRESULT
        ' 17. CreateTypography
    CreateTypography As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal typography As Any Ptr Ptr ) As HRESULT
        ' 18. GetGdiInterop
    GetGdiInterop As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal gdiInterop As Any Ptr Ptr ) As HRESULT
        ' 19. CreateTextLayout
    CreateTextLayout As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal string As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal maxWidth As Single, ByVal maxHeight As Single, ByVal textLayout As Any Ptr Ptr ) As HRESULT
        ' 20. CreateGdiCompatibleTextLayout
    CreateGdiCompatibleTextLayout As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal string As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal layoutWidth As Single, ByVal layoutHeight As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal useGdiNatural As Long, ByVal textLayout As Any Ptr Ptr ) As HRESULT
        ' 21. CreateEllipsisTrimmingSign
    CreateEllipsisTrimmingSign As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal textFormat As Any Ptr, ByVal trimmingSign As Any Ptr Ptr ) As HRESULT
        ' 22. CreateTextAnalyzer
    CreateTextAnalyzer As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal textAnalyzer As Any Ptr Ptr ) As HRESULT
        ' 23. CreateNumberSubstitution
    CreateNumberSubstitution As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal substitutionMethod As DWRITE_NUMBER_SUBSTITUTION_METHOD, ByVal localeName As WString Ptr, ByVal ignoreUserOverride As Long, ByVal numberSubstitution As Any Ptr Ptr ) As HRESULT
        ' 24. CreateGlyphRunAnalysis
    CreateGlyphRunAnalysis As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRunAnalysis As Any Ptr Ptr ) As HRESULT
        
    GetEudcFontCollection As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal collection As Any Ptr Ptr, ByVal checkForUpdates As Long = 0 ) As HRESULT
        ' 26. CreateCustomRenderingParams
    CreateCustomRenderingParams1 As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal enhancedContrastGrayscale As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        
    GetSystemFontFallback As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal fontFallback As IDWriteFontFallback Ptr Ptr ) As HRESULT
        ' 28. CreateFontFallbackBuilder
    CreateFontFallbackBuilder As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal fontFallbackBuilder As IDWriteFontFallbackBuilder Ptr Ptr ) As HRESULT
        ' 29. TranslateColorGlyphRun
    TranslateColorGlyphRun As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal worldToDeviceTransform As DWRITE_MATRIX Ptr, ByVal colorPaletteIndex As ULong, ByVal colorLayers As IDWriteColorGlyphRunEnumerator Ptr Ptr ) As HRESULT
        ' 30. CreateCustomRenderingParams
    CreateCustomRenderingParams2 As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal grayscaleEnhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal renderingParams As IDWriteRenderingParams2 Ptr Ptr ) As HRESULT
        ' 31. CreateGlyphRunAnalysis
    CreateGlyphRunAnalysis1 As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal transform As DWRITE_MATRIX Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal antialiasMode As DWRITE_TEXT_ANTIALIAS_MODE, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRunAnalysis As IDWriteGlyphRunAnalysis Ptr Ptr ) As HRESULT
        
    CreateGlyphRunAnalysis2 As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal transform As DWRITE_MATRIX Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE1, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal antialiasMode As DWRITE_TEXT_ANTIALIAS_MODE, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRunAnalysis As IDWriteGlyphRunAnalysis Ptr Ptr ) As HRESULT
        ' 33. CreateCustomRenderingParams
    CreateCustomRenderingParams3 As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal grayscaleEnhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE1, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal renderingParams As IDWriteRenderingParams3 Ptr Ptr ) As HRESULT
        ' 34. CreateFontFaceReference_ (from file)
    CreateFontFaceReference_ As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal fontFile As IDWriteFontFile Ptr, ByVal faceIndex As ULong, ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 35. CreateFontFaceReference (from path)
    CreateFontFaceReference As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal filePath As WString Ptr, ByVal lastWriteTime As FILETIME Ptr, ByVal faceIndex As ULong, ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 36. GetSystemFontSet
    GetSystemFontSet As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal fontSet As IDWriteFontSet Ptr Ptr ) As HRESULT
        ' 37. CreateFontSetBuilder
    CreateFontSetBuilder As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal fontSetBuilder As IDWriteFontSetBuilder Ptr Ptr ) As HRESULT
        ' 38. CreateFontCollectionFromFontSet
    CreateFontCollectionFromFontSet As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal fontSet As IDWriteFontSet Ptr, ByVal fontCollection As IDWriteFontCollection1 Ptr Ptr ) As HRESULT
        ' 39. GetSystemFontCollection
    GetSystemFontCollection1 As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal includeDownloadableFonts As Long, ByVal fontCollection As IDWriteFontCollection1 Ptr Ptr, ByVal checkForUpdates As Long ) As HRESULT
        ' 40. GetFontDownloadQueue
    GetFontDownloadQueue As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal fontDownloadQueue As IDWriteFontDownloadQueue Ptr Ptr ) As HRESULT
        
    TranslateColorGlyphRun1 As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal baselineOrigin As D2D1_POINT_2F, ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr, ByVal desiredGlyphImageFormats As DWRITE_GLYPH_IMAGE_FORMATS, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal worldAndDpiTransform As DWRITE_MATRIX Ptr, ByVal colorPaletteIndex As ULong, ByVal colorLayers As IDWriteColorGlyphRunEnumerator1 Ptr Ptr ) As HRESULT
        ' 42. ComputeGlyphOrigins_ (simple version)
    ComputeGlyphOrigins_ As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal baselineOrigin As D2D1_POINT_2F, ByVal glyphOrigins As D2D1_POINT_2F Ptr ) As HRESULT
        ' 43. ComputeGlyphOrigins (with measuring mode)
    ComputeGlyphOrigins As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal baselineOrigin As D2D1_POINT_2F, ByVal worldAndDpiTransform As DWRITE_MATRIX Ptr, ByVal glyphOrigins As D2D1_POINT_2F Ptr ) As HRESULT
        
    CreateFontSetBuilder1 As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal fontSetBuilder As IDWriteFontSetBuilder1 Ptr Ptr ) As HRESULT
        ' 45. CreateInMemoryFontFileLoader
    CreateInMemoryFontFileLoader As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal newLoader As IDWriteInMemoryFontFileLoader Ptr Ptr ) As HRESULT
        ' 46. CreateHttpFontFileLoader
    CreateHttpFontFileLoader As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal referrerUrl As WString Ptr, ByVal extraHeaders As WString Ptr, ByVal newLoader As IDWriteRemoteFontFileLoader Ptr Ptr ) As HRESULT
        ' 47. AnalyzeContainerType
    AnalyzeContainerType As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal fileData As Any Ptr, ByVal fileDataSize As ULong ) As DWRITE_CONTAINER_TYPE
        ' 48. UnpackFontFile
    UnpackFontFile As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal containerType As DWRITE_CONTAINER_TYPE, ByVal fileData As Any Ptr, ByVal fileDataSize As ULong, ByVal unpackedFontStream As IDWriteFontFileStream Ptr Ptr ) As HRESULT
        
    CreateFontFaceReference1 As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal fontFile As IDWriteFontFile Ptr, ByVal faceIndex As ULong, ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong, ByVal fontFaceReference As IDWriteFontFaceReference1 Ptr Ptr ) As HRESULT
        ' 50. CreateFontResource
    CreateFontResource As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal fontFile As IDWriteFontFile Ptr, ByVal faceIndex As ULong, ByVal fontResource As IDWriteFontResource Ptr Ptr ) As HRESULT
        ' 51. GetSystemFontSet
    GetSystemFontSet1 As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal includeDownloadableFonts As Long, ByVal fontSet As IDWriteFontSet1 Ptr Ptr ) As HRESULT
        ' 52. GetSystemFontCollection
    GetSystemFontCollection2 As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal includeDownloadableFonts As Long, ByVal fontFamilyModel As DWRITE_FONT_FAMILY_MODEL, ByVal fontCollection As IDWriteFontCollection2 Ptr Ptr ) As HRESULT
        ' 53. CreateFontCollectionFromFontSet
    CreateFontCollectionFromFontSet1 As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal fontSet As IDWriteFontSet Ptr, ByVal fontFamilyModel As DWRITE_FONT_FAMILY_MODEL, ByVal fontCollection As IDWriteFontCollection2 Ptr Ptr ) As HRESULT
        ' 54. CreateFontSetBuilder
    CreateFontSetBuilder2 As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal fontSetBuilder As IDWriteFontSetBuilder2 Ptr Ptr ) As HRESULT
        ' 55. CreateTextFormat
    CreateTextFormat1 As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal fontFamilyName As WString Ptr, ByVal fontCollection As IDWriteFontCollection Ptr, ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong, ByVal fontSize As Single, ByVal localeName As WString Ptr, ByVal textFormat As IDWriteTextFormat3 Ptr Ptr ) As HRESULT

        
    GetSystemFontSet2 As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal includeDownloadableFonts As Long, ByVal fontSet As IDWriteFontSet2 Ptr Ptr ) As HRESULT
        ' 57. GetSystemFontCollection
    GetSystemFontCollection3 As Function(ByVal This As IDWriteFactory7 Ptr,  ByVal includeDownloadableFonts As Long, ByVal fontFamilyModel As DWRITE_FONT_FAMILY_MODEL, ByVal fontCollection As IDWriteFontCollection3 Ptr Ptr ) As HRESULT
End Type
#define IDWriteFactory7_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFactory7_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFactory7_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFactory7_GetSystemFontCollection(p, a, b) (p)->lpVtbl->GetSystemFontCollection(p, a, b)
#define IDWriteFactory7_CreateCustomFontCollection(p, a, b, c, d) (p)->lpVtbl->CreateCustomFontCollection(p, a, b, c, d)
#define IDWriteFactory7_RegisterFontCollectionLoader(p, a) (p)->lpVtbl->RegisterFontCollectionLoader(p, a)
#define IDWriteFactory7_UnregisterFontCollectionLoader(p, a) (p)->lpVtbl->UnregisterFontCollectionLoader(p, a)
#define IDWriteFactory7_CreateFontFileReference(p, a, b, c) (p)->lpVtbl->CreateFontFileReference(p, a, b, c)
#define IDWriteFactory7_CreateCustomFontFileReference(p, a, b, c, d) (p)->lpVtbl->CreateCustomFontFileReference(p, a, b, c, d)
#define IDWriteFactory7_CreateFontFace(p, a, b, c, d, e, f) (p)->lpVtbl->CreateFontFace(p, a, b, c, d, e, f)
#define IDWriteFactory7_CreateRenderingParams(p, a) (p)->lpVtbl->CreateRenderingParams(p, a)
#define IDWriteFactory7_CreateMonitorRenderingParams(p, a, b) (p)->lpVtbl->CreateMonitorRenderingParams(p, a, b)
#define IDWriteFactory7_CreateCustomRenderingParams(p, a, b, c, d, e, f) (p)->lpVtbl->CreateCustomRenderingParams(p, a, b, c, d, e, f)
#define IDWriteFactory7_RegisterFontFileLoader(p, a) (p)->lpVtbl->RegisterFontFileLoader(p, a)
#define IDWriteFactory7_UnregisterFontFileLoader(p, a) (p)->lpVtbl->UnregisterFontFileLoader(p, a)
#define IDWriteFactory7_CreateTextFormat(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateTextFormat(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory7_CreateTypography(p, a) (p)->lpVtbl->CreateTypography(p, a)
#define IDWriteFactory7_GetGdiInterop(p, a) (p)->lpVtbl->GetGdiInterop(p, a)
#define IDWriteFactory7_CreateTextLayout(p, a, b, c, d, e, f) (p)->lpVtbl->CreateTextLayout(p, a, b, c, d, e, f)
#define IDWriteFactory7_CreateGdiCompatibleTextLayout(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->CreateGdiCompatibleTextLayout(p, a, b, c, d, e, f, g, h, i)
#define IDWriteFactory7_CreateEllipsisTrimmingSign(p, a, b) (p)->lpVtbl->CreateEllipsisTrimmingSign(p, a, b)
#define IDWriteFactory7_CreateTextAnalyzer(p, a) (p)->lpVtbl->CreateTextAnalyzer(p, a)
#define IDWriteFactory7_CreateNumberSubstitution(p, a, b, c, d) (p)->lpVtbl->CreateNumberSubstitution(p, a, b, c, d)
#define IDWriteFactory7_CreateGlyphRunAnalysis(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateGlyphRunAnalysis(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory7_GetEudcFontCollection(p, a, b) (p)->lpVtbl->GetEudcFontCollection(p, a, b)
#define IDWriteFactory7_CreateCustomRenderingParams1(p, a, b, c, d, e, f, g) (p)->lpVtbl->CreateCustomRenderingParams1(p, a, b, c, d, e, f, g)
#define IDWriteFactory7_GetSystemFontFallback(p, a) (p)->lpVtbl->GetSystemFontFallback(p, a)
#define IDWriteFactory7_CreateFontFallbackBuilder(p, a) (p)->lpVtbl->CreateFontFallbackBuilder(p, a)
#define IDWriteFactory7_TranslateColorGlyphRun(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->TranslateColorGlyphRun(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory7_CreateCustomRenderingParams2(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateCustomRenderingParams2(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory7_CreateGlyphRunAnalysis1(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->CreateGlyphRunAnalysis1(p, a, b, c, d, e, f, g, h, i)
#define IDWriteFactory7_CreateGlyphRunAnalysis2(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->CreateGlyphRunAnalysis2(p, a, b, c, d, e, f, g, h, i)
#define IDWriteFactory7_CreateCustomRenderingParams3(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateCustomRenderingParams3(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory7_CreateFontFaceReference_(p, a, b, c, d) (p)->lpVtbl->CreateFontFaceReference_(p, a, b, c, d)
#define IDWriteFactory7_CreateFontFaceReference(p, a, b, c, d, e) (p)->lpVtbl->CreateFontFaceReference(p, a, b, c, d, e)
#define IDWriteFactory7_GetSystemFontSet(p, a) (p)->lpVtbl->GetSystemFontSet(p, a)
#define IDWriteFactory7_CreateFontSetBuilder(p, a) (p)->lpVtbl->CreateFontSetBuilder(p, a)
#define IDWriteFactory7_CreateFontCollectionFromFontSet(p, a, b) (p)->lpVtbl->CreateFontCollectionFromFontSet(p, a, b)
#define IDWriteFactory7_GetSystemFontCollection1(p, a, b, c) (p)->lpVtbl->GetSystemFontCollection1(p, a, b, c)
#define IDWriteFactory7_GetFontDownloadQueue(p, a) (p)->lpVtbl->GetFontDownloadQueue(p, a)
#define IDWriteFactory7_TranslateColorGlyphRun1(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->TranslateColorGlyphRun1(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory7_ComputeGlyphOrigins_(p, a, b, c) (p)->lpVtbl->ComputeGlyphOrigins_(p, a, b, c)
#define IDWriteFactory7_ComputeGlyphOrigins(p, a, b, c, d, e) (p)->lpVtbl->ComputeGlyphOrigins(p, a, b, c, d, e)
#define IDWriteFactory7_CreateFontSetBuilder1(p, a) (p)->lpVtbl->CreateFontSetBuilder1(p, a)
#define IDWriteFactory7_CreateInMemoryFontFileLoader(p, a) (p)->lpVtbl->CreateInMemoryFontFileLoader(p, a)
#define IDWriteFactory7_CreateHttpFontFileLoader(p, a, b, c) (p)->lpVtbl->CreateHttpFontFileLoader(p, a, b, c)
#define IDWriteFactory7_AnalyzeContainerType(p, a, b) (p)->lpVtbl->AnalyzeContainerType(p, a, b)
#define IDWriteFactory7_UnpackFontFile(p, a, b, c, d) (p)->lpVtbl->UnpackFontFile(p, a, b, c, d)
#define IDWriteFactory7_CreateFontFaceReference1(p, a, b, c, d, e, f) (p)->lpVtbl->CreateFontFaceReference1(p, a, b, c, d, e, f)
#define IDWriteFactory7_CreateFontResource(p, a, b, c) (p)->lpVtbl->CreateFontResource(p, a, b, c)
#define IDWriteFactory7_GetSystemFontSet1(p, a, b) (p)->lpVtbl->GetSystemFontSet1(p, a, b)
#define IDWriteFactory7_GetSystemFontCollection2(p, a, b, c) (p)->lpVtbl->GetSystemFontCollection2(p, a, b, c)
#define IDWriteFactory7_CreateFontCollectionFromFontSet1(p, a, b, c) (p)->lpVtbl->CreateFontCollectionFromFontSet1(p, a, b, c)
#define IDWriteFactory7_CreateFontSetBuilder2(p, a) (p)->lpVtbl->CreateFontSetBuilder2(p, a)
#define IDWriteFactory7_CreateTextFormat1(p, a, b, c, d, e, f, g) (p)->lpVtbl->CreateTextFormat1(p, a, b, c, d, e, f, g)
#define IDWriteFactory7_GetSystemFontSet2(p, a, b) (p)->lpVtbl->GetSystemFontSet2(p, a, b)
#define IDWriteFactory7_GetSystemFontCollection3(p, a, b, c) (p)->lpVtbl->GetSystemFontCollection3(p, a, b, c)

' ============================================================================
' IDWriteFactory8
' ============================================================================
Type IDWriteFactory8Vtbl As IDWriteFactory8Vtbl_
Type IDWriteFactory8
    lpVtbl As IDWriteFactory8Vtbl Ptr
End Type
Type IDWriteFactory8Vtbl_     '' Extends IDWriteFactory7Vtbl_
    QueryInterface As Function(ByVal This As IDWriteFactory8 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFactory8 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFactory8 Ptr) As ULong
        
    GetSystemFontCollection As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal fontCollection As Any Ptr Ptr, ByVal checkForUpdates As Long = 0 ) As HRESULT
        ' 5. CreateCustomFontCollection
    CreateCustomFontCollection As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal collectionLoader As Any Ptr, ByVal collectionKey As Any Ptr, ByVal collectionKeySize As ULong, ByVal fontCollection As Any Ptr Ptr ) As HRESULT
        ' 6. RegisterFontCollectionLoader
    RegisterFontCollectionLoader As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal fontCollectionLoader As Any Ptr ) As HRESULT
        ' 7. UnregisterFontCollectionLoader
    UnregisterFontCollectionLoader As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal fontCollectionLoader As Any Ptr ) As HRESULT
        ' 8. CreateFontFileReference
    CreateFontFileReference As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal filePath As WString Ptr, ByVal lastWriteTime As FILETIME Ptr, ByVal fontFile As Any Ptr Ptr ) As HRESULT
        ' 9. CreateCustomFontFileReference
    CreateCustomFontFileReference As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal fontFileReferenceKey As Any Ptr, ByVal fontFileReferenceKeySize As ULong, ByVal fontFileLoader As Any Ptr, ByVal fontFile As Any Ptr Ptr ) As HRESULT
        ' 10. CreateFontFace
    CreateFontFace As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal fontFaceType As DWRITE_FONT_FACE_TYPE, ByVal numberOfFiles As ULong, ByVal fontFiles As Any Ptr Ptr, ByVal faceIndex As ULong, ByVal fontFaceSimulationFlags As DWRITE_FONT_SIMULATIONS, ByVal fontFace As Any Ptr Ptr ) As HRESULT
        ' 11. CreateRenderingParams
    CreateRenderingParams As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 12. CreateMonitorRenderingParams
    CreateMonitorRenderingParams As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal monitor As HMONITOR, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 13. CreateCustomRenderingParams
    CreateCustomRenderingParams As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 14. RegisterFontFileLoader
    RegisterFontFileLoader As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal fontFileLoader As Any Ptr ) As HRESULT
        ' 15. UnregisterFontFileLoader
    UnregisterFontFileLoader As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal fontFileLoader As Any Ptr ) As HRESULT
        ' 16. CreateTextFormat
    CreateTextFormat As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal fontFamilyName As WString Ptr, ByVal fontCollection As Any Ptr, ByVal fontWeight As DWRITE_FONT_WEIGHT, ByVal fontStyle As DWRITE_FONT_STYLE, ByVal fontStretch As DWRITE_FONT_STRETCH, ByVal fontSize As Single, ByVal localeName As WString Ptr, ByVal textFormat As IDWriteTextFormat Ptr Ptr ) As HRESULT
        ' 17. CreateTypography
    CreateTypography As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal typography As Any Ptr Ptr ) As HRESULT
        ' 18. GetGdiInterop
    GetGdiInterop As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal gdiInterop As Any Ptr Ptr ) As HRESULT
        ' 19. CreateTextLayout
    CreateTextLayout As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal string As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal maxWidth As Single, ByVal maxHeight As Single, ByVal textLayout As Any Ptr Ptr ) As HRESULT
        ' 20. CreateGdiCompatibleTextLayout
    CreateGdiCompatibleTextLayout As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal string As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal layoutWidth As Single, ByVal layoutHeight As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal useGdiNatural As Long, ByVal textLayout As Any Ptr Ptr ) As HRESULT
        ' 21. CreateEllipsisTrimmingSign
    CreateEllipsisTrimmingSign As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal textFormat As Any Ptr, ByVal trimmingSign As Any Ptr Ptr ) As HRESULT
        ' 22. CreateTextAnalyzer
    CreateTextAnalyzer As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal textAnalyzer As Any Ptr Ptr ) As HRESULT
        ' 23. CreateNumberSubstitution
    CreateNumberSubstitution As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal substitutionMethod As DWRITE_NUMBER_SUBSTITUTION_METHOD, ByVal localeName As WString Ptr, ByVal ignoreUserOverride As Long, ByVal numberSubstitution As Any Ptr Ptr ) As HRESULT
        ' 24. CreateGlyphRunAnalysis
    CreateGlyphRunAnalysis As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRunAnalysis As Any Ptr Ptr ) As HRESULT
        
    GetEudcFontCollection As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal collection As Any Ptr Ptr, ByVal checkForUpdates As Long = 0 ) As HRESULT
        ' 26. CreateCustomRenderingParams
    CreateCustomRenderingParams1 As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal enhancedContrastGrayscale As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        
    GetSystemFontFallback As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal fontFallback As IDWriteFontFallback Ptr Ptr ) As HRESULT
        ' 28. CreateFontFallbackBuilder
    CreateFontFallbackBuilder As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal fontFallbackBuilder As IDWriteFontFallbackBuilder Ptr Ptr ) As HRESULT
        ' 29. TranslateColorGlyphRun
    TranslateColorGlyphRun As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal worldToDeviceTransform As DWRITE_MATRIX Ptr, ByVal colorPaletteIndex As ULong, ByVal colorLayers As IDWriteColorGlyphRunEnumerator Ptr Ptr ) As HRESULT
        ' 30. CreateCustomRenderingParams
    CreateCustomRenderingParams2 As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal grayscaleEnhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal renderingParams As IDWriteRenderingParams2 Ptr Ptr ) As HRESULT
        ' 31. CreateGlyphRunAnalysis
    CreateGlyphRunAnalysis1 As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal transform As DWRITE_MATRIX Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal antialiasMode As DWRITE_TEXT_ANTIALIAS_MODE, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRunAnalysis As IDWriteGlyphRunAnalysis Ptr Ptr ) As HRESULT
        
    CreateGlyphRunAnalysis2 As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal transform As DWRITE_MATRIX Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE1, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal antialiasMode As DWRITE_TEXT_ANTIALIAS_MODE, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRunAnalysis As IDWriteGlyphRunAnalysis Ptr Ptr ) As HRESULT
        ' 33. CreateCustomRenderingParams
    CreateCustomRenderingParams3 As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal grayscaleEnhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE1, ByVal gridFitMode As DWRITE_GRID_FIT_MODE, ByVal renderingParams As IDWriteRenderingParams3 Ptr Ptr ) As HRESULT
        ' 34. CreateFontFaceReference_ (from file)
    CreateFontFaceReference_ As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal fontFile As IDWriteFontFile Ptr, ByVal faceIndex As ULong, ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 35. CreateFontFaceReference (from path)
    CreateFontFaceReference As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal filePath As WString Ptr, ByVal lastWriteTime As FILETIME Ptr, ByVal faceIndex As ULong, ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr ) As HRESULT
        ' 36. GetSystemFontSet
    GetSystemFontSet As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal fontSet As IDWriteFontSet Ptr Ptr ) As HRESULT
        ' 37. CreateFontSetBuilder
    CreateFontSetBuilder As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal fontSetBuilder As IDWriteFontSetBuilder Ptr Ptr ) As HRESULT
        ' 38. CreateFontCollectionFromFontSet
    CreateFontCollectionFromFontSet As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal fontSet As IDWriteFontSet Ptr, ByVal fontCollection As IDWriteFontCollection1 Ptr Ptr ) As HRESULT
        ' 39. GetSystemFontCollection
    GetSystemFontCollection1 As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal includeDownloadableFonts As Long, ByVal fontCollection As IDWriteFontCollection1 Ptr Ptr, ByVal checkForUpdates As Long ) As HRESULT
        ' 40. GetFontDownloadQueue
    GetFontDownloadQueue As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal fontDownloadQueue As IDWriteFontDownloadQueue Ptr Ptr ) As HRESULT
        
    TranslateColorGlyphRun1 As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal baselineOrigin As D2D1_POINT_2F, ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr, ByVal desiredGlyphImageFormats As DWRITE_GLYPH_IMAGE_FORMATS, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal worldAndDpiTransform As DWRITE_MATRIX Ptr, ByVal colorPaletteIndex As ULong, ByVal colorLayers As IDWriteColorGlyphRunEnumerator1 Ptr Ptr ) As HRESULT
        ' 42. ComputeGlyphOrigins_ (simple version)
    ComputeGlyphOrigins_ As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal baselineOrigin As D2D1_POINT_2F, ByVal glyphOrigins As D2D1_POINT_2F Ptr ) As HRESULT
        ' 43. ComputeGlyphOrigins (with measuring mode)
    ComputeGlyphOrigins As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal baselineOrigin As D2D1_POINT_2F, ByVal worldAndDpiTransform As DWRITE_MATRIX Ptr, ByVal glyphOrigins As D2D1_POINT_2F Ptr ) As HRESULT
        
    CreateFontSetBuilder1 As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal fontSetBuilder As IDWriteFontSetBuilder1 Ptr Ptr ) As HRESULT
        ' 45. CreateInMemoryFontFileLoader
    CreateInMemoryFontFileLoader As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal newLoader As IDWriteInMemoryFontFileLoader Ptr Ptr ) As HRESULT
        ' 46. CreateHttpFontFileLoader
    CreateHttpFontFileLoader As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal referrerUrl As WString Ptr, ByVal extraHeaders As WString Ptr, ByVal newLoader As IDWriteRemoteFontFileLoader Ptr Ptr ) As HRESULT
        ' 47. AnalyzeContainerType
    AnalyzeContainerType As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal fileData As Any Ptr, ByVal fileDataSize As ULong ) As DWRITE_CONTAINER_TYPE
        ' 48. UnpackFontFile
    UnpackFontFile As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal containerType As DWRITE_CONTAINER_TYPE, ByVal fileData As Any Ptr, ByVal fileDataSize As ULong, ByVal unpackedFontStream As IDWriteFontFileStream Ptr Ptr ) As HRESULT
        
    CreateFontFaceReference1 As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal fontFile As IDWriteFontFile Ptr, ByVal faceIndex As ULong, ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong, ByVal fontFaceReference As IDWriteFontFaceReference1 Ptr Ptr ) As HRESULT
        ' 50. CreateFontResource
    CreateFontResource As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal fontFile As IDWriteFontFile Ptr, ByVal faceIndex As ULong, ByVal fontResource As IDWriteFontResource Ptr Ptr ) As HRESULT
        ' 51. GetSystemFontSet
    GetSystemFontSet1 As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal includeDownloadableFonts As Long, ByVal fontSet As IDWriteFontSet1 Ptr Ptr ) As HRESULT
        ' 52. GetSystemFontCollection
    GetSystemFontCollection2 As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal includeDownloadableFonts As Long, ByVal fontFamilyModel As DWRITE_FONT_FAMILY_MODEL, ByVal fontCollection As IDWriteFontCollection2 Ptr Ptr ) As HRESULT
        ' 53. CreateFontCollectionFromFontSet
    CreateFontCollectionFromFontSet1 As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal fontSet As IDWriteFontSet Ptr, ByVal fontFamilyModel As DWRITE_FONT_FAMILY_MODEL, ByVal fontCollection As IDWriteFontCollection2 Ptr Ptr ) As HRESULT
        ' 54. CreateFontSetBuilder
    CreateFontSetBuilder2 As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal fontSetBuilder As IDWriteFontSetBuilder2 Ptr Ptr ) As HRESULT
        ' 55. CreateTextFormat
    CreateTextFormat1 As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal fontFamilyName As WString Ptr, ByVal fontCollection As IDWriteFontCollection Ptr, ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, ByVal fontAxisValueCount As ULong, ByVal fontSize As Single, ByVal localeName As WString Ptr, ByVal textFormat As IDWriteTextFormat3 Ptr Ptr ) As HRESULT
        
    GetSystemFontSet2 As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal includeDownloadableFonts As Long, ByVal fontSet As IDWriteFontSet2 Ptr Ptr ) As HRESULT
        ' 57. GetSystemFontCollection
    GetSystemFontCollection3 As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal includeDownloadableFonts As Long, ByVal fontFamilyModel As DWRITE_FONT_FAMILY_MODEL, ByVal fontCollection As IDWriteFontCollection3 Ptr Ptr ) As HRESULT

        
    TranslateColorGlyphRun2 As Function(ByVal This As IDWriteFactory8 Ptr,  ByVal baselineOrigin As D2D1_POINT_2F, ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr, ByVal desiredGlyphImageFormats As DWRITE_GLYPH_IMAGE_FORMATS, ByVal paintFeatureLevel As DWRITE_PAINT_FEATURE_LEVEL, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal worldAndDpiTransform As DWRITE_MATRIX Ptr, ByVal colorPaletteIndex As ULong, ByVal colorEnumerator As IDWriteColorGlyphRunEnumerator1 Ptr Ptr ) As HRESULT
End Type
#define IDWriteFactory8_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFactory8_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFactory8_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFactory8_GetSystemFontCollection(p, a, b) (p)->lpVtbl->GetSystemFontCollection(p, a, b)
#define IDWriteFactory8_CreateCustomFontCollection(p, a, b, c, d) (p)->lpVtbl->CreateCustomFontCollection(p, a, b, c, d)
#define IDWriteFactory8_RegisterFontCollectionLoader(p, a) (p)->lpVtbl->RegisterFontCollectionLoader(p, a)
#define IDWriteFactory8_UnregisterFontCollectionLoader(p, a) (p)->lpVtbl->UnregisterFontCollectionLoader(p, a)
#define IDWriteFactory8_CreateFontFileReference(p, a, b, c) (p)->lpVtbl->CreateFontFileReference(p, a, b, c)
#define IDWriteFactory8_CreateCustomFontFileReference(p, a, b, c, d) (p)->lpVtbl->CreateCustomFontFileReference(p, a, b, c, d)
#define IDWriteFactory8_CreateFontFace(p, a, b, c, d, e, f) (p)->lpVtbl->CreateFontFace(p, a, b, c, d, e, f)
#define IDWriteFactory8_CreateRenderingParams(p, a) (p)->lpVtbl->CreateRenderingParams(p, a)
#define IDWriteFactory8_CreateMonitorRenderingParams(p, a, b) (p)->lpVtbl->CreateMonitorRenderingParams(p, a, b)
#define IDWriteFactory8_CreateCustomRenderingParams(p, a, b, c, d, e, f) (p)->lpVtbl->CreateCustomRenderingParams(p, a, b, c, d, e, f)
#define IDWriteFactory8_RegisterFontFileLoader(p, a) (p)->lpVtbl->RegisterFontFileLoader(p, a)
#define IDWriteFactory8_UnregisterFontFileLoader(p, a) (p)->lpVtbl->UnregisterFontFileLoader(p, a)
#define IDWriteFactory8_CreateTextFormat(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateTextFormat(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory8_CreateTypography(p, a) (p)->lpVtbl->CreateTypography(p, a)
#define IDWriteFactory8_GetGdiInterop(p, a) (p)->lpVtbl->GetGdiInterop(p, a)
#define IDWriteFactory8_CreateTextLayout(p, a, b, c, d, e, f) (p)->lpVtbl->CreateTextLayout(p, a, b, c, d, e, f)
#define IDWriteFactory8_CreateGdiCompatibleTextLayout(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->CreateGdiCompatibleTextLayout(p, a, b, c, d, e, f, g, h, i)
#define IDWriteFactory8_CreateEllipsisTrimmingSign(p, a, b) (p)->lpVtbl->CreateEllipsisTrimmingSign(p, a, b)
#define IDWriteFactory8_CreateTextAnalyzer(p, a) (p)->lpVtbl->CreateTextAnalyzer(p, a)
#define IDWriteFactory8_CreateNumberSubstitution(p, a, b, c, d) (p)->lpVtbl->CreateNumberSubstitution(p, a, b, c, d)
#define IDWriteFactory8_CreateGlyphRunAnalysis(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateGlyphRunAnalysis(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory8_GetEudcFontCollection(p, a, b) (p)->lpVtbl->GetEudcFontCollection(p, a, b)
#define IDWriteFactory8_CreateCustomRenderingParams1(p, a, b, c, d, e, f, g) (p)->lpVtbl->CreateCustomRenderingParams1(p, a, b, c, d, e, f, g)
#define IDWriteFactory8_GetSystemFontFallback(p, a) (p)->lpVtbl->GetSystemFontFallback(p, a)
#define IDWriteFactory8_CreateFontFallbackBuilder(p, a) (p)->lpVtbl->CreateFontFallbackBuilder(p, a)
#define IDWriteFactory8_TranslateColorGlyphRun(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->TranslateColorGlyphRun(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory8_CreateCustomRenderingParams2(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateCustomRenderingParams2(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory8_CreateGlyphRunAnalysis1(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->CreateGlyphRunAnalysis1(p, a, b, c, d, e, f, g, h, i)
#define IDWriteFactory8_CreateGlyphRunAnalysis2(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->CreateGlyphRunAnalysis2(p, a, b, c, d, e, f, g, h, i)
#define IDWriteFactory8_CreateCustomRenderingParams3(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateCustomRenderingParams3(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory8_CreateFontFaceReference_(p, a, b, c, d) (p)->lpVtbl->CreateFontFaceReference_(p, a, b, c, d)
#define IDWriteFactory8_CreateFontFaceReference(p, a, b, c, d, e) (p)->lpVtbl->CreateFontFaceReference(p, a, b, c, d, e)
#define IDWriteFactory8_GetSystemFontSet(p, a) (p)->lpVtbl->GetSystemFontSet(p, a)
#define IDWriteFactory8_CreateFontSetBuilder(p, a) (p)->lpVtbl->CreateFontSetBuilder(p, a)
#define IDWriteFactory8_CreateFontCollectionFromFontSet(p, a, b) (p)->lpVtbl->CreateFontCollectionFromFontSet(p, a, b)
#define IDWriteFactory8_GetSystemFontCollection1(p, a, b, c) (p)->lpVtbl->GetSystemFontCollection1(p, a, b, c)
#define IDWriteFactory8_GetFontDownloadQueue(p, a) (p)->lpVtbl->GetFontDownloadQueue(p, a)
#define IDWriteFactory8_TranslateColorGlyphRun1(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->TranslateColorGlyphRun1(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory8_ComputeGlyphOrigins_(p, a, b, c) (p)->lpVtbl->ComputeGlyphOrigins_(p, a, b, c)
#define IDWriteFactory8_ComputeGlyphOrigins(p, a, b, c, d, e) (p)->lpVtbl->ComputeGlyphOrigins(p, a, b, c, d, e)
#define IDWriteFactory8_CreateFontSetBuilder1(p, a) (p)->lpVtbl->CreateFontSetBuilder1(p, a)
#define IDWriteFactory8_CreateInMemoryFontFileLoader(p, a) (p)->lpVtbl->CreateInMemoryFontFileLoader(p, a)
#define IDWriteFactory8_CreateHttpFontFileLoader(p, a, b, c) (p)->lpVtbl->CreateHttpFontFileLoader(p, a, b, c)
#define IDWriteFactory8_AnalyzeContainerType(p, a, b) (p)->lpVtbl->AnalyzeContainerType(p, a, b)
#define IDWriteFactory8_UnpackFontFile(p, a, b, c, d) (p)->lpVtbl->UnpackFontFile(p, a, b, c, d)
#define IDWriteFactory8_CreateFontFaceReference1(p, a, b, c, d, e, f) (p)->lpVtbl->CreateFontFaceReference1(p, a, b, c, d, e, f)
#define IDWriteFactory8_CreateFontResource(p, a, b, c) (p)->lpVtbl->CreateFontResource(p, a, b, c)
#define IDWriteFactory8_GetSystemFontSet1(p, a, b) (p)->lpVtbl->GetSystemFontSet1(p, a, b)
#define IDWriteFactory8_GetSystemFontCollection2(p, a, b, c) (p)->lpVtbl->GetSystemFontCollection2(p, a, b, c)
#define IDWriteFactory8_CreateFontCollectionFromFontSet1(p, a, b, c) (p)->lpVtbl->CreateFontCollectionFromFontSet1(p, a, b, c)
#define IDWriteFactory8_CreateFontSetBuilder2(p, a) (p)->lpVtbl->CreateFontSetBuilder2(p, a)
#define IDWriteFactory8_CreateTextFormat1(p, a, b, c, d, e, f, g) (p)->lpVtbl->CreateTextFormat1(p, a, b, c, d, e, f, g)
#define IDWriteFactory8_GetSystemFontSet2(p, a, b) (p)->lpVtbl->GetSystemFontSet2(p, a, b)
#define IDWriteFactory8_GetSystemFontCollection3(p, a, b, c) (p)->lpVtbl->GetSystemFontCollection3(p, a, b, c)
#define IDWriteFactory8_TranslateColorGlyphRun2(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->TranslateColorGlyphRun2(p, a, b, c, d, e, f, g, h, i)

' ============================================================================
' IDWriteBitmapRenderTarget2
' ============================================================================
Type IDWriteBitmapRenderTarget2Vtbl As IDWriteBitmapRenderTarget2Vtbl_
Type IDWriteBitmapRenderTarget2
    lpVtbl As IDWriteBitmapRenderTarget2Vtbl Ptr
End Type
Type IDWriteBitmapRenderTarget2Vtbl_     '' Extends IDWriteBitmapRenderTarget1Vtbl_
    QueryInterface As Function(ByVal This As IDWriteBitmapRenderTarget2 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteBitmapRenderTarget2 Ptr) As ULong
    Release As Function(ByVal This As IDWriteBitmapRenderTarget2 Ptr) As ULong
        
    DrawGlyphRun As Function(ByVal This As IDWriteBitmapRenderTarget2 Ptr,  ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal renderingParams As Any Ptr, ByVal textColor As COLORREF, ByVal blackBoxRect As RECT Ptr = 0 ) As HRESULT
        ' 5. GetMemoryDC
    GetMemoryDC As Function(ByVal This As IDWriteBitmapRenderTarget2 Ptr) As HDC
        ' 6. GetPixelsPerDip
    GetPixelsPerDip As Function(ByVal This As IDWriteBitmapRenderTarget2 Ptr) As Single
        ' 7. SetPixelsPerDip
    SetPixelsPerDip As Function(ByVal This As IDWriteBitmapRenderTarget2 Ptr,  ByVal pixelsPerDip As Single ) As HRESULT
        ' 8. GetCurrentTransform
    GetCurrentTransform As Function(ByVal This As IDWriteBitmapRenderTarget2 Ptr,  ByVal transform As DWRITE_MATRIX Ptr ) As HRESULT
        ' 9. SetCurrentTransform
    SetCurrentTransform As Function(ByVal This As IDWriteBitmapRenderTarget2 Ptr,  ByVal transform As DWRITE_MATRIX Ptr ) As HRESULT
        ' 10. GetSize
    GetSize As Function(ByVal This As IDWriteBitmapRenderTarget2 Ptr,  ByVal size As SIZE Ptr ) As HRESULT
        ' 11. Resize
    Resize As Function(ByVal This As IDWriteBitmapRenderTarget2 Ptr,  ByVal width As ULong, ByVal height As ULong ) As HRESULT
        
    GetTextAntialiasMode As Function(ByVal This As IDWriteBitmapRenderTarget2 Ptr) As DWRITE_TEXT_ANTIALIAS_MODE
        ' 13. SetTextAntialiasMode
    SetTextAntialiasMode As Function(ByVal This As IDWriteBitmapRenderTarget2 Ptr,  ByVal antialiasMode As DWRITE_TEXT_ANTIALIAS_MODE ) As HRESULT

        
    GetBitmapData As Function(ByVal This As IDWriteBitmapRenderTarget2 Ptr,  ByVal bitmapData As DWRITE_BITMAP_DATA_BGRA32 Ptr ) As HRESULT
End Type
#define IDWriteBitmapRenderTarget2_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteBitmapRenderTarget2_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteBitmapRenderTarget2_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteBitmapRenderTarget2_DrawGlyphRun(p, a, b, c, d, e, f, g) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d, e, f, g)
#define IDWriteBitmapRenderTarget2_GetMemoryDC(p, a) (p)->lpVtbl->GetMemoryDC(p, a)
#define IDWriteBitmapRenderTarget2_GetPixelsPerDip(p, a) (p)->lpVtbl->GetPixelsPerDip(p, a)
#define IDWriteBitmapRenderTarget2_SetPixelsPerDip(p, a) (p)->lpVtbl->SetPixelsPerDip(p, a)
#define IDWriteBitmapRenderTarget2_GetCurrentTransform(p, a) (p)->lpVtbl->GetCurrentTransform(p, a)
#define IDWriteBitmapRenderTarget2_SetCurrentTransform(p, a) (p)->lpVtbl->SetCurrentTransform(p, a)
#define IDWriteBitmapRenderTarget2_GetSize(p, a) (p)->lpVtbl->GetSize(p, a)
#define IDWriteBitmapRenderTarget2_Resize(p, a, b) (p)->lpVtbl->Resize(p, a, b)
#define IDWriteBitmapRenderTarget2_GetTextAntialiasMode(p, a) (p)->lpVtbl->GetTextAntialiasMode(p, a)
#define IDWriteBitmapRenderTarget2_SetTextAntialiasMode(p, a) (p)->lpVtbl->SetTextAntialiasMode(p, a)
#define IDWriteBitmapRenderTarget2_GetBitmapData(p, a) (p)->lpVtbl->GetBitmapData(p, a)

' ============================================================================
' IDWriteBitmapRenderTarget3
' ============================================================================
Type IDWriteBitmapRenderTarget3Vtbl As IDWriteBitmapRenderTarget3Vtbl_
Type IDWriteBitmapRenderTarget3
    lpVtbl As IDWriteBitmapRenderTarget3Vtbl Ptr
End Type
Type IDWriteBitmapRenderTarget3Vtbl_     '' Extends IDWriteBitmapRenderTarget2Vtbl_
    QueryInterface As Function(ByVal This As IDWriteBitmapRenderTarget3 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteBitmapRenderTarget3 Ptr) As ULong
    Release As Function(ByVal This As IDWriteBitmapRenderTarget3 Ptr) As ULong
        
    DrawGlyphRun As Function(ByVal This As IDWriteBitmapRenderTarget3 Ptr,  ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal renderingParams As Any Ptr, ByVal textColor As COLORREF, ByVal blackBoxRect As RECT Ptr = 0 ) As HRESULT
        ' 5. GetMemoryDC
    GetMemoryDC As Function(ByVal This As IDWriteBitmapRenderTarget3 Ptr) As HDC
        ' 6. GetPixelsPerDip
    GetPixelsPerDip As Function(ByVal This As IDWriteBitmapRenderTarget3 Ptr) As Single
        ' 7. SetPixelsPerDip
    SetPixelsPerDip As Function(ByVal This As IDWriteBitmapRenderTarget3 Ptr,  ByVal pixelsPerDip As Single ) As HRESULT
        ' 8. GetCurrentTransform
    GetCurrentTransform As Function(ByVal This As IDWriteBitmapRenderTarget3 Ptr,  ByVal transform As DWRITE_MATRIX Ptr ) As HRESULT
        ' 9. SetCurrentTransform
    SetCurrentTransform As Function(ByVal This As IDWriteBitmapRenderTarget3 Ptr,  ByVal transform As DWRITE_MATRIX Ptr ) As HRESULT
        ' 10. GetSize
    GetSize As Function(ByVal This As IDWriteBitmapRenderTarget3 Ptr,  ByVal size As SIZE Ptr ) As HRESULT
        ' 11. Resize
    Resize As Function(ByVal This As IDWriteBitmapRenderTarget3 Ptr,  ByVal width As ULong, ByVal height As ULong ) As HRESULT
        
    GetTextAntialiasMode As Function(ByVal This As IDWriteBitmapRenderTarget3 Ptr) As DWRITE_TEXT_ANTIALIAS_MODE
        ' 13. SetTextAntialiasMode
    SetTextAntialiasMode As Function(ByVal This As IDWriteBitmapRenderTarget3 Ptr,  ByVal antialiasMode As DWRITE_TEXT_ANTIALIAS_MODE ) As HRESULT
        
    GetBitmapData As Function(ByVal This As IDWriteBitmapRenderTarget3 Ptr,  ByVal bitmapData As DWRITE_BITMAP_DATA_BGRA32 Ptr ) As HRESULT

        
    GetPaintFeatureLevel As Function(ByVal This As IDWriteBitmapRenderTarget3 Ptr) As DWRITE_PAINT_FEATURE_LEVEL
        ' 16. DrawPaintGlyphRun
    DrawPaintGlyphRun As Function(ByVal This As IDWriteBitmapRenderTarget3 Ptr,  ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal glyphImageFormat As DWRITE_GLYPH_IMAGE_FORMATS, ByVal textColor As COLORREF, ByVal colorPaletteIndex As ULong, ByVal blackBoxRect As RECT Ptr ) As HRESULT
        ' 17. DrawGlyphRunWithColorSupport
    DrawGlyphRunWithColorSupport As Function(ByVal This As IDWriteBitmapRenderTarget3 Ptr,  ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal renderingParams As IDWriteRenderingParams Ptr, ByVal textColor As COLORREF, ByVal colorPaletteIndex As ULong, ByVal blackBoxRect As RECT Ptr ) As HRESULT
End Type
#define IDWriteBitmapRenderTarget3_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteBitmapRenderTarget3_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteBitmapRenderTarget3_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteBitmapRenderTarget3_DrawGlyphRun(p, a, b, c, d, e, f, g) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d, e, f, g)
#define IDWriteBitmapRenderTarget3_GetMemoryDC(p, a) (p)->lpVtbl->GetMemoryDC(p, a)
#define IDWriteBitmapRenderTarget3_GetPixelsPerDip(p, a) (p)->lpVtbl->GetPixelsPerDip(p, a)
#define IDWriteBitmapRenderTarget3_SetPixelsPerDip(p, a) (p)->lpVtbl->SetPixelsPerDip(p, a)
#define IDWriteBitmapRenderTarget3_GetCurrentTransform(p, a) (p)->lpVtbl->GetCurrentTransform(p, a)
#define IDWriteBitmapRenderTarget3_SetCurrentTransform(p, a) (p)->lpVtbl->SetCurrentTransform(p, a)
#define IDWriteBitmapRenderTarget3_GetSize(p, a) (p)->lpVtbl->GetSize(p, a)
#define IDWriteBitmapRenderTarget3_Resize(p, a, b) (p)->lpVtbl->Resize(p, a, b)
#define IDWriteBitmapRenderTarget3_GetTextAntialiasMode(p, a) (p)->lpVtbl->GetTextAntialiasMode(p, a)
#define IDWriteBitmapRenderTarget3_SetTextAntialiasMode(p, a) (p)->lpVtbl->SetTextAntialiasMode(p, a)
#define IDWriteBitmapRenderTarget3_GetBitmapData(p, a) (p)->lpVtbl->GetBitmapData(p, a)
#define IDWriteBitmapRenderTarget3_GetPaintFeatureLevel(p, a) (p)->lpVtbl->GetPaintFeatureLevel(p, a)
#define IDWriteBitmapRenderTarget3_DrawPaintGlyphRun(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->DrawPaintGlyphRun(p, a, b, c, d, e, f, g, h)
#define IDWriteBitmapRenderTarget3_DrawGlyphRunWithColorSupport(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->DrawGlyphRunWithColorSupport(p, a, b, c, d, e, f, g, h)


