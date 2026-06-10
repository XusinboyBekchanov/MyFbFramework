'###############################################################################
'#  HotKey.bi                                                                  #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'###############################################################################

#include once "HotKey.bi"

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function HotKey.ReadProperty(PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "text": Text: Return FText.vptr
			Case "tabindex": Return @FTabIndex
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function HotKey.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "text": This.Text = QWString(Value)
			Case "tabindex": TabIndex = QInteger(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	
	Private Property HotKey.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property HotKey.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property HotKey.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property HotKey.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	#ifndef __USE_GTK__
		Private Sub HotKey.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QHotKey(Sender.Child)
					
				End With
			End If
		End Sub
		
		Private Sub HotKey.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Private Sub HotKey.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_GTK__
			Dim As GdkEvent Ptr e = Message.Event
			Select Case Message.Event->type
			Case GDK_BUTTON_PRESS
				Message.Result = True
				Return
			Case GDK_BUTTON_RELEASE
				Message.Result = True
				Return
			Case GDK_KEY_PRESS
				Dim As String KeyName = *gdk_keyval_name(e->key.keyval)
				Select Case KeyName
				Case "Shift_L", "Shift_R", "Control_L", "Control_R", "Meta_L", "Meta_R", "Alt_L", "Alt_R", "Super_L", "Super_R", "Hyper_L", "Hyper_R"
					bKeyPressed = False
					KeyName = ..Left(KeyName, Len(KeyName) - 2)
					If KeyName = "Control" Then KeyName = "Ctrl"
					Select Case KeyName
					Case "Ctrl": bCtrl = True
					Case "Shift": bShift = True
					Case "Alt": bAlt = True
					Case "Meta": bMeta = True
					Case "Super": bSuper = True
					Case "Hyper": bHyper = True
					End Select
					KeyName = ""
'					If e->Key.state And GDK_Mod1_MASK Then KeyName = "Alt + " & KeyName
'					If e->Key.state And GDK_Shift_MASK Then KeyName = "Shift + " & KeyName
'					If e->Key.state And GDK_Control_MASK Then KeyName = "Ctrl + " & KeyName
'					If e->Key.state And GDK_Meta_MASK Then KeyName = "Meta + " & KeyName
'					If e->Key.state And GDK_Super_MASK Then KeyName = "Super + " & KeyName
'					If e->Key.state And GDK_Hyper_MASK Then KeyName = "Hyper + " & KeyName
					If bAlt Then KeyName = "Alt + " & KeyName
					If bShift Then KeyName = "Shift + " & KeyName
					If bCtrl Then KeyName = "Ctrl + " & KeyName
					If bMeta Then KeyName = "Meta + " & KeyName
					If bSuper Then KeyName = "Super + " & KeyName
					If bHyper Then KeyName = "Hyper + " & KeyName
					#ifdef __USE_GTK4__
						gtk_entry_buffer_set_text(gtk_entry_get_buffer(GTK_ENTRY(widget)), ToUtf8(KeyName), -1)
					#else
						gtk_entry_set_text(GTK_ENTRY(widget), ToUtf8(KeyName))
					#endif
					gtk_editable_set_position(GTK_EDITABLE(widget), Len(KeyName))
					If OnChange Then OnChange(*Designer, This)
				Case Else
					KeyName = UCase(KeyName)
					'If KeyName <> "ISO_NEXT_GROUP" Then
						bKeyPressed = True
						If e->key.state And GDK_MOD1_MASK Then KeyName = "Alt + " & KeyName
						If e->key.state And GDK_SHIFT_MASK Then KeyName = "Shift + " & KeyName
						If e->key.state And GDK_CONTROL_MASK Then KeyName = "Ctrl + " & KeyName
						If e->key.state And GDK_META_MASK Then KeyName = "Meta + " & KeyName
						If e->key.state And GDK_SUPER_MASK Then KeyName = "Super + " & KeyName
						If e->key.state And GDK_HYPER_MASK Then KeyName = "Hyper + " & KeyName
'						If bAlt Then KeyName = "Alt + " & KeyName
'						If bShift Then KeyName = "Shift + " & KeyName
'						If bCtrl Then KeyName = "Ctrl + " & KeyName
'						If bMeta Then KeyName = "Meta + " & KeyName
'						If bSuper Then KeyName = "Super + " & KeyName
'						If bHyper Then KeyName = "Hyper + " & KeyName
						#ifdef __USE_GTK4__
							If WStr(*gtk_entry_buffer_get_text(gtk_entry_get_buffer(GTK_ENTRY(widget)))) <> KeyName Then
								gtk_entry_buffer_set_text(gtk_entry_get_buffer(GTK_ENTRY(widget)), ToUtf8(KeyName), -1)
						#else
							If WStr(*gtk_entry_get_text(GTK_ENTRY(widget))) <> KeyName Then
								gtk_entry_set_text(GTK_ENTRY(widget), ToUtf8(KeyName))
						#endif
							gtk_editable_set_position(GTK_EDITABLE(widget), Len(KeyName))
							If OnChange Then OnChange(*Designer, This)
						End If
						Message.Result = True
						Return
					'End If
				End Select
			Case GDK_KEY_RELEASE
				Dim As String KeyName = *gdk_keyval_name(e->key.keyval)
				Select Case KeyName
				Case "Shift_L", "Shift_R", "Control_L", "Control_R", "Meta_L", "Meta_R", "Alt_L", "Alt_R", "Super_L", "Super_R", "Hyper_L", "Hyper_R"
					KeyName = ..Left(KeyName, Len(KeyName) - 2)
					If KeyName = "Control" Then KeyName = "Ctrl"
					Select Case KeyName
					Case "Ctrl": bCtrl = False
					Case "Shift": bShift = False
					Case "Alt": bAlt = False
					Case "Meta": bMeta = False
					Case "Super": bSuper = False
					Case "Hyper": bHyper = False
					End Select
					If Not bKeyPressed Then
						KeyName = !"\0"
						#ifdef __USE_GTK4__
							If WStr(*gtk_entry_buffer_get_text(gtk_entry_get_buffer(GTK_ENTRY(widget)))) <> KeyName Then
								gtk_entry_buffer_set_text(gtk_entry_get_buffer(GTK_ENTRY(widget)), KeyName, -1)
						#else
							If WStr(*gtk_entry_get_text(GTK_ENTRY(widget))) <> KeyName Then
								gtk_entry_set_text(GTK_ENTRY(widget), KeyName)
						#endif
							gtk_editable_set_position(GTK_EDITABLE(widget), Len(KeyName))
							If OnChange Then OnChange(*Designer, This)
						End If
					End If
				End Select
			End Select
		#else
			Select Case Message.Msg
			Case CM_COMMAND
				Select Case Message.wParamHi
				Case EN_CHANGE
					If OnChange Then OnChange(*Designer, This)
				End Select
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Property HotKey.Text ByRef As WString
		#ifdef __USE_GTK__
			#ifdef __USE_GTK4__
				FText = Replace(WStr(*gtk_entry_buffer_get_text(gtk_entry_get_buffer(GTK_ENTRY(widget)))), " ", "")
			#else
				FText = Replace(WStr(*gtk_entry_get_text(GTK_ENTRY(widget))), " ", "")
			#endif
		#else
			Dim wHotKey As WORD
			wHotKey = SendMessage(Handle, HKM_GETHOTKEY, 0, 0)
			FText = GetChrKeyCode(LoByte(LoWord(wHotKey)))
			If (HiByte(LoWord(wHotKey)) And HOTKEYF_SHIFT) = HOTKEYF_SHIFT Then FText = "Shift+" & FText
			If (HiByte(LoWord(wHotKey)) And HOTKEYF_ALT) = HOTKEYF_ALT Then FText = "Alt+" & FText
			If (HiByte(LoWord(wHotKey)) And HOTKEYF_CONTROL) = HOTKEYF_CONTROL Then FText = "Ctrl+" & FText
		#endif
		Return *FText.vptr
	End Property
	
	Private Property HotKey.Text(ByRef Value As WString)
		FText = Value
		#ifdef __USE_GTK__
			Dim sKey As String = Value
			Dim wHotKey As String
			Var Pos1 = InStrRev(sKey, "+")
			If Pos1 > 0 Then sKey = Trim(Mid(sKey, Pos1 + 1))
			wHotKey = IIf(InStr(Value, "Ctrl") > 0, "Ctrl + ", "") & IIf(InStr(Value, "Shift") > 0, "Shift + ", "") & IIf(InStr(Value, "Alt") > 0, "Alt + ", "") & _
			IIf(InStr(Value, "Meta") > 0, "Meta + ", "") & IIf(InStr(Value, "Super") > 0, "Super + ", "") & IIf(InStr(Value, "Hyper") > 0, "Hyper + ", "") & UCase(sKey)
			If wHotKey = "" Then
				#ifdef __USE_GTK4__
					gtk_entry_buffer_set_text(gtk_entry_get_buffer(GTK_ENTRY(widget)), !"\0", -1)
				#else
					gtk_entry_set_text(GTK_ENTRY(widget), !"\0")
				#endif
			Else
				#ifdef __USE_GTK4__
					gtk_entry_buffer_set_text(gtk_entry_get_buffer(GTK_ENTRY(widget)), ToUtf8(wHotKey), -1)
				#else
					gtk_entry_set_text(GTK_ENTRY(widget), ToUtf8(wHotKey))
				#endif
			End If
		#else
			Dim sKey As String = Value
			Dim wHotKey As WORD
			Var Pos1 = InStrRev(sKey, "+")
			If Pos1 > 0 Then sKey = Mid(sKey, Pos1 + 1)
			wHotKey = MAKEWORD(GetAscKeyCode(sKey), IIf(InStr(Value, "Ctrl") > 0, HOTKEYF_CONTROL, 0) Or IIf(InStr(Value, "Shift") > 0, HOTKEYF_SHIFT, 0) Or IIf(InStr(Value, "Alt") > 0, HOTKEYF_ALT, 0))
			SendMessage(Handle, HKM_SETHOTKEY, wHotKey, 0)
		#endif
	End Property
	
	Private Operator HotKey.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Private Sub HotKey.Entry_Activate(entry As GtkEntry Ptr, user_data As Any Ptr)
			Dim As HotKey Ptr hk = user_data
			Dim As Control Ptr btn = hk->GetForm()->FDefaultButton
			If btn AndAlso btn->OnClick Then btn->OnClick(*btn->Designer, *btn)
		End Sub
	#endif
	
	Private Constructor HotKey
		With This
			WLet(FClassName, "HotKey")
			WLet(FClassAncestor, "msctls_hotkey32")
			FTabIndex          = -1
			FTabStop           = True
			#ifdef __USE_GTK__
				Widget = gtk_entry_new()
				g_signal_connect(gtk_entry(Widget), "activate", G_CALLBACK(@Entry_Activate), @This)
				This.RegisterClass "HotKey", @This
			#else
				.RegisterClass "HotKey","msctls_hotkey32"
				.Style        = WS_CHILD
				.ExStyle      = 0
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.Width        = 175
			.Height       = 21
			.Child        = @This
		End With
	End Constructor
	
	Private Destructor HotKey
		#ifndef __USE_GTK__
			UnregisterClass "HotKey", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
