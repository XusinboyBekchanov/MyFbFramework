'###############################################################################
'#  ComboBoxEx.bi                                                              #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'#  Version 1.0.0                                                              #
'###############################################################################

#include once "ComboBoxEdit.bi"
#include once "ImageList.bi"

Namespace My.Sys.Forms
	#define QComboBoxEx(__Ptr__) (*Cast(ComboBoxEx Ptr, __Ptr__))
	#define QComboBoxItem(__Ptr__) (*Cast(ComboBoxItem Ptr,__Ptr__))
	
	'    Enum ComboBoxExStyle
	'        cbeSimple            = 0
	'        cbeDropDown
	'        cbeDropDownList
	'        cbeOwnerDrawFixed
	'        cbeOwnerDrawVariable
	'    End Enum
	
	'`ComboBoxItem` - Represents a single item in a combo box control with support for hierarchical display and multiple icon states (Windows, Linux).
	Private Type ComboBoxItem Extends My.Sys.Object
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
			'Native tree iterator handle (GTK+)
			TreeIter As GtkTreeIter
		#endif
		'Reference to parent ComboBox
		Parent   As Control Ptr
		'Returns item's position in parent collection
		Declare Function Index As Integer
		Declare Property Text ByRef As WString
		'Display text of the item
		Declare Property Text(ByRef Value As WString)
		Declare Property Object As Any Ptr
		'Associated user-defined object
		Declare Property Object(Value As Any Ptr)
		Declare Property Hint ByRef As WString
		'Tooltip text displayed on hover
		Declare Property Hint(ByRef Value As WString)
		Declare Property ImageIndex As Integer
		'Index of default icon in parent's ImageList
		Declare Property ImageIndex(Value As Integer)
		Declare Property ImageKey ByRef As WString
		'Key name of default icon
		Declare Property ImageKey(ByRef Value As WString)
		Declare Property SelectedImageIndex As Integer
		'Icon index for selected state
		Declare Property SelectedImageIndex(Value As Integer)
		Declare Property OverlayIndex As Integer
		'Index of overlay icon in ImageList
		Declare Property OverlayIndex(Value As Integer)
		Declare Property Indent As Integer
		'Hierarchical indentation level
		Declare Property Indent(Value As Integer)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	Private Type ComboBoxExItems
	Private:
		FItems As List
		PItem As ComboBoxItem Ptr
		#ifndef __USE_GTK__
			cbei As COMBOBOXEXITEM
		#endif
	Public:
		'Reference to parent ComboBox
		Parent   As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Item(Index As Integer) As ComboBoxItem Ptr
		Declare Property Item(Index As Integer, Value As ComboBoxItem Ptr)
		Declare Function Add(ByRef Caption As WString = "", Obj As Any Ptr = 0, ImageIndex As Integer = -1, SelectedImageIndex As Integer = -1, OverlayIndex As Integer = -1, Indent As Integer = 0, Index As Integer = -1) As ComboBoxItem Ptr
		Declare Function Add(ByRef Caption As WString = "", Obj As Any Ptr = 0, ByRef ImageKey As WString, ByRef SelectedImageKey As WString = "", ByRef OverlayKey As WString = "", Indent As Integer = 0, Index As Integer = -1) As ComboBoxItem Ptr
		Declare Sub Remove(Index As Integer)
		'Returns item's position in parent collection
		Declare Function IndexOf(ByRef Item As ComboBoxItem Ptr) As Integer
		'Returns item's position in parent collection
		Declare Function IndexOf(ByRef Text As WString) As Integer
		'Returns item's position in parent collection
		Declare Function IndexOfData(pData As Any Ptr) As Integer
		Declare Function Contains(ByRef Text As WString) As Boolean
		Declare Sub Clear
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	'`ComboBoxEx` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`ComboBoxEx` - ComboBoxEx controls are combo box controls that provide native support for item images.
	Private Type ComboBoxEx Extends ComboBoxEdit
	Private:
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Declare Static Sub WNDPROC(ByRef Message As Message)
			Declare Static Function HookChildProc(hDlg As HWND, uMsg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			FComboBoxDarkMode As Boolean
		#endif
	Protected:
		Declare Sub UpdateListHeight
		
	Public:
		#ifdef __USE_GTK__
			'Pointer to native list storage structure.
			ListStore As GtkListStore Ptr
		#elseif defined(__USE_WINAPI__)
			'Enables dark theme rendering.
			Declare Virtual Sub SetDark(Value As Boolean)
		#endif
		'Collection of image-text list items.
		Items             As ComboBoxExItems
		'ImageList containing icons for list items.
		ImagesList         As ImageList Ptr
		#ifndef ReadProperty_Off
			'Loads persisted image-text properties.
			Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Persists image-text properties.
			Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Virtual Property IntegralHeight As Boolean
		'Adjusts height to prevent partial item display.
		Declare Virtual Property IntegralHeight(Value As Boolean)
		Declare Virtual Property Style As ComboBoxEditStyle
		'Display style with image support (Simple/Dropdown/DropdownList).
		Declare Virtual Property Style(Value As ComboBoxEditStyle)
		'Access items by index (default property).
		Declare Virtual Property Item(FIndex As Integer) ByRef As WString
		'Access items by index (default property).
		Declare Virtual Property Item(FIndex As Integer, ByRef FItem As WString)
		'Extended data associated with list items.
		Declare Virtual Property ItemData(FIndex As Integer) As Any Ptr
		'Extended data associated with list items.
		Declare Virtual Property ItemData(FIndex As Integer, Value As Any Ptr)
		Declare Virtual Property ItemCount As Integer
		'Total number of items in list.
		Declare Virtual Property ItemCount(Value As Integer)
		Declare Virtual Property Text ByRef As WString
		'Editable text content with image awareness.
		Declare Virtual Property Text(ByRef Value As WString)
		'Appends image-text item to list.
		Declare Virtual Sub AddItem(ByRef FItem As WString)
		'Deletes item by index with image.
		Declare Virtual Sub RemoveItem(FIndex As Integer)
		'Inserts image-text item at position.
		Declare Virtual Sub InsertItem(FIndex As Integer, ByRef FItem As WString)
		'Returns item index by text/image.
		Declare Virtual Function IndexOf(ByRef Item As WString) As Integer
		'Checks if text/image item exists.
		Declare Virtual Function Contains(ByRef Item As WString) As Boolean
		'Finds index by extended item data.
		Declare Virtual Function IndexOfData(pData As Any Ptr) As Integer
		Declare Virtual Sub Clear
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "ComboBoxEx.bas"
#endif
