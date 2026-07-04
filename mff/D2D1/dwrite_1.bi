'###############################################################################
' This file is part of MyFBFramework
' Authors: UEZ, Xusinboy Bekchanov, Liu XiaLin
' Based on UEZ's abstract version.
' Direct2D 1.2 API - FreeBASIC Translation
' Adapted by Xusinboy Bekchanov, Liu XiaLin
'###############################################################################

#pragma once
#include once "dwrite.bi"
' ============================================================================
' DirectWrite 1 - Enumerations
' ============================================================================
' PANOSE Enumerations
Type DWRITE_PANOSE_FAMILY As Long
Enum
    DWRITE_PANOSE_FAMILY_ANY
    DWRITE_PANOSE_FAMILY_NO_FIT
    DWRITE_PANOSE_FAMILY_TEXT_DISPLAY
    DWRITE_PANOSE_FAMILY_SCRIPT
    DWRITE_PANOSE_FAMILY_DECORATIVE
    DWRITE_PANOSE_FAMILY_SYMBOL
    DWRITE_PANOSE_FAMILY_PICTORIAL = DWRITE_PANOSE_FAMILY_SYMBOL
End Enum
Type DWRITE_PANOSE_SERIF_STYLE As Long
Enum
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
Type DWRITE_PANOSE_WEIGHT As Long
Enum
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
Type DWRITE_PANOSE_PROPORTION As Long
Enum
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
Type DWRITE_PANOSE_CONTRAST As Long
Enum
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
Type DWRITE_PANOSE_STROKE_VARIATION As Long
Enum
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
Type DWRITE_PANOSE_ARM_STYLE As Long
Enum
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
Type DWRITE_PANOSE_LETTERFORM As Long
Enum
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
Type DWRITE_PANOSE_MIDLINE As Long
Enum
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
Type DWRITE_PANOSE_XHEIGHT As Long
Enum
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
Type DWRITE_PANOSE_TOOL_KIND As Long
Enum
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
Type DWRITE_PANOSE_SPACING As Long
Enum
    DWRITE_PANOSE_SPACING_ANY
    DWRITE_PANOSE_SPACING_NO_FIT
    DWRITE_PANOSE_SPACING_PROPORTIONAL_SPACED
    DWRITE_PANOSE_SPACING_MONOSPACED
End Enum
Type DWRITE_PANOSE_ASPECT_RATIO As Long
Enum
    DWRITE_PANOSE_ASPECT_RATIO_ANY
    DWRITE_PANOSE_ASPECT_RATIO_NO_FIT
    DWRITE_PANOSE_ASPECT_RATIO_VERY_CONDENSED
    DWRITE_PANOSE_ASPECT_RATIO_CONDENSED
    DWRITE_PANOSE_ASPECT_RATIO_NORMAL
    DWRITE_PANOSE_ASPECT_RATIO_EXPANDED
    DWRITE_PANOSE_ASPECT_RATIO_VERY_EXPANDED
End Enum
Type DWRITE_PANOSE_SCRIPT_TOPOLOGY As Long
Enum
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
Type DWRITE_PANOSE_SCRIPT_FORM As Long
Enum
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
Type DWRITE_PANOSE_FINIALS As Long
Enum
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
Type DWRITE_PANOSE_XASCENT As Long
Enum
    DWRITE_PANOSE_XASCENT_ANY
    DWRITE_PANOSE_XASCENT_NO_FIT
    DWRITE_PANOSE_XASCENT_VERY_LOW
    DWRITE_PANOSE_XASCENT_LOW
    DWRITE_PANOSE_XASCENT_MEDIUM
    DWRITE_PANOSE_XASCENT_HIGH
    DWRITE_PANOSE_XASCENT_VERY_HIGH
End Enum
Type DWRITE_PANOSE_DECORATIVE_CLASS As Long
Enum
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
Type DWRITE_PANOSE_ASPECT As Long
Enum
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
Type DWRITE_PANOSE_FILL As Long
Enum
    DWRITE_PANOSE_FILL_ANY
    DWRITE_PANOSE_FILL_NO_FIT
    DWRITE_PANOSE_FILL_STANDARD_SOLID_FILL
    DWRITE_PANOSE_FILL_NO_FILL
    DWRITE_PANOSE_FILL_PATTERNED_FILL
    DWRITE_PANOSE_FILL_COMPLEX_FILL
    DWRITE_PANOSE_FILL_SHAPED_FILL
    DWRITE_PANOSE_FILL_DRAWN_DISTRESSED
End Enum
Type DWRITE_PANOSE_LINING As Long
Enum
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
Type DWRITE_PANOSE_DECORATIVE_TOPOLOGY As Long
Enum
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
Type DWRITE_PANOSE_CHARACTER_RANGES As Long
Enum
    DWRITE_PANOSE_CHARACTER_RANGES_ANY
    DWRITE_PANOSE_CHARACTER_RANGES_NO_FIT
    DWRITE_PANOSE_CHARACTER_RANGES_EXTENDED_COLLECTION
    DWRITE_PANOSE_CHARACTER_RANGES_LITERALS
    DWRITE_PANOSE_CHARACTER_RANGES_NO_LOWER_CASE
    DWRITE_PANOSE_CHARACTER_RANGES_SMALL_CAPS
End Enum
Type DWRITE_PANOSE_SYMBOL_KIND As Long
Enum
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
Type DWRITE_PANOSE_SYMBOL_ASPECT_RATIO As Long
Enum
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
Type DWRITE_OUTLINE_THRESHOLD As Long
Enum
    DWRITE_OUTLINE_THRESHOLD_ANTIALIASED
    DWRITE_OUTLINE_THRESHOLD_ALIASED
End Enum
Type DWRITE_BASELINE As Long
Enum
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
Type DWRITE_TEXT_ANTIALIAS_MODE As Long
Enum
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
As ULong restrictCaretToClusters : 1, usesWordDividers : 1, isDiscreteWriting : 1, isBlockWriting : 1, isDistributedWithinCluster : 1, isConnectedWriting : 1, isCursiveWriting : 1, reserved : 25
End Type
Type DWRITE_JUSTIFICATION_OPPORTUNITY
    expansionMinimum As Single
    expansionMaximum As Single
    compressionMaximum As Single
As ULong expansionPriority : 8, compressionPriority : 8, allowResidualExpansion : 1, allowResidualCompression : 1, applyToLeadingEdge : 1, applyToTrailingEdge : 1, reserved : 12
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
Type ID2D1DrawingStateBlockVtbl As ID2D1DrawingStateBlockVtbl_
Type ID2D1DrawingStateBlock
    lpVtbl As ID2D1DrawingStateBlockVtbl Ptr
End Type
Type ID2D1DrawingStateBlockVtbl_     '' Extends ID2D1ResourceVtbl_
    QueryInterface As Function(ByVal This As ID2D1DrawingStateBlock Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1DrawingStateBlock Ptr) As ULong
    Release As Function(ByVal This As ID2D1DrawingStateBlock Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1DrawingStateBlock Ptr, ByVal factory As Any Ptr Ptr)

    GetDescription As Sub(ByVal This As ID2D1DrawingStateBlock Ptr, ByVal stateDescription As D2D1_DRAWING_STATE_DESCRIPTION Ptr)
    SetDescription As Sub(ByVal This As ID2D1DrawingStateBlock Ptr, ByVal stateDescription As D2D1_DRAWING_STATE_DESCRIPTION Ptr)
    SetTextRenderingParams As Sub(ByVal This As ID2D1DrawingStateBlock Ptr, ByVal textRenderingParams As IDWriteRenderingParams Ptr)
    GetTextRenderingParams As Sub(ByVal This As ID2D1DrawingStateBlock Ptr, ByVal textRenderingParams As IDWriteRenderingParams Ptr)
End Type
#define ID2D1DrawingStateBlock_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1DrawingStateBlock_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1DrawingStateBlock_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1DrawingStateBlock_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1DrawingStateBlock_GetDescription(p, a) (p)->lpVtbl->GetDescription(p, a)
#define ID2D1DrawingStateBlock_SetDescription(p, a) (p)->lpVtbl->SetDescription(p, a)
#define ID2D1DrawingStateBlock_SetTextRenderingParams(p, a) (p)->lpVtbl->SetTextRenderingParams(p, a)
#define ID2D1DrawingStateBlock_GetTextRenderingParams(p, a) (p)->lpVtbl->GetTextRenderingParams(p, a)

' ============================================================================
' IDWriteFactory1
' ============================================================================
Type IDWriteFactory1Vtbl As IDWriteFactory1Vtbl_
Type IDWriteFactory1
    lpVtbl As IDWriteFactory1Vtbl Ptr
End Type
Type IDWriteFactory1Vtbl_     '' Extends IDWriteFactoryVtbl_
    QueryInterface As Function(ByVal This As IDWriteFactory1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFactory1 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFactory1 Ptr) As ULong
        
    GetSystemFontCollection As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal fontCollection As Any Ptr Ptr, ByVal checkForUpdates As Long = 0 ) As HRESULT
        ' 5. CreateCustomFontCollection
    CreateCustomFontCollection As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal collectionLoader As Any Ptr, ByVal collectionKey As Any Ptr, ByVal collectionKeySize As ULong, ByVal fontCollection As Any Ptr Ptr ) As HRESULT
        ' 6. RegisterFontCollectionLoader
    RegisterFontCollectionLoader As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal fontCollectionLoader As Any Ptr ) As HRESULT
        ' 7. UnregisterFontCollectionLoader
    UnregisterFontCollectionLoader As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal fontCollectionLoader As Any Ptr ) As HRESULT
        ' 8. CreateFontFileReference
    CreateFontFileReference As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal filePath As WString Ptr, ByVal lastWriteTime As FILETIME Ptr, ByVal fontFile As Any Ptr Ptr ) As HRESULT
        ' 9. CreateCustomFontFileReference
    CreateCustomFontFileReference As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal fontFileReferenceKey As Any Ptr, ByVal fontFileReferenceKeySize As ULong, ByVal fontFileLoader As Any Ptr, ByVal fontFile As Any Ptr Ptr ) As HRESULT
        ' 10. CreateFontFace
    CreateFontFace As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal fontFaceType As DWRITE_FONT_FACE_TYPE, ByVal numberOfFiles As ULong, ByVal fontFiles As Any Ptr Ptr, ByVal faceIndex As ULong, ByVal fontFaceSimulationFlags As DWRITE_FONT_SIMULATIONS, ByVal fontFace As Any Ptr Ptr ) As HRESULT
        ' 11. CreateRenderingParams
    CreateRenderingParams As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 12. CreateMonitorRenderingParams
    CreateMonitorRenderingParams As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal monitor As HMONITOR, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 13. CreateCustomRenderingParams
    CreateCustomRenderingParams As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
        ' 14. RegisterFontFileLoader
    RegisterFontFileLoader As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal fontFileLoader As Any Ptr ) As HRESULT
        ' 15. UnregisterFontFileLoader
    UnregisterFontFileLoader As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal fontFileLoader As Any Ptr ) As HRESULT
        ' 16. CreateTextFormat
    CreateTextFormat As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal fontFamilyName As WString Ptr, ByVal fontCollection As Any Ptr, ByVal fontWeight As DWRITE_FONT_WEIGHT, ByVal fontStyle As DWRITE_FONT_STYLE, ByVal fontStretch As DWRITE_FONT_STRETCH, ByVal fontSize As Single, ByVal localeName As WString Ptr, ByVal textFormat As IDWriteTextFormat Ptr Ptr ) As HRESULT
        ' 17. CreateTypography
    CreateTypography As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal typography As Any Ptr Ptr ) As HRESULT
        ' 18. GetGdiInterop
    GetGdiInterop As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal gdiInterop As Any Ptr Ptr ) As HRESULT
        ' 19. CreateTextLayout
    CreateTextLayout As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal string As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal maxWidth As Single, ByVal maxHeight As Single, ByVal textLayout As Any Ptr Ptr ) As HRESULT
        ' 20. CreateGdiCompatibleTextLayout
    CreateGdiCompatibleTextLayout As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal string As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal layoutWidth As Single, ByVal layoutHeight As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal useGdiNatural As Long, ByVal textLayout As Any Ptr Ptr ) As HRESULT
        ' 21. CreateEllipsisTrimmingSign
    CreateEllipsisTrimmingSign As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal textFormat As Any Ptr, ByVal trimmingSign As Any Ptr Ptr ) As HRESULT
        ' 22. CreateTextAnalyzer
    CreateTextAnalyzer As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal textAnalyzer As Any Ptr Ptr ) As HRESULT
        ' 23. CreateNumberSubstitution
    CreateNumberSubstitution As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal substitutionMethod As DWRITE_NUMBER_SUBSTITUTION_METHOD, ByVal localeName As WString Ptr, ByVal ignoreUserOverride As Long, ByVal numberSubstitution As Any Ptr Ptr ) As HRESULT
        ' 24. CreateGlyphRunAnalysis
    CreateGlyphRunAnalysis As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal glyphRunAnalysis As Any Ptr Ptr ) As HRESULT

        
    GetEudcFontCollection As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal collection As Any Ptr Ptr, ByVal checkForUpdates As Long = 0 ) As HRESULT
        ' 26. CreateCustomRenderingParams
    CreateCustomRenderingParams1 As Function(ByVal This As IDWriteFactory1 Ptr,  ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal enhancedContrastGrayscale As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As DWRITE_PIXEL_GEOMETRY, ByVal renderingMode As DWRITE_RENDERING_MODE, ByVal renderingParams As Any Ptr Ptr ) As HRESULT
End Type
#define IDWriteFactory1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFactory1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFactory1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFactory1_GetSystemFontCollection(p, a, b) (p)->lpVtbl->GetSystemFontCollection(p, a, b)
#define IDWriteFactory1_CreateCustomFontCollection(p, a, b, c, d) (p)->lpVtbl->CreateCustomFontCollection(p, a, b, c, d)
#define IDWriteFactory1_RegisterFontCollectionLoader(p, a) (p)->lpVtbl->RegisterFontCollectionLoader(p, a)
#define IDWriteFactory1_UnregisterFontCollectionLoader(p, a) (p)->lpVtbl->UnregisterFontCollectionLoader(p, a)
#define IDWriteFactory1_CreateFontFileReference(p, a, b, c) (p)->lpVtbl->CreateFontFileReference(p, a, b, c)
#define IDWriteFactory1_CreateCustomFontFileReference(p, a, b, c, d) (p)->lpVtbl->CreateCustomFontFileReference(p, a, b, c, d)
#define IDWriteFactory1_CreateFontFace(p, a, b, c, d, e, f) (p)->lpVtbl->CreateFontFace(p, a, b, c, d, e, f)
#define IDWriteFactory1_CreateRenderingParams(p, a) (p)->lpVtbl->CreateRenderingParams(p, a)
#define IDWriteFactory1_CreateMonitorRenderingParams(p, a, b) (p)->lpVtbl->CreateMonitorRenderingParams(p, a, b)
#define IDWriteFactory1_CreateCustomRenderingParams(p, a, b, c, d, e, f) (p)->lpVtbl->CreateCustomRenderingParams(p, a, b, c, d, e, f)
#define IDWriteFactory1_RegisterFontFileLoader(p, a) (p)->lpVtbl->RegisterFontFileLoader(p, a)
#define IDWriteFactory1_UnregisterFontFileLoader(p, a) (p)->lpVtbl->UnregisterFontFileLoader(p, a)
#define IDWriteFactory1_CreateTextFormat(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateTextFormat(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory1_CreateTypography(p, a) (p)->lpVtbl->CreateTypography(p, a)
#define IDWriteFactory1_GetGdiInterop(p, a) (p)->lpVtbl->GetGdiInterop(p, a)
#define IDWriteFactory1_CreateTextLayout(p, a, b, c, d, e, f) (p)->lpVtbl->CreateTextLayout(p, a, b, c, d, e, f)
#define IDWriteFactory1_CreateGdiCompatibleTextLayout(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->CreateGdiCompatibleTextLayout(p, a, b, c, d, e, f, g, h, i)
#define IDWriteFactory1_CreateEllipsisTrimmingSign(p, a, b) (p)->lpVtbl->CreateEllipsisTrimmingSign(p, a, b)
#define IDWriteFactory1_CreateTextAnalyzer(p, a) (p)->lpVtbl->CreateTextAnalyzer(p, a)
#define IDWriteFactory1_CreateNumberSubstitution(p, a, b, c, d) (p)->lpVtbl->CreateNumberSubstitution(p, a, b, c, d)
#define IDWriteFactory1_CreateGlyphRunAnalysis(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateGlyphRunAnalysis(p, a, b, c, d, e, f, g, h)
#define IDWriteFactory1_GetEudcFontCollection(p, a, b) (p)->lpVtbl->GetEudcFontCollection(p, a, b)
#define IDWriteFactory1_CreateCustomRenderingParams1(p, a, b, c, d, e, f, g) (p)->lpVtbl->CreateCustomRenderingParams1(p, a, b, c, d, e, f, g)

' ============================================================================
' IDWriteFontFace1
' ============================================================================
Type IDWriteFontFace1Vtbl As IDWriteFontFace1Vtbl_
Type IDWriteFontFace1
    lpVtbl As IDWriteFontFace1Vtbl Ptr
End Type
Type IDWriteFontFace1Vtbl_     '' Extends IDWriteFontFaceVtbl_
    QueryInterface As Function(ByVal This As IDWriteFontFace1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFontFace1 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFontFace1 Ptr) As ULong
        
    GetType As Function(ByVal This As IDWriteFontFace1 Ptr) As DWRITE_FONT_FACE_TYPE
        ' 5. GetFiles
    GetFiles As Function(ByVal This As IDWriteFontFace1 Ptr,  ByVal number_of_files As ULong Ptr, ByVal fontfiles As Any Ptr Ptr ) As HRESULT
        ' 6. GetIndex
    GetIndex As Function(ByVal This As IDWriteFontFace1 Ptr) As ULong
        ' 7. GetSimulations
    GetSimulations As Function(ByVal This As IDWriteFontFace1 Ptr) As DWRITE_FONT_SIMULATIONS
        ' 8. IsSymbolFont
    IsSymbolFont As Function(ByVal This As IDWriteFontFace1 Ptr) As Long
        ' 9. GetMetrics
    GetMetrics As Sub(ByVal This As IDWriteFontFace1 Ptr,  ByVal metrics As DWRITE_FONT_METRICS Ptr )
        ' 10. GetGlyphCount
    GetGlyphCount As Function(ByVal This As IDWriteFontFace1 Ptr) As UShort
        ' 11. GetDesignGlyphMetrics
    GetDesignGlyphMetrics As Function(ByVal This As IDWriteFontFace1 Ptr,  ByVal glyph_indices As UShort Ptr, ByVal glyph_count As ULong, ByVal metrics As DWRITE_GLYPH_METRICS Ptr, ByVal is_sideways As Long ) As HRESULT
        ' 12. GetGlyphIndices
    GetGlyphIndices As Function(ByVal This As IDWriteFontFace1 Ptr,  ByVal codepoints As ULong Ptr, ByVal count As ULong, ByVal glyph_indices As UShort Ptr ) As HRESULT
        ' 13. TryGetFontTable
    TryGetFontTable As Function(ByVal This As IDWriteFontFace1 Ptr,  ByVal table_tag As ULong, ByVal table_data As Any Ptr Ptr, ByVal table_size As ULong Ptr, ByVal context As Any Ptr Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 14. ReleaseFontTable
    ReleaseFontTable As Sub(ByVal This As IDWriteFontFace1 Ptr,  ByVal table_context As Any Ptr )
        ' 15. GetGlyphRunOutline
    GetGlyphRunOutline As Function(ByVal This As IDWriteFontFace1 Ptr,  ByVal emSize As Single, ByVal glyph_indices As UShort Ptr, ByVal glyph_advances As Single Ptr, ByVal glyph_offsets As DWRITE_GLYPH_OFFSET Ptr, ByVal glyph_count As ULong, ByVal is_sideways As Long, ByVal is_rtl As Long, ByVal geometrysink As Any Ptr ) As HRESULT
        ' 16. GetRecommendedRenderingMode
    GetRecommendedRenderingMode As Function(ByVal This As IDWriteFontFace1 Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal mode As DWRITE_MEASURING_MODE, ByVal params As IDWriteRenderingParams Ptr, ByVal rendering_mode As DWRITE_RENDERING_MODE Ptr ) As HRESULT
        ' 17. GetGdiCompatibleMetrics
    GetGdiCompatibleMetrics As Function(ByVal This As IDWriteFontFace1 Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal metrics As DWRITE_FONT_METRICS Ptr ) As HRESULT
        ' 18. GetGdiCompatibleGlyphMetrics
    GetGdiCompatibleGlyphMetrics As Function(ByVal This As IDWriteFontFace1 Ptr,  ByVal emSize As Single, ByVal pixels_per_dip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal use_gdi_natural As Long, ByVal glyph_indices As UShort Ptr, ByVal glyph_count As ULong, ByVal metrics As DWRITE_GLYPH_METRICS Ptr, ByVal is_sideways As Long ) As HRESULT

        
    GetMetrics1 As Sub(ByVal This As IDWriteFontFace1 Ptr,  ByVal metrics As DWRITE_FONT_METRICS1 Ptr )
        ' 20. GetGdiCompatibleMetrics
    GetGdiCompatibleMetrics1 As Function(ByVal This As IDWriteFontFace1 Ptr,  ByVal emSize As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal metrics As DWRITE_FONT_METRICS1 Ptr ) As HRESULT
        ' 21. GetCaretMetrics
    GetCaretMetrics As Sub(ByVal This As IDWriteFontFace1 Ptr,  ByVal metrics As DWRITE_CARET_METRICS Ptr )
        ' 22. GetUnicodeRanges
    GetUnicodeRanges As Function(ByVal This As IDWriteFontFace1 Ptr,  ByVal maxCount As ULong, ByVal ranges As DWRITE_UNICODE_RANGE Ptr, ByVal count As ULong Ptr ) As HRESULT
        ' 23. IsMonospacedFont
    IsMonospacedFont As Function(ByVal This As IDWriteFontFace1 Ptr) As Long
        ' 24. GetDesignGlyphAdvances
    GetDesignGlyphAdvances As Function(ByVal This As IDWriteFontFace1 Ptr,  ByVal glyphCount As ULong, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvances As Long Ptr, ByVal isSideways As Long = 0 ) As HRESULT
        ' 25. GetGdiCompatibleGlyphAdvances
    GetGdiCompatibleGlyphAdvances As Function(ByVal This As IDWriteFontFace1 Ptr,  ByVal emSize As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal useGdiNatural As Long, ByVal isSideways As Long, ByVal glyphCount As ULong, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvances As Long Ptr ) As HRESULT
        ' 26. GetKerningPairAdjustments
    GetKerningPairAdjustments As Function(ByVal This As IDWriteFontFace1 Ptr,  ByVal glyphCount As ULong, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvanceAdjustments As Long Ptr ) As HRESULT
        ' 27. HasKerningPairs
    HasKerningPairs As Function(ByVal This As IDWriteFontFace1 Ptr) As Long
        ' 28. GetRecommendedRenderingMode
    GetRecommendedRenderingMode1 As Function(ByVal This As IDWriteFontFace1 Ptr,  ByVal fontEmSize As Single, ByVal dpiX As Single, ByVal dpiY As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal isSideways As Long, ByVal outlineThreshold As DWRITE_OUTLINE_THRESHOLD, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal renderingMode As DWRITE_RENDERING_MODE Ptr ) As HRESULT
        ' 29. GetVerticalGlyphVariants
    GetVerticalGlyphVariants As Function(ByVal This As IDWriteFontFace1 Ptr,  ByVal glyphCount As ULong, ByVal nominalGlyphIndices As UShort Ptr, ByVal verticalGlyphIndices As UShort Ptr ) As HRESULT
        ' 30. HasVerticalGlyphVariants
    HasVerticalGlyphVariants As Function(ByVal This As IDWriteFontFace1 Ptr) As Long
End Type
#define IDWriteFontFace1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFontFace1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFontFace1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFontFace1_GetType(p, a) (p)->lpVtbl->GetType(p, a)
#define IDWriteFontFace1_GetFiles(p, a, b) (p)->lpVtbl->GetFiles(p, a, b)
#define IDWriteFontFace1_GetIndex(p, a) (p)->lpVtbl->GetIndex(p, a)
#define IDWriteFontFace1_GetSimulations(p, a) (p)->lpVtbl->GetSimulations(p, a)
#define IDWriteFontFace1_IsSymbolFont(p, a) (p)->lpVtbl->IsSymbolFont(p, a)
#define IDWriteFontFace1_GetMetrics(p, a) (p)->lpVtbl->GetMetrics(p, a)
#define IDWriteFontFace1_GetGlyphCount(p, a) (p)->lpVtbl->GetGlyphCount(p, a)
#define IDWriteFontFace1_GetDesignGlyphMetrics(p, a, b, c, d) (p)->lpVtbl->GetDesignGlyphMetrics(p, a, b, c, d)
#define IDWriteFontFace1_GetGlyphIndices(p, a, b, c) (p)->lpVtbl->GetGlyphIndices(p, a, b, c)
#define IDWriteFontFace1_TryGetFontTable(p, a, b, c, d, e) (p)->lpVtbl->TryGetFontTable(p, a, b, c, d, e)
#define IDWriteFontFace1_ReleaseFontTable(p, a) (p)->lpVtbl->ReleaseFontTable(p, a)
#define IDWriteFontFace1_GetGlyphRunOutline(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGlyphRunOutline(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace1_GetRecommendedRenderingMode(p, a, b, c, d, e) (p)->lpVtbl->GetRecommendedRenderingMode(p, a, b, c, d, e)
#define IDWriteFontFace1_GetGdiCompatibleMetrics(p, a, b, c, d) (p)->lpVtbl->GetGdiCompatibleMetrics(p, a, b, c, d)
#define IDWriteFontFace1_GetGdiCompatibleGlyphMetrics(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGdiCompatibleGlyphMetrics(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace1_GetMetrics1(p, a) (p)->lpVtbl->GetMetrics1(p, a)
#define IDWriteFontFace1_GetGdiCompatibleMetrics1(p, a, b, c, d) (p)->lpVtbl->GetGdiCompatibleMetrics1(p, a, b, c, d)
#define IDWriteFontFace1_GetCaretMetrics(p, a) (p)->lpVtbl->GetCaretMetrics(p, a)
#define IDWriteFontFace1_GetUnicodeRanges(p, a, b, c) (p)->lpVtbl->GetUnicodeRanges(p, a, b, c)
#define IDWriteFontFace1_IsMonospacedFont(p, a) (p)->lpVtbl->IsMonospacedFont(p, a)
#define IDWriteFontFace1_GetDesignGlyphAdvances(p, a, b, c, d) (p)->lpVtbl->GetDesignGlyphAdvances(p, a, b, c, d)
#define IDWriteFontFace1_GetGdiCompatibleGlyphAdvances(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetGdiCompatibleGlyphAdvances(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace1_GetKerningPairAdjustments(p, a, b, c) (p)->lpVtbl->GetKerningPairAdjustments(p, a, b, c)
#define IDWriteFontFace1_HasKerningPairs(p, a) (p)->lpVtbl->HasKerningPairs(p, a)
#define IDWriteFontFace1_GetRecommendedRenderingMode1(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetRecommendedRenderingMode1(p, a, b, c, d, e, f, g, h)
#define IDWriteFontFace1_GetVerticalGlyphVariants(p, a, b, c) (p)->lpVtbl->GetVerticalGlyphVariants(p, a, b, c)
#define IDWriteFontFace1_HasVerticalGlyphVariants(p, a) (p)->lpVtbl->HasVerticalGlyphVariants(p, a)

' ============================================================================
' IDWriteFont1
' ============================================================================
Type IDWriteFont1Vtbl As IDWriteFont1Vtbl_
Type IDWriteFont1
    lpVtbl As IDWriteFont1Vtbl Ptr
End Type
Type IDWriteFont1Vtbl_     '' Extends IDWriteFontVtbl_
    QueryInterface As Function(ByVal This As IDWriteFont1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteFont1 Ptr) As ULong
    Release As Function(ByVal This As IDWriteFont1 Ptr) As ULong
        
    GetFontFamily As Function(ByVal This As IDWriteFont1 Ptr,  ByVal family As Any Ptr Ptr ) As HRESULT
        ' 5. GetWeight
    GetWeight As Function(ByVal This As IDWriteFont1 Ptr) As DWRITE_FONT_WEIGHT
        ' 6. GetStretch
    GetStretch As Function(ByVal This As IDWriteFont1 Ptr) As DWRITE_FONT_STRETCH
        ' 7. GetStyle
    GetStyle As Function(ByVal This As IDWriteFont1 Ptr) As DWRITE_FONT_STYLE
        ' 8. IsSymbolFont
    IsSymbolFont As Function(ByVal This As IDWriteFont1 Ptr) As Long
        ' 9. GetFaceNames
    GetFaceNames As Function(ByVal This As IDWriteFont1 Ptr,  ByVal names As Any Ptr Ptr ) As HRESULT
        ' 10. GetInformationalStrings
    GetInformationalStrings As Function(ByVal This As IDWriteFont1 Ptr,  ByVal informationalStringID As DWRITE_INFORMATIONAL_STRING_ID, ByVal informationalStrings As Any Ptr Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' 11. GetSimulations
    GetSimulations As Function(ByVal This As IDWriteFont1 Ptr) As DWRITE_FONT_SIMULATIONS
        ' 12. GetMetrics
    GetMetrics As Sub(ByVal This As IDWriteFont1 Ptr,  ByVal fontMetrics As DWRITE_FONT_METRICS Ptr )
        ' 13. HasCharacter
    HasCharacter As Function(ByVal This As IDWriteFont1 Ptr,  ByVal unicodeValue As ULong, ByVal exists As Long Ptr ) As HRESULT
        ' 14. CreateFontFace
    CreateFontFace As Function(ByVal This As IDWriteFont1 Ptr,  ByVal fontFace As Any Ptr Ptr ) As HRESULT

        
    GetMetrics1 As Sub(ByVal This As IDWriteFont1 Ptr,  ByVal fontMetrics As DWRITE_FONT_METRICS1 Ptr )
        ' 16. GetPanose
    GetPanose As Sub(ByVal This As IDWriteFont1 Ptr,  ByVal panose As DWRITE_PANOSE Ptr )
        ' 17. GetUnicodeRanges
    GetUnicodeRanges As Function(ByVal This As IDWriteFont1 Ptr,  ByVal maxCount As ULong, ByVal unicodeRanges As DWRITE_UNICODE_RANGE Ptr, ByVal actualCount As ULong Ptr ) As HRESULT
        ' 18. IsMonospacedFont
    IsMonospacedFont As Function(ByVal This As IDWriteFont1 Ptr) As Long
End Type
#define IDWriteFont1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteFont1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteFont1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteFont1_GetFontFamily(p, a) (p)->lpVtbl->GetFontFamily(p, a)
#define IDWriteFont1_GetWeight(p, a) (p)->lpVtbl->GetWeight(p, a)
#define IDWriteFont1_GetStretch(p, a) (p)->lpVtbl->GetStretch(p, a)
#define IDWriteFont1_GetStyle(p, a) (p)->lpVtbl->GetStyle(p, a)
#define IDWriteFont1_IsSymbolFont(p, a) (p)->lpVtbl->IsSymbolFont(p, a)
#define IDWriteFont1_GetFaceNames(p, a) (p)->lpVtbl->GetFaceNames(p, a)
#define IDWriteFont1_GetInformationalStrings(p, a, b, c) (p)->lpVtbl->GetInformationalStrings(p, a, b, c)
#define IDWriteFont1_GetSimulations(p, a) (p)->lpVtbl->GetSimulations(p, a)
#define IDWriteFont1_GetMetrics(p, a) (p)->lpVtbl->GetMetrics(p, a)
#define IDWriteFont1_HasCharacter(p, a, b) (p)->lpVtbl->HasCharacter(p, a, b)
#define IDWriteFont1_CreateFontFace(p, a) (p)->lpVtbl->CreateFontFace(p, a)
#define IDWriteFont1_GetMetrics1(p, a) (p)->lpVtbl->GetMetrics1(p, a)
#define IDWriteFont1_GetPanose(p, a) (p)->lpVtbl->GetPanose(p, a)
#define IDWriteFont1_GetUnicodeRanges(p, a, b, c) (p)->lpVtbl->GetUnicodeRanges(p, a, b, c)
#define IDWriteFont1_IsMonospacedFont(p, a) (p)->lpVtbl->IsMonospacedFont(p, a)

' ============================================================================
' IDWriteRenderingParams1
' ============================================================================
Type IDWriteRenderingParams1Vtbl As IDWriteRenderingParams1Vtbl_
Type IDWriteRenderingParams1
    lpVtbl As IDWriteRenderingParams1Vtbl Ptr
End Type
Type IDWriteRenderingParams1Vtbl_     '' Extends IDWriteRenderingParamsVtbl_
    QueryInterface As Function(ByVal This As IDWriteRenderingParams1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteRenderingParams1 Ptr) As ULong
    Release As Function(ByVal This As IDWriteRenderingParams1 Ptr) As ULong
        
    GetGamma As Function(ByVal This As IDWriteRenderingParams1 Ptr) As Single
        ' 5. GetEnhancedContrast
    GetEnhancedContrast As Function(ByVal This As IDWriteRenderingParams1 Ptr) As Single
        ' 6. GetClearTypeLevel
    GetClearTypeLevel As Function(ByVal This As IDWriteRenderingParams1 Ptr) As Single
        ' 7. GetPixelGeometry
    GetPixelGeometry As Function(ByVal This As IDWriteRenderingParams1 Ptr) As DWRITE_PIXEL_GEOMETRY
        ' 8. GetRenderingMode
    GetRenderingMode As Function(ByVal This As IDWriteRenderingParams1 Ptr) As DWRITE_RENDERING_MODE

        
    GetGrayscaleEnhancedContrast As Function(ByVal This As IDWriteRenderingParams1 Ptr) As Single
End Type
#define IDWriteRenderingParams1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteRenderingParams1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteRenderingParams1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteRenderingParams1_GetGamma(p, a) (p)->lpVtbl->GetGamma(p, a)
#define IDWriteRenderingParams1_GetEnhancedContrast(p, a) (p)->lpVtbl->GetEnhancedContrast(p, a)
#define IDWriteRenderingParams1_GetClearTypeLevel(p, a) (p)->lpVtbl->GetClearTypeLevel(p, a)
#define IDWriteRenderingParams1_GetPixelGeometry(p, a) (p)->lpVtbl->GetPixelGeometry(p, a)
#define IDWriteRenderingParams1_GetRenderingMode(p, a) (p)->lpVtbl->GetRenderingMode(p, a)
#define IDWriteRenderingParams1_GetGrayscaleEnhancedContrast(p, a) (p)->lpVtbl->GetGrayscaleEnhancedContrast(p, a)

' ============================================================================
' IDWriteTextAnalyzer1
' ============================================================================
Type IDWriteTextAnalyzer1Vtbl As IDWriteTextAnalyzer1Vtbl_
Type IDWriteTextAnalyzer1
    lpVtbl As IDWriteTextAnalyzer1Vtbl Ptr
End Type
Type IDWriteTextAnalyzer1Vtbl_     '' Extends IDWriteTextAnalyzerVtbl_
    QueryInterface As Function(ByVal This As IDWriteTextAnalyzer1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteTextAnalyzer1 Ptr) As ULong
    Release As Function(ByVal This As IDWriteTextAnalyzer1 Ptr) As ULong
        ' --- IUnknown (1-3) ---
        ' 2. AddRef
        ' 4.
    AnalyzeScript As Function(ByVal This As IDWriteTextAnalyzer1 Ptr, ByVal analysisSource As IDWriteTextAnalysisSource Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal analysisSink As IDWriteTextAnalysisSink Ptr) As HRESULT
    AnalyzeBidi As Function(ByVal This As IDWriteTextAnalyzer1 Ptr, ByVal analysisSource As IDWriteTextAnalysisSource Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal analysisSink As IDWriteTextAnalysisSink Ptr) As HRESULT
    AnalyzeNumberSubstitution As Function(ByVal This As IDWriteTextAnalyzer1 Ptr, ByVal analysisSource As IDWriteTextAnalysisSource Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal analysisSink As IDWriteTextAnalysisSink Ptr) As HRESULT
    AnalyzeLineBreakpoints As Function(ByVal This As IDWriteTextAnalyzer1 Ptr, ByVal analysisSource As IDWriteTextAnalysisSource Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal analysisSink As IDWriteTextAnalysisSink Ptr) As HRESULT
        ' Weist den Glyphen die korrekten OpenType-Features zu (Shaping).
    GetGlyphs As Function(ByVal This As IDWriteTextAnalyzer1 Ptr, ByVal textString As WString Ptr, ByVal textLength As ULong, ByVal fontFace As IDWriteFontFace Ptr, ByVal isSideways As Long, ByVal isRightToLeft As Long, ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS Ptr, ByVal localeName As WString Ptr, ByVal numberSubstitution As IDWriteNumberSubstitution Ptr, ByVal features As DWRITE_TYPOGRAPHIC_FEATURES Ptr Ptr, ByVal featureRangeLengths As ULong Ptr, ByVal featureRanges As ULong, ByVal maxGlyphCount As ULong, ByRef clusters As UShort Ptr, ByRef textProps As DWRITE_SHAPING_TEXT_PROPERTIES Ptr, ByRef glyphIndices As UShort Ptr, ByRef glyphProps As DWRITE_SHAPING_GLYPH_PROPERTIES Ptr, ByRef actualGlyphCount As ULong) As HRESULT
        ' Ermittelt die Platzierung der Glyphen (Advances und Offsets).
    GetGlyphPlacements As Function(ByVal This As IDWriteTextAnalyzer1 Ptr, ByVal textString As WString Ptr, ByVal clusters As UShort Ptr, ByRef textProps As DWRITE_SHAPING_TEXT_PROPERTIES Ptr, ByVal textLength As ULong, ByVal glyphIndices As UShort Ptr, ByRef glyphProps As DWRITE_SHAPING_GLYPH_PROPERTIES Ptr, ByVal glyphCount As ULong, ByVal fontFace As IDWriteFontFace Ptr, ByVal fontEmSize As Single, ByVal isSideways As Long, ByVal isRightToLeft As Long, ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS Ptr, ByVal localeName As WString Ptr, ByVal features As DWRITE_TYPOGRAPHIC_FEATURES Ptr Ptr, ByVal featureRangeLengths As ULong Ptr, ByVal featureRanges As ULong, ByRef glyphAdvances As Single Ptr, ByRef glyphOffsets As DWRITE_GLYPH_OFFSET Ptr) As HRESULT
        ' Platziert Glyphen so, dass sie exakt mit dem GDI-Raster übereinstimmen.
    GetGdiCompatibleGlyphPlacements As Function(ByVal This As IDWriteTextAnalyzer1 Ptr, ByVal textString As WString Ptr, ByVal clusters As UShort Ptr, ByRef textProps As DWRITE_SHAPING_TEXT_PROPERTIES Ptr, ByVal textLength As ULong, ByVal glyphIndices As UShort Ptr, ByRef glyphProps As DWRITE_SHAPING_GLYPH_PROPERTIES Ptr, ByVal glyphCount As ULong, ByVal fontFace As IDWriteFontFace Ptr, ByVal fontEmSize As Single, ByVal pixelsPerDip As Single, ByVal transform As DWRITE_MATRIX Ptr, ByVal useGdiNatural As Long, ByVal isSideways As Long, ByVal isRightToLeft As Long, ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS Ptr, ByVal localeName As WString Ptr, ByVal features As DWRITE_TYPOGRAPHIC_FEATURES Ptr Ptr, ByVal featureRangeLengths As ULong Ptr, ByVal featureRanges As ULong, ByRef glyphAdvances As Single Ptr, ByRef glyphOffsets As DWRITE_GLYPH_OFFSET Ptr) As HRESULT

        
        ' ApplyCharacterSpacing
    ApplyCharacterSpacing As Function(ByVal This As IDWriteTextAnalyzer1 Ptr,  ByVal leadingSpacing As Single, ByVal trailingSpacing As Single, ByVal minimumAdvanceWidth As Single, ByVal textLength As ULong, ByVal glyphCount As ULong, ByVal clusterMap As UShort Ptr, ByVal glyphAdvances As Single Ptr, ByVal glyphOffsets As DWRITE_GLYPH_OFFSET Ptr, ByVal glyphProperties As DWRITE_SHAPING_GLYPH_PROPERTIES Ptr, ByVal modifiedGlyphAdvances As Single Ptr, ByVal modifiedGlyphOffsets As DWRITE_GLYPH_OFFSET Ptr ) As HRESULT
        ' GetBaseline
    GetBaseline As Function(ByVal This As IDWriteTextAnalyzer1 Ptr,  ByVal fontFace As Any Ptr, ByVal baseline As DWRITE_BASELINE, ByVal isVertical As Long, ByVal isSimulationAllowed As Long, ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS, ByVal localeName As WString Ptr, ByVal baselineCoordinate As Long Ptr, ByVal exists As Long Ptr ) As HRESULT
        ' AnalyzeVerticalGlyphOrientation
    AnalyzeVerticalGlyphOrientation As Function(ByVal This As IDWriteTextAnalyzer1 Ptr,  ByVal analysisSource As Any Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal analysisSink As Any Ptr ) As HRESULT
        ' GetGlyphOrientationTransform
    GetGlyphOrientationTransform As Function(ByVal This As IDWriteTextAnalyzer1 Ptr,  ByVal glyphOrientationAngle As DWRITE_GLYPH_ORIENTATION_ANGLE, ByVal isSideways As Long, ByVal transform As DWRITE_MATRIX Ptr ) As HRESULT
        ' GetScriptProperties
    GetScriptProperties As Function(ByVal This As IDWriteTextAnalyzer1 Ptr,  ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS, ByVal scriptProperties As DWRITE_SCRIPT_PROPERTIES Ptr ) As HRESULT
        ' GetTextComplexity
    GetTextComplexity As Function(ByVal This As IDWriteTextAnalyzer1 Ptr,  ByVal textString As WString Ptr, ByVal textLength As ULong, ByVal fontFace As Any Ptr, ByVal isTextSimple As Long Ptr, ByVal textLengthRead As ULong Ptr, ByVal glyphIndices As UShort Ptr ) As HRESULT
        ' GetJustificationOpportunities
    GetJustificationOpportunities As Function(ByVal This As IDWriteTextAnalyzer1 Ptr,  ByVal fontFace As Any Ptr, ByVal fontEmSize As Single, ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS, ByVal textLength As ULong, ByVal glyphCount As ULong, ByVal textString As WString Ptr, ByVal clusterMap As UShort Ptr, ByVal glyphProperties As DWRITE_SHAPING_GLYPH_PROPERTIES Ptr, ByVal justificationOpportunities As DWRITE_JUSTIFICATION_OPPORTUNITY Ptr ) As HRESULT
        ' JustifyGlyphAdvances
    JustifyGlyphAdvances As Function(ByVal This As IDWriteTextAnalyzer1 Ptr,  ByVal lineWidth As Single, ByVal glyphCount As ULong, ByVal justificationOpportunities As DWRITE_JUSTIFICATION_OPPORTUNITY Ptr, ByVal glyphAdvances As Single Ptr, ByVal glyphOffsets As DWRITE_GLYPH_OFFSET Ptr, ByVal justifiedGlyphAdvances As Single Ptr, ByVal justifiedGlyphOffsets As DWRITE_GLYPH_OFFSET Ptr ) As HRESULT
        ' GetJustifiedGlyphs
    GetJustifiedGlyphs As Function(ByVal This As IDWriteTextAnalyzer1 Ptr,  ByVal fontFace As Any Ptr, ByVal fontEmSize As Single, ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS, ByVal textLength As ULong, ByVal glyphCount As ULong, ByVal maxGlyphCount As ULong, ByVal clusterMap As UShort Ptr, ByVal glyphIndices As UShort Ptr, ByVal glyphAdvances As Single Ptr, ByVal justifiedGlyphAdvances As Single Ptr, ByVal justifiedGlyphOffsets As DWRITE_GLYPH_OFFSET Ptr, ByVal glyphProperties As DWRITE_SHAPING_GLYPH_PROPERTIES Ptr, ByVal actualGlyphCount As ULong Ptr, ByVal modifiedClusterMap As UShort Ptr, ByVal modifiedGlyphIndices As UShort Ptr, ByVal modifiedGlyphAdvances As Single Ptr, ByVal modifiedGlyphOffsets As DWRITE_GLYPH_OFFSET Ptr ) As HRESULT
End Type
#define IDWriteTextAnalyzer1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteTextAnalyzer1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteTextAnalyzer1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteTextAnalyzer1_AnalyzeScript(p, a, b, c, d) (p)->lpVtbl->AnalyzeScript(p, a, b, c, d)
#define IDWriteTextAnalyzer1_AnalyzeBidi(p, a, b, c, d) (p)->lpVtbl->AnalyzeBidi(p, a, b, c, d)
#define IDWriteTextAnalyzer1_AnalyzeNumberSubstitution(p, a, b, c, d) (p)->lpVtbl->AnalyzeNumberSubstitution(p, a, b, c, d)
#define IDWriteTextAnalyzer1_AnalyzeLineBreakpoints(p, a, b, c, d) (p)->lpVtbl->AnalyzeLineBreakpoints(p, a, b, c, d)
#define IDWriteTextAnalyzer1_GetGlyphs(p, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, q, r) (p)->lpVtbl->GetGlyphs(p, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, q, r)
#define IDWriteTextAnalyzer1_GetGlyphPlacements(p, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, q, r, s) (p)->lpVtbl->GetGlyphPlacements(p, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, q, r, s)
#define IDWriteTextAnalyzer1_GetGdiCompatibleGlyphPlacements(p, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, q, r, s, t, u, v) (p)->lpVtbl->GetGdiCompatibleGlyphPlacements(p, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, q, r, s, t, u, v)
#define IDWriteTextAnalyzer1_ApplyCharacterSpacing(p, a, b, c, d, e, f, g, h, i, j, k) (p)->lpVtbl->ApplyCharacterSpacing(p, a, b, c, d, e, f, g, h, i, j, k)
#define IDWriteTextAnalyzer1_GetBaseline(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->GetBaseline(p, a, b, c, d, e, f, g, h)
#define IDWriteTextAnalyzer1_AnalyzeVerticalGlyphOrientation(p, a, b, c, d) (p)->lpVtbl->AnalyzeVerticalGlyphOrientation(p, a, b, c, d)
#define IDWriteTextAnalyzer1_GetGlyphOrientationTransform(p, a, b, c) (p)->lpVtbl->GetGlyphOrientationTransform(p, a, b, c)
#define IDWriteTextAnalyzer1_GetScriptProperties(p, a, b) (p)->lpVtbl->GetScriptProperties(p, a, b)
#define IDWriteTextAnalyzer1_GetTextComplexity(p, a, b, c, d, e, f) (p)->lpVtbl->GetTextComplexity(p, a, b, c, d, e, f)
#define IDWriteTextAnalyzer1_GetJustificationOpportunities(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->GetJustificationOpportunities(p, a, b, c, d, e, f, g, h, i)
#define IDWriteTextAnalyzer1_JustifyGlyphAdvances(p, a, b, c, d, e, f, g) (p)->lpVtbl->JustifyGlyphAdvances(p, a, b, c, d, e, f, g)
#define IDWriteTextAnalyzer1_GetJustifiedGlyphs(p, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, q, r) (p)->lpVtbl->GetJustifiedGlyphs(p, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, q, r)

' ============================================================================
' IDWriteTextAnalysisSource1
' ============================================================================
Type IDWriteTextAnalysisSource1Vtbl As IDWriteTextAnalysisSource1Vtbl_
Type IDWriteTextAnalysisSource1
    lpVtbl As IDWriteTextAnalysisSource1Vtbl Ptr
End Type
Type IDWriteTextAnalysisSource1Vtbl_     '' Extends IDWriteTextAnalysisSourceVtbl_
    QueryInterface As Function(ByVal This As IDWriteTextAnalysisSource1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteTextAnalysisSource1 Ptr) As ULong
    Release As Function(ByVal This As IDWriteTextAnalysisSource1 Ptr) As ULong
        ' --- IUnknown (1-3) ---
        ' 2. AddRef
        ' 4.
    GetTextAtPosition As Function(ByVal This As IDWriteTextAnalysisSource1 Ptr, ByVal textPosition As ULong, ByRef textString As WString Ptr, ByRef textLength As ULong) As HRESULT
    GetTextBeforePosition As Function(ByVal This As IDWriteTextAnalysisSource1 Ptr, ByVal textPosition As ULong, ByRef textString As WString Ptr, ByRef textLength As ULong) As HRESULT
    GetParagraphReadingDirection As Function(ByVal This As IDWriteTextAnalysisSource1 Ptr) As DWRITE_READING_DIRECTION
    GetLocaleName As Function(ByVal This As IDWriteTextAnalysisSource1 Ptr, ByVal textPosition As ULong, ByRef textLength As ULong, ByRef localeName As WString Ptr) As HRESULT
        ' Liefert die NumberSubstitution-Regeln für einen Textbereich.
    GetNumberSubstitution As Function(ByVal This As IDWriteTextAnalysisSource1 Ptr, ByVal textPosition As ULong, ByRef textLength As ULong, ByRef numberSubstitution As IDWriteNumberSubstitution Ptr) As HRESULT

        
        ' GetVerticalGlyphOrientation
    GetVerticalGlyphOrientation As Function(ByVal This As IDWriteTextAnalysisSource1 Ptr,  ByVal textPosition As ULong, ByVal textLength As ULong Ptr, ByVal glyphOrientation As DWRITE_VERTICAL_GLYPH_ORIENTATION Ptr, ByVal bidiLevel As Byte Ptr ) As HRESULT
End Type
#define IDWriteTextAnalysisSource1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteTextAnalysisSource1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteTextAnalysisSource1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteTextAnalysisSource1_GetTextAtPosition(p, a, b, c) (p)->lpVtbl->GetTextAtPosition(p, a, b, c)
#define IDWriteTextAnalysisSource1_GetTextBeforePosition(p, a, b, c) (p)->lpVtbl->GetTextBeforePosition(p, a, b, c)
#define IDWriteTextAnalysisSource1_GetParagraphReadingDirection(p, a) (p)->lpVtbl->GetParagraphReadingDirection(p, a)
#define IDWriteTextAnalysisSource1_GetLocaleName(p, a, b, c) (p)->lpVtbl->GetLocaleName(p, a, b, c)
#define IDWriteTextAnalysisSource1_GetNumberSubstitution(p, a, b, c) (p)->lpVtbl->GetNumberSubstitution(p, a, b, c)
#define IDWriteTextAnalysisSource1_GetVerticalGlyphOrientation(p, a, b, c, d) (p)->lpVtbl->GetVerticalGlyphOrientation(p, a, b, c, d)

' ============================================================================
' IDWriteTextAnalysisSink1
' ============================================================================
Type IDWriteTextAnalysisSink1Vtbl As IDWriteTextAnalysisSink1Vtbl_
Type IDWriteTextAnalysisSink1
    lpVtbl As IDWriteTextAnalysisSink1Vtbl Ptr
End Type
Type IDWriteTextAnalysisSink1Vtbl_     '' Extends IDWriteTextAnalysisSinkVtbl_
    QueryInterface As Function(ByVal This As IDWriteTextAnalysisSink1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteTextAnalysisSink1 Ptr) As ULong
    Release As Function(ByVal This As IDWriteTextAnalysisSink1 Ptr) As ULong
        ' --- IUnknown (1-3) ---
        ' 2. AddRef
        ' 4.
    SetScriptAnalysis As Function(ByVal This As IDWriteTextAnalysisSink1 Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal scriptAnalysis As DWRITE_SCRIPT_ANALYSIS Ptr) As HRESULT
    SetLineBreakpoints As Function(ByVal This As IDWriteTextAnalysisSink1 Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal lineBreakpoints As DWRITE_LINE_BREAKPOINT Ptr) As HRESULT
    SetBidiLevel As Function(ByVal This As IDWriteTextAnalysisSink1 Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal explicitLevel As UByte, ByVal resolvedLevel As UByte) As HRESULT
    SetNumberSubstitution As Function(ByVal This As IDWriteTextAnalysisSink1 Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal numberSubstitution As IDWriteNumberSubstitution Ptr) As HRESULT
    SetGlyphOrientation As Function(ByVal This As IDWriteTextAnalysisSink1 Ptr, ByVal textPosition As ULong, ByVal textLength As ULong, ByVal glyphOrientation As DWRITE_VERTICAL_GLYPH_ORIENTATION, ByVal bidiLevel As UByte, ByVal isSideways As Long, ByVal isRightToLeft As Long) As HRESULT

        
        ' SetGlyphOrientation
    SetGlyphOrientation1 As Function(ByVal This As IDWriteTextAnalysisSink1 Ptr,  ByVal textPosition As ULong, ByVal textLength As ULong, ByVal glyphOrientationAngle As DWRITE_GLYPH_ORIENTATION_ANGLE, ByVal adjustedBidiLevel As Byte, ByVal isSideways As Long, ByVal isRightToLeft As Long ) As HRESULT
End Type
#define IDWriteTextAnalysisSink1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteTextAnalysisSink1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteTextAnalysisSink1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteTextAnalysisSink1_SetScriptAnalysis(p, a, b, c) (p)->lpVtbl->SetScriptAnalysis(p, a, b, c)
#define IDWriteTextAnalysisSink1_SetLineBreakpoints(p, a, b, c) (p)->lpVtbl->SetLineBreakpoints(p, a, b, c)
#define IDWriteTextAnalysisSink1_SetBidiLevel(p, a, b, c, d) (p)->lpVtbl->SetBidiLevel(p, a, b, c, d)
#define IDWriteTextAnalysisSink1_SetNumberSubstitution(p, a, b, c) (p)->lpVtbl->SetNumberSubstitution(p, a, b, c)
#define IDWriteTextAnalysisSink1_SetGlyphOrientation(p, a, b, c, d, e, f) (p)->lpVtbl->SetGlyphOrientation(p, a, b, c, d, e, f)
#define IDWriteTextAnalysisSink1_SetGlyphOrientation1(p, a, b, c, d, e, f) (p)->lpVtbl->SetGlyphOrientation1(p, a, b, c, d, e, f)

' ============================================================================
' IDWriteTextLayout1
' ============================================================================
Type IDWriteTextLayout1Vtbl As IDWriteTextLayout1Vtbl_
Type IDWriteTextLayout1
    lpVtbl As IDWriteTextLayout1Vtbl Ptr
End Type
Type IDWriteTextLayout1Vtbl_     '' Extends IDWriteTextLayoutVtbl_
    QueryInterface As Function(ByVal This As IDWriteTextLayout1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteTextLayout1 Ptr) As ULong
    Release As Function(ByVal This As IDWriteTextLayout1 Ptr) As ULong
        
    SetTextAlignment As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal textAlignment As DWRITE_TEXT_ALIGNMENT ) As HRESULT
        ' 5. SetParagraphAlignment
    SetParagraphAlignment As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal paragraphAlignment As DWRITE_PARAGRAPH_ALIGNMENT ) As HRESULT
        ' 6. SetWordWrapping
    SetWordWrapping As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal wordWrapping As DWRITE_WORD_WRAPPING ) As HRESULT
        ' 7. SetReadingDirection
    SetReadingDirection As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal readingDirection As DWRITE_READING_DIRECTION ) As HRESULT
        ' 8. SetFlowDirection
    SetFlowDirection As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal flowDirection As DWRITE_FLOW_DIRECTION ) As HRESULT
        ' 9. SetIncrementalTabStop
    SetIncrementalTabStop As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal incrementalTabStop As Single ) As HRESULT
        ' 10. SetTrimming
    SetTrimming As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal trimmingOptions As DWRITE_TRIMMING Ptr, ByVal trimmingSign As Any Ptr ) As HRESULT
        ' 11. SetLineSpacing
    SetLineSpacing As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal lineSpacingMethod As DWRITE_LINE_SPACING_METHOD, ByVal lineSpacing As Single, ByVal baseline As Single ) As HRESULT
        ' 12. GetTextAlignment
    GetTextAlignment As Function(ByVal This As IDWriteTextLayout1 Ptr) As DWRITE_TEXT_ALIGNMENT
        ' 13. GetParagraphAlignment
    GetParagraphAlignment As Function(ByVal This As IDWriteTextLayout1 Ptr) As DWRITE_PARAGRAPH_ALIGNMENT
        ' 14. GetWordWrapping
    GetWordWrapping As Function(ByVal This As IDWriteTextLayout1 Ptr) As DWRITE_WORD_WRAPPING
        ' 15. GetReadingDirection
    GetReadingDirection As Function(ByVal This As IDWriteTextLayout1 Ptr) As DWRITE_READING_DIRECTION
        ' 16. GetFlowDirection
    GetFlowDirection As Function(ByVal This As IDWriteTextLayout1 Ptr) As DWRITE_FLOW_DIRECTION
        ' 17. GetIncrementalTabStop
    GetIncrementalTabStop As Function(ByVal This As IDWriteTextLayout1 Ptr) As Single
        ' 18. GetTrimming
    GetTrimming As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal trimmingOptions As DWRITE_TRIMMING Ptr, ByVal trimmingSign As Any Ptr Ptr ) As HRESULT
        ' 19. GetLineSpacing
    GetLineSpacing As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal lineSpacingMethod As DWRITE_LINE_SPACING_METHOD Ptr, ByVal lineSpacing As Single Ptr, ByVal baseline As Single Ptr ) As HRESULT
        ' 20. GetFontCollection
    GetFontCollection As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal fontCollection As Any Ptr Ptr ) As HRESULT
        ' 21. GetFontFamilyNameLength
    GetFontFamilyNameLength As Function(ByVal This As IDWriteTextLayout1 Ptr) As ULong
        ' 22. GetFontFamilyName
    GetFontFamilyName As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal fontFamilyName As WString Ptr, ByVal nameSize As ULong ) As HRESULT
        ' 23. GetFontWeight
    GetFontWeight As Function(ByVal This As IDWriteTextLayout1 Ptr) As DWRITE_FONT_WEIGHT
        ' 24. GetFontStyle
    GetFontStyle As Function(ByVal This As IDWriteTextLayout1 Ptr) As DWRITE_FONT_STYLE
        ' 25. GetFontStretch
    GetFontStretch As Function(ByVal This As IDWriteTextLayout1 Ptr) As DWRITE_FONT_STRETCH
        ' 26. GetFontSize
    GetFontSize As Function(ByVal This As IDWriteTextLayout1 Ptr) As Single
        ' 27. GetLocaleNameLength
    GetLocaleNameLength As Function(ByVal This As IDWriteTextLayout1 Ptr) As ULong
        ' 28. GetLocaleName
    GetLocaleName As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal localeName As WString Ptr, ByVal nameSize As ULong ) As HRESULT
        
    SetMaxWidth As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal maxWidth As Single ) As HRESULT
        ' 30. SetMaxHeight
    SetMaxHeight As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal maxHeight As Single ) As HRESULT
        ' 31. SetFontCollection
    SetFontCollection As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal fontCollection As Any Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 32. SetFontFamilyName
    SetFontFamilyName As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal fontFamilyName As WString Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 33. SetFontWeight
    SetFontWeight As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal fontWeight As DWRITE_FONT_WEIGHT, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 34. SetFontStyle
    SetFontStyle As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal fontStyle As DWRITE_FONT_STYLE, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 35. SetFontStretch
    SetFontStretch As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal fontStretch As DWRITE_FONT_STRETCH, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 36. SetFontSize
    SetFontSize As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal fontSize As Single, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 37. SetUnderline
    SetUnderline As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal hasUnderline As Long, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 38. SetStrikethrough
    SetStrikethrough As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal hasStrikethrough As Long, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 39. SetDrawingEffect
    SetDrawingEffect As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal drawingEffect As IUnknown Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 40. SetInlineObject
    SetInlineObject As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal inlineObject As Any Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 41. SetTypography
    SetTypography As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal typography As Any Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 42. SetLocaleName
    SetLocaleName As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal localeName As WString Ptr, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 43. GetMaxWidth
    GetMaxWidth As Function(ByVal This As IDWriteTextLayout1 Ptr) As Single
        ' 44. GetMaxHeight
    GetMaxHeight As Function(ByVal This As IDWriteTextLayout1 Ptr) As Single
        ' 45. GetFontCollection
    GetFontCollection1 As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal currentPosition As ULong, ByVal fontCollection As Any Ptr Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 46. GetFontFamilyNameLength
    GetFontFamilyNameLength1 As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal currentPosition As ULong, ByVal nameLength As ULong Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 47. GetFontFamilyName
    GetFontFamilyName1 As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal currentPosition As ULong, ByVal fontFamilyName As WString Ptr, ByVal nameSize As ULong, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 48. GetFontWeight
    GetFontWeight1 As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal currentPosition As ULong, ByVal fontWeight As DWRITE_FONT_WEIGHT Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 49. GetFontStyle
    GetFontStyle1 As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal currentPosition As ULong, ByVal fontStyle As DWRITE_FONT_STYLE Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 50. GetFontStretch
    GetFontStretch1 As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal currentPosition As ULong, ByVal fontStretch As DWRITE_FONT_STRETCH Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 51. GetFontSize
    GetFontSize1 As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal currentPosition As ULong, ByVal fontSize As Single Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 52. GetUnderline
    GetUnderline As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal currentPosition As ULong, ByVal hasUnderline As Long Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 53. GetStrikethrough
    GetStrikethrough As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal currentPosition As ULong, ByVal hasStrikethrough As Long Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 54. GetDrawingEffect
    GetDrawingEffect As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal currentPosition As ULong, ByVal drawingEffect As IUnknown Ptr Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 55. GetInlineObject
    GetInlineObject As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal currentPosition As ULong, ByVal inlineObject As Any Ptr Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 56. GetTypography
    GetTypography As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal currentPosition As ULong, ByVal typography As Any Ptr Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 57. GetLocaleNameLength
    GetLocaleNameLength1 As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal currentPosition As ULong, ByVal nameLength As ULong Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 58. GetLocaleName
    GetLocaleName1 As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal currentPosition As ULong, ByVal localeName As WString Ptr, ByVal nameSize As ULong, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 59. Draw
    Draw As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal clientDrawingContext As Any Ptr, ByVal renderer As Any Ptr, ByVal originX As Single, ByVal originY As Single ) As HRESULT
        ' 60. GetLineMetrics
    GetLineMetrics As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal lineMetrics As DWRITE_LINE_METRICS Ptr, ByVal maxLineCount As ULong, ByVal actualLineCount As ULong Ptr ) As HRESULT
        ' 61. GetMetrics
    GetMetrics As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal textMetrics As DWRITE_TEXT_METRICS Ptr ) As HRESULT
        ' 62. GetOverhangMetrics
    GetOverhangMetrics As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal overhangs As DWRITE_OVERHANG_METRICS Ptr ) As HRESULT
        ' 63. GetClusterMetrics
    GetClusterMetrics As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal clusterMetrics As DWRITE_CLUSTER_METRICS Ptr, ByVal maxClusterCount As ULong, ByVal actualClusterCount As ULong Ptr ) As HRESULT
        ' 64. DetermineMinWidth
    DetermineMinWidth As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal minWidth As Single Ptr ) As HRESULT
        ' 65. HitTestPoint
    HitTestPoint As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal pointX As Single, ByVal pointY As Single, ByVal isTrailingHit As Long Ptr, ByVal isInside As Long Ptr, ByVal hitTestMetrics As DWRITE_HIT_TEST_METRICS Ptr ) As HRESULT
        ' 66. HitTestTextPosition
    HitTestTextPosition As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal textPosition As ULong, ByVal isTrailingHit As Long, ByVal pointX As Single Ptr, ByVal pointY As Single Ptr, ByVal hitTestMetrics As DWRITE_HIT_TEST_METRICS Ptr ) As HRESULT
        ' 67. HitTestTextRange
    HitTestTextRange As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal textPosition As ULong, ByVal textLength As ULong, ByVal originX As Single, ByVal originY As Single, ByVal hitTestMetrics As DWRITE_HIT_TEST_METRICS Ptr, ByVal maxHitTestMetricsCount As ULong, ByVal actualHitTestMetricsCount As ULong Ptr ) As HRESULT

        
    SetPairKerning As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal isPairKerningEnabled As Long, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 69. GetPairKerning
    GetPairKerning As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal currentPosition As ULong, ByVal isPairKerningEnabled As Long Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
        ' 70. SetCharacterSpacing
    SetCharacterSpacing As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal leadingSpacing As Single, ByVal trailingSpacing As Single, ByVal minimumAdvanceWidth As Single, ByVal textRange As DWRITE_TEXT_RANGE ) As HRESULT
        ' 71. GetCharacterSpacing
    GetCharacterSpacing As Function(ByVal This As IDWriteTextLayout1 Ptr,  ByVal currentPosition As ULong, ByVal leadingSpacing As Single Ptr, ByVal trailingSpacing As Single Ptr, ByVal minimumAdvanceWidth As Single Ptr, ByVal textRange As DWRITE_TEXT_RANGE Ptr = 0 ) As HRESULT
End Type
#define IDWriteTextLayout1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteTextLayout1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteTextLayout1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteTextLayout1_SetTextAlignment(p, a) (p)->lpVtbl->SetTextAlignment(p, a)
#define IDWriteTextLayout1_SetParagraphAlignment(p, a) (p)->lpVtbl->SetParagraphAlignment(p, a)
#define IDWriteTextLayout1_SetWordWrapping(p, a) (p)->lpVtbl->SetWordWrapping(p, a)
#define IDWriteTextLayout1_SetReadingDirection(p, a) (p)->lpVtbl->SetReadingDirection(p, a)
#define IDWriteTextLayout1_SetFlowDirection(p, a) (p)->lpVtbl->SetFlowDirection(p, a)
#define IDWriteTextLayout1_SetIncrementalTabStop(p, a) (p)->lpVtbl->SetIncrementalTabStop(p, a)
#define IDWriteTextLayout1_SetTrimming(p, a, b) (p)->lpVtbl->SetTrimming(p, a, b)
#define IDWriteTextLayout1_SetLineSpacing(p, a, b, c) (p)->lpVtbl->SetLineSpacing(p, a, b, c)
#define IDWriteTextLayout1_GetTextAlignment(p, a) (p)->lpVtbl->GetTextAlignment(p, a)
#define IDWriteTextLayout1_GetParagraphAlignment(p, a) (p)->lpVtbl->GetParagraphAlignment(p, a)
#define IDWriteTextLayout1_GetWordWrapping(p, a) (p)->lpVtbl->GetWordWrapping(p, a)
#define IDWriteTextLayout1_GetReadingDirection(p, a) (p)->lpVtbl->GetReadingDirection(p, a)
#define IDWriteTextLayout1_GetFlowDirection(p, a) (p)->lpVtbl->GetFlowDirection(p, a)
#define IDWriteTextLayout1_GetIncrementalTabStop(p, a) (p)->lpVtbl->GetIncrementalTabStop(p, a)
#define IDWriteTextLayout1_GetTrimming(p, a, b) (p)->lpVtbl->GetTrimming(p, a, b)
#define IDWriteTextLayout1_GetLineSpacing(p, a, b, c) (p)->lpVtbl->GetLineSpacing(p, a, b, c)
#define IDWriteTextLayout1_GetFontCollection(p, a) (p)->lpVtbl->GetFontCollection(p, a)
#define IDWriteTextLayout1_GetFontFamilyNameLength(p, a) (p)->lpVtbl->GetFontFamilyNameLength(p, a)
#define IDWriteTextLayout1_GetFontFamilyName(p, a, b) (p)->lpVtbl->GetFontFamilyName(p, a, b)
#define IDWriteTextLayout1_GetFontWeight(p, a) (p)->lpVtbl->GetFontWeight(p, a)
#define IDWriteTextLayout1_GetFontStyle(p, a) (p)->lpVtbl->GetFontStyle(p, a)
#define IDWriteTextLayout1_GetFontStretch(p, a) (p)->lpVtbl->GetFontStretch(p, a)
#define IDWriteTextLayout1_GetFontSize(p, a) (p)->lpVtbl->GetFontSize(p, a)
#define IDWriteTextLayout1_GetLocaleNameLength(p, a) (p)->lpVtbl->GetLocaleNameLength(p, a)
#define IDWriteTextLayout1_GetLocaleName(p, a, b) (p)->lpVtbl->GetLocaleName(p, a, b)
#define IDWriteTextLayout1_SetMaxWidth(p, a) (p)->lpVtbl->SetMaxWidth(p, a)
#define IDWriteTextLayout1_SetMaxHeight(p, a) (p)->lpVtbl->SetMaxHeight(p, a)
#define IDWriteTextLayout1_SetFontCollection(p, a, b) (p)->lpVtbl->SetFontCollection(p, a, b)
#define IDWriteTextLayout1_SetFontFamilyName(p, a, b) (p)->lpVtbl->SetFontFamilyName(p, a, b)
#define IDWriteTextLayout1_SetFontWeight(p, a, b) (p)->lpVtbl->SetFontWeight(p, a, b)
#define IDWriteTextLayout1_SetFontStyle(p, a, b) (p)->lpVtbl->SetFontStyle(p, a, b)
#define IDWriteTextLayout1_SetFontStretch(p, a, b) (p)->lpVtbl->SetFontStretch(p, a, b)
#define IDWriteTextLayout1_SetFontSize(p, a, b) (p)->lpVtbl->SetFontSize(p, a, b)
#define IDWriteTextLayout1_SetUnderline(p, a, b) (p)->lpVtbl->SetUnderline(p, a, b)
#define IDWriteTextLayout1_SetStrikethrough(p, a, b) (p)->lpVtbl->SetStrikethrough(p, a, b)
#define IDWriteTextLayout1_SetDrawingEffect(p, a, b) (p)->lpVtbl->SetDrawingEffect(p, a, b)
#define IDWriteTextLayout1_SetInlineObject(p, a, b) (p)->lpVtbl->SetInlineObject(p, a, b)
#define IDWriteTextLayout1_SetTypography(p, a, b) (p)->lpVtbl->SetTypography(p, a, b)
#define IDWriteTextLayout1_SetLocaleName(p, a, b) (p)->lpVtbl->SetLocaleName(p, a, b)
#define IDWriteTextLayout1_GetMaxWidth(p, a) (p)->lpVtbl->GetMaxWidth(p, a)
#define IDWriteTextLayout1_GetMaxHeight(p, a) (p)->lpVtbl->GetMaxHeight(p, a)
#define IDWriteTextLayout1_GetFontCollection1(p, a, b, c) (p)->lpVtbl->GetFontCollection1(p, a, b, c)
#define IDWriteTextLayout1_GetFontFamilyNameLength1(p, a, b, c) (p)->lpVtbl->GetFontFamilyNameLength1(p, a, b, c)
#define IDWriteTextLayout1_GetFontFamilyName1(p, a, b, c, d) (p)->lpVtbl->GetFontFamilyName1(p, a, b, c, d)
#define IDWriteTextLayout1_GetFontWeight1(p, a, b, c) (p)->lpVtbl->GetFontWeight1(p, a, b, c)
#define IDWriteTextLayout1_GetFontStyle1(p, a, b, c) (p)->lpVtbl->GetFontStyle1(p, a, b, c)
#define IDWriteTextLayout1_GetFontStretch1(p, a, b, c) (p)->lpVtbl->GetFontStretch1(p, a, b, c)
#define IDWriteTextLayout1_GetFontSize1(p, a, b, c) (p)->lpVtbl->GetFontSize1(p, a, b, c)
#define IDWriteTextLayout1_GetUnderline(p, a, b, c) (p)->lpVtbl->GetUnderline(p, a, b, c)
#define IDWriteTextLayout1_GetStrikethrough(p, a, b, c) (p)->lpVtbl->GetStrikethrough(p, a, b, c)
#define IDWriteTextLayout1_GetDrawingEffect(p, a, b, c) (p)->lpVtbl->GetDrawingEffect(p, a, b, c)
#define IDWriteTextLayout1_GetInlineObject(p, a, b, c) (p)->lpVtbl->GetInlineObject(p, a, b, c)
#define IDWriteTextLayout1_GetTypography(p, a, b, c) (p)->lpVtbl->GetTypography(p, a, b, c)
#define IDWriteTextLayout1_GetLocaleNameLength1(p, a, b, c) (p)->lpVtbl->GetLocaleNameLength1(p, a, b, c)
#define IDWriteTextLayout1_GetLocaleName1(p, a, b, c, d) (p)->lpVtbl->GetLocaleName1(p, a, b, c, d)
#define IDWriteTextLayout1_Draw(p, a, b, c, d) (p)->lpVtbl->Draw(p, a, b, c, d)
#define IDWriteTextLayout1_GetLineMetrics(p, a, b, c) (p)->lpVtbl->GetLineMetrics(p, a, b, c)
#define IDWriteTextLayout1_GetMetrics(p, a) (p)->lpVtbl->GetMetrics(p, a)
#define IDWriteTextLayout1_GetOverhangMetrics(p, a) (p)->lpVtbl->GetOverhangMetrics(p, a)
#define IDWriteTextLayout1_GetClusterMetrics(p, a, b, c) (p)->lpVtbl->GetClusterMetrics(p, a, b, c)
#define IDWriteTextLayout1_DetermineMinWidth(p, a) (p)->lpVtbl->DetermineMinWidth(p, a)
#define IDWriteTextLayout1_HitTestPoint(p, a, b, c, d, e) (p)->lpVtbl->HitTestPoint(p, a, b, c, d, e)
#define IDWriteTextLayout1_HitTestTextPosition(p, a, b, c, d, e) (p)->lpVtbl->HitTestTextPosition(p, a, b, c, d, e)
#define IDWriteTextLayout1_HitTestTextRange(p, a, b, c, d, e, f, g) (p)->lpVtbl->HitTestTextRange(p, a, b, c, d, e, f, g)
#define IDWriteTextLayout1_SetPairKerning(p, a, b) (p)->lpVtbl->SetPairKerning(p, a, b)
#define IDWriteTextLayout1_GetPairKerning(p, a, b, c) (p)->lpVtbl->GetPairKerning(p, a, b, c)
#define IDWriteTextLayout1_SetCharacterSpacing(p, a, b, c, d) (p)->lpVtbl->SetCharacterSpacing(p, a, b, c, d)
#define IDWriteTextLayout1_GetCharacterSpacing(p, a, b, c, d, e) (p)->lpVtbl->GetCharacterSpacing(p, a, b, c, d, e)

' ============================================================================
' IDWriteBitmapRenderTarget1
' ============================================================================
Type IDWriteBitmapRenderTarget1Vtbl As IDWriteBitmapRenderTarget1Vtbl_
Type IDWriteBitmapRenderTarget1
    lpVtbl As IDWriteBitmapRenderTarget1Vtbl Ptr
End Type
Type IDWriteBitmapRenderTarget1Vtbl_     '' Extends IDWriteBitmapRenderTargetVtbl_
    QueryInterface As Function(ByVal This As IDWriteBitmapRenderTarget1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IDWriteBitmapRenderTarget1 Ptr) As ULong
    Release As Function(ByVal This As IDWriteBitmapRenderTarget1 Ptr) As ULong
        
    DrawGlyphRun As Function(ByVal This As IDWriteBitmapRenderTarget1 Ptr,  ByVal baselineOriginX As Single, ByVal baselineOriginY As Single, ByVal measuringMode As DWRITE_MEASURING_MODE, ByVal glyphRun As DWRITE_GLYPH_RUN Ptr, ByVal renderingParams As Any Ptr, ByVal textColor As COLORREF, ByVal blackBoxRect As RECT Ptr = 0 ) As HRESULT
        ' 5. GetMemoryDC
    GetMemoryDC As Function(ByVal This As IDWriteBitmapRenderTarget1 Ptr) As HDC
        ' 6. GetPixelsPerDip
    GetPixelsPerDip As Function(ByVal This As IDWriteBitmapRenderTarget1 Ptr) As Single
        ' 7. SetPixelsPerDip
    SetPixelsPerDip As Function(ByVal This As IDWriteBitmapRenderTarget1 Ptr,  ByVal pixelsPerDip As Single ) As HRESULT
        ' 8. GetCurrentTransform
    GetCurrentTransform As Function(ByVal This As IDWriteBitmapRenderTarget1 Ptr,  ByVal transform As DWRITE_MATRIX Ptr ) As HRESULT
        ' 9. SetCurrentTransform
    SetCurrentTransform As Function(ByVal This As IDWriteBitmapRenderTarget1 Ptr,  ByVal transform As DWRITE_MATRIX Ptr ) As HRESULT
        ' 10. GetSize
    GetSize As Function(ByVal This As IDWriteBitmapRenderTarget1 Ptr,  ByVal size As SIZE Ptr ) As HRESULT
        ' 11. Resize
    Resize As Function(ByVal This As IDWriteBitmapRenderTarget1 Ptr,  ByVal width As ULong, ByVal height As ULong ) As HRESULT

        
    GetTextAntialiasMode As Function(ByVal This As IDWriteBitmapRenderTarget1 Ptr) As DWRITE_TEXT_ANTIALIAS_MODE
        ' 13. SetTextAntialiasMode
    SetTextAntialiasMode As Function(ByVal This As IDWriteBitmapRenderTarget1 Ptr,  ByVal antialiasMode As DWRITE_TEXT_ANTIALIAS_MODE ) As HRESULT
End Type
#define IDWriteBitmapRenderTarget1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IDWriteBitmapRenderTarget1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IDWriteBitmapRenderTarget1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define IDWriteBitmapRenderTarget1_DrawGlyphRun(p, a, b, c, d, e, f, g) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d, e, f, g)
#define IDWriteBitmapRenderTarget1_GetMemoryDC(p, a) (p)->lpVtbl->GetMemoryDC(p, a)
#define IDWriteBitmapRenderTarget1_GetPixelsPerDip(p, a) (p)->lpVtbl->GetPixelsPerDip(p, a)
#define IDWriteBitmapRenderTarget1_SetPixelsPerDip(p, a) (p)->lpVtbl->SetPixelsPerDip(p, a)
#define IDWriteBitmapRenderTarget1_GetCurrentTransform(p, a) (p)->lpVtbl->GetCurrentTransform(p, a)
#define IDWriteBitmapRenderTarget1_SetCurrentTransform(p, a) (p)->lpVtbl->SetCurrentTransform(p, a)
#define IDWriteBitmapRenderTarget1_GetSize(p, a) (p)->lpVtbl->GetSize(p, a)
#define IDWriteBitmapRenderTarget1_Resize(p, a, b) (p)->lpVtbl->Resize(p, a, b)
#define IDWriteBitmapRenderTarget1_GetTextAntialiasMode(p, a) (p)->lpVtbl->GetTextAntialiasMode(p, a)
#define IDWriteBitmapRenderTarget1_SetTextAntialiasMode(p, a) (p)->lpVtbl->SetTextAntialiasMode(p, a)

