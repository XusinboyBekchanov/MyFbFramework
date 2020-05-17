'###############################################################################
'#  Picture.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Liu ZiQI                                           #
'#  Based on:                                                                  #
'#   TStatic.bi                                                                #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Created by Liu ZiQI (2019)                                                 #
'###############################################################################
'https://blog.csdn.net/mmmvp/article/details/365155
#include once "Graphic.bi"
#include once "ContainerControl.bi"
#include once "Canvas.bi"

Namespace My.Sys.Forms
	#define QPicture(__Ptr__) *Cast(Picture Ptr,__Ptr__)
	
	Enum PictureStyle
		ssBitmap, ssIcon, ssCursor, ssEmf, ssOwnerDraw
	End Enum
	
	Type Picture Extends ContainerControl
	Private:
		AStyle(24)         As Integer
		FRealSizeImage    As Boolean
		FCenterImage      As Boolean
		ARealSizeImage(2) As Integer
		ACenterImage(2)   As Integer
		#ifdef __USE_GTK__
			ImageWidget As GtkWidget Ptr
		#else
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#endif
		Declare Sub ProcessMessage(ByRef Message As Message)
		Declare Static Sub GraphicChange(ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
	Public:
		Graphic As My.Sys.Drawing.GraphicType
		Canvas  As My.Sys.Drawing.Canvas
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
		OnClick    As Sub(ByRef Sender As Picture)
		OnDblClick As Sub(ByRef Sender As Picture)
		#ifndef __USE_GTK__
			OnDraw As Sub(ByRef Sender As Picture, ByRef R As Rect,DC As HDC)
		#endif
	End Type
End Namespace
#ifndef __USE_MAKE__
	#include once "Picture.bas"
#endif
