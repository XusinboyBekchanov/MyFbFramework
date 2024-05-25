'################################################################################
'#  RichTextBox.bi                                                              #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov(2018-2019)  Liu XiaLin                          #
'################################################################################

#include once "RichTextBox.bi"
#ifndef __USE_GTK__
	#include once "win/richole.bi"
#endif

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function RichTextBox.ReadProperty(ByRef PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "editstyle": Return @FEditStyle
			Case "selalignment": FSelIntVal = SelAlignment: Return @FSelIntVal
			Case "selbackcolor": FSelIntVal = SelBackColor: Return @FSelIntVal
			Case "selbold": FSelBoolVal = SelBold: Return @FSelBoolVal
			Case "selbullet": FSelBoolVal = SelBullet: Return @FSelBoolVal
			Case "selcharoffset": FSelIntVal = SelCharOffset: Return @FSelIntVal
			Case "selcharset": FSelIntVal = SelCharSet: Return @FSelIntVal
			Case "selcolor": FSelIntVal = SelColor: Return @FSelIntVal
			Case "selfontname": WLet(FSelWStrVal, SelFontName): Return FSelWStrVal
			Case "selfontsize": FSelIntVal = SelFontSize: Return @FSelIntVal
			Case "selindent": FSelIntVal = SelIndent: Return @FSelIntVal
			Case "selitalic": FSelBoolVal = SelItalic: Return @FSelBoolVal
			Case "selprotected": FSelBoolVal = SelProtected: Return @FSelBoolVal
			Case "selrightindent": FSelIntVal = SelRightIndent: Return @FSelIntVal
			Case "selhangingindent": FSelIntVal = SelHangingIndent: Return @FSelIntVal
			Case "seltabcount": FSelIntVal = SelTabCount: Return @FSelIntVal
			Case "selunderline": FSelBoolVal = SelUnderline: Return @FSelBoolVal
			Case "selstrikeout": FSelBoolVal = SelStrikeout: Return @FSelBoolVal
			Case "tabindex": Return @FTabIndex
			Case "textrtf": TextRTF: Return FTextRTF.vptr
			Case "zoom": Return @FZoom
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function RichTextBox.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
			If Value = 0 Then
				Select Case LCase(PropertyName)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			Else
				Select Case LCase(PropertyName)
				Case "editstyle": EditStyle = QBoolean(Value)
				Case "selalignment": SelAlignment = *Cast(AlignmentConstants Ptr, Value)
				Case "selbackcolor": SelBackColor = QInteger(Value)
				Case "selbold": SelBold = QBoolean(Value)
				Case "selbullet": SelBullet = QBoolean(Value)
				Case "selcharoffset": SelCharOffset = QInteger(Value)
				Case "selcharset": SelCharSet = QInteger(Value)
				Case "selcolor": SelColor = QInteger(Value)
				Case "selfontname": SelFontName = QWString(Value)
				Case "selfontsize": SelFontSize = QInteger(Value)
				Case "selindent": SelIndent = QInteger(Value)
				Case "selitalic": SelItalic = QBoolean(Value)
				Case "selprotected": SelProtected = QBoolean(Value)
				Case "selrightindent": SelRightIndent = QInteger(Value)
				Case "selhangingindent": SelHangingIndent = QInteger(Value)
				Case "seltabcount": SelTabCount = QInteger(Value)
				Case "selunderline": SelUnderline = QBoolean(Value)
				Case "selstrikeout": SelStrikeout = QBoolean(Value)
				Case "tabindex": TabIndex = QInteger(Value)
				Case "textrtf": TextRTF = QWString(Value)
				Case "zoom": Zoom = QInteger(Value)
				Case Else: Return Base.WriteProperty(PropertyName, Value)
				End Select
			End If
			Return True
		End Function
	#endif
	
	Private Property RichTextBox.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property RichTextBox.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property RichTextBox.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property RichTextBox.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Function RichTextBox.GetTextRange(cpMin As Integer, cpMax As Integer) ByRef As WString
		Dim cpMax2 As Integer = cpMax
		#ifdef __USE_GTK__
			Dim As GtkTextIter _start, _end
			gtk_text_buffer_get_iter_at_offset(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, cpMin)
			gtk_text_buffer_get_iter_at_offset(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_end, cpMax)
			WLet(FSelText, WStr(*gtk_text_buffer_get_text(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, @_end, True)))
		#else
			Dim txtrange As TEXTRANGE
			If cpMax2 = -1 Then cpMax2 = This.GetTextLength
			FTextRange = Cast(WString Ptr, _Reallocate(FTextRange, (cpMax - cpMin + 2) * SizeOf(WString)))
			txtrange.chrg.cpMin = cpMin
			txtrange.chrg.cpMax = cpMax
			txtrange.lpstrText = FTextRange
			SendMessage(FHandle, EM_GETTEXTRANGE, 0, CInt(@txtrange))
		#endif
		Return *FTextRange
	End Function
	
	Private Property RichTextBox.SelAlignment As AlignmentConstants
		#ifdef __USE_GTK__
			Dim As Integer iAlignment = GetIntProperty("justification")
			Return IIf(iAlignment = GTK_JUSTIFY_CENTER, AlignmentConstants.taCenter, IIf(iAlignment = GTK_JUSTIFY_RIGHT, AlignmentConstants.taRight, AlignmentConstants.taLeft))
		#else
			If FHandle Then
				Pf.dwMask = PFM_ALIGNMENT
				Perform(EM_GETPARAFORMAT, 0, Cast(LPARAM, @Pf))
				Return Pf.wAlignment - 1
			End If
		#endif
		Return 0
	End Property
	
	Private Property RichTextBox.SelAlignment(Value As AlignmentConstants)
		#ifdef __USE_GTK__
			SetIntProperty "justification", IIf(Value = AlignmentConstants.taLeft, GTK_JUSTIFY_LEFT, IIf(Value = AlignmentConstants.taCenter, GTK_JUSTIFY_CENTER, IIf(Value = AlignmentConstants.taRight, GTK_JUSTIFY_RIGHT, 0)))
		#else
			If FHandle Then
				Pf.dwMask = PFM_ALIGNMENT
				Pf.wAlignment = Value + 1
				Perform(EM_SETPARAFORMAT, 0, Cast(LPARAM, @Pf))
			End If
		#endif
	End Property
	
	Private Property RichTextBox.SelBullet As Boolean
		#ifdef __USE_GTK__
			Dim As GtkTextIter FStart, FEnd
			gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @FStart, @FEnd)
			Dim As Boolean bBullet
			Dim As GSList Ptr list = gtk_text_iter_get_tags(@FStart)
			While(list)
				Dim As GtkTextTag Ptr TextTag = list->data
				Dim intval1 As gint, intval2 As gint, ptab_array As PangoTabArray Ptr
				g_object_get(TextTag, "indent", @intval1, "left-margin", @intval2, "tabs", @ptab_array, NULL)
				If intval1 <> -14 AndAlso intval2 = -14 AndAlso ptab_array <> 0 Then bBullet = True
				list = g_slist_next(list)
			Wend
			g_slist_free(list)
			Return bBullet
		#else
			If FHandle Then
				Pf.dwMask = PFM_NUMBERING
				Perform(EM_GETPARAFORMAT, 0, Cast(LPARAM, @Pf))
				Return Pf.wNumbering = PFN_BULLET
			End If
		#endif
		Return 0
	End Property
	
	Private Property RichTextBox.SelBullet(Value As Boolean)
		#ifdef __USE_GTK__
			Dim As GtkTextTagTable Ptr TextTagTable = gtk_text_buffer_get_tag_table(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)))
			Dim As GtkTextTag Ptr NeedTextTag, NotNeedTextTag, TrueTextTag, FalseTextTag
			Dim As String NeedTagName, TrueTagName = "Bullet1", FalseTagName = "Bullet0"
			TrueTextTag = gtk_text_tag_table_lookup(TextTagTable, TrueTagName)
			FalseTextTag = gtk_text_tag_table_lookup(TextTagTable, FalseTagName)
			If Value Then
				NeedTextTag = TrueTextTag
				NotNeedTextTag = FalseTextTag
				NeedTagName = TrueTagName
			Else
				NeedTextTag = FalseTextTag
				NotNeedTextTag = TrueTextTag
				NeedTagName = FalseTagName
			End If
			Dim As GtkTextIter FStart, FEnd
			gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @FStart, @FEnd)
			If NeedTextTag = 0 Then
				NeedTextTag = gtk_text_tag_new(NeedTagName)
				If Value Then
					Dim As PangoTabArray Ptr ptab_array = pango_tab_array_new(2, True)
					pango_tab_array_set_tab(ptab_array, 0, PANGO_TAB_LEFT, 0)
					pango_tab_array_set_tab(ptab_array, 1, PANGO_TAB_LEFT, 14)
					g_object_set(NeedTextTag, "indent", -14, "left-margin", 14, "wrap-mode", GTK_WRAP_WORD, "tabs", ptab_array, NULL)
				Else
					g_object_set(NeedTextTag, "indent", 0, "left-margin", 0, "wrap-mode", GTK_WRAP_WORD, "tabs", 0, NULL)
				End If
				gtk_text_tag_table_add(TextTagTable, NeedTextTag)
			Else
				gtk_text_buffer_remove_tag(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), NeedTextTag, @FStart, @FEnd)
			End If
			If NotNeedTextTag <> 0 Then gtk_text_buffer_remove_tag(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), NotNeedTextTag, @FStart, @FEnd)
			gtk_text_buffer_apply_tag(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), NeedTextTag, @FStart, @FEnd)
		#else
			If FHandle Then
				Pf.dwMask = PFM_NUMBERING
				Pf.wNumbering = IIf(Value, PFN_BULLET, 0)
				Perform(EM_SETPARAFORMAT, 0, Cast(LPARAM, @Pf))
			End If
		#endif
	End Property
	
	Private Property RichTextBox.SelIndent As Integer
		#ifdef __USE_GTK__
			Return gtk_text_view_get_indent(GTK_TEXT_VIEW(widget))
		#else
			If FHandle Then
				Pf.dwMask = PFM_STARTINDENT
				Perform(EM_GETPARAFORMAT, 0, Cast(LPARAM, @Pf))
				Return Pf.dxStartIndent
			End If
		#endif
		Return 0
	End Property
	
	Private Property RichTextBox.SelIndent(Value As Integer)
		#ifdef __USE_GTK__
			gtk_text_view_set_indent(GTK_TEXT_VIEW(widget), Value)
		#else
			If FHandle Then
				Pf.dwMask = PFM_STARTINDENT
				Pf.dxStartIndent = Value
				Perform(EM_SETPARAFORMAT, 0, Cast(LPARAM, @Pf))
			End If
		#endif
	End Property
	
	Private Property RichTextBox.SelRightIndent As Integer
		#ifdef __USE_GTK__
			Return GetIntProperty("right-margin")
		#else
			If FHandle Then
				Pf.dwMask = PFM_RIGHTINDENT
				Perform(EM_GETPARAFORMAT, 0, Cast(LPARAM, @Pf))
				Return Pf.dxRightIndent
			End If
		#endif
		Return 0
	End Property
	
	Private Property RichTextBox.SelRightIndent(Value As Integer)
		#ifdef __USE_GTK__
			SetIntProperty("right-margin", Value)
		#else
			If FHandle Then
				Pf.dwMask = PFM_RIGHTINDENT
				Pf.dxRightIndent = Value
				Perform(EM_SETPARAFORMAT, 0, Cast(LPARAM, @Pf))
			End If
		#endif
	End Property
	
	Private Property RichTextBox.SelHangingIndent As Integer
		#ifdef __USE_GTK__
			Return GetIntProperty("indent") - SelIndent
		#else
			If FHandle Then
				Pf.dwMask = PFM_OFFSET
				Perform(EM_GETPARAFORMAT, 0, Cast(LPARAM, @Pf))
				Return Pf.dxOffset
			End If
		#endif
		Return 0
	End Property
	
	Private Property RichTextBox.SelHangingIndent(Value As Integer)
		#ifdef __USE_GTK__
			SetIntProperty("indent", SelIndent + Value)
		#else
			If FHandle Then
				Pf.dwMask = PFM_OFFSET
				Pf.dxOffset = Value
				Perform(EM_SETPARAFORMAT, 0, Cast(LPARAM, @Pf))
			End If
		#endif
	End Property
	
	Private Property RichTextBox.SelTabCount As Integer
		#ifdef __USE_GTK__
			Dim As GtkTextIter FStart, FEnd
			gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @FStart, @FEnd)
			Dim As PangoTabArray Ptr ptab_array
			Dim As GSList Ptr list = gtk_text_iter_get_tags(@FStart)
			While(list)
				Dim As GtkTextTag Ptr TextTag = list->data
				list = g_slist_next(list)
				g_object_get(TextTag, "tabs", @ptab_array, NULL)
				If ptab_array <> 0 Then Exit While
			Wend
			g_slist_free(list)
			If ptab_array = 0 Then Return 0
			Dim As Integer sTabCount = pango_tab_array_get_size(ptab_array)
			pango_tab_array_free(ptab_array)
			Return sTabCount
		#else
			If FHandle Then
				Pf.dwMask = PFM_TABSTOPS
				Perform(EM_GETPARAFORMAT, 0, Cast(LPARAM, @Pf))
				Return Pf.cTabCount
			End If
		#endif
		Return 0
	End Property
	
	Private Property RichTextBox.SelTabCount(Value As Integer)
		#ifdef __USE_GTK__
			Dim As GtkTextIter FStart, FEnd
			gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @FStart, @FEnd)
			Dim As PangoTabArray Ptr ptab_array
			Dim As GSList Ptr list = gtk_text_iter_get_tags(@FStart)
			While(list)
				Dim As GtkTextTag Ptr TextTag = list->data
				list = g_slist_next(list)
				g_object_get(TextTag, "tabs", @ptab_array, NULL)
				If ptab_array <> 0 Then Exit While
			Wend
			g_slist_free(list)
			If ptab_array = 0 Then
				ptab_array = pango_tab_array_new(Value, True)
			Else
				pango_tab_array_resize(ptab_array, Value)
			End If
			Dim As GtkTextTag Ptr TextTag = gtk_text_tag_new("Tabs")
			g_object_set(TextTag, "tabs", ptab_array, NULL)
			gtk_text_buffer_apply_tag(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), TextTag, @FStart, @FEnd)
			g_object_unref(TextTag)
		#else
			If FHandle Then
				pf.dwMask = PFM_TABSTOPS
				Perform(EM_GETPARAFORMAT, 0, Cast(LPARAM, @Pf))
				Pf.cTabCount = Value
				Perform(EM_SETPARAFORMAT, 0, Cast(LPARAM, @Pf))
			End If
		#endif
	End Property
	
	Private Property RichTextBox.SelTabs(sElement As Integer) As Integer
		#ifdef __USE_GTK__
			If sElement >= 0 AndAlso sElement < SelTabCount Then
				Dim As GtkTextIter FStart, FEnd
				gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @FStart, @FEnd)
				Dim As PangoTabArray Ptr ptab_array
				Dim As GSList Ptr list = gtk_text_iter_get_tags(@FStart)
				While(list)
					Dim As GtkTextTag Ptr TextTag = list->data
					list = g_slist_next(list)
					g_object_get(TextTag, "tabs", @ptab_array, NULL)
					If ptab_array <> 0 Then Exit While
				Wend
				g_slist_free(list)
				If ptab_array = 0 Then Return 0
				Dim As gint Value
				pango_tab_array_get_tab(ptab_array, sElement, PANGO_TAB_LEFT, @Value)
				Return Value
			End If
		#else
			If FHandle Then
				If sElement >= 0 AndAlso sElement <= 31 Then
					Pf.dwMask = PFM_TABSTOPS
					Perform(EM_GETPARAFORMAT, 0, Cast(LPARAM, @Pf))
					Return Pf.rgxTabs(sElement)
				End If
			End If
		#endif
		Return 0
	End Property
	
	Private Property RichTextBox.SelTabs(sElement As Integer, Value As Integer)
		#ifdef __USE_GTK__
			If sElement >= 0 AndAlso sElement < SelTabCount Then
				Dim As GtkTextIter FStart, FEnd
				gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @FStart, @FEnd)
				Dim As PangoTabArray Ptr ptab_array
				Dim As GSList Ptr list = gtk_text_iter_get_tags(@FStart)
				While(list)
					Dim As GtkTextTag Ptr TextTag = list->data
					list = g_slist_next(list)
					g_object_get(TextTag, "tabs", @ptab_array, NULL)
					If ptab_array <> 0 Then Exit While
				Wend
				g_slist_free(list)
				If ptab_array = 0 Then ptab_array = pango_tab_array_new(sElement + 1, True)
				pango_tab_array_set_tab(ptab_array, sElement, PANGO_TAB_LEFT, Value)
				gtk_text_view_set_tabs(GTK_TEXT_VIEW(widget), ptab_array)
				Dim As GtkTextTag Ptr TextTag = gtk_text_tag_new("Tabs")
				g_object_set(TextTag, "tabs", ptab_array, NULL)
				gtk_text_buffer_apply_tag(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), TextTag, @FStart, @FEnd)
				g_object_unref(TextTag)
			End If
		#else
			If FHandle Then
				If sElement >= 0 AndAlso sElement <= 31 Then
					Pf.dwMask = PFM_TABSTOPS
					Perform(EM_GETPARAFORMAT, 0, Cast(LPARAM, @Pf))
					Pf.rgxTabs(sElement) = Value
					Perform(EM_SETPARAFORMAT, 0, Cast(LPARAM, @Pf))
				End If
			End If
		#endif
	End Property
	
	Private Property RichTextBox.SelBackColor As Integer
		#ifdef __USE_GTK__
			Return BGRToRGBA(ValInt(GetStrProperty("background")))
		#else
			If FHandle Then
				Cf2.dwMask = CFM_BACKCOLOR
				Perform(EM_GETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf2))
				Return BGRToRGBA(Cf2.crBackColor)
			End If
		#endif
		Return 0
	End Property
	
	Private Property RichTextBox.SelBackColor(Value As Integer)
		#ifdef __USE_GTK__
			'SetStrProperty "background", "#" & Hex(RGBAToBGR(Value), 6), True
			SetStrProperty "background", "#" & Hex(Value, 6), True
		#else
			If FHandle Then
				Cf2.dwMask = CFM_BACKCOLOR
				Cf2.dwEffects = 0
				'Cf2.crBackColor = RGBAToBGR(Value)
				Cf2.crBackColor = Value
				Perform(EM_SETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf2))
			End If
		#endif
	End Property
	
	Private Property RichTextBox.SelColor As Integer
		#ifdef __USE_GTK__
			Return BGRToRGBA(ValInt(GetStrProperty("foreground")))
		#else
			If FHandle Then
				Cf.dwMask = CFM_COLOR
				Perform(EM_GETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
				Return BGRToRGBA(Cf.crTextColor)
			End If
		#endif
		Return 0
	End Property
	
	Private Property RichTextBox.SelColor(Value As Integer)
		#ifdef __USE_GTK__
			'SetStrProperty "foreground", "#" & Hex(RGBAToBGR(Value), 6), True
			SetStrProperty "foreground", "#" & Hex(Value, 6), True
		#else
			If FHandle Then
				'Dim As CHARFORMAT2 Cf
				'Cf.cbSize = SizeOf(Cf)
				'Cf.dwMask = CFM_COLOR
				'Cf.crTextColor = RGBAToBGR(Value)
				'SendMessage(FHandle, EM_SETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
				'Cf.cbSize = SizeOf(Cf)
				Cf.dwMask = CFM_COLOR
				Cf.dwEffects = 0
				'Cf.crTextColor = RGBAToBGR(Value)
				Cf.crTextColor = Value
				Perform(EM_SETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
			End If
		#endif
	End Property
	
	Private Property RichTextBox.SelFontName ByRef As WString
		#ifdef __USE_GTK__
			Return GetStrProperty("family")
		#else
			If FHandle Then
				Cf.dwMask = CFM_FACE
				Perform(EM_GETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
				Return Cf.szFaceName
			End If
		#endif
		Return Font.Name
	End Property
	
	Private Property RichTextBox.SelFontName(ByRef Value As WString)
		#ifdef __USE_GTK__
			SetStrProperty("family", Value)
		#else
			If FHandle Then
				Cf.dwMask = CFM_FACE
				Cf.szFaceName = Value
				Perform(EM_SETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
			End If
		#endif
	End Property
	
	Private Property RichTextBox.SelFontSize As Integer
		#ifdef __USE_GTK__
			Return GetIntProperty("size")
		#else
			If FHandle Then
				Cf.dwMask = CFM_SIZE
				Perform(EM_GETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
				Return Cf.yHeight
			End If
		#endif
		Return 0
	End Property
	
	Private Property RichTextBox.SelFontSize(Value As Integer)
		#ifdef __USE_GTK__
			SetIntProperty "size", Value
		#else
			If FHandle Then
				Cf.dwMask = CFM_SIZE
				Cf.yHeight = Value
				Perform(EM_SETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
			End If
		#endif
	End Property
	
	#ifdef __USE_GTK__
		Private Function RichTextBox.GetStrProperty(sProperty As String) ByRef As WString
			Dim As GtkTextIter FStart, FEnd
			gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @FStart, @FEnd)
			Dim As GSList Ptr list = gtk_text_iter_get_tags(@FStart)
			While (list)
				Dim As GtkTextTag Ptr TextTag = list->data
				Dim As gchar Ptr strval
				g_object_get(TextTag, sProperty, @strval, NULL)
				If *strval <> "" Then WLet(FSelWStrVal, WStr(*strval))
				list = g_slist_next(list)
			Wend
			g_slist_free(list)
			Return *FSelWStrVal
		End Function
		
		Private Sub RichTextBox.SetStrProperty(sProperty As String, ByRef Value As WString, WithoutPrevValue As Boolean = False)
			Dim As GtkTextTagTable Ptr TextTagTable = gtk_text_buffer_get_tag_table(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)))
			Dim As GtkTextTag Ptr NeedTextTag, NotNeedTextTag
			Dim As String NeedTagName = sProperty & Value, NotNeedTagName = sProperty & IIf(WithoutPrevValue, "", GetStrProperty(sProperty))
			NeedTextTag = gtk_text_tag_table_lookup(TextTagTable, NeedTagName)
			NotNeedTextTag = gtk_text_tag_table_lookup(TextTagTable, NotNeedTagName)
			Dim As GtkTextIter FStart, FEnd
			gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @FStart, @FEnd)
			If NeedTextTag = 0 Then
				NeedTextTag = gtk_text_tag_new(NeedTagName)
				g_object_set(NeedTextTag, sProperty, ToUtf8(Value), NULL)
				gtk_text_tag_table_add(TextTagTable, NeedTextTag)
			Else
				gtk_text_buffer_remove_tag(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), NeedTextTag, @FStart, @FEnd)
			End If
			If NotNeedTextTag <> 0 Then gtk_text_buffer_remove_tag(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), NotNeedTextTag, @FStart, @FEnd)
			gtk_text_buffer_apply_tag(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), NeedTextTag, @FStart, @FEnd)
		End Sub
		
		Private Function RichTextBox.GetIntProperty(sProperty As String) As Integer
			Dim As GtkTextIter FStart, FEnd
			gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @FStart, @FEnd)
			Dim As Integer iResult
			Dim As GSList Ptr list = gtk_text_iter_get_tags(@FStart)
			While (list)
				Dim As GtkTextTag Ptr TextTag = list->data
				Dim As gint intval
				g_object_get(TextTag, sProperty, @intval, NULL)
				If intval <> 0 Then iResult = intval
				list = g_slist_next(list)
			Wend
			g_slist_free(list)
			Return iResult
		End Function
		
		Private Sub RichTextBox.SetIntProperty(sProperty As String, Value As Integer)
			Dim As GtkTextTagTable Ptr TextTagTable = gtk_text_buffer_get_tag_table(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)))
			Dim As GtkTextTag Ptr NeedTextTag, NotNeedTextTag
			Dim As String NeedTagName = sProperty & Str(Value), NotNeedTagName = sProperty & Str(GetIntProperty(sProperty))
			NeedTextTag = gtk_text_tag_table_lookup(TextTagTable, NeedTagName)
			NotNeedTextTag = gtk_text_tag_table_lookup(TextTagTable, NotNeedTagName)
			Dim As GtkTextIter FStart, FEnd
			gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @FStart, @FEnd)
			If NeedTextTag = 0 Then
				NeedTextTag = gtk_text_tag_new(NeedTagName)
				g_object_set(NeedTextTag, sProperty, Value, NULL)
				gtk_text_tag_table_add(TextTagTable, NeedTextTag)
			Else
				gtk_text_buffer_remove_tag(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), NeedTextTag, @FStart, @FEnd)
			End If
			If NotNeedTextTag <> 0 Then gtk_text_buffer_remove_tag(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), NotNeedTextTag, @FStart, @FEnd)
			gtk_text_buffer_apply_tag(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), NeedTextTag, @FStart, @FEnd)
		End Sub
		
		Private Function RichTextBox.GetBoolProperty(sProperty As String, NeedValue As Integer) As Boolean
			Dim As GtkTextTagTable Ptr TextTagTable = gtk_text_buffer_get_tag_table(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)))
			Dim As GtkTextTag Ptr NeedTextTag
			Dim As String NeedTagName = sProperty & Str(NeedValue)
			NeedTextTag = gtk_text_tag_table_lookup(TextTagTable, NeedTagName)
			If NeedTextTag = 0 Then Return False
			Dim As GtkTextIter FStart, FEnd
			gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @FStart, @FEnd)
			Dim As Boolean bResult
			Dim As GSList Ptr list = gtk_text_iter_get_tags(@FStart)
			While (list)
				Dim As GtkTextTag Ptr TextTag = list->data
				If NeedTextTag = TextTag Then bResult = True: Exit While
				list = g_slist_next(list)
			Wend
			g_slist_free(list)
			Return bResult
		End Function
		
		Private Sub RichTextBox.SetBoolProperty(sProperty As String, Value As Boolean, TrueValue As Integer, FalseValue As Integer, StartChar As Integer = -1, EndChar As Integer = -1)
			Dim As GtkTextTagTable Ptr TextTagTable = gtk_text_buffer_get_tag_table(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)))
			Dim As GtkTextTag Ptr NeedTextTag, NotNeedTextTag, TrueTextTag, FalseTextTag
			Dim As String NeedTagName, TrueTagName = sProperty & Str(TrueValue), FalseTagName = sProperty & Str(FalseValue)
			TrueTextTag = gtk_text_tag_table_lookup(TextTagTable, TrueTagName)
			FalseTextTag = gtk_text_tag_table_lookup(TextTagTable, FalseTagName)
			If Value Then
				NeedTextTag = TrueTextTag
				NotNeedTextTag = FalseTextTag
				NeedTagName = TrueTagName
			Else
				NeedTextTag = FalseTextTag
				NotNeedTextTag = TrueTextTag
				NeedTagName = FalseTagName
			End If
			Dim As GtkTextIter FStart, FEnd
			If StartChar = -1 OrElse EndChar = -1 Then
				gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @FStart, @FEnd)
			Else
				Dim As GtkTextBuffer Ptr buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget))
				gtk_text_buffer_get_iter_at_offset(buffer, @FStart, StartChar)
				gtk_text_buffer_get_iter_at_offset(buffer, @FEnd, EndChar)
			End If
			If NeedTextTag = 0 Then
				NeedTextTag = gtk_text_tag_new(NeedTagName)
				g_object_set(NeedTextTag, sProperty, IIf(Value, TrueValue, FalseValue), NULL)
				gtk_text_tag_table_add(TextTagTable, NeedTextTag)
			Else
				gtk_text_buffer_remove_tag(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), NeedTextTag, @FStart, @FEnd)
			End If
			If NotNeedTextTag <> 0 Then gtk_text_buffer_remove_tag(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), NotNeedTextTag, @FStart, @FEnd)
			gtk_text_buffer_apply_tag(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), NeedTextTag, @FStart, @FEnd)
		End Sub
	#endif
	
	Private Property RichTextBox.SelBold As Boolean
		#ifdef __USE_GTK__
			Return GetBoolProperty("weight", PANGO_WEIGHT_BOLD)
		#else
			If FHandle Then
				Cf.dwMask = CFM_BOLD
				Perform(EM_GETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
				Return Cf.dwEffects And CFE_BOLD
			End If
		#endif
		Return 0
	End Property
	
	Private Property RichTextBox.SelBold(Value As Boolean)
		#ifdef __USE_GTK__
			SetBoolProperty "weight", Value, PANGO_WEIGHT_BOLD, PANGO_WEIGHT_NORMAL
		#else
			If FHandle Then
				Cf.dwMask = CFM_BOLD
				Perform(EM_GETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
				Cf.dwEffects = Cf.dwEffects Or CFE_BOLD
				Perform(EM_SETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
			End If
		#endif
	End Property
	
	Private Property RichTextBox.SelItalic As Boolean
		#ifdef __USE_GTK__
			Return GetBoolProperty("style", PANGO_STYLE_ITALIC)
		#else
			If FHandle Then
				Cf.dwMask = CFM_ITALIC
				Perform(EM_GETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
				Return Cf.dwEffects And CFE_ITALIC
			End If
		#endif
		Return 0
	End Property
	
	Private Property RichTextBox.SelItalic(Value As Boolean)
		#ifdef __USE_GTK__
			SetBoolProperty "style", Value, PANGO_STYLE_ITALIC, PANGO_STYLE_NORMAL
		#else
			If FHandle Then
				Cf.dwMask = CFM_ITALIC
				Perform(EM_GETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
				Cf.dwEffects = Cf.dwEffects Or CFE_ITALIC
				Perform(EM_SETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
			End If
		#endif
	End Property
	
	Private Property RichTextBox.SelUnderline As Boolean
		#ifdef __USE_GTK__
			Return GetBoolProperty("underline", PANGO_UNDERLINE_SINGLE)
		#else
			If FHandle Then
				Cf.dwMask = CFM_UNDERLINE
				Perform(EM_GETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
				Return Cf.dwEffects And CFE_UNDERLINE
			End If
		#endif
		Return 0
	End Property
	
	Private Property RichTextBox.SelUnderline(Value As Boolean)
		#ifdef __USE_GTK__
			SetBoolProperty "style", Value, PANGO_UNDERLINE_SINGLE, PANGO_UNDERLINE_NONE
		#else
			If FHandle Then
				Cf.dwMask = CFM_UNDERLINE
				Perform(EM_GETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
				Cf.dwEffects = Cf.dwEffects Or CFE_UNDERLINE
				Perform(EM_SETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
			End If
		#endif
	End Property
	
	Private Property RichTextBox.SelStrikeout As Boolean
		#ifdef __USE_GTK__
			Return GetBoolProperty("strikethrough", True)
		#else
			If FHandle Then
				Cf.dwMask = CFM_STRIKEOUT
				Perform(EM_GETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
				Return Cf.dwEffects And CFE_STRIKEOUT
			End If
		#endif
		Return 0
	End Property
	
	Private Property RichTextBox.SelStrikeout(Value As Boolean)
		#ifdef __USE_GTK__
			SetBoolProperty "strikethrough", Value, True, False
		#else
			If FHandle Then
				Cf.dwMask = CFM_STRIKEOUT
				Perform(EM_GETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
				Cf.dwEffects = Cf.dwEffects Or CFE_STRIKEOUT
				Perform(EM_SETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
			End If
		#endif
	End Property
	
	Private Property RichTextBox.SelProtected As Boolean
		#ifdef __USE_GTK__
			Return GetBoolProperty("editable", True)
		#else
			If FHandle Then
				Cf.dwMask = CFM_PROTECTED
				Perform(EM_GETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
				Return Cf.dwEffects And CFE_PROTECTED
			End If
		#endif
		Return 0
	End Property
	
	Private Property RichTextBox.SelProtected(Value As Boolean)
		#ifdef __USE_GTK__
			SetBoolProperty "editable", Value, True, False
		#else
			If FHandle Then
				Cf.dwMask = CFM_PROTECTED
				Perform(EM_GETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
				Cf.dwEffects = Cf.dwEffects Or CFE_PROTECTED
				Perform(EM_SETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
			End If
		#endif
	End Property
	
	Private Property RichTextBox.SelCharOffset As Integer
		#ifdef __USE_GTK__
			Return GetIntProperty("rise")
		#else
			If FHandle Then
				Cf.dwMask = CFM_OFFSET
				Perform(EM_GETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
				Return Cf.yOffset
			End If
		#endif
		Return 0
	End Property
	
	Private Property RichTextBox.SelCharOffset(Value As Integer)
		#ifdef __USE_GTK__
			SetIntProperty("rise", Value)
		#else
			If FHandle Then
				Cf.dwMask = CFM_OFFSET
				Cf.yOffset = Value
				Perform(EM_SETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
			End If
		#endif
	End Property
	
	Private Property RichTextBox.SelCharSet As Integer
		#ifndef __USE_GTK__
			If FHandle Then
				Cf.dwMask = CFM_CHARSET
				Perform(EM_GETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
				Return Cf.bCharSet
			End If
		#endif
		Return 0
	End Property
	
	Private Property RichTextBox.SelCharSet(Value As Integer)
		#ifndef __USE_GTK__
			If FHandle Then
				Cf.dwMask = CFM_CHARSET
				Cf.bCharSet = Value
				Perform(EM_SETCHARFORMAT, SCF_SELECTION, Cast(LPARAM, @Cf))
			End If
		#endif
	End Property
	
	Private Function RichTextBox.GetCharIndexFromPos(p As My.Sys.Drawing.Point) As Integer
		#ifndef __USE_GTK__
			Return Perform(EM_CHARFROMPOS, 0, CInt(@p))
		#else
			Dim As GtkTextIter TextIter
			gtk_text_view_get_iter_at_position(GTK_TEXT_VIEW(widget), @TextIter, 0, p.X, p.Y)
			Return gtk_text_iter_get_offset(@TextIter)
		#endif
	End Function
	
	Private Property RichTextBox.Zoom As Integer
		Dim As Integer wp, lp
		Var Result = FZoom
		#ifndef __USE_GTK__
			If Handle Then
				Result = 100
				Perform(EM_GETZOOM, CInt(@wp), CInt(@lp))
				If (lp > 0) Then Result = MulDiv(100, wp, lp)
			End If
		#endif
		Return Result
	End Property
	
	Private Property RichTextBox.Zoom(Value As Integer)
		FZoom = Value
		#ifndef __USE_GTK__
			If Value = 0 Then
				Perform(EM_SETZOOM, 0, 0)
			Else
				Perform(EM_SETZOOM, Value, 100)
			End If
		#endif
	End Property
	
	Private Function RichTextBox.BottomLine As Integer
		#ifndef __USE_GTK__
			Dim r As ..Rect, i As Integer
			Perform(EM_GETRECT, 0, CInt(@r))
			r.Left = r.Left + 1
			r.Top  = r.Bottom - 2
			i = Perform(EM_CHARFROMPOS, 0, CInt(@r))
			Return Perform(EM_EXLINEFROMCHAR, 0, i)
		#else
			Return 0
		#endif
	End Function
	
	Private Function RichTextBox.CanRedo As Boolean
		#ifndef __USE_GTK__
			If FHandle Then
				Return (Perform(EM_CANREDO, 0, 0) <> 0)
			Else
				Return 0
			End If
		#else
			Return 0
		#endif
	End Function
	
	Private Sub RichTextBox.Undo
		#ifndef __USE_GTK__
			If FHandle Then Perform(EM_UNDO, 0, 0)
		#endif
	End Sub
	
	Private Sub RichTextBox.Redo
		#ifndef __USE_GTK__
			If FHandle Then Perform(EM_REDO, 0, 0)
		#endif
	End Sub
	
	Private Function RichTextBox.Find(ByRef Value As WString) As Boolean
		#ifndef __USE_GTK__
			If FHandle = 0 Then Return False
			Dim ft As FINDTEXTEX, Result As Integer
			FFindText = _Reallocate(FFindText, (Len(Value) + 1) * SizeOf(FFindText))
			*FFindText = Value
			ft.lpstrText = FFindText
			ft.chrg.cpMin = 0
			ft.chrg.cpMax = -1
			Result = Perform(EM_FINDTEXTEX, FR_DOWN, Cast(LPARAM, @ft))
			If Result = -1 Then
				Return False
			Else
				Perform(EM_EXSETSEL, 0, Cast(LPARAM, @ft.chrgText))
				Return True
			End If
		#else
			Dim As GtkTextIter _start, _end, match_start, match_end
			gtk_text_buffer_get_iter_at_offset(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, 0)
			gtk_text_buffer_get_iter_at_offset(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_end, gtk_text_buffer_get_char_count(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget))))
			Dim As Boolean bResult = gtk_text_iter_forward_search(@_start, ToUtf8(Value), GTK_TEXT_SEARCH_TEXT_ONLY, @match_start, @match_end, @_end)
			If bResult Then gtk_text_buffer_select_range(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @match_start, @match_end)
			Return bResult
		#endif
	End Function
	
	Private Function RichTextBox.FindNext(ByRef Value As WString = "") As Boolean
		#ifndef __USE_GTK__
			If FHandle = 0 Then Return False
			Dim ft As FINDTEXTEX, Result As Integer
			If Value <> "" Then
				FFindText = _Reallocate(FFindText, (Len(Value) + 1) * SizeOf(FFindText))
				*FFindText = Value
			End If
			If FFindText = 0 Then Exit Function
			Perform(EM_EXGETSEL, 0, Cast(LPARAM, @ft.chrg))
			ft.lpstrText = FFindText
			If ft.chrg.cpMin <> ft.chrg.cpMax Then
				ft.chrg.cpMin = ft.chrg.cpMax
			End If
			ft.chrg.cpMax = -1
			Result = Perform(EM_FINDTEXTEX, FR_DOWN, Cast(LPARAM, @ft))
			If Result = -1 Then
				Return False
			Else
				Perform(EM_EXSETSEL, 0, Cast(LPARAM, @ft.chrgText))
				Return True
			End If
		#else
			Dim As GtkTextIter _start, _end, sel_start, sel_end, match_start, match_end
			gtk_text_buffer_get_iter_at_offset(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, 0)
			gtk_text_buffer_get_iter_at_offset(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_end, gtk_text_buffer_get_char_count(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget))))
			gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @sel_start, @sel_end)
			Dim As Boolean bResult = gtk_text_iter_forward_search(@sel_end, ToUtf8(Value), GTK_TEXT_SEARCH_TEXT_ONLY, @match_start, @match_end, @_end)
			If bResult Then gtk_text_buffer_select_range(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @match_start, @match_end)
			Return bResult
		#endif
	End Function
	
	Private Function RichTextBox.FindPrev(ByRef Value As WString = "") As Boolean
		#ifndef __USE_GTK__
			If FHandle = 0 Then Return False
			Dim ft As FINDTEXTEX, Result As Integer
			If Value <> "" Then
				FFindText = _Reallocate(FFindText, (Len(Value) + 1) * SizeOf(FFindText))
				*FFindText = Value
			End If
			If FFindText = 0 Then Exit Function
			Perform(EM_EXGETSEL, 0, Cast(LPARAM, @ft.chrg))
			ft.lpstrText = FFindText
			ft.chrg.cpMax = 0
			Result = Perform(EM_FINDTEXTEX, 0, Cast(LPARAM, @ft))
			If Result = -1 Then
				Return False
			Else
				Perform(EM_EXSETSEL, 0, Cast(LPARAM, @ft.chrgText))
				Return True
			End If
		#else
			Dim As GtkTextIter _start, _end, sel_start, sel_end, match_start, match_end
			gtk_text_buffer_get_iter_at_offset(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, 0)
			gtk_text_buffer_get_iter_at_offset(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_end, gtk_text_buffer_get_char_count(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget))))
			gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @sel_start, @sel_end)
			Dim As Boolean bResult = gtk_text_iter_backward_search(@sel_start, ToUtf8(Value), GTK_TEXT_SEARCH_TEXT_ONLY, @match_start, @match_end, @_start)
			If bResult Then gtk_text_buffer_select_range(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @match_start, @match_end)
			Return bResult
		#endif
	End Function
	
	#ifndef __USE_GTK__
		Private Sub RichTextBox.WndProc(ByRef message As Message)
		End Sub
	#endif
	
	Private Sub RichTextBox.ProcessMessage(ByRef message As Message)
		#ifndef __USE_GTK__
			Select Case message.Msg
			Case CM_COMMAND
				Select Case message.wParamHi
				Case EN_SELCHANGE
					If OnSelChange Then OnSelChange(*Designer, This)
					message.Result = 0
				Case EN_REQUESTRESIZE
					With Cast(REQRESIZE Ptr, message.lParam)->rc
						If OnResize Then OnResize(*Designer, This, UnScaleX(.Right - .Left), UnScaleY(.Bottom - .Top))
					End With
				Case EN_PROTECTED
					Static As Boolean AllowChange  = 1
					With Cast(ENPROTECTED Ptr, message.lParam)->chrg
						If OnProtectChange Then
							OnProtectChange(*Designer, This, .cpMin, .cpMax, AllowChange)
							If Not AllowChange Then message.Result = 1
						End If
					End With
				End Select
			Case WM_PASTE
				Dim Action As Integer = 1
				If OnPaste Then OnPaste(*Designer, This, Action)
				Select Case Action
				Case 0: message.Result = -1
				Case 1: message.Result = 0
				Case 2: message.Result = -2
					Dim As REPASTESPECIAL reps
					reps.dwAspect = 0
					reps.dwParam = 0
					message.Msg = EM_PASTESPECIAL
					message.wParam = CF_TEXT
					message.lParam = Cast(LPARAM, @reps)
				End Select
			Case WM_DPICHANGED
				Base.ProcessMessage message
				If g_darkModeSupported AndAlso g_darkModeEnabled Then
					If FDarkMode Then
						SetDark True
					End If
				Else
					If Not FDarkMode Then
						SetDark False
					End If
				End If
				Return
			Case WM_PAINT
				If g_darkModeSupported AndAlso g_darkModeEnabled Then
					If Not FDarkMode Then
						SetDark True
					End If
				Else
					If FDarkMode Then
						SetDark False
					End If
				End If
				Dim As Any Ptr cp = GetClassProc(message.hWnd)
				If cp <> 0 Then
					message.Result = CallWindowProc(cp, message.hWnd, message.Msg, message.wParam, message.lParam)
				End If
				Dim As HDC Dc
				Dc = GetWindowDC(Handle)
				Dim As Rect r = Type( 0 )
				GetWindowRect(message.hWnd, @r)
				r.Right -= r.Left
				r.Bottom -= r.Top
				r.Left = 0
				r.Top = 0
				Dim As HPEN NewPen
				Dim As HPEN PrevPen
				Dim As HBRUSH PrevBrush
				NewPen = CreatePen(PS_SOLID, 1, BGR(130, 135, 144))
				PrevPen = SelectObject(Dc, NewPen)
				PrevBrush = SelectObject(Dc, GetStockObject(NULL_BRUSH))
				Rectangle Dc, r.Left, r.Top, r.Right, r.Bottom
				DeleteObject NewPen
				r.Right -= 1
				r.Bottom -= 1
				r.Left = 1
				r.Top = 1
				If FDarkMode Then
					NewPen = CreatePen(PS_SOLID, 1, darkBkColor)
				Else
					NewPen = CreatePen(PS_SOLID, 1, FBackColor)
				End If
				SelectObject(Dc, NewPen)
				Rectangle Dc, r.Left, r.Top, r.Right, r.Bottom
				SelectObject(Dc, PrevPen)
				SelectObject(Dc, PrevBrush)
				ReleaseDC(FHandle, Dc)
				DeleteObject NewPen
				message.Result = 0
				Return
			End Select
		#endif
		Base.ProcessMessage(message)
	End Sub
	
	Private Property RichTextBox.EditStyle As Boolean
		Return FEditStyle
	End Property
	
	Private Property RichTextBox.EditStyle(Value As Boolean)
		FEditStyle = Value
		#ifndef __USE_GTK__
			If FHandle Then
				If FEditStyle Then Perform(EM_SETEDITSTYLE, 1, 1)
			End If
		#endif
	End Property
	
	Private Property RichTextBox.SelText ByRef As WString
		Dim As Integer LStart, LEnd
		#ifdef __USE_GTK__
			Dim As GtkTextIter _start, _end
			gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, @_end)
			WLet(FSelText, WStr(*gtk_text_buffer_get_text(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, @_end, True)))
		#else
			If FHandle Then
				Dim charArr As CHARRANGE
				SendMessage(FHandle, EM_GETSEL, CInt(@LStart), CInt(@LEnd))
				If LEnd - LStart <= 0 Then
					FSelText = _Reallocate(FSelText, SizeOf(WString))
					*FSelText = ""
				Else
					FSelText = _Reallocate(FSelText, (LEnd - LStart + 1 + 1) * SizeOf(WString))
					*FSelText = String(LEnd - LStart + 1, 0)
					SendMessage(FHandle, EM_GETSELTEXT, 0, Cast(LPARAM, FSelText))
				End If
			End If
		#endif
		Return *FSelText
	End Property
	
	Private Property RichTextBox.SelText(ByRef Value As WString)
		FSelText = _Reallocate(FSelText, (Len(Value) + 1) * SizeOf(WString))
		*FSelText = Value
		#ifdef __USE_GTK__
			Dim As GtkTextIter _start, _end
			gtk_text_buffer_insert_at_cursor(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), ToUtf8(Value), -1)
		#else
			Dim stSetText As SETTEXTEX
			stSetText.flags = ST_KEEPUNDO
			stSetText.codepage = 1200
			SendMessage(FHandle, EM_REPLACESEL, Cast(WPARAM, @stSetText), Cast(LPARAM, FSelText))
		#endif
	End Property
	
	#ifndef __USE_GTK__
		Private Function RichTextBox.StreamInProc(hFile As ..HANDLE, pBuffer As PVOID, NumBytes As Integer, pBytesRead As Integer Ptr) As BOOL
			Dim As Integer length
			ReadFile(hFile, pBuffer, NumBytes, Cast(LPDWORD, @length), 0)
			*pBytesRead = length
			If length = 0 Then
				Return 1
			End If
		End Function
		
		Private Function RichTextBox.StreamOutProc (hFile As ..HANDLE, pBuffer As PVOID, NumBytes As Integer, pBytesWritten As Integer Ptr) As BOOL
			Dim As Integer length
			WriteFile(hFile, pBuffer, NumBytes, Cast(LPDWORD, @length), 0)
			*pBytesWritten = length
			If length = 0 Then
				Return 1
			End If
		End Function
		
		Private Function RichTextBox.GetTextCallback(dwCookie As DWORD_PTR, pbBuff As Byte Ptr, cb As Long, pcb As Long Ptr) As DWORD
			Dim ptxt As UString Ptr = Cast(UString Ptr, dwCookie)
			If ptxt Then
				ptxt->AppendBuffer(pbBuff, cb)
				*pcb = cb
			End If
			Return 0
		End Function
	#endif
	
	Private Property RichTextBox.TextRTF As UString
		Dim As String s
		#ifndef __USE_GTK__
			If FHandle Then
				FTextRTF = ""
				Dim editstream As EDITSTREAM
				editstream.dwCookie = Cast(DWORD_PTR, @FTextRTF)
				editstream.pfnCallback = Cast(EDITSTREAMCALLBACK, @GetTextCallback)
				SendMessage(FHandle, EM_STREAMOUT, SF_RTF, Cast(LPARAM, @editstream))
				s = Space(FTextRTF.Length)
				If Len(s) Then CopyMemory(StrPtr(s), FTextRTF.vptr, FTextRTF.Length)
			End If
		#endif
		Return s
	End Property
	
	Private Property RichTextBox.TextRTF(Value As UString)
		#ifdef __USE_WINAPI__
			If FHandle Then
				Dim As String Buffer
				If StartsWith(Value, "{\rtf") Then
					Buffer = Value
				Else
					Buffer = ToUtf8(Value)
				End If
				Dim bb As SETTEXTEX
				bb.flags = ST_DEFAULT
				bb.codepage = CP_ACP
				SendMessage(FHandle, EM_SETTEXTEX, Cast(WPARAM, @bb), Cast(LPARAM, StrPtr(Buffer)))
			End If
		#elseif defined(__USE_GTK__)
			If StartsWith(Value, "{\rtf") OrElse StartsWith(Value, "{\urtf") Then
				Dim As GtkTextBuffer Ptr buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget))
				Dim iter As GtkTextIter
				gtk_text_buffer_set_text(buffer, !"\0", -1)
				gtk_text_buffer_get_end_iter(buffer, @iter)
				Dim in_tag As Boolean = False
				Dim count As Integer = 0
				Dim start_bold As Integer = -1
				Dim start_italic As Integer = -1
				Dim rtf_tag As String
				Dim c As UString
				Dim Buff As UString
				For i As Integer = 1 To Len(Value)
					c = Mid(Value, i, 1)
					If CBool(c = "\") OrElse (CBool(c = " ") AndAlso in_tag) OrElse CBool(c = "}") Then
						If Buff <> "" Then
							gtk_text_buffer_insert(buffer, @iter, ToUtf8(Buff), -1)
							Buff = ""
						End If
						If in_tag Then
							If rtf_tag = "b" Then
								start_bold = count
							ElseIf rtf_tag = "i" Then
								start_italic = count
							ElseIf rtf_tag = "par" Then
								gtk_text_buffer_insert(buffer, @iter, Chr(13, 10), 2)
								count += 1
							End If
						End If
						If start_bold > -1 AndAlso ((in_tag AndAlso CBool(rtf_tag = "b0")) OrElse CBool(c = "}")) Then
							SetBoolProperty "weight", True, PANGO_WEIGHT_BOLD, PANGO_WEIGHT_NORMAL, start_bold, count
							start_bold = -1
						End If
						If start_italic > -1 AndAlso ((in_tag AndAlso CBool(rtf_tag = "i0")) OrElse CBool(c = "}")) Then
							SetBoolProperty "style", True, PANGO_STYLE_ITALIC, PANGO_STYLE_NORMAL, start_italic, count
							start_italic = -1
						End If
						rtf_tag = ""
						in_tag = c = "\"
					ElseIf c = "{" Or c = "}" Then
						Continue For
					ElseIf in_tag Then
						If c = !"\n" Then
							Continue For
						End If
						rtf_tag += c
					Else
						Buff += c
						count += 1
					End If
				Next
			Else
				Base.Text = Value
			End If
		#endif
	End Property
	
	Private Function RichTextBox.AddImageFromFile(ByRef File As WString) As Boolean
		Dim As My.Sys.Drawing.BitmapType Bitm
		Bitm.LoadFromFile(File)
		Return AddImage(Bitm)
	End Function
	
	Private Function RichTextBox.AddImage(ByRef ResName As WString) As Boolean
		Dim As My.Sys.Drawing.BitmapType Bitm
		Bitm.LoadFromResourceName(ResName)
		Return AddImage(Bitm)
	End Function
	
	Private Function RichTextBox.AddImage(ByRef Ico As My.Sys.Drawing.Icon) As Boolean
		Dim As My.Sys.Drawing.BitmapType Bitm
		#ifdef __USE_GTK__
			Bitm.Handle = Ico.Handle
		#else
			Bitm.Handle = Ico.ToBitmap
		#endif
		Return AddImage(Bitm)
	End Function
	
	Private Function RichTextBox.AddImage(ByRef Cur As My.Sys.Drawing.Cursor) As Boolean
		Dim As My.Sys.Drawing.BitmapType Bitm
		#ifndef __USE_GTK__
			Bitm.Handle = Cur.ToBitmap
		#endif
		Return AddImage(Bitm)
	End Function
	
	Private Function RichTextBox.AddImage(ByRef Bitm As My.Sys.Drawing.BitmapType) As Boolean
		#ifdef __USE_GTK__
			Dim As GtkWidget Ptr img
			Dim As GtkTextIter _start, _end
			'Dim As GtkTextChildAnchor Ptr ChildAnchor
			gtk_text_buffer_get_selection_bounds(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, @_end)
			gtk_text_buffer_delete(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, @_end)
			'ChildAnchor = gtk_text_buffer_create_child_anchor(gtk_text_view_get_buffer(gtk_text_view(widget)), @_start)
			'img = gtk_image_new_from_pixbuf(Bitm.Handle)
			'gtk_text_view_add_child_at_anchor(gtk_text_view(widget), img, ChildAnchor)
			gtk_text_buffer_insert_pixbuf(gtk_text_view_get_buffer(GTK_TEXT_VIEW(widget)), @_start, Bitm.Handle)
			'gtk_widget_show(img)
		#else
			Dim As HRESULT hr
			
			Dim As LPRICHEDITOLE pRichEditOle
			SendMessage(FHandle, EM_GETOLEINTERFACE, 0, Cast(LPARAM, @pRichEditOle))
			
			If (pRichEditOle = NULL) Then
				Return False
			End If
			
			Dim As IDataObject Ptr pDataObject
			
			CoInitialize(NULL)
			If (OpenClipboard(NULL)) Then
				EmptyClipboard()
				SetClipboardData(CF_BITMAP, Bitm.Handle)
				CloseClipboard()
			Else
				Return False
			End If
			OleGetClipboard(@pDataObject)
			If (pDataObject = NULL) Then
				Return 0
			End If
			
			Dim As LPLOCKBYTES pLockBytes = NULL
			hr = CreateILockBytesOnHGlobal(NULL, True, @pLockBytes)
			
			If (FAILED(hr)) Then
				Return False
			End If
			
			Dim As LPSTORAGE pStorage
			hr = StgCreateDocfileOnILockBytes(pLockBytes, _
			STGM_SHARE_EXCLUSIVE Or STGM_CREATE Or STGM_READWRITE, _
			0, @pStorage)
			
			If (FAILED(hr)) Then
				Return False
			End If
			
			Dim As FORMATETC formatEtc
			formatEtc.cfFormat = 0
			formatEtc.ptd = NULL
			formatEtc.dwAspect = DVASPECT_CONTENT
			formatEtc.lindex = -1
			formatEtc.tymed = TYMED_NULL
			
			Dim As LPOLECLIENTSITE pClientSite
			hr = pRichEditOle->lpVtbl->GetClientSite(pRichEditOle, @pClientSite)
			
			If (FAILED(hr)) Then
				Return False
			End If
			
			Dim As LPUNKNOWN pUnk
			Dim As CLSID clsid_ = CLSID_NULL
			
			'hr = OleCreateFromFile(@clsid_, Cast(LPCOLESTR, @File), @IID_IUnknown, OLERENDER_DRAW, _
			'@formatEtc, pClientSite, pStorage, Cast(LPVOID Ptr, @pUnk))
			hr = OleCreateStaticFromData(pDataObject, @IID_IUnknown, OLERENDER_DRAW, _
			@formatEtc, pClientSite, pStorage, Cast(LPVOID Ptr, @pUnk))
			
			pClientSite->lpVtbl->Release(pClientSite)
			
			If (FAILED(hr)) Then
				Return False
			End If
			
			Dim As LPOLEOBJECT pObject
			hr = pUnk->lpVtbl->QueryInterface(pUnk, @IID_IOleObject, Cast(LPVOID Ptr, @pObject))
			pUnk->lpVtbl->Release(pUnk)
			
			If (FAILED(hr)) Then
				Return False
			End If
			
			OleSetContainedObject(Cast(LPUNKNOWN, pObject), True)
			Dim As REOBJECT reobject
			reobject.cbStruct = SizeOf(reobject)
			hr = pObject->lpVtbl->GetUserClassID(pObject, @clsid_)
			
			If (FAILED(hr)) Then
				pObject->lpVtbl->Release(pObject)
				Return False
			End If
			
			reobject.clsid = clsid_
			reobject.cp = REO_CP_SELECTION
			reobject.dvaspect = DVASPECT_CONTENT 'DVASPECT_THUMBNAIL, DVASPECT_ICON, DVASPECT_DOCPRINT
			'reobject.dvaspect = DVASPECT_DOCPRINT
			reobject.dwFlags = REO_BELOWBASELINE 'Or REO_RESIZABLE 'Or REO_USEASBACKGROUND
			reobject.dwUser = 0
			reobject.poleobj = pObject
			reobject.polesite = pClientSite
			reobject.pstg = pStorage
			Dim As SIZEL sizel
			sizel.cx = 0
			reobject.sizel = sizel
			
			'			SendMessage(FHandle, EM_SETSEL, 0, -1)
			'			Dim As DWORD dwStart, dwEnd
			'			SendMessage(FHandle, EM_GETSEL, Cast(WPARAM, @dwStart), Cast(LPARAM, @dwEnd))
			'			SendMessage(FHandle, EM_SETSEL, dwEnd + 1, dwEnd + 1)
			SendMessage(FHandle, EM_REPLACESEL, True, Cast(WPARAM, @""))
			
			hr = pRichEditOle->lpVtbl->InsertObject(pRichEditOle, @reobject)
			pObject->lpVtbl->Release(pObject)
			pRichEditOle->lpVtbl->Release(pRichEditOle)
			CoUninitialize()
			
			If (FAILED(hr)) Then
				Return False
			End If
			
		#endif
		Return True
	End Function
	
	Private Sub RichTextBox.LoadFromFile(ByRef Value As WString, bRTF As Boolean)
		#ifndef __USE_GTK__
			If FHandle Then
				Dim hFile As ..HANDLE
				hFile = CreateFile(@Value, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0)
				If hFile <> INVALID_HANDLE_VALUE Then
					Dim editstream As EDITSTREAM
					editstream.dwCookie = Cast(DWORD_PTR, hFile)
					editstream.pfnCallback = Cast(EDITSTREAMCALLBACK, @StreamInProc)
					SendMessage(FHandle, EM_STREAMIN, IIf(bRTF, SF_RTF, SF_TEXT), Cast(LPARAM, @editstream))
					SendMessage(FHandle, EM_SETMODIFY, False, 0)
					CloseHandle(hFile)
				End If
			End If
		#endif
	End Sub
	
	Private Sub RichTextBox.SaveToFile(ByRef Value As WString, bRTF As Boolean)
		#ifndef __USE_GTK__
			If Not bRTF Then
				Base.SaveToFile(Value)
			ElseIf FHandle Then
				Dim hFile As ..HANDLE
				hFile = CreateFile(@Value, GENERIC_WRITE, FILE_SHARE_READ, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0)
				If hFile <> INVALID_HANDLE_VALUE Then
					Dim editstream As EDITSTREAM
					editstream.dwCookie = Cast(DWORD_PTR,hFile)
					editstream.pfnCallback= Cast(EDITSTREAMCALLBACK,@StreamOutProc)
					SendMessage(FHandle, EM_STREAMOUT, IIf(bRTF, SF_RTF, SF_TEXT), Cast(LPARAM, @editstream))
					SendMessage(FHandle, EM_SETMODIFY, False, 0)
					CloseHandle(hFile)
				End If
			End If
		#endif
	End Sub
	
	Private Function RichTextBox.SelPrint(ByRef Canvas As My.Sys.Drawing.Canvas) As Boolean
		#if defined(__USE_WINAPI__) AndAlso Not defined(__USE_CAIRO__)
			Dim di As DOCINFO, sz As WString * 64 = This.Name
			di.cbSize = SizeOf(DOCINFO)
			di.lpszDocName = VarPtr(sz)
			Dim hdc As HDC = Canvas.Handle
			If StartDoc(hdc, @di) <= 0 Then
				Return False
			End If
			
			Dim As Integer cxPhysOffset = GetDeviceCaps(hdc, PHYSICALOFFSETX)
			Dim As Integer cyPhysOffset = GetDeviceCaps(hdc, PHYSICALOFFSETY)
			
			Dim As Integer cxPhys = GetDeviceCaps(hdc, PHYSICALWIDTH)
			Dim As Integer cyPhys = GetDeviceCaps(hdc, PHYSICALHEIGHT)
			
			' Create "print preview".
			SendMessage(FHandle, EM_SETTARGETDEVICE, Cast(WPARAM, hdc), cxPhys / 2)
			
			Dim As FORMATRANGE fr
			
			fr.hdc       = hdc
			fr.hdcTarget = hdc
			
			' Set page rect To physical page size in twips.
			fr.rcPage.Top    = 0
			fr.rcPage.Left   = 0
			fr.rcPage.Right  = MulDiv(cxPhys, 1440, GetDeviceCaps(hdc, LOGPIXELSX))
			fr.rcPage.Bottom = MulDiv(cyPhys, 1440, GetDeviceCaps(hdc, LOGPIXELSY))
			
			' Set the rendering rectangle To the pintable area of the page.
			fr.rc.Left   = cxPhysOffset
			fr.rc.Right  = cxPhysOffset + cxPhys
			fr.rc.Top    = cyPhysOffset
			fr.rc.Bottom = cyPhysOffset + cyPhys
			
			'SendMessage(FHandle, EM_SETSEL, 0, Cast(LPARAM, -1))          ' Select the entire contents.
			SendMessage(FHandle, EM_EXGETSEL, 0, Cast(LPARAM, @fr.chrg))  ' Get the selection into a CHARRANGE.
			
			Dim As Boolean fSuccess = True
			
			' Use GDI To Print successive pages.
			While (fr.chrg.cpMin < fr.chrg.cpMax AndAlso fSuccess)
				fSuccess = StartPage(hdc) > 0
				
				If (Not fSuccess) Then Exit While
				
				Dim As Integer cpMin = SendMessage(FHandle, EM_FORMATRANGE, True, Cast(LPARAM, @fr))
				
				If (cpMin <= fr.chrg.cpMin) Then
					fSuccess = False
					Exit While
				End If
				
				fr.chrg.cpMin = cpMin
				fSuccess = EndPage(hdc) > 0
			Wend
			
			SendMessage(FHandle, EM_FORMATRANGE, False, 0)
			
			If (fSuccess) Then
				EndDoc(hdc)
			Else
				AbortDoc(hdc)
			End If
			
			Return fSuccess
		#else
			Return False
		#endif
	End Function
	
	#ifndef __USE_GTK__
		Private Sub RichTextBox.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QRichTextBox(Sender.Child)
					If .MaxLength <> 0 Then
						.MaxLength = .MaxLength
					End If
					If .EditStyle Then
						.EditStyle = .EditStyle
					End If
					If .FZoom Then
						.Zoom = .FZoom
					End If
					If .ReadOnly Then .Perform(EM_SETREADONLY, True, 0)
					.Perform(EM_SETEVENTMASK, 0, .Perform(EM_GETEVENTMASK, 0, 0) Or ENM_CHANGE Or ENM_SCROLL Or ENM_SELCHANGE Or ENM_CLIPFORMAT Or ENM_MOUSEEVENTS)
					.SetDark .FDarkMode
				End With
			End If
		End Sub
		
		Private Sub RichTextBox.SetDark(Value As Boolean)
			Base.SetDark Value
			If Value Then
				SendMessage(FHandle, EM_SETBKGNDCOLOR, 0, darkBkColor)
				Dim As CHARFORMAT2 Cf
				Cf.cbSize = SizeOf(Cf)
				Cf.dwMask = CFM_COLOR Or CFM_BACKCOLOR
				Cf.crTextColor = darkTextColor
				Cf.crBackColor = darkBkColor
				SendMessage(FHandle, EM_SETCHARFORMAT, SCF_ALL, Cast(LPARAM, @Cf))
			Else
				SendMessage(FHandle, EM_SETBKGNDCOLOR, 0, FBackColor)
				Dim As CHARFORMAT2 Cf
				Cf.cbSize = SizeOf(Cf)
				Cf.dwMask = CFM_COLOR Or CFM_BACKCOLOR
				Cf.crTextColor = FForeColor
				Cf.crBackColor = FBackColor
				SendMessage(FHandle, EM_SETCHARFORMAT, SCF_ALL, Cast(LPARAM, @Cf))
			End If
		End Sub
	#endif
	
	Private Operator RichTextBox.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Constructor RichTextBox
		With This
			#ifdef __USE_GTK__
				widget = gtk_text_view_new()
			#else
				hRichTextBox = LoadLibrary("RICHED20.DLL")
				Pf.cbSize = SizeOf(Pf)
				Pf2.cbSize = SizeOf(Pf2)
				Cf.cbSize = SizeOf(Cf)
				Cf2.cbSize = SizeOf(Cf2)
				.RegisterClass "RichTextBox", "RichEdit20W"
				.OnHandleIsAllocated = @HandleIsAllocated
				.ChildProc		= @WndProc
				WLet(.FClassAncestor, "RichEdit20W")
			#endif
			.FHideSelection    = False
			FTabIndex          = -1
			FTabStop           = True
			WLet(.FClassName, "RichTextBox")
			.Child       = @This
			.DoubleBuffered = True
			.Width       = 121
			.Height      = 121
		End With
	End Constructor
	
	Private Destructor RichTextBox
		WDeAllocate(FFindText)
		WDeAllocate(FTextRange)
		WDeAllocate(FSelWStrVal)
		#ifndef __USE_GTK__
			DestroyWindow FHandle
			FreeLibrary(hRichTextBox)
		#endif
	End Destructor
End Namespace
