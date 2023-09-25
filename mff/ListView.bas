'###############################################################################
'#  ListView.bi                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                         #
'###############################################################################

#include once "ListView.bi"
#ifdef __USE_WINAPI__
	#include once "win\tmschema.bi"
#endif

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function ListView.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "allowcolumnreorder": Return @FAllowColumnReorder
			Case "borderselect": Return @FBorderSelect
			Case "checkboxes": Return @FCheckBoxes
			Case "columnheaderhidden": Return @FColumnHeaderHidden
			Case "fullrowselect": Return @FFullRowSelect
			Case "hovertime": Return @FHoverTime
			Case "gridlines": Return @FGridLines
			Case "images": Return Images
			Case "stateimages": Return StateImages
			Case "smallimages": Return SmallImages
			Case "groupheaderimages": Return GroupHeaderImages
			Case "labeltip": Return @FLabelTip
			Case "singleclickactivate": Return @FSingleClickActivate
			Case "sort": Return @FSortStyle
			Case "tabindex": Return @FTabIndex
			Case "hoverselection": Return @FHoverSelection
			Case "view": Return @FView
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function ListView.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "allowcolumnreorder": AllowColumnReorder = QBoolean(Value)
				Case "borderselect": BorderSelect = QBoolean(Value)
				Case "checkboxes": CheckBoxes = QBoolean(Value)
				Case "columnheaderhidden": ColumnHeaderHidden = QBoolean(Value)
				Case "fullrowselect": FullRowSelect = QBoolean(Value)
				Case "hovertime": HoverTime = QInteger(Value)
				Case "gridlines": GridLines = QBoolean(Value)
				Case "images": Images = Cast(ImageList Ptr, Value)
				Case "stateimages": StateImages = Cast(ImageList Ptr, Value)
				Case "smallimages": SmallImages = Cast(ImageList Ptr, Value)
				Case "groupheaderimages": GroupHeaderImages = Cast(ImageList Ptr, Value)
				Case "labeltip": LabelTip = QBoolean(Value)
				Case "singleclickactivate": SingleClickActivate = QBoolean(Value)
				Case "sort": Sort = *Cast(SortStyle Ptr, Value)
				Case "tabindex": TabIndex = QInteger(Value)
				Case "hoverselection": HoverSelection = QBoolean(Value)
				Case "view": This.View = *Cast(ViewStyle Ptr, Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Property ListView.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property ListView.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property ListView.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property ListView.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Function ListViewItem.Index As Integer
		If Parent Then
			Return Cast(ListView Ptr, Parent)->ListItems.IndexOf(@This)
		Else
			Return -1
		End If
	End Function
	
	Private Property ListViewItem.Selected As Boolean
		#ifdef __USE_GTK__
			'Dim As GtkTreeIter iter
			'Dim As Boolean bChecked
			'gtk_tree_model_get_iter_from_string(ListViewGetModel(Parent->Handle), @iter, Trim(Str(This.Index)))
			'gtk_tree_model_get(ListViewGetModel(Parent->Handle), @iter, 0, @bChecked, -1)
			'Return bChecked
		#elseif defined(__USE_WINAPI__)
			If Parent AndAlso Parent->Handle Then
				lvi.mask = LVIF_STATE
				lvi.iItem = Index
				lvi.iSubItem = 0
    			lvi.stateMask = LVIS_SELECTED
				ListView_GetItem(Parent->Handle, @lvi)
				FSelected = (lvi.state And LVIS_SELECTED) = LVIS_SELECTED
			End If
		#endif
		Return FSelected
	End Property
	
	Private Property ListViewItem.Selected(Value As Boolean)
		FSelected = Value
		#ifdef __USE_WINAPI__
			If Parent AndAlso Parent->Handle Then
				lvi.mask = LVIF_STATE
				lvi.iItem = Index
				ListView_GetItem(Parent->Handle, @lvi)
				If Value Then
					If (lvi.state And LVIS_SELECTED) <> LVIS_SELECTED Then
						lvi.state = lvi.state Or LVIS_SELECTED
						ListView_SetItem(Parent->Handle, @lvi)
					End If
				ElseIf (lvi.state And LVIS_SELECTED) = LVIS_SELECTED Then
					lvi.state = lvi.state And Not LVIS_SELECTED
					ListView_SetItem(Parent->Handle, @lvi)
				End If
			End If
		#endif
	End Property
	
	Private Sub ListViewItem.SelectItem
		#ifdef __USE_GTK__
			If Parent Then
				If GTK_IS_ICON_VIEW(Parent->Handle) Then
					gtk_icon_view_select_path(GTK_ICON_VIEW(Parent->Handle), gtk_tree_path_new_from_string(Trim(Str(This.Index))))
				Else
					If gtk_tree_view_get_selection(GTK_TREE_VIEW(Parent->Handle)) Then
						gtk_tree_selection_select_iter(gtk_tree_view_get_selection(GTK_TREE_VIEW(Parent->Handle)), @TreeIter)
					End If
				End If
			End If
		#elseif defined(__USE_WINAPI__)
			If Parent AndAlso Parent->Handle Then
				Dim lvi As LVITEM
				lvi.iItem = Index
				lvi.iSubItem   = 0
				lvi.state    = LVIS_SELECTED Or LVIS_FOCUSED
				lvi.stateMask = LVIF_STATE
				ListView_SetItem(Parent->Handle, @lvi)
			End If
		#endif
	End Sub
	
	Private Property ListViewItem.Text(iSubItem As Integer) ByRef As WString
		#ifdef __USE_WINAPI__
			If Parent AndAlso Parent->Handle Then
				WReAllocate(FText, 255)
				lvi.mask = LVIF_TEXT
				lvi.iItem = Index
				lvi.iSubItem   = iSubItem
				lvi.pszText    = FText
				lvi.cchTextMax = 255
				ListView_GetItem(Parent->Handle, @lvi)
				FSubItems.Item(iSubItem) = *FText
				Return FSubItems.Item(iSubItem)
			Else
				If FSubItems.Count > iSubItem Then
					Return FSubItems.Item(iSubItem)
				Else
					Return WStr("")
				End If
			End If
		#else
			If FSubItems.Count > iSubItem Then
				Return FSubItems.Item(iSubItem)
			Else
				Return WStr("")
			End If
		#endif
	End Property
	
	#ifdef __USE_GTK__
		Private Function ListViewGetModel(widget As GtkWidget Ptr) As GtkTreeModel Ptr
			If GTK_IS_WIDGET(widget) Then
				If GTK_IS_TREE_VIEW(widget) Then
					Return gtk_tree_view_get_model(GTK_TREE_VIEW(widget))
				Else
					Return gtk_icon_view_get_model(GTK_ICON_VIEW(widget))
				End If
			End If
		End Function
	#endif
	
	Private Property ListViewItem.Text(iSubItem As Integer, ByRef Value As WString)
		WLet(FText, Value)
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
				If ListViewGetModel(Parent->Handle) Then
					gtk_list_store_set(GTK_LIST_STORE(ListViewGetModel(Parent->Handle)), @TreeIter, iSubItem + 3, ToUtf8(Value), -1)
				End If
			#elseif defined(__USE_WINAPI__)
				If Parent->Handle Then
					lvi.mask = LVIF_TEXT
					lvi.iItem = Index
					lvi.iSubItem   = iSubItem
					lvi.pszText    = FText
					lvi.cchTextMax = Len(*FText)
					ListView_SetItem(Parent->Handle, @lvi)
				End If
			#endif
		End If
	End Property
	
	Private Property ListViewItem.State As Integer
		#ifdef __USE_WINAPI__
			If Parent AndAlso Parent->Handle Then
				lvi.mask = LVIF_STATE
				lvi.iItem = Index
				lvi.iSubItem   = 0
				ListView_GetItem(Parent->Handle, @lvi)
				FState = lvi.state
			End If
		#endif
		Return FState
	End Property
	
	Private Property ListViewItem.State(Value As Integer)
		FState = Value
		#ifdef __USE_WINAPI__
			If Parent AndAlso Parent->Handle Then
				lvi.mask = LVIF_STATE
				lvi.iItem = Index
				lvi.iSubItem   = 0
				lvi.state    = Value
				ListView_SetItem(Parent->Handle, @lvi)
			End If
		#endif
	End Property
	
	Private Property ListViewItem.Indent As Integer
		#ifdef __USE_WINAPI__
			If Parent AndAlso Parent->Handle Then
				lvi.mask = LVIF_INDENT
				lvi.iItem = Index
				lvi.iSubItem   = 0
				ListView_GetItem(Parent->Handle, @lvi)
				FIndent = lvi.iIndent
			End If
		#endif
		Return FIndent
	End Property
	
	Private Property ListViewItem.Indent(Value As Integer)
		FIndent = Value
		#ifdef __USE_WINAPI__
			If Parent AndAlso Parent->Handle Then
				lvi.mask = LVIF_INDENT
				lvi.iItem = Index
				lvi.iSubItem   = 0
				lvi.iIndent    = Value
				ListView_SetItem(Parent->Handle, @lvi)
			End If
		#endif
	End Property
	
	Const LVIS_UNCHECKED = 4096
	Const LVIS_CHECKED = 8192
	Const LVIS_CHECKEDMASK = 12288
	
	Private Property ListViewItem.Checked As Boolean
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			Dim As Boolean bChecked
			gtk_tree_model_get_iter_from_string(ListViewGetModel(Parent->Handle), @iter, Trim(Str(This.Index)))
			gtk_tree_model_get(ListViewGetModel(Parent->Handle), @iter, 0, @bChecked, -1)
			Return bChecked
		#elseif defined(__USE_WINAPI__)
			If Parent AndAlso Parent->Handle Then
				lvi.mask = LVIF_STATE
				lvi.iItem = Index
				lvi.stateMask = LVIS_CHECKEDMASK
				ListView_GetItem(Parent->Handle, @lvi)
				FChecked = lvi.state = LVIS_CHECKED
			End If
		#endif
		Return FChecked
	End Property
	
	Private Property ListViewItem.Checked(Value As Boolean)
		FChecked = Value
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			gtk_tree_model_get_iter_from_string(ListViewGetModel(Parent->Handle), @iter, Trim(Str(This.Index)))
			gtk_list_store_set(GTK_LIST_STORE(ListViewGetModel(Parent->Handle)), @iter, 0, Value, -1)
		#elseif defined(__USE_WINAPI__)
			If Parent AndAlso Parent->Handle Then
				lvi.mask = LVIF_STATE
				lvi.iItem = Index
				lvi.stateMask = LVIS_CHECKEDMASK
				If Value Then
					lvi.state = LVIS_CHECKED
				Else
					lvi.state = LVIS_UNCHECKED
				End If
				ListView_SetItem(Parent->Handle, @lvi)
			End If
		#endif
	End Property
	
	Private Property ListViewItem.Hint ByRef As WString
		Return WGet(FHint)
	End Property
	
	Private Property ListViewItem.Hint(ByRef Value As WString)
		WLet(FHint, Value)
	End Property
	
	Private Property ListViewItem.ImageIndex As Integer
		Return FImageIndex
	End Property
	
	Private Property ListViewItem.ImageIndex(Value As Integer)
		If Value <> FImageIndex Then
			FImageIndex = Value
			#ifdef __USE_WINAPI__
				If Parent AndAlso Parent->Handle Then
					lvi.mask = LVIF_IMAGE
					lvi.iItem = Index
					lvi.iSubItem   = 0
					lvi.iImage     = Value
					ListView_SetItem(Parent->Handle, @lvi)
				End If
			#endif
		End If
	End Property
	
	Private Property ListViewItem.SelectedImageIndex As Integer
		Return FImageIndex
	End Property
	
	Private Property ListViewItem.SelectedImageIndex(Value As Integer)
		If Value <> FSelectedImageIndex Then
			FSelectedImageIndex = Value
			If Parent Then
				With QControl(Parent)
					'.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
				End With
			End If
		End If
	End Property
	
	Private Property ListViewItem.Visible As Boolean
		Return FVisible
	End Property
	
	Private Property ListViewItem.Visible(Value As Boolean)
		If Value <> FVisible Then
			FVisible = Value
			If Parent Then
				With QControl(Parent)
					'.Perform(TB_HIDEBUTTON, FCommandID, MakeLong(NOT FVisible, 0))
				End With
			End If
		End If
	End Property
	
	Private Property ListViewItem.ImageKey ByRef As WString
		Return WGet(FImageKey)
	End Property
	
	Private Property ListViewItem.ImageKey(ByRef Value As WString)
		'If Value <> *FImageKey Then
		WLet(FImageKey, Value)
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				Dim As GError Ptr gerr
				If Value <> "" Then
					gtk_list_store_set(GTK_LIST_STORE(ListViewGetModel(Parent->Handle)), @TreeIter, 1, gtk_icon_theme_load_icon(gtk_icon_theme_get_default(), ToUtf8(Value), 16, GTK_ICON_LOOKUP_USE_BUILTIN, @gerr), -1)
					gtk_list_store_set(GTK_LIST_STORE(ListViewGetModel(Parent->Handle)), @TreeIter, 2, ToUtf8(Value), -1)
				End If
			End If
		#elseif defined(__USE_WINAPI__)
			If Parent AndAlso Parent->Handle AndAlso Cast(ListView Ptr, Parent)->Images Then
				FImageIndex = Cast(ListView Ptr, Parent)->Images->IndexOf(Value)
				lvi.mask = LVIF_IMAGE
				lvi.iItem = Index
				lvi.iSubItem   = 0
				lvi.iImage     = FImageIndex
				ListView_SetItem(Parent->Handle, @lvi)
			End If
		#endif
		'End If
	End Property
	
	Private Property ListViewItem.SelectedImageKey ByRef As WString
		Return WGet(FImageKey)
	End Property
	
	Private Property ListViewItem.SelectedImageKey(ByRef Value As WString)
		'If Value <> *FSelectedImageKey Then
		WLet(FSelectedImageKey, Value)
		If Parent Then
			With QControl(Parent)
				'.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
			End With
		End If
		'End If
	End Property
	
	Private Operator ListViewItem.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor ListViewItem
		FHint = 0 'CAllocate_(0)
		FText = 0 'CAllocate_(0)
		FVisible    = 1
		Text(0)    = ""
		Hint       = ""
		FImageIndex = -1
		FSelectedImageIndex = -1
		FSmallImageIndex = -1
	End Constructor
	
	Private Destructor ListViewItem
		If FHint Then _Deallocate( FHint)
		If FText Then _Deallocate( FText)
		If FImageKey Then _Deallocate( FImageKey)
		If FSelectedImageKey Then _Deallocate( FSelectedImageKey)
		If FSmallImageKey Then _Deallocate( FSmallImageKey)
	End Destructor
	
	Private Sub ListViewColumn.SelectItem
		#ifdef __USE_WINAPI__
			If Parent AndAlso Parent->Handle Then ListView_SetSelectedColumn(Parent->Handle, Index)
		#endif
	End Sub
	
	Private Property ListViewColumn.Text ByRef As WString
		Return WGet(FText)
	End Property
	
	Private Property ListViewColumn.Text(ByRef Value As WString)
		WLet(FText, Value)
		#ifdef __USE_WINAPI__
			If Parent AndAlso Parent->Handle Then
				Dim lvc As LVCOLUMN
				lvc.mask = LVCF_TEXT Or LVCF_SUBITEM
				lvc.iSubItem = Index
				lvc.pszText = FText
				lvc.cchTextMax = Len(*FText)
				ListView_SetColumn(Parent->Handle, Index, @lvc)
			End If
		#endif
	End Property
	
	Private Property ListViewColumn.Width As Integer
		#if defined(__USE_WINAPI__)
			If Parent AndAlso Parent->Handle Then
				Dim lvc As LVCOLUMN
				lvc.mask = LVCF_WIDTH Or LVCF_SUBITEM
				lvc.iSubItem = Index
				ListView_GetColumn(Parent->Handle, Index, @lvc)
				FWidth = UnScaleX(lvc.cx)
			End If
		#endif
		Return FWidth
	End Property
	
	Private Property ListViewColumn.Width(Value As Integer)
		FWidth = Value
		#ifdef __USE_GTK__
			#ifdef __USE_GTK3__
				If This.Column Then gtk_tree_view_column_set_fixed_width(This.Column, Max(-1, Value))
			#else
				If This.Column Then gtk_tree_view_column_set_fixed_width(This.Column, Max(1, Value))
			#endif
		#elseif defined(__USE_WINAPI__)
			If Parent AndAlso Parent->Handle Then
				Dim lvc As LVCOLUMN
				lvc.mask = LVCF_WIDTH Or LVCF_SUBITEM
				lvc.iSubItem = Index
				lvc.cx = ScaleX(Value)
				ListView_SetColumn(Parent->Handle, Index, @lvc)
			End If
		#endif
	End Property
	
	Private Property ListViewColumn.Format As ColumnFormat
		Return FFormat
	End Property
	
	Private Property ListViewColumn.Format(Value As ColumnFormat)
		FFormat = Value
		#ifdef __USE_WINAPI__
			If Parent AndAlso Parent->Handle Then
				Dim lvc As LVCOLUMN
				lvc.mask = LVCF_FMT Or LVCF_SUBITEM
				lvc.iSubItem = Index
				lvc.fmt = Value
				ListView_SetColumn(Parent->Handle, Index, @lvc)
			End If
		#endif
	End Property
	
	Private Property ListViewColumn.Hint ByRef As WString
		Return WGet(FHint)
	End Property
	
	Private Property ListViewColumn.Hint(ByRef Value As WString)
		WLet(FHint, Value)
	End Property
	
	Private Property ListViewColumn.ImageIndex As Integer
		Return FImageIndex
	End Property
	
	Private Property ListViewColumn.ImageIndex(Value As Integer)
		If Value <> FImageIndex Then
			FImageIndex = Value
			If Parent Then
				With QControl(Parent)
					'.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
				End With
			End If
		End If
	End Property
	
	Private Property ListViewColumn.Visible As Boolean
		Return FVisible
	End Property
	
	Private Property ListViewColumn.Visible(Value As Boolean)
		If Value <> FVisible Then
			FVisible = Value
			If Parent Then
				With QControl(Parent)
					'.Perform(TB_HIDEBUTTON, FCommandID, MakeLong(NOT FVisible, 0))
				End With
			End If
		End If
	End Property
	
	Private Property ListViewColumn.Editable As Boolean
		Return FEditable
	End Property
	
	Private Property ListViewColumn.Editable(Value As Boolean)
		If Value <> FEditable Then
			FEditable = Value
		End If
	End Property
	
	Private Operator ListViewColumn.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor ListViewColumn
		FHint = 0 'CAllocate_(0)
		FText = 0 'CAllocate_(0)
		FVisible    = 1
		Text    = ""
		Hint       = ""
		FImageIndex = -1
	End Constructor
	
	Private Destructor ListViewColumn
		If FHint Then _Deallocate( FHint)
		If FText Then _Deallocate( FText)
	End Destructor
	
	Private Property ListViewItems.Count As Integer
		Return FItems.Count
	End Property
	
	Private Property ListViewItems.Count(Value As Integer)
	End Property
	
	Private Property ListViewItems.Item(Index As Integer) As ListViewItem Ptr
		If Index >= 0 AndAlso Index < FItems.Count Then
			Return FItems.Items[Index] 'QListViewItem(FItems.Items[Index])
		End If
	End Property
	
	Private Property ListViewItems.Item(Index As Integer, Value As ListViewItem Ptr)
		If Index >= 0 AndAlso Index < FItems.Count Then
			FItems.Items[Index] = Value  'David Change
		End If
	End Property
	
	#ifdef __USE_GTK__
		Private Function ListViewItems.FindByIterUser_Data(User_Data As Any Ptr) As ListViewItem Ptr
			For i As Integer = 0 To Count - 1
				If Item(i)->TreeIter.user_data = User_Data Then Return Item(i)
			Next i
			Return 0
		End Function
	#endif
	
	Private Function ListViewItems.Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0, Index As Integer = -1) As ListViewItem Ptr
		PItem = _New( ListViewItem)
		Dim i As Integer = Index
		Dim As SortStyle iSortStyle = Cast(ListView Ptr, Parent)->Sort
		If iSortStyle <> SortStyle.ssNone Then
			For i = 0 To FItems.Count - 1
				If iSortStyle = SortStyle.ssSortAscending Then
					If Cast(ListViewItem Ptr, FItems.Item(i))->Text(0) > FCaption Then Exit For
				Else
					If Cast(ListViewItem Ptr, FItems.Item(i))->Text(0) < FCaption Then Exit For
				End If
			Next
			FItems.Insert i, PItem
		ElseIf Index = -1 Then
			FItems.Add PItem
		Else
			FItems.Insert i, PItem
		End If
		With *PItem
			.ImageIndex     = FImageIndex
			.Text(0)        = FCaption
			.State        = State
			.Indent        = Indent
		End With
		#ifdef __USE_GTK__
			Cast(ListView Ptr, Parent)->Init
			If iSortStyle <> SortStyle.ssNone OrElse Index <> -1 Then
				gtk_list_store_insert(GTK_LIST_STORE(ListViewGetModel(Parent->Handle)), @PItem->TreeIter, i)
			Else
				gtk_list_store_append(GTK_LIST_STORE(ListViewGetModel(Parent->Handle)), @PItem->TreeIter)
			End If
			gtk_list_store_set (GTK_LIST_STORE(ListViewGetModel(Parent->Handle)), @PItem->TreeIter, 3, ToUtf8(FCaption), -1)
		#elseif defined(__USE_WINAPI__)
			lvi.mask = LVIF_TEXT Or LVIF_IMAGE Or LVIF_STATE Or LVIF_INDENT Or LVIF_PARAM
			lvi.pszText  = @FCaption
			lvi.cchTextMax = Len(FCaption)
			lvi.iItem = IIf(Index = -1, FItems.Count - 1, Index)
			lvi.iSubItem = 0
			lvi.iImage   = FImageIndex
			lvi.state   = INDEXTOSTATEIMAGEMASK(State)
			lvi.stateMask = LVIS_STATEIMAGEMASK
			lvi.iIndent   = Indent
			lvi.lParam    = Cast(LPARAM, PItem)
		#endif
		If Parent Then
			#ifdef __USE_WINAPI__
				If Parent->Handle Then ListView_InsertItem(Parent->Handle, @lvi)
			#endif
			PItem->Parent = Parent
			PItem->Text(0) = FCaption
		End If
		Return PItem
	End Function
	
	Private Function ListViewItems.Add(ByRef FCaption As WString = "", ByRef FImageKey As WString, State As Integer = 0, Indent As Integer = 0, Index As Integer = -1) As ListViewItem Ptr
		If Parent AndAlso Cast(ListView Ptr, Parent)->Images Then
			PItem = Add(FCaption, Cast(ListView Ptr, Parent)->Images->IndexOf(FImageKey), State, Indent, Index)
		Else
			PItem = Add(FCaption, -1, State, Indent, Index)
		End If
		If PItem Then PItem->ImageKey = FImageKey
		Return PItem
	End Function
	
	Private Function ListViewItems.Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, State As Integer = 0, Indent As Integer = 0) As ListViewItem Ptr
		Dim As ListViewItem Ptr PItem
		#ifdef __USE_WINAPI__
			Dim As LVITEM lvi
		#endif
		PItem = _New( ListViewItem)
		FItems.Insert Index, PItem
		With *PItem
			.ImageIndex     = FImageIndex
			.Text(0)        = FCaption
			.State          = State
			.Indent         = Indent
		End With
		#ifdef __USE_WINAPI__
			lvi.mask = LVIF_TEXT Or LVIF_IMAGE Or LVIF_STATE Or LVIF_INDENT Or LVIF_PARAM
			lvi.pszText  = @FCaption
			lvi.cchTextMax = Len(FCaption)
			lvi.iItem = Index
			lvi.iImage   = FImageIndex
			lvi.state   = INDEXTOSTATEIMAGEMASK(State)
			lvi.stateMask = LVIS_STATEIMAGEMASK
			lvi.iIndent   = Indent
			lvi.lParam    = Cast(LPARAM, PItem)
			If Parent Then
				PItem->Parent = Parent
				If Parent->Handle Then ListView_InsertItem(Parent->Handle, @lvi)
			End If
		#endif
		Return PItem
	End Function
	
	Private Sub ListViewItems.Remove(Index As Integer)
		If Count < 1 OrElse Index < 0 OrElse Index > Count - 1 Then Exit Sub
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				gtk_list_store_remove(GTK_LIST_STORE(ListViewGetModel(Parent->Handle)), @This.Item(Index)->TreeIter)
			End If
		#elseif defined(__USE_WINAPI__)
			If Parent AndAlso Parent->Handle Then
				ListView_DeleteItem(Parent->Handle, Index)
			End If
		#endif
		_Delete(Cast(ListViewItem Ptr, FItems.Items[Index]))
		FItems.Remove Index
	End Sub
	
	#ifdef __USE_WINAPI__
		Private Function ListViewCompareFunc(ByVal lParam1 As LPARAM, ByVal lParam2 As LPARAM, ByVal lParamSort As LPARAM) As Long
			Dim As ListViewItem Ptr FirstItem = Cast(ListViewItem Ptr, lParam1), SecondItem = Cast(ListViewItem Ptr, lParam2)
			If FirstItem <> 0 AndAlso SecondItem <> 0 Then
				Select Case FirstItem->Text(0)
				Case Is < SecondItem->Text(0): Return -1
				Case Is > SecondItem->Text(0): Return 1
				Case Else: Return 0
				End Select
			End If
			Return 0
		End Function
	#endif
	
	Private Sub ListViewItems.Sort
		#ifdef __USE_WINAPI__
			If Parent AndAlso Parent->Handle Then
				SendMessage Parent->Handle, LVM_SORTITEMS, 0, Cast(WPARAM, @ListViewCompareFunc)
				'ListView_SortItems Parent->Handle, @ListViewCompareFunc, 0
			End If
		#endif
	End Sub
	
	Private Function ListViewItems.IndexOf(ByRef FItem As ListViewItem Ptr) As Integer
		Return FItems.IndexOf(FItem)
	End Function
	
	Private Function ListViewItems.IndexOf(ByRef Caption As WString) As Integer
		For i As Integer = 0 To Count - 1
			If LCase(QListViewItem(FItems.Items[i]).Text(0)) = LCase(Caption) Then
				Return i
			End If
		Next i
		Return -1
	End Function
	
	Private Function ListViewItems.Contains(ByRef Caption As WString) As Boolean
		Return IndexOf(Caption) <> -1
	End Function
	
	Private Sub ListViewItems.Clear
		#ifdef __USE_GTK__
			If Parent AndAlso GTK_LIST_STORE(ListViewGetModel(Parent->Handle)) Then gtk_list_store_clear(GTK_LIST_STORE(ListViewGetModel(Parent->Handle)))
		#elseif defined(__USE_WINAPI__)
			If Parent AndAlso Parent->Handle Then SendMessage Parent->Handle, LVM_DELETEALLITEMS, 0, 0
		#endif
		For i As Integer = Count -1 To 0 Step -1
			_Delete( Cast(ListViewItem Ptr, FItems.Items[i]))
		Next i
		FItems.Clear
	End Sub
	
	Private Operator ListViewItems.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor ListViewItems
		This.Clear
	End Constructor
	
	Private Destructor ListViewItems
		#if defined(__USE_GTK__) AndAlso defined(__FB_WIN32__)
		#else
			This.Clear
		#endif
	End Destructor
	
	Private Property ListViewColumns.Count As Integer
		Return FColumns.Count
	End Property
	
	Private Property ListViewColumns.Count(Value As Integer)
	End Property
	
	Private Property ListViewColumns.Column(Index As Integer) As ListViewColumn Ptr
		Return QListViewColumn(FColumns.Items[Index])
	End Property
	
	Private Property ListViewColumns.Column(Index As Integer, Value As ListViewColumn Ptr)
		'QListViewColumn(FColumns.Items[Index]) = Value
	End Property
	
	#ifdef __USE_GTK__
		Private Sub ListViewColumns.Cell_Edited(renderer As GtkCellRendererText Ptr, path As gchar Ptr, new_text As gchar Ptr, user_data As Any Ptr)
			Dim As ListViewColumn Ptr PColumn = user_data
			If PColumn = 0 Then Exit Sub
			Dim As ListView Ptr lv = Cast(ListView Ptr, PColumn->Parent)
			If lv = 0 Then Exit Sub
			If lv->OnCellEdited Then lv->OnCellEdited(*lv->Designer, *lv, Val(*path), PColumn->Index, *new_text)
		End Sub
	
		Private Sub ListViewColumns.Check(cell As GtkCellRendererToggle Ptr, path As gchar Ptr, user_data As Any Ptr)
			Dim As ListView Ptr lv = user_data
			Dim As GtkListStore Ptr model = GTK_LIST_STORE(ListViewGetModel(lv->Handle))
			Dim As GtkTreeIter iter
			Dim As gboolean active
			
			active = gtk_cell_renderer_toggle_get_active (cell)
			
			gtk_tree_model_get_iter_from_string (GTK_TREE_MODEL (model), @iter, path)
			
			If (active) Then
				'gtk_cell_renderer_set_alignment(GTK_CELL_RENDERER(cell), 0, 0)
				gtk_list_store_set (GTK_LIST_STORE (model), @iter, 0, False, -1)
			Else
				'gtk_cell_renderer_set_alignment(GTK_CELL_RENDERER(cell), 0.5, 0.5)
				gtk_list_store_set (GTK_LIST_STORE (model), @iter, 0, True, -1)
			End If
		End Sub
	#endif
	
	Private Function ListViewColumns.Add(ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer = -1, Format As ColumnFormat = cfLeft, ColEditable As Boolean = False) As ListViewColumn Ptr
		Dim As ListViewColumn Ptr PColumn
		Dim As Integer Index
		#ifdef __USE_WINAPI__
			Dim As LVCOLUMN lvc
		#endif
		PColumn = _New( ListViewColumn)
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
				PColumn->Column = gtk_tree_view_column_new()
				gtk_tree_view_column_set_reorderable(PColumn->Column, Cast(ListView Ptr, Parent)->AllowColumnReorder)
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
					If Cast(ListView Ptr, Parent)->CheckBoxes Then
						Dim As GtkCellRenderer Ptr rendertoggle = gtk_cell_renderer_toggle_new()
						gtk_tree_view_column_pack_start(PColumn->Column, rendertoggle, False)
						gtk_tree_view_column_add_attribute(PColumn->Column, rendertoggle, ToUTF8("active"), 0)
						'gtk_cell_renderer_toggle_set_activatable(gtk_cell_renderer_toggle(rendertoggle), True)
						g_signal_connect(rendertoggle, "toggled", G_CALLBACK(@check), Parent)
					End If
					Dim As GtkCellRenderer Ptr renderpixbuf = gtk_cell_renderer_pixbuf_new()
					gtk_tree_view_column_pack_start(PColumn->Column, renderpixbuf, False)
					gtk_tree_view_column_add_attribute(PColumn->Column, renderpixbuf, ToUTF8("icon_name"), 2)
				End If
				g_signal_connect(G_OBJECT(rendertext), "edited", G_CALLBACK (@Cell_Edited), PColumn)
				gtk_tree_view_column_pack_start(PColumn->Column, rendertext, True)
				gtk_tree_view_column_add_attribute(PColumn->Column, rendertext, ToUTF8("text"), Index + 3)
				gtk_tree_view_column_set_resizable(PColumn->Column, True)
				gtk_tree_view_column_set_title(PColumn->Column, ToUTF8(FCaption))
				If gtk_is_tree_view(Parent->Handle) Then
					gtk_tree_view_append_column(GTK_TREE_VIEW(Parent->Handle), PColumn->Column)
				Else
					gtk_tree_view_append_column(GTK_TREE_VIEW(g_object_get_data(G_OBJECT(Parent->Handle), "@@@TreeView")), PColumn->Column)
				End If
				#ifdef __USE_GTK3__
					gtk_tree_view_column_set_fixed_width(PColumn->Column, Max(-1, iWidth))
				#else
					gtk_tree_view_column_set_fixed_width(PColumn->Column, Max(1, iWidth))
				#endif
			End If
		#elseif defined(__USE_WINAPI__)
			lvC.mask      =  LVCF_FMT Or LVCF_WIDTH Or LVCF_TEXT Or LVCF_SUBITEM
			lvC.fmt       =  Format
			lvc.cx		  = ScaleX(IIf(iWidth = -1, 50, iWidth))
			lvc.iImage   = PColumn->ImageIndex
			lvc.iSubItem = PColumn->Index
			lvc.pszText  = @FCaption
			lvc.cchTextMax = Len(FCaption)
		#endif
		If Parent Then
			PColumn->Parent = Parent
			#ifdef __USE_GTK__
				
			#elseif defined(__USE_WINAPI__)
				If Parent->Handle Then
					ListView_InsertColumn(Parent->Handle, PColumn->Index, @lvc)
				End If
			#endif
		End If
		Return PColumn
	End Function
	
	Private Sub ListViewColumns.Insert(Index As Integer, ByRef FCaption As WString = "", FImageIndex As Integer = -1, iWidth As Integer, Format As ColumnFormat = cfLeft)
		Dim As ListViewColumn Ptr PColumn
		#ifdef __USE_WINAPI__
			Dim As LVCOLUMN lvc
		#endif
		PColumn = _New( ListViewColumn)
		FColumns.Insert Index, PColumn
		With *PColumn
			.ImageIndex     = FImageIndex
			.Text        = FCaption
			.Index        = FColumns.Count - 1
			.Width     = iWidth
			.Format = Format
		End With
		#ifdef __USE_WINAPI__
			lvC.mask      =  LVCF_FMT Or LVCF_WIDTH Or LVCF_TEXT Or LVCF_SUBITEM
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
					ListView_SetColumnWidth(Parent->Handle, Index, ScaleX(iWidth))
				End If
			End If
		#endif
	End Sub
	
	Private Sub ListViewColumns.Remove(Index As Integer)
		FColumns.Remove Index
		#ifdef __USE_WINAPI__
			If Parent AndAlso Parent->Handle Then
				SendMessage Parent->Handle, LVM_DELETECOLUMN, Cast(WPARAM, Index), 0
			End If
		#endif
	End Sub
	
	Private Function ListViewColumns.IndexOf(ByRef FColumn As ListViewColumn Ptr) As Integer
		Return FColumns.IndexOf(FColumn)
	End Function
	
	Private Sub ListViewColumns.Clear
		For i As Integer = Count -1 To 0 Step -1
			_Delete( @QListViewColumn(FColumns.Items[i]))
			Remove i
		Next i
		FColumns.Clear
	End Sub
	
	Private Operator ListViewColumns.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor ListViewColumns
		This.Clear
	End Constructor
	
	Private Destructor ListViewColumns
		This.Clear
	End Destructor
	
	Private Sub ListView.Init()
		#ifdef __USE_GTK__
			If gtk_tree_view_get_model(GTK_TREE_VIEW(TreeViewWidget)) = NULL Then
				With This
					If .ColumnTypes Then _DeleteSquareBrackets( .ColumnTypes)
					.ColumnTypes = _New(GType[Columns.Count + 4])
					.ColumnTypes[0] = G_TYPE_BOOLEAN
					.ColumnTypes[1] = GDK_TYPE_PIXBUF
					.ColumnTypes[2] = G_TYPE_STRING
					For i As Integer = 3 To Columns.Count + 3
						.ColumnTypes[i] = G_TYPE_STRING
					Next i
				End With
				gtk_list_store_set_column_types(ListStore, Columns.Count + 3, ColumnTypes)
				gtk_tree_view_set_model(GTK_TREE_VIEW(TreeViewWidget), GTK_TREE_MODEL(ListStore))
				gtk_icon_view_set_model(GTK_ICON_VIEW(IconViewWidget), GTK_TREE_MODEL(ListStore))
				gtk_icon_view_set_pixbuf_column(GTK_ICON_VIEW(IconViewWidget), 1)
				If Columns.Count > 0 Then
					gtk_icon_view_set_text_column(GTK_ICON_VIEW(IconViewWidget), 3)
				End If
				gtk_tree_view_set_enable_tree_lines(GTK_TREE_VIEW(TreeViewWidget), True)
			End If
		#endif
	End Sub
	
	Private Sub ListView.EnsureVisible(Index As Integer)
		#ifdef __USE_GTK__
			If GTK_IS_ICON_VIEW(widget) Then
				gtk_icon_view_select_path(GTK_ICON_VIEW(widget), gtk_tree_path_new_from_string(Trim(Str(Index))))
			Else
				If TreeSelection Then
					If Index > -1 AndAlso Index < ListItems.Count Then
						Dim As GtkTreeIter iter
						gtk_tree_model_get_iter_from_string(GTK_TREE_MODEL(ListStore), @iter, Trim(Str(Index)))
						gtk_tree_view_scroll_to_cell(GTK_TREE_VIEW(widget), gtk_tree_model_get_path(GTK_TREE_MODEL(ListStore), @iter), NULL, False, 0, 0)
					End If
				End If
			End If
		#elseif defined(__USE_WINAPI__)
			ListView_EnsureVisible(FHandle, Index, True)
		#endif
	End Sub
	
	Private Property ListView.ColumnHeaderHidden As Boolean
		Return FColumnHeaderHidden
	End Property
	
	Private Property ListView.ColumnHeaderHidden(Value As Boolean)
		FColumnHeaderHidden = Value
		#ifdef __USE_GTK__
			gtk_tree_view_set_headers_visible(GTK_TREE_VIEW(TreeViewWidget), Not Value)
		#elseif defined(__USE_WINAPI__)
			ChangeStyle LVS_NOCOLUMNHEADER, Value
		#endif
	End Property
	
	Private Sub ListView.ChangeLVExStyle(iStyle As Integer, Value As Boolean)
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
	
	Private Property ListView.SingleClickActivate As Boolean
		Return FSingleClickActivate
	End Property
	
	Private Property ListView.SingleClickActivate(Value As Boolean)
		FSingleClickActivate = Value
		#ifdef __USE_GTK__
			#ifdef __USE_GTK3__
				gtk_tree_view_set_activate_on_single_click(GTK_TREE_VIEW(TreeViewWidget), Value)
				gtk_icon_view_set_activate_on_single_click(GTK_ICON_VIEW(IconViewWidget), Value)
			#else
				
			#endif
		#elseif defined(__USE_WINAPI__)
			ChangeLVExStyle LVS_EX_ONECLICKACTIVATE, Value
		#endif
	End Property
	
	Private Property ListView.HoverSelection As Boolean
		Return FHoverSelection
	End Property
	
	Private Property ListView.HoverSelection(Value As Boolean)
		FHoverSelection = Value
		#ifdef __USE_GTK__
			gtk_tree_view_set_hover_selection(GTK_TREE_VIEW(TreeViewWidget), Value)
		#elseif defined(__USE_WINAPI__)
			ChangeLVExStyle LVS_EX_TRACKSELECT, Value
		#endif
	End Property
	
	Private Property ListView.AllowColumnReorder As Boolean
		Return FAllowColumnReorder
	End Property
	
	Private Property ListView.AllowColumnReorder(Value As Boolean)
		FAllowColumnReorder = Value
		#ifdef __USE_GTK__
			For i As Integer = 0 To Columns.Count - 1
				gtk_tree_view_column_set_reorderable(Columns.Column(i)->Column, Value)
			Next
		#elseif defined(__USE_WINAPI__)
			ChangeLVExStyle LVS_EX_HEADERDRAGDROP, Value
		#endif
	End Property
	
	Private Property ListView.BorderSelect As Boolean
		Return FBorderSelect
	End Property
	
	Private Property ListView.BorderSelect(Value As Boolean)
		FBorderSelect = Value
		#ifdef __USE_WINAPI__
			ChangeLVExStyle LVS_EX_BORDERSELECT, Value
		#endif
	End Property
	
	Private Property ListView.GridLines As Boolean
		Return FGridLines
	End Property
	
	Private Property ListView.GridLines(Value As Boolean)
		FGridLines = Value
		#ifdef __USE_GTK__
			gtk_tree_view_set_grid_lines(GTK_TREE_VIEW(TreeViewWidget), IIf(Value, GTK_TREE_VIEW_GRID_LINES_BOTH, GTK_TREE_VIEW_GRID_LINES_NONE))
		#elseif defined(__USE_WINAPI__)
			ChangeLVExStyle LVS_EX_GRIDLINES, Value
		#endif
	End Property
	
	Private Property ListView.CheckBoxes As Boolean
		Return FCheckBoxes
	End Property
	
	Private Property ListView.CheckBoxes(Value As Boolean)
		FCheckBoxes = Value
		#ifdef __USE_WINAPI__
			ChangeLVExStyle LVS_EX_CHECKBOXES, Value
		#endif
	End Property
	
	Private Property ListView.FullRowSelect As Boolean
		Return FFullRowSelect
	End Property
	
	Private Property ListView.FullRowSelect(Value As Boolean)
		FFullRowSelect = Value
		#ifdef __USE_WINAPI__
			ChangeLVExStyle LVS_EX_FULLROWSELECT, Value
		#endif
	End Property
	
	Private Property ListView.LabelTip As Boolean
		Return FLabelTip
	End Property
	
	Private Property ListView.LabelTip(Value As Boolean)
		FLabelTip = Value
		#ifdef __USE_WINAPI__
			ChangeLVExStyle LVS_EX_LABELTIP, Value
		#endif
	End Property
	
	Private Property ListView.MultiSelect As Boolean
		Return FMultiSelect
	End Property
	
	Private Property ListView.MultiSelect(Value As Boolean)
		FMultiSelect = Value
		#ifdef __USE_WINAPI__
			ChangeStyle LVS_SINGLESEL, Not Value
		#endif
	End Property
	
	Private Property ListView.HoverTime As Integer
		Return FHoverTime
	End Property
	
	Private Property ListView.HoverTime(Value As Integer)
		FHoverTime = Value
		#ifdef __USE_WINAPI__
			If Handle Then Perform(LVM_SETHOVERTIME, 0, Value)
		#endif
	End Property
	
	Private Property ListView.View As ViewStyle
		#ifdef __USE_WINAPI__
			If Handle Then
				FView = ListView_GetView(Handle)
			End If
		#endif
		Return FView
	End Property
	
	Private Property ListView.View(Value As ViewStyle)
		FView = Value
		#ifdef __USE_GTK__
			If FView = ViewStyle.vsDetails Then
				If widget <> TreeViewWidget Then
					widget = TreeViewWidget
					gtk_widget_hide(IconViewWidget)
					If gtk_widget_get_parent(IconViewWidget) = scrolledwidget Then
						g_object_ref(IconViewWidget)
						gtk_container_remove(GTK_CONTAINER(scrolledwidget), IconViewWidget)
					End If
					gtk_container_add(GTK_CONTAINER(scrolledwidget), widget)
					gtk_tree_view_set_model(GTK_TREE_VIEW(widget), gtk_icon_view_get_model(GTK_ICON_VIEW(IconViewWidget)))
					gtk_widget_show(widget)
				End If
			Else
				If widget <> IconViewWidget Then
					widget = IconViewWidget
					gtk_widget_hide(TreeViewWidget)
					If gtk_widget_get_parent(TreeViewWidget) = scrolledwidget Then
						g_object_ref(TreeViewWidget)
						gtk_container_remove(gtk_container(scrolledwidget), TreeViewWidget)
					End If
					gtk_container_add(gtk_container(scrolledwidget), widget)
					gtk_icon_view_set_model(gtk_icon_view(widget), gtk_tree_view_get_model(gtk_tree_view(TreeViewWidget)))
					If scrolledwidget Then g_object_set_data(G_OBJECT(scrolledwidget), "@@@Control2", @This)
					If widget Then 
						g_object_set_data(G_OBJECT(widget), "@@@Control2", @This)
						g_object_set_data(G_OBJECT(widget), "@@@TreeView", TreeViewWidget)
						This.RegisterClass "ListView", @This
					End If
					gtk_widget_show(Widget)
				End If
				Select Case FView
				Case vsIcon: gtk_icon_view_set_item_orientation(GTK_ICON_VIEW(widget), GTK_ORIENTATION_VERTICAL): gtk_icon_view_set_columns(GTK_ICON_VIEW(widget), -1)
				Case vsSmallIcon: gtk_icon_view_set_item_orientation(GTK_ICON_VIEW(widget), GTK_ORIENTATION_HORIZONTAL): gtk_icon_view_set_columns(GTK_ICON_VIEW(widget), -1)
				Case vsList, vsTile, vsMax: gtk_icon_view_set_item_orientation(GTK_ICON_VIEW(widget), GTK_ORIENTATION_HORIZONTAL): gtk_icon_view_set_columns(GTK_ICON_VIEW(widget), 1)
				End Select
			End If
		#elseif defined(__USE_WINAPI__)
			If Handle Then Perform LVM_SETVIEW, Cast(WPARAM, Cast(DWORD, Value)), 0
		#endif
	End Property
	
	Private Property ListView.SelectedItem As ListViewItem Ptr
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			If GTK_IS_ICON_VIEW(widget) Then
				Dim As GList Ptr list = gtk_icon_view_get_selected_items(GTK_ICON_VIEW(widget))
				Dim As GtkTreePath Ptr path
				Dim i As Integer
				If (list) Then
					path = list->data
					i = gtk_tree_path_get_indices(path)[0]
				End If
				g_list_free_full(list, Cast(GDestroyNotify, @gtk_tree_path_free))
				Return ListItems.Item(i)
			Else
				If gtk_tree_selection_get_selected(TreeSelection, NULL, @iter) Then
					Return ListItems.FindByIterUser_Data(iter.user_data)
				End If
			End If
		#elseif defined(__USE_WINAPI__)
			If Handle Then
				Dim As Integer item = ListView_GetNextItem(Handle, -1, LVNI_SELECTED)
				If item <> -1 Then Return ListItems.Item(item)
			End If
		#endif
		Return 0
	End Property
	
	Private Property ListView.SelectedItemIndex As Integer
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			If GTK_IS_ICON_VIEW(widget) Then
				Dim As GList Ptr list = gtk_icon_view_get_selected_items(GTK_ICON_VIEW(widget))
				Dim As GtkTreePath Ptr path
				Dim i As Integer
				If (list) Then
					path = list->data
					i = gtk_tree_path_get_indices(path)[0]
				End If
				g_list_free_full(list, Cast(GDestroyNotify, @gtk_tree_path_free))
				Return i
			ElseIf GTK_IS_TREE_SELECTION(TreeSelection) Then
				If gtk_tree_selection_get_selected(TreeSelection, NULL, @iter) Then
					Dim As Integer i
					Dim As GtkTreePath Ptr path
					
					path = gtk_tree_model_get_path(GTK_TREE_MODEL(ListStore), @iter)
					i = gtk_tree_path_get_indices(path)[0]
					gtk_tree_path_free(path)
					'				Dim As ListViewItem Ptr lvi = ListItems.FindByIterUser_Data(iter.User_Data)
					'				If lvi <> 0 Then Return lvi->Index
					Return i
				End If
			End If
		#elseif defined(__USE_WINAPI__)
			If Handle Then
				Return ListView_GetNextItem(Handle, -1, LVNI_SELECTED)
			End If
		#endif
		Return -1
	End Property
	
	Private Property ListView.SelectedItemIndex(Value As Integer)
		#ifdef __USE_GTK__
			If GTK_IS_ICON_VIEW(widget) Then
				gtk_icon_view_select_path(GTK_ICON_VIEW(widget), gtk_tree_path_new_from_string(Trim(Str(Value))))
			Else
				If TreeSelection Then
					If Value = -1 Then
						gtk_tree_selection_unselect_all(TreeSelection)
					ElseIf Value > -1 AndAlso Value < ListItems.Count Then
						Dim As GtkTreeIter iter
						gtk_tree_model_get_iter_from_string(GTK_TREE_MODEL(ListStore), @iter, Trim(Str(Value)))
						gtk_tree_selection_select_iter(TreeSelection, @iter)
						gtk_tree_view_scroll_to_cell(GTK_TREE_VIEW(widget), gtk_tree_model_get_path(GTK_TREE_MODEL(ListStore), @iter), NULL, False, 0, 0)
					End If
				End If
			End If
		#elseif defined(__USE_WINAPI__)
			If Handle Then
				ListView_SetItemState(Handle, Value, LVIS_FOCUSED Or LVIS_SELECTED, LVNI_SELECTED Or LVNI_FOCUSED)
				ListView_EnsureVisible(Handle, Value, True)
			End If
		#endif
	End Property
	
	Private Property ListView.SelectedItem(Value As ListViewItem Ptr)
		Value->SelectItem
	End Property
	
	Private Property ListView.SelectedColumn As ListViewColumn Ptr
		#ifdef __USE_WINAPI__
			If Handle Then
				Return Columns.Column(ListView_GetSelectedColumn(Handle))
			End If
		#endif
		Return 0
	End Property
	
	Private Property ListView.Sort As SortStyle
		Return FSortStyle
	End Property
	
	Private Property ListView.Sort(Value As SortStyle)
		FSortStyle = Value
		#ifdef __USE_WINAPI__
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
	
	Private Property ListView.SelectedColumn(Value As ListViewColumn Ptr)
		#ifdef __USE_WINAPI__
			If Handle Then ListView_SetSelectedColumn(Handle, Value->Index)
		#endif
	End Property
	
	Private Property ListView.ShowHint As Boolean
		Return FShowHint
	End Property
	
	Private Property ListView.ShowHint(Value As Boolean)
		FShowHint = Value
	End Property
	
	Private Sub ListView.WndProc(ByRef Message As Message)
	End Sub
	
	#ifdef __USE_WINAPI__
		Private Sub ListView.SetDark(Value As Boolean)
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
	
	Private Sub ListView.ProcessMessage(ByRef Message As Message)
		'?message.msg, GetMessageName(message.msg)
		#ifdef __USE_GTK__
			Dim As GdkEvent Ptr e = Message.Event
			Select Case Message.Event->type
			Case GDK_MAP
				Init
			Case GDK_BUTTON_RELEASE
				If SelectedItemIndex <> -1 Then
					If OnItemClick Then OnItemClick(*Designer, This, SelectedItemIndex)
				End If
			#ifdef __USE_GTK3__
			Case GDK_2BUTTON_PRESS, GDK_DOUBLE_BUTTON_PRESS
			#else
			Case GDK_2BUTTON_PRESS
			#endif
				If SelectedItemIndex <> -1 Then
					If OnItemDblClick Then OnItemDblClick(*Designer, This, SelectedItemIndex)
				End If
			Case GDK_KEY_PRESS
				If SelectedItemIndex <> -1 Then
					If OnItemKeyDown Then OnItemKeyDown(*Designer, This, SelectedItemIndex, Message.Event->key.keyval, Message.Event->key.state)
				End If
			End Select
		#elseif defined(__USE_WINAPI__)
			Select Case Message.Msg
			Case WM_PAINT
				If g_darkModeSupported AndAlso g_darkModeEnabled Then
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
			Case WM_DESTROY
				If Images Then ListView_SetImageList(FHandle, 0, LVSIL_NORMAL)
				If StateImages Then ListView_SetImageList(FHandle, 0, LVSIL_STATE)
				If SmallImages Then ListView_SetImageList(FHandle, 0, LVSIL_SMALL)
				If GroupHeaderImages Then ListView_SetImageList(FHandle, 0, LVSIL_GROUPHEADER)
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
			Case CM_NOTIFY
				Dim lvp As NMLISTVIEW Ptr = Cast(NMLISTVIEW Ptr, Message.lParam)
				Select Case lvp->hdr.code
				Case NM_CLICK: If OnItemClick Then OnItemClick(*Designer, This, lvp->iItem)
				Case NM_DBLCLK: If OnItemDblClick Then OnItemDblClick(*Designer, This, lvp->iItem)
				Case NM_KEYDOWN: 
					Dim As LPNMKEY lpnmk = Cast(LPNMKEY, Message.lParam)
					If OnItemKeyDown Then OnItemKeyDown(*Designer, This, lvp->iItem, lpnmk->nVKey, lpnmk->uFlags And &HFFFF)
				Case NM_CUSTOMDRAW
					If (g_darkModeSupported AndAlso g_darkModeEnabled AndAlso CBool(FView = ViewStyle.vsDetails) AndAlso FGridLines) Then
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
								Heights += FItemHeight
								MoveToEx nmcd->hdc, 0, Heights, 0
								LineTo nmcd->hdc, ScaleX(This.Width), Heights
							Next i
							SelectObject(nmcd->hdc, PrevPen)
							DeleteObject GridLinesPen
							Message.Result = CDRF_DODEFAULT
							Return
						End Select
					End If
				Case LVN_ITEMACTIVATE: If OnItemActivate Then OnItemActivate(*Designer, This, lvp->iItem)
				Case LVN_BEGINSCROLL: If OnBeginScroll Then OnBeginScroll(*Designer, This)
				Case LVN_ENDSCROLL: If OnEndScroll Then OnEndScroll(*Designer, This)
				Case LVN_ITEMCHANGING: 
					Dim bCancel As Boolean
					If OnSelectedItemChanging Then OnSelectedItemChanging(*Designer, This, lvp->iItem, bCancel)
					If bCancel Then Message.Result = -1: Exit Sub 
				Case LVN_ITEMCHANGED: If OnSelectedItemChanged Then OnSelectedItemChanged(*Designer, This, lvp->iItem)
				Case HDN_ITEMCHANGED:
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
	
	#ifdef __USE_WINAPI__
		Private Sub ListView.HandleIsDestroyed(ByRef Sender As Control)
		End Sub
		
		Private Sub ListView.HandleIsAllocated(ByRef Sender As Control)
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
					lvStyle = lvStyle Or .FLVExStyle
					SendMessage(.FHandle, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, ByVal lvStyle)
					If .HoverTime Then .HoverTime = .FHoverTime
					.View = .FView
					Var TempHandle = .FHandle
					For i As Integer = 0 To .Columns.Count -1
						Dim lvc As LVCOLUMN
						lvc.mask            = LVCF_FMT Or LVCF_WIDTH Or LVCF_TEXT Or LVCF_SUBITEM
						lvc.fmt             = .Columns.Column(i)->Format
						lvc.cx              = 0
						lvc.pszText         = @.Columns.Column(i)->Text
						lvc.cchTextMax      = Len(.Columns.Column(i)->Text)
						lvc.iImage          = .Columns.Column(i)->ImageIndex
						lvc.iSubItem        = i
						.FHandle            = 0
						lvc.cx              = ScaleX(.Columns.Column(i)->Width)
						.FHandle            = TempHandle
						ListView_InsertColumn(.FHandle, i, @lvc)
					Next i
					For i As Integer = 0 To .ListItems.Count - 1
						For j As Integer = 0 To .Columns.Count - 1
							.FHandle = 0
							Dim lvi As LVITEM
							lvi.pszText         = @.ListItems.Item(i)->Text(j)
							lvi.cchTextMax      = Len(.ListItems.Item(i)->Text(j))
							lvi.iItem           = i
							lvi.iSubItem        = j
							If j = 0 Then
								lvi.mask = LVIF_TEXT Or LVIF_IMAGE Or LVIF_STATE Or LVIF_INDENT Or LVIF_PARAM
								lvi.iImage          = .ListItems.Item(i)->ImageIndex
								lvi.State   = INDEXTOSTATEIMAGEMASK(.ListItems.Item(i)->State)
								lvi.stateMask = LVIS_STATEIMAGEMASK
								lvi.iIndent   = .ListItems.Item(i)->Indent
								lvi.lParam   =  Cast(LPARAM, .ListItems.Item(i))
								.FHandle = TempHandle
								ListView_InsertItem(.FHandle, @lvi)
								.FHandle = 0
								If .ListItems.Item(i)->Checked Then
									.FHandle = TempHandle
									Dim lvi As LVITEM
									lvi.mask = LVIF_STATE
									lvi.iItem = i
									lvi.stateMask = LVIS_CHECKEDMASK
									lvi.state = LVIS_CHECKED
									ListView_SetItem(.FHandle, @lvi)
								End If
								.FHandle = TempHandle
							Else
								.FHandle = TempHandle
								lvi.mask = LVIF_TEXT
								ListView_SetItem(.FHandle, @lvi)
							End If
						Next j
					Next i
					.SelectedItemIndex = 0
				End With
			End If
		End Sub
	#endif
	
	Private Operator ListView.Cast As Control Ptr
		Return @This
	End Operator
	
	#ifdef __USE_GTK__
		Private Sub ListView.ListView_RowActivated(tree_view As GtkTreeView Ptr, path As GtkTreePath Ptr, column As GtkTreeViewColumn Ptr, user_data As Any Ptr)
			Dim As ListView Ptr lv = Cast(Any Ptr, user_data)
			If lv Then
				Dim As GtkTreeModel Ptr model
				Dim As GtkTreeIter iter
				model = gtk_tree_view_get_model(tree_view)
				If gtk_tree_model_get_iter(model, @iter, path) Then
					If lv->OnItemActivate Then lv->OnItemActivate(*lv->Designer, *lv, Val(*gtk_tree_model_get_string_from_iter(model, @iter)))
				End If
			End If
		End Sub
		
		Private Sub ListView.ListView_ItemActivated(icon_view As GtkIconView Ptr, path As GtkTreePath Ptr, user_data As Any Ptr)
			Dim As ListView Ptr lv = Cast(Any Ptr, user_data)
			If lv Then
				Dim As GtkTreeModel Ptr model
				Dim As GtkTreeIter iter
				model = gtk_icon_view_get_model(icon_view)
				If gtk_tree_model_get_iter(model, @iter, path) Then
					If lv->OnItemActivate Then lv->OnItemActivate(*lv->Designer, *lv, Val(*gtk_tree_model_get_string_from_iter(model, @iter)))
				End If
			End If
		End Sub
		
		Private Sub ListView.ListView_SelectionChanged(selection As GtkTreeSelection Ptr, user_data As Any Ptr)
			Dim As ListView Ptr lv = Cast(Any Ptr, user_data)
			If lv Then
				Dim As GtkTreeIter iter
				Dim As GtkTreeModel Ptr model
				If gtk_tree_selection_get_selected(selection, @model, @iter) Then
					Dim As Integer SelectedIndex = Val(*gtk_tree_model_get_string_from_iter(model, @iter))
					If lv->PrevIndex <> SelectedIndex AndAlso lv->PrevIndex <> -1 Then
						Dim bCancel As Boolean
						If lv->OnSelectedItemChanging Then lv->OnSelectedItemChanging(*lv->Designer, *lv, lv->PrevIndex, bCancel)
						If bCancel Then
							lv->SelectedItemIndex = lv->PrevIndex
							Exit Sub
						End If
					End If
					If lv->OnSelectedItemChanged Then lv->OnSelectedItemChanged(*lv->Designer, *lv, SelectedIndex)
					lv->PrevIndex = SelectedIndex
				End If
			End If
		End Sub
		
		Private Sub ListView.IconView_SelectionChanged(iconview As GtkIconView Ptr, user_data As Any Ptr)
			Dim As ListView Ptr lv = Cast(Any Ptr, user_data)
			If lv Then
				Dim As GtkTreeIter iter
				Dim As GList Ptr list = gtk_icon_view_get_selected_items(iconview)
				Dim As GtkTreePath Ptr path
				Dim SelectedIndex As Integer
				If (list) Then
					path = list->data
					SelectedIndex = gtk_tree_path_get_indices(path)[0]
				End If
				g_list_free_full(list, Cast(GDestroyNotify, @gtk_tree_path_free))
				If lv->PrevIndex <> SelectedIndex AndAlso lv->PrevIndex <> -1 Then
					Dim bCancel As Boolean
					If lv->OnSelectedItemChanging Then lv->OnSelectedItemChanging(*lv->Designer, *lv, lv->PrevIndex, bCancel)
					If bCancel Then
						lv->SelectedItemIndex = lv->PrevIndex
						Exit Sub
					End If
				End If
				If lv->OnSelectedItemChanged Then lv->OnSelectedItemChanged(*lv->Designer, *lv, SelectedIndex)
				lv->PrevIndex = SelectedIndex
			End If
		End Sub
		
		Private Sub ListView.ListView_Map(widget As GtkWidget Ptr, user_data As Any Ptr)
			Dim As ListView Ptr lv = user_data
			lv->Init
		End Sub
		
		Private Function ListView.ListView_Scroll(self As GtkAdjustment Ptr, user_data As Any Ptr) As Boolean
			Dim As ListView Ptr lv = user_data
			If lv->OnEndScroll Then lv->OnEndScroll(*lv->Designer, *lv)
			Return True
		End Function
	#endif
	
	Private Constructor ListView
		#ifdef __USE_GTK__
			ListStore = gtk_list_store_new(3, G_TYPE_BOOLEAN, GDK_TYPE_PIXBUF, G_TYPE_STRING)
			scrolledwidget = gtk_scrolled_window_new(NULL, NULL)
			gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolledwidget), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
			'widget = gtk_tree_view_new_with_model(gtk_tree_model(ListStore))
			TreeViewWidget = gtk_tree_view_new()
			IconViewWidget = gtk_icon_view_new()
			widget = TreeViewWidget
			gtk_container_add(GTK_CONTAINER(scrolledwidget), widget)
			TreeSelection = gtk_tree_view_get_selection(GTK_TREE_VIEW(widget))
			#ifdef __USE_GTK3__
				g_signal_connect(gtk_scrollable_get_hadjustment(GTK_SCROLLABLE(widget)), "value-changed", G_CALLBACK(@ListView_Scroll), @This)
				g_signal_connect(gtk_scrollable_get_vadjustment(GTK_SCROLLABLE(widget)), "value-changed", G_CALLBACK(@ListView_Scroll), @This)
			#else
				g_signal_connect(gtk_tree_view_get_hadjustment(GTK_TREE_VIEW(widget)), "value-changed", G_CALLBACK(@ListView_Scroll), @This)
				g_signal_connect(gtk_tree_view_get_vadjustment(GTK_TREE_VIEW(widget)), "value-changed", G_CALLBACK(@ListView_Scroll), @This)
			#endif
			g_signal_connect(GTK_TREE_VIEW(widget), "map", G_CALLBACK(@ListView_Map), @This)
			g_signal_connect(GTK_TREE_VIEW(widget), "row-activated", G_CALLBACK(@ListView_RowActivated), @This)
			g_signal_connect(GTK_ICON_VIEW(IconViewWidget), "item-activated", G_CALLBACK(@ListView_ItemActivated), @This)
			g_signal_connect(GTK_ICON_VIEW(IconViewWidget), "selection-changed", G_CALLBACK(@IconView_SelectionChanged), @This)
			g_signal_connect(G_OBJECT(TreeSelection), "changed", G_CALLBACK (@ListView_SelectionChanged), @This)
			gtk_tree_view_set_enable_tree_lines(GTK_TREE_VIEW(widget), True)
			gtk_tree_view_set_grid_lines(GTK_TREE_VIEW(widget), GTK_TREE_VIEW_GRID_LINES_BOTH)
			ColumnTypes = _New( GType[3])
			ColumnTypes[0] = G_TYPE_BOOLEAN
			ColumnTypes[1] = GDK_TYPE_PIXBUF
			ColumnTypes[2] = G_TYPE_STRING
			This.RegisterClass "ListView", @This
		#endif
		BorderStyle = BorderStyles.bsClient
		ListItems.Parent = @This
		Columns.Parent = @This
		FView = vsDetails
		DoubleBuffered = True
		FEnabled = True
		FGridLines = True
		FFullRowSelect = True
		FVisible = True
		FTabIndex          = -1
		FTabStop = True
		With This
			.Child             = @This
			#ifdef __USE_WINAPI__
				.OnHandleIsAllocated = @HandleIsAllocated
				.OnHandleIsDestroyed = @HandleIsDestroyed
				.RegisterClass "ListView", WC_LISTVIEW
				.ChildProc         = @WndProc
				.ExStyle           = WS_EX_CLIENTEDGE
				.FLVExStyle        = LVS_EX_FULLROWSELECT Or LVS_EX_GridLINES Or LVS_EX_DOUBLEBUFFER
				.Style             = WS_CHILD Or WS_TABSTOP Or WS_VISIBLE Or LVS_REPORT Or LVS_ICON Or LVS_SINGLESEL Or LVS_SHOWSELALWAYS
				WLet(FClassAncestor, WC_LISTVIEW)
			#elseif defined(__USE_JNI__)
				WLet(FClassAncestor, "android/widget/ListView")
			#endif
			WLet(FClassName, "ListView")
			.Width             = 121
			.Height            = 121
		End With
	End Constructor
	
	Private Destructor ListView
		#if defined(__USE_GTK__) AndAlso defined(__FB_WIN32__)
		#else
			ListItems.Clear
		#endif
		#ifdef __USE_WINAPI__
			UnregisterClass "ListView",GetModuleHandle(NULL)
		#elseif defined(__USE_GTK__)
			If ColumnTypes Then _DeleteSquareBrackets( ColumnTypes)
			#ifndef __FB_WIN32__
				If GTK_IS_WIDGET(TreeViewWidget) AndAlso TreeViewWidget <> widget Then 
					#ifdef __USE_GTK4__
						g_object_unref(widget)
					#else
						gtk_widget_destroy(TreeViewWidget)
					#endif
				End If
				If GTK_IS_WIDGET(IconViewWidget) AndAlso IconViewWidget <> widget Then 
					#ifdef __USE_GTK4__
						g_object_unref(widget)
					#else
						gtk_widget_destroy(IconViewWidget)
					#endif
				End If
			#endif
		#endif
	End Destructor
End Namespace
