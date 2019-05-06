'###############################################################################
'#  ToolPalette.bi                                                             #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TToolBar.bi                                                               #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Adapted to ToolPalette and added cross-platform                            #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#Include Once "ToolBar.bi"

Namespace My.Sys.Forms
    #DEFINE QToolGroup(__Ptr__) *Cast(ToolGroup Ptr,__Ptr__)
    #DEFINE QToolPalette(__Ptr__) *Cast(ToolPalette Ptr,__Ptr__)
    
    Enum ToolPaletteStyle
		tpsIcons
		tpsText
		tpsBoth
		tpsBothHorizontal
	End Enum

    Type ToolGroupButtons
        Private:
            FButtons As List
        Public:
            Parent   As My.Sys.Object Ptr
            Declare Property Count As Integer
            Declare Property Count(Value As Integer)
            Declare Property Item(Index As Integer) As ToolButton Ptr
            Declare Property Item(ByRef Key As WString) As ToolButton Ptr
            Declare Property Item(Index As Integer, Value As ToolButton Ptr)
            Declare Function Add(FStyle As Integer = tbsAutosize, FImageIndex As Integer = -1, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As Integer = tstEnabled) As ToolButton Ptr
            Declare Function Add(FStyle As Integer = tbsAutosize, ByRef ImageKey As WString, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As Integer = tstEnabled) As ToolButton Ptr
            Declare Sub Remove(Index As Integer)
            Declare Function IndexOf(BYREF FButton As ToolButton Ptr) As Integer
            Declare Function IndexOf(ByRef Key As WString) As Integer
            Declare Sub Clear
            Declare Operator Cast As Any Ptr
            Declare Constructor
            Declare Destructor
    End Type
    
    Type ToolGroup Extends My.Sys.Object
        Private:
            FCaption      As WString Ptr
            FExpanded     As Boolean
            FCommandID    As Integer
        Protected:
            FName           As WString Ptr
        Public:
        	#IfDef __USE_GTK__
				Widget As GtkWidget Ptr
			#EndIf
            Tag           As Any Ptr
            Ctrl       As Control Ptr
            Buttons		As ToolGroupButtons
            Declare Function Index As Integer
            Declare Property Caption ByRef As WString
            Declare Property Caption(ByRef Value As WString)
            Declare Property CommandID As Integer 
            Declare Property CommandID(Value As Integer)
            Declare Property Name ByRef As WString
            Declare Property Name(ByRef Value As WString)
            Declare Property Expanded As Boolean
            Declare Property Expanded(Value As Boolean)
            Declare Operator Cast As Any Ptr
            Declare Constructor
            Declare Destructor
    End Type

    Type ToolGroups
        Private:
            FGroups As List
        Public:
            Parent   As Control Ptr
            Declare Property Count As Integer
            Declare Property Count(Value As Integer)
            Declare Property Item(Index As Integer) As ToolGroup Ptr
            Declare Property Item(ByRef Key As WString) As ToolGroup Ptr
            Declare Property Item(Index As Integer, Value As ToolGroup Ptr)
            Declare Function Add(ByRef Caption As WString, ByRef Key As WString = "") As ToolGroup Ptr
            Declare Sub Remove(Index As Integer)
            Declare Function IndexOf(ByRef FToolGroup As ToolGroup Ptr) As Integer
            Declare Function IndexOf(ByRef Key As WString) As Integer
            Declare Sub Clear
            Declare Operator Cast As Any Ptr
            Declare Constructor
            Declare Destructor
    End Type

    Type ToolPalette Extends Control
        Private:
            FButtonWidth    As Integer
            FButtonHeight   As Integer
            FColor          As Integer
            FAutosize       As Boolean
            FFlat           As Boolean
            FList           As Boolean
            FDivider        As Boolean
            FVisible        As Boolean
            FEnabled        As Boolean
            FTransparent    As Boolean
            FStyle          As Integer
            FWrapable       As Integer
            ATransparent(2) As Integer
            AFlat(2)        As Integer
            ADivider(2)     As Integer
            AAutosize(2)    As Integer
            AList(2)        As Integer
            AState(6)       As Integer
            AWrap(2)        As Integer
            FButtons        As List
            Declare Static Sub WndProc(BYREF Message As Message)
			Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
			Declare Static Sub HandleIsDestroyed(BYREF Sender As Control)
			Declare Sub ProcessMessage(BYREF Message As Message)
            Declare Sub GetDropDownMenuItems
        Public:
            Groups          As ToolGroups
            ImagesList      As ImageList Ptr
            HotImagesList   As ImageList Ptr
            DisabledImagesList As ImageList Ptr
            'Declare Function Buttons(Index As Integer) As ToolButton
            Declare Property AutoSize As Boolean
            Declare Property AutoSize(Value As Boolean)
            Declare Property Flat As Boolean
            Declare Property Flat(Value As Boolean)
            Declare Property List As Boolean
            Declare Property List(Value As Boolean)
            Declare Property Wrapable As Boolean
            Declare Property Wrapable(Value As Boolean)
            Declare Property Transparency As Boolean
            Declare Property Transparency(Value As Boolean)
            Declare Property Divider As Boolean
            Declare Property Divider(Value As Boolean)
            Declare Property Style As Integer
            Declare Property Style(Value As Integer)
            Declare Property ButtonWidth As Integer
            Declare Property ButtonWidth(Value As Integer)
            Declare Property ButtonHeight As Integer
            Declare Property ButtonHeight(Value As Integer)
            Declare Operator Cast As Control Ptr 
            Declare Constructor
            Declare Destructor
            OnButtonClick As Sub(BYREF Sender As ToolPalette,BYREF Button As ToolButton)
    End Type

	Constructor ToolGroup
		#IfDef __USE_GTK__
			widget = gtk_tool_item_group_new("")
		#EndIf
		FExpanded = True
		Buttons.Parent = @This
	End Constructor
	
	Destructor ToolGroup
		WDeallocate FCaption
	End Destructor
	
	Property ToolGroup.CommandID As Integer
        Return FCommandID
    End Property

    Property ToolGroup.CommandID(Value As Integer)
        Dim As Integer i
        If Value <> FCommandID Then
            FCommandID = Value
            If Ctrl Then
                With QControl(Ctrl)
					#IfNDef __USE_GTK__
						i = .Perform(TB_COMMANDTOINDEX,FCommandID,0)
						.Perform(TB_SETCMDID,i,FCommandID)
					#EndIf
                End With
            End If
        End If
    End Property
	
	Function ToolGroup.Index As Integer
		If Ctrl Then
			Return Cast(ToolPalette Ptr, Ctrl)->Groups.IndexOf(@This)
		End If
		Return -1
	End Function
	
	Property ToolGroup.Caption ByRef As WString
		Return WGet(FCaption)
	End Property
	
	Property ToolGroup.Caption(ByRef Value As WString)
		WLet FCaption, Value
		#IfDef __USE_GTK__
			gtk_tool_item_group_set_label(gtk_tool_item_group(widget), ToUTF8(Value))
		#EndIf
	End Property
	
	Property ToolGroup.Name ByRef As WString
		Return WGet(FName)
	End Property
	
	Property ToolGroup.Name(ByRef Value As WString)
		WLet FName, Value
	End Property
	
	Property ToolGroup.Expanded As Boolean
		Return FExpanded
	End Property
	
	Property ToolGroup.Expanded(Value As Boolean)
		FExpanded = Value
		#IfDef __USE_GTK__
			gtk_tool_item_group_set_collapsed(gtk_tool_item_group(widget), Not Value)
		#Else
			If Ctrl Then
                With QControl(Ctrl)
					.Perform(TB_CHECKBUTTON, FCommandID, MakeLong(FExpanded, 0))
					.UpdateLock
		            For i As Integer = 0 To Buttons.Count - 1
		                Buttons.Item(i)->Visible = FExpanded
		            Next
		            .UpdateUnlock
				End With
			End If
		#EndIf
	End Property
	
	Operator ToolGroup.Cast As Any Ptr
        Return @This
    End Operator

	Property ToolGroupButtons.Count As Integer
        Return FButtons.Count
    End Property

    Property ToolGroupButtons.Count(Value As Integer)
    End Property

    Property ToolGroupButtons.Item(Index As Integer) As ToolButton Ptr
        Return Cast(ToolButton Ptr, FButtons.Items[Index])
    End Property
    
    Property ToolGroupButtons.Item(ByRef Key As WString) As ToolButton Ptr
        If IndexOf(Key) <> -1 Then Return Cast(ToolButton Ptr, FButtons.Items[IndexOf(Key)])
        Return 0
    End Property

    Property ToolGroupButtons.Item(Index As Integer, Value As ToolButton Ptr)
       'QToolButton(FButtons.Items[Index]) = Value 
    End Property
    
    Function ToolGroupButtons.Add(FStyle As Integer = tbsAutosize, FImageIndex As Integer = -1, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As Integer = tstEnabled) As ToolButton Ptr
        Dim As ToolButton Ptr PButton
        PButton = New ToolButton
        FButtons.Add PButton
        With *PButton
            .Style          = FStyle
            #IfDef __USE_GTK__
				Select Case FStyle
				Case tbsSeparator
					.widget = gtk_widget(gtk_separator_tool_item_new())
				Case Else
					Select Case FStyle
					Case tbsButton
						.widget = gtk_widget(gtk_tool_button_new(NULL, ToUTF8(FCaption)))
					Case tbsAutosize
						.widget = gtk_widget(gtk_tool_button_new(NULL, ToUTF8(FCaption)))
					Case tbsCheck
						.widget = gtk_widget(gtk_toggle_tool_button_new())
					Case tbsCheckGroup
						If FButtons.Count > 1 AndAlso gtk_is_radio_tool_button(QToolButton(FButtons.Item(FButtons.Count - 2)).widget) Then
							.widget = gtk_widget(gtk_radio_tool_button_new_from_widget(gtk_radio_tool_button(QToolButton(FButtons.Item(FButtons.Count - 2)).widget)))
						Else
							.widget = gtk_widget(gtk_radio_tool_button_new(NULL))
						End If
					Case tbsGroup
						If FButtons.Count > 1 AndAlso gtk_is_radio_tool_button(QToolButton(FButtons.Item(FButtons.Count - 2)).widget) Then
							.widget = gtk_widget(gtk_radio_tool_button_new_from_widget(gtk_radio_tool_button(QToolButton(FButtons.Item(FButtons.Count - 2)).widget)))
						Else
							.widget = gtk_widget(gtk_radio_tool_button_new(NULL))
						End If
					Case tbsDropDown
						.widget = gtk_widget(gtk_menu_tool_button_new(NULL, ToUTF8(FCaption)))
						gtk_menu_tool_button_set_menu(gtk_menu_tool_button(.widget), .DropDownMenu.widget)
						gtk_widget_show_all(.widget)
					Case tbsNoPrefix
						.widget = gtk_widget(gtk_tool_button_new(NULL, ToUTF8(FCaption)))
					Case tbsShowText
						.widget = gtk_widget(gtk_tool_button_new(NULL, ToUTF8(FCaption)))
					Case tbsWholeDropdown
						.widget = gtk_widget(gtk_menu_tool_button_new(NULL, ToUTF8(FCaption)))
						gtk_menu_tool_button_set_menu(gtk_menu_tool_button(.widget), .DropDownMenu.widget)
					Case Else
						.widget = gtk_widget(gtk_tool_button_new(NULL, ToUTF8(FCaption)))
					End Select
					gtk_tool_item_set_tooltip_text(gtk_tool_item(.widget), ToUTF8(FHint))
					g_signal_connect(.widget, "clicked", G_CALLBACK(@ToolButtonClicked), PButton)
				End Select
            #EndIf
            .State        = FState
            .ImageIndex     = FImageIndex
            .Hint           = FHint
            .ShowHint       = FShowHint
            .Name         = FKey
            .Caption        = FCaption
            .CommandID      = (Cast(ToolGroup Ptr, This.Parent)->Index + 1) * 100 + FButtons.Count
            .OnClick        = FClick
        End With
        PButton->Ctrl = @Cast(ToolGroup Ptr, Parent)->Ctrl
        #IfDef __USE_GTK__
			If Parent Then
				gtk_tool_item_group_insert(gtk_tool_item_group(Cast(ToolGroup Ptr, Parent)->widget), gtk_tool_item(PButton->widget), Index)
			End If
        #Else
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
			If This.Parent AndAlso Cast(ToolGroup Ptr, This.Parent)->Ctrl Then
				If Index <> -1 Then
					Cast(ToolGroup Ptr, This.Parent)->Ctrl->Perform(TB_INSERTBUTTON,Index,CInt(@TB))
				Else
					Cast(ToolGroup Ptr, This.Parent)->Ctrl->Perform(TB_ADDBUTTONS,1,CInt(@TB))
				End If
			End If
		#EndIf
        Return PButton
    End Function

    Function ToolGroupButtons.Add(FStyle As Integer = tbsAutosize, ByRef ImageKey As WString, Index As Integer = -1, FClick As Any Ptr = NULL, ByRef FKey As WString = "", ByRef FCaption As WString = "", ByRef FHint As WString = "", FShowHint As Boolean = False, FState As Integer = tstEnabled) As ToolButton Ptr
        Dim As ToolButton Ptr PButton
        #IfDef __USE_GTK__
			PButton = Add(FStyle, -1, Index, FClick, FKey, FCaption, FHint, FShowHint, FState)
        	If PButton Then PButton->ImageKey         = ImageKey
        #Else
			If Parent AndAlso Cast(ToolGroup Ptr, Parent)->Ctrl AndAlso Cast(ToolPalette Ptr, Cast(ToolGroup Ptr, Parent)->Ctrl)->ImagesList Then
				With *Cast(ToolPalette Ptr, Cast(ToolGroup Ptr, Parent)->Ctrl)->ImagesList
					PButton = Add(FStyle, .IndexOf(ImageKey), Index, FClick, FKey, FCaption, FHint, FShowHint, FState)
				End With
			Else
				PButton = Add(FStyle, -1, Index, FClick, FKey, FCaption, FHint, FShowHint, FState)
			End If
		#EndIf
        Return PButton
    End Function
    
    Sub ToolGroupButtons.Remove(Index As Integer)
        FButtons.Remove Index
        If Parent AndAlso Cast(ToolGroup Ptr, Parent)->Ctrl Then
			#IfNDef __USE_GTK__
				Cast(ToolGroup Ptr, Parent)->Ctrl->Perform(TB_DELETEBUTTON,Index,0)
			#EndIf
        End If
    End Sub

    Function ToolGroupButtons.IndexOf(BYREF FButton As ToolButton Ptr) As Integer
        Return FButtons.IndexOF(FButton) 
    End Function

    Function ToolGroupButtons.IndexOf(ByRef Key As WString) As Integer
        For i As Integer = 0 To Count - 1
            If QToolButton(FButtons.Items[i]).Name = Key Then Return i
        Next i
        Return -1
    End Function

    Sub ToolGroupButtons.Clear
        For i As Integer = Count -1 To 0 Step -1
            Delete @QToolButton(FButtons.Items[i])
        Next i
        FButtons.Clear
    End Sub

    Operator ToolGroupButtons.Cast As Any Ptr
        Return @This
    End Operator

    Constructor ToolGroupButtons
        This.Clear
    End Constructor

    Destructor ToolGroupButtons
         This.Clear
    End Destructor
    
    Property ToolGroups.Count As Integer
        Return FGroups.Count
    End Property

    Property ToolGroups.Count(Value As Integer)
    End Property

    Property ToolGroups.Item(Index As Integer) As ToolGroup Ptr
        Return Cast(ToolGroup Ptr, FGroups.Items[Index])
    End Property
    
    Property ToolGroups.Item(ByRef Key As WString) As ToolGroup Ptr
        If IndexOf(Key) <> -1 Then Return Cast(ToolGroup Ptr, FGroups.Items[IndexOf(Key)])
        Return 0
    End Property

    Property ToolGroups.Item(Index As Integer, Value As ToolGroup Ptr)
       'QToolButton(FButtons.Items[Index]) = Value 
    End Property
    
    Function ToolGroups.Add(ByRef Caption As WString, ByRef Key As WString = "") As ToolGroup Ptr
        Dim As ToolGroup Ptr PGroup
        PGroup = New ToolGroup
        FGroups.Add PGroup
        With *PGroup
            .Name         = Key
            .Caption        = Caption
            .CommandID		= (FGroups.Count) * 100
        End With
        PGroup->Ctrl = Parent
        #IfDef __USE_GTK__
			If Parent AndAlso Parent->Widget Then
				gtk_container_add(GTK_CONTAINER (Parent->Widget), PGroup->Widget)
			End If
        #Else
        	If Parent Then
	        	Dim As TBBUTTON TB
	        	If FGroups.Count > 1 Then
					TB.fsState   = TBSTATE_ENABLED Or TBSTATE_WRAP
					TB.fsStyle   = TBSTYLE_SEP
					TB.iBitmap   = -1
					TB.idCommand = 0
					TB.iString = 0
					TB.dwData = 0
					Parent->Perform(TB_ADDBUTTONS, 1, CInt(@TB))
				End If
				TB.fsState   = TBSTATE_ENABLED Or TBSTATE_CHECKED Or TBSTATE_WRAP
				TB.fsStyle   = TBSTYLE_CHECK
				TB.iBitmap   = 0
				TB.idCommand = PGroup->CommandID
				If Caption <> "" Then 
					TB.iString = CInt(@Caption)
				Else
					TB.iString = 0
				End If
				TB.dwData = 0 'Cast(DWord_Ptr,@PButton->DropDownMenu)
				'If Index <> -1 Then
				'	Parent->Parent->Perform(TB_INSERTBUTTON,Index,CInt(@TB))
				'Else
					Parent->Perform(TB_ADDBUTTONS, 1, CInt(@TB))
				'End If
				TB.fsState   = 0
				TB.fsStyle   = TBSTYLE_SEP
				TB.iBitmap   = -1
				TB.idCommand = 0
				TB.iString = 0
				TB.dwData = 0
				Parent->Perform(TB_ADDBUTTONS, 1, CInt(@TB))
			End If
		#EndIf
        Return PGroup
    End Function

    Sub ToolGroups.Remove(Index As Integer)
        FGroups.Remove Index
        If Parent Then
			#IfNDef __USE_GTK__
				Parent->Parent->Perform(TB_DELETEBUTTON,Index,0)
			#EndIf
        End If
    End Sub

    Function ToolGroups.IndexOf(ByRef FGroup As ToolGroup Ptr) As Integer
        Return FGroups.IndexOF(FGroup) 
    End Function

    Function ToolGroups.IndexOf(ByRef Key As WString) As Integer
        For i As Integer = 0 To Count - 1
            If QToolGroup(FGroups.Items[i]).Name = Key Then Return i
        Next i
        Return -1
    End Function

    Sub ToolGroups.Clear
        For i As Integer = Count - 1 To 0 Step -1
            Delete @QToolGroup(FGroups.Items[i])
        Next i
        FGroups.Clear
    End Sub

    Operator ToolGroups.Cast As Any Ptr
        Return @This
    End Operator

    Constructor ToolGroups
        This.Clear
    End Constructor

    Destructor ToolGroups
         This.Clear
    End Destructor
    
    Sub ToolPalette.GetDropDownMenuItems
        FPopupMenuItems.Clear
        'For j As Integer = 0 To Buttons.Count - 1
        '    For i As Integer = 0 To Buttons.Item(j)->DropDownMenu.Count -1
        '        EnumPopupMenuItems *Buttons.Item(j)->DropDownMenu.Item(i)
        '    Next i
        'Next j
    End Sub
    
    Property ToolPalette.AutoSize As Boolean
        #IfNDef __USE_GTK__
			FAutoSize = StyleExists(TBSTYLE_AUTOSIZE)
        #EndIf
        Return FAutoSize
    End Property

    Property ToolPalette.AutoSize(Value As Boolean)
        FAutoSize = Value
        #IfNDef __USE_GTK__
			ChangeStyle TBSTYLE_AUTOSIZE, Value
			If FHandle Then if FAutosize Then Perform(TB_AUTOSIZE, 0, 0)
		#EndIf
    End Property

	Property ToolPalette.Style As Integer
        Return FStyle
    End Property

    Property ToolPalette.Style(Value As Integer)
        FStyle = Value
        #IfDef __USE_GTK__
			Dim As GtkToolBarStyle gStyle 
			Select Case FStyle
			Case 0: gStyle = GTK_TOOLBAR_ICONS
			Case 1: gStyle = GTK_TOOLBAR_TEXT
			Case 2: gStyle = GTK_TOOLBAR_BOTH
			Case 3: gStyle = GTK_TOOLBAR_BOTH_HORIZ
			End Select
			gtk_tool_palette_set_style(gtk_tool_palette(widget), gStyle)
			'For i As Integer = 0 To Groups.Count - 1
			'	For j As Integer = 0 To Groups.Item(i)->Buttons.Count - 1
			'		With *Groups.Item(i)->Buttons.Item(i)
			'			.ImageKey = .ImageKey
			'		End With
			'	Next j
			'Next i
			If gtk_is_container(widget) Then gtk_widget_queue_resize(widget)
			gtk_widget_queue_draw(widget) 
		#Else
			For j As Integer = 0 To Groups.Count - 1
				For i As Integer = 0 To Groups.Item(j)->Buttons.Count - 1
					With *Cast(ToolButton Ptr, Groups.Item(j)->Buttons.Item(i))
						If Value = 0 Then
							
						End If
						If Value = 0 Then
							.Caption = ""
							.Style = tbsCheckGroup Or tbsAutosize
						Else
							.Caption = .Name
							.Style = tbsCheckGroup
						End If
					End With
				Next i
			Next j
			ChangeStyle TBSTYLE_AUTOSIZE, Value
			If FHandle Then 
				if FAutosize Then Perform(TB_AUTOSIZE, 0, 0)
				RecreateWnd
			End If
		#EndIf
    End Property

    Property ToolPalette.Flat As Boolean
        #IfNDef __USE_GTK__
			FFlat = StyleExists(TBSTYLE_FLAT)
        #EndIf
        Return FFlat
    End Property

    Property ToolPalette.Flat(Value As Boolean)
        FFlat = Value
        #IfNDef __USE_GTK__
			ChangeStyle TBSTYLE_FLAT, Value
		#EndIf
    End Property
    
    Property ToolPalette.List As Boolean
        #IfNDef __USE_GTK__
			FList = StyleExists(TBSTYLE_LIST)
        #EndIf
        Return FList
    End Property

    Property ToolPalette.List(Value As Boolean)
        FList = Value
        #IfNDef __USE_GTK__
			ChangeStyle TBSTYLE_LIST, Value
		#EndIf
    End Property
    

    Property ToolPalette.Divider As Boolean
        #IfNDef __USE_GTK__
			FDivider = Not StyleExists(CCS_NODIVIDER)
        #EndIf
        Return FDivider
    End Property

    Property ToolPalette.Divider(Value As Boolean)
        FDivider = Value
        #IfNDef __USE_GTK__
			ChangeStyle CCS_NODIVIDER, Not Value
		#EndIf
    End Property

    Property ToolPalette.Transparency As Boolean
        #IfNDef __USE_GTK__
			FTransparent = StyleExists(TBSTYLE_TRANSPARENT)
        #EndIf
        Return FTransparent
    End Property

    Property ToolPalette.Transparency(Value As Boolean)
        FTransparent = Value
        #IfNDef __USE_GTK__
			ChangeStyle TBSTYLE_TRANSPARENT, Value
		#EndIf
    End Property

    Property ToolPalette.ButtonWidth As Integer
        Return FButtonWidth
    End Property

    Property ToolPalette.ButtonWidth(Value As Integer)
        FButtonWidth = Value
        #IfNDef __USE_GTK__
			If Handle Then Perform(TB_SETBUTTONSIZE,0,MakeLong(FButtonWidth,FButtonHeight))
		#EndIf
    End Property

    Property ToolPalette.ButtonHeight As Integer
        Return FButtonHeight
    End Property

    Property ToolPalette.ButtonHeight(Value As Integer)
        FButtonHeight = Value
        #IfNDef __USE_GTK__
			If Handle Then Perform(TB_SETBUTTONSIZE,0,MakeLong(FButtonWidth,FButtonHeight))
		#EndIf
    End Property

    Property ToolPalette.Wrapable As Boolean
        #IfNDef __USE_GTK__
			FWrapable = StyleExists(TBSTYLE_WRAPABLE)
        #EndIf
        Return FWrapable
    End Property

    Property ToolPalette.Wrapable(Value As Boolean)
        FWrapable = Value
        #IfNDef __USE_GTK__
			ChangeStyle TBSTYLE_WRAPABLE, Value
		#EndIf
	End Property

    Sub ToolPalette.WndProc(BYREF Message As Message)
	End Sub

		Sub ToolPalette.ProcessMessage(BYREF Message As Message)
		#IfNDef __USE_GTK__
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
					'Index = Perform(TB_COMMANDTOINDEX, Message.wParam, 0)
					Dim As Integer gi, bi
					Dim As String comm = Trim(Str(Message.wParam))
					gi = Val(Left(comm, Len(comm) - 2)) - 1
					bi = Val(Mid(comm, Len(comm) - 1)) - 1
					If gi > -1 AndAlso gi < Groups.Count Then
						If bi = -1 Then
							Groups.Item(gi)->Expanded = Not Groups.Item(gi)->Expanded
						ElseIf bi > -1 AndAlso bi < Groups.Item(gi)->Buttons.Count Then
							Dim As ToolButton Ptr but = Groups.Item(gi)->Buttons.Item(bi)
							If but->OnClick Then but->OnClick(*but)
						End If
					End If
				End If
			Case CM_NOTIFY
				Dim As TBNOTIFY PTR Tbn
				Dim As TBBUTTON TB
				Dim As RECT R
				Dim As Integer i
				Tbn = Cast(TBNOTIFY PTR,Message.lParam) 
				Select Case Tbn->hdr.Code
				Case TBN_DROPDOWN
					 If Tbn->iItem <> -1 Then 
						 SendMessage(Tbn->hdr.hwndFrom,TB_GETRECT,Tbn->iItem,CInt(@R))
						 MapWindowPoints(Tbn->hdr.hwndFrom,0,Cast(Point Ptr,@R),2)
						 i = SendMessage(Tbn->hdr.hwndFrom,TB_COMMANDTOINDEX,Tbn->iItem,0)
						 If SendMessage(Tbn->hdr.hwndFrom,TB_GETBUTTON,i,CInt(@TB)) Then
							 'TrackPopupMenu(Buttons.Item(i)->DropDownMenu.Handle,0,R.Left,R.Bottom,0,Tbn->hdr.hwndFrom,NULL)
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
'					   If Buttons.Item(Index)->ShowHint Then
'						  If Buttons.Item(Index)->Hint <> "" Then
'							  'Dim As UString s 
'							  's = Buttons.Button(Index).Hint
'							  TTX->lpszText = @(Buttons.Item(Index)->Hint)
'						  End If
'					   End If
					End If
				End If
			End Select
		#EndIf
			Base.ProcessMessage(message)
		End Sub

		Sub ToolPalette.HandleIsDestroyed(BYREF Sender As Control)
		End Sub

		Sub ToolPalette.HandleIsAllocated(BYREF Sender As Control)
			#IfNDef __USE_GTK__
			If Sender.Child Then
				With QToolPalette(Sender.Child)
					If .ImagesList Then .ImagesList->ParentWindow = @Sender: If .ImagesList->Handle Then .Perform(TB_SETIMAGELIST,0,CInt(.ImagesList->Handle))
					If .HotImagesList Then .HotImagesList->ParentWindow = @Sender: If .HotImagesList->Handle Then .Perform(TB_SETHOTIMAGELIST,0,CInt(.HotImagesList->Handle))
					If .DisabledImagesList Then .DisabledImagesList->ParentWindow = @Sender: If .DisabledImagesList->Handle Then .Perform(TB_SETDISABLEDIMAGELIST,0,CInt(.DisabledImagesList->Handle))
					.Perform(TB_BUTTONSTRUCTSIZE,SizeOF(TBBUTTON),0)
					.Perform(TB_SETEXTENDEDSTYLE, 0, .Perform(TB_GETEXTENDEDSTYLE, 0, 0) OR TBSTYLE_EX_DRAWDDARROWS)
					.Perform(TB_SETBUTTONSIZE,0,MakeLong(.ButtonWidth,.ButtonHeight))
					.Perform(TB_SETBITMAPSIZE,0,MakeLong(.ButtonWidth,.ButtonHeight))
					Dim As TBBUTTON TB
					For j As Integer = 0 To .Groups.Count -1
						If j > 0 Then
							TB.fsState   = 0
							TB.fsStyle   = TBSTYLE_SEP
							TB.iBitmap   = -1
							TB.idCommand = 0
							TB.iString = 0
							TB.dwData = 0
							.Perform(TB_ADDBUTTONS, 1, CInt(@TB))
						End If
						TB.fsState   = TBSTATE_ENABLED Or TBSTATE_CHECKED Or TBSTATE_WRAP
						TB.fsStyle   = TBSTYLE_CHECK
						TB.iBitmap   = 0
						TB.idCommand = .Groups.Item(j)->CommandID
						If .Groups.Item(j)->Caption <> "" Then
							TB.iString = CInt(@.Groups.Item(j)->Caption)
						Else
							TB.iString = 0
						End If
						TB.dwData = 0 'Cast(DWord_Ptr,@PButton->DropDownMenu)
						.Perform(TB_ADDBUTTONS, 1, CInt(@TB))
						TB.fsState   = 0
						TB.fsStyle   = TBSTYLE_SEP
						TB.iBitmap   = -1
						TB.idCommand = 0
						TB.iString = 0
						TB.dwData = 0
						.Perform(TB_ADDBUTTONS, 1, CInt(@TB))
						For i As Integer = 0 To .Groups.Item(j)->Buttons.Count - 1
							.Groups.Item(j)->Buttons.Item(i)->Ctrl = @Sender
							'Dim As WString Ptr s = .Buttons.Button(i)->Caption
							If i = .Groups.Item(j)->Buttons.Count - 1 Then
								TB.fsState = .Groups.Item(j)->Buttons.Item(i)->State Or TBSTATE_WRAP
							Else
								TB.fsState = .Groups.Item(j)->Buttons.Item(i)->State
							End If
							TB.fsStyle   = .Groups.Item(j)->Buttons.Item(i)->Style
							TB.iBitmap   = .Groups.Item(j)->Buttons.Item(i)->ImageIndex
							TB.idCommand = .Groups.Item(j)->Buttons.Item(i)->CommandID
							If .Groups.Item(j)->Buttons.Item(i)->Caption <> "" Then
								TB.iString   = CInt(@.Groups.Item(j)->Buttons.Item(i)->Caption)
							Else
								TB.iString   = 0
							End If
							TB.dwData    = Cast(DWord_Ptr, @.Groups.Item(j)->Buttons.Item(i)->DropDownMenu)
							.Perform(TB_ADDBUTTONS, 1, CInt(@TB))
						Next i
					Next j
					If .AutoSize Then .Perform(TB_AUTOSIZE,0,0)
				End With
			End If
			#EndIf
		End Sub
	

    Operator ToolPalette.Cast As Control Ptr 
        Return @This
    End Operator

    Constructor ToolPalette
		With This
        FButtonWidth    = 16
        FButtonHeight   = 16
        #IfDef __USE_GTK__
			widget = gtk_tool_palette_new()
			scrolledwidget = gtk_scrolled_window_new(NULL, NULL)
			gtk_scrolled_window_set_policy(gtk_scrolled_window(scrolledwidget), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
			gtk_container_add(gtk_container(scrolledwidget), widget)
			.RegisterClass "ToolPalette", @This
        #Else
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
		#EndIf
        FTransparent    = 1
        FAutosize       = 1
        FButtonWidth    = 16
        FButtonHeight   = 16
        Groups.Parent  = @This
        FEnabled = True
            #IfNDef __USE_GTK__
				.OnHandleIsAllocated = @HandleIsAllocated
				.OnHandleIsDestroyed = @HandleIsDestroyed
				.ChildProc         = @WndProc
				.ExStyle           = 0
				Base.Style             = WS_CHILD OR TBSTYLE_TOOLTIPS OR CCS_NOPARENTALIGN OR CCS_NOMOVEY OR AList(FList) Or AAutosize(_Abs(FAutosize)) OR AFlat(_Abs(FFlat)) OR ADivider(_Abs(FDivider)) OR AWrap(_Abs(FWrapable)) OR ATransparent(_Abs(FTransparent))
				.RegisterClass "ToolPalette", "ToolBarWindow32"
            #EndIf
            .Child             = @This
            WLet FClassName, "ToolPalette"
            WLet FClassAncestor, "ToolBarWindow32"
            .Width             = 121
            .Height            = 26
            '.Font              = @Font
            '.Cursor            = @Cursor
        End With 
    End Constructor

    Destructor ToolPalette
    	Groups.Clear
		#IfNDef __USE_GTK__
			'UnregisterClass "ToolPalette", GetmoduleHandle(NULL)
		#EndIf
    End Destructor
End Namespace
