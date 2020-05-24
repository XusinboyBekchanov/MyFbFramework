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
#include once "WStringList.bi"

Using My.Sys.ComponentModel

Namespace My.Sys.Forms
	#ifdef __USE_GTK__
		Enum DrawingStyle
			dsFocus
			dsNormal
			dsSelected
			dsTransparent
			dsBlend
			dsBlend25
			dsBlend50
		End Enum
		
		Enum ImagesType
			itImage = 0
			itMask
		End Enum
	#else
		Enum DrawingStyle
			dsFocus       = ILD_FOCUS
			dsNormal      = ILD_NORMAL
			dsSelected    = ILD_SELECTED
			dsTransparent = ILD_TRANSPARENT
			dsBlend       = ILD_BLEND
			dsBlend25     = ILD_BLEND25
			dsBlend50     = ILD_BLEND50
		End Enum
		
		Enum ImagesType
			itImage = 0
			itMask  = ILD_MASK
		End Enum
	#endif
	
	Type ImageList Extends Component
	Private:
		FParentWindow As Component Ptr
		FWidth        As Integer
		FHeight       As Integer
		FBKColor      As Integer
		FCount        As Integer
		FKeys            As WStringList
		Declare Sub Create
		Declare Sub NotifyWindow
	Public:
		#ifdef __USE_GTK__
			Widget 			As GtkIconTheme Ptr
		#else
			Handle        As HIMAGELIST
		#endif
		AllocBy       As Integer
		ImageType     As ImagesType
		DrawingStyle  As DrawingStyle
		Declare Property ParentWindow As Component Ptr
		Declare Property ParentWindow(Value As Component Ptr)
		Declare Property Width As Integer
		Declare Property Width(Value As Integer)
		Declare Property Height As Integer
		Declare Property Height(Value As Integer)
		Declare Property BKColor As Integer
		Declare Property BKColor(Value As Integer)
		Declare Property Count As Integer
		Declare Sub AddBitmap(Bitmap As My.Sys.Drawing.BitmapType, Mask As My.Sys.Drawing.BitmapType, ByRef Key As WString = "")
		Declare Sub AddIcon(Icon As My.Sys.Drawing.Icon, ByRef Key As WString = "")
		#ifndef __USE_GTK__
			Declare Sub AddIcon(Ico As String, ByRef Key As WString = "", ModuleHandle As HInstance = GetModuleHandle(NULL))
		#endif
		Declare Sub AddCursor(Cursor As My.Sys.Drawing.Cursor, ByRef Key As WString = "")
		Declare Sub AddMasked(ByRef Bitmap As My.Sys.Drawing.BitmapType, MaskColor As Integer, ByRef Key As WString = "")
		#ifdef __USE_GTK__
			Declare Sub AddMasked(Bmp As String, MaskColor As Integer, ByRef Key As WString = "")
		#else
			Declare Sub AddMasked(Bmp As String, MaskColor As Integer, ByRef Key As WString = "", ModuleHandle As HInstance = GetModuleHandle(NULL))
		#endif
		#ifdef __USE_GTK__
			Declare Sub AddPng(ByRef Png As WString, ByRef Key As WString = "")
		#else
			Declare Sub AddPng(ByRef Png As WString, ByRef Key As WString = "", ModuleHandle As HInstance = GetModuleHandle(NULL))
		#endif
		Declare Sub Remove(Index As Integer)
		Declare Sub Remove(ByRef Key As WString)
		Declare Function GetBitmap(Index As Integer) ByRef As My.Sys.Drawing.BitmapType
		Declare Function GetMask(Index As Integer) As My.Sys.Drawing.BitmapType
		Declare Function GetIcon(Index As Integer) As My.Sys.Drawing.Icon
		Declare Function GetCursor(Index As Integer) As My.Sys.Drawing.Cursor
		Declare Function GetBitmap(ByRef Key As WString) ByRef As My.Sys.Drawing.BitmapType
		Declare Function GetMask(ByRef Key As WString) As My.Sys.Drawing.BitmapType
		Declare Function GetIcon(ByRef Key As WString) As My.Sys.Drawing.Icon
		Declare Function GetCursor(ByRef Key As WString) As My.Sys.Drawing.Cursor
		Declare Function IndexOf(ByRef Key As WString) As Integer
		#ifndef __USE_GTK__
			Declare Sub DrawEx(Index As Integer, DestDC As HDC, X As Integer, Y As Integer, iWidth As Integer, iHeight As Integer, FG As Integer, BK As Integer)
			Declare Sub Draw(Index As Integer, DestDC As HDC, X As Integer, Y As Integer)
		#endif
		Declare Sub Clear
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		OnChange As Sub(BYREF Sender As ImageList)
	End Type
End namespace

#IfNDef __USE_MAKE__
	#Include Once "ImageList.bas"
#EndIf
