'################################################################################
'#  TreeView.bi                                                                 #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#include once "TreeView.bi"
#ifndef __USE_GTK__
	#include once "win\commctrl.bi"
#endif

Namespace My.Sys.Forms
	Sub TreeNode.SelectItem
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->widget Then gtk_tree_selection_select_iter(Cast(TreeView Ptr, Parent)->TreeSelection, @TreeIter)
		#else
			If Parent AndAlso Parent->Handle Then TreeView_Select(Parent->Handle, Handle, TVGN_CARET)
		#endif
	End Sub
	
	Sub TreeNode.Collapse
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->widget AndAlso Cast(TreeView Ptr, Parent)->TreeStore Then
				Dim As GtkTreePath Ptr TreePath = gtk_tree_path_new_from_string(gtk_tree_model_get_string_from_iter(GTK_Tree_model(Cast(TreeView Ptr, Parent)->TreeStore), @TreeIter))
				gtk_tree_view_collapse_row(gtk_tree_view(Parent->widget), TreePath)
				gtk_tree_path_free(TreePath)
			End If
		#else
			If Parent AndAlso Parent->Handle Then TreeView_Expand(Parent->Handle, Handle, TVE_EXPAND)
		#endif
	End Sub
	
	Sub TreeNode.Expand
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->widget AndAlso Cast(TreeView Ptr, Parent)->TreeStore Then
				Dim As GtkTreePath Ptr TreePath = gtk_tree_path_new_from_string(gtk_tree_model_get_string_from_iter(GTK_Tree_model(Cast(TreeView Ptr, Parent)->TreeStore), @TreeIter))
				gtk_tree_view_expand_row(gtk_tree_view(Parent->widget), TreePath, False)
				gtk_tree_path_free(TreePath)
			End If
		#else
			If Parent AndAlso Parent->Handle Then TreeView_Expand(Parent->Handle, Handle, TVE_EXPAND)
		#endif
	End Sub
	
	Function TreeNode.IsExpanded As Boolean
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->widget AndAlso Cast(TreeView Ptr, Parent)->TreeStore Then
				Dim As GtkTreePath Ptr TreePath = gtk_tree_path_new_from_string(gtk_tree_model_get_string_from_iter(GTK_Tree_model(Cast(TreeView Ptr, Parent)->TreeStore), @TreeIter))
				Var bResult = gtk_tree_view_row_expanded(gtk_tree_view(Parent->widget), TreePath)
				gtk_tree_path_free(TreePath)
				Return bResult
			End If
		#else
			If Parent AndAlso Parent->Handle Then Return TreeView_GetItemState(Parent->Handle, Handle, TVIS_EXPANDED)
		#endif
	End Function
	
	Property TreeNode.Bold As Boolean
		#ifdef __USE_GTK__
			Return  FBold
		#else
			If Parent AndAlso Parent->Handle Then 
				FBold = TreeView_GetItemState(Parent->Handle, Handle, TVIS_BOLD)
				Return FBold
			End If
		#endif
	End Property
	
	Property TreeNode.Bold(Value As Boolean)
		FBold = Value
		#ifdef __USE_GTK__
		#else
			If Parent AndAlso Parent->Handle Then
				TreeView_SetItemState(Parent->Handle, Handle, IIf(Value, TVIS_BOLD, 0), TVIS_BOLD)
			End If
		#endif
	End Property
	
	Function TreeNode.Index As Integer
		If FParentNode <> 0 Then
			Return FParentNode->Nodes.IndexOf(@This)
		ElseIf Parent <> 0 Then
			Return Cast(TreeView Ptr, Parent)->Nodes.IndexOf(@This)
		Else
			Return -1
		End If
	End Function
	
	Function TreeNode.ToString ByRef As WString
		Return This.Name
	End Function
	
	Property TreeNode.Text ByRef As WString
		Return *FText.vptr
	End Property
	
	Property TreeNode.Text(ByRef Value As WString)
		FText = Value
		#ifdef __USE_GTK__
			If Parent AndAlso Cast(TreeView Ptr, Parent)->TreeStore Then
				gtk_tree_store_set(Cast(TreeView Ptr, Parent)->TreeStore, @TreeIter, 1, ToUTF8(Value), -1)
			EndIf
		#else
			If Parent AndAlso Parent->Handle Then
				Dim tvi As TVITEM
				'tvi.mask = TVIF_HANDLE
				'TreeView_GetItem(Parent->Handle, @tvi)
				tvi.mask = TVIF_TEXT
				tvi.hItem = Handle
				tvi.pszText = FText.vptr
				tvi.cchTextMax = Len(FText)
				TreeView_SetItem(Parent->Handle, @tvi)
			End If
		#endif
	End Property
	
	Property TreeNode.IsUpdated As Boolean
		Return FIsUpdated
	End Property
	
	Property TreeNode.IsUpdated(Value As Boolean)
		FIsUpdated = Value
	End Property
	
	Property TreeNode.Checked As Boolean
		Return FChecked
	End Property
	
	Property TreeNode.Checked(Value As Boolean)
		FChecked = Value
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
			#ifdef __USE_GTK__
			#else
				If Parent AndAlso Parent->Handle Then
					Dim tvi As TVITEM
					tvi.mask = TVIF_IMAGE
					tvi.hItem = Handle
					tvi.iImage             = FImageIndex
					TreeView_SetItem(Parent->Handle, @tvi)
				End If
			#endif
		End If
	End Property
	
	Property TreeNode.ImageKey ByRef As WString
		Return WGet(FImageKey)
	End Property
	
	Property TreeNode.ImageKey(ByRef Value As WString)
		If Value <> *FImageKey Then
			WLet FImageKey, Value
			#ifdef __USE_GTK__
				If Parent AndAlso Cast(TreeView Ptr, Parent)->TreeStore Then
					gtk_tree_store_set(Cast(TreeView Ptr, Parent)->TreeStore, @TreeIter, 0, ToUTF8(Value), -1)
				EndIf
			#else
				If Parent AndAlso Parent->Handle Then
					FImageIndex = Cast(TreeView Ptr, Parent)->Images->IndexOf(*FImageKey)
					Dim tvi As TVITEM
					tvi.mask = TVIF_IMAGE
					tvi.hItem = Handle
					tvi.iImage             = FImageIndex
					TreeView_SetItem(Parent->Handle, @tvi)
				End If
			#endif
		End If
	End Property
	
	Property TreeNode.SelectedImageIndex As Integer
		Return FImageIndex
	End Property
	
	Property TreeNode.SelectedImageIndex(Value As Integer)
		FSelectedImageIndex = Value
		#ifdef __USE_GTK__
		#else
			If Parent AndAlso Parent->Handle Then
				Dim tvi As TVITEM
				tvi.mask = TVIF_SELECTEDIMAGE
				tvi.hItem = Handle
				tvi.iSelectedImage   = FSelectedImageIndex
				TreeView_SetItem(Parent->Handle, @tvi)
			End If
		#endif
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
		#ifdef __USE_GTK__
		#else
			If Parent AndAlso Parent->Handle Then
				FSelectedImageIndex = Cast(TreeView Ptr, Parent)->Images->IndexOf(*FSelectedImageKey)
				Dim tvi As TVITEM
				tvi.mask = TVIF_SELECTEDIMAGE
				tvi.hItem = Handle
				tvi.iSelectedImage = FSelectedImageIndex
				TreeView_SetItem(Parent->Handle, @tvi)
			End If
		#endif
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
		FText = "" 'CAllocate(0)
		FVisible    = 1
		Text    = ""
		Hint       = ""
		FImageIndex = -1
		FSelectedImageIndex = -1
	End Constructor
	
	Destructor TreeNode
		Nodes.Clear
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->widget Then
				gtk_tree_store_remove(Cast(TreeView Ptr, Parent)->TreeStore, @This.TreeIter)
			End If
		#else
			If Parent AndAlso Parent->Handle Then
				TreeView_DeleteItem(Parent->Handle, This.Handle)
			End If
		#endif
		WDeAllocate FHint
		'WDeAllocate FText
		WDeAllocate FImageKey
		WDeAllocate FSelectedImageKey
	End Destructor
	
	Constructor TreeNodeCollection
		This.Clear
	End Constructor
	
	Destructor TreeNodeCollection
		This.Clear
	End Destructor
	
	#ifdef __USE_GTK__
		Function TreeNodeCollection.FindByIterUser_Data(User_Data As Any Ptr) As TreeNode Ptr
			If ParentNode AndAlso ParentNode->TreeIter.User_Data = User_Data Then Return ParentNode
			For i As Integer = 0 To Count - 1
				PNode = Item(i)->Nodes.FindByIterUser_Data(User_Data)
				If PNode <> 0 Then Return PNode
			Next i
			Return 0
		End Function
	#else
		Function TreeNodeCollection.FindByHandle(hti As HTREEItem) As TreeNode Ptr
			If ParentNode AndAlso ParentNode->Handle = hti Then Return ParentNode
			For i As Integer = 0 To Count - 1
				PNode = Item(i)->Nodes.FindByHandle(hti)
				If PNode <> 0 Then Return PNode
			Next i
			Return 0
		End Function
	#endif
	
	Property TreeNodeCollection.Count As Integer
		Return FNodes.Count
	End Property
	
	Property TreeNodeCollection.Count(Value As Integer)
	End Property
	
	Property TreeNodeCollection.Item(Index As Integer) As TreeNode Ptr
		Return Cast(TreeNode Ptr, FNodes.Items[Index])
	End Property
	
	Property TreeNodeCollection.Item(Index As Integer, Value As TreeNode Ptr)
		'QTreeNode(FNodes.Items[Index]) = Value
		FNodes.Items[Index] = Value 'David Change
	End Property
	
	Function TreeNodeCollection.Add(ByRef FText As WString = "", ByRef FKey As WString = "", ByRef FHint As WString = "", FImageIndex As Integer = -1, FSelectedImageIndex As Integer = -1, bSorted As Boolean = False) As PTreeNode
		PNode = New TreeNode
		Dim iIndex As Integer = -1
		If Cast(TreeView Ptr, Parent)->Sorted Or bSorted Then
			For i As Integer = 0 To FNodes.Count - 1
				If LCase(Item(i)->Text) > LCase(FText) Then
					iIndex = i
					Exit For
				End If
			Next
		End If
		If iIndex = -1 Then FNodes.Add PNode Else FNodes.Insert iIndex, PNode
		With *PNode
			.Text         = FText
			.Name         = FKey
			.ImageIndex     = FImageIndex
			.SelectedImageIndex     = FSelectedImageIndex
			.Hint           = FHint
			.Parent         = Parent
			.Nodes.Parent         = Parent
			.ParentNode        = Cast(TreeNode Ptr, ParentNode)
			#ifdef __USE_GTK__
				If Parent AndAlso Cast(TreeView Ptr, Parent)->TreeStore Then
					If .ParentNode Then
						gtk_tree_store_insert(Cast(TreeView Ptr, Parent)->TreeStore, @.TreeIter, @.ParentNode->TreeIter, iIndex)
					Else
						gtk_tree_store_insert(Cast(TreeView Ptr, Parent)->TreeStore, @.TreeIter, NULL, iIndex)
					End If
					gtk_tree_store_set(Cast(TreeView Ptr, Parent)->TreeStore, @.TreeIter, 1, ToUTF8(FText), -1)
				EndIf
			#else
				Dim As TVINSERTSTRUCT tvis
				If Parent AndAlso Parent->Handle Then
					tvis.Item.Mask = TVIF_TEXT Or TVIF_IMAGE Or TVIF_SELECTEDIMAGE
					tvis.item.pszText              = @Ftext
					tvis.item.cchTextMax           = Len(Ftext)
					tvis.item.iImage             = FImageIndex
					tvis.item.iSelectedImage     = FSelectedImageIndex
					tvis.hInsertAfter            = IIf(Cast(TreeView Ptr, Parent)->Sorted Or bSorted, TVI_SORT, 0)
					'tvis.hInsertAfter            = 0
					If .ParentNode Then tvis.hParent               = .ParentNode->Handle
					.Handle        = TreeView_InsertItem(Parent->Handle, @tvis)
				End If
			#endif
		End With
		Return PNode
	End Function
	
	Function TreeNodeCollection.Add(ByRef FText As WString = "", ByRef FKey As WString = "", ByRef FHint As WString = "", ByRef FImageKey As WString, ByRef FSelectedImageKey As WString, bSorted As Boolean = False) As TreeNode Ptr
		If Parent AndAlso Cast(TreeView Ptr, Parent)->Images AndAlso Cast(TreeView Ptr, Parent)->SelectedImages Then
			PNode = This.Add(FText, FKey, FHint, Cast(TreeView Ptr, Parent)->Images->IndexOf(FImageKey), Cast(TreeView Ptr, Parent)->SelectedImages->IndexOf(FSelectedImageKey), bSorted)
		Else
			PNode = This.Add(FText, FKey, FHint, -1, -1, bSorted)
		End If
		If PNode Then PNode->ImageKey         = FImageKey: PNode->SelectedImageKey         = FSelectedImageKey
		Return PNode
	End Function
	
	Function TreeNodeCollection.Insert(Index As Integer, ByRef FText As WString = "", ByRef FKey As WString = "", ByRef FHint As WString = "", FImageIndex As Integer = -1, FSelectedImageIndex As Integer = -1) As PTreeNode
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
			#ifdef __USE_GTK__
				If Parent AndAlso Cast(TreeView Ptr, Parent)->TreeStore Then
					If .ParentNode Then
						gtk_tree_store_insert(Cast(TreeView Ptr, Parent)->TreeStore, @.TreeIter, @.ParentNode->TreeIter, Index)
					Else
						gtk_tree_store_insert(Cast(TreeView Ptr, Parent)->TreeStore, @.TreeIter, NULL, Index)
					End If
					gtk_tree_store_set(Cast(TreeView Ptr, Parent)->TreeStore, @.TreeIter, 1, ToUTF8(FText), -1)
				EndIf
			#else
				Dim As TVINSERTSTRUCT tvis
				If Parent->Handle Then
					tvis.Item.Mask = TVIF_TEXT Or TVIF_IMAGE Or TVIF_SELECTEDIMAGE
					tvis.item.pszText              = @Ftext
					tvis.item.cchTextMax           = Len(Ftext)
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
			#endif
		End With
		Return PNode
	End Function
	
	Function TreeNodeCollection.Insert(Index As Integer, ByRef FText As WString = "", ByRef FKey As WString = "", ByRef FHint As WString = "", ByRef FImageKey As WString, ByRef FSelectedImageKey As WString) As TreeNode Ptr
		If Parent AndAlso Cast(TreeView Ptr, Parent)->Images AndAlso Cast(TreeView Ptr, Parent)->SelectedImages Then
			PNode = This.Insert(Index, FText, FKey, FHint, Cast(TreeView Ptr, Parent)->Images->IndexOf(FImageKey), Cast(TreeView Ptr, Parent)->SelectedImages->IndexOf(FSelectedImageKey))
		Else
			PNode = This.Insert(Index, FText, FKey, FHint, -1, -1)
		End If
		If PNode Then PNode->ImageKey         = FImageKey: PNode->SelectedImageKey         = FSelectedImageKey
		Return PNode
	End Function
	
	Sub TreeNodeCollection.Remove(Index As Integer)
'		#ifdef __USE_GTK__
'			If Parent AndAlso Parent->widget Then
'				gtk_tree_store_remove(Cast(TreeView Ptr, Parent)->TreeStore, @This.Item(Index)->TreeIter)
'			End If
'		#else
'			If Parent AndAlso Parent->Handle Then
'				TreeView_DeleteItem(Parent->Handle, Item(Index)->Handle)
'			End If
'		#endif
		Delete Item(Index)
		FNodes.Remove Index
	End Sub
	Sub TreeNodeCollection.EditLabel
		#ifdef __USE_GTK__
		#else
			If Parent AndAlso Parent->Handle AndAlso FParentNode->Handle Then
				'TreeView_EditLabel(Parent->Handle, FParentNode->Handle)
			End If
		#endif
	End Sub
	
	Function TreeNodeCollection.IndexOf(ByRef FNode As TreeNode Ptr) As Integer
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
'		If ParentNode = 0 Then
'			#ifdef __USE_GTK__
'				If Parent AndAlso Cast(TreeView Ptr, Parent)->TreeStore Then gtk_tree_store_clear(Cast(TreeView Ptr, Parent)->TreeStore)
'			#else
'				If Parent AndAlso Parent->Handle Then SendMessage(Parent->Handle, TVM_DELETEITEM, 0, Cast(LPARAM, TVI_ROOT))
'			#endif
			For i As Integer = Count - 1 To 0 Step -1
				Delete Cast(TreeNode Ptr, FNodes.Items[i])
			Next i
'		Else
'			For i As Integer = Count - 1 To 0 Step -1
'				Remove i
'			Next i
'		End If
		FNodes.Clear
	End Sub
	
	#ifndef __USE_GTK__
		Sub TreeView.SendToAllChildItems(ByVal hNode As HTREEITEM, tvMessage As Long)
			Dim hChildNode As HTREEITEM
			Do While hNode
				TreeView_Expand(FHandle, hNode, tvMessage)
				hChildNode = TreeView_GetChild(FHandle, hNode)
				If hChildNode Then SendToAllChildItems(hChildNode, tvMessage)
				hNode = TreeView_GetNextSibling(FHandle, hNode)
			Loop
		End Sub
	#endif
	
	Sub TreeView.CollapseAll
		#ifdef __USE_GTK__
			gtk_tree_view_collapse_all(gtk_tree_view(widget))
		#else
			SendToAllChildItems(TreeView_GetRoot(Handle), TVE_COLLAPSE)
		#endif
	End Sub
	
	Sub TreeView.ExpandAll
		#ifdef __USE_GTK__
			gtk_tree_view_expand_all(gtk_tree_view(widget))
		#else
			SendToAllChildItems(TreeView_GetRoot(Handle), TVM_EXPAND)
		#endif
	End Sub
	
	Property TreeView.HideSelection As Boolean
		Return FHideSelection
	End Property
	
	Property TreeView.HideSelection(Value As Boolean)
		FHideSelection = Value
		#ifndef __USE_GTK__
			ChangeStyle TVS_SHOWSELALWAYS, Not Value
		#endif
	End Property
	
	Property TreeView.EditLabels As Boolean
		Return FEditLabels
	End Property
	
	Property TreeView.EditLabels(Value As Boolean)
		FEditLabels = Value
		#ifndef __USE_GTK__
			ChangeStyle TVS_EDITLABELS, Not Value
		#endif
	End Property
	
	Property TreeView.SelectedNode As TreeNode Ptr
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			If gtk_tree_selection_get_selected(TreeSelection, NULL, @iter) Then
				Return Nodes.FindByIterUser_Data(iter.User_Data)
			End If
		#else
			If Handle Then
				Dim As HTREEItem hti = TreeView_GetNextItem(Handle, NULL, TVGN_CARET)
				Return Nodes.FindByHandle(hti)
			End If
		#endif
		Return 0
	End Property
	
	Property TreeView.SelectedNode(Value As TreeNode Ptr)
		#ifdef __USE_GTK__
			If TreeSelection Then gtk_tree_selection_select_iter(TreeSelection, @Value->TreeIter)
		#else
			If Handle Then TreeView_Select(Handle, Value->Handle, TVGN_CARET)
		#endif
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
		#ifdef __USE_GTK__
			If Value Then
				gtk_tree_sortable_set_sort_column_id(gtk_tree_sortable(TreeStore), GTK_TREE_SORTABLE_DEFAULT_SORT_COLUMN_ID, GTK_SORT_ASCENDING)
			Else
				gtk_tree_sortable_set_sort_column_id(gtk_tree_sortable(TreeStore), GTK_TREE_SORTABLE_UNSORTED_SORT_COLUMN_ID, GTK_SORT_ASCENDING)
			End If
		#endif
	End Property
	
	#ifndef __USE_GTK__
		Sub TreeView.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Sub TreeView.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_GTK__
			Dim As GdkEvent Ptr e = Message.event
			Select Case Message.event->Type
			Case Else
			End Select
		#else
			Select Case Message.Msg
			Case WM_PAINT
				Message.Result = 0
			Case WM_SIZE
			Case CM_NOTIFY
				Dim tvp As NMTREEVIEW Ptr = Cast(NMTREEVIEW Ptr, message.lparam)
				If tvp->itemNew.hItem <> 0 Then
					Dim sn As TreeNode Ptr
					Select Case tvp->hdr.code
					Case NM_CLICK
						sn = Nodes.FindByHandle(tvp->itemNew.hItem): If sn = 0 Then sn = SelectedNode
						If OnNodeClick AndAlso sn Then OnNodeClick(This, *sn)
					Case NM_DBLCLK:
						sn = Nodes.FindByHandle(tvp->itemNew.hItem): If sn = 0 Then sn = SelectedNode
						If OnNodeDblClick AndAlso sn Then OnNodeDblClick(This, *sn)
						If OnNodeActivate Then OnNodeActivate(This, *sn)
					Case NM_KILLFOCUS
					Case NM_RCLICK
						If OnMouseUp Then OnMouseUp(This,1,Message.lParamLo,Message.lParamHi,Message.wParam And &HFFFF)
						If ContextMenu Then
							If ContextMenu->Handle Then
								Dim As Point P
								GetCursorPos(@P)
								ContextMenu->Popup(P.x, P.y)
							End If
						End If
					Case NM_RDBLCLK
					Case NM_RETURN
						sn = Nodes.FindByHandle(tvp->itemNew.hItem): If sn = 0 Then sn = SelectedNode
						If OnNodeActivate AndAlso sn Then OnNodeActivate(This, *sn)
					Case NM_SETCURSOR
					Case NM_SETFOCUS
					Case TVN_KEYDOWN
					Case TVN_GETINFOTIP
					Case TVN_SINGLEEXPAND
					Case TVN_SELCHANGING
						sn = Nodes.FindByHandle(tvp->itemNew.hItem): If sn = 0 Then sn = SelectedNode
						If OnSelChanging AndAlso sn <> 0 Then OnSelChanging(This, *sn)
					Case TVN_SELCHANGED
						sn = Nodes.FindByHandle(tvp->itemNew.hItem): If sn = 0 Then sn = SelectedNode
						If OnSelChanged AndAlso sn <> 0 Then OnSelChanged(This, *sn)
					Case TVN_GETDISPINFO
					Case TVN_GETINFOTIP
					Case TVN_SETDISPINFO
					Case TVN_ITEMCHANGED
					Case TVN_ITEMCHANGING
					Case TVN_ITEMEXPANDING
						sn = Nodes.FindByHandle(tvp->itemNew.hItem): If sn = 0 Then sn = SelectedNode
						If OnNodeExpanding AndAlso sn <> 0 Then OnNodeExpanding(This, *sn)
					Case TVN_ITEMEXPANDED
						sn = Nodes.FindByHandle(tvp->itemNew.hItem): If sn = 0 Then sn = SelectedNode
						If OnNodeExpanded AndAlso sn <> 0 Then OnNodeExpanded(This, *sn)
					Case TVN_BEGINDRAG
					Case TVN_BEGINRDRAG
					Case TVN_DELETEITEM
					Case TVN_BEGINLABELEDIT
					Case TVN_ENDLABELEDIT
						Dim tvpA As NMTVDISPINFOA Ptr = Cast(NMTVDISPINFOA Ptr, message.lparam)
						Dim As WString Ptr tmpStr = Cast(WString Ptr, tvpA->item.pszText)
						If OnAfterLabelEdit Then OnAfterLabelEdit(This, *tmpStr)
						Deallocate tmpStr
					Case TVN_ITEMCHANGINGW
					Case TVN_ITEMCHANGED
					Case TVN_ASYNCDRAW
						'Case NM_KEYDOWN: If OnItemDblClick Then OnItemDblClick(This, *ListItems.Item(lvp->iItem))
					End Select
				End If
				
			Case CM_COMMAND
				
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
		Sub TreeView.HandleIsDestroyed(ByRef Sender As Control)
		End Sub
		
		Sub TreeView.CreateNodes(PNode As TreeNode Ptr)
			With PNode->Nodes
				For i As Integer = 0 To .Count - 1
					Dim tvis As TVINSERTSTRUCT
					tvis.Item.Mask = TVIF_TEXT Or TVIF_IMAGE Or TVIF_SELECTEDIMAGE
					tvis.item.pszText              = @.Item(i)->text
					tvis.item.cchTextMax           = Len(.Item(i)->text)
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
		
		Sub TreeView.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QTreeView(Sender.Child)
					If .Images Then .Images->ParentWindow = @Sender
					If .SelectedImages Then .SelectedImages->ParentWindow = @Sender
					'.Perform(TB_BUTTONSTRUCTSIZE,SizeOF(TBBUTTON),0)
					'.Perform(TB_SETEXTENDEDSTYLE, 0, .Perform(TB_GETEXTENDEDSTYLE, 0, 0) OR TBSTYLE_EX_DRAWDDARROWS)
					'.Perform(TB_SETBUTTONSIZE,0,MakeLong(.ButtonWidth,.ButtonHeight))
					'.Perform(TB_SETBITMAPSIZE,0,MakeLong(.ButtonWidth,.ButtonHeight))
					Dim lvStyle As Integer = TreeView_GetExtendedStyle(.FHandle) 'David Change
					lvStyle = lvStyle Or TVS_EX_DOUBLEBUFFER' Or TVS_EX_FADEINOUTEXPANDOS 'the ICO not showing at the beginning
					TreeView_SetExtendedStyle(.FHandle, lvStyle, 0)
					
					If .Images AndAlso .Images->Handle Then TreeView_SetImageList(.FHandle, CInt(.Images->Handle), TVSIL_NORMAL)
					If .SelectedImages AndAlso .SelectedImages->Handle Then TreeView_SetImageList(.FHandle, CInt(.SelectedImages->Handle), TVSIL_STATE)
					For i As Integer = 0 To .Nodes.Count -1
						Dim tvis As TVINSERTSTRUCT
						tvis.Item.Mask = TVIF_TEXT Or TVIF_IMAGE Or TVIF_SELECTEDIMAGE
						tvis.item.pszText              = @.Nodes.Item(i)->text
						tvis.item.cchTextMax           = Len(.Nodes.Item(i)->text)
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
	#endif
	
	Operator TreeView.Cast As Control Ptr
		Return @This
	End Operator
	
	#ifdef __USE_GTK__
		Sub TreeView_RowActivated(tree_view As GtkTreeView Ptr, path As GtkTreePath Ptr, column As GtkTreeViewColumn Ptr, user_data As Any Ptr)
			Dim As TreeView Ptr tv = Cast(Any Ptr, user_data)
			If tv Then
				Dim As GtkTreeModel Ptr model
				Dim As GtkTreeIter iter
				model = gtk_tree_view_get_model(tree_view)
				If gtk_tree_model_get_iter(model, @iter, path) Then
					If tv->OnNodeActivate Then tv->OnNodeActivate(*tv, *tv->Nodes.FindByIterUser_Data(iter.User_Data))
				End If
			End If
		End Sub
		
		Sub TreeView_SelectionChanged(selection As GtkTreeSelection Ptr, user_data As Any Ptr)
			Dim As TreeView Ptr tv = Cast(Any Ptr, user_data)
			If tv Then
				Dim As GtkTreeIter iter
				Dim As GtkTreeModel Ptr model
				If gtk_tree_selection_get_selected(selection, @model, @iter) Then
					If tv->OnSelChanged Then tv->OnSelChanged(*tv, *tv->Nodes.FindByIterUser_Data(iter.User_Data))
				End If
			End If
		End Sub
		
		Function TreeView_ButtonRelease(widget As GtkWidget Ptr, e As GdkEvent Ptr, user_data As Any Ptr) As Boolean
			Dim As TreeView Ptr tv = user_data
			Dim Message As Message
			If e->button.button = 3 AndAlso tv->ContextMenu Then
				If tv->ContextMenu->widget Then
					Message = Type(tv, widget, e, False)
					tv->ContextMenu->Popup(e->button.x, e->button.y, @Message)
				End If
			End If
			Return False
		End Function
		
		Function TreeView_QueryTooltip(widget As GtkWidget Ptr, x As gint, y As gint, keyboard_mode As Boolean, tooltip As GtkTooltip Ptr, user_data As Any Ptr) As Boolean
			Dim As TreeView Ptr tv = user_data
			Dim As GtkTreeIter iter
			Dim As GtkTreePath Ptr path
			Dim As GtkTreeModel Ptr model
			If Not gtk_tree_view_get_tooltip_context(gtk_tree_view(widget), @x, @y, keyboard_mode, @model, @path, @iter) Then
				Return False
			End If
			Dim As TreeNode Ptr tn = tv->Nodes.FindByIterUser_Data(iter.User_Data)
			gtk_tooltip_set_text(tooltip, ToUTF8(tn->Hint))
			gtk_tree_view_set_tooltip_row(gtk_tree_view(widget), tooltip, path)
			Return True
		End Function
	#endif
	
	Constructor TreeView
		Nodes.Clear
		Nodes.Parent = @This
		FEnabled = True
		FVisible = True
		With This
			.Child             = @This
			#ifdef __USE_GTK__
				Dim As GtkTreeViewColumn Ptr col = gtk_tree_view_column_new()
				Dim As GtkCellRenderer Ptr renderpixbuf = gtk_cell_renderer_pixbuf_new()
				Dim As GtkCellRenderer Ptr rendertext = gtk_cell_renderer_text_new()
				scrolledwidget = gtk_scrolled_window_new(NULL, NULL)
				gtk_scrolled_window_set_policy(gtk_scrolled_window(scrolledwidget), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
				TreeStore = gtk_tree_store_new(2, G_TYPE_STRING, G_TYPE_STRING)
				widget = gtk_tree_view_new_with_model(GTK_TREE_MODEL(TreeStore))
				gtk_container_add(gtk_container(scrolledwidget), widget)
				TreeSelection = gtk_tree_view_get_selection(GTK_TREE_VIEW(widget))
				
				gtk_tree_view_column_pack_start(col, renderpixbuf, False)
				gtk_tree_view_column_add_attribute(col, renderpixbuf, ToUTF8("icon_name"), 0)
				'gtk_tree_view_append_column(GTK_TREE_VIEW(widget), colpixbuf)
				
				gtk_tree_view_column_pack_start(col, rendertext, True)
				gtk_tree_view_column_add_attribute(col, rendertext, ToUTF8("text"), 1)
				gtk_tree_view_append_column(GTK_TREE_VIEW(widget), col)
				
				gtk_tree_view_set_headers_visible(GTK_TREE_VIEW(widget), False)
				gtk_tree_view_set_enable_tree_lines(GTK_TREE_VIEW(widget), True)
				#ifdef __USE_GTK3__
					gtk_widget_set_has_tooltip(widget, True)
				#endif
				
				g_signal_connect(gtk_tree_view(widget), "button-release-event", G_CALLBACK(@TreeView_ButtonRelease), @This)
				g_signal_connect(widget, "row-activated", G_CALLBACK(@TreeView_RowActivated), @This)
				g_signal_connect(widget, "query-tooltip", G_CALLBACK(@TreeView_QueryTooltip), @This)
				g_signal_connect(G_OBJECT(TreeSelection), "changed", G_CALLBACK (@TreeView_SelectionChanged), @This)
			#else
				.OnHandleIsAllocated = @HandleIsAllocated
				.OnHandleIsDestroyed = @HandleIsDestroyed
				.RegisterClass "TreeView", WC_TREEVIEW
				.ChildProc         = @WndProc
				WLet FClassAncestor, WC_TREEVIEW
				.ExStyle           = WS_EX_CLIENTEDGE
				.Style             = WS_CHILD Or WS_VISIBLE Or TVS_HASLINES Or TVS_LINESATROOT Or TVS_HASBUTTONS
				.BackColor       = GetSysColor(COLOR_WINDOW) 'David Change
				.DoubleBuffered = True
			#endif
			WLet FClassName, "TreeView"
			FTabStop = True
			.Width             = 121
			.Height            = 121
		End With
	End Constructor
	
	Destructor TreeView
		Nodes.Clear
		#ifndef __USE_GTK__
			UnregisterClass "TreeView",GetmoduleHandle(NULL)
		#endif
	End Destructor
End Namespace
