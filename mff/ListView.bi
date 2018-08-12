'###############################################################################
'#  ListView.bi                                                                #
'#  This file is part of MyFBFramework                                    #
'#  Version 1.0.0                                                              #
'###############################################################################

#Include Once "Control.bi"

Const LVCFMT_FILL = &h200000

Enum SortStyle
    ssNone
    ssSortAscending
    ssSortDescending
End Enum

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

Namespace My.Sys.Forms
    #DEFINE QListView(__Ptr__) *Cast(ListView Ptr,__Ptr__)
    #DEFINE QListViewItem(__Ptr__) *Cast(ListViewItem Ptr,__Ptr__)
    #DEFINE QListViewColumn(__Ptr__) *Cast(ListViewColumn Ptr,__Ptr__)
    
    Type ListViewItem Extends My.Sys.Object
        Private:
            FText               As WString Ptr
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
            Dim lvi             As LVITEM
        Public:
            Index As Integer
            Parent   As Control Ptr
            Tag As Any Ptr
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
            OnClick As Sub(BYREF Sender As My.Sys.Object)
            OnDblClick As Sub(BYREF Sender As My.Sys.Object)
    End Type

    Sub ListViewItem.SelectItem
        If Parent AndAlso Parent->Handle Then
            Dim lvi As LVITEM
            lvi.iItem = Index
            lvi.iSubItem   = 0
            lvi.state    = LVIS_SELECTED
            lvi.statemask = LVNI_SELECTED
            ListView_SetItem(Parent->Handle, @lvi)
        End If
    End Sub

    Dim Shared As WString Ptr ListViewText
    Property ListViewItem.Text(iSubItem As Integer) ByRef As WString
        If Parent AndAlso Parent->Handle Then
            WReallocate ListViewText, 255
            lvi.Mask = LVIF_TEXT
            lvi.iItem = Index
            lvi.iSubItem   = iSubItem
            lvi.pszText    = ListViewText
            lvi.cchTextMax = 255
            ListView_GetItem(Parent->Handle, @lvi)
            Return *ListViewText
        Else
            Return WStr("")
        End If
    End Property

    Property ListViewItem.Text(iSubItem As Integer, ByRef Value As WString)
        WLet FText, Value
        If Parent AndAlso Parent->Handle Then
            lvi.Mask = LVIF_TEXT
            lvi.iItem = Index
            lvi.iSubItem   = iSubItem
            lvi.pszText    = FText
            lvi.cchTextMax = Len(*FText)
            ListView_SetItem(Parent->Handle, @lvi)
        End If 
    End Property

    Property ListViewItem.State As Integer
        If Parent AndAlso Parent->Handle Then
            lvi.Mask = LVIF_STATE
            lvi.iItem = Index
            lvi.iSubItem   = 0
            ListView_GetItem(Parent->Handle, @lvi)
            FState = lvi.state
        End If
        Return FState
    End Property

    Property ListViewItem.State(Value As Integer)
        FState = Value
        If Parent AndAlso Parent->Handle Then
            lvi.Mask = LVIF_STATE
            lvi.iItem = Index
            lvi.iSubItem   = 0
            lvi.State    = Value
            ListView_SetItem(Parent->Handle, @lvi)
        End If 
    End Property

    Property ListViewItem.Indent As Integer
        If Parent AndAlso Parent->Handle Then
            lvi.Mask = LVIF_INDENT
            lvi.iItem = Index
            lvi.iSubItem   = 0
            ListView_GetItem(Parent->Handle, @lvi)
            FIndent = lvi.iIndent
        End If
        Return FIndent
    End Property

    Property ListViewItem.Indent(Value As Integer)
        FIndent = Value
        If Parent AndAlso Parent->Handle Then
            lvi.Mask = LVIF_INDENT
            lvi.iItem = Index
            lvi.iSubItem   = 0
            lvi.iIndent    = Value
            ListView_SetItem(Parent->Handle, @lvi)
        End If 
    End Property

    Property ListViewItem.Hint ByRef As WString
        Return WGet(FHint)
    End Property

    Property ListViewItem.Hint(ByRef Value As WString)
        WLet FHint, Value
    End Property


    Property ListViewItem.ImageIndex As Integer
        Return FImageIndex
    End Property

    Property ListViewItem.ImageIndex(Value As Integer)
        If Value <> FImageIndex Then
            FImageIndex = Value
            If Parent Then 
                With QControl(Parent)
                    '.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
                End With
            End If
        End If
    End Property

    Property ListViewItem.SelectedImageIndex As Integer
        Return FImageIndex
    End Property

    Property ListViewItem.SelectedImageIndex(Value As Integer)
        If Value <> FSelectedImageIndex Then
            FSelectedImageIndex = Value
            If Parent Then 
                With QControl(Parent)
                    '.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
                End With
            End If
        End If
    End Property

    Property ListViewItem.Visible As Boolean
        Return FVisible
    End Property
    
    Property ListViewItem.ImageKey ByRef As WString
        Return WGet(FImageKey)
    End Property

    Property ListViewItem.ImageKey(ByRef Value As WString)
        'If Value <> *FImageKey Then
            WLet FImageKey, Value
            If Parent Then 
                With QControl(Parent)
                    '.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
                End With
            End If
        'End If
    End Property

    Property ListViewItem.SelectedImageKey ByRef As WString
        Return WGet(FImageKey)
    End Property

    Property ListViewItem.SelectedImageKey(ByRef Value As WString)
        'If Value <> *FSelectedImageKey Then
            WLet FSelectedImageKey, Value
            If Parent Then 
                With QControl(Parent)
                    '.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
                End With
            End If
        'End If
    End Property

    Property ListViewItem.Visible(Value As Boolean)
        If Value <> FVisible Then
            FVisible = Value
            If Parent Then 
                With QControl(Parent)
                    '.Perform(TB_HIDEBUTTON, FCommandID, MakeLong(NOT FVisible, 0))
                End With
            End If
        End If
    End Property

    Operator ListViewItem.Cast As Any Ptr
        Return @This
    End Operator

    Constructor ListViewItem
        FHint = CAllocate(0)
        FText = CAllocate(0)
        FVisible    = 1
        Text(0)    = ""
        Hint       = ""
        FImageIndex = -1
        FSelectedImageIndex = -1
        FSmallImageIndex = -1
    End Constructor

    Destructor ListViewItem
        If FHint Then Deallocate FHint
        If FText Then Deallocate FText
        If FImageKey Then Deallocate FImageKey
        If FSelectedImageKey Then Deallocate FSelectedImageKey
        If FSmallImageKey Then Deallocate FSmallImageKey
    End Destructor
    
    Type ListViewColumn Extends My.Sys.Object
        Private:
            FText            As WString Ptr
            FHint            As WString Ptr
            FImageIndex   As Integer
            FWidth      As Integer
            FFormat      As ColumnFormat
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
            Declare Property Format As ColumnFormat
            Declare Property Format(Value As ColumnFormat)
            Declare Operator Cast As Any Ptr
            Declare Constructor
            Declare Destructor
            OnClick As Sub(BYREF Sender As My.Sys.Object)
            OnDblClick As Sub(BYREF Sender As My.Sys.Object)
    End Type

    Type ListViewColumns
        Private:
            FColumns As List
        Public:
            Parent   As Control Ptr
            Declare Property Count As Integer
            Declare Property Count(Value As Integer)
            Declare Property Column(Index As Integer) As ListViewColumn Ptr
            Declare Property Column(Index As Integer, Value As ListViewColumn Ptr)
            Declare Function Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As ColumnFormat = cfLeft) As ListViewColumn Ptr
            Declare Sub Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As ColumnFormat = cfLeft)
            Declare Sub Remove(Index As Integer)
            Declare Function IndexOf(BYREF FColumn As ListViewColumn Ptr) As Integer
            Declare Sub Clear
            Declare Operator Cast As Any Ptr
            Declare Constructor
            Declare Destructor
    End Type

    Type ListViewItems
        Private:
            FItems As List
            PItem As ListViewItem Ptr
            lvi As LVITEM
        Public:
            Parent   As Control Ptr
            Declare Property Count As Integer
            Declare Property Count(Value As Integer)
            Declare Property Item(Index As Integer) As ListViewItem Ptr
            Declare Property Item(Index As Integer, Value As ListViewItem Ptr)
            Declare Function Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0) As ListViewItem Ptr
            Declare Function Add(ByRef FCaption As WString = "", ByRef FImageKey As WString, State As Integer = 0, Indent As Integer = 0) As ListViewItem Ptr
            Declare Function Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0) As ListViewItem Ptr
            Declare Sub Remove(Index As Integer)
            Declare Function IndexOf(BYREF FItem As ListViewItem Ptr) As Integer
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
            FSortStyle As SortStyle
            Declare Static Sub WndProc(BYREF Message As Message)
            Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
            Declare Static Sub HandleIsDestroyed(BYREF Sender As Control)
            Declare Sub ProcessMessage(BYREF Message As Message)
        Public:
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
            Declare Property SelectedColumn As ListViewColumn Ptr
            Declare Property SelectedColumn(Value As ListViewColumn Ptr)
            Declare Operator Cast As Control Ptr
            Declare Constructor
            Declare Destructor
            OnItemClick As Sub(BYREF Sender As ListView, BYREF Item As ListViewItem)
            OnItemDblClick As Sub(BYREF Sender As ListView, BYREF Item As ListViewItem)
            OnItemKeyDown As Sub(BYREF Sender As ListView, BYREF Item As ListViewItem)
            OnSelectedItemChanged As Sub(ByRef Sender As ListView, BYREF Item As ListViewItem)
            OnBeginScroll As Sub(ByRef Sender As ListView)
            OnEndScroll As Sub(ByRef Sender As ListView)
    End Type

    Sub ListViewColumn.SelectItem
        If Parent AndAlso Parent->Handle Then ListView_SetSelectedColumn(Parent->Handle, Index)
    End Sub

    Property ListViewColumn.Text ByRef As WString
        Return WGet(FText)
    End Property

    Property ListViewColumn.Text(ByRef Value As WString)
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

    Property ListViewColumn.Width As Integer
        Return FWidth
    End Property

    Property ListViewColumn.Width(Value As Integer)
        FWidth = Value
        If Parent AndAlso Parent->Handle Then
            Dim lvc As LVCOLUMN
            lvc.mask = LVCF_WIDTH OR LVCF_SUBITEM
            lvc.iSubItem = Index
            lvc.cx = Value
            ListView_SetColumn(Parent->Handle, Index, @lvc)
          End If 
    End Property

    Property ListViewColumn.Format As ColumnFormat
        Return FFormat
    End Property

    Property ListViewColumn.Format(Value As ColumnFormat)
        FFormat = Value
        If Parent AndAlso Parent->Handle Then
            Dim lvc As LVCOLUMN
            lvc.mask = LVCF_FMT OR LVCF_SUBITEM
            lvc.iSubItem = Index
            lvc.fmt = Value
            ListView_SetColumn(Parent->Handle, Index, @lvc)
          End If 
    End Property

    Property ListViewColumn.Hint ByRef As WString
        Return WGet(FHint)
    End Property

    Property ListViewColumn.Hint(ByRef Value As WString)
        WLet FHint, Value
    End Property


    Property ListViewColumn.ImageIndex As Integer
        Return FImageIndex
    End Property

    Property ListViewColumn.ImageIndex(Value As Integer)
        If Value <> FImageIndex Then
            FImageIndex = Value
            If Parent Then 
                With QControl(Parent)
                    '.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
                End With
            End If
        End If
    End Property

    Property ListViewColumn.Visible As Boolean
        Return FVisible
    End Property

    Property ListViewColumn.Visible(Value As Boolean)
        If Value <> FVisible Then
            FVisible = Value
            If Parent Then 
                With QControl(Parent)
                    '.Perform(TB_HIDEBUTTON, FCommandID, MakeLong(NOT FVisible, 0))
                End With
            End If
        End If
    End Property

    Operator ListViewColumn.Cast As Any Ptr
        Return @This
    End Operator

    Constructor ListViewColumn
        FHint = CAllocate(0)
        FText = CAllocate(0)
        FVisible    = 1
        Text    = ""
        Hint       = ""
        FImageIndex = -1
    End Constructor

    Destructor ListViewColumn
        If FHint Then Deallocate FHint
        If FText Then Deallocate FText
    End Destructor

    Property ListViewItems.Count As Integer
        Return FItems.Count
    End Property

    Property ListViewItems.Count(Value As Integer)
    End Property

    Property ListViewItems.Item(Index As Integer) As ListViewItem Ptr
        Return QListViewItem(FItems.Items[Index])
    End Property

    Property ListViewItems.Item(Index As Integer, Value As ListViewItem Ptr)
       'QToolButton(FItems.Items[Index]) = Value 
    End Property

    Function ListViewItems.Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0) As ListViewItem Ptr
        PItem = New ListViewItem
        FItems.Add PItem
        With *PItem
            .ImageIndex     = FImageIndex
            .Text(0)        = FCaption
            .State        = State
            .Indent        = Indent
            .Index    = FItems.Count - 1
        End With
        lvi.Mask = LVIF_TEXT or LVIF_IMAGE or LVIF_STATE or LVIF_INDENT
        lvi.pszText  = @FCaption
        lvi.cchTextMax = Len(FCaption)
        lvi.iItem = PItem->Index
        lvi.iSubItem = 0
        lvi.iImage   = FImageIndex
        lvi.State   = INDEXTOSTATEIMAGEMASK(State)
        lvi.stateMask = LVIS_STATEIMAGEMASK
        lvi.iIndent   = Indent
        If Parent Then
           PItem->Parent = Parent
           If Parent->Handle Then ListView_InsertItem(Parent->Handle, @lvi)
        End If
        Return PItem
    End Function
    
    Function ListViewItems.Add(ByRef FCaption As WString = "", ByRef FImageKey As WString, State As Integer = 0, Indent As Integer = 0) As ListViewItem Ptr
        If Parent AndAlso Cast(ListView Ptr, Parent)->Images Then
            PItem = Add(FCaption, Cast(ListView Ptr, Parent)->Images->IndexOf(FImageKey), State, Indent)
        Else
            PItem = Add(FCaption, -1, State, Indent)
        End If
        If PItem Then PItem->ImageKey = FImageKey
        Return PItem
    End Function

    Function ListViewItems.Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0) As ListViewItem Ptr
        Dim As ListViewItem Ptr PItem
        Dim As LVITEM lvi
        PItem = New ListViewItem
        FItems.Insert Index, PItem
        With *PItem
            .ImageIndex     = FImageIndex
            .Text(0)        = FCaption
            .State          = State
            .Indent         = Indent
            .Index    = Index
        End With
        lvi.Mask = LVIF_TEXT or LVIF_IMAGE or LVIF_State or LVIF_Indent
        lvi.pszText  = @FCaption
        lvi.cchTextMax = Len(FCaption)
        lvi.iItem = PItem->Index
        lvi.iImage   = FImageIndex
        lvi.State   = INDEXTOSTATEIMAGEMASK(State)
        lvi.stateMask = LVIS_STATEIMAGEMASK
        lvi.iIndent   = Indent
        If Parent Then
           PItem->Parent = Parent
           If Parent->Handle Then ListView_InsertItem(Parent->Handle, @lvi)
        End If
        Return PItem
    End Function

    Sub ListViewItems.Remove(Index As Integer)
        FItems.Remove Index
        If Parent AndAlso Parent->Handle Then
            ListView_DeleteItem(Parent->Handle, Index)
        End If
    End Sub

    Function CompareFunc(ByVal lParam1 As LPARAM, ByVal lParam2 As LPARAM, ByVal lParamSort As LPARAM) As Long
        Return 0
    End Function
    
    Sub ListViewItems.Sort
        If Parent AndAlso Parent->Handle Then
            'Parent->Perform LVM_SORTITEMS, 0, @CompareFunc
             'ListView_SortItems 
        End If
    End Sub
    
    Function ListViewItems.IndexOf(BYREF FItem As ListViewItem Ptr) As Integer
        Return FItems.IndexOF(FItem)
    End Function

    Function ListViewItems.IndexOf(ByRef Caption As WString) As Integer
        For i As Integer = 0 To Count - 1
            If QListViewItem(FItems.Items[i]).Text(0) = Caption Then
                Return i
            End If 
        Next i
        Return -1
    End Function

    Function ListViewItems.Contains(ByRef Caption As WString) As Boolean
        Return IndexOf(Caption) <> -1
    End Function

    Sub ListViewItems.Clear
        If Parent AndAlso Parent->Handle Then Parent->Perform LVM_DELETEALLITEMS, 0, 0 
        For i As Integer = Count -1 To 0 Step -1
            Delete Cast(ListViewItem Ptr, FItems.Items[i])
        Next i
        FItems.Clear
    End Sub

    Operator ListViewItems.Cast As Any Ptr
        Return @This
    End Operator

    Constructor ListViewItems
        This.Clear
    End Constructor

    Destructor ListViewItems
         This.Clear
    End Destructor

    Property ListViewColumns.Count As Integer
        Return FColumns.Count
    End Property

    Property ListViewColumns.Count(Value As Integer)
    End Property

    Property ListViewColumns.Column(Index As Integer) As ListViewColumn Ptr
        Return QListViewColumn(FColumns.Items[Index])
    End Property

    Property ListViewColumns.Column(Index As Integer, Value As ListViewColumn Ptr)
       'QListViewColumn(FColumns.Items[Index]) = Value 
    End Property

    Function ListViewColumns.Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As integer, Format As ColumnFormat = cfLeft) As ListViewColumn Ptr
        Dim As ListViewColumn Ptr PColumn
        Dim As LVCOLUMN lvc
        PColumn = New ListViewColumn
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

    Sub ListViewColumns.Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As integer, Format As ColumnFormat = cfLeft)
        Dim As ListViewColumn Ptr PColumn
        Dim As LVCOLUMN lvc
        PColumn = New ListViewColumn
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

    Sub ListViewColumns.Remove(Index As Integer)
        FColumns.Remove Index
        If Parent AndAlso Parent->Handle Then
            Parent->Perform LVM_DELETECOLUMN, cast(WPARAM, Index), 0
        End If
    End Sub

    Function ListViewColumns.IndexOf(BYREF FColumn As ListViewColumn Ptr) As Integer
        Return FColumns.IndexOF(FColumn)
    End Function

    Sub ListViewColumns.Clear
        For i As Integer = Count -1 To 0 Step -1
            Delete @QListViewColumn(FColumns.Items[i])
            Remove i
        Next i
        FColumns.Clear
    End Sub

    Operator ListViewColumns.Cast As Any Ptr
        Return @This
    End Operator

    Constructor ListViewColumns
        This.Clear
    End Constructor

    Destructor ListViewColumns
         This.Clear
    End Destructor
    
    Property ListView.ColumnHeaderHidden As Boolean
        Return FColumnHeaderHidden
    End Property

    Property ListView.ColumnHeaderHidden(Value As Boolean)
        FColumnHeaderHidden = Value
        ChangeStyle LVS_NOCOLUMNHEADER, Value
    End Property

    Property ListView.View As ViewStyle
        If Handle Then 
            FView = ListView_GetView(Handle)
        End If
        Return FView
    End Property

    Property ListView.View(Value As ViewStyle)
        FView = Value
        If Handle Then Perform LVM_SETVIEW, cast(wparam, cast(dword, Value)), 0
    End Property

    Property ListView.SelectedItem As ListViewItem Ptr
        If Handle Then
            Dim As Integer item = ListView_GetNextItem(Handle, -1, LVNI_SELECTED)
            If item <> -1 Then Return ListItems.Item(item)
        End If
        Return 0
    End Property

    Property ListView.SelectedItem(Value As ListViewItem Ptr)
        Value->SelectItem
    End Property

    Property ListView.SelectedColumn As ListViewColumn Ptr
        If Handle Then
            Return Columns.Column(ListView_GetSelectedColumn(Handle))
        End If
        Return 0
    End Property
    
    Property ListView.Sort As SortStyle
        Return FSortStyle
    End Property

    Property ListView.Sort(Value As SortStyle)
        FSortStyle = Value
        Select Case FSortStyle
        Case ssNone
            ChangeStyle LVS_SORTASCENDING, False
            ChangeStyle LVS_SORTDESCENDING, False
        Case ssSortAscending
            ChangeStyle LVS_SORTDESCENDING, False
            ChangeStyle LVS_SORTASCENDING, True
        Case ssSortDescending
            ChangeStyle LVS_SORTASCENDING, False
            ChangeStyle LVS_SORTDESCENDING, True
        End Select
    End Property

    Property ListView.SelectedColumn(Value As ListViewColumn Ptr)
        If Handle Then ListView_SetSelectedColumn(Handle, Value->Index)
    End Property

    Property ListView.ShowHint As Boolean
        Return FShowHint
    End Property

    Property ListView.ShowHint(Value As Boolean)
        FShowHint = Value
    End Property

    Sub ListView.WndProc(BYREF Message As Message)
    End Sub

    Sub ListView.ProcessMessage(BYREF Message As Message)
        '?message.msg, GetMessageName(message.msg)
        Select Case Message.Msg
        Case WM_PAINT
            Message.Result = 0
        Case WM_SIZE
        Case CM_NOTIFY
            Dim lvp As NMLISTVIEW Ptr = Cast(NMLISTVIEW Ptr, message.lparam)
            If lvp->iItem <> -1 Then
                Select Case lvp->hdr.code
                Case NM_CLICK: If OnItemClick Then OnItemClick(This, *ListItems.Item(lvp->iItem))
                Case NM_DBLCLK: If OnItemDblClick Then OnItemDblClick(This, *ListItems.Item(lvp->iItem))
                Case LVN_ITEMCHANGED: If OnSelectedItemChanged Then OnSelectedItemChanged(This, *ListItems.Item(lvp->iItem))
                Case NM_KEYDOWN: If OnItemKeyDown Then OnItemKeyDown(This, *ListItems.Item(lvp->iItem))
                End Select
            End If
            Select Case lvp->hdr.code
            Case LVN_BEGINSCROLL: If OnBeginScroll Then OnBeginScroll(This)
            Case LVN_ENDSCROLL: If OnEndScroll Then OnEndScroll(This)
            Case HDN_ITEMCHANGED:
            End Select
        Case WM_NOTIFY
            Select Case message.Wparam
            Case LVN_ENDSCROLL
            Case LVN_ENDSCROLL
            End Select
        Case CM_COMMAND
            Select Case message.Wparam
            Case LVN_ITEMACTIVATE
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

    Sub ListView.HandleIsDestroyed(BYREF Sender As Control)
    End Sub

    Sub ListView.HandleIsAllocated(BYREF Sender As Control)
        If Sender.Child Then
            With QListView(Sender.Child)
                If .Images Then
                    .Images->ParentWindow = .Handle
                    If .Images->Handle Then ListView_SetImageList(.FHandle, CInt(.Images->Handle), LVSIL_NORMAL)
                End If
                If .StateImages Then .StateImages->ParentWindow = .Handle
                If .SmallImages Then .SmallImages->ParentWindow = .Handle
                If .GroupHeaderImages Then .GroupHeaderImages->ParentWindow = .Handle
                If .Images AndAlso .Images->Handle Then ListView_SetImageList(.FHandle, CInt(.Images->Handle), LVSIL_NORMAL)
                If .StateImages AndAlso .StateImages->Handle Then ListView_SetImageList(.FHandle, CInt(.StateImages->Handle), LVSIL_STATE)
                If .SmallImages AndAlso .SmallImages->Handle Then ListView_SetImageList(.FHandle, CInt(.SmallImages->Handle), LVSIL_SMALL)
                If .GroupHeaderImages AndAlso .GroupHeaderImages->Handle Then ListView_SetImageList(.FHandle, CInt(.GroupHeaderImages->Handle), LVSIL_GROUPHEADER)
                Dim lvStyle As Integer
                lvStyle = SendMessage(.FHandle, LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0)
                lvStyle = lvStyle Or  LVS_EX_GRIDLINES Or LVS_EX_FULLROWSELECT
                SendMessage(.FHandle, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, ByVal lvStyle)
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

    Operator ListView.Cast As Control Ptr 
        Return @This
    End Operator

    Constructor ListView
        ListItems.Parent = @This
        Columns.Parent = @This
        FEnabled = True
        FVisible = True
        With This
            .OnHandleIsAllocated = @HandleIsAllocated
            .OnHandleIsDestroyed = @HandleIsDestroyed
            .RegisterClass "ListView", WC_ListView
            .Child             = @This
            .ChildProc         = @WndProc
            WLet FClassName, "ListView"
            WLet FClassAncestor, WC_ListView
            .ExStyle           = WS_EX_CLIENTEDGE
            .Style             = WS_CHILD Or WS_TABSTOP Or WS_VISIBLE Or  LVS_REPORT Or LVS_SINGLESEL Or LVS_SHOWSELALWAYS
            .Width             = 121
            .Height            = 121
        End With 
    End Constructor

    Destructor ListView
        UnregisterClass "ListView",GetmoduleHandle(NULL)
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
