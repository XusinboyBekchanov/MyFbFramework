'###############################################################################
'#  Form.bi                                                                    #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TForm.bi                                                                  #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#Include Once "ContainerControl.bi"
#Include Once "Application.bi"

Namespace My.Sys.Forms
    #DEFINE QForm(__Ptr__) *Cast(Form Ptr,__Ptr__)

    Enum ModalResults
        OK
        Cancel
        Yes
        No
    End Enum
    
    Enum FormBorderStyle
        None
        SizableToolWindow
        FixedToolWindow
        Sizable
        Fixed3D
        FixedSingle
        FixedDialog
    End Enum
    
    Enum FormStyles
        fsNormal
        fsMDIForm
        fsMDIChild
        fsStayOnTop
    End Enum
            
    Enum WindowStates
        wsHide
        wsNormal
        wsMaximized
        wsMinimized
    End Enum
    
    Type Form Extends ContainerControl
        Private:
            FMainForm      As Boolean
            FMainStyle(2)  As Integer
            FMenuItems     As List
            FBorderStyle   As Integer
            FFormStyle     As Integer
            FBorderIcons   As Integer
            FExStyle(6)    As Integer
            FCmdShow(4)    As Integer
            FChild(2)      As Integer
            FStyle(6)      As Integer
            FClassStyle(6) As Integer
            FWindowState   As Integer
            FCreated	   As Boolean
            FOnCreate      As Sub(BYREF Sender As Form)
            Declare Static Sub ActiveControlChanged(ByRef Sender As Control)
            #IfNDef __USE_GTK__
				Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
				Declare Static Sub HandleIsDestroyed(BYREF Sender As Control)
				Declare Static Sub WndProc(BYREF Message As Message)
            #EndIf
            Declare Function EnumMenuItems(Item As MenuItem) As Boolean
            Declare Sub GetMenuItems
        Protected:
			Declare Sub ProcessMessage(BYREF Message As Message)
            FControlBox     As Boolean
            FMinimizeBox    As Boolean
            FMaximizeBox    As Boolean
            FOpacity        As Integer
        Public:
            Icon          As My.Sys.Drawing.Icon
            ModalResult   As Integer 'ModalResults
            Declare Function ReadProperty(ByRef PropertyName As String) As Any Ptr
            Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
            Declare Property ActiveControl As Control Ptr
            Declare Property ActiveControl(Value As Control Ptr)
            Declare Property DefaultButton As Control ptr 'CommandButton
            Declare Property DefaultButton(Value As Control ptr)
            Declare Property CancelButton As Control ptr 'CommandButton
            Declare Property CancelButton(Value As Control ptr)
            Declare Property BorderStyle As Integer 'FormBorderStyle
            Declare Property BorderStyle(Value As Integer)
            Declare Property FormStyle As Integer 'FormStyles
            Declare Property FormStyle(Value As Integer)
            Declare Property WindowState As Integer 'WindowStates
            Declare Property WindowState(Value As Integer)
            Declare Property Opacity As Integer
            Declare Property Opacity(Value As Integer)
            Declare Property Owner As Form Ptr
            Declare Property Owner(Value As Form Ptr)
            #IfDef __USE_GTK__
            	WindowWidget As GtkWidget Ptr
				HeaderBarWidget As GtkWidget Ptr
				Declare Property ParentWidget As GtkWidget Ptr
				Declare Property ParentWidget(Value As GtkWidget Ptr)
			#EndIf
            Declare Property Caption ByRef As WString
            Declare Property Caption(ByRef Value As WString)
            Declare Property Text ByRef As WString
            Declare Property Text(ByRef Value As WString)
            Declare Property ControlBox As Boolean
            Declare Property ControlBox(Value As Boolean)            
            Declare Property MinimizeBox As Boolean
            Declare Property MinimizeBox(Value As Boolean)            
            Declare Property MaximizeBox As Boolean
            Declare Property MaximizeBox(Value As Boolean)            
            Declare Property MainForm As Boolean
            Declare Property MainForm(Value As Boolean)
            Declare Property Menu As MainMenu Ptr
            Declare Property Menu(Value As MainMenu Ptr)
            Declare Property Enabled As Boolean
            Declare Property Enabled(Value As Boolean)            
            Declare Property Visible As Boolean
            Declare Property Visible(Value As Boolean)            
            Declare Operator Cast As Control Ptr
            Declare Sub BringToFront
            Declare Sub SendToBack
            Declare Sub Invalidate
            Declare Sub Repaint
            Declare Sub Show
            Declare Sub Show(ByRef Parent As Form)
            Declare Function ShowModal As Integer
            Declare Sub Hide
            Declare Sub Maximize
            Declare Sub Minimize
            Declare Sub CloseForm
            Declare Sub Center
            Declare Constructor
            Declare Destructor
            OnActivate   As Sub(ByRef Sender As Form)
            OnActiveControlChange As Sub(ByRef Sender As Form)
            OnClose      As Sub(ByRef Sender As Form, BYREF Action As Integer)
            OnDeActivate As Sub(ByRef Sender As Form)
            OnHide       As Sub(ByRef Sender As Form)
            OnFree       As Sub(ByRef Sender As Form)
            #IfNDef __USE_GTK__
				OnPaint      As Sub(ByRef Sender As Form, DC As HDC, R As Rect)
            #EndIf
            OnSize       As Sub(ByRef Sender As Form)
            OnShow       As Sub(ByRef Sender As Form)
            OnTimer      As Sub(ByRef Sender As Form)
    End Type

    Function Form.ReadProperty(ByRef PropertyName As String) As Any Ptr
        FTempString = LCase(PropertyName)
        Select Case FTempString
        Case "borderstyle": Return @FBorderStyle
        Case "cancelbutton": Return FCancelButton
        Case "caption": Return This.FText
        Case "defaultbutton": Return FDefaultButton
        Case "icon": Return @Icon
        Case "controlbox": Return @FControlBox
        Case "minimizebox": Return @FMinimizeBox
        Case "maximizebox": Return @FMaximizeBox
        Case "formstyle": Return @FFormStyle
        Case "menu": Return Menu
        Case "mainform": Return @FMainForm
        Case "modalresult": Return @ModalResult
        Case "opacity": Return @FOpacity
        Case "owner": Return FOwner
        Case "windowstate": Return @FWindowState
        Case Else: Return Base.ReadProperty(PropertyName)
        End Select
        Return 0
    End Function
    
    Function Form.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
        If Value = 0 Then
            Select Case LCase(PropertyName)
            Case Else: Return Base.WriteProperty(PropertyName, Value)
            End Select
        Else
            Select Case LCase(PropertyName)
            Case "borderstyle": This.BorderStyle = QInteger(Value)
            Case "cancelbutton": This.CancelButton = Cast(Control Ptr, Value)
            Case "caption": This.Caption = QWString(Value)
            Case "defaultbutton": This.DefaultButton = Cast(Control Ptr, Value)
            Case "formstyle": This.FormStyle = QInteger(Value)
            Case "controlbox": This.ControlBox = QBoolean(Value)    
            Case "minimizebox": This.MinimizeBox = QBoolean(Value)    
            Case "maximizebox": This.MaximizeBox = QBoolean(Value)    
            Case "icon": This.Icon = QWString(Value)
            Case "mainform": This.MainForm = QBoolean(Value)
            Case "menu": This.Menu = Cast(MainMenu Ptr, Value)
            Case "modalresult": This.ModalResult = QInteger(Value)
            Case "opacity": This.Opacity = QInteger(Value)
            Case "owner": This.Owner = Cast(Form Ptr, Value)
            #IfDef __USE_GTK__
				Case "parentwidget": This.ParentWidget = Value
			#EndIf
            Case "text": This.Text = QWString(Value)
            Case "windowstate": This.WindowState = QInteger(Value)
            Case "visible": This.Visible = QBoolean(Value)
            Case Else: Return Base.WriteProperty(PropertyName, Value)
            End Select
        End If
        Return True
    End Function
    
    Property Form.ActiveControl As Control Ptr
        Return FActiveControl
    End Property

    Property Form.ActiveControl(Value As Control Ptr)
        FActiveControl = Value
        'If FActiveControl Then FActiveControl->SetFocus
        If OnActiveControlChange Then OnActiveControlChange(This)
    End Property

    Property Form.Owner As Form Ptr
        Return Cast(Form Ptr, FOwner)
    End Property

    Property Form.Owner(Value As Form Ptr)
        If Value <> FOwner Then
           FOwner = Value
           #IfNDef __USE_GTK__
			   If Handle AndAlso FOwner AndAlso FOwner->Handle Then 
				   SetParent FOwner->Handle, Handle
			   End If
			#EndIf
        End If
    End Property
    
    #IfDef __USE_GTK__
		Property Form.ParentWidget As GtkWidget Ptr
			Return FParentWidget
		End Property
		
		Property Form.ParentWidget(Value As GtkWidget Ptr)
			If Not GTK_IS_BOX(widget) Then
				g_object_ref(box)
				gtk_container_remove(gtk_container(WindowWidget), box)
				Widget = box
				gtk_widget_set_size_request(Widget, FWidth, FHeight)
				#IfDef __USE_GTK3__
					HeaderBarWidget = gtk_header_bar_new()
					gtk_widget_set_sensitive(HeaderBarWidget, False)
					gtk_header_bar_set_has_subtitle(gtk_header_bar(HeaderBarWidget), False)
					'gtk_widget_set_size_request(widget, FW, 1)
					gtk_header_bar_set_title(gtk_header_bar(HeaderBarWidget), ToUTF8(*FText))
					'gtk_header_bar_set_show_close_button(gtk_header_bar(HeaderBarWidget), True)
				#Else
					HeaderBarWidget = gtk_label_new(ToUTF8(*FText))
					'Dim As GdkColor color1, color2
					'gdk_color_parse ("black", @color1)
					'gtk_widget_modify_bg(HeaderBarWidget, GTK_STATE_NORMAL, @color1)
					'gdk_color_parse ("white", @color2)
					'gtk_widget_modify_fg(HeaderBarWidget, GTK_STATE_NORMAL, @color2)
				#EndIf
				gtk_box_pack_start(Gtk_Box(widget), HeaderBarWidget, false, false, 0)
				Base.ParentWidget = Value
				BorderStyle = BorderStyle
			End If
		End Property
	#EndIf

    Property Form.DefaultButton As Control Ptr
        Return FDefaultButton
    End Property
    
    Property Form.DefaultButton(Value As Control Ptr)
        FDefaultButton = Value
        #IfDef __USE_GTK__
        	If Value <> 0 Then
        		gtk_window_set_default(gtk_window(Widget), Value->Widget)
        		gtk_widget_grab_default(Value->Widget)
        	Else
        		gtk_window_set_default(gtk_window(Widget), NULL)
        	End If
        #EndIf
        If FDefaultButton AndAlso UCASE(*FDefaultButton.ClassName) = "COMMANDBUTTON" Then
            
        End If
    End Property
    
    Property Form.CancelButton As Control Ptr
        Return FCancelButton
    End Property
    
    Property Form.CancelButton(Value As Control Ptr)
        FCancelButton = Value
    End Property
    
    Property Form.MainForm As Boolean
        Return FMainForm
    End Property

    Property Form.MainForm(Value As Boolean)
        If Value <> FMainForm Then
            FMainForm = Value
            If App.MainForm <> 0 Then Cast(Form Ptr, App.MainForm)->MainForm = False
            #IfNDef __USE_GTK__
				ChangeExStyle WS_EX_APPWINDOW, Value
            #EndIf
            If FMainForm Then
                App.MainForm = @This
            Else     
                App.MainForm = 0
            End If           
        End If
    End Property

	Property Form.Menu As MainMenu Ptr
        Return FMenu
    End Property

    Property Form.Menu(Value As MainMenu Ptr)
        FMenu = Value
        If FMenu Then FMenu->ParentWindow = @This
    End Property

    Property Form.Opacity As Integer
        Return FOpacity
    End Property

    Property Form.Opacity(Value As Integer)
        FOpacity = Value
        #IfDef __USE_GTK__
        	#IfDef __USE_GTK3__
        		gtk_widget_set_opacity(widget, Value / 255.0)
        	#Else
        		gtk_window_set_opacity(gtk_window(widget), Value / 255.0)
        	#EndIf
        #Else
			ChangeExStyle WS_EX_LAYERED, Cast(Boolean, 255 - FOpacity)
			If FHandle Then
				SetLayeredWindowAttributes(FHandle, 0, FOpacity, LWA_ALPHA)
			End If
		#EndIf
    End Property
    
    Property Form.ControlBox As Boolean
        Return FControlBox
    End Property

    Property Form.ControlBox(Value As Boolean)
        FControlBox = Value
        #IfNDef __USE_GTK__
			ChangeStyle WS_SYSMENU, Value
			SetWindowPos(FHandle, 0, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE Or SWP_DRAWFRAME)
		#EndIf
    End Property

    Property Form.MinimizeBox As Boolean
        Return FMinimizeBox
    End Property

    Property Form.MinimizeBox(Value As Boolean)
        FMinimizeBox = Value
        #IfNDef __USE_GTK__
			ChangeStyle WS_MINIMIZEBOX, Value
			SetWindowPos(FHandle, 0, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE Or SWP_DRAWFRAME)
		#EndIf
    End Property
    
    Property Form.MaximizeBox As Boolean
        Return FMaximizeBox
    End Property

    Property Form.MaximizeBox(Value As Boolean)
        FMaximizeBox = Value
        #IfNDef __USE_GTK__
			ChangeStyle WS_MAXIMIZEBOX, Value
			SetWindowPos(FHandle, 0, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE Or SWP_DRAWFRAME)
		#EndIf
    End Property
    
    Property Form.BorderStyle As Integer
        Return FBorderStyle
    End Property

    Property Form.BorderStyle(Value As Integer)
        FBorderStyle = Value
        #IfDef __USE_GTK__
        	Select Case Value
			Case FormBorderStyle.None, FormBorderStyle.FixedToolWindow, FormBorderStyle.Fixed3D, FormBorderStyle.FixedSingle, FormBorderStyle.FixedDialog
				Dim As GdkGeometry hints
				hints.base_width = FWidth
				hints.base_height = FHeight
				hints.min_width = FWidth
				hints.min_height = FHeight
				hints.width_inc = 1
				hints.height_inc = 1
				If Gtk_Is_Window(Widget) Then
					gtk_window_set_geometry_hints(gtk_window(Widget), NULL, @hints, GDK_HINT_RESIZE_INC Or GDK_HINT_MIN_SIZE Or GDK_HINT_BASE_SIZE)
				End If
			Case FormBorderStyle.SizableToolWindow, FormBorderStyle.Sizable

			End Select
        	Select Case Value
			Case FormBorderStyle.None
				If Gtk_Is_Window(Widget) Then
					gtk_window_set_decorated(gtk_window(widget), False)
					gtk_window_set_type_hint(gtk_window(widget), GDK_WINDOW_TYPE_HINT_SPLASHSCREEN)
					gtk_window_set_resizable(gtk_window(widget), False)
				Else
					gtk_widget_set_visible(HeaderBarWidget, False)
				End If
			Case FormBorderStyle.SizableToolWindow
				If Gtk_Is_Window(Widget) Then
					gtk_window_set_decorated(gtk_window(widget), True)
					gtk_window_set_type_hint(gtk_window(widget), GDK_WINDOW_TYPE_HINT_DOCK)
					gtk_window_set_resizable(gtk_window(widget), True)
				Else
					gtk_widget_set_visible(HeaderBarWidget, True)
				End If
			Case FormBorderStyle.FixedToolWindow
				If Gtk_Is_Window(Widget) Then
					gtk_window_set_decorated(gtk_window(widget), True)
					gtk_window_set_type_hint(gtk_window(widget), GDK_WINDOW_TYPE_HINT_DOCK)
					gtk_window_set_resizable(gtk_window(widget), False)
				Else
					gtk_widget_set_visible(HeaderBarWidget, True)
				End If
			Case FormBorderStyle.Sizable
				If Gtk_Is_Window(Widget) Then
					gtk_window_set_decorated(gtk_window(widget), True)
					gtk_window_set_type_hint(gtk_window(widget), GDK_WINDOW_TYPE_HINT_NORMAL)
					gtk_window_set_resizable(gtk_window(widget), True)
				Else
					gtk_widget_set_visible(HeaderBarWidget, True)
				End If
			Case FormBorderStyle.Fixed3D
				If Gtk_Is_Window(Widget) Then
					gtk_window_set_decorated(gtk_window(widget), True)
					gtk_window_set_type_hint(gtk_window(widget), GDK_WINDOW_TYPE_HINT_DIALOG)
					gtk_window_set_resizable(gtk_window(widget), False)
				Else
					gtk_widget_set_visible(HeaderBarWidget, True)
				End If
			Case FormBorderStyle.FixedSingle
				If Gtk_Is_Window(Widget) Then
					gtk_window_set_decorated(gtk_window(widget), True)
					gtk_window_set_type_hint(gtk_window(widget), GDK_WINDOW_TYPE_HINT_DIALOG)
					gtk_window_set_resizable(gtk_window(widget), False)
				Else
					gtk_widget_set_visible(HeaderBarWidget, True)
				End If
			Case FormBorderStyle.FixedDialog
				If Gtk_Is_Window(Widget) Then
					gtk_window_set_decorated(gtk_window(widget), True)
					gtk_window_set_type_hint(gtk_window(widget), GDK_WINDOW_TYPE_HINT_DIALOG)
					gtk_window_set_resizable(gtk_window(widget), False)
				Else
					gtk_widget_set_visible(HeaderBarWidget, True)
				End If
			End Select
        #Else
			ChangeStyle WS_POPUP, False
			ChangeStyle WS_BORDER, False
			ChangeStyle WS_THICKFRAME, False
			ChangeStyle WS_DLGFRAME, False
			ChangeStyle DS_CONTROL, False
			ChangeExStyle WS_EX_TOOLWINDOW, False
			ChangeExStyle WS_EX_CLIENTEDGE, False
			ChangeExStyle WS_EX_WINDOWEDGE, False
			ChangeExStyle WS_EX_DLGMODALFRAME, False
			Select Case Value
			Case FormBorderStyle.None
				ChangeStyle WS_CAPTION, False
				ChangeStyle DS_CONTROL, True
				If Not DesignMode Then ChangeStyle WS_POPUP, True
				ChangeExStyle WS_EX_CONTROLPARENT, True
			Case FormBorderStyle.SizableToolWindow
				ChangeStyle WS_BORDER, True
				ChangeStyle WS_THICKFRAME, True
				ChangeExStyle WS_EX_TOOLWINDOW, True
			Case FormBorderStyle.FixedToolWindow
				ChangeStyle WS_BORDER, True
				ChangeStyle WS_DLGFRAME, True
				ChangeExStyle WS_EX_TOOLWINDOW, True
			Case FormBorderStyle.Sizable
				ChangeStyle WS_THICKFRAME, True
				ChangeStyle WS_DLGFRAME, True
				ChangeStyle WS_BORDER, True
				ChangeExStyle WS_EX_WINDOWEDGE, True
			Case FormBorderStyle.Fixed3D
				ChangeStyle WS_DLGFRAME, True
				ChangeStyle WS_BORDER, True
				ChangeExStyle WS_EX_WINDOWEDGE, True
				ChangeExStyle WS_EX_CLIENTEDGE, True
			Case FormBorderStyle.FixedSingle
				ChangeStyle WS_DLGFRAME, True
				ChangeStyle WS_BORDER, True
				ChangeExStyle WS_EX_WINDOWEDGE, True
			Case FormBorderStyle.FixedDialog
				ChangeStyle WS_DLGFRAME, True
				ChangeStyle WS_BORDER, True
				ChangeExStyle WS_EX_DLGMODALFRAME, True
			End Select
			If FHandle Then SetWindowPos(FHandle, 0, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE Or SWP_DRAWFRAME)
		#EndIf
    End Property

    Property Form.FormStyle As Integer
        Return FFormStyle
    End Property
      
    Property Form.FormStyle(Value As Integer)
        If Value = FFormStyle Then Exit Property
        FFormStyle = Value
        #IfNDef __USE_GTK__
			Select Case FFormStyle
			Case 0 'fsNormal
				If (ExStyle AND WS_EX_TOPMOST) = WS_EX_TOPMOST Then
					ExStyle = ExStyle AND NOT WS_EX_TOPMOST
					SetWindowPos Handle,HWND_NOTOPMOST,0,0,0,0,SWP_NOMOVE OR SWP_NOACTIVATE OR SWP_NOSIZE
				End If 
			Case 1 'fsMDIForm
			Case 2 'fsMDIChild
			Case 3 'fsStayOnTop
				If (ExStyle AND WS_EX_TOPMOST) <> WS_EX_TOPMOST Then
					ExStyle = ExStyle OR WS_EX_TOPMOST
					SetWindowPos Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE OR SWP_NOACTIVATE OR SWP_NOSIZE
				End If    
			End Select
		#EndIf
    End Property

    Property Form.WindowState As Integer
        Return FWindowState
    End Property

    Property Form.WindowState(Value As Integer)
        FWindowState = Value
    End Property

    Property Form.Caption ByRef As WString
		Return Text
    End Property

    Property Form.Caption(ByRef Value As WString)
		Text = Value
    End Property

	Property Form.Text ByRef As WString
		Return Base.Text
    End Property

    Property Form.Text(ByRef Value As WString)
		Base.Text = Value
		#IfDef __USE_GTK__
			If GTK_IS_WINDOW(widget) Then
				gtk_window_set_title(GTK_WINDOW(widget), ToUtf8(Value))
        	ElseIf HeaderBarWidget Then
        		#IfDef __USE_GTK3__
        			gtk_header_bar_set_title(gtk_header_bar(HeaderBarWidget), ToUTF8(Value))
        		#Else
        			gtk_label_set_text(gtk_label(HeaderBarWidget), ToUTF8(Value))
        		#EndIf
        	End If
        #EndIf
    End Property

    Property Form.Enabled As Boolean
        Return Base.Enabled
    End Property

    Property Form.Enabled(Value As Boolean)
        Base.Enabled = Value
        FWindowState = Value
    End Property
    
    Sub Form.ActiveControlChanged(ByRef Sender As Control)
    	If Sender.Child Then
    		With QForm(Sender.Child)
    			If .OnActiveControlChange Then .OnActiveControlChange(QForm(Sender.Child))
    		End With
    	End If
    End Sub

	#IfNDef __USE_GTK__
		Sub Form.WndProc(BYREF message As Message)
		End Sub

		Sub Form.HandleIsDestroyed(BYREF Sender As Control)
			If Sender.Child Then
				With QForm(Sender.Child)
					SetMenu .Handle,NULL
					DrawMenuBar .Handle
				End With
			End If
		End Sub
	
'		Function GetAscKeyCode(HotKey As String) As Integer
'	        Select Case HotKey
'	        Case "Backspace", "Back": Return 08
'	        Case "Tab": Return 09
'	        Case "Enter", "Return": Return 13
'	        Case "Escape", "Esc": Return 27
'	        Case "Space": Return 32
'	        Case "PageUp": Return 33
'	        Case "PageDown": Return 34
'	        Case "End": Return 35
'	        Case "Home": Return 36
'	        Case "Left": Return 37
'	        Case "Up": Return 38
'	        Case "Right": Return 39
'	        Case "Down": Return 40
'	        Case "Print": Return 42
'	        Case "Insert", "Ins": Return 45
'	        Case "Num0": Return 96
'	        Case "Num1": Return 97
'	        Case "Num2": Return 98
'	        Case "Num3": Return 99
'	        Case "Num4": Return 100
'	        Case "Num5": Return 101
'	        Case "Num6": Return 102
'	        Case "Num7": Return 103
'	        Case "Num8": Return 104
'	        Case "Num9": Return 105
'	        Case "F1": Return 112
'	        Case "F2": Return 113
'	        Case "F3": Return 114
'	        Case "F4": Return 115
'	        Case "F5": Return 116
'	        Case "F6": Return 117
'	        Case "F7": Return 118
'	        Case "F8": Return 119
'	        Case "F9": Return 120
'	        Case "F10": Return 121
'	        Case "F11": Return 122
'	        Case "F12": Return 123
'	        Case "Delete", "Del": : Return 127
'	        Case Else: Return Asc(HotKey)
'	        End Select
'	    End Function
    
		Sub Form.HandleIsAllocated(BYREF Sender As Control)
			If Sender.Child Then
				Dim As HMENU NoNeedSysMenu
				With QForm(Sender.Child)
					 SetClassLong(.Handle,GCL_STYLE,.FClassStyle(.BorderStyle))
					 If .FBorderStyle = 2 Then
						SetClassLongPtr(.Handle,GCLP_HICON,NULL) 
						SendMessage(.Handle,WM_SETICON,1,NULL)
						NoNeedSysMenu = GetSystemMenu(.Handle, False)
						DeleteMenu(NoNeedSysMenu, SC_TASKLIST, MF_BYCOMMAND)
						DeleteMenu(NoNeedSysMenu, 7, MF_BYPOSITION)
						DeleteMenu(NoNeedSysMenu, 5, MF_BYPOSITION)
						DeleteMenu(NoNeedSysMenu, SC_MAXIMIZE, MF_BYCOMMAND)
						DeleteMenu(NoNeedSysMenu, SC_MINIMIZE, MF_BYCOMMAND)
						DeleteMenu(NoNeedSysMenu, SC_SIZE, MF_BYCOMMAND)
						DeleteMenu(NoNeedSysMenu, SC_RESTORE, MF_BYCOMMAND)
					 Else
						SendMessage(.Handle, WM_SETICON, 1, CInt(.Icon.Handle))
						GetSystemMenu(.Handle, True)
						EnableMenuItem(NoNeedSysMenu, SC_MINIMIZE, MF_BYCOMMAND OR MF_GRAYED)
						EnableMenuItem(NoNeedSysMenu, SC_MAXIMIZE, MF_BYCOMMAND OR MF_GRAYED)
					 End If
					 If .Opacity <> 255 Then SetLayeredWindowAttributes(.Handle, 0, .Opacity, LWA_ALPHA)
					 If .Menu Then .Menu->ParentWindow = @Sender
					 .GetMenuItems
					Dim As String mnuCaption, HotKey
					Dim As Integer Pos1, CountOfHotKeys = 0
					Dim As MenuItem Ptr mi
					ReDim accl(1) As ACCEL
					For i As Integer = 0 To .FMenuItems.Count - 1
						mi = .FMenuItems.Items[i]
						mnuCaption = mi->Caption
						Pos1 = InStr(mnuCaption, !"\t")
						If Pos1 > 0 Then
							CountOfHotKeys = CountOfHotKeys + 1
							HotKey = Mid(mnuCaption, Pos1 + 1)
							ReDim Preserve accl(CountOfHotKeys - 1) As ACCEL
							If Instr(HotKey, "Ctrl") > 0 Then accl(CountOfHotKeys - 1).fVirt = accl(CountOfHotKeys - 1).fVirt Or FCONTROL
							If Instr(HotKey, "Shift") > 0 Then accl(CountOfHotKeys - 1).fVirt = accl(CountOfHotKeys - 1).fVirt Or FSHIFT
							If Instr(HotKey, "Alt") > 0 Then accl(CountOfHotKeys - 1).fVirt = accl(CountOfHotKeys - 1).fVirt Or FALT
							accl(CountOfHotKeys - 1).fVirt = accl(CountOfHotKeys - 1).fVirt Or FVIRTKEY
							Pos1 = InstrRev(HotKey, "+")
							If Pos1 > 0 Then HotKey = Mid(HotKey, Pos1 + 1)
							accl(CountOfHotKeys - 1).key = GetAscKeyCode(HotKey)
							accl(CountOfHotKeys - 1).cmd = mi->Command
						End If
					Next i
					.Accelerator = CreateAcceleratorTable(Cast(LPACCEL, @accl(0)), CountOfHotKeys)
				End With
			End If
		End Sub
	#EndIf

	Sub Form.ProcessMessage(BYREF msg As Message)
		Dim As Integer Action = 1
		#IfDef __USE_GTK__
			Select Case msg.event->Type
			Case GDK_DELETE
				If OnClose Then OnClose(This, Action)
				Select Case Action
				Case 0
					msg.Result = -1
				Case 1
					If MainForm Then
						'End 0
					Else
					   gtk_widget_hide(widget)
					   msg.Result = -1
					End If
				Case 2
					msg.Result = -1
				End Select
			Case Else 
			 
			End Select
		#Else
			Static As Boolean IsMenuItem
			Select Case msg.Msg
			Case WM_PAINT
				 Dim As HDC Dc,memDC
				 Dim As HBITMAP Bmp
				 Dim As PAINTSTRUCT Ps
				 Dc = BeginPaint(Handle,@Ps)
				 If DoubleBuffered Then
					MemDC = CreateCompatibleDC(DC)
					Bmp   = CreateCompatibleBitmap(DC,Ps.rcpaint.Right,Ps.rcpaint.Bottom)
					SelectObject(MemDc,Bmp)
					SendMessage(Handle,WM_ERASEBKGND, CInt(MemDC), CInt(MemDC))
					FillRect memDc,@Ps.rcpaint, Brush.Handle
					If OnPaint Then OnPaint(This,memDC,Ps.rcpaint)
					BitBlt(DC, 0, 0, Ps.rcpaint.Right, Ps.rcpaint.Bottom, MemDC, 0, 0, SRCCOPY)
					DeleteObject(Bmp)
					DeleteDC(MemDC)
				Else
					FillRect Dc,@Ps.rcpaint, Brush.Handle
					If OnPaint Then OnPaint(This,DC,Ps.rcpaint) 
				End If
				EndPaint Handle,@Ps
				msg.Result = 0
			Case WM_CLOSE
				If OnClose Then
					OnClose(This, Action)
				End If
				Select Case Action
				Case 0
					msg.Result = -1
				Case 1
					If MainForm Then
						PostQuitMessage 0
						'End 0
					Else
					   ShowWindow Handle,SW_HIDE
					   msg.Result = -1
					End If
				Case 2
					ShowWindow Handle,SW_MINIMIZE
					msg.Result = -1
				End Select
			Case WM_COMMAND
				GetMenuItems
				Dim As MenuItem Ptr mi
				For i As Integer = 0 To FMenuItems.Count -1
					mi = FMenuItems.Items[i]
					With *mi
						If .Command = msg.wParamLo Then
							If .OnClick Then .OnClick(*mi)
							Exit For
						End If
					End With
				Next i
				IsMenuItem = False
			Case WM_MENUSELECT
				 IsMenuItem = True
			Case WM_INITMENU
			Case WM_INITMENUPOPUP
			Case WM_SIZE
				 If OnSize Then OnSize(This)
			Case WM_TIMER
				 If OnTimer Then OnTimer(This)
			Case WM_ACTIVATE
				 Select Case msg.wParamLo
				 Case WA_ACTIVE, WA_CLICKACTIVE 
					 If OnActivate Then OnActivate(This)
				 Case WA_INACTIVE
					 If OnDeActivate Then OnDeActivate(This)
				 End Select
			Case WM_DESTROY
				If Accelerator Then DestroyAcceleratorTable(Accelerator)
			 Case WM_DRAWITEM
				 Dim As DRAWITEMSTRUCT Ptr diStruct
				 diStruct = Cast(DRAWITEMSTRUCT Ptr, msg.lParam)
				 Select Case diStruct->CtlType 
				 Case ODT_MENU    
					'If This.Menu AndAlso This.Menu->ImagesList AndAlso This.Menu->ImagesList->Handle AndAlso diStruct->itemData <> 0 Then
					'    ImageList_Draw(This.Menu->ImagesList->Handle, Cast(MenuItem Ptr, diStruct->itemData)->ImageIndex, diStruct->hDC, 2, 2, ILD_NORMAL)
					'End If
				 End Select
			 Case CM_HELP
				 Dim As Point P
				 Dim As HWND HControl
				 Dim As Control Ptr Ctrl
				 Dim As Integer ContextID,Id,i
				 Dim As HELPINFO Ptr HIF
				 HIF = Cast(HELPINFO Ptr, msg.lParam)
				 If HIF->iContextType = HELPINFO_WINDOW Then
					 HControl = HIF->hItemHandle
					 Ctrl = Cast(Control Ptr, GetWindowLongPtr(HControl, GWLP_USERDATA)) 
					 If Ctrl Then
						If Ctrl->HelpContext <> 0 Then
							ContextID = Ctrl->HelpContext
						Else
							If Ctrl->Parent Then
								Ctrl= Ctrl->Parent 
								ContextID = Ctrl->HelpContext
							 Else
								Exit Select
							 End If
						End If
					 End If   
					 Ctrl->ClientToScreen(P)
				 Else  ' Message.HelpInfo.iContextType = HELPINFO_MENUITEM 
					 Id = 0 
					 If This.Menu Then
						 For i = 0 To This.Menu->Count -1
								If This.Menu->Item(i)->Command = HIF->iCtrlID Then
									Id = i
									Exit For
								End If
						 Next i
					End If
	'                 If Id Then ContextID = MainMenu.Item(Id)->HelpContext
	'                 If ContextID = 0 Then 
	'                     For i = 0 to MainMenu.Count -1
	'                          If MainMenu.Items[i]->CommandID = HIF->iCtrlID Then
	'                              Id = i
	'                              Exit For
	'                          End If
	'                     Next i  
	'                     If Id then ContextID = PopupMenu.Items[Id]->HelpContext
	'                 End If   
					 This.ClientToScreen(P)
				 End If
				 If (GetWindowLong(Handle,GWL_EXSTYLE) AND WS_EX_CONTEXTHELP) = WS_EX_CONTEXTHELP Then
					 App.HelpCommand(HELP_SETPOPUP_POS, CInt(@P))
					 App.HelpCommand(HELP_CONTEXTPOPUP, ContextID)
				 Else
					 App.HelpContext(ContextID)
				 End If
			End Select
		#EndIf
		Base.ProcessMessage(msg)
	End Sub
            
    Sub Form.SendToBack
    End Sub
        
    Property Form.Visible() As Boolean
        #IfNDef __USE_GTK__
			If FHandle Then
				FVisible = IsWindowVisible(FHandle)
			End if
		#EndIf
        Return FVisible
    End Property

    Property Form.Visible(Value As Boolean)
        FVisible = Value 
        If Value Then 
            Show
        Else
            Hide
        End If
    End Property

    Sub Form.Show
		#IfDef __USE_GTK__
			RequestAlign
			If widget Then
				If Not FCreated Then
					FCreated = True
					If Icon.ResName <> "" Then
						If gtk_is_window(widget) Then
							Dim As GList Ptr list1 = NULL
							Dim As GError Ptr gerr
							Dim As GdkPixbuf Ptr gtkicon
							gtkicon = gdk_pixbuf_new_from_file_at_size(ToUTF8(Icon.ResName), 16, 16, @gerr)
							If gtkicon <> 0 Then list1 = g_list_append(list1, gtkicon)
							gtkicon = gdk_pixbuf_new_from_file_at_size(ToUTF8(Icon.ResName), 48, 48, @gerr)
							If gtkicon <> 0 Then list1 = g_list_append(list1, gtkicon)
							gtk_window_set_icon_list(GTK_WINDOW(Widget), list1)
						End If
					End If
					If OnCreate Then OnCreate(This)
				End If
				gtk_widget_show_all(widget)
				If gtk_is_window(widget) Then
					Select Case FBorderStyle
					Case FormBorderStyle.None
						gtk_window_set_resizable(gtk_window(widget), False)
					Case FormBorderStyle.SizableToolWindow
						gtk_window_set_resizable(gtk_window(widget), True)
					Case FormBorderStyle.FixedToolWindow
						gtk_window_set_resizable(gtk_window(widget), False)
					Case FormBorderStyle.Sizable
						gtk_window_set_resizable(gtk_window(widget), True)
					Case FormBorderStyle.Fixed3D
						gtk_window_set_resizable(gtk_window(widget), False)
					Case FormBorderStyle.FixedSingle
						gtk_window_set_resizable(gtk_window(widget), False)
					Case FormBorderStyle.FixedDialog
						gtk_window_set_resizable(gtk_window(widget), False)
					End Select
				End If
				'Requests @This
			End If
		#Else
			If IsWindowVisible(Handle) Then
				This.SetFocus
			Else
				If Handle Then
					ShowWindow Handle, FCmdShow(FWindowState)
					If FParent Then Cast(Control Ptr, FParent)->RequestAlign
				Else
					CreateWnd
				End If
			End If
		#EndIf
        If OnShow Then OnShow(This)
    End Sub
    
    Sub Form.Show(ByRef OwnerForm As Form)
        This.FParent = @OwnerForm
        #IfDef __USE_GTK__
			gtk_window_set_transient_for(gtk_window(widget), gtk_window(OwnerForm.Widget))
        #EndIf
        This.Show
    End Sub
        
    Function Form.ShowModal As Integer
        #IfDef __USE_GTK__
			gtk_window_set_modal(gtk_window(widget), True)
			If OnShow Then OnShow(This)
			This.Show
		#Else
			Dim As Integer i
			Dim As Any Ptr Mtx
			If IsWindowVisible(Handle) Then
			   This.SetFocus
			   Exit Function
			End If
			If GetCapture <> 0 Then SendMessage(GetCapture,WM_CANCELMODE,0,0)
			'?"..." & GetCapture
			'ReleaseCapture
			For i = 0 To App.FormCount -1
				If App.Forms[i]->Handle <> Handle Then Cast(Form Ptr, App.Forms[i]->Child)->Enabled = False
			Next i
			If OnShow Then OnShow(This)
			Visible = True
			Do
			   App.DoEvents
			   Update
			Loop While IsWindowVisible(Handle) = True
			Visible = False
			For i = 0 To App.FormCount -1
				 Cast(Form Ptr, App.Forms[i]->Child)->Enabled = True
			Next i
			'ReleaseCapture
			SetActiveWindow MainHandle
		#EndIf
        Function = ModalResult
    End Function

    Sub Form.Hide
		#IfNDef __USE_GTK__
			If Handle Then
				If IsWindowVisible(Handle) Then
					If OnHide Then OnHide(This)
					ShowWindow Handle, SW_HIDE
				End If
			End If
		#EndIf
    End Sub
    
    Sub Form.Maximize
		#IfDef __USE_GTK__
			gtk_window_maximize(GTK_WINDOW(widget))
		#Else
			If IsIconic(Handle) = 0 Then
			   ShowWindow Handle, SW_MAXIMIZE
			End If
		#EndIf
    End Sub
    
    Sub Form.Minimize
		#IfDef __USE_GTK__
			gtk_window_iconify(GTK_WINDOW(widget))
		#Else
			If IsIconic(Handle) = 0 Then
			   ShowWindow Handle, SW_MINIMIZE
			End If
		#EndIf
    End Sub

    Sub Form.CloseForm
		#IfDef __USE_GTK__
			#IfDef __USE_GTK3__
				gtk_window_close(Gtk_Window(widget))
			#Else
				Dim As Integer Action = 1
				If OnClose Then OnClose(This, Action)
				Select Case Action
				Case 0
				Case 1
					If MainForm Then
						gtk_widget_destroy(widget)
					Else
						gtk_widget_hide(widget)
					End If
				Case 2
				End Select
			#EndIf
		#Else
			If Handle Then Perform(WM_CLOSE, 0, 0)
		#EndIf
    End Sub

    Sub Form.Center
		#IfDef __USE_GTK__
			gtk_window_move(gtk_window(widget), (gdk_screen_width() - This.FWidth) \ 2, (gdk_screen_height() - This.FHeight) \ 2)
			'gtk_window_set_position(gtk_window(widget), GTK_WIN_POS_CENTER) '_ALWAYS
		#Else
			This.Left = (GetSystemMetrics(SM_CXSCREEN) - This.Width) \ 2
			This.Top  = (GetSystemMetrics(SM_CYSCREEN) - This.Height) \ 2
		#EndIf
    End Sub

    Function Form.EnumMenuItems(Item As MenuItem) As Boolean
        FMenuItems.Add Item
        For i As Integer = 0 To Item.Count -1
            EnumMenuItems *Item.Item(i)
        Next i
        Return True
    End Function

    Sub Form.GetMenuItems
        FMenuItems.Clear
        If This.Menu Then
            For i As Integer = 0 To This.Menu->Count -1
                EnumMenuItems *This.Menu->Item(i)
            Next i
        End If
    End Sub

    Operator Form.Cast As Control Ptr
       Return @This
    End Operator

    Constructor Form
		#IfDef __USE_GTK__
			WindowWidget = gtk_window_new(GTK_WINDOW_TOPLEVEL)
			Widget = WindowWidget
			'gtk_window_set_policy(GTK_WINDOW(widget), true, false, false)
			If OnCreate Then OnCreate(This)
			This.RegisterClass "Form", @This
        #Else
        	FMainStyle(0)  = 0  
			FMainStyle(1)  = WS_EX_APPWINDOW
			FClassStyle(0) = CS_VREDRAW OR CS_HREDRAW OR CS_DBLCLKS
			FClassStyle(1) = CS_DBLCLKS
			FClassStyle(2) = CS_DBLCLKS OR CS_SAVEBITS OR CS_BYTEALIGNWINDOW
			FClassStyle(3) = CS_DBLCLKS
			FClassStyle(4) = CS_DBLCLKS
			FClassStyle(5) = CS_DBLCLKS
			FExStyle(0)    = WS_EX_CONTROLPARENT
			FExStyle(1)    = WS_EX_CONTROLPARENT
			FExStyle(2)    = WS_EX_CONTROLPARENT OR WS_EX_DLGMODALFRAME
			FExStyle(3)    = WS_EX_CONTROLPARENT
			FExStyle(4)    = WS_EX_CONTROLPARENT OR WS_EX_TOOLWINDOW
			FExStyle(5)    = WS_EX_CONTROLPARENT OR WS_EX_TOOLWINDOW
			FStyle(0)      = DS_CONTROL
			FStyle(1)      = WS_CAPTION OR WS_BORDER OR DS_CONTROL
			FStyle(2)      = WS_CAPTION OR WS_BORDER OR WS_SYSMENU
			FStyle(3)      = WS_OVERLAPPEDWINDOW
			FStyle(4)      = WS_CAPTION OR WS_BORDER OR WS_SYSMENU
			FStyle(5)      = WS_CAPTION OR WS_THICKFRAME OR WS_SYSMENU
			FChild(0) = 0
			FChild(1) = WS_CHILD
			FCmdShow(0) = SW_HIDE
			FCmdShow(1) = SW_SHOWNORMAL
			FCmdShow(2) = SW_SHOWMAXIMIZED
			FCmdShow(3) = SW_SHOWMINIMIZED
			This.RegisterClass "Form"
		#EndIf
		Text = "Form"
        FBorderStyle   = 3
        FWindowState   = 1
        FControlBox = True
        FMinimizeBox = True
        FMaximizeBox = True
        FOpacity = 255
        Canvas.Ctrl    = This
        With This
            .Child             = @This
            #IfNDef __USE_GTK__
				.ChildProc         = @WndProc
			#EndIf
            WLet FClassName, "Form"
            WLet FClassAncestor, ""
            .OnActiveControlChanged = @ActiveControlChanged
            #IfNDef __USE_GTK__
				.ExStyle           = WS_EX_CONTROLPARENT Or WS_EX_WINDOWEDGE 'FExStyle(FBorderStyle) OR FMainStyle(FMainForm)
				.Style             = WS_CAPTION Or WS_SYSMENU Or WS_MINIMIZEBOX Or WS_MAXIMIZEBOX Or WS_THICKFRAME Or WS_DLGFRAME Or WS_BORDER 'FStyle(FBorderStyle) Or FChild(Abs_(FIsChild))
				.BackColor             = GetSysColor(COLOR_BTNFACE) 
				.OnHandleIsAllocated = @HandleIsAllocated
			#EndIf
            .Width             = 350
            .Height            = 300
        End With
        If App.MainForm = 0 Then MainForm = True
        #IFDEF __AUTOMATE_CREATE_FORM__  
        CreateWnd
        #ENDIF
    End Constructor

    Destructor Form
        If OnFree Then OnFree(This)
        #IfNDef __USE_GTK__
			If FHandle Then FreeWnd
		#EndIf
        'UnregisterClass ClassName, GetModuleHandle(NULL)
    End Destructor
End namespace
