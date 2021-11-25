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
'#ifdef __FB_WIN32__
'	#include once "win/wingdi.bi"
'#endif
#include once "Graphics.bi"

Private Function ColorToRGB(FColor As Integer) As Integer
	If FColor < 0 Then
		#ifdef __USE_GTK__
			Return FColor
		#elseif defined(__USE_WINAPI__)
			Return GetSysColor(FColor And &H000000FF)
		#endif
	Else
		Return FColor
	End If
End Function

Private Function RGBAToBGR(FColor As UInteger) As Integer
	#ifdef __USE_GTK__
		Return BGR(GetRed(FColor), GetGreen(FColor), GetBlue(FColor))
	#else
		Return BGR(GetBlue(FColor), GetGreen(FColor), GetRed(FColor))
	#endif
End Function

Private Function BGRToRGBA(FColor As UInteger) As UInteger
	#ifdef __USE_GTK__
		Return RGBA(GetRed(FColor), GetGreen(FColor), GetBlue(FColor), 255)
	#else
		Return RGBA(GetBlue(FColor), GetGreen(FColor), GetRed(FColor), 255)
	#endif
End Function

Private Function GetRed(FColor As Long) As Integer
	Return CUInt(FColor) And 255
End Function

Private Function GetGreen(FColor As Long) As Integer
	Return CUInt(FColor) Shr 8 And 255
End Function

Private Function GetBlue(FColor As Long) As Integer
	Return CUInt(FColor) Shr 16 And 255
End Function

Private Function GetRedD(FColor As Long) As Double
	Return Abs(CUInt(FColor) And 255) / 255.0
End Function

Private Function GetGreenD(FColor As Long) As Double
	Return Abs(CUInt(FColor) Shr 8 And 255) / 255.0
End Function

Private Function GetBlueD(FColor As Long) As Double
	Return Abs(CUInt(FColor) Shr 16 And 255) / 255.0
End Function
'End Namespace
