﻿'###############################################################################
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

Namespace My.Sys.Forms
	Function GroupBox.ReadProperty(PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "caption": Return FText.vptr
		Case "text": Return FText.vptr
		Case "tabindex": Return @FTabIndex
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Function GroupBox.WriteProperty(PropertyName As String, Value As Any Ptr) As Boolean
		Select Case LCase(PropertyName)
		Case "caption": This.Caption = QWString(Value)
		Case "text": This.Text = QWString(Value)
		Case "tabindex": TabIndex = QInteger(Value)
		Case Else: Return Base.WriteProperty(PropertyName, Value)
		End Select
		Return True
	End Function
	
	Property GroupBox.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Property GroupBox.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Property GroupBox.TabStop As Boolean
		Return FTabStop
	End Property
	
	Property GroupBox.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Property GroupBox.Caption ByRef As WString
		Return Text
	End Property
	
	Property GroupBox.Caption(ByRef Value As WString)
		Text = Value
	End Property
	
	Property GroupBox.Text ByRef As WString
		#ifdef __USE_GTK__
			FText = WStr(gtk_frame_get_label(GTK_FRAME(widget)))
			Return *FText.vptr
		#else
			Return Base.Text
		#endif
	End Property
	
	Property GroupBox.Text(ByRef Value As WString)
		Base.Text = Value
		#ifdef __USE_GTK__
			If widget Then gtk_frame_set_label(GTK_FRAME(widget), ToUtf8(Value))
		#endif
	End Property
	
	Property GroupBox.ParentColor As Boolean
		Return FParentColor
	End Property
	
	Property GroupBox.ParentColor(Value As Boolean)
		FParentColor = Value
		If FParentColor Then
			This.BackColor = This.Parent->BackColor
			Invalidate
		End If
	End Property
	
	#ifndef __USE_GTK__
		Sub GroupBox.WndProc(ByRef Message As Message)
			If Message.Sender Then
			End If
		End Sub
	#endif
	
	Sub GroupBox.ProcessMessage(ByRef Message As Message)
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
				FillRect Dc,@R,This.Brush.Handle
				ReleaseDC Handle, Dc
   				RedrawWindow(FHandle, NULL, NULL, RDW_INVALIDATE)
			Case WM_COMMAND
				CallWindowProc(@SuperWndProc, GetParent(Handle), Message.Msg, Message.wParam, Message.lParam)
			Case CM_CTLCOLOR
'				Static As HDC Dc
'				Dc = Cast(HDC, Message.wParam)
'				SetBKMode Dc, TRANSPARENT
'				SetTextColor Dc, This.Font.Color
'				SetBKColor Dc, This.BackColor
'				SetBKMode Dc, OPAQUE
			Case CM_COMMAND
				If Message.wParamHi = BN_CLICKED Then
					If OnClick Then OnClick(This)
				End If
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	Operator GroupBox.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Constructor GroupBox
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
			#endif
			.Width       = 121
			.Height      = 51
		End With
	End Constructor
	
	Destructor GroupBox
	End Destructor
End Namespace
