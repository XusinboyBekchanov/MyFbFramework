'################################################################################
'#  ToolTips.bi                                                                 #
'#  This file is part of MyFBFramework                                          #
'#  Authors: Xusinboy Bekchanov (2018-2019)                                     #
'################################################################################

#include once "ToolTips.bi"

Namespace My.Sys.Forms
	#ifndef __USE_GTK__
		Sub ToolTips.HandleIsAllocated(ByRef Sender As Control)
			With QToolTips(@Sender)
				
			End With
		End Sub
		
		Sub ToolTips.WNDPROC(ByRef Message As Message)
		End Sub
		
		Sub ToolTips.ProcessMessage(ByRef Message As Message)
			Select Case Message.Msg
			Case CM_NOTIFY
				Dim As LPNMHDR LP = Cast(LPNMHDR, Message.lParam)
				Select Case LP->code
				Case TTN_LINKCLICK
					Dim As PNMLINK pNMLink1 = Cast(PNMLINK, Message.lParam)
					Dim As LITEM item = pNMLink1->item
					If OnLinkClicked Then OnLinkClicked(This, item.szUrl)
				End Select
			Case WM_MOUSEMOVE
				Message.Result = -1
				Return
			End Select
			Base.ProcessMessage(Message)
		End Sub
		
		Private Sub ToolTips.CreateWnd
			Base.CreateWnd
			If Parent AndAlso Parent->Handle Then
				Dim As TOOLINFO    ti
				ZeroMemory(@ti, SizeOf(ti))
				
				ti.cbSize = SizeOf(ti)
				ti.hwnd   = Parent->Handle
				'ti.uId    = Cast(UINT, FHandle)
			
				'FHandle = CreateWindowW(TOOLTIPS_CLASS, "", WS_POPUP, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, NULL, Cast(HMENU, NULL), GetModuleHandle(NULL), NULL)
				If g_darkModeEnabled Then
					SetWindowTheme(FHandle, "DarkMode_Explorer", nullptr)
				End If
				ti.uFlags = TTF_IDISHWND Or TTF_TRACK Or TTF_ABSOLUTE Or TTF_PARSELINKS Or TTF_TRANSPARENT
				ti.hinst  = GetModuleHandle(NULL)
				ti.lpszText  = FText.vptr
				
				SendMessage(FHandle, TTM_ADDTOOL, 0, Cast(LPARAM, @ti))
			End If
		End Sub
	#else
		Function ToolTips.ActivateLink(label As GtkLabel Ptr, uri As gchar Ptr, user_data As gpointer) As Boolean
			Dim As ToolTips Ptr tt = user_data
			If tt <> 0 Then
				If tt->OnLinkClicked Then tt->OnLinkClicked(*tt, *uri)
			End If
			Return True
		End Function
	#endif
	
	Private Sub ToolTips.Show
		If FText = "" Then FText = " "
		#ifdef __USE_GTK__
			gtk_label_set_markup(GTK_LABEL(lblTooltip), ToUtf8(FText))
			gtk_window_move(GTK_WINDOW(winTooltip), FLeft, FTop)
			gtk_window_resize(GTK_WINDOW(winTooltip), 100, 25)
			gtk_widget_show_all(winTooltip)
		#else
			Dim As TOOLINFO    ti
			ZeroMemory(@ti, SizeOf(ti))
			
			ti.cbSize = SizeOf(ti)
			ti.hwnd   = Parent->Handle
			'ti.uId    = Cast(UINT, FHandle)
			
			If FHandle = 0 Then
				CreateWnd
				'FHandle = CreateWindowW(TOOLTIPS_CLASS, "", WS_POPUP, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, NULL, Cast(HMENU, NULL), GetModuleHandle(NULL), NULL)
				If g_darkModeEnabled Then
					SetWindowTheme(FHandle, "DarkMode_Explorer", nullptr)
				End If
				ti.uFlags = TTF_IDISHWND Or TTF_TRACK Or TTF_ABSOLUTE Or TTF_PARSELINKS Or TTF_TRANSPARENT
				ti.hinst  = GetModuleHandle(NULL)
				ti.lpszText  = FText.vptr
				
				SendMessage(FHandle, TTM_ADDTOOL, 0, Cast(LPARAM, @ti))
			Else
				SendMessage(FHandle, TTM_GETTOOLINFO, 0, CInt(@ti))
				
				ti.lpszText = FText.vptr
				
				SendMessage(FHandle, TTM_UPDATETIPTEXT, 0, CInt(@ti))
			End If
			
			SendMessage(FHandle, TTM_SETMAXTIPWIDTH, 0, 1000)
			SendMessage(FHandle, TTM_TRACKACTIVATE, True, Cast(LPARAM, @ti))
			
			Var Result = SendMessage(FHandle, TTM_GETBUBBLESIZE, 0, Cast(LPARAM, @ti))
			
			Dim As ..Rect rc
			.ClientToScreen(Parent->Handle, Cast(..Point Ptr, @rc))
			SendMessage(FHandle, TTM_TRACKPOSITION, 0, MAKELPARAM(rc.Left + FLeft, rc.Top + FTop))
		#endif
	End Sub
	
	Private Sub ToolTips.Hide
		#ifdef __USE_GTK__
			gtk_widget_hide(GTK_WIDGET(winTooltip))
		#else
			If Parent AndAlso Parent->Handle Then
				Dim As TOOLINFO    ti
				ZeroMemory(@ti, SizeOf(ti))
				
				ti.cbSize = SizeOf(ti)
				ti.hwnd   = Parent->Handle
				'ti.uId    = Cast(UINT, FHandle)
				
				SendMessage(FHandle, TTM_TRACKACTIVATE, False, Cast(LPARAM, @ti))
			End If
		#endif
	End Sub
	
	Private Operator ToolTips.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Constructor ToolTips
		With This
			WLet(FClassName, "ToolTips")
			WLet(FClassAncestor, "tooltips_class32")
			#ifdef __USE_GTK__
				winTooltip = gtk_window_new(GTK_WINDOW_POPUP)
				lblTooltip = gtk_label_new(NULL)
				#ifdef __USE_GTK3__
					gtk_widget_set_margin_left(lblTooltip, 1)
					gtk_widget_set_margin_top(lblTooltip, 1)
					gtk_widget_set_margin_right(lblTooltip, 1)
					gtk_widget_set_margin_bottom(lblTooltip, 1)
				#endif
				gtk_container_add(GTK_CONTAINER(winTooltip), lblTooltip)
				g_signal_connect(lblTooltip, "activate-link", G_CALLBACK(@ActivateLink), @This)
			#else
				.RegisterClass "ToolTips", "tooltips_class32"
				.Style        = WS_POPUP
				.ExStyle      = 0 'WS_EX_TOPMOST
				.ChildProc    = @WNDPROC
				.OnHandleIsAllocated = @HandleIsAllocated
			#endif
			.Width        = 175
			.Height       = 21
			.Child        = @This
		End With
	End Constructor
	
	Private Destructor ToolTips
		#ifndef __USE_GTK__
			'UnregisterClass "ToolTips", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace
