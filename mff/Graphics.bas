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

	Private Function ShiftColor(ByVal clrFirst As Long, ByVal clrSecond As Long, ByVal lAlpha As Long) As Long
		Dim lShiftColor As Long
		#ifdef __USE_GTK__
			Dim clrFore(3)         As ULong = {GetRed(clrFirst), GetGreen(clrFirst), GetBlue(clrFirst)}
			Dim clrBack(3)         As ULong = {GetRed(clrSecond), GetGreen(clrSecond), GetBlue(clrSecond)}
			
			clrFore(0) = (clrFore(0) * lAlpha + clrBack(0) * (255 - lAlpha)) / 255
			clrFore(1) = (clrFore(1) * lAlpha + clrBack(1) * (255 - lAlpha)) / 255
			clrFore(2) = (clrFore(2) * lAlpha + clrBack(2) * (255 - lAlpha)) / 255
			
			lShiftColor = RGB(clrFore(0), clrFore(1), clrFore(2))
			lShiftColor = (Cast(ULong, 100 / 100 * 255) Shl 24) + (Cast(ULong, GetRed(lShiftColor)) Shl 16) + (Cast(ULong, GetGreen(lShiftColor)) Shl 8) + (Cast(ULong, GetBlue(lShiftColor)))
		#elseif defined(__USE_WINAPI__)
			Dim clrFore(3)         As COLORREF
			Dim clrBack(3)         As COLORREF
			
			OleTranslateColor clrFirst, 0, VarPtr(clrFore(0))
			OleTranslateColor clrSecond, 0, VarPtr(clrBack(0))
			
			clrFore(0) = (clrFore(0) * lAlpha + clrBack(0) * (255 - lAlpha)) / 255
			clrFore(1) = (clrFore(1) * lAlpha + clrBack(1) * (255 - lAlpha)) / 255
			clrFore(2) = (clrFore(2) * lAlpha + clrBack(2) * (255 - lAlpha)) / 255
			
			memcpy @lShiftColor, VarPtr(clrFore(0)), 4
		#endif
		
		Return lShiftColor
		
	End Function
	
	Private Function IsDarkColor(lColor As Long) As Boolean
		Dim bBGRA(0 To 3) As Byte
		#ifdef __USE_WINAPI__
			OleTranslateColor lColor, 0, VarPtr(lColor)
			CopyMemory(@bBGRA(0), @lColor, 4&)
		#endif
		
		IsDarkColor = ((CLng(bBGRA(0)) + (CLng(bBGRA(1) * 3)) + CLng(bBGRA(2))) / 2) < 382
	End Function
	

Public Function RGBtoARGB(ByVal RGBColor As ULong, ByVal Opacity As Long) As ULong
	#ifdef __USE_GTK__
		Return ShiftColor(RGBColor, clWhite, Opacity / 100 * 255)
		'Return ((Cast(ULong, Opacity / 100 * 255) Shl 24) + (Cast(ULong, Abs(GetRed(RGBColor))) Shl 16) + (Cast(ULong, Abs(GetGreen(RGBColor))) Shl 8) + (Cast(ULong, Abs(GetBlue(RGBColor)))))
	#elseif defined(__USE_WINAPI__)
		Return ((Cast(DWORD, Opacity / 100 * 255) Shl 24) + (Cast(DWORD, GetRed(RGBColor)) Shl 16) + (Cast(DWORD, GetGreen(RGBColor)) Shl 8) + Cast(DWORD, GetBlue(RGBColor)))
	#endif
	'Return Color_MakeARGB(Opacity / 100 * 255, GetRed(RGBColor), GetGreen(RGBColor), GetBlue(RGBColor))
	Return 0
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
