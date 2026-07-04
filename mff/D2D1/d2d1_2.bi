'###############################################################################
' This file is part of MyFBFramework
' Authors: UEZ, Xusinboy Bekchanov, Liu XiaLin
' Based on UEZ's abstract version.
' Direct2D 1.2 API - FreeBASIC Translation
' Adapted by Xusinboy Bekchanov, Liu XiaLin
'###############################################################################
#include once "d2d1_1.bi"
#include once "d2d1effects_1.bi"
' ============================================================================
' Enumerations
' ============================================================================
Type D2D1_RENDERING_PRIORITY As Long
Enum
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
    ' 4: GetFactory (ID2D1Resource)
    ' Keine zusätzlichen Methoden
End Type
' ============================================================================
' ID2D1DeviceContext1
' ============================================================================
Type ID2D1DeviceContext1Vtbl As ID2D1DeviceContext1Vtbl_
Type ID2D1DeviceContext1
    lpVtbl As ID2D1DeviceContext1Vtbl Ptr
End Type
Type ID2D1DeviceContext1Vtbl_     '' Extends ID2D1DeviceContextVtbl_
    QueryInterface As Function(ByVal This As ID2D1DeviceContext1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1DeviceContext1 Ptr) As ULong
    Release As Function(ByVal This As ID2D1DeviceContext1 Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal factory As Any Ptr Ptr)
        ' 4.   (ID2D1Resource: GetFactory)
    CreateBitmap As Function(ByVal This As ID2D1DeviceContext1 Ptr, ByVal size As D2D1_SIZE_U, ByVal srcData As Any Ptr, ByVal pitch As ULong, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapFromWicBitmap As Function(ByVal This As ID2D1DeviceContext1 Ptr, ByVal wicBitmapSource As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateSharedBitmap As Function(ByVal This As ID2D1DeviceContext1 Ptr, ByVal riid As GUID Ptr, ByVal data As Any Ptr, ByVal bitmapProps As D2D1_BITMAP_PROPERTIES Ptr, ByVal bitmap As ID2D1Bitmap Ptr Ptr) As HRESULT
    CreateBitmapBrush As Function(ByVal This As ID2D1DeviceContext1 Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal bitmapBrushProperties As D2D1_BITMAP_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal bitmapBrush As ID2D1BitmapBrush Ptr Ptr) As HRESULT
    CreateSolidColorBrush As Function(ByVal This As ID2D1DeviceContext1 Ptr, ByVal color As D2D1_COLOR_F Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal solidColorBrush As ID2D1SolidColorBrush Ptr Ptr) As HRESULT
    CreateGradientStopCollection As Function(ByVal This As ID2D1DeviceContext1 Ptr, ByVal gradientStops As D2D1_GRADIENT_STOP Ptr, ByVal gradientStopsCount As ULong, ByVal colorInterpolationGamma As D2D1_GAMMA, ByVal extendMode As D2D1_EXTEND_MODE, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr Ptr) As HRESULT
    CreateLinearGradientBrush As Function(ByVal This As ID2D1DeviceContext1 Ptr, ByVal linearGradientBrushProperties As D2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal linearGradientBrush As ID2D1LinearGradientBrush Ptr Ptr) As HRESULT
    CreateRadialGradientBrush As Function(ByVal This As ID2D1DeviceContext1 Ptr, ByVal radialGradientBrushProperties As D2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES Ptr, ByVal brushProperties As D2D1_BRUSH_PROPERTIES Ptr, ByVal gradientStopCollection As ID2D1GradientStopCollection Ptr, ByVal radialGradientBrush As ID2D1RadialGradientBrush Ptr Ptr) As HRESULT
    CreateCompatibleRenderTarget As Function(ByVal This As ID2D1DeviceContext1 Ptr, ByVal desiredSize As D2D1_SIZE_F Ptr, ByVal desiredPixelSize As D2D1_SIZE_U Ptr, ByVal desiredFormat As D2D1_PIXEL_FORMAT Ptr, ByVal options As ULong, ByVal bitmapRenderTarget As Any Ptr Ptr) As HRESULT 'ID2D1BitmapRenderTarget
    CreateLayer As Function(ByVal This As ID2D1DeviceContext1 Ptr, ByVal size As D2D1_SIZE_F Ptr, ByVal layer As ID2D1Layer Ptr Ptr) As HRESULT
    CreateMesh As Function(ByVal This As ID2D1DeviceContext1 Ptr, ByVal mesh As ID2D1Mesh Ptr Ptr) As HRESULT
    DrawLine As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal p0 As D2D1_POINT_2F, ByVal p1 As D2D1_POINT_2F, ByVal brush As ID2D1SolidColorBrush Ptr, ByVal strokeWidth As Single = 0, ByVal strokeStyle As ID2D1StrokeStyle Ptr = NULL)
    DrawRectangle As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRectangle As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawRoundedRectangle As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillRoundedRectangle As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal roundRect As D2D1_ROUNDED_RECT Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawEllipse As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillEllipse As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal brush As ID2D1Brush Ptr)
    DrawGeometry As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal strokeWidth As Single, ByVal strokeStyle As ID2D1StrokeStyle Ptr)
    FillGeometry As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal opacityBrush As ID2D1Brush Ptr)
    FillMesh As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal mesh As ID2D1Mesh Ptr, ByVal brush As ID2D1Brush Ptr)
    FillOpacityMask As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal mask As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal content As D2D1_OPACITY_MASK_CONTENT, ByVal destRect As D2D1_RECT_F Ptr, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawBitmap As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal bitmap As ID2D1Bitmap Ptr, ByVal destRect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolationMode As D2D1_BITMAP_INTERPOLATION_MODE, ByVal sourceRect As D2D1_RECT_F Ptr)
    DrawText As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal text As WString Ptr, ByVal stringLength As ULong, ByVal textFormat As Any Ptr, ByVal layoutRect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS = 0, ByVal measuringMode As DWRITE_MEASURING_MODE = 0)
    DrawTextLayout As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal origin As D2D1_POINT_2F Ptr, ByVal layout As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal options As D2D1_DRAW_TEXT_OPTIONS)
    DrawGlyphRun As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal baselineOrigin As D2D1_POINT_2F Ptr, ByVal glyphRun As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuringMode As DWRITE_MEASURING_MODE)
    SetTransform As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    GetTransform As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr)
    SetAntialiasMode As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    GetAntialiasMode As Function(ByVal This As ID2D1DeviceContext1 Ptr) As D2D1_ANTIALIAS_MODE
    SetTextAntialiasMode As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal antialiasMode As D2D1_TEXT_ANTIALIAS_MODE)
    GetTextAntialiasMode As Function(ByVal This As ID2D1DeviceContext1 Ptr) As D2D1_TEXT_ANTIALIAS_MODE
    SetTextRenderingParams As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal params As Any Ptr)
    GetTextRenderingParams As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal params As Any Ptr Ptr)
    SetTags As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal tag1 As D2D1_TAG, ByVal tag2 As D2D1_TAG)
    GetTags As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr)
    PushLayer As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal layerParams As D2D1_LAYER_PARAMETERS Ptr, ByVal layer As ID2D1Layer Ptr)
    PopLayer As Sub(ByVal This As ID2D1DeviceContext1 Ptr)
    Flush As Function(ByVal This As ID2D1DeviceContext1 Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    SaveDrawingState As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal stateBlock As Any Ptr)
    RestoreDrawingState As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal stateBlock As Any Ptr)
    PushAxisAlignedClip As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal antialiasMode As D2D1_ANTIALIAS_MODE)
    PopAxisAlignedClip As Sub(ByVal This As ID2D1DeviceContext1 Ptr)
    Clear As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal col As D2D1_COLOR_F Ptr)
    BeginDraw As Sub(ByVal This As ID2D1DeviceContext1 Ptr)
    EndDraw As Function(ByVal This As ID2D1DeviceContext1 Ptr, ByVal tag1 As D2D1_TAG Ptr, ByVal tag2 As D2D1_TAG Ptr) As HRESULT
    GetPixelFormat As Function(ByVal This As ID2D1DeviceContext1 Ptr) As D2D1_PIXEL_FORMAT
    SetDpi As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal dpiX As Single, ByVal dpiY As Single)
    GetDpi As Sub(ByVal This As ID2D1DeviceContext1 Ptr, ByVal dpiX As Single Ptr, ByVal dpiY As Single Ptr)
    GetSize As Function(ByVal This As ID2D1DeviceContext1 Ptr, ByVal size As Any Ptr) As D2D1_SIZE_F
    GetPixelSize As Function(ByVal This As ID2D1DeviceContext1 Ptr, ByVal pixelSize As Any Ptr) As D2D1_SIZE_U
    GetMaximumBitmapSize As Function(ByVal This As ID2D1DeviceContext1 Ptr) As ULong
    IsSupported As Function(ByVal This As ID2D1DeviceContext1 Ptr, ByVal renderTargetProperties As D2D1_RENDER_TARGET_PROPERTIES Ptr) As BOOL
        ' Erbt alle Methoden von ID2D1RenderTarget (1-57)
    	' 58. CreateBitmap (überladen)
    CreateBitmap1 As Function(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal size As D2D1_SIZE_U, ByVal src_data As Any Ptr, ByVal pitch As ULong, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As Any Ptr Ptr ) As HRESULT
    	' 59. CreateBitmapFromWicBitmap (überladen)
    CreateBitmapFromWicBitmap1 As Function(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal bitmap_source As IUnknownBase Ptr, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As ID2D1Bitmap1 Ptr Ptr ) As HRESULT
    	' 60. CreateColorContext
    CreateColorContext As Function(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal space As D2D1_COLOR_SPACE, ByVal profile As UByte Ptr, ByVal profile_size As ULong, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 61. CreateColorContextFromFilename
    CreateColorContextFromFilename As Function(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal filename As WString Ptr, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 62. CreateColorContextFromWicColorContext
    CreateColorContextFromWicColorContext As Function(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal wic_color_context As Any Ptr, ByVal color_context As Any Ptr Ptr ) As HRESULT
    	' 63. CreateBitmapFromDxgiSurface
    CreateBitmapFromDxgiSurface As Function(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal surface As Any Ptr, ByVal desc As D2D1_BITMAP_PROPERTIES1 Ptr, ByVal bitmap As Any Ptr Ptr ) As HRESULT
    	' 64. CreateEffect
    CreateEffect As Function(ByVal This As ID2D1DeviceContext1 Ptr,  ByRef effect_id As GUID, ByVal effect As ID2D1Effect Ptr Ptr ) As HRESULT
    	' 65. CreateGradientStopCollection (überladen)
    CreateGradientStopCollection1 As Function(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal stops As D2D1_GRADIENT_STOP Ptr, ByVal stop_count As ULong, ByVal preinterpolation_space As D2D1_COLOR_SPACE, ByVal postinterpolation_space As D2D1_COLOR_SPACE, ByVal buffer_precision As D2D1_BUFFER_PRECISION, ByVal extend_mode As D2D1_EXTEND_MODE, ByVal color_interpolation_mode As D2D1_COLOR_INTERPOLATION_MODE, ByVal gradient As Any Ptr Ptr ) As HRESULT
    	' 66. CreateImageBrush
    CreateImageBrush As Function(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal image As ID2D1Image Ptr, ByVal image_brush_desc As D2D1_IMAGE_BRUSH_PROPERTIES Ptr, ByVal brush_desc As D2D1_BRUSH_PROPERTIES Ptr, ByVal brush As Any Ptr Ptr ) As HRESULT
    	' 67. CreateBitmapBrush (überladen)
    CreateBitmapBrush1 As Function(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal bitmap_brush_desc As D2D1_BITMAP_BRUSH_PROPERTIES1 Ptr, ByVal brush_desc As D2D1_BRUSH_PROPERTIES Ptr, ByVal bitmap_brush As Any Ptr Ptr ) As HRESULT
    	' 68. CreateCommandList
    CreateCommandList As Function(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal command_list As Any Ptr Ptr ) As HRESULT
    	' 69. IsDxgiFormatSupported
    IsDxgiFormatSupported As Function(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal format As ULong ) As Long
    	' 70. IsBufferPrecisionSupported
    IsBufferPrecisionSupported As Function(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal buffer_precision As D2D1_BUFFER_PRECISION ) As Long
    	' 71. GetImageLocalBounds
    GetImageLocalBounds As Function(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal image As ID2D1Image Ptr, ByVal local_bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 72. GetImageWorldBounds
    GetImageWorldBounds As Function(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal image As ID2D1Image Ptr, ByVal world_bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 73. GetGlyphRunWorldBounds
    GetGlyphRunWorldBounds As Function(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal measuring_mode As ULong, ByVal bounds As D2D1_RECT_F Ptr ) As HRESULT
    	' 74. GetDevice
    GetDevice As Sub(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal device As Any Ptr Ptr )
    	' 75. SetTarget
    SetTarget As Sub(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal target As ID2D1Image Ptr )
    	' 76. GetTarget
    GetTarget As Sub(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal target As Any Ptr Ptr )
    	' 77. SetRenderingControls
    SetRenderingControls As Sub(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal rendering_controls As D2D1_RENDERING_CONTROLS Ptr )
    	' 78. GetRenderingControls
    GetRenderingControls As Sub(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal rendering_controls As D2D1_RENDERING_CONTROLS Ptr )
    	' 79. SetPrimitiveBlend
    SetPrimitiveBlend As Sub(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal primitive_blend As D2D1_PRIMITIVE_BLEND )
    	' 80. GetPrimitiveBlend
    GetPrimitiveBlend As Function(ByVal This As ID2D1DeviceContext1 Ptr) As D2D1_PRIMITIVE_BLEND
    	' 81. SetUnitMode
    SetUnitMode As Sub(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal unit_mode As D2D1_UNIT_MODE )
    	' 82. GetUnitMode
    GetUnitMode As Function(ByVal This As ID2D1DeviceContext1 Ptr) As D2D1_UNIT_MODE
    	' 83. DrawGlyphRun (überladen)
    DrawGlyphRun1 As Sub(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal glyph_run_desc As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuring_mode As ULong )
    	' 84. DrawImage
    DrawImage As Sub(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal image As ID2D1Image Ptr, ByVal target_offset As D2D1_POINT_2F Ptr = 0, ByVal image_rect As D2D1_RECT_F Ptr = 0, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE = D2D1_INTERPOLATION_MODE_LINEAR, ByVal composite_mode As D2D1_COMPOSITE_MODE = D2D1_COMPOSITE_MODE_SOURCE_OVER )
    	' 85. DrawGdiMetafile
    DrawGdiMetafile As Sub(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal metafile As ID2D1GdiMetafile Ptr, ByVal target_offset As D2D1_POINT_2F Ptr )
    	' 86. DrawBitmap (überladen)
    DrawBitmap1 As Sub(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE, ByVal src_rect As D2D1_RECT_F Ptr, ByVal perspective_transform As D2D1_MATRIX_4X4_F Ptr )
    	' 87. InvalidateEffectInputRectangle
    InvalidateEffectInputRectangle As Function(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal effect As Any Ptr, ByVal input As ULong, ByVal input_rect As D2D1_RECT_F Ptr ) As HRESULT
    	' 88. GetEffectInvalidRectangleCount
    GetEffectInvalidRectangleCount As Function(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal effect As Any Ptr, ByVal rect_count As ULong Ptr ) As HRESULT
    	' 89. GetEffectInvalidRectangles
    GetEffectInvalidRectangles As Function(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal effect As Any Ptr, ByVal rectangles As D2D1_RECT_F Ptr, ByVal rect_count As ULong ) As HRESULT
    	' 90. GetEffectRequiredInputRectangles
    GetEffectRequiredInputRectangles As Function(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal effect As Any Ptr, ByVal image_rect As D2D1_RECT_F Ptr, ByVal desc As D2D1_EFFECT_INPUT_DESCRIPTION Ptr, ByVal input_rects As D2D1_RECT_F Ptr, ByVal input_count As ULong ) As HRESULT
    	' 91. FillOpacityMask (überladen)
    FillOpacityMask1 As Sub(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal mask As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal content As D2D1_OPACITY_MASK_CONTENT, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal src_rect As D2D1_RECT_F Ptr )
    	' 92. PushLayer
    PushLayer1 As Sub(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal layer_parameters As D2D1_LAYER_PARAMETERS1 Ptr, ByVal layer As ID2D1Layer Ptr )

        ' Erbt alle Methoden von ID2D1DeviceContext (1-96 Methoden)
        ' 97. CreateFilledGeometryRealization
    CreateFilledGeometryRealization As Function(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal tolerance As Single, ByVal realization As Any Ptr Ptr ) As HRESULT
        ' 98. CreateStrokedGeometryRealization
    CreateStrokedGeometryRealization As Function(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal tolerance As Single, ByVal stroke_width As Single, ByVal stroke_style As ID2D1StrokeStyle Ptr, ByVal realization As Any Ptr Ptr ) As HRESULT
        ' 99. DrawGeometryRealization
    DrawGeometryRealization As Sub(ByVal This As ID2D1DeviceContext1 Ptr,  ByVal realization As ID2D1GeometryRealization Ptr, ByVal brush As ID2D1Brush Ptr )
End Type
#define ID2D1DeviceContext1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1DeviceContext1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1DeviceContext1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1DeviceContext1_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1DeviceContext1_CreateBitmap(p, a, b, c, d, e) (p)->lpVtbl->CreateBitmap(p, a, b, c, d, e)
#define ID2D1DeviceContext1_CreateBitmapFromWicBitmap(p, a, b, c) (p)->lpVtbl->CreateBitmapFromWicBitmap(p, a, b, c)
#define ID2D1DeviceContext1_CreateSharedBitmap(p, a, b, c, d) (p)->lpVtbl->CreateSharedBitmap(p, a, b, c, d)
#define ID2D1DeviceContext1_CreateBitmapBrush(p, a, b, c, d) (p)->lpVtbl->CreateBitmapBrush(p, a, b, c, d)
#define ID2D1DeviceContext1_CreateSolidColorBrush(p, a, b, c) (p)->lpVtbl->CreateSolidColorBrush(p, a, b, c)
#define ID2D1DeviceContext1_CreateGradientStopCollection(p, a, b, c, d, e) (p)->lpVtbl->CreateGradientStopCollection(p, a, b, c, d, e)
#define ID2D1DeviceContext1_CreateLinearGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateLinearGradientBrush(p, a, b, c, d)
#define ID2D1DeviceContext1_CreateRadialGradientBrush(p, a, b, c, d) (p)->lpVtbl->CreateRadialGradientBrush(p, a, b, c, d)
#define ID2D1DeviceContext1_CreateCompatibleRenderTarget(p, a, b, c, d, e) (p)->lpVtbl->CreateCompatibleRenderTarget(p, a, b, c, d, e)
#define ID2D1DeviceContext1_CreateLayer(p, a, b) (p)->lpVtbl->CreateLayer(p, a, b)
#define ID2D1DeviceContext1_CreateMesh(p, a) (p)->lpVtbl->CreateMesh(p, a)
#define ID2D1DeviceContext1_DrawLine(p, a, b, c, d, e) (p)->lpVtbl->DrawLine(p, a, b, c, d, e)
#define ID2D1DeviceContext1_DrawRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRectangle(p, a, b, c, d)
#define ID2D1DeviceContext1_FillRectangle(p, a, b) (p)->lpVtbl->FillRectangle(p, a, b)
#define ID2D1DeviceContext1_DrawRoundedRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRoundedRectangle(p, a, b, c, d)
#define ID2D1DeviceContext1_FillRoundedRectangle(p, a, b) (p)->lpVtbl->FillRoundedRectangle(p, a, b)
#define ID2D1DeviceContext1_DrawEllipse(p, a, b, c, d) (p)->lpVtbl->DrawEllipse(p, a, b, c, d)
#define ID2D1DeviceContext1_FillEllipse(p, a, b) (p)->lpVtbl->FillEllipse(p, a, b)
#define ID2D1DeviceContext1_DrawGeometry(p, a, b, c, d) (p)->lpVtbl->DrawGeometry(p, a, b, c, d)
#define ID2D1DeviceContext1_FillGeometry(p, a, b, c) (p)->lpVtbl->FillGeometry(p, a, b, c)
#define ID2D1DeviceContext1_FillMesh(p, a, b) (p)->lpVtbl->FillMesh(p, a, b)
#define ID2D1DeviceContext1_FillOpacityMask(p, a, b, c, d, e) (p)->lpVtbl->FillOpacityMask(p, a, b, c, d, e)
#define ID2D1DeviceContext1_DrawBitmap(p, a, b, c, d, e) (p)->lpVtbl->DrawBitmap(p, a, b, c, d, e)
#define ID2D1DeviceContext1_DrawText(p, a, b, c, d, e, f, g) (p)->lpVtbl->DrawText(p, a, b, c, d, e, f, g)
#define ID2D1DeviceContext1_DrawTextLayout(p, a, b, c, d) (p)->lpVtbl->DrawTextLayout(p, a, b, c, d)
#define ID2D1DeviceContext1_DrawGlyphRun(p, a, b, c, d) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d)
#define ID2D1DeviceContext1_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1DeviceContext1_GetTransform(p, a) (p)->lpVtbl->GetTransform(p, a)
#define ID2D1DeviceContext1_SetAntialiasMode(p, a) (p)->lpVtbl->SetAntialiasMode(p, a)
#define ID2D1DeviceContext1_GetAntialiasMode(p, a) (p)->lpVtbl->GetAntialiasMode(p, a)
#define ID2D1DeviceContext1_SetTextAntialiasMode(p, a) (p)->lpVtbl->SetTextAntialiasMode(p, a)
#define ID2D1DeviceContext1_GetTextAntialiasMode(p, a) (p)->lpVtbl->GetTextAntialiasMode(p, a)
#define ID2D1DeviceContext1_SetTextRenderingParams(p, a) (p)->lpVtbl->SetTextRenderingParams(p, a)
#define ID2D1DeviceContext1_GetTextRenderingParams(p, a) (p)->lpVtbl->GetTextRenderingParams(p, a)
#define ID2D1DeviceContext1_SetTags(p, a, b) (p)->lpVtbl->SetTags(p, a, b)
#define ID2D1DeviceContext1_GetTags(p, a, b) (p)->lpVtbl->GetTags(p, a, b)
#define ID2D1DeviceContext1_PushLayer(p, a, b) (p)->lpVtbl->PushLayer(p, a, b)
#define ID2D1DeviceContext1_PopLayer(p, a) (p)->lpVtbl->PopLayer(p, a)
#define ID2D1DeviceContext1_Flush(p, a, b) (p)->lpVtbl->Flush(p, a, b)
#define ID2D1DeviceContext1_SaveDrawingState(p, a) (p)->lpVtbl->SaveDrawingState(p, a)
#define ID2D1DeviceContext1_RestoreDrawingState(p, a) (p)->lpVtbl->RestoreDrawingState(p, a)
#define ID2D1DeviceContext1_PushAxisAlignedClip(p, a, b) (p)->lpVtbl->PushAxisAlignedClip(p, a, b)
#define ID2D1DeviceContext1_PopAxisAlignedClip(p, a) (p)->lpVtbl->PopAxisAlignedClip(p, a)
#define ID2D1DeviceContext1_Clear(p, a) (p)->lpVtbl->Clear(p, a)
#define ID2D1DeviceContext1_BeginDraw(p, a) (p)->lpVtbl->BeginDraw(p, a)
#define ID2D1DeviceContext1_EndDraw(p, a, b) (p)->lpVtbl->EndDraw(p, a, b)
#define ID2D1DeviceContext1_GetPixelFormat(p, a) (p)->lpVtbl->GetPixelFormat(p, a)
#define ID2D1DeviceContext1_SetDpi(p, a, b) (p)->lpVtbl->SetDpi(p, a, b)
#define ID2D1DeviceContext1_GetDpi(p, a, b) (p)->lpVtbl->GetDpi(p, a, b)
#define ID2D1DeviceContext1_GetSize(p, a) (p)->lpVtbl->GetSize(p, a)
#define ID2D1DeviceContext1_GetPixelSize(p, a) (p)->lpVtbl->GetPixelSize(p, a)
#define ID2D1DeviceContext1_GetMaximumBitmapSize(p, a) (p)->lpVtbl->GetMaximumBitmapSize(p, a)
#define ID2D1DeviceContext1_IsSupported(p, a) (p)->lpVtbl->IsSupported(p, a)
#define ID2D1DeviceContext1_CreateBitmap1(p, a, b, c, d, e) (p)->lpVtbl->CreateBitmap1(p, a, b, c, d, e)
#define ID2D1DeviceContext1_CreateBitmapFromWicBitmap1(p, a, b, c) (p)->lpVtbl->CreateBitmapFromWicBitmap1(p, a, b, c)
#define ID2D1DeviceContext1_CreateColorContext(p, a, b, c, d) (p)->lpVtbl->CreateColorContext(p, a, b, c, d)
#define ID2D1DeviceContext1_CreateColorContextFromFilename(p, a, b) (p)->lpVtbl->CreateColorContextFromFilename(p, a, b)
#define ID2D1DeviceContext1_CreateColorContextFromWicColorContext(p, a, b) (p)->lpVtbl->CreateColorContextFromWicColorContext(p, a, b)
#define ID2D1DeviceContext1_CreateBitmapFromDxgiSurface(p, a, b, c) (p)->lpVtbl->CreateBitmapFromDxgiSurface(p, a, b, c)
#define ID2D1DeviceContext1_CreateEffect(p, a, b) (p)->lpVtbl->CreateEffect(p, a, b)
#define ID2D1DeviceContext1_CreateGradientStopCollection1(p, a, b, c, d, e, f, g, h) (p)->lpVtbl->CreateGradientStopCollection1(p, a, b, c, d, e, f, g, h)
#define ID2D1DeviceContext1_CreateImageBrush(p, a, b, c, d) (p)->lpVtbl->CreateImageBrush(p, a, b, c, d)
#define ID2D1DeviceContext1_CreateBitmapBrush1(p, a, b, c, d) (p)->lpVtbl->CreateBitmapBrush1(p, a, b, c, d)
#define ID2D1DeviceContext1_CreateCommandList(p, a) (p)->lpVtbl->CreateCommandList(p, a)
#define ID2D1DeviceContext1_IsDxgiFormatSupported(p, a) (p)->lpVtbl->IsDxgiFormatSupported(p, a)
#define ID2D1DeviceContext1_IsBufferPrecisionSupported(p, a) (p)->lpVtbl->IsBufferPrecisionSupported(p, a)
#define ID2D1DeviceContext1_GetImageLocalBounds(p, a, b) (p)->lpVtbl->GetImageLocalBounds(p, a, b)
#define ID2D1DeviceContext1_GetImageWorldBounds(p, a, b) (p)->lpVtbl->GetImageWorldBounds(p, a, b)
#define ID2D1DeviceContext1_GetGlyphRunWorldBounds(p, a, b, c, d) (p)->lpVtbl->GetGlyphRunWorldBounds(p, a, b, c, d)
#define ID2D1DeviceContext1_GetDevice(p, a) (p)->lpVtbl->GetDevice(p, a)
#define ID2D1DeviceContext1_SetTarget(p, a) (p)->lpVtbl->SetTarget(p, a)
#define ID2D1DeviceContext1_GetTarget(p, a) (p)->lpVtbl->GetTarget(p, a)
#define ID2D1DeviceContext1_SetRenderingControls(p, a) (p)->lpVtbl->SetRenderingControls(p, a)
#define ID2D1DeviceContext1_GetRenderingControls(p, a) (p)->lpVtbl->GetRenderingControls(p, a)
#define ID2D1DeviceContext1_SetPrimitiveBlend(p, a) (p)->lpVtbl->SetPrimitiveBlend(p, a)
#define ID2D1DeviceContext1_GetPrimitiveBlend(p, a) (p)->lpVtbl->GetPrimitiveBlend(p, a)
#define ID2D1DeviceContext1_SetUnitMode(p, a) (p)->lpVtbl->SetUnitMode(p, a)
#define ID2D1DeviceContext1_GetUnitMode(p, a) (p)->lpVtbl->GetUnitMode(p, a)
#define ID2D1DeviceContext1_DrawGlyphRun1(p, a, b, c, d, e) (p)->lpVtbl->DrawGlyphRun1(p, a, b, c, d, e)
#define ID2D1DeviceContext1_DrawImage(p, a, b, c, d, e) (p)->lpVtbl->DrawImage(p, a, b, c, d, e)
#define ID2D1DeviceContext1_DrawGdiMetafile(p, a, b) (p)->lpVtbl->DrawGdiMetafile(p, a, b)
#define ID2D1DeviceContext1_DrawBitmap1(p, a, b, c, d, e, f) (p)->lpVtbl->DrawBitmap1(p, a, b, c, d, e, f)
#define ID2D1DeviceContext1_InvalidateEffectInputRectangle(p, a, b, c) (p)->lpVtbl->InvalidateEffectInputRectangle(p, a, b, c)
#define ID2D1DeviceContext1_GetEffectInvalidRectangleCount(p, a, b) (p)->lpVtbl->GetEffectInvalidRectangleCount(p, a, b)
#define ID2D1DeviceContext1_GetEffectInvalidRectangles(p, a, b, c) (p)->lpVtbl->GetEffectInvalidRectangles(p, a, b, c)
#define ID2D1DeviceContext1_GetEffectRequiredInputRectangles(p, a, b, c, d, e) (p)->lpVtbl->GetEffectRequiredInputRectangles(p, a, b, c, d, e)
#define ID2D1DeviceContext1_FillOpacityMask1(p, a, b, c, d, e) (p)->lpVtbl->FillOpacityMask1(p, a, b, c, d, e)
#define ID2D1DeviceContext1_PushLayer1(p, a, b) (p)->lpVtbl->PushLayer1(p, a, b)
#define ID2D1DeviceContext1_CreateFilledGeometryRealization(p, a, b, c) (p)->lpVtbl->CreateFilledGeometryRealization(p, a, b, c)
#define ID2D1DeviceContext1_CreateStrokedGeometryRealization(p, a, b, c, d, e) (p)->lpVtbl->CreateStrokedGeometryRealization(p, a, b, c, d, e)
#define ID2D1DeviceContext1_DrawGeometryRealization(p, a, b) (p)->lpVtbl->DrawGeometryRealization(p, a, b)

' ============================================================================
' ID2D1Device1
' ============================================================================
Type ID2D1Device1Vtbl As ID2D1Device1Vtbl_
Type ID2D1Device1
    lpVtbl As ID2D1Device1Vtbl Ptr
End Type
Type ID2D1Device1Vtbl_     '' Extends ID2D1DeviceVtbl_
    QueryInterface As Function(ByVal This As ID2D1Device1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Device1 Ptr) As ULong
    Release As Function(ByVal This As ID2D1Device1 Ptr) As ULong
    GetFactory As Sub(ByVal This As ID2D1Device1 Ptr, ByVal factory As Any Ptr Ptr)
        ' 4: GetFactory
        ' 5. CreateDeviceContext
    CreateDeviceContext As Function(ByVal This As ID2D1Device1 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal context As Any Ptr Ptr ) As HRESULT
        ' 6. CreatePrintControl
    CreatePrintControl As Function(ByVal This As ID2D1Device1 Ptr,  ByVal wic_factory As Any Ptr, ByVal document_target As Any Ptr, ByVal desc As D2D1_PRINT_CONTROL_PROPERTIES Ptr, ByVal print_control As Any Ptr Ptr ) As HRESULT
        ' 7. SetMaximumTextureMemory
    SetMaximumTextureMemory As Sub(ByVal This As ID2D1Device1 Ptr,  ByVal max_texture_memory As ULongInt )
        ' 8. GetMaximumTextureMemory
    GetMaximumTextureMemory As Function(ByVal This As ID2D1Device1 Ptr) As ULongInt
        ' 9. ClearResources
    ClearResources As Function(ByVal This As ID2D1Device1 Ptr,  ByVal msec_since_use As ULong ) As HRESULT

        ' Erbt von ID2D1Device (1-10 Methoden)
        ' 11. GetRenderingPriority
    GetRenderingPriority As Function(ByVal This As ID2D1Device1 Ptr) As D2D1_RENDERING_PRIORITY
        ' 12. SetRenderingPriority
    SetRenderingPriority As Sub(ByVal This As ID2D1Device1 Ptr,  ByVal priority As D2D1_RENDERING_PRIORITY )
        ' 13. CreateDeviceContext
    CreateDeviceContext1 As Function(ByVal This As ID2D1Device1 Ptr,  ByVal options As D2D1_DEVICE_CONTEXT_OPTIONS, ByVal device_context As Any Ptr Ptr ) As HRESULT
End Type
#define ID2D1Device1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Device1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Device1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Device1_GetFactory(p, a) (p)->lpVtbl->GetFactory(p, a)
#define ID2D1Device1_CreateDeviceContext(p, a, b) (p)->lpVtbl->CreateDeviceContext(p, a, b)
#define ID2D1Device1_CreatePrintControl(p, a, b, c, d) (p)->lpVtbl->CreatePrintControl(p, a, b, c, d)
#define ID2D1Device1_SetMaximumTextureMemory(p, a) (p)->lpVtbl->SetMaximumTextureMemory(p, a)
#define ID2D1Device1_GetMaximumTextureMemory(p, a) (p)->lpVtbl->GetMaximumTextureMemory(p, a)
#define ID2D1Device1_ClearResources(p, a) (p)->lpVtbl->ClearResources(p, a)
#define ID2D1Device1_GetRenderingPriority(p, a) (p)->lpVtbl->GetRenderingPriority(p, a)
#define ID2D1Device1_SetRenderingPriority(p, a) (p)->lpVtbl->SetRenderingPriority(p, a)
#define ID2D1Device1_CreateDeviceContext1(p, a, b) (p)->lpVtbl->CreateDeviceContext1(p, a, b)

' ============================================================================
' ID2D1Factory2
' ============================================================================
Type ID2D1Factory2Vtbl As ID2D1Factory2Vtbl_
Type ID2D1Factory2
    lpVtbl As ID2D1Factory2Vtbl Ptr
End Type
Type ID2D1Factory2Vtbl_     '' Extends ID2D1Factory1Vtbl_
    QueryInterface As Function(ByVal This As ID2D1Factory2 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1Factory2 Ptr) As ULong
    Release As Function(ByVal This As ID2D1Factory2 Ptr) As ULong
        ' 2. AddRef
        ' 4.
    ReloadSystemMetrics As Function(ByVal This As ID2D1Factory2 Ptr) As HRESULT
    GetDesktopDpi As Sub(ByVal This As ID2D1Factory2 Ptr, ByVal dpiX As Single Ptr, ByVal dpiY As Single Ptr)
    CreateRectangleGeometry As Function(ByVal This As ID2D1Factory2 Ptr, ByVal rect As D2D1_RECT_F Ptr, ByVal geometry As ID2D1RectangleGeometry Ptr Ptr) As HRESULT
    CreateRoundedRectangleGeometry As Function(ByVal This As ID2D1Factory2 Ptr, ByVal rect As D2D1_ROUNDED_RECT Ptr, ByVal geometry As ID2D1RoundedRectangleGeometry Ptr Ptr) As HRESULT
    CreateEllipseGeometry As Function(ByVal This As ID2D1Factory2 Ptr, ByVal ellipse As D2D1_ELLIPSE Ptr, ByVal ID2D1EllipseGeometry As Any Ptr Ptr) As HRESULT
    CreateGeometryGroup As Function(ByVal This As ID2D1Factory2 Ptr, ByVal fill_mode As D2D1_FILL_MODE, ByVal geometries As ID2D1Geometry Ptr Ptr, ByVal geometryCount As ULong, ByVal group As ID2D1GeometryGroup Ptr Ptr) As HRESULT
    CreateTransformedGeometry As Function(ByVal This As ID2D1Factory2 Ptr, ByVal src_geometry As ID2D1Geometry Ptr, ByVal transform As D2D1_MATRIX_3X2_F Ptr, ByVal transformedGeometry As ID2D1TransformedGeometry Ptr Ptr) As HRESULT
    CreatePathGeometry As Function(ByVal This As ID2D1Factory2 Ptr, ByVal geometry As ID2D1PathGeometry Ptr Ptr) As HRESULT
    CreateStrokeStyle As Function(ByVal This As ID2D1Factory2 Ptr, ByVal styleProps As D2D1_STROKE_STYLE_PROPERTIES Ptr, ByVal dashes As Single Ptr, ByVal dashCount As ULong, ByVal strokeStyle As ID2D1StrokeStyle Ptr Ptr) As HRESULT
    CreateDrawingStateBlock As Function(ByVal This As ID2D1Factory2 Ptr, ByVal stateDesc As D2D1_DRAWING_STATE_DESCRIPTION Ptr, ByVal text_renderingParams As Any Ptr, ByVal stateBlock As IUnknownBase Ptr Ptr) As HRESULT ' ID2D1DrawingStateBlock
    CreateWicBitmapRenderTarget As Function(ByVal This As ID2D1Factory2 Ptr, ByVal target As Any Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1RenderTarget Ptr Ptr) As HRESULT
    CreateHwndRenderTarget As Function(ByVal This As ID2D1Factory2 Ptr, ByVal desc As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal targetProps As D2D1_HWND_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1HwndRenderTarget Ptr Ptr) As HRESULT
    CreateDxgiSurfaceRenderTarget As Function(ByVal This As ID2D1Factory2 Ptr, ByVal surface As Any Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1RenderTarget Ptr Ptr) As HRESULT
    CreateDCRenderTarget As Function(ByVal This As ID2D1Factory2 Ptr, ByVal targetProps As D2D1_RENDER_TARGET_PROPERTIES Ptr, ByVal renderTarget As ID2D1DCRenderTarget Ptr Ptr) As HRESULT
    	' Erbt von ID2D1Factory (1-17 Methoden)
    	' 18. CreateDevice
    CreateDevice As Function(ByVal This As ID2D1Factory2 Ptr,  ByVal dxgi_device As Any Ptr, ByVal device As ID2D1Device Ptr Ptr ) As HRESULT
    	' 19. CreateStrokeStyle (überladen)
    CreateStrokeStyle1 As Function(ByVal This As ID2D1Factory2 Ptr,  ByVal desc As D2D1_STROKE_STYLE_PROPERTIES1 Ptr, ByVal dashes As Single Ptr, ByVal dash_count As ULong, ByVal stroke_style As Any Ptr Ptr ) As HRESULT
    	' 20. CreatePathGeometry (überladen)
    CreatePathGeometry1 As Function(ByVal This As ID2D1Factory2 Ptr,  ByVal geometry As Any Ptr Ptr ) As HRESULT
    	' 21. CreateDrawingStateBlock (überladen)
    CreateDrawingStateBlock1 As Function(ByVal This As ID2D1Factory2 Ptr,  ByVal desc As D2D1_DRAWING_STATE_DESCRIPTION1 Ptr, ByVal text_rendering_params As Any Ptr, ByVal state_block As Any Ptr Ptr ) As HRESULT
    	' 22. CreateGdiMetafile
    CreateGdiMetafile As Function(ByVal This As ID2D1Factory2 Ptr,  ByVal stream As Any Ptr, ByVal metafile As Any Ptr Ptr ) As HRESULT
    	' 23. RegisterEffectFromStream
    RegisterEffectFromStream As Function(ByVal This As ID2D1Factory2 Ptr,  ByRef effect_id As GUID, ByVal property_xml As Any Ptr, ByVal bindings As Any Ptr, ByVal binding_count As ULong, ByVal effect_factory As PD2D1_EFFECT_FACTORY Ptr ) As HRESULT
    	' 24. RegisterEffectFromString
    RegisterEffectFromString As Function(ByVal This As ID2D1Factory2 Ptr,  ByVal effect_id As GUID, ByVal property_xml As WString Ptr, ByVal bindings As Any Ptr, ByVal binding_count As ULong, ByVal effect_factory As PD2D1_EFFECT_FACTORY Ptr ) As HRESULT
    	' 25. UnregisterEffect
    UnregisterEffect As Function(ByVal This As ID2D1Factory2 Ptr,  ByRef effect_id As GUID ) As HRESULT
    	' 26. GetRegisteredEffects
    GetRegisteredEffects As Function(ByVal This As ID2D1Factory2 Ptr,  ByVal effects As GUID Ptr, ByVal effect_count As ULong, ByVal returned As ULong Ptr, ByVal registered As ULong Ptr ) As HRESULT
    	' 27. GetEffectProperties
    GetEffectProperties As Function(ByVal This As ID2D1Factory2 Ptr,  ByRef effect_id As GUID, ByVal props As Any Ptr Ptr ) As HRESULT

        ' Erbt von ID2D1Factory1 (1-20 Methoden)
        ' 21. CreateDevice
    CreateDevice1 As Function(ByVal This As ID2D1Factory2 Ptr,  ByVal dxgi_device As Any Ptr, ByVal device As Any Ptr Ptr ) As HRESULT
End Type
#define ID2D1Factory2_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1Factory2_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1Factory2_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1Factory2_ReloadSystemMetrics(p, a) (p)->lpVtbl->ReloadSystemMetrics(p, a)
#define ID2D1Factory2_GetDesktopDpi(p, a, b) (p)->lpVtbl->GetDesktopDpi(p, a, b)
#define ID2D1Factory2_CreateRectangleGeometry(p, a, b) (p)->lpVtbl->CreateRectangleGeometry(p, a, b)
#define ID2D1Factory2_CreateRoundedRectangleGeometry(p, a, b) (p)->lpVtbl->CreateRoundedRectangleGeometry(p, a, b)
#define ID2D1Factory2_CreateEllipseGeometry(p, a, b) (p)->lpVtbl->CreateEllipseGeometry(p, a, b)
#define ID2D1Factory2_CreateGeometryGroup(p, a, b, c, d) (p)->lpVtbl->CreateGeometryGroup(p, a, b, c, d)
#define ID2D1Factory2_CreateTransformedGeometry(p, a, b, c) (p)->lpVtbl->CreateTransformedGeometry(p, a, b, c)
#define ID2D1Factory2_CreatePathGeometry(p, a) (p)->lpVtbl->CreatePathGeometry(p, a)
#define ID2D1Factory2_CreateStrokeStyle(p, a, b, c, d) (p)->lpVtbl->CreateStrokeStyle(p, a, b, c, d)
#define ID2D1Factory2_CreateDrawingStateBlock(p, a, b, c) (p)->lpVtbl->CreateDrawingStateBlock(p, a, b, c)
#define ID2D1Factory2_CreateWicBitmapRenderTarget(p, a, b, c) (p)->lpVtbl->CreateWicBitmapRenderTarget(p, a, b, c)
#define ID2D1Factory2_CreateHwndRenderTarget(p, a, b, c) (p)->lpVtbl->CreateHwndRenderTarget(p, a, b, c)
#define ID2D1Factory2_CreateDxgiSurfaceRenderTarget(p, a, b, c) (p)->lpVtbl->CreateDxgiSurfaceRenderTarget(p, a, b, c)
#define ID2D1Factory2_CreateDCRenderTarget(p, a, b) (p)->lpVtbl->CreateDCRenderTarget(p, a, b)
#define ID2D1Factory2_CreateDevice(p, a, b) (p)->lpVtbl->CreateDevice(p, a, b)
#define ID2D1Factory2_CreateStrokeStyle1(p, a, b, c, d) (p)->lpVtbl->CreateStrokeStyle1(p, a, b, c, d)
#define ID2D1Factory2_CreatePathGeometry1(p, a) (p)->lpVtbl->CreatePathGeometry1(p, a)
#define ID2D1Factory2_CreateDrawingStateBlock1(p, a, b, c) (p)->lpVtbl->CreateDrawingStateBlock1(p, a, b, c)
#define ID2D1Factory2_CreateGdiMetafile(p, a, b) (p)->lpVtbl->CreateGdiMetafile(p, a, b)
#define ID2D1Factory2_RegisterEffectFromStream(p, a, b, c, d, e) (p)->lpVtbl->RegisterEffectFromStream(p, a, b, c, d, e)
#define ID2D1Factory2_RegisterEffectFromString(p, a, b, c, d, e) (p)->lpVtbl->RegisterEffectFromString(p, a, b, c, d, e)
#define ID2D1Factory2_UnregisterEffect(p, a) (p)->lpVtbl->UnregisterEffect(p, a)
#define ID2D1Factory2_GetRegisteredEffects(p, a, b, c, d) (p)->lpVtbl->GetRegisteredEffects(p, a, b, c, d)
#define ID2D1Factory2_GetEffectProperties(p, a, b) (p)->lpVtbl->GetEffectProperties(p, a, b)
#define ID2D1Factory2_CreateDevice1(p, a, b) (p)->lpVtbl->CreateDevice1(p, a, b)

' ============================================================================
' ID2D1CommandSink1
' ============================================================================
Type ID2D1CommandSink1Vtbl As ID2D1CommandSink1Vtbl_
Type ID2D1CommandSink1
    lpVtbl As ID2D1CommandSink1Vtbl Ptr
End Type
Type ID2D1CommandSink1Vtbl_     '' Extends ID2D1CommandSinkVtbl_
    QueryInterface As Function(ByVal This As ID2D1CommandSink1 Ptr, ByVal riid As GUID Ptr, ByVal ppvObject As Any Ptr Ptr) As HRESULT
    AddRef As Function(ByVal This As ID2D1CommandSink1 Ptr) As ULong
    Release As Function(ByVal This As ID2D1CommandSink1 Ptr) As ULong
        
    BeginDraw As Function(ByVal This As ID2D1CommandSink1 Ptr) As HRESULT
        ' 5. EndDraw
    EndDraw As Function(ByVal This As ID2D1CommandSink1 Ptr) As HRESULT
        ' 6. SetAntialiasMode
    SetAntialiasMode As Function(ByVal This As ID2D1CommandSink1 Ptr,  ByVal antialias_mode As D2D1_ANTIALIAS_MODE ) As HRESULT
        ' 7. SetTags
    SetTags As Function(ByVal This As ID2D1CommandSink1 Ptr,  ByVal tag1 As D2D1_TAG, ByVal tag2 As D2D1_TAG ) As HRESULT
        ' 8. SetTextAntialiasMode
    SetTextAntialiasMode As Function(ByVal This As ID2D1CommandSink1 Ptr,  ByVal antialias_mode As D2D1_TEXT_ANTIALIAS_MODE ) As HRESULT
        ' 9. SetTextRenderingParams
    SetTextRenderingParams As Function(ByVal This As ID2D1CommandSink1 Ptr,  ByVal text_rendering_params As Any Ptr ) As HRESULT
        ' 10. SetTransform
    SetTransform As Function(ByVal This As ID2D1CommandSink1 Ptr,  ByVal transform As D2D1_MATRIX_3X2_F Ptr ) As HRESULT
        ' 11. SetPrimitiveBlend
    SetPrimitiveBlend As Function(ByVal This As ID2D1CommandSink1 Ptr,  ByVal primitive_blend As D2D1_PRIMITIVE_BLEND ) As HRESULT
        ' 12. SetUnitMode
    SetUnitMode As Function(ByVal This As ID2D1CommandSink1 Ptr,  ByVal unit_mode As D2D1_UNIT_MODE ) As HRESULT
        ' 13. Clear
    Clear As Function(ByVal This As ID2D1CommandSink1 Ptr,  ByVal color As D2D1_COLOR_F Ptr ) As HRESULT
        ' 14. DrawGlyphRun
    DrawGlyphRun As Function(ByVal This As ID2D1CommandSink1 Ptr,  ByVal baseline_origin As D2D1_POINT_2F, ByVal glyph_run As Any Ptr, ByVal glyph_run_desc As Any Ptr, ByVal brush As ID2D1Brush Ptr, ByVal measuring_mode As ULong ) As HRESULT
        ' 15. DrawLine
    DrawLine As Function(ByVal This As ID2D1CommandSink1 Ptr,  ByVal p0 As D2D1_POINT_2F, ByVal p1 As D2D1_POINT_2F, ByVal brush As ID2D1Brush Ptr, ByVal stroke_width As Single, ByVal stroke_style As ID2D1StrokeStyle Ptr ) As HRESULT
        ' 16. DrawGeometry
    DrawGeometry As Function(ByVal This As ID2D1CommandSink1 Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal stroke_width As Single, ByVal stroke_style As ID2D1StrokeStyle Ptr ) As HRESULT
        ' 17. DrawRectangle
    DrawRectangle As Function(ByVal This As ID2D1CommandSink1 Ptr,  ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr, ByVal stroke_width As Single, ByVal stroke_style As ID2D1StrokeStyle Ptr ) As HRESULT
        ' 18. DrawBitmap
    DrawBitmap As Function(ByVal This As ID2D1CommandSink1 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal opacity As Single, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE, ByVal src_rect As D2D1_RECT_F Ptr, ByVal perspective_transform As D2D1_MATRIX_4X4_F Ptr ) As HRESULT
        ' 19. DrawImage
    DrawImage As Function(ByVal This As ID2D1CommandSink1 Ptr,  ByVal image As ID2D1Image Ptr, ByVal target_offset As D2D1_POINT_2F Ptr, ByVal image_rect As D2D1_RECT_F Ptr, ByVal interpolation_mode As D2D1_INTERPOLATION_MODE, ByVal composite_mode As D2D1_COMPOSITE_MODE ) As HRESULT
        ' 20. DrawGdiMetafile
    DrawGdiMetafile As Function(ByVal This As ID2D1CommandSink1 Ptr,  ByVal metafile As ID2D1GdiMetafile Ptr, ByVal target_offset As D2D1_POINT_2F Ptr ) As HRESULT
        ' 21. FillMesh
    FillMesh As Function(ByVal This As ID2D1CommandSink1 Ptr,  ByVal mesh As ID2D1Mesh Ptr, ByVal brush As ID2D1Brush Ptr ) As HRESULT
        ' 22. FillOpacityMask
    FillOpacityMask As Function(ByVal This As ID2D1CommandSink1 Ptr,  ByVal bitmap As ID2D1Bitmap Ptr, ByVal brush As ID2D1Brush Ptr, ByVal dst_rect As D2D1_RECT_F Ptr, ByVal src_rect As D2D1_RECT_F Ptr ) As HRESULT
        ' 23. FillGeometry
    FillGeometry As Function(ByVal This As ID2D1CommandSink1 Ptr,  ByVal geometry As ID2D1Geometry Ptr, ByVal brush As ID2D1Brush Ptr, ByVal opacity_brush As ID2D1Brush Ptr ) As HRESULT
        ' 24. FillRectangle
    FillRectangle As Function(ByVal This As ID2D1CommandSink1 Ptr,  ByVal rect As D2D1_RECT_F Ptr, ByVal brush As ID2D1Brush Ptr ) As HRESULT
        ' 25. PushAxisAlignedClip
    PushAxisAlignedClip As Function(ByVal This As ID2D1CommandSink1 Ptr,  ByVal clip_rect As D2D1_RECT_F Ptr, ByVal antialias_mode As D2D1_ANTIALIAS_MODE ) As HRESULT
        ' 26. PushLayer
    PushLayer As Function(ByVal This As ID2D1CommandSink1 Ptr,  ByVal layer_parameters As D2D1_LAYER_PARAMETERS1 Ptr, ByVal layer As ID2D1Layer Ptr ) As HRESULT
        ' 27. PopAxisAlignedClip
    PopAxisAlignedClip As Function(ByVal This As ID2D1CommandSink1 Ptr) As HRESULT
        ' 28. PopLayer
    PopLayer As Function(ByVal This As ID2D1CommandSink1 Ptr) As HRESULT

        ' Erbt von ID2D1CommandSink
        ' Zusätzliche Methode
    SetPrimitiveBlend1 As Function(ByVal This As ID2D1CommandSink1 Ptr,  ByVal primitive_blend As D2D1_PRIMITIVE_BLEND ) As HRESULT
End Type
#define ID2D1CommandSink1_QueryInterface(p, a, b) (p)->lpVtbl->QueryInterface(p, a, b)
#define ID2D1CommandSink1_AddRef(p, a) (p)->lpVtbl->AddRef(p, a)
#define ID2D1CommandSink1_Release(p, a) (p)->lpVtbl->Release(p, a)
#define ID2D1CommandSink1_BeginDraw(p, a) (p)->lpVtbl->BeginDraw(p, a)
#define ID2D1CommandSink1_EndDraw(p, a) (p)->lpVtbl->EndDraw(p, a)
#define ID2D1CommandSink1_SetAntialiasMode(p, a) (p)->lpVtbl->SetAntialiasMode(p, a)
#define ID2D1CommandSink1_SetTags(p, a, b) (p)->lpVtbl->SetTags(p, a, b)
#define ID2D1CommandSink1_SetTextAntialiasMode(p, a) (p)->lpVtbl->SetTextAntialiasMode(p, a)
#define ID2D1CommandSink1_SetTextRenderingParams(p, a) (p)->lpVtbl->SetTextRenderingParams(p, a)
#define ID2D1CommandSink1_SetTransform(p, a) (p)->lpVtbl->SetTransform(p, a)
#define ID2D1CommandSink1_SetPrimitiveBlend(p, a) (p)->lpVtbl->SetPrimitiveBlend(p, a)
#define ID2D1CommandSink1_SetUnitMode(p, a) (p)->lpVtbl->SetUnitMode(p, a)
#define ID2D1CommandSink1_Clear(p, a) (p)->lpVtbl->Clear(p, a)
#define ID2D1CommandSink1_DrawGlyphRun(p, a, b, c, d, e) (p)->lpVtbl->DrawGlyphRun(p, a, b, c, d, e)
#define ID2D1CommandSink1_DrawLine(p, a, b, c, d, e) (p)->lpVtbl->DrawLine(p, a, b, c, d, e)
#define ID2D1CommandSink1_DrawGeometry(p, a, b, c, d) (p)->lpVtbl->DrawGeometry(p, a, b, c, d)
#define ID2D1CommandSink1_DrawRectangle(p, a, b, c, d) (p)->lpVtbl->DrawRectangle(p, a, b, c, d)
#define ID2D1CommandSink1_DrawBitmap(p, a, b, c, d, e, f) (p)->lpVtbl->DrawBitmap(p, a, b, c, d, e, f)
#define ID2D1CommandSink1_DrawImage(p, a, b, c, d, e) (p)->lpVtbl->DrawImage(p, a, b, c, d, e)
#define ID2D1CommandSink1_DrawGdiMetafile(p, a, b) (p)->lpVtbl->DrawGdiMetafile(p, a, b)
#define ID2D1CommandSink1_FillMesh(p, a, b) (p)->lpVtbl->FillMesh(p, a, b)
#define ID2D1CommandSink1_FillOpacityMask(p, a, b, c, d) (p)->lpVtbl->FillOpacityMask(p, a, b, c, d)
#define ID2D1CommandSink1_FillGeometry(p, a, b, c) (p)->lpVtbl->FillGeometry(p, a, b, c)
#define ID2D1CommandSink1_FillRectangle(p, a, b) (p)->lpVtbl->FillRectangle(p, a, b)
#define ID2D1CommandSink1_PushAxisAlignedClip(p, a, b) (p)->lpVtbl->PushAxisAlignedClip(p, a, b)
#define ID2D1CommandSink1_PushLayer(p, a, b) (p)->lpVtbl->PushLayer(p, a, b)
#define ID2D1CommandSink1_PopAxisAlignedClip(p, a) (p)->lpVtbl->PopAxisAlignedClip(p, a)
#define ID2D1CommandSink1_PopLayer(p, a) (p)->lpVtbl->PopLayer(p, a)
#define ID2D1CommandSink1_SetPrimitiveBlend1(p, a) (p)->lpVtbl->SetPrimitiveBlend1(p, a)

' ============================================================================
' Functions
' ============================================================================
Declare Function D2D1ComputeMaximumScaleFactor Lib "d2d1" ( ByVal matrix As D2D1_MATRIX_3X2_F Ptr ) As Single
