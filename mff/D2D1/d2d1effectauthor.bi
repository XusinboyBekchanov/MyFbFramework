' Based on the C header files Wine project:
' Copyright (C) the Wine project
' Ported to FB by UEZ
' Build 2026-01-04 beta

#pragma once

' ============================================================================
' Direct2D Effect Author API - FreeBASIC Translation
' ============================================================================

#include once "d2d1_1.bi"

' ============================================================================
' Callback Function Types
' ============================================================================

'Type PD2D1_PROPERTY_SET_FUNCTION As Function ( _
'    ByVal effect As IUnknown Ptr, _
'    ByVal data As UByte Ptr, _
'    ByVal data_size As ULong _
') As HRESULT

'Type PD2D1_PROPERTY_GET_FUNCTION As Function ( _
'    ByVal effect As IUnknown Ptr, _
'    ByVal data As UByte Ptr, _
'    ByVal data_size As ULong, _
'    ByVal actual_size As ULong Ptr _
') As HRESULT

' ============================================================================
' Enumerations
' ============================================================================

'Enum D2D1_FILTER
'    D2D1_FILTER_MIN_MAG_MIP_POINT = &h00
'    D2D1_FILTER_MIN_MAG_POINT_MIP_LINEAR = &h01
'    D2D1_FILTER_MIN_POINT_MAG_LINEAR_MIP_POINT = &h04
'    D2D1_FILTER_MIN_POINT_MAG_MIP_LINEAR = &h05
'    D2D1_FILTER_MIN_LINEAR_MAG_MIP_POINT = &h10
'    D2D1_FILTER_MIN_LINEAR_MAG_POINT_MIP_LINEAR = &h11
'    D2D1_FILTER_MIN_MAG_LINEAR_MIP_POINT = &h14
'    D2D1_FILTER_MIN_MAG_MIP_LINEAR = &h15
'    D2D1_FILTER_ANISOTROPIC = &h55
'End Enum

'Enum D2D1_FEATURE
'    D2D1_FEATURE_DOUBLES = 0
'    D2D1_FEATURE_D3D10_X_HARDWARE_OPTIONS = 1
'End Enum

'Enum D2D1_CHANNEL_DEPTH
'    D2D1_CHANNEL_DEPTH_DEFAULT = 0
'    D2D1_CHANNEL_DEPTH_1 = 1
'    D2D1_CHANNEL_DEPTH_4 = 4
'End Enum

'Enum D2D1_CHANGE_TYPE
'    D2D1_CHANGE_TYPE_NONE = 0
'    D2D1_CHANGE_TYPE_PROPERTIES = 1
'    D2D1_CHANGE_TYPE_CONTEXT = 2
'    D2D1_CHANGE_TYPE_GRAPH = 3
'End Enum

'Enum D2D1_PIXEL_OPTIONS
'    D2D1_PIXEL_OPTIONS_NONE = 0
'    D2D1_PIXEL_OPTIONS_TRIVIAL_SAMPLING = 1
'End Enum

'Enum D2D1_VERTEX_OPTIONS
'    D2D1_VERTEX_OPTIONS_NONE = 0
'    D2D1_VERTEX_OPTIONS_DO_NOT_CLEAR = 1
'    D2D1_VERTEX_OPTIONS_USE_DEPTH_BUFFER = 2
'    D2D1_VERTEX_OPTIONS_ASSUME_NO_OVERLAP = 4
'End Enum

'Enum D2D1_VERTEX_USAGE
'    D2D1_VERTEX_USAGE_STATIC = 0
'    D2D1_VERTEX_USAGE_DYNAMIC = 1
'End Enum

'Enum D2D1_BLEND_OPERATION
'    D2D1_BLEND_OPERATION_ADD = 1
'    D2D1_BLEND_OPERATION_SUBTRACT = 2
'    D2D1_BLEND_OPERATION_REV_SUBTRACT = 3
'    D2D1_BLEND_OPERATION_MIN = 4
'    D2D1_BLEND_OPERATION_MAX = 5
'End Enum

'Enum D2D1_BLEND
'    D2D1_BLEND_ZERO = 1
'    D2D1_BLEND_ONE = 2
'    D2D1_BLEND_SRC_COLOR = 3
'    D2D1_BLEND_INV_SRC_COLOR = 4
'    D2D1_BLEND_SRC_ALPHA = 5
'    D2D1_BLEND_INV_SRC_ALPHA = 6
'    D2D1_BLEND_DEST_ALPHA = 7
'    D2D1_BLEND_INV_DEST_ALPHA = 8
'    D2D1_BLEND_DEST_COLOR = 9
'    D2D1_BLEND_INV_DEST_COLOR = 10
'    D2D1_BLEND_SRC_ALPHA_SAT = 11
'    D2D1_BLEND_BLEND_FACTOR = 14
'    D2D1_BLEND_INV_BLEND_FACTOR = 15
'End Enum

' ============================================================================
' Structures
' ============================================================================

Type D2D1_PROPERTY_BINDING
    propertyName As WString Ptr
    setFunction As PD2D1_PROPERTY_SET_FUNCTION
    getFunction As PD2D1_PROPERTY_GET_FUNCTION
End Type

Type D2D1_INPUT_DESCRIPTION
    filter As D2D1_FILTER
    levelOfDetailCount As ULong
End Type

Type D2D1_VERTEX_RANGE
    startVertex As ULong
    vertexCount As ULong
End Type

Type D2D1_BLEND_DESCRIPTION
    sourceBlend As D2D1_BLEND
    destinationBlend As D2D1_BLEND
    blendOperation As D2D1_BLEND_OPERATION
    sourceBlendAlpha As D2D1_BLEND
    destinationBlendAlpha As D2D1_BLEND
    blendOperationAlpha As D2D1_BLEND_OPERATION
    blendFactor(3) As Single
End Type

Type D2D1_RESOURCE_TEXTURE_PROPERTIES
    extents As ULong Ptr
    dimensions As ULong
    bufferPrecision As D2D1_BUFFER_PRECISION
    channelDepth As D2D1_CHANNEL_DEPTH
    filter As D2D1_FILTER
    extendModes As D2D1_EXTEND_MODE Ptr
End Type

Type D2D1_INPUT_ELEMENT_DESC
    semanticName As ZString Ptr
    semanticIndex As ULong
    format As ULong  ' DXGI_FORMAT
    inputSlot As ULong
    alignedByteOffset As ULong
End Type

Type D2D1_VERTEX_BUFFER_PROPERTIES
    inputCount As ULong
    usage As D2D1_VERTEX_USAGE
    data As UByte Ptr
    byteWidth As ULong
End Type

Type D2D1_CUSTOM_VERTEX_BUFFER_PROPERTIES
    shaderBufferWithInputSignature As UByte Ptr
    shaderBufferSize As ULong
    inputElements As D2D1_INPUT_ELEMENT_DESC Ptr
    elementCount As ULong
    stride As ULong
End Type

' ============================================================================
' IID Definitions
' ============================================================================

Dim Shared IID_ID2D1VertexBuffer As GUID = Type(&h9b8b1336, &h00a5, &h4668, {&h92, &hb7, &hce, &hd5, &hd8, &hbf, &h9b, &h7b})
Dim Shared IID_ID2D1ResourceTexture As GUID = Type(&h688d15c3, &h02b0, &h438d, {&hb1, &h3a, &hd1, &hb4, &h4c, &h32, &hc3, &h9a})
Dim Shared IID_ID2D1RenderInfo As GUID = Type(&h519ae1bd, &hd19a, &h420d, {&hb8, &h49, &h36, &h4f, &h59, &h47, &h76, &hb7})
Dim Shared IID_ID2D1DrawInfo As GUID = Type(&h693ce632, &h7f2f, &h45de, {&h93, &hfe, &h18, &hd8, &h8b, &h37, &haa, &h21})
Dim Shared IID_ID2D1ComputeInfo As GUID = Type(&h5598b14b, &h9fd7, &h48b7, {&h9b, &hdb, &h8f, &h09, &h64, &heb, &h38, &hbc})
Dim Shared IID_ID2D1TransformNode As GUID = Type(&hb2efe1e7, &h729f, &h4102, {&h94, &h9f, &h50, &h5f, &ha2, &h1b, &hf6, &h66})
Dim Shared IID_ID2D1TransformGraph As GUID = Type(&h13d29038, &hc3e6, &h4034, {&h90, &h81, &h13, &hb5, &h3a, &h41, &h79, &h92})
Dim Shared IID_ID2D1Transform As GUID = Type(&hef1a287d, &h342a, &h4f76, {&h8f, &hdb, &hda, &h0d, &h6e, &ha9, &hf9, &h2b})
Dim Shared IID_ID2D1DrawTransform As GUID = Type(&h36bfdcb6, &h9739, &h435d, {&ha3, &h0d, &ha6, &h53, &hbe, &hff, &h6a, &h6f})
Dim Shared IID_ID2D1ComputeTransform As GUID = Type(&h0d85573c, &h01e3, &h4f7d, {&hbf, &hd9, &h0d, &h60, &h60, &h8b, &hf3, &hc3})
Dim Shared IID_ID2D1AnalysisTransform As GUID = Type(&h0359dc30, &h95e6, &h4568, {&h90, &h55, &h27, &h72, &h0d, &h13, &h0e, &h93})
Dim Shared IID_ID2D1SourceTransform As GUID = Type(&hdb1800dd, &h0c34, &h4cf9, {&hbe, &h90, &h31, &hcc, &h0a, &h56, &h53, &he1})
Dim Shared IID_ID2D1ConcreteTransform As GUID = Type(&h1a799d8a, &h69f7, &h4e4c, {&h9f, &hed, &h43, &h7c, &hcc, &h66, &h84, &hcc})
Dim Shared IID_ID2D1BlendTransform As GUID = Type(&h63ac0b32, &hba44, &h450f, {&h88, &h06, &h7f, &h4c, &ha1, &hff, &h2f, &h1b})
Dim Shared IID_ID2D1BorderTransform As GUID = Type(&h4998735c, &h3a19, &h473c, {&h97, &h81, &h65, &h68, &h47, &he3, &ha3, &h47})
Dim Shared IID_ID2D1OffsetTransform As GUID = Type(&h3fe6adea, &h7643, &h4f53, {&hbd, &h14, &ha0, &hce, &h63, &hf2, &h40, &h42})
Dim Shared IID_ID2D1BoundsAdjustmentTransform As GUID = Type(&h90f732e2, &h5092, &h4606, {&ha8, &h19, &h86, &h51, &h97, &h0b, &hac, &hcd})
Dim Shared IID_ID2D1EffectContext As GUID = Type(&h3d9f916b, &h27dc, &h4ad7, {&hb4, &hf1, &h64, &h94, &h53, &h40, &hf5, &h63})
Dim Shared IID_ID2D1EffectImpl As GUID = Type(&ha248fd3f, &h3e6c, &h4e63, {&h9f, &h03, &h7f, &h68, &hec, &hc9, &h1d, &hb9})

' ============================================================================
' Interfaces
' ============================================================================

' ============================================================================
' ID2D1VertexBuffer
' ============================================================================
Type ID2D1VertexBuffer Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. Map
    Declare Abstract Function Map Stdcall ( _
        ByVal data As UByte Ptr Ptr, _
        ByVal size As ULong _
    ) As HRESULT
    
    ' 5. Unmap
    Declare Abstract Function Unmap Stdcall () As HRESULT
End Type

' ============================================================================
' ID2D1ResourceTexture
' ============================================================================
Type ID2D1ResourceTexture Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. Update
    Declare Abstract Function Update Stdcall ( _
        ByVal min_extents As ULong Ptr, _
        ByVal max_extents As ULong Ptr, _
        ByVal strides As ULong Ptr, _
        ByVal dimensions As ULong, _
        ByVal data As UByte Ptr, _
        ByVal data_size As ULong _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1RenderInfo
' ============================================================================
Type ID2D1RenderInfo Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. SetInputDescription
    Declare Abstract Function SetInputDescription Stdcall ( _
        ByVal index As ULong, _
        ByVal description As D2D1_INPUT_DESCRIPTION _
    ) As HRESULT
    
    ' 5. SetOutputBuffer
    Declare Abstract Function SetOutputBuffer Stdcall ( _
        ByVal precision As D2D1_BUFFER_PRECISION, _
        ByVal depth As D2D1_CHANNEL_DEPTH _
    ) As HRESULT
    
    ' 6. SetCached
    Declare Abstract Sub SetCached Stdcall ( _
        ByVal is_cached As Long _
    )
    
    ' 7. SetInstructionCountHint
    Declare Abstract Sub SetInstructionCountHint Stdcall ( _
        ByVal count As ULong _
    )
End Type

' ============================================================================
' ID2D1DrawInfo
' ============================================================================
Type ID2D1DrawInfo Extends ID2D1RenderInfo
    ' 1-7: ID2D1RenderInfo
    
    ' 8. SetPixelShaderConstantBuffer
    Declare Abstract Function SetPixelShaderConstantBuffer Stdcall ( _
        ByVal buffer As UByte Ptr, _
        ByVal size As ULong _
    ) As HRESULT
    
    ' 9. SetResourceTexture
    Declare Abstract Function SetResourceTexture Stdcall ( _
        ByVal index As ULong, _
        ByVal texture As ID2D1ResourceTexture Ptr _
    ) As HRESULT
    
    ' 10. SetVertexShaderConstantBuffer
    Declare Abstract Function SetVertexShaderConstantBuffer Stdcall ( _
        ByVal buffer As UByte Ptr, _
        ByVal size As ULong _
    ) As HRESULT
    
    ' 11. SetPixelShader
    Declare Abstract Function SetPixelShader Stdcall ( _
        ByRef id As GUID, _
        ByVal options As D2D1_PIXEL_OPTIONS _
    ) As HRESULT
    
    ' 12. SetVertexProcessing
    Declare Abstract Function SetVertexProcessing Stdcall ( _
        ByVal buffer As ID2D1VertexBuffer Ptr, _
        ByVal options As D2D1_VERTEX_OPTIONS, _
        ByVal description As D2D1_BLEND_DESCRIPTION Ptr, _
        ByVal range As D2D1_VERTEX_RANGE Ptr, _
        ByVal shader As GUID Ptr _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1ComputeInfo
' ============================================================================
Type ID2D1ComputeInfo Extends ID2D1RenderInfo
    ' 1-7: ID2D1RenderInfo
    
    ' 8. SetComputeShaderConstantBuffer
    Declare Abstract Function SetComputeShaderConstantBuffer Stdcall ( _
        ByVal buffer As UByte Ptr, _
        ByVal size As ULong _
    ) As HRESULT
    
    ' 9. SetComputeShader
    Declare Abstract Function SetComputeShader Stdcall ( _
        ByRef id As GUID _
    ) As HRESULT
    
    ' 10. SetResourceTexture
    Declare Abstract Function SetResourceTexture Stdcall ( _
        ByVal index As ULong, _
        ByVal texture As ID2D1ResourceTexture Ptr _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1TransformNode
' ============================================================================
Type ID2D1TransformNode Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. GetInputCount
    Declare Abstract Function GetInputCount Stdcall () As ULong
End Type

' ============================================================================
' ID2D1TransformGraph
' ============================================================================
Type ID2D1TransformGraph Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. GetInputCount
    Declare Abstract Function GetInputCount Stdcall () As ULong
    
    ' 5. SetSingleTransformNode
    Declare Abstract Function SetSingleTransformNode Stdcall ( _
        ByVal node As ID2D1TransformNode Ptr _
    ) As HRESULT
    
    ' 6. AddNode
    Declare Abstract Function AddNode Stdcall ( _
        ByVal node As ID2D1TransformNode Ptr _
    ) As HRESULT
    
    ' 7. RemoveNode
    Declare Abstract Function RemoveNode Stdcall ( _
        ByVal node As ID2D1TransformNode Ptr _
    ) As HRESULT
    
    ' 8. SetOutputNode
    Declare Abstract Function SetOutputNode Stdcall ( _
        ByVal node As ID2D1TransformNode Ptr _
    ) As HRESULT
    
    ' 9. ConnectNode
    Declare Abstract Function ConnectNode Stdcall ( _
        ByVal from_node As ID2D1TransformNode Ptr, _
        ByVal to_node As ID2D1TransformNode Ptr, _
        ByVal index As ULong _
    ) As HRESULT
    
    ' 10. ConnectToEffectInput
    Declare Abstract Function ConnectToEffectInput Stdcall ( _
        ByVal input_index As ULong, _
        ByVal node As ID2D1TransformNode Ptr, _
        ByVal node_index As ULong _
    ) As HRESULT
    
    ' 11. Clear
    Declare Abstract Sub Clear Stdcall ()
    
    ' 12. SetPassthroughGraph
    Declare Abstract Function SetPassthroughGraph Stdcall ( _
        ByVal index As ULong _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1Transform
' ============================================================================
Type ID2D1Transform Extends ID2D1TransformNode
    ' 1-4: ID2D1TransformNode
    
    ' 5. MapOutputRectToInputRects
    Declare Abstract Function MapOutputRectToInputRects Stdcall ( _
        ByVal output_rect As D2D1_RECT_L Ptr, _
        ByVal input_rects As D2D1_RECT_L Ptr, _
        ByVal input_rects_count As ULong _
    ) As HRESULT
    
    ' 6. MapInputRectsToOutputRect
    Declare Abstract Function MapInputRectsToOutputRect Stdcall ( _
        ByVal input_rects As D2D1_RECT_L Ptr, _
        ByVal input_opaque_rects As D2D1_RECT_L Ptr, _
        ByVal input_rect_count As ULong, _
        ByVal output_rect As D2D1_RECT_L Ptr, _
        ByVal output_opaque_rect As D2D1_RECT_L Ptr _
    ) As HRESULT
    
    ' 7. MapInvalidRect
    Declare Abstract Function MapInvalidRect Stdcall ( _
        ByVal index As ULong, _
        ByVal input_rect As D2D1_RECT_L, _
        ByVal output_rect As D2D1_RECT_L Ptr _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1DrawTransform
' ============================================================================
Type ID2D1DrawTransform Extends ID2D1Transform
    ' 1-7: ID2D1Transform
    
    ' 8. SetDrawInfo
    Declare Abstract Function SetDrawInfo Stdcall ( _
        ByVal info As ID2D1DrawInfo Ptr _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1ComputeTransform
' ============================================================================
Type ID2D1ComputeTransform Extends ID2D1Transform
    ' 1-7: ID2D1Transform
    
    ' 8. SetComputeInfo
    Declare Abstract Function SetComputeInfo Stdcall ( _
        ByVal info As ID2D1ComputeInfo Ptr _
    ) As HRESULT
    
    ' 9. CalculateThreadgroups
    Declare Abstract Function CalculateThreadgroups Stdcall ( _
        ByVal output_rect As D2D1_RECT_L Ptr, _
        ByVal dimension_x As ULong Ptr, _
        ByVal dimension_y As ULong Ptr, _
        ByVal dimension_z As ULong Ptr _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1AnalysisTransform
' ============================================================================
Type ID2D1AnalysisTransform Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. ProcessAnalysisResults
    Declare Abstract Function ProcessAnalysisResults Stdcall ( _
        ByVal data As UByte Ptr, _
        ByVal size As ULong _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1SourceTransform
' ============================================================================
Type ID2D1SourceTransform Extends ID2D1Transform
    ' 1-7: ID2D1Transform
    
    ' 8. SetRenderInfo
    Declare Abstract Function SetRenderInfo Stdcall ( _
        ByVal info As ID2D1RenderInfo Ptr _
    ) As HRESULT
    
    ' 9. Draw
    Declare Abstract Function Draw Stdcall ( _
        ByVal target As ID2D1Bitmap1 Ptr, _
        ByVal draw_rect As D2D1_RECT_L Ptr, _
        ByVal target_origin As D2D1_POINT_2U _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1ConcreteTransform
' ============================================================================
Type ID2D1ConcreteTransform Extends ID2D1TransformNode
    ' 1-4: ID2D1TransformNode
    
    ' 5. SetOutputBuffer
    Declare Abstract Function SetOutputBuffer Stdcall ( _
        ByVal precision As D2D1_BUFFER_PRECISION, _
        ByVal depth As D2D1_CHANNEL_DEPTH _
    ) As HRESULT
    
    ' 6. SetCached
    Declare Abstract Sub SetCached Stdcall ( _
        ByVal is_cached As Long _
    )
End Type

' ============================================================================
' ID2D1BlendTransform
' ============================================================================
Type ID2D1BlendTransform Extends ID2D1ConcreteTransform
    ' 1-6: ID2D1ConcreteTransform
    
    ' 7. SetDescription
    Declare Abstract Sub SetDescription Stdcall ( _
        ByVal description As D2D1_BLEND_DESCRIPTION Ptr _
    )
    
    ' 8. GetDescription
    Declare Abstract Sub GetDescription Stdcall ( _
        ByVal description As D2D1_BLEND_DESCRIPTION Ptr _
    )
End Type

' ============================================================================
' ID2D1BorderTransform
' ============================================================================
Type ID2D1BorderTransform Extends ID2D1ConcreteTransform
    ' 1-6: ID2D1ConcreteTransform
    
    ' 7. SetExtendModeX
    Declare Abstract Sub SetExtendModeX Stdcall ( _
        ByVal mode As D2D1_EXTEND_MODE _
    )
    
    ' 8. SetExtendModeY
    Declare Abstract Sub SetExtendModeY Stdcall ( _
        ByVal mode As D2D1_EXTEND_MODE _
    )
    
    ' 9. GetExtendModeX
    Declare Abstract Function GetExtendModeX Stdcall () As D2D1_EXTEND_MODE
    
    ' 10. GetExtendModeY
    Declare Abstract Function GetExtendModeY Stdcall () As D2D1_EXTEND_MODE
End Type

' ============================================================================
' ID2D1OffsetTransform
' ============================================================================
Type ID2D1OffsetTransform Extends ID2D1TransformNode
    ' 1-4: ID2D1TransformNode
    
    ' 5. SetOffset
    Declare Abstract Sub SetOffset Stdcall ( _
        ByVal offset As D2D1_POINT_2L _
    )
    
    ' 6. GetOffset
    Declare Abstract Function GetOffset Stdcall () As D2D1_POINT_2L
End Type

' ============================================================================
' ID2D1BoundsAdjustmentTransform
' ============================================================================
Type ID2D1BoundsAdjustmentTransform Extends ID2D1TransformNode
    ' 1-4: ID2D1TransformNode
    
    ' 5. SetOutputBounds
    Declare Abstract Sub SetOutputBounds Stdcall ( _
        ByVal bounds As D2D1_RECT_L Ptr _
    )
    
    ' 6. GetOutputBounds
    Declare Abstract Sub GetOutputBounds Stdcall ( _
        ByVal bounds As D2D1_RECT_L Ptr _
    )
End Type

' ============================================================================
' ID2D1EffectContext
' ============================================================================
Type ID2D1EffectContext Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. GetDpi
    Declare Abstract Sub GetDpi Stdcall ( _
        ByVal dpi_x As Single Ptr, _
        ByVal dpi_y As Single Ptr _
    )
    
    ' 5. CreateEffect
    Declare Abstract Function CreateEffect Stdcall ( _
        ByRef clsid As GUID, _
        ByVal effect As Any Ptr Ptr _
    ) As HRESULT
    
    ' 6. GetMaximumSupportedFeatureLevel
    Declare Abstract Function GetMaximumSupportedFeatureLevel Stdcall ( _
        ByVal levels As ULong Ptr, _
        ByVal level_count As ULong, _
        ByVal max_level As ULong Ptr _
    ) As HRESULT
    
    ' 7. CreateTransformNodeFromEffect
    Declare Abstract Function CreateTransformNodeFromEffect Stdcall ( _
        ByVal effect As Any Ptr, _
        ByVal node As Any Ptr Ptr _
    ) As HRESULT
    
    ' 8. CreateBlendTransform
    Declare Abstract Function CreateBlendTransform Stdcall ( _
        ByVal num_inputs As ULong, _
        ByVal description As D2D1_BLEND_DESCRIPTION Ptr, _
        ByVal transform As Any Ptr Ptr _
    ) As HRESULT
    
    ' 9. CreateBorderTransform
    Declare Abstract Function CreateBorderTransform Stdcall ( _
        ByVal mode_x As D2D1_EXTEND_MODE, _
        ByVal mode_y As D2D1_EXTEND_MODE, _
        ByVal transform As Any Ptr Ptr _
    ) As HRESULT
    
    ' 10. CreateOffsetTransform
    Declare Abstract Function CreateOffsetTransform Stdcall ( _
        ByVal offset As D2D1_POINT_2L, _
        ByVal transform As Any Ptr Ptr _
    ) As HRESULT
    
    ' 11. CreateBoundsAdjustmentTransform
    Declare Abstract Function CreateBoundsAdjustmentTransform Stdcall ( _
        ByVal output_rect As D2D1_RECT_L Ptr, _
        ByVal transform As Any Ptr Ptr _
    ) As HRESULT
    
    ' 12. LoadPixelShader
    Declare Abstract Function LoadPixelShader Stdcall ( _
        ByRef shader_id As GUID, _
        ByVal buffer As UByte Ptr, _
        ByVal buffer_size As ULong _
    ) As HRESULT
    
    ' 13. LoadVertexShader
    Declare Abstract Function LoadVertexShader Stdcall ( _
        ByRef shader_id As GUID, _
        ByVal buffer As UByte Ptr, _
        ByVal buffer_size As ULong _
    ) As HRESULT
    
    ' 14. LoadComputeShader
    Declare Abstract Function LoadComputeShader Stdcall ( _
        ByRef shader_id As GUID, _
        ByVal buffer As UByte Ptr, _
        ByVal buffer_size As ULong _
    ) As HRESULT
    
    ' 15. IsShaderLoaded
    Declare Abstract Function IsShaderLoaded Stdcall ( _
        ByRef shader_id As GUID _
    ) As Long
    
    ' 16. CreateResourceTexture
    Declare Abstract Function CreateResourceTexture Stdcall ( _
        ByVal id As GUID Ptr, _
        ByVal texture_properties As D2D1_RESOURCE_TEXTURE_PROPERTIES Ptr, _
        ByVal data As UByte Ptr, _
        ByVal strides As ULong Ptr, _
        ByVal data_size As ULong, _
        ByVal texture As Any Ptr Ptr _
    ) As HRESULT
    
    ' 17. FindResourceTexture
    Declare Abstract Function FindResourceTexture Stdcall ( _
        ByVal id As GUID Ptr, _
        ByVal texture As Any Ptr Ptr _
    ) As HRESULT
    
    ' 18. CreateVertexBuffer
    Declare Abstract Function CreateVertexBuffer Stdcall ( _
        ByVal buffer_properties As D2D1_VERTEX_BUFFER_PROPERTIES Ptr, _
        ByVal id As GUID Ptr, _
        ByVal custom_buffer_properties As D2D1_CUSTOM_VERTEX_BUFFER_PROPERTIES Ptr, _
        ByVal buffer As Any Ptr Ptr _
    ) As HRESULT
    
    ' 19. FindVertexBuffer
    Declare Abstract Function FindVertexBuffer Stdcall ( _
        ByVal id As GUID Ptr, _
        ByVal buffer As Any Ptr Ptr _
    ) As HRESULT
    
    ' 20. CreateColorContext
    Declare Abstract Function CreateColorContext Stdcall ( _
        ByVal space As D2D1_COLOR_SPACE, _
        ByVal profile As UByte Ptr, _
        ByVal profile_size As ULong, _
        ByVal color_context As Any Ptr Ptr _
    ) As HRESULT
    
    ' 21. CreateColorContextFromFilename
    Declare Abstract Function CreateColorContextFromFilename Stdcall ( _
        ByVal filename As WString Ptr, _
        ByVal color_context As Any Ptr Ptr _
    ) As HRESULT
    
    ' 22. CreateColorContextFromWicColorContext
    Declare Abstract Function CreateColorContextFromWicColorContext Stdcall ( _
        ByVal wic_color_context As Any Ptr, _
        ByVal color_context As Any Ptr Ptr _
    ) As HRESULT
    
    ' 23. CheckFeatureSupport
    Declare Abstract Function CheckFeatureSupport Stdcall ( _
        ByVal feature As D2D1_FEATURE, _
        ByVal data As Any Ptr, _
        ByVal data_size As ULong _
    ) As HRESULT
    
    ' 24. IsBufferPrecisionSupported
    Declare Abstract Function IsBufferPrecisionSupported Stdcall ( _
        ByVal precision As D2D1_BUFFER_PRECISION _
    ) As Long
End Type

' ============================================================================
' ID2D1EffectImpl
' ============================================================================
Type ID2D1EffectImpl Extends IUnknownBase
    ' 1-3: IUnknown
    
    ' 4. Initialize
    Declare Abstract Function Initialize Stdcall ( _
        ByVal context As ID2D1EffectContext Ptr, _
        ByVal graph As ID2D1TransformGraph Ptr _
    ) As HRESULT
    
    ' 5. PrepareForRender
    Declare Abstract Function PrepareForRender Stdcall ( _
        ByVal change_type As D2D1_CHANGE_TYPE _
    ) As HRESULT
    
    ' 6. SetGraph
    Declare Abstract Function SetGraph Stdcall ( _
        ByVal graph As ID2D1TransformGraph Ptr _
    ) As HRESULT
End Type