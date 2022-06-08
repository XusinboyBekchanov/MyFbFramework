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
					
				End With
			End If
		End Sub
	#endif
	
	Private Sub GroupBox.ProcessMessage(ByRef Message As Message)
		#ifndef __USE_GTK__
			Select Case Message.Msg
			Case WM_ERASEBKGND
			Case WM_PAINT
				If g_darkModeSupported AndAlso g_darkModeEnabled AndAlso FDefaultBackColor = FBackColor Then
					If Not FDarkMode Then
						SetDark True
'						FDarkMode = True
'						'SetWindowTheme(.FHandle, "", "")
'						'SetWindowTheme(.FHandle, "DarkMode", nullptr)
'						This.Brush.Handle = hbrBkgnd
'						SendMessageW(FHandle, WM_THEMECHANGED, 0, 0)
					End If
				Else
					If FDarkMode Then
						SetDark False
'						FDarkMode = False
'						'SetWindowTheme(.FHandle, "", "")
'						'SetWindowTheme(.FHandle, "DarkMode", nullptr)
'						If FBackColor = -1 Then
'							This.Brush.Handle = 0
'						Else
'							This.Brush.Color = FBackColor
'						End If
'						SendMessageW(FHandle, WM_THEMECHANGED, 0, 0)
					End If
				End If
				Dim As Integer W, H
				Dim As HDC Dc, memDC
				Dim As HBITMAP Bmp
				Dim As ..Rect R
				Dim As PAINTSTRUCT Ps
				This.Canvas.HandleSetted = True
				Dc = BeginPaint(Handle, @Ps)
				FillRect Dc, @Ps.rcpaint, This.Brush.Handle
				This.Canvas.Handle = Dc
				If g_darkModeSupported AndAlso g_darkModeEnabled Then
					Dim As LRESULT state = SendMessage(FHandle, BM_GETSTATE, 0, 0)
					Dim As Integer stateID
					'stateID = GBS_DISABLED
					stateID = GBS_NORMAL
					Dim As HPEN NewPen = CreatePen(PS_SOLID, 1, darkHlBkColor)
					Dim As HPEN PrevPen = SelectObject(Dc, NewPen)
					Dim As HPEN PrevBrush = SelectObject(Dc, GetStockObject(NULL_BRUSH))
					Rectangle Dc, ScaleX(This.Left), ScaleY(This.Top) + 6, ScaleX(This.Left + This.Width), ScaleY(This.Top + This.Height) - 1
					SetTextColor(Dc, darkTextColor)
					SetBkColor(Dc, darkBkColor)
					Dim As hFont OldFontHandle, NewFontHandle
					OldFontHandle = SelectObject(Dc, This.Font.Handle)
					TextOut(Dc, ScaleX(This.Left) + 6, ScaleY(This.Top), @This.Text, Len(This.Text))
					NewFontHandle = SelectObject(dc, OldFontHandle)
					SelectObject(Dc, PrevPen)
					SelectObject(Dc, PrevBrush)
					EndPaint Handle, @Ps
					DeleteObject NewPen
					Message.Result = 0
					This.Canvas.HandleSetted = False
					Return
				Else
					EndPaint Handle, @Ps
					'ReleaseDC Handle, Dc
					RedrawWindow(FHandle, NULL, NULL, RDW_INVALIDATE)
				End If
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
