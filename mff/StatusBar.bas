'###############################################################################
'#  StatusBar.bi                                                               #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TStatusBar.bi                                                             #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "StatusBar.bi"

Namespace My.Sys.Forms
	#ifndef ReadProperty_Off
		Private Function StatusPanel.ReadProperty(PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "alignment": Return @FAlignment
			Case "bevel": Return @FBevel
			Case "caption": Return FCaption
			Case "icon": Return @Icon
			Case "index": Return @Index
			Case "name": Return FName
			Case "panelindex": FPanelIndex = PanelIndex: Return @FPanelIndex
			Case "parent": Return StatusBarControl
			Case "realwidth": FRealWidth = RealWidth: Return @FRealWidth
			Case "width": Return @FWidth
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function StatusPanel.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "alignment": This.Alignment = QInteger(Value)
			Case "bevel": This.Bevel = *Cast(BevelStyle Ptr, Value)
			Case "caption": This.Caption = QWString(Value)
			Case "icon": This.Icon = QWString(Value)
			Case "name": This.Name = QWString(Value)
			Case "panelindex": This.PanelIndex = QInteger(Value)
			Case "parent": This.Parent = Value
			Case "width": This.Width = QInteger(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	
	Private Property StatusPanel.Caption ByRef As WString
		If FCaption > 0 Then Return *FCaption Else Return ""
	End Property
	
	Private Property StatusPanel.Caption(ByRef Value As WString)
		FCaption = _Reallocate(FCaption, (Len(Value) + 1) * SizeOf(WString))
		*FCaption = Value
		If This.StatusBarControl Then Cast(StatusBar Ptr, This.StatusBarControl)->UpdatePanels
	End Property
	
	Private Property StatusPanel.Name ByRef As WString
		If FName > 0 Then Return *FName Else Return ""
	End Property
	
	Private Property StatusPanel.Name(ByRef Value As WString)
		WLet(FName, Value)
	End Property
	
	Private Property StatusPanel.PanelIndex As Integer
		If StatusBarControl Then
			Return Cast(StatusBar Ptr, StatusBarControl)->IndexOf(@This)
		Else
			Return -1
		End If
	End Property
	
	Private Sub StatusBar.ChangePanelIndex(ByRef stPanel As StatusPanel Ptr, Index As Integer)
		Dim OldIndex As Integer = This.IndexOf(stPanel)
		If OldIndex > -1 AndAlso OldIndex <> Index AndAlso Index <= Count - 1 Then
			If Index < OldIndex Then
				For i As Integer = OldIndex - 1 To Index Step -1
					Panels[i + 1] = Panels[i]
				Next i
				Panels[Index] = stPanel
			Else
				For i As Integer = OldIndex + 1 To Index
					Panels[i - 1] = Panels[i]
				Next i
				Panels[Index] = stPanel
			End If
		End If
	End Sub
	
	Private Property StatusPanel.PanelIndex(Value As Integer)
		If StatusBarControl Then
			Cast(StatusBar Ptr, StatusBarControl)->ChangePanelIndex @This, Value
		End If
	End Property
	
	Private Property StatusPanel.Parent As Control Ptr
		Return StatusBarControl
	End Property
	
	Private Property StatusPanel.Parent(Value As Control Ptr)
		If StatusBarControl <> 0 AndAlso StatusBarControl <> Value Then
			Dim As Integer Index = Cast(StatusBar Ptr, StatusBarControl)->IndexOf(@This)
			If Index > -1 Then Cast(StatusBar Ptr, StatusBarControl)->Remove Index
		End If
		StatusBarControl = Value
		Cast(StatusBar Ptr, StatusBarControl)->Add @This
	End Property

	Private Property StatusPanel.Width As Integer
		Return FWidth
	End Property
	
	Private Property StatusPanel.Width(Value As Integer)
		FWidth = Value
		If This.StatusBarControl Then Cast(StatusBar Ptr, This.StatusBarControl)->UpdatePanels
	End Property
	
	Private Property StatusPanel.RealWidth As Integer
		#ifndef __USE_GTK__
			If StatusBarControl->Handle Then
				Dim As ..Rect rct
				Dim As Integer Index = Cast(StatusBar Ptr, StatusBarControl)->IndexOf(@This)
				SendMessage(StatusBarControl->Handle, SB_GETRECT, Index, Cast(LPARAM, @rct))
				FRealWidth = rct.Right - rct.Left
			End If
		#endif
		Return FRealWidth
	End Property
		
	Private Property StatusPanel.Bevel As BevelStyle
		Return FBevel
	End Property
	
	Private Property StatusPanel.Bevel(Value As BevelStyle)
		FBevel = Value
		If This.StatusBarControl Then Cast(StatusBar Ptr, This.StatusBarControl)->UpdatePanels
	End Property
	
	Private Property StatusPanel.Alignment As Integer
		Return FAlignment
	End Property
	
	Private Property StatusPanel.Alignment(Value As Integer)
		FAlignment = Value
		If This.StatusBarControl Then Cast(StatusBar Ptr, This.StatusBarControl)->UpdatePanels
	End Property
	
	Private Operator StatusPanel.Cast As Any Ptr
		Return @This
	End Operator
	
	Private Operator StatusPanel.Let(ByRef Value As WString)
		Caption = Value
	End Operator
	
	Private Sub StatusPanel.IconChanged(ByRef Designer As My.Sys.Object,  ByRef Sender As My.Sys.Drawing.Icon)
		With *Cast(StatusPanel Ptr, Sender.Graphic)
			#ifdef __USE_GTK__
			#else
				If .Parent AndAlso .Parent->Handle Then
					SendMessage(.Parent->Handle, SB_SETICON, Cast(StatusBar Ptr, .Parent)->IndexOf(Sender.Graphic), CInt(.Icon.Handle))
				End If
			#endif
		End With
	End Sub

	Private Constructor StatusPanel
		WLet(FClassName, "StatusPanel")
		Caption     = ""
		FWidth      = 50
		FAlignment  = 0
		FBevel      = 0
		Icon.Graphic = @This
		Icon.Changed = @IconChanged
	End Constructor
	
	Private Destructor StatusPanel
		If FCaption Then _Deallocate( FCaption)
		If FName Then _Deallocate(FName)
	End Destructor
	
	#ifndef ReadProperty_Off
		Private Function StatusBar.ReadProperty(PropertyName As String) As Any Ptr
			Select Case LCase(PropertyName)
			Case "count": Return @Count
			Case "simplepanel": Return @FSimplePanel
			Case "simpletext": Return FSimpleText
			Case "sizegrip": Return @FSizeGrip
			Case Else: Return Base.ReadProperty(PropertyName)
			End Select
			Return 0
		End Function
	#endif
	
	#ifndef WriteProperty_Off
		Private Function StatusBar.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
			Select Case LCase(PropertyName)
			Case "backcolor": This.BackColor = QInteger(Value)
			Case "simplepanel": This.SimplePanel = QBoolean(Value)
			Case "simpletext": This.SimpleText = QWString(Value)
			Case "sizegrip": This.SizeGrip = QBoolean(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
			Return True
		End Function
	#endif
	
	Private Function StatusBar.Add(ByRef wText As WString) As StatusPanel Ptr
		Count += 1
		Panels = _Reallocate(Panels, SizeOf(StatusPanel Ptr) * Count)
		Panels[Count -1] = _New( StatusPanel)
		Panels[Count -1]->FDynamic = True
		Panels[Count -1]->Index     = Count - 1
		Panels[Count -1]->Width     = 50
		Panels[Count -1]->Caption   = wText
		Panels[Count -1]->Alignment = 0
		Panels[Count -1]->Bevel     = pbLowered
		Panels[Count - 1]->StatusBarControl = @This
		UpdatePanels
		Return Panels[Count - 1]
	End Function
	
	Private Sub StatusBar.Add(stPanel As StatusPanel Ptr)
		Count += 1
		Panels = _Reallocate(Panels, SizeOf(StatusPanel Ptr) * Count)
		Panels[Count - 1] = stPanel
		UpdatePanels
	End Sub
	
	Private Sub StatusBar.Remove(Index As Integer)
		Dim As StatusPanel Ptr Ptr Temp
		Dim As Integer i, x = 0
		If Index >= 0 And Index <= Count - 1 Then
			#ifdef __USE_GTK__
				gtk_statusbar_remove(GTK_STATUSBAR(widget), context_id, Panels[i]->message_id)
			#endif
			Temp = _CAllocate((Count - 1) * SizeOf(StatusPanel Ptr))
			x = 0
			For i = 0 To Count -1
				If i <> Index Then
					x += 1
					Temp[x -1] = Panels[i]
				End If
			Next i
			Count -= 1
			Panels = _CAllocate(Count*SizeOf(StatusPanel Ptr))
			For i = 0 To Count -1
				Panels[i] = Temp[i]
			Next i
			_Deallocate( Temp)
		End If
		UpdatePanels
	End Sub
	
	Private Sub StatusBar.Clear
		For i As Integer = Count -1 To 0 Step -1
			Remove i
		Next i
		Count = 0
		#ifdef __USE_GTK__
			gtk_statusbar_remove_all(GTK_STATUSBAR(widget), context_id)
		#else
			SetWindowText Handle, ""
		#endif
	End Sub
	
	Private Function StatusBar.IndexOf(ByRef stPanel As StatusPanel Ptr) As Integer
		For i As Integer = 0 To Count - 1
			If Panels[i] = stPanel Then Return i
		Next
		Return -1
	End Function
	
	Private Sub StatusBar.UpdatePanels
		Dim As Long i, FWidth()
		Dim As WString Ptr s
		Dim As WString Ptr ss
		If Count > 0 Then
			ReDim FWidth(Count - 1)
			For i = 0 To Count - 1
				If i = 0 Then
					FWidth(i) = ScaleX(Panels[i]->Width)
				Else
					FWidth(i) = ScaleX(Panels[i]->Width) + FWidth(i -1)
				End If
			Next i
			FWidth(Count - 1) = -1
			#ifndef __USE_GTK__
				Perform(SB_SETPARTS, Count, Cast(LPARAM, CInt(@FWidth(0))))
			#endif
			For i = 0 To Count - 1
				If Panels[i]->Alignment = 0 Then
					WLet(s, Panels[i]->Caption)
				ElseIf Panels[i]->Alignment = 1 Then
					WLet(s, Chr(9)+Panels[i]->Caption)
				ElseIf Panels[i]->Alignment = 2 Then
					WLet(s, Chr(9) & Chr(9) & Panels[i]->Caption)
				Else
					WLet(s, Panels[i]->Caption)
				End If
				#ifndef __USE_GTK__
					Perform(SB_SETTEXT, i Or Panels[i]->Bevel, Cast(LPARAM, CInt(s)))
					Perform(SB_SETICON, i, Cast(LPARAM, CInt(Panels[i]->Icon.Handle)))
				#endif
				WLet(ss, *ss & IIf(i = 0, "", !"\t") & Panels[i]->Caption)
			Next i
		End If
		#ifdef __USE_GTK__
			gtk_statusbar_push(GTK_STATUSBAR(widget), context_id, ToUtf8(*ss))
		#endif
		Invalidate
		WDeAllocate(s)
		WDeAllocate(ss)
	End Sub
	
	Private Property StatusBar.Panel(Index As Integer) As StatusPanel Ptr
		If Index >= 0 And Index <= Count -1 Then
			Return *Panels[Index]
		End If
	End Property
	
	Private Property StatusBar.Panel(Index As Integer, Value As StatusPanel Ptr)
		If Index >= 0 And Index <= Count -1 Then
			Panels[Index] = Value
		End If
	End Property
	
	Private Property StatusBar.BackColor As Integer
		Return Base.BackColor
	End Property
	
	Private Property StatusBar.BackColor(Value As Integer)
		Base.BackColor = Value
		#ifndef __USE_GTK__
			If Handle Then SendMessage(Handle, SB_SETBKCOLOR, 0, Base.BackColor)
		#endif
	End Property
	
	Private Property StatusBar.SizeGrip As Boolean
		Return FSizeGrip
	End Property
	
	Private Property StatusBar.SizeGrip(Value As Boolean)
		If Value <> FSizeGrip Then
			FSizeGrip = Value
			#ifndef __USE_GTK__
				Style  = WS_CHILD Or CCS_NOPARENTALIGN Or AStyle(abs_(FSizeGrip))
			#endif
			RecreateWnd
		End If
	End Property
	
	Private Property StatusBar.SimplePanel As Boolean
		Return FSimplePanel
	End Property
	
	Private Property StatusBar.SimplePanel(Value As Boolean)
		If Value <> FSimplePanel Then
			FSimplePanel = Value
			#ifndef __USE_GTK__
				If Handle Then
					SendMessage(Handle, SB_SIMPLE, FSimplePanel, 0)
					SimpleText = *FSimpleText
				End If
			#endif
		End If
	End Property
	
	Private Property StatusBar.SimpleText ByRef As WString
		If FSimpleText > 0 Then Return *FSimpleText Else Return ""
	End Property
	
	Private Property StatusBar.SimpleText(ByRef Value As WString)
		If SimplePanel Then
			FSimpleText = _Reallocate(FSimpleText, (Len(Value) + 1) * SizeOf(WString))
			*FSimpleText = Value
			Text = *FSimpleText
			#ifndef __USE_GTK__
				If FHandle Then SendMessage(Handle, SB_SETTEXT, 255, CInt(@Value))
			#endif
		End If
	End Property
	
	#ifndef __USE_GTK__
		Private Sub StatusBar.HandleIsAllocated(ByRef Sender As My.Sys.Forms.Control)
			If Sender.Child Then
				With QStatusBar(Sender.Child)
					'SetClassLong .Handle, GCL_STYLE, GetClassLong(.Handle,GCL_STYLE) And Not CS_HREDRAW
					'.Perform(SB_SETBKCOLOR, 0, .BackColor)
					.SimpleText = .SimpleText
					.SimplePanel = .SimplePanel
					.UpdatePanels
				End With
			End If
		End Sub
		
		Private Sub StatusBar.WndProc(ByRef Message As Message)
		End Sub
		
		Private Sub StatusBar.ProcessMessage(ByRef Message As Message)
			Select Case Message.Msg
			Case WM_ERASEBKGND
				If g_darkModeSupported AndAlso g_darkModeEnabled Then
					Message.Result = -1
					Exit Sub
				End If
			Case WM_PAINT
				If g_darkModeSupported AndAlso g_darkModeEnabled AndAlso FDefaultBackColor = FBackColor Then
					If Not FDarkMode Then
						FDarkMode = True
						'SetWindowTheme(.FHandle, "DarkMode:ExplorerStatusBar", nullptr)
						'SetWindowTheme(.FHandle, "DarkMode_InfoPaneToolbar", nullptr)
						'SetWindowTheme(.FHandle, "", "")
						SendMessage FHandle, SB_SETBKCOLOR, 0, darkBkColor
						Brush.Handle = hbrBkgnd
						SendMessageW(FHandle, WM_THEMECHANGED, 0, 0)
						AllowDarkModeForWindow(FHandle, g_darkModeEnabled)
						UpdateWindow(FHandle)
					End If
					Dim As HDC Dc, memDC
					Dim As HBITMAP Bmp
					Dim As PAINTSTRUCT Ps
					Dim As ..Rect R
					Dc = BeginPaint(Handle, @Ps)
					FillRect Dc, @Ps.rcPaint, Brush.Handle
					Canvas.SetHandle Dc
					Dim As HFONT OldFontHandle, NewFontHandle
					OldFontHandle = SelectObject(Dc, Font.Handle)
					SetTextColor(Dc, darkTextColor)
					SetBkMode(Dc, TRANSPARENT)
					For i As Integer = 0 To Count - 1
						SendMessage FHandle, SB_GETRECT, i, Cast(LPARAM, @R)
						'Canvas.Pen.Color = clWhite
						'SelectObject(Dc, Canvas.Pen.Handle)
						'MoveToEx Dc, R.Left - 1, 3, 0
						'LineTo Dc, R.Left - 1, R.Bottom - 3
						R.Left += 3
						R.Top += 3
						DrawText Dc, Panels[i]->Caption, Len(Panels[i]->Caption), @R, DT_END_ELLIPSIS
						'.TextOut(Dc, R.Left + 3, R.Top + 3, Panels[i]->Caption, Len(Panels[i]->Caption))
					Next i
					SetBkMode(Dc, OPAQUE)
					NewFontHandle = SelectObject(Dc, OldFontHandle)
					If OnPaint Then OnPaint(*Designer, This, Canvas)
					Canvas.UnSetHandle
					EndPaint Handle, @Ps
					Message.Result = 0
					Return
				End If
			Case CM_NOTIFY
				Dim lvp As NMMOUSE Ptr = Cast(NMMOUSE Ptr, Message.lParam)
				Dim As StatusPanel Ptr stPanel
				If lvp->dwItemSpec >= 0 AndAlso lvp->dwItemSpec < Count Then
					stPanel = Panels[lvp->dwItemSpec]
				End If
				Select Case lvp->hdr.code
				Case NM_CLICK: If OnPanelClick Then OnPanelClick(*Designer, This, *stPanel, 0, lvp->pt.X, lvp->pt.Y)
				Case NM_DBLCLK: If OnPanelDblClick Then OnPanelDblClick(*Designer, This, *stPanel, 0, lvp->pt.X, lvp->pt.Y)
				Case NM_RCLICK: If OnPanelClick Then OnPanelClick(*Designer, This, *stPanel, 1, lvp->pt.X, lvp->pt.Y)
				Case NM_RDBLCLK: If OnPanelDblClick Then OnPanelDblClick(*Designer, This, *stPanel, 1, lvp->pt.X, lvp->pt.Y)
				Case SBN_SIMPLEMODECHANGE:
				End Select
			Case Else
			End Select
			Base.ProcessMessage(Message)
		End Sub
	#endif
	
	Private Operator StatusBar.Cast As My.Sys.Forms.Control Ptr
		Return Cast(My.Sys.Forms.Control Ptr, @This)
	End Operator
	
	Private Constructor StatusBar
		With This
			#ifdef __USE_GTK__
				widget = gtk_statusbar_new
				'gtk_statusbar_set_has_resize_grip(gtk_statusbar(widget), true)
				.RegisterClass "StatusBar", @This
				WLet(FSimpleText, "StatusBar")
				context_id = gtk_statusbar_get_context_id(GTK_STATUSBAR(widget), *FSimpleText)
				gtk_widget_show_all(widget)
				'Var cont2 = gtk_statusbar_get_context_id(gtk_statusbar(widget), "statusbar 2")
				'gtk_statusbar_push(gtk_statusbar(widget), cont2, *FSimpleText)
				
			#else
				AStyle(0) = 0
				AStyle(1) = SBARS_SIZEGRIP
			#endif
			FSizeGrip = True
			WLet(FClassName, "StatusBar")
			WLet(FClassAncestor, "msctls_StatusBar32")
			#ifndef __USE_GTK__
				.RegisterClass "StatusBar","msctls_StatusBar32"
				'David Change
				.Style        = WS_CHILD Or CCS_NOPARENTALIGN Or AStyle(abs_(FSizeGrip)) Or WS_CLIPCHILDREN Or WS_CLIPSIBLINGS Or CCS_BOTTOM Or SBARS_TOOLTIPS
				.ExStyle      = 0
				.BackColor        = GetSysColor(COLOR_BTNFACE)
				FDefaultBackColor = .BackColor
				.ChildProc    = @WndProc
				.OnHandleIsAllocated = @HandleIsAllocated
				.DoubleBuffered = True
			#endif
			#ifdef __USE_GTK3__
				.Height       = 35
			#else
				.Height       = 21
			#endif
			.Width        = 175
			.Child        = @This
		End With
	End Constructor
	
	Private Destructor StatusBar
		For i As Integer = Count - 1 To 0 Step -1
			If Panels[i]->FDynamic Then _Delete(Panels[i])
		Next
		_Deallocate(Panels) 'CAllocate_(0)
		#ifndef __USE_GTK__
			UnregisterClass "StatusBar",GetModuleHandle(NULL)
		#endif
		If FSimpleText <> 0 Then _Deallocate( FSimpleText)
	End Destructor
End Namespace

#ifdef __EXPORT_PROCS__
	Sub StatusBarRemovePanel Alias "StatusBarRemovePanel" (sb As My.Sys.Forms.StatusBar Ptr, Index As Integer) Export
		sb->Remove Index
	End Sub

	Function StatusBarPanelByIndex Alias "StatusBarPanelByIndex" (sb As My.Sys.Forms.StatusBar Ptr, Index As Integer) As My.Sys.Forms.StatusPanel Ptr Export
		Return sb->Panel(Index)
	End Function
#endif
