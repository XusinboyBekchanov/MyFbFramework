'###############################################################################
' This file is part of MyFBFramework
' Authors: UEZ, Xusinboy Bekchanov, Liu XiaLin
' Based on UEZ's abstract version.
' Direct2D 1.2 API - FreeBASIC Translation
' Adapted by Xusinboy Bekchanov, Liu XiaLin
'###############################################################################
#pragma once
' ---------------------------------------------------------------------------
' D2D Base Types (from d2dbasetypes.h)
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
