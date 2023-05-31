'###############################################################################
'#  ComboBoxEx.bi                                                              #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'#  Version 1.0.0                                                              #
'###############################################################################

#include once "ComboBoxEx.bi"

Namespace My.Sys.Forms
	Private Function ComboBoxItem.Index As Integer
		If Parent Then
			Return Cast(ComboBoxEx Ptr, Parent)->Items.IndexOf(@This)
		Else
			Return -1
		End If
	End Function
	
	Private Property ComboBoxItem.Text ByRef As WString
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
	
	Private Property ComboBoxItem.Text(ByRef Value As WString)
		WLet(FText, Value)
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				gtk_list_store_set (Cast(ComboBoxEx Ptr, Parent)->ListStore, @TreeIter, 1, ToUtf8(Value), -1)
			End If
		#else
			If Parent AndAlso Parent->Handle Then
				Dim cbei As COMBOBOXEXITEM
				cbei.mask = CBEIF_TEXT
				cbei.iItem = Index
				cbei.pszText    = FText
				cbei.cchTextMax = Len(*FText)
				SendMessage Parent->Handle, CBEM_SETITEM, 0, CInt(@cbei)
			End If
		#endif
	End Property
	
	Private Property ComboBoxItem.Object As Any Ptr
		Return FObject
	End Property
	
	Private Property ComboBoxItem.Object(Value As Any Ptr)
		FObject = Value
	End Property
	
	Private Property ComboBoxItem.Hint ByRef As WString
		Return WGet(FHint)
	End Property
	
	Private Property ComboBoxItem.Hint(ByRef Value As WString)
		WLet(FHint, Value)
	End Property
	
	
	Private Property ComboBoxItem.ImageIndex As Integer
		Return FImageIndex
	End Property
	
	Private Property ComboBoxItem.ImageIndex(Value As Integer)
		If Value <> FImageIndex Then
			FImageIndex = Value
			#ifndef __USE_GTK__
				If Parent AndAlso Parent->Handle Then
					Dim cbei As COMBOBOXEXITEM
					cbei.mask = CBEIF_IMAGE
					cbei.iItem = Index
					cbei.iImage = FImageIndex
					SendMessage Parent->Handle, CBEM_SETITEM, 0, CInt(@cbei)
				End If
			#endif
		End If
	End Property
	
	Private Property ComboBoxItem.ImageKey ByRef As WString
		Return WGet(FImageKey)
	End Property
	
	Private Property ComboBoxItem.ImageKey(ByRef Value As WString)
		WLet(FImageKey, Value)
		#ifdef __USE_GTK__
			If Parent AndAlso Parent->Handle Then
				gtk_list_store_set (Cast(ComboBoxEx Ptr, Parent)->ListStore, @TreeIter, 0, ToUtf8(Value), -1)
			End If
		#endif
	End Property
	
	Private Property ComboBoxItem.SelectedImageIndex As Integer
		Return FImageIndex
	End Property
	
	Private Property ComboBoxItem.SelectedImageIndex(Value As Integer)
		If Value <> FSelectedImageIndex Then
			FSelectedImageIndex = Value
			#ifndef __USE_GTK__
				If Parent AndAlso Parent->Handle Then
					Dim cbei As COMBOBOXEXITEM
					cbei.mask = CBEIF_SELECTEDIMAGE
					cbei.iItem = Index
					cbei.iSelectedImage = FSelectedImageIndex
					SendMessage Parent->Handle, CBEM_SETITEM, 0, CInt(@cbei)
				End If
			#endif
		End If
	End Property
	
	Private Property ComboBoxItem.OverlayIndex As Integer
		Return FImageIndex
	End Property
	
	Private Property ComboBoxItem.OverlayIndex(Value As Integer)
		If Value <> FOverlayIndex Then
			FOverlayIndex = Value
			#ifndef __USE_GTK__
				If Parent AndAlso Parent->Handle Then
					Dim cbei As COMBOBOXEXITEM
					cbei.mask = CBEIF_OVERLAY
					cbei.iItem = Index
					cbei.iOverlay = FOverlayIndex
					SendMessage Parent->Handle, CBEM_SETITEM, 0, CInt(@cbei)
				End If
			#endif
		End If
	End Property
	
	Private Property ComboBoxItem.Indent As Integer
		Return FIndent
	End Property
	
	Private Property ComboBoxItem.Indent(Value As Integer)
		If Value <> FIndent Then
			FIndent = Value
			#ifndef __USE_GTK__
				If Parent AndAlso Parent->Handle Then
					Dim cbei As COMBOBOXEXITEM
					cbei.mask = CBEIF_INDENT
					cbei.iItem = Index
					cbei.iIndent = FIndent
					SendMessage Parent->Handle, CBEM_SETITEM, 0, CInt(@cbei)
				End If
			#endif
		End If
	End Property
	
	Private Operator ComboBoxItem.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor ComboBoxItem
		FHint = 0 'CAllocate_(0)
		FText = 0 'CAllocate_(0)
		Text    = ""
		Hint       = ""
		FImageIndex = -1
		FSelectedImageIndex = -1
		FOverlayIndex = -1
	End Constructor
	
	Private Destructor ComboBoxItem
		If FHint Then Deallocate_( FHint)
		If FText Then Deallocate_( FText)
		If FImageKey Then Deallocate_( FImageKey)
	End Destructor
	
	Private Property ComboBoxExItems.Count As Integer
		Return FItems.Count
	End Property
	
	Private Property ComboBoxExItems.Count(Value As Integer)
	End Property
	
	Private Property ComboBoxExItems.Item(Index As Integer) As ComboBoxItem Ptr
		If Index > -1 AndAlso Index < FItems.Count Then Return QComboBoxItem(FItems.Items[Index]) Else Return 0
	End Property
	
	Private Property ComboBoxExItems.Item(Index As Integer, Value As ComboBoxItem Ptr)
		'QToolButton(FItems.Items[Index]) = Value
	End Property
	
	Private Function ComboBoxExItems.Add(ByRef FText As WString = "", Obj As Any Ptr = 0, FImageIndex As Integer = -1, FSelectedImageIndex As Integer = -1, FOverlayIndex As Integer = -1, FIndent As Integer = 0, Index As Integer = -1) As ComboBoxItem Ptr
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
			cbei.mask = CBEIF_IMAGE Or CBEIF_INDENT Or CBEIF_OVERLAY Or CBEIF_SELECTEDIMAGE Or CBEIF_TEXT
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
	
	Private Function ComboBoxExItems.Add(ByRef FText As WString = "", Obj As Any Ptr = 0, ByRef ImageKey As WString, ByRef SelectedImageKey As WString = "", ByRef OverlayKey As WString = "", Indent As Integer = 0, Index As Integer = -1) As ComboBoxItem Ptr
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
	
	Private Sub ComboBoxExItems.Remove(Index As Integer)
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
	
	Private Function ComboBoxExItems.IndexOf(ByRef FItem As ComboBoxItem Ptr) As Integer
		Return FItems.IndexOf(FItem)
	End Function
	
	Private Function ComboBoxExItems.IndexOf(ByRef Text As WString) As Integer
		For i As Integer = 0 To FItems.Count - 1
			If (*Cast(ComboBoxItem Ptr, FItems.Items[i])).Text = Text Then Return i
		Next i
		Return -1
	End Function
	
	Function ComboBoxExItems.IndexOfData(pData As Any Ptr) As Integer
		For i As Integer = 0 To FItems.Count - 1
			If (*Cast(ComboBoxItem Ptr, FItems.Items[i])).Object = pData Then Return i
		Next i
		Return -1
	End Function
	
	Private Function ComboBoxExItems.Contains(ByRef Text As WString) As Boolean
		Return IndexOf(Text) <> -1
	End Function
	
	Private Sub ComboBoxExItems.Clear
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
	
	Private Operator ComboBoxExItems.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor ComboBoxExItems
		This.Clear
	End Constructor
	
	Private Destructor ComboBoxExItems
		This.Clear
	End Destructor
	
	#ifndef ReadProperty_Off
		Private Function ComboBoxEx.ReadProperty(PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "imageslist": Return ImagesList
			Case "integralheight": Return @FIntegralHeight
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function ComboBoxEx.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "designmode": DesignMode = QBoolean(Value): If FDesignMode Then This.Items.Add *FName: This.ItemIndex = 0
			Case "imageslist": ImagesList = Value
			Case "integralheight": IntegralHeight = QBoolean(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	
	Private Sub ComboBoxEx.AddItem(ByRef FItem As WString)
		Items.Add FItem
	End Sub
	
	Private Sub ComboBoxEx.RemoveItem(Index As Integer)
		Items.Remove(Index)
	End Sub
	
	Private Sub ComboBoxEx.InsertItem(Index As Integer, ByRef FItem As WString)
		Items.Add FItem, , , , , , Index
	End Sub
	
	Private Function ComboBoxEx.IndexOf(ByRef FItem As WString) As Integer
		Return Items.IndexOf(FItem)
	End Function
	
	Private Function ComboBoxEx.Contains(ByRef FItem As WString) As Boolean
		Return IndexOf(FItem) <> -1
	End Function
	
	Private Function ComboBoxEx.IndexOfData(pData As Any Ptr) As Integer
		Return Items.IndexOfData(pData)
	End Function
	
	Private Property ComboBoxEx.IntegralHeight As Boolean
		Return FIntegralHeight
	End Property
	
	Private Property ComboBoxEx.IntegralHeight(Value As Boolean)
		FIntegralHeight = Value
		#ifndef __USE_GTK__
			ChangeStyle CBS_NOINTEGRALHEIGHT, Not Value
		#endif
	End Property
	
	Private Property ComboBoxEx.Item(Index As Integer) ByRef As WString
		If Items.Item(Index) Then
			Return Items.Item(Index)->Text
		Else
			Return ""
		End If
	End Property
	
	Private Property ComboBoxEx.Item(Index As Integer, ByRef FItem As WString)
		If Items.Item(Index) Then
			Items.Item(Index)->Text = FItem
		End If
	End Property
	
	Private Property ComboBoxEx.ItemData(Index As Integer) As Any Ptr
		If Items.Item(Index) Then
			Return Items.Item(Index)->Object
		Else
			Return 0
		End If
	End Property
	
	Private Property ComboBoxEx.ItemData(Index As Integer, Value As Any Ptr)
		If Items.Item(Index) Then
			Items.Item(Index)->Object = Value
		End If
	End Property
	
	Private Property ComboBoxEx.ItemCount As Integer
		#ifndef __USE_GTK__
			If Handle Then
				Return Perform(CB_GETCOUNT,0,0)
			End If
		#endif
		Return Items.Count
	End Property
	
	Private Property ComboBoxEx.ItemCount(Value As Integer)
	End Property
	
	Private Property ComboBoxEx.Text ByRef As WString
		If This.FStyle >= cbDropDownList Then
			If This.ItemIndex = -1 Then
				FText = ""
			Else
				FText = This.Items.Item(This.ItemIndex)->Text
			End If
		Else
			#ifdef __USE_WINAPI__
				Dim As Integer L
				Dim As LRESULT h
				Select Case This.FStyle
				Case ComboBoxEditStyle.cbSimple
					h = SendMessageW(FHandle, CBEM_GETCOMBOCONTROL, 0, 0)
				Case ComboBoxEditStyle.cbDropDown
					h = SendMessageW(FHandle, CBEM_GETEDITCONTROL, 0, 0)
				End Select
				L = SendMessageW(Cast(HWND, h), WM_GETTEXTLENGTH, 0, 0)
				FText.Resize(L + 1)
				GetWindowText(Cast(HWND, h), FText.vptr, L + 1)
			#elseif defined(__USE_GTK__)
				'#ifdef __USE_GTK__
					FText = WStr(*gtk_combo_box_text_get_active_text(GTK_COMBO_BOX_TEXT(widget)))
'				#else
'					Base.Text
'				#endif
			#endif
		End If
		Return *FText.vptr
	End Property
	
	Private Property ComboBoxEx.Text(ByRef Value As WString)
		Base.Text = Value
		#ifdef __USE_WINAPI__
			Select Case This.FStyle
			Case ComboBoxEditStyle.cbSimple
				SendMessageW(Cast(HWND, SendMessageW(FHandle, CBEM_GETCOMBOCONTROL, 0, 0)), WM_SETTEXT, -1, CInt(FText.vptr))
			Case ComboBoxEditStyle.cbDropDown
				SendMessageW(Cast(HWND,SendMessageW(FHandle, CBEM_GETEDITCONTROL, 0, 0)), WM_SETTEXT, -1, CInt(FText.vptr))
			Case Else
				Perform(CB_SELECTSTRING, -1, CInt(FText.vptr))
			End Select
			'If FHandle Then Perform(CB_SELECTSTRING, -1, CInt(FText.vptr))
		#elseif defined(__USE_GTK__)
			If widget Then gtk_combo_box_set_active (GTK_COMBO_BOX(widget), This.IndexOf(Value))
		#endif
	End Property
	
	Private Sub ComboBoxEx.UpdateListHeight
		If This.Style <> cbSimple Then
			#ifndef __USE_GTK__
				Dim As LRESULT h
				h = SendMessageW(FHandle, CBEM_GETCOMBOCONTROL, 0, 0)
				MoveWindow Cast(HWND, h), 0, 0, ScaleX(This.Width), ScaleY(This.Height + (IIf(ItemHeight = 0, 13, ItemHeight) * FDropDownCount)), 1
			#endif
		End If
	End Sub
	
	Private Sub ComboBoxEx.Clear
		Items.Clear
	End Sub
	
	#ifndef __USE_GTK__
		Function ComboBoxEx.HookChildProc(hDlg As HWND, uMsg As UINT, WPARAM As WPARAM, LPARAM As LPARAM) As LRESULT
			Dim As ComboBoxEx Ptr cbo = GetProp(hDlg, "MFFControl")
			If cbo Then
				Dim Message As Message
				Message = Type(cbo, hDlg, uMsg, WPARAM, LPARAM, 0, LoWord(WPARAM), HiWord(WPARAM), LoWord(LPARAM), HiWord(LPARAM), Message.Captured)
				cbo->ProcessMessage(Message)
				'Select Case uMsg
				'Case WM_LBUTTONDBLCLK
				'	If cbo->OnDblClick Then cbo->OnDblClick(*cbo)
				'End Select
				If Message.Result = -1 Then
					Return Message.Result
				ElseIf Message.Result = -2 Then
					uMsg = Message.Msg
					WPARAM = Message.wParam
					LPARAM = Message.lParam
				ElseIf Message.Result <> 0 Then
					Return Message.Result
				End If
			End If
			Return CallWindowProc(GetProp(hDlg, "@@@@Proc"), hDlg, uMsg, WPARAM, LPARAM)
		End Function
		
		Private Sub ComboBoxEx.HandleIsAllocated(ByRef Sender As Control)
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
					Dim As HWND h = Cast(HWND, SendMessage(.Handle, CBEM_GETCOMBOCONTROL, 0, 0))
					Dim As COMBOBOXINFO cbINFO
					cbINFO.cbSize = SizeOf(COMBOBOXINFO)
					GetComboBoxInfo(h, @cbINFO)
					h = cbINFO.hwndItem
					If GetWindowLongPtr(h, GWLP_WNDPROC) <> @HookChildProc Then
						SetProp(h, "MFFControl", Sender.Child)
						SetProp(h, "@@@@Proc", Cast(..WNDPROC, SetWindowLongPtr(h, GWLP_WNDPROC, CInt(@HookChildProc))))
					End If
					If h = cbINFO.hwndCombo Then
						h = FindWindowEx(h, 0, "Edit", 0)
					End If
					If GetWindowLongPtr(h, GWLP_WNDPROC) <> @HookChildProc Then
						SetProp(h, "MFFControl", Sender.Child)
						SetProp(h, "@@@@Proc", Cast(..WNDPROC, SetWindowLongPtr(h, GWLP_WNDPROC, CInt(@HookChildProc))))
					End If
					Dim As Integer i
					For i = 0 To .Items.Count - 1
						Dim As COMBOBOXEXITEM cbei
						cbei.mask = CBEIF_TEXT Or CBEIF_IMAGE Or CBEIF_INDENT Or CBEIF_OVERLAY Or CBEIF_SELECTEDIMAGE
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
		Private Sub ComboBoxEx.WNDPROC(ByRef Message As Message)
			'        If Message.Sender Then
			'            If Cast(TControl Ptr,Message.Sender)->Child Then
			'                Cast(ComboBoxEx Ptr,Cast(TControl Ptr,Message.Sender)->Child)->ProcessMessage(Message)
			'            End If
			'        End If
		End Sub
	#endif
	
	#ifdef __USE_WINAPI__
		Private Sub ComboBoxEx.SetDark(Value As Boolean)
			Base.SetDark Value
			If Value Then
				Dim As HWND cmbHandle = Cast(HWND, SendMessageW(FHandle, CBEM_GETCOMBOCONTROL, 0, 0))
				Dim As COMBOBOXINFO cbINFO
				cbINFO.cbSize = SizeOf(COMBOBOXINFO)
				GetComboBoxInfo(cmbHandle, @cbINFO)
				Dim As HWND lstHandle = cbINFO.hwndList
				SetWindowTheme(cmbHandle, "DarkMode_CFD", nullptr)
				SetWindowTheme(lstHandle, "DarkMode_Explorer", nullptr)
				Brush.Handle = hbrBkgnd
				'SendMessageW(cmbHandle, WM_THEMECHANGED, 0, 0)
			Else
				Dim As HWND cmbHandle = Cast(HWND, SendMessageW(FHandle, CBEM_GETCOMBOCONTROL, 0, 0))
				Dim As COMBOBOXINFO cbINFO
				cbINFO.cbSize = SizeOf(COMBOBOXINFO)
				GetComboBoxInfo(cmbHandle, @cbINFO)
				Dim As HWND lstHandle = cbINFO.hwndList
				SetWindowTheme(cmbHandle, NULL, NULL)
				SetWindowTheme(lstHandle, NULL, NULL)
				If FBackColor = -1 Then
					Brush.Handle = 0
				Else
					Brush.Color = FBackColor
				End If
				'SendMessageW(cmbHandle, WM_THEMECHANGED, 0, 0)
			End If
			'SendMessage FHandle, WM_THEMECHANGED, 0, 0
		End Sub
	#endif
	
	Private Sub ComboBoxEx.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Dim pt As ..Point, rc As ..Rect, t As Long, itd As Long
			Select Case Message.Msg
			Case WM_PAINT
				If g_darkModeSupported AndAlso g_darkModeEnabled AndAlso FDefaultBackColor = FBackColor Then
					If Not FDarkMode Then
						SetDark True
'						FDarkMode = True
'						Dim As HWND cmbHandle = Cast(HWND, SendMessageW(FHandle, CBEM_GETCOMBOCONTROL, 0, 0))
'						Dim As COMBOBOXINFO cbINFO
'						cbINFO.cbSize = SizeOf(COMBOBOXINFO)
'						GetComboBoxInfo(cmbHandle, @cbINFO)
'						Dim As HWND lstHandle = cbINFO.hwndList
'						SetWindowTheme(cmbHandle, "DarkMode_CFD", nullptr)
'						SetWindowTheme(lstHandle, "DarkMode_Explorer", nullptr)
'						Brush.Handle = hbrBkgnd
'						SendMessageW(cmbHandle, WM_THEMECHANGED, 0, 0)
					End If
				Else
					If FDarkMode Then
						SetDark False
'						FDarkMode = False
'						Dim As HWND cmbHandle = Cast(HWND, SendMessageW(FHandle, CBEM_GETCOMBOCONTROL, 0, 0))
'						Dim As COMBOBOXINFO cbINFO
'						cbINFO.cbSize = SizeOf(COMBOBOXINFO)
'						GetComboBoxInfo(cmbHandle, @cbINFO)
'						Dim As HWND lstHandle = cbINFO.hwndList
'						SetWindowTheme(cmbHandle, NULL, NULL)
'						SetWindowTheme(lstHandle, NULL, NULL)
'						If FBackColor = -1 Then
'							Brush.Handle = 0
'						Else
'							Brush.Color = FBackColor
'						End If
'						SendMessageW(cmbHandle, WM_THEMECHANGED, 0, 0)
					End If
				End If
			Case WM_DESTROY
				If ImagesList Then Perform CBEM_SETIMAGELIST, 0, 0
			Case WM_DRAWITEM
				Dim lpdis As DRAWITEMSTRUCT Ptr
				Dim As Integer ItemID, State
				lpdis = Cast(DRAWITEMSTRUCT Ptr, Message.lParam)
				If OnDrawItem Then
					OnDrawItem(This, lpdis->itemID, lpdis->itemState, *Cast(Rect Ptr, @lpdis->rcItem), lpdis->hDC)
				Else 'If Base.FStyle = cbOwnerDrawFixed Then
					If lpdis->itemID = &HFFFFFFFF& Then
						Exit Sub
					EndIf
					Select Case lpdis->itemAction
					Case ODA_DRAWENTIRE, ODA_SELECT
						'DRAW BACKGROUND
						If (lpdis->itemState And ODS_COMBOBOXEDIT) Then
						Else
							FillRect lpdis->hDC, @lpdis->rcItem, Brush.Handle 'GetSysColorBrush(COLOR_WINDOW)
						End If
						If (lpdis->itemState And ODS_SELECTED)   Then                       'if selected Then
							If (lpdis->itemState And ODS_COMBOBOXEDIT) Then
								SetBkMode lpdis->hDC, TRANSPARENT
								If g_darkModeSupported AndAlso g_darkModeEnabled AndAlso FDefaultBackColor = FBackColor Then
									SetTextColor lpdis->hDC, darkTextColor                'Set text color
								Else
									SetTextColor lpdis->hDC, GetSysColor(COLOR_WINDOWTEXT)                'Set text color
								End If
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
								SetBkMode lpdis->hDC, TRANSPARENT
							Else
								FillRect lpdis->hDC, @lpdis->rcItem, Brush.Handle 'GetSysColorBrush(COLOR_WINDOW)
								SetBkColor lpdis->hDC, Brush.Color 'GetSysColor(COLOR_WINDOW)                    'Set text Background
							End If
							If g_darkModeSupported AndAlso g_darkModeEnabled AndAlso FDefaultBackColor = FBackColor Then
								SetTextColor lpdis->hDC, darkTextColor                'Set text color
							Else
								SetTextColor lpdis->hDC, GetSysColor(COLOR_WINDOWTEXT)                'Set text color
							End If
							If CInt(ItemIndex = -1) AndAlso CInt(lpdis->itemID = 0) AndAlso CInt(Focused) Then
								rc.Left   = lpdis->rcItem.Left + 16 : rc.Right = lpdis->rcItem.Right              '  Set cordinates
								rc.Top    = lpdis->rcItem.Top
								rc.Bottom = lpdis->rcItem.Bottom
								DrawFocusRect lpdis->hDC, @rc  'draw focus rectangle
							End If
						End If
						'DRAW TEXT
						'SendMessage message.hWnd, CB_GETLBTEXT, lpdis->itemID, Cast(LPARAM, @zTxt)                  'Get text
						If lpdis->itemID >= 0 AndAlso lpdis->itemID < Items.Count Then
							Dim As WString Ptr zTxt = @Items.Item(lpdis->itemID)->Text
							TextOut lpdis->hDC, lpdis->rcItem.Left + ScaleX(18 + 3) + IIf(lpdis->itemState And ODS_COMBOBOXEDIT, 0, Items.Item(lpdis->itemID)->Indent * 11), lpdis->rcItem.Top + 1, zTxt, Len(*zTxt)     'Draw text
							'DRAW IMAGE
							rc.Left   = lpdis->rcItem.Left + 2 : rc.Right = lpdis->rcItem.Left + 15               'Set cordinates
							rc.Top    = lpdis->rcItem.Top + 1
							rc.Bottom = lpdis->rcItem.Bottom - 1
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
		Base.ProcessMessage(Message)
	End Sub
	
	Private Property ComboBoxEx.Style As ComboBoxEditStyle
		Return Base.FStyle
	End Property
	
	Private Property ComboBoxEx.Style(Value As ComboBoxEditStyle)
		If Value <> Base.FStyle Then
			Base.FStyle = Value
			#ifdef __USE_GTK__
				Base.Style = Value
			#else
				Base.Base.Style = WS_CHILD Or CBS_AUTOHSCROLL Or AStyle(abs_(Value))
			#endif
		End If
	End Property
	
	Private Operator ComboBoxEx.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Constructor ComboBoxEx
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
			gtk_container_add(GTK_CONTAINER(eventboxwidget), widget)
			Base.Base.RegisterClass "ComboBoxEx", @This
		#else
			Dim As INITCOMMONCONTROLSEX icex
			
			icex.dwSize = SizeOf(INITCOMMONCONTROLSEX)
			icex.dwICC = ICC_USEREX_CLASSES
			
			INITCOMMONCONTROLSEX(@icex)
		#endif
		Items.Parent       = @This
		FIntegralHeight    = False
		FTabStop           = True
		'ItemHeight         = 13
		FDropDownCount     = 8
		With This
			.Child       = @This
			#ifndef __USE_GTK__
				Base.Base.RegisterClass "ComboBoxEx", "ComboBoxEx32"
				.ChildProc   = @WNDPROC
				Type fnRtlGetNtVersionNumbers As Sub(major As LPDWORD, minor As LPDWORD, Build As LPDWORD)
				Dim As fnRtlGetNtVersionNumbers RtlGetNtVersionNumbers
				Dim As HMODULE hNtdllModule = GetModuleHandle("ntdll.dll")
				If (hNtdllModule) Then
					RtlGetNtVersionNumbers = Cast(fnRtlGetNtVersionNumbers, GetProcAddress(hNtdllModule, "RtlGetNtVersionNumbers"))
				End If
				Dim As DWORD g_buildNumber = 0
				If (RtlGetNtVersionNumbers) Then
					Dim As DWORD major, minor
					RtlGetNtVersionNumbers(@major, @minor, @g_buildNumber)
					g_buildNumber = g_buildNumber And &hF0000000
				End If
				Select Case g_buildNumber
				Case 17763 /'1809'/, 18362 /'1903'/
					Base.FStyle             = cbOwnerDrawFixed
					Base.Base.Style       = WS_CHILD Or CBS_DROPDOWNLIST Or CBS_AUTOHSCROLL Or CBS_OWNERDRAWFIXED Or WS_VSCROLL
				Case Else
					Base.FStyle             = cbDropDownList
					Base.Base.Style       = WS_CHILD Or CBS_DROPDOWNLIST Or CBS_AUTOHSCROLL Or WS_VSCROLL
				End Select
				.OnHandleIsAllocated = @HandleIsAllocated
				.BackColor       = GetSysColor(COLOR_WINDOW)
				FDefaultBackColor = .BackColor
			#endif
			WLet(FClassName, "ComboBoxEx")
			WLet(FClassAncestor, "ComboBoxEx32")
			.Width       = 121
			.Height      = 121
		End With
	End Constructor
	
	Private Destructor ComboBoxEx
		Items.Clear
		#ifndef __USE_GTK__
			UnregisterClass "ComboBoxEx", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
