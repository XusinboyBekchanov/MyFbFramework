'###############################################################################
'#  ImageBox.bi                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TStatic.bi                                                                #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "Graphic.bi"

Namespace My.Sys.Forms
	#define QImageBox(__Ptr__) (*Cast(ImageBox Ptr,__Ptr__))
	
	Private Enum ImageBoxStyle
		ssBitmap, ssIcon, ssCursor, ssEmf, ssOwnerDraw
	End Enum
	
	'`ImageBox` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`ImageBox` - Displays a graphic (Windows, Linux).
	Private Type ImageBox Extends Control
	Private:
		FImageStyle       As Integer
		AStyle(5)         As Integer
		FRealSizeImage    As Boolean
		FCenterImage      As Boolean
		ARealSizeImage(2) As Integer
		ARealSizeControl(2) As Integer
		ACenterImage(2)   As Integer
		#ifdef __USE_GTK__
			Declare Static Function DesignDraw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Declare Static Function DesignExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
		#else
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#endif
		Declare Static Sub GraphicChange(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
	Protected:
		#ifdef __USE_WASM__
			Declare Virtual Function GetContent() As UString
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		'Underlying image data object (Bitmap/Icon)
		Graphic            As My.Sys.Drawing.GraphicType
		#ifndef ReadProperty_Off
			'Loads image from persistence stream
			Declare Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves image to persistence stream
			Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Property AutoSize As Boolean
		'Adjusts control size to match image dimensions
		Declare Property AutoSize(Value As Boolean)
		Declare Property DesignMode As Boolean
		'Indicates if used in design interface
		Declare Property DesignMode(Value As Boolean)
		Declare Property Style As ImageBoxStyle
		'Display mode (Stretch/Tile/Zoom/Center)
		Declare Property Style(Value As ImageBoxStyle)
		Declare Property RealSizeImage As Boolean
		'Displays image at native resolution without scaling
		Declare Property RealSizeImage(Value As Boolean)
		Declare Property CenterImage As Boolean
		'Centers image within the control area
		Declare Property CenterImage(Value As Boolean)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		#ifdef __USE_WINAPI__
			'Triggered during image rendering
			OnDraw     As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ImageBox, ByRef R As My.Sys.Drawing.Rect, DC As HDC = 0)
		#endif
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "ImageBox.bas"
#endif
