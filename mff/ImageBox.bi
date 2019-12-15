'###############################################################################
'#  ImageBox.bi                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TStatic.bi                                                                #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#Include Once "Graphic.bi"

Namespace My.Sys.Forms
    #DEFINE QImageBox(__Ptr__) *Cast(ImageBox Ptr,__Ptr__)

	Enum ImageBoxStyle
        ssBitmap, ssIcon, ssCursor, ssEmf, ssOwnerDraw
    End Enum

    Type ImageBox Extends Control
        Private:
			AStyle(5)         As Integer
            FRealSizeImage    As Boolean
            FCenterImage      As Boolean
            ARealSizeImage(2) As Integer
            ACenterImage(2)   As Integer
            #IfNdef __USE_GTK__
				Declare Static Sub WndProc(BYREF Message As Message)
				Declare Sub ProcessMessage(BYREF Message As Message)
				Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
			#EndIf
            Declare Static Sub GraphicChange(BYREF Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
        Public:
            Graphic            As My.Sys.Drawing.GraphicType
            Declare Function ReadProperty(PropertyName As String) As Any Ptr
            Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
            Declare Property Style As Integer
            Declare Property Style(Value As Integer)
            Declare Property RealSizeImage As Boolean
            Declare Property RealSizeImage(Value As Boolean)
            Declare Property CenterImage As Boolean
            Declare Property CenterImage(Value As Boolean)
            Declare Operator Cast As Control Ptr
            Declare Constructor
            Declare Destructor
            OnClick    As Sub(BYREF Sender As ImageBox)
            OnDblClick As Sub(BYREF Sender As ImageBox)
            #IfNdef __USE_GTK__
				OnDraw     As Sub(BYREF Sender As ImageBox, BYREF R As Rect,DC As HDC = 0)
			#EndIf
    End Type
End Namespace

#IfNDef __USE_MAKE__
	#Include Once "ImageBox.bas"
#EndIf
