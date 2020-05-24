'###############################################################################
'#  TextBox.bi                                                                 #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TEdit.bi                                                                  #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "TextBox.bi"

Namespace My.Sys.Forms
	Sub TextBox.ScrollToCaret()
		#ifndef __USE_GTK__
			Perform EM_SCROLLCARET, 0, 0
		#endif
	End Sub
	
	Property TextBox.WantReturn() As Boolean
		#ifndef __USE_GTK__
			FWantReturn = StyleExists(ES_WANTRETURN)
		#endif
		Return FWantReturn
	End Property
	
	Property TextBox.WantReturn(Value As Boolean)
		FWantReturn = Value
		#ifndef __USE_GTK__
			ChangeStyle ES_WANTRETURN, Value
		#endif
	End Property
	
	Property TextBox.Multiline() As Boolean
		Return FMultiline
	End Property
	
	Property TextBox.Multiline(Value As Boolean)
		FMultiline = Value
		#ifdef __USE_GTK__
			If FMultiline Then
				Widget = WidgetTextView
				scrolledwidget = WidgetScrolledWindow
				gtk_container_add(gtk_container(scrolledwidget), widget)
			Else
				Widget = WidgetEntry
				scrolledwidget = 0
			End If
		#else
			If FMultiline Then
				Base.Style = Base.Style Or ES_MULTILINE Or ES_WANTRETURN
			Else
				Base.Style = Base.Style And Not ES_MULTILINE And Not ES_WANTRETURN
			End If
		#endif
	End Property
	
	Sub TextBox.AddLine(ByRef wsLine As WString)
		InsertLine(LinesCount - 1, wsLine)
	End Sub
	
	Sub TextBox.InsertLine(Index As Integer, ByRef wsLine As WString)
		Dim As Integer iStart, LineLen
		#ifndef __USE_GTK__
			Dim As WString Ptr sLine = CAllocate(MAXLENGTH * SizeOf(WString))
			If Index >= 0 Then
				iStart = SendMessage(FHandle, EM_LINEINDEX, Index, 0)
				If iStart >= 0 Then
					*sLine = wsline + WChr(13) & WChr(10)
				Else
					iStart = SendMessage(FHandle, EM_LINEINDEX, Index - 1, 0)
					If iStart < 0 Then Exit Sub
					LineLen = SendMessage(FHandle, EM_LINELENGTH, SelStart,0)
					If LineLen = 0 Then Exit Sub
					iStart += LineLen
					*sLine = WChr(13) & WChr(10) + wsLine
				End If
				SendMessage(FHandle, EM_SETSEL, iStart, iStart)
				SendMessage(FHandle, EM_REPLACESEL, 0, CInt(sLine))
			End If
		#endif
	End Sub
	
	Sub TextBox.RemoveLine(Index As Integer)
		Const Empty = ""
		Dim As Integer iStart, iEnd
		#ifndef __USE_GTK__
			iStart = SendMessage(FHandle, EM_LINEINDEX, Index, 0)
			If iStart >= 0 Then
				iEnd = SendMessage(FHandle, EM_LINEINDEX, Index + 1, 0)
				If iEnd < 0 Then iEnd = iStart + SendMessage(FHandle, EM_LINELENGTH, iStart, 0)
				SendMessage(FHandle, EM_SETSEL, iStart, iEnd)
				SendMessage(FHandle, EM_REPLACESEL, 0, CInt(StrPtr(Empty)))
			End If
		#endif
	End Sub
	
	Property TextBox.Text ByRef As WString
		#ifdef __USE_GTK__
			If gtk_is_widget(widget) Then
				If gtk_is_text_view(widget) Then
					Dim As GtkTextBuffer Ptr buffer = gtk_text_view_get_buffer(gtk_text_view(Widget))
					Dim As GtkTextIter _start, _end
					gtk_text_buffer_get_bounds(buffer, @_start, @_end)
					FText = WStr(*gtk_text_buffer_get_text(buffer, @_start, @_end, True))
				Else
					FText = WStr(*gtk_entry_get_text(gtk_entry(widget)))
				EndIf
			End If
			Return *FText.vptr
		#else
			Return Base.Text
		#endif
	End Property
	
	Property TextBox.Text(ByRef Value As WString)
		Base.Text = Value
		#ifdef __USE_GTK__
			If gtk_is_text_view(widget) Then
				Dim As GtkTextBuffer Ptr buffer = gtk_text_view_get_buffer(gtk_text_view(Widget))
				gtk_text_buffer_set_text(buffer, ToUtf8(IIf(Value = "", " ", Value)), -1)
			Else
				gtk_entry_set_text(gtk_entry(widget), ToUtf8(IIf(Value = "", " ", Value)))
			EndIf
		#endif
	End Property
	
	Function TextBox.GetTextLength() As Integer
		#ifdef __USE_GTK__
			If FMultiline Then
				Dim As GtkTextBuffer Ptr buffer = gtk_text_view_get_buffer(gtk_text_view(Widget))
				Return gtk_text_buffer_get_char_count(buffer)
			Else
				Return gtk_entry_get_text_length(gtk_entry(widget))
			End If
		#else
			Return Base.GetTextLength
		#endif
	End Function
	
	Property TextBox.BorderStyle As Integer
		Return FBorderStyle
	End Property
	
	Property TextBox.BorderStyle(Value As Integer)
		FBorderStyle = Value
		#ifndef __USE_GTK__
			If FBorderStyle Then
				Base.Style = Base.Style Or WS_BORDER
				Base.ExStyle = WS_EX_CLIENTEDGE
			Else
				Base.Style = Base.Style And Not WS_BORDER
				Base.ExStyle = 0
			End If
		#endif
	End Property
	
	Property TextBox.ReadOnly As Boolean
		Return FReadOnly
	End Property
	
	Property TextBox.ReadOnly(Value As Boolean)
		FReadOnly = Value
		#ifdef __USE_GTK__
			If gtk_is_text_view(Widget) Then
				gtk_text_view_set_editable(gtk_text_view(Widget), Not Value)
			ElseIf Widget Then
				gtk_editable_set_editable(gtk_editable(Widget), Not Value)
			End If
		#else
			If Handle Then Perform(EM_SETREADONLY,FReadOnly,0)
		#endif
	End Property
	
	Property TextBox.Ctl3D As Boolean
		Return FCtl3D
	End Property
	
	Property TextBox.Ctl3D(Value As Boolean)
		If Value <> FCtl3D Then
			FCtl3D = Value
			RecreateWnd
		End If
	End Property
	
	Property TextBox.HideSelection As Boolean
		Return FHideSelection
	End Property
	
	Property TextBox.HideSelection(Value As Boolean)
		FHideSelection = Value
		#ifndef __USE_GTK__
			If Not FHideSelection Then Base.Style = Base.Style Or ES_NOHIDESEL Else Base.Style = Base.Style And Not ES_NOHIDESEL
		#endif
	End Property
	
	Property TextBox.OEMConvert As Boolean
		Return FOEMConvert
	End Property
	
	Property TextBox.OEMConvert(Value As Boolean)
		If Value <> FOEMConvert Then
			FOEMConvert = Value
			RecreateWnd
		End If
	End Property
	
	Property TextBox.CharCase As Integer
		Return FCharCase
	End Property
	
	Property TextBox.CharCase(Value As Integer)
		If FCharCase <> Value Then
			FCharCase = Value
			RecreateWnd
		End If
	End Property
	
	Property TextBox.Masked As Boolean
		Return FMasked
	End Property
	
	Property TextBox.Masked(Value As Boolean)
		FMasked = Value
		#ifndef __USE_GTK__
			If Handle Then
				If FMasked Then
					Perform(EM_SETPASSWORDCHAR,FMaskChar,0)
				Else
					Perform(EM_SETPASSWORDCHAR,0,0)
				End If
			End If
		#endif
	End Property
	
	Property TextBox.MaskChar As Byte
		Return FMaskChar
	End Property
	
	Property TextBox.MaskChar(Value As Byte)
		FMaskChar = Value
		#ifndef __USE_GTK__
			If Handle Then Perform(EM_SETPASSWORDCHAR,FMaskChar,0)
		#endif
	End Property
	
	Property TextBox.TopLine As Integer
		#ifndef __USE_GTK__
			If FHandle Then FTopLine = Perform(EM_GETFIRSTVISIBLELINE, 0, 0)
		#endif
		Return FTopLine
	End Property
	
	Property TextBox.TopLine(Value As Integer)
		FTopLine = Value
		#ifndef __USE_GTK__
			If FHandle Then Perform(10012, FTopLine, 0)
		#endif
	End Property
	
	Sub TextBox.InputFilter(ByRef Value As WString)
		FInputFilter = Reallocate(FInputFilter, (Len(Value) + 1) * SizeOf(WString))
		*FInputFilter = Value
	End Sub
	
	Sub TextBox.LoadFromFile(ByRef File As WString)
		Dim Result As Integer
		Result = Open(File For Input Encoding "utf-32" As #1)
		If Result <> 0 Then Result = Open(File For Input Encoding "utf-16" As #1)
		If Result <> 0 Then Result = Open(File For Input Encoding "utf-8" As #1)
		If Result <> 0 Then Result = Open(File For Input As #1)
		If Result = 0 Then
			FText = WInput(LOF(1), #1)
			#ifndef __USE_GTK__
				If FHandle Then SetWindowText(FHandle, FText.vptr)
			#endif
		End If
		Close #1
	End Sub
	
	Sub TextBox.SaveToFile(ByRef File As WString)
		If Open(File For Output Encoding "utf-8" As #1) = 0 Then
			Print #1, Text;
		End If
		Close #1
	End Sub
	
	Function TextBox.GetLineLength(Index As Integer = -1) As Integer
		#ifndef __USE_GTK__
			If FHandle Then
				Dim As Integer CharIndex = SendMessage(FHandle, EM_LINEINDEX, Index, 0)
				Return SendMessage(FHandle, EM_LINELENGTH, CharIndex, 0)
			End If
		#endif
		Return -1
	End Function
	
	Function TextBox.GetLineFromCharIndex(Index As Integer = -1) As Integer
		#ifndef __USE_GTK__
			If FHandle Then
				Return SendMessage(FHandle, EM_LINEFROMCHAR, Index, 0)
			End If
		#endif
		Return -1
	End Function
	
	Function TextBox.GetCharIndexFromLine(Index As Integer) As Integer
		#ifndef __USE_GTK__
			If FHandle Then
				Return SendMessage(FHandle, EM_LINEINDEX, Index, 0)
			End If
		#endif
		Return -1
	End Function
	
	Property TextBox.Lines(Index As Integer) ByRef As WString
		#ifndef __USE_GTK__
			If FHandle Then
				Dim As Integer lThisChar = SendMessage(FHandle, EM_LINEINDEX, Index, 0)
				Dim As Integer lChar = SendMessage(FHandle, em_linelength, lThisChar, 0)
				WLet FLine, WSpace(lChar)
				Mid(*FLine, 1, 1) = WChr(lChar And &HFF)
				Mid(*FLine, 2, 1) = WChr(lChar \ &H100)
				SendMessage(FHandle, em_getline, Index, CInt(FLine))
				Return *FLine
			End If
		#endif
		Return ""
	End Property
	
	Property TextBox.Lines(Index As Integer, ByRef Value As WString)
		#ifndef __USE_GTK__
			If FHandle Then
				Dim As Integer iStart, iEnd
				iStart = SendMessage(FHandle, EM_LINEINDEX, Index, 0)
				If iStart >= 0 Then
					iEnd = SendMessage(FHandle, EM_LINEINDEX, Index + 1, 0)
					If iEnd < 0 Then iEnd = iStart + SendMessage(FHandle, EM_LINELENGTH, iStart, 0)
					SendMessage(FHandle, EM_SETSEL, iStart, iEnd)
					SendMessage(FHandle, EM_REPLACESEL, True, CInt(@Value))
				End If
			End If
		#endif
	End Property
	
	Sub TextBox.GetSel(ByRef iSelStart As Integer, ByRef iSelEnd As Integer)
		#ifdef __USE_GTK__
			If widget Then
				If FMultiLine Then
					Dim As GtkTextIter _start, _end
					Dim As GtkTextBuffer Ptr buffer = gtk_text_view_get_buffer(gtk_text_view(Widget))
					gtk_text_buffer_get_selection_bounds(buffer, @_start, @_end)
					iSelStart = gtk_text_iter_get_offset(@_start)
					iSelEnd = gtk_text_iter_get_offset(@_end)
				Else
					
				End If
			End If
		#else
			If FHandle Then
				SendMessage(FHandle, EM_GETSEL, CInt(@iSelStart), CInt(@iSelEnd))
			End If
		#endif
	End Sub
	
	Sub TextBox.GetSel(ByRef iSelStartRow As Integer, ByRef iSelStartCol As Integer, ByRef iSelEndRow As Integer, ByRef iSelEndCol As Integer)
		#ifndef __USE_GTK__
			If FHandle Then
				Dim As Integer iSelStart, iSelEnd
				SendMessage(FHandle, EM_GETSEL, CInt(@iSelStart), CInt(@iSelEnd))
				iSelStartRow = SendMessage(FHandle, EM_LINEFROMCHAR, iSelStart, 0)
				iSelStartCol = iSelStart - SendMessage(FHandle, EM_LINEINDEX, iSelStartRow, 0)
				iSelEndRow = SendMessage(FHandle, EM_LINEFROMCHAR, iSelEnd, 0)
				iSelEndCol = iSelStart - SendMessage(FHandle, EM_LINEINDEX, iSelEndRow, 0)
			End If
		#endif
	End Sub
	
	Sub TextBox.SetSel(iSelStart As Integer, iSelEnd As Integer)
		#ifdef __USE_GTK__
			If FMultiLine Then
				Dim As GtkTextIter _start, _end
				Dim As GtkTextBuffer Ptr buffer = gtk_text_view_get_buffer(gtk_text_view(Widget))
				gtk_text_buffer_get_iter_at_offset(buffer, @_start, iSelStart)
				gtk_text_buffer_get_iter_at_offset(buffer, @_end, iSelEnd)
				gtk_text_buffer_select_range(buffer, @_start, @_end)
			Else
				
			End If
		#else
			If FHandle Then
				SendMessage(FHandle, EM_SETSEL, iSelStart, iSelEnd)
			End If
		#endif
	End Sub
	
	Sub TextBox.SetSel(iSelStartRow As Integer, iSelStartCol As Integer, iSelEndRow As Integer, iSelEndCol As Integer)
		#ifndef __USE_GTK__
			If FHandle Then
				Dim As Integer iSelStart, iSelEnd
				iSelStart = SendMessage(FHandle, EM_LINEINDEX, iSelStartRow, 0) + iSelStartCol
				iSelEnd = SendMessage(FHandle, EM_LINEINDEX, iSelEndRow, 0) + iSelEndCol
				SendMessage(FHandle, EM_SETSEL, iSelStart, iSelEnd)
			End If
		#endif
	End Sub
	
	Property TextBox.LinesCount As Integer
		#ifndef __USE_GTK__
			If FHandle Then
				Return SendMessage(FHandle, EM_GetLineCount, 0, 0)
			End If
		#endif
		Return 0
	End Property
	
	Property TextBox.LinesCount(Value As Integer)
	End Property
	
	Property TextBox.CaretPos As Point
		#ifndef __USE_GTK__
			If FHandle Then
				Dim As Integer x, y
				x = HiWord(SendMessage(FHandle, EM_GETSEL, 0, 0))
				y = SendMessage(FHandle, EM_LINEFROMCHAR, x, 0)
				x = x - SendMessage(FHandle, EM_LINEINDEX, -1, 0)
				Return Type(x, y)
			End If
		#endif
		Return Type(0, 0)
	End Property
	
	Property TextBox.CaretPos(value As Point)
	End Property
	
	Property TextBox.ScrollBars As Integer
		Return FScrollBars
	End Property
	
	Property TextBox.ScrollBars(Value As Integer)
		FScrollBars = Value
		#ifndef __USE_GTK__
			Select Case FScrollBars
			Case 0
				FStyle = FStyle And Not (ws_hscroll Or ws_vscroll)
			Case 1
				FStyle = (FStyle And Not ws_hscroll) Or ws_vscroll
			Case 2
				FStyle = (FStyle And Not ws_vscroll) Or ws_hscroll
			Case 3
				FStyle = FStyle Or (ws_hscroll Or ws_vscroll)
			End Select
		#endif
	End Property
	
	Property TextBox.WordWraps As Integer
		Return FWordWraps
	End Property
	
	Property TextBox.WordWraps(Value As Integer)
		FWordWraps = value
		#ifndef __USE_GTK__
			If Value Then
				FStyle = FStyle And Not es_autohscroll
			Else
				FStyle = FStyle Or es_autohscroll
			End If
		#endif
	End Property
	
	Property TextBox.SelStart As Integer
		Dim As Integer LStart
		#ifndef __USE_GTK__
			SendMessage(Handle, EM_GETSEL, CInt(@LStart), 0)
		#endif
		FSelStart = LStart
		Return FSelStart
	End Property
	
	Property TextBox.SelStart(Value As Integer)
		FSelStart = Value
		#ifndef __USE_GTK__
			SendMessage(Handle, EM_SETSEL, Value, Value)
		#endif
	End Property
	
	Property TextBox.SelLength As Integer
		Dim As Integer LStart,LEnd
		#ifndef __USE_GTK__
			SendMessage(Handle, EM_GETSEL, CInt(@LStart), CInt(@LEnd))
		#endif
		FSelLength = LEnd - LStart
		Return FSelLength
	End Property
	
	Property TextBox.SelLength(Value As Integer)
		Dim As Integer LStart,LEnd,FEnd
		FSelLength = Value
		#ifndef __USE_GTK__
			SendMessage(Handle, EM_GETSEL, CInt(@LStart), CInt(@LEnd))
			FEnd = LStart + Value
			SendMessage(Handle, EM_SETSEL, LStart, FEnd)
			SendMessage(Handle, EM_SCROLLCARET, 0,0)
		#endif
	End Property
	
	Property TextBox.SelEnd As Integer
		Dim As Integer LEnd
		#ifndef __USE_GTK__
			SendMessage(Handle, EM_GETSEL, 0, CInt(@LEnd))
		#endif
		FSelEnd = LEnd
		Return FSelEnd
	End Property
	
	Property TextBox.SelEnd(Value As Integer)
		Dim As Integer LStart, LEnd, FEnd
		FSelEnd = Value
		#ifndef __USE_GTK__
			SendMessage(Handle, EM_GETSEL, CInt(@LStart), CInt(@LEnd))
			SendMessage(Handle, EM_SETSEL, LStart, FSelEnd)
			SendMessage(Handle, EM_SCROLLCARET, 0,0)
		#endif
	End Property
	
	Property TextBox.SelText ByRef As WString
		#ifndef __USE_GTK__
			If FHandle Then
				Dim As Integer LStart, LEnd
				SendMessage(FHandle, EM_GETSEL, CInt(@LStart), CInt(@LEnd))
				If LEnd - LStart <= 0 Then
					FSelText = Reallocate(FSelText, SizeOf(WString))
					*FSelText = ""
				Else
					FSelText = Reallocate(FSelText, (LEnd - LStart + 1 + 1) * SizeOf(WString))
					*FSelText = Mid(Text, LStart + 1, LEnd - LStart)
				End If
			End If
		#endif
		Return *FSelText
	End Property
	
	Property TextBox.SelText(ByRef Value As WString)
		FSelText = Reallocate(FSelText, (Len(Value) + 1) * SizeOf(WString))
		*FSelText = Value
		#ifdef __USE_GTK__
			If FMultiLine Then
				Dim As GtkTextBuffer Ptr buffer = gtk_text_view_get_buffer(gtk_text_view(Widget))
				Dim As GtkTextIter _start, _end
				gtk_text_buffer_insert_at_cursor(buffer, ToUTF8(Value), -1)
				buffer = gtk_text_view_get_buffer(gtk_text_view(Widget))
				gtk_text_buffer_get_selection_bounds(buffer, @_start, @_end)
				gtk_text_view_scroll_to_iter(gtk_text_view(Widget), @_end, 0, False, 0, 0)
			Else
				'gtk_editable_get_position(gtk_editable(widget))
				
				'"cursor-position"
				'gtk_entry_buffer_insert_text
			EndIf
		#else
			SendMessage(FHandle, EM_REPLACESEL, 0, CInt(FSelText))
		#endif
	End Property
	
	Property TextBox.MaxLength As Integer
		Return FMaxLength
	End Property
	
	Property TextBox.MaxLength(Value As Integer)
		FMaxLength = Value
		#ifndef __USE_GTK__
			If Handle Then Perform(EM_LIMITTEXT, Value, 0)
		#endif
	End Property
	
	Property TextBox.Modified As Boolean
		#ifndef __USE_GTK__
			If Handle Then
				FModified = (Perform(EM_GETMODIFY, 0, 0) <> 0)
			End If
		#endif
		Return FModified
	End Property
	
	Property TextBox.Modified(Value As Boolean)
		FModified = Value
		#ifndef __USE_GTK__
			If Handle Then
				Perform(EM_SETMODIFY, Cast(Byte,Value), 0)
			End If
		#endif
	End Property
	
	#ifndef __USE_GTK__
		Sub TextBox.WndProc(ByRef message As Message)
		End Sub
		
		Sub TextBox.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QTextBox(Sender.Child)
					'If .MaxLength <> 0 Then
					.Perform(EM_LIMITTEXT, -1, 0)
					If .ReadOnly Then .Perform(EM_SETREADONLY, True, 0)
					'.MaxLength = .MaxLength
					'End If
				End With
			End If
		End Sub
	#endif
	
	#ifndef __USE_GTK__
		Sub TextBox.ProcessMessage(ByRef message As Message)
			'?GetMessageName(message.msg)
			Select Case message.Msg
			Case CM_CTLCOLOR
				Static As HDC Dc
				Dc = Cast(HDC,Message.wParam)
				SetBKMode Dc, TRANSPARENT
				SetTextColor Dc,Font.Color
				SetBKColor Dc,This.BackColor
				SetBKMode Dc,OPAQUE
			Case CM_COMMAND
				Select Case Message.wParamHi
				Case BN_CLICKED
					If OnClick Then OnClick(This)
				Case EN_CHANGE
					If OnChange Then OnChange(This)
				Case EN_UPDATE
					If OnUpdate Then OnUpdate(This)
				Case EN_KILLFOCUS
					If OnLostFocus Then OnLostFocus(This)
				Case EN_SETFOCUS
					If OnGotFocus Then OnGotFocus(This)
				Case EN_VSCROLL
					If OnVScroll Then OnVScroll(This)
				Case EN_HSCROLL
					If OnHScroll Then OnHScroll(This)
				End Select
				message.result = 0
			Case WM_CHAR
				If Len(*FInputFilter)>0 Then
					If InStr(*FInputFilter,WChr(Message.WParam))=0 And Message.wParam>31 Then message.result = -1
				End If
			Case WM_KEYUP
				'David Change
				'bShift = GetKeyState(VK_SHIFT) And 8000
				'bCtrl = GetKeyState(VK_CONTROL) And 8000
				If ParentHandle>0 THEN
					Select Case message.wParam
					Case VK_RETURN, VK_ESCAPE,VK_DOWN, VK_UP,VK_LEFT,VK_RIGHT,VK_TAB
						PostMessage(ParentHandle, CM_COMMAND, Message.wParam, 9999)
						'case VK_HOME,VK_END,VK_PRIOR,VK_NEXT,VK_INSERT,VK_DELETE,VK_BACK
						'case VK_MENU 'VK_CONTROL VK_SHIFT
						'print "TextBox VK_MENU: ",VK_MENU
						'case else
					End Select
				End if
			Case WM_SETFOCUS
				'David Change
				If Handle Then
					If This.SelText Then
						SendMessage Handle, EM_SETSEL, 0, -1
					Else
						SendMessage Handle, EM_SETSEL, -1, 0
					End If
				End If
			Case WM_CUT
				If OnCut Then OnCut(This)
			Case WM_COPY
				If OnCopy Then OnCopy(This)
			Case WM_PASTE
				Dim Action As Integer = 1
				If OnPaste Then OnPaste(This, Action)
				Select Case Action
				Case 0: message.result = -1
				Case 1: message.result = 0
				End Select
			End Select
			Base.ProcessMessage(message)
		End Sub
	#endif
	
	Sub TextBox.Clear
		Text = ""
	End Sub
	
	Sub TextBox.ClearUndo
		#ifndef __USE_GTK__
			If FHandle Then Perform(EM_EMPTYUNDOBUFFER, 0, 0)
		#endif
	End Sub
	
	Function TextBox.CanUndo As Boolean
		#ifndef __USE_GTK__
			If FHandle Then
				Return (Perform(EM_CANUNDO, 0, 0) <> 0)
			Else
				Return 0
			End If
		#else
			Return 0
		#endif
	End Function
	
	Sub TextBox.Undo
		#ifndef __USE_GTK__
			If FHandle Then Perform(WM_UNDO, 0, 0)
		#endif
	End Sub
	
	Sub TextBox.PasteFromClipboard
		#ifndef __USE_GTK__
			If FHandle Then Perform(WM_PASTE, 0, 0)
		#endif
	End Sub
	
	Sub TextBox.CopyToClipboard
		#ifndef __USE_GTK__
			If FHandle Then Perform(WM_COPY, 0, 0)
		#endif
	End Sub
	
	Sub TextBox.CutToClipboard
		#ifndef __USE_GTK__
			If FHandle Then Perform(WM_CUT, 0, 0)
		#endif
	End Sub
	
	Sub TextBox.SelectAll
		#ifndef __USE_GTK__
			If FHandle Then Perform(EM_SETSEL, 0, -1)
		#endif
	End Sub
	
	Operator TextBox.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Sub TextBox.Entry_Activate(entry As GtkEntry Ptr, user_data As Any Ptr)
			Dim As TextBox Ptr txt = user_data
			Dim As Control Ptr btn = txt->GetForm()->FDefaultButton
			If btn AndAlso btn->OnClick Then btn->OnClick(*btn)
		End Sub
	#endif
	
	Constructor TextBox
		'FSelText = CAllocate(0)
		#ifdef __USE_GTK__
			WidgetEntry = gtk_entry_new()
			WidgetTextView = gtk_text_view_new()
			gtk_entry_set_activates_default(gtk_entry(WidgetEntry), True)
			gtk_entry_set_width_chars(gtk_entry(WidgetEntry), 0)
			g_signal_connect(gtk_entry(WidgetEntry), "activate", G_CALLBACK(@Entry_Activate), @This)
			WidgetScrolledWindow = gtk_scrolled_window_new(NULL, NULL)
			gtk_scrolled_window_set_policy(gtk_scrolled_window(WidgetScrolledWindow), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
			Widget = WidgetEntry
			This.RegisterClass "TextBox", @This
		#else
			ACharCase(0)      = 0
			ACharCase(1)      = ES_UPPERCASE
			ACharCase(2)      = ES_LOWERCASE
			AMaskStyle(0)     = 0
			AMaskStyle(1)     = ES_PASSWORD
			ABorderExStyle(0) = 0
			ABorderExStyle(1) = WS_EX_CLIENTEDGE
			ABorderStyle(0)   = 0
			ABorderStyle(1)   = WS_BORDER
			AOEMConvert(0)    = 0
			AOEMConvert(1)    = ES_OEMCONVERT
			AHideSelection(0) = ES_NOHIDESEL
			AHideSelection(1) = 0
		#endif
		FHideSelection    = 1
		FCtl3D            = True
		FMaskChar         = Asc("*")
		FMaxLength          = 64000
		FEnabled = True
		FTabStop = True
		With This
			#ifndef __USE_GTK__
				.OnHandleIsAllocated = @HandleIsAllocated
				.ChildProc   = @WndProc
				.ExStyle     = WS_EX_CLIENTEDGE ' OR ES_AUTOHSCROLL OR ES_AUTOVSCROLL
				.Style       = WS_CHILD Or ES_AUTOHSCROLL Or WS_TABSTOP Or ES_WANTRETURN Or ACharCase(Abs_(FCharCase)) Or AMaskStyle(Abs_(FMasked)) Or AOEMConvert(Abs_(FOEMConvert)) Or AHideSelection(Abs_(FHideSelection))
				.BackColor       = GetSysColor(COLOR_WINDOW)
				.DoubleBuffered = True
				.RegisterClass "TextBox", "Edit"
			#endif
			WLet FClassName, "TextBox"
			WLet FClassAncestor, "Edit"
			.Child       = @This
			.Width       = 121
			.Height      = ScaleY(Font.Size /72*96+6) '21
			'.Cursor      = LoadCursor(NULL, IDC_IBEAM)
		End With
	End Constructor
	
	Destructor TextBox
		If FSelText Then Deallocate FSelText
		If FLine Then Deallocate FLine
	End Destructor
End Namespace
