'###############################################################################
'#  Splitter.bi                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TSplitter.bi                                                              #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
	#DEFINE QSplitter(__Ptr__) *Cast(Splitter Ptr, __Ptr__)
	
	Type Splitter Extends Control
	Private:
		FOldParentProc  As Any Ptr
		#IfNDef __USE_GTK__
			Declare Static Sub ParentWndProc(BYREF Message As Message)
			Declare Static Sub WndProc(BYREF Message As Message)
		#EndIf
	Protected:
		Declare Sub DrawTrackSplit(x As Integer, y As Integer)
		Declare Sub ProcessMessage(BYREF Message As Message)
	Public:
		#IfDef __USE_GTK__
			Dim As Boolean bCursor
		#EndIf
		Declare Operator Cast As Control Ptr
		Declare Property Align As Integer
		Declare Property Align(Value As Integer)
		OnPaint As Sub(byref Sender As Splitter)
		OnMoved As Sub(byref Sender As Splitter)
		Declare Constructor
		Declare Destructor
	End Type
End namespace

#IfNDef __USE_MAKE__
	#Include Once "Splitter.bas"
#EndIf
