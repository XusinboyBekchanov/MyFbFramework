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
	#ifndef ReadProperty_Off
		Private Function CheckedListBox.ReadProperty(PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function CheckedListBox.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	
	Private Sub CheckedListBox.AddItem(ByRef FItem As WString, Obj As Any Ptr = 0)
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
			If Handle Then Perform(LB_ADDSTRING, 0, CInt(@FItem))
		#endif
	End Sub
	
	Private Sub CheckedListBox.InsertItem(FIndex As Integer, ByRef FItem As WString, Obj As Any Ptr = 0)
		If FSort Then
			AddItem FItem, Obj
			Exit Sub
		End If
		Items.Insert(FIndex, FItem, Obj)
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			gtk_list_store_insert(ListStore, @Iter, FIndex)
			gtk_list_store_set (ListStore, @Iter, 1, ToUtf8(FItem), -1)
		#else
			If Handle Then Perform(LB_INSERTSTRING, FIndex, CInt(@FItem))
		#endif
	End Sub
	
	Private Property CheckedListBox.Checked(Index As Integer) As Boolean
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
	
	Private Property CheckedListBox.Checked(Index As Integer, Value As Boolean)
		#ifdef __USE_GTK__
			Dim As GtkTreeIter iter
			gtk_tree_model_get_iter_from_string(GTK_TREE_MODEL(ListStore), @iter, Trim(Str(Index)))
			gtk_list_store_set(ListStore, @iter, 0, Value, -1)
		#else
			If Handle Then Perform(LB_SETITEMDATA, Index, abs_(Value))
		#endif
	End Property
	
	#ifndef __USE_GTK__
		Private Sub CheckedListBox.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QCheckedListBox(Sender.Child)
					For i As Integer = 0 To .Items.Count -1
						Dim As WString Ptr s = CAllocate_((Len(.Items.Item(i)) + 1) * SizeOf(WString))
						*s = .Items.Item(i)
						.Perform(LB_ADDSTRING, 0, CInt(s))
					Next i
					.Perform(LB_SETITEMHEIGHT, 0, MAKELPARAM(.ItemHeight, 0))
					.MultiColumn = .MultiColumn
					.ItemIndex = .ItemIndex
					If .SelectionMode = SelectionModes.smMultiSimple Or .SelectionMode = SelectionModes.smMultiExtended Then
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
		Private Sub CheckedListBox.WndProc(ByRef Message As Message)
		End Sub
		
		Private Sub CheckedListBox.ProcessMessage(ByRef Message As Message)
			Dim pt As ..Point, rc As ..Rect, t As Long, itd As Long
			Select Case Message.Msg
			Case CM_DRAWITEM
				Dim lpdis As DRAWITEMSTRUCT Ptr, zTxt As WString * 64
				Dim As Integer ItemID, State
				lpdis = Cast(DRAWITEMSTRUCT Ptr, Message.lParam)
				If OnDrawItem Then
					OnDrawItem(This, lpdis->itemID, lpdis->itemState, *Cast(My.Sys.Drawing.Rect Ptr, @lpdis->rcItem), lpdis->hDC)
				Else
					If lpdis->itemID = &HFFFFFFFF& Then
						Exit Sub
					EndIf
					Select Case lpdis->itemAction
					Case ODA_DRAWENTIRE, ODA_SELECT
						'DRAW BACKGROUND
						FillRect lpdis->hDC, @lpdis->rcItem, Brush.Handle 'GetSysColorBrush(COLOR_WINDOW)
						If (lpdis->itemState And ODS_SELECTED)   Then                       'if selected Then
							rc.Left   = lpdis->rcItem.Left + 16 : rc.Right = lpdis->rcItem.Right              '  Set cordinates
							rc.Top    = lpdis->rcItem.Top
							rc.Bottom = lpdis->rcItem.Bottom
							FillRect lpdis->hDC, @rc, GetSysColorBrush(COLOR_HIGHLIGHT)
							SetBkColor lpdis->hDC, GetSysColor(COLOR_HIGHLIGHT)                    'Set text Background
							SetTextColor lpdis->hDC, GetSysColor(COLOR_HIGHLIGHTTEXT)                'Set text color
							'If ItemIndex = lpdis->itemID AndAlso Focused Then
							If Focused AndAlso lpdis->itemAction = ODA_SELECT Then
								'DrawFocusRect lpdis->hDC, @rc  'draw focus rectangle
							End If
						Else
							FillRect lpdis->hDC, @lpdis->rcItem, Brush.Handle ' GetSysColorBrush(COLOR_WINDOW)
							SetBkColor lpdis->hDC, Brush.Color 'GetSysColor(COLOR_WINDOW)                    'Set text Background
							SetTextColor lpdis->hDC, IIf(g_darkModeEnabled, darkTextColor, GetSysColor(COLOR_WINDOWTEXT))                'Set text color
							If CInt(ItemIndex = -1) AndAlso CInt(lpdis->itemID = 0) AndAlso CInt(Focused) Then
								rc.Left   = lpdis->rcItem.Left + 16 : rc.Right = lpdis->rcItem.Right              '  Set cordinates
								rc.Top    = lpdis->rcItem.Top
								rc.Bottom = lpdis->rcItem.Bottom
								'DrawFocusRect lpdis->hDC, @rc  'draw focus rectangle
							End If
						End If
						'DRAW TEXT
						SendMessage Message.hWnd, LB_GETTEXT, lpdis->itemID, Cast(LPARAM, @zTxt)                  'Get text
						TextOut lpdis->hDC, lpdis->rcItem.Left + 18, lpdis->rcItem.Top + 2, @zTxt, Len(zTxt)     'Draw text
						'DRAW CHECKBOX
						rc.Left   = lpdis->rcItem.Left + 2 : rc.Right = lpdis->rcItem.Left + 15               'Set cordinates
						rc.Top    = lpdis->rcItem.Top + 2
						rc.Bottom = lpdis->rcItem.Bottom - 1
						fTheme = OpenThemeData(FHandle, "BUTTON")
						If fTheme Then
							If SendMessage(Message.hWnd, LB_GETITEMDATA, lpdis->itemID, 0) Then 'checked or not? itemdata knows Then
								DrawThemeBackground(fTheme, lpdis->hDC, BP_CHECKBOX, CBS_CHECKEDNORMAL, @rc, 0)
							Else
								DrawThemeBackground(fTheme, lpdis->hDC, BP_CHECKBOX, CBS_UNCHECKEDNORMAL, @rc, 0)
							End If
						Else
							If SendMessage(Message.hWnd, LB_GETITEMDATA, lpdis->itemID, 0) Then 'checked or not? itemdata knows Then
								DrawFrameControl lpdis->hDC, @rc, DFC_BUTTON, DFCS_BUTTONCHECK Or DFCS_CHECKED
							Else
								DrawFrameControl lpdis->hDC, @rc, DFC_BUTTON, DFCS_BUTTONCHECK
							End If
						End If
						CloseThemeData(fTheme)
						Message.Result = True : Exit Sub
					Case ODA_FOCUS
						'DrawFocusRect lpdis->hDC, @lpdis->rcItem  'draw focus rectangle
						Message.Result = True : Exit Sub
					End Select
				End If
			Case WM_LBUTTONDOWN
				If Message.wParam = MK_LBUTTON  Then                                            'respond to mouse click
					pt.X = LoWord(Message.lParam) : pt.Y = HiWord(Message.lParam)                       'get cursor pos
					t = SendMessage(Message.hWnd, LB_ITEMFROMPOINT, 0, MAKELONG(pt.X, pt.Y))    'get sel. item
					SendMessage Message.hWnd, LB_GETITEMRECT, t, Cast(LPARAM, @rc)                            'get sel. item's rect
					rc.Left   = rc.Left + 2 : rc.Right = rc.Left + 15                                       'checkbox cordinates
					If PtInRect(@rc, pt) Then
						itd = Not CBool(SendMessage(Message.hWnd, LB_GETITEMDATA, t, 0))                 'get toggled item data
						SendMessage Message.hWnd, LB_SETITEMDATA, t, itd                            'set toggled item data
						InvalidateRect Message.hWnd, @rc, 0 : UpdateWindow Message.hWnd                     'update sel. item only
					End If
				End If
'			Case WM_PAINT
'				'Message.Result = 0
'			Case CM_CTLCOLOR
'				Static As HDC Dc
'				Dc = Cast(HDC,Message.wParam)
'				SetBKMode Dc, TRANSPARENT
'				SetTextColor Dc, Font.Color
'				SetBKColor Dc, This.BackColor
'				SetBKMode Dc, OPAQUE
'			Case CM_COMMAND
'				Select Case Message.wParamHi
'				Case LBN_SELCHANGE
'					If SelectionMode = SelectionModes.smMultiSimple Or SelectionMode = SelectionModes.smMultiExtended Then
'						FSelCount = Perform(LB_GETSELCOUNT,0,0)
'						If FSelCount Then
'							Dim As Integer AItems(FSelCount)
'							Perform(LB_GETSELITEMS,FSelCount,CInt(@AItems(0)))
'							SelItems = @AItems(0)
'						End If
'					End If
'					If OnChange Then OnChange(This)
'				Case LBN_DBLCLK
'					If OnDblClick Then OnDblClick(This)
'				End Select
'			Case CM_MEASUREITEM
'				Dim As MEASUREITEMSTRUCT Ptr miStruct
'				Dim As Integer ItemID
'				miStruct = Cast(MEASUREITEMSTRUCT Ptr,Message.lParam)
'				ItemID = Cast(Integer,miStruct->itemID)
'				If OnMeasureItem Then
'					OnMeasureItem(This,itemID,miStruct->itemHeight)
'				Else
'					miStruct->itemHeight = ItemHeight
'				End If
'			Case CM_DRAWITEM
'				Dim As DRAWITEMSTRUCT Ptr diStruct
'				Dim As Integer ItemID,State
'				Dim As Rect R
'				Dim As HDC Dc
'				diStruct = Cast(DRAWITEMSTRUCT Ptr,Message.lParam)
'				ItemID = Cast(Integer,diStruct->itemID)
'				State = Cast(Integer,diStruct->itemState)
'				R = Cast(Rect,diStruct->rcItem)
'				Dc = diStruct->hDC
'				If OnDrawItem Then
'					OnDrawItem(This,ItemID,State,R,Dc)
'				Else
'					If (State And ODS_SELECTED) = ODS_SELECTED Then
'						Static As HBRUSH B
'						If B Then DeleteObject B
'						B = CreateSolidBrush(&H800000)
'						FillRect Dc,@R,B
'						R.Left += 2
'						SetTextColor Dc,clHighlightText
'						SetBKColor Dc,&H800000
'						DrawText(Dc,Item(ItemID),Len(Item(ItemID)),@R,DT_SINGLELINE Or DT_VCENTER Or DT_NOPREFIX)
'					Else
'						FillRect Dc, @R, Brush.Handle
'						R.Left += 2
'						SetTextColor Dc, Font.Color
'						SetBKColor Dc, This.BackColor
'						DrawText(Dc,Item(ItemID),Len(Item(ItemID)),@R,DT_SINGLELINE Or DT_VCENTER Or DT_NOPREFIX)
'					End If
'				End If
			Case WM_CHAR
				If Message.wParam = 32 Then Checked(ItemIndex) = Not Checked(ItemIndex): This.Repaint
				If OnKeyPress Then OnKeyPress(This, LoByte(Message.wParam))
'			Case WM_KEYDOWN
'				If OnKeyDown Then OnKeyDown(This,Message.wParam,Message.wParam And &HFFFF)
'			Case WM_KEYUP
'				If OnKeyUp Then OnKeyUp(This,Message.wParam,Message.wParam And &HFFFF)
			End Select
			Base.ProcessMessage(Message)
		End Sub
	#endif
	
	
	Private Sub CheckedListBox.SaveToFile(ByRef FileName As WString)
		Dim As Integer F, i
		Dim As WString Ptr s
		F = FreeFile
		Open FileName For Output Encoding "utf-8" As #F
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
		Deallocate s
	End Sub
	
	Private Sub CheckedListBox.LoadFromFile(ByRef FileName As WString)
		Dim As Integer F, i
		Dim As WString * 1024 s
		F = FreeFile
		This.Clear
		Open FileName For Input Encoding "utf-8" As #F
		While Not EOF(F)
			Line Input #F, s
			#ifdef __USE_GTK__
				AddItem s
			#else
				Perform(LB_ADDSTRING, 0, CInt(@s))
			#endif
		Wend
		Close #F
	End Sub
	
	#ifdef __USE_GTK__
		Private Sub CheckedListBox.Check(cell As GtkCellRendererToggle Ptr, path As gchar Ptr, model As GtkListStore Ptr)
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
	
	Private Constructor CheckedListBox
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
		#endif
		FCtl3D             = False
		Base.FBorderStyle       = 1
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
				.ExStyle     = WS_EX_CLIENTEDGE
				Base.Base.Style       = WS_CHILD Or WS_VSCROLL Or WS_HSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or LBS_DISABLENOSCROLL Or LBS_OWNERDRAWFIXED
				.BackColor       = GetSysColor(COLOR_WINDOW)
				.OnHandleIsAllocated = @HandleIsAllocated
				.DoubleBuffered = True
			#endif
			.Width       = 121
			.Height      = 17
		End With
	End Constructor
	
	Private Destructor CheckedListBox
		'If Items Then DeAllocate Items
	End Destructor
End Namespace
