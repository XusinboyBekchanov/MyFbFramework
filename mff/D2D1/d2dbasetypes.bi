' Based on the C header files Wine project:
' Copyright (C) the Wine project
' Ported to FB by UEZ
' Build 2026-01-04 beta

#pragma once

' ---------------------------------------------------------------------------
' D2D Base Types (Übersetzt aus d2dbasetypes.h)
' ---------------------------------------------------------------------------

#ifndef _D2DBASETYPES_BI
#define _D2DBASETYPES_BI

#ifndef D3DCOLORVALUE_DEFINED
Type D3DCOLORVALUE
    r As Single
    g As Single
    b As Single
    a As Single
End Type
#define D3DCOLORVALUE_DEFINED
#endif

#endif ' _D2DBASETYPES_BI