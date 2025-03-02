'################################################################################
'#  RichTextBox.bi                                                              #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#include once "TextBox.bi"

Namespace My.Sys.Forms
	#define QRichTextBox(__Ptr__) (*Cast(RichTextBox Ptr,__Ptr__))
	
	'`RichTextBox` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`RichTextBox` - The RichTextBox control enables you to display or edit flow content including paragraphs, images, tables, and more.
	Private Type RichTextBox Extends TextBox
	Private:
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			Declare Static Function StreamInProc(hFile As ..HANDLE, pBuffer As PVOID, NumBytes As Integer, pBytesRead As Integer Ptr) As BOOL
			Declare Static Function StreamOutProc (hFile As ..HANDLE, pBuffer As PVOID, NumBytes As Integer, pBytesWritten As Integer Ptr) As BOOL
			Declare Static Function GetTextCallback(dwCookie As DWORD_PTR, pbBuff As Byte Ptr, cb As Long, pcb As Long Ptr) As DWORD
			Declare Virtual Sub SetDark(Value As Boolean)
		#else
			Declare Function GetStrProperty(sProperty As String) ByRef As WString
			Declare Sub SetStrProperty(sProperty As String, ByRef Value As WString, WithoutPrevValue As Boolean = False)
			Declare Function GetIntProperty(sProperty As String) As Integer
			Declare Sub SetIntProperty(sProperty As String, Value As Integer)
			Declare Function GetBoolProperty(sProperty As String, NeedValue As Integer) As Boolean
			Declare Sub SetBoolProperty(sProperty As String, Value As Boolean, TrueValue As Integer, FalseValue As Integer, StartChar As Integer = -1, EndChar As Integer = -1)
		#endif
		FFindText           As WString Ptr
		FTextRange          As WString Ptr
		FTextRTF            As UString
		FSelWStrVal         As WString Ptr
		FSelIntVal          As Integer
		FSelBoolVal         As Integer
	Protected:
		#ifndef __USE_GTK__
			hRichTextBox    As HINSTANCE
			Pf              As PARAFORMAT
			Pf2             As PARAFORMAT2
			Cf              As CHARFORMAT
			Cf2             As CHARFORMAT2
		#endif
		FEditStyle As Boolean
		FZoom As Integer
		Declare Virtual Sub ProcessMessage(ByRef message As Message)
	Public:
		#ifndef ReadProperty_Off
			'Reads persisted properties.
			Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Persists properties.
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Checks redo availability.
		Declare Function CanRedo As Boolean
		'Converts coordinates to char index.
		Declare Function GetCharIndexFromPos(p As My.Sys.Drawing.Point) As Integer
		'Extracts text from range.
		Declare Function GetTextRange(cpMin As Integer, cpMax As Integer) ByRef As WString
		'Searches for text with options.
		Declare Function Find(ByRef Value As WString) As Boolean
		'Continues forward search.
		'Searches for text with options.
		Declare Function FindNext(ByRef Value As WString = "") As Boolean
		'Continues backward search.
		'Searches for text with options.
		Declare Function FindPrev(ByRef Value As WString = "") As Boolean
		'Scrolls to last visible line.
		Declare Function BottomLine As Integer
		Declare Property SelAlignment As AlignmentConstants
		'Alignment of selected paragraphs.
		Declare Property SelAlignment(Value As AlignmentConstants)
		Declare Property SelBackColor As Integer
		'Background color of selection.
		Declare Property SelBackColor(Value As Integer)
		Declare Property SelBullet As Boolean
		'Bulleted list formatting for selection.
		Declare Property SelBullet(Value As Boolean)
		Declare Property SelIndent As Integer
		'Left indent of selected paragraphs.
		Declare Property SelIndent(Value As Integer)
		Declare Property SelRightIndent As Integer
		'Right indent of selected paragraphs.
		Declare Property SelRightIndent(Value As Integer)
		Declare Property SelHangingIndent As Integer
		'Hanging indent of selection.
		Declare Property SelHangingIndent(Value As Integer)
		Declare Property SelTabCount As Integer
		'Number of tab stops in selection.
		Declare Property SelTabCount(Value As Integer)
		'Array of tab stop positions.
		Declare Property SelTabs(sElement As Integer) As Integer
		'Array of tab stop positions.
		Declare Property SelTabs(sElement As Integer, Value As Integer)
		Declare Property SelFontName ByRef As WString
		'Font name for selected text.
		Declare Property SelFontName(ByRef Value As WString)
		Declare Property SelFontSize As Integer
		'Font size for selected text.
		Declare Property SelFontSize(Value As Integer)
		Declare Property SelBold As Boolean
		'Bold state of selected text.
		Declare Property SelBold(Value As Boolean)
		Declare Property SelItalic As Boolean
		'Italic state of selected text.
		Declare Property SelItalic(Value As Boolean)
		Declare Property SelUnderline As Boolean
		'Underline state of selection.
		Declare Property SelUnderline(Value As Boolean)
		Declare Property SelStrikeout As Boolean
		'Strikethrough state of selection.
		Declare Property SelStrikeout(Value As Boolean)
		Declare Property SelProtected As Boolean
		'Protects selection from editing.
		Declare Property SelProtected(Value As Boolean)
		Declare Property SelCharOffset As Integer
		'Vertical offset for superscript/subscript.
		Declare Property SelCharOffset(Value As Integer)
		Declare Property SelCharSet As Integer
		'Character set for selected text.
		Declare Property SelCharSet(Value As Integer)
		Declare Property SelText ByRef As WString
		'Selected rich-formatted text.
		Declare Property SelText(ByRef Value As WString)
		Declare Property TabIndex As Integer
		'Tab order index.
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		'Enables tab key navigation.
		Declare Property TabStop(Value As Boolean)
		Declare Property TextRTF As UString
		'RTF-formatted text content.
		Declare Property TextRTF(Value As UString)
		Declare Property SelColor As Integer
		'Text color of selection.
		Declare Property SelColor(Value As Integer)
		Declare Property EditStyle As Boolean
		'Sets rich edit control behavior flags.
		Declare Property EditStyle(Value As Boolean)
		Declare Property Zoom As Integer
		'Zoom level percentage (10-500).
		Declare Property Zoom(Value As Integer)
		'Inserts image from memory.
		Declare Function AddImage(ByRef Bitm As My.Sys.Drawing.BitmapType) As Boolean
		'Inserts image from memory.
		Declare Function AddImage(ByRef Bitm As My.Sys.Drawing.Icon) As Boolean
		'Inserts image from memory.
		Declare Function AddImage(ByRef Bitm As My.Sys.Drawing.Cursor) As Boolean
		'Inserts image from memory.
		Declare Function AddImage(ByRef ResName As WString) As Boolean
		'Inserts image from file path.
		'Inserts image from memory.
		Declare Function AddImageFromFile(ByRef File As WString) As Boolean
		'Prints selected content.
		Declare Function SelPrint(ByRef Canvas As My.Sys.Drawing.Canvas) As Boolean
		'Loads RTF content from file.
		Declare Sub LoadFromFile(ByRef File As WString, bRTF As Boolean)
		'Saves RTF content to file.
		Declare Sub SaveToFile(ByRef File As WString, bRTF As Boolean)
		'Reverses last edit action.
		Declare Sub Undo
		'Reapplies last undone action.
		Declare Sub Redo
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		'Triggered on selection change.
		OnSelChange As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As RichTextBox)
		'Triggered when protected text changes.
		OnProtectChange As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As RichTextBox, SelStart As Integer, SelEnd As Integer, ByRef AllowChange As Boolean)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "RichTextBox.bas"
#endif
