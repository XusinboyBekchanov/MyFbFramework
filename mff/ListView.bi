'###############################################################################
'#  ListView.bi                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'###############################################################################

#Include Once "Control.bi"
#IfDef __USE_GTK__
	#Include Once "glib-object.bi"
#EndIf

Const LVCFMT_FILL = &h200000

Enum SortStyle
    ssNone
    ssSortAscending
    ssSortDescending
End Enum

#IfDef __USE_GTK__
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
#Else
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
#EndIf

Namespace My.Sys.Forms
    #DEFINE QListView(__Ptr__) *Cast(ListView Ptr,__Ptr__)
    #DEFINE QListViewItem(__Ptr__) *Cast(ListViewItem Ptr,__Ptr__)
    #DEFINE QListViewColumn(__Ptr__) *Cast(ListViewColumn Ptr,__Ptr__)
    
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
            #IfNDef __USE_GTK__
				Dim lvi             As LVITEM
			#EndIf
        Public:
        	#IfDef __USE_GTK__
				TreeIter As GtkTreeIter
            #EndIf
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
            OnClick As Sub(BYREF Sender As My.Sys.Object)
            OnDblClick As Sub(BYREF Sender As My.Sys.Object)
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
        	#IfDef __USE_GTK__
        		Dim As GtkTreeViewColumn Ptr Column
        	#EndIf
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
            OnClick As Sub(BYREF Sender As My.Sys.Object)
            OnDblClick As Sub(BYREF Sender As My.Sys.Object)
    End Type

    Type ListViewColumns
        Private:
            FColumns As List
        	#IfDef __USE_GTK__
            	Declare Static Sub Cell_Edited(renderer As GtkCellRendererText Ptr, path As gchar Ptr, new_text As gchar Ptr, user_data As Any Ptr)
        	#EndIf
        Public:
            Parent   As Control Ptr
            Declare Property Count As Integer
            Declare Property Count(Value As Integer)
            Declare Property Column(Index As Integer) As ListViewColumn Ptr
            Declare Property Column(Index As Integer, Value As ListViewColumn Ptr)
            Declare Function Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As ColumnFormat = cfLeft, Editable As Boolean = False) As ListViewColumn Ptr
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
            #IfNDef __USE_GTK__
				lvi As LVITEM
			#EndIf
        Public:
        	#IfDef __USE_GTK__
        		Declare Function FindByIterUser_Data(User_Data As Any Ptr) As ListViewItem Ptr
        	#EndIf
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
            FSingleClickActivate As Boolean
            FSortStyle As SortStyle
            Declare Static Sub WndProc(BYREF Message As Message)
			Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
			Declare Static Sub HandleIsDestroyed(BYREF Sender As Control)
			Declare Sub ProcessMessage(BYREF Message As Message)
        Public:
			#IfDef __USE_GTK__
				ListStore As GtkListStore Ptr
				TreeSelection As GtkTreeSelection Ptr
				ColumnTypes As GType Ptr
            #EndIf
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
            OnSelectedItemChanged As Sub(ByRef Sender As ListView, ByVal ItemIndex As Integer)
            OnBeginScroll As Sub(ByRef Sender As ListView)
            OnEndScroll As Sub(ByRef Sender As ListView)
            OnCellEdited As Sub(ByRef Sender As ListView, ByVal ItemIndex As Integer, ByVal SubItemIndex As Integer, ByRef NewText As WString)
    End Type

    Function ListViewItem.Index As Integer
        If Parent Then
            Return Cast(ListView Ptr, Parent)->ListItems.IndexOf(@This)
        Else
            Return -1
        End If
    End Function
    
    Sub ListViewItem.SelectItem
		#IfDef __USE_GTK__
			If Parent AndAlso Cast(ListView Ptr, Parent)->TreeSelection Then
				gtk_tree_selection_select_iter(Cast(ListView Ptr, Parent)->TreeSelection, @TreeIter)
			End If
		#Else
			If Parent AndAlso Parent->Handle Then
				Dim lvi As LVITEM
				lvi.iItem = Index
				lvi.iSubItem   = 0
				lvi.state    = LVIS_SELECTED
				lvi.statemask = LVNI_SELECTED
				ListView_SetItem(Parent->Handle, @lvi)
			End If
		#EndIf
    End Sub

    Dim Shared As WString Ptr ListViewText
    Property ListViewItem.Text(iSubItem As Integer) ByRef As WString
        #IfDef __USE_GTK__
			If FSubItems.Count > iSubItem Then
				Return FSubItems.Item(iSubItem)
			Else
				Return WStr("")
			End If
        #Else
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
		#EndIf
    End Property

    Property ListViewItem.Text(iSubItem As Integer, ByRef Value As WString)
        WLet FText, Value
        #IfDef __USE_GTK__
			If Parent AndAlso Cast(ListView Ptr, Parent)->ListStore Then
				Dim ic As Integer = FSubItems.Count
				Dim cc As Integer = Cast(ListView Ptr, Parent)->Columns.Count
				If ic < cc Then
					For i As Integer = ic + 1 To cc
						FSubItems.Add ""
					Next i
				End If
				FSubItems.Item(iSubItem) = Value
				gtk_list_store_set (Cast(ListView Ptr, Parent)->ListStore, @TreeIter, iSubItem + 1, ToUtf8(Value), -1)
			End If
        #Else
			If Parent AndAlso Parent->Handle Then
				lvi.Mask = LVIF_TEXT
				lvi.iItem = Index
				lvi.iSubItem   = iSubItem
				lvi.pszText    = FText
				lvi.cchTextMax = Len(*FText)
				ListView_SetItem(Parent->Handle, @lvi)
			End If
		#EndIf 
    End Property

    Property ListViewItem.State As Integer
		#IfNDef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				lvi.Mask = LVIF_STATE
				lvi.iItem = Index
				lvi.iSubItem   = 0
				ListView_GetItem(Parent->Handle, @lvi)
				FState = lvi.state
			End If
		#EndIf
        Return FState
    End Property

    Property ListViewItem.State(Value As Integer)
        FState = Value
        #IfNDef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				lvi.Mask = LVIF_STATE
				lvi.iItem = Index
				lvi.iSubItem   = 0
				lvi.State    = Value
				ListView_SetItem(Parent->Handle, @lvi)
			End If
		#EndIf 
    End Property

    Property ListViewItem.Indent As Integer
        #IfNDef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				lvi.Mask = LVIF_INDENT
				lvi.iItem = Index
				lvi.iSubItem   = 0
				ListView_GetItem(Parent->Handle, @lvi)
				FIndent = lvi.iIndent
			End If
		#EndIf
        Return FIndent
    End Property

    Property ListViewItem.Indent(Value As Integer)
        FIndent = Value
        #IfNDef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				lvi.Mask = LVIF_INDENT
				lvi.iItem = Index
				lvi.iSubItem   = 0
				lvi.iIndent    = Value
				ListView_SetItem(Parent->Handle, @lvi)
			End If
		#EndIf 
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
            #IfDef __USE_GTK__
            	If Parent AndAlso Parent->widget Then
					gtk_list_store_set (Cast(ListView Ptr, Parent)->ListStore, @TreeIter, 0, ToUTF8(Value), -1)
				End If
			#Else
            	If Parent Then 
             	   With QControl(Parent)
              	      '.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
               		End With
            	End If
            #EndIf
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
    
    Sub ListViewColumn.SelectItem
		#IfNDef __USE_GTK__
			If Parent AndAlso Parent->Handle Then ListView_SetSelectedColumn(Parent->Handle, Index)
		#EndIf
    End Sub

    Property ListViewColumn.Text ByRef As WString
        Return WGet(FText)
    End Property

    Property ListViewColumn.Text(ByRef Value As WString)
        WLet FText, Value
        #IfNDef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				Dim lvc As LVCOLUMN
				lvc.mask = TVIF_TEXT
				lvc.iSubItem = Index
				lvc.pszText = FText
				lvc.cchTextMax = Len(*FText)
				ListView_SetColumn(Parent->Handle, Index, @lvc)
			  End If
		#EndIf 
    End Property

    Property ListViewColumn.Width As Integer
        Return FWidth
    End Property

    Property ListViewColumn.Width(Value As Integer)
        FWidth = Value
		#IfDef __USE_GTK__
			#IfDef __USE_GTK3__
				If This.Column Then gtk_tree_view_column_set_fixed_width(This.Column, Max(-1, Value))
			#Else
				If This.Column Then gtk_tree_view_column_set_fixed_width(This.Column, Max(1, Value))
			#EndIf
		#Else
			If Parent AndAlso Parent->Handle Then
				Dim lvc As LVCOLUMN
				lvc.mask = LVCF_WIDTH OR LVCF_SUBITEM
				lvc.iSubItem = Index
				lvc.cx = Value
				ListView_SetColumn(Parent->Handle, Index, @lvc)
			  End If
		#EndIf 
    End Property

    Property ListViewColumn.Format As ColumnFormat
        Return FFormat
    End Property

    Property ListViewColumn.Format(Value As ColumnFormat)
        FFormat = Value
        #IfNDef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				Dim lvc As LVCOLUMN
				lvc.mask = LVCF_FMT OR LVCF_SUBITEM
				lvc.iSubItem = Index
				lvc.fmt = Value
				ListView_SetColumn(Parent->Handle, Index, @lvc)
			  End If
		#EndIf 
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

	Property ListViewColumn.Editable As Boolean
        Return FEditable
    End Property

    Property ListViewColumn.Editable(Value As Boolean)
        If Value <> FEditable Then
            FEditable = Value
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
    
    #IfDef __USE_GTK__
	    Function ListViewItems.FindByIterUser_Data(User_Data As Any Ptr) As ListViewItem Ptr
			For i as integer = 0 to Count - 1
				If Item(i)->TreeIter.User_Data = User_Data Then Return Item(i)
			Next i
			Return 0
		End Function
	#EndIf

    Function ListViewItems.Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0) As ListViewItem Ptr
        PItem = New ListViewItem
        FItems.Add PItem
        With *PItem
            .ImageIndex     = FImageIndex
            .Text(0)        = FCaption
            .State        = State
            .Indent        = Indent
        End With
        #IfDef __USE_GTK__
			Cast(ListView Ptr, Parent)->Init
			gtk_list_store_append (Cast(ListView Ptr, Parent)->ListStore, @PItem->TreeIter)
        	gtk_list_store_set (Cast(ListView Ptr, Parent)->ListStore, @PItem->TreeIter, 1, ToUtf8(FCaption), -1)
        #Else
			lvi.Mask = LVIF_TEXT or LVIF_IMAGE or LVIF_STATE or LVIF_INDENT
			lvi.pszText  = @FCaption
			lvi.cchTextMax = Len(FCaption)
			lvi.iItem = FItems.Count - 1
			lvi.iSubItem = 0
			lvi.iImage   = FImageIndex
			lvi.State   = INDEXTOSTATEIMAGEMASK(State)
			lvi.stateMask = LVIS_STATEIMAGEMASK
			lvi.iIndent   = Indent
		#EndIf
		If Parent Then
			PItem->Parent = Parent
			#IfDef __USE_GTK__
				PItem->Text(0) = FCaption
			#Else
			   If Parent->Handle Then ListView_InsertItem(Parent->Handle, @lvi)
			#EndIf
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
        #IfNDef __USE_GTK__
			Dim As LVITEM lvi
		#EndIf
        PItem = New ListViewItem
        FItems.Insert Index, PItem
        With *PItem
            .ImageIndex     = FImageIndex
            .Text(0)        = FCaption
            .State          = State
            .Indent         = Indent
        End With
        #IfNDef __USE_GTK__
			lvi.Mask = LVIF_TEXT or LVIF_IMAGE or LVIF_State or LVIF_Indent
			lvi.pszText  = @FCaption
			lvi.cchTextMax = Len(FCaption)
			lvi.iItem = Index
			lvi.iImage   = FImageIndex
			lvi.State   = INDEXTOSTATEIMAGEMASK(State)
			lvi.stateMask = LVIS_STATEIMAGEMASK
			lvi.iIndent   = Indent
			If Parent Then
			   PItem->Parent = Parent
			   If Parent->Handle Then ListView_InsertItem(Parent->Handle, @lvi)
			End If
		#EndIf
        Return PItem
    End Function

    Sub ListViewItems.Remove(Index As Integer)
        FItems.Remove Index
        #IfDef __USE_GTK__
        	If Parent AndAlso Parent->widget Then
				gtk_list_store_remove(Cast(ListView Ptr, Parent)->ListStore, @This.Item(Index)->TreeIter)
			End If
        #Else
			If Parent AndAlso Parent->Handle Then
				ListView_DeleteItem(Parent->Handle, Index)
			End If
		#EndIf
    End Sub
	
	#IfNDef __USE_GTK__
		Function CompareFunc(ByVal lParam1 As LPARAM, ByVal lParam2 As LPARAM, ByVal lParamSort As LPARAM) As Long
			Return 0
		End Function
	#EndIf
    
    Sub ListViewItems.Sort
		#IfNDef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				'Parent->Perform LVM_SORTITEMS, 0, @CompareFunc
				 'ListView_SortItems 
			End If
		#EndIf
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
		#IfDef __USE_GTK__
			If Parent AndAlso Cast(ListView Ptr, Parent)->ListStore Then gtk_list_store_clear(Cast(ListView Ptr, Parent)->ListStore)
		#Else
			If Parent AndAlso Parent->Handle Then Parent->Perform LVM_DELETEALLITEMS, 0, 0 
        #EndIf
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

	#IfDef __USE_GTK__
		Sub ListViewColumns.Cell_Edited(renderer As GtkCellRendererText Ptr, path As gchar Ptr, new_text As gchar Ptr, user_data As Any Ptr)
			Dim As ListViewColumn Ptr PColumn = user_data
			If PColumn = 0 Then Exit Sub
			Dim As ListView Ptr lv = Cast(ListView Ptr, PColumn->Parent)
			If lv = 0 Then Exit Sub
			If lv->OnCellEdited Then lv->OnCellEdited(*lv, Val(*path), PColumn->Index, *new_text)
		End Sub
	#EndIf

    Function ListViewColumns.Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As ColumnFormat = cfLeft, ColEditable As Boolean = False) As ListViewColumn Ptr
        Dim As ListViewColumn Ptr PColumn
        Dim As Integer Index
        #IfNDef __USE_GTK__
			Dim As LVCOLUMN lvc
        #EndIf
        PColumn = New ListViewColumn
        FColumns.Add PColumn
        Index = FColumns.Count - 1
        With *PColumn
            .ImageIndex     = FImageIndex
            .Text        = FCaption
            .Index = Index
            .Width     = iWidth
            .Format = Format
        End With
        #IfDef __USE_GTK__
			If Parent Then
				With *Cast(ListView Ptr, Parent)
				If .ColumnTypes Then Delete [] .ColumnTypes
				.ColumnTypes = New GType[Index + 2]
				For i As Integer = 0 To Index + 1
					.ColumnTypes[i] = G_TYPE_STRING
				Next i
				End With
				PColumn->Column = gtk_tree_view_column_new()
				Dim As GtkCellRenderer Ptr rendertext = gtk_cell_renderer_text_new()
				If ColEditable Then
					Dim As GValue bValue '= G_VALUE_INIT
					g_value_init_(@bValue, G_TYPE_BOOLEAN)
					g_value_set_boolean(@bValue, TRUE)
					g_object_set_property(G_OBJECT(rendertext), "editable", @bValue)
					g_value_unset(@bValue)
					'Dim bTrue As gboolean = True
					'g_object_set(rendertext, "mode", GTK_CELL_RENDERER_MODE_EDITABLE, NULL)
					'g_object_set(gtk_cell_renderer_text(rendertext), "editable-set", true, NULL)
					'g_object_set(rendertext, "editable", bTrue, NULL)
				End If
				If Index = 0 Then
					Dim As GtkCellRenderer Ptr renderpixbuf = gtk_cell_renderer_pixbuf_new()
					gtk_tree_view_column_pack_start(PColumn->Column, renderpixbuf, False)
					gtk_tree_view_column_add_attribute(PColumn->Column, renderpixbuf, ToUTF8("icon_name"), 0)
				End If
				g_signal_connect(G_OBJECT(rendertext), "edited", G_CALLBACK (@Cell_Edited), PColumn)
				gtk_tree_view_column_pack_start(PColumn->Column, rendertext, True)
				gtk_tree_view_column_add_attribute(PColumn->Column, rendertext, ToUTF8("text"), Index + 1)
				gtk_tree_view_column_set_resizable(PColumn->Column, True)
				gtk_tree_view_column_set_title(PColumn->Column, ToUTF8(FCaption))
				gtk_tree_view_append_column(GTK_TREE_VIEW(Cast(ListView Ptr, Parent)->widget), PColumn->Column)
				#IfDef __USE_GTK3__
					gtk_tree_view_column_set_fixed_width(PColumn->Column, Max(-1, iWidth))
				#Else
					gtk_tree_view_column_set_fixed_width(PColumn->Column, Max(1, iWidth))
				#EndIf
			End If
        #Else
			lvC.mask      =  LVCF_FMT OR LVCF_WIDTH OR LVCF_TEXT OR LVCF_SUBITEM
			lvC.fmt       =  Format
			lvc.cx		  = IIF(iWidth = -1, 50, iWidth)
			lvc.iImage   = PColumn->ImageIndex
			lvc.iSubItem = PColumn->Index
			lvc.pszText  = @FCaption
			lvc.cchTextMax = Len(FCaption)
		#EndIf
		If Parent Then
			PColumn->Parent = Parent
			#IfDef __USE_GTK__
				
			#Else
				If Parent->Handle Then
					ListView_InsertColumn(Parent->Handle, PColumn->Index, @lvc)
				End If
			#EndIf
		End If
        Return PColumn
    End Function

    Sub ListViewColumns.Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As integer, Format As ColumnFormat = cfLeft)
        Dim As ListViewColumn Ptr PColumn
        #IfNDef __USE_GTK__
			Dim As LVCOLUMN lvc
        #EndIf
        PColumn = New ListViewColumn
        FColumns.Insert Index, PColumn
        With *PColumn
            .ImageIndex     = FImageIndex
            .Text        = FCaption
            .Index        = FColumns.Count - 1
            .Width     = iWidth
            .Format = Format
        End With
		#IfNDef __USE_GTK__
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
		#EndIf
    End Sub

    Sub ListViewColumns.Remove(Index As Integer)
        FColumns.Remove Index
        #IfNDef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				Parent->Perform LVM_DELETECOLUMN, cast(WPARAM, Index), 0
			End If
		#EndIf
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
    
    Sub ListView.Init()
    	#IfDef __USE_GTK__
			If gtk_tree_view_get_model(gtk_tree_view(widget)) = NULL Then
				gtk_list_store_set_column_types(ListStore, Columns.Count + 1, ColumnTypes)
				gtk_tree_view_set_model(gtk_tree_view(widget), GTK_TREE_MODEL(ListStore))
				gtk_tree_view_set_enable_tree_lines(GTK_TREE_VIEW(widget), true)
			End If
		#EndIf
    End Sub
    
    Property ListView.ColumnHeaderHidden As Boolean
        Return FColumnHeaderHidden
    End Property

    Property ListView.ColumnHeaderHidden(Value As Boolean)
        FColumnHeaderHidden = Value
        #IfDef __USE_GTK__
			gtk_tree_view_set_headers_visible(GTK_TREE_VIEW(widget), Not Value)
        #Else
			ChangeStyle LVS_NOCOLUMNHEADER, Value
		#EndIf
    End Property
    
    Property ListView.SingleClickActivate As Boolean
        Return FSingleClickActivate
    End Property

    Property ListView.SingleClickActivate(Value As Boolean)
        FSingleClickActivate = Value
        #IfDef __USE_GTK__
        	#IfDef __USE_GTK3__
				gtk_tree_view_set_activate_on_single_click(GTK_TREE_VIEW(widget), Value)
        	#Else
        		
        	#EndIf
        #Else
			
		#EndIf
    End Property

    Property ListView.View As ViewStyle
        #IfNDef __USE_GTK__
			If Handle Then 
				FView = ListView_GetView(Handle)
			End If
		#EndIf
        Return FView
    End Property

    Property ListView.View(Value As ViewStyle)
        FView = Value
		#IfNDef __USE_GTK__
			If Handle Then Perform LVM_SETVIEW, cast(wparam, cast(dword, Value)), 0
		#EndIf
    End Property

    Property ListView.SelectedItem As ListViewItem Ptr
        #IfDef __USE_GTK__
        	Dim As GtkTreeIter iter
			If gtk_tree_selection_get_selected(TreeSelection, NULL, @iter) Then
				Return ListItems.FindByIterUser_Data(iter.User_Data)
			End If
        #Else
			If Handle Then
				Dim As Integer item = ListView_GetNextItem(Handle, -1, LVNI_SELECTED)
				If item <> -1 Then Return ListItems.Item(item)
			End If
		#EndIf
        Return 0
    End Property
    
    Property ListView.SelectedItemIndex As Integer
        #IfDef __USE_GTK__
        	Dim As GtkTreeIter iter
			If gtk_tree_selection_get_selected(TreeSelection, NULL, @iter) Then
				Dim As ListViewItem Ptr lvi = ListItems.FindByIterUser_Data(iter.User_Data)
				If lvi <> 0 Then Return lvi->Index
			End If
        #Else
			If Handle Then
				Return ListView_GetNextItem(Handle, -1, LVNI_SELECTED)
			End If
		#EndIf
        Return -1
    End Property
    
    Property ListView.SelectedItemIndex(Value As Integer)
        #IfDef __USE_GTK__
			If TreeSelection Then
				If Value = -1 Then
					gtk_tree_selection_unselect_all(TreeSelection)
				ElseIf Value > -1 AndAlso Value < ListItems.Count Then
					gtk_tree_selection_select_iter(TreeSelection, @ListItems.Item(Value)->TreeIter)
					gtk_tree_view_scroll_to_cell(gtk_tree_view(widget), gtk_tree_model_get_path(gtk_tree_model(ListStore), @ListItems.Item(Value)->TreeIter), NULL, False, 0, 0)
				End If
			End If
		#Else
			If Handle Then
				Dim lvi As LVITEM
				lvi.iItem = Value
				lvi.iSubItem   = 0
				lvi.state    = LVIS_SELECTED
				lvi.statemask = LVNI_SELECTED
				ListView_SetItem(Handle, @lvi)
			End If
		#EndIf
    End Property

    Property ListView.SelectedItem(Value As ListViewItem Ptr)
        Value->SelectItem
    End Property

    Property ListView.SelectedColumn As ListViewColumn Ptr
        #IfNDef __USE_GTK__
			If Handle Then
				Return Columns.Column(ListView_GetSelectedColumn(Handle))
			End If
		#EndIf
        Return 0
    End Property
    
    Property ListView.Sort As SortStyle
        Return FSortStyle
    End Property

    Property ListView.Sort(Value As SortStyle)
        FSortStyle = Value
        #IfNDef __USE_GTK__
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
		#EndIf
    End Property

    Property ListView.SelectedColumn(Value As ListViewColumn Ptr)
        #IfNDef __USE_GTK__
			If Handle Then ListView_SetSelectedColumn(Handle, Value->Index)
		#EndIf
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
			#IfDef __USE_GTK__
				Dim As GdkEvent Ptr e = Message.event
				Select Case Message.event->Type
				Case GDK_MAP
					Init
				End Select
			#Else
			Select Case Message.Msg
			Case WM_PAINT
				Message.Result = 0
			Case WM_SIZE
			Case CM_NOTIFY
				Dim lvp As NMLISTVIEW Ptr = Cast(NMLISTVIEW Ptr, message.lparam)
				Select Case lvp->hdr.code
				Case NM_CLICK: If OnItemClick Then OnItemClick(This, lvp->iItem)
				Case NM_DBLCLK: If OnItemDblClick Then OnItemDblClick(This, lvp->iItem)
				Case NM_KEYDOWN: If OnItemKeyDown Then OnItemKeyDown(This, lvp->iItem)
				Case LVN_ITEMACTIVATE: If OnItemActivate Then OnItemActivate(This, lvp->iItem)
				Case LVN_BEGINSCROLL: If OnBeginScroll Then OnBeginScroll(This)
				Case LVN_ENDSCROLL: If OnEndScroll Then OnEndScroll(This)
				Case LVN_ITEMCHANGED: If OnSelectedItemChanged Then OnSelectedItemChanged(This, lvp->iItem)
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
			#EndIf
			Base.ProcessMessage(Message)
		End Sub

	#IfNDef __USE_GTK__
		Sub ListView.HandleIsDestroyed(BYREF Sender As Control)
		End Sub

		Sub ListView.HandleIsAllocated(BYREF Sender As Control)
			If Sender.Child Then
				With QListView(Sender.Child)
					If .Images Then
						.Images->ParentWindow = @Sender
						If .Images->Handle Then ListView_SetImageList(.FHandle, CInt(.Images->Handle), LVSIL_NORMAL)
					End If
					If .StateImages Then .StateImages->ParentWindow = @Sender
					If .SmallImages Then .SmallImages->ParentWindow = @Sender
					If .GroupHeaderImages Then .GroupHeaderImages->ParentWindow = @Sender
					If .Images AndAlso .Images->Handle Then ListView_SetImageList(.FHandle, CInt(.Images->Handle), LVSIL_NORMAL)
					If .StateImages AndAlso .StateImages->Handle Then ListView_SetImageList(.FHandle, CInt(.StateImages->Handle), LVSIL_STATE)
					If .SmallImages AndAlso .SmallImages->Handle Then ListView_SetImageList(.FHandle, CInt(.SmallImages->Handle), LVSIL_SMALL)
					If .GroupHeaderImages AndAlso .GroupHeaderImages->Handle Then ListView_SetImageList(.FHandle, CInt(.GroupHeaderImages->Handle), LVSIL_GROUPHEADER)
					Dim lvStyle As Integer
					lvStyle = SendMessage(.FHandle, LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0)
					lvStyle = lvStyle Or  LVS_EX_GRIDLINES Or LVS_EX_FULLROWSELECT
					SendMessage(.FHandle, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, ByVal lvStyle)
					If .FView <> 0 Then .View = .View
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
	#EndIf

    Operator ListView.Cast As Control Ptr 
        Return @This
    End Operator

	#IfDef __USE_GTK__
		Sub ListView_RowActivated(tree_view As GtkTreeView Ptr, path As GtkTreePath Ptr, column As GtkTreeViewColumn Ptr, user_data As Any Ptr)
			Dim As ListView Ptr lv = Cast(Any Ptr, user_data)
			If lv Then
				Dim As GtkTreeModel Ptr model
				Dim As GtkTreeIter iter
				model = gtk_tree_view_get_model(tree_view)
				If gtk_tree_model_get_iter(model, @iter, path) Then
					If lv->OnItemActivate Then lv->OnItemActivate(*lv, Val(*gtk_tree_model_get_string_from_iter(model, @iter)))
				End If
			End If
	    End Sub
	    
	    Sub ListView_SelectionChanged(selection As GtkTreeSelection Ptr, user_data As Any Ptr)
			Dim As ListView Ptr lv = Cast(Any Ptr, user_data)
			If lv Then
				Dim As GtkTreeIter iter
				Dim As GtkTreeModel Ptr model
				If gtk_tree_selection_get_selected(selection, @model, @iter) Then
					If lv->OnSelectedItemChanged Then lv->OnSelectedItemChanged(*lv, Val(*gtk_tree_model_get_string_from_iter(model, @iter)))
				End If
			End If
	    End Sub
	    
	    Sub ListView_Map(widget As GtkWidget Ptr, user_data As Any Ptr)
			Dim As ListView Ptr lv = user_data
			lv->Init
	    End Sub
	#EndIf
	
    Constructor ListView
		#IfDef __USE_GTK__
			ListStore = gtk_list_store_new(1, G_TYPE_STRING)
			scrolledwidget = gtk_scrolled_window_new(NULL, NULL)
			gtk_scrolled_window_set_policy(gtk_scrolled_window(scrolledwidget), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
			'widget = gtk_tree_view_new_with_model(gtk_tree_model(ListStore))
			widget = gtk_tree_view_new()
			gtk_container_add(gtk_container(scrolledwidget), widget)
			TreeSelection = gtk_tree_view_get_selection(GTK_TREE_VIEW(widget))
			g_signal_connect(gtk_tree_view(widget), "map", G_CALLBACK(@ListView_Map), @This)
			g_signal_connect(gtk_tree_view(widget), "row-activated", G_CALLBACK(@ListView_RowActivated), @This)
			g_signal_connect(G_OBJECT(TreeSelection), "changed", G_CALLBACK (@ListView_SelectionChanged), @This)
			gtk_tree_view_set_enable_tree_lines(GTK_TREE_VIEW(widget), true)
			gtk_tree_view_set_grid_lines(GTK_TREE_VIEW(widget), GTK_TREE_VIEW_GRID_LINES_BOTH)
			ColumnTypes = New GType[1]
			ColumnTypes[0] = G_TYPE_STRING
			This.RegisterClass "ListView", @This
		#EndIf
        ListItems.Parent = @This
        Columns.Parent = @This
        FEnabled = True
        FVisible = True
        With This
			.Child             = @This
			#IfNDef __USE_GTK__
				.OnHandleIsAllocated = @HandleIsAllocated
				.OnHandleIsDestroyed = @HandleIsDestroyed
				.RegisterClass "ListView", WC_ListView
				.ChildProc         = @WndProc
				.ExStyle           = WS_EX_CLIENTEDGE
				.Style             = WS_CHILD Or WS_TABSTOP Or WS_VISIBLE Or LVS_REPORT Or LVS_ICON Or LVS_SINGLESEL Or LVS_SHOWSELALWAYS
				WLet FClassAncestor, WC_ListView
			#EndIf
            WLet FClassName, "ListView"
            .Width             = 121
            .Height            = 121
        End With 
    End Constructor

    Destructor ListView
    	ListItems.Clear
		#IfNDef __USE_GTK__    
			UnregisterClass "ListView",GetmoduleHandle(NULL)
		#Else
			If ColumnTypes Then Delete [] ColumnTypes
		#EndIf
    End Destructor
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
