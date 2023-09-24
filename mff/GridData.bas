'################################################################################
'#  GridData.bi                                                             #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################
#include once "GridData.bi"
#include once "Application.bi"
#include once "vbcompat.bi"

Namespace My.Sys.Forms
	#ifndef __USE_GTK__
		Private Function GridDataItem.GetItemIndex() As Integer
			'        Return Index '
			Var nItem = ListView_GetItemCount(Parent->Handle)
			For i As Integer = 0 To nItem - 1
				lviItem.mask = LVIF_PARAM
				lviItem.iItem = i
				lviItem.iSubItem   = 0
				ListView_GetItem(Parent->Handle, @lviItem)
				If lviItem.lParam = Cast(LPARAM, @This) Then
					Return i
				End If
			Next i
			Return -1
		End Function
	#endif
	
	Private Sub GridDataItem.Collapse
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->Handle AndAlso Cast(GridData Ptr, Parent)->TreeStore Then
				Dim As GtkTreePath Ptr TreePath = gtk_tree_path_new_from_string(gtk_tree_model_get_string_from_iter(GTK_TREE_MODEL(Cast(GridData Ptr, Parent)->TreeStore), @TreeIter))
				gtk_tree_view_collapse_row(GTK_TREE_VIEW(Parent->Handle), TreePath)
				gtk_tree_path_free(TreePath)
			End If
		#else
			Var ItemIndex = This.GetItemIndex()
			If ItemIndex <> -1 Then
				State = 1
				Var nItem = ListView_GetItemCount(Parent->Handle)
				Var i = ItemIndex + 1
				Do While i < nItem
					lviItem.mask = LVIF_INDENT
					lviItem.iItem = i
					lviItem.iSubItem   = 0
					ListView_GetItem(Parent->Handle, @lviItem)
					If lviItem.iIndent > FIndent Then
						ListView_DeleteItem(Parent->Handle, i)
						nItem -= 1
					ElseIf lviItem.iIndent <= FIndent Then
						Exit Do
					End If
				Loop
			End If
		#endif
		FExpanded = False
	End Sub
	
	Private Sub GridDataItem.Expand
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->Handle AndAlso Cast(GridData Ptr, Parent)->TreeStore Then
				Dim As GtkTreePath Ptr TreePath = gtk_tree_path_new_from_string(gtk_tree_model_get_string_from_iter(GTK_TREE_MODEL(Cast(GridData Ptr, Parent)->TreeStore), @TreeIter))
				gtk_tree_view_expand_row(GTK_TREE_VIEW(Parent->Handle), TreePath, False)
				gtk_tree_path_free(TreePath)
			End If
		#else
			If Parent AndAlso Parent->Handle Then
				State = 2
				Var ItemIndex = This.GetItemIndex
				If ItemIndex <> -1 Then
					For i As Integer = 0 To Items.Count - 1
						lviItem.mask = LVIF_TEXT Or LVIF_IMAGE Or LVIF_STATE Or LVIF_INDENT Or LVIF_PARAM
						lviItem.pszText  = @Items.Item(i)->Text(0)
						lviItem.cchTextMax = Len(Items.Item(i)->Text(0))
						lviItem.iItem = ItemIndex + i + 1
						lviItem.iImage   = Items.Item(i)->FImageIndex
						If Items.Item(i)->Items.Count > 0 Then
							lviItem.state   = INDEXTOSTATEIMAGEMASK(1)
							Items.Item(i)->FExpanded = False
						Else
							lviItem.state   = 0
						End If
						lviItem.stateMask = LVIS_STATEIMAGEMASK
						lviItem.iIndent   = Items.Item(i)->Indent
						lviItem.lParam = Cast(LPARAM, Items.Item(i))
						ListView_InsertItem(Parent->Handle, @lviItem)
						For j As Integer = 1 To Cast(GridData Ptr, Parent)->Columns.Count - 1
							Dim As LVITEM lvi1
							lvi1.mask = LVIF_TEXT
							lvi1.iItem = ItemIndex + i + 1
							lvi1.iSubItem   = j
							lvi1.pszText    = @Items.Item(i)->Text(j)
							lvi1.cchTextMax = Len(Items.Item(i)->Text(j))
							ListView_SetItem(Parent->Handle, @lvi1)
						Next
					Next
				End If
			End If
		#endif
		FExpanded = True
	End Sub
	
	Private Function GridDataItem.IsExpanded As Boolean
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->Handle AndAlso Cast(GridData Ptr, Parent)->TreeStore Then
				Dim As GtkTreePath Ptr TreePath = gtk_tree_path_new_from_string(gtk_tree_model_get_string_from_iter(GTK_TREE_MODEL(Cast(GridData Ptr, Parent)->TreeStore), @TreeIter))
				FExpanded = gtk_tree_view_row_expanded(GTK_TREE_VIEW(Parent->Handle), TreePath)
			End If
			Return FExpanded
		#else
			Return FExpanded
			'If Parent AndAlso Parent->Handle Then Return TreeView_GetItemState(Parent->Handle, Handle, TVIS_EXPANDED)
		#endif
	End Function
	
	Private Function GridDataItem.Index As Integer
		If FParentItem <> 0 Then
			Return FParentItem->Items.IndexOf(@This)
		ElseIf Parent <> 0 Then
			Return Cast(GridData Ptr, Parent)->ListItems.IndexOf(@This)
		Else
			Return -1
		End If
	End Function
	
	Private Sub GridDataItem.SelectItem
		#ifdef __USE_GTK__
			If Parent AndAlso Cast(GridData Ptr, Parent)->TreeSelection Then
				gtk_tree_selection_select_iter(Cast(GridData Ptr, Parent)->TreeSelection, @TreeIter)
			End If
		#else
			If Parent AndAlso Parent->Handle Then
				Var ItemIndex = This.GetItemIndex
				If ItemIndex = -1 Then Exit Sub
				Dim lvi As LVITEM
				lvi.iItem = Index
				lvi.iSubItem   = 0
				lvi.state    = LVIS_SELECTED
				lvi.stateMask = LVNI_SELECTED
				ListView_SetItem(Parent->Handle, @lvi)
			End If
		#endif
	End Sub
	
	Private Property GridDataItem.BackColor(iSubItem As Integer)As Integer
		If FSubItems.Count>0 AndAlso FSubItems.Count > iSubItem Then
			If mCellBackColor(iSubItem)<=0 Then mCellBackColor(iSubItem)=Parent->BackColor
			Return mCellBackColor(iSubItem)
		Else
			Return clWhite
		End If
	End Property
	Private Property GridDataItem.BackColor(iSubItem As Integer,Value As Integer)
		If FSubItems.Count > iSubItem Then mCellBackColor(iSubItem) = Value
	End Property
	
	Private Property GridDataItem.ForeColor(iSubItem As Integer)As Integer
		If FSubItems.Count > iSubItem Then
			If mCellForeColor(iSubItem)<=0 Then mCellForeColor(iSubItem)=clBlack
			Return mCellForeColor(iSubItem)
		Else
			Return clBlack
		End If
	End Property
	Private Property GridDataItem.ForeColor(iSubItem As Integer,Value As Integer)
		If FSubItems.Count > iSubItem Then mCellForeColor(iSubItem) = Value
	End Property
	
	Private Property GridDataItem.Text(iSubItem As Integer) ByRef As WString
		If FSubItems.Count > iSubItem Then
			Return FSubItems.Item(iSubItem)
		Else
			Return WStr("")
		End If
	End Property
	Private Property GridDataItem.Text(iSubItem As Integer, ByRef Value As WString)
		WLet(FText, Value)
		For i As Integer = FSubItems.Count To iSubItem
			FSubItems.Add ""
		Next
		FSubItems.Item(iSubItem) =Value
		If iSubItem=0 Then  'Init
			ReDim mCellBackColor(0 To FSubItems.Count)
			ReDim mCellForeColor(0 To FSubItems.Count)
		ElseIf UBound(mCellBackColor)< FSubItems.Count Then
			ReDim Preserve mCellBackColor(FSubItems.Count)
			ReDim Preserve mCellForeColor(FSubItems.Count)
		End If
		If Parent Then
			#ifdef __USE_GTK__
				If Cast(GridData Ptr, Parent)->TreeStore Then
					gtk_tree_store_set (Cast(GridData Ptr, Parent)->TreeStore, @TreeIter, iSubItem + 1, ToUtf8(Value), -1)
				End If
			#else
				'				If Parent AndAlso Parent->Handle Then
				'					Var ItemIndex = This.GetItemIndex
				'					If ItemIndex = -1 Then Exit Property
				'					lviItem.Mask = LVIF_TEXT
				'					lviItem.iItem = ItemIndex
				'					lviItem.iSubItem   = iSubItem
				'					lviItem.pszText    = FText
				'					lviItem.cchTextMax = Len(*FText)
				'					ListView_SetItem(Parent->Handle, @lviItem)
				'				End If
			#endif
		End If
	End Property
	
	Private Property GridDataItem.State As Integer
		Return FState
	End Property
	
	Private Property GridDataItem.State(Value As Integer)
		FState = Value
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				Var ItemIndex = GetItemIndex
				If ItemIndex = -1 Then Exit Property
				lviItem.mask = LVIF_STATE
				lviItem.iItem = ItemIndex
				lviItem.iSubItem   = 0
				lviItem.state    = INDEXTOSTATEIMAGEMASK(Value)
				lviItem.stateMask = LVIS_STATEIMAGEMASK
				ListView_SetItem(Parent->Handle, @lviItem)
			End If
		#endif
	End Property
	
	Private Property GridDataItem.Locked(Value As Boolean)
		FLocked = Value
	End Property
	Private Property GridDataItem.Locked As Boolean
		Return FLocked
	End Property
	
	Private Property GridDataItem.Indent As Integer
		Return FIndent
	End Property
	
	Private Property GridDataItem.Indent(Value As Integer)
		FIndent = Value
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				Var ItemIndex = GetItemIndex
				If ItemIndex = -1 Then Exit Property
				lviItem.mask = LVIF_INDENT
				lviItem.iItem = ItemIndex
				lviItem.iSubItem   = 0
				lviItem.iIndent    = Value
				ListView_SetItem(Parent->Handle, @lviItem)
			End If
		#endif
	End Property
	
	Private Property GridDataItem.Hint ByRef As WString
		Return WGet(FHint)
	End Property
	
	Private Property GridDataItem.Hint(ByRef Value As WString)
		WLet(FHint, Value)
	End Property
	
	Private Property GridDataItem.ImageIndex As Integer
		Return FImageIndex
	End Property
	
	Private Property GridDataItem.ImageIndex(Value As Integer)
		If Value <> FImageIndex Then
			FImageIndex = Value
			If Parent Then
				With QControl(Parent)
					'.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
				End With
			End If
		End If
	End Property
	
	Private Property GridDataItem.SelectedImageIndex As Integer
		Return FImageIndex
	End Property
	
	Private Property GridDataItem.SelectedImageIndex(Value As Integer)
		If Value <> FSelectedImageIndex Then
			FSelectedImageIndex = Value
			If Parent Then
				With QControl(Parent)
					'.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
				End With
			End If
		End If
	End Property
	
	Private Property GridDataItem.Visible As Boolean
		Return FVisible
	End Property
	
	Private Property GridDataItem.ParentItem As GridDataItem Ptr
		Return FParentItem
	End Property
	
	Private Property GridDataItem.ParentItem(Value As GridDataItem Ptr)
		FParentItem = Value
	End Property
	
	Private Property GridDataItem.ImageKey ByRef As WString
		Return WGet(FImageKey)
	End Property
	
	Private Property GridDataItem.ImageKey(ByRef Value As WString)
		'If Value <> *FImageKey Then
		WLet(FImageKey, Value)
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				gtk_tree_store_set (Cast(GridData Ptr, Parent)->TreeStore, @TreeIter, 0, ToUtf8(Value), -1)
			End If
		#else
			If Parent Then
				With QControl(Parent)
					'.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
				End With
			End If
		#endif
		'End If
	End Property
	
	Private Property GridDataItem.SelectedImageKey ByRef As WString
		Return WGet(FImageKey)
	End Property
	
	Private Property GridDataItem.SelectedImageKey(ByRef Value As WString)
		'If Value <> *FSelectedImageKey Then
		WLet(FSelectedImageKey, Value)
		If Parent Then
			With QControl(Parent)
				'.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
			End With
		End If
		'End If
	End Property
	
	Private Property GridDataItem.Visible(Value As Boolean)
		If Value <> FVisible Then
			FVisible = Value
			#ifndef __USE_GTK__
				If Parent AndAlso Parent->Handle Then
					Var ItemIndex = GetItemIndex
					If ItemIndex = -1 Then Exit Property
					If Value = False Then
						ListView_DeleteItem(Parent->Handle, ItemIndex)
					End If
				End If
			#endif
		End If
	End Property
	
	Private Operator GridDataItem.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor GridDataItem
		Items.Clear
		Items.Parent = Parent
		Items.ParentItem = @This
		FHint = 0
		FText = 0
		FVisible    = 1
		Text(0)    = ""
		Hint       = ""
		FImageIndex = -1
		FSelectedImageIndex = -1
		FSmallImageIndex = -1
		ReDim mCellBackColor(0)
		ReDim mCellForeColor(0)
	End Constructor
	
	Private Destructor GridDataItem
		Items.Clear
		WDeAllocate(FHint)
		WDeAllocate(FText)
		WDeAllocate(FImageKey)
		WDeAllocate(FSelectedImageKey)
		WDeAllocate(FSmallImageKey)
		Erase mCellBackColor
		Erase mCellForeColor
	End Destructor
	
	Private Sub GridDataColumn.SelectItem
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then ListView_SetSelectedColumn(Parent->Handle, Index)
		#endif
	End Sub
	
	Private Property GridDataColumn.Text ByRef As WString
		Return WGet(FText)
	End Property
	
	Private Property GridDataColumn.Text(ByRef Value As WString)
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
	
	Private Property GridDataColumn.ColWidth As Integer
		Return FColWidth
	End Property
	
	Private Property GridDataColumn.ColWidth(Value As Integer)
		FColWidth = Value
		#ifdef __USE_GTK__
			#ifdef __USE_GTK3__
				If This.Column Then gtk_tree_view_column_set_fixed_width(This.Column, Max(-1, Value))
			#else
				If This.Column Then gtk_tree_view_column_set_fixed_width(This.Column, Max(1, Value))
			#endif
		#else
			If Parent AndAlso Parent->Handle Then
				Dim lvc As LVCOLUMN
				lvc.mask = LVCF_WIDTH Or LVCF_SUBITEM
				lvc.iSubItem = Index
				lvc.cx = Value
				ListView_SetColumn(Parent->Handle, Index, @lvc)
			End If
		#endif
	End Property
	
	Private Property GridDataColumn.ControlType As Integer
		If FControlType < 0 Or FControlType > CT_TextBox Then FControlType = CT_TextBox
		Return FControlType
	End Property
	
	Private Property GridDataColumn.ControlType(Value As Integer)
		If Value < 0 Or Value> CT_TextBox Then Value = CT_TextBox
		FControlType = Value
	End Property
	
	Private Property GridDataColumn.DataType As Integer
		If FDataType < 0 Or FDataType> DT_String Then FDataType = DT_String
		Return FDataType
	End Property
	Private Property GridDataColumn.DataType(Value As Integer)
		If Value < 0 Or Value > DT_String Then Value= DT_String
		FDataType = Value
	End Property
	
	Private Property GridDataColumn.Locked(Value As Boolean)
		FLocked = Value
	End Property
	
	Private Property GridDataColumn.Locked As Boolean
		Return FLocked
	End Property
	
	Private Property GridDataColumn.SortOrder(Value As SortStyle)
		FSortOrder = Value
	End Property
	
	Private Property GridDataColumn.SortOrder As SortStyle
		Return FSortOrder
	End Property
	
	Private Property GridDataColumn.MuiltLine As Boolean
		Return FMuiltLine
	End Property
	
	Private Property GridDataColumn.MuiltLine(Value As Boolean)
		FMuiltLine = Value
	End Property
	
	Private Property GridDataColumn.Format As ColumnFormat
		Return FFormat
	End Property
	
	Private Property GridDataColumn.Format(Value As ColumnFormat)
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
	
	Private Property GridDataColumn.FormatHeader As ColumnFormat
		Return FFormatHeader
	End Property
	
	Private Property GridDataColumn.FormatHeader(Value As ColumnFormat)
		FFormatHeader = Value
	End Property
	
	Private Property GridDataColumn.Hint ByRef As WString
		Return WGet(FHint)
	End Property
	
	Private Property GridDataColumn.Hint(ByRef Value As WString)
		WLet(FHint, Value)
	End Property
	
	Private Property GridDataColumn.GridEditComboItem ByRef As WString
		If FGridEditComboItem > 0 Then Return *FGridEditComboItem Else Return ""
	End Property
	
	Private Property GridDataColumn.GridEditComboItem(ByRef Value As WString)
		WLet(FGridEditComboItem, Value)
	End Property
	
	Private Property GridDataColumn.ImageIndex As Integer
		Return FImageIndex
	End Property
	
	Private Property GridDataColumn.ImageIndex(Value As Integer)
		If Value <> FImageIndex Then
			FImageIndex = Value
			If Parent Then
				With QControl(Parent)
					'.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
				End With
			End If
		End If
	End Property
	
	Private Property GridDataColumn.Visible As Boolean
		Return FVisible
	End Property
	
	Private Property GridDataColumn.Visible(Value As Boolean)
		If Value <> FVisible Then
			FVisible = Value
			If Parent Then
				With QControl(Parent)
					'.Perform(TB_HIDEBUTTON, FCommandID, MakeLong(NOT FVisible, 0))
				End With
			End If
		End If
	End Property
	
	Private Operator GridDataColumn.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor GridDataColumn
		FHint = 0
		FText = 0
		FVisible    = 1
		Text    = ""
		Hint       = ""
		FImageIndex = -1
		FGridEditComboItem =0
	End Constructor
	
	Private Destructor GridDataColumn
		If FHint Then _Deallocate(FHint)
		If FText Then _Deallocate(FText)
		If FGridEditComboItem Then _Deallocate(FGridEditComboItem)
	End Destructor
	
	Private Property GridDataItems.Count As Integer
		Return FItems.Count
	End Property
	
	Private Property GridDataItems.Count(Value As Integer)
	End Property
	
	Private Property GridDataItems.Item(Index As Integer) As GridDataItem Ptr
		If Index >= 0 AndAlso Index < FItems.Count Then
			Return FItems.Items[Index]
		End If
	End Property
	
	Private Property GridDataItems.Item(Index As Integer, Value As GridDataItem Ptr)
		If Index >= 0 AndAlso Index < FItems.Count Then
			FItems.Items[Index] = Value
		End If
	End Property
	
	#ifdef __USE_GTK__
		Private Function GridDataItems.FindByIterUser_Data(User_Data As Any Ptr) As GridDataItem Ptr
			If ParentItem AndAlso ParentItem->TreeIter.user_data = User_Data Then Return ParentItem
			For i As Integer = 0 To FItems.Count - 1
				PItem = Item(i)->Items.FindByIterUser_Data(User_Data)
				If PItem <> 0 Then Return PItem
			Next i
			Return 0
		End Function
	#else
		Private Function GridDataItems.FindByHandle(Value As LPARAM) As GridDataItem Ptr
			If ParentItem AndAlso ParentItem->HANDLE = Value Then Return ParentItem
			For i As Integer = 0 To FItems.Count - 1
				PItem = Item(i)->Items.FindByHandle(Value)
				If PItem <> 0 Then Return PItem
			Next i
			Return 0
		End Function
	#endif
	
	Private Property GridDataItems.ParentItem As GridDataItem Ptr
		Return FParentItem
	End Property
	
	Private Property GridDataItems.ParentItem(Value As GridDataItem Ptr)
		FParentItem = Value
	End Property
	
	Private Function GridDataItems.Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, tLocked As Boolean=False, Indent As Integer = 0) As GridDataItem Ptr
		PItem = _New(GridDataItem)
		FItems.Add PItem
		With *PItem
			.ImageIndex     = FImageIndex
			.Text(0)        = FCaption
			.State        = State
			.Locked         = tLocked
			If ParentItem Then
				.Indent        = ParentItem->Indent + 1
			Else
				.Indent        = 0
			End If
			.Parent         = Parent
			#ifndef __USE_GTK__
				.HANDLE = Cast(LPARAM, PItem)
			#endif
			.Items.Parent         = Parent
			.ParentItem        = ParentItem
			If FItems.Count = 1 AndAlso ParentItem Then
				ParentItem->State = IIf(ParentItem->IsExpanded, 2, 1)
			End If
			#ifdef __USE_GTK__
				If Parent AndAlso Cast(GridData Ptr, Parent)->TreeStore Then
					Cast(GridData Ptr, Parent)->Init
					If ParentItem <> 0 Then
						gtk_tree_store_append (Cast(GridData Ptr, Parent)->TreeStore, @PItem->TreeIter, @.ParentItem->TreeIter)
					Else
						gtk_tree_store_append (Cast(GridData Ptr, Parent)->TreeStore, @PItem->TreeIter, NULL)
					End If
					gtk_tree_store_set (Cast(GridData Ptr, Parent)->TreeStore, @PItem->TreeIter, 1, ToUtf8(FCaption), -1)
				End If
				PItem->Text(0) = FCaption
			#else
				If Parent AndAlso Parent->Handle AndAlso (ParentItem = 0 OrElse ParentItem->IsExpanded) Then
					lviItems.Mask = LVIF_TEXT Or LVIF_IMAGE Or LVIF_STATE Or LVIF_INDENT Or LVIF_PARAM
					lviItems.pszText  = @FCaption
					lviItems.cchTextMax = Len(FCaption)
					lviItems.iItem = FItems.Count - 1
					lviItems.iSubItem = 0
					lviItems.iImage   = FImageIndex
					lviItems.State   = INDEXTOSTATEIMAGEMASK(State)
					lviItems.stateMask = LVIS_STATEIMAGEMASK
					lviItems.iIndent   = .Indent
					lviItems.LParam = Cast(LPARAM, PItem)
					ListView_InsertItem(Parent->Handle, @lviItems)
				End If
			#endif
		End With
		Return PItem
	End Function
	
	Private Function GridDataItems.Add(ByRef FCaption As WString = "", ByRef FImageKey As WString, State As Integer = 0, tLocked As Boolean=False, Indent As Integer = 0) As GridDataItem Ptr
		If Parent AndAlso Cast(GridData Ptr, Parent)->Images Then
			PItem = Add(FCaption, Cast(GridData Ptr, Parent)->Images->IndexOf(FImageKey), State, tLocked, Indent)
		Else
			PItem = Add(FCaption, -1, State, tLocked, Indent)
		End If
		If PItem Then PItem->ImageKey = FImageKey
		Return PItem
	End Function
	
	Private Function GridDataItems.Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, tLocked As Boolean=False, Indent As Integer = 0) As GridDataItem Ptr
		Dim As GridDataItem Ptr PItem
		#ifndef __USE_GTK__
			Dim As LVITEM lvi
		#endif
		PItem = _New(GridDataItem)
		FItems.Insert Index, PItem
		With *PItem
			.ImageIndex     = FImageIndex
			.Text(0)        = FCaption
			.State          = State
			.Locked         = tLocked
			If ParentItem Then
				.Indent        = ParentItem->Indent + 1
			Else
				.Indent        = 0
			End If
			#ifndef __USE_GTK__
				.HANDLE 		= Cast(LPARAM, PItem)
			#endif
			.Parent         = Parent
			.Items.Parent         = Parent
			.ParentItem        = Cast(GridDataItem Ptr, ParentItem)
			If FItems.Count = 1 AndAlso ParentItem Then
				ParentItem->State = IIf(ParentItem->IsExpanded, 2, 1)
			End If
			#ifdef __USE_GTK__
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
	
	Private Sub GridDataItems.Remove(Index As Integer)
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				gtk_tree_store_remove(Cast(GridData Ptr, Parent)->TreeStore, @This.Item(Index)->TreeIter)
			End If
		#else
			If Parent AndAlso Parent->Handle Then
				Item(Index)->Visible = False
				ListView_DeleteItem(Parent->Handle, Index)'David Change
			End If
		#endif
		FItems.Remove Index
	End Sub
	
	'	#IfNDef __USE_GTK__
	'		Private Function CompareFunc(lParam1 As LPARAM, lParam2 As LPARAM, lParamSort As LPARAM) As Long
	'			Return 0
	'		End Function
	'	#EndIf
	
	'    Private Sub GridDataItems.Sort
	'		#IfNDef __USE_GTK__
	'			If Parent AndAlso Parent->Handle Then
	'				Parent->Perform LVM_SORTITEMS, 0, @CompareFunc
	'				ListView_SortItems
	'			End If
	'		#EndIf
	'    End Sub
	
	Private Function GridDataItems.IndexOf(ByRef FItem As GridDataItem Ptr) As Integer
		Return FItems.IndexOf(FItem)
	End Function
	
	Private Function GridDataItems.IndexOf(ByRef Caption As WString, ByVal WholeWords As Boolean = True, ByVal MatchCase As Boolean = True) As Integer
		For i As Integer = 0 To FItems.Count - 1
			If WholeWords Then
				If MatchCase Then
					If QGridDataItem(FItems.Items[i]).Text(0) = Caption Then Return i
				Else
					If LCase(QGridDataItem(FItems.Items[i]).Text(0)) = LCase(Caption) Then Return i
				End If
			Else
				If MatchCase Then
					If InStr(QGridDataItem(FItems.Items[i]).Text(0), Caption) Then Return i
				Else
					If InStr(LCase(QGridDataItem(FItems.Items[i]).Text(0)), LCase(Caption)) Then Return i
				End If
			End If
		Next i
		Return -1
	End Function
	
	Private Function GridDataItems.Contains(ByRef Caption As WString, ByVal WholeWords As Boolean = True, ByVal MatchCase As Boolean = True) As Boolean
		Return IndexOf(Caption, WholeWords, MatchCase) <> -1
	End Function
	
	Private Sub GridDataItems.Clear
		If FItems.Count<1 Then Exit Sub
		#ifdef __USE_GTK__
			If Parent AndAlso Cast(GridData Ptr, Parent)->TreeStore Then gtk_tree_store_clear(Cast(GridData Ptr, Parent)->TreeStore)
		#else
			For i As Integer = FItems.Count - 1  To 1 Step -1 'if to 0 will be hanging
				_Delete(Cast(GridDataItem Ptr, FItems.Items[i]))
				FItems.Remove i
			Next
			Item(0)->Text(0)=Str(BLANKROW)
			'FItems.Clear 'will be hanging
			If Parent AndAlso Parent->Handle Then SendMessage Parent->Handle, LVM_DELETEALLITEMS, 0, 0
		#endif
		
	End Sub
	
	Private Operator GridDataItems.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor GridDataItems
		This.Clear
	End Constructor
	
	Private Destructor GridDataItems
		This.Clear
	End Destructor
	
	Private Property GridDataColumns.Count As Integer
		Return FColumns.Count
	End Property
	
	Private Property GridDataColumns.Count(Value As Integer)
	End Property
	
	Private Property GridDataColumns.Column(Index As Integer) As GridDataColumn Ptr
		Return QGridDataColumn(FColumns.Items[Index])
	End Property
	
	Private Property GridDataColumns.Column(Index As Integer, Value As GridDataColumn Ptr)
		'QGridDataColumn(FColumns.Items[Index]) = Value
		FColumns.Items[Index] = Value
	End Property
	
	#ifdef __USE_GTK__
		Private Sub GridDataColumns.Cell_Edited(renderer As GtkCellRendererText Ptr, path As gchar Ptr, new_text As gchar Ptr, user_data As Any Ptr)
			Dim As GridDataColumn Ptr PColumn = user_data
			If PColumn = 0 Then Exit Sub
			Dim As GridData Ptr lv = Cast(GridData Ptr, PColumn->Parent)
			If lv = 0 Then Exit Sub
			Dim As GtkTreeIter iter
			Dim As GtkTreeModel Ptr model = gtk_tree_view_get_model(GTK_TREE_VIEW(lv->Handle))
			If gtk_tree_model_get_iter(model, @iter, gtk_tree_path_new_from_string(path)) Then
				If lv->OnCellEdited Then lv->OnCellEdited(*lv->Designer, *lv, lv->ListItems.FindByIterUser_Data(iter.user_data), PColumn->Index, *new_text)
				'gtk_tree_store_set(lv->TreeStore, @iter, PColumn->Index + 1, ToUtf8(*new_text), -1)
			End If
		End Sub
		
		Private Sub GridDataColumns.Cell_Editing(cell As GtkCellRenderer Ptr, editable As GtkCellEditable Ptr, path As Const gchar Ptr, user_data As Any Ptr)
			Dim As GridDataColumn Ptr PColumn = user_data
			If PColumn = 0 Then Exit Sub
			Dim As GridData Ptr lv = Cast(GridData Ptr, PColumn->Parent)
			If lv = 0 Then Exit Sub
			Dim As GtkTreeIter iter
			Dim As GtkTreeModel Ptr model = gtk_tree_view_get_model(GTK_TREE_VIEW(lv->Handle))
			Dim As Control Ptr CellEditor
			If gtk_tree_model_get_iter(model, @iter, gtk_tree_path_new_from_string(path)) Then
				If lv->OnCellEditing Then lv->OnCellEditing(*lv->Designer, *lv, lv->ListItems.FindByIterUser_Data(iter.user_data), PColumn->Index, CellEditor)
				If CellEditor <> 0 Then editable = GTK_CELL_EDITABLE(CellEditor->Handle)
			End If
		End Sub
	#endif
	
	Private Function GridDataColumns.Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, tFormat As ColumnFormat = cfLeft, tDataType As GridDataTypeEnum = DT_String, tLocked As Boolean = False, tControlType As GridControlTypeEnum = CT_TextBox, ByRef tComboItem As WString = "", tSortOrder As SortStyle = SortStyle.ssSortAscending) As GridDataColumn Ptr
		Dim As GridDataColumn Ptr PColumn
		Dim As Integer Index
		#ifndef __USE_GTK__
			Dim As LVCOLUMN lvc
		#endif
		PColumn = _New(GridDataColumn)
		FColumns.Add PColumn
		Index = FColumns.Count - 1
		With *PColumn
			.ImageIndex     = FImageIndex
			.Text        = FCaption
			.Index = Index
			.ColWidth     = IIf(iWidth < 0, 100, iWidth)
			.Format = tFormat
			.DataType = tDataType
			.Locked = tLocked
			.ControlType = tControlType
			.SortOrder = tSortOrder
			.GridEditComboItem= tComboItem
		End With
		#ifdef __USE_GTK__
			If Parent Then
				With *Cast(GridData Ptr, Parent)
					If .ColumnTypes Then _DeleteSquareBrackets(.ColumnTypes)
					.ColumnTypes = _New(GType[Index + 2])
					For i As Integer = 0 To Index + 1
						.ColumnTypes[i] = G_TYPE_STRING
					Next i
				End With
				PColumn->Column = gtk_tree_view_column_new()
				Dim As GtkCellRenderer Ptr rendertext = gtk_cell_renderer_text_new ()
				'				If ColEditable Then
				'					Dim As GValue bValue '= G_VALUE_INIT
				'					g_value_init_(@bValue, G_TYPE_BOOLEAN)
				'					g_value_set_boolean(@bValue, True)
				'					g_object_set_property(G_OBJECT(rendertext), "editable", @bValue)
				'					g_object_set_property(G_OBJECT(rendertext), "editable-set", @bValue)
				'					g_value_unset(@bValue)
				'					'Dim bTrue As gboolean = True
				'					'g_object_set(rendertext, "mode", GTK_CELL_RENDERER_MODE_EDITABLE, NULL)
				'					'g_object_set(gtk_cell_renderer_text(rendertext), "editable-set", true, NULL)
				'					'g_object_set(rendertext, "editable", bTrue, NULL)
				'				End If
				If Index = 0 Then
					Dim As GtkCellRenderer Ptr renderpixbuf = gtk_cell_renderer_pixbuf_new()
					gtk_tree_view_column_pack_start(PColumn->Column, renderpixbuf, False)
					gtk_tree_view_column_add_attribute(PColumn->Column, renderpixbuf, ToUtf8("icon_name"), 0)
				End If
				g_signal_connect(G_OBJECT(rendertext), "edited", G_CALLBACK (@Cell_Edited), PColumn)
				g_signal_connect(G_OBJECT(rendertext), "editing-started", G_CALLBACK (@Cell_Editing), PColumn)
				gtk_tree_view_column_pack_start(PColumn->Column, rendertext, True)
				gtk_tree_view_column_add_attribute(PColumn->Column, rendertext, ToUtf8("text"), Index + 1)
				gtk_tree_view_column_set_resizable(PColumn->Column, True)
				gtk_tree_view_column_set_title(PColumn->Column, ToUtf8(FCaption))
				gtk_tree_view_append_column(GTK_TREE_VIEW(Cast(GridData Ptr, Parent)->Handle), PColumn->Column)
				#ifdef __USE_GTK3__
					gtk_tree_view_column_set_fixed_width(PColumn->Column, Max(-1, iWidth))
				#else
					gtk_tree_view_column_set_fixed_width(PColumn->Column, Max(1, iWidth))
				#endif
			End If
		#else
			lvc.mask      =LVCF_FMT Or LVCF_IMAGE Or LVCF_WIDTH Or LVCF_TEXT Or LVCF_SUBITEM Or LVCFMT_IMAGE 'LVCF_TEXT |LVCF_WIDTH| LVCF_FMT |LVCF_SUBITEM
			lvc.fmt       =  LVCFMT_LEFT Or LVCFMT_IMAGE Or LVCFMT_COL_HAS_IMAGES Or HDF_OWNERDRAW  'tFormat
			lvc.cx		  = IIf(iWidth < 0, 100, iWidth)
			lvc.iImage   = PColumn->ImageIndex
			lvc.iSubItem = PColumn->Index
			'lvc.pszText  = @FCaption
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
	
	Private Sub GridDataColumns.Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, tFormat As ColumnFormat = cfLeft, tDataType As GridDataTypeEnum = DT_String, tLocked As Boolean = False, tControlType As GridControlTypeEnum = CT_TextBox, ByRef tComboItem As WString = "", tSortOrder As SortStyle= SortStyle.ssSortAscending)
		Dim As GridDataColumn Ptr PColumn
		#ifndef __USE_GTK__
			Dim As LVCOLUMN lvc
		#endif
		PColumn = _New(GridDataColumn)
		FColumns.Insert Index, PColumn
		With *PColumn
			.ImageIndex     = FImageIndex
			.Text        = FCaption
			.Index        = FColumns.Count - 1
			.ColWidth     = IIf(iWidth < 0, 100, iWidth)
			.Format = tFormat
			.DataType =tDataType
			.Locked = tLocked
			.ControlType = tControlType
			.SortOrder = tSortOrder
			.GridEditComboItem= tComboItem
		End With
		#ifndef __USE_GTK__
			lvc.mask      =  LVCF_FMT Or LVCF_WIDTH Or LVCF_TEXT Or LVCF_SUBITEM
			lvc.fmt       =  tFormat
			lvc.cx = IIf(iWidth < 0, 100, iWidth)
			lvc.iImage    = PColumn->ImageIndex
			lvc.iSubItem  = PColumn->Index
			'lvc.pszText  = @FCaption
			lvc.cchTextMax = Len(FCaption)
			If Parent Then
				PColumn->Parent = Parent
				If Parent->Handle Then
					ListView_InsertColumn(Parent->Handle, Index, @lvc)
					ListView_SetColumnWidth(Parent->Handle, Index, iWidth)
				End If
			End If
		#endif
	End Sub
	
	Private Sub GridDataColumns.Remove(Index As Integer)
		FColumns.Remove Index
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				SendMessage Parent->Handle, LVM_DELETECOLUMN, Cast(WPARAM, Index), 0
			End If
		#endif
	End Sub
	
	Private Function GridDataColumns.IndexOf(ByRef FColumn As GridDataColumn Ptr) As Integer
		Return FColumns.IndexOf(FColumn)
	End Function
	
	Private Sub GridDataColumns.Clear
		On Error Goto ErrorHandler
		If FColumns.Count>0 Then
			For i As Integer = FColumns.Count -1 To 0 Step -1
				#ifndef __USE_GTK__
					If Parent AndAlso Parent->Handle Then SendMessage Parent->Handle, LVM_DELETECOLUMN, Cast(WPARAM, i), 0
				#endif
				_Delete(Cast(GridDataColumn Ptr, FColumns.Items[i]))
				FColumns.Remove i
			Next
			FColumns.Clear
		End If
		Exit Sub
		ErrorHandler:
		MsgBox ErrDescription(Err) & " (" & Err & ") " & _
		"in line " & Erl() & " " & _
		"in Private Function " & ZGet(Erfn()) & " " & _
		"in module " & ZGet(Ermn())
	End Sub
	
	Private Operator GridDataColumns.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor GridDataColumns
		This.Clear
	End Constructor
	
	Private Destructor GridDataColumns
		This.Clear
	End Destructor
	
	Private Sub GridData.Init()
		#ifdef __USE_GTK__
			If gtk_tree_view_get_model(GTK_TREE_VIEW(widget)) = NULL Then
				gtk_tree_store_set_column_types(TreeStore, Columns.Count + 1, ColumnTypes)
				gtk_tree_view_set_model(GTK_TREE_VIEW(widget), GTK_TREE_MODEL(TreeStore))
				gtk_tree_view_set_enable_tree_lines(GTK_TREE_VIEW(widget), True)
			End If
		#else
			FLvi.iSubItem=0
			FLvi.iItem=0
			mCol=0: mRow=0
			ListItems.Clear
			Columns.Clear
			GridEditText.Visible=False ' Force refesh windows
			GridEditDateTimePicker.Visible =False
			GridEditComboBox.Visible =False
			
		#endif
	End Sub
	
	Private Sub GridData.EnsureVisible(Index As Integer)
		#ifdef __USE_GTK__
			If GTK_IS_ICON_VIEW(widget) Then
				gtk_icon_view_select_path(GTK_ICON_VIEW(widget), gtk_tree_path_new_from_string(Trim(Str(Index))))
			Else
				If TreeSelection Then
					If Index > -1 AndAlso Index < ListItems.Count Then
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
	
	Private Property GridData.ColumnHeaderHidden As Boolean
		Return FColumnHeaderHidden
	End Property
	
	Private Property GridData.ColumnHeaderHidden(Value As Boolean)
		FColumnHeaderHidden = Value
		#ifdef __USE_GTK__
			gtk_tree_view_set_headers_visible(GTK_TREE_VIEW(widget), Not Value)
		#else
			ChangeStyle LVS_NOCOLUMNHEADER, Value
		#endif
	End Property
	
	Private Property GridData.SingleClickActivate As Boolean
		Return FSingleClickActivate
	End Property
	
	Private Property GridData.SingleClickActivate(Value As Boolean)
		FSingleClickActivate = Value
		#ifdef __USE_GTK__
			#ifdef __USE_GTK3__
				gtk_tree_view_set_activate_on_single_click(GTK_TREE_VIEW(widget), Value)
			#else
				
			#endif
		#else
			
		#Endif
	End Property
	
	Private Property GridData.View As ViewStyle
		#IfnDef __USE_GTK__
			If Handle Then
				FView = ListView_GetView(Handle)
			End If
		#Endif
		Return FView
	End Property
	
	Private Property GridData.View(Value As ViewStyle)
		FView = Value
		#ifndef __USE_GTK__
			If Handle Then Perform LVM_SETVIEW, Cast(wparam, Cast(DWord, Value)), 0
		#endif
	End Property
	
	Private Property GridData.SelectedItem As GridDataItem Ptr
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			If gtk_tree_selection_get_selected(TreeSelection, NULL, @iter) Then
				Return ListItems.FindByIterUser_Data(iter.User_Data)
			End If
		#else
			If Handle Then
				Dim As Integer Item = ListView_GetNextItem(HANDLE, -1, LVNI_SELECTED)
				If Item <> -1 Then Return GetGridDataItem(Item)
			End If
		#endif
		Return 0
	End Property
	
	Private Property GridData.SelectedItemIndex As Integer
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			If gtk_tree_selection_get_selected(TreeSelection, NULL, @iter) Then
				Dim As GridDataItem Ptr lvi = ListItems.FindByIterUser_Data(iter.user_data)
				If lvi <> 0 Then Return lvi->Index
			End If
		#else
			If Handle Then
				Return ListView_GetNextItem(Handle, -1, LVNI_SELECTED)
			End If
		#endif
		Return -1
	End Property
	
	Private Property GridData.SelectedItemIndex(Value As Integer)
		#ifdef __USE_GTK__
			If TreeSelection Then
				If Value = -1 Then
					gtk_tree_selection_unselect_all(TreeSelection)
				ElseIf Value > -1 AndAlso Value < ListItems.Count Then
					gtk_tree_selection_select_iter(TreeSelection, @ListItems.Item(Value)->TreeIter)
					gtk_tree_view_scroll_to_cell(GTK_TREE_VIEW(widget), gtk_tree_model_get_path(GTK_TREE_MODEL(TreeStore), @ListItems.Item(Value)->TreeIter), NULL, False, 0, 0)
				End If
			End If
		#else
			ListView_SetItemState(Handle, Value, LVIS_FOCUSED Or LVIS_SELECTED, LVNI_SELECTED Or LVNI_FOCUSED)
			ListView_EnsureVisible(Handle, Value, True)
		#endif
	End Property
	
	#ifdef __USE_WINAPI__
		Private Property GridData.HandleHeader As HWND
			Return mHandleHeader
		End Property
		Private Property GridData.HandleHeader(Value As HWND)
			mHandleHeader=Value
		End Property
	#endif
	
	Private Sub GridData.SetGridLines(tFocusRect As Integer=-1,tDrawMode As Integer=-1,_
		tColorLine As Integer=-1,tColorLineHeader As Integer=-1,tColorEditBack As Integer=-1,tColorSelected As Integer=-1,_
		tColorHover As Integer=-1,tWidth As Integer=-1,PenMode As Integer=-1)
		If tFocusRect<>-1 Then mGridFocusRect = tFocusRect
		If tDrawMode<>-1 Then mGridLineDrawMode = tDrawMode
		If tColorLine<>-1 Then mGridColorLine = tColorLine
		If tColorLineHeader<>-1 Then mGridColorLineHeader = tColorLineHeader
		If tColorEditBack<>-1 Then mGridColorEditBack = tColorEditBack
		If tWidth<>-1 Then mGridLineWidth = tWidth
		If PenMode<>-1 Then mGridLinePenMode = PenMode
		If tColorSelected<>-1 Then mGridColorSelected=tColorSelected
		If tColorHover<>-1 Then mGridColorHover=tColorHover
	End Sub
	
	Private Property GridData.RowHeightHeader As Integer
		Return  mRowHeightHeader
	End Property
	Private Property GridData.RowHeightHeader(Value As Integer)
		'Must call RowHeightHeader First for the header height. It is not working after Columns.Add
		
		'    Dim As Integer FSizeHeaderSave =mFSizeHeader
		'    Dim As HDC GridDCHeader = GetDc(mHandleHeader)
		mRowHeightHeader=IIf(Value<18,18,Value)
		'    'mRowHeight=(18+(mFSize-8)*1.45
		'mFSize=(mRowHeight-18)/1.45+8
		mFSizeHeader=IIf(Value<18,8,(mRowHeightHeader-18)/1.45+8)
		'    If mFontHandleHeader Then DeleteObject(mFontHandleHeader)
		'    mFontHandleHeader=CreateFontW(-MulDiv(mFSizeHeader,mFCyPixelsHeader,72),0,mFOrientationHeader*mFSizeHeader,mFOrientationHeader*mFSizeHeader,mFBoldsHeader(Abs_(mFBoldHeader)),mFItalicHeader,mFUnderlineHeader,mFStrikeOutHeader,mFCharSetHeader,OUT_TT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,FF_DONTCARE,*mFNameHeader)
		'    SendMessage(mHandleHeader, WM_SETFONT,CUInt(mFontHandleHeader),True) 'enlarge the height of header
		'    SelectObject(GridDCHeader,mFontHandleHeader)
		'    'mFSizeHeader=FSizeHeaderSave
		'    'If mFontHandleHeader Then DeleteObject(mFontHandleHeader)
		'    'mFontHandleHeader=CreateFontW(-MulDiv(mFSizeHeader,mFCyPixelsHeader,72),0,mFOrientationHeader*mFSizeHeader,mFOrientationHeader*mFSizeHeader,mFBoldsHeader(Abs_(mFBoldHeader)),mFItalicHeader,mFUnderlineHeader,mFStrikeOutHeader,mFCharSetHeader,OUT_TT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,FF_DONTCARE,*mFNameHeader)
		'    'SelectObject(GridDCHeader,mFontHandleHeader)
		'
		'    ReleaseDC(mHandleHeader, GridDCHeader)
		'    GetClientRect Handle,@mClientRect
		'    GetClientRect mHandleHeader,@mClientRectHeader
		'    mRowHeightHeader=IIf(Value<18,18,Value)
		'    This.Font.Size=(mRowHeightHeader-18)/1.45+8
	End Property
	
	Private Sub GridData.SetFontHeader(tFontColor As Integer=-1,tFontColorBK As Integer=-1,tNameHeader As WString="",_
		tSizeHeader As Integer=-1,tCharSetHeader As Integer=FontCharset.Default, _
		tBoldsHeader As Boolean=False,tItalicHeader As Boolean=False, _
		tUnderlineHeader As Boolean=False,tStrikeoutHeader As Boolean=False)
		
		If tFontColor<>-1 Then mHeaderForeColor=tFontColor
		If tFontColorBK<>-1 Then mHeaderBackColor=tFontColorBK
		If Len(tNameHeader) > 0 Then WLET(mFNameHeader, tNameHeader)
		If tSizeHeader<>-1 Then mFSizeHeader=tSizeHeader
		mFBoldHeader=tBoldsHeader
		mFItalicHeader =tItalicHeader
		mFUnderlineHeader=tUnderlineHeader
		mFStrikeOutHeader=tStrikeoutHeader
		mFCharSetHeader = tCharSetHeader
		#ifdef __USE_WINAPI__
			If mFontHandleHeader Then DeleteObject(mFontHandleHeader)
			mFontHandleHeader = CreateFontW(-MulDiv(mFSizeHeader, mFCyPixelsHeader, 72), 0, mFOrientationHeader*mFSizeHeader, mFOrientationHeader*mFSizeHeader, mFBoldsHeader(Abs_(mFBoldHeader)), mFItalicHeader, mFUnderlineHeader, mFStrikeOutHeader, mFCharSetHeader, OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, FF_DONTCARE, *mFNameHeader)
		#endif
	End Sub
	
	Private Sub GridData.SetFont(tName As WString="",tSize As Integer=-1,tCharSet As Integer=FontCharset.Default,tBolds As Boolean=False,tItalic As Boolean=False,tUnderline As Boolean=False,tStrikeout As Boolean=False)
		If Len(tName) > 0 Then WLET(mFName, tName)
		If tSize<>-1 Then mFSize=tSize
		mFBold=tBolds
		mFItalic =tItalic
		mFUnderline=tUnderline
		mFStrikeOut=tStrikeout
		mFCharSet = tCharSet
		#ifdef __USE_WINAPI__
			If mFontHandleBody Then DeleteObject(mFontHandleBody)
			mFontHandleBody=CreateFontW(-MulDiv(mFSize,mFCyPixels,72),0,mFOrientation*mFSize,mFOrientation*mFSize,mFBolds(Abs_(mFBold)),mFItalic,mFUnderline,mFStrikeOut,mFCharSet,OUT_TT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,FF_DONTCARE,*mFName)
			If mFontHandleBodyUnderline Then DeleteObject(mFontHandleBodyUnderline)
			mFontHandleBodyUnderline= CreateFontW(-MulDiv(mFSize, mFCyPixels, 72), 0, mFOrientation*mFSize, mFOrientation*mFSize, mFBolds(Abs_(mFBold)), mFItalic, True, mFStrikeOut, mFCharSet, OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, FF_DONTCARE, *mFName)
		#endif
		
	End Sub
	
	Private Property GridData.ShowHoverBar As Boolean
		Return  mShowHoverBar
	End Property
	Private Property GridData.ShowHoverBar(Value As Boolean)
		mShowHoverBar=Value
	End Property
	
	Private Property GridData.ShowSelection As Boolean
		Return  mShowSelection
	End Property
	Private Property GridData.ShowSelection(Value As Boolean)
		mShowSelection=Value
	End Property
	
	Private Property GridData.RowHeight As Integer
		Return  mRowHeight
	End Property
	Private Property GridData.RowHeight(Value As Integer)
		mRowHeight=IIf(Value<18,18,Value)
		'    This.Font.Size=(tRowHeight-18)/1.45+8
		This.ImgListGrid.Height=mRowHeight 'Change Height of body
		This.ImgListGrid.Width=mRowHeight 'Change Height of body
		This.SmallImages  = @ImgListGrid
	End Property
	
	Private Property GridData.SelectedItem(Value As GridDataItem Ptr)
		Value->SelectItem
	End Property
	
	Private Property GridData.SelectedColumn As GridDataColumn Ptr
		#ifndef __USE_GTK__
			If Handle Then
				Return Columns.Column(ListView_GetSelectedColumn(Handle))
			End If
		#endif
		Return 0
	End Property
	
	#ifndef __USE_GTK__
		Private Function GridData.GetGridDataItem(iItem As Integer) As GridDataItem Ptr
			Dim lvi As LVITEM
			lvi.mask = LVIF_PARAM
			lvi.iItem = iItem
			If ListView_GetItem(Handle, @lvi) Then
				Return Cast(GridDataItem Ptr, lvi.lParam)
			End If
			Return 0
		End Function
	#endif
	
	Private Property GridData.Sort As SortStyle
		Return FSortStyle
	End Property
	
	Private Property GridData.Sort(Value As SortStyle)
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
	Private Sub GridData.Refresh()
		' dim as RECT RectCell
		#ifdef __USE_WINAPI__
			GridReDraw(mDrawRowStart, mDrawRowStart + mCountPerPage, mRow, mCol)     '
		#endif
		'PostMessage(Handle, WM_SIZE, 0, 0) 'Force to Refresh. better than GridReDraw because it is not updated sometimes.
	End Sub
	
	Private Sub GridData.SortData(iCol As Integer,tSortStyle As SortStyle)
		If tSortStyle = SortStyle.ssNone Then
			iCol=0
			tSortStyle = SortStyle.ssSortDescending
		End If
		If mSorting Then Exit Sub
		mSorting=True
		Dim As Integer i,j
		Dim tItemCount As Integer
		tItemCount= ListItems.Count'ListItems.Item(j)->Text(iCOl)
		Dim tItem As GridDataItem Ptr
		#ifdef __USE_WINAPI__
			Dim As HCURSOR hCurSave = GetCursor()
			SetCursor(LoadCursor(0, IDC_WAIT))
		#endif
		'print "Sort Start ",time
		If tSortStyle= SortStyle.ssSortDescending Then
			For i = tItemCount -1 To 0  Step -1
				'Skip the blank row marked by ListItems.Item(j)->Text(0))>=BLANKROW
				If Val(ListItems.Item(i)->Text(0))<BLANKROW Then
					For j = 1 To i
						'Print Val(ListItems.Item(j)->Text(0))
						If Columns.Column(iCol)->DataType=DT_Numeric Then
							If Val(ListItems.Item(j)->Text(iCol)) < Val(ListItems.Item(j-1)->Text(iCol)) Then
								'Exchange j - 1, j
								tItem=ListItems.Item(j-1)
								ListItems.Item(j-1)=ListItems.Item(j)
								ListItems.Item(j)=tItem
							End If
						Else
							If LCase(ListItems.Item(j)->Text(iCol)) < LCase(ListItems.Item(j-1)->Text(iCol)) Then
								'Exchange j - 1, j
								tItem=ListItems.Item(j-1)
								ListItems.Item(j-1)=ListItems.Item(j)
								ListItems.Item(j)=tItem
							End If
						End If
					Next
				End If
			Next
		Else
			For i = tItemCount -1 To 0 Step -1
				'Skip the blank row marked by ListItems.Item(j)->Text(0))>=BLANKROW
				If Val(ListItems.Item(i)->Text(0))<BLANKROW Then
					For j = 1 To i
						If Columns.Column(iCol)->DataType=DT_Numeric Then
							If Val(ListItems.Item(j)->Text(iCol)) > Val(ListItems.Item(j-1)->Text(iCol)) Then
								'Exchange j - 1, j
								tItem=ListItems.Item(j-1)
								ListItems.Item(j-1)=ListItems.Item(j)
								ListItems.Item(j)=tItem
							End If
						Else
							If LCase(ListItems.Item(j)->Text(iCOl)) > LCase(ListItems.Item(j-1)->Text(iCOl)) Then
								'Exchange j - 1, j
								tItem=ListItems.Item(j-1)
								ListItems.Item(j-1)=ListItems.Item(j)
								ListItems.Item(j)=tItem
								
							End If
						End If
					Next
				End If
			Next
		End If
		mSorting=False
		'print "Sort End ",time
	End Sub
	
	Private Property GridData.BackColor As Integer
		Return mGridColorBack
	End Property
	Private Property GridData.BackColor(Value As Integer)
		mGridColorBack = Value
	End Property
	
	Private Property GridData.ForeColor As Integer
		Return mGridColorFore
	End Property
	Private Property GridData.ForeColor(Value As Integer)
		mGridColorFore = Value
	End Property
	
	Private Property GridData.SelectedColumn(Value As GridDataColumn Ptr)
		#ifndef __USE_GTK__
			If Handle Then ListView_SetSelectedColumn(Handle, Value->Index)
		#endif
	End Property
	
	Private Property GridData.ShowHint As Boolean
		Return FShowHint
	End Property
	
	Private Property GridData.ShowHint(Value As Boolean)
		FShowHint = Value
	End Property
	
	Private Property GridData.AllowEdit As Boolean
		Return mAllowEdit
	End Property
	Private Property GridData.AllowEdit(Value As Boolean)
		mAllowEdit = Value
	End Property
	
	#ifdef __USE_WINAPI__
		Private Sub GridData.WndProc(ByRef Message As Message)
		End Sub
		
		Private Sub GridData.DrawLine(tDC As HDC, x1 As Integer, y1 As Integer, x2 As Integer, y2 As Integer, lColor As Integer = -1, lWidth As Integer = 1, lLineType As Integer = PS_SOLID)
			Dim pt As LPPOINT
			If lColor <>-1 Then
				Static As  HPEN HPEN,hPenSele
				HPEN = CreatePen(lLineType, lWidth, lColor)
				hPenSele = SelectObject(tDC, HPEN)
				MoveToEx tDC, x1, y1, pt
				LineTo tDC, x2, y2
				SelectObject tDC, hPenSele
				DeleteObject HPEN
			Else
				MoveToEx tDC, x1, y1, pt
				LineTo tDC, x2, y2
			End If
			
		End Sub
		Private Sub GridData.DrawRect(tDc As hDC,R As Rect,FillColor As Integer = -1,tSelctionRow As Integer = -1,tSelctionCol As Integer = -1)
			#ifndef __USE_GTK__
				Static As HBRUSH BSelction
				Static As HBRUSH BCellBack
				Static As Integer FillColorSave
				Dim As LPPOINT lppt
				If tSelctionRow=mRow AndAlso mShowSelection Then
					If BSelction Then DeleteObject BSelction
					If tSelctionCol=mCol Then
						BSelction=CreateSolidBrush(mGridColorEditBack)
					Else
						BSelction=CreateSolidBrush(mGridColorSelected)
					End If
					FillRect tDc,@R,BSelction
				Else
					If FillColor<>FillColorSave  Then
						If BCellBack Then DeleteObject BCellBack
						If FillColor <> -1 Then
							BCellBack = CreateSolidBrush(FillColor)
						Else
							BCellBack = CreateSolidBrush(clWhite)
						End If
					End If
					FillColorSave=FillColor
					'DrawEdge tDc,@R,BDR_RAISEDINNER,BF_FLAT'BF_BOTTOM
					If mGridLineDrawMode = GRIDLINE_None  Then  ' GRIDLINE_None Both GRIDLINE_Vertical GRIDLINE_Horizontal Then
						DrawEdge tDc,@R,BDR_SUNKENOUTER,BF_FLAT
						'InflateRect(@R, -1, -1)
						FillRect tDc,@R,BCellBack
					Else
						FillRect tDc,@R,BCellBack
					End If
				End If
				
				'https://docs.microsoft.com/zh-cn/windows/win32/api/winuser/nf-winuser-drawedge
				'DrawEdge tDc,@R,BDR_RAISEDINNER,BF_BOTTOM
				'MoveToEx tDc,R.Left,R.bottom,lppt
				'LineTo tDc, R.Right,R.bottom
			#endif
		End Sub
		Private Sub GridData.DrawSortArrow(DC As HDC,lX As Integer, lY As Integer,lWidth As Integer, lStep As Integer, nOrientation As SortStyle)
			
			'// Purpose: Renders the Sort/Sub-Sort arrows
			Dim hPenOld         As HPEN
			Dim hPen            As HPEN
			Dim lCount          As Integer
			Dim lVerticalChange As Integer
			Dim x1              As Integer
			Dim x2              As Integer
			Dim y1              As Integer
			Dim pt              As LPPOINT
			'ssNone ssSortAscending ssSortDescending
			If Not nOrientation = SortStyle.ssNone Then
				hPen = CreatePen(PS_SOLID, 1, cl3DDkShadow)
				hPenOld = SelectObject(DC, hPen)
				If nOrientation = SortStyle.ssSortDescending Then
					lVerticalChange = -1
					lY = lY + lStep - 1
				Else
					lVerticalChange = 1
				End If
				
				x1 = lX
				x2 = lWidth
				y1 = lY
				MoveToEx DC, x1, y1, pt
				For lCount = 1 To lStep
					LineTo DC, x1 + x2, y1
					x1 = x1 + 1
					y1 = y1 + lVerticalChange
					x2 = x2 - 2
					MoveToEx DC, x1, y1, pt
				Next lCount
				SelectObject(DC, hPenOld)
				DeleteObject(HPEN)
			End If
			'     ReleaseDC(mHandleHeader, GridDCHeader)
		End Sub
		
		Private Sub GridData.GridReDraw(RowShowStart As Integer, RowShowEnd As Integer, RowHover As Integer = -1, ColHover As Integer = -1, DrawHeaderOnly As Boolean = False)
			'https://blog.csdn.net/hurryboylqs/article/details/5858997
			If ListItems.Count <1 Then Exit Sub 'NO ANY DATA
			Dim As Integer iColCount=Columns.Count-1
			If iColCount<0 OrElse ColHover>iColCount Then Exit Sub 'NO ANY DATA
			Dim As Integer iRow=0, iCol=0,iColEnd=-1,iColStart=-1,iCT=0,GridWidth=0,GridHeight=0
			Dim As Integer iColorBK=0,iForeColor=0
			Dim As SCROLLINFO Si
			Dim As HDC GridDCHeader = GetDC(mHandleHeader)
			Dim As HDC memDCHeader =CreateCompatibleDC(GridDCHeader)
			Dim As HBITMAP BmpHeader
			If GridDCHeader<=0 OrElse memDCHeader <= 0  Then Exit Sub
			Dim As Short uFormatHeader,uFormat
			Dim As Rect REC(iColCount),RectHeader,RectCell
			Dim As WString Ptr sText
			'ShowScrollBar(Handle, SB_HORZ,True)'  .SB_HORZ, @Si) 'SB_VERT HORZ
			
			If RowShowEnd<0 OrElse RowShowStart<0 OrElse mDrawRowStart <=0 OrElse mCountPerPage <=0 Then
				mCountPerPage = ListView_GetCountPerPage(HANDLE)
				mDrawRowStart=ListView_GetTopIndex(HANDLE)
				RowShowEnd= mDrawRowStart + mCountPerPage
			End If
			If RowShowEnd>ListItems.Count-1 Then RowShowEnd=ListItems.Count-1
			If RowShowStart<0 Then RowShowStart=0
			If RowShowEnd<RowShowStart Then RowShowEnd=RowShowStart
			'print RowShowStart,RowShowEnd,iColCount
			For iCol = 0 To iColCount
				ListView_GetSubItemRect(HANDLE, RowShowStart, iCol, LVIR_BOUNDS, @REC(iCol)) 'Nothing   when in NM_CUSTOMDRAW mode
				If REC(iCol).Right>=This.Width AndAlso iColEnd=-1 AndAlso iCol>0 Then iColEnd=iCol
				If REC(iCol).Left>0 AndAlso iColStart=-1 AndAlso iCol>0 Then iColStart=iCol-1
			Next
			
			Si.cbSize = SizeOf (Si)
			Si.fMask = SIF_ALL
			GetScrollInfo(HANDLE, SB_HORZ, @Si) 'SB_VERT HORZ
			
			mRowHeight=REC(1).Bottom -REC(1).Top
			mRowHeightHeader=REC(1).Top-1
			'Clean the Header
			RectCell=REC(0)
			RectCell.Top=0
			RectCell.Bottom=mRowHeightHeader
			'RectCell.Right=This.Width
			
			'the following is the Truth
			GridWidth=REC(0).Right
			REC(0).Right=REC(1).Left
			REC(0).Left -= 1
			If iColStart<0 Then iColStart=0
			If iColEnd>iColCount OrElse iColEnd<=iColStart Then iColEnd=iColCount
			If si.nPos<0 OrElse mCountPerPage<1 OrElse mDrawRowStart<0 Then Exit Sub
			SelectObject(GridDCHeader,mFontHandleHeader)
			
			BmpHeader = CreateCompatibleBitmap(GridDCHeader,mClientRectHeader.Right,mClientRectHeader.Bottom)
			SelectObject(MemDcHeader,BmpHeader)
			'PostMessage(mHandleHeader, WM_SETREDRAW, False, 0) 'DO NOT UPDATING THE TITLE BAR
			'PostMessage(mHandleHeader,WM_ERASEBKGND, CInt(MemDCHeader), CInt(MemDCHeader))
			FillRect memDcHeader, @mClientRectHeader,This.Brush.Handle
			SetBkMode(memDCHeader, TRANSPARENT)
			DrawRect(memDcHeader, mClientRectHeader, mHeaderBackColor,-1,-1)
			SetTextColor(memDcHeader, mHeaderForeColor)
			
			'Draw Header
			For iCol = iColStart To iColEnd
				RectCell= REC(iCol)
				RectCell.Top=REC(0).Top: RectCell.Bottom=REC(0).Bottom
				If RectCell.Right-RectCell.Left <= 5 Then Continue For
				'Print "CType ",iCT," DataType ",Columns.Column(iCol)->DataType
				'SendMessage(mHandleHeader, WM_SETREDRAW, False, 0) 'DO NOT UPDATING THE TITLE BAR
				RectHeader=REC(iCol)
				WLet(sText, Columns.Column(iCol)->Text)
				RectHeader.Top=0
				RectHeader.Bottom =mRowHeightHeader'REC(0).Top
				RectHeader.Left=Si.nPos+REC(iCol).Left
				RectHeader.Right=Si.nPos+REC(iCol).Right
				DrawRect(MemDCHeader, RectHeader,mHeaderBackColor,-1,-1)
				RectHeader.Left=Si.nPos+REC(iCol).Left+4
				RectHeader.Right=Si.nPos+REC(iCol).Right-3
				uFormatHeader=IIf(Columns.Column(iCol)->FormatHeader =cfLeft,DT_VCENTER Or DT_LEFT,IIf(Columns.Column(iCol)->FormatHeader =cfRight,DT_VCENTER Or DT_RIGHT,DT_VCENTER Or DT_CENTER))
				uFOrmatHeader=uFOrmatHeader Or IIf(InStr(*sText,WChr(10)),DT_WORDBREAK Or DT_EDITCONTROL,DT_SINGLELINE)
				DrawText(MemDCHeader, *sText, -1, @RectHeader, uFormatHeader)'Or DT_SINGLELINE
				
				'https://docs.microsoft.com/zh-cn/windows/win32/api/winuser/nf-winuser-drawframecontrol
				'if icol mod 2 then
				'   DrawFrameControl(MemDCHeader, @RectHeader,DFC_SCROLL,DFCS_SCROLLDOWN or DFCS_FLAT or DFCS_INACTIVE) 'DFC_BUTTON,DFCS_BUTTONRADIO)
				'else
				'   DrawFrameControl(MemDCHeader, @RectHeader,DFC_SCROLL,DFCS_SCROLLUP or DFCS_FLAT or DFCS_INACTIVE) 'DFC_BUTTON,DFCS_BUTTONRADIO)
				'end if
				If mSortColumn>0 AndAlso icol=mSortColumn Then
					If Columns.Column(mSortColumn)->Format=cfRight Then
						DrawSortArrow(MemDCHeader,RectHeader.Left,mRowHeightHeader- 6, 6, 3, Columns.Column(iCol)->SortOrder)
					Else
						DrawSortArrow(MemDCHeader,RectHeader.Right-12,mRowHeightHeader- 6, 6, 3, Columns.Column(iCol)->SortOrder)
					End If
				End If
				'Draw vertical Line
				DrawLine(MemDCHeader,si.nPos+REC(iCol).Left-1,0,si.nPos+ REC(iCol).Left-1,mRowHeightHeader-1,mGridColorLineHeader,mGridLineWidth,mGridLinePenMode)
			Next
			'Draw the last vertical Line
			DrawLine(MemDCHeader,si.nPos+REC(iColEnd).Right-1,0,si.nPos+ REC(iColEnd).Right-1,mRowHeightHeader-1,mGridColorLineHeader,mGridLineWidth,mGridLinePenMode)
			'Draw the right Blank area
			RectCell.Bottom=mRowHeightHeader+1
			DrawRect(MemDCHeader,RectCell, mGridColorBack,-1,-1)
			BitBlt(GridDCHeader, 0, 0,mClientRectHeader.Right, mClientRectHeader.Bottom, MemDCHeader, 0, 0, SRCCOPY)
			DeleteObject(BmpHeader)
			DeleteDC(MemDCHeader)
			ReleaseDC(mHandleHeader, GridDCHeader)
			If DrawHeaderOnly Then Exit Sub
			
			Dim As HBITMAP Bmp
			Dim As HDC GridDC = GetDC(HANDLE)
			Dim As HDC memDC = CreateCompatibleDC(GridDC)
			If GridDC <= 0 OrElse memDCHeader <= 0  Then Exit Sub
			SelectObject(GridDC,mFontHandleBody)
			Bmp = CreateCompatibleBitmap(GridDC, mClientRect.Right, mClientRect.Bottom)
			SelectObject(MemDc,Bmp)
			'SendMessage(Handle,WM_ERASEBKGND, CInt(MemDC), CInt(MemDC))
			FillRect memDc,@mClientRect,This.Brush.Handle
			SetBkMode(memDC,TRANSPARENT)
			'SetBkColor(memDC,OPAQUE)
			
			Dim pt As LPPOINT
			Static As  HPEN HPEN,hPenSele
			HPEN = CreatePen(mGridLinePenMode, mGridLineWidth, mGridColorLine)
			hPenSele = SelectObject(MemDC, HPEN)
			For iRow = RowShowStart To RowShowEnd 'ListItems.Count
				For iCol = iColStart To iColEnd
					RectCell= REC(iCol)
					RectCell.Top = REC(0).Top: RectCell.Bottom = REC(0).Bottom
					If RectCell.Right-RectCell.Left <= 1 Then Continue For
					iColorBK = ListItems.Item(iRow)->BackColor(iCOl)
					If iCOl=0 Then
						WLet(sText,WStr(iRow+1))
					Else
						WLet(sText,ListItems.Item(iRow)->Text(iCOl))
					End If
					
					iCT = Columns.Column(iCol)->ControlType
					Select Case iCT
					Case CT_Header'=0
						RectCell.Left =rec(0).Left+1
						DrawRect(MemDC, RectCell, mHeaderBackColor,-1,-1)
					Case CT_CheckBox '= 1
						'https://www.cnblogs.com/doudongchun/p/3699719.html
						DrawRect(MemDC, RectCell, iColorBK,iRow,iCol)
						RectCell.Top =(RectCell.Top +RectCell.Bottom)/2-9
						RectCell.Bottom =RectCell.Top+18
						If Len(*sText)<=1 Then
							RectCell.Left =(RectCell.Left+RectCell.Right)/2-9
							RectCell.Right =RectCell.Left+18
						Else
							RectCell.Left =REC(iCol).Left+3
							RectCell.Right =RectCell.Left+18
						End If
						If InStr(*sText,CHRUnCheck)>0 Then
							DrawFrameControl(memDC, @RectCell,DFC_BUTTON,DFCS_BUTTONCHECK Or DFCS_CHECKED)
						Else
							DrawFrameControl(memDC, @RectCell,DFC_BUTTON,DFCS_BUTTONCHECK)
						End If
						'Draw  Text
						If Len(*sText)>1 Then
							RectCell= REC(iCol)
							RectCell.Top=REC(0).Top: RectCell.Bottom=REC(0).Bottom
							RectCell.Left =REC(iCol).Left+22
							RectCell.Right =REC(iCol).Right-2
							RectCell.Top +=3:RectCell.Bottom-=1
						End If
					Case CT_LinkLabel '= 2
						DrawRect(memDC, RectCell, iColorBK,iRow,iCol)
						RectCell.Top +=3:RectCell.Bottom-=1
						RectCell.Left +=3: RectCell.Right-=3
						
					Case CT_DateTimePicker' = 3
						DrawRect(memDC, RectCell, iColorBK,iRow,iCol)
						RectCell.Top +=3:RectCell.Bottom-=1
						RectCell.Left +=3: RectCell.Right-=3
						
					Case CT_ProgressBar' = 4
						DrawRect(MemDC, RectCell, iColorBK,iRow,iCol)
						If Val(*sText)>100 Then
							wlet(sText, "100%")
						ElseIf Val(*sText)<0 Then
							wLet(sText,"0%")
						Else
							wAdd sText,"%"
						End If
						InflateRect(@RectCell, -3, -3)
						RectCell.Top =(RectCell.Top +RectCell.Bottom)/2-9
						RectCell.Bottom =RectCell.Top+18
						RectCell.Right =RectCell.Left+ (RectCell.Right-RectCell.Left)* Val(*sText)/100
						'iForeColor=ListItems.Item(iRow)->ForeColor(iCOl)
						If iForeColor<=0 Then iForeColor=ClGreen
						If Val(*sText)>0 Then DrawRect(MemDC, RectCell, iForeColor,-1,-1)
						RectCell.Right =Rec(icol).Right
					Case CT_Custom' = 5
						DrawRect(MemDC, RectCell, iColorBK,iRow,iCol)
					Case CT_Button' = 6
						DrawRect(MemDC, RectCell, iColorBK,iRow,iCol)
						'https://docs.microsoft.com/zh-cn/windows/win32/api/winuser/nf-winuser-drawframecontrol
						RectCell.Top +=3:RectCell.Bottom-=1
						RectCell.Left +=3: RectCell.Right-=3
						DrawFrameControl(MemDC, @RectCell,DFC_BUTTON,DFCS_BUTTONPUSH) 'DFC_BUTTON,DFCS_BUTTONRADIO)
						
					Case CT_ComboBoxEdit' = 7
						'https://www.cnblogs.com/doudongchun/p/3699719.html
						DrawRect(MemDC, RectCell, iColorBK,iRow,iCol)
						RectCell.Top =(RectCell.Top +RectCell.Bottom)/2-9
						RectCell.Bottom =RectCell.Top +18
						RectCell.Left =RectCell.Right-20
						If Len(*sText)>0 Then DrawFrameControl(MemDC, @RectCell,DFC_SCROLL,DFCS_SCROLLDOWN) 'DFC_BUTTON,DFCS_BUTTONRADIO)
						RectCell.Left =Rec(iCol).Left+3
						RectCell.Right= Rec(iCol).Right-23
					Case CT_TextBox '= 9
						DrawRect(MemDC, RectCell, iColorBK,iRow,iCol)
						RectCell.Top +=3:RectCell.Bottom-=1
						RectCell.Left +=3: RectCell.Right-=3
					Case Else
						DrawRect(MemDC, RectCell, iColorBK,iRow,iCol)
						InflateRect(@RectCell, -2, -2)
					End Select
					SelectObject(MemDC,mFontHandleBody)
					iForeColor=ListItems.Item(iRow)->ForeColor(iCOl)
					SetTextColor(MemDC, iForeColor)
					
					Select Case Columns.Column(iCol)->DataType
					Case DT_Nothing '=0
						uFormat=DT_SINGLELINE
					Case DT_Numeric' = 1
						uFormat=DT_SINGLELINE
					Case DT_Date' = 1
						uFormat=DT_SINGLELINE
					Case DT_LinkLabel' = 2
						uFOrmat=IIf(InStr(*sText,WChr(10)),DT_WORDBREAK Or DT_EDITCONTROL,DT_SINGLELINE)
						SelectObject(MemDC,mFontHandleBodyUnderline)
					Case DT_Boolean '= 3
						uFormat=DT_SINGLELINE
					Case DT_ProgressBar' = 4
						uFormat=DT_SINGLELINE
					Case DT_Custom '= 5
					Case DT_Button '= 6
						uFOrmat=IIf(InStr(*sText,WChr(10)),DT_WORDBREAK Or DT_EDITCONTROL,DT_SINGLELINE)
					Case DT_ComBoBoxEdit' = 7
						uFormat=DT_SINGLELINE
					Case DT_Date '= 8
						uFormat=DT_SINGLELINE
					Case DT_Time '= 10
						uFormat=DT_SINGLELINE
					Case Else 'DT_String = 9
						uFOrmat=IIf(InStr(*sText,WChr(10)),DT_WORDBREAK Or DT_EDITCONTROL,DT_SINGLELINE)
						GridEditText.ScrollBars = IIf(InStr(*sText,WChr(10)),ScrollBarsType.Both,ScrollBarsType.None)
					End Select
					'Force to change to MuiltLine
					If Columns.Column(iCol)->MuiltLine = True Then uFOrmat = DT_WORDBREAK Or DT_EDITCONTROL
					If Len(*sText)>0 Then
						'InflateRect(@RectCell, -4, -4)
						'https://www.cnblogs.com/lingyun1120/archive/2011/11/14/2248072.html
						If Columns.Column(iCol)->Format=cfLeft Then
							DrawText(MemDC, *sText, -1, @RectCell, DT_VCENTER Or DT_LEFT Or uFOrmat)  'Or DT_SINGLELINE ???????
						ElseIf Columns.Column(iCol)->Format=cfRight Then
							DrawText(MemDC, *sText, -1, @RectCell, DT_VCENTER Or DT_RIGHT Or uFOrmat)   'Or DT_SINGLELINE ???????
						Else
							DrawText(MemDC, *sText, -1, @RectCell, DT_VCENTER Or DT_CENTER Or uFOrmat) 'Or DT_SINGLELINE ???????
						End If
					End If
					RectCell= REC(iCol)
					RectCell.Top=REC(0).Top: RectCell.Bottom=REC(0).Bottom
				Next
				If mGridLineDrawMode = GRIDLINE_Both Or mGridLineDrawMode = GRIDLINE_HOrizontal Then  ' GRIDLINE_Vertical
					DrawLine(MemDC,REC(0).Left,RectCell.Top, REC(iColEnd).Right,RectCell.Top,mGridColorLine,mGridLineWidth,mGridLinePenMode)
				End If
				REC(0).Top=REC(0).Top+mRowHeight
				REC(0).Bottom=REC(0).Top+mRowHeight
			Next
			If RowHover>=0 And ColHover>0 Then
				RectCell.Left =REC(ColHover).Left+1:   RectCell.Right =REC(ColHover).Right-1 'GridWidth-1
				RectCell.Top =mRowHeightHeader+mRowHeight*(RowHover-RowShowStart)+2
				RectCell.Bottom =RectCell.Top+ mRowHeight
				'Draw Focus Row
				DrawFocusRect(memDC, @RectCell)
			End If
			'Draw Bottom Line of Grid Body
			If mGridLineDrawMode = GRIDLINE_Both Or mGridLineDrawMode = GRIDLINE_Horizontal Then  ' GRIDLINE_None Both GRIDLINE_VerticalThen
				DrawLine(memDC,REC(0).Left,RectCell.Top+mRowHeight, REC(iColEnd).Right,RectCell.Top+mRowHeight,mGridColorLine,mGridLineWidth,mGridLinePenMode)
			End If
			
			If mGridLineDrawMode = GRIDLINE_Both Or mGridLineDrawMode = GRIDLINE_Vertical Then  ' GRIDLINE_None GRIDLINE_HOrizontal Then
				For iCol=iColStart To iColEnd
					DrawLine(memDC,REC(iCol).Left-1,0, REC(iCol).Left-1,REC(0).Bottom,mGridColorLine,mGridLineWidth,mGridLinePenMode)
				Next
				'Draw Right Line of Grid Body
				DrawLine(memDC,REC(iColEnd).Right,0, REC(iColEnd).Right,REC(0).Bottom,mGridColorLine,mGridLineWidth,mGridLinePenMode)
			End If
			
			'    'Draw the Blank area
			'    If GridWidth<This.Width Then 'Draw the Blank area at the right
			'        RectCell.Left =GridWidth+1:      RectCell.Right=This.Width
			'        RectCell.Top =0
			'        RectCell.Bottom=This.Height
			'        DrawRect(MemDC,RectCell, This.BackColor,-1,-1)
			'
			'    End If
			'    GridHeight=REC(0).Bottom-mRowHeight+1
			'    If GridHeight<This.Height Then 'Draw the Blank area at the Bottom
			'        RectCell.Left =0:             RectCell.Right=This.Width
			'        RectCell.Top =GridHeight:   RectCell.Bottom=This.Height
			'        DrawRect(MemDC,RectCell,mGridColorBack,-1,-1)
			'        'Have to draw bottom line again to cover the background?
			'        DrawLine(MemDC,RectCell.Left,RectCell.Top-1, RectCell.Right,RectCell.Top-1,mGridColorLine,mGridLineWidth,mGridLinePenMode)
			'    End If
			BitBlt(GridDC, 0, 0,mClientRect.Right, mClientRect.Bottom, memDC, 0, 0, SRCCOPY)
			DeleteObject(Bmp)
			DeleteDC(memDC)
			ReleaseDC(Handle, GridDC)
		End Sub
	#endif
	Private Sub GridData.ProcessMessage(ByRef Message As Message)
		'?message.msg, GetMessageName(message.msg)
		#ifdef __USE_GTK__
			Dim As GdkEvent Ptr e = Message.Event
			Select Case Message.Event->type
			Case GDK_MAP
				Init
			End Select
		#else
			Static As HDC nmcdhDC '=-1
			Static As Boolean tSCROLL_HorV,tRefresh
			Static As Integer  ComboColOld
			Dim tMOUSEWHEEL As Boolean = False
			Dim lplvcd As NMLVCUSTOMDRAW Ptr
			Dim As Rect RectCell
			Dim As WString Ptr sText
			Dim As SCROLLINFO Si
			'if WM_PAINT<>Message.Msg and Message.Msg<>WM_DRAWITEM then print *FClassName +": " +GetMessageName(message.msg)
			'Print *FClassName +": " +GetMessageName(message.msg)
			Select Case Message.Msg
				
			Case CM_CREATE
				GridReDraw(mDrawRowStart, mDrawRowStart + mCountPerPage,mRow, mCol)
			Case WM_PAINT
				GridReDraw(mDrawRowStart, mDrawRowStart + mCountPerPage,mRow, mCol)
				'message.Result = -1' CDRF_SKIPDEFAULT 'CDRF_SKIPDEFAULT=4  This is very important for custmor draw Will infect the other window showing if have Value
				' case WM_ICONERASEBKGND
			Case WM_ERASEBKGND
				Message.Result = -1'CDRF_SKIPDEFAULT  ' This is very important for custmor draw
				'      case WM_NCHITTEST
				'      CASE WM_WINDOWPOSCHANGING
				'         message.Result =    CDRF_SKIPDEFAULT
			Case WM_DRAWITEM '
				Message.Result =-1'CDRF_SKIPDEFAULT
				'      Case WM_SETFOCUS
				'         PRINT "WM_SETFOCUS "
				'Case WM_NCPAINT
				'    message.Result = CDRF_SKIPDEFAULT
			Case WM_DESTROY
				If Images Then ListView_SetImageList(FHandle, 0, LVSIL_NORMAL)
				If StateImages Then ListView_SetImageList(FHandle, 0, LVSIL_STATE)
				If SmallImages Then ListView_SetImageList(FHandle, 0, LVSIL_SMALL)
				If GroupHeaderImages Then ListView_SetImageList(FHandle, 0, LVSIL_GROUPHEADER)
			Case WM_SIZE
				mCountPerPage = ListView_GetCountPerPage(Handle)
				mDrawRowStart=ListView_GetTopIndex(Handle)
				GetClientRect mHandleHeader,@mClientRectHeader
				GetClientRect Handle,@mClientRect
				If This.Visible= True Then GridReDraw(mDrawRowStart, mDrawRowStart + mCountPerPage,mRow, mCol)
				
				'      Case WM_MOUSEACTIVATE
				'      Case WM_MOUSEWHEEL
				'print "WM_MOUSEWHEEL ------------------------"
				'tMOUSEWHEEL = False
				'message.Result  = CDRF_NOTIFYSUBITEMDRAW
				'GridReDraw(mDrawRowStart, mDrawRowStart + mCountPerPage,mRow, mCol)
				' tRefresh=not tRefresh
				'          'exit sub
				'      case WM_MOUSEMOVE
				'          'print "WM_MOUSEMOVE ######## ",Message.lParamLo,Message.lParamHi 'X,Y
				'      case WM_MOUSEHOVER
				
				'      case WM_MOUSELEAVE
				'          'print "WM_MOUSELEAVE !!!!!!!!!!"
				'      case WM_VSCROLL
				'           tSCROLL_HorV=False
				'           'print "WM_VSCROLL XXXXXXXXX"
				
				'      case WM_HSCROLL
				'           tSCROLL_HorV=true
				'           'print "WM_HSCROLL !!!!!!!!!!"
				'      Case WM_RBUTTONDOWN
			Case WM_LBUTTONDOWN
				Dim lvhti As LVHITTESTINFO
				lvhti.pt.X = Message.lParamLo
				lvhti.pt.Y = Message.lParamHi
				lvhti.iItem = FLvi.iItem  'Must Let Value
				lvhti.iSubItem = FLvi.iSubItem 'Must Let Value
				If (ListView_HitTest(Handle, @lvhti) <> -1) Then
					If (lvhti.flags = LVHT_ONITEMSTATEICON) Then
						Var tlvi = GetGridDataItem(lvhti.iItem)
						If tlvi AndAlso tlvi->Items.Count > 0 Then
							If tlvi->IsExpanded Then
								tlvi->Collapse
							Else
								If OnItemExpanding Then OnItemExpanding(*Designer, This, tlvi)
								tlvi->Expand
							End If
						End If
					End If
				End If
			Case CM_NOTIFY   '4002
				Dim lvp As NMLISTVIEW Ptr = Cast(NMLISTVIEW Ptr, Message.lParam)
				lplvcd = Cast(NMLVCUSTOMDRAW Ptr, Message.lParam)
				'if tRefresh then print "CM_NOTIFY Key ",lvp->iItem,lvp->iSubItem,lplvcd->nmcd.hdr.code
				Message.Result = CDRF_DODEFAULT
				Select Case lplvcd->nmcd.hdr.code
				Case NM_CUSTOMDRAW
					'Drawing too many times. Showing slowly.
					'GridReDraw(mDrawRowStart, mDrawRowStart + mCountPerPage,mRow, mCol,True)
					Message.Result =0' CDRF_SKIPDEFAULT
				Case NM_CLICK
					'Print "NM_CLICK ", lvp->iItem, lvp->iSubItem    'Nothing   when in NM_CUSTOMDRAW mode
					'Updating the input result
					Select Case Columns.Column(mCol)->ControlType
						'Case CT_Header
						'case CT_Button
						'case CT_ProgressBar
					Case CT_ComboBoxEdit
						If GridEditComboBox.Visible=True Then ListItems.Item(mRow)->Text(mCol) =GridEditComboBox.Text
					Case CT_DateTimePicker
						If GridEditDateTimePicker.Visible=True Then ListItems.Item(mRow)->Text(mCol) =GridEditDateTimePicker.Text
					Case CT_CheckBox
					Case CT_TextBox
						If GridEditText.Visible=True Then ListItems.Item(mRow)->Text(mCol)=GridEditText.Text
					End Select
					GridEditText.Visible=False ' Force refesh windows
					GridEditDateTimePicker.Visible =False
					GridEditComboBox.Visible =False
					FLvi.iItem = lvp->iItem: FLvi.iSubItem = lvp->iSubItem
					mRow=lvp->iItem: mCol=lvp->iSubItem
					If mCol>=0 AndAlso mRow>=0 Then
						If mCol=0 Then mCol=1
						If Columns.Column(mCol)->ControlType = CT_ComboBoxEdit AndAlso mAllowEdit Then
							ListView_GetSubItemRect(Handle, mRow, mCol, LVIR_BOUNDS, @RectCell)
							GridEditText.Visible=False ' Force refesh windows
							GridEditDateTimePicker.Visible =False
							If ComboColOld<>mCol Then
								GridEditComboBox.Clear
								If Len(Columns.Column(mCol)->GridEditComboItem)>0 Then
									Dim tArray() As WString Ptr
									Split(Columns.Column(mCol)->GridEditComboItem,Chr(9),tArray())
									For ii As Integer =0 To UBound(tArray)
										GridEditComboBox.AddItem *tArray(ii)
										_Deallocate(tArray(ii))
									Next
									Erase tArray
								End If
								ComboColOld=mCol
							End If
							
							RectCell.Top =(RectCell.Top +RectCell.Bottom)/2-GridEditComboBox.Height/2
							GridEditComboBox.BackColor= ListItems.Item(mRow)->BackColor(mCol)
							GridEditComboBox.Font.Color=ListItems.Item(mRow)->ForeColor(mCol)
							GridEditComboBox.Visible =True
							GridEditComboBox.SetBounds RectCell.Left, RectCell.Top, RectCell.Right - RectCell.Left-1, mFontHeight*1.2
							GridEditComboBox.ItemIndex=GridEditComboBox.IndexOf(ListItems.Item(mRow)->Text(mCol))
							
							GridEditComboBox.SetFocus
							InvalidateRect(Handle,@RectCell,False)
							UpdateWindow Handle
						End If
						GridReDraw(mDrawRowStart, mDrawRowStart + mCountPerPage,mRow, mCol)
					End If
					If OnItemClick Then OnItemClick(*Designer, This, lvp->iItem, lvp->iSubItem, nmcdhDC)
					
				Case NM_DBLCLK
					'Print "NM_DBLCLK ", lvp->iItem, lvp->iSubItem
					If mSorting=False Then
						If OnItemDblClick Then OnItemDblClick(*Designer, This, lvp->iItem, lvp->iSubItem, nmcdhDC)
						EditControlShow(ComboColOld,lvp->iItem, lvp->iSubItem)
					End If
				Case NM_KEYDOWN
					If OnItemKeyDown Then OnItemKeyDown(*Designer, This, GetGridDataItem(lvp->iItem))
				Case LVN_ITEMACTIVATE
					'Print "LVN_ITEMACTIVATE ", lvp->iItem, lvp->iSubItem
					If OnItemActivate Then OnItemActivate(*Designer, This, GetGridDataItem(lvp->iItem))
				Case LVN_COLUMNCLICK
					'Print "LVN_COLUMNCLICK ************iItem,iSubItem ",lvp->iItem,lvp->iSubItem
					'tRefresh=True
					If mSorting=False And lvp->iSubItem<>0 Then
						mSortColumn= lvp->iSubItem
						mCol=mSortColumn
						'ListView_SetSelectedColumn(Handle,0)
						'ListView_SelectItem(Handle,mDrawRowStart)
						'ListView_SetItemState(Handle,mCol, 0, LVIS_SELECTED)
						'ListView_SetItemState(Handle, -1, 0, LVIS_SELECTED OR LVIS_FOCUSED)
						'ssNone ssSortAscending ssSortDescending
						Columns.Column(mSortColumn)->SortOrder = IIf(Columns.Column(mSortColumn)->SortOrder = SortStyle.ssNone, SortStyle.ssSortAscending, IIf(Columns.Column(mSortColumn)->SortOrder = SortStyle.ssSortAscending, SortStyle.ssSortDescending, SortStyle.ssNone))
						SortData(mSortColumn,Columns.Column(mSortColumn)->SortOrder)
						GridReDraw(mDrawRowStart, mDrawRowStart + mCountPerPage,mRow, mCol)
						GridEditText.Visible=False'Force GRID to Refresh
					End If
					'RectCell.Top=0:RectCell.Left=0: RectCell.Right=This.Width: RectCell.Bottom=This.Height
					InvalidateRect(Handle,NULL,False)
					UpdateWindow Handle
					If OnHeadClick Then OnHeadClick(*Designer, This, lvp->iSubItem)
					Message.Result =0'CDRF_SKIPDEFAULT
				Case LVN_BEGINSCROLL 'Reach here '
					If OnBeginScroll Then OnBeginScroll(*Designer, This)
				Case LVN_ENDSCROLL 'Reach here
					'Print "CM_NOTIFY LVN_ENDSCROLL " 'BeginScroll LVN_ENDSCROLL
					'                        Si.cbSize = SizeOf (Si)
					'                        Si.fMask =SIF_RANGE 'SIF_ALL'SIF_RANGE
					'                        Si.nMax = mScrollMaxH'-This.Width 'The ScrollBar V's width
					'                        SetScrollInfo(Handle, SB_HORZ, @Si, True) 'SB_VERT  HORZ
					
					GridEditText.Visible=False ' Force refesh windows
					GridEditDateTimePicker.Visible =False
					GridEditComboBox.Visible =False
					mCountPerPage = ListView_GetCountPerPage(Handle)
					mDrawRowStart=ListView_GetTopIndex(Handle)
					GetClientRect mHandleHeader,@mClientRectHeader
					GetClientRect Handle,@mClientRect
					GridReDraw(mDrawRowStart, mDrawRowStart + mCountPerPage,mRow, mCol)
					
					'SendMessage(formh, WM_MOUSEMOVE,MK_LBUTTON,MAKELPARAM(321,477))
					'message.Result  = -1'  CDRF_SKIPDEFAULT
					
				Case LVN_ITEMCHANGED 'Hover not updated if message.Result  = 1 in   WM_NOTIFY
					'Print "CM_NOTIFY LVN_ITEMCHANGED mRow, mCol, lplvcd->nmcd.dwItemSpec,hDC ",mRow, mCol,lplvcd->nmcd.dwItemSpec,lplvcd->nmcd.hDC
					
					If OnSelectedItemChanged Then OnSelectedItemChanged(*Designer, This, lvp->iItem, lvp->iSubItem, nmcdhDC)
					'message.Result  =  CDRF_SKIPDEFAULT
					'Case HDN_ITEMCHANGED 'Never reach here in Win OS
					'case HDN_BEGINTRACK  'Never reach here in Win OS
					'case HDN_ENDTRACK  'Never reach here in Win OS
				End Select
				'      Case WM_KEYDOWN
				'PRINT  "WM_KEYDOWN",Message.wParam,Message.lParam
			Case WM_KEYUP
				Select Case Message.wParam
				Case VK_DOWN,VK_UP,VK_HOME,VK_END,VK_NEXT,VK_PRIOR
					Dim As Integer tItemSelel=ListView_GetNextItem(Handle, -1, LVNI_SELECTED)
					If tItemSelel<>-1 Then
						If tItemSelel <=mDrawRowStart Or tItemSelel >=mDrawRowStart + mCountPerPage Then mDrawRowStart=ListView_GetTopIndex(Handle)
						If Message.lParam=CT_TextBox Then GridEditText.Visible=False ' Force refesh windows
						If Message.lParam=CT_ComboBoxEdit Then GridEditComboBox.Visible =False
						If Message.lParam=CT_DateTimePicker Then GridEditDateTimePicker.Visible =False
						If mRow<>tItemSelel Then
							mRow=tItemSelel
							GridReDraw(mDrawRowStart, mDrawRowStart + mCountPerPage,mRow, mCol)
						End If
					End If
				Case VK_SPACE
					If mSorting=False Then EditControlShow(ComboColOld,mRow, mCol)
				Case VK_LEFT
					mCol-=1
					If mCol<=0 Then
						mCol=1
					Else
						Message.Result=0'CDRF_SKIPDEFAULT
					End If
					Message.Result= CDRF_SKIPDEFAULT
					GridReDraw(mDrawRowStart, mDrawRowStart + mCountPerPage,mRow, mCol)
				Case VK_RIGHT,VK_TAB
					ListView_GetSubItemRect(Handle, mRow, mCol, LVIR_BOUNDS, @RectCell)
					If RectCell.Right<This.Width Then
						Message.Result=  CDRF_SKIPDEFAULT
					End If
					mCol+=1
					If mCol>=Columns.Count-1 Then mCol=Columns.Count-1
					If Message.lParam=CT_TextBox Then
						GridEditText.Visible=False ' Force refesh windows
					End If
					If Message.lParam=CT_ComboBoxEdit Then GridEditComboBox.Visible =False
					If Message.lParam=CT_DateTimePicker Then GridEditDateTimePicker.Visible =False
					GridReDraw(mDrawRowStart, mDrawRowStart + mCountPerPage,mRow, mCol)
				Case VK_RETURN
					ListView_GetSubItemRect(Handle, mRow, mCol, LVIR_BOUNDS, @RectCell)
					If RectCell.Right<This.Width Then
						Message.Result=  CDRF_SKIPDEFAULT
					End If
					mCol+=1
					If mCol>=Columns.Count-1 Then mCol=Columns.Count-1
					Message.Result=  CDRF_SKIPDEFAULT
					GridReDraw(mDrawRowStart, mDrawRowStart + mCountPerPage,mRow, mCol)
					
				Case VK_ESCAPE
					If Message.lParam=CT_TextBox Then
						GridEditText.Visible=False ' Force refesh windows
					End If
					If Message.lParam=CT_ComboBoxEdit Then GridEditComboBox.Visible =False
					If Message.lParam=CT_DateTimePicker Then GridEditDateTimePicker.Visible =False
					GridReDraw(mDrawRowStart, mDrawRowStart + mCountPerPage,mRow, mCol)
				End Select
				
			Case WM_NOTIFY
				'if tRefresh=true then print "lplvcd0->nmcd.hdr.code", lplvcd0->nmcd.hdr.code
				lplvcd= Cast(NMLVCUSTOMDRAW Ptr, Message.lParam)
				Dim lvpHeader As NMHEADERA Ptr = Cast(NMHEADERA Ptr, Message.lParam)
				Select Case lplvcd->nmcd.hdr.code'message.wParam
				Case LVN_ODCACHEHINT
					'Print "WM_NOTIFY LVN_ODCACHEHINT "
				Case LVN_BEGINSCROLL ' 'not Reach here
					'Print "WM_NOTIFY BEGINSCROLL "
					
				Case LVN_ENDSCROLL  ' 'not Reach here
					' Print "WM_NOTIFY LVN_ENDSCROLL " 'LVN_ENDSCROLL
					'GridReDraw(mDrawRowStart, mDrawRowStart + mCountPerPage,mRow, mCol)
				Case HDN_ITEMCHANGED  'OK
					'Print "WM_NOTIFY HDN_ITEMCHANGED",lplvcd->iSubItem,lvpHeader->iItem
					If OnHeadColWidthAdjust Then OnHeadColWidthAdjust(*Designer, This, lvpHeader->iItem)
				Case HDN_BEGINTRACK  'OK
					GridEditText.Visible=False ' Force refesh windows
					GridEditDateTimePicker.Visible =False
					GridEditComboBox.Visible =False
					
				Case HDN_ENDTRACK    'OK
					'Print "WM_NOTIFY HDN_ENDTRACK",lplvcd->iSubItem,lvpHeader->iItem
					GridReDraw(mDrawRowStart, mDrawRowStart + mCountPerPage,mRow, mCol)
					If OnHeadColWidthAdjust Then OnHeadColWidthAdjust(*Designer, This, lvpHeader->iItem)
				Case Else
				End Select
			Case CM_COMMAND
				Print "CM_COMMAND "
				Select Case message.wParam
					'              Case LVN_ITEMACTIVATE
					'              Case LVN_KEYDOWN
					'              Case LVN_ITEMCHANGING
					'              Case LVN_ITEMCHANGED
					'              Case LVN_INSERTITEM
					'              Case LVN_DELETEITEM
					'              Case LVN_DELETEALLITEMS
					'              Case LVN_BEGINLABELEDIT
					'              Case LVN_ENDLABELEDIT
					'              Case LVN_COLUMNCLICK
					'              Case LVN_BEGINDRAG
					'              Case LVN_BEGINRDRAG
					'              Case LVN_ODCACHEHINT
					'              Case LVN_ODFINDITEM
					'              Case LVN_ODSTATECHANGED
					'              Case LVN_HOTTRACK
					'              Case LVN_GETDISPINFO
					'              Case LVN_SETDISPINFO
					'                  'Case LVN_COLUMNDROPDOWN
					'              Case LVN_GETINFOTIP
					'                  'Case LVN_COLUMNOVERFLOWCLICK
					'              Case LVN_INCREMENTALSEARCH
					'              Case LVN_BEGINSCROLL
					'              Case LVN_ENDSCROLL
					'               'Case LVN_LINKCLICK
					'               'Case LVN_GETEMPTYMARKUP
					
					'Message.LParamLo
				Case VK_DOWN
					Print Message.LParam
					If message.LParam<>CT_TextBox Then
						If message.LParam=CT_ComboBoxEdit Then GridEditComboBox.Visible =False
						If message.LParam=CT_DateTimePicker Then GridEditDateTimePicker.Visible =False
						mRow+=1
						If mRow>ListItems.Count-1 Then mRow=ListItems.Count-1
						If mRow>=mDrawRowStart + mCountPerPage Then mDrawRowStart=ListView_GetTopIndex(Handle)
						GridReDraw(mDrawRowStart, mDrawRowStart + mCountPerPage,mRow, mCol)
					End If
				Case VK_UP
					If message.LParam<>CT_TextBox Then   ' Force refesh windows
						If message.LParam=CT_ComboBoxEdit Then GridEditComboBox.Visible =False
						If message.LParam=CT_DateTimePicker Then GridEditDateTimePicker.Visible =False
						mRow-=1
						If mRow<0 Then mRow=0
						If mRow <=mDrawRowStart Then mDrawRowStart=ListView_GetTopIndex(Handle)
						GridReDraw(mDrawRowStart, mDrawRowStart + mCountPerPage,mRow, mCol)
					End If
				Case VK_ESCAPE
					If Message.lParam=CT_TextBox Then GridEditText.Visible=False ' Force refesh windows
					If Message.lParam=CT_ComboBoxEdit Then GridEditComboBox.Visible =False
					If Message.lParam=CT_DateTimePicker Then GridEditDateTimePicker.Visible =False
					GridReDraw(mDrawRowStart, mDrawRowStart + mCountPerPage,mRow, mCol)
				Case VK_RETURN,VK_TAB
					Select Case Message.lParam
					Case CT_TextBox
						'Now you can input RETURN Keycode
						If GridEditText.Multiline=False Or Message.wParam=VK_TAB Then
							ListItems.Item(mRow)->Text(mCol) =GridEditText.Text
							GridEditText.Visible=False ' Force refesh windows
						End If
					Case CT_ComboBoxEdit
						ListItems.Item(mRow)->Text(mCol) =GridEditComboBox.Text
						GridEditComboBox.Visible =False
					Case CT_DateTimePicker
						ListItems.Item(mRow)->Text(mCol) =GridEditDateTimePicker.Text
						GridEditDateTimePicker.Visible =False
					End Select
					GridReDraw(mDrawRowStart, mDrawRowStart + mCountPerPage,mRow, mCol)
					' Case VK_LEFT
					'Case VK_RIGHT
					' Case Else
					' message.Result = CDRF_DODEFAULT
				End Select
				'Case CM_NEEDTEXT
			End Select
			WDeAllocate sText
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	#ifdef __USE_WINAPI__
		Private Sub GridData.EditControlShow(ByRef tComboColOld As Integer,ByVal tRow As Integer,ByVal tCol As Integer)
			If mAllowEdit=False Then Exit Sub
			If ListItems.Item(mRow)->Locked OrElse Columns.Column(mCol)->Locked Then Exit Sub
			Dim As Rect RectCell
			Dim As WString Ptr sText
			
			'Updating the input result
			Select Case Columns.Column(mCol)->ControlType
				'Case CT_Header
				'case CT_Button
				'case CT_ProgressBar
			Case CT_ComboBoxEdit
				If GridEditComboBox.Visible=True Then ListItems.Item(mRow)->Text(mCol) =GridEditComboBox.Text
			Case CT_DateTimePicker
				If GridEditDateTimePicker.Visible=True Then ListItems.Item(mRow)->Text(mCol) =GridEditDateTimePicker.Text
				'case CT_CheckBox
			Case CT_TextBox
				If GridEditText.Visible=True Then ListItems.Item(mRow)->Text(mCol)=GridEditText.Text
			End Select
			'Move to new position
			If tRow>=0 AndAlso tCol>0 Then
				mRow=tRow: mCol=tCol
				WLet(sText,ListItems.Item(mRow)->Text(mCol))
				ListView_GetSubItemRect(HANDLE, mRow, mCol, LVIR_BOUNDS, @RectCell)
				
				Select Case Columns.Column(mCol)->ControlType
				Case CT_Header
					GridEditText.Visible=False ' Force refesh windows
					GridEditDateTimePicker.Visible =False
					GridEditComboBox.Visible =False
				Case CT_Button
					GridEditText.Visible=False ' Force refesh windows
					GridEditDateTimePicker.Visible =False
					GridEditComboBox.Visible =False
				Case CT_ProgressBar,CT_LinkLabel
					GridEditText.Visible=False ' Force refesh windows
					GridEditDateTimePicker.Visible =False
					GridEditComboBox.Visible =False
				Case CT_ComboBoxEdit
					GridEditText.Visible=False ' Force refesh windows
					GridEditDateTimePicker.Visible =False
					If tComboColOld<>mCol Then
						If Len(Columns.Column(mCol)->GridEditComboItem)>0 Then
							Dim tArray() As WString Ptr
							Split(Columns.Column(mCol)->GridEditComboItem,Chr(9),tArray())
							GridEditComboBox.Clear
							For ii As Integer =0 To UBound(tArray)
								GridEditComboBox.AddItem *tArray(ii)
								_Deallocate(tArray(ii))
							Next
							Erase tArray
						End If
						tComboColOld=mCol
					End If
					RectCell.Top =(RectCell.Top +RectCell.Bottom)/2-GridEditComboBox.Height/2
					GridEditComboBox.BackColor=ListItems.Item(mRow)->BackColor(mCol)
					GridEditComboBox.Font.Color=ListItems.Item(mRow)->ForeColor(mCol)
					GridEditComboBox.Visible =True
					GridEditComboBox.SetBounds RectCell.Left, RectCell.Top, RectCell.Right - RectCell.Left-1, mFontHeight*1.2
					GridEditComboBox.ItemIndex=GridEditComboBox.IndexOf(*sText)
					GridEditComboBox.SetFocus
				Case CT_DateTimePicker
					Dim As SYSTEMTIME ST
					ST.wYear=Year(DateValue(*sText))
					ST.wmonth=Month(DateValue(*sText))
					ST.wday=Day(DateValue(*sText))
					ST.wHour=Hour(TimeValue(*sText))
					ST.wMinute=Minute(TimeValue(*sText))
					ST.wSecond=Second(TimeValue(*sText))
					If Columns.Column(mCol)->DataType = DT_Time Then
						'TODO Not working
						GridEditDateTimePicker.TimePicker = True
					Else
						GridEditDateTimePicker.TimePicker = False
					End If
					SendMessage(GridEditDateTimePicker.Handle,DTM_SETSYSTEMTIME,GDT_VALID,Cast(LPARAM,@ST))
					GridEditDateTimePicker.BackColor=ListItems.Item(mRow)->BackColor(mCol)
					GridEditDateTimePicker.Font.Color=ListItems.Item(mRow)->ForeColor(mCol)
					GridEditText.Visible=False ' Force refesh windows
					GridEditDateTimePicker.Visible =True
					GridEditComboBox.Visible =False
					GridEditDateTimePicker.SetBounds RectCell.Left, RectCell.Top, RectCell.Right - RectCell.Left-1, RectCell.Bottom - RectCell.Top
					GridEditDateTimePicker.SetFocus
				Case CT_CheckBox
					GridEditText.Visible=False ' Force refesh windows
					GridEditDateTimePicker.Visible =False
					GridEditComboBox.Visible =False
					If InStr(*stext,ChrUnCheck)>0 Then
						ListItems.Item(mRow)->Text(mCol)=Replace(*sText,ChrUnCheck,ChrCheck)
					ElseIf InStr(*sText,CHRCheck)>0 Then
						ListItems.Item(mRow)->Text(mCol)=Replace(*sText,CHRCheck,CHRUnCheck)
					Else
						If Len(*sText)<=1 Then
							ListItems.Item(mRow)->Text(mCol)=CHRUnCheck
						End If
						WAdd sText,CHRUnCheck
						ListItems.Item(mRow)->Text(mCol)=*sText
					End If
					GridReDraw(mDrawRowStart, mDrawRowStart + mCountPerPage,mRow, mCol)
				Case CT_TextBox
					GridEditText.Visible =True
					GridEditDateTimePicker.Visible =False
					GridEditComboBox.Visible =False
					GridEditText.BackColor=mGridColorEditBack 'ListItems.Item(mRow)->BackColor(mCol)
					GridEditText.Font.Color=ListItems.Item(mRow)->ForeColor(mCol)
					GridEditText.SetBounds RectCell.Left, RectCell.Top, RectCell.Right - RectCell.Left-1, RectCell.Bottom - RectCell.Top
					If Columns.Column(mCol)->DataType=DT_Numeric Then
						'1234567890+-./ .190 /191 +187 -189 NumPad abcdefghij n=. m=- k=+ o=/
						GridEditText.Multiline=False
						GridEditText.InputFilter("1234567890+-.")
						'David CHange
					Else
						GridEditText.Multiline=True
					End If
					GridEditText.Text=*sText
					GridEditText.SetFocus
					GridEditText.SetSel Len(*sText),Len(*sText)
				End Select
			Else
				GridEditText.Visible=False ' Force refesh windows
				GridEditDateTimePicker.Visible =False
				GridEditComboBox.Visible =False
			End If
			InvalidateRect(Handle,@RectCell,False)
			UpdateWindow Handle
			WDeallocate sText
		End Sub
	#endif
	#ifndef __USE_GTK__
		Private Sub GridData.HandleIsDestroyed(ByRef Sender As Control)
		End Sub
		
		Private Sub GridData.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				Dim As HDC GridDC, GridDCHeader
				With QGridData(Sender.Child)
					If .Images Then
						.Images->ParentWindow = @Sender
						If .Images->Handle Then ListView_SetImageList(.Handle, CInt(.Images->Handle), LVSIL_NORMAL)
					End If
					If .StateImages Then .StateImages->ParentWindow = @Sender
					If .SmallImages Then .SmallImages->ParentWindow = @Sender
					If .GroupHeaderImages Then .GroupHeaderImages->ParentWindow = @Sender
					If .Images AndAlso .Images->Handle Then ListView_SetImageList(.Handle, CInt(.Images->Handle), LVSIL_NORMAL)
					If .StateImages AndAlso .StateImages->Handle Then ListView_SetImageList(.Handle, CInt(.StateImages->Handle), LVSIL_STATE)
					If .SmallImages AndAlso .SmallImages->Handle Then ListView_SetImageList(.Handle, CInt(.SmallImages->Handle), LVSIL_SMALL)
					If .GroupHeaderImages AndAlso .GroupHeaderImages->Handle Then ListView_SetImageList(.Handle, CInt(.GroupHeaderImages->Handle), LVSIL_GROUPHEADER)
					Dim lvStyle As Integer
					
					'lvStyle = SendMessage(.Handle, LVM_GETEXTENDEDLISTVIEWSTYLE, 0, 0)
					'lvStyle = lvStyle Or LVS_EX_FULLROWSELECT 'Or LVS_EX_SIMPLESELECT Or LVS_EX_SUBITEMIMAGES Or LVS_EX_TRACKSELECT
					'lvStyle = lvStyle Or  LVS_EX_GRIDLINES Or LVS_EX_FULLROWSELECT
					' Will got trouble in GetItemCount if remove LVS_EX_FULLROWSELECT
					'lvStyle = lvStyle Or LVS_EX_FULLROWSELECT Or LVS_EX_SIMPLESELECT or LVS_EX_HEADERDRAGDROP Or LVS_EX_SUBITEMIMAGES
					'lvStyle = lvStyle Or  LVS_EX_ONECLICKACTIVATE Or LVS_EX_LABELTIP Or LVS_EX_TRACKSELECT
					'SendMessage(.Handle, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, lvStyle)
					GridDC =GetDC(.Handle)
					.mHandleHeader = ListView_GetHeader(.Handle)
					GridDCHeader = GetDC(.mHandleHeader)
					SetBkMode GridDCHeader, TRANSPARENT
					SetBkMode GridDC, TRANSPARENT
					PostMessage(.HandleHeader, WM_SETREDRAW, False, 0) 'DO NOT UPDATING THE TITLE BAR
					.GridEditText.ParentHandle=.Handle
					.GridEditComboBox.ParentHandle=.Handle
					.GridEditDateTimePicker.ParentHandle=.Handle
					.GridEditText.Visible=False
					.GridEditText.Text=.ListItems.Item(0)->Text(1)
					.GridEditComboBox.Visible=False'
					.GridEditDateTimePicker.Visible=False'
					
					'FONT
					If .mFSize<10 Then .mFSize=10
					.mFCyPixels=GetDeviceCaps(GridDC, LOGPIXELSY)
					.mFCyPixelsHeader=GetDeviceCaps(GridDC, LOGPIXELSY)
					If .mFontHandleBody Then DeleteObject(.mFontHandleBody)
					.mFontHandleBody=CreateFontW(-MulDiv(.mFSize,.mFCyPixels,72),0,.mFOrientation*.mFSize,.mFOrientation*.mFSize,.mFBolds(abs_(.mFBold)),.mFItalic,.mFUnderline,.mFStrikeOut,.mFCharSet,OUT_TT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,FF_DONTCARE,*.mFName)
					.mFontHandleBodyUnderline=CreateFontW(-MulDiv(.mFSize,.mFCyPixels,72),0,.mFOrientation*.mFSize,.mFOrientation*.mFSize,.mFBolds(abs_(.mFBold)),.mFItalic,True,.mFStrikeOut,.mFCharSet,OUT_TT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,FF_DONTCARE,*.mFName)
					
					SendMessage(.Handle, WM_SETFONT,CUInt(.mFontHandleBody),True)
					SelectObject(GridDC,.mFontHandleBody)
					Dim Sz As ..Size
					GetTextExtentPoint32(GridDC,"B",Len("B"),@Sz)
					.mFontHeight=Sz.cy
					.mFontWidth=Sz.cx
					
					'mRowHeight=(18+(mFSize-8)*1.45
					'mFSize=(mRowHeight-18)/1.45+8
					If .mFSizeHeader<8 Then .mFSizeHeader=8
					If .mFontHandleHeader Then DeleteObject(.mFontHandleHeader)
					.mFontHandleHeader=CreateFontW(-MulDiv(.mFSizeHeader,.mFCyPixelsHeader,72),0,.mFOrientationHeader*.mFSizeHeader,.mFOrientationHeader*.mFSizeHeader,.mFBoldsHeader(abs_(.mFBoldHeader)),.mFItalicHeader,.mFUnderlineHeader,.mFStrikeOutHeader,.mFCharSetHeader,OUT_TT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,FF_DONTCARE,*.mFNameHeader)
					SendMessage(.HandleHeader, WM_SETFONT,CUInt(.mFontHandleHeader),True) 'enlarge the height of header
					
					If .mFSizeHeader<10 Then .mFSizeHeader=10
					'.mFBoldHeader=1
					If .mFontHandleHeader Then DeleteObject(.mFontHandleHeader)
					.mFontHandleHeader=CreateFontW(-MulDiv(.mFSizeHeader,.mFCyPixelsHeader,72),0,.mFOrientationHeader*.mFSizeHeader,.mFOrientationHeader*.mFSizeHeader,.mFBoldsHeader(abs_(.mFBoldHeader)),.mFItalicHeader,.mFUnderlineHeader,.mFStrikeOutHeader,.mFCharSetHeader,OUT_TT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,FF_DONTCARE,*.mFNameHeader)
					SelectObject(GridDCHeader,.mFontHandleHeader)
					ReleaseDC(.Handle, GridDC)
					ReleaseDC(.mHandleHeader, GridDCHeader)
					
					GetClientRect .mHandleHeader,@.mClientRectHeader
					GetClientRect .Handle,@.mClientRect
					
					If .FView <> 0 Then .View = .View
					For i As Integer = 0 To .Columns.Count -1
						Dim lvc As LVCOLUMN
						lvC.mask      =  LVCF_FMT Or LVCF_WIDTH Or LVCF_TEXT Or LVCF_SUBITEM
						lvC.fmt       =  .Columns.Column(i)->Format Or HDF_OWNERDRAW
						lvc.cx=100
						'lvc.pszText              = @.Columns.Column(i)->Text
						lvc.cchTextMax           = Len(.Columns.Column(i)->Text)
						lvc.iImage             = .Columns.Column(i)->ImageIndex
						lvc.iSubItem         = i
						ListView_InsertColumn(.Handle, i, @lvc)
						ListView_SetColumnWidth(.Handle, i, .Columns.Column(i)->ColWidth)
					Next i
					For i As Integer = 0 To .ListItems.Count -1
						Dim lvi As LVITEM
						lvi.Mask = LVIF_TEXT Or LVIF_IMAGE
						lvi.pszText              = @.ListItems.Item(i)->Text(0)
						lvi.cchTextMax           = Len(.ListItems.Item(i)->Text(0))
						lvi.iItem             = i
						lvi.iImage             = .ListItems.Item(i)->ImageIndex
						ListView_InsertItem(.Handle, @lvi)
						
						'                For j As Integer = 0 To .Columns.Count - 1
						'                    Dim As LVITEM lvi1
						'                    lvi1.Mask = LVIF_TEXT
						'                    lvi1.iItem = i
						'                    lvi1.iSubItem   = j
						'                    lvi1.pszText    = @.ListItems.Item(i)->Text(j)
						'                    lvi1.cchTextMax = Len(.ListItems.Item(i)->Text(j))
						'                    ListView_SetItem(.Handle, @lvi1)
						'                Next j
					Next i
					Dim As NONCLIENTMETRICS ncm
					ncm.cbSize =SizeOf(NONCLIENTMETRICS)
					'ncm.iScrollWidth = 27
					'get the non-client metrics for the system
					SystemParametersInfo(SPI_GETNONCLIENTMETRICS, ncm.cbSize, @ncm, 0)
					'SystemParametersInfo(SPI_SETNONCLIENTMETRICS, ncm.cbSize, ncm, SPIF_SENDCHANGE)
					.mSysScrollWidth = ncm.iScrollWidth
					If .mSysScrollWidth<10 Then .mSysScrollWidth=20
					
					'Print "ShowScrollBar ", ShowScrollBar(.Handle, SB_BOTH,True)'  .SB_HORZ, @Si) 'SB_VERT HORZ SB_BOTH
					'ShowScrollBar(.Handle, SB_VERT,True)'  .SB_HORZ, @Si) 'SB_VERT HORZ
					
				End With
			End If
			
		End Sub
		
	#endif
	
	Private Operator GridData.Cast As Control Ptr
		Return @This
	End Operator
	
	#ifdef __USE_GTK__
		Private Sub GridData_RowActivated(tree_view As GtkTreeView Ptr, path As GtkTreePath Ptr, column As GtkTreeViewColumn Ptr, user_data As Any Ptr)
			Dim As GridData Ptr lv = Cast(Any Ptr, user_data)
			If lv Then
				Dim As GtkTreeModel Ptr model
				Dim As GtkTreeIter iter
				model = gtk_tree_view_get_model(tree_view)
				
				If gtk_tree_model_get_iter(model, @iter, path) Then
					If lv->OnItemActivate Then lv->OnItemActivate(*lv->Designer, *lv, lv->ListItems.FindByIterUser_Data(iter.user_data))
				End If
			End If
		End Sub
		
		Private Sub GridData_SelectionChanged(selection As GtkTreeSelection Ptr, user_data As Any Ptr)
			Dim As GridData Ptr lv = Cast(Any Ptr, user_data)
			If lv Then
				Dim As GtkTreeIter iter
				Dim As GtkTreeModel Ptr model
				If gtk_tree_selection_get_selected(selection, @model, @iter) Then
					#if 0
						If lv->OnSelectedItemChanged Then lv->OnSelectedItemChanged(*lv, lv->ListItems.FindByIterUser_Data(iter.user_data))
					#endif
				End If
			End If
		End Sub
		
		Private Sub GridData_Map(widget As GtkWidget Ptr, user_data As Any Ptr)
			Dim As GridData Ptr lv = user_data
			lv->Init
		End Sub
		
		Private Function GridData.GridData_TestExpandRow(tree_view As GtkTreeView Ptr, iter As GtkTreeIter Ptr, path As GtkTreePath Ptr, user_data As Any Ptr) As Boolean
			Dim As GridData Ptr lv = user_data
			If lv Then
				Dim As GtkTreeModel Ptr model
				model = gtk_tree_view_get_model(tree_view)
				If lv->OnItemExpanding Then lv->OnItemExpanding(*lv->Designer, *lv, lv->ListItems.FindByIterUser_Data(iter->user_data))
			End If
			Return False
		End Function
	#else
		
	#endif
	
	Private Sub GridData.CollapseAll
		#ifdef __USE_GTK__
			gtk_tree_view_collapse_all(GTK_TREE_VIEW(widget))
		#endif
	End Sub
	
	Private Sub GridData.ExpandAll
		#ifdef __USE_GTK__
			gtk_tree_view_expand_all(GTK_TREE_VIEW(widget))
		#endif
	End Sub
	
	Private Constructor GridData
		#ifdef __USE_GTK__
			TreeStore = gtk_tree_store_new(1, G_TYPE_STRING)
			scrolledwidget = gtk_scrolled_window_new(NULL, NULL)
			gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolledwidget), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
			'widget = gtk_tree_view_new_with_model(gtk_tree_model(ListStore))
			widget = gtk_tree_view_new()
			gtk_container_add(GTK_CONTAINER(scrolledwidget), widget)
			TreeSelection = gtk_tree_view_get_selection(GTK_TREE_VIEW(widget))
			g_signal_connect(GTK_TREE_VIEW(widget), "map", G_CALLBACK(@GridData_Map), @This)
			g_signal_connect(GTK_TREE_VIEW(widget), "row-activated", G_CALLBACK(@GridData_RowActivated), @This)
			g_signal_connect(GTK_TREE_VIEW(widget), "test-expand-row", G_CALLBACK(@GridData_TestExpandRow), @This)
			g_signal_connect(G_OBJECT(TreeSelection), "changed", G_CALLBACK (@GridData_SelectionChanged), @This)
			gtk_tree_view_set_enable_tree_lines(GTK_TREE_VIEW(widget), True)
			gtk_tree_view_set_grid_lines(GTK_TREE_VIEW(widget), GTK_TREE_VIEW_GRID_LINES_BOTH)
			ColumnTypes = _New(GType[1])
			ColumnTypes[0] = G_TYPE_STRING
			This.RegisterClass "GridData", @This
		#endif
		'Font
		mFBolds(0) = 400
		mFBolds(1) = 700
		WLet(mFName, This.Font.Name)     '"TAHOMA"
		WLet(mFNameHeader, This.Font.Name)  '"TAHOMA"
		mFCharSet=FontCharset.Default
		mFCharSetHeader=FontCharset.Default
		mFBoldsHeader(0) = 400
		mFBoldsHeader(1) =700
		
		FEnabled = True
		FVisible = True
		ListItems.Parent = @This
		Columns.Parent = @This
		Columns.Clear
		ListItems.Clear
		
		GridEditComboBox.Parent = @This
		GridEditText.Parent = @This
		GridEditDateTimePicker.Parent = @This
		'GridEditLinkLabel.Parent = @This
		'GridEditText.BorderStyle = 0
		GridEditText.Multiline= True
		'GridEditText.WantReturn = True 'one is enough
		GridEditText.BringToFront
		GridEditComboBox.BringToFront
		GridEditDateTimePicker.BringToFront
		
		GridEditComboBox.Visible = False
		GridEditDateTimePicker.Visible = False
		'GridEditLinkLabel.Visible = False
		GridEditText.Visible = False
		With This
			.Child             = @This
			#ifndef __USE_GTK__
				.OnHandleIsAllocated = @HandleIsAllocated
				.OnHandleIsDestroyed = @HandleIsDestroyed
				.RegisterClass "GridData", WC_LISTVIEW
				.ChildProc         = @WNDPROC
				.ExStyle           = WS_EX_CLIENTEDGE
				.Style             = WS_CHILD Or WS_TABSTOP Or WS_VISIBLE Or LVS_REPORT Or LVS_SINGLESEL Or LVS_OWNERDRAWFIXED 'Or LVS_SHOWSELALWAYS OR LVS_EDITLABELS OR LVS_EX_DOUBLEBUFFER
				.DoubleBuffered = True
				WLet(FClassAncestor, WC_LISTVIEW)
			#endif
			WLet(FClassName, "GridData")
			.Width             = 121
			.Height            = 121
		End With
		Columns.Add "NO.", 0, 35, cfCenter, CT_Header, False, CT_Header, , SortStyle.ssSortAscending
		Columns.Add "Column" & Chr(10) & "One", 0,100,cfCenter, DT_String,False,CT_TextBox
		Columns.Add "Column" & Chr(10) & "Two" , 0,100,cfCenter,DT_String,False,CT_TextBox
		For i As Integer =1 To 50
			ListItems.Add Str(i),0,1
		Next
	End Constructor
	
	Private Destructor GridData
		ListItems.Clear
		Columns.Clear
		#ifndef __USE_GTK__
			UnregisterClass "GridData",GetModuleHandle(NULL)
			If mFontHandleBody Then DeleteObject(mFontHandleBody)
			If mFontHandleHeader Then DeleteObject(mFontHandleHeader)
			If mFontHandleBodyUnderline Then DeleteObject(mFontHandleBodyUnderline)
		#else
			If ColumnTypes Then _DeleteSquareBrackets(ColumnTypes)
		#endif
		WDeAllocate FClassName
		WDeAllocate FClassAncestor
		WDeAllocate mFName
		WDeAllocate mFNameHeader
	End Destructor
End Namespace

