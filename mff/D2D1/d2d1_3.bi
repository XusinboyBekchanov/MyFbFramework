'###############################################################################
' This file is part of MyFBFramework
' Authors: UEZ, Xusinboy Bekchanov, Liu XiaLin
' Based on UEZ's abstract version.
' Direct2D 1.3 API - FreeBASIC Translation
' Adapted by Xusinboy Bekchanov, Liu XiaLin
'###############################################################################
#pragma once
#include once "d2d1_2.bi"
#include once "d2d1effects_2.bi"
' ============================================================================
' Enumerations
' ============================================================================
Type D2D1_INK_NIB_SHAPE As Long
Enum
    D2D1_INK_NIB_SHAPE_ROUND = 0
    D2D1_INK_NIB_SHAPE_SQUARE = 1
End Enum
Type D2D1_PATCH_EDGE_MODE As Long
Enum
    D2D1_PATCH_EDGE_MODE_ALIASED = 0
    D2D1_PATCH_EDGE_MODE_ANTIALIASED = 1
    D2D1_PATCH_EDGE_MODE_ALIASED_INFLATED = 2
End Enum
Type D2D1_ORIENTATION As Long
Enum
    D2D1_ORIENTATION_DEFAULT = 1
    D2D1_ORIENTATION_FLIP_HORIZONTAL = 2
    D2D1_ORIENTATION_ROTATE_CLOCKWISE180 = 3
    D2D1_ORIENTATION_ROTATE_CLOCKWISE180_FLIP_HORIZONTAL = 4
    D2D1_ORIENTATION_ROTATE_CLOCKWISE90_FLIP_HORIZONTAL = 5
    D2D1_ORIENTATION_ROTATE_CLOCKWISE270 = 6
    D2D1_ORIENTATION_ROTATE_CLOCKWISE270_FLIP_HORIZONTAL = 7
    D2D1_ORIENTATION_ROTATE_CLOCKWISE90 = 8
End Enum
Type D2D1_TRANSFORMED_IMAGE_SOURCE_OPTIONS As Long
Enum
    D2D1_TRANSFORMED_IMAGE_SOURCE_OPTIONS_NONE = 0
    D2D1_TRANSFORMED_IMAGE_SOURCE_OPTIONS_DISABLE_DPI_SCALE = 1
End Enum
Type D2D1_IMAGE_SOURCE_LOADING_OPTIONS As Long
Enum
    D2D1_IMAGE_SOURCE_LOADING_OPTIONS_NONE = 0
    D2D1_IMAGE_SOURCE_LOADING_OPTIONS_RELEASE_SOURCE = 1
    D2D1_IMAGE_SOURCE_LOADING_OPTIONS_CACHE_ON_DEMAND = 2
End Enum
Type D2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS As Long
Enum
    D2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS_NONE = 0
    D2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS_LOW_QUALITY_PRIMARY_CONVERSION = 1
End Enum
Type D2D1_SPRITE_OPTIONS As Long
Enum
    D2D1_SPRITE_OPTIONS_NONE = 0
    D2D1_SPRITE_OPTIONS_CLAMP_TO_SOURCE_RECTANGLE = 1
End Enum
Type D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION As Long
Enum
    D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION_DEFAULT = 0
    D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION_DISABLE = 1
End Enum
Type D2D1_GAMMA1 As Long
Enum
    D2D1_GAMMA1_G22 = 0  ' D2D1_GAMMA_2_2
    D2D1_GAMMA1_G10 = 1  ' D2D1_GAMMA_1_0
    D2D1_GAMMA1_G2084 = 2
End Enum
Type D2D1_COLOR_CONTEXT_TYPE As Long
Enum
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
Type ID2D1InkStyleVtbl As ID2D1InkStyleVtbl_
Type ID2D1InkStyle
    lpVtbl As ID2D1InkStyleVtbl Ptr
End Type
Type ID2D1InkStyleVtbl_     '' Extends ID2D1ResourceVtbl_
    QueryInterface As Function(ByVal This As ID2D1InkStyle Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1InkStyle Ptr) As ULong
    Release As Function(ByVal This As ID2D1InkStyle Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1InkStyle Ptr, ByVal factory As Any Ptr Ptr)

        ' 4: GetFactory (ID2D1Resource)
        ' 5. SetNibTransform
    SetNibTransform As Sub(ByVal This As ID2D1InkStyle Ptr,  ByVal transform As D2D1_MATRIX_3X2_F Ptr )
        ' 6. GetNibTransform
    GetNibTransform As Sub(ByVal This As ID2D1InkStyle Ptr,  ByVal transform As D2D1_MATRIX_3X2_F Ptr )
        ' 7. SetNibShape
    SetNibShape As Sub(ByVal This As ID2D1InkStyle Ptr,  ByVal shape As D2D1_INK_NIB_SHAPE )
        ' 8. GetNibShape
    GetNibShape As Function(ByVal This As ID2D1InkStyle Ptr) As D2D1_INK_NIB_SHAPE
End Type
#define ID2D1InkStyle_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1InkStyle_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1InkStyle_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1InkStyle_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1InkStyle_SetNibTransform(p, a) (p)->lpVtbl->SetNibTransform(p, a)
#define ID2D1InkStyle_GetNibTransform(p, a) (p)->lpVtbl->GetNibTransform(p, a)
#define ID2D1InkStyle_SetNibShape(p, a) (p)->lpVtbl->SetNibShape(p, a)
#define ID2D1InkStyle_GetNibShape(p, a) (p)->lpVtbl->GetNibShape(p, a)

' ============================================================================
' ID2D1Ink
' ============================================================================
Type ID2D1InkVtbl As ID2D1InkVtbl_
Type ID2D1Ink
    lpVtbl As ID2D1InkVtbl Ptr
End Type
Type ID2D1InkVtbl_     '' Extends ID2D1ResourceVtbl_
    QueryInterface As Function(ByVal This As ID2D1Ink Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Ink Ptr) As ULong
    Release As Function(ByVal This As ID2D1Ink Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1Ink Ptr, ByVal factory As Any Ptr Ptr)

        ' 4: GetFactory (ID2D1Resource)
        ' 5. SetStartPoint
    SetStartPoint As Sub(ByVal This As ID2D1Ink Ptr,  ByVal start_point As D2D1_INK_POINT Ptr )
        ' 6. GetStartPoint
    GetStartPoint As Function(ByVal This As ID2D1Ink Ptr) As D2D1_INK_POINT
        ' 7. AddSegments
    AddSegments As Function(ByVal This As ID2D1Ink Ptr,  ByVal segments As D2D1_INK_BEZIER_SEGMENT Ptr, ByVal segment_count As ULong ) As HRESULT
        ' 8. RemoveSegmentsAtEnd
    RemoveSegmentsAtEnd As Function(ByVal This As ID2D1Ink Ptr,  ByVal segment_count As ULong ) As HRESULT
        ' 9. SetSegments
    SetSegments As Function(ByVal This As ID2D1Ink Ptr,  ByVal start_segment As ULong, ByVal segments As D2D1_INK_BEZIER_SEGMENT Ptr, ByVal segment_count As ULong ) As HRESULT
        ' 10. SetSegmentAtEnd
    SetSegmentAtEnd As Function(ByVal This As ID2D1Ink Ptr,  ByVal segment As D2D1_INK_BEZIER_SEGMENT Ptr ) As HRESULT
        ' 11. GetSegmentCount
    GetSegmentCount As Function(ByVal This As ID2D1Ink Ptr) As ULong
        ' 12. GetSegments
    GetSegments As Function(ByVal This As ID2D1Ink Ptr,  ByVal start_segment As ULong, ByVal segments As D2D1_INK_BEZIER_SEGMENT Ptr, ByVal segment_count As ULong ) As HRESULT
        ' 13. StreamAsGeometry
    StreamAsGeometry As Function(ByVal This As ID2D1Ink Ptr,  ByVal ink_style As ID2D1InkStyle Ptr, ByVal world_transform As D2D1_MATRIX_3X2_F Ptr, ByVal flattening_tolerance As Single, ByVal geometry_sink As Any Ptr ) As HRESULT
        ' 14. GetBounds
    GetBounds As Function(ByVal This As ID2D1Ink Ptr,  ByVal ink_style As ID2D1InkStyle Ptr, ByVal world_transform As D2D1_MATRIX_3X2_F Ptr, ByVal bounds As D2D1_RECT_F Ptr ) As HRESULT
End Type
#define ID2D1Ink_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Ink_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Ink_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Ink_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1Ink_SetStartPoint(p, a) (p)->lpVtbl->SetStartPoint(p, a)
#define ID2D1Ink_GetStartPoint(p, a) (p)->lpVtbl->GetStartPoint(p, a)
#define ID2D1Ink_AddSegments(p, a, b) (p)->lpVtbl->AddSegments(p, a, b)
#define ID2D1Ink_RemoveSegmentsAtEnd(p, a) (p)->lpVtbl->RemoveSegmentsAtEnd(p, a)
#define ID2D1Ink_SetSegments(p, a, b, c) (p)->lpVtbl->SetSegments(p, a, b, c)
#define ID2D1Ink_SetSegmentAtEnd(p, a) (p)->lpVtbl->SetSegmentAtEnd(p, a)
#define ID2D1Ink_GetSegmentCount(p, a) (p)->lpVtbl->GetSegmentCount(p, a)
#define ID2D1Ink_GetSegments(p, a, b, c) (p)->lpVtbl->GetSegments(p, a, b, c)
#define ID2D1Ink_StreamAsGeometry(p, a, b, c, d) (p)->lpVtbl->StreamAsGeometry(p, a, b, c, d)
#define ID2D1Ink_GetBounds(p, a, b, c) (p)->lpVtbl->GetBounds(p, a, b, c)

' ============================================================================
' ID2D1GradientMesh
' ============================================================================
Type ID2D1GradientMeshVtbl As ID2D1GradientMeshVtbl_
Type ID2D1GradientMesh
    lpVtbl As ID2D1GradientMeshVtbl Ptr
End Type
Type ID2D1GradientMeshVtbl_     '' Extends ID2D1ResourceVtbl_
    QueryInterface As Function(ByVal This As ID2D1GradientMesh Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1GradientMesh Ptr) As ULong
    Release As Function(ByVal This As ID2D1GradientMesh Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1GradientMesh Ptr, ByVal factory As Any Ptr Ptr)

        ' 4: GetFactory (ID2D1Resource)
        ' 5. GetPatchCount
    GetPatchCount As Function(ByVal This As ID2D1GradientMesh Ptr) As ULong
        ' 6. GetPatches
    GetPatches As Function(ByVal This As ID2D1GradientMesh Ptr,  ByVal start_index As ULong, ByVal patches As D2D1_GRADIENT_MESH_PATCH Ptr, ByVal patch_count As ULong ) As HRESULT
End Type
#define ID2D1GradientMesh_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1GradientMesh_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1GradientMesh_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1GradientMesh_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1GradientMesh_GetPatchCount(p, a) (p)->lpVtbl->GetPatchCount(p, a)
#define ID2D1GradientMesh_GetPatches(p, a, b, c) (p)->lpVtbl->GetPatches(p, a, b, c)

' ============================================================================
' ID2D1ImageSource
' ============================================================================
Type ID2D1ImageSourceVtbl As ID2D1ImageSourceVtbl_
Type ID2D1ImageSource
    lpVtbl As ID2D1ImageSourceVtbl Ptr
End Type
Type ID2D1ImageSourceVtbl_     '' Extends ID2D1ImageVtbl_
        ' 4-5: ID2D1Resource
        
    OfferResources As Function(ByVal This As ID2D1ImageSource Ptr) As HRESULT
        ' 8. TryReclaimResources
    TryReclaimResources As Function(ByVal This As ID2D1ImageSource Ptr,  ByVal resources_discarded As Long Ptr ) As HRESULT
End Type
#define ID2D1ImageSource_OfferResources(p, a) (p)->lpVtbl->OfferResources(p, a)
#define ID2D1ImageSource_TryReclaimResources(p, a) (p)->lpVtbl->TryReclaimResources(p, a)

' ============================================================================
' ID2D1ImageSourceFromWic
' ============================================================================
Type ID2D1ImageSourceFromWicVtbl As ID2D1ImageSourceFromWicVtbl_
Type ID2D1ImageSourceFromWic
    lpVtbl As ID2D1ImageSourceFromWicVtbl Ptr
End Type
Type ID2D1ImageSourceFromWicVtbl_     '' Extends ID2D1ImageSourceVtbl_
        ' 4-5: ID2D1Resource
        
    OfferResources As Function(ByVal This As ID2D1ImageSourceFromWic Ptr) As HRESULT
        ' 8. TryReclaimResources
    TryReclaimResources As Function(ByVal This As ID2D1ImageSourceFromWic Ptr,  ByVal resources_discarded As Long Ptr ) As HRESULT

        ' 4-8: ID2D1ImageSource
        ' 9. EnsureCached
    EnsureCached As Function(ByVal This As ID2D1ImageSourceFromWic Ptr,  ByVal rect_to_fill As D2D1_RECT_U Ptr ) As HRESULT
        ' 10. TrimCache
    TrimCache As Function(ByVal This As ID2D1ImageSourceFromWic Ptr,  ByVal rect_to_preserve As D2D1_RECT_U Ptr ) As HRESULT
        ' 11. GetSource
    GetSource As Sub(ByVal This As ID2D1ImageSourceFromWic Ptr,  ByVal source As Any Ptr Ptr )
End Type
#define ID2D1ImageSourceFromWic_OfferResources(p, a) (p)->lpVtbl->OfferResources(p, a)
#define ID2D1ImageSourceFromWic_TryReclaimResources(p, a) (p)->lpVtbl->TryReclaimResources(p, a)
#define ID2D1ImageSourceFromWic_EnsureCached(p, a) (p)->lpVtbl->EnsureCached(p, a)
#define ID2D1ImageSourceFromWic_TrimCache(p, a) (p)->lpVtbl->TrimCache(p, a)
#define ID2D1ImageSourceFromWic_GetSource(p, a) (p)->lpVtbl->GetSource(p, a)

' ============================================================================
' ID2D1TransformedImageSource
' ============================================================================
Type ID2D1TransformedImageSourceVtbl As ID2D1TransformedImageSourceVtbl_
Type ID2D1TransformedImageSource
    lpVtbl As ID2D1TransformedImageSourceVtbl Ptr
End Type
Type ID2D1TransformedImageSourceVtbl_     '' Extends ID2D1ImageVtbl_
        ' 4-5: ID2D1Resource
        
    GetSource As Sub(ByVal This As ID2D1TransformedImageSource Ptr,  ByVal source As Any Ptr Ptr )
        ' 8. GetProperties
    GetProperties As Sub(ByVal This As ID2D1TransformedImageSource Ptr,  ByVal out As D2D1_TRANSFORMED_IMAGE_SOURCE_PROPERTIES Ptr )
End Type
#define ID2D1TransformedImageSource_GetSource(p, a) (p)->lpVtbl->GetSource(p, a)
#define ID2D1TransformedImageSource_GetProperties(p, a) (p)->lpVtbl->GetProperties(p, a)

' ============================================================================
' ID2D1LookupTable3D
' ============================================================================
Type ID2D1LookupTable3D Extends ID2D1Resource
    ' 4: GetFactory (ID2D1Resource)
    ' Keine zusätzlichen Methoden
End Type
' ============================================================================
' ID2D1SpriteBatch
' ============================================================================
Type ID2D1SpriteBatchVtbl As ID2D1SpriteBatchVtbl_
Type ID2D1SpriteBatch
    lpVtbl As ID2D1SpriteBatchVtbl Ptr
End Type
Type ID2D1SpriteBatchVtbl_     '' Extends ID2D1ResourceVtbl_
    QueryInterface As Function(ByVal This As ID2D1SpriteBatch Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1SpriteBatch Ptr) As ULong
    Release As Function(ByVal This As ID2D1SpriteBatch Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1SpriteBatch Ptr, ByVal factory As Any Ptr Ptr)

        ' 4: GetFactory (ID2D1Resource)
        ' 5. AddSprites
    AddSprites As Function(ByVal This As ID2D1SpriteBatch Ptr,  ByVal sprite_count As ULong, ByVal destination_rectangles As D2D1_RECT_F Ptr, ByVal source_rectangles As D2D1_RECT_U Ptr, ByVal colors As D2D1_COLOR_F Ptr, ByVal transforms As D2D1_MATRIX_3X2_F Ptr, ByVal destination_rectangles_stride As ULong, ByVal source_rectangles_stride As ULong, ByVal colors_stride As ULong, ByVal transforms_stride As ULong ) As HRESULT
        ' 6. SetSprites
    SetSprites As Function(ByVal This As ID2D1SpriteBatch Ptr,  ByVal start_index As ULong, ByVal sprite_count As ULong, ByVal destination_rectangles As D2D1_RECT_F Ptr, ByVal source_rectangles As D2D1_RECT_U Ptr, ByVal colors As D2D1_COLOR_F Ptr, ByVal transforms As D2D1_MATRIX_3X2_F Ptr, ByVal destination_rectangles_stride As ULong, ByVal source_rectangles_stride As ULong, ByVal colors_stride As ULong, ByVal transforms_stride As ULong ) As HRESULT
        ' 7. GetSprites
    GetSprites As Function(ByVal This As ID2D1SpriteBatch Ptr,  ByVal start_index As ULong, ByVal sprite_count As ULong, ByVal destination_rectangles As D2D1_RECT_F Ptr, ByVal source_rectangles As D2D1_RECT_U Ptr, ByVal colors As D2D1_COLOR_F Ptr, ByVal transforms As D2D1_MATRIX_3X2_F Ptr ) As HRESULT
        ' 8. GetSpriteCount
    GetSpriteCount As Function(ByVal This As ID2D1SpriteBatch Ptr) As ULong
        ' 9. Clear
    Clear As Sub(ByVal This As ID2D1SpriteBatch Ptr)
End Type
#define ID2D1SpriteBatch_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1SpriteBatch_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1SpriteBatch_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1SpriteBatch_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1SpriteBatch_AddSprites(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->AddSprites(p, a, b, c, d, e, f, g, h, i)
#define ID2D1SpriteBatch_SetSprites(p, a, b, c, d, e, f, g, h, i, j) (p)->lpVtbl->SetSprites(p, a, b, c, d, e, f, g, h, i, j)
#define ID2D1SpriteBatch_GetSprites(p, a, b, c, d, e, f) (p)->lpVtbl->GetSprites(p, a, b, c, d, e, f)
#define ID2D1SpriteBatch_GetSpriteCount(p, a) (p)->lpVtbl->GetSpriteCount(p, a)
#define ID2D1SpriteBatch_Clear(p, a) (p)->lpVtbl->Clear(p, a)

' ============================================================================
' ID2D1SvgGlyphStyle
' ============================================================================
Type ID2D1SvgGlyphStyleVtbl As ID2D1SvgGlyphStyleVtbl_
Type ID2D1SvgGlyphStyle
    lpVtbl As ID2D1SvgGlyphStyleVtbl Ptr
End Type
Type ID2D1SvgGlyphStyleVtbl_     '' Extends ID2D1ResourceVtbl_
    QueryInterface As Function(ByVal This As ID2D1SvgGlyphStyle Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1SvgGlyphStyle Ptr) As ULong
    Release As Function(ByVal This As ID2D1SvgGlyphStyle Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1SvgGlyphStyle Ptr, ByVal factory As Any Ptr Ptr)

        ' 4: GetFactory (ID2D1Resource)
        ' 5. SetFill
    SetFill As Function(ByVal This As ID2D1SvgGlyphStyle Ptr,  ByVal brush As ID2D1Brush Ptr ) As HRESULT
        ' 6. GetFill
    GetFill As Sub(ByVal This As ID2D1SvgGlyphStyle Ptr,  ByVal brush As Any Ptr Ptr )
        ' 7. SetStroke
    SetStroke As Function(ByVal This As ID2D1SvgGlyphStyle Ptr,  ByVal brush As ID2D1Brush Ptr, ByVal stroke_width As Single, ByVal dashes As Single Ptr, ByVal dashes_count As ULong, ByVal dash_offset As Single ) As HRESULT
        ' 8. GetStrokeDashesCount
    GetStrokeDashesCount As Function(ByVal This As ID2D1SvgGlyphStyle Ptr) As ULong
        ' 9. GetStroke
    GetStroke As Sub(ByVal This As ID2D1SvgGlyphStyle Ptr,  ByVal brush As Any Ptr Ptr, ByVal stroke_width As Single Ptr, ByVal dashes As Single Ptr, ByVal dashes_count As ULong, ByVal dash_offset As Single Ptr )
End Type
#define ID2D1SvgGlyphStyle_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1SvgGlyphStyle_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1SvgGlyphStyle_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1SvgGlyphStyle_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1SvgGlyphStyle_SetFill(p, a) (p)->lpVtbl->SetFill(p, a)
#define ID2D1SvgGlyphStyle_GetFill(p, a) (p)->lpVtbl->GetFill(p, a)
#define ID2D1SvgGlyphStyle_SetStroke(p, a, b, c, d, e) (p)->lpVtbl->SetStroke(p, a, b, c, d, e)
#define ID2D1SvgGlyphStyle_GetStrokeDashesCount(p, a) (p)->lpVtbl->GetStrokeDashesCount(p, a)
#define ID2D1SvgGlyphStyle_GetStroke(p, a, b, c, d, e) (p)->lpVtbl->GetStroke(p, a, b, c, d, e)

' ============================================================================
' ID2D1ColorContext1
' ============================================================================
Type ID2D1ColorContext1Vtbl As ID2D1ColorContext1Vtbl_
Type ID2D1ColorContext1
    lpVtbl As ID2D1ColorContext1Vtbl Ptr
End Type
Type ID2D1ColorContext1Vtbl_     '' Extends ID2D1ColorContextVtbl_
    QueryInterface As Function(ByVal This As ID2D1ColorContext1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1ColorContext1 Ptr) As ULong
    Release As Function(ByVal This As ID2D1ColorContext1 Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1ColorContext1 Ptr, ByVal factory As Any Ptr Ptr)
        ' 4: GetFactory
        ' 5. GetColorSpace
    GetColorSpace As Function(ByVal This As ID2D1ColorContext1 Ptr) As D2D1_COLOR_SPACE
        ' 6. GetProfileSize
    GetProfileSize As Function(ByVal This As ID2D1ColorContext1 Ptr) As ULong
        ' 7. GetProfile
    GetProfile As Function(ByVal This As ID2D1ColorContext1 Ptr,  ByVal profile As UByte Ptr, ByVal size As ULong ) As HRESULT

        ' Erbt von ID2D1ColorContext
        ' Zusätzliche Methoden
    GetColorContextType As Function(ByVal This As ID2D1ColorContext1 Ptr) As D2D1_COLOR_CONTEXT_TYPE
    GetDXGIColorSpace As Function(ByVal This As ID2D1ColorContext1 Ptr) As ULong ' DXGI_COLOR_SPACE_TYPE
    GetSimpleColorProfile As Function(ByVal This As ID2D1ColorContext1 Ptr,  ByVal simple_profile As D2D1_SIMPLE_COLOR_PROFILE Ptr ) As HRESULT
End Type
#define ID2D1ColorContext1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1ColorContext1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1ColorContext1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1ColorContext1_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1ColorContext1_GetColorSpace(p, a) (p)->lpVtbl->GetColorSpace(p, a)
#define ID2D1ColorContext1_GetProfileSize(p, a) (p)->lpVtbl->GetProfileSize(p, a)
#define ID2D1ColorContext1_GetProfile(p, a, b) (p)->lpVtbl->GetProfile(p, a, b)
#define ID2D1ColorContext1_GetColorContextType(p, a) (p)->lpVtbl->GetColorContextType(p, a)
#define ID2D1ColorContext1_GetDXGIColorSpace(p, a) (p)->lpVtbl->GetDXGIColorSpace(p, a)
#define ID2D1ColorContext1_GetSimpleColorProfile(p, a) (p)->lpVtbl->GetSimpleColorProfile(p, a)

' ============================================================================
' ID2D1DeviceContext2
' ============================================================================
Type ID2D1DeviceContext2Vtbl As ID2D1DeviceContext2Vtbl_
Type ID2D1DeviceContext2
    lpVtbl As ID2D1DeviceContext2Vtbl Ptr
End Type
Type ID2D1DeviceContext2Vtbl_     '' Extends ID2D1DeviceContext1Vtbl_
    QueryInterface As Function(ByVal This As ID2D1DeviceContext2 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1DeviceContext2 Ptr) As ULong
    Release As Function(ByVal This As ID2D1DeviceContext2 Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal factory As Any Ptr Ptr)
        ' 4.   (ID2D1Resource: GetFactory)
    CreateBitmap As Function(ByVal This As ID2D1DeviceContext2 Ptr, ByVal size As D2D1_SIZE_U, ByVal srcData As Any Ptr, ByVal pitch As ULong, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapFromWicBitmap As Function(ByVal This As ID2D1DeviceContext2 Ptr, ByVal wicBitmapSource As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateSharedBitmap As Function(ByVal This As ID2D1DeviceContext2 Ptr, ByVal riid As GUID Ptr, ByVal data As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapBrush As Function(ByVal This As ID2D1DeviceContext2 Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal bitmapBrushProperties As D2D1_BITMAP_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal bitmapBrush As ID2D1BitmapBrush Ptr Ptr) As HRESULT
    CreateSolidColorBrush As Function(ByVal This As ID2D1DeviceContext2 Ptr, ByVal color As D2D1_COLOR_F Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal solidColorBrush As ID2D1SolidColorBrush Ptr Ptr) As HRESULT
    CreateGradientStopCollection As Function(ByVal This As ID2D1DeviceContext2 Ptr, ByVal gradientStops As D2D1_GRADIENT_STOP Ptr, ByVal gradientStopsCount As ULong, ByVal colorInterpolationGamma As D2D1_GAMMA, ByVal extendMode As D2D1_EXTEND_MODE, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr Ptr) As HRESULT
    CreateLinearGradientBrush As Function(ByVal This As ID2D1DeviceContext2 Ptr, ByVal linearGradientBrushProperties As D2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal linearGradientBrush As ID2D1LinearGradientBrush Ptr Ptr) As HRESULT
    CreateRadialGradientBrush As Function(ByVal This As ID2D1DeviceContext2 Ptr, ByVal radialGradientBrushProperties As D2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal radialGradientBrush As ID2D1RadialGradientBrush Ptr Ptr) As HRESULT
    CreateCompatibleRenderTarget As Function(ByVal This As ID2D1DeviceContext2 Ptr, ByVal desiredSize As D2D1_SIZE_F Ptr, ByVal desiredPixelSize As D2D1_SIZE_U Ptr, ByVal desiredFormat As D2D1_PIXEL_FORMAT Ptr, ByVal options As ULong, ByVal bitmapRenderTarget As Any Ptr Ptr) As HRESULT 'ID2D1BitmapRenderTarget
    CreateLayer As Function(ByVal This As ID2D1DeviceContext2 Ptr, ByVal size As D2D1_SIZE_F Ptr, ByVal layer As ID2D1Layer Ptr Ptr) As HRESULT
    CreateMesh As Function(ByVal This As ID2D1DeviceContext2 Ptr, ByVal mesh As ID2D1Mesh Ptr Ptr) As HRESULT
    DrawLine As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal p0 As D2D1_POINT_2F, ByVal p1 As D2D1_POINT_2F, ByVal brush As ID2D1SolidColorBrush Ptr, ByVal strokeWidth As Single = 0, ByVal strokeStyle As ID2D1StrokeStyle Ptr = NULL)
    DrawRectangle As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRectangle As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawRoundedRectangle As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRoundedRectangle As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawEllipse As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillEllipse As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawGeometry As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillGeometry As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal opacityBrush As ID2D1Brush Ptr)
    FillMesh As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal mesh As ID2D1Mesh Ptr, ByVal brush As ID2D1Brush Ptr)
    FillOpacityMask As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal mask As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal content As D2D1_OPACITY_MASK_CONTENT, ByVal destRect As D2D1_RECT_F Ptr, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawBitmap As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal destRect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolationMode As D2D1_BITMAP_INTERPOLATION_MODE, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawText As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal text As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal layoutRect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS = 0, ByVal measuringMode As DWRITE_MEASURING_MODE = 0)
    DrawTextLayout As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal origin As D2D1_POINT_2F Ptr, ByVal layout As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS)
    DrawGlyphRun As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal baselineOrigin As D2D1_POINT_2F Ptr, ByVal glyphRun As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE)
    SetTransform As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    GetTransform As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    SetAntialiasMode As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    GetAntialiasMode As Function(ByVal This As ID2D1DeviceContext2 Ptr) As D2D1_ANTIALIAS_MODE
    SetTextAntialiasMode As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal antialiasMode As D2D1_TEXT_ANTIALIAS_MODE)
    GetTextAntialiasMode As Function(ByVal This As ID2D1DeviceContext2 Ptr) As D2D1_TEXT_ANTIALIAS_MODE
    SetTextRenderingParams As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal params As Any Ptr)
    GetTextRenderingParams As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal params As Any Ptr Ptr)
    SetTags As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal tag1 As D2D1_TAG, ByVal tag2 As D2D1_TAG)
    GetTags As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr)
    PushLayer As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal layerParams As D2D1_LAYER_PARAMETERS Ptr, ByVal layer As ID2D1Layer Ptr)
    PopLayer As Sub(ByVal This As ID2D1DeviceContext2 Ptr)
    Flush As Function(ByVal This As ID2D1DeviceContext2 Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    SaveDrawingState As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal stateBlock As Any Ptr)
    RestoreDrawingState As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal stateBlock As Any Ptr)
    PushAxisAlignedClip As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    PopAxisAlignedClip As Sub(ByVal This As ID2D1DeviceContext2 Ptr)
    Clear As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal col As D2D1_COLOR_F Ptr)
    BeginDraw As Sub(ByVal This As ID2D1DeviceContext2 Ptr)
    EndDraw As Function(ByVal This As ID2D1DeviceContext2 Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    GetPixelFormat As Function(ByVal This As ID2D1DeviceContext2 Ptr) As D2D1_PIXEL_FORMAT
    SetDpi As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal dpiX As Single, ByVal dpiY As Single)
    GetDpi As Sub(ByVal This As ID2D1DeviceContext2 Ptr, ByVal dpiX As Single Ptr, ByVal dpiY As Single Ptr)
    GetSize As Function(ByVal This As ID2D1DeviceContext2 Ptr, ByVal size As Any Ptr) As D2D1_SIZE_F
    GetPixelSize As Function(ByVal This As ID2D1DeviceContext2 Ptr, ByVal pixelSize As Any Ptr) As D2D1_SIZE_U
    GetMaximumBitmapSize As Function(ByVal This As ID2D1DeviceContext2 Ptr) As ULong
    IsSupported As Function(ByVal This As ID2D1DeviceContext2 Ptr, ByVal renderTargetProperties As D2D1_RENDER_TARGET_PROPERTIES Ptr) As BOOL
        ' Erbt alle Methoden von ID2D1RenderTarget (1-57)
    	' 58. CreateBitmap (überladen)
    CreateBitmap1 As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal size As D2D1_SIZE_U, ByVal src_data As Any Ptr, ByVal pitch As ULong, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As Any Ptr Ptr ) As HRESULT
    	' 59. CreateBitmapFromWicBitmap (überladen)
    CreateBitmapFromWicBitmap1 As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal bitmap_source As IUnknownBase Ptr, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As ID2D1Bitmap1 Ptr Ptr ) As HRESULT
    	' 60. CreateColorContext
    CreateColorContext As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal space As D2D1_COLOR_SPACE, ByVal profile As UByte Ptr, ByVal profile_size As ULong, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 61. CreateColorContextFromFilename
    CreateColorContextFromFilename As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal filename As WString Ptr, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 62. CreateColorContextFromWicColorContext
    CreateColorContextFromWicColorContext As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal wic_color_context As Any Ptr, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 63. CreateBitmapFromDxgiSurface
    CreateBitmapFromDxgiSurface As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal surface As Any Ptr, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As Any Ptr Ptr ) As HRESULT
    	' 64. CreateEffect
    CreateEffect As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByRef effect_id As GUID, ByVal effect As ID2D1Effect Ptr Ptr ) As HRESULT
    	' 65. CreateGradientStopCollection (überladen)
    CreateGradientStopCollection1 As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal stops As D2D1_GRADIENT_STOP Ptr, ByVal stop_count As ULong, ByVal preinterpolation_space As D2D1_COLOR_SPACE, ByVal postinterpolation_space As D2D1_COLOR_SPACE, ByVal buffer_precision As D2D1_BUFFER_PRECISION, ByVal extend_mode As D2D1_EXTEND_MODE, ByVal color_interpolation_mode As D2D1_COLOR_INTERPOLATION_MODE, ByVal gradient As Any Ptr Ptr ) As HRESULT
    	' 66. CreateImageBrush
    CreateImageBrush As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal image As ID2D1Image Ptr, ByVal image_brush_desc As D2D1_IMAGE_BRUSH_PROPERTIES Ptr, ByVal brush_desc As D2D1_BRUSH_PROPERTIES Ptr, ByVal brush As Any Ptr Ptr ) As HRESULT
    	' 67. CreateBitmapBrush (überladen)
    CreateBitmapBrush1 As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal bitmap_brush_desc As D2D1_BITMAP_BRUSH_PROPERTIES1 Ptr, ByVal brush_desc As D2D1_BRUSH_PROPERTIES Ptr, ByVal bitmap_brush As Any Ptr Ptr ) As HRESULT
    	' 68. CreateCommandList
    CreateCommandList As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal command_list As Any Ptr Ptr ) As HRESULT
    	' 69. IsDxgiFormatSupported
    IsDxgiFormatSupported As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal format As ULong ) As Long
    	' 70. IsBufferPrecisionSupported
    IsBufferPrecisionSupported As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal buffer_precision As D2D1_BUFFER_PRECISION ) As Long
    	' 71. GetImageLocalBounds
    GetImageLocalBounds As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal image As ID2D1Image Ptr, ByVal local_bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 72. GetImageWorldBounds
    GetImageWorldBounds As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal image As ID2D1Image Ptr, ByVal world_bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 73. GetGlyphRunWorldBounds
    GetGlyphRunWorldBounds As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal measuring_mode As ULong, ByVal bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 74. GetDevice
    GetDevice As Sub(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal device As Any Ptr Ptr )
    	' 75. SetTarget
    SetTarget As Sub(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal target As ID2D1Image Ptr )
    	' 76. GetTarget
    GetTarget As Sub(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal target As Any Ptr Ptr )
    	' 77. SetRenderingControls
    SetRenderingControls As Sub(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal rendering_controls As D2D1_RENDERING_CONTROLS Ptr )
    	' 78. GetRenderingControls
    GetRenderingControls As Sub(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal rendering_controls As D2D1_RENDERING_CONTROLS Ptr )
    	' 79. SetPrimitiveBlend
    SetPrimitiveBlend As Sub(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal primitive_blend As D2D1_PRIMITIVE_BLEND )
    	' 80. GetPrimitiveBlend
    GetPrimitiveBlend As Function(ByVal This As ID2D1DeviceContext2 Ptr) As D2D1_PRIMITIVE_BLEND
    	' 81. SetUnitMode
    SetUnitMode As Sub(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal unit_mode As D2D1_UNIT_MODE )
    	' 82. GetUnitMode
    GetUnitMode As Function(ByVal This As ID2D1DeviceContext2 Ptr) As D2D1_UNIT_MODE
    	' 83. DrawGlyphRun (überladen)
    DrawGlyphRun1 As Sub(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal glyph_run_desc As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuring_mode As ULong )
    	' 84. DrawImage
    DrawImage As Sub(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal image As ID2D1Image Ptr, ByVal target_offset As D2D1_POINT_2F Ptr = 0, ByVal image_rect As D2D1_RECT_F Ptr = 0, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR, ByVal composite_mode As D2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER )
    	' 85. DrawGdiMetafile
    DrawGdiMetafile As Sub(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal metafile As ID2D1GdiMetafile Ptr, ByVal target_offset As D2D1_POINT_2F Ptr )
    	' 86. DrawBitmap (überladen)
    DrawBitmap1 As Sub(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE, ByVal src_rect As D2D1_RECT_F Ptr, ByVal perspective_transform As D2D1_MATRIX_4X4_F Ptr )
    	' 87. InvalidateEffectInputRectangle
    InvalidateEffectInputRectangle As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal effect As Any Ptr, ByVal input As ULong, ByVal input_rect As D2D1_RECT_F Ptr ) As HRESULT
    	' 88. GetEffectInvalidRectangleCount
    GetEffectInvalidRectangleCount As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal effect As Any Ptr, ByVal rect_count As ULong Ptr ) As HRESULT
    	' 89. GetEffectInvalidRectangles
    GetEffectInvalidRectangles As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal effect As Any Ptr, ByVal rectangles As D2D1_RECT_F Ptr, ByVal rect_count As ULong ) As HRESULT
    	' 90. GetEffectRequiredInputRectangles
    GetEffectRequiredInputRectangles As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal effect As Any Ptr, ByVal image_rect As D2D1_RECT_F Ptr, ByVal desc As D2D1_EFFECT_INPUT_DESCRIPTION Ptr, ByVal input_rects As D2D1_RECT_F Ptr, ByVal input_count As ULong ) As HRESULT
    	' 91. FillOpacityMask (überladen)
    FillOpacityMask1 As Sub(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal mask As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal content As D2D1_OPACITY_MASK_CONTENT, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal src_rect As D2D1_RECT_F Ptr )
    	' 92. PushLayer
    PushLayer1 As Sub(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal layer_parameters As D2D1_LAYER_PARAMETERS1 Ptr, ByVal layer As ID2D1Layer Ptr )
        ' Erbt alle Methoden von ID2D1DeviceContext (1-96 Methoden)
        ' 97. CreateFilledGeometryRealization
    CreateFilledGeometryRealization As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal tolerance As Single, ByVal realization As Any Ptr Ptr ) As HRESULT
        ' 98. CreateStrokedGeometryRealization
    CreateStrokedGeometryRealization As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal tolerance As Single, ByVal stroke_width As Single, ByVal stroke_style As ID2D1StrokeStyle Ptr, ByVal realization As Any Ptr Ptr ) As HRESULT
        ' 99. DrawGeometryRealization
    DrawGeometryRealization As Sub(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal realization As ID2D1GeometryRealization Ptr, ByVal brush As ID2D1Brush Ptr )

        ' Erbt alle Methoden von ID2D1DeviceContext1
        ' Neue Methoden
    CreateInk As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal start_point As D2D1_INK_POINT Ptr, ByVal ink As Any Ptr Ptr ) As HRESULT
    CreateInkStyle As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal ink_style_properties As D2D1_INK_STYLE_PROPERTIES Ptr, ByVal ink_style As Any Ptr Ptr ) As HRESULT
    CreateGradientMesh As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal patches As D2D1_GRADIENT_MESH_PATCH Ptr, ByVal patches_count As ULong, ByVal gradient_mesh As Any Ptr Ptr ) As HRESULT
    CreateImageSourceFromWic As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal wic_bitmap_source As Any Ptr, ByVal loading_options As D2D1_IMAGE_SOURCE_LOADING_OPTIONS, ByVal alpha_mode As D2D1_ALPHA_MODE, ByVal image_source As Any Ptr Ptr ) As HRESULT
    CreateLookupTable3D As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal precision As ULong, ByVal extents As ULong Ptr, ByVal data As UByte Ptr, ByVal data_count As ULong, ByVal strides As ULong Ptr, ByVal lookup_table As Any Ptr Ptr ) As HRESULT
    CreateImageSourceFromDxgi As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal surfaces As Any Ptr Ptr, ByVal surface_count As ULong, ByVal color_space As ULong, ByVal options As D2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS, ByVal image_source As Any Ptr Ptr ) As HRESULT
    GetGradientMeshWorldBounds As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal gradient_mesh As ID2D1GradientMesh Ptr, ByVal bounds As D2D1_RECT_F Ptr ) As HRESULT
    DrawInk As Sub(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal ink As ID2D1Ink Ptr, ByVal brush As ID2D1Brush Ptr, ByVal ink_style As ID2D1InkStyle Ptr )
    DrawGradientMesh As Sub(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal gradient_mesh As ID2D1GradientMesh Ptr )
    DrawGdiMetafile1 As Sub(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal gdi_metafile As Any Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal src_rect As D2D1_RECT_F Ptr )
    CreateTransformedImageSource As Function(ByVal This As ID2D1DeviceContext2 Ptr,  ByVal source As ID2D1ImageSource Ptr, ByVal props As D2D1_TRANSFORMED_IMAGE_SOURCE_PROPERTIES Ptr, ByVal transformed As Any Ptr Ptr ) As HRESULT
End Type
#define ID2D1DeviceContext2_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1DeviceContext2_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1DeviceContext2_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1DeviceContext2_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1DeviceContext2_CreateBitmap(p, a, b, c, d, e) (p)->lpVtbl->CreateBitmap(p, a, b, c, d, e)
#define ID2D1DeviceContext2_CreateBitmapFromWicBitmap(p, a, b, c) (p)->lpVtbl->CreateBitmapFromWicBitmap(p, a, b, c)
#define ID2D1DeviceContext2_CreateSharedBitmap(p, a, b, c, d) (p)->lpVtbl->CreateSharedBitmap(p, a, b, c, d)
#define ID2D1DeviceContext2_CreateBitmapBrush(p, a, b, c, d) (p)->lpVtbl->CreateBitmapBrush(p, a, b, c, d)
#define ID2D1DeviceContext2_CreateSolidColorBrush(p, a, b, c) (p)->lpVtbl->CreateSolidColorBrush(p, a, b, c)
#define ID2D1DeviceContext2_CreateGradientStopCollection(p, a, b, c, d, e) (p)->lpVtbl->CreateGradientStopCollection(p, a, b, c, d, e)
#define ID2D1DeviceContext2_CreateLinearGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateLinearGradientBrush(p, a, b, c, d)
#define ID2D1DeviceContext2_CreateRadialGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateRadialGradientBrush(p, a, b, c, d)
#define ID2D1DeviceContext2_CreateCompatibleRenderTarget(p, a, b, c, d, e) (p)->lpVtbl->CreateCompatibleRenderTarget(p, a, b, c, d, e)
#define ID2D1DeviceContext2_CreateLayer(p, a, b) (p)->lpVtbl->CreateLayer(p, a, b)
#define ID2D1DeviceContext2_CreateMesh(p, a) (p)->lpVtbl->CreateMesh(p, a)
#define ID2D1DeviceContext2_DrawLine(p, a, b, c, d, e) (p)->lpVtbl->DrawLine(p, a, b, c, d, e)
#define ID2D1DeviceContext2_DrawRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRectangle(p, a, b, c, d)
#define ID2D1DeviceContext2_FillRectangle(p, a, b) (p)->lpVtbl->FillRectangle(p, a, b)
#define ID2D1DeviceContext2_DrawRoundedRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRoundedRectangle(p, a, b, c, d)
#define ID2D1DeviceContext2_FillRoundedRectangle(p, a, b) (p)->lpVtbl->FillRoundedRectangle(p, a, b)
#define ID2D1DeviceContext2_DrawEllipse(p, a, b, c, d) (p)->lpVtbl->DrawEllipse(p, a, b, c, d)
#define ID2D1DeviceContext2_FillEllipse(p, a, b) (p)->lpVtbl->FillEllipse(p, a, b)
#define ID2D1DeviceContext2_DrawGeometry(p, a, b, c, d) (p)->lpVtbl->DrawGeometry(p, a, b, c, d)
#define ID2D1DeviceContext2_FillGeometry(p, a, b, c) (p)->lpVtbl->FillGeometry(p, a, b, c)
#define ID2D1DeviceContext2_FillMesh(p, a, b) (p)->lpVtbl->FillMesh(p, a, b)
#define ID2D1DeviceContext2_FillOpacityMask(p, a, b, c, d, e) (p)->lpVtbl->FillOpacityMask(p, a, b, c, d, e)
#define ID2D1DeviceContext2_DrawBitmap(p, a, b, c, d, e) (p)->lpVtbl->DrawBitmap(p, a, b, c, d, e)
#define ID2D1DeviceContext2_DrawText(p, a, b, c, d, e, f, g) (p)->lpVtbl->DrawText(p, a, b, c, d, e, f, g)
#define ID2D1DeviceContext2_DrawTextLayout(p, a, b, c, d) (p)->lpVtbl->DrawTextLayout(p, a, b, c, d)
#define ID2D1DeviceContext2_DrawGlyphRun(p, a, b, c, d) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d)
#define ID2D1DeviceContext2_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1DeviceContext2_GetTransform(p, a) (p)->lpVtbl->GetTransform(p, a)
#define ID2D1DeviceContext2_SetAntialiasMode(p, a) (p)->lpVtbl->SetAntialiasMode(p, a)
#define ID2D1DeviceContext2_GetAntialiasMode(p, a) (p)->lpVtbl->GetAntialiasMode(p, a)
#define ID2D1DeviceContext2_SetTextAntialiasMode(p, a) (p)->lpVtbl->SetTextAntialiasMode(p, a)
#define ID2D1DeviceContext2_GetTextAntialiasMode(p, a) (p)->lpVtbl->GetTextAntialiasMode(p, a)
#define ID2D1DeviceContext2_SetTextRenderingParams(p, a) (p)->lpVtbl->SetTextRenderingParams(p, a)
#define ID2D1DeviceContext2_GetTextRenderingParams(p, a) (p)->lpVtbl->GetTextRenderingParams(p, a)
#define ID2D1DeviceContext2_SetTags(p, a, b) (p)->lpVtbl->SetTags(p, a, b)
#define ID2D1DeviceContext2_GetTags(p, a, b) (p)->lpVtbl->GetTags(p, a, b)
#define ID2D1DeviceContext2_PushLayer(p, a, b) (p)->lpVtbl->PushLayer(p, a, b)
#define ID2D1DeviceContext2_PopLayer(p, a) (p)->lpVtbl->PopLayer(p, a)
#define ID2D1DeviceContext2_Flush(p, a, b) (p)->lpVtbl->Flush(p, a, b)
#define ID2D1DeviceContext2_SaveDrawingState(p, a) (p)->lpVtbl->SaveDrawingState(p, a)
#define ID2D1DeviceContext2_RestoreDrawingState(p, a) (p)->lpVtbl->RestoreDrawingState(p, a)
#define ID2D1DeviceContext2_PushAxisAlignedClip(p, a, b) (p)->lpVtbl->PushAxisAlignedClip(p, a, b)
#define ID2D1DeviceContext2_PopAxisAlignedClip(p, a) (p)->lpVtbl->PopAxisAlignedClip(p, a)
#define ID2D1DeviceContext2_Clear(p, a) (p)->lpVtbl->Clear(p, a)
#define ID2D1DeviceContext2_BeginDraw(p, a) (p)->lpVtbl->BeginDraw(p, a)
#define ID2D1DeviceContext2_EndDraw(p, a, b) (p)->lpVtbl->EndDraw(p, a, b)
#define ID2D1DeviceContext2_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)
#define ID2D1DeviceContext2_SetDpi(p, a, b) (p)->lpVtbl->SetDpi(p, a, b)
#define ID2D1DeviceContext2_GetDpi(p, a, b) (p)->lpVtbl->GetDpi(p, a, b)
#define ID2D1DeviceContext2_GetSize(p, a) (p)->lpVtbl->GetSize(p, a)
#define ID2D1DeviceContext2_GetPixelSize(p, a) (p)->lpVtbl->GetPixelSize(p, a)
#define ID2D1DeviceContext2_GetMaximumBitmapSize(p, a) (p)->lpVtbl->GetMaximumBitmapSize(p, a)
#define ID2D1DeviceContext2_IsSupported(p, a) (p)->lpVtbl->IsSupported(p, a)
#define ID2D1DeviceContext2_CreateBitmap1(p, a, b, c, d, e) (p)->lpVtbl->CreateBitmap1(p, a, b, c, d, e)
#define ID2D1DeviceContext2_CreateBitmapFromWicBitmap1(p, a, b, c) (p)->lpVtbl->CreateBitmapFromWicBitmap1(p, a, b, c)
#define ID2D1DeviceContext2_CreateColorContext(p, a, b, c, d) (p)->lpVtbl->CreateColorContext(p, a, b, c, d)
#define ID2D1DeviceContext2_CreateColorContextFromFilename(p, a, b) (p)->lpVtbl->CreateColorContextFromFilename(p, a, b)
#define ID2D1DeviceContext2_CreateColorContextFromWicColorContext(p, a, b) (p)->lpVtbl->CreateColorContextFromWicColorContext(p, a, b)
#define ID2D1DeviceContext2_CreateBitmapFromDxgiSurface(p, a, b, c) (p)->lpVtbl->CreateBitmapFromDxgiSurface(p, a, b, c)
#define ID2D1DeviceContext2_CreateEffect(p, a, b) (p)->lpVtbl->CreateEffect(p, a, b)
#define ID2D1DeviceContext2_CreateGradientStopCollection1(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateGradientStopCollection1(p, a, b, c, d, e, f, g, h)
#define ID2D1DeviceContext2_CreateImageBrush(p, a, b, c, d) (p)->lpVtbl->CreateImageBrush(p, a, b, c, d)
#define ID2D1DeviceContext2_CreateBitmapBrush1(p, a, b, c, d) (p)->lpVtbl->CreateBitmapBrush1(p, a, b, c, d)
#define ID2D1DeviceContext2_CreateCommandList(p, a) (p)->lpVtbl->CreateCommandList(p, a)
#define ID2D1DeviceContext2_IsDxgiFormatSupported(p, a) (p)->lpVtbl->IsDxgiFormatSupported(p, a)
#define ID2D1DeviceContext2_IsBufferPrecisionSupported(p, a) (p)->lpVtbl->IsBufferPrecisionSupported(p, a)
#define ID2D1DeviceContext2_GetImageLocalBounds(p, a, b) (p)->lpVtbl->GetImageLocalBounds(p, a, b)
#define ID2D1DeviceContext2_GetImageWorldBounds(p, a, b) (p)->lpVtbl->GetImageWorldBounds(p, a, b)
#define ID2D1DeviceContext2_GetGlyphRunWorldBounds(p, a, b, c, d) (p)->lpVtbl->GetGlyphRunWorldBounds(p, a, b, c, d)
#define ID2D1DeviceContext2_GetDevice(p, a) (p)->lpVtbl->GetDevice(p, a)
#define ID2D1DeviceContext2_SetTarget(p, a) (p)->lpVtbl->SetTarget(p, a)
#define ID2D1DeviceContext2_GetTarget(p, a) (p)->lpVtbl->GetTarget(p, a)
#define ID2D1DeviceContext2_SetRenderingControls(p, a) (p)->lpVtbl->SetRenderingControls(p, a)
#define ID2D1DeviceContext2_GetRenderingControls(p, a) (p)->lpVtbl->GetRenderingControls(p, a)
#define ID2D1DeviceContext2_SetPrimitiveBlend(p, a) (p)->lpVtbl->SetPrimitiveBlend(p, a)
#define ID2D1DeviceContext2_GetPrimitiveBlend(p, a) (p)->lpVtbl->GetPrimitiveBlend(p, a)
#define ID2D1DeviceContext2_SetUnitMode(p, a) (p)->lpVtbl->SetUnitMode(p, a)
#define ID2D1DeviceContext2_GetUnitMode(p, a) (p)->lpVtbl->GetUnitMode(p, a)
#define ID2D1DeviceContext2_DrawGlyphRun1(p, a, b, c, d, e) (p)->lpVtbl->DrawGlyphRun1(p, a, b, c, d, e)
#define ID2D1DeviceContext2_DrawImage(p, a, b, c, d, e) (p)->lpVtbl->DrawImage(p, a, b, c, d, e)
#define ID2D1DeviceContext2_DrawGdiMetafile(p, a, b) (p)->lpVtbl->DrawGdiMetafile(p, a, b)
#define ID2D1DeviceContext2_DrawBitmap1(p, a, b, c, d, e, f) (p)->lpVtbl->DrawBitmap1(p, a, b, c, d, e, f)
#define ID2D1DeviceContext2_InvalidateEffectInputRectangle(p, a, b, c) (p)->lpVtbl->InvalidateEffectInputRectangle(p, a, b, c)
#define ID2D1DeviceContext2_GetEffectInvalidRectangleCount(p, a, b) (p)->lpVtbl->GetEffectInvalidRectangleCount(p, a, b)
#define ID2D1DeviceContext2_GetEffectInvalidRectangles(p, a, b, c) (p)->lpVtbl->GetEffectInvalidRectangles(p, a, b, c)
#define ID2D1DeviceContext2_GetEffectRequiredInputRectangles(p, a, b, c, d, e) (p)->lpVtbl->GetEffectRequiredInputRectangles(p, a, b, c, d, e)
#define ID2D1DeviceContext2_FillOpacityMask1(p, a, b, c, d, e) (p)->lpVtbl->FillOpacityMask1(p, a, b, c, d, e)
#define ID2D1DeviceContext2_PushLayer1(p, a, b) (p)->lpVtbl->PushLayer1(p, a, b)
#define ID2D1DeviceContext2_CreateFilledGeometryRealization(p, a, b, c) (p)->lpVtbl->CreateFilledGeometryRealization(p, a, b, c)
#define ID2D1DeviceContext2_CreateStrokedGeometryRealization(p, a, b, c, d, e) (p)->lpVtbl->CreateStrokedGeometryRealization(p, a, b, c, d, e)
#define ID2D1DeviceContext2_DrawGeometryRealization(p, a, b) (p)->lpVtbl->DrawGeometryRealization(p, a, b)
#define ID2D1DeviceContext2_CreateInk(p, a, b) (p)->lpVtbl->CreateInk(p, a, b)
#define ID2D1DeviceContext2_CreateInkStyle(p, a, b) (p)->lpVtbl->CreateInkStyle(p, a, b)
#define ID2D1DeviceContext2_CreateGradientMesh(p, a, b, c) (p)->lpVtbl->CreateGradientMesh(p, a, b, c)
#define ID2D1DeviceContext2_CreateImageSourceFromWic(p, a, b, c, d) (p)->lpVtbl->CreateImageSourceFromWic(p, a, b, c, d)
#define ID2D1DeviceContext2_CreateLookupTable3D(p, a, b, c, d, e, f) (p)->lpVtbl->CreateLookupTable3D(p, a, b, c, d, e, f)
#define ID2D1DeviceContext2_CreateImageSourceFromDxgi(p, a, b, c, d, e) (p)->lpVtbl->CreateImageSourceFromDxgi(p, a, b, c, d, e)
#define ID2D1DeviceContext2_GetGradientMeshWorldBounds(p, a, b) (p)->lpVtbl->GetGradientMeshWorldBounds(p, a, b)
#define ID2D1DeviceContext2_DrawInk(p, a, b, c) (p)->lpVtbl->DrawInk(p, a, b, c)
#define ID2D1DeviceContext2_DrawGradientMesh(p, a) (p)->lpVtbl->DrawGradientMesh(p, a)
#define ID2D1DeviceContext2_DrawGdiMetafile1(p, a, b, c) (p)->lpVtbl->DrawGdiMetafile1(p, a, b, c)
#define ID2D1DeviceContext2_CreateTransformedImageSource(p, a, b, c) (p)->lpVtbl->CreateTransformedImageSource(p, a, b, c)

' ============================================================================
' ID2D1DeviceContext3
' ============================================================================
Type ID2D1DeviceContext3Vtbl As ID2D1DeviceContext3Vtbl_
Type ID2D1DeviceContext3
    lpVtbl As ID2D1DeviceContext3Vtbl Ptr
End Type
Type ID2D1DeviceContext3Vtbl_     '' Extends ID2D1DeviceContext2Vtbl_
    QueryInterface As Function(ByVal This As ID2D1DeviceContext3 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1DeviceContext3 Ptr) As ULong
    Release As Function(ByVal This As ID2D1DeviceContext3 Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal factory As Any Ptr Ptr)
        ' 4.   (ID2D1Resource: GetFactory)
    CreateBitmap As Function(ByVal This As ID2D1DeviceContext3 Ptr, ByVal size As D2D1_SIZE_U, ByVal srcData As Any Ptr, ByVal pitch As ULong, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapFromWicBitmap As Function(ByVal This As ID2D1DeviceContext3 Ptr, ByVal wicBitmapSource As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateSharedBitmap As Function(ByVal This As ID2D1DeviceContext3 Ptr, ByVal riid As GUID Ptr, ByVal data As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapBrush As Function(ByVal This As ID2D1DeviceContext3 Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal bitmapBrushProperties As D2D1_BITMAP_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal bitmapBrush As ID2D1BitmapBrush Ptr Ptr) As HRESULT
    CreateSolidColorBrush As Function(ByVal This As ID2D1DeviceContext3 Ptr, ByVal color As D2D1_COLOR_F Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal solidColorBrush As ID2D1SolidColorBrush Ptr Ptr) As HRESULT
    CreateGradientStopCollection As Function(ByVal This As ID2D1DeviceContext3 Ptr, ByVal gradientStops As D2D1_GRADIENT_STOP Ptr, ByVal gradientStopsCount As ULong, ByVal colorInterpolationGamma As D2D1_GAMMA, ByVal extendMode As D2D1_EXTEND_MODE, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr Ptr) As HRESULT
    CreateLinearGradientBrush As Function(ByVal This As ID2D1DeviceContext3 Ptr, ByVal linearGradientBrushProperties As D2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal linearGradientBrush As ID2D1LinearGradientBrush Ptr Ptr) As HRESULT
    CreateRadialGradientBrush As Function(ByVal This As ID2D1DeviceContext3 Ptr, ByVal radialGradientBrushProperties As D2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal radialGradientBrush As ID2D1RadialGradientBrush Ptr Ptr) As HRESULT
    CreateCompatibleRenderTarget As Function(ByVal This As ID2D1DeviceContext3 Ptr, ByVal desiredSize As D2D1_SIZE_F Ptr, ByVal desiredPixelSize As D2D1_SIZE_U Ptr, ByVal desiredFormat As D2D1_PIXEL_FORMAT Ptr, ByVal options As ULong, ByVal bitmapRenderTarget As Any Ptr Ptr) As HRESULT 'ID2D1BitmapRenderTarget
    CreateLayer As Function(ByVal This As ID2D1DeviceContext3 Ptr, ByVal size As D2D1_SIZE_F Ptr, ByVal layer As ID2D1Layer Ptr Ptr) As HRESULT
    CreateMesh As Function(ByVal This As ID2D1DeviceContext3 Ptr, ByVal mesh As ID2D1Mesh Ptr Ptr) As HRESULT
    DrawLine As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal p0 As D2D1_POINT_2F, ByVal p1 As D2D1_POINT_2F, ByVal brush As ID2D1SolidColorBrush Ptr, ByVal strokeWidth As Single = 0, ByVal strokeStyle As ID2D1StrokeStyle Ptr = NULL)
    DrawRectangle As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRectangle As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawRoundedRectangle As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRoundedRectangle As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawEllipse As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillEllipse As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawGeometry As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillGeometry As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal opacityBrush As ID2D1Brush Ptr)
    FillMesh As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal mesh As ID2D1Mesh Ptr, ByVal brush As ID2D1Brush Ptr)
    FillOpacityMask As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal mask As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal content As D2D1_OPACITY_MASK_CONTENT, ByVal destRect As D2D1_RECT_F Ptr, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawBitmap As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal destRect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolationMode As D2D1_BITMAP_INTERPOLATION_MODE, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawText As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal text As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal layoutRect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS = 0, ByVal measuringMode As DWRITE_MEASURING_MODE = 0)
    DrawTextLayout As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal origin As D2D1_POINT_2F Ptr, ByVal layout As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS)
    DrawGlyphRun As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal baselineOrigin As D2D1_POINT_2F Ptr, ByVal glyphRun As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE)
    SetTransform As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    GetTransform As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    SetAntialiasMode As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    GetAntialiasMode As Function(ByVal This As ID2D1DeviceContext3 Ptr) As D2D1_ANTIALIAS_MODE
    SetTextAntialiasMode As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal antialiasMode As D2D1_TEXT_ANTIALIAS_MODE)
    GetTextAntialiasMode As Function(ByVal This As ID2D1DeviceContext3 Ptr) As D2D1_TEXT_ANTIALIAS_MODE
    SetTextRenderingParams As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal params As Any Ptr)
    GetTextRenderingParams As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal params As Any Ptr Ptr)
    SetTags As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal tag1 As D2D1_TAG, ByVal tag2 As D2D1_TAG)
    GetTags As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr)
    PushLayer As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal layerParams As D2D1_LAYER_PARAMETERS Ptr, ByVal layer As ID2D1Layer Ptr)
    PopLayer As Sub(ByVal This As ID2D1DeviceContext3 Ptr)
    Flush As Function(ByVal This As ID2D1DeviceContext3 Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    SaveDrawingState As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal stateBlock As Any Ptr)
    RestoreDrawingState As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal stateBlock As Any Ptr)
    PushAxisAlignedClip As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    PopAxisAlignedClip As Sub(ByVal This As ID2D1DeviceContext3 Ptr)
    Clear As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal col As D2D1_COLOR_F Ptr)
    BeginDraw As Sub(ByVal This As ID2D1DeviceContext3 Ptr)
    EndDraw As Function(ByVal This As ID2D1DeviceContext3 Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    GetPixelFormat As Function(ByVal This As ID2D1DeviceContext3 Ptr) As D2D1_PIXEL_FORMAT
    SetDpi As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal dpiX As Single, ByVal dpiY As Single)
    GetDpi As Sub(ByVal This As ID2D1DeviceContext3 Ptr, ByVal dpiX As Single Ptr, ByVal dpiY As Single Ptr)
    GetSize As Function(ByVal This As ID2D1DeviceContext3 Ptr, ByVal size As Any Ptr) As D2D1_SIZE_F
    GetPixelSize As Function(ByVal This As ID2D1DeviceContext3 Ptr, ByVal pixelSize As Any Ptr) As D2D1_SIZE_U
    GetMaximumBitmapSize As Function(ByVal This As ID2D1DeviceContext3 Ptr) As ULong
    IsSupported As Function(ByVal This As ID2D1DeviceContext3 Ptr, ByVal renderTargetProperties As D2D1_RENDER_TARGET_PROPERTIES Ptr) As BOOL
        ' Erbt alle Methoden von ID2D1RenderTarget (1-57)
    	' 58. CreateBitmap (überladen)
    CreateBitmap1 As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal size As D2D1_SIZE_U, ByVal src_data As Any Ptr, ByVal pitch As ULong, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As Any Ptr Ptr ) As HRESULT
    	' 59. CreateBitmapFromWicBitmap (überladen)
    CreateBitmapFromWicBitmap1 As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal bitmap_source As IUnknownBase Ptr, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As ID2D1Bitmap1 Ptr Ptr ) As HRESULT
    	' 60. CreateColorContext
    CreateColorContext As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal space As D2D1_COLOR_SPACE, ByVal profile As UByte Ptr, ByVal profile_size As ULong, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 61. CreateColorContextFromFilename
    CreateColorContextFromFilename As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal filename As WString Ptr, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 62. CreateColorContextFromWicColorContext
    CreateColorContextFromWicColorContext As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal wic_color_context As Any Ptr, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 63. CreateBitmapFromDxgiSurface
    CreateBitmapFromDxgiSurface As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal surface As Any Ptr, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As Any Ptr Ptr ) As HRESULT
    	' 64. CreateEffect
    CreateEffect As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByRef effect_id As GUID, ByVal effect As ID2D1Effect Ptr Ptr ) As HRESULT
    	' 65. CreateGradientStopCollection (überladen)
    CreateGradientStopCollection1 As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal stops As D2D1_GRADIENT_STOP Ptr, ByVal stop_count As ULong, ByVal preinterpolation_space As D2D1_COLOR_SPACE, ByVal postinterpolation_space As D2D1_COLOR_SPACE, ByVal buffer_precision As D2D1_BUFFER_PRECISION, ByVal extend_mode As D2D1_EXTEND_MODE, ByVal color_interpolation_mode As D2D1_COLOR_INTERPOLATION_MODE, ByVal gradient As Any Ptr Ptr ) As HRESULT
    	' 66. CreateImageBrush
    CreateImageBrush As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal image As ID2D1Image Ptr, ByVal image_brush_desc As D2D1_IMAGE_BRUSH_PROPERTIES Ptr, ByVal brush_desc As D2D1_BRUSH_PROPERTIES Ptr, ByVal brush As Any Ptr Ptr ) As HRESULT
    	' 67. CreateBitmapBrush (überladen)
    CreateBitmapBrush1 As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal bitmap_brush_desc As D2D1_BITMAP_BRUSH_PROPERTIES1 Ptr, ByVal brush_desc As D2D1_BRUSH_PROPERTIES Ptr, ByVal bitmap_brush As Any Ptr Ptr ) As HRESULT
    	' 68. CreateCommandList
    CreateCommandList As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal command_list As Any Ptr Ptr ) As HRESULT
    	' 69. IsDxgiFormatSupported
    IsDxgiFormatSupported As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal format As ULong ) As Long
    	' 70. IsBufferPrecisionSupported
    IsBufferPrecisionSupported As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal buffer_precision As D2D1_BUFFER_PRECISION ) As Long
    	' 71. GetImageLocalBounds
    GetImageLocalBounds As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal image As ID2D1Image Ptr, ByVal local_bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 72. GetImageWorldBounds
    GetImageWorldBounds As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal image As ID2D1Image Ptr, ByVal world_bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 73. GetGlyphRunWorldBounds
    GetGlyphRunWorldBounds As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal measuring_mode As ULong, ByVal bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 74. GetDevice
    GetDevice As Sub(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal device As Any Ptr Ptr )
    	' 75. SetTarget
    SetTarget As Sub(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal target As ID2D1Image Ptr )
    	' 76. GetTarget
    GetTarget As Sub(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal target As Any Ptr Ptr )
    	' 77. SetRenderingControls
    SetRenderingControls As Sub(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal rendering_controls As D2D1_RENDERING_CONTROLS Ptr )
    	' 78. GetRenderingControls
    GetRenderingControls As Sub(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal rendering_controls As D2D1_RENDERING_CONTROLS Ptr )
    	' 79. SetPrimitiveBlend
    SetPrimitiveBlend As Sub(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal primitive_blend As D2D1_PRIMITIVE_BLEND )
    	' 80. GetPrimitiveBlend
    GetPrimitiveBlend As Function(ByVal This As ID2D1DeviceContext3 Ptr) As D2D1_PRIMITIVE_BLEND
    	' 81. SetUnitMode
    SetUnitMode As Sub(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal unit_mode As D2D1_UNIT_MODE )
    	' 82. GetUnitMode
    GetUnitMode As Function(ByVal This As ID2D1DeviceContext3 Ptr) As D2D1_UNIT_MODE
    	' 83. DrawGlyphRun (überladen)
    DrawGlyphRun1 As Sub(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal glyph_run_desc As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuring_mode As ULong )
    	' 84. DrawImage
    DrawImage As Sub(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal image As ID2D1Image Ptr, ByVal target_offset As D2D1_POINT_2F Ptr = 0, ByVal image_rect As D2D1_RECT_F Ptr = 0, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR, ByVal composite_mode As D2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER )
    	' 85. DrawGdiMetafile
    DrawGdiMetafile As Sub(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal metafile As ID2D1GdiMetafile Ptr, ByVal target_offset As D2D1_POINT_2F Ptr )
    	' 86. DrawBitmap (überladen)
    DrawBitmap1 As Sub(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE, ByVal src_rect As D2D1_RECT_F Ptr, ByVal perspective_transform As D2D1_MATRIX_4X4_F Ptr )
    	' 87. InvalidateEffectInputRectangle
    InvalidateEffectInputRectangle As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal effect As Any Ptr, ByVal input As ULong, ByVal input_rect As D2D1_RECT_F Ptr ) As HRESULT
    	' 88. GetEffectInvalidRectangleCount
    GetEffectInvalidRectangleCount As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal effect As Any Ptr, ByVal rect_count As ULong Ptr ) As HRESULT
    	' 89. GetEffectInvalidRectangles
    GetEffectInvalidRectangles As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal effect As Any Ptr, ByVal rectangles As D2D1_RECT_F Ptr, ByVal rect_count As ULong ) As HRESULT
    	' 90. GetEffectRequiredInputRectangles
    GetEffectRequiredInputRectangles As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal effect As Any Ptr, ByVal image_rect As D2D1_RECT_F Ptr, ByVal desc As D2D1_EFFECT_INPUT_DESCRIPTION Ptr, ByVal input_rects As D2D1_RECT_F Ptr, ByVal input_count As ULong ) As HRESULT
    	' 91. FillOpacityMask (überladen)
    FillOpacityMask1 As Sub(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal mask As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal content As D2D1_OPACITY_MASK_CONTENT, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal src_rect As D2D1_RECT_F Ptr )
    	' 92. PushLayer
    PushLayer1 As Sub(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal layer_parameters As D2D1_LAYER_PARAMETERS1 Ptr, ByVal layer As ID2D1Layer Ptr )
        ' Erbt alle Methoden von ID2D1DeviceContext (1-96 Methoden)
        ' 97. CreateFilledGeometryRealization
    CreateFilledGeometryRealization As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal tolerance As Single, ByVal realization As Any Ptr Ptr ) As HRESULT
        ' 98. CreateStrokedGeometryRealization
    CreateStrokedGeometryRealization As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal tolerance As Single, ByVal stroke_width As Single, ByVal stroke_style As ID2D1StrokeStyle Ptr, ByVal realization As Any Ptr Ptr ) As HRESULT
        ' 99. DrawGeometryRealization
    DrawGeometryRealization As Sub(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal realization As ID2D1GeometryRealization Ptr, ByVal brush As ID2D1Brush Ptr )
        ' Erbt alle Methoden von ID2D1DeviceContext1
        ' Neue Methoden
    CreateInk As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal start_point As D2D1_INK_POINT Ptr, ByVal ink As Any Ptr Ptr ) As HRESULT
    CreateInkStyle As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal ink_style_properties As D2D1_INK_STYLE_PROPERTIES Ptr, ByVal ink_style As Any Ptr Ptr ) As HRESULT
    CreateGradientMesh As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal patches As D2D1_GRADIENT_MESH_PATCH Ptr, ByVal patches_count As ULong, ByVal gradient_mesh As Any Ptr Ptr ) As HRESULT
    CreateImageSourceFromWic As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal wic_bitmap_source As Any Ptr, ByVal loading_options As D2D1_IMAGE_SOURCE_LOADING_OPTIONS, ByVal alpha_mode As D2D1_ALPHA_MODE, ByVal image_source As Any Ptr Ptr ) As HRESULT
    CreateLookupTable3D As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal precision As ULong, ByVal extents As ULong Ptr, ByVal data As UByte Ptr, ByVal data_count As ULong, ByVal strides As ULong Ptr, ByVal lookup_table As Any Ptr Ptr ) As HRESULT
    CreateImageSourceFromDxgi As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal surfaces As Any Ptr Ptr, ByVal surface_count As ULong, ByVal color_space As ULong, ByVal options As D2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS, ByVal image_source As Any Ptr Ptr ) As HRESULT
    GetGradientMeshWorldBounds As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal gradient_mesh As ID2D1GradientMesh Ptr, ByVal bounds As D2D1_RECT_F Ptr ) As HRESULT
    DrawInk As Sub(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal ink As ID2D1Ink Ptr, ByVal brush As ID2D1Brush Ptr, ByVal ink_style As ID2D1InkStyle Ptr )
    DrawGradientMesh As Sub(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal gradient_mesh As ID2D1GradientMesh Ptr )
    DrawGdiMetafile1 As Sub(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal gdi_metafile As Any Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal src_rect As D2D1_RECT_F Ptr )
    CreateTransformedImageSource As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal source As ID2D1ImageSource Ptr, ByVal props As D2D1_TRANSFORMED_IMAGE_SOURCE_PROPERTIES Ptr, ByVal transformed As Any Ptr Ptr ) As HRESULT

        ' Erbt von ID2D1DeviceContext2
    CreateSpriteBatch As Function(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal sprite_batch As Any Ptr Ptr ) As HRESULT
    DrawSpriteBatch As Sub(ByVal This As ID2D1DeviceContext3 Ptr,  ByVal sprite_batch As ID2D1SpriteBatch Ptr, ByVal start_index As ULong, ByVal sprite_count As ULong, ByVal bitmap As ID2D1Bitmap Ptr, ByVal interpolation_mode As D2D1_BITMAP_INTERPOLATION_MODE, ByVal sprite_options As D2D1_SPRITE_OPTIONS )
End Type
#define ID2D1DeviceContext3_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1DeviceContext3_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1DeviceContext3_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1DeviceContext3_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1DeviceContext3_CreateBitmap(p, a, b, c, d, e) (p)->lpVtbl->CreateBitmap(p, a, b, c, d, e)
#define ID2D1DeviceContext3_CreateBitmapFromWicBitmap(p, a, b, c) (p)->lpVtbl->CreateBitmapFromWicBitmap(p, a, b, c)
#define ID2D1DeviceContext3_CreateSharedBitmap(p, a, b, c, d) (p)->lpVtbl->CreateSharedBitmap(p, a, b, c, d)
#define ID2D1DeviceContext3_CreateBitmapBrush(p, a, b, c, d) (p)->lpVtbl->CreateBitmapBrush(p, a, b, c, d)
#define ID2D1DeviceContext3_CreateSolidColorBrush(p, a, b, c) (p)->lpVtbl->CreateSolidColorBrush(p, a, b, c)
#define ID2D1DeviceContext3_CreateGradientStopCollection(p, a, b, c, d, e) (p)->lpVtbl->CreateGradientStopCollection(p, a, b, c, d, e)
#define ID2D1DeviceContext3_CreateLinearGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateLinearGradientBrush(p, a, b, c, d)
#define ID2D1DeviceContext3_CreateRadialGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateRadialGradientBrush(p, a, b, c, d)
#define ID2D1DeviceContext3_CreateCompatibleRenderTarget(p, a, b, c, d, e) (p)->lpVtbl->CreateCompatibleRenderTarget(p, a, b, c, d, e)
#define ID2D1DeviceContext3_CreateLayer(p, a, b) (p)->lpVtbl->CreateLayer(p, a, b)
#define ID2D1DeviceContext3_CreateMesh(p, a) (p)->lpVtbl->CreateMesh(p, a)
#define ID2D1DeviceContext3_DrawLine(p, a, b, c, d, e) (p)->lpVtbl->DrawLine(p, a, b, c, d, e)
#define ID2D1DeviceContext3_DrawRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRectangle(p, a, b, c, d)
#define ID2D1DeviceContext3_FillRectangle(p, a, b) (p)->lpVtbl->FillRectangle(p, a, b)
#define ID2D1DeviceContext3_DrawRoundedRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRoundedRectangle(p, a, b, c, d)
#define ID2D1DeviceContext3_FillRoundedRectangle(p, a, b) (p)->lpVtbl->FillRoundedRectangle(p, a, b)
#define ID2D1DeviceContext3_DrawEllipse(p, a, b, c, d) (p)->lpVtbl->DrawEllipse(p, a, b, c, d)
#define ID2D1DeviceContext3_FillEllipse(p, a, b) (p)->lpVtbl->FillEllipse(p, a, b)
#define ID2D1DeviceContext3_DrawGeometry(p, a, b, c, d) (p)->lpVtbl->DrawGeometry(p, a, b, c, d)
#define ID2D1DeviceContext3_FillGeometry(p, a, b, c) (p)->lpVtbl->FillGeometry(p, a, b, c)
#define ID2D1DeviceContext3_FillMesh(p, a, b) (p)->lpVtbl->FillMesh(p, a, b)
#define ID2D1DeviceContext3_FillOpacityMask(p, a, b, c, d, e) (p)->lpVtbl->FillOpacityMask(p, a, b, c, d, e)
#define ID2D1DeviceContext3_DrawBitmap(p, a, b, c, d, e) (p)->lpVtbl->DrawBitmap(p, a, b, c, d, e)
#define ID2D1DeviceContext3_DrawText(p, a, b, c, d, e, f, g) (p)->lpVtbl->DrawText(p, a, b, c, d, e, f, g)
#define ID2D1DeviceContext3_DrawTextLayout(p, a, b, c, d) (p)->lpVtbl->DrawTextLayout(p, a, b, c, d)
#define ID2D1DeviceContext3_DrawGlyphRun(p, a, b, c, d) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d)
#define ID2D1DeviceContext3_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1DeviceContext3_GetTransform(p, a) (p)->lpVtbl->GetTransform(p, a)
#define ID2D1DeviceContext3_SetAntialiasMode(p, a) (p)->lpVtbl->SetAntialiasMode(p, a)
#define ID2D1DeviceContext3_GetAntialiasMode(p, a) (p)->lpVtbl->GetAntialiasMode(p, a)
#define ID2D1DeviceContext3_SetTextAntialiasMode(p, a) (p)->lpVtbl->SetTextAntialiasMode(p, a)
#define ID2D1DeviceContext3_GetTextAntialiasMode(p, a) (p)->lpVtbl->GetTextAntialiasMode(p, a)
#define ID2D1DeviceContext3_SetTextRenderingParams(p, a) (p)->lpVtbl->SetTextRenderingParams(p, a)
#define ID2D1DeviceContext3_GetTextRenderingParams(p, a) (p)->lpVtbl->GetTextRenderingParams(p, a)
#define ID2D1DeviceContext3_SetTags(p, a, b) (p)->lpVtbl->SetTags(p, a, b)
#define ID2D1DeviceContext3_GetTags(p, a, b) (p)->lpVtbl->GetTags(p, a, b)
#define ID2D1DeviceContext3_PushLayer(p, a, b) (p)->lpVtbl->PushLayer(p, a, b)
#define ID2D1DeviceContext3_PopLayer(p, a) (p)->lpVtbl->PopLayer(p, a)
#define ID2D1DeviceContext3_Flush(p, a, b) (p)->lpVtbl->Flush(p, a, b)
#define ID2D1DeviceContext3_SaveDrawingState(p, a) (p)->lpVtbl->SaveDrawingState(p, a)
#define ID2D1DeviceContext3_RestoreDrawingState(p, a) (p)->lpVtbl->RestoreDrawingState(p, a)
#define ID2D1DeviceContext3_PushAxisAlignedClip(p, a, b) (p)->lpVtbl->PushAxisAlignedClip(p, a, b)
#define ID2D1DeviceContext3_PopAxisAlignedClip(p, a) (p)->lpVtbl->PopAxisAlignedClip(p, a)
#define ID2D1DeviceContext3_Clear(p, a) (p)->lpVtbl->Clear(p, a)
#define ID2D1DeviceContext3_BeginDraw(p, a) (p)->lpVtbl->BeginDraw(p, a)
#define ID2D1DeviceContext3_EndDraw(p, a, b) (p)->lpVtbl->EndDraw(p, a, b)
#define ID2D1DeviceContext3_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)
#define ID2D1DeviceContext3_SetDpi(p, a, b) (p)->lpVtbl->SetDpi(p, a, b)
#define ID2D1DeviceContext3_GetDpi(p, a, b) (p)->lpVtbl->GetDpi(p, a, b)
#define ID2D1DeviceContext3_GetSize(p, a) (p)->lpVtbl->GetSize(p, a)
#define ID2D1DeviceContext3_GetPixelSize(p, a) (p)->lpVtbl->GetPixelSize(p, a)
#define ID2D1DeviceContext3_GetMaximumBitmapSize(p, a) (p)->lpVtbl->GetMaximumBitmapSize(p, a)
#define ID2D1DeviceContext3_IsSupported(p, a) (p)->lpVtbl->IsSupported(p, a)
#define ID2D1DeviceContext3_CreateBitmap1(p, a, b, c, d, e) (p)->lpVtbl->CreateBitmap1(p, a, b, c, d, e)
#define ID2D1DeviceContext3_CreateBitmapFromWicBitmap1(p, a, b, c) (p)->lpVtbl->CreateBitmapFromWicBitmap1(p, a, b, c)
#define ID2D1DeviceContext3_CreateColorContext(p, a, b, c, d) (p)->lpVtbl->CreateColorContext(p, a, b, c, d)
#define ID2D1DeviceContext3_CreateColorContextFromFilename(p, a, b) (p)->lpVtbl->CreateColorContextFromFilename(p, a, b)
#define ID2D1DeviceContext3_CreateColorContextFromWicColorContext(p, a, b) (p)->lpVtbl->CreateColorContextFromWicColorContext(p, a, b)
#define ID2D1DeviceContext3_CreateBitmapFromDxgiSurface(p, a, b, c) (p)->lpVtbl->CreateBitmapFromDxgiSurface(p, a, b, c)
#define ID2D1DeviceContext3_CreateEffect(p, a, b) (p)->lpVtbl->CreateEffect(p, a, b)
#define ID2D1DeviceContext3_CreateGradientStopCollection1(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateGradientStopCollection1(p, a, b, c, d, e, f, g, h)
#define ID2D1DeviceContext3_CreateImageBrush(p, a, b, c, d) (p)->lpVtbl->CreateImageBrush(p, a, b, c, d)
#define ID2D1DeviceContext3_CreateBitmapBrush1(p, a, b, c, d) (p)->lpVtbl->CreateBitmapBrush1(p, a, b, c, d)
#define ID2D1DeviceContext3_CreateCommandList(p, a) (p)->lpVtbl->CreateCommandList(p, a)
#define ID2D1DeviceContext3_IsDxgiFormatSupported(p, a) (p)->lpVtbl->IsDxgiFormatSupported(p, a)
#define ID2D1DeviceContext3_IsBufferPrecisionSupported(p, a) (p)->lpVtbl->IsBufferPrecisionSupported(p, a)
#define ID2D1DeviceContext3_GetImageLocalBounds(p, a, b) (p)->lpVtbl->GetImageLocalBounds(p, a, b)
#define ID2D1DeviceContext3_GetImageWorldBounds(p, a, b) (p)->lpVtbl->GetImageWorldBounds(p, a, b)
#define ID2D1DeviceContext3_GetGlyphRunWorldBounds(p, a, b, c, d) (p)->lpVtbl->GetGlyphRunWorldBounds(p, a, b, c, d)
#define ID2D1DeviceContext3_GetDevice(p, a) (p)->lpVtbl->GetDevice(p, a)
#define ID2D1DeviceContext3_SetTarget(p, a) (p)->lpVtbl->SetTarget(p, a)
#define ID2D1DeviceContext3_GetTarget(p, a) (p)->lpVtbl->GetTarget(p, a)
#define ID2D1DeviceContext3_SetRenderingControls(p, a) (p)->lpVtbl->SetRenderingControls(p, a)
#define ID2D1DeviceContext3_GetRenderingControls(p, a) (p)->lpVtbl->GetRenderingControls(p, a)
#define ID2D1DeviceContext3_SetPrimitiveBlend(p, a) (p)->lpVtbl->SetPrimitiveBlend(p, a)
#define ID2D1DeviceContext3_GetPrimitiveBlend(p, a) (p)->lpVtbl->GetPrimitiveBlend(p, a)
#define ID2D1DeviceContext3_SetUnitMode(p, a) (p)->lpVtbl->SetUnitMode(p, a)
#define ID2D1DeviceContext3_GetUnitMode(p, a) (p)->lpVtbl->GetUnitMode(p, a)
#define ID2D1DeviceContext3_DrawGlyphRun1(p, a, b, c, d, e) (p)->lpVtbl->DrawGlyphRun1(p, a, b, c, d, e)
#define ID2D1DeviceContext3_DrawImage(p, a, b, c, d, e) (p)->lpVtbl->DrawImage(p, a, b, c, d, e)
#define ID2D1DeviceContext3_DrawGdiMetafile(p, a, b) (p)->lpVtbl->DrawGdiMetafile(p, a, b)
#define ID2D1DeviceContext3_DrawBitmap1(p, a, b, c, d, e, f) (p)->lpVtbl->DrawBitmap1(p, a, b, c, d, e, f)
#define ID2D1DeviceContext3_InvalidateEffectInputRectangle(p, a, b, c) (p)->lpVtbl->InvalidateEffectInputRectangle(p, a, b, c)
#define ID2D1DeviceContext3_GetEffectInvalidRectangleCount(p, a, b) (p)->lpVtbl->GetEffectInvalidRectangleCount(p, a, b)
#define ID2D1DeviceContext3_GetEffectInvalidRectangles(p, a, b, c) (p)->lpVtbl->GetEffectInvalidRectangles(p, a, b, c)
#define ID2D1DeviceContext3_GetEffectRequiredInputRectangles(p, a, b, c, d, e) (p)->lpVtbl->GetEffectRequiredInputRectangles(p, a, b, c, d, e)
#define ID2D1DeviceContext3_FillOpacityMask1(p, a, b, c, d, e) (p)->lpVtbl->FillOpacityMask1(p, a, b, c, d, e)
#define ID2D1DeviceContext3_PushLayer1(p, a, b) (p)->lpVtbl->PushLayer1(p, a, b)
#define ID2D1DeviceContext3_CreateFilledGeometryRealization(p, a, b, c) (p)->lpVtbl->CreateFilledGeometryRealization(p, a, b, c)
#define ID2D1DeviceContext3_CreateStrokedGeometryRealization(p, a, b, c, d, e) (p)->lpVtbl->CreateStrokedGeometryRealization(p, a, b, c, d, e)
#define ID2D1DeviceContext3_DrawGeometryRealization(p, a, b) (p)->lpVtbl->DrawGeometryRealization(p, a, b)
#define ID2D1DeviceContext3_CreateInk(p, a, b) (p)->lpVtbl->CreateInk(p, a, b)
#define ID2D1DeviceContext3_CreateInkStyle(p, a, b) (p)->lpVtbl->CreateInkStyle(p, a, b)
#define ID2D1DeviceContext3_CreateGradientMesh(p, a, b, c) (p)->lpVtbl->CreateGradientMesh(p, a, b, c)
#define ID2D1DeviceContext3_CreateImageSourceFromWic(p, a, b, c, d) (p)->lpVtbl->CreateImageSourceFromWic(p, a, b, c, d)
#define ID2D1DeviceContext3_CreateLookupTable3D(p, a, b, c, d, e, f) (p)->lpVtbl->CreateLookupTable3D(p, a, b, c, d, e, f)
#define ID2D1DeviceContext3_CreateImageSourceFromDxgi(p, a, b, c, d, e) (p)->lpVtbl->CreateImageSourceFromDxgi(p, a, b, c, d, e)
#define ID2D1DeviceContext3_GetGradientMeshWorldBounds(p, a, b) (p)->lpVtbl->GetGradientMeshWorldBounds(p, a, b)
#define ID2D1DeviceContext3_DrawInk(p, a, b, c) (p)->lpVtbl->DrawInk(p, a, b, c)
#define ID2D1DeviceContext3_DrawGradientMesh(p, a) (p)->lpVtbl->DrawGradientMesh(p, a)
#define ID2D1DeviceContext3_DrawGdiMetafile1(p, a, b, c) (p)->lpVtbl->DrawGdiMetafile1(p, a, b, c)
#define ID2D1DeviceContext3_CreateTransformedImageSource(p, a, b, c) (p)->lpVtbl->CreateTransformedImageSource(p, a, b, c)
#define ID2D1DeviceContext3_CreateSpriteBatch(p, a) (p)->lpVtbl->CreateSpriteBatch(p, a)
#define ID2D1DeviceContext3_DrawSpriteBatch(p, a, b, c, d, e, f) (p)->lpVtbl->DrawSpriteBatch(p, a, b, c, d, e, f)

' ============================================================================
' ID2D1DeviceContext4
' ============================================================================
Type ID2D1DeviceContext4Vtbl As ID2D1DeviceContext4Vtbl_
Type ID2D1DeviceContext4
    lpVtbl As ID2D1DeviceContext4Vtbl Ptr
End Type
Type ID2D1DeviceContext4Vtbl_     '' Extends ID2D1DeviceContext3Vtbl_
    QueryInterface As Function(ByVal This As ID2D1DeviceContext4 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1DeviceContext4 Ptr) As ULong
    Release As Function(ByVal This As ID2D1DeviceContext4 Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal factory As Any Ptr Ptr)
        ' 4.   (ID2D1Resource: GetFactory)
    CreateBitmap As Function(ByVal This As ID2D1DeviceContext4 Ptr, ByVal size As D2D1_SIZE_U, ByVal srcData As Any Ptr, ByVal pitch As ULong, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapFromWicBitmap As Function(ByVal This As ID2D1DeviceContext4 Ptr, ByVal wicBitmapSource As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateSharedBitmap As Function(ByVal This As ID2D1DeviceContext4 Ptr, ByVal riid As GUID Ptr, ByVal data As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapBrush As Function(ByVal This As ID2D1DeviceContext4 Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal bitmapBrushProperties As D2D1_BITMAP_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal bitmapBrush As ID2D1BitmapBrush Ptr Ptr) As HRESULT
    CreateSolidColorBrush As Function(ByVal This As ID2D1DeviceContext4 Ptr, ByVal color As D2D1_COLOR_F Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal solidColorBrush As ID2D1SolidColorBrush Ptr Ptr) As HRESULT
    CreateGradientStopCollection As Function(ByVal This As ID2D1DeviceContext4 Ptr, ByVal gradientStops As D2D1_GRADIENT_STOP Ptr, ByVal gradientStopsCount As ULong, ByVal colorInterpolationGamma As D2D1_GAMMA, ByVal extendMode As D2D1_EXTEND_MODE, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr Ptr) As HRESULT
    CreateLinearGradientBrush As Function(ByVal This As ID2D1DeviceContext4 Ptr, ByVal linearGradientBrushProperties As D2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal linearGradientBrush As ID2D1LinearGradientBrush Ptr Ptr) As HRESULT
    CreateRadialGradientBrush As Function(ByVal This As ID2D1DeviceContext4 Ptr, ByVal radialGradientBrushProperties As D2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal radialGradientBrush As ID2D1RadialGradientBrush Ptr Ptr) As HRESULT
    CreateCompatibleRenderTarget As Function(ByVal This As ID2D1DeviceContext4 Ptr, ByVal desiredSize As D2D1_SIZE_F Ptr, ByVal desiredPixelSize As D2D1_SIZE_U Ptr, ByVal desiredFormat As D2D1_PIXEL_FORMAT Ptr, ByVal options As ULong, ByVal bitmapRenderTarget As Any Ptr Ptr) As HRESULT 'ID2D1BitmapRenderTarget
    CreateLayer As Function(ByVal This As ID2D1DeviceContext4 Ptr, ByVal size As D2D1_SIZE_F Ptr, ByVal layer As ID2D1Layer Ptr Ptr) As HRESULT
    CreateMesh As Function(ByVal This As ID2D1DeviceContext4 Ptr, ByVal mesh As ID2D1Mesh Ptr Ptr) As HRESULT
    DrawLine As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal p0 As D2D1_POINT_2F, ByVal p1 As D2D1_POINT_2F, ByVal brush As ID2D1SolidColorBrush Ptr, ByVal strokeWidth As Single = 0, ByVal strokeStyle As ID2D1StrokeStyle Ptr = NULL)
    DrawRectangle As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRectangle As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawRoundedRectangle As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRoundedRectangle As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawEllipse As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillEllipse As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawGeometry As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillGeometry As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal opacityBrush As ID2D1Brush Ptr)
    FillMesh As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal mesh As ID2D1Mesh Ptr, ByVal brush As ID2D1Brush Ptr)
    FillOpacityMask As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal mask As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal content As D2D1_OPACITY_MASK_CONTENT, ByVal destRect As D2D1_RECT_F Ptr, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawBitmap As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal destRect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolationMode As D2D1_BITMAP_INTERPOLATION_MODE, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawText As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal text As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal layoutRect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS = 0, ByVal measuringMode As DWRITE_MEASURING_MODE = 0)
    DrawTextLayout As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal origin As D2D1_POINT_2F Ptr, ByVal layout As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS)
    DrawGlyphRun As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal baselineOrigin As D2D1_POINT_2F Ptr, ByVal glyphRun As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE)
    SetTransform As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    GetTransform As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    SetAntialiasMode As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    GetAntialiasMode As Function(ByVal This As ID2D1DeviceContext4 Ptr) As D2D1_ANTIALIAS_MODE
    SetTextAntialiasMode As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal antialiasMode As D2D1_TEXT_ANTIALIAS_MODE)
    GetTextAntialiasMode As Function(ByVal This As ID2D1DeviceContext4 Ptr) As D2D1_TEXT_ANTIALIAS_MODE
    SetTextRenderingParams As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal params As Any Ptr)
    GetTextRenderingParams As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal params As Any Ptr Ptr)
    SetTags As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal tag1 As D2D1_TAG, ByVal tag2 As D2D1_TAG)
    GetTags As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr)
    PushLayer As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal layerParams As D2D1_LAYER_PARAMETERS Ptr, ByVal layer As ID2D1Layer Ptr)
    PopLayer As Sub(ByVal This As ID2D1DeviceContext4 Ptr)
    Flush As Function(ByVal This As ID2D1DeviceContext4 Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    SaveDrawingState As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal stateBlock As Any Ptr)
    RestoreDrawingState As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal stateBlock As Any Ptr)
    PushAxisAlignedClip As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    PopAxisAlignedClip As Sub(ByVal This As ID2D1DeviceContext4 Ptr)
    Clear As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal col As D2D1_COLOR_F Ptr)
    BeginDraw As Sub(ByVal This As ID2D1DeviceContext4 Ptr)
    EndDraw As Function(ByVal This As ID2D1DeviceContext4 Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    GetPixelFormat As Function(ByVal This As ID2D1DeviceContext4 Ptr) As D2D1_PIXEL_FORMAT
    SetDpi As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal dpiX As Single, ByVal dpiY As Single)
    GetDpi As Sub(ByVal This As ID2D1DeviceContext4 Ptr, ByVal dpiX As Single Ptr, ByVal dpiY As Single Ptr)
    GetSize As Function(ByVal This As ID2D1DeviceContext4 Ptr, ByVal size As Any Ptr) As D2D1_SIZE_F
    GetPixelSize As Function(ByVal This As ID2D1DeviceContext4 Ptr, ByVal pixelSize As Any Ptr) As D2D1_SIZE_U
    GetMaximumBitmapSize As Function(ByVal This As ID2D1DeviceContext4 Ptr) As ULong
    IsSupported As Function(ByVal This As ID2D1DeviceContext4 Ptr, ByVal renderTargetProperties As D2D1_RENDER_TARGET_PROPERTIES Ptr) As BOOL
        ' Erbt alle Methoden von ID2D1RenderTarget (1-57)
    	' 58. CreateBitmap (überladen)
    CreateBitmap1 As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal size As D2D1_SIZE_U, ByVal src_data As Any Ptr, ByVal pitch As ULong, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As Any Ptr Ptr ) As HRESULT
    	' 59. CreateBitmapFromWicBitmap (überladen)
    CreateBitmapFromWicBitmap1 As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal bitmap_source As IUnknownBase Ptr, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As ID2D1Bitmap1 Ptr Ptr ) As HRESULT
    	' 60. CreateColorContext
    CreateColorContext As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal space As D2D1_COLOR_SPACE, ByVal profile As UByte Ptr, ByVal profile_size As ULong, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 61. CreateColorContextFromFilename
    CreateColorContextFromFilename As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal filename As WString Ptr, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 62. CreateColorContextFromWicColorContext
    CreateColorContextFromWicColorContext As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal wic_color_context As Any Ptr, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 63. CreateBitmapFromDxgiSurface
    CreateBitmapFromDxgiSurface As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal surface As Any Ptr, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As Any Ptr Ptr ) As HRESULT
    	' 64. CreateEffect
    CreateEffect As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByRef effect_id As GUID, ByVal effect As ID2D1Effect Ptr Ptr ) As HRESULT
    	' 65. CreateGradientStopCollection (überladen)
    CreateGradientStopCollection1 As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal stops As D2D1_GRADIENT_STOP Ptr, ByVal stop_count As ULong, ByVal preinterpolation_space As D2D1_COLOR_SPACE, ByVal postinterpolation_space As D2D1_COLOR_SPACE, ByVal buffer_precision As D2D1_BUFFER_PRECISION, ByVal extend_mode As D2D1_EXTEND_MODE, ByVal color_interpolation_mode As D2D1_COLOR_INTERPOLATION_MODE, ByVal gradient As Any Ptr Ptr ) As HRESULT
    	' 66. CreateImageBrush
    CreateImageBrush As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal image As ID2D1Image Ptr, ByVal image_brush_desc As D2D1_IMAGE_BRUSH_PROPERTIES Ptr, ByVal brush_desc As D2D1_BRUSH_PROPERTIES Ptr, ByVal brush As Any Ptr Ptr ) As HRESULT
    	' 67. CreateBitmapBrush (überladen)
    CreateBitmapBrush1 As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal bitmap_brush_desc As D2D1_BITMAP_BRUSH_PROPERTIES1 Ptr, ByVal brush_desc As D2D1_BRUSH_PROPERTIES Ptr, ByVal bitmap_brush As Any Ptr Ptr ) As HRESULT
    	' 68. CreateCommandList
    CreateCommandList As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal command_list As Any Ptr Ptr ) As HRESULT
    	' 69. IsDxgiFormatSupported
    IsDxgiFormatSupported As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal format As ULong ) As Long
    	' 70. IsBufferPrecisionSupported
    IsBufferPrecisionSupported As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal buffer_precision As D2D1_BUFFER_PRECISION ) As Long
    	' 71. GetImageLocalBounds
    GetImageLocalBounds As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal image As ID2D1Image Ptr, ByVal local_bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 72. GetImageWorldBounds
    GetImageWorldBounds As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal image As ID2D1Image Ptr, ByVal world_bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 73. GetGlyphRunWorldBounds
    GetGlyphRunWorldBounds As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal measuring_mode As ULong, ByVal bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 74. GetDevice
    GetDevice As Sub(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal device As Any Ptr Ptr )
    	' 75. SetTarget
    SetTarget As Sub(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal target As ID2D1Image Ptr )
    	' 76. GetTarget
    GetTarget As Sub(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal target As Any Ptr Ptr )
    	' 77. SetRenderingControls
    SetRenderingControls As Sub(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal rendering_controls As D2D1_RENDERING_CONTROLS Ptr )
    	' 78. GetRenderingControls
    GetRenderingControls As Sub(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal rendering_controls As D2D1_RENDERING_CONTROLS Ptr )
    	' 79. SetPrimitiveBlend
    SetPrimitiveBlend As Sub(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal primitive_blend As D2D1_PRIMITIVE_BLEND )
    	' 80. GetPrimitiveBlend
    GetPrimitiveBlend As Function(ByVal This As ID2D1DeviceContext4 Ptr) As D2D1_PRIMITIVE_BLEND
    	' 81. SetUnitMode
    SetUnitMode As Sub(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal unit_mode As D2D1_UNIT_MODE )
    	' 82. GetUnitMode
    GetUnitMode As Function(ByVal This As ID2D1DeviceContext4 Ptr) As D2D1_UNIT_MODE
    	' 83. DrawGlyphRun (überladen)
    DrawGlyphRun1 As Sub(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal glyph_run_desc As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuring_mode As ULong )
    	' 84. DrawImage
    DrawImage As Sub(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal image As ID2D1Image Ptr, ByVal target_offset As D2D1_POINT_2F Ptr = 0, ByVal image_rect As D2D1_RECT_F Ptr = 0, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR, ByVal composite_mode As D2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER )
    	' 85. DrawGdiMetafile
    DrawGdiMetafile As Sub(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal metafile As ID2D1GdiMetafile Ptr, ByVal target_offset As D2D1_POINT_2F Ptr )
    	' 86. DrawBitmap (überladen)
    DrawBitmap1 As Sub(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE, ByVal src_rect As D2D1_RECT_F Ptr, ByVal perspective_transform As D2D1_MATRIX_4X4_F Ptr )
    	' 87. InvalidateEffectInputRectangle
    InvalidateEffectInputRectangle As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal effect As Any Ptr, ByVal input As ULong, ByVal input_rect As D2D1_RECT_F Ptr ) As HRESULT
    	' 88. GetEffectInvalidRectangleCount
    GetEffectInvalidRectangleCount As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal effect As Any Ptr, ByVal rect_count As ULong Ptr ) As HRESULT
    	' 89. GetEffectInvalidRectangles
    GetEffectInvalidRectangles As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal effect As Any Ptr, ByVal rectangles As D2D1_RECT_F Ptr, ByVal rect_count As ULong ) As HRESULT
    	' 90. GetEffectRequiredInputRectangles
    GetEffectRequiredInputRectangles As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal effect As Any Ptr, ByVal image_rect As D2D1_RECT_F Ptr, ByVal desc As D2D1_EFFECT_INPUT_DESCRIPTION Ptr, ByVal input_rects As D2D1_RECT_F Ptr, ByVal input_count As ULong ) As HRESULT
    	' 91. FillOpacityMask (überladen)
    FillOpacityMask1 As Sub(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal mask As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal content As D2D1_OPACITY_MASK_CONTENT, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal src_rect As D2D1_RECT_F Ptr )
    	' 92. PushLayer
    PushLayer1 As Sub(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal layer_parameters As D2D1_LAYER_PARAMETERS1 Ptr, ByVal layer As ID2D1Layer Ptr )
        ' Erbt alle Methoden von ID2D1DeviceContext (1-96 Methoden)
        ' 97. CreateFilledGeometryRealization
    CreateFilledGeometryRealization As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal tolerance As Single, ByVal realization As Any Ptr Ptr ) As HRESULT
        ' 98. CreateStrokedGeometryRealization
    CreateStrokedGeometryRealization As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal tolerance As Single, ByVal stroke_width As Single, ByVal stroke_style As ID2D1StrokeStyle Ptr, ByVal realization As Any Ptr Ptr ) As HRESULT
        ' 99. DrawGeometryRealization
    DrawGeometryRealization As Sub(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal realization As ID2D1GeometryRealization Ptr, ByVal brush As ID2D1Brush Ptr )
        ' Erbt alle Methoden von ID2D1DeviceContext1
        ' Neue Methoden
    CreateInk As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal start_point As D2D1_INK_POINT Ptr, ByVal ink As Any Ptr Ptr ) As HRESULT
    CreateInkStyle As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal ink_style_properties As D2D1_INK_STYLE_PROPERTIES Ptr, ByVal ink_style As Any Ptr Ptr ) As HRESULT
    CreateGradientMesh As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal patches As D2D1_GRADIENT_MESH_PATCH Ptr, ByVal patches_count As ULong, ByVal gradient_mesh As Any Ptr Ptr ) As HRESULT
    CreateImageSourceFromWic As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal wic_bitmap_source As Any Ptr, ByVal loading_options As D2D1_IMAGE_SOURCE_LOADING_OPTIONS, ByVal alpha_mode As D2D1_ALPHA_MODE, ByVal image_source As Any Ptr Ptr ) As HRESULT
    CreateLookupTable3D As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal precision As ULong, ByVal extents As ULong Ptr, ByVal data As UByte Ptr, ByVal data_count As ULong, ByVal strides As ULong Ptr, ByVal lookup_table As Any Ptr Ptr ) As HRESULT
    CreateImageSourceFromDxgi As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal surfaces As Any Ptr Ptr, ByVal surface_count As ULong, ByVal color_space As ULong, ByVal options As D2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS, ByVal image_source As Any Ptr Ptr ) As HRESULT
    GetGradientMeshWorldBounds As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal gradient_mesh As ID2D1GradientMesh Ptr, ByVal bounds As D2D1_RECT_F Ptr ) As HRESULT
    DrawInk As Sub(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal ink As ID2D1Ink Ptr, ByVal brush As ID2D1Brush Ptr, ByVal ink_style As ID2D1InkStyle Ptr )
    DrawGradientMesh As Sub(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal gradient_mesh As ID2D1GradientMesh Ptr )
    DrawGdiMetafile1 As Sub(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal gdi_metafile As Any Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal src_rect As D2D1_RECT_F Ptr )
    CreateTransformedImageSource As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal source As ID2D1ImageSource Ptr, ByVal props As D2D1_TRANSFORMED_IMAGE_SOURCE_PROPERTIES Ptr, ByVal transformed As Any Ptr Ptr ) As HRESULT
        ' Erbt von ID2D1DeviceContext2
    CreateSpriteBatch As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal sprite_batch As Any Ptr Ptr ) As HRESULT
    DrawSpriteBatch As Sub(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal sprite_batch As ID2D1SpriteBatch Ptr, ByVal start_index As ULong, ByVal sprite_count As ULong, ByVal bitmap As ID2D1Bitmap Ptr, ByVal interpolation_mode As D2D1_BITMAP_INTERPOLATION_MODE, ByVal sprite_options As D2D1_SPRITE_OPTIONS )

        ' Erbt von ID2D1DeviceContext3
    CreateSvgGlyphStyle As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal svg_glyph_style As Any Ptr Ptr ) As HRESULT
        ' DrawText - Überladen mit zusätzlichen Parametern
    DrawText1 As Sub(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal string As WString Ptr, ByVal string_length As ULong, ByVal text_format As Any Ptr, ByVal layout_rect As D2D1_RECT_F Ptr, ByVal default_fill_brush As ID2D1Brush Ptr, ByVal svg_glyph_style As ID2D1SvgGlyphStyle Ptr, ByVal color_palette_index As ULong, ByVal options As D2D1_DRAW_TEXT_OPTIONS, ByVal measuring_mode As ULong )
    DrawTextLayout1 As Sub(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal origin As D2D1_POINT_2F, ByVal text_layout As Any Ptr, ByVal default_fill_brush As ID2D1Brush Ptr, ByVal svg_glyph_style As ID2D1SvgGlyphStyle Ptr, ByVal color_palette_index As ULong, ByVal options As D2D1_DRAW_TEXT_OPTIONS )
    DrawColorBitmapGlyphRun As Sub(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal glyph_image_format As ULong, ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal measuring_mode As ULong, ByVal bitmap_snap_option As D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION )
    DrawSvgGlyphRun As Sub(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal default_fill_brush As ID2D1Brush Ptr, ByVal svg_glyph_style As ID2D1SvgGlyphStyle Ptr, ByVal color_palette_index As ULong, ByVal measuring_mode As ULong )
    GetColorBitmapGlyphImage As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal glyph_image_format As ULong, ByVal glyph_origin As D2D1_POINT_2F, ByVal font_face As Any Ptr, ByVal font_em_size As Single, ByVal glyph_index As UShort, ByVal is_sideways As Long, ByVal world_transform As D2D1_MATRIX_3X2_F Ptr, ByVal dpi_x As Single, ByVal dpi_y As Single, ByVal glyph_transform As D2D1_MATRIX_3X2_F Ptr, ByVal glyph_image As Any Ptr Ptr ) As HRESULT
    GetSvgGlyphImage As Function(ByVal This As ID2D1DeviceContext4 Ptr,  ByVal glyph_origin As D2D1_POINT_2F, ByVal font_face As Any Ptr, ByVal font_em_size As Single, ByVal glyph_index As UShort, ByVal is_sideways As Long, ByVal world_transform As D2D1_MATRIX_3X2_F Ptr, ByVal default_fill_brush As ID2D1Brush Ptr, ByVal svg_glyph_style As ID2D1SvgGlyphStyle Ptr, ByVal color_palette_index As ULong, ByVal glyph_transform As D2D1_MATRIX_3X2_F Ptr, ByVal glyph_image As Any Ptr Ptr ) As HRESULT
End Type
#define ID2D1DeviceContext4_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1DeviceContext4_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1DeviceContext4_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1DeviceContext4_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1DeviceContext4_CreateBitmap(p, a, b, c, d, e) (p)->lpVtbl->CreateBitmap(p, a, b, c, d, e)
#define ID2D1DeviceContext4_CreateBitmapFromWicBitmap(p, a, b, c) (p)->lpVtbl->CreateBitmapFromWicBitmap(p, a, b, c)
#define ID2D1DeviceContext4_CreateSharedBitmap(p, a, b, c, d) (p)->lpVtbl->CreateSharedBitmap(p, a, b, c, d)
#define ID2D1DeviceContext4_CreateBitmapBrush(p, a, b, c, d) (p)->lpVtbl->CreateBitmapBrush(p, a, b, c, d)
#define ID2D1DeviceContext4_CreateSolidColorBrush(p, a, b, c) (p)->lpVtbl->CreateSolidColorBrush(p, a, b, c)
#define ID2D1DeviceContext4_CreateGradientStopCollection(p, a, b, c, d, e) (p)->lpVtbl->CreateGradientStopCollection(p, a, b, c, d, e)
#define ID2D1DeviceContext4_CreateLinearGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateLinearGradientBrush(p, a, b, c, d)
#define ID2D1DeviceContext4_CreateRadialGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateRadialGradientBrush(p, a, b, c, d)
#define ID2D1DeviceContext4_CreateCompatibleRenderTarget(p, a, b, c, d, e) (p)->lpVtbl->CreateCompatibleRenderTarget(p, a, b, c, d, e)
#define ID2D1DeviceContext4_CreateLayer(p, a, b) (p)->lpVtbl->CreateLayer(p, a, b)
#define ID2D1DeviceContext4_CreateMesh(p, a) (p)->lpVtbl->CreateMesh(p, a)
#define ID2D1DeviceContext4_DrawLine(p, a, b, c, d, e) (p)->lpVtbl->DrawLine(p, a, b, c, d, e)
#define ID2D1DeviceContext4_DrawRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRectangle(p, a, b, c, d)
#define ID2D1DeviceContext4_FillRectangle(p, a, b) (p)->lpVtbl->FillRectangle(p, a, b)
#define ID2D1DeviceContext4_DrawRoundedRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRoundedRectangle(p, a, b, c, d)
#define ID2D1DeviceContext4_FillRoundedRectangle(p, a, b) (p)->lpVtbl->FillRoundedRectangle(p, a, b)
#define ID2D1DeviceContext4_DrawEllipse(p, a, b, c, d) (p)->lpVtbl->DrawEllipse(p, a, b, c, d)
#define ID2D1DeviceContext4_FillEllipse(p, a, b) (p)->lpVtbl->FillEllipse(p, a, b)
#define ID2D1DeviceContext4_DrawGeometry(p, a, b, c, d) (p)->lpVtbl->DrawGeometry(p, a, b, c, d)
#define ID2D1DeviceContext4_FillGeometry(p, a, b, c) (p)->lpVtbl->FillGeometry(p, a, b, c)
#define ID2D1DeviceContext4_FillMesh(p, a, b) (p)->lpVtbl->FillMesh(p, a, b)
#define ID2D1DeviceContext4_FillOpacityMask(p, a, b, c, d, e) (p)->lpVtbl->FillOpacityMask(p, a, b, c, d, e)
#define ID2D1DeviceContext4_DrawBitmap(p, a, b, c, d, e) (p)->lpVtbl->DrawBitmap(p, a, b, c, d, e)
#define ID2D1DeviceContext4_DrawText(p, a, b, c, d, e, f, g) (p)->lpVtbl->DrawText(p, a, b, c, d, e, f, g)
#define ID2D1DeviceContext4_DrawTextLayout(p, a, b, c, d) (p)->lpVtbl->DrawTextLayout(p, a, b, c, d)
#define ID2D1DeviceContext4_DrawGlyphRun(p, a, b, c, d) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d)
#define ID2D1DeviceContext4_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1DeviceContext4_GetTransform(p, a) (p)->lpVtbl->GetTransform(p, a)
#define ID2D1DeviceContext4_SetAntialiasMode(p, a) (p)->lpVtbl->SetAntialiasMode(p, a)
#define ID2D1DeviceContext4_GetAntialiasMode(p, a) (p)->lpVtbl->GetAntialiasMode(p, a)
#define ID2D1DeviceContext4_SetTextAntialiasMode(p, a) (p)->lpVtbl->SetTextAntialiasMode(p, a)
#define ID2D1DeviceContext4_GetTextAntialiasMode(p, a) (p)->lpVtbl->GetTextAntialiasMode(p, a)
#define ID2D1DeviceContext4_SetTextRenderingParams(p, a) (p)->lpVtbl->SetTextRenderingParams(p, a)
#define ID2D1DeviceContext4_GetTextRenderingParams(p, a) (p)->lpVtbl->GetTextRenderingParams(p, a)
#define ID2D1DeviceContext4_SetTags(p, a, b) (p)->lpVtbl->SetTags(p, a, b)
#define ID2D1DeviceContext4_GetTags(p, a, b) (p)->lpVtbl->GetTags(p, a, b)
#define ID2D1DeviceContext4_PushLayer(p, a, b) (p)->lpVtbl->PushLayer(p, a, b)
#define ID2D1DeviceContext4_PopLayer(p, a) (p)->lpVtbl->PopLayer(p, a)
#define ID2D1DeviceContext4_Flush(p, a, b) (p)->lpVtbl->Flush(p, a, b)
#define ID2D1DeviceContext4_SaveDrawingState(p, a) (p)->lpVtbl->SaveDrawingState(p, a)
#define ID2D1DeviceContext4_RestoreDrawingState(p, a) (p)->lpVtbl->RestoreDrawingState(p, a)
#define ID2D1DeviceContext4_PushAxisAlignedClip(p, a, b) (p)->lpVtbl->PushAxisAlignedClip(p, a, b)
#define ID2D1DeviceContext4_PopAxisAlignedClip(p, a) (p)->lpVtbl->PopAxisAlignedClip(p, a)
#define ID2D1DeviceContext4_Clear(p, a) (p)->lpVtbl->Clear(p, a)
#define ID2D1DeviceContext4_BeginDraw(p, a) (p)->lpVtbl->BeginDraw(p, a)
#define ID2D1DeviceContext4_EndDraw(p, a, b) (p)->lpVtbl->EndDraw(p, a, b)
#define ID2D1DeviceContext4_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)
#define ID2D1DeviceContext4_SetDpi(p, a, b) (p)->lpVtbl->SetDpi(p, a, b)
#define ID2D1DeviceContext4_GetDpi(p, a, b) (p)->lpVtbl->GetDpi(p, a, b)
#define ID2D1DeviceContext4_GetSize(p, a) (p)->lpVtbl->GetSize(p, a)
#define ID2D1DeviceContext4_GetPixelSize(p, a) (p)->lpVtbl->GetPixelSize(p, a)
#define ID2D1DeviceContext4_GetMaximumBitmapSize(p, a) (p)->lpVtbl->GetMaximumBitmapSize(p, a)
#define ID2D1DeviceContext4_IsSupported(p, a) (p)->lpVtbl->IsSupported(p, a)
#define ID2D1DeviceContext4_CreateBitmap1(p, a, b, c, d, e) (p)->lpVtbl->CreateBitmap1(p, a, b, c, d, e)
#define ID2D1DeviceContext4_CreateBitmapFromWicBitmap1(p, a, b, c) (p)->lpVtbl->CreateBitmapFromWicBitmap1(p, a, b, c)
#define ID2D1DeviceContext4_CreateColorContext(p, a, b, c, d) (p)->lpVtbl->CreateColorContext(p, a, b, c, d)
#define ID2D1DeviceContext4_CreateColorContextFromFilename(p, a, b) (p)->lpVtbl->CreateColorContextFromFilename(p, a, b)
#define ID2D1DeviceContext4_CreateColorContextFromWicColorContext(p, a, b) (p)->lpVtbl->CreateColorContextFromWicColorContext(p, a, b)
#define ID2D1DeviceContext4_CreateBitmapFromDxgiSurface(p, a, b, c) (p)->lpVtbl->CreateBitmapFromDxgiSurface(p, a, b, c)
#define ID2D1DeviceContext4_CreateEffect(p, a, b) (p)->lpVtbl->CreateEffect(p, a, b)
#define ID2D1DeviceContext4_CreateGradientStopCollection1(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateGradientStopCollection1(p, a, b, c, d, e, f, g, h)
#define ID2D1DeviceContext4_CreateImageBrush(p, a, b, c, d) (p)->lpVtbl->CreateImageBrush(p, a, b, c, d)
#define ID2D1DeviceContext4_CreateBitmapBrush1(p, a, b, c, d) (p)->lpVtbl->CreateBitmapBrush1(p, a, b, c, d)
#define ID2D1DeviceContext4_CreateCommandList(p, a) (p)->lpVtbl->CreateCommandList(p, a)
#define ID2D1DeviceContext4_IsDxgiFormatSupported(p, a) (p)->lpVtbl->IsDxgiFormatSupported(p, a)
#define ID2D1DeviceContext4_IsBufferPrecisionSupported(p, a) (p)->lpVtbl->IsBufferPrecisionSupported(p, a)
#define ID2D1DeviceContext4_GetImageLocalBounds(p, a, b) (p)->lpVtbl->GetImageLocalBounds(p, a, b)
#define ID2D1DeviceContext4_GetImageWorldBounds(p, a, b) (p)->lpVtbl->GetImageWorldBounds(p, a, b)
#define ID2D1DeviceContext4_GetGlyphRunWorldBounds(p, a, b, c, d) (p)->lpVtbl->GetGlyphRunWorldBounds(p, a, b, c, d)
#define ID2D1DeviceContext4_GetDevice(p, a) (p)->lpVtbl->GetDevice(p, a)
#define ID2D1DeviceContext4_SetTarget(p, a) (p)->lpVtbl->SetTarget(p, a)
#define ID2D1DeviceContext4_GetTarget(p, a) (p)->lpVtbl->GetTarget(p, a)
#define ID2D1DeviceContext4_SetRenderingControls(p, a) (p)->lpVtbl->SetRenderingControls(p, a)
#define ID2D1DeviceContext4_GetRenderingControls(p, a) (p)->lpVtbl->GetRenderingControls(p, a)
#define ID2D1DeviceContext4_SetPrimitiveBlend(p, a) (p)->lpVtbl->SetPrimitiveBlend(p, a)
#define ID2D1DeviceContext4_GetPrimitiveBlend(p, a) (p)->lpVtbl->GetPrimitiveBlend(p, a)
#define ID2D1DeviceContext4_SetUnitMode(p, a) (p)->lpVtbl->SetUnitMode(p, a)
#define ID2D1DeviceContext4_GetUnitMode(p, a) (p)->lpVtbl->GetUnitMode(p, a)
#define ID2D1DeviceContext4_DrawGlyphRun1(p, a, b, c, d, e) (p)->lpVtbl->DrawGlyphRun1(p, a, b, c, d, e)
#define ID2D1DeviceContext4_DrawImage(p, a, b, c, d, e) (p)->lpVtbl->DrawImage(p, a, b, c, d, e)
#define ID2D1DeviceContext4_DrawGdiMetafile(p, a, b) (p)->lpVtbl->DrawGdiMetafile(p, a, b)
#define ID2D1DeviceContext4_DrawBitmap1(p, a, b, c, d, e, f) (p)->lpVtbl->DrawBitmap1(p, a, b, c, d, e, f)
#define ID2D1DeviceContext4_InvalidateEffectInputRectangle(p, a, b, c) (p)->lpVtbl->InvalidateEffectInputRectangle(p, a, b, c)
#define ID2D1DeviceContext4_GetEffectInvalidRectangleCount(p, a, b) (p)->lpVtbl->GetEffectInvalidRectangleCount(p, a, b)
#define ID2D1DeviceContext4_GetEffectInvalidRectangles(p, a, b, c) (p)->lpVtbl->GetEffectInvalidRectangles(p, a, b, c)
#define ID2D1DeviceContext4_GetEffectRequiredInputRectangles(p, a, b, c, d, e) (p)->lpVtbl->GetEffectRequiredInputRectangles(p, a, b, c, d, e)
#define ID2D1DeviceContext4_FillOpacityMask1(p, a, b, c, d, e) (p)->lpVtbl->FillOpacityMask1(p, a, b, c, d, e)
#define ID2D1DeviceContext4_PushLayer1(p, a, b) (p)->lpVtbl->PushLayer1(p, a, b)
#define ID2D1DeviceContext4_CreateFilledGeometryRealization(p, a, b, c) (p)->lpVtbl->CreateFilledGeometryRealization(p, a, b, c)
#define ID2D1DeviceContext4_CreateStrokedGeometryRealization(p, a, b, c, d, e) (p)->lpVtbl->CreateStrokedGeometryRealization(p, a, b, c, d, e)
#define ID2D1DeviceContext4_DrawGeometryRealization(p, a, b) (p)->lpVtbl->DrawGeometryRealization(p, a, b)
#define ID2D1DeviceContext4_CreateInk(p, a, b) (p)->lpVtbl->CreateInk(p, a, b)
#define ID2D1DeviceContext4_CreateInkStyle(p, a, b) (p)->lpVtbl->CreateInkStyle(p, a, b)
#define ID2D1DeviceContext4_CreateGradientMesh(p, a, b, c) (p)->lpVtbl->CreateGradientMesh(p, a, b, c)
#define ID2D1DeviceContext4_CreateImageSourceFromWic(p, a, b, c, d) (p)->lpVtbl->CreateImageSourceFromWic(p, a, b, c, d)
#define ID2D1DeviceContext4_CreateLookupTable3D(p, a, b, c, d, e, f) (p)->lpVtbl->CreateLookupTable3D(p, a, b, c, d, e, f)
#define ID2D1DeviceContext4_CreateImageSourceFromDxgi(p, a, b, c, d, e) (p)->lpVtbl->CreateImageSourceFromDxgi(p, a, b, c, d, e)
#define ID2D1DeviceContext4_GetGradientMeshWorldBounds(p, a, b) (p)->lpVtbl->GetGradientMeshWorldBounds(p, a, b)
#define ID2D1DeviceContext4_DrawInk(p, a, b, c) (p)->lpVtbl->DrawInk(p, a, b, c)
#define ID2D1DeviceContext4_DrawGradientMesh(p, a) (p)->lpVtbl->DrawGradientMesh(p, a)
#define ID2D1DeviceContext4_DrawGdiMetafile1(p, a, b, c) (p)->lpVtbl->DrawGdiMetafile1(p, a, b, c)
#define ID2D1DeviceContext4_CreateTransformedImageSource(p, a, b, c) (p)->lpVtbl->CreateTransformedImageSource(p, a, b, c)
#define ID2D1DeviceContext4_CreateSpriteBatch(p, a) (p)->lpVtbl->CreateSpriteBatch(p, a)
#define ID2D1DeviceContext4_DrawSpriteBatch(p, a, b, c, d, e, f) (p)->lpVtbl->DrawSpriteBatch(p, a, b, c, d, e, f)
#define ID2D1DeviceContext4_CreateSvgGlyphStyle(p, a) (p)->lpVtbl->CreateSvgGlyphStyle(p, a)
#define ID2D1DeviceContext4_DrawText1(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->DrawText1(p, a, b, c, d, e, f, g, h, i)
#define ID2D1DeviceContext4_DrawTextLayout1(p, a, b, c, d, e, f) (p)->lpVtbl->DrawTextLayout1(p, a, b, c, d, e, f)
#define ID2D1DeviceContext4_DrawColorBitmapGlyphRun(p, a, b, c, d, e) (p)->lpVtbl->DrawColorBitmapGlyphRun(p, a, b, c, d, e)
#define ID2D1DeviceContext4_DrawSvgGlyphRun(p, a, b, c, d, e, f) (p)->lpVtbl->DrawSvgGlyphRun(p, a, b, c, d, e, f)
#define ID2D1DeviceContext4_GetColorBitmapGlyphImage(p, a, b, c, d, e, f, g, h, i, j, k) (p)->lpVtbl->GetColorBitmapGlyphImage(p, a, b, c, d, e, f, g, h, i, j, k)
#define ID2D1DeviceContext4_GetSvgGlyphImage(p, a, b, c, d, e, f, g, h, i, j, k) (p)->lpVtbl->GetSvgGlyphImage(p, a, b, c, d, e, f, g, h, i, j, k)

' ============================================================================
' ID2D1DeviceContext5
' ============================================================================
Type ID2D1DeviceContext5Vtbl As ID2D1DeviceContext5Vtbl_
Type ID2D1DeviceContext5
    lpVtbl As ID2D1DeviceContext5Vtbl Ptr
End Type
Type ID2D1DeviceContext5Vtbl_     '' Extends ID2D1DeviceContext4Vtbl_
    QueryInterface As Function(ByVal This As ID2D1DeviceContext5 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1DeviceContext5 Ptr) As ULong
    Release As Function(ByVal This As ID2D1DeviceContext5 Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal factory As Any Ptr Ptr)
        ' 4.   (ID2D1Resource: GetFactory)
    CreateBitmap As Function(ByVal This As ID2D1DeviceContext5 Ptr, ByVal size As D2D1_SIZE_U, ByVal srcData As Any Ptr, ByVal pitch As ULong, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapFromWicBitmap As Function(ByVal This As ID2D1DeviceContext5 Ptr, ByVal wicBitmapSource As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateSharedBitmap As Function(ByVal This As ID2D1DeviceContext5 Ptr, ByVal riid As GUID Ptr, ByVal data As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapBrush As Function(ByVal This As ID2D1DeviceContext5 Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal bitmapBrushProperties As D2D1_BITMAP_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal bitmapBrush As ID2D1BitmapBrush Ptr Ptr) As HRESULT
    CreateSolidColorBrush As Function(ByVal This As ID2D1DeviceContext5 Ptr, ByVal color As D2D1_COLOR_F Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal solidColorBrush As ID2D1SolidColorBrush Ptr Ptr) As HRESULT
    CreateGradientStopCollection As Function(ByVal This As ID2D1DeviceContext5 Ptr, ByVal gradientStops As D2D1_GRADIENT_STOP Ptr, ByVal gradientStopsCount As ULong, ByVal colorInterpolationGamma As D2D1_GAMMA, ByVal extendMode As D2D1_EXTEND_MODE, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr Ptr) As HRESULT
    CreateLinearGradientBrush As Function(ByVal This As ID2D1DeviceContext5 Ptr, ByVal linearGradientBrushProperties As D2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal linearGradientBrush As ID2D1LinearGradientBrush Ptr Ptr) As HRESULT
    CreateRadialGradientBrush As Function(ByVal This As ID2D1DeviceContext5 Ptr, ByVal radialGradientBrushProperties As D2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal radialGradientBrush As ID2D1RadialGradientBrush Ptr Ptr) As HRESULT
    CreateCompatibleRenderTarget As Function(ByVal This As ID2D1DeviceContext5 Ptr, ByVal desiredSize As D2D1_SIZE_F Ptr, ByVal desiredPixelSize As D2D1_SIZE_U Ptr, ByVal desiredFormat As D2D1_PIXEL_FORMAT Ptr, ByVal options As ULong, ByVal bitmapRenderTarget As Any Ptr Ptr) As HRESULT 'ID2D1BitmapRenderTarget
    CreateLayer As Function(ByVal This As ID2D1DeviceContext5 Ptr, ByVal size As D2D1_SIZE_F Ptr, ByVal layer As ID2D1Layer Ptr Ptr) As HRESULT
    CreateMesh As Function(ByVal This As ID2D1DeviceContext5 Ptr, ByVal mesh As ID2D1Mesh Ptr Ptr) As HRESULT
    DrawLine As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal p0 As D2D1_POINT_2F, ByVal p1 As D2D1_POINT_2F, ByVal brush As ID2D1SolidColorBrush Ptr, ByVal strokeWidth As Single = 0, ByVal strokeStyle As ID2D1StrokeStyle Ptr = NULL)
    DrawRectangle As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRectangle As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawRoundedRectangle As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRoundedRectangle As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawEllipse As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillEllipse As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawGeometry As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillGeometry As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal opacityBrush As ID2D1Brush Ptr)
    FillMesh As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal mesh As ID2D1Mesh Ptr, ByVal brush As ID2D1Brush Ptr)
    FillOpacityMask As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal mask As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal content As D2D1_OPACITY_MASK_CONTENT, ByVal destRect As D2D1_RECT_F Ptr, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawBitmap As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal destRect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolationMode As D2D1_BITMAP_INTERPOLATION_MODE, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawText As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal text As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal layoutRect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS = 0, ByVal measuringMode As DWRITE_MEASURING_MODE = 0)
    DrawTextLayout As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal origin As D2D1_POINT_2F Ptr, ByVal layout As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS)
    DrawGlyphRun As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal baselineOrigin As D2D1_POINT_2F Ptr, ByVal glyphRun As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE)
    SetTransform As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    GetTransform As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    SetAntialiasMode As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    GetAntialiasMode As Function(ByVal This As ID2D1DeviceContext5 Ptr) As D2D1_ANTIALIAS_MODE
    SetTextAntialiasMode As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal antialiasMode As D2D1_TEXT_ANTIALIAS_MODE)
    GetTextAntialiasMode As Function(ByVal This As ID2D1DeviceContext5 Ptr) As D2D1_TEXT_ANTIALIAS_MODE
    SetTextRenderingParams As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal params As Any Ptr)
    GetTextRenderingParams As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal params As Any Ptr Ptr)
    SetTags As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal tag1 As D2D1_TAG, ByVal tag2 As D2D1_TAG)
    GetTags As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr)
    PushLayer As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal layerParams As D2D1_LAYER_PARAMETERS Ptr, ByVal layer As ID2D1Layer Ptr)
    PopLayer As Sub(ByVal This As ID2D1DeviceContext5 Ptr)
    Flush As Function(ByVal This As ID2D1DeviceContext5 Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    SaveDrawingState As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal stateBlock As Any Ptr)
    RestoreDrawingState As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal stateBlock As Any Ptr)
    PushAxisAlignedClip As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    PopAxisAlignedClip As Sub(ByVal This As ID2D1DeviceContext5 Ptr)
    Clear As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal col As D2D1_COLOR_F Ptr)
    BeginDraw As Sub(ByVal This As ID2D1DeviceContext5 Ptr)
    EndDraw As Function(ByVal This As ID2D1DeviceContext5 Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    GetPixelFormat As Function(ByVal This As ID2D1DeviceContext5 Ptr) As D2D1_PIXEL_FORMAT
    SetDpi As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal dpiX As Single, ByVal dpiY As Single)
    GetDpi As Sub(ByVal This As ID2D1DeviceContext5 Ptr, ByVal dpiX As Single Ptr, ByVal dpiY As Single Ptr)
    GetSize As Function(ByVal This As ID2D1DeviceContext5 Ptr, ByVal size As Any Ptr) As D2D1_SIZE_F
    GetPixelSize As Function(ByVal This As ID2D1DeviceContext5 Ptr, ByVal pixelSize As Any Ptr) As D2D1_SIZE_U
    GetMaximumBitmapSize As Function(ByVal This As ID2D1DeviceContext5 Ptr) As ULong
    IsSupported As Function(ByVal This As ID2D1DeviceContext5 Ptr, ByVal renderTargetProperties As D2D1_RENDER_TARGET_PROPERTIES Ptr) As BOOL
        ' Erbt alle Methoden von ID2D1RenderTarget (1-57)
    	' 58. CreateBitmap (überladen)
    CreateBitmap1 As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal size As D2D1_SIZE_U, ByVal src_data As Any Ptr, ByVal pitch As ULong, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As Any Ptr Ptr ) As HRESULT
    	' 59. CreateBitmapFromWicBitmap (überladen)
    CreateBitmapFromWicBitmap1 As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal bitmap_source As IUnknownBase Ptr, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As ID2D1Bitmap1 Ptr Ptr ) As HRESULT
    	' 60. CreateColorContext
    CreateColorContext As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal space As D2D1_COLOR_SPACE, ByVal profile As UByte Ptr, ByVal profile_size As ULong, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 61. CreateColorContextFromFilename
    CreateColorContextFromFilename As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal filename As WString Ptr, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 62. CreateColorContextFromWicColorContext
    CreateColorContextFromWicColorContext As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal wic_color_context As Any Ptr, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 63. CreateBitmapFromDxgiSurface
    CreateBitmapFromDxgiSurface As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal surface As Any Ptr, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As Any Ptr Ptr ) As HRESULT
    	' 64. CreateEffect
    CreateEffect As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByRef effect_id As GUID, ByVal effect As ID2D1Effect Ptr Ptr ) As HRESULT
    	' 65. CreateGradientStopCollection (überladen)
    CreateGradientStopCollection1 As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal stops As D2D1_GRADIENT_STOP Ptr, ByVal stop_count As ULong, ByVal preinterpolation_space As D2D1_COLOR_SPACE, ByVal postinterpolation_space As D2D1_COLOR_SPACE, ByVal buffer_precision As D2D1_BUFFER_PRECISION, ByVal extend_mode As D2D1_EXTEND_MODE, ByVal color_interpolation_mode As D2D1_COLOR_INTERPOLATION_MODE, ByVal gradient As Any Ptr Ptr ) As HRESULT
    	' 66. CreateImageBrush
    CreateImageBrush As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal image As ID2D1Image Ptr, ByVal image_brush_desc As D2D1_IMAGE_BRUSH_PROPERTIES Ptr, ByVal brush_desc As D2D1_BRUSH_PROPERTIES Ptr, ByVal brush As Any Ptr Ptr ) As HRESULT
    	' 67. CreateBitmapBrush (überladen)
    CreateBitmapBrush1 As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal bitmap_brush_desc As D2D1_BITMAP_BRUSH_PROPERTIES1 Ptr, ByVal brush_desc As D2D1_BRUSH_PROPERTIES Ptr, ByVal bitmap_brush As Any Ptr Ptr ) As HRESULT
    	' 68. CreateCommandList
    CreateCommandList As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal command_list As Any Ptr Ptr ) As HRESULT
    	' 69. IsDxgiFormatSupported
    IsDxgiFormatSupported As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal format As ULong ) As Long
    	' 70. IsBufferPrecisionSupported
    IsBufferPrecisionSupported As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal buffer_precision As D2D1_BUFFER_PRECISION ) As Long
    	' 71. GetImageLocalBounds
    GetImageLocalBounds As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal image As ID2D1Image Ptr, ByVal local_bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 72. GetImageWorldBounds
    GetImageWorldBounds As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal image As ID2D1Image Ptr, ByVal world_bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 73. GetGlyphRunWorldBounds
    GetGlyphRunWorldBounds As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal measuring_mode As ULong, ByVal bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 74. GetDevice
    GetDevice As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal device As Any Ptr Ptr )
    	' 75. SetTarget
    SetTarget As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal target As ID2D1Image Ptr )
    	' 76. GetTarget
    GetTarget As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal target As Any Ptr Ptr )
    	' 77. SetRenderingControls
    SetRenderingControls As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal rendering_controls As D2D1_RENDERING_CONTROLS Ptr )
    	' 78. GetRenderingControls
    GetRenderingControls As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal rendering_controls As D2D1_RENDERING_CONTROLS Ptr )
    	' 79. SetPrimitiveBlend
    SetPrimitiveBlend As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal primitive_blend As D2D1_PRIMITIVE_BLEND )
    	' 80. GetPrimitiveBlend
    GetPrimitiveBlend As Function(ByVal This As ID2D1DeviceContext5 Ptr) As D2D1_PRIMITIVE_BLEND
    	' 81. SetUnitMode
    SetUnitMode As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal unit_mode As D2D1_UNIT_MODE )
    	' 82. GetUnitMode
    GetUnitMode As Function(ByVal This As ID2D1DeviceContext5 Ptr) As D2D1_UNIT_MODE
    	' 83. DrawGlyphRun (überladen)
    DrawGlyphRun1 As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal glyph_run_desc As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuring_mode As ULong )
    	' 84. DrawImage
    DrawImage As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal image As ID2D1Image Ptr, ByVal target_offset As D2D1_POINT_2F Ptr = 0, ByVal image_rect As D2D1_RECT_F Ptr = 0, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR, ByVal composite_mode As D2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER )
    	' 85. DrawGdiMetafile
    DrawGdiMetafile As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal metafile As ID2D1GdiMetafile Ptr, ByVal target_offset As D2D1_POINT_2F Ptr )
    	' 86. DrawBitmap (überladen)
    DrawBitmap1 As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE, ByVal src_rect As D2D1_RECT_F Ptr, ByVal perspective_transform As D2D1_MATRIX_4X4_F Ptr )
    	' 87. InvalidateEffectInputRectangle
    InvalidateEffectInputRectangle As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal effect As Any Ptr, ByVal input As ULong, ByVal input_rect As D2D1_RECT_F Ptr ) As HRESULT
    	' 88. GetEffectInvalidRectangleCount
    GetEffectInvalidRectangleCount As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal effect As Any Ptr, ByVal rect_count As ULong Ptr ) As HRESULT
    	' 89. GetEffectInvalidRectangles
    GetEffectInvalidRectangles As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal effect As Any Ptr, ByVal rectangles As D2D1_RECT_F Ptr, ByVal rect_count As ULong ) As HRESULT
    	' 90. GetEffectRequiredInputRectangles
    GetEffectRequiredInputRectangles As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal effect As Any Ptr, ByVal image_rect As D2D1_RECT_F Ptr, ByVal desc As D2D1_EFFECT_INPUT_DESCRIPTION Ptr, ByVal input_rects As D2D1_RECT_F Ptr, ByVal input_count As ULong ) As HRESULT
    	' 91. FillOpacityMask (überladen)
    FillOpacityMask1 As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal mask As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal content As D2D1_OPACITY_MASK_CONTENT, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal src_rect As D2D1_RECT_F Ptr )
    	' 92. PushLayer
    PushLayer1 As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal layer_parameters As D2D1_LAYER_PARAMETERS1 Ptr, ByVal layer As ID2D1Layer Ptr )
        ' Erbt alle Methoden von ID2D1DeviceContext (1-96 Methoden)
        ' 97. CreateFilledGeometryRealization
    CreateFilledGeometryRealization As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal tolerance As Single, ByVal realization As Any Ptr Ptr ) As HRESULT
        ' 98. CreateStrokedGeometryRealization
    CreateStrokedGeometryRealization As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal tolerance As Single, ByVal stroke_width As Single, ByVal stroke_style As ID2D1StrokeStyle Ptr, ByVal realization As Any Ptr Ptr ) As HRESULT
        ' 99. DrawGeometryRealization
    DrawGeometryRealization As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal realization As ID2D1GeometryRealization Ptr, ByVal brush As ID2D1Brush Ptr )
        ' Erbt alle Methoden von ID2D1DeviceContext1
        ' Neue Methoden
    CreateInk As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal start_point As D2D1_INK_POINT Ptr, ByVal ink As Any Ptr Ptr ) As HRESULT
    CreateInkStyle As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal ink_style_properties As D2D1_INK_STYLE_PROPERTIES Ptr, ByVal ink_style As Any Ptr Ptr ) As HRESULT
    CreateGradientMesh As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal patches As D2D1_GRADIENT_MESH_PATCH Ptr, ByVal patches_count As ULong, ByVal gradient_mesh As Any Ptr Ptr ) As HRESULT
    CreateImageSourceFromWic As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal wic_bitmap_source As Any Ptr, ByVal loading_options As D2D1_IMAGE_SOURCE_LOADING_OPTIONS, ByVal alpha_mode As D2D1_ALPHA_MODE, ByVal image_source As Any Ptr Ptr ) As HRESULT
    CreateLookupTable3D As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal precision As ULong, ByVal extents As ULong Ptr, ByVal data As UByte Ptr, ByVal data_count As ULong, ByVal strides As ULong Ptr, ByVal lookup_table As Any Ptr Ptr ) As HRESULT
    CreateImageSourceFromDxgi As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal surfaces As Any Ptr Ptr, ByVal surface_count As ULong, ByVal color_space As ULong, ByVal options As D2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS, ByVal image_source As Any Ptr Ptr ) As HRESULT
    GetGradientMeshWorldBounds As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal gradient_mesh As ID2D1GradientMesh Ptr, ByVal bounds As D2D1_RECT_F Ptr ) As HRESULT
    DrawInk As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal ink As ID2D1Ink Ptr, ByVal brush As ID2D1Brush Ptr, ByVal ink_style As ID2D1InkStyle Ptr )
    DrawGradientMesh As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal gradient_mesh As ID2D1GradientMesh Ptr )
    DrawGdiMetafile1 As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal gdi_metafile As Any Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal src_rect As D2D1_RECT_F Ptr )
    CreateTransformedImageSource As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal source As ID2D1ImageSource Ptr, ByVal props As D2D1_TRANSFORMED_IMAGE_SOURCE_PROPERTIES Ptr, ByVal transformed As Any Ptr Ptr ) As HRESULT
        ' Erbt von ID2D1DeviceContext2
    CreateSpriteBatch As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal sprite_batch As Any Ptr Ptr ) As HRESULT
    DrawSpriteBatch As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal sprite_batch As ID2D1SpriteBatch Ptr, ByVal start_index As ULong, ByVal sprite_count As ULong, ByVal bitmap As ID2D1Bitmap Ptr, ByVal interpolation_mode As D2D1_BITMAP_INTERPOLATION_MODE, ByVal sprite_options As D2D1_SPRITE_OPTIONS )
        ' Erbt von ID2D1DeviceContext3
    CreateSvgGlyphStyle As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal svg_glyph_style As Any Ptr Ptr ) As HRESULT
        ' DrawText - Überladen mit zusätzlichen Parametern
    DrawText1 As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal string As WString Ptr, ByVal string_length As ULong, ByVal text_format As Any Ptr, ByVal layout_rect As D2D1_RECT_F Ptr, ByVal default_fill_brush As ID2D1Brush Ptr, ByVal svg_glyph_style As ID2D1SvgGlyphStyle Ptr, ByVal color_palette_index As ULong, ByVal options As D2D1_DRAW_TEXT_OPTIONS, ByVal measuring_mode As ULong )
    DrawTextLayout1 As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal origin As D2D1_POINT_2F, ByVal text_layout As Any Ptr, ByVal default_fill_brush As ID2D1Brush Ptr, ByVal svg_glyph_style As ID2D1SvgGlyphStyle Ptr, ByVal color_palette_index As ULong, ByVal options As D2D1_DRAW_TEXT_OPTIONS )
    DrawColorBitmapGlyphRun As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal glyph_image_format As ULong, ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal measuring_mode As ULong, ByVal bitmap_snap_option As D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION )
    DrawSvgGlyphRun As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal default_fill_brush As ID2D1Brush Ptr, ByVal svg_glyph_style As ID2D1SvgGlyphStyle Ptr, ByVal color_palette_index As ULong, ByVal measuring_mode As ULong )
    GetColorBitmapGlyphImage As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal glyph_image_format As ULong, ByVal glyph_origin As D2D1_POINT_2F, ByVal font_face As Any Ptr, ByVal font_em_size As Single, ByVal glyph_index As UShort, ByVal is_sideways As Long, ByVal world_transform As D2D1_MATRIX_3X2_F Ptr, ByVal dpi_x As Single, ByVal dpi_y As Single, ByVal glyph_transform As D2D1_MATRIX_3X2_F Ptr, ByVal glyph_image As Any Ptr Ptr ) As HRESULT
    GetSvgGlyphImage As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal glyph_origin As D2D1_POINT_2F, ByVal font_face As Any Ptr, ByVal font_em_size As Single, ByVal glyph_index As UShort, ByVal is_sideways As Long, ByVal world_transform As D2D1_MATRIX_3X2_F Ptr, ByVal default_fill_brush As ID2D1Brush Ptr, ByVal svg_glyph_style As ID2D1SvgGlyphStyle Ptr, ByVal color_palette_index As ULong, ByVal glyph_transform As D2D1_MATRIX_3X2_F Ptr, ByVal glyph_image As Any Ptr Ptr ) As HRESULT

        ' Erbt von ID2D1DeviceContext4
    CreateSvgDocument As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal input_xml_stream As Any Ptr, ByVal viewport_size As D2D1_SIZE_F, ByVal svg_document As Any Ptr Ptr ) As HRESULT
    DrawSvgDocument As Sub(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal svg_document As Any Ptr )
    CreateColorContextFromDxgiColorSpace As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal color_space As ULong, ByVal color_context As Any Ptr Ptr ) As HRESULT
    CreateColorContextFromSimpleColorProfile As Function(ByVal This As ID2D1DeviceContext5 Ptr,  ByVal simple_profile As D2D1_SIMPLE_COLOR_PROFILE Ptr, ByVal color_context As Any Ptr Ptr ) As HRESULT
End Type
#define ID2D1DeviceContext5_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1DeviceContext5_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1DeviceContext5_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1DeviceContext5_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1DeviceContext5_CreateBitmap(p, a, b, c, d, e) (p)->lpVtbl->CreateBitmap(p, a, b, c, d, e)
#define ID2D1DeviceContext5_CreateBitmapFromWicBitmap(p, a, b, c) (p)->lpVtbl->CreateBitmapFromWicBitmap(p, a, b, c)
#define ID2D1DeviceContext5_CreateSharedBitmap(p, a, b, c, d) (p)->lpVtbl->CreateSharedBitmap(p, a, b, c, d)
#define ID2D1DeviceContext5_CreateBitmapBrush(p, a, b, c, d) (p)->lpVtbl->CreateBitmapBrush(p, a, b, c, d)
#define ID2D1DeviceContext5_CreateSolidColorBrush(p, a, b, c) (p)->lpVtbl->CreateSolidColorBrush(p, a, b, c)
#define ID2D1DeviceContext5_CreateGradientStopCollection(p, a, b, c, d, e) (p)->lpVtbl->CreateGradientStopCollection(p, a, b, c, d, e)
#define ID2D1DeviceContext5_CreateLinearGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateLinearGradientBrush(p, a, b, c, d)
#define ID2D1DeviceContext5_CreateRadialGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateRadialGradientBrush(p, a, b, c, d)
#define ID2D1DeviceContext5_CreateCompatibleRenderTarget(p, a, b, c, d, e) (p)->lpVtbl->CreateCompatibleRenderTarget(p, a, b, c, d, e)
#define ID2D1DeviceContext5_CreateLayer(p, a, b) (p)->lpVtbl->CreateLayer(p, a, b)
#define ID2D1DeviceContext5_CreateMesh(p, a) (p)->lpVtbl->CreateMesh(p, a)
#define ID2D1DeviceContext5_DrawLine(p, a, b, c, d, e) (p)->lpVtbl->DrawLine(p, a, b, c, d, e)
#define ID2D1DeviceContext5_DrawRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRectangle(p, a, b, c, d)
#define ID2D1DeviceContext5_FillRectangle(p, a, b) (p)->lpVtbl->FillRectangle(p, a, b)
#define ID2D1DeviceContext5_DrawRoundedRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRoundedRectangle(p, a, b, c, d)
#define ID2D1DeviceContext5_FillRoundedRectangle(p, a, b) (p)->lpVtbl->FillRoundedRectangle(p, a, b)
#define ID2D1DeviceContext5_DrawEllipse(p, a, b, c, d) (p)->lpVtbl->DrawEllipse(p, a, b, c, d)
#define ID2D1DeviceContext5_FillEllipse(p, a, b) (p)->lpVtbl->FillEllipse(p, a, b)
#define ID2D1DeviceContext5_DrawGeometry(p, a, b, c, d) (p)->lpVtbl->DrawGeometry(p, a, b, c, d)
#define ID2D1DeviceContext5_FillGeometry(p, a, b, c) (p)->lpVtbl->FillGeometry(p, a, b, c)
#define ID2D1DeviceContext5_FillMesh(p, a, b) (p)->lpVtbl->FillMesh(p, a, b)
#define ID2D1DeviceContext5_FillOpacityMask(p, a, b, c, d, e) (p)->lpVtbl->FillOpacityMask(p, a, b, c, d, e)
#define ID2D1DeviceContext5_DrawBitmap(p, a, b, c, d, e) (p)->lpVtbl->DrawBitmap(p, a, b, c, d, e)
#define ID2D1DeviceContext5_DrawText(p, a, b, c, d, e, f, g) (p)->lpVtbl->DrawText(p, a, b, c, d, e, f, g)
#define ID2D1DeviceContext5_DrawTextLayout(p, a, b, c, d) (p)->lpVtbl->DrawTextLayout(p, a, b, c, d)
#define ID2D1DeviceContext5_DrawGlyphRun(p, a, b, c, d) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d)
#define ID2D1DeviceContext5_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1DeviceContext5_GetTransform(p, a) (p)->lpVtbl->GetTransform(p, a)
#define ID2D1DeviceContext5_SetAntialiasMode(p, a) (p)->lpVtbl->SetAntialiasMode(p, a)
#define ID2D1DeviceContext5_GetAntialiasMode(p, a) (p)->lpVtbl->GetAntialiasMode(p, a)
#define ID2D1DeviceContext5_SetTextAntialiasMode(p, a) (p)->lpVtbl->SetTextAntialiasMode(p, a)
#define ID2D1DeviceContext5_GetTextAntialiasMode(p, a) (p)->lpVtbl->GetTextAntialiasMode(p, a)
#define ID2D1DeviceContext5_SetTextRenderingParams(p, a) (p)->lpVtbl->SetTextRenderingParams(p, a)
#define ID2D1DeviceContext5_GetTextRenderingParams(p, a) (p)->lpVtbl->GetTextRenderingParams(p, a)
#define ID2D1DeviceContext5_SetTags(p, a, b) (p)->lpVtbl->SetTags(p, a, b)
#define ID2D1DeviceContext5_GetTags(p, a, b) (p)->lpVtbl->GetTags(p, a, b)
#define ID2D1DeviceContext5_PushLayer(p, a, b) (p)->lpVtbl->PushLayer(p, a, b)
#define ID2D1DeviceContext5_PopLayer(p, a) (p)->lpVtbl->PopLayer(p, a)
#define ID2D1DeviceContext5_Flush(p, a, b) (p)->lpVtbl->Flush(p, a, b)
#define ID2D1DeviceContext5_SaveDrawingState(p, a) (p)->lpVtbl->SaveDrawingState(p, a)
#define ID2D1DeviceContext5_RestoreDrawingState(p, a) (p)->lpVtbl->RestoreDrawingState(p, a)
#define ID2D1DeviceContext5_PushAxisAlignedClip(p, a, b) (p)->lpVtbl->PushAxisAlignedClip(p, a, b)
#define ID2D1DeviceContext5_PopAxisAlignedClip(p, a) (p)->lpVtbl->PopAxisAlignedClip(p, a)
#define ID2D1DeviceContext5_Clear(p, a) (p)->lpVtbl->Clear(p, a)
#define ID2D1DeviceContext5_BeginDraw(p, a) (p)->lpVtbl->BeginDraw(p, a)
#define ID2D1DeviceContext5_EndDraw(p, a, b) (p)->lpVtbl->EndDraw(p, a, b)
#define ID2D1DeviceContext5_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)
#define ID2D1DeviceContext5_SetDpi(p, a, b) (p)->lpVtbl->SetDpi(p, a, b)
#define ID2D1DeviceContext5_GetDpi(p, a, b) (p)->lpVtbl->GetDpi(p, a, b)
#define ID2D1DeviceContext5_GetSize(p, a) (p)->lpVtbl->GetSize(p, a)
#define ID2D1DeviceContext5_GetPixelSize(p, a) (p)->lpVtbl->GetPixelSize(p, a)
#define ID2D1DeviceContext5_GetMaximumBitmapSize(p, a) (p)->lpVtbl->GetMaximumBitmapSize(p, a)
#define ID2D1DeviceContext5_IsSupported(p, a) (p)->lpVtbl->IsSupported(p, a)
#define ID2D1DeviceContext5_CreateBitmap1(p, a, b, c, d, e) (p)->lpVtbl->CreateBitmap1(p, a, b, c, d, e)
#define ID2D1DeviceContext5_CreateBitmapFromWicBitmap1(p, a, b, c) (p)->lpVtbl->CreateBitmapFromWicBitmap1(p, a, b, c)
#define ID2D1DeviceContext5_CreateColorContext(p, a, b, c, d) (p)->lpVtbl->CreateColorContext(p, a, b, c, d)
#define ID2D1DeviceContext5_CreateColorContextFromFilename(p, a, b) (p)->lpVtbl->CreateColorContextFromFilename(p, a, b)
#define ID2D1DeviceContext5_CreateColorContextFromWicColorContext(p, a, b) (p)->lpVtbl->CreateColorContextFromWicColorContext(p, a, b)
#define ID2D1DeviceContext5_CreateBitmapFromDxgiSurface(p, a, b, c) (p)->lpVtbl->CreateBitmapFromDxgiSurface(p, a, b, c)
#define ID2D1DeviceContext5_CreateEffect(p, a, b) (p)->lpVtbl->CreateEffect(p, a, b)
#define ID2D1DeviceContext5_CreateGradientStopCollection1(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateGradientStopCollection1(p, a, b, c, d, e, f, g, h)
#define ID2D1DeviceContext5_CreateImageBrush(p, a, b, c, d) (p)->lpVtbl->CreateImageBrush(p, a, b, c, d)
#define ID2D1DeviceContext5_CreateBitmapBrush1(p, a, b, c, d) (p)->lpVtbl->CreateBitmapBrush1(p, a, b, c, d)
#define ID2D1DeviceContext5_CreateCommandList(p, a) (p)->lpVtbl->CreateCommandList(p, a)
#define ID2D1DeviceContext5_IsDxgiFormatSupported(p, a) (p)->lpVtbl->IsDxgiFormatSupported(p, a)
#define ID2D1DeviceContext5_IsBufferPrecisionSupported(p, a) (p)->lpVtbl->IsBufferPrecisionSupported(p, a)
#define ID2D1DeviceContext5_GetImageLocalBounds(p, a, b) (p)->lpVtbl->GetImageLocalBounds(p, a, b)
#define ID2D1DeviceContext5_GetImageWorldBounds(p, a, b) (p)->lpVtbl->GetImageWorldBounds(p, a, b)
#define ID2D1DeviceContext5_GetGlyphRunWorldBounds(p, a, b, c, d) (p)->lpVtbl->GetGlyphRunWorldBounds(p, a, b, c, d)
#define ID2D1DeviceContext5_GetDevice(p, a) (p)->lpVtbl->GetDevice(p, a)
#define ID2D1DeviceContext5_SetTarget(p, a) (p)->lpVtbl->SetTarget(p, a)
#define ID2D1DeviceContext5_GetTarget(p, a) (p)->lpVtbl->GetTarget(p, a)
#define ID2D1DeviceContext5_SetRenderingControls(p, a) (p)->lpVtbl->SetRenderingControls(p, a)
#define ID2D1DeviceContext5_GetRenderingControls(p, a) (p)->lpVtbl->GetRenderingControls(p, a)
#define ID2D1DeviceContext5_SetPrimitiveBlend(p, a) (p)->lpVtbl->SetPrimitiveBlend(p, a)
#define ID2D1DeviceContext5_GetPrimitiveBlend(p, a) (p)->lpVtbl->GetPrimitiveBlend(p, a)
#define ID2D1DeviceContext5_SetUnitMode(p, a) (p)->lpVtbl->SetUnitMode(p, a)
#define ID2D1DeviceContext5_GetUnitMode(p, a) (p)->lpVtbl->GetUnitMode(p, a)
#define ID2D1DeviceContext5_DrawGlyphRun1(p, a, b, c, d, e) (p)->lpVtbl->DrawGlyphRun1(p, a, b, c, d, e)
#define ID2D1DeviceContext5_DrawImage(p, a, b, c, d, e) (p)->lpVtbl->DrawImage(p, a, b, c, d, e)
#define ID2D1DeviceContext5_DrawGdiMetafile(p, a, b) (p)->lpVtbl->DrawGdiMetafile(p, a, b)
#define ID2D1DeviceContext5_DrawBitmap1(p, a, b, c, d, e, f) (p)->lpVtbl->DrawBitmap1(p, a, b, c, d, e, f)
#define ID2D1DeviceContext5_InvalidateEffectInputRectangle(p, a, b, c) (p)->lpVtbl->InvalidateEffectInputRectangle(p, a, b, c)
#define ID2D1DeviceContext5_GetEffectInvalidRectangleCount(p, a, b) (p)->lpVtbl->GetEffectInvalidRectangleCount(p, a, b)
#define ID2D1DeviceContext5_GetEffectInvalidRectangles(p, a, b, c) (p)->lpVtbl->GetEffectInvalidRectangles(p, a, b, c)
#define ID2D1DeviceContext5_GetEffectRequiredInputRectangles(p, a, b, c, d, e) (p)->lpVtbl->GetEffectRequiredInputRectangles(p, a, b, c, d, e)
#define ID2D1DeviceContext5_FillOpacityMask1(p, a, b, c, d, e) (p)->lpVtbl->FillOpacityMask1(p, a, b, c, d, e)
#define ID2D1DeviceContext5_PushLayer1(p, a, b) (p)->lpVtbl->PushLayer1(p, a, b)
#define ID2D1DeviceContext5_CreateFilledGeometryRealization(p, a, b, c) (p)->lpVtbl->CreateFilledGeometryRealization(p, a, b, c)
#define ID2D1DeviceContext5_CreateStrokedGeometryRealization(p, a, b, c, d, e) (p)->lpVtbl->CreateStrokedGeometryRealization(p, a, b, c, d, e)
#define ID2D1DeviceContext5_DrawGeometryRealization(p, a, b) (p)->lpVtbl->DrawGeometryRealization(p, a, b)
#define ID2D1DeviceContext5_CreateInk(p, a, b) (p)->lpVtbl->CreateInk(p, a, b)
#define ID2D1DeviceContext5_CreateInkStyle(p, a, b) (p)->lpVtbl->CreateInkStyle(p, a, b)
#define ID2D1DeviceContext5_CreateGradientMesh(p, a, b, c) (p)->lpVtbl->CreateGradientMesh(p, a, b, c)
#define ID2D1DeviceContext5_CreateImageSourceFromWic(p, a, b, c, d) (p)->lpVtbl->CreateImageSourceFromWic(p, a, b, c, d)
#define ID2D1DeviceContext5_CreateLookupTable3D(p, a, b, c, d, e, f) (p)->lpVtbl->CreateLookupTable3D(p, a, b, c, d, e, f)
#define ID2D1DeviceContext5_CreateImageSourceFromDxgi(p, a, b, c, d, e) (p)->lpVtbl->CreateImageSourceFromDxgi(p, a, b, c, d, e)
#define ID2D1DeviceContext5_GetGradientMeshWorldBounds(p, a, b) (p)->lpVtbl->GetGradientMeshWorldBounds(p, a, b)
#define ID2D1DeviceContext5_DrawInk(p, a, b, c) (p)->lpVtbl->DrawInk(p, a, b, c)
#define ID2D1DeviceContext5_DrawGradientMesh(p, a) (p)->lpVtbl->DrawGradientMesh(p, a)
#define ID2D1DeviceContext5_DrawGdiMetafile1(p, a, b, c) (p)->lpVtbl->DrawGdiMetafile1(p, a, b, c)
#define ID2D1DeviceContext5_CreateTransformedImageSource(p, a, b, c) (p)->lpVtbl->CreateTransformedImageSource(p, a, b, c)
#define ID2D1DeviceContext5_CreateSpriteBatch(p, a) (p)->lpVtbl->CreateSpriteBatch(p, a)
#define ID2D1DeviceContext5_DrawSpriteBatch(p, a, b, c, d, e, f) (p)->lpVtbl->DrawSpriteBatch(p, a, b, c, d, e, f)
#define ID2D1DeviceContext5_CreateSvgGlyphStyle(p, a) (p)->lpVtbl->CreateSvgGlyphStyle(p, a)
#define ID2D1DeviceContext5_DrawText1(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->DrawText1(p, a, b, c, d, e, f, g, h, i)
#define ID2D1DeviceContext5_DrawTextLayout1(p, a, b, c, d, e, f) (p)->lpVtbl->DrawTextLayout1(p, a, b, c, d, e, f)
#define ID2D1DeviceContext5_DrawColorBitmapGlyphRun(p, a, b, c, d, e) (p)->lpVtbl->DrawColorBitmapGlyphRun(p, a, b, c, d, e)
#define ID2D1DeviceContext5_DrawSvgGlyphRun(p, a, b, c, d, e, f) (p)->lpVtbl->DrawSvgGlyphRun(p, a, b, c, d, e, f)
#define ID2D1DeviceContext5_GetColorBitmapGlyphImage(p, a, b, c, d, e, f, g, h, i, j, k) (p)->lpVtbl->GetColorBitmapGlyphImage(p, a, b, c, d, e, f, g, h, i, j, k)
#define ID2D1DeviceContext5_GetSvgGlyphImage(p, a, b, c, d, e, f, g, h, i, j, k) (p)->lpVtbl->GetSvgGlyphImage(p, a, b, c, d, e, f, g, h, i, j, k)
#define ID2D1DeviceContext5_CreateSvgDocument(p, a, b, c) (p)->lpVtbl->CreateSvgDocument(p, a, b, c)
#define ID2D1DeviceContext5_DrawSvgDocument(p, a) (p)->lpVtbl->DrawSvgDocument(p, a)
#define ID2D1DeviceContext5_CreateColorContextFromDxgiColorSpace(p, a, b) (p)->lpVtbl->CreateColorContextFromDxgiColorSpace(p, a, b)
#define ID2D1DeviceContext5_CreateColorContextFromSimpleColorProfile(p, a, b) (p)->lpVtbl->CreateColorContextFromSimpleColorProfile(p, a, b)

' ============================================================================
' ID2D1DeviceContext6
' ============================================================================
Type ID2D1DeviceContext6Vtbl As ID2D1DeviceContext6Vtbl_
Type ID2D1DeviceContext6
    lpVtbl As ID2D1DeviceContext6Vtbl Ptr
End Type
Type ID2D1DeviceContext6Vtbl_     '' Extends ID2D1DeviceContext5Vtbl_
    QueryInterface As Function(ByVal This As ID2D1DeviceContext6 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1DeviceContext6 Ptr) As ULong
    Release As Function(ByVal This As ID2D1DeviceContext6 Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal factory As Any Ptr Ptr)
        ' 4.   (ID2D1Resource: GetFactory)
    CreateBitmap As Function(ByVal This As ID2D1DeviceContext6 Ptr, ByVal size As D2D1_SIZE_U, ByVal srcData As Any Ptr, ByVal pitch As ULong, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapFromWicBitmap As Function(ByVal This As ID2D1DeviceContext6 Ptr, ByVal wicBitmapSource As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateSharedBitmap As Function(ByVal This As ID2D1DeviceContext6 Ptr, ByVal riid As GUID Ptr, ByVal data As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapBrush As Function(ByVal This As ID2D1DeviceContext6 Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal bitmapBrushProperties As D2D1_BITMAP_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal bitmapBrush As ID2D1BitmapBrush Ptr Ptr) As HRESULT
    CreateSolidColorBrush As Function(ByVal This As ID2D1DeviceContext6 Ptr, ByVal color As D2D1_COLOR_F Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal solidColorBrush As ID2D1SolidColorBrush Ptr Ptr) As HRESULT
    CreateGradientStopCollection As Function(ByVal This As ID2D1DeviceContext6 Ptr, ByVal gradientStops As D2D1_GRADIENT_STOP Ptr, ByVal gradientStopsCount As ULong, ByVal colorInterpolationGamma As D2D1_GAMMA, ByVal extendMode As D2D1_EXTEND_MODE, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr Ptr) As HRESULT
    CreateLinearGradientBrush As Function(ByVal This As ID2D1DeviceContext6 Ptr, ByVal linearGradientBrushProperties As D2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal linearGradientBrush As ID2D1LinearGradientBrush Ptr Ptr) As HRESULT
    CreateRadialGradientBrush As Function(ByVal This As ID2D1DeviceContext6 Ptr, ByVal radialGradientBrushProperties As D2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal radialGradientBrush As ID2D1RadialGradientBrush Ptr Ptr) As HRESULT
    CreateCompatibleRenderTarget As Function(ByVal This As ID2D1DeviceContext6 Ptr, ByVal desiredSize As D2D1_SIZE_F Ptr, ByVal desiredPixelSize As D2D1_SIZE_U Ptr, ByVal desiredFormat As D2D1_PIXEL_FORMAT Ptr, ByVal options As ULong, ByVal bitmapRenderTarget As Any Ptr Ptr) As HRESULT 'ID2D1BitmapRenderTarget
    CreateLayer As Function(ByVal This As ID2D1DeviceContext6 Ptr, ByVal size As D2D1_SIZE_F Ptr, ByVal layer As ID2D1Layer Ptr Ptr) As HRESULT
    CreateMesh As Function(ByVal This As ID2D1DeviceContext6 Ptr, ByVal mesh As ID2D1Mesh Ptr Ptr) As HRESULT
    DrawLine As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal p0 As D2D1_POINT_2F, ByVal p1 As D2D1_POINT_2F, ByVal brush As ID2D1SolidColorBrush Ptr, ByVal strokeWidth As Single = 0, ByVal strokeStyle As ID2D1StrokeStyle Ptr = NULL)
    DrawRectangle As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRectangle As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawRoundedRectangle As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRoundedRectangle As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawEllipse As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillEllipse As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawGeometry As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillGeometry As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal opacityBrush As ID2D1Brush Ptr)
    FillMesh As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal mesh As ID2D1Mesh Ptr, ByVal brush As ID2D1Brush Ptr)
    FillOpacityMask As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal mask As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal content As D2D1_OPACITY_MASK_CONTENT, ByVal destRect As D2D1_RECT_F Ptr, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawBitmap As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal destRect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolationMode As D2D1_BITMAP_INTERPOLATION_MODE, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawText As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal text As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal layoutRect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS = 0, ByVal measuringMode As DWRITE_MEASURING_MODE = 0)
    DrawTextLayout As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal origin As D2D1_POINT_2F Ptr, ByVal layout As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS)
    DrawGlyphRun As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal baselineOrigin As D2D1_POINT_2F Ptr, ByVal glyphRun As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE)
    SetTransform As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    GetTransform As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    SetAntialiasMode As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    GetAntialiasMode As Function(ByVal This As ID2D1DeviceContext6 Ptr) As D2D1_ANTIALIAS_MODE
    SetTextAntialiasMode As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal antialiasMode As D2D1_TEXT_ANTIALIAS_MODE)
    GetTextAntialiasMode As Function(ByVal This As ID2D1DeviceContext6 Ptr) As D2D1_TEXT_ANTIALIAS_MODE
    SetTextRenderingParams As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal params As Any Ptr)
    GetTextRenderingParams As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal params As Any Ptr Ptr)
    SetTags As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal tag1 As D2D1_TAG, ByVal tag2 As D2D1_TAG)
    GetTags As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr)
    PushLayer As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal layerParams As D2D1_LAYER_PARAMETERS Ptr, ByVal layer As ID2D1Layer Ptr)
    PopLayer As Sub(ByVal This As ID2D1DeviceContext6 Ptr)
    Flush As Function(ByVal This As ID2D1DeviceContext6 Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    SaveDrawingState As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal stateBlock As Any Ptr)
    RestoreDrawingState As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal stateBlock As Any Ptr)
    PushAxisAlignedClip As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    PopAxisAlignedClip As Sub(ByVal This As ID2D1DeviceContext6 Ptr)
    Clear As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal col As D2D1_COLOR_F Ptr)
    BeginDraw As Sub(ByVal This As ID2D1DeviceContext6 Ptr)
    EndDraw As Function(ByVal This As ID2D1DeviceContext6 Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    GetPixelFormat As Function(ByVal This As ID2D1DeviceContext6 Ptr) As D2D1_PIXEL_FORMAT
    SetDpi As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal dpiX As Single, ByVal dpiY As Single)
    GetDpi As Sub(ByVal This As ID2D1DeviceContext6 Ptr, ByVal dpiX As Single Ptr, ByVal dpiY As Single Ptr)
    GetSize As Function(ByVal This As ID2D1DeviceContext6 Ptr, ByVal size As Any Ptr) As D2D1_SIZE_F
    GetPixelSize As Function(ByVal This As ID2D1DeviceContext6 Ptr, ByVal pixelSize As Any Ptr) As D2D1_SIZE_U
    GetMaximumBitmapSize As Function(ByVal This As ID2D1DeviceContext6 Ptr) As ULong
    IsSupported As Function(ByVal This As ID2D1DeviceContext6 Ptr, ByVal renderTargetProperties As D2D1_RENDER_TARGET_PROPERTIES Ptr) As BOOL
        ' Erbt alle Methoden von ID2D1RenderTarget (1-57)
    	' 58. CreateBitmap (überladen)
    CreateBitmap1 As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal size As D2D1_SIZE_U, ByVal src_data As Any Ptr, ByVal pitch As ULong, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As Any Ptr Ptr ) As HRESULT
    	' 59. CreateBitmapFromWicBitmap (überladen)
    CreateBitmapFromWicBitmap1 As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal bitmap_source As IUnknownBase Ptr, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As ID2D1Bitmap1 Ptr Ptr ) As HRESULT
    	' 60. CreateColorContext
    CreateColorContext As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal space As D2D1_COLOR_SPACE, ByVal profile As UByte Ptr, ByVal profile_size As ULong, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 61. CreateColorContextFromFilename
    CreateColorContextFromFilename As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal filename As WString Ptr, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 62. CreateColorContextFromWicColorContext
    CreateColorContextFromWicColorContext As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal wic_color_context As Any Ptr, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 63. CreateBitmapFromDxgiSurface
    CreateBitmapFromDxgiSurface As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal surface As Any Ptr, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As Any Ptr Ptr ) As HRESULT
    	' 64. CreateEffect
    CreateEffect As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByRef effect_id As GUID, ByVal effect As ID2D1Effect Ptr Ptr ) As HRESULT
    	' 65. CreateGradientStopCollection (überladen)
    CreateGradientStopCollection1 As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal stops As D2D1_GRADIENT_STOP Ptr, ByVal stop_count As ULong, ByVal preinterpolation_space As D2D1_COLOR_SPACE, ByVal postinterpolation_space As D2D1_COLOR_SPACE, ByVal buffer_precision As D2D1_BUFFER_PRECISION, ByVal extend_mode As D2D1_EXTEND_MODE, ByVal color_interpolation_mode As D2D1_COLOR_INTERPOLATION_MODE, ByVal gradient As Any Ptr Ptr ) As HRESULT
    	' 66. CreateImageBrush
    CreateImageBrush As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal image As ID2D1Image Ptr, ByVal image_brush_desc As D2D1_IMAGE_BRUSH_PROPERTIES Ptr, ByVal brush_desc As D2D1_BRUSH_PROPERTIES Ptr, ByVal brush As Any Ptr Ptr ) As HRESULT
    	' 67. CreateBitmapBrush (überladen)
    CreateBitmapBrush1 As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal bitmap_brush_desc As D2D1_BITMAP_BRUSH_PROPERTIES1 Ptr, ByVal brush_desc As D2D1_BRUSH_PROPERTIES Ptr, ByVal bitmap_brush As Any Ptr Ptr ) As HRESULT
    	' 68. CreateCommandList
    CreateCommandList As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal command_list As Any Ptr Ptr ) As HRESULT
    	' 69. IsDxgiFormatSupported
    IsDxgiFormatSupported As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal format As ULong ) As Long
    	' 70. IsBufferPrecisionSupported
    IsBufferPrecisionSupported As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal buffer_precision As D2D1_BUFFER_PRECISION ) As Long
    	' 71. GetImageLocalBounds
    GetImageLocalBounds As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal image As ID2D1Image Ptr, ByVal local_bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 72. GetImageWorldBounds
    GetImageWorldBounds As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal image As ID2D1Image Ptr, ByVal world_bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 73. GetGlyphRunWorldBounds
    GetGlyphRunWorldBounds As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal measuring_mode As ULong, ByVal bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 74. GetDevice
    GetDevice As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal device As Any Ptr Ptr )
    	' 75. SetTarget
    SetTarget As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal target As ID2D1Image Ptr )
    	' 76. GetTarget
    GetTarget As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal target As Any Ptr Ptr )
    	' 77. SetRenderingControls
    SetRenderingControls As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal rendering_controls As D2D1_RENDERING_CONTROLS Ptr )
    	' 78. GetRenderingControls
    GetRenderingControls As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal rendering_controls As D2D1_RENDERING_CONTROLS Ptr )
    	' 79. SetPrimitiveBlend
    SetPrimitiveBlend As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal primitive_blend As D2D1_PRIMITIVE_BLEND )
    	' 80. GetPrimitiveBlend
    GetPrimitiveBlend As Function(ByVal This As ID2D1DeviceContext6 Ptr) As D2D1_PRIMITIVE_BLEND
    	' 81. SetUnitMode
    SetUnitMode As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal unit_mode As D2D1_UNIT_MODE )
    	' 82. GetUnitMode
    GetUnitMode As Function(ByVal This As ID2D1DeviceContext6 Ptr) As D2D1_UNIT_MODE
    	' 83. DrawGlyphRun (überladen)
    DrawGlyphRun1 As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal glyph_run_desc As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuring_mode As ULong )
    	' 84. DrawImage
    DrawImage As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal image As ID2D1Image Ptr, ByVal target_offset As D2D1_POINT_2F Ptr = 0, ByVal image_rect As D2D1_RECT_F Ptr = 0, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR, ByVal composite_mode As D2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER )
    	' 85. DrawGdiMetafile
    DrawGdiMetafile As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal metafile As ID2D1GdiMetafile Ptr, ByVal target_offset As D2D1_POINT_2F Ptr )
    	' 86. DrawBitmap (überladen)
    DrawBitmap1 As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE, ByVal src_rect As D2D1_RECT_F Ptr, ByVal perspective_transform As D2D1_MATRIX_4X4_F Ptr )
    	' 87. InvalidateEffectInputRectangle
    InvalidateEffectInputRectangle As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal effect As Any Ptr, ByVal input As ULong, ByVal input_rect As D2D1_RECT_F Ptr ) As HRESULT
    	' 88. GetEffectInvalidRectangleCount
    GetEffectInvalidRectangleCount As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal effect As Any Ptr, ByVal rect_count As ULong Ptr ) As HRESULT
    	' 89. GetEffectInvalidRectangles
    GetEffectInvalidRectangles As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal effect As Any Ptr, ByVal rectangles As D2D1_RECT_F Ptr, ByVal rect_count As ULong ) As HRESULT
    	' 90. GetEffectRequiredInputRectangles
    GetEffectRequiredInputRectangles As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal effect As Any Ptr, ByVal image_rect As D2D1_RECT_F Ptr, ByVal desc As D2D1_EFFECT_INPUT_DESCRIPTION Ptr, ByVal input_rects As D2D1_RECT_F Ptr, ByVal input_count As ULong ) As HRESULT
    	' 91. FillOpacityMask (überladen)
    FillOpacityMask1 As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal mask As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal content As D2D1_OPACITY_MASK_CONTENT, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal src_rect As D2D1_RECT_F Ptr )
    	' 92. PushLayer
    PushLayer1 As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal layer_parameters As D2D1_LAYER_PARAMETERS1 Ptr, ByVal layer As ID2D1Layer Ptr )
        ' Erbt alle Methoden von ID2D1DeviceContext (1-96 Methoden)
        ' 97. CreateFilledGeometryRealization
    CreateFilledGeometryRealization As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal tolerance As Single, ByVal realization As Any Ptr Ptr ) As HRESULT
        ' 98. CreateStrokedGeometryRealization
    CreateStrokedGeometryRealization As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal tolerance As Single, ByVal stroke_width As Single, ByVal stroke_style As ID2D1StrokeStyle Ptr, ByVal realization As Any Ptr Ptr ) As HRESULT
        ' 99. DrawGeometryRealization
    DrawGeometryRealization As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal realization As ID2D1GeometryRealization Ptr, ByVal brush As ID2D1Brush Ptr )
        ' Erbt alle Methoden von ID2D1DeviceContext1
        ' Neue Methoden
    CreateInk As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal start_point As D2D1_INK_POINT Ptr, ByVal ink As Any Ptr Ptr ) As HRESULT
    CreateInkStyle As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal ink_style_properties As D2D1_INK_STYLE_PROPERTIES Ptr, ByVal ink_style As Any Ptr Ptr ) As HRESULT
    CreateGradientMesh As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal patches As D2D1_GRADIENT_MESH_PATCH Ptr, ByVal patches_count As ULong, ByVal gradient_mesh As Any Ptr Ptr ) As HRESULT
    CreateImageSourceFromWic As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal wic_bitmap_source As Any Ptr, ByVal loading_options As D2D1_IMAGE_SOURCE_LOADING_OPTIONS, ByVal alpha_mode As D2D1_ALPHA_MODE, ByVal image_source As Any Ptr Ptr ) As HRESULT
    CreateLookupTable3D As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal precision As ULong, ByVal extents As ULong Ptr, ByVal data As UByte Ptr, ByVal data_count As ULong, ByVal strides As ULong Ptr, ByVal lookup_table As Any Ptr Ptr ) As HRESULT
    CreateImageSourceFromDxgi As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal surfaces As Any Ptr Ptr, ByVal surface_count As ULong, ByVal color_space As ULong, ByVal options As D2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS, ByVal image_source As Any Ptr Ptr ) As HRESULT
    GetGradientMeshWorldBounds As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal gradient_mesh As ID2D1GradientMesh Ptr, ByVal bounds As D2D1_RECT_F Ptr ) As HRESULT
    DrawInk As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal ink As ID2D1Ink Ptr, ByVal brush As ID2D1Brush Ptr, ByVal ink_style As ID2D1InkStyle Ptr )
    DrawGradientMesh As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal gradient_mesh As ID2D1GradientMesh Ptr )
    DrawGdiMetafile1 As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal gdi_metafile As Any Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal src_rect As D2D1_RECT_F Ptr )
    CreateTransformedImageSource As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal source As ID2D1ImageSource Ptr, ByVal props As D2D1_TRANSFORMED_IMAGE_SOURCE_PROPERTIES Ptr, ByVal transformed As Any Ptr Ptr ) As HRESULT
        ' Erbt von ID2D1DeviceContext2
    CreateSpriteBatch As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal sprite_batch As Any Ptr Ptr ) As HRESULT
    DrawSpriteBatch As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal sprite_batch As ID2D1SpriteBatch Ptr, ByVal start_index As ULong, ByVal sprite_count As ULong, ByVal bitmap As ID2D1Bitmap Ptr, ByVal interpolation_mode As D2D1_BITMAP_INTERPOLATION_MODE, ByVal sprite_options As D2D1_SPRITE_OPTIONS )
        ' Erbt von ID2D1DeviceContext3
    CreateSvgGlyphStyle As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal svg_glyph_style As Any Ptr Ptr ) As HRESULT
        ' DrawText - Überladen mit zusätzlichen Parametern
    DrawText1 As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal string As WString Ptr, ByVal string_length As ULong, ByVal text_format As Any Ptr, ByVal layout_rect As D2D1_RECT_F Ptr, ByVal default_fill_brush As ID2D1Brush Ptr, ByVal svg_glyph_style As ID2D1SvgGlyphStyle Ptr, ByVal color_palette_index As ULong, ByVal options As D2D1_DRAW_TEXT_OPTIONS, ByVal measuring_mode As ULong )
    DrawTextLayout1 As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal origin As D2D1_POINT_2F, ByVal text_layout As Any Ptr, ByVal default_fill_brush As ID2D1Brush Ptr, ByVal svg_glyph_style As ID2D1SvgGlyphStyle Ptr, ByVal color_palette_index As ULong, ByVal options As D2D1_DRAW_TEXT_OPTIONS )
    DrawColorBitmapGlyphRun As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal glyph_image_format As ULong, ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal measuring_mode As ULong, ByVal bitmap_snap_option As D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION )
    DrawSvgGlyphRun As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal default_fill_brush As ID2D1Brush Ptr, ByVal svg_glyph_style As ID2D1SvgGlyphStyle Ptr, ByVal color_palette_index As ULong, ByVal measuring_mode As ULong )
    GetColorBitmapGlyphImage As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal glyph_image_format As ULong, ByVal glyph_origin As D2D1_POINT_2F, ByVal font_face As Any Ptr, ByVal font_em_size As Single, ByVal glyph_index As UShort, ByVal is_sideways As Long, ByVal world_transform As D2D1_MATRIX_3X2_F Ptr, ByVal dpi_x As Single, ByVal dpi_y As Single, ByVal glyph_transform As D2D1_MATRIX_3X2_F Ptr, ByVal glyph_image As Any Ptr Ptr ) As HRESULT
    GetSvgGlyphImage As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal glyph_origin As D2D1_POINT_2F, ByVal font_face As Any Ptr, ByVal font_em_size As Single, ByVal glyph_index As UShort, ByVal is_sideways As Long, ByVal world_transform As D2D1_MATRIX_3X2_F Ptr, ByVal default_fill_brush As ID2D1Brush Ptr, ByVal svg_glyph_style As ID2D1SvgGlyphStyle Ptr, ByVal color_palette_index As ULong, ByVal glyph_transform As D2D1_MATRIX_3X2_F Ptr, ByVal glyph_image As Any Ptr Ptr ) As HRESULT
        ' Erbt von ID2D1DeviceContext4
    CreateSvgDocument As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal input_xml_stream As Any Ptr, ByVal viewport_size As D2D1_SIZE_F, ByVal svg_document As Any Ptr Ptr ) As HRESULT
    DrawSvgDocument As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal svg_document As Any Ptr )
    CreateColorContextFromDxgiColorSpace As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal color_space As ULong, ByVal color_context As Any Ptr Ptr ) As HRESULT
    CreateColorContextFromSimpleColorProfile As Function(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal simple_profile As D2D1_SIMPLE_COLOR_PROFILE Ptr, ByVal color_context As Any Ptr Ptr ) As HRESULT

        ' Erbt von ID2D1DeviceContext5
    BlendImage As Sub(ByVal This As ID2D1DeviceContext6 Ptr,  ByVal image As ID2D1Image Ptr, ByVal blend_mode As D2D1_BLEND_MODE, ByVal target_offset As D2D1_POINT_2F Ptr, ByVal image_rect As D2D1_RECT_F Ptr, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE )
End Type
#define ID2D1DeviceContext6_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1DeviceContext6_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1DeviceContext6_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1DeviceContext6_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1DeviceContext6_CreateBitmap(p, a, b, c, d, e) (p)->lpVtbl->CreateBitmap(p, a, b, c, d, e)
#define ID2D1DeviceContext6_CreateBitmapFromWicBitmap(p, a, b, c) (p)->lpVtbl->CreateBitmapFromWicBitmap(p, a, b, c)
#define ID2D1DeviceContext6_CreateSharedBitmap(p, a, b, c, d) (p)->lpVtbl->CreateSharedBitmap(p, a, b, c, d)
#define ID2D1DeviceContext6_CreateBitmapBrush(p, a, b, c, d) (p)->lpVtbl->CreateBitmapBrush(p, a, b, c, d)
#define ID2D1DeviceContext6_CreateSolidColorBrush(p, a, b, c) (p)->lpVtbl->CreateSolidColorBrush(p, a, b, c)
#define ID2D1DeviceContext6_CreateGradientStopCollection(p, a, b, c, d, e) (p)->lpVtbl->CreateGradientStopCollection(p, a, b, c, d, e)
#define ID2D1DeviceContext6_CreateLinearGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateLinearGradientBrush(p, a, b, c, d)
#define ID2D1DeviceContext6_CreateRadialGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateRadialGradientBrush(p, a, b, c, d)
#define ID2D1DeviceContext6_CreateCompatibleRenderTarget(p, a, b, c, d, e) (p)->lpVtbl->CreateCompatibleRenderTarget(p, a, b, c, d, e)
#define ID2D1DeviceContext6_CreateLayer(p, a, b) (p)->lpVtbl->CreateLayer(p, a, b)
#define ID2D1DeviceContext6_CreateMesh(p, a) (p)->lpVtbl->CreateMesh(p, a)
#define ID2D1DeviceContext6_DrawLine(p, a, b, c, d, e) (p)->lpVtbl->DrawLine(p, a, b, c, d, e)
#define ID2D1DeviceContext6_DrawRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRectangle(p, a, b, c, d)
#define ID2D1DeviceContext6_FillRectangle(p, a, b) (p)->lpVtbl->FillRectangle(p, a, b)
#define ID2D1DeviceContext6_DrawRoundedRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRoundedRectangle(p, a, b, c, d)
#define ID2D1DeviceContext6_FillRoundedRectangle(p, a, b) (p)->lpVtbl->FillRoundedRectangle(p, a, b)
#define ID2D1DeviceContext6_DrawEllipse(p, a, b, c, d) (p)->lpVtbl->DrawEllipse(p, a, b, c, d)
#define ID2D1DeviceContext6_FillEllipse(p, a, b) (p)->lpVtbl->FillEllipse(p, a, b)
#define ID2D1DeviceContext6_DrawGeometry(p, a, b, c, d) (p)->lpVtbl->DrawGeometry(p, a, b, c, d)
#define ID2D1DeviceContext6_FillGeometry(p, a, b, c) (p)->lpVtbl->FillGeometry(p, a, b, c)
#define ID2D1DeviceContext6_FillMesh(p, a, b) (p)->lpVtbl->FillMesh(p, a, b)
#define ID2D1DeviceContext6_FillOpacityMask(p, a, b, c, d, e) (p)->lpVtbl->FillOpacityMask(p, a, b, c, d, e)
#define ID2D1DeviceContext6_DrawBitmap(p, a, b, c, d, e) (p)->lpVtbl->DrawBitmap(p, a, b, c, d, e)
#define ID2D1DeviceContext6_DrawText(p, a, b, c, d, e, f, g) (p)->lpVtbl->DrawText(p, a, b, c, d, e, f, g)
#define ID2D1DeviceContext6_DrawTextLayout(p, a, b, c, d) (p)->lpVtbl->DrawTextLayout(p, a, b, c, d)
#define ID2D1DeviceContext6_DrawGlyphRun(p, a, b, c, d) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d)
#define ID2D1DeviceContext6_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1DeviceContext6_GetTransform(p, a) (p)->lpVtbl->GetTransform(p, a)
#define ID2D1DeviceContext6_SetAntialiasMode(p, a) (p)->lpVtbl->SetAntialiasMode(p, a)
#define ID2D1DeviceContext6_GetAntialiasMode(p, a) (p)->lpVtbl->GetAntialiasMode(p, a)
#define ID2D1DeviceContext6_SetTextAntialiasMode(p, a) (p)->lpVtbl->SetTextAntialiasMode(p, a)
#define ID2D1DeviceContext6_GetTextAntialiasMode(p, a) (p)->lpVtbl->GetTextAntialiasMode(p, a)
#define ID2D1DeviceContext6_SetTextRenderingParams(p, a) (p)->lpVtbl->SetTextRenderingParams(p, a)
#define ID2D1DeviceContext6_GetTextRenderingParams(p, a) (p)->lpVtbl->GetTextRenderingParams(p, a)
#define ID2D1DeviceContext6_SetTags(p, a, b) (p)->lpVtbl->SetTags(p, a, b)
#define ID2D1DeviceContext6_GetTags(p, a, b) (p)->lpVtbl->GetTags(p, a, b)
#define ID2D1DeviceContext6_PushLayer(p, a, b) (p)->lpVtbl->PushLayer(p, a, b)
#define ID2D1DeviceContext6_PopLayer(p, a) (p)->lpVtbl->PopLayer(p, a)
#define ID2D1DeviceContext6_Flush(p, a, b) (p)->lpVtbl->Flush(p, a, b)
#define ID2D1DeviceContext6_SaveDrawingState(p, a) (p)->lpVtbl->SaveDrawingState(p, a)
#define ID2D1DeviceContext6_RestoreDrawingState(p, a) (p)->lpVtbl->RestoreDrawingState(p, a)
#define ID2D1DeviceContext6_PushAxisAlignedClip(p, a, b) (p)->lpVtbl->PushAxisAlignedClip(p, a, b)
#define ID2D1DeviceContext6_PopAxisAlignedClip(p, a) (p)->lpVtbl->PopAxisAlignedClip(p, a)
#define ID2D1DeviceContext6_Clear(p, a) (p)->lpVtbl->Clear(p, a)
#define ID2D1DeviceContext6_BeginDraw(p, a) (p)->lpVtbl->BeginDraw(p, a)
#define ID2D1DeviceContext6_EndDraw(p, a, b) (p)->lpVtbl->EndDraw(p, a, b)
#define ID2D1DeviceContext6_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)
#define ID2D1DeviceContext6_SetDpi(p, a, b) (p)->lpVtbl->SetDpi(p, a, b)
#define ID2D1DeviceContext6_GetDpi(p, a, b) (p)->lpVtbl->GetDpi(p, a, b)
#define ID2D1DeviceContext6_GetSize(p, a) (p)->lpVtbl->GetSize(p, a)
#define ID2D1DeviceContext6_GetPixelSize(p, a) (p)->lpVtbl->GetPixelSize(p, a)
#define ID2D1DeviceContext6_GetMaximumBitmapSize(p, a) (p)->lpVtbl->GetMaximumBitmapSize(p, a)
#define ID2D1DeviceContext6_IsSupported(p, a) (p)->lpVtbl->IsSupported(p, a)
#define ID2D1DeviceContext6_CreateBitmap1(p, a, b, c, d, e) (p)->lpVtbl->CreateBitmap1(p, a, b, c, d, e)
#define ID2D1DeviceContext6_CreateBitmapFromWicBitmap1(p, a, b, c) (p)->lpVtbl->CreateBitmapFromWicBitmap1(p, a, b, c)
#define ID2D1DeviceContext6_CreateColorContext(p, a, b, c, d) (p)->lpVtbl->CreateColorContext(p, a, b, c, d)
#define ID2D1DeviceContext6_CreateColorContextFromFilename(p, a, b) (p)->lpVtbl->CreateColorContextFromFilename(p, a, b)
#define ID2D1DeviceContext6_CreateColorContextFromWicColorContext(p, a, b) (p)->lpVtbl->CreateColorContextFromWicColorContext(p, a, b)
#define ID2D1DeviceContext6_CreateBitmapFromDxgiSurface(p, a, b, c) (p)->lpVtbl->CreateBitmapFromDxgiSurface(p, a, b, c)
#define ID2D1DeviceContext6_CreateEffect(p, a, b) (p)->lpVtbl->CreateEffect(p, a, b)
#define ID2D1DeviceContext6_CreateGradientStopCollection1(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateGradientStopCollection1(p, a, b, c, d, e, f, g, h)
#define ID2D1DeviceContext6_CreateImageBrush(p, a, b, c, d) (p)->lpVtbl->CreateImageBrush(p, a, b, c, d)
#define ID2D1DeviceContext6_CreateBitmapBrush1(p, a, b, c, d) (p)->lpVtbl->CreateBitmapBrush1(p, a, b, c, d)
#define ID2D1DeviceContext6_CreateCommandList(p, a) (p)->lpVtbl->CreateCommandList(p, a)
#define ID2D1DeviceContext6_IsDxgiFormatSupported(p, a) (p)->lpVtbl->IsDxgiFormatSupported(p, a)
#define ID2D1DeviceContext6_IsBufferPrecisionSupported(p, a) (p)->lpVtbl->IsBufferPrecisionSupported(p, a)
#define ID2D1DeviceContext6_GetImageLocalBounds(p, a, b) (p)->lpVtbl->GetImageLocalBounds(p, a, b)
#define ID2D1DeviceContext6_GetImageWorldBounds(p, a, b) (p)->lpVtbl->GetImageWorldBounds(p, a, b)
#define ID2D1DeviceContext6_GetGlyphRunWorldBounds(p, a, b, c, d) (p)->lpVtbl->GetGlyphRunWorldBounds(p, a, b, c, d)
#define ID2D1DeviceContext6_GetDevice(p, a) (p)->lpVtbl->GetDevice(p, a)
#define ID2D1DeviceContext6_SetTarget(p, a) (p)->lpVtbl->SetTarget(p, a)
#define ID2D1DeviceContext6_GetTarget(p, a) (p)->lpVtbl->GetTarget(p, a)
#define ID2D1DeviceContext6_SetRenderingControls(p, a) (p)->lpVtbl->SetRenderingControls(p, a)
#define ID2D1DeviceContext6_GetRenderingControls(p, a) (p)->lpVtbl->GetRenderingControls(p, a)
#define ID2D1DeviceContext6_SetPrimitiveBlend(p, a) (p)->lpVtbl->SetPrimitiveBlend(p, a)
#define ID2D1DeviceContext6_GetPrimitiveBlend(p, a) (p)->lpVtbl->GetPrimitiveBlend(p, a)
#define ID2D1DeviceContext6_SetUnitMode(p, a) (p)->lpVtbl->SetUnitMode(p, a)
#define ID2D1DeviceContext6_GetUnitMode(p, a) (p)->lpVtbl->GetUnitMode(p, a)
#define ID2D1DeviceContext6_DrawGlyphRun1(p, a, b, c, d, e) (p)->lpVtbl->DrawGlyphRun1(p, a, b, c, d, e)
#define ID2D1DeviceContext6_DrawImage(p, a, b, c, d, e) (p)->lpVtbl->DrawImage(p, a, b, c, d, e)
#define ID2D1DeviceContext6_DrawGdiMetafile(p, a, b) (p)->lpVtbl->DrawGdiMetafile(p, a, b)
#define ID2D1DeviceContext6_DrawBitmap1(p, a, b, c, d, e, f) (p)->lpVtbl->DrawBitmap1(p, a, b, c, d, e, f)
#define ID2D1DeviceContext6_InvalidateEffectInputRectangle(p, a, b, c) (p)->lpVtbl->InvalidateEffectInputRectangle(p, a, b, c)
#define ID2D1DeviceContext6_GetEffectInvalidRectangleCount(p, a, b) (p)->lpVtbl->GetEffectInvalidRectangleCount(p, a, b)
#define ID2D1DeviceContext6_GetEffectInvalidRectangles(p, a, b, c) (p)->lpVtbl->GetEffectInvalidRectangles(p, a, b, c)
#define ID2D1DeviceContext6_GetEffectRequiredInputRectangles(p, a, b, c, d, e) (p)->lpVtbl->GetEffectRequiredInputRectangles(p, a, b, c, d, e)
#define ID2D1DeviceContext6_FillOpacityMask1(p, a, b, c, d, e) (p)->lpVtbl->FillOpacityMask1(p, a, b, c, d, e)
#define ID2D1DeviceContext6_PushLayer1(p, a, b) (p)->lpVtbl->PushLayer1(p, a, b)
#define ID2D1DeviceContext6_CreateFilledGeometryRealization(p, a, b, c) (p)->lpVtbl->CreateFilledGeometryRealization(p, a, b, c)
#define ID2D1DeviceContext6_CreateStrokedGeometryRealization(p, a, b, c, d, e) (p)->lpVtbl->CreateStrokedGeometryRealization(p, a, b, c, d, e)
#define ID2D1DeviceContext6_DrawGeometryRealization(p, a, b) (p)->lpVtbl->DrawGeometryRealization(p, a, b)
#define ID2D1DeviceContext6_CreateInk(p, a, b) (p)->lpVtbl->CreateInk(p, a, b)
#define ID2D1DeviceContext6_CreateInkStyle(p, a, b) (p)->lpVtbl->CreateInkStyle(p, a, b)
#define ID2D1DeviceContext6_CreateGradientMesh(p, a, b, c) (p)->lpVtbl->CreateGradientMesh(p, a, b, c)
#define ID2D1DeviceContext6_CreateImageSourceFromWic(p, a, b, c, d) (p)->lpVtbl->CreateImageSourceFromWic(p, a, b, c, d)
#define ID2D1DeviceContext6_CreateLookupTable3D(p, a, b, c, d, e, f) (p)->lpVtbl->CreateLookupTable3D(p, a, b, c, d, e, f)
#define ID2D1DeviceContext6_CreateImageSourceFromDxgi(p, a, b, c, d, e) (p)->lpVtbl->CreateImageSourceFromDxgi(p, a, b, c, d, e)
#define ID2D1DeviceContext6_GetGradientMeshWorldBounds(p, a, b) (p)->lpVtbl->GetGradientMeshWorldBounds(p, a, b)
#define ID2D1DeviceContext6_DrawInk(p, a, b, c) (p)->lpVtbl->DrawInk(p, a, b, c)
#define ID2D1DeviceContext6_DrawGradientMesh(p, a) (p)->lpVtbl->DrawGradientMesh(p, a)
#define ID2D1DeviceContext6_DrawGdiMetafile1(p, a, b, c) (p)->lpVtbl->DrawGdiMetafile1(p, a, b, c)
#define ID2D1DeviceContext6_CreateTransformedImageSource(p, a, b, c) (p)->lpVtbl->CreateTransformedImageSource(p, a, b, c)
#define ID2D1DeviceContext6_CreateSpriteBatch(p, a) (p)->lpVtbl->CreateSpriteBatch(p, a)
#define ID2D1DeviceContext6_DrawSpriteBatch(p, a, b, c, d, e, f) (p)->lpVtbl->DrawSpriteBatch(p, a, b, c, d, e, f)
#define ID2D1DeviceContext6_CreateSvgGlyphStyle(p, a) (p)->lpVtbl->CreateSvgGlyphStyle(p, a)
#define ID2D1DeviceContext6_DrawText1(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->DrawText1(p, a, b, c, d, e, f, g, h, i)
#define ID2D1DeviceContext6_DrawTextLayout1(p, a, b, c, d, e, f) (p)->lpVtbl->DrawTextLayout1(p, a, b, c, d, e, f)
#define ID2D1DeviceContext6_DrawColorBitmapGlyphRun(p, a, b, c, d, e) (p)->lpVtbl->DrawColorBitmapGlyphRun(p, a, b, c, d, e)
#define ID2D1DeviceContext6_DrawSvgGlyphRun(p, a, b, c, d, e, f) (p)->lpVtbl->DrawSvgGlyphRun(p, a, b, c, d, e, f)
#define ID2D1DeviceContext6_GetColorBitmapGlyphImage(p, a, b, c, d, e, f, g, h, i, j, k) (p)->lpVtbl->GetColorBitmapGlyphImage(p, a, b, c, d, e, f, g, h, i, j, k)
#define ID2D1DeviceContext6_GetSvgGlyphImage(p, a, b, c, d, e, f, g, h, i, j, k) (p)->lpVtbl->GetSvgGlyphImage(p, a, b, c, d, e, f, g, h, i, j, k)
#define ID2D1DeviceContext6_CreateSvgDocument(p, a, b, c) (p)->lpVtbl->CreateSvgDocument(p, a, b, c)
#define ID2D1DeviceContext6_DrawSvgDocument(p, a) (p)->lpVtbl->DrawSvgDocument(p, a)
#define ID2D1DeviceContext6_CreateColorContextFromDxgiColorSpace(p, a, b) (p)->lpVtbl->CreateColorContextFromDxgiColorSpace(p, a, b)
#define ID2D1DeviceContext6_CreateColorContextFromSimpleColorProfile(p, a, b) (p)->lpVtbl->CreateColorContextFromSimpleColorProfile(p, a, b)
#define ID2D1DeviceContext6_BlendImage(p, a, b, c, d, e) (p)->lpVtbl->BlendImage(p, a, b, c, d, e)

' ============================================================================
' ID2D1DeviceContext7
' ============================================================================
Type ID2D1DeviceContext7Vtbl As ID2D1DeviceContext7Vtbl_
Type ID2D1DeviceContext7
    lpVtbl As ID2D1DeviceContext7Vtbl Ptr
End Type
Type ID2D1DeviceContext7Vtbl_     '' Extends ID2D1DeviceContext6Vtbl_
    QueryInterface As Function(ByVal This As ID2D1DeviceContext7 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1DeviceContext7 Ptr) As ULong
    Release As Function(ByVal This As ID2D1DeviceContext7 Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal factory As Any Ptr Ptr)
        ' 4.   (ID2D1Resource: GetFactory)
    CreateBitmap As Function(ByVal This As ID2D1DeviceContext7 Ptr, ByVal size As D2D1_SIZE_U, ByVal srcData As Any Ptr, ByVal pitch As ULong, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapFromWicBitmap As Function(ByVal This As ID2D1DeviceContext7 Ptr, ByVal wicBitmapSource As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateSharedBitmap As Function(ByVal This As ID2D1DeviceContext7 Ptr, ByVal riid As GUID Ptr, ByVal data As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapBrush As Function(ByVal This As ID2D1DeviceContext7 Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal bitmapBrushProperties As D2D1_BITMAP_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal bitmapBrush As ID2D1BitmapBrush Ptr Ptr) As HRESULT
    CreateSolidColorBrush As Function(ByVal This As ID2D1DeviceContext7 Ptr, ByVal color As D2D1_COLOR_F Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal solidColorBrush As ID2D1SolidColorBrush Ptr Ptr) As HRESULT
    CreateGradientStopCollection As Function(ByVal This As ID2D1DeviceContext7 Ptr, ByVal gradientStops As D2D1_GRADIENT_STOP Ptr, ByVal gradientStopsCount As ULong, ByVal colorInterpolationGamma As D2D1_GAMMA, ByVal extendMode As D2D1_EXTEND_MODE, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr Ptr) As HRESULT
    CreateLinearGradientBrush As Function(ByVal This As ID2D1DeviceContext7 Ptr, ByVal linearGradientBrushProperties As D2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal linearGradientBrush As ID2D1LinearGradientBrush Ptr Ptr) As HRESULT
    CreateRadialGradientBrush As Function(ByVal This As ID2D1DeviceContext7 Ptr, ByVal radialGradientBrushProperties As D2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal radialGradientBrush As ID2D1RadialGradientBrush Ptr Ptr) As HRESULT
    CreateCompatibleRenderTarget As Function(ByVal This As ID2D1DeviceContext7 Ptr, ByVal desiredSize As D2D1_SIZE_F Ptr, ByVal desiredPixelSize As D2D1_SIZE_U Ptr, ByVal desiredFormat As D2D1_PIXEL_FORMAT Ptr, ByVal options As ULong, ByVal bitmapRenderTarget As Any Ptr Ptr) As HRESULT 'ID2D1BitmapRenderTarget
    CreateLayer As Function(ByVal This As ID2D1DeviceContext7 Ptr, ByVal size As D2D1_SIZE_F Ptr, ByVal layer As ID2D1Layer Ptr Ptr) As HRESULT
    CreateMesh As Function(ByVal This As ID2D1DeviceContext7 Ptr, ByVal mesh As ID2D1Mesh Ptr Ptr) As HRESULT
    DrawLine As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal p0 As D2D1_POINT_2F, ByVal p1 As D2D1_POINT_2F, ByVal brush As ID2D1SolidColorBrush Ptr, ByVal strokeWidth As Single = 0, ByVal strokeStyle As ID2D1StrokeStyle Ptr = NULL)
    DrawRectangle As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRectangle As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawRoundedRectangle As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRoundedRectangle As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawEllipse As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillEllipse As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawGeometry As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillGeometry As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal opacityBrush As ID2D1Brush Ptr)
    FillMesh As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal mesh As ID2D1Mesh Ptr, ByVal brush As ID2D1Brush Ptr)
    FillOpacityMask As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal mask As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal content As D2D1_OPACITY_MASK_CONTENT, ByVal destRect As D2D1_RECT_F Ptr, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawBitmap As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal destRect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolationMode As D2D1_BITMAP_INTERPOLATION_MODE, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawText As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal text As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal layoutRect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS = 0, ByVal measuringMode As DWRITE_MEASURING_MODE = 0)
    DrawTextLayout As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal origin As D2D1_POINT_2F Ptr, ByVal layout As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS)
    DrawGlyphRun As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal baselineOrigin As D2D1_POINT_2F Ptr, ByVal glyphRun As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE)
    SetTransform As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    GetTransform As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    SetAntialiasMode As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    GetAntialiasMode As Function(ByVal This As ID2D1DeviceContext7 Ptr) As D2D1_ANTIALIAS_MODE
    SetTextAntialiasMode As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal antialiasMode As D2D1_TEXT_ANTIALIAS_MODE)
    GetTextAntialiasMode As Function(ByVal This As ID2D1DeviceContext7 Ptr) As D2D1_TEXT_ANTIALIAS_MODE
    SetTextRenderingParams As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal params As Any Ptr)
    GetTextRenderingParams As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal params As Any Ptr Ptr)
    SetTags As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal tag1 As D2D1_TAG, ByVal tag2 As D2D1_TAG)
    GetTags As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr)
    PushLayer As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal layerParams As D2D1_LAYER_PARAMETERS Ptr, ByVal layer As ID2D1Layer Ptr)
    PopLayer As Sub(ByVal This As ID2D1DeviceContext7 Ptr)
    Flush As Function(ByVal This As ID2D1DeviceContext7 Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    SaveDrawingState As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal stateBlock As Any Ptr)
    RestoreDrawingState As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal stateBlock As Any Ptr)
    PushAxisAlignedClip As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    PopAxisAlignedClip As Sub(ByVal This As ID2D1DeviceContext7 Ptr)
    Clear As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal col As D2D1_COLOR_F Ptr)
    BeginDraw As Sub(ByVal This As ID2D1DeviceContext7 Ptr)
    EndDraw As Function(ByVal This As ID2D1DeviceContext7 Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    GetPixelFormat As Function(ByVal This As ID2D1DeviceContext7 Ptr) As D2D1_PIXEL_FORMAT
    SetDpi As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal dpiX As Single, ByVal dpiY As Single)
    GetDpi As Sub(ByVal This As ID2D1DeviceContext7 Ptr, ByVal dpiX As Single Ptr, ByVal dpiY As Single Ptr)
    GetSize As Function(ByVal This As ID2D1DeviceContext7 Ptr, ByVal size As Any Ptr) As D2D1_SIZE_F
    GetPixelSize As Function(ByVal This As ID2D1DeviceContext7 Ptr, ByVal pixelSize As Any Ptr) As D2D1_SIZE_U
    GetMaximumBitmapSize As Function(ByVal This As ID2D1DeviceContext7 Ptr) As ULong
    IsSupported As Function(ByVal This As ID2D1DeviceContext7 Ptr, ByVal renderTargetProperties As D2D1_RENDER_TARGET_PROPERTIES Ptr) As BOOL
        ' Erbt alle Methoden von ID2D1RenderTarget (1-57)
    	' 58. CreateBitmap (überladen)
    CreateBitmap1 As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal size As D2D1_SIZE_U, ByVal src_data As Any Ptr, ByVal pitch As ULong, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As Any Ptr Ptr ) As HRESULT
    	' 59. CreateBitmapFromWicBitmap (überladen)
    CreateBitmapFromWicBitmap1 As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal bitmap_source As IUnknownBase Ptr, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As ID2D1Bitmap1 Ptr Ptr ) As HRESULT
    	' 60. CreateColorContext
    CreateColorContext As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal space As D2D1_COLOR_SPACE, ByVal profile As UByte Ptr, ByVal profile_size As ULong, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 61. CreateColorContextFromFilename
    CreateColorContextFromFilename As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal filename As WString Ptr, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 62. CreateColorContextFromWicColorContext
    CreateColorContextFromWicColorContext As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal wic_color_context As Any Ptr, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 63. CreateBitmapFromDxgiSurface
    CreateBitmapFromDxgiSurface As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal surface As Any Ptr, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As Any Ptr Ptr ) As HRESULT
    	' 64. CreateEffect
    CreateEffect As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByRef effect_id As GUID, ByVal effect As ID2D1Effect Ptr Ptr ) As HRESULT
    	' 65. CreateGradientStopCollection (überladen)
    CreateGradientStopCollection1 As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal stops As D2D1_GRADIENT_STOP Ptr, ByVal stop_count As ULong, ByVal preinterpolation_space As D2D1_COLOR_SPACE, ByVal postinterpolation_space As D2D1_COLOR_SPACE, ByVal buffer_precision As D2D1_BUFFER_PRECISION, ByVal extend_mode As D2D1_EXTEND_MODE, ByVal color_interpolation_mode As D2D1_COLOR_INTERPOLATION_MODE, ByVal gradient As Any Ptr Ptr ) As HRESULT
    	' 66. CreateImageBrush
    CreateImageBrush As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal image As ID2D1Image Ptr, ByVal image_brush_desc As D2D1_IMAGE_BRUSH_PROPERTIES Ptr, ByVal brush_desc As D2D1_BRUSH_PROPERTIES Ptr, ByVal brush As Any Ptr Ptr ) As HRESULT
    	' 67. CreateBitmapBrush (überladen)
    CreateBitmapBrush1 As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal bitmap_brush_desc As D2D1_BITMAP_BRUSH_PROPERTIES1 Ptr, ByVal brush_desc As D2D1_BRUSH_PROPERTIES Ptr, ByVal bitmap_brush As Any Ptr Ptr ) As HRESULT
    	' 68. CreateCommandList
    CreateCommandList As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal command_list As Any Ptr Ptr ) As HRESULT
    	' 69. IsDxgiFormatSupported
    IsDxgiFormatSupported As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal format As ULong ) As Long
    	' 70. IsBufferPrecisionSupported
    IsBufferPrecisionSupported As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal buffer_precision As D2D1_BUFFER_PRECISION ) As Long
    	' 71. GetImageLocalBounds
    GetImageLocalBounds As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal image As ID2D1Image Ptr, ByVal local_bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 72. GetImageWorldBounds
    GetImageWorldBounds As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal image As ID2D1Image Ptr, ByVal world_bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 73. GetGlyphRunWorldBounds
    GetGlyphRunWorldBounds As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal measuring_mode As ULong, ByVal bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 74. GetDevice
    GetDevice As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal device As Any Ptr Ptr )
    	' 75. SetTarget
    SetTarget As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal target As ID2D1Image Ptr )
    	' 76. GetTarget
    GetTarget As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal target As Any Ptr Ptr )
    	' 77. SetRenderingControls
    SetRenderingControls As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal rendering_controls As D2D1_RENDERING_CONTROLS Ptr )
    	' 78. GetRenderingControls
    GetRenderingControls As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal rendering_controls As D2D1_RENDERING_CONTROLS Ptr )
    	' 79. SetPrimitiveBlend
    SetPrimitiveBlend As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal primitive_blend As D2D1_PRIMITIVE_BLEND )
    	' 80. GetPrimitiveBlend
    GetPrimitiveBlend As Function(ByVal This As ID2D1DeviceContext7 Ptr) As D2D1_PRIMITIVE_BLEND
    	' 81. SetUnitMode
    SetUnitMode As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal unit_mode As D2D1_UNIT_MODE )
    	' 82. GetUnitMode
    GetUnitMode As Function(ByVal This As ID2D1DeviceContext7 Ptr) As D2D1_UNIT_MODE
    	' 83. DrawGlyphRun (überladen)
    DrawGlyphRun1 As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal glyph_run_desc As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuring_mode As ULong )
    	' 84. DrawImage
    DrawImage As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal image As ID2D1Image Ptr, ByVal target_offset As D2D1_POINT_2F Ptr = 0, ByVal image_rect As D2D1_RECT_F Ptr = 0, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR, ByVal composite_mode As D2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER )
    	' 85. DrawGdiMetafile
    DrawGdiMetafile As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal metafile As ID2D1GdiMetafile Ptr, ByVal target_offset As D2D1_POINT_2F Ptr )
    	' 86. DrawBitmap (überladen)
    DrawBitmap1 As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE, ByVal src_rect As D2D1_RECT_F Ptr, ByVal perspective_transform As D2D1_MATRIX_4X4_F Ptr )
    	' 87. InvalidateEffectInputRectangle
    InvalidateEffectInputRectangle As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal effect As Any Ptr, ByVal input As ULong, ByVal input_rect As D2D1_RECT_F Ptr ) As HRESULT
    	' 88. GetEffectInvalidRectangleCount
    GetEffectInvalidRectangleCount As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal effect As Any Ptr, ByVal rect_count As ULong Ptr ) As HRESULT
    	' 89. GetEffectInvalidRectangles
    GetEffectInvalidRectangles As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal effect As Any Ptr, ByVal rectangles As D2D1_RECT_F Ptr, ByVal rect_count As ULong ) As HRESULT
    	' 90. GetEffectRequiredInputRectangles
    GetEffectRequiredInputRectangles As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal effect As Any Ptr, ByVal image_rect As D2D1_RECT_F Ptr, ByVal desc As D2D1_EFFECT_INPUT_DESCRIPTION Ptr, ByVal input_rects As D2D1_RECT_F Ptr, ByVal input_count As ULong ) As HRESULT
    	' 91. FillOpacityMask (überladen)
    FillOpacityMask1 As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal mask As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal content As D2D1_OPACITY_MASK_CONTENT, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal src_rect As D2D1_RECT_F Ptr )
    	' 92. PushLayer
    PushLayer1 As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal layer_parameters As D2D1_LAYER_PARAMETERS1 Ptr, ByVal layer As ID2D1Layer Ptr )
        ' Erbt alle Methoden von ID2D1DeviceContext (1-96 Methoden)
        ' 97. CreateFilledGeometryRealization
    CreateFilledGeometryRealization As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal tolerance As Single, ByVal realization As Any Ptr Ptr ) As HRESULT
        ' 98. CreateStrokedGeometryRealization
    CreateStrokedGeometryRealization As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal tolerance As Single, ByVal stroke_width As Single, ByVal stroke_style As ID2D1StrokeStyle Ptr, ByVal realization As Any Ptr Ptr ) As HRESULT
        ' 99. DrawGeometryRealization
    DrawGeometryRealization As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal realization As ID2D1GeometryRealization Ptr, ByVal brush As ID2D1Brush Ptr )
        ' Erbt alle Methoden von ID2D1DeviceContext1
        ' Neue Methoden
    CreateInk As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal start_point As D2D1_INK_POINT Ptr, ByVal ink As Any Ptr Ptr ) As HRESULT
    CreateInkStyle As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal ink_style_properties As D2D1_INK_STYLE_PROPERTIES Ptr, ByVal ink_style As Any Ptr Ptr ) As HRESULT
    CreateGradientMesh As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal patches As D2D1_GRADIENT_MESH_PATCH Ptr, ByVal patches_count As ULong, ByVal gradient_mesh As Any Ptr Ptr ) As HRESULT
    CreateImageSourceFromWic As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal wic_bitmap_source As Any Ptr, ByVal loading_options As D2D1_IMAGE_SOURCE_LOADING_OPTIONS, ByVal alpha_mode As D2D1_ALPHA_MODE, ByVal image_source As Any Ptr Ptr ) As HRESULT
    CreateLookupTable3D As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal precision As ULong, ByVal extents As ULong Ptr, ByVal data As UByte Ptr, ByVal data_count As ULong, ByVal strides As ULong Ptr, ByVal lookup_table As Any Ptr Ptr ) As HRESULT
    CreateImageSourceFromDxgi As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal surfaces As Any Ptr Ptr, ByVal surface_count As ULong, ByVal color_space As ULong, ByVal options As D2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS, ByVal image_source As Any Ptr Ptr ) As HRESULT
    GetGradientMeshWorldBounds As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal gradient_mesh As ID2D1GradientMesh Ptr, ByVal bounds As D2D1_RECT_F Ptr ) As HRESULT
    DrawInk As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal ink As ID2D1Ink Ptr, ByVal brush As ID2D1Brush Ptr, ByVal ink_style As ID2D1InkStyle Ptr )
    DrawGradientMesh As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal gradient_mesh As ID2D1GradientMesh Ptr )
    DrawGdiMetafile1 As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal gdi_metafile As Any Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal src_rect As D2D1_RECT_F Ptr )
    CreateTransformedImageSource As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal source As ID2D1ImageSource Ptr, ByVal props As D2D1_TRANSFORMED_IMAGE_SOURCE_PROPERTIES Ptr, ByVal transformed As Any Ptr Ptr ) As HRESULT
        ' Erbt von ID2D1DeviceContext2
    CreateSpriteBatch As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal sprite_batch As Any Ptr Ptr ) As HRESULT
    DrawSpriteBatch As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal sprite_batch As ID2D1SpriteBatch Ptr, ByVal start_index As ULong, ByVal sprite_count As ULong, ByVal bitmap As ID2D1Bitmap Ptr, ByVal interpolation_mode As D2D1_BITMAP_INTERPOLATION_MODE, ByVal sprite_options As D2D1_SPRITE_OPTIONS )
        ' Erbt von ID2D1DeviceContext3
    CreateSvgGlyphStyle As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal svg_glyph_style As Any Ptr Ptr ) As HRESULT
        ' DrawText - Überladen mit zusätzlichen Parametern
    DrawText1 As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal string As WString Ptr, ByVal string_length As ULong, ByVal text_format As Any Ptr, ByVal layout_rect As D2D1_RECT_F Ptr, ByVal default_fill_brush As ID2D1Brush Ptr, ByVal svg_glyph_style As ID2D1SvgGlyphStyle Ptr, ByVal color_palette_index As ULong, ByVal options As D2D1_DRAW_TEXT_OPTIONS, ByVal measuring_mode As ULong )
    DrawTextLayout1 As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal origin As D2D1_POINT_2F, ByVal text_layout As Any Ptr, ByVal default_fill_brush As ID2D1Brush Ptr, ByVal svg_glyph_style As ID2D1SvgGlyphStyle Ptr, ByVal color_palette_index As ULong, ByVal options As D2D1_DRAW_TEXT_OPTIONS )
    DrawColorBitmapGlyphRun As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal glyph_image_format As ULong, ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal measuring_mode As ULong, ByVal bitmap_snap_option As D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION )
    DrawSvgGlyphRun As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal default_fill_brush As ID2D1Brush Ptr, ByVal svg_glyph_style As ID2D1SvgGlyphStyle Ptr, ByVal color_palette_index As ULong, ByVal measuring_mode As ULong )
    GetColorBitmapGlyphImage As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal glyph_image_format As ULong, ByVal glyph_origin As D2D1_POINT_2F, ByVal font_face As Any Ptr, ByVal font_em_size As Single, ByVal glyph_index As UShort, ByVal is_sideways As Long, ByVal world_transform As D2D1_MATRIX_3X2_F Ptr, ByVal dpi_x As Single, ByVal dpi_y As Single, ByVal glyph_transform As D2D1_MATRIX_3X2_F Ptr, ByVal glyph_image As Any Ptr Ptr ) As HRESULT
    GetSvgGlyphImage As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal glyph_origin As D2D1_POINT_2F, ByVal font_face As Any Ptr, ByVal font_em_size As Single, ByVal glyph_index As UShort, ByVal is_sideways As Long, ByVal world_transform As D2D1_MATRIX_3X2_F Ptr, ByVal default_fill_brush As ID2D1Brush Ptr, ByVal svg_glyph_style As ID2D1SvgGlyphStyle Ptr, ByVal color_palette_index As ULong, ByVal glyph_transform As D2D1_MATRIX_3X2_F Ptr, ByVal glyph_image As Any Ptr Ptr ) As HRESULT
        ' Erbt von ID2D1DeviceContext4
    CreateSvgDocument As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal input_xml_stream As Any Ptr, ByVal viewport_size As D2D1_SIZE_F, ByVal svg_document As Any Ptr Ptr ) As HRESULT
    DrawSvgDocument As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal svg_document As Any Ptr )
    CreateColorContextFromDxgiColorSpace As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal color_space As ULong, ByVal color_context As Any Ptr Ptr ) As HRESULT
    CreateColorContextFromSimpleColorProfile As Function(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal simple_profile As D2D1_SIMPLE_COLOR_PROFILE Ptr, ByVal color_context As Any Ptr Ptr ) As HRESULT
        ' Erbt von ID2D1DeviceContext5
    BlendImage As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal image As ID2D1Image Ptr, ByVal blend_mode As D2D1_BLEND_MODE, ByVal target_offset As D2D1_POINT_2F Ptr, ByVal image_rect As D2D1_RECT_F Ptr, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE )

        ' Erbt von ID2D1DeviceContext6
    GetPaintFeatureLevel As Function(ByVal This As ID2D1DeviceContext7 Ptr) As DWRITE_PAINT_FEATURE_LEVEL
    DrawPaintGlyphRun As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal origin As D2D1_POINT_2F, ByVal run As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal palette_index As ULong, ByVal measuring_mode As ULong )
    DrawGlyphRunWithColorSupport As Sub(ByVal This As ID2D1DeviceContext7 Ptr,  ByVal origin As D2D1_POINT_2F, ByVal run As Any Ptr, ByVal run_desc As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal style As ID2D1SvgGlyphStyle Ptr, ByVal palette_index As ULong, ByVal measuring_mode As ULong, ByVal snap_option As D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION )
End Type
#define ID2D1DeviceContext7_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1DeviceContext7_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1DeviceContext7_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1DeviceContext7_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1DeviceContext7_CreateBitmap(p, a, b, c, d, e) (p)->lpVtbl->CreateBitmap(p, a, b, c, d, e)
#define ID2D1DeviceContext7_CreateBitmapFromWicBitmap(p, a, b, c) (p)->lpVtbl->CreateBitmapFromWicBitmap(p, a, b, c)
#define ID2D1DeviceContext7_CreateSharedBitmap(p, a, b, c, d) (p)->lpVtbl->CreateSharedBitmap(p, a, b, c, d)
#define ID2D1DeviceContext7_CreateBitmapBrush(p, a, b, c, d) (p)->lpVtbl->CreateBitmapBrush(p, a, b, c, d)
#define ID2D1DeviceContext7_CreateSolidColorBrush(p, a, b, c) (p)->lpVtbl->CreateSolidColorBrush(p, a, b, c)
#define ID2D1DeviceContext7_CreateGradientStopCollection(p, a, b, c, d, e) (p)->lpVtbl->CreateGradientStopCollection(p, a, b, c, d, e)
#define ID2D1DeviceContext7_CreateLinearGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateLinearGradientBrush(p, a, b, c, d)
#define ID2D1DeviceContext7_CreateRadialGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateRadialGradientBrush(p, a, b, c, d)
#define ID2D1DeviceContext7_CreateCompatibleRenderTarget(p, a, b, c, d, e) (p)->lpVtbl->CreateCompatibleRenderTarget(p, a, b, c, d, e)
#define ID2D1DeviceContext7_CreateLayer(p, a, b) (p)->lpVtbl->CreateLayer(p, a, b)
#define ID2D1DeviceContext7_CreateMesh(p, a) (p)->lpVtbl->CreateMesh(p, a)
#define ID2D1DeviceContext7_DrawLine(p, a, b, c, d, e) (p)->lpVtbl->DrawLine(p, a, b, c, d, e)
#define ID2D1DeviceContext7_DrawRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRectangle(p, a, b, c, d)
#define ID2D1DeviceContext7_FillRectangle(p, a, b) (p)->lpVtbl->FillRectangle(p, a, b)
#define ID2D1DeviceContext7_DrawRoundedRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRoundedRectangle(p, a, b, c, d)
#define ID2D1DeviceContext7_FillRoundedRectangle(p, a, b) (p)->lpVtbl->FillRoundedRectangle(p, a, b)
#define ID2D1DeviceContext7_DrawEllipse(p, a, b, c, d) (p)->lpVtbl->DrawEllipse(p, a, b, c, d)
#define ID2D1DeviceContext7_FillEllipse(p, a, b) (p)->lpVtbl->FillEllipse(p, a, b)
#define ID2D1DeviceContext7_DrawGeometry(p, a, b, c, d) (p)->lpVtbl->DrawGeometry(p, a, b, c, d)
#define ID2D1DeviceContext7_FillGeometry(p, a, b, c) (p)->lpVtbl->FillGeometry(p, a, b, c)
#define ID2D1DeviceContext7_FillMesh(p, a, b) (p)->lpVtbl->FillMesh(p, a, b)
#define ID2D1DeviceContext7_FillOpacityMask(p, a, b, c, d, e) (p)->lpVtbl->FillOpacityMask(p, a, b, c, d, e)
#define ID2D1DeviceContext7_DrawBitmap(p, a, b, c, d, e) (p)->lpVtbl->DrawBitmap(p, a, b, c, d, e)
#define ID2D1DeviceContext7_DrawText(p, a, b, c, d, e, f, g) (p)->lpVtbl->DrawText(p, a, b, c, d, e, f, g)
#define ID2D1DeviceContext7_DrawTextLayout(p, a, b, c, d) (p)->lpVtbl->DrawTextLayout(p, a, b, c, d)
#define ID2D1DeviceContext7_DrawGlyphRun(p, a, b, c, d) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d)
#define ID2D1DeviceContext7_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1DeviceContext7_GetTransform(p, a) (p)->lpVtbl->GetTransform(p, a)
#define ID2D1DeviceContext7_SetAntialiasMode(p, a) (p)->lpVtbl->SetAntialiasMode(p, a)
#define ID2D1DeviceContext7_GetAntialiasMode(p, a) (p)->lpVtbl->GetAntialiasMode(p, a)
#define ID2D1DeviceContext7_SetTextAntialiasMode(p, a) (p)->lpVtbl->SetTextAntialiasMode(p, a)
#define ID2D1DeviceContext7_GetTextAntialiasMode(p, a) (p)->lpVtbl->GetTextAntialiasMode(p, a)
#define ID2D1DeviceContext7_SetTextRenderingParams(p, a) (p)->lpVtbl->SetTextRenderingParams(p, a)
#define ID2D1DeviceContext7_GetTextRenderingParams(p, a) (p)->lpVtbl->GetTextRenderingParams(p, a)
#define ID2D1DeviceContext7_SetTags(p, a, b) (p)->lpVtbl->SetTags(p, a, b)
#define ID2D1DeviceContext7_GetTags(p, a, b) (p)->lpVtbl->GetTags(p, a, b)
#define ID2D1DeviceContext7_PushLayer(p, a, b) (p)->lpVtbl->PushLayer(p, a, b)
#define ID2D1DeviceContext7_PopLayer(p, a) (p)->lpVtbl->PopLayer(p, a)
#define ID2D1DeviceContext7_Flush(p, a, b) (p)->lpVtbl->Flush(p, a, b)
#define ID2D1DeviceContext7_SaveDrawingState(p, a) (p)->lpVtbl->SaveDrawingState(p, a)
#define ID2D1DeviceContext7_RestoreDrawingState(p, a) (p)->lpVtbl->RestoreDrawingState(p, a)
#define ID2D1DeviceContext7_PushAxisAlignedClip(p, a, b) (p)->lpVtbl->PushAxisAlignedClip(p, a, b)
#define ID2D1DeviceContext7_PopAxisAlignedClip(p, a) (p)->lpVtbl->PopAxisAlignedClip(p, a)
#define ID2D1DeviceContext7_Clear(p, a) (p)->lpVtbl->Clear(p, a)
#define ID2D1DeviceContext7_BeginDraw(p, a) (p)->lpVtbl->BeginDraw(p, a)
#define ID2D1DeviceContext7_EndDraw(p, a, b) (p)->lpVtbl->EndDraw(p, a, b)
#define ID2D1DeviceContext7_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)
#define ID2D1DeviceContext7_SetDpi(p, a, b) (p)->lpVtbl->SetDpi(p, a, b)
#define ID2D1DeviceContext7_GetDpi(p, a, b) (p)->lpVtbl->GetDpi(p, a, b)
#define ID2D1DeviceContext7_GetSize(p, a) (p)->lpVtbl->GetSize(p, a)
#define ID2D1DeviceContext7_GetPixelSize(p, a) (p)->lpVtbl->GetPixelSize(p, a)
#define ID2D1DeviceContext7_GetMaximumBitmapSize(p, a) (p)->lpVtbl->GetMaximumBitmapSize(p, a)
#define ID2D1DeviceContext7_IsSupported(p, a) (p)->lpVtbl->IsSupported(p, a)
#define ID2D1DeviceContext7_CreateBitmap1(p, a, b, c, d, e) (p)->lpVtbl->CreateBitmap1(p, a, b, c, d, e)
#define ID2D1DeviceContext7_CreateBitmapFromWicBitmap1(p, a, b, c) (p)->lpVtbl->CreateBitmapFromWicBitmap1(p, a, b, c)
#define ID2D1DeviceContext7_CreateColorContext(p, a, b, c, d) (p)->lpVtbl->CreateColorContext(p, a, b, c, d)
#define ID2D1DeviceContext7_CreateColorContextFromFilename(p, a, b) (p)->lpVtbl->CreateColorContextFromFilename(p, a, b)
#define ID2D1DeviceContext7_CreateColorContextFromWicColorContext(p, a, b) (p)->lpVtbl->CreateColorContextFromWicColorContext(p, a, b)
#define ID2D1DeviceContext7_CreateBitmapFromDxgiSurface(p, a, b, c) (p)->lpVtbl->CreateBitmapFromDxgiSurface(p, a, b, c)
#define ID2D1DeviceContext7_CreateEffect(p, a, b) (p)->lpVtbl->CreateEffect(p, a, b)
#define ID2D1DeviceContext7_CreateGradientStopCollection1(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateGradientStopCollection1(p, a, b, c, d, e, f, g, h)
#define ID2D1DeviceContext7_CreateImageBrush(p, a, b, c, d) (p)->lpVtbl->CreateImageBrush(p, a, b, c, d)
#define ID2D1DeviceContext7_CreateBitmapBrush1(p, a, b, c, d) (p)->lpVtbl->CreateBitmapBrush1(p, a, b, c, d)
#define ID2D1DeviceContext7_CreateCommandList(p, a) (p)->lpVtbl->CreateCommandList(p, a)
#define ID2D1DeviceContext7_IsDxgiFormatSupported(p, a) (p)->lpVtbl->IsDxgiFormatSupported(p, a)
#define ID2D1DeviceContext7_IsBufferPrecisionSupported(p, a) (p)->lpVtbl->IsBufferPrecisionSupported(p, a)
#define ID2D1DeviceContext7_GetImageLocalBounds(p, a, b) (p)->lpVtbl->GetImageLocalBounds(p, a, b)
#define ID2D1DeviceContext7_GetImageWorldBounds(p, a, b) (p)->lpVtbl->GetImageWorldBounds(p, a, b)
#define ID2D1DeviceContext7_GetGlyphRunWorldBounds(p, a, b, c, d) (p)->lpVtbl->GetGlyphRunWorldBounds(p, a, b, c, d)
#define ID2D1DeviceContext7_GetDevice(p, a) (p)->lpVtbl->GetDevice(p, a)
#define ID2D1DeviceContext7_SetTarget(p, a) (p)->lpVtbl->SetTarget(p, a)
#define ID2D1DeviceContext7_GetTarget(p, a) (p)->lpVtbl->GetTarget(p, a)
#define ID2D1DeviceContext7_SetRenderingControls(p, a) (p)->lpVtbl->SetRenderingControls(p, a)
#define ID2D1DeviceContext7_GetRenderingControls(p, a) (p)->lpVtbl->GetRenderingControls(p, a)
#define ID2D1DeviceContext7_SetPrimitiveBlend(p, a) (p)->lpVtbl->SetPrimitiveBlend(p, a)
#define ID2D1DeviceContext7_GetPrimitiveBlend(p, a) (p)->lpVtbl->GetPrimitiveBlend(p, a)
#define ID2D1DeviceContext7_SetUnitMode(p, a) (p)->lpVtbl->SetUnitMode(p, a)
#define ID2D1DeviceContext7_GetUnitMode(p, a) (p)->lpVtbl->GetUnitMode(p, a)
#define ID2D1DeviceContext7_DrawGlyphRun1(p, a, b, c, d, e) (p)->lpVtbl->DrawGlyphRun1(p, a, b, c, d, e)
#define ID2D1DeviceContext7_DrawImage(p, a, b, c, d, e) (p)->lpVtbl->DrawImage(p, a, b, c, d, e)
#define ID2D1DeviceContext7_DrawGdiMetafile(p, a, b) (p)->lpVtbl->DrawGdiMetafile(p, a, b)
#define ID2D1DeviceContext7_DrawBitmap1(p, a, b, c, d, e, f) (p)->lpVtbl->DrawBitmap1(p, a, b, c, d, e, f)
#define ID2D1DeviceContext7_InvalidateEffectInputRectangle(p, a, b, c) (p)->lpVtbl->InvalidateEffectInputRectangle(p, a, b, c)
#define ID2D1DeviceContext7_GetEffectInvalidRectangleCount(p, a, b) (p)->lpVtbl->GetEffectInvalidRectangleCount(p, a, b)
#define ID2D1DeviceContext7_GetEffectInvalidRectangles(p, a, b, c) (p)->lpVtbl->GetEffectInvalidRectangles(p, a, b, c)
#define ID2D1DeviceContext7_GetEffectRequiredInputRectangles(p, a, b, c, d, e) (p)->lpVtbl->GetEffectRequiredInputRectangles(p, a, b, c, d, e)
#define ID2D1DeviceContext7_FillOpacityMask1(p, a, b, c, d, e) (p)->lpVtbl->FillOpacityMask1(p, a, b, c, d, e)
#define ID2D1DeviceContext7_PushLayer1(p, a, b) (p)->lpVtbl->PushLayer1(p, a, b)
#define ID2D1DeviceContext7_CreateFilledGeometryRealization(p, a, b, c) (p)->lpVtbl->CreateFilledGeometryRealization(p, a, b, c)
#define ID2D1DeviceContext7_CreateStrokedGeometryRealization(p, a, b, c, d, e) (p)->lpVtbl->CreateStrokedGeometryRealization(p, a, b, c, d, e)
#define ID2D1DeviceContext7_DrawGeometryRealization(p, a, b) (p)->lpVtbl->DrawGeometryRealization(p, a, b)
#define ID2D1DeviceContext7_CreateInk(p, a, b) (p)->lpVtbl->CreateInk(p, a, b)
#define ID2D1DeviceContext7_CreateInkStyle(p, a, b) (p)->lpVtbl->CreateInkStyle(p, a, b)
#define ID2D1DeviceContext7_CreateGradientMesh(p, a, b, c) (p)->lpVtbl->CreateGradientMesh(p, a, b, c)
#define ID2D1DeviceContext7_CreateImageSourceFromWic(p, a, b, c, d) (p)->lpVtbl->CreateImageSourceFromWic(p, a, b, c, d)
#define ID2D1DeviceContext7_CreateLookupTable3D(p, a, b, c, d, e, f) (p)->lpVtbl->CreateLookupTable3D(p, a, b, c, d, e, f)
#define ID2D1DeviceContext7_CreateImageSourceFromDxgi(p, a, b, c, d, e) (p)->lpVtbl->CreateImageSourceFromDxgi(p, a, b, c, d, e)
#define ID2D1DeviceContext7_GetGradientMeshWorldBounds(p, a, b) (p)->lpVtbl->GetGradientMeshWorldBounds(p, a, b)
#define ID2D1DeviceContext7_DrawInk(p, a, b, c) (p)->lpVtbl->DrawInk(p, a, b, c)
#define ID2D1DeviceContext7_DrawGradientMesh(p, a) (p)->lpVtbl->DrawGradientMesh(p, a)
#define ID2D1DeviceContext7_DrawGdiMetafile1(p, a, b, c) (p)->lpVtbl->DrawGdiMetafile1(p, a, b, c)
#define ID2D1DeviceContext7_CreateTransformedImageSource(p, a, b, c) (p)->lpVtbl->CreateTransformedImageSource(p, a, b, c)
#define ID2D1DeviceContext7_CreateSpriteBatch(p, a) (p)->lpVtbl->CreateSpriteBatch(p, a)
#define ID2D1DeviceContext7_DrawSpriteBatch(p, a, b, c, d, e, f) (p)->lpVtbl->DrawSpriteBatch(p, a, b, c, d, e, f)
#define ID2D1DeviceContext7_CreateSvgGlyphStyle(p, a) (p)->lpVtbl->CreateSvgGlyphStyle(p, a)
#define ID2D1DeviceContext7_DrawText1(p, a, b, c, d, e, f, g, h, i) (p)->lpVtbl->DrawText1(p, a, b, c, d, e, f, g, h, i)
#define ID2D1DeviceContext7_DrawTextLayout1(p, a, b, c, d, e, f) (p)->lpVtbl->DrawTextLayout1(p, a, b, c, d, e, f)
#define ID2D1DeviceContext7_DrawColorBitmapGlyphRun(p, a, b, c, d, e) (p)->lpVtbl->DrawColorBitmapGlyphRun(p, a, b, c, d, e)
#define ID2D1DeviceContext7_DrawSvgGlyphRun(p, a, b, c, d, e, f) (p)->lpVtbl->DrawSvgGlyphRun(p, a, b, c, d, e, f)
#define ID2D1DeviceContext7_GetColorBitmapGlyphImage(p, a, b, c, d, e, f, g, h, i, j, k) (p)->lpVtbl->GetColorBitmapGlyphImage(p, a, b, c, d, e, f, g, h, i, j, k)
#define ID2D1DeviceContext7_GetSvgGlyphImage(p, a, b, c, d, e, f, g, h, i, j, k) (p)->lpVtbl->GetSvgGlyphImage(p, a, b, c, d, e, f, g, h, i, j, k)
#define ID2D1DeviceContext7_CreateSvgDocument(p, a, b, c) (p)->lpVtbl->CreateSvgDocument(p, a, b, c)
#define ID2D1DeviceContext7_DrawSvgDocument(p, a) (p)->lpVtbl->DrawSvgDocument(p, a)
#define ID2D1DeviceContext7_CreateColorContextFromDxgiColorSpace(p, a, b) (p)->lpVtbl->CreateColorContextFromDxgiColorSpace(p, a, b)
#define ID2D1DeviceContext7_CreateColorContextFromSimpleColorProfile(p, a, b) (p)->lpVtbl->CreateColorContextFromSimpleColorProfile(p, a, b)
#define ID2D1DeviceContext7_BlendImage(p, a, b, c, d, e) (p)->lpVtbl->BlendImage(p, a, b, c, d, e)
#define ID2D1DeviceContext7_GetPaintFeatureLevel(p, a) (p)->lpVtbl->GetPaintFeatureLevel(p, a)
#define ID2D1DeviceContext7_DrawPaintGlyphRun(p, a, b, c, d, e) (p)->lpVtbl->DrawPaintGlyphRun(p, a, b, c, d, e)
#define ID2D1DeviceContext7_DrawGlyphRunWithColorSupport(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->DrawGlyphRunWithColorSupport(p, a, b, c, d, e, f, g, h)

' ============================================================================
' Device Interfaces
' ============================================================================
Type ID2D1Device2Vtbl As ID2D1Device2Vtbl_
Type ID2D1Device2
    lpVtbl As ID2D1Device2Vtbl Ptr
End Type
Type ID2D1Device2Vtbl_     '' Extends ID2D1Device1Vtbl_
    QueryInterface As Function(ByVal This As ID2D1Device2 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Device2 Ptr) As ULong
    Release As Function(ByVal This As ID2D1Device2 Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1Device2 Ptr, ByVal factory As Any Ptr Ptr)
        ' 4: GetFactory
        ' 5. CreateDeviceContext
    CreateDeviceContext As Function(ByVal This As ID2D1Device2 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
        ' 6. CreatePrintControl
    CreatePrintControl As Function(ByVal This As ID2D1Device2 Ptr,  ByVal wic_factory As Any Ptr, ByVal document_target As Any Ptr, ByVal desc As D2D1_PRINT_CONTROL_PROPERTIES Ptr, ByVal print_control As Any Ptr Ptr ) As HRESULT
        ' 7. SetMaximumTextureMemory
    SetMaximumTextureMemory As Sub(ByVal This As ID2D1Device2 Ptr,  ByVal max_texture_memory As ULongInt )
        ' 8. GetMaximumTextureMemory
    GetMaximumTextureMemory As Function(ByVal This As ID2D1Device2 Ptr) As ULongInt
        ' 9. ClearResources
    ClearResources As Function(ByVal This As ID2D1Device2 Ptr,  ByVal msec_since_use As ULong ) As HRESULT
        ' Erbt von ID2D1Device (1-10 Methoden)
        ' 11. GetRenderingPriority
    GetRenderingPriority As Function(ByVal This As ID2D1Device2 Ptr) As D2D1_RENDERING_PRIORITY
        ' 12. SetRenderingPriority
    SetRenderingPriority As Sub(ByVal This As ID2D1Device2 Ptr,  ByVal priority As D2D1_RENDERING_PRIORITY )
        ' 13. CreateDeviceContext
    CreateDeviceContext1 As Function(ByVal This As ID2D1Device2 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal device_context As Any Ptr Ptr ) As HRESULT

    CreateDeviceContext2 As Function(ByVal This As ID2D1Device2 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
    FlushDeviceContexts As Sub(ByVal This As ID2D1Device2 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr )
    GetDxgiDevice As Function(ByVal This As ID2D1Device2 Ptr,  ByVal dxgi_device As Any Ptr Ptr ) As HRESULT
End Type
#define ID2D1Device2_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Device2_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Device2_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Device2_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1Device2_CreateDeviceContext(p, a, b) (p)->lpVtbl->CreateDeviceContext(p, a, b)
#define ID2D1Device2_CreatePrintControl(p, a, b, c, d) (p)->lpVtbl->CreatePrintControl(p, a, b, c, d)
#define ID2D1Device2_SetMaximumTextureMemory(p, a) (p)->lpVtbl->SetMaximumTextureMemory(p, a)
#define ID2D1Device2_GetMaximumTextureMemory(p, a) (p)->lpVtbl->GetMaximumTextureMemory(p, a)
#define ID2D1Device2_ClearResources(p, a) (p)->lpVtbl->ClearResources(p, a)
#define ID2D1Device2_GetRenderingPriority(p, a) (p)->lpVtbl->GetRenderingPriority(p, a)
#define ID2D1Device2_SetRenderingPriority(p, a) (p)->lpVtbl->SetRenderingPriority(p, a)
#define ID2D1Device2_CreateDeviceContext1(p, a, b) (p)->lpVtbl->CreateDeviceContext1(p, a, b)
#define ID2D1Device2_CreateDeviceContext2(p, a, b) (p)->lpVtbl->CreateDeviceContext2(p, a, b)
#define ID2D1Device2_FlushDeviceContexts(p, a) (p)->lpVtbl->FlushDeviceContexts(p, a)
#define ID2D1Device2_GetDxgiDevice(p, a) (p)->lpVtbl->GetDxgiDevice(p, a)

Type ID2D1Device3Vtbl As ID2D1Device3Vtbl_
Type ID2D1Device3
    lpVtbl As ID2D1Device3Vtbl Ptr
End Type
Type ID2D1Device3Vtbl_     '' Extends ID2D1Device2Vtbl_
    QueryInterface As Function(ByVal This As ID2D1Device3 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Device3 Ptr) As ULong
    Release As Function(ByVal This As ID2D1Device3 Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1Device3 Ptr, ByVal factory As Any Ptr Ptr)
        ' 4: GetFactory
        ' 5. CreateDeviceContext
    CreateDeviceContext As Function(ByVal This As ID2D1Device3 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
        ' 6. CreatePrintControl
    CreatePrintControl As Function(ByVal This As ID2D1Device3 Ptr,  ByVal wic_factory As Any Ptr, ByVal document_target As Any Ptr, ByVal desc As D2D1_PRINT_CONTROL_PROPERTIES Ptr, ByVal print_control As Any Ptr Ptr ) As HRESULT
        ' 7. SetMaximumTextureMemory
    SetMaximumTextureMemory As Sub(ByVal This As ID2D1Device3 Ptr,  ByVal max_texture_memory As ULongInt )
        ' 8. GetMaximumTextureMemory
    GetMaximumTextureMemory As Function(ByVal This As ID2D1Device3 Ptr) As ULongInt
        ' 9. ClearResources
    ClearResources As Function(ByVal This As ID2D1Device3 Ptr,  ByVal msec_since_use As ULong ) As HRESULT
        ' Erbt von ID2D1Device (1-10 Methoden)
        ' 11. GetRenderingPriority
    GetRenderingPriority As Function(ByVal This As ID2D1Device3 Ptr) As D2D1_RENDERING_PRIORITY
        ' 12. SetRenderingPriority
    SetRenderingPriority As Sub(ByVal This As ID2D1Device3 Ptr,  ByVal priority As D2D1_RENDERING_PRIORITY )
        ' 13. CreateDeviceContext
    CreateDeviceContext1 As Function(ByVal This As ID2D1Device3 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal device_context As Any Ptr Ptr ) As HRESULT
    CreateDeviceContext2 As Function(ByVal This As ID2D1Device3 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
    FlushDeviceContexts As Sub(ByVal This As ID2D1Device3 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr )
    GetDxgiDevice As Function(ByVal This As ID2D1Device3 Ptr,  ByVal dxgi_device As Any Ptr Ptr ) As HRESULT

    CreateDeviceContext3 As Function(ByVal This As ID2D1Device3 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
End Type
#define ID2D1Device3_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Device3_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Device3_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Device3_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1Device3_CreateDeviceContext(p, a, b) (p)->lpVtbl->CreateDeviceContext(p, a, b)
#define ID2D1Device3_CreatePrintControl(p, a, b, c, d) (p)->lpVtbl->CreatePrintControl(p, a, b, c, d)
#define ID2D1Device3_SetMaximumTextureMemory(p, a) (p)->lpVtbl->SetMaximumTextureMemory(p, a)
#define ID2D1Device3_GetMaximumTextureMemory(p, a) (p)->lpVtbl->GetMaximumTextureMemory(p, a)
#define ID2D1Device3_ClearResources(p, a) (p)->lpVtbl->ClearResources(p, a)
#define ID2D1Device3_GetRenderingPriority(p, a) (p)->lpVtbl->GetRenderingPriority(p, a)
#define ID2D1Device3_SetRenderingPriority(p, a) (p)->lpVtbl->SetRenderingPriority(p, a)
#define ID2D1Device3_CreateDeviceContext1(p, a, b) (p)->lpVtbl->CreateDeviceContext1(p, a, b)
#define ID2D1Device3_CreateDeviceContext2(p, a, b) (p)->lpVtbl->CreateDeviceContext2(p, a, b)
#define ID2D1Device3_FlushDeviceContexts(p, a) (p)->lpVtbl->FlushDeviceContexts(p, a)
#define ID2D1Device3_GetDxgiDevice(p, a) (p)->lpVtbl->GetDxgiDevice(p, a)
#define ID2D1Device3_CreateDeviceContext3(p, a, b) (p)->lpVtbl->CreateDeviceContext3(p, a, b)

Type ID2D1Device4Vtbl As ID2D1Device4Vtbl_
Type ID2D1Device4
    lpVtbl As ID2D1Device4Vtbl Ptr
End Type
Type ID2D1Device4Vtbl_     '' Extends ID2D1Device3Vtbl_
    QueryInterface As Function(ByVal This As ID2D1Device4 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Device4 Ptr) As ULong
    Release As Function(ByVal This As ID2D1Device4 Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1Device4 Ptr, ByVal factory As Any Ptr Ptr)
        ' 4: GetFactory
        ' 5. CreateDeviceContext
    CreateDeviceContext As Function(ByVal This As ID2D1Device4 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
        ' 6. CreatePrintControl
    CreatePrintControl As Function(ByVal This As ID2D1Device4 Ptr,  ByVal wic_factory As Any Ptr, ByVal document_target As Any Ptr, ByVal desc As D2D1_PRINT_CONTROL_PROPERTIES Ptr, ByVal print_control As Any Ptr Ptr ) As HRESULT
        ' 7. SetMaximumTextureMemory
    SetMaximumTextureMemory As Sub(ByVal This As ID2D1Device4 Ptr,  ByVal max_texture_memory As ULongInt )
        ' 8. GetMaximumTextureMemory
    GetMaximumTextureMemory As Function(ByVal This As ID2D1Device4 Ptr) As ULongInt
        ' 9. ClearResources
    ClearResources As Function(ByVal This As ID2D1Device4 Ptr,  ByVal msec_since_use As ULong ) As HRESULT
        ' Erbt von ID2D1Device (1-10 Methoden)
        ' 11. GetRenderingPriority
    GetRenderingPriority As Function(ByVal This As ID2D1Device4 Ptr) As D2D1_RENDERING_PRIORITY
        ' 12. SetRenderingPriority
    SetRenderingPriority As Sub(ByVal This As ID2D1Device4 Ptr,  ByVal priority As D2D1_RENDERING_PRIORITY )
        ' 13. CreateDeviceContext
    CreateDeviceContext1 As Function(ByVal This As ID2D1Device4 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal device_context As Any Ptr Ptr ) As HRESULT
    CreateDeviceContext2 As Function(ByVal This As ID2D1Device4 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
    FlushDeviceContexts As Sub(ByVal This As ID2D1Device4 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr )
    GetDxgiDevice As Function(ByVal This As ID2D1Device4 Ptr,  ByVal dxgi_device As Any Ptr Ptr ) As HRESULT
    CreateDeviceContext3 As Function(ByVal This As ID2D1Device4 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT

    CreateDeviceContext4 As Function(ByVal This As ID2D1Device4 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
    SetMaximumColorGlyphCacheMemory As Sub(ByVal This As ID2D1Device4 Ptr,  ByVal size As ULongInt )
    GetMaximumColorGlyphCacheMemory As Function(ByVal This As ID2D1Device4 Ptr) As ULongInt
End Type
#define ID2D1Device4_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Device4_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Device4_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Device4_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1Device4_CreateDeviceContext(p, a, b) (p)->lpVtbl->CreateDeviceContext(p, a, b)
#define ID2D1Device4_CreatePrintControl(p, a, b, c, d) (p)->lpVtbl->CreatePrintControl(p, a, b, c, d)
#define ID2D1Device4_SetMaximumTextureMemory(p, a) (p)->lpVtbl->SetMaximumTextureMemory(p, a)
#define ID2D1Device4_GetMaximumTextureMemory(p, a) (p)->lpVtbl->GetMaximumTextureMemory(p, a)
#define ID2D1Device4_ClearResources(p, a) (p)->lpVtbl->ClearResources(p, a)
#define ID2D1Device4_GetRenderingPriority(p, a) (p)->lpVtbl->GetRenderingPriority(p, a)
#define ID2D1Device4_SetRenderingPriority(p, a) (p)->lpVtbl->SetRenderingPriority(p, a)
#define ID2D1Device4_CreateDeviceContext1(p, a, b) (p)->lpVtbl->CreateDeviceContext1(p, a, b)
#define ID2D1Device4_CreateDeviceContext2(p, a, b) (p)->lpVtbl->CreateDeviceContext2(p, a, b)
#define ID2D1Device4_FlushDeviceContexts(p, a) (p)->lpVtbl->FlushDeviceContexts(p, a)
#define ID2D1Device4_GetDxgiDevice(p, a) (p)->lpVtbl->GetDxgiDevice(p, a)
#define ID2D1Device4_CreateDeviceContext3(p, a, b) (p)->lpVtbl->CreateDeviceContext3(p, a, b)
#define ID2D1Device4_CreateDeviceContext4(p, a, b) (p)->lpVtbl->CreateDeviceContext4(p, a, b)
#define ID2D1Device4_SetMaximumColorGlyphCacheMemory(p, a) (p)->lpVtbl->SetMaximumColorGlyphCacheMemory(p, a)
#define ID2D1Device4_GetMaximumColorGlyphCacheMemory(p, a) (p)->lpVtbl->GetMaximumColorGlyphCacheMemory(p, a)

Type ID2D1Device5Vtbl As ID2D1Device5Vtbl_
Type ID2D1Device5
    lpVtbl As ID2D1Device5Vtbl Ptr
End Type
Type ID2D1Device5Vtbl_     '' Extends ID2D1Device4Vtbl_
    QueryInterface As Function(ByVal This As ID2D1Device5 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Device5 Ptr) As ULong
    Release As Function(ByVal This As ID2D1Device5 Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1Device5 Ptr, ByVal factory As Any Ptr Ptr)
        ' 4: GetFactory
        ' 5. CreateDeviceContext
    CreateDeviceContext As Function(ByVal This As ID2D1Device5 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
        ' 6. CreatePrintControl
    CreatePrintControl As Function(ByVal This As ID2D1Device5 Ptr,  ByVal wic_factory As Any Ptr, ByVal document_target As Any Ptr, ByVal desc As D2D1_PRINT_CONTROL_PROPERTIES Ptr, ByVal print_control As Any Ptr Ptr ) As HRESULT
        ' 7. SetMaximumTextureMemory
    SetMaximumTextureMemory As Sub(ByVal This As ID2D1Device5 Ptr,  ByVal max_texture_memory As ULongInt )
        ' 8. GetMaximumTextureMemory
    GetMaximumTextureMemory As Function(ByVal This As ID2D1Device5 Ptr) As ULongInt
        ' 9. ClearResources
    ClearResources As Function(ByVal This As ID2D1Device5 Ptr,  ByVal msec_since_use As ULong ) As HRESULT
        ' Erbt von ID2D1Device (1-10 Methoden)
        ' 11. GetRenderingPriority
    GetRenderingPriority As Function(ByVal This As ID2D1Device5 Ptr) As D2D1_RENDERING_PRIORITY
        ' 12. SetRenderingPriority
    SetRenderingPriority As Sub(ByVal This As ID2D1Device5 Ptr,  ByVal priority As D2D1_RENDERING_PRIORITY )
        ' 13. CreateDeviceContext
    CreateDeviceContext1 As Function(ByVal This As ID2D1Device5 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal device_context As Any Ptr Ptr ) As HRESULT
    CreateDeviceContext2 As Function(ByVal This As ID2D1Device5 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
    FlushDeviceContexts As Sub(ByVal This As ID2D1Device5 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr )
    GetDxgiDevice As Function(ByVal This As ID2D1Device5 Ptr,  ByVal dxgi_device As Any Ptr Ptr ) As HRESULT
    CreateDeviceContext3 As Function(ByVal This As ID2D1Device5 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
    CreateDeviceContext4 As Function(ByVal This As ID2D1Device5 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
    SetMaximumColorGlyphCacheMemory As Sub(ByVal This As ID2D1Device5 Ptr,  ByVal size As ULongInt )
    GetMaximumColorGlyphCacheMemory As Function(ByVal This As ID2D1Device5 Ptr) As ULongInt

    CreateDeviceContext5 As Function(ByVal This As ID2D1Device5 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
End Type
#define ID2D1Device5_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Device5_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Device5_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Device5_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1Device5_CreateDeviceContext(p, a, b) (p)->lpVtbl->CreateDeviceContext(p, a, b)
#define ID2D1Device5_CreatePrintControl(p, a, b, c, d) (p)->lpVtbl->CreatePrintControl(p, a, b, c, d)
#define ID2D1Device5_SetMaximumTextureMemory(p, a) (p)->lpVtbl->SetMaximumTextureMemory(p, a)
#define ID2D1Device5_GetMaximumTextureMemory(p, a) (p)->lpVtbl->GetMaximumTextureMemory(p, a)
#define ID2D1Device5_ClearResources(p, a) (p)->lpVtbl->ClearResources(p, a)
#define ID2D1Device5_GetRenderingPriority(p, a) (p)->lpVtbl->GetRenderingPriority(p, a)
#define ID2D1Device5_SetRenderingPriority(p, a) (p)->lpVtbl->SetRenderingPriority(p, a)
#define ID2D1Device5_CreateDeviceContext1(p, a, b) (p)->lpVtbl->CreateDeviceContext1(p, a, b)
#define ID2D1Device5_CreateDeviceContext2(p, a, b) (p)->lpVtbl->CreateDeviceContext2(p, a, b)
#define ID2D1Device5_FlushDeviceContexts(p, a) (p)->lpVtbl->FlushDeviceContexts(p, a)
#define ID2D1Device5_GetDxgiDevice(p, a) (p)->lpVtbl->GetDxgiDevice(p, a)
#define ID2D1Device5_CreateDeviceContext3(p, a, b) (p)->lpVtbl->CreateDeviceContext3(p, a, b)
#define ID2D1Device5_CreateDeviceContext4(p, a, b) (p)->lpVtbl->CreateDeviceContext4(p, a, b)
#define ID2D1Device5_SetMaximumColorGlyphCacheMemory(p, a) (p)->lpVtbl->SetMaximumColorGlyphCacheMemory(p, a)
#define ID2D1Device5_GetMaximumColorGlyphCacheMemory(p, a) (p)->lpVtbl->GetMaximumColorGlyphCacheMemory(p, a)
#define ID2D1Device5_CreateDeviceContext5(p, a, b) (p)->lpVtbl->CreateDeviceContext5(p, a, b)

Type ID2D1Device6Vtbl As ID2D1Device6Vtbl_
Type ID2D1Device6
    lpVtbl As ID2D1Device6Vtbl Ptr
End Type
Type ID2D1Device6Vtbl_     '' Extends ID2D1Device5Vtbl_
    QueryInterface As Function(ByVal This As ID2D1Device6 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Device6 Ptr) As ULong
    Release As Function(ByVal This As ID2D1Device6 Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1Device6 Ptr, ByVal factory As Any Ptr Ptr)
        ' 4: GetFactory
        ' 5. CreateDeviceContext
    CreateDeviceContext As Function(ByVal This As ID2D1Device6 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
        ' 6. CreatePrintControl
    CreatePrintControl As Function(ByVal This As ID2D1Device6 Ptr,  ByVal wic_factory As Any Ptr, ByVal document_target As Any Ptr, ByVal desc As D2D1_PRINT_CONTROL_PROPERTIES Ptr, ByVal print_control As Any Ptr Ptr ) As HRESULT
        ' 7. SetMaximumTextureMemory
    SetMaximumTextureMemory As Sub(ByVal This As ID2D1Device6 Ptr,  ByVal max_texture_memory As ULongInt )
        ' 8. GetMaximumTextureMemory
    GetMaximumTextureMemory As Function(ByVal This As ID2D1Device6 Ptr) As ULongInt
        ' 9. ClearResources
    ClearResources As Function(ByVal This As ID2D1Device6 Ptr,  ByVal msec_since_use As ULong ) As HRESULT
        ' Erbt von ID2D1Device (1-10 Methoden)
        ' 11. GetRenderingPriority
    GetRenderingPriority As Function(ByVal This As ID2D1Device6 Ptr) As D2D1_RENDERING_PRIORITY
        ' 12. SetRenderingPriority
    SetRenderingPriority As Sub(ByVal This As ID2D1Device6 Ptr,  ByVal priority As D2D1_RENDERING_PRIORITY )
        ' 13. CreateDeviceContext
    CreateDeviceContext1 As Function(ByVal This As ID2D1Device6 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal device_context As Any Ptr Ptr ) As HRESULT
    CreateDeviceContext2 As Function(ByVal This As ID2D1Device6 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
    FlushDeviceContexts As Sub(ByVal This As ID2D1Device6 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr )
    GetDxgiDevice As Function(ByVal This As ID2D1Device6 Ptr,  ByVal dxgi_device As Any Ptr Ptr ) As HRESULT
    CreateDeviceContext3 As Function(ByVal This As ID2D1Device6 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
    CreateDeviceContext4 As Function(ByVal This As ID2D1Device6 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
    SetMaximumColorGlyphCacheMemory As Sub(ByVal This As ID2D1Device6 Ptr,  ByVal size As ULongInt )
    GetMaximumColorGlyphCacheMemory As Function(ByVal This As ID2D1Device6 Ptr) As ULongInt
    CreateDeviceContext5 As Function(ByVal This As ID2D1Device6 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT

    CreateDeviceContext6 As Function(ByVal This As ID2D1Device6 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
End Type
#define ID2D1Device6_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Device6_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Device6_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Device6_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1Device6_CreateDeviceContext(p, a, b) (p)->lpVtbl->CreateDeviceContext(p, a, b)
#define ID2D1Device6_CreatePrintControl(p, a, b, c, d) (p)->lpVtbl->CreatePrintControl(p, a, b, c, d)
#define ID2D1Device6_SetMaximumTextureMemory(p, a) (p)->lpVtbl->SetMaximumTextureMemory(p, a)
#define ID2D1Device6_GetMaximumTextureMemory(p, a) (p)->lpVtbl->GetMaximumTextureMemory(p, a)
#define ID2D1Device6_ClearResources(p, a) (p)->lpVtbl->ClearResources(p, a)
#define ID2D1Device6_GetRenderingPriority(p, a) (p)->lpVtbl->GetRenderingPriority(p, a)
#define ID2D1Device6_SetRenderingPriority(p, a) (p)->lpVtbl->SetRenderingPriority(p, a)
#define ID2D1Device6_CreateDeviceContext1(p, a, b) (p)->lpVtbl->CreateDeviceContext1(p, a, b)
#define ID2D1Device6_CreateDeviceContext2(p, a, b) (p)->lpVtbl->CreateDeviceContext2(p, a, b)
#define ID2D1Device6_FlushDeviceContexts(p, a) (p)->lpVtbl->FlushDeviceContexts(p, a)
#define ID2D1Device6_GetDxgiDevice(p, a) (p)->lpVtbl->GetDxgiDevice(p, a)
#define ID2D1Device6_CreateDeviceContext3(p, a, b) (p)->lpVtbl->CreateDeviceContext3(p, a, b)
#define ID2D1Device6_CreateDeviceContext4(p, a, b) (p)->lpVtbl->CreateDeviceContext4(p, a, b)
#define ID2D1Device6_SetMaximumColorGlyphCacheMemory(p, a) (p)->lpVtbl->SetMaximumColorGlyphCacheMemory(p, a)
#define ID2D1Device6_GetMaximumColorGlyphCacheMemory(p, a) (p)->lpVtbl->GetMaximumColorGlyphCacheMemory(p, a)
#define ID2D1Device6_CreateDeviceContext5(p, a, b) (p)->lpVtbl->CreateDeviceContext5(p, a, b)
#define ID2D1Device6_CreateDeviceContext6(p, a, b) (p)->lpVtbl->CreateDeviceContext5(p, a, b)

Type ID2D1Device7Vtbl As ID2D1Device7Vtbl_
Type ID2D1Device7
    lpVtbl As ID2D1Device7Vtbl Ptr
End Type
Type ID2D1Device7Vtbl_     '' Extends ID2D1Device6Vtbl_
    QueryInterface As Function(ByVal This As ID2D1Device7 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Device7 Ptr) As ULong
    Release As Function(ByVal This As ID2D1Device7 Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1Device7 Ptr, ByVal factory As Any Ptr Ptr)
        ' 4: GetFactory
        ' 5. CreateDeviceContext
    CreateDeviceContext As Function(ByVal This As ID2D1Device7 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
        ' 6. CreatePrintControl
    CreatePrintControl As Function(ByVal This As ID2D1Device7 Ptr,  ByVal wic_factory As Any Ptr, ByVal document_target As Any Ptr, ByVal desc As D2D1_PRINT_CONTROL_PROPERTIES Ptr, ByVal print_control As Any Ptr Ptr ) As HRESULT
        ' 7. SetMaximumTextureMemory
    SetMaximumTextureMemory As Sub(ByVal This As ID2D1Device7 Ptr,  ByVal max_texture_memory As ULongInt )
        ' 8. GetMaximumTextureMemory
    GetMaximumTextureMemory As Function(ByVal This As ID2D1Device7 Ptr) As ULongInt
        ' 9. ClearResources
    ClearResources As Function(ByVal This As ID2D1Device7 Ptr,  ByVal msec_since_use As ULong ) As HRESULT
        ' Erbt von ID2D1Device (1-10 Methoden)
        ' 11. GetRenderingPriority
    GetRenderingPriority As Function(ByVal This As ID2D1Device7 Ptr) As D2D1_RENDERING_PRIORITY
        ' 12. SetRenderingPriority
    SetRenderingPriority As Sub(ByVal This As ID2D1Device7 Ptr,  ByVal priority As D2D1_RENDERING_PRIORITY )
        ' 13. CreateDeviceContext
    CreateDeviceContext1 As Function(ByVal This As ID2D1Device7 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal device_context As Any Ptr Ptr ) As HRESULT
    CreateDeviceContext2 As Function(ByVal This As ID2D1Device7 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
    FlushDeviceContexts As Sub(ByVal This As ID2D1Device7 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr )
    GetDxgiDevice As Function(ByVal This As ID2D1Device7 Ptr,  ByVal dxgi_device As Any Ptr Ptr ) As HRESULT
    CreateDeviceContext3 As Function(ByVal This As ID2D1Device7 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
    CreateDeviceContext4 As Function(ByVal This As ID2D1Device7 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
    SetMaximumColorGlyphCacheMemory As Sub(ByVal This As ID2D1Device7 Ptr,  ByVal size As ULongInt )
    GetMaximumColorGlyphCacheMemory As Function(ByVal This As ID2D1Device7 Ptr) As ULongInt
    CreateDeviceContext5 As Function(ByVal This As ID2D1Device7 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
    CreateDeviceContext6 As Function(ByVal This As ID2D1Device7 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT

    CreateDeviceContext7 As Function(ByVal This As ID2D1Device7 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
End Type
#define ID2D1Device7_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Device7_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Device7_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Device7_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1Device7_CreateDeviceContext(p, a, b) (p)->lpVtbl->CreateDeviceContext(p, a, b)
#define ID2D1Device7_CreatePrintControl(p, a, b, c, d) (p)->lpVtbl->CreatePrintControl(p, a, b, c, d)
#define ID2D1Device7_SetMaximumTextureMemory(p, a) (p)->lpVtbl->SetMaximumTextureMemory(p, a)
#define ID2D1Device7_GetMaximumTextureMemory(p, a) (p)->lpVtbl->GetMaximumTextureMemory(p, a)
#define ID2D1Device7_ClearResources(p, a) (p)->lpVtbl->ClearResources(p, a)
#define ID2D1Device7_GetRenderingPriority(p, a) (p)->lpVtbl->GetRenderingPriority(p, a)
#define ID2D1Device7_SetRenderingPriority(p, a) (p)->lpVtbl->SetRenderingPriority(p, a)
#define ID2D1Device7_CreateDeviceContext1(p, a, b) (p)->lpVtbl->CreateDeviceContext1(p, a, b)
#define ID2D1Device7_CreateDeviceContext2(p, a, b) (p)->lpVtbl->CreateDeviceContext2(p, a, b)
#define ID2D1Device7_FlushDeviceContexts(p, a) (p)->lpVtbl->FlushDeviceContexts(p, a)
#define ID2D1Device7_GetDxgiDevice(p, a) (p)->lpVtbl->GetDxgiDevice(p, a)
#define ID2D1Device7_CreateDeviceContext3(p, a, b) (p)->lpVtbl->CreateDeviceContext3(p, a, b)
#define ID2D1Device7_CreateDeviceContext4(p, a, b) (p)->lpVtbl->CreateDeviceContext4(p, a, b)
#define ID2D1Device7_SetMaximumColorGlyphCacheMemory(p, a) (p)->lpVtbl->SetMaximumColorGlyphCacheMemory(p, a)
#define ID2D1Device7_GetMaximumColorGlyphCacheMemory(p, a) (p)->lpVtbl->GetMaximumColorGlyphCacheMemory(p, a)
#define ID2D1Device7_CreateDeviceContext5(p, a, b) (p)->lpVtbl->CreateDeviceContext5(p, a, b)
#define ID2D1Device7_CreateDeviceContext6(p, a, b) (p)->lpVtbl->CreateDeviceContext5(p, a, b)
#define ID2D1Device7_CreateDeviceContext7(p, a, b) (p)->lpVtbl->CreateDeviceContext5(p, a, b)

' ============================================================================
' Factory Interfaces
' ============================================================================
Type ID2D1Factory3Vtbl As ID2D1Factory3Vtbl_
Type ID2D1Factory3
    lpVtbl As ID2D1Factory3Vtbl Ptr
End Type
Type ID2D1Factory3Vtbl_     '' Extends ID2D1Factory2Vtbl_
    QueryInterface As Function(ByVal This As ID2D1Factory3 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Factory3 Ptr) As ULong
    Release As Function(ByVal This As ID2D1Factory3 Ptr) As ULong
        ' 2. AddRef
        ' 4.
    ReloadSystemMetrics As Function(ByVal This As ID2D1Factory3 Ptr) As HRESULT
    GetDesktopDpi As Sub(ByVal This As ID2D1Factory3 Ptr, ByVal dpiX As Single Ptr, ByVal dpiY As Single Ptr)
    CreateRectangleGeometry As Function(ByVal This As ID2D1Factory3 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal geometry As ID2D1RectangleGeometry Ptr Ptr) As HRESULT
    CreateRoundedRectangleGeometry As Function(ByVal This As ID2D1Factory3 Ptr, ByVal rect As D2D1_ROUNDED_RECT Ptr, ByVal geometry As ID2D1RoundedRectangleGeometry Ptr Ptr) As HRESULT
    CreateEllipseGeometry As Function(ByVal This As ID2D1Factory3 Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal ID2D1EllipseGeometry As Any Ptr Ptr) As HRESULT
    CreateGeometryGroup As Function(ByVal This As ID2D1Factory3 Ptr, ByVal fill_mode As D2D1_FILL_MODE, ByVal geometries As ID2D1Geometry Ptr Ptr, ByVal geometryCount As ULong, ByVal group As ID2D1GeometryGroup Ptr Ptr) As HRESULT
    CreateTransformedGeometry As Function(ByVal This As ID2D1Factory3 Ptr, ByVal src_geometry As ID2D1Geometry Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr, ByVal transformedGeometry As ID2D1TransformedGeometry Ptr Ptr) As HRESULT
    CreatePathGeometry As Function(ByVal This As ID2D1Factory3 Ptr, ByVal geometry As ID2D1PathGeometry Ptr Ptr) As HRESULT
    CreateStrokeStyle As Function(ByVal This As ID2D1Factory3 Ptr, ByVal styleProps As D2D1_STROKE_STYLE_PROPERTIES Ptr, ByVal dashes As Single Ptr, ByVal dashCount As ULong, ByVal strokeStyle As ID2D1StrokeStyle Ptr Ptr) As HRESULT
    CreateDrawingStateBlock As Function(ByVal This As ID2D1Factory3 Ptr, ByVal stateDesc As D2D1_DRAWING_STATE_DESCRIPTION Ptr, ByVal text_renderingParams As Any Ptr, ByVal stateBlock As IUnknownBase Ptr Ptr) As HRESULT ' ID2D1DrawingStateBlock
    CreateWicBitmapRenderTarget As Function(ByVal This As ID2D1Factory3 Ptr, ByVal target As Any Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1RenderTarget Ptr Ptr) As HRESULT
    CreateHwndRenderTarget As Function(ByVal This As ID2D1Factory3 Ptr, ByVal desc As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal targetProps As D2D1_HWND_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1HwndRenderTarget Ptr Ptr) As HRESULT
    CreateDxgiSurfaceRenderTarget As Function(ByVal This As ID2D1Factory3 Ptr, ByVal surface As Any Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1RenderTarget Ptr Ptr) As HRESULT
    CreateDCRenderTarget As Function(ByVal This As ID2D1Factory3 Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1DCRenderTarget Ptr Ptr) As HRESULT
    	' Erbt von ID2D1Factory (1-17 Methoden)
    	' 18. CreateDevice
    CreateDevice As Function(ByVal This As ID2D1Factory3 Ptr,  ByVal dxgi_device As Any Ptr, ByVal device As ID2D1Device Ptr Ptr ) As HRESULT
    	' 19. CreateStrokeStyle (überladen)
    CreateStrokeStyle1 As Function(ByVal This As ID2D1Factory3 Ptr,  ByVal desc As D2D1_STROKE_STYLE_PROPERTIES1 Ptr, ByVal dashes As Single Ptr, ByVal dash_count As ULong, ByVal stroke_style As Any Ptr Ptr ) As HRESULT
    	' 20. CreatePathGeometry (überladen)
    CreatePathGeometry1 As Function(ByVal This As ID2D1Factory3 Ptr,  ByVal geometry As Any Ptr Ptr ) As HRESULT
    	' 21. CreateDrawingStateBlock (überladen)
    CreateDrawingStateBlock1 As Function(ByVal This As ID2D1Factory3 Ptr,  ByVal desc As D2D1_DRAWING_STATE_DESCRIPTION1 Ptr, ByVal text_rendering_params As Any Ptr, ByVal state_block As Any Ptr Ptr ) As HRESULT
    	' 22. CreateGdiMetafile
    CreateGdiMetafile As Function(ByVal This As ID2D1Factory3 Ptr,  ByVal stream As Any Ptr, ByVal metafile As Any Ptr Ptr ) As HRESULT
    	' 23. RegisterEffectFromStream
    RegisterEffectFromStream As Function(ByVal This As ID2D1Factory3 Ptr,  ByRef effect_id As GUID, ByVal property_xml As Any Ptr, ByVal bindings As Any Ptr, ByVal binding_count As ULong, ByVal effect_factory As PD2D1_EFFECT_FACTORY Ptr ) As HRESULT
    	' 24. RegisterEffectFromString
    RegisterEffectFromString As Function(ByVal This As ID2D1Factory3 Ptr,  ByVal effect_id As GUID, ByVal property_xml As WString Ptr, ByVal bindings As Any Ptr, ByVal binding_count As ULong, ByVal effect_factory As PD2D1_EFFECT_FACTORY Ptr ) As HRESULT
    	' 25. UnregisterEffect
    UnregisterEffect As Function(ByVal This As ID2D1Factory3 Ptr,  ByRef effect_id As GUID ) As HRESULT
    	' 26. GetRegisteredEffects
    GetRegisteredEffects As Function(ByVal This As ID2D1Factory3 Ptr,  ByVal effects As GUID Ptr, ByVal effect_count As ULong, ByVal returned As ULong Ptr, ByVal registered As ULong Ptr ) As HRESULT
    	' 27. GetEffectProperties
    GetEffectProperties As Function(ByVal This As ID2D1Factory3 Ptr,  ByRef effect_id As GUID, ByVal props As Any Ptr Ptr ) As HRESULT
        ' Erbt von ID2D1Factory1 (1-20 Methoden)
        ' 21. CreateDevice
    CreateDevice1 As Function(ByVal This As ID2D1Factory3 Ptr,  ByVal dxgi_device As Any Ptr, ByVal device As Any Ptr Ptr ) As HRESULT

    CreateDevice2 As Function(ByVal This As ID2D1Factory3 Ptr,  ByVal dxgi_device As Any Ptr, ByVal d2d_device As Any Ptr Ptr ) As HRESULT
End Type
#define ID2D1Factory3_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Factory3_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Factory3_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Factory3_ReloadSystemMetrics(p, a) (p)->lpVtbl->ReloadSystemMetrics(p, a)
#define ID2D1Factory3_GetDesktopDpi(p, a, b) (p)->lpVtbl->GetDesktopDpi(p, a, b)
#define ID2D1Factory3_CreateRectangleGeometry(p, a, b) (p)->lpVtbl->CreateRectangleGeometry(p, a, b)
#define ID2D1Factory3_CreateRoundedRectangleGeometry(p, a, b) (p)->lpVtbl->CreateRoundedRectangleGeometry(p, a, b)
#define ID2D1Factory3_CreateEllipseGeometry(p, a, b) (p)->lpVtbl->CreateEllipseGeometry(p, a, b)
#define ID2D1Factory3_CreateGeometryGroup(p, a, b, c, d) (p)->lpVtbl->CreateGeometryGroup(p, a, b, c, d)
#define ID2D1Factory3_CreateTransformedGeometry(p, a, b, c) (p)->lpVtbl->CreateTransformedGeometry(p, a, b, c)
#define ID2D1Factory3_CreatePathGeometry(p, a) (p)->lpVtbl->CreatePathGeometry(p, a)
#define ID2D1Factory3_CreateStrokeStyle(p, a, b, c, d) (p)->lpVtbl->CreateStrokeStyle(p, a, b, c, d)
#define ID2D1Factory3_CreateDrawingStateBlock(p, a, b, c) (p)->lpVtbl->CreateDrawingStateBlock(p, a, b, c)
#define ID2D1Factory3_CreateWicBitmapRenderTarget(p, a, b, c) (p)->lpVtbl->CreateWicBitmapRenderTarget(p, a, b, c)
#define ID2D1Factory3_CreateHwndRenderTarget(p, a, b, c) (p)->lpVtbl->CreateHwndRenderTarget(p, a, b, c)
#define ID2D1Factory3_CreateDxgiSurfaceRenderTarget(p, a, b, c) (p)->lpVtbl->CreateDxgiSurfaceRenderTarget(p, a, b, c)
#define ID2D1Factory3_CreateDCRenderTarget(p, a, b) (p)->lpVtbl->CreateDCRenderTarget(p, a, b)
#define ID2D1Factory3_CreateDevice(p, a, b) (p)->lpVtbl->CreateDevice(p, a, b)
#define ID2D1Factory3_CreateStrokeStyle1(p, a, b, c, d) (p)->lpVtbl->CreateStrokeStyle1(p, a, b, c, d)
#define ID2D1Factory3_CreatePathGeometry1(p, a) (p)->lpVtbl->CreatePathGeometry1(p, a)
#define ID2D1Factory3_CreateDrawingStateBlock1(p, a, b, c) (p)->lpVtbl->CreateDrawingStateBlock1(p, a, b, c)
#define ID2D1Factory3_CreateGdiMetafile(p, a, b) (p)->lpVtbl->CreateGdiMetafile(p, a, b)
#define ID2D1Factory3_RegisterEffectFromStream(p, a, b, c, d, e) (p)->lpVtbl->RegisterEffectFromStream(p, a, b, c, d, e)
#define ID2D1Factory3_RegisterEffectFromString(p, a, b, c, d, e) (p)->lpVtbl->RegisterEffectFromString(p, a, b, c, d, e)
#define ID2D1Factory3_UnregisterEffect(p, a) (p)->lpVtbl->UnregisterEffect(p, a)
#define ID2D1Factory3_GetRegisteredEffects(p, a, b, c, d) (p)->lpVtbl->GetRegisteredEffects(p, a, b, c, d)
#define ID2D1Factory3_GetEffectProperties(p, a, b) (p)->lpVtbl->GetEffectProperties(p, a, b)
#define ID2D1Factory3_CreateDevice1(p, a, b) (p)->lpVtbl->CreateDevice1(p, a, b)
#define ID2D1Factory3_CreateDevice2(p, a, b) (p)->lpVtbl->CreateDevice2(p, a, b)

Type ID2D1Factory4Vtbl As ID2D1Factory4Vtbl_
Type ID2D1Factory4
    lpVtbl As ID2D1Factory4Vtbl Ptr
End Type
Type ID2D1Factory4Vtbl_     '' Extends ID2D1Factory3Vtbl_
    QueryInterface As Function(ByVal This As ID2D1Factory4 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Factory4 Ptr) As ULong
    Release As Function(ByVal This As ID2D1Factory4 Ptr) As ULong
        ' 2. AddRef
        ' 4.
    ReloadSystemMetrics As Function(ByVal This As ID2D1Factory4 Ptr) As HRESULT
    GetDesktopDpi As Sub(ByVal This As ID2D1Factory4 Ptr, ByVal dpiX As Single Ptr, ByVal dpiY As Single Ptr)
    CreateRectangleGeometry As Function(ByVal This As ID2D1Factory4 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal geometry As ID2D1RectangleGeometry Ptr Ptr) As HRESULT
    CreateRoundedRectangleGeometry As Function(ByVal This As ID2D1Factory4 Ptr, ByVal rect As D2D1_ROUNDED_RECT Ptr, ByVal geometry As ID2D1RoundedRectangleGeometry Ptr Ptr) As HRESULT
    CreateEllipseGeometry As Function(ByVal This As ID2D1Factory4 Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal ID2D1EllipseGeometry As Any Ptr Ptr) As HRESULT
    CreateGeometryGroup As Function(ByVal This As ID2D1Factory4 Ptr, ByVal fill_mode As D2D1_FILL_MODE, ByVal geometries As ID2D1Geometry Ptr Ptr, ByVal geometryCount As ULong, ByVal group As ID2D1GeometryGroup Ptr Ptr) As HRESULT
    CreateTransformedGeometry As Function(ByVal This As ID2D1Factory4 Ptr, ByVal src_geometry As ID2D1Geometry Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr, ByVal transformedGeometry As ID2D1TransformedGeometry Ptr Ptr) As HRESULT
    CreatePathGeometry As Function(ByVal This As ID2D1Factory4 Ptr, ByVal geometry As ID2D1PathGeometry Ptr Ptr) As HRESULT
    CreateStrokeStyle As Function(ByVal This As ID2D1Factory4 Ptr, ByVal styleProps As D2D1_STROKE_STYLE_PROPERTIES Ptr, ByVal dashes As Single Ptr, ByVal dashCount As ULong, ByVal strokeStyle As ID2D1StrokeStyle Ptr Ptr) As HRESULT
    CreateDrawingStateBlock As Function(ByVal This As ID2D1Factory4 Ptr, ByVal stateDesc As D2D1_DRAWING_STATE_DESCRIPTION Ptr, ByVal text_renderingParams As Any Ptr, ByVal stateBlock As IUnknownBase Ptr Ptr) As HRESULT ' ID2D1DrawingStateBlock
    CreateWicBitmapRenderTarget As Function(ByVal This As ID2D1Factory4 Ptr, ByVal target As Any Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1RenderTarget Ptr Ptr) As HRESULT
    CreateHwndRenderTarget As Function(ByVal This As ID2D1Factory4 Ptr, ByVal desc As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal targetProps As D2D1_HWND_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1HwndRenderTarget Ptr Ptr) As HRESULT
    CreateDxgiSurfaceRenderTarget As Function(ByVal This As ID2D1Factory4 Ptr, ByVal surface As Any Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1RenderTarget Ptr Ptr) As HRESULT
    CreateDCRenderTarget As Function(ByVal This As ID2D1Factory4 Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1DCRenderTarget Ptr Ptr) As HRESULT
    	' Erbt von ID2D1Factory (1-17 Methoden)
    	' 18. CreateDevice
    CreateDevice As Function(ByVal This As ID2D1Factory4 Ptr,  ByVal dxgi_device As Any Ptr, ByVal device As ID2D1Device Ptr Ptr ) As HRESULT
    	' 19. CreateStrokeStyle (überladen)
    CreateStrokeStyle1 As Function(ByVal This As ID2D1Factory4 Ptr,  ByVal desc As D2D1_STROKE_STYLE_PROPERTIES1 Ptr, ByVal dashes As Single Ptr, ByVal dash_count As ULong, ByVal stroke_style As Any Ptr Ptr ) As HRESULT
    	' 20. CreatePathGeometry (überladen)
    CreatePathGeometry1 As Function(ByVal This As ID2D1Factory4 Ptr,  ByVal geometry As Any Ptr Ptr ) As HRESULT
    	' 21. CreateDrawingStateBlock (überladen)
    CreateDrawingStateBlock1 As Function(ByVal This As ID2D1Factory4 Ptr,  ByVal desc As D2D1_DRAWING_STATE_DESCRIPTION1 Ptr, ByVal text_rendering_params As Any Ptr, ByVal state_block As Any Ptr Ptr ) As HRESULT
    	' 22. CreateGdiMetafile
    CreateGdiMetafile As Function(ByVal This As ID2D1Factory4 Ptr,  ByVal stream As Any Ptr, ByVal metafile As Any Ptr Ptr ) As HRESULT
    	' 23. RegisterEffectFromStream
    RegisterEffectFromStream As Function(ByVal This As ID2D1Factory4 Ptr,  ByRef effect_id As GUID, ByVal property_xml As Any Ptr, ByVal bindings As Any Ptr, ByVal binding_count As ULong, ByVal effect_factory As PD2D1_EFFECT_FACTORY Ptr ) As HRESULT
    	' 24. RegisterEffectFromString
    RegisterEffectFromString As Function(ByVal This As ID2D1Factory4 Ptr,  ByVal effect_id As GUID, ByVal property_xml As WString Ptr, ByVal bindings As Any Ptr, ByVal binding_count As ULong, ByVal effect_factory As PD2D1_EFFECT_FACTORY Ptr ) As HRESULT
    	' 25. UnregisterEffect
    UnregisterEffect As Function(ByVal This As ID2D1Factory4 Ptr,  ByRef effect_id As GUID ) As HRESULT
    	' 26. GetRegisteredEffects
    GetRegisteredEffects As Function(ByVal This As ID2D1Factory4 Ptr,  ByVal effects As GUID Ptr, ByVal effect_count As ULong, ByVal returned As ULong Ptr, ByVal registered As ULong Ptr ) As HRESULT
    	' 27. GetEffectProperties
    GetEffectProperties As Function(ByVal This As ID2D1Factory4 Ptr,  ByRef effect_id As GUID, ByVal props As Any Ptr Ptr ) As HRESULT
        ' Erbt von ID2D1Factory1 (1-20 Methoden)
        ' 21. CreateDevice
    CreateDevice1 As Function(ByVal This As ID2D1Factory4 Ptr,  ByVal dxgi_device As Any Ptr, ByVal device As Any Ptr Ptr ) As HRESULT
    CreateDevice2 As Function(ByVal This As ID2D1Factory4 Ptr,  ByVal dxgi_device As Any Ptr, ByVal d2d_device As Any Ptr Ptr ) As HRESULT

    CreateDevice3 As Function(ByVal This As ID2D1Factory4 Ptr,  ByVal dxgi_device As Any Ptr, ByVal d2d_device As Any Ptr Ptr ) As HRESULT
End Type
#define ID2D1Factory4_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Factory4_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Factory4_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Factory4_ReloadSystemMetrics(p, a) (p)->lpVtbl->ReloadSystemMetrics(p, a)
#define ID2D1Factory4_GetDesktopDpi(p, a, b) (p)->lpVtbl->GetDesktopDpi(p, a, b)
#define ID2D1Factory4_CreateRectangleGeometry(p, a, b) (p)->lpVtbl->CreateRectangleGeometry(p, a, b)
#define ID2D1Factory4_CreateRoundedRectangleGeometry(p, a, b) (p)->lpVtbl->CreateRoundedRectangleGeometry(p, a, b)
#define ID2D1Factory4_CreateEllipseGeometry(p, a, b) (p)->lpVtbl->CreateEllipseGeometry(p, a, b)
#define ID2D1Factory4_CreateGeometryGroup(p, a, b, c, d) (p)->lpVtbl->CreateGeometryGroup(p, a, b, c, d)
#define ID2D1Factory4_CreateTransformedGeometry(p, a, b, c) (p)->lpVtbl->CreateTransformedGeometry(p, a, b, c)
#define ID2D1Factory4_CreatePathGeometry(p, a) (p)->lpVtbl->CreatePathGeometry(p, a)
#define ID2D1Factory4_CreateStrokeStyle(p, a, b, c, d) (p)->lpVtbl->CreateStrokeStyle(p, a, b, c, d)
#define ID2D1Factory4_CreateDrawingStateBlock(p, a, b, c) (p)->lpVtbl->CreateDrawingStateBlock(p, a, b, c)
#define ID2D1Factory4_CreateWicBitmapRenderTarget(p, a, b, c) (p)->lpVtbl->CreateWicBitmapRenderTarget(p, a, b, c)
#define ID2D1Factory4_CreateHwndRenderTarget(p, a, b, c) (p)->lpVtbl->CreateHwndRenderTarget(p, a, b, c)
#define ID2D1Factory4_CreateDxgiSurfaceRenderTarget(p, a, b, c) (p)->lpVtbl->CreateDxgiSurfaceRenderTarget(p, a, b, c)
#define ID2D1Factory4_CreateDCRenderTarget(p, a, b) (p)->lpVtbl->CreateDCRenderTarget(p, a, b)
#define ID2D1Factory4_CreateDevice(p, a, b) (p)->lpVtbl->CreateDevice(p, a, b)
#define ID2D1Factory4_CreateStrokeStyle1(p, a, b, c, d) (p)->lpVtbl->CreateStrokeStyle1(p, a, b, c, d)
#define ID2D1Factory4_CreatePathGeometry1(p, a) (p)->lpVtbl->CreatePathGeometry1(p, a)
#define ID2D1Factory4_CreateDrawingStateBlock1(p, a, b, c) (p)->lpVtbl->CreateDrawingStateBlock1(p, a, b, c)
#define ID2D1Factory4_CreateGdiMetafile(p, a, b) (p)->lpVtbl->CreateGdiMetafile(p, a, b)
#define ID2D1Factory4_RegisterEffectFromStream(p, a, b, c, d, e) (p)->lpVtbl->RegisterEffectFromStream(p, a, b, c, d, e)
#define ID2D1Factory4_RegisterEffectFromString(p, a, b, c, d, e) (p)->lpVtbl->RegisterEffectFromString(p, a, b, c, d, e)
#define ID2D1Factory4_UnregisterEffect(p, a) (p)->lpVtbl->UnregisterEffect(p, a)
#define ID2D1Factory4_GetRegisteredEffects(p, a, b, c, d) (p)->lpVtbl->GetRegisteredEffects(p, a, b, c, d)
#define ID2D1Factory4_GetEffectProperties(p, a, b) (p)->lpVtbl->GetEffectProperties(p, a, b)
#define ID2D1Factory4_CreateDevice1(p, a, b) (p)->lpVtbl->CreateDevice1(p, a, b)
#define ID2D1Factory4_CreateDevice2(p, a, b) (p)->lpVtbl->CreateDevice2(p, a, b)
#define ID2D1Factory4_CreateDevice3(p, a, b) (p)->lpVtbl->CreateDevice3(p, a, b)

Type ID2D1Factory5Vtbl As ID2D1Factory5Vtbl_
Type ID2D1Factory5
    lpVtbl As ID2D1Factory5Vtbl Ptr
End Type
Type ID2D1Factory5Vtbl_     '' Extends ID2D1Factory4Vtbl_
    QueryInterface As Function(ByVal This As ID2D1Factory5 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Factory5 Ptr) As ULong
    Release As Function(ByVal This As ID2D1Factory5 Ptr) As ULong
        ' 2. AddRef
        ' 4.
    ReloadSystemMetrics As Function(ByVal This As ID2D1Factory5 Ptr) As HRESULT
    GetDesktopDpi As Sub(ByVal This As ID2D1Factory5 Ptr, ByVal dpiX As Single Ptr, ByVal dpiY As Single Ptr)
    CreateRectangleGeometry As Function(ByVal This As ID2D1Factory5 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal geometry As ID2D1RectangleGeometry Ptr Ptr) As HRESULT
    CreateRoundedRectangleGeometry As Function(ByVal This As ID2D1Factory5 Ptr, ByVal rect As D2D1_ROUNDED_RECT Ptr, ByVal geometry As ID2D1RoundedRectangleGeometry Ptr Ptr) As HRESULT
    CreateEllipseGeometry As Function(ByVal This As ID2D1Factory5 Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal ID2D1EllipseGeometry As Any Ptr Ptr) As HRESULT
    CreateGeometryGroup As Function(ByVal This As ID2D1Factory5 Ptr, ByVal fill_mode As D2D1_FILL_MODE, ByVal geometries As ID2D1Geometry Ptr Ptr, ByVal geometryCount As ULong, ByVal group As ID2D1GeometryGroup Ptr Ptr) As HRESULT
    CreateTransformedGeometry As Function(ByVal This As ID2D1Factory5 Ptr, ByVal src_geometry As ID2D1Geometry Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr, ByVal transformedGeometry As ID2D1TransformedGeometry Ptr Ptr) As HRESULT
    CreatePathGeometry As Function(ByVal This As ID2D1Factory5 Ptr, ByVal geometry As ID2D1PathGeometry Ptr Ptr) As HRESULT
    CreateStrokeStyle As Function(ByVal This As ID2D1Factory5 Ptr, ByVal styleProps As D2D1_STROKE_STYLE_PROPERTIES Ptr, ByVal dashes As Single Ptr, ByVal dashCount As ULong, ByVal strokeStyle As ID2D1StrokeStyle Ptr Ptr) As HRESULT
    CreateDrawingStateBlock As Function(ByVal This As ID2D1Factory5 Ptr, ByVal stateDesc As D2D1_DRAWING_STATE_DESCRIPTION Ptr, ByVal text_renderingParams As Any Ptr, ByVal stateBlock As IUnknownBase Ptr Ptr) As HRESULT ' ID2D1DrawingStateBlock
    CreateWicBitmapRenderTarget As Function(ByVal This As ID2D1Factory5 Ptr, ByVal target As Any Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1RenderTarget Ptr Ptr) As HRESULT
    CreateHwndRenderTarget As Function(ByVal This As ID2D1Factory5 Ptr, ByVal desc As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal targetProps As D2D1_HWND_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1HwndRenderTarget Ptr Ptr) As HRESULT
    CreateDxgiSurfaceRenderTarget As Function(ByVal This As ID2D1Factory5 Ptr, ByVal surface As Any Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1RenderTarget Ptr Ptr) As HRESULT
    CreateDCRenderTarget As Function(ByVal This As ID2D1Factory5 Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1DCRenderTarget Ptr Ptr) As HRESULT
    	' Erbt von ID2D1Factory (1-17 Methoden)
    	' 18. CreateDevice
    CreateDevice As Function(ByVal This As ID2D1Factory5 Ptr,  ByVal dxgi_device As Any Ptr, ByVal device As ID2D1Device Ptr Ptr ) As HRESULT
    	' 19. CreateStrokeStyle (überladen)
    CreateStrokeStyle1 As Function(ByVal This As ID2D1Factory5 Ptr,  ByVal desc As D2D1_STROKE_STYLE_PROPERTIES1 Ptr, ByVal dashes As Single Ptr, ByVal dash_count As ULong, ByVal stroke_style As Any Ptr Ptr ) As HRESULT
    	' 20. CreatePathGeometry (überladen)
    CreatePathGeometry1 As Function(ByVal This As ID2D1Factory5 Ptr,  ByVal geometry As Any Ptr Ptr ) As HRESULT
    	' 21. CreateDrawingStateBlock (überladen)
    CreateDrawingStateBlock1 As Function(ByVal This As ID2D1Factory5 Ptr,  ByVal desc As D2D1_DRAWING_STATE_DESCRIPTION1 Ptr, ByVal text_rendering_params As Any Ptr, ByVal state_block As Any Ptr Ptr ) As HRESULT
    	' 22. CreateGdiMetafile
    CreateGdiMetafile As Function(ByVal This As ID2D1Factory5 Ptr,  ByVal stream As Any Ptr, ByVal metafile As Any Ptr Ptr ) As HRESULT
    	' 23. RegisterEffectFromStream
    RegisterEffectFromStream As Function(ByVal This As ID2D1Factory5 Ptr,  ByRef effect_id As GUID, ByVal property_xml As Any Ptr, ByVal bindings As Any Ptr, ByVal binding_count As ULong, ByVal effect_factory As PD2D1_EFFECT_FACTORY Ptr ) As HRESULT
    	' 24. RegisterEffectFromString
    RegisterEffectFromString As Function(ByVal This As ID2D1Factory5 Ptr,  ByVal effect_id As GUID, ByVal property_xml As WString Ptr, ByVal bindings As Any Ptr, ByVal binding_count As ULong, ByVal effect_factory As PD2D1_EFFECT_FACTORY Ptr ) As HRESULT
    	' 25. UnregisterEffect
    UnregisterEffect As Function(ByVal This As ID2D1Factory5 Ptr,  ByRef effect_id As GUID ) As HRESULT
    	' 26. GetRegisteredEffects
    GetRegisteredEffects As Function(ByVal This As ID2D1Factory5 Ptr,  ByVal effects As GUID Ptr, ByVal effect_count As ULong, ByVal returned As ULong Ptr, ByVal registered As ULong Ptr ) As HRESULT
    	' 27. GetEffectProperties
    GetEffectProperties As Function(ByVal This As ID2D1Factory5 Ptr,  ByRef effect_id As GUID, ByVal props As Any Ptr Ptr ) As HRESULT
        ' Erbt von ID2D1Factory1 (1-20 Methoden)
        ' 21. CreateDevice
    CreateDevice1 As Function(ByVal This As ID2D1Factory5 Ptr,  ByVal dxgi_device As Any Ptr, ByVal device As Any Ptr Ptr ) As HRESULT
    CreateDevice2 As Function(ByVal This As ID2D1Factory5 Ptr,  ByVal dxgi_device As Any Ptr, ByVal d2d_device As Any Ptr Ptr ) As HRESULT
    CreateDevice3 As Function(ByVal This As ID2D1Factory5 Ptr,  ByVal dxgi_device As Any Ptr, ByVal d2d_device As Any Ptr Ptr ) As HRESULT

    CreateDevice4 As Function(ByVal This As ID2D1Factory5 Ptr,  ByVal dxgi_device As Any Ptr, ByVal d2d_device As Any Ptr Ptr ) As HRESULT
End Type
#define ID2D1Factory5_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Factory5_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Factory5_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Factory5_ReloadSystemMetrics(p, a) (p)->lpVtbl->ReloadSystemMetrics(p, a)
#define ID2D1Factory5_GetDesktopDpi(p, a, b) (p)->lpVtbl->GetDesktopDpi(p, a, b)
#define ID2D1Factory5_CreateRectangleGeometry(p, a, b) (p)->lpVtbl->CreateRectangleGeometry(p, a, b)
#define ID2D1Factory5_CreateRoundedRectangleGeometry(p, a, b) (p)->lpVtbl->CreateRoundedRectangleGeometry(p, a, b)
#define ID2D1Factory5_CreateEllipseGeometry(p, a, b) (p)->lpVtbl->CreateEllipseGeometry(p, a, b)
#define ID2D1Factory5_CreateGeometryGroup(p, a, b, c, d) (p)->lpVtbl->CreateGeometryGroup(p, a, b, c, d)
#define ID2D1Factory5_CreateTransformedGeometry(p, a, b, c) (p)->lpVtbl->CreateTransformedGeometry(p, a, b, c)
#define ID2D1Factory5_CreatePathGeometry(p, a) (p)->lpVtbl->CreatePathGeometry(p, a)
#define ID2D1Factory5_CreateStrokeStyle(p, a, b, c, d) (p)->lpVtbl->CreateStrokeStyle(p, a, b, c, d)
#define ID2D1Factory5_CreateDrawingStateBlock(p, a, b, c) (p)->lpVtbl->CreateDrawingStateBlock(p, a, b, c)
#define ID2D1Factory5_CreateWicBitmapRenderTarget(p, a, b, c) (p)->lpVtbl->CreateWicBitmapRenderTarget(p, a, b, c)
#define ID2D1Factory5_CreateHwndRenderTarget(p, a, b, c) (p)->lpVtbl->CreateHwndRenderTarget(p, a, b, c)
#define ID2D1Factory5_CreateDxgiSurfaceRenderTarget(p, a, b, c) (p)->lpVtbl->CreateDxgiSurfaceRenderTarget(p, a, b, c)
#define ID2D1Factory5_CreateDCRenderTarget(p, a, b) (p)->lpVtbl->CreateDCRenderTarget(p, a, b)
#define ID2D1Factory5_CreateDevice(p, a, b) (p)->lpVtbl->CreateDevice(p, a, b)
#define ID2D1Factory5_CreateStrokeStyle1(p, a, b, c, d) (p)->lpVtbl->CreateStrokeStyle1(p, a, b, c, d)
#define ID2D1Factory5_CreatePathGeometry1(p, a) (p)->lpVtbl->CreatePathGeometry1(p, a)
#define ID2D1Factory5_CreateDrawingStateBlock1(p, a, b, c) (p)->lpVtbl->CreateDrawingStateBlock1(p, a, b, c)
#define ID2D1Factory5_CreateGdiMetafile(p, a, b) (p)->lpVtbl->CreateGdiMetafile(p, a, b)
#define ID2D1Factory5_RegisterEffectFromStream(p, a, b, c, d, e) (p)->lpVtbl->RegisterEffectFromStream(p, a, b, c, d, e)
#define ID2D1Factory5_RegisterEffectFromString(p, a, b, c, d, e) (p)->lpVtbl->RegisterEffectFromString(p, a, b, c, d, e)
#define ID2D1Factory5_UnregisterEffect(p, a) (p)->lpVtbl->UnregisterEffect(p, a)
#define ID2D1Factory5_GetRegisteredEffects(p, a, b, c, d) (p)->lpVtbl->GetRegisteredEffects(p, a, b, c, d)
#define ID2D1Factory5_GetEffectProperties(p, a, b) (p)->lpVtbl->GetEffectProperties(p, a, b)
#define ID2D1Factory5_CreateDevice1(p, a, b) (p)->lpVtbl->CreateDevice1(p, a, b)
#define ID2D1Factory5_CreateDevice2(p, a, b) (p)->lpVtbl->CreateDevice2(p, a, b)
#define ID2D1Factory5_CreateDevice3(p, a, b) (p)->lpVtbl->CreateDevice3(p, a, b)
#define ID2D1Factory5_CreateDevice4(p, a, b) (p)->lpVtbl->CreateDevice4(p, a, b)

Type ID2D1Factory6Vtbl As ID2D1Factory6Vtbl_
Type ID2D1Factory6
    lpVtbl As ID2D1Factory6Vtbl Ptr
End Type
Type ID2D1Factory6Vtbl_     '' Extends ID2D1Factory5Vtbl_
    QueryInterface As Function(ByVal This As ID2D1Factory6 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Factory6 Ptr) As ULong
    Release As Function(ByVal This As ID2D1Factory6 Ptr) As ULong
        ' 2. AddRef
        ' 4.
    ReloadSystemMetrics As Function(ByVal This As ID2D1Factory6 Ptr) As HRESULT
    GetDesktopDpi As Sub(ByVal This As ID2D1Factory6 Ptr, ByVal dpiX As Single Ptr, ByVal dpiY As Single Ptr)
    CreateRectangleGeometry As Function(ByVal This As ID2D1Factory6 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal geometry As ID2D1RectangleGeometry Ptr Ptr) As HRESULT
    CreateRoundedRectangleGeometry As Function(ByVal This As ID2D1Factory6 Ptr, ByVal rect As D2D1_ROUNDED_RECT Ptr, ByVal geometry As ID2D1RoundedRectangleGeometry Ptr Ptr) As HRESULT
    CreateEllipseGeometry As Function(ByVal This As ID2D1Factory6 Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal ID2D1EllipseGeometry As Any Ptr Ptr) As HRESULT
    CreateGeometryGroup As Function(ByVal This As ID2D1Factory6 Ptr, ByVal fill_mode As D2D1_FILL_MODE, ByVal geometries As ID2D1Geometry Ptr Ptr, ByVal geometryCount As ULong, ByVal group As ID2D1GeometryGroup Ptr Ptr) As HRESULT
    CreateTransformedGeometry As Function(ByVal This As ID2D1Factory6 Ptr, ByVal src_geometry As ID2D1Geometry Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr, ByVal transformedGeometry As ID2D1TransformedGeometry Ptr Ptr) As HRESULT
    CreatePathGeometry As Function(ByVal This As ID2D1Factory6 Ptr, ByVal geometry As ID2D1PathGeometry Ptr Ptr) As HRESULT
    CreateStrokeStyle As Function(ByVal This As ID2D1Factory6 Ptr, ByVal styleProps As D2D1_STROKE_STYLE_PROPERTIES Ptr, ByVal dashes As Single Ptr, ByVal dashCount As ULong, ByVal strokeStyle As ID2D1StrokeStyle Ptr Ptr) As HRESULT
    CreateDrawingStateBlock As Function(ByVal This As ID2D1Factory6 Ptr, ByVal stateDesc As D2D1_DRAWING_STATE_DESCRIPTION Ptr, ByVal text_renderingParams As Any Ptr, ByVal stateBlock As IUnknownBase Ptr Ptr) As HRESULT ' ID2D1DrawingStateBlock
    CreateWicBitmapRenderTarget As Function(ByVal This As ID2D1Factory6 Ptr, ByVal target As Any Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1RenderTarget Ptr Ptr) As HRESULT
    CreateHwndRenderTarget As Function(ByVal This As ID2D1Factory6 Ptr, ByVal desc As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal targetProps As D2D1_HWND_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1HwndRenderTarget Ptr Ptr) As HRESULT
    CreateDxgiSurfaceRenderTarget As Function(ByVal This As ID2D1Factory6 Ptr, ByVal surface As Any Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1RenderTarget Ptr Ptr) As HRESULT
    CreateDCRenderTarget As Function(ByVal This As ID2D1Factory6 Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1DCRenderTarget Ptr Ptr) As HRESULT
    	' Erbt von ID2D1Factory (1-17 Methoden)
    	' 18. CreateDevice
    CreateDevice As Function(ByVal This As ID2D1Factory6 Ptr,  ByVal dxgi_device As Any Ptr, ByVal device As ID2D1Device Ptr Ptr ) As HRESULT
    	' 19. CreateStrokeStyle (überladen)
    CreateStrokeStyle1 As Function(ByVal This As ID2D1Factory6 Ptr,  ByVal desc As D2D1_STROKE_STYLE_PROPERTIES1 Ptr, ByVal dashes As Single Ptr, ByVal dash_count As ULong, ByVal stroke_style As Any Ptr Ptr ) As HRESULT
    	' 20. CreatePathGeometry (überladen)
    CreatePathGeometry1 As Function(ByVal This As ID2D1Factory6 Ptr,  ByVal geometry As Any Ptr Ptr ) As HRESULT
    	' 21. CreateDrawingStateBlock (überladen)
    CreateDrawingStateBlock1 As Function(ByVal This As ID2D1Factory6 Ptr,  ByVal desc As D2D1_DRAWING_STATE_DESCRIPTION1 Ptr, ByVal text_rendering_params As Any Ptr, ByVal state_block As Any Ptr Ptr ) As HRESULT
    	' 22. CreateGdiMetafile
    CreateGdiMetafile As Function(ByVal This As ID2D1Factory6 Ptr,  ByVal stream As Any Ptr, ByVal metafile As Any Ptr Ptr ) As HRESULT
    	' 23. RegisterEffectFromStream
    RegisterEffectFromStream As Function(ByVal This As ID2D1Factory6 Ptr,  ByRef effect_id As GUID, ByVal property_xml As Any Ptr, ByVal bindings As Any Ptr, ByVal binding_count As ULong, ByVal effect_factory As PD2D1_EFFECT_FACTORY Ptr ) As HRESULT
    	' 24. RegisterEffectFromString
    RegisterEffectFromString As Function(ByVal This As ID2D1Factory6 Ptr,  ByVal effect_id As GUID, ByVal property_xml As WString Ptr, ByVal bindings As Any Ptr, ByVal binding_count As ULong, ByVal effect_factory As PD2D1_EFFECT_FACTORY Ptr ) As HRESULT
    	' 25. UnregisterEffect
    UnregisterEffect As Function(ByVal This As ID2D1Factory6 Ptr,  ByRef effect_id As GUID ) As HRESULT
    	' 26. GetRegisteredEffects
    GetRegisteredEffects As Function(ByVal This As ID2D1Factory6 Ptr,  ByVal effects As GUID Ptr, ByVal effect_count As ULong, ByVal returned As ULong Ptr, ByVal registered As ULong Ptr ) As HRESULT
    	' 27. GetEffectProperties
    GetEffectProperties As Function(ByVal This As ID2D1Factory6 Ptr,  ByRef effect_id As GUID, ByVal props As Any Ptr Ptr ) As HRESULT
        ' Erbt von ID2D1Factory1 (1-20 Methoden)
        ' 21. CreateDevice
    CreateDevice1 As Function(ByVal This As ID2D1Factory6 Ptr,  ByVal dxgi_device As Any Ptr, ByVal device As Any Ptr Ptr ) As HRESULT
    CreateDevice2 As Function(ByVal This As ID2D1Factory6 Ptr,  ByVal dxgi_device As Any Ptr, ByVal d2d_device As Any Ptr Ptr ) As HRESULT
    CreateDevice3 As Function(ByVal This As ID2D1Factory6 Ptr,  ByVal dxgi_device As Any Ptr, ByVal d2d_device As Any Ptr Ptr ) As HRESULT
    CreateDevice4 As Function(ByVal This As ID2D1Factory6 Ptr,  ByVal dxgi_device As Any Ptr, ByVal d2d_device As Any Ptr Ptr ) As HRESULT

    CreateDevice5 As Function(ByVal This As ID2D1Factory6 Ptr,  ByVal dxgi_device As Any Ptr, ByVal d2d_device As Any Ptr Ptr ) As HRESULT
End Type
#define ID2D1Factory6_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Factory6_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Factory6_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Factory6_ReloadSystemMetrics(p, a) (p)->lpVtbl->ReloadSystemMetrics(p, a)
#define ID2D1Factory6_GetDesktopDpi(p, a, b) (p)->lpVtbl->GetDesktopDpi(p, a, b)
#define ID2D1Factory6_CreateRectangleGeometry(p, a, b) (p)->lpVtbl->CreateRectangleGeometry(p, a, b)
#define ID2D1Factory6_CreateRoundedRectangleGeometry(p, a, b) (p)->lpVtbl->CreateRoundedRectangleGeometry(p, a, b)
#define ID2D1Factory6_CreateEllipseGeometry(p, a, b) (p)->lpVtbl->CreateEllipseGeometry(p, a, b)
#define ID2D1Factory6_CreateGeometryGroup(p, a, b, c, d) (p)->lpVtbl->CreateGeometryGroup(p, a, b, c, d)
#define ID2D1Factory6_CreateTransformedGeometry(p, a, b, c) (p)->lpVtbl->CreateTransformedGeometry(p, a, b, c)
#define ID2D1Factory6_CreatePathGeometry(p, a) (p)->lpVtbl->CreatePathGeometry(p, a)
#define ID2D1Factory6_CreateStrokeStyle(p, a, b, c, d) (p)->lpVtbl->CreateStrokeStyle(p, a, b, c, d)
#define ID2D1Factory6_CreateDrawingStateBlock(p, a, b, c) (p)->lpVtbl->CreateDrawingStateBlock(p, a, b, c)
#define ID2D1Factory6_CreateWicBitmapRenderTarget(p, a, b, c) (p)->lpVtbl->CreateWicBitmapRenderTarget(p, a, b, c)
#define ID2D1Factory6_CreateHwndRenderTarget(p, a, b, c) (p)->lpVtbl->CreateHwndRenderTarget(p, a, b, c)
#define ID2D1Factory6_CreateDxgiSurfaceRenderTarget(p, a, b, c) (p)->lpVtbl->CreateDxgiSurfaceRenderTarget(p, a, b, c)
#define ID2D1Factory6_CreateDCRenderTarget(p, a, b) (p)->lpVtbl->CreateDCRenderTarget(p, a, b)
#define ID2D1Factory6_CreateDevice(p, a, b) (p)->lpVtbl->CreateDevice(p, a, b)
#define ID2D1Factory6_CreateStrokeStyle1(p, a, b, c, d) (p)->lpVtbl->CreateStrokeStyle1(p, a, b, c, d)
#define ID2D1Factory6_CreatePathGeometry1(p, a) (p)->lpVtbl->CreatePathGeometry1(p, a)
#define ID2D1Factory6_CreateDrawingStateBlock1(p, a, b, c) (p)->lpVtbl->CreateDrawingStateBlock1(p, a, b, c)
#define ID2D1Factory6_CreateGdiMetafile(p, a, b) (p)->lpVtbl->CreateGdiMetafile(p, a, b)
#define ID2D1Factory6_RegisterEffectFromStream(p, a, b, c, d, e) (p)->lpVtbl->RegisterEffectFromStream(p, a, b, c, d, e)
#define ID2D1Factory6_RegisterEffectFromString(p, a, b, c, d, e) (p)->lpVtbl->RegisterEffectFromString(p, a, b, c, d, e)
#define ID2D1Factory6_UnregisterEffect(p, a) (p)->lpVtbl->UnregisterEffect(p, a)
#define ID2D1Factory6_GetRegisteredEffects(p, a, b, c, d) (p)->lpVtbl->GetRegisteredEffects(p, a, b, c, d)
#define ID2D1Factory6_GetEffectProperties(p, a, b) (p)->lpVtbl->GetEffectProperties(p, a, b)
#define ID2D1Factory6_CreateDevice1(p, a, b) (p)->lpVtbl->CreateDevice1(p, a, b)
#define ID2D1Factory6_CreateDevice2(p, a, b) (p)->lpVtbl->CreateDevice2(p, a, b)
#define ID2D1Factory6_CreateDevice3(p, a, b) (p)->lpVtbl->CreateDevice3(p, a, b)
#define ID2D1Factory6_CreateDevice4(p, a, b) (p)->lpVtbl->CreateDevice4(p, a, b)
#define ID2D1Factory6_CreateDevice5(p, a, b) (p)->lpVtbl->CreateDevice5(p, a, b)

Type ID2D1Factory7Vtbl As ID2D1Factory7Vtbl_
Type ID2D1Factory7
    lpVtbl As ID2D1Factory7Vtbl Ptr
End Type
Type ID2D1Factory7Vtbl_     '' Extends ID2D1Factory6Vtbl_
    QueryInterface As Function(ByVal This As ID2D1Factory7 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Factory7 Ptr) As ULong
    Release As Function(ByVal This As ID2D1Factory7 Ptr) As ULong
        ' 2. AddRef
        ' 4.
    ReloadSystemMetrics As Function(ByVal This As ID2D1Factory7 Ptr) As HRESULT
    GetDesktopDpi As Sub(ByVal This As ID2D1Factory7 Ptr, ByVal dpiX As Single Ptr, ByVal dpiY As Single Ptr)
    CreateRectangleGeometry As Function(ByVal This As ID2D1Factory7 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal geometry As ID2D1RectangleGeometry Ptr Ptr) As HRESULT
    CreateRoundedRectangleGeometry As Function(ByVal This As ID2D1Factory7 Ptr, ByVal rect As D2D1_ROUNDED_RECT Ptr, ByVal geometry As ID2D1RoundedRectangleGeometry Ptr Ptr) As HRESULT
    CreateEllipseGeometry As Function(ByVal This As ID2D1Factory7 Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal ID2D1EllipseGeometry As Any Ptr Ptr) As HRESULT
    CreateGeometryGroup As Function(ByVal This As ID2D1Factory7 Ptr, ByVal fill_mode As D2D1_FILL_MODE, ByVal geometries As ID2D1Geometry Ptr Ptr, ByVal geometryCount As ULong, ByVal group As ID2D1GeometryGroup Ptr Ptr) As HRESULT
    CreateTransformedGeometry As Function(ByVal This As ID2D1Factory7 Ptr, ByVal src_geometry As ID2D1Geometry Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr, ByVal transformedGeometry As ID2D1TransformedGeometry Ptr Ptr) As HRESULT
    CreatePathGeometry As Function(ByVal This As ID2D1Factory7 Ptr, ByVal geometry As ID2D1PathGeometry Ptr Ptr) As HRESULT
    CreateStrokeStyle As Function(ByVal This As ID2D1Factory7 Ptr, ByVal styleProps As D2D1_STROKE_STYLE_PROPERTIES Ptr, ByVal dashes As Single Ptr, ByVal dashCount As ULong, ByVal strokeStyle As ID2D1StrokeStyle Ptr Ptr) As HRESULT
    CreateDrawingStateBlock As Function(ByVal This As ID2D1Factory7 Ptr, ByVal stateDesc As D2D1_DRAWING_STATE_DESCRIPTION Ptr, ByVal text_renderingParams As Any Ptr, ByVal stateBlock As IUnknownBase Ptr Ptr) As HRESULT ' ID2D1DrawingStateBlock
    CreateWicBitmapRenderTarget As Function(ByVal This As ID2D1Factory7 Ptr, ByVal target As Any Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1RenderTarget Ptr Ptr) As HRESULT
    CreateHwndRenderTarget As Function(ByVal This As ID2D1Factory7 Ptr, ByVal desc As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal targetProps As D2D1_HWND_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1HwndRenderTarget Ptr Ptr) As HRESULT
    CreateDxgiSurfaceRenderTarget As Function(ByVal This As ID2D1Factory7 Ptr, ByVal surface As Any Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1RenderTarget Ptr Ptr) As HRESULT
    CreateDCRenderTarget As Function(ByVal This As ID2D1Factory7 Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1DCRenderTarget Ptr Ptr) As HRESULT
    	' Erbt von ID2D1Factory (1-17 Methoden)
    	' 18. CreateDevice
    CreateDevice As Function(ByVal This As ID2D1Factory7 Ptr,  ByVal dxgi_device As Any Ptr, ByVal device As ID2D1Device Ptr Ptr ) As HRESULT
    	' 19. CreateStrokeStyle (überladen)
    CreateStrokeStyle1 As Function(ByVal This As ID2D1Factory7 Ptr,  ByVal desc As D2D1_STROKE_STYLE_PROPERTIES1 Ptr, ByVal dashes As Single Ptr, ByVal dash_count As ULong, ByVal stroke_style As Any Ptr Ptr ) As HRESULT
    	' 20. CreatePathGeometry (überladen)
    CreatePathGeometry1 As Function(ByVal This As ID2D1Factory7 Ptr,  ByVal geometry As Any Ptr Ptr ) As HRESULT
    	' 21. CreateDrawingStateBlock (überladen)
    CreateDrawingStateBlock1 As Function(ByVal This As ID2D1Factory7 Ptr,  ByVal desc As D2D1_DRAWING_STATE_DESCRIPTION1 Ptr, ByVal text_rendering_params As Any Ptr, ByVal state_block As Any Ptr Ptr ) As HRESULT
    	' 22. CreateGdiMetafile
    CreateGdiMetafile As Function(ByVal This As ID2D1Factory7 Ptr,  ByVal stream As Any Ptr, ByVal metafile As Any Ptr Ptr ) As HRESULT
    	' 23. RegisterEffectFromStream
    RegisterEffectFromStream As Function(ByVal This As ID2D1Factory7 Ptr,  ByRef effect_id As GUID, ByVal property_xml As Any Ptr, ByVal bindings As Any Ptr, ByVal binding_count As ULong, ByVal effect_factory As PD2D1_EFFECT_FACTORY Ptr ) As HRESULT
    	' 24. RegisterEffectFromString
    RegisterEffectFromString As Function(ByVal This As ID2D1Factory7 Ptr,  ByVal effect_id As GUID, ByVal property_xml As WString Ptr, ByVal bindings As Any Ptr, ByVal binding_count As ULong, ByVal effect_factory As PD2D1_EFFECT_FACTORY Ptr ) As HRESULT
    	' 25. UnregisterEffect
    UnregisterEffect As Function(ByVal This As ID2D1Factory7 Ptr,  ByRef effect_id As GUID ) As HRESULT
    	' 26. GetRegisteredEffects
    GetRegisteredEffects As Function(ByVal This As ID2D1Factory7 Ptr,  ByVal effects As GUID Ptr, ByVal effect_count As ULong, ByVal returned As ULong Ptr, ByVal registered As ULong Ptr ) As HRESULT
    	' 27. GetEffectProperties
    GetEffectProperties As Function(ByVal This As ID2D1Factory7 Ptr,  ByRef effect_id As GUID, ByVal props As Any Ptr Ptr ) As HRESULT
        ' Erbt von ID2D1Factory1 (1-20 Methoden)
        ' 21. CreateDevice
    CreateDevice1 As Function(ByVal This As ID2D1Factory7 Ptr,  ByVal dxgi_device As Any Ptr, ByVal device As Any Ptr Ptr ) As HRESULT
    CreateDevice2 As Function(ByVal This As ID2D1Factory7 Ptr,  ByVal dxgi_device As Any Ptr, ByVal d2d_device As Any Ptr Ptr ) As HRESULT
    CreateDevice3 As Function(ByVal This As ID2D1Factory7 Ptr,  ByVal dxgi_device As Any Ptr, ByVal d2d_device As Any Ptr Ptr ) As HRESULT
    CreateDevice4 As Function(ByVal This As ID2D1Factory7 Ptr,  ByVal dxgi_device As Any Ptr, ByVal d2d_device As Any Ptr Ptr ) As HRESULT
    CreateDevice5 As Function(ByVal This As ID2D1Factory7 Ptr,  ByVal dxgi_device As Any Ptr, ByVal d2d_device As Any Ptr Ptr ) As HRESULT

    CreateDevice6 As Function(ByVal This As ID2D1Factory7 Ptr,  ByVal dxgi_device As Any Ptr, ByVal d2d_device As Any Ptr Ptr ) As HRESULT
End Type
#define ID2D1Factory7_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Factory7_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Factory7_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Factory7_ReloadSystemMetrics(p, a) (p)->lpVtbl->ReloadSystemMetrics(p, a)
#define ID2D1Factory7_GetDesktopDpi(p, a, b) (p)->lpVtbl->GetDesktopDpi(p, a, b)
#define ID2D1Factory7_CreateRectangleGeometry(p, a, b) (p)->lpVtbl->CreateRectangleGeometry(p, a, b)
#define ID2D1Factory7_CreateRoundedRectangleGeometry(p, a, b) (p)->lpVtbl->CreateRoundedRectangleGeometry(p, a, b)
#define ID2D1Factory7_CreateEllipseGeometry(p, a, b) (p)->lpVtbl->CreateEllipseGeometry(p, a, b)
#define ID2D1Factory7_CreateGeometryGroup(p, a, b, c, d) (p)->lpVtbl->CreateGeometryGroup(p, a, b, c, d)
#define ID2D1Factory7_CreateTransformedGeometry(p, a, b, c) (p)->lpVtbl->CreateTransformedGeometry(p, a, b, c)
#define ID2D1Factory7_CreatePathGeometry(p, a) (p)->lpVtbl->CreatePathGeometry(p, a)
#define ID2D1Factory7_CreateStrokeStyle(p, a, b, c, d) (p)->lpVtbl->CreateStrokeStyle(p, a, b, c, d)
#define ID2D1Factory7_CreateDrawingStateBlock(p, a, b, c) (p)->lpVtbl->CreateDrawingStateBlock(p, a, b, c)
#define ID2D1Factory7_CreateWicBitmapRenderTarget(p, a, b, c) (p)->lpVtbl->CreateWicBitmapRenderTarget(p, a, b, c)
#define ID2D1Factory7_CreateHwndRenderTarget(p, a, b, c) (p)->lpVtbl->CreateHwndRenderTarget(p, a, b, c)
#define ID2D1Factory7_CreateDxgiSurfaceRenderTarget(p, a, b, c) (p)->lpVtbl->CreateDxgiSurfaceRenderTarget(p, a, b, c)
#define ID2D1Factory7_CreateDCRenderTarget(p, a, b) (p)->lpVtbl->CreateDCRenderTarget(p, a, b)
#define ID2D1Factory7_CreateDevice(p, a, b) (p)->lpVtbl->CreateDevice(p, a, b)
#define ID2D1Factory7_CreateStrokeStyle1(p, a, b, c, d) (p)->lpVtbl->CreateStrokeStyle1(p, a, b, c, d)
#define ID2D1Factory7_CreatePathGeometry1(p, a) (p)->lpVtbl->CreatePathGeometry1(p, a)
#define ID2D1Factory7_CreateDrawingStateBlock1(p, a, b, c) (p)->lpVtbl->CreateDrawingStateBlock1(p, a, b, c)
#define ID2D1Factory7_CreateGdiMetafile(p, a, b) (p)->lpVtbl->CreateGdiMetafile(p, a, b)
#define ID2D1Factory7_RegisterEffectFromStream(p, a, b, c, d, e) (p)->lpVtbl->RegisterEffectFromStream(p, a, b, c, d, e)
#define ID2D1Factory7_RegisterEffectFromString(p, a, b, c, d, e) (p)->lpVtbl->RegisterEffectFromString(p, a, b, c, d, e)
#define ID2D1Factory7_UnregisterEffect(p, a) (p)->lpVtbl->UnregisterEffect(p, a)
#define ID2D1Factory7_GetRegisteredEffects(p, a, b, c, d) (p)->lpVtbl->GetRegisteredEffects(p, a, b, c, d)
#define ID2D1Factory7_GetEffectProperties(p, a, b) (p)->lpVtbl->GetEffectProperties(p, a, b)
#define ID2D1Factory7_CreateDevice1(p, a, b) (p)->lpVtbl->CreateDevice1(p, a, b)
#define ID2D1Factory7_CreateDevice2(p, a, b) (p)->lpVtbl->CreateDevice2(p, a, b)
#define ID2D1Factory7_CreateDevice3(p, a, b) (p)->lpVtbl->CreateDevice3(p, a, b)
#define ID2D1Factory7_CreateDevice4(p, a, b) (p)->lpVtbl->CreateDevice4(p, a, b)
#define ID2D1Factory7_CreateDevice5(p, a, b) (p)->lpVtbl->CreateDevice5(p, a, b)
#define ID2D1Factory7_CreateDevice6(p, a, b) (p)->lpVtbl->CreateDevice5(p, a, b)

Type ID2D1Factory8Vtbl As ID2D1Factory8Vtbl_
Type ID2D1Factory8
    lpVtbl As ID2D1Factory8Vtbl Ptr
End Type
Type ID2D1Factory8Vtbl_     '' Extends ID2D1Factory7Vtbl_
    QueryInterface As Function(ByVal This As ID2D1Factory8 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Factory8 Ptr) As ULong
    Release As Function(ByVal This As ID2D1Factory8 Ptr) As ULong
        ' 2. AddRef
        ' 4.
    ReloadSystemMetrics As Function(ByVal This As ID2D1Factory8 Ptr) As HRESULT
    GetDesktopDpi As Sub(ByVal This As ID2D1Factory8 Ptr, ByVal dpiX As Single Ptr, ByVal dpiY As Single Ptr)
    CreateRectangleGeometry As Function(ByVal This As ID2D1Factory8 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal geometry As ID2D1RectangleGeometry Ptr Ptr) As HRESULT
    CreateRoundedRectangleGeometry As Function(ByVal This As ID2D1Factory8 Ptr, ByVal rect As D2D1_ROUNDED_RECT Ptr, ByVal geometry As ID2D1RoundedRectangleGeometry Ptr Ptr) As HRESULT
    CreateEllipseGeometry As Function(ByVal This As ID2D1Factory8 Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal ID2D1EllipseGeometry As Any Ptr Ptr) As HRESULT
    CreateGeometryGroup As Function(ByVal This As ID2D1Factory8 Ptr, ByVal fill_mode As D2D1_FILL_MODE, ByVal geometries As ID2D1Geometry Ptr Ptr, ByVal geometryCount As ULong, ByVal group As ID2D1GeometryGroup Ptr Ptr) As HRESULT
    CreateTransformedGeometry As Function(ByVal This As ID2D1Factory8 Ptr, ByVal src_geometry As ID2D1Geometry Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr, ByVal transformedGeometry As ID2D1TransformedGeometry Ptr Ptr) As HRESULT
    CreatePathGeometry As Function(ByVal This As ID2D1Factory8 Ptr, ByVal geometry As ID2D1PathGeometry Ptr Ptr) As HRESULT
    CreateStrokeStyle As Function(ByVal This As ID2D1Factory8 Ptr, ByVal styleProps As D2D1_STROKE_STYLE_PROPERTIES Ptr, ByVal dashes As Single Ptr, ByVal dashCount As ULong, ByVal strokeStyle As ID2D1StrokeStyle Ptr Ptr) As HRESULT
    CreateDrawingStateBlock As Function(ByVal This As ID2D1Factory8 Ptr, ByVal stateDesc As D2D1_DRAWING_STATE_DESCRIPTION Ptr, ByVal text_renderingParams As Any Ptr, ByVal stateBlock As IUnknownBase Ptr Ptr) As HRESULT ' ID2D1DrawingStateBlock
    CreateWicBitmapRenderTarget As Function(ByVal This As ID2D1Factory8 Ptr, ByVal target As Any Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1RenderTarget Ptr Ptr) As HRESULT
    CreateHwndRenderTarget As Function(ByVal This As ID2D1Factory8 Ptr, ByVal desc As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal targetProps As D2D1_HWND_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1HwndRenderTarget Ptr Ptr) As HRESULT
    CreateDxgiSurfaceRenderTarget As Function(ByVal This As ID2D1Factory8 Ptr, ByVal surface As Any Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1RenderTarget Ptr Ptr) As HRESULT
    CreateDCRenderTarget As Function(ByVal This As ID2D1Factory8 Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1DCRenderTarget Ptr Ptr) As HRESULT
    	' Erbt von ID2D1Factory (1-17 Methoden)
    	' 18. CreateDevice
    CreateDevice As Function(ByVal This As ID2D1Factory8 Ptr,  ByVal dxgi_device As Any Ptr, ByVal device As ID2D1Device Ptr Ptr ) As HRESULT
    	' 19. CreateStrokeStyle (überladen)
    CreateStrokeStyle1 As Function(ByVal This As ID2D1Factory8 Ptr,  ByVal desc As D2D1_STROKE_STYLE_PROPERTIES1 Ptr, ByVal dashes As Single Ptr, ByVal dash_count As ULong, ByVal stroke_style As Any Ptr Ptr ) As HRESULT
    	' 20. CreatePathGeometry (überladen)
    CreatePathGeometry1 As Function(ByVal This As ID2D1Factory8 Ptr,  ByVal geometry As Any Ptr Ptr ) As HRESULT
    	' 21. CreateDrawingStateBlock (überladen)
    CreateDrawingStateBlock1 As Function(ByVal This As ID2D1Factory8 Ptr,  ByVal desc As D2D1_DRAWING_STATE_DESCRIPTION1 Ptr, ByVal text_rendering_params As Any Ptr, ByVal state_block As Any Ptr Ptr ) As HRESULT
    	' 22. CreateGdiMetafile
    CreateGdiMetafile As Function(ByVal This As ID2D1Factory8 Ptr,  ByVal stream As Any Ptr, ByVal metafile As Any Ptr Ptr ) As HRESULT
    	' 23. RegisterEffectFromStream
    RegisterEffectFromStream As Function(ByVal This As ID2D1Factory8 Ptr,  ByRef effect_id As GUID, ByVal property_xml As Any Ptr, ByVal bindings As Any Ptr, ByVal binding_count As ULong, ByVal effect_factory As PD2D1_EFFECT_FACTORY Ptr ) As HRESULT
    	' 24. RegisterEffectFromString
    RegisterEffectFromString As Function(ByVal This As ID2D1Factory8 Ptr,  ByVal effect_id As GUID, ByVal property_xml As WString Ptr, ByVal bindings As Any Ptr, ByVal binding_count As ULong, ByVal effect_factory As PD2D1_EFFECT_FACTORY Ptr ) As HRESULT
    	' 25. UnregisterEffect
    UnregisterEffect As Function(ByVal This As ID2D1Factory8 Ptr,  ByRef effect_id As GUID ) As HRESULT
    	' 26. GetRegisteredEffects
    GetRegisteredEffects As Function(ByVal This As ID2D1Factory8 Ptr,  ByVal effects As GUID Ptr, ByVal effect_count As ULong, ByVal returned As ULong Ptr, ByVal registered As ULong Ptr ) As HRESULT
    	' 27. GetEffectProperties
    GetEffectProperties As Function(ByVal This As ID2D1Factory8 Ptr,  ByRef effect_id As GUID, ByVal props As Any Ptr Ptr ) As HRESULT
        ' Erbt von ID2D1Factory1 (1-20 Methoden)
        ' 21. CreateDevice
    CreateDevice1 As Function(ByVal This As ID2D1Factory8 Ptr,  ByVal dxgi_device As Any Ptr, ByVal device As Any Ptr Ptr ) As HRESULT
    CreateDevice2 As Function(ByVal This As ID2D1Factory8 Ptr,  ByVal dxgi_device As Any Ptr, ByVal d2d_device As Any Ptr Ptr ) As HRESULT
    CreateDevice3 As Function(ByVal This As ID2D1Factory8 Ptr,  ByVal dxgi_device As Any Ptr, ByVal d2d_device As Any Ptr Ptr ) As HRESULT
    CreateDevice4 As Function(ByVal This As ID2D1Factory8 Ptr,  ByVal dxgi_device As Any Ptr, ByVal d2d_device As Any Ptr Ptr ) As HRESULT
    CreateDevice5 As Function(ByVal This As ID2D1Factory8 Ptr,  ByVal dxgi_device As Any Ptr, ByVal d2d_device As Any Ptr Ptr ) As HRESULT
    CreateDevice6 As Function(ByVal This As ID2D1Factory8 Ptr,  ByVal dxgi_device As Any Ptr, ByVal d2d_device As Any Ptr Ptr ) As HRESULT

    CreateDevice7 As Function(ByVal This As ID2D1Factory8 Ptr,  ByVal dxgi_device As Any Ptr, ByVal d2d_device As Any Ptr Ptr ) As HRESULT
End Type
#define ID2D1Factory8_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Factory8_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Factory8_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Factory8_ReloadSystemMetrics(p, a) (p)->lpVtbl->ReloadSystemMetrics(p, a)
#define ID2D1Factory8_GetDesktopDpi(p, a, b) (p)->lpVtbl->GetDesktopDpi(p, a, b)
#define ID2D1Factory8_CreateRectangleGeometry(p, a, b) (p)->lpVtbl->CreateRectangleGeometry(p, a, b)
#define ID2D1Factory8_CreateRoundedRectangleGeometry(p, a, b) (p)->lpVtbl->CreateRoundedRectangleGeometry(p, a, b)
#define ID2D1Factory8_CreateEllipseGeometry(p, a, b) (p)->lpVtbl->CreateEllipseGeometry(p, a, b)
#define ID2D1Factory8_CreateGeometryGroup(p, a, b, c, d) (p)->lpVtbl->CreateGeometryGroup(p, a, b, c, d)
#define ID2D1Factory8_CreateTransformedGeometry(p, a, b, c) (p)->lpVtbl->CreateTransformedGeometry(p, a, b, c)
#define ID2D1Factory8_CreatePathGeometry(p, a) (p)->lpVtbl->CreatePathGeometry(p, a)
#define ID2D1Factory8_CreateStrokeStyle(p, a, b, c, d) (p)->lpVtbl->CreateStrokeStyle(p, a, b, c, d)
#define ID2D1Factory8_CreateDrawingStateBlock(p, a, b, c) (p)->lpVtbl->CreateDrawingStateBlock(p, a, b, c)
#define ID2D1Factory8_CreateWicBitmapRenderTarget(p, a, b, c) (p)->lpVtbl->CreateWicBitmapRenderTarget(p, a, b, c)
#define ID2D1Factory8_CreateHwndRenderTarget(p, a, b, c) (p)->lpVtbl->CreateHwndRenderTarget(p, a, b, c)
#define ID2D1Factory8_CreateDxgiSurfaceRenderTarget(p, a, b, c) (p)->lpVtbl->CreateDxgiSurfaceRenderTarget(p, a, b, c)
#define ID2D1Factory8_CreateDCRenderTarget(p, a, b) (p)->lpVtbl->CreateDCRenderTarget(p, a, b)
#define ID2D1Factory8_CreateDevice(p, a, b) (p)->lpVtbl->CreateDevice(p, a, b)
#define ID2D1Factory8_CreateStrokeStyle1(p, a, b, c, d) (p)->lpVtbl->CreateStrokeStyle1(p, a, b, c, d)
#define ID2D1Factory8_CreatePathGeometry1(p, a) (p)->lpVtbl->CreatePathGeometry1(p, a)
#define ID2D1Factory8_CreateDrawingStateBlock1(p, a, b, c) (p)->lpVtbl->CreateDrawingStateBlock1(p, a, b, c)
#define ID2D1Factory8_CreateGdiMetafile(p, a, b) (p)->lpVtbl->CreateGdiMetafile(p, a, b)
#define ID2D1Factory8_RegisterEffectFromStream(p, a, b, c, d, e) (p)->lpVtbl->RegisterEffectFromStream(p, a, b, c, d, e)
#define ID2D1Factory8_RegisterEffectFromString(p, a, b, c, d, e) (p)->lpVtbl->RegisterEffectFromString(p, a, b, c, d, e)
#define ID2D1Factory8_UnregisterEffect(p, a) (p)->lpVtbl->UnregisterEffect(p, a)
#define ID2D1Factory8_GetRegisteredEffects(p, a, b, c, d) (p)->lpVtbl->GetRegisteredEffects(p, a, b, c, d)
#define ID2D1Factory8_GetEffectProperties(p, a, b) (p)->lpVtbl->GetEffectProperties(p, a, b)
#define ID2D1Factory8_CreateDevice1(p, a, b) (p)->lpVtbl->CreateDevice1(p, a, b)
#define ID2D1Factory8_CreateDevice2(p, a, b) (p)->lpVtbl->CreateDevice2(p, a, b)
#define ID2D1Factory8_CreateDevice3(p, a, b) (p)->lpVtbl->CreateDevice3(p, a, b)
#define ID2D1Factory8_CreateDevice4(p, a, b) (p)->lpVtbl->CreateDevice4(p, a, b)
#define ID2D1Factory8_CreateDevice5(p, a, b) (p)->lpVtbl->CreateDevice5(p, a, b)
#define ID2D1Factory8_CreateDevice6(p, a, b) (p)->lpVtbl->CreateDevice5(p, a, b)
#define ID2D1Factory8_CreateDevice7(p, a, b) (p)->lpVtbl->CreateDevice5(p, a, b)

' ============================================================================
' Command Sink Interfaces
' ============================================================================
Type ID2D1CommandSink2Vtbl As ID2D1CommandSink2Vtbl_
Type ID2D1CommandSink2
    lpVtbl As ID2D1CommandSink2Vtbl Ptr
End Type
Type ID2D1CommandSink2Vtbl_     '' Extends ID2D1CommandSink1Vtbl_
    QueryInterface As Function(ByVal This As ID2D1CommandSink2 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1CommandSink2 Ptr) As ULong
    Release As Function(ByVal This As ID2D1CommandSink2 Ptr) As ULong
        
    BeginDraw As Function(ByVal This As ID2D1CommandSink2 Ptr) As HRESULT
        ' 5. EndDraw
    EndDraw As Function(ByVal This As ID2D1CommandSink2 Ptr) As HRESULT
        ' 6. SetAntialiasMode
    SetAntialiasMode As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal antialias_mode As D2D1_ANTIALIAS_MODE ) As HRESULT
        ' 7. SetTags
    SetTags As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal tag1 As D2D1_TAG, ByVal tag2 As D2D1_TAG ) As HRESULT
        ' 8. SetTextAntialiasMode
    SetTextAntialiasMode As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal antialias_mode As D2D1_TEXT_ANTIALIAS_MODE ) As HRESULT
        ' 9. SetTextRenderingParams
    SetTextRenderingParams As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal text_rendering_params As Any Ptr ) As HRESULT
        ' 10. SetTransform
    SetTransform As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal transform As D2D1_MATRIX_3X2_F Ptr ) As HRESULT
        ' 11. SetPrimitiveBlend
    SetPrimitiveBlend As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal primitive_blend As D2D1_PRIMITIVE_BLEND ) As HRESULT
        ' 12. SetUnitMode
    SetUnitMode As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal unit_mode As D2D1_UNIT_MODE ) As HRESULT
        ' 13. Clear
    Clear As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal color As D2D1_COLOR_F Ptr ) As HRESULT
        ' 14. DrawGlyphRun
    DrawGlyphRun As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal glyph_run_desc As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuring_mode As ULong ) As HRESULT
        ' 15. DrawLine
    DrawLine As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal p0 As D2D1_POINT_2F, ByVal p1 As D2D1_POINT_2F, ByVal brush As ID2D1Brush Ptr, ByVal stroke_width As Single, ByVal stroke_style As ID2D1StrokeStyle Ptr ) As HRESULT
        ' 16. DrawGeometry
    DrawGeometry As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal stroke_width As Single, ByVal stroke_style As ID2D1StrokeStyle Ptr ) As HRESULT
        ' 17. DrawRectangle
    DrawRectangle As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal stroke_width As Single, ByVal stroke_style As ID2D1StrokeStyle Ptr ) As HRESULT
        ' 18. DrawBitmap
    DrawBitmap As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE, ByVal src_rect As D2D1_RECT_F Ptr, ByVal perspective_transform As D2D1_MATRIX_4X4_F Ptr ) As HRESULT
        ' 19. DrawImage
    DrawImage As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal image As ID2D1Image Ptr, ByVal target_offset As D2D1_POINT_2F Ptr, ByVal image_rect As D2D1_RECT_F Ptr, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE, ByVal composite_mode As D2D1_COMPOSITE_MODE ) As HRESULT
        ' 20. DrawGdiMetafile
    DrawGdiMetafile As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal metafile As ID2D1GdiMetafile Ptr, ByVal target_offset As D2D1_POINT_2F Ptr ) As HRESULT
        ' 21. FillMesh
    FillMesh As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal mesh As ID2D1Mesh Ptr, ByVal brush As ID2D1Brush Ptr ) As HRESULT
        ' 22. FillOpacityMask
    FillOpacityMask As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal src_rect As D2D1_RECT_F Ptr ) As HRESULT
        ' 23. FillGeometry
    FillGeometry As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal opacity_brush As ID2D1Brush Ptr ) As HRESULT
        ' 24. FillRectangle
    FillRectangle As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr ) As HRESULT
        ' 25. PushAxisAlignedClip
    PushAxisAlignedClip As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal clip_rect As D2D1_RECT_F Ptr, ByVal antialias_mode As D2D1_ANTIALIAS_MODE ) As HRESULT
        ' 26. PushLayer
    PushLayer As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal layer_parameters As D2D1_LAYER_PARAMETERS1 Ptr, ByVal layer As ID2D1Layer Ptr ) As HRESULT
        ' 27. PopAxisAlignedClip
    PopAxisAlignedClip As Function(ByVal This As ID2D1CommandSink2 Ptr) As HRESULT
        ' 28. PopLayer
    PopLayer As Function(ByVal This As ID2D1CommandSink2 Ptr) As HRESULT
        ' Erbt von ID2D1CommandSink
        ' Zusätzliche Methode
    SetPrimitiveBlend1 As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal primitive_blend As D2D1_PRIMITIVE_BLEND ) As HRESULT

    DrawInk As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal ink As ID2D1Ink Ptr, ByVal brush As ID2D1Brush Ptr, ByVal ink_style As ID2D1InkStyle Ptr ) As HRESULT
    DrawGradientMesh As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal gradient_mesh As ID2D1GradientMesh Ptr ) As HRESULT
    DrawGdiMetafile1 As Function(ByVal This As ID2D1CommandSink2 Ptr,  ByVal gdi_metafile As Any Ptr, ByVal dest_rect As D2D1_RECT_F Ptr, ByVal src_rect As D2D1_RECT_F Ptr ) As HRESULT
End Type
#define ID2D1CommandSink2_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1CommandSink2_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1CommandSink2_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1CommandSink2_BeginDraw(p, a) (p)->lpVtbl->BeginDraw(p, a)
#define ID2D1CommandSink2_EndDraw(p, a) (p)->lpVtbl->EndDraw(p, a)
#define ID2D1CommandSink2_SetAntialiasMode(p, a) (p)->lpVtbl->SetAntialiasMode(p, a)
#define ID2D1CommandSink2_SetTags(p, a, b) (p)->lpVtbl->SetTags(p, a, b)
#define ID2D1CommandSink2_SetTextAntialiasMode(p, a) (p)->lpVtbl->SetTextAntialiasMode(p, a)
#define ID2D1CommandSink2_SetTextRenderingParams(p, a) (p)->lpVtbl->SetTextRenderingParams(p, a)
#define ID2D1CommandSink2_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1CommandSink2_SetPrimitiveBlend(p, a) (p)->lpVtbl->SetPrimitiveBlend(p, a)
#define ID2D1CommandSink2_SetUnitMode(p, a) (p)->lpVtbl->SetUnitMode(p, a)
#define ID2D1CommandSink2_Clear(p, a) (p)->lpVtbl->Clear(p, a)
#define ID2D1CommandSink2_DrawGlyphRun(p, a, b, c, d, e) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d, e)
#define ID2D1CommandSink2_DrawLine(p, a, b, c, d, e) (p)->lpVtbl->DrawLine(p, a, b, c, d, e)
#define ID2D1CommandSink2_DrawGeometry(p, a, b, c, d) (p)->lpVtbl->DrawGeometry(p, a, b, c, d)
#define ID2D1CommandSink2_DrawRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRectangle(p, a, b, c, d)
#define ID2D1CommandSink2_DrawBitmap(p, a, b, c, d, e, f) (p)->lpVtbl->DrawBitmap(p, a, b, c, d, e, f)
#define ID2D1CommandSink2_DrawImage(p, a, b, c, d, e) (p)->lpVtbl->DrawImage(p, a, b, c, d, e)
#define ID2D1CommandSink2_DrawGdiMetafile(p, a, b) (p)->lpVtbl->DrawGdiMetafile(p, a, b)
#define ID2D1CommandSink2_FillMesh(p, a, b) (p)->lpVtbl->FillMesh(p, a, b)
#define ID2D1CommandSink2_FillOpacityMask(p, a, b, c, d) (p)->lpVtbl->FillOpacityMask(p, a, b, c, d)
#define ID2D1CommandSink2_FillGeometry(p, a, b, c) (p)->lpVtbl->FillGeometry(p, a, b, c)
#define ID2D1CommandSink2_FillRectangle(p, a, b) (p)->lpVtbl->FillRectangle(p, a, b)
#define ID2D1CommandSink2_PushAxisAlignedClip(p, a, b) (p)->lpVtbl->PushAxisAlignedClip(p, a, b)
#define ID2D1CommandSink2_PushLayer(p, a, b) (p)->lpVtbl->PushLayer(p, a, b)
#define ID2D1CommandSink2_PopAxisAlignedClip(p, a) (p)->lpVtbl->PopAxisAlignedClip(p, a)
#define ID2D1CommandSink2_PopLayer(p, a) (p)->lpVtbl->PopLayer(p, a)
#define ID2D1CommandSink2_SetPrimitiveBlend1(p, a) (p)->lpVtbl->SetPrimitiveBlend1(p, a)
#define ID2D1CommandSink2_DrawInk(p, a, b, c) (p)->lpVtbl->DrawInk(p, a, b, c)
#define ID2D1CommandSink2_DrawGradientMesh(p, a) (p)->lpVtbl->DrawGradientMesh(p, a)
#define ID2D1CommandSink2_DrawGdiMetafile1(p, a, b, c) (p)->lpVtbl->DrawGdiMetafile1(p, a, b, c)

Type ID2D1CommandSink3Vtbl As ID2D1CommandSink3Vtbl_
Type ID2D1CommandSink3
    lpVtbl As ID2D1CommandSink3Vtbl Ptr
End Type
Type ID2D1CommandSink3Vtbl_     '' Extends ID2D1CommandSink2Vtbl_
    QueryInterface As Function(ByVal This As ID2D1CommandSink3 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1CommandSink3 Ptr) As ULong
    Release As Function(ByVal This As ID2D1CommandSink3 Ptr) As ULong
        
    BeginDraw As Function(ByVal This As ID2D1CommandSink3 Ptr) As HRESULT
        ' 5. EndDraw
    EndDraw As Function(ByVal This As ID2D1CommandSink3 Ptr) As HRESULT
        ' 6. SetAntialiasMode
    SetAntialiasMode As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal antialias_mode As D2D1_ANTIALIAS_MODE ) As HRESULT
        ' 7. SetTags
    SetTags As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal tag1 As D2D1_TAG, ByVal tag2 As D2D1_TAG ) As HRESULT
        ' 8. SetTextAntialiasMode
    SetTextAntialiasMode As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal antialias_mode As D2D1_TEXT_ANTIALIAS_MODE ) As HRESULT
        ' 9. SetTextRenderingParams
    SetTextRenderingParams As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal text_rendering_params As Any Ptr ) As HRESULT
        ' 10. SetTransform
    SetTransform As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal transform As D2D1_MATRIX_3X2_F Ptr ) As HRESULT
        ' 11. SetPrimitiveBlend
    SetPrimitiveBlend As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal primitive_blend As D2D1_PRIMITIVE_BLEND ) As HRESULT
        ' 12. SetUnitMode
    SetUnitMode As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal unit_mode As D2D1_UNIT_MODE ) As HRESULT
        ' 13. Clear
    Clear As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal color As D2D1_COLOR_F Ptr ) As HRESULT
        ' 14. DrawGlyphRun
    DrawGlyphRun As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal glyph_run_desc As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuring_mode As ULong ) As HRESULT
        ' 15. DrawLine
    DrawLine As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal p0 As D2D1_POINT_2F, ByVal p1 As D2D1_POINT_2F, ByVal brush As ID2D1Brush Ptr, ByVal stroke_width As Single, ByVal stroke_style As ID2D1StrokeStyle Ptr ) As HRESULT
        ' 16. DrawGeometry
    DrawGeometry As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal stroke_width As Single, ByVal stroke_style As ID2D1StrokeStyle Ptr ) As HRESULT
        ' 17. DrawRectangle
    DrawRectangle As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal stroke_width As Single, ByVal stroke_style As ID2D1StrokeStyle Ptr ) As HRESULT
        ' 18. DrawBitmap
    DrawBitmap As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE, ByVal src_rect As D2D1_RECT_F Ptr, ByVal perspective_transform As D2D1_MATRIX_4X4_F Ptr ) As HRESULT
        ' 19. DrawImage
    DrawImage As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal image As ID2D1Image Ptr, ByVal target_offset As D2D1_POINT_2F Ptr, ByVal image_rect As D2D1_RECT_F Ptr, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE, ByVal composite_mode As D2D1_COMPOSITE_MODE ) As HRESULT
        ' 20. DrawGdiMetafile
    DrawGdiMetafile As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal metafile As ID2D1GdiMetafile Ptr, ByVal target_offset As D2D1_POINT_2F Ptr ) As HRESULT
        ' 21. FillMesh
    FillMesh As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal mesh As ID2D1Mesh Ptr, ByVal brush As ID2D1Brush Ptr ) As HRESULT
        ' 22. FillOpacityMask
    FillOpacityMask As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal src_rect As D2D1_RECT_F Ptr ) As HRESULT
        ' 23. FillGeometry
    FillGeometry As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal opacity_brush As ID2D1Brush Ptr ) As HRESULT
        ' 24. FillRectangle
    FillRectangle As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr ) As HRESULT
        ' 25. PushAxisAlignedClip
    PushAxisAlignedClip As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal clip_rect As D2D1_RECT_F Ptr, ByVal antialias_mode As D2D1_ANTIALIAS_MODE ) As HRESULT
        ' 26. PushLayer
    PushLayer As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal layer_parameters As D2D1_LAYER_PARAMETERS1 Ptr, ByVal layer As ID2D1Layer Ptr ) As HRESULT
        ' 27. PopAxisAlignedClip
    PopAxisAlignedClip As Function(ByVal This As ID2D1CommandSink3 Ptr) As HRESULT
        ' 28. PopLayer
    PopLayer As Function(ByVal This As ID2D1CommandSink3 Ptr) As HRESULT
        ' Erbt von ID2D1CommandSink
        ' Zusätzliche Methode
    SetPrimitiveBlend1 As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal primitive_blend As D2D1_PRIMITIVE_BLEND ) As HRESULT
    DrawInk As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal ink As ID2D1Ink Ptr, ByVal brush As ID2D1Brush Ptr, ByVal ink_style As ID2D1InkStyle Ptr ) As HRESULT
    DrawGradientMesh As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal gradient_mesh As ID2D1GradientMesh Ptr ) As HRESULT
    DrawGdiMetafile1 As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal gdi_metafile As Any Ptr, ByVal dest_rect As D2D1_RECT_F Ptr, ByVal src_rect As D2D1_RECT_F Ptr ) As HRESULT

    DrawSpriteBatch As Function(ByVal This As ID2D1CommandSink3 Ptr,  ByVal sprite_batch As ID2D1SpriteBatch Ptr, ByVal start_index As ULong, ByVal sprite_count As ULong, ByVal bitmap As ID2D1Bitmap Ptr, ByVal interpolation_mode As D2D1_BITMAP_INTERPOLATION_MODE, ByVal sprite_options As D2D1_SPRITE_OPTIONS ) As HRESULT
End Type
#define ID2D1CommandSink3_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1CommandSink3_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1CommandSink3_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1CommandSink3_BeginDraw(p, a) (p)->lpVtbl->BeginDraw(p, a)
#define ID2D1CommandSink3_EndDraw(p, a) (p)->lpVtbl->EndDraw(p, a)
#define ID2D1CommandSink3_SetAntialiasMode(p, a) (p)->lpVtbl->SetAntialiasMode(p, a)
#define ID2D1CommandSink3_SetTags(p, a, b) (p)->lpVtbl->SetTags(p, a, b)
#define ID2D1CommandSink3_SetTextAntialiasMode(p, a) (p)->lpVtbl->SetTextAntialiasMode(p, a)
#define ID2D1CommandSink3_SetTextRenderingParams(p, a) (p)->lpVtbl->SetTextRenderingParams(p, a)
#define ID2D1CommandSink3_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1CommandSink3_SetPrimitiveBlend(p, a) (p)->lpVtbl->SetPrimitiveBlend(p, a)
#define ID2D1CommandSink3_SetUnitMode(p, a) (p)->lpVtbl->SetUnitMode(p, a)
#define ID2D1CommandSink3_Clear(p, a) (p)->lpVtbl->Clear(p, a)
#define ID2D1CommandSink3_DrawGlyphRun(p, a, b, c, d, e) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d, e)
#define ID2D1CommandSink3_DrawLine(p, a, b, c, d, e) (p)->lpVtbl->DrawLine(p, a, b, c, d, e)
#define ID2D1CommandSink3_DrawGeometry(p, a, b, c, d) (p)->lpVtbl->DrawGeometry(p, a, b, c, d)
#define ID2D1CommandSink3_DrawRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRectangle(p, a, b, c, d)
#define ID2D1CommandSink3_DrawBitmap(p, a, b, c, d, e, f) (p)->lpVtbl->DrawBitmap(p, a, b, c, d, e, f)
#define ID2D1CommandSink3_DrawImage(p, a, b, c, d, e) (p)->lpVtbl->DrawImage(p, a, b, c, d, e)
#define ID2D1CommandSink3_DrawGdiMetafile(p, a, b) (p)->lpVtbl->DrawGdiMetafile(p, a, b)
#define ID2D1CommandSink3_FillMesh(p, a, b) (p)->lpVtbl->FillMesh(p, a, b)
#define ID2D1CommandSink3_FillOpacityMask(p, a, b, c, d) (p)->lpVtbl->FillOpacityMask(p, a, b, c, d)
#define ID2D1CommandSink3_FillGeometry(p, a, b, c) (p)->lpVtbl->FillGeometry(p, a, b, c)
#define ID2D1CommandSink3_FillRectangle(p, a, b) (p)->lpVtbl->FillRectangle(p, a, b)
#define ID2D1CommandSink3_PushAxisAlignedClip(p, a, b) (p)->lpVtbl->PushAxisAlignedClip(p, a, b)
#define ID2D1CommandSink3_PushLayer(p, a, b) (p)->lpVtbl->PushLayer(p, a, b)
#define ID2D1CommandSink3_PopAxisAlignedClip(p, a) (p)->lpVtbl->PopAxisAlignedClip(p, a)
#define ID2D1CommandSink3_PopLayer(p, a) (p)->lpVtbl->PopLayer(p, a)
#define ID2D1CommandSink3_SetPrimitiveBlend1(p, a) (p)->lpVtbl->SetPrimitiveBlend1(p, a)
#define ID2D1CommandSink3_DrawInk(p, a, b, c) (p)->lpVtbl->DrawInk(p, a, b, c)
#define ID2D1CommandSink3_DrawGradientMesh(p, a) (p)->lpVtbl->DrawGradientMesh(p, a)
#define ID2D1CommandSink3_DrawGdiMetafile1(p, a, b, c) (p)->lpVtbl->DrawGdiMetafile1(p, a, b, c)
#define ID2D1CommandSink3_DrawSpriteBatch(p, a, b, c, d, e, f) (p)->lpVtbl->DrawSpriteBatch(p, a, b, c, d, e, f)

Type ID2D1CommandSink4Vtbl As ID2D1CommandSink4Vtbl_
Type ID2D1CommandSink4
    lpVtbl As ID2D1CommandSink4Vtbl Ptr
End Type
Type ID2D1CommandSink4Vtbl_     '' Extends ID2D1CommandSink3Vtbl_
    QueryInterface As Function(ByVal This As ID2D1CommandSink4 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1CommandSink4 Ptr) As ULong
    Release As Function(ByVal This As ID2D1CommandSink4 Ptr) As ULong
        
    BeginDraw As Function(ByVal This As ID2D1CommandSink4 Ptr) As HRESULT
        ' 5. EndDraw
    EndDraw As Function(ByVal This As ID2D1CommandSink4 Ptr) As HRESULT
        ' 6. SetAntialiasMode
    SetAntialiasMode As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal antialias_mode As D2D1_ANTIALIAS_MODE ) As HRESULT
        ' 7. SetTags
    SetTags As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal tag1 As D2D1_TAG, ByVal tag2 As D2D1_TAG ) As HRESULT
        ' 8. SetTextAntialiasMode
    SetTextAntialiasMode As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal antialias_mode As D2D1_TEXT_ANTIALIAS_MODE ) As HRESULT
        ' 9. SetTextRenderingParams
    SetTextRenderingParams As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal text_rendering_params As Any Ptr ) As HRESULT
        ' 10. SetTransform
    SetTransform As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal transform As D2D1_MATRIX_3X2_F Ptr ) As HRESULT
        ' 11. SetPrimitiveBlend
    SetPrimitiveBlend As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal primitive_blend As D2D1_PRIMITIVE_BLEND ) As HRESULT
        ' 12. SetUnitMode
    SetUnitMode As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal unit_mode As D2D1_UNIT_MODE ) As HRESULT
        ' 13. Clear
    Clear As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal color As D2D1_COLOR_F Ptr ) As HRESULT
        ' 14. DrawGlyphRun
    DrawGlyphRun As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal glyph_run_desc As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuring_mode As ULong ) As HRESULT
        ' 15. DrawLine
    DrawLine As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal p0 As D2D1_POINT_2F, ByVal p1 As D2D1_POINT_2F, ByVal brush As ID2D1Brush Ptr, ByVal stroke_width As Single, ByVal stroke_style As ID2D1StrokeStyle Ptr ) As HRESULT
        ' 16. DrawGeometry
    DrawGeometry As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal stroke_width As Single, ByVal stroke_style As ID2D1StrokeStyle Ptr ) As HRESULT
        ' 17. DrawRectangle
    DrawRectangle As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal stroke_width As Single, ByVal stroke_style As ID2D1StrokeStyle Ptr ) As HRESULT
        ' 18. DrawBitmap
    DrawBitmap As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE, ByVal src_rect As D2D1_RECT_F Ptr, ByVal perspective_transform As D2D1_MATRIX_4X4_F Ptr ) As HRESULT
        ' 19. DrawImage
    DrawImage As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal image As ID2D1Image Ptr, ByVal target_offset As D2D1_POINT_2F Ptr, ByVal image_rect As D2D1_RECT_F Ptr, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE, ByVal composite_mode As D2D1_COMPOSITE_MODE ) As HRESULT
        ' 20. DrawGdiMetafile
    DrawGdiMetafile As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal metafile As ID2D1GdiMetafile Ptr, ByVal target_offset As D2D1_POINT_2F Ptr ) As HRESULT
        ' 21. FillMesh
    FillMesh As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal mesh As ID2D1Mesh Ptr, ByVal brush As ID2D1Brush Ptr ) As HRESULT
        ' 22. FillOpacityMask
    FillOpacityMask As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal src_rect As D2D1_RECT_F Ptr ) As HRESULT
        ' 23. FillGeometry
    FillGeometry As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal opacity_brush As ID2D1Brush Ptr ) As HRESULT
        ' 24. FillRectangle
    FillRectangle As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr ) As HRESULT
        ' 25. PushAxisAlignedClip
    PushAxisAlignedClip As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal clip_rect As D2D1_RECT_F Ptr, ByVal antialias_mode As D2D1_ANTIALIAS_MODE ) As HRESULT
        ' 26. PushLayer
    PushLayer As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal layer_parameters As D2D1_LAYER_PARAMETERS1 Ptr, ByVal layer As ID2D1Layer Ptr ) As HRESULT
        ' 27. PopAxisAlignedClip
    PopAxisAlignedClip As Function(ByVal This As ID2D1CommandSink4 Ptr) As HRESULT
        ' 28. PopLayer
    PopLayer As Function(ByVal This As ID2D1CommandSink4 Ptr) As HRESULT
        ' Erbt von ID2D1CommandSink
        ' Zusätzliche Methode
    SetPrimitiveBlend1 As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal primitive_blend As D2D1_PRIMITIVE_BLEND ) As HRESULT
    DrawInk As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal ink As ID2D1Ink Ptr, ByVal brush As ID2D1Brush Ptr, ByVal ink_style As ID2D1InkStyle Ptr ) As HRESULT
    DrawGradientMesh As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal gradient_mesh As ID2D1GradientMesh Ptr ) As HRESULT
    DrawGdiMetafile1 As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal gdi_metafile As Any Ptr, ByVal dest_rect As D2D1_RECT_F Ptr, ByVal src_rect As D2D1_RECT_F Ptr ) As HRESULT
    DrawSpriteBatch As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal sprite_batch As ID2D1SpriteBatch Ptr, ByVal start_index As ULong, ByVal sprite_count As ULong, ByVal bitmap As ID2D1Bitmap Ptr, ByVal interpolation_mode As D2D1_BITMAP_INTERPOLATION_MODE, ByVal sprite_options As D2D1_SPRITE_OPTIONS ) As HRESULT

    SetPrimitiveBlend2 As Function(ByVal This As ID2D1CommandSink4 Ptr,  ByVal primitive_blend As D2D1_PRIMITIVE_BLEND ) As HRESULT
End Type
#define ID2D1CommandSink4_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1CommandSink4_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1CommandSink4_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1CommandSink4_BeginDraw(p, a) (p)->lpVtbl->BeginDraw(p, a)
#define ID2D1CommandSink4_EndDraw(p, a) (p)->lpVtbl->EndDraw(p, a)
#define ID2D1CommandSink4_SetAntialiasMode(p, a) (p)->lpVtbl->SetAntialiasMode(p, a)
#define ID2D1CommandSink4_SetTags(p, a, b) (p)->lpVtbl->SetTags(p, a, b)
#define ID2D1CommandSink4_SetTextAntialiasMode(p, a) (p)->lpVtbl->SetTextAntialiasMode(p, a)
#define ID2D1CommandSink4_SetTextRenderingParams(p, a) (p)->lpVtbl->SetTextRenderingParams(p, a)
#define ID2D1CommandSink4_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1CommandSink4_SetPrimitiveBlend(p, a) (p)->lpVtbl->SetPrimitiveBlend(p, a)
#define ID2D1CommandSink4_SetUnitMode(p, a) (p)->lpVtbl->SetUnitMode(p, a)
#define ID2D1CommandSink4_Clear(p, a) (p)->lpVtbl->Clear(p, a)
#define ID2D1CommandSink4_DrawGlyphRun(p, a, b, c, d, e) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d, e)
#define ID2D1CommandSink4_DrawLine(p, a, b, c, d, e) (p)->lpVtbl->DrawLine(p, a, b, c, d, e)
#define ID2D1CommandSink4_DrawGeometry(p, a, b, c, d) (p)->lpVtbl->DrawGeometry(p, a, b, c, d)
#define ID2D1CommandSink4_DrawRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRectangle(p, a, b, c, d)
#define ID2D1CommandSink4_DrawBitmap(p, a, b, c, d, e, f) (p)->lpVtbl->DrawBitmap(p, a, b, c, d, e, f)
#define ID2D1CommandSink4_DrawImage(p, a, b, c, d, e) (p)->lpVtbl->DrawImage(p, a, b, c, d, e)
#define ID2D1CommandSink4_DrawGdiMetafile(p, a, b) (p)->lpVtbl->DrawGdiMetafile(p, a, b)
#define ID2D1CommandSink4_FillMesh(p, a, b) (p)->lpVtbl->FillMesh(p, a, b)
#define ID2D1CommandSink4_FillOpacityMask(p, a, b, c, d) (p)->lpVtbl->FillOpacityMask(p, a, b, c, d)
#define ID2D1CommandSink4_FillGeometry(p, a, b, c) (p)->lpVtbl->FillGeometry(p, a, b, c)
#define ID2D1CommandSink4_FillRectangle(p, a, b) (p)->lpVtbl->FillRectangle(p, a, b)
#define ID2D1CommandSink4_PushAxisAlignedClip(p, a, b) (p)->lpVtbl->PushAxisAlignedClip(p, a, b)
#define ID2D1CommandSink4_PushLayer(p, a, b) (p)->lpVtbl->PushLayer(p, a, b)
#define ID2D1CommandSink4_PopAxisAlignedClip(p, a) (p)->lpVtbl->PopAxisAlignedClip(p, a)
#define ID2D1CommandSink4_PopLayer(p, a) (p)->lpVtbl->PopLayer(p, a)
#define ID2D1CommandSink4_SetPrimitiveBlend1(p, a) (p)->lpVtbl->SetPrimitiveBlend1(p, a)
#define ID2D1CommandSink4_DrawInk(p, a, b, c) (p)->lpVtbl->DrawInk(p, a, b, c)
#define ID2D1CommandSink4_DrawGradientMesh(p, a) (p)->lpVtbl->DrawGradientMesh(p, a)
#define ID2D1CommandSink4_DrawGdiMetafile1(p, a, b, c) (p)->lpVtbl->DrawGdiMetafile1(p, a, b, c)
#define ID2D1CommandSink4_DrawSpriteBatch(p, a, b, c, d, e, f) (p)->lpVtbl->DrawSpriteBatch(p, a, b, c, d, e, f)
#define ID2D1CommandSink4_SetPrimitiveBlend2(p, a) (p)->lpVtbl->SetPrimitiveBlend2(p, a)

