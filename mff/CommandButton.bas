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

#include once "CommandButton.bi"

Namespace My.Sys.Forms
	Function CommandButton.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "caption": Return Cast(Any Ptr, This.FText.vptr)
		Case "default": Return Cast(Any Ptr, @FDefault)
		Case "text": Return Cast(Any Ptr, This.FText.vptr)
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function CommandButton.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "caption": If Value <> 0 Then This.Text = QWString(Value)
		Case "default": If Value <> 0 Then This.Default = QBoolean(Value)
		Case "text": If Value <> 0 Then This.Text = QWString(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Property CommandButton.Caption ByRef As WString
		Return This.Text
	End Property
	
	Property CommandButton.Caption(ByRef Value As WString)
		This.Text = Value
	End Property
	
	Property CommandButton.Text ByRef As WString
		Return Base.Text
	End Property
	
	Property CommandButton.Text(ByRef Value As WString)
		Base.Text = Value
		#ifdef __USE_GTK__
			gtk_label_set_text_with_mnemonic(gtk_label(gtk_bin_get_child(gtk_bin(widget))), ToUtf8(Replace(Value, "&", "_")))
		#endif
	End Property
	
	Property CommandButton.Default As Boolean
		#ifndef __USE_GTK__
			If Handle Then
				FDefault = (Style And BS_DEFPUSHBUTTON)
			End If
		#endif
		Return FDefault
	End Property
	
	Property CommandButton.Default(Value As Boolean)
		If Value <> FDefault Then
			FDefault = Value
			#ifdef __USE_GTK__
				gtk_widget_set_can_default(Widget, Value)
			#else
				ChangeStyle BS_PUSHLIKE, False
				ChangeStyle BS_DEFPUSHBUTTON, True
			#endif
		End If
	End Property
	
	Property CommandButton.Style As ButtonStyle
		Return FStyle
	End Property
	
	Property CommandButton.Style(Value As ButtonStyle)
		If Value <> FStyle Then
			FStyle = Value
			#ifndef __USE_GTK__
				Base.Style = WS_CHILD Or AStyle(Abs_(FStyle)) Or ADefault(Abs_(FDefault))
			#endif
		End If
	End Property
	
	Sub CommandButton.GraphicChange(ByRef Sender As My.Sys.Drawing.GraphicType, Image As Any Ptr,ImageType As Integer)
		With Sender
			If .Ctrl->Child Then
				#ifndef __USE_GTK__
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
				#endif
			End If
		End With
	End Sub
	
	#ifndef __USE_GTK__
		Sub CommandButton.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With  QCommandButton(Sender.Child)
					If .Style <> bsText Then
						.Perform(BM_SETIMAGE,.Graphic.ImageType,CInt(.Graphic.Image))
					End If
				End With
			End If
		End Sub
		
		Sub CommandButton.WndProc(ByRef Message As Message)
			'        If Message.Sender Then
			'            If Cast(TControl Ptr,Message.Sender)->Child Then
			'               Cast(CommandButton Ptr,Cast(TControl Ptr,Message.Sender)->Child)->ProcessMessage(Message)
			'            End If
			'        End If
		End Sub
	#endif
	
	Function CommandButton.EnumMenuItems(Item As MenuItem,ByRef List As List) As Boolean
		For i As Integer = 0 To Item.Count -1
			List.Add Item.Item(i)
			EnumMenuItems *Item.Item(i),List
		Next i
		Return True
	End Function
	
	Sub CommandButton.ProcessMessage(ByRef msg As Message)
		#ifndef __USE_GTK__
			Select Case msg.Msg
				'        Case BM_CLICK
				'            If OnClick Then OnClick(This)
			Case CM_COMMAND
				'If Message.wParamHi = BN_CLICKED Then
				'    If OnClick Then OnClick(This)
				'End If
			Case WM_GETDLGCODE: msg.Result = DLGC_BUTTON Or DLGC_WANTTAB Or IIf(FDefault, DLGC_DEFPUSHBUTTON, 0)
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
		#endif
		Base.ProcessMessage(msg)
	End Sub
	
	Operator CommandButton.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Sub CommandButton.Clicked(widget As GtkButton Ptr, user_data As Any Ptr)
			Dim As CommandButton Ptr but = user_data
			If but->OnClick Then but->OnClick(*but)
		End Sub
	#endif
	
	Constructor CommandButton
		#ifdef __USE_GTK__
			widget = gtk_button_new_with_label("")
			g_signal_connect(widget, "clicked", G_CALLBACK(@Clicked), @This)
		#else
			AStyle(0)        = BS_TEXT
			AStyle(1)        = BS_BITMAP
			AStyle(2)        = BS_ICON
			AStyle(3)        = BS_ICON
			ADefault(0)      = 0 'BS_PUSHLIKE
			ADefault(1)      = BS_DEFPUSHBUTTON
		#endif
		Graphic.Ctrl  = @This
		Graphic.OnChange = @GraphicChange
		FTabStop = True
		With This
			.Child       = @This
			#ifndef __USE_GTK__
				.RegisterClass "CommandButton", "Button"
				.ChildProc   = @WndProc
			#else
				.RegisterClass "CommandButton", @This
			#endif
			WLet FClassName, "CommandButton"
			WLet FClassAncestor, "Button"
			#ifndef __USE_GTK__
				.ExStyle     = 0
				Base.Style       = WS_CHILD Or WS_TABSTOP Or AStyle(Abs_(FStyle)) Or ADefault(Abs_(FDefault))
			#endif
			.Width       = 75
			.Height      = 25
		End With
	End Constructor
	
	Destructor CommandButton
	End Destructor
End Namespace
