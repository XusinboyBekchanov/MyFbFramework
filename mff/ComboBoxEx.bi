'###############################################################################
'#  ComboBoxEx.bi                                                              #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'#  Version 1.0.0                                                              #
'###############################################################################

#include once "ComboBoxEdit.bi"
#include once "ImageList.bi"

Namespace My.Sys.Forms
	#define QComboBoxEx(__Ptr__) *Cast(ComboBoxEx Ptr,__Ptr__)
	#define QComboBoxItem(__Ptr__) *Cast(ComboBoxItem Ptr,__Ptr__)
	
	'    Enum ComboBoxExStyle
	'        cbeSimple            = 0
	'        cbeDropDown
	'        cbeDropDownList
	'        cbeOwnerDrawFixed
	'        cbeOwnerDrawVariable
	'    End Enum
	
	Type ComboBoxItem Extends My.Sys.Object
	Private:
		FText            As WString Ptr
		FObject          As Any Ptr
		FHint            As WString Ptr
		FImageIndex   As Integer
		FImageKey   As WString Ptr
		FSelectedImageIndex   As Integer
		FOverlayIndex   As Integer
		FIndent   As Integer
	Public:
		#ifdef __USE_GTK__
			TreeIter As GtkTreeIter
		#endif
		Parent   As Control Ptr
		Declare Function Index As Integer
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Property Object As Any Ptr
		Declare Property Object(Value As Any Ptr)
		Declare Property Hint ByRef As WString
		Declare Property Hint(ByRef Value As WString)
		Declare Property ImageIndex As Integer
		Declare Property ImageIndex(Value As Integer)
		Declare Property ImageKey ByRef As WString
		Declare Property ImageKey(ByRef Value As WString)
		Declare Property SelectedImageIndex As Integer
		Declare Property SelectedImageIndex(Value As Integer)
		Declare Property OverlayIndex As Integer
		Declare Property OverlayIndex(Value As Integer)
		Declare Property Indent As Integer
		Declare Property Indent(Value As Integer)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	Type ComboBoxExItems
	Private:
		FItems As List
		PItem As ComboBoxItem Ptr
		#ifndef __USE_GTK__
			cbei As COMBOBOXEXITEM
		#endif
	Public:
		Parent   As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Item(Index As Integer) As ComboBoxItem Ptr
		Declare Property Item(Index As Integer, Value As ComboBoxItem Ptr)
		Declare Function Add(ByRef Caption As WString = "", Obj As Any Ptr = 0, ImageIndex As Integer = -1, SelectedImageIndex As Integer = -1, OverlayIndex As Integer = -1, Indent As Integer = 0, Index As Integer = -1) As ComboBoxItem Ptr
		Declare Function Add(ByRef Caption As WString = "", Obj As Any Ptr = 0, ByRef ImageKey As WString, ByRef SelectedImageKey As WString = "", ByRef OverlayKey As WString = "", Indent As Integer = 0, Index As Integer = -1) As ComboBoxItem Ptr
		Declare Sub Remove(Index As Integer)
		Declare Function IndexOf(ByRef Item As ComboBoxItem Ptr) As Integer
		Declare Function IndexOf(ByRef Text As WString) As Integer
		Declare Function Contains(ByRef Text As WString) As Boolean
		Declare Sub Clear
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	Type ComboBoxEx Extends ComboBoxEdit
	Private:
		'FItemIndex        As Integer
		FItemHeight       As Integer
		FIntegralHeight   As Boolean
		FDropDownCount    As Integer
		Declare Sub UpdateListHeight
		Declare Sub ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#endif
	Public:
		#ifdef __USE_GTK__
			ListStore As GtkListStore Ptr
		#endif
		Items             As ComboBoxExItems
		ImagesList         As ImageList Ptr
		'            Declare Property ItemIndex As Integer
		'            Declare Property ItemIndex(Value As Integer)
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Property IntegralHeight As Boolean
		Declare Property IntegralHeight(Value As Boolean)
		Declare Property ItemHeight As Integer
		Declare Property ItemHeight(Value As Integer)
		Declare Property DropDownCount As Integer
		Declare Property DropDownCount(Value As Integer)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "ComboBoxEx.bas"
#endif
