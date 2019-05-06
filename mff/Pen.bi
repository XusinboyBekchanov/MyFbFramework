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

    Function Pen.ReadProperty(ByRef PropertyName As String) As Any Ptr
        Select Case LCase(PropertyName)
        Case "color": Return @FColor
        Case "style": Return @FStyle
        Case "mode": Return @FMode
        Case "size": Return @FSize
        Case Else: Return Base.ReadProperty(PropertyName)
        End Select
        Return 0
    End Function
    
    Function Pen.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
        Select Case LCase(PropertyName)
        Case "color": This.Color = QInteger(Value)
        Case "style": This.Style = QInteger(Value)
        Case "mode": This.Mode = QInteger(Value)
        Case "size": This.Size = QInteger(Value)
        Case Else: Return Base.WriteProperty(PropertyName, Value)
        End Select
        Return True
    End Function
    
    Property Pen.Color As Integer
        Return FColor
    End Property

    Property Pen.Color(Value As Integer)
        FColor = Value
        Create
    End Property

    Property Pen.Style As Integer
        Return FStyle
    End Property

    Property Pen.Style(Value As Integer)
        FStyle = Value
        Create
    End Property

    Property Pen.Mode As Integer
        Return FMode
    End Property

    Property Pen.Mode(Value As Integer)
        FMode = Value
        Create
    End Property

    Property Pen.Size As Integer
        Return FSize
    End Property

    Property Pen.Size(Value As Integer)
        FSize = Value
        Create
    End Property

    Sub Pen.Create
		#IfNDEf __USE_GTK__
			If Handle Then DeleteObject Handle
			Handle = CreatePen(FStyle,FSize,FColor)
		#EndIf
    End Sub

    Operator Pen.Cast As Any Ptr
        Return @This
    End Operator

    Constructor Pen
        FSize  = 1
        FColor = 0
        FMode  = pmCopy
        FStyle = psSolid
        Create
        WLet FClassName, "Pen"
    End Constructor

    Destructor Pen
		#IfNDef __USE_GTK__
			If Handle Then DeleteObject Handle
		#EndIf
    End Destructor
End namespace
