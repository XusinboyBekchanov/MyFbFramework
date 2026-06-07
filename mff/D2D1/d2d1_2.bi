' Based on the C header files Wine project:
' Copyright (C) the Wine project
' Ported to FB by UEZ
' Build 2026-01-04 beta

' ============================================================================
' Direct2D 1.2 API - FreeBASIC Translation
' ============================================================================

#include once "d2d1_1.bi"
#include once "d2d1effects_1.bi"

' ============================================================================
' Enumerations
' ============================================================================

Enum D2D1_RENDERING_PRIORITY
    D2D1_RENDERING_PRIORITY_NORMAL = 0
    D2D1_RENDERING_PRIORITY_LOW = 1
End Enum

' ============================================================================
' IID Definitions
' ============================================================================

Dim Shared IID_ID2D1GeometryRealization As GUID = Type(&ha16907d7, &hbc02, &h4801, {&h99, &he8, &h8c, &hf7, &hf4, &h85, &hf7, &h74})
Dim Shared IID_ID2D1DeviceContext1 As GUID = Type(&hd37f57e4, &h6908, &h459f, {&ha1, &h99, &he7, &h2f, &h24, &hf7, &h99, &h87})
Dim Shared IID_ID2D1Device1 As GUID = Type(&hd21768e1, &h23a4, &h4823, {&ha1, &h4b, &h7c, &h3e, &hba, &h85, &hd6, &h58})
Dim Shared IID_ID2D1Factory2 As GUID = Type(&h94f81a73, &h9212, &h4376, {&h9c, &h58, &hb1, &h6a, &h3a, &h0d, &h39, &h92})
Dim Shared IID_ID2D1CommandSink1 As GUID = Type(&h9eb767fd, &h4269, &h4467, {&hb8, &hc2, &heb, &h30, &hcb, &h30, &h57, &h43})

' ============================================================================
' Interfaces
' ============================================================================

' ============================================================================
' ID2D1GeometryRealization
' ============================================================================
Type ID2D1GeometryRealization Extends ID2D1Resource
    ' 1-3: IUnknown
    ' 4: GetFactory (ID2D1Resource)
    ' Keine zusätzlichen Methoden
End Type

' ============================================================================
' ID2D1DeviceContext1
' ============================================================================
Type ID2D1DeviceContext1 Extends ID2D1DeviceContext
    ' Erbt alle Methoden von ID2D1DeviceContext (1-96 Methoden)
    
    ' 97. CreateFilledGeometryRealization
    Declare Abstract Function CreateFilledGeometryRealization Stdcall ( _
        ByVal geometry As ID2D1Geometry Ptr, _
        ByVal tolerance As Single, _
        ByVal realization As Any Ptr Ptr _
    ) As HRESULT
    
    ' 98. CreateStrokedGeometryRealization
    Declare Abstract Function CreateStrokedGeometryRealization Stdcall ( _
        ByVal geometry As ID2D1Geometry Ptr, _
        ByVal tolerance As Single, _
        ByVal stroke_width As Single, _
        ByVal stroke_style As ID2D1StrokeStyle Ptr, _
        ByVal realization As Any Ptr Ptr _
    ) As HRESULT
    
    ' 99. DrawGeometryRealization
    Declare Abstract Sub DrawGeometryRealization Stdcall ( _
        ByVal realization As ID2D1GeometryRealization Ptr, _
        ByVal brush As ID2D1Brush Ptr _
    )
End Type

' ============================================================================
' ID2D1Device1
' ============================================================================
Type ID2D1Device1 Extends ID2D1Device
    ' Erbt von ID2D1Device (1-10 Methoden)
    
    ' 11. GetRenderingPriority
    Declare Abstract Function GetRenderingPriority Stdcall () As D2D1_RENDERING_PRIORITY
    
    ' 12. SetRenderingPriority
    Declare Abstract Sub SetRenderingPriority Stdcall ( _
        ByVal priority As D2D1_RENDERING_PRIORITY _
    )
    
    ' 13. CreateDeviceContext
    Declare Abstract Function CreateDeviceContext Stdcall ( _
        ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, _
        ByVal device_context As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1Factory2
' ============================================================================
Type ID2D1Factory2 Extends ID2D1Factory1
    ' Erbt von ID2D1Factory1 (1-20 Methoden)
    
    ' 21. CreateDevice
    Declare Abstract Function CreateDevice Stdcall ( _
        ByVal dxgi_device As Any Ptr, _
        ByVal device As Any Ptr Ptr _
    ) As HRESULT
End Type

' ============================================================================
' ID2D1CommandSink1
' ============================================================================
Type ID2D1CommandSink1 Extends ID2D1CommandSink
    ' Erbt von ID2D1CommandSink
    
    ' Zusätzliche Methode
    Declare Abstract Function SetPrimitiveBlend1 Stdcall ( _
        ByVal primitive_blend As D2D1_PRIMITIVE_BLEND _
    ) As HRESULT
End Type

' ============================================================================
' Functions
' ============================================================================

Declare Function D2D1ComputeMaximumScaleFactor Lib "d2d1" ( _
    ByVal matrix As D2D1_MATRIX_3X2_F Ptr _
) As Single