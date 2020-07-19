'###############################################################################
'#  ToolBar.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TToolBar.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "ToolBar.bi"

Namespace My.Sys.Forms
	Sub ToolBar.GetDropDownMenuItems
		FPopupMenuItems.Clear
		For j As Integer = 0 To Buttons.Count - 1
			For i As Integer = 0 To Buttons.Item(j)->DropDownMenu.Count -1
				EnumPopupMenuItems *Buttons.Item(j)->DropDownMenu.Item(i)
			Next i
		Next j
	End Sub
	
	Function ToolButton.ReadProperty(ByRef PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "visible": Return @FVisible
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function ToolButton.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		If Value = 0 Then
			Select Case LCase(PropertyName)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		Else
			Select Case LCase(PropertyName)
			Case "visible": This.Visible = QBoolean(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		End If
		Return True
	End Function
	
	Function ToolButton.ToString ByRef As WString
		Return This.Name
	End Function
	
	Property ToolButton.Caption ByRef As WString
		Return *FCaption
	End Property
	
	Property ToolButton.Caption(ByRef Value As WString)
		Dim As Integer i
		If Value <> *FCaption Then
			WLet FCaption, Value
			#ifndef __USE_GTK__
				Dim As TBBUTTON TB
				If Ctrl Then
					With QControl(Ctrl)
						i = .Perform(TB_COMMANDTOINDEX,FCommandID,0)
						.Perform(TB_GETBUTTON,i,CInt(@TB))
						If *FCaption <> "" Then
							TB.iString = CInt(FCaption)
						Else
							TB.iString = 0
						End If
						.Perform(TB_INSERTBUTTON, i, CInt(@TB))
						.Perform(TB_DELETEBUTTON, i + 1, 0)
					End With
				End If
			#endif
		End If
	End Property
	
	Property ToolButton.Name ByRef As WString
		Return WGet(FName)
	End Property
	
	Property ToolButton.Name(ByRef Value As WString)
		WLet FName, Value
	End Property
	
	Property ToolButton.Hint ByRef As WString
		Return *FHint
	End Property
	
	Property ToolButton.Hint(ByRef Value As WString)
		FHint = Reallocate(FHint, (Len(Value) + 1) * SizeOf(WString))
		*FHint = Value
	End Property
	
	Property ToolButton.ShowHint As Boolean
		Return FShowHint
	End Property
	
	Property ToolButton.ShowHint(Value As Boolean)
		FShowHint = Value
	End Property
	
	Property ToolButton.ImageIndex As Integer
		Return FImageIndex
	End Property
	
	Property ToolButton.ImageIndex(Value As Integer)
		If Value <> FImageIndex Then
			FImageIndex = Value
			If Ctrl Then
				With QControl(Ctrl)
					#ifndef __USE_GTK__
						.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex, 0))
					#endif
				End With
			End If
		End If
	End Property
	
	Property ToolButton.ImageKey ByRef As WString
		Return WGet(FImageKey)
	End Property
	
	Property ToolButton.ImageKey(ByRef Value As WString)
		WLet FImageKey, Value
		#ifdef __USE_GTK__
			If GTK_IS_TOOL_BUTTON(Widget) Then gtk_tool_button_set_icon_name(GTK_TOOL_BUTTON(Widget), Value)
		#else
			If Ctrl AndAlso QToolBar(Ctrl).ImagesList Then
				ImageIndex = QToolBar(Ctrl).ImagesList->IndexOf(Value)
			End If
		#endif
	End Property
	
	Property ToolButton.Style As Integer
		Return FStyle
	End Property
	
	Property ToolButton.Style(Value As Integer)
		If Value <> FStyle Then
			FStyle = Value
			'If Ctrl Then QControl(Ctrl).RecreateWnd
		End If
	End Property
	
	Property ToolButton.State As Integer
		Return FState
	End Property
	
	Property ToolButton.State(Value As Integer)
		If Value <> FState Then
			FState = Value
			If Ctrl Then QControl(Ctrl).RecreateWnd
		End If
	End Property
	
	Property ToolButton.CommandID As Integer
		Return FCommandID
	End Property
	
	Property ToolButton.CommandID(Value As Integer)
		Dim As Integer i
		If Value <> FCommandID Then
			FCommandID = Value
			If Ctrl Then
				With QControl(Ctrl)
					#ifndef __USE_GTK__
						i = .Perform(TB_COMMANDTOINDEX,FCommandID,0)
						.Perform(TB_SETCMDID,i,FCommandID)
					#endif
				End With
			End If
		End If
	End Property
	
	Property ToolButton.Left As Integer
		#ifndef __USE_GTK__
			Dim As Rect R
			Dim As Integer i
			If Ctrl Then
				With QControl(Ctrl)
					If .Handle Then
						i = .Perform(TB_COMMANDTOINDEX,FCommandID,0)
						.Perform(TB_GETITEMRECT,I,CInt(@R))
						FButtonLeft = R.Left
					End If
				End With
			End If
		#endif
		Return FButtonLeft
	End Property
	
	Property ToolButton.Left(Value As Integer)
	End Property
	
	Property ToolButton.Top As Integer
		Dim As Integer i
		If Ctrl Then
			With QControl(Ctrl)
				#IfNDef __USE_GTK__
					Dim As Rect R
					If .Handle Then
						i = .Perform(TB_COMMANDTOINDEX,FCommandID,0)
						.Perform(TB_GETITEMRECT,I,CInt(@R))
						FButtonTop = R.Top
					End If
				#EndIf
			End With
		End If
		Return FButtonTop
	End Property
	
	Property ToolButton.Top(Value As Integer)
	End Property
	
	Property ToolButton.Width As Integer
		Dim As Integer i
		If Ctrl Then
			With QControl(Ctrl)
				#IfNDef __USE_GTK__
					Dim As Rect R
					If .Handle Then
						i = .Perform(TB_COMMANDTOINDEX,FCommandID,0)
						.Perform(TB_GETITEMRECT,I,CInt(@R))
						FButtonWidth = R.Right - R.Left
					End If
				#EndIf
			End With
		End If
		Return FButtonWidth
	End Property
	
	Property ToolButton.Width(Value As Integer)
		FButtonWidth = Value
	End Property
	
	Property ToolButton.Height As Integer
		#IfNDef __USE_GTK__
			Dim As Rect R
			Dim As Integer i
			If Ctrl Then
				With QControl(Ctrl)
					If .Handle Then
						i = .Perform(TB_COMMANDTOINDEX,FCommandID,0)
						.Perform(TB_GETITEMRECT,I,CInt(@R))
						FButtonHeight = R.Bottom - R.Top
					End If
				End With
			End If
		#endif
		Return FButtonHeight
	End Property
	
	Property ToolButton.Height(Value As Integer)
	End Property
	
	Property ToolButton.Visible As Boolean
		Return FVisible
	End Property
	
	Property ToolButton.Visible(Value As Boolean)
		If Value <> FVisible Then
			FVisible = Value
			If Ctrl Then
				With QControl(Ctrl)
					#ifdef __USE_GTK__
						If FVisible Then
							gtk_widget_show(Widget)
						Else
							gtk_widget_hide(Widget)
						End If
					#else
						.Perform(TB_HIDEBUTTON, FCommandID, MakeLong(Not FVisible, 0))
					#endif
				End With
			End If
		End If
	End Property
	
	Property ToolButton.Enabled As Boolean
		Return FEnabled
	End Property
	
	Property ToolButton.Enabled(Value As Boolean)
		If Value <> FEnabled Then
			FEnabled = Value
			If Ctrl Then
				With QControl(Ctrl)
					#ifdef __USE_GTK__
						gtk_widget_set_sensitive(widget, FEnabled)
					#else
						.Perform(TB_ENABLEBUTTON, FCommandID, MakeLong(FEnabled, 0))
						.Perform(TB_CHANGEBITMAP, FCommandID, MakeLong(FImageIndex,0))
					#endif
				End With
			End If
		End If
	End Property
	
	Property ToolButton.Checked As Boolean
		If Ctrl Then
			With QControl(Ctrl)
				#ifdef __USE_GTK__
					If gtk_is_toggle_tool_button(widget) Then
						FChecked = gtk_toggle_tool_button_get_active(gtk_toggle_tool_button(widget))
					Else
						FChecked = False
					End If
				#else
					FChecked = .Perform(TB_ISBUTTONCHECKED, FCommandID, 0)
				#endif
			End With
		End If
		Return FChecked
	End Property
	
	Property ToolButton.Checked(Value As Boolean)
		'If Value <> Checked Then
		FChecked = Value
		If Ctrl Then
			With QControl(Ctrl)
				#ifdef __USE_GTK__
					If gtk_is_toggle_tool_button(widget) Then
						gtk_toggle_tool_button_set_active(gtk_toggle_tool_button(widget), Value)
					End If
				#else
					.Perform(TB_CHECKBUTTON, FCommandID, MakeLong(FChecked, 0))
				#endif
				If OnClick Then OnClick(This)
			End With
		End If
		If CInt(Value) AndAlso CInt((FState And tstChecked) <> tstChecked) Then
			FState = FState Or tstChecked
		End If
		'End If
	End Property
	
	Operator ToolButton.Cast As Any Ptr
		Return @This
	End Operator
	
	Constructor ToolButton
		FHint = CAllocate(0)
		FCaption = CAllocate(0)
		WLet FClassName, "ToolButton"
		FStyle      = tbsButton
		FEnabled    = 1
		FVisible    = 1
		Caption    = ""
		Hint       = ""
		FShowHint   = 0
		FImageIndex = -1
	End Constructor
	
	Destructor ToolButton
		#IfDef __USE_GTK__
			If gtk_is_widget(widget) Then gtk_widget_destroy(Widget)
		#Else
			If DropDownMenu.Handle Then DestroyMenu DropDownMenu.Handle
		#EndIf
		WDeallocate FHint
		WDeallocate FCaption
		WDeallocate FName
	End Destructor
	
	Property ToolButtons.Count As Integer
		Return FButtons.Count
	End Property
	
	Property ToolButtons.Count(Value As Integer)
	End Property
	
	Property ToolButtons.Item(Index As Integer) As ToolButton Ptr
		Return Cast(ToolButton Ptr, FButtons.Items[Index])
	End Property
	
	Property ToolButtons.Item(ByRef Key As WString) As ToolButton Ptr
		If IndexOf(Key) <> -1 Then Return Cast(ToolButton Ptr, FButtons.Items[IndexOf(Key)])
		Return 0
	End Property
	
	Property ToolButtons.Item(Index As Integer, Value As ToolButton Ptr)
		'QToolButton(FButtons.Items[Index]) = Value
	End Property
	
	#IfDef __USE_GTK__
		Sub ToolButtonClicked(gtoolbutton As GtkToolButton Ptr, user_data As Any Ptr)
			Dim As ToolButton Ptr tb = user_data
			If tb Then
				If tb->OnClick Then tb->OnClick(*tb)
			End If
		End Sub
	#EndIf
	
	Function ToolButtons.Add(FStyle As Integer = tbsAutosize, FImageIndex As Integer = -1, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As Integer = tstEnabled) As ToolButton Ptr
		Dim As ToolButton Ptr PButton
		PButton = New ToolButton
		FButtons.Add PButton
		With *PButton
			.Style          = FStyle
			#ifdef __USE_GTK__
				Select Case FStyle
				Case tbsSeparator
					.widget = gtk_widget(gtk_separator_tool_item_new())
				Case Else
					Select Case FStyle
					Case tbsButton, tbsButton Or tbsAutosize
						.widget = gtk_widget(gtk_tool_button_new(NULL, ToUTF8(FCaption)))
					Case tbsAutosize
						.widget = gtk_widget(gtk_tool_button_new(NULL, ToUTF8(FCaption)))
					Case tbsCheck, tbsCheck Or tbsAutosize
						.widget = gtk_widget(gtk_toggle_tool_button_new())
					Case tbsCheckGroup, tbsCheckGroup Or tbsAutosize
						If FButtons.Count > 1 AndAlso gtk_is_radio_tool_button(QToolButton(FButtons.Item(FButtons.Count - 2)).widget) Then
							.widget = gtk_widget(gtk_radio_tool_button_new_from_widget(gtk_radio_tool_button(QToolButton(FButtons.Item(FButtons.Count - 2)).widget)))
						Else
							.widget = gtk_widget(gtk_radio_tool_button_new(NULL))
						End If
					Case tbsGroup, tbsGroup Or tbsAutosize
						If FButtons.Count > 1 AndAlso gtk_is_radio_tool_button(QToolButton(FButtons.Item(FButtons.Count - 2)).widget) Then
							.widget = gtk_widget(gtk_radio_tool_button_new_from_widget(gtk_radio_tool_button(QToolButton(FButtons.Item(FButtons.Count - 2)).widget)))
						Else
							.widget = gtk_widget(gtk_radio_tool_button_new(NULL))
						End If
					Case tbsDropDown, tbsDropDown Or tbsAutosize
						.widget = gtk_widget(gtk_menu_tool_button_new(NULL, ToUTF8(FCaption)))
						gtk_menu_tool_button_set_menu(gtk_menu_tool_button(.widget), .DropDownMenu.widget)
					Case tbsNoPrefix
						.widget = gtk_widget(gtk_tool_button_new(NULL, ToUTF8(FCaption)))
					Case tbsShowText, tbsShowText Or tbsAutosize
						.widget = gtk_widget(gtk_tool_button_new(NULL, ToUTF8(FCaption)))
					Case tbsWholeDropdown, tbsWholeDropdown Or tbsAutoSize
						.widget = gtk_widget(gtk_menu_tool_button_new(NULL, ToUTF8(FCaption)))
						gtk_menu_tool_button_set_menu(gtk_menu_tool_button(.widget), .DropDownMenu.widget)
					Case Else
						.widget = gtk_widget(gtk_tool_button_new(NULL, ToUTF8(FCaption)))
					End Select
					gtk_tool_item_set_tooltip_text(gtk_tool_item(.widget), ToUTF8(FHint))
					g_signal_connect(.widget, "clicked", G_CALLBACK(@ToolButtonClicked), PButton)
				End Select
				gtk_widget_show_all(.widget)
			#endif
			.State        = FState
			.ImageIndex     = FImageIndex
			.Hint           = FHint
			.ShowHint       = FShowHint
			.Name         = FKey
			.Caption        = FCaption
			.CommandID      = 10 + FButtons.Count
			.OnClick        = FClick
		End With
		PButton->Ctrl = Parent
		#ifdef __USE_GTK__
			If Parent Then
				gtk_toolbar_insert(gtk_toolbar(Parent->widget), gtk_tool_item(PButton->widget), Index)
			End If
		#else
			Dim As TBBUTTON TB
			TB.fsState   = FState
			TB.fsStyle   = FStyle
			TB.iBitmap   = PButton->ImageIndex
			TB.idCommand = PButton->CommandID
			If FCaption <> "" Then
				TB.iString = CInt(@FCaption)
			Else
				TB.iString = 0
			End If
			TB.dwData = Cast(DWord_Ptr,@PButton->DropDownMenu)
			If Parent Then
				If Index <> -1 Then
					Parent->Perform(TB_INSERTBUTTON,Index,CInt(@TB))
				Else
					Parent->Perform(TB_ADDBUTTONS,1,CInt(@TB))
				End If
			End If
		#endif
		Return PButton
	End Function
	
	Function ToolButtons.Add(FStyle As Integer = tbsAutosize, ByRef ImageKey As WString, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As Integer = tstEnabled) As ToolButton Ptr
		Dim As ToolButton Ptr PButton
		If Parent AndAlso Cast(ToolBar Ptr, Parent)->ImagesList Then
			With *Cast(ToolBar Ptr, Parent)->ImagesList
				PButton = Add(FStyle, .IndexOf(ImageKey), Index, FClick, FKey, FCaption, FHint, FShowHint, FState)
			End With
		Else
			PButton = Add(FStyle, -1, Index, FClick, FKey, FCaption, FHint, FShowHint, FState)
		End If
		If PButton Then PButton->ImageKey         = ImageKey
		Return PButton
	End Function
	
	Sub ToolButtons.Remove(Index As Integer)
		FButtons.Remove Index
		If Parent Then
			#ifndef __USE_GTK__
				Parent->Perform(TB_DELETEBUTTON,Index,0)
			#endif
		End If
	End Sub
	
	Function ToolButtons.IndexOf(ByRef FButton As ToolButton Ptr) As Integer
		Return FButtons.IndexOF(FButton)
	End Function
	
	Function ToolButtons.IndexOf(ByRef Key As WString) As Integer
		For i As Integer = 0 To Count - 1
			If QToolButton(FButtons.Items[i]).Name = Key Then Return i
		Next i
		Return -1
	End Function
	
	Sub ToolButtons.Clear
		For i As Integer = Count -1 To 0 Step -1
			Delete @QToolButton(FButtons.Items[i])
		Next i
		FButtons.Clear
	End Sub
	
	Operator ToolButtons.Cast As Any Ptr
		Return @This
	End Operator
	
	Constructor ToolButtons
		This.Clear
	End Constructor
	
	Destructor ToolButtons
		This.Clear
	End Destructor
	
	Property ToolBar.AutoSize As Boolean
		#IfNDef __USE_GTK__
			FAutoSize = StyleExists(TBSTYLE_AUTOSIZE)
		#EndIf
		Return FAutoSize
	End Property
	
	Property ToolBar.AutoSize(Value As Boolean)
		FAutoSize = Value
		#IfNDef __USE_GTK__
			ChangeStyle TBSTYLE_AUTOSIZE, Value
			If FHandle Then if FAutosize Then Perform(TB_AUTOSIZE, 0, 0)
		#EndIf
	End Property
	
	Property ToolBar.Flat As Boolean
		#IfNDef __USE_GTK__
			FFlat = StyleExists(TBSTYLE_FLAT)
		#EndIf
		Return FFlat
	End Property
	
	Property ToolBar.Flat(Value As Boolean)
		FFlat = Value
		#IfNDef __USE_GTK__
			ChangeStyle TBSTYLE_FLAT, Value
		#EndIf
	End Property
	
	Property ToolBar.List As Boolean
		#IfNDef __USE_GTK__
			FList = StyleExists(TBSTYLE_LIST)
		#EndIf
		Return FList
	End Property
	
	Property ToolBar.List(Value As Boolean)
		FList = Value
		#IfDef __USE_GTK__
			gtk_toolbar_set_style(gtk_toolbar(widget), IIF(Value, GTK_TOOLBAR_BOTH_HORIZ, GTK_TOOLBAR_BOTH))
		#Else
			ChangeStyle TBSTYLE_LIST, Value
		#EndIf
	End Property
	
	
	Property ToolBar.Divider As Boolean
		#IfNDef __USE_GTK__
			FDivider = Not StyleExists(CCS_NODIVIDER)
		#EndIf
		Return FDivider
	End Property
	
	Property ToolBar.Divider(Value As Boolean)
		FDivider = Value
		#IfNDef __USE_GTK__
			ChangeStyle CCS_NODIVIDER, Not Value
		#EndIf
	End Property
	
	Property ToolBar.Transparency As Boolean
		#IfNDef __USE_GTK__
			FTransparent = StyleExists(TBSTYLE_TRANSPARENT)
		#EndIf
		Return FTransparent
	End Property
	
	Property ToolBar.Transparency(Value As Boolean)
		FTransparent = Value
		#IfNDef __USE_GTK__
			ChangeStyle TBSTYLE_TRANSPARENT, Value
		#EndIf
	End Property
	
	Property ToolBar.ButtonWidth As Integer
		Return FButtonWidth
	End Property
	
	Property ToolBar.ButtonWidth(Value As Integer)
		FButtonWidth = Value
		#IfNDef __USE_GTK__
			If Handle Then Perform(TB_SETBUTTONSIZE,0,MakeLong(FButtonWidth,FButtonHeight))
		#EndIf
	End Property
	
	Property ToolBar.ButtonHeight As Integer
		Return FButtonHeight
	End Property
	
	Property ToolBar.ButtonHeight(Value As Integer)
		FButtonHeight = Value
		#IfNDef __USE_GTK__
			If Handle Then Perform(TB_SETBUTTONSIZE,0,MakeLong(FButtonWidth,FButtonHeight))
		#EndIf
	End Property
	
	Property ToolBar.Wrapable As Boolean
		#IfNDef __USE_GTK__
			FWrapable = StyleExists(TBSTYLE_WRAPABLE)
		#EndIf
		Return FWrapable
	End Property
	
	Property ToolBar.Wrapable(Value As Boolean)
		FWrapable = Value
		#IfNDef __USE_GTK__
			ChangeStyle TBSTYLE_WRAPABLE, Value
		#EndIf
	End Property
	
	Property ToolBar.Caption ByRef As WString
		Return Text
	End Property
	
	Property ToolBar.Caption(ByRef Value As WString)
		Text = Value
	End Property
	
	Sub ToolBar.WndProc(ByRef Message As Message)
	End Sub
	
	Sub ToolBar.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Select Case Message.Msg
			Case WM_PAINT
				Message.Result = 0
			Case WM_SIZE
				If AutoSize Then
					Dim As Rect R
					GetWindowRect Handle,@R
					FHeight = R.Bottom - R.Top
				End If
			Case WM_COMMAND
				GetDropDownMenuItems
				For i As Integer = 0 To FPopupMenuItems.Count -1
					If QMenuItem(FPopupMenuItems.Items[i]).Command = Message.wParamLo Then
						If QMenuItem(FPopupMenuItems.Items[i]).OnClick Then QMenuItem(FPopupMenuItems.Items[i]).OnClick(QMenuItem(FPopupMenuItems.Items[i]))
						Exit For
					End If
				Next i
			Case CM_COMMAND
				Dim As Integer Index
				Dim As TBBUTTON TB
				If Message.wParam <> 0 Then
					Index = Perform(TB_COMMANDTOINDEX, Message.wParam, 0)
					If Perform(TB_GETBUTTON, Index, CInt(@TB)) Then
						If Buttons.Item(Index)->OnClick Then (Buttons.Item(Index))->OnClick(*Buttons.Item(Index))
					End If
				End If
			Case CM_NOTIFY
				Dim As TBNOTIFY Ptr Tbn
				Dim As TBBUTTON TB
				Dim As RECT R
				Dim As Integer i
				Tbn = Cast(TBNOTIFY Ptr,Message.lParam)
				Select Case Tbn->hdr.Code
				Case TBN_DROPDOWN
					If Tbn->iItem <> -1 Then
						SendMessage(Tbn->hdr.hwndFrom,TB_GETRECT,Tbn->iItem,CInt(@R))
						MapWindowPoints(Tbn->hdr.hwndFrom,0,Cast(Point Ptr,@R),2)
						i = SendMessage(Tbn->hdr.hwndFrom,TB_COMMANDTOINDEX,Tbn->iItem,0)
						If SendMessage(Tbn->hdr.hwndFrom,TB_GETBUTTON,i,CInt(@TB)) Then
							TrackPopupMenu(Buttons.Item(i)->DropDownMenu.Handle,0,R.Left,R.Bottom,0,Tbn->hdr.hwndFrom,NULL)
						End If
					End If
				End Select
			Case CM_NEEDTEXT
				Dim As LPTOOLTIPTEXT TTX
				TTX = Cast(LPTOOLTIPTEXT,Message.lParam)
				TTX->hInst = GetModuleHandle(NULL)
				If TTX->hdr.idFrom Then
					Dim As TBButton TB
					Dim As Integer Index
					Index = Perform(TB_COMMANDTOINDEX,TTX->hdr.idFrom,0)
					If Perform(TB_GETBUTTON,Index,CInt(@TB)) Then
						If Buttons.Item(Index)->ShowHint Then
							If Buttons.Item(Index)->Hint <> "" Then
								'Dim As UString s
								's = Buttons.Button(Index).Hint
								TTX->lpszText = @(Buttons.Item(Index)->Hint)
							End If
						End If
					End If
				End If
			End Select
		#endif
		Base.ProcessMessage(message)
	End Sub
	
	Sub ToolBar.HandleIsDestroyed(ByRef Sender As Control)
	End Sub
	
	Sub ToolBar.HandleIsAllocated(ByRef Sender As Control)
		If Sender.Child Then
			With QToolBar(Sender.Child)
				#ifndef __USE_GTK__
					If .ImagesList Then .ImagesList->ParentWindow = @Sender: If .ImagesList->Handle Then .Perform(TB_SETIMAGELIST,0,CInt(.ImagesList->Handle))
					If .HotImagesList Then .HotImagesList->ParentWindow = @Sender: If .HotImagesList->Handle Then .Perform(TB_SETHOTIMAGELIST,0,CInt(.HotImagesList->Handle))
					If .DisabledImagesList Then .DisabledImagesList->ParentWindow = @Sender: If .DisabledImagesList->Handle Then .Perform(TB_SETDISABLEDIMAGELIST,0,CInt(.DisabledImagesList->Handle))
					.Perform(TB_BUTTONSTRUCTSIZE,SizeOf(TBBUTTON),0)
					.Perform(TB_SETEXTENDEDSTYLE, 0, .Perform(TB_GETEXTENDEDSTYLE, 0, 0) Or TBSTYLE_EX_DRAWDDARROWS)
					.Perform(TB_SETBUTTONSIZE,0,MakeLong(.ButtonWidth,.ButtonHeight))
					.Perform(TB_SETBITMAPSIZE,0,MakeLong(.ButtonWidth,.ButtonHeight))
					For i As Integer = 0 To .Buttons.Count - 1
						Dim As TBBUTTON TB
						'Dim As WString Ptr s = .Buttons.Button(i)->Caption
						TB.fsState   = .Buttons.Item(i)->State
						TB.fsStyle   = .Buttons.Item(i)->Style
						TB.iBitmap   = .Buttons.Item(i)->ImageIndex
						TB.idCommand = .Buttons.Item(i)->CommandID
						If .Buttons.Item(i)->Caption <> "" Then
							TB.iString   = CInt(@.Buttons.Item(i)->Caption)
						Else
							TB.iString   = 0
						End If
						TB.dwData    = Cast(DWord_Ptr,@.Buttons.Item(i)->DropDownMenu)
						.Perform(TB_ADDBUTTONS,1,CInt(@TB))
						If Not .Buttons.Item(i)->Visible Then .Perform(TB_HIDEBUTTON, .Buttons.Item(i)->CommandID, MakeLong(True, 0))
					Next i
					If .AutoSize Then .Perform(TB_AUTOSIZE,0,0)
				#endif
				If .DesignMode Then
					.Buttons.Add
				End If
			End With
		End If
	End Sub
	
	Operator ToolBar.Cast As Control Ptr
		Return @This
	End Operator
	
	Constructor ToolBar
		With This
			FButtonWidth    = 16
			FButtonHeight   = 16
			#ifdef __USE_GTK__
				widget = gtk_toolbar_new()
				.RegisterClass "ToolBar", @This
			#else
				AFlat(0)        = 0
				AFlat(1)        = TBSTYLE_FLAT
				ADivider(0)     = CCS_NODIVIDER
				ADivider(1)     = 0
				AAutosize(0)    = 0
				AAutosize(1)    = TBSTYLE_AUTOSIZE
				AList(0)        = 0
				AList(1)        = TBSTYLE_LIST
				AState(0)       = TBSTATE_INDETERMINATE
				AState(1)       = TBSTATE_ENABLED
				AState(2)       = TBSTATE_HIDDEN
				AState(3)       = TBSTATE_CHECKED
				AState(4)       = TBSTATE_PRESSED
				AState(5)       = TBSTATE_WRAP
				AWrap(0)        = 0
				AWrap(1)        = TBSTYLE_WRAPABLE
				ATransparent(0) = 0
				ATransparent(1) = TBSTYLE_TRANSPARENT
			#endif
			FTransparent    = 1
			FAutosize       = 1
			FButtonWidth    = 16
			FButtonHeight   = 16
			Buttons.Parent  = This
			FEnabled = True
			#ifndef __USE_GTK__
				.OnHandleIsAllocated = @HandleIsAllocated
				.OnHandleIsDestroyed = @HandleIsDestroyed
				.ChildProc         = @WndProc
				.ExStyle           = 0
				.Style             = WS_CHILD Or TBSTYLE_TOOLTIPS Or CCS_NOPARENTALIGN Or CCS_NOMOVEY Or AList(FList) Or AAutosize(_Abs(FAutosize)) Or AFlat(_Abs(FFlat)) Or ADivider(_Abs(FDivider)) Or AWrap(_Abs(FWrapable)) Or ATransparent(_Abs(FTransparent))
				.RegisterClass "ToolBar", "ToolBarWindow32"
			#endif
			.Child             = @This
			WLet FClassName, "ToolBar"
			WLet FClassAncestor, "ToolBarWindow32"
			.Width             = 121
			#ifdef __USE_GTK__
				.Height            = 30
			#else
				.Height            = 26
			#endif
			'.Font              = @Font
			'.Cursor            = @Cursor
		End With
	End Constructor
	
	Destructor ToolBar
		Buttons.Clear
		#ifndef __USE_GTK__
			'UnregisterClass "ToolBar", GetmoduleHandle(NULL)
		#endif
	End Destructor
End Namespace

#ifdef __EXPORT_PROCS__
	Function ToolBarAddButtonWithImageIndex Alias "ToolBarAddButtonWithImageIndex"(tb As My.Sys.Forms.ToolBar Ptr, FStyle As Integer = My.Sys.Forms.tbsAutosize, FImageIndex As Integer = -1, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As Integer = My.Sys.Forms.tstEnabled) As My.Sys.Forms.ToolButton Ptr Export
		Return tb->Buttons.Add(FStyle, FImageIndex, Index, FClick, FKey, FCaption, FHint, FShowHint, FState)
	End Function
	
	Function ToolBarAddButtonWithImageKey Alias "ToolBarAddButtonWithImageKey"(tb As My.Sys.Forms.ToolBar Ptr, FStyle As Integer = My.Sys.Forms.tbsAutosize, ByRef ImageKey As WString, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As Integer = My.Sys.Forms.tstEnabled) As My.Sys.Forms.ToolButton Ptr Export
		Return tb->Buttons.Add(FStyle, ImageKey, Index, FClick, FKey, FCaption, FHint, FShowHint, FState)
	End Function
	
	Sub ToolBarRemoveButton Alias "ToolBarRemoveButton"(tb As My.Sys.Forms.ToolBar Ptr, Index As Integer) Export
		tb->Buttons.Remove Index
	End Sub
	
	Function ToolBarIndexOfButton Alias "ToolBarIndexOfButton"(tb As My.Sys.Forms.ToolBar Ptr, Btn As My.Sys.Forms.ToolButton Ptr) As Integer Export
		Return tb->Buttons.IndexOf(Btn)
	End Function
#EndIf
