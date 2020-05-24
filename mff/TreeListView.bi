'################################################################################
'#  TreeListView.bi                                                             #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#include once "ListView.bi"

Namespace My.Sys.Forms
	#define QTreeListView(__Ptr__) *Cast(TreeListView Ptr,__Ptr__)
	#define QTreeListViewItem(__Ptr__) *Cast(TreeListViewItem Ptr,__Ptr__)
	#define QTreeListViewColumn(__Ptr__) *Cast(TreeListViewColumn Ptr,__Ptr__)
	
	Type PTreeListViewItem As TreeListViewItem Ptr
	
	Type TreeListViewItems
	Private:
		FItems As List
		PItem As PTreeListViewItem
		FParentItem As PTreeListViewItem
		#ifndef __USE_GTK__
			lvi As LVITEM
		#endif
	Public:
		#ifdef __USE_GTK__
			Declare Function FindByIterUser_Data(User_Data As Any Ptr) As PTreeListViewItem
		#else
			Declare Function FindByHandle(Value As LParam) As PTreeListViewItem
		#endif
		Parent   As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Item(Index As Integer) As PTreeListViewItem
		Declare Property Item(Index As Integer, Value As PTreeListViewItem)
		Declare Function Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0) As PTreeListViewItem
		Declare Function Add(ByRef FCaption As WString = "", ByRef FImageKey As WString, State As Integer = 0, Indent As Integer = 0) As PTreeListViewItem
		Declare Function Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0) As PTreeListViewItem
		Declare Sub Remove(Index As Integer)
		Declare Property ParentItem As PTreeListViewItem
		Declare Property ParentItem(Value As PTreeListViewItem)
		Declare Function IndexOf(BYREF FItem As PTreeListViewItem) As Integer
		Declare Function IndexOf(ByRef FCaption As WString) As Integer
		Declare Function Contains(ByRef FCaption As WString) As Boolean
		Declare Sub Clear
		Declare Sub Sort
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	Type TreeListViewItem Extends My.Sys.Object
	Private:
		FText               As WString Ptr
		FSubItems           As WStringList
		FHint               As WString Ptr
		FImageIndex         As Integer
		FSelectedImageIndex As Integer
		FSmallImageIndex    As Integer
		FImageKey           As WString Ptr
		FSelectedImageKey   As WString Ptr
		FSmallImageKey      As WString Ptr
		FParentItem As PTreeListViewItem
		FVisible            As Boolean
		FState              As Integer
		FIndent             As Integer
		FExpanded			As Boolean
		#IfNDef __USE_GTK__
			Dim lvi             As LVITEM
		#EndIf
	Protected:
		#ifndef __USE_GTK__
			
		#endif
	Public:
		#ifdef __USE_GTK__
			TreeIter As GtkTreeIter
		#else
			Handle As LParam
			Declare Function GetItemIndex() As Integer
		#endif
		Parent   As Control Ptr
		Items As TreeListViewItems
		Tag As Any Ptr
		Declare Sub SelectItem
		Declare Sub Collapse
		Declare Sub Expand
		Declare Function IsExpanded As Boolean
		Declare Function Index As Integer
		Declare Property Text(iSubItem As Integer) ByRef As WString
		Declare Property Text(iSubItem As Integer, ByRef Value As WString)
		Declare Property Hint ByRef As WString
		Declare Property Hint(ByRef Value As WString)
		Declare Property ParentItem As PTreeListViewItem
		Declare Property ParentItem(Value As PTreeListViewItem)
		Declare Property ImageIndex As Integer
		Declare Property ImageIndex(Value As Integer)
		Declare Property SelectedImageIndex As Integer
		Declare Property SelectedImageIndex(Value As Integer)
		Declare Property SmallImageIndex As Integer
		Declare Property SmallImageIndex(Value As Integer)
		Declare Property ImageKey ByRef As WString
		Declare Property ImageKey(ByRef Value As WString)
		Declare Property SelectedImageKey ByRef As WString
		Declare Property SelectedImageKey(ByRef Value As WString)
		Declare Property SmallImageKey ByRef As WString
		Declare Property SmallImageKey(ByRef Value As WString)
		Declare Property Visible As Boolean
		Declare Property Visible(Value As Boolean)
		Declare Property State As Integer
		Declare Property State(Value As Integer)
		Declare Property Indent As Integer
		Declare Property Indent(Value As Integer)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		OnClick As Sub(BYREF Sender As My.Sys.Object)
		OnDblClick As Sub(BYREF Sender As My.Sys.Object)
	End Type
	
	Type TreeListViewColumn Extends My.Sys.Object
	Private:
		FText            As WString Ptr
		FHint            As WString Ptr
		FImageIndex   As Integer
		FWidth      As Integer
		FFormat      As ColumnFormat
		FVisible      As Boolean
		FEditable	 As Boolean
	Public:
		#IfDef __USE_GTK__
			Dim As GtkTreeViewColumn Ptr Column
		#EndIf
		Index As Integer
		Parent   As Control Ptr
		Declare Sub SelectItem
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Property Hint ByRef As WString
		Declare Property Hint(ByRef Value As WString)
		Declare Property ImageIndex As Integer
		Declare Property ImageIndex(Value As Integer)
		Declare Property Visible As Boolean
		Declare Property Visible(Value As Boolean)
		Declare Property Editable As Boolean
		Declare Property Editable(Value As Boolean)
		Declare Property Width As Integer
		Declare Property Width(Value As Integer)
		Declare Property Format As ColumnFormat
		Declare Property Format(Value As ColumnFormat)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		OnClick As Sub(BYREF Sender As My.Sys.Object)
		OnDblClick As Sub(BYREF Sender As My.Sys.Object)
	End Type
	
	Type TreeListViewColumns
	Private:
		FColumns As List
		#IfDef __USE_GTK__
			Declare Static Sub Cell_Edited(renderer As GtkCellRendererText Ptr, path As gchar Ptr, new_text As gchar Ptr, user_data As Any Ptr)
			Declare Static Sub Cell_Editing(cell As GtkCellRenderer Ptr, editable As GtkCellEditable Ptr, path As const gchar Ptr, user_data As Any Ptr)
		#EndIf
	Public:
		Parent   As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Column(Index As Integer) As TreeListViewColumn Ptr
		Declare Property Column(Index As Integer, Value As TreeListViewColumn Ptr)
		Declare Function Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As ColumnFormat = cfLeft, Editable As Boolean = False) As TreeListViewColumn Ptr
		Declare Sub Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As ColumnFormat = cfLeft)
		Declare Sub Remove(Index As Integer)
		Declare Function IndexOf(BYREF FColumn As TreeListViewColumn Ptr) As Integer
		Declare Sub Clear
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	Type TreeListView Extends Control
	Private:
		FView As ViewStyle
		FColumnHeaderHidden As Boolean
		FSingleClickActivate As Boolean
		FSortStyle As SortStyle
		Declare Static Sub WndProc(BYREF Message As Message)
		Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
		Declare Static Sub HandleIsDestroyed(BYREF Sender As Control)
		Declare Sub ProcessMessage(BYREF Message As Message)
	Protected:
		#IfDef __USE_GTK__
			Declare Static Function TreeListView_TestExpandRow(tree_view As GtkTreeView Ptr, iter As GtkTreeIter Ptr, path As GtkTreePath Ptr, user_data As Any Ptr) As Boolean
		#else
			Declare Function GetTreeListViewItem(Item As Integer) As TreeListViewItem Ptr
		#endif
	Public:
		#ifdef __USE_GTK__
			TreeStore As GtkTreeStore Ptr
			TreeSelection As GtkTreeSelection Ptr
			ColumnTypes As GType Ptr
		#endif
		Declare Sub Init()
		ListItems         As TreeListViewItems
		Columns         As TreeListViewColumns
		Images          As ImageList Ptr
		StateImages       As ImageList Ptr
		SmallImages       As ImageList Ptr
		GroupHeaderImages       As ImageList Ptr
		Declare Sub CollapseAll
		Declare Sub ExpandAll
		Declare Property ColumnHeaderHidden As Boolean
		Declare Property ColumnHeaderHidden(Value As Boolean)
		Declare Property ShowHint As Boolean
		Declare Property ShowHint(Value As Boolean)
		Declare Property View As ViewStyle
		Declare Property View(Value As ViewStyle)
		Declare Property Sort As SortStyle
		Declare Property Sort(Value As SortStyle)
		Declare Property SelectedItem As TreeListViewItem Ptr
		Declare Property SelectedItem(Value As TreeListViewItem Ptr)
		Declare Property SelectedItemIndex As Integer
		Declare Property SelectedItemIndex(Value As Integer)
		Declare Property SelectedColumn As TreeListViewColumn Ptr
		Declare Property SelectedColumn(Value As TreeListViewColumn Ptr)
		Declare Property SingleClickActivate As Boolean
		Declare Property SingleClickActivate(Value As Boolean)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnItemActivate As Sub(ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr)
		OnItemClick As Sub(ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr)
		OnItemDblClick As Sub(ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr)
		OnItemKeyDown As Sub(ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr)
		OnItemExpanding As Sub(ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr)
		OnCellEditing As Sub(ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr, ByVal SubItemIndex As Integer, CellEditor As Control Ptr)
		OnCellEdited As Sub(ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr, ByVal SubItemIndex As Integer, ByRef NewText As WString)
		OnSelectedItemChanged As Sub(ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr)
		OnBeginScroll As Sub(ByRef Sender As TreeListView)
		OnEndScroll As Sub(ByRef Sender As TreeListView)
	End Type
End Namespace

#IfNDef __USE_MAKE__
	#Include Once "TreeListView.bas"
#EndIf
