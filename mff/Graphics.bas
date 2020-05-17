'###############################################################################
'#  Graphics.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TGraphics.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "Graphics.bi"

Function ColorToRGB(FColor As Integer) As Integer
	If FColor < 0 Then
		#ifdef __USE_GTK__
			Return FColor
		#else
			Return GetSysColor(FColor And &H000000FF)
		#endif
	Else
		Return FColor
	End If
End Function

Function GetRed(FColor As Long) As Integer
	Return CUInt(FColor) And 255
End Function

Function GetGreen(FColor As Long) As Integer
	Return CUInt(FColor) Shr 8 And 255
End Function

Function GetBlue(FColor As Long) As Integer
	Return CUInt(FColor) Shr 16 And 255
End Function
'End Namespace
