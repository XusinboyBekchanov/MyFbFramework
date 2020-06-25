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
	Function ComboBoxEdit.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "sort": Return @FSort
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function ComboBoxEdit.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "sort": This.Sort = QBoolean(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Sub ComboBoxEdit.ShowDropDown(Value As Boolean)
		#ifdef __USE_GTK__
			gtk_combo_box_popup(gtk_combo_box(widget))
		#else
			Perform CB_SHOWDROPDOWN, Value, 0
		#endif
	End Sub
	
	#ifndef __USE_GTK__
		Function ComboBoxEdit.WindowProc(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
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
	
	Sub ComboBoxEdit.RegisterClass
		#ifndef __USE_GTK__
			Control.RegisterClass "ComboBoxEdit", "ComboBox", @WindowProc
		#endif
	End Sub
	
	Property ComboBoxEdit.SelColor As Integer
		Return FSelColor
	End Property
	
	Property ComboBoxEdit.SelColor(Value As Integer)
		FSelColor = Value
		Invalidate
	End Property
	
	Property ComboBoxEdit.Style As ComboBoxEditStyle
		Return FStyle
	End Property
	
	Property ComboBoxEdit.Style(Value As ComboBoxEditStyle)
		If Value <> FStyle Then
			FStyle = Value
			#ifdef __USE_GTK__
				If FStyle <= 1 Then
					widget = DropDownWidget
				Else
					widget = DropDownListWidget
				End If
			#else
				Base.Style = WS_CHILD Or WS_VSCROLL Or CBS_HASSTRINGS Or CBS_AUTOHSCROLL Or AStyle(Abs_(FStyle)) Or ASortStyle(Abs_(FSort)) Or AIntegralHeight(Abs_(FIntegralHeight))
			#endif
		End If
	End Property
	
	Property ComboBoxEdit.DropDownCount As Integer
		Return FDropDownCount
	End Property
	
	Property ComboBoxEdit.DropDownCount(Value As Integer)
		FDropDownCount = Value
	End Property
	
	Property ComboBoxEdit.IntegralHeight As Boolean
		Return FIntegralHeight
	End Property
	
	Property ComboBoxEdit.IntegralHeight(Value As Boolean)
		FIntegralHeight = Value
		#ifndef __USE_GTK__
			Base.Style = WS_CHILD Or WS_VSCROLL Or CBS_HASSTRINGS Or CBS_AUTOHSCROLL Or AStyle(Abs_(FStyle)) Or ASortStyle(Abs_(FSort)) Or AIntegralHeight(Abs_(FIntegralHeight))
		#endif
	End Property
	
	Property ComboBoxEdit.ItemCount As Integer
		#ifndef __USE_GTK__
			If Handle Then
				Return Perform(CB_GETCOUNT,0,0)
			End If
		#endif
		Return Items.Count
	End Property
	
	Property ComboBoxEdit.ItemCount(Value As Integer)
	End Property
	
	Property ComboBoxEdit.ItemHeight As Integer
		Return FItemHeight
	End Property
	
	Property ComboBoxEdit.ItemHeight(Value As Integer)
		FItemHeight = Value
		#ifndef __USE_GTK__
			If Handle Then
				If Style <> cbOwnerDrawVariable  Then
					Perform(CB_SETITEMHEIGHT, 0, FItemHeight)
				End If
			End If
		#endif
	End Property
	
	Property ComboBoxEdit.ItemIndex As Integer
		#ifdef __USE_GTK__
			If widget Then FItemIndex = gtk_combo_box_get_active (Gtk_Combo_Box(widget))
		#else
			If Handle Then FItemIndex = Perform(CB_GETCURSEL, 0, 0)
		#endif
		Return FItemIndex
	End Property
	
	Property ComboBoxEdit.ItemIndex(Value As Integer)
		FItemIndex = Value
		#ifdef __USE_GTK__
			If widget Then gtk_combo_box_set_active (Gtk_Combo_Box(widget), Value)
		#else
			If Handle Then Perform(CB_SETCURSEL, FItemIndex, 0)
		#endif
	End Property
	
	Property ComboBoxEdit.Text ByRef As WString
		If FStyle = cbDropDownList Then
			FText = This.Item(This.ItemIndex)
		Else
			#ifdef __USE_GTK__
				FText = WStr(*gtk_combo_box_text_get_active_text(gtk_combo_box_text(widget)))
			#else
				Base.Text
			#endif
		End If
		Return *FText.vptr
	End Property
	
	Property ComboBoxEdit.Text(ByRef Value As WString)
		Base.Text = Value
		#ifdef __USE_GTK__
			If widget Then gtk_combo_box_set_active (Gtk_Combo_Box(widget), IndexOf(Value))
		#else
			If FHandle Then Perform(CB_SELECTSTRING, -1, CInt(FText.vptr))
		#endif
	End Property
	
	Property ComboBoxEdit.Sort As Boolean
		Return FSort
	End Property
	
	Property ComboBoxEdit.Sort(Value As Boolean)
		If Value <> FSort Then
			FSort = Value
			#ifndef __USE_GTK__
				ChangeStyle CBS_SORT, Value
				'Base.Style = WS_CHILD OR WS_VSCROLL OR CBS_HASSTRINGS OR CBS_AUTOHSCROLL OR AStyle(Abs_(FStyle)) OR ASortStyle(Abs_(FSort)) OR AIntegralHeight(Abs_(FIntegralHeight))
			#endif
		End If
	End Property
	
	Property ComboBoxEdit.Object(FIndex As Integer) As Any Ptr
		Return Items.Object(FIndex)
	End Property
	
	Property ComboBoxEdit.Object(FIndex As Integer, Obj As Any Ptr)
		Items.Object(FIndex) = Obj
	End Property
	
	Property ComboBoxEdit.Item(FIndex As Integer) ByRef As WString
		Dim As Integer L
		#ifndef __USE_GTK__
			If Handle Then
				L = Perform(CB_GETLBTEXTLEN, FIndex, 0)
				WReallocate FItemText, L
				Perform(CB_GETLBTEXT, FIndex, CInt(FItemText))
				Return *FItemText
			Else
				WLet FItemText, Items.Item(FIndex)
				Return *FItemText
			End If
		#else
			WLet FItemText, Items.Item(FIndex)
			Return *FItemText
		#endif
	End Property
	
	Property ComboBoxEdit.Item(FIndex As Integer, ByRef FItem As WString)
		Items.Item(FIndex) = FItem
	End Property
	
	Sub ComboBoxEdit.UpdateListHeight
		If Style <> cbSimple Then
			#ifndef __USE_GTK__
				MoveWindow Handle, FLeft, FTop, FWidth, FHeight + (ItemHeight * ItemCount), 1
			#endif
		End If
	End Sub
	
	Sub ComboBoxEdit.AddItem(ByRef FItem As WString)
		Items.Add(FItem)
		#ifdef __USE_GTK__
			If widget Then
				gtk_combo_box_text_append_text(gtk_combo_box_text(widget), ToUtf8(FItem))
			End If
		#else
			If FHandle Then
				Perform(CB_ADDSTRING, 0, CInt(@FItem))
				UpdateListHeight
			End If
		#endif
	End Sub
	
	Sub ComboBoxEdit.AddObject(ByRef ObjName As WString, Obj As Any Ptr)
		Items.Add(ObjName, Obj)
		#ifdef __USE_GTK__
			If widget Then
				gtk_combo_box_text_append_text(gtk_combo_box_text(widget), ToUtf8(ObjName))
			End If
		#else
			If FHandle Then
				Perform(CB_ADDSTRING, 0, CInt(@ObjName))
				UpdateListHeight
			End If
		#endif
	End Sub
	
	Sub ComboBoxEdit.RemoveItem(FIndex As Integer)
		Items.Remove(FIndex)
		#ifdef __USE_GTK__
			If Widget Then
				gtk_combo_box_text_remove(gtk_combo_box_text(widget), FIndex)
			End If
		#else
			If FHandle Then
				Perform(CB_DELETESTRING, FIndex, 0)
				UpdateListHeight
			End If
		#endif
	End Sub
	
	Sub ComboBoxEdit.InsertItem(FIndex As Integer, ByRef FItem As WString)
		Items.Insert(FIndex, FItem)
		#ifdef __USE_GTK__
			gtk_combo_box_text_insert_text(gtk_combo_box_text(widget), FIndex, ToUtf8(FItem))
		#else
			If FHandle Then
				Perform(CB_INSERTSTRING, FIndex, CInt(@FItem))
				UpdateListHeight
			End If
		#endif
	End Sub
	
	Sub ComboBoxEdit.InsertObject(FIndex As Integer, ByRef ObjName As WString, Obj As Any Ptr)
		Items.Insert(FIndex, ObjName, Obj)
		#ifdef __USE_GTK__
			gtk_combo_box_text_insert_text(gtk_combo_box_text(widget), FIndex, ToUtf8(ObjName))
		#else
			If FHandle Then
				Perform(CB_INSERTSTRING, FIndex, CInt(@ObjName))
				UpdateListHeight
			End If
		#endif
	End Sub
	
	Function ComboBoxEdit.IndexOf(ByRef FItem As WString) As Integer
		Return Items.IndexOf(FItem) ' Perform(CB_FINDSTRING, -1, CInt(@FItem))
	End Function
	
	Function ComboBoxEdit.Contains(ByRef FItem As WString) As Boolean
		Return IndexOf(FItem) <> -1
	End Function
	
	Function ComboBoxEdit.IndexOfObject(Obj As Any Ptr) As Integer
		Return Items.IndexOfObject(Obj)
	End Function
	
	#ifndef __USE_GTK__
		Function ComboBoxEdit.SubClassProc(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
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
		
		Sub ComboBoxEdit.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QComboBoxEdit(Sender.Child)
					.GetChilds
					If .Style <> cbOwnerDrawVariable Then
						.Perform(CB_SETITEMHEIGHT, 0, .ItemHeight)
					End If
					.UpdateListHeight
					Dim As Integer i
					For i = 0 To .Items.Count - 1
						Dim As WString Ptr s = CAllocate((Len(.Items.Item(i)) + 1) * SizeOf(WString))
						*s = .Items.Item(i)
						.Perform(CB_ADDSTRING, 0, CInt(s))
					Next i
					.ItemIndex = .FItemIndex
					.Text = .FText
					If .FEditHandle <> 0 Then
						SetWindowLongPtr(.FEditHandle, GWLP_USERDATA, CInt(.Child))
						.lpfnEditWndProc = Cast(Any Ptr, SetWindowLongPtr(.FEditHandle, GWLP_WNDPROC, CInt(@SubClassProc)))
					End If
				End With
			End If
		End Sub
	#endif
	
	Sub ComboBoxEdit.GetChilds
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
	
	Sub ComboBoxEdit.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Select Case Message.Msg
			Case WM_NCCREATE
				
			Case WM_CREATE
				
			Case WM_PAINT
				Message.Result = 0
			Case CM_CTLCOLOR
				Dim As HDC Dc
				Dc = Cast(HDC, Message.wParam)
				SetBKMode Dc, TRANSPARENT
				SetTextColor Dc, Font.Color
				SetBKColor Dc, This.BackColor
				SetBKMode Dc, OPAQUE
			Case CM_CANCELMODE
				If Message.Sender <> This Then Perform(CB_SHOWDROPDOWN, 0, 0)
			Case CM_COMMAND
				Select Case Message.wParamHi
				Case CBN_SELCHANGE
					If OnChange Then OnChange(This)
				Case CBN_SELENDOK
					If OnSelected Then OnSelected(This, ItemIndex)
				Case CBN_SELENDCANCEL
					If OnSelectCanceled Then OnSelectCanceled(This)
				Case CBN_EDITCHANGE
				Case CBN_EDITUPDATE
				Case CBN_CLOSEUP
					If OnCloseUp Then OnCloseUp(This)
				Case CBN_DROPDOWN
					If IntegralHeight = False Then
						If Items.Count Then
							SetWindowPos(Handle, 0, 0, 0, FWidth, ItemHeight * DropDownCount + Height + 2 , SWP_NOMOVE Or SWP_NOZORDER Or SWP_NOACTIVATE Or SWP_NOREDRAW Or SWP_HIDEWINDOW)
						Else
							SetWindowPos(Handle, 0, 0, 0, FWidth, ItemHeight + Height + 2 , SWP_NOMOVE Or SWP_NOZORDER Or SWP_NOACTIVATE Or SWP_NOREDRAW Or SWP_HIDEWINDOW)
						End If
						SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE Or SWP_NOZORDER Or SWP_NOACTIVATE Or SWP_NOREDRAW Or SWP_SHOWWINDOW)
					End If
					If OnDropDown Then OnDropDown(This)
				Case CBN_DBLCLK
					If OnDblClick Then OnDblClick(This)
				End Select
			Case CM_MEASUREITEM
				Dim As MEASUREITEMSTRUCT Ptr miStruct
				Dim As Integer ItemID
				miStruct = Cast(MEASUREITEMSTRUCT Ptr,Message.lParam)
				ItemID = Cast(Integer,miStruct->itemID)
				If OnMeasureItem Then
					OnMeasureItem(This, itemID,miStruct->itemHeight)
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
				If (diStruct->itemState And ODS_COMBOBOXEDIT) <> 0 Then State = State Or ODS_ComboBOXEDIT
				If (diStruct->itemState And ODS_DEFAULT) <> 0 Then State = State Or ODS_DEFAULT
				If OnDrawItem Then
					OnDrawItem(This,ItemID,State,R,Dc)
				Else
					If (State And ODS_SELECTED) = ODS_SELECTED Then
						Static As HBRUSH B
						If B Then DeleteObject B
						B = CreateSolidBrush(FSelColor)
						FillRect Dc, @R, B
						SetTextColor Dc, clHighlightText
						SetBKColor Dc, FSelColor
						TextOut(Dc,R.Left + 2, R.Top, Item(ItemID),Len(Item(ItemID)))
						If (State And ODS_FOCUS) = ODS_FOCUS Then DrawFocusRect(DC, @R)
					Else
						FillRect Dc, @R, Brush.Handle
						SetTextColor Dc, Font.Color
						SetBKColor Dc, This.BackColor
						TextOut(Dc, R.Left + 2, R.Top, Item(ItemID), Len(Item(ItemID)))
					End If
				End If
			Case WM_CHAR
				If OnKeyPress Then OnKeyPress(This, LoByte(Message.wParam), Message.wParam And &HFFFF)
			Case WM_KEYDOWN
				If OnKeyDown Then OnKeyDown(This, Message.wParam, Message.wParam And &HFFFF)
			Case WM_KEYUP
				If OnKeyUp Then OnKeyUp(This, Message.wParam, Message.wParam And &HFFFF)
			End Select
		#endif
		Base.ProcessMessage(message)
	End Sub
	
	Sub ComboBoxEdit.Clear
		ItemCount = 0
		Items.Clear
		#ifdef __USE_GTK__
			#ifdef __USE_GTK3__
				gtk_combo_box_text_remove_all(gtk_combo_box_text(widget))
			#else
				Dim As GtkListStore Ptr store
				store = GTK_LIST_STORE (gtk_combo_box_get_model (GTK_COMBO_BOX (widget)))
				gtk_list_store_clear (store)
			#endif
		#else
			Perform(CB_RESETCONTENT, 0, 0)
		#endif
	End Sub
	
	Sub ComboBoxEdit.SaveToFile(ByRef File As WString)
		Dim As Integer F, i
		Dim As WString Ptr s
		F = FreeFile
		Open File For Binary Access Write As #F
		For i = 0 To ItemCount -1
			#ifndef __USE_GTK__
				Dim TextLen As Integer = Perform(CB_GETLBTEXTLEN, i, 0)
				s = CAllocate((TextLen + 1) * SizeOf(WString))
				*s = WSpace(TextLen)
				Perform(CB_GETLBTEXT, i, CInt(s))
				Print #F, *s
			#endif
		Next i
		Close #F
	End Sub
	
	Sub ComboBoxEdit.LoadFromFile(ByRef File As WString)
		Dim As Integer F, i
		Dim As WString Ptr s
		F = FreeFile
		Clear
		Open File For Binary Access Read As #F
		s = CAllocate((LOF(F) + 1) * SizeOf(WString))
		While Not EOF(F)
			Line Input #F, *s
			#ifndef __USE_GTK__
				Perform(CB_ADDSTRING, 0, CInt(s))
			#endif
		Wend
		Close #F
	End Sub
	
	Operator ComboBoxEdit.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Sub ComboBoxEdit_Popup(widget As GtkComboBox Ptr, user_data As Any Ptr)
			Dim As ComboBoxEdit Ptr cbo = user_data
			If cbo->OnDropdown Then cbo->OnDropdown(*cbo)
		End Sub
		
		Function ComboBoxEdit_Popdown(widget As GtkComboBox Ptr, user_data As Any Ptr) As Boolean
			Dim As ComboBoxEdit Ptr cbo = user_data
			If cbo->OnCloseUp Then cbo->OnCloseUp(*cbo)
			Return False
		End Function
		
		Sub ComboBoxEdit_Changed(widget As GtkComboBox Ptr, user_data As Any Ptr)
			Dim As ComboBoxEdit Ptr cbo = user_data
			If cbo->OnSelected Then cbo->OnSelected(*cbo, cbo->ItemIndex)
			If cbo->OnChange Then cbo->OnChange(*cbo)
		End Sub
		
		Sub ComboBoxEdit.Entry_Activate(entry As GtkEntry Ptr, user_data As Any Ptr)
			Dim As ComboBoxEdit Ptr cbo = user_data
			Dim As Control Ptr btn = cbo->GetForm()->FDefaultButton
			If btn AndAlso btn->OnClick Then btn->OnClick(*btn)
		End Sub
	#endif
	
	Constructor ComboBoxEdit
		#ifdef __USE_GTK__
			DropDownWidget = gtk_combo_box_text_new_with_entry()
			DropDownListWidget = gtk_combo_box_text_new()
			widget = DropDownListWidget
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
		ItemHeight          = 13
		FDropDownCount      = 8
		FSelColor           = &H800000
		FIntegralHeight     = 0
		FItemIndex          = -1
		FTabStop            = True
		'Items.Parent        = @This
		With This
			.Child          = @This
			'.ChildProc     = @WindowProc
			'ComboBoxEdit.RegisterClass
			WLet FClassName, "ComboBoxEdit"
			WLet FClassAncestor, "ComboBox"
			#ifndef __USE_GTK__
				Base.RegisterClass "ComboBoxEdit", "ComboBox"
				.ExStyle       = 0
				Base.Style     = WS_CHILD Or WS_VSCROLL Or WS_TABSTOP Or CBS_HASSTRINGS Or CBS_AUTOHSCROLL Or AStyle(Abs_(FStyle)) Or ASortStyle(Abs_(FSort)) Or AIntegralHeight(Abs_(FIntegralHeight))
				.BackColor         = GetSysColor(COLOR_WINDOW)
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
	
	Destructor ComboBoxEdit
		WDeallocate FItemText
		#ifdef __USE_GTK__
			If gtk_is_widget(DropDownWidget) Then
				gtk_widget_destroy(DropDownWidget)
				DropDownWidget = 0
			End If
			If gtk_is_widget(DropDownListWidget) Then
				gtk_widget_destroy(DropDownListWidget)
				DropDownListWidget = 0
			End If
			Widget = 0
			'			If This.Parent AndAlso This.Parent->Widget Then
			'				gtk_container_remove(gtk_container(This.Parent->Widget), gtk_widget(Widget))
			'			End If
		#else
			UnregisterClass "ComboBoxEdit", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
