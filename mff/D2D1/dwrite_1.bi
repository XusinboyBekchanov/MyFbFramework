' Based on the C header files Wine project:
' Copyright (C) the Wine project
' Ported to FB by UEZ
' Build 2026-01-04 beta

#pragma once

#include once "dwrite.bi"

' ============================================================================
' DirectWrite 1 - Enumerations
' ============================================================================

' PANOSE Enumerations
Enum DWRITE_PANOSE_FAMILY
    DWRITE_PANOSE_FAMILY_ANY
    DWRITE_PANOSE_FAMILY_NO_FIT
    DWRITE_PANOSE_FAMILY_TEXT_DISPLAY
    DWRITE_PANOSE_FAMILY_SCRIPT
    DWRITE_PANOSE_FAMILY_DECORATIVE
    DWRITE_PANOSE_FAMILY_SYMBOL
    DWRITE_PANOSE_FAMILY_PICTORIAL = DWRITE_PANOSE_FAMILY_SYMBOL
End Enum

Enum DWRITE_PANOSE_SERIF_STYLE
    DWRITE_PANOSE_SERIF_STYLE_ANY
    DWRITE_PANOSE_SERIF_STYLE_NO_FIT
    DWRITE_PANOSE_SERIF_STYLE_COVE
    DWRITE_PANOSE_SERIF_STYLE_OBTUSE_COVE
    DWRITE_PANOSE_SERIF_STYLE_SQUARE_COVE
    DWRITE_PANOSE_SERIF_STYLE_OBTUSE_SQUARE_COVE
    DWRITE_PANOSE_SERIF_STYLE_SQUARE
    DWRITE_PANOSE_SERIF_STYLE_THIN
    DWRITE_PANOSE_SERIF_STYLE_OVAL
    DWRITE_PANOSE_SERIF_STYLE_EXAGGERATED
    DWRITE_PANOSE_SERIF_STYLE_TRIANGLE
    DWRITE_PANOSE_SERIF_STYLE_NORMAL_SANS
    DWRITE_PANOSE_SERIF_STYLE_OBTUSE_SANS
    DWRITE_PANOSE_SERIF_STYLE_PERPENDICULAR_SANS
    DWRITE_PANOSE_SERIF_STYLE_FLARED
    DWRITE_PANOSE_SERIF_STYLE_ROUNDED
    DWRITE_PANOSE_SERIF_STYLE_SCRIPT
    DWRITE_PANOSE_SERIF_STYLE_PERP_SANS = DWRITE_PANOSE_SERIF_STYLE_PERPENDICULAR_SANS
    DWRITE_PANOSE_SERIF_STYLE_BONE = DWRITE_PANOSE_SERIF_STYLE_OVAL
End Enum

Enum DWRITE_PANOSE_WEIGHT
    DWRITE_PANOSE_WEIGHT_ANY
    DWRITE_PANOSE_WEIGHT_NO_FIT
    DWRITE_PANOSE_WEIGHT_VERY_LIGHT
    DWRITE_PANOSE_WEIGHT_LIGHT
    DWRITE_PANOSE_WEIGHT_THIN
    DWRITE_PANOSE_WEIGHT_BOOK
    DWRITE_PANOSE_WEIGHT_MEDIUM
    DWRITE_PANOSE_WEIGHT_DEMI
    DWRITE_PANOSE_WEIGHT_BOLD
    DWRITE_PANOSE_WEIGHT_HEAVY
    DWRITE_PANOSE_WEIGHT_BLACK
    DWRITE_PANOSE_WEIGHT_EXTRA_BLACK
    DWRITE_PANOSE_WEIGHT_NORD = DWRITE_PANOSE_WEIGHT_EXTRA_BLACK
End Enum

Enum DWRITE_PANOSE_PROPORTION
    DWRITE_PANOSE_PROPORTION_ANY
    DWRITE_PANOSE_PROPORTION_NO_FIT
    DWRITE_PANOSE_PROPORTION_OLD_STYLE
    DWRITE_PANOSE_PROPORTION_MODERN
    DWRITE_PANOSE_PROPORTION_EVEN_WIDTH
    DWRITE_PANOSE_PROPORTION_EXPANDED
    DWRITE_PANOSE_PROPORTION_CONDENSED
    DWRITE_PANOSE_PROPORTION_VERY_EXPANDED
    DWRITE_PANOSE_PROPORTION_VERY_CONDENSED
    DWRITE_PANOSE_PROPORTION_MONOSPACED
End Enum

Enum DWRITE_PANOSE_CONTRAST
    DWRITE_PANOSE_CONTRAST_ANY
    DWRITE_PANOSE_CONTRAST_NO_FIT
    DWRITE_PANOSE_CONTRAST_NONE
    DWRITE_PANOSE_CONTRAST_VERY_LOW
    DWRITE_PANOSE_CONTRAST_LOW
    DWRITE_PANOSE_CONTRAST_MEDIUM_LOW
    DWRITE_PANOSE_CONTRAST_MEDIUM
    DWRITE_PANOSE_CONTRAST_MEDIUM_HIGH
    DWRITE_PANOSE_CONTRAST_HIGH
    DWRITE_PANOSE_CONTRAST_VERY_HIGH
    DWRITE_PANOSE_CONTRAST_HORIZONTAL_LOW
    DWRITE_PANOSE_CONTRAST_HORIZONTAL_MEDIUM
    DWRITE_PANOSE_CONTRAST_HORIZONTAL_HIGH
    DWRITE_PANOSE_CONTRAST_BROKEN
End Enum

Enum DWRITE_PANOSE_STROKE_VARIATION
    DWRITE_PANOSE_STROKE_VARIATION_ANY
    DWRITE_PANOSE_STROKE_VARIATION_NO_FIT
    DWRITE_PANOSE_STROKE_VARIATION_NO_VARIATION
    DWRITE_PANOSE_STROKE_VARIATION_GRADUAL_DIAGONAL
    DWRITE_PANOSE_STROKE_VARIATION_GRADUAL_TRANSITIONAL
    DWRITE_PANOSE_STROKE_VARIATION_GRADUAL_VERTICAL
    DWRITE_PANOSE_STROKE_VARIATION_GRADUAL_HORIZONTAL
    DWRITE_PANOSE_STROKE_VARIATION_RAPID_VERTICAL
    DWRITE_PANOSE_STROKE_VARIATION_RAPID_HORIZONTAL
    DWRITE_PANOSE_STROKE_VARIATION_INSTANT_VERTICAL
    DWRITE_PANOSE_STROKE_VARIATION_INSTANT_HORIZONTAL
End Enum

Enum DWRITE_PANOSE_ARM_STYLE
    DWRITE_PANOSE_ARM_STYLE_ANY
    DWRITE_PANOSE_ARM_STYLE_NO_FIT
    DWRITE_PANOSE_ARM_STYLE_STRAIGHT_ARMS_HORIZONTAL
    DWRITE_PANOSE_ARM_STYLE_STRAIGHT_ARMS_WEDGE
    DWRITE_PANOSE_ARM_STYLE_STRAIGHT_ARMS_VERTICAL
    DWRITE_PANOSE_ARM_STYLE_STRAIGHT_ARMS_SINGLE_SERIF
    DWRITE_PANOSE_ARM_STYLE_STRAIGHT_ARMS_DOUBLE_SERIF
    DWRITE_PANOSE_ARM_STYLE_NONSTRAIGHT_ARMS_HORIZONTAL
    DWRITE_PANOSE_ARM_STYLE_NONSTRAIGHT_ARMS_WEDGE
    DWRITE_PANOSE_ARM_STYLE_NONSTRAIGHT_ARMS_VERTICAL
    DWRITE_PANOSE_ARM_STYLE_NONSTRAIGHT_ARMS_SINGLE_SERIF
    DWRITE_PANOSE_ARM_STYLE_NONSTRAIGHT_ARMS_DOUBLE_SERIF
    DWRITE_PANOSE_ARM_STYLE_STRAIGHT_ARMS_HORZ = DWRITE_PANOSE_ARM_STYLE_STRAIGHT_ARMS_HORIZONTAL
    DWRITE_PANOSE_ARM_STYLE_STRAIGHT_ARMS_VERT = DWRITE_PANOSE_ARM_STYLE_STRAIGHT_ARMS_VERTICAL
    DWRITE_PANOSE_ARM_STYLE_BENT_ARMS_HORZ = DWRITE_PANOSE_ARM_STYLE_NONSTRAIGHT_ARMS_HORIZONTAL
    DWRITE_PANOSE_ARM_STYLE_BENT_ARMS_WEDGE = DWRITE_PANOSE_ARM_STYLE_NONSTRAIGHT_ARMS_WEDGE
    DWRITE_PANOSE_ARM_STYLE_BENT_ARMS_VERT = DWRITE_PANOSE_ARM_STYLE_NONSTRAIGHT_ARMS_VERTICAL
    DWRITE_PANOSE_ARM_STYLE_BENT_ARMS_SINGLE_SERIF = DWRITE_PANOSE_ARM_STYLE_NONSTRAIGHT_ARMS_SINGLE_SERIF
    DWRITE_PANOSE_ARM_STYLE_BENT_ARMS_DOUBLE_SERIF = DWRITE_PANOSE_ARM_STYLE_NONSTRAIGHT_ARMS_DOUBLE_SERIF
End Enum

Enum DWRITE_PANOSE_LETTERFORM
    DWRITE_PANOSE_LETTERFORM_ANY
    DWRITE_PANOSE_LETTERFORM_NO_FIT
    DWRITE_PANOSE_LETTERFORM_NORMAL_CONTACT
    DWRITE_PANOSE_LETTERFORM_NORMAL_WEIGHTED
    DWRITE_PANOSE_LETTERFORM_NORMAL_BOXED
    DWRITE_PANOSE_LETTERFORM_NORMAL_FLATTENED
    DWRITE_PANOSE_LETTERFORM_NORMAL_ROUNDED
    DWRITE_PANOSE_LETTERFORM_NORMAL_OFF_CENTER
    DWRITE_PANOSE_LETTERFORM_NORMAL_SQUARE
    DWRITE_PANOSE_LETTERFORM_OBLIQUE_CONTACT
    DWRITE_PANOSE_LETTERFORM_OBLIQUE_WEIGHTED
    DWRITE_PANOSE_LETTERFORM_OBLIQUE_BOXED
    DWRITE_PANOSE_LETTERFORM_OBLIQUE_FLATTENED
    DWRITE_PANOSE_LETTERFORM_OBLIQUE_ROUNDED
    DWRITE_PANOSE_LETTERFORM_OBLIQUE_OFF_CENTER
    DWRITE_PANOSE_LETTERFORM_OBLIQUE_SQUARE
End Enum

Enum DWRITE_PANOSE_MIDLINE
    DWRITE_PANOSE_MIDLINE_ANY
    DWRITE_PANOSE_MIDLINE_NO_FIT
    DWRITE_PANOSE_MIDLINE_STANDARD_TRIMMED
    DWRITE_PANOSE_MIDLINE_STANDARD_POINTED
    DWRITE_PANOSE_MIDLINE_STANDARD_SERIFED
    DWRITE_PANOSE_MIDLINE_HIGH_TRIMMED
    DWRITE_PANOSE_MIDLINE_HIGH_POINTED
    DWRITE_PANOSE_MIDLINE_HIGH_SERIFED
    DWRITE_PANOSE_MIDLINE_CONSTANT_TRIMMED
    DWRITE_PANOSE_MIDLINE_CONSTANT_POINTED
    DWRITE_PANOSE_MIDLINE_CONSTANT_SERIFED
    DWRITE_PANOSE_MIDLINE_LOW_TRIMMED
    DWRITE_PANOSE_MIDLINE_LOW_POINTED
    DWRITE_PANOSE_MIDLINE_LOW_SERIFED
End Enum

Enum DWRITE_PANOSE_XHEIGHT
    DWRITE_PANOSE_XHEIGHT_ANY
    DWRITE_PANOSE_XHEIGHT_NO_FIT
    DWRITE_PANOSE_XHEIGHT_CONSTANT_SMALL
    DWRITE_PANOSE_XHEIGHT_CONSTANT_STANDARD
    DWRITE_PANOSE_XHEIGHT_CONSTANT_LARGE
    DWRITE_PANOSE_XHEIGHT_DUCKING_SMALL
    DWRITE_PANOSE_XHEIGHT_DUCKING_STANDARD
    DWRITE_PANOSE_XHEIGHT_DUCKING_LARGE
    DWRITE_PANOSE_XHEIGHT_CONSTANT_STD = DWRITE_PANOSE_XHEIGHT_CONSTANT_STANDARD
    DWRITE_PANOSE_XHEIGHT_DUCKING_STD = DWRITE_PANOSE_XHEIGHT_DUCKING_STANDARD
End Enum

Enum DWRITE_PANOSE_TOOL_KIND
    DWRITE_PANOSE_TOOL_KIND_ANY
    DWRITE_PANOSE_TOOL_KIND_NO_FIT
    DWRITE_PANOSE_TOOL_KIND_FLAT_NIB
    DWRITE_PANOSE_TOOL_KIND_PRESSURE_POINT
    DWRITE_PANOSE_TOOL_KIND_ENGRAVED
    DWRITE_PANOSE_TOOL_KIND_BALL
    DWRITE_PANOSE_TOOL_KIND_BRUSH
    DWRITE_PANOSE_TOOL_KIND_ROUGH
    DWRITE_PANOSE_TOOL_KIND_FELT_PEN_BRUSH_TIP
    DWRITE_PANOSE_TOOL_KIND_WILD_BRUSH
End Enum

Enum DWRITE_PANOSE_SPACING
    DWRITE_PANOSE_SPACING_ANY
    DWRITE_PANOSE_SPACING_NO_FIT
    DWRITE_PANOSE_SPACING_PROPORTIONAL_SPACED
    DWRITE_PANOSE_SPACING_MONOSPACED
End Enum

Enum DWRITE_PANOSE_ASPECT_RATIO
    DWRITE_PANOSE_ASPECT_RATIO_ANY
    DWRITE_PANOSE_ASPECT_RATIO_NO_FIT
    DWRITE_PANOSE_ASPECT_RATIO_VERY_CONDENSED
    DWRITE_PANOSE_ASPECT_RATIO_CONDENSED
    DWRITE_PANOSE_ASPECT_RATIO_NORMAL
    DWRITE_PANOSE_ASPECT_RATIO_EXPANDED
    DWRITE_PANOSE_ASPECT_RATIO_VERY_EXPANDED
End Enum

Enum DWRITE_PANOSE_SCRIPT_TOPOLOGY
    DWRITE_PANOSE_SCRIPT_TOPOLOGY_ANY
    DWRITE_PANOSE_SCRIPT_TOPOLOGY_NO_FIT
    DWRITE_PANOSE_SCRIPT_TOPOLOGY_ROMAN_DISCONNECTED
    DWRITE_PANOSE_SCRIPT_TOPOLOGY_ROMAN_TRAILING
    DWRITE_PANOSE_SCRIPT_TOPOLOGY_ROMAN_CONNECTED
    DWRITE_PANOSE_SCRIPT_TOPOLOGY_CURSIVE_DISCONNECTED
    DWRITE_PANOSE_SCRIPT_TOPOLOGY_CURSIVE_TRAILING
    DWRITE_PANOSE_SCRIPT_TOPOLOGY_CURSIVE_CONNECTED
    DWRITE_PANOSE_SCRIPT_TOPOLOGY_BLACKLETTER_DISCONNECTED
    DWRITE_PANOSE_SCRIPT_TOPOLOGY_BLACKLETTER_TRAILING
    DWRITE_PANOSE_SCRIPT_TOPOLOGY_BLACKLETTER_CONNECTED
End Enum

Enum DWRITE_PANOSE_SCRIPT_FORM
    DWRITE_PANOSE_SCRIPT_FORM_ANY
    DWRITE_PANOSE_SCRIPT_FORM_NO_FIT
    DWRITE_PANOSE_SCRIPT_FORM_UPRIGHT_NO_WRAPPING
    DWRITE_PANOSE_SCRIPT_FORM_UPRIGHT_SOME_WRAPPING
    DWRITE_PANOSE_SCRIPT_FORM_UPRIGHT_MORE_WRAPPING
    DWRITE_PANOSE_SCRIPT_FORM_UPRIGHT_EXTREME_WRAPPING
    DWRITE_PANOSE_SCRIPT_FORM_OBLIQUE_NO_WRAPPING
    DWRITE_PANOSE_SCRIPT_FORM_OBLIQUE_SOME_WRAPPING
    DWRITE_PANOSE_SCRIPT_FORM_OBLIQUE_MORE_WRAPPING
    DWRITE_PANOSE_SCRIPT_FORM_OBLIQUE_EXTREME_WRAPPING
    DWRITE_PANOSE_SCRIPT_FORM_EXAGGERATED_NO_WRAPPING
    DWRITE_PANOSE_SCRIPT_FORM_EXAGGERATED_SOME_WRAPPING
    DWRITE_PANOSE_SCRIPT_FORM_EXAGGERATED_MORE_WRAPPING
    DWRITE_PANOSE_SCRIPT_FORM_EXAGGERATED_EXTREME_WRAPPING
End Enum

Enum DWRITE_PANOSE_FINIALS
    DWRITE_PANOSE_FINIALS_ANY
    DWRITE_PANOSE_FINIALS_NO_FIT
    DWRITE_PANOSE_FINIALS_NONE_NO_LOOPS
    DWRITE_PANOSE_FINIALS_NONE_CLOSED_LOOPS
    DWRITE_PANOSE_FINIALS_NONE_OPEN_LOOPS
    DWRITE_PANOSE_FINIALS_SHARP_NO_LOOPS
    DWRITE_PANOSE_FINIALS_SHARP_CLOSED_LOOPS
    DWRITE_PANOSE_FINIALS_SHARP_OPEN_LOOPS
    DWRITE_PANOSE_FINIALS_TAPERED_NO_LOOPS
    DWRITE_PANOSE_FINIALS_TAPERED_CLOSED_LOOPS
    DWRITE_PANOSE_FINIALS_TAPERED_OPEN_LOOPS
    DWRITE_PANOSE_FINIALS_ROUND_NO_LOOPS
    DWRITE_PANOSE_FINIALS_ROUND_CLOSED_LOOPS
    DWRITE_PANOSE_FINIALS_ROUND_OPEN_LOOPS
End Enum

Enum DWRITE_PANOSE_XASCENT
    DWRITE_PANOSE_XASCENT_ANY
    DWRITE_PANOSE_XASCENT_NO_FIT
    DWRITE_PANOSE_XASCENT_VERY_LOW
    DWRITE_PANOSE_XASCENT_LOW
    DWRITE_PANOSE_XASCENT_MEDIUM
    DWRITE_PANOSE_XASCENT_HIGH
    DWRITE_PANOSE_XASCENT_VERY_HIGH
End Enum

Enum DWRITE_PANOSE_DECORATIVE_CLASS
    DWRITE_PANOSE_DECORATIVE_CLASS_ANY
    DWRITE_PANOSE_DECORATIVE_CLASS_NO_FIT
    DWRITE_PANOSE_DECORATIVE_CLASS_DERIVATIVE
    DWRITE_PANOSE_DECORATIVE_CLASS_NONSTANDARD_TOPOLOGY
    DWRITE_PANOSE_DECORATIVE_CLASS_NONSTANDARD_ELEMENTS
    DWRITE_PANOSE_DECORATIVE_CLASS_NONSTANDARD_ASPECT
    DWRITE_PANOSE_DECORATIVE_CLASS_INITIALS
    DWRITE_PANOSE_DECORATIVE_CLASS_CARTOON
    DWRITE_PANOSE_DECORATIVE_CLASS_PICTURE_STEMS
    DWRITE_PANOSE_DECORATIVE_CLASS_ORNAMENTED
    DWRITE_PANOSE_DECORATIVE_CLASS_TEXT_AND_BACKGROUND
    DWRITE_PANOSE_DECORATIVE_CLASS_COLLAGE
    DWRITE_PANOSE_DECORATIVE_CLASS_MONTAGE
End Enum

Enum DWRITE_PANOSE_ASPECT
    DWRITE_PANOSE_ASPECT_ANY
    DWRITE_PANOSE_ASPECT_NO_FIT
    DWRITE_PANOSE_ASPECT_SUPER_CONDENSED
    DWRITE_PANOSE_ASPECT_VERY_CONDENSED
    DWRITE_PANOSE_ASPECT_CONDENSED
    DWRITE_PANOSE_ASPECT_NORMAL
    DWRITE_PANOSE_ASPECT_EXTENDED
    DWRITE_PANOSE_ASPECT_VERY_EXTENDED
    DWRITE_PANOSE_ASPECT_SUPER_EXTENDED
    DWRITE_PANOSE_ASPECT_MONOSPACED
End Enum

Enum DWRITE_PANOSE_FILL
    DWRITE_PANOSE_FILL_ANY
    DWRITE_PANOSE_FILL_NO_FIT
    DWRITE_PANOSE_FILL_STANDARD_SOLID_FILL
    DWRITE_PANOSE_FILL_NO_FILL
    DWRITE_PANOSE_FILL_PATTERNED_FILL
    DWRITE_PANOSE_FILL_COMPLEX_FILL
    DWRITE_PANOSE_FILL_SHAPED_FILL
    DWRITE_PANOSE_FILL_DRAWN_DISTRESSED
End Enum

Enum DWRITE_PANOSE_LINING
    DWRITE_PANOSE_LINING_ANY
    DWRITE_PANOSE_LINING_NO_FIT
    DWRITE_PANOSE_LINING_NONE
    DWRITE_PANOSE_LINING_INLINE
    DWRITE_PANOSE_LINING_OUTLINE
    DWRITE_PANOSE_LINING_ENGRAVED
    DWRITE_PANOSE_LINING_SHADOW
    DWRITE_PANOSE_LINING_RELIEF
    DWRITE_PANOSE_LINING_BACKDROP
End Enum

Enum DWRITE_PANOSE_DECORATIVE_TOPOLOGY
    DWRITE_PANOSE_DECORATIVE_TOPOLOGY_ANY
    DWRITE_PANOSE_DECORATIVE_TOPOLOGY_NO_FIT
    DWRITE_PANOSE_DECORATIVE_TOPOLOGY_STANDARD
    DWRITE_PANOSE_DECORATIVE_TOPOLOGY_SQUARE
    DWRITE_PANOSE_DECORATIVE_TOPOLOGY_MULTIPLE_SEGMENT
    DWRITE_PANOSE_DECORATIVE_TOPOLOGY_ART_DECO
    DWRITE_PANOSE_DECORATIVE_TOPOLOGY_UNEVEN_WEIGHTING
    DWRITE_PANOSE_DECORATIVE_TOPOLOGY_DIVERSE_ARMS
    DWRITE_PANOSE_DECORATIVE_TOPOLOGY_DIVERSE_FORMS
    DWRITE_PANOSE_DECORATIVE_TOPOLOGY_LOMBARDIC_FORMS
    DWRITE_PANOSE_DECORATIVE_TOPOLOGY_UPPER_CASE_IN_LOWER_CASE
    DWRITE_PANOSE_DECORATIVE_TOPOLOGY_IMPLIED_TOPOLOGY
    DWRITE_PANOSE_DECORATIVE_TOPOLOGY_HORSESHOE_E_AND_A
    DWRITE_PANOSE_DECORATIVE_TOPOLOGY_CURSIVE
    DWRITE_PANOSE_DECORATIVE_TOPOLOGY_BLACKLETTER
    DWRITE_PANOSE_DECORATIVE_TOPOLOGY_SWASH_VARIANCE
End Enum

Enum DWRITE_PANOSE_CHARACTER_RANGES
    DWRITE_PANOSE_CHARACTER_RANGES_ANY
    DWRITE_PANOSE_CHARACTER_RANGES_NO_FIT
    DWRITE_PANOSE_CHARACTER_RANGES_EXTENDED_COLLECTION
    DWRITE_PANOSE_CHARACTER_RANGES_LITERALS
    DWRITE_PANOSE_CHARACTER_RANGES_NO_LOWER_CASE
    DWRITE_PANOSE_CHARACTER_RANGES_SMALL_CAPS
End Enum

Enum DWRITE_PANOSE_SYMBOL_KIND
    DWRITE_PANOSE_SYMBOL_KIND_ANY
    DWRITE_PANOSE_SYMBOL_KIND_NO_FIT
    DWRITE_PANOSE_SYMBOL_KIND_MONTAGES
    DWRITE_PANOSE_SYMBOL_KIND_PICTURES
    DWRITE_PANOSE_SYMBOL_KIND_SHAPES
    DWRITE_PANOSE_SYMBOL_KIND_SCIENTIFIC
    DWRITE_PANOSE_SYMBOL_KIND_MUSIC
    DWRITE_PANOSE_SYMBOL_KIND_EXPERT
    DWRITE_PANOSE_SYMBOL_KIND_PATTERNS
    DWRITE_PANOSE_SYMBOL_KIND_BOARDERS
    DWRITE_PANOSE_SYMBOL_KIND_ICONS
    DWRITE_PANOSE_SYMBOL_KIND_LOGOS
    DWRITE_PANOSE_SYMBOL_KIND_INDUSTRY_SPECIFIC
End Enum

Enum DWRITE_PANOSE_SYMBOL_ASPECT_RATIO
    DWRITE_PANOSE_SYMBOL_ASPECT_RATIO_ANY
    DWRITE_PANOSE_SYMBOL_ASPECT_RATIO_NO_FIT
    DWRITE_PANOSE_SYMBOL_ASPECT_RATIO_NO_WIDTH
    DWRITE_PANOSE_SYMBOL_ASPECT_RATIO_EXCEPTIONALLY_WIDE
    DWRITE_PANOSE_SYMBOL_ASPECT_RATIO_SUPER_WIDE
    DWRITE_PANOSE_SYMBOL_ASPECT_RATIO_VERY_WIDE
    DWRITE_PANOSE_SYMBOL_ASPECT_RATIO_WIDE
    DWRITE_PANOSE_SYMBOL_ASPECT_RATIO_NORMAL
    DWRITE_PANOSE_SYMBOL_ASPECT_RATIO_NARROW
    DWRITE_PANOSE_SYMBOL_ASPECT_RATIO_VERY_NARROW
End Enum

Enum DWRITE_OUTLINE_THRESHOLD
    DWRITE_OUTLINE_THRESHOLD_ANTIALIASED
    DWRITE_OUTLINE_THRESHOLD_ALIASED
End Enum

Enum DWRITE_BASELINE
    DWRITE_BASELINE_DEFAULT
    DWRITE_BASELINE_ROMAN
    DWRITE_BASELINE_CENTRAL
    DWRITE_BASELINE_MATH
    DWRITE_BASELINE_HANGING
    DWRITE_BASELINE_IDEOGRAPHIC_BOTTOM
    DWRITE_BASELINE_IDEOGRAPHIC_TOP
    DWRITE_BASELINE_MINIMUM
    DWRITE_BASELINE_MAXIMUM
End Enum

'Enum DWRITE_VERTICAL_GLYPH_ORIENTATION
'    DWRITE_VERTICAL_GLYPH_ORIENTATION_DEFAULT
'    DWRITE_VERTICAL_GLYPH_ORIENTATION_STACKED
'End Enum

'Enum DWRITE_GLYPH_ORIENTATION_ANGLE
'    DWRITE_GLYPH_ORIENTATION_ANGLE_0_DEGREES
'    DWRITE_GLYPH_ORIENTATION_ANGLE_90_DEGREES
'    DWRITE_GLYPH_ORIENTATION_ANGLE_180_DEGREES
'    DWRITE_GLYPH_ORIENTATION_ANGLE_270_DEGREES
'End Enum

Enum DWRITE_TEXT_ANTIALIAS_MODE
    DWRITE_TEXT_ANTIALIAS_MODE_CLEARTYPE
    DWRITE_TEXT_ANTIALIAS_MODE_GRAYSCALE
End Enum

' ============================================================================
' DirectWrite 1 - Structures
' ============================================================================

Type DWRITE_FONT_METRICS1
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
    glyphBoxLeft As Short
    glyphBoxTop As Short
    glyphBoxRight As Short
    glyphBoxBottom As Short
    subscriptPositionX As Short
    subscriptPositionY As Short
    subscriptSizeX As Short
    subscriptSizeY As Short
    superscriptPositionX As Short
    superscriptPositionY As Short
    superscriptSizeX As Short
    superscriptSizeY As Short
    hasTypographicMetrics As Long
End Type

Type DWRITE_CARET_METRICS
    slopeRise As Short
    slopeRun As Short
    offset As Short
End Type

Type DWRITE_UNICODE_RANGE
    first As ULong
    last As ULong
End Type

Type DWRITE_SCRIPT_PROPERTIES
    isoScriptCode As ULong
    isoScriptNumber As ULong
    clusterLookahead As ULong
    justificationCharacter As ULong
    As ULong _
        restrictCaretToClusters : 1, _
        usesWordDividers : 1, _
        isDiscreteWriting : 1, _
        isBlockWriting : 1, _
        isDistributedWithinCluster : 1, _
        isConnectedWriting : 1, _
        isCursiveWriting : 1, _
        reserved : 25
End Type

Type DWRITE_JUSTIFICATION_OPPORTUNITY
    expansionMinimum As Single
    expansionMaximum As Single
    compressionMaximum As Single
    As ULong _
        expansionPriority : 8, _
        compressionPriority : 8, _
        allowResidualExpansion : 1, _
        allowResidualCompression : 1, _
        applyToLeadingEdge : 1, _
        applyToTrailingEdge : 1, _
        reserved : 12
End Type

' PANOSE Union
Type DWRITE_PANOSE_TEXT
    familyKind As Byte
    serifStyle As Byte
    weight As Byte
    proportion As Byte
    contrast As Byte
    strokeVariation As Byte
    armStyle As Byte
    letterform As Byte
    midline As Byte
    xHeight As Byte
End Type

Type DWRITE_PANOSE_SCRIPT
    familyKind As Byte
    toolKind As Byte
    weight As Byte
    spacing As Byte
    aspectRatio As Byte
    contrast As Byte
    scriptTopology As Byte
    scriptForm As Byte
    finials As Byte
    xAscent As Byte
End Type

Type DWRITE_PANOSE_DECORATIVE
    familyKind As Byte
    decorativeClass As Byte
    weight As Byte
    aspect As Byte
    contrast As Byte
    serifVariant As Byte
    fill As Byte
    lining As Byte
    decorativeTopology As Byte
    characterRange As Byte
End Type

Type DWRITE_PANOSE_SYMBOL
    familyKind As Byte
    symbolKind As Byte
    weight As Byte
    spacing As Byte
    aspectRatioAndContrast As Byte
    aspectRatio94 As Byte
    aspectRatio119 As Byte
    aspectRatio157 As Byte
    aspectRatio163 As Byte
    aspectRatio211 As Byte
End Type

Union DWRITE_PANOSE
    values(0 To 9) As Byte
    familyKind As Byte
    text As DWRITE_PANOSE_TEXT
    script As DWRITE_PANOSE_SCRIPT
    decorative As DWRITE_PANOSE_DECORATIVE
    symbol As DWRITE_PANOSE_SYMBOL
End Union

' ==============================
' ID2D1DrawingStateBlock
' ==============================
Type ID2D1DrawingStateBlock Extends ID2D1Resource
    ' 5.
    Declare Abstract Sub GetDescription Stdcall (ByVal stateDescription As D2D1_DRAWING_STATE_DESCRIPTION Ptr)
    ' 6.
    Declare Abstract Sub SetDescription Stdcall (ByVal stateDescription As D2D1_DRAWING_STATE_DESCRIPTION Ptr)
    ' 7.
    Declare Abstract Sub SetTextRenderingParams Stdcall (ByVal textRenderingParams As IDWriteRenderingParams Ptr) '
    ' 8.
    Declare Abstract Sub GetTextRenderingParams Stdcall (ByVal textRenderingParams As IDWriteRenderingParams Ptr)
End Type

' ============================================================================
' IDWriteFactory1
' ============================================================================
Type IDWriteFactory1 Extends IDWriteFactory
    ' 1-24: IDWriteFactory
    
    ' 25. GetEudcFontCollection
    Declare Abstract Function GetEudcFontCollection Stdcall ( _
        ByVal collection As Any Ptr Ptr, _
        ByVal checkForUpdates As Long = 0 _
    ) As HRESULT
    
    ' 26. CreateCustomRenderingParams
    Declare Abstract Function CreateCustomRenderingParams Stdcall ( _
        ByVal gamma As Single, _
        ByVal enhancedContrast As Single, _
        ByVal enhancedContrastGrayscale As Single, _
        ByVal clearTypeLevel As Single, _
        ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, _
        ByVal renderingMode As DWRITE_RENDERING_MODE, _
        ByVal renderingParams As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteFontFace1
' ============================================================================
Type IDWriteFontFace1 Extends IDWriteFontFace
    ' 1-18: IDWriteFontFace
    
    ' 19. GetMetrics
    Declare Abstract Sub GetMetrics Stdcall ( _
        ByVal metrics As DWRITE_FONT_METRICS1 Ptr _
    )
    
    ' 20. GetGdiCompatibleMetrics
    Declare Abstract Function GetGdiCompatibleMetrics Stdcall ( _
        ByVal emSize As Single, _
        ByVal pixelsPerDip As Single, _
        ByVal transform As DWRITE_MATRIX Ptr, _
        ByVal metrics As DWRITE_FONT_METRICS1 Ptr _
    ) As HRESULT
    
    ' 21. GetCaretMetrics
    Declare Abstract Sub GetCaretMetrics Stdcall ( _
        ByVal metrics As DWRITE_CARET_METRICS Ptr _
    )
    
    ' 22. GetUnicodeRanges
    Declare Abstract Function GetUnicodeRanges Stdcall ( _
        ByVal maxCount As ULong, _
        ByVal ranges As DWRITE_UNICODE_RANGE Ptr, _
        ByVal count As ULong Ptr _
    ) As HRESULT
    
    ' 23. IsMonospacedFont
    Declare Abstract Function IsMonospacedFont Stdcall () As Long
    
    ' 24. GetDesignGlyphAdvances
    Declare Abstract Function GetDesignGlyphAdvances Stdcall ( _
        ByVal glyphCount As ULong, _
        ByVal glyphIndices As UShort Ptr, _
        ByVal glyphAdvances As Long Ptr, _
        ByVal isSideways As Long = 0 _
    ) As HRESULT
    
    ' 25. GetGdiCompatibleGlyphAdvances
    Declare Abstract Function GetGdiCompatibleGlyphAdvances Stdcall ( _
        ByVal emSize As Single, _
        ByVal pixelsPerDip As Single, _
        ByVal transform As DWRITE_MATRIX Ptr, _
        ByVal useGdiNatural As Long, _
        ByVal isSideways As Long, _
        ByVal glyphCount As ULong, _
        ByVal glyphIndices As UShort Ptr, _
        ByVal glyphAdvances As Long Ptr _
    ) As HRESULT
    
    ' 26. GetKerningPairAdjustments
    Declare Abstract Function GetKerningPairAdjustments Stdcall ( _
        ByVal glyphCount As ULong, _
        ByVal glyphIndices As UShort Ptr, _
        ByVal glyphAdvanceAdjustments As Long Ptr _
    ) As HRESULT
    
    ' 27. HasKerningPairs
    Declare Abstract Function HasKerningPairs Stdcall () As Long
    
    ' 28. GetRecommendedRenderingMode
    Declare Abstract Function GetRecommendedRenderingMode Stdcall ( _
        ByVal fontEmSize As Single, _
        ByVal dpiX As Single, _
        ByVal dpiY As Single, _
        ByVal transform As DWRITE_MATRIX Ptr, _
        ByVal isSideways As Long, _
        ByVal outlineThreshold As DWRITE_OUTLINE_THRESHOLD, _
        ByVal measuringMode As DWRITE_MEASURING_MODE, _
        ByVal renderingMode As DWRITE_RENDERING_MODE Ptr _
    ) As HRESULT
    
    ' 29. GetVerticalGlyphVariants
    Declare Abstract Function GetVerticalGlyphVariants Stdcall ( _
        ByVal glyphCount As ULong, _
        ByVal nominalGlyphIndices As UShort Ptr, _
        ByVal verticalGlyphIndices As UShort Ptr _
    ) As HRESULT
    
    ' 30. HasVerticalGlyphVariants
    Declare Abstract Function HasVerticalGlyphVariants Stdcall () As Long
End Type

' ============================================================================
' IDWriteFont1
' ============================================================================
Type IDWriteFont1 Extends IDWriteFont
    ' 1-14: IDWriteFont
    
    ' 15. GetMetrics
    Declare Abstract Sub GetMetrics Stdcall ( _
        ByVal fontMetrics As DWRITE_FONT_METRICS1 Ptr _
    )
    
    ' 16. GetPanose
    Declare Abstract Sub GetPanose Stdcall ( _
        ByVal panose As DWRITE_PANOSE Ptr _
    )
    
    ' 17. GetUnicodeRanges
    Declare Abstract Function GetUnicodeRanges Stdcall ( _
        ByVal maxCount As ULong, _
        ByVal unicodeRanges As DWRITE_UNICODE_RANGE Ptr, _
        ByVal actualCount As ULong Ptr _
    ) As HRESULT
    
    ' 18. IsMonospacedFont
    Declare Abstract Function IsMonospacedFont Stdcall () As Long
End Type

' ============================================================================
' IDWriteRenderingParams1
' ============================================================================
Type IDWriteRenderingParams1 Extends IDWriteRenderingParams
    ' 1-8: IDWriteRenderingParams
    
    ' 9. GetGrayscaleEnhancedContrast
    Declare Abstract Function GetGrayscaleEnhancedContrast Stdcall () As Single
End Type

' ============================================================================
' IDWriteTextAnalyzer1
' ============================================================================
Type IDWriteTextAnalyzer1 Extends IDWriteTextAnalyzer
    ' 1-N: IDWriteTextAnalyzer (Methods from base interface)
    
    ' ApplyCharacterSpacing
    Declare Abstract Function ApplyCharacterSpacing Stdcall ( _
        ByVal leadingSpacing As Single, _
        ByVal trailingSpacing As Single, _
        ByVal minimumAdvanceWidth As Single, _
        ByVal textLength As ULong, _
        ByVal glyphCount As ULong, _
        ByVal clusterMap As UShort Ptr, _
        ByVal glyphAdvances As Single Ptr, _
        ByVal glyphOffsets As DWRITE_GLYPH_OFFSET Ptr, _
        ByVal glyphProperties As DWRITE_SHAPING_GLYPH_PROPERTIES Ptr, _
        ByVal modifiedGlyphAdvances As Single Ptr, _
        ByVal modifiedGlyphOffsets As DWRITE_GLYPH_OFFSET Ptr _
    ) As HRESULT
    
    ' GetBaseline
    Declare Abstract Function GetBaseline Stdcall ( _
        ByVal fontFace As Any Ptr, _
        ByVal baseline As DWRITE_BASELINE, _
        ByVal isVertical As Long, _
        ByVal isSimulationAllowed As Long, _
        ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS, _
        ByVal localeName As WString Ptr, _
        ByVal baselineCoordinate As Long Ptr, _
        ByVal exists As Long Ptr _
    ) As HRESULT
    
    ' AnalyzeVerticalGlyphOrientation
    Declare Abstract Function AnalyzeVerticalGlyphOrientation Stdcall ( _
        ByVal analysisSource As Any Ptr, _
        ByVal textPosition As ULong, _
        ByVal textLength As ULong, _
        ByVal analysisSink As Any Ptr _
    ) As HRESULT
    
    ' GetGlyphOrientationTransform
    Declare Abstract Function GetGlyphOrientationTransform Stdcall ( _
        ByVal glyphOrientationAngle As DWRITE_GLYPH_ORIENTATION_ANGLE, _
        ByVal isSideways As Long, _
        ByVal transform As DWRITE_MATRIX Ptr _
    ) As HRESULT
    
    ' GetScriptProperties
    Declare Abstract Function GetScriptProperties Stdcall ( _
        ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS, _
        ByVal scriptProperties As DWRITE_SCRIPT_PROPERTIES Ptr _
    ) As HRESULT
    
    ' GetTextComplexity
    Declare Abstract Function GetTextComplexity Stdcall ( _
        ByVal textString As WString Ptr, _
        ByVal textLength As ULong, _
        ByVal fontFace As Any Ptr, _
        ByVal isTextSimple As Long Ptr, _
        ByVal textLengthRead As ULong Ptr, _
        ByVal glyphIndices As UShort Ptr _
    ) As HRESULT
    
    ' GetJustificationOpportunities
    Declare Abstract Function GetJustificationOpportunities Stdcall ( _
        ByVal fontFace As Any Ptr, _
        ByVal fontEmSize As Single, _
        ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS, _
        ByVal textLength As ULong, _
        ByVal glyphCount As ULong, _
        ByVal textString As WString Ptr, _
        ByVal clusterMap As UShort Ptr, _
        ByVal glyphProperties As DWRITE_SHAPING_GLYPH_PROPERTIES Ptr, _
        ByVal justificationOpportunities As DWRITE_JUSTIFICATION_OPPORTUNITY Ptr _
    ) As HRESULT
    
    ' JustifyGlyphAdvances
    Declare Abstract Function JustifyGlyphAdvances Stdcall ( _
        ByVal lineWidth As Single, _
        ByVal glyphCount As ULong, _
        ByVal justificationOpportunities As DWRITE_JUSTIFICATION_OPPORTUNITY Ptr, _
        ByVal glyphAdvances As Single Ptr, _
        ByVal glyphOffsets As DWRITE_GLYPH_OFFSET Ptr, _
        ByVal justifiedGlyphAdvances As Single Ptr, _
        ByVal justifiedGlyphOffsets As DWRITE_GLYPH_OFFSET Ptr _
    ) As HRESULT
    
    ' GetJustifiedGlyphs
    Declare Abstract Function GetJustifiedGlyphs Stdcall ( _
        ByVal fontFace As Any Ptr, _
        ByVal fontEmSize As Single, _
        ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS, _
        ByVal textLength As ULong, _
        ByVal glyphCount As ULong, _
        ByVal maxGlyphCount As ULong, _
        ByVal clusterMap As UShort Ptr, _
        ByVal glyphIndices As UShort Ptr, _
        ByVal glyphAdvances As Single Ptr, _
        ByVal justifiedGlyphAdvances As Single Ptr, _
        ByVal justifiedGlyphOffsets As DWRITE_GLYPH_OFFSET Ptr, _
        ByVal glyphProperties As DWRITE_SHAPING_GLYPH_PROPERTIES Ptr, _
        ByVal actualGlyphCount As ULong Ptr, _
        ByVal modifiedClusterMap As UShort Ptr, _
        ByVal modifiedGlyphIndices As UShort Ptr, _
        ByVal modifiedGlyphAdvances As Single Ptr, _
        ByVal modifiedGlyphOffsets As DWRITE_GLYPH_OFFSET Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteTextAnalysisSource1
' ============================================================================
Type IDWriteTextAnalysisSource1 Extends IDWriteTextAnalysisSource
    ' 1-N: IDWriteTextAnalysisSource
    
    ' GetVerticalGlyphOrientation
    Declare Abstract Function GetVerticalGlyphOrientation Stdcall ( _
        ByVal textPosition As ULong, _
        ByVal textLength As ULong Ptr, _
        ByVal glyphOrientation As DWRITE_VERTICAL_GLYPH_ORIENTATION Ptr, _
        ByVal bidiLevel As Byte Ptr _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteTextAnalysisSink1
' ============================================================================
Type IDWriteTextAnalysisSink1 Extends IDWriteTextAnalysisSink
    ' 1-N: IDWriteTextAnalysisSink
    
    ' SetGlyphOrientation
    Declare Abstract Function SetGlyphOrientation Stdcall ( _
        ByVal textPosition As ULong, _
        ByVal textLength As ULong, _
        ByVal glyphOrientationAngle As DWRITE_GLYPH_ORIENTATION_ANGLE, _
        ByVal adjustedBidiLevel As Byte, _
        ByVal isSideways As Long, _
        ByVal isRightToLeft As Long _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteTextLayout1
' ============================================================================
Type IDWriteTextLayout1 Extends IDWriteTextLayout
    ' 1-67: IDWriteTextLayout
    
    ' 68. SetPairKerning
    Declare Abstract Function SetPairKerning Stdcall ( _
        ByVal isPairKerningEnabled As Long, _
        ByVal textRange As DWRITE_TEXT_RANGE _
    ) As HRESULT
    
    ' 69. GetPairKerning
    Declare Abstract Function GetPairKerning Stdcall ( _
        ByVal currentPosition As ULong, _
        ByVal isPairKerningEnabled As Long Ptr, _
        ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 _
    ) As HRESULT
    
    ' 70. SetCharacterSpacing
    Declare Abstract Function SetCharacterSpacing Stdcall ( _
        ByVal leadingSpacing As Single, _
        ByVal trailingSpacing As Single, _
        ByVal minimumAdvanceWidth As Single, _
        ByVal textRange As DWRITE_TEXT_RANGE _
    ) As HRESULT
    
    ' 71. GetCharacterSpacing
    Declare Abstract Function GetCharacterSpacing Stdcall ( _
        ByVal currentPosition As ULong, _
        ByVal leadingSpacing As Single Ptr, _
        ByVal trailingSpacing As Single Ptr, _
        ByVal minimumAdvanceWidth As Single Ptr, _
        ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 _
    ) As HRESULT
End Type

' ============================================================================
' IDWriteBitmapRenderTarget1
' ============================================================================
Type IDWriteBitmapRenderTarget1 Extends IDWriteBitmapRenderTarget
    ' 1-11: IDWriteBitmapRenderTarget
    
    ' 12. GetTextAntialiasMode
    Declare Abstract Function GetTextAntialiasMode Stdcall () As DWRITE_TEXT_ANTIALIAS_MODE
    
    ' 13. SetTextAntialiasMode
    Declare Abstract Function SetTextAntialiasMode Stdcall ( _
        ByVal antialiasMode As DWRITE_TEXT_ANTIALIAS_MODE _
    ) As HRESULT
End Type