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
	#ifndef ReadProperty_Off
		Private Function TextBox.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "alignment": Return @FAlignment
			Case "borderstyle": Return @FBorderStyle
			'Case "caretpos": Return @CaretPos
			Case "charcase": Return @FCharCase
			Case "ctl3d": Return @FCtl3D
			Case "hideselection": Return @FHideSelection
			Case "maskchar": Return FMaskChar
			Case "masked": Return @FMasked
			Case "maxlength": Return @FMaxLength
			Case "modified": Return @FModified
			Case "multiline": Return @FMultiline
			Case "numbersonly": Return @FNumbersOnly
			Case "oemconvert": Return @FOEMConvert
			Case "readonly": Return @FReadOnly
			Case "scrollbars": Return @FScrollBars
			Case "selstart": Return @FSelStart
			Case "sellength": Return @FSelLength
			Case "selend": Return @FSelEnd
			Case "seltext": Return FSelText
			Case "tabindex": Return @FTabIndex
			Case "topline": Return @FTopLine
			Case "wantreturn": Return @FWantReturn
			Case "wanttab": Return @FWantTab
			Case "wordwraps": Return @FWordWraps
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function TextBox.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "alignment": Alignment = *Cast(AlignmentConstants Ptr, Value)
				Case "borderstyle": BorderStyle = *Cast(BorderStyles Ptr, Value)
				Case "caretpos": CaretPos = *Cast(My.Sys.Drawing.Point Ptr, Value)
				Case "charcase": CharCase = *Cast(CharCases Ptr, Value)
				Case "ctl3d": Ctl3D = QBoolean(Value)
				Case "hideselection": HideSelection = QBoolean(Value)
				Case "maskchar": MaskChar = QWString(Value)
				Case "masked": Masked = QBoolean(Value)
				Case "maxlength": MaxLength = QInteger(Value)
				Case "modified": Modified = QBoolean(Value)
				Case "multiline": Multiline = QBoolean(Value)
				Case "numbersonly": NumbersOnly = QBoolean(Value)
				Case "oemconvert": OEMConvert = QBoolean(Value)
				Case "readonly": ReadOnly = QBoolean(Value)
				Case "scrollbars": ScrollBars = *Cast(ScrollBarsType Ptr, Value)
				Case "selstart": SelStart = QInteger(Value)
				Case "sellength": SelLength = QInteger(Value)
				Case "selend": SelEnd = QInteger(Value)
				Case "seltext": SelText = QWString(Value)
				Case "tabindex": TabIndex = QInteger(Value)
				Case "topline": TopLine = QInteger(Value)
				Case "wantreturn": WantReturn = QBoolean(Value)
				Case "wanttab": WantTab = QBoolean(Value)
				Case "wordwraps": WordWraps = QBoolean(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Property TextBox.Alignment As AlignmentConstants
		Return FAlignment
	End Property
	
	Private Property TextBox.Alignment(Value As AlignmentConstants)
		If Value <> FAlignment Then
			FAlignment = Value
			#ifdef __USE_GTK__
				Select Case Value
				Case taLeft:
					gtk_entry_set_alignment(gtk_entry(WidgetEntry), 0.0)
					gtk_text_view_set_justification(gtk_text_view(WidgetTextView), GTK_JUSTIFY_LEFT)
				Case taCenter: 
					gtk_entry_set_alignment(gtk_entry(WidgetEntry), 0.5)
					gtk_text_view_set_justification(gtk_text_view(WidgetTextView), GTK_JUSTIFY_CENTER)
				Case taRight:
					gtk_entry_set_alignment(gtk_entry(WidgetEntry), 1.0)
					gtk_text_view_set_justification(gtk_text_view(WidgetTextView), GTK_JUSTIFY_RIGHT)
				End Select
			#elseif defined(__USE_WINAPI__)
				ChangeStyle ES_LEFT, False
				ChangeStyle ES_CENTER, False
				ChangeStyle ES_RIGHT, False
				Select Case Value
				Case taLeft: ChangeStyle ES_LEFT, True
				Case taCenter: ChangeStyle ES_CENTER, True
				Case taRight: ChangeStyle ES_RIGHT, True
				End Select
				RecreateWnd
			#endif
		End If
	End Property
	
	Private Property TextBox.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property TextBox.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property TextBox.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property TextBox.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Sub TextBox.ScrollToCaret()
		#ifdef __USE_GTK__
			If gtk_is_text_view(widget) Then
				gtk_text_view_scroll_to_mark(gtk_text_view(widget), gtk_text_buffer_get_insert(gtk_text_view_get_buffer(gtk_text_view(widget))), 0.0, True, 0.5, 0.5)
			End If
		#elseif defined(__USE_WINAPI__)
			Perform EM_SCROLLCARET, 0, 0
		#endif
	End Sub
	
	Private Property TextBox.LeftMargin() As Integer
		#ifdef __USE_GTK__
			If gtk_is_text_view(widget) Then
				FLeftMargin = gtk_text_view_get_left_margin(gtk_text_view(widget))
			End If
		#elseif defined(__USE_WINAPI__)
			If FHandle Then
				Dim As DWORD Result = SendMessage(FHandle, EM_GETMARGINS, 0, 0)
				FLeftMargin = LoWord(Result)
			End If
		#endif
		Return FLeftMargin
	End Property
	
	Private Property TextBox.LeftMargin(Value As Integer)
		FLeftMargin = Value
		#ifdef __USE_GTK__
			If gtk_is_text_view(widget) Then
				gtk_text_view_set_left_margin(gtk_text_view(widget), Value)
			End If
		#elseif defined(__USE_WINAPI__)
			If FHandle Then
				SendMessage(FHandle, EM_SETMARGINS, EC_LEFTMARGIN, MakeWord(ScaleX(FLeftMargin), ScaleX(FRightMargin)))
			End If
		#endif
	End Property
	
	Private Property TextBox.RightMargin() As Integer
		#ifdef __USE_GTK__
			If gtk_is_text_view(widget) Then
				FRightMargin = gtk_text_view_get_right_margin(gtk_text_view(widget))
			End If
		#elseif defined(__USE_WINAPI__)
			If FHandle Then
				Dim As DWORD Result = SendMessage(FHandle, EM_GETMARGINS, 0, 0)
				FRightMargin = HiWord(Result)
			End If
		#endif
		Return FRightMargin
	End Property
	
	Private Property TextBox.RightMargin(Value As Integer)
		FRightMargin = Value
		#ifdef __USE_GTK__
			If GTK_IS_TEXT_VIEW(widget) Then
				gtk_text_view_set_right_margin(GTK_TEXT_VIEW(widget), Value)
			End If
		#elseif defined(__USE_WINAPI__)
			If FHandle Then
				SendMessage(FHandle, EM_SETMARGINS, EC_RIGHTMARGIN, MAKEWORD(ScaleX(FLeftMargin), ScaleX(FRightMargin)))
			End If
		#endif
	End Property
	
	Private Property TextBox.WantReturn() As Boolean
		#ifdef __USE_WINAPI__
			FWantReturn = StyleExists(ES_WANTRETURN)
		#endif
		Return FWantReturn
	End Property
	
	Private Property TextBox.WantReturn(Value As Boolean)
		FWantReturn = Value
		#ifdef __USE_WINAPI__
			ChangeStyle ES_WANTRETURN, Value
		#endif
	End Property
	
	Private Property TextBox.WantTab() As Boolean
		Return FWantTab
	End Property
	
	Private Property TextBox.WantTab(Value As Boolean)
		FWantTab = Value
		#ifdef __USE_GTK__
			If GTK_IS_TEXT_VIEW(widget) Then
				gtk_text_view_set_accepts_tab(GTK_TEXT_VIEW(widget), Value)
			End If
		#endif
	End Property
	
	Private Property TextBox.Multiline() As Boolean
		Return FMultiline
	End Property
	
	Private Property TextBox.Multiline(Value As Boolean)
		FMultiline = Value
		#ifdef __USE_GTK__
			ChangeWidget
		#elseif defined(__USE_WINAPI__)
			If FMultiline Then
				Base.Style = Base.Style Or ES_MULTILINE Or ES_WANTRETURN
			Else
				Base.Style = Base.Style And Not ES_MULTILINE And Not ES_WANTRETURN
			End If
			RecreateWnd
		#endif
	End Property
	
	Private Sub TextBox.AddLine(ByRef wsLine As WString)
		InsertLine(LinesCount - 1, wsLine)
	End Sub
	
	#ifndef TextBox_InsertLine_Off
		Private Sub TextBox.InsertLine(Index As Integer, ByRef wsLine As WString)
			Dim As Integer iStart, LineLen
			#ifdef __USE_GTK__
				If GTK_IS_TEXT_VIEW(widget) Then
					Dim As GtkTextIter _startline
					gtk_text_buffer_get_iter_at_line(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_startline, Index)
					gtk_text_buffer_insert(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_startline, ToUtf8(wsLine & Chr(13) & Chr(10)), -1)
				End If
			#elseif defined(__USE_WINAPI__)
				Dim As WString Ptr sLine = _CAllocate(MaxLength * SizeOf(WString))
				If Index >= 0 Then
					iStart = SendMessage(FHandle, EM_LINEINDEX, Index, 0)
					If iStart >= 0 Then
						*sLine = wsLine + WChr(13) & WChr(10)
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
	#endif
	
	Private Sub TextBox.RemoveLine(Index As Integer)
		Const Empty = ""
		Dim As Integer iStart, iEnd
		#ifdef __USE_GTK__
			If GTK_IS_TEXT_VIEW(widget) Then
				Dim As GtkTextIter _startline, _endline
				gtk_text_buffer_get_iter_at_line(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_startline, Index)
				gtk_text_buffer_get_iter_at_line(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_endline, Index + 1)
				gtk_text_buffer_delete(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_startline, @_endline)
			End If
		#elseif defined(__USE_WINAPI__)
			iStart = SendMessage(FHandle, EM_LINEINDEX, Index, 0)
			If iStart >= 0 Then
				iEnd = SendMessage(FHandle, EM_LINEINDEX, Index + 1, 0)
				If iEnd < 0 Then iEnd = iStart + SendMessage(FHandle, EM_LINELENGTH, iStart, 0)
				SendMessage(FHandle, EM_SETSEL, iStart, iEnd)
				SendMessage(FHandle, EM_REPLACESEL, 0, CInt(StrPtr(Empty)))
			End If
		#endif
	End Sub
	
	Private Property TextBox.Text ByRef As WString
		#ifdef __USE_GTK__
			If GTK_IS_WIDGET(widget) Then
				If GTK_IS_TEXT_VIEW(widget) Then
					Dim As GtkTextBuffer Ptr buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget))
					Dim As GtkTextIter _start, _end
					gtk_text_buffer_get_bounds(buffer, @_start, @_end)
					FText = WStr(*gtk_text_buffer_get_text(buffer, @_start, @_end, True))
				Else
					#ifdef __USE_GTK4__
						FText = WStr(*gtk_entry_buffer_get_text(gtk_entry_get_buffer(GTK_ENTRY(widget))))
					#else
						FText = WStr(*gtk_entry_get_text(GTK_ENTRY(widget)))
					#endif
				EndIf
			End If
			Return *FText.vptr
		#elseif defined(__USE_JNI__)
			If FHandle Then
				Dim As jobject CharSequence = CallObjectMethod(FHandle, "android/widget/EditText", "getText", "()Ljava/lang/CharSequence;")
				Dim As jclass cCharSequence = (*env)->FindClass(env, "java/lang/CharSequence")
				Dim As jmethodID mLength = (*env)->GetMethodID(env, cCharSequence, "length", "()I")
				Dim As jmethodID mCharAt = (*env)->GetMethodID(env, cCharSequence, "charAt", "(I)C")
				Dim As Integer length = (*env)->CallIntMethod(env, CharSequence, mLength)
				FText = ""
				FText.Resize length
				For i As Integer = 0 To length - 1
				    FText.vptr[i] = (*env)->CallCharMethod(env, CharSequence, mCharAt, i)
				Next
				FText.vptr[length] = 0
			End If
			Return *FText.vptr
		#elseif defined(__USE_WASM__)
			Dim ptr_ As ZString Ptr = GetStringValue(@This)
			FText = *ptr_
			FreePtr(ptr_)
			Return *FText.vptr
		#else
			Return Base.Text
		#endif
	End Property
	
	Private Property TextBox.Text(ByRef Value As WString)
		Base.Text = Value
		#ifdef __USE_GTK__
			If GTK_IS_TEXT_VIEW(widget) Then
				Dim As GtkTextBuffer Ptr buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget))
				If Value = "" Then
					gtk_text_buffer_set_text(buffer, !"\0", -1)
				Else
					gtk_text_buffer_set_text(buffer, ToUtf8(Value), -1)
				End If
			Else
				If Value = "" Then
					#ifdef __USE_GTK4__
						gtk_entry_buffer_set_text(gtk_entry_get_buffer(GTK_ENTRY(widget)), !"\0", -1)
					#else
						gtk_entry_set_text(GTK_ENTRY(widget), !"\0")
					#endif
				Else
					#ifdef __USE_GTK4__
						gtk_entry_buffer_set_text(gtk_entry_get_buffer(GTK_ENTRY(widget)), ToUtf8(Value), -1)
					#else
						gtk_entry_set_text(GTK_ENTRY(widget), ToUtf8(Value))
					#endif
				End If
			EndIf
		#elseif defined(__USE_JNI__)
			If FHandle Then
				(*env)->CallVoidMethod(env, FHandle, GetMethodID("android/widget/EditText", "setText", "(Ljava/lang/CharSequence;)V"), (*env)->NewStringUTF(env, ToUtf8(FText)))
			End If
		#elseif defined(__USE_WASM__)
			If FHandle Then
				SetStringValue(@This, Value)
			End If
		#endif
	End Property
	
	Private Function TextBox.GetTextLength() As Integer
		#ifdef __USE_GTK__
			If FMultiline Then
				Dim As GtkTextBuffer Ptr buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget))
				Return gtk_text_buffer_get_char_count(buffer)
			Else
				Return gtk_entry_get_text_length(GTK_ENTRY(widget))
			End If
		#else
			Return Base.GetTextLength
		#endif
	End Function
	
	Private Property TextBox.BorderStyle As BorderStyles
		Return FBorderStyle
	End Property
	
	Private Property TextBox.BorderStyle(Value As BorderStyles)
		FBorderStyle = Value
		#ifdef __USE_GTK__
			If GTK_IS_TEXT_VIEW(widget) Then
				If FBorderStyle Then
					gtk_scrolled_window_set_shadow_type(GTK_SCROLLED_WINDOW(scrolledwidget), GTK_SHADOW_OUT)
				Else
					gtk_scrolled_window_set_shadow_type(GTK_SCROLLED_WINDOW(scrolledwidget), GTK_SHADOW_NONE)
				End If
			End If
		#elseif defined(__USE_WINAPI__)
			If FBorderStyle Then
				'Base.Style = Base.Style Or WS_BORDER
				Base.ExStyle = WS_EX_CLIENTEDGE
			Else
				'Base.Style = Base.Style And Not WS_BORDER
				Base.ExStyle = 0
			End If
		#endif
	End Property
	
	Private Property TextBox.ReadOnly As Boolean
		Return FReadOnly
	End Property
	
	Private Property TextBox.ReadOnly(Value As Boolean)
		FReadOnly = Value
		#ifdef __USE_GTK__
			gtk_text_view_set_editable(GTK_TEXT_VIEW(WidgetTextView), Not Value)
			gtk_editable_set_editable(GTK_EDITABLE(WidgetEntry), Not Value)
		#elseif defined(__USE_WINAPI__)
			If Handle Then Perform(EM_SETREADONLY, FReadOnly, 0)
		#endif
	End Property
	
	Private Property TextBox.Ctl3D As Boolean
		Return FCtl3D
	End Property
	
	Private Property TextBox.Ctl3D(Value As Boolean)
		If Value <> FCtl3D Then
			FCtl3D = Value
			RecreateWnd
		End If
	End Property
	
	Private Property TextBox.HideSelection As Boolean
		Return FHideSelection
	End Property
	
	Private Property TextBox.HideSelection(Value As Boolean)
		FHideSelection = Value
		#ifdef __USE_WINAPI__
			If Not FHideSelection Then Base.Style = Base.Style Or ES_NOHIDESEL Else Base.Style = Base.Style And Not ES_NOHIDESEL
		#endif
	End Property
	
	Private Property TextBox.OEMConvert As Boolean
		Return FOEMConvert
	End Property
	
	Private Property TextBox.OEMConvert(Value As Boolean)
		If Value <> FOEMConvert Then
			FOEMConvert = Value
			RecreateWnd
		End If
	End Property
	
	Private Property TextBox.CharCase As CharCases
		Return FCharCase
	End Property
	
	Private Property TextBox.CharCase(Value As CharCases)
		If FCharCase <> Value Then
			FCharCase = Value
			#ifdef __USE_GTK__
				#ifdef __USE_GTK3__
					Select Case FCharCase
					Case ecNone: gtk_entry_set_input_hints(GTK_ENTRY(WidgetEntry), GTK_INPUT_HINT_NONE): gtk_text_view_set_input_hints(GTK_TEXT_VIEW(WidgetTextView), GTK_INPUT_HINT_NONE)
					Case ecLower: gtk_entry_set_input_hints(GTK_ENTRY(WidgetEntry), GTK_INPUT_HINT_LOWERCASE): gtk_text_view_set_input_hints(GTK_TEXT_VIEW(WidgetTextView), GTK_INPUT_HINT_LOWERCASE)
					Case ecUpper: gtk_entry_set_input_hints(GTK_ENTRY(WidgetEntry), GTK_INPUT_HINT_UPPERCASE_CHARS): gtk_text_view_set_input_hints(GTK_TEXT_VIEW(WidgetTextView), GTK_INPUT_HINT_UPPERCASE_CHARS)
					End Select
				#endif
			#elseif defined(__USE_WINAPI__)
				ChangeStyle(ES_LOWERCASE, False)
				ChangeStyle(ES_UPPERCASE, False)
				Select Case FCharCase
				Case ecNone
				Case ecLower: ChangeStyle(ES_LOWERCASE, True)
				Case ecUpper: ChangeStyle(ES_UPPERCASE, True)
				End Select
			#endif
		End If
	End Property
	
	Private Property TextBox.Masked As Boolean
		Return FMasked
	End Property
	
	Private Property TextBox.Masked(Value As Boolean)
		FMasked = Value
		#ifdef __USE_GTK__
			If GTK_IS_ENTRY(widget) Then
				gtk_entry_set_visibility(GTK_ENTRY(widget), Not Value)
			End If
		#elseif defined(__USE_WINAPI__)
			If Handle Then
				If FMasked Then
					If WGet(FMaskChar) = "" Then
						Perform(EM_SETPASSWORDCHAR, Asc("*"), 0)
					Else
						Perform(EM_SETPASSWORDCHAR, Asc(*FMaskChar), 0)
					End If
				Else
					Perform(EM_SETPASSWORDCHAR, 0, 0)
				End If
			End If
		#endif
	End Property
	
	Private Property TextBox.MaskChar ByRef As WString
		Return WGet(FMaskChar)
	End Property
	
	Private Property TextBox.MaskChar(ByRef Value As WString)
		WLet(FMaskChar, Value)
		#ifdef __USE_GTK__
			If GTK_IS_ENTRY(widget) Then
				gtk_entry_set_invisible_char(GTK_ENTRY(widget), Asc(Value))
			End If
		#elseif defined(__USE_WINAPI__)
			If Handle Then Perform(EM_SETPASSWORDCHAR, Asc(Value), 0)
		#endif
	End Property
	
	Private Property TextBox.NumbersOnly As Boolean
		Return FNumbersOnly
	End Property
	
	Private Property TextBox.NumbersOnly(Value As Boolean)
		FNumbersOnly = Value
		#ifdef __USE_GTK__
			
		#elseif defined(__USE_WINAPI__)
			ChangeStyle ES_NUMBER, Value
		#endif
	End Property
	
	Private Property TextBox.TopLine As Integer
		#ifdef __USE_GTK__
			If GTK_IS_TEXT_VIEW(widget) Then
				For i As Integer = 0 To LinesCount - 1
					Dim As GtkTextIter _startline
					gtk_text_buffer_get_iter_at_line(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_startline, i)
					If gtk_text_view_starts_display_line(GTK_TEXT_VIEW(widget), @_startline) Then
						Return i
					End If
				Next
			End If
		#elseif defined(__USE_WINAPI__)
			If FHandle Then FTopLine = Perform(EM_GETFIRSTVISIBLELINE, 0, 0)
		#endif
		Return FTopLine
	End Property
	
	Private Property TextBox.TopLine(Value As Integer)
		FTopLine = Value
		#ifdef __USE_GTK__
			If GTK_IS_TEXT_VIEW(widget) Then
				Dim As GtkTextIter _topline
				gtk_text_buffer_get_iter_at_line(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_topline, Value)
				gtk_text_view_forward_display_line(GTK_TEXT_VIEW(widget), @_topline)
			End If
		#elseif defined(__USE_WINAPI__)
			If FHandle Then Perform(10012, FTopLine, 0)
		#endif
	End Property
	
	Private Sub TextBox.InputFilter(ByRef Value As WString)
		FInputFilter = _Reallocate(FInputFilter, (Len(Value) + 1) * SizeOf(WString))
		*FInputFilter = Value
	End Sub
	
	Private Sub TextBox.LoadFromFile(ByRef File As WString)
		Dim Result As Integer
		Dim Fn As Integer = FreeFile_
		Result = Open(File For Input Encoding "utf-32" As #Fn)
		If Result <> 0 Then Result = Open(File For Input Encoding "utf-16" As #Fn)
		If Result <> 0 Then Result = Open(File For Input Encoding "utf-8" As #Fn)
		If Result <> 0 Then Result = Open(File For Input As #Fn)
		If Result = 0 Then
			FText = WInput(LOF(Fn), #Fn)
			#ifdef __USE_GTK__
				If GTK_IS_TEXT_VIEW(widget) Then
					Dim As GtkTextBuffer Ptr buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget))
					If FText = "" Then
						gtk_text_buffer_set_text(buffer, !"\0", -1)
					Else
						gtk_text_buffer_set_text(buffer, ToUtf8(FText), -1)
					End If
				Else
					If FText = "" Then
						gtk_entry_set_text(GTK_ENTRY(widget), !"\0")
					Else
						gtk_entry_set_text(GTK_ENTRY(widget), ToUtf8(FText))
					End If
				EndIf
			#elseif defined(__USE_WINAPI__)
				If FHandle Then SetWindowText(FHandle, FText.vptr)
			#endif
		End If
		CloseFile_(Fn)
	End Sub
	
	Private Sub TextBox.SaveToFile(ByRef FILE As WString)
		Dim As Integer Fn = FreeFile_
		If Open(FILE For Output Encoding "utf-8" As #Fn) = 0 Then
			Print #Fn, Text;
		End If
		CloseFile_(Fn)
	End Sub
	
	Private Function TextBox.GetLineLength(Index As Integer = -1) As Integer
		#ifdef __USE_GTK__
			If GTK_IS_TEXT_VIEW(widget) Then
				Dim As GtkTextIter _startline, _endline
				gtk_text_buffer_get_iter_at_line(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_startline, Index)
				gtk_text_buffer_get_iter_at_line(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_endline, Index + 1)
				Return Len(WStr(*gtk_text_buffer_get_text(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_startline, @_endline, True)))
			End If
		#elseif defined(__USE_WINAPI__)
			If FHandle Then
				Dim As Integer CharIndex = SendMessage(FHandle, EM_LINEINDEX, Index, 0)
				Return SendMessage(FHandle, EM_LINELENGTH, CharIndex, 0)
			End If
		#endif
		Return -1
	End Function
	
	Private Function TextBox.GetLineFromCharIndex(Index As Integer = -1) As Integer
		#ifdef __USE_GTK__
			If GTK_IS_TEXT_VIEW(widget) Then
				For i As Integer = 0 To LinesCount - 1
					Dim As GtkTextIter _startline, _endline
					gtk_text_buffer_get_iter_at_line(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_startline, i)
					gtk_text_buffer_get_iter_at_line(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_endline, i + 1)
					If Index >= gtk_text_iter_get_offset(@_startline) AndAlso Index <= gtk_text_iter_get_offset(@_endline) Then
						Return i
					End If
				Next
			End If
		#elseif defined(__USE_WINAPI__)
			If FHandle Then
				Return SendMessage(FHandle, EM_LINEFROMCHAR, Index, 0)
			End If
		#endif
		Return -1
	End Function
	
	Private Function TextBox.GetCharIndexFromLine(Index As Integer) As Integer
		#ifdef __USE_GTK__
			If GTK_IS_TEXT_VIEW(widget) Then
				Dim As GtkTextIter _startline
				gtk_text_buffer_get_iter_at_line(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_startline, Index)
				Return gtk_text_iter_get_offset(@_startline)
			Else
				Return 0
			End If
		#elseif defined(__USE_WINAPI__)
			If FHandle Then
				Return SendMessage(FHandle, EM_LINEINDEX, Index, 0)
			End If
		#endif
		Return -1
	End Function
	
	Private Property TextBox.Lines(Index As Integer) ByRef As WString
		#ifdef __USE_GTK__
			If GTK_IS_TEXT_VIEW(widget) Then
				Dim As GtkTextIter _startline, _endline
				gtk_text_buffer_get_iter_at_line(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_startline, Index)
				gtk_text_buffer_get_iter_at_line(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_endline, Index + 1)
				WLet(FLine, WStr(*gtk_text_buffer_get_text(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_startline, @_endline, True)))
				Return *FLine
			ElseIf Index = 0 Then
				Return Text
			End If
		#elseif defined(__USE_WINAPI__)
			If FHandle Then
				Dim As Integer lThisChar = SendMessage(FHandle, EM_LINEINDEX, Index, 0)
				Dim As Integer lChar = SendMessage(FHandle, EM_LINELENGTH, lThisChar, 0)
				WLet(FLine, WSpace(lChar))
				Mid(*FLine, 1, 1) = WChr(lChar And &HFF)
				Mid(*FLine, 2, 1) = WChr(lChar \ &H100)
				SendMessage(FHandle, EM_GETLINE, Index, CInt(FLine))
				Return *FLine
			End If
		#endif
		Return ""
	End Property
	
	Private Property TextBox.Lines(Index As Integer, ByRef Value As WString)
		#ifdef __USE_GTK__
			If GTK_IS_TEXT_VIEW(widget) Then
				Dim As GtkTextIter _startline, _endline
				gtk_text_buffer_get_iter_at_line(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_startline, Index)
				gtk_text_buffer_get_iter_at_line(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_endline, Index + 1)
				gtk_text_buffer_delete(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_startline, @_endline)
				gtk_text_buffer_insert(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_startline, ToUtf8(Value & Chr(13) & Chr(10)), -1)
			ElseIf Index = 0 Then
				Text = Value
			End If
		#elseif defined(__USE_WINAPI__)
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
	
	Private Sub TextBox.GetSel(ByRef iSelStart As Integer, ByRef iSelEnd As Integer)
		#ifdef __USE_GTK__
			If widget Then
				If GTK_IS_TEXT_VIEW(widget) Then
					Dim As GtkTextIter _start, _end
					Dim As GtkTextBuffer Ptr buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget))
					gtk_text_buffer_get_selection_bounds(buffer, @_start, @_end)
					iSelStart = gtk_text_iter_get_offset(@_start)
					iSelEnd = gtk_text_iter_get_offset(@_end)
				Else
					gtk_editable_get_selection_bounds(GTK_EDITABLE(widget), Cast(gint Ptr, @iSelStart), Cast(gint Ptr, @iSelEnd))
				End If
			End If
		#elseif defined(__USE_WINAPI__)
			If FHandle Then
				SendMessage(FHandle, EM_GETSEL, CInt(@iSelStart), CInt(@iSelEnd))
			End If
		#endif
	End Sub
	
	Private Sub TextBox.GetSel(ByRef iSelStartRow As Integer, ByRef iSelStartCol As Integer, ByRef iSelEndRow As Integer, ByRef iSelEndCol As Integer)
		#ifdef __USE_GTK__
			If GTK_IS_TEXT_VIEW(widget) Then
				Dim As GtkTextIter _start, _end, _startline, _endline
				gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, @_end)
				Dim As Integer StartCharIndex = gtk_text_iter_get_offset(@_start)
				Dim As Integer EndCharIndex = gtk_text_iter_get_offset(@_end)
				iSelStartRow = GetLineFromCharIndex(StartCharIndex)
				iSelEndRow = GetLineFromCharIndex(EndCharIndex)
				gtk_text_buffer_get_iter_at_line(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_startline, iSelStartRow)
				gtk_text_buffer_get_iter_at_line(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_endline, iSelEndRow)
				iSelStartCol = StartCharIndex - gtk_text_iter_get_offset(@_startline)
				iSelEndCol = EndCharIndex - gtk_text_iter_get_offset(@_endline)
			Else
				gtk_editable_get_selection_bounds(GTK_EDITABLE(widget), Cast(gint Ptr, @iSelStartCol), Cast(gint Ptr, @iSelEndCol))
				iSelStartRow = 0
				iSelEndRow = 0
			End If
		#elseif defined(__USE_WINAPI__)
			If FHandle Then
				Dim As Integer iSelStart, iSelEnd
				SendMessage(FHandle, EM_GETSEL, CInt(@iSelStart), CInt(@iSelEnd))
				iSelStartRow = SendMessage(FHandle, EM_LINEFROMCHAR, iSelStart, 0)
				iSelStartCol = iSelStart - SendMessage(FHandle, EM_LINEINDEX, iSelStartRow, 0)
				iSelEndRow = SendMessage(FHandle, EM_LINEFROMCHAR, iSelEnd, 0)
				iSelEndCol = iSelEnd - SendMessage(FHandle, EM_LINEINDEX, iSelEndRow, 0)
			End If
		#endif
	End Sub
	
	Private Sub TextBox.SetSel(iSelStart As Integer, iSelEnd As Integer)
		#ifdef __USE_GTK__
			If GTK_IS_TEXT_VIEW(widget) Then
				Dim As GtkTextIter _start, _end
				Dim As GtkTextBuffer Ptr buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget))
				gtk_text_buffer_get_iter_at_offset(buffer, @_start, iSelStart)
				gtk_text_buffer_get_iter_at_offset(buffer, @_end, iSelEnd)
				gtk_text_buffer_select_range(buffer, @_start, @_end)
			Else
				gtk_editable_select_region(GTK_EDITABLE(widget), *Cast(gint Ptr, @iSelStart), *Cast(gint Ptr, @iSelEnd))
			End If
		#elseif defined(__USE_WINAPI__)
			If FHandle Then
				SendMessage(FHandle, EM_SETSEL, iSelStart, iSelEnd)
			Else
				FSelStart = iSelStart
				FSelEnd = iSelEnd
			End If
		#elseif defined(__USE_JNI__)
			If FHandle Then
				(*env)->CallVoidMethod(env, FHandle, GetMethodID(*FClassAncestor, "selSelection", "(II)V"), iSelStart, iSelEnd)
			Else
				FSelStart = iSelStart
				FSelEnd = iSelEnd
			End If
		#endif
	End Sub
	
	Private Sub TextBox.SetSel(iSelStartRow As Integer, iSelStartCol As Integer, iSelEndRow As Integer, iSelEndCol As Integer)
		#ifdef __USE_GTK__
			If GTK_IS_TEXT_VIEW(widget) Then
				Dim As GtkTextIter _start, _end, _startline, _endline
				gtk_text_buffer_get_iter_at_line(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_startline, iSelStartRow)
				gtk_text_buffer_get_iter_at_line(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_endline, iSelEndRow)
				gtk_text_buffer_get_iter_at_offset(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, gtk_text_iter_get_offset(@_startline) + iSelStartCol)
				gtk_text_buffer_get_iter_at_offset(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_end, gtk_text_iter_get_offset(@_endline) + iSelEndCol)
				gtk_text_buffer_select_range(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, @_end)
			ElseIf iSelStartRow = 0 Then
				gtk_editable_select_region(GTK_EDITABLE(widget), *Cast(gint Ptr, @iSelStartCol), *Cast(gint Ptr, @iSelEndCol))
			End If
		#elseif defined(__USE_WINAPI__)
			If FHandle Then
				Dim As Integer iSelStart, iSelEnd
				iSelStart = SendMessage(FHandle, EM_LINEINDEX, iSelStartRow, 0) + iSelStartCol
				iSelEnd = SendMessage(FHandle, EM_LINEINDEX, iSelEndRow, 0) + iSelEndCol
				SendMessage(FHandle, EM_SETSEL, iSelStart, iSelEnd)
			End If
		#endif
	End Sub
	
	#ifndef TextBox_LinesCount_Off
		Private Function TextBox.LinesCount As Integer
			#ifdef __USE_GTK__
				If GTK_IS_TEXT_VIEW(widget) Then
					If Text <> "" Then
						Return 1
					End If
				Else
					Return gtk_text_buffer_get_line_count(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)))
				End If
			#elseif defined(__USE_WINAPI__)
				If FHandle Then
					Return SendMessage(FHandle, EM_GETLINECOUNT, 0, 0)
				End If
			#endif
			Return 0
		End Function
	#endif
	
	Private Property TextBox.CaretPos As My.Sys.Drawing.Point
		Dim As Integer x, y
		#ifdef __USE_GTK__
			If GTK_IS_TEXT_VIEW(widget) Then
				Dim As GtkTextIter _start, _end, _startline
				gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, @_end)
				Dim As Integer CurCharIndex = gtk_text_iter_get_offset(@_start)
				Dim As Integer CurLineIndex = GetLineFromCharIndex(CurCharIndex)
				gtk_text_buffer_get_iter_at_line(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_startline, CurLineIndex)
				Return Type(CurCharIndex - gtk_text_iter_get_offset(@_startline), CurLineIndex)
			Else
				Return Type(gtk_editable_get_position(GTK_EDITABLE(widget)), 0)
			End If
		#elseif defined(__USE_WINAPI__)
			If FHandle Then
				x = HiWord(SendMessage(FHandle, EM_GETSEL, 0, 0))
				y = SendMessage(FHandle, EM_LINEFROMCHAR, x, 0)
				x = x - SendMessage(FHandle, EM_LINEINDEX, -1, 0)
				Return Type(x, y)
			End If
		#endif
		Return Type(0, 0)
	End Property
	
	Private Property TextBox.CaretPos(value As My.Sys.Drawing.Point)
	End Property
	
	Private Property TextBox.ScrollBars As ScrollBarsType
		Return FScrollBars
	End Property
	
	Private Property TextBox.ScrollBars(Value As ScrollBarsType)
		FScrollBars = Value
		#ifdef __USE_GTK__
			ChangeWidget
		#elseif defined(__USE_WINAPI__)
			Select Case FScrollBars
			Case 0
				This.Style = This.Style And Not (WS_HSCROLL Or WS_VSCROLL)
			Case 1
				This.Style = (This.Style And Not WS_HSCROLL) Or WS_VSCROLL
			Case 2
				This.Style = (This.Style And Not WS_VSCROLL) Or WS_HSCROLL
			Case 3
				This.Style = This.Style Or (WS_HSCROLL Or WS_VSCROLL)
			End Select
			RecreateWnd
		#endif
	End Property
	
	Private Property TextBox.WordWraps As Boolean
		Return FWordWraps
	End Property

	#ifdef __USE_GTK__
		Private Sub TextBox.ChangeWidget()
			Dim As GtkWidget Ptr Ctrlwidget = IIf(CInt(FMultiline) Or CInt(FWordWraps) Or CInt(FScrollBars), WidgetTextView, WidgetEntry)
			If widget = Ctrlwidget Then Exit Sub
			Dim As GtkTextBuffer Ptr buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(WidgetTextView))
			If CInt(FMultiline) Or CInt(FWordWraps) Or CInt(FScrollBars) Then
				widget = WidgetTextView
				scrolledwidget = WidgetScrolledWindow
				gtk_widget_hide(WidgetEntry)
				If CInt(gtk_widget_get_parent(scrolledwidget) = 0) AndAlso CInt(This.Parent) AndAlso CInt(This.Parent->layoutwidget) Then
					gtk_layout_put(GTK_LAYOUT(This.Parent->layoutwidget), scrolledwidget, FLeft, FTop)
				End If
				If scrolledwidget Then g_object_set_data(G_OBJECT(scrolledwidget), "@@@Control2", @This)
				If widget Then g_object_set_data(G_OBJECT(widget), "@@@Control2", @This)
				SetBounds(FLeft, FTop, FWidth, FHeight)
				#ifdef __USE_GTK4__
					gtk_text_buffer_set_text(buffer, *gtk_entry_buffer_get_text(gtk_entry_get_buffer(GTK_ENTRY(WidgetEntry))), -1)
				#else
					gtk_text_buffer_set_text(buffer, *gtk_entry_get_text(GTK_ENTRY(WidgetEntry)), -1)
				#endif
				gtk_widget_show_all(scrolledwidget)
			Else
				widget = WidgetEntry
				gtk_widget_hide(scrolledwidget)
				SetBounds(FLeft, FTop, FWidth, FHeight)
				Dim As GtkTextIter _start, _end
				gtk_text_buffer_get_bounds(buffer, @_start, @_end)
				#ifdef __USE_GTK4__
					gtk_entry_buffer_set_text(gtk_entry_get_buffer(GTK_ENTRY(widget)), *gtk_text_buffer_get_text(buffer, @_start, @_end, True), -1)
				#else
					gtk_entry_set_text(GTK_ENTRY(widget), *gtk_text_buffer_get_text(buffer, @_start, @_end, True))
				#endif
				gtk_widget_show(WidgetEntry)
				scrolledwidget = 0
			End If
		End Sub
	#endif
	
	Private Property TextBox.WordWraps(Value As Boolean)
		FWordWraps = Value
		#ifdef __USE_GTK__
			ChangeWidget
			If Value Then
				gtk_text_view_set_wrap_mode(GTK_TEXT_VIEW(widget), GTK_WRAP_WORD)
			Else
				gtk_text_view_set_wrap_mode(GTK_TEXT_VIEW(widget), GTK_WRAP_NONE)
			End If
		#elseif defined(__USE_WINAPI__)
			If Value Then
				This.Style = This.Style And Not ES_AUTOHSCROLL
			Else
				This.Style = This.Style Or ES_AUTOHSCROLL
			End If
			RecreateWnd
		#endif
	End Property
	
	Private Property TextBox.SelStart As Integer
		Dim As Integer LStart
		#ifdef __USE_GTK__
			If GTK_IS_TEXT_VIEW(widget) Then
				Dim As GtkTextIter _start, _end
				gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, @_end)
				FSelStart = gtk_text_iter_get_offset(@_start)
			Else
				FSelStart = gtk_editable_get_position(GTK_EDITABLE(widget))
			End If
		#elseif defined(__USE_WINAPI__)
			SendMessage(Handle, EM_GETSEL, CInt(@FSelStart), 0)
		#endif
		Return FSelStart
	End Property
	
	Private Property TextBox.SelStart(Value As Integer)
		FSelStart = Value
		#ifdef __USE_GTK__
			If GTK_IS_EDITABLE(widget) Then
				gtk_editable_set_position(GTK_EDITABLE(widget), Value)
			Else
				Dim As GtkTextIter _start
				gtk_text_buffer_get_iter_at_offset(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, Value)
				gtk_text_buffer_select_range(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, @_start)
			End If
		#elseif defined(__USE_WINAPI__)
			SendMessage(Handle, EM_SETSEL, Value, Value)
		#elseif defined(__USE_JNI__)
			SetSel Value, Value
		#endif
	End Property
	
	Private Property TextBox.SelLength As Integer
		Dim As Integer LStart,LEnd
		#ifdef __USE_GTK__
			If GTK_IS_EDITABLE(widget) Then
				gtk_editable_get_selection_bounds(GTK_EDITABLE(widget), Cast(gint Ptr, @LStart), Cast(gint Ptr, @LEnd))
			Else
				Dim As GtkTextIter _start, _end
				gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, @_end)
				LStart = gtk_text_iter_get_offset(@_start)
				LEnd = gtk_text_iter_get_offset(@_end)
			End If
		#elseif defined(__USE_WINAPI__)
			SendMessage(Handle, EM_GETSEL, CInt(@LStart), CInt(@LEnd))
		#endif
		FSelLength = LEnd - LStart
		Return FSelLength
	End Property
	
	Private Property TextBox.SelLength(Value As Integer)
		Dim As Integer LStart, LEnd, FEnd
		FSelLength = Value
		#ifdef __USE_GTK__
			If GTK_IS_EDITABLE(widget) Then
				gtk_editable_get_selection_bounds(GTK_EDITABLE(widget), Cast(gint Ptr, @LStart), Cast(gint Ptr, @LEnd))
				FEnd = LStart + Value
				gtk_editable_select_region(gtk_editable(widget), *Cast(gint Ptr, @LStart), *Cast(gint Ptr, @LEnd))
			Else
				Dim As GtkTextIter _start, _end, _endnew
				gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, @_end)
				LStart = gtk_text_iter_get_offset(@_start)
				LEnd = gtk_text_iter_get_offset(@_end)
				FEnd = LStart + Value
				gtk_text_buffer_get_iter_at_offset(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_endnew, FEnd)
				gtk_text_buffer_select_range(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, @_endnew)
			End If
		#elseif defined(__USE_WINAPI__)
			SendMessage(Handle, EM_GETSEL, CInt(@LStart), CInt(@LEnd))
			FEnd = LStart + Value
			SendMessage(Handle, EM_SETSEL, LStart, FEnd)
			SendMessage(Handle, EM_SCROLLCARET, 0,0)
		#endif
	End Property
	
	Private Property TextBox.SelEnd As Integer
		Dim As Integer LStart, LEnd
		#ifdef __USE_GTK__
			If GTK_IS_EDITABLE(widget) Then
				gtk_editable_get_selection_bounds(GTK_EDITABLE(widget), Cast(gint Ptr, @LStart), Cast(gint Ptr, @LEnd))
			Else
				Dim As GtkTextIter _start, _end
				gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, @_end)
				LEnd = gtk_text_iter_get_offset(@_end)
			End If
		#elseif defined(__USE_WINAPI__)
			SendMessage(Handle, EM_GETSEL, 0, CInt(@LEnd))
		#endif
		FSelEnd = LEnd
		Return FSelEnd
	End Property
	
	Private Property TextBox.SelEnd(Value As Integer)
		Dim As Integer LStart, LEnd, FEnd
		FSelEnd = Value
		#ifdef __USE_GTK__
			If GTK_IS_EDITABLE(widget) Then
				gtk_editable_get_selection_bounds(GTK_EDITABLE(widget), Cast(gint Ptr, @LStart), Cast(gint Ptr, @LEnd))
				gtk_editable_select_region(GTK_EDITABLE(widget), *Cast(gint Ptr, @LStart), *Cast(gint Ptr, @LEnd))
			Else
				Dim As GtkTextIter _start, _end, _endnew
				gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, @_end)
				gtk_text_buffer_get_iter_at_offset(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_endnew, FSelEnd)
				gtk_text_buffer_select_range(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, @_endnew)
			End If
		#elseif defined(__USE_WINAPI__)
			SendMessage(Handle, EM_GETSEL, CInt(@LStart), CInt(@LEnd))
			SendMessage(Handle, EM_SETSEL, LStart, FSelEnd)
			SendMessage(Handle, EM_SCROLLCARET, 0,0)
		#endif
	End Property
	
	Private Property TextBox.SelText ByRef As WString
		Dim As Integer LStart, LEnd
		#ifdef __USE_GTK__
			If GTK_IS_EDITABLE(widget) Then
				gtk_editable_get_selection_bounds(GTK_EDITABLE(widget), Cast(gint Ptr, @LStart), Cast(gint Ptr, @LEnd))
				WLet(FSelText, WStr(*gtk_editable_get_chars(GTK_EDITABLE(widget), LStart, FSelEnd)))
			Else
				Dim As GtkTextIter _start, _end
				gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, @_end)
				WLet(FSelText, WStr(*gtk_text_buffer_get_text(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, @_end, True)))
			End If
		#elseif defined(__USE_WINAPI__)
			If FHandle Then
				Dim As Integer LStart, LEnd
				SendMessage(FHandle, EM_GETSEL, CInt(@LStart), CInt(@LEnd))
				If LEnd - LStart <= 0 Then
					FSelText = _Reallocate(FSelText, SizeOf(WString))
					*FSelText = ""
				Else
					FSelText = _Reallocate(FSelText, (LEnd - LStart + 1 + 1) * SizeOf(WString))
					*FSelText = Mid(Text, LStart + 1, LEnd - LStart)
				End If
			End If
		#endif
		Return *FSelText
	End Property
	
	Private Property TextBox.SelText(ByRef Value As WString)
		FSelText = _Reallocate(FSelText, (Len(Value) + 1) * SizeOf(WString))
		*FSelText = Value
		#ifdef __USE_GTK__
			If GTK_IS_TEXT_VIEW(widget) Then
				Dim As GtkTextIter _start, _end
				gtk_text_buffer_insert_at_cursor(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), ToUtf8(Value), -1)
				gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, @_end)
				Dim As GtkTextMark Ptr ptextmark = gtk_text_buffer_create_mark(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), NULL, @_end, False)
				gtk_text_view_scroll_to_mark(GTK_TEXT_VIEW(widget), ptextmark, 0., False, 0., 0.)
			Else
				Dim As gint Pos1 = gtk_editable_get_position(GTK_EDITABLE(widget))
				gtk_editable_insert_text(GTK_EDITABLE(widget), ToUtf8(*FSelText), -1, @Pos1)
			EndIf
		#elseif defined(__USE_WINAPI__)
			SendMessage(FHandle, EM_REPLACESEL, 0, CInt(FSelText))
		#endif
	End Property
	
	Private Property TextBox.MaxLength As Integer
		Return FMaxLength
	End Property
	
	Private Property TextBox.MaxLength(Value As Integer)
		FMaxLength = Value
		#ifdef __USE_GTK__
			If GTK_IS_ENTRY(widget) Then
				gtk_entry_set_max_length(GTK_ENTRY(widget), Value)
			End If
		#elseif defined(__USE_WINAPI__)
			If Handle Then Perform(EM_LIMITTEXT, Value, 0)
		#endif
	End Property
	
	Private Property TextBox.Modified As Boolean
		#ifdef __USE_GTK__
			If GTK_IS_TEXT_VIEW(widget) Then
				FModified = gtk_text_buffer_get_modified(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)))
			End If
		#elseif defined(__USE_WINAPI__)
			If Handle Then
				FModified = (Perform(EM_GETMODIFY, 0, 0) <> 0)
			End If
		#endif
		Return FModified
	End Property
	
	Private Property TextBox.Modified(Value As Boolean)
		FModified = Value
		#ifdef __USE_GTK__
			If GTK_IS_TEXT_VIEW(widget) Then
				gtk_text_buffer_set_modified(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), FModified)
			End If
		#elseif defined(__USE_WINAPI__)
			If Handle Then
				Perform(EM_SETMODIFY, Cast(Byte, Value), 0)
			End If
		#endif
	End Property
	
	#ifdef __USE_WINAPI__
		Private Sub TextBox.WndProc(ByRef message As Message)
		End Sub
	#endif
	
	#ifndef __USE_GTK__
		Private Sub TextBox.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QTextBox(Sender.Child)
					#ifdef __USE_WASM__
						If .OnChange Then SetChangeEvent(.FHandle)
					#elseif defined(__USE_WINAPI__)
						If .FMaxLength = 0 Then 
							.Perform(EM_LIMITTEXT, -1, 0)
						Else
							.Perform(EM_LIMITTEXT, .FMaxLength, 0)
						End If
						If .ReadOnly Then .Perform(EM_SETREADONLY, True, 0)
						If .FMasked Then .Masked = True
						If .FSelStart <> 0 OrElse .FSelEnd <> 0 Then .SetSel .FSelStart, .FSelEnd
						'.MaxLength = .MaxLength
						'End If
					#endif
				End With
			End If
		End Sub
	#endif
	
	Private Sub TextBox.ProcessMessage(ByRef message As Message)
		#ifdef __USE_GTK__
			Dim As GdkEvent Ptr e = message.Event
			Select Case message.Event->type
			Case GDK_KEY_PRESS
				If FWantReturn = False AndAlso Asc(*e->key.string) = 13 Then
					message.Result = True 
				End If
			End Select
		#elseif defined(__USE_WINAPI__)
			Select Case message.Msg
			Case WM_PAINT, WM_MOUSELEAVE, WM_MOUSEMOVE
				If g_darkModeSupported AndAlso g_darkModeEnabled AndAlso (CBool(message.Msg <> WM_MOUSEMOVE) OrElse (CBool(message.Msg = WM_MOUSEMOVE) AndAlso FMouseInClient)) Then
					If Not FDarkMode Then
						FDarkMode = True
						Brush.Handle = hbrBkgnd
						SetWindowTheme(FHandle, "DarkMode_Explorer", nullptr)
						SendMessageW(FHandle, WM_THEMECHANGED, 0, 0)
						Repaint
					End If
					Dim As Any Ptr cp = GetClassProc(message.hWnd)
					If cp <> 0 Then
						message.Result = CallWindowProc(cp, message.hWnd, message.Msg, message.wParam, message.lParam)
					End If
					Dim As HDC Dc
					Dc = GetWindowDC(Handle)
					Dim As Rect r = Type( 0 )
					GetWindowRect(message.hWnd, @r)
					r.Right -= r.Left + 1
					r.Bottom -= r.Top + 1
					r.Left = 1
					r.Top = 1
					Dim As HPEN NewPen = CreatePen(PS_SOLID, 1, darkBkColor)
					Dim As HPEN PrevPen = SelectObject(Dc, NewPen)
					Dim As HPEN PrevBrush = SelectObject(Dc, GetStockObject(NULL_BRUSH))
					Rectangle Dc, r.Left, r.Top, r.Right, r.Bottom
					SelectObject(Dc, PrevPen)
					SelectObject(Dc, PrevBrush)
					ReleaseDC(Handle, Dc)
					DeleteObject NewPen
					message.Result = 0
					Return
				End If
			Case CM_CTLCOLOR
				Static As HDC Dc
				Dc = Cast(HDC, message.wParam)
				SetBkMode Dc, TRANSPARENT
				SetTextColor Dc, Font.Color
				SetBkColor Dc, This.BackColor
				SetBkMode Dc, OPAQUE
			Case CM_COMMAND
				Select Case message.wParamHi
				Case BN_CLICKED
					If OnClick Then OnClick(*Designer, This)
				Case EN_CHANGE
					If OnChange Then OnChange(*Designer, This)
				Case EN_UPDATE
					If OnUpdate Then OnUpdate(*Designer, This, This.Text)
				Case EN_KILLFOCUS
					If OnLostFocus Then OnLostFocus(*Designer, This)
				Case EN_SETFOCUS
					If OnGotFocus Then OnGotFocus(*Designer, This)
				Case EN_VSCROLL
					If OnScroll Then OnScroll(*Designer, This)
				Case EN_HSCROLL
					If OnScroll Then OnScroll(*Designer, This)
				End Select
				message.Result = 0
			Case WM_CHAR
				If Len(*FInputFilter)>0 Then
					If InStr(*FInputFilter,WChr(message.wParam))=0 And message.wParam>31 Then message.Result = -1
				End If
			Case WM_KEYUP
				'David Change
				'bShift = GetKeyState(VK_SHIFT) And 8000
				'bCtrl = GetKeyState(VK_CONTROL) And 8000
				If WantTab Then
					If message.wParam = VK_TAB Then
						SelText = !"\t"
					End If
				End If
				If message.wParam = VK_RETURN Then
					If OnActivate Then OnActivate(*Designer, This)
				End If
				If ParentHandle>0 Then
					Select Case message.wParam
					Case VK_RETURN, VK_ESCAPE, VK_DOWN, VK_UP, VK_LEFT, VK_RIGHT, VK_TAB
						PostMessage(ParentHandle, CM_COMMAND, message.wParam, 9999)
						'case VK_HOME,VK_END,VK_PRIOR,VK_NEXT,VK_INSERT,VK_DELETE,VK_BACK
						'case VK_MENU 'VK_CONTROL VK_SHIFT
						'print "TextBox VK_MENU: ",VK_MENU
						'case else
					End Select
				End If
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
				If OnCut Then OnCut(*Designer, This)
			Case WM_COPY
				If OnCopy Then OnCopy(*Designer, This)
			Case WM_PASTE
				Dim Action As Integer = 1
				If OnPaste Then OnPaste(*Designer, This, Action)
				Select Case Action
				Case 0: message.Result = -1
				Case 1: message.Result = 0
				End Select
			End Select
		#endif
		Base.ProcessMessage(message)
	End Sub
	
	Private Sub TextBox.Clear
		Text = ""
	End Sub
	
	Private Sub TextBox.ClearUndo
		#ifdef __USE_WINAPI__
			If FHandle Then Perform(EM_EMPTYUNDOBUFFER, 0, 0)
		#endif
	End Sub
	
	Private Function TextBox.CanUndo As Boolean
		#ifdef __USE_WINAPI__
			If FHandle Then
				Return (Perform(EM_CANUNDO, 0, 0) <> 0)
			Else
				Return 0
			End If
		#else
			Return 0
		#endif
	End Function
	
	Private Sub TextBox.Undo
		#ifdef __USE_WINAPI__
			If FHandle Then Perform(WM_UNDO, 0, 0)
		#endif
	End Sub
	
	Private Sub TextBox.PasteFromClipboard
		#ifdef __USE_GTK__
			If GTK_IS_EDITABLE(widget) Then
				gtk_editable_paste_clipboard(GTK_EDITABLE(widget))
			Else
				gtk_text_buffer_paste_clipboard(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), gtk_clipboard_get(GDK_SELECTION_CLIPBOARD), 0, True)
			End If
		#elseif defined(__USE_WINAPI__)
			If FHandle Then Perform(WM_PASTE, 0, 0)
		#endif
	End Sub
	
'	Sub TextBox.Delete
'		#ifdef __USE_GTK__
'			If gtk_is_editable(widget) Then
'				If gtk_editable_get_selection_bounds(gtk_editable(widget), 0, 0) Then
'					gtk_editable_delete_selection(gtk_editable(widget))
'				Else
'					Dim As Integer pos1 = gtk_editable_get_position(gtk_editable(widget))
'					gtk_editable_delete_text(gtk_editable(widget), pos1, pos1 + 1)
'				End If
'			Else
'				
'			End If
'		#else
'			If FHandle Then Perform(WM_KEYDOWN, WM_DELETE, 0)
'		#endif
'	End Sub
	
	Private Sub TextBox.CopyToClipboard
		#ifdef __USE_GTK__
			If GTK_IS_EDITABLE(widget) Then
				gtk_editable_copy_clipboard(GTK_EDITABLE(widget))
			Else
				gtk_text_buffer_copy_clipboard(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), gtk_clipboard_get(GDK_SELECTION_CLIPBOARD))
			End If
		#elseif defined(__USE_WINAPI__)
			If FHandle Then Perform(WM_COPY, 0, 0)
		#endif
	End Sub
	
	Private Sub TextBox.CutToClipboard
		#ifdef __USE_GTK__
			If GTK_IS_EDITABLE(widget) Then
				gtk_editable_cut_clipboard(GTK_EDITABLE(widget))
			Else
				gtk_text_buffer_cut_clipboard(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), gtk_clipboard_get(GDK_SELECTION_CLIPBOARD), True)
			End If
		#elseif defined(__USE_WINAPI__)
			If FHandle Then Perform(WM_CUT, 0, 0)
		#endif
	End Sub
	
	Private Sub TextBox.SelectAll
		#ifdef __USE_GTK__
			If GTK_IS_EDITABLE(widget) Then
				gtk_editable_select_region(GTK_EDITABLE(widget), 0, -1)
			Else
				Dim As GtkTextIter _start, _end
				gtk_text_buffer_get_iter_at_offset(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, 0)
				gtk_text_buffer_get_iter_at_offset(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_end, gtk_text_buffer_get_char_count(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget))))
				gtk_text_buffer_select_range(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, @_end)
			End If
		#elseif defined(__USE_WINAPI__)
			If FHandle Then Perform(EM_SETSEL, 0, -1)
		#elseif defined(__USE_JNI__)
			If FHandle Then (*env)->CallVoidMethod(env, FHandle, GetMethodID(*FClassAncestor, "selectAll", "()V"))
		#endif
	End Sub
	
	Private Operator TextBox.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	#ifdef __USE_GTK__
		Private Sub TextBox.Entry_Changed(entry As GtkEntry Ptr, user_data As Any Ptr)
			Dim As TextBox Ptr txt = user_data
			If txt AndAlso txt->OnChange Then txt->OnChange(*txt->Designer, *txt)
		End Sub
		
		Private Sub TextBox.TextBuffer_Changed(TextBuffer As GtkTextBuffer Ptr, user_data As Any Ptr)
			Dim As TextBox Ptr txt = user_data
			If txt Then
				If CInt(txt->FMaxLength > 0) AndAlso CInt(GTK_IS_TEXT_VIEW(txt->widget)) AndAlso CInt(Len(txt->Text) > txt->FMaxLength) Then
					txt->Text = .Left(txt->Text, txt->FMaxLength)
				Else
					If txt->OnChange Then txt->OnChange(*txt->Designer, *txt)
				End If
			End If
		End Sub
		
		Private Sub TextBox.Entry_Activate(entry As GtkEntry Ptr, user_data As Any Ptr)
			Dim As TextBox Ptr txt = user_data
			Dim As Control Ptr btn = txt->GetForm()->FDefaultButton
			If txt->OnActivate Then txt->OnActivate(*txt->Designer, *txt)
			If btn AndAlso btn->OnClick Then btn->OnClick(*btn->Designer, *btn)
		End Sub
		
		Private Function TextBox.Entry_FocusInEvent(widget As GtkWidget Ptr, Event As GdkEventFocus Ptr, user_data As Any Ptr) As Boolean
			Dim As TextBox Ptr txt = user_data
			If txt AndAlso txt->OnGotFocus Then txt->OnGotFocus(*txt->Designer, *txt)
			Return False
		End Function
		
		Private Function TextBox.Entry_FocusOutEvent(widget As GtkWidget Ptr, Event As GdkEventFocus Ptr, user_data As Any Ptr) As Boolean
			Dim As TextBox Ptr txt = user_data
			If txt AndAlso txt->OnLostFocus Then txt->OnLostFocus(*txt->Designer, *txt)
			Return False
		End Function
		
		Private Sub TextBox.Entry_CopyClipboard(widget As GtkWidget Ptr, user_data As Any Ptr)
			Dim As TextBox Ptr txt = user_data
			If txt AndAlso txt->OnCopy Then txt->OnCopy(*txt->Designer, *txt)
		End Sub
		
		Private Sub TextBox.Entry_CutClipboard(widget As GtkWidget Ptr, user_data As Any Ptr)
			Dim As TextBox Ptr txt = user_data
			If txt AndAlso txt->OnCut Then txt->OnCut(*txt->Designer, *txt)
		End Sub
		
		Private Sub TextBox.Entry_PasteClipboard(widget As GtkWidget Ptr, user_data As Any Ptr)
			Dim As TextBox Ptr txt = user_data
			Dim Action As Integer = 1
			If txt AndAlso txt->OnPaste Then txt->OnPaste(*txt->Designer, *txt, Action)
		End Sub
		
		Private Sub TextBox.TextView_SetScrollAdjustments(textview As GtkTextView Ptr, arg1 As GtkAdjustment Ptr, arg2 As GtkAdjustment Ptr, user_data As Any Ptr)
			Dim As TextBox Ptr txt = user_data
			If GTK_IS_WIDGET(arg1) Then g_signal_connect(arg1, "value-changed", G_CALLBACK(@Adjustment_ValueChanged), txt)
			If GTK_IS_WIDGET(arg2) Then g_signal_connect(arg2, "value-changed", G_CALLBACK(@Adjustment_ValueChanged), txt)
		End Sub
		
		Private Sub TextBox.Adjustment_ValueChanged(adjustment As GtkAdjustment Ptr, user_data As Any Ptr)
			Dim As TextBox Ptr txt = user_data
			If txt AndAlso txt->OnScroll Then txt->OnScroll(*txt->Designer, *txt)
		End Sub
		
		Private Sub TextBox.Preedit_Changed(self As GtkWidget Ptr, preedit As gchar Ptr, user_data As Any Ptr)
			Dim As TextBox Ptr txt = user_data
			If txt AndAlso txt->OnUpdate Then txt->OnUpdate(*txt->Designer, *txt, WStr(*preedit))
		End Sub
		
		Private Sub TextBox.Entry_InsertText(self As GtkEditable Ptr, new_text As gchar Ptr, new_text_length As gint, position As gint Ptr, user_data As Any Ptr)
			Dim As TextBox Ptr txt = user_data
			If txt->CharCase <> ecNone Then
				g_signal_handlers_block_by_func(G_OBJECT (self), G_CALLBACK(@Entry_InsertText), user_data)
				Dim As gint pos1 = gtk_editable_get_position(self)
				gtk_editable_insert_text(self, ToUtf8(IIf(txt->CharCase = ecLower, LCase(*new_text), UCase(*new_text))), new_text_length, position)
				g_signal_handlers_unblock_by_func(G_OBJECT (self), G_CALLBACK(@Entry_InsertText), user_data)
				g_signal_stop_emission_by_name(G_OBJECT(self), "insert_text")
			End If
		End Sub
	#endif
	
	Private Constructor TextBox
		'FSelText = CAllocate(0)
		#ifdef __USE_GTK__
			WidgetEntry = gtk_entry_new()
			WidgetTextView = gtk_text_view_new()
			gtk_entry_set_activates_default(GTK_ENTRY(WidgetEntry), True)
			gtk_entry_set_width_chars(GTK_ENTRY(WidgetEntry), 0)
			g_signal_connect(GTK_ENTRY(WidgetEntry), "activate", G_CALLBACK(@Entry_Activate), @This)
			g_signal_connect(GTK_ENTRY(WidgetEntry), "changed", G_CALLBACK(@Entry_Changed), @This)
			g_signal_connect(GTK_WIDGET(WidgetEntry), "focus-in-event", G_CALLBACK(@Entry_FocusInEvent), @This)
			g_signal_connect(GTK_WIDGET(WidgetEntry), "focus-out-event", G_CALLBACK(@Entry_FocusOutEvent), @This)
			g_signal_connect(GTK_WIDGET(WidgetEntry), "copy-clipboard", G_CALLBACK(@Entry_CopyClipboard), @This)
			g_signal_connect(GTK_WIDGET(WidgetEntry), "cut-clipboard", G_CALLBACK(@Entry_CutClipboard), @This)
			g_signal_connect(GTK_WIDGET(WidgetEntry), "paste-clipboard", G_CALLBACK(@Entry_PasteClipboard), @This)
			g_signal_connect(GTK_WIDGET(WidgetTextView), "copy-clipboard", G_CALLBACK(@Entry_CopyClipboard), @This)
			g_signal_connect(GTK_WIDGET(WidgetTextView), "cut-clipboard", G_CALLBACK(@Entry_CutClipboard), @This)
			g_signal_connect(GTK_WIDGET(WidgetTextView), "paste-clipboard", G_CALLBACK(@Entry_PasteClipboard), @This)
			#ifdef __USE_GTK3__
				g_signal_connect(gtk_scrollable_get_hadjustment(GTK_SCROLLABLE(WidgetTextView)), "value-changed", G_CALLBACK(@Adjustment_ValueChanged), @This)
				g_signal_connect(gtk_scrollable_get_vadjustment(gtk_scrollable(WidgetTextView)), "value-changed", G_CALLBACK(@Adjustment_ValueChanged), @This)
			#else
				g_signal_connect(GTK_WIDGET(WidgetTextView), "set-scroll-adjustments", G_CALLBACK(@TextView_SetScrollAdjustments), @This)
			#endif
			g_signal_connect(GTK_TEXT_VIEW(WidgetTextView), "preedit-changed", G_CALLBACK(@Preedit_Changed), @This)
			g_signal_connect(GTK_ENTRY(WidgetEntry), "preedit-changed", G_CALLBACK(@Preedit_Changed), @This)
			g_signal_connect(gtk_text_view_get_buffer(GTK_TEXT_VIEW(WidgetTextView)), "changed", G_CALLBACK(@TextBuffer_Changed), @This)
			#ifndef __USE_GTK3__
				g_signal_connect(GTK_EDITABLE(WidgetEntry), "insert-text", G_CALLBACK(@Entry_InsertText), @This)
			#endif
			WidgetScrolledWindow = gtk_scrolled_window_new(NULL, NULL)
			gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(WidgetScrolledWindow), GTK_POLICY_AUTOMATIC, GTK_POLICY_AUTOMATIC)
			gtk_scrolled_window_set_shadow_type(GTK_SCROLLED_WINDOW(WidgetScrolledWindow), GTK_SHADOW_OUT)
			gtk_container_add(GTK_CONTAINER(WidgetScrolledWindow), WidgetTextView)
			scrolledwidget = WidgetScrolledWindow
			widget = WidgetTextView
			This.RegisterClass "TextBox", @This
			scrolledwidget = 0
			widget = WidgetEntry
			This.RegisterClass "TextBox", @This
		#elseif defined(__USE_WINAPI__)
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
		FBorderStyle      = 1
		FHideSelection    = 1
		FCtl3D            = True
		WLet(FMaskChar, "")
		#ifdef __USE_WINAPI__
			FMaxLength          = 64000
		#endif
		FEnabled = True
		FTabIndex          = -1
		FWantReturn        = True
		FTabStop = True
		With This
			#ifdef __USE_WINAPI__
				.OnHandleIsAllocated = @HandleIsAllocated
				.ChildProc   = @WndProc
				.ExStyle     = WS_EX_CLIENTEDGE ' OR ES_AUTOHSCROLL OR ES_AUTOVSCROLL
				.Style       = WS_CHILD Or ES_AUTOHSCROLL Or WS_TABSTOP Or ES_WANTRETURN Or ACharCase(abs_(FCharCase)) Or AMaskStyle(abs_(FMasked)) Or AOEMConvert(abs_(FOEMConvert)) Or AHideSelection(abs_(FHideSelection))
				.BackColor        = GetSysColor(COLOR_WINDOW)
				FDefaultBackColor = .BackColor
				.DoubleBuffered = True
				.RegisterClass "TextBox", "Edit"
				WLet(FClassAncestor, "Edit")
			#elseif defined(__USE_JNI__)
				WLet(FClassAncestor, Replace(__FB_QUOTE__(Package), "_", "/") & "/mffEditText")
			#elseif defined(__USE_WASM__)
				WLet(FClassAncestor, "input")
				FType = "text"
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			WLet(FClassName, "TextBox")
			.Child       = @This
			.Width       = 121
			.Height      = ScaleY(Font.Size /72*96+6) '21
			'.Cursor      = LoadCursor(NULL, IDC_IBEAM)
		End With
	End Constructor
	
	Private Destructor TextBox
		If FSelText <> 0 Then _Deallocate( FSelText)
		If FLine <> 0 Then _Deallocate( FLine)
		WDeAllocate(FMaskChar)
	End Destructor
End Namespace

#ifdef __USE_JNI__
	Sub mffEditText_onTextChanged Alias AddToPackage(Package, mffEditText_onTextChanged) (ByVal env As JNIEnv Ptr, This_ As jobject, s As jobject, start As Integer, before As Integer, Count As Integer) Export
		Dim As Integer ID = CallIntMethod(This_, "android/view/View", "getId", "()I")
		Dim As My.Sys.Forms.TextBox Ptr txt = Handles.Item(ID)
		If txt Then
			If txt->OnChange Then txt->OnChange(*txt->Designer, *txt)
		End If
	End Sub
#elseif defined(__USE_WASM__)
	'Sub OnChange(Id As Integer) Export
	'	If Id > 0 Then
	'		Dim As My.Sys.Forms.TextBox Ptr txt = Cast(Any Ptr, Id)
	'		If txt AndAlso txt->OnChange Then txt->OnClick(*txt->Designer, *txt)
	'	End If
	'End Sub
#endif

