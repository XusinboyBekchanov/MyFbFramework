' Based on the C header files Wine project:
' Copyright (C) the Wine project
' Ported to FB by UEZ
' Build 2026-01-04 beta

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

Enum D2D1_DEVICE_CONTEXT_OPTIONS
    D2D1_DEVICE_CONTEXT_OPTIONS_NONE = 0
    D2D1_DEVICE_CONTEXT_OPTIONS_ENABLE_MULTITHREADED_OPTIMIZATIONS = 1
End Enum

Enum D2D1_STROKE_TRANSFORM_TYPE
    D2D1_STROKE_TRANSFORM_TYPE_NORMAL = 0
    D2D1_STROKE_TRANSFORM_TYPE_FIXED = 1
    D2D1_STROKE_TRANSFORM_TYPE_HAIRLINE = 2
End Enum

Enum D2D1_PRIMITIVE_BLEND
    D2D1_PRIMITIVE_BLEND_SOURCE_OVER = 0
    D2D1_PRIMITIVE_BLEND_COPY = 1
    D2D1_PRIMITIVE_BLEND_MIN = 2
    D2D1_PRIMITIVE_BLEND_ADD = 3
    D2D1_PRIMITIVE_BLEND_MAX = 4
End Enum

Enum D2D1_UNIT_MODE
    D2D1_UNIT_MODE_DIPS = 0
    D2D1_UNIT_MODE_PIXELS = 1
End Enum

Enum D2D1_PRINT_FONT_SUBSET_MODE
    D2D1_PRINT_FONT_SUBSET_MODE_DEFAULT = 0
    D2D1_PRINT_FONT_SUBSET_MODE_EACHPAGE = 1
    D2D1_PRINT_FONT_SUBSET_MODE_NONE = 2
End Enum

Enum D2D1_COLOR_SPACE
    D2D1_COLOR_SPACE_CUSTOM = 0
    D2D1_COLOR_SPACE_SRGB = 1
    D2D1_COLOR_SPACE_SCRGB = 2
End Enum

Enum D2D1_BITMAP_OPTIONS
    D2D1_BITMAP_OPTIONS_NONE = 0
    D2D1_BITMAP_OPTIONS_TARGET = 1
    D2D1_BITMAP_OPTIONS_CANNOT_DRAW = 2
    D2D1_BITMAP_OPTIONS_CPU_READ = 4
    D2D1_BITMAP_OPTIONS_GDI_COMPATIBLE = 8
End Enum

Enum D2D1_MAP_OPTIONS
    D2D1_MAP_OPTIONS_NONE = 0
    D2D1_MAP_OPTIONS_READ = 1
    D2D1_MAP_OPTIONS_WRITE = 2
    D2D1_MAP_OPTIONS_DISCARD = 4
End Enum

Enum D2D1_BUFFER_PRECISION
    D2D1_BUFFER_PRECISION_UNKNOWN = 0
    D2D1_BUFFER_PRECISION_8BPC_UNORM = 1
    D2D1_BUFFER_PRECISION_8BPC_UNORM_SRGB = 2
    D2D1_BUFFER_PRECISION_16BPC_UNORM = 3
    D2D1_BUFFER_PRECISION_16BPC_FLOAT = 4
    D2D1_BUFFER_PRECISION_32BPC_FLOAT = 5
End Enum

Enum D2D1_COLOR_INTERPOLATION_MODE
    D2D1_COLOR_INTERPOLATION_MODE_STRAIGHT = 0
    D2D1_COLOR_INTERPOLATION_MODE_PREMULTIPLIED = 1
End Enum

Enum D2D1_INTERPOLATION_MODE
    D2D1_INTERPOLATION_MODE_NEAREST_NEIGHBOR = 0
    D2D1_INTERPOLATION_MODE_LINEAR = 1
    D2D1_INTERPOLATION_MODE_CUBIC = 2
    D2D1_INTERPOLATION_MODE_MULTI_SAMPLE_LINEAR = 3
    D2D1_INTERPOLATION_MODE_ANISOTROPIC = 4
    D2D1_INTERPOLATION_MODE_HIGH_QUALITY_CUBIC = 5
End Enum

Enum D2D1_COMPOSITE_MODE
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

Enum D2D1_LAYER_OPTIONS1
    D2D1_LAYER_OPTIONS1_NONE = 0
    D2D1_LAYER_OPTIONS1_INITIALIZE_FROM_BACKGROUND = 1
    D2D1_LAYER_OPTIONS1_IGNORE_ALPHA = 2
End Enum

Enum D2D1_PROPERTY_TYPE
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

Enum D2D1_PROPERTY
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

Enum D2D1_SUBPROPERTY
    D2D1_SUBPROPERTY_DISPLAYNAME = &h80000000
    D2D1_SUBPROPERTY_ISREADONLY = &h80000001
    D2D1_SUBPROPERTY_MIN = &h80000002
    D2D1_SUBPROPERTY_MAX = &h80000003
    D2D1_SUBPROPERTY_DEFAULT = &h80000004
    D2D1_SUBPROPERTY_FIELDS = &h80000005
    D2D1_SUBPROPERTY_INDEX = &h80000006
End Enum

Enum D2D1_THREADING_MODE
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

Type PD2D1_PROPERTY_SET_FUNCTION As Function (ByVal effect As IUnknownBase Ptr, _
                                              ByVal data As Const Byte Ptr, _
                                              ByVal dataSize As UINT32 _
                                             ) As HRESULT

Type PD2D1_PROPERTY_GET_FUNCTION As Function ( _
                                                ByVal effect As Const IUnknownBase Ptr, _
                                                ByVal data As Byte Ptr, _
                                                ByVal dataSize As UINT32, _
                                                ByVal actualSize As UINT32 Ptr _
                                            ) As HRESULT

' ============================================================================
' Interfaces
' ============================================================================

' ============================================================================
' ID2D1GdiMetafileSink
' ============================================================================
Type ID2D1GdiMetafileSink Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. ProcessRecord
    Declare Abstract Function ProcessRecord Stdcall ( _
        ByVal record_type As ULong, _
        ByVal data As Any Ptr, _
        ByVal size As ULong _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1GdiMetafile
' ============================================================================
Type ID2D1GdiMetafile Extends ID2D1Resource
    ' 1-3: IUnknown
    ' 4: GetFactory
    
    ' 5. Stream
    Declare Abstract Function Stream Stdcall ( _
        ByVal sink As ID2D1GdiMetafileSink Ptr _
    ) As HRESULT
    
    ' 6. GetBounds
    Declare Abstract Function GetBounds Stdcall ( _
        ByVal bounds As D2D1_RECT_F Ptr _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1PathGeometry1
' ============================================================================
Type ID2D1PathGeometry1 Extends ID2D1PathGeometry
    ' Erbt von ID2D1PathGeometry
    
    ' 5. ComputePointAndSegmentAtLength
    Declare Abstract Function ComputePointAndSegmentAtLength Stdcall ( _
        ByVal length As Single, _
        ByVal start_segment As ULong, _
        ByVal transform As D2D1_MATRIX_3X2_F Ptr, _
        ByVal tolerance As Single, _
        ByVal point_desc As D2D1_POINT_DESCRIPTION Ptr _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1Properties
' ============================================================================
Type ID2D1Properties Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. GetPropertyCount
    Declare Abstract Function GetPropertyCount Stdcall () As ULong
    
    ' 5. GetPropertyName
    Declare Abstract Function GetPropertyName Stdcall ( _
        ByVal index As ULong, _
        ByVal name As WString Ptr, _
        ByVal name_count As ULong _
    ) As HRESULT
    
    ' 6. GetPropertyNameLength
    Declare Abstract Function GetPropertyNameLength Stdcall ( _
        ByVal index As ULong _
    ) As ULong
    
    ' 7. GetType
    Declare Abstract Function GetType Stdcall ( _
        ByVal index As ULong _
    ) As D2D1_PROPERTY_TYPE
    
    ' 8. GetPropertyIndex
    Declare Abstract Function GetPropertyIndex Stdcall ( _
        ByVal name As WString Ptr _
    ) As ULong
    
    ' 9. SetValueByName
    Declare Abstract Function SetValueByName Stdcall ( _
        ByVal name As WString Ptr, _
        ByVal prop_type As D2D1_PROPERTY_TYPE, _
        ByVal value As UByte Ptr, _
        ByVal value_size As ULong _
    ) As HRESULT
    
    ' 10. SetValue
    Declare Abstract Function SetValue Stdcall ( _
        ByVal index As ULong, _
        ByVal prop_type As D2D1_PROPERTY_TYPE, _
        ByVal value As UByte Ptr, _
        ByVal value_size As ULong _
    ) As HRESULT
    
    ' 11. GetValueByName
    Declare Abstract Function GetValueByName Stdcall ( _
        ByVal name As WString Ptr, _
        ByVal prop_type As D2D1_PROPERTY_TYPE, _
        ByVal value As UByte Ptr, _
        ByVal value_size As ULong _
    ) As HRESULT
    
    ' 12. GetValue
    Declare Abstract Function GetValue Stdcall ( _
        ByVal index As ULong, _
        ByVal prop_type As D2D1_PROPERTY_TYPE, _
        ByVal value As UByte Ptr, _
        ByVal value_size As ULong _
    ) As HRESULT
    
    ' 13. GetValueSize
    Declare Abstract Function GetValueSize Stdcall ( _
        ByVal index As ULong _
    ) As ULong
    
    ' 14. GetSubProperties
    Declare Abstract Function GetSubProperties Stdcall ( _
        ByVal index As ULong, _
        ByVal props As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1Effect
' ============================================================================
Type ID2D1Effect Extends ID2D1Properties
    ' Erbt von ID2D1Properties (1-14)
    
    ' 15. SetInput
    Declare Abstract Sub SetInput stdcall ( _
        ByVal index As ULong, _
        ByVal input As ID2D1Image Ptr, _
        ByVal invalidate As Long = True _
    )
    
    ' 16. SetInputCount
    Declare Abstract Function SetInputCount stdcall ( _
        ByVal count As ULong _
    ) As HRESULT
    
    ' 17. GetInput
    Declare Abstract Sub GetInput stdcall ( _
        ByVal index As ULong, _
        ByVal input As ID2D1Image Ptr Ptr _
    )
    
    ' 18. GetInputCount
    Declare Abstract Function GetInputCount stdcall () As ULong
    
    ' 19. GetOutput
    Declare Abstract Sub GetOutput stdcall ( _
        ByVal output As ID2D1Image Ptr Ptr _
    )

End Type

' ============================================================================
' ID2D1DrawingStateBlock1
' ============================================================================
Type ID2D1DrawingStateBlock1 Extends ID2D1DrawingStateBlock
    ' Erbt von ID2D1DrawingStateBlock
    
    ' Zusätzliche Methoden
    Declare Abstract Sub GetDescription stdcall ( _
        ByVal desc As D2D1_DRAWING_STATE_DESCRIPTION1 Ptr _
    )
    
    Declare Abstract Sub SetDescription stdcall ( _
        ByVal desc As D2D1_DRAWING_STATE_DESCRIPTION1 Ptr _
    )
End Type

' ============================================================================
' ID2D1ColorContext
' ============================================================================
Type ID2D1ColorContext Extends ID2D1Resource
    ' 1-3: IUnknown
    ' 4: GetFactory
    
    ' 5. GetColorSpace
    Declare Abstract Function GetColorSpace stdcall () As D2D1_COLOR_SPACE
    
    ' 6. GetProfileSize
    Declare Abstract Function GetProfileSize stdcall () As ULong
    
    ' 7. GetProfile
    Declare Abstract Function GetProfile stdcall ( _
        ByVal profile As UByte Ptr, _
        ByVal size As ULong _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1Bitmap1
' ============================================================================
Type ID2D1Bitmap1 Extends ID2D1Bitmap
    ' Erbt von ID2D1Bitmap
    
    ' Zusätzliche Methoden
    Declare Abstract Sub GetColorContext stdcall ( _
        ByVal context As Any Ptr Ptr _
    )
    
    Declare Abstract Function GetOptions stdcall () As D2D1_BITMAP_OPTIONS
    
    Declare Abstract Function GetSurface stdcall ( _
        ByVal surface As Any Ptr Ptr _
    ) As HRESULT
    
    Declare Abstract Function Map stdcall ( _
        ByVal options As D2D1_MAP_OPTIONS, _
        ByVal mapped_rect As D2D1_MAPPED_RECT Ptr _
    ) As HRESULT
    
    Declare Abstract Function Unmap stdcall () As HRESULT
End Type

' ============================================================================
' ID2D1BitmapBrush1
' ============================================================================
Type ID2D1BitmapBrush1 Extends ID2D1BitmapBrush
    ' Erbt von ID2D1BitmapBrush
    
    ' Zusätzliche Methoden
    Declare Abstract Sub SetInterpolationMode1 stdcall ( _
        ByVal mode As D2D1_INTERPOLATION_MODE _
    )
    
    Declare Abstract Function GetInterpolationMode1 stdcall () As D2D1_INTERPOLATION_MODE
End Type

' ============================================================================
' ID2D1GradientStopCollection1
' ============================================================================
Type ID2D1GradientStopCollection1 Extends ID2D1GradientStopCollection
    ' Erbt von ID2D1GradientStopCollection
    
    ' Zusätzliche Methoden
    Declare Abstract Sub GetGradientStops1 Stdcall ( _
        ByVal gradient As D2D1_GRADIENT_STOP Ptr, _
        ByVal count As ULong _
    )
    
    Declare Abstract Function GetPreInterpolationSpace Stdcall () As D2D1_COLOR_SPACE
    
    Declare Abstract Function GetPostInterpolationSpace Stdcall () As D2D1_COLOR_SPACE
    
    Declare Abstract Function GetBufferPrecision Stdcall () As D2D1_BUFFER_PRECISION
    
    Declare Abstract Function GetColorInterpolationMode Stdcall () As D2D1_COLOR_INTERPOLATION_MODE
End Type

' ============================================================================
' ID2D1Device
' ============================================================================
Type ID2D1Device Extends ID2D1Resource
    ' 1-3: IUnknown
    ' 4: GetFactory
    
    ' 5. CreateDeviceContext
    Declare Abstract Function CreateDeviceContext Stdcall ( _
        ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, _
        ByVal context As Any Ptr Ptr _
    ) As HRESULT
    
    ' 6. CreatePrintControl
    Declare Abstract Function CreatePrintControl Stdcall ( _
        ByVal wic_factory As Any Ptr, _
        ByVal document_target As Any Ptr, _
        ByVal desc As D2D1_PRINT_CONTROL_PROPERTIES Ptr, _
        ByVal print_control As Any Ptr Ptr _
    ) As HRESULT
    
    ' 7. SetMaximumTextureMemory
    Declare Abstract Sub SetMaximumTextureMemory Stdcall ( _
        ByVal max_texture_memory As ULongInt _
    )
    
    ' 8. GetMaximumTextureMemory
    Declare Abstract Function GetMaximumTextureMemory Stdcall () As ULongInt
    
    ' 9. ClearResources
    Declare Abstract Function ClearResources Stdcall ( _
        ByVal msec_since_use As ULong _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1CommandSink
' ============================================================================
Type ID2D1CommandSink Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. BeginDraw
    Declare Abstract Function BeginDraw Stdcall () As HRESULT
    
    ' 5. EndDraw
    Declare Abstract Function EndDraw Stdcall () As HRESULT
    
    ' 6. SetAntialiasMode
    Declare Abstract Function SetAntialiasMode Stdcall ( _
        ByVal antialias_mode As D2D1_ANTIALIAS_MODE _
    ) As HRESULT
    
    ' 7. SetTags
    Declare Abstract Function SetTags Stdcall ( _
        ByVal tag1 As D2D1_TAG, _
        ByVal tag2 As D2D1_TAG _
    ) As HRESULT
    
    ' 8. SetTextAntialiasMode
    Declare Abstract Function SetTextAntialiasMode Stdcall ( _
        ByVal antialias_mode As D2D1_TEXT_ANTIALIAS_MODE _
    ) As HRESULT
    
    ' 9. SetTextRenderingParams
    Declare Abstract Function SetTextRenderingParams Stdcall ( _
        ByVal text_rendering_params As Any Ptr _
    ) As HRESULT
    
    ' 10. SetTransform
    Declare Abstract Function SetTransform Stdcall ( _
        ByVal transform As D2D1_MATRIX_3X2_F Ptr _
    ) As HRESULT
    
    ' 11. SetPrimitiveBlend
    Declare Abstract Function SetPrimitiveBlend Stdcall ( _
        ByVal primitive_blend As D2D1_PRIMITIVE_BLEND _
    ) As HRESULT
    
    ' 12. SetUnitMode
    Declare Abstract Function SetUnitMode Stdcall ( _
        ByVal unit_mode As D2D1_UNIT_MODE _
    ) As HRESULT
    
    ' 13. Clear
    Declare Abstract Function Clear Stdcall ( _
        ByVal color As D2D1_COLOR_F Ptr _
    ) As HRESULT
    
    ' 14. DrawGlyphRun
    Declare Abstract Function DrawGlyphRun Stdcall ( _
        ByVal baseline_origin As D2D1_POINT_2F, _
        ByVal glyph_run As Any Ptr, _
        ByVal glyph_run_desc As Any Ptr, _
        ByVal brush As ID2D1Brush Ptr, _
        ByVal measuring_mode As ULong _
    ) As HRESULT
    
    ' 15. DrawLine
    Declare Abstract Function DrawLine Stdcall ( _
        ByVal p0 As D2D1_POINT_2F, _
        ByVal p1 As D2D1_POINT_2F, _
        ByVal brush As ID2D1Brush Ptr, _
        ByVal stroke_width As Single, _
        ByVal stroke_style As ID2D1StrokeStyle Ptr _
    ) As HRESULT
    
    ' 16. DrawGeometry
    Declare Abstract Function DrawGeometry Stdcall ( _
        ByVal geometry As ID2D1Geometry Ptr, _
        ByVal brush As ID2D1Brush Ptr, _
        ByVal stroke_width As Single, _
        ByVal stroke_style As ID2D1StrokeStyle Ptr _
    ) As HRESULT
    
    ' 17. DrawRectangle
    Declare Abstract Function DrawRectangle Stdcall ( _
        ByVal rect As D2D1_RECT_F Ptr, _
        ByVal brush As ID2D1Brush Ptr, _
        ByVal stroke_width As Single, _
        ByVal stroke_style As ID2D1StrokeStyle Ptr _
    ) As HRESULT
    
    ' 18. DrawBitmap
    Declare Abstract Function DrawBitmap Stdcall ( _
        ByVal bitmap As ID2D1Bitmap Ptr, _
        ByVal dst_rect As D2D1_RECT_F Ptr, _
        ByVal opacity As Single, _
        ByVal interpolation_mode As D2D1_INTERPOLATION_MODE, _
        ByVal src_rect As D2D1_RECT_F Ptr, _
        ByVal perspective_transform As D2D1_MATRIX_4X4_F Ptr _
    ) As HRESULT
    
    ' 19. DrawImage
    Declare Abstract Function DrawImage Stdcall ( _
        ByVal image As ID2D1Image Ptr, _
        ByVal target_offset As D2D1_POINT_2F Ptr, _
        ByVal image_rect As D2D1_RECT_F Ptr, _
        ByVal interpolation_mode As D2D1_INTERPOLATION_MODE, _
        ByVal composite_mode As D2D1_COMPOSITE_MODE _
    ) As HRESULT
    
    ' 20. DrawGdiMetafile
    Declare Abstract Function DrawGdiMetafile Stdcall ( _
        ByVal metafile As ID2D1GdiMetafile Ptr, _
        ByVal target_offset As D2D1_POINT_2F Ptr _
    ) As HRESULT
    
    ' 21. FillMesh
    Declare Abstract Function FillMesh Stdcall ( _
        ByVal mesh As ID2D1Mesh Ptr, _
        ByVal brush As ID2D1Brush Ptr _
    ) As HRESULT
    
    ' 22. FillOpacityMask
    Declare Abstract Function FillOpacityMask Stdcall ( _
        ByVal bitmap As ID2D1Bitmap Ptr, _
        ByVal brush As ID2D1Brush Ptr, _
        ByVal dst_rect As D2D1_RECT_F Ptr, _
        ByVal src_rect As D2D1_RECT_F Ptr _
    ) As HRESULT
    
    ' 23. FillGeometry
    Declare Abstract Function FillGeometry Stdcall ( _
        ByVal geometry As ID2D1Geometry Ptr, _
        ByVal brush As ID2D1Brush Ptr, _
        ByVal opacity_brush As ID2D1Brush Ptr _
    ) As HRESULT
    
    ' 24. FillRectangle
    Declare Abstract Function FillRectangle Stdcall ( _
        ByVal rect As D2D1_RECT_F Ptr, _
        ByVal brush As ID2D1Brush Ptr _
    ) As HRESULT
    
    ' 25. PushAxisAlignedClip
    Declare Abstract Function PushAxisAlignedClip Stdcall ( _
        ByVal clip_rect As D2D1_RECT_F Ptr, _
        ByVal antialias_mode As D2D1_ANTIALIAS_MODE _
    ) As HRESULT
    
    ' 26. PushLayer
    Declare Abstract Function PushLayer Stdcall ( _
        ByVal layer_parameters As D2D1_LAYER_PARAMETERS1 Ptr, _
        ByVal layer As ID2D1Layer Ptr _
    ) As HRESULT
    
    ' 27. PopAxisAlignedClip
    Declare Abstract Function PopAxisAlignedClip Stdcall () As HRESULT
    
    ' 28. PopLayer
    Declare Abstract Function PopLayer Stdcall () As HRESULT
End Type

' ============================================================================
' ID2D1CommandList
' ============================================================================
Type ID2D1CommandList Extends ID2D1Image
    ' Erbt von ID2D1Image
    
    ' Zusätzliche Methoden
    Declare Abstract Function Stream Stdcall ( _
        ByVal sink As ID2D1CommandSink Ptr _
    ) As HRESULT
    
    Declare Abstract Function Close Stdcall () As HRESULT
End Type

' ============================================================================
' ID2D1PrintControl
' ============================================================================
Type ID2D1PrintControl Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. AddPage
    Declare Abstract Function AddPage Stdcall ( _
        ByVal list As Any Ptr, _
        ByVal size As D2D1_SIZE_F, _
        ByVal stream As Any Ptr, _
        ByVal tag1 As D2D1_TAG Ptr, _
        ByVal tag2 As D2D1_TAG Ptr _
    ) As HRESULT
    
    ' 5. Close
    Declare Abstract Function Close Stdcall () As HRESULT
End Type

' ============================================================================
' ID2D1ImageBrush
' ============================================================================
Type ID2D1ImageBrush Extends ID2D1Brush
    ' Erbt von ID2D1Brush
    
    ' Zusätzliche Methoden
    Declare Abstract Sub SetImage Stdcall ( _
        ByVal image As ID2D1Image Ptr _
    )
    
    Declare Abstract Sub SetExtendModeX Stdcall ( _
        ByVal extend_mode As D2D1_EXTEND_MODE _
    )
    
    Declare Abstract Sub SetExtendModeY Stdcall ( _
        ByVal extend_mode As D2D1_EXTEND_MODE _
    )
    
    Declare Abstract Sub SetInterpolationMode Stdcall ( _
        ByVal interpolation_mode As D2D1_INTERPOLATION_MODE _
    )
    
    Declare Abstract Sub SetSourceRectangle Stdcall ( _
        ByVal rect As D2D1_RECT_F Ptr _
    )
    
    Declare Abstract Sub GetImage Stdcall ( _
        ByVal image As Any Ptr Ptr _
    )
    
    Declare Abstract Function GetExtendModeX Stdcall () As D2D1_EXTEND_MODE
    
    Declare Abstract Function GetExtendModeY Stdcall () As D2D1_EXTEND_MODE
    
    Declare Abstract Function GetInterpolationMode Stdcall () As D2D1_INTERPOLATION_MODE
    
    Declare Abstract Sub GetSourceRectangle Stdcall ( _
        ByVal rect As D2D1_RECT_F Ptr _
    )
End Type

' ============================================================================
' ID2D1DeviceContext (MASSIVE Interface!)
' ============================================================================
Type ID2D1DeviceContext Extends ID2D1RenderTarget
    ' Erbt alle Methoden von ID2D1RenderTarget (1-57)
    
	' 58. CreateBitmap (überladen)
	Declare Abstract Function CreateBitmap Stdcall ( _
		ByVal size As D2D1_SIZE_U, _
		ByVal src_data As Any Ptr, _
		ByVal pitch As ULong, _
		ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, _
		ByVal bitmap As Any Ptr Ptr _
	) As HRESULT

	' 59. CreateBitmapFromWicBitmap (überladen)
	Declare Abstract Function CreateBitmapFromWicBitmap Stdcall ( _
		ByVal bitmap_source As IUnknownBase Ptr, _ 'IWICBitmapSource
		ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, _
		ByVal bitmap As ID2D1Bitmap1 Ptr Ptr _
	) As HRESULT

	' 60. CreateColorContext
	Declare Abstract Function CreateColorContext Stdcall ( _
		ByVal space As D2D1_COLOR_SPACE, _
		ByVal profile As UByte Ptr, _
		ByVal profile_size As ULong, _
		ByVal color_context As Any Ptr Ptr _
	) As HRESULT

	' 61. CreateColorContextFromFilename
	Declare Abstract Function CreateColorContextFromFilename Stdcall ( _
		ByVal filename As WString Ptr, _
		ByVal color_context As Any Ptr Ptr _
	) As HRESULT

	' 62. CreateColorContextFromWicColorContext
	Declare Abstract Function CreateColorContextFromWicColorContext Stdcall ( _
		ByVal wic_color_context As Any Ptr, _
		ByVal color_context As Any Ptr Ptr _
	) As HRESULT

	' 63. CreateBitmapFromDxgiSurface
	Declare Abstract Function CreateBitmapFromDxgiSurface Stdcall ( _
		ByVal surface As Any Ptr, _
		ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, _
		ByVal bitmap As Any Ptr Ptr _
	) As HRESULT

	' 64. CreateEffect
	Declare Abstract Function CreateEffect Stdcall ( _
		ByRef effect_id As GUID, _
		ByVal effect As ID2D1Effect Ptr Ptr _
	) As HRESULT

	' 65. CreateGradientStopCollection (überladen)
	Declare Abstract Function CreateGradientStopCollection Stdcall ( _
		ByVal stops As D2D1_GRADIENT_STOP Ptr, _
		ByVal stop_count As ULong, _
		ByVal preinterpolation_space As D2D1_COLOR_SPACE, _
		ByVal postinterpolation_space As D2D1_COLOR_SPACE, _
		ByVal buffer_precision As D2D1_BUFFER_PRECISION, _
		ByVal extend_mode As D2D1_EXTEND_MODE, _
		ByVal color_interpolation_mode As D2D1_COLOR_INTERPOLATION_MODE, _
		ByVal gradient As Any Ptr Ptr _
	) As HRESULT

	' 66. CreateImageBrush
	Declare Abstract Function CreateImageBrush Stdcall ( _
		ByVal image As ID2D1Image Ptr, _
		ByVal image_brush_desc As D2D1_IMAGE_BRUSH_PROPERTIES Ptr, _
		ByVal brush_desc As D2D1_BRUSH_PROPERTIES Ptr, _
		ByVal brush As Any Ptr Ptr _
	) As HRESULT

	' 67. CreateBitmapBrush (überladen)
	Declare Abstract Function CreateBitmapBrush Stdcall ( _
		ByVal bitmap As ID2D1Bitmap Ptr, _
		ByVal bitmap_brush_desc As D2D1_BITMAP_BRUSH_PROPERTIES1 Ptr, _
		ByVal brush_desc As D2D1_BRUSH_PROPERTIES Ptr, _
		ByVal bitmap_brush As Any Ptr Ptr _
	) As HRESULT

	' 68. CreateCommandList
	Declare Abstract Function CreateCommandList Stdcall ( _
		ByVal command_list As Any Ptr Ptr _
	) As HRESULT

	' 69. IsDxgiFormatSupported
	Declare Abstract Function IsDxgiFormatSupported Stdcall ( _
		ByVal format As ULong _
	) As Long

	' 70. IsBufferPrecisionSupported
	Declare Abstract Function IsBufferPrecisionSupported Stdcall ( _
		ByVal buffer_precision As D2D1_BUFFER_PRECISION _
	) As Long

	' 71. GetImageLocalBounds
	Declare Abstract Function GetImageLocalBounds Stdcall ( _
		ByVal image As ID2D1Image Ptr, _
		ByVal local_bounds As D2D1_RECT_F Ptr _
	) As HRESULT

	' 72. GetImageWorldBounds
	Declare Abstract Function GetImageWorldBounds Stdcall ( _
		ByVal image As ID2D1Image Ptr, _
		ByVal world_bounds As D2D1_RECT_F Ptr _
	) As HRESULT

	' 73. GetGlyphRunWorldBounds
	Declare Abstract Function GetGlyphRunWorldBounds Stdcall ( _
		ByVal baseline_origin As D2D1_POINT_2F, _
		ByVal glyph_run As Any Ptr, _
		ByVal measuring_mode As ULong, _
		ByVal bounds As D2D1_RECT_F Ptr _
	) As HRESULT

	' 74. GetDevice
	Declare Abstract Sub GetDevice Stdcall ( _
		ByVal device As Any Ptr Ptr _
	)

	' 75. SetTarget
	Declare Abstract Sub SetTarget Stdcall ( _
		ByVal target As ID2D1Image Ptr _
	)

	' 76. GetTarget
	Declare Abstract Sub GetTarget Stdcall ( _
		ByVal target As Any Ptr Ptr _
	)

	' 77. SetRenderingControls
	Declare Abstract Sub SetRenderingControls Stdcall ( _
		ByVal rendering_controls As D2D1_RENDERING_CONTROLS Ptr _
	)

	' 78. GetRenderingControls
	Declare Abstract Sub GetRenderingControls Stdcall ( _
		ByVal rendering_controls As D2D1_RENDERING_CONTROLS Ptr _
	)

	' 79. SetPrimitiveBlend
	Declare Abstract Sub SetPrimitiveBlend Stdcall ( _
		ByVal primitive_blend As D2D1_PRIMITIVE_BLEND _
	)

	' 80. GetPrimitiveBlend
	Declare Abstract Function GetPrimitiveBlend Stdcall () As D2D1_PRIMITIVE_BLEND

	' 81. SetUnitMode
	Declare Abstract Sub SetUnitMode Stdcall ( _
		ByVal unit_mode As D2D1_UNIT_MODE _
	)

	' 82. GetUnitMode
	Declare Abstract Function GetUnitMode Stdcall () As D2D1_UNIT_MODE

	' 83. DrawGlyphRun (überladen)
	Declare Abstract Sub DrawGlyphRun Stdcall ( _
		ByVal baseline_origin As D2D1_POINT_2F, _
		ByVal glyph_run As Any Ptr, _
		ByVal glyph_run_desc As Any Ptr, _
		ByVal brush As ID2D1Brush Ptr, _
		ByVal measuring_mode As ULong _
	)

	' 84. DrawImage
	Declare Abstract Sub DrawImage Stdcall ( _
		ByVal image As ID2D1Image Ptr, _
		ByVal target_offset As D2D1_POINT_2F Ptr = 0, _
		ByVal image_rect As D2D1_RECT_F Ptr = 0, _
		ByVal interpolation_mode As D2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR, _
		ByVal composite_mode As D2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER _
	)

	' 85. DrawGdiMetafile
	Declare Abstract Sub DrawGdiMetafile Stdcall ( _
		ByVal metafile As ID2D1GdiMetafile Ptr, _
		ByVal target_offset As D2D1_POINT_2F Ptr _
	)

	' 86. DrawBitmap (überladen)
	Declare Abstract Sub DrawBitmap Stdcall ( _
		ByVal bitmap As ID2D1Bitmap Ptr, _
		ByVal dst_rect As D2D1_RECT_F Ptr, _
		ByVal opacity As Single, _
		ByVal interpolation_mode As D2D1_INTERPOLATION_MODE, _
		ByVal src_rect As D2D1_RECT_F Ptr, _
		ByVal perspective_transform As D2D1_MATRIX_4X4_F Ptr _
	)

	' 87. InvalidateEffectInputRectangle
	Declare Abstract Function InvalidateEffectInputRectangle Stdcall ( _
		ByVal effect As Any Ptr, _
		ByVal input As ULong, _
		ByVal input_rect As D2D1_RECT_F Ptr _
	) As HRESULT

	' 88. GetEffectInvalidRectangleCount
	Declare Abstract Function GetEffectInvalidRectangleCount Stdcall ( _
		ByVal effect As Any Ptr, _
		ByVal rect_count As ULong Ptr _
	) As HRESULT

	' 89. GetEffectInvalidRectangles
	Declare Abstract Function GetEffectInvalidRectangles Stdcall ( _
		ByVal effect As Any Ptr, _
		ByVal rectangles As D2D1_RECT_F Ptr, _
		ByVal rect_count As ULong _
	) As HRESULT

	' 90. GetEffectRequiredInputRectangles
	Declare Abstract Function GetEffectRequiredInputRectangles Stdcall ( _
		ByVal effect As Any Ptr, _
		ByVal image_rect As D2D1_RECT_F Ptr, _
		ByVal desc As D2D1_EFFECT_INPUT_DESCRIPTION Ptr, _
		ByVal input_rects As D2D1_RECT_F Ptr, _
		ByVal input_count As ULong _
	) As HRESULT

	' 91. FillOpacityMask (überladen)
	Declare Abstract Sub FillOpacityMask Stdcall ( _
		ByVal mask As ID2D1Bitmap Ptr, _
		ByVal brush As ID2D1Brush Ptr, _
		ByVal content As D2D1_OPACITY_MASK_CONTENT, _
		ByVal dst_rect As D2D1_RECT_F Ptr, _
		ByVal src_rect As D2D1_RECT_F Ptr _
	)

	' 92. PushLayer
	Declare Abstract Sub PushLayer Stdcall ( _
		ByVal layer_parameters As D2D1_LAYER_PARAMETERS1 Ptr, _
		ByVal layer As ID2D1Layer Ptr _
	)

End Type

' ============================================================================
' ID2D1StrokeStyle1
' ============================================================================
Type ID2D1StrokeStyle1 Extends ID2D1StrokeStyle
	' Erbt von ID2D1StrokeStyle
	' Zusätzliche Methode
	Declare Abstract Function GetStrokeTransformType Stdcall () As D2D1_STROKE_TRANSFORM_TYPE
End Type

' ============================================================================
' ID2D1Factory1
' ============================================================================
Type ID2D1Factory1 Extends ID2D1Factory
	' Erbt von ID2D1Factory (1-17 Methoden)
	
	' 18. CreateDevice
	Declare Abstract Function CreateDevice Stdcall ( _
		ByVal dxgi_device As Any Ptr, _
		ByVal device As ID2D1Device Ptr Ptr _
	) As HRESULT

	' 19. CreateStrokeStyle (überladen)
	Declare Abstract Function CreateStrokeStyle Stdcall ( _
		ByVal desc As D2D1_STROKE_STYLE_PROPERTIES1 Ptr, _
		ByVal dashes As Single Ptr, _
		ByVal dash_count As ULong, _
		ByVal stroke_style As Any Ptr Ptr _
	) As HRESULT

	' 20. CreatePathGeometry (überladen)
	Declare Abstract Function CreatePathGeometry Stdcall ( _
		ByVal geometry As Any Ptr Ptr _
	) As HRESULT

	' 21. CreateDrawingStateBlock (überladen)
	Declare Abstract Function CreateDrawingStateBlock Stdcall ( _
		ByVal desc As D2D1_DRAWING_STATE_DESCRIPTION1 Ptr, _
		ByVal text_rendering_params As Any Ptr, _
		ByVal state_block As Any Ptr Ptr _
	) As HRESULT

	' 22. CreateGdiMetafile
	Declare Abstract Function CreateGdiMetafile Stdcall ( _
		ByVal stream As Any Ptr, _
		ByVal metafile As Any Ptr Ptr _
	) As HRESULT

	' 23. RegisterEffectFromStream
	Declare Abstract Function RegisterEffectFromStream Stdcall ( _
		ByRef effect_id As GUID, _
		ByVal property_xml As Any Ptr, _
		ByVal bindings As Any Ptr, _
		ByVal binding_count As ULong, _
		ByVal effect_factory As PD2D1_EFFECT_FACTORY Ptr _
	) As HRESULT

	' 24. RegisterEffectFromString
	Declare Abstract Function RegisterEffectFromString Stdcall ( _
		ByVal effect_id As GUID, _
		ByVal property_xml As WString Ptr, _
		ByVal bindings As Any Ptr, _
		ByVal binding_count As ULong, _
		ByVal effect_factory As PD2D1_EFFECT_FACTORY Ptr _
	) As HRESULT

	' 25. UnregisterEffect
	Declare Abstract Function UnregisterEffect Stdcall ( _
		ByRef effect_id As GUID _
	) As HRESULT

	' 26. GetRegisteredEffects
	Declare Abstract Function GetRegisteredEffects Stdcall ( _
		ByVal effects As GUID Ptr, _
		ByVal effect_count As ULong, _
		ByVal returned As ULong Ptr, _
		ByVal registered As ULong Ptr _
	) As HRESULT

	' 27. GetEffectProperties
	Declare Abstract Function GetEffectProperties Stdcall ( _
		ByRef effect_id As GUID, _
		ByVal props As Any Ptr Ptr _
	) As HRESULT
End Type

' ============================================================================
' ID2D1Multithread
' ============================================================================
Type ID2D1Multithread Extends IUnknownBase
	' 1-3: IUnknown
	' 4. GetMultithreadProtected
	Declare Abstract Function GetMultithreadProtected Stdcall () As Long

	' 5. Enter
	Declare Abstract Sub Enter Stdcall ()

	' 6. Leave
	Declare Abstract Sub Leave Stdcall ()
End Type

Extern "Windows"

' ============================================================================
' Functions
' ============================================================================
Declare Function D2D1CreateDevice Lib "d2d1" ( _
		ByVal dxgi_device As Any Ptr, _
		ByVal creation_properties As D2D1_CREATION_PROPERTIES Ptr, _
		ByVal device As Any Ptr Ptr _
		) As HRESULT
		
Declare Function D2D1CreateDeviceContext Lib "d2d1" ( _
		ByVal dxgi_surface As Any Ptr, _
		ByVal creation_properties As D2D1_CREATION_PROPERTIES Ptr, _
		ByVal context As Any Ptr Ptr _
		) As HRESULT
Declare Sub D2D1SinCos Lib "d2d1" ( _
		ByVal angle As Single, _
		ByRef s As Single, _
		ByRef c As Single _
		)
Declare Function D2D1Tan Lib "d2d1" ( _
		ByVal angle As Single _
		) As Single
		Declare Function D2D1Vec3Length Lib "d2d1" ( _
		ByVal x As Single, _
		ByVal y As Single, _
		ByVal z As Single _
		) As Single
Declare Function D2D1ConvertColorSpace Lib "d2d1" ( _
		ByVal src_colour_space As D2D1_COLOR_SPACE, _
		ByVal dst_colour_space As D2D1_COLOR_SPACE, _
		ByRef colour As D2D1_COLOR_F _
		) As D2D1_COLOR_F
End Extern