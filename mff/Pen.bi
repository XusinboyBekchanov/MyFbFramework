'###############################################################################
'#  Pen.bi                                                                     #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TPen.bi                                                                   #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Modified by Xusinboy Bekchanov (2018-2019)                                 #
'###############################################################################

#include once "Object.bi"

Namespace My.Sys.Drawing
	#ifdef __USE_WINAPI__
		Private Enum PenStyle
			psSolid       = PS_SOLID
			psDash        = PS_DASH
			psDot         = PS_DOT
			psDashDot     = PS_DASHDOT
			psDashDotDot  = PS_DASHDOTDOT
			psClear       = PS_NULL
			psInsideFrame = PS_INSIDEFRAME
		End Enum
		
		Private Enum PenMode
			pmBlack       = R2_BLACK
			pmWhite       = R2_WHITE
			pmNop         = R2_NOP
			pmNot         = R2_NOT
			pmCopy        = R2_COPYPEN
			pmNotCopy     = R2_NOTCOPYPEN
			pmMergePenNot = R2_MERGEPENNOT
			pmMaskPenNot  = R2_MASKPENNOT
			pmMergeNotPen = R2_MERGENOTPEN
			pmMaskNotPen  = R2_MASKNOTPEN
			pmMerge       = R2_MERGEPEN
			pmNotMerge    = R2_NOTMERGEPEN
			pmMask        = R2_MASKPEN
			pmNotMask     = R2_NOTMASKPEN
			pmXor         = R2_XORPEN
			pmNotXor      = R2_NOTXORPEN
		End Enum
	#else
		Private Enum PenStyle
			psSolid
			psDash
			psDot
			psDashDot
			psDashDotDot
			psClear
			psInsideFrame
		End Enum
		
		Private Enum PenMode
			pmBlack
			pmWhite
			pmNop
			pmNot
			pmCopy
			pmNotCopy
			pmMergePenNot
			pmMaskPenNot
			pmMergeNotPen
			pmMaskNotPen
			pmMerge
			pmNotMerge
			pmMask
			pmNotMask
			pmXor
			pmNotXor
		End Enum
	#endif
	
	'Defines an object used to draw lines and curves (Windows only).
	Private Type Pen Extends My.Sys.Object
	Private:
		FColor  As Integer
		FStyle  As PenStyle
		FMode   As PenMode
		FSize   As Integer
		Declare Sub Create
	Public:
		#ifdef __USE_WINAPI__
			Handle  As HPEN
		#endif
		Parent As My.Sys.Object Ptr
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property Color As ULong
		Declare Property Color(Value As ULong)
		Declare Property Style As PenStyle
		Declare Property Style(Value As PenStyle)
		Declare Property Mode As PenMode
		Declare Property Mode(Value As PenMode)
		Declare Property Size As Integer
		Declare Property Size(Value As Integer)
		Declare Operator Cast As Any Ptr
		OnCreate As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Pen)
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "Pen.bas"
#endif
