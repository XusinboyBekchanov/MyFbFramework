'################################################################################
'#  TreeView.bi                                                                 #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#include once "TreeView.bi"
#ifdef __USE_WINAPI__
	#include once "win\commctrl.bi"
	#include once "win\tmschema.bi"
#endif

Namespace My.Sys.Forms
	Private Sub TreeNode.SelectItem
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->Handle Then gtk_tree_selection_select_iter(gtk_tree_view_get_selection(GTK_TREE_VIEW(Parent->Handle)), @TreeIter)
		#else
			If Parent AndAlso Parent->Handle Then TreeView_Select(Parent->Handle, Handle, TVGN_CARET)
		#endif
	End Sub
	
	Private Sub TreeNode.Collapse
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->Handle AndAlso gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle)) Then
				Dim As GtkTreePath Ptr TreePath = gtk_tree_path_new_from_string(gtk_tree_model_get_string_from_iter(gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle)), @TreeIter))
				gtk_tree_view_collapse_row(GTK_TREE_VIEW(Parent->Handle), TreePath)
				gtk_tree_path_free(TreePath)
			End If
		#else
			If Parent AndAlso Parent->Handle Then TreeView_Expand(Parent->Handle, Handle, TVE_EXPAND)
		#endif
	End Sub
	
	Private Sub TreeNode.Expand
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->Handle AndAlso gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle)) Then
				Dim As GtkTreePath Ptr TreePath = gtk_tree_path_new_from_string(gtk_tree_model_get_string_from_iter(gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle)), @TreeIter))
				gtk_tree_view_expand_row(GTK_TREE_VIEW(Parent->Handle), TreePath, False)
				gtk_tree_path_free(TreePath)
			End If
		#else
			If Parent AndAlso Parent->Handle Then TreeView_Expand(Parent->Handle, Handle, TVE_EXPAND)
		#endif
	End Sub
	
	Private Function TreeNode.IsExpanded As Boolean
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->Handle AndAlso gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle)) Then
				Dim As GtkTreePath Ptr TreePath = gtk_tree_path_new_from_string(gtk_tree_model_get_string_from_iter(gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle)), @TreeIter))
				Var bResult = gtk_tree_view_row_expanded(GTK_TREE_VIEW(Parent->Handle), TreePath)
				gtk_tree_path_free(TreePath)
				Return bResult
			End If
		#else
			If Parent AndAlso Parent->Handle Then Return TreeView_GetItemState(Parent->Handle, Handle, TVIS_EXPANDED)
		#endif
	End Function
	
	Private Property TreeNode.Bold As Boolean
		#ifdef __USE_GTK__
			Return  FBold
		#else
			If Parent AndAlso Parent->Handle Then
				FBold = TreeView_GetItemState(Parent->Handle, Handle, TVIS_BOLD)
				Return FBold
			End If
		#endif
	End Property
	
	Private Property TreeNode.Bold(Value As Boolean)
		FBold = Value
		#ifdef __USE_GTK__
		#else
			If Parent AndAlso Parent->Handle Then
				TreeView_SetItemState(Parent->Handle, Handle, IIf(Value, TVIS_BOLD, 0), TVIS_BOLD)
			End If
		#endif
	End Property
	
	Private Function TreeNode.Index As Integer
		If FParentNode <> 0 Then
			Return FParentNode->Nodes.IndexOf(@This)
		ElseIf Parent <> 0 Then
			Return Cast(TreeView Ptr, Parent)->Nodes.IndexOf(@This)
		Else
			Return -1
		End If
	End Function
	
	Private Function TreeNode.ToString ByRef As WString
		Return This.Name
	End Function
	
	Private Property TreeNode.Text ByRef As WString
		Return *FText.vptr
	End Property
	
	Private Property TreeNode.Text(ByRef Value As WString)
		FText = Value
		#ifdef __USE_GTK__
			If Parent AndAlso gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle)) Then
				gtk_tree_store_set(GTK_TREE_STORE(gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle))), @TreeIter, 1, ToUtf8(Value), -1)
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
	
	Private Property TreeNode.IsUpdated As Boolean
		Return FIsUpdated
	End Property
	
	Private Property TreeNode.IsUpdated(Value As Boolean)
		FIsUpdated = Value
	End Property
	
	Private Property TreeNode.Checked As Boolean
		Return FChecked
	End Property
	
	Private Property TreeNode.Checked(Value As Boolean)
		FChecked = Value
	End Property
	
	Private Property TreeNode.Hint ByRef As WString
		Return WGet(FHint)
	End Property
	
	Private Property TreeNode.Hint(ByRef Value As WString)
		WLet(FHint, Value)
	End Property
	
	Private Property TreeNode.Name ByRef As WString
		Return WGet(FName)
	End Property
	
	Private Property TreeNode.Name(ByRef Value As WString)
		WLet(FName, Value)
	End Property
	
	Private Property TreeNode.ImageIndex As Integer
		Return FImageIndex
	End Property
	
	Private Property TreeNode.ImageIndex(Value As Integer)
		FImageIndex = Value
		#ifdef __USE_GTK__
			If Parent AndAlso Cast(TreeView Ptr, Parent)->Images AndAlso gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle)) Then
				gtk_tree_store_set(GTK_TREE_STORE(gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle))), @TreeIter, 0, ToUtf8(Cast(TreeView Ptr, Parent)->Images->Items.Get(FImageIndex)), -1)
			EndIf
		#else
			If Value <> FImageIndex Then
				If Parent AndAlso Parent->Handle Then
					Dim tvi As TVITEM
					tvi.mask = TVIF_IMAGE
					tvi.hItem = Handle
					tvi.iImage             = FImageIndex
					TreeView_SetItem(Parent->Handle, @tvi)
				End If
			End If
		#endif
	End Property
	
	Private Property TreeNode.ImageKey ByRef As WString
		Return WGet(FImageKey)
	End Property
	
	Private Property TreeNode.ImageKey(ByRef Value As WString)
		If Value <> *FImageKey Then
			WLet(FImageKey, Value)
			If Parent AndAlso Parent->Handle AndAlso Cast(TreeView Ptr, Parent)->Images Then
				FImageIndex = Cast(TreeView Ptr, Parent)->Images->IndexOf(*FImageKey)
				#ifdef __USE_GTK__
					If gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle)) Then
						gtk_tree_store_set(GTK_TREE_STORE(gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle))), @TreeIter, 0, ToUtf8(Cast(TreeView Ptr, Parent)->Images->Items.Get(FImageIndex)), -1)
					EndIf
				#else
					Dim tvi As TVITEM
					tvi.mask = TVIF_IMAGE
					tvi.hItem = Handle
					tvi.iImage             = FImageIndex
					TreeView_SetItem(Parent->Handle, @tvi)
				#endif
			End If
		End If
	End Property
	
	Private Property TreeNode.SelectedImageIndex As Integer
		Return FSelectedImageIndex
	End Property
	
	Private Property TreeNode.SelectedImageIndex(Value As Integer)
		FSelectedImageIndex = Value
		If Parent AndAlso Parent->Handle Then
			#ifdef __USE_GTK__
				If CInt(Cast(TreeView Ptr, Parent)->SelectedImages) AndAlso CInt(Cast(TreeView Ptr, Parent)->SelectedNode = @This) AndAlso CInt(gtk_tree_view_get_model(gtk_tree_view(Parent->Handle))) Then
					gtk_tree_store_set(gtk_tree_store(gtk_tree_view_get_model(gtk_tree_view(Parent->Handle))), @TreeIter, 0, ToUTF8(Cast(TreeView Ptr, Parent)->SelectedImages->Items.Get(FSelectedImageIndex)), -1)
				End If
			#else
				Dim tvi As TVITEM
				tvi.mask = TVIF_SELECTEDIMAGE
				tvi.hItem = Handle
				tvi.iSelectedImage   = FSelectedImageIndex
				TreeView_SetItem(Parent->Handle, @tvi)
			#endif
		End If
	End Property
	
	Private Property TreeNode.ParentNode As TreeNode Ptr
		Return FParentNode
	End Property
	
	Private Property TreeNode.ParentNode(Value As TreeNode Ptr)
		FParentNode = Value
	End Property
	
	Private Property TreeNode.SelectedImageKey ByRef As WString
		Return WGet(FSelectedImageKey)
	End Property
	
	Private Property TreeNode.SelectedImageKey(ByRef Value As WString)
		WLet(FSelectedImageKey, Value)
		If Parent AndAlso Parent->Handle AndAlso Cast(TreeView Ptr, Parent)->SelectedImages Then
			FSelectedImageIndex = Cast(TreeView Ptr, Parent)->SelectedImages->IndexOf(*FSelectedImageKey)
			#ifdef __USE_GTK__
				If CInt(Cast(TreeView Ptr, Parent)->SelectedNode = @This) AndAlso CInt(gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle))) Then
					gtk_tree_store_set(GTK_TREE_STORE(gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle))), @TreeIter, 0, ToUtf8(Cast(TreeView Ptr, Parent)->SelectedImages->Items.Get(FSelectedImageIndex)), -1)
				End If
			#else
				Dim tvi As TVITEM
				tvi.mask = TVIF_SELECTEDIMAGE
				tvi.hItem = Handle
				tvi.iSelectedImage = FSelectedImageIndex
				TreeView_SetItem(Parent->Handle, @tvi)
			#endif
		End If
	End Property
	
	Private Property TreeNode.Visible As Boolean
		Return FVisible
	End Property
	
	Private Property TreeNode.Visible(Value As Boolean)
		If Value <> FVisible Then
			FVisible = Value
			If Parent Then
				With QControl(Parent)
					'.Perform(TB_HIDEBUTTON, FCommandID, MakeLong(NOT FVisible, 0))
				End With
			End If
		End If
	End Property
	
	Private Operator TreeNode.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor TreeNode
		Nodes.Clear
		Nodes.Parent = Parent
		Nodes.ParentNode = @This
		FHint = 0' CAllocate_(0)
		FText = "" 'CAllocate(0)
		FVisible    = 1
		Text    = ""
		Hint       = ""
		FImageIndex = -1
		FSelectedImageIndex = -1
	End Constructor
	
	Private Function TreeNode.IsDisposed As Boolean
		Return FIsDisposed
	End Function
	
	Private Destructor TreeNode
		Nodes.Clear
		FIsDisposed = True
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				If GTK_IS_TREE_VIEW(Parent->Handle) Then
					gtk_tree_store_remove(GTK_TREE_STORE(gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle))), @This.TreeIter)
					This.TreeIter.user_data = 0
				End If
			End If
		#else
			If Parent AndAlso Parent->Handle Then
				TreeView_DeleteItem(Parent->Handle, This.Handle)
				This.Handle = 0
			End If
		#endif
		WDeAllocate(FHint)
		WDeAllocate(FName)
		'WDeAllocate FText
		WDeAllocate(FImageKey)
		WDeAllocate(FSelectedImageKey)
	End Destructor
	
	Private Constructor TreeNodeCollection
		This.Clear
	End Constructor
	
	Private Destructor TreeNodeCollection
		This.Clear
	End Destructor
	
	#ifdef __USE_GTK__
		Private Function TreeNodeCollection.FindByIterUser_Data(User_Data As Any Ptr) As TreeNode Ptr
			If ParentNode AndAlso ParentNode->TreeIter.user_data = User_Data Then Return ParentNode
			For i As Integer = 0 To Count - 1
				PNode = Item(i)->Nodes.FindByIterUser_Data(User_Data)
				If PNode <> 0 Then Return PNode
			Next i
			Return 0
		End Function
	#else
		Private Function TreeNodeCollection.FindByHandle(hti As HTREEITEM) As TreeNode Ptr
			If ParentNode AndAlso ParentNode->Handle = hti Then Return ParentNode
			For i As Integer = 0 To Count - 1
				PNode = Item(i)->Nodes.FindByHandle(hti)
				If PNode <> 0 Then Return PNode
			Next i
			Return 0
		End Function
	#endif
	
	Private Property TreeNodeCollection.Count As Integer
		Return FNodes.Count
	End Property
	
	Private Property TreeNodeCollection.Count(Value As Integer)
	End Property
	
	Private Property TreeNodeCollection.Item(Index As Integer) As TreeNode Ptr
		If Index >= 0 AndAlso Index < FNodes.Count Then
			Return FNodes.Items[Index]
		End If
	End Property
	
	Private Property TreeNodeCollection.Item(Index As Integer, Value As TreeNode Ptr)
		If Index >= 0 AndAlso Index < FNodes.Count Then
			FNodes.Items[Index] = Value 'David Change
		End If
	End Property
	
	Private Function TreeNodeCollection.Add(ByRef FText As WString = "", ByRef FKey As WString = "", ByRef FHint As WString = "", FImageIndex As Integer = -1, FSelectedImageIndex As Integer = -1, bSorted As Boolean = False) As PTreeNode
		Dim PNode As PTreeNode
		PNode = _New( TreeNode)
		PNode->FDynamic = True
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
				If Parent AndAlso Parent->Handle AndAlso gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle)) Then
					If .ParentNode Then
						gtk_tree_store_insert(GTK_TREE_STORE(gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle))), @.TreeIter, @.ParentNode->TreeIter, iIndex)
					Else
						gtk_tree_store_insert(GTK_TREE_STORE(gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle))), @.TreeIter, NULL, iIndex)
					End If
					gtk_tree_store_set(GTK_TREE_STORE(gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle))), @.TreeIter, 1, ToUtf8(FText), -1)
					.ImageIndex = .ImageIndex
				EndIf
			#else
				Dim As TVINSERTSTRUCT tvis
				If Parent AndAlso Parent->Handle Then
					tvis.item.mask = TVIF_TEXT Or TVIF_IMAGE Or TVIF_SELECTEDIMAGE
					tvis.item.pszText              = @FText
					tvis.item.cchTextMax           = Len(FText)
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
	
	Private Function TreeNodeCollection.Add(ByRef FText As WString = "", ByRef FKey As WString = "", ByRef FHint As WString = "", ByRef FImageKey As WString, ByRef FSelectedImageKey As WString, bSorted As Boolean = False) As TreeNode Ptr
		Dim As TreeNode Ptr PNode
		If Parent AndAlso Cast(TreeView Ptr, Parent)->Images AndAlso Cast(TreeView Ptr, Parent)->SelectedImages Then
			PNode = This.Add(FText, FKey, FHint, Cast(TreeView Ptr, Parent)->Images->IndexOf(FImageKey), Cast(TreeView Ptr, Parent)->SelectedImages->IndexOf(FSelectedImageKey), bSorted)
		Else
			PNode = This.Add(FText, FKey, FHint, -1, -1, bSorted)
		End If
		If PNode Then PNode->ImageKey         = FImageKey: PNode->SelectedImageKey         = FSelectedImageKey
		Return PNode
	End Function
	
	Private Function TreeNodeCollection.Insert(Index As Integer, ByRef FText As WString = "", ByRef FKey As WString = "", ByRef FHint As WString = "", FImageIndex As Integer = -1, FSelectedImageIndex As Integer = -1) As PTreeNode
		Dim PNode As PTreeNode
		PNode = _New( TreeNode)
		PNode->FDynamic = True
		FNodes.Insert Index, PNode
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
				If Parent AndAlso gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle)) Then
					If .ParentNode Then
						gtk_tree_store_insert(GTK_TREE_STORE(gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle))), @.TreeIter, @.ParentNode->TreeIter, Index)
					Else
						gtk_tree_store_insert(GTK_TREE_STORE(gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle))), @.TreeIter, NULL, Index)
					End If
					gtk_tree_store_set(GTK_TREE_STORE(gtk_tree_view_get_model(GTK_TREE_VIEW(Parent->Handle))), @.TreeIter, 1, ToUtf8(FText), -1)
				EndIf
			#else
				Dim As TVINSERTSTRUCT tvis
				If Parent->Handle Then
					tvis.item.mask = TVIF_TEXT Or TVIF_IMAGE Or TVIF_SELECTEDIMAGE
					tvis.item.pszText              = @FText
					tvis.item.cchTextMax           = Len(FText)
					tvis.item.iImage             = FImageIndex
					tvis.item.iSelectedImage     = FSelectedImageIndex
					tvis.hInsertAfter            = IIf(Index = 0, TVI_FIRST, IIf(Index < 0, TVI_LAST, Item(Index - 1)->Handle))
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
	
	Private Function TreeNodeCollection.Insert(Index As Integer, ByRef FText As WString = "", ByRef FKey As WString = "", ByRef FHint As WString = "", ByRef FImageKey As WString, ByRef FSelectedImageKey As WString) As TreeNode Ptr
		Dim PNode As PTreeNode
		If Parent AndAlso Cast(TreeView Ptr, Parent)->Images AndAlso Cast(TreeView Ptr, Parent)->SelectedImages Then
			PNode = This.Insert(Index, FText, FKey, FHint, Cast(TreeView Ptr, Parent)->Images->IndexOf(FImageKey), Cast(TreeView Ptr, Parent)->SelectedImages->IndexOf(FSelectedImageKey))
		Else
			PNode = This.Insert(Index, FText, FKey, FHint, -1, -1)
		End If
		If PNode Then PNode->ImageKey         = FImageKey: PNode->SelectedImageKey         = FSelectedImageKey
		Return PNode
	End Function
	
	Private Sub TreeNodeCollection.Remove(Index As Integer)
		'		#ifdef __USE_GTK__
		'			If Parent AndAlso Parent->widget Then
		'				gtk_tree_store_remove(Cast(TreeView Ptr, Parent)->TreeStore, @This.Item(Index)->TreeIter)
		'			End If
		'		#else
		'			If Parent AndAlso Parent->Handle Then
		'				TreeView_DeleteItem(Parent->Handle, Item(Index)->Handle)
		'			End If
		'		#endif
		_Delete(Item(Index))
		FNodes.Remove Index
	End Sub
	Private Sub TreeNodeCollection.EditLabel
		#ifdef __USE_GTK__
		#else
			If Parent AndAlso Parent->Handle AndAlso FParentNode->Handle Then
				'TreeView_EditLabel(Parent->Handle, FParentNode->Handle)
			End If
		#endif
	End Sub
	
	Private Function TreeNodeCollection.IndexOf(ByRef FNode As TreeNode Ptr) As Integer
		Return FNodes.IndexOf(FNode)
	End Function
	
	Private Function TreeNodeCollection.IndexOf(ByRef Text As WString) As Integer
		For i As Integer = 0 To Count - 1
			If Item(i)->Text = Text Then Return i
		Next i
		Return -1
	End Function
	
	Private Function TreeNodeCollection.IndexOfKey(ByRef Key As WString) As Integer
		For i As Integer = 0 To Count - 1
			If Item(i)->Name = Key Then Return i
		Next i
		Return -1
	End Function
	
	Private Function TreeNodeCollection.Contains(ByRef FNode As TreeNode Ptr) As Boolean
		Return IndexOf(FNode) <> -1
	End Function
	
	Private Function TreeNodeCollection.Contains(ByRef Text As WString) As Boolean
		Return IndexOf(Text) <> -1
	End Function
	
	Private Function TreeNodeCollection.ContainsKey(ByRef Key As WString) As Boolean
		Return IndexOfKey(Key) <> -1
	End Function
	
	Private Property TreeNodeCollection.ParentNode As PTreeNode
		Return FParentNode
	End Property
	
	Private Property TreeNodeCollection.ParentNode(Value As PTreeNode)
		FParentNode = Value
	End Property
	
	Private Sub TreeNodeCollection.Clear
		'		If ParentNode = 0 Then
		'			#ifdef __USE_GTK__
		'				If Parent AndAlso Cast(TreeView Ptr, Parent)->TreeStore Then gtk_tree_store_clear(Cast(TreeView Ptr, Parent)->TreeStore)
		'			#else
		'				If Parent AndAlso Parent->Handle Then SendMessage(Parent->Handle, TVM_DELETEITEM, 0, Cast(LPARAM, TVI_ROOT))
		'			#endif
		For i As Integer = FNodes.Count - 1 To 0 Step -1
			If Cast(TreeNode Ptr, FNodes.Items[i])->FDynamic Then _Delete( Cast(TreeNode Ptr, FNodes.Items[i]))
		Next i
		'		Else
		'			For i As Integer = Count - 1 To 0 Step -1
		'				Remove i
		'			Next i
		'		End If
		FNodes.Clear
	End Sub
	
	#ifndef ReadProperty_Off
		Private Function TreeView.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "editlabels": Return @FEditLabels
			Case "hideselection": Return @FHideSelection
			Case "images": Return Images
			Case "sorted": Return @FSorted
			Case "showhint": Return @FShowHint
			Case "selectedimages": Return SelectedImages
			Case "selectednode": Return SelectedNode
			Case "tabindex": Return @FTabIndex
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function TreeView.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "editlabels": EditLabels = QBoolean(Value)
				Case "hideselection": HideSelection = QBoolean(Value)
				Case "images": Images = Value
				Case "sorted": Sorted = QBoolean(Value)
				Case "showhint": ShowHint = QBoolean(Value)
				Case "selectedimages": SelectedImages = Value
				Case "selectednode": SelectedNode = Value
				Case "tabindex": TabIndex = QInteger(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Property TreeView.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property TreeView.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property TreeView.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property TreeView.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	#ifndef __USE_GTK__
		Private Sub TreeView.SendToAllChildItems(ByVal hNode As HTREEITEM, tvMessage As Long)
			Dim hChildNode As HTREEITEM
			Do While hNode
				TreeView_Expand(FHandle, hNode, tvMessage)
				hChildNode = TreeView_GetChild(FHandle, hNode)
				If hChildNode Then SendToAllChildItems(hChildNode, tvMessage)
				hNode = TreeView_GetNextSibling(FHandle, hNode)
			Loop
		End Sub
	#endif
	
	Private Sub TreeView.CollapseAll
		#ifdef __USE_GTK__
			gtk_tree_view_collapse_all(gtk_tree_view(widget))
		#else
			SendToAllChildItems(TreeView_GetRoot(Handle), TVE_COLLAPSE)
		#endif
	End Sub
	
	Private Sub TreeView.ExpandAll
		#ifdef __USE_GTK__
			gtk_tree_view_expand_all(gtk_tree_view(widget))
		#else
			SendToAllChildItems(TreeView_GetRoot(Handle), TVM_EXPAND)
		#endif
	End Sub
	
	Private Property TreeView.HideSelection As Boolean
		Return FHideSelection
	End Property
	
	Private Property TreeView.HideSelection(Value As Boolean)
		FHideSelection = Value
		#ifndef __USE_GTK__
			ChangeStyle TVS_SHOWSELALWAYS, Not Value
		#endif
	End Property
	
	Private Property TreeView.EditLabels As Boolean
		Return FEditLabels
	End Property
	
	Private Property TreeView.EditLabels(Value As Boolean)
		FEditLabels = Value
		#ifdef __USE_GTK__
			Dim As GValue bValue '= G_VALUE_INIT
			g_value_init_(@bValue, G_TYPE_BOOLEAN)
			g_value_set_boolean(@bValue, Value)
			g_object_set_property(G_OBJECT(rendertext), "editable", @bValue)
			g_object_set_property(G_OBJECT(rendertext), "editable-set", @bValue)
			g_value_unset(@bValue)
		#else
			ChangeStyle TVS_EDITLABELS, Value
		#endif
	End Property
	
	Private Property TreeView.SelectedNode As TreeNode Ptr
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			If gtk_tree_selection_get_selected(TreeSelection, NULL, @iter) Then
				Return Nodes.FindByIterUser_Data(iter.user_data)
			End If
		#else
			If Handle Then
				Dim As HTREEItem hti = TreeView_GetNextItem(Handle, NULL, TVGN_CARET)
				Return Nodes.FindByHandle(hti)
			End If
		#endif
		Return 0
	End Property
	
	Private Property TreeView.SelectedNode(Value As TreeNode Ptr)
		#ifdef __USE_GTK__
			If TreeSelection Then gtk_tree_selection_select_iter(TreeSelection, @Value->TreeIter)
		#else
			If Handle Then TreeView_Select(Handle, Value->Handle, TVGN_CARET)
		#endif
	End Property
	
	Private Function TreeView.DraggedNode As TreeNode Ptr
		#ifdef __USE_GTK__
			Dim As GtkTreePath Ptr path
			Dim As GtkTreeVIewDropPosition Pos1
			Dim As GtkTreeIter iter
			gtk_tree_view_get_drag_dest_row(gtk_tree_view(widget), @path, @Pos1)
			If path <> 0 AndAlso gtk_tree_model_get_iter(gtk_tree_model(TreeStore), @iter, path) Then
				Return Nodes.FindByIterUser_Data(iter.User_Data)
			End If
		#else
			If Handle Then
				Dim As HTREEItem hti = TreeView_GetNextItem(Handle, NULL, TVGN_DROPHILITE)
				Return Nodes.FindByHandle(hti)
			End If
		#endif
		Return 0
	End Function
	
	Private Property TreeView.ShowHint As Boolean
		Return FShowHint
	End Property
	
	Private Property TreeView.ShowHint(Value As Boolean)
		FShowHint = Value
	End Property
	
	Private Property TreeView.Sorted As Boolean
		Return FSorted
	End Property
	
	Private Property TreeView.Sorted(Value As Boolean)
		FSorted = Value
		#ifdef __USE_GTK__
			If Value Then
				gtk_tree_sortable_set_sort_column_id(GTK_TREE_SORTABLE(TreeStore), GTK_TREE_SORTABLE_DEFAULT_SORT_COLUMN_ID, GTK_SORT_ASCENDING)
			Else
				gtk_tree_sortable_set_sort_column_id(GTK_TREE_SORTABLE(TreeStore), GTK_TREE_SORTABLE_UNSORTED_SORT_COLUMN_ID, GTK_SORT_ASCENDING)
			End If
		#endif
	End Property
	
	#ifndef __USE_GTK__
		Private Sub TreeView.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Private Sub TreeView.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_GTK__
			Dim As GdkEvent Ptr e = Message.Event
			Select Case Message.Event->type
			Case GDK_BUTTON_RELEASE
				If SelectedNode <> 0 Then
					If OnNodeClick Then OnNodeClick(*Designer, This, *SelectedNode)
				End If
				#ifdef __USE_GTK3__
				Case GDK_2BUTTON_PRESS, GDK_DOUBLE_BUTTON_PRESS
				#else
				Case GDK_2BUTTON_PRESS
				#endif
				If SelectedNode <> 0 Then
					If OnNodeDblClick Then OnNodeDblClick(*Designer, This, *SelectedNode)
				End If
			End Select
		#else
			Select Case Message.Msg
			Case WM_PAINT
				Message.Result = 0
			Case WM_DESTROY
				If Images Then TreeView_SetImageList(FHandle, 0, TVSIL_NORMAL)
				If SelectedImages Then TreeView_SetImageList(FHandle, 0, TVSIL_STATE)
			Case WM_SIZE
			Case WM_NOTIFY
				If (Cast(LPNMHDR, Message.lParam)->code = NM_CUSTOMDRAW) Then
					Dim As LPNMCUSTOMDRAW nmcd = Cast(LPNMCUSTOMDRAW, Message.lParam)
					Select Case nmcd->dwDrawStage
					Case CDDS_PREPAINT
						Message.Result = CDRF_NOTIFYITEMDRAW
						Return
					Case CDDS_ITEMPREPAINT
						'Var info = Cast(SubclassInfo Ptr, dwRefData)
						'SetTextColor(nmcd->hdc, headerTextColor)
						Message.Result = CDRF_DODEFAULT
						Return
					End Select
				End If
			Case WM_THEMECHANGED
				If (g_darkModeSupported) Then
					
					AllowDarkModeForWindow(Message.hWnd, g_darkModeEnabled)
					
					'Dim As HTHEME hTheme = OpenThemeData(nullptr, "ItemsView")
					'If (hTheme) Then
					'Dim As COLORREF Color1
					'If (SUCCEEDED(GetThemeColor(hTheme, 0, 0, TMT_TEXTCOLOR, @Color1))) Then
					If g_darkModeEnabled Then
						TreeView_SetTextColor(Message.hWnd, darkTextColor) 'Color1)
					Else
						TreeView_SetTextColor(Message.hWnd, Font.Color) 'Color1)
					End If
					'End If
					'If (SUCCEEDED(GetThemeColor(hTheme, 0, 0, TMT_FILLCOLOR, @Color1))) Then
					'TreeView_SetTextBkColor(Message.hWnd, Color1)
					If g_darkModeEnabled Then
						TreeView_SetBkColor(Message.hWnd, darkBkColor) 'Color1)
					Else
						TreeView_SetBkColor(Message.hWnd, FBackColor) 'Color1)
					End If
					'End If
					'	CloseThemeData(hTheme)
					'End If
					
					RedrawWindow(Message.hWnd, nullptr, nullptr, RDW_FRAME Or RDW_INVALIDATE)
				End If
			Case CM_NOTIFY
				Dim tvp As NMTREEVIEW Ptr = Cast(NMTREEVIEW Ptr, Message.lParam)
				If tvp->itemNew.hItem <> 0 Then
					Dim sn As TreeNode Ptr
					Select Case tvp->hdr.code
					Case NM_CLICK
						sn = Nodes.FindByHandle(tvp->itemNew.hItem): If sn = 0 Then sn = SelectedNode
						If OnNodeClick AndAlso sn Then OnNodeClick(*Designer, This, *sn)
					Case NM_DBLCLK:
						sn = Nodes.FindByHandle(tvp->itemNew.hItem): If sn = 0 Then sn = SelectedNode
						If OnNodeDblClick AndAlso sn Then OnNodeDblClick(*Designer, This, *sn)
						If OnNodeActivate Then OnNodeActivate(*Designer, This, *sn)
					Case NM_KILLFOCUS
					Case NM_RCLICK
						If OnMouseUp Then OnMouseUp(*Designer, This, 1, Message.lParamLo, Message.lParamHi, Message.wParam And &HFFFF)
						If ContextMenu Then
							If ContextMenu->Handle Then
								Dim As ..Point P
								GetCursorPos(@P)
								ContextMenu->Popup(P.X, P.Y)
							End If
						End If
					Case NM_RDBLCLK
					Case NM_RETURN
						sn = Nodes.FindByHandle(tvp->itemNew.hItem): If sn = 0 Then sn = SelectedNode
						If OnNodeActivate AndAlso sn Then OnNodeActivate(*Designer, This, *sn)
					Case NM_SETCURSOR
					Case NM_SETFOCUS
					Case TVN_KEYDOWN
					Case TVN_GETINFOTIP
					Case TVN_SINGLEEXPAND
					Case TVN_SELCHANGING
						sn = Nodes.FindByHandle(tvp->itemNew.hItem): If sn = 0 Then sn = SelectedNode
						Dim bCancel As Boolean
						If OnSelChanging AndAlso sn <> 0 Then OnSelChanging(*Designer, This, *sn, bCancel)
						If bCancel Then Message.Result = -1: Exit Sub
					Case TVN_SELCHANGED
						sn = Nodes.FindByHandle(tvp->itemNew.hItem): If sn = 0 Then sn = SelectedNode
						If OnSelChanged AndAlso sn <> 0 Then OnSelChanged(*Designer, This, *sn)
					Case TVN_GETDISPINFO
					Case TVN_GETINFOTIP
					Case TVN_SETDISPINFO
					Case TVN_ITEMCHANGED
					Case TVN_ITEMCHANGING
					Case TVN_ITEMEXPANDING
						sn = Nodes.FindByHandle(tvp->itemNew.hItem): If sn = 0 Then sn = SelectedNode
						Dim bCancel As Boolean
						Select Case tvp->action
						Case TVE_COLLAPSE: If OnNodeCollapsing AndAlso sn <> 0 Then OnNodeCollapsing(*Designer, This, *sn, bCancel)
						Case TVE_EXPAND: If OnNodeExpanding AndAlso sn <> 0 Then OnNodeExpanding(*Designer, This, *sn, bCancel)
						End Select
						If bCancel Then Message.Result = -1: Exit Sub
					Case TVN_ITEMEXPANDED
						sn = Nodes.FindByHandle(tvp->itemNew.hItem): If sn = 0 Then sn = SelectedNode
						Select Case tvp->action
						Case TVE_COLLAPSE: If OnNodeCollapsed AndAlso sn <> 0 Then OnNodeCollapsed(*Designer, This, *sn)
						Case TVE_EXPAND: If OnNodeExpanded AndAlso sn <> 0 Then OnNodeExpanded(*Designer, This, *sn)
						End Select
					Case TVN_BEGINDRAG
					Case TVN_BEGINRDRAG
					Case TVN_DELETEITEM
					Case TVN_BEGINLABELEDIT
						Dim tvpA As NMTVDISPINFOA Ptr = Cast(NMTVDISPINFOA Ptr, Message.lParam)
						Dim As WString Ptr tmpStr = Cast(WString Ptr, tvpA->item.pszText)
						sn = Nodes.FindByHandle(tvp->itemNew.hItem): If sn = 0 Then sn = SelectedNode
						Dim bCancel As Boolean
						If OnBeforeLabelEdit Then OnBeforeLabelEdit(*Designer, This, *sn, *tmpStr, bCancel)
						_Deallocate( tmpStr)
						If bCancel Then Message.Result = -1: Exit Sub
					Case TVN_ENDLABELEDIT
						Dim tvpA As NMTVDISPINFOA Ptr = Cast(NMTVDISPINFOA Ptr, Message.lParam)
						Dim As WString Ptr tmpStr = Cast(WString Ptr, tvpA->item.pszText)
						sn = Nodes.FindByHandle(tvp->itemNew.hItem): If sn = 0 Then sn = SelectedNode
						Dim bCancel As Boolean
						If OnAfterLabelEdit Then OnAfterLabelEdit(*Designer, This, *sn, *tmpStr, bCancel)
						_Deallocate( tmpStr)
						If Not bCancel Then Message.Result = -1: Exit Sub
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
		Private Sub TreeView.HandleIsDestroyed(ByRef Sender As Control)
		End Sub
		
		Private Sub TreeView.CreateNodes(PNode As TreeNode Ptr)
			With PNode->Nodes
				For i As Integer = 0 To .Count - 1
					Dim tvis As TVINSERTSTRUCT
					tvis.item.mask = TVIF_TEXT Or TVIF_IMAGE Or TVIF_SELECTEDIMAGE
					tvis.item.pszText              = @.Item(i)->Text
					tvis.item.cchTextMax           = Len(.Item(i)->Text)
					tvis.item.iImage             = .Item(i)->ImageIndex
					tvis.item.iSelectedImage     = .Item(i)->SelectedImageIndex
					tvis.hInsertAfter            = 0
					If .Item(i)->ParentNode Then
						tvis.hParent               = .Item(i)->ParentNode->Handle
					Else
						tvis.hParent            = TVI_ROOT
					End If
					.Item(i)->Handle        = TreeView_InsertItem(FHandle, @tvis )
					CreateNodes .Item(i)
				Next i
			End With
		End Sub
		
		Private Sub TreeView.HandleIsAllocated(ByRef Sender As Control)
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
						tvis.item.mask = TVIF_TEXT Or TVIF_IMAGE Or TVIF_SELECTEDIMAGE
						tvis.item.pszText              = @.Nodes.Item(i)->Text
						tvis.item.cchTextMax           = Len(.Nodes.Item(i)->Text)
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
	
	Private Operator TreeView.Cast As Control Ptr
		Return @This
	End Operator
	
	#ifdef __USE_GTK__
		Private Sub TreeView.TreeView_RowActivated(tree_view As GtkTreeView Ptr, path As GtkTreePath Ptr, column As GtkTreeViewColumn Ptr, user_data As Any Ptr)
			Dim As TreeView Ptr tv = Cast(Any Ptr, user_data)
			If tv Then
				Dim As GtkTreeModel Ptr model
				Dim As GtkTreeIter iter
				model = gtk_tree_view_get_model(tree_view)
				If gtk_tree_model_get_iter(model, @iter, path) Then
					If tv->OnNodeActivate Then tv->OnNodeActivate(*tv->Designer, *tv, *tv->Nodes.FindByIterUser_Data(iter.user_data))
				End If
			End If
		End Sub
		
		Private Sub TreeView.TreeView_SelectionChanged(selection As GtkTreeSelection Ptr, user_data As Any Ptr)
			Dim As TreeView Ptr tv = Cast(Any Ptr, user_data)
			If tv Then
				Dim As GtkTreeIter iter
				Dim As GtkTreeModel Ptr model
				If GTK_IS_TREE_STORE(tv->TreeStore) Then
					If gtk_tree_selection_get_selected(selection, @model, @iter) Then
						Dim As TreeNode Ptr SelNode = tv->Nodes.FindByIterUser_Data(iter.user_data)
						If tv->PrevNode <> 0 AndAlso tv->PrevNode->IsDisposed = False AndAlso tv->PrevNode <> SelNode Then
							Dim bCancel As Boolean
							If tv->OnSelChanging Then tv->OnSelChanging(*tv->Designer, *tv, *tv->PrevNode, bCancel)
							If bCancel Then
								tv->SelectedNode = tv->PrevNode
								Exit Sub
							End If
							'							If tv->Images <> 0 AndAlso tv->SelectedImages <> 0 AndAlso tv->TreeStore <> 0 Then
							'								If tv->PrevNode->ImageKey <> "" Then
							'									gtk_tree_store_set(tv->TreeStore, @tv->PrevNode->TreeIter, 0, ToUTF8(tv->Images->Items.Get(tv->PrevNode->ImageKey)), -1)
							'								ElseIf tv->PrevNode->ImageIndex > -1 Then
							'									gtk_tree_store_set(tv->TreeStore, @tv->PrevNode->TreeIter, 0, ToUTF8(tv->Images->Items.Get(tv->PrevNode->ImageIndex)), -1)
							'								End If
							'							End If
						End If
						'						If SelNode <> 0 AndAlso SelNode->IsDisposed = False AndAlso tv->SelectedImages <> 0 AndAlso tv->TreeStore <> 0 Then
						'							If SelNode->SelectedImageKey <> "" Then
						'								gtk_tree_store_set(tv->TreeStore, @SelNode->TreeIter, 0, ToUTF8(tv->SelectedImages->Items.Get(SelNode->SelectedImageKey)), -1)
						'							ElseIf SelNode->SelectedImageIndex > -1 Then
						'								gtk_tree_store_set(tv->TreeStore, @SelNode->TreeIter, 0, ToUTF8(tv->SelectedImages->Items.Get(SelNode->SelectedImageIndex)), -1)
						'							End If
						'						End If
						If tv->OnSelChanged Then tv->OnSelChanged(*tv->Designer, *tv, *SelNode)
						tv->PrevNode = SelNode
					End If
				End If
			End If
		End Sub
		
		Private Function TreeView.TreeView_ButtonRelease(widget As GtkWidget Ptr, e As GdkEvent Ptr, user_data As Any Ptr) As Boolean
			Dim As TreeView Ptr tv = user_data
			Dim Message As Message
			If e->button.button = 3 AndAlso tv->ContextMenu Then
				If tv->ContextMenu->Handle Then
					Message = Type(tv, widget, e, False)
					tv->ContextMenu->Popup(e->button.x, e->button.y, @Message)
				End If
			End If
			Return False
		End Function
		
		Private Function TreeView.TreeView_QueryTooltip(widget As GtkWidget Ptr, x As gint, y As gint, keyboard_mode As Boolean, tooltip As GtkTooltip Ptr, user_data As Any Ptr) As Boolean
			Dim As TreeView Ptr tv = user_data
			Dim As GtkTreeIter iter
			Dim As GtkTreePath Ptr path
			Dim As GtkTreeModel Ptr model
			If Not gtk_tree_view_get_tooltip_context(GTK_TREE_VIEW(widget), @x, @y, keyboard_mode, @model, @path, @iter) Then
				Return False
			End If
			Dim As TreeNode Ptr tn = tv->Nodes.FindByIterUser_Data(iter.user_data)
			gtk_tooltip_set_text(tooltip, ToUtf8(tn->Hint))
			gtk_tree_view_set_tooltip_row(GTK_TREE_VIEW(widget), tooltip, path)
			Return True
		End Function
		
		Private Sub TreeView.Cell_Editing(cell As GtkCellRenderer Ptr, editable As GtkCellEditable Ptr, path As Const gchar Ptr, user_data As Any Ptr)
			Dim As TreeView Ptr tv = user_data
			Dim As GtkTreeIter iter
			Dim As GtkTreeModel Ptr model = gtk_tree_view_get_model(GTK_TREE_VIEW(tv->Handle))
			If gtk_tree_model_get_iter(model, @iter, gtk_tree_path_new_from_string(path)) Then
				Dim As TreeNode Ptr tn = tv->Nodes.FindByIterUser_Data(iter.user_data)
				Dim As Boolean bCancel
				If tv->OnBeforeLabelEdit Then tv->OnBeforeLabelEdit(*tv->Designer, *tv, *tn, tn->Text, bCancel)
				If bCancel Then
					gtk_cell_renderer_stop_editing(cell, True)
				End If
			End If
		End Sub
		
		Private Sub TreeView.Cell_Edited(renderer As GtkCellRendererText Ptr, path As gchar Ptr, new_text As gchar Ptr, user_data As Any Ptr)
			Dim As TreeView Ptr tv = user_data
			Dim As GtkTreeIter iter
			Dim As GtkTreeModel Ptr model = gtk_tree_view_get_model(GTK_TREE_VIEW(tv->Handle))
			If gtk_tree_model_get_iter(model, @iter, gtk_tree_path_new_from_string(path)) Then
				Dim As TreeNode Ptr tn = tv->Nodes.FindByIterUser_Data(iter.user_data)
				Dim As Boolean bCancel
				If tv->OnAfterLabelEdit Then tv->OnAfterLabelEdit(*tv->Designer, *tv, *tn, *new_text, bCancel)
				If Not bCancel Then
					gtk_tree_store_set(GTK_TREE_STORE(model), @iter, 1, ToUtf8(*new_text), -1)
				End If
			End If
		End Sub
		
		Private Function TreeView.TestCollapseRow(tree_view As GtkTreeView Ptr, iter As GtkTreeIter Ptr, path As GtkTreePath Ptr, user_data As Any Ptr) As Boolean
			Dim As TreeView Ptr tv = user_data
			If tv Then
				Dim bCancel As Boolean
				If tv->OnNodeCollapsing Then tv->OnNodeCollapsing(*tv->Designer, *tv, *tv->Nodes.FindByIterUser_Data(iter->user_data), bCancel)
				If bCancel Then Return True
			End If
			Return False
		End Function
		
		Private Function TreeView.TestExpandRow(tree_view As GtkTreeView Ptr, iter As GtkTreeIter Ptr, path As GtkTreePath Ptr, user_data As Any Ptr) As Boolean
			Dim As TreeView Ptr tv = user_data
			If tv Then
				Dim bCancel As Boolean
				If tv->OnNodeExpanding Then tv->OnNodeExpanding(*tv->Designer, *tv, *tv->Nodes.FindByIterUser_Data(iter->user_data), bCancel)
				If bCancel Then Return True
			End If
			Return False
		End Function
		
		Private Function TreeView.RowCollapsed(tree_view As GtkTreeView Ptr, iter As GtkTreeIter Ptr, path As GtkTreePath Ptr, user_data As Any Ptr) As Boolean
			Dim As TreeView Ptr tv = user_data
			If tv Then
				If tv->OnNodeCollapsed Then tv->OnNodeCollapsed(*tv->Designer, *tv, *tv->Nodes.FindByIterUser_Data(iter->user_data))
			End If
			Return False
		End Function
		
		Private Function TreeView.RowExpanded(tree_view As GtkTreeView Ptr, iter As GtkTreeIter Ptr, path As GtkTreePath Ptr, user_data As Any Ptr) As Boolean
			Dim As TreeView Ptr tv = user_data
			If tv Then
				If tv->OnNodeExpanded Then tv->OnNodeExpanded(*tv->Designer, *tv, *tv->Nodes.FindByIterUser_Data(iter->user_data))
			End If
			Return False
		End Function
	#endif
	
	Private Constructor TreeView
		Nodes.Clear
		Nodes.Parent = @This
		FEnabled = True
		FVisible = True
		With This
			.Child             = @This
			#ifdef __USE_GTK__
				Dim As GtkTreeViewColumn Ptr col = gtk_tree_view_column_new()
				Dim As GtkCellRenderer Ptr renderpixbuf = gtk_cell_renderer_pixbuf_new()
				rendertext = gtk_cell_renderer_text_new()
				scrolledwidget = gtk_scrolled_window_new(NULL, NULL)
				gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolledwidget), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
				TreeStore = gtk_tree_store_new(2, G_TYPE_STRING, G_TYPE_STRING)
				widget = gtk_tree_view_new_with_model(GTK_TREE_MODEL(TreeStore))
				gtk_container_add(GTK_CONTAINER(scrolledwidget), widget)
				TreeSelection = gtk_tree_view_get_selection(GTK_TREE_VIEW(widget))
				
				gtk_tree_view_column_pack_start(col, renderpixbuf, False)
				gtk_tree_view_column_add_attribute(col, renderpixbuf, ToUtf8("icon_name"), 0)
				'gtk_tree_view_append_column(GTK_TREE_VIEW(widget), colpixbuf)
				
				gtk_tree_view_column_pack_start(col, rendertext, True)
				gtk_tree_view_column_add_attribute(col, rendertext, ToUtf8("text"), 1)
				gtk_tree_view_append_column(GTK_TREE_VIEW(widget), col)
				
				gtk_tree_view_set_headers_visible(GTK_TREE_VIEW(widget), False)
				gtk_tree_view_set_enable_tree_lines(GTK_TREE_VIEW(widget), True)
				#ifdef __USE_GTK3__
					gtk_widget_set_has_tooltip(widget, True)
				#endif
				
				g_signal_connect(G_OBJECT(rendertext), "edited", G_CALLBACK(@Cell_Edited), @This)
				g_signal_connect(G_OBJECT(rendertext), "editing-started", G_CALLBACK(@Cell_Editing), @This)
				g_signal_connect(GTK_TREE_VIEW(widget), "button-release-event", G_CALLBACK(@TreeView_ButtonRelease), @This)
				g_signal_connect(widget, "row-activated", G_CALLBACK(@TreeView_RowActivated), @This)
				g_signal_connect(widget, "query-tooltip", G_CALLBACK(@TreeView_QueryTooltip), @This)
				g_signal_connect(G_OBJECT(TreeSelection), "changed", G_CALLBACK (@TreeView_SelectionChanged), @This)
				g_signal_connect(GTK_TREE_VIEW(widget), "test-collapse-row", G_CALLBACK(@TestCollapseRow), @This)
				g_signal_connect(GTK_TREE_VIEW(widget), "test-expand-row", G_CALLBACK(@TestExpandRow), @This)
				g_signal_connect(GTK_TREE_VIEW(widget), "row-collapsed", G_CALLBACK(@RowCollapsed), @This)
				g_signal_connect(GTK_TREE_VIEW(widget), "row-expanded", G_CALLBACK(@RowExpanded), @This)
				This.RegisterClass "TreeView", @This
			#else
				.OnHandleIsAllocated = @HandleIsAllocated
				.OnHandleIsDestroyed = @HandleIsDestroyed
				.RegisterClass "TreeView", WC_TREEVIEW
				.ChildProc         = @WndProc
				WLet(FClassAncestor, WC_TREEVIEW)
				.ExStyle           = WS_EX_CLIENTEDGE
				.Style             = WS_CHILD Or WS_VISIBLE Or TVS_HASLINES Or TVS_LINESATROOT Or TVS_HASBUTTONS
				.BackColor       = GetSysColor(COLOR_WINDOW) 'David Change
				FDefaultBackColor = .BackColor
				.DoubleBuffered = True
			#endif
			BorderStyle = BorderStyles.bsClient
			WLet(FClassName, "TreeView")
			FTabIndex          = -1
			FTabStop = True
			.Width             = 121
			.Height            = 121
		End With
	End Constructor
	
	Private Destructor TreeView
		Nodes.Clear
		#ifdef __USE_GTK__
			
		#else
			UnregisterClass "TreeView", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
