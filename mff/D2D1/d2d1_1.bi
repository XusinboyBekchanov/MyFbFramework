'###############################################################################
' This file is part of MyFBFramework
' Authors: UEZ, Xusinboy Bekchanov, Liu XiaLin
' Based on UEZ's abstract version.
' Direct2D 1.2 API - FreeBASIC Translation
' Adapted by Xusinboy Bekchanov, Liu XiaLin
'###############################################################################
#pragma once
' ============================================================================
' Direct2D 1.1 API - FreeBASIC Translation
' ============================================================================
#include once "d2d1.bi"
#include once "d2d1effects.bi"
' ============================================================================
' Constants
' ============================================================================
Const D2D1_INVALID_PROPERTY_INDEX = &hFFFFFFFF
' ============================================================================
' Enumerations
' ============================================================================
Type D2D1_DEVICE_CONTEXT_OPTIONS As Long
Enum
    D2D1_DEVICE_CONTEXT_OPTIONS_NONE = 0
    D2D1_DEVICE_CONTEXT_OPTIONS_ENABLE_MULTITHREADED_OPTIMIZATIONS = 1
End Enum
Type D2D1_STROKE_TRANSFORM_TYPE As Long
Enum
    D2D1_STROKE_TRANSFORM_TYPE_NORMAL = 0
    D2D1_STROKE_TRANSFORM_TYPE_FIXED = 1
    D2D1_STROKE_TRANSFORM_TYPE_HAIRLINE = 2
End Enum
Type D2D1_PRIMITIVE_BLEND As Long
Enum
    D2D1_PRIMITIVE_BLEND_SOURCE_OVER = 0
    D2D1_PRIMITIVE_BLEND_COPY = 1
    D2D1_PRIMITIVE_BLEND_MIN = 2
    D2D1_PRIMITIVE_BLEND_ADD = 3
    D2D1_PRIMITIVE_BLEND_MAX = 4
End Enum
Type D2D1_UNIT_MODE As Long
Enum
    D2D1_UNIT_MODE_DIPS = 0
    D2D1_UNIT_MODE_PIXELS = 1
End Enum
Type D2D1_PRINT_FONT_SUBSET_MODE As Long
Enum
    D2D1_PRINT_FONT_SUBSET_MODE_DEFAULT = 0
    D2D1_PRINT_FONT_SUBSET_MODE_EACHPAGE = 1
    D2D1_PRINT_FONT_SUBSET_MODE_NONE = 2
End Enum
Type D2D1_COLOR_SPACE As Long
Enum
    D2D1_COLOR_SPACE_CUSTOM = 0
    D2D1_COLOR_SPACE_SRGB = 1
    D2D1_COLOR_SPACE_SCRGB = 2
End Enum
Type D2D1_BITMAP_OPTIONS As Long
Enum
    D2D1_BITMAP_OPTIONS_NONE = 0
    D2D1_BITMAP_OPTIONS_TARGET = 1
    D2D1_BITMAP_OPTIONS_CANNOT_DRAW = 2
    D2D1_BITMAP_OPTIONS_CPU_READ = 4
    D2D1_BITMAP_OPTIONS_GDI_COMPATIBLE = 8
End Enum
Type D2D1_MAP_OPTIONS As Long
Enum
    D2D1_MAP_OPTIONS_NONE = 0
    D2D1_MAP_OPTIONS_READ = 1
    D2D1_MAP_OPTIONS_WRITE = 2
    D2D1_MAP_OPTIONS_DISCARD = 4
End Enum
Type D2D1_BUFFER_PRECISION As Long
Enum
    D2D1_BUFFER_PRECISION_UNKNOWN = 0
    D2D1_BUFFER_PRECISION_8BPC_UNORM = 1
    D2D1_BUFFER_PRECISION_8BPC_UNORM_SRGB = 2
    D2D1_BUFFER_PRECISION_16BPC_UNORM = 3
    D2D1_BUFFER_PRECISION_16BPC_FLOAT = 4
    D2D1_BUFFER_PRECISION_32BPC_FLOAT = 5
End Enum
Type D2D1_COLOR_INTERPOLATION_MODE As Long
Enum
    D2D1_COLOR_INTERPOLATION_MODE_STRAIGHT = 0
    D2D1_COLOR_INTERPOLATION_MODE_PREMULTIPLIED = 1
End Enum
Type D2D1_INTERPOLATION_MODE As Long
Enum
    D2D1_INTERPOLATION_MODE_NEAREST_NEIGHBOR = 0
    D2D1_INTERPOLATION_MODE_LINEAR = 1
    D2D1_INTERPOLATION_MODE_CUBIC = 2
    D2D1_INTERPOLATION_MODE_MULTI_SAMPLE_LINEAR = 3
    D2D1_INTERPOLATION_MODE_ANISOTROPIC = 4
    D2D1_INTERPOLATION_MODE_HIGH_QUALITY_CUBIC = 5
End Enum
Type D2D1_COMPOSITE_MODE As Long
Enum
    D2D1_COMPOSITE_MODE_SOURCE_OVER = 0
    D2D1_COMPOSITE_MODE_DESTINATION_OVER = 1
    D2D1_COMPOSITE_MODE_SOURCE_IN = 2
    D2D1_COMPOSITE_MODE_DESTINATION_IN = 3
    D2D1_COMPOSITE_MODE_SOURCE_OUT = 4
    D2D1_COMPOSITE_MODE_DESTINATION_OUT = 5
    D2D1_COMPOSITE_MODE_SOURCE_ATOP = 6
    D2D1_COMPOSITE_MODE_DESTINATION_ATOP = 7
    D2D1_COMPOSITE_MODE_XOR = 8
    D2D1_COMPOSITE_MODE_PLUS = 9
    D2D1_COMPOSITE_MODE_SOURCE_COPY = 10
    D2D1_COMPOSITE_MODE_BOUNDED_SOURCE_COPY = 11
    D2D1_COMPOSITE_MODE_MASK_INVERT = 12
End Enum
Type D2D1_LAYER_OPTIONS1 As Long
Enum
    D2D1_LAYER_OPTIONS1_NONE = 0
    D2D1_LAYER_OPTIONS1_INITIALIZE_FROM_BACKGROUND = 1
    D2D1_LAYER_OPTIONS1_IGNORE_ALPHA = 2
End Enum
Type D2D1_PROPERTY_TYPE As Long
Enum
    D2D1_PROPERTY_TYPE_UNKNOWN = 0
    D2D1_PROPERTY_TYPE_STRING = 1
    D2D1_PROPERTY_TYPE_BOOL = 2
    D2D1_PROPERTY_TYPE_UINT32 = 3
    D2D1_PROPERTY_TYPE_INT32 = 4
    D2D1_PROPERTY_TYPE_FLOAT = 5
    D2D1_PROPERTY_TYPE_VECTOR2 = 6
    D2D1_PROPERTY_TYPE_VECTOR3 = 7
    D2D1_PROPERTY_TYPE_VECTOR4 = 8
    D2D1_PROPERTY_TYPE_BLOB = 9
    D2D1_PROPERTY_TYPE_IUNKNOWN = 10
    D2D1_PROPERTY_TYPE_ENUM = 11
    D2D1_PROPERTY_TYPE_ARRAY = 12
    D2D1_PROPERTY_TYPE_CLSID = 13
    D2D1_PROPERTY_TYPE_MATRIX_3X2 = 14
    D2D1_PROPERTY_TYPE_MATRIX_4X3 = 15
    D2D1_PROPERTY_TYPE_MATRIX_4X4 = 16
    D2D1_PROPERTY_TYPE_MATRIX_5X4 = 17
    D2D1_PROPERTY_TYPE_COLOR_CONTEXT = 18
End Enum
Type D2D1_PROPERTY As Long
Enum
    D2D1_PROPERTY_CLSID = &h80000000
    D2D1_PROPERTY_DISPLAYNAME = &h80000001
    D2D1_PROPERTY_AUTHOR = &h80000002
    D2D1_PROPERTY_CATEGORY = &h80000003
    D2D1_PROPERTY_DESCRIPTION = &h80000004
    D2D1_PROPERTY_INPUTS = &h80000005
    D2D1_PROPERTY_CACHED = &h80000006
    D2D1_PROPERTY_PRECISION = &h80000007
    D2D1_PROPERTY_MIN_INPUTS = &h80000008
    D2D1_PROPERTY_MAX_INPUTS = &h80000009
End Enum
Type D2D1_SUBPROPERTY As Long
Enum
    D2D1_SUBPROPERTY_DISPLAYNAME = &h80000000
    D2D1_SUBPROPERTY_ISREADONLY = &h80000001
    D2D1_SUBPROPERTY_MIN = &h80000002
    D2D1_SUBPROPERTY_MAX = &h80000003
    D2D1_SUBPROPERTY_DEFAULT = &h80000004
    D2D1_SUBPROPERTY_FIELDS = &h80000005
    D2D1_SUBPROPERTY_INDEX = &h80000006
End Enum
Type D2D1_THREADING_MODE As Long
Enum
    D2D1_THREADING_MODE_SINGLE_THREADED = 0  ' D2D1_FACTORY_TYPE_SINGLE_THREADED
    D2D1_THREADING_MODE_MULTI_THREADED = 1   ' D2D1_FACTORY_TYPE_MULTI_THREADED
End Enum
' ============================================================================
' Structures
' ============================================================================
Type D2D1_CREATION_PROPERTIES
    threadingMode As D2D1_THREADING_MODE
    debugLevel As D2D1_DEBUG_LEVEL
    options As D2D1_DEVICE_CONTEXT_OPTIONS
End Type
Type D2D1_STROKE_STYLE_PROPERTIES1
    startCap As D2D1_CAP_STYLE
    endCap As D2D1_CAP_STYLE
    dashCap As D2D1_CAP_STYLE
    lineJoin As D2D1_LINE_JOIN
    miterLimit As Single
    dashStyle As D2D1_DASH_STYLE
    dashOffset As Single
    transformType As D2D1_STROKE_TRANSFORM_TYPE
End Type
Type D2D1_DRAWING_STATE_DESCRIPTION1
    antialiasMode As D2D1_ANTIALIAS_MODE
    textAntialiasMode As D2D1_TEXT_ANTIALIAS_MODE
    tag1 As D2D1_TAG
    tag2 As D2D1_TAG
    transform As D2D1_MATRIX_3X2_F
    primitiveBlend As D2D1_PRIMITIVE_BLEND
    unitMode As D2D1_UNIT_MODE
End Type
Type D2D1_PRINT_CONTROL_PROPERTIES
    fontSubset As D2D1_PRINT_FONT_SUBSET_MODE
    rasterDPI As Single
    colorSpace As D2D1_COLOR_SPACE
End Type
Type D2D1_MAPPED_RECT
    pitch As ULong
    bits As UByte Ptr
End Type
Type D2D1_BITMAP_PROPERTIES1
    pixelFormat As D2D1_PIXEL_FORMAT
    dpiX As Single
    dpiY As Single
    bitmapOptions As D2D1_BITMAP_OPTIONS
    colorContext As Any Ptr  ' ID2D1ColorContext Ptr
End Type
Type D2D1_IMAGE_BRUSH_PROPERTIES
    sourceRectangle As D2D1_RECT_F
    extendModeX As D2D1_EXTEND_MODE
    extendModeY As D2D1_EXTEND_MODE
    interpolationMode As D2D1_INTERPOLATION_MODE
End Type
Type D2D1_BITMAP_BRUSH_PROPERTIES1
    extendModeX As D2D1_EXTEND_MODE
    extendModeY As D2D1_EXTEND_MODE
    interpolationMode As D2D1_INTERPOLATION_MODE
End Type
Type D2D1_RENDERING_CONTROLS
    bufferPrecision As D2D1_BUFFER_PRECISION
    tileSize As D2D1_SIZE_U
End Type
Type D2D1_LAYER_PARAMETERS1
    contentBounds As D2D1_RECT_F
    geometricMask As ID2D1Geometry Ptr
    maskAntialiasMode As D2D1_ANTIALIAS_MODE
    maskTransform As D2D1_MATRIX_3X2_F
    opacity As Single
    opacityBrush As ID2D1Brush Ptr
    layerOptions As D2D1_LAYER_OPTIONS1
End Type
Type D2D1_EFFECT_INPUT_DESCRIPTION
    effect As Any Ptr  ' ID2D1Effect Ptr
    inputIndex As ULong
    inputRectangle As D2D1_RECT_F
End Type
Type D2D1_POINT_DESCRIPTION
    point As D2D1_POINT_2F
    unitTangentVector As D2D1_POINT_2F
    endSegment As ULong
    endFigure As ULong
    lengthToEndSegment As Single
End Type
' Forward declaration for property binding
'Type D2D1_PROPERTY_BINDING As Any
' Effect factory callback
Type PD2D1_EFFECT_FACTORY As Function(ByVal effect As Any Ptr Ptr) As HRESULT
' ============================================================================
' IID Definitions
' ============================================================================
Dim Shared IID_ID2D1GdiMetafileSink As GUID = Type(&h82237326, &h8111, &h4f7c, {&hbc, &hf4, &hb5, &hc1, &h17, &h55, &h64, &hfe})
Dim Shared IID_ID2D1GdiMetafile As GUID = Type(&h2f543dc3, &hcfc1, &h4211, {&h86, &h4f, &hcf, &hd9, &h1c, &h6f, &h33, &h95})
Dim Shared IID_ID2D1PathGeometry1 As GUID = Type(&h62baa2d2, &hab54, &h41b7, {&hb8, &h72, &h78, &h7e, &h01, &h06, &ha4, &h21})
Dim Shared IID_ID2D1Properties As GUID = Type(&h483473d7, &hcd46, &h4f9d, {&h9d, &h3a, &h31, &h12, &haa, &h80, &h15, &h9d})
Dim Shared IID_ID2D1Effect As GUID = Type(&h28211a43, &h7d89, &h476f, {&h81, &h81, &h2d, &h61, &h59, &hb2, &h20, &had})
Dim Shared IID_ID2D1DrawingStateBlock1 As GUID = Type(&h689f1f85, &hc72e, &h4e33, {&h8f, &h19, &h85, &h75, &h4e, &hfd, &h5a, &hce})
Dim Shared IID_ID2D1ColorContext As GUID = Type(&h1c4820bb, &h5771, &h4518, {&ha5, &h81, &h2f, &he4, &hdd, &h0e, &hc6, &h57})
Dim Shared IID_ID2D1Bitmap1 As GUID = Type(&ha898a84c, &h3873, &h4588, {&hb0, &h8b, &heb, &hbf, &h97, &h8d, &hf0, &h41})
Dim Shared IID_ID2D1BitmapBrush1 As GUID = Type(&h41343a53, &he41a, &h49a2, {&h91, &hcd, &h21, &h79, &h3b, &hbb, &h62, &he5})
Dim Shared IID_ID2D1GradientStopCollection1 As GUID = Type(&hae1572f4, &h5dd0, &h4777, {&h99, &h8b, &h92, &h79, &h47, &h2a, &he6, &h3b})
Dim Shared IID_ID2D1Device As GUID = Type(&h47dd575d, &hac05, &h4cdd, {&h80, &h49, &h9b, &h02, &hcd, &h16, &hf4, &h4c})
Dim Shared IID_ID2D1CommandSink As GUID = Type(&h54d7898a, &ha061, &h40a7, {&hbe, &hc7, &he4, &h65, &hbc, &hba, &h2c, &h4f})
Dim Shared IID_ID2D1CommandList As GUID = Type(&hb4f34a19, &h2383, &h4d76, {&h94, &hf6, &hec, &h34, &h36, &h57, &hc3, &hdc})
Dim Shared IID_ID2D1PrintControl As GUID = Type(&h2c1d867d, &hc290, &h41c8, {&hae, &h7e, &h34, &ha9, &h87, &h02, &he9, &ha5})
Dim Shared IID_ID2D1ImageBrush As GUID = Type(&hfe9e984d, &h3f95, &h407c, {&hb5, &hdb, &hcb, &h94, &hd4, &he8, &hf8, &h7c})
Dim Shared IID_ID2D1DeviceContext As GUID = Type(&he8f7fe7a, &h191c, &h466d, {&had, &h95, &h97, &h56, &h78, &hbd, &ha9, &h98})
Dim Shared IID_ID2D1StrokeStyle1 As GUID = Type(&h10a72a66, &he91c, &h43f4, {&h99, &h3f, &hdd, &hf4, &hb8, &h2b, &h0b, &h4a})
Dim Shared IID_ID2D1Factory1 As GUID = Type(&hbb12d362, &hdaee, &h4b9a, {&haa, &h1d, &h14, &hba, &h40, &h1c, &hfa, &h1f})
Dim Shared IID_ID2D1Multithread As GUID = Type(&h31e6e7bc, &he0ff, &h4d46, {&h8c, &h64, &ha0, &ha8, &hc4, &h1c, &h15, &hd3})

'Type PD2D1_EFFECT_FACTORY As Function (ByVal effect As IUnknownBase Ptr Ptr) As HRESULT
Type PD2D1_PROPERTY_SET_FUNCTION As Function (ByVal effect As IUnknownBase Ptr, ByVal data As Const Byte Ptr, ByVal dataSize As UINT32 ) As HRESULT
Type PD2D1_PROPERTY_GET_FUNCTION As Function ( ByVal effect As Const IUnknownBase Ptr, ByVal data As Byte Ptr, ByVal dataSize As UINT32, ByVal actualSize As UINT32 Ptr ) As HRESULT
' ============================================================================
' Interfaces
' ============================================================================
' ============================================================================
' ID2D1GdiMetafileSink
' ============================================================================
Type ID2D1GdiMetafileSinkVtbl As ID2D1GdiMetafileSinkVtbl_
Type ID2D1GdiMetafileSink
    lpVtbl As ID2D1GdiMetafileSinkVtbl Ptr
End Type
Type ID2D1GdiMetafileSinkVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As ID2D1GdiMetafileSink Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1GdiMetafileSink Ptr) As ULong
    Release As Function(ByVal This As ID2D1GdiMetafileSink Ptr) As ULong

        
    ProcessRecord As Function(ByVal This As ID2D1GdiMetafileSink Ptr,  ByVal record_type As ULong, ByVal data As Any Ptr, ByVal size As ULong ) As HRESULT
End Type
#define ID2D1GdiMetafileSink_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1GdiMetafileSink_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1GdiMetafileSink_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1GdiMetafileSink_ProcessRecord(p, a, b, c) (p)->lpVtbl->ProcessRecord(p, a, b, c)

' ============================================================================
' ID2D1GdiMetafile
' ============================================================================
Type ID2D1GdiMetafileVtbl As ID2D1GdiMetafileVtbl_
Type ID2D1GdiMetafile
    lpVtbl As ID2D1GdiMetafileVtbl Ptr
End Type
Type ID2D1GdiMetafileVtbl_     '' Extends ID2D1ResourceVtbl_
    QueryInterface As Function(ByVal This As ID2D1GdiMetafile Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1GdiMetafile Ptr) As ULong
    Release As Function(ByVal This As ID2D1GdiMetafile Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1GdiMetafile Ptr, ByVal factory As Any Ptr Ptr)

        ' 4: GetFactory
        ' 5. Stream
    Stream As Function(ByVal This As ID2D1GdiMetafile Ptr,  ByVal sink As ID2D1GdiMetafileSink Ptr ) As HRESULT
        ' 6. GetBounds
    GetBounds As Function(ByVal This As ID2D1GdiMetafile Ptr,  ByVal bounds As D2D1_RECT_F Ptr ) As HRESULT
End Type
#define ID2D1GdiMetafile_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1GdiMetafile_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1GdiMetafile_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1GdiMetafile_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1GdiMetafile_Stream(p, a) (p)->lpVtbl->Stream(p, a)
#define ID2D1GdiMetafile_GetBounds(p, a) (p)->lpVtbl->GetBounds(p, a)

' ============================================================================
' ID2D1PathGeometry1
' ============================================================================
Type ID2D1PathGeometry1Vtbl As ID2D1PathGeometry1Vtbl_
Type ID2D1PathGeometry1
    lpVtbl As ID2D1PathGeometry1Vtbl Ptr
End Type
Type ID2D1PathGeometry1Vtbl_     '' Extends ID2D1PathGeometryVtbl_
    QueryInterface As Function(ByVal This As ID2D1PathGeometry1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1PathGeometry1 Ptr) As ULong
    Release As Function(ByVal This As ID2D1PathGeometry1 Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1PathGeometry1 Ptr, ByVal factory As Any Ptr Ptr)
    GetBounds As Function(ByVal This As ID2D1PathGeometry1 Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal bounds As D2D1_RECT_F Ptr) As HRESULT
    GetWidenedBounds As Function(ByVal This As ID2D1PathGeometry1 Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal bounds As D2D1_RECT_F Ptr) As HRESULT
    StrokeContainsPoint As Function(ByVal This As ID2D1PathGeometry1 Ptr, ByVal point As D2D1_POINT_2F, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal contains As BOOL Ptr) As HRESULT
    FillContainsPoint As Function(ByVal This As ID2D1PathGeometry1 Ptr, ByVal point As D2D1_POINT_2F, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal contains As BOOL Ptr) As HRESULT
    CompareWithGeometry As Function(ByVal This As ID2D1PathGeometry1 Ptr, ByVal inputGeometry As Any Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal relation As D2D1_GEOMETRY_RELATION Ptr) As HRESULT
    Simplify As Function(ByVal This As ID2D1PathGeometry1 Ptr, ByVal simplificationOption As D2D1_GEOMETRY_SIMPLIFICATION_OPTION, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    Tessellate As Function(ByVal This As ID2D1PathGeometry1 Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal tessellationSink As ID2D1TessellationSink Ptr) As HRESULT
    CombineWithGeometry As Function(ByVal This As ID2D1PathGeometry1 Ptr, ByVal inputGeometry As ID2D1PathGeometry1 Ptr, ByVal combineMode As D2D1_COMBINE_MODE, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    Outline As Function(ByVal This As ID2D1PathGeometry1 Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    ComputeArea As Function(ByVal This As ID2D1PathGeometry1 Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal area As Single Ptr) As HRESULT
    ComputeLength As Function(ByVal This As ID2D1PathGeometry1 Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal length As Single Ptr) As HRESULT
    ComputePointAtLength As Function(ByVal This As ID2D1PathGeometry1 Ptr, ByVal length As Single, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal point As D2D1_POINT_2F Ptr, ByVal unitVectorX As D2D1_POINT_2F Ptr) As HRESULT
    Widen As Sub(ByVal This As ID2D1PathGeometry1 Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr)
    Open As Function(ByVal This As ID2D1PathGeometry1 Ptr, ByVal geometrySink As ID2D1GeometrySink Ptr Ptr) As HRESULT
    Stream As Function(ByVal This As ID2D1PathGeometry1 Ptr, ByVal geometrySink As ID2D1GeometrySink Ptr) As HRESULT    
    GetSegmentCount As Function(ByVal This As ID2D1PathGeometry1 Ptr, ByRef count As ULong) As HRESULT  
    GetFigureCount As Function(ByVal This As ID2D1PathGeometry1 Ptr, ByRef count As ULong) As HRESULT

        ' Erbt von ID2D1PathGeometry
        ' 5. ComputePointAndSegmentAtLength
    ComputePointAndSegmentAtLength As Function(ByVal This As ID2D1PathGeometry1 Ptr,  ByVal length As Single, ByVal start_segment As ULong, ByVal transform As D2D1_MATRIX_3X2_F Ptr, ByVal tolerance As Single, ByVal point_desc As D2D1_POINT_DESCRIPTION Ptr ) As HRESULT
End Type
#define ID2D1PathGeometry1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1PathGeometry1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1PathGeometry1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1PathGeometry1_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1PathGeometry1_GetBounds(p, a, b) (p)->lpVtbl->GetBounds(p, a, b)
#define ID2D1PathGeometry1_GetWidenedBounds(p, a, b, c, d, e) (p)->lpVtbl->GetWidenedBounds(p, a, b, c, d, e)
#define ID2D1PathGeometry1_StrokeContainsPoint(p, a, b, c, d, e, f) (p)->lpVtbl->StrokeContainsPoint(p, a, b, c, d, e, f)
#define ID2D1PathGeometry1_FillContainsPoint(p, a, b, c, d) (p)->lpVtbl->FillContainsPoint(p, a, b, c, d)
#define ID2D1PathGeometry1_CompareWithGeometry(p, a, b, c, d) (p)->lpVtbl->CompareWithGeometry(p, a, b, c, d)
#define ID2D1PathGeometry1_Simplify(p, a, b, c, d) (p)->lpVtbl->Simplify(p, a, b, c, d)
#define ID2D1PathGeometry1_Tessellate(p, a, b, c) (p)->lpVtbl->Tessellate(p, a, b, c)
#define ID2D1PathGeometry1_CombineWithGeometry(p, a, b, c, d, e) (p)->lpVtbl->CombineWithGeometry(p, a, b, c, d, e)
#define ID2D1PathGeometry1_Outline(p, a, b, c) (p)->lpVtbl->Outline(p, a, b, c)
#define ID2D1PathGeometry1_ComputeArea(p, a, b, c) (p)->lpVtbl->ComputeArea(p, a, b, c)
#define ID2D1PathGeometry1_ComputeLength(p, a, b, c) (p)->lpVtbl->ComputeLength(p, a, b, c)
#define ID2D1PathGeometry1_ComputePointAtLength(p, a, b, c, d, e) (p)->lpVtbl->ComputePointAtLength(p, a, b, c, d, e)
#define ID2D1PathGeometry1_Widen(p, a, b, c, d, e) (p)->lpVtbl->Widen(p, a, b, c, d, e)
#define ID2D1PathGeometry1_Open(p, a) (p)->lpVtbl->Open(p, a)
#define ID2D1PathGeometry1_Stream(p, a) (p)->lpVtbl->Stream(p, a)
#define ID2D1PathGeometry1_GetSegmentCount(p, a) (p)->lpVtbl->GetSegmentCount(p, a)
#define ID2D1PathGeometry1_GetFigureCount(p, a) (p)->lpVtbl->GetFigureCount(p, a)
#define ID2D1PathGeometry1_ComputePointAndSegmentAtLength(p, a, b, c, d, e) (p)->lpVtbl->ComputePointAndSegmentAtLength(p, a, b, c, d, e)

' ============================================================================
' ID2D1Properties
' ============================================================================
Type ID2D1PropertiesVtbl As ID2D1PropertiesVtbl_
Type ID2D1Properties
    lpVtbl As ID2D1PropertiesVtbl Ptr
End Type
Type ID2D1PropertiesVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As ID2D1Properties Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Properties Ptr) As ULong
    Release As Function(ByVal This As ID2D1Properties Ptr) As ULong

        
    GetPropertyCount As Function(ByVal This As ID2D1Properties Ptr) As ULong
        ' 5. GetPropertyName
    GetPropertyName As Function(ByVal This As ID2D1Properties Ptr,  ByVal index As ULong, ByVal name As WString Ptr, ByVal name_count As ULong ) As HRESULT
        ' 6. GetPropertyNameLength
    GetPropertyNameLength As Function(ByVal This As ID2D1Properties Ptr,  ByVal index As ULong ) As ULong
        ' 7. GetType
    GetType As Function(ByVal This As ID2D1Properties Ptr,  ByVal index As ULong ) As D2D1_PROPERTY_TYPE
        ' 8. GetPropertyIndex
    GetPropertyIndex As Function(ByVal This As ID2D1Properties Ptr,  ByVal name As WString Ptr ) As ULong
        ' 9. SetValueByName
    SetValueByName As Function(ByVal This As ID2D1Properties Ptr,  ByVal name As WString Ptr, ByVal prop_type As D2D1_PROPERTY_TYPE, ByVal value As UByte Ptr, ByVal value_size As ULong ) As HRESULT
        ' 10. SetValue
    SetValue As Function(ByVal This As ID2D1Properties Ptr,  ByVal index As ULong, ByVal prop_type As D2D1_PROPERTY_TYPE, ByVal value As UByte Ptr, ByVal value_size As ULong ) As HRESULT
        ' 11. GetValueByName
    GetValueByName As Function(ByVal This As ID2D1Properties Ptr,  ByVal name As WString Ptr, ByVal prop_type As D2D1_PROPERTY_TYPE, ByVal value As UByte Ptr, ByVal value_size As ULong ) As HRESULT
        ' 12. GetValue
    GetValue As Function(ByVal This As ID2D1Properties Ptr,  ByVal index As ULong, ByVal prop_type As D2D1_PROPERTY_TYPE, ByVal value As UByte Ptr, ByVal value_size As ULong ) As HRESULT
        ' 13. GetValueSize
    GetValueSize As Function(ByVal This As ID2D1Properties Ptr,  ByVal index As ULong ) As ULong
        ' 14. GetSubProperties
    GetSubProperties As Function(ByVal This As ID2D1Properties Ptr,  ByVal index As ULong, ByVal props As Any Ptr Ptr ) As HRESULT
End Type
#define ID2D1Properties_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Properties_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Properties_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Properties_GetPropertyCount(p, a) (p)->lpVtbl->GetPropertyCount(p, a)
#define ID2D1Properties_GetPropertyName(p, a, b, c) (p)->lpVtbl->GetPropertyName(p, a, b, c)
#define ID2D1Properties_GetPropertyNameLength(p, a) (p)->lpVtbl->GetPropertyNameLength(p, a)
#define ID2D1Properties_GetType(p, a) (p)->lpVtbl->GetType(p, a)
#define ID2D1Properties_GetPropertyIndex(p, a) (p)->lpVtbl->GetPropertyIndex(p, a)
#define ID2D1Properties_SetValueByName(p, a, b, c, d) (p)->lpVtbl->SetValueByName(p, a, b, c, d)
#define ID2D1Properties_SetValue(p, a, b, c, d) (p)->lpVtbl->SetValue(p, a, b, c, d)
#define ID2D1Properties_GetValueByName(p, a, b, c, d) (p)->lpVtbl->GetValueByName(p, a, b, c, d)
#define ID2D1Properties_GetValue(p, a, b, c, d) (p)->lpVtbl->GetValue(p, a, b, c, d)
#define ID2D1Properties_GetValueSize(p, a) (p)->lpVtbl->GetValueSize(p, a)
#define ID2D1Properties_GetSubProperties(p, a, b) (p)->lpVtbl->GetSubProperties(p, a, b)

' ============================================================================
' ID2D1Effect
' ============================================================================
Type ID2D1EffectVtbl As ID2D1EffectVtbl_
Type ID2D1Effect
    lpVtbl As ID2D1EffectVtbl Ptr
End Type
Type ID2D1EffectVtbl_     '' Extends ID2D1PropertiesVtbl_
    QueryInterface As Function(ByVal This As ID2D1Effect Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Effect Ptr) As ULong
    Release As Function(ByVal This As ID2D1Effect Ptr) As ULong
        
    GetPropertyCount As Function(ByVal This As ID2D1Effect Ptr) As ULong
        ' 5. GetPropertyName
    GetPropertyName As Function(ByVal This As ID2D1Effect Ptr,  ByVal index As ULong, ByVal name As WString Ptr, ByVal name_count As ULong ) As HRESULT
        ' 6. GetPropertyNameLength
    GetPropertyNameLength As Function(ByVal This As ID2D1Effect Ptr,  ByVal index As ULong ) As ULong
        ' 7. GetType
    GetType As Function(ByVal This As ID2D1Effect Ptr,  ByVal index As ULong ) As D2D1_PROPERTY_TYPE
        ' 8. GetPropertyIndex
    GetPropertyIndex As Function(ByVal This As ID2D1Effect Ptr,  ByVal name As WString Ptr ) As ULong
        ' 9. SetValueByName
    SetValueByName As Function(ByVal This As ID2D1Effect Ptr,  ByVal name As WString Ptr, ByVal prop_type As D2D1_PROPERTY_TYPE, ByVal value As UByte Ptr, ByVal value_size As ULong ) As HRESULT
        ' 10. SetValue
    SetValue As Function(ByVal This As ID2D1Effect Ptr,  ByVal index As ULong, ByVal prop_type As D2D1_PROPERTY_TYPE, ByVal value As UByte Ptr, ByVal value_size As ULong ) As HRESULT
        ' 11. GetValueByName
    GetValueByName As Function(ByVal This As ID2D1Effect Ptr,  ByVal name As WString Ptr, ByVal prop_type As D2D1_PROPERTY_TYPE, ByVal value As UByte Ptr, ByVal value_size As ULong ) As HRESULT
        ' 12. GetValue
    GetValue As Function(ByVal This As ID2D1Effect Ptr,  ByVal index As ULong, ByVal prop_type As D2D1_PROPERTY_TYPE, ByVal value As UByte Ptr, ByVal value_size As ULong ) As HRESULT
        ' 13. GetValueSize
    GetValueSize As Function(ByVal This As ID2D1Effect Ptr,  ByVal index As ULong ) As ULong
        ' 14. GetSubProperties
    GetSubProperties As Function(ByVal This As ID2D1Effect Ptr,  ByVal index As ULong, ByVal props As Any Ptr Ptr ) As HRESULT

        ' Erbt von ID2D1Properties (1-14)
        ' 15. SetInput
    SetInput As Sub(ByVal This As ID2D1Effect Ptr,  ByVal index As ULong, ByVal input As ID2D1Image Ptr, ByVal invalidate As Long = True )
        ' 16. SetInputCount
    SetInputCount As Function(ByVal This As ID2D1Effect Ptr,  ByVal count As ULong ) As HRESULT
        ' 17. GetInput
    GetInput As Sub(ByVal This As ID2D1Effect Ptr,  ByVal index As ULong, ByVal input As ID2D1Image Ptr Ptr )
        ' 18. GetInputCount
    GetInputCount As Function(ByVal This As ID2D1Effect Ptr) As ULong
        ' 19. GetOutput
    GetOutput As Sub(ByVal This As ID2D1Effect Ptr,  ByVal output As ID2D1Image Ptr Ptr )
End Type
#define ID2D1Effect_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Effect_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Effect_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Effect_GetPropertyCount(p, a) (p)->lpVtbl->GetPropertyCount(p, a)
#define ID2D1Effect_GetPropertyName(p, a, b, c) (p)->lpVtbl->GetPropertyName(p, a, b, c)
#define ID2D1Effect_GetPropertyNameLength(p, a) (p)->lpVtbl->GetPropertyNameLength(p, a)
#define ID2D1Effect_GetType(p, a) (p)->lpVtbl->GetType(p, a)
#define ID2D1Effect_GetPropertyIndex(p, a) (p)->lpVtbl->GetPropertyIndex(p, a)
#define ID2D1Effect_SetValueByName(p, a, b, c, d) (p)->lpVtbl->SetValueByName(p, a, b, c, d)
#define ID2D1Effect_SetValue(p, a, b, c, d) (p)->lpVtbl->SetValue(p, a, b, c, d)
#define ID2D1Effect_GetValueByName(p, a, b, c, d) (p)->lpVtbl->GetValueByName(p, a, b, c, d)
#define ID2D1Effect_GetValue(p, a, b, c, d) (p)->lpVtbl->GetValue(p, a, b, c, d)
#define ID2D1Effect_GetValueSize(p, a) (p)->lpVtbl->GetValueSize(p, a)
#define ID2D1Effect_GetSubProperties(p, a, b) (p)->lpVtbl->GetSubProperties(p, a, b)
#define ID2D1Effect_SetInput(p, a, b, c) (p)->lpVtbl->SetInput(p, a, b, c)
#define ID2D1Effect_SetInputCount(p, a) (p)->lpVtbl->SetInputCount(p, a)
#define ID2D1Effect_GetInput(p, a, b) (p)->lpVtbl->GetInput(p, a, b)
#define ID2D1Effect_GetInputCount(p, a) (p)->lpVtbl->GetInputCount(p, a)
#define ID2D1Effect_GetOutput(p, a) (p)->lpVtbl->GetOutput(p, a)

' ============================================================================
' ID2D1DrawingStateBlock1
' ============================================================================
Type ID2D1DrawingStateBlock1Vtbl As ID2D1DrawingStateBlock1Vtbl_
Type ID2D1DrawingStateBlock1
    lpVtbl As ID2D1DrawingStateBlock1Vtbl Ptr
End Type
Type ID2D1DrawingStateBlock1Vtbl_     '' Extends ID2D1DrawingStateBlockVtbl_
        ' Erbt von ID2D1DrawingStateBlock
        ' Zusätzliche Methoden
    GetDescription As Sub(ByVal This As ID2D1DrawingStateBlock1 Ptr,  ByVal desc As D2D1_DRAWING_STATE_DESCRIPTION1 Ptr )
    SetDescription As Sub(ByVal This As ID2D1DrawingStateBlock1 Ptr,  ByVal desc As D2D1_DRAWING_STATE_DESCRIPTION1 Ptr )
End Type
#define ID2D1DrawingStateBlock1_GetDescription(p, a) (p)->lpVtbl->GetDescription(p, a)
#define ID2D1DrawingStateBlock1_SetDescription(p, a) (p)->lpVtbl->SetDescription(p, a)

' ============================================================================
' ID2D1ColorContext
' ============================================================================
Type ID2D1ColorContextVtbl As ID2D1ColorContextVtbl_
Type ID2D1ColorContext
    lpVtbl As ID2D1ColorContextVtbl Ptr
End Type
Type ID2D1ColorContextVtbl_     '' Extends ID2D1ResourceVtbl_
    QueryInterface As Function(ByVal This As ID2D1ColorContext Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1ColorContext Ptr) As ULong
    Release As Function(ByVal This As ID2D1ColorContext Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1ColorContext Ptr, ByVal factory As Any Ptr Ptr)

        ' 4: GetFactory
        ' 5. GetColorSpace
    GetColorSpace As Function(ByVal This As ID2D1ColorContext Ptr) As D2D1_COLOR_SPACE
        ' 6. GetProfileSize
    GetProfileSize As Function(ByVal This As ID2D1ColorContext Ptr) As ULong
        ' 7. GetProfile
    GetProfile As Function(ByVal This As ID2D1ColorContext Ptr,  ByVal profile As UByte Ptr, ByVal size As ULong ) As HRESULT
End Type
#define ID2D1ColorContext_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1ColorContext_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1ColorContext_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1ColorContext_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1ColorContext_GetColorSpace(p, a) (p)->lpVtbl->GetColorSpace(p, a)
#define ID2D1ColorContext_GetProfileSize(p, a) (p)->lpVtbl->GetProfileSize(p, a)
#define ID2D1ColorContext_GetProfile(p, a, b) (p)->lpVtbl->GetProfile(p, a, b)

' ============================================================================
' ID2D1Bitmap1
' ============================================================================
Type ID2D1Bitmap1Vtbl As ID2D1Bitmap1Vtbl_
Type ID2D1Bitmap1
    lpVtbl As ID2D1Bitmap1Vtbl Ptr
End Type
Type ID2D1Bitmap1Vtbl_     '' Extends ID2D1BitmapVtbl_
	QueryInterface As Function(ByVal This As ID2D1Bitmap1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Bitmap1 Ptr) As ULong
    Release As Function(ByVal This As ID2D1Bitmap1 Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1Bitmap1 Ptr, ByVal factory As Any Ptr Ptr)
    
    GetSize As Sub(ByVal This As ID2D1Bitmap1 Ptr, ByVal size As D2D1_SIZE_F Ptr)
    GetPixelSize As Sub(ByVal This As ID2D1Bitmap1 Ptr, ByVal pixSize As D2D1_SIZE_U Ptr)
    GetPixelFormat As Sub(ByVal This As ID2D1Bitmap1 Ptr, ByVal pixFormat As D2D1_PIXEL_FORMAT Ptr)
    GetDpi As Sub(ByVal This As ID2D1Bitmap1 Ptr, ByRef dpiX As Single, ByRef dpiY As Single)
    CopyFromBitmap As Function(ByVal This As ID2D1Bitmap1 Ptr, ByVal destPoint As D2D1_POINT_2U Ptr, ByVal bitmap As ID2D1Bitmap1 Ptr, ByVal srcRect As D2D1_RECT_U Ptr) As HRESULT
    CopyFromRenderTarget As Function(ByVal This As ID2D1Bitmap1 Ptr, ByVal destPoint As D2D1_POINT_2U Ptr, ByVal renderTarget As Any Ptr, ByVal srcRect As D2D1_RECT_U Ptr) As HRESULT
    CopyFromMemory As Function(ByVal This As ID2D1Bitmap1 Ptr, ByVal dstRect As D2D1_RECT_U Ptr, ByVal srcData As Any Ptr, ByVal pitch As ULong) As HRESULT

    GetColorContext As Sub(ByVal This As ID2D1Bitmap1 Ptr,  ByVal context As Any Ptr Ptr )
    GetOptions As Function(ByVal This As ID2D1Bitmap1 Ptr) As D2D1_BITMAP_OPTIONS
    GetSurface As Function(ByVal This As ID2D1Bitmap1 Ptr,  ByVal surface As Any Ptr Ptr ) As HRESULT
    Map As Function(ByVal This As ID2D1Bitmap1 Ptr,  ByVal options As D2D1_MAP_OPTIONS, ByVal mapped_rect As D2D1_MAPPED_RECT Ptr ) As HRESULT
    Unmap As Function(ByVal This As ID2D1Bitmap1 Ptr) As HRESULT
End Type
#define ID2D1Bitmap1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Bitmap1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Bitmap1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Bitmap1_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1Bitmap1_GetSize(p, a) (p)->lpVtbl->GetSize(p, a)
#define ID2D1Bitmap1_GetPixelSize(p, a) (p)->lpVtbl->GetPixelSize(p, a)
#define ID2D1Bitmap1_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)
#define ID2D1Bitmap1_GetDpi(p, a, b) (p)->lpVtbl->GetDpi(p, a, b)
#define ID2D1Bitmap1_CopyFromBitmap(p, a, b, c) (p)->lpVtbl->CopyFromBitmap(p, a, b, c)
#define ID2D1Bitmap1_CopyFromRenderTarget(p, a, b, c) (p)->lpVtbl->CopyFromRenderTarget(p, a, b, c)
#define ID2D1Bitmap1_CopyFromMemory(p, a, b, c) (p)->lpVtbl->CopyFromMemory(p, a, b, c)
#define ID2D1Bitmap1_GetColorContext(p, a) (p)->lpVtbl->GetColorContext(p, a)
#define ID2D1Bitmap1_GetOptions(p, a) (p)->lpVtbl->GetOptions(p, a)
#define ID2D1Bitmap1_GetSurface(p, a) (p)->lpVtbl->GetSurface(p, a)
#define ID2D1Bitmap1_Map(p, a, b) (p)->lpVtbl->Map(p, a, b)
#define ID2D1Bitmap1_Unmap(p, a) (p)->lpVtbl->Unmap(p, a)

' ============================================================================
' ID2D1BitmapBrush1
' ============================================================================
Type ID2D1BitmapBrush1Vtbl As ID2D1BitmapBrush1Vtbl_
Type ID2D1BitmapBrush1
    lpVtbl As ID2D1BitmapBrush1Vtbl Ptr
End Type
Type ID2D1BitmapBrush1Vtbl_     '' Extends ID2D1BitmapBrushVtbl_
    QueryInterface As Function(ByVal This As ID2D1BitmapBrush1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1BitmapBrush1 Ptr) As ULong
    Release As Function(ByVal This As ID2D1BitmapBrush1 Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1BitmapBrush1 Ptr, ByVal factory As Any Ptr Ptr)
        ' 4. ID2D1Resource::GetFactory
    SetOpacity As Sub(ByVal This As ID2D1BitmapBrush1 Ptr, ByVal opacity As Single)
    SetTransform As Sub(ByVal This As ID2D1BitmapBrush1 Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    GetOpacity As Function(ByVal This As ID2D1BitmapBrush1 Ptr) As Single
    GetTransform As Sub(ByVal This As ID2D1BitmapBrush1 Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    SetExtendModeX As Sub(ByVal This As ID2D1BitmapBrush1 Ptr, ByVal extendModeX As D2D1_EXTEND_MODE)
    SetExtendModeY As Sub(ByVal This As ID2D1BitmapBrush1 Ptr, ByVal extendModeY As D2D1_EXTEND_MODE)
    SetInterpolationMode As Sub(ByVal This As ID2D1BitmapBrush1 Ptr, ByVal interpolationMode As D2D1_BITMAP_INTERPOLATION_MODE)
    SetBitmap As Sub(ByVal This As ID2D1BitmapBrush1 Ptr, ByVal bitmap As ID2D1Bitmap Ptr)
    GetExtendModeX As Function(ByVal This As ID2D1BitmapBrush1 Ptr) As D2D1_EXTEND_MODE
    GetExtendModeY As Function(ByVal This As ID2D1BitmapBrush1 Ptr) As D2D1_EXTEND_MODE
    GetInterpolationMode As Function(ByVal This As ID2D1BitmapBrush1 Ptr) As D2D1_BITMAP_INTERPOLATION_MODE
    GetBitmap As Sub(ByVal This As ID2D1BitmapBrush1 Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr)

        ' Erbt von ID2D1BitmapBrush
        ' Zusätzliche Methoden
    SetInterpolationMode1 As Sub(ByVal This As ID2D1BitmapBrush1 Ptr,  ByVal mode As D2D1_INTERPOLATION_MODE )
    GetInterpolationMode1 As Function(ByVal This As ID2D1BitmapBrush1 Ptr) As D2D1_INTERPOLATION_MODE
End Type
#define ID2D1BitmapBrush1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1BitmapBrush1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1BitmapBrush1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1BitmapBrush1_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1BitmapBrush1_SetOpacity(p, a) (p)->lpVtbl->SetOpacity(p, a)
#define ID2D1BitmapBrush1_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1BitmapBrush1_GetOpacity(p, a) (p)->lpVtbl->GetOpacity(p, a)
#define ID2D1BitmapBrush1_GetTransform(p, a) (p)->lpVtbl->GetTransform(p, a)
#define ID2D1BitmapBrush1_SetExtendModeX(p, a) (p)->lpVtbl->SetExtendModeX(p, a)
#define ID2D1BitmapBrush1_SetExtendModeY(p, a) (p)->lpVtbl->SetExtendModeY(p, a)
#define ID2D1BitmapBrush1_SetInterpolationMode(p, a) (p)->lpVtbl->SetInterpolationMode(p, a)
#define ID2D1BitmapBrush1_SetBitmap(p, a) (p)->lpVtbl->SetBitmap(p, a)
#define ID2D1BitmapBrush1_GetExtendModeX(p, a) (p)->lpVtbl->GetExtendModeX(p, a)
#define ID2D1BitmapBrush1_GetExtendModeY(p, a) (p)->lpVtbl->GetExtendModeY(p, a)
#define ID2D1BitmapBrush1_GetInterpolationMode(p, a) (p)->lpVtbl->GetInterpolationMode(p, a)
#define ID2D1BitmapBrush1_GetBitmap(p, a) (p)->lpVtbl->GetBitmap(p, a)
#define ID2D1BitmapBrush1_SetInterpolationMode1(p, a) (p)->lpVtbl->SetInterpolationMode1(p, a)
#define ID2D1BitmapBrush1_GetInterpolationMode1(p, a) (p)->lpVtbl->GetInterpolationMode1(p, a)

' ============================================================================
' ID2D1GradientStopCollection1
' ============================================================================
Type ID2D1GradientStopCollection1Vtbl As ID2D1GradientStopCollection1Vtbl_
Type ID2D1GradientStopCollection1
    lpVtbl As ID2D1GradientStopCollection1Vtbl Ptr
End Type
Type ID2D1GradientStopCollection1Vtbl_     '' Extends ID2D1GradientStopCollectionVtbl_
    QueryInterface As Function(ByVal This As ID2D1GradientStopCollection1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1GradientStopCollection1 Ptr) As ULong
    Release As Function(ByVal This As ID2D1GradientStopCollection1 Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1GradientStopCollection1 Ptr, ByVal factory As Any Ptr Ptr)
        ' 4. ID2D1Resource::GetFactory
    GetGradientStopCount As Function(ByVal This As ID2D1GradientStopCollection1 Ptr) As ULong
    GetGradientStops As Sub(ByVal This As ID2D1GradientStopCollection1 Ptr, ByVal gradientStops As D2D1_GRADIENT_STOP Ptr, ByVal gradientStopsCount As ULong)
    GetColorInterpolationGamma As Function(ByVal This As ID2D1GradientStopCollection1 Ptr) As D2D1_GAMMA
        ' Gibt an, wie die Farben außerhalb des [0,1] Bereichs behandelt werden
    GetExtendMode As Function(ByVal This As ID2D1GradientStopCollection1 Ptr) As D2D1_EXTEND_MODE
        ' In manchen IDL/Header Versionen: GetColorContext (D2D 1.1+)
        ' In D2D 1.0 ist Slot 9 oft die letzte Methode fur die Stop-Daten.

        ' Erbt von ID2D1GradientStopCollection
        ' Zusätzliche Methoden
    GetGradientStops1 As Sub(ByVal This As ID2D1GradientStopCollection1 Ptr,  ByVal gradient As D2D1_GRADIENT_STOP Ptr, ByVal count As ULong )
    GetPreInterpolationSpace As Function(ByVal This As ID2D1GradientStopCollection1 Ptr) As D2D1_COLOR_SPACE
    GetPostInterpolationSpace As Function(ByVal This As ID2D1GradientStopCollection1 Ptr) As D2D1_COLOR_SPACE
    GetBufferPrecision As Function(ByVal This As ID2D1GradientStopCollection1 Ptr) As D2D1_BUFFER_PRECISION
    GetColorInterpolationMode As Function(ByVal This As ID2D1GradientStopCollection1 Ptr) As D2D1_COLOR_INTERPOLATION_MODE
End Type
#define ID2D1GradientStopCollection1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1GradientStopCollection1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1GradientStopCollection1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1GradientStopCollection1_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1GradientStopCollection1_GetGradientStopCount(p, a) (p)->lpVtbl->GetGradientStopCount(p, a)
#define ID2D1GradientStopCollection1_GetGradientStops(p, a, b) (p)->lpVtbl->GetGradientStops(p, a, b)
#define ID2D1GradientStopCollection1_GetColorInterpolationGamma(p, a) (p)->lpVtbl->GetColorInterpolationGamma(p, a)
#define ID2D1GradientStopCollection1_GetExtendMode(p, a) (p)->lpVtbl->GetExtendMode(p, a)
#define ID2D1GradientStopCollection1_GetGradientStops1(p, a, b) (p)->lpVtbl->GetGradientStops1(p, a, b)
#define ID2D1GradientStopCollection1_GetPreInterpolationSpace(p, a) (p)->lpVtbl->GetPreInterpolationSpace(p, a)
#define ID2D1GradientStopCollection1_GetPostInterpolationSpace(p, a) (p)->lpVtbl->GetPostInterpolationSpace(p, a)
#define ID2D1GradientStopCollection1_GetBufferPrecision(p, a) (p)->lpVtbl->GetBufferPrecision(p, a)
#define ID2D1GradientStopCollection1_GetColorInterpolationMode(p, a) (p)->lpVtbl->GetColorInterpolationMode(p, a)

' ============================================================================
' ID2D1Device
' ============================================================================
Type ID2D1DeviceVtbl As ID2D1DeviceVtbl_
Type ID2D1Device
    lpVtbl As ID2D1DeviceVtbl Ptr
End Type
Type ID2D1DeviceVtbl_     '' Extends ID2D1ResourceVtbl_
    QueryInterface As Function(ByVal This As ID2D1Device Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Device Ptr) As ULong
    Release As Function(ByVal This As ID2D1Device Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1Device Ptr, ByVal factory As Any Ptr Ptr)

        ' 4: GetFactory
        ' 5. CreateDeviceContext
    CreateDeviceContext As Function(ByVal This As ID2D1Device Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
        ' 6. CreatePrintControl
    CreatePrintControl As Function(ByVal This As ID2D1Device Ptr,  ByVal wic_factory As Any Ptr, ByVal document_target As Any Ptr, ByVal desc As D2D1_PRINT_CONTROL_PROPERTIES Ptr, ByVal print_control As Any Ptr Ptr ) As HRESULT
        ' 7. SetMaximumTextureMemory
    SetMaximumTextureMemory As Sub(ByVal This As ID2D1Device Ptr,  ByVal max_texture_memory As ULongInt )
        ' 8. GetMaximumTextureMemory
    GetMaximumTextureMemory As Function(ByVal This As ID2D1Device Ptr) As ULongInt
        ' 9. ClearResources
    ClearResources As Function(ByVal This As ID2D1Device Ptr,  ByVal msec_since_use As ULong ) As HRESULT
End Type
#define ID2D1Device_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Device_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Device_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Device_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1Device_CreateDeviceContext(p, a, b) (p)->lpVtbl->CreateDeviceContext(p, a, b)
#define ID2D1Device_CreatePrintControl(p, a, b, c, d) (p)->lpVtbl->CreatePrintControl(p, a, b, c, d)
#define ID2D1Device_SetMaximumTextureMemory(p, a) (p)->lpVtbl->SetMaximumTextureMemory(p, a)
#define ID2D1Device_GetMaximumTextureMemory(p, a) (p)->lpVtbl->GetMaximumTextureMemory(p, a)
#define ID2D1Device_ClearResources(p, a) (p)->lpVtbl->ClearResources(p, a)

' ============================================================================
' ID2D1CommandSink
' ============================================================================
Type ID2D1CommandSinkVtbl As ID2D1CommandSinkVtbl_
Type ID2D1CommandSink
    lpVtbl As ID2D1CommandSinkVtbl Ptr
End Type
Type ID2D1CommandSinkVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As ID2D1CommandSink Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1CommandSink Ptr) As ULong
    Release As Function(ByVal This As ID2D1CommandSink Ptr) As ULong

        
    BeginDraw As Function(ByVal This As ID2D1CommandSink Ptr) As HRESULT
        ' 5. EndDraw
    EndDraw As Function(ByVal This As ID2D1CommandSink Ptr) As HRESULT
        ' 6. SetAntialiasMode
    SetAntialiasMode As Function(ByVal This As ID2D1CommandSink Ptr,  ByVal antialias_mode As D2D1_ANTIALIAS_MODE ) As HRESULT
        ' 7. SetTags
    SetTags As Function(ByVal This As ID2D1CommandSink Ptr,  ByVal tag1 As D2D1_TAG, ByVal tag2 As D2D1_TAG ) As HRESULT
        ' 8. SetTextAntialiasMode
    SetTextAntialiasMode As Function(ByVal This As ID2D1CommandSink Ptr,  ByVal antialias_mode As D2D1_TEXT_ANTIALIAS_MODE ) As HRESULT
        ' 9. SetTextRenderingParams
    SetTextRenderingParams As Function(ByVal This As ID2D1CommandSink Ptr,  ByVal text_rendering_params As Any Ptr ) As HRESULT
        ' 10. SetTransform
    SetTransform As Function(ByVal This As ID2D1CommandSink Ptr,  ByVal transform As D2D1_MATRIX_3X2_F Ptr ) As HRESULT
        ' 11. SetPrimitiveBlend
    SetPrimitiveBlend As Function(ByVal This As ID2D1CommandSink Ptr,  ByVal primitive_blend As D2D1_PRIMITIVE_BLEND ) As HRESULT
        ' 12. SetUnitMode
    SetUnitMode As Function(ByVal This As ID2D1CommandSink Ptr,  ByVal unit_mode As D2D1_UNIT_MODE ) As HRESULT
        ' 13. Clear
    Clear As Function(ByVal This As ID2D1CommandSink Ptr,  ByVal color As D2D1_COLOR_F Ptr ) As HRESULT
        ' 14. DrawGlyphRun
    DrawGlyphRun As Function(ByVal This As ID2D1CommandSink Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal glyph_run_desc As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuring_mode As ULong ) As HRESULT
        ' 15. DrawLine
    DrawLine As Function(ByVal This As ID2D1CommandSink Ptr,  ByVal p0 As D2D1_POINT_2F, ByVal p1 As D2D1_POINT_2F, ByVal brush As ID2D1Brush Ptr, ByVal stroke_width As Single, ByVal stroke_style As ID2D1StrokeStyle Ptr ) As HRESULT
        ' 16. DrawGeometry
    DrawGeometry As Function(ByVal This As ID2D1CommandSink Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal stroke_width As Single, ByVal stroke_style As ID2D1StrokeStyle Ptr ) As HRESULT
        ' 17. DrawRectangle
    DrawRectangle As Function(ByVal This As ID2D1CommandSink Ptr,  ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal stroke_width As Single, ByVal stroke_style As ID2D1StrokeStyle Ptr ) As HRESULT
        ' 18. DrawBitmap
    DrawBitmap As Function(ByVal This As ID2D1CommandSink Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE, ByVal src_rect As D2D1_RECT_F Ptr, ByVal perspective_transform As D2D1_MATRIX_4X4_F Ptr ) As HRESULT
        ' 19. DrawImage
    DrawImage As Function(ByVal This As ID2D1CommandSink Ptr,  ByVal image As ID2D1Image Ptr, ByVal target_offset As D2D1_POINT_2F Ptr, ByVal image_rect As D2D1_RECT_F Ptr, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE, ByVal composite_mode As D2D1_COMPOSITE_MODE ) As HRESULT
        ' 20. DrawGdiMetafile
    DrawGdiMetafile As Function(ByVal This As ID2D1CommandSink Ptr,  ByVal metafile As ID2D1GdiMetafile Ptr, ByVal target_offset As D2D1_POINT_2F Ptr ) As HRESULT
        ' 21. FillMesh
    FillMesh As Function(ByVal This As ID2D1CommandSink Ptr,  ByVal mesh As ID2D1Mesh Ptr, ByVal brush As ID2D1Brush Ptr ) As HRESULT
        ' 22. FillOpacityMask
    FillOpacityMask As Function(ByVal This As ID2D1CommandSink Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal src_rect As D2D1_RECT_F Ptr ) As HRESULT
        ' 23. FillGeometry
    FillGeometry As Function(ByVal This As ID2D1CommandSink Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal opacity_brush As ID2D1Brush Ptr ) As HRESULT
        ' 24. FillRectangle
    FillRectangle As Function(ByVal This As ID2D1CommandSink Ptr,  ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr ) As HRESULT
        ' 25. PushAxisAlignedClip
    PushAxisAlignedClip As Function(ByVal This As ID2D1CommandSink Ptr,  ByVal clip_rect As D2D1_RECT_F Ptr, ByVal antialias_mode As D2D1_ANTIALIAS_MODE ) As HRESULT
        ' 26. PushLayer
    PushLayer As Function(ByVal This As ID2D1CommandSink Ptr,  ByVal layer_parameters As D2D1_LAYER_PARAMETERS1 Ptr, ByVal layer As ID2D1Layer Ptr ) As HRESULT
        ' 27. PopAxisAlignedClip
    PopAxisAlignedClip As Function(ByVal This As ID2D1CommandSink Ptr) As HRESULT
        ' 28. PopLayer
    PopLayer As Function(ByVal This As ID2D1CommandSink Ptr) As HRESULT
End Type
#define ID2D1CommandSink_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1CommandSink_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1CommandSink_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1CommandSink_BeginDraw(p, a) (p)->lpVtbl->BeginDraw(p, a)
#define ID2D1CommandSink_EndDraw(p, a) (p)->lpVtbl->EndDraw(p, a)
#define ID2D1CommandSink_SetAntialiasMode(p, a) (p)->lpVtbl->SetAntialiasMode(p, a)
#define ID2D1CommandSink_SetTags(p, a, b) (p)->lpVtbl->SetTags(p, a, b)
#define ID2D1CommandSink_SetTextAntialiasMode(p, a) (p)->lpVtbl->SetTextAntialiasMode(p, a)
#define ID2D1CommandSink_SetTextRenderingParams(p, a) (p)->lpVtbl->SetTextRenderingParams(p, a)
#define ID2D1CommandSink_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1CommandSink_SetPrimitiveBlend(p, a) (p)->lpVtbl->SetPrimitiveBlend(p, a)
#define ID2D1CommandSink_SetUnitMode(p, a) (p)->lpVtbl->SetUnitMode(p, a)
#define ID2D1CommandSink_Clear(p, a) (p)->lpVtbl->Clear(p, a)
#define ID2D1CommandSink_DrawGlyphRun(p, a, b, c, d, e) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d, e)
#define ID2D1CommandSink_DrawLine(p, a, b, c, d, e) (p)->lpVtbl->DrawLine(p, a, b, c, d, e)
#define ID2D1CommandSink_DrawGeometry(p, a, b, c, d) (p)->lpVtbl->DrawGeometry(p, a, b, c, d)
#define ID2D1CommandSink_DrawRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRectangle(p, a, b, c, d)
#define ID2D1CommandSink_DrawBitmap(p, a, b, c, d, e, f) (p)->lpVtbl->DrawBitmap(p, a, b, c, d, e, f)
#define ID2D1CommandSink_DrawImage(p, a, b, c, d, e) (p)->lpVtbl->DrawImage(p, a, b, c, d, e)
#define ID2D1CommandSink_DrawGdiMetafile(p, a, b) (p)->lpVtbl->DrawGdiMetafile(p, a, b)
#define ID2D1CommandSink_FillMesh(p, a, b) (p)->lpVtbl->FillMesh(p, a, b)
#define ID2D1CommandSink_FillOpacityMask(p, a, b, c, d) (p)->lpVtbl->FillOpacityMask(p, a, b, c, d)
#define ID2D1CommandSink_FillGeometry(p, a, b, c) (p)->lpVtbl->FillGeometry(p, a, b, c)
#define ID2D1CommandSink_FillRectangle(p, a, b) (p)->lpVtbl->FillRectangle(p, a, b)
#define ID2D1CommandSink_PushAxisAlignedClip(p, a, b) (p)->lpVtbl->PushAxisAlignedClip(p, a, b)
#define ID2D1CommandSink_PushLayer(p, a, b) (p)->lpVtbl->PushLayer(p, a, b)
#define ID2D1CommandSink_PopAxisAlignedClip(p, a) (p)->lpVtbl->PopAxisAlignedClip(p, a)
#define ID2D1CommandSink_PopLayer(p, a) (p)->lpVtbl->PopLayer(p, a)

' ============================================================================
' ID2D1CommandList
' ============================================================================
Type ID2D1CommandListVtbl As ID2D1CommandListVtbl_
Type ID2D1CommandList
    lpVtbl As ID2D1CommandListVtbl Ptr
End Type
Type ID2D1CommandListVtbl_     '' Extends ID2D1ImageVtbl_
        ' Erbt von ID2D1Image
        ' Zusätzliche Methoden
    Stream As Function(ByVal This As ID2D1CommandList Ptr,  ByVal sink As ID2D1CommandSink Ptr ) As HRESULT
    Close As Function(ByVal This As ID2D1CommandList Ptr) As HRESULT
End Type
#define ID2D1CommandList_Stream(p, a) (p)->lpVtbl->Stream(p, a)
#define ID2D1CommandList_Close(p, a) (p)->lpVtbl->Close(p, a)

' ============================================================================
' ID2D1PrintControl
' ============================================================================
Type ID2D1PrintControlVtbl As ID2D1PrintControlVtbl_
Type ID2D1PrintControl
    lpVtbl As ID2D1PrintControlVtbl Ptr
End Type
Type ID2D1PrintControlVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As ID2D1PrintControl Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1PrintControl Ptr) As ULong
    Release As Function(ByVal This As ID2D1PrintControl Ptr) As ULong

        
    AddPage As Function(ByVal This As ID2D1PrintControl Ptr,  ByVal list As Any Ptr, ByVal size As D2D1_SIZE_F, ByVal stream As Any Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr ) As HRESULT
        ' 5. Close
    Close As Function(ByVal This As ID2D1PrintControl Ptr) As HRESULT
End Type
#define ID2D1PrintControl_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1PrintControl_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1PrintControl_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1PrintControl_AddPage(p, a, b, c, d, e) (p)->lpVtbl->AddPage(p, a, b, c, d, e)
#define ID2D1PrintControl_Close(p, a) (p)->lpVtbl->Close(p, a)

' ============================================================================
' ID2D1ImageBrush
' ============================================================================
Type ID2D1ImageBrushVtbl As ID2D1ImageBrushVtbl_
Type ID2D1ImageBrush
    lpVtbl As ID2D1ImageBrushVtbl Ptr
End Type
Type ID2D1ImageBrushVtbl_     '' Extends ID2D1BrushVtbl_
    QueryInterface As Function(ByVal This As ID2D1ImageBrush Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1ImageBrush Ptr) As ULong
    Release As Function(ByVal This As ID2D1ImageBrush Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1ImageBrush Ptr, ByVal factory As Any Ptr Ptr)
        ' 4. ID2D1Resource::GetFactory
    SetOpacity As Sub(ByVal This As ID2D1ImageBrush Ptr, ByVal opacity As Single)
    SetTransform As Sub(ByVal This As ID2D1ImageBrush Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    GetOpacity As Function(ByVal This As ID2D1ImageBrush Ptr) As Single
    GetTransform As Sub(ByVal This As ID2D1ImageBrush Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)

        ' Erbt von ID2D1Brush
        ' Zusätzliche Methoden
    SetImage As Sub(ByVal This As ID2D1ImageBrush Ptr,  ByVal image As ID2D1Image Ptr )
    SetExtendModeX As Sub(ByVal This As ID2D1ImageBrush Ptr,  ByVal extend_mode As D2D1_EXTEND_MODE )
    SetExtendModeY As Sub(ByVal This As ID2D1ImageBrush Ptr,  ByVal extend_mode As D2D1_EXTEND_MODE )
    SetInterpolationMode As Sub(ByVal This As ID2D1ImageBrush Ptr,  ByVal interpolation_mode As D2D1_INTERPOLATION_MODE )
    SetSourceRectangle As Sub(ByVal This As ID2D1ImageBrush Ptr,  ByVal rect As D2D1_RECT_F Ptr )
    GetImage As Sub(ByVal This As ID2D1ImageBrush Ptr,  ByVal image As Any Ptr Ptr )
    GetExtendModeX As Function(ByVal This As ID2D1ImageBrush Ptr) As D2D1_EXTEND_MODE
    GetExtendModeY As Function(ByVal This As ID2D1ImageBrush Ptr) As D2D1_EXTEND_MODE
    GetInterpolationMode As Function(ByVal This As ID2D1ImageBrush Ptr) As D2D1_INTERPOLATION_MODE
    GetSourceRectangle As Sub(ByVal This As ID2D1ImageBrush Ptr,  ByVal rect As D2D1_RECT_F Ptr )
End Type
#define ID2D1ImageBrush_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1ImageBrush_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1ImageBrush_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1ImageBrush_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1ImageBrush_SetOpacity(p, a) (p)->lpVtbl->SetOpacity(p, a)
#define ID2D1ImageBrush_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1ImageBrush_GetOpacity(p, a) (p)->lpVtbl->GetOpacity(p, a)
#define ID2D1ImageBrush_GetTransform(p, a) (p)->lpVtbl->GetTransform(p, a)
#define ID2D1ImageBrush_SetImage(p, a) (p)->lpVtbl->SetImage(p, a)
#define ID2D1ImageBrush_SetExtendModeX(p, a) (p)->lpVtbl->SetExtendModeX(p, a)
#define ID2D1ImageBrush_SetExtendModeY(p, a) (p)->lpVtbl->SetExtendModeY(p, a)
#define ID2D1ImageBrush_SetInterpolationMode(p, a) (p)->lpVtbl->SetInterpolationMode(p, a)
#define ID2D1ImageBrush_SetSourceRectangle(p, a) (p)->lpVtbl->SetSourceRectangle(p, a)
#define ID2D1ImageBrush_GetImage(p, a) (p)->lpVtbl->GetImage(p, a)
#define ID2D1ImageBrush_GetExtendModeX(p, a) (p)->lpVtbl->GetExtendModeX(p, a)
#define ID2D1ImageBrush_GetExtendModeY(p, a) (p)->lpVtbl->GetExtendModeY(p, a)
#define ID2D1ImageBrush_GetInterpolationMode(p, a) (p)->lpVtbl->GetInterpolationMode(p, a)
#define ID2D1ImageBrush_GetSourceRectangle(p, a) (p)->lpVtbl->GetSourceRectangle(p, a)

' ============================================================================
' ID2D1DeviceContext (MASSIVE Interface!)
' ============================================================================
Type ID2D1DeviceContextVtbl As ID2D1DeviceContextVtbl_
Type ID2D1DeviceContext
    lpVtbl As ID2D1DeviceContextVtbl Ptr
End Type
Type ID2D1DeviceContextVtbl_     '' Extends ID2D1RenderTargetVtbl_
    QueryInterface As Function(ByVal This As ID2D1DeviceContext Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1DeviceContext Ptr) As ULong
    Release As Function(ByVal This As ID2D1DeviceContext Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal factory As Any Ptr Ptr)
        ' 4.   (ID2D1Resource: GetFactory)
    CreateBitmap As Function(ByVal This As ID2D1DeviceContext Ptr, ByVal size As D2D1_SIZE_U, ByVal srcData As Any Ptr, ByVal pitch As ULong, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapFromWicBitmap As Function(ByVal This As ID2D1DeviceContext Ptr, ByVal wicBitmapSource As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateSharedBitmap As Function(ByVal This As ID2D1DeviceContext Ptr, ByVal riid As GUID Ptr, ByVal data As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapBrush As Function(ByVal This As ID2D1DeviceContext Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal bitmapBrushProperties As D2D1_BITMAP_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal bitmapBrush As ID2D1BitmapBrush Ptr Ptr) As HRESULT
    CreateSolidColorBrush As Function(ByVal This As ID2D1DeviceContext Ptr, ByVal color As D2D1_COLOR_F Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal solidColorBrush As ID2D1SolidColorBrush Ptr Ptr) As HRESULT
    CreateGradientStopCollection As Function(ByVal This As ID2D1DeviceContext Ptr, ByVal gradientStops As D2D1_GRADIENT_STOP Ptr, ByVal gradientStopsCount As ULong, ByVal colorInterpolationGamma As D2D1_GAMMA, ByVal extendMode As D2D1_EXTEND_MODE, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr Ptr) As HRESULT
    CreateLinearGradientBrush As Function(ByVal This As ID2D1DeviceContext Ptr, ByVal linearGradientBrushProperties As D2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal linearGradientBrush As ID2D1LinearGradientBrush Ptr Ptr) As HRESULT
    CreateRadialGradientBrush As Function(ByVal This As ID2D1DeviceContext Ptr, ByVal radialGradientBrushProperties As D2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal radialGradientBrush As ID2D1RadialGradientBrush Ptr Ptr) As HRESULT
    CreateCompatibleRenderTarget As Function(ByVal This As ID2D1DeviceContext Ptr, ByVal desiredSize As D2D1_SIZE_F Ptr, ByVal desiredPixelSize As D2D1_SIZE_U Ptr, ByVal desiredFormat As D2D1_PIXEL_FORMAT Ptr, ByVal options As ULong, ByVal bitmapRenderTarget As Any Ptr Ptr) As HRESULT 'ID2D1BitmapRenderTarget
    CreateLayer As Function(ByVal This As ID2D1DeviceContext Ptr, ByVal size As D2D1_SIZE_F Ptr, ByVal layer As ID2D1Layer Ptr Ptr) As HRESULT
    CreateMesh As Function(ByVal This As ID2D1DeviceContext Ptr, ByVal mesh As ID2D1Mesh Ptr Ptr) As HRESULT
    DrawLine As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal p0 As D2D1_POINT_2F, ByVal p1 As D2D1_POINT_2F, ByVal brush As ID2D1SolidColorBrush Ptr, ByVal strokeWidth As Single = 0, ByVal strokeStyle As ID2D1StrokeStyle Ptr = NULL)
    DrawRectangle As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRectangle As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawRoundedRectangle As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRoundedRectangle As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawEllipse As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillEllipse As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawGeometry As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillGeometry As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal opacityBrush As ID2D1Brush Ptr)
    FillMesh As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal mesh As ID2D1Mesh Ptr, ByVal brush As ID2D1Brush Ptr)
    FillOpacityMask As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal mask As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal content As D2D1_OPACITY_MASK_CONTENT, ByVal destRect As D2D1_RECT_F Ptr, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawBitmap As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal destRect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolationMode As D2D1_BITMAP_INTERPOLATION_MODE, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawText As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal text As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal layoutRect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS = 0, ByVal measuringMode As DWRITE_MEASURING_MODE = 0)
    DrawTextLayout As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal origin As D2D1_POINT_2F, ByVal layout As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS)
    DrawGlyphRun As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal baselineOrigin As D2D1_POINT_2F Ptr, ByVal glyphRun As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE)
    SetTransform As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    GetTransform As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    SetAntialiasMode As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    GetAntialiasMode As Function(ByVal This As ID2D1DeviceContext Ptr) As D2D1_ANTIALIAS_MODE
    SetTextAntialiasMode As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal antialiasMode As D2D1_TEXT_ANTIALIAS_MODE)
    GetTextAntialiasMode As Function(ByVal This As ID2D1DeviceContext Ptr) As D2D1_TEXT_ANTIALIAS_MODE
    SetTextRenderingParams As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal params As Any Ptr)
    GetTextRenderingParams As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal params As Any Ptr Ptr)
    SetTags As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal tag1 As D2D1_TAG, ByVal tag2 As D2D1_TAG)
    GetTags As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr)
    PushLayer As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal layerParams As D2D1_LAYER_PARAMETERS Ptr, ByVal layer As ID2D1Layer Ptr)
    PopLayer As Sub(ByVal This As ID2D1DeviceContext Ptr)
    Flush As Function(ByVal This As ID2D1DeviceContext Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    SaveDrawingState As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal stateBlock As Any Ptr)
    RestoreDrawingState As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal stateBlock As Any Ptr)
    PushAxisAlignedClip As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    PopAxisAlignedClip As Sub(ByVal This As ID2D1DeviceContext Ptr)
    Clear As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal col As D2D1_COLOR_F Ptr)
    BeginDraw As Sub(ByVal This As ID2D1DeviceContext Ptr)
    EndDraw As Function(ByVal This As ID2D1DeviceContext Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    GetPixelFormat As Function(ByVal This As ID2D1DeviceContext Ptr) As D2D1_PIXEL_FORMAT
    SetDpi As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal dpiX As Single, ByVal dpiY As Single)
    GetDpi As Sub(ByVal This As ID2D1DeviceContext Ptr, ByVal dpiX As Single Ptr, ByVal dpiY As Single Ptr)
    GetSize As Function(ByVal This As ID2D1DeviceContext Ptr, ByVal size As Any Ptr) As D2D1_SIZE_F
    GetPixelSize As Function(ByVal This As ID2D1DeviceContext Ptr, ByVal pixelSize As Any Ptr) As D2D1_SIZE_U
    GetMaximumBitmapSize As Function(ByVal This As ID2D1DeviceContext Ptr) As ULong
    IsSupported As Function(ByVal This As ID2D1DeviceContext Ptr, ByVal renderTargetProperties As D2D1_RENDER_TARGET_PROPERTIES Ptr) As BOOL

        ' Erbt alle Methoden von ID2D1RenderTarget (1-57)
    	' 58. CreateBitmap (überladen)
    CreateBitmap1 As Function(ByVal This As ID2D1DeviceContext Ptr,  ByVal size As D2D1_SIZE_U, ByVal src_data As Any Ptr, ByVal pitch As ULong, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As Any Ptr Ptr ) As HRESULT
    	' 59. CreateBitmapFromWicBitmap (überladen)
    CreateBitmapFromWicBitmap1 As Function(ByVal This As ID2D1DeviceContext Ptr,  ByVal bitmap_source As IUnknownBase Ptr, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As ID2D1Bitmap1 Ptr Ptr ) As HRESULT
    	' 60. CreateColorContext
    CreateColorContext As Function(ByVal This As ID2D1DeviceContext Ptr,  ByVal space As D2D1_COLOR_SPACE, ByVal profile As UByte Ptr, ByVal profile_size As ULong, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 61. CreateColorContextFromFilename
    CreateColorContextFromFilename As Function(ByVal This As ID2D1DeviceContext Ptr,  ByVal filename As WString Ptr, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 62. CreateColorContextFromWicColorContext
    CreateColorContextFromWicColorContext As Function(ByVal This As ID2D1DeviceContext Ptr,  ByVal wic_color_context As Any Ptr, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 63. CreateBitmapFromDxgiSurface
    CreateBitmapFromDxgiSurface As Function(ByVal This As ID2D1DeviceContext Ptr,  ByVal surface As Any Ptr, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As Any Ptr Ptr ) As HRESULT
    	' 64. CreateEffect
    CreateEffect As Function(ByVal This As ID2D1DeviceContext Ptr,  ByRef effect_id As GUID, ByVal effect As ID2D1Effect Ptr Ptr ) As HRESULT
    	' 65. CreateGradientStopCollection (überladen)
    CreateGradientStopCollection1 As Function(ByVal This As ID2D1DeviceContext Ptr,  ByVal stops As D2D1_GRADIENT_STOP Ptr, ByVal stop_count As ULong, ByVal preinterpolation_space As D2D1_COLOR_SPACE, ByVal postinterpolation_space As D2D1_COLOR_SPACE, ByVal buffer_precision As D2D1_BUFFER_PRECISION, ByVal extend_mode As D2D1_EXTEND_MODE, ByVal color_interpolation_mode As D2D1_COLOR_INTERPOLATION_MODE, ByVal gradient As Any Ptr Ptr ) As HRESULT
    	' 66. CreateImageBrush
    CreateImageBrush As Function(ByVal This As ID2D1DeviceContext Ptr,  ByVal image As ID2D1Image Ptr, ByVal image_brush_desc As D2D1_IMAGE_BRUSH_PROPERTIES Ptr, ByVal brush_desc As D2D1_BRUSH_PROPERTIES Ptr, ByVal brush As Any Ptr Ptr ) As HRESULT
    	' 67. CreateBitmapBrush (überladen)
    CreateBitmapBrush1 As Function(ByVal This As ID2D1DeviceContext Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal bitmap_brush_desc As D2D1_BITMAP_BRUSH_PROPERTIES1 Ptr, ByVal brush_desc As D2D1_BRUSH_PROPERTIES Ptr, ByVal bitmap_brush As Any Ptr Ptr ) As HRESULT
    	' 68. CreateCommandList
    CreateCommandList As Function(ByVal This As ID2D1DeviceContext Ptr,  ByVal command_list As Any Ptr Ptr ) As HRESULT
    	' 69. IsDxgiFormatSupported
    IsDxgiFormatSupported As Function(ByVal This As ID2D1DeviceContext Ptr,  ByVal format As ULong ) As Long
    	' 70. IsBufferPrecisionSupported
    IsBufferPrecisionSupported As Function(ByVal This As ID2D1DeviceContext Ptr,  ByVal buffer_precision As D2D1_BUFFER_PRECISION ) As Long
    	' 71. GetImageLocalBounds
    GetImageLocalBounds As Function(ByVal This As ID2D1DeviceContext Ptr,  ByVal image As ID2D1Image Ptr, ByVal local_bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 72. GetImageWorldBounds
    GetImageWorldBounds As Function(ByVal This As ID2D1DeviceContext Ptr,  ByVal image As ID2D1Image Ptr, ByVal world_bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 73. GetGlyphRunWorldBounds
    GetGlyphRunWorldBounds As Function(ByVal This As ID2D1DeviceContext Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal measuring_mode As ULong, ByVal bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 74. GetDevice
    GetDevice As Sub(ByVal This As ID2D1DeviceContext Ptr,  ByVal device As Any Ptr Ptr )
    	' 75. SetTarget
    SetTarget As Sub(ByVal This As ID2D1DeviceContext Ptr,  ByVal target As ID2D1Image Ptr )
    	' 76. GetTarget
    GetTarget As Sub(ByVal This As ID2D1DeviceContext Ptr,  ByVal target As Any Ptr Ptr )
    	' 77. SetRenderingControls
    SetRenderingControls As Sub(ByVal This As ID2D1DeviceContext Ptr,  ByVal rendering_controls As D2D1_RENDERING_CONTROLS Ptr )
    	' 78. GetRenderingControls
    GetRenderingControls As Sub(ByVal This As ID2D1DeviceContext Ptr,  ByVal rendering_controls As D2D1_RENDERING_CONTROLS Ptr )
    	' 79. SetPrimitiveBlend
    SetPrimitiveBlend As Sub(ByVal This As ID2D1DeviceContext Ptr,  ByVal primitive_blend As D2D1_PRIMITIVE_BLEND )
    	' 80. GetPrimitiveBlend
    GetPrimitiveBlend As Function(ByVal This As ID2D1DeviceContext Ptr) As D2D1_PRIMITIVE_BLEND
    	' 81. SetUnitMode
    SetUnitMode As Sub(ByVal This As ID2D1DeviceContext Ptr,  ByVal unit_mode As D2D1_UNIT_MODE )
    	' 82. GetUnitMode
    GetUnitMode As Function(ByVal This As ID2D1DeviceContext Ptr) As D2D1_UNIT_MODE
    	' 83. DrawGlyphRun (überladen)
    DrawGlyphRun1 As Sub(ByVal This As ID2D1DeviceContext Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal glyph_run_desc As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuring_mode As ULong )
    	' 84. DrawImage
    DrawImage As Sub(ByVal This As ID2D1DeviceContext Ptr,  ByVal image As ID2D1Image Ptr, ByVal target_offset As D2D1_POINT_2F Ptr = 0, ByVal image_rect As D2D1_RECT_F Ptr = 0, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR, ByVal composite_mode As D2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER )
    	' 85. DrawGdiMetafile
    DrawGdiMetafile As Sub(ByVal This As ID2D1DeviceContext Ptr,  ByVal metafile As ID2D1GdiMetafile Ptr, ByVal target_offset As D2D1_POINT_2F Ptr )
    	' 86. DrawBitmap (überladen)
    DrawBitmap1 As Sub(ByVal This As ID2D1DeviceContext Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE, ByVal src_rect As D2D1_RECT_F Ptr, ByVal perspective_transform As D2D1_MATRIX_4X4_F Ptr )
    	' 87. InvalidateEffectInputRectangle
    InvalidateEffectInputRectangle As Function(ByVal This As ID2D1DeviceContext Ptr,  ByVal effect As Any Ptr, ByVal input As ULong, ByVal input_rect As D2D1_RECT_F Ptr ) As HRESULT
    	' 88. GetEffectInvalidRectangleCount
    GetEffectInvalidRectangleCount As Function(ByVal This As ID2D1DeviceContext Ptr,  ByVal effect As Any Ptr, ByVal rect_count As ULong Ptr ) As HRESULT
    	' 89. GetEffectInvalidRectangles
    GetEffectInvalidRectangles As Function(ByVal This As ID2D1DeviceContext Ptr,  ByVal effect As Any Ptr, ByVal rectangles As D2D1_RECT_F Ptr, ByVal rect_count As ULong ) As HRESULT
    	' 90. GetEffectRequiredInputRectangles
    GetEffectRequiredInputRectangles As Function(ByVal This As ID2D1DeviceContext Ptr,  ByVal effect As Any Ptr, ByVal image_rect As D2D1_RECT_F Ptr, ByVal desc As D2D1_EFFECT_INPUT_DESCRIPTION Ptr, ByVal input_rects As D2D1_RECT_F Ptr, ByVal input_count As ULong ) As HRESULT
    	' 91. FillOpacityMask (überladen)
    FillOpacityMask1 As Sub(ByVal This As ID2D1DeviceContext Ptr,  ByVal mask As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal content As D2D1_OPACITY_MASK_CONTENT, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal src_rect As D2D1_RECT_F Ptr )
    	' 92. PushLayer
    PushLayer1 As Sub(ByVal This As ID2D1DeviceContext Ptr,  ByVal layer_parameters As D2D1_LAYER_PARAMETERS1 Ptr, ByVal layer As ID2D1Layer Ptr )
End Type
#define ID2D1DeviceContext_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1DeviceContext_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1DeviceContext_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1DeviceContext_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1DeviceContext_CreateBitmap(p, a, b, c, d, e) (p)->lpVtbl->CreateBitmap(p, a, b, c, d, e)
#define ID2D1DeviceContext_CreateBitmapFromWicBitmap(p, a, b, c) (p)->lpVtbl->CreateBitmapFromWicBitmap(p, a, b, c)
#define ID2D1DeviceContext_CreateSharedBitmap(p, a, b, c, d) (p)->lpVtbl->CreateSharedBitmap(p, a, b, c, d)
#define ID2D1DeviceContext_CreateBitmapBrush(p, a, b, c, d) (p)->lpVtbl->CreateBitmapBrush(p, a, b, c, d)
#define ID2D1DeviceContext_CreateSolidColorBrush(p, a, b, c) (p)->lpVtbl->CreateSolidColorBrush(p, a, b, c)
#define ID2D1DeviceContext_CreateGradientStopCollection(p, a, b, c, d, e) (p)->lpVtbl->CreateGradientStopCollection(p, a, b, c, d, e)
#define ID2D1DeviceContext_CreateLinearGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateLinearGradientBrush(p, a, b, c, d)
#define ID2D1DeviceContext_CreateRadialGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateRadialGradientBrush(p, a, b, c, d)
#define ID2D1DeviceContext_CreateCompatibleRenderTarget(p, a, b, c, d, e) (p)->lpVtbl->CreateCompatibleRenderTarget(p, a, b, c, d, e)
#define ID2D1DeviceContext_CreateLayer(p, a, b) (p)->lpVtbl->CreateLayer(p, a, b)
#define ID2D1DeviceContext_CreateMesh(p, a) (p)->lpVtbl->CreateMesh(p, a)
#define ID2D1DeviceContext_DrawLine(p, a, b, c, d, e) (p)->lpVtbl->DrawLine(p, a, b, c, d, e)
#define ID2D1DeviceContext_DrawRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRectangle(p, a, b, c, d)
#define ID2D1DeviceContext_FillRectangle(p, a, b) (p)->lpVtbl->FillRectangle(p, a, b)
#define ID2D1DeviceContext_DrawRoundedRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRoundedRectangle(p, a, b, c, d)
#define ID2D1DeviceContext_FillRoundedRectangle(p, a, b) (p)->lpVtbl->FillRoundedRectangle(p, a, b)
#define ID2D1DeviceContext_DrawEllipse(p, a, b, c, d) (p)->lpVtbl->DrawEllipse(p, a, b, c, d)
#define ID2D1DeviceContext_FillEllipse(p, a, b) (p)->lpVtbl->FillEllipse(p, a, b)
#define ID2D1DeviceContext_DrawGeometry(p, a, b, c, d) (p)->lpVtbl->DrawGeometry(p, a, b, c, d)
#define ID2D1DeviceContext_FillGeometry(p, a, b, c) (p)->lpVtbl->FillGeometry(p, a, b, c)
#define ID2D1DeviceContext_FillMesh(p, a, b) (p)->lpVtbl->FillMesh(p, a, b)
#define ID2D1DeviceContext_FillOpacityMask(p, a, b, c, d, e) (p)->lpVtbl->FillOpacityMask(p, a, b, c, d, e)
#define ID2D1DeviceContext_DrawBitmap(p, a, b, c, d, e) (p)->lpVtbl->DrawBitmap(p, a, b, c, d, e)
#define ID2D1DeviceContext_DrawText(p, a, b, c, d, e, f, g) (p)->lpVtbl->DrawText(p, a, b, c, d, e, f, g)
#define ID2D1DeviceContext_DrawTextLayout(p, a, b, c, d) (p)->lpVtbl->DrawTextLayout(p, a, b, c, d)
#define ID2D1DeviceContext_DrawGlyphRun(p, a, b, c, d) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d)
#define ID2D1DeviceContext_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1DeviceContext_GetTransform(p, a) (p)->lpVtbl->GetTransform(p, a)
#define ID2D1DeviceContext_SetAntialiasMode(p, a) (p)->lpVtbl->SetAntialiasMode(p, a)
#define ID2D1DeviceContext_GetAntialiasMode(p, a) (p)->lpVtbl->GetAntialiasMode(p, a)
#define ID2D1DeviceContext_SetTextAntialiasMode(p, a) (p)->lpVtbl->SetTextAntialiasMode(p, a)
#define ID2D1DeviceContext_GetTextAntialiasMode(p, a) (p)->lpVtbl->GetTextAntialiasMode(p, a)
#define ID2D1DeviceContext_SetTextRenderingParams(p, a) (p)->lpVtbl->SetTextRenderingParams(p, a)
#define ID2D1DeviceContext_GetTextRenderingParams(p, a) (p)->lpVtbl->GetTextRenderingParams(p, a)
#define ID2D1DeviceContext_SetTags(p, a, b) (p)->lpVtbl->SetTags(p, a, b)
#define ID2D1DeviceContext_GetTags(p, a, b) (p)->lpVtbl->GetTags(p, a, b)
#define ID2D1DeviceContext_PushLayer(p, a, b) (p)->lpVtbl->PushLayer(p, a, b)
#define ID2D1DeviceContext_PopLayer(p, a) (p)->lpVtbl->PopLayer(p, a)
#define ID2D1DeviceContext_Flush(p, a, b) (p)->lpVtbl->Flush(p, a, b)
#define ID2D1DeviceContext_SaveDrawingState(p, a) (p)->lpVtbl->SaveDrawingState(p, a)
#define ID2D1DeviceContext_RestoreDrawingState(p, a) (p)->lpVtbl->RestoreDrawingState(p, a)
#define ID2D1DeviceContext_PushAxisAlignedClip(p, a, b) (p)->lpVtbl->PushAxisAlignedClip(p, a, b)
#define ID2D1DeviceContext_PopAxisAlignedClip(p, a) (p)->lpVtbl->PopAxisAlignedClip(p, a)
#define ID2D1DeviceContext_Clear(p, a) (p)->lpVtbl->Clear(p, a)
#define ID2D1DeviceContext_BeginDraw(p, a) (p)->lpVtbl->BeginDraw(p, a)
#define ID2D1DeviceContext_EndDraw(p, a, b) (p)->lpVtbl->EndDraw(p, a, b)
#define ID2D1DeviceContext_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)
#define ID2D1DeviceContext_SetDpi(p, a, b) (p)->lpVtbl->SetDpi(p, a, b)
#define ID2D1DeviceContext_GetDpi(p, a, b) (p)->lpVtbl->GetDpi(p, a, b)
#define ID2D1DeviceContext_GetSize(p, a) (p)->lpVtbl->GetSize(p, a)
#define ID2D1DeviceContext_GetPixelSize(p, a) (p)->lpVtbl->GetPixelSize(p, a)
#define ID2D1DeviceContext_GetMaximumBitmapSize(p, a) (p)->lpVtbl->GetMaximumBitmapSize(p, a)
#define ID2D1DeviceContext_IsSupported(p, a) (p)->lpVtbl->IsSupported(p, a)
#define ID2D1DeviceContext_CreateBitmap1(p, a, b, c, d, e) (p)->lpVtbl->CreateBitmap1(p, a, b, c, d, e)
#define ID2D1DeviceContext_CreateBitmapFromWicBitmap1(p, a, b, c) (p)->lpVtbl->CreateBitmapFromWicBitmap1(p, a, b, c)
#define ID2D1DeviceContext_CreateColorContext(p, a, b, c, d) (p)->lpVtbl->CreateColorContext(p, a, b, c, d)
#define ID2D1DeviceContext_CreateColorContextFromFilename(p, a, b) (p)->lpVtbl->CreateColorContextFromFilename(p, a, b)
#define ID2D1DeviceContext_CreateColorContextFromWicColorContext(p, a, b) (p)->lpVtbl->CreateColorContextFromWicColorContext(p, a, b)
#define ID2D1DeviceContext_CreateBitmapFromDxgiSurface(p, a, b, c) (p)->lpVtbl->CreateBitmapFromDxgiSurface(p, a, b, c)
#define ID2D1DeviceContext_CreateEffect(p, a, b) (p)->lpVtbl->CreateEffect(p, a, b)
#define ID2D1DeviceContext_CreateGradientStopCollection1(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateGradientStopCollection1(p, a, b, c, d, e, f, g, h)
#define ID2D1DeviceContext_CreateImageBrush(p, a, b, c, d) (p)->lpVtbl->CreateImageBrush(p, a, b, c, d)
#define ID2D1DeviceContext_CreateBitmapBrush1(p, a, b, c, d) (p)->lpVtbl->CreateBitmapBrush1(p, a, b, c, d)
#define ID2D1DeviceContext_CreateCommandList(p, a) (p)->lpVtbl->CreateCommandList(p, a)
#define ID2D1DeviceContext_IsDxgiFormatSupported(p, a) (p)->lpVtbl->IsDxgiFormatSupported(p, a)
#define ID2D1DeviceContext_IsBufferPrecisionSupported(p, a) (p)->lpVtbl->IsBufferPrecisionSupported(p, a)
#define ID2D1DeviceContext_GetImageLocalBounds(p, a, b) (p)->lpVtbl->GetImageLocalBounds(p, a, b)
#define ID2D1DeviceContext_GetImageWorldBounds(p, a, b) (p)->lpVtbl->GetImageWorldBounds(p, a, b)
#define ID2D1DeviceContext_GetGlyphRunWorldBounds(p, a, b, c, d) (p)->lpVtbl->GetGlyphRunWorldBounds(p, a, b, c, d)
#define ID2D1DeviceContext_GetDevice(p, a) (p)->lpVtbl->GetDevice(p, a)
#define ID2D1DeviceContext_SetTarget(p, a) (p)->lpVtbl->SetTarget(p, a)
#define ID2D1DeviceContext_GetTarget(p, a) (p)->lpVtbl->GetTarget(p, a)
#define ID2D1DeviceContext_SetRenderingControls(p, a) (p)->lpVtbl->SetRenderingControls(p, a)
#define ID2D1DeviceContext_GetRenderingControls(p, a) (p)->lpVtbl->GetRenderingControls(p, a)
#define ID2D1DeviceContext_SetPrimitiveBlend(p, a) (p)->lpVtbl->SetPrimitiveBlend(p, a)
#define ID2D1DeviceContext_GetPrimitiveBlend(p, a) (p)->lpVtbl->GetPrimitiveBlend(p, a)
#define ID2D1DeviceContext_SetUnitMode(p, a) (p)->lpVtbl->SetUnitMode(p, a)
#define ID2D1DeviceContext_GetUnitMode(p, a) (p)->lpVtbl->GetUnitMode(p, a)
#define ID2D1DeviceContext_DrawGlyphRun1(p, a, b, c, d, e) (p)->lpVtbl->DrawGlyphRun1(p, a, b, c, d, e)
#define ID2D1DeviceContext_DrawImage(p, a, b, c, d, e) (p)->lpVtbl->DrawImage(p, a, b, c, d, e)
#define ID2D1DeviceContext_DrawGdiMetafile(p, a, b) (p)->lpVtbl->DrawGdiMetafile(p, a, b)
#define ID2D1DeviceContext_DrawBitmap1(p, a, b, c, d, e, f) (p)->lpVtbl->DrawBitmap1(p, a, b, c, d, e, f)
#define ID2D1DeviceContext_InvalidateEffectInputRectangle(p, a, b, c) (p)->lpVtbl->InvalidateEffectInputRectangle(p, a, b, c)
#define ID2D1DeviceContext_GetEffectInvalidRectangleCount(p, a, b) (p)->lpVtbl->GetEffectInvalidRectangleCount(p, a, b)
#define ID2D1DeviceContext_GetEffectInvalidRectangles(p, a, b, c) (p)->lpVtbl->GetEffectInvalidRectangles(p, a, b, c)
#define ID2D1DeviceContext_GetEffectRequiredInputRectangles(p, a, b, c, d, e) (p)->lpVtbl->GetEffectRequiredInputRectangles(p, a, b, c, d, e)
#define ID2D1DeviceContext_FillOpacityMask1(p, a, b, c, d, e) (p)->lpVtbl->FillOpacityMask1(p, a, b, c, d, e)
#define ID2D1DeviceContext_PushLayer1(p, a, b) (p)->lpVtbl->PushLayer1(p, a, b)

' ============================================================================
' ID2D1StrokeStyle1
' ============================================================================
Type ID2D1StrokeStyle1Vtbl As ID2D1StrokeStyle1Vtbl_
Type ID2D1StrokeStyle1
    lpVtbl As ID2D1StrokeStyle1Vtbl Ptr
End Type
Type ID2D1StrokeStyle1Vtbl_     '' Extends ID2D1StrokeStyleVtbl_
    QueryInterface As Function(ByVal This As ID2D1StrokeStyle1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1StrokeStyle1 Ptr) As ULong
    Release As Function(ByVal This As ID2D1StrokeStyle1 Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1StrokeStyle1 Ptr, ByVal factory As Any Ptr Ptr)
    GetStartCap As Function(ByVal This As ID2D1StrokeStyle1 Ptr) As D2D1_CAP_STYLE
    GetEndCap As Function(ByVal This As ID2D1StrokeStyle1 Ptr) As D2D1_CAP_STYLE
    GetDashCap As Function(ByVal This As ID2D1StrokeStyle1 Ptr) As D2D1_CAP_STYLE
    GetMiterLimit As Function(ByVal This As ID2D1StrokeStyle1 Ptr) As Single
    GetLineJoin As Function(ByVal This As ID2D1StrokeStyle1 Ptr) As D2D1_LINE_JOIN
    GetDashOffset As Function(ByVal This As ID2D1StrokeStyle1 Ptr) As Single
    GetDashStyle As Function(ByVal This As ID2D1StrokeStyle1 Ptr) As D2D1_DASH_STYLE
    GetDashesCount As Function(ByVal This As ID2D1StrokeStyle1 Ptr) As ULong
    GetDashes As Sub(ByVal This As ID2D1StrokeStyle1 Ptr, ByVal dashes As Single Ptr, ByVal dashesCount As ULong)

    	' Erbt von ID2D1StrokeStyle
    	' Zusätzliche Methode
    GetStrokeTransformType As Function(ByVal This As ID2D1StrokeStyle1 Ptr) As D2D1_STROKE_TRANSFORM_TYPE
End Type
#define ID2D1StrokeStyle1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1StrokeStyle1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1StrokeStyle1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1StrokeStyle1_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1StrokeStyle1_GetStartCap(p, a) (p)->lpVtbl->GetStartCap(p, a)
#define ID2D1StrokeStyle1_GetEndCap(p, a) (p)->lpVtbl->GetEndCap(p, a)
#define ID2D1StrokeStyle1_GetDashCap(p, a) (p)->lpVtbl->GetDashCap(p, a)
#define ID2D1StrokeStyle1_GetMiterLimit(p, a) (p)->lpVtbl->GetMiterLimit(p, a)
#define ID2D1StrokeStyle1_GetLineJoin(p, a) (p)->lpVtbl->GetLineJoin(p, a)
#define ID2D1StrokeStyle1_GetDashOffset(p, a) (p)->lpVtbl->GetDashOffset(p, a)
#define ID2D1StrokeStyle1_GetDashStyle(p, a) (p)->lpVtbl->GetDashStyle(p, a)
#define ID2D1StrokeStyle1_GetDashesCount(p, a) (p)->lpVtbl->GetDashesCount(p, a)
#define ID2D1StrokeStyle1_GetDashes(p, a, b) (p)->lpVtbl->GetDashes(p, a, b)
#define ID2D1StrokeStyle1_GetStrokeTransformType(p, a) (p)->lpVtbl->GetStrokeTransformType(p, a)

' ============================================================================
' ID2D1Factory1
' ============================================================================
Type ID2D1Factory1Vtbl As ID2D1Factory1Vtbl_
Type ID2D1Factory1
    lpVtbl As ID2D1Factory1Vtbl Ptr
End Type
Type ID2D1Factory1Vtbl_     '' Extends ID2D1FactoryVtbl_
    QueryInterface As Function(ByVal This As ID2D1Factory1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Factory1 Ptr) As ULong
    Release As Function(ByVal This As ID2D1Factory1 Ptr) As ULong
        ' 2. AddRef
        ' 4.
    ReloadSystemMetrics As Function(ByVal This As ID2D1Factory1 Ptr) As HRESULT
    GetDesktopDpi As Sub(ByVal This As ID2D1Factory1 Ptr, ByVal dpiX As Single Ptr, ByVal dpiY As Single Ptr)
    CreateRectangleGeometry As Function(ByVal This As ID2D1Factory1 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal geometry As ID2D1RectangleGeometry Ptr Ptr) As HRESULT
    CreateRoundedRectangleGeometry As Function(ByVal This As ID2D1Factory1 Ptr, ByVal rect As D2D1_ROUNDED_RECT Ptr, ByVal geometry As ID2D1RoundedRectangleGeometry Ptr Ptr) As HRESULT
    CreateEllipseGeometry As Function(ByVal This As ID2D1Factory1 Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal ID2D1EllipseGeometry As Any Ptr Ptr) As HRESULT
    CreateGeometryGroup As Function(ByVal This As ID2D1Factory1 Ptr, ByVal fill_mode As D2D1_FILL_MODE, ByVal geometries As ID2D1Geometry Ptr Ptr, ByVal geometryCount As ULong, ByVal group As ID2D1GeometryGroup Ptr Ptr) As HRESULT
    CreateTransformedGeometry As Function(ByVal This As ID2D1Factory1 Ptr, ByVal src_geometry As ID2D1Geometry Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr, ByVal transformedGeometry As ID2D1TransformedGeometry Ptr Ptr) As HRESULT
    CreatePathGeometry As Function(ByVal This As ID2D1Factory1 Ptr, ByVal geometry As ID2D1PathGeometry Ptr Ptr) As HRESULT
    CreateStrokeStyle As Function(ByVal This As ID2D1Factory1 Ptr, ByVal styleProps As D2D1_STROKE_STYLE_PROPERTIES Ptr, ByVal dashes As Single Ptr, ByVal dashCount As ULong, ByVal strokeStyle As ID2D1StrokeStyle Ptr Ptr) As HRESULT
    CreateDrawingStateBlock As Function(ByVal This As ID2D1Factory1 Ptr, ByVal stateDesc As D2D1_DRAWING_STATE_DESCRIPTION Ptr, ByVal text_renderingParams As Any Ptr, ByVal stateBlock As IUnknownBase Ptr Ptr) As HRESULT ' ID2D1DrawingStateBlock
    CreateWicBitmapRenderTarget As Function(ByVal This As ID2D1Factory1 Ptr, ByVal target As Any Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1RenderTarget Ptr Ptr) As HRESULT
    CreateHwndRenderTarget As Function(ByVal This As ID2D1Factory1 Ptr, ByVal desc As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal targetProps As D2D1_HWND_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1HwndRenderTarget Ptr Ptr) As HRESULT
    CreateDxgiSurfaceRenderTarget As Function(ByVal This As ID2D1Factory1 Ptr, ByVal surface As Any Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1RenderTarget Ptr Ptr) As HRESULT
    CreateDCRenderTarget As Function(ByVal This As ID2D1Factory1 Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1DCRenderTarget Ptr Ptr) As HRESULT

    	' Erbt von ID2D1Factory (1-17 Methoden)
    	' 18. CreateDevice
    CreateDevice As Function(ByVal This As ID2D1Factory1 Ptr,  ByVal dxgi_device As Any Ptr, ByVal device As ID2D1Device Ptr Ptr ) As HRESULT
    	' 19. CreateStrokeStyle (überladen)
    CreateStrokeStyle1 As Function(ByVal This As ID2D1Factory1 Ptr,  ByVal desc As D2D1_STROKE_STYLE_PROPERTIES1 Ptr, ByVal dashes As Single Ptr, ByVal dash_count As ULong, ByVal stroke_style As Any Ptr Ptr ) As HRESULT
    	' 20. CreatePathGeometry (überladen)
    CreatePathGeometry1 As Function(ByVal This As ID2D1Factory1 Ptr,  ByVal geometry As Any Ptr Ptr ) As HRESULT
    	' 21. CreateDrawingStateBlock (überladen)
    CreateDrawingStateBlock1 As Function(ByVal This As ID2D1Factory1 Ptr,  ByVal desc As D2D1_DRAWING_STATE_DESCRIPTION1 Ptr, ByVal text_rendering_params As Any Ptr, ByVal state_block As Any Ptr Ptr ) As HRESULT
    	' 22. CreateGdiMetafile
    CreateGdiMetafile As Function(ByVal This As ID2D1Factory1 Ptr,  ByVal stream As Any Ptr, ByVal metafile As Any Ptr Ptr ) As HRESULT
    	' 23. RegisterEffectFromStream
    RegisterEffectFromStream As Function(ByVal This As ID2D1Factory1 Ptr,  ByRef effect_id As GUID, ByVal property_xml As Any Ptr, ByVal bindings As Any Ptr, ByVal binding_count As ULong, ByVal effect_factory As PD2D1_EFFECT_FACTORY Ptr ) As HRESULT
    	' 24. RegisterEffectFromString
    RegisterEffectFromString As Function(ByVal This As ID2D1Factory1 Ptr,  ByVal effect_id As GUID, ByVal property_xml As WString Ptr, ByVal bindings As Any Ptr, ByVal binding_count As ULong, ByVal effect_factory As PD2D1_EFFECT_FACTORY Ptr ) As HRESULT
    	' 25. UnregisterEffect
    UnregisterEffect As Function(ByVal This As ID2D1Factory1 Ptr,  ByRef effect_id As GUID ) As HRESULT
    	' 26. GetRegisteredEffects
    GetRegisteredEffects As Function(ByVal This As ID2D1Factory1 Ptr,  ByVal effects As GUID Ptr, ByVal effect_count As ULong, ByVal returned As ULong Ptr, ByVal registered As ULong Ptr ) As HRESULT
    	' 27. GetEffectProperties
    GetEffectProperties As Function(ByVal This As ID2D1Factory1 Ptr,  ByRef effect_id As GUID, ByVal props As Any Ptr Ptr ) As HRESULT
End Type
#define ID2D1Factory1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Factory1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Factory1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Factory1_ReloadSystemMetrics(p, a) (p)->lpVtbl->ReloadSystemMetrics(p, a)
#define ID2D1Factory1_GetDesktopDpi(p, a, b) (p)->lpVtbl->GetDesktopDpi(p, a, b)
#define ID2D1Factory1_CreateRectangleGeometry(p, a, b) (p)->lpVtbl->CreateRectangleGeometry(p, a, b)
#define ID2D1Factory1_CreateRoundedRectangleGeometry(p, a, b) (p)->lpVtbl->CreateRoundedRectangleGeometry(p, a, b)
#define ID2D1Factory1_CreateEllipseGeometry(p, a, b) (p)->lpVtbl->CreateEllipseGeometry(p, a, b)
#define ID2D1Factory1_CreateGeometryGroup(p, a, b, c, d) (p)->lpVtbl->CreateGeometryGroup(p, a, b, c, d)
#define ID2D1Factory1_CreateTransformedGeometry(p, a, b, c) (p)->lpVtbl->CreateTransformedGeometry(p, a, b, c)
#define ID2D1Factory1_CreatePathGeometry(p, a) (p)->lpVtbl->CreatePathGeometry(p, a)
#define ID2D1Factory1_CreateStrokeStyle(p, a, b, c, d) (p)->lpVtbl->CreateStrokeStyle(p, a, b, c, d)
#define ID2D1Factory1_CreateDrawingStateBlock(p, a, b, c) (p)->lpVtbl->CreateDrawingStateBlock(p, a, b, c)
#define ID2D1Factory1_CreateWicBitmapRenderTarget(p, a, b, c) (p)->lpVtbl->CreateWicBitmapRenderTarget(p, a, b, c)
#define ID2D1Factory1_CreateHwndRenderTarget(p, a, b, c) (p)->lpVtbl->CreateHwndRenderTarget(p, a, b, c)
#define ID2D1Factory1_CreateDxgiSurfaceRenderTarget(p, a, b, c) (p)->lpVtbl->CreateDxgiSurfaceRenderTarget(p, a, b, c)
#define ID2D1Factory1_CreateDCRenderTarget(p, a, b) (p)->lpVtbl->CreateDCRenderTarget(p, a, b)
#define ID2D1Factory1_CreateDevice(p, a, b) (p)->lpVtbl->CreateDevice(p, a, b)
#define ID2D1Factory1_CreateStrokeStyle1(p, a, b, c, d) (p)->lpVtbl->CreateStrokeStyle1(p, a, b, c, d)
#define ID2D1Factory1_CreatePathGeometry1(p, a) (p)->lpVtbl->CreatePathGeometry1(p, a)
#define ID2D1Factory1_CreateDrawingStateBlock1(p, a, b, c) (p)->lpVtbl->CreateDrawingStateBlock1(p, a, b, c)
#define ID2D1Factory1_CreateGdiMetafile(p, a, b) (p)->lpVtbl->CreateGdiMetafile(p, a, b)
#define ID2D1Factory1_RegisterEffectFromStream(p, a, b, c, d, e) (p)->lpVtbl->RegisterEffectFromStream(p, a, b, c, d, e)
#define ID2D1Factory1_RegisterEffectFromString(p, a, b, c, d, e) (p)->lpVtbl->RegisterEffectFromString(p, a, b, c, d, e)
#define ID2D1Factory1_UnregisterEffect(p, a) (p)->lpVtbl->UnregisterEffect(p, a)
#define ID2D1Factory1_GetRegisteredEffects(p, a, b, c, d) (p)->lpVtbl->GetRegisteredEffects(p, a, b, c, d)
#define ID2D1Factory1_GetEffectProperties(p, a, b) (p)->lpVtbl->GetEffectProperties(p, a, b)

' ============================================================================
' ID2D1Multithread
' ============================================================================
Type ID2D1MultithreadVtbl As ID2D1MultithreadVtbl_
Type ID2D1Multithread
    lpVtbl As ID2D1MultithreadVtbl Ptr
End Type
Type ID2D1MultithreadVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As ID2D1Multithread Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Multithread Ptr) As ULong
    Release As Function(ByVal This As ID2D1Multithread Ptr) As ULong

    	' 4. GetMultithreadProtected
    GetMultithreadProtected As Function(ByVal This As ID2D1Multithread Ptr) As Long
    	' 5. Enter
    Enter As Sub(ByVal This As ID2D1Multithread Ptr)
    	' 6. Leave
    Leave As Sub(ByVal This As ID2D1Multithread Ptr)
End Type
#define ID2D1Multithread_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Multithread_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Multithread_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Multithread_GetMultithreadProtected(p, a) (p)->lpVtbl->GetMultithreadProtected(p, a)
#define ID2D1Multithread_Enter(p, a) (p)->lpVtbl->Enter(p, a)
#define ID2D1Multithread_Leave(p, a) (p)->lpVtbl->Leave(p, a)

Extern "Windows"
' ============================================================================
' Functions
' ============================================================================
Declare Function D2D1CreateDevice Lib "d2d1" ( ByVal dxgi_device As Any Ptr, ByVal creation_properties As D2D1_CREATION_PROPERTIES Ptr, ByVal device As Any Ptr Ptr ) As HRESULT
Declare Function D2D1CreateDeviceContext Lib "d2d1" ( ByVal dxgi_surface As Any Ptr, ByVal creation_properties As D2D1_CREATION_PROPERTIES Ptr, ByVal context As Any Ptr Ptr ) As HRESULT
Declare Sub D2D1SinCos Lib "d2d1" ( ByVal angle As Single, ByRef s As Single, ByRef c As Single )
Declare Function D2D1Tan Lib "d2d1" ( ByVal angle As Single ) As Single
Declare Function D2D1Vec3Length Lib "d2d1" ( ByVal x As Single, ByVal y As Single, ByVal z As Single ) As Single
Declare Function D2D1ConvertColorSpace Lib "d2d1" ( ByVal src_colour_space As D2D1_COLOR_SPACE, ByVal dst_colour_space As D2D1_COLOR_SPACE, ByRef colour As D2D1_COLOR_F ) As D2D1_COLOR_F
End Extern
