' Based on the C header files Wine project:
' Copyright (C) the Wine project
' Ported to FB by UEZ
' Build 2026-01-04 beta

#pragma once

#include once "dwrite_2.bi"

' ============================================================================
' DirectWrite 3 - Vollständige und filigrante Portierung nach FreeBASIC
' ============================================================================

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

Enum DWRITE_COLOR_COMPOSITE_MODE
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

Enum DWRITE_LOCALITY
    DWRITE_LOCALITY_REMOTE
    DWRITE_LOCALITY_PARTIAL
    DWRITE_LOCALITY_LOCAL
End Enum

Enum DWRITE_RENDERING_MODE1
    DWRITE_RENDERING_MODE1_DEFAULT
    DWRITE_RENDERING_MODE1_ALIASED
    DWRITE_RENDERING_MODE1_GDI_CLASSIC
    DWRITE_RENDERING_MODE1_GDI_NATURAL
    DWRITE_RENDERING_MODE1_NATURAL
    DWRITE_RENDERING_MODE1_NATURAL_SYMMETRIC
    DWRITE_RENDERING_MODE1_OUTLINE
    DWRITE_RENDERING_MODE1_NATURAL_SYMMETRIC_DOWNSAMPLED
End Enum

Enum DWRITE_FONT_PROPERTY_ID
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

Enum DWRITE_FONT_AXIS_TAG
    DWRITE_FONT_AXIS_TAG_WEIGHT       = &h74686777  '' 'wght'
    DWRITE_FONT_AXIS_TAG_WIDTH        = &h68746477  '' 'wdth'
    DWRITE_FONT_AXIS_TAG_SLANT        = &h746e6c73  '' 'slnt'
    DWRITE_FONT_AXIS_TAG_OPTICAL_SIZE = &h7a73706f  '' 'opsz'
    DWRITE_FONT_AXIS_TAG_ITALIC       = &h6c617469  '' 'ital'
End Enum

Enum DWRITE_FONT_SOURCE_TYPE
    DWRITE_FONT_SOURCE_TYPE_UNKNOWN
    DWRITE_FONT_SOURCE_TYPE_PER_MACHINE
    DWRITE_FONT_SOURCE_TYPE_PER_USER
    DWRITE_FONT_SOURCE_TYPE_APPX_PACKAGE
    DWRITE_FONT_SOURCE_TYPE_REMOTE_FONT_PROVIDER
End Enum

Enum DWRITE_AUTOMATIC_FONT_AXES
    DWRITE_AUTOMATIC_FONT_AXES_NONE
    DWRITE_AUTOMATIC_FONT_AXES_OPTICAL_SIZE
End Enum

Enum DWRITE_FONT_AXIS_ATTRIBUTES
    DWRITE_FONT_AXIS_ATTRIBUTES_NONE
    DWRITE_FONT_AXIS_ATTRIBUTES_VARIABLE
    DWRITE_FONT_AXIS_ATTRIBUTES_HIDDEN
End Enum

Enum DWRITE_FONT_FAMILY_MODEL
    DWRITE_FONT_FAMILY_MODEL_TYPOGRAPHIC
    DWRITE_FONT_FAMILY_MODEL_WEIGHT_STRETCH_STYLE
End Enum

Enum DWRITE_PAINT_TYPE
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
Enum DWRITE_PAINT_FEATURE_LEVEL
    DWRITE_PAINT_FEATURE_LEVEL_NONE = 0
    DWRITE_PAINT_FEATURE_LEVEL_COLR_V0 = 1
    DWRITE_PAINT_FEATURE_LEVEL_COLR_V1 = 2
End Enum
#endif

Enum DWRITE_PAINT_ATTRIBUTES
    DWRITE_PAINT_ATTRIBUTES_NONE = 0
    DWRITE_PAINT_ATTRIBUTES_USES_PALETTE = &h01
    DWRITE_PAINT_ATTRIBUTES_USES_TEXT_COLOR = &h02
End Enum

Enum DWRITE_FONT_LINE_GAP_USAGE
    DWRITE_FONT_LINE_GAP_USAGE_DEFAULT
    DWRITE_FONT_LINE_GAP_USAGE_DISABLED
    DWRITE_FONT_LINE_GAP_USAGE_ENABLED
End Enum

Enum DWRITE_CONTAINER_TYPE
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
    clipBox As D2D_RECT_F
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
Type IDWriteFontDownloadListener Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. DownloadCompleted
    Declare Abstract Sub DownloadCompleted Stdcall ( _
        ByVal queue As IDWriteFontDownloadQueue Ptr, _
        ByVal context As IUnknown Ptr, _
        ByVal downloadResult As HRESULT _
    )
End Type

' ============================================================================
' IDWriteFontDownloadQueue
' ============================================================================
Type IDWriteFontDownloadQueue_ Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. AddListener
    Declare Abstract Function AddListener Stdcall ( _
        ByVal listener As IDWriteFontDownloadListener Ptr, _
        ByVal token As ULong Ptr _
    ) As HRESULT
    
    ' 5. RemoveListener
    Declare Abstract Function RemoveListener Stdcall ( _
        ByVal token As ULong _
    ) As HRESULT
    
    ' 6. IsEmpty
    Declare Abstract Function IsEmpty Stdcall () As Long
    
    ' 7. BeginDownload
    Declare Abstract Function BeginDownload Stdcall ( _
        ByVal context As IUnknown Ptr _
    ) As HRESULT
    
    ' 8. CancelDownload
    Declare Abstract Function CancelDownload Stdcall () As HRESULT
    
    ' 9. GetGenerationCount
    Declare Abstract Function GetGenerationCount Stdcall () As ULongInt
End Type

' ============================================================================
' IDWriteRenderingParams3
' ============================================================================
Type IDWriteRenderingParams3 Extends IDWriteRenderingParams2
    ' 1-10: IDWriteRenderingParams2
    
    ' 11. GetRenderingMode1
    Declare Abstract Function GetRenderingMode1 Stdcall () As DWRITE_RENDERING_MODE1
End Type

' ============================================================================
' IDWriteStringList
' ============================================================================
Type IDWriteStringList Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. GetCount
    Declare Abstract Function GetCount Stdcall () As ULong
    
    ' 5. GetLocaleNameLength
    Declare Abstract Function GetLocaleNameLength Stdcall ( _
        ByVal listIndex As ULong, _
        ByVal length As ULong Ptr _
    ) As HRESULT
    
    ' 6. GetLocaleName
    Declare Abstract Function GetLocaleName Stdcall ( _
        ByVal listIndex As ULong, _
        ByVal localeName As WString Ptr, _
        ByVal size As ULong _
    ) As HRESULT
    
    ' 7. GetStringLength
    Declare Abstract Function GetStringLength Stdcall ( _
        ByVal listIndex As ULong, _
        ByVal length As ULong Ptr _
    ) As HRESULT
    
    ' 8. GetString
    Declare Abstract Function GetString Stdcall ( _
        ByVal listIndex As ULong, _
        ByVal stringBuffer As WString Ptr, _
        ByVal stringSize As ULong _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontSet
' ============================================================================
Type IDWriteFontSet_ Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. GetFontCount
    Declare Abstract Function GetFontCount Stdcall () As ULong
    
    ' 5. GetFontFaceReference
    Declare Abstract Function GetFontFaceReference Stdcall ( _
        ByVal listIndex As ULong, _
        ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr _
    ) As HRESULT
    
    ' 6. FindFontFaceReference
    Declare Abstract Function FindFontFaceReference Stdcall ( _
        ByVal fontFaceReference As IDWriteFontFaceReference Ptr, _
        ByVal listIndex As ULong Ptr, _
        ByVal exists As Long Ptr _
    ) As HRESULT
    
    ' 7. FindFontFace
    Declare Abstract Function FindFontFace Stdcall ( _
        ByVal fontFace As IDWriteFontFace Ptr, _
        ByVal listIndex As ULong Ptr, _
        ByVal exists As Long Ptr _
    ) As HRESULT
    
    ' 8. GetPropertyValues__ (double underscore version)
    Declare Abstract Function GetPropertyValues__ Stdcall ( _
        ByVal propertyID As DWRITE_FONT_PROPERTY_ID, _
        ByVal values As IDWriteStringList Ptr Ptr _
    ) As HRESULT
    
    ' 9. GetPropertyValues_ (single underscore version)
    Declare Abstract Function GetPropertyValues_ Stdcall ( _
        ByVal propertyID As DWRITE_FONT_PROPERTY_ID, _
        ByVal preferredLocaleNames As WString Ptr, _
        ByVal values As IDWriteStringList Ptr Ptr _
    ) As HRESULT
    
    ' 10. GetPropertyValues (by index)
    Declare Abstract Function GetPropertyValues Stdcall ( _
        ByVal listIndex As ULong, _
        ByVal propertyId As DWRITE_FONT_PROPERTY_ID, _
        ByVal exists As Long Ptr, _
        ByVal values As IDWriteLocalizedStrings Ptr Ptr _
    ) As HRESULT
    
    ' 11. GetPropertyOccurrenceCount
    Declare Abstract Function GetPropertyOccurrenceCount Stdcall ( _
        ByVal property As DWRITE_FONT_PROPERTY Ptr, _
        ByVal propertyOccurrenceCount As ULong Ptr _
    ) As HRESULT
    
    ' 12. GetMatchingFonts_ (by family and WWS)
    Declare Abstract Function GetMatchingFonts_ Stdcall ( _
        ByVal familyName As WString Ptr, _
        ByVal fontWeight As DWRITE_FONT_WEIGHT, _
        ByVal fontStretch As DWRITE_FONT_STRETCH, _
        ByVal fontStyle As DWRITE_FONT_STYLE, _
        ByVal filteredSet As IDWriteFontSet Ptr Ptr _
    ) As HRESULT
    
    ' 13. GetMatchingFonts (by properties)
    Declare Abstract Function GetMatchingFonts Stdcall ( _
        ByVal properties As DWRITE_FONT_PROPERTY Ptr, _
        ByVal propertyCount As ULong, _
        ByVal filteredSet As IDWriteFontSet Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontResource
' ============================================================================
Type IDWriteFontResource Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. GetFontFile
    Declare Abstract Function GetFontFile Stdcall ( _
        ByVal fontFile As IDWriteFontFile Ptr Ptr _
    ) As HRESULT
    
    ' 5. GetFontFaceIndex
    Declare Abstract Function GetFontFaceIndex Stdcall () As ULong
    
    ' 6. GetFontAxisCount
    Declare Abstract Function GetFontAxisCount Stdcall () As ULong
    
    ' 7. GetDefaultFontAxisValues
    Declare Abstract Function GetDefaultFontAxisValues Stdcall ( _
        ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, _
        ByVal fontAxisValueCount As ULong _
    ) As HRESULT
    
    ' 8. GetFontAxisRanges
    Declare Abstract Function GetFontAxisRanges Stdcall ( _
        ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, _
        ByVal fontAxisRangeCount As ULong _
    ) As HRESULT
    
    ' 9. GetFontAxisAttributes
    Declare Abstract Function GetFontAxisAttributes Stdcall ( _
        ByVal axisIndex As ULong _
    ) As DWRITE_FONT_AXIS_ATTRIBUTES
    
    ' 10. GetAxisNames
    Declare Abstract Function GetAxisNames Stdcall ( _
        ByVal axisIndex As ULong, _
        ByVal names As IDWriteLocalizedStrings Ptr Ptr _
    ) As HRESULT
    
    ' 11. GetAxisValueNameCount
    Declare Abstract Function GetAxisValueNameCount Stdcall ( _
        ByVal axisIndex As ULong _
    ) As ULong
    
    ' 12. GetAxisValueNames
    Declare Abstract Function GetAxisValueNames Stdcall ( _
        ByVal axisIndex As ULong, _
        ByVal axisValueIndex As ULong, _
        ByVal fontAxisRange As DWRITE_FONT_AXIS_RANGE Ptr, _
        ByVal names As IDWriteLocalizedStrings Ptr Ptr _
    ) As HRESULT
    
    ' 13. HasVariations
    Declare Abstract Function HasVariations Stdcall () As Long
    
    ' 14. CreateFontFace
    Declare Abstract Function CreateFontFace Stdcall ( _
        ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, _
        ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, _
        ByVal fontAxisValueCount As ULong, _
        ByVal fontFace As IDWriteFontFace5 Ptr Ptr _
    ) As HRESULT
    
    ' 15. CreateFontFaceReference
    Declare Abstract Function CreateFontFaceReference Stdcall ( _
        ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, _
        ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, _
        ByVal fontAxisValueCount As ULong, _
        ByVal fontFaceReference As IDWriteFontFaceReference1 Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontSet1
' ============================================================================
Type IDWriteFontSet1 Extends IDWriteFontSet_
    ' 1-13: IDWriteFontSet
    
    ' 14. GetMatchingFonts (with axis values)
    Declare Abstract Function GetMatchingFonts Stdcall ( _
        ByVal fontProperty As DWRITE_FONT_PROPERTY Ptr, _
        ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, _
        ByVal fontAxisValueCount As ULong, _
        ByVal matchingFonts As IDWriteFontSet1 Ptr Ptr _
    ) As HRESULT
    
    ' 15. GetFirstFontResources
    Declare Abstract Function GetFirstFontResources Stdcall ( _
        ByVal filteredFontSet As IDWriteFontSet1 Ptr Ptr _
    ) As HRESULT
    
    ' 16. GetFilteredFonts__ (by indices)
    Declare Abstract Function GetFilteredFonts__ Stdcall ( _
        ByVal indices As ULong Ptr, _
        ByVal indexCount As ULong, _
        ByVal filteredFontSet As IDWriteFontSet1 Ptr Ptr _
    ) As HRESULT
    
    ' 17. GetFilteredFonts_ (by axis ranges)
    Declare Abstract Function GetFilteredFonts_ Stdcall ( _
        ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, _
        ByVal fontAxisRangeCount As ULong, _
        ByVal selectAnyRange As Long, _
        ByVal filteredFontSet As IDWriteFontSet1 Ptr Ptr _
    ) As HRESULT
    
    ' 18. GetFilteredFonts (by properties)
    Declare Abstract Function GetFilteredFonts Stdcall ( _
        ByVal properties As DWRITE_FONT_PROPERTY Ptr, _
        ByVal propertyCount As ULong, _
        ByVal selectAnyProperty As Long, _
        ByVal filteredFontSet As IDWriteFontSet1 Ptr Ptr _
    ) As HRESULT
    
    ' 19. GetFilteredFontIndices_ (by axis ranges)
    Declare Abstract Function GetFilteredFontIndices_ Stdcall ( _
        ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, _
        ByVal fontAxisRangeCount As ULong, _
        ByVal selectAnyRange As Long, _
        ByVal indices As ULong Ptr, _
        ByVal maxIndexCount As ULong, _
        ByVal actualIndexCount As ULong Ptr _
    ) As HRESULT
    
    ' 20. GetFilteredFontIndices (by properties)
    Declare Abstract Function GetFilteredFontIndices Stdcall ( _
        ByVal properties As DWRITE_FONT_PROPERTY Ptr, _
        ByVal propertyCount As ULong, _
        ByVal selectAnyProperty As Long, _
        ByVal indices As ULong Ptr, _
        ByVal maxIndexCount As ULong, _
        ByVal actualIndexCount As ULong Ptr _
    ) As HRESULT
    
    ' 21. GetFontAxisRanges_ (by font index)
    Declare Abstract Function GetFontAxisRanges_ Stdcall ( _
        ByVal listIndex As ULong, _
        ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, _
        ByVal maxFontAxisRangeCount As ULong, _
        ByVal actualFontAxisRangeCount As ULong Ptr _
    ) As HRESULT
    
    ' 22. GetFontAxisRanges (all fonts)
    Declare Abstract Function GetFontAxisRanges Stdcall ( _
        ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, _
        ByVal maxFontAxisRangeCount As ULong, _
        ByVal actualFontAxisRangeCount As ULong Ptr _
    ) As HRESULT
    
    ' 23. GetFontFaceReference
    Declare Abstract Function GetFontFaceReference Stdcall ( _
        ByVal listIndex As ULong, _
        ByVal fontFaceReference As IDWriteFontFaceReference1 Ptr Ptr _
    ) As HRESULT
    
    ' 24. CreateFontResource
    Declare Abstract Function CreateFontResource Stdcall ( _
        ByVal listIndex As ULong, _
        ByVal fontResource As IDWriteFontResource Ptr Ptr _
    ) As HRESULT
    
    ' 25. CreateFontFace
    Declare Abstract Function CreateFontFace Stdcall ( _
        ByVal listIndex As ULong, _
        ByVal fontFace As IDWriteFontFace5 Ptr Ptr _
    ) As HRESULT
    
    ' 26. GetFontLocality
    Declare Abstract Function GetFontLocality Stdcall ( _
        ByVal listIndex As ULong _
    ) As DWRITE_LOCALITY
End Type

' ============================================================================
' IDWriteFont3
' ============================================================================
Type IDWriteFont3 Extends IDWriteFont2
    ' 1-19: IDWriteFont2
    
    ' 20. CreateFontFace
    Declare Abstract Function CreateFontFace Stdcall ( _
        ByVal fontFace As IDWriteFontFace3 Ptr Ptr _
    ) As HRESULT
    
    ' 21. Equals
    Declare Abstract Function Equals Stdcall ( _
        ByVal font As IDWriteFont Ptr _
    ) As Long
    
    ' 22. GetFontFaceReference
    Declare Abstract Function GetFontFaceReference Stdcall ( _
        ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr _
    ) As HRESULT
    
    ' 23. HasCharacter
    Declare Abstract Function HasCharacter Stdcall ( _
        ByVal unicodeValue As ULong _
    ) As Long
    
    ' 24. GetLocality
    Declare Abstract Function GetLocality Stdcall () As DWRITE_LOCALITY
End Type

' ============================================================================
' IDWriteFontFamily1
' ============================================================================
Type IDWriteFontFamily1 Extends IDWriteFontFamily
    ' 1-9: IDWriteFontFamily
    
    ' 10. GetFontLocality
    Declare Abstract Function GetFontLocality Stdcall ( _
        ByVal listIndex As ULong _
    ) As DWRITE_LOCALITY
    
    ' 11. GetFont
    Declare Abstract Function GetFont Stdcall ( _
        ByVal listIndex As ULong, _
        ByVal font As IDWriteFont3 Ptr Ptr _
    ) As HRESULT
    
    ' 12. GetFontFaceReference
    Declare Abstract Function GetFontFaceReference Stdcall ( _
        ByVal listIndex As ULong, _
        ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontFamily2
' ============================================================================
Type IDWriteFontFamily2 Extends IDWriteFontFamily1
    ' 1-12: IDWriteFontFamily1
    
    ' 13. GetMatchingFonts
    Declare Abstract Function GetMatchingFonts Stdcall ( _
        ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, _
        ByVal fontAxisValueCount As ULong, _
        ByVal matchingFonts As IDWriteFontList2 Ptr Ptr _
    ) As HRESULT
    
    ' 14. GetFontSet
    Declare Abstract Function GetFontSet Stdcall ( _
        ByVal fontSet As IDWriteFontSet1 Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontCollection1
' ============================================================================
Type IDWriteFontCollection1 Extends IDWriteFontCollection
    ' 1-7: IDWriteFontCollection
    
    ' 8. GetFontSet
    Declare Abstract Function GetFontSet Stdcall ( _
        ByVal fontSet As IDWriteFontSet Ptr Ptr _
    ) As HRESULT
    
    ' 9. GetFontFamily
    Declare Abstract Function GetFontFamily Stdcall ( _
        ByVal index As ULong, _
        ByVal fontFamily As IDWriteFontFamily1 Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontCollection2
' ============================================================================
Type IDWriteFontCollection2 Extends IDWriteFontCollection1
    ' 1-9: IDWriteFontCollection1
    
    ' 10. GetFontFamily
    Declare Abstract Function GetFontFamily Stdcall ( _
        ByVal index As ULong, _
        ByVal fontFamily As IDWriteFontFamily2 Ptr Ptr _
    ) As HRESULT
    
    ' 11. GetMatchingFonts
    Declare Abstract Function GetMatchingFonts Stdcall ( _
        ByVal familyName As WString Ptr, _
        ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, _
        ByVal fontAxisValueCount As ULong, _
        ByVal fontList As IDWriteFontList2 Ptr Ptr _
    ) As HRESULT
    
    ' 12. GetFontFamilyModel
    Declare Abstract Function GetFontFamilyModel Stdcall () As DWRITE_FONT_FAMILY_MODEL
    
    ' 13. GetFontSet
    Declare Abstract Function GetFontSet Stdcall ( _
        ByVal fontSet As IDWriteFontSet1 Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontCollection3
' ============================================================================
Type IDWriteFontCollection3 Extends IDWriteFontCollection2
    ' 1-13: IDWriteFontCollection2
    
    ' 14. GetExpirationEvent
    Declare Abstract Function GetExpirationEvent Stdcall () As HANDLE
End Type

' ============================================================================
' IDWriteFontFaceReference
' ============================================================================
Type IDWriteFontFaceReference_ Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. CreateFontFace
    Declare Abstract Function CreateFontFace Stdcall ( _
        ByVal fontFace As IDWriteFontFace3 Ptr Ptr _
    ) As HRESULT
    
    ' 5. CreateFontFaceWithSimulations
    Declare Abstract Function CreateFontFaceWithSimulations Stdcall ( _
        ByVal fontFaceSimulationFlags As DWRITE_FONT_SIMULATIONS, _
        ByVal fontFace As IDWriteFontFace3 Ptr Ptr _
    ) As HRESULT
    
    ' 6. Equals
    Declare Abstract Function Equals Stdcall ( _
        ByVal fontFaceReference As IDWriteFontFaceReference Ptr _
    ) As Long
    
    ' 7. GetFontFaceIndex
    Declare Abstract Function GetFontFaceIndex Stdcall () As ULong
    
    ' 8. GetSimulations
    Declare Abstract Function GetSimulations Stdcall () As DWRITE_FONT_SIMULATIONS
    
    ' 9. GetFontFile
    Declare Abstract Function GetFontFile Stdcall ( _
        ByVal fontFile As IDWriteFontFile Ptr Ptr _
    ) As HRESULT
    
    ' 10. GetLocalFileSize
    Declare Abstract Function GetLocalFileSize Stdcall () As ULongInt
    
    ' 11. GetFileSize
    Declare Abstract Function GetFileSize Stdcall () As ULongInt
    
    ' 12. GetFileTime
    Declare Abstract Function GetFileTime Stdcall ( _
        ByVal lastWriteTime As FILETIME Ptr _
    ) As HRESULT
    
    ' 13. GetLocality
    Declare Abstract Function GetLocality Stdcall () As DWRITE_LOCALITY
    
    ' 14. EnqueueFontDownloadRequest
    Declare Abstract Function EnqueueFontDownloadRequest Stdcall () As HRESULT
    
    ' 15. EnqueueCharacterDownloadRequest
    Declare Abstract Function EnqueueCharacterDownloadRequest Stdcall ( _
        ByVal characters As WString Ptr, _
        ByVal characterCount As ULong _
    ) As HRESULT
    
    ' 16. EnqueueGlyphDownloadRequest
    Declare Abstract Function EnqueueGlyphDownloadRequest Stdcall ( _
        ByVal glyphIndices As UShort Ptr, _
        ByVal glyphCount As ULong _
    ) As HRESULT
    
    ' 17. EnqueueFileFragmentDownloadRequest
    Declare Abstract Function EnqueueFileFragmentDownloadRequest Stdcall ( _
        ByVal fileOffset As ULongInt, _
        ByVal fragmentSize As ULongInt _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontFaceReference1
' ============================================================================
Type IDWriteFontFaceReference1_ Extends IDWriteFontFaceReference_
    ' 1-17: IDWriteFontFaceReference
    
    ' 18. CreateFontFace
    Declare Abstract Function CreateFontFace Stdcall ( _
        ByVal fontFace As IDWriteFontFace5 Ptr Ptr _
    ) As HRESULT
    
    ' 19. GetFontAxisValueCount
    Declare Abstract Function GetFontAxisValueCount Stdcall () As ULong
    
    ' 20. GetFontAxisValues
    Declare Abstract Function GetFontAxisValues Stdcall ( _
        ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, _
        ByVal fontAxisValueCount As ULong _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontList1
' ============================================================================
Type IDWriteFontList1 Extends IDWriteFontList
    ' 1-6: IDWriteFontList
    
    ' 7. GetFontLocality
    Declare Abstract Function GetFontLocality Stdcall ( _
        ByVal listIndex As ULong _
    ) As DWRITE_LOCALITY
    
    ' 8. GetFont
    Declare Abstract Function GetFont Stdcall ( _
        ByVal listIndex As ULong, _
        ByVal font As IDWriteFont3 Ptr Ptr _
    ) As HRESULT
    
    ' 9. GetFontFaceReference
    Declare Abstract Function GetFontFaceReference Stdcall ( _
        ByVal listIndex As ULong, _
        ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontList2
' ============================================================================
Type IDWriteFontList2_ Extends IDWriteFontList1
    ' 1-9: IDWriteFontList1
    
    ' 10. GetFontSet
    Declare Abstract Function GetFontSet Stdcall ( _
        ByVal fontSet As IDWriteFontSet1 Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontSet2
' ============================================================================
Type IDWriteFontSet2 Extends IDWriteFontSet1
    ' 1-26: IDWriteFontSet1
    
    ' 27. GetExpirationEvent
    Declare Abstract Function GetExpirationEvent Stdcall () As HANDLE
End Type

' ============================================================================
' IDWriteFontSet3
' ============================================================================
Type IDWriteFontSet3 Extends IDWriteFontSet2
    ' 1-27: IDWriteFontSet2
    
    ' 28. GetFontSourceType
    Declare Abstract Function GetFontSourceType Stdcall ( _
        ByVal fontIndex As ULong _
    ) As DWRITE_FONT_SOURCE_TYPE
    
    ' 29. GetFontSourceNameLength
    Declare Abstract Function GetFontSourceNameLength Stdcall ( _
        ByVal listIndex As ULong _
    ) As ULong
    
    ' 30. GetFontSourceName
    Declare Abstract Function GetFontSourceName Stdcall ( _
        ByVal listIndex As ULong, _
        ByVal stringBuffer As WString Ptr, _
        ByVal stringBufferSize As ULong _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontSet4
' ============================================================================
Type IDWriteFontSet4 Extends IDWriteFontSet3
    ' 1-30: IDWriteFontSet3
    
    ' 31. ConvertWeightStretchStyleToFontAxisValues
    Declare Abstract Function ConvertWeightStretchStyleToFontAxisValues Stdcall ( _
        ByVal inputAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, _
        ByVal inputAxisCount As ULong, _
        ByVal fontWeight As DWRITE_FONT_WEIGHT, _
        ByVal fontStretch As DWRITE_FONT_STRETCH, _
        ByVal fontStyle As DWRITE_FONT_STYLE, _
        ByVal fontSize As Single, _
        ByVal outputAxisValues As DWRITE_FONT_AXIS_VALUE Ptr _
    ) As ULong
    
    ' 32. GetMatchingFonts
    Declare Abstract Function GetMatchingFonts Stdcall ( _
        ByVal familyName As WString Ptr, _
        ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, _
        ByVal fontAxisValueCount As ULong, _
        ByVal allowedSimulations As DWRITE_FONT_SIMULATIONS, _
        ByVal matchingFonts As IDWriteFontSet4 Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontFace3
' ============================================================================
Type IDWriteFontFace3_ Extends IDWriteFontFace2
    ' 1-35: IDWriteFontFace2
    
    ' 36. GetFontFaceReference
    Declare Abstract Function GetFontFaceReference Stdcall ( _
        ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr _
    ) As HRESULT
    
    ' 37. GetPanose
    Declare Abstract Sub GetPanose Stdcall ( _
        ByVal panose As DWRITE_PANOSE Ptr _
    )
    
    ' 38. GetWeight
    Declare Abstract Function GetWeight Stdcall () As DWRITE_FONT_WEIGHT
    
    ' 39. GetStretch
    Declare Abstract Function GetStretch Stdcall () As DWRITE_FONT_STRETCH
    
    ' 40. GetStyle
    Declare Abstract Function GetStyle Stdcall () As DWRITE_FONT_STYLE
    
    ' 41. GetFamilyNames
    Declare Abstract Function GetFamilyNames Stdcall ( _
        ByVal names As IDWriteLocalizedStrings Ptr Ptr _
    ) As HRESULT
    
    ' 42. GetFaceNames
    Declare Abstract Function GetFaceNames Stdcall ( _
        ByVal names As IDWriteLocalizedStrings Ptr Ptr _
    ) As HRESULT
    
    ' 43. GetInformationalStrings
    Declare Abstract Function GetInformationalStrings Stdcall ( _
        ByVal informationalStringID As DWRITE_INFORMATIONAL_STRING_ID, _
        ByVal informationalStrings As IDWriteLocalizedStrings Ptr Ptr, _
        ByVal exists As Long Ptr _
    ) As HRESULT
    
    ' 44. HasCharacter
    Declare Abstract Function HasCharacter Stdcall ( _
        ByVal unicodeValue As ULong _
    ) As Long
    
    ' 45. GetRecommendedRenderingMode
    Declare Abstract Function GetRecommendedRenderingMode Stdcall ( _
        ByVal fontEmSize As Single, _
        ByVal dpiX As Single, _
        ByVal dpiY As Single, _
        ByVal transform As DWRITE_MATRIX Ptr, _
        ByVal isSideways As Long, _
        ByVal outlineThreshold As DWRITE_OUTLINE_THRESHOLD, _
        ByVal measuringMode As DWRITE_MEASURING_MODE, _
        ByVal renderingParams As IDWriteRenderingParams Ptr, _
        ByVal renderingMode As DWRITE_RENDERING_MODE1 Ptr, _
        ByVal gridFitMode As DWRITE_GRID_FIT_MODE Ptr _
    ) As HRESULT
    
    ' 46. IsCharacterLocal
    Declare Abstract Function IsCharacterLocal Stdcall ( _
        ByVal unicodeValue As ULong _
    ) As Long
    
    ' 47. IsGlyphLocal
    Declare Abstract Function IsGlyphLocal Stdcall ( _
        ByVal glyphId As UShort _
    ) As Long
    
    ' 48. AreCharactersLocal
    Declare Abstract Function AreCharactersLocal Stdcall ( _
        ByVal characters As WString Ptr, _
        ByVal characterCount As ULong, _
        ByVal enqueueIfNotLocal As Long, _
        ByVal isLocal As Long Ptr _
    ) As HRESULT
    
    ' 49. AreGlyphsLocal
    Declare Abstract Function AreGlyphsLocal Stdcall ( _
        ByVal glyphIndices As UShort Ptr, _
        ByVal glyphCount As ULong, _
        ByVal enqueueIfNotLocal As Long, _
        ByVal isLocal As Long Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteTextFormat2
' ============================================================================
Type IDWriteTextFormat2 Extends IDWriteTextFormat1
    ' 1-36: IDWriteTextFormat1
    
    ' 37. SetLineSpacing
    Declare Abstract Function SetLineSpacing Stdcall ( _
        ByVal lineSpacingOptions As DWRITE_LINE_SPACING Ptr _
    ) As HRESULT
    
    ' 38. GetLineSpacing
    Declare Abstract Function GetLineSpacing Stdcall ( _
        ByVal lineSpacingOptions As DWRITE_LINE_SPACING Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteTextFormat3
' ============================================================================
Type IDWriteTextFormat3 Extends IDWriteTextFormat2
    ' 1-38: IDWriteTextFormat2
    
    ' 39. SetFontAxisValues
    Declare Abstract Function SetFontAxisValues Stdcall ( _
        ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, _
        ByVal fontAxisValueCount As ULong _
    ) As HRESULT
    
    ' 40. GetFontAxisValueCount
    Declare Abstract Function GetFontAxisValueCount Stdcall () As ULong
    
    ' 41. GetFontAxisValues
    Declare Abstract Function GetFontAxisValues Stdcall ( _
        ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, _
        ByVal fontAxisValueCount As ULong _
    ) As HRESULT
    
    ' 42. GetAutomaticFontAxes
    Declare Abstract Function GetAutomaticFontAxes Stdcall () As DWRITE_AUTOMATIC_FONT_AXES
    
    ' 43. SetAutomaticFontAxes
    Declare Abstract Function SetAutomaticFontAxes Stdcall ( _
        ByVal automaticFontAxes As DWRITE_AUTOMATIC_FONT_AXES _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteTextLayout3
' ============================================================================
Type IDWriteTextLayout3 Extends IDWriteTextLayout2
    ' 1-80: IDWriteTextLayout2
    
    ' 81. InvalidateLayout
    Declare Abstract Function InvalidateLayout Stdcall () As HRESULT
    
    ' 82. SetLineSpacing
    Declare Abstract Function SetLineSpacing Stdcall ( _
        ByVal lineSpacingOptions As DWRITE_LINE_SPACING Ptr _
    ) As HRESULT
    
    ' 83. GetLineSpacing
    Declare Abstract Function GetLineSpacing Stdcall ( _
        ByVal lineSpacingOptions As DWRITE_LINE_SPACING Ptr _
    ) As HRESULT
    
    ' 84. GetLineMetrics
    Declare Abstract Function GetLineMetrics Stdcall ( _
        ByVal lineMetrics As DWRITE_LINE_METRICS1 Ptr, _
        ByVal maxLineCount As ULong, _
        ByVal actualLineCount As ULong Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteTextLayout4
' ============================================================================
Type IDWriteTextLayout4 Extends IDWriteTextLayout3
    ' 1-84: IDWriteTextLayout3
    
    ' 85. SetFontAxisValues
    Declare Abstract Function SetFontAxisValues Stdcall ( _
        ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, _
        ByVal fontAxisValueCount As ULong, _
        ByVal textRange As DWRITE_TEXT_RANGE _
    ) As HRESULT
    
    ' 86. GetFontAxisValueCount
    Declare Abstract Function GetFontAxisValueCount Stdcall ( _
        ByVal currentPosition As ULong _
    ) As ULong
    
    ' 87. GetFontAxisValues
    Declare Abstract Function GetFontAxisValues Stdcall ( _
        ByVal currentPosition As ULong, _
        ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, _
        ByVal fontAxisValueCount As ULong, _
        ByVal textRange As DWRITE_TEXT_RANGE Ptr _
    ) As HRESULT
    
    ' 88. GetAutomaticFontAxes
    Declare Abstract Function GetAutomaticFontAxes Stdcall () As DWRITE_AUTOMATIC_FONT_AXES
    
    ' 89. SetAutomaticFontAxes
    Declare Abstract Function SetAutomaticFontAxes Stdcall ( _
        ByVal automaticFontAxes As DWRITE_AUTOMATIC_FONT_AXES _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontFallback1
' ============================================================================
Type IDWriteFontFallback1 Extends IDWriteFontFallback
    ' 1-4: IDWriteFontFallback
    
    ' 5. MapCharacters
    Declare Abstract Function MapCharacters Stdcall ( _
        ByVal analysisSource As IDWriteTextAnalysisSource Ptr, _
        ByVal textPosition As ULong, _
        ByVal textLength As ULong, _
        ByVal baseFontCollection As IDWriteFontCollection Ptr, _
        ByVal baseFamilyName As WString Ptr, _
        ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, _
        ByVal fontAxisValueCount As ULong, _
        ByVal mappedLength As ULong Ptr, _
        ByVal scale As Single Ptr, _
        ByVal mappedFontFace As IDWriteFontFace5 Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteGdiInterop1
' ============================================================================
Type IDWriteGdiInterop1 Extends IDWriteGdiInterop
    ' 1-8: IDWriteGdiInterop
    
    ' 9. CreateFontFromLOGFONT
    Declare Abstract Function CreateFontFromLOGFONT Stdcall ( _
        ByVal logFont As LOGFONTW Ptr, _
        ByVal fontCollection As IDWriteFontCollection Ptr, _
        ByVal font As IDWriteFont Ptr Ptr _
    ) As HRESULT
    
    ' 10. GetFontSignature_ (FontFace version)
    Declare Abstract Function GetFontSignature_ Stdcall ( _
        ByVal fontFace As IDWriteFontFace Ptr, _
        ByVal fontSignature As FONTSIGNATURE Ptr _
    ) As HRESULT
    
    ' 11. GetFontSignature (Font version)
    Declare Abstract Function GetFontSignature Stdcall ( _
        ByVal font As IDWriteFont Ptr, _
        ByVal fontSignature As FONTSIGNATURE Ptr _
    ) As HRESULT
    
    ' 12. GetMatchingFontsByLOGFONT
    Declare Abstract Function GetMatchingFontsByLOGFONT Stdcall ( _
        ByVal logFont As LOGFONTW Ptr, _
        ByVal fontSet As IDWriteFontSet Ptr, _
        ByVal filteredSet As IDWriteFontSet Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontSetBuilder
' ============================================================================
Type IDWriteFontSetBuilder Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. AddFontFaceReference_ (with properties)
    Declare Abstract Function AddFontFaceReference_ Stdcall ( _
        ByVal fontFaceReference As IDWriteFontFaceReference Ptr, _
        ByVal properties As DWRITE_FONT_PROPERTY Ptr, _
        ByVal propertyCount As ULong _
    ) As HRESULT
    
    ' 5. AddFontFaceReference (simple version)
    Declare Abstract Function AddFontFaceReference Stdcall ( _
        ByVal fontFaceReference As IDWriteFontFaceReference Ptr _
    ) As HRESULT
    
    ' 6. AddFontSet
    Declare Abstract Function AddFontSet Stdcall ( _
        ByVal fontSet As IDWriteFontSet Ptr _
    ) As HRESULT
    
    ' 7. CreateFontSet
    Declare Abstract Function CreateFontSet Stdcall ( _
        ByVal fontSet As IDWriteFontSet Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontSetBuilder1
' ============================================================================
Type IDWriteFontSetBuilder1 Extends IDWriteFontSetBuilder
    ' 1-7: IDWriteFontSetBuilder
    
    ' 8. AddFontFile
    Declare Abstract Function AddFontFile Stdcall ( _
        ByVal fontFile As IDWriteFontFile Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontSetBuilder2
' ============================================================================
Type IDWriteFontSetBuilder2 Extends IDWriteFontSetBuilder1
    ' 1-8: IDWriteFontSetBuilder1
    
    ' 9. AddFont
    Declare Abstract Function AddFont Stdcall ( _
        ByVal fontFile As IDWriteFontFile Ptr, _
        ByVal fontFaceIndex As ULong, _
        ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, _
        ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, _
        ByVal fontAxisValueCount As ULong, _
        ByVal fontAxisRanges As DWRITE_FONT_AXIS_RANGE Ptr, _
        ByVal fontAxisRangeCount As ULong, _
        ByVal properties As DWRITE_FONT_PROPERTY Ptr, _
        ByVal propertyCount As ULong _
    ) As HRESULT
    
    ' 10. AddFontFile (by path)
    Declare Abstract Function AddFontFile Stdcall ( _
        ByVal filePath As WString Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFactory3
' ============================================================================
Type IDWriteFactory3 Extends IDWriteFactory2
    ' 1-31: IDWriteFactory2
    
    ' 32. CreateGlyphRunAnalysis
    Declare Abstract Function CreateGlyphRunAnalysis Stdcall ( _
        ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, _
        ByVal transform As DWRITE_MATRIX Ptr, _
        ByVal renderingMode As DWRITE_RENDERING_MODE1, _
        ByVal measuringMode As DWRITE_MEASURING_MODE, _
        ByVal gridFitMode As DWRITE_GRID_FIT_MODE, _
        ByVal antialiasMode As DWRITE_TEXT_ANTIALIAS_MODE, _
        ByVal baselineOriginX As Single, _
        ByVal baselineOriginY As Single, _
        ByVal glyphRunAnalysis As IDWriteGlyphRunAnalysis Ptr Ptr _
    ) As HRESULT
    
    ' 33. CreateCustomRenderingParams
    Declare Abstract Function CreateCustomRenderingParams Stdcall ( _
        ByVal gamma As Single, _
        ByVal enhancedContrast As Single, _
        ByVal grayscaleEnhancedContrast As Single, _
        ByVal clearTypeLevel As Single, _
        ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, _
        ByVal renderingMode As DWRITE_RENDERING_MODE1, _
        ByVal gridFitMode As DWRITE_GRID_FIT_MODE, _
        ByVal renderingParams As IDWriteRenderingParams3 Ptr Ptr _
    ) As HRESULT
    
    ' 34. CreateFontFaceReference_ (from file)
    Declare Abstract Function CreateFontFaceReference_ Stdcall ( _
        ByVal fontFile As IDWriteFontFile Ptr, _
        ByVal faceIndex As ULong, _
        ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, _
        ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr _
    ) As HRESULT
    
    ' 35. CreateFontFaceReference (from path)
    Declare Abstract Function CreateFontFaceReference Stdcall ( _
        ByVal filePath As WString Ptr, _
        ByVal lastWriteTime As FILETIME Ptr, _
        ByVal faceIndex As ULong, _
        ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, _
        ByVal fontFaceReference As IDWriteFontFaceReference Ptr Ptr _
    ) As HRESULT
    
    ' 36. GetSystemFontSet
    Declare Abstract Function GetSystemFontSet Stdcall ( _
        ByVal fontSet As IDWriteFontSet Ptr Ptr _
    ) As HRESULT
    
    ' 37. CreateFontSetBuilder
    Declare Abstract Function CreateFontSetBuilder Stdcall ( _
        ByVal fontSetBuilder As IDWriteFontSetBuilder Ptr Ptr _
    ) As HRESULT
    
    ' 38. CreateFontCollectionFromFontSet
    Declare Abstract Function CreateFontCollectionFromFontSet Stdcall ( _
        ByVal fontSet As IDWriteFontSet Ptr, _
        ByVal fontCollection As IDWriteFontCollection1 Ptr Ptr _
    ) As HRESULT
    
    ' 39. GetSystemFontCollection
    Declare Abstract Function GetSystemFontCollection Stdcall ( _
        ByVal includeDownloadableFonts As Long, _
        ByVal fontCollection As IDWriteFontCollection1 Ptr Ptr, _
        ByVal checkForUpdates As Long _
    ) As HRESULT
    
    ' 40. GetFontDownloadQueue
    Declare Abstract Function GetFontDownloadQueue Stdcall ( _
        ByVal fontDownloadQueue As IDWriteFontDownloadQueue Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontFace4
' ============================================================================
Type IDWriteFontFace4 Extends IDWriteFontFace3_
    ' 1-49: IDWriteFontFace3
    
    ' 50. GetGlyphImageFormats_ (for specific glyph and ppem range)
    Declare Abstract Function GetGlyphImageFormats_ Stdcall ( _
        ByVal glyphId As UShort, _
        ByVal pixelsPerEmFirst As ULong, _
        ByVal pixelsPerEmLast As ULong, _
        ByVal glyphImageFormats As DWRITE_GLYPH_IMAGE_FORMATS Ptr _
    ) As HRESULT
    
    ' 51. GetGlyphImageFormats (all supported formats)
    Declare Abstract Function GetGlyphImageFormats Stdcall () As DWRITE_GLYPH_IMAGE_FORMATS
    
    ' 52. GetGlyphImageData
    Declare Abstract Function GetGlyphImageData Stdcall ( _
        ByVal glyphId As UShort, _
        ByVal pixelsPerEm As ULong, _
        ByVal glyphImageFormat As DWRITE_GLYPH_IMAGE_FORMATS, _
        ByVal glyphData As DWRITE_GLYPH_IMAGE_DATA Ptr, _
        ByVal glyphDataContext As Any Ptr Ptr _
    ) As HRESULT
    
    ' 53. ReleaseGlyphImageData
    Declare Abstract Sub ReleaseGlyphImageData Stdcall ( _
        ByVal glyphDataContext As Any Ptr _
    )
End Type

' ============================================================================
' IDWriteFontFace5
' ============================================================================
Type IDWriteFontFace5_ Extends IDWriteFontFace4
    ' 1-53: IDWriteFontFace4
    
    ' 54. GetFontAxisValueCount
    Declare Abstract Function GetFontAxisValueCount Stdcall () As ULong
    
    ' 55. GetFontAxisValues
    Declare Abstract Function GetFontAxisValues Stdcall ( _
        ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, _
        ByVal fontAxisValueCount As ULong _
    ) As HRESULT
    
    ' 56. HasVariations
    Declare Abstract Function HasVariations Stdcall () As Long
    
    ' 57. GetFontResource
    Declare Abstract Function GetFontResource Stdcall ( _
        ByVal fontResource As IDWriteFontResource Ptr Ptr _
    ) As HRESULT
    
    ' 58. Equals
    Declare Abstract Function Equals Stdcall ( _
        ByVal fontFace As IDWriteFontFace Ptr _
    ) As Long
End Type

' ============================================================================
' IDWriteFontFace6
' ============================================================================
Type IDWriteFontFace6 Extends IDWriteFontFace5_
    ' 1-58: IDWriteFontFace5
    
    ' 59. GetFamilyNames
    Declare Abstract Function GetFamilyNames Stdcall ( _
        ByVal fontFamilyModel As DWRITE_FONT_FAMILY_MODEL, _
        ByVal names As IDWriteLocalizedStrings Ptr Ptr _
    ) As HRESULT
    
    ' 60. GetFaceNames
    Declare Abstract Function GetFaceNames Stdcall ( _
        ByVal fontFamilyModel As DWRITE_FONT_FAMILY_MODEL, _
        ByVal names As IDWriteLocalizedStrings Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWritePaintReader
' ============================================================================
Type IDWritePaintReader Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. SetCurrentGlyph
    Declare Abstract Function SetCurrentGlyph Stdcall ( _
        ByVal glyphIndex As ULong, _
        ByVal paintElement As DWRITE_PAINT_ELEMENT Ptr, _
        ByVal structSize As ULong, _
        ByVal clipBox As D2D_RECT_F Ptr, _
        ByVal glyphAttributes As DWRITE_PAINT_ATTRIBUTES Ptr = 0 _
    ) As HRESULT
    
    ' 5. SetTextColor
    Declare Abstract Function SetTextColor Stdcall ( _
        ByVal textColor As DWRITE_COLOR_F Ptr _
    ) As HRESULT
    
    ' 6. SetColorPaletteIndex
    Declare Abstract Function SetColorPaletteIndex Stdcall ( _
        ByVal colorPaletteIndex As ULong _
    ) As HRESULT
    
    ' 7. SetCustomColorPalette
    Declare Abstract Function SetCustomColorPalette Stdcall ( _
        ByVal paletteEntries As DWRITE_COLOR_F Ptr, _
        ByVal paletteEntryCount As ULong _
    ) As HRESULT
    
    ' 8. MoveToFirstChild
    Declare Abstract Function MoveToFirstChild Stdcall ( _
        ByVal paintElement As DWRITE_PAINT_ELEMENT Ptr, _
        ByVal structSize As ULong _
    ) As HRESULT
    
    ' 9. MoveToNextSibling
    Declare Abstract Function MoveToNextSibling Stdcall ( _
        ByVal paintElement As DWRITE_PAINT_ELEMENT Ptr, _
        ByVal structSize As ULong _
    ) As HRESULT
    
    ' 10. MoveToParent
    Declare Abstract Function MoveToParent Stdcall () As HRESULT
    
    ' 11. GetGradientStops
    Declare Abstract Function GetGradientStops Stdcall ( _
        ByVal firstGradientStopIndex As ULong, _
        ByVal gradientStopCount As ULong, _
        ByVal gradientStops As D2D1_GRADIENT_STOP Ptr _
    ) As HRESULT
    
    ' 12. GetGradientStopColors
    Declare Abstract Function GetGradientStopColors Stdcall ( _
        ByVal firstGradientStopIndex As ULong, _
        ByVal gradientStopCount As ULong, _
        ByVal gradientStopColors As DWRITE_PAINT_COLOR Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontFace7
' ============================================================================
Type IDWriteFontFace7 Extends IDWriteFontFace6
    ' 1-60: IDWriteFontFace6
    
    ' 61. GetPaintFeatureLevel
    Declare Abstract Function GetPaintFeatureLevel Stdcall ( _
        ByVal glyphImageFormat As DWRITE_GLYPH_IMAGE_FORMATS _
    ) As DWRITE_PAINT_FEATURE_LEVEL
    
    ' 62. CreatePaintReader
    Declare Abstract Function CreatePaintReader Stdcall ( _
        ByVal glyphImageFormat As DWRITE_GLYPH_IMAGE_FORMATS, _
        ByVal paintFeatureLevel As DWRITE_PAINT_FEATURE_LEVEL, _
        ByVal paintReader As IDWritePaintReader Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteColorGlyphRunEnumerator1
' ============================================================================
Type IDWriteColorGlyphRunEnumerator1 Extends IDWriteColorGlyphRunEnumerator
    ' 1-5: IDWriteColorGlyphRunEnumerator
    
    ' 6. GetCurrentRun
    Declare Abstract Function GetCurrentRun Stdcall ( _
        ByVal colorGlyphRun As DWRITE_COLOR_GLYPH_RUN1 Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFactory4
' ============================================================================
Type IDWriteFactory4 Extends IDWriteFactory3
    ' 1-40: IDWriteFactory3
    
    ' 41. TranslateColorGlyphRun
    Declare Abstract Function TranslateColorGlyphRun Stdcall ( _
        ByVal baselineOrigin As D2D1_POINT_2F, _
        ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, _
        ByVal glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr, _
        ByVal desiredGlyphImageFormats As DWRITE_GLYPH_IMAGE_FORMATS, _
        ByVal measuringMode As DWRITE_MEASURING_MODE, _
        ByVal worldAndDpiTransform As DWRITE_MATRIX Ptr, _
        ByVal colorPaletteIndex As ULong, _
        ByVal colorLayers As IDWriteColorGlyphRunEnumerator1 Ptr Ptr _
    ) As HRESULT
    
    ' 42. ComputeGlyphOrigins_ (simple version)
    Declare Abstract Function ComputeGlyphOrigins_ Stdcall ( _
        ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, _
        ByVal baselineOrigin As D2D1_POINT_2F, _
        ByVal glyphOrigins As D2D1_POINT_2F Ptr _
    ) As HRESULT
    
    ' 43. ComputeGlyphOrigins (with measuring mode)
    Declare Abstract Function ComputeGlyphOrigins Stdcall ( _
        ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, _
        ByVal measuringMode As DWRITE_MEASURING_MODE, _
        ByVal baselineOrigin As D2D1_POINT_2F, _
        ByVal worldAndDpiTransform As DWRITE_MATRIX Ptr, _
        ByVal glyphOrigins As D2D1_POINT_2F Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteAsyncResult
' ============================================================================
Type IDWriteAsyncResult Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. GetWaitHandle
    Declare Abstract Function GetWaitHandle Stdcall () As HANDLE
    
    ' 5. GetResult
    Declare Abstract Function GetResult Stdcall () As HRESULT
End Type

' ============================================================================
' IDWriteRemoteFontFileStream
' ============================================================================
Type IDWriteRemoteFontFileStream Extends IDWriteFontFileStream
    ' 1-7: IDWriteFontFileStream
    
    ' 8. GetLocalFileSize
    Declare Abstract Function GetLocalFileSize Stdcall ( _
        ByVal localFileSize As ULongInt Ptr _
    ) As HRESULT
    
    ' 9. GetFileFragmentLocality
    Declare Abstract Function GetFileFragmentLocality Stdcall ( _
        ByVal fileOffset As ULongInt, _
        ByVal fragmentSize As ULongInt, _
        ByVal isLocal As Long Ptr, _
        ByVal partialSize As ULongInt Ptr _
    ) As HRESULT
    
    ' 10. GetLocality
    Declare Abstract Function GetLocality Stdcall () As DWRITE_LOCALITY
    
    ' 11. BeginDownload
    Declare Abstract Function BeginDownload Stdcall ( _
        ByVal downloadOperationID As GUID Ptr, _
        ByVal fileFragments As DWRITE_FILE_FRAGMENT Ptr, _
        ByVal fragmentCount As ULong, _
        ByVal asyncResult As IDWriteAsyncResult Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteRemoteFontFileLoader
' ============================================================================
Type IDWriteRemoteFontFileLoader Extends IDWriteFontFileLoader
    ' 1-4: IDWriteFontFileLoader
    
    ' 5. CreateRemoteStreamFromKey
    Declare Abstract Function CreateRemoteStreamFromKey Stdcall ( _
        ByVal fontFileReferenceKey As Any Ptr, _
        ByVal fontFileReferenceKeySize As ULong, _
        ByVal fontFileStream As IDWriteRemoteFontFileStream Ptr Ptr _
    ) As HRESULT
    
    ' 6. GetLocalityFromKey
    Declare Abstract Function GetLocalityFromKey Stdcall ( _
        ByVal fontFileReferenceKey As Any Ptr, _
        ByVal fontFileReferenceKeySize As ULong, _
        ByVal locality As DWRITE_LOCALITY Ptr _
    ) As HRESULT
    
    ' 7. CreateFontFileReferenceFromUrl
    Declare Abstract Function CreateFontFileReferenceFromUrl Stdcall ( _
        ByVal factory As IDWriteFactory Ptr, _
        ByVal baseUrl As WString Ptr, _
        ByVal fontFileUrl As WString Ptr, _
        ByVal fontFile As IDWriteFontFile Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteInMemoryFontFileLoader
' ============================================================================
Type IDWriteInMemoryFontFileLoader Extends IDWriteFontFileLoader
    ' 1-4: IDWriteFontFileLoader
    
    ' 5. CreateInMemoryFontFileReference
    Declare Abstract Function CreateInMemoryFontFileReference Stdcall ( _
        ByVal factory As IDWriteFactory Ptr, _
        ByVal fontData As Any Ptr, _
        ByVal fontDataSize As ULong, _
        ByVal owner As IUnknown Ptr, _
        ByVal fontFile As IDWriteFontFile Ptr Ptr _
    ) As HRESULT
    
    ' 6. GetFileCount
    Declare Abstract Function GetFileCount Stdcall () As ULong
End Type

' ============================================================================
' IDWriteFactory5
' ============================================================================
Type IDWriteFactory5 Extends IDWriteFactory4
    ' 1-43: IDWriteFactory4
    
    ' 44. CreateFontSetBuilder
    Declare Abstract Function CreateFontSetBuilder Stdcall ( _
        ByVal fontSetBuilder As IDWriteFontSetBuilder1 Ptr Ptr _
    ) As HRESULT
    
    ' 45. CreateInMemoryFontFileLoader
    Declare Abstract Function CreateInMemoryFontFileLoader Stdcall ( _
        ByVal newLoader As IDWriteInMemoryFontFileLoader Ptr Ptr _
    ) As HRESULT
    
    ' 46. CreateHttpFontFileLoader
    Declare Abstract Function CreateHttpFontFileLoader Stdcall ( _
        ByVal referrerUrl As WString Ptr, _
        ByVal extraHeaders As WString Ptr, _
        ByVal newLoader As IDWriteRemoteFontFileLoader Ptr Ptr _
    ) As HRESULT
    
    ' 47. AnalyzeContainerType
    Declare Abstract Function AnalyzeContainerType Stdcall ( _
        ByVal fileData As Any Ptr, _
        ByVal fileDataSize As ULong _
    ) As DWRITE_CONTAINER_TYPE
    
    ' 48. UnpackFontFile
    Declare Abstract Function UnpackFontFile Stdcall ( _
        ByVal containerType As DWRITE_CONTAINER_TYPE, _
        ByVal fileData As Any Ptr, _
        ByVal fileDataSize As ULong, _
        ByVal unpackedFontStream As IDWriteFontFileStream Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFactory6
' ============================================================================
Type IDWriteFactory6 Extends IDWriteFactory5
    ' 1-48: IDWriteFactory5
    
    ' 49. CreateFontFaceReference
    Declare Abstract Function CreateFontFaceReference Stdcall ( _
        ByVal fontFile As IDWriteFontFile Ptr, _
        ByVal faceIndex As ULong, _
        ByVal fontSimulations As DWRITE_FONT_SIMULATIONS, _
        ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, _
        ByVal fontAxisValueCount As ULong, _
        ByVal fontFaceReference As IDWriteFontFaceReference1 Ptr Ptr _
    ) As HRESULT
    
    ' 50. CreateFontResource
    Declare Abstract Function CreateFontResource Stdcall ( _
        ByVal fontFile As IDWriteFontFile Ptr, _
        ByVal faceIndex As ULong, _
        ByVal fontResource As IDWriteFontResource Ptr Ptr _
    ) As HRESULT
    
    ' 51. GetSystemFontSet
    Declare Abstract Function GetSystemFontSet Stdcall ( _
        ByVal includeDownloadableFonts As Long, _
        ByVal fontSet As IDWriteFontSet1 Ptr Ptr _
    ) As HRESULT
    
    ' 52. GetSystemFontCollection
    Declare Abstract Function GetSystemFontCollection Stdcall ( _
        ByVal includeDownloadableFonts As Long, _
        ByVal fontFamilyModel As DWRITE_FONT_FAMILY_MODEL, _
        ByVal fontCollection As IDWriteFontCollection2 Ptr Ptr _
    ) As HRESULT
    
    ' 53. CreateFontCollectionFromFontSet
    Declare Abstract Function CreateFontCollectionFromFontSet Stdcall ( _
        ByVal fontSet As IDWriteFontSet Ptr, _
        ByVal fontFamilyModel As DWRITE_FONT_FAMILY_MODEL, _
        ByVal fontCollection As IDWriteFontCollection2 Ptr Ptr _
    ) As HRESULT
    
    ' 54. CreateFontSetBuilder
    Declare Abstract Function CreateFontSetBuilder Stdcall ( _
        ByVal fontSetBuilder As IDWriteFontSetBuilder2 Ptr Ptr _
    ) As HRESULT
    
    ' 55. CreateTextFormat
    Declare Abstract Function CreateTextFormat Stdcall ( _
        ByVal fontFamilyName As WString Ptr, _
        ByVal fontCollection As IDWriteFontCollection Ptr, _
        ByVal fontAxisValues As DWRITE_FONT_AXIS_VALUE Ptr, _
        ByVal fontAxisValueCount As ULong, _
        ByVal fontSize As Single, _
        ByVal localeName As WString Ptr, _
        ByVal textFormat As IDWriteTextFormat3 Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFactory7
' ============================================================================
Type IDWriteFactory7 Extends IDWriteFactory6
    ' 1-55: IDWriteFactory6
    
    ' 56. GetSystemFontSet
    Declare Abstract Function GetSystemFontSet Stdcall ( _
        ByVal includeDownloadableFonts As Long, _
        ByVal fontSet As IDWriteFontSet2 Ptr Ptr _
    ) As HRESULT
    
    ' 57. GetSystemFontCollection
    Declare Abstract Function GetSystemFontCollection Stdcall ( _
        ByVal includeDownloadableFonts As Long, _
        ByVal fontFamilyModel As DWRITE_FONT_FAMILY_MODEL, _
        ByVal fontCollection As IDWriteFontCollection3 Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFactory8
' ============================================================================
Type IDWriteFactory8 Extends IDWriteFactory7
    ' 1-57: IDWriteFactory7
    
    ' 58. TranslateColorGlyphRun
    Declare Abstract Function TranslateColorGlyphRun Stdcall ( _
        ByVal baselineOrigin As D2D1_POINT_2F, _
        ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, _
        ByVal glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr, _
        ByVal desiredGlyphImageFormats As DWRITE_GLYPH_IMAGE_FORMATS, _
        ByVal paintFeatureLevel As DWRITE_PAINT_FEATURE_LEVEL, _
        ByVal measuringMode As DWRITE_MEASURING_MODE, _
        ByVal worldAndDpiTransform As DWRITE_MATRIX Ptr, _
        ByVal colorPaletteIndex As ULong, _
        ByVal colorEnumerator As IDWriteColorGlyphRunEnumerator1 Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteBitmapRenderTarget2
' ============================================================================
Type IDWriteBitmapRenderTarget2 Extends IDWriteBitmapRenderTarget1
    ' 1-13: IDWriteBitmapRenderTarget1
    
    ' 14. GetBitmapData
    Declare Abstract Function GetBitmapData Stdcall ( _
        ByVal bitmapData As DWRITE_BITMAP_DATA_BGRA32 Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteBitmapRenderTarget3
' ============================================================================
Type IDWriteBitmapRenderTarget3 Extends IDWriteBitmapRenderTarget2
    ' 1-14: IDWriteBitmapRenderTarget2
    
    ' 15. GetPaintFeatureLevel
    Declare Abstract Function GetPaintFeatureLevel Stdcall () As DWRITE_PAINT_FEATURE_LEVEL
    
    ' 16. DrawPaintGlyphRun
    Declare Abstract Function DrawPaintGlyphRun Stdcall ( _
        ByVal baselineOriginX As Single, _
        ByVal baselineOriginY As Single, _
        ByVal measuringMode As DWRITE_MEASURING_MODE, _
        ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, _
        ByVal glyphImageFormat As DWRITE_GLYPH_IMAGE_FORMATS, _
        ByVal textColor As COLORREF, _
        ByVal colorPaletteIndex As ULong, _
        ByVal blackBoxRect As RECT Ptr _
    ) As HRESULT
    
    ' 17. DrawGlyphRunWithColorSupport
    Declare Abstract Function DrawGlyphRunWithColorSupport Stdcall ( _
        ByVal baselineOriginX As Single, _
        ByVal baselineOriginY As Single, _
        ByVal measuringMode As DWRITE_MEASURING_MODE, _
        ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, _
        ByVal renderingParams As IDWriteRenderingParams Ptr, _
        ByVal textColor As COLORREF, _
        ByVal colorPaletteIndex As ULong, _
        ByVal blackBoxRect As RECT Ptr _
    ) As HRESULT
End Type
