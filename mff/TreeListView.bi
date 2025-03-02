'################################################################################
'#  TreeListView.bi                                                             #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#include once "ListView.bi"

Namespace My.Sys.Forms
	#define QTreeListView(__Ptr__) (*Cast(TreeListView Ptr,__Ptr__))
	#define QTreeListViewItem(__Ptr__) (*Cast(TreeListViewItem Ptr, __Ptr__))
	#define QTreeListViewColumn(__Ptr__) (*Cast(TreeListViewColumn Ptr,__Ptr__))
	
	Private Type PTreeListViewItem As TreeListViewItem Ptr
	
	'`TreeListViewItems` - Manages a collection of hierarchical items in a TreeListView control with native OS integration.
	Private Type TreeListViewItems Extends My.Sys.Object
	Private:
		FItems As List
		PItem As PTreeListViewItem
		FParentItem As PTreeListViewItem
		#ifndef __USE_GTK__
			lvi As LVITEM
		#endif
	Public:
		#ifdef __USE_GTK__
			'Finds item via GTK+ iterator data
			Declare Function FindByIterUser_Data(User_Data As Any Ptr) As PTreeListViewItem
		#else
			'Locates item via native OS handle
			Declare Function FindByHandle(Value As LPARAM) As PTreeListViewItem
		#endif
		'Reference to parent TreeListView control
		Parent   As Control Ptr
		Declare Property Count As Integer
		'Total number of items in the collection
		Declare Property Count(Value As Integer)
		'Indexer accessing items by position/key
		Declare Property Item(Index As Integer) As PTreeListViewItem
		'Indexer accessing items by position/key
		Declare Property Item(Index As Integer, Value As PTreeListViewItem)
		'Creates and appends new item
		Declare Function Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0) As PTreeListViewItem
		'Creates and appends new item
		Declare Function Add(ByRef FCaption As WString = "", ByRef FImageKey As WString, State As Integer = 0, Indent As Integer = 0) As PTreeListViewItem
		'Adds item at specified position
		Declare Function Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0) As PTreeListViewItem
		'Deletes specified item
		Declare Sub Remove(Index As Integer)
		Declare Property ParentItem As PTreeListViewItem
		'Parent node in hierarchical structure
		Declare Property ParentItem(Value As PTreeListViewItem)
		'Returns position index of item
		Declare Function IndexOf(ByRef FItem As PTreeListViewItem) As Integer
		'Returns position index of item
		Declare Function IndexOf(ByRef FCaption As WString) As Integer
		'Verifies item existence in collection
		Declare Function Contains(ByRef FCaption As WString) As Boolean
		Declare Property TabIndex As Integer
		'Position in tab navigation order
		Declare Property TabIndex(Value As Integer)
		'Removes all items from collection
		Declare Sub Clear
		'Alphabetically sorts items
		Declare Sub Sort
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	'`TreeListViewItem` - Represents a hierarchical item in a TreeListView control with multi-state icons and native tree model integration.
	Private Type TreeListViewItem Extends My.Sys.Object
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
		#ifndef __USE_GTK__
			Dim lvi             As LVITEM
		#endif
	Protected:
		#ifndef __USE_GTK__
			Declare Static Sub DeleteItems(Node As TreeListViewItem Ptr)
			Declare Static Function GetVisibleItemsCount(Node As TreeListViewItem Ptr) As Integer
			Declare Static Function GetTreeListViewItemIndex(Node As TreeListViewItem Ptr, iItem As TreeListViewItem Ptr, ByRef iCount As Integer) As Integer
		#endif
		Declare Static Sub AddItems(Node As TreeListViewItem Ptr)
	Public:
		#ifdef __USE_GTK__
			'GTK+ tree model iterator reference
			TreeIter As GtkTreeIter
		#else
			'Native OS handle (WinAPI/GTK+)
			Handle As LPARAM
			'Returns position in parent collection
			Declare Function GetItemIndex() As Integer
		#endif
		'Reference to parent TreeListView
		Parent   As Control Ptr
		'Child items collection
		Nodes As TreeListViewItems
		'User-defined associated data
		Tag As Any Ptr
		'Highlights item as selected
		Declare Sub SelectItem
		'Hides child items
		Declare Sub Collapse
		'Reveals child items
		Declare Sub Expand
		'Returns true if expanded
		Declare Function IsExpanded As Boolean
		'Alias for GetItemIndex
		Declare Function Index As Integer
		'Display text in first column
		Declare Property Text(iSubItem As Integer) ByRef As WString
		'Display text in first column
		Declare Property Text(iSubItem As Integer, ByRef Value As WString)
		Declare Property Hint ByRef As WString
		'Tooltip text displayed on hover
		Declare Property Hint(ByRef Value As WString)
		Declare Property ParentItem As PTreeListViewItem
		'Parent node in hierarchy
		Declare Property ParentItem(Value As PTreeListViewItem)
		Declare Property ImageIndex As Integer
		'Default icon index in parent's ImageList
		Declare Property ImageIndex(Value As Integer)
		Declare Property SelectedImageIndex As Integer
		'Icon index when item is selected
		Declare Property SelectedImageIndex(Value As Integer)
		Declare Property SmallImageIndex As Integer
		'Index of small variant icon
		Declare Property SmallImageIndex(Value As Integer)
		Declare Property ImageKey ByRef As WString
		'Key name of default icon
		Declare Property ImageKey(ByRef Value As WString)
		Declare Property SelectedImageKey ByRef As WString
		'Key name of selected state icon
		Declare Property SelectedImageKey(ByRef Value As WString)
		Declare Property SmallImageKey ByRef As WString
		'Key name of small icon variant
		Declare Property SmallImageKey(ByRef Value As WString)
		Declare Property Visible As Boolean
		'Controls item visibility in view
		Declare Property Visible(Value As Boolean)
		Declare Property State As Integer
		'Current state flags (Expanded/Selected)
		Declare Property State(Value As Integer)
		Declare Property Indent As Integer
		'Hierarchical indentation level
		Declare Property Indent(Value As Integer)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		'Triggered on single mouse click
		OnClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object)
		'Triggered on double mouse click
		OnDblClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object)
	End Type
	
	'`TreeListViewColumn` - Defines display and interaction rules for a column in a hierarchical TreeListView control.
	Private Type TreeListViewColumn Extends My.Sys.Object
	Private:
		FText            As WString Ptr
		FHint            As WString Ptr
		FImageIndex   As Integer
		FWidth      As Integer
		FFormat      As ColumnFormat
		FVisible      As Boolean
		FEditable    As Boolean
	Public:
		#ifdef __USE_GTK__
			Dim As GtkTreeViewColumn Ptr Column
			Dim As GtkCellRenderer Ptr rendertext
		#endif
		'Zero-based position in column collection
		Index As Integer
		'Reference to parent TreeListView control
		Parent   As Control Ptr
		'Highlights all cells in the column
		Declare Sub SelectItem
		Declare Property Text ByRef As WString
		'Header text displayed for the column
		Declare Property Text(ByRef Value As WString)
		Declare Property Hint ByRef As WString
		'Tooltip text displayed on column header hover
		Declare Property Hint(ByRef Value As WString)
		Declare Property ImageIndex As Integer
		'Index of header icon in parent's ImageList
		Declare Property ImageIndex(Value As Integer)
		Declare Property Visible As Boolean
		'Controls column visibility
		Declare Property Visible(Value As Boolean)
		Declare Property Editable As Boolean
		'Enables in-cell editing for this column
		Declare Property Editable(Value As Boolean)
		Declare Property Width As Integer
		'Display width in pixels
		Declare Property Width(Value As Integer)
		Declare Property Format As ColumnFormat
		'Data formatting pattern (e.g., currency/datetime)
		Declare Property Format(Value As ColumnFormat)
		'Refreshes column display properties
		Declare Sub Update
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		'Triggered on column header click
		OnClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object)
		'Triggered on column header double-click
		OnDblClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object)
	End Type
	
	Private Type TreeListViewColumns Extends My.Sys.Object
	Private:
		FColumns As List
		#ifdef __USE_GTK__
			Declare Static Sub Cell_Edited(renderer As GtkCellRendererText Ptr, path As gchar Ptr, new_text As gchar Ptr, user_data As Any Ptr)
			Declare Static Sub Cell_Editing(cell As GtkCellRenderer Ptr, editable As GtkCellEditable Ptr, path As Const gchar Ptr, user_data As Any Ptr)
		#endif
	Public:
		'Reference to parent TreeListView control
		Parent   As Control Ptr
		Declare Property Count As Integer
		'Total number of items in the collection
		Declare Property Count(Value As Integer)
		Declare Property Column(Index As Integer) As TreeListViewColumn Ptr
		Declare Property Column(Index As Integer, Value As TreeListViewColumn Ptr)
		'Creates and appends new item
		Declare Function Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As ColumnFormat = cfLeft, ColEditable As Boolean = False) As TreeListViewColumn Ptr
		'Adds item at specified position
		Declare Sub Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As ColumnFormat = cfLeft)
		'Deletes specified item
		Declare Sub Remove(Index As Integer)
		'Zero-based position in column collection
		Declare Function IndexOf(ByRef FColumn As TreeListViewColumn Ptr) As Integer
		'Removes all items from collection
		Declare Sub Clear
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	'`TreeListView` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`TreeListView` - Combines the features of a `TreeView` and a `ListView`.
	Private Type TreeListView Extends Control
	Private:
		FColumnHeaderHidden As Boolean
		FGridLines As Boolean
		FEditLabels As Boolean
		FMultiSelect As Boolean
		FSingleClickActivate As Boolean
		FSortStyle As SortStyle
		FOwnerDraw As Boolean
		FPressedSubItem As Integer
		FLVExStyle As Integer
		FItemHeight As Integer
		FOwnerData As Boolean
		Declare Sub ChangeLVExStyle(iStyle As Integer, Value As Boolean)
		Declare Static Sub WndProc(ByRef Message As Message)
		Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		Declare Static Sub HandleIsDestroyed(ByRef Sender As Control)
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Protected:
		#ifdef __USE_GTK__
			Dim As GtkCellRenderer Ptr rendertext
			Declare Static Function TreeListView_TestExpandRow(tree_view As GtkTreeView Ptr, iter As GtkTreeIter Ptr, path As GtkTreePath Ptr, user_data As Any Ptr) As Boolean
			Declare Static Sub TreeListView_Map(widget As GtkWidget Ptr, user_data As Any Ptr)
			Declare Static Sub TreeListView_RowActivated(tree_view As GtkTreeView Ptr, path As GtkTreePath Ptr, column As GtkTreeViewColumn Ptr, user_data As Any Ptr)
			Declare Static Sub TreeListView_Scroll(self As GtkAdjustment Ptr, user_data As Any Ptr)
			Declare Static Sub TreeListView_SelectionChanged(selection As GtkTreeSelection Ptr, user_data As Any Ptr)
		#elseif defined(__USE_WINAPI__)
			Declare Static Function EditControlProc(hDlg As HWND, uMsg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			Declare Static Function GetTreeListViewItemByIndex(Node As TreeListViewItem Ptr, Item As Integer, ByRef iCount As Integer) As TreeListViewItem Ptr
			Declare Function GetTreeListViewItem(Item As Integer) As TreeListViewItem Ptr
			Declare Virtual Sub SetDark(Value As Boolean)
			hHeader As HWND
			headerTextColor As COLORREF
		#endif
	Public:
		#ifndef ReadProperty_Off
			'Loads persisted properties.
			Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves properties to storage.
			Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		#ifdef __USE_GTK__
			'Pointer to native tree storage structure.
			TreeStore As GtkTreeStore Ptr
			'Selection mode (Single/Multiple).
			TreeSelection As GtkTreeSelection Ptr
			'Specifies column data types (Text/Image/Checkbox).
			ColumnTypes As GType Ptr
		#endif
		'Initializes control components.
		Declare Sub Init()
		'Scrolls to make node visible.
		Declare Sub EnsureVisible(Index As Integer)
		'Retrieves node by visual position.
		Declare Function GetItemByVisibleIndex(Item As Integer) As TreeListViewItem Ptr
		'Root tree node collection.
		Nodes           As TreeListViewItems
		'Collection of column definitions.
		Columns         As TreeListViewColumns
		'Image list for node icons.
		Images          As ImageList Ptr
		'Image list for node state icons.
		StateImages     As ImageList Ptr
		'Collapses all expanded nodes.
		Declare Sub CollapseAll
		'Expands all collapsible nodes.
		Declare Sub ExpandAll
		Declare Property ColumnHeaderHidden As Boolean
		'Hides column headers when enabled.
		Declare Property ColumnHeaderHidden(Value As Boolean)
		Declare Property EditLabels As Boolean
		'Enables in-place item text editing.
		Declare Property EditLabels(Value As Boolean)
		Declare Property GridLines As Boolean
		'Displays row/column separator lines.
		Declare Property GridLines(Value As Boolean)
		Declare Property MultiSelect As Boolean
		'Allows multiple node selection.
		Declare Property MultiSelect(Value As Boolean)
		Declare Property OwnerData As Boolean
		'Enables virtual mode data population.
		Declare Property OwnerData(Value As Boolean)
		Declare Property OwnerDraw As Boolean
		'Enables custom node rendering.
		Declare Property OwnerDraw(Value As Boolean)
		Declare Property ShowHint As Boolean
		'Controls tooltip visibility.
		Declare Property ShowHint(Value As Boolean)
		Declare Property Sort As SortStyle
		'Enables automatic column sorting.
		Declare Property Sort(Value As SortStyle)
		Declare Property SelectedItem As TreeListViewItem Ptr
		'Currently highlighted tree node.
		Declare Property SelectedItem(Value As TreeListViewItem Ptr)
		Declare Property SelectedItemIndex As Integer
		'Index of selected node (-1 if none).
		Declare Property SelectedItemIndex(Value As Integer)
		Declare Property SelectedColumn As TreeListViewColumn Ptr
		'Currently focused column index.
		Declare Property SelectedColumn(Value As TreeListViewColumn Ptr)
		Declare Property SingleClickActivate As Boolean
		'Activates nodes with single click.
		Declare Property SingleClickActivate(Value As Boolean)
		Declare Property TabIndex As Integer
		'Tab navigation order index.
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		'Enables Tab key navigation.
		Declare Property TabStop(Value As Boolean)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		'Triggered on node activation.
		OnItemActivate        As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr)
		'Raised on node click.
		OnItemClick           As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr)
		'Raised on node double-click.
		OnItemDblClick        As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr)
		'Keyboard input on focused node.
		OnItemKeyDown         As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr)
		'Triggered before node expansion.
		OnItemExpanding       As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr)
		'Triggered before cell editing starts.
		OnCellEditing         As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr, ByVal SubItemIndex As Integer, CellEditor As Control Ptr, ByRef Cancel As Boolean)
		'Triggered after cell edit completion.
		OnCellEdited          As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr, ByVal SubItemIndex As Integer, ByRef NewText As WString, ByRef Cancel As Boolean)
		'Raised after selection changes.
		OnSelectedItemChanged As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr)
		'Raised when scrolling starts.
		OnBeginScroll         As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeListView)
		'Raised when scrolling completes.
		OnEndScroll           As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeListView)
		'Custom node sizing event.
		OnMeasureItem         As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr, ByRef ItemWidth As ULong, ByRef ItemHeight As ULong)
		'Custom node rendering event.
		OnDrawItem            As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr, ItemAction As Integer, ItemState As Integer, ByRef R As My.Sys.Drawing.Rect, ByRef Canvas As My.Sys.Drawing.Canvas)
		'Virtual mode data prefetch notification.
		OnCacheHint           As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeListView, ByVal iFrom As Integer, ByVal iTo As Integer)
		'Virtual mode data request event.
		OnGetDisplayInfo      As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As TreeListView, ByRef NewText As WString, ByVal RowIndex As Integer, ByVal ColumnIndex As Integer, iMask As ULong)
	End Type
End Namespace

#ifndef __USE_MAKE__
	#include once "TreeListView.bas"
#endif
