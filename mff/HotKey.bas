'###############################################################################
'#  HotKey.bi                                                                  #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                    #
'###############################################################################

#include once "HotKey.bi"

Namespace My.Sys.Forms
	Function HotKey.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "text": Text: Return FText.vptr
		Case "tabindex": Return @FTabIndex
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function HotKey.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "text": This.Text = QWString(Value)
		Case "tabindex": TabIndex = QInteger(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Property HotKey.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Property HotKey.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Property HotKey.TabStop As Boolean
		Return FTabStop
	End Property
	
	Property HotKey.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	#ifndef __USE_GTK__
		Sub HotKey.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QHotKey(Sender.Child)
					
				End With
			End If
		End Sub
		
		Sub HotKey.WndProc(ByRef Message As Message)
		End Sub
	#endif
	
	Sub HotKey.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_GTK__
			Dim As GdkEvent Ptr e = Message.event
			Select Case Message.event->Type
			Case GDK_BUTTON_PRESS
				Message.Result = True
				Return
			Case GDK_BUTTON_RELEASE
				Message.Result = True
				Return
			Case GDK_KEY_PRESS
				Dim As String KeyName = *gdk_keyval_name(e->Key.keyval)
				Select Case KeyName
				Case "Shift_L", "Shift_R", "Control_L", "Control_R", "Meta_L", "Meta_R", "Alt_L", "Alt_R", "Super_L", "Super_R", "Hyper_L", "Hyper_R"
				Case Else
					KeyName = UCase(KeyName)
					If e->Key.state And GDK_Mod1_MASK Then KeyName = "Alt + " & KeyName
					If e->Key.state And GDK_Shift_MASK Then KeyName = "Shift + " & KeyName
					If e->Key.state And GDK_Control_MASK Then KeyName = "Ctrl + " & KeyName
					If e->Key.state And GDK_Meta_MASK Then KeyName = "Meta + " & KeyName
					If e->Key.state And GDK_Super_MASK Then KeyName = "Super + " & KeyName
					If e->Key.state And GDK_Hyper_MASK Then KeyName = "Hyper + " & KeyName
					gtk_entry_set_text(gtk_entry(widget), ToUTF8(KeyName))
					gtk_editable_set_position(gtk_editable(widget), Len(KeyName))
					If OnChange Then OnChange(This)
					Message.Result = True
					Return
				End Select
			End Select
		#else
			Select Case Message.Msg
			Case CM_COMMAND
				Select Case Message.wParamHi
				Case EN_CHANGE
					If OnChange Then OnChange(This)
				End Select
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Property HotKey.Text ByRef As WString
		#ifdef __USE_GTK__
			FText = Replace(WStr(*gtk_entry_get_text(gtk_entry(widget))), " ", "")
		#else
			Dim wHotKey As Word
			wHotKey = SendMessage(Handle, HKM_GETHOTKEY, 0, 0)
			FText = GetChrKeyCode(LoByte(LoWord(wHotKey)))
			If (HiByte(LoWord(wHotKey)) And HOTKEYF_SHIFT) = HOTKEYF_SHIFT Then FText = "Shift+" & FText
			If (HiByte(LoWord(wHotKey)) And HOTKEYF_ALT) = HOTKEYF_ALT Then FText = "Alt+" & FText
			If (HiByte(LoWord(wHotKey)) And HOTKEYF_CONTROL) = HOTKEYF_CONTROL Then FText = "Ctrl+" & FText
		#endif
		Return *FText.vptr
	End Property
	
	Property HotKey.Text(ByRef Value As WString)
		FText = Value
		#ifdef __USE_GTK__
			Dim sKey As String = Value
			Dim wHotKey As String
			Var Pos1 = InStrRev(sKey, "+")
			If Pos1 > 0 Then sKey = Trim(Mid(sKey, Pos1 + 1))
			wHotKey = IIf(InStr(Value, "Ctrl") > 0, "Ctrl + ", "") & IIf(InStr(Value, "Shift") > 0, "Shift + ", "") & IIf(InStr(Value, "Alt") > 0, "Alt + ", "") & _
			IIf(InStr(Value, "Meta") > 0, "Meta + ", "") & IIf(InStr(Value, "Super") > 0, "Super + ", "") & IIf(InStr(Value, "Hyper") > 0, "Hyper + ", "") & UCase(sKey)
			gtk_entry_set_text(gtk_entry(widget), ToUTF8(wHotKey))
		#else
			Dim sKey As String = Value
			Dim wHotKey As Word
			Var Pos1 = InStrRev(sKey, "+")
			If Pos1 > 0 Then sKey = Mid(sKey, Pos1 + 1)
			wHotKey = MAKEWORD(GetAscKeyCode(sKey), IIf(InStr(Value, "Ctrl") > 0, HOTKEYF_CONTROL, 0) Or IIf(InStr(Value, "Shift") > 0, HOTKEYF_SHIFT, 0) Or IIf(InStr(Value, "Alt") > 0, HOTKEYF_ALT, 0))
			SendMessage(Handle, HKM_SETHOTKEY, wHotKey, 0)
		#endif
	End Property
	
	Operator HotKey.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Sub HotKey.Entry_Activate(entry As GtkEntry Ptr, user_data As Any Ptr)
			Dim As HotKey Ptr hk = user_data
			Dim As Control Ptr btn = hk->GetForm()->FDefaultButton
			If btn AndAlso btn->OnClick Then btn->OnClick(*btn)
		End Sub
	#endif
	
	Constructor HotKey
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
	
	Destructor HotKey
		#ifndef __USE_GTK__
			UnregisterClass "HotKey", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
