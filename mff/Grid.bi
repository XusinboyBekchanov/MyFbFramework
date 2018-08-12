'###############################################################################
'#  Grid.bi                                                                #
'#  This file is part of MyFBFramework                                    #
'#  Version 1.0.0                                                              #
'###############################################################################

#Include Once "Control.bi"

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

    Sub GridItem.SelectItem
        If Parent AndAlso Parent->Handle Then
            Dim lvi As LVITEM
            lvi.iItem = Index
            lvi.iSubItem   = 0
                lvi.state    = LVIS_SELECTED
            lvi.statemask = LVNI_SELECTED
                ListView_SetItem(Parent->Handle, @lvi)
        End If
    End Sub

    Property GridItem.Text(iSubItem As Integer) ByRef As WString
        If Parent AndAlso Parent->Handle Then
            WReallocate FText, 255
            Dim lvi As LVITEM
            lvi.Mask = LVIF_TEXT
            lvi.iItem = Index
            lvi.iSubItem   = iSubItem
                lvi.pszText    = FText
                lvi.cchTextMax = 255
              ListView_GetItem(Parent->Handle, @lvi)
            Return *FText
          End If
        Return WGet(FText)
    End Property

    Property GridItem.Text(iSubItem As Integer, ByRef Value As WString)
        WLet FText, Value
        If Parent AndAlso Parent->Handle Then
            Dim lvi As LVITEM
            lvi.Mask = LVIF_TEXT
            lvi.iItem = Index
            lvi.iSubItem   = iSubItem
                lvi.pszText    = FText
                lvi.cchTextMax = Len(*FText)
              ListView_SetItem(Parent->Handle, @lvi)
          End If 
    End Property

    Property GridItem.Hint ByRef As WString
        Return WGet(FHint)
    End Property

    Property GridItem.Hint(ByRef Value As WString)
        WLet FHint, Value
    End Property


    Property GridItem.ImageIndex As Integer
        Return FImageIndex
    End Property

    Property GridItem.ImageIndex(Value As Integer)
        If Value <> FImageIndex Then
            FImageIndex = Value
            If Parent Then 
                With QControl(Parent)
                    '.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
                End With
            End If
        End If
    End Property

    Property GridItem.SelectedImageIndex As Integer
        Return FImageIndex
    End Property

    Property GridItem.SelectedImageIndex(Value As Integer)
        If Value <> FSelectedImageIndex Then
            FSelectedImageIndex = Value
            If Parent Then 
                With QControl(Parent)
                    '.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
                End With
            End If
        End If
    End Property

    Property GridItem.Visible As Boolean
        Return FVisible
    End Property

    Property GridItem.Visible(Value As Boolean)
        If Value <> FVisible Then
            FVisible = Value
            If Parent Then 
                With QControl(Parent)
                    '.Perform(TB_HIDEBUTTON, FCommandID, MakeLong(NOT FVisible, 0))
                End With
            End If
        End If
    End Property

    Operator GridItem.Cast As Any Ptr
        Return @This
    End Operator

    Constructor GridItem
        FHint = CAllocate(0)
        FText = CAllocate(0)
        FVisible    = 1
        Text(0)    = ""
        Hint       = ""
        FImageIndex = -1
        FSelectedImageIndex = -1
        FSmallImageIndex = -1
    End Constructor

    Destructor GridItem
        If FHint Then Deallocate FHint
        If FText Then Deallocate FText
    End Destructor
    
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

    Sub GridColumn.SelectItem
        If Parent AndAlso Parent->Handle Then ListView_SetSelectedColumn(Parent->Handle, Index)
    End Sub

    Property GridColumn.Text ByRef As WString
        Return WGet(FText)
    End Property

    Property GridColumn.Text(ByRef Value As WString)
        WLet FText, Value
        If Parent AndAlso Parent->Handle Then
            Dim lvc As LVCOLUMN
            lvc.mask = TVIF_TEXT
            lvc.iSubItem = Index
            lvc.pszText = FText
            lvc.cchTextMax = Len(*FText)
            ListView_SetColumn(Parent->Handle, Index, @lvc)
          End If 
    End Property

    Property GridColumn.Width As Integer
        Return FWidth
    End Property

    Property GridColumn.Width(Value As Integer)
        FWidth = Value
        If Parent AndAlso Parent->Handle Then
            Dim lvc As LVCOLUMN
            lvc.mask = LVCF_WIDTH OR LVCF_SUBITEM
            lvc.iSubItem = Index
            ListView_SetColumn(Parent->Handle, Index, @lvc)
          End If 
    End Property

    Property GridColumn.Format As GridColumnFormat
        Return FFormat
    End Property

    Property GridColumn.Format(Value As GridColumnFormat)
        FFormat = Value
        If Parent AndAlso Parent->Handle Then
            Dim lvc As LVCOLUMN
            lvc.mask = LVCF_FMT OR LVCF_SUBITEM
            lvc.iSubItem = Index
            lvc.fmt = Value
            ListView_SetColumn(Parent->Handle, Index, @lvc)
          End If 
    End Property

    Property GridColumn.Hint ByRef As WString
        Return WGet(FHint)
    End Property

    Property GridColumn.Hint(ByRef Value As WString)
        WLet FHint, Value
    End Property


    Property GridColumn.ImageIndex As Integer
        Return FImageIndex
    End Property

    Property GridColumn.ImageIndex(Value As Integer)
        If Value <> FImageIndex Then
            FImageIndex = Value
            If Parent Then 
                With QControl(Parent)
                    '.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
                End With
            End If
        End If
    End Property

    Property GridColumn.Visible As Boolean
        Return FVisible
    End Property

    Property GridColumn.Visible(Value As Boolean)
        If Value <> FVisible Then
            FVisible = Value
            If Parent Then 
                With QControl(Parent)
                    '.Perform(TB_HIDEBUTTON, FCommandID, MakeLong(NOT FVisible, 0))
                End With
            End If
        End If
    End Property

    Operator GridColumn.Cast As Any Ptr
        Return @This
    End Operator

    Constructor GridColumn
        FHint = CAllocate(0)
        FText = CAllocate(0)
        FVisible    = 1
        Text    = ""
        Hint       = ""
        FImageIndex = -1
    End Constructor

    Destructor GridColumn
        If FHint Then Deallocate FHint
        If FText Then Deallocate FText
    End Destructor

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

    Property GridItems.Count As Integer
        Return FItems.Count
    End Property

    Property GridItems.Count(Value As Integer)
    End Property

    Property GridItems.Item(Index As Integer) As GridItem Ptr
        Return QGridItem(FItems.Items[Index])
    End Property

    Property GridItems.Item(Index As Integer, Value As GridItem Ptr)
       'QToolButton(FItems.Items[Index]) = Value 
    End Property

    Function GridItems.Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1) As GridItem Ptr
        Dim As GridItem Ptr PItem
        Dim As LVITEM lvi
        PItem = New GridItem
        FItems.Add PItem
        With *PItem
            .ImageIndex     = FImageIndex
            .Text(0)        = FCaption
            .Index    = FItems.Count - 1
        End With
        lvi.Mask = LVIF_TEXT or LVIF_IMAGE
        lvi.pszText  = @FCaption
        lvi.cchTextMax = Len(FCaption)
        lvi.iItem = PItem->Index
        lvi.iSubItem = 0
        lvi.iImage   = FImageIndex
        If Parent Then
           PItem->Parent = Parent
           If Parent->Handle Then ListView_InsertItem(Parent->Handle, @lvi)
        End If
        Return PItem
    End Function

    Sub GridItems.Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1)
        Dim As GridItem Ptr PItem
        Dim As LVITEM lvi
        PItem = New GridItem
        FItems.Insert Index, PItem
        With *PItem
            .ImageIndex     = FImageIndex
            .Text(0)        = FCaption
            .Index    = Index
        End With
        lvi.Mask = LVIF_TEXT or LVIF_IMAGE
        lvi.pszText  = @FCaption
        lvi.cchTextMax = Len(FCaption)
        lvi.iItem = PItem->Index
        lvi.iImage   = FImageIndex
        If Parent Then
           PItem->Parent = Parent
           If Parent->Handle Then ListView_InsertItem(Parent->Handle, @lvi)
        End If
    End Sub

    Sub GridItems.Remove(Index As Integer)
        FItems.Remove Index
        If Parent AndAlso Parent->Handle Then
            ListView_DeleteItem(Parent->Handle, Index)
        End If
    End Sub

    Function GridItems.IndexOf(BYREF FItem As GridItem Ptr) As Integer
        Return FItems.IndexOF(FItem)
    End Function

    Sub GridItems.Clear
        If Parent AndAlso Parent->Handle Then Parent->Perform LVM_DELETEALLITEMS, 0, 0 
        For i As Integer = Count -1 To 0 Step -1
            Delete @QGridItem(FItems.Items[i])
        Next i
        FItems.Clear
    End Sub

    Operator GridItems.Cast As Any Ptr
        Return @This
    End Operator

    Constructor GridItems
        This.Clear
    End Constructor

    Destructor GridItems
         This.Clear
    End Destructor

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

    Property GridColumns.Count As Integer
        Return FColumns.Count
    End Property

    Property GridColumns.Count(Value As Integer)
    End Property

    Property GridColumns.Column(Index As Integer) As GridColumn Ptr
        Return QGridColumn(FColumns.Items[Index])
    End Property

    Property GridColumns.Column(Index As Integer, Value As GridColumn Ptr)
       'QGridColumn(FColumns.Items[Index]) = Value 
    End Property

    Function GridColumns.Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As integer, Format As GridColumnFormat = gcfLeft) As GridColumn Ptr
        Dim As GridColumn Ptr PColumn
        Dim As LVCOLUMN lvc
        PColumn = New GridColumn
        FColumns.Add PColumn
        With *PColumn
            .ImageIndex     = FImageIndex
            .Text        = FCaption
            .Index = FColumns.Count - 1
            .Width     = iWidth
            .Format = Format
        End With
        lvC.mask      =  LVCF_FMT OR LVCF_WIDTH OR LVCF_TEXT OR LVCF_SUBITEM
        lvC.fmt       =  Format
        lvc.cx=0
        lvc.iImage   = PColumn->ImageIndex
        lvc.iSubItem = PColumn->Index
        lvc.pszText  = @FCaption
        lvc.cchTextMax = Len(FCaption)
        If Parent Then
               PColumn->Parent = Parent
               If Parent->Handle Then
                ListView_InsertColumn(Parent->Handle, PColumn->Index, @lvc)
                ListView_SetColumnWidth(Parent->Handle, PColumn->Index, iWidth)
            End If
        End If
        Return PColumn
    End Function

    Sub GridColumns.Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As integer, Format As GridColumnFormat = gcfLeft)
        Dim As GridColumn Ptr PColumn
        Dim As LVCOLUMN lvc
        PColumn = New GridColumn
        FColumns.Insert Index, PColumn
        With *PColumn
            .ImageIndex     = FImageIndex
            .Text        = FCaption
            .Index        = FColumns.Count - 1
            .Width     = iWidth
            .Format = Format
        End With
        lvC.mask      =  LVCF_FMT OR LVCF_WIDTH OR LVCF_TEXT OR LVCF_SUBITEM
        lvC.fmt       =  Format
        lvc.cx=0
        lvc.iImage   = PColumn->ImageIndex
        lvc.iSubItem = PColumn->Index
        lvc.pszText  = @FCaption
        lvc.cchTextMax = Len(FCaption)
        If Parent Then
            PColumn->Parent = Parent
            If Parent->Handle Then
                ListView_InsertColumn(Parent->Handle, Index, @lvc)
                ListView_SetColumnWidth(Parent->Handle, Index, iWidth)
            End If
        End If
    End Sub

    Sub GridColumns.Remove(Index As Integer)
        FColumns.Remove Index
        If Parent AndAlso Parent->Handle Then
            Parent->Perform LVM_DELETECOLUMN, cast(WPARAM, Index), 0
        End If
    End Sub

    Function GridColumns.IndexOf(BYREF FColumn As GridColumn Ptr) As Integer
        Return FColumns.IndexOF(FColumn)
    End Function

    Sub GridColumns.Clear
        For i As Integer = Count -1 To 0 Step -1
            Delete @QGridColumn(FColumns.Items[i])
            Remove i
        Next i
        FColumns.Clear
    End Sub

    Operator GridColumns.Cast As Any Ptr
        Return @This
    End Operator

    Constructor GridColumns
        This.Clear
    End Constructor

    Destructor GridColumns
         This.Clear
    End Destructor

    Type Grid Extends Control
        Private:
            Declare Static Sub WndProc(BYREF Message As Message)
            Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
            Declare Static Sub HandleIsDestroyed(BYREF Sender As Control)
            Declare Sub ProcessMessage(BYREF Message As Message)
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

    Property Grid.SelectedItem As GridItem Ptr
        If Handle Then
            Dim As Integer item = ListView_GetNextItem(Handle, -1, LVNI_SELECTED)
            If item <> -1 Then Return ListItems.Item(item)
        End If
        Return 0
    End Property

    Property Grid.SelectedItem(Value As GridItem Ptr)
        Value->SelectItem
    End Property

    Property Grid.SelectedColumn As GridColumn Ptr
        If Handle Then
            Return Columns.Column(ListView_GetSelectedColumn(Handle))
        End If
        Return 0
    End Property

    Property Grid.SelectedColumn(Value As GridColumn Ptr)
        If Handle Then ListView_SetSelectedColumn(Handle, Value->Index)
    End Property

    Property Grid.ShowHint As Boolean
        Return FShowHint
    End Property

    Property Grid.ShowHint(Value As Boolean)
        FShowHint = Value
    End Property

    Sub Grid.WndProc(BYREF Message As Message)
    End Sub

    Sub Grid.ProcessMessage(BYREF Message As Message)
        '?message.msg, GetMessageName(message.msg)
        Select Case Message.Msg
        Case WM_PAINT
            Message.Result = 0
        Case WM_SIZE
        Case CM_NOTIFY
            Dim lvp As NMListView Ptr = Cast(NMListView Ptr, message.lparam)
            If lvp->iItem <> -1 Then
                   Select Case lvp->hdr.code
                Case NM_CLICK: If OnItemClick Then OnItemClick(This, *ListItems.Item(lvp->iItem))
                Case NM_DBLCLK: If OnItemDblClick Then OnItemDblClick(This, *ListItems.Item(lvp->iItem))
                'Case NM_KEYDOWN: If OnItemDblClick Then OnItemDblClick(This, *ListItems.Item(lvp->iItem))
                End Select
            End If
        Case CM_COMMAND
            Select Case message.Wparam
            Case LVN_KEYDOWN
            Case LVN_ITEMCHANGING
            Case LVN_ITEMCHANGED
            Case LVN_INSERTITEM
            Case LVN_DELETEITEM
            Case LVN_DELETEALLITEMS
            Case LVN_BEGINLABELEDIT
            Case LVN_ENDLABELEDIT
            Case LVN_COLUMNCLICK
            Case LVN_BEGINDRAG
            Case LVN_BEGINRDRAG
            Case LVN_ODCACHEHINT
            Case LVN_ODFINDITEM
            Case LVN_ITEMACTIVATE
            Case LVN_ODSTATECHANGED
            Case LVN_HOTTRACK
            Case LVN_GETDISPINFO
            Case LVN_SETDISPINFO
            'Case LVN_COLUMNDROPDOWN
            Case LVN_GETINFOTIP
            'Case LVN_COLUMNOVERFLOWCLICK
            Case LVN_INCREMENTALSEARCH
            Case LVN_BEGINSCROLL
            Case LVN_ENDSCROLL
            'Case LVN_LINKCLICK
            'Case LVN_GETEMPTYMARKUP
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

    Sub Grid.HandleIsDestroyed(BYREF Sender As Control)
    End Sub

    Sub Grid.HandleIsAllocated(BYREF Sender As Control)
        If Sender.Child Then
            With QGrid(Sender.Child)
                If .Images Then
                    .Images->ParentWindow = .Handle
                    If .Images->Handle Then ListView_SetImageList(.FHandle, CInt(.Images->Handle), LVSIL_NORMAL)
                End If
                If .SelectedImages Then .SelectedImages->ParentWindow = .Handle
                If .SmallImages Then .SmallImages->ParentWindow = .Handle
                If .GroupHeaderImages Then .GroupHeaderImages->ParentWindow = .Handle
                If .Images AndAlso .Images->Handle Then ListView_SetImageList(.FHandle, CInt(.Images->Handle), LVSIL_NORMAL)
                If .SelectedImages AndAlso .SelectedImages->Handle Then ListView_SetImageList(.FHandle, CInt(.SelectedImages->Handle), LVSIL_STATE)
                If .SmallImages AndAlso .SmallImages->Handle Then ListView_SetImageList(.FHandle, CInt(.SmallImages->Handle), LVSIL_SMALL)
                If .GroupHeaderImages AndAlso .GroupHeaderImages->Handle Then ListView_SetImageList(.FHandle, CInt(.GroupHeaderImages->Handle), LVSIL_GROUPHEADER)
                Dim lvStyle As Integer
                lvStyle = SendMessage(.FHandle, LVM_GETEXTENDEDListViewSTYLE, 0, 0)
                lvStyle = lvStyle Or  LVS_EX_GRIDLINES Or LVS_EX_FULLROWSELECT
                SendMessage(.FHandle, LVM_SETEXTENDEDListViewSTYLE, 0, ByVal lvStyle)
                For i As Integer = 0 To .Columns.Count -1
                    dim lvc as LVCOLUMN
                    lvC.mask      =  LVCF_FMT OR LVCF_WIDTH OR LVCF_TEXT OR LVCF_SUBITEM
                    lvC.fmt       =  .Columns.Column(i)->Format
                    lvc.cx=0
                    lvc.pszText              = @.Columns.Column(i)->Text
                      lvc.cchTextMax           = len(.Columns.Column(i)->text)
                      lvc.iImage             = .Columns.Column(i)->ImageIndex
                    lvc.iSubItem         = i
                      ListView_InsertColumn(.FHandle, i, @lvc)
                    ListView_SetColumnWidth(.FHandle, i, .Columns.Column(i)->Width)
                Next i
                For i As Integer = 0 To .ListItems.Count -1
                    dim lvi as LVITEM
                    lvi.Mask = LVIF_TEXT or LVIF_IMAGE
                    lvi.pszText              = @.ListItems.Item(i)->Text(0) 
                      lvi.cchTextMax           = len(.ListItems.Item(i)->text(0))
                    lvi.iItem             = i
                      lvi.iImage             = .ListItems.Item(i)->ImageIndex
                      ListView_InsertItem(.FHandle, @lvi)
                Next i
            End With
        End If
    End Sub

    Operator Grid.Cast As Control Ptr 
        Return @This
    End Operator

    Constructor Grid
        ListItems.Parent = @This
        Columns.Parent = @This
        FEnabled = True
        FVisible = True
        With This
            .OnHandleIsAllocated = @HandleIsAllocated
            .OnHandleIsDestroyed = @HandleIsDestroyed
            .RegisterClass "Grid", WC_ListView
            .Child             = @This
            .ChildProc         = @WndProc
            WLet FClassName, "Grid"
            WLet FClassAncestor, WC_ListView
            .ExStyle           = WS_EX_CLIENTEDGE
            .Style             = WS_CHILD Or WS_TABSTOP Or WS_VISIBLE Or LVS_REPORT Or LVS_SINGLESEL Or LVS_SHOWSELALWAYS
            .Width             = 121
            .Height            = 121
        End With 
    End Constructor

    Destructor Grid
        UnregisterClass "Grid",GetmoduleHandle(NULL)
    End Destructor
End Namespace

'TODO:
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
