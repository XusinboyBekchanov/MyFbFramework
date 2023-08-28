'###############################################################################
'#  ComboBoxEdit.bi                                                            #
'#  This file is part of MyFBFramework                                         #
'#  Based on:                                                                  #
'#   TComboBox.bi                                                              #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "ComboBoxEdit.bi"

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function ComboBoxEdit.ReadProperty(PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "dropdowncount": Return @FDropDownCount
			Case "integralheight": Return @FIntegralHeight
			Case "itemheight": Return @FItemHeight
			Case "selcolor": Return @FSelColor
			Case "sort": Return @FSort
			Case "style": Return @FStyle
			Case "tabindex": Return @FTabIndex
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function ComboBoxEdit.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "designmode": DesignMode = QBoolean(Value): If FDesignMode Then This.AddItem *FName: This.ItemIndex = 0
			Case "dropdowncount": DropDownCount = QInteger(Value)
			Case "integralheight": This.IntegralHeight = QBoolean(Value)
			Case "itemheight": This.ItemHeight = QInteger(Value)
			Case "selcolor": This.SelColor = QInteger(Value)
			Case "sort": This.Sort = QBoolean(Value)
			Case "style": This.Style = *Cast(ComboBoxEditStyle Ptr, Value)
			Case "tabindex": TabIndex = QInteger(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	
	Private Sub ComboBoxEdit.Undo
		#ifdef __USE_WINAPI__
			If FEditHandle Then SendMessage(FEditHandle, WM_UNDO, 0, 0)
		#endif
	End Sub
	
	Private Sub ComboBoxEdit.PasteFromClipboard
		#ifdef __USE_GTK__
			If GTK_IS_EDITABLE(gtk_bin_get_child(GTK_BIN(widget))) Then
				gtk_editable_paste_clipboard(GTK_EDITABLE(gtk_bin_get_child(GTK_BIN(widget))))
			End If
		#elseif defined(__USE_WINAPI__)
			If FEditHandle Then SendMessage(FEditHandle, WM_PASTE, 0, 0)
		#endif
	End Sub
	
	Private Sub ComboBoxEdit.CopyToClipboard
		#ifdef __USE_GTK__
			If GTK_IS_EDITABLE(gtk_bin_get_child(GTK_BIN(widget))) Then
				gtk_editable_copy_clipboard(GTK_EDITABLE(gtk_bin_get_child(GTK_BIN(widget))))
			End If
		#elseif defined(__USE_WINAPI__)
			If FEditHandle Then SendMessage(FEditHandle, WM_COPY, 0, 0)
		#endif
	End Sub
	
	Private Sub ComboBoxEdit.CutToClipboard
		#ifdef __USE_GTK__
			If GTK_IS_EDITABLE(gtk_bin_get_child(GTK_BIN(widget))) Then
				gtk_editable_cut_clipboard(GTK_EDITABLE(gtk_bin_get_child(GTK_BIN(widget))))
			End If
		#elseif defined(__USE_WINAPI__)
			If FEditHandle Then SendMessage(FEditHandle, WM_CUT, 0, 0)
		#endif
	End Sub
	
	Private Sub ComboBoxEdit.SelectAll
		#ifdef __USE_GTK__
			If GTK_IS_EDITABLE(gtk_bin_get_child(GTK_BIN(widget))) Then
				gtk_editable_select_region(GTK_EDITABLE(gtk_bin_get_child(GTK_BIN(widget))), 0, -1)
			End If
		#elseif defined(__USE_WINAPI__)
			If FEditHandle Then SendMessage(FEditHandle, EM_SETSEL, 0, -1)
		#endif
	End Sub
	
	Private Property ComboBoxEdit.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property ComboBoxEdit.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property ComboBoxEdit.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property ComboBoxEdit.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Sub ComboBoxEdit.ShowDropDown(Value As Boolean)
		#ifdef __USE_GTK__
			gtk_combo_box_popup(GTK_COMBO_BOX(widget))
		#else
			Perform CB_SHOWDROPDOWN, Value, 0
		#endif
	End Sub
	
	#ifndef __USE_GTK__
		Private Function ComboBoxEdit.WindowProc(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			Select Case Msg
			Case WM_NCCREATE
				'Dim As CreateStruct Ptr CS = Cast(CreateStruct Ptr, lparam)
				'Dim As ComboBoxEdit Ptr CE = New ComboBoxEdit
				'CS->Style = CE->Style
				'CS->dwExStyle = CE->ExStyle
				'lParam = CS
			Case WM_CREATE
				'Dim As CreateStruct Ptr CS = Cast(CreateStruct Ptr, lparam)
				'Dim As ComboBoxEdit Ptr CE = New ComboBoxEdit
				'CS->Style = CE->Style
				'CS->dwExStyle = CE->ExStyle
				'lParam = CS
			End Select
			Return Control.SuperWndProc(FWindow, Msg, wParam, lParam)
		End Function
	#endif
	
	Private Sub ComboBoxEdit.RegisterClass
		#ifndef __USE_GTK__
			Control.RegisterClass "ComboBoxEdit", "ComboBox", @WindowProc
		#endif
	End Sub
	
	Private Property ComboBoxEdit.SelColor As Integer
		Return FSelColor
	End Property
	
	Private Property ComboBoxEdit.SelColor(Value As Integer)
		FSelColor = Value
		Invalidate
	End Property
	
	Private Property ComboBoxEdit.Style As ComboBoxEditStyle
		Return FStyle
	End Property
	
	Private Property ComboBoxEdit.Style(Value As ComboBoxEditStyle)
		If Value <> FStyle Then
			FStyle = Value
			#ifdef __USE_GTK__
				Dim As GtkWidget Ptr Ctrlwidget = IIf(FStyle <= 1, DropDownWidget, DropDownListWidget)
				If widget = Ctrlwidget Then Exit Property
				If Ctrlwidget = DropDownWidget Then
					widget = DropDownWidget
					#ifdef __USE_GTK4__
						gtk_widget_set_visible(DropDownListWidget, False)
					#else
						gtk_widget_hide(DropDownListWidget)
					#endif
					If gtk_widget_get_parent(DropDownListWidget) = eventboxwidget Then
						g_object_ref(DropDownListWidget)
						gtk_container_remove(GTK_CONTAINER(eventboxwidget), DropDownListWidget)
					End If
					gtk_container_add(GTK_CONTAINER(eventboxwidget), widget)
					If widget Then 
						g_object_set_data(G_OBJECT(widget), "@@@Control2", @This)
						g_object_set_data(G_OBJECT(gtk_bin_get_child(GTK_BIN(DropDownWidget))), "@@@Control2", @This)
					End If
					Dim As GtkTreeIter Iter
					If gtk_tree_model_get_iter_first(gtk_combo_box_get_model(GTK_COMBO_BOX(widget)), @Iter) = False Then
						This.Clear
						This.AddItem *FName: This.ItemIndex = 0
					End If
					#ifdef __USE_GTK4__
						gtk_widget_set_visible(widget, True)
					#else
						gtk_widget_show(widget)
					#endif
				Else
					widget = DropDownListWidget
					#ifdef __USE_GTK4__
						gtk_widget_set_visible(DropDownWidget, False)
					#else
						gtk_widget_hide(DropDownWidget)
					#endif
					If gtk_widget_get_parent(DropDownWidget) = eventboxwidget Then
						g_object_ref(DropDownWidget)
						gtk_container_remove(GTK_CONTAINER(eventboxwidget), DropDownWidget)
					End If
					gtk_container_add(GTK_CONTAINER(eventboxwidget), widget)
					#ifdef __USE_GTK4__
						gtk_widget_set_visible(widget, True)
					#else
						gtk_widget_show(widget)
					#endif
				End If
			#else
				Base.Style = WS_CHILD Or WS_VSCROLL Or CBS_HASSTRINGS Or CBS_AUTOHSCROLL Or AStyle(abs_(FStyle)) Or ASortStyle(abs_(FSort)) Or AIntegralHeight(abs_(FIntegralHeight))
			#endif
		End If
	End Property
	
	Private Property ComboBoxEdit.DropDownCount As Integer
		Return FDropDownCount
	End Property
	
	Private Property ComboBoxEdit.DropDownCount(Value As Integer)
		FDropDownCount = Value
	End Property
	
	Private Property ComboBoxEdit.IntegralHeight As Boolean
		Return FIntegralHeight
	End Property
	
	Private Property ComboBoxEdit.IntegralHeight(Value As Boolean)
		FIntegralHeight = Value
		#ifndef __USE_GTK__
			Base.Style = WS_CHILD Or WS_VSCROLL Or CBS_HASSTRINGS Or CBS_AUTOHSCROLL Or AStyle(abs_(FStyle)) Or ASortStyle(abs_(FSort)) Or AIntegralHeight(abs_(FIntegralHeight))
		#endif
	End Property
	
	Private Property ComboBoxEdit.ItemCount As Integer
		#ifndef __USE_GTK__
			If Handle Then
				Return Perform(CB_GETCOUNT,0,0)
			End If
		#endif
		Return Items.Count
	End Property
	
	Private Property ComboBoxEdit.ItemCount(Value As Integer)
	End Property
	
	Private Property ComboBoxEdit.ItemHeight As Integer
		#ifndef __USE_GTK__
			If Handle Then
				If Style <> cbOwnerDrawVariable  Then
					FItemHeight = UnScaleY(Perform(CB_GETITEMHEIGHT, 0, 0))
				End If
			End If
		#endif
		Return FItemHeight
	End Property
	
	Private Property ComboBoxEdit.ItemHeight(Value As Integer)
		FItemHeight = Value
		#ifndef __USE_GTK__
			If Handle Then
				If Style <> cbOwnerDrawVariable  Then
					Perform(CB_SETITEMHEIGHT, 0, ScaleY(FItemHeight))
				End If
			End If
		#endif
	End Property
	
	Private Property ComboBoxEdit.ItemIndex As Integer
		#ifdef __USE_GTK__
			If widget Then FItemIndex = gtk_combo_box_get_active (GTK_COMBO_BOX(widget))
		#else
			If Handle Then FItemIndex = Perform(CB_GETCURSEL, 0, 0)
		#endif
		Return FItemIndex
	End Property
	
	Private Property ComboBoxEdit.ItemIndex(Value As Integer)
		FItemIndex = Value
		#ifdef __USE_GTK__
			If widget Then gtk_combo_box_set_active (GTK_COMBO_BOX(widget), Value)
		#else
			If Handle Then Perform(CB_SETCURSEL, FItemIndex, 0)
			If OnChange Then OnChange(*Designer, This)
		#endif
	End Property
	
	Private Property ComboBoxEdit.Text ByRef As WString
		If FStyle >= cbDropDownList Then
			If This.ItemIndex > -1 Then
				FText = This.Item(This.ItemIndex)
			Else
				FText = ""
			End If
		Else
			#ifdef __USE_GTK__
				FText = WStr(*gtk_combo_box_text_get_active_text(GTK_COMBO_BOX_TEXT(widget)))
			#else
				Base.Text
			#endif
		End If
		Return *FText.vptr
	End Property
	
	Private Property ComboBoxEdit.Text(ByRef Value As WString)
		Base.Text = Value
		#ifdef __USE_GTK__
			If widget Then gtk_combo_box_set_active (GTK_COMBO_BOX(widget), IndexOf(Value))
		#else
			If FStyle > 1 Then
				If FHandle Then Perform(CB_SELECTSTRING, -1, CInt(FText.vptr))
			Else
				If FHandle Then Perform(WM_SETTEXT, -1, CInt(FText.vptr))
			End If
		#endif
	End Property
	
	Private Property ComboBoxEdit.Sort As Boolean
		Return FSort
	End Property
	
	Private Property ComboBoxEdit.Sort(Value As Boolean)
		If Value <> FSort Then
			FSort = Value
			#ifdef __USE_GTK__
				
			#else
				ChangeStyle CBS_SORT, Value
				'Base.Style = WS_CHILD OR WS_VSCROLL OR CBS_HASSTRINGS OR CBS_AUTOHSCROLL OR AStyle(Abs_(FStyle)) OR ASortStyle(Abs_(FSort)) OR AIntegralHeight(Abs_(FIntegralHeight))
			#endif
		End If
	End Property
	
	Private Property ComboBoxEdit.ItemData(FIndex As Integer) As Any Ptr
		Return Items.Object(FIndex)
	End Property
	
	Private Property ComboBoxEdit.ItemData(FIndex As Integer, Value As Any Ptr)
		Items.Object(FIndex) = Value
	End Property
	
	Private Property ComboBoxEdit.Item(FIndex As Integer) ByRef As WString
		Dim As Integer L
		#ifndef __USE_GTK__
			If Handle Then
				L = Perform(CB_GETLBTEXTLEN, FIndex, 0)
				WReAllocate(FItemText, L)
				Perform(CB_GETLBTEXT, FIndex, CInt(FItemText))
				Return *FItemText
			Else
				WLet(FItemText, Items.Item(FIndex))
				Return *FItemText
			End If
		#else
			WLet(FItemText, Items.Item(FIndex))
			Return *FItemText
		#endif
	End Property
	
	Private Property ComboBoxEdit.Item(FIndex As Integer, ByRef FItem As WString)
		'Items.Item(FIndex) = FItem  'not refresh
		RemoveItem(FIndex)
		InsertItem(FIndex, FItem)
	End Property
	
	Private Sub ComboBoxEdit.UpdateListHeight
		If Style <> cbSimple Then
			#ifndef __USE_GTK__
				Dim As ..Rect R
				GetWindowRect Handle, @R
				MapWindowPoints 0, GetParent(Handle), Cast(Point Ptr, @R), 2
				MoveWindow Handle, R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top + ScaleY(ItemHeight * FDropDownCount), 1
			#endif
		End If
	End Sub
	
	Private Sub ComboBoxEdit.AddItem(ByRef FItem As WString)
		Dim i As Integer
		If FSort Then
			For i = 0 To Items.Count - 1
				If Items.Item(i) > FItem Then Exit For
			Next
			Items.Insert i, FItem
		Else
			Items.Add(FItem)
		End If
		#ifdef __USE_GTK__
			If widget Then
				If FSort Then
					gtk_combo_box_text_insert_text(GTK_COMBO_BOX_TEXT(widget), i, ToUtf8(FItem))
				Else
					gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(widget), ToUtf8(FItem))
				End If
			End If
		#else
			If FHandle Then
				Perform(CB_ADDSTRING, 0, CInt(@FItem))
				UpdateListHeight
			End If
		#endif
	End Sub
	
	Private Sub ComboBoxEdit.RemoveItem(FIndex As Integer)
		Items.Remove(FIndex)
		#ifdef __USE_GTK__
			If widget Then
				gtk_combo_box_text_remove(GTK_COMBO_BOX_TEXT(widget), FIndex)
			End If
		#else
			If FHandle Then
				Perform(CB_DELETESTRING, FIndex, 0)
				UpdateListHeight
			End If
		#endif
	End Sub
	
	Private Sub ComboBoxEdit.InsertItem(FIndex As Integer, ByRef FItem As WString)
		If FSort Then
			AddItem FItem
			Exit Sub
		End If
		Items.Insert(FIndex, FItem)
		#ifdef __USE_GTK__
			gtk_combo_box_text_insert_text(GTK_COMBO_BOX_TEXT(widget), FIndex, ToUtf8(FItem))
		#else
			If FHandle Then
				Perform(CB_INSERTSTRING, FIndex, CInt(@FItem))
				UpdateListHeight
			End If
		#endif
	End Sub
	
	Private Function ComboBoxEdit.IndexOf(ByRef FItem As WString) As Integer
		Return Items.IndexOf(FItem) ' Perform(CB_FINDSTRING, -1, CInt(@FItem))
	End Function
	
	Private Function ComboBoxEdit.Contains(ByRef FItem As WString) As Boolean
		Return IndexOf(FItem) <> -1
	End Function
	
	Private Function ComboBoxEdit.IndexOfData(pData As Any Ptr) As Integer
		Return Items.IndexOfObject(pData)
	End Function
	
	#ifndef __USE_GTK__
		Private Function ComboBoxEdit.SubClassProc(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			Dim As ComboBoxEdit Ptr Ctrl
			Dim As Message Message
			Ctrl = Cast(ComboBoxEdit Ptr, GetWindowLongPtr(FWindow, GWLP_USERDATA))
			Message = Type(Ctrl, FWindow, Msg, wParam, lParam, 0, LoWord(wParam), HiWord(wParam), LoWord(lParam), HiWord(lParam), Message.Captured)
			If Ctrl Then
				With *Ctrl
					If Ctrl->ClassName <> "" Then
						.ProcessMessage(Message)
						If Message.Result = -1 Then
							Return Message.Result
						ElseIf Message.Result = -2 Then
							Msg = Message.Msg
							wParam = Message.wParam
							lParam = Message.lParam
						ElseIf Message.Result <> 0 Then
							Return Message.Result
						End If
					End If
				End With
				Message.Result = CallWindowProc(Ctrl->lpfnEditWndProc, FWindow, Msg, wParam, lParam)
			End If
			Return Message.Result
		End Function
		
		Private Sub ComboBoxEdit.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QComboBoxEdit(Sender.Child)
					.GetChilds
					If .Style <> cbOwnerDrawVariable AndAlso .FItemHeight <> 0 Then
						.Perform(CB_SETITEMHEIGHT, 0, ScaleY(.FItemHeight))
					End If
					.UpdateListHeight
					Dim As Integer i
					For i = 0 To .Items.Count - 1
'						Dim As WString Ptr s = CAllocate_((Len(.Items.Item(i)) + 1) * SizeOf(WString))
'						*s = .Items.Item(i)
						.Perform(CB_ADDSTRING, 0, CInt(@.Items.Item(i)))
					Next i
					.ItemIndex = .FItemIndex
					.Text = .FText
					If .FEditHandle <> 0 Then
						SetWindowLongPtr(.FEditHandle, GWLP_USERDATA, CInt(.Child))
						.lpfnEditWndProc = Cast(Any Ptr, SetWindowLongPtr(.FEditHandle, GWLP_WNDPROC, CInt(@SUBCLASSPROC)))
					End If
				End With
			End If
		End Sub
	#endif
	
	Private Sub ComboBoxEdit.GetChilds
		#ifndef __USE_GTK__
			Dim As HWND Child
			FEditHandle = 0
			FListHandle = 0
			If Style = cbDropDown Or Style = cbSimple Then
				Child = GetWindow(Handle, GW_CHILD)
				If Child <> 0 Then
					If Style = cbSimple Then
						FListHandle = Child
						Child = GetWindow(Child, GW_HWNDNEXT)
					End If
					FEditHandle = Child
				End If
			End If
		#endif
	End Sub
	
	#ifdef __USE_WINAPI__
		Private Sub ComboBoxEdit.SetDark(Value As Boolean)
			Base.SetDark Value
			If Value Then
				SetWindowTheme(FHandle, "DarkMode_CFD", nullptr)
				Brush.Handle = hbrBkgnd
				SendMessageW(FHandle, WM_THEMECHANGED, 0, 0)
				Dim As COMBOBOXINFO cbi
				cbi.cbSize = SizeOf(COMBOBOXINFO)
				Dim As BOOL result = GetComboBoxInfo(FHandle, @cbi)
				If result Then
					If cbi.hwndList Then
						'dark scrollbar for listbox of combobox
						SetWindowTheme(cbi.hwndList, "DarkMode_Explorer", nullptr)
					End If
				End If
			Else
				SetWindowTheme(FHandle, NULL, NULL)
				If FBackColor = -1 Then
					Brush.Handle = 0
				Else
					Brush.Color = FBackColor
				End If
				SendMessageW(FHandle, WM_THEMECHANGED, 0, 0)
				Dim As COMBOBOXINFO cbi
				cbi.cbSize = SizeOf(COMBOBOXINFO)
				Dim As BOOL result = GetComboBoxInfo(FHandle, @cbi)
				If result Then
					If cbi.hwndList Then
						'dark scrollbar for listbox of combobox
						SetWindowTheme(cbi.hwndList, NULL, NULL)
					End If
				End If
			End If
			'SendMessage FHandle, WM_THEMECHANGED, 0, 0
		End Sub
	#endif
	
	Private Sub ComboBoxEdit.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Select Case Message.Msg
			Case WM_NCCREATE
				
			Case WM_CREATE
				
			Case WM_PAINT
				If g_darkModeSupported AndAlso g_darkModeEnabled Then
					If Not FDarkMode Then
						SetDark True
'						FDarkMode = True
'						SetWindowTheme(FHandle, "DarkMode_CFD", nullptr)
'						Brush.Handle = hbrBkgnd
'						SendMessageW(FHandle, WM_THEMECHANGED, 0, 0)
'						Dim As COMBOBOXINFO cbi
'						cbi.cbSize = SizeOf(COMBOBOXINFO)
'						Dim As BOOL result = GetComboBoxInfo(FHandle, @cbi)
'						If result Then
'							If cbi.hwndList Then
'								'dark scrollbar for listbox of combobox
'								SetWindowTheme(cbi.hwndList, "DarkMode_Explorer", nullptr)
'							End If
'						End If
					End If
				Else
					If FDarkMode Then
						SetDark False
'						FDarkMode = False
'						SetWindowTheme(FHandle, NULL, NULL)
'						If FBackColor = -1 Then
'							Brush.Handle = 0
'						Else
'							Brush.Color = FBackColor
'						End If
'						SendMessageW(FHandle, WM_THEMECHANGED, 0, 0)
'						Dim As COMBOBOXINFO cbi
'						cbi.cbSize = SizeOf(COMBOBOXINFO)
'						Dim As BOOL result = GetComboBoxInfo(FHandle, @cbi)
'						If result Then
'							If cbi.hwndList Then
'								'dark scrollbar for listbox of combobox
'								SetWindowTheme(cbi.hwndList, NULL, NULL)
'							End If
'						End If
					End If
				End If
				Message.Result = 0
			Case CM_CTLCOLOR
				Dim As HDC Dc
				Dc = Cast(HDC, Message.wParam)
				SetBkMode Dc, TRANSPARENT
				SetTextColor Dc, Font.Color
				SetBkColor Dc, This.BackColor
				SetBkMode Dc, OPAQUE
			Case CM_CANCELMODE
				If Message.Sender <> This Then Perform(CB_SHOWDROPDOWN, 0, 0)
			Case CM_COMMAND
				Select Case Message.wParamHi
				Case CBN_SELCHANGE
					If OnChange Then OnChange(*Designer, This)
				Case CBN_SELENDOK
					If OnSelected Then OnSelected(*Designer, This, ItemIndex)
				Case CBN_SELENDCANCEL
					If OnSelectCanceled Then OnSelectCanceled(*Designer, This)
				Case CBN_EDITCHANGE
					If OnChange Then OnChange(*Designer, This)
				Case CBN_EDITUPDATE
				Case CBN_CLOSEUP
					If OnCloseUp Then OnCloseUp(*Designer, This)
				Case CBN_DROPDOWN
					If IntegralHeight = False Then
						If Items.Count Then
							SetWindowPos(Handle, 0, 0, 0, ScaleX(FWidth), ScaleY(ItemHeight * DropDownCount + Height + 2), SWP_NOMOVE Or SWP_NOZORDER Or SWP_NOACTIVATE Or SWP_NOREDRAW Or SWP_HIDEWINDOW)
						Else
							SetWindowPos(Handle, 0, 0, 0, ScaleX(FWidth), ScaleY(ItemHeight + Height + 2) , SWP_NOMOVE Or SWP_NOZORDER Or SWP_NOACTIVATE Or SWP_NOREDRAW Or SWP_HIDEWINDOW)
						End If
						SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE Or SWP_NOZORDER Or SWP_NOACTIVATE Or SWP_NOREDRAW Or SWP_SHOWWINDOW)
					End If
					If OnDropDown Then OnDropDown(*Designer, This)
				Case CBN_DBLCLK
					If OnDblClick Then OnDblClick(*Designer, This)
				End Select
			Case CM_MEASUREITEM
				Dim As MEASUREITEMSTRUCT Ptr miStruct
				Dim As Integer ItemID
				miStruct = Cast(MEASUREITEMSTRUCT Ptr,Message.lParam)
				ItemID = Cast(Integer,miStruct->itemID)
				If OnMeasureItem Then
					OnMeasureItem(*Designer, This, ItemID, miStruct->itemHeight)
				Else
					miStruct->itemHeight = ItemHeight
				End If
			Case CM_DRAWITEM
				Dim As DRAWITEMSTRUCT Ptr diStruct
				Dim As Integer ItemID,State
				Dim As ..Rect R
				Dim As HDC Dc
				diStruct = Cast(DRAWITEMSTRUCT Ptr,Message.lParam)
				ItemID = Cast(Integer, diStruct->itemID)
				State = Cast(Integer, diStruct->itemState)
				R = Cast(..Rect, diStruct->rcItem)
				Dc = diStruct->hDC
				If (diStruct->itemState And ODS_COMBOBOXEDIT) <> 0 Then State = State Or ODS_COMBOBOXEDIT
				If (diStruct->itemState And ODS_DEFAULT) <> 0 Then State = State Or ODS_DEFAULT
				If OnDrawItem Then
					OnDrawItem(*Designer, This, ItemID, State, *Cast(Rect Ptr, @R), Dc)
				Else
					If (State And ODS_SELECTED) = ODS_SELECTED Then
						Static As HBRUSH B
						If B Then DeleteObject B
						B = CreateSolidBrush(FSelColor)
						FillRect Dc, @R, B
						SetTextColor Dc, clHighlightText
						SetBkColor Dc, FSelColor
						TextOut(Dc,R.Left + 2, R.Top, Item(ItemID),Len(Item(ItemID)))
						If (State And ODS_FOCUS) = ODS_FOCUS Then DrawFocusRect(Dc, @R)
					Else
						FillRect Dc, @R, Brush.Handle
						SetTextColor Dc, Font.Color
						SetBkColor Dc, This.BackColor
						TextOut(Dc, R.Left + 2, R.Top, Item(ItemID), Len(Item(ItemID)))
					End If
				End If
			Case WM_CHAR
				If OnKeyPress Then OnKeyPress(*Designer, This, LoByte(Message.wParam), Message.wParam And &HFFFF)
			Case WM_KEYDOWN
				If OnKeyDown Then OnKeyDown(*Designer, This, Message.wParam, Message.wParam And &HFFFF)
			Case WM_KEYUP
				If Message.wParam = VK_RETURN Then
					If OnActivate Then OnActivate(*Designer, This)
				End If
				If OnKeyUp Then OnKeyUp(*Designer, This, Message.wParam, Message.wParam And &HFFFF)
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Sub ComboBoxEdit.Clear
		ItemCount = 0
		Items.Clear
		#ifdef __USE_GTK__
			#ifdef __USE_GTK3__
				gtk_combo_box_text_remove_all(GTK_COMBO_BOX_TEXT(widget))
			#else
				Dim As GtkListStore Ptr store
				store = GTK_LIST_STORE (gtk_combo_box_get_model (GTK_COMBO_BOX (widget)))
				gtk_list_store_clear (store)
			#endif
		#else
			Perform(CB_RESETCONTENT, 0, 0)
		#endif
	End Sub
	
	Private Sub ComboBoxEdit.SaveToFile(ByRef File As WString)
		Dim As Integer F, i
		Dim As WString Ptr s
		F = FreeFile_
		Open File For Output Encoding "utf-8" As #F
		For i = 0 To ItemCount -1
			#ifndef __USE_GTK__
				Dim TextLen As Integer = Perform(CB_GETLBTEXTLEN, i, 0)
				s = _CAllocate((TextLen + 1) * SizeOf(WString))
				*s = WSpace(TextLen)
				Perform(CB_GETLBTEXT, i, CInt(s))
				Print #F, *s
			#endif
		Next i
		CloseFile_(F)
		_Deallocate(s)
	End Sub
	
	Private Sub ComboBoxEdit.LoadFromFile(ByRef FileName As WString)
		Dim As Integer F, i
		Dim As WString * 1024 s
		F = FreeFile_
		This.Clear
		Open FileName For Input Encoding "utf-8" As #F
		While Not EOF(F)
			Line Input #F, s
			This.AddItem s
		Wend
		CloseFile_(F)
	End Sub
	
	Private Operator ComboBoxEdit.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Private Sub ComboBoxEdit.ComboBoxEdit_Popup(widget As GtkComboBox Ptr, user_data As Any Ptr)
			Dim As ComboBoxEdit Ptr cbo = user_data
			cbo->FSelected = False
			If cbo->OnDropDown Then cbo->OnDropDown(*cbo->Designer, *cbo)
		End Sub
		
		Private Function ComboBoxEdit.ComboBoxEdit_Popdown(widget As GtkComboBox Ptr, user_data As Any Ptr) As Boolean
			Dim As ComboBoxEdit Ptr cbo = user_data
			If cbo->FSelected = False Then
				If cbo->OnSelectCanceled Then cbo->OnSelectCanceled(*cbo->Designer, *cbo)
			End If
			If cbo->OnCloseUp Then cbo->OnCloseUp(*cbo->Designer, *cbo)
			Return False
		End Function
		
		Private Sub ComboBoxEdit.ComboBoxEdit_Changed(widget As GtkComboBox Ptr, user_data As Any Ptr)
			Dim As ComboBoxEdit Ptr cbo = user_data
			cbo->FSelected = True
			If cbo->OnSelected Then cbo->OnSelected(*cbo->Designer, *cbo, cbo->ItemIndex)
			If cbo->OnChange Then cbo->OnChange(*cbo->Designer, *cbo)
		End Sub
		
		Private Sub ComboBoxEdit.Entry_Activate(entry As GtkEntry Ptr, user_data As Any Ptr)
			Dim As ComboBoxEdit Ptr cbo = user_data
			Dim As Control Ptr btn = cbo->GetForm()->FDefaultButton
			If cbo->OnActivate Then cbo->OnActivate(*cbo->Designer, *cbo)
			If btn AndAlso btn->OnClick Then btn->OnClick(*btn->Designer, *btn)
		End Sub
	#endif
	
	Private Constructor ComboBoxEdit
		#ifdef __USE_GTK__
			DropDownWidget = gtk_combo_box_text_new_with_entry()
			DropDownListWidget = gtk_combo_box_text_new()
			widget = DropDownListWidget
			eventboxwidget = gtk_event_box_new()
			gtk_container_add(gtk_container(eventboxwidget), widget)
			g_signal_connect(gtk_bin_get_child(gtk_bin(DropDownWidget)), "activate", G_CALLBACK(@Entry_Activate), @This)
			g_signal_connect(widget, "changed", G_CALLBACK(@ComboBoxEdit_Changed), @This)
			g_signal_connect(widget, "popup", G_CALLBACK(@ComboBoxEdit_Popup), @This)
			g_signal_connect(widget, "popdown", G_CALLBACK(@ComboBoxEdit_Popdown), @This)
			Base.RegisterClass "ComboBoxEdit", @This
		#else
			ASortStyle(Abs_(True))   = CBS_SORT
			AStyle(0)          = CBS_SIMPLE
			AStyle(1)          = CBS_DROPDOWN
			AStyle(2)          = CBS_DROPDOWNLIST
			AStyle(3)          = CBS_DROPDOWNLIST Or CBS_OWNERDRAWFIXED
			AStyle(4)          = CBS_DROPDOWNLIST Or CBS_OWNERDRAWVARIABLE
			AIntegralHeight(0) = CBS_NOINTEGRALHEIGHT
			AIntegralHeight(1) = 0
		#endif
		FStyle              = cbDropDownList
		'ItemHeight          = 13
		FDropDownCount      = 8
		FSelColor           = &H800000
		FIntegralHeight     = 0
		FItemIndex          = -1
		FTabIndex           = -1
		FTabStop            = True
		'Items.Parent        = @This
		With This
			.Child          = @This
			'.ChildProc     = @WindowProc
			'ComboBoxEdit.RegisterClass
			WLet(FClassName, "ComboBoxEdit")
			WLet(FClassAncestor, "ComboBox")
			#ifndef __USE_GTK__
				Base.RegisterClass "ComboBoxEdit", "ComboBox"
				.ExStyle       = 0
				Base.Style     = WS_CHILD Or WS_VSCROLL Or WS_TABSTOP Or CBS_HASSTRINGS Or CBS_AUTOHSCROLL Or AStyle(abs_(FStyle)) Or ASortStyle(abs_(FSort)) Or AIntegralHeight(abs_(FIntegralHeight))
				.BackColor         = GetSysColor(COLOR_WINDOW)
				FDefaultBackColor = .BackColor
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.Width          = 121
			#ifdef __USE_GTK__
				#ifndef __USE_GTK3__
					.FMinHeight     = 28
				#endif
				.Height        = 20
			#else
				.Height        = 17
			#endif
		End With
	End Constructor
	
	Private Destructor ComboBoxEdit
		WDeAllocate(FItemText)
		#ifdef __USE_GTK__
			#ifndef __FB_WIN32__
				If GTK_IS_WIDGET(DropDownWidget) Then
					#ifdef __USE_GTK4__
						g_object_unref(DropDownWidget)
					#else
						gtk_widget_destroy(DropDownWidget)
					#endif
					DropDownWidget = 0
				End If
				If GTK_IS_WIDGET(DropDownListWidget) Then
					#ifdef __USE_GTK4__
						g_object_unref(DropDownListWidget)
					#else
						gtk_widget_destroy(DropDownListWidget)
					#endif
					DropDownListWidget = 0
				End If
			#endif
			widget = 0
			'			If This.Parent AndAlso This.Parent->Widget Then
			'				gtk_container_remove(gtk_container(This.Parent->Widget), gtk_widget(Widget))
			'			End If
		#else
			UnregisterClass "ComboBoxEdit", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
