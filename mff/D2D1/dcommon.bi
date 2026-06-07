' Based on the C header files Wine project:
' Copyright (C) the Wine project
' Ported to FB by UEZ
' Build 2026-01-04 beta

#pragma once

' ---------------------------------------------------------------------------
' DCommon (Übersetzt aus dcommon.idl)
' ---------------------------------------------------------------------------
#include once "dxgicommon.bi"

#ifndef __DCOMMON_BI
#define __DCOMMON_BI

' Grundlegende Typdefinitionen
#ifndef UINT32
Type UINT32 As ULong
#endif

' Messmodi für Text (DirectWrite)
Enum DWRITE_MEASURING_MODE
    DWRITE_MEASURING_MODE_NATURAL
    DWRITE_MEASURING_MODE_GDI_CLASSIC
    DWRITE_MEASURING_MODE_GDI_NATURAL
    DWRITE_MEASURING_MODE_FORCE_DWORD = &hFFFFFFFF
End Enum

' Formate für Glyphen-Bilder
Enum DWRITE_GLYPH_IMAGE_FORMATS
    DWRITE_GLYPH_IMAGE_FORMATS_NONE                   = 0
    DWRITE_GLYPH_IMAGE_FORMATS_TRUETYPE               = 1 Shl 0
    DWRITE_GLYPH_IMAGE_FORMATS_CFF                    = 1 Shl 1
    DWRITE_GLYPH_IMAGE_FORMATS_COLR                   = 1 Shl 2
    DWRITE_GLYPH_IMAGE_FORMATS_SVG                    = 1 Shl 3
    DWRITE_GLYPH_IMAGE_FORMATS_PNG                    = 1 Shl 4
    DWRITE_GLYPH_IMAGE_FORMATS_JPEG                   = 1 Shl 5
    DWRITE_GLYPH_IMAGE_FORMATS_TIFF                   = 1 Shl 6
    DWRITE_GLYPH_IMAGE_FORMATS_PREMULTIPLIED_B8G8R8A8 = 1 Shl 7
    DWRITE_MEASURING_MODE_FORCE_DWORD = &hFFFFFFFF
End Enum

' D2D1_ALPHA_MODE documentation at https://learn.microsoft.com/windows/win32/api/dcommon/ne-dcommon-d2d1_alpha_mode
Enum ' D2D1_ALPHA_MODE
    D2D1_ALPHA_MODE_UNKNOWN = 0,
    D2D1_ALPHA_MODE_PREMULTIPLIED = 1,
    D2D1_ALPHA_MODE_STRAIGHT = 2,
    D2D1_ALPHA_MODE_IGNORE = 3
End Enum ' D2D1_ALPHA_MODE
Type D2D1_ALPHA_MODE As ULong

' D2D1_TURBULENCE_NOISE documentation at https://learn.microsoft.com/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_turbulence_noise
Enum ' D2D1_TURBULENCE_NOISE
    D2D1_TURBULENCE_NOISE_FRACTAL_SUM = 0,
    D2D1_TURBULENCE_NOISE_TURBULENCE = 1
End Enum ' D2D1_TURBULENCE_NOISE
Type D2D1_TURBULENCE_NOISE As ULong

' D2D1_ANTIALIAS_MODE documentation at https://learn.microsoft.com/windows/win32/api/d2d1/ne-d2d1-d2d1_antialias_mode
Enum ' D2D1_ANTIALIAS_MODE
    D2D1_ANTIALIAS_MODE_PER_PRIMITIVE = 0,
    D2D1_ANTIALIAS_MODE_ALIASED = 1
End Enum ' D2D1_ANTIALIAS_MODE
Type D2D1_ANTIALIAS_MODE As ULong

' D2D1_EXTEND_MODE documentation at https://learn.microsoft.com/windows/win32/api/d2d1/ne-d2d1-d2d1_extend_mode
Enum ' D2D1_EXTEND_MODE
    D2D1_EXTEND_MODE_CLAMP = 0,
    D2D1_EXTEND_MODE_WRAP = 1,
    D2D1_EXTEND_MODE_MIRROR = 2
End Enum ' D2D1_EXTEND_MODE
Type D2D1_EXTEND_MODE As ULong

' D2D1_TEXT_ANTIALIAS_MODE documentation at https://learn.microsoft.com/windows/win32/api/d2d1/ne-d2d1-d2d1_text_antialias_mode
Enum ' D2D1_TEXT_ANTIALIAS_MODE
    D2D1_TEXT_ANTIALIAS_MODE_DEFAULT = 0,
    D2D1_TEXT_ANTIALIAS_MODE_CLEARTYPE = 1,
    D2D1_TEXT_ANTIALIAS_MODE_GRAYSCALE = 2,
    D2D1_TEXT_ANTIALIAS_MODE_ALIASED = 3
End Enum ' D2D1_TEXT_ANTIALIAS_MODE
Type D2D1_TEXT_ANTIALIAS_MODE As ULong

' Pixel-Format Struktur
Type D2D1_PIXEL_FORMAT
    format    As DXGI_FORMAT
    alphaMode As D2D1_ALPHA_MODE
End Type

' Rechteck-Strukturen
Type D2D_RECT_F
    left   As Single
    top    As Single
    right  As Single
    bottom As Single
End Type

' Größen-Strukturen
Type D2D1_SIZE_U
    width  As UINT32
    height As UINT32
End Type

' D2D1_COLOR_F documentation at https://learn.microsoft.com/windows/win32/Direct2D/d2d-color-f
Type D2D1_COLOR_F 
    r As Single
    g As Single
    b As Single
    a As Single
End Type

' D2D1_POINT_2U documentation at https://learn.microsoft.com/windows/win32/api/dcommon/ns-dcommon-d2d_point_2u
Type D2D1_POINT_2U 
    x As ULong
    y As ULong
End Type

' D2D1_POINT_2F documentation at https://learn.microsoft.com/windows/win32/api/dcommon/ns-dcommon-d2d_point_2f
Type D2D1_POINT_2F 
    x As Single
    y As Single
End Type

Type D2D1_POINT_2L
    x As Long
    y As Long
End Type

' D2D_VECTOR_2F documentation at https://learn.microsoft.com/windows/win32/api/dcommon/ns-dcommon-d2d_vector_2f
Type D2D1_VECTOR_2F 
    x As Single
    y As Single
End Type

' D2D1_VECTOR_3F documentation at https://learn.microsoft.com/windows/win32/api/dcommon/ns-dcommon-d2d_vector_3f
Type D2D1_VECTOR_3F 
    x As Single
    y As Single
    z As Single
End Type

' D2D1_VECTOR_4F documentation at https://learn.microsoft.com/windows/win32/api/dcommon/ns-dcommon-d2d_vector_4f
Type D2D1_VECTOR_4F 
    x As Single
    y As Single
    z As Single
    w As Single
End Type

' D2D1_RECT_U documentation at https://learn.microsoft.com/windows/win32/api/dcommon/ns-dcommon-d2d_rect_u
Type D2D1_RECT_U 
    left As ULong
    top As ULong
    right As ULong
    bottom As ULong
End Type

' D2D1_SIZE_F documentation at https://learn.microsoft.com/windows/win32/api/dcommon/ns-dcommon-d2d_size_f
Type D2D1_SIZE_F 
    width As Single
    height As Single
End Type

Type D2D1_RECT_F 
    left As Single
    top As Single
    right As Single
    bottom As Single
End Type

Type D2D1_RECT_L
    As Long left
    As Long top
    As Long right
    As Long bottom
End Type

' Matrix 3x2 (Standard für Transformationen)
Union D2D1_MATRIX_3X2_F
    Type
        m11 As Single
        m12 As Single
        m21 As Single
        m22 As Single
        dx  As Single
        dy  As Single
    End Type
    Type
        _11 As Single
        _12 As Single
        _21 As Single
        _22 As Single
        _31 As Single
        _32 As Single
    End Type
    m(0 To 2, 0 To 1) As Single
End Union

' Matrix 4x3
Union D2D1_MATRIX_4X3_F
    Type
        _11 As Single
        _12 As Single
        _13 As Single
        _21 As Single
        _22 As Single
        _23 As Single
        _31 As Single
        _32 As Single
        _33 As Single
        _41 As Single
        _42 As Single
        _43 As Single
    End Type
    m(0 To 3, 0 To 2) As Single
End Union

' Matrix 4x4
Union D2D1_MATRIX_4X4_F
    Type
        _11 As Single
        _12 As Single
        _13 As Single
        _14 As Single
        _21 As Single
        _22 As Single
        _23 As Single
        _24 As Single
        _31 As Single
        _32 As Single
        _33 As Single
        _34 As Single
        _41 As Single
        _42 As Single
        _43 As Single
        _44 As Single
    End Type
    m(0 To 3, 0 To 3) As Single
End Union

' D2D_MATRIX_5X4_F documentation at https://learn.microsoft.com/windows/win32/api/dcommon/ns-dcommon-d2d_matrix_5x4_f
Type D2D1_MATRIX_5X4_F 
    Union 
        Type 
            _11 As Single
            _12 As Single
            _13 As Single
            _14 As Single
            _21 As Single
            _22 As Single
            _23 As Single
            _24 As Single
            _31 As Single
            _32 As Single
            _33 As Single
            _34 As Single
            _41 As Single
            _42 As Single
            _43 As Single
            _44 As Single
            _51 As Single
            _52 As Single
            _53 As Single
            _54 As Single
        End Type
        m(0 To 4, 0 To 3) As Single
    End Union
End Type

#endif