'###############################################################################
'#  Header.bi                                                                  #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   THeader.bi                                                                #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Modified by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                      #
'###############################################################################

#include once "Header.bi"

Namespace My.Sys.Forms
	'HeaderSection
	
	Private Property HeaderSection.Style As HeaderSectionStyle
		Return FStyle
	End Property
	
	Private Property HeaderSection.Style(Value As HeaderSectionStyle)
		If Value <> FStyle Then
			FStyle = Value
			QHeader(HeaderControl).UpdateItems
		End If
	End Property
	
	Private Property HeaderSection.Caption ByRef As WString
		Return WGet(FCaption)
	End Property
	
	Private Property HeaderSection.Caption(ByRef Value As WString)
		WLet(FCaption, Value)
		QHeader(HeaderControl).UpdateItems
		#ifdef __USE_GTK__
			If Handle Then
				If LabelHandle Then
					gtk_label_set_label(gtk_label(LabelHandle), ToUTF8(Value))
				Else
					gtk_tree_view_column_set_title(Handle, ToUTF8(Value))
				End If
			End If
		#endif
	End Property
	
	Private Property HeaderSection.Alignment As Integer
		Return FAlignment
	End Property
	
	Private Property HeaderSection.Alignment(Value As Integer)
		If Value <> FAlignment Then
			FAlignment = Value
			QHeader(HeaderControl).UpdateItems
			#ifdef __USE_GTK__
				If Handle Then
					Select Case Value
					Case 0: gtk_tree_view_column_set_alignment(Handle, 0.0)
					Case 1: gtk_tree_view_column_set_alignment(Handle, 0.5)
					Case 2: gtk_tree_view_column_set_alignment(Handle, 1.0)
					Case 3: gtk_tree_view_column_set_alignment(Handle, 1.0)
					End Select
				End If
			#endif
		End If
	End Property
	
	Private Property HeaderSection.ImageIndex As Integer
		Return FImageIndex
	End Property
	
	Private Property HeaderSection.ImageIndex(Value As Integer)
		If Value <> FImageIndex Then
			FImageIndex = Value
			QHeader(HeaderControl).UpdateItems
			#ifdef __USE_GTK__
				ImageHandle = gtk_image_new_from_icon_name(ToUTF8(HeaderControl->Images->Items.Get(FImageIndex)), GTK_ICON_SIZE_MENU)
			#endif
		End If
	End Property
	
	Private Property HeaderSection.ImageKey ByRef As WString
		Return WGet(FImageKey)
	End Property
	
	Private Property HeaderSection.ImageKey(ByRef Value As WString)
		If Value <> *FImageKey Then
			WLet FImageKey, Value
			If HeaderControl AndAlso HeaderControl->Images Then FImageIndex = HeaderControl->Images->IndexOf(*FImageKey)
			QHeader(HeaderControl).UpdateItems
			#ifdef __USE_GTK__
				If HeaderControl AndAlso HeaderControl->Images Then ImageHandle = gtk_image_new_from_icon_name(ToUTF8(HeaderControl->Images->Items.Get(FImageIndex)), GTK_ICON_SIZE_MENU)
			#endif
		End If
	End Property
	
	Private Property HeaderSection.Resizable As Boolean
		Return FResizable
	End Property
	
	Private Property HeaderSection.Resizable(Value As Boolean)
		If Value <> FResizable Then
			FResizable = Value
			QHeader(HeaderControl).UpdateItems
			#ifdef __USE_GTK__
				gtk_tree_view_column_set_resizable(Handle, Value)
			#endif
		End If
	End Property
	
	Private Property HeaderSection.Width As Integer
		#ifdef __USE_GTK__
			If Handle Then
				FWidth = gtk_tree_view_column_get_width(Handle)
			End If
		#endif
		Return FWidth
	End Property
	
	Private Property HeaderSection.Width(Value As Integer)
		If Value <> FWidth Then
			FWidth = Value
			QHeader(HeaderControl).UpdateItems
			#ifdef __USE_GTK__
				If Handle Then
					If FWidth = -1 Then
						gtk_tree_view_column_set_sizing(Handle, GTK_TREE_VIEW_COLUMN_AUTOSIZE)
					Else
						gtk_tree_view_column_set_sizing(Handle, GTK_TREE_VIEW_COLUMN_FIXED)
						gtk_tree_view_column_set_fixed_width(Handle, Max(1, FWidth))
					End If
				End If
			#endif
		End If
	End Property
	
	Private Operator HeaderSection.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Constructor HeaderSection
		#ifndef __USE_GTK__
			AFmt(0)         = HDF_LEFT
			AFmt(1)         = HDF_CENTER
			AFmt(2)         = HDF_RIGHT
			AFmt(3)         = HDF_RTLREADING
		#endif
		WLet(FCaption, "")
		FImageIndex     = -1
		FAlignment      = 0
		FWidth          = 50
	End Constructor
	
	Private Destructor HeaderSection
	End Destructor
	
	'Header
	Private Function Header.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "dragreorder": Return @FDragReorder
		Case "fulldrag": Return @FFullDrag
		Case "hottrack": Return @FHotTrack
		Case "sectioncount": FSectionCount = SectionCount: Return @FSectionCount
		Case "style": Return @FStyle
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Private Function Header.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "dragreorder": If Value <> 0 Then This.DragReorder = QBoolean(Value)
		Case "fulldrag": If Value <> 0 Then This.FullDrag = QBoolean(Value)
		Case "hottrack": If Value <> 0 Then This.HotTrack = QBoolean(Value)
		Case "style": If Value <> 0 Then This.Style = *Cast(HeaderStyle Ptr, Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Private Property Header.Style As HeaderStyle
		Return FStyle
	End Property
	
	Private Property Header.Style(Value As HeaderStyle)
		If FStyle <> Value Then
			FStyle = Value
			#ifdef __USE_GTK__
				For i As Integer = 0 To FSections.Count - 1
					gtk_tree_view_column_set_clickable(Section(i)->Handle, Value = HeaderStyle.hsNormal)
				Next
			#else
				ChangeStyle HDS_BUTTONS, Not Value
				'Base.Style = WS_CHILD Or AStyle(Abs_(FStyle)) Or AFullDrag(Abs_(FFullDrag)) Or AHotTrack(Abs_(FHotTrack)) Or ADragReorder(Abs_(FDragReorder))
			#endif
		End If
	End Property
	
	Private Property Header.HotTrack As Boolean
		Return FHotTrack
	End Property
	
	Private Property Header.HotTrack(Value As Boolean)
		If FHotTrack <> Value Then
			FHotTrack = Value
			#ifndef __USE_GTK__
				ChangeStyle HDS_HOTTRACK, Value
				'Base.Style = WS_CHILD Or AStyle(Abs_(FStyle)) Or AFullDrag(Abs_(FFullDrag)) Or AHotTrack(Abs_(FHotTrack)) Or ADragReorder(Abs_(FDragReorder))
			#endif
		End If
	End Property
	
	Private Property Header.FullDrag As Boolean
		Return FFullDrag
	End Property
	
	Private Property Header.FullDrag(Value As Boolean)
		If FFullDrag <> Value Then
			FFullDrag = Value
			#ifndef __USE_GTK__
				ChangeStyle HDS_FULLDRAG, Value
				'Base.Style = WS_CHILD Or AStyle(Abs_(FStyle)) Or AFullDrag(Abs_(FFullDrag)) Or AHotTrack(Abs_(FHotTrack)) Or ADragReorder(Abs_(FDragReorder))
			#endif
		End If
	End Property
	
	Private Property Header.DragReorder As Boolean
		Return FDragReorder
	End Property
	
	Private Property Header.DragReorder(Value As Boolean)
		If FDragReorder <> Value Then
			DragReorder = Value
			#ifdef __USE_GTK__
				For i As Integer = 0 To FSections.Count - 1
					gtk_tree_view_column_set_reorderable(gtk_tree_view_column(Section(i)->Handle), Value)
				Next
			#else
				ChangeStyle HDS_DRAGDROP, Value
				'Base.Style = WS_CHILD Or AStyle(Abs_(FStyle)) Or AFullDrag(Abs_(FFullDrag)) Or AHotTrack(Abs_(FHotTrack)) Or ADragReorder(Abs_(FDragReorder))
			#endif
		End If
	End Property
	
	Private Property Header.Resizable As Boolean
		Return FResizable
	End Property
	
	Private Property Header.Resizable(Value As Boolean)
		If FResizable <> Value Then
			FResizable = Value
			#ifdef __USE_GTK__
				For i As Integer = 0 To FSections.Count - 1
					gtk_tree_view_column_set_resizable(gtk_tree_view_column(Section(i)->Handle), Value)
				Next
			#else
				'Const HDS_NOSIZING = &h800
				#if _WIN32_WINNT >= &h0600
					ChangeStyle HDS_NOSIZING, Not Value
				#endif
			#endif
		End If
	End Property
	
	Private Property Header.SectionCount As Integer
		FSectionCount = FSections.Count
		Return FSectionCount
	End Property
	
	Private Property Header.SectionCount(Value As Integer)
		FSectionCount = FSections.Count
	End Property
	
	Private Property Header.Section(Index As Integer) As HeaderSection Ptr
		If Index >= 0 And Index <= SectionCount -1 Then
			Return QHeaderSection(FSections.Items[Index])
		End If
		Return NULL
	End Property
	
	Private Property Header.Section(Index As Integer, Value As HeaderSection Ptr)
		If Index >= 0 And Index <= SectionCount -1 Then
			FSections.Items[Index] = Value
		End If
	End Property
	
	Private Property Header.Captions(Index As Integer) ByRef As WString
		If Index >= 0 And Index <= SectionCount -1 Then
			Return QHeaderSection(FSections.Items[Index]).Caption
		Else
			Return ""
		End If
	End Property
	
	Private Property Header.Captions(Index As Integer, ByRef Value As WString)
		If Index >= 0 And Index <= SectionCount -1 Then
			QHeaderSection(FSections.Items[Index]).Caption = Value
		End If
	End Property
	
	Private Property Header.Widths(Index As Integer) As Integer
		If Index >= 0 And Index <= SectionCount -1 Then
			Return QHeaderSection(FSections.Items[Index]).Width
		Else
			Return 0
		End If
	End Property
	
	Private Property Header.Widths(Index As Integer, Value As Integer)
		If Index >= 0 And Index <= SectionCount -1 Then
			QHeaderSection(FSections.Items[Index]).Width = Value
		End If
	End Property
	
	Private Property Header.Alignments(Index As Integer) As Integer
		If Index >= 0 And Index <= SectionCount -1 Then
			Return QHeaderSection(FSections.Items[Index]).Alignment
		Else
			Return 0
		End If
	End Property
	
	Private Property Header.Alignments(Index As Integer, Value As Integer)
		If Index >= 0 And Index <= SectionCount -1 Then
			QHeaderSection(FSections.Items[Index]).Alignment = Value
		End If
	End Property
	
	Private Property Header.ImageIndexes(Index As Integer) As Integer
		If Index >= 0 And Index <= SectionCount -1 Then
			Return QHeaderSection(FSections.Items[Index]).ImageIndex
		Else
			Return -1
		End If
	End Property
	
	Private Property Header.ImageIndexes(Index As Integer, Value As Integer)
		If Index >= 0 And Index <= SectionCount -1 Then
			QHeaderSection(FSections.Items[Index]).ImageIndex = Value
		End If
	End Property
	
	Private Sub Header.UpdateItems
		#ifndef __USE_GTK__
			Dim As HDITEM HI
			For i As Integer = SectionCount -1 To 0 Step -1
				Perform(HDM_DELETEITEM, i, 0)
			Next i
			For i As Integer = 0 To SectionCount - 1
				HI.mask       = HDI_FORMAT Or HDI_WIDTH Or HDI_LPARAM Or HDI_TEXT
				HI.pszText    = @QHeaderSection(FSections.Items[I]).Caption
				HI.cchTextMax = Len(QHeaderSection(FSections.Items[I]).Caption)
				HI.cxy        = QHeaderSection(FSections.Items[I]).Width
				HI.fmt        = AFmt(QHeaderSection(FSections.Items[I]).Alignment)
				HI.iImage     = QHeaderSection(FSections.Items[I]).ImageIndex
				If HI.iImage <> -1 Then
					HI.mask = HI.mask Or HDI_IMAGE
					HI.fmt = HI.fmt Or HDF_IMAGE
				End If
				If QHeaderSection(FSections.Items[I]).Style > 0 Then
					HI.fmt = HI.fmt Or HDF_OWNERDRAW
				Else
					HI.fmt = HI.fmt Or HDF_STRING
				End If
				If FResizable AndAlso Not QHeaderSection(FSections.Items[I]).Resizable Then
					#if _WIN32_WINNT >= &h0600
						HI.fmt = HI.fmt Or HDF_FIXEDWIDTH
					#endif
				End If
				HI.hbm        = NULL
				HI.lParam     = Cast(LParam, FSections.Items[I])
				Perform(HDM_INSERTITEM, i, CInt(@HI))
			Next i
		#endif
	End Sub
	
	#ifndef __USE_GTK__
		Private Sub Header.HandleIsAllocated(ByRef Sender As Control)
			Dim As HDITEM HI
			If Sender.Child Then
				With QHeader(Sender.Child)
					If .Images Then 
						.Images->ParentWindow = @Sender
						SendMessage(.Handle, HDM_SETIMAGELIST, 0, Cast(LPARAM, .Images->Handle))
					End If
					For i As Integer = 0 To .SectionCount - 1
						HI.mask       = HDI_FORMAT Or HDI_WIDTH Or HDI_LPARAM Or HDI_TEXT
						HI.pszText    = @QHeaderSection(.FSections.Items[I]).Caption
						HI.cchTextMax = Len(QHeaderSection(.FSections.Items[I]).Caption)
						HI.cxy        = QHeaderSection(.FSections.Items[I]).Width
						HI.fmt        = .AFmt(QHeaderSection(.FSections.Items[I]).Alignment)
						HI.iImage     = QHeaderSection(.FSections.Items[I]).ImageIndex
						If HI.iImage <> -1 Then
							HI.mask = HI.mask Or HDI_IMAGE
							HI.fmt = HI.fmt Or HDF_IMAGE
						End If
						If QHeaderSection(.FSections.Items[I]).Style > 0 Then
							HI.fmt = HI.fmt Or HDF_OWNERDRAW
						Else
							HI.fmt = HI.fmt Or HDF_STRING
						End If
						HI.hbm        = NULL
						HI.lParam     = Cast(LParam, .FSections.Items[I])
						.Perform(HDM_INSERTITEM, i, CInt(@HI))
					Next i
				End With
			End If
		End Sub
		
		Private Sub Header.WndProc(ByRef Message As Message)
			If Message.Sender Then
			End If
		End Sub
	#endif
	
	Private Function Header.EnumMenuItems(Item As MenuItem, ByRef List As List) As Boolean
		For i As Integer = 0 To Item.Count -1
			List.Add Item.Item(i)
			EnumMenuItems *Item.Item(i), List
		Next i
		Return True
	End Function
	
	Private Sub Header.Init()
		#ifdef __USE_GTK__
			If gtk_tree_view_get_model(GTK_TREE_VIEW(widget)) = NULL Then
				If ColumnTypes Then Delete_SquareBrackets(ColumnTypes)
				ColumnTypes = New_(GType[FSections.Count + 1])
				For i As Integer = 0 To FSections.Count
					ColumnTypes[i] = G_TYPE_STRING
				Next i
				gtk_list_store_set_column_types(ListStore, FSections.Count, ColumnTypes)
				gtk_tree_view_set_model(GTK_TREE_VIEW(widget), GTK_TREE_MODEL(ListStore))
			End If
		#endif
	End Sub
	
	Private Sub Header.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_GTK__
			Dim As GdkEvent Ptr e = Message.event
			Select Case Message.event->Type
			Case GDK_MAP
				Init
			End Select
		#else
			Static As Boolean IsMenuItem
			Select Case Message.Msg
			Case WM_RBUTTONDOWN
				'PopupMenu.Window = FHandle
				'PopupMenu.Popup(Message.lParamLo, Message.lParamHi)
			Case CM_NOTIFY
				Dim As HD_NOTIFY Ptr HDN
				Dim As Integer ItemIndex, MouseButton
				HDN = Cast(HD_NOTIFY Ptr, Message.lParam)
				ItemIndex   = HDN->iItem
				MouseButton = HDN->iButton
				Select Case HDN->hdr.code
				Case HDN_BEGINTRACK
					If OnBeginTrack Then OnBeginTrack(This, QHeaderSection(FSections.Items[ItemIndex]))
				Case HDN_ENDTRACK
					If OnEndTrack Then OnEndTrack(This, QHeaderSection(FSections.Items[ItemIndex]))
				Case HDN_DIVIDERDBLCLICK
					If OnDividerDblClick Then OnDividerDblClick(This, ItemIndex,MouseButton)
				Case HDN_ITEMCHANGED
					Dim As HD_ITEM Ptr HI
					HI = Cast(HD_ITEM Ptr,HDN->pItem)
					QHeaderSection(FSections.Items[ItemIndex]).Width = HI->cxy
					If OnChange Then OnChange(This,QHeaderSection(FSections.Items[ItemIndex]))
				Case HDN_ITEMCHANGING
					Dim As HD_ITEM Ptr HI
					HI = Cast(HD_ITEM Ptr,HDN->pItem)
					Dim bCancel As Boolean
					If OnChanging Then OnChanging(This, QHeaderSection(FSections.Items[ItemIndex]), bCancel)
					If bCancel Then Message.Result = -1: Exit Sub Else QHeaderSection(FSections.Items[ItemIndex]).Width = HI->cxy
				Case HDN_ITEMCLICK
					If OnSectionClick Then OnSectionClick(This, QHeaderSection(FSections.Items[ItemIndex]), ItemIndex, MouseButton)
				Case HDN_ITEMDBLCLICK
					If OnSectionDblClick Then OnSectionDblClick(This, QHeaderSection(FSections.Items[ItemIndex]), ItemIndex, MouseButton)
				Case HDN_TRACK
					If OnTrack Then OnTrack(This, QHeaderSection(FSections.Items[ItemIndex]))
				End Select
			Case CM_DRAWITEM
				Dim As DRAWITEMSTRUCT Ptr Dis
				Dis = Cast(DRAWITEMSTRUCT Ptr, Message.lParam)
				Dim As My.Sys.Drawing.Rect R = *Cast(My.Sys.Drawing.Rect Ptr, @Dis->rcItem)
				Dim As Integer Index = Dis->ItemID, State = Dis->itemState
				If OnDrawSection Then OnDrawSection(This, QHeaderSection(FSections.Items[Index]), R, State And ODS_SELECTED <> 0)
			Case WM_MENUSELECT
				IsMenuItem = True
			Case WM_COMMAND
				Static As List List
				Dim As MenuItem Ptr Item
				If IsMenuItem Then
					List.Clear
					For i As Integer = 0 To ContextMenu->Count -1
						EnumMenuItems(*ContextMenu->Item(i), List)
					Next i
					For i As Integer = 0 To List.Count - 1
						If QMenuItem(List.Items[i]).Command = Message.wParamLo Then
							If QMenuItem(List.Items[i]).OnClick Then QMenuItem(List.Items[i]).OnClick(QMenuItem(List.Items[i]))
							Exit For
						End If
					Next i
					IsMenuItem = False
				End If
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	#ifdef __USE_GTK__
		Private Sub Header.Column_Clicked(treeviewcolumn As GtkTreeViewColumn Ptr, user_data As Any Ptr)
			Dim As HeaderSection Ptr hsec = user_data
			Dim As Header Ptr hdr = hsec->HeaderControl
			If hdr->OnSectionClick Then hdr->OnSectionClick(*hdr, *hsec, hdr->FSections.IndexOf(hsec), 0)
		End Sub
		
		Private Function Header.Column_Draw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Dim As HeaderSection Ptr hsec = data1
			Dim As Header Ptr hdr = hsec->HeaderControl
			Dim As Integer AllocatedWidth = gtk_tree_view_column_get_width(hsec->Handle)
			If AllocatedWidth <> hsec->AllocatedWidth Then
				Dim bCancel As Boolean
				If hdr->OnChanging Then hdr->OnChanging(*hdr, *hsec, bCancel)
				If bCancel Then
					gtk_tree_view_column_set_fixed_width(hsec->Handle, hsec->AllocatedWidth)
					Return False
				End If
				hsec->AllocatedWidth = AllocatedWidth
				If hdr->OnChange Then hdr->OnChange(*hdr, *hsec)
				If hdr->OnTrack Then hdr->OnTrack(*hdr, *hsec)
			End If
			Return False
		End Function
		
		Private Function Header.Column_ExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			Dim As cairo_t Ptr cr = gdk_cairo_create(Event->window)
			Column_Draw(widget, cr, data1)
			cairo_destroy(cr)
			Return False
		End Function
		
		Private Function Header.Column_ButtonPressEvent(widget As GtkWidget Ptr, Event As GdkEvent Ptr, user_data As Any Ptr) As Boolean
			If Event->button.type = GDK_2BUTTON_PRESS Then
				Dim As HeaderSection Ptr hsec = user_data
				Dim As Header Ptr hdr = hsec->HeaderControl
				If hdr->OnSectionDblClick Then hdr->OnSectionDblClick(*hdr, *hsec, hdr->FSections.IndexOf(hsec), Event->button.button - 1)
			End If
			Return False
		End Function
	#endif
	
	Private Function Header.AddSection(ByRef FCaption As WString = "", FImageIndex As Integer = -1, FWidth As Integer = -1, FAlignment As Integer = 0, bResizable As Boolean = True) As HeaderSection Ptr
		Dim As HeaderSection Ptr PSection
		PSection = New_( HeaderSection)
		FSections.Add PSection
		With *PSection
			.HeaderControl = @This
			.Caption       = FCaption
			.ImageIndex    = FImageIndex
			.Alignment     = FAlignment
			.Width         = FWidth
		End With
		
		#ifdef __USE_GTK__
			PSection->Handle = gtk_tree_view_column_new()
			gtk_tree_view_column_set_reorderable(PSection->Handle, FDragReorder)
			Dim As GtkCellRenderer Ptr rendertext = gtk_cell_renderer_text_new()
			gtk_tree_view_column_pack_start(PSection->Handle, rendertext, True)
			gtk_tree_view_column_add_attribute(PSection->Handle, rendertext, ToUTF8("text"), 0)
			gtk_tree_view_column_set_resizable(PSection->Handle, FResizable AndAlso bResizable)
			gtk_tree_view_column_set_clickable(PSection->Handle, FStyle = HeaderStyle.hsNormal)
			If Images Then
				#ifdef __USE_GTK3__
					PSection->BoxHandle = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 1)
				#else
					PSection->BoxHandle = gtk_hbox_new(False, 1)
				#endif
				PSection->ImageHandle = gtk_image_new_from_icon_name(ToUTF8(Images->Items.Get(FImageIndex)), GTK_ICON_SIZE_MENU)
				gtk_container_add (GTK_CONTAINER (PSection->BoxHandle), PSection->ImageHandle)
				PSection->LabelHandle = gtk_label_new(ToUTF8(FCaption))
				gtk_container_add(GTK_CONTAINER (PSection->BoxHandle), PSection->LabelHandle)
				gtk_widget_show_all(PSection->BoxHandle)
				gtk_tree_view_column_set_widget(PSection->Handle, PSection->BoxHandle)
			Else
				#ifdef __USE_GTK3__
					gtk_tree_view_column_set_title(PSection->Handle, ToUTF8(FCaption))
				#else
					PSection->LabelHandle = gtk_label_new(ToUTF8(FCaption))
					gtk_tree_view_column_set_widget(PSection->Handle, PSection->LabelHandle)
					gtk_widget_show_all(PSection->LabelHandle)
				#endif
			End If
			gtk_tree_view_append_column(GTK_TREE_VIEW(FHandle), PSection->Handle)
			#ifdef __USE_GTK3__
				PSection->ButtonHandle = gtk_tree_view_column_get_button(PSection->Handle)
			#else
				If Images Then
					PSection->ButtonHandle = gtk_widget_get_parent(gtk_widget_get_parent(gtk_widget_get_parent(PSection->BoxHandle)))
				Else
					PSection->ButtonHandle = gtk_widget_get_parent(gtk_widget_get_parent(gtk_widget_get_parent(PSection->LabelHandle)))
				End If
			#endif
			If FWidth = -1 Then
				gtk_tree_view_column_set_sizing(PSection->Handle, GTK_TREE_VIEW_COLUMN_AUTOSIZE)
			Else
				gtk_tree_view_column_set_sizing(PSection->Handle, GTK_TREE_VIEW_COLUMN_FIXED)
				gtk_tree_view_column_set_fixed_width(PSection->Handle, Max(1, FWidth))
			End If
			PSection->Alignment = FAlignment
			#ifdef __USE_GTK3__
				g_signal_connect(PSection->ButtonHandle, "draw", G_CALLBACK(@Column_Draw), PSection)
			#else
				g_signal_connect(PSection->ButtonHandle, "expose-event", G_CALLBACK(@Column_ExposeEvent), PSection)
			#endif
			g_signal_connect(PSection->ButtonHandle, "button-press-event", G_CALLBACK(@Column_ButtonPressEvent), PSection)
			g_signal_connect(gtk_tree_view_column(PSection->Handle), "clicked", G_CALLBACK(@Column_Clicked), PSection)
		#else
			Dim As HDITEM HI
			With HI
				.mask       = HDI_FORMAT Or HDI_WIDTH Or HDI_LPARAM Or HDI_TEXT
				.pszText    = @FCaption
				.cchTextMax = Len(FCaption)
				.cxy        = PSection->Width
				.fmt        = AFmt(Abs_(PSection->Alignment))
				.iImage     = FImageIndex
				If .iImage <> -1 Then
					.mask = .mask Or HDI_IMAGE
					.fmt  = .fmt Or HDF_IMAGE
				End If
				If PSection->Style > 0 Then
					.fmt = .fmt Or HDF_OWNERDRAW
				Else
					.fmt = .fmt Or HDF_STRING
				End If
				If FResizable AndAlso Not bResizable Then
					#if _WIN32_WINNT >= &h0600
						.fmt = .fmt Or HDF_FIXEDWIDTH
					#endif
				End If
				.hbm        = NULL
				.lParam     = Cast(LParam, PSection)
			End With
			If Handle Then Perform(HDM_INSERTITEM, SectionCount - 1, CInt(@HI))
		#endif
		Return PSection
	End Function
	
	Private Function Header.AddSection(ByRef FCaption As WString = "", ByRef FImageKey As WString, FWidth As Integer = -1, FAlignment As Integer = 0, bResizable As Boolean = True) As HeaderSection Ptr
		Dim As HeaderSection Ptr PSection
		If Images Then
			PSection = This.AddSection(FCaption, Images->IndexOf(FImageKey), FWidth, FAlignment, bResizable)
		Else
			PSection = This.AddSection(FCaption, -1, FWidth, FAlignment, bResizable)
		End If
		If PSection Then PSection->ImageKey         = FImageKey
		Return PSection
	End Function
	
	Private Sub Header.AddSections cdecl(FCount As Integer, ...)
		Dim As HeaderSection Ptr PSection
		'Dim As Any Ptr Arg
		Dim args As Cva_List
		'Arg = va_first()
		Cva_Start(args, FCount)
		For i As Integer = 0 To FCount - 1
			PSection = New_( HeaderSection)
			With *PSection
				.HeaderControl = @This
				'.Caption       = *va_arg(Arg, WString Ptr)
				.Caption       = *Cva_Arg(args, WString Ptr)
			End With
			FSections.Add PSection
			#ifdef __USE_GTK__
				PSection->Handle = gtk_tree_view_column_new()
				gtk_tree_view_column_set_reorderable(PSection->Handle, FDragReorder)
				gtk_tree_view_column_set_resizable(PSection->Handle, FResizable)
				gtk_tree_view_column_set_clickable(PSection->Handle, FStyle = HeaderStyle.hsNormal)
				gtk_tree_view_column_set_title(PSection->Handle, ToUTF8(PSection->Caption))
				gtk_tree_view_append_column(GTK_TREE_VIEW(FHandle), PSection->Handle)
				Dim As gint wx, wy
				gtk_tree_view_convert_bin_window_to_widget_coords(gtk_tree_view(FHandle), 0, 0, @wx, @wy)
				gtk_widget_set_size_request(FHandle, FWidth, wy)
				g_signal_connect(gtk_tree_view_column(PSection->Handle), "clicked", G_CALLBACK(@Column_Clicked), PSection)
			#else
				Dim As HDITEM HI
				With HI
					.mask       = HDI_FORMAT Or HDI_LPARAM Or HDI_TEXT Or HDI_WIDTH
					.pszText    = @PSection->Caption
					.cchTextMax = Len(PSection->Caption)
					.cxy        = PSection->Width
					.fmt        = AFmt(Abs_(PSection->Alignment))
					.iImage     = PSection->ImageIndex
					If .iImage <> -1 Then
						.mask = .mask Or HDI_IMAGE
						.fmt  = .fmt Or HDF_IMAGE
					End If
					If PSection->Style Then
						.fmt = .fmt Or HDF_OWNERDRAW
					Else
						.fmt = .fmt Or HDF_STRING
					End If
					.hbm        = NULL
					.lParam     = Cast(LParam,PSection)
				End With
				If Handle Then Perform(HDM_INSERTITEM, SectionCount - 1, CInt(@HI))
			#endif
			'Arg = va_next(Arg, WString Ptr)
		Next i
		Cva_End(args)
	End Sub
	
	Private Sub Header.RemoveSection(Index As Integer)
		If Index >= 0 And Index <= SectionCount - 1 Then
			#ifdef __USE_GTK__
				If FHandle Then gtk_tree_view_remove_column(gtk_tree_view(FHandle), gtk_tree_view_column(Section(Index)->Handle))
			#else
				If FHandle Then Perform(HDM_DELETEITEM, Index, 0)
			#endif
			FSections.Remove Index
		End If
	End Sub
	
	Private Operator Header.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Private Sub Header.Header_Map(widget As GtkWidget Ptr, user_data As Any Ptr)
			Dim As Header Ptr hdr = user_data
			hdr->Init
		End Sub
		
		Private Function Header.Header_Draw(widget As GtkWidget Ptr, cr As cairo_t Ptr, data1 As Any Ptr) As Boolean
			Dim As Header Ptr hdr = data1
			#ifdef __USE_GTK3__
				Dim As Integer AllocatedWidth = gtk_widget_get_allocated_width(widget), AllocatedHeight = gtk_widget_get_allocated_height(widget)
			#else
				Dim As Integer AllocatedWidth = widget->allocation.width, AllocatedHeight = widget->allocation.height
			#endif
			If AllocatedWidth <> hdr->AllocatedWidth Or AllocatedHeight <> hdr->AllocatedHeight Then
				If AllocatedHeight <> hdr->AllocatedHeight Then
					If hdr->SectionCount > 0 Then gtk_widget_set_size_request(hdr->Section(0)->ButtonHandle, hdr->Section(0)->Width, AllocatedHeight)
				End If
				hdr->AllocatedWidth = AllocatedWidth
				hdr->AllocatedHeight = AllocatedHeight
				'Dim As gint wx, wy
				'gtk_tree_view_convert_bin_window_to_widget_coords(gtk_tree_view(widget), 0, 0, @wx, @wy)
				'gtk_widget_set_size_request(widget, hdr->Width, wy)
			End If
			Return False
		End Function
		
		Private Function Header.Header_ExposeEvent(widget As GtkWidget Ptr, Event As GdkEventExpose Ptr, data1 As Any Ptr) As Boolean
			Dim As cairo_t Ptr cr = gdk_cairo_create(Event->window)
			Header_Draw(widget, cr, data1)
			cairo_destroy(cr)
			Return False
		End Function
	#endif
	
	Private Constructor Header
		#ifndef __USE_GTK__
'			AStyle(0)       = HDS_BUTTONS
'			AStyle(1)       = 0
'			AFullDrag(0)    = 0
'			AFullDrag(1)    = HDS_FULLDRAG
'			AHotTrack(0)    = 0
'			AHotTrack(1)    = HDS_HOTTRACK
'			ADragReorder(0) = 0
'			ADragReorder(1) = HDS_DRAGDROP
			AFmt(0)         = HDF_LEFT
			AFmt(1)         = HDF_CENTER
			AFmt(2)         = HDF_RIGHT
			AFmt(3)         = HDF_RTLREADING
		#endif
		FFullDrag       = True
		FDragReorder    = True
		FHotTrack       = True
		FResizable      = True
		With This
			.Child             = @This
			#ifdef __USE_GTK__
				widget = gtk_tree_view_new()
				gtk_widget_set_can_focus(widget, False)
				ListStore = gtk_list_store_new(1, G_TYPE_STRING)
				ColumnTypes = New_(GType[1])
				ColumnTypes[0] = G_TYPE_STRING
				g_signal_connect(gtk_tree_view(widget), "map", G_CALLBACK(@Header_Map), @This)
				#ifdef __USE_GTK3__
					g_signal_connect(widget, "draw", G_CALLBACK(@Header_Draw), @This)
				#else
					g_signal_connect(widget, "expose-event", G_CALLBACK(@Header_ExposeEvent), @This)
				#endif
				This.RegisterClass "Header", @This
			#else
				.RegisterClass "Header", WC_HEADER
				.ChildProc         = @WndProc
				.ExStyle           = 0
				'Base.Style             = WS_CHILD Or AStyle(Abs_(FStyle)) Or AFullDrag(Abs_(FFullDrag)) Or AHotTrack(Abs_(FHotTrack)) Or ADragReorder(Abs_(FDragReorder))
				Base.Style             = WS_CHILD Or HDS_BUTTONS Or HDS_FULLDRAG Or HDS_DRAGDROP ' Or HDS_HOTTRACK
				.DoubleBuffered = True
				.BackColor             = GetSysColor(COLOR_BTNFACE)
				.OnHandleIsAllocated = @HandleIsAllocated
				WLet(FClassAncestor, WC_HEADER)
			#endif
			WLet(FClassName, "Header")
			.Width             = 150
			.Height            = 24
			.Align             = DockStyle.alTop
		End With
	End Constructor
	
	Private Destructor Header
		FSections.Clear
	End Destructor
End Namespace
