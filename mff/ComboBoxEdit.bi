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

#Include Once "Control.bi"
#Include Once "ListItems.bi"

namespace My.Sys.Forms
    #DEFINE QComboBoxEdit(__Ptr__) *Cast(ComboBoxEdit Ptr,__Ptr__)

    Enum ComboBoxEditStyle
        cbSimple            = 0
        cbDropDown          
        cbDropDownList      
        cbOwnerDrawFixed    
        cbOwnerDrawVariable  
    End Enum

    Type ComboBoxEdit Extends Control
        Private:
            FStyle            As Integer
            FSort             As Boolean
            FItemHeight       As Integer
            FDropDownCount    As Integer
            FIntegralHeight   As Boolean
            #IfNDef __USE_GTK__
				FListHandle       As HWND
				FEditHandle       As HWND
            #EndIf
            FSelColor         As Integer
            AStyle(5)         As Integer
            ASortStyle(2)     As Integer
            AIntegralHeight(2)As Integer
            Declare Sub GetChilds 
            Declare Sub UpdateListHeight
            #IfNDef __USE_GTK__
				Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
			#EndIf
        Protected:
            FItemIndex        As Integer
            #IfNDef __USE_GTK__
				Declare Static Function WindowProc(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			#EndIf
			Declare Sub ProcessMessage(BYREF Message As Message)
        Public:
            Items             As ListItems
            Declare Property Style As ComboBoxEditStyle
            Declare Property Style(Value As ComboBoxEditStyle)
            Declare Property Text ByRef As WString
            Declare Property Text(ByRef Value As WString)
            Declare Property SelColor As Integer
            Declare Property SelColor(Value As Integer)
            Declare Property ItemIndex As Integer
            Declare Property ItemIndex(Value As Integer)
            Declare Property ItemHeight As Integer
            Declare Property ItemHeight(Value As Integer)
            Declare Property ItemCount As Integer
            Declare Property ItemCount(Value As Integer)
            Declare Property DropDownCount As Integer
            Declare Property DropDownCount(Value As Integer)
            Declare Property IntegralHeight As Boolean
            Declare Property IntegralHeight(Value As Boolean)
            Declare Property Sort As Boolean
            Declare Property Sort(Value As Boolean)
            Declare Property Object(FIndex As Integer) As Any Ptr
            Declare Property Object(FIndex As Integer, Obj As Any Ptr)
            Declare Property Item(FIndex As Integer) ByRef As WString
            Declare Property Item(FIndex As Integer, ByRef FItem As WString)
            Declare Operator Cast As Control Ptr
            Declare Sub AddItem(ByRef FItem As WString)
            Declare Sub AddObject(ByRef ObjName As WString, Obj As Any Ptr)
            Declare Sub RemoveItem(FIndex As Integer)
            Declare Sub InsertItem(FIndex As Integer, ByRef FItem As WString)
            Declare Sub InsertObject(FIndex As Integer, ByRef ObjName As WString, Obj As Any Ptr)
            Declare Function IndexOf(ByRef Item As WString) As Integer
            Declare Function Contains(ByRef Item As WString) As Boolean
            Declare Function IndexOfObject(Obj As Any Ptr) As Integer
            Declare Sub Clear
            Declare Sub ShowDropDown(Value As Boolean)
            Declare Sub SaveToFile(ByRef File As WString)
            Declare Sub LoadFromFile(ByRef File As WString)
            Declare Static Sub RegisterClass
            Declare Constructor
            Declare Destructor
            OnChange            As Sub(BYREF Sender As ComboBoxEdit)
            OnDblClick          As Sub(BYREF Sender As ComboBoxEdit)
            OnDropDown          As Sub(BYREF Sender As ComboBoxEdit)
            OnCloseUp           As Sub(BYREF Sender As ComboBoxEdit)
            OnKeyPress          As Sub(BYREF Sender As ComboBoxEdit, Key As Byte, Shift As Integer)
            OnKeyDown           As Sub(BYREF Sender As ComboBoxEdit, Key As Integer, Shift As Integer)
            OnKeyUp             As Sub(BYREF Sender As ComboBoxEdit, Key As Integer, Shift As Integer)
            #IfNDef __USE_GTK__
				OnMeasureItem       As Sub(BYREF Sender As ComboBoxEdit, ItemIndex As Integer, BYREF Height As UInt)
				OnDrawItem          As Sub(BYREF Sender As ComboBoxEdit, ItemIndex As Integer, State As Integer, BYREF R As Rect, DC As HDC = 0)
            #EndIf
            OnSelected          As Sub(BYREF Sender As ComboBoxEdit, ItemIndex As Integer)
            OnSelectCanceled    As Sub(BYREF Sender As ComboBoxEdit)
    End Type

    Sub ComboBoxEdit.ShowDropDown(Value As Boolean)
        #IfDef __USE_GTK__
			gtk_combo_box_popup(gtk_combo_box(widget))
        #Else
			Perform CB_SHOWDROPDOWN, Value, 0
		#EndIf
    End Sub
    
    #IfNDef __USE_GTK__
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
	#EndIf

    Sub ComboBoxEdit.RegisterClass
		#IfNDef __USE_GTK__
			Control.RegisterClass "ComboBoxEdit", "ComboBox", @WindowProc
		#EndIf
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
            #IfNDef __USE_GTK__
				Base.Style = WS_CHILD OR WS_VSCROLL OR CBS_HASSTRINGS OR CBS_AUTOHSCROLL OR AStyle(Abs_(FStyle)) OR ASortStyle(Abs_(FSort)) OR AIntegralHeight(Abs_(FIntegralHeight))
			#EndIf
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
		#IfNDef __USE_GTK__
			Base.Style = WS_CHILD OR WS_VSCROLL OR CBS_HASSTRINGS OR CBS_AUTOHSCROLL OR AStyle(Abs_(FStyle)) OR ASortStyle(Abs_(FSort)) OR AIntegralHeight(Abs_(FIntegralHeight))
		#EndIf
    End Property

    Property ComboBoxEdit.ItemCount As Integer
        #IfNDef __USE_GTK__
			If Handle Then 
				Return Perform(CB_GETCOUNT,0,0)
			End If
		#EndIf
        Return Items.Count
    End Property

    Property ComboBoxEdit.ItemCount(Value As Integer)
    End Property

    Property ComboBoxEdit.ItemHeight As Integer
        Return FItemHeight
    End Property

    Property ComboBoxEdit.ItemHeight(Value As Integer)
        FItemHeight = Value
        #IfNDef __USE_GTK__
			If Handle Then 
				If Style <> cbOwnerDrawVariable  Then
					Perform(CB_SETITEMHEIGHT, 0, FItemHeight)
				End If
			End If
		#EndIf
    End Property

    Property ComboBoxEdit.ItemIndex As Integer
        #IfDef __USE_GTK__
			If widget Then FItemIndex = gtk_combo_box_get_active (Gtk_Combo_Box(widget))
        #Else
			If Handle Then FItemIndex = Perform(CB_GETCURSEL, 0, 0)
        #EndIf
        Return FItemIndex
    End Property

    Property ComboBoxEdit.ItemIndex(Value As Integer)
        FItemIndex = Value
        #IfDef __USE_GTK__
			If widget Then gtk_combo_box_set_active (Gtk_Combo_Box(widget), Value)
        #Else
			If Handle Then Perform(CB_SETCURSEL, FItemIndex, 0)
		#EndIf
    End Property

    Property ComboBoxEdit.Text ByRef As WString
        WLet FText, This.Item(This.ItemIndex)
        Return WGet(FText)
    End Property

    Property ComboBoxEdit.Text(ByRef Value As WString)
        Base.Text = Value
        #IfDef __USE_GTK__
			If widget Then gtk_combo_box_set_active (Gtk_Combo_Box(widget), IndexOf(Value))
        #Else
			If FHandle Then Perform(CB_SELECTSTRING, -1, CInt(FText))
		#EndIf
    End Property

    Property ComboBoxEdit.Sort As Boolean
        Return FSort
    End Property

    Property ComboBoxEdit.Sort(Value As Boolean)
        If Value <> FSort Then
           FSort = Value
           #IfNDef __USE_GTK__
				ChangeStyle CBS_SORT, Value
				'Base.Style = WS_CHILD OR WS_VSCROLL OR CBS_HASSTRINGS OR CBS_AUTOHSCROLL OR AStyle(Abs_(FStyle)) OR ASortStyle(Abs_(FSort)) OR AIntegralHeight(Abs_(FIntegralHeight))
			#EndIf
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
        Dim As WString Ptr s
        #IfNDef __USE_GTK__
			If Handle Then
			   L = Perform(CB_GETLBTEXTLEN, FIndex, 0)
			   s = CAllocate((L + 1) * SizeOf(WString))
			   *s = WSpace(L)
			   Perform(CB_GETLBTEXT, FIndex, CInt(s))
			   Return *s
			Else
				s = CAllocate((Len(Items.Item(FIndex)) + 1) * SizeOf(WString))
			   *s = Items.Item(FIndex)
				Return *s
			End If
		#Else
			s = CAllocate((Len(Items.Item(FIndex)) + 1) * SizeOf(WString))
		   *s = Items.Item(FIndex)
			Return *s
		#EndIf
    End Property

    Property ComboBoxEdit.Item(FIndex As Integer, ByRef FItem As WString)
        Items.Item(FIndex) = FItem
    End Property

    Sub ComboBoxEdit.UpdateListHeight
        If Style <> cbSimple Then
			#IfNDef __USE_GTK__
				MoveWindow Handle, FLeft, FTop, FWidth, FHeight + (ItemHeight * ItemCount), 1 
			#EndIf
        End If
    End Sub

    Sub ComboBoxEdit.AddItem(ByRef FItem As WString)
        Items.Add(FItem)
        #IfDef __USE_GTK__
			If widget Then
				gtk_combo_box_text_append_text(gtk_combo_box_text(widget), ToUtf8(FItem))
			End If
        #Else
			If FHandle Then 
				Perform(CB_ADDSTRING, 0, CInt(@FItem))
				UpdateListHeight
			End If
		#EndIf
    End Sub

    Sub ComboBoxEdit.AddObject(ByRef ObjName As WString, Obj As Any Ptr)
        Items.Add(ObjName, Obj)
        #IfNDef __USE_GTK__
			If FHandle Then 
				Perform(CB_ADDSTRING, 0, CInt(@ObjName))
				UpdateListHeight
			End If
		#EndIf
    End Sub

    Sub ComboBoxEdit.RemoveItem(FIndex As Integer)
        Items.Remove(FIndex)
        #IfNDef __USE_GTK__
			If FHandle Then 
				Perform(CB_DELETESTRING, FIndex, 0)
				UpdateListHeight
			End If
		#EndIf
    End Sub

    Sub ComboBoxEdit.InsertItem(FIndex As Integer, ByRef FItem As WString)
        Items.Insert(FIndex, FItem)
        #IfDef __USE_GTK__
        	gtk_combo_box_text_insert_text(gtk_combo_box_text(widget), FIndex, ToUtf8(FItem))
        #Else
			If FHandle Then 
				Perform(CB_INSERTSTRING, FIndex, CInt(@FItem))
				UpdateListHeight
			End If
		#EndIf
    End Sub

    Sub ComboBoxEdit.InsertObject(FIndex As Integer, ByRef ObjName As WString, Obj As Any Ptr)
        Items.Insert(FIndex, ObjName, Obj)
        #IfNDef __USE_GTK__
        			 If FHandle Then 
        			     Perform(CB_INSERTSTRING, FIndex, CInt(@ObjName))
        				    UpdateListHeight
        			 End If
        #EndIf
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

	   #IfNDef __USE_GTK__
    		Sub ComboBoxEdit.HandleIsAllocated(BYREF Sender As Control)
    			If Sender.Child Then
    				With QComboBoxEdit(Sender.Child)
    					 .GetChilds
    					 If .Style <> cbOwnerDrawVariable Then
    						.Perform(CB_SETITEMHEIGHT, 0, .ItemHeight)
    					 End If
    					 .UpdateListHeight
    					 Dim As Integer i
    					For i = 0 To .Items.Count -1
    						Dim As WString Ptr s = CAllocate((Len(.Items.Item(i)) + 1) * SizeOf(WString))
    						*s = .Items.Item(i) 
    						 .Perform(CB_ADDSTRING, 0, CInt(s))
    					Next i
    					.ItemIndex = .FItemIndex
    					.Text = *(.FText)
    				End With
    			End If
    		End Sub
	   #EndIf

    Sub ComboBoxEdit.GetChilds
        #IfNDef __USE_GTK__
        			Dim As HWND Child
        			FEditHandle = 0
        			FListHandle = 0
        			If Style = cbDropDown OR Style = cbSimple Then
        				Child = GetWindow(Handle, GW_CHILD)
        				If Child <> 0 then
        				   If Style = cbSimple then
        					   FListHandle = Child
        					   Child = GetWindow(Child, GW_HWNDNEXT)
        				   End If
        				   FEditHandle = Child
        				End If
        			End If
		      #EndIf
    End Sub

	Sub ComboBoxEdit.ProcessMessage(BYREF Message As Message)
        #IfNDef __USE_GTK__	
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
    						  SetWindowPos(Handle, 0, 0, 0, FWidth, ItemHeight * DropDownCount + Height + 2 , SWP_NOMOVE OR SWP_NOZORDER OR SWP_NOACTIVATE OR SWP_NOREDRAW OR SWP_HIDEWINDOW)
    					  Else
    						  SetWindowPos(Handle, 0, 0, 0, FWidth, ItemHeight + Height + 2 , SWP_NOMOVE OR SWP_NOZORDER OR SWP_NOACTIVATE OR SWP_NOREDRAW OR SWP_HIDEWINDOW)
    					  End If
    					  SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_NOMOVE OR SWP_NOSIZE OR SWP_NOZORDER OR SWP_NOACTIVATE OR SWP_NOREDRAW OR SWP_SHOWWINDOW)
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
    				If (diStruct->itemState AND ODS_COMBOBOXEDIT) <> 0 Then State = State OR ODS_ComboBOXEDIT
    				If (diStruct->itemState AND ODS_DEFAULT) <> 0 Then State = State OR ODS_DEFAULT
    				If OnDrawItem Then
    					OnDrawItem(This,ItemID,State,R,Dc)
    				Else
    					If (State AND ODS_SELECTED) = ODS_SELECTED Then
    						Static As HBRUSH B 
    						If B Then DeleteObject B
    						B = CreateSolidBrush(FSelColor)
    						FillRect Dc, @R, B
    						SetTextColor Dc, clHighlightText
    						SetBKColor Dc, FSelColor
    						TextOut(Dc,R.Left + 2, R.Top, Item(ItemID),Len(Item(ItemID)))
    						If (State AND ODS_FOCUS) = ODS_FOCUS Then DrawFocusRect(DC, @R)
    					Else
    						FillRect Dc, @R, Brush.Handle
    						SetTextColor Dc, Font.Color
    						SetBKColor Dc, This.BackColor
    						TextOut(Dc, R.Left + 2, R.Top, Item(ItemID), Len(Item(ItemID)))
    					End If
    				End If
    			Case WM_CHAR
    				If OnKeyPress Then OnKeyPress(This, LoByte(Message.wParam), Message.wParam AND &HFFFF)
    			Case WM_KEYDOWN
    				If OnKeyDown Then OnKeyDown(This, Message.wParam, Message.wParam AND &HFFFF)
    			Case WM_KEYUP
    				If OnKeyUp Then OnKeyUp(This, Message.wParam, Message.wParam AND &HFFFF)
    			End Select
    #EndIf
			Base.ProcessMessage(message)
		End Sub

    Sub ComboBoxEdit.Clear
        ItemCount = 0
        Items.Clear
        #IfNDef __USE_GTK__
			         Perform(CB_RESETCONTENT, 0, 0)
		      #EndIf
    End Sub

    Sub ComboBoxEdit.SaveToFile(ByRef File As WString)
        Dim As Integer F, i
        Dim As WString Ptr s
        F = FreeFile
        Open File For Binary Access Write As #F
             For i = 0 To ItemCount -1
            				#IfNDef __USE_GTK__
            					Dim TextLen As Integer = Perform(CB_GETLBTEXTLEN, i, 0)
            					s = CAllocate((TextLen + 1) * SizeOf(WString))
            					*s = WSpace(TextLen) 
            					Perform(CB_GETLBTEXT, i, CInt(s))
            					 Print #F, *s
            				#EndIf
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
                #IfNDef __USE_GTK__
            		Perform(CB_ADDSTRING, 0, CInt(s))
            	#EndIf
            WEnd
        Close #F
    End Sub

    Operator ComboBoxEdit.Cast As Control Ptr 
        Return Cast(Control Ptr, @This)
    End Operator
    
    #IfDef __USE_GTK__
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
	    End Sub
	#EndIf

    Constructor ComboBoxEdit
		#IfDef __USE_GTK__
			widget = gtk_combo_box_text_new()
			g_signal_connect(widget, "changed", G_CALLBACK(@ComboBoxEdit_Changed), @This)
			g_signal_connect(widget, "popup", G_CALLBACK(@ComboBoxEdit_Popup), @This)
			g_signal_connect(widget, "popdown", G_CALLBACK(@ComboBoxEdit_Popdown), @This)
			Base.RegisterClass "ComboBoxEdit", @This
		#Else
			ASortStyle(Abs_(True))   = CBS_SORT
			AStyle(0)          = CBS_SIMPLE
			AStyle(1)          = CBS_DROPDOWN
			AStyle(2)          = CBS_DROPDOWNLIST
			AStyle(3)          = CBS_DROPDOWNLIST OR CBS_OWNERDRAWFIXED
			AStyle(4)          = CBS_DROPDOWNLIST OR CBS_OWNERDRAWVARIABLE 
			AIntegralHeight(0) = CBS_NOINTEGRALHEIGHT    
			AIntegralHeight(1) = 0
		#EndIf
        FStyle             = cbDropDownList 
        ItemHeight         = 13
        FDropDownCount     = 8
        FSelColor          = &H800000
        FIntegralHeight    = 0
        FItemIndex         = -1
        Items.Parent       = @This
        With This
            .Child         = @This
            '.ChildProc     = @WindowProc
            'ComboBoxEdit.RegisterClass
            WLet FClassName, "ComboBoxEdit"
            WLet FClassAncestor, "ComboBox"
            #IfNDef __USE_GTK__
				Base.RegisterClass "ComboBoxEdit", "ComboBox"
            				.ExStyle       = 0
            				Base.Style     = WS_CHILD OR WS_VSCROLL OR CBS_HASSTRINGS OR CBS_AUTOHSCROLL OR AStyle(Abs_(FStyle)) OR ASortStyle(Abs_(FSort)) OR AIntegralHeight(Abs_(FIntegralHeight))
            				.BackColor         = GetSysColor(COLOR_WINDOW)
            				.OnHandleIsAllocated = @HandleIsAllocated
            #EndIf
            .Width         = 121
            #IfDef __USE_GTK__
            	.Height        = 20
            #Else
            	.Height        = 17
            #EndIf
        End With  
    End Constructor

    Destructor ComboBoxEdit
		      #IfNDef __USE_GTK__
			         UnregisterClass "ComboBoxEdit", GetModuleHandle(NULL)
		      #EndIf
    End Destructor
End namespace
