'###############################################################################
'#  CommandButton.bi                                                           #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TButton.bi                                                                #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#DEFINE QCommandButton(__Ptr__) *Cast(CommandButton Ptr,__Ptr__)

#Include Once "Control.bi"
#Include Once "Graphic.bi"
#Include Once "List.bi"

Enum ButtonStyle
    bsText, bsBitmap, bsIcon, bsCursor, bsOwnerDraw
End Enum

Namespace My.Sys.Forms
    Type CommandButton Extends Control
        Private:
            FStyle      As ButtonStyle
            FDefault    As Boolean
            FImageType  As Integer
            AStyle(4)   As Integer
            ADefault(2) As Integer
            #IfNDef __USE_GTK__
				Declare Static Sub WndProc(BYREF message As Message)
				Declare Static Sub HandleIsAllocated(BYREF Sender As Control)
			#Else
				Declare Static Sub Clicked(widget As GtkButton Ptr, user_data As Any Ptr)
            #EndIf
            Declare Sub ProcessMessage(BYREF message As Message)
            Declare Static Sub GraphicChange(BYREF Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr, ImageType As Integer)
            Declare Function EnumMenuItems(Item As MenuItem, BYREF List As List) As Boolean
        Public:
            Graphic     As My.Sys.Drawing.GraphicType
            Declare Function ReadProperty(PropertyName As String) As Any Ptr
            Declare Function WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
            Declare Property Caption ByRef As WString
            Declare Property Caption(ByRef Value As WString)
            Declare Property Text ByRef As WString
            Declare Property Text(ByRef Value As WString)
            Declare Property Default As Boolean
            Declare Property Default(Value As Boolean)
            Declare Property Style As ButtonStyle
            Declare Property Style(Value As ButtonStyle)
            Declare Operator Cast As Control Ptr
            Declare Constructor
            Declare Destructor
            #IfNDef __USE_GTK__
				OnDraw  As Sub(BYREF Sender As CommandButton, BYREF R As Rect, DC As HDC = 0)
			#EndIf
    End Type

    Function CommandButton.ReadProperty(PropertyName As String) As Any Ptr
        Select Case LCase(PropertyName)
        Case "caption": Return Cast(Any Ptr, This.FText)
        Case "text": Return Cast(Any Ptr, This.FText)
        Case Else: Return Base.ReadProperty(PropertyName)
        End Select
        Return 0
    End Function
    
    Function CommandButton.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
        Select Case LCase(PropertyName)
        Case "caption": If Value <> 0 Then This.Caption = *Cast(WString Ptr, Value)
        Case "text": If Value <> 0 Then This.Text = *Cast(WString Ptr, Value)
        Case Else: Return Base.WriteProperty(PropertyName, Value)
        End Select
        Return True
    End Function
    
    Property CommandButton.Caption ByRef As WString
		Return Text
    End Property

    Property CommandButton.Caption(ByRef Value As WString)
		Text = Value
    End Property
    
    Property CommandButton.Text ByRef As WString
        Return Base.Text
    End Property

    Property CommandButton.Text(ByRef Value As WString)
        Base.Text = Value
        #IfDef __USE_GTK__
        	gtk_label_set_text_with_mnemonic(gtk_label(gtk_bin_get_child(gtk_bin(widget))), ToUtf8(Replace(Value, "&", "_")))
		#EndIf
    End Property

    Property CommandButton.Default As Boolean
        #IfNDef __USE_GTK__
			If Handle Then
				FDefault = (Style AND BS_DEFPUSHBUTTON)
			End If
		#EndIf
        Return FDefault
    End Property

    Property CommandButton.Default(Value As Boolean)
        If Value <> FDefault Then
            FDefault = Value
            #IfDef __USE_GTK__
            	If Value Then
            		gtk_widget_set_can_default(Widget, True)
	            End If
            #Else
				ChangeStyle BS_PUSHLIKE, False
				ChangeStyle BS_DEFPUSHBUTTON, True
			#EndIf
        End If
    End Property

    Property CommandButton.Style As ButtonStyle
        Return FStyle
    End Property

    Property CommandButton.Style(Value As ButtonStyle)
        If Value <> FStyle Then
            FStyle = Value
            #IfNDef __USE_GTK__
				Base.Style = WS_CHILD OR AStyle(Abs_(FStyle)) OR ADefault(Abs_(FDefault)) 
			#EndIf
        End If
    End Property

    Sub CommandButton.GraphicChange(BYREF Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr,ImageType As Integer)
        With Sender
            If .Ctrl->Child Then
				#IfNDef __USE_GTK__
					Select Case ImageType
					Case IMAGE_BITMAP
						QCommandButton(.Ctrl->Child).Style = bsBitmap
						QCommandButton(.Ctrl->Child).Perform(BM_SETIMAGE,ImageType,CInt(Sender.Bitmap.Handle))
					Case IMAGE_ICON
						QCommandButton(.Ctrl->Child).Style = bsIcon
						QCommandButton(.Ctrl->Child).Perform(BM_SETIMAGE,ImageType,CInt(Sender.Icon.Handle))
					Case IMAGE_CURSOR
						QCommandButton(.Ctrl->Child).Style = bsCursor
						QCommandButton(.Ctrl->Child).Perform(BM_SETIMAGE,ImageType,CInt(Sender.Icon.Handle))
					End Select
				#EndIf
            End If
        End With
    End Sub

	#IfNDef __USE_GTK__
		Sub CommandButton.HandleIsAllocated(BYREF Sender As Control)
			If Sender.Child Then
				With  QCommandButton(Sender.Child)
					If .Style <> bsText Then
						.Perform(BM_SETIMAGE,.Graphic.ImageType,CInt(.Graphic.Image))
					End If
				End With
			End If
		End Sub

		Sub CommandButton.WndProc(BYREF Message As Message)
	'        If Message.Sender Then
	'            If Cast(TControl Ptr,Message.Sender)->Child Then
	'               Cast(CommandButton Ptr,Cast(TControl Ptr,Message.Sender)->Child)->ProcessMessage(Message) 
	'            End If
	'        End If
		End Sub
	#EndIf

    Function CommandButton.EnumMenuItems(Item As MenuItem,BYREF List As List) As Boolean
        For i As Integer = 0 To Item.Count -1
            List.Add Item.Item(i)
            EnumMenuItems *Item.Item(i),List
        Next i
        Return True
    End Function

	Sub CommandButton.ProcessMessage(BYREF msg As Message)
	#IfNDef __USE_GTK__
		Select Case msg.Msg
'        Case BM_CLICK
'            If OnClick Then OnClick(This)
		Case CM_COMMAND
			'If Message.wParamHi = BN_CLICKED Then
			'    If OnClick Then OnClick(This)
			'End If
		Case WM_GETDLGCODE: msg.Result = DLGC_BUTTON Or IIF(FDefault, DLGC_DEFPUSHBUTTON, DLGC_UNDEFPUSHBUTTON)
		Case CM_DRAWITEM
			Dim As DRAWITEMSTRUCT Ptr diStruct
			Dim As Rect R
			Dim As HDC Dc
			diStruct = Cast(DRAWITEMSTRUCT Ptr,msg.lParam)
			R = Cast(Rect,diStruct->rcItem)
			Dc = diStruct->hDC
			If OnDraw Then 
				OnDraw(This,R,Dc)
			Else
			End If
		Case WM_KEYUP
			If LoWord(msg.wParam) = VK_SPACE Or LoWord(msg.wParam) = VK_RETURN Then
				If OnClick Then OnClick(This)
				msg.Result = -1
				Return
			End If
		End Select
		#EndIf
		Base.ProcessMessage(msg)
	End Sub

    Operator CommandButton.Cast As Control Ptr 
        Return Cast(Control Ptr, @This)
    End Operator
	
	#IfDef __USE_GTK__
		Sub CommandButton.Clicked(widget As GtkButton Ptr, user_data As Any Ptr)
	    	Dim As CommandButton Ptr but = user_data
	    	If but->OnClick Then but->OnClick(*but)
	    End Sub
    #EndIf

    Constructor CommandButton
        #IfDef __USE_GTK__
			widget = gtk_button_new_with_label("")
			g_signal_connect(widget, "clicked", G_CALLBACK(@Clicked), @This)
        #Else
			AStyle(0)        = BS_TEXT
			AStyle(1)        = BS_BITMAP
			AStyle(2)        = BS_ICON 
			AStyle(3)        = BS_ICON 
			ADefault(0)      = BS_PUSHLIKE
			ADefault(1)      = BS_DEFPUSHBUTTON
        #EndIf
        Graphic.Ctrl  = @This
        Graphic.OnChange = @GraphicChange
        FTabStop = True
        With This
            .Child       = @This
            #IfNDef __USE_GTK__
				.RegisterClass "CommandButton", "Button"
				.ChildProc   = @WndProc
			#Else
				.RegisterClass "CommandButton", @This
            #EndIf
            WLet FClassName, "CommandButton"
            WLet FClassAncestor, "Button"
            #IfNDef __USE_GTK__
				.ExStyle     = 0
				Base.Style       = WS_CHILD OR WS_TABSTOP OR AStyle(Abs_(FStyle)) OR ADefault(Abs_(FDefault))
            #EndIf
            .Width       = 75
            .Height      = 25
        End With  
    End Constructor

    Destructor CommandButton
    End Destructor
End Namespace
