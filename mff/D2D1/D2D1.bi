#include once "win/ole2.bi"

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
	DWRITE_FONT_FILE_TYPE_TRUETYPE_COLLECTION = DWRITE_FONT_FILE_TYPE_OPENTYPE_COLLECTION
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
	DWRITE_FONT_FACE_TYPE_TRUETYPE_COLLECTION = DWRITE_FONT_FACE_TYPE_OPENTYPE_COLLECTION
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
	DWRITE_INFORMATIONAL_STRING_PREFERRED_FAMILY_NAMES = DWRITE_INFORMATIONAL_STRING_TYPOGRAPHIC_FAMILY_NAMES
	DWRITE_INFORMATIONAL_STRING_PREFERRED_SUBFAMILY_NAMES = DWRITE_INFORMATIONAL_STRING_TYPOGRAPHIC_SUBFAMILY_NAMES
	DWRITE_INFORMATIONAL_STRING_WWS_FAMILY_NAME = DWRITE_INFORMATIONAL_STRING_WEIGHT_STRETCH_STYLE_FAMILY_NAME
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
	DWRITE_RENDERING_MODE_CLEARTYPE_GDI_CLASSIC = DWRITE_RENDERING_MODE_GDI_CLASSIC
	DWRITE_RENDERING_MODE_CLEARTYPE_GDI_NATURAL = DWRITE_RENDERING_MODE_GDI_NATURAL
	DWRITE_RENDERING_MODE_CLEARTYPE_NATURAL = DWRITE_RENDERING_MODE_NATURAL
	DWRITE_RENDERING_MODE_CLEARTYPE_NATURAL_SYMMETRIC = DWRITE_RENDERING_MODE_NATURAL_SYMMETRIC
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

Type DWRITE_MEASURING_MODE As Long
Enum
    DWRITE_MEASURING_MODE_NATURAL = 0
    DWRITE_MEASURING_MODE_GDI_CLASSIC = 1
    DWRITE_MEASURING_MODE_GDI_NATURAL = 2
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

#define COM_METHOD(p, i) Cast(Any Ptr Ptr, Cast(Any Ptr Ptr, p)[0])[i]

Type D3D10_FEATURE_LEVEL1 As Long
Enum
	D3D10_FEATURE_LEVEL_10_0   = &ha000
	D3D10_FEATURE_LEVEL_10_1   = &ha100
	D3D10_FEATURE_LEVEL_9_1    = &h9100
	D3D10_FEATURE_LEVEL_9_2    = &h9200
	D3D10_FEATURE_LEVEL_9_3    = &h9300
End Enum

Type DXGI_FORMAT As Long
Enum
	DXGI_FORMAT_UNKNOWN                      = 0
	DXGI_FORMAT_R32G32B32A32_TYPELESS        = 1
	DXGI_FORMAT_R32G32B32A32_FLOAT           = 2
	DXGI_FORMAT_R32G32B32A32_UINT            = 3
	DXGI_FORMAT_R32G32B32A32_SINT            = 4
	DXGI_FORMAT_R32G32B32_TYPELESS           = 5
	DXGI_FORMAT_R32G32B32_FLOAT              = 6
	DXGI_FORMAT_R32G32B32_UINT               = 7
	DXGI_FORMAT_R32G32B32_SINT               = 8
	DXGI_FORMAT_R16G16B16A16_TYPELESS        = 9
	DXGI_FORMAT_R16G16B16A16_FLOAT           = 10
	DXGI_FORMAT_R16G16B16A16_UNORM           = 11
	DXGI_FORMAT_R16G16B16A16_UINT            = 12
	DXGI_FORMAT_R16G16B16A16_SNORM           = 13
	DXGI_FORMAT_R16G16B16A16_SINT            = 14
	DXGI_FORMAT_R32G32_TYPELESS              = 15
	DXGI_FORMAT_R32G32_FLOAT                 = 16
	DXGI_FORMAT_R32G32_UINT                  = 17
	DXGI_FORMAT_R32G32_SINT                  = 18
	DXGI_FORMAT_R32G8X24_TYPELESS            = 19
	DXGI_FORMAT_D32_FLOAT_S8X24_UINT         = 20
	DXGI_FORMAT_R32_FLOAT_X8X24_TYPELESS     = 21
	DXGI_FORMAT_X32_TYPELESS_G8X24_UINT      = 22
	DXGI_FORMAT_R10G10B10A2_TYPELESS         = 23
	DXGI_FORMAT_R10G10B10A2_UNORM            = 24
	DXGI_FORMAT_R10G10B10A2_UINT             = 25
	DXGI_FORMAT_R11G11B10_FLOAT              = 26
	DXGI_FORMAT_R8G8B8A8_TYPELESS            = 27
	DXGI_FORMAT_R8G8B8A8_UNORM               = 28
	DXGI_FORMAT_R8G8B8A8_UNORM_SRGB          = 29
	DXGI_FORMAT_R8G8B8A8_UINT                = 30
	DXGI_FORMAT_R8G8B8A8_SNORM               = 31
	DXGI_FORMAT_R8G8B8A8_SINT                = 32
	DXGI_FORMAT_R16G16_TYPELESS              = 33
	DXGI_FORMAT_R16G16_FLOAT                 = 34
	DXGI_FORMAT_R16G16_UNORM                 = 35
	DXGI_FORMAT_R16G16_UINT                  = 36
	DXGI_FORMAT_R16G16_SNORM                 = 37
	DXGI_FORMAT_R16G16_SINT                  = 38
	DXGI_FORMAT_R32_TYPELESS                 = 39
	DXGI_FORMAT_D32_FLOAT                    = 40
	DXGI_FORMAT_R32_FLOAT                    = 41
	DXGI_FORMAT_R32_UINT                     = 42
	DXGI_FORMAT_R32_SINT                     = 43
	DXGI_FORMAT_R24G8_TYPELESS               = 44
	DXGI_FORMAT_D24_UNORM_S8_UINT            = 45
	DXGI_FORMAT_R24_UNORM_X8_TYPELESS        = 46
	DXGI_FORMAT_X24_TYPELESS_G8_UINT         = 47
	DXGI_FORMAT_R8G8_TYPELESS                = 48
	DXGI_FORMAT_R8G8_UNORM                   = 49
	DXGI_FORMAT_R8G8_UINT                    = 50
	DXGI_FORMAT_R8G8_SNORM                   = 51
	DXGI_FORMAT_R8G8_SINT                    = 52
	DXGI_FORMAT_R16_TYPELESS                 = 53
	DXGI_FORMAT_R16_FLOAT                    = 54
	DXGI_FORMAT_D16_UNORM                    = 55
	DXGI_FORMAT_R16_UNORM                    = 56
	DXGI_FORMAT_R16_UINT                     = 57
	DXGI_FORMAT_R16_SNORM                    = 58
	DXGI_FORMAT_R16_SINT                     = 59
	DXGI_FORMAT_R8_TYPELESS                  = 60
	DXGI_FORMAT_R8_UNORM                     = 61
	DXGI_FORMAT_R8_UINT                      = 62
	DXGI_FORMAT_R8_SNORM                     = 63
	DXGI_FORMAT_R8_SINT                      = 64
	DXGI_FORMAT_A8_UNORM                     = 65
	DXGI_FORMAT_R1_UNORM                     = 66
	DXGI_FORMAT_R9G9B9E5_SHAREDEXP           = 67
	DXGI_FORMAT_R8G8_B8G8_UNORM              = 68
	DXGI_FORMAT_G8R8_G8B8_UNORM              = 69
	DXGI_FORMAT_BC1_TYPELESS                 = 70
	DXGI_FORMAT_BC1_UNORM                    = 71
	DXGI_FORMAT_BC1_UNORM_SRGB               = 72
	DXGI_FORMAT_BC2_TYPELESS                 = 73
	DXGI_FORMAT_BC2_UNORM                    = 74
	DXGI_FORMAT_BC2_UNORM_SRGB               = 75
	DXGI_FORMAT_BC3_TYPELESS                 = 76
	DXGI_FORMAT_BC3_UNORM                    = 77
	DXGI_FORMAT_BC3_UNORM_SRGB               = 78
	DXGI_FORMAT_BC4_TYPELESS                 = 79
	DXGI_FORMAT_BC4_UNORM                    = 80
	DXGI_FORMAT_BC4_SNORM                    = 81
	DXGI_FORMAT_BC5_TYPELESS                 = 82
	DXGI_FORMAT_BC5_UNORM                    = 83
	DXGI_FORMAT_BC5_SNORM                    = 84
	DXGI_FORMAT_B5G6R5_UNORM                 = 85
	DXGI_FORMAT_B5G5R5A1_UNORM               = 86
	DXGI_FORMAT_B8G8R8A8_UNORM               = 87
	DXGI_FORMAT_B8G8R8X8_UNORM               = 88
	DXGI_FORMAT_R10G10B10_XR_BIAS_A2_UNORM   = 89
	DXGI_FORMAT_B8G8R8A8_TYPELESS            = 90
	DXGI_FORMAT_B8G8R8A8_UNORM_SRGB          = 91
	DXGI_FORMAT_B8G8R8X8_TYPELESS            = 92
	DXGI_FORMAT_B8G8R8X8_UNORM_SRGB          = 93
	DXGI_FORMAT_BC6H_TYPELESS                = 94
	DXGI_FORMAT_BC6H_UF16                    = 95
	DXGI_FORMAT_BC6H_SF16                    = 96
	DXGI_FORMAT_BC7_TYPELESS                 = 97
	DXGI_FORMAT_BC7_UNORM                    = 98
	DXGI_FORMAT_BC7_UNORM_SRGB               = 99
	DXGI_FORMAT_FORCE_UINT                   = &hffffffff
End Enum

Type D2D1_ALPHA_MODE As Long
Enum
	D2D1_ALPHA_MODE_UNKNOWN         = 0
	D2D1_ALPHA_MODE_PREMULTIPLIED   = 1
	D2D1_ALPHA_MODE_STRAIGHT        = 2
	D2D1_ALPHA_MODE_IGNORE          = 3
End Enum

Type D2D1_ANTIALIAS_MODE As Long
Enum
	D2D1_ANTIALIAS_MODE_PER_PRIMITIVE   = 0
	D2D1_ANTIALIAS_MODE_ALIASED         = 1
End Enum

Type D2D1_ARC_SIZE As Long
Enum
	D2D1_ARC_SIZE_SMALL   = 0
	D2D1_ARC_SIZE_LARGE   = 1
End Enum

Enum
	D2D1_INTERPOLATION_MODE_DEFINITION_NEAREST_NEIGHBOR    = 0
	D2D1_INTERPOLATION_MODE_DEFINITION_LINEAR              = 1
	D2D1_INTERPOLATION_MODE_DEFINITION_CUBIC               = 2
	D2D1_INTERPOLATION_MODE_DEFINITION_MULTI_SAMPLE_LINEAR = 3
	D2D1_INTERPOLATION_MODE_DEFINITION_ANISOTROPIC         = 4
	D2D1_INTERPOLATION_MODE_DEFINITION_HIGH_QUALITY_CUBIC  = 5
	D2D1_INTERPOLATION_MODE_DEFINITION_FANT                = 6
	D2D1_INTERPOLATION_MODE_DEFINITION_MIPMAP_LINEAR       = 7
End Enum

Type D2D1_BITMAP_INTERPOLATION_MODE As Long
Enum
	D2D1_BITMAP_INTERPOLATION_MODE_NEAREST_NEIGHBOR   = 0
	D2D1_BITMAP_INTERPOLATION_MODE_LINEAR             = 1
End Enum

Type D2D1_CAP_STYLE As Long
Enum
	D2D1_CAP_STYLE_FLAT       = 0
	D2D1_CAP_STYLE_SQUARE     = 1
	D2D1_CAP_STYLE_ROUND      = 2
	D2D1_CAP_STYLE_TRIANGLE   = 3
End Enum

Type D2D1_COMBINE_MODE As Long
Enum
	D2D1_COMBINE_MODE_UNION       = 0
	D2D1_COMBINE_MODE_INTERSECT   = 1
	D2D1_COMBINE_MODE_XOR         = 2
	D2D1_COMBINE_MODE_EXCLUDE     = 3
End Enum

Type D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS As Long
Enum
	D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS_NONE             = &h00000000
	D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS_GDI_COMPATIBLE   = &h00000001
End Enum

Type D2D1_DASH_STYLE As Long
Enum
	D2D1_DASH_STYLE_SOLID          = 0
	D2D1_DASH_STYLE_DASH           = 1
	D2D1_DASH_STYLE_DOT            = 2
	D2D1_DASH_STYLE_DASH_DOT       = 3
	D2D1_DASH_STYLE_DASH_DOT_DOT   = 4
	D2D1_DASH_STYLE_CUSTOM         = 5
End Enum

Type D2D1_DC_INITIALIZE_MODE As Long
Enum
	D2D1_DC_INITIALIZE_MODE_COPY    = 0
	D2D1_DC_INITIALIZE_MODE_CLEAR   = 1
End Enum

Type D2D1_DEBUG_LEVEL As Long
Enum
	D2D1_DEBUG_LEVEL_NONE          = 0
	D2D1_DEBUG_LEVEL_ERROR         = 1
	D2D1_DEBUG_LEVEL_WARNING       = 2
	D2D1_DEBUG_LEVEL_INFORMATION   = 3
End Enum

Type D2D1_DRAW_TEXT_OPTIONS As Long
Enum
	D2D1_DRAW_TEXT_OPTIONS_NO_SNAP   = &h00000001
	D2D1_DRAW_TEXT_OPTIONS_CLIP      = &h00000002
	D2D1_DRAW_TEXT_OPTIONS_ENABLE_COLOR_FONT = &h00000004
	D2D1_DRAW_TEXT_OPTIONS_NONE      = &h00000000
	D2D1_DRAW_TEXT_OPTIONS_FORCE_DWORD = &hffffffff
End Enum

Type D2D1_EXTEND_MODE As Long
Enum
	D2D1_EXTEND_MODE_CLAMP    = 0
	D2D1_EXTEND_MODE_WRAP     = 1
	D2D1_EXTEND_MODE_MIRROR   = 2
End Enum

Type D2D1_FACTORY_TYPE As Long
Enum
	D2D1_FACTORY_TYPE_SINGLE_THREADED   = 0
	D2D1_FACTORY_TYPE_MULTI_THREADED    = 1
End Enum

Type D2D1_FEATURE_LEVEL As Long
Enum
	D2D1_FEATURE_LEVEL_DEFAULT   = 0
	D2D1_FEATURE_LEVEL_9         = D3D10_FEATURE_LEVEL_9_1
	D2D1_FEATURE_LEVEL_10        = D3D10_FEATURE_LEVEL_10_0
End Enum

Type D3D10_FEATURE_LEVEL1 As Long
Enum
	D3D10_FEATURE_LEVEL_10_0   = &ha000
	D3D10_FEATURE_LEVEL_10_1   = &ha100
	D3D10_FEATURE_LEVEL_9_1    = &h9100
	D3D10_FEATURE_LEVEL_9_2    = &h9200
	D3D10_FEATURE_LEVEL_9_3    = &h9300
End Enum

Type D2D1_FIGURE_BEGIN As Long
Enum
	D2D1_FIGURE_BEGIN_FILLED   = 0
	D2D1_FIGURE_BEGIN_HOLLOW   = 1
End Enum

Type D2D1_FIGURE_END As Long
Enum
	D2D1_FIGURE_END_OPEN     = 0
	D2D1_FIGURE_END_CLOSED   = 1
End Enum

Type D2D1_FILL_MODE As Long
Enum
	D2D1_FILL_MODE_ALTERNATE   = 0
	D2D1_FILL_MODE_WINDING     = 1
End Enum

Type D2D1_GAMMA As Long
Enum
	D2D1_GAMMA_2_2   = 0
	D2D1_GAMMA_1_0   = 1
End Enum

Type D2D1_GEOMETRY_RELATION As Long
Enum
	D2D1_GEOMETRY_RELATION_UNKNOWN        = 0
	D2D1_GEOMETRY_RELATION_DISJOINT       = 1
	D2D1_GEOMETRY_RELATION_IS_CONTAINED   = 2
	D2D1_GEOMETRY_RELATION_CONTAINS       = 3
	D2D1_GEOMETRY_RELATION_OVERLAP        = 4
End Enum

Type D2D1_GEOMETRY_SIMPLIFICATION_OPTION As Long
Enum
	D2D1_GEOMETRY_SIMPLIFICATION_OPTION_CUBICS_AND_LINES   = 0
	D2D1_GEOMETRY_SIMPLIFICATION_OPTION_LINES              = 1
End Enum

Type D2D1_LAYER_OPTIONS As Long
Enum
	D2D1_LAYER_OPTIONS_NONE                       = &h00000000
	D2D1_LAYER_OPTIONS_INITIALIZE_FOR_CLEARTYPE   = &h00000001
End Enum ' D2D1_LAYER_OPTIONS;

Type D2D1_LINE_JOIN As Long
Enum
	D2D1_LINE_JOIN_MITER            = 0
	D2D1_LINE_JOIN_BEVEL            = 1
	D2D1_LINE_JOIN_ROUND            = 2
	D2D1_LINE_JOIN_MITER_OR_BEVEL   = 3
End Enum

Type D2D1_OPACITY_MASK_CONTENT As Long
Enum
	D2D1_OPACITY_MASK_CONTENT_GRAPHICS              = 0
	D2D1_OPACITY_MASK_CONTENT_TEXT_NATURAL          = 1
	D2D1_OPACITY_MASK_CONTENT_TEXT_GDI_COMPATIBLE   = 2
End Enum

Type D2D1_PATH_SEGMENT As Long
Enum
	D2D1_PATH_SEGMENT_NONE                    = &h00000000
	D2D1_PATH_SEGMENT_FORCE_UNSTROKED         = &h00000001
	D2D1_PATH_SEGMENT_FORCE_ROUND_LINE_JOIN   = &h00000002
End Enum ' D2D1_PATH_SEGMENT;

Type D2D1_PRESENT_OPTIONS As Long
Enum
	D2D1_PRESENT_OPTIONS_NONE              = &h00000000
	D2D1_PRESENT_OPTIONS_RETAIN_CONTENTS   = &h00000001
	D2D1_PRESENT_OPTIONS_IMMEDIATELY       = &h00000002
End Enum

Type D2D1_RENDER_TARGET_TYPE As Long
Enum
	D2D1_RENDER_TARGET_TYPE_DEFAULT     = 0
	D2D1_RENDER_TARGET_TYPE_SOFTWARE    = 1
	D2D1_RENDER_TARGET_TYPE_HARDWARE    = 2
End Enum

Type D2D1_RENDER_TARGET_USAGE As Long
Enum
	D2D1_RENDER_TARGET_USAGE_NONE                    = &h00000000
	D2D1_RENDER_TARGET_USAGE_FORCE_BITMAP_REMOTING   = &h00000001
	D2D1_RENDER_TARGET_USAGE_GDI_COMPATIBLE          = &h00000002
End Enum

Type D2D1_SWEEP_DIRECTION As Long
Enum
	D2D1_SWEEP_DIRECTION_COUNTER_CLOCKWISE   = 0
	D2D1_SWEEP_DIRECTION_CLOCKWISE           = 1
End Enum

Type D2D1_TEXT_ANTIALIAS_MODE As Long
Enum
	D2D1_TEXT_ANTIALIAS_MODE_DEFAULT     = 0
	D2D1_TEXT_ANTIALIAS_MODE_CLEARTYPE   = 1
	D2D1_TEXT_ANTIALIAS_MODE_GRAYSCALE   = 2
	D2D1_TEXT_ANTIALIAS_MODE_ALIASED     = 3
End Enum

Type D2D1_WINDOW_STATE As Long
Enum
	D2D1_WINDOW_STATE_NONE       = &h0000000
	D2D1_WINDOW_STATE_OCCLUDED   = &h0000001
End Enum

Type DWRITE_TEXT_METRICS
	left As FLOAT
	top As FLOAT
	width As FLOAT
	widthIncludingTrailingWhitespace As FLOAT
	height As FLOAT
	layoutWidth As FLOAT
	layoutHeight As FLOAT
	maxBidiReorderingDepth As UINT32
	lineCount As UINT32
End Type

Type IDWriteTextFormatVtbl
	' IUnknown
	QueryInterface           As Function(this As Any Ptr, riid As Const GUID Ptr, ppv As Any Ptr Ptr) As HRESULT
	AddRef                   As Function(this As Any Ptr) As HRESULT
	Release                  As Function(this As Any Ptr) As HRESULT
End Type

Type IDWriteTextFormat
	lpVtbl As IDWriteTextFormatVtbl Ptr
End Type

Type IDWriteTextLayoutVtbl
    ' IUnknown
    QueryInterface As Function(This As Any Ptr, riid As Const GUID Ptr, ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(This As Any Ptr) As ULong
    Release As Function(This As Any Ptr) As ULong

    ' IDWriteTextFormat (наследуется)
    SetTextAlignment As Function(This As Any Ptr, textAlignment As Long) As HRESULT
    SetParagraphAlignment As Function(This As Any Ptr, paragraphAlignment As Long) As HRESULT
    SetWordWrapping As Function(This As Any Ptr, wordWrapping As Long) As HRESULT
    SetReadingDirection As Function(This As Any Ptr, readingDirection As Long) As HRESULT
    SetFlowDirection As Function(This As Any Ptr, flowDirection As Long) As HRESULT
    SetIncrementalTabStop As Function(This As Any Ptr, incrementalTabStop As Single) As HRESULT
    SetTrimming As Function(This As Any Ptr, trimmingOptions As Any Ptr, trimmingSign As Any Ptr) As HRESULT
    SetLineSpacing As Function(This As Any Ptr, lineSpacingMethod As Long, lineSpacing As Single, baseline As Single) As HRESULT
    GetTextAlignment As Function(This As Any Ptr) As Long
    GetParagraphAlignment As Function(This As Any Ptr) As Long
    GetWordWrapping As Function(This As Any Ptr) As Long
    GetReadingDirection As Function(This As Any Ptr) As Long
    GetFlowDirection As Function(This As Any Ptr) As Long
    GetIncrementalTabStop As Function(This As Any Ptr) As Single
    GetTrimming As Function(This As Any Ptr, trimmingOptions As Any Ptr, trimmingSign As Any Ptr) As HRESULT
    GetLineSpacing As Function(This As Any Ptr, lineSpacingMethod As Long Ptr, lineSpacing As Single Ptr, baseline As Single Ptr) As HRESULT
    GetFontCollection As Function(This As Any Ptr, fontCollection As Any Ptr Ptr) As HRESULT
    GetFontFamilyNameLength As Function(This As Any Ptr) As UInteger
    GetFontFamilyName As Function(This As Any Ptr, fontFamilyName As WString Ptr, nameSize As UInteger) As HRESULT
    GetFontWeight As Function(This As Any Ptr) As Long
    GetFontStyle As Function(This As Any Ptr) As Long
    GetFontStretch As Function(This As Any Ptr) As Long
    GetFontSize As Function(This As Any Ptr) As Single
    GetLocaleNameLength As Function(This As Any Ptr) As UInteger
    GetLocaleName As Function(This As Any Ptr, localeName As WString Ptr, nameSize As UInteger) As HRESULT

    ' IDWriteTextLayout
    SetMaxWidth As Function(This As Any Ptr, maxWidth As Single) As HRESULT
    SetMaxHeight As Function(This As Any Ptr, maxHeight As Single) As HRESULT
    SetFontCollection_ As Function(This As Any Ptr, fontCollection As Any Ptr, textRange As Any Ptr) As HRESULT
    SetFontFamilyName_ As Function(This As Any Ptr, fontFamilyName As WString Ptr, textRange As Any Ptr) As HRESULT
    SetFontWeight_ As Function(This As Any Ptr, fontWeight As Long, textRange As Any Ptr) As HRESULT
    SetFontStyle_ As Function(This As Any Ptr, fontStyle As Long, textRange As Any Ptr) As HRESULT
    SetFontStretch_ As Function(This As Any Ptr, fontStretch As Long, textRange As Any Ptr) As HRESULT
    SetFontSize_ As Function(This As Any Ptr, fontSize As Single, textRange As Any Ptr) As HRESULT
    SetUnderline As Function(This As Any Ptr, hasUnderline As Long, textRange As Any Ptr) As HRESULT
    SetStrikethrough As Function(This As Any Ptr, hasStrikethrough As Long, textRange As Any Ptr) As HRESULT
    SetDrawingEffect As Function(This As Any Ptr, drawingEffect As Any Ptr, textRange As Any Ptr) As HRESULT
    SetInlineObject As Function(This As Any Ptr, inlineObject As Any Ptr, textRange As Any Ptr) As HRESULT
    SetTypography As Function(This As Any Ptr, typography As Any Ptr, textRange As Any Ptr) As HRESULT
    SetLocaleName_ As Function(This As Any Ptr, localeName As WString Ptr, textRange As Any Ptr) As HRESULT
    GetMaxWidth As Function(This As Any Ptr) As Single
    GetMaxHeight As Function(This As Any Ptr) As Single
    GetFontCollection_ As Function(This As Any Ptr, currentPosition As UInteger, fontCollection As Any Ptr Ptr, textRange As Any Ptr) As HRESULT
    GetFontFamilyNameLength_ As Function(This As Any Ptr, currentPosition As UInteger, nameLength As UInteger Ptr, textRange As Any Ptr) As HRESULT
    GetFontFamilyName_ As Function(This As Any Ptr, currentPosition As UInteger, fontFamilyName As WString Ptr, nameSize As UInteger, textRange As Any Ptr) As HRESULT
    GetFontWeight_ As Function(This As Any Ptr, currentPosition As UInteger, fontWeight As Long Ptr, textRange As Any Ptr) As HRESULT
    GetFontStyle_ As Function(This As Any Ptr, currentPosition As UInteger, fontStyle As Long Ptr, textRange As Any Ptr) As HRESULT
    GetFontStretch_ As Function(This As Any Ptr, currentPosition As UInteger, fontStretch As Long Ptr, textRange As Any Ptr) As HRESULT
    GetFontSize_ As Function(This As Any Ptr, currentPosition As UInteger, fontSize As Single Ptr, textRange As Any Ptr) As HRESULT
    GetUnderline As Function(This As Any Ptr, currentPosition As UInteger, hasUnderline As Long Ptr, textRange As Any Ptr) As HRESULT
    GetStrikethrough As Function(This As Any Ptr, currentPosition As UInteger, hasStrikethrough As Long Ptr, textRange As Any Ptr) As HRESULT
    GetDrawingEffect As Function(This As Any Ptr, currentPosition As UInteger, drawingEffect As Any Ptr Ptr, textRange As Any Ptr) As HRESULT
    GetInlineObject As Function(This As Any Ptr, currentPosition As UInteger, inlineObject As Any Ptr Ptr, textRange As Any Ptr) As HRESULT
    GetTypography As Function(This As Any Ptr, currentPosition As UInteger, typography As Any Ptr Ptr, textRange As Any Ptr) As HRESULT
    GetLocaleNameLength_ As Function(This As Any Ptr, currentPosition As UInteger, nameLength As UInteger Ptr, textRange As Any Ptr) As HRESULT
    GetLocaleName_ As Function(This As Any Ptr, currentPosition As UInteger, localeName As WString Ptr, nameSize As UInteger, textRange As Any Ptr) As HRESULT
    Draw As Function(This As Any Ptr, clientDrawingContext As Any Ptr, renderer As Any Ptr, originX As Single, originY As Single) As HRESULT
    GetLineMetrics As Function(This As Any Ptr, lineMetrics As Any Ptr, maxLineCount As UInteger, actualLineCount As UInteger Ptr) As HRESULT
    GetMetrics As Function(This As Any Ptr, textMetrics As Any Ptr) As HRESULT
    GetOverhangMetrics As Function(This As Any Ptr, overhangs As Any Ptr) As HRESULT
    GetClusterMetrics As Function(This As Any Ptr, clusterMetrics As Any Ptr, maxClusterCount As UInteger, actualClusterCount As UInteger Ptr) As HRESULT
    DetermineMinWidth As Function(This As Any Ptr, minWidth As Single Ptr) As HRESULT
    HitTestPoint As Function(This As Any Ptr, pointX As Single, pointY As Single, isTrailingHit As Long Ptr, isInside As Long Ptr, hitTestMetrics As Any Ptr) As HRESULT
    HitTestTextPosition As Function(This As Any Ptr, textPosition As UInteger, isTrailingHit As Long, pointX As Single Ptr, pointY As Single Ptr, hitTestMetrics As Any Ptr) As HRESULT
    HitTestTextRange As Function(This As Any Ptr, textPosition As UInteger, textLength As UInteger, originX As Single, originY As Single, hitTestMetrics As Any Ptr, maxHitTestMetricsCount As UInteger, actualHitTestMetricsCount As UInteger Ptr) As HRESULT
End Type

Type IDWriteTextLayout
	lpVtbl As IDWriteTextLayoutVtbl Ptr
End Type

Type IDWriteFontCollection
	lpVtbl As Any Ptr
End Type

Type D2D1_FACTORY_OPTIONS
    debugLevel As Long
End Type

Type ID2D1Factory
	lpVtbl As Any Ptr
End Type

Type ID2D1SolidColorBrushVtbl
	' IUnknown
	QueryInterface           As Function(this As Any Ptr, riid As Const GUID Ptr, ppv As Any Ptr Ptr) As HRESULT
	AddRef                   As Function(this As Any Ptr) As HRESULT
	Release                  As Function(this As Any Ptr) As HRESULT
End Type

Type ID2D1SolidColorBrush
	lpVtbl As ID2D1SolidColorBrushVtbl Ptr
End Type

Type D2D1_POINT_2F
	x As Single
	y As Single
End Type

Type D2D1_RECT_F
	left As FLOAT
	top As FLOAT
	right As FLOAT
	bottom As FLOAT
End Type

Type D2D1_SIZE_U
	Width As ULong
	height As ULong
End Type

Type D2D1_SIZE_F
	Width As Single
	height As Single
End Type

Type D2D1_PIXEL_FORMAT
	format     As ULong
	alphaMode  As ULong
End Type

Type D2D1_MATRIX_3X2_F
	m11 As Single : m12 As Single
	m21 As Single : m22 As Single
	dx  As Single : dy  As Single
End Type

Enum D2D1_UNIT_MODE
    D2D1_UNIT_MODE_DIPS = 0
    D2D1_UNIT_MODE_PIXELS = 1
    D2D1_UNIT_MODE_FORCE_DWORD = &hffffffff
End Enum

Function D2D1Matrix3x2F_Identity() As D2D1_MATRIX_3X2_F
    Return Type<D2D1_MATRIX_3X2_F>( _
        1.0f, 0.0f, _
        0.0f, 1.0f, _
        0.0f, 0.0f)
End Function

Type D2D1_BRUSH_PROPERTIES
	opacity As Single
	transform As D2D1_MATRIX_3X2_F
End Type

Type D2D1_ROUNDED_RECT
	rect As D2D1_RECT_F
	radiusX As Single
	radiusY As Single
End Type

Type D2D1_ELLIPSE
	point As D2D1_POINT_2F
	radiusX As Single
	radiusY As Single
End Type

Type D2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES
	startPoint As D2D1_POINT_2F
	endPoint As D2D1_POINT_2F
End Type

Type D2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES
	center As D2D1_POINT_2F
	gradientOriginOffset As D2D1_POINT_2F
	radiusX As Single
	radiusY As Single
End Type

Type D2D1_COLOR_F
	r As Single
	g As Single
	b As Single
	a As Single
End Type

Type D2D1_GRADIENT_STOP
	position As Single
	color As D2D1_COLOR_F
End Type

Type D2D1_BITMAP_PROPERTIES
	pixelFormat As D2D1_PIXEL_FORMAT
	dpiX As Single
	dpiY As Single
End Type

Type D2D1_LAYER_PARAMETERS
	contentBounds As D2D1_RECT_F
	geometricMask As Any Ptr
	maskAntialiasMode As Long ' D2D1_ANTIALIAS_MODE
	maskTransform As D2D1_MATRIX_3X2_F
	opacity As Single
	opacityBrush As Any Ptr
	layerOptions As Long ' D2D1_LAYER_OPTIONS
End Type

' DWRITE_GLYPH_RUN (from DirectWrite)
Type DWRITE_GLYPH_RUN
	fontFace As Any Ptr
	fontEmSize As Single
	glyphCount As UINT32
	glyphIndices As UShort Ptr
	glyphAdvances As Single Ptr
	glyphOffsets As Const Any Ptr ' technically DWRITE_GLYPH_OFFSET ptr
	isSideways As BOOL
	bidiLevel As UINT32
End Type

Type D2D1_BITMAP_BRUSH_PROPERTIES
	extendModeX As Long ' D2D1_EXTEND_MODE
	extendModeY As Long ' D2D1_EXTEND_MODE
	interpolationMode As Long ' D2D1_BITMAP_INTERPOLATION_MODE
End Type

Type D2D1_HWND_RENDER_TARGET_PROPERTIES
	hwnd As HWND
	pixelSize As D2D1_SIZE_U
	presentOptions As D2D1_PRESENT_OPTIONS
End Type

Type D2D1_RENDER_TARGET_PROPERTIES
	type_ As D2D1_RENDER_TARGET_TYPE
	pixelFormat As D2D1_PIXEL_FORMAT
	dpiX As FLOAT
	dpiY As FLOAT
	usage As D2D1_RENDER_TARGET_USAGE
	minLevel As D2D1_FEATURE_LEVEL
End Type

Type ID2D1BrushVtbl
	' IUnknown
	QueryInterface           As Function(this As Any Ptr, riid As Const GUID Ptr, ppv As Any Ptr Ptr) As HRESULT
	AddRef                   As Function(this As Any Ptr) As HRESULT
	Release                  As Function(this As Any Ptr) As HRESULT
End Type

Type ID2D1Brush
	lpVtbl As ID2D1BrushVtbl Ptr
End Type

Type ID2D1StrokeStyle
	lpVtbl As Any Ptr
End Type

Type D2D1_BEZIER_SEGMENT
    point1 As D2D1_POINT_2F
    point2 As D2D1_POINT_2F
    point3 As D2D1_POINT_2F
End Type

Type D2D1_QUADRATIC_BEZIER_SEGMENT
    point1 As D2D1_POINT_2F
    point2 As D2D1_POINT_2F
End Type

Type D2D1_ARC_SEGMENT
    point As D2D1_POINT_2F
    size As D2D1_SIZE_F
    rotationAngle As Single
    sweepDirection As D2D1_SWEEP_DIRECTION
    arcSize As D2D1_ARC_SIZE
End Type

Type ID2D1GeometrySinkVtbl
    ' IUnknown
    QueryInterface As Function(This As Any Ptr, riid As Const GUID Ptr, ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(This As Any Ptr) As ULong
    Release As Function(This As Any Ptr) As ULong

    ' ID2D1SimplifiedGeometrySink
    SetFillMode As Sub(This As Any Ptr, fillMode As D2D1_FILL_MODE)
    SetSegmentFlags As Sub(This As Any Ptr, vertexFlags As D2D1_PATH_SEGMENT)
    BeginFigure As Sub(This As Any Ptr, startPoint As D2D1_POINT_2F, figureBegin As D2D1_FIGURE_BEGIN)
    AddLines As Sub(This As Any Ptr, points As Const D2D1_POINT_2F Ptr, pointsCount As UInteger)
    AddBeziers As Sub(This As Any Ptr, beziers As Const D2D1_BEZIER_SEGMENT Ptr, beziersCount As UInteger)
    EndFigure As Sub(This As Any Ptr, figureEnd As D2D1_FIGURE_END)
    Close As Function(This As Any Ptr) As HRESULT

    ' ID2D1GeometrySink
    AddLine As Sub(This As Any Ptr, point As D2D1_POINT_2F)
    AddBezier As Sub(This As Any Ptr, bezier As Const D2D1_BEZIER_SEGMENT Ptr)
    AddQuadraticBezier As Sub(This As Any Ptr, bezier As Const D2D1_QUADRATIC_BEZIER_SEGMENT Ptr)
    AddQuadraticBeziers As Sub(This As Any Ptr, beziers As Const D2D1_QUADRATIC_BEZIER_SEGMENT Ptr, beziersCount As UInteger)
    AddArc As Sub(This As Any Ptr, arc As Const D2D1_ARC_SEGMENT Ptr)
End Type

Type ID2D1GeometrySink
    lpVtbl As ID2D1GeometrySinkVtbl Ptr
End Type

Type ID2D1PathGeometryVtbl
    ' IUnknown
    QueryInterface As Function(This As Any Ptr, riid As Const GUID Ptr, ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(This As Any Ptr) As ULong
    Release As Function(This As Any Ptr) As ULong

    ' ID2D1Resource
    GetFactory As Sub(This As Any Ptr, ppFactory As Any Ptr Ptr)

    ' ID2D1Geometry
    GetBounds As Function(This As Any Ptr, worldTransform As Const Any Ptr, bounds As Any Ptr) As HRESULT
    GetWidenedBounds As Function(This As Any Ptr, strokeWidth As Single, strokeStyle As Any Ptr, worldTransform As Const Any Ptr, flatteningTolerance As Single, bounds As Any Ptr) As HRESULT
    StrokeContainsPoint As Function(This As Any Ptr, point As D2D1_POINT_2F, strokeWidth As Single, strokeStyle As Any Ptr, worldTransform As Const Any Ptr, flatteningTolerance As Single, contains As Integer Ptr) As HRESULT
    FillContainsPoint As Function(This As Any Ptr, point As D2D1_POINT_2F, worldTransform As Const Any Ptr, flatteningTolerance As Single, contains As Integer Ptr) As HRESULT
    CompareWithGeometry As Function(This As Any Ptr, inputGeometry As Any Ptr, inputTransform As Const Any Ptr, relation As Long Ptr) As HRESULT
    Simplify As Function(This As Any Ptr, simplificationOption As Long, worldTransform As Const Any Ptr, flatteningTolerance As Single, geometrySink As Any Ptr) As HRESULT
    Tessellate As Function(This As Any Ptr, worldTransform As Const Any Ptr, flatteningTolerance As Single, tessellationSink As Any Ptr) As HRESULT
    CombineWithGeometry As Function(This As Any Ptr, inputGeometry As Any Ptr, combineMode As Long, inputTransform As Const Any Ptr, flatteningTolerance As Single, geometrySink As Any Ptr) As HRESULT
    Outline As Function(This As Any Ptr, worldTransform As Const Any Ptr, flatteningTolerance As Single, geometrySink As Any Ptr) As HRESULT
    ComputeArea As Function(This As Any Ptr, worldTransform As Const Any Ptr, flatteningTolerance As Single, area As Single Ptr) As HRESULT
    ComputeLength As Function(This As Any Ptr, worldTransform As Const Any Ptr, flatteningTolerance As Single, length As Single Ptr) As HRESULT
    ComputePointAtLength As Function(This As Any Ptr, length As Single, worldTransform As Const Any Ptr, flatteningTolerance As Single, point As D2D1_POINT_2F Ptr, unitTangentVector As D2D1_POINT_2F Ptr) As HRESULT
    Widen As Function(This As Any Ptr, strokeWidth As Single, strokeStyle As Any Ptr, worldTransform As Const Any Ptr, flatteningTolerance As Single, geometrySink As Any Ptr) As HRESULT

    ' ID2D1PathGeometry
    Open As Function(This As Any Ptr, ppSink As ID2D1GeometrySink Ptr Ptr) As HRESULT
    Stream As Function(This As Any Ptr, geometrySink As Any Ptr) As HRESULT
    GetSegmentCount As Function(This As Any Ptr, count As UInteger Ptr) As HRESULT
    GetFigureCount As Function(This As Any Ptr, count As UInteger Ptr) As HRESULT
End Type

Type ID2D1PathGeometry
    lpVtbl As ID2D1PathGeometryVtbl Ptr
End Type

Type D2D1_TAG As UINT64

Type ID2D1RenderTargetVtbl
	' IUnknown
	QueryInterface           As Function(this As Any Ptr, riid As Const GUID Ptr, ppv As Any Ptr Ptr) As HRESULT
	AddRef                   As Function(this As Any Ptr) As HRESULT
	Release                  As Function(this As Any Ptr) As HRESULT
	
	' ID2D1Resource
	GetFactory               As Sub(this As Any Ptr, factory As Any Ptr Ptr)
	
	' ID2D1RenderTarget
	CreateBitmap             As Function(this As Any Ptr, size As D2D1_SIZE_U, srcData As Any Ptr, pitch As UINT32, bitmapProperties As Const D2D1_BITMAP_PROPERTIES Ptr, bitmap As Any Ptr Ptr) As HRESULT
	CreateBitmapFromWicBitmap As Function(this As Any Ptr, wicBitmapSource As Any Ptr, bitmapProperties As Const D2D1_BITMAP_PROPERTIES Ptr, bitmap As Any Ptr Ptr) As HRESULT
	CreateSharedBitmap       As Function(this As Any Ptr, riid As Const GUID Ptr, data As Any Ptr, bitmapProperties As Const D2D1_BITMAP_PROPERTIES Ptr, bitmap As Any Ptr Ptr) As HRESULT
	CreateBitmapBrush        As Function(this As Any Ptr, bitmap As Any Ptr, brushProperties As Const D2D1_BITMAP_BRUSH_PROPERTIES Ptr, brushProps As Const D2D1_BRUSH_PROPERTIES Ptr, brush As Any Ptr Ptr) As HRESULT
	CreateSolidColorBrush    As Function(this As Any Ptr, color As Const D2D1_COLOR_F Ptr, brushProperties As Const D2D1_BRUSH_PROPERTIES Ptr, brush As Any Ptr Ptr) As HRESULT
	CreateGradientStopCollection As Function(this As Any Ptr, gradientStops As Const D2D1_GRADIENT_STOP Ptr, gradientStopCount As UINT32, colorInterpolationGamma As D2D1_GAMMA, extendMode As D2D1_EXTEND_MODE, stopCollection As Any Ptr Ptr) As HRESULT
	CreateLinearGradientBrush As Function(this As Any Ptr, brushProperties As Const D2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES Ptr, brushProps As Const D2D1_BRUSH_PROPERTIES Ptr, brush As Any Ptr Ptr) As HRESULT
	CreateRadialGradientBrush As Function(this As Any Ptr, brushProperties As Const D2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES Ptr, brushProps As Const D2D1_BRUSH_PROPERTIES Ptr, brush As Any Ptr Ptr) As HRESULT
	CreateCompatibleRenderTarget As Function(this As Any Ptr, desiredSize As Const D2D1_SIZE_F Ptr, desiredPixelSize As Const D2D1_SIZE_U Ptr, desiredFormat As Const D2D1_PIXEL_FORMAT Ptr, options As D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS, renderTarget As Any Ptr Ptr) As HRESULT
	CreateLayer              As Function(this As Any Ptr, size As Const D2D1_SIZE_F Ptr, layer As Any Ptr Ptr) As HRESULT
	CreateMesh               As Function(this As Any Ptr, mesh As Any Ptr Ptr) As HRESULT
	DrawLine                 As Sub(ByVal this As Any Ptr, ByVal point0 As Const D2D1_POINT_2F, ByVal point1 As Const D2D1_POINT_2F, ByVal brush As Any Ptr, ByVal strokeWidth As FLOAT = 1.0f, ByVal strokeStyle As ID2D1StrokeStyle Ptr = NULL)
	DrawRectangle            As Sub(this As Any Ptr, rect As Const D2D1_RECT_F Ptr, brush As ID2D1Brush Ptr, strokeWidth As FLOAT = 1.0f, strokeStyle As ID2D1StrokeStyle Ptr = NULL)
	FillRectangle            As Sub(this As Any Ptr, rect As Const D2D1_RECT_F Ptr, brush As Any Ptr)
	DrawRoundedRectangle     As Sub(this As Any Ptr, rect As Const D2D1_ROUNDED_RECT Ptr, brush As Any Ptr, strokeWidth As FLOAT = 1.0f, strokeStyle As ID2D1StrokeStyle Ptr = NULL)
	FillRoundedRectangle     As Sub(this As Any Ptr, rect As Const D2D1_ROUNDED_RECT Ptr, brush As Any Ptr)
	DrawEllipse              As Sub(this As Any Ptr, ellipse As Const D2D1_ELLIPSE, brush As Any Ptr, strokeWidth As Single, strokeStyle As Any Ptr)
	FillEllipse              As Sub(this As Any Ptr, ellipse As Const D2D1_ELLIPSE, brush As Any Ptr)
	DrawGeometry             As Sub(this As Any Ptr, geometry As Any Ptr, brush As Any Ptr, strokeWidth As Single, strokeStyle As Any Ptr)
	FillGeometry             As Sub(this As Any Ptr, geometry As Any Ptr, brush As Any Ptr, opacityBrush As Any Ptr)
	FillMesh                 As Sub(this As Any Ptr, mesh As Any Ptr, brush As Any Ptr)
	FillOpacityMask          As Sub(this As Any Ptr, opacityMask As Any Ptr, brush As Any Ptr, content As D2D1_OPACITY_MASK_CONTENT, destinationRect As Const D2D1_RECT_F Ptr, sourceRect As Const D2D1_RECT_F Ptr)
	DrawBitmap               As Sub(this As Any Ptr, bitmap As Any Ptr, destinationRect As Const D2D1_RECT_F Ptr, opacity As Single, interpolationMode As D2D1_BITMAP_INTERPOLATION_MODE, sourceRect As Const D2D1_RECT_F Ptr)
	DrawText                 As Sub(this As Any Ptr, text As WString Ptr, textLength As UINT32, textFormat As Any Ptr, layoutRect As Const D2D1_RECT_F Ptr, defaultForegroundBrush As Any Ptr, options As UINT32, measuringMode As UINT32)
	DrawTextLayout           As Sub(this As Any Ptr, ByVal origin As Const D2D1_POINT_2F, ByVal textLayout As Any Ptr, ByVal defaultForegroundBrush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS = D2D1_DRAW_TEXT_OPTIONS_NONE)
	DrawGlyphRun             As Sub(this As Any Ptr, baselineOrigin As Const D2D1_POINT_2F Ptr, glyphRun As Const DWRITE_GLYPH_RUN Ptr, foregroundBrush As Any Ptr, measuringMode As UINT32)
	SetTransform             As Sub(this As Any Ptr, transform As Const D2D1_MATRIX_3X2_F Ptr)
	GetTransform             As Sub(this As Any Ptr, transform As D2D1_MATRIX_3X2_F Ptr)
	SetAntialiasMode         As Sub(this As Any Ptr, mode As D2D1_ANTIALIAS_MODE)
	GetAntialiasMode         As Function(this As Any Ptr) As D2D1_ANTIALIAS_MODE
	SetTextAntialiasMode     As Sub(this As Any Ptr, mode As D2D1_TEXT_ANTIALIAS_MODE)
	GetTextAntialiasMode     As Function(this As Any Ptr) As D2D1_TEXT_ANTIALIAS_MODE
	SetTextRenderingParams   As Sub(this As Any Ptr, params As Any Ptr)
	GetTextRenderingParams   As Sub(this As Any Ptr, params As Any Ptr Ptr)
	SetTags                  As Sub(this As Any Ptr, tag1 As ULONGLONG, tag2 As ULONGLONG)
	GetTags                  As Sub(this As Any Ptr, tag1 As ULONGLONG Ptr, tag2 As ULONGLONG Ptr)
	PushLayer                As Sub(this As Any Ptr, layerParameters As Const D2D1_LAYER_PARAMETERS Ptr, layer As Any Ptr)
	PopLayer                 As Sub(this As Any Ptr)
	Flush                    As Function(this As Any Ptr, tag1 As ULONGLONG Ptr, tag2 As ULONGLONG Ptr) As HRESULT
	SaveDrawingState         As Sub(this As Any Ptr, stateBlock As Any Ptr)
	RestoreDrawingState      As Sub(this As Any Ptr, stateBlock As Any Ptr)
	PushAxisAlignedClip      As Sub(this As Any Ptr, clipRect As Const D2D1_RECT_F Ptr, antialiasMode As D2D1_ANTIALIAS_MODE)
	PopAxisAlignedClip       As Sub(this As Any Ptr)
	Clear                    As Sub(this As Any Ptr, color As Const D2D1_COLOR_F Ptr)
	BeginDraw                As Sub(this As Any Ptr)
	EndDraw                  As Function(this As Any Ptr, tag1 As ULONGLONG Ptr, tag2 As ULONGLONG Ptr) As HRESULT
	GetPixelFormat           As Function(this As Any Ptr) As D2D1_PIXEL_FORMAT
	SetDpi                   As Sub(this As Any Ptr, dpiX As Single, dpiY As Single)
	GetDpi                   As Sub(this As Any Ptr, dpiX As Single Ptr, dpiY As Single Ptr)
	GetSize                  As Function(this As Any Ptr) As D2D1_SIZE_F
	GetPixelSize             As Function(this As Any Ptr) As D2D1_SIZE_U
	GetMaximumBitmapSize     As Function(this As Any Ptr) As UINT32
	IsSupported              As Function(this As Any Ptr, renderTargetProperties As Const D2D1_RENDER_TARGET_PROPERTIES Ptr) As BOOL
End Type

Type ID2D1RenderTarget
	lpVtbl As ID2D1RenderTargetVtbl Ptr
End Type

Type IWICBitmapSource
	lpVtbl As Any Ptr
End Type

Type ID2D1BitmapVtbl
	' IUnknown
	QueryInterface           As Function(this As Any Ptr, riid As Const GUID Ptr, ppv As Any Ptr Ptr) As HRESULT
	AddRef                   As Function(this As Any Ptr) As HRESULT
	Release                  As Function(this As Any Ptr) As HRESULT
End Type

Type ID2D1Bitmap
	lpVtbl As ID2D1BitmapVtbl Ptr
End Type

Type ID2D1Layer
	lpVtbl As Any Ptr
End Type

Type ID2D1Geometry
	lpVtbl As Any Ptr
End Type

Type ID2D1Mesh
	lpVtbl As Any Ptr
End Type

Type IDWriteRenderingParams
	lpVtbl As Any Ptr
End Type

Type ID2D1BitmapBrush
	lpVtbl As Any Ptr
End Type

Type ID2D1GradientStopCollection
	lpVtbl As Any Ptr
End Type

Type ID2D1LinearGradientBrush
	lpVtbl As Any Ptr
End Type

Type ID2D1RadialGradientBrush
	lpVtbl As Any Ptr
End Type

Type ID2D1BitmapRenderTarget
	lpVtbl As Any Ptr
End Type

Type ID2D1DrawingStateBlock
	lpVtbl As Any Ptr
End Type

Type ID2D1Image
	lpVtbl As Any Ptr
End Type

Type D2D1_IMAGE_BRUSH_PROPERTIES
	lpVtbl As Any Ptr
End Type

Type D2D1_BITMAP_BRUSH_PROPERTIES1
	lpVtbl As Any Ptr
End Type

Type D2D1_COLOR_SPACE As Long
Enum
    D2D1_COLOR_SPACE_CUSTOM = 0
    D2D1_COLOR_SPACE_SRGB = 1
    D2D1_COLOR_SPACE_SCRGB = 2
End Enum

Type ID2D1CommandList
	lpVtbl As Any Ptr
End Type

Type ID2D1GradientStopCollection1
	lpVtbl As Any Ptr
End Type

Type D2D1_BUFFER_PRECISION As Long
Enum
    D2D1_BUFFER_PRECISION_UNKNOWN        = 0
    D2D1_BUFFER_PRECISION_8BPC_UNORM     = 1
    D2D1_BUFFER_PRECISION_8BPC_UNORM_SRGB = 2
    D2D1_BUFFER_PRECISION_16BPC_UNORM    = 3
    D2D1_BUFFER_PRECISION_16BPC_FLOAT    = 4
    D2D1_BUFFER_PRECISION_32BPC_FLOAT    = 5
End Enum

Type D2D1_RENDERING_CONTROLS
	lpVtbl As Any Ptr
End Type

Type D2D1_COLOR_INTERPOLATION_MODE As Long
Enum
    D2D1_COLOR_INTERPOLATION_MODE_STRAIGHT = 0
    D2D1_COLOR_INTERPOLATION_MODE_PREMULTIPLIED = 1
End Enum

Type D2D1_PRIMITIVE_BLEND As Long
Enum
    D2D1_PRIMITIVE_BLEND_SOURCE_OVER = 0
    D2D1_PRIMITIVE_BLEND_SOURCE_IN = 1
    D2D1_PRIMITIVE_BLEND_SOURCE_OUT = 2
    D2D1_PRIMITIVE_BLEND_SOURCE_ATOP = 3
    D2D1_PRIMITIVE_BLEND_DESTINATION_OVER = 4
    D2D1_PRIMITIVE_BLEND_DESTINATION_IN = 5
    D2D1_PRIMITIVE_BLEND_DESTINATION_OUT = 6
    D2D1_PRIMITIVE_BLEND_DESTINATION_ATOP = 7
    D2D1_PRIMITIVE_BLEND_XOR = 8
    D2D1_PRIMITIVE_BLEND_COPY = 9
    D2D1_PRIMITIVE_BLEND_PLUS = 10
End Enum

Type ID2D1ImageBrush
	lpVtbl As Any Ptr
End Type

Type ID2D1BitmapBrush1
	lpVtbl As Any Ptr
End Type

Type ID2D1ColorContext As ID2D1ColorContext_

Type ID2D1ColorContextVtbl
    ' IUnknown
    QueryInterface As Function(ByVal This As ID2D1ColorContext Ptr, ByVal riid As Const GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1ColorContext Ptr) As ULong
    Release As Function(ByVal This As ID2D1ColorContext Ptr) As ULong

    ' ID2D1Resource
    GetFactory As Sub(ByVal This As ID2D1ColorContext Ptr, ByVal ppFactory As Any Ptr Ptr)

    ' ID2D1ColorContext
    GetColorSpace As Function(ByVal This As ID2D1ColorContext Ptr) As D2D1_COLOR_SPACE
    GetProfileSize As Function(ByVal This As ID2D1ColorContext Ptr) As ULong
    GetProfile As Function(ByVal This As ID2D1ColorContext Ptr, ByVal profileBuffer As UByte Ptr, ByVal profileSize As ULong) As HRESULT
End Type

Type ID2D1ColorContext_
    lpVtbl As ID2D1ColorContextVtbl Ptr
End Type

Type D2D1_BITMAP_OPTIONS As Long
Enum
    D2D1_BITMAP_OPTIONS_NONE              = &h0
    D2D1_BITMAP_OPTIONS_TARGET            = &h1
    D2D1_BITMAP_OPTIONS_CANNOT_DRAW       = &h2
    D2D1_BITMAP_OPTIONS_CPU_READ          = &h4
    D2D1_BITMAP_OPTIONS_GPU_READ          = &h8
    D2D1_BITMAP_OPTIONS_FORCE_DWORD       = &hFFFFFFFF
End Enum

Type D2D1_BITMAP_PROPERTIES1
    pixelFormat As D2D1_PIXEL_FORMAT
    dpiX As Single
    dpiY As Single
    bitmapOptions As D2D1_BITMAP_OPTIONS
    colorContext As ID2D1ColorContext Ptr
End Type

Type DWRITE_GLYPH_RUN_DESCRIPTION
    localeName As WString Ptr
    string As WString Ptr
    stringLength As ULong
    clusterMap As UShort Ptr
    textPosition As ULong
End Type

Type ID2D1Device_ As ID2D1Device

Type ID2D1DeviceContext As ID2D1DeviceContext_

Type ID2D1DeviceContextVtbl
    ' IUnknown
    QueryInterface As Function(ByVal This As Any Ptr, ByVal riid As Const GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef         As Function(ByVal This As Any Ptr) As ULong
    Release        As Function(ByVal This As Any Ptr) As ULong

    ' ID2D1Resource
    GetFactory     As Sub(ByVal This As Any Ptr, ByVal factory As ID2D1Factory Ptr Ptr)

    ' ID2D1RenderTarget
    CreateBitmap             As Function(this As Any Ptr, size As D2D1_SIZE_U, srcData As Any Ptr, pitch As UINT32, bitmapProperties As Const D2D1_BITMAP_PROPERTIES Ptr, bitmap As Any Ptr Ptr) As HRESULT
	CreateBitmapFromWicBitmap As Function(this As Any Ptr, wicBitmapSource As Any Ptr, bitmapProperties As Const D2D1_BITMAP_PROPERTIES Ptr, bitmap As Any Ptr Ptr) As HRESULT
	CreateSharedBitmap       As Function(this As Any Ptr, riid As Const GUID Ptr, data As Any Ptr, bitmapProperties As Const D2D1_BITMAP_PROPERTIES Ptr, bitmap As Any Ptr Ptr) As HRESULT
	CreateBitmapBrush        As Function(this As Any Ptr, bitmap As Any Ptr, brushProperties As Const D2D1_BITMAP_BRUSH_PROPERTIES Ptr, brushProps As Const D2D1_BRUSH_PROPERTIES Ptr, brush As Any Ptr Ptr) As HRESULT
	CreateSolidColorBrush    As Function(this As Any Ptr, color As Const D2D1_COLOR_F Ptr, brushProperties As Const D2D1_BRUSH_PROPERTIES Ptr, brush As Any Ptr Ptr) As HRESULT
	CreateGradientStopCollection As Function(this As Any Ptr, gradientStops As Const D2D1_GRADIENT_STOP Ptr, gradientStopCount As UINT32, colorInterpolationGamma As D2D1_GAMMA, extendMode As D2D1_EXTEND_MODE, stopCollection As Any Ptr Ptr) As HRESULT
	CreateLinearGradientBrush As Function(this As Any Ptr, brushProperties As Const D2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES Ptr, brushProps As Const D2D1_BRUSH_PROPERTIES Ptr, brush As Any Ptr Ptr) As HRESULT
	CreateRadialGradientBrush As Function(this As Any Ptr, brushProperties As Const D2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES Ptr, brushProps As Const D2D1_BRUSH_PROPERTIES Ptr, brush As Any Ptr Ptr) As HRESULT
	CreateCompatibleRenderTarget As Function(this As Any Ptr, desiredSize As Const D2D1_SIZE_F Ptr, desiredPixelSize As Const D2D1_SIZE_U Ptr, desiredFormat As Const D2D1_PIXEL_FORMAT Ptr, options As D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS, renderTarget As Any Ptr Ptr) As HRESULT
	CreateLayer              As Function(this As Any Ptr, size As Const D2D1_SIZE_F Ptr, layer As Any Ptr Ptr) As HRESULT
	CreateMesh               As Function(this As Any Ptr, mesh As Any Ptr Ptr) As HRESULT
	DrawLine                 As Sub(ByVal this As Any Ptr, ByVal point0 As Const D2D1_POINT_2F, ByVal point1 As Const D2D1_POINT_2F, ByVal brush As Any Ptr, ByVal strokeWidth As FLOAT = 1.0f, ByVal strokeStyle As ID2D1StrokeStyle Ptr = NULL)
	DrawRectangle            As Sub(this As Any Ptr, rect As Const D2D1_RECT_F Ptr, brush As ID2D1Brush Ptr, strokeWidth As FLOAT = 1.0f, strokeStyle As ID2D1StrokeStyle Ptr = NULL)
	FillRectangle            As Sub(this As Any Ptr, rect As Const D2D1_RECT_F Ptr, brush As Any Ptr)
	DrawRoundedRectangle     As Sub(this As Any Ptr, rect As Const D2D1_ROUNDED_RECT Ptr, brush As Any Ptr, strokeWidth As FLOAT = 1.0f, strokeStyle As ID2D1StrokeStyle Ptr = NULL)
	FillRoundedRectangle     As Sub(this As Any Ptr, rect As Const D2D1_ROUNDED_RECT Ptr, brush As Any Ptr)
	DrawEllipse              As Sub(this As Any Ptr, ellipse As Const D2D1_ELLIPSE, brush As Any Ptr, strokeWidth As Single, strokeStyle As Any Ptr)
	FillEllipse              As Sub(this As Any Ptr, ellipse As Const D2D1_ELLIPSE, brush As Any Ptr)
	DrawGeometry             As Sub(this As Any Ptr, geometry As Any Ptr, brush As Any Ptr, strokeWidth As Single, strokeStyle As Any Ptr)
	FillGeometry             As Sub(this As Any Ptr, geometry As Any Ptr, brush As Any Ptr, opacityBrush As Any Ptr)
	FillMesh                 As Sub(this As Any Ptr, mesh As Any Ptr, brush As Any Ptr)
	FillOpacityMask          As Sub(this As Any Ptr, opacityMask As Any Ptr, brush As Any Ptr, content As D2D1_OPACITY_MASK_CONTENT, destinationRect As Const D2D1_RECT_F Ptr, sourceRect As Const D2D1_RECT_F Ptr)
	DrawBitmap               As Sub(this As Any Ptr, bitmap As Any Ptr, destinationRect As Const D2D1_RECT_F Ptr, opacity As Single, interpolationMode As D2D1_BITMAP_INTERPOLATION_MODE, sourceRect As Const D2D1_RECT_F Ptr)
	DrawText                 As Sub(this As Any Ptr, text As WString Ptr, textLength As UINT32, textFormat As Any Ptr, layoutRect As Const D2D1_RECT_F Ptr, defaultForegroundBrush As Any Ptr, options As UINT32, measuringMode As UINT32)
	DrawTextLayout           As Sub(this As Any Ptr, ByVal origin As Const D2D1_POINT_2F, ByVal textLayout As Any Ptr, ByVal defaultForegroundBrush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS = D2D1_DRAW_TEXT_OPTIONS_NONE)
	DrawGlyphRun             As Sub(this As Any Ptr, baselineOrigin As Const D2D1_POINT_2F Ptr, glyphRun As Const DWRITE_GLYPH_RUN Ptr, foregroundBrush As Any Ptr, measuringMode As UINT32)
	SetTransform             As Sub(this As Any Ptr, transform As Const D2D1_MATRIX_3X2_F Ptr)
	GetTransform             As Sub(this As Any Ptr, transform As D2D1_MATRIX_3X2_F Ptr)
	SetAntialiasMode         As Sub(this As Any Ptr, mode As D2D1_ANTIALIAS_MODE)
	GetAntialiasMode         As Function(this As Any Ptr) As D2D1_ANTIALIAS_MODE
	SetTextAntialiasMode     As Sub(this As Any Ptr, mode As D2D1_TEXT_ANTIALIAS_MODE)
	GetTextAntialiasMode     As Function(this As Any Ptr) As D2D1_TEXT_ANTIALIAS_MODE
	SetTextRenderingParams   As Sub(this As Any Ptr, params As Any Ptr)
	GetTextRenderingParams   As Sub(this As Any Ptr, params As Any Ptr Ptr)
	SetTags                  As Sub(This As Any Ptr, tag1 As ULONGLONG, tag2 As ULONGLONG)
	GetTags                  As Sub(this As Any Ptr, tag1 As ULONGLONG Ptr, tag2 As ULONGLONG Ptr)
	PushLayer                As Sub(this As Any Ptr, layerParameters As Const D2D1_LAYER_PARAMETERS Ptr, layer As Any Ptr)
	PopLayer                 As Sub(this As Any Ptr)
	Flush                    As Function(this As Any Ptr, tag1 As ULONGLONG Ptr, tag2 As ULONGLONG Ptr) As HRESULT
	SaveDrawingState         As Sub(this As Any Ptr, stateBlock As Any Ptr)
	RestoreDrawingState      As Sub(this As Any Ptr, stateBlock As Any Ptr)
	PushAxisAlignedClip      As Sub(this As Any Ptr, clipRect As Const D2D1_RECT_F Ptr, antialiasMode As D2D1_ANTIALIAS_MODE)
	PopAxisAlignedClip       As Sub(this As Any Ptr)
	Clear                    As Sub(this As Any Ptr, color As Const D2D1_COLOR_F Ptr)
	BeginDraw                As Sub(this As Any Ptr)
	EndDraw                  As Function(this As Any Ptr, tag1 As ULONGLONG Ptr, tag2 As ULONGLONG Ptr) As HRESULT
	GetPixelFormat           As Function(this As Any Ptr) As D2D1_PIXEL_FORMAT
	SetDpi                   As Sub(this As Any Ptr, dpiX As Single, dpiY As Single)
	GetDpi                   As Sub(this As Any Ptr, dpiX As Single Ptr, dpiY As Single Ptr)
	GetSize                  As Function(this As Any Ptr) As D2D1_SIZE_F
	GetPixelSize             As Function(this As Any Ptr) As D2D1_SIZE_U
	GetMaximumBitmapSize     As Function(this As Any Ptr) As UINT32
	IsSupported              As Function(this As Any Ptr, renderTargetProperties As Const D2D1_RENDER_TARGET_PROPERTIES Ptr) As BOOL

    ' ID2D1DeviceContext
    CreateBitmap1 As Function(This As Any Ptr, size As Const D2D1_SIZE_U, sourceData As Any Ptr, pitch As ULong, bitmapProperties As Const D2D1_BITMAP_PROPERTIES1 Ptr, ppBitmap As Any Ptr Ptr) As HRESULT
    CreateBitmapFromWicBitmap1 As Function(This As Any Ptr, wicBitmapSource As Any Ptr, bitmapProperties As Const D2D1_BITMAP_PROPERTIES1 Ptr, ppBitmap As Any Ptr Ptr) As HRESULT
    CreateColorContext As Function(This As Any Ptr, space As Long, profile As Const UByte Ptr, profileSize As ULong, ppColorContext As Any Ptr Ptr) As HRESULT
    CreateColorContextFromFilename As Function(This As Any Ptr, filename As WString Ptr, ppColorContext As Any Ptr Ptr) As HRESULT
    CreateColorContextFromWicColorContext As Function(This As Any Ptr, wicContext As Any Ptr, ppColorContext As Any Ptr Ptr) As HRESULT
    CreateBitmapFromDxgiSurface As Function(This As Any Ptr, surface As Any Ptr, bitmapProperties As Const D2D1_BITMAP_PROPERTIES1 Ptr, ppBitmap As Any Ptr Ptr) As HRESULT
    CreateEffect As Function(This As Any Ptr, effectId As Const GUID Ptr, ppEffect As Any Ptr Ptr) As HRESULT
    CreateGradientStopCollection1 As Function(This As Any Ptr, gradientStops As Const D2D1_GRADIENT_STOP Ptr, gradientStopsCount As ULong, preInterpolationSpace As Long, postInterpolationSpace As Long, bufferPrecision As Long, extendMode As Long, colorInterpolationMode As Long, ppGradientStopCollection1 As Any Ptr Ptr) As HRESULT
    CreateImageBrush As Function(This As Any Ptr, image As Any Ptr, imageBrushProperties As Const D2D1_IMAGE_BRUSH_PROPERTIES Ptr, brushProperties As Const D2D1_BRUSH_PROPERTIES Ptr, ppImageBrush As Any Ptr Ptr) As HRESULT
    CreateBitmapBrush1 As Function(This As Any Ptr, bitmap As Any Ptr, bitmapBrushProperties As Const D2D1_BITMAP_BRUSH_PROPERTIES1 Ptr, brushProperties As Const D2D1_BRUSH_PROPERTIES Ptr, ppBitmapBrush As Any Ptr Ptr) As HRESULT
    CreateCommandList As Function(This As Any Ptr, ppCommandList As Any Ptr Ptr) As HRESULT
    IsDxgiFormatSupported As Function(This As Any Ptr, format As DXGI_FORMAT) As BOOL
    IsBufferPrecisionSupported As Function(This As Any Ptr, bufferPrecision As Long) As BOOL
    GetImageLocalBounds As Function(This As Any Ptr, image As Any Ptr, localBounds As D2D1_RECT_F Ptr) As HRESULT
    GetImageWorldBounds As Function(This As Any Ptr, image As Any Ptr, worldBounds As D2D1_RECT_F Ptr) As HRESULT
    GetGlyphRunWorldBounds As Function(This As Any Ptr, baselineOrigin As Const D2D1_POINT_2F Ptr, glyphRun As Const DWRITE_GLYPH_RUN Ptr, measuringMode As Long, bounds As D2D1_RECT_F Ptr) As HRESULT
    GetDevice As Function(This As Any Ptr, device As Any Ptr Ptr) As Sub
    SetTarget As Sub(This As Any Ptr, image As Any Ptr)
    GetTarget As Function(This As Any Ptr) As Any Ptr
    SetRenderingControls As Sub(This As Any Ptr, renderingControls As Const D2D1_RENDERING_CONTROLS Ptr)
    GetRenderingControls As Sub(This As Any Ptr, renderingControls As D2D1_RENDERING_CONTROLS Ptr)
    SetPrimitiveBlend As Sub(This As Any Ptr, blend As Long)
    GetPrimitiveBlend As Function(This As Any Ptr) As Long
    SetUnitMode As Sub(This As Any Ptr, unitMode As Long)
    GetUnitMode As Function(This As Any Ptr) As Long
    DrawGlyphRun1 As Sub(This As Any Ptr, baselineOrigin As Const D2D1_POINT_2F Ptr, glyphRun As Const DWRITE_GLYPH_RUN Ptr, glyphRunDescription As Const DWRITE_GLYPH_RUN_DESCRIPTION Ptr, foregroundBrush As Any Ptr, measuringMode As Long)
    DrawImage As Sub(This As Any Ptr, image As Any Ptr, targetOffset As Const D2D1_POINT_2F Ptr, imageRectangle As Const D2D1_RECT_F Ptr, interpolationMode As Long, compositeMode As Long)
    DrawGdiMetafile As Sub(This As Any Ptr, metafile As Any Ptr, targetOffset As Const D2D1_POINT_2F Ptr)
    DrawGdiMetafile2 As Sub(This As Any Ptr, metafile As Any Ptr, targetOffset As Const D2D1_POINT_2F Ptr, sourceRectangle As Const D2D1_RECT_F Ptr)
    SetTarget1 As Sub(This As Any Ptr, image As Any Ptr)
    GetTarget1 As Function(This As Any Ptr) As Any Ptr
    SetTextAntialiasMode1 As Sub(This As Any Ptr, mode As Long)
    GetTextAntialiasMode1 As Function(This As Any Ptr) As Long
End Type

Type ID2D1DeviceContext_
	lpVtbl As ID2D1DeviceContextVtbl Ptr
End Type

Type D2D1_DEVICE_CONTEXT_OPTIONS As Long
Enum
    D2D1_DEVICE_CONTEXT_OPTIONS_NONE = 0
    D2D1_DEVICE_CONTEXT_OPTIONS_ENABLE_MULTITHREADED_OPTIMIZATIONS = 1
    D2D1_DEVICE_CONTEXT_OPTIONS_FORCE_DWORD = &HFFFFFFFF
End Enum

Const WICBitmapUseAlpha = &H00000001

#define IID_IWICFormatConverter GUID(0x00000301, 0xa8f2, 0x4877, {0xba,0x0a,0xfd,0x2b,0x66,0x45,0xfb,0x94})

' --- WICBitmapDitherType ---
Const WICBitmapDitherTypeNone          = 0
Const WICBitmapDitherTypeSolid         = 1
Const WICBitmapDitherTypeOrdered4x4    = 2
Const WICBitmapDitherTypeOrdered8x8    = 3
Const WICBitmapDitherTypeOrdered16x16  = 4
Const WICBitmapDitherTypeSpiral4x4     = 5
Const WICBitmapDitherTypeSpiral8x8     = 6
Const WICBitmapDitherTypeDualSpiral4x4 = 7
Const WICBitmapDitherTypeDualSpiral8x8 = 8
Const WICBitmapDitherTypeErrorDiffusion= 9

' --- WICBitmapPaletteType ---
Const WICBitmapPaletteTypeCustom           = 0
Const WICBitmapPaletteTypeMedianCut        = 1
Const WICBitmapPaletteTypeFixedBW          = 2
Const WICBitmapPaletteTypeFixedHalftone8   = 3
Const WICBitmapPaletteTypeFixedHalftone27  = 4
Const WICBitmapPaletteTypeFixedHalftone64  = 5
Const WICBitmapPaletteTypeFixedHalftone125 = 6
Const WICBitmapPaletteTypeFixedHalftone216 = 7
Const WICBitmapPaletteTypeFixedWebPalette  = WICBitmapPaletteTypeFixedHalftone216
Const WICBitmapPaletteTypeFixedHalftone252 = 8
Const WICBitmapPaletteTypeFixedHalftone256 = 9
Const WICBitmapPaletteTypeFixedGray4       = 10
Const WICBitmapPaletteTypeFixedGray16      = 11
Const WICBitmapPaletteTypeFixedGray256     = 12

Type IWICFormatConverterVtbl
    ' IUnknown
    QueryInterface As Function(this As Any Ptr, riid As Const IID Ptr, ppvObject As Any Ptr Ptr) As HRESULT
    AddRef          As Function(this As Any Ptr) As ULong
    Release         As Function(this As Any Ptr) As ULong
    ' IWICBitmapSource
    GetSize         As Function(this As Any Ptr, puiWidth As UINT Ptr, puiHeight As UINT Ptr) As HRESULT
    GetPixelFormat  As Function(this As Any Ptr, pPixelFormat As GUID Ptr) As HRESULT
    GetResolution   As Function(this As Any Ptr, pDpiX As Double Ptr, pDpiY As Double Ptr) As HRESULT
    CopyPalette     As Function(this As Any Ptr, pIPalette As Any Ptr) As HRESULT
    CopyPixels      As Function(this As Any Ptr, prc As Const Any Ptr, cbStride As UINT, cbBufferSize As UINT, pbBuffer As Byte Ptr) As HRESULT
    ' IWICFormatConverter
    Initialize      As Function(this As Any Ptr, pISource As Any Ptr, dstFormat As Const GUID Ptr, dither As Integer, alpha As Single, pPalette As Any Ptr, paletteType As Integer) As HRESULT
    CanConvert      As Function(this As Any Ptr, srcPixelFormat As Const GUID Ptr, dstPixelFormat As Const GUID Ptr, pfCanConvert As BOOL Ptr) As HRESULT
End Type

Type IWICFormatConverter
    lpVtbl As IWICFormatConverterVtbl Ptr
End Type

Type IWICImagingFactoryVtbl
	' IUnknown
	QueryInterface          As Function(ByVal This As Any Ptr, ByVal riid As REFIID, ByVal ppvObject As Any Ptr Ptr) As HRESULT
	AddRef                  As Function(ByVal This As Any Ptr) As ULong
	Release                 As Function(ByVal This As Any Ptr) As ULong

	' IWICImagingFactory методлари (асосийлар)
	CreateDecoderFromFilename As Function(ByVal This As Any Ptr, ByVal wzFilename As LPCWSTR, ByVal pguidVendor As Const GUID Ptr, ByVal dwDesiredAccess As DWORD, ByVal metadataOptions As DWORD, ByVal ppIDecoder As Any Ptr Ptr) As HRESULT
	CreateDecoderFromStream As Function(ByVal This As Any Ptr, ByVal pIStream As Any Ptr, ByVal pguidVendor As Const GUID Ptr, ByVal metadataOptions As DWORD, ByVal ppIDecoder As Any Ptr Ptr) As HRESULT
	CreateDecoderFromFileHandle As Function(ByVal This As Any Ptr, ByVal hFile As HANDLE, ByVal pguidVendor As Const GUID Ptr, ByVal metadataOptions As DWORD, ByVal ppIDecoder As Any Ptr Ptr) As HRESULT
	CreateComponentInfo As Function(ByVal This As Any Ptr, ByVal clsidComponent As Const GUID Ptr, ByVal ppIComponentInfo As Any Ptr Ptr) As HRESULT
	CreateDecoder As Function(ByVal This As Any Ptr, ByVal guidContainerFormat As Const GUID Ptr, ByVal pguidVendor As Const GUID Ptr, ByVal ppIDecoder As Any Ptr Ptr) As HRESULT
	CreateEncoder As Function(ByVal This As Any Ptr, ByVal guidContainerFormat As Const GUID Ptr, ByVal pguidVendor As Const GUID Ptr, ByVal ppIEncoder As Any Ptr Ptr) As HRESULT
	CreatePalette As Function(ByVal This As Any Ptr, ByVal ppIPalette As Any Ptr Ptr) As HRESULT
	CreateFormatConverter As Function(ByVal This As Any Ptr, ByVal ppIFormatConverter As Any Ptr Ptr) As HRESULT
	CreateBitmapScaler As Function(ByVal This As Any Ptr, ByVal ppIBitmapScaler As Any Ptr Ptr) As HRESULT
	CreateBitmapClipper As Function(ByVal This As Any Ptr, ByVal ppIBitmapClipper As Any Ptr Ptr) As HRESULT
	CreateBitmapFlipRotator As Function(ByVal This As Any Ptr, ByVal ppIBitmapFlipRotator As Any Ptr Ptr) As HRESULT
	CreateStream As Function(ByVal This As Any Ptr, ByVal ppIWICStream As Any Ptr Ptr) As HRESULT
	CreateColorContext As Function(ByVal This As Any Ptr, ByVal ppIWICColorContext As Any Ptr Ptr) As HRESULT
	CreateColorTransformer As Function(ByVal This As Any Ptr, ByVal ppIWICColorTransform As Any Ptr Ptr) As HRESULT
	CreateBitmap As Function(ByVal This As Any Ptr, ByVal uiWidth As UINT, ByVal uiHeight As UINT, ByVal pixelFormat As Const GUID Ptr, ByVal option As DWORD, ByVal ppIBitmap As Any Ptr Ptr) As HRESULT
	CreateBitmapFromSource As Function(ByVal This As Any Ptr, ByVal pIBitmapSource As Any Ptr, ByVal option As DWORD, ByVal ppIBitmap As Any Ptr Ptr) As HRESULT
	CreateBitmapFromSourceRect As Function(ByVal This As Any Ptr, ByVal pIBitmapSource As Any Ptr, ByVal x As UINT, ByVal y As UINT, ByVal width As UINT, ByVal height As UINT, ByVal ppIBitmap As Any Ptr Ptr) As HRESULT
	CreateBitmapFromMemory As Function(ByVal This As Any Ptr, ByVal uiWidth As UINT, ByVal uiHeight As UINT, ByVal pixelFormat As Const GUID Ptr, ByVal cbStride As UINT, ByVal cbBufferSize As UINT, ByVal pbBuffer As Byte Ptr, ByVal ppIBitmap As Any Ptr Ptr) As HRESULT
	CreateBitmapFromHBITMAP As Function(ByVal This As Any Ptr, ByVal hBitmap As HBITMAP, ByVal hPalette As HPALETTE, ByVal option As DWORD, ByVal ppIBitmap As Any Ptr Ptr) As HRESULT
	CreateBitmapFromHICON As Function(ByVal This As Any Ptr, ByVal hIcon As HICON, ByVal ppIBitmap As Any Ptr Ptr) As HRESULT
	CreateComponentEnumerator As Function(ByVal This As Any Ptr, ByVal componentTypes As DWORD, ByVal options As DWORD, ByVal ppIEnumUnknown As Any Ptr Ptr) As HRESULT
	CreateFastMetadataEncoderFromDecoder As Function(ByVal This As Any Ptr, ByVal pIDecoder As Any Ptr, ByVal ppIFastEncoder As Any Ptr Ptr) As HRESULT
	CreateFastMetadataEncoderFromFrameDecode As Function(ByVal This As Any Ptr, ByVal pIFrameDecode As Any Ptr, ByVal ppIFastEncoder As Any Ptr Ptr) As HRESULT
	CreateQueryWriter As Function(ByVal This As Any Ptr, ByVal guidMetadataFormat As Const GUID Ptr, ByVal pguidVendor As Const GUID Ptr, ByVal ppIQueryWriter As Any Ptr Ptr) As HRESULT
	CreateQueryWriterFromReader As Function(ByVal This As Any Ptr, ByVal pIQueryReader As Any Ptr, ByVal pguidVendor As Const GUID Ptr, ByVal ppIQueryWriter As Any Ptr Ptr) As HRESULT
End Type

Type IWICImagingFactory
	lpVtbl As IWICImagingFactoryVtbl Ptr
End Type

Type IPrintDocumentPackageTargetVtbl
    ' IUnknown
    QueryInterface As Function(ByVal this As Any Ptr, ByVal riid As Const GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef         As Function(ByVal this As Any Ptr) As ULong
    Release        As Function(ByVal this As Any Ptr) As ULong

    ' IPrintDocumentPackageTarget
    GetPackageTargetTypes As Function(ByVal this As Any Ptr, ByRef targetCount As ULong, ByRef targetTypes As GUID Ptr) As HRESULT
    GetPackageTarget      As Function(ByVal this As Any Ptr, ByVal guidTargetType As Const GUID Ptr, ByRef ppPackageTarget As Any Ptr) As HRESULT
    Cancel                As Function(ByVal this As Any Ptr) As HRESULT
End Type

Type IPrintDocumentPackageTarget
    lpVtbl As IPrintDocumentPackageTargetVtbl Ptr
End Type

Type D2D1_PRINT_FONT_SUBSET_MODE As Long
Enum
    D2D1_PRINT_FONT_SUBSET_MODE_DEFAULT = 0
    D2D1_PRINT_FONT_SUBSET_MODE_EACHPAGE = 1
    D2D1_PRINT_FONT_SUBSET_MODE_NONE = 2
End Enum

Type D2D1_PRINT_CONTROL_PROPERTIES
    fontSubset As D2D1_PRINT_FONT_SUBSET_MODE
    rasterDPI  As FLOAT
    colorSpace As D2D1_COLOR_SPACE
End Type

Type ID2D1PrintControlVtbl
    ' IUnknown
    QueryInterface As Function(ByVal this As Any Ptr, ByVal riid As Const GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef         As Function(ByVal this As Any Ptr) As ULong
    Release        As Function(ByVal this As Any Ptr) As ULong

    ' ID2D1PrintControl
    AddPage As Function( _
        ByVal This As Any Ptr, _
        ByVal commandList As Any Ptr, _        ' ID2D1CommandList*
        ByVal pageSize As Const D2D1_SIZE_F Ptr, _
        ByVal printTicketStream As Any Ptr, _   ' IStream*
        ByRef tag1 As D2D1_TAG, _
        ByRef tag2 As D2D1_TAG) As HRESULT

    Close As Function(ByVal this As Any Ptr) As HRESULT
End Type

Type ID2D1PrintControl
    lpVtbl As ID2D1PrintControlVtbl Ptr
End Type

Type ID2D1DeviceVtbl
	' IUnknown
	QueryInterface             As Function(ByVal This As Any Ptr, ByVal riid As REFIID, ByVal ppvObject As Any Ptr Ptr) As HRESULT
	AddRef                     As Function(ByVal This As Any Ptr) As ULong
	Release                    As Function(ByVal This As Any Ptr) As ULong

	' ID2D1Resource
	GetFactory                 As Sub(ByVal This As Any Ptr, ByVal factory As ID2D1Factory Ptr Ptr)

	' ID2D1Device
	CreateDeviceContext        As Function(ByVal This As Any Ptr, ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal deviceContext As ID2D1DeviceContext Ptr Ptr) As HRESULT
	CreatePrintControl         As Function(ByVal This As Any Ptr, ByVal wicFactory As IWICImagingFactory Ptr, ByVal documentTarget As IPrintDocumentPackageTarget Ptr, ByVal printControlProperties As D2D1_PRINT_CONTROL_PROPERTIES Ptr, ByVal printControl As ID2D1PrintControl Ptr Ptr) As HRESULT
	SetMaximumTextureMemory    As Sub(ByVal This As Any Ptr, ByVal maximumInBytes As UINT64)
	GetMaximumTextureMemory    As Function(ByVal This As Any Ptr) As UINT64
	ClearResources             As Sub(ByVal This As Any Ptr, ByVal millisecondsSinceUse As ULong)
End Type

Type ID2D1Device
	lpVtbl As ID2D1DeviceVtbl Ptr
End Type

Dim Shared IID_ID2D1Factory As GUID = Type(&h06152247, &h6f50, &h465a, {&h92, &h45, &h11, &h8b, &hfd, &h3b, &h60, &h07})

Dim Shared IID_ID2D1Factory1 As GUID = Type(&hbb12d362, &hdaee, &h4b9a, {&haa, &h1d, &h14, &hba, &h40, &h1c, &hfa, &h1f})


Type D2D1_STROKE_STYLE_PROPERTIES
    startCap       As D2D1_CAP_STYLE
    endCap         As D2D1_CAP_STYLE
    dashCap        As D2D1_CAP_STYLE
    lineJoin       As D2D1_LINE_JOIN
    miterLimit     As FLOAT
    dashStyle      As D2D1_DASH_STYLE
    dashOffset     As FLOAT
End Type

Type D2D1_STROKE_TRANSFORM_TYPE As Long
Enum
    D2D1_STROKE_TRANSFORM_TYPE_NORMAL = 0
    D2D1_STROKE_TRANSFORM_TYPE_FIXED = 1
    D2D1_STROKE_TRANSFORM_TYPE_HAIRLINE = 2
    D2D1_STROKE_TRANSFORM_TYPE_FORCE_DWORD = &HFFFFFFFF
End Enum

Type D2D1_STROKE_STYLE_PROPERTIES1
    startCap       As D2D1_CAP_STYLE
    endCap         As D2D1_CAP_STYLE
    dashCap        As D2D1_CAP_STYLE
    lineJoin       As D2D1_LINE_JOIN
    miterLimit     As FLOAT
    dashStyle      As D2D1_DASH_STYLE
    dashOffset     As FLOAT
    transformType  As D2D1_STROKE_TRANSFORM_TYPE
End Type

Type D2D1_DRAWING_STATE_DESCRIPTION1
    antialiasMode        As D2D1_ANTIALIAS_MODE
    textAntialiasMode    As D2D1_TEXT_ANTIALIAS_MODE
    tag1                 As D2D1_TAG
    tag2                 As D2D1_TAG
    transform            As D2D1_MATRIX_3X2_F
    primitiveBlend       As D2D1_PRIMITIVE_BLEND
    unitMode             As D2D1_UNIT_MODE
End Type

Type DXGI_SAMPLE_DESC
    Count As ULong
    Quality As ULong
End Type

Type DXGI_SURFACE_DESC
    Width As ULong
    Height As ULong
    Format As DXGI_FORMAT
    SampleDesc As DXGI_SAMPLE_DESC
End Type

Type DXGI_RESIDENCY As Long
Enum
    DXGI_RESIDENCY_FULLY_RESIDENT = 1
    DXGI_RESIDENCY_RESIDENT_IN_SHARED_MEMORY = 2
    DXGI_RESIDENCY_EVICTED_TO_DISK = 3
End Enum

Type DXGI_MAPPED_RECT
    Pitch As Long
    pBits As UByte Ptr
End Type

Type DXGI_RATIONAL
    Numerator   As ULong
    Denominator As ULong
End Type

Type DXGI_MODE_SCANLINE_ORDER As Long
Enum
    DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED = 0
    DXGI_MODE_SCANLINE_ORDER_PROGRESSIVE = 1
    DXGI_MODE_SCANLINE_ORDER_UPPER_FIELD_FIRST = 2
    DXGI_MODE_SCANLINE_ORDER_LOWER_FIELD_FIRST = 3
End Enum

Type DXGI_MODE_SCALING As Long
Enum
    DXGI_MODE_SCALING_UNSPECIFIED = 0
    DXGI_MODE_SCALING_CENTERED     = 1
    DXGI_MODE_SCALING_STRETCHED    = 2
End Enum

Type DXGI_MODE_DESC
    Width As ULong
    Height As ULong
    RefreshRate As DXGI_RATIONAL
    Format As DXGI_FORMAT
    ScanlineOrdering As DXGI_MODE_SCANLINE_ORDER
    Scaling As DXGI_MODE_SCALING
End Type

Type D2D1_POINT_2U
    x As ULong
    y As ULong
End Type

Type D2D1_RECT_U
    left   As ULong
    top    As ULong
    right  As ULong
    bottom As ULong
End Type

Enum D2D1_MAP_OPTIONS
    D2D1_MAP_OPTIONS_NONE        = 0
    D2D1_MAP_OPTIONS_READ        = 1
    D2D1_MAP_OPTIONS_WRITE       = 2
    D2D1_MAP_OPTIONS_DISCARD     = 4
End Enum

Type D2D1_MAPPED_RECT
    bits  As UByte Ptr
    pitch As ULong
End Type

Type DXGI_USAGE As Long
Enum
    DXGI_USAGE_SHADER_INPUT         = &h00000010
    DXGI_USAGE_RENDER_TARGET_OUTPUT = &h00000020
    DXGI_USAGE_BACK_BUFFER          = &h00000040
    DXGI_USAGE_DISCARD_ON_PRESENT   = &h00000080
    DXGI_USAGE_UNORDERED_ACCESS     = &h00000100
End Enum

Type DXGI_SWAP_EFFECT As Long
Enum
    DXGI_SWAP_EFFECT_DISCARD         = 0
    DXGI_SWAP_EFFECT_SEQUENTIAL      = 1
    DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL = 3
    DXGI_SWAP_EFFECT_FLIP_DISCARD    = 4
End Enum

Type DXGI_SWAP_CHAIN_DESC
    BufferDesc As DXGI_MODE_DESC
    SampleDesc As DXGI_SAMPLE_DESC
    BufferUsage As ULong
    BufferCount As ULong
    OutputWindow As HWND
    Windowed As BOOL
    SwapEffect As DXGI_SWAP_EFFECT
    Flags As ULong
End Type

Type DXGI_SCALING As Long
Enum
  DXGI_SCALING_STRETCH = 0
  DXGI_SCALING_NONE = 1
  DXGI_SCALING_ASPECT_RATIO_STRETCH = 2
End Enum

Type DXGI_ALPHA_MODE As Long
Enum
  DXGI_ALPHA_MODE_UNSPECIFIED     = 0
  DXGI_ALPHA_MODE_PREMULTIPLIED   = 1
  DXGI_ALPHA_MODE_STRAIGHT        = 2
  DXGI_ALPHA_MODE_IGNORE          = 3
  DXGI_ALPHA_MODE_FORCE_DWORD     = &hFFFFFFFF
End Enum

Type DXGI_SWAP_CHAIN_DESC1
  Width As UINT
  Height As UINT
  Format As DXGI_FORMAT
  Stereo As BOOL
  SampleDesc As DXGI_SAMPLE_DESC
  BufferUsage As DXGI_USAGE
  BufferCount As UINT
  Scaling As DXGI_SCALING
  SwapEffect As DXGI_SWAP_EFFECT
  AlphaMode As DXGI_ALPHA_MODE
  Flags As UInteger
End Type

Type IDXGISurfaceVtbl
    ' IUnknown
    QueryInterface As Function(ByVal this As Any Ptr, ByVal riid As Const GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef         As Function(ByVal this As Any Ptr) As ULong
    Release        As Function(ByVal this As Any Ptr) As ULong

    ' IDXGIObject
    SetPrivateData           As Function(ByVal this As Any Ptr, ByVal guid As Const guid Ptr, ByVal dataSize As ULong, ByVal pData As Any Ptr) As HRESULT
    SetPrivateDataInterface  As Function(ByVal this As Any Ptr, ByVal guid As Const guid Ptr, ByVal pUnknown As Any Ptr) As HRESULT
    GetPrivateData           As Function(ByVal this As Any Ptr, ByVal guid As Const guid Ptr, ByRef dataSize As ULong, ByVal pData As Any Ptr) As HRESULT
    GetParent                As Function(ByVal this As Any Ptr, ByVal riid As Const GUID Ptr, ByVal ppParent As Any Ptr Ptr) As HRESULT
    GetDevice                As Function(ByVal this As Any Ptr, ByVal riid As Const GUID Ptr, ByVal ppDevice As Any Ptr Ptr) As HRESULT

    ' IDXGISurface
    GetDesc                  As Function(ByVal this As Any Ptr, ByVal pDesc As DXGI_SURFACE_DESC Ptr) As HRESULT
    Map                      As Function(ByVal this As Any Ptr, ByVal pLockedRect As DXGI_MAPPED_RECT Ptr, ByVal MapFlags As ULong) As HRESULT
    Unmap                    As Function(ByVal this As Any Ptr) As HRESULT
End Type

Type IDXGISurface
    lpVtbl As IDXGISurfaceVtbl Ptr
End Type

Type D3D11_RESOURCE_DIMENSION As Long
Enum
    D3D11_RESOURCE_DIMENSION_UNKNOWN    = 0
    D3D11_RESOURCE_DIMENSION_BUFFER     = 1
    D3D11_RESOURCE_DIMENSION_TEXTURE1D  = 2
    D3D11_RESOURCE_DIMENSION_TEXTURE2D  = 3
    D3D11_RESOURCE_DIMENSION_TEXTURE3D  = 4
End Enum

Type D3D11_TEXTURE2D_DESC
    Width              As ULong
    Height             As ULong
    MipLevels          As ULong
    ArraySize          As ULong
    Format             As ULong            ' DXGI_FORMAT
    SampleDesc_Count   As ULong
    SampleDesc_Quality As ULong
    Usage              As ULong            ' D3D11_USAGE
    BindFlags          As ULong
    CPUAccessFlags     As ULong
    MiscFlags          As ULong
End Type

Dim Shared IID_ID3D11Texture2D As GUID = Type(&h6F15AAF2, &hD208, &h4E89, {&h9A, &hB4, &h48, &h95, &h85, &h37, &hCD, &h3E})

Type ID3D11Texture2DVtbl
    ' IUnknown
    QueryInterface     As Function(ByVal This As Any Ptr, ByVal riid As Const GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef             As Function(ByVal This As Any Ptr) As ULong
    Release            As Function(ByVal This As Any Ptr) As ULong

    ' ID3D11DeviceChild
    GetDevice          As Sub(ByVal This As Any Ptr, ByVal ppDevice As Any Ptr Ptr)
    GetPrivateData     As Function(ByVal This As Any Ptr, ByVal guid As Const guid Ptr, ByVal pDataSize As ULong Ptr, ByVal pData As Any Ptr) As HRESULT
    SetPrivateData     As Function(ByVal This As Any Ptr, ByVal guid As Const guid Ptr, ByVal DataSize As ULong, ByVal pData As Any Ptr) As HRESULT
    SetPrivateDataInterface As Function(ByVal This As Any Ptr, ByVal guid As Const guid Ptr, ByVal pData As Any Ptr) As HRESULT

    ' ID3D11Resource
    GetType_           As Sub(ByVal This As Any Ptr, ByVal pResourceDimension As D3D11_RESOURCE_DIMENSION)
    SetEvictionPriority As Sub(ByVal This As Any Ptr, ByVal EvictionPriority As ULong)
    GetEvictionPriority As Function(ByVal This As Any Ptr) As ULong

    ' ID3D11Texture2D
    GetDesc            As Sub(ByVal This As Any Ptr, ByVal pDesc As D3D11_TEXTURE2D_DESC Ptr)
End Type

Type ID3D11Texture2D
    lpVtbl As ID3D11Texture2DVtbl Ptr
End Type

'Dim Shared IID_IDXGISurface As GUID = Type(&hCB1193DB, &h6C49, &h4D86, {&hBF, &h47, &h9E, &h23, &hBB, &hD2, &h60, &hEC})

Dim Shared IID_IDXGISurface As GUID = Type(&hcafcb56c, &h6ac3, &h4889, {&hbf, &h47, &h9e, &h23, &hbb, &hd2, &h60, &hec})

Dim Shared IID_IDXGISurface1 As GUID = Type(&h4AE63092, &h6327, &h4C1B, {&h80, &hAE, &hBF, &hE1, &h2E, &hA3, &h2B, &h86})

Type DXGI_ADAPTER_DESC
    Description     As WString * 128
    VendorId        As ULong
    DeviceId        As ULong
    SubSysId        As ULong
    Revision        As ULong
    DedicatedVideoMemory As ULONGLONG
    DedicatedSystemMemory As ULONGLONG
    SharedSystemMemory    As ULONGLONG
    AdapterLuid      As LUID
End Type

Type IDXGIAdapterVtbl
    ' IUnknown
    QueryInterface     As Function(ByVal This As Any Ptr, ByVal riid As Const GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef             As Function(ByVal This As Any Ptr) As ULong
    Release            As Function(ByVal This As Any Ptr) As ULong

    ' IDXGIObject
    SetPrivateData     As Function(ByVal This As Any Ptr, ByVal Name As Const GUID Ptr, ByVal DataSize As UInteger, ByVal pData As Const Any Ptr) As HRESULT
    SetPrivateDataInterface As Function(ByVal This As Any Ptr, ByVal Name As Const GUID Ptr, ByVal pUnknown As Any Ptr) As HRESULT
    GetPrivateData     As Function(ByVal This As Any Ptr, ByVal Name As Const GUID Ptr, ByVal pDataSize As UInteger Ptr, ByVal pData As Any Ptr) As HRESULT
    GetParent          As Function(ByVal This As Any Ptr, ByVal riid As Const GUID Ptr, ByVal ppParent As Any Ptr Ptr) As HRESULT

    ' IDXGIAdapter
    EnumOutputs        As Function(ByVal This As Any Ptr, ByVal Output As UInteger, ByVal ppOutput As Any Ptr Ptr) As HRESULT
    GetDesc            As Function(ByVal This As Any Ptr, ByVal pDesc As DXGI_ADAPTER_DESC Ptr) As HRESULT
    CheckInterfaceSupport As Function(ByVal This As Any Ptr, ByVal InterfaceName As Const GUID Ptr, ByVal pUMDVersion As LARGE_INTEGER Ptr) As HRESULT
End Type

Type ID2D1Bitmap1 As ID2D1Bitmap1_

Type ID2D1Bitmap1Vtbl
    ' IUnknown
    QueryInterface As Function(ByVal This As ID2D1Bitmap1 Ptr, ByVal riid As Const GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Bitmap1 Ptr) As ULong
    Release As Function(ByVal This As ID2D1Bitmap1 Ptr) As ULong

    ' ID2D1Resource
    GetFactory As Sub(ByVal This As ID2D1Bitmap1 Ptr, ByVal ppFactory As Any Ptr Ptr)

    ' ID2D1Image (пустой)

    ' ID2D1Bitmap
    GetSize As Function(ByVal This As ID2D1Bitmap1 Ptr) As D2D1_SIZE_F
    GetPixelSize As Function(ByVal This As ID2D1Bitmap1 Ptr) As D2D1_SIZE_U
    GetPixelFormat As Function(ByVal This As ID2D1Bitmap1 Ptr) As D2D1_PIXEL_FORMAT
    GetDpi As Sub(ByVal This As ID2D1Bitmap1 Ptr, ByVal dpiX As Single Ptr, ByVal dpiY As Single Ptr)
    CopyFromBitmap As Function(ByVal This As ID2D1Bitmap1 Ptr, ByVal destPoint As Const D2D1_POINT_2U Ptr, ByVal srcBitmap As ID2D1Bitmap Ptr, ByVal srcRect As Const D2D1_RECT_U Ptr) As HRESULT
    CopyFromRenderTarget As Function(ByVal This As ID2D1Bitmap1 Ptr, ByVal destPoint As Const D2D1_POINT_2U Ptr, ByVal srcRenderTarget As ID2D1RenderTarget Ptr, ByVal srcRect As Const D2D1_RECT_U Ptr) As HRESULT
    CopyFromMemory As Function(ByVal This As ID2D1Bitmap1 Ptr, ByVal dstRect As Const D2D1_RECT_U Ptr, ByVal srcData As Any Ptr, ByVal pitch As ULong) As HRESULT

    ' ID2D1Bitmap1
    GetColorContext As Sub(ByVal This As ID2D1Bitmap1 Ptr, ByVal colorContext As ID2D1ColorContext Ptr Ptr)
    GetOptions As Function(ByVal This As ID2D1Bitmap1 Ptr) As D2D1_BITMAP_OPTIONS
    GetSurface As Function(ByVal This As ID2D1Bitmap1 Ptr, ByVal dxgiSurface As IDXGISurface Ptr Ptr) As HRESULT
    Map As Function(ByVal This As ID2D1Bitmap1 Ptr, ByVal options As D2D1_MAP_OPTIONS, ByVal mappedRect As D2D1_MAPPED_RECT Ptr) As HRESULT
    Unmap As Function(ByVal This As ID2D1Bitmap1 Ptr) As HRESULT
End Type

Type ID2D1Bitmap1_
    lpVtbl As ID2D1Bitmap1Vtbl Ptr
End Type

Type IWICBitmap As IWICBitmap_

Type IWICBitmapVtbl
    ' IUnknown
    QueryInterface As Function(ByVal This As IWICBitmap Ptr, ByVal riid As Const GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IWICBitmap Ptr) As ULong
    Release As Function(ByVal This As IWICBitmap Ptr) As ULong
End Type

Type IWICBitmap_
    lpVtbl As IWICBitmapVtbl Ptr
End Type

Type IDXGIAdapter
    lpVtbl As IDXGIAdapterVtbl Ptr
End Type

Type IDXGIDeviceVtbl
	' IUnknown
	QueryInterface     As Function(ByVal This As Any Ptr, ByVal riid As REFIID, ByVal ppvObject As Any Ptr Ptr) As HRESULT
	AddRef             As Function(ByVal This As Any Ptr) As ULong
	Release            As Function(ByVal This As Any Ptr) As ULong

	' IDXGIObject
	SetPrivateData     As Function(ByVal This As Any Ptr, ByVal Name As REFGUID, ByVal DataSize As ULong, ByVal pData As Any Ptr) As HRESULT
	SetPrivateDataInterface As Function(ByVal This As Any Ptr, ByVal Name As REFGUID, ByVal pUnknown As IUnknown Ptr) As HRESULT
	GetPrivateData     As Function(ByVal This As Any Ptr, ByVal Name As REFGUID, ByRef pDataSize As ULong, ByVal pData As Any Ptr) As HRESULT
	GetParent          As Function(ByVal This As Any Ptr, ByVal riid As REFIID, ByVal ppParent As Any Ptr Ptr) As HRESULT

	' IDXGIDevice
	GetAdapter                  As Function(ByVal This As Any Ptr, ByVal ppAdapter As IDXGIAdapter Ptr Ptr) As HRESULT
	CreateSurface               As Function(ByVal This As Any Ptr, ByVal pDesc As DXGI_SURFACE_DESC Ptr, ByVal SurfaceCount As ULong, ByVal Usage As ULong, ByVal pSharedResource As Any Ptr, ByVal ppSurface As IDXGISurface Ptr Ptr) As HRESULT
	QueryResourceResidency      As Function(ByVal This As Any Ptr, ByVal ppResources As IUnknown Ptr Ptr, ByVal pResidencyStatus As DXGI_RESIDENCY, ByVal ResourceCount As ULong) As HRESULT
	SetGPUThreadPriority        As Function(ByVal This As Any Ptr, ByVal Priority As Long) As HRESULT
	GetGPUThreadPriority        As Function(ByVal This As Any Ptr, ByVal pPriority As Long Ptr) As HRESULT
End Type

Type IDXGIDevice
	lpVtbl As IDXGIDeviceVtbl Ptr
End Type

Dim Shared IID_IDXGIDevice As GUID = Type(&h54ec77fa, &h1377, &h44e6, {&h8c, &h32, &h88, &hfd, &h5f, &h44, &hc8, &h4c})

Type DXGI_MODE_ROTATION As Long
Enum
    DXGI_MODE_ROTATION_UNSPECIFIED = 0   ' Не указано (используется по умолчанию)
    DXGI_MODE_ROTATION_IDENTITY    = 1   ' 0° — нормальное положение
    DXGI_MODE_ROTATION_ROTATE90    = 2   ' 90° по часовой стрелке
    DXGI_MODE_ROTATION_ROTATE180   = 3   ' 180° (перевёрнуто)
    DXGI_MODE_ROTATION_ROTATE270   = 4   ' 270° (90° против часовой стрелки)
End Enum

Type DXGI_OUTPUT_DESC
    DeviceName As WCHAR Ptr
    DesktopCoordinates As RECT
    AttachedToDesktop As BOOL
    Rotation As DXGI_MODE_ROTATION
    Monitor As HMONITOR
End Type

Type DXGI_RGB
    Red   As Single
    Green As Single
    Blue  As Single
End Type

Type DXGI_GAMMA_CONTROL_CAPABILITIES
    ScaleAndOffsetSupported As BOOL
    MaxConvertedValue       As Single
    MinConvertedValue       As Single
    NumGammaControlPoints   As ULong
    ControlPointPositions   As Single Ptr
End Type

Type DXGI_GAMMA_CONTROL
    Scale   As DXGI_RGB                  ' Масштаб по каждому каналу (умножение)
    Offset  As DXGI_RGB                  ' Смещение по каждому каналу (прибавление)
    GammaCurve(0 To 1024) As DXGI_RGB   ' Контрольные точки гамма-кривой (обычно 1025 точек)
End Type

Type DXGI_FRAME_STATISTICS
    PresentCount      As ULong
    PresentRefreshCount As ULong
    SyncRefreshCount  As ULong
    SyncQPCTime       As LARGE_INTEGER
    SyncGPUTime       As LARGE_INTEGER
End Type

Type IDXGIOutput As IDXGIOutput_
	
Type IDXGIOutputVtbl
    ' IUnknown
    QueryInterface As Function(This As IDXGIOutput Ptr, riid As Const GUID Ptr, ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(This As IDXGIOutput Ptr) As ULong
    Release As Function(This As IDXGIOutput Ptr) As ULong

    ' IDXGIObject
    SetPrivateData As Function(This As IDXGIOutput Ptr, name As Const GUID Ptr, dataSize As ULong, data As Any Ptr) As HRESULT
    SetPrivateDataInterface As Function(This As IDXGIOutput Ptr, name As Const GUID Ptr, pUnknown As IUnknown Ptr) As HRESULT
    GetPrivateData As Function(This As IDXGIOutput Ptr, name As Const GUID Ptr, pDataSize As ULong Ptr, data As Any Ptr) As HRESULT
    GetParent As Function(This As IDXGIOutput Ptr, riid As Const GUID Ptr, ppParent As Any Ptr Ptr) As HRESULT

    ' IDXGIOutput
    GetDesc As Function(This As IDXGIOutput Ptr, desc As DXGI_OUTPUT_DESC Ptr) As HRESULT
    GetDisplayModeList As Function(This As IDXGIOutput Ptr, format As DXGI_FORMAT, flags As ULong, numModes As ULong Ptr, desc As DXGI_MODE_DESC Ptr) As HRESULT
    FindClosestMatchingMode As Function(This As IDXGIOutput Ptr, modeToMatch As Const DXGI_MODE_DESC Ptr, closestMatch As DXGI_MODE_DESC Ptr, concernedDevice As IUnknown Ptr) As HRESULT
    WaitForVBlank As Function(This As IDXGIOutput Ptr) As HRESULT
    TakeOwnership As Function(This As IDXGIOutput Ptr, device As IUnknown Ptr, exclusive As BOOL) As HRESULT
    ReleaseOwnership As Sub(This As IDXGIOutput Ptr)
    GetGammaControlCapabilities As Function(This As IDXGIOutput Ptr, caps As DXGI_GAMMA_CONTROL_CAPABILITIES Ptr) As HRESULT
    SetGammaControl As Function(This As IDXGIOutput Ptr, gammaControl As Const DXGI_GAMMA_CONTROL Ptr) As HRESULT
    GetGammaControl As Function(This As IDXGIOutput Ptr, gammaControl As DXGI_GAMMA_CONTROL Ptr) As HRESULT
    SetDisplaySurface As Function(This As IDXGIOutput Ptr, scanoutSurface As IDXGISurface Ptr) As HRESULT
    GetDisplaySurfaceData As Function(This As IDXGIOutput Ptr, destination As IDXGISurface Ptr) As HRESULT
    GetFrameStatistics As Function(This As IDXGIOutput Ptr, stats As DXGI_FRAME_STATISTICS Ptr) As HRESULT
End Type

Type IDXGIOutput_
    lpVtbl As IDXGIOutputVtbl Ptr
End Type

Type IDXGISwapChain As IDXGISwapChain_

Type IDXGISwapChainVtbl
    ' IUnknown
    QueryInterface As Function(This As IDXGISwapChain Ptr, riid As Const GUID Ptr, ppv As Any Ptr Ptr) As HRESULT
    AddRef As Function(This As IDXGISwapChain Ptr) As ULong
    Release As Function(This As IDXGISwapChain Ptr) As ULong

    ' IDXGIObject
    SetPrivateData As Function(This As IDXGISwapChain Ptr, name As Const GUID Ptr, size As ULong, data As Any Ptr) As HRESULT
    SetPrivateDataInterface As Function(This As IDXGISwapChain Ptr, name As Const GUID Ptr, pUnknown As IUnknown Ptr) As HRESULT
    GetPrivateData As Function(This As IDXGISwapChain Ptr, name As Const GUID Ptr, pSize As ULong Ptr, data As Any Ptr) As HRESULT
    GetParent As Function(This As IDXGISwapChain Ptr, riid As Const GUID Ptr, ppParent As Any Ptr Ptr) As HRESULT

    ' IDXGISwapChain
    Present As Function(This As IDXGISwapChain Ptr, syncInterval As ULong, flags As ULong) As HRESULT
    GetBuffer As Function(This As IDXGISwapChain Ptr, bufferIndex As UINT, riid As Const GUID Ptr, surface As IDXGISurface Ptr Ptr) As HRESULT
    SetFullscreenState As Function(This As IDXGISwapChain Ptr, fullscreen As BOOL, target As IDXGIOutput Ptr) As HRESULT
    GetFullscreenState As Function(This As IDXGISwapChain Ptr, fullscreen As BOOL Ptr, target As IDXGIOutput Ptr Ptr) As HRESULT
    GetDesc As Function(This As IDXGISwapChain Ptr, desc As DXGI_SWAP_CHAIN_DESC Ptr) As HRESULT
    ResizeBuffers As Function(This As IDXGISwapChain Ptr, bufferCount As ULong, width As ULong, height As ULong, format As DXGI_FORMAT, flags As ULong) As HRESULT
    ResizeTarget As Function(This As IDXGISwapChain Ptr, pNewTargetParameters As Const DXGI_MODE_DESC Ptr) As HRESULT
    GetContainingOutput As Function(This As IDXGISwapChain Ptr, ppOutput As IDXGIOutput Ptr Ptr) As HRESULT
    GetFrameStatistics As Function(This As IDXGISwapChain Ptr, stats As DXGI_FRAME_STATISTICS Ptr) As HRESULT
    GetLastPresentCount As Function(This As IDXGISwapChain Ptr, pLastPresentCount As ULong Ptr) As HRESULT
End Type

Type IDXGISwapChain_
    lpVtbl As IDXGISwapChainVtbl Ptr
End Type

Dim Shared IID_IDXGIFactory As GUID = Type(&h7B7166EC, &h21C7, &h44AE, {&hB2, &h1A, &hC9, &hAE, &h32, &h1A, &hE3, &h69})

Type IDXGIFactory As IDXGIFactory_

Type IDXGIFactoryVtbl
    ' IUnknown
    QueryInterface As Function(This As IDXGIFactory Ptr, riid As Const GUID Ptr, ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(This As IDXGIFactory Ptr) As ULong
    Release As Function(This As IDXGIFactory Ptr) As ULong

    ' IDXGIObject
    SetPrivateData As Function(This As IDXGIFactory Ptr, name As Const GUID Ptr, dataSize As ULong, data As Any Ptr) As HRESULT
    SetPrivateDataInterface As Function(This As IDXGIFactory Ptr, name As Const GUID Ptr, unknown As IUnknown Ptr) As HRESULT
    GetPrivateData As Function(This As IDXGIFactory Ptr, name As Const GUID Ptr, dataSize As ULong Ptr, data As Any Ptr) As HRESULT
    GetParent As Function(This As IDXGIFactory Ptr, riid As Const GUID Ptr, parent As Any Ptr Ptr) As HRESULT

    ' IDXGIFactory
    EnumAdapters As Function(This As IDXGIFactory Ptr, adapterIndex As ULong, adapter As IDXGIAdapter Ptr Ptr) As HRESULT
    MakeWindowAssociation As Function(This As IDXGIFactory Ptr, windowHandle As HWND, flags As ULong) As HRESULT
    GetWindowAssociation As Function(This As IDXGIFactory Ptr, windowHandle As HWND Ptr) As HRESULT
    CreateSwapChain As Function(ByVal This As IDXGIFactory Ptr, ByVal device As IUnknown Ptr, ByVal desc As Const DXGI_SWAP_CHAIN_DESC Ptr, ByVal swapChain As IDXGISwapChain Ptr Ptr) As HRESULT
    CreateSoftwareAdapter As Function(This As IDXGIFactory Ptr, moduleHandle As HMODULE, adapter As IDXGIAdapter Ptr Ptr) As HRESULT
End Type

Type IDXGIFactory_
    lpVtbl As IDXGIFactoryVtbl Ptr
End Type

Type ID2D1Factory1Vtbl
    ' IUnknown
    QueryInterface            As Function(ByVal This As Any Ptr, ByVal riid As Const GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef                    As Function(ByVal This As Any Ptr) As ULong
    Release                   As Function(ByVal This As Any Ptr) As ULong

    ' ID2D1Factory
    ReloadSystemMetrics       As Function(ByVal This As Any Ptr) As Long
    GetDesktopDpi             As Sub(ByVal This As Any Ptr, ByRef dpiX As Single, ByRef dpiY As Single)
    CreateRectangleGeometry   As Function(ByVal This As Any Ptr, ByRef rect As D2D1_RECT_F, ByRef ppGeometry As Any Ptr) As Long
    CreateRoundedRectangleGeometry As Function(ByVal This As Any Ptr, ByRef roundedRect As D2D1_ROUNDED_RECT, ByRef ppGeometry As Any Ptr) As Long
    CreateEllipseGeometry     As Function(ByVal This As Any Ptr, ByRef ellipse As D2D1_ELLIPSE, ByRef ppGeometry As Any Ptr) As Long
    CreateGeometryGroup       As Function(ByVal This As Any Ptr, ByVal fillMode As D2D1_FILL_MODE, ByRef ppGeometries As Any Ptr Ptr, ByVal geometryCount As ULong, ByRef ppGeometryGroup As Any Ptr) As Long
    CreateTransformedGeometry As Function(ByVal This As Any Ptr, ByVal pSourceGeometry As Any Ptr, ByRef transform As D2D1_MATRIX_3X2_F, ByRef ppGeometry As Any Ptr) As Long
    CreatePathGeometry        As Function(ByVal This As Any Ptr, ByRef ppPathGeometry As Any Ptr) As Long
    CreateStrokeStyle         As Function(ByVal This As Any Ptr, ByRef strokeStyleProperties As D2D1_STROKE_STYLE_PROPERTIES, ByRef dashes As Single, ByVal dashesCount As ULong, ByRef ppStrokeStyle As Any Ptr) As Long
    CreateDrawingStateBlock   As Function(ByVal This As Any Ptr, ByVal drawingStateDescription As Any Ptr, ByVal textRenderingParams As Any Ptr, ByRef ppDrawingStateBlock As Any Ptr) As Long
    CreateWicBitmapRenderTarget As Function(ByVal This As Any Ptr, ByVal target As Any Ptr, ByRef renderTargetProperties As D2D1_RENDER_TARGET_PROPERTIES, ByRef ppRenderTarget As Any Ptr) As Long
    CreateHwndRenderTarget    As Function(ByVal This As Any Ptr, ByRef renderTargetProperties As D2D1_RENDER_TARGET_PROPERTIES, ByRef hwndRenderTargetProperties As D2D1_HWND_RENDER_TARGET_PROPERTIES, ByRef ppRenderTarget As Any Ptr) As Long
    CreateDxgiSurfaceRenderTarget As Function(ByVal This As Any Ptr, ByVal surface As Any Ptr, ByRef renderTargetProperties As D2D1_RENDER_TARGET_PROPERTIES, ByRef ppRenderTarget As Any Ptr) As Long
    CreateDCRenderTarget      As Function(ByVal This As Any Ptr, ByRef renderTargetProperties As D2D1_RENDER_TARGET_PROPERTIES, ByRef ppRenderTarget As Any Ptr) As Long

    ' ID2D1Factory1
    CreateDevice          As Function(ByVal This As Any Ptr, ByVal dxgiDevice As IDXGIDevice Ptr, ByVal d2dDevice As ID2D1Device Ptr Ptr) As HRESULT
    CreateStrokeStyle1    As Function(ByVal This As Any Ptr, ByVal strokeStyleProperties As Const D2D1_STROKE_STYLE_PROPERTIES1 Ptr, ByVal dashes As Single Ptr, ByVal dashesCount As UInteger, ByVal strokeStyle As Any Ptr Ptr) As HRESULT
    CreatePathGeometry1   As Function(ByVal This As Any Ptr, ByVal pathGeometry As Any Ptr Ptr) As HRESULT
    CreateDrawingStateBlock1 As Function(ByVal This As Any Ptr, ByVal drawingStateDescription As Const D2D1_DRAWING_STATE_DESCRIPTION1 Ptr, ByVal textRenderingParams As Any Ptr, ByVal drawingStateBlock As Any Ptr Ptr) As HRESULT
    CreateGdiMetafile     As Function(ByVal This As Any Ptr, ByVal metafileStream As Any Ptr, ByVal metafile As Any Ptr Ptr) As HRESULT
    RegisterEffectFromStream As Function(ByVal This As Any Ptr, ByVal classId As Const GUID Ptr, ByVal propertyXml As Any Ptr, ByVal propertyXmlSize As ULong, ByVal bindings As Any Ptr, ByVal bindingsCount As ULong, ByVal effectFactory As Any Ptr) As HRESULT
    RegisterEffectFromString As Function(ByVal This As Any Ptr, ByVal classId As Const GUID Ptr, ByVal propertyXml As WString Ptr, ByVal bindings As Any Ptr, ByVal bindingsCount As ULong, ByVal effectFactory As Any Ptr) As HRESULT
    UnregisterEffect      As Function(ByVal This As Any Ptr, ByVal classId As Const GUID Ptr) As HRESULT
    GetRegisteredEffects  As Function(ByVal This As Any Ptr, ByVal effects As GUID Ptr, ByVal effectsCount As ULong, ByVal effectsReturned As ULong Ptr, ByVal effectsRegistered As ULong Ptr) As HRESULT
    GetEffectProperties   As Function(ByVal This As Any Ptr, ByVal effectId As Const GUID Ptr, ByVal properties As Any Ptr Ptr) As HRESULT
End Type

Type ID2D1Factory1
	lpVtbl As ID2D1Factory1Vtbl Ptr
End Type

Type IDWriteFactoryVtbl
    ' IUnknown
    QueryInterface                      As Function(ByVal This As Any Ptr, ByRef riid As GUID, ByRef ppvObject As Any Ptr) As Long
    AddRef                              As Function(ByVal This As Any Ptr) As ULong
    Release                             As Function(ByVal This As Any Ptr) As ULong

    ' IDWriteFactory
    GetSystemFontCollection             As Function(ByVal This As Any Ptr, ByRef fontCollection As Any Ptr, ByVal checkForUpdates As Long) As Long
    CreateCustomFontCollection          As Function(ByVal This As Any Ptr, ByVal loader As Any Ptr, ByVal collectionKey As Any Ptr, ByVal keySize As ULong, ByRef fontCollection As Any Ptr) As Long
    RegisterFontCollectionLoader        As Function(ByVal This As Any Ptr, ByVal fontCollectionLoader As Any Ptr) As Long
    UnregisterFontCollectionLoader      As Function(ByVal This As Any Ptr, ByVal fontCollectionLoader As Any Ptr) As Long
    CreateFontFileReference             As Function(ByVal This As Any Ptr, ByVal filePath As WString Ptr, ByVal lastWriteTime As Any Ptr, ByRef fontFile As Any Ptr) As Long
    CreateCustomFontFileReference       As Function(ByVal This As Any Ptr, ByVal fontFileReferenceKey As Any Ptr, ByVal keySize As ULong, ByVal fontFileLoader As Any Ptr, ByRef fontFile As Any Ptr) As Long
    CreateFontFace                      As Function(ByVal This As Any Ptr, ByVal faceType As ULong, ByVal fontFiles As Any Ptr Ptr, ByVal fileCount As ULong, ByVal faceIndex As ULong, ByVal simulationFlags As ULong, ByRef fontFace As Any Ptr) As Long
    CreateRenderingParams               As Function(ByVal This As Any Ptr, ByRef renderingParams As Any Ptr) As Long
    CreateMonitorRenderingParams        As Function(ByVal This As Any Ptr, ByVal monitor As Any Ptr, ByRef renderingParams As Any Ptr) As Long
    CreateCustomRenderingParams         As Function(ByVal This As Any Ptr, ByVal gamma As Single, ByVal enhancedContrast As Single, ByVal clearTypeLevel As Single, ByVal pixelGeometry As ULong, ByVal renderingMode As ULong, ByRef renderingParams As Any Ptr) As Long
    RegisterFontFileLoader              As Function(ByVal This As Any Ptr, ByVal fontFileLoader As Any Ptr) As Long
    UnregisterFontFileLoader            As Function(ByVal This As Any Ptr, ByVal fontFileLoader As Any Ptr) As Long
    CreateTextFormat                    As Function(ByVal This As Any Ptr, ByVal fontFamilyName As WString Ptr, ByVal fontCollection As Any Ptr, ByVal fontWeight As ULong, ByVal fontStyle As ULong, ByVal fontStretch As ULong, ByVal fontSize As Single, ByVal localeName As WString Ptr, ByRef textFormat As Any Ptr) As Long
    CreateTypography                    As Function(ByVal This As Any Ptr, ByRef typography As Any Ptr) As Long
    GetGdiInterop                       As Function(ByVal This As Any Ptr, ByRef gdiInterop As Any Ptr) As Long
    CreateTextLayout                    As Function(ByVal This As Any Ptr, ByVal text As WString Ptr, ByVal textLength As ULong, ByVal textFormat As Any Ptr, ByVal maxWidth As Single, ByVal maxHeight As Single, ByRef textLayout As Any Ptr) As Long
    CreateGdiCompatibleTextLayout       As Function(ByVal This As Any Ptr, ByVal text As WString Ptr, ByVal textLength As ULong, ByVal textFormat As Any Ptr, ByVal layoutWidth As Single, ByVal layoutHeight As Single, ByVal pixelsPerDip As Single, ByVal transform As Any Ptr, ByVal useGdiNatural As Long, ByRef textLayout As Any Ptr) As Long
    CreateEllipsisTrimmingSign          As Function(ByVal This As Any Ptr, ByVal textFormat As Any Ptr, ByVal textLayout As Any Ptr, ByRef trimmingSign As Any Ptr) As Long
    CreateTextAnalyzer                 As Function(ByVal This As Any Ptr, ByRef textAnalyzer As Any Ptr) As Long
    CreateNumberSubstitution           As Function(ByVal This As Any Ptr, ByVal substitutionMethod As ULong, ByVal localeName As WString Ptr, ByVal ignoreUserOverrides As Long, ByRef numberSubstitution As Any Ptr) As Long
    CreateGlyphRunAnalysis             As Function(ByVal This As Any Ptr, ByVal glyphRun As Any Ptr, ByVal pixelsPerDip As Single, ByVal transform As Any Ptr, ByVal renderingMode As ULong, ByVal measuringMode As ULong, ByVal baselineX As Single, ByVal baselineY As Single, ByRef glyphRunAnalysis As Any Ptr) As Long
End Type

Type IDWriteFactory
    lpVtbl As IDWriteFactoryVtbl Ptr
End Type

Type fnCreateTextLayout As Function( _
ByVal This As IDWriteFactory Ptr, _
ByVal text As LPCWSTR, _
ByVal textLength As UINT32, _
ByVal fformat As IDWriteTextFormat Ptr, _
ByVal maxWidth As Single, _
ByVal maxHeight As Single, _
ByVal textLayout As IDWriteTextLayout Ptr Ptr _
) As HRESULT

Dim Shared CreateTextLayout As fnCreateTextLayout

Type D2D1CreateFactoryType As Function( _
ByVal factoryType As Long, _
ByVal riid As Const GUID Ptr, _
ByVal pFactoryOptions As D2D1_FACTORY_OPTIONS Ptr, _
ByVal ppIFactory As Any Ptr Ptr _
) As Long

Type D2D1GetDebugInterfaceType As Function( _
ByVal riid As REFIID, _
    ByVal ppv As Any Ptr Ptr _
) As HRESULT

Type D3D_FEATURE_LEVEL As Long
Enum
    D3D_FEATURE_LEVEL_9_1  = &h9100
    D3D_FEATURE_LEVEL_9_2  = &h9200
    D3D_FEATURE_LEVEL_9_3  = &h9300
    D3D_FEATURE_LEVEL_10_0 = &ha000
    D3D_FEATURE_LEVEL_10_1 = &ha100
    D3D_FEATURE_LEVEL_11_0 = &hb000
    D3D_FEATURE_LEVEL_11_1 = &hb100
    D3D_FEATURE_LEVEL_12_0 = &hc000
    D3D_FEATURE_LEVEL_12_1 = &hc100
End Enum

Type D3D_DRIVER_TYPE As Long
Enum
    D3D_DRIVER_TYPE_UNKNOWN           = 0
    D3D_DRIVER_TYPE_HARDWARE          = 1
    D3D_DRIVER_TYPE_REFERENCE         = 2
    D3D_DRIVER_TYPE_NULL              = 3
    D3D_DRIVER_TYPE_SOFTWARE          = 4
    D3D_DRIVER_TYPE_WARP              = 5
End Enum

Type ID3D11DeviceVtbl
    ' IUnknown
    QueryInterface              As Function(ByVal This As Any Ptr, ByVal riid As Const GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef                      As Function(ByVal This As Any Ptr) As ULong
    Release                     As Function(ByVal This As Any Ptr) As ULong

    ' ID3D11Device
    CreateBuffer                As Function(ByVal This As Any Ptr, ByVal pDesc As Any Ptr, ByVal pInitialData As Any Ptr, ByVal ppBuffer As Any Ptr Ptr) As HRESULT
    CreateTexture1D             As Function(ByVal This As Any Ptr, ByVal pDesc As Any Ptr, ByVal pInitialData As Any Ptr, ByVal ppTexture1D As Any Ptr Ptr) As HRESULT
    CreateTexture2D             As Function(ByVal This As Any Ptr, ByVal pDesc As Any Ptr, ByVal pInitialData As Any Ptr, ByVal ppTexture2D As Any Ptr Ptr) As HRESULT
    CreateTexture3D             As Function(ByVal This As Any Ptr, ByVal pDesc As Any Ptr, ByVal pInitialData As Any Ptr, ByVal ppTexture3D As Any Ptr Ptr) As HRESULT
    CreateShaderResourceView    As Function(ByVal This As Any Ptr, ByVal pResource As Any Ptr, ByVal pDesc As Any Ptr, ByVal ppSRView As Any Ptr Ptr) As HRESULT
    CreateUnorderedAccessView   As Function(ByVal This As Any Ptr, ByVal pResource As Any Ptr, ByVal pDesc As Any Ptr, ByVal ppUAView As Any Ptr Ptr) As HRESULT
    CreateRenderTargetView      As Function(ByVal This As Any Ptr, ByVal pResource As Any Ptr, ByVal pDesc As Any Ptr, ByVal ppRTView As Any Ptr Ptr) As HRESULT
    CreateDepthStencilView      As Function(ByVal This As Any Ptr, ByVal pResource As Any Ptr, ByVal pDesc As Any Ptr, ByVal ppDSView As Any Ptr Ptr) As HRESULT
    CreateInputLayout           As Function(ByVal This As Any Ptr, ByVal pInputElementDescs As Any Ptr, ByVal NumElements As UInteger, ByVal pShaderBytecodeWithInputSignature As Any Ptr, ByVal BytecodeLength As UInteger, ByVal ppInputLayout As Any Ptr Ptr) As HRESULT
    CreateVertexShader          As Function(ByVal This As Any Ptr, ByVal pShaderBytecode As Any Ptr, ByVal BytecodeLength As UInteger, ByVal pClassLinkage As Any Ptr, ByVal ppVertexShader As Any Ptr Ptr) As HRESULT
    CreateGeometryShader        As Function(ByVal This As Any Ptr, ByVal pShaderBytecode As Any Ptr, ByVal BytecodeLength As UInteger, ByVal pClassLinkage As Any Ptr, ByVal ppGeometryShader As Any Ptr Ptr) As HRESULT
    CreatePixelShader           As Function(ByVal This As Any Ptr, ByVal pShaderBytecode As Any Ptr, ByVal BytecodeLength As UInteger, ByVal pClassLinkage As Any Ptr, ByVal ppPixelShader As Any Ptr Ptr) As HRESULT
    CreateHullShader            As Function(ByVal This As Any Ptr, ByVal pShaderBytecode As Any Ptr, ByVal BytecodeLength As UInteger, ByVal pClassLinkage As Any Ptr, ByVal ppHullShader As Any Ptr Ptr) As HRESULT
    CreateDomainShader          As Function(ByVal This As Any Ptr, ByVal pShaderBytecode As Any Ptr, ByVal BytecodeLength As UInteger, ByVal pClassLinkage As Any Ptr, ByVal ppDomainShader As Any Ptr Ptr) As HRESULT
    CreateComputeShader         As Function(ByVal This As Any Ptr, ByVal pShaderBytecode As Any Ptr, ByVal BytecodeLength As UInteger, ByVal pClassLinkage As Any Ptr, ByVal ppComputeShader As Any Ptr Ptr) As HRESULT
    CreateClassLinkage          As Function(ByVal This As Any Ptr, ByVal ppLinkage As Any Ptr Ptr) As HRESULT
    CreateBlendState            As Function(ByVal This As Any Ptr, ByVal pBlendStateDesc As Any Ptr, ByVal ppBlendState As Any Ptr Ptr) As HRESULT
    CreateDepthStencilState     As Function(ByVal This As Any Ptr, ByVal pDepthStencilDesc As Any Ptr, ByVal ppDepthStencilState As Any Ptr Ptr) As HRESULT
    CreateRasterizerState       As Function(ByVal This As Any Ptr, ByVal pRasterizerDesc As Any Ptr, ByVal ppRasterizerState As Any Ptr Ptr) As HRESULT
    CreateSamplerState          As Function(ByVal This As Any Ptr, ByVal pSamplerDesc As Any Ptr, ByVal ppSamplerState As Any Ptr Ptr) As HRESULT
    CreateQuery                 As Function(ByVal This As Any Ptr, ByVal pQueryDesc As Any Ptr, ByVal ppQuery As Any Ptr Ptr) As HRESULT
    CreatePredicate             As Function(ByVal This As Any Ptr, ByVal pPredicateDesc As Any Ptr, ByVal ppPredicate As Any Ptr Ptr) As HRESULT
    CreateCounter               As Function(ByVal This As Any Ptr, ByVal pCounterDesc As Any Ptr, ByVal ppCounter As Any Ptr Ptr) As HRESULT
    CreateDeferredContext       As Function(ByVal This As Any Ptr, ByVal ContextFlags As UInteger, ByVal ppDeferredContext As Any Ptr Ptr) As HRESULT
    OpenSharedResource          As Function(ByVal This As Any Ptr, ByVal hResource As HANDLE, ByVal riid As Const GUID Ptr, ByVal ppResource As Any Ptr Ptr) As HRESULT
    CheckFormatSupport          As Function(ByVal This As Any Ptr, ByVal Format As UInteger, ByVal pFormatSupport As UInteger Ptr) As HRESULT
    CheckMultisampleQualityLevels As Function(ByVal This As Any Ptr, ByVal Format As UInteger, ByVal SampleCount As UInteger, ByVal pNumQualityLevels As UInteger Ptr) As HRESULT
    CheckCounterInfo            As Sub     (ByVal This As Any Ptr, ByVal pCounterInfo As Any Ptr)
    CheckCounter                As Function(ByVal This As Any Ptr, ByVal pDesc As Any Ptr, ByVal pType As Any Ptr, ByVal pActiveCounters As UInteger Ptr, ByVal szName As ZString Ptr, ByVal pNameLength As UInteger Ptr, ByVal szUnits As ZString Ptr, ByVal pUnitsLength As UInteger Ptr, ByVal szDesc As ZString Ptr, ByVal pDescLength As UInteger Ptr) As HRESULT
    CheckFeatureSupport         As Function(ByVal This As Any Ptr, ByVal Feature As UInteger, ByVal pFeatureSupportData As Any Ptr, ByVal FeatureSupportDataSize As UInteger) As HRESULT
    GetPrivateData              As Function(ByVal This As Any Ptr, ByVal guid As Const guid Ptr, ByVal pDataSize As UInteger Ptr, ByVal pData As Any Ptr) As HRESULT
    SetPrivateData              As Function(ByVal This As Any Ptr, ByVal guid As Const guid Ptr, ByVal DataSize As UInteger, ByVal pData As Const Any Ptr) As HRESULT
    SetPrivateDataInterface     As Function(ByVal This As Any Ptr, ByVal guid As Const guid Ptr, ByVal pData As Any Ptr) As HRESULT
    GetFeatureLevel             As Function(ByVal This As Any Ptr) As UInteger
    GetCreationFlags            As Function(ByVal This As Any Ptr) As UInteger
    GetDeviceRemovedReason      As Function(ByVal This As Any Ptr) As HRESULT
    GetImmediateContext         As Sub     (ByVal This As Any Ptr, ByVal ppImmediateContext As Any Ptr Ptr)
    SetExceptionMode            As Function(ByVal This As Any Ptr, ByVal RaiseFlags As UInteger) As HRESULT
    GetExceptionMode            As Function(ByVal This As Any Ptr) As UInteger
End Type

Type ID3D11Device
    lpVtbl As ID3D11DeviceVtbl Ptr
End Type

Type ID3D11DeviceContextVtbl
    ' IUnknown
    QueryInterface           As Function(ByVal This As Any Ptr, ByVal riid As Const GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef                   As Function(ByVal This As Any Ptr) As ULong
    Release                  As Function(ByVal This As Any Ptr) As ULong

    ' ID3D11DeviceChild
    GetDevice                As Sub(ByVal This As Any Ptr, ByVal ppDevice As Any Ptr Ptr)
    GetPrivateData           As Function(ByVal This As Any Ptr, ByVal guid As Const guid Ptr, ByVal pDataSize As UInteger Ptr, ByVal pData As Any Ptr) As HRESULT
    SetPrivateData           As Function(ByVal This As Any Ptr, ByVal guid As Const guid Ptr, ByVal DataSize As UInteger, ByVal pData As Const Any Ptr) As HRESULT
    SetPrivateDataInterface  As Function(ByVal This As Any Ptr, ByVal guid As Const guid Ptr, ByVal pData As Any Ptr) As HRESULT

    ' ID3D11DeviceContext
    VSSetConstantBuffers     As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
    PSSetShaderResources     As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
    PSSetShader              As Sub(ByVal This As Any Ptr, ByVal pPixelShader As Any Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal NumClassInstances As UInteger)
    PSSetSamplers            As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
    VSSetShader              As Sub(ByVal This As Any Ptr, ByVal pVertexShader As Any Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal NumClassInstances As UInteger)
    DrawIndexed              As Sub(ByVal This As Any Ptr, ByVal IndexCount As UInteger, ByVal StartIndexLocation As UInteger, ByVal BaseVertexLocation As Integer)
    Draw                     As Sub(ByVal This As Any Ptr, ByVal VertexCount As UInteger, ByVal StartVertexLocation As UInteger)
    Map                      As Function(ByVal This As Any Ptr, ByVal pResource As Any Ptr, ByVal Subresource As UInteger, ByVal MapType As UInteger, ByVal MapFlags As UInteger, ByVal pMappedResource As Any Ptr) As HRESULT
    Unmap                    As Sub(ByVal This As Any Ptr, ByVal pResource As Any Ptr, ByVal Subresource As UInteger)
    PSSetConstantBuffers         As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
    IASetInputLayout             As Sub(ByVal This As Any Ptr, ByVal pInputLayout As Any Ptr)
    IASetVertexBuffers           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppVertexBuffers As Any Ptr Ptr, ByVal pStrides As UInteger Ptr, ByVal pOffsets As UInteger Ptr)
    IASetIndexBuffer             As Sub(ByVal This As Any Ptr, ByVal pIndexBuffer As Any Ptr, ByVal Format As UInteger, ByVal Offset As UInteger)
    DrawIndexedInstanced         As Sub(ByVal This As Any Ptr, ByVal IndexCountPerInstance As UInteger, ByVal InstanceCount As UInteger, ByVal StartIndexLocation As UInteger, ByVal BaseVertexLocation As Integer, ByVal StartInstanceLocation As UInteger)
    DrawInstanced                As Sub(ByVal This As Any Ptr, ByVal VertexCountPerInstance As UInteger, ByVal InstanceCount As UInteger, ByVal StartVertexLocation As UInteger, ByVal StartInstanceLocation As UInteger)
    GSSetConstantBuffers         As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
    GSSetShader                  As Sub(ByVal This As Any Ptr, ByVal pShader As Any Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal NumClassInstances As UInteger)
    IASetPrimitiveTopology       As Sub(ByVal This As Any Ptr, ByVal Topology As UInteger)
    VSSetShaderResources         As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
    VSSetSamplers                As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
    Begin_                      As Sub(ByVal This As Any Ptr, ByVal pAsync As Any Ptr)
    End_                        As Sub(ByVal This As Any Ptr, ByVal pAsync As Any Ptr)
    GetData                     As Function(ByVal This As Any Ptr, ByVal pAsync As Any Ptr, ByVal pData As Any Ptr, ByVal DataSize As UInteger, ByVal GetDataFlags As UInteger) As HRESULT
    SetPredication               As Sub(ByVal This As Any Ptr, ByVal pPredicate As Any Ptr, ByVal PredicateValue As BOOL)
    GSSetShaderResources         As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
    GSSetSamplers                As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
    OMSetRenderTargets           As Sub(ByVal This As Any Ptr, ByVal NumViews As UInteger, ByVal ppRenderTargetViews As Any Ptr Ptr, ByVal pDepthStencilView As Any Ptr)
    OMSetRenderTargetsAndUnorderedAccessViews As Sub(ByVal This As Any Ptr, ByVal NumRTVs As UInteger, ByVal ppRTVs As Any Ptr Ptr, ByVal pDSV As Any Ptr, ByVal UAVStartSlot As UInteger, ByVal NumUAVs As UInteger, ByVal ppUAVs As Any Ptr Ptr, ByVal pUAVInitialCounts As UInteger Ptr)
    OMSetBlendState              As Sub(ByVal This As Any Ptr, ByVal pBlendState As Any Ptr, ByVal BlendFactor As Single Ptr, ByVal SampleMask As UInteger)
    OMSetDepthStencilState       As Sub(ByVal This As Any Ptr, ByVal pDepthStencilState As Any Ptr, ByVal StencilRef As UInteger)
    SOSetTargets                 As Sub(ByVal This As Any Ptr, ByVal NumBuffers As UInteger, ByVal ppSOTargets As Any Ptr Ptr, ByVal pOffsets As UInteger Ptr)
    DrawAuto                     As Sub(ByVal This As Any Ptr)
    DrawIndexedInstancedIndirect As Sub(ByVal This As Any Ptr, ByVal pBufferForArgs As Any Ptr, ByVal AlignedByteOffsetForArgs As UInteger)
    DrawInstancedIndirect         As Sub(ByVal This As Any Ptr, ByVal pBufferForArgs As Any Ptr, ByVal AlignedByteOffsetForArgs As UInteger)
    Dispatch                      As Sub(ByVal This As Any Ptr, ByVal ThreadGroupCountX As UInteger, ByVal ThreadGroupCountY As UInteger, ByVal ThreadGroupCountZ As UInteger)
    DispatchIndirect               As Sub(ByVal This As Any Ptr, ByVal pBufferForArgs As Any Ptr, ByVal AlignedByteOffsetForArgs As UInteger)
    RSSetState                      As Sub(ByVal This As Any Ptr, ByVal pRasterizerState As Any Ptr)
    RSSetViewports                  As Sub(ByVal This As Any Ptr, ByVal NumViewports As UInteger, ByVal pViewports As Any Ptr)
    RSSetScissorRects               As Sub(ByVal This As Any Ptr, ByVal NumRects As UInteger, ByVal pRects As Any Ptr)
    CopySubresourceRegion          As Sub(ByVal This As Any Ptr, ByVal pDstResource As Any Ptr, ByVal DstSubresource As UInteger, ByVal DstX As UInteger, ByVal DstY As UInteger, ByVal DstZ As UInteger, ByVal pSrcResource As Any Ptr, ByVal SrcSubresource As UInteger, ByVal pSrcBox As Any Ptr)
    CopyResource                   As Sub(ByVal This As Any Ptr, ByVal pDstResource As Any Ptr, ByVal pSrcResource As Any Ptr)
    UpdateSubresource              As Sub(ByVal This As Any Ptr, ByVal pDstResource As Any Ptr, ByVal DstSubresource As UInteger, ByVal pDstBox As Any Ptr, ByVal pSrcData As Any Ptr, ByVal SrcRowPitch As UInteger, ByVal SrcDepthPitch As UInteger)
    CopyStructureCount             As Sub(ByVal This As Any Ptr, ByVal pDstBuffer As Any Ptr, ByVal DstAlignedByteOffset As UInteger, ByVal pSrcView As Any Ptr)
    ClearRenderTargetView          As Sub(ByVal This As Any Ptr, ByVal pRenderTargetView As Any Ptr, ByVal ColorRGBA As Single Ptr)
    ClearUnorderedAccessViewUint   As Sub(ByVal This As Any Ptr, ByVal pUnorderedAccessView As Any Ptr, ByVal Values As UInteger Ptr)
    ClearUnorderedAccessViewFloat  As Sub(ByVal This As Any Ptr, ByVal pUnorderedAccessView As Any Ptr, ByVal Values As Single Ptr)
    ClearDepthStencilView          As Sub(ByVal This As Any Ptr, ByVal pDepthStencilView As Any Ptr, ByVal ClearFlags As UInteger, ByVal Depth As Single, ByVal Stencil As UByte)
    GenerateMips                   As Sub(ByVal This As Any Ptr, ByVal pShaderResourceView As Any Ptr)
    SetResourceMinLOD              As Sub(ByVal This As Any Ptr, ByVal pResource As Any Ptr, ByVal MinLOD As Single)
    GetResourceMinLOD              As Function(ByVal This As Any Ptr, ByVal pResource As Any Ptr) As Single
    ResolveSubresource             As Sub(ByVal This As Any Ptr, ByVal pDstResource As Any Ptr, ByVal DstSubresource As UInteger, ByVal pSrcResource As Any Ptr, ByVal SrcSubresource As UInteger, ByVal Format As UInteger)
    ExecuteCommandList             As Sub(ByVal This As Any Ptr, ByVal pCommandList As Any Ptr, ByVal RestoreContextState As BOOL)
    HSSetShaderResources           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
    HSSetShader                    As Sub(ByVal This As Any Ptr, ByVal pHullShader As Any Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal NumClassInstances As UInteger)
    HSSetSamplers                  As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
    HSSetConstantBuffers           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
    DSSetShaderResources           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
    DSSetShader                    As Sub(ByVal This As Any Ptr, ByVal pDomainShader As Any Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal NumClassInstances As UInteger)
    DSSetSamplers                  As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
    DSSetConstantBuffers           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
    CSSetShaderResources           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
    CSSetUnorderedAccessViews      As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumUAVs As UInteger, ByVal ppUnorderedAccessViews As Any Ptr Ptr, ByVal pUAVInitialCounts As UInteger Ptr)
    CSSetShader                    As Sub(ByVal This As Any Ptr, ByVal pComputeShader As Any Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal NumClassInstances As UInteger)
    CSSetSamplers                  As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
    CSSetConstantBuffers           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
    VSGetConstantBuffers           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
    PSGetShaderResources           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
    PSGetShader                    As Sub(ByVal This As Any Ptr, ByVal ppPixelShader As Any Ptr Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal pNumClassInstances As UInteger Ptr)
    PSGetSamplers                  As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
    VSGetShader                    As Sub(ByVal This As Any Ptr, ByVal ppVertexShader As Any Ptr Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal pNumClassInstances As UInteger Ptr)
    PSGetConstantBuffers           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
    IAGetInputLayout               As Sub(ByVal This As Any Ptr, ByVal ppInputLayout As Any Ptr Ptr)
    IAGetVertexBuffers             As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppVertexBuffers As Any Ptr Ptr, ByVal pStrides As UInteger Ptr, ByVal pOffsets As UInteger Ptr)
    IAGetIndexBuffer               As Sub(ByVal This As Any Ptr, ByVal ppIndexBuffer As Any Ptr Ptr, ByVal pFormat As UInteger Ptr, ByVal pOffset As UInteger Ptr)
    GSGetConstantBuffers           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
    GSGetShader                    As Sub(ByVal This As Any Ptr, ByVal ppGeometryShader As Any Ptr Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal pNumClassInstances As UInteger Ptr)
    IAGetPrimitiveTopology         As Sub(ByVal This As Any Ptr, ByVal pTopology As UInteger Ptr)
    VSGetShaderResources           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
    VSGetSamplers                  As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
    GetPredication                 As Sub(ByVal This As Any Ptr, ByVal ppPredicate As Any Ptr Ptr, ByVal pPredicateValue As BOOL Ptr)
    GSGetShaderResources           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
    GSGetSamplers                  As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
    OMGetRenderTargets             As Sub(ByVal This As Any Ptr, ByVal NumViews As UInteger, ByVal ppRenderTargetViews As Any Ptr Ptr, ByVal ppDepthStencilView As Any Ptr Ptr)
    OMGetRenderTargetsAndUnorderedAccessViews As Sub(ByVal This As Any Ptr, ByVal NumRTVs As UInteger, ByVal ppRTVs As Any Ptr Ptr, ByVal ppDSV As Any Ptr Ptr, ByVal UAVStartSlot As UInteger, ByVal NumUAVs As UInteger, ByVal ppUAVs As Any Ptr Ptr)
    OMGetBlendState                As Sub(ByVal This As Any Ptr, ByVal ppBlendState As Any Ptr Ptr, ByVal BlendFactor As Single Ptr, ByVal pSampleMask As UInteger Ptr)
    OMGetDepthStencilState         As Sub(ByVal This As Any Ptr, ByVal ppDepthStencilState As Any Ptr Ptr, ByVal pStencilRef As UInteger Ptr)
    SOGetTargets                   As Sub(ByVal This As Any Ptr, ByVal NumBuffers As UInteger, ByVal ppSOTargets As Any Ptr Ptr)
    RSGetState                     As Sub(ByVal This As Any Ptr, ByVal ppRasterizerState As Any Ptr Ptr)
    RSGetViewports                 As Sub(ByVal This As Any Ptr, ByVal pNumViewports As UInteger Ptr, ByVal pViewports As Any Ptr)
    RSGetScissorRects              As Sub(ByVal This As Any Ptr, ByVal pNumRects As UInteger Ptr, ByVal pRects As Any Ptr)
    HSGetShaderResources           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
    HSGetShader                    As Sub(ByVal This As Any Ptr, ByVal ppHullShader As Any Ptr Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal pNumClassInstances As UInteger Ptr)
    HSGetSamplers                  As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
    HSGetConstantBuffers           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
    DSGetShaderResources           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
    DSGetShader                    As Sub(ByVal This As Any Ptr, ByVal ppDomainShader As Any Ptr Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal pNumClassInstances As UInteger Ptr)
    DSGetSamplers                  As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
    DSGetConstantBuffers           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
    CSGetShaderResources           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumViews As UInteger, ByVal ppShaderResourceViews As Any Ptr Ptr)
    CSGetUnorderedAccessViews      As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumUAVs As UInteger, ByVal ppUnorderedAccessViews As Any Ptr Ptr)
    CSGetShader                    As Sub(ByVal This As Any Ptr, ByVal ppComputeShader As Any Ptr Ptr, ByVal ppClassInstances As Any Ptr Ptr, ByVal pNumClassInstances As UInteger Ptr)
    CSGetSamplers                  As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumSamplers As UInteger, ByVal ppSamplers As Any Ptr Ptr)
    CSGetConstantBuffers           As Sub(ByVal This As Any Ptr, ByVal StartSlot As UInteger, ByVal NumBuffers As UInteger, ByVal ppConstantBuffers As Any Ptr Ptr)
    ClearState                     As Sub(ByVal This As Any Ptr)
    Flush                          As Sub(ByVal This As Any Ptr)
    GetType_                       As Sub(ByVal This As Any Ptr, ByVal pType As UInteger Ptr)
    GetContextFlags                As Sub(ByVal This As Any Ptr, ByVal pFlags As UInteger Ptr)
    FinishCommandList              As Function(ByVal This As Any Ptr, ByVal RestoreDeferredContextState As BOOL, ByVal ppCommandList As Any Ptr Ptr) As HRESULT
End Type

Type ID3D11DeviceContext
    lpVtbl As ID3D11DeviceContextVtbl Ptr
End Type

Dim Shared IID_IDXGIFactory2 As GUID = (&h50C83A1C, &hE072, &h4C48, {&h87, &hB0, &h36, &h30, &hFA, &h36, &hA6, &hD0})

Type DXGI_SWAP_CHAIN_FULLSCREEN_DESC
    RefreshRate       As DXGI_RATIONAL
    ScanlineOrdering  As DXGI_MODE_SCANLINE_ORDER
    Scaling           As DXGI_MODE_SCALING
    Windowed          As BOOL
End Type

Type DXGI_ADAPTER_DESC1
    Description(127) As WCHAR       ' WCHAR[128] = 256 bytes
    VendorId As UInteger
    DeviceId As UInteger
    SubSysId As UInteger
    Revision As UInteger
    DedicatedVideoMemory As ULongInt
    DedicatedSystemMemory As ULongInt
    SharedSystemMemory As ULongInt
    AdapterLuid As LUID
    Flags As UInteger
End Type

Type IDXGIAdapter1Vtbl
    ' IUnknown
    QueryInterface As Function(ByVal This As Any Ptr, ByVal riid As REFIID, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef         As Function(ByVal This As Any Ptr) As ULong
    Release        As Function(ByVal This As Any Ptr) As ULong

    ' IDXGIObject
    SetPrivateData          As Function(ByVal This As Any Ptr, ByVal Name As REFGUID, ByVal DataSize As UINT, ByVal pData As Any Ptr) As HRESULT
    SetPrivateDataInterface As Function(ByVal This As Any Ptr, ByVal Name As REFGUID, ByVal pUnknown As IUnknown Ptr) As HRESULT
    GetPrivateData          As Function(ByVal This As Any Ptr, ByVal Name As REFGUID, ByRef DataSize As UINT, ByVal pData As Any Ptr) As HRESULT
    GetParent               As Function(ByVal This As Any Ptr, ByVal riid As REFIID, ByVal ppParent As Any Ptr Ptr) As HRESULT

    ' IDXGIAdapter
    EnumOutputs             As Function(ByVal This As Any Ptr, ByVal Output As UINT, ByVal ppOutput As IDXGIOutput Ptr Ptr) As HRESULT
    GetDesc                 As Function(ByVal This As Any Ptr, ByRef pDesc As DXGI_ADAPTER_DESC) As HRESULT
    CheckInterfaceSupport   As Function(ByVal This As Any Ptr, ByVal InterfaceName As REFGUID, ByRef pUMDVersion As LARGE_INTEGER) As HRESULT

    ' IDXGIAdapter1
    GetDesc1                As Function(ByVal This As Any Ptr, ByRef pDesc As DXGI_ADAPTER_DESC1) As HRESULT
End Type

Type IDXGIAdapter1
    lpVtbl As IDXGIAdapter1Vtbl Ptr
End Type

Type DXGI_RECT
    left   As Long
    top    As Long
    right  As Long
    bottom As Long
End Type

Type DXGI_PRESENT_PARAMETERS
    DirtyRectsCount As UInteger
    pDirtyRects     As RECT Ptr          ' RECT is already defined in Windows headers
    pScrollRect     As DXGI_RECT Ptr
    pScrollOffset   As Point Ptr
End Type

Type IDXGISwapChain1Vtbl
    ' IUnknown
    QueryInterface  As Function(This As Any Ptr, riid As REFIID, ppvObject As Any Ptr Ptr) As HRESULT
    AddRef          As Function(This As Any Ptr) As ULong
    Release         As Function(This As Any Ptr) As ULong

    ' IDXGIObject
    SetPrivateData           As Function(This As Any Ptr, Name As REFGUID, DataSize As UINT, pData As Any Ptr) As HRESULT
    SetPrivateDataInterface  As Function(This As Any Ptr, Name As REFGUID, pUnknown As IUnknown Ptr) As HRESULT
    GetPrivateData           As Function(This As Any Ptr, Name As REFGUID, ByRef DataSize As UINT, pData As Any Ptr) As HRESULT
    GetParent                As Function(This As Any Ptr, riid As REFIID, ppParent As Any Ptr Ptr) As HRESULT

    ' IDXGIDeviceSubObject
    GetDevice                As Function(This As Any Ptr, riid As REFIID, ppDevice As Any Ptr Ptr) As HRESULT

    ' IDXGISwapChain
    Present                  As Function(This As Any Ptr, SyncInterval As UINT, Flags As UINT) As HRESULT
    GetBuffer                As Function(This As Any Ptr, Buffer As UINT, riid As REFIID, ppSurface As Any Ptr Ptr) As HRESULT
    SetFullscreenState       As Function(This As Any Ptr, Fullscreen As BOOL, pTarget As IDXGIOutput Ptr) As HRESULT
    GetFullscreenState       As Function(This As Any Ptr, ByRef Fullscreen As BOOL, ppTarget As IDXGIOutput Ptr Ptr) As HRESULT
    GetDesc                  As Function(This As Any Ptr, pDesc As DXGI_SWAP_CHAIN_DESC Ptr) As HRESULT
    ResizeBuffers            As Function(This As Any Ptr, BufferCount As UINT, Width As UINT, Height As UINT, NewFormat As DXGI_FORMAT, SwapChainFlags As UINT) As HRESULT
    ResizeTarget             As Function(This As Any Ptr, pNewTargetParameters As DXGI_MODE_DESC Ptr) As HRESULT
    GetContainingOutput      As Function(This As Any Ptr, ppOutput As IDXGIOutput Ptr Ptr) As HRESULT
    GetFrameStatistics       As Function(This As Any Ptr, pStats As DXGI_FRAME_STATISTICS Ptr) As HRESULT
    GetLastPresentCount      As Function(This As Any Ptr, pLastPresentCount As UINT Ptr) As HRESULT

    ' IDXGISwapChain1
    GetDesc1                 As Function(This As Any Ptr, pDesc As DXGI_SWAP_CHAIN_DESC1 Ptr) As HRESULT
    GetFullscreenDesc        As Function(This As Any Ptr, pDesc As DXGI_SWAP_CHAIN_FULLSCREEN_DESC Ptr) As HRESULT
    GetHwnd                  As Function(This As Any Ptr, phwnd As HWND Ptr) As HRESULT
    GetCoreWindow            As Function(This As Any Ptr, riid As REFIID, ppUnk As Any Ptr Ptr) As HRESULT
    Present1                 As Function(This As Any Ptr, SyncInterval As UINT, PresentFlags As UINT, pPresentParameters As DXGI_PRESENT_PARAMETERS Ptr) As HRESULT
    IsTemporaryMonoSupported As Function(This As Any Ptr) As BOOL
    GetRestrictToOutput      As Function(This As Any Ptr, ppOutput As IDXGIOutput Ptr Ptr) As HRESULT
    SetBackgroundColor       As Function(This As Any Ptr, pColor As D2D1_COLOR_F Ptr) As HRESULT
    GetBackgroundColor       As Function(This As Any Ptr, pColor As D2D1_COLOR_F Ptr) As HRESULT
    SetRotation              As Function(This As Any Ptr, Rotation As DXGI_MODE_ROTATION) As HRESULT
    GetRotation              As Function(This As Any Ptr, pRotation As DXGI_MODE_ROTATION Ptr) As HRESULT
End Type

Type IDXGISwapChain1
    lpVtbl As IDXGISwapChain1Vtbl Ptr
End Type

Type IDXGIFactory2 As IDXGIFactory2_

Type IDXGIFactory2Vtbl
    ' IUnknown
    QueryInterface As Function(ByVal This As Any Ptr, ByVal riid As REFIID, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef         As Function(ByVal This As Any Ptr) As ULong
    Release        As Function(ByVal This As Any Ptr) As ULong

    ' IDXGIObject
    SetPrivateData           As Function(ByVal This As Any Ptr, ByVal Name As REFGUID, ByVal DataSize As UINT, ByVal pData As Any Ptr) As HRESULT
    SetPrivateDataInterface  As Function(ByVal This As Any Ptr, ByVal Name As REFGUID, ByVal pUnknown As IUnknown Ptr) As HRESULT
    GetPrivateData           As Function(ByVal This As Any Ptr, ByVal Name As REFGUID, ByRef DataSize As UINT, ByVal pData As Any Ptr) As HRESULT
    GetParent                As Function(ByVal This As Any Ptr, ByVal riid As REFIID, ByVal ppParent As Any Ptr Ptr) As HRESULT

    ' IDXGIFactory
    EnumAdapters             As Function(ByVal This As Any Ptr, ByVal Adapter As UINT, ByVal ppAdapter As IDXGIAdapter Ptr Ptr) As HRESULT
    MakeWindowAssociation    As Function(ByVal This As Any Ptr, ByVal WindowHandle As HWND, ByVal Flags As UINT) As HRESULT
    GetWindowAssociation     As Function(ByVal This As Any Ptr, ByRef pWindowHandle As HWND) As HRESULT
    CreateSwapChain          As Function(ByVal This As Any Ptr, ByVal pDevice As IUnknown Ptr, ByRef pDesc As DXGI_SWAP_CHAIN_DESC, ByRef ppSwapChain As IDXGISwapChain Ptr) As HRESULT
    CreateSoftwareAdapter    As Function(ByVal This As Any Ptr, ByVal ModuleHandle As HMODULE, ByVal ppAdapter As IDXGIAdapter Ptr Ptr) As HRESULT

    ' IDXGIFactory1
    EnumAdapters1            As Function(ByVal This As Any Ptr, ByVal Adapter As UINT, ByVal ppAdapter As IDXGIAdapter1 Ptr Ptr) As HRESULT
    IsCurrent                As Function(ByVal This As Any Ptr) As BOOL

    ' IDXGIFactory2
    IsWindowedStereoEnabled  As Function(ByVal This As Any Ptr) As BOOL
    CreateSwapChainForHwnd   As Function(ByVal This As Any Ptr, ByVal pDevice As IUnknown Ptr, ByVal hWnd As HWND, pDesc As DXGI_SWAP_CHAIN_DESC1 Ptr, pFullscreenDesc As DXGI_SWAP_CHAIN_FULLSCREEN_DESC Ptr, ByVal pRestrictToOutput As IDXGIOutput Ptr, ByVal ppSwapChain As IDXGISwapChain1 Ptr Ptr) As HRESULT
    CreateSwapChainForCoreWindow As Function(ByVal This As Any Ptr, ByVal pDevice As IUnknown Ptr, ByVal pWindow As IUnknown Ptr, ByRef pDesc As DXGI_SWAP_CHAIN_DESC1, ByVal pRestrictToOutput As IDXGIOutput Ptr, ByVal ppSwapChain As IDXGISwapChain1 Ptr Ptr) As HRESULT
    GetSharedResourceAdapterLuid As Function(ByVal This As Any Ptr, ByVal hResource As HANDLE, ByRef pLuid As LUID) As HRESULT
    RegisterStereoStatusWindow   As Function(ByVal This As Any Ptr, ByVal WindowHandle As HWND, ByVal wMsg As UINT, ByRef pdwCookie As DWORD) As HRESULT
    RegisterStereoStatusEvent    As Function(ByVal This As Any Ptr, ByVal hEvent As HANDLE, ByRef pdwCookie As DWORD) As HRESULT
    UnregisterStereoStatus       As Sub(ByVal This As Any Ptr, ByVal dwCookie As DWORD)
    RegisterOcclusionStatusWindow As Function(ByVal This As Any Ptr, ByVal WindowHandle As HWND, ByVal wMsg As UINT, ByRef pdwCookie As DWORD) As HRESULT
    RegisterOcclusionStatusEvent As Function(ByVal This As Any Ptr, ByVal hEvent As HANDLE, ByRef pdwCookie As DWORD) As HRESULT
    UnregisterOcclusionStatus    As Sub(ByVal This As Any Ptr, ByVal dwCookie As DWORD)
    CreateSwapChainForComposition As Function(ByVal This As Any Ptr, ByVal pDevice As IUnknown Ptr, ByRef pDesc As DXGI_SWAP_CHAIN_DESC1, ByVal pRestrictToOutput As IDXGIOutput Ptr, ByVal ppSwapChain As IDXGISwapChain1 Ptr Ptr) As HRESULT
End Type

Type IDXGIFactory2_
    lpVtbl As IDXGIFactory2Vtbl Ptr
End Type

Dim Shared pD3D11DeviceContext As ID3D11DeviceContext Ptr

Const D3D10_SDK_VERSION = 29
Const D3D11_SDK_VERSION = 7

Type D3D11_CREATE_DEVICE_FLAG As Long
Enum
    D3D11_CREATE_DEVICE_SINGLETHREADED = &h1,
    D3D11_CREATE_DEVICE_DEBUG = &h2,
    D3D11_CREATE_DEVICE_SWITCH_TO_REF = &h4,
    D3D11_CREATE_DEVICE_PREVENT_INTERNAL_THREADING_OPTIMIZATIONS = &h8,
    D3D11_CREATE_DEVICE_BGRA_SUPPORT = &h20,
    D3D11_CREATE_DEVICE_DEBUGGABLE = &h40,
    D3D11_CREATE_DEVICE_PREVENT_ALTERING_LAYER_SETTINGS_FROM_REGISTRY = &h80,
    D3D11_CREATE_DEVICE_DISABLE_GPU_TIMEOUT = &h100,
    D3D11_CREATE_DEVICE_VIDEO_SUPPORT = &h800
End Enum

Type D3D11CreateDeviceType As Function _
( _
ByVal pAdapter As IDXGIAdapter Ptr, _                      ' IDXGIAdapter*
ByVal DriverType As D3D_DRIVER_TYPE, _                   ' D3D_DRIVER_TYPE
ByVal Software As HMODULE, _                      ' HMODULE (0)
ByVal Flags As UINT, _                        
ByVal pFeatureLevels As Const D3D_FEATURE_LEVEL Ptr, _  
ByVal FeatureLevels As UINT, _                
ByVal SDKVersion As UINT, _                   
ByVal ppDevice As ID3D11Device Ptr Ptr, _                  
ByVal pFeatureLevelOut As D3D_FEATURE_LEVEL Ptr, _
ByVal ppImmediateContext As ID3D11DeviceContext Ptr Ptr _         
) As HRESULT

Type DWriteCreateFactoryType As Function( _
ByVal factoryType As DWRITE_FACTORY_TYPE, _
ByVal IID As REFIID, _
ByVal factory As IDWriteFactory Ptr Ptr _
) As HRESULT

Dim Shared IID_IDWriteFactory As GUID = Type(&hB859EE5A, &hD838, &h4B5B, {&hA2, &hE8, &h1A, &hDC, &h7D, &h93, &hDB, &h48})

Type fnCreateTextFormat As Function( _
ByVal This As Any Ptr, _
ByVal fontName As Const WString Ptr, _
ByVal fontCollection As Any Ptr, _
ByVal fontWeight As Long, _
ByVal FontStyle As Long, _
ByVal fontStretch As Long, _
ByVal fontSize As Single, _
ByVal localeName As Const WString Ptr, _
ByVal ppTextFormat As Any Ptr Ptr _
) As HRESULT

Dim Shared CreateTextFormat As fnCreateTextFormat

Type fnCreateHwndRenderTarget As Function( _
ByVal This As Any Ptr, _
ByVal renderTargetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, _
ByVal hwndRenderTargetProps As D2D1_HWND_RENDER_TARGET_PROPERTIES Ptr, _
ByVal outRenderTarget As Any Ptr Ptr _
) As Long

Dim Shared CreateHwndRenderTarget As fnCreateHwndRenderTarget

Const DXGI_SWAP_CHAIN_FLAG_GDI_COMPATIBLE = &h00000010

' Globals
Dim Shared As Any Ptr hD2D1 = 0
Dim Shared As Any Ptr hD3D11 = 0
Dim Shared As Any Ptr hDWrite = 0
Dim Shared As ID2D1Device Ptr pD2D1Device = 0
Dim Shared As ID3D11Device Ptr pD3D11Device = 0
Dim Shared As IDXGIFactory2 Ptr pDXGIFactory2 = 0
Dim Shared As ID2D1Factory Ptr pD2D1Factory = 0
Dim Shared As ID2D1Factory1 Ptr pD2D1Factory1 = 0
Dim Shared As IDWriteFactory Ptr pDWriteFactory = 0
Dim Shared As IDXGIAdapter Ptr pDXGIAdapter = 0
Dim Shared As IDXGIDevice Ptr pDXGIDevice = 0
Dim Shared As Boolean g_Direct2DEnabled

Type D3D11_DEBUG_FEATURE As Long
Enum
    D3D11_DEBUG_FEATURE_FLUSH_PER_RENDER_OP = &h1
    D3D11_DEBUG_FEATURE_FINISH_PER_RENDER_OP = &h2
    D3D11_DEBUG_FEATURE_PRESENT_PER_RENDER_OP = &h4
    D3D11_DEBUG_FEATURE_ALWAYS_DISCARD = &h8
    D3D11_DEBUG_FEATURE_NEVER_DISCARD = &h10
    D3D11_DEBUG_FEATURE_AVOID_BEHAVIOR_CHANGING_DEBUG_AIDS = &h20
End Enum

Type ID3D11DebugVtbl
    ' IUnknown
    QueryInterface As Function(ByVal This As Any Ptr, ByRef riid As GUID, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As Any Ptr) As ULong
    Release As Function(ByVal This As Any Ptr) As ULong

    ' ID3D11Debug
    SetFeatureMask As Function(ByVal This As Any Ptr, ByVal Mask As D3D11_DEBUG_FEATURE) As HRESULT
    GetFeatureMask As Function(ByVal This As Any Ptr, ByVal pMask As ULong Ptr) As HRESULT
    SetPresentPerRenderOpDelay As Function(ByVal This As Any Ptr, ByVal Milliseconds As ULong) As HRESULT
    GetPresentPerRenderOpDelay As Function(ByVal This As Any Ptr, ByVal pMilliseconds As ULong Ptr) As HRESULT
    SetSwapChain As Function(ByVal This As Any Ptr, ByVal pSwapChain As Any Ptr) As HRESULT
    GetSwapChain As Function(ByVal This As Any Ptr, ByVal ppSwapChain As Any Ptr Ptr) As HRESULT
    ValidateContext As Function(ByVal This As Any Ptr, ByVal pContext As Any Ptr) As HRESULT
    ReportLiveDeviceObjects As Function(ByVal This As Any Ptr, ByVal Flags As ULong) As HRESULT
    ValidateContextForDispatch As Function(ByVal This As Any Ptr, ByVal pContext As Any Ptr) As HRESULT
End Type

Type ID3D11Debug
    lpVtbl As ID3D11DebugVtbl Ptr
End Type

Dim Shared IID_ID3D11Debug As GUID = ( _
    &h79CF2233, &h7536, &h4948, { &h9D, &h36, &h1E, &h46, &h92, &hDC, &h57, &h60 } )

Const D3D11_RLO_SUMMARY = 0
Const D3D11_RLO_DETAIL = 1

Dim Shared IID_ID2D1Debug1 As GUID = ( _
    &H429A1A06, &H0DDB, &H4C9C, {&H9A, &H3E, &H0C, &H0A, &H6B, &H56, &HA3, &HE0} )

Type ID2D1Debug1Vtbl
    ' IUnknown
    QueryInterface As Function(ByVal This As Any Ptr, ByVal riid As REFIID, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As Any Ptr) As ULong
    Release As Function(ByVal This As Any Ptr) As ULong

    ' ID2D1Debug
    EnableDebugLayer As Sub(ByVal This As Any Ptr)

    ' ID2D1Debug1
    ReportLiveObjects As Function(ByVal This As Any Ptr, ByVal level As D2D1_DEBUG_LEVEL) As HRESULT
End Type

Type ID2D1Debug1
    lpVtbl As ID2D1Debug1Vtbl Ptr
End Type

Function UnloadD2D1 As Long
	#ifdef __USE_WINAPI__
		Dim pDebug As ID3D11Debug Ptr
		Dim pDebugD2D1 As ID2D1Debug1 Ptr
		' Проверяем, что pD3D11Device существует
		If pDWriteFactory Then Cast(Sub(ByVal As Any Ptr), COM_METHOD(pDWriteFactory, 2))(pDWriteFactory): pDWriteFactory = 0
		If pDXGIAdapter <> 0 Then pDXGIAdapter->lpVtbl->Release(pDXGIAdapter): pDXGIAdapter = 0
		If pDXGIDevice <> 0 Then pDXGIDevice->lpVtbl->Release(pDXGIDevice): pDXGIDevice = 0
    	If pD3D11DeviceContext Then
			pD3D11DeviceContext->lpVtbl->OMSetRenderTargets(pD3D11DeviceContext, 0, 0, 0)
			pD3D11DeviceContext->lpVtbl->ClearState(pD3D11DeviceContext)
			pD3D11DeviceContext->lpVtbl->Flush(pD3D11DeviceContext)
			pD3D11DeviceContext->lpVtbl->Release(pD3D11DeviceContext)
			pD3D11DeviceContext = 0
		End If
		If pD3D11Device Then
			If SUCCEEDED(pD3D11Device->lpVtbl->QueryInterface(pD3D11Device, @IID_ID3D11Debug, @pDebug)) Then
		        
			End If
			pD3D11Device->lpVtbl->Release(pD3D11Device): pD3D11Device = 0
		End If
		If pD2D1Device Then pD2D1Device->lpVtbl->Release(pD2D1Device): pD2D1Device = 0
		If pD2D1Factory Then Cast(Sub(ByVal As Any Ptr), COM_METHOD(pD2D1Factory, 2))(pD2D1Factory): pD2D1Factory = 0
		If pD2D1Factory1 Then
			'Dim D2D1GetDebugInterface As D2D1GetDebugInterfaceType
			'D2D1GetDebugInterface = Cast(D2D1CreateFactoryType, DyLibSymbol(hD2D1, "D2D1GetDebugInterface"))
			'If D2D1GetDebugInterface <> 0 Then
			'	Var hr = D2D1GetDebugInterface(@IID_ID2D1Debug1, @pDebugD2D1)
			'	If hr = 0 Then
			'		pDebugD2D1->lpVtbl->ReportLiveObjects(pDebug, D2D1_DEBUG_LEVEL_INFORMATION)
			'		pDebugD2D1->lpVtbl->Release(pDebug)
			'	End If
			'End If
			pD2D1Factory1->lpVtbl->Release(pD2D1Factory1): pD2D1Factory1 = 0
		End If
		If pDXGIFactory2 Then pDXGIFactory2->lpVtbl->Release(pDXGIFactory2): pDXGIFactory2 = 0
		If hD2D1 Then DyLibFree(hD2D1): hD2D1 = 0
		If hD3D11 Then DyLibFree(hD3D11): hD3D11 = 0
		If hDWrite Then DyLibFree(hDWrite): hDWrite = 0
		If pDebug <> 0 Then
			' 0 = D3D11_RLO_SUMMARY (короткий отчёт)
	        ' 1 = D3D11_RLO_DETAIL  (подробный отчёт с именами)
	        OutputDebugString("===== D3D11 ReportLiveObjects START =====" & Chr(13,10))
	        pDebug->lpVtbl->ReportLiveDeviceObjects(pDebug, D3D11_RLO_DETAIL Or D3D11_RLO_SUMMARY)
	        OutputDebugString("===== D3D11 ReportLiveObjects END =====" & Chr(13,10))
	        pDebug->lpVtbl->Release(pDebug)
	    End If
		'CoUninitialize()
	#endif
	Return 0
End Function

Function LoadD2D1 As Long
	#ifdef __USE_WINAPI__
		'CoInitializeEx(0, 0)
		
		hD2D1 = DyLibLoad("d2d1.dll")
		If hD2D1 = 0 Then Return UnloadD2D1
		
		Dim CreateD2D1Factory As D2D1CreateFactoryType
		CreateD2D1Factory = Cast(D2D1CreateFactoryType, DyLibSymbol(hD2D1, "D2D1CreateFactory"))
		If CreateD2D1Factory = 0 Then Return UnloadD2D1
		
		Dim opts As D2D1_FACTORY_OPTIONS
		opts.debugLevel = D2D1_DEBUG_LEVEL_INFORMATION
		
		'Dim hr As Long = CreateD2D1Factory(D2D1_FACTORY_TYPE_SINGLE_THREADED, @IID_ID2D1Factory1, @opts, @pD2D1Factory1)
		Dim hr As Long = CreateD2D1Factory(D2D1_FACTORY_TYPE_SINGLE_THREADED, @IID_ID2D1Factory1, 0, @pD2D1Factory1)
		If hr <> 0 Then Return UnloadD2D1
		
		hDWrite = DyLibLoad("dwrite.dll")
		If hDWrite = 0 Then Return UnloadD2D1
		
		Dim CreateFactory As DWriteCreateFactoryType
		CreateFactory = Cast(DWriteCreateFactoryType, DyLibSymbol(hDWrite, "DWriteCreateFactory"))
		If CreateFactory = 0 Then Return UnloadD2D1
		
		hr = CreateFactory(DWRITE_FACTORY_TYPE_SHARED, @IID_IDWriteFactory, @pDWriteFactory)
		If hr <> 0 Then Return UnloadD2D1
		
		hD3D11 = DyLibLoad("d3d11.dll")
		If hD3D11 = 0 Then Return UnloadD2D1
		
		Dim D3D11CreateDevice As D3D11CreateDeviceType
		D3D11CreateDevice = Cast(D3D11CreateDeviceType, DyLibSymbol(hD3D11, "D3D11CreateDevice"))
		If D3D11CreateDevice = 0 Then Return UnloadD2D1
		
		Dim pDXGI As Any Ptr = 0
		' Or D3D11_CREATE_DEVICE_DEBUG
		hr = D3D11CreateDevice(0, D3D_DRIVER_TYPE_HARDWARE, 0, D3D11_CREATE_DEVICE_BGRA_SUPPORT, 0, 0, D3D11_SDK_VERSION, @pD3D11Device, 0, @pD3D11DeviceContext)
		
		If hr <> 0 Then Return UnloadD2D1
		
		hr = pD3D11Device->lpVtbl->QueryInterface(pD3D11Device, @IID_IDXGIDevice, @pDXGIDevice)
		If hr <> 0 Then Return UnloadD2D1
		
		'pDXGIDevice->lpVtbl->SetMaximumFrameLatency
		
		hr = pD2D1Factory1->lpVtbl->CreateDevice(pD2D1Factory1, pDXGIDevice, @pD2D1Device)
		If hr <> 0 Then Return UnloadD2D1
		
		pDXGIDevice->lpVtbl->GetAdapter(pDXGIDevice, @pDXGIAdapter)
		
		'Dim As DXGI_ADAPTER_DESC adapterDesc
		'pAdapter->lpVtbl->GetDesc(pAdapter,  @adapterDesc)
		'Print "GPU: "; adapterDesc.Description
		'Print "VendorId: "; Hex(adapterDesc.VendorId)
		
		hr = pDXGIAdapter->lpVtbl->GetParent(pDXGIAdapter, @IID_IDXGIFactory2, Cast(Any Ptr Ptr, @pDXGIFactory2))
		If hr <> 0 Then Return UnloadD2D1
		CreateHwndRenderTarget = Cast(fnCreateHwndRenderTarget, COM_METHOD(pD2D1Factory1, 14))
		CreateTextFormat = Cast(fnCreateTextFormat, COM_METHOD(pDWriteFactory, 15))
		CreateTextLayout = Cast(fnCreateTextLayout, COM_METHOD(pDWriteFactory, 18))
		
		g_Direct2DEnabled = True
	#endif
	Return 0
End Function
