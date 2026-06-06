' Based on the C header files Wine project:
' Copyright (C) the Wine project
' Ported to FB by UEZ
' Build 2026-01-04 beta

' ============================================================================
' DirectWrite API - FreeBASIC Translation
' ============================================================================

#pragma once

#inclib "dwrite"

'#include once "unknwn.bi"
#include once "d2d1.bi"
#include once "dcommon.bi"

' ==============================
' DLL imports
' ==============================
Extern "Windows"
Declare Function DWriteCreateFactory stdcall Lib "dwrite" Alias "DWriteCreateFactory" ( _
                        ByVal factoryType As ULong, _
                        ByVal riid As GUID Ptr, _
                        ByVal factory As Any Ptr Ptr) As HRESULT
End Extern

' Forward declarations
'Type IDWriteFactory As Any
'Type IDWriteFontCollection As Any
'Type IDWriteFontFamily As Any
'Type IDWriteFontFace As Any
'Type IDWriteInlineObject As Any
'Type ID2D1SimplifiedGeometrySink As Any

'Type IDWriteGeometrySink As ID2D1SimplifiedGeometrySink

' ============================================================================
' Constants
' ============================================================================

Const DWRITE_ALPHA_MAX = 255
Const LF_FACESIZE = 32

' ============================================================================
' Enumerations
' ============================================================================

Enum DWRITE_FACTORY_TYPE
    DWRITE_FACTORY_TYPE_SHARED = 0
    DWRITE_FACTORY_TYPE_ISOLATED = 1
End Enum

Enum DWRITE_FONT_FILE_TYPE
    DWRITE_FONT_FILE_TYPE_UNKNOWN = 0
    DWRITE_FONT_FILE_TYPE_CFF = 1
    DWRITE_FONT_FILE_TYPE_TRUETYPE = 2
    DWRITE_FONT_FILE_TYPE_OPENTYPE_COLLECTION = 3
    DWRITE_FONT_FILE_TYPE_TYPE1_PFM = 4
    DWRITE_FONT_FILE_TYPE_TYPE1_PFB = 5
    DWRITE_FONT_FILE_TYPE_VECTOR = 6
    DWRITE_FONT_FILE_TYPE_BITMAP = 7
    DWRITE_FONT_FILE_TYPE_TRUETYPE_COLLECTION = 3  ' = OPENTYPE_COLLECTION
End Enum

Enum DWRITE_FONT_FACE_TYPE
    DWRITE_FONT_FACE_TYPE_CFF = 0
    DWRITE_FONT_FACE_TYPE_TRUETYPE = 1
    DWRITE_FONT_FACE_TYPE_OPENTYPE_COLLECTION = 2
    DWRITE_FONT_FACE_TYPE_TYPE1 = 3
    DWRITE_FONT_FACE_TYPE_VECTOR = 4
    DWRITE_FONT_FACE_TYPE_BITMAP = 5
    DWRITE_FONT_FACE_TYPE_UNKNOWN = 6
    DWRITE_FONT_FACE_TYPE_RAW_CFF = 7
    DWRITE_FONT_FACE_TYPE_TRUETYPE_COLLECTION = 2  ' = OPENTYPE_COLLECTION
End Enum

Enum DWRITE_FONT_WEIGHT
    DWRITE_FONT_WEIGHT_THIN = 100
    DWRITE_FONT_WEIGHT_EXTRA_LIGHT = 200
    DWRITE_FONT_WEIGHT_ULTRA_LIGHT = 200
    DWRITE_FONT_WEIGHT_LIGHT = 300
    DWRITE_FONT_WEIGHT_SEMI_LIGHT = 350
    DWRITE_FONT_WEIGHT_NORMAL = 400
    DWRITE_FONT_WEIGHT_REGULAR = 400
    DWRITE_FONT_WEIGHT_MEDIUM = 500
    DWRITE_FONT_WEIGHT_DEMI_BOLD = 600
    DWRITE_FONT_WEIGHT_SEMI_BOLD = 600
    DWRITE_FONT_WEIGHT_BOLD = 700
    DWRITE_FONT_WEIGHT_EXTRA_BOLD = 800
    DWRITE_FONT_WEIGHT_ULTRA_BOLD = 800
    DWRITE_FONT_WEIGHT_BLACK = 900
    DWRITE_FONT_WEIGHT_HEAVY = 900
    DWRITE_FONT_WEIGHT_EXTRA_BLACK = 950
    DWRITE_FONT_WEIGHT_ULTRA_BLACK = 950
End Enum

Enum DWRITE_FONT_STRETCH
    DWRITE_FONT_STRETCH_UNDEFINED = 0
    DWRITE_FONT_STRETCH_ULTRA_CONDENSED = 1
    DWRITE_FONT_STRETCH_EXTRA_CONDENSED = 2
    DWRITE_FONT_STRETCH_CONDENSED = 3
    DWRITE_FONT_STRETCH_SEMI_CONDENSED = 4
    DWRITE_FONT_STRETCH_NORMAL = 5
    DWRITE_FONT_STRETCH_MEDIUM = 5
    DWRITE_FONT_STRETCH_SEMI_EXPANDED = 6
    DWRITE_FONT_STRETCH_EXPANDED = 7
    DWRITE_FONT_STRETCH_EXTRA_EXPANDED = 8
    DWRITE_FONT_STRETCH_ULTRA_EXPANDED = 9
End Enum

Enum DWRITE_FONT_STYLE
    DWRITE_FONT_STYLE_NORMAL = 0
    DWRITE_FONT_STYLE_OBLIQUE = 1
    DWRITE_FONT_STYLE_ITALIC = 2
End Enum

Enum DWRITE_INFORMATIONAL_STRING_ID
    DWRITE_INFORMATIONAL_STRING_NONE = 0
    DWRITE_INFORMATIONAL_STRING_COPYRIGHT_NOTICE = 1
    DWRITE_INFORMATIONAL_STRING_VERSION_STRINGS = 2
    DWRITE_INFORMATIONAL_STRING_TRADEMARK = 3
    DWRITE_INFORMATIONAL_STRING_MANUFACTURER = 4
    DWRITE_INFORMATIONAL_STRING_DESIGNER = 5
    DWRITE_INFORMATIONAL_STRING_DESIGNER_URL = 6
    DWRITE_INFORMATIONAL_STRING_DESCRIPTION = 7
    DWRITE_INFORMATIONAL_STRING_FONT_VENDOR_URL = 8
    DWRITE_INFORMATIONAL_STRING_LICENSE_DESCRIPTION = 9
    DWRITE_INFORMATIONAL_STRING_LICENSE_INFO_URL = 10
    DWRITE_INFORMATIONAL_STRING_WIN32_FAMILY_NAMES = 11
    DWRITE_INFORMATIONAL_STRING_WIN32_SUBFAMILY_NAMES = 12
    DWRITE_INFORMATIONAL_STRING_TYPOGRAPHIC_FAMILY_NAMES = 13
    DWRITE_INFORMATIONAL_STRING_TYPOGRAPHIC_SUBFAMILY_NAMES = 14
    DWRITE_INFORMATIONAL_STRING_SAMPLE_TEXT = 15
    DWRITE_INFORMATIONAL_STRING_FULL_NAME = 16
    DWRITE_INFORMATIONAL_STRING_POSTSCRIPT_NAME = 17
    DWRITE_INFORMATIONAL_STRING_POSTSCRIPT_CID_NAME = 18
    DWRITE_INFORMATIONAL_STRING_WEIGHT_STRETCH_STYLE_FAMILY_NAME = 19
    DWRITE_INFORMATIONAL_STRING_DESIGN_SCRIPT_LANGUAGE_TAG = 20
    DWRITE_INFORMATIONAL_STRING_SUPPORTED_SCRIPT_LANGUAGE_TAG = 21
    DWRITE_INFORMATIONAL_STRING_PREFERRED_FAMILY_NAMES = 13
    DWRITE_INFORMATIONAL_STRING_PREFERRED_SUBFAMILY_NAMES = 14
    DWRITE_INFORMATIONAL_STRING_WWS_FAMILY_NAME = 19
End Enum

Enum DWRITE_FONT_SIMULATIONS
    DWRITE_FONT_SIMULATIONS_NONE = 0
    DWRITE_FONT_SIMULATIONS_BOLD = 1
    DWRITE_FONT_SIMULATIONS_OBLIQUE = 2
End Enum

Enum DWRITE_PIXEL_GEOMETRY
    DWRITE_PIXEL_GEOMETRY_FLAT = 0
    DWRITE_PIXEL_GEOMETRY_RGB = 1
    DWRITE_PIXEL_GEOMETRY_BGR = 2
End Enum

Enum DWRITE_RENDERING_MODE
    DWRITE_RENDERING_MODE_DEFAULT = 0
    DWRITE_RENDERING_MODE_ALIASED = 1
    DWRITE_RENDERING_MODE_GDI_CLASSIC = 2
    DWRITE_RENDERING_MODE_GDI_NATURAL = 3
    DWRITE_RENDERING_MODE_NATURAL = 4
    DWRITE_RENDERING_MODE_NATURAL_SYMMETRIC = 5
    DWRITE_RENDERING_MODE_OUTLINE = 6
    DWRITE_RENDERING_MODE_CLEARTYPE_GDI_CLASSIC = 2
    DWRITE_RENDERING_MODE_CLEARTYPE_GDI_NATURAL = 3
    DWRITE_RENDERING_MODE_CLEARTYPE_NATURAL = 4
    DWRITE_RENDERING_MODE_CLEARTYPE_NATURAL_SYMMETRIC = 5
End Enum

Enum DWRITE_TEXT_ALIGNMENT
    DWRITE_TEXT_ALIGNMENT_LEADING = 0
    DWRITE_TEXT_ALIGNMENT_TRAILING = 1
    DWRITE_TEXT_ALIGNMENT_CENTER = 2
    DWRITE_TEXT_ALIGNMENT_JUSTIFIED = 3
End Enum

Enum DWRITE_PARAGRAPH_ALIGNMENT
    DWRITE_PARAGRAPH_ALIGNMENT_NEAR = 0
    DWRITE_PARAGRAPH_ALIGNMENT_FAR = 1
    DWRITE_PARAGRAPH_ALIGNMENT_CENTER = 2
End Enum

Enum DWRITE_WORD_WRAPPING
    DWRITE_WORD_WRAPPING_WRAP = 0
    DWRITE_WORD_WRAPPING_NO_WRAP = 1
    DWRITE_WORD_WRAPPING_EMERGENCY_BREAK = 2
    DWRITE_WORD_WRAPPING_WHOLE_WORD = 3
    DWRITE_WORD_WRAPPING_CHARACTER = 4
End Enum

Enum DWRITE_READING_DIRECTION
    DWRITE_READING_DIRECTION_LEFT_TO_RIGHT = 0
    DWRITE_READING_DIRECTION_RIGHT_TO_LEFT = 1
    DWRITE_READING_DIRECTION_TOP_TO_BOTTOM = 2
    DWRITE_READING_DIRECTION_BOTTOM_TO_TOP = 3
End Enum

Enum DWRITE_FLOW_DIRECTION
    DWRITE_FLOW_DIRECTION_TOP_TO_BOTTOM = 0
    DWRITE_FLOW_DIRECTION_BOTTOM_TO_TOP = 1
    DWRITE_FLOW_DIRECTION_LEFT_TO_RIGHT = 2
    DWRITE_FLOW_DIRECTION_RIGHT_TO_LEFT = 3
End Enum

Enum DWRITE_TRIMMING_GRANULARITY
    DWRITE_TRIMMING_GRANULARITY_NONE = 0
    DWRITE_TRIMMING_GRANULARITY_CHARACTER = 1
    DWRITE_TRIMMING_GRANULARITY_WORD = 2
End Enum

Enum DWRITE_BREAK_CONDITION
    DWRITE_BREAK_CONDITION_NEUTRAL = 0
    DWRITE_BREAK_CONDITION_CAN_BREAK = 1
    DWRITE_BREAK_CONDITION_MAY_NOT_BREAK = 2
    DWRITE_BREAK_CONDITION_MUST_BREAK = 3
End Enum

Enum DWRITE_LINE_SPACING_METHOD
    DWRITE_LINE_SPACING_METHOD_DEFAULT = 0
    DWRITE_LINE_SPACING_METHOD_UNIFORM = 1
    DWRITE_LINE_SPACING_METHOD_PROPORTIONAL = 2
End Enum

Enum DWRITE_FONT_FEATURE_TAG
    DWRITE_FONT_FEATURE_TAG_ALTERNATIVE_FRACTIONS = &h63726661
    DWRITE_FONT_FEATURE_TAG_PETITE_CAPITALS_FROM_CAPITALS = &h63703263
    DWRITE_FONT_FEATURE_TAG_SMALL_CAPITALS_FROM_CAPITALS = &h63733263
    DWRITE_FONT_FEATURE_TAG_CONTEXTUAL_ALTERNATES = &h746c6163
    DWRITE_FONT_FEATURE_TAG_CASE_SENSITIVE_FORMS = &h65736163
    DWRITE_FONT_FEATURE_TAG_GLYPH_COMPOSITION_DECOMPOSITION = &h706d6363
    DWRITE_FONT_FEATURE_TAG_CONTEXTUAL_LIGATURES = &h67696c63
    DWRITE_FONT_FEATURE_TAG_CAPITAL_SPACING = &h70737063
    DWRITE_FONT_FEATURE_TAG_CONTEXTUAL_SWASH = &h68777363
    DWRITE_FONT_FEATURE_TAG_CURSIVE_POSITIONING = &h73727563
    DWRITE_FONT_FEATURE_TAG_DEFAULT = &h746c6664
    DWRITE_FONT_FEATURE_TAG_DISCRETIONARY_LIGATURES = &h67696c64
    DWRITE_FONT_FEATURE_TAG_EXPERT_FORMS = &h74707865
    DWRITE_FONT_FEATURE_TAG_FRACTIONS = &h63617266
    DWRITE_FONT_FEATURE_TAG_FULL_WIDTH = &h64697766
    DWRITE_FONT_FEATURE_TAG_HALF_FORMS = &h666c6168
    DWRITE_FONT_FEATURE_TAG_HALANT_FORMS = &h6e6c6168
    DWRITE_FONT_FEATURE_TAG_ALTERNATE_HALF_WIDTH = &h746c6168
    DWRITE_FONT_FEATURE_TAG_HISTORICAL_FORMS = &h74736968
    DWRITE_FONT_FEATURE_TAG_HORIZONTAL_KANA_ALTERNATES = &h616e6b68
    DWRITE_FONT_FEATURE_TAG_HISTORICAL_LIGATURES = &h67696c68
    DWRITE_FONT_FEATURE_TAG_HALF_WIDTH = &h64697768
    DWRITE_FONT_FEATURE_TAG_HOJO_KANJI_FORMS = &h6f6a6f68
    DWRITE_FONT_FEATURE_TAG_JIS04_FORMS = &h3430706a
    DWRITE_FONT_FEATURE_TAG_JIS78_FORMS = &h3837706a
    DWRITE_FONT_FEATURE_TAG_JIS83_FORMS = &h3338706a
    DWRITE_FONT_FEATURE_TAG_JIS90_FORMS = &h3039706a
    DWRITE_FONT_FEATURE_TAG_KERNING = &h6e72656b
    DWRITE_FONT_FEATURE_TAG_STANDARD_LIGATURES = &h6167696c
    DWRITE_FONT_FEATURE_TAG_LINING_FIGURES = &h6d756e6c
    DWRITE_FONT_FEATURE_TAG_LOCALIZED_FORMS = &h6c636f6c
    DWRITE_FONT_FEATURE_TAG_MARK_POSITIONING = &h6b72616d
    DWRITE_FONT_FEATURE_TAG_MATHEMATICAL_GREEK = &h6b72676d
    DWRITE_FONT_FEATURE_TAG_MARK_TO_MARK_POSITIONING = &h6b6d6b6d
    DWRITE_FONT_FEATURE_TAG_ALTERNATE_ANNOTATION_FORMS = &h746c616e
    DWRITE_FONT_FEATURE_TAG_NLC_KANJI_FORMS = &h6b636c6e
    DWRITE_FONT_FEATURE_TAG_OLD_STYLE_FIGURES = &h6d756e6f
    DWRITE_FONT_FEATURE_TAG_ORDINALS = &h6e64726f
    DWRITE_FONT_FEATURE_TAG_PROPORTIONAL_ALTERNATE_WIDTH = &h746c6170
    DWRITE_FONT_FEATURE_TAG_PETITE_CAPITALS = &h70616370
    DWRITE_FONT_FEATURE_TAG_PROPORTIONAL_FIGURES = &h6d756e70
    DWRITE_FONT_FEATURE_TAG_PROPORTIONAL_WIDTHS = &h64697770
    DWRITE_FONT_FEATURE_TAG_QUARTER_WIDTHS = &h64697771
    DWRITE_FONT_FEATURE_TAG_REQUIRED_LIGATURES = &h67696c72
    DWRITE_FONT_FEATURE_TAG_RUBY_NOTATION_FORMS = &h79627572
    DWRITE_FONT_FEATURE_TAG_STYLISTIC_ALTERNATES = &h746c6173
    DWRITE_FONT_FEATURE_TAG_SCIENTIFIC_INFERIORS = &h666e6973
    DWRITE_FONT_FEATURE_TAG_SMALL_CAPITALS = &h70636d73
    DWRITE_FONT_FEATURE_TAG_SIMPLIFIED_FORMS = &h6c706d73
    DWRITE_FONT_FEATURE_TAG_STYLISTIC_SET_1 = &h31307373
    DWRITE_FONT_FEATURE_TAG_STYLISTIC_SET_2 = &h32307373
    DWRITE_FONT_FEATURE_TAG_STYLISTIC_SET_3 = &h33307373
    DWRITE_FONT_FEATURE_TAG_STYLISTIC_SET_4 = &h34307373
    DWRITE_FONT_FEATURE_TAG_STYLISTIC_SET_5 = &h35307373
    DWRITE_FONT_FEATURE_TAG_STYLISTIC_SET_6 = &h36307373
    DWRITE_FONT_FEATURE_TAG_STYLISTIC_SET_7 = &h37307373
    DWRITE_FONT_FEATURE_TAG_STYLISTIC_SET_8 = &h38307373
    DWRITE_FONT_FEATURE_TAG_STYLISTIC_SET_9 = &h39307373
    DWRITE_FONT_FEATURE_TAG_STYLISTIC_SET_10 = &h30317373
    DWRITE_FONT_FEATURE_TAG_STYLISTIC_SET_11 = &h31317373
    DWRITE_FONT_FEATURE_TAG_STYLISTIC_SET_12 = &h32317373
    DWRITE_FONT_FEATURE_TAG_STYLISTIC_SET_13 = &h33317373
    DWRITE_FONT_FEATURE_TAG_STYLISTIC_SET_14 = &h34317373
    DWRITE_FONT_FEATURE_TAG_STYLISTIC_SET_15 = &h35317373
    DWRITE_FONT_FEATURE_TAG_STYLISTIC_SET_16 = &h36317373
    DWRITE_FONT_FEATURE_TAG_STYLISTIC_SET_17 = &h37317373
    DWRITE_FONT_FEATURE_TAG_STYLISTIC_SET_18 = &h38317373
    DWRITE_FONT_FEATURE_TAG_STYLISTIC_SET_19 = &h39317373
    DWRITE_FONT_FEATURE_TAG_STYLISTIC_SET_20 = &h30327373
    DWRITE_FONT_FEATURE_TAG_SUBSCRIPT = &h73627573
    DWRITE_FONT_FEATURE_TAG_SUPERSCRIPT = &h73707573
    DWRITE_FONT_FEATURE_TAG_SWASH = &h68737773
    DWRITE_FONT_FEATURE_TAG_TITLING = &h6c746974
    DWRITE_FONT_FEATURE_TAG_TRADITIONAL_NAME_FORMS = &h6d616e74
    DWRITE_FONT_FEATURE_TAG_TABULAR_FIGURES = &h6d756e74
    DWRITE_FONT_FEATURE_TAG_TRADITIONAL_FORMS = &h64617274
    DWRITE_FONT_FEATURE_TAG_THIRD_WIDTHS = &h64697774
    DWRITE_FONT_FEATURE_TAG_UNICASE = &h63696e75
    DWRITE_FONT_FEATURE_TAG_VERTICAL_WRITING = &h74726576
    DWRITE_FONT_FEATURE_TAG_VERTICAL_ALTERNATES_AND_ROTATION = &h32747276
    DWRITE_FONT_FEATURE_TAG_SLASHED_ZERO = &h6f72657a
End Enum

Enum DWRITE_SCRIPT_SHAPES
    DWRITE_SCRIPT_SHAPES_DEFAULT = 0
    DWRITE_SCRIPT_SHAPES_NO_VISUAL = 1
End Enum

Enum DWRITE_NUMBER_SUBSTITUTION_METHOD
    DWRITE_NUMBER_SUBSTITUTION_METHOD_FROM_CULTURE = 0
    DWRITE_NUMBER_SUBSTITUTION_METHOD_CONTEXTUAL = 1
    DWRITE_NUMBER_SUBSTITUTION_METHOD_NONE = 2
    DWRITE_NUMBER_SUBSTITUTION_METHOD_NATIONAL = 3
    DWRITE_NUMBER_SUBSTITUTION_METHOD_TRADITIONAL = 4
End Enum

Enum DWRITE_TEXTURE_TYPE
    DWRITE_TEXTURE_ALIASED_1x1 = 0
    DWRITE_TEXTURE_CLEARTYPE_3x1 = 1
End Enum

Enum DWRITE_VERTICAL_GLYPH_ORIENTATION
    DWRITE_VERTICAL_GLYPH_ORIENTATION_DEFAULT = 0,
    DWRITE_VERTICAL_GLYPH_ORIENTATION_STACKED = 1
End Enum

Enum DWRITE_GLYPH_ORIENTATION_ANGLE
    DWRITE_GLYPH_ORIENTATION_ANGLE_0_DEGREES = 0,
    DWRITE_GLYPH_ORIENTATION_ANGLE_90_DEGREES = 1,
    DWRITE_GLYPH_ORIENTATION_ANGLE_180_DEGREES = 2,
    DWRITE_GLYPH_ORIENTATION_ANGLE_270_DEGREES = 3
End Enum

' ============================================================================
' Structures
' ============================================================================

Type DWRITE_FONT_METRICS
    designUnitsPerEm As UShort
    ascent As UShort
    descent As UShort
    lineGap As Short
    capHeight As UShort
    xHeight As UShort
    underlinePosition As Short
    underlineThickness As UShort
    strikethroughPosition As Short
    strikethroughThickness As UShort
End Type

Type DWRITE_GLYPH_METRICS
    leftSideBearing As Long
    advanceWidth As ULong
    rightSideBearing As Long
    topSideBearing As Long
    advanceHeight As ULong
    bottomSideBearing As Long
    verticalOriginY As Long
End Type

Type DWRITE_GLYPH_OFFSET
    advanceOffset As Single
    ascenderOffset As Single
End Type

Type DWRITE_MATRIX
    m11 As Single
    m12 As Single
    m21 As Single
    m22 As Single
    dx As Single
    dy As Single
End Type

Type DWRITE_TRIMMING
    granularity As DWRITE_TRIMMING_GRANULARITY
    delimiter As ULong
    delimiterCount As ULong
End Type

Type DWRITE_GLYPH_RUN
    fontFace As Any Ptr 'IDWriteFontFace
    fontEmSize As Single
    glyphCount As ULong
    glyphIndices As UShort Ptr
    glyphAdvances As Single Ptr
    glyphOffsets As DWRITE_GLYPH_OFFSET Ptr
    isSideways As Long
    bidiLevel As ULong
End Type

Type DWRITE_GLYPH_RUN_DESCRIPTION
    localeName As WString Ptr
    string As WString Ptr
    stringLength As ULong
    clusterMap As UShort Ptr
    textPosition As ULong
End Type

Type DWRITE_UNDERLINE
    width As Single
    thickness As Single
    offset As Single
    runHeight As Single
    readingDirection As DWRITE_READING_DIRECTION
    flowDirection As DWRITE_FLOW_DIRECTION
    localeName As WString Ptr
    measuringMode As DWRITE_MEASURING_MODE
End Type

Type DWRITE_STRIKETHROUGH
    width As Single
    thickness As Single
    offset As Single
    readingDirection As DWRITE_READING_DIRECTION
    flowDirection As DWRITE_FLOW_DIRECTION
    localeName As WString Ptr
    measuringMode As DWRITE_MEASURING_MODE
End Type

Type DWRITE_INLINE_OBJECT_METRICS
    width As Single
    height As Single
    baseline As Single
    supportsSideways As Long
End Type

Type DWRITE_OVERHANG_METRICS
    left As Single
    top As Single
    right As Single
    bottom As Single
End Type

Type DWRITE_FONT_FEATURE
    nameTag As DWRITE_FONT_FEATURE_TAG
    parameter As ULong
End Type

Type DWRITE_TEXT_RANGE
    startPosition As ULong
    length As ULong
End Type

Type DWRITE_LINE_METRICS
    length As ULong
    trailingWhitespaceLength As ULong
    newlineLength As ULong
    height As Single
    baseline As Single
    isTrimmed As Long
End Type

Type DWRITE_TEXT_METRICS
    left As Single
    top As Single
    width As Single
    widthIncludingTrailingWhitespace As Single
    height As Single
    layoutWidth As Single
    layoutHeight As Single
    maxBidiReorderingDepth As ULong
    lineCount As ULong
End Type

Type DWRITE_CLUSTER_METRICS
    width As Single
    length As UShort
    ' Bitfields
    canWrapLineAfter_isWhitespace_isNewline_isSoftHyphen_isRightToLeft_padding As UShort
End Type

Type DWRITE_HIT_TEST_METRICS
    textPosition As ULong
    length As ULong
    left As Single
    top As Single
    width As Single
    height As Single
    bidiLevel As ULong
    isText As Long
    isTrimmed As Long
End Type

Type DWRITE_SCRIPT_ANALYSIS
    script As UShort
    shapes As DWRITE_SCRIPT_SHAPES
End Type

Type DWRITE_LINE_BREAKPOINT
    ' Bitfields packed in one byte
    breakConditionBefore_breakConditionAfter_isWhitespace_isSoftHyphen_padding As UByte
End Type

Type DWRITE_TYPOGRAPHIC_FEATURES
    features As DWRITE_FONT_FEATURE Ptr
    featureCount As ULong
End Type

Type DWRITE_SHAPING_TEXT_PROPERTIES
    ' Bitfields
    isShapedAlone_reserved1_canBreakShapingAfter_reserved As UShort
End Type

Type DWRITE_SHAPING_GLYPH_PROPERTIES
    ' Bitfields
    justification_isClusterStart_isDiacritic_isZeroWidthSpace_reserved As UShort
End Type

'Type LOGFONTW
'    lfHeight As Long
'    lfWidth As Long
'    lfEscapement As Long
'    lfOrientation As Long
'    lfWeight As Long
'    lfItalic As UByte
'    lfUnderline As UByte
'    lfStrikeOut As UByte
'    lfCharSet As UByte
'    lfOutPrecision As UByte
'    lfClipPrecision As UByte
'    lfQuality As UByte
'    lfPitchAndFamily As UByte
'    lfFaceName(LF_FACESIZE - 1) As WString
'End Type


' ============================================================================
' IID Definitions
' ============================================================================
Dim Shared As GUID IID_ID2D1Factory                  = Type<GUID>(&h06152247, &h6F50, &h465A, {&h92, &h45, &h11, &h8B, &hFD, &h3B, &h60, &h07})
Dim Shared IID_IDWriteFontFileStream As GUID = Type<GUID>(&h6d4865fe, &h0ab8, &h4d91, {&h8f, &h62, &h5d, &hd6, &hbe, &h34, &ha3, &he0})
Dim Shared IID_IDWriteFontFileLoader As GUID = Type<GUID>(&h727cad4e, &hd6af, &h4c9e, {&h8a, &h08, &hd6, &h95, &hb1, &h1c, &haa, &h49})
Dim Shared IID_IDWriteLocalFontFileLoader As GUID = Type<GUID>(&hb2d9f3ec, &hc9fe, &h4a11, {&ha2, &hec, &hd8, &h62, &h08, &hf7, &hc0, &ha2})
Dim Shared IID_IDWriteFontFile As GUID = Type<GUID>(&h739d886a, &hcef5, &h47dc, {&h87, &h69, &h1a, &h8b, &h41, &hbe, &hbb, &hb0})
Dim Shared IID_IDWriteFontFileEnumerator As GUID = Type<GUID>(&h72755049, &h5ff7, &h435d, {&h83, &h48, &h4b, &he9, &h7c, &hfa, &h6c, &h7c})
Dim Shared IID_IDWriteFontCollectionLoader As GUID = Type<GUID>(&hcca920e4, &h52f0, &h492b, {&hbf, &ha8, &h29, &hc7, &h2e, &he0, &ha4, &h68})
Dim Shared IID_IDWriteLocalizedStrings As GUID = Type<GUID>(&h08256209, &h099a, &h4b34, {&hb8, &h6d, &hc2, &h2b, &h11, &h0e, &h77, &h71})
Dim Shared IID_IDWriteRenderingParams As GUID = Type<GUID>(&h2f0da53a, &h2add, &h47cd, {&h82, &hee, &hd9, &hec, &h34, &h68, &h8e, &h75})
Dim Shared IID_IDWriteFontFace As GUID = Type<GUID>(&h5f49804d, &h7024, &h4d43, {&hbf, &ha9, &hd2, &h59, &h84, &hf5, &h38, &h49})
Dim Shared IID_IDWriteFont As GUID = Type<GUID>(&hacd16696, &h8c14, &h4f5d, {&h87, &h7e, &hfe, &h3f, &hc1, &hd3, &h27, &h37})
Dim Shared IID_IDWriteFontList As GUID = Type<GUID>(&h1a0d8438, &h1d97, &h4ec1, {&hae, &hf9, &ha2, &hfb, &h86, &hed, &h6a, &hcb})
Dim Shared IID_IDWriteFontFamily As GUID = Type<GUID>(&hda20d8ef, &h812a, &h4c43, {&h98, &h02, &h62, &hec, &h4a, &hbd, &h7a, &hdd})
Dim Shared IID_IDWriteFontCollection As GUID = Type<GUID>(&ha84cee02, &h3eea, &h4eee, {&ha8, &h27, &h87, &hc1, &ha0, &h2a, &h0f, &hcc})
Dim Shared IID_IDWritePixelSnapping As GUID = Type<GUID>(&heaf3a2da, &hecf4, &h4d24, {&hb6, &h44, &hb3, &h4f, &h68, &h42, &h02, &h4b})
Dim Shared IID_IDWriteTextRenderer As GUID = Type<GUID>(&hef8a8135, &h5cc6, &h45fe, {&h88, &h25, &hc5, &ha0, &h72, &h4e, &hb8, &h19})
Dim Shared IID_IDWriteInlineObject As GUID = Type<GUID>(&h8339fde3, &h106f, &h47ab, {&h83, &h73, &h1c, &h62, &h95, &heb, &h10, &hb3})
Dim Shared IID_IDWriteTextFormat As GUID = Type<GUID>(&h9c906818, &h31d7, &h4fd3, {&ha1, &h51, &h7c, &h5e, &h22, &h5d, &hb5, &h5a})
Dim Shared IID_IDWriteTypography As GUID = Type<GUID>(&h55f1112b, &h1dc2, &h4b3c, {&h95, &h41, &hf4, &h68, &h94, &hed, &h85, &hb6})
Dim Shared IID_IDWriteBitmapRenderTarget As GUID = Type<GUID>(&h5e5a32a3, &h8dff, &h4773, {&h9f, &hf6, &h06, &h96, &hea, &hb7, &h72, &h67})
Dim Shared IID_IDWriteGdiInterop As GUID = Type<GUID>(&h1edd9491, &h9853, &h4299, {&h89, &h8f, &h64, &h32, &h98, &h3b, &h6f, &h3a})
Dim Shared IID_IDWriteTextLayout As GUID = Type<GUID>(&h53737037, &h6d14, &h410b, {&h9b, &hfe, &h0b, &h18, &h2b, &hb7, &h09, &h61})
Dim Shared IID_IDWriteNumberSubstitution As GUID = Type<GUID>(&h14885cc9, &hbab0, &h4f90, {&hb6, &hed, &h5c, &h36, &h6a, &h2c, &hd0, &h3d})
Dim Shared IID_IDWriteTextAnalysisSource As GUID = Type<GUID>(&h688e1a58, &h5094, &h47c8, {&had, &hc8, &hfb, &hce, &ha6, &h0a, &he9, &h2b})
Dim Shared IID_IDWriteTextAnalysisSink As GUID = Type<GUID>(&h5810cd44, &h0ca0, &h4701, {&hb3, &hfa, &hbe, &hc5, &h18, &h2a, &he4, &hf6})
Dim Shared IID_IDWriteTextAnalyzer As GUID = Type<GUID>(&hb7e6163e, &h7f46, &h43b4, {&h84, &hb3, &he4, &he6, &h24, &h9c, &h36, &h5d})
Dim Shared IID_IDWriteGlyphRunAnalysis As GUID = Type<GUID>(&h7d97dbf7, &he085, &h42d4, {&h81, &he3, &h6a, &h88, &h3b, &hde, &hd1, &h18})
Dim Shared IID_IDWriteFactory As GUID = Type<GUID>(&hb859ee5a, &hd838, &h4b5b, {&ha2, &he8, &h1a, &hdc, &h7d, &h93, &hdb, &h48})

' ============================================================================
' Interfaces
' ============================================================================

' ============================================================================
' IDWriteFontFileStream
' ============================================================================
Type IDWriteFontFileStream Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. ReadFileFragment
    Declare Abstract Function ReadFileFragment Stdcall ( _
        ByVal fragment_start As Any Ptr Ptr, _
        ByVal offset As ULongInt, _
        ByVal fragment_size As ULongInt, _
        ByVal fragment_context As Any Ptr Ptr _
    ) As HRESULT
    
    ' 5. ReleaseFileFragment
    Declare Abstract Sub ReleaseFileFragment Stdcall ( _
        ByVal fragment_context As Any Ptr _
    )
    
    ' 6. GetFileSize
    Declare Abstract Function GetFileSize Stdcall ( _
        ByVal size As ULongInt Ptr _
    ) As HRESULT
    
    ' 7. GetLastWriteTime
    Declare Abstract Function GetLastWriteTime Stdcall ( _
        ByVal last_writetime As ULongInt Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontFileLoader
' ============================================================================
Type IDWriteFontFileLoader Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. CreateStreamFromKey
    Declare Abstract Function CreateStreamFromKey Stdcall ( _
        ByVal key As Any Ptr, _
        ByVal key_size As ULong, _
        ByVal stream As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteLocalFontFileLoader
' ============================================================================
Type IDWriteLocalFontFileLoader Extends IDWriteFontFileLoader
    ' 1-4: IDWriteFontFileLoader
    
    ' 5. GetFilePathLengthFromKey
    Declare Abstract Function GetFilePathLengthFromKey Stdcall ( _
        ByVal key As Any Ptr, _
        ByVal key_size As ULong, _
        ByVal length As ULong Ptr _
    ) As HRESULT
    
    ' 6. GetFilePathFromKey
    Declare Abstract Function GetFilePathFromKey Stdcall ( _
        ByVal key As Any Ptr, _
        ByVal key_size As ULong, _
        ByVal path As WString Ptr, _
        ByVal length As ULong _
    ) As HRESULT
    
    ' 7. GetLastWriteTimeFromKey
    Declare Abstract Function GetLastWriteTimeFromKey Stdcall ( _
        ByVal key As Any Ptr, _
        ByVal key_size As ULong, _
        ByVal writetime As FILETIME Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontFile
' ============================================================================
Type IDWriteFontFile Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. GetReferenceKey
    Declare Abstract Function GetReferenceKey Stdcall ( _
        ByVal key As Any Ptr Ptr, _
        ByVal key_size As ULong Ptr _
    ) As HRESULT
    
    ' 5. GetLoader
    Declare Abstract Function GetLoader Stdcall ( _
        ByVal loader As Any Ptr Ptr _
    ) As HRESULT
    
    ' 6. Analyze
    Declare Abstract Function Analyze Stdcall ( _
        ByVal is_supported_fonttype As Long Ptr, _
        ByVal file_type As DWRITE_FONT_FILE_TYPE Ptr, _
        ByVal face_type As DWRITE_FONT_FACE_TYPE Ptr, _
        ByVal faces_num As ULong Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontFileEnumerator
' ============================================================================
Type IDWriteFontFileEnumerator Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. MoveNext
    Declare Abstract Function MoveNext Stdcall ( _
        ByVal has_current_file As Long Ptr _
    ) As HRESULT
    
    ' 5. GetCurrentFontFile
    Declare Abstract Function GetCurrentFontFile Stdcall ( _
        ByVal font_file As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontCollectionLoader
' ============================================================================
Type IDWriteFontCollectionLoader Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. CreateEnumeratorFromKey
    Declare Abstract Function CreateEnumeratorFromKey Stdcall ( _
        ByVal factory As Any Ptr, _
        ByVal key As Any Ptr, _
        ByVal key_size As ULong, _
        ByVal enumerator As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteLocalizedStrings
' ============================================================================
Type IDWriteLocalizedStrings Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. GetCount
    Declare Abstract Function GetCount Stdcall () As ULong
    
    ' 5. FindLocaleName
    Declare Abstract Function FindLocaleName Stdcall ( _
        ByVal locale_name As WString Ptr, _
        ByVal index As ULong Ptr, _
        ByVal exists As Long Ptr _
    ) As HRESULT
    
    ' 6. GetLocaleNameLength
    Declare Abstract Function GetLocaleNameLength Stdcall ( _
        ByVal index As ULong, _
        ByVal length As ULong Ptr _
    ) As HRESULT
    
    ' 7. GetLocaleName
    Declare Abstract Function GetLocaleName Stdcall ( _
        ByVal index As ULong, _
        ByVal locale_name As WString Ptr, _
        ByVal size As ULong _
    ) As HRESULT
    
    ' 8. GetStringLength
    Declare Abstract Function GetStringLength Stdcall ( _
        ByVal index As ULong, _
        ByVal length As ULong Ptr _
    ) As HRESULT
    
    ' 9. GetString
    Declare Abstract Function GetString Stdcall ( _
        ByVal index As ULong, _
        ByVal buffer As WString Ptr, _
        ByVal size As ULong _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteRenderingParams
' ============================================================================
Type IDWriteRenderingParams Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. GetGamma
    Declare Abstract Function GetGamma Stdcall () As Single
    
    ' 5. GetEnhancedContrast
    Declare Abstract Function GetEnhancedContrast Stdcall () As Single
    
    ' 6. GetClearTypeLevel
    Declare Abstract Function GetClearTypeLevel Stdcall () As Single
    
    ' 7. GetPixelGeometry
    Declare Abstract Function GetPixelGeometry Stdcall () As DWRITE_PIXEL_GEOMETRY
    
    ' 8. GetRenderingMode
    Declare Abstract Function GetRenderingMode Stdcall () As DWRITE_RENDERING_MODE
End Type

' ============================================================================
' IDWriteFontFace
' ============================================================================
Type IDWriteFontFace Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. GetType
    Declare Abstract Function GetType Stdcall () As DWRITE_FONT_FACE_TYPE
    
    ' 5. GetFiles
    Declare Abstract Function GetFiles Stdcall ( _
        ByVal number_of_files As ULong Ptr, _
        ByVal fontfiles As Any Ptr Ptr _
    ) As HRESULT
    
    ' 6. GetIndex
    Declare Abstract Function GetIndex Stdcall () As ULong
    
    ' 7. GetSimulations
    Declare Abstract Function GetSimulations Stdcall () As DWRITE_FONT_SIMULATIONS
    
    ' 8. IsSymbolFont
    Declare Abstract Function IsSymbolFont Stdcall () As Long
    
    ' 9. GetMetrics
    Declare Abstract Sub GetMetrics Stdcall ( _
        ByVal metrics As DWRITE_FONT_METRICS Ptr _
    )
    
    ' 10. GetGlyphCount
    Declare Abstract Function GetGlyphCount Stdcall () As UShort
    
    ' 11. GetDesignGlyphMetrics
    Declare Abstract Function GetDesignGlyphMetrics Stdcall ( _
        ByVal glyph_indices As UShort Ptr, _
        ByVal glyph_count As ULong, _
        ByVal metrics As DWRITE_GLYPH_METRICS Ptr, _
        ByVal is_sideways As Long _
    ) As HRESULT
    
    ' 12. GetGlyphIndices
    Declare Abstract Function GetGlyphIndices Stdcall ( _
        ByVal codepoints As ULong Ptr, _
        ByVal count As ULong, _
        ByVal glyph_indices As UShort Ptr _
    ) As HRESULT
    
    ' 13. TryGetFontTable
    Declare Abstract Function TryGetFontTable Stdcall ( _
        ByVal table_tag As ULong, _
        ByVal table_data As Any Ptr Ptr, _
        ByVal table_size As ULong Ptr, _
        ByVal context As Any Ptr Ptr, _
        ByVal exists As Long Ptr _
    ) As HRESULT
    
    ' 14. ReleaseFontTable
    Declare Abstract Sub ReleaseFontTable Stdcall ( _
        ByVal table_context As Any Ptr _
    )
    
    ' 15. GetGlyphRunOutline
    Declare Abstract Function GetGlyphRunOutline Stdcall ( _
        ByVal emSize As Single, _
        ByVal glyph_indices As UShort Ptr, _
        ByVal glyph_advances As Single Ptr, _
        ByVal glyph_offsets As DWRITE_GLYPH_OFFSET Ptr, _
        ByVal glyph_count As ULong, _
        ByVal is_sideways As Long, _
        ByVal is_rtl As Long, _
        ByVal geometrysink As Any Ptr _ 
    ) As HRESULT
    
    ' 16. GetRecommendedRenderingMode
    Declare Abstract Function GetRecommendedRenderingMode Stdcall ( _
        ByVal emSize As Single, _
        ByVal pixels_per_dip As Single, _
        ByVal mode As DWRITE_MEASURING_MODE, _
        ByVal params As IDWriteRenderingParams Ptr, _
        ByVal rendering_mode As DWRITE_RENDERING_MODE Ptr _
    ) As HRESULT
    
    ' 17. GetGdiCompatibleMetrics
    Declare Abstract Function GetGdiCompatibleMetrics Stdcall ( _
        ByVal emSize As Single, _
        ByVal pixels_per_dip As Single, _
        ByVal transform As DWRITE_MATRIX Ptr, _
        ByVal metrics As DWRITE_FONT_METRICS Ptr _
    ) As HRESULT
    
    ' 18. GetGdiCompatibleGlyphMetrics
    Declare Abstract Function GetGdiCompatibleGlyphMetrics Stdcall ( _
        ByVal emSize As Single, _
        ByVal pixels_per_dip As Single, _
        ByVal transform As DWRITE_MATRIX Ptr, _
        ByVal use_gdi_natural As Long, _
        ByVal glyph_indices As UShort Ptr, _
        ByVal glyph_count As ULong, _
        ByVal metrics As DWRITE_GLYPH_METRICS Ptr, _
        ByVal is_sideways As Long _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFont
' ============================================================================
Type IDWriteFont Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. GetFontFamily
    Declare Abstract Function GetFontFamily Stdcall ( _
        ByVal family As Any Ptr Ptr _
    ) As HRESULT
    
    ' 5. GetWeight
    Declare Abstract Function GetWeight Stdcall () As DWRITE_FONT_WEIGHT
    
    ' 6. GetStretch
    Declare Abstract Function GetStretch Stdcall () As DWRITE_FONT_STRETCH
    
    ' 7. GetStyle
    Declare Abstract Function GetStyle Stdcall () As DWRITE_FONT_STYLE
    
    ' 8. IsSymbolFont
    Declare Abstract Function IsSymbolFont Stdcall () As Long
    
    ' 9. GetFaceNames
    Declare Abstract Function GetFaceNames Stdcall ( _
        ByVal names As Any Ptr Ptr _
    ) As HRESULT
    
    ' 10. GetInformationalStrings
    Declare Abstract Function GetInformationalStrings Stdcall ( _
        ByVal informationalStringID As DWRITE_INFORMATIONAL_STRING_ID, _
        ByVal informationalStrings As Any Ptr Ptr, _
        ByVal exists As Long Ptr _
    ) As HRESULT
    
    ' 11. GetSimulations
    Declare Abstract Function GetSimulations Stdcall () As DWRITE_FONT_SIMULATIONS
    
    ' 12. GetMetrics
    Declare Abstract Sub GetMetrics Stdcall ( _
        ByVal fontMetrics As DWRITE_FONT_METRICS Ptr _
    )
    
    ' 13. HasCharacter
    Declare Abstract Function HasCharacter Stdcall ( _
        ByVal unicodeValue As ULong, _
        ByVal exists As Long Ptr _
    ) As HRESULT
    
    ' 14. CreateFontFace
    Declare Abstract Function CreateFontFace Stdcall ( _
        ByVal fontFace As Any Ptr Ptr _
    ) As HRESULT
End Type

' ==============================
' IDWriteFontList
' ==============================
Type IDWriteFontList Extends IUnknownBase
    ' --- IUnknown (1-3) ---
    ' 1. QueryInterface
    ' 2. AddRef
    ' 3. Release
    ' 4.
    Declare Abstract Function GetFontCollection Stdcall (ByRef fontCollection As any Ptr) As HRESULT 'IDWriteFontCollection Ptr
    ' 5.
    Declare Abstract Function GetFontCount Stdcall () As ULong
    ' 6.
    Declare Abstract Function GetFont Stdcall (ByVal index As ULong, _
                                               ByRef font As IDWriteFont Ptr) As HRESULT
End Type

' ==============================
' IDWriteFontFamily
' ==============================
Type IDWriteFontFamily Extends IDWriteFontList
    ' 7. 
    Declare Abstract Function GetFamilyNames Stdcall (ByRef names As IDWriteLocalizedStrings Ptr) As HRESULT
    ' 8.
    Declare Abstract Function GetFirstMatchingFont Stdcall (ByVal weight As ULong, _
                                                            ByVal stretch As ULong, _
                                                            ByVal style As ULong, _
                                                            ByRef matchingFont As IDWriteFont Ptr) As HRESULT
    ' 9.
    Declare Abstract Function GetMatchingFonts Stdcall (ByVal weight As DWRITE_FONT_WEIGHT, _
                                                        ByVal stretch As ULong, _
                                                        ByVal style As ULong, _
                                                        ByRef matchingFonts As IDWriteFontList Ptr) As HRESULT
End Type

' ==============================
' IDWriteFontCollection
' ==============================
Type IDWriteFontCollection Extends IUnknownBase
    ' --- IUnknown (1-3) ---
    ' 1. QueryInterface
    ' 2. AddRef
    ' 3. Release
    ' 4.
    Declare Abstract Function GetFontFamilyCount Stdcall () As ULong
    ' 5.
    Declare Abstract Function GetFontFamily Stdcall (ByVal index As ULong, _
                                                     ByRef fontFamily As IDWriteFontFamily Ptr) As HRESULT
    ' 6.
    Declare Abstract Function FindFamilyName Stdcall (ByVal familyName As WString Ptr, _
                                                      ByRef index As ULong, _
                                                      ByRef exists As Long) As HRESULT
    ' 7.
    Declare Abstract Function GetFontFromFontFace Stdcall (ByVal fontFace As IDWriteFontFace Ptr, _
                                                           ByRef font As IDWriteFont Ptr) As HRESULT
End Type

' ============================================================================
' IDWritePixelSnapping
' ============================================================================
Type IDWritePixelSnapping Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. IsPixelSnappingDisabled
    Declare Abstract Function IsPixelSnappingDisabled Stdcall ( _
        ByVal clientDrawingContext As Any Ptr, _
        ByVal isDisabled As Long Ptr _
    ) As HRESULT
    
    ' 5. GetCurrentTransform
    Declare Abstract Function GetCurrentTransform Stdcall ( _
        ByVal clientDrawingContext As Any Ptr, _
        ByVal transform As DWRITE_MATRIX Ptr _
    ) As HRESULT
    
    ' 6. GetPixelsPerDip
    Declare Abstract Function GetPixelsPerDip Stdcall ( _
        ByVal clientDrawingContext As Any Ptr, _
        ByVal pixelsPerDip As Single Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteTextRenderer
' ============================================================================
Type IDWriteTextRenderer Extends IDWritePixelSnapping
    ' 1-6: IDWritePixelSnapping
    
    ' 7. DrawGlyphRun
    Declare Abstract Function DrawGlyphRun Stdcall ( _
        ByVal clientDrawingContext As Any Ptr, _
        ByVal baselineOriginX As Single, _
        ByVal baselineOriginY As Single, _
        ByVal measuringMode As DWRITE_MEASURING_MODE, _
        ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, _
        ByVal glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr, _
        ByVal clientDrawingEffect As IUnknown Ptr _
    ) As HRESULT
    
    ' 8. DrawUnderline
    Declare Abstract Function DrawUnderline Stdcall ( _
        ByVal clientDrawingContext As Any Ptr, _
        ByVal baselineOriginX As Single, _
        ByVal baselineOriginY As Single, _
        ByVal underline As DWRITE_UNDERLINE Ptr, _
        ByVal clientDrawingEffect As IUnknown Ptr _
    ) As HRESULT
    
    ' 9. DrawStrikethrough
    Declare Abstract Function DrawStrikethrough Stdcall ( _
        ByVal clientDrawingContext As Any Ptr, _
        ByVal baselineOriginX As Single, _
        ByVal baselineOriginY As Single, _
        ByVal strikethrough As DWRITE_STRIKETHROUGH Ptr, _
        ByVal clientDrawingEffect As IUnknown Ptr _
    ) As HRESULT
    
    ' 10. DrawInlineObject
    Declare Abstract Function DrawInlineObject Stdcall ( _
        ByVal clientDrawingContext As Any Ptr, _
        ByVal originX As Single, _
        ByVal originY As Single, _
        ByVal inlineObject As Any Ptr, _
        ByVal isSideways As Long, _
        ByVal isRightToLeft As Long, _
        ByVal clientDrawingEffect As IUnknown Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteInlineObject
' ============================================================================
Type IDWriteInlineObject Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. Draw
    Declare Abstract Function Draw Stdcall ( _
        ByVal clientDrawingContext As Any Ptr, _
        ByVal renderer As Any Ptr, _
        ByVal originX As Single, _
        ByVal originY As Single, _
        ByVal isSideways As Long, _
        ByVal isRightToLeft As Long, _
        ByVal clientDrawingEffect As IUnknown Ptr _
    ) As HRESULT
    
    ' 5. GetMetrics
    Declare Abstract Function GetMetrics Stdcall ( _
        ByVal metrics As DWRITE_INLINE_OBJECT_METRICS Ptr _
    ) As HRESULT
    
    ' 6. GetOverhangMetrics
    Declare Abstract Function GetOverhangMetrics Stdcall ( _
        ByVal overhangs As DWRITE_OVERHANG_METRICS Ptr _
    ) As HRESULT
    
    ' 7. GetBreakConditions
    Declare Abstract Function GetBreakConditions Stdcall ( _
        ByVal breakConditionBefore As DWRITE_BREAK_CONDITION Ptr, _
        ByVal breakConditionAfter As DWRITE_BREAK_CONDITION Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteTextFormat
' ============================================================================
Type IDWriteTextFormat Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. SetTextAlignment
    Declare Abstract Function SetTextAlignment Stdcall ( _
        ByVal textAlignment As DWRITE_TEXT_ALIGNMENT _
    ) As HRESULT
    
    ' 5. SetParagraphAlignment
    Declare Abstract Function SetParagraphAlignment Stdcall ( _
        ByVal paragraphAlignment As DWRITE_PARAGRAPH_ALIGNMENT _
    ) As HRESULT
    
    ' 6. SetWordWrapping
    Declare Abstract Function SetWordWrapping Stdcall ( _
        ByVal wordWrapping As DWRITE_WORD_WRAPPING _
    ) As HRESULT
    
    ' 7. SetReadingDirection
    Declare Abstract Function SetReadingDirection Stdcall ( _
        ByVal readingDirection As DWRITE_READING_DIRECTION _
    ) As HRESULT
    
    ' 8. SetFlowDirection
    Declare Abstract Function SetFlowDirection Stdcall ( _
        ByVal flowDirection As DWRITE_FLOW_DIRECTION _
    ) As HRESULT
    
    ' 9. SetIncrementalTabStop
    Declare Abstract Function SetIncrementalTabStop Stdcall ( _
        ByVal incrementalTabStop As Single _
    ) As HRESULT
    
    ' 10. SetTrimming
    Declare Abstract Function SetTrimming Stdcall ( _
        ByVal trimmingOptions As DWRITE_TRIMMING Ptr, _
        ByVal trimmingSign As Any Ptr _
    ) As HRESULT
    
    ' 11. SetLineSpacing
    Declare Abstract Function SetLineSpacing Stdcall ( _
        ByVal lineSpacingMethod As DWRITE_LINE_SPACING_METHOD, _
        ByVal lineSpacing As Single, _
        ByVal baseline As Single _
    ) As HRESULT
    
    ' 12. GetTextAlignment
    Declare Abstract Function GetTextAlignment Stdcall () As DWRITE_TEXT_ALIGNMENT
    
    ' 13. GetParagraphAlignment
    Declare Abstract Function GetParagraphAlignment Stdcall () As DWRITE_PARAGRAPH_ALIGNMENT
    
    ' 14. GetWordWrapping
    Declare Abstract Function GetWordWrapping Stdcall () As DWRITE_WORD_WRAPPING
    
    ' 15. GetReadingDirection
    Declare Abstract Function GetReadingDirection Stdcall () As DWRITE_READING_DIRECTION
    
    ' 16. GetFlowDirection
    Declare Abstract Function GetFlowDirection Stdcall () As DWRITE_FLOW_DIRECTION
    
    ' 17. GetIncrementalTabStop
    Declare Abstract Function GetIncrementalTabStop Stdcall () As Single
    
    ' 18. GetTrimming
    Declare Abstract Function GetTrimming Stdcall ( _
        ByVal trimmingOptions As DWRITE_TRIMMING Ptr, _
        ByVal trimmingSign As Any Ptr Ptr _
    ) As HRESULT
    
    ' 19. GetLineSpacing
    Declare Abstract Function GetLineSpacing Stdcall ( _
        ByVal lineSpacingMethod As DWRITE_LINE_SPACING_METHOD Ptr, _
        ByVal lineSpacing As Single Ptr, _
        ByVal baseline As Single Ptr _
    ) As HRESULT
    
    ' 20. GetFontCollection
    Declare Abstract Function GetFontCollection Stdcall ( _
        ByVal fontCollection As Any Ptr Ptr _
    ) As HRESULT
    
    ' 21. GetFontFamilyNameLength
    Declare Abstract Function GetFontFamilyNameLength Stdcall () As ULong
    
    ' 22. GetFontFamilyName
    Declare Abstract Function GetFontFamilyName Stdcall ( _
        ByVal fontFamilyName As WString Ptr, _
        ByVal nameSize As ULong _
    ) As HRESULT
    
    ' 23. GetFontWeight
    Declare Abstract Function GetFontWeight Stdcall () As DWRITE_FONT_WEIGHT
    
    ' 24. GetFontStyle
    Declare Abstract Function GetFontStyle Stdcall () As DWRITE_FONT_STYLE
    
    ' 25. GetFontStretch
    Declare Abstract Function GetFontStretch Stdcall () As DWRITE_FONT_STRETCH
    
    ' 26. GetFontSize
    Declare Abstract Function GetFontSize Stdcall () As Single
    
    ' 27. GetLocaleNameLength
    Declare Abstract Function GetLocaleNameLength Stdcall () As ULong
    
    ' 28. GetLocaleName
    Declare Abstract Function GetLocaleName Stdcall ( _
        ByVal localeName As WString Ptr, _
        ByVal nameSize As ULong _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteTextLayout
' ============================================================================
Type IDWriteTextLayout Extends IDWriteTextFormat
    ' 1-28: IDWriteTextFormat
    
    ' 29. SetMaxWidth
    Declare Abstract Function SetMaxWidth Stdcall ( _
        ByVal maxWidth As Single _
    ) As HRESULT
    
    ' 30. SetMaxHeight
    Declare Abstract Function SetMaxHeight Stdcall ( _
        ByVal maxHeight As Single _
    ) As HRESULT
    
    ' 31. SetFontCollection
    Declare Abstract Function SetFontCollection Stdcall ( _
        ByVal fontCollection As Any Ptr, _
        ByVal textRange As DWRITE_TEXT_RANGE _
    ) As HRESULT
    
    ' 32. SetFontFamilyName
    Declare Abstract Function SetFontFamilyName Stdcall ( _
        ByVal fontFamilyName As WString Ptr, _
        ByVal textRange As DWRITE_TEXT_RANGE _
    ) As HRESULT
    
    ' 33. SetFontWeight
    Declare Abstract Function SetFontWeight Stdcall ( _
        ByVal fontWeight As DWRITE_FONT_WEIGHT, _
        ByVal textRange As DWRITE_TEXT_RANGE _
    ) As HRESULT
    
    ' 34. SetFontStyle
    Declare Abstract Function SetFontStyle Stdcall ( _
        ByVal fontStyle As DWRITE_FONT_STYLE, _
        ByVal textRange As DWRITE_TEXT_RANGE _
    ) As HRESULT
    
    ' 35. SetFontStretch
    Declare Abstract Function SetFontStretch Stdcall ( _
        ByVal fontStretch As DWRITE_FONT_STRETCH, _
        ByVal textRange As DWRITE_TEXT_RANGE _
    ) As HRESULT
    
    ' 36. SetFontSize
    Declare Abstract Function SetFontSize Stdcall ( _
        ByVal fontSize As Single, _
        ByVal textRange As DWRITE_TEXT_RANGE _
    ) As HRESULT
    
    ' 37. SetUnderline
    Declare Abstract Function SetUnderline Stdcall ( _
        ByVal hasUnderline As Long, _
        ByVal textRange As DWRITE_TEXT_RANGE _
    ) As HRESULT
    
    ' 38. SetStrikethrough
    Declare Abstract Function SetStrikethrough Stdcall ( _
        ByVal hasStrikethrough As Long, _
        ByVal textRange As DWRITE_TEXT_RANGE _
    ) As HRESULT
    
    ' 39. SetDrawingEffect
    Declare Abstract Function SetDrawingEffect Stdcall ( _
        ByVal drawingEffect As IUnknown Ptr, _
        ByVal textRange As DWRITE_TEXT_RANGE _
    ) As HRESULT
    
    ' 40. SetInlineObject
    Declare Abstract Function SetInlineObject Stdcall ( _
        ByVal inlineObject As Any Ptr, _
        ByVal textRange As DWRITE_TEXT_RANGE _
    ) As HRESULT
    
    ' 41. SetTypography
    Declare Abstract Function SetTypography Stdcall ( _
        ByVal typography As Any Ptr, _
        ByVal textRange As DWRITE_TEXT_RANGE _
    ) As HRESULT
    
    ' 42. SetLocaleName
    Declare Abstract Function SetLocaleName Stdcall ( _
        ByVal localeName As WString Ptr, _
        ByVal textRange As DWRITE_TEXT_RANGE _
    ) As HRESULT
    
    ' 43. GetMaxWidth
    Declare Abstract Function GetMaxWidth Stdcall () As Single
    
    ' 44. GetMaxHeight
    Declare Abstract Function GetMaxHeight Stdcall () As Single
    
    ' 45. GetFontCollection
    Declare Abstract Function GetFontCollection Stdcall ( _
        ByVal currentPosition As ULong, _
        ByVal fontCollection As Any Ptr Ptr, _
        ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 _
    ) As HRESULT
    
    ' 46. GetFontFamilyNameLength
    Declare Abstract Function GetFontFamilyNameLength Stdcall ( _
        ByVal currentPosition As ULong, _
        ByVal nameLength As ULong Ptr, _
        ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 _
    ) As HRESULT
    
    ' 47. GetFontFamilyName
    Declare Abstract Function GetFontFamilyName Stdcall ( _
        ByVal currentPosition As ULong, _
        ByVal fontFamilyName As WString Ptr, _
        ByVal nameSize As ULong, _
        ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 _
    ) As HRESULT
    
    ' 48. GetFontWeight
    Declare Abstract Function GetFontWeight Stdcall ( _
        ByVal currentPosition As ULong, _
        ByVal fontWeight As DWRITE_FONT_WEIGHT Ptr, _
        ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 _
    ) As HRESULT
    
    ' 49. GetFontStyle
    Declare Abstract Function GetFontStyle Stdcall ( _
        ByVal currentPosition As ULong, _
        ByVal fontStyle As DWRITE_FONT_STYLE Ptr, _
        ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 _
    ) As HRESULT
    
    ' 50. GetFontStretch
    Declare Abstract Function GetFontStretch Stdcall ( _
        ByVal currentPosition As ULong, _
        ByVal fontStretch As DWRITE_FONT_STRETCH Ptr, _
        ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 _
    ) As HRESULT
    
    ' 51. GetFontSize
    Declare Abstract Function GetFontSize Stdcall ( _
        ByVal currentPosition As ULong, _
        ByVal fontSize As Single Ptr, _
        ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 _
    ) As HRESULT
    
    ' 52. GetUnderline
    Declare Abstract Function GetUnderline Stdcall ( _
        ByVal currentPosition As ULong, _
        ByVal hasUnderline As Long Ptr, _
        ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 _
    ) As HRESULT
    
    ' 53. GetStrikethrough
    Declare Abstract Function GetStrikethrough Stdcall ( _
        ByVal currentPosition As ULong, _
        ByVal hasStrikethrough As Long Ptr, _
        ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 _
    ) As HRESULT
    
    ' 54. GetDrawingEffect
    Declare Abstract Function GetDrawingEffect Stdcall ( _
        ByVal currentPosition As ULong, _
        ByVal drawingEffect As IUnknown Ptr Ptr, _
        ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 _
    ) As HRESULT
    
    ' 55. GetInlineObject
    Declare Abstract Function GetInlineObject Stdcall ( _
        ByVal currentPosition As ULong, _
        ByVal inlineObject As Any Ptr Ptr, _
        ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 _
    ) As HRESULT
    
    ' 56. GetTypography
    Declare Abstract Function GetTypography Stdcall ( _
        ByVal currentPosition As ULong, _
        ByVal typography As Any Ptr Ptr, _
        ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 _
    ) As HRESULT
    
    ' 57. GetLocaleNameLength
    Declare Abstract Function GetLocaleNameLength Stdcall ( _
        ByVal currentPosition As ULong, _
        ByVal nameLength As ULong Ptr, _
        ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 _
    ) As HRESULT
    
    ' 58. GetLocaleName
    Declare Abstract Function GetLocaleName Stdcall ( _
        ByVal currentPosition As ULong, _
        ByVal localeName As WString Ptr, _
        ByVal nameSize As ULong, _
        ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 _
    ) As HRESULT
    
    ' 59. Draw
    Declare Abstract Function Draw Stdcall ( _
        ByVal clientDrawingContext As Any Ptr, _
        ByVal renderer As Any Ptr, _
        ByVal originX As Single, _
        ByVal originY As Single _
    ) As HRESULT
    
    ' 60. GetLineMetrics
    Declare Abstract Function GetLineMetrics Stdcall ( _
        ByVal lineMetrics As DWRITE_LINE_METRICS Ptr, _
        ByVal maxLineCount As ULong, _
        ByVal actualLineCount As ULong Ptr _
    ) As HRESULT
    
    ' 61. GetMetrics
    Declare Abstract Function GetMetrics Stdcall ( _
        ByVal textMetrics As DWRITE_TEXT_METRICS Ptr _
    ) As HRESULT
    
    ' 62. GetOverhangMetrics
    Declare Abstract Function GetOverhangMetrics Stdcall ( _
        ByVal overhangs As DWRITE_OVERHANG_METRICS Ptr _
    ) As HRESULT
    
    ' 63. GetClusterMetrics
    Declare Abstract Function GetClusterMetrics Stdcall ( _
        ByVal clusterMetrics As DWRITE_CLUSTER_METRICS Ptr, _
        ByVal maxClusterCount As ULong, _
        ByVal actualClusterCount As ULong Ptr _
    ) As HRESULT
    
    ' 64. DetermineMinWidth
    Declare Abstract Function DetermineMinWidth Stdcall ( _
        ByVal minWidth As Single Ptr _
    ) As HRESULT
    
    ' 65. HitTestPoint
    Declare Abstract Function HitTestPoint Stdcall ( _
        ByVal pointX As Single, _
        ByVal pointY As Single, _
        ByVal isTrailingHit As Long Ptr, _
        ByVal isInside As Long Ptr, _
        ByVal hitTestMetrics As DWRITE_HIT_TEST_METRICS Ptr _
    ) As HRESULT
    
    ' 66. HitTestTextPosition
    Declare Abstract Function HitTestTextPosition Stdcall ( _
        ByVal textPosition As ULong, _
        ByVal isTrailingHit As Long, _
        ByVal pointX As Single Ptr, _
        ByVal pointY As Single Ptr, _
        ByVal hitTestMetrics As DWRITE_HIT_TEST_METRICS Ptr _
    ) As HRESULT
    
    ' 67. HitTestTextRange
    Declare Abstract Function HitTestTextRange Stdcall ( _
        ByVal textPosition As ULong, _
        ByVal textLength As ULong, _
        ByVal originX As Single, _
        ByVal originY As Single, _
        ByVal hitTestMetrics As DWRITE_HIT_TEST_METRICS Ptr, _
        ByVal maxHitTestMetricsCount As ULong, _
        ByVal actualHitTestMetricsCount As ULong Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteTypography
' ============================================================================
Type IDWriteTypography Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. AddFontFeature
    Declare Abstract Function AddFontFeature Stdcall ( _
        ByVal fontFeature As DWRITE_FONT_FEATURE _
    ) As HRESULT
    
    ' 5. GetFontFeatureCount
    Declare Abstract Function GetFontFeatureCount Stdcall () As ULong
    
    ' 6. GetFontFeature
    Declare Abstract Function GetFontFeature Stdcall ( _
        ByVal fontFeatureIndex As ULong, _
        ByVal fontFeature As DWRITE_FONT_FEATURE Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteNumberSubstitution
' ============================================================================
Type IDWriteNumberSubstitution Extends IUnknownBase
    ' 1-3: IUnknown
    ' (No additional methods - marker interface)
End Type

' ==============================
' IDWriteTextAnalysisSource
' ==============================
Type IDWriteTextAnalysisSource Extends IUnknownBase
    ' --- IUnknown (1-3) ---
    ' 1. QueryInterface
    ' 2. AddRef
    ' 3. Release
    ' 4.
    Declare Abstract Function GetTextAtPosition Stdcall (ByVal textPosition As ULong, _
                                                         ByRef textString As WString Ptr, _
                                                         ByRef textLength As ULong) As HRESULT
    ' 5.
    Declare Abstract Function GetTextBeforePosition Stdcall (ByVal textPosition As ULong, _
                                                             ByRef textString As WString Ptr, _
                                                             ByRef textLength As ULong) As HRESULT
    ' 6.
    Declare Abstract Function GetParagraphReadingDirection Stdcall () As DWRITE_READING_DIRECTION
    ' 7.
    Declare Abstract Function GetLocaleName Stdcall (ByVal textPosition As ULong, _
                                                     ByRef textLength As ULong, _
                                                     ByRef localeName As WString Ptr) As HRESULT
    ' 8.
    ' Liefert die NumberSubstitution-Regeln für einen Textbereich.
    Declare Abstract Function GetNumberSubstitution Stdcall (ByVal textPosition As ULong, _
                                                             ByRef textLength As ULong, _
                                                             ByRef numberSubstitution As IDWriteNumberSubstitution Ptr) As HRESULT
End Type

' ==============================
' IDWriteTextAnalysisSink
' ==============================
Type IDWriteTextAnalysisSink Extends IUnknownBase
    ' --- IUnknown (1-3) ---
    ' 1. QueryInterface
    ' 2. AddRef
    ' 3. Release
    ' 4.
    Declare Abstract Function SetScriptAnalysis Stdcall (ByVal textPosition As ULong, _
                                                         ByVal textLength As ULong, _
                                                         ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS Ptr) As HRESULT
    ' 5.
    Declare Abstract Function SetLineBreakpoints Stdcall (ByVal textPosition As ULong, _
                                                          ByVal textLength As ULong, _
                                                          ByVal lineBreakpoints As DWRITE_LINE_BREAKPOINT Ptr) As HRESULT
    ' 6.
    Declare Abstract Function SetBidiLevel Stdcall (ByVal textPosition As ULong, _
                                                    ByVal textLength As ULong, _
                                                    ByVal explicitLevel As UByte, _
                                                    ByVal resolvedLevel As UByte) As HRESULT
    ' 7.
    Declare Abstract Function SetNumberSubstitution Stdcall (ByVal textPosition As ULong, _
                                                             ByVal textLength As ULong, _
                                                             ByVal numberSubstitution As IDWriteNumberSubstitution Ptr) As HRESULT
    ' 8. (Optional in manchen Implementierungen)
    Declare Abstract Function SetGlyphOrientation Stdcall (ByVal textPosition As ULong, _
                                                          ByVal textLength As ULong, _
                                                          ByVal glyphOrientation As DWRITE_VERTICAL_GLYPH_ORIENTATION, _
                                                          ByVal bidiLevel As UByte, _
                                                          ByVal isSideways As Long, _
                                                          ByVal isRightToLeft As Long) As HRESULT
End Type

' ==============================
' IDWriteTextAnalyzer
' ==============================
Type IDWriteTextAnalyzer Extends IUnknownBase
    ' --- IUnknown (1-3) ---
    ' 1. QueryInterface
    ' 2. AddRef
    ' 3. Release
    ' 4.
    Declare Abstract Function AnalyzeScript Stdcall (ByVal analysisSource As IDWriteTextAnalysisSource Ptr, _
                                                     ByVal textPosition As ULong, _
                                                     ByVal textLength As ULong, _
                                                     ByVal analysisSink As IDWriteTextAnalysisSink Ptr) As HRESULT
    ' 5.
    Declare Abstract Function AnalyzeBidi Stdcall (ByVal analysisSource As IDWriteTextAnalysisSource Ptr, _
                                                   ByVal textPosition As ULong, _
                                                   ByVal textLength As ULong, _
                                                   ByVal analysisSink As IDWriteTextAnalysisSink Ptr) As HRESULT
    ' 6.
    Declare Abstract Function AnalyzeNumberSubstitution Stdcall (ByVal analysisSource As IDWriteTextAnalysisSource Ptr, _
                                                                 ByVal textPosition As ULong, _
                                                                 ByVal textLength As ULong, _
                                                                 ByVal analysisSink As IDWriteTextAnalysisSink Ptr) As HRESULT
    ' 7.
    Declare Abstract Function AnalyzeLineBreakpoints Stdcall (ByVal analysisSource As IDWriteTextAnalysisSource Ptr, _
                                                              ByVal textPosition As ULong, _
                                                              ByVal textLength As ULong, _
                                                              ByVal analysisSink As IDWriteTextAnalysisSink Ptr) As HRESULT
    ' 8.
    ' Weist den Glyphen die korrekten OpenType-Features zu (Shaping).
    Declare Abstract Function GetGlyphs Stdcall (ByVal textString As WString Ptr, _
                                                 ByVal textLength As ULong, _
                                                 ByVal fontFace As IDWriteFontFace Ptr, _
                                                 ByVal isSideways As Long, _
                                                 ByVal isRightToLeft As Long, _
                                                 ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS Ptr, _
                                                 ByVal localeName As WString Ptr, _
                                                 ByVal numberSubstitution As IDWriteNumberSubstitution Ptr, _
                                                 ByVal features As DWRITE_TYPOGRAPHIC_FEATURES Ptr Ptr, _
                                                 ByVal featureRangeLengths As ULong Ptr, _
                                                 ByVal featureRanges As ULong, _
                                                 ByVal maxGlyphCount As ULong, _
                                                 ByRef clusters As UShort Ptr, _
                                                 ByRef textProps As DWRITE_SHAPING_TEXT_PROPERTIES Ptr, _
                                                 ByRef glyphIndices As UShort Ptr, _
                                                 ByRef glyphProps As DWRITE_SHAPING_GLYPH_PROPERTIES Ptr, _
                                                 ByRef actualGlyphCount As ULong) As HRESULT
    ' 9.
    ' Ermittelt die Platzierung der Glyphen (Advances und Offsets).
    Declare Abstract Function GetGlyphPlacements Stdcall (ByVal textString As WString Ptr, _
                                                          ByVal clusters As UShort Ptr, _
                                                          ByRef textProps As DWRITE_SHAPING_TEXT_PROPERTIES Ptr, _
                                                          ByVal textLength As ULong, _
                                                          ByVal glyphIndices As UShort Ptr, _
                                                          ByRef glyphProps As DWRITE_SHAPING_GLYPH_PROPERTIES Ptr, _
                                                          ByVal glyphCount As ULong, _
                                                          ByVal fontFace As IDWriteFontFace Ptr, _
                                                          ByVal fontEmSize As Single, _
                                                          ByVal isSideways As Long, _
                                                          ByVal isRightToLeft As Long, _
                                                          ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS Ptr, _
                                                          ByVal localeName As WString Ptr, _
                                                          ByVal features As DWRITE_TYPOGRAPHIC_FEATURES Ptr Ptr, _
                                                          ByVal featureRangeLengths As ULong Ptr, _
                                                          ByVal featureRanges As ULong, _
                                                          ByRef glyphAdvances As Single Ptr, _
                                                          ByRef glyphOffsets As DWRITE_GLYPH_OFFSET Ptr) As HRESULT
    ' 10.
    ' Platziert Glyphen so, dass sie exakt mit dem GDI-Raster übereinstimmen.
    Declare Abstract Function GetGdiCompatibleGlyphPlacements Stdcall (ByVal textString As WString Ptr, _
                                                                       ByVal clusters As UShort Ptr, _
                                                                       ByRef textProps As DWRITE_SHAPING_TEXT_PROPERTIES Ptr, _
                                                                       ByVal textLength As ULong, _
                                                                       ByVal glyphIndices As UShort Ptr, _
                                                                       ByRef glyphProps As DWRITE_SHAPING_GLYPH_PROPERTIES Ptr, _
                                                                       ByVal glyphCount As ULong, _
                                                                       ByVal fontFace As IDWriteFontFace Ptr, _
                                                                       ByVal fontEmSize As Single, _
                                                                       ByVal pixelsPerDip As Single, _
                                                                       ByVal transform As DWRITE_MATRIX Ptr, _
                                                                       ByVal useGdiNatural As Long, _ ' BOOL
                                                                       ByVal isSideways As Long, _
                                                                       ByVal isRightToLeft As Long, _
                                                                       ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS Ptr, _
                                                                       ByVal localeName As WString Ptr, _
                                                                       ByVal features As DWRITE_TYPOGRAPHIC_FEATURES Ptr Ptr, _
                                                                       ByVal featureRangeLengths As ULong Ptr, _
                                                                       ByVal featureRanges As ULong, _
                                                                       ByRef glyphAdvances As Single Ptr, _
                                                                       ByRef glyphOffsets As DWRITE_GLYPH_OFFSET Ptr) As HRESULT
 End Type

' ============================================================================
' IDWriteGdiInterop
' ============================================================================
Type IDWriteGdiInterop Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. CreateFontFromLOGFONT
    Declare Abstract Function CreateFontFromLOGFONT Stdcall ( _
        ByVal logFont As LOGFONTW Ptr, _
        ByVal font As Any Ptr Ptr _
    ) As HRESULT
    
    ' 5. ConvertFontToLOGFONT
    Declare Abstract Function ConvertFontToLOGFONT Stdcall ( _
        ByVal font As Any Ptr, _
        ByVal logFont As LOGFONTW Ptr, _
        ByVal isSystemFont As Long Ptr _
    ) As HRESULT
    
    ' 6. ConvertFontFaceToLOGFONT
    Declare Abstract Function ConvertFontFaceToLOGFONT Stdcall ( _
        ByVal font As Any Ptr, _
        ByVal logFont As LOGFONTW Ptr _
    ) As HRESULT
    
    ' 7. CreateFontFaceFromHdc
    Declare Abstract Function CreateFontFaceFromHdc Stdcall ( _
        ByVal hdc As HDC, _
        ByVal fontFace As Any Ptr Ptr _
    ) As HRESULT
    
    ' 8. CreateBitmapRenderTarget
    Declare Abstract Function CreateBitmapRenderTarget Stdcall ( _
        ByVal hdc As HDC, _
        ByVal width As ULong, _
        ByVal height As ULong, _
        ByVal renderTarget As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteBitmapRenderTarget
' ============================================================================
Type IDWriteBitmapRenderTarget Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. DrawGlyphRun
    Declare Abstract Function DrawGlyphRun Stdcall ( _
        ByVal baselineOriginX As Single, _
        ByVal baselineOriginY As Single, _
        ByVal measuringMode As DWRITE_MEASURING_MODE, _
        ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, _
        ByVal renderingParams As Any Ptr, _
        ByVal textColor As COLORREF, _
        ByVal blackBoxRect As RECT Ptr = 0 _
    ) As HRESULT
    
    ' 5. GetMemoryDC
    Declare Abstract Function GetMemoryDC Stdcall () As HDC
    
    ' 6. GetPixelsPerDip
    Declare Abstract Function GetPixelsPerDip Stdcall () As Single
    
    ' 7. SetPixelsPerDip
    Declare Abstract Function SetPixelsPerDip Stdcall ( _
        ByVal pixelsPerDip As Single _
    ) As HRESULT
    
    ' 8. GetCurrentTransform
    Declare Abstract Function GetCurrentTransform Stdcall ( _
        ByVal transform As DWRITE_MATRIX Ptr _
    ) As HRESULT
    
    ' 9. SetCurrentTransform
    Declare Abstract Function SetCurrentTransform Stdcall ( _
        ByVal transform As DWRITE_MATRIX Ptr _
    ) As HRESULT
    
    ' 10. GetSize
    Declare Abstract Function GetSize Stdcall ( _
        ByVal size As SIZE Ptr _
    ) As HRESULT
    
    ' 11. Resize
    Declare Abstract Function Resize Stdcall ( _
        ByVal width As ULong, _
        ByVal height As ULong _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteGlyphRunAnalysis
' ============================================================================
Type IDWriteGlyphRunAnalysis Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. GetAlphaTextureBounds
    Declare Abstract Function GetAlphaTextureBounds Stdcall ( _
        ByVal textureType As DWRITE_TEXTURE_TYPE, _
        ByVal textureBounds As RECT Ptr _
    ) As HRESULT
    
    ' 5. CreateAlphaTexture
    Declare Abstract Function CreateAlphaTexture Stdcall ( _
        ByVal textureType As DWRITE_TEXTURE_TYPE, _
        ByVal textureBounds As RECT Ptr, _
        ByVal alphaValues As Byte Ptr, _
        ByVal bufferSize As ULong _
    ) As HRESULT
    
    ' 6. GetAlphaBlendParams
    Declare Abstract Function GetAlphaBlendParams Stdcall ( _
        ByVal renderingParams As Any Ptr, _
        ByVal blendGamma As Single Ptr, _
        ByVal blendEnhancedContrast As Single Ptr, _
        ByVal blendClearTypeLevel As Single Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFactory
' ============================================================================
Type IDWriteFactory Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. GetSystemFontCollection
    Declare Abstract Function GetSystemFontCollection Stdcall ( _
        ByVal fontCollection As Any Ptr Ptr, _
        ByVal checkForUpdates As Long = 0 _
    ) As HRESULT
    
    ' 5. CreateCustomFontCollection
    Declare Abstract Function CreateCustomFontCollection Stdcall ( _
        ByVal collectionLoader As Any Ptr, _
        ByVal collectionKey As Any Ptr, _
        ByVal collectionKeySize As ULong, _
        ByVal fontCollection As Any Ptr Ptr _
    ) As HRESULT
    
    ' 6. RegisterFontCollectionLoader
    Declare Abstract Function RegisterFontCollectionLoader Stdcall ( _
        ByVal fontCollectionLoader As Any Ptr _
    ) As HRESULT
    
    ' 7. UnregisterFontCollectionLoader
    Declare Abstract Function UnregisterFontCollectionLoader Stdcall ( _
        ByVal fontCollectionLoader As Any Ptr _
    ) As HRESULT
    
    ' 8. CreateFontFileReference
    Declare Abstract Function CreateFontFileReference Stdcall ( _
        ByVal filePath As WString Ptr, _
        ByVal lastWriteTime As FILETIME Ptr, _
        ByVal fontFile As Any Ptr Ptr _
    ) As HRESULT
    
    ' 9. CreateCustomFontFileReference
    Declare Abstract Function CreateCustomFontFileReference Stdcall ( _
        ByVal fontFileReferenceKey As Any Ptr, _
        ByVal fontFileReferenceKeySize As ULong, _
        ByVal fontFileLoader As Any Ptr, _
        ByVal fontFile As Any Ptr Ptr _
    ) As HRESULT
    
    ' 10. CreateFontFace
    Declare Abstract Function CreateFontFace Stdcall ( _
        ByVal fontFaceType As DWRITE_FONT_FACE_TYPE, _
        ByVal numberOfFiles As ULong, _
        ByVal fontFiles As Any Ptr Ptr, _
        ByVal faceIndex As ULong, _
        ByVal fontFaceSimulationFlags As DWRITE_FONT_SIMULATIONS, _
        ByVal fontFace As Any Ptr Ptr _
    ) As HRESULT
    
    ' 11. CreateRenderingParams
    Declare Abstract Function CreateRenderingParams Stdcall ( _
        ByVal renderingParams As Any Ptr Ptr _
    ) As HRESULT
    
    ' 12. CreateMonitorRenderingParams
    Declare Abstract Function CreateMonitorRenderingParams Stdcall ( _
        ByVal monitor As HMONITOR, _
        ByVal renderingParams As Any Ptr Ptr _
    ) As HRESULT
    
    ' 13. CreateCustomRenderingParams
    Declare Abstract Function CreateCustomRenderingParams Stdcall ( _
        ByVal gamma As Single, _
        ByVal enhancedContrast As Single, _
        ByVal clearTypeLevel As Single, _
        ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, _
        ByVal renderingMode As DWRITE_RENDERING_MODE, _
        ByVal renderingParams As Any Ptr Ptr _
    ) As HRESULT
    
    ' 14. RegisterFontFileLoader
    Declare Abstract Function RegisterFontFileLoader Stdcall ( _
        ByVal fontFileLoader As Any Ptr _
    ) As HRESULT
    
    ' 15. UnregisterFontFileLoader
    Declare Abstract Function UnregisterFontFileLoader Stdcall ( _
        ByVal fontFileLoader As Any Ptr _
    ) As HRESULT
    
    ' 16. CreateTextFormat
    Declare Abstract Function CreateTextFormat Stdcall ( _
        ByVal fontFamilyName As WString Ptr, _
        ByVal fontCollection As Any Ptr, _
        ByVal fontWeight As DWRITE_FONT_WEIGHT, _
        ByVal fontStyle As DWRITE_FONT_STYLE, _
        ByVal fontStretch As DWRITE_FONT_STRETCH, _
        ByVal fontSize As Single, _
        ByVal localeName As WString Ptr, _
        ByVal textFormat As IDWriteTextFormat Ptr Ptr _
    ) As HRESULT
    
    ' 17. CreateTypography
    Declare Abstract Function CreateTypography Stdcall ( _
        ByVal typography As Any Ptr Ptr _
    ) As HRESULT
    
    ' 18. GetGdiInterop
    Declare Abstract Function GetGdiInterop Stdcall ( _
        ByVal gdiInterop As Any Ptr Ptr _
    ) As HRESULT
    
    ' 19. CreateTextLayout
    Declare Abstract Function CreateTextLayout Stdcall ( _
        ByVal string As WString Ptr, _
        ByVal stringLength As ULong, _
        ByVal textFormat As Any Ptr, _
        ByVal maxWidth As Single, _
        ByVal maxHeight As Single, _
        ByVal textLayout As Any Ptr Ptr _
    ) As HRESULT
    
    ' 20. CreateGdiCompatibleTextLayout
    Declare Abstract Function CreateGdiCompatibleTextLayout Stdcall ( _
        ByVal string As WString Ptr, _
        ByVal stringLength As ULong, _
        ByVal textFormat As Any Ptr, _
        ByVal layoutWidth As Single, _
        ByVal layoutHeight As Single, _
        ByVal pixelsPerDip As Single, _
        ByVal transform As DWRITE_MATRIX Ptr, _
        ByVal useGdiNatural As Long, _
        ByVal textLayout As Any Ptr Ptr _
    ) As HRESULT
    
    ' 21. CreateEllipsisTrimmingSign
    Declare Abstract Function CreateEllipsisTrimmingSign Stdcall ( _
        ByVal textFormat As Any Ptr, _
        ByVal trimmingSign As Any Ptr Ptr _
    ) As HRESULT
    
    ' 22. CreateTextAnalyzer
    Declare Abstract Function CreateTextAnalyzer Stdcall ( _
        ByVal textAnalyzer As Any Ptr Ptr _
    ) As HRESULT
    
    ' 23. CreateNumberSubstitution
    Declare Abstract Function CreateNumberSubstitution Stdcall ( _
        ByVal substitutionMethod As DWRITE_NUMBER_SUBSTITUTION_METHOD, _
        ByVal localeName As WString Ptr, _
        ByVal ignoreUserOverride As Long, _
        ByVal numberSubstitution As Any Ptr Ptr _
    ) As HRESULT
    
    ' 24. CreateGlyphRunAnalysis
    Declare Abstract Function CreateGlyphRunAnalysis Stdcall ( _
        ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, _
        ByVal pixelsPerDip As Single, _
        ByVal transform As DWRITE_MATRIX Ptr, _
        ByVal renderingMode As DWRITE_RENDERING_MODE, _
        ByVal measuringMode As DWRITE_MEASURING_MODE, _
        ByVal baselineOriginX As Single, _
        ByVal baselineOriginY As Single, _
        ByVal glyphRunAnalysis As Any Ptr Ptr _
    ) As HRESULT
    
End Type