'###############################################################################
' This file is part of MyFBFramework
' Authors: UEZ, Xusinboy Bekchanov, Liu XiaLin
' Based on UEZ's abstract version.
' Direct2D 1.2 API - FreeBASIC Translation
' Adapted by Xusinboy Bekchanov, Liu XiaLin
'###############################################################################
#pragma once
#include once "d2d1_1.bi"
' ============================================================================
' Callback Function Types
' ============================================================================
'Type PD2D1_PROPERTY_SET_FUNCTION As Function ( '    ByVal effect As IUnknown Ptr, '    ByVal data As UByte Ptr, '    ByVal data_size As ULong ') As HRESULT
'Type PD2D1_PROPERTY_GET_FUNCTION As Function ( '    ByVal effect As IUnknown Ptr, '    ByVal data As UByte Ptr, '    ByVal data_size As ULong, '    ByVal actual_size As ULong Ptr ') As HRESULT
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
Type ID2D1VertexBufferVtbl As ID2D1VertexBufferVtbl_
Type ID2D1VertexBuffer
    lpVtbl As ID2D1VertexBufferVtbl Ptr
End Type
Type ID2D1VertexBufferVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As ID2D1VertexBuffer Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1VertexBuffer Ptr) As ULong
    Release As Function(ByVal This As ID2D1VertexBuffer Ptr) As ULong

        
    Map As Function(ByVal This As ID2D1VertexBuffer Ptr,  ByVal data As UByte Ptr Ptr, ByVal size As ULong ) As HRESULT
        ' 5. Unmap
    Unmap As Function(ByVal This As ID2D1VertexBuffer Ptr) As HRESULT
End Type
#define ID2D1VertexBuffer_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1VertexBuffer_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1VertexBuffer_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1VertexBuffer_Map(p, a, b) (p)->lpVtbl->Map(p, a, b)
#define ID2D1VertexBuffer_Unmap(p, a) (p)->lpVtbl->Unmap(p, a)

' ============================================================================
' ID2D1ResourceTexture
' ============================================================================
Type ID2D1ResourceTextureVtbl As ID2D1ResourceTextureVtbl_
Type ID2D1ResourceTexture
    lpVtbl As ID2D1ResourceTextureVtbl Ptr
End Type
Type ID2D1ResourceTextureVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As ID2D1ResourceTexture Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1ResourceTexture Ptr) As ULong
    Release As Function(ByVal This As ID2D1ResourceTexture Ptr) As ULong

        
    Update As Function(ByVal This As ID2D1ResourceTexture Ptr,  ByVal min_extents As ULong Ptr, ByVal max_extents As ULong Ptr, ByVal strides As ULong Ptr, ByVal dimensions As ULong, ByVal data As UByte Ptr, ByVal data_size As ULong ) As HRESULT
End Type
#define ID2D1ResourceTexture_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1ResourceTexture_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1ResourceTexture_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1ResourceTexture_Update(p, a, b, c, d, e, f) (p)->lpVtbl->Update(p, a, b, c, d, e, f)

' ============================================================================
' ID2D1RenderInfo
' ============================================================================
Type ID2D1RenderInfoVtbl As ID2D1RenderInfoVtbl_
Type ID2D1RenderInfo
    lpVtbl As ID2D1RenderInfoVtbl Ptr
End Type
Type ID2D1RenderInfoVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As ID2D1RenderInfo Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1RenderInfo Ptr) As ULong
    Release As Function(ByVal This As ID2D1RenderInfo Ptr) As ULong

        
    SetInputDescription As Function(ByVal This As ID2D1RenderInfo Ptr,  ByVal index As ULong, ByVal description As D2D1_INPUT_DESCRIPTION ) As HRESULT
        ' 5. SetOutputBuffer
    SetOutputBuffer As Function(ByVal This As ID2D1RenderInfo Ptr,  ByVal precision As D2D1_BUFFER_PRECISION, ByVal depth As D2D1_CHANNEL_DEPTH ) As HRESULT
        ' 6. SetCached
    SetCached As Sub(ByVal This As ID2D1RenderInfo Ptr,  ByVal is_cached As Long )
        ' 7. SetInstructionCountHint
    SetInstructionCountHint As Sub(ByVal This As ID2D1RenderInfo Ptr,  ByVal count As ULong )
End Type
#define ID2D1RenderInfo_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1RenderInfo_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1RenderInfo_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1RenderInfo_SetInputDescription(p, a, b) (p)->lpVtbl->SetInputDescription(p, a, b)
#define ID2D1RenderInfo_SetOutputBuffer(p, a, b) (p)->lpVtbl->SetOutputBuffer(p, a, b)
#define ID2D1RenderInfo_SetCached(p, a) (p)->lpVtbl->SetCached(p, a)
#define ID2D1RenderInfo_SetInstructionCountHint(p, a) (p)->lpVtbl->SetInstructionCountHint(p, a)

' ============================================================================
' ID2D1DrawInfo
' ============================================================================
Type ID2D1DrawInfoVtbl As ID2D1DrawInfoVtbl_
Type ID2D1DrawInfo
    lpVtbl As ID2D1DrawInfoVtbl Ptr
End Type
Type ID2D1DrawInfoVtbl_     '' Extends ID2D1RenderInfoVtbl_
    QueryInterface As Function(ByVal This As ID2D1DrawInfo Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1DrawInfo Ptr) As ULong
    Release As Function(ByVal This As ID2D1DrawInfo Ptr) As ULong
        
    SetInputDescription As Function(ByVal This As ID2D1DrawInfo Ptr,  ByVal index As ULong, ByVal description As D2D1_INPUT_DESCRIPTION ) As HRESULT
        ' 5. SetOutputBuffer
    SetOutputBuffer As Function(ByVal This As ID2D1DrawInfo Ptr,  ByVal precision As D2D1_BUFFER_PRECISION, ByVal depth As D2D1_CHANNEL_DEPTH ) As HRESULT
        ' 6. SetCached
    SetCached As Sub(ByVal This As ID2D1DrawInfo Ptr,  ByVal is_cached As Long )
        ' 7. SetInstructionCountHint
    SetInstructionCountHint As Sub(ByVal This As ID2D1DrawInfo Ptr,  ByVal count As ULong )

        
    SetPixelShaderConstantBuffer As Function(ByVal This As ID2D1DrawInfo Ptr,  ByVal buffer As UByte Ptr, ByVal size As ULong ) As HRESULT
        ' 9. SetResourceTexture
    SetResourceTexture As Function(ByVal This As ID2D1DrawInfo Ptr,  ByVal index As ULong, ByVal texture As ID2D1ResourceTexture Ptr ) As HRESULT
        ' 10. SetVertexShaderConstantBuffer
    SetVertexShaderConstantBuffer As Function(ByVal This As ID2D1DrawInfo Ptr,  ByVal buffer As UByte Ptr, ByVal size As ULong ) As HRESULT
        ' 11. SetPixelShader
    SetPixelShader As Function(ByVal This As ID2D1DrawInfo Ptr,  ByRef id As GUID, ByVal options As D2D1_PIXEL_OPTIONS ) As HRESULT
        ' 12. SetVertexProcessing
    SetVertexProcessing As Function(ByVal This As ID2D1DrawInfo Ptr,  ByVal buffer As ID2D1VertexBuffer Ptr, ByVal options As D2D1_VERTEX_OPTIONS, ByVal description As D2D1_BLEND_DESCRIPTION Ptr, ByVal range As D2D1_VERTEX_RANGE Ptr, ByVal shader As GUID Ptr ) As HRESULT
End Type
#define ID2D1DrawInfo_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1DrawInfo_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1DrawInfo_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1DrawInfo_SetInputDescription(p, a, b) (p)->lpVtbl->SetInputDescription(p, a, b)
#define ID2D1DrawInfo_SetOutputBuffer(p, a, b) (p)->lpVtbl->SetOutputBuffer(p, a, b)
#define ID2D1DrawInfo_SetCached(p, a) (p)->lpVtbl->SetCached(p, a)
#define ID2D1DrawInfo_SetInstructionCountHint(p, a) (p)->lpVtbl->SetInstructionCountHint(p, a)
#define ID2D1DrawInfo_SetPixelShaderConstantBuffer(p, a, b) (p)->lpVtbl->SetPixelShaderConstantBuffer(p, a, b)
#define ID2D1DrawInfo_SetResourceTexture(p, a, b) (p)->lpVtbl->SetResourceTexture(p, a, b)
#define ID2D1DrawInfo_SetVertexShaderConstantBuffer(p, a, b) (p)->lpVtbl->SetVertexShaderConstantBuffer(p, a, b)
#define ID2D1DrawInfo_SetPixelShader(p, a, b) (p)->lpVtbl->SetPixelShader(p, a, b)
#define ID2D1DrawInfo_SetVertexProcessing(p, a, b, c, d, e) (p)->lpVtbl->SetVertexProcessing(p, a, b, c, d, e)

' ============================================================================
' ID2D1ComputeInfo
' ============================================================================
Type ID2D1ComputeInfoVtbl As ID2D1ComputeInfoVtbl_
Type ID2D1ComputeInfo
    lpVtbl As ID2D1ComputeInfoVtbl Ptr
End Type
Type ID2D1ComputeInfoVtbl_     '' Extends ID2D1RenderInfoVtbl_
    QueryInterface As Function(ByVal This As ID2D1ComputeInfo Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1ComputeInfo Ptr) As ULong
    Release As Function(ByVal This As ID2D1ComputeInfo Ptr) As ULong
        
    SetInputDescription As Function(ByVal This As ID2D1ComputeInfo Ptr,  ByVal index As ULong, ByVal description As D2D1_INPUT_DESCRIPTION ) As HRESULT
        ' 5. SetOutputBuffer
    SetOutputBuffer As Function(ByVal This As ID2D1ComputeInfo Ptr,  ByVal precision As D2D1_BUFFER_PRECISION, ByVal depth As D2D1_CHANNEL_DEPTH ) As HRESULT
        ' 6. SetCached
    SetCached As Sub(ByVal This As ID2D1ComputeInfo Ptr,  ByVal is_cached As Long )
        ' 7. SetInstructionCountHint
    SetInstructionCountHint As Sub(ByVal This As ID2D1ComputeInfo Ptr,  ByVal count As ULong )

        
    SetComputeShaderConstantBuffer As Function(ByVal This As ID2D1ComputeInfo Ptr,  ByVal buffer As UByte Ptr, ByVal size As ULong ) As HRESULT
        ' 9. SetComputeShader
    SetComputeShader As Function(ByVal This As ID2D1ComputeInfo Ptr,  ByRef id As GUID ) As HRESULT
        ' 10. SetResourceTexture
    SetResourceTexture As Function(ByVal This As ID2D1ComputeInfo Ptr,  ByVal index As ULong, ByVal texture As ID2D1ResourceTexture Ptr ) As HRESULT
End Type
#define ID2D1ComputeInfo_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1ComputeInfo_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1ComputeInfo_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1ComputeInfo_SetInputDescription(p, a, b) (p)->lpVtbl->SetInputDescription(p, a, b)
#define ID2D1ComputeInfo_SetOutputBuffer(p, a, b) (p)->lpVtbl->SetOutputBuffer(p, a, b)
#define ID2D1ComputeInfo_SetCached(p, a) (p)->lpVtbl->SetCached(p, a)
#define ID2D1ComputeInfo_SetInstructionCountHint(p, a) (p)->lpVtbl->SetInstructionCountHint(p, a)
#define ID2D1ComputeInfo_SetComputeShaderConstantBuffer(p, a, b) (p)->lpVtbl->SetComputeShaderConstantBuffer(p, a, b)
#define ID2D1ComputeInfo_SetComputeShader(p, a) (p)->lpVtbl->SetComputeShader(p, a)
#define ID2D1ComputeInfo_SetResourceTexture(p, a, b) (p)->lpVtbl->SetResourceTexture(p, a, b)

' ============================================================================
' ID2D1TransformNode
' ============================================================================
Type ID2D1TransformNodeVtbl As ID2D1TransformNodeVtbl_
Type ID2D1TransformNode
    lpVtbl As ID2D1TransformNodeVtbl Ptr
End Type
Type ID2D1TransformNodeVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As ID2D1TransformNode Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1TransformNode Ptr) As ULong
    Release As Function(ByVal This As ID2D1TransformNode Ptr) As ULong

        
    GetInputCount As Function(ByVal This As ID2D1TransformNode Ptr) As ULong
End Type
#define ID2D1TransformNode_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1TransformNode_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1TransformNode_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1TransformNode_GetInputCount(p, a) (p)->lpVtbl->GetInputCount(p, a)

' ============================================================================
' ID2D1TransformGraph
' ============================================================================
Type ID2D1TransformGraphVtbl As ID2D1TransformGraphVtbl_
Type ID2D1TransformGraph
    lpVtbl As ID2D1TransformGraphVtbl Ptr
End Type
Type ID2D1TransformGraphVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As ID2D1TransformGraph Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1TransformGraph Ptr) As ULong
    Release As Function(ByVal This As ID2D1TransformGraph Ptr) As ULong

        
    GetInputCount As Function(ByVal This As ID2D1TransformGraph Ptr) As ULong
        ' 5. SetSingleTransformNode
    SetSingleTransformNode As Function(ByVal This As ID2D1TransformGraph Ptr,  ByVal node As ID2D1TransformNode Ptr ) As HRESULT
        ' 6. AddNode
    AddNode As Function(ByVal This As ID2D1TransformGraph Ptr,  ByVal node As ID2D1TransformNode Ptr ) As HRESULT
        ' 7. RemoveNode
    RemoveNode As Function(ByVal This As ID2D1TransformGraph Ptr,  ByVal node As ID2D1TransformNode Ptr ) As HRESULT
        ' 8. SetOutputNode
    SetOutputNode As Function(ByVal This As ID2D1TransformGraph Ptr,  ByVal node As ID2D1TransformNode Ptr ) As HRESULT
        ' 9. ConnectNode
    ConnectNode As Function(ByVal This As ID2D1TransformGraph Ptr,  ByVal from_node As ID2D1TransformNode Ptr, ByVal to_node As ID2D1TransformNode Ptr, ByVal index As ULong ) As HRESULT
        ' 10. ConnectToEffectInput
    ConnectToEffectInput As Function(ByVal This As ID2D1TransformGraph Ptr,  ByVal input_index As ULong, ByVal node As ID2D1TransformNode Ptr, ByVal node_index As ULong ) As HRESULT
        ' 11. Clear
    Clear As Sub(ByVal This As ID2D1TransformGraph Ptr)
        ' 12. SetPassthroughGraph
    SetPassthroughGraph As Function(ByVal This As ID2D1TransformGraph Ptr,  ByVal index As ULong ) As HRESULT
End Type
#define ID2D1TransformGraph_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1TransformGraph_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1TransformGraph_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1TransformGraph_GetInputCount(p, a) (p)->lpVtbl->GetInputCount(p, a)
#define ID2D1TransformGraph_SetSingleTransformNode(p, a) (p)->lpVtbl->SetSingleTransformNode(p, a)
#define ID2D1TransformGraph_AddNode(p, a) (p)->lpVtbl->AddNode(p, a)
#define ID2D1TransformGraph_RemoveNode(p, a) (p)->lpVtbl->RemoveNode(p, a)
#define ID2D1TransformGraph_SetOutputNode(p, a) (p)->lpVtbl->SetOutputNode(p, a)
#define ID2D1TransformGraph_ConnectNode(p, a, b, c) (p)->lpVtbl->ConnectNode(p, a, b, c)
#define ID2D1TransformGraph_ConnectToEffectInput(p, a, b, c) (p)->lpVtbl->ConnectToEffectInput(p, a, b, c)
#define ID2D1TransformGraph_Clear(p, a) (p)->lpVtbl->Clear(p, a)
#define ID2D1TransformGraph_SetPassthroughGraph(p, a) (p)->lpVtbl->SetPassthroughGraph(p, a)

' ============================================================================
' ID2D1Transform
' ============================================================================
Type ID2D1TransformVtbl As ID2D1TransformVtbl_
Type ID2D1Transform
    lpVtbl As ID2D1TransformVtbl Ptr
End Type
Type ID2D1TransformVtbl_     '' Extends ID2D1TransformNodeVtbl_
    QueryInterface As Function(ByVal This As ID2D1Transform Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Transform Ptr) As ULong
    Release As Function(ByVal This As ID2D1Transform Ptr) As ULong
        
    GetInputCount As Function(ByVal This As ID2D1Transform Ptr) As ULong

        
    MapOutputRectToInputRects As Function(ByVal This As ID2D1Transform Ptr,  ByVal output_rect As D2D1_RECT_L Ptr, ByVal input_rects As D2D1_RECT_L Ptr, ByVal input_rects_count As ULong ) As HRESULT
        ' 6. MapInputRectsToOutputRect
    MapInputRectsToOutputRect As Function(ByVal This As ID2D1Transform Ptr,  ByVal input_rects As D2D1_RECT_L Ptr, ByVal input_opaque_rects As D2D1_RECT_L Ptr, ByVal input_rect_count As ULong, ByVal output_rect As D2D1_RECT_L Ptr, ByVal output_opaque_rect As D2D1_RECT_L Ptr ) As HRESULT
        ' 7. MapInvalidRect
    MapInvalidRect As Function(ByVal This As ID2D1Transform Ptr,  ByVal index As ULong, ByVal input_rect As D2D1_RECT_L, ByVal output_rect As D2D1_RECT_L Ptr ) As HRESULT
End Type
#define ID2D1Transform_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Transform_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Transform_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Transform_GetInputCount(p, a) (p)->lpVtbl->GetInputCount(p, a)
#define ID2D1Transform_MapOutputRectToInputRects(p, a, b, c) (p)->lpVtbl->MapOutputRectToInputRects(p, a, b, c)
#define ID2D1Transform_MapInputRectsToOutputRect(p, a, b, c, d, e) (p)->lpVtbl->MapInputRectsToOutputRect(p, a, b, c, d, e)
#define ID2D1Transform_MapInvalidRect(p, a, b, c) (p)->lpVtbl->MapInvalidRect(p, a, b, c)

' ============================================================================
' ID2D1DrawTransform
' ============================================================================
Type ID2D1DrawTransformVtbl As ID2D1DrawTransformVtbl_
Type ID2D1DrawTransform
    lpVtbl As ID2D1DrawTransformVtbl Ptr
End Type
Type ID2D1DrawTransformVtbl_     '' Extends ID2D1TransformVtbl_
    QueryInterface As Function(ByVal This As ID2D1DrawTransform Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1DrawTransform Ptr) As ULong
    Release As Function(ByVal This As ID2D1DrawTransform Ptr) As ULong
        
    GetInputCount As Function(ByVal This As ID2D1DrawTransform Ptr) As ULong
        
    MapOutputRectToInputRects As Function(ByVal This As ID2D1DrawTransform Ptr,  ByVal output_rect As D2D1_RECT_L Ptr, ByVal input_rects As D2D1_RECT_L Ptr, ByVal input_rects_count As ULong ) As HRESULT
        ' 6. MapInputRectsToOutputRect
    MapInputRectsToOutputRect As Function(ByVal This As ID2D1DrawTransform Ptr,  ByVal input_rects As D2D1_RECT_L Ptr, ByVal input_opaque_rects As D2D1_RECT_L Ptr, ByVal input_rect_count As ULong, ByVal output_rect As D2D1_RECT_L Ptr, ByVal output_opaque_rect As D2D1_RECT_L Ptr ) As HRESULT
        ' 7. MapInvalidRect
    MapInvalidRect As Function(ByVal This As ID2D1DrawTransform Ptr,  ByVal index As ULong, ByVal input_rect As D2D1_RECT_L, ByVal output_rect As D2D1_RECT_L Ptr ) As HRESULT

        
    SetDrawInfo As Function(ByVal This As ID2D1DrawTransform Ptr,  ByVal info As ID2D1DrawInfo Ptr ) As HRESULT
End Type
#define ID2D1DrawTransform_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1DrawTransform_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1DrawTransform_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1DrawTransform_GetInputCount(p, a) (p)->lpVtbl->GetInputCount(p, a)
#define ID2D1DrawTransform_MapOutputRectToInputRects(p, a, b, c) (p)->lpVtbl->MapOutputRectToInputRects(p, a, b, c)
#define ID2D1DrawTransform_MapInputRectsToOutputRect(p, a, b, c, d, e) (p)->lpVtbl->MapInputRectsToOutputRect(p, a, b, c, d, e)
#define ID2D1DrawTransform_MapInvalidRect(p, a, b, c) (p)->lpVtbl->MapInvalidRect(p, a, b, c)
#define ID2D1DrawTransform_SetDrawInfo(p, a) (p)->lpVtbl->SetDrawInfo(p, a)

' ============================================================================
' ID2D1ComputeTransform
' ============================================================================
Type ID2D1ComputeTransformVtbl As ID2D1ComputeTransformVtbl_
Type ID2D1ComputeTransform
    lpVtbl As ID2D1ComputeTransformVtbl Ptr
End Type
Type ID2D1ComputeTransformVtbl_     '' Extends ID2D1TransformVtbl_
    QueryInterface As Function(ByVal This As ID2D1ComputeTransform Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1ComputeTransform Ptr) As ULong
    Release As Function(ByVal This As ID2D1ComputeTransform Ptr) As ULong
        
    GetInputCount As Function(ByVal This As ID2D1ComputeTransform Ptr) As ULong
        
    MapOutputRectToInputRects As Function(ByVal This As ID2D1ComputeTransform Ptr,  ByVal output_rect As D2D1_RECT_L Ptr, ByVal input_rects As D2D1_RECT_L Ptr, ByVal input_rects_count As ULong ) As HRESULT
        ' 6. MapInputRectsToOutputRect
    MapInputRectsToOutputRect As Function(ByVal This As ID2D1ComputeTransform Ptr,  ByVal input_rects As D2D1_RECT_L Ptr, ByVal input_opaque_rects As D2D1_RECT_L Ptr, ByVal input_rect_count As ULong, ByVal output_rect As D2D1_RECT_L Ptr, ByVal output_opaque_rect As D2D1_RECT_L Ptr ) As HRESULT
        ' 7. MapInvalidRect
    MapInvalidRect As Function(ByVal This As ID2D1ComputeTransform Ptr,  ByVal index As ULong, ByVal input_rect As D2D1_RECT_L, ByVal output_rect As D2D1_RECT_L Ptr ) As HRESULT

        
    SetComputeInfo As Function(ByVal This As ID2D1ComputeTransform Ptr,  ByVal info As ID2D1ComputeInfo Ptr ) As HRESULT
        ' 9. CalculateThreadgroups
    CalculateThreadgroups As Function(ByVal This As ID2D1ComputeTransform Ptr,  ByVal output_rect As D2D1_RECT_L Ptr, ByVal dimension_x As ULong Ptr, ByVal dimension_y As ULong Ptr, ByVal dimension_z As ULong Ptr ) As HRESULT
End Type
#define ID2D1ComputeTransform_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1ComputeTransform_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1ComputeTransform_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1ComputeTransform_GetInputCount(p, a) (p)->lpVtbl->GetInputCount(p, a)
#define ID2D1ComputeTransform_MapOutputRectToInputRects(p, a, b, c) (p)->lpVtbl->MapOutputRectToInputRects(p, a, b, c)
#define ID2D1ComputeTransform_MapInputRectsToOutputRect(p, a, b, c, d, e) (p)->lpVtbl->MapInputRectsToOutputRect(p, a, b, c, d, e)
#define ID2D1ComputeTransform_MapInvalidRect(p, a, b, c) (p)->lpVtbl->MapInvalidRect(p, a, b, c)
#define ID2D1ComputeTransform_SetComputeInfo(p, a) (p)->lpVtbl->SetComputeInfo(p, a)
#define ID2D1ComputeTransform_CalculateThreadgroups(p, a, b, c, d) (p)->lpVtbl->CalculateThreadgroups(p, a, b, c, d)

' ============================================================================
' ID2D1AnalysisTransform
' ============================================================================
Type ID2D1AnalysisTransformVtbl As ID2D1AnalysisTransformVtbl_
Type ID2D1AnalysisTransform
    lpVtbl As ID2D1AnalysisTransformVtbl Ptr
End Type
Type ID2D1AnalysisTransformVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As ID2D1AnalysisTransform Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1AnalysisTransform Ptr) As ULong
    Release As Function(ByVal This As ID2D1AnalysisTransform Ptr) As ULong

        
    ProcessAnalysisResults As Function(ByVal This As ID2D1AnalysisTransform Ptr,  ByVal data As UByte Ptr, ByVal size As ULong ) As HRESULT
End Type
#define ID2D1AnalysisTransform_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1AnalysisTransform_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1AnalysisTransform_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1AnalysisTransform_ProcessAnalysisResults(p, a, b) (p)->lpVtbl->ProcessAnalysisResults(p, a, b)

' ============================================================================
' ID2D1SourceTransform
' ============================================================================
Type ID2D1SourceTransformVtbl As ID2D1SourceTransformVtbl_
Type ID2D1SourceTransform
    lpVtbl As ID2D1SourceTransformVtbl Ptr
End Type
Type ID2D1SourceTransformVtbl_     '' Extends ID2D1TransformVtbl_
    QueryInterface As Function(ByVal This As ID2D1SourceTransform Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1SourceTransform Ptr) As ULong
    Release As Function(ByVal This As ID2D1SourceTransform Ptr) As ULong
        
    GetInputCount As Function(ByVal This As ID2D1SourceTransform Ptr) As ULong
        
    MapOutputRectToInputRects As Function(ByVal This As ID2D1SourceTransform Ptr,  ByVal output_rect As D2D1_RECT_L Ptr, ByVal input_rects As D2D1_RECT_L Ptr, ByVal input_rects_count As ULong ) As HRESULT
        ' 6. MapInputRectsToOutputRect
    MapInputRectsToOutputRect As Function(ByVal This As ID2D1SourceTransform Ptr,  ByVal input_rects As D2D1_RECT_L Ptr, ByVal input_opaque_rects As D2D1_RECT_L Ptr, ByVal input_rect_count As ULong, ByVal output_rect As D2D1_RECT_L Ptr, ByVal output_opaque_rect As D2D1_RECT_L Ptr ) As HRESULT
        ' 7. MapInvalidRect
    MapInvalidRect As Function(ByVal This As ID2D1SourceTransform Ptr,  ByVal index As ULong, ByVal input_rect As D2D1_RECT_L, ByVal output_rect As D2D1_RECT_L Ptr ) As HRESULT

        
    SetRenderInfo As Function(ByVal This As ID2D1SourceTransform Ptr,  ByVal info As ID2D1RenderInfo Ptr ) As HRESULT
        ' 9. Draw
    Draw As Function(ByVal This As ID2D1SourceTransform Ptr,  ByVal target As ID2D1Bitmap1 Ptr, ByVal draw_rect As D2D1_RECT_L Ptr, ByVal target_origin As D2D1_POINT_2U ) As HRESULT
End Type
#define ID2D1SourceTransform_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1SourceTransform_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1SourceTransform_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1SourceTransform_GetInputCount(p, a) (p)->lpVtbl->GetInputCount(p, a)
#define ID2D1SourceTransform_MapOutputRectToInputRects(p, a, b, c) (p)->lpVtbl->MapOutputRectToInputRects(p, a, b, c)
#define ID2D1SourceTransform_MapInputRectsToOutputRect(p, a, b, c, d, e) (p)->lpVtbl->MapInputRectsToOutputRect(p, a, b, c, d, e)
#define ID2D1SourceTransform_MapInvalidRect(p, a, b, c) (p)->lpVtbl->MapInvalidRect(p, a, b, c)
#define ID2D1SourceTransform_SetRenderInfo(p, a) (p)->lpVtbl->SetRenderInfo(p, a)
#define ID2D1SourceTransform_Draw(p, a, b, c) (p)->lpVtbl->Draw(p, a, b, c)

' ============================================================================
' ID2D1ConcreteTransform
' ============================================================================
Type ID2D1ConcreteTransformVtbl As ID2D1ConcreteTransformVtbl_
Type ID2D1ConcreteTransform
    lpVtbl As ID2D1ConcreteTransformVtbl Ptr
End Type
Type ID2D1ConcreteTransformVtbl_     '' Extends ID2D1TransformNodeVtbl_
    QueryInterface As Function(ByVal This As ID2D1ConcreteTransform Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1ConcreteTransform Ptr) As ULong
    Release As Function(ByVal This As ID2D1ConcreteTransform Ptr) As ULong
        
    GetInputCount As Function(ByVal This As ID2D1ConcreteTransform Ptr) As ULong

        
    SetOutputBuffer As Function(ByVal This As ID2D1ConcreteTransform Ptr,  ByVal precision As D2D1_BUFFER_PRECISION, ByVal depth As D2D1_CHANNEL_DEPTH ) As HRESULT
        ' 6. SetCached
    SetCached As Sub(ByVal This As ID2D1ConcreteTransform Ptr,  ByVal is_cached As Long )
End Type
#define ID2D1ConcreteTransform_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1ConcreteTransform_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1ConcreteTransform_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1ConcreteTransform_GetInputCount(p, a) (p)->lpVtbl->GetInputCount(p, a)
#define ID2D1ConcreteTransform_SetOutputBuffer(p, a, b) (p)->lpVtbl->SetOutputBuffer(p, a, b)
#define ID2D1ConcreteTransform_SetCached(p, a) (p)->lpVtbl->SetCached(p, a)

' ============================================================================
' ID2D1BlendTransform
' ============================================================================
Type ID2D1BlendTransformVtbl As ID2D1BlendTransformVtbl_
Type ID2D1BlendTransform
    lpVtbl As ID2D1BlendTransformVtbl Ptr
End Type
Type ID2D1BlendTransformVtbl_     '' Extends ID2D1ConcreteTransformVtbl_
    QueryInterface As Function(ByVal This As ID2D1BlendTransform Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1BlendTransform Ptr) As ULong
    Release As Function(ByVal This As ID2D1BlendTransform Ptr) As ULong
        
    GetInputCount As Function(ByVal This As ID2D1BlendTransform Ptr) As ULong
        
    SetOutputBuffer As Function(ByVal This As ID2D1BlendTransform Ptr,  ByVal precision As D2D1_BUFFER_PRECISION, ByVal depth As D2D1_CHANNEL_DEPTH ) As HRESULT
        ' 6. SetCached
    SetCached As Sub(ByVal This As ID2D1BlendTransform Ptr,  ByVal is_cached As Long )

        
    SetDescription As Sub(ByVal This As ID2D1BlendTransform Ptr,  ByVal description As D2D1_BLEND_DESCRIPTION Ptr )
        ' 8. GetDescription
    GetDescription As Sub(ByVal This As ID2D1BlendTransform Ptr,  ByVal description As D2D1_BLEND_DESCRIPTION Ptr )
End Type
#define ID2D1BlendTransform_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1BlendTransform_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1BlendTransform_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1BlendTransform_GetInputCount(p, a) (p)->lpVtbl->GetInputCount(p, a)
#define ID2D1BlendTransform_SetOutputBuffer(p, a, b) (p)->lpVtbl->SetOutputBuffer(p, a, b)
#define ID2D1BlendTransform_SetCached(p, a) (p)->lpVtbl->SetCached(p, a)
#define ID2D1BlendTransform_SetDescription(p, a) (p)->lpVtbl->SetDescription(p, a)
#define ID2D1BlendTransform_GetDescription(p, a) (p)->lpVtbl->GetDescription(p, a)

' ============================================================================
' ID2D1BorderTransform
' ============================================================================
Type ID2D1BorderTransformVtbl As ID2D1BorderTransformVtbl_
Type ID2D1BorderTransform
    lpVtbl As ID2D1BorderTransformVtbl Ptr
End Type
Type ID2D1BorderTransformVtbl_     '' Extends ID2D1ConcreteTransformVtbl_
    QueryInterface As Function(ByVal This As ID2D1BorderTransform Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1BorderTransform Ptr) As ULong
    Release As Function(ByVal This As ID2D1BorderTransform Ptr) As ULong
        
    GetInputCount As Function(ByVal This As ID2D1BorderTransform Ptr) As ULong
        
    SetOutputBuffer As Function(ByVal This As ID2D1BorderTransform Ptr,  ByVal precision As D2D1_BUFFER_PRECISION, ByVal depth As D2D1_CHANNEL_DEPTH ) As HRESULT
        ' 6. SetCached
    SetCached As Sub(ByVal This As ID2D1BorderTransform Ptr,  ByVal is_cached As Long )

        
    SetExtendModeX As Sub(ByVal This As ID2D1BorderTransform Ptr,  ByVal mode As D2D1_EXTEND_MODE )
        ' 8. SetExtendModeY
    SetExtendModeY As Sub(ByVal This As ID2D1BorderTransform Ptr,  ByVal mode As D2D1_EXTEND_MODE )
        ' 9. GetExtendModeX
    GetExtendModeX As Function(ByVal This As ID2D1BorderTransform Ptr) As D2D1_EXTEND_MODE
        ' 10. GetExtendModeY
    GetExtendModeY As Function(ByVal This As ID2D1BorderTransform Ptr) As D2D1_EXTEND_MODE
End Type
#define ID2D1BorderTransform_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1BorderTransform_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1BorderTransform_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1BorderTransform_GetInputCount(p, a) (p)->lpVtbl->GetInputCount(p, a)
#define ID2D1BorderTransform_SetOutputBuffer(p, a, b) (p)->lpVtbl->SetOutputBuffer(p, a, b)
#define ID2D1BorderTransform_SetCached(p, a) (p)->lpVtbl->SetCached(p, a)
#define ID2D1BorderTransform_SetExtendModeX(p, a) (p)->lpVtbl->SetExtendModeX(p, a)
#define ID2D1BorderTransform_SetExtendModeY(p, a) (p)->lpVtbl->SetExtendModeY(p, a)
#define ID2D1BorderTransform_GetExtendModeX(p, a) (p)->lpVtbl->GetExtendModeX(p, a)
#define ID2D1BorderTransform_GetExtendModeY(p, a) (p)->lpVtbl->GetExtendModeY(p, a)

' ============================================================================
' ID2D1OffsetTransform
' ============================================================================
Type ID2D1OffsetTransformVtbl As ID2D1OffsetTransformVtbl_
Type ID2D1OffsetTransform
    lpVtbl As ID2D1OffsetTransformVtbl Ptr
End Type
Type ID2D1OffsetTransformVtbl_     '' Extends ID2D1TransformNodeVtbl_
    QueryInterface As Function(ByVal This As ID2D1OffsetTransform Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1OffsetTransform Ptr) As ULong
    Release As Function(ByVal This As ID2D1OffsetTransform Ptr) As ULong
        
    GetInputCount As Function(ByVal This As ID2D1OffsetTransform Ptr) As ULong

        
    SetOffset As Sub(ByVal This As ID2D1OffsetTransform Ptr,  ByVal offset As D2D1_POINT_2L )
        ' 6. GetOffset
    GetOffset As Function(ByVal This As ID2D1OffsetTransform Ptr) As D2D1_POINT_2L
End Type
#define ID2D1OffsetTransform_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1OffsetTransform_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1OffsetTransform_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1OffsetTransform_GetInputCount(p, a) (p)->lpVtbl->GetInputCount(p, a)
#define ID2D1OffsetTransform_SetOffset(p, a) (p)->lpVtbl->SetOffset(p, a)
#define ID2D1OffsetTransform_GetOffset(p, a) (p)->lpVtbl->GetOffset(p, a)

' ============================================================================
' ID2D1BoundsAdjustmentTransform
' ============================================================================
Type ID2D1BoundsAdjustmentTransformVtbl As ID2D1BoundsAdjustmentTransformVtbl_
Type ID2D1BoundsAdjustmentTransform
    lpVtbl As ID2D1BoundsAdjustmentTransformVtbl Ptr
End Type
Type ID2D1BoundsAdjustmentTransformVtbl_     '' Extends ID2D1TransformNodeVtbl_
    QueryInterface As Function(ByVal This As ID2D1BoundsAdjustmentTransform Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1BoundsAdjustmentTransform Ptr) As ULong
    Release As Function(ByVal This As ID2D1BoundsAdjustmentTransform Ptr) As ULong
        
    GetInputCount As Function(ByVal This As ID2D1BoundsAdjustmentTransform Ptr) As ULong

        
    SetOutputBounds As Sub(ByVal This As ID2D1BoundsAdjustmentTransform Ptr,  ByVal bounds As D2D1_RECT_L Ptr )
        ' 6. GetOutputBounds
    GetOutputBounds As Sub(ByVal This As ID2D1BoundsAdjustmentTransform Ptr,  ByVal bounds As D2D1_RECT_L Ptr )
End Type
#define ID2D1BoundsAdjustmentTransform_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1BoundsAdjustmentTransform_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1BoundsAdjustmentTransform_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1BoundsAdjustmentTransform_GetInputCount(p, a) (p)->lpVtbl->GetInputCount(p, a)
#define ID2D1BoundsAdjustmentTransform_SetOutputBounds(p, a) (p)->lpVtbl->SetOutputBounds(p, a)
#define ID2D1BoundsAdjustmentTransform_GetOutputBounds(p, a) (p)->lpVtbl->GetOutputBounds(p, a)

' ============================================================================
' ID2D1EffectContext
' ============================================================================
Type ID2D1EffectContextVtbl As ID2D1EffectContextVtbl_
Type ID2D1EffectContext
    lpVtbl As ID2D1EffectContextVtbl Ptr
End Type
Type ID2D1EffectContextVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As ID2D1EffectContext Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1EffectContext Ptr) As ULong
    Release As Function(ByVal This As ID2D1EffectContext Ptr) As ULong

        
    GetDpi As Sub(ByVal This As ID2D1EffectContext Ptr,  ByVal dpi_x As Single Ptr, ByVal dpi_y As Single Ptr )
        ' 5. CreateEffect
    CreateEffect As Function(ByVal This As ID2D1EffectContext Ptr,  ByRef clsid As GUID, ByVal effect As Any Ptr Ptr ) As HRESULT
        ' 6. GetMaximumSupportedFeatureLevel
    GetMaximumSupportedFeatureLevel As Function(ByVal This As ID2D1EffectContext Ptr,  ByVal levels As ULong Ptr, ByVal level_count As ULong, ByVal max_level As ULong Ptr ) As HRESULT
        ' 7. CreateTransformNodeFromEffect
    CreateTransformNodeFromEffect As Function(ByVal This As ID2D1EffectContext Ptr,  ByVal effect As Any Ptr, ByVal node As Any Ptr Ptr ) As HRESULT
        ' 8. CreateBlendTransform
    CreateBlendTransform As Function(ByVal This As ID2D1EffectContext Ptr,  ByVal num_inputs As ULong, ByVal description As D2D1_BLEND_DESCRIPTION Ptr, ByVal transform As Any Ptr Ptr ) As HRESULT
        ' 9. CreateBorderTransform
    CreateBorderTransform As Function(ByVal This As ID2D1EffectContext Ptr,  ByVal mode_x As D2D1_EXTEND_MODE, ByVal mode_y As D2D1_EXTEND_MODE, ByVal transform As Any Ptr Ptr ) As HRESULT
        ' 10. CreateOffsetTransform
    CreateOffsetTransform As Function(ByVal This As ID2D1EffectContext Ptr,  ByVal offset As D2D1_POINT_2L, ByVal transform As Any Ptr Ptr ) As HRESULT
        ' 11. CreateBoundsAdjustmentTransform
    CreateBoundsAdjustmentTransform As Function(ByVal This As ID2D1EffectContext Ptr,  ByVal output_rect As D2D1_RECT_L Ptr, ByVal transform As Any Ptr Ptr ) As HRESULT
        ' 12. LoadPixelShader
    LoadPixelShader As Function(ByVal This As ID2D1EffectContext Ptr,  ByRef shader_id As GUID, ByVal buffer As UByte Ptr, ByVal buffer_size As ULong ) As HRESULT
        ' 13. LoadVertexShader
    LoadVertexShader As Function(ByVal This As ID2D1EffectContext Ptr,  ByRef shader_id As GUID, ByVal buffer As UByte Ptr, ByVal buffer_size As ULong ) As HRESULT
        ' 14. LoadComputeShader
    LoadComputeShader As Function(ByVal This As ID2D1EffectContext Ptr,  ByRef shader_id As GUID, ByVal buffer As UByte Ptr, ByVal buffer_size As ULong ) As HRESULT
        ' 15. IsShaderLoaded
    IsShaderLoaded As Function(ByVal This As ID2D1EffectContext Ptr,  ByRef shader_id As GUID ) As Long
        ' 16. CreateResourceTexture
    CreateResourceTexture As Function(ByVal This As ID2D1EffectContext Ptr,  ByVal id As GUID Ptr, ByVal texture_properties As D2D1_RESOURCE_TEXTURE_PROPERTIES Ptr, ByVal data As UByte Ptr, ByVal strides As ULong Ptr, ByVal data_size As ULong, ByVal texture As Any Ptr Ptr ) As HRESULT
        ' 17. FindResourceTexture
    FindResourceTexture As Function(ByVal This As ID2D1EffectContext Ptr,  ByVal id As GUID Ptr, ByVal texture As Any Ptr Ptr ) As HRESULT
        ' 18. CreateVertexBuffer
    CreateVertexBuffer As Function(ByVal This As ID2D1EffectContext Ptr,  ByVal buffer_properties As D2D1_VERTEX_BUFFER_PROPERTIES Ptr, ByVal id As GUID Ptr, ByVal custom_buffer_properties As D2D1_CUSTOM_VERTEX_BUFFER_PROPERTIES Ptr, ByVal buffer As Any Ptr Ptr ) As HRESULT
        ' 19. FindVertexBuffer
    FindVertexBuffer As Function(ByVal This As ID2D1EffectContext Ptr,  ByVal id As GUID Ptr, ByVal buffer As Any Ptr Ptr ) As HRESULT
        ' 20. CreateColorContext
    CreateColorContext As Function(ByVal This As ID2D1EffectContext Ptr,  ByVal space As D2D1_COLOR_SPACE, ByVal profile As UByte Ptr, ByVal profile_size As ULong, ByVal color_context As Any Ptr Ptr ) As HRESULT
        ' 21. CreateColorContextFromFilename
    CreateColorContextFromFilename As Function(ByVal This As ID2D1EffectContext Ptr,  ByVal filename As WString Ptr, ByVal color_context As Any Ptr Ptr ) As HRESULT
        ' 22. CreateColorContextFromWicColorContext
    CreateColorContextFromWicColorContext As Function(ByVal This As ID2D1EffectContext Ptr,  ByVal wic_color_context As Any Ptr, ByVal color_context As Any Ptr Ptr ) As HRESULT
        ' 23. CheckFeatureSupport
    CheckFeatureSupport As Function(ByVal This As ID2D1EffectContext Ptr,  ByVal feature As D2D1_FEATURE, ByVal data As Any Ptr, ByVal data_size As ULong ) As HRESULT
        ' 24. IsBufferPrecisionSupported
    IsBufferPrecisionSupported As Function(ByVal This As ID2D1EffectContext Ptr,  ByVal precision As D2D1_BUFFER_PRECISION ) As Long
End Type
#define ID2D1EffectContext_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1EffectContext_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1EffectContext_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1EffectContext_GetDpi(p, a, b) (p)->lpVtbl->GetDpi(p, a, b)
#define ID2D1EffectContext_CreateEffect(p, a, b) (p)->lpVtbl->CreateEffect(p, a, b)
#define ID2D1EffectContext_GetMaximumSupportedFeatureLevel(p, a, b, c) (p)->lpVtbl->GetMaximumSupportedFeatureLevel(p, a, b, c)
#define ID2D1EffectContext_CreateTransformNodeFromEffect(p, a, b) (p)->lpVtbl->CreateTransformNodeFromEffect(p, a, b)
#define ID2D1EffectContext_CreateBlendTransform(p, a, b, c) (p)->lpVtbl->CreateBlendTransform(p, a, b, c)
#define ID2D1EffectContext_CreateBorderTransform(p, a, b, c) (p)->lpVtbl->CreateBorderTransform(p, a, b, c)
#define ID2D1EffectContext_CreateOffsetTransform(p, a, b) (p)->lpVtbl->CreateOffsetTransform(p, a, b)
#define ID2D1EffectContext_CreateBoundsAdjustmentTransform(p, a, b) (p)->lpVtbl->CreateBoundsAdjustmentTransform(p, a, b)
#define ID2D1EffectContext_LoadPixelShader(p, a, b, c) (p)->lpVtbl->LoadPixelShader(p, a, b, c)
#define ID2D1EffectContext_LoadVertexShader(p, a, b, c) (p)->lpVtbl->LoadVertexShader(p, a, b, c)
#define ID2D1EffectContext_LoadComputeShader(p, a, b, c) (p)->lpVtbl->LoadComputeShader(p, a, b, c)
#define ID2D1EffectContext_IsShaderLoaded(p, a) (p)->lpVtbl->IsShaderLoaded(p, a)
#define ID2D1EffectContext_CreateResourceTexture(p, a, b, c, d, e, f) (p)->lpVtbl->CreateResourceTexture(p, a, b, c, d, e, f)
#define ID2D1EffectContext_FindResourceTexture(p, a, b) (p)->lpVtbl->FindResourceTexture(p, a, b)
#define ID2D1EffectContext_CreateVertexBuffer(p, a, b, c, d) (p)->lpVtbl->CreateVertexBuffer(p, a, b, c, d)
#define ID2D1EffectContext_FindVertexBuffer(p, a, b) (p)->lpVtbl->FindVertexBuffer(p, a, b)
#define ID2D1EffectContext_CreateColorContext(p, a, b, c, d) (p)->lpVtbl->CreateColorContext(p, a, b, c, d)
#define ID2D1EffectContext_CreateColorContextFromFilename(p, a, b) (p)->lpVtbl->CreateColorContextFromFilename(p, a, b)
#define ID2D1EffectContext_CreateColorContextFromWicColorContext(p, a, b) (p)->lpVtbl->CreateColorContextFromWicColorContext(p, a, b)
#define ID2D1EffectContext_CheckFeatureSupport(p, a, b, c) (p)->lpVtbl->CheckFeatureSupport(p, a, b, c)
#define ID2D1EffectContext_IsBufferPrecisionSupported(p, a) (p)->lpVtbl->IsBufferPrecisionSupported(p, a)

' ============================================================================
' ID2D1EffectImpl
' ============================================================================
Type ID2D1EffectImplVtbl As ID2D1EffectImplVtbl_
Type ID2D1EffectImpl
    lpVtbl As ID2D1EffectImplVtbl Ptr
End Type
Type ID2D1EffectImplVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As ID2D1EffectImpl Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1EffectImpl Ptr) As ULong
    Release As Function(ByVal This As ID2D1EffectImpl Ptr) As ULong

        
    Initialize As Function(ByVal This As ID2D1EffectImpl Ptr,  ByVal context As ID2D1EffectContext Ptr, ByVal graph As ID2D1TransformGraph Ptr ) As HRESULT
        ' 5. PrepareForRender
    PrepareForRender As Function(ByVal This As ID2D1EffectImpl Ptr,  ByVal change_type As D2D1_CHANGE_TYPE ) As HRESULT
        ' 6. SetGraph
    SetGraph As Function(ByVal This As ID2D1EffectImpl Ptr,  ByVal graph As ID2D1TransformGraph Ptr ) As HRESULT
End Type
#define ID2D1EffectImpl_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1EffectImpl_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1EffectImpl_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1EffectImpl_Initialize(p, a, b) (p)->lpVtbl->Initialize(p, a, b)
#define ID2D1EffectImpl_PrepareForRender(p, a) (p)->lpVtbl->PrepareForRender(p, a)
#define ID2D1EffectImpl_SetGraph(p, a) (p)->lpVtbl->SetGraph(p, a)

