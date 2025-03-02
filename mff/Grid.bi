'################################################################################
'#  Grid.bi                                                                     #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov,  Liu XiaLin                                    #
'################################################################################
#include once "Control.bi"
#include once "WStringList.bi"
#include once "TextBox.bi"

Namespace My.Sys.Forms
	#define QGrid(__Ptr__) (*Cast(Grid Ptr, __Ptr__))
	#define QGridRow(__Ptr__) (*Cast(GridRow Ptr, __Ptr__))
	#define QGridCell(__Ptr__) (*Cast(GridCell Ptr, __Ptr__))
	#define QGridColumn(__Ptr__) (*Cast(GridColumn Ptr, __Ptr__))
	
	Type PGridRow As GridRow Ptr
	Type PGridColumn As GridColumn Ptr
	
	Private Type GridCell Extends My.Sys.Object
	Private:
		FEditable      As Boolean
		FForeColor     As Integer = -1
		FBackColor     As Integer = -1
	Public:
		Column As PGridColumn
		Parent As Control Ptr
		Row As PGridRow
		Tag As Any Ptr
		Declare Sub SelectItem
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Property Editable As Boolean
		Declare Property Editable(Value As Boolean)
		Declare Property ForeColor As Integer
		Declare Property ForeColor(Value As Integer)
		Declare Property BackColor As Integer
		Declare Property BackColor(Value As Integer)
		Declare Operator Cast As Any Ptr
	End Type
	
	Private Type GridRow Extends My.Sys.Object
	Private:
		FText              As WString Ptr
		FCells             As WStringList
		FHint              As WString Ptr
		FImageIndex        As Integer
		FSelectedImageIndex As Integer
		FSmallImageIndex   As Integer
		FImageKey          As WString Ptr
		FSelectedImageKey  As WString Ptr
		FSmallImageKey     As WString Ptr
		FVisible           As Boolean
		FEditable          As Boolean
		FForeColor         As Integer = -1
		FBackColor         As Integer = -1
		FState             As Integer
		FIndent            As Integer
		#ifdef __USE_WINAPI__
			Dim lvi        As LVITEM
		#endif
	Public:
		#ifdef __USE_GTK__
			TreeIter As GtkTreeIter
		#endif
		Parent  As Control Ptr
		Tag As Any Ptr
		Declare Sub SelectItem
		Declare Function Index As Integer
		Declare Function Item(ColumnIndex As Integer) As GridCell Ptr
		Declare Property Text(ColumnIndex As Integer) ByRef As WString
		Declare Property Text(ColumnIndex As Integer, ByRef Value As WString)
		Declare Property Editable As Boolean
		Declare Property Editable(Value As Boolean)
		Declare Property ForeColor As Integer
		Declare Property ForeColor(Value As Integer)
		Declare Property BackColor As Integer
		Declare Property BackColor(Value As Integer)
		Declare Property Hint ByRef As WString
		Declare Property Hint(ByRef Value As WString)
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
		Declare Property State As Integer
		Declare Property State(Value As Integer)
		Declare Property Indent As Integer
		Declare Property Indent(Value As Integer)
		Declare Property Visible As Boolean
		Declare Property Visible(Value As Boolean)
		Declare Sub ColumnEvents(ColumnIndex As Integer, ColumnDelete As Boolean = False)
		Declare Operator [](ColumnIndex As Integer) ByRef As GridCell
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		OnClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object)
		OnDblClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object)
	End Type
	
	'`GridColumn` - Defines the visual and behavioral properties of a column within a grid control.
	Private Type GridColumn Extends My.Sys.Object
	Private:
		FText          As WString Ptr
		FHint          As WString Ptr
		FImageIndex    As Integer
		FWidth         As Integer
		FFormat        As ColumnFormat
		FVisible       As Boolean
		FEditable      As Boolean
		FForeColor     As Integer = -1
		FBackColor     As Integer = -1
	Public:
		#ifdef __USE_GTK__
			Dim As GtkTreeViewColumn Ptr Column
		#endif
		'Ordinal position within parent grid columns
		Index As Integer
		'Reference to containing grid control
		Parent As Control Ptr
		'User-defined object storage
		Tag As Any Ptr
		'Programmatically selects all cells in column
		Declare Sub SelectItem
		Declare Property Text ByRef As WString
		'Column header display text
		Declare Property Text(ByRef Value As WString)
		Declare Property Hint ByRef As WString
		'Tooltip text displayed on column header hover
		Declare Property Hint(ByRef Value As WString)
		Declare Property ImageIndex As Integer
		'Index of associated icon in parent's ImageList
		Declare Property ImageIndex(Value As Integer)
		Declare Property Visible As Boolean
		'Controls column visibility
		Declare Property Visible(Value As Boolean)
		Declare Property Editable As Boolean
		'Enables in-cell editing for this column
		Declare Property Editable(Value As Boolean)
		Declare Property BackColor As Integer
		'Background color for column cells
		Declare Property BackColor(Value As Integer)
		Declare Property ForeColor As Integer
		'Text color for column content
		Declare Property ForeColor(Value As Integer)
		Declare Property Width As Integer
		'Column display width in pixels
		Declare Property Width(Value As Integer)
		Declare Property Format As ColumnFormat
		'Data formatting string (e.g., currency/datetime patterns)
		Declare Property Format(Value As ColumnFormat)
		'Refreshes column display properties
		Declare Sub Update()
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		'Triggered when column header is clicked
		OnClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object)
		'Raised on column header double-click
		OnDblClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object)
	End Type
	
	Private Type GridRows
	Private:
		FItems As List
		PItem As GridRow Ptr
	Public:
		#ifdef __USE_GTK__
			Declare Function FindByIterUser_Data(User_Data As Any Ptr) As GridRow Ptr
		#endif
		'Reference to containing grid control
		Parent          As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Item(Index As Integer) As GridRow Ptr
		Declare Property Item(Index As Integer, Value As GridRow Ptr)
		Declare Function Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0, Index As Integer = -1, RowEditable As Boolean = False, ColorBK As Integer = -1, ColorText As Integer = -1) As GridRow Ptr
		Declare Function Add(ByRef FCaption As WString = "", ByRef FImageKey As WString, State As Integer = 0, Indent As Integer = 0, Index As Integer = -1, RowEditable As Boolean = False, ColorBK As Integer = -1, ColorText As Integer = -1) As GridRow Ptr
		Declare Function Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0, InsertBefore As Boolean = True, RowEditable As Boolean = False, ColorBK As Integer = -1, ColorText As Integer = -1, DuplicateIndex As Integer = -1) As GridRow Ptr
		Declare Sub Remove(Index As Integer)
		'Ordinal position within parent grid columns
		Declare Function IndexOf(ByRef FItem As GridRow Ptr) As Integer
		Declare Sub Clear
		Declare Sub Sort(ColumnIndex As Integer = 0, Direction As SortStyle = SortStyle.ssSortAscending, MatchCase As Boolean = False, iLeft As Integer = 0, iRight As Integer = 0)
		Declare Operator [](Index As Integer) ByRef As GridRow
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	Private Type GridColumns Extends My.Sys.Object
	Private:
		FColumns As List
		#ifdef __USE_GTK__
			Declare Static Sub Cell_Edited(renderer As GtkCellRendererText Ptr, path As gchar Ptr, new_text As gchar Ptr, user_data As Any Ptr)
			Declare Static Sub Check(cell As GtkCellRendererToggle Ptr, path As gchar Ptr, user_data As Any Ptr)
		#endif
	Public:
		'Reference to containing grid control
		Parent  As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Column(Index As Integer) As GridColumn Ptr
		Declare Property Column(Index As Integer, Value As GridColumn Ptr)
		Declare Function Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = 100, Format As ColumnFormat = cfLeft, ColEditable As Boolean = False, ColBackColor As Integer = -1, ColForeColor As Integer = -1) As GridColumn Ptr
		Declare Sub Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As ColumnFormat = cfLeft, InsertBefore As Boolean = True, ColEditable As Boolean = False, ColBackColor As Integer = -1, ColForeColor As Integer = -1, DuplicateIndex As Integer = -1)
		Declare Sub Remove(Index As Integer)
		'Ordinal position within parent grid columns
		Declare Function IndexOf(ByRef FColumn As GridColumn Ptr) As Integer
		Declare Sub Clear
		Declare Operator [](Index As Integer) ByRef As GridColumn
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	'`Grid` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`Grid` is a Control within the MyFbFramework, part of the freeBasic framework.
	'`Grid` - Defines a flexible grid area that consists of columns and rows.
	Private Type Grid Extends Control
	Private:
		FAllowColumnReorder As Boolean
		FColumnHeaderHidden As Boolean
		FGridLines          As Boolean
		FHoverTime          As Integer
		FFullRowSelect      As Boolean
		FSingleClickActivate As Boolean
		FSortIndex          As Integer
		FSortOrder          As SortStyle
		FHoverSelection     As Boolean
		FLVExStyle          As Integer
		FRow                As Integer
		FCol                As Integer
		FItemHeight         As Integer
		GridEditText        As TextBox
		FSorting            As Boolean
		FAllowEdit          As Boolean = True
		FOwnerData          As Boolean = True
		#ifdef __USE_WINAPI__
			FClientRect         As Rect
		#endif
		'GRID PROPERTY
		'FGridLineDrawMode       As Integer = 1
		
		#ifdef __USE_WINAPI__
			FGridColorLine          As Integer = -1 'BGR(166, 166, 166) 'clSilver
			FGridColorLineHeader    As Integer = clWhite 'BGR(166, 166, 166)'clSilver
			FGridColorSelected      As Integer = BGR(68, 155, 235) ' &HFFFFE6 '&HFFFFDE ' &HFEE8FFFF 'BGR(210, 238, 245)'BGR(178, 214, 255)
			FGridColorHover         As Integer = BGR(110, 228, 255)
			FGridColorBack          As Integer = clWhite
			FGridColorFore          As Integer = clBlack
			FGridColorEditBack      As Integer = clHighlight 'BGR(24, 255, 255) ' &H9AFA00'clWhite
			FGridColorEditFore      As Integer = clHighlightText 'clBlack ' &H9AFA00'clWhite
			FGridLineWidth          As Integer = 1
		#else
			FGridColorLine          As Integer
			FGridColorLineHeader    As Integer
			FGridColorSelected      As Integer
			FGridColorHover         As Integer
			FGridColorBack          As Integer
			FGridColorFore          As Integer
			FGridColorEditBack      As Integer
			FGridColorEditFore      As Integer
			FGridLineWidth          As Integer
		#endif
		
		#ifdef __USE_WINAPI__
			FGridLinePenMode        As Integer = PS_SOLID
		#else
			FGridLinePenMode        As Integer
		#endif
		Declare Sub ChangeLVExStyle(iStyle As Integer, Value As Boolean)
		#ifndef __USE_GTK__
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		#endif
		#ifdef __USE_WINAPI__
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsDestroyed(ByRef Sender As Control)
			Declare Sub EditControlShow(ByVal tRow As Integer, ByVal tCol As Integer)
			Declare Sub DrawRect(tDc As HDC, R As Rect, FillColor As Integer = -1, tSelctionRow As Integer = -1, tSelctionCol As Integer = -1)
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
		#ifdef __USE_GTK__
			Declare Static Sub Grid_RowActivated(tree_view As GtkTreeView Ptr, path As GtkTreePath Ptr, column As GtkTreeViewColumn Ptr, user_data As Any Ptr)
			Declare Static Sub Grid_SelectionChanged(selection As GtkTreeSelection Ptr, user_data As Any Ptr)
			Declare Static Sub Grid_Map(widget As GtkWidget Ptr, user_data As Any Ptr)
			Declare Static Function Grid_Scroll(self As GtkAdjustment Ptr, user_data As Any Ptr) As Boolean
			ListStore As GtkListStore Ptr
			TreeSelection As GtkTreeSelection Ptr
			ColumnTypes As GType Ptr
			PrevIndex As Integer
		#elseif defined(__USE_WINAPI__)
			Declare Virtual Sub SetDark(Value As Boolean)
			hHeader As HWND
			headerTextColor As COLORREF
		#endif
	Protected:
		#ifdef __USE_WASM__
			Declare Virtual Function GetContent() As UString
		#endif
	Public:
		'Removes all rows and columns.
		Declare Sub Clear()
		'Collection of data rows.
		Rows                   As GridRows
		'Collection of column definitions.
		Columns                As GridColumns
		'Primary image list for row icons.
		Images                 As ImageList Ptr
		'Image list for selected state icons.
		SelectedImages         As ImageList Ptr
		'Image list for small-sized icons.
		SmallImages            As ImageList Ptr
		'Image list for row state indicators.
		StateImages            As ImageList Ptr
		'Image list for group headers.
		GroupHeaderImages      As ImageList Ptr
		#ifndef ReadProperty_Off
			'Loads persisted properties.
			Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			'Persists properties to storage.
			Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		'Access cell content by row/column.
		Declare Function Cells(RowIndex As Integer, ColumnIndex As Integer) As GridCell Ptr
		Declare Property AllowEdit As Boolean
		'Allows in-cell content editing.
		Declare Property AllowEdit(Value As Boolean)
		Declare Property AllowColumnReorder As Boolean
		'Enables drag-and-drop column reordering.
		Declare Property AllowColumnReorder(Value As Boolean)
		Declare Property ColumnHeaderHidden As Boolean
		'Hides column headers when enabled.
		Declare Property ColumnHeaderHidden(Value As Boolean)
		Declare Property FullRowSelect As Boolean
		'Selects entire row on click.
		Declare Property FullRowSelect(Value As Boolean)
		Declare Property OwnerData As Boolean
		'Enables virtual data population mode.
		Declare Property OwnerData(Value As Boolean)
		Declare Property ColorSelected As Integer
		'Highlight color for selected rows/cells.
		Declare Property ColorSelected(Value As Integer)
		Declare Property ColorEditBack As Integer
		'Background color for edit mode cells.
		Declare Property ColorEditBack(Value As Integer)
		Declare Property ColorEditFore As Integer
		'Text color for edit mode cells.
		Declare Property ColorEditFore(Value As Integer)
		Declare Property ColorLine As Integer
		'Color of grid separator lines.
		Declare Property ColorLine(Value As Integer)
		Declare Property HoverTime As Integer
		'Hover detection delay (ms).
		Declare Property HoverTime(Value As Integer)
		Declare Property GridLines As Boolean
		'Toggles row/column separator lines.
		Declare Property GridLines(Value As Boolean)
		Declare Property ShowHint As Boolean
		'Controls tooltip visibility.
		Declare Property ShowHint(Value As Boolean)
		Declare Property SortIndex As Integer
		'Index of sorted column.
		Declare Property SortIndex(Value As Integer)
		Declare Property SortOrder As SortStyle
		'Sort direction (Ascending/Descending).
		Declare Property SortOrder(Value As SortStyle)
		Declare Property SelectedRow As GridRow Ptr
		'Currently highlighted row object.
		Declare Property SelectedRow(Value As GridRow Ptr)
		Declare Property SelectedRowIndex As Integer
		'Index of selected row (-1 if none).
		Declare Property SelectedRowIndex(Value As Integer)
		Declare Property SelectedColumn As GridColumn Ptr
		'Currently focused column object.
		Declare Property SelectedColumn(Value As GridColumn Ptr)
		Declare Property SelectedColumnIndex As Integer
		'Index of selected column (-1 if none).
		Declare Property SelectedColumnIndex(Value As Integer)
		Declare Property SingleClickActivate As Boolean
		'Activates rows with single click.
		Declare Property SingleClickActivate(Value As Boolean)
		Declare Property TabIndex As Integer
		'Tab navigation order index.
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		'Enables Tab key navigation.
		Declare Property TabStop(Value As Boolean)
		'Gets or sets a value indicating whether an row is automatically selected when the mouse pointer remains over the item for a few seconds.
		Declare Property HoverSelection As Boolean
		Declare Property HoverSelection(Value As Boolean)
		Declare Operator [](RowIndex As Integer) ByRef As GridRow
		Declare Operator Cast As Control Ptr
		'Saves grid data to file.
		Declare Sub SaveToFile(ByRef FileName As WString)
		'Loads grid data from file.
		Declare Sub LoadFromFile(ByRef FileName As WString)
		'Scrolls to make cell visible.
		Declare Sub EnsureVisible(Index As Integer)
		Declare Constructor
		Declare Destructor
		'Raised on column header click.
		OnColumnClick           As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByVal ColIndex As Integer)
		'Triggered on row activation.
		OnRowActivate           As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByVal RowIndex As Integer)
		'Raised on row click.
		OnRowClick              As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByVal RowIndex As Integer)
		'Raised on row double-click.
		OnRowDblClick           As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByVal RowIndex As Integer)
		'Keyboard input on focused row.
		OnRowKeyDown            As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByVal RowIndex As Integer, Key As Integer, Shift As Integer)
		'Raised before selection changes.
		OnSelectedRowChanging   As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByVal RowIndex As Integer, ByRef Cancel As Boolean)
		'Raised after selection changes.
		OnSelectedRowChanged    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByVal RowIndex As Integer)
		'Raised when scrolling starts.
		OnBeginScroll           As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid)
		'Raised when scrolling completes.
		OnEndScroll             As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid)
		'Triggered after cell edit completion.
		OnCellEdited            As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByVal RowIndex As Integer, ByVal ColumnIndex As Integer, ByRef NewText As WString)
		'Virtual mode data prefetch notification.
		OnCacheHint             As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByVal iFrom As Integer, ByVal iTo As Integer)
		'Virtual mode data request event.
		OnGetDispInfo           As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByRef NewText As WString, ByVal RowIndex As Integer, ByVal ColumnIndex As Integer, iMask As ULong)
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
	
	Const LVS_EX_GridLINES = &h1
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
	Const LVS_EX_SNAPTOGrid = &h80000
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
	#include once "Grid.bas"
#endif
