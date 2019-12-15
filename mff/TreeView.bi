'################################################################################
'#  TreeView.bi                                                                 #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#Include Once "Control.bi"

Namespace My.Sys.Forms
    Type PTreeNode As TreeNode Ptr

    #DEFINE QTreeView(__Ptr__) *Cast(TreeView Ptr,__Ptr__)
    #DEFINE QTreeNode(__Ptr__) *Cast(TreeNode Ptr,__Ptr__)
    
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
            Declare Function IndexOf(ByRef FNode As PTreeNode) As Integer
            Declare Function IndexOf(ByRef Text As WString) As Integer
            Declare Function IndexOfKey(ByRef Key As WString) As Integer
            Declare Function Contains(ByRef FNode As PTreeNode) As Boolean
            Declare Function Contains(ByRef Text As WString) As Boolean
            Declare Function ContainsKey(ByRef Key As WString) As Boolean
            #IfDef __USE_GTK__
				Declare Function FindByIterUser_Data(User_Data As Any Ptr) As PTreeNode
            #Else
				Declare Function FindByHandle(hti As HTREEItem) As PTreeNode
            #EndIf
            Declare Sub Clear
            Declare Sub Sort
            Declare Constructor
            Declare Destructor
    End Type
    
    Type TreeNode Extends My.Sys.Object
        Private:
            FName           As WString Ptr
            FText           As WString Ptr
            FHint           As WString Ptr
            FImageIndex   As Integer
            FImageKey   As WString Ptr
            FSelectedImageIndex   As Integer
            FSelectedImageKey    As WString Ptr
            FParentNode As PTreeNode
            FVisible      As Boolean
        Public:
            Tag As Any Ptr
            Parent   As Control Ptr
            Nodes As TreeNodeCollection
            #IfDef __USE_GTK__
				TreeIter As GtkTreeIter
            #Else
				Handle As HTREEITEM
            #EndIf
            Declare Sub SelectItem
            Declare Sub Collapse
            Declare Sub Expand
            Declare Function IsExpanded As Boolean
            Declare Function Index As Integer
            Declare Virtual Function ToString ByRef As WString
            Declare Property Name ByRef As WString
            Declare Property Name(ByRef Value As WString)
            Declare Property Text ByRef As WString
            Declare Property Text(ByRef Value As WString)
            Declare Property Hint ByRef As WString
            Declare Property Hint(ByRef Value As WString)
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
            Declare Operator Cast As Any Ptr
            Declare Constructor
            Declare Destructor
            OnClick As Sub(BYREF Sender As My.Sys.Object)
            OnDblClick As Sub(BYREF Sender As My.Sys.Object)
    End Type
    
    Type TreeView Extends Control
        Private:
            'FNodes        As List
            FSorted As Boolean
            FHideSelection As Boolean
            Declare Sub CreateNodes(PNode As TreeNode Ptr)
            #IfNDef __USE_GTK__
				Declare Static Sub WndProc(BYREF Message As Message)
				Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
				Declare Static Sub HandleIsDestroyed(BYREF Sender As Control)
				Declare Sub SendToAllChildItems(ByVal hNode As HTREEITEM, tvMessage As Long)
			#EndIf
			Declare Sub ProcessMessage(BYREF Message As Message)
        Public:
            #IfDef __USE_GTK__
				TreeStore As GtkTreeStore Ptr
				TreeSelection As GtkTreeSelection Ptr
            #EndIf
            Images          As ImageList Ptr
            SelectedImages       As ImageList Ptr
            Nodes           As TreeNodeCollection
            Declare Sub CollapseAll
            Declare Sub ExpandAll
            Declare Property HideSelection As Boolean
            Declare Property HideSelection(Value As Boolean)
            Declare Property Sorted As Boolean
            Declare Property Sorted(Value As Boolean)
            Declare Property ShowHint As Boolean
            Declare Property ShowHint(Value As Boolean)
            Declare Property SelectedNode As TreeNode Ptr
            Declare Property SelectedNode(Value As TreeNode Ptr)
            Declare Operator Cast As Control Ptr 
            Declare Constructor
            Declare Destructor
            OnNodeActivate As Sub(BYREF Sender As TreeView, BYREF Item As TreeNode)
            OnNodeClick As Sub(BYREF Sender As TreeView, BYREF Item As TreeNode)
            OnNodeDblClick As Sub(BYREF Sender As TreeView, BYREF Item As TreeNode)
            OnSelChange As Sub(BYREF Sender As TreeView, BYREF Item As TreeNode)
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
'#if _WIN32_WINNT = &h0602
'    const TVS_EX_MULTISELECT = &h2
'    const TVS_EX_DOUBLEBUFFER = &h4
'    const TVS_EX_NOINDENTSTATE = &h8
'    const TVS_EX_RICHTOOLTIP = &h10
'    const TVS_EX_AUTOHSCROLL = &h20
'    const TVS_EX_FADEINOUTEXPANDOS = &h40
'    const TVS_EX_PARTIALCHECKBOXES = &h80
'    const TVS_EX_EXCLUSIONCHECKBOXES = &h100
'    const TVS_EX_DIMMEDCHECKBOXES = &h200
'    const TVS_EX_DRAWIMAGEASYNC = &h400
'#endif

#IfNDef __USE_MAKE__
	#Include Once "TreeView.bas"
#EndIf
