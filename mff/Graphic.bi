'###############################################################################
'#  Graphic.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TGraphic.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#Include Once "Control.bi"

Namespace My.Sys.Drawing
	#DEFINE QGraphic(__Ptr__) *Cast(GraphicType Ptr,__Ptr__)
	
	Type GraphicType Extends My.Sys.Object
	Private:
		Declare Static Sub BitmapChanged(BYREF Sender As My.Sys.Drawing.BitmapType)
		Declare Static Sub IconChanged(BYREF Sender As My.Sys.Drawing.Icon)
		Declare Static Sub CursorChanged(BYREF Sender As My.Sys.Drawing.Cursor)
	Public:
		Ctrl      As My.Sys.Forms.Control Ptr
		Bitmap    As My.Sys.Drawing.BitmapType
		Icon      As My.Sys.Drawing.Icon
		Cursor    As My.Sys.Drawing.Cursor
		Image     As Any Ptr
		ImageType As Integer
		Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Declare Constructor
		Declare Destructor
		OnChange As Sub(BYREF Sender As GraphicType, Image As Any Ptr, ImageType As Integer)
	End Type
End Namespace

#IfNDef __USE_MAKE__
	#Include Once "Graphic.bas"
#EndIf
