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

#Include Once "Object.bi"

Namespace My.Sys.Drawing
	#IFDef __USE_GTK__
		Enum PenStyle
			psSolid
			psDash
			psDot
			psDashDot
			psDashDotDot
			psClear
			psInsideFrame
		End Enum
		
		Enum PenMode
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
	#Else
		Enum PenStyle
			psSolid       = PS_SOLID
			psDash        = PS_DASH
			psDot         = PS_DOT
			psDashDot     = PS_DASHDOT
			psDashDotDot  = PS_DASHDOTDOT
			psClear       = PS_NULL
			psInsideFrame = PS_INSIDEFRAME
		End Enum
		
		Enum PenMode
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
	#EndIf
	
	Type Pen Extends My.Sys.Object
	private:
		FColor  As Integer
		FStyle  As PenStyle
		FMode   As PenMode
		FSize   As Integer
		Declare Sub Create
	public:
		#IFNDef __USE_GTK__
			Handle  As HPEN
		#EndIf
		Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Declare Property Color As Integer
		Declare Property Color(Value As Integer)
		Declare Property Style As Integer 'PenStyle
		Declare Property Style(Value As Integer)
		Declare Property Mode As Integer 'PenMode
		Declare Property Mode(Value As Integer)
		Declare Property Size As Integer
		Declare Property Size(Value As Integer)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#IfNDef __USE_MAKE__
	#Include Once "Pen.bas"
#EndIf
