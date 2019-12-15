'###############################################################################
'#  CheckBox.bi                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TCheckBox.bi                                                              #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
    #DEFINE QCheckBox(__Ptr__) *Cast(CheckBox Ptr,__Ptr__)

    Type CheckBox Extends Control
        Private:
            FChecked    As Boolean
            #IfNDef __USE_GTK__
				Declare Static Sub WndProc(BYREF Message As Message)
				Declare Sub ProcessMessage(BYREF Message As Message)
            #EndIf
            Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
        Public:
            Declare Function ReadProperty(PropertyName As String) As Any Ptr
            Declare Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
        Declare Property Caption ByRef As WString
        Declare Property Caption(ByRef Value As WString)
        Declare Property Text ByRef As WString
        Declare Property Text(ByRef Value As WString)
        Declare Property Checked As Boolean
        Declare Property Checked(Value As Boolean)
        Declare Operator Cast As Control Ptr
        Declare Constructor
        Declare Destructor
        OnClick As Sub(ByRef Sender As CheckBox)
    End Type
End namespace

#IfNDef __USE_MAKE__
	#Include Once "CheckBox.bas"
#EndIf
