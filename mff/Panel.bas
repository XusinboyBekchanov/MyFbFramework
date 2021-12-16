﻿'###############################################################################
'#  Panel.bi                                                                   #
'#  This file is part of MyFBFramework                                         #
'#  Authors: Nastase Eodor, Xusinboy Bekchanov, Liu XiaLin                     #
'#  Based on:                                                                  #
'#   TPanel.bi                                                                 #
'#   FreeBasic Windows GUI ToolKit                                             #
'#   Copyright (c) 2007-2008 Nastase Eodor                                     #
'#   Version 1.0.0                                                             #
'#  Updated and added cross-platform                                           #
'#  by Xusinboy Bekchanov(2018-2019)  Liu XiaLin                               #
'###############################################################################

#include once "Panel.bi"
'#Include Once "Canvas.bi"

Namespace My.Sys.Forms
	Private Function Panel.ReadProperty(ByRef PropertyName As String) As Any Ptr
		Select Case LCase(PropertyName)
		Case "tabindex": Return @FTabIndex
		Case Else: Return Base.ReadProperty(PropertyName)
		End Select
		Return 0
	End Function
	
	Private Function Panel.WriteProperty(ByRef PropertyName As String, Value As Any Ptr) As Boolean
		If Value = 0 Then
			Select Case LCase(PropertyName)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		Else
			Select Case LCase(PropertyName)
			Case "tabindex": TabIndex = QInteger(Value)
			Case Else: Return Base.WriteProperty(PropertyName, Value)
			End Select
		End If
		Return True
	End Function
	
	Private Property Panel.TabIndex As Integer
		Return FTabIndex
	End Property
	
	Private Property Panel.TabIndex(Value As Integer)
		ChangeTabIndex Value
	End Property
	
	Private Property Panel.TabStop As Boolean
		Return FTabStop
	End Property
	
	Private Property Panel.TabStop(Value As Boolean)
		ChangeTabStop Value
	End Property
	
	Private Property Panel.Text ByRef As WString
		Return WGet(FText)
	End Property
	
	Private Property Panel.Text(ByRef Value As WString)
		Base.Text = Value
	End Property
		
	Private Property Panel.BevelInner As Integer
		Return FBevelInner
	End Property
	
	Private Property Panel.BevelInner(Value As Integer)
		FBevelInner = Value
		Invalidate
	End Property
	
	Private Property Panel.BevelOuter As Integer
		Return FBevelOuter
	End Property
	
	Private Property Panel.BevelOuter(Value As Integer)
		FBevelOuter = Value
		Invalidate
	End Property
	
	Private Property Panel.BevelWidth As Integer
		Return FBevelWidth
	End Property
	
	Private Property Panel.BevelWidth(Value As Integer)
		FBevelWidth = Value
		Invalidate
	End Property
	
	Private Property Panel.BorderWidth As Integer
		Return FBorderWidth
	End Property
	
	Private Property Panel.BorderWidth(Value As Integer)
		FBorderWidth = Value
		Invalidate
	End Property
	
	#ifdef __USE_WINAPI__
		Private Sub Panel.HandleIsAllocated(ByRef Sender As Control)
			If Sender.Child Then
				With QPanel(Sender.Child)
				End With
			End If
		End Sub
		
		Private Sub Panel.WndProc(ByRef Message As Message)
		End Sub
	#endif
	Private Sub Panel.ProcessMessage(ByRef Message As Message)
		#ifdef __USE_WINAPI__
			Select Case Message.Msg
			Case WM_ERASEBKGND
				If OnPaint Then OnPaint(This, Canvas)
			Case WM_PAINT, WM_Create
				Dim As Integer W,H
				Dim As HDC Dc, memDC
				Dim As HBITMAP Bmp
				Dim As ..Rect R, RFrame
				GetClientRect Handle, @R
				Dc = GetDC(Handle)
				If DoubleBuffered Then
					MemDC = CreateCompatibleDC(DC)
					Bmp   = CreateCompatibleBitmap(DC, R.Right, R.Bottom)
					SelectObject(MemDc, Bmp)
					'SendMessage(Handle, WM_ERASEBKGND, CInt(MemDC), CInt(MemDC))
					FillRect memDc, @R, This.Brush.Handle
					SetBkMode(memDC, TRANSPARENT)
					H = Canvas.TextHeight("Wg")
					W = Canvas.TextWidth(Text)
					SetBkColor(memDC, OPAQUE)
					
					'Canvas.TextOut((R.Right - W)/2,(R.Bottom - H)/2,Text,Font.Color,-1)
					If Text <> "" Then 'David Change
'						RFrame=R
'						'InflateRect(@RFrame, -1, -1)
'						RFrame.Top=R.Top+H/2
'						DoRect(RFrame,clScrollBar,clScrollBar)'cl3DDkShadow clBtnShadow
'						Canvas.Pen.Color = This.BackColor
'						Canvas.Pen.Size = 3
'						Canvas.Line(8,RFrame.Top-1,w+10,RFrame.Top-1)
'						Canvas.TextOut(10,0,Text,clWindowText,-1) 'David Change
					Else
						Frame3D(*Cast(My.Sys.Drawing.Rect Ptr, @R), FBorderWidth)
					End If
					If FBevelInner <> bvNone Then
						AdjustColors(FBevelInner)
						Frame3D(*Cast(My.Sys.Drawing.Rect Ptr, @R), FBevelWidth)
					End If
					Frame3D(*Cast(My.Sys.Drawing.Rect Ptr, @R), FBorderWidth)
					If FBevelOuter <> bvNone Then
						AdjustColors(FBevelOuter)
						Frame3D(*Cast(My.Sys.Drawing.Rect Ptr, @R), FBevelWidth)
					End If
					Canvas.HandleSetted = True
					Canvas.Handle = MemDC
					If OnPaint Then OnPaint(This, Canvas)
					Canvas.HandleSetted = False
					BitBlt(DC, 0, 0, R.Right, R.Bottom, MemDC, 0, 0, SRCCOPY)
					DeleteObject(Bmp)
					DeleteDC(MemDC)
				Else
					SetBKMode Dc, TRANSPARENT
					FillRect Dc, @R, This.Brush.Handle
					SetBKColor Dc, OPAQUE
					H = Canvas.TextHeight("Wg")
					W = Canvas.TextWidth(Text)
					'Canvas.TextOut((R.Right - W)/2,(R.Bottom - H)/2,Text,Font.Color,-1)
					If Text<>"" Then 'David Change
'						RFrame=R
'						InflateRect(@RFrame, -1, -1)
'						RFrame.Top=R.Top+H/2
'						DoRect(RFrame,clScrollBar,clScrollBar)'cl3DDkShadow clBtnShadow
'						Canvas.Pen.Color = This.BackColor
'						Canvas.Pen.Size = 3
'						Canvas.Line(8,RFrame.Top-1,w+10,RFrame.Top-1)
'						Canvas.Pen.Size = 1
'						Canvas.TextOut(10,0,Text,clWindowText,-1) 'David Change
					Else
						Frame3D(*Cast(My.Sys.Drawing.Rect Ptr, @R), FBorderWidth)
					End If
					If FBevelInner <> bvNone Then
						AdjustColors(FBevelInner)
						Frame3D(*Cast(My.Sys.Drawing.Rect Ptr, @R), FBevelWidth)
					End If
					Frame3D(*Cast(My.Sys.Drawing.Rect Ptr, @R), FBorderWidth)
					If FBevelOuter <> bvNone Then
						AdjustColors(FBevelOuter)
						Frame3D(*Cast(My.Sys.Drawing.Rect Ptr, @R), FBevelWidth)
					End If
					Canvas.Handle = Dc
					If OnPaint Then OnPaint(This, Canvas)
				End If
				ReleaseDC Handle, Dc
				Message.Result = 0
				Exit Sub
			End Select
		#endif
		Base.ProcessMessage(Message)
	End Sub
	
	#ifdef __USE_WINAPI__
		Private Sub Panel.AdjustColors(FBevel As Integer)
			FTopColor = GetSysColor(COLOR_BTNHIGHLIGHT)
			If FBevel = bvLowered Then FTopColor = GetSysColor(COLOR_BTNSHADOW)
			FBottomColor = GetSysColor(COLOR_BTNSHADOW)
			If FBevel = bvLowered Then FBottomColor = GetSysColor(COLOR_BTNHIGHLIGHT)
		End Sub
		
		Private Sub Panel.DoRect(R As My.Sys.Drawing.Rect, tTopColor As Integer = GetSysColor(COLOR_BTNSHADOW), tBottomColor As Integer = GetSysColor(COLOR_BTNSHADOW))
			Canvas.Pen.Color = FTopColor
			Canvas.Line(R.Left, R.Top, R.Right, R.Top)
			Canvas.Line(R.Left, R.Top, R.Left, R.Bottom)
			Canvas.Pen.Color = FBottomColor
			Canvas.Line(R.Right, R.Top, R.Right, R.Bottom)
			Canvas.Line(R.Left, R.Bottom, R.Right, R.Bottom)
		End Sub
		
		Private Sub Panel.Frame3D(R As My.Sys.Drawing.RECT, AWidth As Integer)
			Canvas.Pen.Size = 1
			R.Bottom -= 1
			R.Right  -= 1
			While AWidth > 0
				AWidth -= 1
				DoRect(R)
				InflateRect(Cast(..Rect Ptr, @R), -1, -1)
			Wend
			R.Bottom += 1
			R.Right  += 1
		End Sub
	#endif
	
	Property Panel.Visible As Boolean
		Return Base.Visible
	End Property
	
	Property Panel.Visible(Value As Boolean)
		Base.Visible = Value
	End Property
	
	Private Operator Panel.Cast As Control Ptr
		Return Cast(Control Ptr, @This)
	End Operator
	
	Private Sub Panel.CreateWnd
		Base.CreateWnd
		#ifdef __USE_JNI__
			layoutview = FHandle
		#endif
	End Sub
	
	Private Constructor Panel
		With This
			#ifdef __USE_GTK__
				'widget = gtk_scrolled_window_new(null, null)
				'widget = gtk_layout_new(null, null)
				'widget = gtk_box_new(GTK_ORIENTATION_VERTICAL, 0)
				'gtk_container_add(GTK_CONTAINER(widget), box)
				widget = gtk_layout_new(null, null)
				'gtk_container_add(GTK_CONTAINER(widget), layoutwidget)
				'gtk_box_pack_end(Gtk_Box(widget), layoutwidget, true, true, 0)
				
				'gtk_widget_set_events(widget, _
				'         GDK_EXPOSURE_MASK Or _
				'         GDK_SCROLL_MASK Or _
				'        GDK_STRUCTURE_MASK Or _
				'       GDK_KEY_PRESS_MASK Or _
				'      GDK_KEY_RELEASE_MASK Or _
				'     GDK_FOCUS_CHANGE_MASK Or _
				'    GDK_LEAVE_NOTIFY_MASK Or _
				'   GDK_BUTTON_PRESS_MASK Or _
				'  GDK_BUTTON_RELEASE_MASK Or _
				' GDK_POINTER_MOTION_MASK Or _
				'GDK_POINTER_MOTION_HINT_MASK)
				
				'widget = gtk_fixed_new()
				'gtk_scrolled_window_set_policy(gtk_scrolled_window(widget), GTK_POLICY_EXTERNAL, GTK_POLICY_EXTERNAL)
				'gtk_scrolled_window_set_propagate_natural_width(gtk_scrolled_window(widget), true)
				'widget = gtk_fixed_new()
				.RegisterClass "Panel", @This
			#endif
			FBorderWidth = 0
			'FBevelWidth=2
			'PopupMenu.Ctrl = This
			Canvas.Ctrl    = @This
			.Child       = @This
			#ifdef __USE_WINAPI__
				.RegisterClass "Panel"
				.ChildProc   = @WndProc
				.ExStyle     = 0
				.Style       = WS_CHILD
				.BackColor       = GetSysColor(COLOR_BTNFACE)
				.OnHandleIsAllocated = @HandleIsAllocated
			#elseif defined(__USE_JNI__)
				WLet(FClassAncestor, "android/widget/AbsoluteLayout")
			#endif
			FTabIndex          = -1
			WLet(FClassName, "Panel")
			.Width       = 121
			.Height      = 41
		End With
	End Constructor
	
	Private Destructor Panel
		#ifdef __USE_WINAPI__
			UnregisterClass "Panel", GetModuleHandle(NULL)
		#endif
	End Destructor
End Namespace


