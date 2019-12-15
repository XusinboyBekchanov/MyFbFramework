'###############################################################################
'#  CheckedListBox.bi                                                          #
'#  This file is part of MyFBFramework                                         #
'#  Based on:                                                                  #
'#   TListBox.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Modified by Xusinboy Bekchanov (2018-2019)                                 #
'###############################################################################

#Include Once "Control.bi"
#Include Once "ListItems.bi"

Namespace My.Sys.Forms
    #DEFINE QCheckedListBox(__Ptr__) *Cast(CheckedListBox Ptr,__Ptr__)

    Type CheckedListBox Extends Control
        Private:
            FBorderStyle      As Integer
            FSort             As Boolean
            FSelCount         As Integer
            FSelItems         As Integer Ptr
            FTopIndex         As Integer
            FItemIndex        As Integer
            FItemHeight       As Integer
            FMultiselect      As Boolean
            FExtendSelect     As Boolean
            FColumns          As Integer
            FIntegralHeight   As Boolean
            FCtl3D            As Boolean
            ABorderStyle(3)   As Integer
            ABorderExStyle(2) As Integer
            AStyle(3)         As Integer
            ASortStyle(2)     As Integer
            AMultiselect(2)   As Integer
            AExtendSelect(2)  As Integer
            AMultiColumns(2)  As Integer
            AIntegralHeight(2)As Integer
            #IfNDef __USE_GTK__
				Declare Static Sub WndProc(BYREF Message As Message)
				Declare Sub ProcessMessage(BYREF Message As Message)
				Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
			#EndIf
        Public:
            Items             As ListItems
            Declare Property TabStop As Boolean
            Declare Property TabStop(Value As Boolean)
            Declare Property BorderStyle As Integer
            Declare Property BorderStyle(Value As Integer)
            Declare Property Ctl3D As Boolean
            Declare Property Ctl3D(Value As Boolean)
            Declare Property ItemIndex As Integer
            Declare Property ItemIndex(Value As Integer)
            Declare Property TopIndex As Integer
            Declare Property TopIndex(Value As Integer)
            Declare Property ItemHeight As Integer
            Declare Property ItemHeight(Value As Integer)
            Declare Property ItemCount As Integer
            Declare Property ItemCount(Value As Integer)
            Declare Property SelCount As Integer
            Declare Property SelCount(Value As Integer)
            Declare Property SelItems As Integer Ptr
            Declare Property SelItems(Value As Integer Ptr)
            Declare Property Sort As Boolean
            Declare Property Sort(Value As Boolean)
            Declare Property MultiSelect As Boolean
            Declare Property MultiSelect(Value As Boolean)
            Declare Property ExtendSelect As Boolean
            Declare Property ExtendSelect(Value As Boolean)
            Declare Property IntegralHeight As Boolean
            Declare Property IntegralHeight(Value As Boolean)
            Declare Property Columns As Integer
            Declare Property Columns(Value As Integer)
            Declare Property Object(FIndex As Integer) As Any Ptr
            Declare Property Object(FIndex As Integer, Obj As Any Ptr)
            Declare Property Item(FIndex As Integer) ByRef As WString
            Declare Property Item(FIndex As Integer, ByRef FItem As WString)
            Declare Property Text ByRef As WString
            Declare Property Text(ByRef Value As WString)
            Declare Operator Cast As Control Ptr
            Declare Sub AddItem(ByRef FItem As WString)
            Declare Sub AddObject(ByRef ObjName As WString, Obj As Any Ptr)
            Declare Sub RemoveItem(FIndex As Integer)
            Declare Sub InsertItem(FIndex As Integer, ByRef FItem As WString)
            Declare Sub InsertObject(FIndex As Integer, ByRef ObjName As WString, Obj As Any Ptr)
            Declare Function IndexOf(ByRef Item As WString) As Integer
            Declare Function IndexOfObject(Obj As Any Ptr) As Integer
            Declare Sub Clear
            Declare Sub SaveToFile(ByRef File As WString)
            Declare Sub LoadFromFile(ByRef File As WString)
            Declare Constructor
            Declare Destructor
            OnChange      As Sub(BYREF Sender As CheckedListBox)
            OnDblClick    As Sub(BYREF Sender As CheckedListBox)
            OnKeyPress    As Sub(BYREF Sender As CheckedListBox, Key As Byte, Shift As Integer)
            OnKeyDown     As Sub(BYREF Sender As CheckedListBox, Key As Integer, Shift As Integer)
            OnKeyUp       As Sub(BYREF Sender As CheckedListBox, Key As Integer, Shift As Integer)
            #IfNDef __USE_GTK__
            OnMeasureItem As Sub(BYREF Sender As CheckedListBox, ItemIndex As Integer, BYREF Height As UInt)
				OnDrawItem    As Sub(BYREF Sender As CheckedListBox, ItemIndex As Integer, State As Integer,BYREF R As Rect, DC As HDC = 0)
			#EndIf
    End Type
End namespace

#IfNDef __USE_MAKE__
	#Include Once "CheckedListBox.bas"
#EndIf
