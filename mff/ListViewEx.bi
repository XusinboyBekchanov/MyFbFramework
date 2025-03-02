'###############################################################################
'#  ListViewEx.bi                                                              #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov     Liu XiaLin                                 #
'###############################################################################

'RowBackground	DataGrid中的行的背景颜色.
'AlternationRowBackground	交替行背景色.
'ColumnHeaderHeight	标题列的高度.
'RowHeaderWidth	具有行标题头的宽度.
'ColumnWidth	每列的宽度.
'RowHeight	每行的高度.
'GridLinesVisibility	确定是否显示网格线.
'VerticalGridLinesBrush	用于绘制列之间的网格线的画刷.
'HorizontalGrdiLinesBrush	用于绘制行之间网格线的画刷.
'多种数据类型支持 文本、数字、日期、图像和布尔值
'https://www.cnblogs.com/browser-yy/p/3295939.html   C# 格式化字符串（转载）
#include once "Control.bi"
#include once "WStringList.bi"
#ifdef __USE_GTK__
	#include once "glib-object.bi"
#endif

Const LVCFMT_FILL = &h200000

#ifdef __USE_WINAPI__
	'Private Enum ViewStyle
	'	vsIcon = LV_VIEW_ICON
	'	vsDetails = LV_VIEW_DETAILS
	'	vsSmallIcon = LV_VIEW_SMALLICON
	'	vsList = LV_VIEW_LIST
	'	vsTile = LV_VIEW_TILE
	'	vsMax = LV_VIEW_MAX
	'End Enum
	
	'Private Enum ColumnFormat
	'	cfLeft = LVCFMT_LEFT
	'	cfRight = LVCFMT_RIGHT
	'	cfCenter = LVCFMT_CENTER
	'	cfJustifyMask = LVCFMT_JUSTIFYMASK
	'	cfImage = LVCFMT_IMAGE
	'	cfBitmapOnRight = LVCFMT_BITMAP_ON_RIGHT
	'	cfColHasImages = LVCFMT_COL_HAS_IMAGES
	'	'cfFixedWidth = LVCFMT_FIXED_WIDTH
	'	'cfNoDpiScale = LVCFMT_NO_DPI_SCALE
	'	'cfFixedRatio = LVCFMT_FIXED_RATIO
	'	'cfLineBreak = LVCFMT_LINE_BREAK
	'	cfFill = LVCFMT_FILL
	'	'cfWrap = LVCFMT_WRAP
	'	'cfNoTitle = LVCFMT_NO_TITLE
	'	'cfSplitButton = LVCFMT_SPLITBUTTON
	'	'cfTilePlacementMask = LVCFMT_TILE_PLACEMENTMASK
	'End Enum
#else
	'Private Enum ViewStyle
	'	vsIcon
	'	vsDetails
	'	vsSmallIcon
	'	vsList
	'	vsTile
	'	vsMax
	'End Enum
	
	'Private Enum ColumnFormat
	'	cfLeft
	'	cfRight
	'	cfCenter
	'	cfJustifyMask
	'	cfImage
	'	cfBitmapOnRight
	'	cfColHasImages
	'	'cfFixedWidth
	'	'cfNoDpiScale
	'	'cfFixedRatio
	'	'cfLineBreak
	'	cfFill
	'	'cfWrap
	'	'cfNoTitle
	'	'cfSplitButton
	'	'cfTilePlacementMask
	'End Enum
#endif

Namespace My.Sys.Forms
	#define QListViewEx(__Ptr__) (*Cast(ListViewEx Ptr, __Ptr__))
	#define QListViewExItem(__Ptr__) (*Cast(ListViewExItem Ptr, __Ptr__))
	#define QListViewExColumn(__Ptr__) (*Cast(ListViewExColumn Ptr, __Ptr__))
	'`ListViewExItem` - Represents an enhanced item in a ListViewEx control with multi-state visuals and hierarchical support.
	Private Type ListViewExItem Extends My.Sys.Object
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
		FSelected           As Boolean
		FVisible            As Boolean
		FForeColor         As Integer = -1
		FBackColor         As Integer = -1
		FState              As Integer
		FChecked            As Boolean
		FIndent             As Integer
		#ifdef __USE_WINAPI__
			Dim lvi             As LVITEM
		#endif
	Public:
		#ifdef __USE_GTK__
			'GTK+ tree model iterator reference
			TreeIter As GtkTreeIter
		#endif
		'Parent ListViewEx control reference
		Parent   As Control Ptr
		'User-defined associated data
		Tag As Any Ptr
		'Programmatically selects the item
		Declare Sub SelectItem
		Declare Property Checked As Boolean
		'Checkbox state (if checkboxes enabled)
		Declare Property Checked(Value As Boolean)
		'Returns position in parent's item collection
		Declare Function Index As Integer
		'Primary display text
		Declare Property Text(iSubItem As Integer) ByRef As WString
		'Primary display text
		Declare Property Text(iSubItem As Integer, ByRef Value As WString)
		Declare Property BackColor As Integer
		'Background color of the item row
		Declare Property BackColor(ByVal Value As Integer)
		Declare Property ForeColor As Integer
		'Text color of the item
		Declare Property ForeColor(ByVal Value As Integer)
		Declare Property Hint ByRef As WString
		'Tooltip text shown on item hover
		Declare Property Hint(ByRef Value As WString)
		Declare Property ImageIndex As Integer
		'Default icon index in parent's ImageList
		Declare Property ImageIndex(Value As Integer)
		Declare Property SelectedImageIndex As Integer
		'Icon index when item is selected
		Declare Property SelectedImageIndex(Value As Integer)
		Declare Property SmallImageIndex As Integer
		'Icon index for small icon view mode
		Declare Property SmallImageIndex(Value As Integer)
		Declare Property ImageKey ByRef As WString
		'Key name of default icon
		Declare Property ImageKey(ByRef Value As WString)
		Declare Property SelectedImageKey ByRef As WString
		'Key name of selected state icon
		Declare Property SelectedImageKey(ByRef Value As WString)
		Declare Property SmallImageKey ByRef As WString
		'Key name of small view mode icon
		Declare Property SmallImageKey(ByRef Value As WString)
		Declare Property Visible As Boolean
		'Controls item visibility
		Declare Property Visible(Value As Boolean)
		Declare Property Selected As Boolean
		'Indicates selection state
		Declare Property Selected(Value As Boolean)
		Declare Property State As Integer
		'Custom state flags (Highlighted/Disabled)
		Declare Property State(Value As Integer)
		Declare Property Indent As Integer
		'Hierarchy indentation level (tree-mode)
		Declare Property Indent(Value As Integer)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		'Triggered on single mouse click
		OnClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object)
		'Triggered on double mouse click
		OnDblClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object)
	End Type
	
	'`ListViewExColumn` - Enhanced column definition for advanced ListView controls with dynamic styling and data interaction capabilities.
	Private Type ListViewExColumn Extends My.Sys.Object
	Private:
		FText            As WString Ptr
		FHint            As WString Ptr
		FImageIndex      As Integer
		FWidth           As Integer
		FFormat          As ColumnFormat
		FVisible         As Boolean
		FEditable        As Boolean
		FForeColor     As Integer = -1
		FBackColor     As Integer = -1
	Public:
		#ifdef __USE_GTK__
			Dim As GtkTreeViewColumn Ptr Column
		#endif
		'Zero-based position in column collection
		Index As Integer
		'Reference to parent ListViewEx control
		Parent   As Control Ptr
		'Programmatically selects all cells in column
		Declare Sub SelectItem
		Declare Property Text ByRef As WString
		'Header display caption
		Declare Property Text(ByRef Value As WString)
		Declare Property Hint ByRef As WString
		'Context-sensitive help text on header hover
		Declare Property Hint(ByRef Value As WString)
		Declare Property ImageIndex As Integer
		'Icon index in parent's ImageList for header decoration
		Declare Property ImageIndex(Value As Integer)
		Declare Property Visible As Boolean
		'Controls column visibility state
		Declare Property Visible(Value As Boolean)
		Declare Property Editable As Boolean
		'Enables cell-level inline editing with custom controls
		Declare Property Editable(Value As Boolean)
		Declare Property BackColor As Integer
		'Background color of column header
		Declare Property BackColor(Value As Integer)
		Declare Property ForeColor As Integer
		'Text color of column header
		Declare Property ForeColor(Value As Integer)
		Declare Property Width As Integer
		'Column width in DPI-aware measurement units
		Declare Property Width(Value As Integer)
		Declare Property Format As ColumnFormat
		'Advanced conditional formatting rules (e.g., "Positive;Negative;Zero")
		Declare Property Format(Value As ColumnFormat)
		'Forces immediate visual refresh of column
		Declare Sub Update()
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		'Raised when column header receives single-click
		OnClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object)
		'Raised when column header receives double-click
		OnDblClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object)
	End Type
	
	Private Type ListViewExColumns Extends My.Sys.Object
	Private:
		FColumns As List
		#ifdef __USE_GTK__
			Declare Static Sub Cell_Edited(renderer As GtkCellRendererText Ptr, path As gchar Ptr, new_text As gchar Ptr, user_data As Any Ptr)
			Declare Static Sub Check(cell As GtkCellRendererToggle Ptr, path As gchar Ptr, user_data As Any Ptr)
		#endif
	Public:
		'Reference to parent ListViewEx control
		Parent   As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Column(Index As Integer) As ListViewExColumn Ptr
		Declare Property Column(Index As Integer, Value As ListViewExColumn Ptr)
		Declare Function Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As ColumnFormat = cfLeft, Editable As Boolean = False, iBackColor As Integer = -1) As ListViewExColumn Ptr
		Declare Sub Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As ColumnFormat = cfLeft)
		Declare Sub Remove(Index As Integer)
		'Zero-based position in column collection
		Declare Function IndexOf(ByRef FColumn As ListViewExColumn Ptr) As Integer
		Declare Sub Clear
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	Private Type ListViewExItems
	Private:
		FItems        As List
		PItem         As ListViewExItem Ptr
		FDelimiterChr As String
		#ifdef __USE_WINAPI__
			lvi       As LVITEM
		#endif
	Public:
		#ifdef __USE_GTK__
			Declare Function FindByIterUser_Data(User_Data As Any Ptr) As ListViewExItem Ptr
		#endif
		'Reference to parent ListViewEx control
		Parent        As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Item(Index As Integer) As ListViewExItem Ptr
		Declare Property Item(Index As Integer, Value As ListViewExItem Ptr)
		Declare Function Add(ByRef FCaption As WString = "", ByVal FImageIndex As Integer = -1, ByVal State As Integer = 0, ByVal Indent As Integer = 0, ByVal Index As Integer = -1, ByRef DelimiterChr As String = "", ByVal IsLastItem As Boolean = True) As ListViewExItem Ptr
		Declare Function Add(ByRef FCaption As WString = "", ByRef FImageKey As WString, ByVal State As Integer = 0, ByVal Indent As Integer = 0, ByVal Index As Integer = -1, ByRef DelimiterChr As String = "", ByVal IsLastItem As Boolean = True) As ListViewExItem Ptr
		Declare Function Insert(Index As Integer, ByRef FCaption As WString = "", ByVal FImageIndex As Integer = -1, ByVal State As Integer = 0, ByVal Indent As Integer = 0, ByRef DelimiterChr As String = "", ByVal IsLastItem As Boolean = True) As ListViewExItem Ptr
		Declare Sub Remove(Index As Integer)
		'Zero-based position in column collection
		Declare Function IndexOf(ByRef FItem As ListViewExItem Ptr) As Integer
		'Zero-based position in column collection
		Declare Function IndexOf(ByRef FCaption As WString) As Integer
		Declare Function Contains(ByRef FCaption As WString) As Boolean
		Declare Sub Sort Overload(ByVal ColIndex As Integer, ByVal SortOrder As SortStyle = SortStyle.ssSortAscending, ByVal SortAsNumber As Boolean = False, ByVal MatchCase As Boolean = False)
		Declare Sub Sort Overload(iDataPtr() As WString Ptr, ByVal ColIndex As Integer, ByVal SortOrder As SortStyle = SortStyle.ssSortAscending, ByVal SortAsNumber As Boolean = False, ByVal MatchCase As Boolean = False)
		
		Declare Sub Clear
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	'`ListViewEx` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`ListViewEx` - Represents a control that displays a list of data items.
	Private Type ListViewEx Extends Control
	Private:
		FAllowColumnReorder  As Boolean
		FBorderSelect        As Boolean
		FCheckBoxes          As Boolean
		FColumnHeaderHidden  As Boolean
		FGridLines           As Boolean
		FHoverTime           As Integer
		FFullRowSelect       As Boolean
		FLabelTip            As Boolean
		FMultiSelect         As Boolean
		FSingleClickActivate As Boolean
		FRow                 As Integer
		FCol                 As Integer
		FSorting             As Boolean
		FMultiLine           As Boolean
		FHoverSelection      As Boolean
		FView                As ViewStyle = ViewStyle.vsDetails
		FLVExStyle           As Integer
		FRowsHeight          As Integer
		FAlternativeColor    As Integer = -1
		
		Declare Sub ChangeLVExStyle(iStyle As Integer, Value As Boolean)
		#ifdef __USE_WINAPI__
			FBrushSelction   As HBRUSH 
			FBrushCellBack   As HBRUSH 
			FFillColorSave   As Integer
			FGridColorSelected As Integer
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Sub DrawRect(tDc As HDC, R As Rect, FillColor As Integer = -1, tSelctionRow As Integer = -1)
			'Declare Sub DrawGrid(RowShowStart As Integer, RowShowEnd As Integer, RowHover As Integer = -1, ColHover As Integer = -1, DrawHeaderOnly As Boolean = False)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			Declare Static Sub HandleIsDestroyed(ByRef Sender As Control)
			
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		'Declare Virtual Sub ProcessMessageAfter(ByRef Message As Message)
		#ifdef __USE_GTK__
			Declare Static Sub ListView_RowActivated(tree_view As GtkTreeView Ptr, path As GtkTreePath Ptr, column As GtkTreeViewColumn Ptr, user_data As Any Ptr)
			Declare Static Sub ListView_ItemActivated(icon_view As GtkIconView Ptr, path As GtkTreePath Ptr, user_data As Any Ptr)
			Declare Static Sub ListView_SelectionChanged(selection As GtkTreeSelection Ptr, user_data As Any Ptr)
			Declare Static Sub IconView_SelectionChanged(iconview As GtkIconView Ptr, user_data As Any Ptr)
			Declare Static Sub ListView_Map(widget As GtkWidget Ptr, user_data As Any Ptr)
			Declare Static Function ListView_Scroll(self As GtkAdjustment Ptr, user_data As Any Ptr) As Boolean
			ListStore As GtkListStore Ptr
			TreeSelection As GtkTreeSelection Ptr
			ColumnTypes As GType Ptr
			TreeViewWidget As GtkWidget Ptr
			IconViewWidget As GtkWidget Ptr
			PrevIndex As Integer
		#elseif defined(__USE_WINAPI__)
			Declare Virtual Sub SetDark(Value As Boolean)
			'Font Property
			FFontCyPixels             As Integer
			FFontBolds(0 To 1)        As Integer = {400, 700}
			FHandleHeader             As HWND
			FTextColorHeader          As COLORREF
			FFontHandleBody           As HFONT
			FFontHandleHeader         As HFONT
			FFontHeight               As Integer = 6
			FFontWidth                As Integer = 6
			
		#endif
	Public:
		#ifndef ReadProperty_Off
			'Loads persisted properties.
			Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Saves properties to storage.
			Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Initializes control components.
		Declare Sub Init()
		'Scrolls to make item visible.
		Declare Sub EnsureVisible(Index As Integer)
		'Collection of list items.
		ListItems               As ListViewExItems
		'Collection of column definitions.
		Columns                 As ListViewExColumns
		'Primary image list for item icons.
		Images                  As ImageList Ptr
		'Image list for item state icons.
		StateImages             As ImageList Ptr
		'Image list for small-sized icons.
		SmallImages             As ImageList Ptr
		'Image list for group header icons.
		GroupHeaderImages       As ImageList Ptr
		'Custom sorting comparison parameters.
		SortComparePara         As CompareParaType
		
		'Pointer to underlying data structure.
		DataArrayPtr(Any, Any)  As WString Ptr
		Declare Property AllowColumnReorder As Boolean
		'Enables drag-and-drop column reordering.
		Declare Property AllowColumnReorder(Value As Boolean)
		Declare Property BorderSelect As Boolean
		'Shows border around selected items.
		Declare Property BorderSelect(Value As Boolean)
		Declare Property CheckBoxes As Boolean
		'Displays checkboxes next to list items.
		Declare Property CheckBoxes(Value As Boolean)
		Declare Property ColumnHeaderHidden As Boolean
		'Hides column headers when enabled.
		Declare Property ColumnHeaderHidden(Value As Boolean)
		Declare Property FullRowSelect As Boolean
		'Highlights entire row on selection.
		Declare Property FullRowSelect(Value As Boolean)
		Declare Property HoverTime As Integer
		'Delay (ms) before hover events trigger.
		Declare Property HoverTime(Value As Integer)
		Declare Property GridLines As Boolean
		'Displays row/column separator lines.
		Declare Property GridLines(Value As Boolean)
		Declare Property LabelTip As Boolean
		'Enables tooltips for truncated text.
		Declare Property LabelTip(Value As Boolean)
		Declare Property MultiSelect As Boolean
		'Enables multiple item selection.
		Declare Property MultiSelect(Value As Boolean)
		Declare Property ShowHint As Boolean
		'Controls hint/tooltip visibility.
		Declare Property ShowHint(Value As Boolean)
		Declare Property TabIndex As Integer
		'Tab navigation order index.
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		'Enables Tab key navigation.
		Declare Property TabStop(Value As Boolean)
		Declare Property View As ViewStyle
		'Display mode (Details/Icon/List/etc).
		Declare Property View(Value As ViewStyle)
		Declare Property RowsCount As Integer
		'Total number of items in the list.
		Declare Property RowsCount(Value As Integer)
		Declare Property MultiLine As Boolean
		'Allows multi-line text in items.
		Declare Property MultiLine(Value As Boolean)
		Declare Property RowsHeight As Integer
		'Height of each row in pixels.
		Declare Property RowsHeight(Value As Integer)
		Declare Property AlternativeColor As Integer
		'Background color for alternating rows.
		Declare Property AlternativeColor(Value As Integer)
		Declare Property SelectedItem As ListViewExItem Ptr
		'Currently highlighted list item.
		Declare Property SelectedItem(Value As ListViewExItem Ptr)
		Declare Property SelectedItemIndex As Integer
		'Index of selected item (-1 if none).
		Declare Property SelectedItemIndex(Value As Integer)
		Declare Property SelectedColumn As ListViewExColumn Ptr
		'Index of currently selected column.
		Declare Property SelectedColumn(Value As ListViewExColumn Ptr)
		Declare Property SingleClickActivate As Boolean
		'Activates items with single click.
		Declare Property SingleClickActivate(Value As Boolean)
		'Gets or sets a value indicating whether an item is automatically selected when the mouse pointer remains over the item for a few seconds.
		Declare Property HoverSelection As Boolean
		Declare Property HoverSelection(Value As Boolean)
		'Saves list data to file.
		Declare Function SaveToFile(ByRef FileName As WString, ByRef DelimiterChr As String = Chr(9)) As Boolean
		'Loads list data from file.
		Declare Function LoadFromFile(ByRef FileName As WString, ByRef DelimiterChr As String = "", ByVal HasTitle As Boolean = True, ByVal ReadToArrary As Boolean = True) As Integer
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		'Raised on column header click.
		OnColumnClick          As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ListViewEx, ByVal ColIndex As Integer, ByVal SortOrder As SortStyle, ByVal MatchCase As Boolean)
		'Triggered on item activation.
		OnItemActivate         As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ListViewEx, ByVal ItemIndex As Integer)
		'Raised on item click.
		OnItemClick            As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ListViewEx, ByVal ItemIndex As Integer)
		'Raised on item double-click.
		OnItemDblClick         As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ListViewEx, ByVal ItemIndex As Integer)
		'Triggered by keyboard input on item.
		OnItemKeyDown          As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ListViewEx, ByVal ItemIndex As Integer, Key As Integer, Shift As Integer)
		'Raised before selection changes.
		OnSelectedItemChanging As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ListViewEx, ByVal ItemIndex As Integer, ByRef Cancel As Boolean)
		'Raised after selection changes.
		OnSelectedItemChanged  As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ListViewEx, ByVal ItemIndex As Integer)
		'Raised when scrolling starts.
		OnBeginScroll          As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ListViewEx)
		'Raised when scrolling completes.
		OnEndScroll            As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ListViewEx)
		'Triggered after cell edit completion.
		OnCellEdited           As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As ListViewEx, ByVal ItemIndex As Integer, ByVal SubItemIndex As Integer, ByRef NewText As WString)
	End Type
End Namespace

'TODO:
#ifdef __USE_WINAPI__
	'const LVS_ICON = &h0
	'const LVS_REPORT = &h1
	'const LVS_SMALLICON = &h2
	'const LVS_LIST = &h3
	'const LVS_TYPEMASK = &h3
	'const LVS_SINGLESEL = &h4
	'const LVS_SHOWSELALWAYS = &h8
	'const LVS_SORTASCENDING = &h10
	'const LVS_SORTDESCENDING = &h20
	'const LVS_SHAREIMAGELISTS = &h40
	'const LVS_NOLABELWRAP = &h80
	'const LVS_AUTOARRANGE = &h100
	'const LVS_EDITLABELS = &h200
	'const LVS_OWNERDATA = &h1000
	'const LVS_NOSCROLL = &h2000
	'const LVS_TYPESTYLEMASK = &hfc00
	'const LVS_ALIGNTOP = &h0
	'const LVS_ALIGNLEFT = &h800
	'const LVS_ALIGNMASK = &hc00
	'const LVS_OWNERDRAWFIXED = &h400
	'const LVS_NOCOLUMNHEADER = &h4000
	'const LVS_NOSORTHEADER = &h8000
	
	Const LVS_EX_GRIDLINES = &h1
	Const LVS_EX_SUBITEMIMAGES = &h2
	Const LVS_EX_CHECKBOXES = &h4
	Const LVS_EX_TRACKSELECT = &h8
	Const LVS_EX_HEADERDRAGDROP = &h10
	Const LVS_EX_FULLROWSELECT = &h20
	Const LVS_EX_ONECLICKACTIVATE = &h40
	Const LVS_EX_TWOCLICKACTIVATE = &h80
	Const LVS_EX_FLATSB = &h100
	Const LVS_EX_REGIONAL = &h200
	Const LVS_EX_INFOTIP = &h400
	Const LVS_EX_UNDERLINEHOT = &h800
	Const LVS_EX_UNDERLINECOLD = &h1000
	Const LVS_EX_MULTIWORKAREAS = &h2000
	Const LVS_EX_LABELTIP = &h4000
	Const LVS_EX_BORDERSELECT = &h8000
	Const LVS_EX_DOUBLEBUFFER = &h10000
	Const LVS_EX_HIDELABELS = &h20000
	Const LVS_EX_SINGLEROW = &h40000
	Const LVS_EX_SNAPTOGRID = &h80000
	Const LVS_EX_SIMPLESELECT = &h100000
	
	#if _WIN32_WINNT = &h0602
		Const LVS_EX_JUSTIFYCOLUMNS = &h200000
		Const LVS_EX_TRANSPARENTBKGND = &h400000
		Const LVS_EX_TRANSPARENTSHADOWTEXT = &h800000
		Const LVS_EX_AUTOAUTOARRANGE = &h1000000
		Const LVS_EX_HEADERINALLVIEWS = &h2000000
		Const LVS_EX_AUTOCHECKSELECT = &h8000000
		Const LVS_EX_AUTOSIZECOLUMNS = &h10000000
		Const LVS_EX_COLUMNSNAPPOINTS = &h40000000
		Const LVS_EX_COLUMNOVERFLOW = &h80000000
	#endif
#endif

#ifndef __USE_MAKE__
	#include once "ListViewEx.bas"
#endif
