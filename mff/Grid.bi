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
		Index As Integer
		Parent As Control Ptr
		Tag As Any Ptr
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
		Declare Property BackColor As Integer
		Declare Property BackColor(Value As Integer)
		Declare Property ForeColor As Integer
		Declare Property ForeColor(Value As Integer)
		Declare Property Width As Integer
		Declare Property Width(Value As Integer)
		Declare Property Format As ColumnFormat
		Declare Property Format(Value As ColumnFormat)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		OnClick As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As My.Sys.Object)
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
		Parent          As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Item(Index As Integer) As GridRow Ptr
		Declare Property Item(Index As Integer, Value As GridRow Ptr)
		Declare Function Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0, Index As Integer = -1, RowEditable As Boolean = False, ColorBK As Integer = -1, ColorText As Integer = -1) As GridRow Ptr
		Declare Function Add(ByRef FCaption As WString = "", ByRef FImageKey As WString, State As Integer = 0, Indent As Integer = 0, Index As Integer = -1, RowEditable As Boolean = False, ColorBK As Integer = -1, ColorText As Integer = -1) As GridRow Ptr
		Declare Function Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0, InsertBefore As Boolean = True, RowEditable As Boolean = False, ColorBK As Integer = -1, ColorText As Integer = -1, DuplicateIndex As Integer = -1) As GridRow Ptr
		Declare Sub Remove(Index As Integer)
		Declare Function IndexOf(ByRef FItem As GridRow Ptr) As Integer
		Declare Sub Clear
		Declare Sub Sort(ColumnIndex As Integer, Direction As ListSortDirection, MatchCase As Boolean = False, iLeft As Integer = 0, iRight As Integer = 0)
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
		Parent  As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Column(Index As Integer) As GridColumn Ptr
		Declare Property Column(Index As Integer, Value As GridColumn Ptr)
		Declare Function Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = 100, Format As ColumnFormat = cfLeft, ColEditable As Boolean = False, ColBackColor As Integer = -1, ColForeColor As Integer = -1) As GridColumn Ptr
		Declare Sub Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As ColumnFormat = cfLeft, InsertBefore As Boolean = True, ColEditable As Boolean = False, ColBackColor As Integer = -1, ColForeColor As Integer = -1, DuplicateIndex As Integer = -1)
		Declare Sub Remove(Index As Integer)
		Declare Function IndexOf(ByRef FColumn As GridColumn Ptr) As Integer
		Declare Sub Clear
		Declare Operator [](Index As Integer) ByRef As GridColumn
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	'Defines a flexible grid area that consists of columns and rows.
	Private Type Grid Extends Control
	Private:
		FAllowColumnReorder As Boolean
		FColumnHeaderHidden As Boolean
		FGridLines          As Boolean
		FHoverTime          As Integer
		FFullRowSelect      As Boolean
		FSingleClickActivate As Boolean
		FSortIndex          As Integer
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
			FGridColorSelected      As Integer = BGR(178, 225, 235) ' &HFFFFE6 '&HFFFFDE ' &HFEE8FFFF 'BGR(210, 238, 245)'BGR(178, 214, 255)
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
		Declare Sub Clear()
		Rows                   As GridRows
		Columns                As GridColumns
		Images                 As ImageList Ptr
		SelectedImages         As ImageList Ptr
		SmallImages            As ImageList Ptr
		StateImages            As ImageList Ptr
		GroupHeaderImages      As ImageList Ptr
		#ifndef ReadProperty_Off
			Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		#endif
		#ifndef WriteProperty_Off
			Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		#endif
		Declare Function Cells(RowIndex As Integer, ColumnIndex As Integer) As GridCell Ptr
		Declare Property AllowEdit As Boolean
		Declare Property AllowEdit(Value As Boolean)
		Declare Property AllowColumnReorder As Boolean
		Declare Property AllowColumnReorder(Value As Boolean)
		Declare Property ColumnHeaderHidden As Boolean
		Declare Property ColumnHeaderHidden(Value As Boolean)
		Declare Property FullRowSelect As Boolean
		Declare Property FullRowSelect(Value As Boolean)
		Declare Property OwnerData As Boolean
		Declare Property OwnerData(Value As Boolean)
		Declare Property RowsCount As Integer
		Declare Property RowsCount(RowCount As Integer)
		Declare Property ColorSelected As Integer
		Declare Property ColorSelected(Value As Integer)
		Declare Property ColorEditBack As Integer
		Declare Property ColorEditBack(Value As Integer)
		Declare Property ColorEditFore As Integer
		Declare Property ColorEditFore(Value As Integer)
		Declare Property ColorLine As Integer
		Declare Property ColorLine(Value As Integer)
		Declare Property HoverTime As Integer
		Declare Property HoverTime(Value As Integer)
		Declare Property GridLines As Boolean
		Declare Property GridLines(Value As Boolean)
		Declare Property ShowHint As Boolean
		Declare Property ShowHint(Value As Boolean)
		Declare Property SortIndex As Integer
		Declare Property SortIndex(Value As Integer)
		Declare Property SelectedRow As GridRow Ptr
		Declare Property SelectedRow(Value As GridRow Ptr)
		Declare Property SelectedRowIndex As Integer
		Declare Property SelectedRowIndex(Value As Integer)
		Declare Property SelectedColumn As GridColumn Ptr
		Declare Property SelectedColumn(Value As GridColumn Ptr)
		Declare Property SelectedColumnIndex As Integer
		Declare Property SelectedColumnIndex(Value As Integer)
		Declare Property SingleClickActivate As Boolean
		Declare Property SingleClickActivate(Value As Boolean)
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		'Gets or sets a value indicating whether an row is automatically selected when the mouse pointer remains over the item for a few seconds.
		Declare Property HoverSelection As Boolean
		Declare Property HoverSelection(Value As Boolean)
		Declare Operator [](RowIndex As Integer) ByRef As GridRow
		Declare Operator Cast As Control Ptr
		Declare Sub SaveToFile(ByRef FileName As WString)
		Declare Sub LoadFromFile(ByRef FileName As WString)
		Declare Sub EnsureVisible(Index As Integer)
		Declare Constructor
		Declare Destructor
		OnColumnClick           As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByVal ColIndex As Integer)
		OnRowActivate           As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByVal RowIndex As Integer)
		OnRowClick              As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByVal RowIndex As Integer)
		OnRowDblClick           As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByVal RowIndex As Integer)
		OnRowKeyDown            As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByVal RowIndex As Integer, Key As Integer, Shift As Integer)
		OnSelectedRowChanging   As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByVal RowIndex As Integer, ByRef Cancel As Boolean)
		OnSelectedRowChanged    As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByVal RowIndex As Integer)
		OnBeginScroll           As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid)
		OnEndScroll             As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid)
		OnCellEdited            As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByVal RowIndex As Integer, ByVal ColumnIndex As Integer, ByRef NewText As WString)
		OnCacheHint             As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByVal iFrom As Integer, ByVal iTo As Integer)
		#ifdef __USE_WINAPI__
			OnGetDispInfo       As Sub(ByRef Designer As My.Sys.Object, ByRef Sender As Grid, ByRef NewText As WString, ByVal RowIndex As Integer, ByVal ColumnIndex As Integer, iMask As UINT)
		#endif
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
