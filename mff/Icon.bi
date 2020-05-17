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

#Include Once "Object.bi"
#Include Once "Bitmap.bi"
#IfDef __USE_GTK__
	#Include once "gtk/gtk.bi"
	#IfDef __USE_GTK3__
		#include once "glib-object.bi"
	#EndIf
#EndIf

Namespace My.Sys.Drawing
	Type Icon Extends My.Sys.Object
	Private:
		FWidth  As Integer
		FHeight As Integer
		FResName As WString Ptr
	Public:
		Graphic As Any Ptr
		#IfDef __USE_GTK__
			Handle As GdkPixBuf Ptr
		#Else
			Handle  As HICON
		#EndIf
		Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Declare Property ResName ByRef As WString
		Declare Property ResName(ByRef Value As WString)
		Declare Property Width As Integer
		Declare Property Width(Value As Integer)
		Declare Property Height As Integer
		Declare Property Height(Value As Integer)
		Declare Sub LoadFromFile(ByRef File As WString, cx As Integer = 0, cy As Integer = 0)
		Declare Sub SaveToFile(ByRef File As WString)
		Declare Sub LoadFromResourceName(ByRef ResName As WString, cx As Integer = 0, cy As Integer = 0)
		Declare Sub LoadFromResourceID(ResID As Integer, cx As Integer = 0, cy As Integer = 0)
		#IfNDef __USE_GTK__
			Declare Function ToBitmap() As hBitmap
		#EndIf
		Declare Operator Cast As Any Ptr
		Declare Operator Cast As WString Ptr
		Declare Operator Let(ByRef Value As WString)
		Declare Operator Let(Value As Integer)
		#IfNDef __USE_GTK__
			Declare Operator Let(Value As HICON)
		#EndIf
		Declare Constructor
		Declare Destructor
		Changed As Sub(BYREF Sender As Icon)
	End Type
End Namespace

#IfNDef __USE_MAKE__
	#Include Once "Icon.bas"
#EndIf
