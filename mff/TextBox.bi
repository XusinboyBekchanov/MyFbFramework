'###############################################################################
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
	#define QTextBox(__Ptr__) (*Cast(TextBox Ptr,__Ptr__))
	
	Private Enum CharCases
		ecNone, ecLower, ecUpper
	End Enum
	
	Private Enum ScrollBarsType
		None, Vertical, Horizontal, Both
	End Enum
	
	'`TextBox` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`TextBox` - Displays information entered at design time by the user, or in code at run time.
	Private Type TextBox Extends Control
	Private:
	Protected:
		#ifdef __USE_GTK__
			Declare Static Sub Entry_Activate(entry As GtkEntry Ptr, user_data As Any Ptr)
			Declare Static Sub Entry_Changed(entry As GtkEntry Ptr, user_data As Any Ptr)
			Declare Static Function Entry_FocusInEvent(widget As GtkWidget Ptr, Event As GdkEventFocus Ptr, user_data As Any Ptr) As Boolean
			Declare Static Function Entry_FocusOutEvent(widget As GtkWidget Ptr, Event As GdkEventFocus Ptr, user_data As Any Ptr) As Boolean
			Declare Static Sub Entry_CopyClipboard(widget As GtkWidget Ptr, user_data As Any Ptr)
			Declare Static Sub Entry_CutClipboard(widget As GtkWidget Ptr, user_data As Any Ptr)
			Declare Static Sub Entry_PasteClipboard(widget As GtkWidget Ptr, user_data As Any Ptr)
			Declare Static Sub TextView_SetScrollAdjustments(textview As GtkTextView Ptr, arg1 As GtkAdjustment Ptr, arg2 As GtkAdjustment Ptr, user_data As Any Ptr)
			Declare Static Sub TextBuffer_Changed(TextBuffer As GtkTextBuffer Ptr, user_data As Any Ptr)
			Declare Static Sub Adjustment_ValueChanged(adjustment As GtkAdjustment Ptr, user_data As Any Ptr)
			Declare Static Sub Preedit_Changed(self As GtkWidget Ptr, preedit As gchar Ptr, user_data As Any Ptr)
			Declare Static Sub Entry_InsertText(self As GtkEditable Ptr, new_text As gchar Ptr, new_text_length As gint, position As gint Ptr, user_data As Any Ptr)
		#else
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#endif
		FTopLine          As Integer
		FSelStart         As Integer
		FSelLength        As Integer
		FSelEnd           As Integer
		FSelText          As WString Ptr
		FLine             As WString Ptr
		FCharCase         As CharCases
		FMasked           As Boolean
		FMaskChar         As WString Ptr
		FAlignment        As Integer
		FBorderStyle      As BorderStyles
		FReadOnly         As Boolean
		FCtl3D            As Boolean
		FHideSelection    As Boolean
		FOEMConvert       As Boolean
		FMaxLength        As Integer
		FModified         As Boolean
		FLeftMargin       As Integer
		FNumbersOnly      As Boolean
		FRightMargin      As Integer
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
			Declare Sub ChangeWidget()
		#else
			Declare Static Sub WndProc(ByRef message As Message)
			Declare Virtual Sub SetDark(Value As Boolean)
		#endif
		Declare Virtual Sub ProcessMessage(ByRef message As Message)
	Public:
		#ifndef ReadProperty_Off
			'Reads property from storage.
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Writes property to storage.
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Appends a new line of text.
		Declare Sub AddLine(ByRef wsLine As WString)
		'Inserts text line at specified position.
		Declare Sub InsertLine(Index As Integer, ByRef wsLine As WString)
		'Deletes specified line.
		Declare Sub RemoveLine(Index As Integer)
		'Retrieves current selection range.
		Declare Sub GetSel(ByRef iSelStart As Integer, ByRef iSelEnd As Integer)
		'Retrieves current selection range.
		Declare Sub GetSel(ByRef iSelStartRow As Integer, ByRef iSelStartCol As Integer, ByRef iSelEndRow As Integer, ByRef iSelEndCol As Integer)
		'Sets text selection range.
		Declare Sub SetSel(iSelStart As Integer, iSelEnd As Integer)
		'Sets text selection range.
		Declare Sub SetSel(iSelStartRow As Integer, iSelStartCol As Integer, iSelEndRow As Integer, iSelEndCol As Integer)
		'Returns line number from character index.
		Declare Function GetLineFromCharIndex(Index As Integer = -1) As Integer
		'Returns character index for line start.
		Declare Function GetCharIndexFromLine(Index As Integer) As Integer
		'Returns character count of specified line.
		Declare Function GetLineLength(Index As Integer) As Integer
		Declare Property Alignment As AlignmentConstants
		'Gets or sets the horizontal alignment of text in the TextBox.
		Declare Property Alignment(Value As AlignmentConstants)
		Declare Property BorderStyle As BorderStyles
		'Specifies the border style of the TextBox (None, FixedSingle, etc).
		Declare Property BorderStyle(Value As BorderStyles)
		Declare Property ReadOnly As Boolean
		'Determines if text is editable.
		Declare Property ReadOnly(Value As Boolean)
		Declare Property Ctl3D As Boolean
		'Controls whether the TextBox has a 3D appearance.
		Declare Property Ctl3D(Value As Boolean)
		Declare Property HideSelection As Boolean
		'Determines if selected text remains highlighted when focus is lost.
		Declare Property HideSelection(Value As Boolean)
		Declare Property OEMConvert As Boolean
		'Controls OEM/ANSI character conversion during input.
		Declare Property OEMConvert(Value As Boolean)
		Declare Property MaxLength As Integer
		'Maximum number of characters allowed in the control.
		Declare Property MaxLength(Value As Integer)
		Declare Property Modified As Boolean
		'Indicates whether text has been changed since last save/load.
		Declare Property Modified(Value As Boolean)
		Declare Property CharCase As CharCases
		'Determines if text is automatically converted to uppercase/lowercase.
		Declare Property CharCase(Value As CharCases)
		Declare Property Masked As Boolean
		'Indicates whether input masking is enabled.
		Declare Property Masked(Value As Boolean)
		Declare Property MaskChar ByRef As WString
		'Specifies the character used for password masking.
		Declare Property MaskChar(ByRef Value As WString)
		Declare Property NumbersOnly As Boolean
		'Restricts input to numeric characters.
		Declare Property NumbersOnly(Value As Boolean)
		Declare Property LeftMargin As Integer
		'Sets the left margin width in pixels.
		Declare Property LeftMargin(Value As Integer)
		Declare Property RightMargin As Integer
		'Sets the right margin width in pixels.
		Declare Property RightMargin(Value As Integer)
		'Gets or sets the text content as an array of strings.
		Declare Property Lines(Index As Integer) ByRef As WString
		'Gets or sets the text content as an array of strings.
		Declare Property Lines(Index As Integer, ByRef Value As WString)
		'Gets or sets the text content as an array of strings.
		Declare Function LinesCount As Integer
		Declare Property CaretPos As My.Sys.Drawing.Point
		'Gets or sets the current caret position (text insertion point).
		Declare Property CaretPos(Value As My.Sys.Drawing.Point)
		Declare Property SelStart As Integer
		'Gets or sets the start position of selected text.
		Declare Property SelStart(Value As Integer)
		Declare Property SelEnd As Integer
		'Gets or sets the end position of selected text.
		Declare Property SelEnd(Value As Integer)
		Declare Property SelLength As Integer
		'Gets or sets the number of selected characters.
		Declare Property SelLength(Value As Integer)
		Declare Property SelText ByRef As WString
		'Gets or sets the currently selected text.
		Declare Property SelText(ByRef Value As WString)
		Declare Property ScrollBars As ScrollBarsType
		'Controls visibility of horizontal/vertical scrollbars.
		Declare Property ScrollBars(Value As ScrollBarsType)
		Declare Property TabIndex As Integer
		'Controls focus order in tab navigation.
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		'Determines if control can receive focus via Tab key.
		Declare Property TabStop(Value As Boolean)
		Declare Property Text ByRef As WString
		'Gets or sets the text contents.
		Declare Property Text(ByRef Value As WString)
		Declare Property TopLine As Integer
		'Gets/sets the index of the topmost visible line.
		Declare Property TopLine(Value As Integer)
		Declare Property WordWraps As Boolean
		'Determines automatic line wrapping behavior.
		Declare Property WordWraps(Value As Boolean)
		'Controls Enter key behavior in multiline mode.
		Declare Property WantReturn() As Boolean
		'Controls Enter key behavior in multiline mode.
		Declare Property WantReturn(Value As Boolean)
		'Controls Tab key behavior in multiline mode.
		Declare Property WantTab() As Boolean
		'Controls Tab key behavior in multiline mode.
		Declare Property WantTab(Value As Boolean)
		'Determines if multiple lines of text are allowed.
		Declare Property Multiline() As Boolean
		'Determines if multiple lines of text are allowed.
		Declare Property Multiline(Value As Boolean)
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		'Clears all text content.
		Declare Sub Clear
		'Resets the undo buffer.
		Declare Sub ClearUndo
		'Checks if undo operation is available.
		Declare Function CanUndo As Boolean
		'Returns total character count.
		Declare Function GetTextLength() As Integer
		'Reverses last edit operation.
		Declare Sub Undo
		'Pastes content from clipboard.
		Declare Sub PasteFromClipboard
		'Copies selected text to clipboard.
		Declare Sub CopyToClipboard
		'Cuts selected text to clipboard.
		Declare Sub CutToClipboard
		'Declare Sub Delete
		Declare Sub SelectAll
		'Scrolls view to caret position.
		Declare Sub ScrollToCaret
		'Scrolls view to end line.
		Declare Sub ScrollToEnd
		'Scrolls view to line position.
		Declare Sub ScrollToLine(LineNumber As Integer)
		'Loads text content from file.
		Declare Sub LoadFromFile(ByRef File As WString)
		'Saves text content to file.
		Declare Sub SaveToFile(ByRef File As WString)
		'Applies input restriction filter.
		Declare Sub InputFilter(ByRef Value As WString) 'David Change
		Declare Constructor
		Declare Destructor
		'Raised when control becomes active.
		OnActivate  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TextBox)
		'Raised when text content changes.
		OnChange    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TextBox)
		'Raised when control receives focus.
		OnGotFocus  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TextBox)
		'Raised when control loses focus.
		OnLostFocus As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TextBox)
		'OnHScroll  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TextBox)
		'OnVScroll  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TextBox)
		OnCut       As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TextBox)
		'Raised after text is copied to clipboard.
		OnCopy      As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TextBox)
		'Raised after text is pasted from clipboard.
		OnPaste     As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TextBox, ByRef Action As Integer)
		'Raises the Update event.
		OnUpdate    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TextBox, ByRef NewText As WString)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "TextBox.bas"
#endif
