'###############################################################################
'#  ComboBoxEx.bi                                                              #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'#  Version 1.0.0                                                              #
'###############################################################################

#include once "ComboBoxEx.bi"

Namespace My.Sys.Forms
	Function ComboBoxItem.Index As Integer
		If Parent Then
			Return Cast(ComboBoxEx Ptr, Parent)->Items.IndexOf(@This)
		Else
			Return -1
		End If
	End Function
	
	Property ComboBoxItem.Text ByRef As WString
		'        If Parent AndAlso Parent->Handle Then
		'            WReallocate FText, 255
		'            Dim cbei As COMBOBOXEXITEM
		'            cbei.mask = CBEIF_TEXT
		'            cbei.iItem = Index
		'                cbei.pszText    = FText
		'                cbei.cchTextMax = 255
		'              Parent->Perform CBEM_GETITEM, 0, CInt(@cbei)
		'          End If
		Return WGet(FText)
	End Property
	
	Property ComboBoxItem.Text(ByRef Value As WString)
		WLet(FText, Value)
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				gtk_list_store_set (Cast(ComboBoxEx Ptr, Parent)->ListStore, @TreeIter, 1, ToUTF8(Value), -1)
			End If
		#else
			If Parent AndAlso Parent->Handle Then
				Dim cbei As COMBOBOXEXITEM
				cbei.Mask = CBEIF_TEXT
				cbei.iItem = Index
				cbei.pszText    = FText
				cbei.cchTextMax = Len(*FText)
				SendMessage Parent->Handle, CBEM_SETITEM, 0, CInt(@cbei)
			End If
		#endif
	End Property
	
	Property ComboBoxItem.Object As Any Ptr
		Return FObject
	End Property
	
	Property ComboBoxItem.Object(Value As Any Ptr)
		FObject = Value
	End Property
	
	Property ComboBoxItem.Hint ByRef As WString
		Return WGet(FHint)
	End Property
	
	Property ComboBoxItem.Hint(ByRef Value As WString)
		WLet(FHint, Value)
	End Property
	
	
	Property ComboBoxItem.ImageIndex As Integer
		Return FImageIndex
	End Property
	
	Property ComboBoxItem.ImageIndex(Value As Integer)
		If Value <> FImageIndex Then
			FImageIndex = Value
			#ifndef __USE_GTK__
				If Parent AndAlso Parent->Handle Then
					Dim cbei As COMBOBOXEXITEM
					cbei.Mask = CBEIF_IMAGE
					cbei.iItem = Index
					cbei.iImage = FImageIndex
					SendMessage Parent->Handle, CBEM_SETITEM, 0, CInt(@cbei)
				End If
			#endif
		End If
	End Property
	
	Property ComboBoxItem.ImageKey ByRef As WString
		Return WGet(FImageKey)
	End Property
	
	Property ComboBoxItem.ImageKey(ByRef Value As WString)
		WLet(FImageKey, Value)
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				gtk_list_store_set (Cast(ComboBoxEx Ptr, Parent)->ListStore, @TreeIter, 0, ToUTF8(Value), -1)
			End If
		#endif
	End Property
	
	Property ComboBoxItem.SelectedImageIndex As Integer
		Return FImageIndex
	End Property
	
	Property ComboBoxItem.SelectedImageIndex(Value As Integer)
		If Value <> FSelectedImageIndex Then
			FSelectedImageIndex = Value
			#ifndef __USE_GTK__
				If Parent AndAlso Parent->Handle Then
					Dim cbei As COMBOBOXEXITEM
					cbei.Mask = CBEIF_SELECTEDIMAGE
					cbei.iItem = Index
					cbei.iSelectedImage = FSelectedImageIndex
					SendMessage Parent->Handle, CBEM_SETITEM, 0, CInt(@cbei)
				End If
			#endif
		End If
	End Property
	
	Property ComboBoxItem.OverlayIndex As Integer
		Return FImageIndex
	End Property
	
	Property ComboBoxItem.OverlayIndex(Value As Integer)
		If Value <> FOverlayIndex Then
			FOverlayIndex = Value
			#ifndef __USE_GTK__
				If Parent AndAlso Parent->Handle Then
					Dim cbei As COMBOBOXEXITEM
					cbei.Mask = CBEIF_OVERLAY
					cbei.iItem = Index
					cbei.iOverlay = FOverlayIndex
					SendMessage Parent->Handle, CBEM_SETITEM, 0, CInt(@cbei)
				End If
			#endif
		End If
	End Property
	
	Property ComboBoxItem.Indent As Integer
		Return FIndent
	End Property
	
	Property ComboBoxItem.Indent(Value As Integer)
		If Value <> FIndent Then
			FIndent = Value
			#ifndef __USE_GTK__
				If Parent AndAlso Parent->Handle Then
					Dim cbei As COMBOBOXEXITEM
					cbei.Mask = CBEIF_INDENT
					cbei.iItem = Index
					cbei.iIndent = FIndent
					SendMessage Parent->Handle, CBEM_SETITEM, 0, CInt(@cbei)
				End If
			#endif
		End If
	End Property
	
	Operator ComboBoxItem.Cast As Any Ptr
		Return @This
	End Operator
	
	Constructor ComboBoxItem
		FHint = 0 'CAllocate_(0)
		FText = 0 'CAllocate_(0)
		Text    = ""
		Hint       = ""
		FImageIndex = -1
		FSelectedImageIndex = -1
		FOverlayIndex = -1
	End Constructor
	
	Destructor ComboBoxItem
		If FHint Then Deallocate_( FHint)
		If FText Then Deallocate_( FText)
		If FImageKey Then Deallocate_( FImageKey)
	End Destructor
	
	Property ComboBoxExItems.Count As Integer
		Return FItems.Count
	End Property
	
	Property ComboBoxExItems.Count(Value As Integer)
	End Property
	
	Property ComboBoxExItems.Item(Index As Integer) As ComboBoxItem Ptr
		If Index <= FItems.Count Then Return QComboBoxItem(FItems.Items[Index]) Else Return 0
	End Property
	
	Property ComboBoxExItems.Item(Index As Integer, Value As ComboBoxItem Ptr)
		'QToolButton(FItems.Items[Index]) = Value
	End Property
	
	Function ComboBoxExItems.Add(ByRef FText As WString = "", Obj As Any Ptr = 0, FImageIndex As Integer = -1, FSelectedImageIndex As Integer = -1, FOverlayIndex As Integer = -1, FIndent As Integer = 0, Index As Integer = -1) As ComboBoxItem Ptr
		PItem = New_( ComboBoxItem)
		Dim i As Integer
		If Cast(ComboBoxEx Ptr, Parent)->Sort Then
			For i = 0 To FItems.Count - 1
				If Item(i)->Text > FText Then Exit For
			Next
			FItems.Insert i, PItem
		Else
			If Index = -1 Then
				FItems.Add PItem
			Else
				FItems.Insert Index, PItem
			End If
		End If
		With *PItem
			.ImageIndex         = FImageIndex
			.SelectedImageIndex = FSelectedImageIndex
			.OverlayIndex       = FOverlayIndex
			.Indent     		= FIndent
			.Text        		= FText
			.Object        		= Obj
		End With
		#ifdef __USE_GTK__
			If Cast(ComboBoxEx Ptr, Parent)->Sort Then
				gtk_list_store_insert(Cast(ComboBoxEx Ptr, Parent)->ListStore, @PItem->TreeIter, i)
			Else
				#ifdef __USE_GTK3__
					gtk_list_store_insert(Cast(ComboBoxEx Ptr, Parent)->ListStore, @PItem->TreeIter, Index)
				#else
					gtk_list_store_insert(Cast(ComboBoxEx Ptr, Parent)->ListStore, @PItem->TreeIter, IIf(Index = -1, FItems.Count, Index))
				#endif
			End If
			gtk_list_store_set (Cast(ComboBoxEx Ptr, Parent)->ListStore, @PItem->TreeIter, 1, ToUtf8(FText), -1)
			'gtk_widget_show_all(Parent->widget)
		#else
			cbei.Mask = CBEIF_IMAGE Or CBEIF_INDENT Or CBEIF_OVERLAY Or CBEIF_SELECTEDIMAGE Or CBEIF_TEXT
			cbei.pszText  = @FText
			cbei.cchTextMax = Len(FText)
			cbei.iItem = IIf(Index = -1, FItems.Count - 1, Index)
			cbei.iImage   = FImageIndex
			cbei.iSelectedImage   = FSelectedImageIndex
			cbei.iOverlay   = FOverlayIndex
			cbei.iIndent   = FIndent
		#endif
		If Parent Then
			PItem->Parent = Parent
			#ifndef __USE_GTK__
				SendMessage Parent->Handle, CBEM_INSERTITEM, 0, CInt(@cbei)
			#endif
		End If
		Return PItem
	End Function
	
	Function ComboBoxExItems.Add(ByRef FText As WString = "", Obj As Any Ptr = 0, ByRef ImageKey As WString, ByRef SelectedImageKey As WString = "", ByRef OverlayKey As WString = "", Indent As Integer = 0, Index As Integer = -1) As ComboBoxItem Ptr
		Dim Value As ComboBoxItem Ptr
		If Parent AndAlso Cast(ComboBoxEx Ptr, Parent)->ImagesList Then
			With *Cast(ComboBoxEx Ptr, Parent)->ImagesList
				Value = Add(FText, Obj, .IndexOf(ImageKey), .IndexOf(SelectedImageKey), .IndexOf(OverlayKey), Indent, Index)
				Value->ImageKey = ImageKey
			End With
		Else
			Value = Add(FText, Obj, -1, -1, -1, Indent, Index)
		End If
		Return Value
	End Function
	
	Sub ComboBoxExItems.Remove(Index As Integer)
		If Index = -1 Then Exit Sub
		If Parent Then
			#ifdef __USE_GTK__
				gtk_list_store_remove(Cast(ComboBoxEx Ptr, Parent)->ListStore, @This.Item(Index)->TreeIter)
			#else
				SendMessage Parent->Handle, CBEM_DELETEITEM, Index, 0
			#endif
		End If
		Delete_( Cast(ComboBoxItem Ptr, FItems.Items[Index]))
		FItems.Remove Index
	End Sub
	
	Function ComboBoxExItems.IndexOf(ByRef FItem As ComboBoxItem Ptr) As Integer
		Return FItems.IndexOf(FItem)
	End Function
	
	Function ComboBoxExItems.IndexOf(ByRef Text As WString) As Integer
		For i As Integer = 0 To FItems.Count - 1
			If *Cast(ComboBoxItem Ptr, FItems.Items[i]).Text = Text Then Return i
		Next i
		Return -1
	End Function
	
	Function ComboBoxExItems.Contains(ByRef Text As WString) As Boolean
		Return IndexOf(Text) <> -1
	End Function
	
	Sub ComboBoxExItems.Clear
		#ifdef __USE_GTK__
			If Parent Then gtk_list_store_clear(Cast(ComboBoxEx Ptr, Parent)->ListStore)
		#else
			If Parent Then SendMessage Parent->Handle, CB_RESETCONTENT, 0, 0
		#endif
		For i As Integer = Count -1 To 0 Step -1
			Delete_( Cast(ComboBoxItem Ptr, FItems.Items[i]))
		Next i
		FItems.Clear
	End Sub
	
	Operator ComboBoxExItems.Cast As Any Ptr
		Return @This
	End Operator
	
	Constructor ComboBoxExItems
		This.Clear
	End Constructor
	
	Destructor ComboBoxExItems
		This.Clear
	End Destructor
	
	Function ComboBoxEx.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "imageslist": Return ImagesList
		Case "integralheight": Return @FIntegralHeight
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function ComboBoxEx.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "designmode": DesignMode = QBoolean(Value): If FDesignMode Then This.Items.Add *FName: This.ItemIndex = 0
		Case "imageslist": ImagesList = Value
		Case "integralheight": IntegralHeight = QBoolean(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	'    Property ComboBoxEx.ItemIndex As Integer
	'        Return FItemIndex
	'    End Property
	'
	'    Property ComboBoxEx.ItemIndex(Value As Integer)
	'        FItemIndex = Value
	'        If Handle Then Perform(CB_SETCURSEL, FItemIndex, 0)
	'    End Property
	
	Property ComboBoxEx.Text ByRef As WString
		If This.FStyle >= cbDropDownList Then
			FText = This.Items.Item(This.ItemIndex)->Text
		Else
			#ifdef __USE_GTK__
				FText = WStr(*gtk_combo_box_text_get_active_text(gtk_combo_box_text(widget)))
			#else
				Base.Text
			#endif
		End If
		Return *FText.vptr
	End Property
	
	Property ComboBoxEx.Text(ByRef Value As WString)
		Base.Text = Value
		#ifdef __USE_GTK__
			If widget Then gtk_combo_box_set_active (Gtk_Combo_Box(widget), This.IndexOf(Value))
		#else
			If FHandle Then Perform(CB_SELECTSTRING, -1, CInt(FText.vptr))
		#endif
	End Property
	
	Property ComboBoxEx.IntegralHeight As Boolean
		Return FIntegralHeight
	End Property
	
	Property ComboBoxEx.IntegralHeight(Value As Boolean)
		FIntegralHeight = Value
		#ifndef __USE_GTK__
			ChangeStyle CBS_NOINTEGRALHEIGHT, Not Value
		#endif
	End Property
	
	#ifndef __USE_GTK__
		Sub ComboBoxEx.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QComboBoxEx(Sender.Child)
					If .Style <> cbOwnerDrawVariable AndAlso .ItemHeight <> 0 Then
						.Perform(CB_SETITEMHEIGHT, 0, ScaleY(.ItemHeight))
					End If
					.UpdateListHeight
					If .ImagesList Then
						.ImagesList->ParentWindow = @Sender
						.Perform CBEM_SETIMAGELIST, 0, CInt(.ImagesList->Handle)
					End If
					Dim As Integer i
					For i = 0 To .Items.Count - 1
						Dim As COMBOBOXEXITEM cbei
						cbei.Mask = CBEIF_TEXT Or CBEIF_IMAGE Or CBEIF_INDENT Or CBEIF_OVERLAY Or CBEIF_SELECTEDIMAGE
						cbei.pszText  = @.Items.Item(i)->Text
						cbei.cchTextMax = Len(.Items.Item(i)->Text)
						cbei.iItem = -1
						cbei.iImage   = .Items.Item(i)->ImageIndex
						cbei.iSelectedImage   = .Items.Item(i)->SelectedImageIndex
						cbei.iOverlay   = .Items.Item(i)->OverlayIndex
						cbei.iIndent   = .Items.Item(i)->Indent
						.Perform(CBEM_INSERTITEM, 0, CInt(@cbei))
					Next i
					.ItemIndex = .FItemIndex
					.Text = .FText
				End With
			End If
		End Sub
	#endif
	
	#ifndef __USE_GTK__
		Sub ComboBoxEx.WndProc(ByRef Message As Message)
			'        If Message.Sender Then
			'            If Cast(TControl Ptr,Message.Sender)->Child Then
			'                Cast(ComboBoxEx Ptr,Cast(TControl Ptr,Message.Sender)->Child)->ProcessMessage(Message)
			'            End If
			'        End If
		End Sub
	#endif
	
	Sub ComboBoxEx.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Dim pt As Point, rc As RECT, t As Long, itd As Long
			Select Case Message.Msg
				Case WM_DRAWITEM
				Dim lpdis As DRAWITEMSTRUCT Ptr, zTxt As WString * 64
				Dim As Integer ItemID, State
				lpdis = Cast(DRAWITEMSTRUCT Ptr, Message.lParam)
				If OnDrawItem Then
					OnDrawItem(This, lpdis->itemID, lpdis->itemState, lpdis->rcItem, lpdis->hDC)
				Else
					If lpdis->itemID = &HFFFFFFFF& Then
						Exit Sub
					EndIf
					Select Case lpdis->itemAction
					Case ODA_DRAWENTIRE, ODA_SELECT
						'DRAW BACKGROUND
						If (lpdis->itemState And ODS_COMBOBOXEDIT) Then
						Else
							FillRect lpdis->hDC, @lpdis->rcItem, GetSysColorBrush(COLOR_WINDOW)
						End If
						If (lpdis->itemState And ODS_SELECTED)   Then                       'if selected Then
							If (lpdis->itemState And ODS_COMBOBOXEDIT) Then
								SetBKMode lpdis->hDC, TRANSPARENT
								SetTextColor lpdis->hDC, GetSysColor(COLOR_WINDOWTEXT)                'Set text color
								DrawFocusRect lpdis->hDC, @lpdis->rcItem  'draw focus rectangle
							Else
								FillRect lpdis->hDC, @lpdis->rcItem, GetSysColorBrush(COLOR_HIGHLIGHT)
								SetBkColor lpdis->hDC, GetSysColor(COLOR_HIGHLIGHT)                    'Set text Background
								SetTextColor lpdis->hDC, GetSysColor(COLOR_HIGHLIGHTTEXT)                'Set text color
								If ItemIndex = lpdis->itemID AndAlso Focused Then
									DrawFocusRect lpdis->hDC, @lpdis->rcItem  'draw focus rectangle
								End If
							End If
						Else
							If (lpdis->itemState And ODS_COMBOBOXEDIT) Then
								SetBKMode lpdis->hDC, TRANSPARENT
							Else
								FillRect lpdis->hDC, @lpdis->rcItem, GetSysColorBrush(COLOR_WINDOW)
								SetBkColor lpdis->hDC, GetSysColor(COLOR_WINDOW)                    'Set text Background
							End If
							SetTextColor lpdis->hDC, GetSysColor(COLOR_WINDOWTEXT)                'Set text color
							If CInt(ItemIndex = -1) AndAlso CInt(lpdis->itemID = 0) AndAlso CInt(Focused) Then
								rc.Left   = lpdis->rcItem.Left + 16 : rc.Right = lpdis->rcItem.Right              '  Set cordinates
								rc.top    = lpdis->rcItem.top
								rc.bottom = lpdis->rcItem.bottom
								DrawFocusRect lpdis->hDC, @rc  'draw focus rectangle
							End If
						End If
						'DRAW TEXT
						'SendMessage message.hWnd, CB_GETLBTEXT, lpdis->itemID, Cast(LPARAM, @zTxt)                  'Get text
						If lpdis->itemID >= 0 AndAlso lpdis->itemID < Items.Count Then
							zTxt = Items.Item(lpdis->itemID)->Text
							TextOut lpdis->hDC, lpdis->rcItem.Left + 18 + 3 + IIf(lpdis->itemState And ODS_COMBOBOXEDIT, 0, Items.Item(lpdis->itemID)->Indent * 11), lpdis->rcItem.top + 1, @zTxt, Len(zTxt)     'Draw text
							'DRAW IMAGE
							rc.Left   = lpdis->rcItem.Left + 2 : rc.Right = lpdis->rcItem.Left + 15               'Set cordinates
							rc.top    = lpdis->rcItem.top + 1
							rc.bottom = lpdis->rcItem.bottom - 1
							If ImagesList AndAlso ImagesList->Handle Then
								ImageList_Draw(ImagesList->Handle, Items.Item(lpdis->itemID)->ImageIndex, lpdis->hDC, rc.Left + IIf(lpdis->itemState And ODS_COMBOBOXEDIT, 0, Items.Item(lpdis->itemID)->Indent * 11), rc.Top, ILD_TRANSPARENT)
							End If
						End If
						Message.Result = True : Exit Sub
					Case ODA_FOCUS
						DrawFocusRect lpdis->hDC, @lpdis->rcItem  'draw focus rectangle
						Message.Result = True : Exit Sub
					End Select
				End If
			Case CM_COMMAND
				'            Select Case Message.wParamHi
				'            Case CBN_DROPDOWN
				'                If IntegralHeight = False Then
				'                    If Items.Count Then
				'                      SetWindowPos(Handle, 0, 0, 0, FWidth, ItemHeight * DropDownCount + Height + 2 , SWP_NOMOVE OR SWP_NOZORDER OR SWP_NOACTIVATE OR SWP_NOREDRAW OR SWP_HIDEWINDOW)
				'                    Else
				'                      SetWindowPos(Handle, 0, 0, 0, FWidth, ItemHeight + Height + 2 , SWP_NOMOVE OR SWP_NOZORDER OR SWP_NOACTIVATE OR SWP_NOREDRAW OR SWP_HIDEWINDOW)
				'                    End If
				'                    SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_NOMOVE OR SWP_NOSIZE OR SWP_NOZORDER OR SWP_NOACTIVATE OR SWP_NOREDRAW OR SWP_SHOWWINDOW)
				'               End If
				'            End Select
			End Select
		#endif
		Base.ProcessMessage(message)
	End Sub
	
	Operator ComboBoxEx.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Constructor ComboBoxEx
		#ifdef __USE_GTK__
			ListStore = gtk_list_store_new(2, G_TYPE_STRING, G_TYPE_STRING)
			widget = gtk_combo_box_new_with_model(GTK_TREE_MODEL(ListStore))
			g_signal_connect(widget, "changed", G_CALLBACK(@ComboBoxEdit.ComboBoxEdit_Changed), @This)
			Dim As GtkCellRenderer Ptr renderer
			/' icon cell '/
			renderer = gtk_cell_renderer_pixbuf_new()
			gtk_cell_layout_pack_start( GTK_CELL_LAYOUT(widget), renderer, False)
			gtk_cell_layout_set_attributes( GTK_CELL_LAYOUT(widget), renderer, ToUtf8("icon-name"), 0, NULL)
			/' text cell '/
			renderer = gtk_cell_renderer_text_new()
			gtk_cell_layout_pack_start( GTK_CELL_LAYOUT(widget), renderer, True)
			gtk_cell_layout_set_attributes( GTK_CELL_LAYOUT(widget), renderer, ToUtf8("text"), 1, NULL)
			eventboxwidget = gtk_event_box_new()
			gtk_container_add(gtk_container(eventboxwidget), widget)
			Base.Base.RegisterClass "ComboBoxEx", @This
		#else
			Dim As INITCOMMONCONTROLSEX icex
			
			icex.dwSize = SizeOf(INITCOMMONCONTROLSEX)
			icex.dwICC = ICC_USEREX_CLASSES
			
			InitCommonControlsEx(@icex)
		#endif
		Items.Parent       = @This
		FIntegralHeight    = False
		FTabStop           = True
		Base.FStyle             = cbOwnerDrawFixed
		ItemHeight         = 13
		FDropDownCount     = 8
		With This
			.Child       = @This
			#ifndef __USE_GTK__
				Base.Base.RegisterClass "ComboBoxEx", "ComboBoxEx32"
				.ChildProc   = @WndProc
				Base.Base.Style       = WS_CHILD Or CBS_DROPDOWNLIST Or CBS_OWNERDRAWFIXED Or WS_VSCROLL
				.OnHandleIsAllocated = @HandleIsAllocated
				.BackColor       = GetSysColor(COLOR_WINDOW)
			#endif
			WLet(FClassName, "ComboBoxEx")
			WLet(FClassAncestor, "ComboBoxEx32")
			.Width       = 121
			.Height      = 121
		End With
	End Constructor
	
	Destructor ComboBoxEx
		Items.Clear
		#ifndef __USE_GTK__
			UnregisterClass "ComboBoxEx", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
