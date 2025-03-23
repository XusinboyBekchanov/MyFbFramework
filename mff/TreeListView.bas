'################################################################################
'#  TreeListView.bi                                                             #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#include once "TreeListView.bi"
#include once "TextBox.bi"
#ifdef __USE_WINAPI__
	#include once "win\tmschema.bi"
#endif

Namespace My.Sys.Forms
	#ifndef __USE_GTK__
		Private Function TreeListViewItem.GetTreeListViewItemIndex(Node As TreeListViewItem Ptr, iItem As TreeListViewItem Ptr, ByRef iCount As Integer) As Integer
			Dim As Integer Result
			If Not Node->IsExpanded Then Return -1
			For i As Integer = 0 To Node->Nodes.Count - 1
				If Not Node->Nodes.Item(i)->Visible Then Continue For
				iCount += 1
				If iItem = Node->Nodes.Item(i) Then Return iCount
				Result = GetTreeListViewItemIndex(Node->Nodes.Item(i), iItem, iCount)
				If Result > -1 Then Return Result
			Next
			Return -1
		End Function
		
		Private Function TreeListViewItem.GetItemIndex() As Integer
			If FParentItem <> 0 AndAlso Not FParentItem->FExpanded Then Return -1
			If Parent = 0 OrElse Handle = 0 Then Return -1
			If Cast(TreeListView Ptr, Parent)->OwnerData Then
				With *Cast(TreeListView Ptr, Parent)
					Dim As Integer iCount = -1, Result
					For i As Integer = 0 To .Nodes.Count - 1
						If Not .Nodes.Item(i)->Visible Then Continue For
						iCount += 1
						If .Nodes.Item(i) = @This Then Return iCount
						Result = GetTreeListViewItemIndex(.Nodes.Item(i), @This, iCount)
						If Result > -1 Then Return Result
					Next
				End With
			Else
				Var nItem = ListView_GetItemCount(Parent->Handle)
				For i As Integer = 0 To nItem - 1
					lvi.mask = LVIF_PARAM
					lvi.iItem = i
					lvi.iSubItem   = 0
					ListView_GetItem(Parent->Handle, @lvi)
					If lvi.lParam = Cast(LPARAM, @This) Then
						Return i
					End If
				Next i
			End If
			Return -1
		End Function
	#endif
	
	Private Sub TreeListViewItem.Collapse
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->Handle AndAlso Cast(TreeListView Ptr, Parent)->TreeStore Then
				If Visible Then
					Dim As GtkTreePath Ptr TreePath = gtk_tree_path_new_from_string(gtk_tree_model_get_string_from_iter(GTK_TREE_MODEL(Cast(TreeListView Ptr, Parent)->TreeStore), @TreeIter))
					gtk_tree_view_collapse_row(GTK_TREE_VIEW(Parent->Handle), TreePath)
					gtk_tree_path_free(TreePath)
				End If
			End If
		#else
			If Parent AndAlso Parent->Handle Then
				Var ItemIndex = This.GetItemIndex()
				If ItemIndex <> -1 Then
					LockWindowUpdate Parent->Handle
					State = 1
					Var nItem = ListView_GetItemCount(Parent->Handle)
					Var i = ItemIndex + 1
					If Cast(TreeListView Ptr, Parent)->OwnerData Then
						Dim As TreeListViewItem Ptr tlvi
						Dim As IntegerList iList
						Do While i < nItem
							tlvi = Cast(TreeListView Ptr, Parent)->GetItemByVisibleIndex(i)
							If tlvi > 0 Then
								If tlvi->Indent > FIndent Then
									iList.Add i
								ElseIf tlvi->Indent <= FIndent Then
									Exit Do
								End If
							End If
							i += 1
						Loop
						For i = iList.Count - 1 To 0 Step -1
							ListView_DeleteItem(Parent->Handle, iList.Item(i))
						Next
					Else
						Do While i < nItem
							lvi.mask = LVIF_INDENT
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
					LockWindowUpdate 0
				End If
			End If
		#endif
		FExpanded = False
	End Sub
	
	Private Sub TreeListViewItem.Expand
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->Handle AndAlso Cast(TreeListView Ptr, Parent)->TreeStore Then
				If Visible Then
					Dim As GtkTreePath Ptr TreePath = gtk_tree_path_new_from_string(gtk_tree_model_get_string_from_iter(GTK_TREE_MODEL(Cast(TreeListView Ptr, Parent)->TreeStore), @TreeIter))
					gtk_tree_view_expand_row(GTK_TREE_VIEW(Parent->Handle), TreePath, False)
					gtk_tree_path_free(TreePath)
				End If
			End If
		#else
			If Parent AndAlso Parent->Handle Then
				If Not FExpanded Then
					If QTreeListView(Parent).OnItemExpanding Then QTreeListView(Parent).OnItemExpanding(* (QTreeListView(Parent).Designer), QTreeListView(Parent), @This)
					State = 2
					Var ItemIndex = This.GetItemIndex
					If ItemIndex <> -1 Then
						For i As Integer = 0 To Nodes.Count - 1
							lvi.mask = LVIF_TEXT Or LVIF_IMAGE Or LVIF_STATE Or LVIF_INDENT Or LVIF_PARAM
							lvi.pszText  = @Nodes.Item(i)->Text(0)
							lvi.cchTextMax = Len(Nodes.Item(i)->Text(0))
							lvi.iItem = ItemIndex + i + 1
							lvi.iImage   = Nodes.Item(i)->FImageIndex
							If Nodes.Item(i)->Nodes.Count > 0 Then
								lvi.state   = INDEXTOSTATEIMAGEMASK(1)
								Nodes.Item(i)->FExpanded = False
							Else
								lvi.state   = 0
							End If
							lvi.stateMask = LVIS_STATEIMAGEMASK
							lvi.iIndent   = Nodes.Item(i)->Indent
							lvi.lParam = Cast(LPARAM, Nodes.Item(i))
							ListView_InsertItem(Parent->Handle, @lvi)
							For j As Integer = 1 To Cast(TreeListView Ptr, Parent)->Columns.Count - 1
								Dim As LVITEM lvi1
								lvi1.mask = LVIF_TEXT
								lvi1.iItem = ItemIndex + i + 1
								lvi1.iSubItem   = j
								lvi1.pszText    = @Nodes.Item(i)->Text(j)
								lvi1.cchTextMax = Len(Nodes.Item(i)->Text(j))
								ListView_SetItem(Parent->Handle, @lvi1)
							Next j
						Next i
					End If
				End If
			End If
		#endif
		FExpanded = True
	End Sub
	
	Private Function TreeListViewItem.IsExpanded As Boolean
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->Handle AndAlso Cast(TreeListView Ptr, Parent)->TreeStore Then
				Dim As GtkTreePath Ptr TreePath = gtk_tree_path_new_from_string(gtk_tree_model_get_string_from_iter(GTK_TREE_MODEL(Cast(TreeListView Ptr, Parent)->TreeStore), @TreeIter))
				Var bResult = gtk_tree_view_row_expanded(GTK_TREE_VIEW(Parent->Handle), TreePath)
				gtk_tree_path_free(TreePath)
				Return bResult
			End If
		#else
			Return FExpanded
			'If Parent AndAlso Parent->Handle Then Return TreeView_GetItemState(Parent->Handle, Handle, TVIS_EXPANDED)
		#endif
	End Function
	
	Private Function TreeListViewItem.Index As Integer
		If FParentItem <> 0 Then
			Return FParentItem->Nodes.IndexOf(@This)
		ElseIf Parent <> 0 Then
			Return Cast(TreeListView Ptr, Parent)->Nodes.IndexOf(@This)
		Else
			Return -1
		End If
	End Function
	
	Private Sub TreeListViewItem.SelectItem
		#ifdef __USE_GTK__
			If Parent AndAlso Cast(TreeListView Ptr, Parent)->TreeSelection Then
				gtk_tree_selection_select_iter(Cast(TreeListView Ptr, Parent)->TreeSelection, @TreeIter)
			End If
		#else
			If Parent AndAlso Parent->Handle Then
				Var ItemIndex = This.GetItemIndex
				If ItemIndex = -1 Then Exit Sub
				ListView_SetItemState(Parent->Handle, ItemIndex, LVIS_FOCUSED Or LVIS_SELECTED, LVNI_SELECTED Or LVNI_FOCUSED)
			End If
		#endif
	End Sub
	
	Private Property TreeListViewItem.Text(iSubItem As Integer) ByRef As WString
		If FSubItems.Count > iSubItem Then
			Return FSubItems.Item(iSubItem)
		Else
			Return WStr("")
		End If
	End Property
	
	Private Property TreeListViewItem.Text(iSubItem As Integer, ByRef Value As WString)
		WLet(FText, Value)
		For i As Integer = FSubItems.Count To iSubItem
			FSubItems.Add ""
		Next i
		FSubItems.Item(iSubItem) = Value
		If Parent Then
			#ifdef __USE_GTK__
				If Cast(TreeListView Ptr, Parent)->TreeStore Then
					gtk_tree_store_set (Cast(TreeListView Ptr, Parent)->TreeStore, @TreeIter, iSubItem + 1, ToUtf8(Value), -1)
				End If
			#else
				If Parent AndAlso Parent->Handle Then
					Var ItemIndex = This.GetItemIndex
					If ItemIndex = -1 Then Exit Property
					lvi.mask = LVIF_TEXT
					lvi.iItem = ItemIndex
					lvi.iSubItem   = iSubItem
					lvi.pszText    = FText
					lvi.cchTextMax = Len(*FText)
					ListView_SetItem(Parent->Handle, @lvi)
				End If
			#endif
		End If
	End Property
	
	Private Property TreeListViewItem.State As Integer
		Return FState
	End Property
	
	Private Property TreeListViewItem.State(Value As Integer)
		FState = Value
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				Var ItemIndex = GetItemIndex
				If ItemIndex = -1 Then Exit Property
				lvi.mask = LVIF_STATE
				lvi.iItem = ItemIndex
				lvi.iSubItem   = 0
				lvi.state    = INDEXTOSTATEIMAGEMASK(Value)
				lvi.stateMask = LVIS_STATEIMAGEMASK
				ListView_SetItem(Parent->Handle, @lvi)
			End If
		#endif
	End Property
	
	Private Property TreeListViewItem.Indent As Integer
		Return FIndent
	End Property
	
	Private Property TreeListViewItem.Indent(Value As Integer)
		FIndent = Value
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				Var ItemIndex = GetItemIndex
				If ItemIndex = -1 Then Exit Property
				lvi.mask = LVIF_INDENT
				lvi.iItem = ItemIndex
				lvi.iSubItem   = 0
				lvi.iIndent    = Value
				ListView_SetItem(Parent->Handle, @lvi)
			End If
		#endif
	End Property
	
	Private Property TreeListViewItem.Hint ByRef As WString
		Return WGet(FHint)
	End Property
	
	Private Property TreeListViewItem.Hint(ByRef Value As WString)
		WLet(FHint, Value)
	End Property
	
	
	Private Property TreeListViewItem.ImageIndex As Integer
		Return FImageIndex
	End Property
	
	Private Property TreeListViewItem.ImageIndex(Value As Integer)
		If Value <> FImageIndex Then
			FImageIndex = Value
			If Parent Then
				With QControl(Parent)
					'.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
				End With
			End If
		End If
	End Property
	
	Private Property TreeListViewItem.SelectedImageIndex As Integer
		Return FImageIndex
	End Property
	
	Private Property TreeListViewItem.SelectedImageIndex(Value As Integer)
		If Value <> FSelectedImageIndex Then
			FSelectedImageIndex = Value
			If Parent Then
				With QControl(Parent)
					'.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
				End With
			End If
		End If
	End Property
	
	Private Property TreeListViewItem.Visible As Boolean
		Return FVisible
	End Property
	
	Private Property TreeListViewItem.ParentItem As TreeListViewItem Ptr
		Return FParentItem
	End Property
	
	Private Property TreeListViewItem.ParentItem(Value As TreeListViewItem Ptr)
		FParentItem = Value
	End Property
	
	Private Property TreeListViewItem.ImageKey ByRef As WString
		If FImageKey > 0 Then Return *FImageKey Else Return ""
	End Property
	
	Private Property TreeListViewItem.ImageKey(ByRef Value As WString)
		If FImageKey = 0 OrElse Value <> *FImageKey Then
			WLet(FImageKey, Value)
			#ifdef __USE_GTK__
				If Parent AndAlso Parent->Handle Then
					gtk_tree_store_set (Cast(TreeListView Ptr, Parent)->TreeStore, @TreeIter, 0, ToUtf8(Value), -1)
				End If
			#else
				If Parent Then
					With QControl(Parent)
						'.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
					End With
				End If
			#endif
		End If
	End Property
	
	Private Property TreeListViewItem.SelectedImageKey ByRef As WString
		If FSelectedImageKey > 0 Then Return *FSelectedImageKey Else Return ""
	End Property
	
	Private Property TreeListViewItem.SelectedImageKey(ByRef Value As WString)
		If FSelectedImageKey = 0 OrElse Value <> *FSelectedImageKey Then
			WLet(FSelectedImageKey, Value)
			If Parent Then
				With QControl(Parent)
					'.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
				End With
			End If
		End If
	End Property
	
	#ifndef __USE_GTK__
		Private Sub TreeListViewItem.DeleteItems(Node As TreeListViewItem Ptr)
			For i As Integer = Node->Nodes.Count - 1 To 0 Step -1
				Var ItemIndex = Node->Nodes.Item(i)->GetItemIndex
				If ItemIndex <> -1 Then ListView_DeleteItem(Node->Parent->Handle, ItemIndex)
			Next
		End Sub
		
		Private Function TreeListViewItem.GetVisibleItemsCount(Node As TreeListViewItem Ptr) As Integer
			Dim As Integer iCount
			If Node->IsExpanded Then
				For i As Integer = 0 To Node->Nodes.Count - 1
					If Node->Nodes.Item(i)->Visible Then
						iCount += GetVisibleItemsCount(Node->Nodes.Item(i)) + 1
					End If
				Next
			End If
			Return iCount
		End Function
	#endif
	
	Private Sub TreeListViewItem.AddItems(Node As TreeListViewItem Ptr)
		#ifdef __USE_GTK__
			If Node->ParentItem = 0 OrElse Node->ParentItem->Visible Then
				Dim As Integer iIndex
				Dim As TreeListViewItems Ptr pNodes
				If Node->ParentItem <> 0 Then
					pNodes = @(Node->ParentItem->Nodes)
				Else
					pNodes = @(QTreeListView(Node->Parent).Nodes)
				End If
				For i As Integer = 0 To Node->Index - 1
					If pNodes->Item(i)->Visible Then
						iIndex = iIndex + 1
					End If
				Next
				If Node->Parent AndAlso Cast(TreeListView Ptr, Node->Parent)->TreeStore Then
					Cast(TreeListView Ptr, Node->Parent)->Init
					If Node->ParentItem <> 0 Then
						gtk_tree_store_insert (Cast(TreeListView Ptr, Node->Parent)->TreeStore, @Node->TreeIter, @(Node->ParentItem->TreeIter), iIndex)
					Else
						gtk_tree_store_insert (Cast(TreeListView Ptr, Node->Parent)->TreeStore, @Node->TreeIter, NULL, iIndex)
					End If
					gtk_tree_store_set (Cast(TreeListView Ptr, Node->Parent)->TreeStore, @Node->TreeIter, 1, ToUtf8(Node->Text(0)), -1)
					For j As Integer = 1 To Cast(TreeListView Ptr, Node->Parent)->Columns.Count - 1
						gtk_tree_store_set (Cast(TreeListView Ptr, Node->Parent)->TreeStore, @Node->TreeIter, j + 1, ToUtf8(Node->Text(j)), -1)
					Next
					For j As Integer = 0 To Node->Nodes.Count - 1
						If Node->Nodes.Item(j)->Visible Then AddItems Node->Nodes.Item(j)
					Next
				End If
			End If
		#else
			Dim As Integer iIndex
			Dim As TreeListViewItems Ptr pNodes
			If Node->ParentItem <> 0 Then
				pNodes = @(Node->ParentItem->Nodes)
			Else
				pNodes = @(QTreeListView(Node->Parent).Nodes)
			End If
			If CInt(Node->Parent) AndAlso CInt(Node->Parent->Handle) AndAlso (CInt(CInt(Node->ParentItem = 0) OrElse CInt(Node->ParentItem->IsExpanded))) Then
				Dim As TreeListViewItem Ptr LastItem
				Dim As Integer ParentItemIndex
				For i As Integer = 0 To Node->Index - 1
					If pNodes->Item(i)->Visible Then
						LastItem = pNodes->Item(i)
					End If
				Next
				If LastItem = 0 Then
					If Node->ParentItem Then iIndex = Node->ParentItem->GetItemIndex + 1
				Else
					iIndex = LastItem->GetItemIndex + Node->GetVisibleItemsCount(LastItem) + 1
				End If
				If Node->ParentItem = 0 OrElse Node->ParentItem->GetItemIndex <> -1 Then
					Dim As LVITEM lvi
					lvi.mask = LVIF_TEXT Or LVIF_IMAGE Or LVIF_STATE Or LVIF_INDENT Or LVIF_PARAM
					lvi.pszText  = @(Node->Text(0))
					lvi.cchTextMax = Len(Node->Text(0))
					lvi.iItem = iIndex
					lvi.iSubItem = 0
					lvi.iImage   = Node->FImageIndex
					lvi.state   = INDEXTOSTATEIMAGEMASK(Node->State)
					lvi.stateMask = LVIS_STATEIMAGEMASK
					lvi.iIndent   = Node->Indent
					lvi.lParam = Cast(LPARAM, Node)
					ListView_InsertItem(Node->Parent->Handle, @lvi)
					For j As Integer = 1 To Cast(TreeListView Ptr, Node->Parent)->Columns.Count - 1
						Dim As LVITEM lvi1
						lvi1.mask = LVIF_TEXT
						lvi1.iItem = iIndex
						lvi1.iSubItem   = j
						lvi1.pszText    = @(Node->Text(j))
						lvi1.cchTextMax = Len(Node->Text(j))
						ListView_SetItem(Node->Parent->Handle, @lvi1)
					Next j
					For j As Integer = 0 To Node->Nodes.Count - 1
						If Node->Nodes.Item(j)->Visible Then AddItems Node->Nodes.Item(j)
					Next
				End If
			End If
		#endif
	End Sub
	
	Private Property TreeListViewItem.Visible(Value As Boolean)
		If Value <> FVisible Then
			FVisible = Value
			If Value Then
				AddItems @This
			Else
				#ifdef __USE_GTK__
					If Parent AndAlso Parent->Handle Then
						gtk_tree_store_remove(Cast(TreeListView Ptr, Parent)->TreeStore, @This.TreeIter)
					End If
				#else
					If Parent AndAlso Parent->Handle Then
						DeleteItems(@This)
						Var ItemIndex = GetItemIndex
						If ItemIndex <> -1 Then ListView_DeleteItem(Parent->Handle, ItemIndex)
					End If
				#endif
			End If
		End If
	End Property
	
	Private Operator TreeListViewItem.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor TreeListViewItem
		Nodes.Parent = Parent
		Nodes.ParentItem = @This
		FHint = 0 'CAllocate_(0)
		FText = 0 'CAllocate_(0)
		FVisible    = 1
		Text(0)    = ""
		Hint       = ""
		FImageIndex = -1
		FSelectedImageIndex = -1
		FSmallImageIndex = -1
	End Constructor
	
	Private Destructor TreeListViewItem
		Nodes.Clear
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				gtk_tree_store_remove(Cast(TreeListView Ptr, Parent)->TreeStore, @This.TreeIter)
			End If
		#else
			If Parent AndAlso Parent->Handle Then
				Var ItemIndex = GetItemIndex
				If ItemIndex <> -1 Then ListView_DeleteItem(Parent->Handle, ItemIndex)
			End If
		#endif
		WDeAllocate(FHint)
		WDeAllocate(FText)
		WDeAllocate(FImageKey)
		WDeAllocate(FSelectedImageKey)
		WDeAllocate(FSmallImageKey)
	End Destructor
	
	Private Sub TreeListViewColumn.SelectItem
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then ListView_SetSelectedColumn(Parent->Handle, Index)
		#endif
	End Sub
	
	Private Property TreeListViewColumn.Text ByRef As WString
		Return WGet(FText)
	End Property
	
	Private Property TreeListViewColumn.Text(ByRef Value As WString)
		WLet(FText, Value)
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				Dim lvc As LVCOLUMN
				lvc.mask = TVIF_TEXT
				lvc.iSubItem = Index
				lvc.pszText = FText
				lvc.cchTextMax = Len(*FText)
				ListView_SetColumn(Parent->Handle, Index, @lvc)
			End If
		#endif
	End Property
	
	Private Property TreeListViewColumn.Width As Integer
		#ifdef __USE_GTK__
			If This.Column Then FWidth = gtk_tree_view_column_get_width(This.Column)
		#else
			Dim lvc As LVCOLUMN
			lvc.mask = LVCF_WIDTH Or LVCF_SUBITEM
			lvc.iSubItem = Index
			If Parent AndAlso Parent->Handle AndAlso ListView_GetColumn(Parent->Handle, Index, @lvc) Then
				FWidth = UnScaleX(lvc.cx)
			End If
		#endif
		Return FWidth
	End Property
	
	Private Property TreeListViewColumn.Width(Value As Integer)
		FWidth = Value
		Update
	End Property
	
	Private Sub TreeListViewColumn.Update
		#ifdef __USE_GTK__
			#ifdef __USE_GTK3__
				If This.Column Then gtk_tree_view_column_set_fixed_width(This.Column, Max(-1, FWidth))
			#else
				If This.Column Then gtk_tree_view_column_set_fixed_width(This.Column, Max(1, FWidth))
			#endif
		#else
			If Parent AndAlso Parent->Handle Then
				Dim lvc As LVCOLUMN
				lvc.mask = LVCF_WIDTH Or LVCF_SUBITEM
				lvc.iSubItem = Index
				lvc.cx = ScaleX(FWidth)
				ListView_SetColumn(Parent->Handle, Index, @lvc)
			End If
		#endif
	End Sub
	
	Private Property TreeListViewColumn.Format As ColumnFormat
		Return FFormat
	End Property
	
	Private Property TreeListViewColumn.Format(Value As ColumnFormat)
		FFormat = Value
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				Dim lvc As LVCOLUMN
				lvc.mask = LVCF_FMT Or LVCF_SUBITEM
				lvc.iSubItem = Index
				lvc.fmt = Value
				ListView_SetColumn(Parent->Handle, Index, @lvc)
			End If
		#endif
	End Property
	
	Private Property TreeListViewColumn.Hint ByRef As WString
		Return WGet(FHint)
	End Property
	
	Private Property TreeListViewColumn.Hint(ByRef Value As WString)
		WLet(FHint, Value)
	End Property
	
	
	Private Property TreeListViewColumn.ImageIndex As Integer
		Return FImageIndex
	End Property
	
	Private Property TreeListViewColumn.ImageIndex(Value As Integer)
		If Value <> FImageIndex Then
			FImageIndex = Value
			If Parent Then
				With QControl(Parent)
					'.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
				End With
			End If
		End If
	End Property
	
	Private Property TreeListViewColumn.Visible As Boolean
		Return FVisible
	End Property
	
	Private Property TreeListViewColumn.Visible(Value As Boolean)
		If Value <> FVisible Then
			FVisible = Value
			If Parent Then
				With QControl(Parent)
					'.Perform(TB_HIDEBUTTON, FCommandID, MakeLong(NOT FVisible, 0))
				End With
			End If
		End If
	End Property
	
	Private Property TreeListViewColumn.Editable As Boolean
		Return FEditable
	End Property
	
	Private Property TreeListViewColumn.Editable(Value As Boolean)
		If Value <> FEditable Then
			FEditable = Value
			If Index = 0 Then
				
			End If
			#ifdef __USE_GTK__
				Dim As GValue bValue '= G_VALUE_INIT
				g_value_init_(@bValue, G_TYPE_BOOLEAN)
				g_value_set_boolean(@bValue, Value)
				g_object_set_property(G_OBJECT(rendertext), "editable", @bValue)
				g_object_set_property(G_OBJECT(rendertext), "editable-set", @bValue)
				g_value_unset(@bValue)
			#endif
		End If
	End Property
	
	Private Operator TreeListViewColumn.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor TreeListViewColumn
		FHint = 0 'CAllocate_(0)
		FText = 0 'CAllocate_(0)
		FVisible    = 1
		Text    = ""
		Hint       = ""
		FImageIndex = -1
	End Constructor
	
	Private Destructor TreeListViewColumn
		If FHint Then _Deallocate( FHint)
		If FText Then _Deallocate( FText)
	End Destructor
	
	Private Property TreeListViewItems.Count As Integer
		Return FItems.Count
	End Property
	
	Private Property TreeListViewItems.Count(Value As Integer)
		If Parent Then
			With *Cast(TreeListView Ptr, Parent)
				If Value >= .Nodes.Count Then
					For i As Integer = .Nodes.Count To Value - 1
						.Nodes.Add
					Next
				Else
					For i As Integer = .Nodes.Count - 1 To Value Step -1
						.Nodes.Remove i
					Next
				End If
			End With
			If Parent->Handle Then
				#ifdef __USE_WINAPI__
					SendMessage(Parent->Handle, LVM_SETITEMCOUNT, Value, LVSICF_NOINVALIDATEALL)
				#endif
			End If
		End If
	End Property
	
	Private Property TreeListViewItems.Item(Index As Integer) As TreeListViewItem Ptr
		If Index >= 0 AndAlso Index < FItems.Count Then
			Return FItems.Items[Index]
		End If
	End Property
	
	Private Property TreeListViewItems.Item(Index As Integer, Value As TreeListViewItem Ptr)
		If Index >= 0 AndAlso Index < FItems.Count Then
			FItems.Items[Index] = Value 'David Change
		End If
	End Property
	
	#ifdef __USE_GTK__
		Private Function TreeListViewItems.FindByIterUser_Data(User_Data As Any Ptr) As TreeListViewItem Ptr
			If ParentItem AndAlso ParentItem->TreeIter.user_data = User_Data Then Return ParentItem
			For i As Integer = 0 To Count - 1
				PItem = Item(i)->Nodes.FindByIterUser_Data(User_Data)
				If PItem <> 0 Then Return PItem
			Next i
			Return 0
		End Function
	#else
		Private Function TreeListViewItems.FindByHandle(Value As LPARAM) As TreeListViewItem Ptr
			If ParentItem AndAlso ParentItem->Handle = Value Then Return ParentItem
			For i As Integer = 0 To Count - 1
				PItem = Item(i)->Nodes.FindByHandle(Value)
				If PItem <> 0 Then Return PItem
			Next i
			Return 0
		End Function
	#endif
	
	Private Property TreeListViewItems.ParentItem As TreeListViewItem Ptr
		Return FParentItem
	End Property
	
	Private Property TreeListViewItems.ParentItem(Value As TreeListViewItem Ptr)
		FParentItem = Value
	End Property
	
	Private Function TreeListViewItems.Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0) As TreeListViewItem Ptr
		PItem = _New( TreeListViewItem)
		PItem->FDynamic = True
		FItems.Add PItem
		With *PItem
			.ImageIndex     = FImageIndex
			Var MinColumnsCount = 0
			If InStr(FCaption, Chr(9)) > 0 Then
				Dim As UString Captions(Any)
				Split(FCaption, Chr(9), Captions())
				MinColumnsCount = Min(UBound(Captions), Cast(TreeListView Ptr, Parent)->Columns.Count - 1)
				For j As Integer = 0 To MinColumnsCount
					.Text(j)        = Captions(j)
				Next
			Else
				.Text(0)        = FCaption
			End If
			.State        = State
			If ParentItem Then
				.Indent        = ParentItem->Indent + 1
			Else
				.Indent        = 0
			End If
			.Parent         = Parent
			.Nodes.Parent         = Parent
			.ParentItem        = ParentItem
			If FItems.Count = 1 AndAlso ParentItem Then
				ParentItem->State = IIf(ParentItem->IsExpanded, 2, 1)
			End If
			#ifdef __USE_GTK__
				If Parent AndAlso Cast(TreeListView Ptr, Parent)->TreeStore Then
					Cast(TreeListView Ptr, Parent)->Init
					If ParentItem <> 0 Then
						gtk_tree_store_append (Cast(TreeListView Ptr, Parent)->TreeStore, @PItem->TreeIter, @.ParentItem->TreeIter)
					Else
						gtk_tree_store_append (Cast(TreeListView Ptr, Parent)->TreeStore, @PItem->TreeIter, NULL)
					End If
					gtk_tree_store_set (Cast(TreeListView Ptr, Parent)->TreeStore, @PItem->TreeIter, 1, ToUtf8(.Text(0)), -1)
					For j As Integer = 1 To MinColumnsCount
						gtk_tree_store_set (Cast(TreeListView Ptr, Parent)->TreeStore, @PItem->TreeIter, j + 1, ToUtf8(.Text(j)), -1)
					Next j
				End If
				PItem->Text(0) = .Text(0)
			#else
				If CInt(Parent) AndAlso CInt(Parent->Handle) Then
					If Cast(TreeListView Ptr, Parent)->OwnerData Then
						'SendMessage(Parent->Handle, LVM_SETITEMCOUNT, FItems.Count, LVSICF_NOINVALIDATEALL)
					ElseIf CInt(ParentItem = 0) OrElse CInt(ParentItem->IsExpanded) Then
						Var i = FItems.Count - 1
						lvi.mask = LVIF_TEXT Or LVIF_IMAGE Or LVIF_STATE Or LVIF_INDENT Or LVIF_PARAM
						lvi.pszText  = @.Text(0)
						lvi.cchTextMax = Len(.Text(0))
						'lvi.pszText  = @FCaption
						'lvi.cchTextMax = Len(FCaption)
						lvi.iItem = i
						lvi.iSubItem = 0
						lvi.iImage   = FImageIndex
						lvi.state   = INDEXTOSTATEIMAGEMASK(State)
						lvi.stateMask = LVIS_STATEIMAGEMASK
						lvi.iIndent   = .Indent
						lvi.lParam = Cast(LPARAM, PItem)
						ListView_InsertItem(Parent->Handle, @lvi)
						For j As Integer = 1 To MinColumnsCount
							Dim As LVITEM lvi1
							lvi1.mask = LVIF_TEXT
							lvi1.iItem = i
							lvi1.iSubItem   = j
							lvi1.pszText    = @.Text(j)
							lvi1.cchTextMax = Len(.Text(j))
							ListView_SetItem(Parent->Handle, @lvi1)
						Next j
					End If
				End If
				.Handle = Cast(LPARAM, PItem)
			#endif
		End With
		Return PItem
	End Function
	
	Private Function TreeListViewItems.Add(ByRef FCaption As WString = "", ByRef FImageKey As WString, State As Integer = 0, Indent As Integer = 0) As TreeListViewItem Ptr
		If Parent AndAlso Cast(TreeListView Ptr, Parent)->Images Then
			PItem = Add(FCaption, Cast(TreeListView Ptr, Parent)->Images->IndexOf(FImageKey), State, Indent)
		Else
			PItem = Add(FCaption, -1, State, Indent)
		End If
		If PItem Then PItem->ImageKey = FImageKey
		Return PItem
	End Function
	
	Private Function TreeListViewItems.Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0) As TreeListViewItem Ptr
		Dim As TreeListViewItem Ptr PItem
		#ifndef __USE_GTK__
			Dim As LVITEM lvi
		#endif
		PItem = _New( TreeListViewItem)
		PItem->FDynamic = True
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
			#ifndef __USE_GTK__
				.Handle 		= Cast(LPARAM, PItem)
			#endif
			.Parent         = Parent
			.Nodes.Parent         = Parent
			.ParentItem        = Cast(TreeListViewItem Ptr, ParentItem)
			If FItems.Count = 1 AndAlso ParentItem Then
				ParentItem->State = IIf(ParentItem->IsExpanded, 2, 1)
			End If
			#ifdef __USE_GTK__
				If Parent AndAlso Cast(TreeListView Ptr, Parent)->TreeStore Then
					Cast(TreeListView Ptr, Parent)->Init
					If ParentItem <> 0 Then
						gtk_tree_store_insert(Cast(TreeListView Ptr, Parent)->TreeStore, @PItem->TreeIter, @.ParentItem->TreeIter, Index)
					Else
						gtk_tree_store_insert(Cast(TreeListView Ptr, Parent)->TreeStore, @PItem->TreeIter, NULL, Index)
					End If
					gtk_tree_store_set(Cast(TreeListView Ptr, Parent)->TreeStore, @PItem->TreeIter, 1, ToUtf8(FCaption), -1)
				End If
				PItem->Text(0) = FCaption
			#else
				If Parent AndAlso Parent->Handle Then
					lvi.mask = LVIF_TEXT Or LVIF_IMAGE Or LVIF_STATE Or LVIF_INDENT Or LVIF_PARAM
					lvi.pszText  = @FCaption
					lvi.cchTextMax = Len(FCaption)
					lvi.iItem = Index
					lvi.iImage   = FImageIndex
					lvi.state   = INDEXTOSTATEIMAGEMASK(State)
					lvi.stateMask = LVIS_STATEIMAGEMASK
					lvi.iIndent   = .Indent
					lvi.lParam = Cast(LPARAM, PItem)
					ListView_InsertItem(Parent->Handle, @lvi)
				End If
			#endif
		End With
		Return PItem
	End Function
	
	Private Sub TreeListViewItems.Remove(Index As Integer)
		'		#ifdef __USE_GTK__
		'			If Parent AndAlso Parent->widget Then
		'				'gtk_tree_store_remove(Cast(TreeListView Ptr, Parent)->TreeStore, @This.Item(Index)->TreeIter)
		'				Delete_( Cast(TreeListViewItem Ptr, FItems.Items[Index]))
		'			End If
		'		#else
		'			If Parent AndAlso Parent->Handle Then
		'				'Item(Index)->Visible = False
		'				Delete_( Cast(TreeListViewItem Ptr, FItems.Items[Index]))
		'			End If
		'		#endif
		If Count < 1 OrElse Index < 0 OrElse Index > Count - 1 Then Exit Sub
		If Cast(TreeListViewItem Ptr, FItems.Items[Index])->FDynamic Then _Delete( Cast(TreeListViewItem Ptr, FItems.Items[Index]))
		FItems.Remove Index
	End Sub
	
	#ifdef __USE_WINAPI__
		Function CompareFunc(ByVal lParam1 As LPARAM, ByVal lParam2 As LPARAM, ByVal lParamSort As LPARAM) As Long
			Return 0
		End Function
	#endif
	
	Private Sub TreeListViewItems.Sort
		#ifdef __USE_WINAPI__
			If Parent AndAlso Parent->Handle Then
				'Parent->Perform LVM_SORTITEMS, 0, @CompareFunc
			End If
		#endif
	End Sub
	
	Private Function TreeListViewItems.IndexOf(ByRef FItem As TreeListViewItem Ptr) As Integer
		Return FItems.IndexOf(FItem)
	End Function
	
	Private Function TreeListViewItems.IndexOf(ByRef Caption As WString) As Integer
		For i As Integer = 0 To Count - 1
			If QTreeListViewItem(FItems.Items[i]).Text(0) = Caption Then
				Return i
			End If
		Next i
		Return -1
	End Function
	
	Private Function TreeListViewItems.Contains(ByRef Caption As WString) As Boolean
		Return IndexOf(Caption) <> -1
	End Function
	
	Private Sub TreeListViewItems.Clear
		If FParentItem = 0 Then
			#ifdef __USE_GTK__
				'If Parent AndAlso Cast(TreeListView Ptr, Parent)->TreeStore Then gtk_tree_store_clear(Cast(TreeListView Ptr, Parent)->TreeStore)
			#else
				If Parent AndAlso Parent->Handle Then SendMessage Parent->Handle, LVM_DELETEALLITEMS, 0, 0
			#endif
		End If
		For i As Integer = Count - 1 To 0 Step -1
			If Cast(TreeListViewItem Ptr, FItems.Items[i])->FDynamic Then _Delete(Cast(TreeListViewItem Ptr, FItems.Items[i]))
		Next i
		FItems.Clear
		If ParentItem Then ParentItem->State = 0
	End Sub
	
	Private Operator TreeListViewItems.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor TreeListViewItems
		'This.Clear
	End Constructor
	
	Private Destructor TreeListViewItems
		This.Clear
	End Destructor
	
	Private Property TreeListViewColumns.Count As Integer
		Return FColumns.Count
	End Property
	
	Private Property TreeListViewColumns.Count(Value As Integer)
	End Property
	
	Private Property TreeListViewColumns.Column(Index As Integer) As TreeListViewColumn Ptr
		Return QListViewColumn(FColumns.Items[Index])
	End Property
	
	Private Property TreeListViewColumns.Column(Index As Integer, Value As TreeListViewColumn Ptr)
		'QListViewColumn(FColumns.Items[Index]) = Value
	End Property
	
	#ifdef __USE_GTK__
		Private Sub TreeListViewColumns.Cell_Edited(renderer As GtkCellRendererText Ptr, path As gchar Ptr, new_text As gchar Ptr, user_data As Any Ptr)
			Dim As TreeListViewColumn Ptr PColumn = user_data
			If PColumn = 0 Then Exit Sub
			Dim As TreeListView Ptr lv = Cast(TreeListView Ptr, PColumn->Parent)
			If lv = 0 Then Exit Sub
			Dim As GtkTreeIter iter
			Dim As GtkTreeModel Ptr model = gtk_tree_view_get_model(GTK_TREE_VIEW(lv->Handle))
			If gtk_tree_model_get_iter(model, @iter, gtk_tree_path_new_from_string(path)) Then
				Dim Cancel As Boolean
				If lv->OnCellEdited Then lv->OnCellEdited(*lv->Designer, *lv, lv->Nodes.FindByIterUser_Data(iter.user_data), PColumn->Index, *new_text, Cancel)
				If Not Cancel Then
					lv->Nodes.FindByIterUser_Data(iter.user_data)->Text(PColumn->Index) = *new_text
					'gtk_tree_store_set(lv->TreeStore, @iter, PColumn->Index + 1, ToUtf8(*new_text), -1)
				End If
			End If
		End Sub
		
		Private Sub TreeListViewColumns.Cell_Editing(cell As GtkCellRenderer Ptr, editable As GtkCellEditable Ptr, path As Const gchar Ptr, user_data As Any Ptr)
			Dim As TreeListViewColumn Ptr PColumn = user_data
			If PColumn = 0 Then Exit Sub
			Dim As TreeListView Ptr lv = Cast(TreeListView Ptr, PColumn->Parent)
			If lv = 0 Then Exit Sub
			Dim As GtkTreeIter iter
			Dim As GtkTreeModel Ptr model = gtk_tree_view_get_model(GTK_TREE_VIEW(lv->Handle))
			Dim As TextBox txt
			If gtk_tree_model_get_iter(model, @iter, gtk_tree_path_new_from_string(path)) Then
				Dim Cancel As Boolean
				txt.Handle = Cast(GtkWidget Ptr, editable)
				If lv->OnCellEditing Then lv->OnCellEditing(*lv->Designer, *lv, lv->Nodes.FindByIterUser_Data(iter.user_data), PColumn->Index, @txt, Cancel)
				txt.Handle = 0
				If Cancel Then
					gtk_cell_editable_editing_done(editable)
				End If
				'If CellEditor <> 0 Then editable = gtk_cell_editable(CellEditor->Handle)
			End If
		End Sub
	#endif
	
	Private Function TreeListViewColumns.Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As ColumnFormat = cfLeft, ColEditable As Boolean = False) As TreeListViewColumn Ptr
		Dim As TreeListViewColumn Ptr PColumn
		Dim As Integer Index
		#ifndef __USE_GTK__
			Dim As LVCOLUMN lvc
		#endif
		PColumn = _New( TreeListViewColumn)
		FColumns.Add PColumn
		Index = FColumns.Count - 1
		With *PColumn
			.ImageIndex     = FImageIndex
			.Text        = FCaption
			.Index = Index
			.Width     = iWidth
			.Format = Format
		End With
		#ifdef __USE_GTK__
			If Parent Then
				With *Cast(TreeListView Ptr, Parent)
					If .ColumnTypes Then _DeleteSquareBrackets( .ColumnTypes)
					.ColumnTypes = _New( GType[Index + 2])
					For i As Integer = 0 To Index + 1
						.ColumnTypes[i] = G_TYPE_STRING
					Next i
				End With
				PColumn->Column = gtk_tree_view_column_new()
				PColumn->rendertext = gtk_cell_renderer_text_new()
				If ColEditable Then
					Dim As GValue bValue '= G_VALUE_INIT
					g_value_init_(@bValue, G_TYPE_BOOLEAN)
					g_value_set_boolean(@bValue, True)
					g_object_set_property(G_OBJECT(PColumn->rendertext), "editable", @bValue)
					g_object_set_property(G_OBJECT(PColumn->rendertext), "editable-set", @bValue)
					g_value_unset(@bValue)
					'Dim bTrue As gboolean = True
					'g_object_set(rendertext, "mode", GTK_CELL_RENDERER_MODE_EDITABLE, NULL)
					'g_object_set(gtk_cell_renderer_text(rendertext), "editable-set", true, NULL)
					'g_object_set(rendertext, "editable", bTrue, NULL)
				End If
				If Index = 0 Then
					Dim As GtkCellRenderer Ptr renderpixbuf = gtk_cell_renderer_pixbuf_new()
					gtk_tree_view_column_pack_start(PColumn->Column, renderpixbuf, False)
					gtk_tree_view_column_add_attribute(PColumn->Column, renderpixbuf, ToUtf8("icon_name"), 0)
				End If
				g_signal_connect(G_OBJECT(PColumn->rendertext), "edited", G_CALLBACK (@Cell_Edited), PColumn)
				g_signal_connect(G_OBJECT(PColumn->rendertext), "editing-started", G_CALLBACK (@Cell_Editing), PColumn)
				gtk_tree_view_column_pack_start(PColumn->Column, PColumn->rendertext, True)
				gtk_tree_view_column_add_attribute(PColumn->Column, PColumn->rendertext, ToUtf8("text"), Index + 1)
				gtk_tree_view_column_set_resizable(PColumn->Column, True)
				gtk_tree_view_column_set_title(PColumn->Column, ToUtf8(FCaption))
				gtk_tree_view_append_column(GTK_TREE_VIEW(Cast(TreeListView Ptr, Parent)->Handle), PColumn->Column)
				#ifdef __USE_GTK3__
					gtk_tree_view_column_set_fixed_width(PColumn->Column, Max(-1, iWidth))
				#else
					gtk_tree_view_column_set_fixed_width(PColumn->Column, Max(1, iWidth))
				#endif
			End If
		#else
			lvc.mask      =  LVCF_FMT Or LVCF_WIDTH Or LVCF_TEXT Or LVCF_SUBITEM
			lvc.fmt       =  Format
			lvc.cx		  = ScaleX(IIf(iWidth = -1, 50, iWidth))
			lvc.iImage   = PColumn->ImageIndex
			lvc.iSubItem = PColumn->Index
			lvc.pszText  = @FCaption
			lvc.cchTextMax = Len(FCaption)
		#endif
		If Parent Then
			PColumn->Parent = Parent
			#ifdef __USE_GTK__
				
			#else
				If Parent->Handle Then
					ListView_InsertColumn(Parent->Handle, PColumn->Index, @lvc)
				End If
			#endif
		End If
		Return PColumn
	End Function
	
	Private Sub TreeListViewColumns.Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer, Format As ColumnFormat = cfLeft)
		Dim As TreeListViewColumn Ptr PColumn
		#ifndef __USE_GTK__
			Dim As LVCOLUMN lvc
		#endif
		PColumn = _New( TreeListViewColumn)
		FColumns.Insert Index, PColumn
		With *PColumn
			.ImageIndex = FImageIndex
			.Text       = FCaption
			.Index      = FColumns.Count - 1
			.Width      = iWidth
			.Format     = Format
		End With
		#ifndef __USE_GTK__
			lvc.mask        =  LVCF_FMT Or LVCF_WIDTH Or LVCF_TEXT Or LVCF_SUBITEM
			lvc.fmt         =  Format
			lvc.cx          = 0
			lvc.iImage      = PColumn->ImageIndex
			lvc.iSubItem    = PColumn->Index
			lvc.pszText     = @FCaption
			lvc.cchTextMax  = Len(FCaption)
			If Parent Then
				PColumn->Parent = Parent
				If Parent->Handle Then
					ListView_InsertColumn(Parent->Handle, Index, @lvc)
					ListView_SetColumnWidth(Parent->Handle, Index, ScaleX(iWidth))
				End If
			End If
		#endif
	End Sub
	
	Private Sub TreeListViewColumns.Remove(Index As Integer)
		FColumns.Remove Index
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				SendMessage Parent->Handle, LVM_DELETECOLUMN, Cast(WPARAM, Index), 0
			End If
		#endif
	End Sub
	
	Private Function TreeListViewColumns.IndexOf(ByRef FColumn As TreeListViewColumn Ptr) As Integer
		Return FColumns.IndexOf(FColumn)
	End Function
	
	Private Sub TreeListViewColumns.Clear
		For i As Integer = Count -1 To 0 Step -1
			_Delete( @QTreeListViewColumn(FColumns.Items[i]))
			Remove i
		Next i
		FColumns.Clear
	End Sub
	
	Private Operator TreeListViewColumns.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor TreeListViewColumns
		This.Clear
	End Constructor
	
	Destructor TreeListViewColumns
		This.Clear
	End Destructor
	
	#ifndef ReadProperty_Off
		Private Function TreeListView.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "columnheaderhidden": Return @FColumnHeaderHidden
			Case "images": Return Images
			Case "gridlines": Return @FGridLines
			Case "multiselect": Return @FMultiSelect
			Case "singleclickactivate": Return @FSingleClickActivate
			Case "sortorder": Return @FSortStyle
			Case "stateimages": Return StateImages
			Case "tabindex": Return @FTabIndex
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function TreeListView.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "columnheaderhidden": This.ColumnHeaderHidden = QBoolean(Value)
				Case "images": This.Images = Value
				Case "gridlines": This.GridLines = QBoolean(Value)
				Case "multiselect": This.MultiSelect = QBoolean(Value)
				Case "singleclickactivate": This.SingleClickActivate = QBoolean(Value)
				Case "sortorder": This.SortOrder = *Cast(SortStyle Ptr, Value)
				Case "stateimages": This.StateImages = Value
				Case "tabindex": This.TabIndex = QInteger(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Property TreeListView.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property TreeListView.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property TreeListView.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property TreeListView.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Sub TreeListView.Init()
		#ifdef __USE_GTK__
			If gtk_tree_view_get_model(GTK_TREE_VIEW(widget)) = NULL Then
				gtk_tree_store_set_column_types(TreeStore, Columns.Count + 1, ColumnTypes)
				gtk_tree_view_set_model(GTK_TREE_VIEW(widget), GTK_TREE_MODEL(TreeStore))
				gtk_tree_view_set_enable_tree_lines(GTK_TREE_VIEW(widget), True)
			End If
		#endif
	End Sub
		
	Private Sub TreeListView.EnsureVisible(Index As Integer)
		#ifdef __USE_GTK__
			If GTK_IS_ICON_VIEW(widget) Then
				gtk_icon_view_select_path(GTK_ICON_VIEW(widget), gtk_tree_path_new_from_string(Trim(Str(Index))))
			Else
				If TreeSelection Then
					If Index > -1 AndAlso Index < Nodes.Count Then
						Dim As GtkTreeIter iter
						gtk_tree_model_get_iter_from_string(GTK_TREE_MODEL(TreeStore), @iter, Trim(Str(Index)))
						gtk_tree_view_scroll_to_cell(GTK_TREE_VIEW(widget), gtk_tree_model_get_path(GTK_TREE_MODEL(TreeStore), @iter), NULL, False, 0, 0)
					End If
				End If
			End If
		#elseif defined(__USE_WINAPI__)
			ListView_EnsureVisible(FHandle, Index, True)
		#endif
	End Sub
	
	Private Property TreeListView.OwnerData As Boolean
		Return FOwnerData
	End Property
	
	Private Property TreeListView.OwnerData(Value As Boolean)
		FOwnerData = Value
		#ifndef __USE_GTK__
			ChangeStyle LVS_OWNERDATA, Value
		#endif
	End Property
	
	Private Property TreeListView.OwnerDraw As Boolean
		Return FOwnerDraw
	End Property
	
	Private Property TreeListView.OwnerDraw(Value As Boolean)
		FOwnerDraw = Value
		#ifndef __USE_GTK__
			ChangeStyle LVS_OWNERDRAWFIXED, Value
		#endif
	End Property
	
	Private Property TreeListView.ColumnHeaderHidden As Boolean
		Return FColumnHeaderHidden
	End Property
	
	Private Property TreeListView.ColumnHeaderHidden(Value As Boolean)
		FColumnHeaderHidden = Value
		#ifdef __USE_GTK__
			gtk_tree_view_set_headers_visible(GTK_TREE_VIEW(widget), Not Value)
		#else
			ChangeStyle LVS_NOCOLUMNHEADER, Value
		#endif
	End Property
	
	Private Property TreeListView.GridLines As Boolean
		Return FGridLines
	End Property
	
	Private Property TreeListView.GridLines(Value As Boolean)
		FGridLines = Value
		#ifdef __USE_GTK__
			gtk_tree_view_set_grid_lines(GTK_TREE_VIEW(widget), IIf(Value, GTK_TREE_VIEW_GRID_LINES_BOTH, GTK_TREE_VIEW_GRID_LINES_NONE))
		#elseif defined(__USE_WINAPI__)
			ChangeLVExStyle LVS_EX_GRIDLINES, Value
		#endif
	End Property
	
	Private Property TreeListView.EditLabels As Boolean
		Return FEditLabels
	End Property
	
	Private Property TreeListView.EditLabels(Value As Boolean)
		FEditLabels = Value
		#ifdef __USE_GTK__
			'			If Columns.Count > 0 Then
			'				Columns.Column(0)->Editable = Value
			'			End If
		#else
			ChangeStyle LVS_EDITLABELS, Value
		#endif
	End Property
	
	Private Property TreeListView.MultiSelect As Boolean
		Return FMultiSelect
	End Property
	
	Private Property TreeListView.MultiSelect(Value As Boolean)
		FMultiSelect = Value
		#ifdef __USE_WINAPI__
			ChangeStyle LVS_SINGLESEL, Not Value
		#endif
	End Property
	
	Private Sub TreeListView.ChangeLVExStyle(iStyle As Integer, Value As Boolean)
		#ifdef __USE_WINAPI__
			If FHandle Then FLVExStyle = SendMessage(FHandle, LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0)
			If Value Then
				If ((FLVExStyle And iStyle) <> iStyle) Then FLVExStyle = FLVExStyle Or iStyle
			ElseIf ((FLVExStyle And iStyle) = iStyle) Then
				FLVExStyle = FLVExStyle And Not iStyle
			End If
			If FHandle Then SendMessage(FHandle, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, ByVal FLVExStyle)
		#endif
	End Sub
	
	Private Property TreeListView.SingleClickActivate As Boolean
		Return FSingleClickActivate
	End Property
	
	Private Property TreeListView.SingleClickActivate(Value As Boolean)
		FSingleClickActivate = Value
		#ifdef __USE_GTK__
			#ifdef __USE_GTK3__
				gtk_tree_view_set_activate_on_single_click(GTK_TREE_VIEW(widget), Value)
			#else
				
			#endif
		#else
			
		#endif
	End Property
	
	Private Property TreeListView.SelectedItem As TreeListViewItem Ptr
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			If gtk_tree_selection_get_selected(TreeSelection, NULL, @iter) Then
				Return Nodes.FindByIterUser_Data(iter.user_data)
			End If
		#else
			If Handle Then
				Dim As Integer item = ListView_GetNextItem(Handle, -1, LVNI_SELECTED)
				If item <> -1 Then Return GetTreeListViewItem(item)
			End If
		#endif
		Return 0
	End Property
	
	Private Property TreeListView.SelectedItemIndex As Integer
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			If gtk_tree_selection_get_selected(TreeSelection, NULL, @iter) Then
				Dim As TreeListViewItem Ptr lvi = Nodes.FindByIterUser_Data(iter.user_data)
				If lvi <> 0 Then Return lvi->Index
			End If
		#else
			If Handle Then
				Return ListView_GetNextItem(Handle, -1, LVNI_SELECTED)
			End If
		#endif
		Return -1
	End Property
	
	Private Property TreeListView.SelectedItemIndex(Value As Integer)
		#ifdef __USE_GTK__
			If TreeSelection Then
				If Value = -1 Then
					gtk_tree_selection_unselect_all(TreeSelection)
				ElseIf Value > -1 AndAlso Value < Nodes.Count Then
					gtk_tree_selection_select_iter(TreeSelection, @Nodes.Item(Value)->TreeIter)
					gtk_tree_view_scroll_to_cell(GTK_TREE_VIEW(widget), gtk_tree_model_get_path(GTK_TREE_MODEL(TreeStore), @Nodes.Item(Value)->TreeIter), NULL, False, 0, 0)
				End If
			End If
		#else
			If Handle Then
				ListView_SetItemState(Handle, Value, LVIS_FOCUSED Or LVIS_SELECTED, LVNI_SELECTED Or LVNI_FOCUSED)
				ListView_EnsureVisible(Handle, Value, True)
			End If
		#endif
	End Property
	
	Private Property TreeListView.SelectedItem(Value As TreeListViewItem Ptr)
		Value->SelectItem
	End Property
	
	Private Property TreeListView.SelectedColumn As TreeListViewColumn Ptr
		#ifndef __USE_GTK__
			If Handle Then
				Return Columns.Column(ListView_GetSelectedColumn(Handle))
			End If
		#endif
		Return 0
	End Property
	
	#ifndef __USE_GTK__
		Private Function TreeListView.GetTreeListViewItem(iItem As Integer) As TreeListViewItem Ptr
			If FOwnerData Then Return GetItemByVisibleIndex(iItem)
			Dim lvi As LVITEM
			lvi.mask = LVIF_PARAM
			lvi.iItem = iItem
			If ListView_GetItem(Handle, @lvi) Then
				Return Cast(TreeListViewItem Ptr, lvi.lParam)
			End If
			Return 0
		End Function
		
		Private Function TreeListView.GetTreeListViewItemByIndex(Node As TreeListViewItem Ptr, iItem As Integer, ByRef iCount As Integer) As TreeListViewItem Ptr
			Dim As TreeListViewItem Ptr Result
			If Not Node->IsExpanded Then Return 0
			For i As Integer = 0 To Node->Nodes.Count - 1
				If Not Node->Nodes.Item(i)->Visible Then Continue For
				iCount += 1
				If iItem = iCount Then Return Node->Nodes.Item(i)
				Result = GetTreeListViewItemByIndex(Node->Nodes.Item(i), iItem, iCount)
				If Result > 0 Then Return Result
			Next
			Return 0
		End Function
		
		Private Function TreeListView.GetItemByVisibleIndex(iItem As Integer) As TreeListViewItem Ptr
			Dim As Integer iCount = -1
			Dim As TreeListViewItem Ptr Result
			For i As Integer = 0 To Nodes.Count - 1
				If Not Nodes.Item(i)->Visible Then Continue For
				iCount += 1
				If iItem = iCount Then Return Nodes.Item(i)
				Result = GetTreeListViewItemByIndex(Nodes.Item(i), iItem, iCount)
				If Result > 0 Then Return Result
			Next
			Return 0
		End Function
	#endif
	
	Private Property TreeListView.SortColumn As TreeListViewColumn Ptr
		Return FSortColumn
	End Property
	
	Private Property TreeListView.SortColumn(Value As TreeListViewColumn Ptr)
		FSortColumn = Value
	End Property
	
	Private Property TreeListView.SortOrder As SortStyle
		Return FSortStyle
	End Property
	
	Private Property TreeListView.SortOrder(Value As SortStyle)
		FSortStyle = Value
		#ifndef __USE_GTK__
			Select Case FSortStyle
			Case SortStyle.ssNone
				ChangeStyle LVS_SORTASCENDING, False
				ChangeStyle LVS_SORTDESCENDING, False
			Case SortStyle.ssSortAscending
				ChangeStyle LVS_SORTDESCENDING, False
				ChangeStyle LVS_SORTASCENDING, True
			Case SortStyle.ssSortDescending
				ChangeStyle LVS_SORTASCENDING, False
				ChangeStyle LVS_SORTDESCENDING, True
			End Select
		#endif
	End Property
	
	Private Sub TreeListView.Sort
		
	End Sub
	
	Private Property TreeListView.SelectedColumn(Value As TreeListViewColumn Ptr)
		#ifndef __USE_GTK__
			If Handle Then ListView_SetSelectedColumn(Handle, Value->Index)
		#endif
	End Property
	
	Private Property TreeListView.ShowHint As Boolean
		Return FShowHint
	End Property
	
	Private Property TreeListView.ShowHint(Value As Boolean)
		FShowHint = Value
	End Property
	
	Private Sub TreeListView.WndProc(ByRef Message As Message)
	End Sub
	
	#ifdef __USE_WINAPI__
		Function TreeListView.EditControlProc(hDlg As HWND, uMsg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			Select Case uMsg
			Case WM_WINDOWPOSCHANGING
				Cast(WINDOWPOS Ptr, lParam)->x = Cast(Integer, GetProp(hDlg, "@@@Left"))
			End Select
			Return CallWindowProc(GetProp(hDlg, "@@@Proc"), hDlg, uMsg, wParam, lParam)
		End Function
		
		Private Sub TreeListView.SetDark(Value As Boolean)
			Base.SetDark Value
			If Value Then
				hHeader = ListView_GetHeader(FHandle)
				SetWindowTheme(hHeader, "DarkMode_ItemsView", nullptr) ' DarkMode
				SetWindowTheme(FHandle, "DarkMode_Explorer", nullptr) ' DarkMode
				AllowDarkModeForWindow(FHandle, g_darkModeEnabled)
				AllowDarkModeForWindow(hHeader, g_darkModeEnabled)
			Else
				hHeader = ListView_GetHeader(FHandle)
				SetWindowTheme(hHeader, NULL, NULL) ' DarkMode
				SetWindowTheme(FHandle, NULL, NULL) ' DarkMode
				AllowDarkModeForWindow(FHandle, g_darkModeEnabled)
				AllowDarkModeForWindow(hHeader, g_darkModeEnabled)
			End If
			'SendMessage FHandle, WM_THEMECHANGED, 0, 0
		End Sub
	#endif
	
	Private Sub TreeListView.ProcessMessage(ByRef Message As Message)
		'?message.msg, GetMessageName(message.msg)
		#ifdef __USE_GTK__
			Dim As GdkEvent Ptr e = Message.Event
			Select Case Message.Event->type
			Case GDK_MAP
				Init
			End Select
		#else
			Select Case Message.Msg
			Case WM_PAINT
				If g_darkModeSupported AndAlso g_darkModeEnabled AndAlso FDefaultBackColor = FBackColor Then
					If Not FDarkMode Then
						SetDark True
						'						FDarkMode = True
						'						hHeader = ListView_GetHeader(FHandle)
						'						SetWindowTheme(hHeader, "DarkMode_ItemsView", nullptr) ' DarkMode
						'						SetWindowTheme(FHandle, "DarkMode_Explorer", nullptr) ' DarkMode
						'						AllowDarkModeForWindow(FHandle, g_darkModeEnabled)
						'						AllowDarkModeForWindow(hHeader, g_darkModeEnabled)
					End If
				Else
					If FDarkMode Then
						SetDark False
						'						FDarkMode = False
						'						hHeader = ListView_GetHeader(FHandle)
						'						SetWindowTheme(hHeader, NULL, NULL) ' DarkMode
						'						SetWindowTheme(FHandle, NULL, NULL) ' DarkMode
						'						AllowDarkModeForWindow(FHandle, g_darkModeEnabled)
						'						AllowDarkModeForWindow(hHeader, g_darkModeEnabled)
					End If
				End If
				Message.Result = 0
			Case WM_DPICHANGED
				Base.ProcessMessage(Message)
				If Images Then Images->SetImageSize Images->ImageWidth, Images->ImageHeight, xdpi, ydpi
				If StateImages Then StateImages->SetImageSize StateImages->ImageWidth, StateImages->ImageHeight, xdpi, ydpi
				If Images AndAlso Images->Handle Then ListView_SetImageList(FHandle, CInt(Images->Handle), LVSIL_SMALL)
				If StateImages AndAlso StateImages->Handle Then ListView_SetImageList(FHandle, CInt(StateImages->Handle), LVSIL_STATE)
				FItemHeight = 0
				Dim As ..Rect rc
				GetWindowRect(FHandle, @rc)
				Dim As WINDOWPOS wp
				wp.hwnd = FHandle
				wp.cx = rc.Right
				wp.cy = rc.Bottom
				wp.flags = SWP_NOACTIVATE Or SWP_NOMOVE Or SWP_NOOWNERZORDER Or SWP_NOZORDER
				SendMessage(FHandle, WM_WINDOWPOSCHANGED, 0, Cast(LPARAM, @wp))
				For i As Integer = 0 To Columns.Count - 1
					Columns.Column(i)->xdpi = xdpi
					Columns.Column(i)->ydpi = ydpi
					Columns.Column(i)->Update
				Next
				Return
			Case WM_DESTROY
				If Images Then ListView_SetImageList(FHandle, 0, LVSIL_SMALL)
				If StateImages Then ListView_SetImageList(FHandle, 0, LVSIL_STATE)
			Case WM_NOTIFY
				If (Cast(LPNMHDR, Message.lParam)->code = NM_CUSTOMDRAW) Then
					Dim As LPNMCUSTOMDRAW nmcd = Cast(LPNMCUSTOMDRAW, Message.lParam)
					Select Case nmcd->dwDrawStage
					Case CDDS_PREPAINT
						Message.Result = CDRF_NOTIFYITEMDRAW
						Return
					Case CDDS_ITEMPREPAINT
						'Var info = Cast(SubclassInfo Ptr, dwRefData)
						If g_darkModeEnabled Then
							SetTextColor(nmcd->hdc, headerTextColor)
						End If
						Message.Result = CDRF_DODEFAULT
						Return
					End Select
				End If
			Case WM_THEMECHANGED
				If (g_darkModeSupported) Then
					Dim As HWND hHeader = ListView_GetHeader(Message.hWnd)
					
					AllowDarkModeForWindow(Message.hWnd, g_darkModeEnabled)
					AllowDarkModeForWindow(hHeader, g_darkModeEnabled)
					
					Dim As HTHEME hTheme '= OpenThemeData(nullptr, "ItemsView")
					'If (hTheme) Then
					'	Dim As COLORREF Color1
					'	If (SUCCEEDED(GetThemeColor(hTheme, 0, 0, TMT_TEXTCOLOR, @Color1))) Then
					If g_darkModeEnabled Then
						ListView_SetTextColor(Message.hWnd, darkTextColor) 'Color1)
					Else
						ListView_SetTextColor(Message.hWnd, Font.Color) 'Color1)
					End If
					'	End If
					'	If (SUCCEEDED(GetThemeColor(hTheme, 0, 0, TMT_FILLCOLOR, @Color1))) Then
					If g_darkModeEnabled Then
						ListView_SetTextBkColor(Message.hWnd, darkBkColor) 'Color1)
						ListView_SetBkColor(Message.hWnd, darkBkColor) 'Color1)
					Else
						ListView_SetTextBkColor(Message.hWnd, GetSysColor(COLOR_WINDOW)) 'Color1)
						ListView_SetBkColor(Message.hWnd, GetSysColor(COLOR_WINDOW)) 'Color1)
					End If
					'	End If
					'	CloseThemeData(hTheme)
					'End If
					
					hTheme = OpenThemeData(hHeader, "Header")
					If (hTheme) Then
						'Var info = reinterpret_cast<SubclassInfo*>(dwRefData);
						GetThemeColor(hTheme, HP_HEADERITEM, 0, TMT_TEXTCOLOR, @headerTextColor)
						CloseThemeData(hTheme)
					End If
					
					SendMessageW(hHeader, WM_THEMECHANGED, Message.wParam, Message.lParam)
					
					RedrawWindow(Message.hWnd, nullptr, nullptr, RDW_FRAME Or RDW_INVALIDATE)
				End If
			Case CM_DRAWITEM
				Dim lpdis As DRAWITEMSTRUCT Ptr
				Dim As Integer ItemID, State
				lpdis = Cast(DRAWITEMSTRUCT Ptr, Message.lParam)
				If OnDrawItem Then
					Canvas.SetHandle lpdis->hDC
					OnDrawItem(*Designer, This, GetTreeListViewItem(lpdis->itemID), lpdis->itemState, lpdis->itemAction, *Cast(My.Sys.Drawing.Rect Ptr, @lpdis->rcItem), Canvas)
					Canvas.UnSetHandle
					Message.Result = True
					Exit Sub
				End If
			Case CM_MEASUREITEM
				Dim As MEASUREITEMSTRUCT Ptr miStruct
				Dim As Integer ItemID
				miStruct = Cast(MEASUREITEMSTRUCT Ptr, Message.lParam)
				ItemID = Cast(Integer, miStruct->itemID)
				'If FOwnerDraw Then miStruct->itemHeight = ScaleY(17)
				If StateImages Then
					miStruct->itemHeight = ScaleY(StateImages->ImageHeight) + 1
					FItemHeight = 0
				End If
				If OnMeasureItem Then OnMeasureItem(*Designer, This, GetTreeListViewItem(ItemID), miStruct->itemWidth, miStruct->itemHeight)
			Case WM_SIZE
			Case WM_LBUTTONDOWN
				Dim lvhti As LVHITTESTINFO
				lvhti.pt.X = Message.lParamLo
				lvhti.pt.Y = Message.lParamHi
				If (ListView_HitTest(Handle, @lvhti) <> -1) Then
					Var tlvi = GetTreeListViewItem(lvhti.iItem)
					'If tlvi AndAlso tlvi->Nodes.Count > 0 Then
					If tlvi AndAlso tlvi->State > 0 Then
						Dim As ..Rect lpRect
						Dim As Integer sX16 = ScaleX(16)
						ListView_GetSubItemRect(FHandle, lvhti.iItem, 0, LVIR_BOUNDS, @lpRect)
						If lvhti.flags = LVHT_ONITEMSTATEICON OrElse (FOwnerDraw AndAlso lvhti.pt.X >= lpRect.Left + 3 + tlvi->Indent * sX16 AndAlso lvhti.pt.X <= lpRect.Left + 3 + sX16+ tlvi->Indent * sX16 AndAlso _
							lvhti.pt.Y >= lpRect.Top AndAlso lvhti.pt.Y <= lpRect.Bottom) Then
							If tlvi->IsExpanded Then
								tlvi->Collapse
							Else
								tlvi->Expand
							End If
							If FOwnerData Then Repaint
						End If
					End If
				End If
				ListView_SubItemHitTest(Handle, @lvhti)
				FPressedSubItem = lvhti.iSubItem
			Case WM_KEYDOWN
				Dim iIndent As Integer
				Var tlvi = SelectedItem
				If tlvi Then
					Select Case LoWord(Message.wParam)
					Case VK_LEFT, VK_BACK
						If tlvi->IsExpanded Then
							tlvi->Collapse
							If FOwnerData Then Repaint
						ElseIf tlvi->ParentItem Then
							tlvi->ParentItem->SelectItem
						End If
					Case VK_RIGHT
						'If tlvi->Nodes.Count > 0 Then
						If tlvi->State > 0 Then
							If tlvi->IsExpanded Then
								If tlvi->Nodes.Count > 0 Then tlvi->Nodes.Item(0)->SelectItem
							Else
								tlvi->Expand
								If FOwnerData Then Repaint
							End If
						End If
					End Select
				End If
			Case CM_NOTIFY
				Dim lvp As NMLISTVIEW Ptr = Cast(NMLISTVIEW Ptr, Message.lParam)
				Select Case lvp->hdr.code
				Case NM_CLICK: If OnItemClick Then OnItemClick(*Designer, This, GetTreeListViewItem(lvp->iItem))
				Case NM_DBLCLK: If OnItemDblClick Then OnItemDblClick(*Designer, This, GetTreeListViewItem(lvp->iItem))
				Case NM_KEYDOWN:
					Dim nmk As NMKEY Ptr = Cast(NMKEY Ptr, Message.lParam)
					If OnItemKeyDown Then OnItemKeyDown(*Designer, This, GetTreeListViewItem(lvp->iItem))
				Case NM_CUSTOMDRAW
					If (g_darkModeSupported AndAlso g_darkModeEnabled) AndAlso FGridLines Then
						Dim As LPNMCUSTOMDRAW nmcd = Cast(LPNMCUSTOMDRAW, Message.lParam)
						Select Case nmcd->dwDrawStage
						Case CDDS_PREPAINT
							Message.Result = CDRF_NOTIFYPOSTPAINT
							Return
						Case CDDS_POSTPAINT
							Dim As HPEN GridLinesPen = CreatePen(PS_SOLID, 1, darkHlBkColor)
							Dim As HPEN PrevPen = SelectObject(nmcd->hdc, GridLinesPen)
							Dim As Integer Widths, Heights
							Dim As SCROLLINFO sif
							sif.cbSize = SizeOf(sif)
							sif.fMask  = SIF_POS
							GetScrollInfo(FHandle, SB_HORZ, @sif)
							Widths -= sif.nPos
							Dim lvc As LVCOLUMN
							For i As Integer = 0 To Columns.Count - 1
								lvc.mask = LVCF_WIDTH Or LVCF_SUBITEM
								lvc.iSubItem = i
								ListView_GetColumn(FHandle, i, @lvc)
								Widths += lvc.cx
								MoveToEx nmcd->hdc, Widths, 0, 0
								LineTo nmcd->hdc, Widths, ScaleY(This.Height)
							Next i
							Dim As HWND hHeader = ListView_GetHeader(FHandle)
							Dim As ..Rect R
							GetWindowRect(hHeader, @R)
							Heights = R.Bottom - R.Top - 1
							Dim rc As ..Rect
							If ListView_GetItemCount(FHandle) = 0 Then
								If FItemHeight = 0 Then
									Dim As LVITEM lvi
									lvi.mask = LVIF_PARAM
									lvi.lParam = 0
									ListView_InsertItem(FHandle, @lvi)
									ListView_GetItemRect FHandle, 0, @rc, LVIR_BOUNDS
									ListView_DeleteItem(FHandle, 0)
									FItemHeight = rc.Bottom - rc.Top
								End If
							Else
								ListView_GetItemRect FHandle, 0, @rc, LVIR_BOUNDS
								FItemHeight = rc.Bottom - rc.Top
							End If
							For i As Integer = 0 To ListView_GetCountPerPage(FHandle)
								Heights += FItemHeight '17
								MoveToEx nmcd->hdc, 0, Heights, 0
								LineTo nmcd->hdc, ScaleX(This.Width), Heights
							Next i
							SelectObject(nmcd->hdc, PrevPen)
							DeleteObject GridLinesPen
							Message.Result = CDRF_DODEFAULT
							Return
						End Select
					End If
				Case LVN_ITEMACTIVATE: If OnItemActivate Then OnItemActivate(*Designer, This, GetTreeListViewItem(lvp->iItem))
				Case LVN_BEGINSCROLL: If OnBeginScroll Then OnBeginScroll(*Designer, This)
				Case LVN_ENDSCROLL: If OnEndScroll Then OnEndScroll(*Designer, This)
				Case LVN_ITEMCHANGED: If OnSelectedItemChanged Then OnSelectedItemChanged(*Designer, This, GetTreeListViewItem(lvp->iItem))
				Case HDN_ITEMCHANGED:
				Case LVN_BEGINLABELEDIT
					If FPressedSubItem < Columns.Count AndAlso Not Columns.Column(FPressedSubItem)->Editable Then Message.Result = -1: Exit Sub
					If FPressedSubItem >= Columns.Count Then Message.Result = -1: Exit Sub
					Dim lvp1 As NMLVDISPINFO Ptr = Cast(NMLVDISPINFO Ptr, Message.lParam)
					Dim bCancel As Boolean
					Dim As TextBox txt
					txt.Handle = Cast(HWND, SendMessage(FHandle, LVM_GETEDITCONTROL, 0, 0))
					If FPressedSubItem <> 0 Then
						If GetWindowLongPtr(txt.Handle, GWLP_WNDPROC) <> @EditControlProc Then
							SetProp(txt.Handle, "@@@Proc", Cast(..HANDLE, SetWindowLongPtr(txt.Handle, GWLP_WNDPROC, CInt(@EditControlProc))))
						End If
						Dim As ..Rect lpRect
						ListView_GetSubItemRect(FHandle, lvp1->item.iItem, FPressedSubItem, LVIR_BOUNDS, @lpRect)
						SetProp(txt.Handle, "@@@Left", Cast(..HANDLE, Cast(Integer, lpRect.Left)))
						txt.Text = GetTreeListViewItem(lvp1->item.iItem)->Text(FPressedSubItem)
					End If
					If OnCellEditing Then OnCellEditing(*Designer, This, GetTreeListViewItem(lvp1->item.iItem), FPressedSubItem, @txt, bCancel)
					txt.Handle = 0
					If bCancel Then Message.Result = -1: Exit Sub
				Case LVN_ENDLABELEDIT
					Dim lvp1 As NMLVDISPINFO Ptr = Cast(NMLVDISPINFO Ptr, Message.lParam)
					If lvp1->item.pszText <> 0 Then
						Dim bCancel As Boolean
						If OnCellEdited Then OnCellEdited(*Designer, This, GetTreeListViewItem(lvp1->item.iItem), FPressedSubItem, *lvp1->item.pszText, bCancel)
						If bCancel Then
							Message.Result = 0
						Else
							GetTreeListViewItem(lvp1->item.iItem)->Text(FPressedSubItem) = *lvp1->item.pszText
							If FPressedSubItem > 0 Then
								Message.Result = 0
							Else
								Message.Result = -1
							End If
							Exit Sub
						End If
					End If
				Case LVN_SETDISPINFO
					If FOwnerData Then
						Dim lpdi As NMLVDISPINFO Ptr = Cast(NMLVDISPINFO Ptr, Message.lParam)
					End If
				Case LVN_GETDISPINFO
					If FOwnerData Then
						Dim lpdi As NMLVDISPINFO Ptr = Cast(NMLVDISPINFO Ptr, Message.lParam)
						If lpdi->item.iItem >= 0 Then
							Dim As Integer tCol = lpdi->item.iSubItem
							Dim As Integer tRow = lpdi->item.iItem
							If OnGetDisplayInfo Then 
								Dim As WString * 255 NewText
								OnGetDisplayInfo(*Designer, This, NewText, tRow, tCol, lpdi->item.mask)
							Else
								Dim As TreeListViewItem Ptr Result = GetItemByVisibleIndex(tRow)
								If Result > 0 Then
									'Select Case lpdi->item.mask
									'Case LVIF_TEXT
										lpdi->item.pszText = @Result->Text(tCol)
										lpdi->item.cchTextMax = Len(Result->Text(tCol))
									'Case LVIF_IMAGE
										lpdi->item.iImage = Result->ImageIndex
									'Case LVIF_INDENT
										lpdi->item.iIndent = Result->Indent
									'Case LVIF_PARAM
										lpdi->item.lParam = Result->Handle
									'Case LVIF_STATE
										lpdi->item.state = INDEXTOSTATEIMAGEMASK(Result->State)
										lpdi->item.stateMask = LVIS_STATEIMAGEMASK
									'End Select
								End If
							End If
						End If
					End If
				Case LVN_ODCACHEHINT
					If FOwnerData Then
						Dim pCacheHint As NMLVCACHEHINT Ptr = Cast(NMLVCACHEHINT  Ptr, Message.lParam)
						If OnCacheHint Then OnCacheHint(*Designer, This, pCacheHint->iFrom, pCacheHint->iTo)
					End If
				Case LVN_ODFINDITEM
				Case LVN_ODSTATECHANGED
					
				End Select
			Case WM_NOTIFY
				Select Case Message.wParam
				Case LVN_ENDSCROLL
				Case LVN_ENDSCROLL
				End Select
			Case CM_COMMAND
				Select Case Message.wParam
				Case LVN_ITEMACTIVATE
				Case LVN_KEYDOWN
				Case LVN_ITEMCHANGING
				Case LVN_ITEMCHANGED
				Case LVN_INSERTITEM
				Case LVN_DELETEITEM
				Case LVN_DELETEALLITEMS
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
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	#ifndef __USE_GTK__
		Private Sub TreeListView.HandleIsDestroyed(ByRef Sender As Control)
		End Sub
		
		Private Sub TreeListView.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QTreeListView(Sender.Child)
					If .Images Then
						.Images->ParentWindow = @Sender
						If .Images->Handle Then ListView_SetImageList(.FHandle, CInt(.Images->Handle), LVSIL_SMALL)
					End If
					If .StateImages Then
						.StateImages->ParentWindow = @Sender
						If .StateImages->Handle Then ListView_SetImageList(.FHandle, CInt(.StateImages->Handle), LVSIL_STATE)
					End If
					Dim lvStyle As Integer
					lvStyle = SendMessage(.FHandle, LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0)
					lvStyle = lvStyle Or .FLVExStyle
					SendMessage(.FHandle, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, ByVal lvStyle)
					For i As Integer = 0 To .Columns.Count - 1
						Dim lvc As LVCOLUMN
						lvc.mask      =  LVCF_FMT Or LVCF_WIDTH Or LVCF_TEXT Or LVCF_SUBITEM
						lvc.fmt       =  .Columns.Column(i)->Format
						lvc.cx=0
						lvc.pszText              = @.Columns.Column(i)->Text
						lvc.cchTextMax           = Len(.Columns.Column(i)->Text)
						lvc.iImage             = .Columns.Column(i)->ImageIndex
						lvc.iSubItem         = i
						Var iWidth = .Columns.Column(i)->Width
						ListView_InsertColumn(.FHandle, i, @lvc)
						ListView_SetColumnWidth(.FHandle, i, .ScaleX(iWidth))
					Next i
					For i As Integer = 0 To .Nodes.Count -1
						Dim lvi As LVITEM
						lvi.mask = LVIF_TEXT Or LVIF_IMAGE Or LVIF_STATE Or LVIF_INDENT Or LVIF_PARAM
						lvi.pszText             = @.Nodes.Item(i)->Text(0)
						lvi.cchTextMax          = Len(.Nodes.Item(i)->Text(0))
						lvi.iItem               = i
						lvi.iSubItem            = 0
						lvi.iImage              = .Nodes.Item(i)->ImageIndex
						lvi.state              = INDEXTOSTATEIMAGEMASK(.Nodes.Item(i)->State)
						lvi.stateMask           = LVIS_STATEIMAGEMASK
						lvi.iIndent             = .Nodes.Item(i)->Indent
						lvi.lParam              = Cast(LPARAM, .Nodes.Item(i))
						ListView_InsertItem(.FHandle, @lvi)
						For j As Integer = 0 To .Columns.Count - 1
							Dim As LVITEM lvi1
							lvi1.mask = LVIF_TEXT
							lvi1.iItem = i
							lvi1.iSubItem   = j
							lvi1.pszText    = @.Nodes.Item(i)->Text(j)
							lvi1.cchTextMax = Len(.Nodes.Item(i)->Text(j))
							ListView_SetItem(.Handle, @lvi1)
						Next j
					Next i
				End With
			End If
		End Sub
	#endif
	
	Private Operator TreeListView.Cast As Control Ptr
		Return @This
	End Operator
	
	#ifdef __USE_GTK__
		Private Sub TreeListView.TreeListView_RowActivated(tree_view As GtkTreeView Ptr, path As GtkTreePath Ptr, column As GtkTreeViewColumn Ptr, user_data As Any Ptr)
			Dim As TreeListView Ptr lv = Cast(Any Ptr, user_data)
			If lv Then
				Dim As GtkTreeModel Ptr model
				Dim As GtkTreeIter iter
				model = gtk_tree_view_get_model(tree_view)
				
				If gtk_tree_model_get_iter(model, @iter, path) Then
					If lv->OnItemActivate Then lv->OnItemActivate(*lv->Designer, *lv, lv->Nodes.FindByIterUser_Data(iter.user_data))
				End If
			End If
		End Sub
		
		Private Sub TreeListView.TreeListView_SelectionChanged(selection As GtkTreeSelection Ptr, user_data As Any Ptr)
			Dim As TreeListView Ptr lv = Cast(Any Ptr, user_data)
			If lv Then
				Dim As GtkTreeIter iter
				Dim As GtkTreeModel Ptr model
				If gtk_tree_selection_get_selected(selection, @model, @iter) Then
					If lv->OnSelectedItemChanged Then lv->OnSelectedItemChanged(*lv->Designer, *lv, lv->Nodes.FindByIterUser_Data(iter.user_data))
				End If
			End If
		End Sub
		
		Private Sub TreeListView.TreeListView_Map(widget As GtkWidget Ptr, user_data As Any Ptr)
			Dim As TreeListView Ptr lv = user_data
			lv->Init
		End Sub
		
		Private Function TreeListView.TreeListView_TestExpandRow(tree_view As GtkTreeView Ptr, iter As GtkTreeIter Ptr, path As GtkTreePath Ptr, user_data As Any Ptr) As Boolean
			Dim As TreeListView Ptr lv = user_data
			If lv Then
				Dim As GtkTreeModel Ptr model
				model = gtk_tree_view_get_model(tree_view)
				If lv->OnItemExpanding Then lv->OnItemExpanding(*lv->Designer, *lv, lv->Nodes.FindByIterUser_Data(iter->user_data))
			End If
			Return False
		End Function
		
	#endif
	
	Private Sub TreeListView.CollapseAll
		#ifdef __USE_GTK__
			gtk_tree_view_collapse_all(GTK_TREE_VIEW(widget))
		#else
			For i As Integer = 0 To Nodes.Count - 1
				Nodes.Item(i)->Collapse
			Next
		#endif
	End Sub
	
	Private Sub TreeListView.ExpandAll
		#ifdef __USE_GTK__
			gtk_tree_view_expand_all(GTK_TREE_VIEW(widget))
		#else
			For i As Integer = 0 To Nodes.Count - 1
				Nodes.Item(i)->Expand
			Next
		#endif
	End Sub
	
	#ifdef __USE_GTK__
		Private Sub TreeListView.TreeListView_Scroll(self As GtkAdjustment Ptr, user_data As Any Ptr)
			Dim As TreeListView Ptr lv = user_data
			If lv->OnEndScroll Then lv->OnEndScroll(*lv->Designer, *lv)
		End Sub
	#endif
	
	Private Constructor TreeListView
		#ifdef __USE_GTK__
			TreeStore = gtk_tree_store_new(1, G_TYPE_STRING)
			scrolledwidget = gtk_scrolled_window_new(NULL, NULL)
			gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolledwidget), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
			'widget = gtk_tree_view_new_with_model(gtk_tree_model(ListStore))
			widget = gtk_tree_view_new()
			gtk_container_add(GTK_CONTAINER(scrolledwidget), widget)
			TreeSelection = gtk_tree_view_get_selection(GTK_TREE_VIEW(widget))
			#ifdef __USE_GTK3__
				g_signal_connect(gtk_scrollable_get_hadjustment(GTK_SCROLLABLE(widget)), "value-changed", G_CALLBACK(@TreeListView_Scroll), @This)
				g_signal_connect(gtk_scrollable_get_vadjustment(GTK_SCROLLABLE(widget)), "value-changed", G_CALLBACK(@TreeListView_Scroll), @This)
			#else
				g_signal_connect(gtk_tree_view_get_hadjustment(GTK_TREE_VIEW(widget)), "value-changed", G_CALLBACK(@TreeListView_Scroll), @This)
				g_signal_connect(gtk_tree_view_get_vadjustment(GTK_TREE_VIEW(widget)), "value-changed", G_CALLBACK(@TreeListView_Scroll), @This)
			#endif
			g_signal_connect(GTK_TREE_VIEW(widget), "map", G_CALLBACK(@TreeListView_Map), @This)
			g_signal_connect(GTK_TREE_VIEW(widget), "row-activated", G_CALLBACK(@TreeListView_RowActivated), @This)
			g_signal_connect(GTK_TREE_VIEW(widget), "test-expand-row", G_CALLBACK(@TreeListView_TestExpandRow), @This)
			g_signal_connect(G_OBJECT(TreeSelection), "changed", G_CALLBACK (@TreeListView_SelectionChanged), @This)
			gtk_tree_view_set_enable_tree_lines(GTK_TREE_VIEW(widget), True)
			gtk_tree_view_set_grid_lines(GTK_TREE_VIEW(widget), GTK_TREE_VIEW_GRID_LINES_BOTH)
			ColumnTypes = _New( GType[1])
			ColumnTypes[0] = G_TYPE_STRING
			This.RegisterClass "TreeListView", @This
		#endif
		'Nodes.Clear
		Nodes.Parent = @This
		Columns.Parent = @This
		DoubleBuffered = True
		FEnabled = True
		FGridLines = True
		FVisible = True
		FTabIndex          = -1
		FTabStop = True
		With This
			.Child             = @This
			#ifndef __USE_GTK__
				.OnHandleIsAllocated = @HandleIsAllocated
				.OnHandleIsDestroyed = @HandleIsDestroyed
				.RegisterClass "TreeListView", WC_LISTVIEW
				.ChildProc         = @WndProc
				.ExStyle           = WS_EX_CLIENTEDGE
				.FLVExStyle        = LVS_EX_FULLROWSELECT Or LVS_EX_GRIDLINES Or LVS_EX_DOUBLEBUFFER
				.Style             = WS_CHILD Or WS_TABSTOP Or WS_VISIBLE Or LVS_REPORT Or LVS_ICON Or LVS_SINGLESEL Or LVS_SHOWSELALWAYS
				WLet(FClassAncestor, WC_LISTVIEW)
			#endif
			WLet(FClassName, "TreeListView")
			.Width             = 121
			.Height            = 121
		End With
	End Constructor
	
	Private Destructor TreeListView
		'Nodes.Clear
		'Columns.Clear
		#ifndef __USE_GTK__
			UnregisterClass "TreeListView",GetModuleHandle(NULL)
		#else
			If ColumnTypes Then _DeleteSquareBrackets( ColumnTypes)
		#endif
	End Destructor
End Namespace
