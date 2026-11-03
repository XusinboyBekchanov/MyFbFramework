'################################################################################
'#  GridDataExBase.bi                                                             #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                      #
'#  Converted from: VBFlexGridBase.bas of VBFLXGRD18 (VB GridDataEx Control 1.8)  #
'#  https://github.com/Kr00l/VBFLXGRD                                           #  
'#  Window class registration, splitter hatch brush and ReaderMode support.     #
'#  In the VB6 original this module also hosted the COM subclassing helpers     #
'#  (FlexObjSetAddRef & friends); in FreeBASIC the control object pointer is    #
'#  stored directly in the window extra bytes / GWLP_USERDATA instead, so       #
'#  those msvbvm60 helpers are not needed anymore.                              #
'################################################################################

#pragma once

#include once "Object.bi"

Namespace My.Sys.Forms
	Declare Sub FlexInitCC(ByVal ICC As Long)
	Declare Sub FlexWndRegisterClass()
	Declare Sub FlexWndReleaseClass()
	Declare Function FlexGetSplitterBrush() As HANDLE
	Declare Function FlexGetDragCursor(ByVal IDC As Long) As HANDLE
	Declare Function FlexWindowProc(ByVal hWnd As HWND, ByVal wMsg As UINT, ByVal wParam As WPARAM, ByVal lParam As LPARAM) As LRESULT
End Namespace

#ifndef __USE_MAKE__
	#include once "GridDataExBase.bas"
#endif
