'###############################################################################
'#  TabControl.bi                                                              #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TTabControl.bi                                                            #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "TabControl.bi"

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function TabPage.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "parent": Return FParent
			Case "text": Return FCaption
			Case "caption": Return FCaption
			Case "usevisualstylebackcolor": Return @UseVisualStyleBackColor
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function TabPage.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case "parent": This.Parent = Value
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "parent": If *Cast(My.Sys.Object Ptr, Value) Is TabControl Then This.Parent = Cast(TabControl Ptr, Value)
				Case "text": This.Text = QWString(Value)
				Case "caption": This.Caption = QWString(Value)
				Case "usevisualstylebackcolor": This.UseVisualStyleBackColor = QBoolean(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	#ifndef __USE_GTK__
		Private Sub TabPage.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QTabPage(Sender.Child)
					If .UseVisualStyleBackColor Then
						SetWindowTheme(.Handle, NULL, "TAB")
					End If
					.FTheme = OpenThemeData(.Handle, "Window")
				End With
			End If
		End Sub
	#endif
	
	Private Sub TabPage.ProcessMessage(ByRef msg As Message)
		#ifndef __USE_GTK__
			'FTheme = GetWindowTheme(Msg.hWnd)
			Dim As ..RECT rct
			Select Case msg.msg
			Case WM_DESTROY
				CloseThemeData(FTheme)
			Case WM_CTLCOLORSTATIC ', WM_CTLCOLORBTN
				If UseVisualStyleBackColor AndAlso CBool(Not (g_darkModeEnabled AndAlso FDefaultBackColor = FBackColor)) Then
					If IsAppThemed() Then
						GetClientRect(Cast(HWND, Msg.lParam), @rct)
						DrawThemeParentBackground(Cast(HWND, Msg.lParam), Cast(HDC, Msg.wParam), @rct)
						SetBkMode(Cast(HDC, Msg.wParam), TRANSPARENT)
						Msg.Result = Cast(LRESULT, GetStockObject(NULL_BRUSH))
						Return
					End If
				End If
			Case WM_PAINT
				If UseVisualStyleBackColor AndAlso CBool(Not (g_darkModeEnabled AndAlso FDefaultBackColor = FBackColor)) Then
					If FDarkMode AndAlso msg.hWnd = FHandle Then
						FDarkMode = False
						SetWindowTheme(FHandle, NULL, "TAB")
						FTheme = OpenThemeData(FHandle, "Window")
					End If
					If IsAppThemed() Then
						GetClientRect(Msg.hWnd, @rct)
						DrawThemeBackground(FTheme, Cast(HDC, Msg.wParam), 10, 0, @rct, NULL) 'TABP_BODY = 10
						'Msg.Result = True
						Return
					End If
				End If
			Case WM_ERASEBKGND
				If UseVisualStyleBackColor AndAlso CBool(Not (g_darkModeEnabled AndAlso FDefaultBackColor = FBackColor)) Then
					If IsAppThemed() Then
						GetClientRect(Msg.hWnd, @rct)
						DrawThemeBackground(FTheme, Cast(HDC, Msg.wParam), 10, 0, @rct, NULL) 'TABP_BODY = 10
						Msg.Result = 1
						Return
					End If
				End If
			Case WM_PRINTCLIENT
				If UseVisualStyleBackColor AndAlso CBool(Not (g_darkModeEnabled AndAlso FDefaultBackColor = FBackColor)) Then
					If IsAppThemed() Then
						Dim As ..RECT rct
						GetClientRect(Msg.hWnd, @rct)
						FillRect(Cast(HDC, Msg.wParam), @rct, GetStockObject(NULL_BRUSH))
						Msg.Result = True
						Return
					End If
				End If
				'Case WM_PAINT, WM_ERASEBKGND
				'	    		Dim As PAINTSTRUCT ps
				'				Dim As HDC hdc = BeginPaint(msg.hwnd, @ps)
				'	    		Dim As RECT rcWin
				'				Dim As RECT rcWnd
				'				Dim As HWND parWnd = GetParent(msg.hwnd)
				'				Dim As HDC parDc = GetDC(parWnd)
				'				GetWindowRect(msg.hwnd, @rcWnd)
				'				ScreenToClient(parWnd, @rcWnd)
				'				GetClipBox(hdc, @rcWin )
				'	    		BitBlt(hdc, rcWin.left, rcWin.top, rcWin.right - rcWin.left, rcWin.bottom - rcWin.top, parDC, rcWnd.left, rcWnd.top, SRC_COPY)
				'				ReleaseDC(parWnd, parDC)
				'				EndPaint(msg.hwnd, @ps)
				'EnableThemeDialogTexture(msg.hwnd, ETDT_ENABLETAB)
			End Select
		#endif
		Base.ProcessMessage(msg)
	End Sub
	
	Private Property TabPage.Index As Integer
		If This.Parent AndAlso *Base.Parent Is TabControl Then
			Return Cast(TabControl Ptr, This.Parent)->IndexOfTab(@This)
		End If
		Return -1
	End Property
	
	Private Sub TabPage.Update()
		If This.Parent AndAlso *Base.Parent Is TabControl Then
			#ifndef __USE_GTK__
				If This.Parent->Handle Then
					Dim As TCITEM Ti
					Ti.mask = TCIF_TEXT Or TCIF_IMAGE Or TCIF_PARAM
					This.Parent->Perform(TCM_GETITEM, Index, CInt(@Ti))
					Ti.cchTextMax = Len(WGet(FCaption)) + 1
					Ti.pszText = FCaption
					If FObject Then Ti.lparam = Cast(LParam, FObject)
					If Cast(TabControl Ptr, This.Parent)->Images AndAlso FImageKey <> 0 Then
						Ti.iImage = Cast(TabControl Ptr, This.Parent)->Images->IndexOf(*FImageKey)
					Else
						Ti.iImage = FImageIndex
					End If
					This.Parent->Perform(TCM_SETITEM,Index,CInt(@Ti))
				End If
			#endif
		End If
	End Sub
	
	Private Sub TabPage.SelectTab()
		If This.Parent AndAlso *Base.Parent Is TabControl Then
			Cast(TabControl Ptr, This.Parent)->SelectedTabIndex = Index
		End If
	End Sub
	
	Private Property TabPage.Caption ByRef As WString
		Return This.Text
	End Property
	
	Private Property TabPage.Caption(ByRef Value As WString)
		This.Text = Value
	End Property
	
	Private Property TabPage.Text ByRef As WString
		Return WGet(FCaption)
	End Property
	
	Private Property TabPage.Text(ByRef Value As WString)
		WLet(FCaption, Value)
		#ifdef __USE_GTK__
			If gtk_is_label(_Label) Then
				gtk_label_set_text(gtk_Label(_Label), ToUTF8(Value))
			End If
		#else
			Update
		#endif
	End Property
	
	#ifndef Parent_Off
		Private Property TabPage.Parent As TabControl Ptr
			Return Cast(TabControl Ptr, FParent)
		End Property
		
		Private Property TabPage.Parent(Value As TabControl Ptr)
			FParent = Value
			If Value Then Value->AddTab(@This)
		End Property
	#endif
	
	Private Property TabPage.Object As Any Ptr
		Return FObject
	End Property
	
	Private Property TabPage.Object(Value As Any Ptr)
		FObject = Value
		Update
	End Property
	
	Private Property TabPage.ImageIndex As Integer
		Return FImageIndex
	End Property
	
	Private Property TabPage.ImageIndex(Value As Integer)
		FImageIndex = Value
		Update
	End Property
	
	Private Property TabPage.ImageKey ByRef As WString
		Return *FImageKey
	End Property
	
	Private Property TabPage.ImageKey(ByRef Value As WString)
		WLet(FImageKey, Value)
		#ifdef __USE_GTK__
			gtk_image_set_from_icon_name(gtk_image(_icon), ToUTF8(Value), GTK_ICON_SIZE_MENU)
		#else
			Update
		#endif
	End Property
	
	Property TabPage.Visible As Boolean
		Return Base.Visible
	End Property
	
	Property TabPage.Visible(Value As Boolean)
		If FVisible <> Value Then
			FVisible = Value
			If Value Then
				#ifdef __USE_WINAPI__
'					Dim As TCITEMW Ti
'					Dim As Integer LenSt = Len(Caption) + 1
'					Dim As WString Ptr St = CAllocate_(LenSt * Len(WString))
'					St = @Caption
'					Ti.mask = TCIF_TEXT Or TCIF_IMAGE Or TCIF_PARAM
'					Ti.pszText    = St
'					Ti.cchTextMax = LenSt
'					If Tabs[FTabCount - 1]->Object Then Ti.lParam = Cast(LPARAM, Tabs[FTabCount - 1]->Object)
'					Ti.iImage = Tabs[FTabCount - 1]->ImageIndex
'					SendMessageW(FHandle, TCM_INSERTITEMW, FTabCount - 1, CInt(@Ti))
				#endif
			Else
				#ifdef __USE_WINAPI__
					'Perform(TCM_DELETEITEM, Index, 0)
				#endif
			End If
		End If
		Base.Visible = Value
	End Property
	
	Private Operator TabPage.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Operator TabPage.Let(ByRef Value As WString)
		Caption = Value
	End Operator
	
	Private Operator TabPage.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Constructor TabPage
		'Caption = ""
		FObject    = 0
		FImageIndex        = 0
		'Anchor.Left = asAnchor
		'Anchor.Top = asAnchor
		'Anchor.Right = asAnchor
		'Anchor.Bottom = asAnchor
		WLet(FClassName, "TabPage")
		WLet(FClassAncestor, "Panel")
		Child = @This
		#ifdef __USE_GTK__
			This.RegisterClass "TabPage", @This
		#else
			Align = DockStyle.alClient
			Base.Style = WS_CHILD Or DS_SETFOREGROUND
			This.OnHandleIsAllocated = @HandleIsAllocated
			This.RegisterClass "TabPage", "Panel"
		#endif
	End Constructor
	
	Private Destructor TabPage
		'If FParent <> 0 Then Parent->DeleteTab(Parent->IndexOf(@This))
		WDeallocate FCaption
		WDeallocate FImageKey
	End Destructor
	
	#ifndef ReadProperty_Off
		Private Function TabControl.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "tabindex": Return @FTabIndex
			Case "selectedtabindex": Return @FSelectedTabIndex
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function TabControl.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "tabindex": TabIndex = QInteger(Value)
				Case "selectedtabindex": This.SelectedTabIndex = QInteger(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Property TabControl.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property TabControl.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property TabControl.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property TabControl.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Property TabPage.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property TabPage.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property TabPage.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property TabPage.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Property TabControl.SelectedTabIndex As Integer
		#ifdef __USE_GTK__
			Return gtk_notebook_get_current_page(gtk_notebook(widget))
		#else
			Return Perform(TCM_GETCURSEL,0,0)
		#endif
	End Property
	
	Private Property TabControl.SelectedTabIndex(Value As Integer)
		FSelectedTabIndex = Value
		#ifdef __USE_GTK__
			gtk_notebook_set_current_page(gtk_notebook(widget), Value)
		#else
			If Handle Then
				Perform(TCM_SETCURSEL,FSelectedTabIndex,0)
				Dim Id As Integer = SelectedTabIndex
				For i As Integer = 0 To TabCount - 1
					Tabs[i]->Visible = i = Id
					If FDesignMode Then
						ShowWindow(Tabs[i]->Handle, Abs_(i = Id))
						If i <> Id Then SetWindowPos Tabs[i]->Handle, HWND_BOTTOM, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE
					End If
				Next i
				RequestAlign
				If OnSelChange Then OnSelChange(This, Id)
			End If
		#endif
	End Property
	
	Private Sub TabControl.SetMargins()
		Select Case FTabPosition
		Case 0: Base.SetMargins 4 + ItemWidth(0), 2, 4, 3
		Case 1: Base.SetMargins 2, 2, 4 + ItemWidth(0), 3
		Case 2: Base.SetMargins 2, 4 + ItemHeight(0), 4, 3
		Case 3: Base.SetMargins 2, 2, 2, 4 + ItemHeight(0)
		End Select
	End Sub
	
	Private Property TabControl.TabPosition As My.Sys.Forms.TabPosition
		Return FTabPosition
	End Property
	
	Private Property TabControl.TabPosition(Value As My.Sys.Forms.TabPosition)
		FTabPosition = Value
		#ifdef __USE_GTK__
			gtk_notebook_set_tab_pos(gtk_notebook(widget), FTabPosition)
			For i As Integer = 0 To TabCount - 1
				Select Case FTabPosition
				Case 0, 1
					gtk_label_set_text(GTK_LABEL(Tabs[i]->_label), ToUTF8(" " & Tabs[i]->Caption & " "))
					gtk_label_set_angle(GTK_LABEL(Tabs[i]->_label), 90)
				Case 2, 3
					gtk_label_set_text(GTK_LABEL(Tabs[i]->_label), ToUTF8(Tabs[i]->Caption))
					gtk_label_set_angle(GTK_LABEL(Tabs[i]->_label), 0)
				End Select
			Next
		#else
			Select Case FTabPosition
			Case 0
				ChangeStyle(TCS_BOTTOM, False)
				ChangeStyle(TCS_RIGHT, False)
				ChangeStyle(TCS_MULTILINE, True)
				ChangeStyle(TCS_VERTICAL, True)
				ChangeStyle(TCS_OWNERDRAWFIXED, True)
			Case 1
				ChangeStyle(TCS_BOTTOM, False)
				ChangeStyle(TCS_MULTILINE, True)
				ChangeStyle(TCS_VERTICAL, True)
				ChangeStyle(TCS_RIGHT, True)
				ChangeStyle(TCS_OWNERDRAWFIXED, True)
			Case 2
				ChangeStyle(TCS_BOTTOM, False)
				ChangeStyle(TCS_RIGHT, False)
				ChangeStyle(TCS_VERTICAL, False)
				If Not FMultiline Then ChangeStyle(TCS_MULTILINE, False)
				If Not FTabStyle = tsOwnerDrawFixed Then ChangeStyle(TCS_OWNERDRAWFIXED, False)
			Case 3
				ChangeStyle(TCS_RIGHT, False)
				ChangeStyle(TCS_VERTICAL, False)
				ChangeStyle(TCS_BOTTOM, True)
				If Not FMultiline Then ChangeStyle(TCS_MULTILINE, False)
				If Not FTabStyle = tsOwnerDrawFixed Then ChangeStyle(TCS_OWNERDRAWFIXED, False)
			End Select
		#endif
		SetMargins
	End Property
	
	Private Property TabControl.TabStyle As My.Sys.Forms.TabStyle
		Return FTabStyle
	End Property
	
	Private Property TabControl.TabStyle(Value As My.Sys.Forms.TabStyle)
		FTabStyle = Value
		#ifndef __USE_GTK__
			Select Case FTabStyle
			Case 0
				ChangeStyle TCS_BUTTONS, False
				ChangeStyle TCS_OWNERDRAWFIXED, False
				ChangeStyle TCS_TABS, True
			Case 1
				ChangeStyle TCS_TABS, False
				ChangeStyle TCS_OWNERDRAWFIXED, False
				ChangeStyle TCS_BUTTONS, True
			Case 2
				ChangeStyle TCS_TABS, False
				ChangeStyle TCS_BUTTONS, False
				ChangeStyle TCS_OWNERDRAWFIXED, True
			End Select
		#endif
	End Property
	
	Private Property TabControl.FlatButtons As Boolean
		Return FFlatButtons
	End Property
	
	Private Property TabControl.FlatButtons(Value As Boolean)
		FFlatButtons = Value
		#ifndef __USE_GTK__
			Select Case FFlatButtons
			Case True
				If (Style And TCS_FLATBUTTONS) <> TCS_FLATBUTTONS Then
					Style = Style Or TCS_FLATBUTTONS
				End If
			Case False
				If (Style And TCS_FLATBUTTONS) = TCS_FLATBUTTONS Then
					Style = Style And Not TCS_FLATBUTTONS
				End If
			End Select
		#endif
		'RecreateWnd
	End Property
	
	Private Property TabControl.Multiline As Boolean
		Return FMultiline
	End Property
	
	Private Property TabControl.Multiline(Value As Boolean)
		FMultiline = Value
		#ifndef __USE_GTK__
			Select Case FMultiline
			Case False
				If (Style And TCS_MULTILINE) = TCS_MULTILINE Then
					Style = Style And Not TCS_MULTILINE
				End If
				If (Style And TCS_SINGLELINE) <> TCS_SINGLELINE Then
					Style = Style Or TCS_SINGLELINE
				End If
			Case True
				If (Style And TCS_MULTILINE) <> TCS_MULTILINE Then
					Style = Style Or TCS_MULTILINE
				End If
				If (Style And TCS_SINGLELINE) = TCS_SINGLELINE Then
					Style = Style And Not TCS_SINGLELINE
				End If
			End Select
		#endif
		RecreateWnd
	End Property
	
	Private Property TabControl.Reorderable As Boolean
		Return FReorderable
	End Property
	
	Private Property TabControl.Reorderable(Value As Boolean)
		FReorderable = Value
		#ifdef __USE_GTK__
			For i As Integer = 0 To TabCount - 1
				gtk_notebook_set_tab_reorderable(gtk_notebook(widget), Tabs[i]->Widget, Value)
			Next
		#endif
		RecreateWnd
	End Property
	
	Private Property TabControl.TabCount As Integer
		#ifndef __USE_GTK__
			If Handle Then
				FTabCount = Perform(TCM_GETITEMCOUNT,0,0)
			End If
		#endif
		Return FTabCount
	End Property
	
	Private Property TabControl.TabCount(Value As Integer)
	End Property
	
	Private Property TabControl.Tab(Index As Integer) As TabPage Ptr
		Return Tabs[Index]
	End Property
	
	Private Property TabControl.Tab(Index As Integer, Value As TabPage Ptr)
	End Property
	
	Private Property TabControl.SelectedTab As TabPage Ptr
		If SelectedTabIndex >= 0 And SelectedTabIndex <= TabCount - 1 Then
			Return Tabs[SelectedTabIndex]
		Else
			Return 0
		End If
	End Property
	
	Private Property TabControl.SelectedTab(Value As TabPage Ptr)
		SelectedTabIndex = IndexOfTab(Value)
	End Property
	
	Private Function TabControl.ItemHeight(Index As Integer) As Integer
		If Index >= 0 And Index < TabCount Then
			#ifdef __USE_GTK__
				#ifdef __USE_GTK3__
					Return gtk_widget_get_allocated_height(gtk_notebook_get_tab_label(gtk_notebook(widget), Tabs[Index]->Widget))
				#else
					Return gtk_notebook_get_tab_label(gtk_notebook(widget), Tabs[Index]->Widget)->allocation.height
				#endif
			#else
				Dim As ..Rect R
				Perform(TCM_GETITEMRECT, Index, CInt(@R))
				Return UnScaleY(R.Bottom - R.Top)
			#endif
		End If
		Return 0
	End Function
	
	Private Function TabControl.ItemWidth(Index As Integer) As Integer
		If Index >= 0 And Index < TabCount Then
			#ifdef __USE_GTK__
				#ifdef __USE_GTK3__
					Return gtk_widget_get_allocated_width(gtk_notebook_get_tab_label(gtk_notebook(widget), Tabs[Index]->Widget))
				#else
					Return gtk_notebook_get_tab_label(gtk_notebook(widget), Tabs[Index]->Widget)->allocation.width
				#endif
			#else
				Dim As ..Rect R
				Perform(TCM_GETITEMRECT, Index, CInt(@R))
				Return UnScaleX(R.Right - R.Left)
			#endif
		End If
		Return 0
	End Function
	
	Private Function TabControl.ItemLeft(Index As Integer) As Integer
		If Index >= 0 And Index < TabCount Then
			#ifndef __USE_GTK__
				Dim As ..Rect R
				Perform(TCM_GETITEMRECT, Index, CInt(@R))
				Return UnScaleX(R.Left)
			#endif
		End If
		Return 0
	End Function
	
	Private Function TabControl.ItemTop(Index As Integer) As Integer
		If Index >= 0 And Index < TabCount Then
			#ifndef __USE_GTK__
				Dim As ..Rect R
				Perform(TCM_GETITEMRECT, Index, CInt(@R))
				Return UnScaleY(R.Top)
			#endif
		End If
		Return 0
	End Function
	
	#ifndef __USE_GTK__
		Private Sub TabControl.WndProc(ByRef Message As Message)
		End Sub
		
		Private Sub TabControl.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QTabControl(Sender.Child)
					If .Images Then .Images->ParentWindow = @Sender
					If .Images AndAlso .Images->Handle Then .Perform(TCM_SETIMAGELIST, 0, CInt(.Images->Handle))
					For i As Integer = 0 To .FTabCount - 1
						Dim As TCITEMW Ti
						Ti.mask = TCIF_TEXT Or TCIF_IMAGE Or TCIF_PARAM
						Ti.pszText    = @(.Tabs[i]->Caption)
						Ti.cchTextMax = Len(.Tabs[i]->Caption) + 1
						If .Images AndAlso .Tabs[i]->ImageKey <> "" Then
							Ti.iImage = .Images->IndexOf(.Tabs[i]->ImageKey)
						Else
							Ti.iImage = .Tabs[i]->ImageIndex
						End If
						'If .Tabs[i]->Object Then Ti.lParam = Cast(LPARAM, .Tabs[i]->Object)
						Ti.lParam = Cast(LPARAM, .Handle)
						.Perform(TCM_INSERTITEM, i, CInt(@Ti))
						'EnableThemeDialogTexture(.Tabs[i]->Handle, ETDT_ENABLETAB)
						.SetMargins
					Next
					.RequestAlign
					If .TabCount > 0 Then .Tabs[0]->BringToFront()
				End With
			End If
		End Sub
	#endif
	
	Private Sub TabControl.ProcessMessage(ByRef Message As Message)
			#ifndef __USE_GTK__
			Select Case Message.Msg
			Case CM_DRAWITEM
				If FTabPosition = tpLeft Or FTabPosition = tpRight Then
					Dim As LogFont LogRec
					Dim As hFont OldFontHandle, NewFontHandle
					Dim hdc As hdc
					GetObject Font.Handle, SizeOf(LogRec), @LogRec
					LogRec.lfEscapement = 90 * 10
					NewFontHandle = CreateFontIndirect(@LogRec)
					hdc = GetDc(FHandle)
					OldFontHandle = SelectObject(hdc, NewFontHandle)
					SetBKMode(hdc, TRANSPARENT)
					For i As Integer = 0 To TabCount - 1
						.TextOut(hdc, IIf(FTabPosition = tpLeft, ScaleX(2), ScaleX(This.Width - ItemWidth(i))), ScaleY(ItemTop(i) + ItemHeight(i) - 5), Tabs[i]->Caption, Len(Tabs[i]->Caption))
					Next i
					SetBKMode(hdc,OPAQUE)
					NewFontHandle = SelectObject(hdc, OldFontHandle)
					ReleaseDc FHandle, hdc
					DeleteObject(NewFontHandle)
				End If
				Message.Result = 0
			Case WM_THEMECHANGED
				
			Case WM_ERASEBKGND
				If g_darkModeSupported AndAlso g_darkModeEnabled Then
					Message.Result = -1
					Exit Sub
				End If
			Case WM_PAINT
				If g_darkModeSupported AndAlso g_darkModeEnabled AndAlso FDefaultBackColor = FBackColor Then
					If Not FDarkMode Then
						FDarkMode = True
						'SetWindowTheme(FHandle, "DarkMode::Menu", nullptr)
						SetWindowTheme(FHandle, "DarkMode_ImmersiveStart", nullptr) ' DarkMode
						AllowDarkModeForWindow(FHandle, g_darkModeEnabled)
						Brush.Handle = hbrBkgnd
						SendMessageW(FHandle, WM_THEMECHANGED, 0, 0)
						Repaint
					End If
					Dim As HDC Dc, memDC
					Dim As HBITMAP Bmp
					Dim As PAINTSTRUCT Ps
					Dc = BeginPaint(Handle, @Ps)
					Canvas.HandleSetted = True
					Canvas.Handle = Dc
					If OnPaint Then OnPaint(This, Canvas)
					FillRect Dc, @Ps.rcpaint, Brush.Handle
					Dim As LogFont LogRec
					Dim As hFont OldFontHandle, NewFontHandle
					If FTabPosition = tpLeft Or FTabPosition = tpRight Then
						GetObject Font.Handle, SizeOf(LogRec), @LogRec
						LogRec.lfEscapement = 90 * 10
						NewFontHandle = CreateFontIndirect(@LogRec)
						OldFontHandle = SelectObject(Dc, NewFontHandle)
					Else
						OldFontHandle = SelectObject(Dc, Font.Handle)
					End If
					SetTextColor(Dc, darkTextColor)
					SetBKMode(Dc, TRANSPARENT)
					For i As Integer = 0 To TabCount - 1
						Dim As ..Rect R
						Perform(TCM_GETITEMRECT, i, CInt(@R))
						If i = SelectedTabIndex Then
							FillRect(Dc, @R, hbrHlBkgnd)
						End If
						If FTabPosition = tpLeft Or FTabPosition = tpRight Then
							.TextOut(Dc, IIf(FTabPosition = tpLeft, ScaleX(2), ScaleX(This.Width - ItemWidth(i))), ScaleY(ItemTop(i) + ItemHeight(i) - 5), Tabs[i]->Caption, Len(Tabs[i]->Caption))
						Else
							If Images Then
								ImageList_Draw(Images->Handle, IIf(Tabs[i]->ImageKey <> "", Images->IndexOf(Tabs[i]->ImageKey), Tabs[i]->ImageIndex), Dc, R.Left + 3, R.Top + 2, ILD_TRANSPARENT)
								.TextOut(Dc, R.Left + 5 + ScaleX(Images->ImageWidth), R.Top + 3, Tabs[i]->Caption, Len(Tabs[i]->Caption))
							Else
								.TextOut(Dc, R.Left + 5, R.Top + 3, Tabs[i]->Caption, Len(Tabs[i]->Caption))
							End If
						End If
					Next i
					SetBKMode(dc, OPAQUE)
					NewFontHandle = SelectObject(dc, OldFontHandle)
					If FTabPosition = tpLeft Or FTabPosition = tpRight Then
						DeleteObject(NewFontHandle)
					End If
					EndPaint Handle, @Ps
					Message.Result = 0
					Canvas.HandleSetted = False
					Return
				Else
					If FDarkMode Then
						FDarkMode = False
						'SetWindowTheme(FHandle, "DarkMode::Menu", nullptr)
						SetWindowTheme(FHandle, NULL, NULL) ' DarkMode
						AllowDarkModeForWindow(FHandle, g_darkModeEnabled)
						If FBackColor = -1 Then
							Brush.Handle = 0
						Else
							Brush.Color = FBackColor
						End If
						SendMessageW(FHandle, WM_THEMECHANGED, 0, 0)
						Repaint
					End If
				End If
			Case WM_SIZE
			Case WM_LBUTTONDOWN
				DownButton = 0
				FMousePos = Message.lParamLo
				SetCapture FHandle
			Case WM_LBUTTONUP
				DownButton = -1
				ReleaseCapture
			Case WM_MOUSEMOVE
				If CInt(FReorderable) AndAlso CInt(DownButton = 0) Then
					Dim As ..Rect R1, R2, R3
					Var SelTbIndex = SelectedTabIndex
					Perform(TCM_GETITEMRECT, SelTbIndex, CInt(@R1))
					If Message.lParamLo < R1.Left AndAlso SelTbIndex > 0 Then
						Perform(TCM_GETITEMRECT, SelTbIndex - 1, CInt(@R2))
						If Message.lParamLo < R2.Left + FMousePos - R1.Left Then
							ReorderTab Tabs[SelTbIndex], SelTbIndex - 1
							Perform(TCM_GETITEMRECT, SelTbIndex - 1, CInt(@R3))
							FMousePos = R3.Left + FMousePos - R1.Left
						End If
					ElseIf Message.lParamLo > R1.Right AndAlso SelTbIndex < TabCount - 1 Then
						Perform(TCM_GETITEMRECT, SelTbIndex + 1, CInt(@R2))
						If Message.lParamLo > R2.Right - R2.Left + FMousePos - R1.Left Then
							ReorderTab Tabs[SelTbIndex], SelTbIndex + 1
							Perform(TCM_GETITEMRECT, SelTbIndex + 1, CInt(@R3))
							FMousePos = R3.Left + FMousePos - R1.Left
						End If
					End If
				End If
			Case CM_COMMAND
			Case CM_NOTIFY
				Dim As LPNMHDR NM
				NM = Cast(LPNMHDR,Message.lParam)
				If NM->Code = TCN_SELCHANGE Then
					SelectedTabIndex = SelectedTabIndex
				End If
			Case WM_NCHITTEST
				If FDesignMode Then Exit Sub
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Function TabControl.AddTab(ByRef Caption As WString, aObject As Any Ptr = 0, ImageIndex As Integer = -1) As TabPage Ptr
		FTabCount += 1
		Dim tb As TabPage Ptr = New_( TabPage)
		tb->FDynamic = True
		tb->Caption = Caption
		tb->Object = AObject
		tb->ImageIndex = ImageIndex
		Tabs = Reallocate_(Tabs, SizeOf(TabPage Ptr) * FTabCount)
		Tabs[FTabCount - 1] = tb
		#ifdef __USE_GTK__
			If widget Then
				#ifdef __USE_GTK3__
					tb->_box = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 1)
				#else
					tb->_box = gtk_hbox_new(False, 1)
				#endif
				tb->_icon = gtk_image_new_from_icon_name(ToUTF8(tb->ImageKey), GTK_ICON_SIZE_MENU)
				gtk_container_add (GTK_CONTAINER (tb->_box), tb->_icon)
				tb->_label = gtk_label_new(ToUTF8(tb->Caption))
				gtk_container_add (GTK_CONTAINER (tb->_box), tb->_label)
				'gtk_box_pack_end (GTK_BOX (tp->_box), tp->_label, TRUE, TRUE, 0)
				gtk_widget_show_all(tb->_box)
				gtk_notebook_append_page(gtk_notebook(widget), tb->widget, tb->_box)
				gtk_notebook_set_tab_reorderable(gtk_notebook(widget), tb->widget, FReorderable)
				'gtk_notebook_append_page(gtk_notebook(widget), tb->widget, gtk_label_new(ToUTF8(Caption)))
			End If
		#else
			If Handle Then
				Dim As TCITEMW Ti
				Dim As Integer LenSt = Len(Caption) + 1
				Dim As WString Ptr St = CAllocate_(LenSt * Len(WString))
				St = @Caption
				Ti.mask = TCIF_TEXT Or TCIF_IMAGE Or TCIF_PARAM
				Ti.pszText    = St
				Ti.cchTextMax = LenSt
				If Tabs[FTabCount - 1]->Object Then Ti.lParam = Cast(LPARAM, Tabs[FTabCount - 1]->Object)
				Ti.iImage = Tabs[FTabCount - 1]->ImageIndex
				SendmessageW(FHandle, TCM_INSERTITEMW, FTabCount - 1, CInt(@Ti))
			End If
			SetMargins
		#endif
		This.Add(tb)
		tb->Visible = FTabCount = 1
		Return Tabs[FTabCount - 1]
	End Function
	
	Private Function TabControl.AddTab(ByRef Caption As WString, aObject As Any Ptr = 0, ByRef ImageKey As WString) As TabPage Ptr
		Dim tb As TabPage Ptr
		If Images Then
			tb = AddTab(Caption, aObject, Images->IndexOf(ImageKey))
		Else
			tb = AddTab(Caption, aObject, -1)
		End If
		If tb Then tb->ImageKey = ImageKey
		Return tb
	End Function
	
	Private Sub TabControl.AddTab(ByRef tp As TabPage Ptr)
		FTabCount += 1
		'tp->TabPageControl = @This
		Tabs = Reallocate_(Tabs, SizeOf(TabPage Ptr) * FTabCount)
		Tabs[FTabCount - 1] = tp
'		If tp->Parent <> 0 Then
'			Cast(TabControl Ptr, tp->Parent)->DeleteTab(tp)
'		End If
		#ifdef __USE_GTK__
			If widget Then
				#ifdef __USE_GTK3__
					tp->_box = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 1)
				#else
					tp->_box = gtk_hbox_new(False, 1)
				#endif
				tp->_icon = gtk_image_new_from_icon_name(ToUTF8(tp->ImageKey), GTK_ICON_SIZE_MENU)
				gtk_container_add (GTK_CONTAINER (tp->_box), tp->_icon)
				tp->_label = gtk_label_new(ToUTF8(tp->Caption))
				gtk_container_add (GTK_CONTAINER (tp->_box), tp->_label)
				'gtk_box_pack_end (GTK_BOX (tp->_box), tp->_label, TRUE, TRUE, 0)
				gtk_widget_show_all(tp->_box)
				gtk_notebook_append_page(gtk_notebook(widget), tp->widget, tp->_box)
				gtk_notebook_set_tab_reorderable(gtk_notebook(widget), tp->widget, FReorderable)
				'RequestAlign
			End If
			tp->Visible = FTabCount = 1
			If widget Then
				gtk_widget_show_all(widget)
			End If
		#else
			If Handle Then
				Dim As TCITEMW Ti
				Dim As WString Ptr St
				WLet(St, tp->Caption)
				Ti.mask = TCIF_TEXT Or TCIF_IMAGE Or TCIF_PARAM
				Ti.pszText    = St
				Ti.cchTextMax = Len(tp->Caption)
				If tp->Object Then Ti.lParam = Cast(LPARAM, tp->Object)
				Ti.iImage = tp->ImageIndex
				SendmessageW(FHandle, TCM_INSERTITEMW, FTabCount - 1, CInt(@Ti))
				WDeallocate St
			End If
			SetMargins
			tp->Visible = FTabCount = 1
		#endif
		This.Add(Tabs[FTabCount - 1])
		Tabs[FTabCount - 1]->SendToBack
	End Sub
	
	Private Sub TabControl.ReorderTab(ByVal tp As TabPage Ptr, Index As Integer)
		Dim As Integer i
		Dim As TabPage Ptr It
		If Index >= 0 And Index <= FTabCount -1 Then
			If Index < tp->Index Then
				For i = Index To tp->Index - 1
					It = Tabs[i]
					Tabs[i + 1] = It
					If i = Index Then
						Tabs[Index] = tp
					End If
					Tabs[i + 1]->Update
				Next i
				Tabs[Index]->Update
			Else
				For i = tp->Index + 1 To Index
					It = Tabs[i]
					Tabs[i - 1] = It
					Tabs[i - 1]->Update
				Next i
				Tabs[Index] = tp
				Tabs[Index]->Update
			End If
			SelectedTabIndex = Index
		End If
	End Sub
	
	Private Sub TabControl.DeleteTab(Index As Integer)
		Dim As Integer i
		Dim As TabPage Ptr It
		If Index >= 0 And Index <= FTabCount -1 Then
			If Tabs[Index]->FDynamic Then Delete_(Tabs[Index])
			This.Remove(Tabs[Index])
			For i = Index + 1 To FTabCount -1
				It = Tabs[i]
				Tabs[i - 1] = It
			Next i
			FTabCount -= 1
			If FTabCount = 0 Then
				Deallocate_(Tabs)
				Tabs = 0
			Else
				Tabs = Reallocate_(Tabs,FTabCount*SizeOf(TabPage Ptr))
			End If
			#ifdef __USE_GTK__
				gtk_notebook_remove_page(gtk_notebook(widget), Index)
			#else
				Perform(TCM_DELETEITEM,Index,0)
			#endif
			If Index > 0 Then
				SelectedTabIndex = Index - 1
			ElseIf Index < TabCount - 1 Then
				SelectedTabIndex = Index + 1
			End If
			If FTabCount = 0 Then SetMargins
		End If
	End Sub
	
	Private Sub TabControl.DeleteTab(Value As TabPage Ptr)
		DeleteTab IndexOfTab(value)
	End Sub
	
	Private Sub TabControl.InsertTab(Index As Integer, ByRef Caption As WString, AObject As Any Ptr = 0)
		Dim As Integer i
		Dim As TabPage Ptr It
		#ifndef __USE_GTK__
			Dim As TCITEM Ti
			Ti.mask = TCIF_TEXT Or TCIF_IMAGE Or TCIF_PARAM
		#endif
		If Index >= 0 And Index <= FTabCount -1 Then
			FTabCount += 1
			Tabs = Reallocate_(Tabs,FTabCount*SizeOf(TabPage Ptr))
			For i = Index To FTabCount -2
				It = Tabs[i]
				Tabs[i + 1] = It
			Next i
			Tabs[Index] = New_( TabPage)
			Tabs[Index]->FDynamic = True
			Tabs[Index]->Caption = Caption
			Tabs[Index]->Object = aObject
			'Tabs[Index]->TabPageControl = @This
			#ifndef __USE_GTK__
				Ti.pszText    = @(Tabs[Index]->Caption)
				Ti.cchTextMax = Len(Tabs[Index]->Caption) + 1
				If Tabs[Index]->Object Then Ti.lParam = Cast(LPARAM, Tabs[Index]->Object)
				Perform(TCM_INSERTITEM, Index, CInt(@Ti))
			#endif
			SetMargins
			This.Add(Tabs[Index])
		End If
	End Sub
	
	Private Sub TabControl.InsertTab(Index As Integer, ByRef tp As TabPage Ptr)
		FTabCount += 1
		'tp->TabPageControl = @This
		Tabs = Reallocate_(Tabs, SizeOf(TabPage Ptr) * FTabCount)
		Tabs[FTabCount - 1] = tp
		#ifdef __USE_GTK__
			If widget Then
				#ifdef __USE_GTK3__
					tp->_box = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 1)
				#else
					tp->_box = gtk_hbox_new(False, 1)
				#endif
				tp->_icon = gtk_image_new_from_icon_name(ToUTF8(tp->ImageKey), GTK_ICON_SIZE_MENU)
				gtk_container_add (GTK_CONTAINER (tp->_box), tp->_icon)
				tp->_label = gtk_label_new(ToUTF8(tp->Caption))
				gtk_container_add (GTK_CONTAINER (tp->_box), tp->_label)
				'gtk_box_pack_end (GTK_BOX (tp->_box), tp->_label, TRUE, TRUE, 0)
				gtk_widget_show_all(tp->_box)
				gtk_notebook_insert_page(gtk_notebook(widget), tp->widget, tp->_box, Index)
				gtk_notebook_set_tab_reorderable(gtk_notebook(widget), tp->widget, FReorderable)
				'RequestAlign
			End If
			tp->Visible = FTabCount = 1
			If widget Then
				gtk_widget_show_all(widget)
			End If
		#else
			If Handle Then
				Dim As TCITEMW Ti
				Dim As WString Ptr St
				WLet(St, tp->Caption)
				Ti.mask = TCIF_TEXT Or TCIF_IMAGE Or TCIF_PARAM
				Ti.pszText    = St
				Ti.cchTextMax = Len(tp->Caption)
				If tp->Object Then Ti.lParam = Cast(LPARAM, tp->Object)
				Ti.iImage = tp->ImageIndex
				SendmessageW(FHandle, TCM_INSERTITEMW, Index, CInt(@Ti))
			End If
			SetMargins
			tp->Visible = FTabCount = 1
		#endif
		This.Add(Tabs[Index])
	End Sub
	
	Private Operator TabControl.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Function TabControl.IndexOfTab(Value As TabPage Ptr) As Integer
		Dim As Integer i
		For i = 0 To TabCount - 1
			If Tabs[i] = Value Then Return i
		Next i
		Return -1
	End Function
	
	#ifdef __USE_GTK__
		Private Sub TabControl_SwitchPage(notebook As GtkNotebook Ptr, page As GtkWidget Ptr, page_num As UInteger, user_data As Any Ptr)
			Dim As TabControl Ptr tc = user_data
			tc->Tabs[page_num]->RequestAlign
			If tc->OnSelChange Then tc->OnSelChange(*tc, page_num)
		End Sub
	#endif
	
	Private Constructor TabControl
		SetMargins
		With This
			#ifdef __USE_GTK__
				widget = gtk_notebook_new()
				gtk_notebook_set_scrollable(gtk_notebook(widget), True)
				g_signal_connect(gtk_notebook(widget), "switch-page", G_CALLBACK(@TabControl_SwitchPage), @This)
				.RegisterClass "TabControl", @This
			#else
				WLet(FClassAncestor, "SysTabControl32")
				.RegisterClass "TabControl", "SysTabControl32"
			#endif
			WLet(FClassName, "TabControl")
			.Child       = @This
			#ifndef __USE_GTK__
				.ChildProc   = @WndProc
				Base.ExStyle     = 0
				Base.Style       = WS_CHILD
				.OnHandleIsAllocated = @HandleIsAllocated
				.DoubleBuffered = True
			#endif
			FTabIndex          = -1
			FTabStop           = True
			FTabPosition = 2
			.Width       = 121
			.Height      = 121
		End With
	End Constructor
	
	Private Destructor TabControl
		For i As Integer = 0 To FTabCount - 1
			Tabs[i]->Parent = 0
			If Tabs[i]->FDynamic Then Delete_(Tabs[i])
		Next
		If Tabs <> 0 Then Deallocate_(Tabs)
		'UnregisterClass "TabControl", GetModuleHandle(NULL)
	End Destructor
	
End Namespace
