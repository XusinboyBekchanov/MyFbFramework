'###############################################################################
' This file is part of MyFBFramework
' Authors: UEZ, Xusinboy Bekchanov, Liu XiaLin
' Based on UEZ's abstract version.
' Direct2D 1.2 API - FreeBASIC Translation
' Adapted by Xusinboy Bekchanov, Liu XiaLin
'###############################################################################

#pragma once
#inclib "dwrite"
'#include once "unknwn.bi"
#include once "d2d1.bi"
#include once "dcommon.bi"
' ==============================
' DLL imports
' ==============================
Extern "Windows"
Declare Function DWriteCreateFactory stdcall Lib "dwrite" Alias "DWriteCreateFactory" ( ByVal factoryType As ULong, ByVal riid As GUID Ptr, ByVal factory As Any Ptr Ptr) As HRESULT
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
Type DWRITE_FACTORY_TYPE As Long
Enum
    DWRITE_FACTORY_TYPE_SHARED = 0
    DWRITE_FACTORY_TYPE_ISOLATED = 1
End Enum
Type DWRITE_FONT_FILE_TYPE As Long
Enum
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
Type DWRITE_FONT_FACE_TYPE As Long
Enum
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
Type DWRITE_FONT_WEIGHT As Long
Enum
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
Type DWRITE_FONT_STRETCH As Long
Enum
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
Type DWRITE_FONT_STYLE As Long
Enum
    DWRITE_FONT_STYLE_NORMAL = 0
    DWRITE_FONT_STYLE_OBLIQUE = 1
    DWRITE_FONT_STYLE_ITALIC = 2
End Enum
Type DWRITE_INFORMATIONAL_STRING_ID As Long
Enum
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
Type DWRITE_FONT_SIMULATIONS As Long
Enum
    DWRITE_FONT_SIMULATIONS_NONE = 0
    DWRITE_FONT_SIMULATIONS_BOLD = 1
    DWRITE_FONT_SIMULATIONS_OBLIQUE = 2
End Enum
Type DWRITE_PIXEL_GEOMETRY As Long
Enum
    DWRITE_PIXEL_GEOMETRY_FLAT = 0
    DWRITE_PIXEL_GEOMETRY_RGB = 1
    DWRITE_PIXEL_GEOMETRY_BGR = 2
End Enum
Type DWRITE_RENDERING_MODE As Long
Enum
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
Type DWRITE_TEXT_ALIGNMENT As Long
Enum
    DWRITE_TEXT_ALIGNMENT_LEADING = 0
    DWRITE_TEXT_ALIGNMENT_TRAILING = 1
    DWRITE_TEXT_ALIGNMENT_CENTER = 2
    DWRITE_TEXT_ALIGNMENT_JUSTIFIED = 3
End Enum
Type DWRITE_PARAGRAPH_ALIGNMENT As Long
Enum
    DWRITE_PARAGRAPH_ALIGNMENT_NEAR = 0
    DWRITE_PARAGRAPH_ALIGNMENT_FAR = 1
    DWRITE_PARAGRAPH_ALIGNMENT_CENTER = 2
End Enum
Type DWRITE_WORD_WRAPPING As Long
Enum
    DWRITE_WORD_WRAPPING_WRAP = 0
    DWRITE_WORD_WRAPPING_NO_WRAP = 1
    DWRITE_WORD_WRAPPING_EMERGENCY_BREAK = 2
    DWRITE_WORD_WRAPPING_WHOLE_WORD = 3
    DWRITE_WORD_WRAPPING_CHARACTER = 4
End Enum
Type DWRITE_READING_DIRECTION As Long
Enum
    DWRITE_READING_DIRECTION_LEFT_TO_RIGHT = 0
    DWRITE_READING_DIRECTION_RIGHT_TO_LEFT = 1
    DWRITE_READING_DIRECTION_TOP_TO_BOTTOM = 2
    DWRITE_READING_DIRECTION_BOTTOM_TO_TOP = 3
End Enum
Type DWRITE_FLOW_DIRECTION As Long
Enum
    DWRITE_FLOW_DIRECTION_TOP_TO_BOTTOM = 0
    DWRITE_FLOW_DIRECTION_BOTTOM_TO_TOP = 1
    DWRITE_FLOW_DIRECTION_LEFT_TO_RIGHT = 2
    DWRITE_FLOW_DIRECTION_RIGHT_TO_LEFT = 3
End Enum
Type DWRITE_TRIMMING_GRANULARITY As Long
Enum
    DWRITE_TRIMMING_GRANULARITY_NONE = 0
    DWRITE_TRIMMING_GRANULARITY_CHARACTER = 1
    DWRITE_TRIMMING_GRANULARITY_WORD = 2
End Enum
Type DWRITE_BREAK_CONDITION As Long
Enum
    DWRITE_BREAK_CONDITION_NEUTRAL = 0
    DWRITE_BREAK_CONDITION_CAN_BREAK = 1
    DWRITE_BREAK_CONDITION_MAY_NOT_BREAK = 2
    DWRITE_BREAK_CONDITION_MUST_BREAK = 3
End Enum
Type DWRITE_LINE_SPACING_METHOD As Long
Enum
    DWRITE_LINE_SPACING_METHOD_DEFAULT = 0
    DWRITE_LINE_SPACING_METHOD_UNIFORM = 1
    DWRITE_LINE_SPACING_METHOD_PROPORTIONAL = 2
End Enum
Type DWRITE_FONT_FEATURE_TAG As Long
Enum
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
Type DWRITE_SCRIPT_SHAPES As Long
Enum
    DWRITE_SCRIPT_SHAPES_DEFAULT = 0
    DWRITE_SCRIPT_SHAPES_NO_VISUAL = 1
End Enum
Type DWRITE_NUMBER_SUBSTITUTION_METHOD As Long
Enum
    DWRITE_NUMBER_SUBSTITUTION_METHOD_FROM_CULTURE = 0
    DWRITE_NUMBER_SUBSTITUTION_METHOD_CONTEXTUAL = 1
    DWRITE_NUMBER_SUBSTITUTION_METHOD_NONE = 2
    DWRITE_NUMBER_SUBSTITUTION_METHOD_NATIONAL = 3
    DWRITE_NUMBER_SUBSTITUTION_METHOD_TRADITIONAL = 4
End Enum
Type DWRITE_TEXTURE_TYPE As Long
Enum
    DWRITE_TEXTURE_ALIASED_1x1 = 0
    DWRITE_TEXTURE_CLEARTYPE_3x1 = 1
End Enum
Type DWRITE_VERTICAL_GLYPH_ORIENTATION As Long
Enum
    DWRITE_VERTICAL_GLYPH_ORIENTATION_DEFAULT = 0,
    DWRITE_VERTICAL_GLYPH_ORIENTATION_STACKED = 1
End Enum
Type DWRITE_GLYPH_ORIENTATION_ANGLE As Long
Enum
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
Type IDWriteFontFileStreamVtbl As IDWriteFontFileStreamVtbl_
Type IDWriteFontFileStream
    lpVtbl As IDWriteFontFileStreamVtbl Ptr
End Type
Type IDWriteFontFileStreamVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontFileStream Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontFileStream Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontFileStream Ptr) As ULong

        
    ReadFileFragment As Function(ByVal This As IDWriteFontFileStream Ptr,  ByVal fragment_start As Any Ptr Ptr, ByVal offset As ULongInt, ByVal fragment_size As ULongInt, ByVal fragment_context As Any Ptr Ptr ) As HRESULT
        ' 5. ReleaseFileFragment
    ReleaseFileFragment As Sub(ByVal This As IDWriteFontFileStream Ptr,  ByVal fragment_context As Any Ptr )
        ' 6. GetFileSize
    GetFileSize As Function(ByVal This As IDWriteFontFileStream Ptr,  ByVal size As ULongInt Ptr ) As HRESULT
        ' 7. GetLastWriteTime
    GetLastWriteTime As Function(ByVal This As IDWriteFontFileStream Ptr,  ByVal last_writetime As ULongInt Ptr ) As HRESULT
End Type
#define IDWriteFontFileStream_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontFileStream_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontFileStream_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontFileStream_ReadFileFragment(p, a, b, c, d) (p)->lpVtbl->ReadFileFragment(p, a, b, c, d)
#define IDWriteFontFileStream_ReleaseFileFragment(p, a) (p)->lpVtbl->ReleaseFileFragment(p, a)
#define IDWriteFontFileStream_GetFileSize(p, a) (p)->lpVtbl->GetFileSize(p, a)
#define IDWriteFontFileStream_GetLastWriteTime(p, a) (p)->lpVtbl->GetLastWriteTime(p, a)

' ============================================================================
' IDWriteFontFileLoader
' ============================================================================
Type IDWriteFontFileLoaderVtbl As IDWriteFontFileLoaderVtbl_
Type IDWriteFontFileLoader
    lpVtbl As IDWriteFontFileLoaderVtbl Ptr
End Type
Type IDWriteFontFileLoaderVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontFileLoader Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontFileLoader Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontFileLoader Ptr) As ULong

        
    CreateStreamFromKey As Function(ByVal This As IDWriteFontFileLoader Ptr,  ByVal key As Any Ptr, ByVal key_size As ULong, ByVal stream As Any Ptr Ptr ) As HRESULT
End Type
#define IDWriteFontFileLoader_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontFileLoader_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontFileLoader_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontFileLoader_CreateStreamFromKey(p, a, b, c) (p)->lpVtbl->CreateStreamFromKey(p, a, b, c)

' ============================================================================
' IDWriteLocalFontFileLoader
' ============================================================================
Type IDWriteLocalFontFileLoaderVtbl As IDWriteLocalFontFileLoaderVtbl_
Type IDWriteLocalFontFileLoader
    lpVtbl As IDWriteLocalFontFileLoaderVtbl Ptr
End Type
Type IDWriteLocalFontFileLoaderVtbl_     '' Extends IDWriteFontFileLoaderVtbl_
    QueryInterface As Function(ByVal This As IDWriteLocalFontFileLoader Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteLocalFontFileLoader Ptr) As ULong
    Release As Function(ByVal This As IDWriteLocalFontFileLoader Ptr) As ULong
        
    CreateStreamFromKey As Function(ByVal This As IDWriteLocalFontFileLoader Ptr,  ByVal key As Any Ptr, ByVal key_size As ULong, ByVal stream As Any Ptr Ptr ) As HRESULT

        
    GetFilePathLengthFromKey As Function(ByVal This As IDWriteLocalFontFileLoader Ptr,  ByVal key As Any Ptr, ByVal key_size As ULong, ByVal length As ULong Ptr ) As HRESULT
        ' 6. GetFilePathFromKey
    GetFilePathFromKey As Function(ByVal This As IDWriteLocalFontFileLoader Ptr,  ByVal key As Any Ptr, ByVal key_size As ULong, ByVal path As WString Ptr, ByVal length As ULong ) As HRESULT
        ' 7. GetLastWriteTimeFromKey
    GetLastWriteTimeFromKey As Function(ByVal This As IDWriteLocalFontFileLoader Ptr,  ByVal key As Any Ptr, ByVal key_size As ULong, ByVal writetime As FILETIME Ptr ) As HRESULT
End Type
#define IDWriteLocalFontFileLoader_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteLocalFontFileLoader_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteLocalFontFileLoader_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteLocalFontFileLoader_CreateStreamFromKey(p, a, b, c) (p)->lpVtbl->CreateStreamFromKey(p, a, b, c)
#define IDWriteLocalFontFileLoader_GetFilePathLengthFromKey(p, a, b, c) (p)->lpVtbl->GetFilePathLengthFromKey(p, a, b, c)
#define IDWriteLocalFontFileLoader_GetFilePathFromKey(p, a, b, c, d) (p)->lpVtbl->GetFilePathFromKey(p, a, b, c, d)
#define IDWriteLocalFontFileLoader_GetLastWriteTimeFromKey(p, a, b, c) (p)->lpVtbl->GetLastWriteTimeFromKey(p, a, b, c)

' ============================================================================
' IDWriteFontFile
' ============================================================================
Type IDWriteFontFileVtbl As IDWriteFontFileVtbl_
Type IDWriteFontFile
    lpVtbl As IDWriteFontFileVtbl Ptr
End Type
Type IDWriteFontFileVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontFile Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontFile Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontFile Ptr) As ULong

        
    GetReferenceKey As Function(ByVal This As IDWriteFontFile Ptr,  ByVal key As Any Ptr Ptr, ByVal key_size As ULong Ptr ) As HRESULT
        ' 5. GetLoader
    GetLoader As Function(ByVal This As IDWriteFontFile Ptr,  ByVal loader As Any Ptr Ptr ) As HRESULT
        ' 6. Analyze
    Analyze As Function(ByVal This As IDWriteFontFile Ptr,  ByVal is_supported_fonttype As Long Ptr, ByVal file_type As DWRITE_FONT_FILE_TYPE Ptr, ByVal face_type As DWRITE_FONT_FACE_TYPE Ptr, ByVal faces_num As ULong Ptr ) As HRESULT
End Type
#define IDWriteFontFile_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontFile_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontFile_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontFile_GetReferenceKey(p, a, b) (p)->lpVtbl->GetReferenceKey(p, a, b)
#define IDWriteFontFile_GetLoader(p, a) (p)->lpVtbl->GetLoader(p, a)
#define IDWriteFontFile_Analyze(p, a, b, c, d) (p)->lpVtbl->Analyze(p, a, b, c, d)

' ============================================================================
' IDWriteFontFileEnumerator
' ============================================================================
Type IDWriteFontFileEnumeratorVtbl As IDWriteFontFileEnumeratorVtbl_
Type IDWriteFontFileEnumerator
    lpVtbl As IDWriteFontFileEnumeratorVtbl Ptr
End Type
Type IDWriteFontFileEnumeratorVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontFileEnumerator Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontFileEnumerator Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontFileEnumerator Ptr) As ULong

        
    MoveNext As Function(ByVal This As IDWriteFontFileEnumerator Ptr,  ByVal has_current_file As Long Ptr ) As HRESULT
        ' 5. GetCurrentFontFile
    GetCurrentFontFile As Function(ByVal This As IDWriteFontFileEnumerator Ptr,  ByVal font_file As Any Ptr Ptr ) As HRESULT
End Type
#define IDWriteFontFileEnumerator_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontFileEnumerator_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontFileEnumerator_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontFileEnumerator_MoveNext(p, a) (p)->lpVtbl->MoveNext(p, a)
#define IDWriteFontFileEnumerator_GetCurrentFontFile(p, a) (p)->lpVtbl->GetCurrentFontFile(p, a)

' ============================================================================
' IDWriteFontCollectionLoader
' ============================================================================
Type IDWriteFontCollectionLoaderVtbl As IDWriteFontCollectionLoaderVtbl_
Type IDWriteFontCollectionLoader
    lpVtbl As IDWriteFontCollectionLoaderVtbl Ptr
End Type
Type IDWriteFontCollectionLoaderVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontCollectionLoader Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontCollectionLoader Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontCollectionLoader Ptr) As ULong

        
    CreateEnumeratorFromKey As Function(ByVal This As IDWriteFontCollectionLoader Ptr,  ByVal factory As Any Ptr, ByVal key As Any Ptr, ByVal key_size As ULong, ByVal enumerator As Any Ptr Ptr ) As HRESULT
End Type
#define IDWriteFontCollectionLoader_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontCollectionLoader_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontCollectionLoader_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontCollectionLoader_CreateEnumeratorFromKey(p, a, b, c, d) (p)->lpVtbl->CreateEnumeratorFromKey(p, a, b, c, d)

' ============================================================================
' IDWriteLocalizedStrings
' ============================================================================
Type IDWriteLocalizedStringsVtbl As IDWriteLocalizedStringsVtbl_
Type IDWriteLocalizedStrings
    lpVtbl As IDWriteLocalizedStringsVtbl Ptr
End Type
Type IDWriteLocalizedStringsVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteLocalizedStrings Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteLocalizedStrings Ptr) As ULong
    Release As Function(ByVal This As IDWriteLocalizedStrings Ptr) As ULong

        
    GetCount As Function(ByVal This As IDWriteLocalizedStrings Ptr) As ULong
        ' 5. FindLocaleName
    FindLocaleName As Function(ByVal This As IDWriteLocalizedStrings Ptr,  ByVal locale_name As WString Ptr, ByVal index As ULong Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 6. GetLocaleNameLength
    GetLocaleNameLength As Function(ByVal This As IDWriteLocalizedStrings Ptr,  ByVal index As ULong, ByVal length As ULong Ptr ) As HRESULT
        ' 7. GetLocaleName
    GetLocaleName As Function(ByVal This As IDWriteLocalizedStrings Ptr,  ByVal index As ULong, ByVal locale_name As WString Ptr, ByVal size As ULong ) As HRESULT
        ' 8. GetStringLength
    GetStringLength As Function(ByVal This As IDWriteLocalizedStrings Ptr,  ByVal index As ULong, ByVal length As ULong Ptr ) As HRESULT
        ' 9. GetString
    GetString As Function(ByVal This As IDWriteLocalizedStrings Ptr,  ByVal index As ULong, ByVal buffer As WString Ptr, ByVal size As ULong ) As HRESULT
End Type
#define IDWriteLocalizedStrings_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteLocalizedStrings_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteLocalizedStrings_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteLocalizedStrings_GetCount(p, a) (p)->lpVtbl->GetCount(p, a)
#define IDWriteLocalizedStrings_FindLocaleName(p, a, b, c) (p)->lpVtbl->FindLocaleName(p, a, b, c)
#define IDWriteLocalizedStrings_GetLocaleNameLength(p, a, b) (p)->lpVtbl->GetLocaleNameLength(p, a, b)
#define IDWriteLocalizedStrings_GetLocaleName(p, a, b, c) (p)->lpVtbl->GetLocaleName(p, a, b, c)
#define IDWriteLocalizedStrings_GetStringLength(p, a, b) (p)->lpVtbl->GetStringLength(p, a, b)
#define IDWriteLocalizedStrings_GetString(p, a, b, c) (p)->lpVtbl->GetString(p, a, b, c)

' ============================================================================
' IDWriteRenderingParams
' ============================================================================
Type IDWriteRenderingParamsVtbl As IDWriteRenderingParamsVtbl_
Type IDWriteRenderingParams
    lpVtbl As IDWriteRenderingParamsVtbl Ptr
End Type
Type IDWriteRenderingParamsVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteRenderingParams Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteRenderingParams Ptr) As ULong
    Release As Function(ByVal This As IDWriteRenderingParams Ptr) As ULong

        
    GetGamma As Function(ByVal This As IDWriteRenderingParams Ptr) As Single
        ' 5. GetEnhancedContrast
    GetEnhancedContrast As Function(ByVal This As IDWriteRenderingParams Ptr) As Single
        ' 6. GetClearTypeLevel
    GetClearTypeLevel As Function(ByVal This As IDWriteRenderingParams Ptr) As Single
        ' 7. GetPixelGeometry
    GetPixelGeometry As Function(ByVal This As IDWriteRenderingParams Ptr) As DWRITE_PIXEL_GEOMETRY
        ' 8. GetRenderingMode
    GetRenderingMode As Function(ByVal This As IDWriteRenderingParams Ptr) As DWRITE_RENDERING_MODE
End Type
#define IDWriteRenderingParams_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteRenderingParams_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteRenderingParams_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteRenderingParams_GetGamma(p, a) (p)->lpVtbl->GetGamma(p, a)
#define IDWriteRenderingParams_GetEnhancedContrast(p, a) (p)->lpVtbl->GetEnhancedContrast(p, a)
#define IDWriteRenderingParams_GetClearTypeLevel(p, a) (p)->lpVtbl->GetClearTypeLevel(p, a)
#define IDWriteRenderingParams_GetPixelGeometry(p, a) (p)->lpVtbl->GetPixelGeometry(p, a)
#define IDWriteRenderingParams_GetRenderingMode(p, a) (p)->lpVtbl->GetRenderingMode(p, a)

' ============================================================================
' IDWriteFontFace
' ============================================================================
Type IDWriteFontFaceVtbl As IDWriteFontFaceVtbl_
Type IDWriteFontFace
    lpVtbl As IDWriteFontFaceVtbl Ptr
End Type
Type IDWriteFontFaceVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontFace Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontFace Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontFace Ptr) As ULong

        
    GetType As Function(ByVal This As IDWriteFontFace Ptr) As DWRITE_FONT_FACE_TYPE
        ' 5. GetFiles
    GetFiles As Function(ByVal This As IDWriteFontFace Ptr,  ByVal number_of_files As ULong Ptr, ByVal fontfiles As Any Ptr Ptr ) As HRESULT
        ' 6. GetIndex
    GetIndex As Function(ByVal This As IDWriteFontFace Ptr) As ULong
        ' 7. GetSimulations
    GetSimulations As Function(ByVal This As IDWriteFontFace Ptr) As DWRITE_FONT_SIMULATIONS
        ' 8. IsSymbolFont
    IsSymbolFont As Function(ByVal This As IDWriteFontFace Ptr) As Long
        ' 9. GetMetrics
    GetMetrics As Sub(ByVal This As IDWriteFontFace Ptr,  ByVal metrics As DWRITE_FONT_METRICS Ptr )
        ' 10. GetGlyphCount
    GetGlyphCount As Function(ByVal This As IDWriteFontFace Ptr) As UShort
        ' 11. GetDesignGlyphMetrics
    GetDesignGlyphMetrics As Function(ByVal This As IDWriteFontFace Ptr,  ByVal glyph_indices As UShort Ptr, ByVal glyph_count As ULong, ByVal metrics As DWRITE_GLYPH_METRICS Ptr, ByVal is_sideways As Long ) As HRESULT
        ' 12. GetGlyphIndices
    GetGlyphIndices As Function(ByVal This As IDWriteFontFace Ptr,  ByVal codepoints As ULong Ptr, ByVal count As ULong, ByVal glyph_indices As UShort Ptr ) As HRESULT
        ' 13. TryGetFontTable
    TryGetFontTable As Function(ByVal This As IDWriteFontFace Ptr,  ByVal table_tag As ULong, ByVal table_data As Any Ptr Ptr, ByVal table_size As ULong Ptr, ByVal context As Any Ptr Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 14. ReleaseFontTable
    ReleaseFontTable As Sub(ByVal This As IDWriteFontFace Ptr,  ByVal table_context As Any Ptr )
        ' 15. GetGlyphRunOutline
    GetGlyphRunOutline As Function(ByVal This As IDWriteFontFace Ptr,  ByVal emSize As Single, ByVal glyph_indices As UShort Ptr, ByVal glyph_advances As Single Ptr, ByVal glyph_offsets As DWRITE_GLYPH_OFFSET Ptr, ByVal glyph_count As ULong, ByVal is_sideways As Long, ByVal is_rtl As Long, ByVal geometrysink As Any Ptr ) As HRESULT
        ' 16. GetRecommendedRenderingMode
    GetRecommendedRenderingMode As Function(ByVal This As IDWriteFontFace Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal mode As DWRITE_MEASURING_MODE, ByVal params As IDWriteRenderingParams Ptr, ByVal rendering_mode As DWRITE_RENDERING_MODE Ptr ) As HRESULT
        ' 17. GetGdiCompatibleMetrics
    GetGdiCompatibleMetrics As Function(ByVal This As IDWriteFontFace Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal metrics As DWRITE_FONT_METRICS Ptr ) As HRESULT
        ' 18. GetGdiCompatibleGlyphMetrics
    GetGdiCompatibleGlyphMetrics As Function(ByVal This As IDWriteFontFace Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal use_gdi_natural As Long, ByVal glyph_indices As UShort Ptr, ByVal glyph_count As ULong, ByVal metrics As DWRITE_GLYPH_METRICS Ptr, ByVal is_sideways As Long ) As HRESULT
End Type
#define IDWriteFontFace_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontFace_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontFace_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontFace_GetType(p, a) (p)->lpVtbl->GetType(p, a)
#define IDWriteFontFace_GetFiles(p, a, b) (p)->lpVtbl->GetFiles(p, a, b)
#define IDWriteFontFace_GetIndex(p, a) (p)->lpVtbl->GetIndex(p, a)
#define IDWriteFontFace_GetSimulations(p, a) (p)->lpVtbl->GetSimulations(p, a)
#define IDWriteFontFace_IsSymbolFont(p, a) (p)->lpVtbl->IsSymbolFont(p, a)
#define IDWriteFontFace_GetMetrics(p, a) (p)->lpVtbl->GetMetrics(p, a)
#define IDWriteFontFace_GetGlyphCount(p, a) (p)->lpVtbl->GetGlyphCount(p, a)
#define IDWriteFontFace_GetDesignGlyphMetrics(p, a, b, c, d) (p)->lpVtbl->GetDesignGlyphMetrics(p, a, b, c, d)
#define IDWriteFontFace_GetGlyphIndices(p, a, b, c) (p)->lpVtbl->GetGlyphIndices(p, a, b, c)
#define IDWriteFontFace_TryGetFontTable(p, a, b, c, d, e) (p)->lpVtbl->TryGetFontTable(p, a, b, c, d, e)
#define IDWriteFontFace_ReleaseFontTable(p, a) (p)->lpVtbl->ReleaseFontTable(p, a)
#define IDWriteFontFace_GetGlyphRunOutline(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGlyphRunOutline(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace_GetRecommendedRenderingMode(p, a, b, c, d, e) (p)->lpVtbl->GetRecommendedRenderingMode(p, a, b, c, d, e)
#define IDWriteFontFace_GetGdiCompatibleMetrics(p, a, b, c, d) (p)->lpVtbl->GetGdiCompatibleMetrics(p, a, b, c, d)
#define IDWriteFontFace_GetGdiCompatibleGlyphMetrics(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGdiCompatibleGlyphMetrics(p, a, b, c, d, e, f, g, h)

' ============================================================================
' IDWriteFont
' ============================================================================
Type IDWriteFontVtbl As IDWriteFontVtbl_
Type IDWriteFont
    lpVtbl As IDWriteFontVtbl Ptr
End Type
Type IDWriteFontVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteFont Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFont Ptr) As ULong
    Release As Function(ByVal This As IDWriteFont Ptr) As ULong

        
    GetFontFamily As Function(ByVal This As IDWriteFont Ptr,  ByVal family As Any Ptr Ptr ) As HRESULT
        ' 5. GetWeight
    GetWeight As Function(ByVal This As IDWriteFont Ptr) As DWRITE_FONT_WEIGHT
        ' 6. GetStretch
    GetStretch As Function(ByVal This As IDWriteFont Ptr) As DWRITE_FONT_STRETCH
        ' 7. GetStyle
    GetStyle As Function(ByVal This As IDWriteFont Ptr) As DWRITE_FONT_STYLE
        ' 8. IsSymbolFont
    IsSymbolFont As Function(ByVal This As IDWriteFont Ptr) As Long
        ' 9. GetFaceNames
    GetFaceNames As Function(ByVal This As IDWriteFont Ptr,  ByVal names As Any Ptr Ptr ) As HRESULT
        ' 10. GetInformationalStrings
    GetInformationalStrings As Function(ByVal This As IDWriteFont Ptr,  ByVal informationalStringID As DWRITE_INFORMATIONAL_STRING_ID, ByVal informationalStrings As Any Ptr Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 11. GetSimulations
    GetSimulations As Function(ByVal This As IDWriteFont Ptr) As DWRITE_FONT_SIMULATIONS
        ' 12. GetMetrics
    GetMetrics As Sub(ByVal This As IDWriteFont Ptr,  ByVal fontMetrics As DWRITE_FONT_METRICS Ptr )
        ' 13. HasCharacter
    HasCharacter As Function(ByVal This As IDWriteFont Ptr,  ByVal unicodeValue As ULong, ByVal exists As Long Ptr ) As HRESULT
        ' 14. CreateFontFace
    CreateFontFace As Function(ByVal This As IDWriteFont Ptr,  ByVal fontFace As Any Ptr Ptr ) As HRESULT
End Type
#define IDWriteFont_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFont_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFont_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFont_GetFontFamily(p, a) (p)->lpVtbl->GetFontFamily(p, a)
#define IDWriteFont_GetWeight(p, a) (p)->lpVtbl->GetWeight(p, a)
#define IDWriteFont_GetStretch(p, a) (p)->lpVtbl->GetStretch(p, a)
#define IDWriteFont_GetStyle(p, a) (p)->lpVtbl->GetStyle(p, a)
#define IDWriteFont_IsSymbolFont(p, a) (p)->lpVtbl->IsSymbolFont(p, a)
#define IDWriteFont_GetFaceNames(p, a) (p)->lpVtbl->GetFaceNames(p, a)
#define IDWriteFont_GetInformationalStrings(p, a, b, c) (p)->lpVtbl->GetInformationalStrings(p, a, b, c)
#define IDWriteFont_GetSimulations(p, a) (p)->lpVtbl->GetSimulations(p, a)
#define IDWriteFont_GetMetrics(p, a) (p)->lpVtbl->GetMetrics(p, a)
#define IDWriteFont_HasCharacter(p, a, b) (p)->lpVtbl->HasCharacter(p, a, b)
#define IDWriteFont_CreateFontFace(p, a) (p)->lpVtbl->CreateFontFace(p, a)

' ==============================
' IDWriteFontList
' ==============================
Type IDWriteFontListVtbl As IDWriteFontListVtbl_
Type IDWriteFontList
    lpVtbl As IDWriteFontListVtbl Ptr
End Type
Type IDWriteFontListVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontList Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontList Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontList Ptr) As ULong

        ' --- IUnknown (1-3) ---
        ' 2. AddRef
        ' 4.
    GetFontCollection As Function(ByVal This As IDWriteFontList Ptr, ByRef fontCollection As any Ptr) As HRESULT 'IDWriteFontCollection Ptr
    GetFontCount As Function(ByVal This As IDWriteFontList Ptr) As ULong
    GetFont As Function(ByVal This As IDWriteFontList Ptr, ByVal index As ULong, ByRef font As IDWriteFont Ptr) As HRESULT
End Type
#define IDWriteFontList_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontList_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontList_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontList_GetFontCollection(p, a) (p)->lpVtbl->GetFontCollection(p, a)
#define IDWriteFontList_GetFontCount(p, a) (p)->lpVtbl->GetFontCount(p, a)
#define IDWriteFontList_GetFont(p, a, b) (p)->lpVtbl->GetFont(p, a, b)

' ==============================
' IDWriteFontFamily
' ==============================
Type IDWriteFontFamilyVtbl As IDWriteFontFamilyVtbl_
Type IDWriteFontFamily
    lpVtbl As IDWriteFontFamilyVtbl Ptr
End Type
Type IDWriteFontFamilyVtbl_     '' Extends IDWriteFontListVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontFamily Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontFamily Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontFamily Ptr) As ULong
        ' --- IUnknown (1-3) ---
        ' 2. AddRef
        ' 4.
    GetFontCollection As Function(ByVal This As IDWriteFontFamily Ptr, ByRef fontCollection As any Ptr) As HRESULT 'IDWriteFontCollection Ptr
    GetFontCount As Function(ByVal This As IDWriteFontFamily Ptr) As ULong
    GetFont As Function(ByVal This As IDWriteFontFamily Ptr, ByVal index As ULong, ByRef font As IDWriteFont Ptr) As HRESULT

    GetFamilyNames As Function(ByVal This As IDWriteFontFamily Ptr, ByRef names As IDWriteLocalizedStrings Ptr) As HRESULT
    GetFirstMatchingFont As Function(ByVal This As IDWriteFontFamily Ptr, ByVal weight As ULong, ByVal stretch As ULong, ByVal style As ULong, ByRef matchingFont As IDWriteFont Ptr) As HRESULT
    GetMatchingFonts As Function(ByVal This As IDWriteFontFamily Ptr, ByVal weight As DWRITE_FONT_WEIGHT, ByVal stretch As ULong, ByVal style As ULong, ByRef matchingFonts As IDWriteFontList Ptr) As HRESULT
End Type
#define IDWriteFontFamily_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontFamily_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontFamily_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontFamily_GetFontCollection(p, a) (p)->lpVtbl->GetFontCollection(p, a)
#define IDWriteFontFamily_GetFontCount(p, a) (p)->lpVtbl->GetFontCount(p, a)
#define IDWriteFontFamily_GetFont(p, a, b) (p)->lpVtbl->GetFont(p, a, b)
#define IDWriteFontFamily_GetFamilyNames(p, a) (p)->lpVtbl->GetFamilyNames(p, a)
#define IDWriteFontFamily_GetFirstMatchingFont(p, a, b, c, d) (p)->lpVtbl->GetFirstMatchingFont(p, a, b, c, d)
#define IDWriteFontFamily_GetMatchingFonts(p, a, b, c, d) (p)->lpVtbl->GetMatchingFonts(p, a, b, c, d)

' ==============================
' IDWriteFontCollection
' ==============================
Type IDWriteFontCollectionVtbl As IDWriteFontCollectionVtbl_
Type IDWriteFontCollection
    lpVtbl As IDWriteFontCollectionVtbl Ptr
End Type
Type IDWriteFontCollectionVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontCollection Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontCollection Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontCollection Ptr) As ULong

        ' --- IUnknown (1-3) ---
        ' 2. AddRef
        ' 4.
    GetFontFamilyCount As Function(ByVal This As IDWriteFontCollection Ptr) As ULong
    GetFontFamily As Function(ByVal This As IDWriteFontCollection Ptr, ByVal index As ULong, ByRef fontFamily As IDWriteFontFamily Ptr) As HRESULT
    FindFamilyName As Function(ByVal This As IDWriteFontCollection Ptr, ByVal familyName As WString Ptr, ByRef index As ULong, ByRef exists As Long) As HRESULT
    GetFontFromFontFace As Function(ByVal This As IDWriteFontCollection Ptr, ByVal fontFace As IDWriteFontFace Ptr, ByRef font As IDWriteFont Ptr) As HRESULT
End Type
#define IDWriteFontCollection_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontCollection_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontCollection_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontCollection_GetFontFamilyCount(p, a) (p)->lpVtbl->GetFontFamilyCount(p, a)
#define IDWriteFontCollection_GetFontFamily(p, a, b) (p)->lpVtbl->GetFontFamily(p, a, b)
#define IDWriteFontCollection_FindFamilyName(p, a, b, c) (p)->lpVtbl->FindFamilyName(p, a, b, c)
#define IDWriteFontCollection_GetFontFromFontFace(p, a, b) (p)->lpVtbl->GetFontFromFontFace(p, a, b)

' ============================================================================
' IDWritePixelSnapping
' ============================================================================
Type IDWritePixelSnappingVtbl As IDWritePixelSnappingVtbl_
Type IDWritePixelSnapping
    lpVtbl As IDWritePixelSnappingVtbl Ptr
End Type
Type IDWritePixelSnappingVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWritePixelSnapping Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWritePixelSnapping Ptr) As ULong
    Release As Function(ByVal This As IDWritePixelSnapping Ptr) As ULong

        
    IsPixelSnappingDisabled As Function(ByVal This As IDWritePixelSnapping Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal isDisabled As Long Ptr ) As HRESULT
        ' 5. GetCurrentTransform
    GetCurrentTransform As Function(ByVal This As IDWritePixelSnapping Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal transform As DWRITE_MATRIX Ptr ) As HRESULT
        ' 6. GetPixelsPerDip
    GetPixelsPerDip As Function(ByVal This As IDWritePixelSnapping Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal pixelsPerDip As Single Ptr ) As HRESULT
End Type
#define IDWritePixelSnapping_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWritePixelSnapping_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWritePixelSnapping_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWritePixelSnapping_IsPixelSnappingDisabled(p, a, b) (p)->lpVtbl->IsPixelSnappingDisabled(p, a, b)
#define IDWritePixelSnapping_GetCurrentTransform(p, a, b) (p)->lpVtbl->GetCurrentTransform(p, a, b)
#define IDWritePixelSnapping_GetPixelsPerDip(p, a, b) (p)->lpVtbl->GetPixelsPerDip(p, a, b)

' ============================================================================
' IDWriteTextRenderer
' ============================================================================
Type IDWriteTextRendererVtbl As IDWriteTextRendererVtbl_
Type IDWriteTextRenderer
    lpVtbl As IDWriteTextRendererVtbl Ptr
End Type
Type IDWriteTextRendererVtbl_     '' Extends IDWritePixelSnappingVtbl_
    QueryInterface As Function(ByVal This As IDWriteTextRenderer Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteTextRenderer Ptr) As ULong
    Release As Function(ByVal This As IDWriteTextRenderer Ptr) As ULong
        
    IsPixelSnappingDisabled As Function(ByVal This As IDWriteTextRenderer Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal isDisabled As Long Ptr ) As HRESULT
        ' 5. GetCurrentTransform
    GetCurrentTransform As Function(ByVal This As IDWriteTextRenderer Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal transform As DWRITE_MATRIX Ptr ) As HRESULT
        ' 6. GetPixelsPerDip
    GetPixelsPerDip As Function(ByVal This As IDWriteTextRenderer Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal pixelsPerDip As Single Ptr ) As HRESULT

        
    DrawGlyphRun As Function(ByVal This As IDWriteTextRenderer Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal glyphRunDescription As DWRITE_GLYPH_RUN_DESCRIPTION Ptr, ByVal clientDrawingEffect As IUnknown Ptr ) As HRESULT
        ' 8. DrawUnderline
    DrawUnderline As Function(ByVal This As IDWriteTextRenderer Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal underline As DWRITE_UNDERLINE Ptr, ByVal clientDrawingEffect As IUnknown Ptr ) As HRESULT
        ' 9. DrawStrikethrough
    DrawStrikethrough As Function(ByVal This As IDWriteTextRenderer Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal strikethrough As DWRITE_STRIKETHROUGH Ptr, ByVal clientDrawingEffect As IUnknown Ptr ) As HRESULT
        ' 10. DrawInlineObject
    DrawInlineObject As Function(ByVal This As IDWriteTextRenderer Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal originX As Single, ByVal originY As Single, ByVal inlineObject As Any Ptr, ByVal isSideways As Long, ByVal isRightToLeft As Long, ByVal clientDrawingEffect As IUnknown Ptr ) As HRESULT
End Type
#define IDWriteTextRenderer_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteTextRenderer_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteTextRenderer_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteTextRenderer_IsPixelSnappingDisabled(p, a, b) (p)->lpVtbl->IsPixelSnappingDisabled(p, a, b)
#define IDWriteTextRenderer_GetCurrentTransform(p, a, b) (p)->lpVtbl->GetCurrentTransform(p, a, b)
#define IDWriteTextRenderer_GetPixelsPerDip(p, a, b) (p)->lpVtbl->GetPixelsPerDip(p, a, b)
#define IDWriteTextRenderer_DrawGlyphRun(p, a, b, c, d, e, f, g) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d, e, f, g)
#define IDWriteTextRenderer_DrawUnderline(p, a, b, c, d, e) (p)->lpVtbl->DrawUnderline(p, a, b, c, d, e)
#define IDWriteTextRenderer_DrawStrikethrough(p, a, b, c, d, e) (p)->lpVtbl->DrawStrikethrough(p, a, b, c, d, e)
#define IDWriteTextRenderer_DrawInlineObject(p, a, b, c, d, e, f, g) (p)->lpVtbl->DrawInlineObject(p, a, b, c, d, e, f, g)

' ============================================================================
' IDWriteInlineObject
' ============================================================================
Type IDWriteInlineObjectVtbl As IDWriteInlineObjectVtbl_
Type IDWriteInlineObject
    lpVtbl As IDWriteInlineObjectVtbl Ptr
End Type
Type IDWriteInlineObjectVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteInlineObject Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteInlineObject Ptr) As ULong
    Release As Function(ByVal This As IDWriteInlineObject Ptr) As ULong

        
    Draw As Function(ByVal This As IDWriteInlineObject Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal renderer As Any Ptr, ByVal originX As Single, ByVal originY As Single, ByVal isSideways As Long, ByVal isRightToLeft As Long, ByVal clientDrawingEffect As IUnknown Ptr ) As HRESULT
        ' 5. GetMetrics
    GetMetrics As Function(ByVal This As IDWriteInlineObject Ptr,  ByVal metrics As DWRITE_INLINE_OBJECT_METRICS Ptr ) As HRESULT
        ' 6. GetOverhangMetrics
    GetOverhangMetrics As Function(ByVal This As IDWriteInlineObject Ptr,  ByVal overhangs As DWRITE_OVERHANG_METRICS Ptr ) As HRESULT
        ' 7. GetBreakConditions
    GetBreakConditions As Function(ByVal This As IDWriteInlineObject Ptr,  ByVal breakConditionBefore As DWRITE_BREAK_CONDITION Ptr, ByVal breakConditionAfter As DWRITE_BREAK_CONDITION Ptr ) As HRESULT
End Type
#define IDWriteInlineObject_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteInlineObject_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteInlineObject_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteInlineObject_Draw(p, a, b, c, d, e, f, g) (p)->lpVtbl->Draw(p, a, b, c, d, e, f, g)
#define IDWriteInlineObject_GetMetrics(p, a) (p)->lpVtbl->GetMetrics(p, a)
#define IDWriteInlineObject_GetOverhangMetrics(p, a) (p)->lpVtbl->GetOverhangMetrics(p, a)
#define IDWriteInlineObject_GetBreakConditions(p, a, b) (p)->lpVtbl->GetBreakConditions(p, a, b)

' ============================================================================
' IDWriteTextFormat
' ============================================================================
Type IDWriteTextFormatVtbl As IDWriteTextFormatVtbl_
Type IDWriteTextFormat
    lpVtbl As IDWriteTextFormatVtbl Ptr
End Type
Type IDWriteTextFormatVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteTextFormat Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteTextFormat Ptr) As ULong
    Release As Function(ByVal This As IDWriteTextFormat Ptr) As ULong

        
    SetTextAlignment As Function(ByVal This As IDWriteTextFormat Ptr,  ByVal textAlignment As DWRITE_TEXT_ALIGNMENT ) As HRESULT
        ' 5. SetParagraphAlignment
    SetParagraphAlignment As Function(ByVal This As IDWriteTextFormat Ptr,  ByVal paragraphAlignment As DWRITE_PARAGRAPH_ALIGNMENT ) As HRESULT
        ' 6. SetWordWrapping
    SetWordWrapping As Function(ByVal This As IDWriteTextFormat Ptr,  ByVal wordWrapping As DWRITE_WORD_WRAPPING ) As HRESULT
        ' 7. SetReadingDirection
    SetReadingDirection As Function(ByVal This As IDWriteTextFormat Ptr,  ByVal readingDirection As DWRITE_READING_DIRECTION ) As HRESULT
        ' 8. SetFlowDirection
    SetFlowDirection As Function(ByVal This As IDWriteTextFormat Ptr,  ByVal flowDirection As DWRITE_FLOW_DIRECTION ) As HRESULT
        ' 9. SetIncrementalTabStop
    SetIncrementalTabStop As Function(ByVal This As IDWriteTextFormat Ptr,  ByVal incrementalTabStop As Single ) As HRESULT
        ' 10. SetTrimming
    SetTrimming As Function(ByVal This As IDWriteTextFormat Ptr,  ByVal trimmingOptions As DWRITE_TRIMMING Ptr, ByVal trimmingSign As Any Ptr ) As HRESULT
        ' 11. SetLineSpacing
    SetLineSpacing As Function(ByVal This As IDWriteTextFormat Ptr,  ByVal lineSpacingMethod As DWRITE_LINE_SPACING_METHOD, ByVal lineSpacing As Single, ByVal baseline As Single ) As HRESULT
        ' 12. GetTextAlignment
    GetTextAlignment As Function(ByVal This As IDWriteTextFormat Ptr) As DWRITE_TEXT_ALIGNMENT
        ' 13. GetParagraphAlignment
    GetParagraphAlignment As Function(ByVal This As IDWriteTextFormat Ptr) As DWRITE_PARAGRAPH_ALIGNMENT
        ' 14. GetWordWrapping
    GetWordWrapping As Function(ByVal This As IDWriteTextFormat Ptr) As DWRITE_WORD_WRAPPING
        ' 15. GetReadingDirection
    GetReadingDirection As Function(ByVal This As IDWriteTextFormat Ptr) As DWRITE_READING_DIRECTION
        ' 16. GetFlowDirection
    GetFlowDirection As Function(ByVal This As IDWriteTextFormat Ptr) As DWRITE_FLOW_DIRECTION
        ' 17. GetIncrementalTabStop
    GetIncrementalTabStop As Function(ByVal This As IDWriteTextFormat Ptr) As Single
        ' 18. GetTrimming
    GetTrimming As Function(ByVal This As IDWriteTextFormat Ptr,  ByVal trimmingOptions As DWRITE_TRIMMING Ptr, ByVal trimmingSign As Any Ptr Ptr ) As HRESULT
        ' 19. GetLineSpacing
    GetLineSpacing As Function(ByVal This As IDWriteTextFormat Ptr,  ByVal lineSpacingMethod As DWRITE_LINE_SPACING_METHOD Ptr, ByVal lineSpacing As Single Ptr, ByVal baseline As Single Ptr ) As HRESULT
        ' 20. GetFontCollection
    GetFontCollection As Function(ByVal This As IDWriteTextFormat Ptr,  ByVal fontCollection As Any Ptr Ptr ) As HRESULT
        ' 21. GetFontFamilyNameLength
    GetFontFamilyNameLength As Function(ByVal This As IDWriteTextFormat Ptr) As ULong
        ' 22. GetFontFamilyName
    GetFontFamilyName As Function(ByVal This As IDWriteTextFormat Ptr,  ByVal fontFamilyName As WString Ptr, ByVal nameSize As ULong ) As HRESULT
        ' 23. GetFontWeight
    GetFontWeight As Function(ByVal This As IDWriteTextFormat Ptr) As DWRITE_FONT_WEIGHT
        ' 24. GetFontStyle
    GetFontStyle As Function(ByVal This As IDWriteTextFormat Ptr) As DWRITE_FONT_STYLE
        ' 25. GetFontStretch
    GetFontStretch As Function(ByVal This As IDWriteTextFormat Ptr) As DWRITE_FONT_STRETCH
        ' 26. GetFontSize
    GetFontSize As Function(ByVal This As IDWriteTextFormat Ptr) As Single
        ' 27. GetLocaleNameLength
    GetLocaleNameLength As Function(ByVal This As IDWriteTextFormat Ptr) As ULong
        ' 28. GetLocaleName
    GetLocaleName As Function(ByVal This As IDWriteTextFormat Ptr,  ByVal localeName As WString Ptr, ByVal nameSize As ULong ) As HRESULT
End Type
#define IDWriteTextFormat_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteTextFormat_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteTextFormat_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteTextFormat_SetTextAlignment(p, a) (p)->lpVtbl->SetTextAlignment(p, a)
#define IDWriteTextFormat_SetParagraphAlignment(p, a) (p)->lpVtbl->SetParagraphAlignment(p, a)
#define IDWriteTextFormat_SetWordWrapping(p, a) (p)->lpVtbl->SetWordWrapping(p, a)
#define IDWriteTextFormat_SetReadingDirection(p, a) (p)->lpVtbl->SetReadingDirection(p, a)
#define IDWriteTextFormat_SetFlowDirection(p, a) (p)->lpVtbl->SetFlowDirection(p, a)
#define IDWriteTextFormat_SetIncrementalTabStop(p, a) (p)->lpVtbl->SetIncrementalTabStop(p, a)
#define IDWriteTextFormat_SetTrimming(p, a, b) (p)->lpVtbl->SetTrimming(p, a, b)
#define IDWriteTextFormat_SetLineSpacing(p, a, b, c) (p)->lpVtbl->SetLineSpacing(p, a, b, c)
#define IDWriteTextFormat_GetTextAlignment(p, a) (p)->lpVtbl->GetTextAlignment(p, a)
#define IDWriteTextFormat_GetParagraphAlignment(p, a) (p)->lpVtbl->GetParagraphAlignment(p, a)
#define IDWriteTextFormat_GetWordWrapping(p, a) (p)->lpVtbl->GetWordWrapping(p, a)
#define IDWriteTextFormat_GetReadingDirection(p, a) (p)->lpVtbl->GetReadingDirection(p, a)
#define IDWriteTextFormat_GetFlowDirection(p, a) (p)->lpVtbl->GetFlowDirection(p, a)
#define IDWriteTextFormat_GetIncrementalTabStop(p, a) (p)->lpVtbl->GetIncrementalTabStop(p, a)
#define IDWriteTextFormat_GetTrimming(p, a, b) (p)->lpVtbl->GetTrimming(p, a, b)
#define IDWriteTextFormat_GetLineSpacing(p, a, b, c) (p)->lpVtbl->GetLineSpacing(p, a, b, c)
#define IDWriteTextFormat_GetFontCollection(p, a) (p)->lpVtbl->GetFontCollection(p, a)
#define IDWriteTextFormat_GetFontFamilyNameLength(p, a) (p)->lpVtbl->GetFontFamilyNameLength(p, a)
#define IDWriteTextFormat_GetFontFamilyName(p, a, b) (p)->lpVtbl->GetFontFamilyName(p, a, b)
#define IDWriteTextFormat_GetFontWeight(p, a) (p)->lpVtbl->GetFontWeight(p, a)
#define IDWriteTextFormat_GetFontStyle(p, a) (p)->lpVtbl->GetFontStyle(p, a)
#define IDWriteTextFormat_GetFontStretch(p, a) (p)->lpVtbl->GetFontStretch(p, a)
#define IDWriteTextFormat_GetFontSize(p, a) (p)->lpVtbl->GetFontSize(p, a)
#define IDWriteTextFormat_GetLocaleNameLength(p, a) (p)->lpVtbl->GetLocaleNameLength(p, a)
#define IDWriteTextFormat_GetLocaleName(p, a, b) (p)->lpVtbl->GetLocaleName(p, a, b)

' ============================================================================
' IDWriteTextLayout
' ============================================================================
Type IDWriteTextLayoutVtbl As IDWriteTextLayoutVtbl_
Type IDWriteTextLayout
    lpVtbl As IDWriteTextLayoutVtbl Ptr
End Type
Type IDWriteTextLayoutVtbl_     '' Extends IDWriteTextFormatVtbl_
    QueryInterface As Function(ByVal This As IDWriteTextLayout Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteTextLayout Ptr) As ULong
    Release As Function(ByVal This As IDWriteTextLayout Ptr) As ULong
        
    SetTextAlignment As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal textAlignment As DWRITE_TEXT_ALIGNMENT ) As HRESULT
        ' 5. SetParagraphAlignment
    SetParagraphAlignment As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal paragraphAlignment As DWRITE_PARAGRAPH_ALIGNMENT ) As HRESULT
        ' 6. SetWordWrapping
    SetWordWrapping As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal wordWrapping As DWRITE_WORD_WRAPPING ) As HRESULT
        ' 7. SetReadingDirection
    SetReadingDirection As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal readingDirection As DWRITE_READING_DIRECTION ) As HRESULT
        ' 8. SetFlowDirection
    SetFlowDirection As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal flowDirection As DWRITE_FLOW_DIRECTION ) As HRESULT
        ' 9. SetIncrementalTabStop
    SetIncrementalTabStop As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal incrementalTabStop As Single ) As HRESULT
        ' 10. SetTrimming
    SetTrimming As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal trimmingOptions As DWRITE_TRIMMING Ptr, ByVal trimmingSign As Any Ptr ) As HRESULT
        ' 11. SetLineSpacing
    SetLineSpacing As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal lineSpacingMethod As DWRITE_LINE_SPACING_METHOD, ByVal lineSpacing As Single, ByVal baseline As Single ) As HRESULT
        ' 12. GetTextAlignment
    GetTextAlignment As Function(ByVal This As IDWriteTextLayout Ptr) As DWRITE_TEXT_ALIGNMENT
        ' 13. GetParagraphAlignment
    GetParagraphAlignment As Function(ByVal This As IDWriteTextLayout Ptr) As DWRITE_PARAGRAPH_ALIGNMENT
        ' 14. GetWordWrapping
    GetWordWrapping As Function(ByVal This As IDWriteTextLayout Ptr) As DWRITE_WORD_WRAPPING
        ' 15. GetReadingDirection
    GetReadingDirection As Function(ByVal This As IDWriteTextLayout Ptr) As DWRITE_READING_DIRECTION
        ' 16. GetFlowDirection
    GetFlowDirection As Function(ByVal This As IDWriteTextLayout Ptr) As DWRITE_FLOW_DIRECTION
        ' 17. GetIncrementalTabStop
    GetIncrementalTabStop As Function(ByVal This As IDWriteTextLayout Ptr) As Single
        ' 18. GetTrimming
    GetTrimming As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal trimmingOptions As DWRITE_TRIMMING Ptr, ByVal trimmingSign As Any Ptr Ptr ) As HRESULT
        ' 19. GetLineSpacing
    GetLineSpacing As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal lineSpacingMethod As DWRITE_LINE_SPACING_METHOD Ptr, ByVal lineSpacing As Single Ptr, ByVal baseline As Single Ptr ) As HRESULT
        ' 20. GetFontCollection
    GetFontCollection As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal fontCollection As Any Ptr Ptr ) As HRESULT
        ' 21. GetFontFamilyNameLength
    GetFontFamilyNameLength As Function(ByVal This As IDWriteTextLayout Ptr) As ULong
        ' 22. GetFontFamilyName
    GetFontFamilyName As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal fontFamilyName As WString Ptr, ByVal nameSize As ULong ) As HRESULT
        ' 23. GetFontWeight
    GetFontWeight As Function(ByVal This As IDWriteTextLayout Ptr) As DWRITE_FONT_WEIGHT
        ' 24. GetFontStyle
    GetFontStyle As Function(ByVal This As IDWriteTextLayout Ptr) As DWRITE_FONT_STYLE
        ' 25. GetFontStretch
    GetFontStretch As Function(ByVal This As IDWriteTextLayout Ptr) As DWRITE_FONT_STRETCH
        ' 26. GetFontSize
    GetFontSize As Function(ByVal This As IDWriteTextLayout Ptr) As Single
        ' 27. GetLocaleNameLength
    GetLocaleNameLength As Function(ByVal This As IDWriteTextLayout Ptr) As ULong
        ' 28. GetLocaleName
    GetLocaleName As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal localeName As WString Ptr, ByVal nameSize As ULong ) As HRESULT

        
    SetMaxWidth As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal maxWidth As Single ) As HRESULT
        ' 30. SetMaxHeight
    SetMaxHeight As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal maxHeight As Single ) As HRESULT
        ' 31. SetFontCollection
    SetFontCollection As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal fontCollection As Any Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 32. SetFontFamilyName
    SetFontFamilyName As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal fontFamilyName As WString Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 33. SetFontWeight
    SetFontWeight As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal fontWeight As DWRITE_FONT_WEIGHT, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 34. SetFontStyle
    SetFontStyle As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal fontStyle As DWRITE_FONT_STYLE, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 35. SetFontStretch
    SetFontStretch As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal fontStretch As DWRITE_FONT_STRETCH, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 36. SetFontSize
    SetFontSize As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal fontSize As Single, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 37. SetUnderline
    SetUnderline As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal hasUnderline As Long, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 38. SetStrikethrough
    SetStrikethrough As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal hasStrikethrough As Long, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 39. SetDrawingEffect
    SetDrawingEffect As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal drawingEffect As IUnknown Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 40. SetInlineObject
    SetInlineObject As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal inlineObject As Any Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 41. SetTypography
    SetTypography As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal typography As Any Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 42. SetLocaleName
    SetLocaleName As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal localeName As WString Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 43. GetMaxWidth
    GetMaxWidth As Function(ByVal This As IDWriteTextLayout Ptr) As Single
        ' 44. GetMaxHeight
    GetMaxHeight As Function(ByVal This As IDWriteTextLayout Ptr) As Single
        ' 45. GetFontCollection
    GetFontCollection1 As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal currentPosition As ULong, ByVal fontCollection As Any Ptr Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 46. GetFontFamilyNameLength
    GetFontFamilyNameLength1 As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal currentPosition As ULong, ByVal nameLength As ULong Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 47. GetFontFamilyName
    GetFontFamilyName1 As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal currentPosition As ULong, ByVal fontFamilyName As WString Ptr, ByVal nameSize As ULong, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 48. GetFontWeight
    GetFontWeight1 As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal currentPosition As ULong, ByVal fontWeight As DWRITE_FONT_WEIGHT Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 49. GetFontStyle
    GetFontStyle1 As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal currentPosition As ULong, ByVal fontStyle As DWRITE_FONT_STYLE Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 50. GetFontStretch
    GetFontStretch1 As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal currentPosition As ULong, ByVal fontStretch As DWRITE_FONT_STRETCH Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 51. GetFontSize
    GetFontSize1 As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal currentPosition As ULong, ByVal fontSize As Single Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 52. GetUnderline
    GetUnderline As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal currentPosition As ULong, ByVal hasUnderline As Long Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 53. GetStrikethrough
    GetStrikethrough As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal currentPosition As ULong, ByVal hasStrikethrough As Long Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 54. GetDrawingEffect
    GetDrawingEffect As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal currentPosition As ULong, ByVal drawingEffect As IUnknown Ptr Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 55. GetInlineObject
    GetInlineObject As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal currentPosition As ULong, ByVal inlineObject As Any Ptr Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 56. GetTypography
    GetTypography As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal currentPosition As ULong, ByVal typography As Any Ptr Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 57. GetLocaleNameLength
    GetLocaleNameLength1 As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal currentPosition As ULong, ByVal nameLength As ULong Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 58. GetLocaleName
    GetLocaleName1 As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal currentPosition As ULong, ByVal localeName As WString Ptr, ByVal nameSize As ULong, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 59. Draw
    Draw As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal renderer As Any Ptr, ByVal originX As Single, ByVal originY As Single ) As HRESULT
        ' 60. GetLineMetrics
    GetLineMetrics As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal lineMetrics As DWRITE_LINE_METRICS Ptr, ByVal maxLineCount As ULong, ByVal actualLineCount As ULong Ptr ) As HRESULT
        ' 61. GetMetrics
    GetMetrics As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal textMetrics As DWRITE_TEXT_METRICS Ptr ) As HRESULT
        ' 62. GetOverhangMetrics
    GetOverhangMetrics As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal overhangs As DWRITE_OVERHANG_METRICS Ptr ) As HRESULT
        ' 63. GetClusterMetrics
    GetClusterMetrics As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal clusterMetrics As DWRITE_CLUSTER_METRICS Ptr, ByVal maxClusterCount As ULong, ByVal actualClusterCount As ULong Ptr ) As HRESULT
        ' 64. DetermineMinWidth
    DetermineMinWidth As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal minWidth As Single Ptr ) As HRESULT
        ' 65. HitTestPoint
    HitTestPoint As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal pointX As Single, ByVal pointY As Single, ByVal isTrailingHit As Long Ptr, ByVal isInside As Long Ptr, ByVal hitTestMetrics As DWRITE_HIT_TEST_METRICS Ptr ) As HRESULT
        ' 66. HitTestTextPosition
    HitTestTextPosition As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal textPosition As ULong, ByVal isTrailingHit As Long, ByVal pointX As Single Ptr, ByVal pointY As Single Ptr, ByVal hitTestMetrics As DWRITE_HIT_TEST_METRICS Ptr ) As HRESULT
        ' 67. HitTestTextRange
    HitTestTextRange As Function(ByVal This As IDWriteTextLayout Ptr,  ByVal textPosition As ULong, ByVal textLength As ULong, ByVal originX As Single, ByVal originY As Single, ByVal hitTestMetrics As DWRITE_HIT_TEST_METRICS Ptr, ByVal maxHitTestMetricsCount As ULong, ByVal actualHitTestMetricsCount As ULong Ptr ) As HRESULT
End Type
#define IDWriteTextLayout_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteTextLayout_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteTextLayout_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteTextLayout_SetTextAlignment(p, a) (p)->lpVtbl->SetTextAlignment(p, a)
#define IDWriteTextLayout_SetParagraphAlignment(p, a) (p)->lpVtbl->SetParagraphAlignment(p, a)
#define IDWriteTextLayout_SetWordWrapping(p, a) (p)->lpVtbl->SetWordWrapping(p, a)
#define IDWriteTextLayout_SetReadingDirection(p, a) (p)->lpVtbl->SetReadingDirection(p, a)
#define IDWriteTextLayout_SetFlowDirection(p, a) (p)->lpVtbl->SetFlowDirection(p, a)
#define IDWriteTextLayout_SetIncrementalTabStop(p, a) (p)->lpVtbl->SetIncrementalTabStop(p, a)
#define IDWriteTextLayout_SetTrimming(p, a, b) (p)->lpVtbl->SetTrimming(p, a, b)
#define IDWriteTextLayout_SetLineSpacing(p, a, b, c) (p)->lpVtbl->SetLineSpacing(p, a, b, c)
#define IDWriteTextLayout_GetTextAlignment(p, a) (p)->lpVtbl->GetTextAlignment(p, a)
#define IDWriteTextLayout_GetParagraphAlignment(p, a) (p)->lpVtbl->GetParagraphAlignment(p, a)
#define IDWriteTextLayout_GetWordWrapping(p, a) (p)->lpVtbl->GetWordWrapping(p, a)
#define IDWriteTextLayout_GetReadingDirection(p, a) (p)->lpVtbl->GetReadingDirection(p, a)
#define IDWriteTextLayout_GetFlowDirection(p, a) (p)->lpVtbl->GetFlowDirection(p, a)
#define IDWriteTextLayout_GetIncrementalTabStop(p, a) (p)->lpVtbl->GetIncrementalTabStop(p, a)
#define IDWriteTextLayout_GetTrimming(p, a, b) (p)->lpVtbl->GetTrimming(p, a, b)
#define IDWriteTextLayout_GetLineSpacing(p, a, b, c) (p)->lpVtbl->GetLineSpacing(p, a, b, c)
#define IDWriteTextLayout_GetFontCollection(p, a) (p)->lpVtbl->GetFontCollection(p, a)
#define IDWriteTextLayout_GetFontFamilyNameLength(p, a) (p)->lpVtbl->GetFontFamilyNameLength(p, a)
#define IDWriteTextLayout_GetFontFamilyName(p, a, b) (p)->lpVtbl->GetFontFamilyName(p, a, b)
#define IDWriteTextLayout_GetFontWeight(p, a) (p)->lpVtbl->GetFontWeight(p, a)
#define IDWriteTextLayout_GetFontStyle(p, a) (p)->lpVtbl->GetFontStyle(p, a)
#define IDWriteTextLayout_GetFontStretch(p, a) (p)->lpVtbl->GetFontStretch(p, a)
#define IDWriteTextLayout_GetFontSize(p, a) (p)->lpVtbl->GetFontSize(p, a)
#define IDWriteTextLayout_GetLocaleNameLength(p, a) (p)->lpVtbl->GetLocaleNameLength(p, a)
#define IDWriteTextLayout_GetLocaleName(p, a, b) (p)->lpVtbl->GetLocaleName(p, a, b)
#define IDWriteTextLayout_SetMaxWidth(p, a) (p)->lpVtbl->SetMaxWidth(p, a)
#define IDWriteTextLayout_SetMaxHeight(p, a) (p)->lpVtbl->SetMaxHeight(p, a)
#define IDWriteTextLayout_SetFontCollection(p, a, b) (p)->lpVtbl->SetFontCollection(p, a, b)
#define IDWriteTextLayout_SetFontFamilyName(p, a, b) (p)->lpVtbl->SetFontFamilyName(p, a, b)
#define IDWriteTextLayout_SetFontWeight(p, a, b) (p)->lpVtbl->SetFontWeight(p, a, b)
#define IDWriteTextLayout_SetFontStyle(p, a, b) (p)->lpVtbl->SetFontStyle(p, a, b)
#define IDWriteTextLayout_SetFontStretch(p, a, b) (p)->lpVtbl->SetFontStretch(p, a, b)
#define IDWriteTextLayout_SetFontSize(p, a, b) (p)->lpVtbl->SetFontSize(p, a, b)
#define IDWriteTextLayout_SetUnderline(p, a, b) (p)->lpVtbl->SetUnderline(p, a, b)
#define IDWriteTextLayout_SetStrikethrough(p, a, b) (p)->lpVtbl->SetStrikethrough(p, a, b)
#define IDWriteTextLayout_SetDrawingEffect(p, a, b) (p)->lpVtbl->SetDrawingEffect(p, a, b)
#define IDWriteTextLayout_SetInlineObject(p, a, b) (p)->lpVtbl->SetInlineObject(p, a, b)
#define IDWriteTextLayout_SetTypography(p, a, b) (p)->lpVtbl->SetTypography(p, a, b)
#define IDWriteTextLayout_SetLocaleName(p, a, b) (p)->lpVtbl->SetLocaleName(p, a, b)
#define IDWriteTextLayout_GetMaxWidth(p, a) (p)->lpVtbl->GetMaxWidth(p, a)
#define IDWriteTextLayout_GetMaxHeight(p, a) (p)->lpVtbl->GetMaxHeight(p, a)
#define IDWriteTextLayout_GetFontCollection1(p, a, b, c) (p)->lpVtbl->GetFontCollection1(p, a, b, c)
#define IDWriteTextLayout_GetFontFamilyNameLength1(p, a, b, c) (p)->lpVtbl->GetFontFamilyNameLength1(p, a, b, c)
#define IDWriteTextLayout_GetFontFamilyName1(p, a, b, c, d) (p)->lpVtbl->GetFontFamilyName1(p, a, b, c, d)
#define IDWriteTextLayout_GetFontWeight1(p, a, b, c) (p)->lpVtbl->GetFontWeight1(p, a, b, c)
#define IDWriteTextLayout_GetFontStyle1(p, a, b, c) (p)->lpVtbl->GetFontStyle1(p, a, b, c)
#define IDWriteTextLayout_GetFontStretch1(p, a, b, c) (p)->lpVtbl->GetFontStretch1(p, a, b, c)
#define IDWriteTextLayout_GetFontSize1(p, a, b, c) (p)->lpVtbl->GetFontSize1(p, a, b, c)
#define IDWriteTextLayout_GetUnderline(p, a, b, c) (p)->lpVtbl->GetUnderline(p, a, b, c)
#define IDWriteTextLayout_GetStrikethrough(p, a, b, c) (p)->lpVtbl->GetStrikethrough(p, a, b, c)
#define IDWriteTextLayout_GetDrawingEffect(p, a, b, c) (p)->lpVtbl->GetDrawingEffect(p, a, b, c)
#define IDWriteTextLayout_GetInlineObject(p, a, b, c) (p)->lpVtbl->GetInlineObject(p, a, b, c)
#define IDWriteTextLayout_GetTypography(p, a, b, c) (p)->lpVtbl->GetTypography(p, a, b, c)
#define IDWriteTextLayout_GetLocaleNameLength1(p, a, b, c) (p)->lpVtbl->GetLocaleNameLength1(p, a, b, c)
#define IDWriteTextLayout_GetLocaleName1(p, a, b, c, d) (p)->lpVtbl->GetLocaleName1(p, a, b, c, d)
#define IDWriteTextLayout_Draw(p, a, b, c, d) (p)->lpVtbl->Draw(p, a, b, c, d)
#define IDWriteTextLayout_GetLineMetrics(p, a, b, c) (p)->lpVtbl->GetLineMetrics(p, a, b, c)
#define IDWriteTextLayout_GetMetrics(p, a) (p)->lpVtbl->GetMetrics(p, a)
#define IDWriteTextLayout_GetOverhangMetrics(p, a) (p)->lpVtbl->GetOverhangMetrics(p, a)
#define IDWriteTextLayout_GetClusterMetrics(p, a, b, c) (p)->lpVtbl->GetClusterMetrics(p, a, b, c)
#define IDWriteTextLayout_DetermineMinWidth(p, a) (p)->lpVtbl->DetermineMinWidth(p, a)
#define IDWriteTextLayout_HitTestPoint(p, a, b, c, d, e) (p)->lpVtbl->HitTestPoint(p, a, b, c, d, e)
#define IDWriteTextLayout_HitTestTextPosition(p, a, b, c, d, e) (p)->lpVtbl->HitTestTextPosition(p, a, b, c, d, e)
#define IDWriteTextLayout_HitTestTextRange(p, a, b, c, d, e, f, g) (p)->lpVtbl->HitTestTextRange(p, a, b, c, d, e, f, g)

' ============================================================================
' IDWriteTypography
' ============================================================================
Type IDWriteTypographyVtbl As IDWriteTypographyVtbl_
Type IDWriteTypography
    lpVtbl As IDWriteTypographyVtbl Ptr
End Type
Type IDWriteTypographyVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteTypography Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteTypography Ptr) As ULong
    Release As Function(ByVal This As IDWriteTypography Ptr) As ULong

        
    AddFontFeature As Function(ByVal This As IDWriteTypography Ptr,  ByVal fontFeature As DWRITE_FONT_FEATURE ) As HRESULT
        ' 5. GetFontFeatureCount
    GetFontFeatureCount As Function(ByVal This As IDWriteTypography Ptr) As ULong
        ' 6. GetFontFeature
    GetFontFeature As Function(ByVal This As IDWriteTypography Ptr,  ByVal fontFeatureIndex As ULong, ByVal fontFeature As DWRITE_FONT_FEATURE Ptr ) As HRESULT
End Type
#define IDWriteTypography_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteTypography_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteTypography_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteTypography_AddFontFeature(p, a) (p)->lpVtbl->AddFontFeature(p, a)
#define IDWriteTypography_GetFontFeatureCount(p, a) (p)->lpVtbl->GetFontFeatureCount(p, a)
#define IDWriteTypography_GetFontFeature(p, a, b) (p)->lpVtbl->GetFontFeature(p, a, b)

' ============================================================================
' IDWriteNumberSubstitution
' ============================================================================
Type IDWriteNumberSubstitution Extends IUnknownBase
    ' (No additional methods - marker interface)
End Type
' ==============================
' IDWriteTextAnalysisSource
' ==============================
Type IDWriteTextAnalysisSourceVtbl As IDWriteTextAnalysisSourceVtbl_
Type IDWriteTextAnalysisSource
    lpVtbl As IDWriteTextAnalysisSourceVtbl Ptr
End Type
Type IDWriteTextAnalysisSourceVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteTextAnalysisSource Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteTextAnalysisSource Ptr) As ULong
    Release As Function(ByVal This As IDWriteTextAnalysisSource Ptr) As ULong

        ' --- IUnknown (1-3) ---
        ' 2. AddRef
        ' 4.
    GetTextAtPosition As Function(ByVal This As IDWriteTextAnalysisSource Ptr, ByVal textPosition As ULong, ByRef textString As WString Ptr, ByRef textLength As ULong) As HRESULT
    GetTextBeforePosition As Function(ByVal This As IDWriteTextAnalysisSource Ptr, ByVal textPosition As ULong, ByRef textString As WString Ptr, ByRef textLength As ULong) As HRESULT
    GetParagraphReadingDirection As Function(ByVal This As IDWriteTextAnalysisSource Ptr) As DWRITE_READING_DIRECTION
    GetLocaleName As Function(ByVal This As IDWriteTextAnalysisSource Ptr, ByVal textPosition As ULong, ByRef textLength As ULong, ByRef localeName As WString Ptr) As HRESULT
        ' Liefert die NumberSubstitution-Regeln für einen Textbereich.    GetNumberSubstitution As Function(ByVal This As IDWriteTextAnalysisSource Ptr, ByVal textPosition As ULong, ByRef textLength As ULong, ByRef numberSubstitution As IDWriteNumberSubstitution Ptr) As HRESULT
End Type
#define IDWriteTextAnalysisSource_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteTextAnalysisSource_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteTextAnalysisSource_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteTextAnalysisSource_GetTextAtPosition(p, a, b, c) (p)->lpVtbl->GetTextAtPosition(p, a, b, c)
#define IDWriteTextAnalysisSource_GetTextBeforePosition(p, a, b, c) (p)->lpVtbl->GetTextBeforePosition(p, a, b, c)
#define IDWriteTextAnalysisSource_GetParagraphReadingDirection(p, a) (p)->lpVtbl->GetParagraphReadingDirection(p, a)
#define IDWriteTextAnalysisSource_GetLocaleName(p, a, b, c) (p)->lpVtbl->GetLocaleName(p, a, b, c)
#define IDWriteTextAnalysisSource_GetNumberSubstitution(p, a, b, c) (p)->lpVtbl->GetNumberSubstitution(p, a, b, c)

' ==============================
' IDWriteTextAnalysisSink
' ==============================
Type IDWriteTextAnalysisSinkVtbl As IDWriteTextAnalysisSinkVtbl_
Type IDWriteTextAnalysisSink
    lpVtbl As IDWriteTextAnalysisSinkVtbl Ptr
End Type
Type IDWriteTextAnalysisSinkVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteTextAnalysisSink Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteTextAnalysisSink Ptr) As ULong
    Release As Function(ByVal This As IDWriteTextAnalysisSink Ptr) As ULong

        ' --- IUnknown (1-3) ---
        ' 2. AddRef
        ' 4.
    SetScriptAnalysis As Function(ByVal This As IDWriteTextAnalysisSink Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS Ptr) As HRESULT
    SetLineBreakpoints As Function(ByVal This As IDWriteTextAnalysisSink Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal lineBreakpoints As DWRITE_LINE_BREAKPOINT Ptr) As HRESULT
    SetBidiLevel As Function(ByVal This As IDWriteTextAnalysisSink Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal explicitLevel As UByte, ByVal resolvedLevel As UByte) As HRESULT
    SetNumberSubstitution As Function(ByVal This As IDWriteTextAnalysisSink Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal numberSubstitution As IDWriteNumberSubstitution Ptr) As HRESULT
    SetGlyphOrientation As Function(ByVal This As IDWriteTextAnalysisSink Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal glyphOrientation As DWRITE_VERTICAL_GLYPH_ORIENTATION, ByVal bidiLevel As UByte, ByVal isSideways As Long, ByVal isRightToLeft As Long) As HRESULT
End Type
#define IDWriteTextAnalysisSink_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteTextAnalysisSink_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteTextAnalysisSink_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteTextAnalysisSink_SetScriptAnalysis(p, a, b, c) (p)->lpVtbl->SetScriptAnalysis(p, a, b, c)
#define IDWriteTextAnalysisSink_SetLineBreakpoints(p, a, b, c) (p)->lpVtbl->SetLineBreakpoints(p, a, b, c)
#define IDWriteTextAnalysisSink_SetBidiLevel(p, a, b, c, d) (p)->lpVtbl->SetBidiLevel(p, a, b, c, d)
#define IDWriteTextAnalysisSink_SetNumberSubstitution(p, a, b, c) (p)->lpVtbl->SetNumberSubstitution(p, a, b, c)
#define IDWriteTextAnalysisSink_SetGlyphOrientation(p, a, b, c, d, e, f) (p)->lpVtbl->SetGlyphOrientation(p, a, b, c, d, e, f)

' ==============================
' IDWriteTextAnalyzer
' ==============================
Type IDWriteTextAnalyzerVtbl As IDWriteTextAnalyzerVtbl_
Type IDWriteTextAnalyzer
    lpVtbl As IDWriteTextAnalyzerVtbl Ptr
End Type
Type IDWriteTextAnalyzerVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteTextAnalyzer Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteTextAnalyzer Ptr) As ULong
    Release As Function(ByVal This As IDWriteTextAnalyzer Ptr) As ULong

        ' --- IUnknown (1-3) ---
        ' 2. AddRef
        ' 4.
    AnalyzeScript As Function(ByVal This As IDWriteTextAnalyzer Ptr, ByVal analysisSource As IDWriteTextAnalysisSource Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal analysisSink As IDWriteTextAnalysisSink Ptr) As HRESULT
    AnalyzeBidi As Function(ByVal This As IDWriteTextAnalyzer Ptr, ByVal analysisSource As IDWriteTextAnalysisSource Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal analysisSink As IDWriteTextAnalysisSink Ptr) As HRESULT
    AnalyzeNumberSubstitution As Function(ByVal This As IDWriteTextAnalyzer Ptr, ByVal analysisSource As IDWriteTextAnalysisSource Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal analysisSink As IDWriteTextAnalysisSink Ptr) As HRESULT
    AnalyzeLineBreakpoints As Function(ByVal This As IDWriteTextAnalyzer Ptr, ByVal analysisSource As IDWriteTextAnalysisSource Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal analysisSink As IDWriteTextAnalysisSink Ptr) As HRESULT
        ' Weist den Glyphen die korrekten OpenType-Features zu (Shaping).
    GetGlyphs As Function(ByVal This As IDWriteTextAnalyzer Ptr, ByVal textString As WString Ptr, ByVal textLength As ULong, ByVal fontFace As IDWriteFontFace Ptr, ByVal isSideways As Long, ByVal isRightToLeft As Long, ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS Ptr, ByVal localeName As WString Ptr, ByVal numberSubstitution As IDWriteNumberSubstitution Ptr, ByVal features As DWRITE_TYPOGRAPHIC_FEATURES Ptr Ptr, ByVal featureRangeLengths As ULong Ptr, ByVal featureRanges As ULong, ByVal maxGlyphCount As ULong, ByRef clusters As UShort Ptr, ByRef textProps As DWRITE_SHAPING_TEXT_PROPERTIES Ptr, ByRef glyphIndices As UShort Ptr, ByRef glyphProps As DWRITE_SHAPING_GLYPH_PROPERTIES Ptr, ByRef actualGlyphCount As ULong) As HRESULT
        ' Ermittelt die Platzierung der Glyphen (Advances und Offsets).
    GetGlyphPlacements As Function(ByVal This As IDWriteTextAnalyzer Ptr, ByVal textString As WString Ptr, ByVal clusters As UShort Ptr, ByRef textProps As DWRITE_SHAPING_TEXT_PROPERTIES Ptr, ByVal textLength As ULong, ByVal glyphIndices As UShort Ptr, ByRef glyphProps As DWRITE_SHAPING_GLYPH_PROPERTIES Ptr, ByVal glyphCount As ULong, ByVal fontFace As IDWriteFontFace Ptr, ByVal fontEmSize As Single, ByVal isSideways As Long, ByVal isRightToLeft As Long, ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS Ptr, ByVal localeName As WString Ptr, ByVal features As DWRITE_TYPOGRAPHIC_FEATURES Ptr Ptr, ByVal featureRangeLengths As ULong Ptr, ByVal featureRanges As ULong, ByRef glyphAdvances As Single Ptr, ByRef glyphOffsets As DWRITE_GLYPH_OFFSET Ptr) As HRESULT
        ' Platziert Glyphen so, dass sie exakt mit dem GDI-Raster übereinstimmen.    GetGdiCompatibleGlyphPlacements As Function(ByVal This As IDWriteTextAnalyzer Ptr, ByVal textString As WString Ptr, ByVal clusters As UShort Ptr, ByRef textProps As DWRITE_SHAPING_TEXT_PROPERTIES Ptr, ByVal textLength As ULong, ByVal glyphIndices As UShort Ptr, ByRef glyphProps As DWRITE_SHAPING_GLYPH_PROPERTIES Ptr, ByVal glyphCount As ULong, ByVal fontFace As IDWriteFontFace Ptr, ByVal fontEmSize As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal useGdiNatural As Long, ByVal isSideways As Long, ByVal isRightToLeft As Long, ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS Ptr, ByVal localeName As WString Ptr, ByVal features As DWRITE_TYPOGRAPHIC_FEATURES Ptr Ptr, ByVal featureRangeLengths As ULong Ptr, ByVal featureRanges As ULong, ByRef glyphAdvances As Single Ptr, ByRef glyphOffsets As DWRITE_GLYPH_OFFSET Ptr) As HRESULT
End Type
#define IDWriteTextAnalyzer_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteTextAnalyzer_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteTextAnalyzer_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteTextAnalyzer_AnalyzeScript(p, a, b, c, d) (p)->lpVtbl->AnalyzeScript(p, a, b, c, d)
#define IDWriteTextAnalyzer_AnalyzeBidi(p, a, b, c, d) (p)->lpVtbl->AnalyzeBidi(p, a, b, c, d)
#define IDWriteTextAnalyzer_AnalyzeNumberSubstitution(p, a, b, c, d) (p)->lpVtbl->AnalyzeNumberSubstitution(p, a, b, c, d)
#define IDWriteTextAnalyzer_AnalyzeLineBreakpoints(p, a, b, c, d) (p)->lpVtbl->AnalyzeLineBreakpoints(p, a, b, c, d)
#define IDWriteTextAnalyzer_GetGlyphs(p, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, q, r) (p)->lpVtbl->GetGlyphs(p, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, q, r)
#define IDWriteTextAnalyzer_GetGlyphPlacements(p, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, q, r, s) (p)->lpVtbl->GetGlyphPlacements(p, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, q, r, s)
#define IDWriteTextAnalyzer_GetGdiCompatibleGlyphPlacements(p, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, q, r, s, t, u, v) (p)->lpVtbl->GetGdiCompatibleGlyphPlacements(p, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, q, r, s, t, u, v)

' ============================================================================
' IDWriteGdiInterop
' ============================================================================
Type IDWriteGdiInteropVtbl As IDWriteGdiInteropVtbl_
Type IDWriteGdiInterop
    lpVtbl As IDWriteGdiInteropVtbl Ptr
End Type
Type IDWriteGdiInteropVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteGdiInterop Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteGdiInterop Ptr) As ULong
    Release As Function(ByVal This As IDWriteGdiInterop Ptr) As ULong

        
    CreateFontFromLOGFONT As Function(ByVal This As IDWriteGdiInterop Ptr,  ByVal logFont As LOGFONTW Ptr, ByVal font As Any Ptr Ptr ) As HRESULT
        ' 5. ConvertFontToLOGFONT
    ConvertFontToLOGFONT As Function(ByVal This As IDWriteGdiInterop Ptr,  ByVal font As Any Ptr, ByVal logFont As LOGFONTW Ptr, ByVal isSystemFont As Long Ptr ) As HRESULT
        ' 6. ConvertFontFaceToLOGFONT
    ConvertFontFaceToLOGFONT As Function(ByVal This As IDWriteGdiInterop Ptr,  ByVal font As Any Ptr, ByVal logFont As LOGFONTW Ptr ) As HRESULT
        ' 7. CreateFontFaceFromHdc
    CreateFontFaceFromHdc As Function(ByVal This As IDWriteGdiInterop Ptr,  ByVal hdc As HDC, ByVal fontFace As Any Ptr Ptr ) As HRESULT
        ' 8. CreateBitmapRenderTarget
    CreateBitmapRenderTarget As Function(ByVal This As IDWriteGdiInterop Ptr,  ByVal hdc As HDC, ByVal width As ULong, ByVal height As ULong, ByVal renderTarget As Any Ptr Ptr ) As HRESULT
End Type
#define IDWriteGdiInterop_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteGdiInterop_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteGdiInterop_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteGdiInterop_CreateFontFromLOGFONT(p, a, b) (p)->lpVtbl->CreateFontFromLOGFONT(p, a, b)
#define IDWriteGdiInterop_ConvertFontToLOGFONT(p, a, b, c) (p)->lpVtbl->ConvertFontToLOGFONT(p, a, b, c)
#define IDWriteGdiInterop_ConvertFontFaceToLOGFONT(p, a, b) (p)->lpVtbl->ConvertFontFaceToLOGFONT(p, a, b)
#define IDWriteGdiInterop_CreateFontFaceFromHdc(p, a, b) (p)->lpVtbl->CreateFontFaceFromHdc(p, a, b)
#define IDWriteGdiInterop_CreateBitmapRenderTarget(p, a, b, c, d) (p)->lpVtbl->CreateBitmapRenderTarget(p, a, b, c, d)

' ============================================================================
' IDWriteBitmapRenderTarget
' ============================================================================
Type IDWriteBitmapRenderTargetVtbl As IDWriteBitmapRenderTargetVtbl_
Type IDWriteBitmapRenderTarget
    lpVtbl As IDWriteBitmapRenderTargetVtbl Ptr
End Type
Type IDWriteBitmapRenderTargetVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteBitmapRenderTarget Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteBitmapRenderTarget Ptr) As ULong
    Release As Function(ByVal This As IDWriteBitmapRenderTarget Ptr) As ULong

        
    DrawGlyphRun As Function(ByVal This As IDWriteBitmapRenderTarget Ptr,  ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal renderingParams As Any Ptr, ByVal textColor As COLORREF, ByVal blackBoxRect As RECT Ptr = 0 ) As HRESULT
        ' 5. GetMemoryDC
    GetMemoryDC As Function(ByVal This As IDWriteBitmapRenderTarget Ptr) As HDC
        ' 6. GetPixelsPerDip
    GetPixelsPerDip As Function(ByVal This As IDWriteBitmapRenderTarget Ptr) As Single
        ' 7. SetPixelsPerDip
    SetPixelsPerDip As Function(ByVal This As IDWriteBitmapRenderTarget Ptr,  ByVal pixelsPerDip As Single ) As HRESULT
        ' 8. GetCurrentTransform
    GetCurrentTransform As Function(ByVal This As IDWriteBitmapRenderTarget Ptr,  ByVal transform As DWRITE_MATRIX Ptr ) As HRESULT
        ' 9. SetCurrentTransform
    SetCurrentTransform As Function(ByVal This As IDWriteBitmapRenderTarget Ptr,  ByVal transform As DWRITE_MATRIX Ptr ) As HRESULT
        ' 10. GetSize
    GetSize As Function(ByVal This As IDWriteBitmapRenderTarget Ptr,  ByVal size As SIZE Ptr ) As HRESULT
        ' 11. Resize
    Resize As Function(ByVal This As IDWriteBitmapRenderTarget Ptr,  ByVal width As ULong, ByVal height As ULong ) As HRESULT
End Type
#define IDWriteBitmapRenderTarget_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteBitmapRenderTarget_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteBitmapRenderTarget_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteBitmapRenderTarget_DrawGlyphRun(p, a, b, c, d, e, f, g) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d, e, f, g)
#define IDWriteBitmapRenderTarget_GetMemoryDC(p, a) (p)->lpVtbl->GetMemoryDC(p, a)
#define IDWriteBitmapRenderTarget_GetPixelsPerDip(p, a) (p)->lpVtbl->GetPixelsPerDip(p, a)
#define IDWriteBitmapRenderTarget_SetPixelsPerDip(p, a) (p)->lpVtbl->SetPixelsPerDip(p, a)
#define IDWriteBitmapRenderTarget_GetCurrentTransform(p, a) (p)->lpVtbl->GetCurrentTransform(p, a)
#define IDWriteBitmapRenderTarget_SetCurrentTransform(p, a) (p)->lpVtbl->SetCurrentTransform(p, a)
#define IDWriteBitmapRenderTarget_GetSize(p, a) (p)->lpVtbl->GetSize(p, a)
#define IDWriteBitmapRenderTarget_Resize(p, a, b) (p)->lpVtbl->Resize(p, a, b)

' ============================================================================
' IDWriteGlyphRunAnalysis
' ============================================================================
Type IDWriteGlyphRunAnalysisVtbl As IDWriteGlyphRunAnalysisVtbl_
Type IDWriteGlyphRunAnalysis
    lpVtbl As IDWriteGlyphRunAnalysisVtbl Ptr
End Type
Type IDWriteGlyphRunAnalysisVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteGlyphRunAnalysis Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteGlyphRunAnalysis Ptr) As ULong
    Release As Function(ByVal This As IDWriteGlyphRunAnalysis Ptr) As ULong

        
    GetAlphaTextureBounds As Function(ByVal This As IDWriteGlyphRunAnalysis Ptr,  ByVal textureType As DWRITE_TEXTURE_TYPE, ByVal textureBounds As RECT Ptr ) As HRESULT
        ' 5. CreateAlphaTexture
    CreateAlphaTexture As Function(ByVal This As IDWriteGlyphRunAnalysis Ptr,  ByVal textureType As DWRITE_TEXTURE_TYPE, ByVal textureBounds As RECT Ptr, ByVal alphaValues As Byte Ptr, ByVal bufferSize As ULong ) As HRESULT
        ' 6. GetAlphaBlendParams
    GetAlphaBlendParams As Function(ByVal This As IDWriteGlyphRunAnalysis Ptr,  ByVal renderingParams As Any Ptr, ByVal blendGamma As Single Ptr, ByVal blendEnhancedContrast As Single Ptr, ByVal blendClearTypeLevel As Single Ptr ) As HRESULT
End Type
#define IDWriteGlyphRunAnalysis_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteGlyphRunAnalysis_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteGlyphRunAnalysis_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteGlyphRunAnalysis_GetAlphaTextureBounds(p, a, b) (p)->lpVtbl->GetAlphaTextureBounds(p, a, b)
#define IDWriteGlyphRunAnalysis_CreateAlphaTexture(p, a, b, c, d) (p)->lpVtbl->CreateAlphaTexture(p, a, b, c, d)
#define IDWriteGlyphRunAnalysis_GetAlphaBlendParams(p, a, b, c, d) (p)->lpVtbl->GetAlphaBlendParams(p, a, b, c, d)

' ============================================================================
' IDWriteFactory
' ============================================================================
Type IDWriteFactoryVtbl As IDWriteFactoryVtbl_
Type IDWriteFactory
    lpVtbl As IDWriteFactoryVtbl Ptr
End Type
Type IDWriteFactoryVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As IDWriteFactory Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFactory Ptr) As ULong
    Release As Function(ByVal This As IDWriteFactory Ptr) As ULong
        
    GetSystemFontCollection As Function(ByVal This As IDWriteFactory Ptr,  ByVal fontCollection As Any Ptr Ptr, ByVal checkForUpdates As Long = 0 ) As HRESULT
        ' 5. CreateCustomFontCollection
    CreateCustomFontCollection As Function(ByVal This As IDWriteFactory Ptr,  ByVal collectionLoader As Any Ptr, ByVal collectionKey As Any Ptr, ByVal collectionKeySize As ULong, ByVal fontCollection As Any Ptr Ptr ) As HRESULT
        ' 6. RegisterFontCollectionLoader
    RegisterFontCollectionLoader As Function(ByVal This As IDWriteFactory Ptr,  ByVal fontCollectionLoader As Any Ptr ) As HRESULT
        ' 7. UnregisterFontCollectionLoader
    UnregisterFontCollectionLoader As Function(ByVal This As IDWriteFactory Ptr,  ByVal fontCollectionLoader As Any Ptr ) As HRESULT
        ' 8. CreateFontFileReference
    CreateFontFileReference As Function(ByVal This As IDWriteFactory Ptr,  ByVal filePath As WString Ptr, ByVal lastWriteTime As FILETIME Ptr, ByVal fontFile As Any Ptr Ptr ) As HRESULT
        ' 9. CreateCustomFontFileReference
    CreateCustomFontFileReference As Function(ByVal This As IDWriteFactory Ptr,  ByVal fontFileReferenceKey As Any Ptr, ByVal fontFileReferenceKeySize As ULong, ByVal fontFileLoader As Any Ptr, ByVal fontFile As Any Ptr Ptr ) As HRESULT
        ' 10. CreateFontFace
    CreateFontFace As Function(ByVal This As IDWriteFactory Ptr,  ByVal fontFaceType As DWRITE_FONT_FACE_TYPE, ByVal numberOfFiles As ULong, ByVal fontFiles As Any Ptr Ptr, ByVal faceIndex As ULong, ByVal fontFaceSimulationFlags As DWRITE_FONT_SIMULATIONS, ByVal fontFace As Any Ptr Ptr ) As HRESULT
        ' 11. CreateRenderingParams
    CreateRenderingParams As Function(ByVal This As IDWriteFactory Ptr,  ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 12. CreateMonitorRenderingParams
    CreateMonitorRenderingParams As Function(ByVal This As IDWriteFactory Ptr,  ByVal monitor As HMONITOR, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 13. CreateCustomRenderingParams
    CreateCustomRenderingParams As Function(ByVal This As IDWriteFactory Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 14. RegisterFontFileLoader
    RegisterFontFileLoader As Function(ByVal This As IDWriteFactory Ptr,  ByVal fontFileLoader As Any Ptr ) As HRESULT
        ' 15. UnregisterFontFileLoader
    UnregisterFontFileLoader As Function(ByVal This As IDWriteFactory Ptr,  ByVal fontFileLoader As Any Ptr ) As HRESULT
        ' 16. CreateTextFormat
    CreateTextFormat As Function(ByVal This As IDWriteFactory Ptr,  ByVal fontFamilyName As WString Ptr, ByVal fontCollection As Any Ptr, ByVal fontWeight As DWRITE_FONT_WEIGHT, ByVal fontStyle As DWRITE_FONT_STYLE, ByVal fontStretch As DWRITE_FONT_STRETCH, ByVal fontSize As Single, ByVal localeName As WString Ptr, ByVal textFormat As IDWriteTextFormat Ptr Ptr ) As HRESULT
        ' 17. CreateTypography
    CreateTypography As Function(ByVal This As IDWriteFactory Ptr,  ByVal typography As Any Ptr Ptr ) As HRESULT
        ' 18. GetGdiInterop
    GetGdiInterop As Function(ByVal This As IDWriteFactory Ptr,  ByVal gdiInterop As Any Ptr Ptr ) As HRESULT
        ' 19. CreateTextLayout
    CreateTextLayout As Function(ByVal This As IDWriteFactory Ptr,  ByVal string As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal maxWidth As Single, ByVal maxHeight As Single, ByVal textLayout As Any Ptr Ptr ) As HRESULT
        ' 20. CreateGdiCompatibleTextLayout
    CreateGdiCompatibleTextLayout As Function(ByVal This As IDWriteFactory Ptr,  ByVal string As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal layoutWidth As Single, ByVal layoutHeight As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal useGdiNatural As Long, ByVal textLayout As Any Ptr Ptr ) As HRESULT
        ' 21. CreateEllipsisTrimmingSign
    CreateEllipsisTrimmingSign As Function(ByVal This As IDWriteFactory Ptr,  ByVal textFormat As Any Ptr, ByVal trimmingSign As Any Ptr Ptr ) As HRESULT
        ' 22. CreateTextAnalyzer
    CreateTextAnalyzer As Function(ByVal This As IDWriteFactory Ptr,  ByVal textAnalyzer As Any Ptr Ptr ) As HRESULT
        ' 23. CreateNumberSubstitution
    CreateNumberSubstitution As Function(ByVal This As IDWriteFactory Ptr,  ByVal substitutionMethod As DWRITE_NUMBER_SUBSTITUTION_METHOD, ByVal localeName As WString Ptr, ByVal ignoreUserOverride As Long, ByVal numberSubstitution As Any Ptr Ptr ) As HRESULT
        ' 24. CreateGlyphRunAnalysis
    CreateGlyphRunAnalysis As Function(ByVal This As IDWriteFactory Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRunAnalysis As Any Ptr Ptr ) As HRESULT
End Type
#define IDWriteFactory_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFactory_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFactory_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFactory_GetSystemFontCollection(p, a, b) (p)->lpVtbl->GetSystemFontCollection(p, a, b)
#define IDWriteFactory_CreateCustomFontCollection(p, a, b, c, d) (p)->lpVtbl->CreateCustomFontCollection(p, a, b, c, d)
#define IDWriteFactory_RegisterFontCollectionLoader(p, a) (p)->lpVtbl->RegisterFontCollectionLoader(p, a)
#define IDWriteFactory_UnregisterFontCollectionLoader(p, a) (p)->lpVtbl->UnregisterFontCollectionLoader(p, a)
#define IDWriteFactory_CreateFontFileReference(p, a, b, c) (p)->lpVtbl->CreateFontFileReference(p, a, b, c)
#define IDWriteFactory_CreateCustomFontFileReference(p, a, b, c, d) (p)->lpVtbl->CreateCustomFontFileReference(p, a, b, c, d)
#define IDWriteFactory_CreateFontFace(p, a, b, c, d, e, f) (p)->lpVtbl->CreateFontFace(p, a, b, c, d, e, f)
#define IDWriteFactory_CreateRenderingParams(p, a) (p)->lpVtbl->CreateRenderingParams(p, a)
#define IDWriteFactory_CreateMonitorRenderingParams(p, a, b) (p)->lpVtbl->CreateMonitorRenderingParams(p, a, b)
#define IDWriteFactory_CreateCustomRenderingParams(p, a, b, c, d, e, f) (p)->lpVtbl->CreateCustomRenderingParams(p, a, b, c, d, e, f)
#define IDWriteFactory_RegisterFontFileLoader(p, a) (p)->lpVtbl->RegisterFontFileLoader(p, a)
#define IDWriteFactory_UnregisterFontFileLoader(p, a) (p)->lpVtbl->UnregisterFontFileLoader(p, a)
#define IDWriteFactory_CreateTextFormat(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateTextFormat(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory_CreateTypography(p, a) (p)->lpVtbl->CreateTypography(p, a)
#define IDWriteFactory_GetGdiInterop(p, a) (p)->lpVtbl->GetGdiInterop(p, a)
#define IDWriteFactory_CreateTextLayout(p, a, b, c, d, e, f) (p)->lpVtbl->CreateTextLayout(p, a, b, c, d, e, f)
#define IDWriteFactory_CreateGdiCompatibleTextLayout(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->CreateGdiCompatibleTextLayout(p, a, b, c, d, e, f, g, h, i)
#define IDWriteFactory_CreateEllipsisTrimmingSign(p, a, b) (p)->lpVtbl->CreateEllipsisTrimmingSign(p, a, b)
#define IDWriteFactory_CreateTextAnalyzer(p, a) (p)->lpVtbl->CreateTextAnalyzer(p, a)
#define IDWriteFactory_CreateNumberSubstitution(p, a, b, c, d) (p)->lpVtbl->CreateNumberSubstitution(p, a, b, c, d)
#define IDWriteFactory_CreateGlyphRunAnalysis(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateGlyphRunAnalysis(p, a, b, c, d, e, f, g, h)

