'################################################################################
'#  VisualStyles.bi                                                             #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov, Liu XiaLin                                     #
'#  Converted from: VisualStyles.bas of VBFLXGRD18 (VB FlexGrid Control 1.8)    #
'#  https://github.com/Kr00l/VBFLXGRD                                           #  
'################################################################################

#pragma once

#include once "Object.bi"
'#include once "win\uxtheme.bi"

Namespace My.Sys.Forms
	Declare Function FlexActivateVisualStyles(ByVal hWnd As HWND) As Long
	Declare Function FlexRemoveVisualStyles(ByVal hWnd As HWND) As Long
	Declare Function EnabledVisualStyles() As Boolean
	Declare Function GetComCtlVersion() As Long
End Namespace

#ifndef __USE_MAKE__
	#include once "VisualStyles.bas"
#endif
