'###############################################################################
'#  ComboBoxEx.bi                                                              #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'#  Version 1.0.0                                                              #
'###############################################################################

#Include Once "ComboBoxEdit.bi"
#Include Once "ImageList.bi"
    
namespace My.Sys.Forms
    #DEFINE QComboBoxEx(__Ptr__) *Cast(ComboBoxEx Ptr,__Ptr__)
    #DEFINE QComboBoxItem(__Ptr__) *Cast(ComboBoxItem Ptr,__Ptr__)

'    Enum ComboBoxExStyle
'        cbeSimple            = 0
'        cbeDropDown          
'        cbeDropDownList      
'        cbeOwnerDrawFixed    
'        cbeOwnerDrawVariable  
'    End Enum

    Type ComboBoxItem Extends My.Sys.Object
        Private:
            FText            As WString Ptr
            FObject          As Any Ptr
            FHint            As WString Ptr
            FImageIndex   As Integer
            FImageKey   As WString Ptr
            FSelectedImageIndex   As Integer
            FOverlayIndex   As Integer
            FIndent   As Integer
        Public:
            #IfDef __USE_GTK__
				TreeIter As GtkTreeIter
            #EndIf
            Parent   As Control Ptr
            Declare Function Index As Integer
            Declare Property Text ByRef As WString
            Declare Property Text(ByRef Value As WString)
            Declare Property Object As Any Ptr
            Declare Property Object(Value As Any Ptr)
            Declare Property Hint ByRef As WString
            Declare Property Hint(ByRef Value As WString)
            Declare Property ImageIndex As Integer
            Declare Property ImageIndex(Value As Integer)
            Declare Property ImageKey ByRef As WString
            Declare Property ImageKey(ByRef Value As WString)
            Declare Property SelectedImageIndex As Integer
            Declare Property SelectedImageIndex(Value As Integer)
            Declare Property OverlayIndex As Integer
            Declare Property OverlayIndex(Value As Integer)
            Declare Property Indent As Integer
            Declare Property Indent(Value As Integer)
            Declare Operator Cast As Any Ptr
            Declare Constructor
            Declare Destructor
    End Type

	Type ComboBoxExItems
        Private:
            FItems As List
            PItem As ComboBoxItem Ptr
            #IfNDef __USE_GTK__
            				cbei As COMBOBOXEXITEM
            #EndIf 
        Public:
            Parent   As Control Ptr
            Declare Property Count As Integer
            Declare Property Count(Value As Integer)
            Declare Property Item(Index As Integer) As ComboBoxItem Ptr
            Declare Property Item(Index As Integer, Value As ComboBoxItem Ptr)
            Declare Function Add(ByRef Caption As WString = "", Obj As Any Ptr = 0, ImageIndex As Integer = -1, SelectedImageIndex As Integer = -1, OverlayIndex As Integer = -1, Indent As Integer = 0, Index As Integer = -1) As ComboBoxItem Ptr
            Declare Function Add(ByRef Caption As WString = "", Obj As Any Ptr = 0, ByRef ImageKey As WString, ByRef SelectedImageKey As WString = "", ByRef OverlayKey As WString = "", Indent As Integer = 0, Index As Integer = -1) As ComboBoxItem Ptr
            Declare Sub Remove(Index As Integer)
            Declare Function IndexOf(ByRef Item As ComboBoxItem Ptr) As Integer
            Declare Function IndexOf(ByRef Text As WString) As Integer
            Declare Function Contains(ByRef Text As WString) As Boolean
            Declare Sub Clear
            Declare Operator Cast As Any Ptr
            Declare Constructor
            Declare Destructor
    End Type

    Type ComboBoxEx Extends ComboBoxEdit
        Private:
            'FItemIndex        As Integer
            FItemHeight       As Integer
            FIntegralHeight   As Boolean
            FDropDownCount    As Integer
            Declare Sub UpdateListHeight
        				Declare Sub ProcessMessage(BYREF Message As Message)
            #IfNDef __USE_GTK__
            				Declare Static Sub WndProc(BYREF Message As Message)
            				Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
            #EndIf
        Public:
			#IfDef __USE_GTK__
				ListStore As GtkListStore Ptr
            #EndIf
            Items             As ComboBoxExItems
            ImagesList         As ImageList Ptr
'            Declare Property ItemIndex As Integer
'            Declare Property ItemIndex(Value As Integer)
            Declare Property IntegralHeight As Boolean
            Declare Property IntegralHeight(Value As Boolean)
            Declare Property ItemHeight As Integer
            Declare Property ItemHeight(Value As Integer)
            Declare Property DropDownCount As Integer
            Declare Property DropDownCount(Value As Integer)
            Declare Operator Cast As Control Ptr 
            Declare Constructor
            Declare Destructor
    End Type

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
        WLet FText, Value
        #IfDef __USE_GTK__
			If Parent AndAlso Parent->widget Then
				gtk_list_store_set (Cast(ComboBoxEx Ptr, Parent)->ListStore, @TreeIter, 1, ToUTF8(Value), -1)
			End If
        #Else
			If Parent AndAlso Parent->Handle Then
				Dim cbei As COMBOBOXEXITEM
				cbei.Mask = CBEIF_TEXT
				cbei.iItem = Index
				cbei.pszText    = FText
				cbei.cchTextMax = Len(*FText)
				Parent->Perform CBEM_SETITEM, 0, CInt(@cbei)
			  End If
		#EndIf 
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
        WLet FHint, Value
    End Property


    Property ComboBoxItem.ImageIndex As Integer
        Return FImageIndex
    End Property

    Property ComboBoxItem.ImageIndex(Value As Integer)
        If Value <> FImageIndex Then
            FImageIndex = Value
            #IfNDef __USE_GTK__
				If Parent AndAlso Parent->Handle Then
					Dim cbei As COMBOBOXEXITEM
					cbei.Mask = CBEIF_IMAGE
					cbei.iItem = Index
						cbei.iImage = FImageIndex
					  Parent->Perform CBEM_SETITEM, 0, CInt(@cbei)
				  End If
			#EndIf 
        End If
    End Property

	Property ComboBoxItem.ImageKey ByRef As WString
        Return WGet(FImageKey)
    End Property

    Property ComboBoxItem.ImageKey(ByRef Value As WString)
        WLet FImageKey, Value
		#IfDef __USE_GTK__
			If Parent AndAlso Parent->widget Then
				gtk_list_store_set (Cast(ComboBoxEx Ptr, Parent)->ListStore, @TreeIter, 0, ToUTF8(Value), -1)
			End If
		#EndIf
    End Property

    Property ComboBoxItem.SelectedImageIndex As Integer
        Return FImageIndex
    End Property

    Property ComboBoxItem.SelectedImageIndex(Value As Integer)
        If Value <> FSelectedImageIndex Then
            FSelectedImageIndex = Value
            #IfNDef __USE_GTK__
				If Parent AndAlso Parent->Handle Then
					Dim cbei As COMBOBOXEXITEM
					cbei.Mask = CBEIF_SELECTEDIMAGE
					cbei.iItem = Index
						cbei.iSelectedImage = FSelectedImageIndex 
					  Parent->Perform CBEM_SETITEM, 0, CInt(@cbei)
				  End If
			#EndIf 
        End If
    End Property
    
    Property ComboBoxItem.OverlayIndex As Integer
        Return FImageIndex
    End Property

    Property ComboBoxItem.OverlayIndex(Value As Integer)
        If Value <> FOverlayIndex Then
            FOverlayIndex = Value
            #IfNDef __USE_GTK__
				If Parent AndAlso Parent->Handle Then
					Dim cbei As COMBOBOXEXITEM
					cbei.Mask = CBEIF_OVERLAY
					cbei.iItem = Index
						cbei.iOverlay = FOverlayIndex
					  Parent->Perform CBEM_SETITEM, 0, CInt(@cbei)
				  End If
			#EndIf
        End If
    End Property

    Property ComboBoxItem.Indent As Integer
        Return FIndent
    End Property

    Property ComboBoxItem.Indent(Value As Integer)
        If Value <> FIndent Then
            FIndent = Value
            #IfNDef __USE_GTK__
        				    If Parent AndAlso Parent->Handle Then
                    Dim cbei As COMBOBOXEXITEM
                				cbei.Mask = CBEIF_INDENT
                					cbei.iItem = Index
                					cbei.iIndent = FIndent
                					Parent->Perform CBEM_SETITEM, 0, CInt(@cbei)
        				    End If
        			#EndIf
        End If
    End Property

    Operator ComboBoxItem.Cast As Any Ptr
        Return @This
    End Operator

    Constructor ComboBoxItem
        FHint = CAllocate(0)
        FText = CAllocate(0)
        Text    = ""
        Hint       = ""
        FImageIndex = -1
        FSelectedImageIndex = -1
        FOverlayIndex = -1
    End Constructor

    Destructor ComboBoxItem
        If FHint Then Deallocate FHint
        If FText Then Deallocate FText
    End Destructor

    Property ComboBoxExItems.Count As Integer
        Return FItems.Count
    End Property

    Property ComboBoxExItems.Count(Value As Integer)
    End Property

    Property ComboBoxExItems.Item(Index As Integer) As ComboBoxItem Ptr
        Return QComboBoxItem(FItems.Items[Index])
    End Property

    Property ComboBoxExItems.Item(Index As Integer, Value As ComboBoxItem Ptr)
       'QToolButton(FItems.Items[Index]) = Value 
    End Property

    Function ComboBoxExItems.Add(ByRef FText As WString = "", Obj As Any Ptr = 0, FImageIndex As Integer = -1, FSelectedImageIndex As Integer = -1, FOverlayIndex As Integer = -1, FIndent As Integer = 0, Index As Integer = -1) As ComboBoxItem Ptr
        PItem = New ComboBoxItem
        If Index = -1 Then
        	FItems.Add PItem
        Else
        	FItems.Insert Index, PItem
        End If
        With *PItem
            .ImageIndex         = FImageIndex
            .SelectedImageIndex = FSelectedImageIndex
            .OverlayIndex       = FOverlayIndex
            .Indent     		= FIndent
            .Text        		= FText
            .Object        		= Obj
        End With
        #IfDef __USE_GTK__
        	#IfDef __USE_GTK3__
				gtk_list_store_insert(Cast(ComboBoxEx Ptr, Parent)->ListStore, @PItem->TreeIter, Index)
			#Else
				gtk_list_store_insert(Cast(ComboBoxEx Ptr, Parent)->ListStore, @PItem->TreeIter, IIf(Index = -1, FItems.Count, Index))
			#EndIf
			gtk_list_store_set (Cast(ComboBoxEx Ptr, Parent)->ListStore, @PItem->TreeIter, 1, ToUtf8(FText), -1)
			'gtk_widget_show_all(Parent->widget)
        #Else
			cbei.Mask = CBEIF_IMAGE or CBEIF_INDENT Or CBEIF_OVERLAY Or CBEIF_SELECTEDIMAGE Or CBEIF_TEXT
			cbei.pszText  = @FText
			cbei.cchTextMax = Len(FText)
			cbei.iItem = IIF(Index = -1, FItems.Count - 1, Index)
			cbei.iImage   = FImageIndex
			cbei.iSelectedImage   = FSelectedImageIndex
			cbei.iOverlay   = FOverlayIndex
			cbei.iIndent   = FIndent
		#EndIf
        If Parent Then
           PItem->Parent = Parent
			#IfNDef __USE_GTK__
				Parent->Perform CBEM_INSERTITEM, 0, CInt(@cbei)
			#EndIf
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
			#IfDef __USE_GTK__
				gtk_list_store_remove(Cast(ComboBoxEx Ptr, Parent)->ListStore, @This.Item(Index)->TreeIter)
			#Else
				Parent->Perform CBEM_DELETEITEM, Index, 0
			#EndIf
        End If
        Delete Cast(ComboBoxItem Ptr, FItems.Items[Index])
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
		#IfDef __USE_GTK__
			If Parent Then gtk_list_store_clear(Cast(ComboBoxEx Ptr, Parent)->ListStore)
		#Else
			If Parent Then Parent->Perform CB_RESETCONTENT, 0, 0
        #EndIf
        For i As Integer = Count -1 To 0 Step -1
            Delete @QComboBoxItem(FItems.Items[i])
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

    Sub ComboBoxEx.UpdateListHeight
        'If Style <> cbSimple Then
        #IfNDef __USE_GTK__
            MoveWindow Handle, FLeft, FTop, FWidth, FHeight + (ItemHeight * Items.Count), 1 
        #EndIf
        'End If
    End Sub

'    Property ComboBoxEx.ItemIndex As Integer
'        Return FItemIndex
'    End Property
'
'    Property ComboBoxEx.ItemIndex(Value As Integer)
'        FItemIndex = Value
'        If Handle Then Perform(CB_SETCURSEL, FItemIndex, 0)
'    End Property

    Property ComboBoxEx.DropDownCount As Integer
        Return FDropDownCount
    End Property

    Property ComboBoxEx.DropDownCount(Value As Integer)
        FDropDownCount = Value
    End Property

    Property ComboBoxEx.IntegralHeight As Boolean
        Return FIntegralHeight
    End Property

    Property ComboBoxEx.IntegralHeight(Value As Boolean)
        FIntegralHeight = Value
        #IfNDef __USE_GTK__
			ChangeStyle CBS_NOINTEGRALHEIGHT, Not Value
		#EndIf
    End Property
    
    Property ComboBoxEx.ItemHeight As Integer
        Return FItemHeight
    End Property

    Property ComboBoxEx.ItemHeight(Value As Integer)
        FItemHeight = Value
        #IfNDef __USE_GTK__
			If Handle Then 
				'If Style <> cbOwnerDrawVariable  Then
				'    Perform(CB_SETITEMHEIGHT, 0, FItemHeight)
				'End If
			End If
		#EndIf
    End Property

	#IfNDef __USE_GTK__
		Sub ComboBoxEx.HandleIsAllocated(BYREF Sender As Control)
			If Sender.Child Then
				With QComboBoxEx(Sender.Child)
					 'If .Style <> cbOwnerDrawVariable Then
					 .Perform(CB_SETITEMHEIGHT, 0, .ItemHeight)
					 'End If-
					.UpdateListHeight
					If .ImagesList Then
						.ImagesList->ParentWindow = @Sender
						.Perform CBEM_SETIMAGELIST, 0, CInt(.ImagesList->Handle)
					End If
					 Dim As Integer i
					For i = 0 To .Items.Count - 1
						Dim As COMBOBOXEXITEM cbei
						cbei.Mask = CBEIF_TEXT Or CBEIF_IMAGE or CBEIF_INDENT Or CBEIF_OVERLAY Or CBEIF_SELECTEDIMAGE
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
					.Text = *(.FText)
				End With
			End If
		End Sub
	#EndIf

	#IfNDef __USE_GTK__
		Sub ComboBoxEx.WndProc(BYREF Message As Message)
	'        If Message.Sender Then
	'            If Cast(TControl Ptr,Message.Sender)->Child Then
	'                Cast(ComboBoxEx Ptr,Cast(TControl Ptr,Message.Sender)->Child)->ProcessMessage(Message) 
	'            End If
	'        End If
		End Sub
	#EndIf

	Sub ComboBoxEx.ProcessMessage(BYREF Message As Message)
		#IfNDef __USE_GTK__			
    		Select Case Message.Msg
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
    	#EndIf
    	Base.ProcessMessage(message)
	End Sub

    Operator ComboBoxEx.Cast As Control Ptr 
        Return Cast(Control Ptr, @This)
    End Operator

    Constructor ComboBoxEx
        
        #IfDef __USE_GTK__
			ListStore = gtk_list_store_new(2, G_TYPE_STRING, G_TYPE_STRING)
			widget = gtk_combo_box_new_with_model(GTK_TREE_MODEL(ListStore))
			g_signal_connect(widget, "changed", G_CALLBACK(@ComboBoxEdit_Changed), @This)
			Dim As GtkCellRenderer Ptr renderer
			/' icon cell '/
			renderer = gtk_cell_renderer_pixbuf_new()
			gtk_cell_layout_pack_start( GTK_CELL_LAYOUT(widget), renderer, FALSE)
			gtk_cell_layout_set_attributes( GTK_CELL_LAYOUT(widget), renderer, ToUtf8("icon-name"), 0, NULL)
			/' text cell '/
			renderer = gtk_cell_renderer_text_new()
			gtk_cell_layout_pack_start( GTK_CELL_LAYOUT(widget), renderer, TRUE)
			gtk_cell_layout_set_attributes( GTK_CELL_LAYOUT(widget), renderer, ToUtf8("text"), 1, NULL)
			Base.Base.RegisterClass "ComboBoxEx", @This
        #Else
        			Dim As INITCOMMONCONTROLSEX icex
        
        			icex.dwSize = sizeof(INITCOMMONCONTROLSEX)
        			icex.dwICC = ICC_USEREX_CLASSES
        
        			InitCommonControlsEx(@icex)
      		#EndIf
        Items.Parent       = @This
        FIntegralHeight    = False
        ItemHeight         = 13
        FDropDownCount     = 8
        With This
            .Child       = @This
            #IfNDef __USE_GTK__
				Base.Base.RegisterClass "ComboBoxEx", "ComboBoxEx32"
            	.ChildProc   = @WndProc
            	Base.Base.Style       = WS_CHILD Or CBS_DROPDOWNLIST Or WS_VSCROLL
                .OnHandleIsAllocated = @HandleIsAllocated
            	.BackColor       = GetSysColor(COLOR_WINDOW)
            #EndIf
            WLet FClassName, "ComboBoxEx"
            WLet FClassAncestor, "ComboBoxEx32"
            .Width       = 121
            .Height      = 121
        End With  
    End Constructor

    Destructor ComboBoxEx
    	Items.Clear
		#IfNDef __USE_GTK__
			UnregisterClass "ComboBoxEx", GetModuleHandle(NULL)
		#EndIf
    End Destructor
End namespace
