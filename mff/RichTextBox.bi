'################################################################################
'#  RichTextBox.bi                                                              #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#Include Once "TextBox.bi"

namespace My.Sys.Forms
	#DEFINE QRichTextBox(__Ptr__) *Cast(RichTextBox Ptr,__Ptr__)

	Dim Shared textbuffer As WString Ptr, bufferpos As Integer

	Type RichTextBox Extends TextBox
		Private:
			#IfNDef __USE_GTK__
				Declare Static Sub WndProc(BYREF message As Message)
				Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			#EndIf
			FFindText As WString Ptr
			FTextRange As WString Ptr
		Protected:
			#IfNDef __USE_GTK__
				hRichTextBox As HINSTANCE
			#EndIf
			FEditStyle As Boolean
			FZoom As Integer
			#IfNDef __USE_GTK__
				Declare Sub ProcessMessage(BYREF message As Message)
			#EndIf
		Public:
			Declare Function CanRedo As Boolean
			Declare Function GetCharIndexFromPos(p As Point) As Integer
			Declare Function GetTextRange(cpMin As Integer, cpMax As Integer) ByRef As Wstring
			Declare Function Find(ByRef Value As WString) As Boolean
			Declare Function FindNext(ByRef Value As WString = "") As Boolean
			Declare Function FindPrev(ByRef Value As WString = "") As Boolean
			Declare Function BottomLine As Integer
			Declare Property SelText ByRef As WString
			Declare Property SelText(ByRef Value As WString)
			Declare Property TextRTF ByRef As WString
			Declare Property TextRTF(ByRef Value As WString)
			Declare Property SelColor As Integer
			Declare Property SelColor(Value As Integer)
			Declare Property EditStyle As Boolean
			Declare Property EditStyle(Value As Boolean)
			Declare Property Zoom As Integer
			Declare Property Zoom(Value As Integer)
			Declare Sub LoadFromFile(ByRef File As WString, bRTF As Boolean)
			Declare Sub SaveToFile(ByRef File As WString, bRTF As Boolean)
			Declare Sub Undo
			Declare Sub Redo
			Declare Operator Cast As My.Sys.Forms.Control Ptr
			Declare Constructor
			Declare Destructor
			OnSelChange As Sub(BYREF Sender As RichTextBox)
	End Type
End Namespace

#IfNDef __USE_MAKE__
	#Include Once "RichTextBox.bas"
#EndIf
