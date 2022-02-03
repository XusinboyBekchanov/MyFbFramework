'###############################################################################
'#  GroupBox.bi                                                                #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov                                 #
'#  Based on:                                                                  #
'#   TGroupBox.bi                                                              #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov (2018-2019)                                          #
'###############################################################################

#include once "GroupBox.bi"
#ifdef __USE_WINAPI__
	#include once "win\tmschema.bi"
#endif

Namespace My.Sys.Forms
	Private Function GroupBox.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "caption": Return FText.vptr
		Case "text": Return FText.vptr
		Case "tabindex": Return @FTabIndex
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Private Function GroupBox.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "caption": This.Caption = QWString(Value)
		Case "text": This.Text = QWString(Value)
		Case "tabindex": TabIndex = QInteger(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Private Property GroupBox.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property GroupBox.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property GroupBox.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property GroupBox.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Property GroupBox.Caption ByRef As WString
		Return Text
	End Property
	
	Private Property GroupBox.Caption(ByRef Value As WString)
		Text = Value
	End Property
	
	Private Property GroupBox.Text ByRef As WString
		#ifdef __USE_GTK__
			FText = WStr(gtk_frame_get_label(GTK_FRAME(widget)))
			Return *FText.vptr
		#else
			Return Base.Text
		#endif
	End Property
	
	Private Property GroupBox.Text(ByRef Value As WString)
		Base.Text = Value
		#ifdef __USE_GTK__
			If widget Then gtk_frame_set_label(GTK_FRAME(widget), ToUtf8(Value))
		#endif
	End Property
	
	Private Property GroupBox.ParentColor As Boolean
		Return FParentColor
	End Property
	
	Private Property GroupBox.ParentColor(Value As Boolean)
		FParentColor = Value
		If FParentColor Then
			This.BackColor = This.Parent->BackColor
			Invalidate
		End If
	End Property
	
	#ifndef __USE_GTK__
		Private Sub GroupBox.WndProc(ByRef Message As Message)
			If Message.Sender Then
			End If
		End Sub
	#endif
	
	#ifdef __USE_WINAPI__
		Private Sub GroupBox.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QGroupBox(Sender.Child)
					If g_darkModeSupported AndAlso g_darkModeEnabled AndAlso .FDefaultBackColor = .FBackColor Then
						SetWindowTheme(.FHandle, "", "")
						'SetWindowTheme(.FHandle, "DarkMode", nullptr)
						.Brush.Handle = hbrBkgnd
						SendMessageW(.FHandle, WM_THEMECHANGED, 0, 0)
					End If
				End With
			End If
		End Sub
	#endif
	
	Private Sub GroupBox.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Select Case Message.Msg
			Case WM_ERASEBKGND
			Case WM_PAINT
				Dim As Integer W,H
				Dim As HDC Dc,memDC
				Dim As HBITMAP Bmp
				Dim As ..Rect R
				GetClientRect Handle,@R
				Dc = GetDC(Handle)
				FillRect Dc, @R, This.Brush.Handle
				ReleaseDC Handle, Dc
   				RedrawWindow(FHandle, NULL, NULL, RDW_INVALIDATE)
			Case WM_COMMAND
				'CallWindowProc(@SuperWndProc, GetParent(Handle), Message.Msg, Message.wParam, Message.lParam)
'			Case CM_CTLCOLOR
'				Static As HDC Dc
'				Dc = Cast(HDC, Message.wParam)
'				SetBKMode Dc, TRANSPARENT
'				SetTextColor Dc, This.Font.Color
'				SetBKColor Dc, This.BackColor
'				SetBKMode Dc, OPAQUE
			Case CM_COMMAND
'				If Message.wParamHi = BN_CLICKED Then
'					If OnClick Then OnClick(This)
'				End If
			Case CM_NOTIFY
        		If g_darkModeSupported AndAlso g_darkModeEnabled AndAlso Message.lParam <> 0 AndAlso Cast(LPNMHDR, Message.lParam)->code = NM_CUSTOMDRAW Then
        			Dim As NMCUSTOMDRAW Ptr pnm = Cast(LPNMCUSTOMDRAW, Message.lParam)
        			Select Case pnm->dwDrawStage
					Case CDDS_PREERASE
                        Dim As HRESULT hr = DrawThemeParentBackground(pnm->hdr.hwndFrom, pnm->hdc, @pnm->rc)
                        If FAILED(hr) Then ' If failed draw without theme
                            SetWindowLongPtr(Message.hWnd, DWLP_MSGRESULT, Cast(LONG_PTR, CDRF_DODEFAULT))
                            Message.Result = True
                            Return
                        End If

                        Dim As HTHEME hTheme = OpenThemeData(pnm->hdr.hwndFrom, "BUTTON")

                        If hTheme = 0 Then ' If failed draw without theme
                            CloseThemeData(hTheme)
                            SetWindowLongPtr(Message.hWnd, DWLP_MSGRESULT, Cast(LONG_PTR, CDRF_DODEFAULT))
                            Message.Result = True
                            Return
                        End If
                           
                        Dim As LRESULT state = SendMessage(pnm->hdr.hwndFrom, BM_GETSTATE, 0, 0)
 
                        Dim As Integer stateID ' parameter for DrawThemeBackground

                        Dim As UINT uiItemState = pnm->uItemState
						
						If (uiItemState And CDIS_DISABLED) Then
							stateID = GBS_DISABLED
						Else
						    stateID = GBS_NORMAL
						End If
						
                        Dim As ..RECT r
                        Dim As ..SIZE s
 
                        ' Get check box dimensions so we can calculate 
                        ' rectangle dimensions For text
                        GetThemePartSize(hTheme, pnm->hdc, BP_GROUPBOX, stateID, NULL, TS_TRUE, @s)
 
                        r.left = pnm->rc.left
                        r.top = pnm->rc.top ' + 2
                        r.right = pnm->rc.left + s.cx
                        r.bottom = pnm->rc.Bottom ' r.top + s.cy

                        DrawThemeBackground(hTheme, pnm->hdc, BP_GROUPBOX, stateID, @r, NULL)
 
                        ' adjust rectangle for text drawing
                        'pnm->rc.top += r.top - 2
                        pnm->rc.left += 3 + s.cx

						'SelectObject(pnm->hdc, Font.Handle)
                        DrawText(pnm->hdc, This.Text & "0", -1, @pnm->rc, DT_SINGLELINE Or DT_VCENTER)
                        CloseThemeData(hTheme)
                        Message.Result = Cast(LONG_PTR, CDRF_SKIPDEFAULT)
                        Return
                    End Select
        		End If
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Private Operator GroupBox.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Constructor GroupBox
		With This
			.Child       = @This
			#ifdef __USE_GTK__
				widget = gtk_frame_new("")
				.RegisterClass "GroupBox", @This
			#else
				.RegisterClass "GroupBox", "Button"
				.ChildProc   = @WndProc
			#endif
			WLet(FClassName, "GroupBox")
			WLet(FClassAncestor, "Button")
			FTabIndex          = -1
			FTabStop           = True
			#ifndef __USE_GTK__
				.ExStyle     = 0 'WS_EX_TRANSPARENT
				.Style       = WS_CHILD Or WS_VISIBLE Or BS_GROUPBOX 'Or SS_NOPREFIX
			#endif
			#ifdef __USE_GTK__
				.BackColor       = -1
			#else
				.BackColor       = GetSysColor(COLOR_BTNFACE)
				FDefaultBackColor = .BackColor
				.OnHandleIsAllocated    = @HandleIsAllocated
			#endif
			.Width       = 121
			.Height      = 51
		End With
	End Constructor
	
	Private Destructor GroupBox
	End Destructor
End Namespace
