' Based on the C header files Wine project:
' Copyright (C) the Wine project
' Ported to FB by UEZ
' Build 2026-01-04 beta
#pragma once
#inclib "d2d1"
#inclib "ole32"
#inclib "uuid"
#ifdef __FB_64BIT__
    #inclib "gdiplus"
    #include once "win/gdiplus-c.bi"
#else
    #include once "win/gdiplus.bi"
    Using Gdiplus
#endif
#include once "win/ole2.bi"
#include once "dxgicommon.bi"
#include once "dcommon.bi"
#include once "d2dbasetypes.bi"
#include once "d2derr.bi"
' ==============================
' DLL imports
' ==============================
Extern "Windows"
Declare Function D2D1CreateFactory stdcall Lib "d2d1" Alias "D2D1CreateFactory" ( ByVal factoryType As ULong, ByVal riid As GUID Ptr, ByVal options As Any Ptr, ByVal factory As Any Ptr Ptr) As HRESULT
End Extern

Type IUnknownBaseVtbl As IUnknownBaseVtbl_
Type IUnknownBase
    lpVtbl As IUnknownBaseVtbl Ptr
End Type
Type IUnknownBaseVtbl_     '' Extends ObjectVtbl_
    QueryInterface As Function(ByVal This As IUnknownBase Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As IUnknownBase Ptr) As ULong
    Release As Function(ByVal This As IUnknownBase Ptr) As ULong
End Type
#define IUnknownBase_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define IUnknownBase_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define IUnknownBase_Release(p, a) (p)->lpVtbl->Release(p, a)


' ---------------------------------------------------------------------------
' Basis-Typen und Aliase (vor den Enums einzufügen)
' ---------------------------------------------------------------------------
Type D2D1_TAG As UINT64
#define D2D1_DEFAULT_FLATTENING_TOLERANCE (0.25f)
' ---------------------------------------------------------------------------
' Enumerationen
' ---------------------------------------------------------------------------
Type D2D1_DEBUG_LEVEL As Long
Enum
    D2D1_DEBUG_LEVEL_NONE = 0
    D2D1_DEBUG_LEVEL_ERROR = 1
    D2D1_DEBUG_LEVEL_WARNING = 2
    D2D1_DEBUG_LEVEL_INFORMATION = 3
    D2D1_DEBUG_LEVEL_FORCE_DWORD = &hFFFFFFFF
End Enum
Type D2D1_FACTORY_TYPE As Long
Enum
    D2D1_FACTORY_TYPE_SINGLE_THREADED = 0
    D2D1_FACTORY_TYPE_MULTI_THREADED = 1
    D2D1_FACTORY_TYPE_FORCE_DWORD = &hFFFFFFFF
End Enum
Type D2D1_FILL_MODE As Long
Enum
    D2D1_FILL_MODE_ALTERNATE = 0
    D2D1_FILL_MODE_WINDING = 1
    D2D1_FILL_MODE_FORCE_DWORD = &hFFFFFFFF
End Enum
Type D2D1_PATH_SEGMENT As Long
Enum
    D2D1_PATH_SEGMENT_NONE = 0
    D2D1_PATH_SEGMENT_FORCE_UNSTROKED = 1
    D2D1_PATH_SEGMENT_FORCE_ROUND_LINE_JOIN = 2
    D2D1_PATH_SEGMENT_FORCE_DWORD = &hFFFFFFFF
End Enum
Type D2D1_FIGURE_BEGIN As Long
Enum
    D2D1_FIGURE_BEGIN_FILLED = 0
    D2D1_FIGURE_BEGIN_HOLLOW = 1
    D2D1_FIGURE_BEGIN_FORCE_DWORD = &hFFFFFFFF
End Enum
Type D2D1_FIGURE_END As Long
Enum
    D2D1_FIGURE_END_OPEN = 0
    D2D1_FIGURE_END_CLOSED = 1
    D2D1_FIGURE_END_FORCE_DWORD = &hFFFFFFFF
End Enum
Type D2D1_CAP_STYLE As Long
Enum
    D2D1_CAP_STYLE_FLAT = 0
    D2D1_CAP_STYLE_SQUARE = 1
    D2D1_CAP_STYLE_ROUND = 2
    D2D1_CAP_STYLE_TRIANGLE = 3
    D2D1_CAP_STYLE_FORCE_DWORD = &hFFFFFFFF
End Enum
Type D2D1_LINE_JOIN As Long
Enum
    D2D1_LINE_JOIN_MITER = 0
    D2D1_LINE_JOIN_BEVEL = 1
    D2D1_LINE_JOIN_ROUND = 2
    D2D1_LINE_JOIN_MITER_OR_BEVEL = 3
    D2D1_LINE_JOIN_FORCE_DWORD = &hFFFFFFFF
End Enum
Type D2D1_DASH_STYLE As Long
Enum
    D2D1_DASH_STYLE_SOLID = 0
    D2D1_DASH_STYLE_DASH = 1
    D2D1_DASH_STYLE_DOT = 2
    D2D1_DASH_STYLE_DASH_DOT = 3
    D2D1_DASH_STYLE_DASH_DOT_DOT = 4
    D2D1_DASH_STYLE_CUSTOM = 5
    D2D1_DASH_STYLE_FORCE_DWORD = &hFFFFFFFF
End Enum
Type D2D1_GEOMETRY_RELATION As Long
Enum
    D2D1_GEOMETRY_RELATION_UNKNOWN = 0
    D2D1_GEOMETRY_RELATION_DISJOINT = 1
    D2D1_GEOMETRY_RELATION_IS_CONTAINED = 2
    D2D1_GEOMETRY_RELATION_CONTAINS = 3
    D2D1_GEOMETRY_RELATION_OVERLAP = 4
    D2D1_GEOMETRY_RELATION_FORCE_DWORD = &hFFFFFFFF
End Enum
Type D2D1_GEOMETRY_SIMPLIFICATION_OPTION As Long
Enum
    D2D1_GEOMETRY_SIMPLIFICATION_OPTION_CUBICS_AND_LINES = 0
    D2D1_GEOMETRY_SIMPLIFICATION_OPTION_LINES = 1
    D2D1_GEOMETRY_SIMPLIFICATION_OPTION_FORCE_DWORD = &hFFFFFFFF
End Enum
Type D2D1_COMBINE_MODE As Long
Enum
    D2D1_COMBINE_MODE_UNION = 0
    D2D1_COMBINE_MODE_INTERSECT = 1
    D2D1_COMBINE_MODE_XOR = 2
    D2D1_COMBINE_MODE_EXCLUDE = 3
    D2D1_COMBINE_MODE_FORCE_DWORD = &hFFFFFFFF
End Enum
Type D2D1_SWEEP_DIRECTION As Long
Enum
    D2D1_SWEEP_DIRECTION_COUNTER_CLOCKWISE = 0,
    D2D1_SWEEP_DIRECTION_CLOCKWISE = 1
    D2D1_SWEEP_DIRECTION_FORCE_DWORD = &hFFFFFFFF
End Enum
Type D2D1_ARC_SIZE As Long
Enum
    D2D1_ARC_SIZE_SMALL = 0,
    D2D1_ARC_SIZE_LARGE = 1
    D2D1_ARC_SIZE_FORCE_DWORD = &hFFFFFFFF
End Enum
'Enum D2D1_ANTIALIAS_MODE
'    D2D1_ANTIALIAS_MODE_PER_PRIMITIVE = 0,
'    D2D1_ANTIALIAS_MODE_ALIASED = 1
'    D2D1_ANTIALIAS_MODE_FORCE_DWORD = &hFFFFFFFF
'End Enum
'Enum D2D1_TEXT_ANTIALIAS_MODE
'    D2D1_TEXT_ANTIALIAS_MODE_DEFAULT = 0,
'    D2D1_TEXT_ANTIALIAS_MODE_CLEARTYPE = 1,
'    D2D1_TEXT_ANTIALIAS_MODE_GRAYSCALE = 2,
'    D2D1_TEXT_ANTIALIAS_MODE_ALIASED = 3
'    D2D1_TEXT_ANTIALIAS_MODE_FORCE_DWORD = &hFFFFFFFF
'End Enum
'Enum D2D1_EXTEND_MODE
'    D2D1_EXTEND_MODE_CLAMP = 0,
'    D2D1_EXTEND_MODE_WRAP = 1,
'    D2D1_EXTEND_MODE_MIRROR = 2
'    D2D1_EXTEND_MODE_FORCE_DWORD = &hFFFFFFFF
'End Enum
Type D2D1_BITMAP_INTERPOLATION_MODE As Long
Enum
    D2D1_BITMAP_INTERPOLATION_MODE_NEAREST_NEIGHBOR = 0,
    D2D1_BITMAP_INTERPOLATION_MODE_LINEAR = 1
    D2D1_BITMAP_INTERPOLATION_MODE_FORCE_DWORD = &hFFFFFFFF
End Enum
Type D2D1_GAMMA As Long
Enum
    D2D1_GAMMA_2_2 = 0
    D2D1_GAMMA_1_0 = 1
    D2D1_GAMMA_FORCE_DWORD = &hFFFFFFFF
End Enum
Type D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS As Long
Enum
    D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS_NONE = &h00000000
    D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS_GDI_COMPATIBLE = &h00000001
    D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS_FORCE_DWORD = &hFFFFFFFF
End Enum
Type D2D1_OPACITY_MASK_CONTENT As Long
Enum
    D2D1_OPACITY_MASK_CONTENT_GRAPHICS            = 0
    D2D1_OPACITY_MASK_CONTENT_TEXT_NATURAL        = 1
    D2D1_OPACITY_MASK_CONTENT_TEXT_GDI_COMPATIBLE = 2
    D2D1_OPACITY_MASK_CONTENT_FORCE_DWORD         = &hFFFFFFFF
End Enum
Type D2D1_DRAW_TEXT_OPTIONS As Long
Enum
    D2D1_DRAW_TEXT_OPTIONS_NONE = &h00000000
    D2D1_DRAW_TEXT_OPTIONS_NO_SNAP = &h00000001
    D2D1_DRAW_TEXT_OPTIONS_CLIP = &h00000002
    D2D1_DRAW_TEXT_OPTIONS_ENABLE_COLOR_FONT = &h00000004
    D2D1_DRAW_TEXT_OPTIONS_FORCE_DWORD = &hFFFFFFFF
End Enum
Type D2D1_LAYER_OPTIONS As Long
Enum
    D2D1_LAYER_OPTIONS_NONE = &h00000000
    D2D1_LAYER_OPTIONS_INITIALIZE_FOR_CLEARTYPE = &h00000001
    D2D1_LAYER_OPTIONS_FORCE_DWORD = &hFFFFFFFF
End Enum
Type  D2D1_RENDER_TARGET_TYPE As Long
Enum
    D2D1_RENDER_TARGET_TYPE_DEFAULT = 0,
    D2D1_RENDER_TARGET_TYPE_SOFTWARE = 1,
    D2D1_RENDER_TARGET_TYPE_HARDWARE = 2
    D2D1_RENDER_TARGET_TYPE_FORCE_DWORD = &hFFFFFFFF
End Enum
Type D2D1_RENDER_TARGET_USAGE As Long
Enum
    D2D1_RENDER_TARGET_USAGE_NONE = 0,
    D2D1_RENDER_TARGET_USAGE_FORCE_BITMAP_REMOTING = 1,
    D2D1_RENDER_TARGET_USAGE_GDI_COMPATIBLE = 2
    D2D1_RENDER_TARGET_USAGE_FORCE_DWORD = &hFFFFFFFF
End Enum
Type D2D1_FEATURE_LEVEL As Long
Enum
    D2D1_FEATURE_LEVEL_DEFAULT = 0,
    D2D1_FEATURE_LEVEL_9 = 37120,
    D2D1_FEATURE_LEVEL_10 = 40960
    D2D1_FEATURE_LEVEL_FORCE_DWORD = &hFFFFFFFF
End Enum
Type D2D1_WINDOW_STATE As Long
Enum
    D2D1_WINDOW_STATE_NONE = &h00000000
    D2D1_WINDOW_STATE_OCCLUDED = &h00000001
    D2D1_WINDOW_STATE_FORCE_DWORD = &hFFFFFFFF
End Enum
Type D2D1_DC_INITIALIZE_MODE As Long
Enum
    D2D1_DC_INITIALIZE_MODE_COPY = 0
    D2D1_DC_INITIALIZE_MODE_CLEAR = 1
    D2D1_DC_INITIALIZE_MODE_FORCE_DWORD = &hFFFFFFFF
End Enum
Type D2D1_PRESENT_OPTIONS As Long
Enum
    D2D1_PRESENT_OPTIONS_NONE = 0,
    D2D1_PRESENT_OPTIONS_RETAIN_CONTENTS = 1,
    D2D1_PRESENT_OPTIONS_IMMEDIATELY = 2
    D2D1_PRESENT_OPTIONS_FORCE_DWORD = &hFFFFFFFF
End Enum
' ---------------------------------------------------------------------------
' Strukturen
' ---------------------------------------------------------------------------
Type D2D1_BEZIER_SEGMENT
    point1 As D2D1_POINT_2F
    point2 As D2D1_POINT_2F
    point3 As D2D1_POINT_2F
End Type
Type D2D1_FACTORY_OPTIONS
    debugLevel As D2D1_DEBUG_LEVEL
End Type
Type D2D1_TRIANGLE
    point1 As D2D1_POINT_2F
    point2 As D2D1_POINT_2F
    point3 As D2D1_POINT_2F
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
Type D2D1_QUADRATIC_BEZIER_SEGMENT
    point1 As D2D1_POINT_2F
    point2 As D2D1_POINT_2F
End Type
Type D2D1_ARC_SEGMENT 
    point As D2D1_POINT_2F
    size As D2D1_SIZE_F
    rotationAngle As Single
    sweepDirection As ULong   ' D2D1_SWEEP_DIRECTION
    arcSize As ULong          ' D2D1_ARC_SIZE
End Type
Type D2D1_DRAWING_STATE_DESCRIPTION
    antialiasMode     As ULong            
    textAntialiasMode As ULong            
    tag1              As ULongInt         
    tag2              As ULongInt         
    transform         As D2D1_MATRIX_3X2_F
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
Type D2D1_BITMAP_BRUSH_PROPERTIES 
    extendModeX As ULong
    extendModeY As ULong
    interpolationMode As ULong
End Type
Type D2D1_BRUSH_PROPERTIES
    opacity As Single
    transform As D2D1_MATRIX_3X2_F
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
Type D2D1_LAYER_PARAMETERS
    contentBounds      As D2D1_RECT_F       
    geometricMask      As Any Ptr           
    maskAntialiasMode  As ULong             
    maskTransform      As D2D1_MATRIX_3X2_F 
    opacity            As Single            
    opacityBrush       As Any Ptr           
    layerOptions       As ULong             
End Type
Type D2D1_RENDER_TARGET_PROPERTIES
    type_ As D2D1_RENDER_TARGET_TYPE
    pixelFormat As D2D1_PIXEL_FORMAT
    dpiX As Single
    dpiY As Single
    usage As D2D1_RENDER_TARGET_USAGE
    minLevel As D2D1_FEATURE_LEVEL
End Type
Type D2D1_STROKE_STYLE_PROPERTIES
	startCap As ULong
	endCap As ULong
	dashCap As ULong
	lineJoin As ULong
	miterLimit As Single
	dashStyle As ULong
	dashOffset As Single
End Type
Type D2D1_HWND_RENDER_TARGET_PROPERTIES
    hwnd As HWND
    pixelSize As D2D1_SIZE_U
    presentOptions As D2D1_PRESENT_OPTIONS
End Type

' ---------------------------------------------------------------------------
' Converted COM interface GUIDs
' ---------------------------------------------------------------------------
Dim Shared As GUID ID2D1Resource = Type<GUID>(&h2CD90691, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1StrokeStyle = Type<GUID>(&h2CD9069D, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1SimplifiedGeometrySink = Type<GUID>(&h2CD9069E, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1TessellationSink = Type<GUID>(&h2CD906C1, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1Geometry = Type<GUID>(&h2CD906A1, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1RectangleGeometry = Type<GUID>(&h2CD906A2, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1RoundedRectangleGeometry = Type<GUID>(&h2CD906A3, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1EllipseGeometry = Type<GUID>(&h2CD906A4, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1GeometryGroup = Type<GUID>(&h2CD906A6, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1TransformedGeometry = Type<GUID>(&h2CD906BB, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1GeometrySink = Type<GUID>(&h2CD9069F, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1PathGeometry = Type<GUID>(&h2CD906A5, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1DrawingStateBlock = Type<GUID>(&h28506E39, &hEBF6, &h46A1, { &hBB, &h47, &hfd, &h85, &H56, &h5A, &hB9, &h57 })
Dim Shared As GUID ID2D1Image = Type<GUID>(&h65019F75, &h8DA2, &h497C, { &hB3, &h2C, &hDF, &hA3, &h4E, &h48, &hED, &hE6 })
Dim Shared As GUID ID2D1Bitmap = Type<GUID>(&hA2296057, &hEA42, &h4099, { &h98, &h3b, &h53, &h9F, &hB6, &h50, &h54, &h26 })
Dim Shared As GUID ID2D1Brush = Type<GUID>(&h2CD906A8, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1BitmapBrush = Type<GUID>(&h2CD906AA, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1SolidColorBrush = Type<GUID>(&h2CD906A9, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1GradientStopCollection = Type<GUID>(&h2CD906A7, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1LinearGradientBrush = Type<GUID>(&h2CD906AB, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1RadialGradientBrush = Type<GUID>(&h2CD906AC, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1Layer = Type<GUID>(&h2CD9069B, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1Mesh = Type<GUID>(&h2CD906C2, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1RenderTarget = Type<GUID>(&h2CD90694, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1BitmapRenderTarget = Type<GUID>(&h2CD90695, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1HwndRenderTarget = Type<GUID>(&h2CD90698, &h12E2, &h11DC, { &h9F, &hED, &h00, &h11, &h43, &hA0, &h55, &hF9 })
Dim Shared As GUID ID2D1DCRenderTarget = Type<GUID>(&h1C51BC64, &hDE61, &h46FD, { &h98, &h99, &h63, &hA5, &hD8, &hF0, &h39, &h50 })
Dim Shared As GUID ID2D1GdiInteropRenderTarget = Type<GUID>(&hE0DB51C3, &h6F77, &h4BAE, { &hB3, &hD5, &hE4, &h75, &h09, &hB3, &h58, &h38 })
Dim Shared As GUID ID2D1Factory = Type<GUID>(&h06152247, &h6f50, &h465a, { &h92, &h45, &h11, &h8b, &hfd, &h3b, &h60, &h07 })

' ---------------------------------------------------------------------------
' Converted COM interfaces
' ---------------------------------------------------------------------------
' ==============================
' ID2D1Resource
' ==============================
Type ID2D1ResourceVtbl As ID2D1ResourceVtbl_
Type ID2D1Resource
    lpVtbl As ID2D1ResourceVtbl Ptr
End Type
Type ID2D1ResourceVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As ID2D1Resource Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Resource Ptr) As ULong
    Release As Function(ByVal This As ID2D1Resource Ptr) As ULong

    GetFactory As Sub(ByVal This As ID2D1Resource Ptr, ByVal factory As Any Ptr Ptr)
End Type
#define ID2D1Resource_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Resource_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Resource_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Resource_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)

' ==============================
' ID2D1SimplifiedGeometrySink
' ==============================
Type ID2D1SimplifiedGeometrySinkVtbl As ID2D1SimplifiedGeometrySinkVtbl_
Type ID2D1SimplifiedGeometrySink
    lpVtbl As ID2D1SimplifiedGeometrySinkVtbl Ptr
End Type
Type ID2D1SimplifiedGeometrySinkVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As ID2D1SimplifiedGeometrySink Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1SimplifiedGeometrySink Ptr) As ULong
    Release As Function(ByVal This As ID2D1SimplifiedGeometrySink Ptr) As ULong

        ' 4.
    SetFillMode As Sub(ByVal This As ID2D1SimplifiedGeometrySink Ptr, ByVal fillMode As D2D1_FILL_MODE)
    SetSegmentFlags As Sub(ByVal This As ID2D1SimplifiedGeometrySink Ptr, ByVal vertexFlags As D2D1_PATH_SEGMENT)
    BeginFigure As Sub(ByVal This As ID2D1SimplifiedGeometrySink Ptr, ByVal startPoint As D2D1_POINT_2F, ByVal figureBegin As D2D1_FIGURE_BEGIN)
    AddLines As Sub(ByVal This As ID2D1SimplifiedGeometrySink Ptr, ByVal points As D2D1_POINT_2F Ptr, ByVal pointsCount As ULong)
    AddBeziers As Sub(ByVal This As ID2D1SimplifiedGeometrySink Ptr, ByVal beziers As D2D1_BEZIER_SEGMENT Ptr, ByVal beziersCount As ULong)
    EndFigure As Sub(ByVal This As ID2D1SimplifiedGeometrySink Ptr, ByVal figureEnd As D2D1_FIGURE_END)
    Close As Function(ByVal This As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
End Type
#define ID2D1SimplifiedGeometrySink_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1SimplifiedGeometrySink_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1SimplifiedGeometrySink_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1SimplifiedGeometrySink_SetFillMode(p, a) (p)->lpVtbl->SetFillMode(p, a)
#define ID2D1SimplifiedGeometrySink_SetSegmentFlags(p, a) (p)->lpVtbl->SetSegmentFlags(p, a)
#define ID2D1SimplifiedGeometrySink_BeginFigure(p, a, b) (p)->lpVtbl->BeginFigure(p, a, b)
#define ID2D1SimplifiedGeometrySink_AddLines(p, a, b) (p)->lpVtbl->AddLines(p, a, b)
#define ID2D1SimplifiedGeometrySink_AddBeziers(p, a, b) (p)->lpVtbl->AddBeziers(p, a, b)
#define ID2D1SimplifiedGeometrySink_EndFigure(p, a) (p)->lpVtbl->EndFigure(p, a)
#define ID2D1SimplifiedGeometrySink_Close(p, a) (p)->lpVtbl->Close(p, a)

' ==============================
' ID2D1GeometrySink
' ==============================
Type ID2D1GeometrySinkVtbl As ID2D1GeometrySinkVtbl_
Type ID2D1GeometrySink
    lpVtbl As ID2D1GeometrySinkVtbl Ptr
End Type
Type ID2D1GeometrySinkVtbl_     '' Extends ID2D1SimplifiedGeometrySinkVtbl_
    QueryInterface As Function(ByVal This As ID2D1GeometrySink Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1GeometrySink Ptr) As ULong
    Release As Function(ByVal This As ID2D1GeometrySink Ptr) As ULong
        ' 4.
    SetFillMode As Sub(ByVal This As ID2D1GeometrySink Ptr, ByVal fillMode As D2D1_FILL_MODE)
    SetSegmentFlags As Sub(ByVal This As ID2D1GeometrySink Ptr, ByVal vertexFlags As D2D1_PATH_SEGMENT)
    BeginFigure As Sub(ByVal This As ID2D1GeometrySink Ptr, ByVal startPoint As D2D1_POINT_2F, ByVal figureBegin As D2D1_FIGURE_BEGIN)
    AddLines As Sub(ByVal This As ID2D1GeometrySink Ptr, ByVal points As D2D1_POINT_2F Ptr, ByVal pointsCount As ULong)
    AddBeziers As Sub(ByVal This As ID2D1GeometrySink Ptr, ByVal beziers As D2D1_BEZIER_SEGMENT Ptr, ByVal beziersCount As ULong)
    EndFigure As Sub(ByVal This As ID2D1GeometrySink Ptr, ByVal figureEnd As D2D1_FIGURE_END)
    Close As Function(ByVal This As ID2D1GeometrySink Ptr) As HRESULT

    AddLine As Sub(ByVal This As ID2D1GeometrySink Ptr, ByVal point As D2D1_POINT_2F)
    AddBezier As Sub(ByVal This As ID2D1GeometrySink Ptr, ByVal bezier As D2D1_BEZIER_SEGMENT Ptr)
    AddQuadraticBezier As Sub(ByVal This As ID2D1GeometrySink Ptr, ByVal bezier As D2D1_QUADRATIC_BEZIER_SEGMENT Ptr)
    AddQuadraticBeziers As Sub(ByVal This As ID2D1GeometrySink Ptr, ByVal beziers As D2D1_QUADRATIC_BEZIER_SEGMENT Ptr, ByVal beziersCount As ULong)
    AddArc As Sub(ByVal This As ID2D1GeometrySink Ptr, ByVal arc As D2D1_ARC_SEGMENT Ptr)
End Type
#define ID2D1GeometrySink_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1GeometrySink_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1GeometrySink_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1GeometrySink_SetFillMode(p, a) (p)->lpVtbl->SetFillMode(p, a)
#define ID2D1GeometrySink_SetSegmentFlags(p, a) (p)->lpVtbl->SetSegmentFlags(p, a)
#define ID2D1GeometrySink_BeginFigure(p, a, b) (p)->lpVtbl->BeginFigure(p, a, b)
#define ID2D1GeometrySink_AddLines(p, a, b) (p)->lpVtbl->AddLines(p, a, b)
#define ID2D1GeometrySink_AddBeziers(p, a, b) (p)->lpVtbl->AddBeziers(p, a, b)
#define ID2D1GeometrySink_EndFigure(p, a) (p)->lpVtbl->EndFigure(p, a)
#define ID2D1GeometrySink_Close(p, a) (p)->lpVtbl->Close(p, a)
#define ID2D1GeometrySink_AddLine(p, a) (p)->lpVtbl->AddLine(p, a)
#define ID2D1GeometrySink_AddBezier(p, a) (p)->lpVtbl->AddBezier(p, a)
#define ID2D1GeometrySink_AddQuadraticBezier(p, a) (p)->lpVtbl->AddQuadraticBezier(p, a)
#define ID2D1GeometrySink_AddQuadraticBeziers(p, a, b) (p)->lpVtbl->AddQuadraticBeziers(p, a, b)
#define ID2D1GeometrySink_AddArc(p, a) (p)->lpVtbl->AddArc(p, a)

' ==============================
' ID2D1TessellationSink
' ==============================
Type ID2D1TessellationSinkVtbl As ID2D1TessellationSinkVtbl_
Type ID2D1TessellationSink
    lpVtbl As ID2D1TessellationSinkVtbl Ptr
End Type
Type ID2D1TessellationSinkVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As ID2D1TessellationSink Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1TessellationSink Ptr) As ULong
    Release As Function(ByVal This As ID2D1TessellationSink Ptr) As ULong

        ' --- IUnknown (Index 1-3) ---
        ' 2. AddRef
        ' 4.
    AddTriangles As Sub(ByVal This As ID2D1TessellationSink Ptr, ByVal triangles As D2D1_TRIANGLE Ptr, ByVal trianglesCount As ULong)
    Close As Function(ByVal This As ID2D1TessellationSink Ptr) As HRESULT
End Type
#define ID2D1TessellationSink_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1TessellationSink_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1TessellationSink_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1TessellationSink_AddTriangles(p, a, b) (p)->lpVtbl->AddTriangles(p, a, b)
#define ID2D1TessellationSink_Close(p, a) (p)->lpVtbl->Close(p, a)

' ==============================
' ID2D1StrokeStyle
' ==============================
Type ID2D1StrokeStyleVtbl As ID2D1StrokeStyleVtbl_
Type ID2D1StrokeStyle
    lpVtbl As ID2D1StrokeStyleVtbl Ptr
End Type
Type ID2D1StrokeStyleVtbl_     '' Extends ID2D1ResourceVtbl_
    QueryInterface As Function(ByVal This As ID2D1StrokeStyle Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1StrokeStyle Ptr) As ULong
    Release As Function(ByVal This As ID2D1StrokeStyle Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1StrokeStyle Ptr, ByVal factory As Any Ptr Ptr)

    GetStartCap As Function(ByVal This As ID2D1StrokeStyle Ptr) As D2D1_CAP_STYLE
    GetEndCap As Function(ByVal This As ID2D1StrokeStyle Ptr) As D2D1_CAP_STYLE
    GetDashCap As Function(ByVal This As ID2D1StrokeStyle Ptr) As D2D1_CAP_STYLE
    GetMiterLimit As Function(ByVal This As ID2D1StrokeStyle Ptr) As Single
    GetLineJoin As Function(ByVal This As ID2D1StrokeStyle Ptr) As D2D1_LINE_JOIN
    GetDashOffset As Function(ByVal This As ID2D1StrokeStyle Ptr) As Single
    GetDashStyle As Function(ByVal This As ID2D1StrokeStyle Ptr) As D2D1_DASH_STYLE
    GetDashesCount As Function(ByVal This As ID2D1StrokeStyle Ptr) As ULong
    GetDashes As Sub(ByVal This As ID2D1StrokeStyle Ptr, ByVal dashes As Single Ptr, ByVal dashesCount As ULong)
End Type
#define ID2D1StrokeStyle_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1StrokeStyle_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1StrokeStyle_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1StrokeStyle_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1StrokeStyle_GetStartCap(p, a) (p)->lpVtbl->GetStartCap(p, a)
#define ID2D1StrokeStyle_GetEndCap(p, a) (p)->lpVtbl->GetEndCap(p, a)
#define ID2D1StrokeStyle_GetDashCap(p, a) (p)->lpVtbl->GetDashCap(p, a)
#define ID2D1StrokeStyle_GetMiterLimit(p, a) (p)->lpVtbl->GetMiterLimit(p, a)
#define ID2D1StrokeStyle_GetLineJoin(p, a) (p)->lpVtbl->GetLineJoin(p, a)
#define ID2D1StrokeStyle_GetDashOffset(p, a) (p)->lpVtbl->GetDashOffset(p, a)
#define ID2D1StrokeStyle_GetDashStyle(p, a) (p)->lpVtbl->GetDashStyle(p, a)
#define ID2D1StrokeStyle_GetDashesCount(p, a) (p)->lpVtbl->GetDashesCount(p, a)
#define ID2D1StrokeStyle_GetDashes(p, a, b) (p)->lpVtbl->GetDashes(p, a, b)

' ==============================
' ID2D1Geometry
' ==============================
Type ID2D1GeometryVtbl As ID2D1GeometryVtbl_
Type ID2D1Geometry
    lpVtbl As ID2D1GeometryVtbl Ptr
End Type
Type ID2D1GeometryVtbl_     '' Extends ID2D1ResourceVtbl_
    QueryInterface As Function(ByVal This As ID2D1Geometry Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Geometry Ptr) As ULong
    Release As Function(ByVal This As ID2D1Geometry Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1Geometry Ptr, ByVal factory As Any Ptr Ptr)

    GetBounds As Function(ByVal This As ID2D1Geometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal bounds As D2D1_RECT_F Ptr) As HRESULT
    GetWidenedBounds As Function(ByVal This As ID2D1Geometry Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal bounds As D2D1_RECT_F Ptr) As HRESULT
    StrokeContainsPoint As Function(ByVal This As ID2D1Geometry Ptr, ByVal point As D2D1_POINT_2F, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal contains As BOOL Ptr) As HRESULT
    FillContainsPoint As Function(ByVal This As ID2D1Geometry Ptr, ByVal point As D2D1_POINT_2F, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal contains As BOOL Ptr) As HRESULT
    CompareWithGeometry As Function(ByVal This As ID2D1Geometry Ptr, ByVal inputGeometry As Any Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal relation As D2D1_GEOMETRY_RELATION Ptr) As HRESULT
    Simplify As Function(ByVal This As ID2D1Geometry Ptr, ByVal simplificationOption As D2D1_GEOMETRY_SIMPLIFICATION_OPTION, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    Tessellate As Function(ByVal This As ID2D1Geometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal tessellationSink As ID2D1TessellationSink Ptr) As HRESULT
    CombineWithGeometry As Function(ByVal This As ID2D1Geometry Ptr, ByVal inputGeometry As ID2D1Geometry Ptr, ByVal combineMode As D2D1_COMBINE_MODE, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    Outline As Function(ByVal This As ID2D1Geometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    ComputeArea As Function(ByVal This As ID2D1Geometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal area As Single Ptr) As HRESULT
    ComputeLength As Function(ByVal This As ID2D1Geometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal length As Single Ptr) As HRESULT
    ComputePointAtLength As Function(ByVal This As ID2D1Geometry Ptr, ByVal length As Single, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal point As D2D1_POINT_2F Ptr, ByVal unitVectorX As D2D1_POINT_2F Ptr) As HRESULT
    Widen As Sub(ByVal This As ID2D1Geometry Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr)
End Type
#define ID2D1Geometry_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Geometry_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Geometry_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Geometry_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1Geometry_GetBounds(p, a, b) (p)->lpVtbl->GetBounds(p, a, b)
#define ID2D1Geometry_GetWidenedBounds(p, a, b, c, d, e) (p)->lpVtbl->GetWidenedBounds(p, a, b, c, d, e)
#define ID2D1Geometry_StrokeContainsPoint(p, a, b, c, d, e, f) (p)->lpVtbl->StrokeContainsPoint(p, a, b, c, d, e, f)
#define ID2D1Geometry_FillContainsPoint(p, a, b, c, d) (p)->lpVtbl->FillContainsPoint(p, a, b, c, d)
#define ID2D1Geometry_CompareWithGeometry(p, a, b, c, d) (p)->lpVtbl->CompareWithGeometry(p, a, b, c, d)
#define ID2D1Geometry_Simplify(p, a, b, c, d) (p)->lpVtbl->Simplify(p, a, b, c, d)
#define ID2D1Geometry_Tessellate(p, a, b, c) (p)->lpVtbl->Tessellate(p, a, b, c)
#define ID2D1Geometry_CombineWithGeometry(p, a, b, c, d, e) (p)->lpVtbl->CombineWithGeometry(p, a, b, c, d, e)
#define ID2D1Geometry_Outline(p, a, b, c) (p)->lpVtbl->Outline(p, a, b, c)
#define ID2D1Geometry_ComputeArea(p, a, b, c) (p)->lpVtbl->ComputeArea(p, a, b, c)
#define ID2D1Geometry_ComputeLength(p, a, b, c) (p)->lpVtbl->ComputeLength(p, a, b, c)
#define ID2D1Geometry_ComputePointAtLength(p, a, b, c, d, e) (p)->lpVtbl->ComputePointAtLength(p, a, b, c, d, e)
#define ID2D1Geometry_Widen(p, a, b, c, d, e) (p)->lpVtbl->Widen(p, a, b, c, d, e)

' ==============================
' ID2D1RectangleGeometry
' ==============================
Type ID2D1RectangleGeometryVtbl As ID2D1RectangleGeometryVtbl_
Type ID2D1RectangleGeometry
    lpVtbl As ID2D1RectangleGeometryVtbl Ptr
End Type
Type ID2D1RectangleGeometryVtbl_     '' Extends ID2D1GeometryVtbl_
    QueryInterface As Function(ByVal This As ID2D1RectangleGeometry Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1RectangleGeometry Ptr) As ULong
    Release As Function(ByVal This As ID2D1RectangleGeometry Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1RectangleGeometry Ptr, ByVal factory As Any Ptr Ptr)
    GetBounds As Function(ByVal This As ID2D1RectangleGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal bounds As D2D1_RECT_F Ptr) As HRESULT
    GetWidenedBounds As Function(ByVal This As ID2D1RectangleGeometry Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal bounds As D2D1_RECT_F Ptr) As HRESULT
    StrokeContainsPoint As Function(ByVal This As ID2D1RectangleGeometry Ptr, ByVal point As D2D1_POINT_2F, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal contains As BOOL Ptr) As HRESULT
    FillContainsPoint As Function(ByVal This As ID2D1RectangleGeometry Ptr, ByVal point As D2D1_POINT_2F, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal contains As BOOL Ptr) As HRESULT
    CompareWithGeometry As Function(ByVal This As ID2D1RectangleGeometry Ptr, ByVal inputGeometry As Any Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal relation As D2D1_GEOMETRY_RELATION Ptr) As HRESULT
    Simplify As Function(ByVal This As ID2D1RectangleGeometry Ptr, ByVal simplificationOption As D2D1_GEOMETRY_SIMPLIFICATION_OPTION, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    Tessellate As Function(ByVal This As ID2D1RectangleGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal tessellationSink As ID2D1TessellationSink Ptr) As HRESULT
    CombineWithGeometry As Function(ByVal This As ID2D1RectangleGeometry Ptr, ByVal inputGeometry As ID2D1RectangleGeometry Ptr, ByVal combineMode As D2D1_COMBINE_MODE, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    Outline As Function(ByVal This As ID2D1RectangleGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    ComputeArea As Function(ByVal This As ID2D1RectangleGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal area As Single Ptr) As HRESULT
    ComputeLength As Function(ByVal This As ID2D1RectangleGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal length As Single Ptr) As HRESULT
    ComputePointAtLength As Function(ByVal This As ID2D1RectangleGeometry Ptr, ByVal length As Single, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal point As D2D1_POINT_2F Ptr, ByVal unitVectorX As D2D1_POINT_2F Ptr) As HRESULT
    Widen As Sub(ByVal This As ID2D1RectangleGeometry Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr)

    GetRect As Sub(ByVal This As ID2D1RectangleGeometry Ptr, ByVal rect As D2D1_RECT_F Ptr)
End Type
#define ID2D1RectangleGeometry_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1RectangleGeometry_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1RectangleGeometry_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1RectangleGeometry_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1RectangleGeometry_GetBounds(p, a, b) (p)->lpVtbl->GetBounds(p, a, b)
#define ID2D1RectangleGeometry_GetWidenedBounds(p, a, b, c, d, e) (p)->lpVtbl->GetWidenedBounds(p, a, b, c, d, e)
#define ID2D1RectangleGeometry_StrokeContainsPoint(p, a, b, c, d, e, f) (p)->lpVtbl->StrokeContainsPoint(p, a, b, c, d, e, f)
#define ID2D1RectangleGeometry_FillContainsPoint(p, a, b, c, d) (p)->lpVtbl->FillContainsPoint(p, a, b, c, d)
#define ID2D1RectangleGeometry_CompareWithGeometry(p, a, b, c, d) (p)->lpVtbl->CompareWithGeometry(p, a, b, c, d)
#define ID2D1RectangleGeometry_Simplify(p, a, b, c, d) (p)->lpVtbl->Simplify(p, a, b, c, d)
#define ID2D1RectangleGeometry_Tessellate(p, a, b, c) (p)->lpVtbl->Tessellate(p, a, b, c)
#define ID2D1RectangleGeometry_CombineWithGeometry(p, a, b, c, d, e) (p)->lpVtbl->CombineWithGeometry(p, a, b, c, d, e)
#define ID2D1RectangleGeometry_Outline(p, a, b, c) (p)->lpVtbl->Outline(p, a, b, c)
#define ID2D1RectangleGeometry_ComputeArea(p, a, b, c) (p)->lpVtbl->ComputeArea(p, a, b, c)
#define ID2D1RectangleGeometry_ComputeLength(p, a, b, c) (p)->lpVtbl->ComputeLength(p, a, b, c)
#define ID2D1RectangleGeometry_ComputePointAtLength(p, a, b, c, d, e) (p)->lpVtbl->ComputePointAtLength(p, a, b, c, d, e)
#define ID2D1RectangleGeometry_Widen(p, a, b, c, d, e) (p)->lpVtbl->Widen(p, a, b, c, d, e)
#define ID2D1RectangleGeometry_GetRect(p, a) (p)->lpVtbl->GetRect(p, a)

' ==============================
' ID2D1RoundedRectangleGeometry
' ==============================
Type ID2D1RoundedRectangleGeometryVtbl As ID2D1RoundedRectangleGeometryVtbl_
Type ID2D1RoundedRectangleGeometry
    lpVtbl As ID2D1RoundedRectangleGeometryVtbl Ptr
End Type
Type ID2D1RoundedRectangleGeometryVtbl_     '' Extends ID2D1GeometryVtbl_
    QueryInterface As Function(ByVal This As ID2D1RoundedRectangleGeometry Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1RoundedRectangleGeometry Ptr) As ULong
    Release As Function(ByVal This As ID2D1RoundedRectangleGeometry Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1RoundedRectangleGeometry Ptr, ByVal factory As Any Ptr Ptr)
    GetBounds As Function(ByVal This As ID2D1RoundedRectangleGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal bounds As D2D1_RECT_F Ptr) As HRESULT
    GetWidenedBounds As Function(ByVal This As ID2D1RoundedRectangleGeometry Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal bounds As D2D1_RECT_F Ptr) As HRESULT
    StrokeContainsPoint As Function(ByVal This As ID2D1RoundedRectangleGeometry Ptr, ByVal point As D2D1_POINT_2F, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal contains As BOOL Ptr) As HRESULT
    FillContainsPoint As Function(ByVal This As ID2D1RoundedRectangleGeometry Ptr, ByVal point As D2D1_POINT_2F, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal contains As BOOL Ptr) As HRESULT
    CompareWithGeometry As Function(ByVal This As ID2D1RoundedRectangleGeometry Ptr, ByVal inputGeometry As Any Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal relation As D2D1_GEOMETRY_RELATION Ptr) As HRESULT
    Simplify As Function(ByVal This As ID2D1RoundedRectangleGeometry Ptr, ByVal simplificationOption As D2D1_GEOMETRY_SIMPLIFICATION_OPTION, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    Tessellate As Function(ByVal This As ID2D1RoundedRectangleGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal tessellationSink As ID2D1TessellationSink Ptr) As HRESULT
    CombineWithGeometry As Function(ByVal This As ID2D1RoundedRectangleGeometry Ptr, ByVal inputGeometry As ID2D1RoundedRectangleGeometry Ptr, ByVal combineMode As D2D1_COMBINE_MODE, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    Outline As Function(ByVal This As ID2D1RoundedRectangleGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    ComputeArea As Function(ByVal This As ID2D1RoundedRectangleGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal area As Single Ptr) As HRESULT
    ComputeLength As Function(ByVal This As ID2D1RoundedRectangleGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal length As Single Ptr) As HRESULT
    ComputePointAtLength As Function(ByVal This As ID2D1RoundedRectangleGeometry Ptr, ByVal length As Single, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal point As D2D1_POINT_2F Ptr, ByVal unitVectorX As D2D1_POINT_2F Ptr) As HRESULT
    Widen As Sub(ByVal This As ID2D1RoundedRectangleGeometry Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr)

    GetRoundedRect As Sub(ByVal This As ID2D1RoundedRectangleGeometry Ptr, ByVal roundedRect As D2D1_ROUNDED_RECT Ptr)
End Type
#define ID2D1RoundedRectangleGeometry_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1RoundedRectangleGeometry_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1RoundedRectangleGeometry_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1RoundedRectangleGeometry_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1RoundedRectangleGeometry_GetBounds(p, a, b) (p)->lpVtbl->GetBounds(p, a, b)
#define ID2D1RoundedRectangleGeometry_GetWidenedBounds(p, a, b, c, d, e) (p)->lpVtbl->GetWidenedBounds(p, a, b, c, d, e)
#define ID2D1RoundedRectangleGeometry_StrokeContainsPoint(p, a, b, c, d, e, f) (p)->lpVtbl->StrokeContainsPoint(p, a, b, c, d, e, f)
#define ID2D1RoundedRectangleGeometry_FillContainsPoint(p, a, b, c, d) (p)->lpVtbl->FillContainsPoint(p, a, b, c, d)
#define ID2D1RoundedRectangleGeometry_CompareWithGeometry(p, a, b, c, d) (p)->lpVtbl->CompareWithGeometry(p, a, b, c, d)
#define ID2D1RoundedRectangleGeometry_Simplify(p, a, b, c, d) (p)->lpVtbl->Simplify(p, a, b, c, d)
#define ID2D1RoundedRectangleGeometry_Tessellate(p, a, b, c) (p)->lpVtbl->Tessellate(p, a, b, c)
#define ID2D1RoundedRectangleGeometry_CombineWithGeometry(p, a, b, c, d, e) (p)->lpVtbl->CombineWithGeometry(p, a, b, c, d, e)
#define ID2D1RoundedRectangleGeometry_Outline(p, a, b, c) (p)->lpVtbl->Outline(p, a, b, c)
#define ID2D1RoundedRectangleGeometry_ComputeArea(p, a, b, c) (p)->lpVtbl->ComputeArea(p, a, b, c)
#define ID2D1RoundedRectangleGeometry_ComputeLength(p, a, b, c) (p)->lpVtbl->ComputeLength(p, a, b, c)
#define ID2D1RoundedRectangleGeometry_ComputePointAtLength(p, a, b, c, d, e) (p)->lpVtbl->ComputePointAtLength(p, a, b, c, d, e)
#define ID2D1RoundedRectangleGeometry_Widen(p, a, b, c, d, e) (p)->lpVtbl->Widen(p, a, b, c, d, e)
#define ID2D1RoundedRectangleGeometry_GetRoundedRect(p, a) (p)->lpVtbl->GetRoundedRect(p, a)

' ==============================
' ID2D1EllipseGeometry
' ==============================
Type ID2D1EllipseGeometryVtbl As ID2D1EllipseGeometryVtbl_
Type ID2D1EllipseGeometry
    lpVtbl As ID2D1EllipseGeometryVtbl Ptr
End Type
Type ID2D1EllipseGeometryVtbl_     '' Extends ID2D1GeometryVtbl_
    QueryInterface As Function(ByVal This As ID2D1EllipseGeometry Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1EllipseGeometry Ptr) As ULong
    Release As Function(ByVal This As ID2D1EllipseGeometry Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1EllipseGeometry Ptr, ByVal factory As Any Ptr Ptr)
    GetBounds As Function(ByVal This As ID2D1EllipseGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal bounds As D2D1_RECT_F Ptr) As HRESULT
    GetWidenedBounds As Function(ByVal This As ID2D1EllipseGeometry Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal bounds As D2D1_RECT_F Ptr) As HRESULT
    StrokeContainsPoint As Function(ByVal This As ID2D1EllipseGeometry Ptr, ByVal point As D2D1_POINT_2F, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal contains As BOOL Ptr) As HRESULT
    FillContainsPoint As Function(ByVal This As ID2D1EllipseGeometry Ptr, ByVal point As D2D1_POINT_2F, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal contains As BOOL Ptr) As HRESULT
    CompareWithGeometry As Function(ByVal This As ID2D1EllipseGeometry Ptr, ByVal inputGeometry As Any Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal relation As D2D1_GEOMETRY_RELATION Ptr) As HRESULT
    Simplify As Function(ByVal This As ID2D1EllipseGeometry Ptr, ByVal simplificationOption As D2D1_GEOMETRY_SIMPLIFICATION_OPTION, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    Tessellate As Function(ByVal This As ID2D1EllipseGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal tessellationSink As ID2D1TessellationSink Ptr) As HRESULT
    CombineWithGeometry As Function(ByVal This As ID2D1EllipseGeometry Ptr, ByVal inputGeometry As ID2D1EllipseGeometry Ptr, ByVal combineMode As D2D1_COMBINE_MODE, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    Outline As Function(ByVal This As ID2D1EllipseGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    ComputeArea As Function(ByVal This As ID2D1EllipseGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal area As Single Ptr) As HRESULT
    ComputeLength As Function(ByVal This As ID2D1EllipseGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal length As Single Ptr) As HRESULT
    ComputePointAtLength As Function(ByVal This As ID2D1EllipseGeometry Ptr, ByVal length As Single, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal point As D2D1_POINT_2F Ptr, ByVal unitVectorX As D2D1_POINT_2F Ptr) As HRESULT
    Widen As Sub(ByVal This As ID2D1EllipseGeometry Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr)

    GetEllipse As Sub(ByVal This As ID2D1EllipseGeometry Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr)
End Type
#define ID2D1EllipseGeometry_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1EllipseGeometry_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1EllipseGeometry_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1EllipseGeometry_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1EllipseGeometry_GetBounds(p, a, b) (p)->lpVtbl->GetBounds(p, a, b)
#define ID2D1EllipseGeometry_GetWidenedBounds(p, a, b, c, d, e) (p)->lpVtbl->GetWidenedBounds(p, a, b, c, d, e)
#define ID2D1EllipseGeometry_StrokeContainsPoint(p, a, b, c, d, e, f) (p)->lpVtbl->StrokeContainsPoint(p, a, b, c, d, e, f)
#define ID2D1EllipseGeometry_FillContainsPoint(p, a, b, c, d) (p)->lpVtbl->FillContainsPoint(p, a, b, c, d)
#define ID2D1EllipseGeometry_CompareWithGeometry(p, a, b, c, d) (p)->lpVtbl->CompareWithGeometry(p, a, b, c, d)
#define ID2D1EllipseGeometry_Simplify(p, a, b, c, d) (p)->lpVtbl->Simplify(p, a, b, c, d)
#define ID2D1EllipseGeometry_Tessellate(p, a, b, c) (p)->lpVtbl->Tessellate(p, a, b, c)
#define ID2D1EllipseGeometry_CombineWithGeometry(p, a, b, c, d, e) (p)->lpVtbl->CombineWithGeometry(p, a, b, c, d, e)
#define ID2D1EllipseGeometry_Outline(p, a, b, c) (p)->lpVtbl->Outline(p, a, b, c)
#define ID2D1EllipseGeometry_ComputeArea(p, a, b, c) (p)->lpVtbl->ComputeArea(p, a, b, c)
#define ID2D1EllipseGeometry_ComputeLength(p, a, b, c) (p)->lpVtbl->ComputeLength(p, a, b, c)
#define ID2D1EllipseGeometry_ComputePointAtLength(p, a, b, c, d, e) (p)->lpVtbl->ComputePointAtLength(p, a, b, c, d, e)
#define ID2D1EllipseGeometry_Widen(p, a, b, c, d, e) (p)->lpVtbl->Widen(p, a, b, c, d, e)
#define ID2D1EllipseGeometry_GetEllipse(p, a) (p)->lpVtbl->GetEllipse(p, a)

' ==============================
' ID2D1GeometryGroup
' ==============================
Type ID2D1GeometryGroupVtbl As ID2D1GeometryGroupVtbl_
Type ID2D1GeometryGroup
    lpVtbl As ID2D1GeometryGroupVtbl Ptr
End Type
Type ID2D1GeometryGroupVtbl_     '' Extends ID2D1GeometryVtbl_
    QueryInterface As Function(ByVal This As ID2D1GeometryGroup Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1GeometryGroup Ptr) As ULong
    Release As Function(ByVal This As ID2D1GeometryGroup Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1GeometryGroup Ptr, ByVal factory As Any Ptr Ptr)
    GetBounds As Function(ByVal This As ID2D1GeometryGroup Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal bounds As D2D1_RECT_F Ptr) As HRESULT
    GetWidenedBounds As Function(ByVal This As ID2D1GeometryGroup Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal bounds As D2D1_RECT_F Ptr) As HRESULT
    StrokeContainsPoint As Function(ByVal This As ID2D1GeometryGroup Ptr, ByVal point As D2D1_POINT_2F, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal contains As BOOL Ptr) As HRESULT
    FillContainsPoint As Function(ByVal This As ID2D1GeometryGroup Ptr, ByVal point As D2D1_POINT_2F, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal contains As BOOL Ptr) As HRESULT
    CompareWithGeometry As Function(ByVal This As ID2D1GeometryGroup Ptr, ByVal inputGeometry As Any Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal relation As D2D1_GEOMETRY_RELATION Ptr) As HRESULT
    Simplify As Function(ByVal This As ID2D1GeometryGroup Ptr, ByVal simplificationOption As D2D1_GEOMETRY_SIMPLIFICATION_OPTION, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    Tessellate As Function(ByVal This As ID2D1GeometryGroup Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal tessellationSink As ID2D1TessellationSink Ptr) As HRESULT
    CombineWithGeometry As Function(ByVal This As ID2D1GeometryGroup Ptr, ByVal inputGeometry As ID2D1GeometryGroup Ptr, ByVal combineMode As D2D1_COMBINE_MODE, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    Outline As Function(ByVal This As ID2D1GeometryGroup Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    ComputeArea As Function(ByVal This As ID2D1GeometryGroup Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal area As Single Ptr) As HRESULT
    ComputeLength As Function(ByVal This As ID2D1GeometryGroup Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal length As Single Ptr) As HRESULT
    ComputePointAtLength As Function(ByVal This As ID2D1GeometryGroup Ptr, ByVal length As Single, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal point As D2D1_POINT_2F Ptr, ByVal unitVectorX As D2D1_POINT_2F Ptr) As HRESULT
    Widen As Sub(ByVal This As ID2D1GeometryGroup Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr)

    GetFillMode As Function(ByVal This As ID2D1GeometryGroup Ptr) As D2D1_FILL_MODE
    GetSourceGeometryCount As Function(ByVal This As ID2D1GeometryGroup Ptr) As ULong
    GetSourceGeometries As Sub(ByVal This As ID2D1GeometryGroup Ptr, ByVal geometries As ID2D1Geometry Ptr Ptr, ByVal geometriesCount As ULong)
End Type
#define ID2D1GeometryGroup_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1GeometryGroup_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1GeometryGroup_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1GeometryGroup_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1GeometryGroup_GetBounds(p, a, b) (p)->lpVtbl->GetBounds(p, a, b)
#define ID2D1GeometryGroup_GetWidenedBounds(p, a, b, c, d, e) (p)->lpVtbl->GetWidenedBounds(p, a, b, c, d, e)
#define ID2D1GeometryGroup_StrokeContainsPoint(p, a, b, c, d, e, f) (p)->lpVtbl->StrokeContainsPoint(p, a, b, c, d, e, f)
#define ID2D1GeometryGroup_FillContainsPoint(p, a, b, c, d) (p)->lpVtbl->FillContainsPoint(p, a, b, c, d)
#define ID2D1GeometryGroup_CompareWithGeometry(p, a, b, c, d) (p)->lpVtbl->CompareWithGeometry(p, a, b, c, d)
#define ID2D1GeometryGroup_Simplify(p, a, b, c, d) (p)->lpVtbl->Simplify(p, a, b, c, d)
#define ID2D1GeometryGroup_Tessellate(p, a, b, c) (p)->lpVtbl->Tessellate(p, a, b, c)
#define ID2D1GeometryGroup_CombineWithGeometry(p, a, b, c, d, e) (p)->lpVtbl->CombineWithGeometry(p, a, b, c, d, e)
#define ID2D1GeometryGroup_Outline(p, a, b, c) (p)->lpVtbl->Outline(p, a, b, c)
#define ID2D1GeometryGroup_ComputeArea(p, a, b, c) (p)->lpVtbl->ComputeArea(p, a, b, c)
#define ID2D1GeometryGroup_ComputeLength(p, a, b, c) (p)->lpVtbl->ComputeLength(p, a, b, c)
#define ID2D1GeometryGroup_ComputePointAtLength(p, a, b, c, d, e) (p)->lpVtbl->ComputePointAtLength(p, a, b, c, d, e)
#define ID2D1GeometryGroup_Widen(p, a, b, c, d, e) (p)->lpVtbl->Widen(p, a, b, c, d, e)
#define ID2D1GeometryGroup_GetFillMode(p, a) (p)->lpVtbl->GetFillMode(p, a)
#define ID2D1GeometryGroup_GetSourceGeometryCount(p, a) (p)->lpVtbl->GetSourceGeometryCount(p, a)
#define ID2D1GeometryGroup_GetSourceGeometries(p, a, b) (p)->lpVtbl->GetSourceGeometries(p, a, b)

' ==============================
' ID2D1TransformedGeometry
' ==============================
Type ID2D1TransformedGeometryVtbl As ID2D1TransformedGeometryVtbl_
Type ID2D1TransformedGeometry
    lpVtbl As ID2D1TransformedGeometryVtbl Ptr
End Type
Type ID2D1TransformedGeometryVtbl_     '' Extends ID2D1GeometryVtbl_
    QueryInterface As Function(ByVal This As ID2D1TransformedGeometry Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1TransformedGeometry Ptr) As ULong
    Release As Function(ByVal This As ID2D1TransformedGeometry Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1TransformedGeometry Ptr, ByVal factory As Any Ptr Ptr)
    GetBounds As Function(ByVal This As ID2D1TransformedGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal bounds As D2D1_RECT_F Ptr) As HRESULT
    GetWidenedBounds As Function(ByVal This As ID2D1TransformedGeometry Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal bounds As D2D1_RECT_F Ptr) As HRESULT
    StrokeContainsPoint As Function(ByVal This As ID2D1TransformedGeometry Ptr, ByVal point As D2D1_POINT_2F, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal contains As BOOL Ptr) As HRESULT
    FillContainsPoint As Function(ByVal This As ID2D1TransformedGeometry Ptr, ByVal point As D2D1_POINT_2F, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal contains As BOOL Ptr) As HRESULT
    CompareWithGeometry As Function(ByVal This As ID2D1TransformedGeometry Ptr, ByVal inputGeometry As Any Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal relation As D2D1_GEOMETRY_RELATION Ptr) As HRESULT
    Simplify As Function(ByVal This As ID2D1TransformedGeometry Ptr, ByVal simplificationOption As D2D1_GEOMETRY_SIMPLIFICATION_OPTION, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    Tessellate As Function(ByVal This As ID2D1TransformedGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal tessellationSink As ID2D1TessellationSink Ptr) As HRESULT
    CombineWithGeometry As Function(ByVal This As ID2D1TransformedGeometry Ptr, ByVal inputGeometry As ID2D1TransformedGeometry Ptr, ByVal combineMode As D2D1_COMBINE_MODE, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    Outline As Function(ByVal This As ID2D1TransformedGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    ComputeArea As Function(ByVal This As ID2D1TransformedGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal area As Single Ptr) As HRESULT
    ComputeLength As Function(ByVal This As ID2D1TransformedGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal length As Single Ptr) As HRESULT
    ComputePointAtLength As Function(ByVal This As ID2D1TransformedGeometry Ptr, ByVal length As Single, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal point As D2D1_POINT_2F Ptr, ByVal unitVectorX As D2D1_POINT_2F Ptr) As HRESULT
    Widen As Sub(ByVal This As ID2D1TransformedGeometry Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr)

    GetSourceGeometry As Sub(ByVal This As ID2D1TransformedGeometry Ptr, ByVal sourceGeometry As ID2D1Geometry Ptr Ptr)
    GetTransform As Sub(ByVal This As ID2D1TransformedGeometry Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
End Type
#define ID2D1TransformedGeometry_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1TransformedGeometry_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1TransformedGeometry_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1TransformedGeometry_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1TransformedGeometry_GetBounds(p, a, b) (p)->lpVtbl->GetBounds(p, a, b)
#define ID2D1TransformedGeometry_GetWidenedBounds(p, a, b, c, d, e) (p)->lpVtbl->GetWidenedBounds(p, a, b, c, d, e)
#define ID2D1TransformedGeometry_StrokeContainsPoint(p, a, b, c, d, e, f) (p)->lpVtbl->StrokeContainsPoint(p, a, b, c, d, e, f)
#define ID2D1TransformedGeometry_FillContainsPoint(p, a, b, c, d) (p)->lpVtbl->FillContainsPoint(p, a, b, c, d)
#define ID2D1TransformedGeometry_CompareWithGeometry(p, a, b, c, d) (p)->lpVtbl->CompareWithGeometry(p, a, b, c, d)
#define ID2D1TransformedGeometry_Simplify(p, a, b, c, d) (p)->lpVtbl->Simplify(p, a, b, c, d)
#define ID2D1TransformedGeometry_Tessellate(p, a, b, c) (p)->lpVtbl->Tessellate(p, a, b, c)
#define ID2D1TransformedGeometry_CombineWithGeometry(p, a, b, c, d, e) (p)->lpVtbl->CombineWithGeometry(p, a, b, c, d, e)
#define ID2D1TransformedGeometry_Outline(p, a, b, c) (p)->lpVtbl->Outline(p, a, b, c)
#define ID2D1TransformedGeometry_ComputeArea(p, a, b, c) (p)->lpVtbl->ComputeArea(p, a, b, c)
#define ID2D1TransformedGeometry_ComputeLength(p, a, b, c) (p)->lpVtbl->ComputeLength(p, a, b, c)
#define ID2D1TransformedGeometry_ComputePointAtLength(p, a, b, c, d, e) (p)->lpVtbl->ComputePointAtLength(p, a, b, c, d, e)
#define ID2D1TransformedGeometry_Widen(p, a, b, c, d, e) (p)->lpVtbl->Widen(p, a, b, c, d, e)
#define ID2D1TransformedGeometry_GetSourceGeometry(p, a) (p)->lpVtbl->GetSourceGeometry(p, a)
#define ID2D1TransformedGeometry_GetTransform(p, a) (p)->lpVtbl->GetTransform(p, a)

' ==============================
' ID2D1PathGeometry
' ==============================
Type ID2D1PathGeometryVtbl As ID2D1PathGeometryVtbl_
Type ID2D1PathGeometry
    lpVtbl As ID2D1PathGeometryVtbl Ptr
End Type
Type ID2D1PathGeometryVtbl_     '' Extends ID2D1GeometryVtbl_
    QueryInterface As Function(ByVal This As ID2D1PathGeometry Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1PathGeometry Ptr) As ULong
    Release As Function(ByVal This As ID2D1PathGeometry Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1PathGeometry Ptr, ByVal factory As Any Ptr Ptr)
    GetBounds As Function(ByVal This As ID2D1PathGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal bounds As D2D1_RECT_F Ptr) As HRESULT
    GetWidenedBounds As Function(ByVal This As ID2D1PathGeometry Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal bounds As D2D1_RECT_F Ptr) As HRESULT
    StrokeContainsPoint As Function(ByVal This As ID2D1PathGeometry Ptr, ByVal point As D2D1_POINT_2F, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal contains As BOOL Ptr) As HRESULT
    FillContainsPoint As Function(ByVal This As ID2D1PathGeometry Ptr, ByVal point As D2D1_POINT_2F, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal contains As BOOL Ptr) As HRESULT
    CompareWithGeometry As Function(ByVal This As ID2D1PathGeometry Ptr, ByVal inputGeometry As Any Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal relation As D2D1_GEOMETRY_RELATION Ptr) As HRESULT
    Simplify As Function(ByVal This As ID2D1PathGeometry Ptr, ByVal simplificationOption As D2D1_GEOMETRY_SIMPLIFICATION_OPTION, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    Tessellate As Function(ByVal This As ID2D1PathGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal tessellationSink As ID2D1TessellationSink Ptr) As HRESULT
    CombineWithGeometry As Function(ByVal This As ID2D1PathGeometry Ptr, ByVal inputGeometry As ID2D1PathGeometry Ptr, ByVal combineMode As D2D1_COMBINE_MODE, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    Outline As Function(ByVal This As ID2D1PathGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    ComputeArea As Function(ByVal This As ID2D1PathGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal area As Single Ptr) As HRESULT
    ComputeLength As Function(ByVal This As ID2D1PathGeometry Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal length As Single Ptr) As HRESULT
    ComputePointAtLength As Function(ByVal This As ID2D1PathGeometry Ptr, ByVal length As Single, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal point As D2D1_POINT_2F Ptr, ByVal unitVectorX As D2D1_POINT_2F Ptr) As HRESULT
    Widen As Sub(ByVal This As ID2D1PathGeometry Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr, ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, ByVal flatteningTolerance As Single, ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr)

    Open As Function(ByVal This As ID2D1PathGeometry Ptr, ByVal geometrySink As ID2D1GeometrySink Ptr Ptr) As HRESULT
    Stream As Function(ByVal This As ID2D1PathGeometry Ptr, ByVal geometrySink As ID2D1GeometrySink Ptr) As HRESULT    
    GetSegmentCount As Function(ByVal This As ID2D1PathGeometry Ptr, ByRef count As ULong) As HRESULT  
    GetFigureCount As Function(ByVal This As ID2D1PathGeometry Ptr, ByRef count As ULong) As HRESULT
End Type
#define ID2D1PathGeometry_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1PathGeometry_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1PathGeometry_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1PathGeometry_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1PathGeometry_GetBounds(p, a, b) (p)->lpVtbl->GetBounds(p, a, b)
#define ID2D1PathGeometry_GetWidenedBounds(p, a, b, c, d, e) (p)->lpVtbl->GetWidenedBounds(p, a, b, c, d, e)
#define ID2D1PathGeometry_StrokeContainsPoint(p, a, b, c, d, e, f) (p)->lpVtbl->StrokeContainsPoint(p, a, b, c, d, e, f)
#define ID2D1PathGeometry_FillContainsPoint(p, a, b, c, d) (p)->lpVtbl->FillContainsPoint(p, a, b, c, d)
#define ID2D1PathGeometry_CompareWithGeometry(p, a, b, c, d) (p)->lpVtbl->CompareWithGeometry(p, a, b, c, d)
#define ID2D1PathGeometry_Simplify(p, a, b, c, d) (p)->lpVtbl->Simplify(p, a, b, c, d)
#define ID2D1PathGeometry_Tessellate(p, a, b, c) (p)->lpVtbl->Tessellate(p, a, b, c)
#define ID2D1PathGeometry_CombineWithGeometry(p, a, b, c, d, e) (p)->lpVtbl->CombineWithGeometry(p, a, b, c, d, e)
#define ID2D1PathGeometry_Outline(p, a, b, c) (p)->lpVtbl->Outline(p, a, b, c)
#define ID2D1PathGeometry_ComputeArea(p, a, b, c) (p)->lpVtbl->ComputeArea(p, a, b, c)
#define ID2D1PathGeometry_ComputeLength(p, a, b, c) (p)->lpVtbl->ComputeLength(p, a, b, c)
#define ID2D1PathGeometry_ComputePointAtLength(p, a, b, c, d, e) (p)->lpVtbl->ComputePointAtLength(p, a, b, c, d, e)
#define ID2D1PathGeometry_Widen(p, a, b, c, d, e) (p)->lpVtbl->Widen(p, a, b, c, d, e)
#define ID2D1PathGeometry_Open(p, a) (p)->lpVtbl->Open(p, a)
#define ID2D1PathGeometry_Stream(p, a) (p)->lpVtbl->Stream(p, a)
#define ID2D1PathGeometry_GetSegmentCount(p, a) (p)->lpVtbl->GetSegmentCount(p, a)
#define ID2D1PathGeometry_GetFigureCount(p, a) (p)->lpVtbl->GetFigureCount(p, a)

Type ID2D1Image
    QueryInterface As Function(ByVal This As Any Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As Any Ptr) As ULong
    Release As Function(ByVal This As Any Ptr) As ULong
    GetFactory As Sub(ByVal This As Any Ptr, ByVal factory As Any Ptr Ptr)
End Type
' ==============================
' ID2D1Bitmap
' ==============================
Type ID2D1BitmapVtbl As ID2D1BitmapVtbl_
Type ID2D1Bitmap
    lpVtbl As ID2D1BitmapVtbl Ptr
End Type
Type ID2D1BitmapVtbl_     '' Extends ID2D1ImageVtbl_
	QueryInterface As Function(ByVal This As ID2D1Bitmap Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Bitmap Ptr) As ULong
    Release As Function(ByVal This As ID2D1Bitmap Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1Bitmap Ptr, ByVal factory As Any Ptr Ptr)
    GetSize As Sub(ByVal This As ID2D1Bitmap Ptr, ByVal size As D2D1_SIZE_F Ptr)
    GetPixelSize As Sub(ByVal This As ID2D1Bitmap Ptr, ByVal pixSize As D2D1_SIZE_U Ptr)
    GetPixelFormat As Sub(ByVal This As ID2D1Bitmap Ptr, ByVal pixFormat As D2D1_PIXEL_FORMAT Ptr)
    GetDpi As Sub(ByVal This As ID2D1Bitmap Ptr, ByRef dpiX As Single, ByRef dpiY As Single)
    CopyFromBitmap As Function(ByVal This As ID2D1Bitmap Ptr, ByVal destPoint As D2D1_POINT_2U Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal srcRect As D2D1_RECT_U Ptr) As HRESULT
    CopyFromRenderTarget As Function(ByVal This As ID2D1Bitmap Ptr, ByVal destPoint As D2D1_POINT_2U Ptr, ByVal renderTarget As Any Ptr, ByVal srcRect As D2D1_RECT_U Ptr) As HRESULT
    CopyFromMemory As Function(ByVal This As ID2D1Bitmap Ptr, ByVal dstRect As D2D1_RECT_U Ptr, ByVal srcData As Any Ptr, ByVal pitch As ULong) As HRESULT
End Type
#define ID2D1Bitmap_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Bitmap_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Bitmap_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Bitmap_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1Bitmap_GetSize(p, a) (p)->lpVtbl->GetSize(p, a)
#define ID2D1Bitmap_GetPixelSize(p, a) (p)->lpVtbl->GetPixelSize(p, a)
#define ID2D1Bitmap_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)
#define ID2D1Bitmap_GetDpi(p, a, b) (p)->lpVtbl->GetDpi(p, a, b)
#define ID2D1Bitmap_CopyFromBitmap(p, a, b, c) (p)->lpVtbl->CopyFromBitmap(p, a, b, c)
#define ID2D1Bitmap_CopyFromRenderTarget(p, a, b, c) (p)->lpVtbl->CopyFromRenderTarget(p, a, b, c)
#define ID2D1Bitmap_CopyFromMemory(p, a, b, c) (p)->lpVtbl->CopyFromMemory(p, a, b, c)

' ==============================
' ID2D1Brush
' ==============================
Type ID2D1BrushVtbl As ID2D1BrushVtbl_
Type ID2D1Brush
    lpVtbl As ID2D1BrushVtbl Ptr
End Type
Type ID2D1BrushVtbl_     '' Extends ID2D1ResourceVtbl_
    QueryInterface As Function(ByVal This As ID2D1Brush Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Brush Ptr) As ULong
    Release As Function(ByVal This As ID2D1Brush Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1Brush Ptr, ByVal factory As Any Ptr Ptr)

        ' 4. ID2D1Resource::GetFactory
    SetOpacity As Sub(ByVal This As ID2D1Brush Ptr, ByVal opacity As Single)
    SetTransform As Sub(ByVal This As ID2D1Brush Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    GetOpacity As Function(ByVal This As ID2D1Brush Ptr) As Single
    GetTransform As Sub(ByVal This As ID2D1Brush Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
End Type
#define ID2D1Brush_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Brush_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Brush_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Brush_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1Brush_SetOpacity(p, a) (p)->lpVtbl->SetOpacity(p, a)
#define ID2D1Brush_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1Brush_GetOpacity(p, a) (p)->lpVtbl->GetOpacity(p, a)
#define ID2D1Brush_GetTransform(p, a) (p)->lpVtbl->GetTransform(p, a)

' ==============================
' ID2D1Brush
' ==============================
Type ID2D1BitmapBrushVtbl As ID2D1BitmapBrushVtbl_
Type ID2D1BitmapBrush
    lpVtbl As ID2D1BitmapBrushVtbl Ptr
End Type
Type ID2D1BitmapBrushVtbl_     '' Extends ID2D1BrushVtbl_
    QueryInterface As Function(ByVal This As ID2D1BitmapBrush Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1BitmapBrush Ptr) As ULong
    Release As Function(ByVal This As ID2D1BitmapBrush Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1BitmapBrush Ptr, ByVal factory As Any Ptr Ptr)
        ' 4. ID2D1Resource::GetFactory
    SetOpacity As Sub(ByVal This As ID2D1BitmapBrush Ptr, ByVal opacity As Single)
    SetTransform As Sub(ByVal This As ID2D1BitmapBrush Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    GetOpacity As Function(ByVal This As ID2D1BitmapBrush Ptr) As Single
    GetTransform As Sub(ByVal This As ID2D1BitmapBrush Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)

    SetExtendModeX As Sub(ByVal This As ID2D1BitmapBrush Ptr, ByVal extendModeX As D2D1_EXTEND_MODE)
    SetExtendModeY As Sub(ByVal This As ID2D1BitmapBrush Ptr, ByVal extendModeY As D2D1_EXTEND_MODE)
    SetInterpolationMode As Sub(ByVal This As ID2D1BitmapBrush Ptr, ByVal interpolationMode As D2D1_BITMAP_INTERPOLATION_MODE)
    SetBitmap As Sub(ByVal This As ID2D1BitmapBrush Ptr, ByVal bitmap As ID2D1Bitmap Ptr)
    GetExtendModeX As Function(ByVal This As ID2D1BitmapBrush Ptr) As D2D1_EXTEND_MODE
    GetExtendModeY As Function(ByVal This As ID2D1BitmapBrush Ptr) As D2D1_EXTEND_MODE
    GetInterpolationMode As Function(ByVal This As ID2D1BitmapBrush Ptr) As D2D1_BITMAP_INTERPOLATION_MODE
    GetBitmap As Sub(ByVal This As ID2D1BitmapBrush Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr)
End Type
#define ID2D1BitmapBrush_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1BitmapBrush_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1BitmapBrush_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1BitmapBrush_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1BitmapBrush_SetOpacity(p, a) (p)->lpVtbl->SetOpacity(p, a)
#define ID2D1BitmapBrush_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1BitmapBrush_GetOpacity(p, a) (p)->lpVtbl->GetOpacity(p, a)
#define ID2D1BitmapBrush_GetTransform(p, a) (p)->lpVtbl->GetTransform(p, a)
#define ID2D1BitmapBrush_SetExtendModeX(p, a) (p)->lpVtbl->SetExtendModeX(p, a)
#define ID2D1BitmapBrush_SetExtendModeY(p, a) (p)->lpVtbl->SetExtendModeY(p, a)
#define ID2D1BitmapBrush_SetInterpolationMode(p, a) (p)->lpVtbl->SetInterpolationMode(p, a)
#define ID2D1BitmapBrush_SetBitmap(p, a) (p)->lpVtbl->SetBitmap(p, a)
#define ID2D1BitmapBrush_GetExtendModeX(p, a) (p)->lpVtbl->GetExtendModeX(p, a)
#define ID2D1BitmapBrush_GetExtendModeY(p, a) (p)->lpVtbl->GetExtendModeY(p, a)
#define ID2D1BitmapBrush_GetInterpolationMode(p, a) (p)->lpVtbl->GetInterpolationMode(p, a)
#define ID2D1BitmapBrush_GetBitmap(p, a) (p)->lpVtbl->GetBitmap(p, a)

' ==============================
' ID2D1SolidColorBrush
' ==============================
Type ID2D1SolidColorBrushVtbl As ID2D1SolidColorBrushVtbl_
Type ID2D1SolidColorBrush
    lpVtbl As ID2D1SolidColorBrushVtbl Ptr
End Type
Type ID2D1SolidColorBrushVtbl_     '' Extends ID2D1BrushVtbl_
    QueryInterface As Function(ByVal This As ID2D1SolidColorBrush Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1SolidColorBrush Ptr) As ULong
    Release As Function(ByVal This As ID2D1SolidColorBrush Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1SolidColorBrush Ptr, ByVal factory As Any Ptr Ptr)
        ' 4. ID2D1Resource::GetFactory
    SetOpacity As Sub(ByVal This As ID2D1SolidColorBrush Ptr, ByVal opacity As Single)
    SetTransform As Sub(ByVal This As ID2D1SolidColorBrush Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    GetOpacity As Function(ByVal This As ID2D1SolidColorBrush Ptr) As Single
    GetTransform As Sub(ByVal This As ID2D1SolidColorBrush Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)

    SetColor As Sub(ByVal This As ID2D1SolidColorBrush Ptr, ByVal color As D2D1_COLOR_F Ptr)
    GetColor As Sub(ByVal This As ID2D1SolidColorBrush Ptr, ByVal color As D2D1_COLOR_F Ptr)
End Type
#define ID2D1SolidColorBrush_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1SolidColorBrush_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1SolidColorBrush_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1SolidColorBrush_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1SolidColorBrush_SetOpacity(p, a) (p)->lpVtbl->SetOpacity(p, a)
#define ID2D1SolidColorBrush_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1SolidColorBrush_GetOpacity(p, a) (p)->lpVtbl->GetOpacity(p, a)
#define ID2D1SolidColorBrush_GetTransform(p, a) (p)->lpVtbl->GetTransform(p, a)
#define ID2D1SolidColorBrush_SetColor(p, a) (p)->lpVtbl->SetColor(p, a)
#define ID2D1SolidColorBrush_GetColor(p, a) (p)->lpVtbl->GetColor(p, a)

' ==============================
' ID2D1GradientStopCollection
' ==============================
Type ID2D1GradientStopCollectionVtbl As ID2D1GradientStopCollectionVtbl_
Type ID2D1GradientStopCollection
    lpVtbl As ID2D1GradientStopCollectionVtbl Ptr
End Type
Type ID2D1GradientStopCollectionVtbl_     '' Extends ID2D1ResourceVtbl_
    QueryInterface As Function(ByVal This As ID2D1GradientStopCollection Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1GradientStopCollection Ptr) As ULong
    Release As Function(ByVal This As ID2D1GradientStopCollection Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1GradientStopCollection Ptr, ByVal factory As Any Ptr Ptr)

        ' 4. ID2D1Resource::GetFactory
    GetGradientStopCount As Function(ByVal This As ID2D1GradientStopCollection Ptr) As ULong
    GetGradientStops As Sub(ByVal This As ID2D1GradientStopCollection Ptr, ByVal gradientStops As D2D1_GRADIENT_STOP Ptr, ByVal gradientStopsCount As ULong)
    GetColorInterpolationGamma As Function(ByVal This As ID2D1GradientStopCollection Ptr) As D2D1_GAMMA
        ' Gibt an, wie die Farben außerhalb des [0,1] Bereichs behandelt werden
    GetExtendMode As Function(ByVal This As ID2D1GradientStopCollection Ptr) As D2D1_EXTEND_MODE
        ' In manchen IDL/Header Versionen: GetColorContext (D2D 1.1+)
        ' In D2D 1.0 ist Slot 9 oft die letzte Methode fur die Stop-Daten.
End Type
#define ID2D1GradientStopCollection_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1GradientStopCollection_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1GradientStopCollection_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1GradientStopCollection_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1GradientStopCollection_GetGradientStopCount(p, a) (p)->lpVtbl->GetGradientStopCount(p, a)
#define ID2D1GradientStopCollection_GetGradientStops(p, a, b) (p)->lpVtbl->GetGradientStops(p, a, b)
#define ID2D1GradientStopCollection_GetColorInterpolationGamma(p, a) (p)->lpVtbl->GetColorInterpolationGamma(p, a)
#define ID2D1GradientStopCollection_GetExtendMode(p, a) (p)->lpVtbl->GetExtendMode(p, a)

' ==============================
' ID2D1LinearGradientBrush
' ==============================
Type ID2D1LinearGradientBrushVtbl As ID2D1LinearGradientBrushVtbl_
Type ID2D1LinearGradientBrush
    lpVtbl As ID2D1LinearGradientBrushVtbl Ptr
End Type
Type ID2D1LinearGradientBrushVtbl_     '' Extends ID2D1BrushVtbl_
    QueryInterface As Function(ByVal This As ID2D1LinearGradientBrush Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1LinearGradientBrush Ptr) As ULong
    Release As Function(ByVal This As ID2D1LinearGradientBrush Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1LinearGradientBrush Ptr, ByVal factory As Any Ptr Ptr)
        ' 4. ID2D1Resource::GetFactory
    SetOpacity As Sub(ByVal This As ID2D1LinearGradientBrush Ptr, ByVal opacity As Single)
    SetTransform As Sub(ByVal This As ID2D1LinearGradientBrush Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    GetOpacity As Function(ByVal This As ID2D1LinearGradientBrush Ptr) As Single
    GetTransform As Sub(ByVal This As ID2D1LinearGradientBrush Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)

    SetStartPoint As Sub(ByVal This As ID2D1LinearGradientBrush Ptr, ByVal startPoint As D2D1_POINT_2F)
    SetEndPoint As Sub(ByVal This As ID2D1LinearGradientBrush Ptr, ByVal endPoint As D2D1_POINT_2F)
    GetStartPoint As Function(ByVal This As ID2D1LinearGradientBrush Ptr) As D2D1_POINT_2F
    GetEndPoint As Function(ByVal This As ID2D1LinearGradientBrush Ptr) As D2D1_POINT_2F
    GetGradientStopCollection As Sub(ByVal This As ID2D1LinearGradientBrush Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr Ptr)
End Type
#define ID2D1LinearGradientBrush_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1LinearGradientBrush_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1LinearGradientBrush_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1LinearGradientBrush_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1LinearGradientBrush_SetOpacity(p, a) (p)->lpVtbl->SetOpacity(p, a)
#define ID2D1LinearGradientBrush_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1LinearGradientBrush_GetOpacity(p, a) (p)->lpVtbl->GetOpacity(p, a)
#define ID2D1LinearGradientBrush_GetTransform(p, a) (p)->lpVtbl->GetTransform(p, a)
#define ID2D1LinearGradientBrush_SetStartPoint(p, a) (p)->lpVtbl->SetStartPoint(p, a)
#define ID2D1LinearGradientBrush_SetEndPoint(p, a) (p)->lpVtbl->SetEndPoint(p, a)
#define ID2D1LinearGradientBrush_GetStartPoint(p, a) (p)->lpVtbl->GetStartPoint(p, a)
#define ID2D1LinearGradientBrush_GetEndPoint(p, a) (p)->lpVtbl->GetEndPoint(p, a)
#define ID2D1LinearGradientBrush_GetGradientStopCollection(p, a) (p)->lpVtbl->GetGradientStopCollection(p, a)

' ==============================
' ID2D1RadialGradientBrush
' ==============================
Type ID2D1RadialGradientBrushVtbl As ID2D1RadialGradientBrushVtbl_
Type ID2D1RadialGradientBrush
    lpVtbl As ID2D1RadialGradientBrushVtbl Ptr
End Type
Type ID2D1RadialGradientBrushVtbl_     '' Extends ID2D1BrushVtbl_
    QueryInterface As Function(ByVal This As ID2D1RadialGradientBrush Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1RadialGradientBrush Ptr) As ULong
    Release As Function(ByVal This As ID2D1RadialGradientBrush Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1RadialGradientBrush Ptr, ByVal factory As Any Ptr Ptr)
        ' 4. ID2D1Resource::GetFactory
    SetOpacity As Sub(ByVal This As ID2D1RadialGradientBrush Ptr, ByVal opacity As Single)
    SetTransform As Sub(ByVal This As ID2D1RadialGradientBrush Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    GetOpacity As Function(ByVal This As ID2D1RadialGradientBrush Ptr) As Single
    GetTransform As Sub(ByVal This As ID2D1RadialGradientBrush Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)

    SetCenter As Sub(ByVal This As ID2D1RadialGradientBrush Ptr, ByVal center As D2D1_POINT_2F)
    SetGradientOriginOffset As Sub(ByVal This As ID2D1RadialGradientBrush Ptr, ByVal gradientOriginOffset As D2D1_POINT_2F)
    SetRadiusX As Sub(ByVal This As ID2D1RadialGradientBrush Ptr, ByVal radiusX As Single)
    SetRadiusY As Sub(ByVal This As ID2D1RadialGradientBrush Ptr, ByVal radiusY As Single)
    GetCenter As Function(ByVal This As ID2D1RadialGradientBrush Ptr) As D2D1_POINT_2F
    GetGradientOriginOffset As Function(ByVal This As ID2D1RadialGradientBrush Ptr) As D2D1_POINT_2F
    GetRadiusX As Function(ByVal This As ID2D1RadialGradientBrush Ptr) As Single
    GetRadiusY As Function(ByVal This As ID2D1RadialGradientBrush Ptr) As Single
    GetGradientStopCollection As Sub(ByVal This As ID2D1RadialGradientBrush Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr Ptr)
End Type
#define ID2D1RadialGradientBrush_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1RadialGradientBrush_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1RadialGradientBrush_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1RadialGradientBrush_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1RadialGradientBrush_SetOpacity(p, a) (p)->lpVtbl->SetOpacity(p, a)
#define ID2D1RadialGradientBrush_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1RadialGradientBrush_GetOpacity(p, a) (p)->lpVtbl->GetOpacity(p, a)
#define ID2D1RadialGradientBrush_GetTransform(p, a) (p)->lpVtbl->GetTransform(p, a)
#define ID2D1RadialGradientBrush_SetCenter(p, a) (p)->lpVtbl->SetCenter(p, a)
#define ID2D1RadialGradientBrush_SetGradientOriginOffset(p, a) (p)->lpVtbl->SetGradientOriginOffset(p, a)
#define ID2D1RadialGradientBrush_SetRadiusX(p, a) (p)->lpVtbl->SetRadiusX(p, a)
#define ID2D1RadialGradientBrush_SetRadiusY(p, a) (p)->lpVtbl->SetRadiusY(p, a)
#define ID2D1RadialGradientBrush_GetCenter(p, a) (p)->lpVtbl->GetCenter(p, a)
#define ID2D1RadialGradientBrush_GetGradientOriginOffset(p, a) (p)->lpVtbl->GetGradientOriginOffset(p, a)
#define ID2D1RadialGradientBrush_GetRadiusX(p, a) (p)->lpVtbl->GetRadiusX(p, a)
#define ID2D1RadialGradientBrush_GetRadiusY(p, a) (p)->lpVtbl->GetRadiusY(p, a)
#define ID2D1RadialGradientBrush_GetGradientStopCollection(p, a) (p)->lpVtbl->GetGradientStopCollection(p, a)

' ==============================
' ID2D1Layer
' ==============================
Type ID2D1LayerVtbl As ID2D1LayerVtbl_
Type ID2D1Layer
    lpVtbl As ID2D1LayerVtbl Ptr
End Type
Type ID2D1LayerVtbl_     '' Extends ID2D1ResourceVtbl_
    QueryInterface As Function(ByVal This As ID2D1Layer Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Layer Ptr) As ULong
    Release As Function(ByVal This As ID2D1Layer Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1Layer Ptr, ByVal factory As Any Ptr Ptr)

    GetSize As Function(ByVal This As ID2D1Layer Ptr) As D2D1_SIZE_F
End Type
#define ID2D1Layer_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Layer_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Layer_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Layer_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1Layer_GetSize(p, a) (p)->lpVtbl->GetSize(p, a)

' ==============================
' ID2D1Mesh
' ==============================
Type ID2D1MeshVtbl As ID2D1MeshVtbl_
Type ID2D1Mesh
    lpVtbl As ID2D1MeshVtbl Ptr
End Type
Type ID2D1MeshVtbl_     '' Extends ID2D1ResourceVtbl_
    QueryInterface As Function(ByVal This As ID2D1Mesh Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Mesh Ptr) As ULong
    Release As Function(ByVal This As ID2D1Mesh Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1Mesh Ptr, ByVal factory As Any Ptr Ptr)

    Open As Function(ByVal This As ID2D1Mesh Ptr, ByVal tessellationSink As ID2D1TessellationSink Ptr Ptr) As HRESULT
End Type
#define ID2D1Mesh_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Mesh_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Mesh_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Mesh_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1Mesh_Open(p, a) (p)->lpVtbl->Open(p, a)

' ==============================
' ID2D1RenderTarget
' ==============================
Type ID2D1RenderTargetVtbl As ID2D1RenderTargetVtbl_
Type ID2D1RenderTarget
    lpVtbl As ID2D1RenderTargetVtbl Ptr
End Type
Type ID2D1RenderTargetVtbl_     '' Extends ID2D1ResourceVtbl_
    QueryInterface As Function(ByVal This As ID2D1RenderTarget Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1RenderTarget Ptr) As ULong
    Release As Function(ByVal This As ID2D1RenderTarget Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal factory As Any Ptr Ptr)

        ' 4.   (ID2D1Resource: GetFactory)
    CreateBitmap As Function(ByVal This As ID2D1RenderTarget Ptr, ByVal size As D2D1_SIZE_U, ByVal srcData As Any Ptr, ByVal pitch As ULong, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapFromWicBitmap As Function(ByVal This As ID2D1RenderTarget Ptr, ByVal wicBitmapSource As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateSharedBitmap As Function(ByVal This As ID2D1RenderTarget Ptr, ByVal riid As GUID Ptr, ByVal data As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapBrush As Function(ByVal This As ID2D1RenderTarget Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal bitmapBrushProperties As D2D1_BITMAP_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal bitmapBrush As ID2D1BitmapBrush Ptr Ptr) As HRESULT
    CreateSolidColorBrush As Function(ByVal This As ID2D1RenderTarget Ptr, ByVal color As D2D1_COLOR_F Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal solidColorBrush As ID2D1SolidColorBrush Ptr Ptr) As HRESULT
    CreateGradientStopCollection As Function(ByVal This As ID2D1RenderTarget Ptr, ByVal gradientStops As D2D1_GRADIENT_STOP Ptr, ByVal gradientStopsCount As ULong, ByVal colorInterpolationGamma As D2D1_GAMMA, ByVal extendMode As D2D1_EXTEND_MODE, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr Ptr) As HRESULT
    CreateLinearGradientBrush As Function(ByVal This As ID2D1RenderTarget Ptr, ByVal linearGradientBrushProperties As D2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal linearGradientBrush As ID2D1LinearGradientBrush Ptr Ptr) As HRESULT
    CreateRadialGradientBrush As Function(ByVal This As ID2D1RenderTarget Ptr, ByVal radialGradientBrushProperties As D2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal radialGradientBrush As ID2D1RadialGradientBrush Ptr Ptr) As HRESULT
    CreateCompatibleRenderTarget As Function(ByVal This As ID2D1RenderTarget Ptr, ByVal desiredSize As D2D1_SIZE_F Ptr, ByVal desiredPixelSize As D2D1_SIZE_U Ptr, ByVal desiredFormat As D2D1_PIXEL_FORMAT Ptr, ByVal options As ULong, ByVal bitmapRenderTarget As Any Ptr Ptr) As HRESULT 'ID2D1BitmapRenderTarget
    CreateLayer As Function(ByVal This As ID2D1RenderTarget Ptr, ByVal size As D2D1_SIZE_F Ptr, ByVal layer As ID2D1Layer Ptr Ptr) As HRESULT
    CreateMesh As Function(ByVal This As ID2D1RenderTarget Ptr, ByVal mesh As ID2D1Mesh Ptr Ptr) As HRESULT
    DrawLine As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal p0 As D2D1_POINT_2F, ByVal p1 As D2D1_POINT_2F, ByVal brush As ID2D1SolidColorBrush Ptr, ByVal strokeWidth As Single = 0, ByVal strokeStyle As ID2D1StrokeStyle Ptr = NULL)
    DrawRectangle As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRectangle As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawRoundedRectangle As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRoundedRectangle As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawEllipse As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillEllipse As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawGeometry As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillGeometry As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal opacityBrush As ID2D1Brush Ptr)
    FillMesh As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal mesh As ID2D1Mesh Ptr, ByVal brush As ID2D1Brush Ptr)
    FillOpacityMask As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal mask As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal content As D2D1_OPACITY_MASK_CONTENT, ByVal destRect As D2D1_RECT_F Ptr, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawBitmap As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal destRect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolationMode As D2D1_BITMAP_INTERPOLATION_MODE, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawText As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal text As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal layoutRect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS = 0, ByVal measuringMode As DWRITE_MEASURING_MODE = 0)
    DrawTextLayout As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal origin As D2D1_POINT_2F, ByVal layout As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS)
    DrawGlyphRun As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal baselineOrigin As D2D1_POINT_2F Ptr, ByVal glyphRun As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE)
    SetTransform As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    GetTransform As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    SetAntialiasMode As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    GetAntialiasMode As Function(ByVal This As ID2D1RenderTarget Ptr) As D2D1_ANTIALIAS_MODE
    SetTextAntialiasMode As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal antialiasMode As D2D1_TEXT_ANTIALIAS_MODE)
    GetTextAntialiasMode As Function(ByVal This As ID2D1RenderTarget Ptr) As D2D1_TEXT_ANTIALIAS_MODE
    SetTextRenderingParams As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal params As Any Ptr)
    GetTextRenderingParams As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal params As Any Ptr Ptr)
    SetTags As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal tag1 As D2D1_TAG, ByVal tag2 As D2D1_TAG)
    GetTags As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr)
    PushLayer As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal layerParams As D2D1_LAYER_PARAMETERS Ptr, ByVal layer As ID2D1Layer Ptr)
    PopLayer As Sub(ByVal This As ID2D1RenderTarget Ptr)
    Flush As Function(ByVal This As ID2D1RenderTarget Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    SaveDrawingState As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal stateBlock As Any Ptr)
    RestoreDrawingState As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal stateBlock As Any Ptr)
    PushAxisAlignedClip As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    PopAxisAlignedClip As Sub(ByVal This As ID2D1RenderTarget Ptr)
    Clear As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal col As D2D1_COLOR_F Ptr)
    BeginDraw As Sub(ByVal This As ID2D1RenderTarget Ptr)
    EndDraw As Function(ByVal This As ID2D1RenderTarget Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    GetPixelFormat As Function(ByVal This As ID2D1RenderTarget Ptr) As D2D1_PIXEL_FORMAT
    SetDpi As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal dpiX As Single, ByVal dpiY As Single)
    GetDpi As Sub(ByVal This As ID2D1RenderTarget Ptr, ByVal dpiX As Single Ptr, ByVal dpiY As Single Ptr)
    GetSize As Function(ByVal This As ID2D1RenderTarget Ptr, ByVal size As Any Ptr) As D2D1_SIZE_F
    GetPixelSize As Function(ByVal This As ID2D1RenderTarget Ptr, ByVal pixelSize As Any Ptr) As D2D1_SIZE_U
    GetMaximumBitmapSize As Function(ByVal This As ID2D1RenderTarget Ptr) As ULong
    IsSupported As Function(ByVal This As ID2D1RenderTarget Ptr, ByVal renderTargetProperties As D2D1_RENDER_TARGET_PROPERTIES Ptr) As BOOL
End Type
#define ID2D1RenderTarget_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1RenderTarget_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1RenderTarget_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1RenderTarget_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1RenderTarget_CreateBitmap(p, a, b, c, d, e) (p)->lpVtbl->CreateBitmap(p, a, b, c, d, e)
#define ID2D1RenderTarget_CreateBitmapFromWicBitmap(p, a, b, c) (p)->lpVtbl->CreateBitmapFromWicBitmap(p, a, b, c)
#define ID2D1RenderTarget_CreateSharedBitmap(p, a, b, c, d) (p)->lpVtbl->CreateSharedBitmap(p, a, b, c, d)
#define ID2D1RenderTarget_CreateBitmapBrush(p, a, b, c, d) (p)->lpVtbl->CreateBitmapBrush(p, a, b, c, d)
#define ID2D1RenderTarget_CreateSolidColorBrush(p, a, b, c) (p)->lpVtbl->CreateSolidColorBrush(p, a, b, c)
#define ID2D1RenderTarget_CreateGradientStopCollection(p, a, b, c, d, e) (p)->lpVtbl->CreateGradientStopCollection(p, a, b, c, d, e)
#define ID2D1RenderTarget_CreateLinearGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateLinearGradientBrush(p, a, b, c, d)
#define ID2D1RenderTarget_CreateRadialGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateRadialGradientBrush(p, a, b, c, d)
#define ID2D1RenderTarget_CreateCompatibleRenderTarget(p, a, b, c, d, e) (p)->lpVtbl->CreateCompatibleRenderTarget(p, a, b, c, d, e)
#define ID2D1RenderTarget_CreateLayer(p, a, b) (p)->lpVtbl->CreateLayer(p, a, b)
#define ID2D1RenderTarget_CreateMesh(p, a) (p)->lpVtbl->CreateMesh(p, a)
#define ID2D1RenderTarget_DrawLine(p, a, b, c, d, e) (p)->lpVtbl->DrawLine(p, a, b, c, d, e)
#define ID2D1RenderTarget_DrawRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRectangle(p, a, b, c, d)
#define ID2D1RenderTarget_FillRectangle(p, a, b) (p)->lpVtbl->FillRectangle(p, a, b)
#define ID2D1RenderTarget_DrawRoundedRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRoundedRectangle(p, a, b, c, d)
#define ID2D1RenderTarget_FillRoundedRectangle(p, a, b) (p)->lpVtbl->FillRoundedRectangle(p, a, b)
#define ID2D1RenderTarget_DrawEllipse(p, a, b, c, d) (p)->lpVtbl->DrawEllipse(p, a, b, c, d)
#define ID2D1RenderTarget_FillEllipse(p, a, b) (p)->lpVtbl->FillEllipse(p, a, b)
#define ID2D1RenderTarget_DrawGeometry(p, a, b, c, d) (p)->lpVtbl->DrawGeometry(p, a, b, c, d)
#define ID2D1RenderTarget_FillGeometry(p, a, b, c) (p)->lpVtbl->FillGeometry(p, a, b, c)
#define ID2D1RenderTarget_FillMesh(p, a, b) (p)->lpVtbl->FillMesh(p, a, b)
#define ID2D1RenderTarget_FillOpacityMask(p, a, b, c, d, e) (p)->lpVtbl->FillOpacityMask(p, a, b, c, d, e)
#define ID2D1RenderTarget_DrawBitmap(p, a, b, c, d, e) (p)->lpVtbl->DrawBitmap(p, a, b, c, d, e)
#define ID2D1RenderTarget_DrawText(p, a, b, c, d, e, f, g) (p)->lpVtbl->DrawText(p, a, b, c, d, e, f, g)
#define ID2D1RenderTarget_DrawTextLayout(p, a, b, c, d) (p)->lpVtbl->DrawTextLayout(p, a, b, c, d)
#define ID2D1RenderTarget_DrawGlyphRun(p, a, b, c, d) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d)
#define ID2D1RenderTarget_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1RenderTarget_GetTransform(p, a) (p)->lpVtbl->GetTransform(p, a)
#define ID2D1RenderTarget_SetAntialiasMode(p, a) (p)->lpVtbl->SetAntialiasMode(p, a)
#define ID2D1RenderTarget_GetAntialiasMode(p, a) (p)->lpVtbl->GetAntialiasMode(p, a)
#define ID2D1RenderTarget_SetTextAntialiasMode(p, a) (p)->lpVtbl->SetTextAntialiasMode(p, a)
#define ID2D1RenderTarget_GetTextAntialiasMode(p, a) (p)->lpVtbl->GetTextAntialiasMode(p, a)
#define ID2D1RenderTarget_SetTextRenderingParams(p, a) (p)->lpVtbl->SetTextRenderingParams(p, a)
#define ID2D1RenderTarget_GetTextRenderingParams(p, a) (p)->lpVtbl->GetTextRenderingParams(p, a)
#define ID2D1RenderTarget_SetTags(p, a, b) (p)->lpVtbl->SetTags(p, a, b)
#define ID2D1RenderTarget_GetTags(p, a, b) (p)->lpVtbl->GetTags(p, a, b)
#define ID2D1RenderTarget_PushLayer(p, a, b) (p)->lpVtbl->PushLayer(p, a, b)
#define ID2D1RenderTarget_PopLayer(p, a) (p)->lpVtbl->PopLayer(p, a)
#define ID2D1RenderTarget_Flush(p, a, b) (p)->lpVtbl->Flush(p, a, b)
#define ID2D1RenderTarget_SaveDrawingState(p, a) (p)->lpVtbl->SaveDrawingState(p, a)
#define ID2D1RenderTarget_RestoreDrawingState(p, a) (p)->lpVtbl->RestoreDrawingState(p, a)
#define ID2D1RenderTarget_PushAxisAlignedClip(p, a, b) (p)->lpVtbl->PushAxisAlignedClip(p, a, b)
#define ID2D1RenderTarget_PopAxisAlignedClip(p, a) (p)->lpVtbl->PopAxisAlignedClip(p, a)
#define ID2D1RenderTarget_Clear(p, a) (p)->lpVtbl->Clear(p, a)
#define ID2D1RenderTarget_BeginDraw(p, a) (p)->lpVtbl->BeginDraw(p, a)
#define ID2D1RenderTarget_EndDraw(p, a, b) (p)->lpVtbl->EndDraw(p, a, b)
#define ID2D1RenderTarget_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)
#define ID2D1RenderTarget_SetDpi(p, a, b) (p)->lpVtbl->SetDpi(p, a, b)
#define ID2D1RenderTarget_GetDpi(p, a, b) (p)->lpVtbl->GetDpi(p, a, b)
#define ID2D1RenderTarget_GetSize(p, a) (p)->lpVtbl->GetSize(p, a)
#define ID2D1RenderTarget_GetPixelSize(p, a) (p)->lpVtbl->GetPixelSize(p, a)
#define ID2D1RenderTarget_GetMaximumBitmapSize(p, a) (p)->lpVtbl->GetMaximumBitmapSize(p, a)
#define ID2D1RenderTarget_IsSupported(p, a) (p)->lpVtbl->IsSupported(p, a)

' ==============================
' ID2D1HwndRenderTarget
' ==============================
Type ID2D1HwndRenderTargetVtbl As ID2D1HwndRenderTargetVtbl_
Type ID2D1HwndRenderTarget
    lpVtbl As ID2D1HwndRenderTargetVtbl Ptr
End Type
Type ID2D1HwndRenderTargetVtbl_     '' Extends ID2D1RenderTargetVtbl_
    QueryInterface As Function(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1HwndRenderTarget Ptr) As ULong
    Release As Function(ByVal This As ID2D1HwndRenderTarget Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal factory As Any Ptr Ptr)
        ' 4.   (ID2D1Resource: GetFactory)
    CreateBitmap As Function(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal size As D2D1_SIZE_U, ByVal srcData As Any Ptr, ByVal pitch As ULong, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapFromWicBitmap As Function(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal wicBitmapSource As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateSharedBitmap As Function(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal riid As GUID Ptr, ByVal data As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapBrush As Function(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal bitmapBrushProperties As D2D1_BITMAP_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal bitmapBrush As ID2D1BitmapBrush Ptr Ptr) As HRESULT
    CreateSolidColorBrush As Function(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal color As D2D1_COLOR_F Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal solidColorBrush As ID2D1SolidColorBrush Ptr Ptr) As HRESULT
    CreateGradientStopCollection As Function(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal gradientStops As D2D1_GRADIENT_STOP Ptr, ByVal gradientStopsCount As ULong, ByVal colorInterpolationGamma As D2D1_GAMMA, ByVal extendMode As D2D1_EXTEND_MODE, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr Ptr) As HRESULT
    CreateLinearGradientBrush As Function(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal linearGradientBrushProperties As D2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal linearGradientBrush As ID2D1LinearGradientBrush Ptr Ptr) As HRESULT
    CreateRadialGradientBrush As Function(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal radialGradientBrushProperties As D2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal radialGradientBrush As ID2D1RadialGradientBrush Ptr Ptr) As HRESULT
    CreateCompatibleRenderTarget As Function(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal desiredSize As D2D1_SIZE_F Ptr, ByVal desiredPixelSize As D2D1_SIZE_U Ptr, ByVal desiredFormat As D2D1_PIXEL_FORMAT Ptr, ByVal options As ULong, ByVal bitmapRenderTarget As Any Ptr Ptr) As HRESULT 'ID2D1BitmapRenderTarget
    CreateLayer As Function(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal size As D2D1_SIZE_F Ptr, ByVal layer As ID2D1Layer Ptr Ptr) As HRESULT
    CreateMesh As Function(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal mesh As ID2D1Mesh Ptr Ptr) As HRESULT
    DrawLine As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal p0 As D2D1_POINT_2F, ByVal p1 As D2D1_POINT_2F, ByVal brush As ID2D1SolidColorBrush Ptr, ByVal strokeWidth As Single = 0, ByVal strokeStyle As ID2D1StrokeStyle Ptr = NULL)
    DrawRectangle As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRectangle As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawRoundedRectangle As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRoundedRectangle As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawEllipse As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillEllipse As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawGeometry As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillGeometry As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal opacityBrush As ID2D1Brush Ptr)
    FillMesh As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal mesh As ID2D1Mesh Ptr, ByVal brush As ID2D1Brush Ptr)
    FillOpacityMask As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal mask As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal content As D2D1_OPACITY_MASK_CONTENT, ByVal destRect As D2D1_RECT_F Ptr, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawBitmap As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal destRect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolationMode As D2D1_BITMAP_INTERPOLATION_MODE, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawText As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal text As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal layoutRect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS = 0, ByVal measuringMode As DWRITE_MEASURING_MODE = 0)
    DrawTextLayout As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal origin As D2D1_POINT_2F, ByVal layout As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS)
    DrawGlyphRun As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal baselineOrigin As D2D1_POINT_2F Ptr, ByVal glyphRun As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE)
    SetTransform As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    GetTransform As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    SetAntialiasMode As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    GetAntialiasMode As Function(ByVal This As ID2D1HwndRenderTarget Ptr) As D2D1_ANTIALIAS_MODE
    SetTextAntialiasMode As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal antialiasMode As D2D1_TEXT_ANTIALIAS_MODE)
    GetTextAntialiasMode As Function(ByVal This As ID2D1HwndRenderTarget Ptr) As D2D1_TEXT_ANTIALIAS_MODE
    SetTextRenderingParams As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal params As Any Ptr)
    GetTextRenderingParams As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal params As Any Ptr Ptr)
    SetTags As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal tag1 As D2D1_TAG, ByVal tag2 As D2D1_TAG)
    GetTags As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr)
    PushLayer As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal layerParams As D2D1_LAYER_PARAMETERS Ptr, ByVal layer As ID2D1Layer Ptr)
    PopLayer As Sub(ByVal This As ID2D1HwndRenderTarget Ptr)
    Flush As Function(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    SaveDrawingState As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal stateBlock As Any Ptr)
    RestoreDrawingState As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal stateBlock As Any Ptr)
    PushAxisAlignedClip As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    PopAxisAlignedClip As Sub(ByVal This As ID2D1HwndRenderTarget Ptr)
    Clear As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal col As D2D1_COLOR_F Ptr)
    BeginDraw As Sub(ByVal This As ID2D1HwndRenderTarget Ptr)
    EndDraw As Function(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    GetPixelFormat As Function(ByVal This As ID2D1HwndRenderTarget Ptr) As D2D1_PIXEL_FORMAT
    SetDpi As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal dpiX As Single, ByVal dpiY As Single)
    GetDpi As Sub(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal dpiX As Single Ptr, ByVal dpiY As Single Ptr)
    GetSize As Function(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal size As Any Ptr) As D2D1_SIZE_F
    GetPixelSize As Function(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal pixelSize As Any Ptr) As D2D1_SIZE_U
    GetMaximumBitmapSize As Function(ByVal This As ID2D1HwndRenderTarget Ptr) As ULong
    IsSupported As Function(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal renderTargetProperties As D2D1_RENDER_TARGET_PROPERTIES Ptr) As BOOL

    CheckWindowState As Function(ByVal This As ID2D1HwndRenderTarget Ptr) As D2D1_WINDOW_STATE
    Resize As Function(ByVal This As ID2D1HwndRenderTarget Ptr, ByVal sz As D2D1_SIZE_U Ptr) As HRESULT
    GetHwnd As Function(ByVal This As ID2D1HwndRenderTarget Ptr) As HWND
End Type
#define ID2D1HwndRenderTarget_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1HwndRenderTarget_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1HwndRenderTarget_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1HwndRenderTarget_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1HwndRenderTarget_CreateBitmap(p, a, b, c, d, e) (p)->lpVtbl->CreateBitmap(p, a, b, c, d, e)
#define ID2D1HwndRenderTarget_CreateBitmapFromWicBitmap(p, a, b, c) (p)->lpVtbl->CreateBitmapFromWicBitmap(p, a, b, c)
#define ID2D1HwndRenderTarget_CreateSharedBitmap(p, a, b, c, d) (p)->lpVtbl->CreateSharedBitmap(p, a, b, c, d)
#define ID2D1HwndRenderTarget_CreateBitmapBrush(p, a, b, c, d) (p)->lpVtbl->CreateBitmapBrush(p, a, b, c, d)
#define ID2D1HwndRenderTarget_CreateSolidColorBrush(p, a, b, c) (p)->lpVtbl->CreateSolidColorBrush(p, a, b, c)
#define ID2D1HwndRenderTarget_CreateGradientStopCollection(p, a, b, c, d, e) (p)->lpVtbl->CreateGradientStopCollection(p, a, b, c, d, e)
#define ID2D1HwndRenderTarget_CreateLinearGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateLinearGradientBrush(p, a, b, c, d)
#define ID2D1HwndRenderTarget_CreateRadialGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateRadialGradientBrush(p, a, b, c, d)
#define ID2D1HwndRenderTarget_CreateCompatibleRenderTarget(p, a, b, c, d, e) (p)->lpVtbl->CreateCompatibleRenderTarget(p, a, b, c, d, e)
#define ID2D1HwndRenderTarget_CreateLayer(p, a, b) (p)->lpVtbl->CreateLayer(p, a, b)
#define ID2D1HwndRenderTarget_CreateMesh(p, a) (p)->lpVtbl->CreateMesh(p, a)
#define ID2D1HwndRenderTarget_DrawLine(p, a, b, c, d, e) (p)->lpVtbl->DrawLine(p, a, b, c, d, e)
#define ID2D1HwndRenderTarget_DrawRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRectangle(p, a, b, c, d)
#define ID2D1HwndRenderTarget_FillRectangle(p, a, b) (p)->lpVtbl->FillRectangle(p, a, b)
#define ID2D1HwndRenderTarget_DrawRoundedRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRoundedRectangle(p, a, b, c, d)
#define ID2D1HwndRenderTarget_FillRoundedRectangle(p, a, b) (p)->lpVtbl->FillRoundedRectangle(p, a, b)
#define ID2D1HwndRenderTarget_DrawEllipse(p, a, b, c, d) (p)->lpVtbl->DrawEllipse(p, a, b, c, d)
#define ID2D1HwndRenderTarget_FillEllipse(p, a, b) (p)->lpVtbl->FillEllipse(p, a, b)
#define ID2D1HwndRenderTarget_DrawGeometry(p, a, b, c, d) (p)->lpVtbl->DrawGeometry(p, a, b, c, d)
#define ID2D1HwndRenderTarget_FillGeometry(p, a, b, c) (p)->lpVtbl->FillGeometry(p, a, b, c)
#define ID2D1HwndRenderTarget_FillMesh(p, a, b) (p)->lpVtbl->FillMesh(p, a, b)
#define ID2D1HwndRenderTarget_FillOpacityMask(p, a, b, c, d, e) (p)->lpVtbl->FillOpacityMask(p, a, b, c, d, e)
#define ID2D1HwndRenderTarget_DrawBitmap(p, a, b, c, d, e) (p)->lpVtbl->DrawBitmap(p, a, b, c, d, e)
#define ID2D1HwndRenderTarget_DrawText(p, a, b, c, d, e, f, g) (p)->lpVtbl->DrawText(p, a, b, c, d, e, f, g)
#define ID2D1HwndRenderTarget_DrawTextLayout(p, a, b, c, d) (p)->lpVtbl->DrawTextLayout(p, a, b, c, d)
#define ID2D1HwndRenderTarget_DrawGlyphRun(p, a, b, c, d) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d)
#define ID2D1HwndRenderTarget_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1HwndRenderTarget_GetTransform(p, a) (p)->lpVtbl->GetTransform(p, a)
#define ID2D1HwndRenderTarget_SetAntialiasMode(p, a) (p)->lpVtbl->SetAntialiasMode(p, a)
#define ID2D1HwndRenderTarget_GetAntialiasMode(p, a) (p)->lpVtbl->GetAntialiasMode(p, a)
#define ID2D1HwndRenderTarget_SetTextAntialiasMode(p, a) (p)->lpVtbl->SetTextAntialiasMode(p, a)
#define ID2D1HwndRenderTarget_GetTextAntialiasMode(p, a) (p)->lpVtbl->GetTextAntialiasMode(p, a)
#define ID2D1HwndRenderTarget_SetTextRenderingParams(p, a) (p)->lpVtbl->SetTextRenderingParams(p, a)
#define ID2D1HwndRenderTarget_GetTextRenderingParams(p, a) (p)->lpVtbl->GetTextRenderingParams(p, a)
#define ID2D1HwndRenderTarget_SetTags(p, a, b) (p)->lpVtbl->SetTags(p, a, b)
#define ID2D1HwndRenderTarget_GetTags(p, a, b) (p)->lpVtbl->GetTags(p, a, b)
#define ID2D1HwndRenderTarget_PushLayer(p, a, b) (p)->lpVtbl->PushLayer(p, a, b)
#define ID2D1HwndRenderTarget_PopLayer(p, a) (p)->lpVtbl->PopLayer(p, a)
#define ID2D1HwndRenderTarget_Flush(p, a, b) (p)->lpVtbl->Flush(p, a, b)
#define ID2D1HwndRenderTarget_SaveDrawingState(p, a) (p)->lpVtbl->SaveDrawingState(p, a)
#define ID2D1HwndRenderTarget_RestoreDrawingState(p, a) (p)->lpVtbl->RestoreDrawingState(p, a)
#define ID2D1HwndRenderTarget_PushAxisAlignedClip(p, a, b) (p)->lpVtbl->PushAxisAlignedClip(p, a, b)
#define ID2D1HwndRenderTarget_PopAxisAlignedClip(p, a) (p)->lpVtbl->PopAxisAlignedClip(p, a)
#define ID2D1HwndRenderTarget_Clear(p, a) (p)->lpVtbl->Clear(p, a)
#define ID2D1HwndRenderTarget_BeginDraw(p, a) (p)->lpVtbl->BeginDraw(p, a)
#define ID2D1HwndRenderTarget_EndDraw(p, a, b) (p)->lpVtbl->EndDraw(p, a, b)
#define ID2D1HwndRenderTarget_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)
#define ID2D1HwndRenderTarget_SetDpi(p, a, b) (p)->lpVtbl->SetDpi(p, a, b)
#define ID2D1HwndRenderTarget_GetDpi(p, a, b) (p)->lpVtbl->GetDpi(p, a, b)
#define ID2D1HwndRenderTarget_GetSize(p, a) (p)->lpVtbl->GetSize(p, a)
#define ID2D1HwndRenderTarget_GetPixelSize(p, a) (p)->lpVtbl->GetPixelSize(p, a)
#define ID2D1HwndRenderTarget_GetMaximumBitmapSize(p, a) (p)->lpVtbl->GetMaximumBitmapSize(p, a)
#define ID2D1HwndRenderTarget_IsSupported(p, a) (p)->lpVtbl->IsSupported(p, a)
#define ID2D1HwndRenderTarget_CheckWindowState(p, a) (p)->lpVtbl->CheckWindowState(p, a)
#define ID2D1HwndRenderTarget_Resize(p, a) (p)->lpVtbl->Resize(p, a)
#define ID2D1HwndRenderTarget_GetHwnd(p, a) (p)->lpVtbl->GetHwnd(p, a)

' ==============================
' ID2D1DCRenderTarget
' ==============================
Type ID2D1DCRenderTargetVtbl As ID2D1DCRenderTargetVtbl_
Type ID2D1DCRenderTarget
    lpVtbl As ID2D1DCRenderTargetVtbl Ptr
End Type
Type ID2D1DCRenderTargetVtbl_     '' Extends ID2D1RenderTargetVtbl_
    QueryInterface As Function(ByVal This As ID2D1DCRenderTarget Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1DCRenderTarget Ptr) As ULong
    Release As Function(ByVal This As ID2D1DCRenderTarget Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal factory As Any Ptr Ptr)
        ' 4.   (ID2D1Resource: GetFactory)
    CreateBitmap As Function(ByVal This As ID2D1DCRenderTarget Ptr, ByVal size As D2D1_SIZE_U, ByVal srcData As Any Ptr, ByVal pitch As ULong, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapFromWicBitmap As Function(ByVal This As ID2D1DCRenderTarget Ptr, ByVal wicBitmapSource As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateSharedBitmap As Function(ByVal This As ID2D1DCRenderTarget Ptr, ByVal riid As GUID Ptr, ByVal Data As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapBrush As Function(ByVal This As ID2D1DCRenderTarget Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal bitmapBrushProperties As D2D1_BITMAP_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal bitmapBrush As ID2D1BitmapBrush Ptr Ptr) As HRESULT
    CreateSolidColorBrush As Function(ByVal This As ID2D1DCRenderTarget Ptr, ByVal Color As D2D1_COLOR_F Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal solidColorBrush As ID2D1SolidColorBrush Ptr Ptr) As HRESULT
    CreateGradientStopCollection As Function(ByVal This As ID2D1DCRenderTarget Ptr, ByVal gradientStops As D2D1_GRADIENT_STOP Ptr, ByVal gradientStopsCount As ULong, ByVal colorInterpolationGamma As D2D1_GAMMA, ByVal extendMode As D2D1_EXTEND_MODE, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr Ptr) As HRESULT
    CreateLinearGradientBrush As Function(ByVal This As ID2D1DCRenderTarget Ptr, ByVal linearGradientBrushProperties As D2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal linearGradientBrush As ID2D1LinearGradientBrush Ptr Ptr) As HRESULT
    CreateRadialGradientBrush As Function(ByVal This As ID2D1DCRenderTarget Ptr, ByVal radialGradientBrushProperties As D2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal radialGradientBrush As ID2D1RadialGradientBrush Ptr Ptr) As HRESULT
    CreateCompatibleRenderTarget As Function(ByVal This As ID2D1DCRenderTarget Ptr, ByVal desiredSize As D2D1_SIZE_F Ptr, ByVal desiredPixelSize As D2D1_SIZE_U Ptr, ByVal desiredFormat As D2D1_PIXEL_FORMAT Ptr, ByVal options As ULong, ByVal bitmapRenderTarget As Any Ptr Ptr) As HRESULT 'ID2D1BitmapRenderTarget
    CreateLayer As Function(ByVal This As ID2D1DCRenderTarget Ptr, ByVal size As D2D1_SIZE_F Ptr, ByVal layer As ID2D1Layer Ptr Ptr) As HRESULT
    CreateMesh As Function(ByVal This As ID2D1DCRenderTarget Ptr, ByVal mesh As ID2D1Mesh Ptr Ptr) As HRESULT
    DrawLine As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal p0 As D2D1_POINT_2F, ByVal p1 As D2D1_POINT_2F, ByVal brush As ID2D1SolidColorBrush Ptr, ByVal strokeWidth As Single = 0, ByVal strokeStyle As ID2D1StrokeStyle Ptr = NULL)
    DrawRectangle As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRectangle As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawRoundedRectangle As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRoundedRectangle As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawEllipse As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillEllipse As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawGeometry As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillGeometry As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal opacityBrush As ID2D1Brush Ptr)
    FillMesh As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal mesh As ID2D1Mesh Ptr, ByVal brush As ID2D1Brush Ptr)
    FillOpacityMask As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal mask As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal content As D2D1_OPACITY_MASK_CONTENT, ByVal destRect As D2D1_RECT_F Ptr, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawBitmap As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal destRect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolationMode As D2D1_BITMAP_INTERPOLATION_MODE, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawText As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal text As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal layoutRect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS = 0, ByVal measuringMode As DWRITE_MEASURING_MODE = 0)
    DrawTextLayout As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal origin As D2D1_POINT_2F, ByVal layout As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS)
    DrawGlyphRun As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal baselineOrigin As D2D1_POINT_2F Ptr, ByVal glyphRun As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE)
    SetTransform As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    GetTransform As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    SetAntialiasMode As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    GetAntialiasMode As Function(ByVal This As ID2D1DCRenderTarget Ptr) As D2D1_ANTIALIAS_MODE
    SetTextAntialiasMode As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal antialiasMode As D2D1_TEXT_ANTIALIAS_MODE)
    GetTextAntialiasMode As Function(ByVal This As ID2D1DCRenderTarget Ptr) As D2D1_TEXT_ANTIALIAS_MODE
    SetTextRenderingParams As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal params As Any Ptr)
    GetTextRenderingParams As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal params As Any Ptr Ptr)
    SetTags As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal tag1 As D2D1_TAG, ByVal tag2 As D2D1_TAG)
    GetTags As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr)
    PushLayer As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal layerParams As D2D1_LAYER_PARAMETERS Ptr, ByVal layer As ID2D1Layer Ptr)
    PopLayer As Sub(ByVal This As ID2D1DCRenderTarget Ptr)
    Flush As Function(ByVal This As ID2D1DCRenderTarget Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    SaveDrawingState As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal stateBlock As Any Ptr)
    RestoreDrawingState As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal stateBlock As Any Ptr)
    PushAxisAlignedClip As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    PopAxisAlignedClip As Sub(ByVal This As ID2D1DCRenderTarget Ptr)
    Clear As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal col As D2D1_COLOR_F Ptr)
    BeginDraw As Sub(ByVal This As ID2D1DCRenderTarget Ptr)
    EndDraw As Function(ByVal This As ID2D1DCRenderTarget Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    GetPixelFormat As Function(ByVal This As ID2D1DCRenderTarget Ptr) As D2D1_PIXEL_FORMAT
    SetDpi As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal dpiX As Single, ByVal dpiY As Single)
    GetDpi As Sub(ByVal This As ID2D1DCRenderTarget Ptr, ByVal dpiX As Single Ptr, ByVal dpiY As Single Ptr)
    GetSize As Function(ByVal This As ID2D1DCRenderTarget Ptr, ByVal size As Any Ptr) As D2D1_SIZE_F
    GetPixelSize As Function(ByVal This As ID2D1DCRenderTarget Ptr, ByVal pixelSize As Any Ptr) As D2D1_SIZE_U
    GetMaximumBitmapSize As Function(ByVal This As ID2D1DCRenderTarget Ptr) As ULong
    IsSupported As Function(ByVal This As ID2D1DCRenderTarget Ptr, ByVal renderTargetProperties As D2D1_RENDER_TARGET_PROPERTIES Ptr) As BOOL

    BindDC As Function(ByVal This As ID2D1DCRenderTarget Ptr, ByVal dc As HDC, ByVal rect As RECT Ptr) As HRESULT
End Type
#define ID2D1DCRenderTarget_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1DCRenderTarget_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1DCRenderTarget_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1DCRenderTarget_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1DCRenderTarget_CreateBitmap(p, a, b, c, d, e) (p)->lpVtbl->CreateBitmap(p, a, b, c, d, e)
#define ID2D1DCRenderTarget_CreateBitmapFromWicBitmap(p, a, b, c) (p)->lpVtbl->CreateBitmapFromWicBitmap(p, a, b, c)
#define ID2D1DCRenderTarget_CreateSharedBitmap(p, a, b, c, d) (p)->lpVtbl->CreateSharedBitmap(p, a, b, c, d)
#define ID2D1DCRenderTarget_CreateBitmapBrush(p, a, b, c, d) (p)->lpVtbl->CreateBitmapBrush(p, a, b, c, d)
#define ID2D1DCRenderTarget_CreateSolidColorBrush(p, a, b, c) (p)->lpVtbl->CreateSolidColorBrush(p, a, b, c)
#define ID2D1DCRenderTarget_CreateGradientStopCollection(p, a, b, c, d, e) (p)->lpVtbl->CreateGradientStopCollection(p, a, b, c, d, e)
#define ID2D1DCRenderTarget_CreateLinearGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateLinearGradientBrush(p, a, b, c, d)
#define ID2D1DCRenderTarget_CreateRadialGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateRadialGradientBrush(p, a, b, c, d)
#define ID2D1DCRenderTarget_CreateCompatibleRenderTarget(p, a, b, c, d, e) (p)->lpVtbl->CreateCompatibleRenderTarget(p, a, b, c, d, e)
#define ID2D1DCRenderTarget_CreateLayer(p, a, b) (p)->lpVtbl->CreateLayer(p, a, b)
#define ID2D1DCRenderTarget_CreateMesh(p, a) (p)->lpVtbl->CreateMesh(p, a)
#define ID2D1DCRenderTarget_DrawLine(p, a, b, c, d, e) (p)->lpVtbl->DrawLine(p, a, b, c, d, e)
#define ID2D1DCRenderTarget_DrawRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRectangle(p, a, b, c, d)
#define ID2D1DCRenderTarget_FillRectangle(p, a, b) (p)->lpVtbl->FillRectangle(p, a, b)
#define ID2D1DCRenderTarget_DrawRoundedRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRoundedRectangle(p, a, b, c, d)
#define ID2D1DCRenderTarget_FillRoundedRectangle(p, a, b) (p)->lpVtbl->FillRoundedRectangle(p, a, b)
#define ID2D1DCRenderTarget_DrawEllipse(p, a, b, c, d) (p)->lpVtbl->DrawEllipse(p, a, b, c, d)
#define ID2D1DCRenderTarget_FillEllipse(p, a, b) (p)->lpVtbl->FillEllipse(p, a, b)
#define ID2D1DCRenderTarget_DrawGeometry(p, a, b, c, d) (p)->lpVtbl->DrawGeometry(p, a, b, c, d)
#define ID2D1DCRenderTarget_FillGeometry(p, a, b, c) (p)->lpVtbl->FillGeometry(p, a, b, c)
#define ID2D1DCRenderTarget_FillMesh(p, a, b) (p)->lpVtbl->FillMesh(p, a, b)
#define ID2D1DCRenderTarget_FillOpacityMask(p, a, b, c, d, e) (p)->lpVtbl->FillOpacityMask(p, a, b, c, d, e)
#define ID2D1DCRenderTarget_DrawBitmap(p, a, b, c, d, e) (p)->lpVtbl->DrawBitmap(p, a, b, c, d, e)
#define ID2D1DCRenderTarget_DrawText(p, a, b, c, d, e, f, g) (p)->lpVtbl->DrawText(p, a, b, c, d, e, f, g)
#define ID2D1DCRenderTarget_DrawTextLayout(p, a, b, c, d) (p)->lpVtbl->DrawTextLayout(p, a, b, c, d)
#define ID2D1DCRenderTarget_DrawGlyphRun(p, a, b, c, d) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d)
#define ID2D1DCRenderTarget_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1DCRenderTarget_GetTransform(p, a) (p)->lpVtbl->GetTransform(p, a)
#define ID2D1DCRenderTarget_SetAntialiasMode(p, a) (p)->lpVtbl->SetAntialiasMode(p, a)
#define ID2D1DCRenderTarget_GetAntialiasMode(p, a) (p)->lpVtbl->GetAntialiasMode(p, a)
#define ID2D1DCRenderTarget_SetTextAntialiasMode(p, a) (p)->lpVtbl->SetTextAntialiasMode(p, a)
#define ID2D1DCRenderTarget_GetTextAntialiasMode(p, a) (p)->lpVtbl->GetTextAntialiasMode(p, a)
#define ID2D1DCRenderTarget_SetTextRenderingParams(p, a) (p)->lpVtbl->SetTextRenderingParams(p, a)
#define ID2D1DCRenderTarget_GetTextRenderingParams(p, a) (p)->lpVtbl->GetTextRenderingParams(p, a)
#define ID2D1DCRenderTarget_SetTags(p, a, b) (p)->lpVtbl->SetTags(p, a, b)
#define ID2D1DCRenderTarget_GetTags(p, a, b) (p)->lpVtbl->GetTags(p, a, b)
#define ID2D1DCRenderTarget_PushLayer(p, a, b) (p)->lpVtbl->PushLayer(p, a, b)
#define ID2D1DCRenderTarget_PopLayer(p, a) (p)->lpVtbl->PopLayer(p, a)
#define ID2D1DCRenderTarget_Flush(p, a, b) (p)->lpVtbl->Flush(p, a, b)
#define ID2D1DCRenderTarget_SaveDrawingState(p, a) (p)->lpVtbl->SaveDrawingState(p, a)
#define ID2D1DCRenderTarget_RestoreDrawingState(p, a) (p)->lpVtbl->RestoreDrawingState(p, a)
#define ID2D1DCRenderTarget_PushAxisAlignedClip(p, a, b) (p)->lpVtbl->PushAxisAlignedClip(p, a, b)
#define ID2D1DCRenderTarget_PopAxisAlignedClip(p, a) (p)->lpVtbl->PopAxisAlignedClip(p, a)
#define ID2D1DCRenderTarget_Clear(p, a) (p)->lpVtbl->Clear(p, a)
#define ID2D1DCRenderTarget_BeginDraw(p, a) (p)->lpVtbl->BeginDraw(p, a)
#define ID2D1DCRenderTarget_EndDraw(p, a, b) (p)->lpVtbl->EndDraw(p, a, b)
#define ID2D1DCRenderTarget_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)
#define ID2D1DCRenderTarget_SetDpi(p, a, b) (p)->lpVtbl->SetDpi(p, a, b)
#define ID2D1DCRenderTarget_GetDpi(p, a, b) (p)->lpVtbl->GetDpi(p, a, b)
#define ID2D1DCRenderTarget_GetSize(p, a) (p)->lpVtbl->GetSize(p, a)
#define ID2D1DCRenderTarget_GetPixelSize(p, a) (p)->lpVtbl->GetPixelSize(p, a)
#define ID2D1DCRenderTarget_GetMaximumBitmapSize(p, a) (p)->lpVtbl->GetMaximumBitmapSize(p, a)
#define ID2D1DCRenderTarget_IsSupported(p, a) (p)->lpVtbl->IsSupported(p, a)
#define ID2D1DCRenderTarget_BindDC(p, a, b) (p)->lpVtbl->BindDC(p, a, b)


' ==============================
' ID2D1GdiInteropRenderTarget
' ==============================
Type ID2D1GdiInteropRenderTargetVtbl As ID2D1GdiInteropRenderTargetVtbl_
Type ID2D1GdiInteropRenderTarget
    lpVtbl As ID2D1GdiInteropRenderTargetVtbl Ptr
End Type
Type ID2D1GdiInteropRenderTargetVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As ID2D1GdiInteropRenderTarget Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1GdiInteropRenderTarget Ptr) As ULong
    Release As Function(ByVal This As ID2D1GdiInteropRenderTarget Ptr) As ULong

        ' 2. AddRef
        ' 4.
    GetDC As Function(ByVal This As ID2D1GdiInteropRenderTarget Ptr, ByVal mode As D2D1_DC_INITIALIZE_MODE, ByRef hdc As HDC) As HRESULT
    ReleaseDC As Function(ByVal This As ID2D1GdiInteropRenderTarget Ptr, ByVal updateRect As RECT Ptr) As HRESULT
End Type
#define ID2D1GdiInteropRenderTarget_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1GdiInteropRenderTarget_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1GdiInteropRenderTarget_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1GdiInteropRenderTarget_GetDC(p, a, b) (p)->lpVtbl->GetDC(p, a, b)
#define ID2D1GdiInteropRenderTarget_ReleaseDC(p, a) (p)->lpVtbl->ReleaseDC(p, a)

' ============================================================================
' ID2D1BitmapRenderTarget
' ============================================================================
Type ID2D1BitmapRenderTargetVtbl As ID2D1BitmapRenderTargetVtbl_
Type ID2D1BitmapRenderTarget
    lpVtbl As ID2D1BitmapRenderTargetVtbl Ptr
End Type
Type ID2D1BitmapRenderTargetVtbl_     '' Extends ID2D1RenderTargetVtbl_
    QueryInterface As Function(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1BitmapRenderTarget Ptr) As ULong
    Release As Function(ByVal This As ID2D1BitmapRenderTarget Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal factory As Any Ptr Ptr)
        ' 4.   (ID2D1Resource: GetFactory)
    CreateBitmap As Function(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal size As D2D1_SIZE_U, ByVal srcData As Any Ptr, ByVal pitch As ULong, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapFromWicBitmap As Function(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal wicBitmapSource As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateSharedBitmap As Function(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal riid As GUID Ptr, ByVal data As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapBrush As Function(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal bitmapBrushProperties As D2D1_BITMAP_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal bitmapBrush As ID2D1BitmapBrush Ptr Ptr) As HRESULT
    CreateSolidColorBrush As Function(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal color As D2D1_COLOR_F Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal solidColorBrush As ID2D1SolidColorBrush Ptr Ptr) As HRESULT
    CreateGradientStopCollection As Function(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal gradientStops As D2D1_GRADIENT_STOP Ptr, ByVal gradientStopsCount As ULong, ByVal colorInterpolationGamma As D2D1_GAMMA, ByVal extendMode As D2D1_EXTEND_MODE, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr Ptr) As HRESULT
    CreateLinearGradientBrush As Function(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal linearGradientBrushProperties As D2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal linearGradientBrush As ID2D1LinearGradientBrush Ptr Ptr) As HRESULT
    CreateRadialGradientBrush As Function(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal radialGradientBrushProperties As D2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal radialGradientBrush As ID2D1RadialGradientBrush Ptr Ptr) As HRESULT
    CreateCompatibleRenderTarget As Function(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal desiredSize As D2D1_SIZE_F Ptr, ByVal desiredPixelSize As D2D1_SIZE_U Ptr, ByVal desiredFormat As D2D1_PIXEL_FORMAT Ptr, ByVal options As ULong, ByVal bitmapRenderTarget As Any Ptr Ptr) As HRESULT 'ID2D1BitmapRenderTarget
    CreateLayer As Function(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal size As D2D1_SIZE_F Ptr, ByVal layer As ID2D1Layer Ptr Ptr) As HRESULT
    CreateMesh As Function(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal mesh As ID2D1Mesh Ptr Ptr) As HRESULT
    DrawLine As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal p0 As D2D1_POINT_2F, ByVal p1 As D2D1_POINT_2F, ByVal brush As ID2D1SolidColorBrush Ptr, ByVal strokeWidth As Single = 0, ByVal strokeStyle As ID2D1StrokeStyle Ptr = NULL)
    DrawRectangle As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRectangle As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawRoundedRectangle As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRoundedRectangle As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawEllipse As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillEllipse As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawGeometry As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillGeometry As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal opacityBrush As ID2D1Brush Ptr)
    FillMesh As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal mesh As ID2D1Mesh Ptr, ByVal brush As ID2D1Brush Ptr)
    FillOpacityMask As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal mask As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal content As D2D1_OPACITY_MASK_CONTENT, ByVal destRect As D2D1_RECT_F Ptr, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawBitmap As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal destRect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolationMode As D2D1_BITMAP_INTERPOLATION_MODE, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawText As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal text As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal layoutRect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS = 0, ByVal measuringMode As DWRITE_MEASURING_MODE = 0)
    DrawTextLayout As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal origin As D2D1_POINT_2F, ByVal layout As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS)
    DrawGlyphRun As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal baselineOrigin As D2D1_POINT_2F Ptr, ByVal glyphRun As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE)
    SetTransform As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    GetTransform As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    SetAntialiasMode As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    GetAntialiasMode As Function(ByVal This As ID2D1BitmapRenderTarget Ptr) As D2D1_ANTIALIAS_MODE
    SetTextAntialiasMode As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal antialiasMode As D2D1_TEXT_ANTIALIAS_MODE)
    GetTextAntialiasMode As Function(ByVal This As ID2D1BitmapRenderTarget Ptr) As D2D1_TEXT_ANTIALIAS_MODE
    SetTextRenderingParams As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal params As Any Ptr)
    GetTextRenderingParams As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal params As Any Ptr Ptr)
    SetTags As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal tag1 As D2D1_TAG, ByVal tag2 As D2D1_TAG)
    GetTags As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr)
    PushLayer As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal layerParams As D2D1_LAYER_PARAMETERS Ptr, ByVal layer As ID2D1Layer Ptr)
    PopLayer As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr)
    Flush As Function(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    SaveDrawingState As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal stateBlock As Any Ptr)
    RestoreDrawingState As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal stateBlock As Any Ptr)
    PushAxisAlignedClip As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    PopAxisAlignedClip As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr)
    Clear As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal col As D2D1_COLOR_F Ptr)
    BeginDraw As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr)
    EndDraw As Function(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    GetPixelFormat As Function(ByVal This As ID2D1BitmapRenderTarget Ptr) As D2D1_PIXEL_FORMAT
    SetDpi As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal dpiX As Single, ByVal dpiY As Single)
    GetDpi As Sub(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal dpiX As Single Ptr, ByVal dpiY As Single Ptr)
    GetSize As Function(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal size As Any Ptr) As D2D1_SIZE_F
    GetPixelSize As Function(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal pixelSize As Any Ptr) As D2D1_SIZE_U
    GetMaximumBitmapSize As Function(ByVal This As ID2D1BitmapRenderTarget Ptr) As ULong
    IsSupported As Function(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal renderTargetProperties As D2D1_RENDER_TARGET_PROPERTIES Ptr) As BOOL

        ' Slots 1-57: Von ID2D1RenderTarget geerbt
        ' 58. GetBitmap - OUT-Parameter muss Pointer-to-Pointer sein!
    GetBitmap As Function(ByVal This As ID2D1BitmapRenderTarget Ptr, ByVal ppBitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
        ' Alternativ:
        ' ByVal ppBitmap As ID2D1Bitmap Ptr Ptr
End Type
#define ID2D1BitmapRenderTarget_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1BitmapRenderTarget_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1BitmapRenderTarget_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1BitmapRenderTarget_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1BitmapRenderTarget_CreateBitmap(p, a, b, c, d, e) (p)->lpVtbl->CreateBitmap(p, a, b, c, d, e)
#define ID2D1BitmapRenderTarget_CreateBitmapFromWicBitmap(p, a, b, c) (p)->lpVtbl->CreateBitmapFromWicBitmap(p, a, b, c)
#define ID2D1BitmapRenderTarget_CreateSharedBitmap(p, a, b, c, d) (p)->lpVtbl->CreateSharedBitmap(p, a, b, c, d)
#define ID2D1BitmapRenderTarget_CreateBitmapBrush(p, a, b, c, d) (p)->lpVtbl->CreateBitmapBrush(p, a, b, c, d)
#define ID2D1BitmapRenderTarget_CreateSolidColorBrush(p, a, b, c) (p)->lpVtbl->CreateSolidColorBrush(p, a, b, c)
#define ID2D1BitmapRenderTarget_CreateGradientStopCollection(p, a, b, c, d, e) (p)->lpVtbl->CreateGradientStopCollection(p, a, b, c, d, e)
#define ID2D1BitmapRenderTarget_CreateLinearGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateLinearGradientBrush(p, a, b, c, d)
#define ID2D1BitmapRenderTarget_CreateRadialGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateRadialGradientBrush(p, a, b, c, d)
#define ID2D1BitmapRenderTarget_CreateCompatibleRenderTarget(p, a, b, c, d, e) (p)->lpVtbl->CreateCompatibleRenderTarget(p, a, b, c, d, e)
#define ID2D1BitmapRenderTarget_CreateLayer(p, a, b) (p)->lpVtbl->CreateLayer(p, a, b)
#define ID2D1BitmapRenderTarget_CreateMesh(p, a) (p)->lpVtbl->CreateMesh(p, a)
#define ID2D1BitmapRenderTarget_DrawLine(p, a, b, c, d, e) (p)->lpVtbl->DrawLine(p, a, b, c, d, e)
#define ID2D1BitmapRenderTarget_DrawRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRectangle(p, a, b, c, d)
#define ID2D1BitmapRenderTarget_FillRectangle(p, a, b) (p)->lpVtbl->FillRectangle(p, a, b)
#define ID2D1BitmapRenderTarget_DrawRoundedRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRoundedRectangle(p, a, b, c, d)
#define ID2D1BitmapRenderTarget_FillRoundedRectangle(p, a, b) (p)->lpVtbl->FillRoundedRectangle(p, a, b)
#define ID2D1BitmapRenderTarget_DrawEllipse(p, a, b, c, d) (p)->lpVtbl->DrawEllipse(p, a, b, c, d)
#define ID2D1BitmapRenderTarget_FillEllipse(p, a, b) (p)->lpVtbl->FillEllipse(p, a, b)
#define ID2D1BitmapRenderTarget_DrawGeometry(p, a, b, c, d) (p)->lpVtbl->DrawGeometry(p, a, b, c, d)
#define ID2D1BitmapRenderTarget_FillGeometry(p, a, b, c) (p)->lpVtbl->FillGeometry(p, a, b, c)
#define ID2D1BitmapRenderTarget_FillMesh(p, a, b) (p)->lpVtbl->FillMesh(p, a, b)
#define ID2D1BitmapRenderTarget_FillOpacityMask(p, a, b, c, d, e) (p)->lpVtbl->FillOpacityMask(p, a, b, c, d, e)
#define ID2D1BitmapRenderTarget_DrawBitmap(p, a, b, c, d, e) (p)->lpVtbl->DrawBitmap(p, a, b, c, d, e)
#define ID2D1BitmapRenderTarget_DrawText(p, a, b, c, d, e, f, g) (p)->lpVtbl->DrawText(p, a, b, c, d, e, f, g)
#define ID2D1BitmapRenderTarget_DrawTextLayout(p, a, b, c, d) (p)->lpVtbl->DrawTextLayout(p, a, b, c, d)
#define ID2D1BitmapRenderTarget_DrawGlyphRun(p, a, b, c, d) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d)
#define ID2D1BitmapRenderTarget_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1BitmapRenderTarget_GetTransform(p, a) (p)->lpVtbl->GetTransform(p, a)
#define ID2D1BitmapRenderTarget_SetAntialiasMode(p, a) (p)->lpVtbl->SetAntialiasMode(p, a)
#define ID2D1BitmapRenderTarget_GetAntialiasMode(p, a) (p)->lpVtbl->GetAntialiasMode(p, a)
#define ID2D1BitmapRenderTarget_SetTextAntialiasMode(p, a) (p)->lpVtbl->SetTextAntialiasMode(p, a)
#define ID2D1BitmapRenderTarget_GetTextAntialiasMode(p, a) (p)->lpVtbl->GetTextAntialiasMode(p, a)
#define ID2D1BitmapRenderTarget_SetTextRenderingParams(p, a) (p)->lpVtbl->SetTextRenderingParams(p, a)
#define ID2D1BitmapRenderTarget_GetTextRenderingParams(p, a) (p)->lpVtbl->GetTextRenderingParams(p, a)
#define ID2D1BitmapRenderTarget_SetTags(p, a, b) (p)->lpVtbl->SetTags(p, a, b)
#define ID2D1BitmapRenderTarget_GetTags(p, a, b) (p)->lpVtbl->GetTags(p, a, b)
#define ID2D1BitmapRenderTarget_PushLayer(p, a, b) (p)->lpVtbl->PushLayer(p, a, b)
#define ID2D1BitmapRenderTarget_PopLayer(p, a) (p)->lpVtbl->PopLayer(p, a)
#define ID2D1BitmapRenderTarget_Flush(p, a, b) (p)->lpVtbl->Flush(p, a, b)
#define ID2D1BitmapRenderTarget_SaveDrawingState(p, a) (p)->lpVtbl->SaveDrawingState(p, a)
#define ID2D1BitmapRenderTarget_RestoreDrawingState(p, a) (p)->lpVtbl->RestoreDrawingState(p, a)
#define ID2D1BitmapRenderTarget_PushAxisAlignedClip(p, a, b) (p)->lpVtbl->PushAxisAlignedClip(p, a, b)
#define ID2D1BitmapRenderTarget_PopAxisAlignedClip(p, a) (p)->lpVtbl->PopAxisAlignedClip(p, a)
#define ID2D1BitmapRenderTarget_Clear(p, a) (p)->lpVtbl->Clear(p, a)
#define ID2D1BitmapRenderTarget_BeginDraw(p, a) (p)->lpVtbl->BeginDraw(p, a)
#define ID2D1BitmapRenderTarget_EndDraw(p, a, b) (p)->lpVtbl->EndDraw(p, a, b)
#define ID2D1BitmapRenderTarget_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)
#define ID2D1BitmapRenderTarget_SetDpi(p, a, b) (p)->lpVtbl->SetDpi(p, a, b)
#define ID2D1BitmapRenderTarget_GetDpi(p, a, b) (p)->lpVtbl->GetDpi(p, a, b)
#define ID2D1BitmapRenderTarget_GetSize(p, a) (p)->lpVtbl->GetSize(p, a)
#define ID2D1BitmapRenderTarget_GetPixelSize(p, a) (p)->lpVtbl->GetPixelSize(p, a)
#define ID2D1BitmapRenderTarget_GetMaximumBitmapSize(p, a) (p)->lpVtbl->GetMaximumBitmapSize(p, a)
#define ID2D1BitmapRenderTarget_IsSupported(p, a) (p)->lpVtbl->IsSupported(p, a)
#define ID2D1BitmapRenderTarget_GetBitmap(p, a) (p)->lpVtbl->GetBitmap(p, a)

' ==============================
' ID2D1Factory
' ==============================
Type ID2D1FactoryVtbl As ID2D1FactoryVtbl_
Type ID2D1Factory
    lpVtbl As ID2D1FactoryVtbl Ptr
End Type
Type ID2D1FactoryVtbl_     '' Extends IUnknownBaseVtbl_
    QueryInterface As Function(ByVal This As ID2D1Factory Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Factory Ptr) As ULong
    Release As Function(ByVal This As ID2D1Factory Ptr) As ULong

        ' 2. AddRef
        ' 4.
    ReloadSystemMetrics As Function(ByVal This As ID2D1Factory Ptr) As HRESULT
    GetDesktopDpi As Sub(ByVal This As ID2D1Factory Ptr, ByVal dpiX As Single Ptr, ByVal dpiY As Single Ptr)
    CreateRectangleGeometry As Function(ByVal This As ID2D1Factory Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal geometry As ID2D1RectangleGeometry Ptr Ptr) As HRESULT
    CreateRoundedRectangleGeometry As Function(ByVal This As ID2D1Factory Ptr, ByVal rect As D2D1_ROUNDED_RECT Ptr, ByVal geometry As ID2D1RoundedRectangleGeometry Ptr Ptr) As HRESULT
    CreateEllipseGeometry As Function(ByVal This As ID2D1Factory Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal ID2D1EllipseGeometry As Any Ptr Ptr) As HRESULT
    CreateGeometryGroup As Function(ByVal This As ID2D1Factory Ptr, ByVal fill_mode As D2D1_FILL_MODE, ByVal geometries As ID2D1Geometry Ptr Ptr, ByVal geometryCount As ULong, ByVal group As ID2D1GeometryGroup Ptr Ptr) As HRESULT
    CreateTransformedGeometry As Function(ByVal This As ID2D1Factory Ptr, ByVal src_geometry As ID2D1Geometry Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr, ByVal transformedGeometry As ID2D1TransformedGeometry Ptr Ptr) As HRESULT
    CreatePathGeometry As Function(ByVal This As ID2D1Factory Ptr, ByVal geometry As ID2D1PathGeometry Ptr Ptr) As HRESULT
    CreateStrokeStyle As Function(ByVal This As ID2D1Factory Ptr, ByVal styleProps As D2D1_STROKE_STYLE_PROPERTIES Ptr, ByVal dashes As Single Ptr, ByVal dashCount As ULong, ByVal strokeStyle As ID2D1StrokeStyle Ptr Ptr) As HRESULT
    CreateDrawingStateBlock As Function(ByVal This As ID2D1Factory Ptr, ByVal stateDesc As D2D1_DRAWING_STATE_DESCRIPTION Ptr, ByVal text_renderingParams As Any Ptr, ByVal stateBlock As IUnknownBase Ptr Ptr) As HRESULT ' ID2D1DrawingStateBlock
    CreateWicBitmapRenderTarget As Function(ByVal This As ID2D1Factory Ptr, ByVal target As Any Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1RenderTarget Ptr Ptr) As HRESULT
    CreateHwndRenderTarget As Function(ByVal This As ID2D1Factory Ptr, ByVal desc As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal targetProps As D2D1_HWND_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1HwndRenderTarget Ptr Ptr) As HRESULT
    CreateDxgiSurfaceRenderTarget As Function(ByVal This As ID2D1Factory Ptr, ByVal surface As Any Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1RenderTarget Ptr Ptr) As HRESULT
    CreateDCRenderTarget As Function(ByVal This As ID2D1Factory Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1DCRenderTarget Ptr Ptr) As HRESULT
End Type
#define ID2D1Factory_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Factory_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Factory_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Factory_ReloadSystemMetrics(p, a) (p)->lpVtbl->ReloadSystemMetrics(p, a)
#define ID2D1Factory_GetDesktopDpi(p, a, b) (p)->lpVtbl->GetDesktopDpi(p, a, b)
#define ID2D1Factory_CreateRectangleGeometry(p, a, b) (p)->lpVtbl->CreateRectangleGeometry(p, a, b)
#define ID2D1Factory_CreateRoundedRectangleGeometry(p, a, b) (p)->lpVtbl->CreateRoundedRectangleGeometry(p, a, b)
#define ID2D1Factory_CreateEllipseGeometry(p, a, b) (p)->lpVtbl->CreateEllipseGeometry(p, a, b)
#define ID2D1Factory_CreateGeometryGroup(p, a, b, c, d) (p)->lpVtbl->CreateGeometryGroup(p, a, b, c, d)
#define ID2D1Factory_CreateTransformedGeometry(p, a, b, c) (p)->lpVtbl->CreateTransformedGeometry(p, a, b, c)
#define ID2D1Factory_CreatePathGeometry(p, a) (p)->lpVtbl->CreatePathGeometry(p, a)
#define ID2D1Factory_CreateStrokeStyle(p, a, b, c, d) (p)->lpVtbl->CreateStrokeStyle(p, a, b, c, d)
#define ID2D1Factory_CreateDrawingStateBlock(p, a, b, c) (p)->lpVtbl->CreateDrawingStateBlock(p, a, b, c)
#define ID2D1Factory_CreateWicBitmapRenderTarget(p, a, b, c) (p)->lpVtbl->CreateWicBitmapRenderTarget(p, a, b, c)
#define ID2D1Factory_CreateHwndRenderTarget(p, a, b, c) (p)->lpVtbl->CreateHwndRenderTarget(p, a, b, c)
#define ID2D1Factory_CreateDxgiSurfaceRenderTarget(p, a, b, c) (p)->lpVtbl->CreateDxgiSurfaceRenderTarget(p, a, b, c)
#define ID2D1Factory_CreateDCRenderTarget(p, a, b) (p)->lpVtbl->CreateDCRenderTarget(p, a, b)

Extern "Windows"
Declare Function D2D1InvertMatrix Lib "d2d1" (ByVal matrix As D2D1_MATRIX_3X2_F Ptr) As Long
Declare Function D2D1IsMatrixInvertible Lib "d2d1" (ByVal matrix As D2D1_MATRIX_3X2_F Ptr) As Long
Declare Sub D2D1MakeRotateMatrix Lib "d2d1" (ByVal angle As Single, ByVal center As D2D1_POINT_2F, ByVal matrix As D2D1_MATRIX_3X2_F Ptr)
Declare Sub D2D1MakeSkewMatrix Lib "d2d1" (ByVal angle_x As Single, ByVal angle_y As Single, ByVal center As D2D1_POINT_2F, ByVal matrix As D2D1_MATRIX_3X2_F Ptr)
End Extern
