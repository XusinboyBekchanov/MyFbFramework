'###############################################################################
'#  GroupBox.bi                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TGroupBox.bi                                                              #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "ContainerControl.bi"

Namespace My.Sys.Forms
	#define QGroupBox(__Ptr__) *Cast(GroupBox Ptr,__Ptr__)
	
	Type GroupBox Extends ContainerControl
	Private:
		FParentColor As Integer
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		Declare Property Caption ByRef As WString
		Declare Property Caption(ByRef Value As WString)
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Property ParentColor As Boolean
		Declare Property ParentColor(Value As Boolean)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnClick As Sub(ByRef Sender As GroupBox)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "GroupBox.bas"
#endif
