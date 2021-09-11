'###############################################################################
'#  CheckedListBox.bi                                                          #
'#  This file is part of MyFBFramework                                         #
'#  Based on:                                                                  #
'#   TListBox.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Modified by Xusinboy Bekchanov (2018-2019)                                 #
'###############################################################################

#include once "CheckedListBox.bi"

Namespace My.Sys.Forms
	Function CheckedListBox.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "borderstyle": Return @FBorderStyle
		Case "multicolumn": Return @FMultiColumn
		Case "ctl3d": Return @FCtl3D
		Case "extendselect": Return @FExtendSelect
		Case "integralheight": Return @FIntegralHeight
		'Case "itemcount": Return @FItemCount
		Case "itemheight": Return @FItemHeight
		Case "itemindex": Return @FItemIndex
		Case "multiselect": Return @FMultiSelect
		Case "selcount": Return @FSelCount
		Case "sort": Return @FSort
		Case "tabindex": Return @FTabIndex
		Case "topindex": Return @FTopIndex
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function CheckedListBox.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "borderstyle": BorderStyle = QInteger(Value)
		Case "multicolumn": MultiColumn = QBoolean(Value)
		Case "ctl3d": Ctl3D = QBoolean(Value)
		Case "extendselect": ExtendSelect = QBoolean(Value)
		Case "integralheight": IntegralHeight = QBoolean(Value)
		Case "itemheight": ItemHeight = QInteger(Value)
		Case "multiselect": MultiSelect = QBoolean(Value)
		Case "sort": Sort = QBoolean(Value)
		Case "tabindex": TabIndex = QInteger(Value)
		Case "topindex": TopIndex = QInteger(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Property CheckedListBox.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Property CheckedListBox.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Property CheckedListBox.TabStop As Boolean
		Return FTabStop
	End Property
	
	Property CheckedListBox.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Property CheckedListBox.MultiSelect As Boolean
		Return FMultiselect
	End Property
	
	Property CheckedListBox.MultiSelect(Value As Boolean)
		If Value <> FMultiselect Then
			FMultiselect = Value
			#ifdef __USE_GTK__
				gtk_tree_selection_set_mode(gtk_tree_view_get_selection(gtk_tree_view(widget)), IIf(value, GTK_SELECTION_MULTIPLE, GTK_SELECTION_SINGLE))
			#else
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD Or WS_HSCROLL Or WS_VSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or LBS_DISABLENOSCROLL Or LBS_OWNERDRAWFIXED Or AStyle(Abs_(FStyle)) Or ABorderStyle(Abs_(FBorderStyle)) Or ASortStyle(Abs_(FSort)) Or AMultiselect(Abs_(FMultiselect)) Or AExtendSelect(Abs_(FExtendSelect)) Or AMultiColumns(Abs_(FMultiColumn)) Or AIntegralHeight(Abs_(FIntegralHeight))
			#endif
		End If
	End Property
	
	Property CheckedListBox.ExtendSelect As Boolean
		Return FExtendSelect
	End Property
	
	Property CheckedListBox.ExtendSelect(Value As Boolean)
		If Value <> FExtendSelect Then
			FExtendSelect = Value
			#ifdef __USE_GTK__
				#ifndef __USE_GTK3__
					gtk_tree_selection_set_mode(gtk_tree_view_get_selection(gtk_tree_view(widget)), IIf(value, GTK_SELECTION_EXTENDED, GTK_SELECTION_MULTIPLE))
				#endif
			#else
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD Or WS_HSCROLL Or WS_VSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or LBS_DISABLENOSCROLL Or LBS_OWNERDRAWFIXED Or AStyle(Abs_(FStyle)) Or ABorderStyle(Abs_(FBorderStyle)) Or ASortStyle(Abs_(FSort)) Or AMultiselect(Abs_(FMultiselect)) Or AExtendSelect(Abs_(FExtendSelect)) Or AMultiColumns(Abs_(FMultiColumn)) Or AIntegralHeight(Abs_(FIntegralHeight))
			#endif
		End If
	End Property
	
	Property CheckedListBox.MultiColumn As Boolean
		Return FMultiColumn
	End Property
	
	Property CheckedListBox.MultiColumn(Value As Boolean)
		If Value <> FMultiColumn Then
			FMultiColumn = Value
			#ifndef __USE_GTK__
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD Or WS_HSCROLL Or WS_VSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or LBS_DISABLENOSCROLL Or LBS_OWNERDRAWFIXED Or AStyle(Abs_(FStyle)) Or ABorderStyle(Abs_(FBorderStyle)) Or ASortStyle(Abs_(FSort)) Or AMultiselect(Abs_(FMultiselect)) Or AExtendSelect(Abs_(FExtendSelect)) Or AMultiColumns(Abs_(FMultiColumn)) Or AIntegralHeight(Abs_(FIntegralHeight))
			#endif
		End If
	End Property
	
	Property CheckedListBox.IntegralHeight As Boolean
		Return FIntegralHeight
	End Property
	
	Property CheckedListBox.IntegralHeight(Value As Boolean)
		If Value <> FIntegralHeight Then
			FIntegralHeight = Value
			#ifndef __USE_GTK__
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD Or WS_HSCROLL Or WS_VSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or LBS_DISABLENOSCROLL Or LBS_OWNERDRAWFIXED Or AStyle(Abs_(FStyle)) Or ABorderStyle(ABs_(FBorderStyle)) Or ASortStyle(Abs_(FSort)) Or AMultiselect(Abs_(FMultiselect)) Or AExtendSelect(Abs_(FExtendSelect)) Or AMultiColumns(Abs_(FMultiColumn)) Or AIntegralHeight(Abs_(FIntegralHeight))
			#endif
		End If
	End Property
	
	Property CheckedListBox.Ctl3D As Boolean
		Return FCtl3D
	End Property
	
	Property CheckedListBox.Ctl3D(Value As Boolean)
		If Value <> FCtl3D Then
			FCtl3D = Value
			#ifndef __USE_GTK__
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD Or WS_HSCROLL Or WS_VSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or LBS_DISABLENOSCROLL Or LBS_OWNERDRAWFIXED Or AStyle(Abs_(FStyle)) Or ABorderStyle(Abs_(FBorderStyle)) Or ASortStyle(Abs_(FSort)) Or AMultiselect(Abs_(FMultiselect)) Or AExtendSelect(Abs_(FExtendSelect)) Or AMultiColumns(Abs_(FMultiColumn)) Or AIntegralHeight(Abs_(FIntegralHeight))
			#endif
		End If
	End Property
	
	Property CheckedListBox.BorderStyle As Integer
		Return FBorderStyle
	End Property
	
	Property CheckedListBox.BorderStyle(Value As Integer)
		If Value <> FBorderStyle Then
			FBorderStyle = Value
			#ifdef __USE_GTK__
				gtk_scrolled_window_set_shadow_type(gtk_scrolled_window(scrolledwidget), IIf(Value, GTK_SHADOW_OUT, GTK_SHADOW_NONE))
			#else
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD Or WS_HSCROLL Or WS_VSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or LBS_DISABLENOSCROLL Or LBS_OWNERDRAWFIXED Or AStyle(Abs_(FStyle)) Or ABorderStyle(Abs_(FBorderStyle)) Or ASortStyle(Abs_(FSort)) Or AMultiselect(Abs_(FMultiselect)) Or AExtendSelect(Abs_(FExtendSelect)) Or AMultiColumns(Abs_(FMultiColumn)) Or AIntegralHeight(Abs_(FIntegralHeight))
			#endif
		End If
	End Property
	
	Property CheckedListBox.ItemCount As Integer
		#ifndef __USE_GTK__
			If Handle Then
				Return Perform(LB_GETCOUNT, 0, 0)
			End If
		#endif
		Return Items.Count
	End Property
	
	Property CheckedListBox.ItemCount(Value As Integer)
	End Property
	
	Property CheckedListBox.ItemHeight As Integer
		Return FItemHeight
	End Property
	
	Property CheckedListBox.ItemHeight(Value As Integer)
		FItemHeight = Value
		#ifndef __USE_GTK__
			If Handle Then Perform(LB_SETITEMHEIGHT,0,MakeLParam(FItemHeight,0))
		#endif
	End Property
	
	Property CheckedListBox.TopIndex As Integer
		Return FTopIndex
	End Property
	
	Property CheckedListBox.TopIndex(Value As Integer)
		FTopIndex = Value
		#ifndef __USE_GTK__
			If Handle Then Perform(LB_SETTOPINDEX,FTopIndex,0)
		#endif
	End Property
	
	Property CheckedListBox.ItemIndex As Integer
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			If gtk_tree_selection_get_selected(TreeSelection, NULL, @iter) Then
				Dim As Integer i
        		Dim As GtkTreePath Ptr path
        		path = gtk_tree_model_get_path(gtk_tree_model(ListStore), @iter)
        		FItemIndex = gtk_tree_path_get_indices(path)[0]
        		gtk_tree_path_free(path)
			End If
		#else
			If Handle Then
				FItemIndex = Perform(LB_GETCURSEL, 0, 0)
			End If
		#endif
		Return FItemIndex
	End Property
	
	Property CheckedListBox.ItemIndex(Value As Integer)
		FItemIndex = Value
		#ifdef __USE_GTK__
			If ListStore Then
				If Value = -1 Then
					gtk_tree_selection_unselect_all(gtk_tree_view_get_selection(gtk_tree_view(widget)))
				ElseIf Value > -1 AndAlso Value < Items.Count Then
					Dim As GtkTreeIter iter
					gtk_tree_model_get_iter_from_string(GTK_TREE_MODEL(ListStore), @iter, Trim(Str(Value)))
					gtk_tree_selection_select_iter(gtk_tree_view_get_selection(gtk_tree_view(widget)), @iter)
					gtk_tree_view_scroll_to_cell(gtk_tree_view(widget), gtk_tree_model_get_path(gtk_tree_model(ListStore), @iter), NULL, False, 0, 0)
				End If
			End If
		#else
			If Handle Then
				If MultiSelect Then
					Perform(LB_SETCARETINDEX, FItemIndex, 0)
				Else
					Perform(LB_SETCURSEL,FItemIndex,0)
				End If
			End If
		#endif
	End Property
	
	Property CheckedListBox.SelCount As Integer
		Return FSelCount
	End Property
	
	Property CheckedListBox.SelCount(Value As Integer)
		FSelCount = Value
	End Property
	
	Property CheckedListBox.SelItems As Integer Ptr
		Return FSelItems
	End Property
	
	Property CheckedListBox.SelItems(Value As Integer Ptr)
		FSelItems = Value
	End Property
	
	Property CheckedListBox.Text ByRef As WString
		If Handle Then
			FText = Items.Item(ItemIndex)
		End If
		Return *FText.vptr
	End Property
	
	Property CheckedListBox.Text(ByRef Value As WString)
		FText = Value
		#ifdef __USE_GTK__
			ItemIndex = Items.IndexOf(Value)
		#else
			If FHandle Then Perform(LB_SELECTSTRING, -1, CInt(FText.vptr))
		#endif
	End Property
	
	Property CheckedListBox.Sort As Boolean
		Return FSort
	End Property
	
	Property CheckedListBox.Sort(Value As Boolean)
		If Value <> FSort Then
			FSort = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or WS_HSCROLL Or WS_VSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or LBS_DISABLENOSCROLL Or LBS_OWNERDRAWFIXED Or AStyle(Abs_(FStyle)) Or ABorderStyle(Abs_(FBorderStyle)) Or ASortStyle(Abs_(FSort)) Or AMultiselect(Abs_(FMultiselect)) Or AExtendSelect(Abs_(FExtendSelect)) Or AMultiColumns(Abs_(FMultiColumn)) Or AIntegralHeight(Abs_(FIntegralHeight))
			#endif
		End If
	End Property
	
	Property CheckedListBox.ItemData(FIndex As Integer) As Any Ptr
		Return Items.Object(FIndex)
	End Property
	
	Property CheckedListBox.ItemData(FIndex As Integer, Obj As Any Ptr)
		Items.Object(FIndex) = Obj
	End Property
	
	Property CheckedListBox.Item(FIndex As Integer) ByRef As WString
		Dim As Integer L
		Dim As WString Ptr s
		#ifndef __USE_GTK__
			If FHandle Then
				L = Perform(LB_GETTEXTLEN, FIndex, 0)
				s = CAllocate_((L + 1) * SizeOf(WString))
				*s = Space(L)
				Perform(LB_GETTEXT, FIndex, CInt(s))
				Return *s
			Else
				s = CAllocate_((Len(Items.Item(FIndex)) + 1) * SizeOf(WString))
				*s = Items.Item(FIndex)
				Return *s
			End If
		#else
			s = CAllocate_((Len(Items.Item(FIndex)) + 1) * SizeOf(WString))
			*s = Items.Item(FIndex)
			Return *s
		#endif
	End Property
	
	Property CheckedListBox.Item(FIndex As Integer, ByRef FItem As WString)
		Items.Item(FIndex) = FItem
	End Property
	
	Sub CheckedListBox.AddItem(ByRef FItem As WString, Obj As Any Ptr = 0)
		Dim i As Integer
		If FSort Then
			For i = 0 To Items.Count - 1
				If Items.Item(i) > FItem Then Exit For
			Next
			Items.Insert i, FItem, Obj
		Else
			Items.Add(FItem, Obj)
		End If
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			gtk_list_store_append (ListStore, @iter)
			gtk_list_store_set(ListStore, @iter, 1, ToUtf8(FItem), -1)
		#else
			If Handle Then Perform(LB_ADDSTRING, 0, CInt(FItem))
		#endif
	End Sub
	
	Sub CheckedListBox.RemoveItem(FIndex As Integer)
		Items.Remove(FIndex)
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			gtk_tree_model_get_iter_from_string(GTK_TREE_MODEL(ListStore), @iter, Trim(Str(FIndex)))
			gtk_list_store_remove(ListStore, @iter)
		#else
			If Handle Then Perform(LB_DELETESTRING, FIndex, 0)
		#endif
	End Sub
	
	Sub CheckedListBox.InsertItem(FIndex As Integer, ByRef FItem As WString, Obj As Any Ptr = 0)
		Items.Insert(FIndex, FItem, Obj)
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			gtk_list_store_insert(ListStore, @Iter, FIndex)
			gtk_list_store_set (ListStore, @Iter, 1, ToUtf8(FItem), -1)
		#else
			If Handle Then Perform(LB_INSERTSTRING, FIndex, CInt(@FItem))
		#endif
	End Sub
	
	Function CheckedListBox.IndexOf(ByRef FItem As WString) As Integer
		#ifndef __USE_GTK__
			Return Perform(LB_FINDSTRING, -1, CInt(FItem))
		#else
			Return Items.IndexOf(FItem)
		#endif
	End Function
	
	Function CheckedListBox.IndexOfData(Obj As Any Ptr) As Integer
		Return Items.IndexOfObject(Obj)
	End Function
	
	Property CheckedListBox.Selected(Index As Integer) As Boolean
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			Dim As Boolean bSelected
			gtk_tree_model_get_iter_from_string(GTK_TREE_MODEL(ListStore), @iter, Trim(Str(Index)))
			gtk_tree_model_get(GTK_TREE_MODEL(ListStore), @iter, @bSelected)
			Return bSelected
		#else
			If Handle Then Return Perform(LB_GETSEL, Index, 0)
		#endif
	End Property
	
	Property CheckedListBox.Selected(Index As Integer, Value As Boolean)
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			gtk_tree_model_get_iter_from_string(GTK_TREE_MODEL(ListStore), @iter, Trim(Str(Index)))
			gtk_list_store_set(ListStore, @Iter, 1, Value, -1)
		#else
			If Handle Then Perform(LB_SETSEL, Abs_(Value), Index)
		#endif
	End Property
	
	Property CheckedListBox.Checked(Index As Integer) As Boolean
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			Dim As Boolean bChecked
			gtk_tree_model_get_iter_from_string(GTK_TREE_MODEL(ListStore), @iter, Trim(Str(Index)))
			gtk_tree_model_get(GTK_TREE_MODEL(ListStore), @iter, 0, @bChecked, -1)
			Return bChecked
		#else
			If Handle Then Return Perform(LB_GETITEMDATA, Index, 0)
		#endif
	End Property
	
	Property CheckedListBox.Checked(Index As Integer, Value As Boolean)
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			gtk_tree_model_get_iter_from_string(GTK_TREE_MODEL(ListStore), @iter, Trim(Str(Index)))
			gtk_list_store_set(ListStore, @Iter, 0, Value, -1)
		#else
			If Handle Then Perform(LB_SETITEMDATA, Index, Abs_(Value))
		#endif
	End Property
	
	#ifndef __USE_GTK__
		Sub CheckedListBox.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QCheckedListBox(Sender.Child)
					For i As Integer = 0 To .Items.Count -1
						Dim As WString Ptr s = CAllocate_((Len(.Items.Item(i)) + 1) * SizeOf(WString))
						*s = .Items.Item(i)
						.Perform(LB_ADDSTRING, 0, CInt(s))
					Next i
					.Perform(LB_SETITEMHEIGHT, 0, MakeLParam(.ItemHeight, 0))
					.MultiColumn = .MultiColumn
					.ItemIndex = .ItemIndex
					If .MultiSelect Then
						For i As Integer = 0 To .SelCount -1
							.Perform(LB_SETSEL, 1, .SelItems[i])
						Next i
					End If
					.TopIndex = .FTopIndex
				End With
			End If
		End Sub
	#endif
	
	#ifndef __USE_GTK__
		Sub CheckedListBox.WndProc(ByRef Message As Message)
		End Sub
		
		Sub CheckedListBox.ProcessMessage(ByRef Message As Message)
			Dim pt As Point, rc As RECT, t As Long, itd As Long
    		Select Case Message.Msg
    		Case CM_DRAWITEM
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
		                FillRect lpdis->hDC, @lpdis->rcItem, GetSysColorBrush(COLOR_WINDOW)
		                If (lpdis->itemState And ODS_SELECTED)   Then                       'if selected Then
		                	rc.Left   = lpdis->rcItem.Left + 16 : rc.Right = lpdis->rcItem.Right              '  Set cordinates
		                    rc.top    = lpdis->rcItem.top
		                    rc.bottom = lpdis->rcItem.bottom
		                	FillRect lpdis->hDC, @rc, GetSysColorBrush(COLOR_HIGHLIGHT)
			                SetBkColor lpdis->hDC, GetSysColor(COLOR_HIGHLIGHT)                    'Set text Background
			                SetTextColor lpdis->hDC, GetSysColor(COLOR_HIGHLIGHTTEXT)                'Set text color
			                If ItemIndex = lpdis->itemID AndAlso Focused Then
			                	DrawFocusRect lpdis->hDC, @rc  'draw focus rectangle
			                End If
		                Else
		                	FillRect lpdis->hDC, @lpdis->rcItem, GetSysColorBrush(COLOR_WINDOW)
		                	SetBkColor lpdis->hDC, GetSysColor(COLOR_WINDOW)                    'Set text Background
			                SetTextColor lpdis->hDC, GetSysColor(COLOR_WINDOWTEXT)                'Set text color
			                If CInt(ItemIndex = -1) AndAlso CInt(lpdis->itemID = 0) AndAlso CInt(Focused) Then
			                	rc.Left   = lpdis->rcItem.Left + 16 : rc.Right = lpdis->rcItem.Right              '  Set cordinates
			                    rc.top    = lpdis->rcItem.top
			                    rc.bottom = lpdis->rcItem.bottom
			                	DrawFocusRect lpdis->hDC, @rc  'draw focus rectangle
			                End If
		                End If
		                'DRAW TEXT
		                SendMessage message.hWnd, LB_GETTEXT, lpdis->itemID, Cast(LPARAM, @zTxt)                  'Get text
		                TextOut lpdis->hDC, lpdis->rcItem.Left + 18, lpdis->rcItem.top + 2, @zTxt, Len(zTxt)     'Draw text
		                'DRAW CHECKBOX
		                rc.Left   = lpdis->rcItem.Left + 2 : rc.Right = lpdis->rcItem.Left + 15               'Set cordinates
		                rc.top    = lpdis->rcItem.top + 2
		                rc.bottom = lpdis->rcItem.bottom - 1
		                If SendMessage(Message.hWnd, LB_GETITEMDATA, lpdis->itemID, 0) Then 'checked or not? itemdata knows
	                        DrawFrameControl lpdis->hDC, @rc, DFC_BUTTON, DFCS_BUTTONCHECK Or DFCS_CHECKED
	                    Else
	                        DrawFrameControl lpdis->hDC, @rc, DFC_BUTTON, DFCS_BUTTONCHECK
		                End If
	                    Message.Result = True : Exit Sub
	                Case ODA_FOCUS
	                    DrawFocusRect lpdis->hDC, @lpdis->rcItem  'draw focus rectangle
	                    Message.Result = True : Exit Sub
		            End Select 
		        End If
			Case WM_LBUTTONDOWN
	            If Message.wParam = MK_LBUTTON  Then                                            'respond to mouse click
	                pt.x = LoWord(Message.lParam) : pt.y = HiWord(Message.lParam)                       'get cursor pos
	                t = SendMessage(Message.hWnd, LB_ITEMFROMPOINT, 0, MakeLong(pt.x, pt.y))    'get sel. item
	                SendMessage Message.hWnd, LB_GETITEMRECT, t, Cast(LPARAM, @rc)                            'get sel. item's rect
	                rc.Left   = rc.Left + 2 : rc.Right = rc.Left + 15                                       'checkbox cordinates
	                If PtInRect(@rc, pt) Then
	                    itd = Not CBool(SendMessage(Message.hWnd, LB_GETITEMDATA, t, 0))                 'get toggled item data
	                    SendMessage Message.hWnd, LB_SETITEMDATA, t, itd                            'set toggled item data
	                    InvalidateRect Message.hWnd, @rc, 0 : UpdateWindow Message.hWnd                     'update sel. item only
	                End If
	            End If
			Case WM_PAINT
				'Message.Result = 0
			Case CM_CTLCOLOR
				Static As HDC Dc
				Dc = Cast(HDC,Message.wParam)
				SetBKMode Dc, TRANSPARENT
				SetTextColor Dc, Font.Color
				SetBKColor Dc, This.BackColor
				SetBKMode Dc, OPAQUE
			Case CM_COMMAND
				Select Case Message.wParamHi
				Case LBN_SELCHANGE
					If MultiSelect Then
						FSelCount = Perform(LB_GETSELCOUNT,0,0)
						If FSelCount Then
							Dim As Integer AItems(FSelCount)
							Perform(LB_GETSELITEMS,FSelCount,CInt(@AItems(0)))
							SelItems = @AItems(0)
						End If
					End If
					If OnChange Then OnChange(This)
				Case LBN_DBLCLK
					If OnDblClick Then OnDblClick(This)
				End Select
			Case CM_MEASUREITEM
				Dim As MEASUREITEMSTRUCT Ptr miStruct
				Dim As Integer ItemID
				miStruct = Cast(MEASUREITEMSTRUCT Ptr,Message.lParam)
				ItemID = Cast(Integer,miStruct->itemID)
				If OnMeasureItem Then
					OnMeasureItem(This,itemID,miStruct->itemHeight)
				Else
					miStruct->itemHeight = ItemHeight
				End If
			Case CM_DRAWITEM
				Dim As DRAWITEMSTRUCT Ptr diStruct
				Dim As Integer ItemID,State
				Dim As Rect R
				Dim As HDC Dc
				diStruct = Cast(DRAWITEMSTRUCT Ptr,Message.lParam)
				ItemID = Cast(Integer,diStruct->itemID)
				State = Cast(Integer,diStruct->itemState)
				R = Cast(Rect,diStruct->rcItem)
				Dc = diStruct->hDC
				If OnDrawItem Then
					OnDrawItem(This,ItemID,State,R,Dc)
				Else
					If (State And ODS_SELECTED) = ODS_SELECTED Then
						Static As HBRUSH B
						If B Then DeleteObject B
						B = CreateSolidBrush(&H800000)
						FillRect Dc,@R,B
						R.Left += 2
						SetTextColor Dc,clHighlightText
						SetBKColor Dc,&H800000
						DrawText(Dc,Item(ItemID),Len(Item(ItemID)),@R,DT_SINGLELINE Or DT_VCENTER Or DT_NOPREFIX)
					Else
						FillRect Dc, @R, Brush.Handle
						R.Left += 2
						SetTextColor Dc, Font.Color
						SetBKColor Dc, This.BackColor
						DrawText(Dc,Item(ItemID),Len(Item(ItemID)),@R,DT_SINGLELINE Or DT_VCENTER Or DT_NOPREFIX)
					End If
				End If
    		Case WM_CHAR
    			If Message.wParam = 32 Then Checked(ItemIndex) = Not Checked(ItemIndex): This.Repaint
				If OnKeyPress Then OnKeyPress(This,LoByte(Message.wParam),Message.wParam And &HFFFF)
			Case WM_KEYDOWN
				If OnKeyDown Then OnKeyDown(This,Message.wParam,Message.wParam And &HFFFF)
			Case WM_KEYUP
				If OnKeyUp Then OnKeyUp(This,Message.wParam,Message.wParam And &HFFFF)
			End Select
			Base.ProcessMessage(Message)
		End Sub
	#endif
	
	Sub CheckedListBox.Clear
		Items.Clear
		#ifdef __USE_GTK__
			gtk_list_store_clear(ListStore)
		#else
			Perform(LB_RESETCONTENT,0,0)
		#endif
	End Sub
	
	Sub CheckedListBox.SaveToFile(ByRef File As WString)
		Dim As Integer F, i
		Dim As WString Ptr s
		F = FreeFile
		Open File For Binary Access Write As #F
		For i = 0 To ItemCount - 1
			#ifdef __USE_GTK__
				Print #F, Items.Item(i)
			#else
				Dim TextLen As Integer = Perform(LB_GETTEXTLEN, i, 0)
				s = CAllocate_((Len(TextLen) + 1) * SizeOf(WString))
				*s = Space(TextLen)
				Perform(LB_GETTEXT, i, CInt(s))
				Print #F, *s
			#endif
		Next i
		Close #F
	End Sub
	
	Sub CheckedListBox.LoadFromFile(ByRef File As WString)
		Dim As Integer F, i
		Dim As WString Ptr s
		F = FreeFile
		Clear
		Open File For Binary Access Read As #F
		s = CAllocate_((LOF(F) + 1) * SizeOf(WString))
		While Not EOF(F)
			Line Input #F, *s
			#ifdef __USE_GTK__
				AddItem *s
			#else
				Perform(LB_ADDSTRING, 0, CInt(s))
			#endif
		Wend
		Deallocate s
		Close #F
	End Sub
	
	Operator CheckedListBox.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Sub CheckedListBox.Check(cell As GtkCellRendererToggle Ptr, path As gchar Ptr, model As GtkListStore Ptr)
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
	
	Constructor CheckedListBox
		#ifdef __USE_GTK__
			Dim As GtkTreeViewColumn Ptr col = gtk_tree_view_column_new()
			Dim As GtkCellRenderer Ptr rendertoggle = gtk_cell_renderer_toggle_new()
			Dim As GtkCellRenderer Ptr rendertext = gtk_cell_renderer_text_new()
			scrolledwidget = gtk_scrolled_window_new(NULL, NULL)
			gtk_scrolled_window_set_policy(gtk_scrolled_window(scrolledwidget), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
			gtk_scrolled_window_set_shadow_type(gtk_scrolled_window(scrolledwidget), GTK_SHADOW_OUT)
			ListStore = gtk_list_store_new(2, G_TYPE_BOOLEAN, G_TYPE_STRING)
			widget = gtk_tree_view_new_with_model(GTK_TREE_MODEL(ListStore))
			gtk_container_add(gtk_container(scrolledwidget), widget)
			TreeSelection = gtk_tree_view_get_selection(GTK_TREE_VIEW(widget))
			
			gtk_tree_view_column_pack_start(col, rendertoggle, False)
			gtk_tree_view_column_add_attribute(col, rendertoggle, ToUTF8("active"), 0)
			g_signal_connect(rendertoggle, "toggled", G_CALLBACK(@check), ListStore)
			
			gtk_tree_view_column_pack_start(col, rendertext, True)
			gtk_tree_view_column_add_attribute(col, rendertext, ToUTF8("text"), 1)
			gtk_tree_view_append_column(GTK_TREE_VIEW(widget), col)
			
			gtk_tree_view_set_headers_visible(GTK_TREE_VIEW(widget), False)
			
'			g_signal_connect(gtk_tree_view(widget), "button-release-event", G_CALLBACK(@TreeView_ButtonRelease), @This)
'			g_signal_connect(widget, "row-activated", G_CALLBACK(@TreeView_RowActivated), @This)
'			g_signal_connect(widget, "query-tooltip", G_CALLBACK(@TreeView_QueryTooltip), @This)
'			g_signal_connect(G_OBJECT(TreeSelection), "changed", G_CALLBACK (@TreeView_SelectionChanged), @This)
		#else
			ASortStyle(0)   = 0
			ASortStyle(1)   = LBS_SORT
			AStyle(0)          = 0
			AStyle(1)          = LBS_OWNERDRAWFIXED
			AStyle(2)          = LBS_OWNERDRAWVARIABLE
			ABorderExStyle(0)  = 0
			ABorderExStyle(1)  = WS_EX_CLIENTEDGE
			ABorderStyle(0)    = WS_BORDER
			ABorderStyle(1)    = 0
			AMultiselect(0)    = 0
			AMultiselect(1)    = LBS_MULTIPLESEL
			AExtendSelect(0)   = 0
			AExtendSelect(1)   = LBS_EXTENDEDSEL
			AMultiColumns(0)   = 0
			AMultiColumns(1)   = LBS_MULTICOLUMN
			AIntegralHeight(0) = LBS_NOINTEGRALHEIGHT
			AIntegralHeight(1) = 0
		#endif
		FCtl3D             = True
		FBorderStyle       = 1
		FTabIndex          = -1
		FTabStop           = True
		'Items.Parent       = @This
		With This
			WLet(FClassName, "CheckedListBox")
			WLet(FClassAncestor, "ListBox")
			.Child       = @This
			#ifndef __USE_GTK__
				.RegisterClass "CheckedListBox", "ListBox"
				.ChildProc   = @WndProc
				.ExStyle     = ABorderExStyle(Abs_(FCtl3D))
				Base.Style       = WS_CHILD Or WS_VSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or LBS_DISABLENOSCROLL Or LBS_OWNERDRAWFIXED Or AStyle(Abs_(FStyle)) Or ABorderStyle(Abs_(FBorderStyle)) Or ASortStyle(Abs_(FSort)) Or AMultiselect(Abs_(FMultiselect)) Or AExtendSelect(Abs_(FExtendSelect)) Or AMultiColumns(Abs_(FMultiColumn)) Or AIntegralHeight(Abs_(FIntegralHeight))
				.BackColor       = GetSysColor(COLOR_WINDOW)
				.OnHandleIsAllocated = @HandleIsAllocated
				.DoubleBuffered = True
			#endif
			.Width       = 121
			.Height      = 17
		End With
	End Constructor
	
	Destructor CheckedListBox
		'If Items Then DeAllocate Items
	End Destructor
End Namespace
