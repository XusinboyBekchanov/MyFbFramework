'################################################################################
'#  TreeListView.bi                                                             #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#Include Once "ListView.bi"

Namespace My.Sys.Forms
    #DEFINE QTreeListView(__Ptr__) *Cast(TreeListView Ptr,__Ptr__)
    #DEFINE QTreeListViewItem(__Ptr__) *Cast(TreeListViewItem Ptr,__Ptr__)
    #DEFINE QTreeListViewColumn(__Ptr__) *Cast(TreeListViewColumn Ptr,__Ptr__)
    
    Type PTreeListViewItem As TreeListViewItem Ptr
    
    Type TreeListViewItems
        Private:
            FItems As List
            PItem As PTreeListViewItem
            FParentItem As PTreeListViewItem
            #IfNDef __USE_GTK__
				lvi As LVITEM
			#EndIf
        Public:
        	#IfDef __USE_GTK__
        		Declare Function FindByIterUser_Data(User_Data As Any Ptr) As PTreeListViewItem
        	#Else
        		Declare Function FindByHandle(Value As LParam) As PTreeListViewItem
        	#EndIf
            Parent   As Control Ptr
            Declare Property Count As Integer
            Declare Property Count(Value As Integer)
            Declare Property Item(Index As Integer) As PTreeListViewItem
            Declare Property Item(Index As Integer, Value As PTreeListViewItem)
            Declare Function Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0) As PTreeListViewItem
            Declare Function Add(ByRef FCaption As WString = "", ByRef FImageKey As WString, State As Integer = 0, Indent As Integer = 0) As PTreeListViewItem
            Declare Function Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0) As PTreeListViewItem
            Declare Sub Remove(Index As Integer)
            Declare Property ParentItem As PTreeListViewItem
            Declare Property ParentItem(Value As PTreeListViewItem)
            Declare Function IndexOf(BYREF FItem As PTreeListViewItem) As Integer
            Declare Function IndexOf(ByRef FCaption As WString) As Integer
            Declare Function Contains(ByRef FCaption As WString) As Boolean
            Declare Sub Clear
            Declare Sub Sort
            Declare Operator Cast As Any Ptr
            Declare Constructor
            Declare Destructor
    End Type

    Type TreeListViewItem Extends My.Sys.Object
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
            FParentItem As PTreeListViewItem
            FVisible            As Boolean
            FState              As Integer
            FIndent             As Integer
            FExpanded			As Boolean
            #IfNDef __USE_GTK__
				Dim lvi             As LVITEM
			#EndIf
		Protected:
        	#IfNDef __USE_GTK__
				
            #EndIf
        Public:
        	#IfDef __USE_GTK__
				TreeIter As GtkTreeIter
			#Else
				Handle As LParam
				Declare Function GetItemIndex() As Integer
            #EndIf
            Parent   As Control Ptr
            Items As TreeListViewItems
            Tag As Any Ptr
            Declare Sub SelectItem
            Declare Sub Collapse
            Declare Sub Expand
            Declare Function IsExpanded As Boolean
            Declare Function Index As Integer
            Declare Property Text(iSubItem As Integer) ByRef As WString
            Declare Property Text(iSubItem As Integer, ByRef Value As WString)
            Declare Property Hint ByRef As WString
            Declare Property Hint(ByRef Value As WString)
            Declare Property ParentItem As PTreeListViewItem
            Declare Property ParentItem(Value As PTreeListViewItem)
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

    Type TreeListViewColumn Extends My.Sys.Object
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

    Type TreeListViewColumns
        Private:
            FColumns As List
        	#IfDef __USE_GTK__
            	Declare Static Sub Cell_Edited(renderer As GtkCellRendererText Ptr, path As gchar Ptr, new_text As gchar Ptr, user_data As Any Ptr)
        		Declare Static Sub Cell_Editing(cell As GtkCellRenderer Ptr, editable As GtkCellEditable Ptr, path As const gchar Ptr, user_data As Any Ptr)
        	#EndIf
        Public:
            Parent   As Control Ptr
            Declare Property Count As Integer
            Declare Property Count(Value As Integer)
            Declare Property Column(Index As Integer) As TreeListViewColumn Ptr
            Declare Property Column(Index As Integer, Value As TreeListViewColumn Ptr)
            Declare Function Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As ColumnFormat = cfLeft, Editable As Boolean = False) As TreeListViewColumn Ptr
            Declare Sub Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As ColumnFormat = cfLeft)
            Declare Sub Remove(Index As Integer)
            Declare Function IndexOf(BYREF FColumn As TreeListViewColumn Ptr) As Integer
            Declare Sub Clear
            Declare Operator Cast As Any Ptr
            Declare Constructor
            Declare Destructor
    End Type

    Type TreeListView Extends Control
        Private:
            FView As ViewStyle
            FColumnHeaderHidden As Boolean
            FSingleClickActivate As Boolean
            FSortStyle As SortStyle
            Declare Static Sub WndProc(BYREF Message As Message)
			Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
			Declare Static Sub HandleIsDestroyed(BYREF Sender As Control)
			Declare Sub ProcessMessage(BYREF Message As Message)
        Protected:
        	#IfDef __USE_GTK__
        		Declare Static Function TreeListView_TestExpandRow(tree_view As GtkTreeView Ptr, iter As GtkTreeIter Ptr, path As GtkTreePath Ptr, user_data As Any Ptr) As Boolean
        	#Else
        		Declare Function GetTreeListViewItem(Item As Integer) As TreeListViewItem Ptr
        	#EndIf
        Public:
			#IfDef __USE_GTK__
				TreeStore As GtkTreeStore Ptr
				TreeSelection As GtkTreeSelection Ptr
				ColumnTypes As GType Ptr
            #EndIf
            Declare Sub Init()
   			ListItems         As TreeListViewItems
            Columns         As TreeListViewColumns
            Images          As ImageList Ptr
            StateImages       As ImageList Ptr
            SmallImages       As ImageList Ptr
            GroupHeaderImages       As ImageList Ptr
            Declare Sub CollapseAll
            Declare Sub ExpandAll
            Declare Property ColumnHeaderHidden As Boolean
            Declare Property ColumnHeaderHidden(Value As Boolean)
            Declare Property ShowHint As Boolean
            Declare Property ShowHint(Value As Boolean)
            Declare Property View As ViewStyle
            Declare Property View(Value As ViewStyle)
            Declare Property Sort As SortStyle
            Declare Property Sort(Value As SortStyle)
            Declare Property SelectedItem As TreeListViewItem Ptr
            Declare Property SelectedItem(Value As TreeListViewItem Ptr)
            Declare Property SelectedItemIndex As Integer
            Declare Property SelectedItemIndex(Value As Integer)
            Declare Property SelectedColumn As TreeListViewColumn Ptr
            Declare Property SelectedColumn(Value As TreeListViewColumn Ptr)
            Declare Property SingleClickActivate As Boolean
            Declare Property SingleClickActivate(Value As Boolean)
            Declare Operator Cast As Control Ptr
            Declare Constructor
            Declare Destructor
            OnItemActivate As Sub(ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr)
            OnItemClick As Sub(ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr)
            OnItemDblClick As Sub(ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr)
            OnItemKeyDown As Sub(ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr)
            OnItemExpanding As Sub(ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr)
            OnCellEditing As Sub(ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr, ByVal SubItemIndex As Integer, CellEditor As Control Ptr)
            OnCellEdited As Sub(ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr, ByVal SubItemIndex As Integer, ByRef NewText As WString)
            OnSelectedItemChanged As Sub(ByRef Sender As TreeListView, ByRef Item As TreeListViewItem Ptr)
            OnBeginScroll As Sub(ByRef Sender As TreeListView)
            OnEndScroll As Sub(ByRef Sender As TreeListView)
    End Type

	#IfNDef __USE_GTK__
		Function TreeListViewItem.GetItemIndex() As Integer
			Var nItem = ListView_GetItemCount(Parent->Handle)
			For i As Integer = 0 To nItem - 1
				lvi.Mask = LVIF_PARAM
				lvi.iItem = i
				lvi.iSubItem   = 0
				ListView_GetItem(Parent->Handle, @lvi)
				If lvi.LParam = Cast(LParam, @This) Then
					Return i
				End If
			Next i
			Return -1
		End Function
	#EndIf

	Sub TreeListViewItem.Collapse
        #IfDef __USE_GTK__
			If Parent AndAlso Parent->widget AndAlso Cast(TreeListView Ptr, Parent)->TreeStore Then
				Dim As GtkTreePath Ptr TreePath = gtk_tree_path_new_from_string(gtk_tree_model_get_string_from_iter(GTK_Tree_model(Cast(TreeListView Ptr, Parent)->TreeStore), @TreeIter))
				gtk_tree_view_collapse_row(gtk_tree_view(Parent->widget), TreePath)
				gtk_tree_path_free(TreePath)
			End If
        #Else
        	Var ItemIndex = This.GetItemIndex()
        	If ItemIndex <> -1 Then
        		State = 1
	        	Var nItem = ListView_GetItemCount(Parent->Handle)
				Var i = ItemIndex + 1
				Do While i < nItem
					lvi.Mask = LVIF_INDENT
					lvi.iItem = i
					lvi.iSubItem   = 0
					ListView_GetItem(Parent->Handle, @lvi)
					If lvi.iIndent > FIndent Then
						ListView_DeleteItem(Parent->Handle, i)
						nItem -= 1
					ElseIf lvi.iIndent <= FIndent Then
						Exit Do
					End If
				Loop
			End If
		#EndIf
		FExpanded = False
    End Sub
    
 	Sub TreeListViewItem.Expand
        #IfDef __USE_GTK__
			If Parent AndAlso Parent->widget AndAlso Cast(TreeListView Ptr, Parent)->TreeStore Then
				Dim As GtkTreePath Ptr TreePath = gtk_tree_path_new_from_string(gtk_tree_model_get_string_from_iter(GTK_Tree_model(Cast(TreeListView Ptr, Parent)->TreeStore), @TreeIter))
				gtk_tree_view_expand_row(gtk_tree_view(Parent->widget), TreePath, False)
				gtk_tree_path_free(TreePath)
			End If
        #Else
        	If Parent AndAlso Parent->Handle Then
        		State = 2
	        	Var ItemIndex = This.GetItemIndex
	        	If ItemIndex <> -1 Then
	        		For i As Integer = 0 To Items.Count - 1
						lvi.Mask = LVIF_TEXT or LVIF_IMAGE or LVIF_State or LVIF_Indent or LVIF_PARAM
						lvi.pszText  = @Items.Item(i)->Text(0)
						lvi.cchTextMax = Len(Items.Item(i)->Text(0))
						lvi.iItem = ItemIndex + i + 1
						lvi.iImage   = Items.Item(i)->FImageIndex
						If Items.Item(i)->Items.Count > 0 Then
							lvi.State   = INDEXTOSTATEIMAGEMASK(1)
							Items.Item(i)->FExpanded = False
						Else
							lvi.State   = 0
						End If
						lvi.stateMask = LVIS_STATEIMAGEMASK
						lvi.iIndent   = Items.Item(i)->Indent
						lvi.LParam = Cast(LParam, Items.Item(i))
						ListView_InsertItem(Parent->Handle, @lvi)
						For j As Integer = 1 To Cast(TreeListView Ptr, Parent)->Columns.Count - 1
							Dim As LVITEM lvi1
							lvi1.Mask = LVIF_TEXT
							lvi1.iItem = ItemIndex + i + 1
							lvi1.iSubItem   = j
							lvi1.pszText    = @Items.Item(i)->Text(j)
							lvi1.cchTextMax = Len(Items.Item(i)->Text(j))
							ListView_SetItem(Parent->Handle, @lvi1)
						Next j
					Next i
	        	End If
	        End If
        #EndIf
		FExpanded = True
    End Sub

    Function TreeListViewItem.IsExpanded As Boolean
        #IfDef __USE_GTK__
			If Parent AndAlso Parent->widget AndAlso Cast(TreeListView Ptr, Parent)->TreeStore Then
				Dim As GtkTreePath Ptr TreePath = gtk_tree_path_new_from_string(gtk_tree_model_get_string_from_iter(GTK_Tree_model(Cast(TreeListView Ptr, Parent)->TreeStore), @TreeIter))
				Var bResult = gtk_tree_view_row_expanded(gtk_tree_view(Parent->widget), TreePath)
				gtk_tree_path_free(TreePath)
				Return bResult
			End If
		#Else
			Return FExpanded
			'If Parent AndAlso Parent->Handle Then Return TreeView_GetItemState(Parent->Handle, Handle, TVIS_EXPANDED)
		#EndIf
    End Function
    
    Function TreeListViewItem.Index As Integer
        If FParentItem <> 0 Then
            Return FParentItem->Items.IndexOf(@This)
        ElseIf Parent <> 0 Then
            Return Cast(TreeListView Ptr, Parent)->ListItems.IndexOf(@This)
        Else
            Return -1
        End If
    End Function
    
    Sub TreeListViewItem.SelectItem
		#IfDef __USE_GTK__
			If Parent AndAlso Cast(TreeListView Ptr, Parent)->TreeSelection Then
				gtk_tree_selection_select_iter(Cast(TreeListView Ptr, Parent)->TreeSelection, @TreeIter)
			End If
		#Else
			If Parent AndAlso Parent->Handle Then
				Var ItemIndex = This.GetItemIndex
				If ItemIndex = -1 Then Exit Sub 
				Dim lvi As LVITEM
				lvi.iItem = Index
				lvi.iSubItem   = 0
				lvi.state    = LVIS_SELECTED
				lvi.statemask = LVNI_SELECTED
				ListView_SetItem(Parent->Handle, @lvi)
			End If
		#EndIf
    End Sub

    Property TreeListViewItem.Text(iSubItem As Integer) ByRef As WString
        If FSubItems.Count > iSubItem Then
			Return FSubItems.Item(iSubItem)
		Else
			Return WStr("")
		End If
    End Property

    Property TreeListViewItem.Text(iSubItem As Integer, ByRef Value As WString)
        WLet FText, Value
		For i As Integer = FSubItems.Count To iSubItem
			FSubItems.Add ""
		Next i
		FSubItems.Item(iSubItem) = Value
		If Parent Then
			#IfDef __USE_GTK__
				If Cast(TreeListView Ptr, Parent)->TreeStore Then
					gtk_tree_store_set (Cast(TreeListView Ptr, Parent)->TreeStore, @TreeIter, iSubItem + 1, ToUtf8(Value), -1)
				End If
			#Else
				If Parent AndAlso Parent->Handle Then
					Var ItemIndex = This.GetItemIndex
					If ItemIndex = -1 Then Exit Property
					lvi.Mask = LVIF_TEXT
					lvi.iItem = ItemIndex
					lvi.iSubItem   = iSubItem
					lvi.pszText    = FText
					lvi.cchTextMax = Len(*FText)
					ListView_SetItem(Parent->Handle, @lvi)
				End If
			#EndIf 
		End If
    End Property

    Property TreeListViewItem.State As Integer
		Return FState
    End Property

    Property TreeListViewItem.State(Value As Integer)
        FState = Value
        #IfNDef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				Var ItemIndex = GetItemIndex
				If ItemIndex = -1 Then Exit Property
				lvi.Mask = LVIF_STATE
				lvi.iItem = ItemIndex
				lvi.iSubItem   = 0
				lvi.State    = INDEXTOSTATEIMAGEMASK(Value)
				lvi.stateMask = LVIS_STATEIMAGEMASK
				ListView_SetItem(Parent->Handle, @lvi)
			End If
		#EndIf 
    End Property

    Property TreeListViewItem.Indent As Integer
        Return FIndent
    End Property

    Property TreeListViewItem.Indent(Value As Integer)
        FIndent = Value
        #IfNDef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				Var ItemIndex = GetItemIndex
				If ItemIndex = -1 Then Exit Property
				lvi.Mask = LVIF_INDENT
				lvi.iItem = ItemIndex
				lvi.iSubItem   = 0
				lvi.iIndent    = Value
				ListView_SetItem(Parent->Handle, @lvi)
			End If
		#EndIf 
    End Property

    Property TreeListViewItem.Hint ByRef As WString
        Return WGet(FHint)
    End Property

    Property TreeListViewItem.Hint(ByRef Value As WString)
        WLet FHint, Value
    End Property


    Property TreeListViewItem.ImageIndex As Integer
        Return FImageIndex
    End Property

    Property TreeListViewItem.ImageIndex(Value As Integer)
        If Value <> FImageIndex Then
            FImageIndex = Value
            If Parent Then 
                With QControl(Parent)
                    '.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
                End With
            End If
        End If
    End Property

    Property TreeListViewItem.SelectedImageIndex As Integer
        Return FImageIndex
    End Property

    Property TreeListViewItem.SelectedImageIndex(Value As Integer)
        If Value <> FSelectedImageIndex Then
            FSelectedImageIndex = Value
            If Parent Then 
                With QControl(Parent)
                    '.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
                End With
            End If
        End If
    End Property

    Property TreeListViewItem.Visible As Boolean
        Return FVisible
    End Property
    
    Property TreeListViewItem.ParentItem As TreeListViewItem Ptr
        Return FParentItem
    End Property
    
    Property TreeListViewItem.ParentItem(Value As TreeListViewItem Ptr)
        FParentItem = Value
    End Property
    
    Property TreeListViewItem.ImageKey ByRef As WString
        Return WGet(FImageKey)
    End Property

    Property TreeListViewItem.ImageKey(ByRef Value As WString)
        'If Value <> *FImageKey Then
            WLet FImageKey, Value
            #IfDef __USE_GTK__
            	If Parent AndAlso Parent->widget Then
					gtk_tree_store_set (Cast(TreeListView Ptr, Parent)->TreeStore, @TreeIter, 0, ToUTF8(Value), -1)
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

    Property TreeListViewItem.SelectedImageKey ByRef As WString
        Return WGet(FImageKey)
    End Property

    Property TreeListViewItem.SelectedImageKey(ByRef Value As WString)
        'If Value <> *FSelectedImageKey Then
            WLet FSelectedImageKey, Value
            If Parent Then 
                With QControl(Parent)
                    '.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
                End With
            End If
        'End If
    End Property

    Property TreeListViewItem.Visible(Value As Boolean)
        If Value <> FVisible Then
            FVisible = Value
            #IfNDef __USE_GTK__
	            If Parent AndAlso Parent->Handle Then
					Var ItemIndex = GetItemIndex
					If ItemIndex = -1 Then Exit Property
					If Value = False Then
						ListView_DeleteItem(Parent->Handle, ItemIndex)
					End If
    			End If
    		#EndIf
        End If
    End Property

    Operator TreeListViewItem.Cast As Any Ptr
        Return @This
    End Operator

    Constructor TreeListViewItem
        Items.Clear
        Items.Parent = Parent
        Items.ParentItem = @This
        FHint = CAllocate(0)
        FText = CAllocate(0)
        FVisible    = 1
        Text(0)    = ""
        Hint       = ""
        FImageIndex = -1
        FSelectedImageIndex = -1
        FSmallImageIndex = -1
    End Constructor

    Destructor TreeListViewItem
    	Items.Clear
        WDeallocate FHint
        WDeallocate FText
        WDeallocate FImageKey
        WDeallocate FSelectedImageKey
        WDeallocate FSmallImageKey
    End Destructor
    
    Sub TreeListViewColumn.SelectItem
		#IfNDef __USE_GTK__
			If Parent AndAlso Parent->Handle Then ListView_SetSelectedColumn(Parent->Handle, Index)
		#EndIf
    End Sub

    Property TreeListViewColumn.Text ByRef As WString
        Return WGet(FText)
    End Property

    Property TreeListViewColumn.Text(ByRef Value As WString)
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

    Property TreeListViewColumn.Width As Integer
        Return FWidth
    End Property

    Property TreeListViewColumn.Width(Value As Integer)
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

    Property TreeListViewColumn.Format As ColumnFormat
        Return FFormat
    End Property

    Property TreeListViewColumn.Format(Value As ColumnFormat)
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

    Property TreeListViewColumn.Hint ByRef As WString
        Return WGet(FHint)
    End Property

    Property TreeListViewColumn.Hint(ByRef Value As WString)
        WLet FHint, Value
    End Property


    Property TreeListViewColumn.ImageIndex As Integer
        Return FImageIndex
    End Property

    Property TreeListViewColumn.ImageIndex(Value As Integer)
        If Value <> FImageIndex Then
            FImageIndex = Value
            If Parent Then 
                With QControl(Parent)
                    '.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
                End With
            End If
        End If
    End Property

    Property TreeListViewColumn.Visible As Boolean
        Return FVisible
    End Property

    Property TreeListViewColumn.Visible(Value As Boolean)
        If Value <> FVisible Then
            FVisible = Value
            If Parent Then 
                With QControl(Parent)
                    '.Perform(TB_HIDEBUTTON, FCommandID, MakeLong(NOT FVisible, 0))
                End With
            End If
        End If
    End Property

	Property TreeListViewColumn.Editable As Boolean
        Return FEditable
    End Property

    Property TreeListViewColumn.Editable(Value As Boolean)
        If Value <> FEditable Then
            FEditable = Value
        End If
    End Property

    Operator TreeListViewColumn.Cast As Any Ptr
        Return @This
    End Operator

    Constructor TreeListViewColumn
        FHint = CAllocate(0)
        FText = CAllocate(0)
        FVisible    = 1
        Text    = ""
        Hint       = ""
        FImageIndex = -1
    End Constructor

    Destructor TreeListViewColumn
        If FHint Then Deallocate FHint
        If FText Then Deallocate FText
    End Destructor

    Property TreeListViewItems.Count As Integer
        Return FItems.Count
    End Property

    Property TreeListViewItems.Count(Value As Integer)
    End Property

    Property TreeListViewItems.Item(Index As Integer) As TreeListViewItem Ptr
        Return QListViewItem(FItems.Items[Index])
    End Property

    Property TreeListViewItems.Item(Index As Integer, Value As TreeListViewItem Ptr)
       'QToolButton(FItems.Items[Index]) = Value 
    End Property
    
    #IfDef __USE_GTK__
	    Function TreeListViewItems.FindByIterUser_Data(User_Data As Any Ptr) As TreeListViewItem Ptr
			If ParentItem AndAlso ParentItem->TreeIter.User_Data = User_Data Then Return ParentItem
			For i as integer = 0 to Count - 1
				PItem = Item(i)->Items.FindByIterUser_Data(User_Data)
				If PItem <> 0 Then Return PItem
			Next i
			Return 0
	    End Function
	#Else
	   	Function TreeListViewItems.FindByHandle(Value As LParam) As TreeListViewItem Ptr
			If ParentItem AndAlso ParentItem->Handle = Value Then Return ParentItem
			For i as integer = 0 to Count - 1
				PItem = Item(i)->Items.FindByHandle(Value)
				If PItem <> 0 Then Return PItem
			Next i
			Return 0
	    End Function
	#EndIf
	
	Property TreeListViewItems.ParentItem As TreeListViewItem Ptr
        Return FParentItem
    End Property
    
    Property TreeListViewItems.ParentItem(Value As TreeListViewItem Ptr)
        FParentItem = Value
    End Property

    Function TreeListViewItems.Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0) As TreeListViewItem Ptr
        PItem = New TreeListViewItem
        FItems.Add PItem
        With *PItem
            .ImageIndex     = FImageIndex
            .Text(0)        = FCaption
            .State        = State
            If ParentItem Then
            	.Indent        = ParentItem->Indent + 1
            Else
            	.Indent        = 0
            End If
            .Parent         = Parent
            #IfNDef __USE_GTK__
            	.Handle = Cast(LParam, PItem)
            #EndIf
            .Items.Parent         = Parent
            .ParentItem        = ParentItem
            If FItems.Count = 1 AndAlso ParentItem Then
            	ParentItem->State = IIF(ParentItem->IsExpanded, 2, 1)
            End If
        	#IfDef __USE_GTK__
				If Parent AndAlso Cast(TreeListView Ptr, Parent)->TreeStore Then
					Cast(TreeListView Ptr, Parent)->Init
					If ParentItem <> 0 Then
						gtk_tree_store_append (Cast(TreeListView Ptr, Parent)->TreeStore, @PItem->TreeIter, @.ParentItem->TreeIter)
					Else
						gtk_tree_store_append (Cast(TreeListView Ptr, Parent)->TreeStore, @PItem->TreeIter, NULL)
        			End If
        			gtk_tree_store_set (Cast(TreeListView Ptr, Parent)->TreeStore, @PItem->TreeIter, 1, ToUtf8(FCaption), -1)
				End If
				PItem->Text(0) = FCaption
	        #Else
	        	If Parent AndAlso Parent->Handle AndAlso (ParentItem = 0 OrElse ParentItem->IsExpanded) Then
					lvi.Mask = LVIF_TEXT or LVIF_IMAGE or LVIF_STATE or LVIF_INDENT or LVIF_PARAM
					lvi.pszText  = @FCaption
					lvi.cchTextMax = Len(FCaption)
					lvi.iItem = FItems.Count - 1
					lvi.iSubItem = 0
					lvi.iImage   = FImageIndex
					lvi.State   = INDEXTOSTATEIMAGEMASK(State)
					lvi.stateMask = LVIS_STATEIMAGEMASK
					lvi.iIndent   = .Indent
					lvi.LParam = Cast(LParam, PItem)
					ListView_InsertItem(Parent->Handle, @lvi)
				End If
			#EndIf
		End With
		Return PItem
    End Function
    
    Function TreeListViewItems.Add(ByRef FCaption As WString = "", ByRef FImageKey As WString, State As Integer = 0, Indent As Integer = 0) As TreeListViewItem Ptr
        If Parent AndAlso Cast(TreeListView Ptr, Parent)->Images Then
            PItem = Add(FCaption, Cast(TreeListView Ptr, Parent)->Images->IndexOf(FImageKey), State, Indent)
        Else
            PItem = Add(FCaption, -1, State, Indent)
        End If
        If PItem Then PItem->ImageKey = FImageKey
        Return PItem
    End Function

    Function TreeListViewItems.Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0) As TreeListViewItem Ptr
        Dim As TreeListViewItem Ptr PItem
        #IfNDef __USE_GTK__
			Dim As LVITEM lvi
		#EndIf
        PItem = New TreeListViewItem
        FItems.Insert Index, PItem
        With *PItem
            .ImageIndex     = FImageIndex
            .Text(0)        = FCaption
            .State          = State
            If ParentItem Then
            	.Indent        = ParentItem->Indent + 1
            Else
            	.Indent        = 0
            End If
            #IfNDef __USE_GTK__
            	.Handle 		= Cast(LParam, PItem)
            #EndIf
            .Parent         = Parent
            .Items.Parent         = Parent
            .ParentItem        = Cast(TreeListViewItem Ptr, ParentItem)
            If FItems.Count = 1 AndAlso ParentItem Then
            	ParentItem->State = IIF(ParentItem->IsExpanded, 2, 1)
            End If
	        #IfDef __USE_GTK__
	        #Else
				If Parent AndAlso Parent->Handle Then 
					lvi.Mask = LVIF_TEXT or LVIF_IMAGE or LVIF_State or LVIF_Indent or LVIF_PARAM
					lvi.pszText  = @FCaption
					lvi.cchTextMax = Len(FCaption)
					lvi.iItem = Index
					lvi.iImage   = FImageIndex
					lvi.State   = INDEXTOSTATEIMAGEMASK(State)
					lvi.stateMask = LVIS_STATEIMAGEMASK
					lvi.iIndent   = .Indent
					lvi.LParam = Cast(LParam, PItem)
					ListView_InsertItem(Parent->Handle, @lvi)
				End If
			#EndIf
		End With
        Return PItem
    End Function

    Sub TreeListViewItems.Remove(Index As Integer)
        #IfDef __USE_GTK__
        	If Parent AndAlso Parent->widget Then
				gtk_tree_store_remove(Cast(TreeListView Ptr, Parent)->TreeStore, @This.Item(Index)->TreeIter)
			End If
        #Else
			If Parent AndAlso Parent->Handle Then
				Item(Index)->Visible = False
			End If
		#EndIf
		FItems.Remove Index
    End Sub	
	
	#IfNDef __USE_GTK__
'		Function CompareFunc(ByVal lParam1 As LPARAM, ByVal lParam2 As LPARAM, ByVal lParamSort As LPARAM) As Long
'			Return 0
'		End Function
	#EndIf
    
    Sub TreeListViewItems.Sort
		#IfNDef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				'Parent->Perform LVM_SORTITEMS, 0, @CompareFunc
				 'ListView_SortItems 
			End If
		#EndIf
    End Sub
    
    Function TreeListViewItems.IndexOf(BYREF FItem As TreeListViewItem Ptr) As Integer
        Return FItems.IndexOF(FItem)
    End Function

    Function TreeListViewItems.IndexOf(ByRef Caption As WString) As Integer
        For i As Integer = 0 To Count - 1
            If QTreeListViewItem(FItems.Items[i]).Text(0) = Caption Then
                Return i
            End If 
        Next i
        Return -1
    End Function

    Function TreeListViewItems.Contains(ByRef Caption As WString) As Boolean
        Return IndexOf(Caption) <> -1
    End Function

    Sub TreeListViewItems.Clear
		#IfDef __USE_GTK__
			If Parent AndAlso Cast(TreeListView Ptr, Parent)->TreeStore Then gtk_tree_store_clear(Cast(TreeListView Ptr, Parent)->TreeStore)
		#Else
			If Parent AndAlso Parent->Handle Then Parent->Perform LVM_DELETEALLITEMS, 0, 0 
        #EndIf
        For i As Integer = Count -1 To 0 Step -1
            Delete Cast(TreeListViewItem Ptr, FItems.Items[i])
        Next i
        FItems.Clear
    End Sub

    Operator TreeListViewItems.Cast As Any Ptr
        Return @This
    End Operator

    Constructor TreeListViewItems
        This.Clear
    End Constructor

    Destructor TreeListViewItems
         This.Clear
    End Destructor

    Property TreeListViewColumns.Count As Integer
        Return FColumns.Count
    End Property

    Property TreeListViewColumns.Count(Value As Integer)
    End Property

    Property TreeListViewColumns.Column(Index As Integer) As TreeListViewColumn Ptr
        Return QListViewColumn(FColumns.Items[Index])
    End Property

    Property TreeListViewColumns.Column(Index As Integer, Value As TreeListViewColumn Ptr)
       'QListViewColumn(FColumns.Items[Index]) = Value 
    End Property

	#IfDef __USE_GTK__
		Sub TreeListViewColumns.Cell_Edited(renderer As GtkCellRendererText Ptr, path As gchar Ptr, new_text As gchar Ptr, user_data As Any Ptr)
			Dim As TreeListViewColumn Ptr PColumn = user_data
			If PColumn = 0 Then Exit Sub
			Dim As TreeListView Ptr lv = Cast(TreeListView Ptr, PColumn->Parent)
			If lv = 0 Then Exit Sub
			Dim As GtkTreeIter iter
			Dim As GtkTreeModel Ptr model = gtk_tree_view_get_model(gtk_tree_view(lv->Widget))
			If gtk_tree_model_get_iter(model, @iter, gtk_tree_path_new_from_string(path)) Then
				If lv->OnCellEdited Then lv->OnCellEdited(*lv, lv->ListItems.FindByIterUser_Data(iter.User_Data), PColumn->Index, *new_text)
				'gtk_tree_store_set(lv->TreeStore, @iter, PColumn->Index + 1, ToUtf8(*new_text), -1)
			End If
		End Sub
		
		Sub TreeListViewColumns.Cell_Editing(cell As GtkCellRenderer Ptr, editable As GtkCellEditable Ptr, path As const gchar Ptr, user_data As Any Ptr)
			Dim As TreeListViewColumn Ptr PColumn = user_data
			If PColumn = 0 Then Exit Sub
			Dim As TreeListView Ptr lv = Cast(TreeListView Ptr, PColumn->Parent)
			If lv = 0 Then Exit Sub
			Dim As GtkTreeIter iter
			Dim As GtkTreeModel Ptr model = gtk_tree_view_get_model(gtk_tree_view(lv->Widget))
			Dim As Control Ptr CellEditor
			If gtk_tree_model_get_iter(model, @iter, gtk_tree_path_new_from_string(path)) Then
				If lv->OnCellEditing Then lv->OnCellEditing(*lv, lv->ListItems.FindByIterUser_Data(iter.User_Data), PColumn->Index, CellEditor)
				If CellEditor <> 0 Then editable = gtk_cell_editable(CellEditor->Widget)
			End If
		End Sub
	#EndIf

    Function TreeListViewColumns.Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As ColumnFormat = cfLeft, ColEditable As Boolean = False) As TreeListViewColumn Ptr
        Dim As TreeListViewColumn Ptr PColumn
        Dim As Integer Index
        #IfNDef __USE_GTK__
			Dim As LVCOLUMN lvc
        #EndIf
        PColumn = New TreeListViewColumn
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
				Dim As GtkCellRenderer Ptr rendertext = gtk_cell_renderer_text_new ()
				If ColEditable Then
					Dim As GValue bValue '= G_VALUE_INIT
					g_value_init_(@bValue, G_TYPE_BOOLEAN)
					g_value_set_boolean(@bValue, TRUE)
					g_object_set_property(G_OBJECT(rendertext), "editable", @bValue)
					g_object_set_property(G_OBJECT(rendertext), "editable-set", @bValue)
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
				g_signal_connect(G_OBJECT(rendertext), "editing-started", G_CALLBACK (@Cell_Editing), PColumn)
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

    Sub TreeListViewColumns.Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As integer, Format As ColumnFormat = cfLeft)
        Dim As TreeListViewColumn Ptr PColumn
        #IfNDef __USE_GTK__
			Dim As LVCOLUMN lvc
        #EndIf
        PColumn = New TreeListViewColumn
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

    Sub TreeListViewColumns.Remove(Index As Integer)
        FColumns.Remove Index
        #IfNDef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				Parent->Perform LVM_DELETECOLUMN, cast(WPARAM, Index), 0
			End If
		#EndIf
    End Sub

    Function TreeListViewColumns.IndexOf(BYREF FColumn As TreeListViewColumn Ptr) As Integer
        Return FColumns.IndexOF(FColumn)
    End Function

    Sub TreeListViewColumns.Clear
        For i As Integer = Count -1 To 0 Step -1
            Delete @QTreeListViewColumn(FColumns.Items[i])
            Remove i
        Next i
        FColumns.Clear
    End Sub

    Operator TreeListViewColumns.Cast As Any Ptr
        Return @This
    End Operator

    Constructor TreeListViewColumns
        This.Clear
    End Constructor

    Destructor TreeListViewColumns
         This.Clear
    End Destructor
    
    Sub TreeListView.Init()
    	#IfDef __USE_GTK__
			If gtk_tree_view_get_model(gtk_tree_view(widget)) = NULL Then
				gtk_tree_store_set_column_types(TreeStore, Columns.Count + 1, ColumnTypes)
				gtk_tree_view_set_model(gtk_tree_view(widget), GTK_TREE_MODEL(TreeStore))
				gtk_tree_view_set_enable_tree_lines(GTK_TREE_VIEW(widget), true)
			End If
		#EndIf
    End Sub
    
    Property TreeListView.ColumnHeaderHidden As Boolean
        Return FColumnHeaderHidden
    End Property

    Property TreeListView.ColumnHeaderHidden(Value As Boolean)
        FColumnHeaderHidden = Value
        #IfDef __USE_GTK__
			gtk_tree_view_set_headers_visible(GTK_TREE_VIEW(widget), Not Value)
        #Else
			ChangeStyle LVS_NOCOLUMNHEADER, Value
		#EndIf
    End Property
    
    Property TreeListView.SingleClickActivate As Boolean
        Return FSingleClickActivate
    End Property

    Property TreeListView.SingleClickActivate(Value As Boolean)
        FSingleClickActivate = Value
        #IfDef __USE_GTK__
        	#IfDef __USE_GTK3__
				gtk_tree_view_set_activate_on_single_click(GTK_TREE_VIEW(widget), Value)
        	#Else
        		
        	#EndIf
        #Else
			
		#EndIf
    End Property

    Property TreeListView.View As ViewStyle
        #IfNDef __USE_GTK__
			If Handle Then 
				FView = ListView_GetView(Handle)
			End If
		#EndIf
        Return FView
    End Property

    Property TreeListView.View(Value As ViewStyle)
        FView = Value
		#IfNDef __USE_GTK__
			If Handle Then Perform LVM_SETVIEW, cast(wparam, cast(dword, Value)), 0
		#EndIf
    End Property

    Property TreeListView.SelectedItem As TreeListViewItem Ptr
        #IfDef __USE_GTK__
        	Dim As GtkTreeIter iter
			If gtk_tree_selection_get_selected(TreeSelection, NULL, @iter) Then
				Return ListItems.FindByIterUser_Data(iter.User_Data)
			End If
        #Else
			If Handle Then
				Dim As Integer item = ListView_GetNextItem(Handle, -1, LVNI_SELECTED)
				If item <> -1 Then Return GetTreeListViewItem(item)
			End If
		#EndIf
        Return 0
    End Property
    
    Property TreeListView.SelectedItemIndex As Integer
        #IfDef __USE_GTK__
        	Dim As GtkTreeIter iter
			If gtk_tree_selection_get_selected(TreeSelection, NULL, @iter) Then
				Dim As TreeListViewItem Ptr lvi = ListItems.FindByIterUser_Data(iter.User_Data)
				If lvi <> 0 Then Return lvi->Index
			End If
        #Else
			If Handle Then
				Return ListView_GetNextItem(Handle, -1, LVNI_SELECTED)
			End If
		#EndIf
        Return -1
    End Property
    
    Property TreeListView.SelectedItemIndex(Value As Integer)
        #IfDef __USE_GTK__
			If TreeSelection Then
				If Value = -1 Then
					gtk_tree_selection_unselect_all(TreeSelection)
				ElseIf Value > -1 AndAlso Value < ListItems.Count Then
					gtk_tree_selection_select_iter(TreeSelection, @ListItems.Item(Value)->TreeIter)
					gtk_tree_view_scroll_to_cell(gtk_tree_view(widget), gtk_tree_model_get_path(gtk_tree_model(TreeStore), @ListItems.Item(Value)->TreeIter), NULL, False, 0, 0)
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

    Property TreeListView.SelectedItem(Value As TreeListViewItem Ptr)
        Value->SelectItem
    End Property

    Property TreeListView.SelectedColumn As TreeListViewColumn Ptr
        #IfNDef __USE_GTK__
			If Handle Then
				Return Columns.Column(ListView_GetSelectedColumn(Handle))
			End If
		#EndIf
        Return 0
    End Property
    
    #IfNDef __USE_GTK__
	    Function TreeListView.GetTreeListViewItem(iItem As Integer) As TreeListViewItem Ptr
	    	Dim lvi As LVITEM
			lvi.mask = LVIF_PARAM
			lvi.iItem = iItem
			If ListView_GetItem(Handle, @lvi) Then
				Return Cast(TreeListViewItem Ptr, lvi.LParam)
			End If
			Return 0
	    End Function
	#EndIf
    
    Property TreeListView.Sort As SortStyle
        Return FSortStyle
    End Property

    Property TreeListView.Sort(Value As SortStyle)
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

    Property TreeListView.SelectedColumn(Value As TreeListViewColumn Ptr)
        #IfNDef __USE_GTK__
			If Handle Then ListView_SetSelectedColumn(Handle, Value->Index)
		#EndIf
    End Property

    Property TreeListView.ShowHint As Boolean
        Return FShowHint
    End Property

    Property TreeListView.ShowHint(Value As Boolean)
        FShowHint = Value
    End Property

		Sub TreeListView.WndProc(BYREF Message As Message)
		End Sub
		
		
		
		Sub TreeListView.ProcessMessage(BYREF Message As Message)
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
				Case WM_LBUTTONDOWN
					Dim lvhti As LVHITTESTINFO
					lvhti.pt.x = Message.lParamLo
					lvhti.pt.y = Message.lParamHi
					If (ListView_HitTest(Handle, @lvhti) <> -1) Then
						If (lvhti.flags = LVHT_ONITEMSTATEICON) Then
							Var tlvi = GetTreeListViewItem(lvhti.iItem)
							If tlvi AndAlso tlvi->Items.Count > 0 Then
								If tlvi->IsExpanded Then
									tlvi->Collapse
								Else
									If OnItemExpanding Then OnItemExpanding(This, tlvi)
									tlvi->Expand
								End If
							End If
						End If
					End If
				Case CM_NOTIFY
					Dim lvp As NMLISTVIEW Ptr = Cast(NMLISTVIEW Ptr, message.lparam)
					Select Case lvp->hdr.code
					Case NM_CLICK: If OnItemClick Then OnItemClick(This, GetTreeListViewItem(lvp->iItem))
					Case NM_DBLCLK: If OnItemDblClick Then OnItemDblClick(This, GetTreeListViewItem(lvp->iItem))
					Case NM_KEYDOWN: If OnItemKeyDown Then OnItemKeyDown(This, GetTreeListViewItem(lvp->iItem))
					Case LVN_ITEMACTIVATE: If OnItemActivate Then OnItemActivate(This, GetTreeListViewItem(lvp->iItem))
					Case LVN_BEGINSCROLL: If OnBeginScroll Then OnBeginScroll(This)
					Case LVN_ENDSCROLL: If OnEndScroll Then OnEndScroll(This)
					Case LVN_ITEMCHANGED: If OnSelectedItemChanged Then OnSelectedItemChanged(This, GetTreeListViewItem(lvp->iItem))
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
		Sub TreeListView.HandleIsDestroyed(BYREF Sender As Control)
		End Sub

		Sub TreeListView.HandleIsAllocated(BYREF Sender As Control)
			If Sender.Child Then
				With QTreeListView(Sender.Child)
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
						For j As Integer = 0 To .Columns.Count - 1
							Dim As LVITEM lvi1
							lvi1.Mask = LVIF_TEXT
							lvi1.iItem = i
							lvi1.iSubItem   = j
							lvi1.pszText    = @.ListItems.Item(i)->Text(j)
							lvi1.cchTextMax = Len(.ListItems.Item(i)->Text(j))
							ListView_SetItem(.Handle, @lvi1)
						Next j
					Next i
				End With
			End If
		End Sub
	#EndIf

    Operator TreeListView.Cast As Control Ptr 
        Return @This
    End Operator

	#IfDef __USE_GTK__
		Sub TreeListView_RowActivated(tree_view As GtkTreeView Ptr, path As GtkTreePath Ptr, column As GtkTreeViewColumn Ptr, user_data As Any Ptr)
			Dim As TreeListView Ptr lv = Cast(Any Ptr, user_data)
			If lv Then
				Dim As GtkTreeModel Ptr model
				Dim As GtkTreeIter iter
				model = gtk_tree_view_get_model(tree_view)
				
				If gtk_tree_model_get_iter(model, @iter, path) Then
					If lv->OnItemActivate Then lv->OnItemActivate(*lv, lv->ListItems.FindByIterUser_Data(iter.User_Data))
				End If
			End If
	    End Sub
	    
	    Sub TreeListView_SelectionChanged(selection As GtkTreeSelection Ptr, user_data As Any Ptr)
			Dim As TreeListView Ptr lv = Cast(Any Ptr, user_data)
			If lv Then
				Dim As GtkTreeIter iter
				Dim As GtkTreeModel Ptr model
				If gtk_tree_selection_get_selected(selection, @model, @iter) Then
					If lv->OnSelectedItemChanged Then lv->OnSelectedItemChanged(*lv, lv->ListItems.FindByIterUser_Data(iter.User_Data))
				End If
			End If
	    End Sub
	    
	    Sub TreeListView_Map(widget As GtkWidget Ptr, user_data As Any Ptr)
			Dim As TreeListView Ptr lv = user_data
			lv->Init
	    End Sub
	    
	    Function TreeListView.TreeListView_TestExpandRow(tree_view As GtkTreeView Ptr, iter As GtkTreeIter Ptr, path As GtkTreePath Ptr, user_data As Any Ptr) As Boolean
	    	Dim As TreeListView Ptr lv = user_data
			If lv Then
				Dim As GtkTreeModel Ptr model
				model = gtk_tree_view_get_model(tree_view)
				If lv->OnItemExpanding Then lv->OnItemExpanding(*lv, lv->ListItems.FindByIterUser_Data(iter->User_Data))
			End If
			Return False
	    End Function
	    
	#EndIf
	
	Sub TreeListView.CollapseAll
    	#IfDef __USE_GTK__
    		gtk_tree_view_collapse_all(gtk_tree_view(widget))
    	#EndIf
    End Sub
    
    Sub TreeListView.ExpandAll
    	#IfDef __USE_GTK__
    		gtk_tree_view_expand_all(gtk_tree_view(widget))
    	#EndIf
    End Sub
    
    Constructor TreeListView
    	#IfDef __USE_GTK__
			TreeStore = gtk_tree_store_new(1, G_TYPE_STRING)
			scrolledwidget = gtk_scrolled_window_new(NULL, NULL)
			gtk_scrolled_window_set_policy(gtk_scrolled_window(scrolledwidget), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
			'widget = gtk_tree_view_new_with_model(gtk_tree_model(ListStore))
			widget = gtk_tree_view_new()
			gtk_container_add(gtk_container(scrolledwidget), widget)
			TreeSelection = gtk_tree_view_get_selection(GTK_TREE_VIEW(widget))
			g_signal_connect(gtk_tree_view(widget), "map", G_CALLBACK(@TreeListView_Map), @This)
			g_signal_connect(gtk_tree_view(widget), "row-activated", G_CALLBACK(@TreeListView_RowActivated), @This)
			g_signal_connect(gtk_tree_view(widget), "test-expand-row", G_CALLBACK(@TreeListView_TestExpandRow), @This)
			g_signal_connect(G_OBJECT(TreeSelection), "changed", G_CALLBACK (@TreeListView_SelectionChanged), @This)
			gtk_tree_view_set_enable_tree_lines(GTK_TREE_VIEW(widget), true)
			gtk_tree_view_set_grid_lines(GTK_TREE_VIEW(widget), GTK_TREE_VIEW_GRID_LINES_BOTH)
			ColumnTypes = New GType[1]
			ColumnTypes[0] = G_TYPE_STRING
			This.RegisterClass "TreeListView", @This
		#EndIf
        ListItems.Clear
        ListItems.Parent = @This
        Columns.Parent = @This
        FEnabled = True
        FVisible = True
        With This
			.Child             = @This
			#IfNDef __USE_GTK__
				.OnHandleIsAllocated = @HandleIsAllocated
				.OnHandleIsDestroyed = @HandleIsDestroyed
				.RegisterClass "TreeListView", WC_ListView
				.ChildProc         = @WndProc
				.ExStyle           = WS_EX_CLIENTEDGE
				.Style             = WS_CHILD Or WS_TABSTOP Or WS_VISIBLE Or LVS_REPORT Or LVS_ICON Or LVS_SINGLESEL Or LVS_SHOWSELALWAYS
				WLet FClassAncestor, WC_ListView
			#EndIf
            WLet FClassName, "TreeListView"
            .Width             = 121
            .Height            = 121
        End With 
    End Constructor

    Destructor TreeListView
    	ListItems.Clear
    	Columns.Clear
		#IfNDef __USE_GTK__    
			UnregisterClass "TreeListView",GetmoduleHandle(NULL)
		#Else
			If ColumnTypes Then Delete [] ColumnTypes
		#EndIf
    End Destructor
End Namespace
