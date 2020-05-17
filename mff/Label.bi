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

#Include Once "Graphic.bi"

Namespace My.Sys.Forms
	#DEFINE QLabel(__Ptr__) *Cast(Label Ptr,__Ptr__)
	
	Enum LabelStyle
		lsText, lsBitmap, lsIcon, lsCursor, lsEmf, lsOwnerDraw
	End Enum
	
	Enum LabelBorder
		sbNone, sbSimple, sbSunken
	End Enum
	
	Enum Alignment
		taLeft, taCenter, taRight
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
		#IfNdef __USE_GTK__
			Declare Static Sub WndProc(BYREF Message As Message)
			Declare Sub ProcessMessage(BYREF Message As Message)
			Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
		#EndIf
		Declare Static Sub GraphicChange(BYREF Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
	Public:
		Graphic            As My.Sys.Drawing.GraphicType
		Declare Function ReadProperty(PropertyName As String) As Any Ptr
		Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Declare Property Caption ByRef As WString
		Declare Property Caption(ByRef Value As WString)
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Property Border As Integer
		Declare Property Border(Value As Integer)
		Declare Property Style As Integer
		Declare Property Style(Value As Integer)
		Declare Property RealSizeImage As Boolean
		Declare Property RealSizeImage(Value As Boolean)
		Declare Property CenterImage As Boolean
		Declare Property CenterImage(Value As Boolean)
		Declare Property Alignment As Integer
		Declare Property Alignment(Value As Integer)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnClick    As Sub(BYREF Sender As Label)
		OnDblClick As Sub(BYREF Sender As Label)
		#IfNdef __USE_GTK__
			OnDraw     As Sub(BYREF Sender As Label,BYREF R As Rect,DC As HDC = 0)
		#EndIf
	End Type
End Namespace

#IfNDef __USE_MAKE__
	#Include Once "Label.bas"
#EndIf
