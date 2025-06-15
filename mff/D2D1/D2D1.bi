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

Type IDWriteFactory
	lpVtbl As Any Ptr
End Type

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
ByVal pFactoryOptions As Any Ptr, _
ByVal ppIFactory As Any Ptr Ptr _
) As Long

Dim Shared IID_ID2D1Factory As GUID = Type(&h06152247, &h6f50, &h465a, {&h92, &h45, &h11, &h8b, &hfd, &h3b, &h60, &h07} )

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

' Globals
Dim Shared As Any Ptr hD2D1 = 0
Dim Shared As Any Ptr hDWrite = 0
Dim Shared As ID2D1Factory Ptr pD2D1Factory = 0
Dim Shared As IDWriteFactory Ptr pDWriteFactory = 0
Dim Shared As Boolean g_Direct2DEnabled
