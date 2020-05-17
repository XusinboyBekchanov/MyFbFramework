'###############################################################################
'#  Grid.bi                                                                #
'#  This file is part of MyFBFramework                                    #
'#  Version 1.0.0                                                              #
'###############################################################################

#include once "Control.bi"

#IfDef __USE_GTK__
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
#Else
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
#EndIf

Namespace My.Sys.Forms
	#DEFINE QGrid(__Ptr__) *Cast(Grid Ptr,__Ptr__)
	#DEFINE QGridItem(__Ptr__) *Cast(GridItem Ptr,__Ptr__)
	#DEFINE QGridColumn(__Ptr__) *Cast(GridColumn Ptr,__Ptr__)
	
	Type GridItem Extends My.Sys.Object
	Private:
		FText            As WString Ptr
		FHint            As WString Ptr
		FImageIndex   As Integer
		FSelectedImageIndex   As Integer
		FSmallImageIndex   As Integer
		FVisible      As Boolean
	Public:
		Index As Integer
		Parent   As Control Ptr
		Declare Sub SelectItem
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
		Declare Property Visible As Boolean
		Declare Property Visible(Value As Boolean)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		OnClick As Sub(BYREF Sender As My.Sys.Object)
		OnDblClick As Sub(BYREF Sender As My.Sys.Object)
	End Type
	
	Type GridColumn Extends My.Sys.Object
	Private:
		FText            As WString Ptr
		FHint            As WString Ptr
		FImageIndex   As Integer
		FWidth      As Integer
		FFormat      As GridColumnFormat
		FVisible      As Boolean
	Public:
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
		Declare Property Width As Integer
		Declare Property Width(Value As Integer)
		Declare Property Format As GridColumnFormat
		Declare Property Format(Value As GridColumnFormat)
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		OnClick As Sub(BYREF Sender As My.Sys.Object)
		OnDblClick As Sub(BYREF Sender As My.Sys.Object)
	End Type
	
	Type GridItems
	Private:
		FItems As List
	Public:
		Parent   As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Item(Index As Integer) As GridItem Ptr
		Declare Property Item(Index As Integer, Value As GridItem Ptr)
		Declare Function Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1) As GridItem Ptr
		Declare Sub Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1)
		Declare Sub Remove(Index As Integer)
		Declare Function IndexOf(BYREF FItem As GridItem Ptr) As Integer
		Declare Sub Clear
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	Type GridColumns
	Private:
		FColumns As List
	Public:
		Parent   As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Column(Index As Integer) As GridColumn Ptr
		Declare Property Column(Index As Integer, Value As GridColumn Ptr)
		Declare Function Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As GridColumnFormat = gcfLeft) As GridColumn Ptr
		Declare Sub Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As GridColumnFormat = gcfLeft)
		Declare Sub Remove(Index As Integer)
		Declare Function IndexOf(BYREF FColumn As GridColumn Ptr) As Integer
		Declare Sub Clear
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
	End Type
	
	Type Grid Extends Control
	Private:
		#IfNDef __USE_GTK__
			Declare Static Sub WndProc(BYREF Message As Message)
			Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
			Declare Static Sub HandleIsDestroyed(BYREF Sender As Control)
			Declare Sub ProcessMessage(BYREF Message As Message)
		#EndIf
	Public:
		ListItems         As GridItems
		Columns         As GridColumns
		Images          As ImageList Ptr
		SelectedImages       As ImageList Ptr
		SmallImages       As ImageList Ptr
		GroupHeaderImages       As ImageList Ptr
		Declare Property ShowHint As Boolean
		Declare Property ShowHint(Value As Boolean)
		Declare Property SelectedItem As GridItem Ptr
		Declare Property SelectedItem(Value As GridItem Ptr)
		Declare Property SelectedColumn As GridColumn Ptr
		Declare Property SelectedColumn(Value As GridColumn Ptr)
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnItemClick As Sub(BYREF Sender As Grid, BYREF Item As GridItem)
		OnItemDblClick As Sub(BYREF Sender As Grid, BYREF Item As GridItem)
	End Type
End Namespace

'TODO:
#IfNDef __USE_GTK__
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
