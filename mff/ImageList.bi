'###############################################################################
'#  ImageList.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TImageList.bi                                                             #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added png support                                              #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "Graphics.bi"
#include once "Component.bi"
#include once "Dictionary.bi"
#include once "Canvas.bi"

Using My.Sys.ComponentModel

Namespace My.Sys.Forms
	#ifdef __USE_GTK__
		Enum DrawingStyles
			dsFocus
			dsNormal
			dsSelected
			dsTransparent
			dsBlend
			dsBlend25
			dsBlend50
		End Enum
		
		Enum ImageTypes
			itImage = 0
			itMask
		End Enum
	#else
		Enum DrawingStyles
			dsFocus       = ILD_FOCUS
			dsNormal      = ILD_NORMAL
			dsSelected    = ILD_SELECTED
			dsTransparent = ILD_TRANSPARENT
			dsBlend       = ILD_BLEND
			dsBlend25     = ILD_BLEND25
			dsBlend50     = ILD_BLEND50
		End Enum
		
		Enum ImageTypes
			itImage = 0
			itMask  = ILD_MASK
		End Enum
	#endif
	
	Type ImageList Extends Component
	Private:
		FParentWindow   As Component Ptr
		FImageWidth     As Integer
		FImageHeight    As Integer
		FBackColor      As Integer
		FMaskColor      As Integer
		FCount          As Integer
		FNotChange      As Boolean
		FNotAdd         As Boolean
		FBMP            As My.Sys.Drawing.BitmapType
		Declare Static Sub ImageList_Change(ByRef Sender As Dictionary)
		Declare Sub Create
		Declare Sub NotifyWindow
	Public:
		Items           As Dictionary
		Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#ifdef __USE_GTK__
			Handle      As GtkIconTheme Ptr
		#else
			Handle      As HIMAGELIST
		#endif
		InitialCount    As Integer
		GrowCount       As Integer
		ImageType       As ImageTypes
		DrawingStyle    As DrawingStyles
		Declare Property ParentWindow As Component Ptr
		Declare Property ParentWindow(Value As Component Ptr)
		Declare Property ImageWidth As Integer
		Declare Property ImageWidth(Value As Integer)
		Declare Property ImageHeight As Integer
		Declare Property ImageHeight(Value As Integer)
		Declare Property BackColor As Integer
		Declare Property BackColor(Value As Integer)
		Declare Property MaskColor As Integer
		Declare Property MaskColor(Value As Integer)
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Sub Add(ByRef ResName As WString, ByRef Key As WString = "", ModuleHandle As Any Ptr = 0)
		Declare Sub Add(Bmp As My.Sys.Drawing.BitmapType, Mask As My.Sys.Drawing.BitmapType, ByRef Key As WString = "")
		Declare Sub Add(Icon As My.Sys.Drawing.Icon, ByRef Key As WString = "")
		Declare Sub Add(Cursor As My.Sys.Drawing.Cursor, ByRef Key As WString = "")
		Declare Sub AddMasked(ByRef Bitmap As My.Sys.Drawing.BitmapType, MaskColor As Integer, ByRef Key As WString = "")
		Declare Sub AddMasked(ByRef ResName As WString, MaskColor As Integer, ByRef Key As WString = "", ModuleHandle As Any Ptr = 0)
		Declare Sub AddFromFile(ByRef File As WString, ByRef Key As WString = "")
'		Declare Sub AddPng(ByRef ResName As WString, ByRef Key As WString = "", ModuleHandle As Any Ptr = 0)
'		Declare Sub Set(Index As Integer, Bitmap As My.Sys.Drawing.BitmapType, Mask As My.Sys.Drawing.BitmapType, ByRef Key As WString = "")
'		Declare Sub Set(ByRef Key As WString, Bitmap As My.Sys.Drawing.BitmapType, Mask As My.Sys.Drawing.BitmapType, ByRef Key As WString = "")
'		Declare Sub Set(Index As Integer, Icon As My.Sys.Drawing.Icon, ByRef Key As WString = "")
'		Declare Sub Set(ByRef Key As WString, Icon As My.Sys.Drawing.Icon, ByRef Key As WString = "")
'		Declare Sub Set(Index As Integer, Cursor As My.Sys.Drawing.Cursor, ByRef Key As WString = "")
'		Declare Sub Set(ByRef Key As WString, Cursor As My.Sys.Drawing.Cursor, ByRef Key As WString = "")
'		Declare Sub Set(Index As Integer, ByRef ResName As WString, ModuleHandle As Any Ptr = 0)
'		Declare Sub Set(ByRef Key As WString, ByRef ResName As WString, ModuleHandle As Any Ptr = 0)
'		Declare Sub SetFromFile(Index As Integer, ByRef File As WString)
'		Declare Sub SetFromFile(ByRef Key As WString, ByRef File As WString)
		Declare Sub Remove(Index As Integer)
		Declare Sub Remove(ByRef Key As WString)
		Declare Function GetBitmap(Index As Integer) As My.Sys.Drawing.BitmapType
		Declare Function GetMask(Index As Integer) As My.Sys.Drawing.BitmapType
		Declare Function GetIcon(Index As Integer) As My.Sys.Drawing.Icon
		Declare Function GetCursor(Index As Integer) As My.Sys.Drawing.Cursor
		Declare Function GetBitmap(ByRef Key As WString) As My.Sys.Drawing.BitmapType
		Declare Function GetMask(ByRef Key As WString) As My.Sys.Drawing.BitmapType
		Declare Function GetIcon(ByRef Key As WString) As My.Sys.Drawing.Icon
		Declare Function GetCursor(ByRef Key As WString) As My.Sys.Drawing.Cursor
		Declare Function IndexOf(ByRef Key As WString) As Integer
		Declare Sub Draw(Index As Integer, ByRef Canvas As My.Sys.Drawing.Canvas, X As Integer, Y As Integer, iWidth As Integer = -1, iHeight As Integer = -1, FG As Integer = -1, BK As Integer = -1)
		Declare Sub Clear
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		OnChange As Sub(ByRef Sender As ImageList)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "ImageList.bas"
#endif
