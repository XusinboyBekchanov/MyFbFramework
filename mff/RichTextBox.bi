'################################################################################
'#  RichTextBox.bi                                                              #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#include once "TextBox.bi"

Namespace My.Sys.Forms
	#define QRichTextBox(__Ptr__) *Cast(RichTextBox Ptr,__Ptr__)
	
	Private Type RichTextBox Extends TextBox
	Private:
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			Declare Static Function StreamInProc(hFile As Handle, pBuffer As PVOID, NumBytes As Integer, pBytesRead As Integer Ptr) As BOOL
			Declare Static Function StreamOutProc (hFile As Handle, pBuffer As PVOID, NumBytes As Integer, pBytesWritten As Integer Ptr) As BOOL
			Declare Static Function GetTextCallback(dwCookie As DWORD_PTR, pbBuff As Byte Ptr, cb As Long, pcb As Long Ptr) As DWORD
		#else
			Declare Function GetStrProperty(sProperty As String) ByRef As WString
			Declare Sub SetStrProperty(sProperty As String, ByRef Value As WString, WithoutPrevValue As Boolean = False)
			Declare Function GetIntProperty(sProperty As String) As Integer
			Declare Sub SetIntProperty(sProperty As String, Value As Integer)
			Declare Function GetBoolProperty(sProperty As String, NeedValue As Integer) As Boolean
			Declare Sub SetBoolProperty(sProperty As String, Value As Boolean, TrueValue As Integer, FalseValue As Integer)
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
		Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Declare Function CanRedo As Boolean
		Declare Function GetCharIndexFromPos(p As My.Sys.Drawing.Point) As Integer
		Declare Function GetTextRange(cpMin As Integer, cpMax As Integer) ByRef As WString
		Declare Function Find(ByRef Value As WString) As Boolean
		Declare Function FindNext(ByRef Value As WString = "") As Boolean
		Declare Function FindPrev(ByRef Value As WString = "") As Boolean
		Declare Function BottomLine As Integer
		Declare Property SelAlignment As AlignmentConstants
		Declare Property SelAlignment(Value As AlignmentConstants)
		Declare Property SelBackColor As Integer
		Declare Property SelBackColor(Value As Integer)
		Declare Property SelBullet As Boolean
		Declare Property SelBullet(Value As Boolean)
		Declare Property SelIndent As Integer
		Declare Property SelIndent(Value As Integer)
		Declare Property SelRightIndent As Integer
		Declare Property SelRightIndent(Value As Integer)
		Declare Property SelHangingIndent As Integer
		Declare Property SelHangingIndent(Value As Integer)
		Declare Property SelTabCount As Integer
		Declare Property SelTabCount(Value As Integer)
		Declare Property SelTabs(sElement As Integer) As Integer
		Declare Property SelTabs(sElement As Integer, Value As Integer)
		Declare Property SelFontName ByRef As WString
		Declare Property SelFontName(ByRef Value As WString)
		Declare Property SelFontSize As Integer
		Declare Property SelFontSize(Value As Integer)
		Declare Property SelBold As Boolean
		Declare Property SelBold(Value As Boolean)
		Declare Property SelItalic As Boolean
		Declare Property SelItalic(Value As Boolean)
		Declare Property SelUnderline As Boolean
		Declare Property SelUnderline(Value As Boolean)
		Declare Property SelStrikeout As Boolean
		Declare Property SelStrikeout(Value As Boolean)
		Declare Property SelProtected As Boolean
		Declare Property SelProtected(Value As Boolean)
		Declare Property SelCharOffset As Integer
		Declare Property SelCharOffset(Value As Integer)
		Declare Property SelCharSet As Integer
		Declare Property SelCharSet(Value As Integer)
		Declare Property SelText ByRef As WString
		Declare Property SelText(ByRef Value As WString)
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		Declare Property TextRTF As String
		Declare Property TextRTF(Value As String)
		Declare Property SelColor As Integer
		Declare Property SelColor(Value As Integer)
		Declare Property EditStyle As Boolean
		Declare Property EditStyle(Value As Boolean)
		Declare Property Zoom As Integer
		Declare Property Zoom(Value As Integer)
		Declare Function AddImage(ByRef Bitm As My.Sys.Drawing.BitmapType) As Boolean
		Declare Function AddImage(ByRef Bitm As My.Sys.Drawing.Icon) As Boolean
		Declare Function AddImage(ByRef Bitm As My.Sys.Drawing.Cursor) As Boolean
		Declare Function AddImage(ByRef ResName As WString) As Boolean
		Declare Function AddImageFromFile(ByRef File As WString) As Boolean
		Declare Function SelPrint(ByRef Canvas As My.Sys.Drawing.Canvas) As Boolean
		Declare Sub LoadFromFile(ByRef File As WString, bRTF As Boolean)
		Declare Sub SaveToFile(ByRef File As WString, bRTF As Boolean)
		Declare Sub Undo
		Declare Sub Redo
		Declare Operator Cast As My.Sys.Forms.Control Ptr
		Declare Constructor
		Declare Destructor
		OnSelChange As Sub(ByRef Sender As RichTextBox)
		OnProtectChange As Sub(ByRef Sender As RichTextBox, SelStart As Integer, SelEnd As Integer, ByRef AllowChange As Boolean)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "RichTextBox.bas"
#endif
