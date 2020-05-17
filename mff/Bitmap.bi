'################################################################################
'#  BitmapType.bi                                                               #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                      #
'#  Based on:                                                                   #
'#   TBitmap.bi                                                                 #
'#   FreeBasic Windows GUI ToolKit                                              #
'#   Copyright (c) 2007-2008 Nastase Eodor                                      #
'#   Version 1.0.0                                                              #
'#  Updated and added cross-platform                                            #
'#  by Xusinboy Bekchanov (2018-2019)                                           #
'################################################################################

#include once "Object.bi"
#include once "Graphics.bi"
#ifndef __USE_GTK__
	#ifdef __FB_64BIT__
		#inclib "gdiplus"
		#include once "win/gdiplus-c.bi"
	#else
		#include once "win/ddraw.bi"
		#include once "win/gdiplus.bi"
		Using gdiplus
	#endif
#else
	#include once "gtk/gtk.bi"
	#ifdef __USE_GTK3__
		#include once "glib-object.bi"
	#endif
#endif

Namespace My.Sys.Drawing
	#define QBitmapType(__Ptr__) *Cast(BitmapType Ptr,__Ptr__)
	
	Type BitmapType Extends My.Sys.Object
	Private:
		FWidth       As Integer
		FHeight      As Integer
		#ifndef __USE_GTK__
			FDevice      As HDC
		#endif
		FTransparent As Boolean
		FLoadFlag(2) As Integer
		Declare Sub Create
	Public:
		Graphic      As Any Ptr
		#ifdef __USE_GTK__
			Handle 		As GdkPixBuf Ptr
		#else
			Handle       As HBITMAP
		#endif
		Brush        As My.Sys.Drawing.Brush
		Pen          As My.Sys.Drawing.Pen
		Tag          As Any Ptr
		Declare Property Width As Integer
		Declare Property Width(Value As Integer)
		Declare Property Height As Integer
		Declare Property Height(Value As Integer)
		Declare Property Transparency As Boolean
		Declare Property Transparency(Value As Boolean)
		Declare Sub LoadFromFile(ByRef File As WString, cxDesired As Integer = 0, cyDesired As Integer = 0) 'David Change
		Declare Sub SaveToFile(ByRef File As WString)
		#ifdef __USE_GTK__
			Declare Sub LoadFromResourceName(ResName As String, ModuleHandle As Integer = 0, cxDesired As Integer = 0, cyDesired As Integer = 0)  'David Change
		#else
			Declare Sub LoadFromResourceName(ResName As String, ModuleHandle As HInstance = GetModuleHandle(NULL), cxDesired As Integer = 0, cyDesired As Integer = 0)
		#endif
		#ifdef __USE_GTK__
			Declare Sub LoadFromPNGResourceName(ResName As String)
		#else
			Declare Sub LoadFromPNGResourceName(ResName As String, ModuleHandle As HInstance = GetModuleHandle(NULL))
		#endif
		Declare Sub LoadFromResourceID(ResID As Integer, cxDesired As Integer = 0, cyDesired As Integer = 0)  'David Change
		'Declare Static Function FromResourceName(ResName As String, cxDesired As Integer = 0, cyDesired As Integer = 0) As BitmapType Ptr  'David Change
		Declare Sub Clear
		Declare Sub Free
		Declare Operator Cast As Any Ptr
		Declare Operator Let(ByRef Value As WString)
		#ifndef __USE_GTK__
			Declare Operator Let(Value As HBITMAP)
		#endif
		Declare Constructor
		Declare Destructor
		Changed As Sub(ByRef Sender As BitmapType)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "Bitmap.bas"
#endif
