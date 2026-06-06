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
	Declare Function D2D1CreateFactory stdcall Lib "d2d1" Alias "D2D1CreateFactory" ( _
                        ByVal factoryType As ULong, _
                        ByVal riid As GUID Ptr, _
                        ByVal options As Any Ptr, _
                        ByVal factory As Any Ptr Ptr) As HRESULT
End Extern


Type IUnknownBase Extends Object
    Declare Abstract Function QueryInterface Stdcall (ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    Declare Abstract Function AddRef Stdcall () As ULong
    Declare Abstract Function Release Stdcall () As ULong
End Type


' ---------------------------------------------------------------------------
' Basis-Typen und Aliase (vor den Enums einzufügen)
' ---------------------------------------------------------------------------
Type D2D1_TAG As UINT64

#define D2D1_DEFAULT_FLATTENING_TOLERANCE (0.25f)

' ---------------------------------------------------------------------------
' Enumerationen
' ---------------------------------------------------------------------------
Enum D2D1_DEBUG_LEVEL
    D2D1_DEBUG_LEVEL_NONE = 0
    D2D1_DEBUG_LEVEL_ERROR = 1
    D2D1_DEBUG_LEVEL_WARNING = 2
    D2D1_DEBUG_LEVEL_INFORMATION = 3
    D2D1_DEBUG_LEVEL_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_FACTORY_TYPE
    D2D1_FACTORY_TYPE_SINGLE_THREADED = 0
    D2D1_FACTORY_TYPE_MULTI_THREADED = 1
    D2D1_FACTORY_TYPE_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_FILL_MODE
    D2D1_FILL_MODE_ALTERNATE = 0
    D2D1_FILL_MODE_WINDING = 1
    D2D1_FILL_MODE_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_PATH_SEGMENT
    D2D1_PATH_SEGMENT_NONE = 0
    D2D1_PATH_SEGMENT_FORCE_UNSTROKED = 1
    D2D1_PATH_SEGMENT_FORCE_ROUND_LINE_JOIN = 2
    D2D1_PATH_SEGMENT_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_FIGURE_BEGIN
    D2D1_FIGURE_BEGIN_FILLED = 0
    D2D1_FIGURE_BEGIN_HOLLOW = 1
    D2D1_FIGURE_BEGIN_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_FIGURE_END
    D2D1_FIGURE_END_OPEN = 0
    D2D1_FIGURE_END_CLOSED = 1
    D2D1_FIGURE_END_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_CAP_STYLE
    D2D1_CAP_STYLE_FLAT = 0
    D2D1_CAP_STYLE_SQUARE = 1
    D2D1_CAP_STYLE_ROUND = 2
    D2D1_CAP_STYLE_TRIANGLE = 3
    D2D1_CAP_STYLE_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_LINE_JOIN
    D2D1_LINE_JOIN_MITER = 0
    D2D1_LINE_JOIN_BEVEL = 1
    D2D1_LINE_JOIN_ROUND = 2
    D2D1_LINE_JOIN_MITER_OR_BEVEL = 3
    D2D1_LINE_JOIN_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_DASH_STYLE
    D2D1_DASH_STYLE_SOLID = 0
    D2D1_DASH_STYLE_DASH = 1
    D2D1_DASH_STYLE_DOT = 2
    D2D1_DASH_STYLE_DASH_DOT = 3
    D2D1_DASH_STYLE_DASH_DOT_DOT = 4
    D2D1_DASH_STYLE_CUSTOM = 5
    D2D1_DASH_STYLE_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_GEOMETRY_RELATION
    D2D1_GEOMETRY_RELATION_UNKNOWN = 0
    D2D1_GEOMETRY_RELATION_DISJOINT = 1
    D2D1_GEOMETRY_RELATION_IS_CONTAINED = 2
    D2D1_GEOMETRY_RELATION_CONTAINS = 3
    D2D1_GEOMETRY_RELATION_OVERLAP = 4
    D2D1_GEOMETRY_RELATION_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_GEOMETRY_SIMPLIFICATION_OPTION
    D2D1_GEOMETRY_SIMPLIFICATION_OPTION_CUBICS_AND_LINES = 0
    D2D1_GEOMETRY_SIMPLIFICATION_OPTION_LINES = 1
    D2D1_GEOMETRY_SIMPLIFICATION_OPTION_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_COMBINE_MODE
    D2D1_COMBINE_MODE_UNION = 0
    D2D1_COMBINE_MODE_INTERSECT = 1
    D2D1_COMBINE_MODE_XOR = 2
    D2D1_COMBINE_MODE_EXCLUDE = 3
    D2D1_COMBINE_MODE_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_SWEEP_DIRECTION
    D2D1_SWEEP_DIRECTION_COUNTER_CLOCKWISE = 0,
    D2D1_SWEEP_DIRECTION_CLOCKWISE = 1
    D2D1_SWEEP_DIRECTION_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_ARC_SIZE
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

Enum D2D1_BITMAP_INTERPOLATION_MODE
    D2D1_BITMAP_INTERPOLATION_MODE_NEAREST_NEIGHBOR = 0,
    D2D1_BITMAP_INTERPOLATION_MODE_LINEAR = 1
    D2D1_BITMAP_INTERPOLATION_MODE_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_GAMMA
    D2D1_GAMMA_2_2 = 0
    D2D1_GAMMA_1_0 = 1
    D2D1_GAMMA_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS
    D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS_NONE = &h00000000
    D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS_GDI_COMPATIBLE = &h00000001
    D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_OPACITY_MASK_CONTENT
    D2D1_OPACITY_MASK_CONTENT_GRAPHICS            = 0
    D2D1_OPACITY_MASK_CONTENT_TEXT_NATURAL        = 1
    D2D1_OPACITY_MASK_CONTENT_TEXT_GDI_COMPATIBLE = 2
    D2D1_OPACITY_MASK_CONTENT_FORCE_DWORD         = &hFFFFFFFF
End Enum

Enum D2D1_DRAW_TEXT_OPTIONS
    D2D1_DRAW_TEXT_OPTIONS_NONE = &h00000000
    D2D1_DRAW_TEXT_OPTIONS_NO_SNAP = &h00000001
    D2D1_DRAW_TEXT_OPTIONS_CLIP = &h00000002
    D2D1_DRAW_TEXT_OPTIONS_ENABLE_COLOR_FONT = &h00000004
    D2D1_DRAW_TEXT_OPTIONS_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_LAYER_OPTIONS
    D2D1_LAYER_OPTIONS_NONE = &h00000000
    D2D1_LAYER_OPTIONS_INITIALIZE_FOR_CLEARTYPE = &h00000001
    D2D1_LAYER_OPTIONS_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_RENDER_TARGET_TYPE
    D2D1_RENDER_TARGET_TYPE_DEFAULT = 0,
    D2D1_RENDER_TARGET_TYPE_SOFTWARE = 1,
    D2D1_RENDER_TARGET_TYPE_HARDWARE = 2
    D2D1_RENDER_TARGET_TYPE_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_RENDER_TARGET_USAGE
    D2D1_RENDER_TARGET_USAGE_NONE = 0,
    D2D1_RENDER_TARGET_USAGE_FORCE_BITMAP_REMOTING = 1,
    D2D1_RENDER_TARGET_USAGE_GDI_COMPATIBLE = 2
    D2D1_RENDER_TARGET_USAGE_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_FEATURE_LEVEL
    D2D1_FEATURE_LEVEL_DEFAULT = 0,
    D2D1_FEATURE_LEVEL_9 = 37120,
    D2D1_FEATURE_LEVEL_10 = 40960
    D2D1_FEATURE_LEVEL_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_WINDOW_STATE
    D2D1_WINDOW_STATE_NONE = &h00000000
    D2D1_WINDOW_STATE_OCCLUDED = &h00000001
    D2D1_WINDOW_STATE_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_DC_INITIALIZE_MODE
    D2D1_DC_INITIALIZE_MODE_COPY = 0
    D2D1_DC_INITIALIZE_MODE_CLEAR = 1
    D2D1_DC_INITIALIZE_MODE_FORCE_DWORD = &hFFFFFFFF
End Enum

Enum D2D1_PRESENT_OPTIONS
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

type D2D1_STROKE_STYLE_PROPERTIES
	startCap as ULong
	endCap as ULong
	dashCap as ULong
	lineJoin as ULong
	miterLimit as Single
	dashStyle as ULong
	dashOffset as Single
end type

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

Dim Shared As GUID ID2D1DrawingStateBlock = Type<GUID>(&h28506E39, &hEBF6, &h46A1, { &hBB, &h47, &hFD, &h85, &h56, &h5A, &hB9, &h57 })
Dim Shared As GUID ID2D1Image = Type<GUID>(&h65019F75, &h8DA2, &h497C, { &hB3, &h2C, &hDF, &hA3, &h4E, &h48, &hED, &hE6 })
Dim Shared As GUID ID2D1Bitmap = Type<GUID>(&hA2296057, &hEA42, &h4099, { &h98, &h3B, &h53, &h9F, &hB6, &h50, &h54, &h26 })

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

Dim Shared As GUID ID2D1Factory = Type<GUID>(&h06152247, &h6F50, &h465A, { &h92, &h45, &h11, &h8B, &hFD, &h3B, &h60, &h07 })


' ---------------------------------------------------------------------------
' Converted COM interfaces
' ---------------------------------------------------------------------------
' ==============================
' ID2D1Resource
' ==============================
Type ID2D1Resource Extends IUnknownBase
    Declare Abstract Sub GetFactory stdcall (ByVal factory As Any Ptr Ptr) 'ID2D1Factory
End Type

' ==============================
' ID2D1SimplifiedGeometrySink
' ==============================
Type ID2D1SimplifiedGeometrySink Extends IUnknownBase
    ' 1-3: IUnknown
    ' 4.
    Declare Abstract Sub SetFillMode Stdcall (ByVal fillMode As D2D1_FILL_MODE)
    ' 5.
    Declare Abstract Sub SetSegmentFlags Stdcall (ByVal vertexFlags As D2D1_PATH_SEGMENT)
    ' 6.
    Declare Abstract Sub BeginFigure Stdcall (ByVal startPoint As D2D1_POINT_2F, _
                                             ByVal figureBegin As D2D1_FIGURE_BEGIN)
    ' 7.
    Declare Abstract Sub AddLines Stdcall (ByVal points As D2D1_POINT_2F Ptr, _
                                           ByVal pointsCount As ULong)
    ' 8.
    Declare Abstract Sub AddBeziers Stdcall (ByVal beziers As D2D1_BEZIER_SEGMENT Ptr, _
                                             ByVal beziersCount As ULong)
    ' 9.
    Declare Abstract Sub EndFigure Stdcall (ByVal figureEnd As D2D1_FIGURE_END)
    ' 10.
    Declare Abstract Function Close Stdcall () As HRESULT
End Type

' ==============================
' ID2D1GeometrySink
' ==============================
Type ID2D1GeometrySink Extends ID2D1SimplifiedGeometrySink 
    ' 11.
    Declare Abstract Sub AddLine Stdcall (ByVal point As D2D1_POINT_2F)
    ' 12.
    Declare Abstract Sub AddBezier Stdcall (ByVal bezier As D2D1_BEZIER_SEGMENT Ptr)
    ' 13.
    Declare Abstract Sub AddQuadraticBezier Stdcall (ByVal bezier As D2D1_QUADRATIC_BEZIER_SEGMENT Ptr)
    ' 14.
    Declare Abstract Sub AddQuadraticBeziers Stdcall (ByVal beziers As D2D1_QUADRATIC_BEZIER_SEGMENT Ptr, _
                                                      ByVal beziersCount As ULong)
    ' 15.
    Declare Abstract Sub AddArc Stdcall (ByVal arc As D2D1_ARC_SEGMENT Ptr)
End Type

' ==============================
' ID2D1TessellationSink
' ==============================
Type ID2D1TessellationSink Extends IUnknownBase
    ' --- IUnknown (Index 1-3) ---
    ' 1. QueryInterface
    ' 2. AddRef
    ' 3. Release
    ' 4.
    Declare Abstract Sub AddTriangles Stdcall (ByVal triangles As D2D1_TRIANGLE Ptr, _
                                               ByVal trianglesCount As ULong)
    ' 5.
    Declare Abstract Function Close Stdcall () As HRESULT
End Type

' ==============================
' ID2D1StrokeStyle
' ==============================
Type ID2D1StrokeStyle Extends ID2D1Resource
    ' 5.
    Declare Abstract Function GetStartCap Stdcall () As D2D1_CAP_STYLE
    ' 6.
    Declare Abstract Function GetEndCap Stdcall () As D2D1_CAP_STYLE
    ' 7.
    Declare Abstract Function GetDashCap Stdcall () As D2D1_CAP_STYLE
    ' 8.
    Declare Abstract Function GetMiterLimit Stdcall () As Single
    ' 9.
    Declare Abstract Function GetLineJoin Stdcall () As D2D1_LINE_JOIN
    ' 10.
    Declare Abstract Function GetDashOffset Stdcall () As Single
    ' 11.
    Declare Abstract Function GetDashStyle Stdcall () As D2D1_DASH_STYLE
    ' 12.
    Declare Abstract Function GetDashesCount Stdcall () As ULong
    ' 13.
    Declare Abstract Sub GetDashes Stdcall (ByVal dashes As Single Ptr, _
                                            ByVal dashesCount As ULong)
End Type

' ==============================
' ID2D1Geometry
' ==============================
Type ID2D1Geometry Extends ID2D1Resource
    ' 5.
    Declare Abstract Function GetBounds Stdcall (ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, _
                                                 ByVal bounds As D2D1_RECT_F Ptr) As HRESULT   
    ' 6
    Declare Abstract Function GetWidenedBounds Stdcall (ByVal strokeWidth As Single, _
                                                        ByVal strokeStyle As ID2D1StrokeStyle Ptr, _ 
                                                        ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, _
                                                        ByVal flatteningTolerance As Single, _
                                                        ByVal bounds As D2D1_RECT_F Ptr) As HRESULT
    ' 7.
    Declare Abstract Function StrokeContainsPoint Stdcall (ByVal point As D2D1_POINT_2F, _
                                                           ByVal strokeWidth As Single, _
                                                           ByVal strokeStyle As ID2D1StrokeStyle Ptr, _
                                                           ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, _
                                                           ByVal flatteningTolerance As Single, _
                                                           ByVal contains As BOOL Ptr) As HRESULT
    ' 8.
    Declare Abstract Function FillContainsPoint Stdcall (ByVal point As D2D1_POINT_2F, _
                                                         ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, _
                                                         ByVal flatteningTolerance As Single, _
                                                         ByVal contains As BOOL Ptr) As HRESULT    
    ' 9.
    Declare Abstract Function CompareWithGeometry Stdcall (ByVal inputGeometry As Any Ptr, _
                                                          ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, _
                                                          ByVal flatteningTolerance As Single, _
                                                          ByVal relation As D2D1_GEOMETRY_RELATION Ptr) As HRESULT   
    ' 10
    Declare Abstract Function Simplify Stdcall (ByVal simplificationOption As D2D1_GEOMETRY_SIMPLIFICATION_OPTION, _
                                                ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, _
                                                ByVal flatteningTolerance As Single, _
                                                ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT   
    ' 11
    Declare Abstract Function Tessellate Stdcall (ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, _
                                                 ByVal flatteningTolerance As Single, _
                                                 ByVal tessellationSink As ID2D1TessellationSink Ptr) As HRESULT  
    ' 12
    Declare Abstract Function CombineWithGeometry Stdcall (ByVal inputGeometry As ID2D1Geometry Ptr, _
                                                          ByVal combineMode As D2D1_COMBINE_MODE, _
                                                          ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, _
                                                          ByVal flatteningTolerance As Single, _
                                                          ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT
    ' 13.
    Declare Abstract Function Outline Stdcall (ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, _
                                               ByVal flatteningTolerance As Single, _
                                               ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr) As HRESULT 
    ' 14.
    Declare Abstract Function ComputeArea Stdcall (ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, _
                                                   ByVal flatteningTolerance As Single, _
                                                   ByVal area As Single Ptr) As HRESULT
    ' 15.
    Declare Abstract Function ComputeLength Stdcall (ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, _
                                                     ByVal flatteningTolerance As Single, _
                                                     ByVal length As Single Ptr) As HRESULT
    ' 16.
    Declare Abstract Function ComputePointAtLength Stdcall (ByVal length As Single, _
                                                            ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, _
                                                            ByVal flatteningTolerance As Single, _
                                                            ByVal point As D2D1_POINT_2F Ptr, _
                                                            ByVal unitVectorX As D2D1_POINT_2F Ptr) As HRESULT
    ' 17.
    Declare Abstract Sub Widen Stdcall (ByVal strokeWidth As Single, _
                                        ByVal strokeStyle As ID2D1StrokeStyle Ptr, _
                                        ByVal worldTransform As D2D1_MATRIX_3X2_F Ptr, _
                                        ByVal flatteningTolerance As Single, _
                                        ByVal geometrySink As ID2D1SimplifiedGeometrySink Ptr)
End Type

' ==============================
' ID2D1RectangleGeometry
' ==============================
Type ID2D1RectangleGeometry Extends ID2D1Geometry
    ' 18.
    Declare Abstract Sub GetRect Stdcall (ByVal rect As D2D1_RECT_F Ptr)
end type

' ==============================
' ID2D1RoundedRectangleGeometry
' ==============================
Type ID2D1RoundedRectangleGeometry Extends ID2D1Geometry
    ' 18.
    Declare Abstract Sub GetRoundedRect Stdcall (ByVal roundedRect As D2D1_ROUNDED_RECT Ptr)
End Type

' ==============================
' ID2D1EllipseGeometry
' ==============================
Type ID2D1EllipseGeometry Extends ID2D1Geometry
    ' 18.
    Declare Abstract Sub GetEllipse Stdcall (ByVal ellipse As D2D1_ELLIPSE Ptr)
End Type

' ==============================
' ID2D1GeometryGroup
' ==============================
Type ID2D1GeometryGroup Extends ID2D1Geometry
    ' 18.
    Declare Abstract Function GetFillMode Stdcall () As D2D1_FILL_MODE
    ' 19.
    Declare Abstract Function GetSourceGeometryCount Stdcall () As ULong
    ' 20.
    Declare Abstract Sub GetSourceGeometries Stdcall (ByVal geometries As ID2D1Geometry Ptr Ptr, _
                                                      ByVal geometriesCount As ULong)
End Type

' ==============================
' ID2D1TransformedGeometry
' ==============================
Type ID2D1TransformedGeometry Extends ID2D1Geometry   
    ' 18.
    Declare Abstract Sub GetSourceGeometry Stdcall (ByVal sourceGeometry As ID2D1Geometry Ptr Ptr)
    ' 19.
    Declare Abstract Sub GetTransform Stdcall (ByVal transform As D2D1_MATRIX_3X2_F Ptr)
End Type

' ==============================
' ID2D1PathGeometry
' ==============================
Type ID2D1PathGeometry Extends ID2D1Geometry
    ' 18.
    Declare Abstract Function Open Stdcall (ByRef geometrySink As ID2D1GeometrySink Ptr) As HRESULT
    ' 19.
    Declare Abstract Function Stream Stdcall (ByVal geometrySink As ID2D1GeometrySink Ptr) As HRESULT    
    ' 20.
    Declare Abstract Function GetSegmentCount Stdcall (ByRef count As ULong) As HRESULT  
    ' 21.
    Declare Abstract Function GetFigureCount Stdcall (ByRef count As ULong) As HRESULT
End Type

Type ID2D1Image Extends ID2D1Resource
    ' 1-3. IUnknown
    ' 4.   ID2D1Resource::GetFactory
End Type

' ==============================
' ID2D1Bitmap
' ==============================
Type ID2D1Bitmap Extends ID2D1Image
    ' 5.
    Declare Abstract Sub GetSize Stdcall (ByVal size As D2D1_SIZE_F Ptr)
    ' 6.
    Declare Abstract Sub GetPixelSize Stdcall (Byval pixSize as D2D1_SIZE_U Ptr)
    ' 7.
    Declare Abstract Sub GetPixelFormat Stdcall (Byval pixFormat As D2D1_PIXEL_FORMAT Ptr)
    ' 8.
    Declare Abstract Sub GetDpi Stdcall (ByRef dpiX As Single, _
                                         ByRef dpiY As Single)
    ' 9.
    Declare Abstract Function CopyFromBitmap Stdcall (ByVal destPoint As D2D1_POINT_2U Ptr, _
                                                      ByVal bitmap As ID2D1Bitmap Ptr, _
                                                      ByVal srcRect As D2D1_RECT_U Ptr) As HRESULT
    ' 10.
    Declare Abstract Function CopyFromRenderTarget Stdcall (ByVal destPoint As D2D1_POINT_2U Ptr, _
                                                            ByVal renderTarget As Any Ptr, _ ' ID2D1RenderTarget Ptr
                                                            ByVal srcRect As D2D1_RECT_U Ptr) As HRESULT
    ' 11.
    Declare Abstract Function CopyFromMemory Stdcall (ByVal dstRect As D2D1_RECT_U Ptr, _
                                                      ByVal srcData As Any Ptr, _
                                                      ByVal pitch As ULong) As HRESULT
End Type

' ==============================
' ID2D1Brush
' ==============================
Type ID2D1Brush Extends ID2D1Resource
    ' 1-3. IUnknown
    ' 4. ID2D1Resource::GetFactory
    ' 5.
    Declare Abstract Sub SetOpacity Stdcall (ByVal opacity As Single)
    ' 6.
    Declare Abstract Sub SetTransform Stdcall (ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    ' 7.
    Declare Abstract Function GetOpacity Stdcall () As Single
    ' 8.
    Declare Abstract Sub GetTransform Stdcall (ByVal transform As D2D1_MATRIX_3X2_F Ptr)
End Type

' ==============================
' ID2D1Brush
' ==============================
Type ID2D1BitmapBrush Extends ID2D1Brush
    ' 9.
    Declare Abstract Sub SetExtendModeX Stdcall (ByVal extendModeX As D2D1_EXTEND_MODE)
    ' 10.
    Declare Abstract Sub SetExtendModeY Stdcall (ByVal extendModeY As D2D1_EXTEND_MODE)
    ' 11.
    Declare Abstract Sub SetInterpolationMode Stdcall (ByVal interpolationMode As D2D1_BITMAP_INTERPOLATION_MODE)
    ' 12.
    Declare Abstract Sub SetBitmap Stdcall (ByVal bitmap As ID2D1Bitmap Ptr)
    ' 13.
    Declare Abstract Function GetExtendModeX Stdcall () As D2D1_EXTEND_MODE
    ' 14.
    Declare Abstract Function GetExtendModeY Stdcall () As D2D1_EXTEND_MODE
    ' 15.
    Declare Abstract Function GetInterpolationMode Stdcall () As D2D1_BITMAP_INTERPOLATION_MODE
    ' 16.
    Declare Abstract Sub GetBitmap Stdcall (ByVal bitmap As ID2D1Bitmap Ptr Ptr)
End Type

' ==============================
' ID2D1SolidColorBrush
' ==============================
Type ID2D1SolidColorBrush Extends ID2D1Brush
    ' 9.
    Declare Abstract Sub SetColor Stdcall (ByVal color As D2D1_COLOR_F Ptr)
    ' 10.
    Declare Abstract Sub GetColor Stdcall (Byval color As D2D1_COLOR_F Ptr)
End Type

' ==============================
' ID2D1GradientStopCollection
' ==============================
Type ID2D1GradientStopCollection Extends ID2D1Resource
    ' 1-3. IUnknown
    ' 4. ID2D1Resource::GetFactory
    ' 5.
    Declare Abstract Function GetGradientStopCount Stdcall () As ULong
    ' 6.
    Declare Abstract Sub GetGradientStops Stdcall (ByVal gradientStops As D2D1_GRADIENT_STOP Ptr, _
                                                  ByVal gradientStopsCount As ULong)
    ' 7.
    Declare Abstract Function GetColorInterpolationGamma Stdcall () As D2D1_GAMMA
    ' 8.
    ' Gibt an, wie die Farben außerhalb des [0,1] Bereichs behandelt werden
    Declare Abstract Function GetExtendMode Stdcall () As D2D1_EXTEND_MODE
    ' 9.
    ' In manchen IDL/Header Versionen: GetColorContext (D2D 1.1+)
    ' In D2D 1.0 ist Slot 9 oft die letzte Methode fur die Stop-Daten.
End Type

' ==============================
' ID2D1LinearGradientBrush
' ==============================
Type ID2D1LinearGradientBrush Extends ID2D1Brush
    ' 9.
    Declare Abstract Sub SetStartPoint Stdcall (ByVal startPoint As D2D1_POINT_2F)
    ' 10.
    Declare Abstract Sub SetEndPoint Stdcall (ByVal endPoint As D2D1_POINT_2F)
    ' 11.
    Declare Abstract Function GetStartPoint Stdcall () As D2D1_POINT_2F
    ' 12.
    Declare Abstract Function GetEndPoint Stdcall () As D2D1_POINT_2F
    ' 13.
    Declare Abstract Sub GetGradientStopCollection Stdcall (ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr Ptr)
End Type

' ==============================
' ID2D1RadialGradientBrush
' ==============================
Type ID2D1RadialGradientBrush Extends ID2D1Brush
    ' 9.
    Declare Abstract Sub SetCenter Stdcall (ByVal center As D2D1_POINT_2F)
    ' 10.
    Declare Abstract Sub SetGradientOriginOffset Stdcall (ByVal gradientOriginOffset As D2D1_POINT_2F)
    ' 11.
    Declare Abstract Sub SetRadiusX Stdcall (ByVal radiusX As Single)
    ' 12.
    Declare Abstract Sub SetRadiusY Stdcall (ByVal radiusY As Single)
    ' 13.
    Declare Abstract Function GetCenter Stdcall () As D2D1_POINT_2F
    ' 14.
    Declare Abstract Function GetGradientOriginOffset Stdcall () As D2D1_POINT_2F
    ' 15.
    Declare Abstract Function GetRadiusX Stdcall () As Single
    ' 16.
    Declare Abstract Function GetRadiusY Stdcall () As Single
    ' 17.
    Declare Abstract Sub GetGradientStopCollection Stdcall (ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr Ptr)
End Type

' ==============================
' ID2D1Layer
' ==============================
Type ID2D1Layer Extends ID2D1Resource
    ' 5.
    Declare Abstract Function GetSize Stdcall () As D2D1_SIZE_F
End Type

' ==============================
' ID2D1Mesh
' ==============================
Type ID2D1Mesh Extends ID2D1Resource
    ' 5.
    Declare Abstract Function Open Stdcall (ByVal tessellationSink As ID2D1TessellationSink Ptr Ptr) As HRESULT
End Type

' ==============================
' ID2D1RenderTarget
' ==============================
Type ID2D1RenderTarget Extends ID2D1Resource
    ' 1-3. (IUnknown)
    ' 4.   (ID2D1Resource: GetFactory)
    ' 5.
    Declare Abstract Function CreateBitmap stdcall (ByVal size As D2D1_SIZE_U, _
                                                    ByVal srcData As Any Ptr, _
                                                    ByVal pitch As ULong, _
                                                    ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, _
                                                    ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    ' 6.
    Declare Abstract Function CreateBitmapFromWicBitmap stdcall (ByVal wicBitmapSource As Any Ptr, _    'IWICBitmapSource
                                                                 ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, _
                                                                 ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    ' 7.
    Declare Abstract Function CreateSharedBitmap stdcall (ByVal riid As GUID Ptr, _
                                                          ByVal data As Any Ptr, _
                                                          ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, _
                                                          ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    ' 8.
    Declare Abstract Function CreateBitmapBrush stdcall (ByVal bitmap As ID2D1Bitmap Ptr, _
                                                         ByVal bitmapBrushProperties As D2D1_BITMAP_BRUSH_PROPERTIES Ptr, _
                                                         ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, _
                                                         ByVal bitmapBrush As ID2D1BitmapBrush Ptr Ptr) As HRESULT
    ' 9.
    Declare Abstract Function CreateSolidColorBrush stdcall (ByVal color As D2D1_COLOR_F Ptr, _
                                                             ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, _
                                                             ByVal solidColorBrush As ID2D1SolidColorBrush Ptr Ptr) As HRESULT
    ' 10.
	Declare Abstract Function CreateGradientStopCollection stdcall (ByVal gradientStops As D2D1_GRADIENT_STOP Ptr, _ 
																    ByVal gradientStopsCount As ULong, _ 
																    ByVal colorInterpolationGamma As D2D1_GAMMA, _
																    ByVal extendMode As D2D1_EXTEND_MODE, _
																    ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr Ptr) As HRESULT
	    ' 11.
    Declare Abstract Function CreateLinearGradientBrush stdcall (ByVal linearGradientBrushProperties As D2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES Ptr, _
                                                                 ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, _
                                                                 ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, _
                                                                 ByVal linearGradientBrush As ID2D1LinearGradientBrush Ptr Ptr) As HRESULT
    ' 12.
	Declare Abstract Function CreateRadialGradientBrush stdcall (ByVal radialGradientBrushProperties As D2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES Ptr, _
																 ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, _
																 ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, _
																 ByVal radialGradientBrush As ID2D1RadialGradientBrush Ptr Ptr) As HRESULT
    ' 13.
    Declare Abstract Function CreateCompatibleRenderTarget stdcall (ByVal desiredSize As D2D1_SIZE_F Ptr, _
                                                                    ByVal desiredPixelSize As D2D1_SIZE_U Ptr, _
                                                                    ByVal desiredFormat As D2D1_PIXEL_FORMAT Ptr, _
                                                                    ByVal options As ULong, _
                                                                    ByVal bitmapRenderTarget As any Ptr Ptr) As HRESULT 'ID2D1BitmapRenderTarget
    ' 14.
    Declare Abstract Function CreateLayer stdcall (ByVal size As D2D1_SIZE_F Ptr, _
                                                   ByVal layer As ID2D1Layer Ptr Ptr) As HRESULT
    ' 15.
    Declare Abstract Function CreateMesh stdcall (ByVal mesh As ID2D1Mesh Ptr Ptr) As HRESULT
    ' 16.
    Declare Abstract Sub DrawLine stdcall (ByVal p0 As D2D1_POINT_2F, _
                                           ByVal p1 As D2D1_POINT_2F, _
                                           ByVal brush As ID2D1SolidColorBrush Ptr, _
                                           ByVal strokeWidth As Single = 0, _
                                           ByVal strokeStyle As ID2D1StrokeStyle Ptr = Null)
    ' 17.
    Declare Abstract Sub DrawRectangle stdcall (ByVal rect As D2D1_RECT_F Ptr, _
                                                ByVal brush As ID2D1Brush Ptr, _
                                                ByVal strokeWidth As Single, _
                                                ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    ' 18.
    Declare Abstract Sub FillRectangle stdcall (ByVal rect As D2D1_RECT_F Ptr, _
                                                ByVal brush As ID2D1Brush Ptr)
    ' 19.
    Declare Abstract Sub DrawRoundedRectangle stdcall (ByVal roundRect As D2D1_ROUNDED_RECT Ptr, _
                                                       ByVal brush As ID2D1Brush Ptr, _
                                                       ByVal strokeWidth As Single, _
                                                       ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    ' 20.
    Declare Abstract Sub FillRoundedRectangle stdcall (ByVal roundRect As D2D1_ROUNDED_RECT Ptr, _
                                                       ByVal brush As ID2D1Brush Ptr)
    ' 21.
    Declare Abstract Sub DrawEllipse stdcall (ByVal ellipse As D2D1_ELLIPSE Ptr, _
                                              ByVal brush As ID2D1Brush Ptr, _
                                              ByVal strokeWidth As Single, _
                                              ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    ' 22.
    Declare Abstract Sub FillEllipse stdcall (ByVal ellipse As D2D1_ELLIPSE Ptr, _
                                              ByVal brush As ID2D1Brush Ptr)
    ' 23.
    Declare Abstract Sub DrawGeometry stdcall (ByVal geometry As ID2D1Geometry Ptr, _
                                               ByVal brush As ID2D1Brush Ptr, _
                                               ByVal strokeWidth As Single, _
                                               ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    ' 24.
    Declare Abstract Sub FillGeometry stdcall (ByVal geometry As ID2D1Geometry Ptr, _
                                               ByVal brush As ID2D1Brush Ptr, _
                                               ByVal opacityBrush As ID2D1Brush Ptr)
    ' 25.
    Declare Abstract Sub FillMesh stdcall (ByVal mesh As ID2D1Mesh Ptr, _
                                           ByVal brush As ID2D1Brush Ptr)
    ' 26.
    Declare Abstract Sub FillOpacityMask stdcall (ByVal mask As ID2D1Bitmap Ptr, _
                                                  ByVal brush As ID2D1Brush Ptr, _
                                                  ByVal content As D2D1_OPACITY_MASK_CONTENT, _
                                                  ByVal destRect As D2D1_RECT_F Ptr, _
                                                  ByVal sourceRect As D2D1_RECT_F Ptr)
    ' 27.
    Declare Abstract Sub DrawBitmap stdcall (ByVal bitmap As ID2D1Bitmap Ptr, _
                                             ByVal destRect As D2D1_RECT_F Ptr, _
                                             ByVal opacity As Single, _
                                             ByVal interpolationMode As D2D1_BITMAP_INTERPOLATION_MODE, _
                                             ByVal sourceRect As D2D1_RECT_F Ptr)
    ' 28.
    Declare Abstract Sub DrawText stdcall (ByVal text As WString Ptr, _
                                           ByVal stringLength As ULong, _
                                           ByVal textFormat As Any Ptr, _       'IDWriteTextFormat
                                           ByVal layoutRect As D2D1_RECT_F Ptr, _
                                           ByVal brush As ID2D1Brush Ptr, _
                                           ByVal options As D2D1_DRAW_TEXT_OPTIONS = 0, _
                                           ByVal measuringMode As DWRITE_MEASURING_MODE = 0)
    ' 29.
    Declare Abstract Sub DrawTextLayout stdcall (ByVal origin As D2D1_POINT_2F Ptr, _
                                                 ByVal layout As Any Ptr, _     'IDWriteTextLayout
                                                 ByVal brush As ID2D1Brush Ptr, _
                                                 ByVal options As D2D1_DRAW_TEXT_OPTIONS)
    ' 30.
    Declare Abstract Sub DrawGlyphRun stdcall (ByVal baselineOrigin As D2D1_POINT_2F Ptr, _
                                              ByVal glyphRun As Any Ptr, _      'DWRITE_GLYPH_RUN
                                              ByVal brush As ID2D1Brush Ptr, _
                                              ByVal measuringMode As DWRITE_MEASURING_MODE)
    ' 31.
    Declare Abstract Sub SetTransform stdcall (ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    ' 32.
    Declare Abstract Sub GetTransform stdcall (ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    ' 33.
    Declare Abstract Sub SetAntialiasMode stdcall (ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    ' 34.
    Declare Abstract Function GetAntialiasMode stdcall () As D2D1_ANTIALIAS_MODE
    ' 35.
    Declare Abstract Sub SetTextAntialiasMode stdcall (ByVal antialiasMode As D2D1_TEXT_ANTIALIAS_MODE)
    ' 36.
    Declare Abstract Function GetTextAntialiasMode stdcall () As D2D1_TEXT_ANTIALIAS_MODE
    ' 37.
    Declare Abstract Sub SetTextRenderingParams stdcall (ByVal params As Any Ptr)   'IDWriteRenderingParams
    ' 38.
    Declare Abstract Sub GetTextRenderingParams stdcall (ByVal params As Any Ptr Ptr) 'IDWriteRenderingParams
    ' 39.
    Declare Abstract Sub SetTags stdcall (ByVal tag1 As D2D1_TAG, _
                                          ByVal tag2 As D2D1_TAG)
    ' 40.
    Declare Abstract Sub GetTags stdcall (ByVal tag1 As D2D1_TAG Ptr, _
                                          ByVal tag2 As D2D1_TAG Ptr)
    ' 41.
    Declare Abstract Sub PushLayer stdcall (ByVal layerParams As D2D1_LAYER_PARAMETERS Ptr, _
                                            ByVal layer As ID2D1Layer Ptr)
    ' 42.
    Declare Abstract Sub PopLayer stdcall ()
    ' 43.
    Declare Abstract Function Flush stdcall (ByVal tag1 As D2D1_TAG Ptr, _
                                             ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    ' 44.
    Declare Abstract Sub SaveDrawingState stdcall (ByVal stateBlock As Any Ptr)     'ID2D1DrawingStateBlock
    ' 45.
    Declare Abstract Sub RestoreDrawingState stdcall (ByVal stateBlock As Any Ptr)   'ID2D1DrawingStateBlock
    ' 46.
    Declare Abstract Sub PushAxisAlignedClip stdcall (ByVal rect As D2D1_RECT_F Ptr, _
                                                      ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    ' 47.
    Declare Abstract Sub PopAxisAlignedClip stdcall ()
    ' 48.
    Declare Abstract Sub Clear stdcall (ByVal col As D2D1_COLOR_F Ptr)
    ' 49.
    Declare Abstract Sub BeginDraw stdcall()
    ' 50.
    Declare Abstract Function EndDraw stdcall (ByVal tag1 As D2D1_TAG Ptr, _
                                               ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    ' 51.
	Declare Abstract Function GetPixelFormat stdcall () As D2D1_PIXEL_FORMAT
    ' 52.
    Declare Abstract Sub SetDpi stdcall (ByVal dpiX As Single, _
                                         ByVal dpiY As Single)
    ' 53.
    Declare Abstract Sub GetDpi stdcall (ByVal dpiX As Single Ptr, _
                                         ByVal dpiY As Single Ptr)
    ' 54.
    Declare Abstract Function GetSize stdcall (ByVal size As Any Ptr) As D2D1_SIZE_F
    ' 55.
    Declare Abstract Function GetPixelSize stdcall (ByVal pixelSize As Any Ptr) As D2D1_SIZE_U
    ' 56.
    Declare Abstract Function GetMaximumBitmapSize stdcall () As ULong
    ' 57.
    Declare Abstract Function IsSupported stdcall (ByVal renderTargetProperties As D2D1_RENDER_TARGET_PROPERTIES Ptr) As BOOL
End Type

' ==============================
' ID2D1HwndRenderTarget
' ==============================
Type ID2D1HwndRenderTarget Extends ID2D1RenderTarget
	' 58.
    Declare Abstract Function CheckWindowState stdcall () As D2D1_WINDOW_STATE
    ' 59.
    Declare Abstract Function Resize stdcall (ByVal sz As D2D1_SIZE_U Ptr) As HRESULT
    ' 60.
    Declare Abstract Function GetHwnd stdcall () As HWND
End Type

' ==============================
' ID2D1DCRenderTarget
' ==============================
Type ID2D1DCRenderTarget Extends ID2D1RenderTarget
    ' 58
    Declare Abstract Function BindDC stdcall (ByVal dc As HDC, _
                                              ByVal rect As RECT Ptr) As HRESULT
End Type


' ==============================
' ID2D1GdiInteropRenderTarget
' ==============================
Type ID2D1GdiInteropRenderTarget Extends IUnknownBase
    ' 1. QueryInterface
    ' 2. AddRef
    ' 3. Release
    ' 4.
    Declare Abstract Function GetDC stdcall(ByVal mode As D2D1_DC_INITIALIZE_MODE, _ 
                                            ByRef hdc As HDC) As HRESULT
    ' 5
    Declare Abstract Function ReleaseDC stdcall(ByVal updateRect As RECT Ptr) As HRESULT
End Type

' ============================================================================
' ID2D1BitmapRenderTarget
' ============================================================================
Type ID2D1BitmapRenderTarget Extends ID2D1RenderTarget
    ' Slots 1-57: Von ID2D1RenderTarget geerbt
    
    ' 58. GetBitmap - OUT-Parameter muss Pointer-to-Pointer sein!
    Declare Abstract Function GetBitmap stdcall (ByVal ppBitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    ' Alternativ:
    ' ByVal ppBitmap As ID2D1Bitmap Ptr Ptr
End Type

' ==============================
' ID2D1Factory
' ==============================
Type ID2D1Factory Extends IUnknownBase
	' 1. QueryInterface
    ' 2. AddRef
    ' 3. Release
    ' 4.
    Declare Abstract Function ReloadSystemMetrics stdcall () As HRESULT
    ' 5.
    Declare Abstract Sub GetDesktopDpi stdcall (ByVal dpiX As Single Ptr, _
                                                ByVal dpiY As Single Ptr)
    ' 6.
    Declare Abstract Function CreateRectangleGeometry stdcall (ByVal rect As D2D1_RECT_F Ptr, _
                                                              ByVal geometry As ID2D1RectangleGeometry Ptr Ptr) As HRESULT 
    ' 7.
    Declare Abstract Function CreateRoundedRectangleGeometry stdcall (ByVal rect As D2D1_ROUNDED_RECT Ptr, _
                                                                     ByVal geometry As ID2D1RoundedRectangleGeometry Ptr Ptr) As HRESULT
    ' 8.
    Declare Abstract Function CreateEllipseGeometry stdcall (ByVal ellipse As D2D1_ELLIPSE Ptr, _
                                                             ByVal ID2D1EllipseGeometry As Any Ptr Ptr) As HRESULT
    ' 9.
    Declare Abstract Function CreateGeometryGroup stdcall (ByVal fill_mode As D2D1_FILL_MODE, _
                                                          ByVal geometries As ID2D1Geometry Ptr Ptr, _
                                                          ByVal geometryCount As ULong, _
                                                          ByVal group As ID2D1GeometryGroup Ptr Ptr) As HRESULT
    ' 10.
    Declare Abstract Function CreateTransformedGeometry stdcall (ByVal src_geometry As ID2D1Geometry Ptr, _
                                                                 ByVal transform As D2D1_MATRIX_3X2_F Ptr, _
                                                                 ByVal transformedGeometry As ID2D1TransformedGeometry Ptr Ptr) As HRESULT
    ' 11.
    Declare Abstract Function CreatePathGeometry stdcall (ByVal geometry As ID2D1PathGeometry Ptr Ptr) As HRESULT
    ' 12.
    Declare Abstract Function CreateStrokeStyle stdcall (ByVal styleProps As D2D1_STROKE_STYLE_PROPERTIES Ptr, _
                                                         ByVal dashes As Single Ptr, _
                                                         ByVal dashCount As ULong, _
                                                         ByVal strokeStyle As ID2D1StrokeStyle Ptr Ptr) As HRESULT
    ' 13.
    Declare Abstract Function CreateDrawingStateBlock stdcall (ByVal stateDesc As D2D1_DRAWING_STATE_DESCRIPTION Ptr, _
                                                              ByVal text_renderingParams As Any Ptr, _
                                                              ByVal stateBlock As IUnknownBase Ptr Ptr) As HRESULT ' ID2D1DrawingStateBlock
    ' 14.
    Declare Abstract Function CreateWicBitmapRenderTarget stdcall (ByVal target As Any Ptr, _       'IWICBitmap
                                                                   ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, _
                                                                   ByVal renderTarget As ID2D1RenderTarget Ptr Ptr) As HRESULT
    ' 15.
    Declare Abstract Function CreateHwndRenderTarget stdcall (ByVal desc As D2D1_RENDER_TARGET_PROPERTIES Ptr, _
                                                              ByVal targetProps As D2D1_HWND_RENDER_TARGET_PROPERTIES Ptr, _
                                                              ByVal renderTarget As ID2D1HwndRenderTarget Ptr Ptr) As HRESULT
    ' 16.
    Declare Abstract Function CreateDxgiSurfaceRenderTarget stdcall (ByVal surface As Any Ptr, _        'IDXGISurface
                                                                     ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, _
                                                                     ByVal renderTarget As ID2D1RenderTarget Ptr Ptr) As HRESULT
    ' 17.
    Declare Abstract Function CreateDCRenderTarget stdcall (ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, _
                                                            ByVal renderTarget As ID2D1DCRenderTarget Ptr Ptr) As HRESULT
End Type

Extern "Windows"
Declare Function D2D1InvertMatrix Lib "d2d1" (ByVal matrix As D2D1_MATRIX_3X2_F Ptr) As Long

Declare Function D2D1IsMatrixInvertible Lib "d2d1" (ByVal matrix As D2D1_MATRIX_3X2_F Ptr) As Long

Declare Sub D2D1MakeRotateMatrix Lib "d2d1" (ByVal angle As Single, _
                                             ByVal center As D2D1_POINT_2F, _
                                             ByVal matrix As D2D1_MATRIX_3X2_F Ptr)

Declare Sub D2D1MakeSkewMatrix Lib "d2d1" (ByVal angle_x As Single, _
                                           ByVal angle_y As Single, _
                                           ByVal center As D2D1_POINT_2F, _
                                           ByVal matrix As D2D1_MATRIX_3X2_F Ptr)
End Extern