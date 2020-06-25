'###############################################################################
'#  ListControl.bi                                                             #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TListBox.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.2.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "ListControl.bi"

Namespace My.Sys.Forms
	Property ListControl.MultiSelect As Boolean
		Return FMultiselect
	End Property
	
	Property ListControl.MultiSelect(Value As Boolean)
		'TODO: GTK_SELECTION_NONE, GTK_SELECTION_BROWSE
		If Value <> FMultiselect Then
			FMultiselect = Value
			#ifdef __USE_GTK__
				#ifdef __USE_GTK3__
					gtk_list_box_set_selection_mode(gtk_list_box(widget), IIf(FMultiSelect, GTK_SELECTION_MULTIPLE, GTK_SELECTION_SINGLE))
				#else
					gtk_list_set_selection_mode(gtk_list(widget), IIf(FMultiSelect, GTK_SELECTION_MULTIPLE, GTK_SELECTION_SINGLE))
				#endif
			#else
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD Or WS_HSCROLL Or WS_VSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or AStyle(Abs_(FStyle)) Or ABorderStyle(Abs_(FBorderStyle)) Or ASortStyle(Abs_(FSort)) Or AMultiselect(Abs_(FMultiselect)) Or AExtendSelect(Abs_(FExtendSelect)) Or AMultiColumns(Abs_(FColumns)) Or AIntegralHeight(Abs_(FIntegralHeight))
			#endif
		End If
	End Property
	
	Property ListControl.ExtendSelect As Boolean
		Return FExtendSelect
	End Property
	
	Property ListControl.ExtendSelect(Value As Boolean)
		If Value <> FExtendSelect Then
			FExtendSelect = Value
			#ifdef __USE_GTK__
				#ifndef __USE_GTK3__
					gtk_list_set_selection_mode(gtk_list(widget), IIf(FExtendSelect, GTK_SELECTION_MULTIPLE, GTK_SELECTION_EXTENDED))
				#endif
			#else
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD Or WS_HSCROLL Or WS_VSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or AStyle(Abs_(FStyle)) Or ABorderStyle(Abs_(FBorderStyle)) Or ASortStyle(Abs_(FSort)) Or AMultiselect(Abs_(FMultiselect)) Or AExtendSelect(Abs_(FExtendSelect)) Or AMultiColumns(Abs_(FColumns)) Or AIntegralHeight(Abs_(FIntegralHeight))
			#endif
		End If
	End Property
	
	Property ListControl.Columns As Integer
		Return FColumns
	End Property
	
	Property ListControl.Columns(Value As Integer)
		If Value <> FColumns Then
			FColumns = Value
			#ifndef __USE_GTK__
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD Or WS_HSCROLL Or WS_VSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or AStyle(Abs_(FStyle)) Or ABorderStyle(Abs_(FBorderStyle)) Or ASortStyle(Abs_(FSort)) Or AMultiselect(Abs_(FMultiselect)) Or AExtendSelect(Abs_(FExtendSelect)) Or AMultiColumns(Abs_(FColumns)) Or AIntegralHeight(Abs_(FIntegralHeight))
			#endif
		End If
	End Property
	
	Property ListControl.IntegralHeight As Boolean
		Return FIntegralHeight
	End Property
	
	Property ListControl.IntegralHeight(Value As Boolean)
		If Value <> FIntegralHeight Then
			FIntegralHeight = Value
			#ifndef __USE_GTK__
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD Or WS_HSCROLL Or WS_VSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or AStyle(Abs_(FStyle)) Or ABorderStyle(ABs_(FBorderStyle)) Or ASortStyle(Abs_(FSort)) Or AMultiselect(Abs_(FMultiselect)) Or AExtendSelect(Abs_(FExtendSelect)) Or AMultiColumns(Abs_(FColumns)) Or AIntegralHeight(Abs_(FIntegralHeight))
			#endif
		End If
	End Property
	
	Property ListControl.Style As ListControlStyle
		Return FStyle
	End Property
	
	Property ListControl.Style(Value As ListControlStyle)
		If Value <> FStyle Then
			FStyle = Value
			#ifndef __USE_GTK__
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD Or WS_HSCROLL Or WS_VSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or AStyle(Abs_(FStyle)) Or ABorderStyle(Abs_(FBorderStyle)) Or ASortStyle(Abs_(FSort)) Or AMultiselect(Abs_(FMultiselect)) Or AExtendSelect(Abs_(FExtendSelect)) Or AMultiColumns(Abs_(FColumns)) Or AIntegralHeight(Abs_(FIntegralHeight))
			#endif
		End If
	End Property
	
	Property ListControl.Ctl3D As Boolean
		Return FCtl3D
	End Property
	
	Property ListControl.Ctl3D(Value As Boolean)
		If Value <> FCtl3D Then
			FCtl3D = Value
			#ifndef __USE_GTK__
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD Or WS_HSCROLL Or WS_VSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or AStyle(Abs_(FStyle)) Or ABorderStyle(Abs_(FBorderStyle)) Or ASortStyle(Abs_(FSort)) Or AMultiselect(Abs_(FMultiselect)) Or AExtendSelect(Abs_(FExtendSelect)) Or AMultiColumns(Abs_(FColumns)) Or AIntegralHeight(Abs_(FIntegralHeight))
			#endif
		End If
	End Property
	
	Property ListControl.BorderStyle As Integer
		Return FBorderStyle
	End Property
	
	Property ListControl.BorderStyle(Value As Integer)
		If Value <> FBorderStyle Then
			FBorderStyle = Value
			#ifndef __USE_GTK__
				ExStyle = ABorderExStyle(Abs_(FCtl3D))
				Base.Style = WS_CHILD Or WS_HSCROLL Or WS_VSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or AStyle(Abs_(FStyle)) Or ABorderStyle(Abs_(FBorderStyle)) Or ASortStyle(Abs_(FSort)) Or AMultiselect(Abs_(FMultiselect)) Or AExtendSelect(Abs_(FExtendSelect)) Or AMultiColumns(Abs_(FColumns)) Or AIntegralHeight(Abs_(FIntegralHeight))
			#endif
		End If
	End Property
	
	Property ListControl.ItemCount As Integer
		#ifndef __USE_GTK__
			If Handle Then
				Return Perform(LB_GETCOUNT,0,0)
			End If
		#endif
		Return Items.Count
	End Property
	
	Property ListControl.ItemCount(Value As Integer)
	End Property
	
	Property ListControl.ItemHeight As Integer
		Return FItemHeight
	End Property
	
	Property ListControl.ItemHeight(Value As Integer)
		FItemHeight = Value
		#ifndef __USE_GTK__
			If Handle Then Perform(LB_SETITEMHEIGHT,0,MakeLParam(FItemHeight,0))
		#endif
	End Property
	
	Property ListControl.TopIndex As Integer
		Return FTopIndex
	End Property
	
	Property ListControl.TopIndex(Value As Integer)
		FTopIndex = Value
		#ifndef __USE_GTK__
			If Handle Then Perform(LB_SETTOPINDEX,FTopIndex,0)
		#endif
	End Property
	
	Property ListControl.ItemIndex As Integer
		#ifdef __USE_GTK__
			FItemIndex = -1
			#ifdef __USE_GTK3__
				Var row = gtk_list_box_get_selected_row(gtk_list_box(widget))
				If gtk_is_list_box_row(row) Then FItemIndex = gtk_list_box_row_get_index(gtk_list_box_get_selected_row(gtk_list_box(widget)))
			#else
				'FItemIndex = gtk_list_box_row_get_index(gtk_list_box(widget))
			#endif
		#else
			If Handle Then
				FItemIndex = Perform(LB_GETCURSEL, 0, 0)
			End If
		#endif
		Return FItemIndex
	End Property
	
	Property ListControl.ItemIndex(Value As Integer)
		FItemIndex = Value
		#ifdef __USE_GTK__
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
	
	Property ListControl.SelCount As Integer
		Return FSelCount
	End Property
	
	Property ListControl.SelCount(Value As Integer)
		FSelCount = Value
	End Property
	
	Property ListControl.SelItems As Integer Ptr
		Return FSelItems
	End Property
	
	Property ListControl.SelItems(Value As Integer Ptr)
		FSelItems = Value
	End Property
	
	Property ListControl.Text ByRef As WString
		#ifdef __USE_GTK__
			If widget Then
		#else
			If Handle Then
		#endif
			FText = Items.Item(ItemIndex)
		End If
		Return *FText.vptr
	End Property
	
	Property ListControl.Text(ByRef Value As WString)
		FText = Value
		#ifndef __USE_GTK__
			If FHandle Then Perform(LB_SELECTSTRING,-1,CInt(FText))
		#endif
	End Property
	
	Property ListControl.Sort As Boolean
		Return FSort
	End Property
	
	Property ListControl.Sort(Value As Boolean)
		If Value <> FSort Then
			FSort = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or WS_HSCROLL Or WS_VSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or AStyle(Abs_(FStyle)) Or ABorderStyle(Abs_(FBorderStyle)) Or ASortStyle(Abs_(FSort)) Or AMultiselect(Abs_(FMultiselect)) Or AExtendSelect(Abs_(FExtendSelect)) Or AMultiColumns(Abs_(FColumns)) Or AIntegralHeight(Abs_(FIntegralHeight))
			#endif
		End If
	End Property
	
	Property ListControl.Object(FIndex As Integer) As Any Ptr
		Return Items.Object(FIndex)
	End Property
	
	Property ListControl.Object(FIndex As Integer, Obj As Any Ptr)
		Items.Object(FIndex) = Obj
	End Property
	
	Property ListControl.Item(FIndex As Integer) ByRef As WString
		Dim As Integer L
		Dim As WString Ptr s
		#ifndef __USE_GTK__
			If FHandle Then
				L = Perform(LB_GETTEXTLEN, FIndex, 0)
				s = CAllocate((L + 1) * SizeOf(WString))
				*s = Space(L)
				Perform(LB_GETTEXT, FIndex, CInt(s))
				Return *s
			Else
				s = CAllocate((Len(Items.Item(FIndex)) + 1) * SizeOf(WString))
				*s = Items.Item(FIndex)
				Return *s
			End If
		#else
			s = CAllocate((Len(Items.Item(FIndex)) + 1) * SizeOf(WString))
			*s = Items.Item(FIndex)
			Return *s
		#endif
	End Property
	
	Property ListControl.Item(FIndex As Integer, ByRef FItem As WString)
		Items.Item(FIndex) = FItem
	End Property
	
	#ifdef __USE_GTK__
		#ifndef __USE_GTK3__
			Sub ListControl.ListItem_Selected(Item1 As GtkItem Ptr, user_data As Any Ptr)
				
			End Sub
		#endif
	#endif
	
	Sub ListControl.AddItem(ByRef FItem As WString)
		Items.Add(FItem)
		#ifdef __USE_GTK__
			If Widget Then
				#ifdef __USE_GTK3__
					Dim As GtkWidget Ptr lbl
					lbl = gtk_label_new(ToUtf8(FItem))
					gtk_label_set_xalign (GTK_LABEL (lbl), 0.0)
					gtk_container_add(GTK_CONTAINER(Widget), lbl)
				#else
					Dim As GtkWidget Ptr item1 = gtk_list_item_new_with_label(ToUtf8(FItem))
					'g_signal_connect(GTK_OBJECT(item1), "select", GTK_SIGNAL_FUNC (@ListItem_Selected), Items.Count - 1)
					gtk_container_add(GTK_CONTAINER(Widget), item1)
				#endif
			End If
		#else
			If Handle Then Perform(LB_ADDSTRING, 0, CInt(@FItem))
		#endif
	End Sub
	
	Sub ListControl.AddObject(ByRef ObjName As WString, Obj As Any Ptr)
		Items.Add(ObjName, Obj)
		#ifdef __USE_GTK__
			If Widget Then
				#ifdef __USE_GTK3__
					gtk_container_add(GTK_CONTAINER(Widget), gtk_label_new(ToUtf8(ObjName)))
				#else
					gtk_container_add(GTK_CONTAINER(Widget), gtk_list_item_new_with_label(ToUtf8(ObjName)))
				#endif
			End If
		#else
			If FHandle Then Perform(LB_ADDSTRING, 0, CInt(@ObjName))
		#endif
	End Sub
	
	Sub ListControl.RemoveItem(FIndex As Integer)
		Items.Remove(FIndex)
		#ifdef __USE_GTK__
			If Widget Then
				#ifdef __USE_GTK3__
					gtk_container_remove(gtk_container(widget), gtk_widget(gtk_list_box_get_row_at_index(gtk_list_box(widget), FIndex)))
				#else
					Dim As GList Ptr children
					Dim As GList Ptr childtoremove
					Dim As GtkWidget Ptr childwidget
					Dim As Integer n
					children = gtk_container_children(GTK_CONTAINER (widget))
					n = 0
					While (children)
						childwidget = GTK_WIDGET (children->data)
						gtk_container_remove(gtk_container(widget), childwidget)
						If n = FIndex Then
							g_list_append(childtoremove, childwidget)
							gtk_list_remove_items(gtk_list(widget), childtoremove)
							Exit While
						End If
						children = children->next
						n += 1
					Wend
				#endif
			End If
		#else
			If Handle Then Perform(LB_DELETESTRING, FIndex, 0)
		#endif
	End Sub
	
	Sub ListControl.InsertItem(FIndex As Integer, ByRef FItem As WString)
		Items.Insert(FIndex, FItem)
		#ifdef __USE_GTK__
			If Widget Then
				#ifdef __USE_GTK3__
					gtk_list_box_insert(gtk_list_box(widget), gtk_label_new(ToUtf8(FItem)), FIndex)
				#else
					Dim As GList Ptr list = NULL
					list = g_list_prepend(list, gtk_list_item_new_with_label(ToUtf8(FItem)))
					gtk_list_insert_items(gtk_list(widget), list, FIndex)
				#endif
			End If
		#else
			If Handle Then Perform(LB_INSERTSTRING, FIndex, CInt(@FItem))
		#endif
	End Sub
	
	Sub ListControl.InsertObject(FIndex As Integer, ByRef ObjName As WString, Obj As Any Ptr)
		Items.Insert(FIndex, ObjName, Obj)
		#ifdef __USE_GTK__
			If Widget Then
				#ifdef __USE_GTK3__
					gtk_list_box_insert(gtk_list_box(widget), gtk_label_new(ToUtf8(ObjName)), FIndex)
				#else
					Dim As GList Ptr list = NULL
					list = g_list_prepend(list, gtk_list_item_new_with_label(ToUtf8(ObjName)))
					gtk_list_insert_items(gtk_list(widget), list, FIndex)
				#endif
			End If
		#else
			If Handle Then Perform(LB_INSERTSTRING, FIndex, CInt(@ObjName))
		#endif
	End Sub
	
	Sub ListControl.Clear
		Items.Clear
		#ifdef __USE_GTK__
			#ifdef __USE_GTK3__
				Dim As GList Ptr children
				Dim As GtkWidget Ptr childwidget
				children = gtk_container_get_children(GTK_CONTAINER (widget))
				While (children)
					childwidget = GTK_WIDGET (children->data)
					gtk_container_remove(gtk_container(widget), childwidget)
					children = children->next
				Wend
			#else
				gtk_list_clear_items(gtk_list(widget), 0, -1)
			#endif
		#else
			Perform(LB_RESETCONTENT,0,0)
		#endif
	End Sub
	Function ListControl.IndexOf(ByRef FItem As WString) As Integer
		#ifndef __USE_GTK__
			Return Perform(LB_FINDSTRING, -1, CInt(FItem))
		#else
			Return -1
		#endif
	End Function
	
	Function ListControl.IndexOfObject(Obj As Any Ptr) As Integer
		Return Items.IndexOfObject(Obj)
	End Function
	
	#ifndef __USE_GTK__
		Sub ListControl.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QListControl(Sender.Child)
					For i As Integer = 0 To .Items.Count -1
						Dim As WString Ptr s = CAllocate((Len(.Items.Item(i)) + 1) * SizeOf(WString))
						*s = .Items.Item(i)
						.Perform(LB_ADDSTRING, 0, CInt(s))
					Next i
					.Perform(LB_SETITEMHEIGHT, 0, MakeLParam(.ItemHeight, 0))
					.Columns = .Columns
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
		
		Sub ListControl.WndProc(ByRef Message As Message)
		End Sub
	#else
		#ifdef __USE_GTK3__
			Sub ListControl.SelectionChanged(box As GtkListBox Ptr, user_data As Any Ptr)
				Dim As ListControl Ptr lst = Cast(Any Ptr, user_data)
				If lst Then
					If lst->OnChange Then lst->OnChange(*lst)
				End If
			End Sub
		#else
			Sub ListControl.SelectionChanged(list As GtkList Ptr, user_data As Any Ptr)
				Dim As ListControl Ptr lst = Cast(Any Ptr, user_data)
				If lst Then
					If lst->MultiSelect Then
						'						FSelCount = Perform(LB_GETSELCOUNT,0,0)
						'						If FSelCount Then
						'							Dim As Integer AItems(FSelCount)
						'							Perform(LB_GETSELITEMS,FSelCount,CInt(@AItems(0)))
						'							SelItems = @AItems(0)
						'						End If
					End If
					'lst->FItemIndex =
					If lst->OnChange Then lst->OnChange(*lst)
				End If
			End Sub
		#endif
	#endif
	
	Sub ListControl.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Select Case Message.Msg
			Case WM_PAINT
				Message.Result = 0
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
				If OnKeyPress Then OnKeyPress(This,LoByte(Message.wParam),Message.wParam And &HFFFF)
			Case WM_KEYDOWN
				If OnKeyDown Then OnKeyDown(This,Message.wParam,Message.wParam And &HFFFF)
			Case WM_KEYUP
				If OnKeyUp Then OnKeyUp(This,Message.wParam,Message.wParam And &HFFFF)
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Sub ListControl.SaveToFile(ByRef File As WString)
		Dim As Integer F, i
		Dim As WString Ptr s
		F = FreeFile
		Open File For Binary Access Write As #F
		For i = 0 To ItemCount - 1
			#ifndef __USE_GTK__
				Dim TextLen As Integer = Perform(LB_GETTEXTLEN, i, 0)
				s = CAllocate((Len(TextLen) + 1) * SizeOf(WString))
				*s = Space(TextLen)
				Perform(LB_GETTEXT, i, CInt(s))
				Print #F, *s
			#endif
		Next i
		Close #F
	End Sub
	
	Sub ListControl.LoadFromFile(ByRef File As WString)
		Dim As Integer F, i
		Dim As WString Ptr s
		F = FreeFile
		Clear
		Open File For Binary Access Read As #F
		s = CAllocate((LOF(F) + 1) * SizeOf(WString))
		While Not EOF(F)
			Line Input #F, *s
			#ifndef __USE_GTK__
				Perform(LB_ADDSTRING, 0, CInt(s))
			#endif
		Wend
		Close #F
	End Sub
	
	Operator ListControl.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Constructor ListControl
		With This
			#ifdef __USE_GTK__
				scrolledwidget = gtk_scrolled_window_new(NULL, NULL)
				gtk_scrolled_window_set_policy(gtk_scrolled_window(scrolledwidget), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
				#ifdef __USE_GTK3__
					widget = gtk_list_box_new()
					gtk_container_add(gtk_container(scrolledwidget), widget)
					g_signal_connect(gtk_list_box(widget), "selected-rows-changed", G_CALLBACK(@SelectionChanged), @This)
				#else
					widget = gtk_list_new()
					gtk_scrolled_window_add_with_viewport(gtk_scrolled_window(scrolledwidget), widget)
					g_signal_connect(gtk_list(widget), "selection-changed", G_CALLBACK(@SelectionChanged), @This)
				#endif
				.RegisterClass "ListControl", @This
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
			FTabStop           = True
			FBorderStyle       = 1
			'Items.Parent       = @This
			
			WLet FClassName, "ListControl"
			.Child       = @This
			#ifndef __USE_GTK__
				.RegisterClass "ListControl", "ListBox"
				WLet FClassAncestor, "ListBox"
				.ChildProc   = @WndProc
				.ExStyle     = ABorderExStyle(Abs_(FCtl3D))
				Base.Style       = WS_CHILD Or WS_HSCROLL Or WS_VSCROLL Or LBS_HASSTRINGS Or LBS_NOTIFY Or AStyle(Abs_(FStyle)) Or ABorderStyle(Abs_(FBorderStyle)) Or ASortStyle(Abs_(FSort)) Or AMultiselect(Abs_(FMultiselect)) Or AExtendSelect(Abs_(FExtendSelect)) Or AMultiColumns(Abs_(FColumns)) Or AIntegralHeight(Abs_(FIntegralHeight))
				.BackColor       = GetSysColor(COLOR_WINDOW)
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.Width       = 121
			.Height      = ScaleY(Font.Size /72*96+6)
		End With
	End Constructor
	
	Destructor ListControl
		'If Items Then DeAllocate Items
	End Destructor
End Namespace
