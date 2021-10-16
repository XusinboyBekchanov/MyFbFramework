'###############################################################################
'#  Grid.bi                                                                #
'#  This file is part of MyFBFramework                                    #
'#  Version 1.0.0                                                              #
'###############################################################################

#include once "Control.bi"

Enum GridSortStyle
	ssNone
	ssSortAscending
	ssSortDescending
End Enum

#ifdef __USE_GTK__
	Enum GridColumnFormat
		gcfLeft
		gcfRight
		gcfCenter
		gcfJustifyMask
		gcfImage
		gcfBitmapOnRight
		gcfColHasImages
		'cfFixedWidth
		'cfNoDpiScale
		'cfFixedRatio
		'cfLineBreak
		'cfWrap
		'cfNoTitle
		'cfSplitButton
		'cfTilePlacementMask
	End Enum
#else
	Enum GridColumnFormat
		gcfLeft = LVCFMT_LEFT
		gcfRight = LVCFMT_RIGHT
		gcfCenter = LVCFMT_CENTER
		gcfJustifyMask = LVCFMT_JUSTIFYMASK
		gcfImage = LVCFMT_IMAGE
		gcfBitmapOnRight = LVCFMT_BITMAP_ON_RIGHT
		gcfColHasImages = LVCFMT_COL_HAS_IMAGES
		'cfFixedWidth = LVCFMT_FIXED_WIDTH
		'cfNoDpiScale = LVCFMT_NO_DPI_SCALE
		'cfFixedRatio = LVCFMT_FIXED_RATIO
		'cfLineBreak = LVCFMT_LINE_BREAK
		'cfWrap = LVCFMT_WRAP
		'cfNoTitle = LVCFMT_NO_TITLE
		'cfSplitButton = LVCFMT_SPLITBUTTON
		'cfTilePlacementMask = LVCFMT_TILE_PLACEMENTMASK
	End Enum
#endif

Namespace My.Sys.Forms
	#define QGrid(__Ptr__) *Cast(Grid Ptr,__Ptr__)
	#define QGridRow(__Ptr__) *Cast(GridRow Ptr, __Ptr__)
	#define QGridColumn(__Ptr__) *Cast(GridColumn Ptr,__Ptr__)
	
	Type GridRow Extends My.Sys.Object
	Private:
		FText               As WString Ptr
		FColumns            As WStringList
		FHint               As WString Ptr
		FImageIndex         As Integer
		FSelectedImageIndex As Integer
		FSmallImageIndex    As Integer
		FImageKey           As WString Ptr
		FSelectedImageKey   As WString Ptr
		FSmallImageKey      As WString Ptr
		FVisible            As Boolean
		FState              As Integer
		FIndent             As Integer
		#ifndef __USE_GTK__
			Dim lvi             As LVITEM
		#endif
	Public:
		#ifdef __USE_GTK__
			TreeIter As GtkTreeIter
		#endif
		Parent   As Control Ptr
		Tag As Any Ptr
		Declare Sub SelectItem
		Declare Function Index As Integer
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		Declare Property Text(iColumn As Integer) ByRef As WString
		Declare Property Text(iColumn As Integer, ByRef Value As WString)
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
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		OnClick As Sub(ByRef Sender As My.Sys.Object)
		OnDblClick As Sub(ByRef Sender As My.Sys.Object)
	End Type
	
	Type GridColumn Extends My.Sys.Object
	Private:
		FText           As WString Ptr
		FHint           As WString Ptr
		FImageIndex     As Integer
		FWidth          As Integer
		FFormat         As GridColumnFormat
		FVisible        As Boolean
		FEditable       As Boolean
	Public:
		#ifdef __USE_GTK__
			Dim As GtkTreeViewColumn Ptr Column
		#endif
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
		Declare Property Format As GridColumnFormat
		Declare Property Format(Value As GridColumnFormat)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		OnClick As Sub(ByRef Sender As My.Sys.Object)
		OnDblClick As Sub(ByRef Sender As My.Sys.Object)
	End Type
	
	Type GridRows
	Private:
		FItems As List
		PItem As GridRow Ptr
		#ifndef __USE_GTK__
			lvi As LVITEM
		#endif
	Public:
		#ifdef __USE_GTK__
			Declare Function FindByIterUser_Data(User_Data As Any Ptr) As GridRow Ptr
		#endif
		Parent   As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Item(Index As Integer) As GridRow Ptr
		Declare Property Item(Index As Integer, Value As GridRow Ptr)
		Declare Function Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0, Index As Integer = -1) As GridRow Ptr
		Declare Function Add(ByRef FCaption As WString = "", ByRef FImageKey As WString, State As Integer = 0, Indent As Integer = 0, Index As Integer = -1) As GridRow Ptr
		Declare Function Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0) As GridRow Ptr
		Declare Sub Remove(Index As Integer)
		Declare Function IndexOf(ByRef FItem As GridRow Ptr) As Integer
		Declare Sub Clear
		Declare Sub Sort
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	Type GridColumns
	Private:
		FColumns As List
		#ifdef __USE_GTK__
			Declare Static Sub Cell_Edited(renderer As GtkCellRendererText Ptr, path As gchar Ptr, new_text As gchar Ptr, user_data As Any Ptr)
			Declare Static Sub Check(cell As GtkCellRendererToggle Ptr, path As gchar Ptr, user_data As Any Ptr)
		#endif
	Public:
		Parent   As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Column(Index As Integer) As GridColumn Ptr
		Declare Property Column(Index As Integer, Value As GridColumn Ptr)
		Declare Function Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As GridColumnFormat = gcfLeft, ColEditable As Boolean = False) As GridColumn Ptr
		Declare Sub Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As GridColumnFormat = gcfLeft)
		Declare Sub Remove(Index As Integer)
		Declare Function IndexOf(ByRef FColumn As GridColumn Ptr) As Integer
		Declare Sub Clear
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	Type Grid Extends Control
	Private:
		FAllowColumnReorder As Boolean
		FColumnHeaderHidden As Boolean
		FGridLines As Boolean
		FHoverTime As Integer
		FFullRowSelect As Boolean
		FSingleClickActivate As Boolean
		FSortStyle As GridSortStyle
		FHoverSelection As Boolean
		FLVExStyle As Integer
		Declare Sub ChangeLVExStyle(iStyle As Integer, Value As Boolean)
		Declare Static Sub WndProc(ByRef Message As Message)
		Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		Declare Static Sub HandleIsDestroyed(ByRef Sender As Control)
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
		#endif
	Public:
		Declare Sub Init()
		Rows         As GridRows
		Columns         As GridColumns
		Images          As ImageList Ptr
		SelectedImages       As ImageList Ptr
		SmallImages       As ImageList Ptr
		StateImages       As ImageList Ptr
		GroupHeaderImages       As ImageList Ptr
		Declare Virtual Function ReadProperty(PropertyName As String) As Any Ptr
		Declare Virtual Function WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Declare Property AllowColumnReorder As Boolean
		Declare Property AllowColumnReorder(Value As Boolean)
		Declare Property ColumnHeaderHidden As Boolean
		Declare Property ColumnHeaderHidden(Value As Boolean)
		Declare Property FullRowSelect As Boolean
		Declare Property FullRowSelect(Value As Boolean)
		Declare Property HoverTime As Integer
		Declare Property HoverTime(Value As Integer)
		Declare Property GridLines As Boolean
		Declare Property GridLines(Value As Boolean)
		Declare Property ShowHint As Boolean
		Declare Property ShowHint(Value As Boolean)
		Declare Property Sort As GridSortStyle
		Declare Property Sort(Value As GridSortStyle)
		Declare Property SelectedRow As GridRow Ptr
		Declare Property SelectedRow(Value As GridRow Ptr)
		Declare Property SelectedRowIndex As Integer
		Declare Property SelectedRowIndex(Value As Integer)
		Declare Property SelectedColumn As GridColumn Ptr
		Declare Property SelectedColumn(Value As GridColumn Ptr)
		Declare Property SingleClickActivate As Boolean
		Declare Property SingleClickActivate(Value As Boolean)
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		'Gets or sets a value indicating whether an row is automatically selected when the mouse pointer remains over the item for a few seconds.
		Declare Property HoverSelection As Boolean
		Declare Property HoverSelection(Value As Boolean)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnRowActivate As Sub(ByRef Sender As Grid, ByVal RowIndex As Integer)
		OnRowClick As Sub(ByRef Sender As Grid, ByVal RowIndex As Integer)
		OnRowDblClick As Sub(ByRef Sender As Grid, ByVal RowIndex As Integer)
		OnRowKeyDown As Sub(ByRef Sender As Grid, ByVal RowIndex As Integer, Key As Integer, Shift As Integer)
		OnSelectedRowChanging As Sub(ByRef Sender As Grid, ByVal RowIndex As Integer, ByRef Cancel As Boolean)
		OnSelectedRowChanged As Sub(ByRef Sender As Grid, ByVal RowIndex As Integer)
		OnBeginScroll As Sub(ByRef Sender As Grid)
		OnEndScroll As Sub(ByRef Sender As Grid)
		OnCellEdited As Sub(ByRef Sender As Grid, ByVal RowIndex As Integer, ByVal ColumnIndex As Integer, ByRef NewText As WString)
	End Type
End Namespace

'TODO:
#ifndef __USE_GTK__
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
	
	const LVS_EX_GRIDLINES = &h1
	const LVS_EX_SUBITEMIMAGES = &h2
	const LVS_EX_CHECKBOXES = &h4
	const LVS_EX_TRACKSELECT = &h8
	const LVS_EX_HEADERDRAGDROP = &h10
	const LVS_EX_FULLROWSELECT = &h20
	const LVS_EX_ONECLICKACTIVATE = &h40
	const LVS_EX_TWOCLICKACTIVATE = &h80
	const LVS_EX_FLATSB = &h100
	const LVS_EX_REGIONAL = &h200
	const LVS_EX_INFOTIP = &h400
	const LVS_EX_UNDERLINEHOT = &h800
	const LVS_EX_UNDERLINECOLD = &h1000
	const LVS_EX_MULTIWORKAREAS = &h2000
	const LVS_EX_LABELTIP = &h4000
	const LVS_EX_BORDERSELECT = &h8000
	const LVS_EX_DOUBLEBUFFER = &h10000
	const LVS_EX_HIDELABELS = &h20000
	const LVS_EX_SINGLEROW = &h40000
	const LVS_EX_SNAPTOGRID = &h80000
	const LVS_EX_SIMPLESELECT = &h100000
	
	#if _WIN32_WINNT = &h0602
		const LVS_EX_JUSTIFYCOLUMNS = &h200000
		const LVS_EX_TRANSPARENTBKGND = &h400000
		const LVS_EX_TRANSPARENTSHADOWTEXT = &h800000
		const LVS_EX_AUTOAUTOARRANGE = &h1000000
		const LVS_EX_HEADERINALLVIEWS = &h2000000
		const LVS_EX_AUTOCHECKSELECT = &h8000000
		const LVS_EX_AUTOSIZECOLUMNS = &h10000000
		const LVS_EX_COLUMNSNAPPOINTS = &h40000000
		const LVS_EX_COLUMNOVERFLOW = &h80000000
	#endif
#EndIf

#IfNDef __USE_MAKE__
	#Include Once "Grid.bas"
#EndIf
