'################################################################################
'#  TreeView.bi                                                                 #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#include once "Control.bi"

Namespace My.Sys.Forms
	Type PTreeNode As TreeNode Ptr
	
	#define QTreeView(__Ptr__) *Cast(TreeView Ptr,__Ptr__)
	#define QTreeNode(__Ptr__) *Cast(TreeNode Ptr,__Ptr__)
	
	Type PTreeNode As TreeNode Ptr
	
	Type TreeNodeCollection Extends My.Sys.Object
	Private:
		FNodes As List
		FParentNode As PTreeNode
		PNode As PTreeNode
	Public:
		Parent   As Control Ptr
		Declare Property Count As Integer
		Declare Property Count(Value As Integer)
		Declare Property Item(Index As Integer) As PTreeNode
		Declare Property Item(Index As Integer, Value As PTreeNode)
		Declare Function Add(ByRef FText As WString = "", ByRef FKey As WString = "", ByRef FHint As WString = "", FImageIndex As Integer = -1, FSelectedImageIndex As Integer = -1, bSorted As Boolean = False) As PTreeNode
		Declare Function Add(ByRef FText As WString = "", ByRef FKey As WString = "", ByRef FHint As WString = "", ByRef FImageKey As WString, ByRef FSelectedImageKey As WString, bSorted As Boolean = False) As PTreeNode
		Declare Function Insert(Index As Integer, ByRef FText As WString = "", ByRef FKey As WString = "", ByRef FHint As WString = "", FImageIndex As Integer = -1, FSelectedImageIndex As Integer = -1) As PTreeNode
		Declare Function Insert(Index As Integer, ByRef FText As WString = "", ByRef FKey As WString = "", ByRef FHint As WString = "", ByRef FImageKey As WString, ByRef FSelectedImageKey As WString) As PTreeNode
		Declare Property ParentNode As PTreeNode
		Declare Property ParentNode(Value As PTreeNode)
		Declare Sub Remove(Index As Integer)
		Declare Sub EditLabel
		Declare Function IndexOf(ByRef FNode As PTreeNode) As Integer
		Declare Function IndexOf(ByRef Text As WString) As Integer
		Declare Function IndexOfKey(ByRef Key As WString) As Integer
		Declare Function Contains(ByRef FNode As PTreeNode) As Boolean
		Declare Function Contains(ByRef Text As WString) As Boolean
		Declare Function ContainsKey(ByRef Key As WString) As Boolean
		#ifdef __USE_GTK__
			Declare Function FindByIterUser_Data(User_Data As Any Ptr) As PTreeNode
		#else
			Declare Function FindByHandle(hti As HTREEItem) As PTreeNode
		#endif
		Declare Sub Clear
		Declare Sub Sort
		Declare Constructor
		Declare Destructor
	End Type
	
	Type TreeNode Extends My.Sys.Object
	Private:
		FName               As WString Ptr
		FText               As UString
		FHint               As WString Ptr
		FImageIndex         As Integer
		FImageKey           As WString Ptr
		FSelectedImageIndex As Integer
		FSelectedImageKey   As WString Ptr
		FParentNode         As PTreeNode
		FVisible            As Boolean
		FIsUpdated          As Boolean
		FIsDisposed         As Boolean
		FChecked            As Boolean
		FBold               As Boolean
	Public:
		Tag As Any Ptr
		Parent   As Control Ptr
		Nodes As TreeNodeCollection
		#ifdef __USE_GTK__
			TreeIter As GtkTreeIter
		#else
			Handle As HTREEITEM
		#endif
		Declare Sub SelectItem
		Declare Sub Collapse
		Declare Sub Expand
		Declare Function IsExpanded As Boolean
		Declare Property Bold As Boolean
		Declare Property Bold(Value As Boolean)
		Declare Function Index As Integer
		Declare Virtual Function ToString ByRef As WString
		Declare Property Name ByRef As WString
		Declare Property Name(ByRef Value As WString)
		Declare Property Text ByRef As WString
		Declare Property Text(ByRef Value As WString)
		Declare Property Hint ByRef As WString
		Declare Property Hint(ByRef Value As WString)
		Declare Property IsUpdated As Boolean
		Declare Property IsUpdated(Value As Boolean)
		Declare Property Checked As Boolean
		Declare Property Checked(Value As Boolean)
		Declare Property ImageIndex As Integer
		Declare Property ImageIndex(Value As Integer)
		Declare Property SelectedImageIndex As Integer
		Declare Property SelectedImageIndex(Value As Integer)
		Declare Property ImageKey ByRef As WString
		Declare Property ImageKey(ByRef Value As WString)
		Declare Property SelectedImageKey ByRef As WString
		Declare Property SelectedImageKey(ByRef Value As WString)
		Declare Property ParentNode As TreeNode Ptr
		Declare Property ParentNode(Value As TreeNode Ptr)
		Declare Property Visible As Boolean
		Declare Property Visible(Value As Boolean)
		Declare Function IsDisposed As Boolean
		Declare Operator Cast As Any Ptr
		Declare Constructor
		Declare Destructor
		OnClick As Sub(ByRef Sender As My.Sys.Object)
		OnDblClick As Sub(ByRef Sender As My.Sys.Object)
	End Type
	
	Type TreeView Extends Control
	Private:
		'FNodes        As List
		FSorted As Boolean
		FHideSelection As Boolean
		FEditLabels As Boolean
	Protected:
		#ifdef __USE_GTK__
			Dim As GtkCellRenderer Ptr rendertext
			Dim As TreeNode Ptr PrevNode
			TreeStore As GtkTreeStore Ptr
			TreeSelection As GtkTreeSelection Ptr
			Declare Static Sub TreeView_RowActivated(tree_view As GtkTreeView Ptr, path As GtkTreePath Ptr, column As GtkTreeViewColumn Ptr, user_data As Any Ptr)
			Declare Static Sub TreeView_SelectionChanged(selection As GtkTreeSelection Ptr, user_data As Any Ptr)
			Declare Static Function TreeView_ButtonRelease(widget As GtkWidget Ptr, e As GdkEvent Ptr, user_data As Any Ptr) As Boolean
			Declare Static Function TreeView_QueryTooltip(widget As GtkWidget Ptr, x As gint, y As gint, keyboard_mode As Boolean, tooltip As GtkTooltip Ptr, user_data As Any Ptr) As Boolean
			Declare Static Sub Cell_Editing(cell As GtkCellRenderer Ptr, editable As GtkCellEditable Ptr, path As Const gchar Ptr, user_data As Any Ptr)
			Declare Static Sub Cell_Edited(renderer As GtkCellRendererText Ptr, path As gchar Ptr, new_text As gchar Ptr, user_data As Any Ptr)
			Declare Static Function TestCollapseRow(tree_view As GtkTreeView Ptr, iter As GtkTreeIter Ptr, path As GtkTreePath Ptr, user_data As Any Ptr) As Boolean
			Declare Static Function TestExpandRow(tree_view As GtkTreeView Ptr, iter As GtkTreeIter Ptr, path As GtkTreePath Ptr, user_data As Any Ptr) As Boolean
			Declare Static Function RowCollapsed(tree_view As GtkTreeView Ptr, iter As GtkTreeIter Ptr, path As GtkTreePath Ptr, user_data As Any Ptr) As Boolean
			Declare Static Function RowExpanded(tree_view As GtkTreeView Ptr, iter As GtkTreeIter Ptr, path As GtkTreePath Ptr, user_data As Any Ptr) As Boolean
		#else
			Declare Static Sub WndProc(ByRef Message As Message)
			Declare Static Sub HandleIsAllocated(ByRef Sender As Control)
			Declare Static Sub HandleIsDestroyed(ByRef Sender As Control)
			Declare Sub SendToAllChildItems(ByVal hNode As HTREEITEM, tvMessage As Long)
			Declare Sub CreateNodes(PNode As TreeNode Ptr)
		#endif
		Declare Virtual Sub ProcessMessage(ByRef Message As Message)
	Public:
		Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
		Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		Images          As ImageList Ptr
		SelectedImages  As ImageList Ptr
		Nodes           As TreeNodeCollection
		Declare Property TabIndex As Integer
		Declare Property TabIndex(Value As Integer)
		Declare Property TabStop As Boolean
		Declare Property TabStop(Value As Boolean)
		Declare Sub CollapseAll
		Declare Sub ExpandAll
		Declare Property EditLabels As Boolean
		Declare Property EditLabels(Value As Boolean)
		Declare Property HideSelection As Boolean
		Declare Property HideSelection(Value As Boolean)
		Declare Property Sorted As Boolean
		Declare Property Sorted(Value As Boolean)
		Declare Property ShowHint As Boolean
		Declare Property ShowHint(Value As Boolean)
		Declare Property SelectedNode As TreeNode Ptr
		Declare Property SelectedNode(Value As TreeNode Ptr)
		Declare Function DraggedNode As TreeNode Ptr
		Declare Operator Cast As Control Ptr
		Declare Constructor
		Declare Destructor
		OnNodeActivate As Sub(ByRef Sender As TreeView, ByRef Item As TreeNode)
		OnNodeClick As Sub(ByRef Sender As TreeView, ByRef Item As TreeNode)
		OnNodeDblClick As Sub(ByRef Sender As TreeView, ByRef Item As TreeNode)
		OnNodeCollapsing As Sub(ByRef Sender As TreeView, ByRef Item As TreeNode, ByRef Cancel As Boolean)
		OnNodeCollapsed As Sub(ByRef Sender As TreeView, ByRef Item As TreeNode)
		OnNodeExpanding As Sub(ByRef Sender As TreeView, ByRef Item As TreeNode, ByRef Cancel As Boolean)
		OnNodeExpanded As Sub(ByRef Sender As TreeView, ByRef Item As TreeNode)
		OnSelChanging As Sub(ByRef Sender As TreeView, ByRef Item As TreeNode, ByRef Cancel As Boolean)
		OnSelChanged As Sub(ByRef Sender As TreeView, ByRef Item As TreeNode)
		OnBeforeLabelEdit As Sub(ByRef Sender As TreeView, ByRef Item As TreeNode, ByRef NodeLabel As WString, ByRef Cancel As Boolean)
		OnAfterLabelEdit As Sub(ByRef Sender As TreeView, ByRef Item As TreeNode, ByRef NodeLabel As WString, ByRef Cancel As Boolean)
	End Type
End Namespace

'TODO:
'const TVS_HASBUTTONS = &h1
'const TVS_HASLINES = &h2
'const TVS_LINESATROOT = &h4
'const TVS_EDITLABELS = &h8
'const TVS_DISABLEDRAGDROP = &h10
'const TVS_SHOWSELALWAYS = &h20
'const TVS_RTLREADING = &h40
'const TVS_NOTOOLTIPS = &h80
'const TVS_CHECKBOXES = &h100
'const TVS_TRACKSELECT = &h200
'const TVS_SINGLEEXPAND = &h400
'const TVS_INFOTIP = &h800
'const TVS_FULLROWSELECT = &h1000
'const TVS_NOSCROLL = &h2000
'const TVS_NONEVENHEIGHT = &h4000
'const TVS_NOHSCROLL = &h8000
'const TVS_EX_NOSINGLECOLLAPSE = &h1
'
#ifndef __USE_GTK__ '_WIN32_WINNT = &h0602
	Const TVS_EX_MULTISELECT = &h2
	Const TVS_EX_DOUBLEBUFFER = &h4
	Const TVS_EX_NOINDENTSTATE = &h8
	Const TVS_EX_RICHTOOLTIP = &h10
	Const TVS_EX_AUTOHSCROLL = &h20
	Const TVS_EX_FADEINOUTEXPANDOS = &h40
	Const TVS_EX_PARTIALCHECKBOXES = &h80
	Const TVS_EX_EXCLUSIONCHECKBOXES = &h100
	Const TVS_EX_DIMMEDCHECKBOXES = &h200
	Const TVS_EX_DRAWIMAGEASYNC = &h400
#endif

#ifndef __USE_MAKE__
	#include once "TreeView.bas"
#endif
