'###############################################################################
'#  TreeView.bi                                                                 #
'#  This file is part of MyFBFramework                                            #
'#  Version 1.0.0                                                              #
'###############################################################################

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
            Declare Function FindByHandle(hti As HTREEItem) As PTreeNode
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
            Handle As HTREEITEM
            Declare Sub SelectItem
            Declare Sub Expand
            Declare Function IsExpanded As Boolean
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
            Declare Static Sub WndProc(BYREF Message As Message)
            Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
            Declare Static Sub HandleIsDestroyed(BYREF Sender As Control)
            Declare Sub ProcessMessage(BYREF Message As Message)
        Public:
            Images          As ImageList Ptr
            SelectedImages       As ImageList Ptr
            Nodes           As TreeNodeCollection
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
            OnNodeClick As Sub(BYREF Sender As TreeView, BYREF Item As TreeNode)
            OnNodeDblClick As Sub(BYREF Sender As TreeView, BYREF Item As TreeNode)
    End Type

    Sub TreeNode.SelectItem
        If Parent AndAlso Parent->Handle Then TreeView_Select(Parent->Handle, Handle, TVGN_CARET)
    End Sub

    Sub TreeNode.Expand
        If Parent AndAlso Parent->Handle Then TreeView_Expand(Parent->Handle, Handle, TVE_EXPAND)
    End Sub

    Function TreeNode.IsExpanded As Boolean
        If Parent AndAlso Parent->Handle Then Return TreeView_GetItemState(Parent->Handle, Handle, TVIS_EXPANDED)
    End Function

    Function TreeNode.ToString ByRef As WString
        Return This.Name
    End Function

    Property TreeNode.Text ByRef As WString
        Return WGet(FText)
    End Property

    Property TreeNode.Text(ByRef Value As WString)
        WLet FText, Value
        If Parent AndAlso Parent->Handle Then
            Dim tvi As TVITEM
            'tvi.mask = TVIF_HANDLE
            'TreeView_GetItem(Parent->Handle, @tvi)
            tvi.mask = TVIF_TEXT
            tvi.hItem = Handle
            tvi.pszText = FText
            tvi.cchTextMax = Len(*FText)
            TreeView_SetItem(Parent->Handle, @tvi)
          End If 
    End Property

    Property TreeNode.Hint ByRef As WString
        Return WGet(FHint)
    End Property

    Property TreeNode.Hint(ByRef Value As WString)
        WLet FHint, Value
    End Property

    Property TreeNode.Name ByRef As WString
        Return WGet(FName)
    End Property

    Property TreeNode.Name(ByRef Value As WString)
        WLet FName, Value
    End Property

    Property TreeNode.ImageIndex As Integer
        Return FImageIndex
    End Property

    Property TreeNode.ImageIndex(Value As Integer)
        If Value <> FImageIndex Then
            FImageIndex = Value
            If Parent Then 
                With QControl(Parent)
                    '.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
                End With
            End If
        End If
    End Property

    Property TreeNode.ImageKey ByRef As WString
        Return WGet(FImageKey)
    End Property

    Property TreeNode.ImageKey(ByRef Value As WString)
        If Value <> FImageIndex Then
            WLet FImageKey, Value
            If Parent Then 
                With QControl(Parent)
                    '.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
                End With
            End If
        End If
    End Property

    Property TreeNode.SelectedImageIndex As Integer
        Return FImageIndex
    End Property

    Property TreeNode.SelectedImageIndex(Value As Integer)
        FImageIndex = Value
        If Parent Then 
            With QControl(Parent)
                '.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
            End With
        End If
    End Property

    Property TreeNode.ParentNode As TreeNode Ptr
        Return FParentNode
    End Property
    
    Property TreeNode.ParentNode(Value As TreeNode Ptr)
        FParentNode = Value
    End Property

    Property TreeNode.SelectedImageKey ByRef As WString
        Return WGet(FSelectedImageKey)
    End Property

    Property TreeNode.SelectedImageKey(ByRef Value As WString)
        WLet FSelectedImageKey, Value
        If Parent Then
            With QControl(Parent)
                '.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
            End With
        End If
    End Property

    Property TreeNode.Visible As Boolean
        Return FVisible
    End Property

    Property TreeNode.Visible(Value As Boolean)
        If Value <> FVisible Then
            FVisible = Value
            If Parent Then 
                With QControl(Parent)
                    '.Perform(TB_HIDEBUTTON, FCommandID, MakeLong(NOT FVisible, 0))
                End With
            End If
        End If
    End Property

    Operator TreeNode.Cast As Any Ptr
        Return @This
    End Operator

    Constructor TreeNode
        Nodes.Clear
        Nodes.Parent = Parent
        Nodes.ParentNode = @This
        FHint = CAllocate(0)
        FText = CAllocate(0)
        FVisible    = 1
        Text    = ""
        Hint       = ""
        FImageIndex = -1
        FSelectedImageIndex = -1
    End Constructor

    Destructor TreeNode
        Nodes.Clear
        WDeAllocate FHint
        WDeAllocate FText
        WDeAllocate FImageKey
        WDeAllocate FSelectedImageKey
    End Destructor
    
    Constructor TreeNodeCollection
        This.Clear
    End Constructor

    Destructor TreeNodeCollection
        This.Clear
    End Destructor
    
    Function TreeNodeCollection.FindByHandle(hti As HTREEItem) As TreeNode Ptr
        If ParentNode AndAlso ParentNode->Handle = hti Then Return ParentNode
        Dim As TreeNode Ptr tn
        For i as integer = 0 to Count - 1
            tn = Item(i)->Nodes.FindByHandle(hti)
            If tn <> 0 Then Return tn
        Next i
        Return 0
    End Function

    Property TreeNodeCollection.Count As Integer
        Return FNodes.Count
    End Property

    Property TreeNodeCollection.Count(Value As Integer)
    End Property

    Property TreeNodeCollection.Item(Index As Integer) As TreeNode Ptr
        Return QTreeNode(FNodes.Items[Index])
    End Property

    Property TreeNodeCollection.Item(Index As Integer, Value As TreeNode Ptr)
       'QTreeNode(FNodes.Items[Index]) = Value 
    End Property

    Function TreeNodeCollection.Add(ByRef FText As WString = "", ByRef FKey As WString = "", ByRef FHint As WString = "", FImageIndex As Integer = -1, FSelectedImageIndex As Integer = -1, bSorted As Boolean = False) As PTreeNode
        Dim As TVINSERTSTRUCT tvis
        PNode = New TreeNode
        FNodes.Add PNode
        With *PNode
            .Text         = FText
            .Name         = FKey
            .ImageIndex     = FImageIndex
            .SelectedImageIndex     = FSelectedImageIndex
            .Hint           = FHint
            .Parent         = Parent
            .Nodes.Parent         = Parent
            .ParentNode        = Cast(TreeNode Ptr, ParentNode)
            If Parent AndAlso Parent->Handle Then
                tvis.Item.Mask = TVIF_TEXT or TVIF_IMAGE or TVIF_SELECTEDIMAGE
                tvis.item.pszText              = @Ftext 
                  tvis.item.cchTextMax           = len(Ftext) 
                  tvis.item.iImage             = FImageIndex
                  tvis.item.iSelectedImage     = FSelectedImageIndex 
                  tvis.hInsertAfter            = IIF(Cast(TreeView Ptr, Parent)->Sorted Or bSorted, TVI_SORT, 0)
                  'tvis.hInsertAfter            = 0
                  If .ParentNode Then tvis.hParent               = .ParentNode->Handle
                .Handle        = TreeView_InsertItem(Parent->Handle, @tvis)
            End If
        End With
        Return PNode
    End Function

    Function TreeNodeCollection.Add(ByRef FText As WString = "", ByRef FKey As WString = "", ByRef FHint As WString = "", ByRef FImageKey As WString, ByRef FSelectedImageKey As WString, bSorted As Boolean = False) As TreeNode Ptr
        Dim As TreeNode Ptr PNode
        If Parent AndAlso Cast(TreeView Ptr, Parent)->Images AndAlso Cast(TreeView Ptr, Parent)->SelectedImages Then
            PNode = This.Add(FText, FKey, FHint, Cast(TreeView Ptr, Parent)->Images->IndexOf(FImageKey), Cast(TreeView Ptr, Parent)->SelectedImages->IndexOf(FSelectedImageKey), bSorted)
        Else
            PNode = This.Add(FText, FKey, FHint, -1, -1, bSorted)
        End If
        If PNode Then PNode->ImageKey         = FImageKey: PNode->SelectedImageKey         = FSelectedImageKey
        Return PNode
    End Function    
            
    Function TreeNodeCollection.Insert(Index As Integer, ByRef FText As WString = "", ByRef FKey As WString = "", ByRef FHint As WString = "", FImageIndex As Integer = -1, FSelectedImageIndex As Integer = -1) As PTreeNode
        Dim As TVINSERTSTRUCT tvis
        PNode = New TreeNode
        FNodes.Add PNode
        With *PNode
            .Text         = FText
            .Name         = FKey
            .ImageIndex     = FImageIndex
            .SelectedImageIndex     = FSelectedImageIndex
            .Hint           = FHint
            .Parent         = Parent
            .Nodes.Parent         = Parent
            .ParentNode        = ParentNode
            If Parent->Handle Then
                tvis.Item.Mask = TVIF_TEXT or TVIF_IMAGE or TVIF_SELECTEDIMAGE
                tvis.item.pszText              = @Ftext 
                  tvis.item.cchTextMax           = len(Ftext) 
                  tvis.item.iImage             = FImageIndex
                  tvis.item.iSelectedImage     = FSelectedImageIndex 
                  tvis.hInsertAfter            = Item(Index)->Handle
                If ParentNode Then
                      tvis.hParent               = ParentNode->Handle
                Else
                    tvis.hParent            = TVI_ROOT
                End If
                   .Handle        = TreeView_InsertItem(Parent->Handle, @tvis)
            End If
        End With
        Return PNode
    End Function

    Function TreeNodeCollection.Insert(Index As Integer, ByRef FText As WString = "", ByRef FKey As WString = "", ByRef FHint As WString = "", ByRef FImageKey As WString, ByRef FSelectedImageKey As WString) As TreeNode Ptr
        Dim As TreeNode Ptr PNode
        If Parent AndAlso Cast(TreeView Ptr, Parent)->Images AndAlso Cast(TreeView Ptr, Parent)->SelectedImages Then
            PNode = This.Insert(Index, FText, FKey, FHint, Cast(TreeView Ptr, Parent)->Images->IndexOf(FImageKey), Cast(TreeView Ptr, Parent)->SelectedImages->IndexOf(FSelectedImageKey))
        Else
            PNode = This.Insert(Index, FText, FKey, FHint, -1, -1)
        End If
        If PNode Then PNode->ImageKey         = FImageKey: PNode->SelectedImageKey         = FSelectedImageKey
        Return PNode
    End Function    
    
    Sub TreeNodeCollection.Remove(Index As Integer)
        If Parent AndAlso Parent->Handle Then
            TreeView_DeleteItem(Parent->Handle, Item(Index)->Handle)
        End If
        FNodes.Remove Index
    End Sub

    Function TreeNodeCollection.IndexOf(BYREF FNode As TreeNode Ptr) As Integer
        Return FNodes.IndexOF(FNode)
    End Function

    Function TreeNodeCollection.IndexOf(ByRef Text As WString) As Integer
        For i As Integer = 0 To Count - 1
            If Item(i)->Text = Text Then Return i
        Next i
        Return -1
    End Function

    Function TreeNodeCollection.IndexOfKey(ByRef Key As WString) As Integer
        For i As Integer = 0 To Count - 1
            If Item(i)->Name = Key Then Return i
        Next i
        Return -1
    End Function

    Function TreeNodeCollection.Contains(ByRef FNode As TreeNode Ptr) As Boolean
        Return IndexOF(FNode) <> -1
    End Function

    Function TreeNodeCollection.Contains(ByRef Text As WString) As Boolean
        Return IndexOF(Text) <> -1
    End Function

    Function TreeNodeCollection.ContainsKey(ByRef Key As WString) As Boolean
        Return IndexOFKey(Key) <> -1
    End Function

    Property TreeNodeCollection.ParentNode As PTreeNode
        Return FParentNode
    End Property
    
    Property TreeNodeCollection.ParentNode(Value As PTreeNode)
        FParentNode = Value
    End Property
    
    Sub TreeNodeCollection.Clear
        For i As Integer = Count -1 To 0 Step -1
            Delete @QTreeNode(FNodes.Items[i])
            Remove i
        Next i
        FNodes.Clear
    End Sub
    
    Property TreeView.HideSelection As Boolean
        Return FHideSelection
    End Property

    Property TreeView.HideSelection(Value As Boolean)
        FHideSelection = Value
        ChangeStyle TVS_SHOWSELALWAYS, Not Value
    End Property

    Property TreeView.SelectedNode As TreeNode Ptr
        If Handle Then
            Dim As HTREEItem hti = TreeView_GetNextItem(Handle, NULL, TVGN_CARET)
            Return Nodes.FindByHandle(hti)
        End If
        Return 0
    End Property

    Property TreeView.SelectedNode(Value As TreeNode Ptr)
        If Handle Then TreeView_Select(Handle, Value->Handle, TVGN_CARET)
    End Property
    
    Property TreeView.ShowHint As Boolean
        Return FShowHint
    End Property

    Property TreeView.ShowHint(Value As Boolean)
        FShowHint = Value
    End Property

    Property TreeView.Sorted As Boolean
        Return FSorted
    End Property

    Property TreeView.Sorted(Value As Boolean)
        FSorted = Value
    End Property

    Sub TreeView.WndProc(BYREF Message As Message)
    End Sub

    Sub TreeView.ProcessMessage(BYREF Message As Message)
        Select Case Message.Msg
        Case WM_PAINT
            Message.Result = 0
        Case WM_SIZE
        Case CM_NOTIFY
            Dim tvp As NMTREEVIEW Ptr = Cast(NMTREEVIEW Ptr, message.lparam)
            If tvp->itemNew.hItem <> 0 Then
                   Select Case tvp->hdr.code
                Case NM_CLICK: If OnNodeClick Then OnNodeClick(This, *Nodes.FindByHandle(tvp->itemNew.hItem))
                Case NM_DBLCLK: If OnNodeDblClick Then OnNodeDblClick(This, *Nodes.FindByHandle(tvp->itemNew.hItem))
                Case NM_KILLFOCUS
                Case NM_RCLICK 
                Case NM_RDBLCLK 
                Case NM_RETURN: If OnNodeDblClick Then OnNodeDblClick(This, *Nodes.FindByHandle(tvp->itemNew.hItem))
                Case NM_SETCURSOR
                Case NM_SETFOCUS
                'Case NM_KEYDOWN: If OnItemDblClick Then OnItemDblClick(This, *ListItems.Item(lvp->iItem))
                End Select
            End If
        Case CM_COMMAND
            Select Case message.Wparam
            Case TVN_KEYDOWN
                
            Case TVN_GETINFOTIP
            Case TVN_SINGLEEXPAND
            Case TVN_SELCHANGING
            Case TVN_SELCHANGED
            Case TVN_GETDISPINFO
            Case TVN_GETINFOTIP
            Case TVN_SETDISPINFO
            Case TVN_ITEMCHANGED
            Case TVN_ITEMCHANGING
            Case TVN_ITEMEXPANDING
            Case TVN_ITEMEXPANDED
            Case TVN_BEGINDRAG
            Case TVN_BEGINRDRAG
            Case TVN_DELETEITEM
            Case TVN_BEGINLABELEDIT
            Case TVN_ENDLABELEDIT
            Case TVN_ITEMCHANGINGW
            Case TVN_ITEMCHANGED
            Case TVN_ASYNCDRAW
            End Select
        Case CM_NOTIFY
'            Dim As TBNOTIFY PTR Tbn
'            Dim As TBBUTTON TB
'            Dim As RECT R
'            Dim As Integer i
'            Tbn = Cast(TBNOTIFY PTR,Message.lParam) 
'            Select Case Tbn->hdr.Code
'            Case TBN_DROPDOWN
'                 If Tbn->iItem <> -1 Then 
'                     SendMessage(Tbn->hdr.hwndFrom,TB_GETRECT,Tbn->iItem,CInt(@R))
'                     MapWindowPoints(Tbn->hdr.hwndFrom,0,Cast(Point Ptr,@R),2)
'                     i = SendMessage(Tbn->hdr.hwndFrom,TB_COMMANDTOINDEX,Tbn->iItem,0)
'                     If SendMessage(Tbn->hdr.hwndFrom,TB_GETBUTTON,i,CInt(@TB)) Then
'                         TrackPopupMenu(Buttons.Button(i)->DropDownMenu.Handle,0,R.Left,R.Bottom,0,Tbn->hdr.hwndFrom,NULL)
'                     End If 
'                 End If
'            End Select
        Case CM_NEEDTEXT       
'            Dim As LPTOOLTIPTEXT TTX
'            TTX = Cast(LPTOOLTIPTEXT,Message.lParam)
'            TTX->hInst = GetModuleHandle(NULL)
'            If TTX->hdr.idFrom Then
'                Dim As TBButton TB
'                Dim As Integer Index
'                Index = Perform(TB_COMMANDTOINDEX,TTX->hdr.idFrom,0)
'                If Perform(TB_GETBUTTON,Index,CInt(@TB)) Then
'                   If Buttons.Button(Index)->ShowHint Then
'                      If Buttons.Button(Index)->Hint <> "" Then
'                          'Dim As UString s 
'                          's = Buttons.Button(Index).Hint
'                          TTX->lpszText = @(Buttons.Button(Index)->Hint)
'                      End If
'                   End If
'                End If
'            End If
        End Select
        Base.ProcessMessage(Message)
    End Sub

    Sub TreeView.HandleIsDestroyed(BYREF Sender As Control)
    End Sub

    Sub TreeView.CreateNodes(PNode As TreeNode Ptr)
        With PNode->Nodes
            For i As Integer = 0 To .Count - 1
                dim tvis as TVINSERTSTRUCT
                tvis.Item.Mask = TVIF_TEXT or TVIF_IMAGE or TVIF_SELECTEDIMAGE
                tvis.item.pszText              = @.Item(i)->text 
                  tvis.item.cchTextMax           = len(.Item(i)->text) 
                  tvis.item.iImage             = .Item(i)->ImageIndex
                  tvis.item.iSelectedImage     = .Item(i)->SelectedImageIndex 
                  tvis.hInsertAfter            = 0
                If .Item(i)->ParentNode Then
                      tvis.hParent               = .Item(i)->ParentNode->Handle
                Else
                    tvis.hParent            = TVI_ROOT
                End If
                  Nodes.Item(i)->Handle        = TreeView_InsertItem(FHandle, @tvis )
                CreateNodes Nodes.Item(i)
            Next i
        End With
    End Sub

    Sub TreeView.HandleIsAllocated(BYREF Sender As Control)
        If Sender.Child Then
            With QTreeView(Sender.Child)
                If .Images Then .Images->ParentWindow = .Handle
                If .SelectedImages Then .SelectedImages->ParentWindow = .Handle
                '.Perform(TB_BUTTONSTRUCTSIZE,SizeOF(TBBUTTON),0)
                '.Perform(TB_SETEXTENDEDSTYLE, 0, .Perform(TB_GETEXTENDEDSTYLE, 0, 0) OR TBSTYLE_EX_DRAWDDARROWS)
                '.Perform(TB_SETBUTTONSIZE,0,MakeLong(.ButtonWidth,.ButtonHeight))
                '.Perform(TB_SETBITMAPSIZE,0,MakeLong(.ButtonWidth,.ButtonHeight))
                If .Images AndAlso .Images->Handle Then TreeView_SetImageList(.FHandle, CInt(.Images->Handle), TVSIL_NORMAL)
                If .SelectedImages AndAlso .SelectedImages->Handle Then TreeView_SetImageList(.FHandle, CInt(.SelectedImages->Handle), TVSIL_STATE)
                For i As Integer = 0 To .Nodes.Count -1
                    dim tvis as TVINSERTSTRUCT
                    tvis.Item.Mask = TVIF_TEXT or TVIF_IMAGE or TVIF_SELECTEDIMAGE
                    tvis.item.pszText              = @.Nodes.Item(i)->text 
                      tvis.item.cchTextMax           = len(.Nodes.Item(i)->text)
                      tvis.item.iImage             = .Nodes.Item(i)->ImageIndex
                      tvis.item.iSelectedImage     = .Nodes.Item(i)->SelectedImageIndex 
                      tvis.hInsertAfter            = 0
                    tvis.hParent            = TVI_ROOT
                    .Nodes.Item(i)->Handle        = TreeView_InsertItem(.FHandle, @tvis)
                    .CreateNodes .Nodes.Item(i)
                Next i
            End With
        End If
    End Sub

    Operator TreeView.Cast As Control Ptr 
        Return @This
    End Operator

    Constructor TreeView
        Nodes.Clear
        Nodes.Parent = @This
        FEnabled = True
        FVisible = True
        With This
            .OnHandleIsAllocated = @HandleIsAllocated
            .OnHandleIsDestroyed = @HandleIsDestroyed
            .RegisterClass "TreeView", WC_TREEVIEW
            .Child             = @This
            .ChildProc         = @WndProc
            WLet FClassName, "TreeView"
            WLet FClassAncestor, WC_TREEVIEW
            .ExStyle           = WS_EX_CLIENTEDGE
            .Style             = WS_CHILD Or WS_VISIBLE or TVS_HASLINES or TVS_LINESATROOT or TVS_HASBUTTONS
            .Width             = 121
            .Height            = 121
        End With 
    End Constructor

    Destructor TreeView
        Nodes.Clear
        UnregisterClass "TreeView",GetmoduleHandle(NULL)
    End Destructor
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
