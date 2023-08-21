'###############################################################################
'#  Icon.bi                                                                    #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TIcon.bi                                                                  #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "Object.bi"
#include once "Bitmap.bi"
#ifdef __USE_GTK__
	#ifdef __USE_GTK4__
		#include once "gir_headers/Gir/Gtk-4.0.bi"
	#else
		#include once "gtk/gtk.bi"
		#ifdef __USE_GTK3__
			#include once "glib-object.bi"
		#endif
	#endif
#endif

Namespace My.Sys.Drawing
	Private Type Icon Extends My.Sys.Object
	Private:
		FWidth  As Integer
		FHeight As Integer
		FResName As WString Ptr
	Public:
		Graphic As Any Ptr
		#ifdef __USE_GTK__
			Handle As GdkPixbuf Ptr
		#elseif defined(__USE_JNI__)
			Handle  As jobject
		#elseif defined(__USE_WINAPI__)
			Handle  As HICON
		#endif
		Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Declare Property ResName ByRef As WString
		Declare Property ResName(ByRef Value As WString)
		Declare Property Width As Integer
		Declare Property Width(Value As Integer)
		Declare Property Height As Integer
		Declare Property Height(Value As Integer)
		Declare Function LoadFromFile(ByRef File As WString, cx As Integer = 0, cy As Integer = 0) As Boolean
		Declare Function SaveToFile(ByRef File As WString) As Boolean
		Declare Function LoadFromResourceName(ByRef ResName As WString, ModuleHandle As Any Ptr = 0, cx As Integer = 0, cy As Integer = 0) As Boolean
		Declare Function LoadFromResourceID(ResID As Integer, ModuleHandle As Any Ptr = 0, cx As Integer = 0, cy As Integer = 0) As Boolean
		Declare Function ToString() ByRef As WString
		#ifdef __USE_WINAPI__
			Declare Function ToBitmap() As HBITMAP
		#endif
		Declare Operator Cast As Any Ptr
		Declare Operator Cast As WString Ptr
		Declare Operator Let(ByRef Value As WString)
		Declare Operator Let(Value As Integer)
		Declare Operator Let(Value As Icon)
		#ifdef __USE_GTK__
			Declare Operator Let(Value As GdkPixbuf Ptr)
		#elseif defined(__USE_WINAPI__)
			Declare Operator Let(Value As HICON)
		#endif
		Declare Constructor
		Declare Destructor
		Changed As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Icon)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "Icon.bas"
#endif
