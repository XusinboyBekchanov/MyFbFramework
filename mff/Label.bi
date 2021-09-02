'###############################################################################
'#  Label.bi                                                                   #
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
	#define QLabel(__Ptr__) *Cast(Label Ptr,__Ptr__)
	
	Enum LabelStyle
		lsText, lsBitmap, lsIcon, lsCursor, lsEmf, lsOwnerDraw
	End Enum
	
	Enum LabelBorder
		sbNone, sbSimple, sbSunken
	End Enum
	
	Type Label Extends Control
	Private:
		FBorder           As Integer
		FStyle            As Integer
		FAlignment        As Integer
		FRealSizeImage    As Boolean
		FCenterImage      As Boolean
		AStyle(6)         As Integer
		ABorder(3)        As Integer
		AAlignment(3)     As Integer
		ARealSizeImage(2) As Integer
		ACenterImage(2)   As Integer
		AWordWraps(2)     As Integer
		FWordWraps        As Boolean
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#endif
		Declare Static Sub GraphicChange(ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
	Protected:
		Declare Virtual Sub ChangeLabelStyle
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		Graphic            As My.Sys.Drawing.GraphicType
		Declare Function ReadProperty(PropertyName As String) As Any Ptr
		Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Declare Property Alignment As AlignmentConstants
		Declare Property Alignment(Value As AlignmentConstants)
		Declare Property Caption ByRef As WString
		Declare Property Caption(ByRef Value As WString)
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Property Border As Integer 'LabelBorder
		Declare Property Border(Value As Integer)
		Declare Property Style As Integer 'LabelStyle
		Declare Property Style(Value As Integer)
		Declare Property RealSizeImage As Boolean
		Declare Property RealSizeImage(Value As Boolean)
		Declare Property CenterImage As Boolean
		Declare Property CenterImage(Value As Boolean)
		Declare Property WordWraps As Boolean
		Declare Property WordWraps(Value As Boolean)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnClick    As Sub(ByRef Sender As Label)
		OnDblClick As Sub(ByRef Sender As Label)
		#ifndef __USE_GTK__
			OnDraw     As Sub(ByRef Sender As Label,ByRef R As Rect,DC As HDC = 0)
		#endif
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "Label.bas"
#endif
