'###############################################################################
'#  TabControl.bi                                                              #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TTabControl.bi                                                            #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include Once "Panel.bi"
#include Once "Menus.bi"
#include Once "ImageList.bi"

Namespace My.Sys.Forms
    #DEFINE QTabControl(__Ptr__) *Cast(TabControl Ptr,__Ptr__)
    #DEFINE QTabPage(__Ptr__) *Cast(TabPage Ptr, __Ptr__)

    Enum TabStyle
        tsTabs,tsButtons,tsOwnerDrawFixed
    End Enum

    Enum TabPosition
        tpLeft,tpRight,tpTop,tpBottom
    End Enum

    Type PTabControl As TabControl Ptr
    
    Type TabPage Extends Panel
        Protected:
            FCaption    As WString Ptr
            FObject     As Any Ptr
            FImageIndex As Integer
            FImageKey   As WString Ptr
        	#IfNDef __USE_GTK__
        		FTheme		As HTHEME
        	#EndIf
        Public:
        	Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
            Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
            Declare Sub ProcessMessage(ByRef msg As Message)
            #IfDef __USE_GTK__
            	_Box			As GtkWidget Ptr
				_Icon			As GtkWidget Ptr
				_Label			As GtkWidget Ptr
			#Else
				Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
			#EndIf
			UseVisualStyleBackColor As Boolean
            Declare Property Index As Integer
            Declare Property Caption ByRef As WString
            Declare Property Caption(ByRef Value As WString)
            Declare Property Text ByRef As WString
            Declare Property Text(ByRef Value As WString)
            Declare Property Object As Any Ptr
            Declare Property Object(Value As Any Ptr)
            Declare Property ImageIndex As Integer
            Declare Property ImageIndex(Value As Integer)
            Declare Property ImageKey ByRef As WString
            Declare Property ImageKey(ByRef Value As WString)
            Declare Property Parent As PTabControl
            Declare Property Parent(Value As PTabControl)
            Declare Operator Let(ByRef Value As WString)
            Declare Operator Cast As Control Ptr
            Declare Operator Cast As Any Ptr
            Declare Sub SelectTab()
            Declare Sub Update()
            Declare Constructor
            Declare Destructor
            OnSelected   As Sub(BYREF Sender As TabPage)
            OnDeSelected As Sub(BYREF Sender As TabPage) 
    End Type

    Type TabControl Extends ContainerControl
        Private:
            FTabIndex     As Integer
            FTabCount     As Integer 
            FMultiline    As Boolean
            FFlatButtons  As Boolean
            FTabPosition  As My.Sys.Forms.TabPosition
            FTabStyle     As My.Sys.Forms.TabStyle
            Declare Sub SetMargins()
            #IfNDef __USE_GTK__
				Declare Static Sub WndProc(BYREF Message As Message)
				Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
				Declare Sub ProcessMessage(BYREF Message As Message)
			#EndIf
        Public:
			Images        As ImageList Ptr
            Tabs             As TabPage Ptr Ptr
            Declare Virtual Function ReadProperty(ByRef PropertyName As String) As Any Ptr
            Declare Virtual Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
            Declare Property TabIndex As Integer
            Declare Property TabIndex(Value As Integer)
            Declare Property TabCount As Integer
            Declare Property TabCount(Value As Integer)
            Declare Property TabPosition As My.Sys.Forms.TabPosition
            Declare Property TabPosition(Value As My.Sys.Forms.TabPosition)
            Declare Property TabStyle As My.Sys.Forms.TabStyle
            Declare Property TabStyle(Value As My.Sys.Forms.TabStyle)
            Declare Property FlatButtons As Boolean
            Declare Property FlatButtons(Value As Boolean)
            Declare Property Multiline As Boolean
            Declare Property Multiline(Value As Boolean)
            Declare Property SelectedTab As TabPage Ptr
            Declare Property SelectedTab(Value As TabPage Ptr)
            Declare Property Tab(Index As Integer) As TabPage Ptr
            Declare Property Tab(Index As Integer, Value As TabPage Ptr)
            Declare Function ItemLeft(Index As Integer) As Integer
            Declare Function ItemTop(Index As Integer) As Integer
            Declare Function ItemWidth(Index As Integer) As Integer
            Declare Function ItemHeight(Index As Integer) As Integer
            Declare Operator Cast As My.Sys.Forms.Control Ptr
            Declare Function IndexOfTab(Value As TabPage Ptr) As Integer
            Declare Function AddTab(ByRef Caption As WString, AObject As Any Ptr = 0, ImageIndex As Integer = -1) As TabPage Ptr
            Declare Function AddTab(ByRef Caption As WString, AObject As Any Ptr = 0, ByRef ImageKey As WString) As TabPage Ptr
            Declare Sub AddTab(ByRef tTab As TabPage Ptr)
            Declare Sub DeleteTab(Index As Integer)
            Declare Sub InsertTab(Index As Integer, ByRef Caption As WString, AObject As Any Ptr = 0)
            Declare Sub Clear
            Declare Constructor
            Declare Destructor
            OnSelChange   As Sub(BYREF Sender As TabControl, NewIndex As Integer)
            OnSelChanging As Sub(BYREF Sender As TabControl, NewIndex As Integer)
            OnGotFocus   As Sub(BYREF Sender As TabControl)
            OnLostFocus   As Sub(BYREF Sender As TabControl)
    End Type

	#IfNDef ReadProperty_Off
	    Function TabPage.ReadProperty(ByRef PropertyName As String) As Any Ptr
	        Select Case LCase(PropertyName)
	        Case "parent": Return FParent
	        Case "text": Return FText
	        Case "caption": Return FText
	        Case "usevisualstylebackcolor": Return @UseVisualStyleBackColor
	        Case Else: Return Base.ReadProperty(PropertyName)
	        End Select
	        Return 0
	    End Function
    #EndIf
    
    #IfNDef WriteProperty_Off
        Function TabPage.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
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
    #EndIf
    
    #IfNDef __USE_GTK__
    	Sub TabPage.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QTabPage(Sender.Child)
					If .UseVisualStyleBackColor Then
						SetWindowTheme(.Handle, NULL, "TAB")
					End If
					.FTheme = OpenThemeData(.Handle, "Window")
				End With
			End If
    	End Sub
    #EndIf

    Sub TabPage.ProcessMessage(ByRef msg As Message)
    	#IfNDef __USE_GTK__
	    	FTheme = GetWindowTheme(Msg.hWnd)
			Dim As RECT rct
			Select Case msg.msg
			Case WM_DESTROY
				CloseThemeData(FTheme)
			Case WM_CTLCOLORSTATIC
				If UseVisualStyleBackColor Then
					GetClientRect(Cast(HWND, Msg.lParam), @rct)
					DrawThemeParentBackground(Cast(HWND, Msg.lParam), Cast(HDC, Msg.wParam), @rct)
					SetBkMode(Cast(HDC, Msg.wParam), TRANSPARENT)
					Msg.Result = Cast(LRESULT, GetStockObject(NULL_BRUSH))
					Return
				End If
			Case WM_PAINT
				If UseVisualStyleBackColor Then
					GetClientRect(Msg.hWnd, @rct)
					DrawThemeBackground(FTheme, Cast(HDC, Msg.wParam), 10, 0, @rct, NULL) 'TABP_BODY = 10
					'Msg.Result = True
					Return
				End If
			Case WM_ERASEBKGND
				If UseVisualStyleBackColor Then
					GetClientRect(Msg.hWnd, @rct)
					DrawThemeBackground(FTheme, Cast(HDC, Msg.wParam), 10, 0, @rct, NULL) 'TABP_BODY = 10
					Msg.Result = 1
					Return
				End If
			Case WM_PRINTCLIENT
				If UseVisualStyleBackColor Then
					Dim As RECT rct
					GetClientRect(Msg.hWnd, @rct)
					FillRect(Cast(HDC, Msg.wParam), @rct, GetStockObject(NULL_BRUSH))
					Msg.Result = TRUE
					Return
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
    	#EndIf
    	Base.ProcessMessage(msg)
    End Sub
        
    Property TabPage.Index As Integer
        If This.Parent AndAlso *Base.Parent Is TabControl Then
            Return Cast(TabControl Ptr, This.Parent)->IndexOfTab(@This)
        End If
        Return -1
    End Property
        
    Sub TabPage.Update()
        If This.Parent AndAlso *Base.Parent Is TabControl Then
            #IfNDef __USE_GTK__
				If This.Parent->Handle Then
					Dim As TCITEM Ti
					Ti.mask = TCIF_TEXT OR TCIF_IMAGE OR TCIF_PARAM
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
			#EndIf
        End If
    End Sub
    
    Sub TabPage.SelectTab()
        If This.Parent AndAlso *Base.Parent Is TabControl Then
            Cast(TabControl Ptr, This.Parent)->TabIndex = Index
        End If
    End Sub
    
    Property TabPage.Caption ByRef As WString
        Return Text
    End Property

    Property TabPage.Caption(ByRef Value As WString)
        Text = Value
    End Property
    
    Property TabPage.Text ByRef As WString
        Return WGet(FCaption)
    End Property

    Property TabPage.Text(ByRef Value As WString)
        WLet FCaption, Value
        #IfDef __USE_GTK__
			If gtk_is_label(_Label) Then
				gtk_label_set_text(gtk_Label(_Label), ToUTF8(Value))
			End If
        #Else
			Update
        #EndIf
    End Property
    
    #IfNDef Parent_Off
        Property TabPage.Parent As TabControl Ptr
			Return Cast(TabControl Ptr, FParent)
		End Property
		
        Property TabPage.Parent(Value As TabControl Ptr)
			FParent = Value
			If Value Then Value->AddTab(@This)
		End Property
    #EndIf

    Property TabPage.Object As Any Ptr
        Return FObject
    End Property

    Property TabPage.Object(Value As Any Ptr)
        FObject = Value
        Update
    End Property

    Property TabPage.ImageIndex As Integer
        Return FImageIndex
    End Property

    Property TabPage.ImageIndex(Value As Integer)
        FImageIndex = Value
        Update
    End Property

    Property TabPage.ImageKey ByRef As WString
        Return *FImageKey
    End Property

    Property TabPage.ImageKey(ByRef Value As WString)
        WLet FImageKey, Value
        Update
    End Property

    Operator TabPage.Cast As Any Ptr
        Return @This
    End Operator

    Operator TabPage.Let(ByRef Value As WString)
        Caption = Value
    End Operator
    
    Operator TabPage.Cast As Control Ptr 
        Return Cast(Control Ptr, @This)
    End Operator

    Constructor TabPage
        Caption = ""
        FObject    = 0
        FImageIndex        = 0
        'Anchor.Left = asAnchor
        'Anchor.Top = asAnchor
        'Anchor.Right = asAnchor
        'Anchor.Bottom = asAnchor
        WLet FClassName, "TabPage"
        WLet FClassAncestor, "Panel"
        Child = @This
        #IfDef __USE_GTK__
			This.RegisterClass "TabPage", @This
        #Else
			Align = 5
			Base.Style = WS_CHILD Or DS_SETFOREGROUND
			This.OnHandleIsAllocated = @HandleIsAllocated
        	This.RegisterClass "TabPage", "Panel"
        #EndIf
    End Constructor

    Destructor TabPage
        If FParent <> 0 Then Parent->DeleteTab(Parent->IndexOf(@This))
    	WDeallocate FCaption
    End Destructor
    
    #IfNDef ReadProperty_Off
	    Function TabControl.ReadProperty(ByRef PropertyName As String) As Any Ptr
	        Select Case LCase(PropertyName)
	        Case "tabindex": Return @FTabIndex
	        Case Else: Return Base.ReadProperty(PropertyName)
	        End Select
	        Return 0
	    End Function
    #EndIf
    
    #IfNDef WriteProperty_Off
        Function TabControl.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
	        If Value = 0 Then
	            Select Case LCase(PropertyName)
	            Case Else: Return Base.WriteProperty(PropertyName, Value)
	            End Select
	        Else
	            Select Case LCase(PropertyName)
	            Case "tabindex": This.TabIndex = QInteger(Value)
	            Case Else: Return Base.WriteProperty(PropertyName, Value)
	            End Select
	        End If
	        Return True
	    End Function
    #EndIf
    
    Property TabControl.TabIndex As Integer
		#IfDef __USE_GTK__
			Return gtk_notebook_get_current_page(gtk_notebook(widget))
		#Else
			Return Perform(TCM_GETCURSEL,0,0) 
		#EndIf
    End Property
        
    Property TabControl.TabIndex(Value As Integer)
        FTabIndex = Value
        #IfDef __USE_GTK__
			gtk_notebook_set_current_page(gtk_notebook(widget), Value)
        #Else
			If Handle Then
				Perform(TCM_SETCURSEL,FTabIndex,0)
				Dim Id As Integer = TabIndex
				For i As Integer = 0 To TabCount - 1
					Tabs[i]->Visible = i = Id
					If DesignMode Then
						ShowWindow(Tabs[i]->Handle, Abs_(i = Id))
						If i <> Id Then SetWindowPos Tabs[i]->Handle, HWND_BOTTOM, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE
					End If
				Next i
				RequestAlign
				If OnSelChange Then OnSelChange(This, Id)
			End If
		#EndIf
    End Property

    Sub TabControl.SetMargins()
        Select Case FTabPosition
        Case 0: Base.SetMargins 4 + ItemWidth(0), 2, 4, 3
        Case 1: Base.SetMargins 2, 2, 4 + ItemWidth(0), 3
        Case 2: Base.SetMargins 2, 4 + ItemHeight(0), 4, 3
        Case 3: Base.SetMargins 2, 2, 2, 4 + ItemHeight(0)
        End Select
    End Sub
    
    Property TabControl.TabPosition As My.Sys.Forms.TabPosition
        Return FTabPosition 
    End Property
        
    Property TabControl.TabPosition(Value As My.Sys.Forms.TabPosition)
        FTabPosition = Value
        #IfDef __USE_GTK__
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
        #Else
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
		#EndIf
        SetMargins
    End Property
        
    Property TabControl.TabStyle As My.Sys.Forms.TabStyle
       Return FTabStyle
    End Property
        
    Property TabControl.TabStyle(Value As My.Sys.Forms.TabStyle)
        FTabStyle = Value
        #IfNDef __USE_GTK__
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
		#EndIf
	End Property
        
    Property TabControl.FlatButtons As Boolean
       Return FFlatButtons
    End Property
        
    Property TabControl.FlatButtons(Value As Boolean)
       FFlatButtons = Value
       #IfNDef __USE_GTK__
			Select Case FFlatButtons
		   Case True
			   If (Style AND TCS_FLATBUTTONS) <> TCS_FLATBUTTONS Then
				  Style = Style OR TCS_FLATBUTTONS
			   End If
		   Case False
			   If (Style AND TCS_FLATBUTTONS) = TCS_FLATBUTTONS Then
				  Style = Style AND NOT TCS_FLATBUTTONS
			   End If
		   End Select
		#EndIf 
       'RecreateWnd
    End Property
        
    Property TabControl.Multiline As Boolean
       Return FMultiline
    End Property
        
    Property TabControl.Multiline(Value As Boolean)
       FMultiline = Value
       #IfNDef __USE_GTK__
			Select Case FMultiline
		   Case False
			   If (Style AND TCS_MULTILINE) = TCS_MULTILINE Then
				  Style = Style AND NOT TCS_MULTILINE
			   End If
			   If (Style AND TCS_SINGLELINE) <> TCS_SINGLELINE Then
				  Style = Style OR TCS_SINGLELINE
			   End If
		   Case True
			   If (Style AND TCS_MULTILINE) <> TCS_MULTILINE Then
				  Style = Style OR TCS_MULTILINE
			   End If
			   If (Style AND TCS_SINGLELINE) = TCS_SINGLELINE Then
				  Style = Style AND NOT TCS_SINGLELINE
			   End If
		   End Select
		#EndIf
       RecreateWnd
    End Property
        
    Property TabControl.TabCount As Integer
       #IfNDef __USE_GTK__
		   If Handle Then
			   FTabCount = Perform(TCM_GETITEMCOUNT,0,0)
		   End If
		#EndIf
       Return FTabCount
    End Property
        
    Property TabControl.TabCount(Value As Integer)
    End Property
        
    Property TabControl.Tab(Index As Integer) As TabPage Ptr
       Return Tabs[Index]
    End Property
        
    Property TabControl.Tab(Index As Integer,Value As TabPage Ptr)
    End Property
    
    Property TabControl.SelectedTab As TabPage Ptr
        If TabIndex >= 0 And TabIndex <= TabCount - 1 Then
            Return Tabs[TabIndex]
        Else
            Return 0
        End If
    End Property
        
    Property TabControl.SelectedTab(Value As TabPage Ptr)
        TabIndex = IndexOfTab(Value)
    End Property
    
    Function TabControl.ItemHeight(Index As Integer) As Integer
        If Index >= 0 AND Index < TabCount Then
            #IfDef __USE_GTK__
            	#IfDef __USE_GTK3__
					Return gtk_widget_get_allocated_height(gtk_notebook_get_tab_label(gtk_notebook(widget), Tabs[Index]->Widget))
            	#Else
            		Return gtk_notebook_get_tab_label(gtk_notebook(widget), Tabs[Index]->Widget)->allocation.height
            	#EndIf
            #Else
				Dim As Rect R
				Perform(TCM_GETITEMRECT,Index,CInt(@R))
				Return (R.Bottom - R.Top)
			#EndIf
        End If
        Return 0
    End Function

    Function TabControl.ItemWidth(Index As Integer) As Integer
        If Index >= 0 AND Index < TabCount Then
            #IfDef __USE_GTK__
            	#IfDef __USE_GTK3__
					Return gtk_widget_get_allocated_width(gtk_notebook_get_tab_label(gtk_notebook(widget), Tabs[Index]->Widget))
            	#Else
            		Return gtk_notebook_get_tab_label(gtk_notebook(widget), Tabs[Index]->Widget)->allocation.width
            	#EndIf
            #Else
				Dim As Rect R
				Perform(TCM_GETITEMRECT,Index,CInt(@R))
				Return (R.Right - R.Left)
			#EndIf
        End If
        Return 0
    End Function

    Function TabControl.ItemLeft(Index As Integer) As Integer
        If Index >= 0 AND Index < TabCount Then
            #IfNDef __USE_GTK__
				Dim As Rect R
				Perform(TCM_GETITEMRECT,Index,CInt(@R))
				Return R.Left
			#EndIf
        End If
        Return 0
    End Function

    Function TabControl.ItemTop(Index As Integer) As Integer
        If Index >= 0 AND Index < TabCount Then
            #IfNDef __USE_GTK__
				Dim As Rect R
				Perform(TCM_GETITEMRECT,Index,CInt(@R))
				Return R.Top
			#EndIf
        End If
        Return 0
    End Function

	#IfNDef __USE_GTK__
		Sub TabControl.WndProc(BYREF Message As Message)
		End Sub

		Sub TabControl.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QTabControl(Sender.Child)
					If .Images Then .Images->ParentWindow = Sender
					If .Images AndAlso .Images->Handle Then .Perform(TCM_SETIMAGELIST,0,CInt(.Images->Handle))
					For i As Integer = 0 To .FTabCount - 1
						Dim As TCITEMW Ti
						Ti.mask = TCIF_TEXT OR TCIF_IMAGE OR TCIF_PARAM
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

		Sub TabControl.ProcessMessage(BYREF Message As Message)
			Select Case Message.Msg
			Case CM_DRAWITEM
				If FTabPosition = tpLeft Or FTabPosition = tpRight Then
					Dim As LogFont LogRec
					  Dim As hFont OldFontHandle, NewFontHandle
					Dim hdc as hdc
					GetObject Font.Handle, SizeOf(LogRec), @LogRec
					  LogRec.lfEscapement = 90 * 10
					  NewFontHandle = CreateFontIndirect(@LogRec)
					hdc = GetDc(FHandle)
					OldFontHandle = SelectObject(hdc, NewFontHandle)
					SetBKMode(hdc,TRANSPARENT)
					For i As Integer = 0 To TabCount - 1
						.TextOut(hdc,IIF(FTabPosition = tpLeft, 2, This.Width - ItemWidth(i)),ItemTop(i) + ItemHeight(i) - 5,Tabs[i]->Caption,Len(Tabs[i]->Caption))
					Next i
					SetBKMode(hdc,OPAQUE)
					NewFontHandle = SelectObject(hdc, OldFontHandle)
					  ReleaseDc FHandle, hdc
					DeleteObject(NewFontHandle)
				End If
				Message.Result = 0
			Case WM_SIZE
			Case CM_COMMAND
			Case CM_NOTIFY
				Dim As LPNMHDR NM 
				NM = Cast(LPNMHDR,Message.lParam)
				If NM->Code = TCN_SELCHANGE Then
					TabIndex = TabIndex
				End If
			Case WM_NCHITTEST
				If DesignMode Then Exit Sub
			End Select
			Base.ProcessMessage(Message)
		End Sub
	#EndIf

    Function TabControl.AddTab(ByRef Caption As WString, aObject As Any Ptr = 0, ImageIndex As Integer = -1) As TabPage Ptr
        FTabCount += 1
        Dim tb As TabPage Ptr = New TabPage
        tb->Caption = Caption
        tb->Object = AObject
        tb->ImageIndex = ImageIndex
        Tabs = Reallocate(Tabs, SizeOF(TabPage) * FTabCount)
        Tabs[FTabCount - 1] = tb
        #IfDef __USE_GTK__
        	If widget Then
        		#IfDef __USE_GTK3__
					tb->_box = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 1)
				#Else
					tb->_box = gtk_hbox_new(false, 1)
				#EndIf
				tb->_icon = gtk_image_new_from_icon_name(ToUTF8(tb->ImageKey), GTK_ICON_SIZE_MENU)
				gtk_container_add (GTK_CONTAINER (tb->_box), tb->_icon)
        		tb->_label = gtk_label_new(ToUTF8(tb->Caption))
        		gtk_container_add (GTK_CONTAINER (tb->_box), tb->_label)
        		'gtk_box_pack_end (GTK_BOX (tp->_box), tp->_label, TRUE, TRUE, 0)
        		gtk_widget_show_all(tb->_box)
        		gtk_notebook_append_page(gtk_notebook(widget), tb->widget, tb->_box)
				'gtk_notebook_append_page(gtk_notebook(widget), tb->widget, gtk_label_new(ToUTF8(Caption)))
        	End If
        #Else
			If Handle Then
				Dim As TCITEMW Ti
				Dim As Integer LenSt = Len(Caption) + 1
				Dim As WString Ptr St = CAllocate(LenSt * Len(WString))
				St = @Caption
				Ti.mask = TCIF_TEXT OR TCIF_IMAGE OR TCIF_PARAM
				Ti.pszText    = St
				Ti.cchTextMax = LenSt
				If Tabs[FTabCount - 1]->Object Then Ti.lParam = Cast(LPARAM, Tabs[FTabCount - 1]->Object)
				Ti.iImage = Tabs[FTabCount - 1]->ImageIndex
				SendmessageW(FHandle, TCM_INSERTITEMW, FTabCount - 1, CInt(@Ti))
			End If
			SetMargins
		#EndIf
		This.Add(tb)
        tb->Visible = FTabCount = 1
        Return Tabs[FTabCount - 1]
    End Function
    
    Function TabControl.AddTab(ByRef Caption As WString, aObject As Any Ptr = 0, ByRef ImageKey As WString) As TabPage Ptr
        Dim tb As TabPage Ptr
        If Images Then
            tb = AddTab(Caption, aObject, Images->IndexOf(ImageKey))
        Else
            tb = AddTab(Caption, aObject, -1)
        End If
        If tb Then tb->ImageKey = ImageKey
        Return tb
    End Function
    
    Sub TabControl.AddTab(ByRef tp As TabPage Ptr)
        FTabCount += 1
        'tp->TabPageControl = @This
        Tabs = Reallocate(Tabs, SizeOF(TabPage) * FTabCount)
        Tabs[FTabCount - 1] = tp
        #IfDef __USE_GTK__
        	If widget Then
        		#IfDef __USE_GTK3__
					tp->_box = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 1)
				#Else
					tp->_box = gtk_hbox_new(false, 1)
				#EndIf
				tp->_icon = gtk_image_new_from_icon_name(ToUTF8(tp->ImageKey), GTK_ICON_SIZE_MENU)
				gtk_container_add (GTK_CONTAINER (tp->_box), tp->_icon)
        		tp->_label = gtk_label_new(ToUTF8(tp->Caption))
        		gtk_container_add (GTK_CONTAINER (tp->_box), tp->_label)
        		'gtk_box_pack_end (GTK_BOX (tp->_box), tp->_label, TRUE, TRUE, 0)
        		gtk_widget_show_all(tp->_box)
        		gtk_notebook_append_page(gtk_notebook(widget), tp->widget, tp->_box)
				'RequestAlign
        	End If
        	tp->Visible = FTabCount = 1
        	If widget Then 
        		gtk_widget_show_all(widget)
        	End If
        #Else
        	If Handle Then
				Dim As TCITEMW Ti
				Dim As WString Ptr St
				WLet St, tp->Caption
				Ti.mask = TCIF_TEXT OR TCIF_IMAGE OR TCIF_PARAM
				Ti.pszText    = St
				Ti.cchTextMax = Len(tp->Caption)
				If tp->Object Then Ti.lParam = Cast(LPARAM, tp->Object)
				Ti.iImage = tp->ImageIndex
				SendmessageW(FHandle, TCM_INSERTITEMW, FTabCount - 1, CInt(@Ti))
        	End If
        	SetMargins
			tp->Visible = FTabCount = 1
		#EndIf
		This.Add(Tabs[FTabCount - 1])
    End Sub
    
    Sub TabControl.DeleteTab(Index As Integer)
        Dim As Integer i
        Dim As TabPage Ptr It
        If Index >= 0 AND Index <= FTabCount -1 Then
            This.Remove(Tabs[Index])
            For i = Index + 1 To FTabCount -1
                It = Tabs[i]
                Tabs[i - 1] = It
            Next i
            FTabCount -= 1 
            Tabs = ReAllocate(Tabs,FTabCount*SizeOF(TabPage))
            #IfDef __USE_GTK__
				gtk_notebook_remove_page(gtk_notebook(widget), Index)
            #Else
				Perform(TCM_DELETEITEM,Index,0)
            #EndIf
            If Index > 0 then
                TabIndex = Index - 1
            ElseIf Index < TabCount - 1 then
                TabIndex = Index + 1
            End if
            If FTabCount = 0 Then SetMargins
        End If
    End Sub
        
    Sub TabControl.InsertTab(Index As Integer, ByRef Caption As WString, AObject As Any Ptr = 0)
       Dim As Integer i
       Dim As TabPage Ptr It
       #IfNDef __USE_GTK__
			Dim As TCITEM Ti
			Ti.mask = TCIF_TEXT OR TCIF_IMAGE OR TCIF_PARAM
       #EndIf
       If Index >= 0 AND Index <= FTabCount -1 Then
          FTabCount += 1 
          Tabs = ReAllocate(Tabs,FTabCount*SizeOF(TabPage))
          For i = Index To FTabCount -2
              It = Tabs[i]
              Tabs[i + 1] = It
          Next i
          Tabs[Index] = New TabPage
          Tabs[Index]->Caption = Caption
          Tabs[Index]->Object = aObject
          'Tabs[Index]->TabPageControl = @This
          #IfNDef __USE_GTK__
			  Ti.pszText    = @(Tabs[Index]->Caption)
			  Ti.cchTextMax = Len(Tabs[Index]->Caption) + 1
			  If Tabs[Index]->Object Then Ti.lParam = Cast(LPARAM, Tabs[Index]->Object)
			  Perform(TCM_INSERTITEM, Index, CInt(@Ti))
          #EndIf
          SetMargins
          This.Add(Tabs[Index])
       End If
    End Sub

    Operator TabControl.Cast As Control Ptr 
        Return Cast(Control Ptr, @This)
    End Operator

    Function TabControl.IndexOfTab(Value As TabPage Ptr) As Integer
        Dim As Integer i
        For i = 0 To TabCount - 1
            If Tabs[i] = Value Then Return i
        Next i
        Return -1
    End Function

	#IfDef __USE_GTK__
		Sub TabControl_SwitchPage(notebook As GtkNotebook Ptr, page As GtkWidget Ptr, page_num As UInteger, user_data As Any Ptr)
			Dim As TabControl Ptr tc = user_data
			tc->Tabs[page_num]->RequestAlign
			If tc->OnSelChange Then tc->OnSelChange(*tc, page_num)
		End Sub
	#EndIf
	
    Constructor TabControl
        SetMargins
        With This
			#IfDef __USE_GTK__
				widget = gtk_notebook_new()
				gtk_notebook_set_scrollable(gtk_notebook(widget), True)
				g_signal_connect(gtk_notebook(widget), "switch-page", G_CALLBACK(@TabControl_SwitchPage), @This)
				.RegisterClass "TabControl", @This
            #Else
				WLet FClassAncestor, "SysTabControl32"
				.RegisterClass "TabControl", "SysTabControl32"
            #EndIf
            WLet FClassName, "TabControl"
            .Child       = @This
            #IfNDef __USE_GTK__
				.ChildProc   = @WndProc
				Base.ExStyle     = 0
				Base.Style       = WS_CHILD 
				.OnHandleIsAllocated = @HandleIsAllocated
            #EndIf
            FTabPosition = 2
            .Width       = 121
            .Height      = 121
        End With
    End Constructor

    Destructor TabControl
    	For i As Integer = 0 To TabCount - 1
    		Tabs[i]->Parent = 0
    	Next
        'UnregisterClass "TabControl", GetModuleHandle(NULL) 
    End Destructor
    
End namespace
