'###############################################################################
'#  Header.bi                                                                  #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   THeader.bi                                                                #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Modified by Xusinboy Bekchanov (2018-2019)                                 #
'###############################################################################

#Include Once "Control.bi"
#Include Once "ImageList.bi"
#Include Once "List.bi"

namespace My.Sys.Forms
    #DEFINE QHeader(__Ptr__) *Cast(Header Ptr,__Ptr__)
    #DEFINE QHeaderSection(__Ptr__) *Cast(HeaderSection Ptr,__Ptr__)

    Type PHeaderControl As Header

    Enum HeaderSectionStyle
        hdsText, hdsOwnerDraw 
    End Enum

    Type HeaderSection Extends My.Sys.Object
        Private:
            FCaption      As WString Ptr
            FAlignment    As Integer
            FImageIndex   As Integer
            FStyle        As Integer
            FWidth        As Integer
            AFmt(4)       As Integer
        Public:
            HeaderControl As PHeaderControl Ptr
            Tag           As Any Ptr
            Declare Property Caption ByRef As WString
            Declare Property Caption(ByRef Value As WString)
            Declare Property Alignment As Integer
            Declare Property Alignment(Value As Integer)
            Declare Property ImageIndex As Integer
            Declare Property ImageIndex(Value As Integer)
            Declare Property Width As Integer
            Declare Property Width(Value As Integer)
            Declare Property Style As Integer
            Declare Property Style(Value As Integer)
            Declare Operator Cast As Any Ptr
            Declare Constructor
            Declare Destructor
    End Type

    Enum HeaderStyle
        hsNormal = 0, hsOwnerDraw
    End Enum

    Type Header Extends Control
        Private:
            FStyle            As Integer
            FFullDrag         As Boolean
            FDragReorder      As Boolean
            FHotTrack         As Boolean
            AStyle(2)         As Integer
            AHotTrack(2)      As Integer
            AFullDrag(2)      As Integer
            ADragReorder(2)   As Integer
            AFmt(4)           As Integer
            FSectionCount     As Integer
            FSections         As List
            #IfNDef __USE_GTK__
				Declare Static Sub WndProc(BYREF Message As Message)
				Declare Sub ProcessMessage(BYREF Message As Message)
				Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
			#EndIf
            Declare Function EnumMenuItems(Item As MenuItem,BYREF List As List) As Boolean
        Public:
            Images            As ImageList
            Declare Property Style As Integer
            Declare Property Style(Value As Integer)
            Declare Property HotTrack As Boolean
            Declare Property HotTrack(Value As Boolean)
            Declare Property FullDrag As Boolean
            Declare Property FullDrag(Value As Boolean)
            Declare Property DragReorder As Boolean
            Declare Property DragReorder(Value As Boolean)
            Declare Property SectionCount As Integer
            Declare Property SectionCount(Value As Integer)
            Declare Property Section(Index As Integer) As HeaderSection Ptr
            Declare Property Section(Index As Integer,Value As HeaderSection Ptr)
            Declare Property Captions(Index As Integer) ByRef As WString
            Declare Property Captions(Index As Integer, ByRef Value As WString)
            Declare Property Widths(Index As Integer) As Integer
            Declare Property Widths(Index As Integer,Value As Integer)
            Declare Property Alignments(Index As Integer) As Integer
            Declare Property Alignments(Index As Integer,Value As Integer)
            Declare Property ImageIndexes(Index As Integer) As Integer
            Declare Property ImageIndexes(Index As Integer,Value As Integer)
            Declare Operator Cast As Control Ptr
            Declare Sub AddSection(ByRef FCaption As WString = "", FImageIndex As Integer = -1, FWidth As Integer = 50, FAlignment As Integer = 0)
            Declare Sub AddSections CDECL(FCount As Integer,...)
            Declare Sub RemoveSection(Index As Integer)
            Declare Sub UpdateItems
            Declare Constructor
            Declare Destructor
            OnSectionClick    As Sub(BYREF Sender As Header, BYREF Section As HeaderSection, Index As Integer, MouseButton As Integer)
            OnSectionDblClick As Sub(BYREF Sender As Header, BYREF Section As HeaderSection, Index As Integer, MouseButton As Integer)
            OnChange          As Sub(BYREF Sender As Header, BYREF Section As HeaderSection)
            OnChanging        As Sub(BYREF Sender As Header, BYREF Section As HeaderSection)
            OnBeginTrack      As Sub(BYREF Sender As Header, BYREF Section As HeaderSection) 
            OnEndTrack        As Sub(BYREF Sender As Header, BYREF Section As HeaderSection)
            OnTrack           As Sub(BYREF Sender As Header, BYREF Section As HeaderSection)
            OnDividerDblClick As Sub(BYREF Sender As Header, Index As Integer, MouseButton As Integer)
            #IfNDef __USE_GTK__
				OnDrawSection     As Sub(BYREF Sender As Header, BYREF Section As HeaderSection, R As Rect, State As Integer)
			#EndIf
    End Type
End Namespace    

#IfNDef __USE_MAKE__
	#Include Once "Header.bas"
#EndIf
