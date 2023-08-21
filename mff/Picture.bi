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
	#define QPicture(__Ptr__) (*Cast(Picture Ptr,__Ptr__))
	
	Private Enum PictureStyle
		ssText, ssBitmap, ssIcon, ssCursor, ssEmf, ssOwnerDraw
	End Enum
	
	Private Enum StretchMode
		smNone, smStretch, smStretchProportional
	End Enum
	
	Private Type Picture Extends ContainerControl
	Private:
		AStyle(24)             As Integer
		FPictureStyle          As Integer
		FRealSizeImage      As Boolean
		FCenterImage        As Boolean
		FTransparent        As Boolean
		FDownButton         As Integer
		FStretchImage       As StretchMode
		ARealSizeImage(2)   As Integer
		ARealSizeControl(2) As Integer
		ACenterImage(2)     As Integer
		#ifdef __USE_GTK__
			ImageWidget        As GtkWidget Ptr
		#else
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#endif
		Declare Static Sub GraphicChange(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
	Protected:
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		Graphic As My.Sys.Drawing.GraphicType
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property AutoSize As Boolean
		Declare Property AutoSize(Value As Boolean)
		Declare Property Style As PictureStyle
		Declare Property Style(Value As PictureStyle)
		Declare Property RealSizeImage As Boolean
		Declare Property RealSizeImage(Value As Boolean)
		Declare Property CenterImage As Boolean
		Declare Property CenterImage(Value As Boolean)
		Declare Property StretchImage As StretchMode
		Declare Property StretchImage(Value As StretchMode)
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		Declare Property Transparent As Boolean
		Declare Property Transparent(Value As Boolean)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnClick    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Picture)
		OnDblClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Picture)
		#ifndef __USE_GTK__
			OnDraw As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Picture, ByRef R As My.Sys.Drawing.Rect, DC As HDC)
		#endif
	End Type
End Namespace
#ifndef __USE_MAKE__
	#include once "Picture.bas"
#endif
