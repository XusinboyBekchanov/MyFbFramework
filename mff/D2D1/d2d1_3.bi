' Based on the C header files Wine project:
' Copyright (C) the Wine project
' Ported to FB by UEZ
' Build 2026-01-04 beta

#pragma once

' ============================================================================
' Direct2D 1.3 API - FreeBASIC Translation
' ============================================================================

#include once "d2d1_2.bi"
#include once "d2d1effects_2.bi"

' ============================================================================
' Enumerations
' ============================================================================

Enum D2D1_INK_NIB_SHAPE
    D2D1_INK_NIB_SHAPE_ROUND = 0
    D2D1_INK_NIB_SHAPE_SQUARE = 1
End Enum

Enum D2D1_PATCH_EDGE_MODE
    D2D1_PATCH_EDGE_MODE_ALIASED = 0
    D2D1_PATCH_EDGE_MODE_ANTIALIASED = 1
    D2D1_PATCH_EDGE_MODE_ALIASED_INFLATED = 2
End Enum

Enum D2D1_ORIENTATION
    D2D1_ORIENTATION_DEFAULT = 1
    D2D1_ORIENTATION_FLIP_HORIZONTAL = 2
    D2D1_ORIENTATION_ROTATE_CLOCKWISE180 = 3
    D2D1_ORIENTATION_ROTATE_CLOCKWISE180_FLIP_HORIZONTAL = 4
    D2D1_ORIENTATION_ROTATE_CLOCKWISE90_FLIP_HORIZONTAL = 5
    D2D1_ORIENTATION_ROTATE_CLOCKWISE270 = 6
    D2D1_ORIENTATION_ROTATE_CLOCKWISE270_FLIP_HORIZONTAL = 7
    D2D1_ORIENTATION_ROTATE_CLOCKWISE90 = 8
End Enum

Enum D2D1_TRANSFORMED_IMAGE_SOURCE_OPTIONS
    D2D1_TRANSFORMED_IMAGE_SOURCE_OPTIONS_NONE = 0
    D2D1_TRANSFORMED_IMAGE_SOURCE_OPTIONS_DISABLE_DPI_SCALE = 1
End Enum

Enum D2D1_IMAGE_SOURCE_LOADING_OPTIONS
    D2D1_IMAGE_SOURCE_LOADING_OPTIONS_NONE = 0
    D2D1_IMAGE_SOURCE_LOADING_OPTIONS_RELEASE_SOURCE = 1
    D2D1_IMAGE_SOURCE_LOADING_OPTIONS_CACHE_ON_DEMAND = 2
End Enum

Enum D2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS
    D2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS_NONE = 0
    D2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS_LOW_QUALITY_PRIMARY_CONVERSION = 1
End Enum

Enum D2D1_SPRITE_OPTIONS
    D2D1_SPRITE_OPTIONS_NONE = 0
    D2D1_SPRITE_OPTIONS_CLAMP_TO_SOURCE_RECTANGLE = 1
End Enum

Enum D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION
    D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION_DEFAULT = 0
    D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION_DISABLE = 1
End Enum

Enum D2D1_GAMMA1
    D2D1_GAMMA1_G22 = 0  ' D2D1_GAMMA_2_2
    D2D1_GAMMA1_G10 = 1  ' D2D1_GAMMA_1_0
    D2D1_GAMMA1_G2084 = 2
End Enum

Enum D2D1_COLOR_CONTEXT_TYPE
    D2D1_COLOR_CONTEXT_TYPE_ICC = 0
    D2D1_COLOR_CONTEXT_TYPE_SIMPLE = 1
    D2D1_COLOR_CONTEXT_TYPE_DXGI = 2
End Enum

'Enum DWRITE_PAINT_FEATURE_LEVEL
'    DWRITE_PAINT_FEATURE_LEVEL_NONE = 0
'    DWRITE_PAINT_FEATURE_LEVEL_COLR_V0 = 1
'    DWRITE_PAINT_FEATURE_LEVEL_COLR_V1 = 2
'End Enum

' ============================================================================
' Structures
' ============================================================================

Type D2D1_INK_POINT
    x As Single
    y As Single
    radius As Single
End Type

Type D2D1_INK_BEZIER_SEGMENT
    point1 As D2D1_INK_POINT
    point2 As D2D1_INK_POINT
    point3 As D2D1_INK_POINT
End Type

Type D2D1_INK_STYLE_PROPERTIES
    nibShape As D2D1_INK_NIB_SHAPE
    nibTransform As D2D1_MATRIX_3X2_F
End Type

Type D2D1_GRADIENT_MESH_PATCH
    point00 As D2D1_POINT_2F
    point01 As D2D1_POINT_2F
    point02 As D2D1_POINT_2F
    point03 As D2D1_POINT_2F
    point10 As D2D1_POINT_2F
    point11 As D2D1_POINT_2F
    point12 As D2D1_POINT_2F
    point13 As D2D1_POINT_2F
    point20 As D2D1_POINT_2F
    point21 As D2D1_POINT_2F
    point22 As D2D1_POINT_2F
    point23 As D2D1_POINT_2F
    point30 As D2D1_POINT_2F
    point31 As D2D1_POINT_2F
    point32 As D2D1_POINT_2F
    point33 As D2D1_POINT_2F
    color00 As D2D1_COLOR_F
    color03 As D2D1_COLOR_F
    color30 As D2D1_COLOR_F
    color33 As D2D1_COLOR_F
    topEdgeMode As D2D1_PATCH_EDGE_MODE
    leftEdgeMode As D2D1_PATCH_EDGE_MODE
    bottomEdgeMode As D2D1_PATCH_EDGE_MODE
    rightEdgeMode As D2D1_PATCH_EDGE_MODE
End Type

Type D2D1_TRANSFORMED_IMAGE_SOURCE_PROPERTIES
    orientation As D2D1_ORIENTATION
    scaleX As Single
    scaleY As Single
    interpolationMode As D2D1_INTERPOLATION_MODE
    options As D2D1_TRANSFORMED_IMAGE_SOURCE_OPTIONS
End Type

Type D2D1_SIMPLE_COLOR_PROFILE
    redPrimary As D2D1_POINT_2F
    greenPrimary As D2D1_POINT_2F
    bluePrimary As D2D1_POINT_2F
    whitePointXZ As D2D1_POINT_2F
    gamma As D2D1_GAMMA1
End Type

' ============================================================================
' IID Definitions
' ============================================================================

Dim Shared IID_ID2D1InkStyle As GUID = Type(&hbae8b344, &h23fc, &h4071, {&h8c, &hb5, &hd0, &h5d, &h6f, &h07, &h38, &h48})
Dim Shared IID_ID2D1Ink As GUID = Type(&hb499923b, &h7029, &h478f, {&ha8, &hb3, &h43, &h2c, &h7c, &h5f, &h53, &h12})
Dim Shared IID_ID2D1GradientMesh As GUID = Type(&hf292e401, &hc050, &h4cde, {&h83, &hd7, &h04, &h96, &h2d, &h3b, &h23, &hc2})
Dim Shared IID_ID2D1ImageSource As GUID = Type(&hc9b664e5, &h74a1, &h4378, {&h9a, &hc2, &hee, &hfc, &h37, &ha3, &hf4, &hd8})
Dim Shared IID_ID2D1ImageSourceFromWic As GUID = Type(&h77395441, &h1c8f, &h4555, {&h86, &h83, &hf5, &h0d, &hab, &h0f, &he7, &h92})
Dim Shared IID_ID2D1TransformedImageSource As GUID = Type(&h7f1f79e5, &h2796, &h416c, {&h8f, &h55, &h70, &h0f, &h91, &h14, &h45, &he5})
Dim Shared IID_ID2D1LookupTable3D As GUID = Type(&h53dd9855, &ha3b0, &h4d5b, {&h82, &he1, &h26, &he2, &h5c, &h5e, &h57, &h97})
Dim Shared IID_ID2D1SpriteBatch As GUID = Type(&h4dc583bf, &h3a10, &h438a, {&h87, &h22, &he9, &h76, &h52, &h24, &hf1, &hf1})
Dim Shared IID_ID2D1SvgGlyphStyle As GUID = Type(&haf671749, &hd241, &h4db8, {&h8e, &h41, &hdc, &hc2, &he5, &hc1, &ha4, &h38})
Dim Shared IID_ID2D1DeviceContext2 As GUID = Type(&h394ea6a3, &h0c34, &h4321, {&h95, &h0b, &h6c, &ha2, &h0f, &h0b, &he6, &hc7})
Dim Shared IID_ID2D1DeviceContext3 As GUID = Type(&h235a7496, &h8351, &h414c, {&hbc, &hd4, &h66, &h72, &hab, &h2d, &h8e, &h00})
Dim Shared IID_ID2D1DeviceContext4 As GUID = Type(&h8c427831, &h3d90, &h4476, {&hb6, &h47, &hc4, &hfa, &he3, &h49, &he4, &hdb})
Dim Shared IID_ID2D1DeviceContext5 As GUID = Type(&h7836d248, &h68cc, &h4df6, {&hb9, &he8, &hde, &h99, &h1b, &hf6, &h2e, &hb7})
Dim Shared IID_ID2D1DeviceContext6 As GUID = Type(&h985f7e37, &h4ed0, &h4a19, {&h98, &ha3, &h15, &hb0, &hed, &hfd, &he3, &h06})
Dim Shared IID_ID2D1DeviceContext7 As GUID = Type(&hec891cf7, &h9b69, &h4851, {&h9d, &hef, &h4e, &h09, &h15, &h77, &h1e, &h62})
Dim Shared IID_ID2D1ColorContext1 As GUID = Type(&h1ab42875, &hc57f, &h4be9, {&hbd, &h85, &h9c, &hd7, &h8d, &h6f, &h55, &hee})
Dim Shared IID_ID2D1Device2 As GUID = Type(&ha44472e1, &h8dfb, &h4e60, {&h84, &h92, &h6e, &h28, &h61, &hc9, &hca, &h8b})
Dim Shared IID_ID2D1Device3 As GUID = Type(&h852f2087, &h802c, &h4037, {&hab, &h60, &hff, &h2e, &h7e, &he6, &hfc, &h01})
Dim Shared IID_ID2D1Device4 As GUID = Type(&hd7bdb159, &h5683, &h4a46, {&hbc, &h9c, &h72, &hdc, &h72, &h0b, &h85, &h8b})
Dim Shared IID_ID2D1Device5 As GUID = Type(&hd55ba0a4, &h6405, &h4694, {&hae, &hf5, &h08, &hee, &h1a, &h43, &h58, &hb4})
Dim Shared IID_ID2D1Device6 As GUID = Type(&h7bfef914, &h2d75, &h4bad, {&hbe, &h87, &he1, &h8d, &hdb, &h07, &h7b, &h6d})
Dim Shared IID_ID2D1Device7 As GUID = Type(&hf07c8968, &hdd4e, &h4ba6, {&h9c, &hbd, &heb, &h6d, &h37, &h52, &hdc, &hbb})
Dim Shared IID_ID2D1Factory3 As GUID = Type(&h0869759f, &h4f00, &h413f, {&hb0, &h3e, &h2b, &hda, &h45, &h40, &h4d, &h0f})
Dim Shared IID_ID2D1Factory4 As GUID = Type(&hbd4ec2d2, &h0662, &h4bee, {&hba, &h8e, &h6f, &h29, &hf0, &h32, &he0, &h96})
Dim Shared IID_ID2D1Factory5 As GUID = Type(&hc4349994, &h838e, &h4b0f, {&h8c, &hab, &h44, &h99, &h7d, &h9e, &hea, &hcc})
Dim Shared IID_ID2D1Factory6 As GUID = Type(&hf9976f46, &hf642, &h44c1, {&h97, &hca, &hda, &h32, &hea, &h2a, &h26, &h35})
Dim Shared IID_ID2D1Factory7 As GUID = Type(&hbdc2bdd3, &hb96c, &h4de6, {&hbd, &hf7, &h99, &hd4, &h74, &h54, &h54, &hde})
Dim Shared IID_ID2D1Factory8 As GUID = Type(&h677c9311, &hf36d, &h4b1f, {&hae, &h86, &h86, &hd1, &h22, &h3f, &hfd, &h3a})

' ============================================================================
' Interfaces
' ============================================================================

' Forward declarations
Type ID2D1SvgDocument As Any

' ============================================================================
' ID2D1InkStyle
' ============================================================================
Type ID2D1InkStyle Extends ID2D1Resource
    ' 1-3: IUnknown
    ' 4: GetFactory (ID2D1Resource)
    
    ' 5. SetNibTransform
    Declare Abstract Sub SetNibTransform Stdcall ( _
        ByVal transform As D2D1_MATRIX_3X2_F Ptr _
    )
    
    ' 6. GetNibTransform
    Declare Abstract Sub GetNibTransform Stdcall ( _
        ByVal transform As D2D1_MATRIX_3X2_F Ptr _
    )
    
    ' 7. SetNibShape
    Declare Abstract Sub SetNibShape Stdcall ( _
        ByVal shape As D2D1_INK_NIB_SHAPE _
    )
    
    ' 8. GetNibShape
    Declare Abstract Function GetNibShape Stdcall () As D2D1_INK_NIB_SHAPE
End Type

' ============================================================================
' ID2D1Ink
' ============================================================================
Type ID2D1Ink Extends ID2D1Resource
    ' 1-3: IUnknown
    ' 4: GetFactory (ID2D1Resource)
    
    ' 5. SetStartPoint
    Declare Abstract Sub SetStartPoint Stdcall ( _
        ByVal start_point As D2D1_INK_POINT Ptr _
    )
    
    ' 6. GetStartPoint
    Declare Abstract Function GetStartPoint Stdcall () As D2D1_INK_POINT
    
    ' 7. AddSegments
    Declare Abstract Function AddSegments Stdcall ( _
        ByVal segments As D2D1_INK_BEZIER_SEGMENT Ptr, _
        ByVal segment_count As ULong _
    ) As HRESULT
    
    ' 8. RemoveSegmentsAtEnd
    Declare Abstract Function RemoveSegmentsAtEnd Stdcall ( _
        ByVal segment_count As ULong _
    ) As HRESULT
    
    ' 9. SetSegments
    Declare Abstract Function SetSegments Stdcall ( _
        ByVal start_segment As ULong, _
        ByVal segments As D2D1_INK_BEZIER_SEGMENT Ptr, _
        ByVal segment_count As ULong _
    ) As HRESULT
    
    ' 10. SetSegmentAtEnd
    Declare Abstract Function SetSegmentAtEnd Stdcall ( _
        ByVal segment As D2D1_INK_BEZIER_SEGMENT Ptr _
    ) As HRESULT
    
    ' 11. GetSegmentCount
    Declare Abstract Function GetSegmentCount Stdcall () As ULong
    
    ' 12. GetSegments
    Declare Abstract Function GetSegments Stdcall ( _
        ByVal start_segment As ULong, _
        ByVal segments As D2D1_INK_BEZIER_SEGMENT Ptr, _
        ByVal segment_count As ULong _
    ) As HRESULT
    
    ' 13. StreamAsGeometry
    Declare Abstract Function StreamAsGeometry Stdcall ( _
        ByVal ink_style As ID2D1InkStyle Ptr, _
        ByVal world_transform As D2D1_MATRIX_3X2_F Ptr, _
        ByVal flattening_tolerance As Single, _
        ByVal geometry_sink As Any Ptr _
    ) As HRESULT
    
    ' 14. GetBounds
    Declare Abstract Function GetBounds Stdcall ( _
        ByVal ink_style As ID2D1InkStyle Ptr, _
        ByVal world_transform As D2D1_MATRIX_3X2_F Ptr, _
        ByVal bounds As D2D1_RECT_F Ptr _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1GradientMesh
' ============================================================================
Type ID2D1GradientMesh Extends ID2D1Resource
    ' 1-3: IUnknown
    ' 4: GetFactory (ID2D1Resource)
    
    ' 5. GetPatchCount
    Declare Abstract Function GetPatchCount Stdcall () As ULong
    
    ' 6. GetPatches
    Declare Abstract Function GetPatches Stdcall ( _
        ByVal start_index As ULong, _
        ByVal patches As D2D1_GRADIENT_MESH_PATCH Ptr, _
        ByVal patch_count As ULong _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1ImageSource
' ============================================================================
Type ID2D1ImageSource Extends ID2D1Image
    ' 1-3: IUnknown
    ' 4-5: ID2D1Resource
    ' 6: GetFactory (ID2D1Image)
    
    ' 7. OfferResources
    Declare Abstract Function OfferResources Stdcall () As HRESULT
    
    ' 8. TryReclaimResources
    Declare Abstract Function TryReclaimResources Stdcall ( _
        ByVal resources_discarded As Long Ptr _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1ImageSourceFromWic
' ============================================================================
Type ID2D1ImageSourceFromWic Extends ID2D1ImageSource
    ' 1-3: IUnknown
    ' 4-8: ID2D1ImageSource
    
    ' 9. EnsureCached
    Declare Abstract Function EnsureCached Stdcall ( _
        ByVal rect_to_fill As D2D1_RECT_U Ptr _
    ) As HRESULT
    
    ' 10. TrimCache
    Declare Abstract Function TrimCache Stdcall ( _
        ByVal rect_to_preserve As D2D1_RECT_U Ptr _
    ) As HRESULT
    
    ' 11. GetSource
    Declare Abstract Sub GetSource Stdcall ( _
        ByVal source As Any Ptr Ptr _
    )
End Type

' ============================================================================
' ID2D1TransformedImageSource
' ============================================================================
Type ID2D1TransformedImageSource Extends ID2D1Image
    ' 1-3: IUnknown
    ' 4-5: ID2D1Resource
    ' 6: GetFactory (ID2D1Image)
    
    ' 7. GetSource
    Declare Abstract Sub GetSource Stdcall ( _
        ByVal source As Any Ptr Ptr _
    )
    
    ' 8. GetProperties
    Declare Abstract Sub GetProperties Stdcall ( _
        ByVal out As D2D1_TRANSFORMED_IMAGE_SOURCE_PROPERTIES Ptr _
    )
End Type

' ============================================================================
' ID2D1LookupTable3D
' ============================================================================
Type ID2D1LookupTable3D Extends ID2D1Resource
    ' 1-3: IUnknown
    ' 4: GetFactory (ID2D1Resource)
    ' Keine zusätzlichen Methoden
End Type

' ============================================================================
' ID2D1SpriteBatch
' ============================================================================
Type ID2D1SpriteBatch Extends ID2D1Resource
    ' 1-3: IUnknown
    ' 4: GetFactory (ID2D1Resource)
    
    ' 5. AddSprites
    Declare Abstract Function AddSprites Stdcall ( _
        ByVal sprite_count As ULong, _
        ByVal destination_rectangles As D2D1_RECT_F Ptr, _
        ByVal source_rectangles As D2D1_RECT_U Ptr, _
        ByVal colors As D2D1_COLOR_F Ptr, _
        ByVal transforms As D2D1_MATRIX_3X2_F Ptr, _
        ByVal destination_rectangles_stride As ULong, _
        ByVal source_rectangles_stride As ULong, _
        ByVal colors_stride As ULong, _
        ByVal transforms_stride As ULong _
    ) As HRESULT
    
    ' 6. SetSprites
    Declare Abstract Function SetSprites Stdcall ( _
        ByVal start_index As ULong, _
        ByVal sprite_count As ULong, _
        ByVal destination_rectangles As D2D1_RECT_F Ptr, _
        ByVal source_rectangles As D2D1_RECT_U Ptr, _
        ByVal colors As D2D1_COLOR_F Ptr, _
        ByVal transforms As D2D1_MATRIX_3X2_F Ptr, _
        ByVal destination_rectangles_stride As ULong, _
        ByVal source_rectangles_stride As ULong, _
        ByVal colors_stride As ULong, _
        ByVal transforms_stride As ULong _
    ) As HRESULT
    
    ' 7. GetSprites
    Declare Abstract Function GetSprites Stdcall ( _
        ByVal start_index As ULong, _
        ByVal sprite_count As ULong, _
        ByVal destination_rectangles As D2D1_RECT_F Ptr, _
        ByVal source_rectangles As D2D1_RECT_U Ptr, _
        ByVal colors As D2D1_COLOR_F Ptr, _
        ByVal transforms As D2D1_MATRIX_3X2_F Ptr _
    ) As HRESULT
    
    ' 8. GetSpriteCount
    Declare Abstract Function GetSpriteCount Stdcall () As ULong
    
    ' 9. Clear
    Declare Abstract Sub Clear Stdcall ()
End Type

' ============================================================================
' ID2D1SvgGlyphStyle
' ============================================================================
Type ID2D1SvgGlyphStyle Extends ID2D1Resource
    ' 1-3: IUnknown
    ' 4: GetFactory (ID2D1Resource)
    
    ' 5. SetFill
    Declare Abstract Function SetFill Stdcall ( _
        ByVal brush As ID2D1Brush Ptr _
    ) As HRESULT
    
    ' 6. GetFill
    Declare Abstract Sub GetFill Stdcall ( _
        ByVal brush As Any Ptr Ptr _
    )
    
    ' 7. SetStroke
    Declare Abstract Function SetStroke Stdcall ( _
        ByVal brush As ID2D1Brush Ptr, _
        ByVal stroke_width As Single, _
        ByVal dashes As Single Ptr, _
        ByVal dashes_count As ULong, _
        ByVal dash_offset As Single _
    ) As HRESULT
    
    ' 8. GetStrokeDashesCount
    Declare Abstract Function GetStrokeDashesCount Stdcall () As ULong
    
    ' 9. GetStroke
    Declare Abstract Sub GetStroke Stdcall ( _
        ByVal brush As Any Ptr Ptr, _
        ByVal stroke_width As Single Ptr, _
        ByVal dashes As Single Ptr, _
        ByVal dashes_count As ULong, _
        ByVal dash_offset As Single Ptr _
    )
End Type

' ============================================================================
' ID2D1ColorContext1
' ============================================================================
Type ID2D1ColorContext1 Extends ID2D1ColorContext
    ' Erbt von ID2D1ColorContext
    
    ' Zusätzliche Methoden
    Declare Abstract Function GetColorContextType Stdcall () As D2D1_COLOR_CONTEXT_TYPE
    Declare Abstract Function GetDXGIColorSpace Stdcall () As ULong ' DXGI_COLOR_SPACE_TYPE
    Declare Abstract Function GetSimpleColorProfile Stdcall ( _
        ByVal simple_profile As D2D1_SIMPLE_COLOR_PROFILE Ptr _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1DeviceContext2
' ============================================================================
Type ID2D1DeviceContext2 Extends ID2D1DeviceContext1
    ' Erbt alle Methoden von ID2D1DeviceContext1
    
    ' Neue Methoden
    Declare Abstract Function CreateInk Stdcall ( _
        ByVal start_point As D2D1_INK_POINT Ptr, _
        ByVal ink As Any Ptr Ptr _
    ) As HRESULT
    
    Declare Abstract Function CreateInkStyle Stdcall ( _
        ByVal ink_style_properties As D2D1_INK_STYLE_PROPERTIES Ptr, _
        ByVal ink_style As Any Ptr Ptr _
    ) As HRESULT
    
    Declare Abstract Function CreateGradientMesh Stdcall ( _
        ByVal patches As D2D1_GRADIENT_MESH_PATCH Ptr, _
        ByVal patches_count As ULong, _
        ByVal gradient_mesh As Any Ptr Ptr _
    ) As HRESULT
    
    Declare Abstract Function CreateImageSourceFromWic Stdcall ( _
        ByVal wic_bitmap_source As Any Ptr, _
        ByVal loading_options As D2D1_IMAGE_SOURCE_LOADING_OPTIONS, _
        ByVal alpha_mode As D2D1_ALPHA_MODE, _
        ByVal image_source As Any Ptr Ptr _
    ) As HRESULT
    
    Declare Abstract Function CreateLookupTable3D Stdcall ( _
        ByVal precision As ULong, _
        ByVal extents As ULong Ptr, _
        ByVal data As UByte Ptr, _
        ByVal data_count As ULong, _
        ByVal strides As ULong Ptr, _
        ByVal lookup_table As Any Ptr Ptr _
    ) As HRESULT
    
    Declare Abstract Function CreateImageSourceFromDxgi Stdcall ( _
        ByVal surfaces As Any Ptr Ptr, _
        ByVal surface_count As ULong, _
        ByVal color_space As ULong, _
        ByVal options As D2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS, _
        ByVal image_source As Any Ptr Ptr _
    ) As HRESULT
    
    Declare Abstract Function GetGradientMeshWorldBounds Stdcall ( _
        ByVal gradient_mesh As ID2D1GradientMesh Ptr, _
        ByVal bounds As D2D1_RECT_F Ptr _
    ) As HRESULT
    
    Declare Abstract Sub DrawInk Stdcall ( _
        ByVal ink As ID2D1Ink Ptr, _
        ByVal brush As ID2D1Brush Ptr, _
        ByVal ink_style As ID2D1InkStyle Ptr _
    )
    
    Declare Abstract Sub DrawGradientMesh Stdcall ( _
        ByVal gradient_mesh As ID2D1GradientMesh Ptr _
    )
    
    Declare Abstract Sub DrawGdiMetafile Stdcall ( _
        ByVal gdi_metafile As Any Ptr, _
        ByVal dst_rect As D2D1_RECT_F Ptr, _
        ByVal src_rect As D2D1_RECT_F Ptr _
    )
    
    Declare Abstract Function CreateTransformedImageSource Stdcall ( _
        ByVal source As ID2D1ImageSource Ptr, _
        ByVal props As D2D1_TRANSFORMED_IMAGE_SOURCE_PROPERTIES Ptr, _
        ByVal transformed As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1DeviceContext3
' ============================================================================
Type ID2D1DeviceContext3 Extends ID2D1DeviceContext2
    ' Erbt von ID2D1DeviceContext2
    
    Declare Abstract Function CreateSpriteBatch Stdcall ( _
        ByVal sprite_batch As Any Ptr Ptr _
    ) As HRESULT
    
    Declare Abstract Sub DrawSpriteBatch Stdcall ( _
        ByVal sprite_batch As ID2D1SpriteBatch Ptr, _
        ByVal start_index As ULong, _
        ByVal sprite_count As ULong, _
        ByVal bitmap As ID2D1Bitmap Ptr, _
        ByVal interpolation_mode As D2D1_BITMAP_INTERPOLATION_MODE, _
        ByVal sprite_options As D2D1_SPRITE_OPTIONS _
    )
End Type

' ============================================================================
' ID2D1DeviceContext4
' ============================================================================
Type ID2D1DeviceContext4 Extends ID2D1DeviceContext3
    ' Erbt von ID2D1DeviceContext3
    
    Declare Abstract Function CreateSvgGlyphStyle Stdcall ( _
        ByVal svg_glyph_style As Any Ptr Ptr _
    ) As HRESULT
    
    ' DrawText - Überladen mit zusätzlichen Parametern
    Declare Abstract Sub DrawText Stdcall ( _
        ByVal string As WString Ptr, _
        ByVal string_length As ULong, _
        ByVal text_format As Any Ptr, _
        ByVal layout_rect As D2D1_RECT_F Ptr, _
        ByVal default_fill_brush As ID2D1Brush Ptr, _
        ByVal svg_glyph_style As ID2D1SvgGlyphStyle Ptr, _
        ByVal color_palette_index As ULong, _
        ByVal options As D2D1_DRAW_TEXT_OPTIONS, _
        ByVal measuring_mode As ULong _
    )
    
    Declare Abstract Sub DrawTextLayout Stdcall ( _
        ByVal origin As D2D1_POINT_2F, _
        ByVal text_layout As Any Ptr, _
        ByVal default_fill_brush As ID2D1Brush Ptr, _
        ByVal svg_glyph_style As ID2D1SvgGlyphStyle Ptr, _
        ByVal color_palette_index As ULong, _
        ByVal options As D2D1_DRAW_TEXT_OPTIONS _
    )
    
    Declare Abstract Sub DrawColorBitmapGlyphRun Stdcall ( _
        ByVal glyph_image_format As ULong, _
        ByVal baseline_origin As D2D1_POINT_2F, _
        ByVal glyph_run As Any Ptr, _
        ByVal measuring_mode As ULong, _
        ByVal bitmap_snap_option As D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION _
    )
    
    Declare Abstract Sub DrawSvgGlyphRun Stdcall ( _
        ByVal baseline_origin As D2D1_POINT_2F, _
        ByVal glyph_run As Any Ptr, _
        ByVal default_fill_brush As ID2D1Brush Ptr, _
        ByVal svg_glyph_style As ID2D1SvgGlyphStyle Ptr, _
        ByVal color_palette_index As ULong, _
        ByVal measuring_mode As ULong _
    )
    
    Declare Abstract Function GetColorBitmapGlyphImage Stdcall ( _
        ByVal glyph_image_format As ULong, _
        ByVal glyph_origin As D2D1_POINT_2F, _
        ByVal font_face As Any Ptr, _
        ByVal font_em_size As Single, _
        ByVal glyph_index As UShort, _
        ByVal is_sideways As Long, _
        ByVal world_transform As D2D1_MATRIX_3X2_F Ptr, _
        ByVal dpi_x As Single, _
        ByVal dpi_y As Single, _
        ByVal glyph_transform As D2D1_MATRIX_3X2_F Ptr, _
        ByVal glyph_image As Any Ptr Ptr _
    ) As HRESULT
    
    Declare Abstract Function GetSvgGlyphImage Stdcall ( _
        ByVal glyph_origin As D2D1_POINT_2F, _
        ByVal font_face As Any Ptr, _
        ByVal font_em_size As Single, _
        ByVal glyph_index As UShort, _
        ByVal is_sideways As Long, _
        ByVal world_transform As D2D1_MATRIX_3X2_F Ptr, _
        ByVal default_fill_brush As ID2D1Brush Ptr, _
        ByVal svg_glyph_style As ID2D1SvgGlyphStyle Ptr, _
        ByVal color_palette_index As ULong, _
        ByVal glyph_transform As D2D1_MATRIX_3X2_F Ptr, _
        ByVal glyph_image As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1DeviceContext5
' ============================================================================
Type ID2D1DeviceContext5 Extends ID2D1DeviceContext4
    ' Erbt von ID2D1DeviceContext4
    
    Declare Abstract Function CreateSvgDocument Stdcall ( _
        ByVal input_xml_stream As Any Ptr, _
        ByVal viewport_size As D2D1_SIZE_F, _
        ByVal svg_document As Any Ptr Ptr _
    ) As HRESULT
    
    Declare Abstract Sub DrawSvgDocument Stdcall ( _
        ByVal svg_document As Any Ptr _
    )
    
    Declare Abstract Function CreateColorContextFromDxgiColorSpace Stdcall ( _
        ByVal color_space As ULong, _
        ByVal color_context As Any Ptr Ptr _
    ) As HRESULT
    
    Declare Abstract Function CreateColorContextFromSimpleColorProfile Stdcall ( _
        ByVal simple_profile As D2D1_SIMPLE_COLOR_PROFILE Ptr, _
        ByVal color_context As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1DeviceContext6
' ============================================================================
Type ID2D1DeviceContext6 Extends ID2D1DeviceContext5
    ' Erbt von ID2D1DeviceContext5
    
    Declare Abstract Sub BlendImage Stdcall ( _
        ByVal image As ID2D1Image Ptr, _
        ByVal blend_mode As D2D1_BLEND_MODE, _
        ByVal target_offset As D2D1_POINT_2F Ptr, _
        ByVal image_rect As D2D1_RECT_F Ptr, _
        ByVal interpolation_mode As D2D1_INTERPOLATION_MODE _
    )
End Type

' ============================================================================
' ID2D1DeviceContext7
' ============================================================================
Type ID2D1DeviceContext7 Extends ID2D1DeviceContext6
    ' Erbt von ID2D1DeviceContext6
    
    Declare Abstract Function GetPaintFeatureLevel Stdcall () As DWRITE_PAINT_FEATURE_LEVEL
    
    Declare Abstract Sub DrawPaintGlyphRun Stdcall ( _
        ByVal origin As D2D1_POINT_2F, _
        ByVal run As Any Ptr, _
        ByVal brush As ID2D1Brush Ptr, _
        ByVal palette_index As ULong, _
        ByVal measuring_mode As ULong _
    )
    
    Declare Abstract Sub DrawGlyphRunWithColorSupport Stdcall ( _
        ByVal origin As D2D1_POINT_2F, _
        ByVal run As Any Ptr, _
        ByVal run_desc As Any Ptr, _
        ByVal brush As ID2D1Brush Ptr, _
        ByVal style As ID2D1SvgGlyphStyle Ptr, _
        ByVal palette_index As ULong, _
        ByVal measuring_mode As ULong, _
        ByVal snap_option As D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION _
    )
End Type

' ============================================================================
' Device Interfaces
' ============================================================================

Type ID2D1Device2 Extends ID2D1Device1
    Declare Abstract Function CreateDeviceContext Stdcall ( _
        ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, _
        ByVal context As Any Ptr Ptr _
    ) As HRESULT
    
    Declare Abstract Sub FlushDeviceContexts Stdcall ( _
        ByVal bitmap As ID2D1Bitmap Ptr _
    )
    
    Declare Abstract Function GetDxgiDevice Stdcall ( _
        ByVal dxgi_device As Any Ptr Ptr _
    ) As HRESULT
End Type

Type ID2D1Device3 Extends ID2D1Device2
    Declare Abstract Function CreateDeviceContext Stdcall ( _
        ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, _
        ByVal context As Any Ptr Ptr _
    ) As HRESULT
End Type

Type ID2D1Device4 Extends ID2D1Device3
    Declare Abstract Function CreateDeviceContext Stdcall ( _
        ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, _
        ByVal context As Any Ptr Ptr _
    ) As HRESULT
    
    Declare Abstract Sub SetMaximumColorGlyphCacheMemory Stdcall ( _
        ByVal size As ULongInt _
    )
    
    Declare Abstract Function GetMaximumColorGlyphCacheMemory Stdcall () As ULongInt
End Type

Type ID2D1Device5 Extends ID2D1Device4
    Declare Abstract Function CreateDeviceContext Stdcall ( _
        ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, _
        ByVal context As Any Ptr Ptr _
    ) As HRESULT
End Type

Type ID2D1Device6 Extends ID2D1Device5
    Declare Abstract Function CreateDeviceContext Stdcall ( _
        ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, _
        ByVal context As Any Ptr Ptr _
    ) As HRESULT
End Type

Type ID2D1Device7 Extends ID2D1Device6
    Declare Abstract Function CreateDeviceContext Stdcall ( _
        ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, _
        ByVal context As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' Factory Interfaces
' ============================================================================

Type ID2D1Factory3 Extends ID2D1Factory2
    Declare Abstract Function CreateDevice Stdcall ( _
        ByVal dxgi_device As Any Ptr, _
        ByVal d2d_device As Any Ptr Ptr _
    ) As HRESULT
End Type

Type ID2D1Factory4 Extends ID2D1Factory3
    Declare Abstract Function CreateDevice Stdcall ( _
        ByVal dxgi_device As Any Ptr, _
        ByVal d2d_device As Any Ptr Ptr _
    ) As HRESULT
End Type

Type ID2D1Factory5 Extends ID2D1Factory4
    Declare Abstract Function CreateDevice Stdcall ( _
        ByVal dxgi_device As Any Ptr, _
        ByVal d2d_device As Any Ptr Ptr _
    ) As HRESULT
End Type

Type ID2D1Factory6 Extends ID2D1Factory5
    Declare Abstract Function CreateDevice Stdcall ( _
        ByVal dxgi_device As Any Ptr, _
        ByVal d2d_device As Any Ptr Ptr _
    ) As HRESULT
End Type

Type ID2D1Factory7 Extends ID2D1Factory6
    Declare Abstract Function CreateDevice Stdcall ( _
        ByVal dxgi_device As Any Ptr, _
        ByVal d2d_device As Any Ptr Ptr _
    ) As HRESULT
End Type

Type ID2D1Factory8 Extends ID2D1Factory7
    Declare Abstract Function CreateDevice Stdcall ( _
        ByVal dxgi_device As Any Ptr, _
        ByVal d2d_device As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' Command Sink Interfaces
' ============================================================================

Type ID2D1CommandSink2 Extends ID2D1CommandSink1
    Declare Abstract Function DrawInk Stdcall ( _
        ByVal ink As ID2D1Ink Ptr, _
        ByVal brush As ID2D1Brush Ptr, _
        ByVal ink_style As ID2D1InkStyle Ptr _
    ) As HRESULT
    
    Declare Abstract Function DrawGradientMesh Stdcall ( _
        ByVal gradient_mesh As ID2D1GradientMesh Ptr _
    ) As HRESULT
    
    Declare Abstract Function DrawGdiMetafile Stdcall ( _
        ByVal gdi_metafile As Any Ptr, _
        ByVal dest_rect As D2D1_RECT_F Ptr, _
        ByVal src_rect As D2D1_RECT_F Ptr _
    ) As HRESULT
End Type

Type ID2D1CommandSink3 Extends ID2D1CommandSink2
    Declare Abstract Function DrawSpriteBatch Stdcall ( _
        ByVal sprite_batch As ID2D1SpriteBatch Ptr, _
        ByVal start_index As ULong, _
        ByVal sprite_count As ULong, _
        ByVal bitmap As ID2D1Bitmap Ptr, _
        ByVal interpolation_mode As D2D1_BITMAP_INTERPOLATION_MODE, _
        ByVal sprite_options As D2D1_SPRITE_OPTIONS _
    ) As HRESULT
End Type

Type ID2D1CommandSink4 Extends ID2D1CommandSink3
    Declare Abstract Function SetPrimitiveBlend2 Stdcall ( _
        ByVal primitive_blend As D2D1_PRIMITIVE_BLEND _
    ) As HRESULT
End Type