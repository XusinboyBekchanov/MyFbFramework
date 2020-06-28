'###############################################################################
'#  ListView.bi                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                         #
'###############################################################################

#include once "ListView.bi"

Namespace My.Sys.Forms
	Function ListViewItem.Index As Integer
		If Parent Then
			Return Cast(ListView Ptr, Parent)->ListItems.IndexOf(@This)
		Else
			Return -1
		End If
	End Function
	
	Sub ListViewItem.SelectItem
		#ifdef __USE_GTK__
			If Parent AndAlso Cast(ListView Ptr, Parent)->TreeSelection Then
				gtk_tree_selection_select_iter(Cast(ListView Ptr, Parent)->TreeSelection, @TreeIter)
			End If
		#else
			If Parent AndAlso Parent->Handle Then
				Dim lvi As LVITEM
				lvi.iItem = Index
				lvi.iSubItem   = 0
				lvi.state    = LVIS_SELECTED
				lvi.statemask = LVNI_SELECTED
				ListView_SetItem(Parent->Handle, @lvi)
			End If
		#endif
	End Sub
	
	Property ListViewItem.Text(iSubItem As Integer) ByRef As WString
		#ifdef __USE_GTK__
			If FSubItems.Count > iSubItem Then
				Return FSubItems.Item(iSubItem)
			Else
				Return WStr("")
			End If
		#else
			If Parent AndAlso Parent->Handle Then
				WReallocate FText, 255
				lvi.Mask = LVIF_TEXT
				lvi.iItem = Index
				lvi.iSubItem   = iSubItem
				lvi.pszText    = FText
				lvi.cchTextMax = 255
				ListView_GetItem(Parent->Handle, @lvi)
				Return *FText
			Else
				If FSubItems.Count > iSubItem Then
					Return FSubItems.Item(iSubItem)
				Else
					Return WStr("")
				End If
			End If
		#endif
	End Property
	
	Property ListViewItem.Text(iSubItem As Integer, ByRef Value As WString)
		WLet FText, Value
		If Parent Then
			Dim ic As Integer = FSubItems.Count
			Dim cc As Integer = Cast(ListView Ptr, Parent)->Columns.Count
			If ic < cc Then
				For i As Integer = ic + 1 To cc
					FSubItems.Add ""
				Next i
			End If
			If iSubItem < cc Then FSubItems.Item(iSubItem) = Value
			#ifdef __USE_GTK__
				If Cast(ListView Ptr, Parent)->ListStore Then
					gtk_list_store_set (Cast(ListView Ptr, Parent)->ListStore, @TreeIter, iSubItem + 1, ToUtf8(Value), -1)
				End If
			#else
				If Parent->Handle Then
					lvi.Mask = LVIF_TEXT
					lvi.iItem = Index
					lvi.iSubItem   = iSubItem
					lvi.pszText    = FText
					lvi.cchTextMax = Len(*FText)
					ListView_SetItem(Parent->Handle, @lvi)
				End If
			#endif
		End If
	End Property
	
	Property ListViewItem.State As Integer
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				lvi.Mask = LVIF_STATE
				lvi.iItem = Index
				lvi.iSubItem   = 0
				ListView_GetItem(Parent->Handle, @lvi)
				FState = lvi.state
			End If
		#endif
		Return FState
	End Property
	
	Property ListViewItem.State(Value As Integer)
		FState = Value
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				lvi.Mask = LVIF_STATE
				lvi.iItem = Index
				lvi.iSubItem   = 0
				lvi.State    = Value
				ListView_SetItem(Parent->Handle, @lvi)
			End If
		#endif
	End Property
	
	Property ListViewItem.Indent As Integer
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				lvi.Mask = LVIF_INDENT
				lvi.iItem = Index
				lvi.iSubItem   = 0
				ListView_GetItem(Parent->Handle, @lvi)
				FIndent = lvi.iIndent
			End If
		#endif
		Return FIndent
	End Property
	
	Property ListViewItem.Indent(Value As Integer)
		FIndent = Value
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				lvi.Mask = LVIF_INDENT
				lvi.iItem = Index
				lvi.iSubItem   = 0
				lvi.iIndent    = Value
				ListView_SetItem(Parent->Handle, @lvi)
			End If
		#endif
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
		#endif
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
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then ListView_SetSelectedColumn(Parent->Handle, Index)
		#endif
	End Sub
	
	Property ListViewColumn.Text ByRef As WString
		Return WGet(FText)
	End Property
	
	Property ListViewColumn.Text(ByRef Value As WString)
		WLet FText, Value
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
	
	Property ListViewColumn.Width As Integer
		Return FWidth
	End Property
	
	Property ListViewColumn.Width(Value As Integer)
		FWidth = Value
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
		Return FItems.Items[Index] 'QListViewItem(FItems.Items[Index])
	End Property
	
	Property ListViewItems.Item(Index As Integer, Value As ListViewItem Ptr)
		'QToolButton(FItems.Items[Index]) = Value
		FItems.Items[Index] = Value  'David Change
	End Property
	
	#ifdef __USE_GTK__
		Function ListViewItems.FindByIterUser_Data(User_Data As Any Ptr) As ListViewItem Ptr
			For i As Integer = 0 To Count - 1
				If Item(i)->TreeIter.User_Data = User_Data Then Return Item(i)
			Next i
			Return 0
		End Function
	#endif
	
	Function ListViewItems.Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0, Index As Integer = -1) As ListViewItem Ptr
		PItem = New ListViewItem
		FItems.Add PItem
		With *PItem
			.ImageIndex     = FImageIndex
			.Text(0)        = FCaption
			.State        = State
			.Indent        = Indent
		End With
		#ifdef __USE_GTK__
			Cast(ListView Ptr, Parent)->Init
			gtk_list_store_append (Cast(ListView Ptr, Parent)->ListStore, @PItem->TreeIter)
			gtk_list_store_set (Cast(ListView Ptr, Parent)->ListStore, @PItem->TreeIter, 1, ToUtf8(FCaption), -1)
		#else
			lvi.Mask = LVIF_TEXT Or LVIF_IMAGE Or LVIF_STATE Or LVIF_INDENT
			lvi.pszText  = @FCaption
			lvi.cchTextMax = Len(FCaption)
			lvi.iItem = IIf(Index = -1, FItems.Count - 1, Index)
			lvi.iSubItem = 0
			lvi.iImage   = FImageIndex
			lvi.State   = INDEXTOSTATEIMAGEMASK(State)
			lvi.stateMask = LVIS_STATEIMAGEMASK
			lvi.iIndent   = Indent
		#endif
		If Parent Then
			PItem->Parent = Parent
			PItem->Text(0) = FCaption
			#ifndef __USE_GTK__
				If Parent->Handle Then ListView_InsertItem(Parent->Handle, @lvi)
			#endif
		End If
		Return PItem
	End Function
	
	Function ListViewItems.Add(ByRef FCaption As WString = "", ByRef FImageKey As WString, State As Integer = 0, Indent As Integer = 0, Index As Integer = -1) As ListViewItem Ptr
		If Parent AndAlso Cast(ListView Ptr, Parent)->Images Then
			PItem = Add(FCaption, Cast(ListView Ptr, Parent)->Images->IndexOf(FImageKey), State, Indent, Index)
		Else
			PItem = Add(FCaption, -1, State, Indent, Index)
		End If
		If PItem Then PItem->ImageKey = FImageKey
		Return PItem
	End Function
	
	Function ListViewItems.Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0) As ListViewItem Ptr
		Dim As ListViewItem Ptr PItem
		#ifndef __USE_GTK__
			Dim As LVITEM lvi
		#endif
		PItem = New ListViewItem
		FItems.Insert Index, PItem
		With *PItem
			.ImageIndex     = FImageIndex
			.Text(0)        = FCaption
			.State          = State
			.Indent         = Indent
		End With
		#ifndef __USE_GTK__
			lvi.Mask = LVIF_TEXT Or LVIF_IMAGE Or LVIF_State Or LVIF_Indent
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
		#endif
		Return PItem
	End Function
	
	Sub ListViewItems.Remove(Index As Integer)
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->widget Then
				gtk_list_store_remove(Cast(ListView Ptr, Parent)->ListStore, @This.Item(Index)->TreeIter)
			End If
		#else
			If Parent AndAlso Parent->Handle Then
				ListView_DeleteItem(Parent->Handle, Index)
			End If
		#endif
		FItems.Remove Index
	End Sub
	
	#ifndef __USE_GTK__
		Function CompareFunc(ByVal lParam1 As LPARAM, ByVal lParam2 As LPARAM, ByVal lParamSort As LPARAM) As Long
			Return 0
		End Function
	#endif
	
	Sub ListViewItems.Sort
		#ifndef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				'Parent->Perform LVM_SORTITEMS, 0, @CompareFunc
				'ListView_SortItems
			End If
		#endif
	End Sub
	
	Function ListViewItems.IndexOf(ByRef FItem As ListViewItem Ptr) As Integer
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
	
	#ifdef __USE_GTK__
		Sub ListViewColumns.Cell_Edited(renderer As GtkCellRendererText Ptr, path As gchar Ptr, new_text As gchar Ptr, user_data As Any Ptr)
			Dim As ListViewColumn Ptr PColumn = user_data
			If PColumn = 0 Then Exit Sub
			Dim As ListView Ptr lv = Cast(ListView Ptr, PColumn->Parent)
			If lv = 0 Then Exit Sub
			If lv->OnCellEdited Then lv->OnCellEdited(*lv, Val(*path), PColumn->Index, *new_text)
		End Sub
	#endif
	
	Function ListViewColumns.Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As ColumnFormat = cfLeft, ColEditable As Boolean = False) As ListViewColumn Ptr
		Dim As ListViewColumn Ptr PColumn
		Dim As Integer Index
		#ifndef __USE_GTK__
			Dim As LVCOLUMN lvc
		#endif
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
		#ifdef __USE_GTK__
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
					g_value_set_boolean(@bValue, True)
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
				#ifdef __USE_GTK3__
					gtk_tree_view_column_set_fixed_width(PColumn->Column, Max(-1, iWidth))
				#else
					gtk_tree_view_column_set_fixed_width(PColumn->Column, Max(1, iWidth))
				#endif
			End If
		#else
			lvC.mask      =  LVCF_FMT Or LVCF_WIDTH Or LVCF_TEXT Or LVCF_SUBITEM
			lvC.fmt       =  Format
			lvc.cx		  = IIf(iWidth = -1, 50, iWidth)
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
	
	Sub ListViewColumns.Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer, Format As ColumnFormat = cfLeft)
		Dim As ListViewColumn Ptr PColumn
		#ifndef __USE_GTK__
			Dim As LVCOLUMN lvc
		#endif
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
				
			#endif
		#else
			
		#endif
	End Property
	
	Property ListView.View As ViewStyle
		#ifndef __USE_GTK__
			If Handle Then
				FView = ListView_GetView(Handle)
			End If
		#endif
		Return FView
	End Property
	
	Property ListView.View(Value As ViewStyle)
		FView = Value
		#ifndef __USE_GTK__
			If Handle Then Perform LVM_SETVIEW, Cast(wparam, Cast(dword, Value)), 0
		#endif
	End Property
	
	Property ListView.SelectedItem As ListViewItem Ptr
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			If gtk_tree_selection_get_selected(TreeSelection, NULL, @iter) Then
				Return ListItems.FindByIterUser_Data(iter.User_Data)
			End If
		#else
			If Handle Then
				Dim As Integer item = ListView_GetNextItem(Handle, -1, LVNI_SELECTED)
				If item <> -1 Then Return ListItems.Item(item)
			End If
		#endif
		Return 0
	End Property
	
	Property ListView.SelectedItemIndex As Integer
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			If gtk_tree_selection_get_selected(TreeSelection, NULL, @iter) Then
				Dim As ListViewItem Ptr lvi = ListItems.FindByIterUser_Data(iter.User_Data)
				If lvi <> 0 Then Return lvi->Index
			End If
		#else
			If Handle Then
				Return ListView_GetNextItem(Handle, -1, LVNI_SELECTED)
			End If
		#endif
		Return -1
	End Property
	
	Property ListView.SelectedItemIndex(Value As Integer)
		#ifdef __USE_GTK__
			If TreeSelection Then
				If Value = -1 Then
					gtk_tree_selection_unselect_all(TreeSelection)
				ElseIf Value > -1 AndAlso Value < ListItems.Count Then
					gtk_tree_selection_select_iter(TreeSelection, @ListItems.Item(Value)->TreeIter)
					gtk_tree_view_scroll_to_cell(gtk_tree_view(widget), gtk_tree_model_get_path(gtk_tree_model(ListStore), @ListItems.Item(Value)->TreeIter), NULL, False, 0, 0)
				End If
			End If
		#else
			If Handle Then
				ListView_SetItemState(Handle, Value, LVIS_FOCUSED Or LVIS_SELECTED, LVIS_FOCUSED Or LVIS_SELECTED)
			End If
		#endif
	End Property
	
	Property ListView.SelectedItem(Value As ListViewItem Ptr)
		Value->SelectItem
	End Property
	
	Property ListView.SelectedColumn As ListViewColumn Ptr
		#ifndef __USE_GTK__
			If Handle Then
				Return Columns.Column(ListView_GetSelectedColumn(Handle))
			End If
		#endif
		Return 0
	End Property
	
	Property ListView.Sort As SortStyle
		Return FSortStyle
	End Property
	
	Property ListView.Sort(Value As SortStyle)
		FSortStyle = Value
		#ifndef __USE_GTK__
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
		#else
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
				Case LVN_ITEMCHANGING: If OnSelectedItemChanging Then OnSelectedItemChanging(This, lvp->iItem)
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
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	#ifndef __USE_GTK__
		Sub ListView.HandleIsDestroyed(ByRef Sender As Control)
		End Sub
		
		Sub ListView.HandleIsAllocated(ByRef Sender As Control)
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
					lvStyle = lvStyle Or  LVS_EX_GRIDLINES Or LVS_EX_FULLROWSELECT Or LVS_EX_DOUBLEBUFFER 'David Change
					SendMessage(.FHandle, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, ByVal lvStyle)
					If .FView <> 0 Then .View = .View
					For i As Integer = 0 To .Columns.Count -1
						Dim lvc As LVCOLUMN
						lvc.mask            = LVCF_FMT Or LVCF_WIDTH Or LVCF_TEXT Or LVCF_SUBITEM
						lvc.fmt             = .Columns.Column(i)->Format
						lvc.cx              = 0
						lvc.pszText         = @.Columns.Column(i)->Text
						lvc.cchTextMax      = Len(.Columns.Column(i)->Text)
						lvc.iImage          = .Columns.Column(i)->ImageIndex
						lvc.iSubItem        = i
						ListView_InsertColumn(.FHandle, i, @lvc)
						ListView_SetColumnWidth(.FHandle, i, .Columns.Column(i)->Width)
					Next i
					Var TempHandle = .FHandle
					For i As Integer = 0 To .ListItems.Count -1
						For j As Integer = 0 To .Columns.Count -1
							.FHandle = 0
							Dim lvi As LVITEM
							lvi.pszText         = @.ListItems.Item(i)->Text(j)
							lvi.cchTextMax      = Len(.ListItems.Item(i)->Text(j))
							lvi.iItem           = i
							lvi.iSubItem        = j
							If j = 0 Then
								lvi.Mask = LVIF_TEXT Or LVIF_IMAGE Or LVIF_State Or LVIF_Indent
								lvi.iImage          = .ListItems.Item(i)->ImageIndex
								lvi.State   = INDEXTOSTATEIMAGEMASK(.ListItems.Item(i)->State)
								lvi.stateMask = LVIS_STATEIMAGEMASK
								lvi.iIndent   = .ListItems.Item(i)->Indent
								.FHandle = TempHandle
								ListView_InsertItem(.FHandle, @lvi)
							Else
								.FHandle = TempHandle
								lvi.Mask = LVIF_TEXT
								ListView_SetItem(.FHandle, @lvi)
							End If
						Next j
					Next i
					.SelectedItemIndex = 0
				End With
			End If
		End Sub
	#endif
	
	Operator ListView.Cast As Control Ptr
		Return @This
	End Operator
	
	#ifdef __USE_GTK__
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
	#endif
	
	Constructor ListView
		#ifdef __USE_GTK__
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
			gtk_tree_view_set_enable_tree_lines(GTK_TREE_VIEW(widget), True)
			gtk_tree_view_set_grid_lines(GTK_TREE_VIEW(widget), GTK_TREE_VIEW_GRID_LINES_BOTH)
			ColumnTypes = New GType[1]
			ColumnTypes[0] = G_TYPE_STRING
			This.RegisterClass "ListView", @This
		#endif
		ListItems.Parent = @This
		Columns.Parent = @This
		FEnabled = True
		FVisible = True
		FTabStop = True
		With This
			.Child             = @This
			#ifndef __USE_GTK__
				.OnHandleIsAllocated = @HandleIsAllocated
				.OnHandleIsDestroyed = @HandleIsDestroyed
				.RegisterClass "ListView", WC_ListView
				.ChildProc         = @WndProc
				.ExStyle           = WS_EX_CLIENTEDGE
				.Style             = WS_CHILD Or WS_TABSTOP Or WS_VISIBLE Or LVS_REPORT Or LVS_ICON Or LVS_SINGLESEL Or LVS_SHOWSELALWAYS
				WLet FClassAncestor, WC_ListView
			#endif
			WLet FClassName, "ListView"
			.Width             = 121
			.Height            = 121
		End With
	End Constructor
	
	Destructor ListView
		ListItems.Clear
		#ifndef __USE_GTK__
			UnregisterClass "ListView",GetmoduleHandle(NULL)
		#else
			If ColumnTypes Then Delete [] ColumnTypes
		#endif
	End Destructor
End Namespace
