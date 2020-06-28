'###############################################################################
'#  ListView.bi                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'###############################################################################

#include once "Control.bi"
#ifdef __USE_GTK__
	#include once "glib-object.bi"
#endif

Const LVCFMT_FILL = &h200000

Enum SortStyle
	ssNone
	ssSortAscending
	ssSortDescending
End Enum

#ifdef __USE_GTK__
	Enum ViewStyle
		vsIcon
		vsDetails
		vsSmallIcon
		vsList
		vsTile
		vsMax
	End Enum
	
	Enum ColumnFormat
		cfLeft
		cfRight
		cfCenter
		cfJustifyMask
		cfImage
		cfBitmapOnRight
		cfColHasImages
		'cfFixedWidth
		'cfNoDpiScale
		'cfFixedRatio
		'cfLineBreak
		cfFill
		'cfWrap
		'cfNoTitle
		'cfSplitButton
		'cfTilePlacementMask
	End Enum
#else
	Enum ViewStyle
		vsIcon = LV_VIEW_ICON
		vsDetails = LV_VIEW_DETAILS
		vsSmallIcon = LV_VIEW_SMALLICON
		vsList = LV_VIEW_LIST
		vsTile = LV_VIEW_TILE
		vsMax = LV_VIEW_MAX
	End Enum
	
	Enum ColumnFormat
		cfLeft = LVCFMT_LEFT
		cfRight = LVCFMT_RIGHT
		cfCenter = LVCFMT_CENTER
		cfJustifyMask = LVCFMT_JUSTIFYMASK
		cfImage = LVCFMT_IMAGE
		cfBitmapOnRight = LVCFMT_BITMAP_ON_RIGHT
		cfColHasImages = LVCFMT_COL_HAS_IMAGES
		'cfFixedWidth = LVCFMT_FIXED_WIDTH
		'cfNoDpiScale = LVCFMT_NO_DPI_SCALE
		'cfFixedRatio = LVCFMT_FIXED_RATIO
		'cfLineBreak = LVCFMT_LINE_BREAK
		cfFill = LVCFMT_FILL
		'cfWrap = LVCFMT_WRAP
		'cfNoTitle = LVCFMT_NO_TITLE
		'cfSplitButton = LVCFMT_SPLITBUTTON
		'cfTilePlacementMask = LVCFMT_TILE_PLACEMENTMASK
	End Enum
#endif

Namespace My.Sys.Forms
	#define QListView(__Ptr__) *Cast(ListView Ptr,__Ptr__)
	#define QListViewItem(__Ptr__) *Cast(ListViewItem Ptr,__Ptr__)
	#define QListViewColumn(__Ptr__) *Cast(ListViewColumn Ptr,__Ptr__)
	
	Type ListViewItem Extends My.Sys.Object
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
		Declare Property Text(iSubItem As Integer) ByRef As WString
		Declare Property Text(iSubItem As Integer, ByRef Value As WString)
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
		Declare Property Visible As Boolean
		Declare Property Visible(Value As Boolean)
		Declare Property State As Integer
		Declare Property State(Value As Integer)
		Declare Property Indent As Integer
		Declare Property Indent(Value As Integer)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		OnClick As Sub(ByRef Sender As My.Sys.Object)
		OnDblClick As Sub(ByRef Sender As My.Sys.Object)
	End Type
	
	Type ListViewColumn Extends My.Sys.Object
	Private:
		FText            As WString Ptr
		FHint            As WString Ptr
		FImageIndex   As Integer
		FWidth      As Integer
		FFormat      As ColumnFormat
		FVisible      As Boolean
		FEditable	 As Boolean
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
		Declare Property Format As ColumnFormat
		Declare Property Format(Value As ColumnFormat)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		OnClick As Sub(ByRef Sender As My.Sys.Object)
		OnDblClick As Sub(ByRef Sender As My.Sys.Object)
	End Type
	
	Type ListViewColumns
	Private:
		FColumns As List
		#ifdef __USE_GTK__
			Declare Static Sub Cell_Edited(renderer As GtkCellRendererText Ptr, path As gchar Ptr, new_text As gchar Ptr, user_data As Any Ptr)
		#endif
	Public:
		Parent   As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Column(Index As Integer) As ListViewColumn Ptr
		Declare Property Column(Index As Integer, Value As ListViewColumn Ptr)
		Declare Function Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As ColumnFormat = cfLeft, Editable As Boolean = False) As ListViewColumn Ptr
		Declare Sub Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As ColumnFormat = cfLeft)
		Declare Sub Remove(Index As Integer)
		Declare Function IndexOf(ByRef FColumn As ListViewColumn Ptr) As Integer
		Declare Sub Clear
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	Type ListViewItems
	Private:
		FItems As List
		PItem As ListViewItem Ptr
		#ifndef __USE_GTK__
			lvi As LVITEM
		#endif
	Public:
		#ifdef __USE_GTK__
			Declare Function FindByIterUser_Data(User_Data As Any Ptr) As ListViewItem Ptr
		#endif
		Parent   As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Item(Index As Integer) As ListViewItem Ptr
		Declare Property Item(Index As Integer, Value As ListViewItem Ptr)
		Declare Function Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0, Index As Integer = -1) As ListViewItem Ptr
		Declare Function Add(ByRef FCaption As WString = "", ByRef FImageKey As WString, State As Integer = 0, Indent As Integer = 0, Index As Integer = -1) As ListViewItem Ptr
		Declare Function Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0) As ListViewItem Ptr
		Declare Sub Remove(Index As Integer)
		Declare Function IndexOf(ByRef FItem As ListViewItem Ptr) As Integer
		Declare Function IndexOf(ByRef FCaption As WString) As Integer
		Declare Function Contains(ByRef FCaption As WString) As Boolean
		Declare Sub Clear
		Declare Sub Sort
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	Type ListView Extends Control
	Private:
		FView As ViewStyle
		FColumnHeaderHidden As Boolean
		FSingleClickActivate As Boolean
		FSortStyle As SortStyle
		Declare Static Sub WndProc(ByRef Message As Message)
		Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
		Declare Static Sub HandleIsDestroyed(ByRef Sender As Control)
		Declare Sub ProcessMessage(ByRef Message As Message)
	Public:
		#ifdef __USE_GTK__
			ListStore As GtkListStore Ptr
			TreeSelection As GtkTreeSelection Ptr
			ColumnTypes As GType Ptr
		#endif
		Declare Sub Init()
		ListItems         As ListViewItems
		Columns         As ListViewColumns
		Images          As ImageList Ptr
		StateImages       As ImageList Ptr
		SmallImages       As ImageList Ptr
		GroupHeaderImages       As ImageList Ptr
		Declare Property ColumnHeaderHidden As Boolean
		Declare Property ColumnHeaderHidden(Value As Boolean)
		Declare Property ShowHint As Boolean
		Declare Property ShowHint(Value As Boolean)
		Declare Property View As ViewStyle
		Declare Property View(Value As ViewStyle)
		Declare Property Sort As SortStyle
		Declare Property Sort(Value As SortStyle)
		Declare Property SelectedItem As ListViewItem Ptr
		Declare Property SelectedItem(Value As ListViewItem Ptr)
		Declare Property SelectedItemIndex As Integer
		Declare Property SelectedItemIndex(Value As Integer)
		Declare Property SelectedColumn As ListViewColumn Ptr
		Declare Property SelectedColumn(Value As ListViewColumn Ptr)
		Declare Property SingleClickActivate As Boolean
		Declare Property SingleClickActivate(Value As Boolean)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnItemActivate As Sub(ByRef Sender As ListView, ByVal ItemIndex As Integer)
		OnItemClick As Sub(ByRef Sender As ListView, ByVal ItemIndex As Integer)
		OnItemDblClick As Sub(ByRef Sender As ListView, ByVal ItemIndex As Integer)
		OnItemKeyDown As Sub(ByRef Sender As ListView, ByVal ItemIndex As Integer)
		OnSelectedItemChanging As Sub(ByRef Sender As ListView, ByVal ItemIndex As Integer)
		OnSelectedItemChanged As Sub(ByRef Sender As ListView, ByVal ItemIndex As Integer)
		OnBeginScroll As Sub(ByRef Sender As ListView)
		OnEndScroll As Sub(ByRef Sender As ListView)
		OnCellEdited As Sub(ByRef Sender As ListView, ByVal ItemIndex As Integer, ByVal SubItemIndex As Integer, ByRef NewText As WString)
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
	Const LVS_EX_SUBITEMIMAGES = &h2
	Const LVS_EX_CHECKBOXES = &h4
	Const LVS_EX_TRACKSELECT = &h8
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
	#Include Once "ListView.bas"
#EndIf
