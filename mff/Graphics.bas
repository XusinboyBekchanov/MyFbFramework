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

#Include Once "Graphics.bi"

	Function ColorToRGB(FColor As Integer) As Integer
		If FColor < 0 then
	    #IFDef __USE_GTK__
			Return FColor
	    #Else
			Return GetSysColor(FColor And &H000000FF)
	    #EndIf 
	    Else
			Return FColor
	    End If  
	End Function

	Function GetRed(FColor As Long) As Byte
		Return CUInt(FColor) And 255
	End Function

	Function GetGreen(FColor As Long) As Byte
		Return CUInt(FColor) shr 8 And 255
	End Function

	Function GetBlue(FColor As Long) As Byte
		'Return CUInt(FColor) And 255
		Return CUInt(FColor) Shr 16 And 255
	End Function
'End Namespace
