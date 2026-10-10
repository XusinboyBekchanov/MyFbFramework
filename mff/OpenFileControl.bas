'###############################################################################
'#  OpenFileControl.bas                                                        #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   Dialogs.bi                                                                #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'#                                                                             #
'#  FIXED VERSION. REQUIRED additions to OpenFileControl.bi (Windows part):    #
'#     FThread  As Any Ptr   ' handle returned by ThreadCreate                 #
'#     FRunning As Long      ' 1 while the dialog thread is alive              #
'###############################################################################

#include once "OpenFileControl.bi"
#ifndef __USE_GTK__
	#include once "win/objbase.bi"
#endif

Namespace My.Sys.Forms
	#ifndef __USE_GTK__
		' ---------------------------------------------------------------------
		' Helpers (module private)
		' ---------------------------------------------------------------------
		' Zero-initialised copy of a WString. Never aliases the source.
		Private Function OFC_Dup(ByVal Src As WString Ptr, ByVal MinChars As Integer, ByVal Extra As Integer = 0) As WString Ptr
			Dim As Integer n = MinChars
			If Src Then
				If Len(*Src) + 1 + Extra > n Then n = Len(*Src) + 1 + Extra
			End If
			If n < 1 Then n = 1
			Dim As WString Ptr p = CAllocate(n, SizeOf(WString))
			If p AndAlso Src Then *p = *Src
			Return p
		End Function
		
		' SendMessage with timeout: the dialog lives in another thread, so a
		' plain SendMessage could dead-lock.
		Private Function OFC_Send(ByVal hDlg As HWND, ByVal Msg As UINT, ByVal wp As WPARAM, ByVal lp As LPARAM) As Long
			Dim As DWORD_PTR r = 0
			If SendMessageTimeout(hDlg, Msg, wp, lp, SMTO_ABORTIFHUNG, 2000, @r) = 0 Then Return 0
			Return Cast(Long, r)
		End Function
		
		' Returns a newly allocated string (caller must Deallocate) or 0.
		Private Function OFC_GetDlgText(ByVal hDlg As HWND, ByVal Msg As UINT) As WString Ptr
			Dim As Long n = OFC_Send(hDlg, Msg, 0, 0)
			If n <= 0 Then Return 0
			Dim As WString Ptr p = CAllocate(n + 2, SizeOf(WString))
			If p = 0 Then Return 0
			If OFC_Send(hDlg, Msg, n + 1, Cast(LPARAM, p)) <= 0 Then
				Deallocate p
				Return 0
			End If
			Return p
		End Function
	#endif
	
	#ifndef ReadProperty_Off
		Private Function OpenFileControl.ReadProperty(PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "defaultext": Return FDefaultExt
			' The getters already refresh F* from the dialog. Do NOT WLet(F*, getter):
			' the getter returns *F*, i.e. source and destination would alias.
			Case "filename": FileName: Return FFileName
			Case "filetitle": FileTitle: Return FFileTitle
			Case "filter": Return FFilter
			Case "initialdir": InitialDir: Return FInitialDir
			Case "multiselect": Return @FMultiSelect
			Case "tabindex": Return @FTabIndex
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function OpenFileControl.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "defaultext": DefaultExt = QWString(Value)
			Case "filename": FileName = QWString(Value)
			Case "filetitle": FileTitle = QWString(Value)
			Case "filter": Filter = QWString(Value)
			Case "initialdir": InitialDir = QWString(Value)
			Case "multiselect": MultiSelect = QBoolean(Value)
			Case "tabindex": TabIndex = QInteger(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	
	Private Property OpenFileControl.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property OpenFileControl.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property OpenFileControl.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property OpenFileControl.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Property OpenFileControl.MultiSelect As Boolean
		Return FMultiSelect
	End Property
	
	Private Property OpenFileControl.MultiSelect(Value As Boolean)
		FMultiSelect = Value
		If Value Then
			Options.Include ofAllowMultiSelect
		Else
			Options.Exclude ofAllowMultiSelect
		End If
		#ifdef __USE_GTK__
			gtk_file_chooser_set_select_multiple(GTK_FILE_CHOOSER (widget), FMultiSelect)
		#endif
	End Property
	
	Private Property OpenFileControl.InitialDir ByRef As WString
		If FHandle Then
			#ifdef __USE_GTK__
				Dim As ZString Ptr pDir = gtk_file_chooser_get_current_folder(GTK_FILE_CHOOSER (widget))
				If pDir Then
					WLet(FInitialDir, WStr(*pDir))
					g_free(pDir)
				End If
			#else
				Dim As WString Ptr p = OFC_GetDlgText(FHandle, CDM_GETFOLDERPATH)
				If p Then
					WLet(FInitialDir, *p)
					Deallocate p
				End If
			#endif
		End If
		Return *FInitialDir
	End Property
	
	Private Property OpenFileControl.InitialDir(ByRef Value As WString)
		If @Value <> FInitialDir Then WLet(FInitialDir, Value) ' guard against aliasing
		#ifdef __USE_GTK__
			If WGet(FInitialDir) = "" Then WLet(FInitialDir, CurDir)
			gtk_file_chooser_set_current_folder(GTK_FILE_CHOOSER (widget), ToUtf8(*FInitialDir))
		#endif
	End Property
	
	Private Property OpenFileControl.DefaultExt ByRef As WString
		Return *FDefaultExt
	End Property
	
	Private Property OpenFileControl.DefaultExt(ByRef Value As WString)
		If @Value <> FDefaultExt Then WLet(FDefaultExt, Value)
		#ifndef __USE_GTK__
			If FHandle Then OFC_Send(FHandle, CDM_SETDEFEXT, 0, Cast(LPARAM, FDefaultExt))
		#endif
	End Property
	
	Private Property OpenFileControl.FileName ByRef As WString
		If FHandle Then
			#ifdef __USE_GTK__
				Dim As ZString Ptr pName = gtk_file_chooser_get_filename(GTK_FILE_CHOOSER(widget))
				If pName Then
					WLet(FFileName, WStr(*pName))
					g_free(pName)
					If InStr(*FFileName, ".") = 0 Then
						If WGet(FDefaultExt) <> "" Then WAdd FFileName, "." & *FDefaultExt
					End If
				End If
			#else
				Dim As WString Ptr p = OFC_GetDlgText(FHandle, CDM_GETFILEPATH)
				If p Then
					WLet(FFileName, *p)
					Deallocate p
				End If
			#endif
		End If
		Return *FFileName
	End Property
	
	Private Property OpenFileControl.FileName(ByRef Value As WString)
		If @Value <> FFileName Then WLet(FFileName, Value)
		#ifdef __USE_GTK__
			' gtk_file_chooser_set_current_name is only valid for SAVE/CREATE_FOLDER actions
			If widget Then
				Dim As GtkFileChooserAction Action = gtk_file_chooser_get_action(GTK_FILE_CHOOSER (widget))
				If Action = GTK_FILE_CHOOSER_ACTION_SAVE OrElse Action = GTK_FILE_CHOOSER_ACTION_CREATE_FOLDER Then
					gtk_file_chooser_set_current_name(GTK_FILE_CHOOSER (widget), ToUtf8(WGet(FFileName)))
				ElseIf WGet(FFileName) = "" Then
					gtk_file_chooser_unselect_all(GTK_FILE_CHOOSER (widget))
				Else
					gtk_file_chooser_set_filename(GTK_FILE_CHOOSER (widget), ToUtf8(*FFileName))
				End If
			End If
		#endif
	End Property
	
	Private Property OpenFileControl.FileTitle ByRef As WString
		If FHandle Then
			#ifdef __USE_GTK__
				FileName
				Dim As Integer Pos1 = InStrRev(*FFileName, "/")
				If Pos1 > 0 Then
					WLet(FFileTitle, Mid(*FFileName, Pos1 + 1))
				Else
					WLet(FFileTitle, *FFileName)
				End If
			#else
				Dim As WString Ptr p = OFC_GetDlgText(FHandle, CDM_GETSPEC)
				If p Then
					WLet(FFileTitle, *p)
					Deallocate p
				End If
			#endif
		End If
		Return *FFileTitle
	End Property
	
	Private Property OpenFileControl.FileTitle(ByRef Value As WString)
		If @Value <> FFileTitle Then WLet(FFileTitle, Value)
		#ifdef __USE_GTK__
			FileName = InitialDir & "/" & *FFileTitle
		#else
			FileName = InitialDir & "\" & *FFileTitle
		#endif
	End Property
	
	Private Property OpenFileControl.Filter ByRef As WString
		Return *FFilter
	End Property
	
	Private Property OpenFileControl.Filter(ByRef Value As WString)
		If @Value <> FFilter Then WLet(FFilter, Value)
		#ifdef __USE_GTK__
			Dim As UString res()
			If *FFilter <> "" Then
				Split *FFilter, "|", res()
				ReDim filefilter(UBound(res) + 1)
				FFilterCount = 0
				For i As Integer = 1 To UBound(res) Step 2
					If res(i) = "" Then Continue For
					FFilterCount += 1
					filefilter(FFilterCount) = gtk_file_filter_new()
					gtk_file_filter_set_name(filefilter(FFilterCount), ToUtf8(res(i - 1)))
					gtk_file_filter_add_pattern(filefilter(FFilterCount), res(i))
					gtk_file_chooser_add_filter(GTK_FILE_CHOOSER (widget), filefilter(FFilterCount))
				Next
				If FFilterIndex <= FFilterCount Then gtk_file_chooser_set_filter(GTK_FILE_CHOOSER (widget), filefilter(FFilterIndex))
			End If
		#endif
	End Property
	
	Private Property OpenFileControl.FilterIndex As Integer
		#ifdef __USE_GTK__
			Dim As GtkFileFilter Ptr choosedfilefilter = gtk_file_chooser_get_filter(GTK_FILE_CHOOSER(widget))
			For i As Integer = 0 To UBound(filefilter)
				If choosedfilefilter = filefilter(i) Then
					FFilterIndex = i
					Exit For
				End If
			Next i
		#endif
		Return FFilterIndex
	End Property
	
	Private Property OpenFileControl.FilterIndex(Value As Integer)
		FFilterIndex    = Value
		#ifdef __USE_GTK__
			If FFilterIndex <= FFilterCount Then gtk_file_chooser_set_filter(GTK_FILE_CHOOSER (widget), filefilter(FFilterIndex))
		#endif
	End Property
	
	#ifndef __USE_GTK__
		Function OpenFileControl.HookListView(hDlg As HWND, uMsg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			Select Case uMsg
			Case WM_NOTIFY
				If (Cast(LPNMHDR, lParam)->code = NM_CUSTOMDRAW) Then
					Dim As LPNMCUSTOMDRAW nmcd = Cast(LPNMCUSTOMDRAW, lParam)
					Select Case nmcd->dwDrawStage
					Case CDDS_PREPAINT
						Return CDRF_NOTIFYITEMDRAW
					Case CDDS_ITEMPREPAINT
						If g_darkModeEnabled Then
							SetTextColor(nmcd->hdc, darkTextColor) 'headerTextColor)
						End If
						Return CDRF_DODEFAULT
					End Select
				End If
			Case WM_NCDESTROY
				Dim As WNDPROC oldProc = GetProp(hDlg, "@@@@Proc")
				SetWindowLongPtr(hDlg, GWLP_WNDPROC, CInt(oldProc))
				RemoveProp(hDlg, "@@@@Proc")
				Return CallWindowProc(oldProc, hDlg, uMsg, wParam, lParam)
			End Select
			Return CallWindowProc(GetProp(hDlg, "@@@@Proc"), hDlg, uMsg, wParam, lParam)
		End Function
		
		Function OpenFileControl.HookListViewParent(hDlg As HWND, uMsg As UINT, wParam1 As WPARAM, lParam1 As LPARAM) As LRESULT
			Select Case uMsg
			Case WM_NOTIFY
				If (Cast(LPNMHDR, lParam1)->code = NM_CUSTOMDRAW) AndAlso ListView_GetView(Cast(LPNMCUSTOMDRAW, lParam1)->hdr.hwndFrom) = 1 AndAlso CInt(g_darkModeEnabled) Then
					Dim As LPNMCUSTOMDRAW nmcd = Cast(LPNMCUSTOMDRAW, lParam1)
					Select Case nmcd->dwDrawStage
					Case CDDS_PREPAINT
						FillRect nmcd->hdc, @nmcd->rc, hbrBkgnd
						Return CDRF_NOTIFYITEMDRAW Or CDRF_NOTIFYPOSTERASE Or CDRF_NOTIFYPOSTPAINT
					Case CDDS_POSTPAINT
						Dim rc As ..Rect
						Dim As Integer SelectedItem = ListView_GetNextItem(nmcd->hdr.hwndFrom, -1, LVNI_SELECTED)
						Dim As Integer SelectedColumn = ListView_GetSelectedColumn(nmcd->hdr.hwndFrom)
						Dim zTxt As WString * 64
						Dim lvi As LVITEM
						For i As Integer = 0 To ListView_GetItemCount(nmcd->hdr.hwndFrom) - 1
							If i <> SelectedItem Then
								ListView_GetSubItemRect(nmcd->hdr.hwndFrom, i, SelectedColumn, LVIR_LABEL, @rc)
								FillRect nmcd->hdc, @rc, hbrBkgnd
								lvi.mask = LVIF_TEXT
								lvi.iItem = i
								lvi.iSubItem   = SelectedColumn
								lvi.pszText    = @zTxt
								lvi.cchTextMax = 64
								ListView_GetItem(nmcd->hdr.hwndFrom, @lvi)
								SetTextColor nmcd->hdc, darkTextColor
								If SelectedColumn = 0 Then
									rc.Left += 2
									rc.Top += 2
								Else
									rc.Left += 6
									rc.Top += 2
								End If
								DrawText nmcd->hdc, @zTxt, Len(zTxt), @rc, DT_END_ELLIPSIS     'Draw text
							End If
						Next i
						Return CDRF_DODEFAULT
					Case CDDS_ITEMPREPAINT
						SetBkMode nmcd->hdc, TRANSPARENT
						FillRect nmcd->hdc, @nmcd->rc, hbrBkgnd
						Return CDRF_DODEFAULT
					End Select
				End If
			Case WM_NCDESTROY
				Dim As WNDPROC oldProc = GetProp(hDlg, "@@@@Proc")
				SetWindowLongPtr(hDlg, GWLP_WNDPROC, CInt(oldProc))
				RemoveProp(hDlg, "@@@@Proc")
				Return CallWindowProc(oldProc, hDlg, uMsg, wParam1, lParam1)
			End Select
			Return CallWindowProc(GetProp(hDlg, "@@@@Proc"), hDlg, uMsg, wParam1, lParam1)
		End Function
		
		Function OpenFileControl.HookChildProc(hDlg As HWND, uMsg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			' The owner pointer is stored ONLY on the dialog window (property "@@@@OFC").
			' This proc is also used for combo boxes, whose GWLP_USERDATA may hold
			' unrelated data - never interpret it as OpenFileControl.
			Dim As OpenFileControl Ptr OpenDial = Cast(OpenFileControl Ptr, GetProp(hDlg, "@@@@OFC"))
			Select Case uMsg
			Case WM_PAINT
				If OpenDial Then
					If Not OpenDial->FFirstShowed Then
						OpenDial->FFirstShowed = True
						MoveWindow hDlg, OpenDial->ScaleX(OpenDial->FLeft), OpenDial->ScaleY(OpenDial->FTop), OpenDial->ScaleX(OpenDial->FWidth), OpenDial->ScaleY(OpenDial->FHeight), True
					End If
					If g_darkModeEnabled Then
						If Not OpenDial->FDarkMode Then
							OpenDial->FDarkMode = True
							SetWindowTheme(hDlg, "DarkMode_Explorer", nullptr)
							AllowDarkModeForWindow(hDlg, g_darkModeEnabled)
							SendMessageW(hDlg, WM_THEMECHANGED, 0, 0)
							EnumChildWindows(hDlg, Cast(WNDENUMPROC, @EnumChildsProc), 0)
						End If
					Else
						If OpenDial->FDarkMode Then
							OpenDial->FDarkMode = False
							SetWindowTheme(hDlg, NULL, NULL)
							AllowDarkModeForWindow(hDlg, g_darkModeEnabled)
							SendMessageW(hDlg, WM_THEMECHANGED, 0, 0)
							EnumChildWindows(hDlg, Cast(WNDENUMPROC, @EnumChildsProc), 0)
						End If
					End If
				End If
			Case WM_WINDOWPOSCHANGING
				If OpenDial Then
					If OpenDial->Constraints.Left <> 0 Then Cast(WINDOWPOS Ptr, lParam)->x  = OpenDial->ScaleX(OpenDial->Constraints.Left)
					If OpenDial->Constraints.Top <> 0 Then Cast(WINDOWPOS Ptr, lParam)->y  = OpenDial->ScaleY(OpenDial->Constraints.Top)
					If OpenDial->Constraints.Width <> 0 Then Cast(WINDOWPOS Ptr, lParam)->cx = OpenDial->ScaleX(OpenDial->Constraints.Width)
					If OpenDial->Constraints.Height <> 0 Then Cast(WINDOWPOS Ptr, lParam)->cy = OpenDial->ScaleY(OpenDial->Constraints.Height)
				End If
			Case WM_CHILDACTIVATE
				If OpenDial Then
					MoveWindow hDlg, OpenDial->FLeft, OpenDial->FTop, OpenDial->FWidth, OpenDial->FHeight, True
				End If
			Case WM_CTLCOLORMSGBOX To WM_CTLCOLORSTATIC, WM_CTLCOLORBTN, WM_CTLCOLOREDIT
				If g_darkModeEnabled Then
					Dim As HDC hd = Cast(HDC, wParam)
					SetTextColor(hd, darkTextColor)
					SetBkColor(hd, darkBkColor)
					Return Cast(LRESULT, hbrBkgnd)
				End If
			Case WM_NCDESTROY
				' Window is going away: unsubclass and drop the properties, so that
				' no message can ever reach a destroyed OpenFileControl.
				Dim As WNDPROC oldProc = GetProp(hDlg, "@@@@Proc")
				SetWindowLongPtr(hDlg, GWLP_WNDPROC, CInt(oldProc))
				RemoveProp(hDlg, "@@@@Proc")
				RemoveProp(hDlg, "@@@@OFC")
				Return CallWindowProc(oldProc, hDlg, uMsg, wParam, lParam)
			End Select
			Return CallWindowProc(GetProp(hDlg, "@@@@Proc"), hDlg, uMsg, wParam, lParam)
		End Function
		
		Function OpenFileControl.HookComboBoxParent(hDlg As HWND, uMsg As UINT, wParam As WPARAM, lParam As LPARAM) As LRESULT
			Return CallWindowProc(GetProp(hDlg, "@@@@Proc"), hDlg, uMsg, wParam, lParam)
		End Function
		
		Function OpenFileControl.EnumChildsProc(hDlg As HWND, lParam1 As LPARAM) As Boolean
			Select Case GetClassNameOf(hDlg)
			Case "ComboBox"
				If g_darkModeEnabled Then
					SetWindowTheme(hDlg, "DarkMode_CFD", nullptr)
				Else
					SetWindowTheme(hDlg, NULL, NULL)
				End If
				Dim As COMBOBOXINFO cbi
				cbi.cbSize = SizeOf(COMBOBOXINFO)
				Dim As BOOL result = GetComboBoxInfo(hDlg, @cbi)
				If result Then
					If g_darkModeEnabled Then
						If cbi.hwndList Then SetWindowTheme(cbi.hwndList, "DarkMode_Explorer", nullptr) 'dark scrollbar for listbox of combobox
					Else
						If cbi.hwndList Then SetWindowTheme(cbi.hwndList, NULL, NULL)
					End If
				End If
				If GetWindowLongPtr(hDlg, GWLP_WNDPROC) <> @HookChildProc Then
					SetProp(hDlg, "@@@@Proc", Cast(WNDPROC, SetWindowLongPtr(hDlg, GWLP_WNDPROC, CInt(@HookChildProc))))
				End If
			Case "ToolbarWindow32"
				If g_darkModeEnabled Then
					SetWindowTheme(hDlg, "DarkMode_InfoPaneToolbar", nullptr)
				Else
					SetWindowTheme(hDlg, NULL, NULL)
				End If
			Case "SysHeader32"
				If g_darkModeEnabled Then
					SetWindowTheme(hDlg, "DarkMode_ItemsView", nullptr)
				Else
					SetWindowTheme(hDlg, NULL, NULL)
				End If
			Case "SysListView32"
				If g_darkModeEnabled Then
					ListView_SetTextColor(hDlg, darkTextColor)
					ListView_SetTextBkColor(hDlg, darkBkColor)
					ListView_SetBkColor(hDlg, darkBkColor)
				Else
					ListView_SetTextColor(hDlg, GetSysColor(COLOR_WINDOWTEXT))
					ListView_SetTextBkColor(hDlg, GetSysColor(COLOR_WINDOW))
					ListView_SetBkColor(hDlg, GetSysColor(COLOR_WINDOW))
				End If
			Case Else
				If g_darkModeEnabled Then
					SetWindowTheme(hDlg, "DarkMode_Explorer", nullptr)
				Else
					SetWindowTheme(hDlg, NULL, NULL)
				End If
			End Select
			AllowDarkModeForWindow(hDlg, g_darkModeEnabled)
			SendMessageW(hDlg, WM_THEMECHANGED, 0, 0)
			Return True
		End Function
		
		Function OpenFileControl.EnumListViewsProc(hDlg As HWND, lParam1 As LPARAM) As Boolean
			Select Case GetClassNameOf(hDlg)
			Case "SysListView32"
				Dim As HWND hHeader = ListView_GetHeader(hDlg)
				If g_darkModeEnabled Then
					SetWindowTheme(hHeader, "DarkMode_ItemsView", nullptr)
					ListView_SetTextColor(hDlg, darkTextColor)
					ListView_SetTextBkColor(hDlg, darkBkColor)
					ListView_SetBkColor(hDlg, darkBkColor)
				Else
					SetWindowTheme(hHeader, NULL, NULL)
					ListView_SetTextColor(hDlg, GetSysColor(COLOR_WINDOWTEXT))
					ListView_SetTextBkColor(hDlg, GetSysColor(COLOR_WINDOW))
					ListView_SetBkColor(hDlg, GetSysColor(COLOR_WINDOW))
				End If
				If Cast(WNDPROC, GetWindowLongPtr(hDlg, GWLP_WNDPROC)) <> CInt(@HookListView) Then
					SetProp(hDlg, "@@@@Proc", Cast(WNDPROC, SetWindowLongPtr(hDlg, GWLP_WNDPROC, CInt(@HookListView))))
				End If
				If Cast(WNDPROC, GetWindowLongPtr(GetParent(hDlg), GWLP_WNDPROC)) <> CInt(@HookListViewParent) Then
					SetProp(GetParent(hDlg), "@@@@Proc", Cast(WNDPROC, SetWindowLongPtr(GetParent(hDlg), GWLP_WNDPROC, CInt(@HookListViewParent))))
				End If
				AllowDarkModeForWindow(hDlg, g_darkModeEnabled)
				SendMessageW(hDlg, WM_THEMECHANGED, 0, 0)
			End Select
			Return True
		End Function
		
		' Runs in the dialog thread (GetOpenFileName hook).
		Private Function OpenFileControl.Hook(FWindow As HWND, Msg As UINT, wParam As WPARAM, lParam As LPARAM) As UInteger
			' No Static variable: several dialogs may live at the same time.
			Dim As OpenFileControl Ptr OpenDial = Cast(OpenFileControl Ptr, GetProp(FWindow, "@@@@OFC"))
			Select Case Msg
			Case WM_INITDIALOG
				OpenDial = Cast(OpenFileControl Ptr, Cast(LPOPENFILENAME, lParam)->lCustData)
				Dim As HWND ModalWnd = GetParent(FWindow)
				If OpenDial = 0 OrElse OpenDial->Parent = 0 OrElse OpenDial->Parent->Handle = 0 Then
					PostMessage(ModalWnd, WM_SYSCOMMAND, SC_CLOSE, 0)
					Return False
				End If
				SetProp(FWindow, "@@@@OFC", Cast(Any Ptr, OpenDial))
				SetWindowLong(ModalWnd, GWL_STYLE, WS_CHILD Or DS_CONTROL)
				SetWindowLong(ModalWnd, GWL_EXSTYLE, WS_EX_CONTROLPARENT)
				SetParent ModalWnd, OpenDial->Parent->Handle
				ShowWindow(GetDlgItem(ModalWnd, IDOK), SW_HIDE)
				ShowWindow(GetDlgItem(ModalWnd, IDCANCEL), SW_HIDE)
				Dim As ..Rect R
				GetWindowRect GetDlgItem(ModalWnd, cmb13), @R
				MapWindowPoints 0, GetParent(GetDlgItem(ModalWnd, cmb13)), Cast(..Point Ptr, @R), 2
				MoveWindow(GetDlgItem(ModalWnd, cmb13), R.Left, R.Top, R.Right - R.Left + 100, R.Bottom - R.Top, True)
				GetWindowRect GetDlgItem(ModalWnd, cmb1), @R
				MapWindowPoints 0, GetParent(GetDlgItem(ModalWnd, cmb1)), Cast(..Point Ptr, @R), 2
				MoveWindow(GetDlgItem(ModalWnd, cmb1), R.Left, R.Top, R.Right - R.Left + 100, R.Bottom - R.Top, True)
				' Subclass here, in the dialog's own thread (no race with the main thread).
				SetProp(ModalWnd, "@@@@OFC", Cast(Any Ptr, OpenDial))
				SetProp(ModalWnd, "@@@@Proc", Cast(WNDPROC, SetWindowLongPtr(ModalWnd, GWLP_WNDPROC, CInt(@HookChildProc))))
				If OpenDial->FVisible Then ShowWindow(ModalWnd, SW_SHOWNORMAL)
				' Publish the handle LAST: the main thread waits for it, so when it
				' sees FHandle <> 0 everything above is already done.
				OpenDial->Handle = ModalWnd
			Case WM_DESTROY
				RemoveProp(FWindow, "@@@@OFC")
			Case WM_NOTIFY
				If OpenDial = 0 Then Return False
				Dim As OFNOTIFY Ptr POF = Cast(OFNOTIFY Ptr, lParam)
				Select Case POF->hdr.code
				Case CDN_FILEOK
					If OpenDial->OnFileActivate Then OpenDial->OnFileActivate(*OpenDial->Designer, *OpenDial)
					SetWindowLongPtr FWindow, DWLP_MSGRESULT, 1 ' keep the (embedded) dialog open
					Return 1
				Case CDN_SELCHANGE
					If OpenDial->OnSelectionChange Then OpenDial->OnSelectionChange(*OpenDial->Designer, *OpenDial)
				Case CDN_FOLDERCHANGE
					If g_darkModeSupported AndAlso g_darkModeEnabled Then
						EnumChildWindows(OpenDial->Handle, Cast(WNDENUMPROC, @EnumListViewsProc), 0)
					End If
					If OpenDial->OnFolderChange Then OpenDial->OnFolderChange(*OpenDial->Designer, *OpenDial)
				Case CDN_TYPECHANGE
					Dim As Integer Index = (*Cast(OPENFILENAME Ptr, POF->lpOFN)).nFilterIndex
					OpenDial->FilterIndex = Index
					If OpenDial->OnTypeChange Then
						OpenDial->OnTypeChange(*OpenDial->Designer, *OpenDial, Index)
					End If
				End Select
			End Select
			Return False
		End Function
	#endif
	
	' Thread procedure: owns ALL buffers it passes to GetOpenFileName.
	Private Sub OpenFileControl.CreateWnd(Param As Any Ptr)
		#ifndef __USE_GTK__
			Dim As OpenFileControl Ptr OpenDial = Param
			Dim As WString Ptr pFile, pTitle, pFilter, pInit, pExt
			Dim As WCHAR Ptr pch
			Dim As Integer i, nFilterLen, nFilterIndex
			Dim As Boolean bCoInit, bResult
			Dim As HRESULT hr
			Dim As DWORD dwFlags
			Dim As WString * 1024 sMsg
			Dim ofn As OPENFILENAME
			Const FILE_CHARS = 32768
			
			If OpenDial = 0 Then Exit Sub
			On Error Goto ErrorHandler
			
			' The shell folder view (SHCreateShellFolderView) requires COM in this thread.
			hr = CoInitializeEx(NULL, COINIT_APARTMENTTHREADED)
			bCoInit = (hr >= 0)
			
			OpenDial->FileNames.Clear
			dwFlags = Cast(Integer, OpenDial->Options)
			
			' Private copies - never share heap blocks with the main thread
			pFile  = OFC_Dup(OpenDial->FFileName, FILE_CHARS)
			pTitle = OFC_Dup(0, MAX_PATH + 1)
			pInit  = OFC_Dup(OpenDial->FInitialDir, MAX_PATH + 1)
			If Len(*pInit) = 0 Then *pInit = CurDir
			If OpenDial->FDefaultExt Then pExt = OFC_Dup(OpenDial->FDefaultExt, 16)
			
			' Filter: "Name|*.ext|Name2|*.ext2" -> "Name\0*.ext\0Name2\0*.ext2\0\0"
			pFilter = OFC_Dup(OpenDial->FFilter, 4, 4)
			nFilterLen = Len(*pFilter)
			pch = Cast(WCHAR Ptr, pFilter)
			For i = 0 To nFilterLen - 1
				If pch[i] = Asc("|") Then pch[i] = 0
			Next
			
			nFilterIndex = OpenDial->FFilterIndex
			If nFilterIndex < 1 Then nFilterIndex = 1
			
			ZeroMemory(@ofn, SizeOf(ofn))
			ofn.lStructSize     = SizeOf(ofn)
			ofn.hwndOwner       = 0
			If nFilterLen > 0 Then ofn.lpstrFilter = pFilter
			ofn.nFilterIndex    = nFilterIndex
			ofn.lpstrFile       = pFile
			ofn.nMaxFile        = FILE_CHARS
			ofn.lpstrFileTitle  = pTitle
			ofn.nMaxFileTitle   = MAX_PATH + 1
			ofn.lpstrInitialDir = pInit
			ofn.Flags           = dwFlags
			ofn.lpfnHook        = Cast(LPOFNHOOKPROC, @Hook)
			ofn.lCustData       = Cast(LPARAM, OpenDial)
			If pExt Then ofn.lpstrDefExt = pExt
			
			bResult = GetOpenFileName(@ofn)
			
	Cleanup:
			If bCoInit Then
				CoUninitialize()
				bCoInit = False
			End If
			If pFile Then Deallocate pFile: pFile = 0
			If pTitle Then Deallocate pTitle: pTitle = 0
			If pFilter Then Deallocate pFilter: pFilter = 0
			If pInit Then Deallocate pInit: pInit = 0
			If pExt Then Deallocate pExt: pExt = 0
			OpenDial->ThreadID = 0
			InterlockedExchange(@OpenDial->FRunning, 0) ' must be the very last access to OpenDial
			Exit Sub
	ErrorHandler:
			' Do not show UI from a worker thread - write to the debugger output instead.
			sMsg = ErrDescription(Err) & " (" & Err & ") " & _
			"in line " & Erl() & " " & _
			"in function " & ZGet(Erfn()) & " " & _
			"in module " & ZGet(Ermn())
			OutputDebugStringW(@sMsg)
			Goto Cleanup
		#endif
	End Sub
	
	Private Sub OpenFileControl.CreateWnd
		#ifndef __USE_GTK__
			If This.Parent <> 0 AndAlso This.Parent->Handle <> 0 Then
				If FRunning <> 0 Then Exit Sub ' dialog thread is already alive
				FHandle = 0
				FDarkMode = False
				FFirstShowed = False
				FRunning = 1
				FThread = ThreadCreate(@CreateWnd, @This)
				If FThread = 0 Then
					FRunning = 0
					Exit Sub
				End If
				ThreadID = FThread
				' Wait until the dialog window exists, the thread ends (dialog failed
				' to open) or a time-out expires. The old loop could spin forever.
				Dim As Double t0 = Timer
				Do While FHandle = 0 AndAlso FRunning <> 0 AndAlso (Timer - t0) < 10
					Sleep(10, 1)
					pApp->DoEvents
				Loop
			End If
		#endif
	End Sub
	
	#ifdef __USE_GTK__
		Private Sub OpenFileControl.FileChooser_CurrentFolderChanged(chooser As GtkFileChooser Ptr, user_data As Any Ptr)
			Dim As OpenFileControl Ptr ofc = user_data
			If ofc->OnFolderChange Then ofc->OnFolderChange(*ofc->Designer, *ofc)
		End Sub
		
		Private Sub OpenFileControl.FileChooser_FileActivated(chooser As GtkFileChooser Ptr, user_data As Any Ptr)
			Dim As OpenFileControl Ptr ofc = user_data
			If ofc->OnFileActivate Then ofc->OnFileActivate(*ofc->Designer, *ofc)
		End Sub
		
		Private Sub OpenFileControl.FileChooser_SelectionChanged(chooser As GtkFileChooser Ptr, user_data As Any Ptr)
			Dim As OpenFileControl Ptr ofc = user_data
			If ofc->OnSelectionChange Then ofc->OnSelectionChange(*ofc->Designer, *ofc)
		End Sub
	#endif
	
	Private Constructor OpenFileControl
		#ifdef __USE_GTK__
			widget =  gtk_file_chooser_widget_new (GTK_FILE_CHOOSER_ACTION_OPEN)
			g_signal_connect(widget, "current-folder-changed", G_CALLBACK(@FileChooser_CurrentFolderChanged), @This)
			g_signal_connect(widget, "file-activated", G_CALLBACK(@FileChooser_FileActivated), @This)
			g_signal_connect(widget, "selection-changed", G_CALLBACK(@FileChooser_SelectionChanged), @This)
		#else
			FThread  = 0
			FRunning = 0
			Options.Include OFN_PATHMUSTEXIST
			Options.Include OFN_FILEMUSTEXIST
			Options.Include OFN_HIDEREADONLY
			Options.Include OFN_ENABLESIZING
			Options.Include OFN_EXPLORER
			Options.Include OFN_ENABLEHOOK
			'OFN_NONETWORKBUTTON
			'OFN_LONGNAMES
			'OFN_NODEREFERENCELINKS
			'OFN_OVERWRITEPROMPT
			'OFN_CREATEPROMPT
			'OFN_DONTADDTORECENT
		#endif
		Child = @This
		FTabIndex          = -1
		FTabStop           = True
		WLet(FClassName, "OpenFileControl")
		WLet(FFilter, "")
		FilterIndex       = 1
	End Constructor
	
	Private Destructor OpenFileControl
		#ifndef __USE_GTK__
			' 1) Close the dialog and WAIT for the worker thread BEFORE freeing anything:
			'    the thread and the window hooks still use this object (use-after-free).
			If FRunning <> 0 Then
				If FHandle Then
					If IsWindow(FHandle) Then PostMessage(FHandle, WM_SYSCOMMAND, SC_CLOSE, 0)
				End If
				Dim As Double t0 = Timer
				' Pump messages instead of blocking: destroying the re-parented dialog
				' sends messages to windows owned by the main thread.
				Do While FRunning <> 0 AndAlso (Timer - t0) < 5
					If pApp Then pApp->DoEvents
					Sleep(10, 1)
				Loop
			End If
			If FThread Then
				If FRunning = 0 Then
					ThreadWait(FThread)
				Else
					ThreadDetach(FThread)
				End If
				FThread = 0
			End If
			FHandle = 0
		#else
			g_signal_handlers_disconnect_by_func(widget, G_CALLBACK(@FileChooser_CurrentFolderChanged), @This)
			g_signal_handlers_disconnect_by_func(widget, G_CALLBACK(@FileChooser_FileActivated), @This)
			g_signal_handlers_disconnect_by_func(widget, G_CALLBACK(@FileChooser_SelectionChanged), @This)
			widget = 0
		#endif
		' 2) Now it is safe to free the buffers.
		If FInitialDir Then _Deallocate(FInitialDir): FInitialDir = 0
		If FDefaultExt Then _Deallocate(FDefaultExt): FDefaultExt = 0
		If FFileName Then _Deallocate(FFileName): FFileName = 0
		If FFileTitle Then _Deallocate(FFileTitle): FFileTitle = 0
		If FFilter Then _Deallocate(FFilter): FFilter = 0
	End Destructor
End Namespace
