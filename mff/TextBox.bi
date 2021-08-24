﻿'###############################################################################
'#  TextBox.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TEdit.bi                                                                  #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "Control.bi"

Namespace My.Sys.Forms
	#define QTextBox(__Ptr__) *Cast(TextBox Ptr,__Ptr__)
	
	Enum CharCases
		ecNone, ecLower, ecUpper
	End Enum
	
	Enum ScrollBarsType
		None, Vertical, Horizontal, Both
	End Enum
	
	Type TextBox Extends Control
	Private:
		#ifdef __USE_GTK__
			Declare Static Sub Entry_Activate(entry As GtkEntry Ptr, user_data As Any Ptr)
			Declare Static Sub Entry_Changed(entry As GtkEntry Ptr, user_data As Any Ptr)
			Declare Static Function Entry_FocusInEvent(widget As GtkWidget Ptr, Event As GdkEventFocus Ptr, user_data As Any Ptr) As Boolean
			Declare Static Function Entry_FocusOutEvent(widget As GtkWidget Ptr, Event As GdkEventFocus Ptr, user_data As Any Ptr) As Boolean
			Declare Static Sub TextBuffer_Changed(TextBuffer As GtkTextBuffer Ptr, user_data As Any Ptr)
		#else
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#endif
	Protected:
		FTopLine          As Integer
		FSelStart         As Integer
		FSelLength        As Integer
		FSelEnd           As Integer
		FSelText          As WString Ptr
		FLine             As WString Ptr
		FCharCase         As CharCases
		FMasked           As Boolean
		FMaskChar         As Byte
		FAlignment        As Integer
		FBorderStyle      As BorderStyles
		FReadOnly         As Boolean
		FCtl3D            As Boolean
		FHideSelection    As Boolean
		FOEMConvert       As Boolean
		FMaxLength        As Integer
		FModified         As Boolean
		ACharCase(3)      As Long
		AMaskStyle(2)     As Long
		ABorderExStyle(2) As Long
		ABorderStyle(2)   As Long
		AOEMConvert(2)    As Long
		AHideSelection(2) As Long
		FWantReturn As Boolean
		FWantTab As Boolean
		FMultiline As Boolean
		FScrollBars As ScrollBarsType
		FWordWraps As Boolean
		FInputFilter As WString Ptr 'David Change
		#ifdef __USE_GTK__
			TextBuffer As GtkTextBuffer Ptr
			WidgetScrolledWindow As GtkWidget Ptr
			WidgetEntry As GtkWidget Ptr
			WidgetTextView As GtkWidget Ptr
		#else
			Declare Static Sub WndProc(ByRef message As Message)
		#endif
		Declare Virtual Sub ProcessMessage(ByRef message As Message)
	Public:
		Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Declare Sub AddLine(ByRef wsLine As WString)
		Declare Sub InsertLine(Index As Integer, ByRef wsLine As WString)
		Declare Sub RemoveLine(Index As Integer)
		Declare Sub GetSel(ByRef iSelStart As Integer, ByRef iSelEnd As Integer)
		Declare Sub GetSel(ByRef iSelStartRow As Integer, ByRef iSelStartCol As Integer, ByRef iSelEndRow As Integer, ByRef iSelEndCol As Integer)
		Declare Sub SetSel(iSelStart As Integer, iSelEnd As Integer)
		Declare Sub SetSel(iSelStartRow As Integer, iSelStartCol As Integer, iSelEndRow As Integer, iSelEndCol As Integer)
		Declare Function GetLineFromCharIndex(Index As Integer = -1) As Integer
		Declare Function GetCharIndexFromLine(Index As Integer) As Integer
		Declare Function GetLineLength(Index As Integer) As Integer
		Declare Property Alignment As AlignmentConstants
		Declare Property Alignment(Value As AlignmentConstants)
		Declare Property BorderStyle As BorderStyles
		Declare Property BorderStyle(Value As BorderStyles)
		Declare Property ReadOnly As Boolean
		Declare Property ReadOnly(Value As Boolean)
		Declare Property Ctl3D As Boolean
		Declare Property Ctl3D(Value As Boolean)
		Declare Property HideSelection As Boolean
		Declare Property HideSelection(Value As Boolean)
		Declare Property OEMConvert As Boolean
		Declare Property OEMConvert(Value As Boolean)
		Declare Property MaxLength As Integer
		Declare Property MaxLength(Value As Integer)
		Declare Property Modified As Boolean
		Declare Property Modified(Value As Boolean)
		Declare Property CharCase As CharCases
		Declare Property CharCase(Value As CharCases)
		Declare Property Masked As Boolean
		Declare Property Masked(Value As Boolean)
		Declare Property MaskChar As Byte
		Declare Property MaskChar(Value As Byte)
		Declare Property Lines(Index As Integer) ByRef As WString
		Declare Property Lines(Index As Integer, ByRef Value As WString)
		Declare Function LinesCount As Integer
		Declare Property CaretPos As Point
		Declare Property CaretPos(Value As Point)
		Declare Property SelStart As Integer
		Declare Property SelStart(Value As Integer)
		Declare Property SelEnd As Integer
		Declare Property SelEnd(Value As Integer)
		Declare Property SelLength As Integer
		Declare Property SelLength(Value As Integer)
		Declare Property SelText ByRef As WString
		Declare Property SelText(ByRef Value As WString)
		Declare Property ScrollBars As ScrollBarsType
		Declare Property ScrollBars(Value As ScrollBarsType)
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Property TopLine As Integer
		Declare Property TopLine(Value As Integer)
		Declare Property WordWraps As Boolean
		Declare Property WordWraps(Value As Boolean)
		Declare Property WantReturn() As Boolean
		Declare Property WantReturn(Value As Boolean)
		Declare Property WantTab() As Boolean
		Declare Property WantTab(Value As Boolean)
		Declare Property Multiline() As Boolean
		Declare Property Multiline(Value As Boolean)
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Sub Clear
		Declare Sub ClearUndo
		Declare Function CanUndo As Boolean
		Declare Function GetTextLength() As Integer
		Declare Sub Undo
		Declare Sub PasteFromClipboard
		Declare Sub CopyToClipboard
		Declare Sub CutToClipboard
		Declare Sub SelectAll
		Declare Sub ScrollToCaret
		Declare Sub LoadFromFile(ByRef File As WString)
		Declare Sub SaveToFile(ByRef File As WString)
		Declare Sub InputFilter( ByRef Value As WString) 'David Change
		Declare Constructor
		Declare Destructor
		OnChange   As Sub(ByRef Sender As TextBox)
		OnGotFocus   As Sub(ByRef Sender As TextBox)
		OnLostFocus   As Sub(ByRef Sender As TextBox)
		OnHScroll   As Sub(ByRef Sender As TextBox)
		OnVScroll   As Sub(ByRef Sender As TextBox)
		OnCut As Sub(ByRef Sender As TextBox)
		OnCopy As Sub(ByRef Sender As TextBox)
		OnPaste As Sub(ByRef Sender As TextBox, ByRef Action As Integer)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "TextBox.bas"
#endif
